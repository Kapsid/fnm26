// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Serbian (`sr`).
class AppLocalizationsSr extends AppLocalizations {
  AppLocalizationsSr([String locale = 'sr']) : super(locale);

  @override
  String get matchPreviewTitle => 'НАЈАВА УТАКМИЦЕ';

  @override
  String get matchKickOff => 'Почетни ударац';

  @override
  String get matchTactics => 'Тактика';

  @override
  String get matchYourXi => 'ТВОЈА ПОСТАВА';

  @override
  String get matchHeadToHead => 'МЕЂУСОБНИ ОДНОС';

  @override
  String matchCouldNotLoad(String error) {
    return 'Утакмица није могла да се учита.\n$error';
  }

  @override
  String get matchNoUpcoming => 'Нема предстојеће утакмице.';

  @override
  String get matchUnknownNation => 'Непознато';

  @override
  String get matchH2hFirstMeeting => 'Први сусрет икад';

  @override
  String get matchH2hYouLead => 'Водиш у међусобним сусретима';

  @override
  String matchH2hOppEdge(String opponent) {
    return 'Предност: $opponent';
  }

  @override
  String get matchH2hEven => 'Нерешено';

  @override
  String matchH2hMet(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count сусрета',
      few: '$count сусрета',
      one: '$count сусрет',
    );
    return '$_temp0';
  }

  @override
  String get matchH2hWon => 'Победе';

  @override
  String get matchH2hDrawn => 'Нерешено';

  @override
  String get matchH2hLost => 'Порази';

  @override
  String get matchDossierTitle => 'Скаутски извештај';

  @override
  String get matchDossierForm => 'ФОРМА';

  @override
  String get matchDossierNoGames => 'Нема недавних утакмица';

  @override
  String get matchDossierKeyMen => 'КЉУЧНИ ИГРАЧИ';

  @override
  String get matchDossierHowTheyPlay => 'КАКО ИГРАЈУ';

  @override
  String matchScoutFormation1(String formation) {
    return 'Обично играју у формацији $formation.';
  }

  @override
  String matchScoutFormation2(String formation) {
    return 'Њихова уобичајена формација је $formation.';
  }

  @override
  String matchScoutFormation3(String formation) {
    return 'Најчешће се постављају у $formation.';
  }

  @override
  String get matchScoutStrengthPressing => 'Притискају високо и лове лопту.';

  @override
  String get matchScoutStrengthDirect =>
      'Играју директно и брзо шаљу лопту напред.';

  @override
  String get matchScoutStrengthPossession =>
      'Добро чувају лопту и стрпљиво граде напад.';

  @override
  String get matchScoutStrengthCounter => 'Чекају ниско и брзо крећу у контре.';

  @override
  String get matchScoutStrengthDeepDefence =>
      'Бране се дубоко и тешко их је пробити.';

  @override
  String get matchScoutStrengthWide => 'Развлаче игру и нападају по крилима.';

  @override
  String get matchScoutStrengthAttacking =>
      'Воле да преузму иницијативу и иду на противника.';

  @override
  String get matchScoutStrengthQuickForwards =>
      'Њихови нападачи су брзи и радо трче иза одбране.';

  @override
  String get matchScoutStrengthPassingMidfield =>
      'Њихов везни ред добро додаје лопту.';

  @override
  String get matchScoutStrengthHardRunning =>
      'Њихов везни ред може да трчи целу утакмицу.';

  @override
  String get matchScoutStrengthSetPieces => 'Опасни су из прекида.';

  @override
  String get matchScoutStrengthQuickDefence =>
      'Њихова одбрана је брза и тешко је проћи иза ње.';

  @override
  String get matchScoutStrengthNone =>
      'У њиховој игри ништа посебно не одскаче.';

  @override
  String get matchScoutWeakSpaceBehind =>
      'Њихова висока линија оставља простор иза леђа за дугу лопту.';

  @override
  String get matchScoutWeakPressedBuildUp =>
      'Високи пресинг може да поремети њихову спору изградњу напада.';

  @override
  String get matchScoutWeakDeepBlock =>
      'Буди стрпљив: овако низак блок може да се разбије.';

  @override
  String get matchScoutWeakLongBall =>
      'Повуци линију дубље и њихове дуге лопте неће имати куда.';

  @override
  String get matchScoutWeakSlowDefence =>
      'Њиховим одбрамбеним играчима недостаје брзине, па шаљи играче иза њихових леђа.';

  @override
  String get matchScoutWeakAerial => 'Делују несигурно када бране прекиде.';

  @override
  String get matchScoutWeakPoorPassing =>
      'Њихов везни ред тешко се додавањем извлачи из притиска.';

  @override
  String get matchScoutWeakTiringMidfield =>
      'Њиховом везном реду недостаје снаге за дуготрајан пресинг.';

  @override
  String get matchScoutWeakBluntAttack =>
      'Њиховим нападачима недостаје брзине.';

  @override
  String get matchScoutApproachTakeTheGame =>
      'Против тебе очекуј да преузму иницијативу.';

  @override
  String get matchScoutApproachEven =>
      'Против тебе очекуј тесну и изједначену утакмицу.';

  @override
  String get matchScoutApproachSitDeep =>
      'Против тебе очекуј да буду опрезни и траже контру.';

  @override
  String get matchScoutLeaningAttacking =>
      'Издалека делују као нападачки настројен тим.';

  @override
  String get matchScoutLeaningCautious => 'Издалека делују као опрезан тим.';

  @override
  String get matchScoutLeaningUnclear =>
      'Издалека је тешко рећи како воле да играју.';

  @override
  String get matchScoutHireHint =>
      'Запосли главног скаута да сазнаш како играју.';

  @override
  String matchCouldNotContinue(String error) {
    return 'Наставак није успео: $error';
  }

  @override
  String get matchSkipToFullTime => 'Прескочи до краја утакмице';

  @override
  String get matchStatShots => 'Шутеви';

  @override
  String get matchStatGoals => 'Голови';

  @override
  String get matchStatYellowCards => 'Жути';

  @override
  String get matchStatRedCards => 'Црвени';

  @override
  String get matchMomentum => 'ИНИЦИЈАТИВА';

  @override
  String get matchSwingAtk => 'НАП';

  @override
  String get matchSwingDef => 'ОДБ';

  @override
  String ceremonyWorldCupYear(int year) {
    return 'СВЕТСКО ПРВЕНСТВО $year';
  }

  @override
  String get ceremonyFinalsAreHere => 'ЗАВРШНИЦА ЈЕ ПОЧЕЛА';

  @override
  String ceremonyHostedBy(String hosts) {
    return 'ДОМАЋИН  $hosts';
  }

  @override
  String get ceremonyHostTbc => 'ДОМАЋИН ЈОШ НИЈЕ ПОТВРЂЕН';

  @override
  String get matchHalfTime => 'ПОЛУВРЕМЕ';

  @override
  String matchHalfTimeScore(int home, int away) {
    return 'Полувреме $home : $away';
  }

  @override
  String resultAggregate(int home, int away) {
    return 'укупно $home-$away';
  }

  @override
  String get matchContinue => 'Настави';

  @override
  String get matchContinuing => 'Настављам…';

  @override
  String matchTacticsWithSubs(int used, int max) {
    return 'Тактика · $used/$max изм.';
  }

  @override
  String matchTiredCount(int count) {
    return 'УМОРНИ ×$count';
  }

  @override
  String get matchTacticsLabel => 'ТАКТИКА';

  @override
  String get teamOverallOverTime => 'УКУПНА ОЦЕНА КРОЗ ВРЕМЕ';

  @override
  String get teamOverall => 'Укупна оцена';

  @override
  String get teamTalkHeading => 'ГОВОР У СВЛАЧИОНИЦИ';

  @override
  String get teamTalkPrompt => 'Одреди тон за друго полувреме.';

  @override
  String get teamTalkCalmLabel => 'Мирне главе';

  @override
  String get teamTalkCalmBlurb => 'Смири тим. Мали подстицај у свим линијама.';

  @override
  String get teamTalkEncourageLabel => 'Охрабри';

  @override
  String get teamTalkEncourageBlurb => 'Идите напред и играјте на победу.';

  @override
  String get teamTalkDemandMoreLabel => 'Тражи више';

  @override
  String get teamTalkDemandMoreBlurb => 'Дајте све од себе. Нападајте жестоко.';

  @override
  String get teamTalkPraiseLabel => 'Збијени редови';

  @override
  String get teamTalkPraiseBlurb =>
      'Останите компактни и чувајте оно што имате.';

  @override
  String get teamTalkBelieveLabel => 'Веруј';

  @override
  String get teamTalkBelieveBlurb =>
      'Верујте у себе. Подстицај на оба краја терена.';

  @override
  String get teamTalkFocusLabel => 'Останите будни';

  @override
  String get teamTalkFocusBlurb =>
      'Потпуна концентрација. Закључајте утакмицу.';

  @override
  String get teamTalkUrgencyLabel => 'Осећај хитности';

  @override
  String get teamTalkUrgencyBlurb =>
      'Притисните одмах. Све или ништа, али отвара простор.';

  @override
  String get teamTalkReassureLabel => 'Без притиска';

  @override
  String get teamTalkReassureBlurb => 'Смирите нерве и држите распоред.';

  @override
  String get commonRetry => 'Покушај поново';

  @override
  String get commonSomethingWentWrong => 'Нешто је пошло наопако';

  @override
  String get commonCrashBox =>
      'Овде је нешто пошло наопако.\nДетаљи су у Подешавања → Дијагностика.';

  @override
  String hubCouldNotAdvance(String error) {
    return 'Свет није могао да се помери даље: $error';
  }

  @override
  String get settingsDiagnosticsTitle => 'Дијагностика';

  @override
  String get settingsDiagnosticsBlurb =>
      'Грешке забележене на овом уређају. Ништа се никуда не шаље.';

  @override
  String get settingsContactTitle => 'Контакт';

  @override
  String get settingsContactCopied => 'Адреса је копирана.';

  @override
  String get settingsCommunityTitle => 'Заједница';

  @override
  String get settingsDiscordSubtitle => 'Придружи се заједници';

  @override
  String get settingsLinkCopied => 'Линк је копиран.';

  @override
  String get diagnosticsEmpty =>
      'Нема забележених грешака. Тако и треба да буде.';

  @override
  String get diagnosticsCopy => 'Копирај';

  @override
  String get diagnosticsCopied => 'Записник је копиран у привремену меморију.';

  @override
  String get diagnosticsClear => 'Обриши';

  @override
  String get navHub => 'Почетна';

  @override
  String get navSquad => 'Састав';

  @override
  String get navStandings => 'Табела';

  @override
  String get navCareers => 'Моја каријера';

  @override
  String get settingsTitle => 'ПОДЕШАВАЊА';

  @override
  String get settingsSoundHapticsTitle => 'Звук и вибрација';

  @override
  String get settingsSoundHapticsBlurb =>
      'Вибрација и кратак тон код голова, почетног ударца и краја утакмице.';

  @override
  String get settingsMatchSoundTitle => 'Звук стадиона';

  @override
  String get settingsMatchSoundBlurb =>
      'Публика и судијска пиштаљка током утакмица.';

  @override
  String get settingsMatchSoundVolume => 'Јачина звука';

  @override
  String get settingsLanguageTitle => 'Језик';

  @override
  String get settingsLanguageBlurb =>
      'Изабери језик апликације или прати уређај.';

  @override
  String get settingsLanguageSystem => 'Систем';

  @override
  String get settingsTextSizeTitle => 'Величина текста';

  @override
  String get settingsTextSizeBlurb => 'Повећај текст ако се тешко чита.';

  @override
  String get settingsTextSizeNormal => 'Нормална';

  @override
  String get settingsTextSizeLarge => 'Велика';

  @override
  String get settingsTextSizeLarger => 'Већа';

  @override
  String get matchPreviewAllMeetings => 'Сви сусрети';

  @override
  String get recordsMeetings => 'СУСРЕТИ';

  @override
  String get recordsLegends => 'ЛЕГЕНДЕ';

  @override
  String get recordsAllTimeXi => 'НАЈБОЉА ПОСТАВА СВИХ ВРЕМЕНА';

  @override
  String get recordsHallOfFame => 'КУЋА СЛАВНИХ';

  @override
  String get recordsAllTimeWorld => 'СВЕТСКА ИСТОРИЈА';

  @override
  String get recordsAllTimeTopScorers => 'НАЈБОЉИ СТРЕЛЦИ СВИХ ВРЕМЕНА';

  @override
  String get recordsMostCapped => 'НАЈВИШЕ НАСТУПА';

  @override
  String get recordsMostWcStarts => 'НАЈВИШЕ СТАРТОВА НА СП';

  @override
  String get recordsMostTournaments => 'НАЈВИШЕ ОДИГРАНИХ ТУРНИРА';

  @override
  String get recordsRecordBook => 'КЊИГА РЕКОРДА';

  @override
  String get recordsHeadToHead => 'МЕЂУСОБНИ ОДНОС';

  @override
  String get recordsFiercestRival => 'НАЈЉУЋИ РИВАЛ';

  @override
  String get recordsMostCaps => 'НАЈВИШЕ НАСТУПА';

  @override
  String get recordsTopScorers => 'НАЈБОЉИ СТРЕЛЦИ';

  @override
  String get recordsMostAssists => 'НАЈВИШЕ АСИСТЕНЦИЈА';

  @override
  String get recordsYourRecord => 'ТВОЈ УЧИНАК';

  @override
  String get callUpHome => 'КОД КУЋЕ';

  @override
  String get callUpAway => 'У ГОСТИМА';

  @override
  String get recordsHome => 'КОД КУЋЕ';

  @override
  String get recordsAway => 'У ГОСТИМА';

  @override
  String get recordsActive => 'АКТИВАН';

  @override
  String get recordsStillActive => 'Још игра';

  @override
  String get recordsAvg => 'прос.';

  @override
  String get recordsSelect => 'Изабери';

  @override
  String get recordsVs => 'против';

  @override
  String get recordsDraws => 'Нерешено';

  @override
  String get recordsGoalsLabel => 'Голови';

  @override
  String get recordsBestFinish => 'Најбољи пласман';

  @override
  String get recordsNoFinalsYet => 'Још нема наступа у завршници';

  @override
  String get recordsLongestUnbeaten => 'Најдужи низ без пораза';

  @override
  String get recordsBiggestWin => 'Највећа победа';

  @override
  String get recordsTileMatches => 'Утакмице';

  @override
  String get recordsTileWins => 'Победе';

  @override
  String get recordsTileTrophies => 'Трофеји';

  @override
  String recordsWinSharePercent(String pct) {
    return '$pct%';
  }

  @override
  String recordsTrophyLatest(String competition, String year) {
    return '$competition $year';
  }

  @override
  String get recordsNoTrophiesYet => 'Још ниједан';

  @override
  String get recordsBiggestDefeat => 'Најтежи пораз';

  @override
  String get recordsRecordHolders => 'Рекордери';

  @override
  String get recordsMostCleanSheets => 'НАЈВИШЕ УТАКМИЦА БЕЗ ПРИМЉЕНОГ ГОЛА';

  @override
  String get recordsSeeAllMeetings => 'Прикажи све сусрете';

  @override
  String get recordsSaveNotFound => 'Сачувана игра није пронађена.';

  @override
  String get recordsNoMatches => 'Нема резултата.';

  @override
  String get recordsSearchPlayerOrNation => 'Тражи играча или земљу';

  @override
  String get recordsSearchNation => 'Тражи земљу';

  @override
  String get recordsPickTwoDifferent => 'Изабери две различите земље.';

  @override
  String get recordsPlayToBuildRecord =>
      'Одиграј неколико утакмица и овде ће се градити твој учинак против сваког противника.';

  @override
  String get recordsTapOpponent => 'Додирни противника за потпуни преглед.';

  @override
  String get recordsEdgeUpperHand => 'Имаш предност';

  @override
  String get recordsEdgeTheirNumber => 'Они су ти баук';

  @override
  String get recordsEdgeEven => 'Нерешено';

  @override
  String get recordsAllTimeWorldSubtitle =>
      'Светски стрелци и рекордери по наступима, свака земља';

  @override
  String get recordsHeadToHeadSubtitle =>
      'Упореди историјски учинак било које две земље';

  @override
  String get recordsLegendsSubtitle =>
      'Најбоља постава свих времена и кућа славних';

  @override
  String get recordsUnitGoals => 'голова';

  @override
  String get recordsUnitCaps => 'наступа';

  @override
  String get recordsUnitStarts => 'стартова';

  @override
  String get recordsUnitCups => 'турнира';

  @override
  String get recordsUnitAssists => 'асистенција';

  @override
  String recordsCapsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count наступа',
      few: '$count наступа',
      one: '$count наступ',
    );
    return '$_temp0';
  }

  @override
  String recordsGoalsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count голова',
      few: '$count гола',
      one: '$count гол',
    );
    return '$_temp0';
  }

  @override
  String recordsAssistsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count асистенција',
      few: '$count асистенције',
      one: '$count асистенција',
    );
    return '$_temp0';
  }

  @override
  String recordsMotmCount(int count) {
    return '$count × играч утакмице';
  }

  @override
  String recordsMatchesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count утакмица',
      few: '$count утакмице',
      one: '$count утакмица',
    );
    return '$_temp0';
  }

  @override
  String recordsMeetingsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count сусрета',
      few: '$count сусрета',
      one: '$count сусрет',
    );
    return '$_temp0';
  }

  @override
  String recordsCodeWins(String code) {
    return 'Победе: $code';
  }

  @override
  String recordsMeetingsWdl(int meetings, int wins, int draws, int losses) {
    String _temp0 = intl.Intl.pluralLogic(
      meetings,
      locale: localeName,
      other: '$meetings сусрета',
      few: '$meetings сусрета',
      one: '$meetings сусрет',
    );
    return '$_temp0 · $winsП $drawsН $lossesИ';
  }

  @override
  String recordsWdl(int wins, int draws, int losses) {
    return '$winsП $drawsН $lossesИ';
  }

  @override
  String recordsRivalLine(int meetings, String record, String edge) {
    String _temp0 = intl.Intl.pluralLogic(
      meetings,
      locale: localeName,
      other: '$meetings сусрета',
      few: '$meetings сусрета',
      one: '$meetings сусрет',
    );
    return '$_temp0 · $record · $edge';
  }

  @override
  String recordsNeverMet(String a, String b) {
    return '$a и $b се у овој игри још никад нису састали.';
  }

  @override
  String tacticsSentOffNote(String names) {
    return 'Искључени: $names. Нема замене, па играш са играчем мање.';
  }

  @override
  String tacticsNeedFitPlayers(int required, int have) {
    return 'Потребно $required расположивих ($have спремних)';
  }

  @override
  String tacticsMissesOfCamp(int missed, int total) {
    return 'Пропушта $missed/$total';
  }

  @override
  String get tacticsOutForWholeCamp => 'Одсутан током целог окупљања';

  @override
  String get rankingCentreOnMe => 'Центрирај на моју земљу';

  @override
  String get recordsAfterExtraTime => 'после прод.';

  @override
  String recordsOnPenalties(int a, int b) {
    return '$a–$b пен.';
  }

  @override
  String recordsVersus(String a, String b) {
    return '$a против $b';
  }

  @override
  String recordsPlayedScore(int played, int gf, int ga) {
    return '$played одиграно · $gf–$ga';
  }

  @override
  String recordsBiggestWinValue(int gf, int ga, String opp) {
    return '$gf–$ga против $opp';
  }

  @override
  String recordsCouldNotLoad(String error) {
    return 'Учитавање није успело.\n$error';
  }

  @override
  String recordsCouldNotLoadLegends(String error) {
    return 'Легенде нису могле да се учитају.\n$error';
  }

  @override
  String recordsCouldNotLoadRecords(String error) {
    return 'Рекорди нису могли да се учитају.\n$error';
  }

  @override
  String recordsCouldNotLoadNations(String error) {
    return 'Земље нису могле да се учитају.\n$error';
  }

  @override
  String recordsCouldNotLoadYourRecord(String error) {
    return 'Твој учинак није могао да се учита.\n$error';
  }

  @override
  String recordsCouldNotLoadRecord(String error) {
    return 'Рекорд није могао да се учита.\n$error';
  }

  @override
  String recordsNoLegends(String nation) {
    return 'Још нема легенди. Одиграј неколико кампања и овде ће се појавити великани репрезентације: $nation.';
  }

  @override
  String recordsGreatestSide(String nation) {
    return 'Најбољи тим који је репрезентација $nation икад могла да изведе.';
  }

  @override
  String get recordsNoWorldHistory =>
      'Свет још нема историју. Одиграј неколико кампања и овде ће се појавити великани свих времена.';

  @override
  String recordsPlayToWriteHistory(String nation) {
    return 'Одиграј неколико утакмица и почни да пишеш историју: $nation.';
  }

  @override
  String get tacticsLineGk => 'ГК';

  @override
  String get tacticsLineDef => 'ОДБ';

  @override
  String get tacticsLineMid => 'ВЕЗ';

  @override
  String get tacticsLineFwd => 'НАП';

  @override
  String get tacticsGoalkeepers => 'ГОЛМАНИ';

  @override
  String get tacticsDefenders => 'ОДБРАМБЕНИ';

  @override
  String get tacticsMidfielders => 'ВЕЗНИ ИГРАЧИ';

  @override
  String get tacticsForwards => 'НАПАДАЧИ';

  @override
  String get tacticsCallUpsTitle => 'ПОЗИВИ';

  @override
  String tacticsPickAtLeastPlayers(int min) {
    return 'Изабери најмање $min играча.';
  }

  @override
  String tacticsCouldNotLoadSquad(String error) {
    return 'Састав није могао да се учита.\n$error';
  }

  @override
  String get tacticsNoSquad => 'Нема састава.';

  @override
  String tacticsSquadCount(int count, int max) {
    return 'САСТАВ · $count/$max';
  }

  @override
  String tacticsMinMax(int min, int max) {
    return 'Мин $min · Макс $max';
  }

  @override
  String get tacticsBestQuality => 'Најбољи квалитет';

  @override
  String get tacticsPreviousSquad => 'Претходни састав';

  @override
  String get tacticsSquadLockedBack => 'Назад (састав закључан)';

  @override
  String get tacticsConfirmSquad => 'Потврди састав';

  @override
  String tacticsSquadFullMax(int max) {
    return 'Састав је пун (макс $max)';
  }

  @override
  String get tacticsSquadLocked => 'САСТАВ ЗАКЉУЧАН';

  @override
  String get tacticsNominationOpen => 'ПРИЈАВА ЈЕ ОТВОРЕНА. ИЗАБЕРИ САСТАВ';

  @override
  String get tacticsSquadFixedBlurb =>
      'Овај састав је утврђен за утакмице испод. Поново га изабери пре следећег рока за пријаву.';

  @override
  String get tacticsSquadWillPlayBlurb =>
      'Овај састав ће играти утакмице испод.';

  @override
  String get tacticsUnknown => 'Непознато';

  @override
  String tacticsAgeValue(int age, String value) {
    return 'Године $age · $value';
  }

  @override
  String get tacticsFatigueExhausted => 'Исцрпљен';

  @override
  String get tacticsFatigueTired => 'Уморан';

  @override
  String get tacticsFatigueMatchLegs => 'Утакмица у ногама';

  @override
  String tacticsTooManySubs(int max) {
    return 'Превише измена (макс $max).';
  }

  @override
  String tacticsMinuteTitle(int minute) {
    return 'ТАКТИКА · $minute\'';
  }

  @override
  String get tacticsApply => 'ПРИМЕНИ';

  @override
  String get tacticsTabLineupSubs => 'ПОСТАВА И ИЗМЕНЕ';

  @override
  String get tacticsTabTactics => 'ТАКТИКА';

  @override
  String get squadLineKeepers => 'ГОЛМАНИ';

  @override
  String get squadLineDefenders => 'ОДБРАНА';

  @override
  String get squadLineMidfielders => 'ВЕЗНИ РЕД';

  @override
  String get squadLineForwards => 'НАПАД';

  @override
  String get squadStatXiRating => 'Оцена поставе';

  @override
  String get squadStatAvgAge => 'Прос. старост';

  @override
  String get squadStatSize => 'Састав';

  @override
  String get squadStatUnavailable => 'Одсутни';

  @override
  String get squadDepthTitle => 'ДУБИНА ПО ЛИНИЈАМА';

  @override
  String squadAgeShort(int age) {
    return '$age г.';
  }

  @override
  String get tacticsTabOtherPositions => 'ДРУГА МЕСТА';

  @override
  String get tacticsOutOfPositionNote => 'Ван позиције';

  @override
  String get tacticsNobodyElse => 'Нема кога другог да се испроба.';

  @override
  String get tacticsPickSomebodyFirst =>
      'Изабери ко излази, а остатак клупе појавиће се овде, са оценом коју би имали на овом месту.';

  @override
  String get tacticsTabSuitable => 'ОДГОВАРАЈУЋИ';

  @override
  String get tacticsTabOnPitch => 'НА ТЕРЕНУ';

  @override
  String tacticsSectionSuitable(int count) {
    return 'ОДГОВАРАЈУЋИ · $count';
  }

  @override
  String get tacticsNobodySuits =>
      'Нико са клупе природно не одговара овом месту, па су овде сви.';

  @override
  String tacticsSectionOnPitch(int count, int max) {
    return 'НА ТЕРЕНУ · $count/$max';
  }

  @override
  String tacticsSectionAvailable(int count) {
    return 'РАСПОЛОЖИВИ · $count';
  }

  @override
  String get tacticsRowStarted => 'Почео';

  @override
  String tacticsRowCameOn(int minute) {
    return 'Ушао у $minute\'';
  }

  @override
  String get tacticsRowSubstitute => 'Ушао';

  @override
  String get tacticsEnergyLabel => 'ЕНЕРГИЈА';

  @override
  String tacticsPickReplacementFor(String name) {
    return 'Додирни замену за: $name, или га поново додирни да одустанеш.';
  }

  @override
  String get tacticsSlotLostToRedCard =>
      'Црвени картон ти је одузео ово место. Превуци саиграча овде да преместиш празнину.';

  @override
  String get tacticsSentOffShort => 'ИСКЉУЧЕН';

  @override
  String get tacticsFullBackLeft => 'Леви бек';

  @override
  String get tacticsFullBackRight => 'Десни бек';

  @override
  String get tacticsFullBackUp => 'Укључује се у напад';

  @override
  String get tacticsFullBackDown => 'Остаје позади';

  @override
  String get tacticsFullBackOff => 'Без упутства';

  @override
  String tacticsFullBackUpHint(String side) {
    return '$side: укључује се у напад. Мало више напада, мало више ризика.';
  }

  @override
  String tacticsFullBackDownHint(String side) {
    return '$side: остаје позади. Мало сигурније, мало мање напада.';
  }

  @override
  String tacticsFullBackOffHint(String side) {
    return '$side: без упутства, игра према плану тима.';
  }

  @override
  String tacticsFullBackSemantics(String side, String state) {
    return '$side, стрелица: $state';
  }

  @override
  String tacticsSubsUsed(int used, int max) {
    return 'ИЗМЕНЕ · $used/$max';
  }

  @override
  String get tacticsDragSubOn =>
      'Додирни играча на терену да га извадиш или задржи и превуци замену на њега.';

  @override
  String get tacticsNoSubs => 'Нема расположивих замена.';

  @override
  String get tacticsChooseShape => 'ИЗАБЕРИ ФОРМАЦИЈУ';

  @override
  String get tacticsFormation => 'ФОРМАЦИЈА';

  @override
  String get tacticsInstructions => 'УПУТСТВА';

  @override
  String get tacticsDrilling => 'УВЕЖБАНОСТ';

  @override
  String get tacticsDrillingUnplayed => 'НЕИГРАНО';

  @override
  String get tacticsDrillingNew => 'НОВО';

  @override
  String get tacticsDrillingSettling => 'УКЛАПА СЕ';

  @override
  String get tacticsDrillingDrilled => 'УИГРАНО';

  @override
  String get tacticsInstrMentality => 'Менталитет';

  @override
  String get tacticsInstrDefensive => 'Дефанзивно';

  @override
  String get tacticsInstrAttacking => 'Нападачки';

  @override
  String get tacticsInstrPressing => 'Пресинг';

  @override
  String get tacticsInstrLowBlock => 'Низак блок';

  @override
  String get tacticsInstrHighPress => 'Високи пресинг';

  @override
  String get tacticsInstrTempo => 'Темпо';

  @override
  String get tacticsInstrPatient => 'Стрпљиво';

  @override
  String get tacticsInstrFast => 'Брзо';

  @override
  String get tacticsInstrWidth => 'Ширина';

  @override
  String get tacticsInstrNarrow => 'Уско';

  @override
  String get tacticsInstrWide => 'Широко';

  @override
  String get tacticsInstrDefLine => 'Одбр. линија';

  @override
  String get tacticsInstrDefensiveLine => 'Одбрамбена линија';

  @override
  String get tacticsInstrDeep => 'Дубоко';

  @override
  String get tacticsInstrHigh => 'Високо';

  @override
  String get tacticsInstrDirectness => 'Директност';

  @override
  String get tacticsInstrPossession => 'Посед лопте';

  @override
  String get tacticsInstrDirect => 'Директно';

  @override
  String get tacticsPickGoalkeeper => 'ИЗАБЕРИ ГОЛМАНА';

  @override
  String get tacticsPickLeftBack => 'ИЗАБЕРИ ЛЕВОГ БЕКА';

  @override
  String get tacticsPickCentreBack => 'ИЗАБЕРИ ШТОПЕРА';

  @override
  String get tacticsPickRightBack => 'ИЗАБЕРИ ДЕСНОГ БЕКА';

  @override
  String get tacticsPickDefensiveMid => 'ИЗАБЕРИ ДЕФАНЗИВНОГ ВЕЗНОГ';

  @override
  String get tacticsPickCentralMid => 'ИЗАБЕРИ ЦЕНТРАЛНОГ ВЕЗНОГ';

  @override
  String get tacticsPickAttackingMid => 'ИЗАБЕРИ ОФАНЗИВНОГ ВЕЗНОГ';

  @override
  String get tacticsPickLeftMid => 'ИЗАБЕРИ ЛЕВОГ ВЕЗНОГ';

  @override
  String get tacticsPickRightMid => 'ИЗАБЕРИ ДЕСНОГ ВЕЗНОГ';

  @override
  String get tacticsPickLeftWing => 'ИЗАБЕРИ ЛЕВО КРИЛО';

  @override
  String get tacticsPickRightWing => 'ИЗАБЕРИ ДЕСНО КРИЛО';

  @override
  String get tacticsPickStriker => 'ИЗАБЕРИ НАПАДАЧА';

  @override
  String tacticsRoleOutOfPosition(String role) {
    return '$role · ван позиције';
  }

  @override
  String tacticsAgeOnly(int age) {
    return 'Године $age';
  }

  @override
  String tacticsRoleAge(String role, int age) {
    return '$role · Године $age';
  }

  @override
  String get tacticsOn => 'НА ТЕРЕНУ';

  @override
  String get tacticsSquad => 'САСТАВ';

  @override
  String get tacticsTabLineup => 'ПОСТАВА';

  @override
  String get tacticsTabInstructions => 'УПУТСТВА';

  @override
  String get tacticsTabRoles => 'УЛОГЕ';

  @override
  String get tacticsTabSetPieces => 'ПРЕКИДИ';

  @override
  String get tacticsTabRolesSetPieces => 'УЛОГЕ И ПРЕКИДИ';

  @override
  String get tacticsRolesSetPiecesBlurb =>
      'Дај сваком играчу из почетне поставе улогу. Додирни ознаку за пенал (⚽) или слободан ударац (▲) да одредиш извођача.';

  @override
  String get tacticsTooltipCallUps => 'Позиви';

  @override
  String get tacticsTooltipPresets => 'Шаблони тактике';

  @override
  String get tacticsTooltipInstructions => 'Упутства';

  @override
  String get tacticsNoTacticSet => 'Тактика није постављена.';

  @override
  String tacticsReplaceStarters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ЗАМЕНИ $count ИГРАЧА ИЗ ПОЧЕТНЕ ПОСТАВЕ',
      few: 'ЗАМЕНИ $count ИГРАЧА ИЗ ПОЧЕТНЕ ПОСТАВЕ',
      one: 'ЗАМЕНИ $count ИГРАЧА ИЗ ПОЧЕТНЕ ПОСТАВЕ',
    );
    return '$_temp0';
  }

  @override
  String tacticsPlayerOut(String name, String reason) {
    return '$name: $reason';
  }

  @override
  String get tacticsOut => 'Одсутан';

  @override
  String get tacticsTapSpotReplace =>
      'Додирни његово место на терену да изабереш замену.';

  @override
  String get tacticsTapOrDrag =>
      'Додирни играча да га замениш или га задржи и превуци да га преместиш.';

  @override
  String get tacticsPlayerRoles => 'УЛОГЕ ИГРАЧА';

  @override
  String get tacticsRolesBlurb =>
      'Дај играчу задатак: ловац на голове, плејмејкер, играч за дуге лопте. Одређује ко даје голове, а ко ствара.';

  @override
  String get tacticsSetPieceTakers => 'ИЗВОЂАЧИ ПРЕКИДА';

  @override
  String get tacticsSetPieceBlurb =>
      'Ко изводи пенале и прекиде, или препусти то најпогоднијем играчу.';

  @override
  String get tacticsTakerAuto => 'Аутоматски';

  @override
  String get tacticsTakerQuickPick => 'Најбољи извођачи';

  @override
  String get tacticsPenalties => 'Пенали';

  @override
  String get tacticsCornersFreeKicks => 'Корнери и слободни ударци';

  @override
  String get tacticsThrowIns => 'Убацивања из аута';

  @override
  String get tacticsThrowInStyle => 'Стил убацивања';

  @override
  String get tacticsThrowInLong => 'Дуга убацивања';

  @override
  String get tacticsThrowInNeutral => 'Неутрално';

  @override
  String get tacticsThrowInDefensive => 'Сигурна убацивања';

  @override
  String get tacticsThrowInLongBlurb =>
      'Убацивања близу шеснаестерца иду у казнени простор. Мало више опасности, посебно са јаким извођачем и високим нападачима, али лопта се нешто чешће изгуби.';

  @override
  String get tacticsThrowInNeutralBlurb =>
      'Убацивања онако како игра дозвољава. Ништа се не мења.';

  @override
  String get tacticsThrowInDefensiveBlurb =>
      'Свако убацивање кратко и сигурно. Мање изгубљених лопти из којих противник контрира, и нешто мање прилика.';

  @override
  String get matchGoalLongThrow => 'ДУГО УБАЦИВАЊЕ';

  @override
  String get tacticsSkillFin => 'ЗАВ';

  @override
  String get tacticsSkillPas => 'ДОД';

  @override
  String tacticsRolePlayer(String name) {
    return 'УЛОГА · $name';
  }

  @override
  String get roleFitGood => 'Одговара';

  @override
  String get roleFitFair => 'Прихватљиво';

  @override
  String get roleFitPoor => 'Не одговара';

  @override
  String get arrowNone => 'Држи позицију';

  @override
  String get arrowForward => 'Напред';

  @override
  String get arrowBack => 'Дубље';

  @override
  String get arrowInside => 'Ка унутра';

  @override
  String get arrowOutside => 'Држи ширину';

  @override
  String get arrowForwardInside => 'Напред и ка унутра';

  @override
  String get arrowForwardOutside => 'Напред и ка споља';

  @override
  String get tacticsPitchModePlayers => 'Играчи';

  @override
  String get tacticsPitchModeRoles => 'Улоге и кретање';

  @override
  String get tacticsPitchRolesHint =>
      'Додирни играча за улогу. Држи и повуци да нацрташ кретање.';

  @override
  String get tacticsPlanRoleHeading => 'УЛОГА';

  @override
  String get tacticsPlanMovementHeading => 'КРЕТАЊЕ';

  @override
  String tacticsPlanTitle(String position, String name) {
    return '$position · $name';
  }

  @override
  String tacticsArrowSet(String name, String movement) {
    return '$name: $movement';
  }

  @override
  String get tacticsKeeperNoRun => 'Голману се не задаје кретање.';

  @override
  String get tacticsPenaltyTaker => 'ИЗВОЂАЧ ПЕНАЛА';

  @override
  String get tacticsCornerFreeKickTaker =>
      'ИЗВОЂАЧ КОРНЕРА И СЛОБОДНИХ УДАРАЦА';

  @override
  String get tacticsAutomatic => 'Аутоматски';

  @override
  String get tacticsLetBestSuited => 'Нека изводи најпогоднији играч.';

  @override
  String get tacticsInXi => 'У ПОСТАВИ';

  @override
  String get tacticsTeamInstructions => 'УПУТСТВА ТИМУ';

  @override
  String get tacticsTeamInstructionsBlurb =>
      'Одреди како игра твој тим. Сваки регулатор помера целу екипу.';

  @override
  String tacticsSavedPreset(String name) {
    return 'Сачувано: „$name“';
  }

  @override
  String tacticsAppliedPreset(String name) {
    return 'Примењено: „$name“';
  }

  @override
  String get tacticsTacticPresets => 'ШАБЛОНИ ТАКТИКЕ';

  @override
  String get tacticsPresetsBlurb =>
      'Сачувај ову формацију као стил за поновну употребу или примени раније сачуван.';

  @override
  String get tacticsSaveCurrentTactic => 'Сачувај тренутну тактику';

  @override
  String tacticsCouldNotLoadPresets(String error) {
    return 'Шаблони нису могли да се учитају.\n$error';
  }

  @override
  String get tacticsNoPresetsYet =>
      'Још нема шаблона. Додирни „Сачувај тренутну тактику“ да сачуваш ову поставку као стил за поновну употребу.';

  @override
  String get tacticsNameThisTactic => 'Назови ову тактику';

  @override
  String get tacticsNameHint => 'нпр. Високи пресинг 4-3-3';

  @override
  String get tacticsCancel => 'Откажи';

  @override
  String get tacticsSave => 'Сачувај';

  @override
  String get tacticsTapToAssign => 'Додирни за доделу';

  @override
  String get tacticsHoldDragSub =>
      'Задржи замену, па је превуци на играча да уђе у игру.';

  @override
  String get hubContinue => 'Настави';

  @override
  String get hubBrackets => 'Костур';

  @override
  String hubCouldNotLoad(String error) {
    return 'Учитавање није успело.\n$error';
  }

  @override
  String hubCouldNotLoadFinances(String error) {
    return 'Финансије нису могле да се учитају.\n$error';
  }

  @override
  String hubCouldNotLoadSave(String error) {
    return 'Сачувана игра није могла да се учита.\n$error';
  }

  @override
  String get hubSaveNotFound => 'Сачувана игра није пронађена.';

  @override
  String get hubUnknown => 'Непознато';

  @override
  String hubWorldChampionsYear(int year) {
    return 'СВЕТСКИ ПРВАЦИ $year';
  }

  @override
  String get hubCycleComplete => 'Циклус је завршен.';

  @override
  String get hubYourJob => 'ТВОЈ ПОСАО';

  @override
  String get hubStayProject => 'Остани и настави свој пројекат';

  @override
  String get hubChooseNextJob => 'ИЗАБЕРИ СЛЕДЕЋИ ПОСАО';

  @override
  String get hubOffersOnTable => 'ПОНУДЕ НА СТОЛУ';

  @override
  String hubOfferSubtitle(String tier, int position) {
    return '$tier · свет #$position';
  }

  @override
  String hubContinueWith(String nation) {
    return 'Настави: $nation';
  }

  @override
  String get hubYourNation => 'твоја земља';

  @override
  String get hubTakeTheJob => 'Прихвати посао';

  @override
  String get hubFederationFinances => 'ФИНАНСИЈЕ САВЕЗА';

  @override
  String get hubBudgetIntro =>
      'Твој први задатак у следећем циклусу је да одредиш буџет савеза и распоредиш га по секторима.';

  @override
  String get hubStarting => 'Покрећем…';

  @override
  String get hubBeginNextCycle => 'Започни следећи циклус';

  @override
  String get hubContinueCareer => 'Настави каријеру';

  @override
  String get hubBackToSaves => 'Назад на сачуване игре';

  @override
  String get hubOpeningBalance => 'Почетно стање';

  @override
  String get hubCentralFunding => 'Централно финансирање';

  @override
  String get hubPrizeMoney => 'Новчане награде';

  @override
  String get hubCommercialReturn => 'Комерцијални приходи';

  @override
  String get hubAvailableToInvest => 'Расположиво за улагање';

  @override
  String hubReputation(String label, int rep) {
    return 'Углед: $label ($rep)';
  }

  @override
  String get hubNationalHero => 'Национални херој';

  @override
  String get hubFinal => 'Финале';

  @override
  String get hubStageRoundOf32 => 'Шеснаестина финала';

  @override
  String get hubStageThirdPlace => 'Утакмица за треће место';

  @override
  String get hubEventAdvanceWorld => 'Помери свет даље';

  @override
  String hubEventStartCycle(int year) {
    return 'Започни циклус $year';
  }

  @override
  String hubEventWorldChampions(String nation) {
    return 'Светски прваци: $nation';
  }

  @override
  String get hubEventSetBudget => 'Одреди буџет савеза';

  @override
  String get hubEventSetBudgetSub =>
      'Распореди средства циклуса пре почетка сезоне';

  @override
  String get hubEventNaturalization => 'Погледај понуду за натурализацију';

  @override
  String get hubEventNaturalizationSub =>
      'Страни играч жели да пређе под твоју заставу';

  @override
  String get hubEventCampaignVerdict => 'Кампања је завршена: погледај пресуду';

  @override
  String get hubEventCampaignComplete => 'Кампања је завршена';

  @override
  String get hubEventIntercontinentalPlayoff => 'Интерконтинентални бараж';

  @override
  String get hubEventWatchWcDraw => 'Гледај жреб Светског првенства';

  @override
  String get hubEventWorldCupHere => 'Светско првенство је почело';

  @override
  String get hubEventWatchFinalsDraw => 'Гледај жреб завршнице';

  @override
  String get hubEventFinalsHere => 'Завршница је почела';

  @override
  String get hubEventPlayWcRound => 'Одиграј следеће коло Светског првенства';

  @override
  String hubEventPlayCupMatch(String cup) {
    return 'Одиграј следећу утакмицу: $cup';
  }

  @override
  String get hubEventPlayNationsCupMatch =>
      'Одиграј следећу утакмицу Купа нација';

  @override
  String get hubEventWatchNationsCupDraw => 'Гледај жреб Купа нација';

  @override
  String get hubEventWatchHostSelection => 'Гледај избор домаћина';

  @override
  String get hubEventWatchQualifyingDraw => 'Гледај жреб квалификација';

  @override
  String get hubEventWatchWcHostSelection =>
      'Гледај избор домаћина Светског првенства';

  @override
  String get hubEventWatchWcQualifyingDraw =>
      'Гледај жреб квалификација за Светско првенство';

  @override
  String get hubEventArrangeFriendlies => 'Договори пријатељске утакмице';

  @override
  String hubEventFriendliesSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Још ниси попунио $count отворених термина за пријатељске утакмице',
      few: 'Још ниси попунио $count отворена термина за пријатељске утакмице',
      one: 'Још ниси попунио $count отворени термин за пријатељске утакмице',
    );
    return '$_temp0';
  }

  @override
  String get hubEventReshapeXi => 'Преобликуј почетну поставу';

  @override
  String hubEventReshapeOutSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count играча из твоје поставе не могу да играју (суспендовани или повређени). Изабери замене',
      few:
          '$count играча из твоје поставе не могу да играју (суспендовани или повређени). Изабери замене',
      one:
          '$count играч из твоје поставе не може да игра (суспендован или повређен). Изабери замену',
    );
    return '$_temp0';
  }

  @override
  String hubEventReshapeShortSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Твоја почетна постава није потпуна. Попуни слободна места',
      few: 'Твоја почетна постава није потпуна. Попуни слободна места',
      one: 'Твоја почетна постава није потпуна. Попуни слободно место',
    );
    return '$_temp0';
  }

  @override
  String hubEventPlayOpponent(String opponent) {
    return 'Одиграј утакмицу: $opponent';
  }

  @override
  String get hubEventContinentalFinalsFallback => 'континентална завршница';

  @override
  String get hubCallUpFriendlies => 'Објави састав за пријатељске утакмице';

  @override
  String get hubCallUpRequalify => 'Поново објави састав за квалификације';

  @override
  String get hubCallUpWorldCup => 'Објави састав за Светско првенство';

  @override
  String get hubCallUpFinals => 'Објави састав за завршницу';

  @override
  String get hubCallUpNationsCup => 'Објави састав за Куп нација';

  @override
  String get hubCallUpQualifying => 'Објави састав за квалификације';

  @override
  String get hubCallUpGeneric => 'Објави састав';

  @override
  String get hubHost => 'Домаћин';

  @override
  String get hubGoldenBoot => 'Најбољи стрелац';

  @override
  String hubGoldenBootValue(String name, int goals) {
    String _temp0 = intl.Intl.pluralLogic(
      goals,
      locale: localeName,
      other: '$goals голова',
      few: '$goals гола',
      one: '$goals гол',
    );
    return '$name · $_temp0';
  }

  @override
  String get hubPens => '(пен.)';

  @override
  String get hubNationalHub => 'СЕДИШТЕ САВЕЗА';

  @override
  String get hubMessages => 'Поруке';

  @override
  String get hubWorldChampions => 'СВЕТСКИ ПРВАЦИ';

  @override
  String get hubViewBracket => 'Прикажи костур ›';

  @override
  String get hubBoardDelighted => 'Одушевљен';

  @override
  String get hubBoardPleased => 'Задовољан';

  @override
  String get hubBoardExpectingMore => 'Очекује више';

  @override
  String get hubBoardConcerned => 'Забринут';

  @override
  String get hubBoardJobAtRisk => 'Посао у опасности';

  @override
  String get boardRemarkNoted =>
      'Управа прима резултат к знању. Њена оцена циклуса остаје непромењена.';

  @override
  String get boardRemarkEncouraged =>
      'Управа поздравља резултат против јачег противника.';

  @override
  String get boardRemarkExpected =>
      'Пораз од јачег противника је био очекиван. Оцена управе остаје непромењена.';

  @override
  String get boardRemarkConcerned =>
      'Управа је примила пораз к знању и очекује реакцију.';

  @override
  String get hubBoard => 'УПРАВА';

  @override
  String get hubFunds => 'СРЕДСТВА';

  @override
  String hubBoardObjective(String label) {
    return 'Циљ управе: $label';
  }

  @override
  String hubObjectiveMet(String result) {
    return 'ИСПУЊЕНО · $result';
  }

  @override
  String hubObjectiveMissed(String result) {
    return 'ПРОМАШЕНО · $result';
  }

  @override
  String get hubNoMoreFixtures => 'Нема више утакмица у овом циклусу.';

  @override
  String get hubVs => 'ПРОТИВ';

  @override
  String hubWorldRank(int rank) {
    return '#$rank';
  }

  @override
  String get hubWorldRankLabel => 'Светска ранг-листа';

  @override
  String get hubSquadStatus => 'СТАЊЕ САСТАВА';

  @override
  String hubPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count играча',
      few: '$count играча',
      one: '$count играч',
    );
    return '$_temp0';
  }

  @override
  String get hubAvgRating => 'Прос. оцена';

  @override
  String get hubMorale => 'Морал';

  @override
  String get hubManageTeam => 'Уреди тим';

  @override
  String get hubGroupsToBeDrawn =>
      'Групе тек треба да се извуку. Гледај жреб да их откријеш.';

  @override
  String hubGroupName(String name) {
    return 'ГРУПА $name';
  }

  @override
  String get hubTblTeam => 'ТИМ';

  @override
  String get hubTblP => 'У';

  @override
  String get hubTblGd => 'ГР';

  @override
  String get hubTblPts => 'Б';

  @override
  String get homeSettings => 'Подешавања';

  @override
  String get homeLeadTheNation => 'ВОДИ РЕПРЕЗЕНТАЦИЈУ';

  @override
  String get homeYourNation => 'твоја земља';

  @override
  String get homeNewGame => 'Нова игра';

  @override
  String get homeAllSaves => 'Све сачуване игре';

  @override
  String get homeLoadGame => 'Учитај игру';

  @override
  String get homeContinue => 'НАСТАВИ';

  @override
  String homeRoadToWorldCup(String date, int year) {
    return '$date · Пут до Светског првенства $year';
  }

  @override
  String get careerManageSaves => 'Управљај сачуваним играма';

  @override
  String get careerNewGameTitle => 'НОВА ИГРА';

  @override
  String careerCouldNotLoadNation(String error) {
    return 'Земља није могла да се учита.\n$error';
  }

  @override
  String get careerNationNotFound => 'Земља није пронађена.';

  @override
  String careerWorldRankNum(int rank) {
    return 'СВЕТСКА РАНГ-ЛИСТА #$rank';
  }

  @override
  String get careerManagerName => 'Име селектора';

  @override
  String get careerManagerNameHint => 'нпр. Мартин';

  @override
  String get careerBeginsBlurb =>
      'Твоја каријера почиње у септембру 2026, на путу ка Светском првенству 2030.';

  @override
  String get careerFreeCycleNote =>
      'Бесплатно за један цео четворогодишњи циклус: квалификације, континентално првенство и Светско првенство, на два места за чување. Након тога једна уплата откључава бесконачне циклусе.';

  @override
  String get careerStartCareer => 'Започни каријеру';

  @override
  String get careersTitle => 'КАРИЈЕРЕ';

  @override
  String get careerManagerCareer => 'Селекторска каријера';

  @override
  String get careerManagerCareerSubtitle =>
      'Сваки циклус који си водио и твој укупни учинак';

  @override
  String get careerSummaryTitle => 'Преглед каријере';

  @override
  String get careerSummarySubtitle =>
      'Твоја витрина са трофејима и селекторски учинак';

  @override
  String get careerAchievements => 'Достигнућа';

  @override
  String get careerAchievementsSubtitle =>
      'Прекретнице, титуле и задовољство управе';

  @override
  String get careerChallenges => 'Изазови';

  @override
  String get careerChallengesSubtitle => 'Брутални изазови за целу каријеру';

  @override
  String get careerTeamRecords => 'Рекорди тима';

  @override
  String get careerTeamRecordsSubtitle =>
      'Најбољи стрелци и број наступа свих времена';

  @override
  String get careerMyMatches => 'Моје утакмице';

  @override
  String get careerMyMatchesSubtitle => 'Сваки резултат и предстојећа утакмица';

  @override
  String get careerTitle => 'КАРИЈЕРА';

  @override
  String careerCouldNotLoadCareer(String error) {
    return 'Каријера није могла да се учита.\n$error';
  }

  @override
  String get careerNoCareer => 'Нема каријере.';

  @override
  String get careerTrophyCabinet => 'ВИТРИНА СА ТРОФЕЈИМА';

  @override
  String get careerTournamentHistory => 'ИСТОРИЈА ТУРНИРА';

  @override
  String get careerNoTournamentsYet => 'Још није завршен ниједан турнир.';

  @override
  String get careerTeamFallback => 'Тим';

  @override
  String careerWorldNum(int rank) {
    return 'СВЕТ #$rank';
  }

  @override
  String careerPointsNum(int points) {
    return '$points БОД.';
  }

  @override
  String careerSeasonNum(int season) {
    return 'СЕЗОНА $season';
  }

  @override
  String get careerStatPlayedShort => 'У';

  @override
  String get careerStatsHeading => 'У БРОЈКАМА';

  @override
  String get careerStatsWinRate => 'Проценат победа';

  @override
  String get careerStatsGoalsFor => 'Дати голови';

  @override
  String get careerStatsGoalsAgainst => 'Примљени голови';

  @override
  String get careerStatsGoalDiff => 'Гол-разлика';

  @override
  String get careerStatsCleanSheets => 'Без примљеног гола';

  @override
  String get careerStatsBiggestWin => 'Највећа победа';

  @override
  String get careerStatsWinStreak => 'Низ победа';

  @override
  String get careerStatsUnbeaten => 'Низ без пораза';

  @override
  String get careerStatsShootouts => 'Пенал-серије';

  @override
  String get careerStatsHatTricks => 'Хет-трикови';

  @override
  String get careerStatsMotms => 'Играч утакмице';

  @override
  String get careerStatsBestRating => 'Најбоља оцена';

  @override
  String get careerStatWonShort => 'П';

  @override
  String get careerStatDrawnShort => 'Н';

  @override
  String get careerStatLostShort => 'И';

  @override
  String get careerStatGoalsForShort => 'ДГ';

  @override
  String get careerStatGoalsAgainstShort => 'ПГ';

  @override
  String get careerStatGoalDiffShort => 'ГР';

  @override
  String get careerNoSilverware => 'Још нема трофеја. Иди и освоји неки.';

  @override
  String get careerMedalGold => 'ЗЛАТО';

  @override
  String get careerMedalSilver => 'СРЕБРО';

  @override
  String get careerMedalBronze => 'БРОНЗА';

  @override
  String careerWinnersName(String name) {
    return 'Победник: $name';
  }

  @override
  String get careerSavesTitle => 'САЧУВАНЕ ИГРЕ';

  @override
  String careerCouldNotLoadSaves(String error) {
    return 'Сачуване игре нису могле да се учитају.\n$error';
  }

  @override
  String careerSlotsCount(int used, int limit) {
    return 'МЕСТА  $used/$limit';
  }

  @override
  String get careerThisSave => 'ова игра';

  @override
  String get careerSlotsFull => 'Сва места су заузета';

  @override
  String careerSlotsUsed(int used) {
    return 'МЕСТА  $used';
  }

  @override
  String get careerSlotsUnlockMore => 'Откључај још места';

  @override
  String get careerSlotsKeepNote =>
      'Свака сачувана игра коју већ имаш остаје доступна. Откључавање је потребно само за нову.';

  @override
  String get careerNewGame => 'Нова игра';

  @override
  String get careerDeleteSaveTitle => 'Обрисати сачувану игру?';

  @override
  String careerDeleteSaveBody(String label) {
    return 'Ово трајно брише твоју каријеру: $label.';
  }

  @override
  String get careerCancel => 'Откажи';

  @override
  String get careerDelete => 'Обриши';

  @override
  String get careerNoSavesYet =>
      'Још нема сачуваних игара.\nЗапочни нову игру и води репрезентацију.';

  @override
  String get careerUnknownNation => 'Непознато';

  @override
  String careerPlayedMinutes(int minutes) {
    return '$minutes мин';
  }

  @override
  String careerPlayedHours(int hours, int minutes) {
    return '$hours ч $minutes мин';
  }

  @override
  String careerLastPlayed(String when) {
    return 'Последњи пут играно: $when';
  }

  @override
  String get careerJustNow => 'управо сад';

  @override
  String get careerYesterday => 'јуче';

  @override
  String careerMinutesAgo(int n) {
    return 'пре $n мин';
  }

  @override
  String careerHoursAgo(int n) {
    return 'пре $n ч';
  }

  @override
  String careerDaysAgo(int n) {
    return 'пре $n д';
  }

  @override
  String careerRoadToWorldCup(int year) {
    return 'Пут до Светског првенства $year';
  }

  @override
  String homeNextFixture(String match, String when) {
    return 'Следеће: $match, $when';
  }

  @override
  String homeCycleComplete(int year) {
    return 'Светско првенство $year је завршено. Следи пресуда управе.';
  }

  @override
  String homeFollowingFinals(int year) {
    return 'Светско првенство $year са трибина';
  }

  @override
  String get careerManagerCareerTitle => 'СЕЛЕКТОРСКА КАРИЈЕРА';

  @override
  String careerCouldNotLoad(String error) {
    return 'Учитавање није успело.\n$error';
  }

  @override
  String get careerCycleByCycle => 'ЦИКЛУС ПО ЦИКЛУС';

  @override
  String careerCyclesNationsLed(int cycles, int nations) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles циклуса',
      few: '$cycles циклуса',
      one: '$cycles циклус',
    );
    String _temp1 = intl.Intl.pluralLogic(
      nations,
      locale: localeName,
      other: '$nations вођених земаља',
      few: '$nations вођене земље',
      one: '$nations вођена земља',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get careerStatTitles => 'Трофеји';

  @override
  String get careerStatPlayed => 'Одиграно';

  @override
  String get careerStatWon => 'Победе';

  @override
  String get careerStatDrawn => 'Нерешено';

  @override
  String get careerStatLost => 'Порази';

  @override
  String careerGoalsWinRate(
    int goalsFor,
    int goalsAgainst,
    String gd,
    int winRate,
  ) {
    return 'Голови $goalsFor–$goalsAgainst  ($gd)  ·  Проценат победа $winRate%';
  }

  @override
  String get careerRecordResults => 'РЕКОРДНИ РЕЗУЛТАТИ';

  @override
  String get careerBestWin => 'Најбоља победа';

  @override
  String get careerWorstDefeat => 'Најтежи пораз';

  @override
  String careerVsOpponentDate(String opponent, String date) {
    return 'против $opponent · $date';
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
    return '$wonП $drawnН $lostИ  ·  ДГ $goalsFor ПГ $goalsAgainst ($gd)';
  }

  @override
  String get careerWorldCupLabel => 'Светско првенство';

  @override
  String get careerContinentalLabel => 'Континентално';

  @override
  String get messagesTitle => 'ПОРУКЕ';

  @override
  String get messagesNoMessagesYet => 'Још нема порука.';

  @override
  String messagesCouldNotLoad(String error) {
    return 'Поруке нису могле да се учитају.\n$error';
  }

  @override
  String get messagesDone => 'Готово';

  @override
  String get messagesNext => 'Даље';

  @override
  String get rankingWorldRanking => 'СВЕТСКА РАНГ-ЛИСТА';

  @override
  String rankingCouldNotLoad(String error) {
    return 'Ранг-листа није могла да се учита.\n$error';
  }

  @override
  String get rankingNoRanking => 'Нема ранг-листе.';

  @override
  String get rankingAll => 'СВЕ';

  @override
  String get rankingYourTeam => 'ТВОЈ ТИМ';

  @override
  String get rankingYourRankingOverTime => 'ТВОЈ ПЛАСМАН КРОЗ ВРЕМЕ';

  @override
  String rankingNowRank(int rank) {
    return 'сад #$rank';
  }

  @override
  String rankingBestWorst(int best, int worst) {
    return 'најбоље #$best · најлошије #$worst';
  }

  @override
  String get friendliesTitle => 'ПРИЈАТЕЉСКЕ';

  @override
  String friendliesLoadError(String error) {
    return 'Пријатељске утакмице нису могле да се учитају.\n$error';
  }

  @override
  String get friendliesContinue => 'Настави';

  @override
  String friendliesArrangeIntro(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count слободних термина',
      few: '$count слободна термина',
      one: '$count слободан термин',
    );
    return 'Договори припремне утакмице за $_temp0 пре следеће званичне утакмице. Додирни противника или остави термин слободним.';
  }

  @override
  String get friendliesFree => 'Слободно';

  @override
  String matchGoalsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ГОЛОВА',
      few: '$count ГОЛА',
      one: '$count ГОЛ',
    );
    return '$_temp0';
  }

  @override
  String get matchGoalsTitle => 'ГОЛОВИ';

  @override
  String get matchGoalsNone => 'Без голова';

  @override
  String get matchGoalPenalty => '11М';

  @override
  String get matchGoalSetPiece => 'ПРК';

  @override
  String matchGoalAssist(String name) {
    return 'асистенција $name';
  }

  @override
  String get friendliesHome => 'КОД КУЋЕ';

  @override
  String get friendliesAway => 'У ГОСТИМА';

  @override
  String get friendliesNoneThisWindow => 'Нема пријатељских у овом термину';

  @override
  String friendliesConfirmCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count пријатељских',
      few: '$count пријатељске',
      one: '$count пријатељску',
    );
    return 'Потврди $_temp0';
  }

  @override
  String get friendliesMonthJan => 'јан';

  @override
  String get friendliesMonthFeb => 'феб';

  @override
  String get friendliesMonthMar => 'мар';

  @override
  String get friendliesMonthApr => 'апр';

  @override
  String get friendliesMonthMay => 'мај';

  @override
  String get friendliesMonthJun => 'јун';

  @override
  String get friendliesMonthJul => 'јул';

  @override
  String get friendliesMonthAug => 'авг';

  @override
  String get friendliesMonthSep => 'сеп';

  @override
  String get friendliesMonthOct => 'окт';

  @override
  String get friendliesMonthNov => 'нов';

  @override
  String get friendliesMonthDec => 'дец';

  @override
  String get resultsMyMatches => 'МОЈЕ УТАКМИЦЕ';

  @override
  String resultsCouldNotLoad(String error) {
    return 'Резултати нису могли да се учитају.\n$error';
  }

  @override
  String get resultsNoFixtures => 'Нема утакмица.';

  @override
  String get resultsVs => 'против';

  @override
  String get resultsStageQualifier => 'КВАЛИФИКАЦИЈЕ';

  @override
  String get resultsStageFriendly => 'ПРИЈАТЕЉСКА';

  @override
  String get resultsStageGroupStage => 'ГРУПНА ФАЗА';

  @override
  String get resultsStageSemiFinal => 'ПОЛУФИНАЛЕ';

  @override
  String get resultsStageFinal => 'ФИНАЛЕ';

  @override
  String get resultsStageContinentalClash => 'ДУЕЛ КОНТИНЕНАТА';

  @override
  String get resultsStageFinalsGroup => 'ГРУПА ЗАВРШНИЦЕ';

  @override
  String get resultsStageRoundOf32 => '1/16 ФИНАЛА';

  @override
  String get resultsStageRoundOf16 => 'ОСМИНА ФИНАЛА';

  @override
  String get resultsStageQuarterFinal => 'ЧЕТВРТФИНАЛЕ';

  @override
  String get resultsStageThirdPlace => 'ЗА ТРЕЋЕ МЕСТО';

  @override
  String get matchSetupWarnCaptain =>
      'Капитен није одређен. Додирни и дај некоме капитенску траку';

  @override
  String matchSetupWarnCaptainInjured(String name) {
    return 'Играч $name је повређен и не може да предводи тим. Додирни и предај траку даље';
  }

  @override
  String matchSetupWarnCaptainSuspended(String name) {
    return 'Играч $name је суспендован за ову утакмицу. Додирни и предај траку даље';
  }

  @override
  String matchSetupWarnCaptainDropped(String name) {
    return 'Играч $name има траку, али није у твом саставу. Додирни и предај је даље';
  }

  @override
  String get matchSetupWarnSetPieces =>
      'Извођачи прекида нису одређени. Додирни и изабери ко ће их изводити';

  @override
  String get matchSetupWarnBoth =>
      'Нема капитена ни извођача прекида. Додирни и одреди их';

  @override
  String matchStageMatchday(int matchday) {
    return '$matchday. КОЛО';
  }

  @override
  String get squadCaptain => 'Капитен';

  @override
  String deptEffectYouth(int points) {
    return 'Таленти из академије стижу са око $points бољом укупном оценом';
  }

  @override
  String deptEffectCommercial(String amount) {
    return '$amount назад на крају циклуса';
  }

  @override
  String deptEffectMedical(int percent) {
    return '$percent% мање повреда';
  }

  @override
  String deptEffectNaturalisation(int percent) {
    return '$percent% шансе да страни играч затражи промену репрезентације';
  }

  @override
  String deptEffectBoard(int points) {
    return '+$points стрпљења управе пре него што ти запрети отказ';
  }

  @override
  String get deptEffectNone => 'Без ефекта док није финансирано';

  @override
  String get statsBestRated => 'Оцене';

  @override
  String get statsMyCareer => 'Каријера';

  @override
  String get statsBestAverageRating => 'НАЈБОЉА ПРОСЕЧНА ОЦЕНА';

  @override
  String get statsMyCareerRecord => 'ТВОЈ УЧИНАК';

  @override
  String get statsNoRatingsRecorded => 'Још нема забележених оцена.';

  @override
  String get statsGroupRecord => 'Учинак';

  @override
  String get statsGroupRuns => 'Низови';

  @override
  String get statsGroupExtremes => 'Крајности';

  @override
  String get statsGroupSplits => 'Код куће и у гостима';

  @override
  String get statsGroupSquad => 'Твоји играчи';

  @override
  String get statsPlayed => 'Одигране утакмице';

  @override
  String get statsWinDrawLoss => 'Победе–нерешено–порази';

  @override
  String get statsWinRate => 'Проценат победа';

  @override
  String get statsGoals => 'Голови дати:примљени';

  @override
  String get statsCleanSheets => 'Мреже без примљеног гола';

  @override
  String get statsFailedToScore => 'Без постигнутог гола';

  @override
  String get statsLongestWinStreak => 'Најдужи низ победа';

  @override
  String get statsLongestUnbeaten => 'Најдужи низ без пораза';

  @override
  String get statsLongestCleanSheets => 'Најдужи низ без примљеног гола';

  @override
  String get statsLongestWinless => 'Најдужи низ без победе';

  @override
  String get statsCurrentRun => 'Тренутни низ без пораза';

  @override
  String get statsBiggestWin => 'Највећа победа';

  @override
  String get statsHeaviestDefeat => 'Најтежи пораз';

  @override
  String get statsMostGoalsInAGame => 'Највише голова на утакмици';

  @override
  String get statsShootouts => 'Пенали: победе–порази';

  @override
  String get statsComebackWins => 'Победе после заостатка';

  @override
  String get statsHome => 'Код куће';

  @override
  String get statsAway => 'У гостима';

  @override
  String get statsNeutral => 'Неутрално';

  @override
  String get statsCompetitive => 'Званичне';

  @override
  String get statsFriendlies => 'Пријатељске';

  @override
  String get statsHatTricks => 'Хет-трикови';

  @override
  String get statsBraces => 'Дублете';

  @override
  String get statsMotms => 'Награде за играча утакмице';

  @override
  String get statsAssists => 'Асистенције';

  @override
  String get statsCards => 'Картони';

  @override
  String get statsBestRating => 'Најбоља појединачна оцена';

  @override
  String statsAppsShort(int apps) {
    String _temp0 = intl.Intl.pluralLogic(
      apps,
      locale: localeName,
      other: '$apps наступа',
      few: '$apps наступа',
      one: '$apps наступ',
    );
    return '$_temp0';
  }

  @override
  String statsMotmShort(int motms) {
    return '$motms MOTM';
  }

  @override
  String get captainArmband => 'К';

  @override
  String get captainCurrent => 'Капитен. Додирни да скинеш траку';

  @override
  String get captainFitBorn => 'Рођени вођа';

  @override
  String get captainFitNatural => 'Природни капитен';

  @override
  String get captainFitCapable => 'Могао би да носи траку';

  @override
  String get captainFitUnproven => 'Још није вођа';

  @override
  String get captainNone => 'Капитен није одређен';

  @override
  String captainMoraleBoost(int morale) {
    return '+$morale морала тима';
  }

  @override
  String get viceCaptainFirst => '1. заменик капитена';

  @override
  String get viceCaptainSecond => '2. заменик капитена';

  @override
  String get viceCaptainNone => 'Заменик капитена није одређен';

  @override
  String get viceCaptainHint => 'Преузима траку кад капитен не може да игра.';

  @override
  String captainStandIn(String vice, String captain) {
    return 'Тим изводи заменик капитена $vice, капитен $captain није доступан';
  }

  @override
  String captainStandInUnnamed(String vice) {
    return 'Тим изводи заменик капитена $vice';
  }

  @override
  String get resultsCategoryWorldCupQualifying =>
      'Квалификације за Светско првенство';

  @override
  String get resultsCategoryFriendlies => 'Пријатељске утакмице';

  @override
  String get resultsCategoryContinentalClash => 'Дуел континената';

  @override
  String get resultsCategoryNationsCup => 'Куп нација';

  @override
  String get resultsCategoryContinentalCup => 'Континентални куп';

  @override
  String get resultsCategoryWorldCupQualifyingShort => 'СП квал.';

  @override
  String get resultsCategoryContinentalQualifyingShort => 'Конт. куп квал.';

  @override
  String get resultsCategoryContinentalQualifying =>
      'Квалификације за континентални куп';

  @override
  String get resultsCategoryWorldCupFinals => 'Завршница Светског првенства';

  @override
  String get resultsRoundResults => 'РЕЗУЛТАТИ КОЛА';

  @override
  String get resultsFriendlyInternationals =>
      'ПРИЈАТЕЉСКЕ УТАКМИЦЕ РЕПРЕЗЕНТАЦИЈА';

  @override
  String get resultsKnockout => 'Нокаут фаза';

  @override
  String resultsEarlierMatches(int count) {
    return 'Раније утакмице ($count)';
  }

  @override
  String resultsMatchday(int matchday) {
    return 'КОЛО $matchday';
  }

  @override
  String get resultsContinue => 'Настави';

  @override
  String resultsGroup(String name) {
    return 'ГРУПА $name';
  }

  @override
  String get achievementsScreenTitle => 'ДОСТИГНУЋА';

  @override
  String get achievementsChallengesTooltip => 'Изазови';

  @override
  String get achievementsChallengesHeading => 'ИЗАЗОВИ';

  @override
  String get achievementsBrutalTests => 'Брутални изазови за целу каријеру';

  @override
  String achievementsCouldNotLoad(String error) {
    return 'Учитавање није успело.\n$error';
  }

  @override
  String achievementsUnlockedCount(int earned, int total) {
    return '$earned / $total откључано';
  }

  @override
  String achievementsConqueredCount(int done, int total) {
    return '$done / $total савладано';
  }

  @override
  String get achievementsBoardSatisfaction => 'ЗАДОВОЉСТВО УПРАВЕ';

  @override
  String achievementsUnlockedBanner(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ДОСТИГНУЋА ОТКЉУЧАНО',
      few: '$count ДОСТИГНУЋА ОТКЉУЧАНА',
      one: '$count ДОСТИГНУЋЕ ОТКЉУЧАНО',
    );
    return '$_temp0';
  }

  @override
  String get achCatWins => 'Победе';

  @override
  String get achCatMatches => 'Утакмице';

  @override
  String get achCatQualifications => 'Квалификације';

  @override
  String get achCatTitles => 'Трофеји';

  @override
  String get achCatMisc => 'Разно';

  @override
  String get achCatMega => 'Мега';

  @override
  String get achCatGoals => 'Голови';

  @override
  String get achCatStreaks => 'Низови';

  @override
  String get achTierBronze => 'Бронза';

  @override
  String get achTierSilver => 'Сребро';

  @override
  String get achTierGold => 'Злато';

  @override
  String get achTierPlatinum => 'Платина';

  @override
  String achGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count голова',
      few: '$count гола',
      one: '$count гол',
    );
    return '$_temp0';
  }

  @override
  String achGoalsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Постигни $count голова.',
      few: 'Постигни $count гола.',
      one: 'Постигни $count гол.',
    );
    return '$_temp0';
  }

  @override
  String achCleanSheets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count утакмица без примљеног гола',
      few: '$count утакмице без примљеног гола',
      one: '$count утакмица без примљеног гола',
    );
    return '$_temp0';
  }

  @override
  String achCleanSheetsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Не прими гол на $count утакмица.',
      few: 'Не прими гол на $count утакмице.',
      one: 'Не прими гол на $count утакмици.',
    );
    return '$_temp0';
  }

  @override
  String get achStreakWin5 => 'Навика побеђивања';

  @override
  String get achStreakWin5Desc => 'Победи на пет утакмица заредом.';

  @override
  String get achStreakWin10 => 'У налету';

  @override
  String get achStreakWin10Desc => 'Победи на десет утакмица заредом.';

  @override
  String get achStreakWin20 => 'Ваљак';

  @override
  String get achStreakWin20Desc => 'Победи на двадесет утакмица заредом.';

  @override
  String get achUnbeaten15 => 'Тешко их је победити';

  @override
  String get achUnbeaten15Desc => 'Одиграј петнаест утакмица без пораза.';

  @override
  String get achUnbeaten30 => 'Недодирљиви';

  @override
  String get achUnbeaten30Desc => 'Одиграј тридесет утакмица без пораза.';

  @override
  String get achHattrick => 'Јунак хет-трика';

  @override
  String get achHattrickDesc => 'Нека играч постигне хет-трик.';

  @override
  String get achMotm10 => 'Истакнути';

  @override
  String get achMotm10Desc => 'Сакупи 10 награда за играча утакмице.';

  @override
  String get achMotm50 => 'Талисман';

  @override
  String get achMotm50Desc => 'Сакупи 50 награда за играча утакмице.';

  @override
  String get achPerfect => 'Савршена десетка';

  @override
  String get achPerfectDesc => 'Нека играч добије оцену 9,5 или вишу.';

  @override
  String get achShootout => 'Лед у венама';

  @override
  String get achShootoutDesc => 'Победи у пет пенал-серија.';

  @override
  String get achMassacre => 'Масакр';

  @override
  String get achMassacreDesc => 'Победи са разликом од 7 или више голова.';

  @override
  String get achAnnihilation => 'Уништење';

  @override
  String get achAnnihilationDesc => 'Победи са разликом од 10 или више голова.';

  @override
  String get chTierBronze => 'Бронза';

  @override
  String get chTierSilver => 'Сребро';

  @override
  String get chTierGold => 'Злато';

  @override
  String get chTierLegendary => 'Легендарно';

  @override
  String get chFirstSteps => 'На клупи';

  @override
  String get chFirstStepsDesc => 'Води тим 5 година.';

  @override
  String get chUnbeaten10 => 'У налету';

  @override
  String get chUnbeaten10Desc => 'Одиграј 10 званичних утакмица без пораза.';

  @override
  String get chTwoNations => 'Нови изазов';

  @override
  String get chTwoNationsDesc => 'Води 2 различите репрезентације.';

  @override
  String get chCont1 => 'Континентални шампион';

  @override
  String get chCont1Desc => 'Освоји континентално првенство.';

  @override
  String get chNc1 => 'Победник Купа нација';

  @override
  String get chNc1Desc => 'Освоји Куп нација.';

  @override
  String get chWc1 => 'Светски шампион';

  @override
  String get chWc1Desc => 'Освоји Светско првенство.';

  @override
  String get chYears25 => 'Естаблишмент';

  @override
  String get chYears25Desc => 'Води тим 25 година.';

  @override
  String get chWc3 => 'Серијски победник';

  @override
  String get chWc3Desc => 'Освоји 3 Светска првенства.';

  @override
  String get chWc5 => 'Династија';

  @override
  String get chWc5Desc => 'Освоји 5 Светских првенстава.';

  @override
  String get chWc10 => 'Бесмртник';

  @override
  String get chWc10Desc => 'Освоји 10 Светских првенстава.';

  @override
  String get chWc2Teams => 'Кофер спреман';

  @override
  String get chWc2TeamsDesc =>
      'Освоји Светско првенство са 2 различите репрезентације.';

  @override
  String get chWc3Teams => 'Светски путник';

  @override
  String get chWc3TeamsDesc =>
      'Освоји Светско првенство са 3 различите репрезентације.';

  @override
  String get chWcStreak3 => 'Три заредом';

  @override
  String get chWcStreak3Desc => 'Освоји 3 Светска првенства заредом.';

  @override
  String get chWcAllconf => 'Освајач света';

  @override
  String get chWcAllconfDesc =>
      'Освоји Светско првенство са репрезентацијом из сваке конфедерације (6).';

  @override
  String get chCont5 => 'Континентални краљ';

  @override
  String get chCont5Desc => 'Освоји 5 континенталних првенстава.';

  @override
  String get chContAll => 'Слем шест континената';

  @override
  String get chContAllDesc =>
      'Освоји континентално првенство сваке конфедерације (6).';

  @override
  String get chTreble => 'Чист скор';

  @override
  String get chTrebleDesc =>
      'Освоји Светско првенство, континентални трофеј и Куп нација у једној каријери.';

  @override
  String get chNations10 => 'Номад';

  @override
  String get chNations10Desc => 'Води 10 различитих репрезентација.';

  @override
  String get chYears100 => 'Век';

  @override
  String get chYears100Desc => 'Води тим 100 година.';

  @override
  String get chYears500 => 'Пола миленијума';

  @override
  String get chYears500Desc => 'Води тим 500 година.';

  @override
  String get chYears1000 => 'Вечни';

  @override
  String get chYears1000Desc => 'Води тим 1000 година.';

  @override
  String get chGrandmaster => 'Велемајстор';

  @override
  String get chGrandmasterDesc =>
      'Освоји 3 Светска првенства И 5 континенталних првенстава.';

  @override
  String get chUndefeated => 'Недодирљиви';

  @override
  String get chUndefeatedDesc => 'Освоји Светско првенство без иједног пораза.';

  @override
  String get chPerfectQual => 'Беспрекоран пролаз';

  @override
  String get chPerfectQualDesc =>
      'Победи на свакој утакмици квалификација за Светско првенство.';

  @override
  String get chMinnow => 'Чудо малих';

  @override
  String get chMinnowDesc =>
      'Освоји Светско првенство са репрезентацијом ван првих 32 на светској ранг-листи.';

  @override
  String get chGrandTour => 'Код куће и у гостима';

  @override
  String get chGrandTourDesc =>
      'Освоји Светско првенство као домаћин и једно ван своје земље.';

  @override
  String get chUnbeaten25 => 'Зид';

  @override
  String get chUnbeaten25Desc => 'Одиграј 25 званичних утакмица без пораза.';

  @override
  String get chGoals10k => 'Машина за голове';

  @override
  String get chGoals10kDesc => 'Постигни 10.000 голова у каријери.';

  @override
  String get chCleanSheets500 => 'Тврђава';

  @override
  String get chCleanSheets500Desc =>
      'Одиграј 500 утакмица без примљеног гола у каријери.';

  @override
  String get chHatTricks25 => 'Навика хет-трика';

  @override
  String get chHatTricks25Desc => 'Нека твоји играчи постигну 25 хет-трикова.';

  @override
  String get chWinStreak25 => 'Немилосрдни';

  @override
  String get chWinStreak25Desc => 'Победи на 25 утакмица заредом.';

  @override
  String get chCont10 => 'Континентална династија';

  @override
  String get chCont10Desc => 'Освоји 10 континенталних првенстава.';

  @override
  String get chPcWc => 'Серијски шампион';

  @override
  String chPcWcDesc(int count) {
    return 'Освоји Светско првенство $count пута у овој игри.';
  }

  @override
  String get chPcMajors => 'Сакупљач трофеја';

  @override
  String chPcMajorsDesc(int count) {
    return 'Освоји велике трофеје: $count (Светско првенство, континентално првенство, Куп нација или Дуел континената).';
  }

  @override
  String get chPcUnbeaten => 'Гвоздени зид';

  @override
  String chPcUnbeatenDesc(int count) {
    return 'Остани без пораза у званичним утакмицама: $count заредом.';
  }

  @override
  String get chPcNations => 'Путник';

  @override
  String chPcNationsDesc(int count) {
    return 'Води различите репрезентације: $count.';
  }

  @override
  String get chPcYears => 'Дуг пут';

  @override
  String chPcYearsDesc(int count) {
    return 'Води тим $count год.';
  }

  @override
  String achWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count победа',
      few: '$count победе',
      one: '$count победа',
    );
    return '$_temp0';
  }

  @override
  String achWinsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Победи на $count утакмица.',
      few: 'Победи на $count утакмице.',
      one: 'Победи на $count утакмици.',
    );
    return '$_temp0';
  }

  @override
  String achMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count утакмица',
      few: '$count утакмице',
      one: '$count утакмица',
    );
    return '$_temp0';
  }

  @override
  String achMatchesDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Одиграј $count утакмица.',
      few: 'Одиграј $count утакмице.',
      one: 'Одиграј $count утакмицу.',
    );
    return '$_temp0';
  }

  @override
  String get achQualWc => 'Учесник Светског првенства';

  @override
  String get achQualWcDesc => 'Квалификуј се за Светско првенство.';

  @override
  String get achQualCont => 'Континентални учесник';

  @override
  String get achQualContDesc =>
      'Квалификуј се за своје континентално првенство.';

  @override
  String get achTitleWc => 'Светски шампиони';

  @override
  String get achTitleWcDesc => 'Освоји Светско првенство.';

  @override
  String get achTitleEuro => 'Шампиони Европе';

  @override
  String get achTitleEuroDesc => 'Освоји Европско првенство.';

  @override
  String get achTitleCopa => 'Шампиони Јужне Америке';

  @override
  String get achTitleCopaDesc => 'Освоји Куп Јужне Америке.';

  @override
  String get achTitleAfcon => 'Шампиони Африке';

  @override
  String get achTitleAfconDesc => 'Освоји Афричко првенство.';

  @override
  String get achTitleAsia => 'Шампиони Азије';

  @override
  String get achTitleAsiaDesc => 'Освоји Азијско првенство.';

  @override
  String get achTitleConcacaf => 'Шампиони Северне Америке';

  @override
  String get achTitleConcacafDesc => 'Освоји Куп Северне Америке.';

  @override
  String get achTitleOfc => 'Шампиони Океаније';

  @override
  String get achTitleOfcDesc => 'Освоји Куп Океаније.';

  @override
  String get achTitleNations => 'Победници Купа нација';

  @override
  String get achTitleNationsDesc => 'Освоји Куп нација.';

  @override
  String get achTitleClash => 'Победници Дуела континената';

  @override
  String get achTitleClashDesc => 'Освоји Дуел континената.';

  @override
  String get achTitleGulf => 'Победници Купа оазе';

  @override
  String get achTitleGulfDesc => 'Освоји Куп оазе.';

  @override
  String get achTitleSea => 'Шампиони југоисточне Азије';

  @override
  String get achTitleSeaDesc => 'Освоји Првенство југоисточне Азије.';

  @override
  String get achMarksman => 'Стрелац Светског првенства';

  @override
  String get achMarksmanDesc =>
      'Нека играч из твог састава постигне 6 или више голова у завршници Светског првенства.';

  @override
  String get achSweep => 'Чист скор';

  @override
  String get achSweepDesc =>
      'Освоји Светско првенство и континентални трофеј у једној каријери.';

  @override
  String get achAllstar => 'Звезда турнира';

  @override
  String get achAllstarDesc =>
      'Нека играч уђе у Тим турнира Светског првенства.';

  @override
  String get achGoldenboot => 'Најбољи стрелац';

  @override
  String get achGoldenbootDesc =>
      'Нека твоја репрезентација буде најбољи стрелац првенства.';

  @override
  String get achDemolition => 'Рушење';

  @override
  String get achDemolitionDesc => 'Победи са разликом од 5 или више голова.';

  @override
  String get achievementsNice => 'Супер!';

  @override
  String get achievementsHardestTests =>
      'Најтежи испити за селектора, кроз целу каријеру и многе репрезентације.';

  @override
  String get achievementsThisSave => 'ОВА ИГРА';

  @override
  String get achievementsBrutalBadge => 'БРУТАЛНО';

  @override
  String get paywallGoPro => 'ПОСТАНИ UNLIMITED';

  @override
  String get paywallOneTimeUnlock => 'Једнократно откључавање. Без претплате.';

  @override
  String get paywallBenefitCarryOn =>
      'Ова игра се наставља тачно где је стала, са сваким наступом, рекордом и ривалством на броју.';

  @override
  String get paywallBenefitNoAds =>
      'Без реклама, без микротрансакција, без претплате. Једна уплата, ажурирања укључена.';

  @override
  String get paywallBenefitSaves =>
      'Колико год сачуваних игара желиш. Води фаворита и аутсајдера истовремено и откриј колико се иста игра различито доживљава.';

  @override
  String get paywallBenefitEndless =>
      'Сваки циклус од сада. Изабери седамнаестогодишњака данас и 2034. сазнај да ли си био у праву.';

  @override
  String get paywallUnlocked => 'Unlimited је откључан. Уживај!';

  @override
  String get paywallContactingStore => 'Повезивање са продавницом…';

  @override
  String paywallUnlockProPriced(String price) {
    return 'Откључај Unlimited · $price';
  }

  @override
  String get paywallRestorePurchases => 'Врати куповине';

  @override
  String get paywallStoreUnavailable => 'Продавница није доступна';

  @override
  String get paywallStoreUnavailableNote =>
      'Цена није могла да се учита. Провери везу и покушај поново.';

  @override
  String get paywallTryAgain => 'Покушај поново';

  @override
  String get gateTitle => 'ТВОЈ ПРВИ ЦИКЛУС ЈЕ ГОТОВ';

  @override
  String get gateLead =>
      'Четири године су један циклус. То није довољно да сазнаш да ли си био у праву.';

  @override
  String get gatePriceLead => 'Једна уплата, заувек';

  @override
  String get gateBuy => 'КУПИ И НАСТАВИ';

  @override
  String get gateExit => 'ИЗЛАЗ';

  @override
  String get gateSaveTitle => 'ОВА ИГРА ЗАХТЕВА PRO';

  @override
  String get gateSaveLead =>
      'Игре после бесплатног циклуса и Pro кампање настављају се уз Pro. Ништа се не губи: игра те чека тачно онаква каквом си је оставио.';

  @override
  String get careerSaveLockedNote => 'За наставак ове игре треба ти Pro';

  @override
  String get federationNaturalisation => 'НАТУРАЛИЗАЦИЈА';

  @override
  String federationNaturalisedTitle(String name) {
    return 'Натурализован: $name';
  }

  @override
  String federationNaturalisedBody(String name, String nation) {
    return 'Играч $name је завршио прелазак и сада може да игра за репрезентацију: $nation. Позови га при избору састава.';
  }

  @override
  String federationCouldNotLoadOffer(String error) {
    return 'Понуда није могла да се учита.\n$error';
  }

  @override
  String get federationContinue => 'Настави';

  @override
  String get federationOfferToSwitchAllegiance =>
      'ПОНУДА ЗА ПРОМЕНУ РЕПРЕЗЕНТАЦИЈЕ';

  @override
  String federationPlayerMeta(String position, int age, String nation) {
    return '$position · $age год. · из земље: $nation';
  }

  @override
  String federationNaturalisationBlurb(
    String name,
    String playerNation,
    String sourceNation,
  ) {
    return 'Играч $name, повезан са земљом $playerNation, спреман је на натурализацију. Прихвати и можеш да га бираш; одбиј и остаје у репрезентацији: $sourceNation.';
  }

  @override
  String get federationDecline => 'Одбиј';

  @override
  String get federationNaturalise => 'Натурализуј';

  @override
  String get federationBudgetLater => 'Одлучи касније';

  @override
  String get federationSetYourBudget => 'ОДРЕДИ БУЏЕТ';

  @override
  String federationCouldNotLoadFinances(String error) {
    return 'Финансије нису могле да се учитају.\n$error';
  }

  @override
  String get federationSaveNotFound => 'Сачувана игра није пронађена.';

  @override
  String get federationBudgetHeading => 'БУЏЕТ САВЕЗА';

  @override
  String federationDistributeBudget(String amount) {
    return 'Распореди $amount по одељењима да отвориш циклус. Потроши паметно.';
  }

  @override
  String federationOverBudget(String amount) {
    return '$amount више него што савез има. Врати нешто назад';
  }

  @override
  String get federationAllocateFullBudget =>
      'Распореди цео буџет да започнеш циклус.';

  @override
  String get federationConfirming => 'Потврђујем…';

  @override
  String get federationConfirmBudget => 'Потврди буџет';

  @override
  String get federationFinances => 'ФИНАНСИЈЕ';

  @override
  String get federationInvestmentUpdated => 'Улагање ажурирано.';

  @override
  String get federationDevelopment => 'РАЗВОЈ САВЕЗА';

  @override
  String get federationProjectedAtSeasonEnd => 'ПРОЦЕНА НА КРАЈУ СЕЗОНЕ';

  @override
  String get federationCentralFunding => 'Централно финансирање';

  @override
  String get federationPrizeMoneySoFar => 'Досадашња наградна средства';

  @override
  String get federationCommercialReturn => 'Комерцијални приход';

  @override
  String get federationThisSeasonLocked => 'ОВА СЕЗОНА (ЗАКЉУЧАНО)';

  @override
  String get federationInvestForNextSeason => 'УЛОЖИ ЗА СЛЕДЕЋУ СЕЗОНУ';

  @override
  String get federationNextSeasonImpact => 'ЕФЕКАТ У СЛЕДЕЋОЈ СЕЗОНИ';

  @override
  String get federationSaving => 'Чувам…';

  @override
  String get federationConfirmInvestment => 'Потврди улагање';

  @override
  String get federationBalance => 'СТАЊЕ САВЕЗА';

  @override
  String get federationCommittedToStaff => 'Обавезе према стручном штабу';

  @override
  String get federationFreeToSpend => 'Слободно за трошење';

  @override
  String get federationWagesNote =>
      'Плате се скидају са стања на крају циклуса, па је толико већ резервисано.';

  @override
  String get federationInvestAtCeremony =>
      'Уложи за следећу сезону на церемонији на крају циклуса.';

  @override
  String federationLevelBadge(int level) {
    return 'Н$level';
  }

  @override
  String get federationAcademyProspects => 'Таленти из академије';

  @override
  String federationPlusOverall(int value) {
    return '+$value укупне оцене';
  }

  @override
  String get federationInjuryRisk => 'Ризик од повреда';

  @override
  String get federationNaturalisationChance => 'Шанса за натурализацију';

  @override
  String get federationBoardPatience => 'Стрпљење управе';

  @override
  String get federationUnallocated => 'НЕРАСПОРЕЂЕНО';

  @override
  String get nationsVitrineTitle => 'ВИТРИНА РЕПРЕЗЕНТАЦИЈЕ';

  @override
  String nationsCouldNotLoad(String error) {
    return 'Земља није могла да се учита.\n$error';
  }

  @override
  String get nationsNoNation => 'Нема земље.';

  @override
  String get nationsHonours => 'ТРОФЕЈИ';

  @override
  String get nationsRankingHistory => 'ИСТОРИЈА СВЕТСКЕ РАНГ-ЛИСТЕ';

  @override
  String get nationsTopScorers => 'НАЈБОЉИ СТРЕЛЦИ СВИХ ВРЕМЕНА';

  @override
  String get nationsTitles => 'ТРОФЕЈИ';

  @override
  String get nationsYourTeam => 'ТВОЈА РЕПРЕЗЕНТАЦИЈА';

  @override
  String get nationsWorld => 'СВЕТ';

  @override
  String get nationsWorldCup => 'Светско првенство';

  @override
  String get nationsContinental => 'Континентално';

  @override
  String nationsAppearances(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count наступа',
      few: '$count наступа',
      one: '$count наступ',
    );
    return '$_temp0';
  }

  @override
  String get nationsNotEnoughHistory =>
      'Историје још нема довољно. Врати се после циклуса или два.';

  @override
  String nationsBestRank(int rank) {
    return 'Најбоље: #$rank';
  }

  @override
  String nationsNowRank(int rank) {
    return 'Сада: #$rank';
  }

  @override
  String get nationsNoGoals => 'Још нема забележених голова.';

  @override
  String get nationsGoalsAbbrev => 'гол.';

  @override
  String get nationsHosts => 'ДОМАЋИН';

  @override
  String get nationsSelectTitle => 'ИЗАБЕРИ РЕПРЕЗЕНТАЦИЈУ';

  @override
  String nationsCouldNotLoadNations(String error) {
    return 'Земље нису могле да се учитају.\n$error';
  }

  @override
  String get nationsNoMatch => 'Ниједна земља не одговара.';

  @override
  String get nationsSelectHeading => 'Изабери репрезентацију';

  @override
  String get nationsSearchHint => 'Тражи државу…';

  @override
  String get nationsRank => 'РАНГ ';

  @override
  String get nationsPremium => 'PREMIUM';

  @override
  String get nationsSelect => 'ИЗАБЕРИ';

  @override
  String get statsTeamRecords => 'РЕКОРДИ РЕПРЕЗЕНТАЦИЈЕ';

  @override
  String get statsRecordBook => 'Књига рекорда';

  @override
  String statsCouldNotLoadStats(String error) {
    return 'Статистика није могла да се учита.\n$error';
  }

  @override
  String get statsNoData => 'Нема података.';

  @override
  String get statsTopScorers => 'НАЈБОЉИ СТРЕЛЦИ';

  @override
  String get statsMostGamesPlayed => 'НАЈВИШЕ ОДИГРАНИХ УТАКМИЦА';

  @override
  String get statsTeam => 'Тим';

  @override
  String get statsTopScorersShort => 'Стрелци';

  @override
  String get statsMostGames => 'Највише утакмица';

  @override
  String get statsMostGamesShort => 'Утакмице';

  @override
  String get statsNoGoalsRecorded => 'Још нема забележених голова.';

  @override
  String get statsUnknown => 'Непознато';

  @override
  String get playerTitle => 'ИГРАЧ';

  @override
  String playerLoadError(String error) {
    return 'Играч није могао да се учита.\n$error';
  }

  @override
  String get playerNotFound => 'Играч није пронађен.';

  @override
  String get playerClub => 'КЛУБ';

  @override
  String get playerClubRole => 'У свом клубу';

  @override
  String get playerPosition => 'Позиција';

  @override
  String get playerPotential => 'Потенцијал';

  @override
  String get playerAge => 'Године';

  @override
  String get playerValue => 'Вредност';

  @override
  String get clubFirstChoice => 'Игра сваке недеље';

  @override
  String get clubRotation => 'Час игра, час не';

  @override
  String get clubFringe => 'Једва игра';

  @override
  String get clubFrozenOut => 'Не игра';

  @override
  String clubAtClub(String club, String standing) {
    return '$club: $standing';
  }

  @override
  String yWinUpset0(String opponent, String score) {
    return 'Гледам фудбал тридесет година и ово нисам очекивао. $opponent $score.';
  }

  @override
  String yWinUpset1(String opponent, String score) {
    return 'Нико им није давао шансе. $opponent $score. Баш нико.';
  }

  @override
  String yWinUpset2(String opponent, String score) {
    return '$opponent $score. Идите и пробудите комшије.';
  }

  @override
  String yWinUpset3(String opponent, String score) {
    return 'Овакве ноћи се причају унуцима. $opponent $score.';
  }

  @override
  String yWinUpset4(String opponent, String score) {
    return '$opponent $score. Како год да се то десило, десило се.';
  }

  @override
  String yWinUpset5(String opponent, String score) {
    return 'На папиру је било готово пре почетка. $opponent $score каже другачије.';
  }

  @override
  String yWinUpset6(String opponent, String score) {
    return '$opponent $score. За годину дана нико неће веровати у тај резултат.';
  }

  @override
  String yWinUpset7(String opponent, String score) {
    return '$opponent $score. Уживај, па погледај распоред утакмица.';
  }

  @override
  String yWinUpset8(String opponent, String score) {
    return '$opponent $score, а ми смо осамдесет од деведесет минута јахали на срећи.';
  }

  @override
  String yWinUpset9(String opponent, String score) {
    return '$opponent $score. Једно вече не брише годину.';
  }

  @override
  String yWinUpset10(String opponent, String score) {
    return '$opponent $score, а сад ће нам рећи да смо кренули правим путем. Нисмо.';
  }

  @override
  String yWinUpset11(String opponent, String score) {
    return '$opponent $score. Дивно. Питај ме опет кад буде битно.';
  }

  @override
  String yWinRoutine0(String opponent, String score) {
    return '$opponent $score. Тачно како треба, а у томе има задовољства.';
  }

  @override
  String yWinRoutine1(String opponent, String score) {
    return '$opponent $score. Немилосрдно, а немилосрдно је комплимент.';
  }

  @override
  String yWinRoutine2(String opponent, String score) {
    return '$opponent $score. Без драме, без страха, без замерки.';
  }

  @override
  String yWinRoutine3(String opponent, String score) {
    return 'Уредан резултат: $opponent $score. Тако изгледа добар тим у мирном дану.';
  }

  @override
  String yWinRoutine4(String opponent, String score) {
    return '$opponent $score. Посао завршен, ништа научено.';
  }

  @override
  String yWinRoutine5(String opponent, String score) {
    return '$opponent $score. Требало је да победимо и јесмо.';
  }

  @override
  String yWinRoutine6(String opponent, String score) {
    return 'Професионално: $opponent $score. Следећи.';
  }

  @override
  String yWinRoutine7(String opponent, String score) {
    return '$opponent $score. Стави то у фиоку и идемо даље.';
  }

  @override
  String yWinRoutine8(String opponent, String score) {
    return '$opponent $score и сад би требало да аплаудирамо. Зато што смо их победили.';
  }

  @override
  String yWinRoutine9(String opponent, String score) {
    return 'Свака част свима, ваљда. $opponent $score.';
  }

  @override
  String yWinRoutine10(String opponent, String score) {
    return '$opponent $score. Победа над оваквима је минимум, а не достигнуће.';
  }

  @override
  String yWinRoutine11(String opponent, String score) {
    return '$opponent $score. Победили смо, али се видело да се мучимо.';
  }

  @override
  String yWinTight0(String opponent, String score) {
    return '$opponent $score и сваки минут заслужен.';
  }

  @override
  String yWinTight1(String opponent, String score) {
    return 'Требао је карактер. $opponent $score.';
  }

  @override
  String yWinTight2(String opponent, String score) {
    return '$opponent $score, на тежи начин, а то је онај начин који траје.';
  }

  @override
  String yWinTight3(String opponent, String score) {
    return '$opponent $score. Екипе које добијају овакве утакмице остају до јуна.';
  }

  @override
  String yWinTight4(String opponent, String score) {
    return 'Нервозно, ружно, али победа. $opponent $score.';
  }

  @override
  String yWinTight5(String opponent, String score) {
    return '$opponent $score. Узми три бода и никад више не гледај снимак.';
  }

  @override
  String yWinTight6(String opponent, String score) {
    return '$opponent $score. Сваки центиметар смо морали да изборимо.';
  }

  @override
  String yWinTight7(String opponent, String score) {
    return '$opponent $score. Није лепо. Вреди исто.';
  }

  @override
  String yWinTight8(String opponent, String score) {
    return '$opponent $score, а ми смо себи то отежали десет пута више него што је требало.';
  }

  @override
  String yWinTight9(String opponent, String score) {
    return 'Не би смело да се овако мучимо. $opponent $score.';
  }

  @override
  String yWinTight10(String opponent, String score) {
    return '$opponent $score. Победили смо, а о себи нисмо научили ништа добро.';
  }

  @override
  String yWinTight11(String opponent, String score) {
    return '$opponent $score, резултат који нам је ласкао.';
  }

  @override
  String yDrew0(String opponent, String score) {
    return 'Бод. $opponent $score. Узми га и идемо даље.';
  }

  @override
  String yDrew1(String opponent, String score) {
    return '$opponent $score. Било је и горих поподнева.';
  }

  @override
  String yDrew2(String opponent, String score) {
    return '$opponent $score. Не мора свака утакмица да буде прича.';
  }

  @override
  String yDrew3(String opponent, String score) {
    return '$opponent $score. Бод је бод, а табела не пита како.';
  }

  @override
  String yDrew4(String opponent, String score) {
    return '$opponent $score. Два бода изгубљена или један добијен. Бирај расположење.';
  }

  @override
  String yDrew5(String opponent, String score) {
    return 'Нерешено. $opponent $score. Нико није срећан, нико није бесан.';
  }

  @override
  String yDrew6(String opponent, String score) {
    return '$opponent $score. Најзаборавнијих деведесет минута године.';
  }

  @override
  String yDrew7(String opponent, String score) {
    return '$opponent $score. Подељен плен. Идемо даље.';
  }

  @override
  String yDrew8(String opponent, String score) {
    return '$opponent $score. Оваквим ремијима кампање тихо умиру.';
  }

  @override
  String yDrew9(String opponent, String score) {
    return 'Два бода бачена. $opponent $score. Другачије то не може да се назове.';
  }

  @override
  String yDrew10(String opponent, String score) {
    return '$opponent $score. Имали смо деведесет минута и никакву идеју шта да радимо с њима.';
  }

  @override
  String yDrew11(String opponent, String score) {
    return '$opponent $score, резултат који нико неће памтити, а сви ће га платити.';
  }

  @override
  String yLost0(String opponent, String score) {
    return 'Пораз. $opponent $score. Дешава се.';
  }

  @override
  String yLost1(String opponent, String score) {
    return '$opponent $score. Нема због чега некога вешати. Идемо на следећу.';
  }

  @override
  String yLost2(String opponent, String score) {
    return '$opponent $score. Дали смо све. Неких дана то није довољно.';
  }

  @override
  String yLost3(String opponent, String score) {
    return '$opponent $score. Главу горе. У овом тиму има још много.';
  }

  @override
  String yLost4(String opponent, String score) {
    return '$opponent $score. Били смо слабији и ту нема расправе.';
  }

  @override
  String yLost5(String opponent, String score) {
    return '$opponent $score. Треба се прегруписати.';
  }

  @override
  String yLost6(String opponent, String score) {
    return '$opponent $score. Није срамота, али није довољно добро.';
  }

  @override
  String yLost7(String opponent, String score) {
    return '$opponent $score. Научи нешто из тога или је све било узалуд.';
  }

  @override
  String yLost8(String opponent, String score) {
    return '$opponent $score, а нисмо их ни окрзнули.';
  }

  @override
  String yLost9(String opponent, String score) {
    return '$opponent $score. Исти проблеми, исти месец, иста оправдања на путу.';
  }

  @override
  String yLost10(String opponent, String score) {
    return '$opponent $score. Када ће ово престати да буде лоша срећа?';
  }

  @override
  String yLost11(String opponent, String score) {
    return '$opponent $score. Овакав резултат мора некога да кошта.';
  }

  @override
  String yLostBadly0(String opponent, String score) {
    return '$opponent $score. Једна лоша ноћ. Суди тиму по кампањи, не по овоме.';
  }

  @override
  String yLostBadly1(String opponent, String score) {
    return 'Нико није желео тај резултат, $opponent $score, мање од самих играча.';
  }

  @override
  String yLostBadly2(String opponent, String score) {
    return '$opponent $score. Ружно, и то није оно што овај тим јесте.';
  }

  @override
  String yLostBadly3(String opponent, String score) {
    return '$opponent $score, резултат за заборав. Следећи пут ће се поправити.';
  }

  @override
  String yLostBadly4(String opponent, String score) {
    return '$opponent $score. Немам речи, а плаћен сам да их имам.';
  }

  @override
  String yLostBadly5(String opponent, String score) {
    return '$opponent $score. Неко за то мора да одговара.';
  }

  @override
  String yLostBadly6(String opponent, String score) {
    return 'Желим да се $opponent $score избрише из записника и из сећања.';
  }

  @override
  String yLostBadly7(String opponent, String score) {
    return '$opponent $score. Овакав резултат нема смисла улепшавати.';
  }

  @override
  String yLostBadly8(String opponent, String score) {
    return 'То није био пораз, то је била предаја. $opponent $score.';
  }

  @override
  String yLostBadly9(String opponent, String score) {
    return '$opponent $score. Људи су платили да гледају ово.';
  }

  @override
  String yLostBadly10(String opponent, String score) {
    return '$opponent $score. Ако ово ништа не промени, неће ништа.';
  }

  @override
  String yLostBadly11(String opponent, String score) {
    return 'Видео сам овај тим и пониженог, али $opponent $score је ново дно.';
  }

  @override
  String yWinUpset12(String opponent, String score) {
    return 'Победа $score против екипе $opponent. Запишите датум, питаће вас где сте били.';
  }

  @override
  String yWinUpset13(String opponent, String score) {
    return 'Ван свлачионице нико није веровао. $score против екипе $opponent. Понос је премала реч.';
  }

  @override
  String yWinUpset14(String opponent, String score) {
    return '$score против екипе $opponent! Сви су трчали док није остало ништа.';
  }

  @override
  String yWinUpset15(String opponent, String score) {
    return 'Убице дивова. $opponent, $score. Зато увек долазимо.';
  }

  @override
  String yWinUpset16(String opponent, String score) {
    return '$score против екипе $opponent. Прогнозе су управо излетеле кроз прозор.';
  }

  @override
  String yWinUpset17(String opponent, String score) {
    return 'Велики фаворит: $opponent. Коначан резултат: $score за нас.';
  }

  @override
  String yWinUpset18(String opponent, String score) {
    return 'Једно од изненађења године: $score против екипе $opponent.';
  }

  @override
  String yWinUpset19(String opponent, String score) {
    return '$opponent $score. Нико то није предвидео и нико не уме то да објасни.';
  }

  @override
  String yWinUpset20(String opponent, String score) {
    return '$score против екипе $opponent. Предивно. Сад ће сви заборавити колико је остатак године био лош.';
  }

  @override
  String yWinUpset21(String opponent, String score) {
    return '$score против екипе $opponent и воз је већ пун. Ја сам био у њему док је био празан.';
  }

  @override
  String yWinUpset22(String opponent, String score) {
    return '$opponent $score. Сјајно, а ипак ће наћи начин да то баце.';
  }

  @override
  String yWinUpset23(String opponent, String score) {
    return 'Велико вече против екипе $opponent, $score. Једна ласта не чини пролеће.';
  }

  @override
  String yLostBadly12(String opponent, String score) {
    return '$score против екипе $opponent. Боли јер нам је стало. Подржимо их свеједно.';
  }

  @override
  String yLostBadly13(String opponent, String score) {
    return 'Вече за заборав против екипе $opponent, $score. Играче боли највише.';
  }

  @override
  String yLostBadly14(String opponent, String score) {
    return '$opponent $score. Главу горе. Тим се цени по томе како одговори на ово.';
  }

  @override
  String yLostBadly15(String opponent, String score) {
    return '$score против екипе $opponent. Лоше, да. Смак света, не.';
  }

  @override
  String yLostBadly16(String opponent, String score) {
    return '$score против екипе $opponent. О овом резултату причаће се годинама, из погрешних разлога.';
  }

  @override
  String yLostBadly17(String opponent, String score) {
    return 'Победа за екипу $opponent, $score. После овога нека се нико не чуди следећи пут.';
  }

  @override
  String yLostBadly18(String opponent, String score) {
    return 'Једно од најгорих вечери у дуго времена: $score против екипе $opponent.';
  }

  @override
  String yLostBadly19(String opponent, String score) {
    return '$opponent $score. Биће питања, и с правом.';
  }

  @override
  String yLostBadly20(String opponent, String score) {
    return '$score против екипе $opponent. Срамотно је преблага реч.';
  }

  @override
  String yLostBadly21(String opponent, String score) {
    return 'Пораз $score против екипе $opponent. Последњи нека угаси светло.';
  }

  @override
  String yLostBadly22(String opponent, String score) {
    return '$opponent $score. Више ме не изненађује, и то ме плаши.';
  }

  @override
  String yLostBadly23(String opponent, String score) {
    return '$score. $opponent. Неко горе би вечерас требало да ажурира CV.';
  }

  @override
  String yWinRout0(String opponent, String score) {
    return '$score против екипе $opponent! Овакав фудбал целу земљу тера на осмех.';
  }

  @override
  String yWinRout1(String opponent, String score) {
    return 'Екипа $opponent разбијена, $score. Какав наступ.';
  }

  @override
  String yWinRout2(String opponent, String score) {
    return '$score. Против екипе $opponent. Вечерас је успело све.';
  }

  @override
  String yWinRout3(String opponent, String score) {
    return 'Рушење $score против екипе $opponent. Сачувајте снимак, требаће вам.';
  }

  @override
  String yWinRout4(String opponent, String score) {
    return '$opponent $score. То је тим који ужива у свом фудбалу.';
  }

  @override
  String yWinRout5(String opponent, String score) {
    return '$score против екипе $opponent, а могло је и више. Величанствено.';
  }

  @override
  String yWinRout6(String opponent, String score) {
    return '$score против екипе $opponent. Резултат који се гледа двапут.';
  }

  @override
  String yWinRout7(String opponent, String score) {
    return 'Победа $score против екипе $opponent. После пола сата утакмице више није било.';
  }

  @override
  String yWinRout8(String opponent, String score) {
    return 'Коначан резултат: $score против екипе $opponent. Убедљиво највећа победа у дуго времена.';
  }

  @override
  String yWinRout9(String opponent, String score) {
    return '$opponent $score. Једни су дошли да играју, други нису ни изашли из аутобуса.';
  }

  @override
  String yWinRout10(String opponent, String score) {
    return '$score. Екипа $opponent није имала одговор ни на шта.';
  }

  @override
  String yWinRout11(String opponent, String score) {
    return 'Батине: $score против екипе $opponent.';
  }

  @override
  String yWinRout12(String opponent, String score) {
    return '$score против екипе $opponent. Лепо, али они баш нису мерило.';
  }

  @override
  String yWinRout13(String opponent, String score) {
    return '$score против екипе $opponent. Пробудите ме кад то урадимо неком добром.';
  }

  @override
  String yWinRout14(String opponent, String score) {
    return '$opponent $score. Забавно, али видео сам тимове који су овако блистали и нису освојили ништа.';
  }

  @override
  String yWinRout15(String opponent, String score) {
    return '$score, и сви су опет генијалци. Противник је био $opponent.';
  }

  @override
  String yWinRout16(String opponent, String score) {
    return '$score против екипе $opponent. Без занашања, то мало доказује.';
  }

  @override
  String yWinRout17(String opponent, String score) {
    return '$opponent $score. Уживајте, а онда се сетите како се завршило последњи пут кад смо се занели.';
  }

  @override
  String yWinShootout0(String opponent) {
    return 'Пролаз после пенала против екипе $opponent! Челични живци, сви до једног.';
  }

  @override
  String yWinShootout1(String opponent) {
    return 'Пенали против екипе $opponent, и издржали смо. Загрлите странца.';
  }

  @override
  String yWinShootout2(String opponent) {
    return 'Пенал-серија против екипе $opponent добијена. Срце ми ово не може поднети.';
  }

  @override
  String yWinShootout3(String opponent) {
    return 'Победа после пенала против екипе $opponent. Идемо у следећу рунду.';
  }

  @override
  String yWinShootout4(String opponent) {
    return 'Против екипе $opponent одлучивала је бела тачка, а ми смо дали више.';
  }

  @override
  String yWinShootout5(String opponent) {
    return 'Пенал-серија добијена против екипе $opponent. Најтежим путем, али пролаз.';
  }

  @override
  String yWinShootout6(String opponent) {
    return 'Пролаз после пенала против екипе $opponent. Лутрија добијена, игру заборавимо.';
  }

  @override
  String yWinShootout7(String opponent) {
    return 'Победити тим $opponent на пенале после онакве игре? Срећа, и сви то знају.';
  }

  @override
  String yWinShootout8(String opponent) {
    return 'Пролаз против тима $opponent на пенале. До тога није смело ни да дође.';
  }

  @override
  String yKnockoutWin0(String opponent, String score) {
    return 'ПРОЛАЗ. $score против тима $opponent, и сан живи.';
  }

  @override
  String yKnockoutWin1(String opponent, String score) {
    return 'ПОБЕДА У НОКАУТ ФАЗИ: $score против тима $opponent. Земља може да почне да верује.';
  }

  @override
  String yKnockoutWin2(String opponent, String score) {
    return '$score против тима $opponent и идемо у следеће коло. Какво вече.';
  }

  @override
  String yKnockoutWin3(String opponent, String score) {
    return 'Тим $opponent иде кући, $score. Напред.';
  }

  @override
  String yKnockoutWin4(String opponent, String score) {
    return 'НОКАУТ ФАЗА: $score против тима $opponent. Следеће коло потврђено.';
  }

  @override
  String yKnockoutWin5(String opponent, String score) {
    return 'Пролаз: $score против тима $opponent.';
  }

  @override
  String yKnockoutWin6(String opponent, String score) {
    return 'Тим $opponent испада, $score. Чека нас следеће коло.';
  }

  @override
  String yKnockoutWin7(String opponent, String score) {
    return 'Победа $score против тима $opponent. У нокаут фази нико не пита како.';
  }

  @override
  String yKnockoutWin8(String opponent, String score) {
    return 'Пролаз против тима $opponent, $score. Следећи противник неће бити тако љубазан.';
  }

  @override
  String yKnockoutWin9(String opponent, String score) {
    return '$score против тима $opponent довољно је за пролаз. Следећи пут требаће много више.';
  }

  @override
  String yKnockoutWin10(String opponent, String score) {
    return 'Тим $opponent је напољу, $score. Више смо преживели него победили.';
  }

  @override
  String yKnockoutWin11(String opponent, String score) {
    return 'У следећем колу после $score против тима $opponent. Не питајте како.';
  }

  @override
  String yUpsetGap0(String opponent, int gap) {
    String _temp0 = intl.Intl.pluralLogic(
      gap,
      locale: localeName,
      other: '$gap места',
      few: '$gap места',
      one: '$gap место',
    );
    return 'На ранг-листи нас је делило $_temp0, а ипак смо победили. Противник: $opponent. Величанствено.';
  }

  @override
  String yUpsetGap1(String opponent, int gap) {
    String _temp0 = intl.Intl.pluralLogic(
      gap,
      locale: localeName,
      other: '$gap места',
      few: '$gap места',
      one: '$gap место',
    );
    return '$opponent: $_temp0 изнад нас. Савладани. Фудбал је диван.';
  }

  @override
  String yUpsetGap2(String opponent, int gap) {
    return 'Разлика на ранг-листи: $gap. Резултат: победа, противник: $opponent. Никад не престајте да верујете.';
  }

  @override
  String yUpsetGap3(String opponent, int gap) {
    return 'Разлика на ранг-листи пре почетка: $gap. Тим $opponent ипак савладан.';
  }

  @override
  String yUpsetGap4(String opponent, int gap) {
    String _temp0 = intl.Intl.pluralLogic(
      gap,
      locale: localeName,
      other: '$gap места',
      few: '$gap места',
      one: '$gap место',
    );
    return 'На светској ранг-листи тим $opponent био је $_temp0 изнад нас. Не вечерас.';
  }

  @override
  String yUpsetGap5(String opponent, int gap) {
    String _temp0 = intl.Intl.pluralLogic(
      gap,
      locale: localeName,
      other: '$gap места',
      few: '$gap места',
      one: '$gap место',
    );
    return 'Индекс изненађења: $_temp0 на ранг-листи између тимова. Победа наша, противник: $opponent.';
  }

  @override
  String yUpsetGap6(String opponent, int gap) {
    String _temp0 = intl.Intl.pluralLogic(
      gap,
      locale: localeName,
      other: '$gap места',
      few: '$gap места',
      one: '$gap место',
    );
    return '$_temp0 на ранг-листи делило нас је од тима $opponent. Једно вече не затвара ту разлику.';
  }

  @override
  String yUpsetGap7(String opponent, int gap) {
    String _temp0 = intl.Intl.pluralLogic(
      gap,
      locale: localeName,
      other: '$gap места',
      few: '$gap места',
      one: '$gap место',
    );
    return '$opponent: $_temp0 изнад, а ипак пораз за њих. Ранг-листа ће то једва приметити.';
  }

  @override
  String yUpsetGap8(int gap) {
    return 'Разлика на ранг-листи: $gap. Запамтите тај број следећи пут кад изгубимо од аутсајдера.';
  }

  @override
  String yEatWords0(String opponent) {
    return 'Отписао сам ову екипу. Погрешио сам, и никад нисам био срећнији што сам погрешио. Противник: $opponent.';
  }

  @override
  String yEatWords1(String opponent) {
    return 'Порцију скромности, молим. Велику. Победа против тима $opponent била је величанствена.';
  }

  @override
  String yEatWords2(String opponent) {
    return 'Рекао сам да немају више ништа. Имали су и те како. Свака част свима против тима $opponent.';
  }

  @override
  String yEatWords3(String opponent) {
    return 'Да се зна: ту победу против тима $opponent нисам видео. Свака част.';
  }

  @override
  String yEatWords4(String opponent) {
    return 'Добро. Рекао сам да ће их раскринкати. Тим $opponent није успео.';
  }

  @override
  String yEatWords5(String opponent) {
    return 'Вечерас једем своје речи о овој екипи. Победа против тима $opponent то заслужује.';
  }

  @override
  String yEatWords6(String opponent) {
    return 'Да, рекао сам да су готови. Једна победа против тима $opponent још не доказује да сам погрешио.';
  }

  @override
  String yEatWords7(String opponent) {
    return 'Кажу да морам да поједем своје речи после тима $opponent. Хоћу, полако, а рачун чувам.';
  }

  @override
  String yEatWords8(String opponent) {
    return 'Победа против тима $opponent била је импресивна. Моје сумње у ову екипу нису нестале.';
  }

  @override
  String yAwayFansWin0(String nation, String score) {
    return 'Свака част тиму $nation. $score, и заслужено од почетка до краја.';
  }

  @override
  String yAwayFansWin1(String nation, String score) {
    return 'Боли то рећи, али вечерас је бољи био тим $nation. $score. Честитке.';
  }

  @override
  String yAwayFansWin2(String nation, String score) {
    return '$score. Капа доле тиму $nation, више су желели.';
  }

  @override
  String yAwayFansWin3(String nation, String score) {
    return 'Пораз $score против тима $nation. Не знам ни шта да кажем.';
  }

  @override
  String yAwayFansWin4(String nation, String score) {
    return '$nation $score. Наши би требало да се стиде.';
  }

  @override
  String yAwayFansWin5(String nation, String score) {
    return '$score против тима $nation. Нека ми неко објасни како се то десило.';
  }

  @override
  String yAwayFansWin6(String nation, String score) {
    return 'Изгубити $score од тима $nation. Ово никад нећу преболети.';
  }

  @override
  String yAwayFansWin7(String nation, String score) {
    return '$score против тима $nation. Срећа. Чиста срећа.';
  }

  @override
  String yAwayFansWin8(String nation, String score) {
    return 'После тог $score навијачи тима $nation биће неподношљиви годинама. Хвала ни на чему.';
  }

  @override
  String yNeutralWin0(String nation, String opponent, String score) {
    return '$nation $score $opponent. Сјајно за фудбал. Зато га волимо.';
  }

  @override
  String yNeutralWin1(String nation, String opponent, String score) {
    return 'Какав резултат: $nation $score $opponent. Фудбал у најбољем издању.';
  }

  @override
  String yNeutralWin2(String nation, String opponent, String score) {
    return 'Сви неутрални вечерас навијају за тим $nation. $score против тима $opponent!';
  }

  @override
  String yNeutralWin3(String nation, String opponent, String score) {
    return 'Резултат кола: $nation $score $opponent.';
  }

  @override
  String yNeutralWin4(String nation, String opponent, String score) {
    return '$nation $score $opponent. То нико није имао на тикету.';
  }

  @override
  String yNeutralWin5(String nation, String opponent, String score) {
    return 'Велики резултат: $nation $score $opponent. Ранг-листа ће се померити.';
  }

  @override
  String yNeutralWin6(String nation, String opponent, String score) {
    return '$nation $score $opponent. Забавно, да видимо могу ли то да понове.';
  }

  @override
  String yNeutralWin7(String nation, String opponent, String score) {
    return '$nation $score $opponent. Да ли је победио $nation или је изгубио $opponent?';
  }

  @override
  String yNeutralWin8(String nation, String opponent, String score) {
    return 'Сензација: $nation $score $opponent. Очекујте много претераних реакција.';
  }

  @override
  String yScorerHero0(String name, String opponent) {
    return '$name против тима $opponent. Деци ће давати његово име.';
  }

  @override
  String yScorerHero1(String name, String opponent) {
    return 'Споменик за играча: $name. Вечерас против тима $opponent био је све.';
  }

  @override
  String yScorerHero2(String name, String opponent) {
    return '$name, какав играч. Запамтите ово вече против тима $opponent.';
  }

  @override
  String yScorerHero3(String name, String opponent) {
    return '$name је одлучио против тима $opponent. Играч утакмице, без расправе.';
  }

  @override
  String yScorerHero4(String name, String opponent) {
    return 'Против тима $opponent вече је припало једном човеку: $name.';
  }

  @override
  String yScorerHero5(String name, String opponent) {
    return '$name се појавио кад је требало, против тима $opponent.';
  }

  @override
  String yScorerHero6(String name, String opponent) {
    return '$name је био сјајан против тима $opponent. Сад сваке недеље.';
  }

  @override
  String yScorerHero7(String name, String opponent) {
    return '$name је спасао екипу против тима $opponent. Остали нису много помогли.';
  }

  @override
  String yScorerHero8(String name, String opponent) {
    return 'Без играча $name то би било сасвим другачије вече против тима $opponent.';
  }

  @override
  String yLostShock0(String opponent, String score) {
    return '$score против тима $opponent. Незгода. Свакоме се деси једном.';
  }

  @override
  String yLostShock1(String opponent, String score) {
    return 'Пораз $score против тима $opponent. Отресите то, кампања није готова.';
  }

  @override
  String yLostShock2(String opponent, String score) {
    return '$opponent $score. Боли, али један резултат не дефинише овај тим.';
  }

  @override
  String yLostShock3(String opponent, String score) {
    return '$score против тима $opponent. Лош дан на послу. Даље.';
  }

  @override
  String yLostShock4(String opponent, String score) {
    return 'Пораз против тима $opponent, $score. Нико то није очекивао.';
  }

  @override
  String yLostShock5(String opponent, String score) {
    return '$opponent $score. Једно од оних вечери које немају смисла.';
  }

  @override
  String yLostShock6(String opponent, String score) {
    return '$score против тима $opponent. Пораз који ће се памтити.';
  }

  @override
  String yLostShock7(String opponent, String score) {
    return 'Поражени од тима $opponent, $score. Сензација како год гледали.';
  }

  @override
  String yLostShock8(String opponent, String score) {
    return '$score против тима $opponent. Од таквог противника! Неприхватљиво.';
  }

  @override
  String yLostShock9(String opponent, String score) {
    return 'Пораз $score против тима $opponent. Хоћу објашњење, не изговоре.';
  }

  @override
  String yLostShock10(String opponent, String score) {
    return '$opponent $score. Национална срамота, и то није фигура.';
  }

  @override
  String yLostShock11(String opponent, String score) {
    return '$score против тима $opponent. Како ико горе још седи на свом месту?';
  }

  @override
  String yLostRout0(String opponent, String score) {
    return '$score против тима $opponent. То је врхунски тим. Учимо.';
  }

  @override
  String yLostRout1(String opponent, String score) {
    return 'Надиграни од тима $opponent, $score. Није срамота изгубити од најбољих.';
  }

  @override
  String yLostRout2(String opponent, String score) {
    return '$opponent $score. Лекција, а на лекцијама се расте.';
  }

  @override
  String yLostRout3(String opponent, String score) {
    return '$score против тима $opponent. Боли, али они су ниво изнад.';
  }

  @override
  String yLostRout4(String opponent, String score) {
    return 'Победа за тим $opponent, $score. Разлика је стварна, и сад су је сви видели.';
  }

  @override
  String yLostRout5(String opponent, String score) {
    return '$score против тима $opponent. Батине, ништа друго.';
  }

  @override
  String yLostRout6(String opponent, String score) {
    return '$opponent $score. Бољи тим, и резултат то каже.';
  }

  @override
  String yLostRout7(String opponent, String score) {
    return 'Пораз $score против тима $opponent. Није срамота, али није било ни утакмице.';
  }

  @override
  String yLostRout8(String opponent, String score) {
    return '$score против тима $opponent. Бољи противник или не, тако се не губи.';
  }

  @override
  String yLostRout9(String opponent, String score) {
    return '$opponent $score. Да ли смо уопште покушали да се надмећемо?';
  }

  @override
  String yLostRout10(String opponent, String score) {
    return '$score. Против тима $opponent. Као јагњад на клање.';
  }

  @override
  String yLostRout11(String opponent, String score) {
    return 'Пораз $score против тима $opponent, и нико није деловао забринуто.';
  }

  @override
  String yLostShootout0(String opponent) {
    return 'Испали после пенала против тима $opponent. Дали су све. Поносан сам на њих.';
  }

  @override
  String yLostShootout1(String opponent) {
    return 'Пенали против тима $opponent. Најсуровији начин испадања. Главу горе.';
  }

  @override
  String yLostShootout2(String opponent) {
    return 'Изгубљено извођење пенала против тима $opponent. Нико то није заслужио.';
  }

  @override
  String yLostShootout3(String opponent) {
    return 'Испали после пенала против тима $opponent. Одлучила је бела тачка.';
  }

  @override
  String yLostShootout4(String opponent) {
    return 'Тим $opponent пролази после пенала. Наш турнир ту се завршава.';
  }

  @override
  String yLostShootout5(String opponent) {
    return 'Изгубљени пенали против тима $opponent. Опет пенали.';
  }

  @override
  String yLostShootout6(String opponent) {
    return 'Испали после пенала против тима $opponent. Да ли их уопште вежбамо?';
  }

  @override
  String yLostShootout7(String opponent) {
    return 'Пораз на пенале против тима $opponent. Требало је то да решимо много раније.';
  }

  @override
  String yLostShootout8(String opponent) {
    return 'Пенали против тима $opponent, и изгубили смо. Наравно.';
  }

  @override
  String yKnockoutLoss0(String opponent, String score) {
    return 'ИСПАЛИ. $score против тима $opponent. Пут на који можемо бити поносни завршава се овде.';
  }

  @override
  String yKnockoutLoss1(String opponent, String score) {
    return 'Избацио нас је тим $opponent, $score. Хвала на успоменама.';
  }

  @override
  String yKnockoutLoss2(String opponent, String score) {
    return '$score против тима $opponent. Путовање је готово, али какво путовање.';
  }

  @override
  String yKnockoutLoss3(String opponent, String score) {
    return 'ИСПАЛИ: $score против тима $opponent. Главе горе.';
  }

  @override
  String yKnockoutLoss4(String opponent, String score) {
    return 'КРАЈ: $score против тима $opponent.';
  }

  @override
  String yKnockoutLoss5(String opponent, String score) {
    return 'Испали: $score против тима $opponent.';
  }

  @override
  String yKnockoutLoss6(String opponent, String score) {
    return 'Тим $opponent пролази, $score. Наш турнир је готов.';
  }

  @override
  String yKnockoutLoss7(String opponent, String score) {
    return 'Избацио нас је тим $opponent, $score. Обдукција почиње сада.';
  }

  @override
  String yKnockoutLoss8(String opponent, String score) {
    return 'ИСПАЛИ. $score против тима $opponent. Други турнир, исти крај.';
  }

  @override
  String yKnockoutLoss9(String opponent, String score) {
    return '$score против тима $opponent, и кући. Нико није изненађен.';
  }

  @override
  String yKnockoutLoss10(String opponent, String score) {
    return 'Избацио нас је тим $opponent, $score. До јутра очекујте изговоре.';
  }

  @override
  String yKnockoutLoss11(String opponent, String score) {
    return '$opponent $score. Испали, и никад није изгледало да ће се завршити другачије.';
  }

  @override
  String yAwayFansGloat0(String nation, String score) {
    return '$score против тима $nation. Поштовање, вратиће се јачи.';
  }

  @override
  String yAwayFansGloat1(String nation, String score) {
    return 'Добра победа за нас, $score. Лош дан за тим $nation, жао ми је њихових навијача.';
  }

  @override
  String yAwayFansGloat2(String nation, String score) {
    return '$score. Лоше вече за тим $nation, а ми смо искористили прилику. Такав је фудбал.';
  }

  @override
  String yAwayFansGloat3(String nation, String score) {
    return '$score против тима $nation! Ко је то очекивао? Они сигурно не.';
  }

  @override
  String yAwayFansGloat4(String nation, String score) {
    return 'Победа $score против тима $nation. Нека неко провери како су им навијачи.';
  }

  @override
  String yAwayFansGloat5(String nation, String score) {
    return '$nation $score. Ово иде у албум.';
  }

  @override
  String yAwayFansGloat6(String nation, String score) {
    return '$score против тима $nation. А мисле да су велики тим.';
  }

  @override
  String yAwayFansGloat7(String nation, String score) {
    return 'Замисли да изгубиш $score од нас. Питај тим $nation, сад знају.';
  }

  @override
  String yAwayFansGloat8(String nation, String score) {
    return '$nation, $score. Срећан лет кући.';
  }

  @override
  String yNeutralLoss0(String nation, String opponent, String score) {
    return '$nation $score $opponent. Велико вече за $opponent, тешко за $nation.';
  }

  @override
  String yNeutralLoss1(String nation, String opponent, String score) {
    return 'Навијачима тима $nation много снаге после $score против тима $opponent. Устаће.';
  }

  @override
  String yNeutralLoss2(String nation, String opponent, String score) {
    return '$nation $score $opponent. Сваки велики тим има овакво вече.';
  }

  @override
  String yNeutralLoss3(String nation, String opponent, String score) {
    return 'Сензација кола: $nation $score $opponent.';
  }

  @override
  String yNeutralLoss4(String nation, String opponent, String score) {
    return '$nation $score $opponent. То нико није очекивао.';
  }

  @override
  String yNeutralLoss5(String nation, String opponent, String score) {
    return 'Резултат дана: $nation $score $opponent. Сад следе питања за $nation.';
  }

  @override
  String yNeutralLoss6(String nation, String opponent, String score) {
    return '$nation $score $opponent. Није случајност, ако сте пратили.';
  }

  @override
  String yNeutralLoss7(String nation, String opponent, String score) {
    return '$nation $score $opponent. Неко тамо имаће много тога да објашњава.';
  }

  @override
  String yNeutralLoss8(String nation, String opponent, String score) {
    return '$nation $score $opponent. Велико име, мала представа.';
  }

  @override
  String yDownGap0(String opponent, int gap) {
    String _temp0 = intl.Intl.pluralLogic(
      gap,
      locale: localeName,
      other: '$gap места',
      few: '$gap места',
      one: '$gap место',
    );
    return '$opponent: $_temp0 испод нас. Дешава се. Даље.';
  }

  @override
  String yDownGap1(int gap) {
    return 'Разлика на ранг-листи: $gap у нашу корист. Фудбал не чита ранг-листе.';
  }

  @override
  String yDownGap2(String opponent, int gap) {
    String _temp0 = intl.Intl.pluralLogic(
      gap,
      locale: localeName,
      other: '$gap места',
      few: '$gap места',
      one: '$gap место',
    );
    return 'На папиру $_temp0 између нас и тима $opponent. Не на терену вечерас.';
  }

  @override
  String yDownGap3(String opponent, int gap) {
    return 'Разлика на ранг-листи пре почетка: $gap у нашу корист. Ипак пораз, противник: $opponent.';
  }

  @override
  String yDownGap4(String opponent, int gap) {
    String _temp0 = intl.Intl.pluralLogic(
      gap,
      locale: localeName,
      other: '$gap места',
      few: '$gap места',
      one: '$gap место',
    );
    return 'На светској ранг-листи тим $opponent био је $_temp0 испод нас. Резултат: пораз.';
  }

  @override
  String yDownGap5(String opponent, int gap) {
    String _temp0 = intl.Intl.pluralLogic(
      gap,
      locale: localeName,
      other: '$gap места',
      few: '$gap места',
      one: '$gap место',
    );
    return 'Индекс изненађења: $_temp0 на ранг-листи, у погрешном смеру. Противник: $opponent.';
  }

  @override
  String yDownGap6(String opponent, int gap) {
    String _temp0 = intl.Intl.pluralLogic(
      gap,
      locale: localeName,
      other: '$gap места',
      few: '$gap места',
      one: '$gap место',
    );
    return '$_temp0 изнад тима $opponent на ранг-листи. Пораз. Објасните то.';
  }

  @override
  String yDownGap7(int gap) {
    String _temp0 = intl.Intl.pluralLogic(
      gap,
      locale: localeName,
      other: '$gap места',
      few: '$gap места',
      one: '$gap место',
    );
    return 'Пораз од тима који је $_temp0 испод нас. Нека вам тај број легне.';
  }

  @override
  String yDownGap8(String opponent, int gap) {
    return 'Разлика на ранг-листи: $gap. Пораз, противник: $opponent. Неко би требало да почне да броји дане.';
  }

  @override
  String yDrewHeroic0(String opponent, String score) {
    return '$score против тима $opponent! Нерешено које има укус победе.';
  }

  @override
  String yDrewHeroic1(String opponent, String score) {
    return '$score против тима $opponent. Поносан на сваког од њих.';
  }

  @override
  String yDrewHeroic2(String opponent, String score) {
    return '$opponent $score. Били су фаворити, а ми смо им парирали.';
  }

  @override
  String yDrewHeroic3(String opponent, String score) {
    return '$score са тимом $opponent. Бод изборен крвљу и знојем.';
  }

  @override
  String yDrewHeroic4(String opponent, String score) {
    return '$score против тима $opponent. Веома добар бод.';
  }

  @override
  String yDrewHeroic5(String opponent, String score) {
    return 'Нерешено $score са тимом $opponent. Мало ко је очекивао ишта.';
  }

  @override
  String yDrewHeroic6(String opponent, String score) {
    return 'Тим $opponent заустављен, $score. Резултат на коме се гради.';
  }

  @override
  String yDrewHeroic7(String opponent, String score) {
    return '$score против тима $opponent. Бод који нам нико није давао.';
  }

  @override
  String yDrewHeroic8(String opponent, String score) {
    return '$score са тимом $opponent. Добар бод, али нерешеним резултатима се ништа не осваја.';
  }

  @override
  String yDrewHeroic9(String opponent, String score) {
    return '$score против тима $opponent. Лепо. Нисмо имали ниједан прави шут.';
  }

  @override
  String yDrewHeroic10(String opponent, String score) {
    return '$opponent $score. Један бод, а сви се понашају као да смо освојили трофеј.';
  }

  @override
  String yDrewHeroic11(String opponent, String score) {
    return '$score против тима $opponent. Паркирали смо аутобус и имали среће.';
  }

  @override
  String yDrewShame0(String opponent, String score) {
    return '$score са тимом $opponent. Фрустрирајуће, али још увек без пораза.';
  }

  @override
  String yDrewShame1(String opponent, String score) {
    return 'Само $score са тимом $opponent. Лош дан. Дешава се.';
  }

  @override
  String yDrewShame2(String opponent, String score) {
    return '$opponent $score. Није довољно добро, и играчи то знају.';
  }

  @override
  String yDrewShame3(String opponent, String score) {
    return '$score против тима $opponent. Два изгубљена бода, ништа више.';
  }

  @override
  String yDrewShame4(String opponent, String score) {
    return '$score са тимом $opponent. Два бода бачена.';
  }

  @override
  String yDrewShame5(String opponent, String score) {
    return 'Само $score са тимом $opponent. Лош резултат, како год га упаковали.';
  }

  @override
  String yDrewShame6(String opponent, String score) {
    return '$opponent $score. Нерешено које има укус пораза.';
  }

  @override
  String yDrewShame7(String opponent, String score) {
    return '$score против тима $opponent. Такве утакмице морамо да добијамо лако.';
  }

  @override
  String yDrewShame8(String opponent, String score) {
    return '$score са тимом $opponent. Срамота.';
  }

  @override
  String yDrewShame9(String opponent, String score) {
    return 'Само нерешено са тимом $opponent, $score. Ко је за ово одговоран?';
  }

  @override
  String yDrewShame10(String opponent, String score) {
    return '$opponent $score. Ако не победимо њих, кога ћемо?';
  }

  @override
  String yDrewShame11(String opponent, String score) {
    return '$score са тимом $opponent. Њихови навијачи славе нерешено против нас. Размислите о томе.';
  }

  @override
  String yTrophy0(String opponent) {
    return 'ШАМПИОНИ. $opponent. Реци то наглас.';
  }

  @override
  String yTrophy1(String opponent) {
    return 'Освојили смо. $opponent. Нисам добро.';
  }

  @override
  String yTrophy2(String opponent) {
    return '$opponent, а трофеј иде кући.';
  }

  @override
  String yTrophy3(String opponent) {
    return 'Сваки од њих легенда. $opponent.';
  }

  @override
  String yRunnerUp0(String opponent) {
    return 'Тако близу. $opponent и медаља коју нико не жели.';
  }

  @override
  String yRunnerUp1(String opponent) {
    return '$opponent: друго место. Болеће годинама.';
  }

  @override
  String yRunnerUp2(String opponent) {
    return '$opponent: једна утакмица до свега.';
  }

  @override
  String yRunnerUp3(String opponent) {
    return '$opponent: други. Нека неко дода флашу.';
  }

  @override
  String yEliminated0(String opponent) {
    return '$opponent: испали смо. Ово ће неко време да боли.';
  }

  @override
  String yEliminated1(String opponent) {
    return '$opponent је место где се за нас све завршава.';
  }

  @override
  String yEliminated2(String opponent) {
    return '$opponent: испадање. Сад следи истрага.';
  }

  @override
  String yEliminated3(String opponent) {
    return '$opponent: испали смо. Нека ми неко објасни то.';
  }

  @override
  String yQualified0(String opponent) {
    return 'ИДЕМО НА ТУРНИР: $opponent.';
  }

  @override
  String yQualified1(String opponent) {
    return 'Квалификовани: $opponent. Узми слободне дане на послу.';
  }

  @override
  String yQualified2(String opponent) {
    return '$opponent, стижемо. Никад није било сумње (сумње је било на све стране).';
  }

  @override
  String yQualified3(String opponent) {
    return '$opponent: пролаз. Најтежи део је готов.';
  }

  @override
  String yGroupDrawn0(String opponent) {
    return 'Група извучена за турнир $opponent. Могло је горе. Могло је много горе.';
  }

  @override
  String yGroupDrawn1(String opponent) {
    return 'Дакле, то је жреб за $opponent. Занимљиво.';
  }

  @override
  String yGroupDrawn2(String opponent) {
    return 'Групе за $opponent су изашле и наша ми се већ не свиђа.';
  }

  @override
  String yGroupDrawn3(String opponent) {
    return 'Жреб за $opponent готов. Нека почне претеривање.';
  }

  @override
  String yHostNamed0(String opponent) {
    return 'Домаћин: $opponent. Почни да штедиш.';
  }

  @override
  String yHostNamed1(String opponent) {
    return 'Иде у земљу: $opponent. Предвидљиво, али у реду.';
  }

  @override
  String yHostNamed2(String opponent) {
    return 'Турнир добија $opponent. Честитке њима, ваљда.';
  }

  @override
  String yHostNamed3(String opponent) {
    return 'Домаћини потврђени: $opponent.';
  }

  @override
  String yTournamentSoon0(String opponent) {
    return 'Ускоро почиње $opponent и не могу мирно да седим.';
  }

  @override
  String yTournamentSoon1(String opponent) {
    return 'Још мало до такмичења $opponent.';
  }

  @override
  String yTournamentSoon2(String opponent) {
    return '$opponent је скоро ту. Списак играча, молим.';
  }

  @override
  String yTournamentSoon3(String opponent) {
    return 'Одбројавање до такмичења $opponent званично је неподношљиво.';
  }

  @override
  String get navY => 'Y';

  @override
  String get yTitle => 'Y';

  @override
  String get yEmpty => 'Још нема шта да се каже. Одиграј утакмицу.';

  @override
  String get yEarlierHeading => 'Раније у овом циклусу';

  @override
  String get yTraitLoyalist =>
      'Подржава тим шта год да се деси. Споро се окреће, брзо опрашта.';

  @override
  String get yTraitCynic =>
      'Претпоставља најгоре и одушевљен је кад се покаже да је у праву.';

  @override
  String get yTraitNostalgic =>
      'Све је пре било боље. Мери те према људима који су се пензионисали.';

  @override
  String get yTraitStatshead =>
      'Објављује бројке и ништа друго. Једва да има расположење.';

  @override
  String get yTraitHypeman => 'Два добра резултата и већ је златна генерација.';

  @override
  String get yTraitContrarian => 'Шта год остали мисле, он мисли супротно.';

  @override
  String get yTraitDoomer => 'Кренуће наопако. Увек ће кренути наопако.';

  @override
  String get yProfilePosts => 'ОБЈАВЕ';

  @override
  String get yProfileEmpty => 'Још ништа са овог налога.';

  @override
  String hubEventGrievance(String player) {
    return '$player жели разговор';
  }

  @override
  String get hubEventGrievanceSub => 'Жели да зна на чему је';

  @override
  String hubEventManagerSkills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count бодова вештине за трошење',
      few: '$count бода вештине за трошење',
      one: '$count бод вештине за трошење',
    );
    return '$_temp0';
  }

  @override
  String get hubEventManagerSkillsSub =>
      'Оно у чему си добар чини твој тим бољим';

  @override
  String get grievanceTitle => 'Разговор у твојој канцеларији';

  @override
  String grievanceGameTime(String player) {
    return '$player је у саставу, а није ни такао лопту. Жели да зна зашто.';
  }

  @override
  String grievanceSquadPlace(String player) {
    return '$player није у саставу и не разуме зашто. Жели да му се каже, овако или онако.';
  }

  @override
  String grievanceRole(String player) {
    return '$player стално игра ван своје позиције и доста му је.';
  }

  @override
  String get grievanceReassure => 'Рачунам на тебе';

  @override
  String get grievanceHonest => 'Иза других си, ево зашто';

  @override
  String get grievanceDismiss => 'Ја бирам тим';

  @override
  String yScorerStar0(String name, int goals) {
    return '$name је дао $goals. Нико други није ни близу.';
  }

  @override
  String yScorerStar1(String name, int goals) {
    return '$goals за играча $name. Он носи овај тим.';
  }

  @override
  String yScorerStar2(String name, int goals) {
    return '$name: $goals у једном дану. Играч, нема шта.';
  }

  @override
  String yScorerStar3(String name, int goals) {
    return '$goals им је дао $name. Наклон.';
  }

  @override
  String yScorerStar4(String name, int goals) {
    return '$goals за играча $name, а остали су били путници.';
  }

  @override
  String yScorerStar5(String name, int goals) {
    return 'Опет $name. $goals. Замисли овај тим без њега.';
  }

  @override
  String yScorerStar6(String name, int goals) {
    return '$goals, а дао их је $name. Један човек не би смео толико да носи.';
  }

  @override
  String yScorerStar7(String name, int goals) {
    return 'Без играча $name то је $goals мање и сасвим другачије поподне.';
  }

  @override
  String yWinStreak0(int count) {
    return '$count заредом. Шта год да се говори у тој свлачионици, делује.';
  }

  @override
  String yWinStreak1(int count) {
    return 'То је $count заредом. Тимови не упадају у овакве низове случајно.';
  }

  @override
  String yWinStreak2(int count) {
    return '$count заредом и наставља се. Самопоуздање се види са трибина.';
  }

  @override
  String yWinStreak3(int count) {
    return 'Без пораза у $count. Питај било кога ко је водио тим: то је најтежи део.';
  }

  @override
  String yWinStreak4(int count) {
    return '$count заредом. Уживај док је распоред благ.';
  }

  @override
  String yWinStreak5(int count) {
    return '$count заредом, а нисмо победили никог битног.';
  }

  @override
  String yWinStreak6(int count) {
    return 'Низ од $count. Питај ме опет кад га неко провери.';
  }

  @override
  String yWinStreak7(int count) {
    return '$count у низу. Сваки тим једном има ово у себи.';
  }

  @override
  String yLossStreak0(int count) {
    return '$count без победе. У неком тренутку изговора понестане.';
  }

  @override
  String yLossStreak1(int count) {
    return 'Пропало је $count заредом. Ово више није кикс.';
  }

  @override
  String yLossStreak2(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count пораза',
      few: '$count пораза',
      one: '$count пораз',
    );
    return '$_temp0 заредом. Неко мора да одговара.';
  }

  @override
  String yLossStreak3(int count) {
    return 'Без победе у $count. Види се по томе како играју.';
  }

  @override
  String yLossStreak4(int count) {
    return '$count без победе и исте грешке сваке недеље.';
  }

  @override
  String yLossStreak5(int count) {
    return '$count заредом. Шта год да се покушава, не ради.';
  }

  @override
  String yLossStreak6(int count) {
    return '$count заредом. Ово је смер, а не пад.';
  }

  @override
  String yLossStreak7(int count) {
    return 'Без победе у $count, а горе нико није ни реч рекао.';
  }

  @override
  String yRivalry0(String opponent, String score) {
    return '$opponent $score. Говори шта хоћеш о фудбалу. Ова вреди дупло.';
  }

  @override
  String yRivalry1(String opponent, String score) {
    return 'Баш против њих. $opponent $score. Нико овде то неће заборавити.';
  }

  @override
  String yRivalry2(String opponent, String score) {
    return '$opponent $score. О овој ће се причати по кафанама.';
  }

  @override
  String yRivalry3(String opponent, String score) {
    return 'Комшије, $score. Право на хвалисање решено на неко време.';
  }

  @override
  String yRivalry4(String opponent, String score) {
    return '$opponent $score. Шта год се још деси ове године, ово имамо.';
  }

  @override
  String yRivalry5(String opponent, String score) {
    return '$opponent $score. Некима од нас то је требало више него табели.';
  }

  @override
  String yRivalry6(String opponent, String score) {
    return '$opponent $score. А они ће то вратити следећи пут, увек врате.';
  }

  @override
  String yRivalry7(String opponent, String score) {
    return '$opponent $score. Целу годину ћемо слушати о овој утакмици.';
  }

  @override
  String yInjuryBlow0(String name) {
    return '$name излази повређен. То је последње што је овом тиму требало.';
  }

  @override
  String yInjuryBlow1(String name) {
    return 'Губитак играча $name мења облик свега.';
  }

  @override
  String yInjuryBlow2(String name) {
    return '$name шепа. Задржи дах.';
  }

  @override
  String yInjuryBlow3(String name) {
    return 'Дакле, неко време без играча $name. Неко мора да стане на његово место.';
  }

  @override
  String yInjuryBlow4(String name) {
    return '$name отпада. Наравно да је баш $name.';
  }

  @override
  String yInjuryBlow5(String name) {
    return 'Без играча $name ово постаје сасвим обичан тим.';
  }

  @override
  String yInjuryBlow6(String name) {
    return '$name опет повређен. Неко би требало да се запита зашто.';
  }

  @override
  String yInjuryBlow7(String name) {
    return 'Изгубили смо играча $name, а иза њега нема никога. То је прави проблем.';
  }

  @override
  String ySentOff0(String name, String minute) {
    return 'Црвени за играча $name у $minute. минуту и цела земља се окреће против њега. Дао нам је више од већине. Пустите га.';
  }

  @override
  String ySentOff1(String name, String minute) {
    return '$name искључен у $minute. минуту. Строго. Са десеторицом смо се ипак борили, а то нешто говори.';
  }

  @override
  String ySentOff2(String name, String minute) {
    return '$name, $minute. минут, црвени картон. Одатле са десеторицом.';
  }

  @override
  String ySentOff3(String name, String minute) {
    return 'Искључење: $name у $minute. минуту. Није прва утакмица коју је решила једна одлука.';
  }

  @override
  String ySentOff4(String name, String minute) {
    return 'Сјајно. $name одлази у $minute. минуту и опет смо са десеторицом.';
  }

  @override
  String ySentOff5(String name, String minute) {
    return '$name искључен у $minute. минуту. Ко овде тачно тренира дисциплину?';
  }

  @override
  String ySentOff6(String name, String minute) {
    return '$minute минута. Толико је $name успео да сачува живце. Професионални фудбал.';
  }

  @override
  String ySentOff7(String name, String minute) {
    return 'Црвени за играча $name у $minute. минуту, а ја треба да поверујем да је ово напредак.';
  }

  @override
  String get yBoardPressure0 =>
      'Управа је јако утихнула. То никад није добар знак.';

  @override
  String get yBoardPressure1 =>
      'Прича се да су у управи почели да постављају питања.';

  @override
  String get yBoardPressure2 => 'Осећа се како се тло помера на спрату изнад.';

  @override
  String get yBoardPressure3 =>
      'Нико у савезу не говори ништа у знак подршке. Извуци своје закључке.';

  @override
  String get yBoardPressure4 => 'Недељама га нико горе није јавно подржао.';

  @override
  String get yBoardPressure5 =>
      'Савез шапуће против сопственог селектора. Као и увек.';

  @override
  String get yBoardPressure6 => 'Кад управа утихне, већ су одлучили.';

  @override
  String get yBoardPressure7 =>
      'Пустиће да се ово отегне док одлука не постане туђа.';

  @override
  String get yReplies => 'ЈОШ О ОВОЈ УТАКМИЦИ';

  @override
  String get yPlayerGrievance0 => 'Питао сам на чему сам. Још чекам одговор.';

  @override
  String get yPlayerGrievance1 => 'Напорно тренирам. Не могу ништа друго.';

  @override
  String get yPlayerGrievance2 => 'Нека питања можеш да поставиш само једном.';

  @override
  String get yPlayerGrievance3 => 'Нисам дошао довде да носим прслуке.';

  @override
  String get playerHonoursTitle => 'ПРИЗНАЊА';

  @override
  String get awardGoldenBall => 'Најбољи играч';

  @override
  String get awardGoldenBoot => 'Најбољи стрелац';

  @override
  String get awardGoldenGlove => 'Најбољи голман';

  @override
  String get awardTeamOfTournament => 'Тим турнира';

  @override
  String get awardPlayerOfYear => 'Светски играч године';

  @override
  String get awardYoungPlayerOfYear => 'Млади играч године';

  @override
  String get playerClubHistory => 'ИСТОРИЈА КЛУБОВА';

  @override
  String get playerCareerRecord => 'УЧИНАК У КАРИЈЕРИ';

  @override
  String get playerInternationalGoals => 'Голови за репрезентацију';

  @override
  String get playerRecentForm => 'СКОРАШЊА ФОРМА';

  @override
  String get playerMatchHistory => 'ИСТОРИЈА УТАКМИЦА';

  @override
  String get playerAttributes => 'АТРИБУТИ';

  @override
  String get playerUnknown => 'Непознато';

  @override
  String get playerAttrPace => 'Брзина';

  @override
  String get playerAttrPhysical => 'Физика';

  @override
  String get playerAttrTechnical => 'Техника';

  @override
  String get playerAttrShooting => 'Шут';

  @override
  String get playerAttrPassing => 'Додавање';

  @override
  String get playerAttrDribbling => 'Дриблинг';

  @override
  String get playerAttrTackling => 'Одузимање';

  @override
  String get playerAttrPositioning => 'Постављање';

  @override
  String get playerAttrComposure => 'Смиреност';

  @override
  String get playerAttrDecisions => 'Одлучивање';

  @override
  String get playerAttrStamina => 'Издржљивост';

  @override
  String get playerAttrStrength => 'Снага';

  @override
  String get playerStatCaps => 'Наступи';

  @override
  String get playerStatGoals => 'Голови';

  @override
  String get playerStatAssists => 'Асистенције';

  @override
  String get playerStatAvgRating => 'Прос. оцена';

  @override
  String get playerStatForm => 'Форма';

  @override
  String get playerStatMotm => 'Играч утакмице';

  @override
  String get playerStatCleanSheets => 'Без примљеног гола';

  @override
  String get playerStatBestGame => 'Најбоља утакмица';

  @override
  String get playerStatCards => 'Картони';

  @override
  String playerCardsValue(int yellows, int reds) {
    return '$yellowsЖ $redsЦ';
  }

  @override
  String get tourSharedYourRun => 'ТВОЈ ПУТ';

  @override
  String get tourSharedList => 'Списак';

  @override
  String get tourSharedBracket => 'Костур';

  @override
  String get tourSharedVs => 'против';

  @override
  String tourSharedGroupSeed(String seed) {
    return 'Група $seed';
  }

  @override
  String get tourSharedThisEdition => 'Ово издање';

  @override
  String get tourSharedAllTime => 'Свих времена';

  @override
  String get tourSharedUnknown => 'Непознато';

  @override
  String get tourSharedActive => 'АКТИВАН';

  @override
  String get tourSharedMedalTable => 'ТАБЕЛА МЕДАЉА';

  @override
  String get tourSharedPastWinners => 'ПРЕТХОДНИ ПОБЕДНИЦИ';

  @override
  String tourSharedHost(String host) {
    return 'Домаћин: $host';
  }

  @override
  String get tourSharedBeat => 'савладали';

  @override
  String get tourSharedPens => ' (пен.)';

  @override
  String get tourSharedAwardsEmpty =>
      'Награде се додељују кад се турнир одигра до краја.';

  @override
  String get tourSharedGoldenBall => 'НАЈБОЉИ ИГРАЧ';

  @override
  String get tourSharedPlayerOfTournament => 'Играч турнира';

  @override
  String get tourSharedGoldenBoot => 'НАЈБОЉИ СТРЕЛАЦ';

  @override
  String tourSharedGoalsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count голова',
      few: '$count гола',
      one: '$count гол',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedGoldenGlove => 'НАЈБОЉИ ГОЛМАН';

  @override
  String get tourSharedTeamOfTournament => 'ТИМ ТУРНИРА';

  @override
  String get tourSharedStatsEmpty =>
      'Рекорди се појављују кад такмичење добије мало историје.';

  @override
  String get tourSharedRecordScorer => 'РЕКОРДЕР ПО ГОЛОВИМА';

  @override
  String get tourSharedStillActive => 'још активан';

  @override
  String get tourSharedMostTitles => 'НАЈВИШЕ ТИТУЛА';

  @override
  String tourSharedTitlesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count титула',
      few: '$count титуле',
      one: '$count титула',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostFinals => 'НАЈВИШЕ ФИНАЛА';

  @override
  String tourSharedFinalsContested(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count одиграних финала',
      few: '$count одиграна финала',
      one: '$count одиграно финале',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostGamesPlayed => 'НАЈВИШЕ ОДИГРАНИХ УТАКМИЦА';

  @override
  String tourSharedMatchesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count утакмица',
      few: '$count утакмице',
      one: '$count утакмица',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostFinalsPlayed => 'НАЈВИШЕ ОДИГРАНИХ ЗАВРШНИХ ТУРНИРА';

  @override
  String tourSharedFinalsTournamentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count завршних турнира',
      few: '$count завршна турнира',
      one: '$count завршни турнир',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedBiggestFinalWin => 'НАЈВЕЋА ПОБЕДА У ФИНАЛУ';

  @override
  String tourStatsGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count голова',
      few: '$count гола',
      one: '$count гол',
    );
    return '$_temp0';
  }

  @override
  String get tourStatsStillActive => 'још активан';

  @override
  String tourStatsTitles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count титула',
      few: '$count титуле',
      one: '$count титула',
    );
    return '$_temp0';
  }

  @override
  String tourStatsFinalsContested(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count одиграних финала',
      few: '$count одиграна финала',
      one: '$count одиграно финале',
    );
    return '$_temp0';
  }

  @override
  String tourStatsMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count утакмица',
      few: '$count утакмице',
      one: '$count утакмица',
    );
    return '$_temp0';
  }

  @override
  String tourStatsFinalsTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count завршних турнира',
      few: '$count завршна турнира',
      one: '$count завршни турнир',
    );
    return '$_temp0';
  }

  @override
  String get tourStatsLeaders => 'ВОДЕЋИ СВИХ ВРЕМЕНА';

  @override
  String get tourStatsTabGames => 'Утакмице';

  @override
  String get tourStatsTabCups => 'Турнири';

  @override
  String get tourStatsTabScorers => 'Стрелци';

  @override
  String tourSharedFinalWinDetail(String opponent, int year) {
    return 'против $opponent · $year';
  }

  @override
  String get tourHolders => 'БРАНИОЦИ ТИТУЛЕ';

  @override
  String tourHoldersSince(int year) {
    return 'освојено $year.';
  }

  @override
  String get tourSharedAllTimeScorers => 'СТРЕЛЦИ СВИХ ВРЕМЕНА';

  @override
  String get tourSharedSummaryEmpty =>
      'Домаћин и стадиони појављују се после жреба овог издања.';

  @override
  String get tourSharedHostHeading => 'ДОМАЋИН';

  @override
  String get tourSharedHostsHeading => 'ДОМАЋИНИ';

  @override
  String get tourSharedCoHostsHeading => 'СУДОМАЋИНИ';

  @override
  String get tourSharedVenues => 'СТАДИОНИ';

  @override
  String get tourSharedMapHeading => 'МАПА ДОМАЋИНА';

  @override
  String get tourSharedMapFit => 'Прикажи целу мапу';

  @override
  String get tourSharedMapFinalVenue => 'Стадион финала';

  @override
  String get tourSharedMapTapHint => 'Додирни ознаку за стадион';

  @override
  String get tourSharedMascot => 'МАСКОТА';

  @override
  String get tourSharedMatchBall => 'ЗВАНИЧНА ЛОПТА';

  @override
  String tourSharedVenueSeats(String city, String capacity) {
    return '$city · $capacity места';
  }

  @override
  String get tourSharedCouldNotLoad => 'Није могуће учитати.';

  @override
  String get tourSharedHostTbc => 'ДОМАЋИН ЋЕ БИТИ ПОТВРЂЕН';

  @override
  String get tourSharedFinalsAreHere => 'ЗАВРШНИЦА ЈЕ ТУ';

  @override
  String tourSharedHostedBy(String hosts) {
    return 'ДОМАЋИН  $hosts';
  }

  @override
  String get tourSharedLetFinalsBegin => 'Нека почне завршница';

  @override
  String get tourSharedCompetitions => 'ТАКМИЧЕЊА';

  @override
  String get tourSharedWorldRanking => 'Светска ранг-листа';

  @override
  String get tourSharedCouldNotLoadTournaments =>
      'Турнире није могуће учитати.';

  @override
  String get tourSharedPrestigeStage => 'ПРЕСТИЖНА СЦЕНА';

  @override
  String get tourSharedOverview => 'Преглед';

  @override
  String get tourSharedWorldRankingTitle => 'Светска ранг-листа';

  @override
  String get tourSharedYourCompetitions => 'ТВОЈА ТАКМИЧЕЊА';

  @override
  String get tourSharedOtherContinents => 'ОСТАЛИ КОНТИНЕНТИ';

  @override
  String get tourSharedComingSoon => 'Турнир ускоро';

  @override
  String get tourSharedSoon => 'УСКОРО';

  @override
  String get tourSharedNoQualifyingDraw => 'Нема жреба квалификација.';

  @override
  String get tourSharedOpenEnvelope => 'Отвори коверту';

  @override
  String tourSharedGroupName(String name) {
    return 'ГРУПА $name';
  }

  @override
  String get tourSharedBall => 'Куглица';

  @override
  String get tourSharedPot => 'Шешир';

  @override
  String get tourSharedAll => 'Све';

  @override
  String get tourSharedTapDrawTeam => 'Додирни за извлачење следећег тима';

  @override
  String get tourSharedTapDrawPot => 'Додирни за извлачење следећег шешира';

  @override
  String get tourSharedTapDrawAll => 'Додирни за откривање целог жреба';

  @override
  String get tourSharedContinue => 'Настави';

  @override
  String get tourSharedPause => 'Пауза';

  @override
  String get tourSharedPlay => 'Покрени';

  @override
  String get tourSharedSkip => 'Прескочи';

  @override
  String tourSharedPotNumber(int number) {
    return 'ШЕШИР $number';
  }

  @override
  String get tourSharedDrawComplete => 'ЖРЕБ ЗАВРШЕН';

  @override
  String get tourSharedDrawing => 'ИЗВЛАЧЕЊЕ…';

  @override
  String get tourContChampionship => 'ПРВЕНСТВО';

  @override
  String get tourContTabSummary => 'САЖЕТАК';

  @override
  String get tourContTabQualifying => 'КВАЛИФИКАЦИЈЕ';

  @override
  String get tourContTabFinals => 'ЗАВРШНИЦА';

  @override
  String get tourContTabBracket => 'КОСТУР';

  @override
  String get tourContTabAwards => 'НАГРАДЕ';

  @override
  String get tourContTabScorers => 'СТРЕЛЦИ';

  @override
  String get tourContTabHistory => 'ИСТОРИЈА';

  @override
  String get tourContTabRecords => 'РЕКОРДИ';

  @override
  String tourContCouldNotLoadCup(String error) {
    return 'Куп није могуће учитати.\n$error';
  }

  @override
  String get tourContNoCupData => 'Нема података о купу.';

  @override
  String get tourContUnknown => 'Непознато';

  @override
  String get tourContGroupsToBeDrawnQual =>
      'Групе квалификација извлаче се на церемонији. Гледај са почетне да видиш с ким играш.';

  @override
  String get tourContQualSeeded =>
      'Твоја репрезентација је директно пласирана у завршницу. У овом циклусу нема квалификација.';

  @override
  String tourContBackgroundRegion(String name) {
    return '$name се симулира у позадини. Резултати се овде појављују како се игра свако коло.';
  }

  @override
  String get tourContGroupsToBeDrawnFinals =>
      'Групе завршнице извлаче се на церемонији. Гледај са почетне да видиш своју групу.';

  @override
  String get tourContFinalsDrawAfterQual =>
      'Жреб завршнице одржава се кад се квалификације заврше.';

  @override
  String get tourContContestedBeforeWc =>
      'Нокаут фазе се играју пре Светског првенства.';

  @override
  String tourContChampionsHeading(String name) {
    return 'ШАМПИОНИ: $name';
  }

  @override
  String tourContWinnersTitle(String name) {
    return 'Победници: $name';
  }

  @override
  String get tourContNoGoalsYet => 'Још нема постигнутих голова.';

  @override
  String tourContGroupHeading(String name) {
    return 'ГРУПА $name';
  }

  @override
  String get tourContBestRunnersUp => 'НАЈБОЉИ ДРУГОПЛАСИРАНИ';

  @override
  String tourContGroupDropdown(String name) {
    return 'Група $name';
  }

  @override
  String get tourContMatches => 'УТАКМИЦЕ';

  @override
  String get tourContNoGroupsDrawn => 'Групе још нису извучене.';

  @override
  String get tourContQualifyingDraw => 'ЖРЕБ КВАЛИФИКАЦИЈА';

  @override
  String get tourContWorldQualifyingDraw => 'СВЕТСКИ ЖРЕБ КВАЛИФИКАЦИЈА';

  @override
  String get tourContFinalsDraw => 'ЖРЕБ ЗАВРШНИЦЕ';

  @override
  String get tourContSeedingPots => 'ШЕШИРИ НОСИЛАЦА';

  @override
  String get tourContGroupDraw => 'ЖРЕБ ГРУПА';

  @override
  String tourContCouldNotLoadDraw(String error) {
    return 'Жреб није могуће учитати.\n$error';
  }

  @override
  String get tourContDrawNotReady => 'Жреб још није спреман.';

  @override
  String get tourContContinentalClash => 'ДУЕЛ КОНТИНЕНАТА';

  @override
  String get tourContTabThisCycle => 'ОВАЈ ЦИКЛУС';

  @override
  String tourContCouldNotLoadClash(String error) {
    return 'Није могуће учитати.\n$error';
  }

  @override
  String get tourContNoSaveFound => 'Сачувана игра није пронађена.';

  @override
  String get tourContClashSoon =>
      'Дуел континената се игра кад се знају оба континентална шампиона.';

  @override
  String get tourContTwoContinentsOneMatch => 'ДВА КОНТИНЕНТА, ЈЕДНА УТАКМИЦА';

  @override
  String get tourContVersusShort => 'против';

  @override
  String tourContWinTheClash(String name) {
    return '$name осваја Дуел континената';
  }

  @override
  String get tourContNoClashYet => 'Дуел континената још није одигран.';

  @override
  String get tourContNationsCup => 'КУП НАЦИЈА';

  @override
  String get tourContTabLeagues => 'ЛИГЕ';

  @override
  String get tourContTabFinalsFour => 'ФАЈНАЛ ФОР';

  @override
  String tourContCouldNotLoad(String error) {
    return 'Учитавање није успело.\n$error';
  }

  @override
  String get tourContNoNationsCupGoals =>
      'Још нема забележених голова у Купу нација.';

  @override
  String get tourContNoNationsCupChampions => 'Још нема шампиона Купа нација.';

  @override
  String get tourContNationsCupOffSeason =>
      'Куп нација овог циклуса почиње после континенталних завршница. Претходне победнике потражи у Историји.';

  @override
  String get tourContNationsCupGroupsSoon =>
      'Групе Купа нација овог циклуса извлаче се на церемонији. Гледај са почетне да видиш с ким играш.';

  @override
  String get tourContLeagueNoGroups => 'У овој лиги нема утакмица у овом колу.';

  @override
  String tourContLeagueHeading(String letter) {
    return 'ЛИГА $letter';
  }

  @override
  String tourContLeagueHeadingYours(String letter) {
    return 'ЛИГА $letter · ТВОЈА ЛИГА';
  }

  @override
  String get tourContFinalsFourSoon =>
      'Фајнал фор играју победници група Лиге А кад се заврши такмичење по групама.';

  @override
  String tourContLeagueChip(String letter) {
    return 'Лига $letter';
  }

  @override
  String tourContLeagueChipStar(String letter) {
    return 'Лига $letter ★';
  }

  @override
  String get tourContSemiFinals => 'ПОЛУФИНАЛЕ';

  @override
  String get tourContFinal => 'ФИНАЛЕ';

  @override
  String get tourContNationsCupDraw => 'ЖРЕБ КУПА НАЦИЈА';

  @override
  String get tourContIntercontinentalPlayoff => 'ИНТЕРКОНТИНЕНТАЛНИ БАРАЖ';

  @override
  String get tourContNoPlayoffThisCycle => 'У овом циклусу нема баража.';

  @override
  String get tourContPlayoffIntro =>
      'Два места на Светском првенству одлучују се нокаут турниром најбољих неуспешних из квалификација.';

  @override
  String get tourContPlayoffThrough =>
      'Прошао си бараж. Идеш на Светско првенство!';

  @override
  String get tourContPlayoffOut =>
      'Ниси успео у баражу. Овај пут нема Светског првенства.';

  @override
  String get tourContContinue => 'Настави';

  @override
  String get tourContPlayoffFinals => 'ФИНАЛЕ БАРАЖА';

  @override
  String get tourContPlayoffSeeded => 'Носилац (слободан пролаз)';

  @override
  String get tourCupTabSummary => 'САЖЕТАК';

  @override
  String get tourCupTabQualifying => 'КВАЛИФИКАЦИЈЕ';

  @override
  String get tourCupTabPlayoff => 'БАРАЖ';

  @override
  String get tourCupPlayoffSoon =>
      'Интерконтинентални бараж одлучује се кад се заврше квалификације свих конфедерација.';

  @override
  String get tourCupTabFinals => 'ЗАВРШНИЦА';

  @override
  String get tourCupTabBracket => 'КОСТУР';

  @override
  String get tourCupTabAwards => 'НАГРАДЕ';

  @override
  String get tourCupTabScorers => 'СТРЕЛЦИ';

  @override
  String get tourCupTabHistory => 'ИСТОРИЈА';

  @override
  String get tourCupTabRecords => 'РЕКОРДИ';

  @override
  String get tourCupTitle => 'СВЕТСКО ПРВЕНСТВО';

  @override
  String get tourCupNoData => 'Нема података о такмичењу.';

  @override
  String tourCupLoadError(String error) {
    return 'Учитавање такмичења није успело.\n$error';
  }

  @override
  String get tourCupUnknown => 'Непознато';

  @override
  String get tourCupWorldChampions => 'СВЕТСКИ ШАМПИОНИ';

  @override
  String get tourCupWorldChampionsTitle => 'Светски шампиони';

  @override
  String get tourCupStillActive => 'Још активан';

  @override
  String get tourCupAllTimeScorers => 'СТРЕЛЦИ СВИХ ВРЕМЕНА';

  @override
  String get tourCupAllConfederations => 'Све конфедерације';

  @override
  String get tourCupBestRunnersUp => 'Најбољи другопласирани';

  @override
  String get tourCupCompWorld => 'Светско првенство';

  @override
  String get tourCupCompEurope => 'Европско првенство';

  @override
  String get tourCupCompSAmerica => 'Куп Јужне Америке';

  @override
  String get tourCupDestRoundOf16 => 'осмину финала';

  @override
  String get tourCupDestKnockouts => 'нокаут фазу';

  @override
  String get tourCupDestFinals => 'завршницу';

  @override
  String get tourCupDestFinalsPlayoff => 'бараж за завршницу';

  @override
  String get tourCupDestIntercontPlayoff => 'интерконтинентални бараж';

  @override
  String get tourCupFinalsDrawnAfterQual =>
      'Завршница се извлачи кад се заврше квалификације.';

  @override
  String get tourCupFinalsDrawSoon =>
      'Групе тек треба да се извуку. Гледај жреб Светског првенства са почетне да их откријеш.';

  @override
  String tourCupGroupName(String name) {
    return 'Група $name';
  }

  @override
  String tourCupGroupNameShort(String name) {
    return 'Група $name';
  }

  @override
  String tourCupHostLabel(String host) {
    return 'Домаћин: $host';
  }

  @override
  String tourCupHostLabelMulti(String hosts) {
    return 'Домаћини: $hosts';
  }

  @override
  String get tourCupIntercontPlayoff => 'Интерконтинентални бараж';

  @override
  String get tourCupKnockoutSoon =>
      'Костур почиње кад се заврши такмичење по групама.';

  @override
  String get tourCupMatches => 'УТАКМИЦЕ';

  @override
  String get tourCupMedalTable => 'ТАБЕЛА МЕДАЉА';

  @override
  String get tourCupMostTitles => 'НАЈВИШЕ ТИТУЛА';

  @override
  String tourCupMostTitlesValue(String nation, int titles, int editions) {
    String _temp0 = intl.Intl.pluralLogic(
      titles,
      locale: localeName,
      other: '$titles титула',
      few: '$titles титуле',
      one: '$titles титула',
    );
    String _temp1 = intl.Intl.pluralLogic(
      editions,
      locale: localeName,
      other: '$editions издања',
      few: '$editions издања',
      one: '$editions издању',
    );
    return '$nation: $_temp0 у $_temp1';
  }

  @override
  String get tourCupNoGoals => 'Још нема голова.';

  @override
  String get tourCupNoGroups => 'Групе нису извучене.';

  @override
  String get tourCupNoHistory => 'Још нема историје.';

  @override
  String get tourCupPastWinners => 'ПРЕТХОДНИ ПОБЕДНИЦИ';

  @override
  String get tourCupPlayoffIntro =>
      'Два места на Светском првенству одлучују се нокаут турниром најбољих неуспешних из квалификација.';

  @override
  String tourCupPlayoffNoEntrants(String confederation) {
    return '$confederation нема бараж: сва места се одлучују у квалификационим групама.';
  }

  @override
  String get tourCupQualDrawSoon =>
      'Групе тек треба да се извуку. Гледај жреб квалификација са почетне да их откријеш.';

  @override
  String tourCupRegionYours(String region) {
    return '$region · твоја';
  }

  @override
  String tourCupScorePens(int home, int away) {
    return '$home–$away (пен.)';
  }

  @override
  String get tourCupSegAllTime => 'Свих времена';

  @override
  String get tourCupSegFinals => 'Завршница';

  @override
  String get tourCupSegQualifying => 'Квалификације';

  @override
  String get playerTraitsTitle => 'ПОЗНАТ ПО';

  @override
  String get traitBigGame => 'Играч за велике утакмице';

  @override
  String get traitBigGameBlurb => 'Подиже ниво у нокаут дуелима.';

  @override
  String get traitSetPiece => 'Специјалиста за прекиде';

  @override
  String get traitSetPieceBlurb => 'Боље изводи и даје више голова из прекида.';

  @override
  String get traitHothead => 'Усијана глава';

  @override
  String get traitHotheadBlurb => 'Скупља знатно више картона од саиграча.';

  @override
  String get traitIronMan => 'Гвоздени';

  @override
  String get traitIronManBlurb => 'Ретко се повређује и спорије се умара.';

  @override
  String get traitWonderkid => 'Вундеркинд';

  @override
  String get traitWonderkidBlurb => 'Млад, већ добар и још брзо напредује.';

  @override
  String get traitLeader => 'Вођа';

  @override
  String get traitLeaderBlurb => 'Подиже сваког саиграча на терену.';

  @override
  String get traitPacey => 'Брзоног';

  @override
  String get traitPaceyBlurb =>
      'Муњевита брзина, стална претња иза леђа одбране.';

  @override
  String get traitOldHead => 'Искусни лисац';

  @override
  String get traitOldHeadBlurb => 'Ветеран чије читање игре надживи ноге.';

  @override
  String get traitWasteful => 'Расипник';

  @override
  String get traitWastefulBlurb => 'Превише добрих прилика шаље поред гола.';

  @override
  String get objectiveWorldCup => 'Светско првенство';

  @override
  String get objectiveWinTournament => 'Освоји титулу';

  @override
  String get objectiveQualifyGeneric => 'Квалификуј се';

  @override
  String hubBoardObjectiveFor(String competition, String label) {
    return '$competition: $label';
  }

  @override
  String get objectiveWinWorldCup => 'Освоји Светско првенство';

  @override
  String get objectiveReachFinal => 'Стигни до финала';

  @override
  String get objectiveReachSemis => 'Стигни до полуфинала';

  @override
  String get objectiveReachQuarters => 'Стигни до четвртфинала';

  @override
  String get objectiveReachKnockouts => 'Стигни до нокаут фазе';

  @override
  String get objectiveQualify => 'Квалификуј се за Светско првенство';

  @override
  String get finishChampions => 'Шампиони';

  @override
  String get finishRunnersUp => 'Другопласирани';

  @override
  String get finishSemiFinals => 'Полуфинале';

  @override
  String get finishQuarterFinals => 'Четвртфинале';

  @override
  String get finishRoundOf16 => 'Осмина финала';

  @override
  String get finishGroupStage => 'Такмичење по групама';

  @override
  String get objectiveQualifyingTopHalf =>
      'Заврши у горњој половини квалификација';

  @override
  String get objectiveQualifyingChallenge =>
      'Бори се за пласман: бар горња половина квалификација';

  @override
  String get finishQualifyingTopHalf => 'Горња половина квалификационе групе';

  @override
  String get finishQualifyingBottomHalf => 'Доња половина квалификационе групе';

  @override
  String get objectiveNcWinIt => 'Освоји Куп нација';

  @override
  String get objectiveNcReachFinal => 'Стигни до финала Купа нација';

  @override
  String get objectiveNcFinalsFour => 'Пласирај се у Фајнал фор';

  @override
  String get objectiveNcWinGroup => 'Освоји групу и напредуј';

  @override
  String get objectiveNcTopHalf => 'Заврши у горњој половини групе';

  @override
  String get objectiveNcSurvive => 'Избегни испадање';

  @override
  String get objectiveNcOffTheBottom => 'Немој да завршиш последњи у групи';

  @override
  String get finishNcChampions => 'Победници Купа нација';

  @override
  String get finishNcFinalsFour => 'Фајнал фор';

  @override
  String get finishNcGroupWinners => 'Победници групе';

  @override
  String get finishNcTopHalf => 'Горња половина групе';

  @override
  String get finishNcStayedUp => 'Избегнуто испадање';

  @override
  String get finishNcClearOfBottom => 'Није последњи у групи';

  @override
  String get finishNcBottom => 'Последњи у групи';

  @override
  String get careerNationsCupLabel => 'Куп нација';

  @override
  String get squadDevPlayer => 'ИГРАЧ';

  @override
  String get squadDevAge => 'ГОД.';

  @override
  String get squadDevPosition => 'ПОЗ';

  @override
  String get squadDevChange => 'ОЦЕНА';

  @override
  String get squadDevNew => 'НОВО';

  @override
  String get squadDevRetired => 'ПЕНЗИОНИСАН';

  @override
  String get squadDevEmpty => 'Мирна година. Без промена у саставу.';

  @override
  String get squadDevTierRegulars => 'СТАНДАРДНИ';

  @override
  String get squadDevTierFringe => 'НА МАРГИНИ';

  @override
  String get squadDevTierYouth => 'МЛАДИ';

  @override
  String get boardObjectivesTitle => 'Циљеви управе';

  @override
  String get boardObjectivesConfidence => 'Поверење управе';

  @override
  String boardObjectiveBeatenBy(String result, int rounds) {
    String _temp0 = intl.Intl.pluralLogic(
      rounds,
      locale: localeName,
      other: '$rounds кругова боље од траженог',
      few: '$rounds круга боље од траженог',
      one: 'круг боље од траженог',
    );
    return '$result: $_temp0';
  }

  @override
  String boardObjectiveShortBy(String result, int rounds) {
    String _temp0 = intl.Intl.pluralLogic(
      rounds,
      locale: localeName,
      other: '$rounds кругова мање од траженог',
      few: '$rounds круга мање од траженог',
      one: '$rounds круг мање од траженог',
    );
    return '$result: $_temp0';
  }

  @override
  String get boardObjectivesPending => 'ЈОШ НИЈЕ ОДЛУЧЕНО';

  @override
  String boardObjectiveSoFar(String result) {
    return 'ДО САДА · $result';
  }

  @override
  String get boardObjectivesEmpty =>
      'Управа није поставила циљ за овај циклус.';

  @override
  String get tourContBestWinners => 'НАЈБОЉИ ПОБЕДНИЦИ ГРУПА';

  @override
  String tourNcWinnersUp(int count, String league) {
    return 'Првих $count иде у Лигу $league';
  }

  @override
  String get tourContBestThirds => 'НАЈБОЉИ ТРЕЋЕПЛАСИРАНИ';

  @override
  String tourContBestPlaced(String position) {
    return 'НАЈБОЉИ $position. ПЛАСИРАНИ';
  }

  @override
  String squadDevPageOf(String page, String pages, int total) {
    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: '$total играча',
      few: '$total играча',
      one: '$total играч',
    );
    return '$page/$pages · $_temp0';
  }

  @override
  String get matchSoldOut => 'РАСПРОДАТО';

  @override
  String matchAttendanceOf(String attendance, String capacity) {
    return 'Попуњено $attendance од $capacity места';
  }

  @override
  String get matchGroundTitle => 'СТАДИОН';

  @override
  String get absenceInjured => 'Повређен';

  @override
  String get absenceSuspended => 'Суспендован';

  @override
  String absenceWeeks(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString недеља',
      few: '$countString недеље',
      one: '$countString недеља',
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
      other: '$countString утакмица',
      few: '$countString утакмице',
      one: '$countString утакмица',
    );
    return '$_temp0';
  }

  @override
  String absenceBackFor(String opponent) {
    return 'Враћа се за: $opponent';
  }

  @override
  String get penaltyOrderTitle => 'Пенали';

  @override
  String get penaltyOrderBlurb =>
      'Одреди пет извођача, редом. Додирни место да га промениш.';

  @override
  String penaltyOrderPick(int number) {
    return 'Ударац $number';
  }

  @override
  String get penaltyOrderPickBlurb =>
      'Изабери ко излази на лопту. Трака показује његову смиреност са беле тачке.';

  @override
  String get penaltyOrderConfirm => 'Изведи';

  @override
  String get penaltyOrderCancel => 'Назад';

  @override
  String get youthTitle => 'Млади';

  @override
  String get youthEmptyLevel => 'На овом нивоу још нема никога.';

  @override
  String get youthReleased => 'Отпуштени ове године';

  @override
  String get u21Title => 'У-21';

  @override
  String get u21Blurb =>
      'Следећа генерација, најбољи таленат први. Празне звездице су процена скаута. Дај играчу наступ да сазнаш шта заиста има.';

  @override
  String get u21Empty =>
      'Тренутно нема никога млађег од 21 у фонду играча. Следећа генерација стиже са новим циклусом.';

  @override
  String u21Breakout(int gain) {
    return '+$gain ОВЕ ГОДИНЕ';
  }

  @override
  String u21AgeCaps(int age, int caps) {
    String _temp0 = intl.Intl.pluralLogic(
      caps,
      locale: localeName,
      other: '$caps наступа',
      few: '$caps наступа',
      one: '$caps наступ',
    );
    return 'Узраст $age · $_temp0';
  }

  @override
  String u21AgeUncapped(int age) {
    return 'Узраст $age · без наступа';
  }

  @override
  String get u21CallUps => 'На позиве';

  @override
  String get youthWatching => 'Праћени';

  @override
  String get youthWatchEmpty =>
      'Још нико није означен. Означи дечака на било ком нивоу и појавиће се овде, заједно са оним што је постао.';

  @override
  String get youthWatchMark => 'Прати овог дечака';

  @override
  String get youthWatchUnmark => 'Престани да га пратиш';

  @override
  String youthWatchMarked(int rating, int age) {
    return 'Означен са оценом $rating, узраст $age';
  }

  @override
  String get youthWatchSenior => 'Прешао у сениорски фонд';

  @override
  String get youthWatchReleased => 'Отпустила га академија';

  @override
  String get youthWatchGone => 'Више није у пирамиди';

  @override
  String get tacticsYouth => 'У-21';

  @override
  String get pressSquad => 'Свлачионица';

  @override
  String get pressBoard => 'Управа';

  @override
  String get pressNoEffect => 'Нико томе не придаје значај';

  @override
  String get matchNeutralGround => 'НЕУТРАЛНО';

  @override
  String get matchExtraTimeAhead => 'ПРОДУЖЕЦИ';

  @override
  String get matchExtraTimeHalf => 'ПРОДУЖЕЦИ · ПОЛУВРЕМЕ';

  @override
  String get matchClockFullTime => 'КРАЈ УТАКМИЦЕ';

  @override
  String get matchClockAfterExtraTime => 'ПОСЛЕ ПРОДУЖЕТАКА';

  @override
  String get matchClockPenalties => 'ПЕНАЛИ';

  @override
  String get matchClockFullTimePenalties => 'КРАЈ · ПЕНАЛИ';

  @override
  String get hubEventPressConference => 'Суочи се са медијима';

  @override
  String get hubEventPressConferenceSub =>
      'Светски медији желе реч пре твоје следеће утакмице';

  @override
  String get squadDevWonderkid => 'ЧУДО ОД ДЕТЕТА';

  @override
  String get tacticsPlaystyle => 'Стил игре';

  @override
  String get tacticsPlaystyleBlurb =>
      'Изабери како тим игра; точкићи испод га фино подешавају.';

  @override
  String get tacticsPlaystyleCustom =>
      'Твоја подешавања. Ниједан именовани стил не одговара овим точкићима.';

  @override
  String get playstyleCustom => 'Прилагођено';

  @override
  String get playstyleBalanced => 'Уравнотежено';

  @override
  String get playstylePossession => 'Посед';

  @override
  String get playstyleGegenpress => 'Гегенпрес';

  @override
  String get playstyleCounter => 'Контранапад';

  @override
  String get playstyleDirect => 'Директно';

  @override
  String get playstyleLowBlock => 'Ниски блок';

  @override
  String get playstyleWingPlay => 'Игра преко крила';

  @override
  String get playstyleBalancedBlurb =>
      'Чврсто у обе половине, ништа претерано.';

  @override
  String get playstylePossessionBlurb =>
      'Чувај лопту, стрпљиво је води, стегни терен.';

  @override
  String get playstyleGegenpressBlurb =>
      'Врати лопту чим је изгубиш, високо на терену.';

  @override
  String get playstyleCounterBlurb =>
      'Повуци се, остани збијен, па удари брзином.';

  @override
  String get playstyleDirectBlurb => 'Рано напред и играј на другу лопту.';

  @override
  String get playstyleLowBlockBlurb =>
      'Дубоко, уско и веома тешко за пробијање.';

  @override
  String get playstyleWingPlayBlurb =>
      'Развуци терен, обиђи по боковима и центрирај.';

  @override
  String get nationsRandomTeam => 'Насумична репрезентација';

  @override
  String get nationsFromTheBottom => 'Од дна';

  @override
  String get bottomStartTitle => 'Без посла';

  @override
  String get bottomStartHeading => 'Три савеза желе да разговарају';

  @override
  String get bottomStartBlurb =>
      'Немаш посао ни углед. Ово су једине репрезентације спремне да ризикују са тобом. Изабери једну и изгради нешто ни из чега.';

  @override
  String get bottomStartAccept => 'Прихвати';

  @override
  String get bottomStartBack => 'Назад на мени';

  @override
  String bottomStartRankOf(int rank, int total) {
    return '$rank. од $total у свету';
  }

  @override
  String get campTitle => 'Базни камп';

  @override
  String campBasedIn(String host) {
    return 'Смештај: $host';
  }

  @override
  String get campBlurb =>
      'Место где тим живи током целог турнира. Не може се променити кад игра почне, а утиче на три ствари у свакој утакмици: колико свежи стижу, колико брзо зараста повреда и колико су оштри.';

  @override
  String get campEffectTravel => 'Свеж долазак';

  @override
  String get campEffectRecovery => 'Бржи опоравак';

  @override
  String get campEffectSharpness => 'Оштрина за утакмице';

  @override
  String get campTerrainCity => 'Центар града';

  @override
  String get campTerrainCoastal => 'Приморско одмаралиште';

  @override
  String get campTerrainMountain => 'Планинско уточиште';

  @override
  String get campTerrainAltitude => 'Камп на висини';

  @override
  String get campTerrainNationalCentre => 'Национални центар';

  @override
  String get campTerrainCityBlurb =>
      'Све је при руци и нигде се не путује, али нема мира ни бекства од буке.';

  @override
  String get campTerrainCoastalBlurb =>
      'Мирно, удобно и добро за расположење; до сваког стадиона дуг пут аутобусом.';

  @override
  String get campTerrainMountainBlurb =>
      'Свеж ваздух и врхунска медицинска подршка која брзо лечи повреде, далеко од турнира.';

  @override
  String get campTerrainAltitudeBlurb =>
      'Напорно за тренинг, али ноге издрже дубоко у турнир.';

  @override
  String get campTerrainNationalCentreBlurb =>
      'Сопствени објекти савеза: ништа спектакуларно, али ништа што би могло да закаже.';

  @override
  String get hubEventChooseCamp => 'Изабери базни камп';

  @override
  String hubEventChooseCampSub(String host) {
    return 'Где ће тим бити смештен: $host';
  }

  @override
  String get tacticsTabBench => 'Клупа';

  @override
  String get squadSearchHint => 'Тражи по имену или клубу';

  @override
  String get squadFilterAll => 'Сви';

  @override
  String get squadFilterInSquad => 'У саставу';

  @override
  String get squadFilterUncapped => 'Без наступа';

  @override
  String get squadFilterUnavailable => 'Недоступни';

  @override
  String get squadLineAll => 'Све линије';

  @override
  String get squadSortBy => 'Сортирај';

  @override
  String get squadSortRating => 'Оцена';

  @override
  String get squadSortCaps => 'Наступи';

  @override
  String get squadSortGoals => 'Голови';

  @override
  String get squadSortAge => 'Узраст';

  @override
  String get squadSortName => 'Име';

  @override
  String get squadLegendTitle => 'Шта значе ознаке';

  @override
  String get squadLegendStarting => 'У твојој почетној једанаесторици';

  @override
  String get squadLegendCalledUp => 'Позван, на клупи';

  @override
  String get squadLegendInjured => 'Повређен, недоступан';

  @override
  String get squadLegendSuspended => 'Суспендован, недоступан';

  @override
  String get squadLegendTired =>
      'Уморан (жуто) или исцрпљен (црвено): одмори га једну утакмицу';

  @override
  String get squadLegendShift =>
      'Његова сопствена промена оцене у следећој утакмици (форма, кондиција, клуб)';

  @override
  String get squadLegendTraits => 'ПОЗНАТ ПО';

  @override
  String squadShowingOf(int shown, int total) {
    return 'Приказано $shown од $total играча';
  }

  @override
  String get squadNobodyMatches => 'Нико у фонду не одговара тим филтерима.';

  @override
  String get squadStatPool => 'Фонд';

  @override
  String get squadStatInSquad => 'Позвани';

  @override
  String get squadMostCapped => 'Највише наступа';

  @override
  String get squadTopScorer => 'Најбољи стрелац';

  @override
  String squadCapsValue(String name, int caps) {
    String _temp0 = intl.Intl.pluralLogic(
      caps,
      locale: localeName,
      other: '$caps наступа',
      few: '$caps наступа',
      one: '$caps наступ',
    );
    return '$name · $_temp0';
  }

  @override
  String squadGoalsValue(String name, int goals) {
    String _temp0 = intl.Intl.pluralLogic(
      goals,
      locale: localeName,
      other: '$goals голова',
      few: '$goals гола',
      one: '$goals гол',
    );
    return '$name · $_temp0';
  }

  @override
  String squadAgeClub(int age, String club) {
    return '$age · $club';
  }

  @override
  String get squadCapsShort => 'Наст.';

  @override
  String get squadGoalsShort => 'Гол';

  @override
  String get recordsRecordBookSubtitle =>
      'Наступи, голови и главни рекорди тима';

  @override
  String get statsLegacy => 'НАСЛЕЂЕ';

  @override
  String tacticsSubAlreadyOff(String name) {
    return '$name је већ замењен и не може да се врати на терен.';
  }

  @override
  String tacticsSubSentOff(String name) {
    return '$name је искључен и не учествује даље.';
  }

  @override
  String get tacticsInjuredShort => 'ПОВРЕЂЕН';

  @override
  String get tacticsSuspendedShort => 'СУСПЕНДОВАН';

  @override
  String get confEurope => 'Европа';

  @override
  String get confSouthAmerica => 'Јужна Америка';

  @override
  String get confNorthAmerica => 'Северна Америка';

  @override
  String get confAfrica => 'Африка';

  @override
  String get confAsia => 'Азија';

  @override
  String get confOceania => 'Океанија';

  @override
  String get compWorldCup => 'Светско првенство';

  @override
  String get compWorldCupFinals => 'Завршница Светског првенства';

  @override
  String get compWorldCupQualifying => 'Квалификације за Светско првенство';

  @override
  String compQualifiers(String region) {
    return 'Квалификације: $region';
  }

  @override
  String get compFriendlies => 'Пријатељске утакмице';

  @override
  String get compNationsCup => 'Куп нација';

  @override
  String get compContinentalClash => 'Дуел континената';

  @override
  String get compIntercontinentalPlayoff => 'Интерконтинентални бараж';

  @override
  String get compContinentalChampionship => 'Континентално првенство';

  @override
  String get compEuropeanChampionship => 'Европско првенство';

  @override
  String get compSouthAmericaCup => 'Куп Јужне Америке';

  @override
  String get compAfricanChampionship => 'Афричко првенство';

  @override
  String get compAsianChampionship => 'Азијско првенство';

  @override
  String get compNorthAmericaCup => 'Куп Северне Америке';

  @override
  String get compOceaniaCup => 'Куп Океаније';

  @override
  String get msgANation => 'Нека репрезентација';

  @override
  String get msgAPlayer => 'Неки играч';

  @override
  String get msgAHostNation => 'земља домаћин';

  @override
  String get msgCycleTitle1 => 'Почиње нови циклус';

  @override
  String msgCycleTitle2(int year) {
    return 'Отвара се пут ка $year';
  }

  @override
  String get msgCycleTitle3 => 'Свануо је нови поход';

  @override
  String get msgCycleTitle4 => 'Назад на посао';

  @override
  String msgCycleBody1(int year) {
    return 'Овде почиње пут ка Светском првенству $year.';
  }

  @override
  String msgCycleBody2(int year) {
    return 'Нови циклус. Циљ је Светско првенство $year.';
  }

  @override
  String msgCycleBody3(int year) {
    return 'Четири године до Светског првенства $year. Посао почиње одмах.';
  }

  @override
  String msgCycleBody4(int year) {
    return 'Поход $year. почиње данас.';
  }

  @override
  String msgContHostTitle(String cup, String host) {
    return '$cup: домаћин је $host';
  }

  @override
  String msgContHostBody(String host, String cup) {
    return '$cup: следећи домаћин је $host.';
  }

  @override
  String msgContQualDrawTitle(String cup) {
    return 'Жреб квалификација: $cup';
  }

  @override
  String msgContQualDrawBody(String cup) {
    return 'Извучене су квалификационе групе: $cup.';
  }

  @override
  String msgWcHostTitle(String host, int year) {
    return 'Светско првенство $year, домаћин: $host';
  }

  @override
  String msgWcHostBody(String host, int year) {
    return '$host ће бити домаћин Светског првенства $year.';
  }

  @override
  String get msgWcQualDrawTitle => 'Жреб квалификација за Светско првенство';

  @override
  String get msgWcQualDrawBody =>
      'Извучене су квалификационе групе за Светско првенство.';

  @override
  String msgContFinalsDrawTitle(String cup) {
    return 'Жреб завршнице: $cup';
  }

  @override
  String msgContFinalsDrawBody(String cup) {
    return 'Извучене су групе завршнице: $cup.';
  }

  @override
  String get msgWcFinalsDrawTitle => 'Жреб завршнице Светског првенства';

  @override
  String msgWcFinalsDrawBody(int year) {
    return 'Одржан је жреб завршнице Светског првенства $year.';
  }

  @override
  String get msgQualWcTitle1 => 'Пролаз на Светско првенство';

  @override
  String get msgQualWcTitle2 => 'Светско првенство обезбеђено';

  @override
  String get msgQualWcTitle3 => 'Идемо на Светско првенство';

  @override
  String get msgQualWcTitle4 => 'Карта у џепу';

  @override
  String msgQualWcBody1(int year) {
    return 'Квалификовао си се за завршницу Светског првенства $year.';
  }

  @override
  String msgQualWcBody2(int year) {
    return 'Званично је: твоја репрезентација игра на Светском првенству $year.';
  }

  @override
  String msgQualWcBody3(int year) {
    return 'Место на Светском првенству $year. је обезбеђено.';
  }

  @override
  String msgQualWcBody4(int year) {
    return 'Прошао си на завршницу Светског првенства $year.';
  }

  @override
  String msgQualContTitle1(String cup) {
    return 'Пролаз: $cup';
  }

  @override
  String msgQualContTitle2(String cup) {
    return '$cup: обезбеђено';
  }

  @override
  String msgQualContTitle3(String cup) {
    return 'Квалификација: $cup';
  }

  @override
  String msgQualContBody1(String cup) {
    return 'Квалификовао си се за завршницу: $cup.';
  }

  @override
  String msgQualContBody2(String cup) {
    return 'Твоја репрезентација је обезбедила место на такмичењу: $cup.';
  }

  @override
  String msgQualContBody3(String cup) {
    return 'Прошао си даље: $cup.';
  }

  @override
  String msgChampTitleMine1(String comp) {
    return '$comp: ШАМПИОНИ!';
  }

  @override
  String msgChampTitleMine2(String comp) {
    return 'Шампиони: $comp!';
  }

  @override
  String msgChampTitleMine3(String comp) {
    return 'Титула је твоја: $comp!';
  }

  @override
  String msgChampTitleOther1(String comp) {
    return '$comp: одлучено';
  }

  @override
  String msgChampTitleOther2(String comp) {
    return '$comp: крунисани шампиони';
  }

  @override
  String msgChampTitleOther3(String comp) {
    return 'Завршен турнир: $comp';
  }

  @override
  String msgChampBodyMine1(String comp, String loser, String result, int year) {
    return 'Твоја репрезентација је шампион ($comp $year.). Поражени финалиста: $loser$result.';
  }

  @override
  String msgChampBodyMine2(String comp, String loser, String result, int year) {
    return '$comp $year.: титула је твоја. Поражен: $loser$result.';
  }

  @override
  String msgChampBodyMine3(String comp, String loser, String result, int year) {
    return '$comp $year. припада теби. Савладан: $loser$result.';
  }

  @override
  String msgChampBodyOther1(
    String winner,
    String comp,
    String loser,
    String result,
    int year,
  ) {
    return '$comp $year.: осваја $winner. Поражени финалиста: $loser$result.';
  }

  @override
  String msgChampBodyOther2(
    String winner,
    String comp,
    String loser,
    String result,
    int year,
  ) {
    return 'Шампион ($comp $year.): $winner. Поражен: $loser$result.';
  }

  @override
  String msgFinalScoreSuffix(int home, int away) {
    return ' $home–$away у финалу';
  }

  @override
  String msgFinalPensSuffix(int home, int away) {
    return ' после пенала (у финалу $home–$away)';
  }

  @override
  String get msgWpotyTitle => 'Светски играч године';

  @override
  String msgWpotyBodyMine(String name, String nation, int year) {
    return '$name ($nation) проглашен је за светског играча године $year, а твој је играч.';
  }

  @override
  String msgWpotyBodyOther(String name, String nation, int year) {
    return '$name ($nation) проглашен је за светског играча године $year.';
  }

  @override
  String get msgYpotTitle => 'Млади играч турнира';

  @override
  String msgYpotBodyMine(String name, String nation, int age, int year) {
    return '$name ($nation, узраст: $age) проглашен је за младог играча турнира $year, а твој је играч.';
  }

  @override
  String msgYpotBodyOther(String name, String nation, int age, int year) {
    return '$name ($nation, узраст: $age) проглашен је за младог играча турнира $year.';
  }

  @override
  String msgRankHold1(int rank) {
    return 'Држиш позицију #$rank.';
  }

  @override
  String msgRankHold2(int rank) {
    return 'Без промене, и даље #$rank.';
  }

  @override
  String msgRankHold3(int rank) {
    return 'Стабилно на #$rank.';
  }

  @override
  String msgRankUp1(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move места',
      few: '$move места',
      one: '$move место',
    );
    return 'Укупно напред за $_temp0, на #$rank.';
  }

  @override
  String msgRankUp2(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move места',
      few: '$move места',
      one: '$move место',
    );
    return 'Успон за $_temp0 диже те на #$rank.';
  }

  @override
  String msgRankUp3(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move места',
      few: '$move места',
      one: '$move место',
    );
    return 'Напред за $_temp0, сада #$rank.';
  }

  @override
  String msgRankDown1(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move места',
      few: '$move места',
      one: '$move место',
    );
    return 'Укупно назад за $_temp0, на #$rank.';
  }

  @override
  String msgRankDown2(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move места',
      few: '$move места',
      one: '$move место',
    );
    return 'Пад за $_temp0 спушта те на #$rank.';
  }

  @override
  String msgRankDown3(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move места',
      few: '$move места',
      one: '$move место',
    );
    return 'Назад за $_temp0, сада #$rank.';
  }

  @override
  String get msgRankLeadYou => 'Ти си на врху света.';

  @override
  String msgRankLeadOther(String nation) {
    return 'На врху света: $nation.';
  }

  @override
  String msgRankTitle(int rank) {
    return 'Светска ранг-листа · #$rank';
  }

  @override
  String msgRankBody(String lead, String movement) {
    return 'Светска ранг-листа је ажурирана. $lead $movement';
  }

  @override
  String msgRankJumpTitleUp(int rank) {
    return 'Успон на #$rank';
  }

  @override
  String msgRankJumpTitleDown(int rank) {
    return 'Пад на #$rank';
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
      other: '$move места',
      few: '$move места',
      one: '$move место',
    );
    return 'Светска ранг-листа се променила после турнира: $tournament. $nation: ушла као #$from, изашла као #$to, успон за $_temp0.';
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
      other: '$move места',
      few: '$move места',
      one: '$move место',
    );
    return 'Светска ранг-листа се променила после турнира: $tournament. $nation: ушла као #$from, изашла као #$to, пад за $_temp0.';
  }

  @override
  String get rankingSinceWcDraw => 'Од жреба за Светско првенство';

  @override
  String get rankingSinceCycleStart => 'Од почетка похода';

  @override
  String rankingMovedFromTo(int from, int now) {
    return '#$from на #$now';
  }

  @override
  String get rankingSinceWcDrawShort => 'од жреба СП';

  @override
  String get rankingSinceCycleStartShort => 'у овом походу';

  @override
  String get rankingTrend => 'Кретање на ранг-листи';

  @override
  String msgCapsTitle(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count наступа',
      few: '$count наступа',
      one: '$count наступ',
    );
    return '$name: $_temp0 за репрезентацију';
  }

  @override
  String msgCapsBody(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count наступа',
      few: '$count наступа',
      one: '$count наступ',
    );
    return '$name је до сада уписао $_temp0 за твоју репрезентацију.';
  }

  @override
  String msgGoalsTitle(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count голова',
      few: '$count гола',
      one: '$count гол',
    );
    return '$name: $_temp0 за репрезентацију';
  }

  @override
  String msgGoalsBody(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count голова',
      few: '$count гола',
      one: '$count гол',
    );
    return '$name је постигао $_temp0 за твоју репрезентацију.';
  }

  @override
  String msgDevTitle(int year) {
    return 'Развој састава · $year.';
  }

  @override
  String msgThroughTitle(int year) {
    return 'Стигли из академије · $year.';
  }

  @override
  String get msgThroughNote =>
      'Ово није нова генерација. То су дечаци који су дошли са једанаест година и сада су одрасли у сениорски фонд играча.';

  @override
  String msgNewFacesTitle(int year) {
    return 'Нова лица · $year.';
  }

  @override
  String get msgIntakeNoteAcademy =>
      'Улагање у академију се види: ова генерација је стигла јача него што би иначе била.';

  @override
  String get msgIntakeNoteStanding =>
      'Земља прати овај тим: док се репрезентација пење на светској ранг-листи, најбољи дечаци бирају фудбал, па је ова генерација стигла јача.';

  @override
  String get msgIntakeNoteBoth =>
      'Новац за академију и успон репрезентације на светској ранг-листи се виде: ова генерација је стигла јача него што би иначе била.';

  @override
  String msgIntakeTitle(int year) {
    return 'Генерација академије · $year.';
  }

  @override
  String msgRetireCaptainTitle(String name) {
    return 'Твој капитен $name се повлачи';
  }

  @override
  String msgRetireTitle(String name) {
    return '$name се повлачи из репрезентације';
  }

  @override
  String msgRetireBody(String name, int age) {
    return '$name је завршио репрезентативну каријеру са $age година.';
  }

  @override
  String msgRetireBodyWith(String name, String tally, int age) {
    return '$name је завршио репрезентативну каријеру са $age година. Укупно: $tally.';
  }

  @override
  String msgTallyCaps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count наступа',
      few: '$count наступа',
      one: '$count наступ',
    );
    return '$_temp0';
  }

  @override
  String msgTallyGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count голова',
      few: '$count гола',
      one: '$count гол',
    );
    return '$_temp0';
  }

  @override
  String get msgArmbandVacant =>
      ' Капитенска трака је слободна. Именуј новог капитена на екрану позива.';

  @override
  String msgHofTitle(String name) {
    return '$name уврштен у Кућу славних';
  }

  @override
  String msgHofBody(String name, int caps, int goals) {
    String _temp0 = intl.Intl.pluralLogic(
      caps,
      locale: localeName,
      other: '$caps наступа',
      few: '$caps наступа',
      one: '$caps наступ',
    );
    String _temp1 = intl.Intl.pluralLogic(
      goals,
      locale: localeName,
      other: '$goals голова',
      few: '$goals гола',
      one: '$goals гол',
    );
    return '$name улази у Кућу славних твоје репрезентације ($_temp0, $_temp1). Погледај га у Легендама.';
  }

  @override
  String hubBanTitle(String name) {
    return '$name суспендован';
  }

  @override
  String hubBanBody(String name, String how, int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: 'следећих $matches утакмица',
      few: 'следеће $matches утакмице',
      one: 'следећа утакмица',
    );
    return '$name $how. Забрана наступа: $_temp0. Није доступан за избор.';
  }

  @override
  String get hubBanHowSecondYellow => 'је искључен због другог жутог картона';

  @override
  String get hubBanHowViolent =>
      'је добио директан црвени картон због насилничког понашања';

  @override
  String get hubBanHowRed => 'је искључен';

  @override
  String hubInjuryTitle(String name) {
    return '$name повређен';
  }

  @override
  String hubInjuryBody(String name, int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: '$matches утакмица',
      few: '$matches утакмице',
      one: '$matches утакмицу',
    );
    return '$name је повређен и одсуствује $_temp0.';
  }

  @override
  String get hubRunnerUpTitle1 => 'Другопласирани';

  @override
  String get hubRunnerUpTitle2 => 'Тако близу, а тако далеко';

  @override
  String get hubRunnerUpTitle3 => 'Сребрна медаља';

  @override
  String hubRunnerUpBody1(String cup, String opponent) {
    return '$cup: финале изгубљено. Победник: $opponent. Тако близу. Овог пута сребро.';
  }

  @override
  String hubRunnerUpBody2(String cup, String opponent) {
    return 'Пораз у финалу, $cup. Победник: $opponent. Друго место, болно близу.';
  }

  @override
  String hubRunnerUpBody3(String cup, String opponent) {
    return 'Финале ($cup) је измакло. Победник: $opponent. Имаш чиме да се поносиш, али пехар није твој.';
  }

  @override
  String get hubKnockedOutTitle1 => 'Испадање';

  @override
  String get hubKnockedOutTitle2 => 'Крај пута';

  @override
  String get hubKnockedOutTitle3 => 'Путовање је готово';

  @override
  String hubKnockedOutBody1(String cup, String opponent, String stage) {
    return 'Испао си са такмичења: $cup. Фаза: $stage, противник: $opponent.';
  }

  @override
  String hubKnockedOutBody2(String cup, String opponent, String stage) {
    return '$opponent је прекинуо твој пут. $cup, фаза: $stage.';
  }

  @override
  String hubKnockedOutBody3(String cup, String opponent, String stage) {
    return '$cup за тебе завршава. Фаза: $stage, противник: $opponent.';
  }

  @override
  String get hubGroupExitTitle1 => 'Испадање у групи';

  @override
  String get hubGroupExitTitle2 => 'Крај у групи';

  @override
  String get hubGroupExitTitle3 => 'Прерано под туш';

  @override
  String hubGroupExitBody1(String cup) {
    return '$cup: крај у групи. Није било довољно за нокаут фазу.';
  }

  @override
  String hubGroupExitBody2(String cup) {
    return 'Ниси изашао из групе. $cup се овде завршава.';
  }

  @override
  String hubGroupExitBody3(String cup) {
    return 'Овог пута без места у нокаут фази. $cup је готов у групи.';
  }

  @override
  String boardObjectiveMetTitle(String comp) {
    return 'Циљ испуњен: $comp';
  }

  @override
  String boardObjectiveMissedTitle(String comp) {
    return 'Циљ промашен: $comp';
  }

  @override
  String boardObjectiveMetBody(String comp, String demand, String finish) {
    return 'Циљ управе ($comp): $demand. Твој исход: $finish. Добили су шта су тражили.';
  }

  @override
  String boardObjectiveMissedBody(String comp, String demand, String finish) {
    return 'Циљ управе ($comp): $demand. Твој исход: $finish. То је испод очекиваног.';
  }

  @override
  String get newsWcMissTitle => 'Крај сна о Светском првенству';

  @override
  String newsWcMissBody(int year) {
    return 'Ниси се пласирао на Светско првенство $year. Квалификациони поход није био довољан. Још четири године.';
  }

  @override
  String get newsRecordScorerTitle => 'Најбољи стрелац свих времена';

  @override
  String newsRecordScorerBody(String name, int goals) {
    return '$name је сада најбољи стрелац свих времена у игри. Голова: $goals.';
  }

  @override
  String get newsRecordCapsTitle => 'Рекордер по наступима';

  @override
  String newsRecordCapsBody(String name, int caps) {
    return '$name је нови рекордер игре по наступима за репрезентацију. Наступа: $caps.';
  }

  @override
  String get newsARecordBreaker => 'Нови рекордер';

  @override
  String newsTransferTitle(String name, String club) {
    return 'Нови клуб за $name: $club';
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
    return '$name ($position, $rating) мења клуб. Из клуба: $fromClub. У клуб: $destination. Обештећење: $fee.';
  }

  @override
  String newsTransferAbroad(String club, String country) {
    return '$club ($country)';
  }

  @override
  String get newsTransferFree => 'Без обештећења';

  @override
  String newsNatzStarTitle(String name, String nation) {
    return '$name би прешао у репрезентацију: $nation!';
  }

  @override
  String newsNatzTitle(String name, String nation) {
    return '$name жели да игра за репрезентацију: $nation';
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
    return '$name, $position од $age година са оценом $rating, тренутно игра за репрезентацију: $fromNation. Има породичне везе са репрезентацијом: $nation и спреман је да промени дрес. Отвори понуду за натурализацију да је прихватиш или одбијеш.';
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
    return '$name, $position од $age година са оценом $rating, тренутно игра за репрезентацију: $fromNation. Велико је име са породичним везама са репрезентацијом: $nation и спреман је да промени дрес. Отвори понуду за натурализацију да је прихватиш или одбијеш.';
  }

  @override
  String get newsTheirNation => 'њихова земља';

  @override
  String get newsYourNation => 'твоја земља';

  @override
  String get tourStatusChampions => 'ШАМПИОНИ';

  @override
  String get tourStatusFinals => 'ЗАВРШНИЦА';

  @override
  String get tourStatusQualifying => 'КВАЛИФИКАЦИЈЕ';

  @override
  String get tourStatusUpcoming => 'ПРЕДСТОЈИ';

  @override
  String get tourStatusInProgress => 'У ТОКУ';

  @override
  String get tourStatusComingSoon => 'УСКОРО';

  @override
  String get tourStatusDecided => 'ЗАВРШЕНО';

  @override
  String tourStatusLeague(String letter) {
    return 'ЛИГА $letter';
  }

  @override
  String get tourDrawWcQualifying => 'ЖРЕБ КВАЛИФИКАЦИЈА ЗА СП';

  @override
  String tourDrawContQualifying(String cup) {
    return 'ЖРЕБ КВАЛИФИКАЦИЈА: $cup';
  }

  @override
  String get tourDrawWcHost => 'ДОМАЋИН СВЕТСКОГ ПРВЕНСТВА';

  @override
  String tourDrawContHost(String cup) {
    return 'ДОМАЋИН: $cup';
  }

  @override
  String get tourDrawHostsReveal => 'А домаћини ће бити…';

  @override
  String get tourDrawHostReveal => 'А домаћин ће бити…';

  @override
  String get tourDrawHostCandidates => 'Кандидати у трци:';

  @override
  String get tourKickoffContinentalCup => 'КОНТИНЕНТАЛНИ КУП';

  @override
  String tourHostCompetitionYear(String competition, int year) {
    return '$competition $year';
  }

  @override
  String newsContMissTitle(String cup) {
    return '$cup: без пласмана';
  }

  @override
  String newsContMissBody(String cup) {
    return 'Ниси изборио пласман на такмичење: $cup. Поход овог пута није био довољан.';
  }

  @override
  String get potyLabelBest => 'Играч године';

  @override
  String get potyLabelYoung => 'Млади играч године';

  @override
  String potyTallyAssists(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count асистенција',
      few: '$count асистенције',
      one: '$count асистенција',
    );
    return '$_temp0';
  }

  @override
  String potyOverallValue(int value) {
    return 'Оцена $value';
  }

  @override
  String potyRatingValue(String value) {
    return 'Просек $value';
  }

  @override
  String newsPotyTitle(int year) {
    return 'Светски играч године $year';
  }

  @override
  String newsPotyBody(String name) {
    return '$name је ове године најбољи играч на свету.';
  }

  @override
  String newsPotyYoungSuffix(String name) {
    return ' $name осваја награду за младог играча.';
  }

  @override
  String newsWatchTitle(int year) {
    return 'Дечаци које пратиш, $year';
  }

  @override
  String newsWatchJump(String name, int rating, int gain) {
    String _temp0 = intl.Intl.pluralLogic(
      gain,
      locale: localeName,
      other: 'за $gain бодова',
      few: 'за $gain бода',
      one: 'за $gain бод',
    );
    return '$name је напредовао на $rating, $_temp0 више него прошле године.';
  }

  @override
  String newsWatchBand(String name, String band) {
    return '$name прелази у узрасну категорију: $band.';
  }

  @override
  String newsWatchDebutTitle(String name) {
    return '$name дебитује';
  }

  @override
  String newsWatchDebutBody(String name, int age, int rating) {
    return '$name је уписао први наступ за репрезентацију са $age година, са оценом $rating. Један од дечака које пратиш.';
  }

  @override
  String get matchStatsAtFullTime =>
      'Посед лопте, оцене играча и играч утакмице познати су тек после последњег звиждука.';

  @override
  String get matchPlayerRatings => 'ОЦЕНЕ ИГРАЧА';

  @override
  String get matchSubstitutions => 'ИЗМЕНЕ';

  @override
  String get matchSubstitutes => 'КЛУПА';

  @override
  String get matchLineupsViewPitch => 'Терен';

  @override
  String get matchLineupsViewList => 'Списак';

  @override
  String get matchLineupsCameOn => 'Ушли са клупе';

  @override
  String get matchConditionsKickOff => 'Почетак';

  @override
  String get matchWeatherClear => 'Ведро';

  @override
  String get matchWeatherRain => 'Слаба киша';

  @override
  String get matchWeatherSnow => 'Снег';

  @override
  String get matchWeatherHaze => 'Измаглица';

  @override
  String get matchWeatherHeavyRain => 'Јака киша';

  @override
  String get matchWeatherThunderstorm => 'Олуја са грмљавином';

  @override
  String get matchWeatherFog => 'Магла';

  @override
  String get matchWeatherWindy => 'Ветровито';

  @override
  String get matchWeatherDustStorm => 'Пешчана олуја';

  @override
  String get matchWeatherFrostyNight => 'Мразна ноћ';

  @override
  String get matchPlayerOfTheMatch => 'ИГРАЧ УТАКМИЦЕ';

  @override
  String get ratingPlayerOfTheMatch => 'Играч утакмице';

  @override
  String ratingSemantics(String rating) {
    return 'Оцена $rating';
  }

  @override
  String get matchAverageRating => 'Просечна оцена';

  @override
  String get matchLiveRatingsNote =>
      'Оцене прате досадашњи ток утакмице и коначне су после последњег звиждука.';

  @override
  String get matchGoalShout => 'ГОЛ!';

  @override
  String get matchRedCardShout => 'ЦРВЕНИ КАРТОН';

  @override
  String matchShootoutScore(int home, int away) {
    return 'ПЕНАЛИ $home–$away';
  }

  @override
  String matchShootoutKickScored(String name) {
    return '$name: ПОГОДАК';
  }

  @override
  String matchShootoutKickMissed(String name) {
    return '$name: ПРОМАШАЈ';
  }

  @override
  String get matchFeedKickOff => 'Почетни ударац!';

  @override
  String get matchFeedNoEvents => 'Још нема догађаја.';

  @override
  String get tourVenues => 'СТАДИОНИ';

  @override
  String tourPot(int number) {
    return 'ШЕШИР $number';
  }

  @override
  String get tourHostSelection => 'ИЗБОР ДОМАЋИНА';

  @override
  String get tourCandidates => 'КАНДИДАТИ';

  @override
  String get tourJointBid => 'ЗАЈЕДНИЧКА КАНДИДАТУРА';

  @override
  String get tourGoldenGlove => 'НАЈБОЉИ ГОЛМАН';

  @override
  String get tourTeamOfTournament => 'ТИМ ТУРНИРА';

  @override
  String get tourYourRun => 'ТВОЈ ПУТ';

  @override
  String get tourMedalTable => 'ТАБЕЛА МЕДАЉА';

  @override
  String tourHostLine(String nation) {
    return 'Домаћин: $nation';
  }

  @override
  String tourHostLineMulti(String hosts) {
    return 'Домаћини: $hosts';
  }

  @override
  String tourGroupNamed(String name) {
    return 'Група $name';
  }

  @override
  String get tourFinalsDrawBlurb =>
      'Носиоци према светској ранг-листи. Пронађи своју земљу пре жреба.';

  @override
  String get tourWorldRanking => 'Светска ранг-листа';

  @override
  String get tourYourCompetitions => 'ТВОЈА ТАКМИЧЕЊА';

  @override
  String get tourOtherContinents => 'ОСТАЛИ КОНТИНЕНТИ';

  @override
  String get tourZoneGlobal => 'СВЕТ';

  @override
  String get tourZoneEurope => 'ЕВРОПА';

  @override
  String get tourZoneSouthAmerica => 'Ј. АМЕРИКА';

  @override
  String get tourZoneNorthAmerica => 'С. АМЕРИКА';

  @override
  String get tourZoneAfrica => 'АФРИКА';

  @override
  String get tourZoneAsia => 'АЗИЈА';

  @override
  String get tourZoneOceania => 'ОКЕАНИЈА';

  @override
  String get tourZoneIntercontinental => 'ИНТЕРКОНТИНЕНТАЛНО';

  @override
  String tourZoneLeague(String league) {
    return 'ЛИГА $league';
  }

  @override
  String tourHostedBy(String hosts) {
    return 'ДОМАЋИН  $hosts';
  }

  @override
  String tourThirdsAdvance(int count, String destination) {
    return 'Првих $count иде даље у $destination';
  }

  @override
  String newsWalkoutTitle(String name) {
    return '$name одлази';
  }

  @override
  String newsWalkoutBody(String name, int age, int caps) {
    String _temp0 = intl.Intl.pluralLogic(
      caps,
      locale: localeName,
      other: '$caps наступа',
      few: '$caps наступа',
      one: '$caps наступ',
    );
    return '$name се повукао из репрезентативног фудбала са $age година ($_temp0). Тражио је да му се каже на чему је, а нико му није рекао, и више не жели да чека.';
  }

  @override
  String get pressHeadlineWent1 => 'Селектор који држи салу под контролом';

  @override
  String get pressHeadlineWent2 => 'Дошли су по свађу, добили су вођу';

  @override
  String get pressHeadlineWent3 => 'Јасни одговори, и погодили су';

  @override
  String get pressHeadlineMixed1 => 'Много речено, мало решено';

  @override
  String get pressHeadlineMixed2 => 'Понешто за све, а ништа ни за кога';

  @override
  String get pressHeadlineMixed3 =>
      'Конференција која је оставила питања отвореним';

  @override
  String get pressHeadlineBadly1 => 'Тешко поподне пред камерама';

  @override
  String get pressHeadlineBadly2 => 'Сала се окренула, и то се видело';

  @override
  String get pressHeadlineBadly3 =>
      'Одговори који ће ујутру изгледати још горе';

  @override
  String get pressHeadlineFlat1 => 'Ништа речено, ништа добијено';

  @override
  String get pressHeadlineFlat2 => 'Десет минута, нема вести';

  @override
  String get pressHeadlineFlat3 => 'Празна страна за последњу страну';

  @override
  String get pressConferenceTitle => 'КОНФЕРЕНЦИЈА ЗА МЕДИЈЕ';

  @override
  String pressQuestionOf(int index, int total) {
    return 'Питање $index од $total';
  }

  @override
  String get pressTomorrowsHeadline => 'СУТРАШЊА ПОСЛЕДЊА СТРАНА';

  @override
  String get pressLeaveRoom => 'НАПУСТИ САЛУ';

  @override
  String get pressRoomVerdictSquad => 'Свлачионица';

  @override
  String get pressRoomVerdictBoard => 'Управа';

  @override
  String get yReactionElation0 => 'нема замерки. ниједне. савршено.';

  @override
  String get yReactionElation1 => 'није ми добро (у најбољем смислу).';

  @override
  String get yReactionElation2 => 'стављам у рам. изнад камина.';

  @override
  String get yReactionElation3 => 'вратили смо се';

  @override
  String get yReactionElation4 =>
      'Сликам ово за оне који су сумњали. Све до једног.';

  @override
  String get yReactionElation5 =>
      'Бићу неподношљив због овога наредних десет година.';

  @override
  String get yReactionElation6 => 'Ето. Зато гледамо.';

  @override
  String get yReactionElation7 => 'Овакви дани плате све оне друге.';

  @override
  String get yReactionElation8 => 'Било је време. Стварно, било је време.';

  @override
  String get yReactionElation9 =>
      'Супер. Сад то поновите и следеће недеље па ћу да верујем.';

  @override
  String get yReactionElation10 =>
      'Уживајте вечерас, јер ће ови већ наћи начин да то покваре.';

  @override
  String get yReactionElation11 =>
      'Једно добро вече никога не чини великим тимом.';

  @override
  String get yReactionRelief0 => 'Није лепо, али узимам то сваки пут.';

  @override
  String get yReactionRelief1 => 'Некако. Некако!';

  @override
  String get yReactionRelief2 => 'Ружно. Три бода. Идемо даље.';

  @override
  String get yReactionRelief3 =>
      'Узећу ружно сваки дан ако долази са бодовима.';

  @override
  String get yReactionRelief4 => 'ово ми је скинуло десет година живота';

  @override
  String get yReactionRelief5 => 'Нико ни реч. Нико да не урекне.';

  @override
  String get yReactionRelief6 => 'Пулс: неприхватљив.';

  @override
  String get yReactionRelief7 => 'Преживели. То је права реч. Преживели.';

  @override
  String get yReactionRelief8 =>
      'После оваквих утакмица не би требало да нам лакне.';

  @override
  String get yReactionRelief9 =>
      'Лакнуло ми је, а мало ме је и срамота што ми је лакнуло.';

  @override
  String get yReactionRelief10 =>
      'Ако је то стандард који славимо, у невољи смо.';

  @override
  String get yReactionRelief11 => 'Провлачење је навика, а није добра.';

  @override
  String get yReactionFury0 => 'Недовољно добро. Ни близу.';

  @override
  String get yReactionFury1 => 'Нека ми неко то објасни полако.';

  @override
  String get yReactionFury2 => 'Тешко се то гледало, а ја сам још пристојан.';

  @override
  String get yReactionFury3 => 'Разочаран. Стварно разочаран.';

  @override
  String get yReactionFury4 => 'Ужасно стање.';

  @override
  String get yReactionFury5 => 'Тражим имена.';

  @override
  String get yReactionFury6 =>
      'Бришем апликацију. У четвртак је опет инсталирам.';

  @override
  String get yReactionFury7 => 'Нико тамо није изгледао као да то жели.';

  @override
  String get yReactionFury8 => 'Сваке четири године исто. СВАКЕ четири године.';

  @override
  String get yReactionFury9 => 'То није игра, то је увреда.';

  @override
  String get yReactionFury10 =>
      'Људи за то жртвују викенде и новац. Размислите о томе.';

  @override
  String get yReactionFury11 =>
      'Годинама сам бранио овај тим. Вечерас не. Не после овога.';

  @override
  String get yReactionDespair0 => 'па.';

  @override
  String get yReactionDespair1 => 'Данас без шала. Ништа.';

  @override
  String get yReactionDespair2 => 'Идем у шетњу. Дугу.';

  @override
  String get yReactionDespair3 => 'Понестало ми је начина да ово кажем.';

  @override
  String get yReactionDespair4 => 'Пробудите ме за четири године.';

  @override
  String get yReactionDespair5 => 'ово је најмрачнија временска линија';

  @override
  String get yReactionDespair6 =>
      'Чак се више ни не љутим. То је забрињавајуће.';

  @override
  String get yReactionDespair7 => 'Ово ће дуго да боли.';

  @override
  String get yReactionDespair8 =>
      'Више не знам шта је ово, али није фудбалски тим.';

  @override
  String get yReactionDespair9 => 'Даље смо него пре, а нико то неће да каже.';

  @override
  String get yReactionDespair10 =>
      'Пропала је цела генерација, а исти људи одлучују шта следи.';

  @override
  String get yReactionDespair11 =>
      'Престаните да ми говорите да је то процес. Не води никуда.';

  @override
  String get yReactionSmugness0 => 'Тихо, али: рекао сам вам.';

  @override
  String get yReactionSmugness1 => 'сачувајте ово';

  @override
  String get yReactionSmugness2 => 'Они који су сумњали много су се утишали.';

  @override
  String get yReactionSmugness3 => 'Не да неко броји. Ја бројим.';

  @override
  String get yReactionSmugness4 =>
      'Рекао сам у јануару. Проверите хронологију.';

  @override
  String get yReactionSmugness5 => 'Неки од вас дугују некима од нас извињење.';

  @override
  String get yReactionSmugness6 =>
      'Остављам ово под ствари које сам први поменуо.';

  @override
  String get yReactionSmugness7 => 'Без ликовања. Мало ликовања.';

  @override
  String get yReactionSmugness8 => 'Где су сад сви стручњаци? Искрено питање.';

  @override
  String get yReactionSmugness9 => 'Желим да ми свако од вас то понови у лице.';

  @override
  String get yReactionSmugness10 =>
      'Снимак екрана, одштампан, урамљен, послат онима који су се смејали.';

  @override
  String get yReactionSmugness11 =>
      'Помињаћу ово до краја живота и заслужили сте то.';

  @override
  String get yReactionShrug0 => 'десило се. следеће.';

  @override
  String get yReactionShrug1 => 'Добро. Свеједно. Даље.';

  @override
  String get yReactionShrug2 => 'Остављам ово под \'фудбал\'.';

  @override
  String get yReactionShrug3 => 'Стварно немам шта да додам.';

  @override
  String get yReactionShrug4 => 'без мисли, празна глава';

  @override
  String get yReactionShrug5 => 'Пробудите ме за следећу.';

  @override
  String get yReactionShrug6 => 'Деведесет минута које ми нико неће вратити.';

  @override
  String get yReactionShrug7 => 'Ни тамо ни овамо, заправо.';

  @override
  String get yReactionShrug8 =>
      'Не могу да вам кажем ниједну ствар која се десила.';

  @override
  String get yReactionShrug9 => 'Још једна од таквих. Има их много.';

  @override
  String get yReactionShrug10 => 'Гледао сам све и нисам осетио баш ништа.';

  @override
  String get yReactionShrug11 =>
      'Ако се овога више нико не сети, мени је у реду.';

  @override
  String get tourThirdsUneven =>
      'Групе су неједнаке, па се резултати против последњег тима сваке веће групе одбацују и сваки тим се оцењује на истим утакмицама.';

  @override
  String get careerExportSave => 'Резервна копија ове игре';

  @override
  String get careerBackupAll => 'КОПИЈА СВИХ ИГАРА';

  @override
  String get careerBackupAllFailed => 'Није могуће записати резервну копију.';

  @override
  String get backupTitle => 'РЕЗЕРВНЕ КОПИЈЕ';

  @override
  String get backupBlurb =>
      'Сва чувања налазе се у једној датотеци на овом телефону и ништа их не копира само од себе, осим ако доле не укључиш аутоматску копију. Чувај копију у облаку да те изгубљени телефон или обрисана апликација не коштају каријере.';

  @override
  String get backupBlurbNoAuto =>
      'Сва чувања налазе се у једној датотеци на овом телефону и ништа их не копира само од себе. Чувај копију у облаку да те изгубљени телефон или обрисана апликација не коштају каријере.';

  @override
  String get backupExport => 'КОПИЈА У ОБЛАК';

  @override
  String get backupExportSubject => 'FNM сачуване игре';

  @override
  String get backupRestore => 'ВРАТИ ИЗ ДАТОТЕКЕ';

  @override
  String get backupRestoreWarnTitle => 'Заменити све сачуване игре?';

  @override
  String get backupRestoreWarnBody =>
      'Враћање замењује све сачуване игре на овом телефону онима из датотеке. Апликација ће се поново покренути.';

  @override
  String get backupRestoreConfirm => 'ЗАМЕНИ';

  @override
  String get backupCancel => 'ОТКАЖИ';

  @override
  String get backupExported => 'Копија је спремна. Изабери где ћеш је чувати.';

  @override
  String get backupFailed => 'Није могуће записати резервну копију.';

  @override
  String get backupRejectedUnreadable => 'Та датотека није могла да се отвори.';

  @override
  String get backupRejectedNotFnm => 'То није FNM сачувана игра.';

  @override
  String get backupRejectedNewer =>
      'Та игра је направљена новијом верзијом апликације. Прво је ажурирај.';

  @override
  String get backupRejectedTooOld =>
      'Та сачувана игра је престара да би је ова верзија могла вратити.';

  @override
  String get careerShare => 'Подели ову каријеру';

  @override
  String get careerImport => 'УВЕЗИ КАРИЈЕРУ';

  @override
  String get careerShareSubject => 'FNM каријера';

  @override
  String get careerImported => 'Каријера увезена.';

  @override
  String get careerImportFailedUnreadable => 'Та датотека није FNM каријера.';

  @override
  String get careerImportFailedNewer =>
      'Та каријера је извезена новијом верзијом апликације. Прво је ажурирај.';

  @override
  String get careerImportFailedSlotsFull =>
      'Сва твоја места за чување су заузета. Обриши једну игру да направиш места или откључај неограничен број сачуваних игара.';

  @override
  String get careerImportFailedNeedsPremium =>
      'Та каријера је изван бесплатног првог циклуса. Откључај целу игру да је увезеш.';

  @override
  String get careerImportFailedCampaignRun =>
      'За ту кампању већ је у току једна каријера. Прво је настави или напусти.';

  @override
  String get careerShareFailed => 'Није могуће извести ту каријеру.';

  @override
  String get managerRename => 'Промени име';

  @override
  String get managerRenameSave => 'Сачувај';

  @override
  String get managerTitle => 'СЕЛЕКТОР';

  @override
  String get managerSkills => 'ТВОЈЕ ВЕШТИНЕ';

  @override
  String managerPointsAvailable(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count бодова за трошење',
      few: '$count бода за трошење',
      one: '$count бод за трошење',
      zero: 'Нема бодова за трошење',
    );
    return '$_temp0';
  }

  @override
  String get managerPointsHow =>
      'Два бода за сваки завршени циклус, један за сваки освојени трофеј.';

  @override
  String get managerSkillsScale =>
      'Свака вештина почиње од 5 и стаје на 20. Потрошен бод је трајан.';

  @override
  String get managerSkillManManagement => 'Рад са људима';

  @override
  String get managerSkillManManagementBlurb =>
      'Сваки бод чини да твоје речи медијима и играчима 3% јаче одјекну у свлачионици.';

  @override
  String get managerSkillTactical => 'Тактика';

  @override
  String get managerSkillTacticalBlurb =>
      'Сваки бод 3% брже уиграва нову формацију, па промена формације кошта мање утакмица.';

  @override
  String get managerSkillYouth => 'Развој младих';

  @override
  String get managerSkillYouthBlurb =>
      'Сваки бод додаје 1% таленту из твоје академије, поврх онога што у њу улажеш.';

  @override
  String get managerSkillNegotiation => 'Преговарање';

  @override
  String get managerSkillNegotiationBlurb =>
      'Сваки бод доноси 2% више новца од савеза, сваки циклус.';

  @override
  String get managerStaff => 'ТВОЈ СТРУЧНИ ШТАБ';

  @override
  String managerStaffWages(String amount) {
    return 'Плате: $amount по циклусу';
  }

  @override
  String get managerRoleAssistant => 'Помоћник селектора';

  @override
  String get managerRoleAssistantBlurb =>
      'Води тренинге: мање повреда и бољи млади играчи.';

  @override
  String get managerRoleScout => 'Главни скаут';

  @override
  String get managerRoleScoutBlurb =>
      'Прати твоје таленте и следећег противника: тачније звездице и предност на дан утакмице.';

  @override
  String get managerRoleFitness => 'Кондициони тренер';

  @override
  String get managerRoleFitnessBlurb => 'Држи их на терену.';

  @override
  String staffEffectInjury(int percent) {
    return '$percent% мање повреда';
  }

  @override
  String staffEffectYouth(int points) {
    return 'Млади играчи +$points укупне оцене';
  }

  @override
  String staffHiringInjury(int min, int max) {
    return 'Запошљавање: $min% до $max% мање повреда';
  }

  @override
  String staffHiringYouth(int minPoints, int maxPoints) {
    return 'и млади играчи +$minPoints до +$maxPoints укупне оцене';
  }

  @override
  String staffEffectScoutRead(int percent) {
    return 'Тачно процени $percent% талената';
  }

  @override
  String staffEffectScoutCaps(int caps) {
    String _temp0 = intl.Intl.pluralLogic(
      caps,
      locale: localeName,
      other: 'Потенцијал познат после $caps наступа',
      one: 'Потенцијал познат после 1 наступа',
    );
    return '$_temp0';
  }

  @override
  String staffEffectScoutDossier(int points) {
    return '+$points оцене од досијеа противника';
  }

  @override
  String staffHiringScoutRead(int min, int max) {
    return 'Запошљавање: $min% до $max% тачних процена';
  }

  @override
  String staffHiringScoutCaps(int minCaps, int maxCaps) {
    return 'и потенцијал познат $minCaps до $maxCaps наступа раније';
  }

  @override
  String staffHiringScoutDossier(int minPoints, int maxPoints) {
    return 'и +$minPoints до +$maxPoints оцене у свакој утакмици';
  }

  @override
  String get staffEffectNone => 'Још без утицаја на твој састав';

  @override
  String get staffVacant => 'Нико на тој функцији';

  @override
  String get staffLeaveVacant => 'Остави место празно';

  @override
  String get managerTierNone => 'Нема';

  @override
  String get managerTierBasic => 'Основна';

  @override
  String get managerTierGood => 'Добра';

  @override
  String get managerTierElite => 'Елитна';

  @override
  String get managerFree => 'бесплатно';

  @override
  String get managerTraining => 'ИЗМЕЂУ ТЕРМИНА';

  @override
  String get managerTrainingBlurb => 'На чему састав ради кад нема утакмице.';

  @override
  String get managerFocusBalanced => 'Уравнотежено';

  @override
  String get managerFocusBalancedBlurb => 'Свега по мало.';

  @override
  String get managerFocusFitness => 'Кондиција';

  @override
  String get managerFocusFitnessBlurb => 'Мање повреда.';

  @override
  String get managerFocusCohesion => 'Повезаност';

  @override
  String get managerFocusCohesionBlurb => 'Формација се брже уиграва.';

  @override
  String get managerFocusYouth => 'Млади';

  @override
  String get managerFocusYouthBlurb => 'Сати са најмлађима у фонду играча.';

  @override
  String get tourOfferTitle => 'Први пут овде?';

  @override
  String get tourOfferBody =>
      'Ово је велика игра. Желиш ли кратак обилазак кључних екрана? Траје минут, а можеш поново да га покренеш било када из Подешавања.';

  @override
  String get tourOfferYes => 'Покажи ми';

  @override
  String get tourOfferNo => 'Не, хвала';

  @override
  String get tourBack => 'Назад';

  @override
  String get tourNext => 'Даље';

  @override
  String get tourDone => 'Готово';

  @override
  String get tourSkip => 'Прескочи';

  @override
  String get tourHubTitle => 'Ово је цела игра';

  @override
  String get tourHubBody =>
      'Једно дугме које се мења како циклус тече: жреб за гледање, састав за објављивање, утакмица за играње. Изнад њега су поверење управе у тебе и циљеви које су ти поставили.';

  @override
  String get tourBudgetTitle => 'Новац савеза';

  @override
  String get tourBudgetBody =>
      'Једном у сваком четворогодишњем циклусу делиш благајну међу одељењима. Из ње се прво плаћа стручни штаб, па је запошљавање елитног скаута одлука против академије, а не уз њу.';

  @override
  String get tourTacticsTitle => 'Како екипа игра';

  @override
  String get tourTacticsBody =>
      'Твоја формација, твој стил игре, твој капитен и ко изводи прекиде. Ако последња два оставиш неодређена, игра ће те упозорити пре почетног ударца, уместо да тихо бира уместо тебе.';

  @override
  String get tourSquadTitle => 'Сви које можеш да изабереш';

  @override
  String get tourSquadBody =>
      'Цео фонд играча, не само састав: ко је у форми, ко има повреду, ко је суспендован и ко је управо стигао из академије.';

  @override
  String get tourCallUpsTitle => 'Објава списка';

  @override
  String get tourCallUpsBody =>
      'За сваки међународни термин објављујеш један списак и он игра сваку утакмицу тог термина, баш као прави селектор. Повреда унутар термина аутоматски доводи замену.';

  @override
  String get tourRecordsTitle => 'Твоја каријера';

  @override
  String get tourRecordsBody =>
      'Све што си урадио: утакмице, рекорди тима, трофеји и свака репрезентација коју си водио.';

  @override
  String get tourCupsTitle => 'Остатак света';

  @override
  String get tourCupsBody =>
      'Сва такмичења која се тренутно играју: групе, табеле и нокаут фазе, укључујући и она у којима не играш. Свет игра даље без обзира на то да ли си се пласирао.';

  @override
  String get settingsTourTitle => 'Понови упутство';

  @override
  String get settingsTourBlurb => 'Поново прођи кроз кључне екране од почетка.';

  @override
  String get tourBoardTitle => 'Коме одговараш';

  @override
  String get tourBoardBody =>
      'Поверење управе у тебе и циљеви које ти је поставила за овај циклус. Ако промашиш задатак, овде ћеш видети да долази.';

  @override
  String get tourStaffTitle => 'Људи око тебе';

  @override
  String get tourStaffBody =>
      'Помоћник, скаут и кондициони тренер, запослени по имену. Њихове плате иду из овог буџета пре одељења, па је сјајан скаут одлука против академије.';

  @override
  String get tourPlaystyleTitle => 'Твој стил игре';

  @override
  String get tourPlaystyleBody =>
      'Формација је само пола тактике. Ово је друга половина: колико високо пресингујеш, колико си директан, колико ризикујеш.';

  @override
  String get settingsTourNoSave =>
      'Прво започни каријеру. Обилазак води кроз твоје екране.';

  @override
  String tacticsOutOfPositionAge(int age) {
    return 'Ван позиције · $age год.';
  }

  @override
  String get federationNextCycleLocked =>
      'Буџет следећег циклуса одређује се на почетку тог циклуса, одједном. До тада, ово је оно што твој новац ради.';

  @override
  String get federationBudgetAlreadySet => 'Већ одређено за овај циклус';

  @override
  String yFinalLooms0(String opponent) {
    return 'Противник у великом финалу: $opponent. Целе недеље нико неће причати ни о чему другом.';
  }

  @override
  String yFinalLooms1(String opponent) {
    return 'Потврђено: $opponent је једино што стоји између нас и тога. Четири године за ово.';
  }

  @override
  String yFinalLooms2(String opponent) {
    return 'Добро. $opponent. Нико не спава док се ово не заврши.';
  }

  @override
  String yFinalLooms3(String opponent) {
    return 'Следећи је $opponent, а све остало може да сачека. Каква недеља.';
  }

  @override
  String get matchSetupLeaveToCoach => 'Препусти извођаче тренеру';

  @override
  String friendliesLikeYourGroup(String rivals) {
    return 'Означено испод: екипе које играју као $rivals, противници које овог циклуса срећеш у групама.';
  }

  @override
  String newsTransferWindowTitle(int year) {
    return 'Прелазни рок · $year';
  }

  @override
  String careerLastAgo(String when) {
    return 'Последњи пут: пре $when';
  }

  @override
  String get settingsFreeScopeTitle => 'Један бесплатни четворогодишњи циклус';

  @override
  String get settingsFreeScopeBlurb =>
      'Цео циклус (квалификације, твоје континентално првенство и Светско првенство) на две сачуване игре, све земље света, без ограничења. Неограничени циклуси и сачуване игре долазе уз једну уплату, само једном, са укљученим ажурирањима.';

  @override
  String get settingsUnlockedTitle => 'Откључано';

  @override
  String get settingsUnlockedBlurb =>
      'Неограничени циклуси, неограничене сачуване игре, ажурирања укључена. Хвала ти.';

  @override
  String get settingsFromDeveloperTitle => 'Од аутора игре';

  @override
  String get settingsFromDeveloperBlurb =>
      'Football Nations Manager прави једна особа и биће дугорочно подржаван. Никада неће бити реклама ни микротрансакција. Ако уживаш у игри, размисли о куповини пуне верзије. Тако се одржавају ажурирања.';

  @override
  String get settingsFromDeveloperThanksBlurb =>
      'Football Nations Manager прави једна особа и биће дугорочно подржаван. Никада неће бити реклама ни микротрансакција. Хвала ти што си купио пуну верзију. Тако се одржавају ажурирања.';

  @override
  String friendliesLikeYourCampaign(String rivals) {
    return 'Означено испод: екипе које играју као $rivals, противници који те тек чекају.';
  }

  @override
  String get friendliesCloseToYou =>
      'Означено испод: екипе најближе теби на светској ранг-листи. После жреба ознаке прате твоју групу.';

  @override
  String transfersMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count трансфера',
      few: '$count трансфера',
      one: '$count трансфер',
    );
    return '$_temp0';
  }

  @override
  String hubRoundPage(int page, int pages) {
    return '$page / $pages';
  }

  @override
  String get transfersNewer => 'Новије';

  @override
  String get transfersOlder => 'Још';

  @override
  String get transfersPagePrevious => 'Претходна';

  @override
  String get transfersPageNext => 'Следећа';

  @override
  String transfersPageOf(int page, int pages) {
    return 'Страна $page од $pages';
  }

  @override
  String get transfersMovedTo => 'Прешао у';

  @override
  String get transfersUnknownClub => 'Непознат клуб';

  @override
  String yAgainstThemAgain0(String opponent, int count) {
    return 'Против: $opponent, већ $count. пут. Неко води рачуна о резултату, и то су они.';
  }

  @override
  String yAgainstThemAgain1(String opponent, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count сусрета',
      few: '$count сусрета',
      one: '$count сусрет',
    );
    return 'Опет $opponent. $_temp0, а још их нисмо прочитали.';
  }

  @override
  String yAgainstThemAgain2(String opponent, int count) {
    return 'Сусрет број $count: $opponent. Ово више није случајност.';
  }

  @override
  String yAgainstThemAgain3(String opponent, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count утакмица',
      few: '$count утакмице',
      one: '$count утакмица',
    );
    return '$opponent: $_temp0 и ниједна нас ништа није научила.';
  }

  @override
  String yAgainstThemAgain4(String opponent, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count пута',
      few: '$count пута',
      one: '$count пут',
    );
    return '$opponent, $_temp0. Тачно знају шта ћемо урадити.';
  }

  @override
  String yAgainstThemAgain5(String opponent, int count) {
    return 'Шта год $opponent има против нас, после $count сусрета то још увек има.';
  }

  @override
  String ySameOldStory0(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count пута',
      few: '$count пута',
      one: '$count пут',
    );
    return '$_temp0 нам се ово недавно десило. Када ћемо признати да смо то ми?';
  }

  @override
  String ySameOldStory1(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count оваквих поподнева',
      few: '$count оваква поподнева',
      one: '$count овакво поподне',
    );
    return 'Већ $_temp0. То је образац, а не низ лоше среће.';
  }

  @override
  String ySameOldStory2(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count пута',
      few: '$count пута',
      one: '$count пут',
    );
    return 'Ову исту утакмицу видели смо $_temp0 у последње време. Исти сценарио, исти крај.';
  }

  @override
  String ySameOldStory3(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count верзија',
      few: '$count верзије',
      one: '$count верзија',
    );
    return '$_temp0 истих деведесет минута. Нико то не поправља.';
  }

  @override
  String ySameOldStory4(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count пута',
      few: '$count пута',
      one: '$count пут',
    );
    return '$_temp0. Ако до сада не видиш образац, не гледаш.';
  }

  @override
  String ySameOldStory5(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count пута',
      few: '$count пута',
      one: '$count пут',
    );
    return 'Иста прича, $_temp0 заредом. Изговори су нестали пре резултата.';
  }

  @override
  String get yToldYouSo0 => 'Рекао сам да ово долази док су сви славили.';

  @override
  String get yToldYouSo1 =>
      'Две добре недеље и опет смо златна генерација. И ево нас.';

  @override
  String get yToldYouSo2 =>
      'Они што су ми прошлог месеца говорили да уживам сад су утихнули.';

  @override
  String get yToldYouSo3 => 'Не уживам у овоме. Врло мало. Ипак мало.';

  @override
  String get yToldYouSo4 =>
      'Никад није било тако добро како су вам говорили, а ово је доказ.';

  @override
  String get yToldYouSo5 =>
      'Сваки пут. Кажу нам да је другачије и сваки пут није.';

  @override
  String get tacticsSubOffAlready => 'Већ изашао';

  @override
  String get tacticsSubInjured => 'Повређен';

  @override
  String get tacticsSubSentOffMark => 'Искључен';

  @override
  String get tacticsSubNoneLeft => 'Нема више измена';

  @override
  String get tacticsUndoLastChange => 'Поништи последњу измену';

  @override
  String get matchStrengthTitle => 'ШТА ПОМЕРА ЕКИПУ';

  @override
  String get strengthFactorFamiliarity => 'Уиграна формација';

  @override
  String get strengthFactorFatigue => 'Уморне ноге';

  @override
  String get strengthFactorClubForm => 'Форма у клубу';

  @override
  String get strengthFactorMorale => 'Свлачионица';

  @override
  String get strengthFactorCaptain => 'Капитен';

  @override
  String get strengthFactorStaff => 'Стручни штаб';

  @override
  String get strengthFactorDossier => 'Скаутски досије';

  @override
  String yDebut0(String name) {
    return '$name уписује први наступ за репрезентацију. Запамтите име.';
  }

  @override
  String yDebut1(String name) {
    return 'Деби за $name. Види се то на њему, зар не?';
  }

  @override
  String yDebut2(String name) {
    return '$name, први наступ. Да видимо шта ће с тим.';
  }

  @override
  String yDebut3(String name) {
    return 'Деби за $name. Саставу су негде требале свеже ноге.';
  }

  @override
  String yDebut4(String name) {
    return '$name добио наступ. У последње време делимо их много.';
  }

  @override
  String yDebut5(String name) {
    return 'Деби за $name. Још један ког ћемо до пролећа заборавити.';
  }

  @override
  String yDrought0(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count утакмица',
      few: '$count утакмице',
      one: '$count утакмицу',
    );
    return '$name $_temp0 није дао гол, а све остало на терену ради.';
  }

  @override
  String yDrought1(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count утакмица',
      few: '$count утакмице',
      one: '$count утакмица',
    );
    return '$_temp0 без гола за $name. Долазе у низу, увек је тако.';
  }

  @override
  String yDrought2(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count утакмица',
      few: '$count утакмице',
      one: '$count утакмица',
    );
    return '$name: $_temp0, нула голова.';
  }

  @override
  String yDrought3(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count утакмица',
      few: '$count утакмице',
      one: '$count утакмица',
    );
    return '$_temp0 без гола за $name. Вреди га пратити.';
  }

  @override
  String yDrought4(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count утакмица',
      few: '$count утакмице',
      one: '$count утакмица',
    );
    return '$_temp0. Ниједан гол. $name не би погодио ни врата од штале.';
  }

  @override
  String yDrought5(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count утакмица',
      few: '$count утакмице',
      one: '$count утакмицу',
    );
    return '$name није дао гол $_temp0. Играјте било кога другог.';
  }

  @override
  String yRivalryLooms0(String opponent, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count сусрета',
      few: '$count сусрета',
      one: '$count сусрет',
    );
    return 'Следећи је $opponent. $_temp0 и још увек значи све.';
  }

  @override
  String yRivalryLooms1(String opponent, int count) {
    return 'Већ $count. пут против: $opponent. Нека дођу.';
  }

  @override
  String yRivalryLooms2(String opponent, int count) {
    return 'Следећи је $opponent. Одиграно: $count.';
  }

  @override
  String yRivalryLooms3(String opponent, int count) {
    return 'Ове недеље сусрет број $count: $opponent.';
  }

  @override
  String yRivalryLooms4(String opponent, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count оваквих',
      few: '$count оваква',
      one: '$count овакав',
    );
    return 'Опет $opponent. $_temp0 и ништа нисмо научили.';
  }

  @override
  String yRivalryLooms5(String opponent, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count утакмица',
      few: '$count утакмице',
      one: '$count утакмица',
    );
    return '$_temp0 против: $opponent и још нас побеђују. Сјајно.';
  }

  @override
  String get positionGoalkeeper => 'Голман';

  @override
  String get positionLeftBack => 'Леви бек';

  @override
  String get positionCentreBack => 'Штопер';

  @override
  String get positionRightBack => 'Десни бек';

  @override
  String get positionDefensiveMid => 'Дефанзивни везни';

  @override
  String get positionCentralMid => 'Централни везни';

  @override
  String get positionAttackingMid => 'Офанзивни везни';

  @override
  String get positionLeftMid => 'Леви везни';

  @override
  String get positionRightMid => 'Десни везни';

  @override
  String get positionLeftWing => 'Лево крило';

  @override
  String get positionRightWing => 'Десно крило';

  @override
  String get positionStriker => 'Нападач';

  @override
  String get roleNone => 'Без улоге';

  @override
  String get roleTargetMan => 'Циљни нападач';

  @override
  String get rolePoacher => 'Ловац на голове';

  @override
  String get rolePlaymaker => 'Креатор игре';

  @override
  String get roleBallWinner => 'Освајач лопте';

  @override
  String get roleInvertedWinger => 'Инвертовано крило';

  @override
  String get roleBallPlayingDefender => 'Штопер који гради игру';

  @override
  String get roleNoneBlurb => 'Игра своју природну игру.';

  @override
  String get roleTargetManBlurb =>
      'Осваја скокове, спушта лопту. Асистенције и прекиди.';

  @override
  String get rolePoacherBlurb => 'Вреба у шеснаестерцу. Много више голова.';

  @override
  String get rolePlaymakerBlurb => 'Ствара шансе. Далеко више асистенција.';

  @override
  String get roleBallWinnerBlurb => 'Разбија игру, а не завршава је.';

  @override
  String get roleInvertedWingerBlurb => 'Улази унутра да шутира. Више голова.';

  @override
  String get roleBallPlayingDefenderBlurb => 'Гради нападе из одбране.';

  @override
  String get roleLineKeeper => 'Голман на линији';

  @override
  String get roleSweeperKeeper => 'Голман либеро';

  @override
  String get roleStopper => 'Стопер';

  @override
  String get roleCoveringDefender => 'Покривајући штопер';

  @override
  String get roleDefensiveFullBack => 'Дефанзивни бек';

  @override
  String get roleWingBack => 'Крилни бек';

  @override
  String get roleInvertedFullBack => 'Инвертовани бек';

  @override
  String get roleAnchor => 'Сидро';

  @override
  String get roleDeepPlaymaker => 'Дубоки плејмејкер';

  @override
  String get roleBoxToBox => 'Бокс-ту-бокс';

  @override
  String get roleShadowStriker => 'Скривени нападач';

  @override
  String get roleTouchlineWinger => 'Крило уз аут-линију';

  @override
  String get roleDefensiveWinger => 'Дефанзивно крило';

  @override
  String get roleFalseNine => 'Лажна деветка';

  @override
  String get rolePressingForward => 'Нападач који пресира';

  @override
  String get roleLineKeeperBlurb =>
      'Остаје на линији. Сигурнији, спорије покреће игру.';

  @override
  String get roleSweeperKeeperBlurb => 'Чисти иза одбране и покреће нападе.';

  @override
  String get roleStopperBlurb => 'Излази да рано освоји лопту. Јак у ваздуху.';

  @override
  String get roleCoveringDefenderBlurb => 'Повлачи се и покрива простор иза.';

  @override
  String get roleDefensiveFullBackBlurb => 'Остаје позади и чува своју страну.';

  @override
  String get roleWingBackBlurb => 'Преклапа и центрира. Много трчи.';

  @override
  String get roleInvertedFullBackBlurb =>
      'Улази у везни ред и помаже да се задржи лопта.';

  @override
  String get roleAnchorBlurb => 'Штити одбрамбену линију. Ретко даје голове.';

  @override
  String get roleDeepPlaymakerBlurb => 'Води игру из дубине. Више асистенција.';

  @override
  String get roleBoxToBoxBlurb => 'Горе-доле целу утакмицу. Треба издржљивост.';

  @override
  String get roleShadowStrikerBlurb =>
      'Касно улеће у шеснаестерац. Више голова.';

  @override
  String get roleTouchlineWingerBlurb =>
      'Држи се аут-линије и центрира. Више асистенција.';

  @override
  String get roleDefensiveWingerBlurb => 'Враћа се да штити бека.';

  @override
  String get roleFalseNineBlurb =>
      'Повлачи се и повезује игру. Више ствара него што даје голове.';

  @override
  String get rolePressingForwardBlurb => 'Води прес напред. Брже се умара.';

  @override
  String get federationDeptYouth => 'Омладинска академија';

  @override
  String get federationDeptCommercial => 'Комерцијала / PR';

  @override
  String get federationDeptMedical => 'Медицина и спортска наука';

  @override
  String get federationDeptNaturalisation => 'Канцеларија за натурализацију';

  @override
  String get federationDeptBoardRelations => 'Односи са управом';

  @override
  String get federationDeptYouthBlurb =>
      'Бољи таленти из академије дебитују за твоју репрезентацију следећег циклуса.';

  @override
  String get federationDeptCommercialBlurb =>
      'Спонзорство доноси додатни приход на крају циклуса.';

  @override
  String get federationDeptMedicalBlurb =>
      'Мање повреда. Састав остаје доступан цео циклус.';

  @override
  String get federationDeptNaturalisationBlurb =>
      'Више страних играча нуди прелазак у твоју репрезентацију.';

  @override
  String get federationDeptBoardRelationsBlurb =>
      'Управа стрпљивије оцењује твоје резултате.';

  @override
  String get federationBuildingAcademy => 'Академија';

  @override
  String get federationBuildingCommercial => 'Комерцијално седиште';

  @override
  String get federationBuildingMedical => 'Медицински центар';

  @override
  String get federationBuildingScouting => 'Скаутска канцеларија';

  @override
  String get federationBuildingBoardroom => 'Сала управе';

  @override
  String get moraleBuoyant => 'Ведар';

  @override
  String get moralePositive => 'Позитиван';

  @override
  String get moraleSettled => 'Стабилан';

  @override
  String get moraleUneasy => 'Немиран';

  @override
  String get moraleRockBottom => 'На дну';

  @override
  String get matchTabTimeline => 'ТОК';

  @override
  String get matchTabStats => 'СТАТИСТИКА';

  @override
  String get matchTabLineups => 'ПОСТАВЕ';

  @override
  String get matchPenalty => 'ПЕНАЛ';

  @override
  String get matchStateLevel => 'Резултат је нерешен';

  @override
  String matchStateLead(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Водиш са $count голова разлике',
      few: 'Водиш са $count гола разлике',
      one: 'Водиш са $count голом разлике',
    );
    return '$_temp0';
  }

  @override
  String matchStateTrail(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Заостајеш $count голова',
      few: 'Заостајеш $count гола',
      one: 'Заостајеш $count гол',
    );
    return '$_temp0';
  }

  @override
  String matchPossessionShare(int possession) {
    return '$possession% поседа лопте';
  }

  @override
  String get boardVerdictSackedTitle => 'Управа те је сменила';

  @override
  String boardVerdictSackedBody(int rating) {
    return 'Лош циклус (оцена $rating%). Твоја владавина се овде завршава. Сада ће те ангажовати само слабије репрезентације.';
  }

  @override
  String get boardVerdictDelightedTitle => 'Управа је одушевљена';

  @override
  String boardVerdictDelightedBody(int rating, String best) {
    return 'Изванредан циклус (оцена $rating%). Најбољи учинак: $best. Веће репрезентације су заинтересоване, или можеш да останеш и градиш.';
  }

  @override
  String get boardVerdictSolidTitle => 'Солидан циклус';

  @override
  String boardVerdictSolidBody(int rating) {
    return 'Управа је задовољна (оцена $rating%). Неколико репрезентација сличног ранга примило би те, али нема притиска да одеш.';
  }

  @override
  String get boardVerdictExpectedMoreTitle => 'Управа је очекивала више';

  @override
  String boardVerdictExpectedMoreBody(int rating) {
    return 'Разочаравајући циклус (оцена $rating%). Задржаваш посао, али све понуде су корак уназад.';
  }

  @override
  String get boardVerdictPressureTitle => 'Под озбиљним си притиском';

  @override
  String boardVerdictPressureBody(int rating) {
    return 'Слаб циклус (оцена $rating%). Преживљаваш, али ако пожелиш нови почетак, занимају се само слабије земље.';
  }

  @override
  String get boardVerdictHeroTitle => 'Земља стоји уз тебе';

  @override
  String boardVerdictHeroNote(String nation, int cycles) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles циклуса',
      few: '$cycles циклуса',
      one: '$cycles циклуса',
    );
    return ' $nation те обожава, национални си херој после $_temp0; посао ти је сигуран колико год желиш.';
  }

  @override
  String get boardVerdictTheNation => 'Земља';

  @override
  String get boardVerdictBestQuiet => 'миран циклус';

  @override
  String get boardVerdictBestCycle => 'циклус у целини';

  @override
  String boardVerdictBestWorld(String placement) {
    return 'Светско првенство: $placement';
  }

  @override
  String get finishThirdPlace => 'Треће место';

  @override
  String get finishFourthPlace => 'Четврто место';

  @override
  String get finishDidNotQualify => 'Није се квалификовао';

  @override
  String get careerRepIconic => 'Икона';

  @override
  String get careerRepRenowned => 'Угледан';

  @override
  String get careerRepEstablished => 'Афирмисан';

  @override
  String get careerRepRising => 'У успону';

  @override
  String get careerRepUnproven => 'Неафирмисан';

  @override
  String get hubOfferStepUp => 'Корак напред';

  @override
  String get hubOfferLateral => 'Исти ранг';

  @override
  String get hubOfferRebuild => 'Обнова';

  @override
  String careerNationsCupWon(String league) {
    return 'Лига $league · Прваци';
  }

  @override
  String careerNationsCupRunnerUp(String league) {
    return 'Лига $league · Другопласирани';
  }

  @override
  String careerNationsCupSemi(String league) {
    return 'Лига $league · Полуфиналиста';
  }

  @override
  String careerNationsCupPlaced(String league, int position) {
    return 'Лига $league · #$position';
  }

  @override
  String tourRunInto(String round) {
    return 'Следеће: $round';
  }

  @override
  String get tourRunIntoThirdPlace => 'Следеће: утакмица за треће место';

  @override
  String tourRunThrough(String round) {
    return 'Прошао даље: $round';
  }

  @override
  String tourRunOut(String round) {
    return 'Испао: $round';
  }

  @override
  String get tourRunInGroup => 'Такмичење по групама траје';

  @override
  String get tourRunGroupOut => 'Испао у такмичењу по групама';

  @override
  String resultsCycleTitle(int year, String nation) {
    return 'Циклус $year · $nation';
  }

  @override
  String resultsCycleRecord(int played, int won, int drawn, int lost) {
    return '$played одиграно  ·  $wonП $drawnН $lostИ';
  }

  @override
  String resultsCycleFinish(String finish) {
    return 'Светско првенство: $finish';
  }

  @override
  String get resultsCycleUnderway => 'Још траје';

  @override
  String yTurnedItRound0(String opponent) {
    return 'Полувреме: два гола заостатка (противник: $opponent), а све су вратили до последњег. То је тим.';
  }

  @override
  String yTurnedItRound1(String opponent) {
    return 'Два гола заостатка, противник $opponent, а на крају више није било важно. Мало ко то може.';
  }

  @override
  String yTurnedItRound2(String opponent) {
    return 'Полувреме: два гола минуса. Крај утакмице: више не. Противник: $opponent. Друго полувреме било је потпуно друга утакмица.';
  }

  @override
  String yTurnedItRound3(String opponent) {
    return 'Преокрет после заостатка од два гола, противник $opponent. Шта год да је речено у свлачионици, реците то сваке недеље.';
  }

  @override
  String yTurnedItRound4(String opponent) {
    return 'Добро, вратили смо се (противник: $opponent). А сад нека ми неко објасни оних првих четрдесет пет минута.';
  }

  @override
  String yTurnedItRound5(String opponent) {
    return 'Два гола минуса, противник $opponent, а ми би требало да будемо одушевљени. Поправите прво полувреме.';
  }

  @override
  String yThrewItAway0(String opponent) {
    return 'На полувремену два гола предности (противник: $opponent) и све је отишло. То се дешава и бољима.';
  }

  @override
  String yThrewItAway1(String opponent) {
    return 'Два гола предности, противник $opponent, и све је пропало. Пред нама је дуг циклус, има времена.';
  }

  @override
  String yThrewItAway2(String opponent) {
    return 'Полувреме: два гола плуса. Крај утакмице: ништа слично. Противник: $opponent.';
  }

  @override
  String yThrewItAway3(String opponent) {
    return 'Предност од два гола, противник $opponent, нестала за свега четрдесет пет минута.';
  }

  @override
  String yThrewItAway4(String opponent) {
    return 'Два гола испред и све смо изгубили. Противник: $opponent. Неко ће за то одговарати.';
  }

  @override
  String yThrewItAway5(String opponent) {
    return 'Два гола предности, противник $opponent, а ми смо успели ово. Сваки пут.';
  }

  @override
  String get cycleBackupDone =>
      'Каријера је сачувана у FNM фасциклу на овом телефону. Деинсталирањем апликације брише се и она: ако желиш копију на другом месту, на екрану сачуваних игара употреби „Резервна копија ове игре“.';

  @override
  String get cycleBackupFailed =>
      'Овај пут није било могуће направити резервну копију каријере.';

  @override
  String pressMomentBigWinWarm1(String opponent) {
    return 'Ноћ за памћење (противник: $opponent). Колико сте поносни на ову екипу?';
  }

  @override
  String pressMomentBigWinWarm2(String opponent) {
    return 'Противник $opponent није могао да Вам парира. Да ли је ово тим у који сте одувек веровали?';
  }

  @override
  String pressMomentBigWinNeutral1(String opponent) {
    return 'Велика победа, противник $opponent. Шта је вечерас направило разлику?';
  }

  @override
  String pressMomentBigWinNeutral2(String opponent) {
    return 'Противник $opponent савладан, и то без проблема. Где сте добили утакмицу?';
  }

  @override
  String pressMomentBigWinHostile1(String opponent) {
    return 'Добра победа, противник $opponent. Једно добро вече: зашто би ико веровао да ће потрајати?';
  }

  @override
  String pressMomentBigWinHostile2(String opponent) {
    return 'Леп резултат, противник $opponent. Да ли је то био Ваш план или су играчи сами смислили шта треба?';
  }

  @override
  String pressMomentBigLossWarm1(String opponent) {
    return 'Тешко вече, противник $opponent. Шта поручујете играчима после овакве утакмице?';
  }

  @override
  String pressMomentBigLossWarm2(String opponent) {
    return 'Нико то није очекивао, противник $opponent. Да ли је то било једноставно једно од оних вечери?';
  }

  @override
  String pressMomentBigLossNeutral1(String opponent) {
    return 'Ово је било поражавајуће вече, противник $opponent. Шта је пошло наопако?';
  }

  @override
  String pressMomentBigLossNeutral2(String opponent) {
    return '$opponent Вас је растурио. Да ли је овај састав довољно добар?';
  }

  @override
  String pressMomentBigLossHostile1(String opponent) {
    return 'Против противника $opponent заостајали сте у свему. Како сте дозволили да дође до овога?';
  }

  @override
  String pressMomentBigLossHostile2(String opponent) {
    return '$opponent је давао голове како је хтео. Где је вечерас био план?';
  }

  @override
  String pressMomentCrisisWarm1(String opponent) {
    return 'Опет нам је измакло, овај пут противник: $opponent. Како преокренути овај низ?';
  }

  @override
  String pressMomentCrisisWarm2(String opponent) {
    return 'Резултата нема, а $opponent је све погоршао. Да ли још верујете у ову екипу?';
  }

  @override
  String pressMomentCrisisNeutral1(String opponent) {
    return 'Опет без победе, овај пут против: $opponent, а управа прати. Да ли је Ваш посао сигуран?';
  }

  @override
  String pressMomentCrisisNeutral2(String opponent) {
    return 'После утакмице с противником $opponent низ постаје дуг. Да ли Вас брине сопствена будућност?';
  }

  @override
  String pressMomentCrisisHostile1(String opponent) {
    return 'И противник $opponent поврх свега. Ваш претходник је добио отказ после оваквог низа. Зашто бисте Ви преживели?';
  }

  @override
  String pressMomentCrisisHostile2(String opponent) {
    return 'После још једне овакве вечери (противник: $opponent) свака радио-емисија тражи Ваш одлазак. Да ли бисте поднели оставку кад би управа то затражила?';
  }

  @override
  String pressMomentJobVerdictWarm1(String opponent) {
    return 'Ставили сте посао на коцку, а после утакмице с противником $opponent није испало по Вашем. Како се држите?';
  }

  @override
  String pressMomentJobVerdictWarm2(String opponent) {
    return 'Три утакмице су готове, последња против: $opponent. Тест сте поставили сами. Шта мислите о пресуди?';
  }

  @override
  String pressMomentJobVerdictNeutral1(String opponent) {
    return 'Рекли сте нам да Вам судимо по следеће три. После утакмице с противником $opponent, јесмо. Да ли је посао још Ваш?';
  }

  @override
  String pressMomentJobVerdictNeutral2(String opponent) {
    return 'Три утакмице, последња против: $opponent, а не оно што сте обећали. Да ли сте с управом разговарали о својој будућности?';
  }

  @override
  String pressMomentJobVerdictHostile1(String opponent) {
    return 'Тест сте поставили сами и пали сте на њему (противник: $opponent). Хоћете ли поднети оставку?';
  }

  @override
  String pressMomentJobVerdictHostile2(String opponent) {
    return 'Ваше речи, не наше: судите ми по следеће три. После утакмице с противником $opponent, зашто још седите овде?';
  }

  @override
  String get pressBeatWhoToBlameWarm1 => 'Желите више од њих. Неко посебно?';

  @override
  String get pressBeatWhoToBlameWarm2 =>
      'Високо сте подигли лествицу. Ко први мора да искорачи?';

  @override
  String get pressBeatWhoToBlameNeutral1 =>
      'Кажете да неки од њих морају да погледају себе. На кога мислите?';

  @override
  String get pressBeatWhoToBlameNeutral2 =>
      'Кажете да није довољно добро. О коме говорите?';

  @override
  String get pressBeatWhoToBlameHostile1 =>
      'Остајете неодређени. Хоћете ли да кажете имена или све пада на Вас?';

  @override
  String get pressBeatWhoToBlameHostile2 =>
      'Сваке недеље крив је неко други. Ко је овај пут?';

  @override
  String get pressBeatIfYouDontWarm1 =>
      'Храбре речи. А ако следећа не испадне по Вашем?';

  @override
  String get pressBeatIfYouDontWarm2 =>
      'Земља ће Вас држати за реч. Шта ако не успе?';

  @override
  String get pressBeatIfYouDontNeutral1 => 'А ако је не добијете? Шта онда?';

  @override
  String get pressBeatIfYouDontNeutral2 => 'Сад сте то рекли. Шта ако грешите?';

  @override
  String get pressBeatIfYouDontHostile1 =>
      'У овој просторији смо већ чули обећања. Шта дугујете навијачима ако и ово пропадне?';

  @override
  String get pressBeatIfYouDontHostile2 =>
      'А кад се то не деси, шта ће бити изговор?';

  @override
  String get pressBeatFollowUpWarm1 =>
      'Још једно, ако имате снаге. На чему ова екипа још мора да ради?';

  @override
  String get pressBeatFollowUpWarm2 =>
      'Кад се слегне прашина, шта из вечерашње утакмице носите у следећу?';

  @override
  String get pressBeatFollowUpNeutral1 =>
      'Идемо мало дубље. Шта мора да се поправи пре следеће утакмице?';

  @override
  String get pressBeatFollowUpNeutral2 =>
      'Ако погледамо даље од резултата: да ли је овај састав тамо где га желите?';

  @override
  String get pressBeatFollowUpHostile1 =>
      'Много речи, мало речено. Шта се заправо мења од сада?';

  @override
  String get pressBeatFollowUpHostile2 =>
      'Навијачи желе директан одговор. Да ли је овај тим довољно добар, да или не?';

  @override
  String pressBeatStandoutWarm1(String player) {
    return '$player је вечерас био изванредан. Докле може да стигне?';
  }

  @override
  String pressBeatStandoutWarm2(String player) {
    return '$player је вечерас у свим насловима. Да ли сте то очекивали?';
  }

  @override
  String pressBeatStandoutNeutral1(String player) {
    return '$player се истакао. Шта сте вечерас тражили од њега?';
  }

  @override
  String pressBeatStandoutNeutral2(String player) {
    return 'Да ли је $player вечерас направио разлику?';
  }

  @override
  String pressBeatStandoutHostile1(String player) {
    return 'Без играча $player прича је другачија. Да ли је ово тим или један играч?';
  }

  @override
  String pressBeatStandoutHostile2(String player) {
    return '$player је био сјајан. Ваша заслуга или његова?';
  }

  @override
  String pressBeatStrugglerWarm1(String player) {
    return '$player је имао тешко вече. Да ли има неку повреду?';
  }

  @override
  String pressBeatStrugglerWarm2(String player) {
    return '$player није имао своје вече. Хоћете ли да га охрабрите?';
  }

  @override
  String pressBeatStrugglerNeutral1(String player) {
    return '$player се вечерас мучио. Да ли задржава место у саставу?';
  }

  @override
  String pressBeatStrugglerNeutral2(String player) {
    return '$player је деловао споро. Шта мислите о његовој утакмици?';
  }

  @override
  String pressBeatStrugglerHostile1(String player) {
    return '$player је опет био путник. Зашто га стално бирате?';
  }

  @override
  String pressBeatStrugglerHostile2(String player) {
    return 'Сви су видели да $player није био у форми. Сви осим клупе?';
  }

  @override
  String get pressThrowbackWinNextKeptWarm =>
      'Рекли сте да ћете добити следећу и јесте. Да ли је лепо бити у праву?';

  @override
  String get pressThrowbackWinNextKeptNeutral =>
      'Обећали сте победу у следећој утакмици и испунили сте. Самопоуздање или хвалисање?';

  @override
  String get pressThrowbackWinNextKeptHostile =>
      'Рекли сте да ћете добити следећу и јесте. Срећа или би требало да почнемо да Вас слушамо?';

  @override
  String get pressThrowbackWinNextBrokenWarm =>
      'Рекли сте да ћете добити ону утакмицу. Није се десило. Шта је пошло наопако?';

  @override
  String get pressThrowbackWinNextBrokenNeutral =>
      'Рекли сте да ћете добити следећу. Нисте. Зашто бисмо веровали следећем обећању?';

  @override
  String get pressThrowbackWinNextBrokenHostile =>
      'Рекли сте да ћете добити следећу. Нисте. Да ли Ваше речи ишта значе у овој просторији?';

  @override
  String get pressThrowbackJobKeptWarm =>
      'Тражили сте да Вам се суди по три утакмице и прошли сте. Оправдани?';

  @override
  String get pressThrowbackJobKeptNeutral =>
      'Судите ми по следеће три, рекли сте. Судили смо, а резултати су стигли. Шта Вас је научио тај тест?';

  @override
  String get pressThrowbackJobKeptHostile =>
      'Дали сте себи три утакмице и пребродили их. Да ли је тест икад био толико тежак?';

  @override
  String get pressThrowbackJobBrokenWarm =>
      'Тражили сте да Вам се суди по три утакмице. Нису испале по Вашем. Шта сте научили?';

  @override
  String get pressThrowbackJobBrokenNeutral =>
      'Рекли сте, судите ми по следеће три. Три су прошле, а с њима и поверење. Шта сад?';

  @override
  String get pressThrowbackJobBrokenHostile =>
      'Поставили сте тест и пали на њему. Зашто би Вам ико сад веровао на реч?';

  @override
  String pressThrowbackBackKeptWarm(String player) {
    return 'Подржали сте играча $player кад други нису. Оправдао је то. Да ли је део заслуге Ваш?';
  }

  @override
  String pressThrowbackBackKeptNeutral(String player) {
    return 'Подржали сте играча $player. Оправдао је. Вера или знање?';
  }

  @override
  String pressThrowbackBackKeptHostile(String player) {
    return 'Подржали сте играча $player и за промену се исплатило. Хоћете ли следећи пут бити толико сигурни?';
  }

  @override
  String pressThrowbackBackBrokenWarm(String player) {
    return 'Стали сте уз играча $player, а није испало добро. Да ли још верујете у њега?';
  }

  @override
  String pressThrowbackBackBrokenNeutral(String player) {
    return 'Подржали сте играча $player. Није Вам то вратио. Да ли је то била грешка?';
  }

  @override
  String pressThrowbackBackBrokenHostile(String player) {
    return 'Ваша процена или Ваша оданост: шта је подбацило код играча $player?';
  }

  @override
  String pressThrowbackBlameKeptWarm(String player) {
    return 'Били сте строги према играчу $player, а утакмице од тада Вам дају за право. Има ли у томе задовољства?';
  }

  @override
  String pressThrowbackBlameKeptNeutral(String player) {
    return 'Јавно сте прозвали играча $player и није одговорио. Има ли за њега повратка?';
  }

  @override
  String pressThrowbackBlameKeptHostile(String player) {
    return 'Оставили сте играча $player на цедилу и није се опоравио. Да ли сте га сломили?';
  }

  @override
  String pressThrowbackBlameBrokenWarm(String player) {
    return 'Прозвали сте играча $player, а он Вам је одговорио на терену. Да ли је то био план од почетка?';
  }

  @override
  String pressThrowbackBlameBrokenNeutral(String player) {
    return 'Окривили сте играча $player, а он је од тада један од Ваших најбољих. Да ли му дугујете извињење?';
  }

  @override
  String pressThrowbackBlameBrokenHostile(String player) {
    return 'Бацили сте играча $player под аутобус, а он Вам је од тада најбољи. Хоћете ли да се извините?';
  }

  @override
  String get pressReplyCreditPlayers1 =>
      'Ови играчи су ми дали све. Не бих мењао ниједног.';

  @override
  String get pressReplyCreditPlayers2 =>
      'Нико не ради више од ове групе. Бранићу их цео дан.';

  @override
  String get pressReplyCreditPlayers3 =>
      'С ове столице нећете чути ни реч против мојих играча.';

  @override
  String get pressReplyCreditPlayers4 =>
      'Заслуга је играча, не моја. Пишите о њима.';

  @override
  String get pressReplyTakeResponsibility1 =>
      'Ово је на мени. Ја сам изабрао састав и ја сам их поставио.';

  @override
  String get pressReplyTakeResponsibility2 =>
      'Судите мени, не њима. То је мој тим и моја одговорност.';

  @override
  String get pressReplyTakeResponsibility3 =>
      'Ако тражите кривца, ево ме, седим овде.';

  @override
  String get pressReplyTakeResponsibility4 =>
      'Одговорност је моја. Оставите играче по страни.';

  @override
  String get pressReplyDemandMore1 =>
      'Желим више. Неки од њих тачно знају шта мислим.';

  @override
  String get pressReplyDemandMore2 =>
      'На овом нивоу труд није довољан. Желим више и рекао сам им то.';

  @override
  String get pressReplyDemandMore3 =>
      'Од сваког од њих очекујем више, почев од сутра.';

  @override
  String get pressReplyDemandMore4 =>
      'Неки од њих морају да погледају себе. Нисам задовољан.';

  @override
  String get pressReplyPromiseWinNext1 =>
      'Добићемо следећу. Можете то да запишете.';

  @override
  String get pressReplyPromiseWinNext2 =>
      'Запамтите моје речи: добијамо следећу утакмицу.';

  @override
  String get pressReplyPromiseWinNext3 =>
      'Следећа утакмица, побеђујемо. Кажем то овде да ме можете држати за реч.';

  @override
  String get pressReplyPromiseWinNext4 =>
      'Сигуран сам у овај тим. Добијамо следећу утакмицу.';

  @override
  String get pressReplyJobOnTheLine1 =>
      'Судите ми по следеће три утакмице. То је поштено.';

  @override
  String get pressReplyJobOnTheLine2 =>
      'Дајте ми три утакмице. Ако до тада не буде како треба, судите ми.';

  @override
  String get pressReplyJobOnTheLine3 =>
      'Следеће три ће показати да ли сам прави човек. Држите ме за реч.';

  @override
  String get pressReplyJobOnTheLine4 =>
      'Три утакмице. После тога пишите о мени шта год желите.';

  @override
  String get pressReplyDeflect1 =>
      'Идемо утакмицу по утакмицу. Немам шта да додам.';

  @override
  String get pressReplyDeflect2 => 'Данас вам нећу правити наслове.';

  @override
  String get pressReplyDeflect3 => 'Следећа утакмица. Само о томе размишљам.';

  @override
  String get pressReplyDeflect4 => 'Шта мислим, остаје у свлачионици.';

  @override
  String get pressReplyTakeCredit1 =>
      'Рекао сам то јер сам веровао у то, и био сам у праву.';

  @override
  String get pressReplyTakeCredit2 => 'Добро сам то прочитао. Зато сам овде.';

  @override
  String get pressReplyTakeCredit3 =>
      'Зовите то проценом. Знао сам шта говорим.';

  @override
  String get pressReplyTakeCredit4 =>
      'Донео сам одлуку и успела је. То ћу прихватити.';

  @override
  String get pressReplyStandByIt1 =>
      'Рекао сам оно у шта сам веровао. Стојим иза тога.';

  @override
  String get pressReplyStandByIt2 => 'Не повлачим ни реч.';

  @override
  String get pressReplyStandByIt3 =>
      'Исти одговор као тада. Мислио сам то, и још увек мислим.';

  @override
  String get pressReplyStandByIt4 => 'Рекао бих то и сутра.';

  @override
  String get pressReplyAdmitMistake1 =>
      'Ту сам погрешио. Преузимам то на себе.';

  @override
  String get pressReplyAdmitMistake2 =>
      'Поштено, погрешно сам проценио. Научићу нешто из тога.';

  @override
  String get pressReplyAdmitMistake3 => 'Погрешио сам и могу то да кажем.';

  @override
  String get pressReplyAdmitMistake4 =>
      'Та одлука није успела, а била је моја.';

  @override
  String pressReplyBackPlayer1(String player) {
    return '$player има моју пуну подршку. Доћи ће до изражаја.';
  }

  @override
  String pressReplyBackPlayer2(String player) {
    return 'Верујем у играча $player и показаће вам зашто.';
  }

  @override
  String pressReplyBackPlayer3(String player) {
    return 'Од мене нећете чути ни реч против играча $player. Испуниће очекивања.';
  }

  @override
  String pressReplyBackPlayer4(String player) {
    return '$player остаје у мојим плановима. Пратите шта ће урадити следеће.';
  }

  @override
  String pressReplyBlamePlayer1(String player) {
    return '$player нас је вечерас изневерио и он то зна.';
  }

  @override
  String pressReplyBlamePlayer2(String player) {
    return 'Од играча $player сам очекивао много више. Он мора да одговори на то.';
  }

  @override
  String pressReplyBlamePlayer3(String player) {
    return '$player није био на нивоу. То ћу рећи јавно.';
  }

  @override
  String pressReplyBlamePlayer4(String player) {
    return 'То од играча $player није било довољно добро и чуће то од мене.';
  }

  @override
  String get pressOnRecordWinNext =>
      'За записник: победићете у следећој утакмици.';

  @override
  String get pressOnRecordJob => 'За записник: суди Вам се по следеће три.';

  @override
  String pressOnRecordBack(String player) {
    return 'За записник: подржавате играча $player.';
  }

  @override
  String pressOnRecordBlame(String player) {
    return 'За записник: $player Вас је изневерио.';
  }

  @override
  String yStatementKept0(String nation) {
    return 'Рекао је то и десило се. $nation има селектора који мисли то што каже.';
  }

  @override
  String yStatementKept1(String nation) {
    return 'Рекао је наглас, а онда је то и урадио. То је човек какав је био потребан: $nation.';
  }

  @override
  String yStatementKept2(String nation) {
    return '$nation: рекао је и обистинило се. Добро, признајем.';
  }

  @override
  String yStatementKept3(String nation) {
    return 'Ставио је то у записник и издржало је. Бод за њега. $nation иде даље.';
  }

  @override
  String yStatementKept4(String nation) {
    return 'Једном је погодио. $nation, немој да се навикнеш.';
  }

  @override
  String yStatementKept5(String nation) {
    return 'И покварен сат двапут дневно показује тачно. $nation је овај пут имао среће.';
  }

  @override
  String yStatementBroken0(String nation) {
    return 'Рекао је то и није успело. Још сам уз њега. $nation иде поново.';
  }

  @override
  String yStatementBroken1(String nation) {
    return '$nation: обећао је више него што смо добили, али радије имам селектора који верује у себе.';
  }

  @override
  String yStatementBroken2(String nation) {
    return '$nation: рекао је то за записник и није се десило. Људи ће памтити.';
  }

  @override
  String yStatementBroken3(String nation) {
    return 'Велике речи, ништа иза њих. $nation: следећи пут мање причај.';
  }

  @override
  String yStatementBroken4(String nation) {
    return 'Стао је пред нас и рекао. А онда ово. $nation заслужује више од приче.';
  }

  @override
  String yStatementBroken5(String nation) {
    return 'Његова реч сад не вреди ништа. Запиши, $nation.';
  }

  @override
  String get ncZoneNorth => 'Северна зона';

  @override
  String get ncZoneWest => 'Западна зона';

  @override
  String get ncZoneEast => 'Источна зона';

  @override
  String get ncZoneCentralSouthern => 'Централна и јужна зона';

  @override
  String careerNationsCupZoneWon(String zone) {
    return '$zone · Прваци';
  }

  @override
  String careerNationsCupZoneRunnerUp(String zone) {
    return '$zone · Другопласирани';
  }

  @override
  String careerNationsCupZoneSemi(String zone) {
    return '$zone · Полуфиналиста';
  }

  @override
  String careerNationsCupZoneRoundOf16(String zone) {
    return '$zone · Осмина финала';
  }

  @override
  String careerNationsCupZoneQuarter(String zone) {
    return '$zone · Четвртфиналиста';
  }

  @override
  String careerNationsCupZonePlaced(String zone, int position) {
    return '$zone · #$position';
  }

  @override
  String get objectiveNcFinalsEight => 'Стигни до четвртфинала';

  @override
  String get objectiveNcZoneWinGroup => 'Освоји прво место у групи';

  @override
  String get finishNcFinalsEight => 'Четвртфинале';

  @override
  String get finishNcBottomHalf => 'Доња половина групе';

  @override
  String get tourContTabZones => 'ЗОНЕ';

  @override
  String get tourContTabFinalsEight => 'НОКАУТ ФАЗА';

  @override
  String get tourContFinalsEightSoon =>
      'Нокаут фаза почиње у новембру осмином финала: свих 14 победника група и 2 најбоља другопласирана.';

  @override
  String get tourContQuarterFinals => 'ЧЕТВРТФИНАЛЕ';

  @override
  String get tourContZoneAdvancement =>
      'Сваки победник групе иде у осмину финала, а придружују им се 2 најбоља другопласирана. Нико не испада.';

  @override
  String tourContZoneHeadingYours(String zone) {
    return '$zone ★';
  }

  @override
  String get compNorthAmericaNationsCup => 'Куп нација Северне Америке';

  @override
  String get compAfricanNationsCup => 'Куп нација';

  @override
  String get objectiveNcWinItNorthAmerica =>
      'Освоји Куп нација Северне Америке';

  @override
  String get objectiveNcWinItAfrica => 'Освоји Куп нација';

  @override
  String get objectiveNcReachFinalNorthAmerica =>
      'Стигни до финала Купа нација Северне Америке';

  @override
  String get objectiveNcReachFinalAfrica => 'Стигни до финала Купа нација';

  @override
  String get finishNcChampionsNorthAmerica =>
      'Победници Купа нација Северне Америке';

  @override
  String get finishNcChampionsAfrica => 'Победници Купа нација';

  @override
  String pressAimQualWarm1(String competition) {
    return 'Почињу квалификације ($competition), а земља верује у ову екипу. Шта циљате?';
  }

  @override
  String pressAimQualWarm2(String competition) {
    return 'Нова квалификациона кампања ($competition), а расположење је одлично. Докле овај тим може да стигне?';
  }

  @override
  String pressAimQualNeutral1(String competition) {
    return 'Почињу квалификације ($competition). Који је циљ ове кампање?';
  }

  @override
  String pressAimQualNeutral2(String competition) {
    return 'Квалификације су ту ($competition). Где видите ову екипу на крају?';
  }

  @override
  String pressAimQualHostile1(String competition) {
    return 'Почињу квалификације ($competition), а многи сумњају да ћете стићи до циља. Шта им поручујете?';
  }

  @override
  String pressAimQualHostile2(String competition) {
    return 'Још једна квалификациона кампања ($competition). Зашто би ико веровао да ће ова бити другачија?';
  }

  @override
  String pressAimFinalsWarm1(String competition) {
    return 'Почиње такмичење ($competition), а цела земља је уз Вас. Докле можете да стигнете?';
  }

  @override
  String pressAimFinalsWarm2(String competition) {
    return 'Стигли сте на такмичење ($competition), а навијачи сањају. Који је циљ?';
  }

  @override
  String pressAimFinalsNeutral1(String competition) {
    return 'Ове недеље почиње такмичење ($competition). Шта би био успех?';
  }

  @override
  String pressAimFinalsNeutral2(String competition) {
    return 'Прва утакмица на такмичењу ($competition) је близу. Поставите нам циљ.';
  }

  @override
  String pressAimFinalsHostile1(String competition) {
    return 'Почиње такмичење ($competition), а нико не очекује много. Чему се заправо надате?';
  }

  @override
  String pressAimFinalsHostile2(String competition) {
    return 'На такмичењу сте ($competition), али сумње нису нестале. Који је Ваш циљ?';
  }

  @override
  String pressBeatRivalWarm1(String rival) {
    return 'У Вашој групи је репрезентација: $rival. Да ли Вас брине?';
  }

  @override
  String pressBeatRivalWarm2(String rival) {
    return 'Жреб Вам је донео репрезентацију: $rival. Како видите ту утакмицу?';
  }

  @override
  String pressBeatRivalNeutral1(String rival) {
    return 'Најјача у Вашој групи делује репрезентација: $rival. Да ли су фаворити?';
  }

  @override
  String pressBeatRivalNeutral2(String rival) {
    return 'Шта мислите о репрезентацији: $rival?';
  }

  @override
  String pressBeatRivalHostile1(String rival) {
    return 'У Вашој групи је репрезентација: $rival. Искрено, можете ли да им парирате?';
  }

  @override
  String pressBeatRivalHostile2(String rival) {
    return 'Већина очекује да ће Вас победити репрезентација: $rival. Да ли греше?';
  }

  @override
  String pressBeatKeyPlayerWarm1(String player) {
    return '$player је у сјајној форми. Да ли је ово његов тренутак?';
  }

  @override
  String pressBeatKeyPlayerWarm2(String player) {
    return '$player је у свим насловима. Може ли да понесе ову екипу?';
  }

  @override
  String pressBeatKeyPlayerNeutral1(String player) {
    return 'Колико ова кампања зависи од играча $player?';
  }

  @override
  String pressBeatKeyPlayerNeutral2(String player) {
    return 'Да ли је $player спреман да предводи овај тим?';
  }

  @override
  String pressBeatKeyPlayerHostile1(String player) {
    return 'Ако $player није у најбољем издању, да ли ова екипа има ишта?';
  }

  @override
  String pressBeatKeyPlayerHostile2(String player) {
    return '$player носи много на плећима. Превише?';
  }

  @override
  String get pressReplyAimHigher1 => 'Идемо даље него што ико очекује.';

  @override
  String get pressReplyAimHigher2 =>
      'Желим више него што је савез тражио и рећи ћу то наглас.';

  @override
  String get pressReplyMatchBrief1 => 'Знамо циљ и остварићемо га.';

  @override
  String get pressReplyMatchBrief2 => 'Савез је поставио циљ. Испунићемо га.';

  @override
  String get pressReplyPlayDown1 => 'Идемо утакмицу по утакмицу.';

  @override
  String get pressReplyPlayDown2 => 'Нема великих обећања. Видећемо где смо.';

  @override
  String get pressReplyPromiseQualify1 =>
      'Квалификоваћемо се. Можете то да запишете.';

  @override
  String get pressReplyPromiseQualify2 =>
      'Ова екипа ће бити на завршном турниру.';

  @override
  String get pressReplyFearNobody1 => 'Не плашимо се никога.';

  @override
  String get pressReplyFearNobody2 => 'И они морају да играју против нас.';

  @override
  String get pressReplyRespectRival1 => 'Они су фаворити и поштујемо их.';

  @override
  String get pressReplyRespectRival2 =>
      'Веома добра екипа. Требаће нам најбоље издање.';

  @override
  String get pressReplyTeamFirst1 =>
      'Реч је о целом тиму, а не о једном играчу.';

  @override
  String get pressReplyTeamFirst2 => 'Нико ово не осваја сам.';

  @override
  String pressOnRecordTarget(String aim) {
    return 'За записник: $aim.';
  }

  @override
  String get pressOnRecordPlayDown => 'За записник: без обећања.';

  @override
  String get pressThrowbackTargetKeptWarm =>
      'Поставили сте циљ пре кампање и остварили га. Да ли је то досад Ваш најпоноснији тренутак?';

  @override
  String get pressThrowbackTargetKeptNeutral =>
      'Рекли сте шта ћете постићи и јесте. Да ли је икад било упитно?';

  @override
  String get pressThrowbackTargetKeptHostile =>
      'Остварили сте циљ који сте поставили. Срећа или је то заиста био план?';

  @override
  String get pressThrowbackTargetBrokenWarm =>
      'Поставили сте циљ и нисте га достигли. Шта је пошло наопако?';

  @override
  String get pressThrowbackTargetBrokenNeutral =>
      'Обећали сте више него што је ова екипа пружила. Да ли жалите што сте то рекли?';

  @override
  String get pressThrowbackTargetBrokenHostile =>
      'Пред кампању сте обећавали велике ствари, а подбацили сте. Зашто бисмо Вам сад веровали?';

  @override
  String hubEventPressPreviewSub(String competition) {
    return 'Медији желе да чују твоје циљеве за такмичење: $competition';
  }

  @override
  String deptLevelCost(int level, String amount) {
    return 'Ниво $level · $amount';
  }

  @override
  String get formOnFire => 'У ватри';

  @override
  String get formGood => 'У форми';

  @override
  String get formSteady => 'Стабилна';

  @override
  String get formPoor => 'Ван форме';

  @override
  String get formCold => 'Ледена';

  @override
  String get playerFormTitle => 'ФОРМА И КОНДИЦИЈА';

  @override
  String playerFormAverage(String rating) {
    return 'Просечна оцена у недавним утакмицама: $rating';
  }

  @override
  String get playerFormNoGames => 'Премало недавних утакмица за процену';

  @override
  String playerFormNextMatch(String delta) {
    return 'Оцена у следећој утакмици: $delta';
  }

  @override
  String get playerFormNoEffect => 'Оцена се у следећој утакмици не мења';

  @override
  String playerFormSquadShare(String delta) {
    return 'Укључује $delta за цео тим (морал, базни камп)';
  }

  @override
  String get sideGroupHome => 'Почетна';

  @override
  String get sideGroupTeam => 'Тим';

  @override
  String get sideGroupCompetitions => 'Такмичења';

  @override
  String get sideGroupFederation => 'Савез';

  @override
  String get sideGroupHistory => 'Историја';

  @override
  String get sideInbox => 'Поруке';

  @override
  String get sideSquad => 'Састав';

  @override
  String get sideTactics => 'Тактика';

  @override
  String get sideMainMenu => 'Главни мени';

  @override
  String get sideCallUps => 'Позиви';

  @override
  String get sideTournaments => 'Турнири';

  @override
  String get sideRanking => 'Ранг-листа';

  @override
  String get sideResults => 'Резултати';

  @override
  String get sideFinances => 'Финансије';

  @override
  String get sideBoard => 'Управа';

  @override
  String get sideManager => 'Селектор и штаб';

  @override
  String get sideRecords => 'Рекорди';

  @override
  String get sideLegends => 'Легенде';

  @override
  String get sideHeadToHead => 'Међусобни сусрети';

  @override
  String get sideAchievements => 'Достигнућа';

  @override
  String get sideCareer => 'Каријера';

  @override
  String get topBarNext => 'Следеће';

  @override
  String get topBarDrawPending => 'Следи жреб';

  @override
  String get paneFullProfile => 'Цео профил';

  @override
  String get panePickPlayer => 'Изабери играча да овде видиш његову картицу';

  @override
  String get inboxPickMessage => 'Изабери поруку да је овде прочиташ';

  @override
  String get inboxFilterAll => 'Све';

  @override
  String get panelViewAll => 'Прикажи све';

  @override
  String get gridViewOverview => 'Преглед';

  @override
  String get gridColCondition => 'Кондиција';

  @override
  String get gridColStatus => 'Статус';

  @override
  String get gridColRank => 'Место';

  @override
  String get gridColMove => 'Помак';

  @override
  String get gridColNation => 'Земља';

  @override
  String get gridColRegion => 'Регион';

  @override
  String get gridColPoints => 'Бодови';

  @override
  String get panePickNation => 'Изабери земљу да овде видиш њен досије';

  @override
  String get resultsCyclesTitle => 'Циклуси';

  @override
  String get tourDrawStart => 'Започни жреб';

  @override
  String get tourDrawViewGroups => 'Прикажи групе';

  @override
  String get gridColCeiling => 'Плафон';

  @override
  String get gridColYearGain => 'Напредак';

  @override
  String get gridColMarkedAt => 'Кад означен';

  @override
  String get budgetSetupTitle => 'Постави буџет';

  @override
  String get budgetEffectsTitle => 'Шта овај буџет доноси';

  @override
  String get naturalisationTitle => 'Натурализација';

  @override
  String get yTrending => 'У тренду';

  @override
  String get yVoices => 'Гласови';

  @override
  String get yConversation => 'Расправа';

  @override
  String get allTimeRecordsTitle => 'Светски рекорди свих времена';

  @override
  String get h2hMeetingsTitle => 'Сви сусрети';

  @override
  String get h2hPickOpponent => 'Изабери противника да овде видиш све сусрете';

  @override
  String get savesTitle => 'Сачуване игре';

  @override
  String get gridColPlayer => 'Играч';

  @override
  String get gridColPos => 'Поз';

  @override
  String get gridColActive => 'Активан';

  @override
  String get gridColMotm => 'MOTM';

  @override
  String get gridColAvg => 'Прос.';

  @override
  String get gridColOpponent => 'Противник';

  @override
  String get gridColStarts => 'Стартови';

  @override
  String get gridColTournaments => 'Турнири';

  @override
  String get gridColDate => 'Датум';

  @override
  String get gridColLastPlayed => 'Последњи пут играно';

  @override
  String get gridColManager => 'Селектор';

  @override
  String nationsShownCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count земаља',
      few: '$count земље',
      one: '$count земља',
    );
    return '$_temp0';
  }

  @override
  String get nationsSortedByRank => 'Поређано по светској ранг-листи';

  @override
  String get nationsStrength => 'Снага';

  @override
  String nationsStrengthOf(int tier) {
    return '$tier од 5';
  }

  @override
  String get nationsSquadOverall => 'Укупна оцена састава';

  @override
  String get nationsOpeningBudget => 'Почетни буџет';

  @override
  String get nationsStarPlayer => 'Звезда тима';

  @override
  String nationsStarTile(String position, int rating) {
    return 'Звезда $position $rating';
  }

  @override
  String nationsStarAge(int age) {
    return 'Старост $age';
  }

  @override
  String get nationsBoardExpects => 'Управа очекује';

  @override
  String nationsManage(String nation) {
    return 'Води: $nation';
  }

  @override
  String get nationsManagerNext => 'Следеће уписујеш име селектора';

  @override
  String get playerPageTitle => 'Играч';

  @override
  String get nationPageTitle => 'Земља';

  @override
  String get friendliesYourGames => 'Твоје пријатељске';

  @override
  String hubEventInjuryCover(String player) {
    return 'Замени повређеног играча $player';
  }

  @override
  String hubEventInjuryCoverSub(int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: 'Одсутан $matches утакмица',
      few: 'Одсутан $matches утакмице',
      one: 'Одсутан $matches утакмицу',
    );
    return '$_temp0. Позови некога или играј даље без њега.';
  }

  @override
  String get injuryCoverTitle => 'ЗАМЕНА';

  @override
  String injuryCoverBanner(String player, String position) {
    return '$player ($position) је повређен. Позови било кога ван састава, на било коју позицију, или га задржи и играј даље.';
  }

  @override
  String injuryCoverConfirm(String player) {
    return 'Позови играча: $player';
  }

  @override
  String injuryCoverKeep(String player) {
    return 'Задржи играча $player и играј даље';
  }

  @override
  String get injuryCoverPick => 'Изабери замену';

  @override
  String get injuryCoverNone => 'Нико ван састава није спреман да се придружи.';

  @override
  String get nationNowRanking => 'Светска ранг-листа';

  @override
  String get nationNowForm => 'Форма';

  @override
  String get nationNowNoForm => 'Још нема одиграних утакмица';

  @override
  String get nationNowNext => 'Следећа утакмица';

  @override
  String get nationNowNoNext => 'Ништа није заказано';

  @override
  String get nationNowSquad => 'Састав';

  @override
  String get nationNowAgainstYou => 'Против тебе';

  @override
  String nationNowRecord(int w, int d, int l) {
    return '$wП $dН $lИ';
  }

  @override
  String get nationNowLastMeeting => 'Последњи сусрет';

  @override
  String nationNowOverall(int value) {
    return 'Укупно $value';
  }

  @override
  String get hubUpcoming => 'ПРЕДСТОЈИ';

  @override
  String get hubFullSchedule => 'Цео распоред';

  @override
  String get scheduleTitle => 'Распоред';

  @override
  String get scheduleToday => 'Данас';

  @override
  String get scheduleKnockoutPending => 'Нокаут фаза, ако прођеш даље';

  @override
  String get scheduleNextRoundPending => 'Следеће коло';

  @override
  String scheduleFromDate(String date) {
    return 'Од $date';
  }

  @override
  String get scheduleHomeShort => 'Д';

  @override
  String get scheduleAwayShort => 'Г';

  @override
  String get tacticsNoPresetsInMatch =>
      'Још нема сачуваних тактика. Сачувај једну на екрану Тактика пре утакмице.';

  @override
  String get homeCampaigns => 'Кампање';

  @override
  String get homeContinueCampaign => 'НАСТАВИ КАМПАЊУ';

  @override
  String homeCampaignCycle(String date, int cycle, int total) {
    return '$date · Циклус $cycle од $total';
  }

  @override
  String get campaignsTitle => 'Кампање';

  @override
  String get campaignTransplantTitle => 'Пресађивање';

  @override
  String get campaignTransplantTwist =>
      'Шест најбољих италијанских играча мења репрезентацију и прелази у Сан Марино';

  @override
  String get campaignTransplantGoal => 'Квалификуј се за Европско првенство';

  @override
  String get campaignGrudgeTitle => 'Стари рачун';

  @override
  String get campaignGrudgeTwist => 'Грузија и Албанија, извучене заједно';

  @override
  String get campaignGrudgeGoal => 'Заврши изнад Албаније у квалификацијама';

  @override
  String get campaignTransplantIntro =>
      'Сан Марино никад није имао квалификациону кампању вредну тог имена. Онда шест најбољих Италијана узме пасош и уђе. Имаш један циклус да од куриозитета направиш тим.';

  @override
  String get campaignGrudgeIntro =>
      'Грузија и Албанија су извучене у исту квалификациону групу и ниједна неће опростити пораз. Заврши изнад Албаније, па види докле можеш да стигнеш.';

  @override
  String get campaignStars1Transplant => 'Квалификуј се';

  @override
  String get campaignStars2Transplant => 'Стигни до нокаут фазе';

  @override
  String get campaignStars3Transplant => 'Освоји Европско првенство';

  @override
  String get campaignStars1Grudge => 'Изнад Албаније';

  @override
  String get campaignStars2Grudge => 'И квалификуј се';

  @override
  String get campaignStars3Grudge => 'И победи их двапут';

  @override
  String get campaignFree => 'Бесплатно';

  @override
  String get campaignStart => 'Старт';

  @override
  String get campaignPartOfUnlimited => 'Део пакета Unlimited';

  @override
  String get campaignResume => 'Настави';

  @override
  String get campaignAbandon => 'Одустани';

  @override
  String get campaignAbandonConfirm =>
      'Одустати од овог покушаја? Напредак се губи; твој печат остаје.';

  @override
  String get campaignMoveToSaves => 'Премести у сачуване';

  @override
  String get campaignCannotContinue =>
      'Свет ове кампање превише се разликује од стварног да би се наставио као каријера.';

  @override
  String get campaignMoveSlotsFull =>
      'Места за чување су попуњена. Прво ослободи једно.';

  @override
  String get campaignStampConquered => 'Освојено';

  @override
  String get campaignStampFailed => 'Неуспело';

  @override
  String get campaignDifficultyHard => 'Тешко';

  @override
  String get campaignDifficultyMedium => 'Средње';

  @override
  String get campaignGoalLabel => 'Циљ';

  @override
  String get campaignStarsLabel => 'Звездице';

  @override
  String get campaignRunInProgress => 'Ова кампања већ има покушај у току.';

  @override
  String get campaignVerdictWon => 'Освојено';

  @override
  String get campaignVerdictLost => 'Не овај пут';

  @override
  String get campaignVerdictContinue => 'Настави';

  @override
  String campaignProgressQualifying(String position) {
    return 'Квалификације: $position';
  }

  @override
  String campaignProgressRival(String rival, String position) {
    return '$rival: $position';
  }

  @override
  String campaignProgressFinals(String stage) {
    return 'Завршница: $stage';
  }

  @override
  String get campaignRunInNumbers => 'Поход у бројкама';

  @override
  String campaignRunMeetings(int won, int played) {
    return 'Добијени мечеви: $won од $played';
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
  String get campaignGuineasTitle => 'Најбоља Гвинеја';

  @override
  String get campaignGuineasTwist =>
      'Екваторијална Гвинеја, најмања од афричких Гвинеја, кроз два циклуса';

  @override
  String get campaignGuineasGoal => 'Победи Гвинеју и Гвинеју Бисао';

  @override
  String get campaignGuineasIntro =>
      'Три афричке земље носе име Гвинеја, а Екваторијална Гвинеја је најмања од њих. Имаш два циклуса да бар једном победиш Гвинеју и Гвинеју Бисао, па види докле можеш да стигнеш на Афричком првенству. Папуа Нова Гвинеја, четврта Гвинеја, већ је договорена за пријатељску утакмицу.';

  @override
  String get campaignStars1Guineas => 'Победи Гвинеју и Гвинеју Бисао';

  @override
  String get campaignStars2Guineas => 'И квалификуј се за Афричко првенство';

  @override
  String get campaignStars3Guineas =>
      'И стигни до четвртфинала Афричког првенства';

  @override
  String get campaignYoungFinnsTitle => 'Млади Финци';

  @override
  String get campaignYoungFinnsTwist =>
      'Златна генерација финских тинејџера, кроз три циклуса';

  @override
  String get campaignYoungFinnsGoal => 'Квалификуј се за Светско првенство';

  @override
  String get campaignYoungFinnsIntro =>
      'Фински сениори су се повукли, а њихово место заузела је златна генерација: сваки играч ког можеш да изабереш има 18 година или мање. Данас су још неизбрушени, али имају таленат да постану једна од најбољих репрезентација на свету, баш као што је то успела млада норвешка генерација. Имаш три циклуса да их одведеш на Светско првенство, а затим да освојиш Европско првенство и Светско првенство.';

  @override
  String get campaignStars1YoungFinns => 'Квалификуј се за Светско првенство';

  @override
  String get campaignStars2YoungFinns => 'Освоји Европско првенство';

  @override
  String get campaignStars3YoungFinns => 'Освоји Светско првенство';

  @override
  String get campaignGreenlandTitle => 'Гренландски век';

  @override
  String get campaignGreenlandTwist =>
      'Гренланд заузима место Сан Марина у Европи, на сто година';

  @override
  String get campaignGreenlandGoal => 'Квалификуј се за Европско првенство';

  @override
  String get campaignGreenlandIntro =>
      'Гренланд никад није одиграо званичну међународну утакмицу. У овом свету заузео је место Сан Марина у Европи и креће са самог дна светске ранг-листе: аматерски играчи, вештачки терени и сезона стиснута између снегова. Имаш сто година, двадесет пет циклуса, да стигнеш до Европског првенства, затим до Светског првенства и, ако се усудиш да сањаш, да освојиш једно од њих.';

  @override
  String get campaignStars1Greenland => 'Квалификуј се за Европско првенство';

  @override
  String get campaignStars2Greenland => 'Квалификуј се за Светско првенство';

  @override
  String get campaignStars3Greenland => 'Освоји Европско или Светско првенство';

  @override
  String get campaignZanzibarTitle => 'Успон Занзибара';

  @override
  String get campaignZanzibarTwist =>
      'Занзибар заузима место Чада у Африци, на сто година';

  @override
  String get campaignZanzibarGoal => 'Квалификуј се за Афричко првенство';

  @override
  String get campaignZanzibarIntro =>
      'Занзибар има свој фудбалски савез и своју репрезентацију, али нема места ни у афричком ни у светском фудбалу. У овом свету заузео је место Чада у Африци и креће близу дна светске ранг-листе: острвски играчи, мали стадиони и монсунска врућина. Имаш сто година, двадесет пет циклуса, да стигнеш до Афричког првенства, затим до Светског првенства и, ако се усудиш да сањаш, да освојиш Светско првенство.';

  @override
  String get campaignStars1Zanzibar => 'Квалификуј се за Афричко првенство';

  @override
  String get campaignStars2Zanzibar => 'Квалификуј се за Светско првенство';

  @override
  String get campaignStars3Zanzibar => 'Освоји Светско првенство';

  @override
  String get campaignPro => 'Pro';

  @override
  String campaignProgressCup(String cup, String year, String status) {
    return '$cup $year: $status';
  }

  @override
  String get campaignCupNotQualified => 'Није се квалификовала';

  @override
  String get campaignCupOpen => 'Тек ће бити одлучено';

  @override
  String campaignWorldRenames(String nation) {
    return 'Ова база преименује репрезентацију на којој се заснива ова кампања: $nation.';
  }

  @override
  String newsYouthTitle1(String name, String level) {
    return '$name блиста у репрезентацији $level';
  }

  @override
  String newsYouthTitle2(String name, String level) {
    return 'Извештај из академије: $name привлачи пажњу';
  }

  @override
  String newsYouthTitle3(String name, String level) {
    return 'Најбољи у репрезентацији $level: $name';
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
      other: '$count пута',
      few: '$count пута',
      one: '$count пут',
    );
    return '$name је у последњем репрезентативном термину $_temp0 затресао мрежу за репрезентацију $level. Противник: $opponent.';
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
      other: '$count голова',
      few: '$count гола',
      one: '$count гол',
    );
    return '$name је за репрезентацију $level постигао $_temp0. Противник у овом термину: $opponent.';
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
      other: '$count голова',
      few: '$count гола',
      one: '$count голом',
    );
    return 'Репрезентација $level играла је у овом термину (противник: $opponent), а $name је са терена отишао са $_temp0 на свом конту.';
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
      other: '$count голова',
      few: '$count гола',
      one: '$count гол',
    );
    return '$name је за репрезентацију $level наместио $_temp0 и водио игру од прве до последње минуте. Противник: $opponent.';
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
      other: '$count асистенција',
      few: '$count асистенције',
      one: '$count асистенција',
    );
    return 'Репрезентација $level играла је у овом термину (противник: $opponent), а конце је вукао $name: $_temp0 и партија о којој стручни штаб још увек прича.';
  }

  @override
  String newsYouthCleanSheet1(String name, String level, String opponent) {
    return '$name је био изванредан, а репрезентација $level сачувала је мрежу нетакнутом. Противник: $opponent.';
  }

  @override
  String newsYouthCleanSheet2(String name, String level, String opponent) {
    return 'Без примљеног гола за репрезентацију $level (противник: $opponent), а највеће заслуге има $name.';
  }

  @override
  String newsYouthDisplay1(
    String name,
    String level,
    String opponent,
    int mark,
  ) {
    return '$name је одушевио у репрезентацији $level (противник: $opponent), а стручни штаб је његову партију оценио са $mark од десет.';
  }

  @override
  String newsYouthDisplay2(
    String name,
    String level,
    String opponent,
    int mark,
  ) {
    return 'Репрезентација $level играла је у овом термину (противник: $opponent), а тренери су издвојили једно име, $name: $mark од десет, највиша оцена у екипи.';
  }

  @override
  String get newsYouthDevReady1 =>
      'У овој форми већ је довољно добар да га размотриш за А репрезентацију.';

  @override
  String get newsYouthDevReady2 =>
      'Стручни штаб верује да је већ сада спреман за сениорски фудбал. Одлука је на теби.';

  @override
  String get newsYouthDevClose1 =>
      'Добро напредује и близу је пробоја у А репрезентацију.';

  @override
  String get newsYouthDevClose2 =>
      'До А репрезентације не фали му много, а још једна добра сезона могла би да буде довољна.';

  @override
  String get newsYouthDevGrowing1 =>
      'Лепо се развија, иако је А репрезентација још корак или два далеко.';

  @override
  String get newsYouthDevGrowing2 =>
      'Има још посла пре него што постане сениорски репрезентативац, али све иде у добром смеру.';

  @override
  String get newsYouthDevRaw1 =>
      'Још је сиров и неколико година далеко од А репрезентације, али таленат се јасно види.';

  @override
  String get newsYouthDevRaw2 =>
      'Још је рано, а тренери академије траже стрпљење, не наслове.';

  @override
  String get newsYouthStrengthGkPhysical =>
      'Издваја га домет и владање шеснаестерцем.';

  @override
  String get newsYouthStrengthGkTechnical =>
      'Хватање и отварање игре најбољи су које је академија видела годинама.';

  @override
  String get newsYouthStrengthGkStamina =>
      'Концентрација му никад не пада: у деведесетом минуту оштар је као у првом.';

  @override
  String get newsYouthStrengthDefPhysical =>
      'Брзина и игра главом кључ су његове игре.';

  @override
  String get newsYouthStrengthDefTechnical =>
      'Чита игру далеко изнад својих година и смирен је с лоптом.';

  @override
  String get newsYouthStrengthDefStamina =>
      'Никад се не искључује и у последњем минуту још увек спринта назад.';

  @override
  String get newsYouthStrengthMidPhysical =>
      'Осваја лопте с правом снагом и одмах их носи напред.';

  @override
  String get newsYouthStrengthMidTechnical =>
      'Преглед игре и распон додавања кључ су његове игре.';

  @override
  String get newsYouthStrengthMidStamina =>
      'Има невероватан мотор: покрива сваку влат траве.';

  @override
  String get newsYouthStrengthFwdPhysical =>
      'Брзина у дубину и снага у ваздуху чине га проблемом за сваку одбрану.';

  @override
  String get newsYouthStrengthFwdTechnical =>
      'Завршница и кретање у шеснаестерцу кључ су његове игре.';

  @override
  String get newsYouthStrengthFwdStamina =>
      'Целу утакмицу пресингује од напред и не да одбрамбеним играчима ни тренутка мира.';

  @override
  String pressMomentBigWinWarm3(String opponent) {
    return 'Навијачи ће дуго певати о овој утакмици (противник: $opponent). Шта сте рекли играчима после последњег звиждука?';
  }

  @override
  String pressMomentBigWinNeutral3(String opponent) {
    return 'Била је то јасна порука, противник $opponent. Колико је тога дошло са тренинга?';
  }

  @override
  String pressMomentBigWinHostile3(String opponent) {
    return 'Честитке на резултату (противник: $opponent), али такве смо вечери већ виђали. Шта је овај пут другачије?';
  }

  @override
  String pressMomentBigLossWarm3(String opponent) {
    return 'Свако има лоше вече, а ово је било једно такво, противник $opponent. Колико брзо то можете да оставите иза себе?';
  }

  @override
  String pressMomentBigLossNeutral3(String opponent) {
    return 'Противник $opponent био је бољи у свакој линији. Одакле почињете с поправкама?';
  }

  @override
  String pressMomentBigLossHostile3(String opponent) {
    return 'Навијачи су одлазили пре краја (противник: $opponent). Можете ли да им замерите?';
  }

  @override
  String pressMomentCrisisWarm3(String opponent) {
    return 'Ово је тежак период, а ни утакмица у којој је противник био $opponent није ништа олакшала. Шта Вас држи?';
  }

  @override
  String pressMomentCrisisNeutral3(String opponent) {
    return 'Још једна утакмица без победе, овај пут противник $opponent. Колико то још може да траје пре него што управа реагује?';
  }

  @override
  String pressMomentCrisisHostile3(String opponent) {
    return 'Сад још и ово, противник $opponent. Да ли је у Вашем плану остало ишта, или је време да уступите место неком другом?';
  }

  @override
  String get pressReplyCreditPlayers5 =>
      'Шта год да напишете, напишите то о играчима. Заслужили су.';

  @override
  String get pressReplyCreditPlayers6 =>
      'Имам групу која би једни за друге скочила у ватру. То није мало.';

  @override
  String get pressReplyTakeResponsibility5 =>
      'Ја доносим одлуке, па критика иде мени. Такав је посао.';

  @override
  String get pressReplyTakeResponsibility6 =>
      'Прво погледајте селектора. Погрешио сам у неким стварима и исправићу их.';

  @override
  String get pressReplyDemandMore5 =>
      'Добро овде није довољно добро. Рекао сам им то у лице.';

  @override
  String get pressReplyDemandMore6 =>
      'Нико у тој свлачионици нема загарантовано место. Сада то знају.';

  @override
  String get pressReplyDeflect5 =>
      'Можете да питате на три различита начина. Одговор ће бити исти.';

  @override
  String get pressReplyDeflect6 => 'Своје мисли чувам за играче. Разумећете.';

  @override
  String yWinRoutine12(String opponent, String score) {
    return '$opponent $score. Миран, контролисан, зрео фудбал. Милина гледати.';
  }

  @override
  String yWinRoutine13(String opponent, String score) {
    return '$opponent $score, а нисмо се ни ознојили. Ова екипа постаје добра у досади, а досада осваја трофеје.';
  }

  @override
  String yWinRoutine14(String opponent, String score) {
    return '$opponent $score. Три бода, нула драме, назад на посао.';
  }

  @override
  String yWinRoutine15(String opponent, String score) {
    return 'Рутинских $score, противник $opponent. Нико то неће памтити и нико не мора.';
  }

  @override
  String yWinRoutine16(String opponent, String score) {
    return '$opponent $score, а ја се ипак некако бринем.';
  }

  @override
  String yWinRoutine17(String opponent, String score) {
    return '$opponent $score. Против праве екипе таква партија би била кажњена.';
  }

  @override
  String yWinTight12(String opponent, String score) {
    return '$opponent $score. Стиснули зубе, патили, победили. То је тим.';
  }

  @override
  String yWinTight13(String opponent, String score) {
    return '$opponent $score, само на живце. Узимам екипу која одбија да изгуби.';
  }

  @override
  String yWinTight14(String opponent, String score) {
    return '$opponent $score. До последње секунде, али бодови су наши.';
  }

  @override
  String yWinTight15(String opponent, String score) {
    return 'Тесних $score, противник $opponent. Мала разлика, такав је фудбал.';
  }

  @override
  String yWinTight16(String opponent, String score) {
    return '$opponent $score. Један срећан одбитак на другу страну и водили бисмо сасвим другачији разговор.';
  }

  @override
  String yWinTight17(String opponent, String score) {
    return 'Једва смо издржали, противник $opponent, $score. Нека то нико не зове партијом.';
  }

  @override
  String yDrew12(String opponent, String score) {
    return '$opponent $score. Није пораз, а понекад је управо то посао.';
  }

  @override
  String yDrew13(String opponent, String score) {
    return 'Тешко изборен бод, противник $opponent, $score. Свидела ми се борбеност.';
  }

  @override
  String yDrew14(String opponent, String score) {
    return '$opponent $score. Подела бодова, како су говорили стари коментатори.';
  }

  @override
  String yDrew15(String opponent, String score) {
    return '$opponent $score. Ниједна екипа није урадила довољно да заслужи више.';
  }

  @override
  String yDrew16(String opponent, String score) {
    return '$opponent $score. Онај нерешен резултат који у аутобусу на путу кући делује као пораз.';
  }

  @override
  String yDrew17(String opponent, String score) {
    return 'Нерешено. $opponent $score. Стално причамо о напретку и стално радимо ово.';
  }

  @override
  String yLost12(String opponent, String score) {
    return '$opponent $score. Боли, али видео сам довољно да верујем у ову екипу.';
  }

  @override
  String yLost13(String opponent, String score) {
    return 'Пораз. $opponent $score, и били су добри. Признати и ићи даље.';
  }

  @override
  String yLost14(String opponent, String score) {
    return '$opponent $score. Један пораз, неколико лекција и ускоро следећа утакмица.';
  }

  @override
  String yLost15(String opponent, String score) {
    return 'Пораз $score, противник $opponent. Тешко је ту шта приговорити.';
  }

  @override
  String yLost16(String opponent, String score) {
    return '$opponent $score. Исте грешке као прошли пут, направљене с истим самопоуздањем.';
  }

  @override
  String yLost17(String opponent, String score) {
    return 'Пораз. $opponent $score. Ако за ово нико не одговара, шта ми уопште радимо?';
  }

  @override
  String get yReactionShrug12 => 'Мени одговара. Не треба свако вече ватромет.';

  @override
  String get yReactionShrug13 => 'Бодови су бодови. Вечерас спавам мирно.';

  @override
  String get yReactionShrug14 => 'Гледао. Без примедби.';

  @override
  String get yReactionShrug15 => 'Негде између у реду и у реду.';

  @override
  String get yReactionShrug16 =>
      'Платио сам пренос за ово. Никад више (вратићу се).';

  @override
  String get yReactionShrug17 => 'Деведесет минута ничега у облику фудбала.';

  @override
  String get yReactionRelief12 => 'Опет дишем. Поносан што су издржали.';

  @override
  String get yReactionRelief13 => 'Такве победе граде тим. Ружно је лепо.';

  @override
  String get yReactionRelief14 => 'Ноктију више нема, али бодова има.';

  @override
  String get yReactionRelief15 => 'Последњи звиждук никад није звучао боље.';

  @override
  String get yReactionRelief16 =>
      'Драго ми је што смо победили, брине ме како.';

  @override
  String get yReactionRelief17 => 'Стално се извучемо. Једног дана нећемо.';

  @override
  String get yReactionFury12 => 'Волим ову екипу и управо зато ово боли.';

  @override
  String get yReactionFury13 =>
      'Лоше вече. Следећи пут нам дугују једну и то знају.';

  @override
  String get yReactionFury14 =>
      'Угасио сам у седамдесетом минуту. Требало је у шездесетом.';

  @override
  String get yReactionFury15 => 'Нема борбе, нема идеја, нема изговора.';

  @override
  String get yReactionFury16 =>
      'Сваки пут исти проблеми, а нико ништа не поправља.';

  @override
  String get yReactionFury17 =>
      'Неко у савезу мора ово поново да погледа и да нам објасни.';

  @override
  String get backupShareHint =>
      'Прави једну датотеку резервне копије са свим сачуваним играма. Изабери Google Drive, iCloud Drive или Датотеке за чување.';

  @override
  String backupLastAt(String date) {
    return 'Последња копија: $date';
  }

  @override
  String get backupNever => 'Још нема копије';

  @override
  String get backupRemindersTitle => 'Подсетници за копију';

  @override
  String get backupRemindersBlurb =>
      'Порука у сандучету кад ти последња копија почне да застарева.';

  @override
  String get backupAutoICloudTitle => 'Аутоматска копија на iCloud';

  @override
  String get backupAutoDriveTitle => 'Аутоматска копија на Google Drive';

  @override
  String get backupAutoBlurb =>
      'Прави копију после утакмица, на крају циклуса и кад изађеш из апликације. Чува последње две.';

  @override
  String get backupStatusUploading => 'Прављење копије.';

  @override
  String get backupStatusUploaded => 'Копија је направљена.';

  @override
  String get backupStatusICloudSignedOut =>
      'iCloud је искључен. Пријави се на iCloud и укључи iCloud Drive у апликацији Подешавања.';

  @override
  String get backupStatusDriveSignedOut =>
      'Ниси пријављен. Укључи прекидач за пријаву преко Google-а.';

  @override
  String get backupStatusNotConfigured =>
      'Још није доступно у овој верзији апликације.';

  @override
  String get backupStatusUnavailable =>
      'Облак тренутно није доступан. Покушаће поново касније.';

  @override
  String get backupStatusFailed =>
      'Последња аутоматска копија није успела. Покушаће поново касније.';

  @override
  String backupDriveSignedInAs(String email) {
    return 'Пријављен као $email';
  }

  @override
  String get backupDriveSignOut => 'ОДЈАВА';

  @override
  String get backupDriveSignInFailed =>
      'Пријава преко Google-а није успела. Покушај касније.';

  @override
  String get backupRestoreICloud => 'ВРАТИ СА ICLOUD-А';

  @override
  String get backupRestoreDrive => 'ВРАТИ СА GOOGLE DRIVE-А';

  @override
  String get backupCrossPlatformHelp =>
      'Прелазиш између iPhone-а и Android-а? Направи копију у датотеку на једном телефону и врати је из те датотеке на другом.';

  @override
  String get backupCloudListBlurb =>
      'Копије са твојих уређаја на овом налогу. Додирни једну да је вратиш.';

  @override
  String get backupCloudListEmpty =>
      'Још нема копија. Новој копији може да треба неколико минута да стигне на други уређај.';

  @override
  String get backupCloudListFailed =>
      'Копије није могуће прочитати. Провери везу и покушај поново.';

  @override
  String get backupCloudThisDevice => 'Овај уређај';

  @override
  String backupCloudMore(int count) {
    return 'Још сачуваних игара: $count';
  }

  @override
  String get backupCloudNewer =>
      'Направљено новијом верзијом апликације. Прво ажурирај.';

  @override
  String get backupCloudDownloading => 'Преузимање копије.';

  @override
  String get backupRestoreSafetyNote =>
      'Прво се на овом телефону чува копија тренутних сачуваних игара.';

  @override
  String get backupRejectedSafety =>
      'Копију тренутних сачуваних игара није било могуће сачувати, па ништа није замењено.';

  @override
  String get newsBackupReminderTitle => 'Време је за копију';

  @override
  String get newsBackupReminderBody =>
      'Твоје сачуване игре постоје само на овом телефону. Отвори Подешавања и додирни Копија у облак или тамо укључи аутоматску копију. Ови подсетници се такође могу искључити у Подешавањима.';

  @override
  String get backupSafetyTitle => 'Копије од пре враћања';

  @override
  String get backupSafetyBlurb =>
      'Чувају се на овом телефону за случај да је враћање било погрешно. Чувају се три најновије.';

  @override
  String get backupSafetyRestore => 'ВРАТИ';

  @override
  String get backupSafetyShare => 'ПОДЕЛИ';

  @override
  String get saveUpgradeFailedTitle =>
      'Сачувану игру није било могуће ажурирати';

  @override
  String get saveUpgradeFailedBody =>
      'Твоју сачувану игру није било могуће ажурирати. Ништа није обрисано, а копија од пре ажурирања чува се на овом телефону.';

  @override
  String get saveUpgradeRestoreButton => 'Врати копију од пре ажурирања';

  @override
  String get saveUpgradeRestoreFailed =>
      'Копију није било могуће вратити. Твоја сачувана игра остала је каква је била.';

  @override
  String get saveOpenFailedTitle => 'Сачуване игре није било могуће отворити';

  @override
  String get saveOpenFailedBody =>
      'Твоје сачуване игре није било могуће отворити. Ништа није обрисано. Покушај поново за тренутак.';

  @override
  String get backupCloudNoDetails => 'Детаљи су још на путу.';

  @override
  String get tacticsLibraryTitle => 'БИБЛИОТЕКА ТАКТИКА';

  @override
  String get tacticsLibraryBlurb =>
      'Тактике из библиотеке можеш да учиташ у било коју сачувану игру, па и у нову. Улоге и извођачи прекида чувају се по позицији, а не по играчу.';

  @override
  String get tacticsSaveToLibrary => 'Сачувај у библиотеку';

  @override
  String get tacticsLoadFromLibrary => 'Учитај из библиотеке';

  @override
  String get tacticsLibraryEmpty =>
      'Библиотека ти је празна. Сачувај овде тактику и моћи ћеш да је учиташ у сваку сачувану игру.';

  @override
  String tacticsLibrarySaved(String name) {
    return '„$name“ је сачувана у библиотеку';
  }

  @override
  String tacticsLibraryLoaded(String name) {
    return 'Учитано: „$name“';
  }

  @override
  String tacticsLibraryNotFitted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count улога или извођача прекида није одговарало овој екипи.',
      few: '$count улоге или извођача прекида нису одговарала овој екипи.',
      one: '1 улога или извођач прекида није одговарао овој екипи.',
    );
    return '$_temp0';
  }

  @override
  String get tacticsLibraryRename => 'Преименуј';

  @override
  String get tacticsLibraryRenameTitle => 'Преименуј тактику';

  @override
  String get tacticsLibraryDelete => 'Избриши';

  @override
  String tacticsLibraryDeleteTitle(String name) {
    return 'Избрисати „$name“?';
  }

  @override
  String get tacticsLibraryDeleteBody =>
      'Нестаће из библиотеке у свим твојим сачуваним играма.';

  @override
  String get tacticsLibraryNameTaken =>
      'У библиотеци већ постоји тактика с тим именом.';

  @override
  String tacticsLibraryCouldNotLoad(String error) {
    return 'Библиотеку није могуће учитати.\n$error';
  }

  @override
  String hostBidHeading(String competition, int year) {
    return 'Кандидатура за домаћинство: $competition $year';
  }

  @override
  String get hostBidScreenTitle => 'Кандидатура';

  @override
  String get hostBidBlurb =>
      'Домаћин се одређује жребом међу кандидатима. Кандидатура даје твом имену већу тежину: стадиони ти дају почетну шансу, а новац је повећава, мада сваки додатни милион вреди мало мање. Новац је потрошен, победио или не.';

  @override
  String hostBidPrize(String amount) {
    return 'Ако победиш, бићеш домаћин, аутоматски се пласираш и добијаш једнократну помоћ од $amount за следећи буџет.';
  }

  @override
  String get hostBidPartnerTitle => 'Судомаћин';

  @override
  String get hostBidPartnerBlurb =>
      'Кандидуј се заједно с другом државом своје конфедерације. Рачунају се стадиони обе земље, јак сусед јача кандидатуру, а ако победите, обе земље су домаћини и аутоматски се квалификују. Подршка се дели, па је твој део мањи.';

  @override
  String get hostBidPartnerNeeded =>
      'Твоји стадиони сами нису довољни. Изабери судомаћина за заједничку кандидатуру.';

  @override
  String get hostBidPartnerAlone => 'Кандидуј се сам';

  @override
  String get hostBidPartnerAgrees => 'Спреман за заједничко домаћинство';

  @override
  String get hostBidPartnerDeclinesOwnBid => 'Одбија: радије се кандидује сам.';

  @override
  String get hostBidPartnerDeclinesTooFar =>
      'Одбија: предалеко за заједничку кандидатуру.';

  @override
  String get hostBidPartnerDeclinesFunds =>
      'Одбија: овог пута не може да финансира свој део.';

  @override
  String hostBidPrizeJoint(String nation, String amount) {
    return 'Ако победиш, домаћин си заједно с државом $nation: обе земље се аутоматски квалификују, а добијаш једнократну подршку од $amount, свој део, за следећи буџет.';
  }

  @override
  String get hostBidChance => 'Шанса за домаћинство';

  @override
  String get hostBidBaseLabel => 'Стадиони и углед';

  @override
  String get hostBidInvestLabel => 'Улагање';

  @override
  String hostBidCeiling(String nation, String percent) {
    return 'Горња граница за $nation: $percent';
  }

  @override
  String get hostBidInvestment => 'Твоје улагање';

  @override
  String hostBidFreeFunds(String amount) {
    return 'Слободна средства: $amount';
  }

  @override
  String get hostBidSubmit => 'Поднеси кандидатуру';

  @override
  String get hostBidDecline => 'Не овај пут';

  @override
  String get hostBidUnavailable => 'Ова кандидатура више није отворена.';

  @override
  String hostBidWonTitle(String competition, int year) {
    return 'Кандидатура успела: $competition $year';
  }

  @override
  String hostBidWonBody(String amount) {
    return 'Бићемо домаћини турнира и као домаћин се пласирамо аутоматски. Једнократна помоћ од $amount већ је у каси савеза и можеш одмах да је распоредиш одељењима у овом циклусу са главног екрана.';
  }

  @override
  String hostBidLostTitle(String competition, int year) {
    return 'Кандидатура неуспела: $competition $year';
  }

  @override
  String hostBidLostBody(String hosts) {
    return 'Домаћинство је добио: $hosts. Наша кандидатура овај пут није била довољна и уложени новац је изгубљен, али савез се добро представио.';
  }

  @override
  String get hostBidGrantEvent => 'Распореди помоћ за домаћинство';

  @override
  String hostBidGrantBanner(String amount) {
    return 'Помоћ за домаћинство: $amount које одмах можеш да додаш одељењима у овом циклусу. Већ распоређено остаје, а остатак остаје у каси.';
  }

  @override
  String get stadiumsTitle => 'Национални стадиони';

  @override
  String get stadiumsEntrySub => 'Надогради стадион или изгради нови';

  @override
  String get stadiumsBlurb =>
      'Ниво стадиона је његова величина: ниво 1 испод 15.000 места, ниво 2 од 15.000, ниво 3 од 25.000, ниво 4 од 40.000, ниво 5 од 60.000. Сваки стадион на почетку сваког циклуса доноси мали приход, више за више места, док их навијачи пуне. Надоградња одмах додаје места и мало угледа од следећег циклуса; смањење снижава одржавање, али ништа се не враћа. Твоји стадиони одлучују за које турнире смеш да се кандидујеш.';

  @override
  String stadiumsIncome(String amount) {
    return 'Приход од стадиона: $amount по циклусу';
  }

  @override
  String stadiumsReputation(int points) {
    return 'Углед од стадиона: +$points';
  }

  @override
  String get stadiumsClosed =>
      'Радови се наручују на почетку циклуса, пре него што поставиш буџет.';

  @override
  String stadiumsCapacity(String seats) {
    return 'Капацитет: $seats';
  }

  @override
  String stadiumsLevel(int level, int max) {
    return 'Ниво $level/$max';
  }

  @override
  String stadiumsUpgrade(String cost) {
    return 'Надогради: $cost';
  }

  @override
  String get stadiumsTopLevel => 'Највиши ниво';

  @override
  String stadiumsOpens(int year) {
    return 'У изградњи, отвара се $year.';
  }

  @override
  String get stadiumsBuildTitle => 'Изгради нови стадион';

  @override
  String get stadiumsOtherGrounds => 'Остали стадиони';

  @override
  String get stadiumsOtherGroundsBody =>
      'Додати у твоју базу података. Угошћују неке домаће утакмице; завршни турнири, кандидатуре за домаћинство и приходи од стадиона долазе из националног скупа изнад.';

  @override
  String get stadiumsBuildBody =>
      'Прилично скупо: нови стадион у граду који изабереш, отворен од почетка следећег циклуса.';

  @override
  String get stadiumsBuildCity => 'Град';

  @override
  String stadiumsBuildButton(String cost) {
    return 'Изгради: $cost';
  }

  @override
  String get stadiumsBuilding => 'Један стадион се већ гради.';

  @override
  String get stadiumsNoCity => 'Сваки град већ има нови стадион.';

  @override
  String stadiumsConfirmUpgrade(String stadium, int level, String cost) {
    return 'Надоградити $stadium на ниво $level за $cost?';
  }

  @override
  String stadiumsConfirmBuild(String city, String cost) {
    return 'Изградити нови стадион за $cost? Град: $city';
  }

  @override
  String get stadiumsConfirm => 'Потврди';

  @override
  String get stadiumsCancel => 'Одустани';

  @override
  String get stadiumsRefused => 'Поруџбина није прошла. Ништа није наплаћено.';

  @override
  String get stadiumsNameLabel => 'Назив стадиона';

  @override
  String get stadiumsNameHint => 'Остави празно да задржиш предложени назив.';

  @override
  String get stadiumsRename => 'Преименуј стадион';

  @override
  String get hostBidSectionTitle => 'Кандидатуре за домаћинство';

  @override
  String get hostBidOpenSub => 'Необавезно. Одлучи пре почетка новог циклуса.';

  @override
  String get hostBidDecidedAtRollover =>
      'Домаћин се објављује на почетку новог циклуса.';

  @override
  String get hostBidLodged =>
      'Кандидатура предата. Домаћин се објављује на почетку новог циклуса.';

  @override
  String hostBidJointWith(String nation) {
    return 'Заједничка кандидатура с државом $nation.';
  }

  @override
  String get hostBidJointOnlyOpen =>
      'Премало за самостално домаћинство, али заједничка кандидатура са судомаћином је отворена.';

  @override
  String get hostBidDeclinedNote => 'Овај пут си одлучио да се не кандидујеш.';

  @override
  String get hostBidOpensLater =>
      'Испуњаваш услове. Можеш да се кандидујеш на крају овог циклуса.';

  @override
  String get hostBidNoFunds =>
      'Нема довољно слободних средстава за кандидатуру.';

  @override
  String hostBidNeedStadiums(int count, String seats) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Недостаје ти још $count стадиона са $seats+ места.',
      few: 'Недостају ти још $count стадиона са $seats+ места.',
      one: 'Недостаје ти још 1 стадион са $seats+ места.',
    );
    return '$_temp0';
  }

  @override
  String hostBidBarredConf(String confederation) {
    return '$confederation је била домаћин последњег Светског првенства.';
  }

  @override
  String get hostBidRecentHost =>
      'Био си домаћин једног од последња три издања.';

  @override
  String hostBidBarRequirement(
    int grounds,
    String otherSeats,
    String finalSeats,
    int semiGrounds,
    String semiSeats,
  ) {
    return 'Услов: стадиони са $otherSeats+ места: $grounds. Финале: $finalSeats+ места. Полуфинала: $semiGrounds × $semiSeats+ места.';
  }

  @override
  String hostBidBarRequirementNoSemis(
    int grounds,
    String otherSeats,
    String finalSeats,
  ) {
    return 'Услов: стадиони са $otherSeats+ места: $grounds. Финале: $finalSeats+ места.';
  }

  @override
  String hostBidNeedFinalGround(String seats) {
    return 'За финале ти недостаје стадион са $seats+ места.';
  }

  @override
  String hostBidNeedSemiGrounds(int count, String seats) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'За полуфинала ти недостаје још $count стадиона са $seats+ места.',
      few: 'За полуфинала ти недостају још $count стадиона са $seats+ места.',
      one: 'За полуфинала ти недостаје још 1 стадион са $seats+ места.',
    );
    return '$_temp0';
  }

  @override
  String get hostBidBelowBar =>
      'Твоји стадиони не испуњавају услове овог турнира.';

  @override
  String get hostBidRulesPending =>
      'Да ли можеш да се кандидујеш, биће јасно кад се објаве домаћини овог циклуса.';

  @override
  String get hostBidBackToBack =>
      'Домаћин си турнира непосредно пре овог. Ниједна земља није домаћин два турнира заредом.';

  @override
  String get hostBidOneOnly =>
      'Већ си се кандидовао за други турнир. Ниједна земља није домаћин два турнира заредом, па можеш да се кандидујеш само за један.';

  @override
  String hostBidRequirement(
    int grounds,
    String minSeats,
    int bigGrounds,
    String bigSeats,
  ) {
    return 'Услов: стадиони са $minSeats+ места: $grounds, од тога са $bigSeats+: $bigGrounds.';
  }

  @override
  String hostBidWonBodyBudget(String amount) {
    return 'Бићемо домаћини турнира и као домаћин смо аутоматски пласирани. Једнократна помоћ од $amount већ је у средствима савеза, спремна за буџет овог циклуса.';
  }

  @override
  String hostBidWonJointBody(String hosts, String amount) {
    return '$hosts ће заједно бити домаћини турнира, а ми се као домаћин аутоматски квалификујемо. Наш део подршке, $amount, сада је у средствима савеза и можеш одмах са почетног екрана да га распоредиш одељењима овог циклуса.';
  }

  @override
  String hostBidWonJointBodyBudget(String hosts, String amount) {
    return '$hosts ће заједно бити домаћини турнира, а ми се као домаћин аутоматски квалификујемо. Наш део подршке, $amount, већ је у средствима савеза, спреман за буџет овог циклуса.';
  }

  @override
  String get hubStadiumIncome => 'Приходи од стадиона';

  @override
  String get stadiumsDownsize => 'Смањи';

  @override
  String stadiumsConfirmDownsize(String stadium, String seats, int level) {
    return 'Смањити $stadium на $seats места (ниво $level)? Ништа се не враћа, али трошкови одржавања падају.';
  }

  @override
  String get stadiumsResizedThisCycle => 'Преуређен у овом циклусу';

  @override
  String stadiumsGroundIncome(String amount) {
    return 'Доноси $amount по циклусу';
  }

  @override
  String hostBidLapsedTitle(String competition, int year) {
    return 'Кандидатура повучена: $competition $year';
  }

  @override
  String hostBidLapsedBodyNation(String nation) {
    return 'Кандидатура је предата за репрезентацију $nation, а нови циклус почињеш негде другде. Повучена је и ништа није наплаћено.';
  }

  @override
  String get hostBidLapsedBodyFunds =>
      'На крају циклуса средства савеза више нису покривала улог. Кандидатура је повучена и ништа није наплаћено.';

  @override
  String get stadiumsViewMap => 'Мапа';

  @override
  String get stadiumsViewList => 'Списак';

  @override
  String get stadiumsMapPickCity =>
      'Додирни град у ком желиш да изградиш нови стадион.';

  @override
  String get stadiumsMapFit => 'Прикажи целу земљу';

  @override
  String get campaignLegacyTitle => 'Доврши наслеђе';

  @override
  String get campaignLegacyTwist =>
      'Шпанија, актуелни европски шампион, кроз један циклус';

  @override
  String get campaignLegacyGoal => 'Одбрани европску титулу';

  @override
  String get campaignLegacyIntro =>
      'Шпанија је актуелни европски шампион, а сумњичави златну еру зову једнократним чудом. Имаш један циклус да докажеш супротно: одбрани круну континента, а онда крени по свет. Додај и Куп нација и наслеђе је довршено.';

  @override
  String get campaignStars1Legacy => 'Освоји Европско првенство';

  @override
  String get campaignStars2Legacy => 'И Светско првенство';

  @override
  String get campaignStars3Legacy => 'И Куп нација';

  @override
  String get campaignSectionOneCycle => 'Један циклус';

  @override
  String get campaignSectionShort => 'Неколико циклуса';

  @override
  String get campaignSectionLong => 'Дуга стаза';

  @override
  String get campaignFilterAll => 'Све';

  @override
  String get campaignFilterNew => 'Неигране';

  @override
  String get campaignFilterInProgress => 'У току';

  @override
  String get campaignFilterDone => 'Завршене';

  @override
  String get campaignFilterEmpty => 'Овде још нема кампања.';

  @override
  String campaignStarsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count звездица',
      few: '$count звездице',
      one: '1 звездица',
      zero: 'Без звездица',
    );
    return '$_temp0';
  }

  @override
  String campaignCycles(int cycles) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles циклуса',
      few: '$cycles циклуса',
      one: '$cycles циклус',
    );
    return '$_temp0';
  }

  @override
  String get msgIntlRetireNoteHigh => ' Одлази на врхунцу, као шампион.';

  @override
  String get msgIntlRetireNoteMissed =>
      ' Пропуштено завршно такмичење била је кап која је прелила чашу.';

  @override
  String get msgIntlRetireNoteSurprise => ' Нико то није очекивао.';

  @override
  String get msgIntlRetireNoteRecord => ' Одлази као рекордер репрезентације.';

  @override
  String msgIntlRetireNewsTitle(String nation, String name) {
    return '$nation: $name се повлачи из репрезентације';
  }

  @override
  String msgIntlRetireNewsBody(String name, String nation, int age) {
    return '$name ($nation) објавио је у $age. години опроштај од репрезентације.';
  }

  @override
  String msgIntlComebackTitle(String name) {
    return '$name се враћа у репрезентацију';
  }

  @override
  String msgIntlComebackBody(String name, int age) {
    return '$name је у $age. години поново на располагању селектору.';
  }

  @override
  String get msgIntlComebackNoteCrisis =>
      ' Са екипом десеткованом повредама, одазвао се позиву.';

  @override
  String get msgIntlComebackNoteManager => ' Нови селектор га је наговорио.';

  @override
  String msgIntlComebackNewsTitle(String nation, String name) {
    return '$nation: $name се враћа у репрезентацију';
  }

  @override
  String msgIntlComebackNewsBody(String name, String nation, int age) {
    return '$name ($nation) је у $age. години поново на располагању селектору.';
  }

  @override
  String msgPoachTitle(String rival, String name) {
    return 'Репрезентација $rival покушава да привуче играча $name';
  }

  @override
  String msgPoachBody(
    String rival,
    String name,
    int age,
    String position,
    String nation,
    int count,
  ) {
    return 'Репрезентација $rival обратила се играчу $name ($age, $position) с понудом да промени репрезентацију. Још није одиграо такмичарску утакмицу за репрезентацију $nation, па још увек може да промени. Дај му минутажу у једној од наших следећих $count такмичарских утакмица и заувек ће бити везан за нас. У супротном би могао да прихвати њихову понуду.';
  }

  @override
  String msgPoachTiedTitle(String name, String rival) {
    return 'Репрезентација $rival остаје без играча $name';
  }

  @override
  String msgPoachTiedBody(String name, String rival, String nation) {
    return '$name је одиграо такмичарску утакмицу за репрезентацију $nation, па репрезентација $rival више не може да га позове. Заувек је везан за нас.';
  }

  @override
  String msgPoachStayedTitle(String name, String rival) {
    return '$name одбија понуду репрезентације $rival';
  }

  @override
  String msgPoachStayedBody(String name, String rival, String nation) {
    return '$name још нема такмичарски наступ за репрезентацију $nation, али је репрезентацији $rival поручио да жели да сачека своју шансу код нас.';
  }

  @override
  String msgPoachSwitchedTitle(String name, String rival) {
    return '$name прелази у репрезентацију $rival';
  }

  @override
  String msgPoachSwitchedBody(String name, String rival, String nation) {
    return '$name је прихватио понуду репрезентације $rival и од сада игра за њу. Без такмичарског наступа за репрезентацију $nation ништа није могло да га задржи.';
  }

  @override
  String msgPoachSwitchedBodyPromise(String name, String rival, String nation) {
    return '$name је прихватио понуду репрезентације $rival. Обећана му је минутажа у репрезентацији $nation која никад није дошла, и од сада игра за репрезентацију $rival.';
  }

  @override
  String get poachPromiseButton => 'Обећај му минутажу';

  @override
  String get poachPromisedLabel => 'Минутажа обећана';

  @override
  String get poachCallUpsButton => 'Отвори позиве';

  @override
  String get poachPromiseHint =>
      'Обећање га тера да сачека још једну такмичарску утакмицу, али ако га прекршиш, вероватније ће отићи.';

  @override
  String playerIntlRetired(int year) {
    return 'Повукао се из репрезентације, $year';
  }

  @override
  String playerIntlComeback(int year) {
    return 'Повратак у репрезентацију, $year';
  }

  @override
  String yLegendRetires0(String name) {
    return 'Хвала, $name. Неки носе дрес, он је носио тим.';
  }

  @override
  String yLegendRetires1(String name) {
    return '$name завршава репрезентативну каријеру. Крај једне ере.';
  }

  @override
  String yLegendRetires2(String name) {
    return '$name се повлачи. Искрено, један турнир прекасно.';
  }

  @override
  String yLegendRetires3(String name) {
    return 'Дакле, $name је готов. Време је за младе.';
  }

  @override
  String matchAltitudeOpponentsTire(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'Надморска висина $altitudeString m: противник ће се брже уморити';
  }

  @override
  String matchAltitudeYouTire(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'Надморска висина $altitudeString m: твоји играчи ће се брже уморити';
  }

  @override
  String matchAltitudeBothTire(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'Надморска висина $altitudeString m: обе екипе ће се брже уморити';
  }

  @override
  String matchAltitudeUsedTo(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'Надморска висина $altitudeString m: обе екипе су навикле';
  }

  @override
  String matchHeatExpected(int temp) {
    final intl.NumberFormat tempNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String tempString = tempNumberFormat.format(temp);

    return 'Врућина: очекује се $tempString °C, снага ће раније попустити';
  }

  @override
  String get matchConditionsAdvice =>
      'Планирај измене рано: овде свеже ноге више вреде';

  @override
  String get fanMoodFurious => 'бесни';

  @override
  String get fanMoodRestless => 'немирни';

  @override
  String get fanMoodCalm => 'мирни';

  @override
  String get fanMoodUpbeat => 'оптимистични';

  @override
  String get fanMoodEuphoric => 'у еуфорији';

  @override
  String matchHomeFans(String mood) {
    return 'Домаћи навијачи: $mood';
  }

  @override
  String federationFans(String mood) {
    return 'Навијачи: $mood';
  }

  @override
  String federationFansIncome(String change) {
    return 'Приход од стадиона у следећем циклусу: $change';
  }

  @override
  String yFansProtest0(String nation, String manager) {
    return 'Двадесет година пратим репрезентацију код куће и у гостима. Нећу да продужим сезонску док се нешто не промени.';
  }

  @override
  String yFansProtest1(String nation, String manager) {
    return 'Наставићемо да певамо за дрес. Али транспарент на северној трибини вечерас је рекао оно што сви мислимо.';
  }

  @override
  String yFansProtest2(String nation, String manager) {
    return 'Пола стадиона празно, а друга половина је цело друго полувреме скандирала #${manager}Out.';
  }

  @override
  String yFansProtest3(String nation, String manager) {
    return 'Навијачке групе причају о бојкоту следеће домаће утакмице. Тешко их је кривити.';
  }

  @override
  String yFansProtest4(String nation, String manager) {
    return '#${manager}Out. Више нисам ни љут. Једноставно је готово.';
  }

  @override
  String yFansProtest5(String nation, String manager) {
    return 'Фотографија са вечерашње утакмице: редови празних седишта и један чаршав са натписом #${manager}Out. То је цео извештај.';
  }

  @override
  String yFansSellOut0(String nation) {
    return 'Опет распродато. Најбоља репрезентација у последњих неколико година и цела земља то зна.';
  }

  @override
  String yFansSellOut1(String nation) {
    return 'Улазнице за следећу домаћу утакмицу плануле су за једанаест минута. Ова екипа нам је вратила викенде.';
  }

  @override
  String yFansSellOut2(String nation) {
    return 'Ни једно слободно место за следећу домаћу утакмицу. Савез ће бројати приход од улазница са осмехом.';
  }

  @override
  String yFansSellOut3(String nation) {
    return 'Још једна распродаја. Причајте шта хоћете о тактици, људи желе да буду на том стадиону.';
  }

  @override
  String yFansSellOut4(String nation) {
    return 'Распродато, добро. Исти људи су звиждали овој екипи пре годину и по.';
  }

  @override
  String yFansSellOut5(String nation) {
    return 'Одједном распродато, одједном сви стручњаци. Где сте били кад нисмо могли никог да победимо?';
  }

  @override
  String get campaignsIntro =>
      'Кампање су ручно састављени изазови: задата репрезентација, свет са сопственим обртом и циљ који треба остварити у одређеном броју циклуса. Сваки поход је одвојен од твојих сачуваних каријера, а што даље стигнеш, то више звездица освајаш, до три.';

  @override
  String hubEventScandal(String player) {
    return 'Скандал на окупљању: $player';
  }

  @override
  String get hubEventScandalSub => 'Послати га кући или задржати?';

  @override
  String get scandalTitle => 'СКАНДАЛ';

  @override
  String scandalStoryParty(String player) {
    return '$player је био на журци која је трајала до зоре, а слике су биле у свим новинама оног јутра кад се екипа окупила.';
  }

  @override
  String scandalStoryCurfew(String player) {
    return '$player је прекршио полицијски час и ухваћен је како се у ситне сате враћа у хотел.';
  }

  @override
  String scandalStoryNightclub(String player) {
    return '$player је фотографисан у ноћном клубу уочи окупљања, а слике су свуда.';
  }

  @override
  String scandalStoryCasino(String player) {
    return '$player је ноћ пре окупљања провео за коцкарским столом, а таблоид има слике.';
  }

  @override
  String get scandalSendHome => 'Пошаљи га кући';

  @override
  String scandalSendHomeCover(String player) {
    return 'Кући, позови: $player';
  }

  @override
  String scandalKeep(String player) {
    return 'Задржи: $player';
  }

  @override
  String get scandalKeepNote =>
      'Ако остане: морал отприлике -4 и управа отприлике -3 до краја циклуса.';

  @override
  String get scandalSendHomeNote =>
      'Ако га пошаљеш кући: нема последица за морал ни управу, а можеш да позовеш замену.';

  @override
  String get scandalFinalsNote =>
      'Ако га пошаљеш кући: нема последица за морал ни управу, али на завршном турниру нико не може да га замени.';

  @override
  String get scandalPickCover => 'Позови замену (необавезно)';

  @override
  String newsScandalTitle(String player) {
    return 'Скандал на окупљању: $player';
  }

  @override
  String yScandalParty0(String player, String tag) {
    return 'Млади су то. $player на журци вече пре окупљања, а ја га свеједно желим на терену. #$tag';
  }

  @override
  String yScandalParty1(String player, String tag) {
    return '$player фотографисан на целоноћној журци, неколико сати пре окупљања репрезентације. Савез је обавештен. #$tag';
  }

  @override
  String yScandalParty2(String player, String tag) {
    return 'Целоноћна журка пре окупљања. $player, шта си мислио? Невероватно. #$tag';
  }

  @override
  String yScandalCurfew0(String player, String tag) {
    return 'Вратио се после полицијског часа, добро, дешава се. $player то само мора да исправи на терену. #$tag';
  }

  @override
  String yScandalCurfew1(String player, String tag) {
    return '$player ухваћен како се после полицијског часа враћа у хотел репрезентације, неколико сати пре тренинга. #$tag';
  }

  @override
  String yScandalCurfew2(String player, String tag) {
    return 'Полицијски час није компликована ствар. $player није издржао ни једну ноћ. #$tag';
  }

  @override
  String yScandalNightclub0(String player, String tag) {
    return 'Па $player је био у клубу. И фудбалери имају живот. Пустите га да игра. #$tag';
  }

  @override
  String yScandalNightclub1(String player, String tag) {
    return 'Фотографије показују играча $player у ноћном клубу уочи окупљања репрезентације. #$tag';
  }

  @override
  String yScandalNightclub2(String player, String tag) {
    return 'Слике из клуба уочи окупљања. $player је обрукао дрес. #$tag';
  }

  @override
  String yScandalCasino0(String player, String tag) {
    return 'Ноћ у казину није злочин. $player ће бити добро. #$tag';
  }

  @override
  String yScandalCasino1(String player, String tag) {
    return '$player виђен за коцкарским столом ноћ пре окупљања репрезентације. #$tag';
  }

  @override
  String yScandalCasino2(String player, String tag) {
    return 'Целу ноћ у казину пре окупљања. $player је прокоцкао више од новца. #$tag';
  }

  @override
  String yScandalSentHome0(String player) {
    return 'Исправна одлука. Нико није већи од тима, па ни $player.';
  }

  @override
  String yScandalSentHome1(String player) {
    return 'Слање кући био је једини одговор. $player је сам крив. Поштовање селектору.';
  }

  @override
  String yScandalSentHome2(String player) {
    return 'Дисциплина је дисциплина. $player је знао правила.';
  }

  @override
  String yScandalSentHome3(String player) {
    return 'Јасна порука свлачионици: $player је у авиону за кућу.';
  }

  @override
  String yScandalSentHome4(String player) {
    return 'Сурово. $player изађе једно вече и окупљање је за њега готово?';
  }

  @override
  String yScandalSentHome5(String player) {
    return 'Слање кући нас слаби. $player одлази, а ми ћемо то платити на терену.';
  }

  @override
  String yScandalKept0(String player) {
    return 'Задржати га је коцкање. $player нека то врати на терену.';
  }

  @override
  String yScandalKept1(String player) {
    return 'Добро, $player остаје. Онда свима дугује праву представу.';
  }

  @override
  String yScandalKept2(String player) {
    return 'Дакле, правила за њега не важе. $player је изузетак. Добро је знати.';
  }

  @override
  String yScandalKept3(String player) {
    return 'Полицијски час је сада очигледно необавезан. Питајте: $player.';
  }

  @override
  String yScandalKept4(String player) {
    return 'Задржати га после тога? $player и екипа су на летовању.';
  }

  @override
  String yScandalKept5(String player) {
    return 'Журка целу ноћ, а онда право у првих једанаест. Сјајна порука, селекторе. $player је сигурно одушевљен.';
  }

  @override
  String get yStreamerBreaks0 =>
      'БРАТА СУ УХВАТИЛИ 😭😭 НОЋ ПРЕ ОКУПЉАЊА?? ПЛАЧЕМ 💀💀💀';

  @override
  String get yStreamerBreaks1 =>
      'НЕЕЕ ЧЕТ ГЛЕДАЈТЕ ОВО 🤯🤯 БРАТ ЈЕ ТО СТВАРНО УРАДИО ПРЕ ОКУПЉАЊА 😭🔥';

  @override
  String get yStreamerBreaks2 =>
      'КО ГА ЈЕ ПУСТИО НАПОЉЕ?? КО ГА ЈЕ ПУСТИО 😭😭💀 ОВО ЈЕ БИОСКОП 🔥🔥';

  @override
  String get yStreamerSentHome0 =>
      'КУЋИ?? КУЋИИИ!!! 😭😭😭 СЕЛЕКТОР СЕ НЕ ШАЛИ 💀🔥';

  @override
  String get yStreamerSentHome1 =>
      'БРАТ ПАКУЈЕ КОФЕРЕ УЖИВО 🤯🤯 ЋАО БРАТЕ 😭👋';

  @override
  String get yStreamerSentHome2 =>
      'НЕМА ШАНСЕЕЕ ПОСЛАЛИ СУ ГА КУЋИ 💀💀 ЧЕТ ТРЕСЕМ СЕ 🔥🔥🔥';

  @override
  String get yStreamerKept0 =>
      'ОСТАЈЕ??? ОСТАЈЕЕЕ 🤯🤯 БРАТ ЈЕ НЕДОДИРЉИВ 😭🔥';

  @override
  String get yStreamerKept1 =>
      'ЖУРКА ЦЕЛУ НОЋ И ЈОШ УВЕК У ЕКИПИ 💀💀 ХОЋУ ТАЈ УГОВОР 😭😭';

  @override
  String get yStreamerKept2 =>
      'СЕЛЕКТОР КАЖЕ ДА ЈЕ СВЕ ОК 😭😭 БРАТЕ ШТА 🤯🤯🤯';

  @override
  String get yCameoUjfaloci => 'Ништа нисам платио, а ни тај износ се не слаже';

  @override
  String get yCameoHavir0 => 'Рибице су отпливале.';

  @override
  String get yCameoHavir1 => 'Бацили смо мреже, а рибе су биле негде другде.';

  @override
  String get yCameoHavir2 => 'Рекао сам то још у септембру, уз гулаш.';

  @override
  String get yCameoHavir3 => 'Ко није пецао на време, нека сад не плаче.';

  @override
  String get yCameoHavir4 => 'Играли смо као сом на сувом.';

  @override
  String get yCameoHavir5 => 'Ветар дува, рибњак се леди. Тако то иде.';

  @override
  String get yCameoHavir6 => 'Некад извучеш само стару чизму.';

  @override
  String get yCameoHavir7 => 'У моје време бар се ишло на пиво. Сад ни то.';

  @override
  String get yCameoLzimberskyHome0 =>
      'Послати момка кући због једне вечери? То је скандал, а не журка!';

  @override
  String get yCameoLzimberskyHome1 =>
      'Момци ваљда смеју мало да се забаве! Лицемерни медији опет су победили.';

  @override
  String get yCameoLzimberskyHome2 =>
      'Ово је лов на вештице. Младић изађе једно вече, а ви га вешате.';

  @override
  String get yCameoLzimberskyHome3 =>
      'Новинар који никад није био на журци нека баци први камен. Срамота!';

  @override
  String get yCameoLzimberskyHome4 =>
      'Селектор се уплашио таблоида. Ја бих момка бранио до последњег даха!';

  @override
  String get yCameoLzimberskyKept0 =>
      'Коначно селектор с кичмом! Задржао је момка, а медији нека плачу.';

  @override
  String get yCameoLzimberskyKept1 =>
      'Момци ваљда смеју мало да се забаве, зар не? Браво, селекторе!';

  @override
  String get yCameoLzimberskyKept2 =>
      'Лицемерни медији вриште, селектор не попушта. Тако се то ради!';

  @override
  String get yCameoLzimberskyKept3 =>
      'Једно вече напољу, а новинари би га каменовали. Селектор је прави мушкарац!';

  @override
  String get yCameoLzimberskyKept4 =>
      'Кажем: пустите момке да живе! Ко ради, тај сме и да се забави. Палац горе.';

  @override
  String get yCameoMarena => 'Ово бих и ја могла да тренирам.';

  @override
  String get yCameoKralik => 'Шта си очекивао хехехе, купуј наш ZeroZero';

  @override
  String get yCameoPosuk0 => 'ЈАДНО';

  @override
  String get yCameoPosuk1 => 'БОЖЕ ДРАГИИИ';

  @override
  String get yCameoPosuk2 => 'Неко у кафану?';

  @override
  String get yTraitStreamer => 'Стримује све, из све снаге, великим словима.';

  @override
  String hubEventAwardsCeremony(int year) {
    return 'Играч године $year';
  }

  @override
  String get hubEventAwardsCeremonySub => 'Гласови су пребројани';

  @override
  String get potyCeremonyWatch => 'Гледај церемонију';

  @override
  String get potyCeremonySkipToList => 'Право на првих пет';

  @override
  String get potyCeremonySkip => 'Прескочи';

  @override
  String get potyCeremonyIntro =>
      'Гласови су пребројани. Ово је пет најбољих играча света ове године.';

  @override
  String potyCeremonyPlace(int place) {
    return '$place. место';
  }

  @override
  String get potyCeremonyWinnerIs => 'А играч године је...';

  @override
  String get potyTop5Heading => 'Најбољих пет на свету';

  @override
  String get potyYoungTop3Heading => 'Млади играч године: најбоља тројица';

  @override
  String get potySeeTop5 => 'Погледај првих пет';

  @override
  String get potyYourPlayer => 'Твој играч';

  @override
  String potyTallyCleanSheets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count утакмица без примљеног гола',
      few: '$count утакмице без примљеног гола',
      one: '$count утакмица без примљеног гола',
    );
    return '$_temp0';
  }

  @override
  String get campaignFullBrief => 'Цео опис';

  @override
  String campaignStarsSoFar(int earned, int total) {
    return 'Досад освојене звездице: $earned од $total';
  }

  @override
  String get campaignStarEarned => 'Досад освојена';

  @override
  String get campaignStarNotYet => 'Још није освојена';

  @override
  String get stadiumsEntrySubClosed =>
      'Погледај своје стадионе. Радови се поново отварају на почетку следећег циклуса.';

  @override
  String get boardObjectiveNoBrief => 'Без постављеног циља';

  @override
  String get boardObjectiveNoBriefBody =>
      'Управа не очекује да стигнеш до ове завршнице. Оцењиваће те по резултатима.';

  @override
  String get boardObjectiveAwaitingDraw => 'Циљ после жреба';

  @override
  String get boardObjectiveAwaitingDrawBody =>
      'Управа ће поставити овај циљ после жреба група.';

  @override
  String get boardObjectiveLaterEdition => 'Циљ тек у другом купу';

  @override
  String get boardObjectiveLaterEditionBody =>
      'Овај циклус има два издања Купа нација, а управа оцењује само друго. Ово издање нема циљ, али те његови резултати још пре жреба другог померају лигу горе или доле.';

  @override
  String tourThirdsNextAdvance(int count, String destination) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Следећих $count екипа иде даље у $destination',
      few: 'Следеће $count екипе иду даље у $destination',
      one: 'Следећа екипа иде даље у $destination',
    );
    return '$_temp0';
  }

  @override
  String yWinEuphoric0(String opponent, String score) {
    return 'Невероватно вече. Ни у најлуђим сновима ово нисмо могли да предвидимо. $score против екипе $opponent!';
  }

  @override
  String yWinEuphoric1(String opponent, String score) {
    return '$score против екипе $opponent. Уштипните ме. Нека ме неко уштипне, молим вас.';
  }

  @override
  String yWinEuphoric2(String opponent, String score) {
    return 'Плачем на трибини. $score против екипе $opponent. Волим ову екипу.';
  }

  @override
  String yWinEuphoric3(String opponent, String score) {
    return '$score против екипе $opponent. Најлепше вече мог навијачког живота, и то убедљиво.';
  }

  @override
  String yWinEuphoric4(String opponent, String score) {
    return '$score против екипе $opponent. Један од највећих резултата у историји ове земље.';
  }

  @override
  String yWinEuphoric5(String opponent, String score) {
    return '$score против екипе $opponent. Нико на свету то није очекивао. Историјски.';
  }

  @override
  String yWinEuphoric6(String opponent, String score) {
    return '$score против екипе $opponent. О овоме ће се причати деценијама.';
  }

  @override
  String yWinEuphoric7(String opponent, String score) {
    return 'Запамтите где сте били вечерас: $score против екипе $opponent.';
  }

  @override
  String yWinEuphoric8(String opponent, String score) {
    return 'Целу годину гунђам и сутра ћу опет. Али вечерас? $score против екипе $opponent. Невероватно.';
  }

  @override
  String yWinEuphoric9(String opponent, String score) {
    return 'Чак ни ја не налазим на шта бих се жалио. $score против екипе $opponent. Нестварно.';
  }

  @override
  String yWinEuphoric10(String opponent, String score) {
    return '$score против екипе $opponent. Говорио сам да је ова екипа готова. Никад ми није било драже што сам погрешио.';
  }

  @override
  String yWinEuphoric11(String opponent, String score) {
    return 'Добро, признајем: $score против екипе $opponent је као из сна. Следеће недеље вероватно опет по старом.';
  }

  @override
  String yDrewGiant0(String opponent, String score) {
    return '$score против екипе $opponent. Једном речју: невероватно!';
  }

  @override
  String yDrewGiant1(String opponent, String score) {
    return 'Бод против једне од најбољих репрезентација света. Узимамо га сваки дан. $score против екипе $opponent.';
  }

  @override
  String yDrewGiant2(String opponent, String score) {
    return '$score против екипе $opponent! Остао сам без гласа и баш ме брига.';
  }

  @override
  String yDrewGiant3(String opponent, String score) {
    return '$score против екипе $opponent. Нерешено? Осећам се као да смо освојили све.';
  }

  @override
  String yDrewGiant4(String opponent, String score) {
    return 'Бод против екипе као што је $opponent нико није очекивао, али свакако га узимамо. $score, сјајан резултат.';
  }

  @override
  String yDrewGiant5(String opponent, String score) {
    return '$score против екипе $opponent. Бод који ће се памтити годинама.';
  }

  @override
  String yDrewGiant6(String opponent, String score) {
    return 'Дошли су као велики фаворити ($opponent) и одлазе са $score. Поносно вече.';
  }

  @override
  String yDrewGiant7(String opponent, String score) {
    return '$score против екипе $opponent. Скоро нико нашег нивоа не узме им бод.';
  }

  @override
  String yDrewGiant8(String opponent, String score) {
    return 'Очекивао сам дебакл. $score против екипе $opponent. Радо повлачим своје речи.';
  }

  @override
  String yDrewGiant9(String opponent, String score) {
    return 'Не волим нерешене, али $score против екипе $opponent? Узимам са осмехом.';
  }

  @override
  String yDrewGiant10(String opponent, String score) {
    return '$score против екипе $opponent. Вечерас славе чак и црногледи, укључујући мене.';
  }

  @override
  String yDrewGiant11(String opponent, String score) {
    return 'Бранили смо се као за живот и узели $score против екипе $opponent. Ружно? Кога брига. Сјајно.';
  }

  @override
  String get potyHistorySubtitle => 'Сви добитници и ко је најчешће побеђивао';

  @override
  String get potyHistoryEmpty =>
      'Играч године још није изабран. Прво гласање је 1. децембра.';

  @override
  String get potyHistoryLatest => 'Последњи добитник';

  @override
  String get potyHistoryMostWins => 'Највише награда';

  @override
  String potyHistoryWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count награда',
      few: '$count награде',
      one: '$count награда',
    );
    return '$_temp0';
  }

  @override
  String get potyHistoryByYear => 'Добитници по годинама';

  @override
  String get potyHistoryByNation => 'По државама';

  @override
  String potyHistoryYourNation(String winners, String finishes) {
    return 'Твоја држава: $winners, $finishes';
  }

  @override
  String potyHistoryWinners(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count добитника',
      few: '$count добитника',
      one: '$count добитник',
    );
    return '$_temp0';
  }

  @override
  String potyHistoryTopFive(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count пласмана у топ 5',
      few: '$count пласмана у топ 5',
      one: '$count пласман у топ 5',
    );
    return '$_temp0';
  }

  @override
  String get potyHistoryYourPlayers => 'Твоји играчи';

  @override
  String get potyHistoryNoYourPlayers =>
      'Ниједан твој играч још није завршио међу првих пет.';

  @override
  String get potyHistoryYoung => 'Млади играч';

  @override
  String get potyHistoryUnknownPlayer => 'Непознат играч';

  @override
  String get hostingTitle => 'Домаћинство';

  @override
  String get hostingThisCycle => 'Овај циклус';

  @override
  String get hostingNextCycle => 'Твоја кандидатура за следећи циклус';

  @override
  String get hostingTba => 'Биће објављено';

  @override
  String get hostingTbaWc => 'Биће објављено после континенталног првенства';

  @override
  String hostingBidPledged(String amount, String percent) {
    return 'Кандидатура предата: $amount, уз $percent шансе за домаћинство.';
  }

  @override
  String get hostingWindowLine =>
      'Кандидатуре се отварају на крају циклуса, после финала Светског првенства.';

  @override
  String hubEventWarmUpOffer(String nation) {
    return 'Понуда пријатељске утакмице: $nation';
  }

  @override
  String get hubEventWarmUpOfferSub => 'Опроштајна утакмица пред њихов турнир';

  @override
  String get warmUpOfferTitle => 'ПОНУДА ПРИЈАТЕЉСКЕ УТАКМИЦЕ';

  @override
  String warmUpOfferBody(String nation, String competition, String date) {
    return '$nation се припрема за турнир $competition и жели опроштајну утакмицу против тебе $date.';
  }

  @override
  String warmUpOfferAway(String nation) {
    return 'У гостима, код противника ($nation).';
  }

  @override
  String get warmUpOfferHome => 'Код куће: противник долази теби.';

  @override
  String get warmUpOfferNote =>
      'Можеш да прихватиш највише две понуде. Прихваћена утакмица има сопствени позив.';

  @override
  String get warmUpOfferAccept => 'Прихвати';

  @override
  String get warmUpOfferDecline => 'Одбиј';

  @override
  String warmUpOfferMsgTitle(String nation) {
    return 'Понуда пријатељске утакмице: $nation';
  }

  @override
  String warmUpOfferMsgBody(String nation, String competition) {
    return '$nation жели опроштајну утакмицу против тебе пре турнира $competition.';
  }

  @override
  String get hubSimToFinal => 'Симулирај до финала';

  @override
  String get jobDossierOpen => 'Проучи понуду';

  @override
  String get jobDossierRating => 'Снага тима';

  @override
  String get jobDossierMood => 'Расположење';

  @override
  String get jobDossierTopPlayers => 'Најбољи играчи';

  @override
  String jobDossierPlayerAge(int age) {
    return '$age г.';
  }

  @override
  String get jobDossierReport => 'Мишљење скаута';

  @override
  String get jobDossierNextTargetLabel => 'Следећи циљ';

  @override
  String jobDossierNextTarget(String cup) {
    return 'Квалификације: $cup и Светско првенство.';
  }

  @override
  String get jobDossierStrongAttack => 'Напад је заиста оштар.';

  @override
  String get jobDossierBluntAttack => 'Голови тешко долазе.';

  @override
  String get jobDossierStrongMidfield => 'Везни ред води игру.';

  @override
  String get jobDossierWeakMidfield => 'У средини терена често су надиграни.';

  @override
  String get jobDossierStrongDefence => 'Позади их је тешко пробити.';

  @override
  String get jobDossierThinDefence => 'Одбрана делује крхко.';

  @override
  String get jobDossierSafeKeeper => 'Голман на ког можеш да се ослониш.';

  @override
  String get jobDossierShakyKeeper => 'Голманска позиција забрињава.';

  @override
  String get jobDossierOldSquad => 'Екипа која стари, подмлађивање се ближи.';

  @override
  String get jobDossierYoungCore => 'Млада окосница у успону.';

  @override
  String jobDossierOneStar(String name) {
    return 'Екипу носи $name.';
  }

  @override
  String get jobDossierDeepSquad => 'Права ширина иза прве поставе.';

  @override
  String get jobDossierThinSquad => 'Мало квалитета иза прве поставе.';

  @override
  String get jobDossierBalanced => 'Уравнотежена екипа без очигледне слабости.';

  @override
  String yQualifiedEuphoric0(String competition) {
    return 'Не могу да верујем да смо успели! Скоро нико то није очекивао. $competition, стижемо 💪';
  }

  @override
  String yQualifiedEuphoric1(String competition) {
    return 'Какво чаробно вече, у земљи снова смо! $competition, стижемо!';
  }

  @override
  String yQualifiedEuphoric2(String competition) {
    return 'Увек сам веровао у ову екипу. Увек. А сада идемо на турнир $competition!';
  }

  @override
  String yQualifiedEuphoric3(String competition) {
    return 'У тој групи нико нам није давао шансе. Нико. Видимо се на турниру $competition!';
  }

  @override
  String yQualifiedEuphoric4(String competition) {
    return 'Сузе у очима. Ми, на турниру $competition. Стварно ми.';
  }

  @override
  String yQualifiedEuphoric5(String competition) {
    return 'Управо играм на улици. Пласман на турнир $competition! Нестварно 🎉';
  }

  @override
  String yQualifiedEuphoric6(String competition) {
    return 'Говорио сам да немамо шансе. Никад нисам био срећнији што сам погрешио. $competition!';
  }

  @override
  String yQualifiedEuphoric7(String competition) {
    return 'Годинама гунђам о овој екипи и сутра опет почињем. А вечерас? $competition, стижемо!';
  }

  @override
  String yQualifiedEuphoric8(String competition) {
    return 'Добро. ДОБРО. Повлачим све. Идемо на турнир $competition!';
  }

  @override
  String yKnockoutEuphoric0(String opponent) {
    return 'Пролаз! $opponent побеђени. Какво чаробно вече, у земљи снова смо!';
  }

  @override
  String yKnockoutEuphoric1(String opponent) {
    return 'Избацили смо противника: $opponent! Сањајте даље, сви 💪';
  }

  @override
  String yKnockoutEuphoric2(String opponent) {
    return 'Знао сам да ова екипа то има у себи. Збогом, $opponent, здраво, следеће коло!';
  }

  @override
  String yKnockoutEuphoric3(String opponent) {
    return 'Остао сам без гласа. $opponent је испао, а ми идемо даље!';
  }

  @override
  String yKnockoutEuphoric4(String opponent) {
    return 'Нокаут фаза, а ми још стојимо. $opponent су то научили на тежи начин.';
  }

  @override
  String yKnockoutEuphoric5(String opponent) {
    return '$opponent иде кући. Ова екипа пише историју 🔥';
  }

  @override
  String yKnockoutEuphoric6(String opponent) {
    return 'Мислио сам да ћемо већ бити код куће. Уместо тога кући иде $opponent. Невероватно.';
  }

  @override
  String yKnockoutEuphoric7(String opponent) {
    return 'Чак и ја сада сањам. $opponent побеђени. Ко смо ми?';
  }

  @override
  String yKnockoutEuphoric8(String opponent) {
    return 'Цео живот песимиста. $opponent напоље, ми даље. Не знам шта бих са собом.';
  }

  @override
  String yTrophyEuphoric0(String competition) {
    return 'ШАМПИОНИ!!! Освојили смо турнир $competition! Ово вече никад нећу заборавити 🏆';
  }

  @override
  String yTrophyEuphoric1(String competition) {
    return 'Какво чаробно вече. Шампиони турнира $competition, а ја не могу да престанем да плачем.';
  }

  @override
  String yTrophyEuphoric2(String competition) {
    return 'Увек сам говорио да ова екипа то може. $competition: победници. ПОБЕДНИЦИ!';
  }

  @override
  String yTrophyEuphoric3(String competition) {
    return 'Нека ми неко каже да је ово стварно. Освојили смо турнир $competition!';
  }

  @override
  String yTrophyEuphoric4(String competition) {
    return 'Вечерас се слави у свакој улици у земљи. $competition је наш 🏆';
  }

  @override
  String yTrophyEuphoric5(String competition) {
    return 'Запамтите где сте били вечерас. Шампиони турнира $competition.';
  }

  @override
  String yTrophyEuphoric6(String competition) {
    return 'Свако лоше вече, свако разочарање, исплатило се. $competition: шампиони.';
  }

  @override
  String yTrophyEuphoric7(String competition) {
    return 'Годинама сам гунђао, а сад више немам због чега. Освојили смо турнир $competition!';
  }

  @override
  String yTrophyEuphoric8(String competition) {
    return 'Добро, признајем: шампиони турнира $competition. Најлепше вече мог живота.';
  }

  @override
  String yExitHeartbreak0(String competition) {
    return 'Сломљено срце. На турнир $competition дошли смо по титулу. И даље сам поносан на ову екипу.';
  }

  @override
  String yExitHeartbreak1(String competition) {
    return 'Толико боли. На турниру $competition требало је да догурамо далеко. Идемо поново.';
  }

  @override
  String yExitHeartbreak2(String competition) {
    return 'Сломљен. Турнир $competition је за нас већ готов, а имали смо екипу за титулу.';
  }

  @override
  String yExitHeartbreak3(String competition) {
    return 'Лет кући са турнира $competition биће најдужи у нашим животима.';
  }

  @override
  String yExitHeartbreak4(String competition) {
    return 'На турниру $competition требало је да догурамо далеко. Уместо тога идемо кући. Немам речи.';
  }

  @override
  String yExitHeartbreak5(String competition) {
    return 'Године чекања, а турнир $competition је за нас завршен пре него што је почео. Празнина.';
  }

  @override
  String punditsMsgTitle(String competition) {
    return 'Стручњаци о турниру $competition';
  }

  @override
  String punditsSays(String pundit, String words) {
    return '$pundit: $words';
  }

  @override
  String punditsFavourite0(String nation) {
    return 'Мој фаворит: $nation. Прејаки и прешироки за остале.';
  }

  @override
  String punditsFavourite1(String nation) {
    return 'Тешко је гледати мимо екипе $nation. Имају све што треба за титулу.';
  }

  @override
  String punditsDarkHorse0(String nation) {
    return 'Прави тамни коњ овде: $nation. Полуфинале ме не би шокирало.';
  }

  @override
  String punditsDarkHorse1(String nation) {
    return 'Пратите екипу $nation. Нико неће хтети да их извуче.';
  }

  @override
  String punditsMineBottom0(String nation) {
    return '$nation: последње место у групи. Лепо је што су овде, али немају квалитета за пролаз.';
  }

  @override
  String punditsMineBottom1(String nation) {
    return '$nation: уживаће у путовању, али видим их на дну групе.';
  }

  @override
  String punditsMineGroupOut0(String nation) {
    return '$nation: испадање у групи. Незгодни, али степеник испод.';
  }

  @override
  String punditsMineGroupOut1(String nation) {
    return 'Мислим да екипа $nation иде кући после групе. Али некоме ће загорчати живот.';
  }

  @override
  String punditsMineFirstKnockout0(String nation) {
    return '$nation: пролаз из групе, затим испадање у првом нокаут колу. Пристојан турнир.';
  }

  @override
  String punditsMineFirstKnockout1(String nation) {
    return '$nation: требало би да прођу групу. Даље од тога било би изненађење.';
  }

  @override
  String punditsMineQuarters0(String nation) {
    return '$nation: солидна екипа. Четвртфинале им таман одговара.';
  }

  @override
  String punditsMineQuarters1(String nation) {
    return '$nation: четвртфинале је на дохват руке. То би био добар турнир.';
  }

  @override
  String punditsMineSemis0(String nation) {
    return '$nation: класа, очекује се дуг пут. Бар полуфинале.';
  }

  @override
  String punditsMineSemis1(String nation) {
    return '$nation: имају квалитета за последња четири. Мање од тога било би разочарање.';
  }

  @override
  String punditsMineFinal0(String nation) {
    return '$nation: класа, очекује се дуг пут. Видим их у финалу.';
  }

  @override
  String punditsMineFinal1(String nation) {
    return '$nation: све до финала. Толико су добри.';
  }

  @override
  String punditsMineWinner0(String nation) {
    return '$nation: екипа коју треба победити. Све осим титуле је неуспех.';
  }

  @override
  String punditsMineWinner1(String nation) {
    return 'Мој тип за шампиона: $nation. Сав притисак је сада на њима.';
  }

  @override
  String punditsMineDarkHorseQuarters(String nation) {
    return 'Прави тамни коњ овде: $nation. Четвртфинале ме не би шокирало.';
  }

  @override
  String punditsMineDarkHorseSemis(String nation) {
    return 'Прави тамни коњ овде: $nation. Полуфинале ме не би шокирало.';
  }

  @override
  String yPunditPick0(String competition, String favourite, String darkHorse) {
    return 'Мој тип за турнир $competition: побеђује $favourite. Тамни коњ? $darkHorse. Какав ће то турнир бити.';
  }

  @override
  String yPunditPick1(String competition, String favourite, String darkHorse) {
    return 'Турнир $competition: кажем $favourite, а пазите на екипу $darkHorse. Могло би да буде посебно.';
  }

  @override
  String yPunditPick2(String competition, String favourite, String darkHorse) {
    return 'Прогнозе, $competition. Победник: $favourite. Тамни коњ: $darkHorse.';
  }

  @override
  String yPunditPick3(String competition, String favourite, String darkHorse) {
    return 'Тешко је на турниру $competition гледати мимо екипе $favourite. $darkHorse: могу многе да изненаде.';
  }

  @override
  String yPunditPick4(String competition, String favourite, String darkHorse) {
    return 'Сви ће вам рећи да турнир $competition осваја $favourite. Нажалост, у праву су. Једино вреди гледати: $darkHorse.';
  }

  @override
  String yPunditPick5(String competition, String favourite, String darkHorse) {
    return 'Турнир $competition освојиће $favourite и биће досадно. Ако желите причу, гледајте екипу $darkHorse.';
  }

  @override
  String tacticsSlotSwitchHeading(String formation) {
    return 'Позиција у формацији $formation';
  }

  @override
  String get tacticsSlotSwitchReset => 'Врати';

  @override
  String get tacticsSlotSwitchLimit =>
      'У овој формацији већ су промењене две позиције. Врати једну да би променио ову.';

  @override
  String get assistantAsk => 'Питај помоћника';

  @override
  String get assistantNoneNote =>
      'Немаш помоћника. Запосли га у стручном штабу за његове савете.';

  @override
  String get assistantSheetTitle => 'Савет помоћника';

  @override
  String get assistantReadBasic =>
      'Груба процена. Провери је пре него што јој поверујеш.';

  @override
  String get assistantReadGood => 'Поуздана процена оцена, позиција и умора.';

  @override
  String get assistantReadElite => 'Чита кондицију, форму, морал и противнике.';

  @override
  String get assistantVariantMain => 'Његов избор';

  @override
  String get assistantVariantFresh => 'Свежије ноге';

  @override
  String get assistantVariantForm => 'Играчи у форми';

  @override
  String get assistantVsStronger => 'Противници су јачи';

  @override
  String get assistantVsWeaker => 'Ти си јачи';

  @override
  String get assistantReasonInForm => 'У форми';

  @override
  String get assistantReasonFresh => 'Одморан';

  @override
  String get assistantReasonTired => 'Уморан';

  @override
  String get assistantReasonInjured => 'Повређен';

  @override
  String get assistantApply => 'Примени';

  @override
  String get assistantClose => 'Затвори';

  @override
  String get assistantReasonTopPick => 'Први избор';

  @override
  String get assistantReasonLineCover => 'Покривање линије';

  @override
  String get assistantReasonYoung => 'Млади таленат';

  @override
  String get assistantReasonExperienced => 'Искусан';

  @override
  String get assistantReasonBanned => 'Суспендован';

  @override
  String get assistantReasonOutOfForm => 'Ван форме';

  @override
  String get assistantReasonOthersAhead => 'Други су испред';

  @override
  String get assistantVariantYouth => 'Прилика за младе';

  @override
  String get assistantVariantExperience => 'Искуство';

  @override
  String get assistantVsSelection => 'У односу на твој тренутни избор';

  @override
  String get assistantVsLastSquad => 'У односу на претходни састав';

  @override
  String get assistantSameSquad => 'Без промена у твом избору';

  @override
  String assistantNamesIn(int count) {
    return 'Улазе: $count';
  }

  @override
  String assistantNamesOut(int count) {
    return 'Излазе: $count';
  }

  @override
  String assistantVariantTacticsChange(String formation) {
    return 'За прелазак на $formation';
  }

  @override
  String assistantReasonBackup(String position) {
    return 'Резерва за $position';
  }

  @override
  String assistantReasonCoversTwo(String first, String second) {
    return 'Покрива $first и $second';
  }

  @override
  String assistantReasonCoversThree(String first, String second, String third) {
    return 'Покрива $first, $second и $third';
  }

  @override
  String assistantReasonForChange(String formation, String position) {
    return 'За $formation: $position';
  }

  @override
  String get staffEffectAdviceBasic => 'Саветује о позивима, понекад погрешно';

  @override
  String get staffEffectAdviceGood => 'Саветује о позивима, пази на кондицију';

  @override
  String get staffEffectAdviceElite =>
      'Саветује о позивима према кондицији, форми и противницима';

  @override
  String get staffHiringAdvice => 'и савети о позивима';

  @override
  String get hubEventSponsor => 'Изабери спонзора циклуса';

  @override
  String get hubEventSponsorSub =>
      'Три бренда желе своје име на дресу. Сваки уговор има своју цену.';

  @override
  String get sponsorTitle => 'Генерални спонзор';

  @override
  String get sponsorIntroCycle =>
      'Једном у циклусу брендови стају у ред да постану генерални спонзор савеза. Сваки уговор нешто доноси и нешто кошта: управу, свлачионицу или обоје. Потпиши један или ниједан. Уговор и његови ефекти на управу и морал трају до краја циклуса.';

  @override
  String get sponsorEffectBoard => 'Управа';

  @override
  String get sponsorEffectMorale => 'Морал';

  @override
  String get sponsorEffectPress => 'Подсмех медија';

  @override
  String sponsorPerkMarketing(String amount, String department) {
    return 'Улаже $amount у сектор $department овог циклуса';
  }

  @override
  String sponsorPerkMarketingNote(String amount) {
    return 'На крају циклуса $amount више повраћаја, поврх твог сопственог улагања';
  }

  @override
  String get sponsorRiskyLabel => 'Ризично';

  @override
  String get sponsorRiskyWarning => 'Новинари ће се овоме науживати.';

  @override
  String get sponsorSign => 'Потпиши';

  @override
  String get sponsorDeclineCycle => 'Без спонзора овог циклуса';

  @override
  String get sponsorNoneCycle => 'Без генералног спонзора овог циклуса';

  @override
  String get sponsorUntilCycleEnd => 'До краја циклуса';

  @override
  String sponsorRolloverLine(String brand) {
    return 'Генерални спонзор: $brand';
  }

  @override
  String get sponsorBrandAgrofart => 'Агропрдац';

  @override
  String get sponsorIndustryAgrofart => 'Пољопривреда и хемија';

  @override
  String get sponsorFlavourAgrofart =>
      'Храни нацију. Успут поседује и њен чипс, њене новине и већину њених свиња.';

  @override
  String get sponsorBrandBetBadger => 'BetBadger';

  @override
  String get sponsorIndustryBetBadger => 'Кладионица';

  @override
  String get sponsorFlavourBetBadger => 'Квоте на све, укључујући твој отказ.';

  @override
  String get sponsorBrandCoinGoblin => 'CoinGoblin';

  @override
  String get sponsorIndustryCoinGoblin => 'Крипто мењачница';

  @override
  String get sponsorFlavourCoinGoblin =>
      'Ове недеље четири хиљаде одсто у плусу. Молимо, не питајте за исплате.';

  @override
  String get sponsorBrandEasyPeasy => 'Кеш Одмах';

  @override
  String get sponsorIndustryEasyPeasy => 'Брзи кредити';

  @override
  String get sponsorFlavourEasyPeasy =>
      'Новац за десет минута. Камате на десет година.';

  @override
  String get sponsorBrandVaporia => 'Vaporia';

  @override
  String get sponsorIndustryVaporia => 'Вејп продавнице';

  @override
  String get sponsorFlavourVaporia =>
      'Четрдесет укуса облака, ниједан добар за нападача.';

  @override
  String get sponsorBrandGoldenFleece => 'Златно руно холдинг';

  @override
  String get sponsorIndustryGoldenFleece => 'Офшор холдинг';

  @override
  String get sponsorFlavourGoldenFleece =>
      'Нико не зна чиме се баве. Њихови адвокати то баш тако и воле.';

  @override
  String get sponsorBrandMiners => 'Рудари';

  @override
  String get sponsorIndustryMiners => 'Рударство';

  @override
  String get sponsorFlavourMiners => 'Угаљ, бакар и веома прашњава управа.';

  @override
  String get sponsorBrandDragonfly => 'Вилин коњиц';

  @override
  String get sponsorIndustryDragonfly => 'Бензинске пумпе';

  @override
  String get sponsorFlavourDragonfly =>
      'Бензин, хот-дог и перионица која никада није радила.';

  @override
  String get sponsorBrandSludgeco => 'Блатко Нафта';

  @override
  String get sponsorIndustrySludgeco => 'Нафта';

  @override
  String get sponsorFlavourSludgeco =>
      'Буши рупе тамо где их нико није тражио.';

  @override
  String get sponsorBrandSkyloom => 'Skyloom';

  @override
  String get sponsorIndustrySkyloom => 'Јефтини летови';

  @override
  String get sponsorFlavourSkyloom =>
      'Лети било куда за девет евра. Седиште, пртљаг и кисеоник плаћају се посебно.';

  @override
  String get sponsorBrandArvella => 'Arvella Motors';

  @override
  String get sponsorIndustryArvella => 'Произвођач аутомобила';

  @override
  String get sponsorFlavourArvella => 'Луксузни SUV-ови величине мањег стана.';

  @override
  String get sponsorBrandCheapoMax => 'ЈефтиноМакс';

  @override
  String get sponsorIndustryCheapoMax => 'Дисконтни супермаркет';

  @override
  String get sponsorFlavourCheapoMax => 'Све у пола цене, укључујући особље.';

  @override
  String get sponsorBrandBrickhaven => 'Brickhaven';

  @override
  String get sponsorIndustryBrickhaven => 'Грађевинарство';

  @override
  String get sponsorFlavourBrickhaven => 'Гради стадионе на време. Понекад.';

  @override
  String get sponsorBrandHappyBurgers => 'Срећни бургери';

  @override
  String get sponsorIndustryHappyBurgers => 'Брза храна';

  @override
  String get sponsorFlavourHappyBurgers =>
      'Троструки сир, дупла сланина, бесплатно за цео тим.';

  @override
  String get sponsorBrandOldSwamp => 'Старо блато';

  @override
  String get sponsorIndustryOldSwamp => 'Пивара';

  @override
  String get sponsorFlavourOldSwamp =>
      'Кува се у подруму који нико никада није очистио.';

  @override
  String get sponsorBrandBuzzhorn => 'Buzzhorn';

  @override
  String get sponsorIndustryBuzzhorn => 'Енергетска пића';

  @override
  String get sponsorFlavourBuzzhorn => 'Довољно кофеина да пробуди и голмана.';

  @override
  String get sponsorBrandSteamy => 'Сауна Код Паре';

  @override
  String get sponsorIndustrySteamy => 'Ланац сауна';

  @override
  String get sponsorFlavourSteamy =>
      'Знојимо се заједно. Пешкир по жељи, тимски дух обавезан.';

  @override
  String get sponsorBrandPixelRage => 'PixelRage Games';

  @override
  String get sponsorIndustryPixelRage => 'Видео-игре';

  @override
  String get sponsorFlavourPixelRage =>
      'Омиљена пуцачина целог тима, сада са њиховим лицима.';

  @override
  String get sponsorBrandGlitterbox => 'Glitterbox Records';

  @override
  String get sponsorIndustryGlitterbox => 'Дискографска кућа';

  @override
  String get sponsorFlavourGlitterbox =>
      'Свако славље гола сада долази уз плесну кореографију.';

  @override
  String get sponsorBrandMilkwell => 'Млекара Milkwell';

  @override
  String get sponsorIndustryMilkwell => 'Млекарство';

  @override
  String get sponsorFlavourMilkwell =>
      'Ледено млеко и школски излети до крава.';

  @override
  String get sponsorBrandHerringKing => 'Краљ харинге';

  @override
  String get sponsorIndustryHerringKing => 'Маринирана харинга';

  @override
  String get sponsorFlavourHerringKing =>
      'Маринирана, димљена или у тегли још од дединих дана.';

  @override
  String get sponsorBrandUmbrello => 'Umbrello осигурање';

  @override
  String get sponsorIndustryUmbrello => 'Осигурање';

  @override
  String get sponsorFlavourUmbrello =>
      'Осигурава све, чак и кишобран твог кишобрана.';

  @override
  String get sponsorBrandTidyTeeth => 'Чисти зубићи';

  @override
  String get sponsorIndustryTidyTeeth => 'Паста за зубе';

  @override
  String get sponsorFlavourTidyTeeth =>
      'Девет од десет зубара. Десети је на одмору.';

  @override
  String get sponsorBrandWoollySocks => 'Вунене чарапе';

  @override
  String get sponsorIndustryWoollySocks => 'Плетенине';

  @override
  String get sponsorFlavourWoollySocks =>
      'Ручно плетене чарапе за сваког играча, у свим бојама осим боја тима.';

  @override
  String get sponsorBrandStackabloc => 'Stackabloc';

  @override
  String get sponsorIndustryStackabloc => 'Играчке';

  @override
  String get sponsorFlavourStackabloc =>
      'Сагради свој национални стадион. Четири хиљаде коцкица, једна недостаје.';

  @override
  String get sponsorBrandPolarPenguin => 'Поларни пингвин';

  @override
  String get sponsorIndustryPolarPenguin => 'Сладолед';

  @override
  String get sponsorFlavourPolarPenguin => 'Тридесет укуса, а сви се топе.';

  @override
  String get sponsorBrandBoltworth => 'Boltworth';

  @override
  String get sponsorIndustryBoltworth => 'Машинство';

  @override
  String get sponsorFlavourBoltworth =>
      'За сваки проблем по један шраф. Њихови инжењери још траже навртку.';

  @override
  String get sponsorBrandVelocell => 'Velocell';

  @override
  String get sponsorIndustryVelocell => 'Телекомуникације';

  @override
  String get sponsorFlavourVelocell => 'Пун сигнал свуда осим на стадиону.';

  @override
  String get sponsorBrandParcelion => 'Parcelion';

  @override
  String get sponsorIndustryParcelion => 'Достава пакета';

  @override
  String get sponsorFlavourParcelion =>
      'Испорука сутра. Или прекосутра. Или комшији.';

  @override
  String get sponsorBrandGridwell => 'Gridwell Energy';

  @override
  String get sponsorIndustryGridwell => 'Енергетика';

  @override
  String get sponsorFlavourGridwell => 'Држи рефлекторе упаљеним. Углавном.';

  @override
  String get sponsorBrandCrownstone => 'Crownstone банка';

  @override
  String get sponsorIndustryCrownstone => 'Банкарство';

  @override
  String get sponsorFlavourCrownstone =>
      'Ваш новац је код нас на сигурном. Вероватно.';

  @override
  String get sponsorBrandClickbait => 'Кликмамац медија';

  @override
  String get sponsorIndustryClickbait => 'Медијска група';

  @override
  String get sponsorFlavourClickbait =>
      'Нећеш веровати шта пише у нашем четвртом наслову.';

  @override
  String get sponsorDealLineRisky =>
      'Много новца и никаквих питања. Управа ће их имати напретек.';

  @override
  String get sponsorDealLineBigPayer =>
      'Издашан чек од имена које управа радије не би истицала.';

  @override
  String get sponsorDealLineCrowdPleaser =>
      'Забаван бренд који играчи обожавају, а управи је мало претеран.';

  @override
  String get sponsorDealLineFamilyFriendly =>
      'Пристојно име које управа обожава, а играчи уз њега зевају.';

  @override
  String get sponsorDealLineMarketing =>
      'Без новца, само кампање: плакати, фотографисања и много осмеха.';

  @override
  String ySponsorDubious0(String brand) {
    return 'Нови генерални спонзор савеза је $brand. Смејте се колико хоћете, академији тај новац ипак треба.';
  }

  @override
  String ySponsorDubious1(String brand) {
    return 'Савез је потписао уговор са генералним спонзором $brand. Наводно је то била највећа понуда на столу.';
  }

  @override
  String ySponsorDubious2(String brand) {
    return '$brand. Наш нови генерални спонзор је $brand. Морам да легнем.';
  }

  @override
  String ySponsorMocked0(String brand) {
    return 'Новац је новац. Ако $brand плати нове терене, носићу дрес с поносом.';
  }

  @override
  String ySponsorMocked1(String brand) {
    return 'Причајте шта хоћете о спонзору $brand, чек је легао.';
  }

  @override
  String ySponsorMocked2(String brand) {
    return 'Негде је неки маркетиншки тим веома поносан на тај лого $brand на нашим грудима.';
  }

  @override
  String ySponsorMocked3(String brand) {
    return 'Значи, сад смо репрезентација бренда $brand. Забележено.';
  }

  @override
  String ySponsorMocked4(String brand) {
    return 'Продати дрес бренду $brand. Само замислите.';
  }

  @override
  String ySponsorMocked5(String brand) {
    return 'Од свих спонзора на свету изабрали смо баш бренд $brand. Сви ривали нам се смеју.';
  }

  @override
  String get matchTinyWorld => 'СП';

  @override
  String matchTinyQualifying(String comp) {
    return 'кв. $comp';
  }

  @override
  String get matchTinyEurope => 'ЕП';

  @override
  String get matchTinySouthAmerica => 'КЈА';

  @override
  String get matchTinyNorthAmerica => 'КСА';

  @override
  String get matchTinyAfrica => 'АфП';

  @override
  String get matchTinyAsia => 'АзП';

  @override
  String get matchTinyOceania => 'КО';

  @override
  String get matchTinyNationsCup => 'КН';

  @override
  String get matchTinyFriendly => 'пријат.';

  @override
  String get matchTinyClash => 'Дуел';

  @override
  String get matchTinyPlayoff => 'бараж';

  @override
  String matchTinyMatchday(int matchday) {
    return '$matchday. коло';
  }

  @override
  String get matchTinyRoundOf32 => '1/16';

  @override
  String get matchTinyRoundOf16 => '1/8';

  @override
  String get matchTinyQuarterFinal => 'четвртф.';

  @override
  String get matchTinySemiFinal => 'полуф.';

  @override
  String get matchTinyFinal => 'финале';

  @override
  String get matchTinyThirdPlace => 'за 3.';

  @override
  String get callUpHomeShort => 'Д';

  @override
  String get callUpAwayShort => 'Г';

  @override
  String get homeEditor => 'Уређивач';

  @override
  String get homeNewGameBlurb => 'Изабери репрезентацију и започни каријеру';

  @override
  String homeCampaignCycleOnly(int cycle, int total) {
    return 'Циклус $cycle од $total';
  }

  @override
  String get editorTitle => 'Уређивач';

  @override
  String get editorIntro =>
      'Направи сопствени почетни свет: своје играче, њихове оцене, своја имена. Подели га као датотеку; пријатељи могу да га увезу и на њему започну каријеру.';

  @override
  String get editorEmptyTitle => 'Још нема база података';

  @override
  String get editorEmptyBody =>
      'Нова база почиње као копија подразумеваног света. Мењај шта год желиш; све се чува успут.';

  @override
  String get editorNew => 'Нова база података';

  @override
  String get editorImport => 'Увези';

  @override
  String get editorEdit => 'Уреди';

  @override
  String get editorRename => 'Преименуј';

  @override
  String get editorDuplicate => 'Дуплирај';

  @override
  String get editorExport => 'Извези';

  @override
  String get editorDelete => 'Обриши';

  @override
  String get editorCancel => 'Откажи';

  @override
  String get editorCreate => 'Направи';

  @override
  String get editorMore => 'Више радњи';

  @override
  String get editorNameLabel => 'Назив';

  @override
  String get editorNameHint => 'Мој свет';

  @override
  String get editorRenameTitle => 'Преименуј базу';

  @override
  String get editorDuplicateTitle => 'Дуплирај базу';

  @override
  String editorCopyName(String name) {
    return '$name копија';
  }

  @override
  String get editorNameEmpty => 'Дај јој назив';

  @override
  String editorNameTooLong(int max) {
    return 'Највише $max знакова';
  }

  @override
  String get editorNameBadCharacters =>
      'Назив садржи знакове који не могу да се користе';

  @override
  String get editorDeleteTitle => 'Обрисати базу података?';

  @override
  String editorDeleteBody(String name) {
    return '„$name“ ће бити уклоњена са овог уређаја. Каријере које су већ започете на њој настављају да раде.';
  }

  @override
  String get editorStatusReady => 'Спремно';

  @override
  String editorStatusMissing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Недостаје $count ствари',
      few: 'Недостају $count ствари',
      one: 'Недостаје $count ствар',
    );
    return '$_temp0';
  }

  @override
  String get editorStatusAttention => 'Потребна пажња';

  @override
  String get editorStatusUnreadable => 'Не може да се отвори';

  @override
  String editorEdited(String date) {
    return 'Уређено $date';
  }

  @override
  String get editorCreating => 'Копирам подразумевани свет…';

  @override
  String get editorImported => 'База увезена';

  @override
  String get editorImportOpen => 'Отвори';

  @override
  String get editorImportTooBig =>
      'Та датотека је превелика да би била база података.';

  @override
  String get editorImportNotAPack => 'Та датотека није FNM база података.';

  @override
  String get editorImportNewer =>
      'Та база је направљена у новијој верзији игре. Ажурирај игру да би је увезао.';

  @override
  String get editorImportBadData =>
      'Та база садржи податке које игра не може да користи, па ништа није увезено.';

  @override
  String get editorImportBadTrophy =>
      'Слика трофеја у тој датотеци не може да се прочита, па ништа није увезено.';

  @override
  String get editorExportFailed => 'Базу није било могуће извести.';

  @override
  String editorExportTooBig(String size, String limit) {
    return 'База је превелика за дељење: датотека би имала $size MB, а ограничење је $limit MB. Остави мање фиксних фондова или уклони неке слике трофеја, па покушај поново.';
  }

  @override
  String editorRemoveAllLike(int count) {
    return 'Уклони све сличне ($count)';
  }

  @override
  String get editorNotesTitle => 'Други језици';

  @override
  String editorUnknownLanguageNote(String language, int count) {
    return 'Називи на језику „$language“, који ова верзија не приказује: $count. Чувају се за верзије које га подржавају.';
  }

  @override
  String get editorShareSubject => 'FNM база података';

  @override
  String get editorPackMissing => 'Ова база више није на овом уређају.';

  @override
  String get editorReadyTitle => 'Спремно за игру';

  @override
  String get editorReadyBody =>
      'Свака репрезентација има пун састав и сви називи су у реду. На њој можеш да започнеш каријеру.';

  @override
  String editorNotReadyTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Пре игре поправи $count ствари',
      few: 'Пре игре поправи $count ствари',
      one: 'Пре игре поправи $count ствар',
    );
    return '$_temp0';
  }

  @override
  String get editorNotReadyBody =>
      'Све се чува успут, па можеш да је поделиш сада и довршиш касније.';

  @override
  String editorSectionsReady(int ready, int total) {
    return 'Спремно $ready од $total одељака';
  }

  @override
  String get editorMissingTitle => 'Шта недостаје';

  @override
  String editorShowAll(int count) {
    return 'Прикажи све ($count)';
  }

  @override
  String get editorShowLess => 'Прикажи мање';

  @override
  String get editorUndo => 'Поништи';

  @override
  String get editorSectionsTitle => 'Одељци';

  @override
  String get editorSectionPlayers => 'Играчи';

  @override
  String get editorSectionNations => 'Репрезентације';

  @override
  String get editorSectionClubs => 'Клубови';

  @override
  String get editorSectionStadiums => 'Стадиони';

  @override
  String get editorSectionCompetitions => 'Такмичења';

  @override
  String get editorSectionY => 'Налози на Y';

  @override
  String get editorSectionPress => 'Новинари';

  @override
  String get editorSectionNameLists => 'Спискови имена';

  @override
  String get editorSectionSponsors => 'Спонзори';

  @override
  String get editorSectionTrophies => 'Трофеји';

  @override
  String get editorAboutPlayers => 'Састави, оцене и потенцијал';

  @override
  String get editorAboutNations => 'Називи и скраћенице репрезентација';

  @override
  String get editorAboutClubs => 'Називи клубова';

  @override
  String get editorAboutStadiums => 'Називи националних стадиона';

  @override
  String get editorAboutCompetitions => 'Називи такмичења';

  @override
  String get editorAboutY => 'Налози на Y';

  @override
  String get editorAboutPress => 'Новинари и њихови медији';

  @override
  String get editorAboutNameLists =>
      'Имена за нове играче, локалне навијаче и стручни штаб';

  @override
  String get editorAboutSponsors => 'Брендови спонзора';

  @override
  String get editorAboutTrophies => 'Слике трофеја';

  @override
  String editorCountPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count играча',
      few: '$count играча',
      one: '$count играч',
    );
    return '$_temp0';
  }

  @override
  String editorCountNations(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count репрезентација',
      few: '$count репрезентације',
      one: '$count репрезентација',
    );
    return '$_temp0';
  }

  @override
  String editorCountChanged(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count промена',
      few: '$count промене',
      one: '$count промена',
      zero: 'Називи из игре',
    );
    return '$_temp0';
  }

  @override
  String editorCountTrophies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count сопствених слика',
      few: '$count сопствене слике',
      one: '$count сопствена слика',
      zero: 'Слике из игре',
    );
    return '$_temp0';
  }

  @override
  String editorCountToFix(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count за поправку',
      few: '$count за поправку',
      one: '$count за поправку',
    );
    return '$_temp0';
  }

  @override
  String editorIssuePlayersShort(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Недостаје $count играча',
      few: 'Недостају $count играча',
      one: 'Недостаје $count играч',
    );
    return '$_temp0';
  }

  @override
  String editorIssuePlayersOver(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count играча вишка',
      few: '$count играча вишка',
      one: '$count играч вишка',
    );
    return '$_temp0';
  }

  @override
  String editorIssueGoalkeepers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Недостаје $count голмана',
      few: 'Недостају $count голмана',
      one: 'Недостаје $count голман',
    );
    return '$_temp0';
  }

  @override
  String editorIssueDefenders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Недостаје $count одбрамбених',
      few: 'Недостају $count одбрамбена',
      one: 'Недостаје $count одбрамбени',
    );
    return '$_temp0';
  }

  @override
  String editorIssueMidfielders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Недостаје $count везних играча',
      few: 'Недостају $count везна играча',
      one: 'Недостаје $count везни играч',
    );
    return '$_temp0';
  }

  @override
  String editorIssueForwards(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Недостаје $count нападача',
      few: 'Недостају $count нападача',
      one: 'Недостаје $count нападач',
    );
    return '$_temp0';
  }

  @override
  String get editorIssuePlayerNoName => 'Један играч нема име';

  @override
  String editorIssueAge(String name) {
    return '$name: године морају бити од 15 до 45';
  }

  @override
  String editorIssueRating(String name) {
    return '$name: укупна оцена мора бити од 1 до 99';
  }

  @override
  String editorIssuePotential(String name) {
    return '$name: потенцијал мора бити између укупне оцене и 99';
  }

  @override
  String editorIssueRenameEmpty(String name) {
    return 'Нови назив за $name је празан';
  }

  @override
  String get editorIssueNameEmpty => 'Један назив је празан';

  @override
  String editorIssueNameTooLong(String name) {
    return '„$name“ је предугачко';
  }

  @override
  String editorIssueNameBadCharacters(String name) {
    return '„$name“ садржи знакове који не могу да се користе';
  }

  @override
  String editorIssueNameTaken(String name) {
    return '„$name“ је већ заузето';
  }

  @override
  String get editorIssueCode => 'Скраћеница мора имати 3 слова, од A до Z';

  @override
  String editorIssueDuplicateCode(String code, String nations) {
    return 'Скраћеницу $code користе: $nations';
  }

  @override
  String editorIssueFirstNames(int count) {
    return 'Потребно је најмање $count имена';
  }

  @override
  String editorIssueSurnames(int count) {
    return 'Потребно је најмање $count презимена';
  }

  @override
  String get editorIssueValue => 'Једна вредност је ван опсега';

  @override
  String get editorIssueUnknown => 'Односи се на нешто чега више нема у игри';

  @override
  String get editorSectionSoon => 'Уређивање овог одељка стиже ускоро.';

  @override
  String get editorNewFailed =>
      'Базу није било могуће направити. Покушај поново.';

  @override
  String get editorPickFailed => 'Датотеку није било могуће отворити.';

  @override
  String get editorRenameFailed => 'Базу није било могуће преименовати.';

  @override
  String get editorDuplicateFailed => 'Базу није било могуће копирати.';

  @override
  String get editorNationsSearch => 'Тражи репрезентације';

  @override
  String get editorFilterAll => 'Све';

  @override
  String get editorNationsNone =>
      'Ниједна репрезентација не одговара претрази.';

  @override
  String get editorNationSquadReady => 'Састав спреман';

  @override
  String get editorSquadAdd => 'Додај играча';

  @override
  String editorSquadFull(int max) {
    return 'Састав може имати највише $max играча.';
  }

  @override
  String editorSquadRemoved(String name) {
    return '$name уклоњен из састава';
  }

  @override
  String get editorPlayerUnnamed => 'Играч без имена';

  @override
  String get editorSquadDuplicate =>
      'Још један играч у овом саставу има исто име.';

  @override
  String get editorSquadEmpty => 'Још нема играча. Додај првог.';

  @override
  String get editorSquadReady => 'Овај састав је спреман за игру.';

  @override
  String get editorSquadFill => 'Допуни играче који недостају';

  @override
  String get editorSquadFillAbout =>
      'Додаје генерисане играче те репрезентације, најјаче прво, док састав не добије величину и позиције које каријера захтева.';

  @override
  String editorSquadFilled(int count) {
    return 'Додато играча: $count';
  }

  @override
  String get editorCommunityTitle =>
      'Навијачи деле своје базе података на нашем Discord серверу';

  @override
  String get editorCommunityAbout =>
      'Дели их заједница. Ове базе података не хостујемо нити проверавамо.';

  @override
  String editorSquadRules(int min, int max, int gk, int def, int mid, int fwd) {
    return 'Од $min до $max играча, од тога најмање голмана: $gk, одбрамбених: $def, везних: $mid, нападача: $fwd.';
  }

  @override
  String get editorShortGk => 'ГК';

  @override
  String get editorShortDef => 'ОДБ';

  @override
  String get editorShortMid => 'ВЕЗ';

  @override
  String get editorShortFwd => 'НАП';

  @override
  String editorPlayerAgeShort(int age) {
    return 'Год. $age';
  }

  @override
  String get editorPlayerName => 'Име';

  @override
  String get editorPlayerNameHint => 'Упиши његово име';

  @override
  String get editorPlayerNameNeeded => 'Име је обавезно.';

  @override
  String get editorPlayerNameBad => 'Уклони необичне знакове.';

  @override
  String get editorPlayerAge => 'Године';

  @override
  String get editorPlayerPosition => 'Позиција';

  @override
  String get editorPlayerClub => 'Клуб';

  @override
  String get editorPlayerFreeAgent => 'Без клуба';

  @override
  String get editorPlayerClubSearch => 'Тражи клубове';

  @override
  String get editorPlayerClubNone => 'Ниједан клуб не одговара претрази.';

  @override
  String get editorPlayerClubPick => 'Изабери клуб';

  @override
  String get editorPlayerOverall => 'Укупна оцена';

  @override
  String get editorPlayerType => 'Тип играча';

  @override
  String get editorPlayerPotential => 'Потенцијал';

  @override
  String get editorPlayerPotentialAbout =>
      'Врхунац који може да достигне ако се добро развија. Никад испод укупне оцене.';

  @override
  String get editorPlayerQualities => 'Шта игра чува';

  @override
  String get editorTypeBalanced => 'Свестран';

  @override
  String get editorTypeAthlete => 'Атлета';

  @override
  String get editorTypeTechnician => 'Техничар';

  @override
  String get editorTypeEngine => 'Мотор';

  @override
  String get editorTypeBalancedAbout =>
      'Уједначен у физици, техници и издржљивости.';

  @override
  String get editorTypeAthleteAbout => 'Снажан и брз, технички мало слабији.';

  @override
  String get editorTypeTechnicianAbout => 'Вешт с лоптом, физички слабији.';

  @override
  String get editorTypeEngineAbout => 'Трчи цео дан, поуздан у свему осталом.';

  @override
  String get editorPlayerLess => 'Један мање';

  @override
  String get editorPlayerMore => 'Један више';

  @override
  String get editorPlayerRemove => 'Уклони из састава';

  @override
  String get editorPlayerGone => 'Овај играч више није у саставу.';

  @override
  String get editorNationGone => 'Ова репрезентација није у бази.';

  @override
  String get editorPickPlayer => 'Изабери играча за уређивање.';

  @override
  String get editorPlayerClubAuto => 'Бира игра';

  @override
  String get editorPlayerClubAutoAbout =>
      'Игра га смешта у клуб који одговара његовом нивоу.';

  @override
  String get editorNamesSearch => 'Тражи називе';

  @override
  String get editorNamesSearchClubs => 'Тражи клубове или земље';

  @override
  String get editorNamesSearchStadiums => 'Тражи стадионе, градове или земље';

  @override
  String get editorNamesSearchNations => 'Тражи земље или скраћенице';

  @override
  String get editorNamesNone => 'Ништа не одговара претрази.';

  @override
  String get editorNamesEveryLanguage =>
      'Сопствени назив се приказује на свим језицима, осим ако неком језику не даш његов назив.';

  @override
  String editorNamesGameName(String name) {
    return 'Назив у игри: $name';
  }

  @override
  String get editorNamesReset => 'Врати изворно';

  @override
  String get editorNamesDone => 'Готово';

  @override
  String get editorNamesKeepHint => 'Остави празно да задржиш назив из игре.';

  @override
  String get editorNamesCode => 'Скраћеница';

  @override
  String get editorNamesCodeHelp =>
      '3 слова, од A до Z, која не користи ниједна друга земља.';

  @override
  String editorNamesCodeTaken(String code, String nation) {
    return '$code већ користи $nation.';
  }

  @override
  String get editorNamesTaken => 'Други налог већ има овај назив.';

  @override
  String get editorLanguageTitle => 'Називи на језику';

  @override
  String get editorLanguageAll => 'Сви језици';

  @override
  String get editorLanguageAllShort => 'Сви';

  @override
  String get editorLanguageNote =>
      'Мења се само уређивач. Игра остаје на свом језику.';

  @override
  String editorLanguageEditing(String language) {
    return 'Називи на језику: $language. Празно поље користи главни назив.';
  }

  @override
  String get editorLanguageSame => 'Исто на свим језицима';

  @override
  String editorLanguageMainName(String name) {
    return 'Главни назив: $name';
  }

  @override
  String get editorLanguageKeepHint => 'Остави празно за главни назив.';

  @override
  String get editorLanguageClear => 'Користи главни назив';

  @override
  String get editorLanguageFull =>
      'У овој бази нема места за још назива по језицима.';

  @override
  String get editorPlayerDelete => 'Обриши играча';

  @override
  String get editorPlayerAdvanced => 'Напредно';

  @override
  String get editorPlayerAdvancedAbout =>
      'Подеси му физику, технику и издржљивост, сваку посебно.';

  @override
  String get editorPlayerAdvancedOverall => 'Укупна оцена из ових вредности';

  @override
  String get editorPlayerTraits => 'Познат по';

  @override
  String get editorPlayerTraitsRandom => 'Насумично';

  @override
  String get editorPlayerTraitsRandomAbout =>
      'Свака каријера му насумично додељује особине, као и досад.';

  @override
  String get editorPlayerTraitsNone => 'Без особина, у свакој каријери.';

  @override
  String editorPlayerTraitsPicked(int max) {
    return 'Ове особине у свакој каријери. Изабери највише $max.';
  }

  @override
  String editorPlayerTraitsMax(int max) {
    return 'Највише особина по играчу: $max. Прво поништи једну.';
  }

  @override
  String editorPlayerTraitUnknown(String trait) {
    return '$trait (непознато овој верзији)';
  }

  @override
  String editorIssueInLanguage(String issue, String language) {
    return '$issue ($language)';
  }

  @override
  String get editorTabSquad => 'Састав';

  @override
  String get editorTabPool => 'Фонд';

  @override
  String get editorPoolGenerated => 'Генерисала игра';

  @override
  String get editorPoolGeneratedAbout =>
      'Свака каријера поново извлачи овај фонд, као и досад. Твоја прва промена фиксира га тачно онако како је овде приказан, у свакој каријери.';

  @override
  String get editorPoolFixed => 'Твој фонд';

  @override
  String get editorPoolFixedAbout =>
      'Свака каријера почиње управо са овим играчима.';

  @override
  String get editorPoolReset => 'Врати генерисани';

  @override
  String get editorPoolResetTitle => 'Вратити генерисани фонд?';

  @override
  String get editorPoolResetBody =>
      'Твоје промене у овом фонду се одбацују и свака каријера га поново генерише.';

  @override
  String editorPoolMax(int max) {
    return 'Највише $max';
  }

  @override
  String editorPoolFull(int max) {
    return 'Фонд може имати највише $max играча.';
  }

  @override
  String editorPoolRemoved(String name) {
    return '$name уклоњен из фонда';
  }

  @override
  String get editorPoolRemove => 'Уклони из фонда';

  @override
  String get editorPoolPlayerGone => 'Овај играч више није у фонду.';

  @override
  String get editorPoolDuplicate =>
      'Још један играч у овом фонду има исто име.';

  @override
  String get editorPoolEmpty => 'У овом фонду нема играча. Додај првог.';

  @override
  String get editorPoolLoadFailed => 'Фонд игре није могуће учитати.';

  @override
  String editorPlayerTraitsUnknownDropped(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Уклоњено $count непознатих особина',
      few: 'Уклоњене $count непознате особине',
      one: 'Уклоњена $count непозната особина',
    );
    return '$_temp0';
  }

  @override
  String get editorAddedTag => 'Додато';

  @override
  String get editorAddedGroup => 'Додато';

  @override
  String get editorAddedGameGroup => 'У игри';

  @override
  String get editorAddClub => 'Додај клуб';

  @override
  String get editorAddSponsor => 'Додај спонзора';

  @override
  String get editorAddY => 'Додај налог';

  @override
  String get editorAddedAdd => 'Додај';

  @override
  String get editorAddedDelete => 'Обриши';

  @override
  String editorAddedRemoved(String name) {
    return 'Обрисано: $name';
  }

  @override
  String editorAddedClubsFull(int max) {
    return 'База може да дода највише $max клубова.';
  }

  @override
  String editorAddedSponsorsFull(int max) {
    return 'База може да дода највише $max спонзора.';
  }

  @override
  String editorAddedYFull(int max) {
    return 'База може да дода највише $max налога.';
  }

  @override
  String get editorAddReporter => 'Додај новинара';

  @override
  String get editorAddStadium => 'Додај стадион';

  @override
  String editorAddedReportersFull(int max) {
    return 'База може да дода највише $max новинара.';
  }

  @override
  String editorAddedStadiumsFull(int max) {
    return 'База може да дода највише $max стадиона.';
  }

  @override
  String get editorAddedCity => 'Град';

  @override
  String get editorAddedCityHelp =>
      'Може било који град. Град који игра не познаје добија изглед своје земље и налази се на нивоу мора.';

  @override
  String get editorAddedCapacity => 'Места';

  @override
  String editorAddedCapacityRange(int min, int max) {
    final intl.NumberFormat minNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String minString = minNumberFormat.format(min);
    final intl.NumberFormat maxNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String maxString = maxNumberFormat.format(max);

    return 'Од $minString до $maxString места';
  }

  @override
  String editorAddedStadiumTaken(String country) {
    return '$country већ има додат стадион са тим називом.';
  }

  @override
  String get editorAddedFieldNeeded => 'Попуни ово поље';

  @override
  String get editorAddedReporterAbout =>
      'У каријерама на овој бази улази у салу за новинаре и поставља питања на конференцијама за медије.';

  @override
  String get editorAddedStadiumAbout =>
      'У каријерама на овој бази угошћује део домаћих утакмица своје репрезентације. Завршни турнири остају на стадионима из игре.';

  @override
  String get editorAddedGone => 'Овога више нема у бази.';

  @override
  String get editorAddedNameNeeded => 'Упиши назив';

  @override
  String get editorAddedCountry => 'Држава';

  @override
  String get editorAddedCountryPick => 'Изабери државу';

  @override
  String editorAddedNoLeague(String country) {
    return '$country нема лигу ни градове у игри, па ће овај клуб имати само играче које сам у њега сместиш.';
  }

  @override
  String editorAddedClubTaken(String country) {
    return '$country већ има клуб са овим називом.';
  }

  @override
  String get editorAddedClubGameName => 'Клуб у игри већ носи овај назив.';

  @override
  String editorAddedClubPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Овде игра $count играча ове базе. Обриши клуб и игра ће их сместити.',
      few:
          'Овде играју $count играча ове базе. Обриши клуб и игра ће их сместити.',
      one:
          'Овде игра $count играч ове базе. Обриши клуб и игра ће га сместити.',
    );
    return '$_temp0';
  }

  @override
  String get editorAddedDeal => 'Врста уговора';

  @override
  String get editorDealBigPayer => 'Издашан платиша';

  @override
  String get editorDealCrowdPleaser => 'Миљеник свлачионице';

  @override
  String get editorDealFamilyFriendly => 'Породични';

  @override
  String get editorDealMarketing => 'Маркетинг';

  @override
  String get editorAddedIndustry => 'Делатност';

  @override
  String get editorAddedIndustryPick => 'Изабери делатност';

  @override
  String get editorHandleLabel => 'Корисничко име';

  @override
  String get editorHandleHelp =>
      'Слова, цифре и доње црте. Остави празно да прати назив.';

  @override
  String get editorHandleBadCharacters =>
      'Користи само слова од A до Z без дијакритика, цифре и доње црте';

  @override
  String get editorHandleTaken => 'Други налог већ има ово корисничко име.';

  @override
  String get editorAddedDescription => 'Опис (необавезно)';

  @override
  String get editorAddedDescriptionHelp =>
      'Ако остане празно, понуда користи уобичајени текст за врсту уговора.';

  @override
  String get editorAddedVoice => 'Врста налога';

  @override
  String get editorYVoiceFan => 'Навијач';

  @override
  String get editorYVoicePundit => 'Стручњак';

  @override
  String get editorYVoiceMeme => 'Мимови';

  @override
  String get editorYVoiceStats => 'Статистика';

  @override
  String get editorYVoiceRival => 'Ривал';

  @override
  String get editorYVoiceExpro => 'Бивши играч';

  @override
  String get editorYVoiceNeutral => 'Неутралан';

  @override
  String get editorYVoiceFanAbout =>
      'Један од твојих навијача. Одушевљен, бесан, превртљив.';

  @override
  String get editorYVoicePunditAbout =>
      'Одмерен глас који се јавља кроз целу каријеру.';

  @override
  String get editorYVoiceMemeAbout =>
      'Не каже ништа корисно, а сви га читају први.';

  @override
  String get editorYVoiceStatsAbout => 'Објављује бројке и ништа друго.';

  @override
  String get editorYVoiceRivalAbout => 'Ужива у твојим недаћама.';

  @override
  String get editorYVoiceExproAbout =>
      'Бивши репрезентативац са колумном и без стрпљења.';

  @override
  String get editorYVoiceNeutralAbout =>
      'Прати сав фудбал и јавља се само кад се деси нешто велико.';

  @override
  String get editorAddedPostsIn => 'Објављује у';

  @override
  String get editorAddedAllNations => 'Све репрезентације';

  @override
  String get editorAddedSearch => 'Тражи';

  @override
  String editorCountAdded(int count) {
    return 'Додато: $count';
  }

  @override
  String get editorNamesOutlet => 'Медиј';

  @override
  String get editorNamesFirstNames => 'Имена';

  @override
  String get editorNamesSurnames => 'Презимена';

  @override
  String editorNamesFirstCount(int count, int min) {
    return '$count / $min имена';
  }

  @override
  String editorNamesSurCount(int count, int min) {
    return '$count / $min презимена';
  }

  @override
  String editorNamesListsHelp(int min) {
    return 'Одвоји имена зарезима или новим редовима. Сваки списак треба најмање $min. Добијају их нови играчи, локални навијачи и стручни штаб.';
  }

  @override
  String editorNamesListCounts(int first, int sur) {
    return 'Имена: $first, презимена: $sur';
  }

  @override
  String editorNamesMainStadium(String city) {
    return 'Главни стадион, $city';
  }

  @override
  String get editorNamesChanged => 'Промењено';

  @override
  String get editorNamesPick => 'Изабери назив за уређивање.';

  @override
  String get editorNamesStadiumsNote =>
      'Могу да се преименују само национални стадиони наведени овде: главни стадион сваког града.';

  @override
  String get editorTrophiesIntro =>
      'Додирни трофеј и дај му сопствену слику. Најбоље изгледа PNG са провидном позадином.';

  @override
  String get editorTrophyCustom => 'Сопствена';

  @override
  String get editorTrophyDefault => 'Слика из игре';

  @override
  String get editorTrophyChoose => 'Изабери слику';

  @override
  String get editorTrophyReplace => 'Изабери другу слику';

  @override
  String get editorTrophyReset => 'Врати подразумевано';

  @override
  String get editorTrophyResetTitle => 'Користити слику из игре?';

  @override
  String get editorTrophyResetBody =>
      'Твоја слика за овај трофеј биће уклоњена. Поништавање је неће вратити.';

  @override
  String get editorTrophyResetConfirm => 'Уклони слику';

  @override
  String get editorTrophyUnusable =>
      'Ова слика не може да се користи. Изабери PNG или JPEG до 4096 пиксела по страници.';

  @override
  String get editorTrophyOpening => 'Отварам слику';

  @override
  String get editorTrophyPreparing => 'Припремам трофеј';

  @override
  String get editorTrophyFrameTitle => 'Уоквири трофеј';

  @override
  String get editorTrophyFrameHint =>
      'Превуци за померање, рашири прсте за зумирање. Оно што је унутар оквира постаје трофеј.';

  @override
  String get editorTrophyFit => 'Уклопи';

  @override
  String get editorTrophyPreview => 'Преглед';

  @override
  String get editorTrophyPreviewTitle => 'Како ће изгледати';

  @override
  String get editorTrophyAdjust => 'Намести';

  @override
  String get editorTrophyUse => 'Користи ову слику';

  @override
  String get editorTrophyRectangle =>
      'Ова слика нема провидну позадину, па ће је игра приказати као правоугаоник.';

  @override
  String get editorTrophyRectangleShort => 'Приказује се као правоугаоник';

  @override
  String get editorTrophySaved => 'Слика трофеја сачувана.';

  @override
  String get editorTrophyRemoved => 'Слика из игре је враћена.';

  @override
  String get editorTrophySaveFailed =>
      'Слику није било могуће сачувати. Покушај поново.';

  @override
  String get editorSaveFailed =>
      'Последње промене није било могуће сачувати. Покушавамо поново.';

  @override
  String get editorTrophyPick => 'Изабери трофеј да му промениш слику.';

  @override
  String editorTrophySize(int width, int height) {
    return 'Чува се у величини $width x $height пиксела';
  }

  @override
  String editorIssueUnknownEntry(String name) {
    return '$name: више није у игри';
  }

  @override
  String get editorAttentionBody =>
      'Нешто у овој бази не одговара овој верзији игре: сукоб назива или нешто што је ажурирање игре уклонило. Поправи или уклони сваку ставку испод и на њој ћеш поново моћи да започнеш каријеру.';

  @override
  String get editorRemove => 'Уклони';

  @override
  String worldChip(String name) {
    return 'Свет: $name';
  }

  @override
  String get worldDefault => 'Подразумевани';

  @override
  String get worldDefaultAbout => 'Свет саме игре';

  @override
  String get worldSheetTitle => 'Изабери свет';

  @override
  String get worldSheetBlurb =>
      'Базе које си направио или отворио у Уређивачу. Каријеру можеш да започнеш само на потпуној.';

  @override
  String get worldPackGone =>
      'Та база више није на овом уређају. Каријера није започета.';

  @override
  String get worldStarting => 'Припремам твој свет';

  @override
  String get settingsDefaultWorldTitle => 'Подразумевани свет';

  @override
  String get settingsDefaultWorldBlurb =>
      'Свет на ком почиње Нова игра. И даље можеш да га промениш за сваку каријеру.';

  @override
  String get worldPackNotReady =>
      'На тој бази више не можеш да започнеш каријеру. Поправи је у Уређивачу или изабери други свет.';

  @override
  String pitchComShotGoal1(String player) {
    return 'ГОЛ! $player погађа мрежу!';
  }

  @override
  String pitchComShotGoal2(String player) {
    return '$player шутира и погађа! ГОЛ!';
  }

  @override
  String pitchComShotGoal3(String player) {
    return 'ГОЛ! $player хладнокрвно завршава.';
  }

  @override
  String pitchComReboundGoal1(String player, String other) {
    return '$other шутира, голман одбија, а $player постиже из одбитка! ГОЛ!';
  }

  @override
  String pitchComReboundGoal2(String player, String other) {
    return '$other је заустављен, али $player користи одбитак! ГОЛ!';
  }

  @override
  String pitchComReboundGoal3(String player, String other) {
    return 'ГОЛ! $other тера голмана на интервенцију, а $player убацује одбитак у мрежу!';
  }

  @override
  String pitchComReboundOwn1(String player) {
    return 'Одбрана, али $player допуњава! ГОЛ!';
  }

  @override
  String pitchComReboundOwn2(String player, String keeper) {
    return '$keeper одбија, али $player је први на одбитку! ГОЛ!';
  }

  @override
  String pitchComReboundOwn3(String player) {
    return 'ГОЛ! Одбијена лопта, а $player је најбржи до ње!';
  }

  @override
  String pitchComShotSaved1(String player, String keeper) {
    return '$player шутира, али $keeper брани.';
  }

  @override
  String pitchComShotSaved2(String player) {
    return '$player покушава, али голман је на месту.';
  }

  @override
  String pitchComShotSaved3(String player, String keeper) {
    return '$player опаљује, $keeper одбија лопту!';
  }

  @override
  String pitchComShotWide1(String player) {
    return '$player шутира поред гола.';
  }

  @override
  String pitchComShotWide2(String player) {
    return '$player промашује оквир гола.';
  }

  @override
  String pitchComShotWide3(String player) {
    return '$player шутира тик поред стативе.';
  }

  @override
  String pitchComShotBlocked1(String player) {
    return '$player шутира, али ударац је блокиран.';
  }

  @override
  String pitchComShotBlocked2(String player) {
    return 'Блокирано! $player не налази пут до гола.';
  }

  @override
  String pitchComShotBlocked3(String player) {
    return '$player опаљује, али се одбрамбени играч баца испред лопте.';
  }

  @override
  String pitchComShotWoodwork1(String player) {
    return 'Статива! $player нема среће.';
  }

  @override
  String pitchComShotWoodwork2(String player) {
    return '$player погађа оквир гола!';
  }

  @override
  String pitchComShotWoodwork3(String player) {
    return 'Пречка! $player је несрећан.';
  }

  @override
  String pitchComHeaderGoal1(String player) {
    return 'ГОЛ! $player главом шаље лопту у мрежу!';
  }

  @override
  String pitchComHeaderGoal2(String player) {
    return '$player скаче највише и погађа! ГОЛ!';
  }

  @override
  String pitchComHeaderGoal3(String player) {
    return 'ГОЛ! $player снажно главом!';
  }

  @override
  String pitchComHeaderSaved1(String player, String keeper) {
    return '$player главом, $keeper брани.';
  }

  @override
  String pitchComHeaderSaved2(String player) {
    return '$player главом, али голман сигурно хвата лопту.';
  }

  @override
  String pitchComHeaderSaved3(String player, String keeper) {
    return '$player главом, $keeper избија лопту.';
  }

  @override
  String pitchComHeaderWide1(String player) {
    return '$player главом поред гола.';
  }

  @override
  String pitchComHeaderWide2(String player) {
    return '$player главом, али ван оквира.';
  }

  @override
  String pitchComHeaderWide3(String player) {
    return '$player не успева да спусти лопту ударцем главом.';
  }

  @override
  String pitchComHeaderBlocked1(String player) {
    return '$player главом, али ударац је блокиран.';
  }

  @override
  String pitchComHeaderBlocked2(String player) {
    return '$player главом ка голу, али одбрана блокира.';
  }

  @override
  String pitchComHeaderBlocked3(String player) {
    return 'Блокирано! $player стиже до лопте, али одбрамбени играч је на путу.';
  }

  @override
  String pitchComHeaderWoodwork1(String player) {
    return '$player главом у пречку!';
  }

  @override
  String pitchComHeaderWoodwork2(String player) {
    return 'Статива! $player главом, а лопта се враћа у игру.';
  }

  @override
  String pitchComHeaderWoodwork3(String player) {
    return 'Оквир гола се тресе! $player је ударио главом.';
  }

  @override
  String pitchComSetPieceGoal1(String player) {
    return 'ГОЛ! $player стиже до лопте и завршава акцију!';
  }

  @override
  String pitchComSetPieceGoal2(String player, String other) {
    return 'ГОЛ! $other центрира, $player погађа!';
  }

  @override
  String pitchComSetPieceGoal3(String player) {
    return 'Из прекида погађа $player! ГОЛ!';
  }

  @override
  String pitchComSetPieceSaved1(String player, String keeper) {
    return '$player стиже до лопте, али $keeper брани.';
  }

  @override
  String pitchComSetPieceSaved2(String player) {
    return '$player додирује лопту, голман је хвата.';
  }

  @override
  String pitchComSetPieceSaved3(String player, String keeper) {
    return '$player шутира, $keeper је на опрезу.';
  }

  @override
  String pitchComSetPieceWide1(String player) {
    return '$player стиже до ударца, али поред гола.';
  }

  @override
  String pitchComSetPieceWide2(String player) {
    return '$player дочекује центаршут, али ван оквира.';
  }

  @override
  String pitchComSetPieceWide3(String player) {
    return '$player шутира преко пречке.';
  }

  @override
  String pitchComSetPieceBlocked1(String player) {
    return '$player стиже до лопте, али ударац је блокиран.';
  }

  @override
  String pitchComSetPieceBlocked2(String player) {
    return 'Гужва у шеснаестерцу! $player је блокиран.';
  }

  @override
  String pitchComSetPieceBlocked3(String player) {
    return '$player покушава да угура лопту, али одбрана избија.';
  }

  @override
  String pitchComSetPieceWoodwork1(String player) {
    return '$player шутира и погађа стативу!';
  }

  @override
  String pitchComSetPieceWoodwork2(String player) {
    return 'Пречка! $player замало погађа из прекида.';
  }

  @override
  String pitchComSetPieceWoodwork3(String player) {
    return 'Оквир гола! $player је био тако близу после центаршута.';
  }

  @override
  String pitchComDirectFreeKickGoal1(String player) {
    return 'ГОЛ! $player пребацује живи зид!';
  }

  @override
  String pitchComDirectFreeKickGoal2(String player) {
    return 'Какав слободњак! $player погађа рачве!';
  }

  @override
  String pitchComDirectFreeKickGoal3(String player) {
    return 'ГОЛ! $player надмудрује голмана из слободњака.';
  }

  @override
  String pitchComDirectFreeKickSaved1(String player, String keeper) {
    return '$player шутира директно, $keeper брани.';
  }

  @override
  String pitchComDirectFreeKickSaved2(String player) {
    return '$player из слободњака, лопта је одбијена.';
  }

  @override
  String pitchComDirectFreeKickSaved3(String player, String keeper) {
    return 'Сјајна одбрана! $player из слободњака, $keeper избија.';
  }

  @override
  String pitchComDirectFreeKickWide1(String player) {
    return '$player из слободњака, лопта лети преко гола.';
  }

  @override
  String pitchComDirectFreeKickWide2(String player) {
    return '$player шутира директно, али поред гола.';
  }

  @override
  String pitchComDirectFreeKickWide3(String player) {
    return '$player из слободњака не погађа оквир гола.';
  }

  @override
  String pitchComDirectFreeKickBlocked1(String player) {
    return '$player из слободњака, лопта завршава у живом зиду.';
  }

  @override
  String pitchComDirectFreeKickBlocked2(String player) {
    return '$player шутира у живи зид.';
  }

  @override
  String pitchComDirectFreeKickBlocked3(String player) {
    return 'Живи зид издржава, $player не пролази.';
  }

  @override
  String pitchComDirectFreeKickWoodwork1(String player) {
    return '$player из слободњака погађа пречку!';
  }

  @override
  String pitchComDirectFreeKickWoodwork2(String player) {
    return 'Статива! $player је био тако близу из слободњака.';
  }

  @override
  String pitchComDirectFreeKickWoodwork3(String player) {
    return 'Оквир гола спасава голмана! $player нема среће.';
  }

  @override
  String pitchComPenaltyGoal1(String player) {
    return 'ГОЛ! $player шаље голмана на погрешну страну.';
  }

  @override
  String pitchComPenaltyGoal2(String player) {
    return '$player залет и погодак! ГОЛ!';
  }

  @override
  String pitchComPenaltyGoal3(String player) {
    return 'ГОЛ! $player хладнокрвно реализује пенал.';
  }

  @override
  String pitchComPenaltySaved1(String player, String keeper) {
    return 'Одбрана! $player шутира, $keeper зауставља пенал!';
  }

  @override
  String pitchComPenaltySaved2(String player) {
    return '$player залет... а голман брани!';
  }

  @override
  String pitchComPenaltySaved3(String player, String keeper) {
    return '$player изводи пенал, $keeper погађа страну и брани!';
  }

  @override
  String pitchComPenaltyMissed1(String player) {
    return '$player промашује пенал!';
  }

  @override
  String pitchComPenaltyMissed2(String player) {
    return 'Поред! $player шаље пенал поред стативе.';
  }

  @override
  String pitchComPenaltyMissed3(String player) {
    return 'Преко! $player шутира пенал у небо.';
  }

  @override
  String pitchComPenaltyWoodwork1(String player) {
    return '$player са беле тачке погађа стативу!';
  }

  @override
  String pitchComPenaltyWoodwork2(String player) {
    return 'Пречка! $player не реализује пенал.';
  }

  @override
  String pitchComPenaltyWoodwork3(String player) {
    return 'Оквир гола! $player не верује шта се догодило.';
  }

  @override
  String pitchComPenaltyReboundGoal1(String player) {
    return 'Лопта је слободна! $player допуњава и затрпава одбијену лопту у мрежу!';
  }

  @override
  String pitchComPenaltyReboundGoal2(String player) {
    return '$player први стиже до слободне лопте и погађа из другог покушаја!';
  }

  @override
  String pitchComPenaltyReboundGoal3(String player) {
    return 'Из другог покушаја! $player се баца на слободну лопту и даје гол!';
  }

  @override
  String pitchComPenaltyReboundSaved1(String player, String keeper) {
    return '$player допуњава, али $keeper поново брани!';
  }

  @override
  String pitchComPenaltyReboundSaved2(String player) {
    return '$player стиже до одбијене лопте, али опет нема гола!';
  }

  @override
  String pitchComPenaltyReboundSaved3(String player, String keeper) {
    return '$keeper брзо реагује и зауставља допуну, шутирао је $player!';
  }

  @override
  String pitchComPenaltyReboundWide1(String player) {
    return '$player стиже до одбијене лопте и шутира поред гола!';
  }

  @override
  String pitchComPenaltyReboundWide2(String player) {
    return '$player први стиже до слободне лопте, али шутира преко гола!';
  }

  @override
  String pitchComPenaltyReboundWide3(String player) {
    return 'Стопостотна прилика при допуни, $player шутира, али лопта иде поред!';
  }

  @override
  String pitchComPenaltyReboundBlocked1(String player) {
    return '$player допуњава, али одбрамбени играч блокира ударац!';
  }

  @override
  String pitchComPenaltyReboundBlocked2(String player) {
    return '$player се баца на одбијену лопту, али ударац је блокиран!';
  }

  @override
  String pitchComPenaltyReboundBlocked3(String player) {
    return 'Одбијена лопта пада пред играча $player, али ударац је блокиран!';
  }

  @override
  String pitchComPenaltyReboundWoodwork1(String player) {
    return '$player допуњава и погађа стативу!';
  }

  @override
  String pitchComPenaltyReboundWoodwork2(String player) {
    return 'Оквир гола! Допуна, шутирао је $player, враћа се у игру!';
  }

  @override
  String pitchComPenaltyReboundWoodwork3(String player) {
    return '$player стиже до одбијене лопте и затресе оквир гола!';
  }

  @override
  String pitchComPenaltyReboundCleared1(String defender) {
    return 'Лопта је слободна у шеснаестерцу, али $defender избија!';
  }

  @override
  String pitchComPenaltyReboundCleared2(String defender) {
    return '$defender први стиже до слободне лопте и избија!';
  }

  @override
  String pitchComPenaltyReboundCleared3(String defender) {
    return '$defender најбрже реагује и избија слободну лопту далеко!';
  }

  @override
  String pitchComPenaltyAwarded1(String player) {
    return 'Пенал! $player пада у шеснаестерцу.';
  }

  @override
  String pitchComPenaltyAwarded2(String player, String other) {
    return 'Судија показује на белу тачку! $other прави прекршај, $player лежи у шеснаестерцу.';
  }

  @override
  String pitchComPenaltyAwarded3(String player, String other) {
    return 'Досуђен пенал! $other руши, $player пада.';
  }

  @override
  String pitchComPenaltyAwardedYellow1(String player, String other) {
    return 'Пенал! $player пада, а $other добија жути картон.';
  }

  @override
  String pitchComPenaltyAwardedYellow2(String player, String other) {
    return 'Пенал и жути картон за $other, $player лежи у шеснаестерцу.';
  }

  @override
  String pitchComPenaltyAwardedYellow3(String player, String other) {
    return 'Пенал и картон! $other руши $player у шеснаестерцу.';
  }

  @override
  String pitchComPenaltyAwardedRed1(String player, String other) {
    return 'Пенал и црвени картон! $player пада, $other напушта терен.';
  }

  @override
  String pitchComPenaltyAwardedRed2(String player, String other) {
    return 'Пенал, а $other је искључен! $player лежи у шеснаестерцу.';
  }

  @override
  String pitchComPenaltyAwardedRed3(String player, String other) {
    return 'Црвени картон и пенал! $player бежи сам ка голу, $other га руши.';
  }

  @override
  String pitchComCorner1(String player) {
    return 'Корнер. Изводи $player.';
  }

  @override
  String pitchComCorner2(String player) {
    return '$player центрира из корнера.';
  }

  @override
  String pitchComCorner3(String player) {
    return 'Корнер, лопту поставља $player.';
  }

  @override
  String pitchComFreeKick1(String player) {
    return 'Слободан ударац. Изводи $player.';
  }

  @override
  String pitchComFreeKick2(String player) {
    return 'Слободан ударац на опасном месту. Уз лопту је $player.';
  }

  @override
  String pitchComFreeKick3(String player) {
    return '$player се спрема за слободан ударац.';
  }

  @override
  String pitchComLongThrow1(String player) {
    return 'Дуги аут! $player баца лопту у шеснаестерац.';
  }

  @override
  String pitchComLongThrow2(String player) {
    return '$player дугим аутом убацује лопту у шеснаестерац.';
  }

  @override
  String pitchComLongThrow3(String player) {
    return 'Ево дугог аута, баца $player.';
  }

  @override
  String pitchComFoulYellow1(String player) {
    return 'Жути картон за $player.';
  }

  @override
  String pitchComFoulYellow2(String player, String other) {
    return '$player добија жути картон због прекршаја, $other остаје да лежи.';
  }

  @override
  String pitchComFoulYellow3(String player, String other) {
    return 'Закаснели старт, $other лежи, а $player добија жути картон.';
  }

  @override
  String pitchComFoulSecondYellow1(String player) {
    return 'Други жути! $player напушта терен.';
  }

  @override
  String pitchComFoulSecondYellow2(String player) {
    return '$player добија други жути картон и искључен је.';
  }

  @override
  String pitchComFoulSecondYellow3(String player) {
    return 'Други жути картон за $player, дакле црвени.';
  }

  @override
  String pitchComFoulRed1(String player) {
    return 'Црвени картон! $player је искључен.';
  }

  @override
  String pitchComFoulRed2(String player, String other) {
    return 'Директно црвени! $player прави прекршај, $other остаје да лежи.';
  }

  @override
  String pitchComFoulRed3(String player) {
    return '$player добија црвени картон и мора да изађе.';
  }

  @override
  String pitchComOffside1(String player) {
    return 'Офсајд. $player је кренуо прерано.';
  }

  @override
  String pitchComOffside2(String player) {
    return 'Заставица иде горе, $player је у офсајду.';
  }

  @override
  String pitchComOffside3(String player) {
    return '$player у офсајду, напад је готов.';
  }

  @override
  String pitchComSub1(String player, String other) {
    return 'Измена: $player улази, $other излази.';
  }

  @override
  String pitchComSub2(String player, String other) {
    return '$other напушта терен, мења га $player.';
  }

  @override
  String pitchComSub3(String player, String other) {
    return 'На терен улази $player, излази $other.';
  }

  @override
  String pitchComSubFill1(String player) {
    return 'На терену је $player.';
  }

  @override
  String pitchComSubFill2(String player) {
    return 'Измена: улази $player.';
  }

  @override
  String pitchComSubFill3(String player) {
    return '$player улази у игру.';
  }

  @override
  String pitchComInjury1(String player) {
    return '$player лежи и потребна му је помоћ.';
  }

  @override
  String pitchComInjury2(String player) {
    return 'Забринутост, $player је задобио ударац.';
  }

  @override
  String pitchComInjury3(String player) {
    return 'Забрињавајућа повреда, $player.';
  }

  @override
  String pitchComGoalScore(String line, int home, int away) {
    return '$line $home–$away';
  }

  @override
  String get pitchComSomeone => 'Играч';

  @override
  String pitchComPenaltyAwardedSecondYellow1(String player, String other) {
    return 'Пенал и други жути! $other излази, $player лежи у шеснаестерцу.';
  }

  @override
  String pitchComPenaltyAwardedSecondYellow2(String player, String other) {
    return 'Пенал! $player пада, а $other добија други жути картон.';
  }

  @override
  String pitchComPenaltyAwardedSecondYellow3(String player, String other) {
    return 'Пенал! $other руши $player и добија други жути, дакле црвени.';
  }

  @override
  String get matchViewChooseTitle => 'Како желиш да пратиш утакмицу?';

  @override
  String get matchViewChooseHint =>
      'Твој избор важи и за следећу утакмицу. Можеш га променити у сваком тренутку.';

  @override
  String get matchViewPitch => '2D TV';

  @override
  String get matchViewPitchBlurb => 'Прати играче на терену';

  @override
  String get matchViewTimeline => 'Ток';

  @override
  String get matchViewTimelineBlurb => 'Прати утакмицу догађај по догађај';

  @override
  String get matchViewSwitchToPitch => 'Гледај у 2D TV режиму';

  @override
  String get matchViewSwitchToTimeline => 'Гледај ток';

  @override
  String get matchTabCommentary => 'КОМЕНТАР';

  @override
  String get matchSubShout => 'ИЗМЕНА';

  @override
  String matchSubOff(String name) {
    return 'Излази: $name';
  }

  @override
  String matchSubOn(String name) {
    return 'Улази: $name';
  }

  @override
  String get editorFilterToFix => 'За исправку';

  @override
  String get editorNothingToFix => 'Овде нема ничег за исправку.';

  @override
  String get editorPromoteTooltip => 'Премести у тим';

  @override
  String editorPromoted(String name) {
    return '$name премештен у тим';
  }

  @override
  String get editorPromoteFullTitle => 'Тим је попуњен';

  @override
  String editorPromoteFullBody(int max) {
    return 'Тим има највише $max играча. Изабери играча који се уместо њега враћа у фонд.';
  }

  @override
  String get editorTrophyGallery => 'Изабери из својих фотографија';

  @override
  String get editorTrophyFile => 'Изабери датотеку';

  @override
  String clubStrengthOf(int stars) {
    return 'Снага клуба: $stars од 5';
  }

  @override
  String get editorClubStrength => 'Снага';

  @override
  String get editorClubStrengthDefault => 'Подразумевано';

  @override
  String editorClubStrengthHelp(int stars) {
    return 'Бољи играчи одлазе у јаче клубове. Подразумевано: $stars од 5, према његовој лиги.';
  }

  @override
  String mgrNewsSacked(String nation, String name) {
    return '$nation отпушта $name';
  }

  @override
  String mgrNewsResigned(String nation, String name) {
    return '$nation: $name поднео оставку';
  }

  @override
  String mgrNewsPoached(String nation, String name) {
    return '$nation: $name одлази у другу репрезентацију';
  }

  @override
  String mgrNewsRetired(String nation, String name) {
    return '$nation: $name завршава тренерску каријеру';
  }

  @override
  String mgrNewsContractEnd(String nation, String name) {
    return '$nation: $name одлази када му истекне уговор';
  }

  @override
  String mgrNewsReplacedByPlayer(String nation, String name) {
    return '$nation: $name уступа место вама';
  }

  @override
  String mgrNewsAppointed(String nation, String name) {
    return '$nation именује $name';
  }

  @override
  String mgrNewsAppointedBody(String nation, String name) {
    return '$name преузима $nation.';
  }

  @override
  String pressBeatOpposingManager(String manager) {
    return 'Ви и $manager имате прошлост. Желите ли нешто да кажете о њему?';
  }

  @override
  String get pressAnswerHitBackAtManager => 'Нека брине о свом тиму.';

  @override
  String get pressAnswerRespectManager => 'Имам велико поштовање према њему.';

  @override
  String yMgrTie1(String manager) {
    return 'На супротној клупи је $manager. Са нашим селектором има прошлост и једва чекам.';
  }

  @override
  String yMgrTie2(String manager) {
    return 'Следећи је $manager на супротној клупи. Он и наш селектор се познају већ неко време.';
  }

  @override
  String yMgrTie3(String manager) {
    return 'Опет $manager. Боље да наш селектор од овога не прави личну ствар.';
  }

  @override
  String yMgrTie4(String manager) {
    return 'Ево нас опет. $manager поред аут-линије, а наш селектор покушава да добије свађу уместо утакмице.';
  }

  @override
  String get mgrRowLabel => 'Селектор';

  @override
  String mgrRowDetail(int age, String date) {
    return '$age год., од $date';
  }

  @override
  String mgrRecordWdl(int won, int drawn, int lost) {
    return '$won П, $drawn Н, $lost И';
  }

  @override
  String mgrRowRecord(String record) {
    return 'Под његовим вођством: $record';
  }

  @override
  String get mgrTieNeutral => 'Без прошлости';

  @override
  String get mgrTieRespect => 'Поштовање';

  @override
  String get mgrTieRival => 'Ривал';

  @override
  String get mgrTieGrudge => 'Замерка';

  @override
  String get mgrTieSuccessor => 'Наследник';

  @override
  String get mgrTieProtege => 'Штићеник';

  @override
  String get mgrTieFormerPlayer => 'Бивши играч';

  @override
  String get mgrEndSacked => 'Отпуштен';

  @override
  String get mgrEndResigned => 'Поднео оставку';

  @override
  String get mgrEndPoached => 'Отишао у другу репрезентацију';

  @override
  String get mgrEndRetired => 'Завршио тренерску каријеру';

  @override
  String get mgrEndContractEnd => 'Истекао уговор';

  @override
  String get mgrEndReplacedByPlayer => 'Заменио си га';

  @override
  String get mgrProfileSpells => 'Каријера';

  @override
  String mgrProfileSpellNow(String nation, String from) {
    return '$nation, од $from';
  }

  @override
  String mgrProfileSpellRange(String nation, String from, String to) {
    return '$nation, од $from до $to';
  }

  @override
  String mgrProfileSpellEnded(String range, String reason) {
    return '$range, $reason';
  }

  @override
  String get mgrProfileRecordVsYou => 'Његов учинак против тебе';

  @override
  String get mgrProfileNoMeetings => 'Још се нисте састали';

  @override
  String get mgrProfileReputation => 'Углед';

  @override
  String get mgrProfileAge => 'Године';

  @override
  String get mgrProfileAppointed => 'Именован';

  @override
  String get mgrProfileStyle => 'Стил';

  @override
  String get mgrProfileTie => 'Међу вама';

  @override
  String mgrPreviewLine(String name) {
    return 'Њихов селектор: $name';
  }

  @override
  String mgrDossierStyle(String style) {
    return 'Стил селектора: $style';
  }

  @override
  String mgrDossierRecord(String record) {
    return 'Твој учинак против њега: $record';
  }

  @override
  String get mgrStylePossession => 'Посед лопте';

  @override
  String get mgrStyleHighPress => 'Високи пресинг';

  @override
  String get mgrStyleDefensive => 'Дефанзиван';

  @override
  String get mgrStyleDirect => 'Директан';

  @override
  String get mgrStyleCounter => 'Контранапад';

  @override
  String get mgrStyleFlair => 'Технички';

  @override
  String get mgrStylePhysical => 'Физички';

  @override
  String get mgrStyleBalanced => 'Уравнотежено';

  @override
  String get mgrListTitle => 'Селектори';

  @override
  String get mgrListCurrent => 'Тренутни';

  @override
  String get mgrListRecentMoves => 'Недавне промене';

  @override
  String get mgrListFilterAll => 'Све';

  @override
  String get mgrListSortReputation => 'Углед';

  @override
  String get mgrListSortName => 'Име';

  @override
  String get mgrListEmptyMoves => 'Нема промена у последње две године.';

  @override
  String get mgrListEmptyCurrent =>
      'Селектори се појављују после следећег преласка у нову сезону.';

  @override
  String get editorSectionManagers => 'Селектори';

  @override
  String get editorAboutManagers => 'Ко води коју репрезентацију првог дана';

  @override
  String get editorManagersHint => 'Бира се на почетку каријере';

  @override
  String get editorManagerName => 'Име селектора';

  @override
  String get editorManagerNationality => 'Држављанство';

  @override
  String editorIssueManagerName(int max) {
    return 'Име селектора мора да има од 1 до $max знакова које игра може да прикаже';
  }

  @override
  String get editorIssueManagerNationality =>
      'Изабери селектору држављанство са списка';

  @override
  String get shareButton => 'Подели';

  @override
  String get shareSheetTitle => 'Подели као слику';

  @override
  String get shareFormatSquare => 'Квадрат';

  @override
  String get shareFormatStory => 'Прича';

  @override
  String get shareFailed => 'Слика није могла да се направи.';

  @override
  String get shareSaveToPhotos => 'Сачувај у фотографије';

  @override
  String get shareSavedToPhotos => 'Сачувано у фотографије';

  @override
  String get sharePhotosDenied =>
      'FNM нема дозволу да додаје у твоје фотографије. Можеш је дати у Подешавањима.';

  @override
  String get editorCountryAll => 'Све државе';

  @override
  String get editorCountryFilterTitle => 'Филтрирај по држави';

  @override
  String get shareCabinetBig => 'Подели моје трофеје';

  @override
  String yExitProud0(String competition) {
    return 'Неочекиван поход на турниру $competition и на крају сјајан резултат. Поносан на момке.';
  }

  @override
  String yExitProud1(String competition) {
    return 'Нико нам није давао шансу на турниру $competition. Догурали смо даље него што се ико усудио да сања. Хвала, момци.';
  }

  @override
  String yExitProud2(String competition) {
    return 'Испали смо са турнира $competition, али каква вожња. Овај тим је натерао целу земљу да верује. Понос.';
  }

  @override
  String yExitProud3(String competition) {
    return 'Нисам очекивао да ћемо проћи групу на турниру $competition. Све после тога је био бонус. Само напред.';
  }

  @override
  String yExitProud4(String competition) {
    return 'На турнир $competition смо отишли надајући се бод или два, а враћамо се после нокаут фазе. Добар турнир.';
  }

  @override
  String yExitProud5(String competition) {
    return 'На турниру $competition даље него што су говориле прогнозе. То је корак напред, просто.';
  }

  @override
  String yExitProud6(String competition) {
    return 'Испали смо са турнира $competition и мало боли. Али будимо искрени: нико нас није видео овако далеко.';
  }

  @override
  String yExitProud7(String competition) {
    return 'Добро, испали смо са турнира $competition. Ипак више него што смо постигли годинама. Прихватам.';
  }

  @override
  String yExitProud8(String competition) {
    return 'Са турнира $competition нема трофеја и никад га није ни могло бити. Добар поход је добар поход. Сад то поновите.';
  }

  @override
  String get yReactionPride0 => 'Поносан на сваког од њих.';

  @override
  String get yReactionPride1 => 'Какав поход. Хвала, момци.';

  @override
  String get yReactionPride2 => 'Ово нико није очекивао. Запамтите то.';

  @override
  String get yReactionPride3 => 'Само напред и горе.';

  @override
  String get yReactionPride4 => 'Све је то бонус. Уживајте.';

  @override
  String get yReactionPride5 => 'Боље него што је ико предвиђао. Добар турнир.';

  @override
  String get yReactionPride6 => 'Испали, али без срамоте. Поштено.';

  @override
  String get yReactionPride7 =>
      'Прошао је бољи тим. Ми смо се ипак часно показали.';

  @override
  String get yReactionPride8 => 'Да се не заносимо. Али да, добар поход.';

  @override
  String yExitAccepted0(String competition) {
    return 'Испали смо са турнира $competition, отприлике где се и очекивало. Поносан што су покушали.';
  }

  @override
  String yExitAccepted1(String competition) {
    return 'Турнир $competition је за нас готов. Великима смо задали муке. Главе горе, момци.';
  }

  @override
  String yExitAccepted2(String competition) {
    return 'Испали смо са турнира $competition. На папиру је то увек био вероватан крај. Учимо и идемо даље.';
  }

  @override
  String yExitAccepted3(String competition) {
    return 'Наш турнир $competition се завршава тамо где је ранг-листа и рекла. Нема срамоте у томе.';
  }

  @override
  String yExitAccepted4(String competition) {
    return 'Испали смо са турнира $competition, како је већина и очекивала. Није катастрофа, али није ни шок.';
  }

  @override
  String yExitAccepted5(String competition) {
    return 'Турнир $competition је био корак предалеко за овај тим. Разлика је стварна. Време је да се смањи.';
  }

  @override
  String get yReactionAcceptance0 => 'Дали су све. Више се не може тражити.';

  @override
  String get yReactionAcceptance1 => 'Главе горе. Вратићемо се.';

  @override
  String get yReactionAcceptance2 => 'Боли, али нису нас осрамотили.';

  @override
  String get yReactionAcceptance3 =>
      'Искрено, отприлике оно што смо очекивали.';

  @override
  String get yReactionAcceptance4 => 'Прошли су бољи. То је фудбал.';

  @override
  String get yReactionAcceptance5 => 'Разочаран, не љут.';

  @override
  String get yReactionAcceptance6 => 'Мало безлично, искрено. Али без шокова.';

  @override
  String get yReactionAcceptance7 => 'Још нисмо тамо. Сви то знају.';

  @override
  String get yReactionAcceptance8 =>
      'Исти ниво као прошли пут. Следећи циклус треба корак напред.';

  @override
  String get sponsorIndustryExtraSportswear => 'Спортска одећа';

  @override
  String get sponsorIndustryExtraAirline => 'Авио-компанија пуне услуге';

  @override
  String get sponsorIndustryExtraRailway => 'Железница';

  @override
  String get sponsorIndustryExtraHotels => 'Хотелски ланац';

  @override
  String get sponsorIndustryExtraCoffee => 'Ланац кафића';

  @override
  String get sponsorIndustryExtraChocolate => 'Чоколада';

  @override
  String get sponsorIndustryExtraMineralWater => 'Минерална вода';

  @override
  String get sponsorIndustryExtraPharmacy => 'Ланац апотека';

  @override
  String get sponsorIndustryExtraFashion => 'Мода';

  @override
  String get sponsorIndustryExtraWatches => 'Часовничар';

  @override
  String get sponsorIndustryExtraElectronics => 'Електроника';

  @override
  String get sponsorIndustryExtraSoftware => 'Софтвер';

  @override
  String get sponsorIndustryExtraStreaming => 'Стриминг услуга';

  @override
  String get sponsorIndustryExtraSocialNetwork => 'Друштвена мрежа';

  @override
  String get sponsorIndustryExtraFurniture => 'Намештај';

  @override
  String get sponsorIndustryExtraTyres => 'Гуме';

  @override
  String get sponsorIndustryExtraShipping => 'Бродарска компанија';

  @override
  String get sponsorIndustryExtraLottery => 'Лутрија';

  @override
  String get sponsorIndustryExtraTourism => 'Туристичка организација';

  @override
  String get sponsorIndustryExtraCosmetics => 'Козметика';

  @override
  String get sponsorIndustryExtraPetFood => 'Храна за кућне љубимце';

  @override
  String get sponsorIndustryExtraBakery => 'Пекара';

  @override
  String get sponsorIndustryExtraSupermarket => 'Супермаркет';

  @override
  String get sponsorIndustryExtraSportsNutrition => 'Спортска исхрана';

  @override
  String get sponsorIndustryExtraWine => 'Вино';

  @override
  String get sponsorIndustryExtraTea => 'Чај';

  @override
  String get sponsorIndustryExtraRealEstate => 'Некретнине';

  @override
  String get sponsorIndustryExtraFitness => 'Фитнес клубови';

  @override
  String get sponsorIndustryExtraNewspaper => 'Новине';

  @override
  String mgrDetailCurrentJob(String nation) {
    return 'Тренутни посао: $nation';
  }

  @override
  String get mgrDetailFree => 'Без посла';

  @override
  String get mgrDetailMatches => 'Утакмице';

  @override
  String get mgrDetailTrophies => 'Трофеји';

  @override
  String get mgrDetailWinRate => 'Проценат победа';

  @override
  String get mgrDetailRecord => 'Учинак';

  @override
  String get mgrDetailNationsLed => 'Вођене репрезентације';

  @override
  String get mgrDetailInCharge => 'На дужности';

  @override
  String get mgrDetailNoSpells => 'Још није водио ниједну репрезентацију.';

  @override
  String get mgrDetailNotFound => 'Селектор није пронађен.';

  @override
  String get mgrDetailBackground => 'Порекло';

  @override
  String get mgrOriginFresh => 'Професионални тренер';

  @override
  String get mgrOriginExAssistant => 'Бивши помоћни тренер';

  @override
  String mgrNewsSeeManager(String name) {
    return 'Профил: $name';
  }

  @override
  String get mgrChangesTitle => 'Промене селектора';

  @override
  String mgrChangesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count промена',
      few: '$count промене',
      one: '$count промена',
    );
    return '$_temp0';
  }

  @override
  String mgrChangesLeftFor(String nation) {
    return 'Нова клупа: $nation';
  }

  @override
  String get mgrChangesAppointed => 'Именован';

  @override
  String get mgrChangesVacant => 'Упражњено';

  @override
  String get editorNameNotAllowed => 'Ово име није дозвољено.';

  @override
  String editorIssueNameNotAllowed(String name) {
    return '„$name“ није дозвољено';
  }

  @override
  String get matchWeatherPlaysHeavyRain =>
      'Јака киша: шутеви и центаршутеви мање прецизни, више клизања';

  @override
  String get matchWeatherPlaysStorm =>
      'Грмљавинско невреме: шутеви и центаршутеви мање прецизни, више клизања';

  @override
  String get matchWeatherPlaysSnow => 'Снег: спорија игра, додавања мало тежа';

  @override
  String get matchWeatherPlaysFrost =>
      'Залеђен терен: спорија игра, додавања мало тежа';

  @override
  String get matchWeatherPlaysGale =>
      'Јак ветар: дуге лопте и центаршутеви непредвидиви, шутеви из даљине тежи';

  @override
  String get matchWeatherPlaysFog => 'Магла: шутеви из даљине тежи';

  @override
  String get matchWeatherPlaysHaze =>
      'Врела измаглица: топлије него обично, ноге ће раније попустити';

  @override
  String get pitchComKickOffHeavyRain =>
      'Кренуло је по јакој киши. Лопта ће клизати по овом терену.';

  @override
  String get pitchComKickOffStorm =>
      'Почетни ударац у грмљавинском невремену. Терен ће бити варљив.';

  @override
  String get pitchComKickOffSnow =>
      'Кренуло је по снегу. Биће то спора и опрезна утакмица.';

  @override
  String get pitchComKickOffFrost =>
      'Ледена ноћ и тврд терен. Додавања неће бити лака.';

  @override
  String get pitchComKickOffGale =>
      'Почетни ударац уз јак ветар. Дуге лопте ће бежати.';

  @override
  String get pitchComKickOffFog =>
      'Почетни ударац у густој магли. Из даљине нико неће лако дати гол.';

  @override
  String get pitchComKickOffHaze =>
      'Почетни ударац у врелој измаглици. Ноге ће се данас рано уморити.';

  @override
  String get matchOwnGoal => 'АУТОГОЛ';

  @override
  String get matchGoalOwnGoal => 'АГ';

  @override
  String pitchComOwnGoal1(String defender) {
    return 'Аутогол! $defender је убацио лопту у сопствену мрежу.';
  }

  @override
  String pitchComOwnGoal2(String defender, String shooter) {
    return 'Покушај играча $shooter се несрећно одбија од играча $defender и завршава у мрежи.';
  }

  @override
  String pitchComOwnGoal3(String defender) {
    return 'Катастрофа за играча $defender, који савлађује сопственог голмана.';
  }

  @override
  String pitchComBigSave1(String keeper, String player) {
    return 'Каква одбрана! $keeper зауставља играча $player из близине.';
  }

  @override
  String pitchComBigSave2(String keeper) {
    return 'Сјајна одбрана, $keeper!';
  }

  @override
  String pitchComBigSave3(String keeper, String player) {
    return '$player је изгледао сигуран за гол, али $keeper некако брани.';
  }

  @override
  String matchTimelineWoodwork(String name) {
    return '$name је погодио оквир гола';
  }

  @override
  String matchTimelineBigSave(String name) {
    return 'Велика одбрана: $name';
  }

  @override
  String get matchChartXg => 'xG током утакмице';

  @override
  String get matchChartMomentum => 'Ко је био бољи';

  @override
  String get editorDemoteTooltip => 'Премести у фонд';

  @override
  String editorDemoted(String name) {
    return '$name премештен у фонд';
  }

  @override
  String get profileTabOverview => 'Преглед';

  @override
  String get profileTabStats => 'Статистика';

  @override
  String get profileTabCareer => 'Каријера';

  @override
  String get profileTabVsYou => 'Против тебе';

  @override
  String get playerStatFitness => 'Кондиција';

  @override
  String get settingsAboutProtected =>
      'Игра, њен код и садржај заштићени су ауторским правом.';

  @override
  String get matchTabSummary => 'РЕЗИМЕ';

  @override
  String get matchSummaryOtherMatches => 'Остале утакмице';

  @override
  String get matchSummaryLive => 'УЖИВО';

  @override
  String get matchSummaryHalfTimeMark => 'ПОЛУВР.';

  @override
  String get matchSummaryFullTimeMark => 'КРАЈ';

  @override
  String get matchSummaryExtraTimeMark => 'ПРОДУЖ.';

  @override
  String get matchStatMinutes => 'Минути';

  @override
  String get matchStatSaves => 'Одбране';

  @override
  String editorWebTitle(String address) {
    return 'Уређуј на рачунару: $address';
  }

  @override
  String get editorWebAbout =>
      'Извези своју базу података, отвори је у прегледачу, поново је преузми и увези овде.';

  @override
  String get editorWebAnother => 'Друга могућност';

  @override
  String get editorMerge => 'Споји другу базу података';

  @override
  String get editorMergeAbout =>
      'Преузми шта је неко други променио у својој копији.';

  @override
  String get editorHistory => 'Историја';

  @override
  String get editorHistoryAbout =>
      'Сачуване верзије ове базе података. Врати се на било коју од њих.';

  @override
  String get editorMergeFromTitle => 'Споји из';

  @override
  String get editorMergeFromFile => 'Датотека базе података';

  @override
  String get editorMergeFromFileAbout =>
      'Изабери .fnmdb датотеку коју је неко поделио с тобом.';

  @override
  String get editorMergeFromDevice => 'На овом уређају';

  @override
  String get editorMergeComparing => 'Поређење база података';

  @override
  String get editorMergeNothing =>
      'Нема шта да се споји. Твоја база података већ има све промене оне друге.';

  @override
  String get editorMergeFailed => 'Базе података није било могуће спојити.';

  @override
  String editorMergeReviewTitle(String name) {
    return 'Промене из $name';
  }

  @override
  String editorMergeFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count промена за преглед',
      few: '$count промене за преглед',
      one: '1 промена за преглед',
    );
    return '$_temp0';
  }

  @override
  String editorMergeConflicts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count сукоба',
      few: '$count сукоба',
      one: '1 сукоб',
      zero: 'Нема сукоба',
    );
    return '$_temp0';
  }

  @override
  String get editorMergeConflictsOnly => 'Само сукоби';

  @override
  String get editorMergeNoConflicts =>
      'Нема сукоба. Свака промена је нова за твоју базу података.';

  @override
  String get editorMergeAll => 'Све';

  @override
  String get editorMergeNone => 'Ништа';

  @override
  String editorMergeTake(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Преузми $count промена',
      few: 'Преузми $count промене',
      one: 'Преузми 1 промену',
      zero: 'Не преузимај промене',
    );
    return '$_temp0';
  }

  @override
  String get editorMergeApply => 'Примени';

  @override
  String get editorMergeYours => 'Твоје';

  @override
  String get editorMergeTheirs => 'Њихово';

  @override
  String get editorMergeNew => 'Ново';

  @override
  String get editorMergeConflict => 'Сукоб';

  @override
  String get editorMergeGameValue => 'Као у игри';

  @override
  String get editorMergeNotHere => 'Нема у овој бази података';

  @override
  String editorMergeSquadOf(String nation) {
    return 'Састав ($nation)';
  }

  @override
  String editorMergePoolOf(String nation) {
    return 'Фонд ($nation)';
  }

  @override
  String get editorMergePlace => 'Премештај';

  @override
  String editorMergeNames(int first, int sur) {
    return '$first имена, $sur презимена';
  }

  @override
  String editorMerged(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count промена спојено',
      few: '$count промене спојене',
      one: '1 промена спојена',
    );
    return '$_temp0';
  }

  @override
  String get editorMergeTabOverview => 'Преглед';

  @override
  String get editorMergeTabNames => 'Називи';

  @override
  String get editorMergeTabPress => 'Новинари и Y';

  @override
  String get editorMergeEveryChange => 'Све промене';

  @override
  String editorMergeNewCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count нових',
      few: '$count нове',
      one: '1 нова',
      zero: 'Ништа ново',
    );
    return '$_temp0';
  }

  @override
  String get editorHistorySave => 'Сачувај верзију';

  @override
  String get editorHistorySaveTitle => 'Сачувај ову верзију';

  @override
  String get editorHistoryNameHint => 'Назив (необавезно)';

  @override
  String get editorHistorySaved => 'Верзија сачувана';

  @override
  String get editorHistoryEmpty =>
      'Још нема сачуваних верзија. Једна се чува пре сваког спајања и враћања, као и када се после паузе вратиш у ову базу података.';

  @override
  String get editorHistoryKeep =>
      'Чува се последњих 30 аутоматских верзија. Верзије које сам сачуваш остају док их не обришеш.';

  @override
  String get editorHistorySession => 'Почетак уређивања';

  @override
  String editorHistoryBeforeMerge(String name) {
    return 'Пре спајања базе $name';
  }

  @override
  String get editorHistoryBeforeRestore => 'Пре враћања';

  @override
  String get editorHistoryManual => 'Сачувана верзија';

  @override
  String get editorHistoryAuto => 'Аутоматски';

  @override
  String editorHistoryDiff(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count разлика у односу на сада',
      few: '$count разлике у односу на сада',
      one: '1 разлика у односу на сада',
      zero: 'Исто као сада',
    );
    return '$_temp0';
  }

  @override
  String get editorHistoryRestore => 'Врати';

  @override
  String get editorHistoryRestoreTitle => 'Вратити ову верзију?';

  @override
  String get editorHistoryRestoreBody =>
      'База података се враћа на ову верзију. Њено тренутно стање се прво чува у историји.';

  @override
  String get editorHistoryRestored => 'Верзија враћена';

  @override
  String get editorHistoryFailed => 'Није успело. Покушај поново.';

  @override
  String get editorHistoryRenameTitle => 'Преименуј верзију';

  @override
  String get editorHistoryDeleteTitle => 'Обрисати ову верзију?';

  @override
  String get editorHistoryDeleteBody =>
      'Уклања се из историје. Сама база података се не мења.';

  @override
  String get financesTabDepartments => 'Одељења';

  @override
  String get financesTabFacilities => 'Објекти';

  @override
  String get financesInvestedSoFar => 'Досад уложено';

  @override
  String get tacticsQuickBest => 'Најбољи';

  @override
  String get tacticsQuickPrevious => 'Претходни';

  @override
  String get assistantAskShort => 'Помоћник';

  @override
  String get editorRankingTitle => 'Светска ранг-листа';

  @override
  String editorRankingPlace(int rank) {
    return '#$rank';
  }

  @override
  String get editorRankingAuto => 'Аутоматски';

  @override
  String editorRankingAutoPlace(int rank) {
    return 'Аутоматски (#$rank)';
  }

  @override
  String get editorRankingAbout =>
      'Где ова репрезентација почиње нову каријеру на светској ранг-листи. Аутоматски прати снагу њеног тима.';

  @override
  String editorRankingHint(int min, int max) {
    return '$min до $max';
  }

  @override
  String editorRankingOf(String nation) {
    return '$nation: светска ранг-листа';
  }

  @override
  String editorIssueRanking(int min, int max) {
    return 'Унеси место на светској ранг-листи од $min до $max.';
  }

  @override
  String get editorRegionWorldwide => 'Цео свет';

  @override
  String get editorRegionNone => 'За овај регион овде нема ничег.';

  @override
  String get nationTabResults => 'Резултати';

  @override
  String get nationTabHistory => 'Историја';

  @override
  String get nationTabStadiums => 'Стадиони';

  @override
  String get nationStatRanking => 'Пласман';

  @override
  String get nationStatOverall => 'Снага';

  @override
  String get nationFactsTitle => 'Чињенице';

  @override
  String get nationFactAgainstYou => 'Твој учинак против њих (П-Н-И)';

  @override
  String nationFactBiggestWin(String opponent, String year) {
    return 'Највећа победа ($opponent, $year)';
  }

  @override
  String get nationFactHomeUnbeaten => 'Домаћих утакмица заредом без пораза';

  @override
  String nationFactTitleDrought(String year) {
    return 'Година од последње титуле ($year)';
  }

  @override
  String get nationFactNoTitles => 'Још чека прву титулу';

  @override
  String nationFactRecordScorer(String name) {
    return 'Голови рекордног стрелца, $name';
  }

  @override
  String nationFactRankClimb(int rank, String year) {
    return 'Места напретка у једном циклусу, до #$rank у $year.';
  }

  @override
  String nationFactWorldFinals(String year) {
    return 'Завршних турнира Светског првенства од $year.';
  }

  @override
  String nationBestRankYear(int rank, String year) {
    return 'Најбоље: #$rank ($year)';
  }

  @override
  String get nationLikelyEleven => 'Вероватна почетна постава';

  @override
  String get nationBestYoung => 'Најбољи до 21';

  @override
  String get nationWhereTheyPlay => 'Где играју';

  @override
  String get nationOtherCountries => 'Остале земље';

  @override
  String get nationBiggestWinYou => 'Твоја највећа победа';

  @override
  String nationAllMeetings(int count) {
    return 'Сви сусрети ($count)';
  }

  @override
  String get nationUpcoming => 'Предстојеће';

  @override
  String get nationLastResults => 'Последњи резултати';

  @override
  String nationAllMatches(int count) {
    return 'Све утакмице ($count)';
  }

  @override
  String get nationShowMore => 'Прикажи више';

  @override
  String get nationHostingRecord => 'Као домаћин';

  @override
  String get nationNeverHosted => 'Још није била домаћин завршног турнира';

  @override
  String get nationHostChampions => 'Првак';

  @override
  String get nationHostRunnersUp => 'Финалиста';

  @override
  String get nationHostThird => 'Трећи';

  @override
  String get nationCoHosts => 'Судомаћин';

  @override
  String get nationNoStadiums => 'Нема забележених стадиона';

  @override
  String get nationManageStadiums => 'Управљај стадионима';

  @override
  String get scheduleHome => 'Код куће';

  @override
  String get scheduleAway => 'У гостима';

  @override
  String scheduleGroupTag(String name) {
    return 'Група $name';
  }

  @override
  String get scheduleFilterMine => 'Моје';

  @override
  String get scheduleFilterCompetitions => 'Такмичења';

  @override
  String get scheduleFilterDraws => 'Жребови';

  @override
  String scheduleDrawOf(String competition) {
    return 'Жреб: $competition';
  }

  @override
  String get scheduleDrawCeremony => 'Церемонија жреба';

  @override
  String get scheduleNoDraws => 'Нема предстојећих жребова';

  @override
  String hubCallUpClosesIn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Позиви се затварају за $count дана',
      few: 'Позиви се затварају за $count дана',
      one: 'Позиви се затварају сутра',
      zero: 'Позиви се затварају данас',
    );
    return '$_temp0';
  }

  @override
  String hubNextWindowLabel(String month, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'још $count утакмица',
      few: 'још $count утакмице',
      one: 'још $count утакмица',
    );
    return '$month: $_temp0';
  }

  @override
  String get careerManagerAge => 'Године';

  @override
  String managerAgeRange(int min, int max) {
    return 'Од $min до $max';
  }

  @override
  String managerNameAge(String name, int age) {
    return '$name ($age)';
  }

  @override
  String get managerSuccession => 'Управа пита за планове о наследнику.';

  @override
  String get managerAgePromptTitle => 'Колико година има твој селектор?';

  @override
  String get managerAgePromptBody =>
      'Ова каријера још нема уписане године селектора. Постави их једном и приказиваће се уз твоје име. У игри не мењају ништа.';

  @override
  String get managerAgePromptSet => 'Постави године';

  @override
  String get managerAgePromptSkip => 'Прескочи';

  @override
  String mgrNewsRetiredAge(String nation, String name, int age) {
    return '$nation: $name ($age) завршава тренерску каријеру';
  }

  @override
  String get editorManagerAge => 'Године';

  @override
  String get editorManagerAgeHint => 'Празно: бира игра';

  @override
  String editorIssueManagerAge(int min, int max) {
    return 'Године селектора морају бити од $min до $max.';
  }

  @override
  String pressFloor(int index, int total) {
    return 'ИМАТЕ РЕЧ · $index/$total';
  }

  @override
  String pressTickerStanding(String code, int points, String place) {
    String _temp0 = intl.Intl.pluralLogic(
      points,
      locale: localeName,
      other: '$points БОДОВА',
      few: '$points БОДА',
      one: '$points БОД',
    );
    return '$code $_temp0 · $place';
  }

  @override
  String get pressAfterTitle => 'ПОСЛЕ КОНФЕРЕНЦИЈЕ';

  @override
  String get pressTileMorale => 'Морал';

  @override
  String get pressTilePress => 'Новинари';

  @override
  String get pressPromiseHeading => 'ОБЕЋАЛИ СТЕ';

  @override
  String get pressPromiseWinNext => 'Победу у следећој утакмици.';

  @override
  String get pressPromiseJob => 'Своје место у наредне три утакмице.';

  @override
  String get pressPromiseJudgedCampaign =>
      'Управа ће пресудити када се кампања реши.';

  @override
  String get pressPromiseJudgedMatch => 'Пресуђује резултат следеће утакмице.';

  @override
  String get hubEventWatchEuroPlayoffDraw => 'Гледај жреб баража';

  @override
  String get hubEventWatchEuroPlayoffs => 'Гледај бараж';

  @override
  String get hubCallUpPlayoffs => 'Објави списак за бараж';

  @override
  String compPlayoffs(String competition) {
    return '$competition: бараж';
  }

  @override
  String newsEuroPlayoffPathTitle(String cup, String path) {
    return '$cup, бараж: пут $path';
  }

  @override
  String newsEuroPlayoffPathBodyHome(String opponent) {
    return 'Полуфинале у једној утакмици код куће против $opponent у марту, затим једно финале за место на завршном турниру.';
  }

  @override
  String newsEuroPlayoffPathBodyAway(String opponent) {
    return 'Полуфинале у једној утакмици у гостима код $opponent у марту, затим једно финале за место на завршном турниру.';
  }

  @override
  String get euroPlayoffDrawTitle => 'ЖРЕБ БАРАЖА';

  @override
  String get euroPlayoffIntro =>
      'Прва два из сваке квалификационе групе пролазе даље. Последња места се освајају у баражним путевима од четири тима, по један за сваку лигу Купа нација: полуфинала у једној утакмици код вишег носиоца у марту, затим једно финале.';

  @override
  String euroPlayoffPath(String path) {
    return 'Пут $path';
  }

  @override
  String get euroPlayoffYourPath => 'Твој пут';

  @override
  String euroPlayoffSemi(int number) {
    return 'Полуфинале $number';
  }

  @override
  String euroPlayoffFinalHost(int number) {
    return 'Финале, домаћин је победник полуфинала $number';
  }

  @override
  String euroPlayoffFinalPending(int first, int second) {
    return 'Победник полуфинала $first против победника полуфинала $second';
  }

  @override
  String euroPlayoffWinnerToGroup(String group) {
    return 'Победник иде у групу $group';
  }

  @override
  String euroPlayoffWinnerPlaceholder(String path) {
    return 'Победник пута $path';
  }

  @override
  String euroPlayoffYourGroupIfWin(String path, String group) {
    return 'Твоја група ако победиш на путу $path: група $group';
  }

  @override
  String get euroPlayoffBracketHeading => 'БАРАЖ';

  @override
  String get wcPlayoffIntro =>
      'Дванаест победника група је прошло. О последњим европским местима одлучује бараж у путевима од четири тима: најбољи другопласирани и најбољи победници група Купа нација који још нису прошли, полуфинала у једној утакмици код вишег носиоца у марту, затим једно финале.';

  @override
  String get icPlayoffIntro =>
      'Шест тимова из пет конфедерација игра за последња два места. Два најбоље рангирана чекају у финалима путева, остала четири играју полуфинала, а све утакмице се играју у земљи домаћину у марту.';

  @override
  String get icPlayoffSeeded => 'Директно у финалу пута';

  @override
  String icPlayoffFinalPending(String nation) {
    return '$nation против победника полуфинала';
  }

  @override
  String wcPlaceholderUefa(String path) {
    return 'Победник европског пута $path';
  }

  @override
  String wcPlaceholderIc(String path) {
    return 'Победник интерконтиненталног пута $path';
  }

  @override
  String newsIcPlayoffTitle(String path) {
    return 'Интерконтинентални бараж: пут $path';
  }

  @override
  String newsIcPlayoffBodySemi(String opponent) {
    return 'Полуфинале у једној утакмици против $opponent у марту, у земљи домаћину, затим финале пута за место на завршном турниру.';
  }

  @override
  String newsIcPlayoffBodyBye(String first, String second) {
    return 'Директно у финалу пута у марту, у земљи домаћину, против победника утакмице $first - $second.';
  }

  @override
  String newsCafPlayoffTitle(String opponent) {
    return 'Афрички бараж: полуфинале против $opponent';
  }

  @override
  String get newsCafPlayoffBody =>
      'Четири најбоља другопласирана тима афричких група састају се у новембру код домаћина Афричког првенства: једна полуфинална утакмица, затим финале. Победник иде у интерконтинентални бараж.';

  @override
  String newsAfcFourthRoundTitle(String group) {
    return 'Азијско четврто коло: група $group';
  }

  @override
  String newsAfcFourthRoundBody(String first, String second) {
    return 'Једно коло утакмица у новембру против $first и $second. Победник групе се квалификује; другопласирани игра пето коло у две утакмице за место у интерконтиненталном баражу.';
  }

  @override
  String newsAfcFifthRoundTitle(String opponent) {
    return 'Азијско пето коло: $opponent у две утакмице';
  }

  @override
  String get newsAfcFifthRoundBody =>
      'Код куће и у гостима у новембру. Победник по збиру голова иде у интерконтинентални бараж; ако је нерешено после реванша, следе продужеци и пенали.';

  @override
  String newsOfcFinalTitle(String opponent) {
    return 'Финале Океаније: $opponent';
  }

  @override
  String get newsOfcFinalBody =>
      'Једна утакмица у новембру код домаћина Купа Океаније за место Океаније на завршном турниру. Поражени иде у интерконтинентални бараж.';

  @override
  String get matchTinyFirstLeg => '1. утак.';

  @override
  String get matchTinySecondLeg => 'реванш';

  @override
  String get matchTinyFourthRound => '4. коло';

  @override
  String get resultsStageFourthRound => 'Четврто коло';

  @override
  String get resultsStageFifthRound => 'Пето коло';

  @override
  String newsNcPromotedTitle(String league) {
    return 'Пласман у Лигу $league';
  }

  @override
  String newsNcPromotedBody(String cup) {
    return 'Прво место у групи у такмичењу $cup: следеће издање се игра лигу више, а пласман доноси савезу 1 мил. €, исплаћених на крају циклуса.';
  }

  @override
  String newsNcRelegatedTitle(String league) {
    return 'Испадање у Лигу $league';
  }

  @override
  String newsNcRelegatedBody(String cup) {
    return 'Последње место у групи у такмичењу $cup: следеће издање се игра лигу ниже.';
  }

  @override
  String stadiumsBuildFrom(String cost) {
    return 'Изградња: од $cost';
  }

  @override
  String stadiumsConfirmBuildSized(String seats, String city, String cost) {
    return 'Изградити стадион са $seats места у граду $city за $cost?';
  }

  @override
  String stadiumsCapacityRange(String min, String max) {
    return 'Капацитет: по избору, од $min до $max места';
  }

  @override
  String get hubAssistantFriendly => 'Препусти помоћнику';

  @override
  String pitchComHandballPenalty1(String player) {
    return 'Играње руком! $player игра руком у шеснаестерцу, пенал.';
  }

  @override
  String pitchComHandballPenalty2(String player) {
    return 'Рука је била одмакнута: пенал због играња руком играча $player!';
  }

  @override
  String pitchComHandballPenaltyYellow(String player) {
    return 'Играње руком играча $player у шеснаестерцу: пенал и жути картон.';
  }

  @override
  String pitchComHandballPenaltyRed(String player) {
    return '$player зауставља лопту руком! Пенал и искључење.';
  }

  @override
  String pitchComHandballYellow(String player) {
    return '$player добија жути картон због играња руком.';
  }

  @override
  String pitchComHandballRed(String player) {
    return 'Намерно играње руком! $player је искључен.';
  }

  @override
  String get matchLiveTable => 'Табела уживо';

  @override
  String get matchShotMap => 'Мапа шутева';

  @override
  String get shotGoal => 'Гол';

  @override
  String get shotSaved => 'Одбрањено';

  @override
  String get shotOffTarget => 'Поред гола';

  @override
  String get shotBlocked => 'Блокирано';

  @override
  String get shotWoodwork => 'Оквир гола';

  @override
  String get playerStatSaves => 'Одбране';

  @override
  String get playerStatPenSaved => 'Одбрањени пенали';

  @override
  String get playerStatPenalties => 'Пенали';

  @override
  String playerStatRateValue(String count, String pct) {
    return '$count ($pct%)';
  }

  @override
  String playerStatOfValue(String done, String of) {
    return '$done/$of';
  }

  @override
  String yPlayoffDrawn0(String competition, String opponent) {
    return 'Жреб баража за $competition: $opponent стоји између нас и завршног турнира.';
  }

  @override
  String yPlayoffDrawn1(String competition, String opponent) {
    return 'У баражу за $competition играмо против $opponent. Један дуел, све на коцки.';
  }

  @override
  String yPlayoffDrawn2(String competition, String opponent) {
    return '$opponent у баражу. Већ морам да легнем. $competition, стижемо. Можда.';
  }

  @override
  String yPlayoffDrawn3(String competition, String opponent) {
    return 'Жреб баража: $opponent. Ако их победимо, $competition је надохват руке.';
  }

  @override
  String get matchElsewhereShout => 'ГОЛ НА ДРУГОМ ТЕРЕНУ';

  @override
  String get assistantMatchTitle => 'Утакмицу води помоћник';

  @override
  String assistantMatchBody(String opponent) {
    return 'Против тима $opponent игра са твојим саставом и твојом тактиком. Ако желиш, прво их подеси.';
  }

  @override
  String get assistantMatchPlay => 'Нека игра';

  @override
  String get assistantMatchResult => 'Помоћникова утакмица';

  @override
  String get euroPlayoffCourseTitle => 'Бараж преко Купа нација';

  @override
  String get euroPlayoffCourseNote =>
      'Прва два из сваке групе пролазе директно. Последња места се освајају у баражу најбољих тимова Купа нација који нису прошли. Тренутно стање:';

  @override
  String get euroPlayoffToFinal => 'У финале';

  @override
  String get euroPlayoffQualified => 'Пласман';

  @override
  String get playerOtherPositions => 'На свакој позицији';

  @override
  String get compGulfCup => 'Куп оазе';

  @override
  String get compSoutheastAsianChampionship => 'Првенство југоисточне Азије';

  @override
  String get matchTinyGulfCup => 'Оаза';

  @override
  String get matchTinySoutheastAsia => 'ЈИ Азија';

  @override
  String hubCallUpRegional(String cup) {
    return 'Позови играче за турнир $cup';
  }

  @override
  String newsRegionalDrawTitle(String cup, String group) {
    return '$cup: група $group';
  }

  @override
  String newsRegionalDrawBody(String cup, String rivals) {
    return 'Жреб турнира $cup је обављен. У децембру играш против: $rivals.';
  }

  @override
  String newsRegionalDrawBodyHosted(String cup, String rivals, String host) {
    return 'Жреб турнира $cup је обављен. У децембру играш против: $rivals. Домаћин: $host.';
  }

  @override
  String newsRegionalWonTitle(String cup) {
    return '$cup освојен!';
  }

  @override
  String newsRegionalWonBody(String cup, String opponent, String score) {
    return 'Освојио си турнир $cup, у финалу си победио $opponent $score.';
  }

  @override
  String get tourZoneGulf => 'ЗАЛИВ';

  @override
  String get tourZoneSoutheastAsia => 'ЈУГОИСТОЧНА АЗИЈА';

  @override
  String regionalCupNext(int year) {
    return 'Следеће издање се игра у децембру $year.';
  }

  @override
  String get regionalCupNoWinners => 'Још нема победника.';

  @override
  String regionalCupEdition(String cup, int year) {
    return '$cup $year';
  }

  @override
  String regionalCupChampion(String name) {
    return 'Победник: $name';
  }

  @override
  String regionalCupHosted(String host) {
    return 'Домаћин: $host';
  }

  @override
  String get regionalCupHomeAndAway => 'Групе се играју код куће и у гостима';

  @override
  String get regionalCupGroups => 'ГРУПЕ';

  @override
  String newsNcPlayoffNetTitle(String finals) {
    return 'Бараж као сигурносна мрежа: $finals';
  }

  @override
  String newsNcPlayoffNetBody(String cup, String finals) {
    return 'Према табелама такмичења $cup засад имаш место у баражу. Ако директан пласман не успе, то је други пут до турнира $finals. Баражни путеви се извлаче после квалификација.';
  }

  @override
  String get ncLegendWinnerUp => 'Победник групе: пласман у вишу лигу';

  @override
  String get ncLegendWinnerFinalsFour => 'Победник групе: пласман у Фајнал фор';

  @override
  String get ncLegendLastDown => 'Последњи: испадање у нижу лигу';

  @override
  String get ncLegendMayMove =>
      'Несигурно: места је мање него група, па у целој лиги напредују само најбољи победници, а испадају само најлошији последњи';

  @override
  String get campaignIsleOfManTitle => 'Три ноге';

  @override
  String get campaignIsleOfManTwist =>
      'Острво Мен заузима место Андоре у Европи, на сто година';

  @override
  String get campaignIsleOfManIntro =>
      'Острво Мен има сопствени фудбалски савез, сопствену лигу и репрезентацију која игра на Острвским играма, али нема место ни у европском ни у светском фудбалу. У овом свету заузело је место Андоре у Европи и креће близу дна светске ранг-листе: полупрофесионални играчи, мали стадион у Дагласу и ветар са Ирског мора на свакој утакмици. Имаш сто година, двадесет пет циклуса, да стигнеш до Европског првенства, затим до Светског првенства и, ако се усудиш да сањаш, освојиш једно од њих.';

  @override
  String get campaignIsleOfManGoal => 'Квалификуј се на Европско првенство';

  @override
  String get campaignStars1IsleOfMan => 'Квалификуј се на Европско првенство';

  @override
  String get campaignStars2IsleOfMan => 'Квалификуј се на Светско првенство';

  @override
  String get campaignStars3IsleOfMan => 'Освоји Европско или Светско првенство';

  @override
  String get campaignCzechoslovakiaTitle => 'Поново заједно';

  @override
  String get campaignCzechoslovakiaTwist =>
      'Чешка и Словачка поново играју као један тим, током четири циклуса';

  @override
  String get campaignCzechoslovakiaIntro =>
      'Чехословачка је 1976. освојила Европско првенство и двапут стигла до финала Светског првенства, а 1993. се поделила на две државе. У овом свету две земље су се поново ујединиле: сви репрезентативци Чешке и Словачке опет играју за један тим, а две нације су нестале из Европе. Почињеш тик унутар првих тридесет на светској ранг-листи и бираш из оба састава. Имаш четири циклуса да одведеш Чехословачку на Светско првенство, а затим освојиш Европско првенство и Светско првенство.';

  @override
  String get campaignCzechoslovakiaGoal => 'Квалификуј се на Светско првенство';

  @override
  String get campaignStars1Czechoslovakia =>
      'Квалификуј се на Светско првенство';

  @override
  String get campaignStars2Czechoslovakia => 'Освоји Европско првенство';

  @override
  String get campaignStars3Czechoslovakia => 'Освоји Светско првенство';

  @override
  String get campaignTexasTitle => 'Усамљена звезда';

  @override
  String get campaignTexasTwist =>
      'Република Тексас заузима место Ангвиле у Северној Америци, кроз пет циклуса';

  @override
  String get campaignTexasIntro =>
      'Тексас је девет година био самостална република пре него што се придружио Сједињеним Државама, а данас ствара више фудбалера од већине држава: три академије из највише лиге, једну од најширих омладинских база на свету и Тексашане у свакој лиги. У овом свету Република Тексас игра за себе, на месту Ангвиле у Северној Америци. Сваки играч рођен је у Тексасу, у Хјустону, Даласу, Сан Антонију, Остину или Ел Пасу, а екипа је средина табеле у региону: довољно добра да намучи свакога, али још не толико да је се ико плаши. Имаш пет циклуса да стигнеш до Светског првенства, освојиш Куп Северне Америке и, ако се усудиш да сањаш, само Светско првенство.';

  @override
  String get campaignTexasGoal => 'Квалификуј се на Светско првенство';

  @override
  String get campaignStars1Texas => 'Квалификуј се на Светско првенство';

  @override
  String get campaignStars2Texas => 'Освоји Куп Северне Америке';

  @override
  String get campaignStars3Texas => 'Освоји Светско првенство';

  @override
  String get wcPlayoffCourseNote =>
      'Сваки победник групе пролази директно. Последња места се освајају у баражу најбољих другопласираних (жуто у групама) и најбољих победника група Купа нација који нису прошли. Из Купа нација, тренутно стање:';

  @override
  String get playoffCourseLegend =>
      'Жуто: иде у бараж као један од најбољих другопласираних, према тренутном стању';

  @override
  String get playoffCourseFooter =>
      'Зашто су овде: Куп нација даје победницима група, а затим следећим најбољим у свакој лиги, место у баражу ако не прођу директно. Ово је само тренутно стање и мења се после сваког кола.';

  @override
  String get traitShotStopper => 'Врхунски у одбрани шутева';

  @override
  String get traitShotStopperBlurb =>
      'Одбрани више шутева него што би се очекивало.';

  @override
  String get traitPenaltyStopper => 'Убица пенала';

  @override
  String get traitPenaltyStopperBlurb =>
      'Брани више пенала, у утакмици и у извођењу пенала.';

  @override
  String get playoffCourseLegendAll => 'Жуто: сви другопласирани иду у бараж';

  @override
  String get wcRunnersUpTableTitle => 'Другопласирани: сви иду у бараж';

  @override
  String get wcRunnersUpTableNote =>
      'Поређано према упоредивим резултатима. Шешири баража се слажу према светској ранг-листи на крају квалификација.';

  @override
  String ncRouteNote(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Шешир 4 баража има $count места за Куп нација.',
      few: 'Шешир 4 баража има $count места за Куп нација.',
      one: 'Шешир 4 баража има $count место за Куп нација.',
    );
    return '$_temp0 Добијају их најпре његови најбољи победници група који не освоје своју квалификациону групу нити буду други, а затим следећи према његовом пласману. Према тренутном стању:';
  }

  @override
  String ncRouteHostCycle(int paths, int runnersUp) {
    return 'Ово Светско првенство организује европска земља, па другопласирани ($runnersUp) попуњавају све баражне путеве ($paths) и у овом циклусу ниједно место не иде преко Купа нација.';
  }

  @override
  String get ncRouteTagHolds => 'Има место';

  @override
  String get ncRouteTagQualified => 'Пролази';

  @override
  String get ncRouteTagRunnerUp => 'Други';

  @override
  String get ncRouteTagWaiting => 'Чека';

  @override
  String get ncRouteLegendHolds =>
      'Држи место у шеширу 4, према тренутном стању';

  @override
  String get ncRouteLegendQualified =>
      'Води у својој квалификационој групи: пролази директно, његово место иде даље';

  @override
  String get ncRouteLegendRunnerUp =>
      'Други у својој квалификационој групи: ионако иде у бараж, његово место иде даље';

  @override
  String get ncRouteLegendWaiting =>
      'Следећи на реду ако неко испред испадне са овог пута';

  @override
  String get statsTabHistory => 'Историја';

  @override
  String get tourCupDestAfcFourthRound => 'азијско четврто коло';

  @override
  String get tourCupDestCafPlayoff => 'афрички бараж';

  @override
  String get tourCupDestOfcFinal => 'финале Океаније';

  @override
  String get qualLegendDirect =>
      'Зелено: према тренутном стању иде директно на завршни турнир';

  @override
  String get qualLegendAfcStep => 'Жуто: иде у азијско четврто коло';

  @override
  String get qualLegendCafStep => 'Жуто: иде у афрички бараж';

  @override
  String get qualLegendOfcStep => 'Жуто: иде у финале Океаније';

  @override
  String get qualLegendIntercont => 'Жуто: иде у интерконтинентални бараж';

  @override
  String get legendThrough =>
      'Зелено: према тренутном стању пролази у следећу рунду';

  @override
  String get campaignRunInNumbersNote =>
      'Само утакмице по којима се ова кампања оцењује: пријатељске утакмице и друга такмичења се не рачунају.';
}
