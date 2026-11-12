// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bulgarian (`bg`).
class AppLocalizationsBg extends AppLocalizations {
  AppLocalizationsBg([String locale = 'bg']) : super(locale);

  @override
  String get matchPreviewTitle => 'ПРЕГЛЕД ПРЕДИ МАЧА';

  @override
  String get matchKickOff => 'Начален удар';

  @override
  String get matchTactics => 'Тактика';

  @override
  String get matchYourXi => 'ТВОЯТ СТАРТОВ СЪСТАВ';

  @override
  String get matchHeadToHead => 'ДИРЕКТНИ СРЕЩИ';

  @override
  String matchCouldNotLoad(String error) {
    return 'Мачът не можа да се зареди.\n$error';
  }

  @override
  String get matchNoUpcoming => 'Няма предстоящ мач.';

  @override
  String get matchUnknownNation => 'Неизвестна';

  @override
  String get matchH2hFirstMeeting => 'Първа среща между двата отбора';

  @override
  String get matchH2hYouLead => 'Водиш в директните срещи';

  @override
  String matchH2hOppEdge(String opponent) {
    return 'Предимство за $opponent';
  }

  @override
  String get matchH2hEven => 'Наравно';

  @override
  String matchH2hMet(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count срещи',
      one: '$count среща',
    );
    return '$_temp0';
  }

  @override
  String get matchH2hWon => 'Победи';

  @override
  String get matchH2hDrawn => 'Равни';

  @override
  String get matchH2hLost => 'Загуби';

  @override
  String get matchDossierTitle => 'Скаутски доклад';

  @override
  String get matchDossierForm => 'ФОРМА';

  @override
  String get matchDossierNoGames => 'Няма скорошни мачове';

  @override
  String get matchDossierKeyMen => 'КЛЮЧОВИ ИГРАЧИ';

  @override
  String get matchDossierHowTheyPlay => 'КАК ИГРАЯТ';

  @override
  String matchScoutFormation1(String formation) {
    return 'Обикновено играят в схема $formation.';
  }

  @override
  String matchScoutFormation2(String formation) {
    return 'Обичайната им схема е $formation.';
  }

  @override
  String matchScoutFormation3(String formation) {
    return 'Най-често залагат на схема $formation.';
  }

  @override
  String get matchScoutStrengthPressing => 'Пресират високо и гонят топката.';

  @override
  String get matchScoutStrengthDirect =>
      'Играят директно и бързо пращат топката напред.';

  @override
  String get matchScoutStrengthPossession =>
      'Задържат добре топката и градят търпеливо.';

  @override
  String get matchScoutStrengthCounter => 'Стоят ниско и контраатакуват бързо.';

  @override
  String get matchScoutStrengthDeepDefence =>
      'Защитават се ниско и трудно се пробиват.';

  @override
  String get matchScoutStrengthWide =>
      'Разтягат играта и атакуват по фланговете.';

  @override
  String get matchScoutStrengthAttacking =>
      'Обичат да поемат инициативата и да атакуват съперника.';

  @override
  String get matchScoutStrengthQuickForwards =>
      'Нападателите им са бързи и обичат да бягат зад защитата.';

  @override
  String get matchScoutStrengthPassingMidfield =>
      'Халфовата им линия подава добре.';

  @override
  String get matchScoutStrengthHardRunning =>
      'Халфовете им имат сили да тичат цял мач.';

  @override
  String get matchScoutStrengthSetPieces => 'Опасни са при статични положения.';

  @override
  String get matchScoutStrengthQuickDefence =>
      'Защитата им е бърза и трудно се минава зад нея.';

  @override
  String get matchScoutStrengthNone => 'Нищо в играта им не изпъква особено.';

  @override
  String get matchScoutWeakSpaceBehind =>
      'Високата им линия оставя място зад защитата за дълъг пас.';

  @override
  String get matchScoutWeakPressedBuildUp =>
      'Високата преса може да обърка бавното им изграждане.';

  @override
  String get matchScoutWeakDeepBlock =>
      'Търпение: нисък блок като техния може да бъде разглобен.';

  @override
  String get matchScoutWeakLongBall =>
      'Свали линията си по-ниско и дългите им топки няма да имат накъде да летят.';

  @override
  String get matchScoutWeakSlowDefence =>
      'Защитниците им са бавни, затова пращай играчи зад гърба им.';

  @override
  String get matchScoutWeakAerial =>
      'Изглеждат несигурни при защита на статични положения.';

  @override
  String get matchScoutWeakPoorPassing =>
      'Халфовата им линия трудно излиза от преса с подавания.';

  @override
  String get matchScoutWeakTiringMidfield =>
      'Халфовете им нямат сили да поддържат пресата.';

  @override
  String get matchScoutWeakBluntAttack => 'Нападателите им са бавни.';

  @override
  String get matchScoutApproachTakeTheGame =>
      'Срещу теб очаквай да поемат инициативата.';

  @override
  String get matchScoutApproachEven =>
      'Срещу теб очаквай оспорван и равностоен мач.';

  @override
  String get matchScoutApproachSitDeep =>
      'Срещу теб очаквай да са предпазливи и да търсят контраатака.';

  @override
  String get matchScoutLeaningAttacking =>
      'Отдалеч изглеждат като атакуващ отбор.';

  @override
  String get matchScoutLeaningCautious =>
      'Отдалеч изглеждат като предпазлив отбор.';

  @override
  String get matchScoutLeaningUnclear =>
      'Отдалеч е трудно да се каже как обичат да играят.';

  @override
  String get matchScoutHireHint =>
      'Назначи главен скаут, за да разбереш как играят.';

  @override
  String matchCouldNotContinue(String error) {
    return 'Не можа да продължи: $error';
  }

  @override
  String get matchSkipToFullTime => 'Към крайния резултат';

  @override
  String get matchStatShots => 'Удари';

  @override
  String get matchStatGoals => 'Голове';

  @override
  String get matchStatYellowCards => 'Жълти';

  @override
  String get matchStatRedCards => 'Червени';

  @override
  String get matchMomentum => 'ИНИЦИАТИВА';

  @override
  String get matchSwingAtk => 'АТК';

  @override
  String get matchSwingDef => 'ЗАЩ';

  @override
  String ceremonyWorldCupYear(int year) {
    return 'СВЕТОВНО ПЪРВЕНСТВО $year';
  }

  @override
  String get ceremonyFinalsAreHere => 'ФИНАЛИТЕ СА ТУК';

  @override
  String ceremonyHostedBy(String hosts) {
    return 'ДОМАКИН  $hosts';
  }

  @override
  String get ceremonyHostTbc => 'ДОМАКИНЪТ СЕ УТОЧНЯВА';

  @override
  String get matchHalfTime => 'ПОЧИВКА';

  @override
  String matchHalfTimeScore(int home, int away) {
    return 'Полувреме $home : $away';
  }

  @override
  String get matchContinue => 'Продължи';

  @override
  String get matchContinuing => 'Продължава…';

  @override
  String matchTacticsWithSubs(int used, int max) {
    return 'Тактика · $used/$max смени';
  }

  @override
  String matchTiredCount(int count) {
    return 'УМОРЕНИ ×$count';
  }

  @override
  String get matchTacticsLabel => 'ТАКТИКА';

  @override
  String get teamOverallOverTime => 'ОБЩ РЕЙТИНГ ПО ГОДИНИ';

  @override
  String get teamOverall => 'Общ рейтинг';

  @override
  String get teamTalkHeading => 'РАЗГОВОР С ОТБОРА';

  @override
  String get teamTalkPrompt => 'Задай тона за второто полувреме.';

  @override
  String get teamTalkCalmLabel => 'Спокойствие';

  @override
  String get teamTalkCalmBlurb => 'Успокой отбора. Малък подем във всичко.';

  @override
  String get teamTalkEncourageLabel => 'Насърчи';

  @override
  String get teamTalkEncourageBlurb => 'Напред и към победата.';

  @override
  String get teamTalkDemandMoreLabel => 'Искай повече';

  @override
  String get teamTalkDemandMoreBlurb =>
      'Дай всичко от себе си. Атакувай яростно.';

  @override
  String get teamTalkPraiseLabel => 'Стегнато';

  @override
  String get teamTalkPraiseBlurb => 'Бъдете компактни и пазете постигнатото.';

  @override
  String get teamTalkBelieveLabel => 'Вярвай';

  @override
  String get teamTalkBelieveBlurb =>
      'Повярвайте в себе си. Подем в защита и в атака.';

  @override
  String get teamTalkFocusLabel => 'Бъди нащрек';

  @override
  String get teamTalkFocusBlurb => 'Пълна концентрация. Заключи мача.';

  @override
  String get teamTalkUrgencyLabel => 'Чувство за неотложност';

  @override
  String get teamTalkUrgencyBlurb =>
      'Натискай веднага. Всичко или нищо, но остават пролуки.';

  @override
  String get teamTalkReassureLabel => 'Без напрежение';

  @override
  String get teamTalkReassureBlurb => 'Успокой нервите и пази структурата.';

  @override
  String get commonRetry => 'Опитай пак';

  @override
  String get commonSomethingWentWrong => 'Нещо се обърка';

  @override
  String get commonCrashBox =>
      'Тук нещо се обърка.\nНастройки → Диагностика има подробности.';

  @override
  String hubCouldNotAdvance(String error) {
    return 'Светът не можа да продължи напред: $error';
  }

  @override
  String get settingsDiagnosticsTitle => 'Диагностика';

  @override
  String get settingsDiagnosticsBlurb =>
      'Грешките, записани на това устройство. Нищо не се изпраща никъде.';

  @override
  String get settingsContactTitle => 'Контакт';

  @override
  String get settingsContactCopied => 'Адресът е копиран.';

  @override
  String get settingsCommunityTitle => 'Общност';

  @override
  String get settingsDiscordSubtitle => 'Присъедини се към общността';

  @override
  String get settingsLinkCopied => 'Връзката е копирана.';

  @override
  String get diagnosticsEmpty => 'Няма записани грешки. Така и трябва.';

  @override
  String get diagnosticsCopy => 'Копирай';

  @override
  String get diagnosticsCopied => 'Дневникът е копиран в клипборда.';

  @override
  String get diagnosticsClear => 'Изчисти';

  @override
  String get navHub => 'Начало';

  @override
  String get navSquad => 'Състав';

  @override
  String get navStandings => 'Класиране';

  @override
  String get navCareers => 'Моята кариера';

  @override
  String get settingsTitle => 'НАСТРОЙКИ';

  @override
  String get settingsSoundHapticsTitle => 'Звук и вибрация';

  @override
  String get settingsSoundHapticsBlurb =>
      'Вибрация и кратък тон при гол, начален удар и краен резултат.';

  @override
  String get settingsMatchSoundTitle => 'Звук от стадиона';

  @override
  String get settingsMatchSoundBlurb =>
      'Публиката и свирката на съдията по време на мачовете.';

  @override
  String get settingsMatchSoundVolume => 'Сила на звука';

  @override
  String get settingsLanguageTitle => 'Език';

  @override
  String get settingsLanguageBlurb =>
      'Избери езика на приложението или следвай устройството.';

  @override
  String get settingsLanguageSystem => 'Системен';

  @override
  String get settingsTextSizeTitle => 'Размер на текста';

  @override
  String get settingsTextSizeBlurb => 'Увеличете текста, ако се чете трудно.';

  @override
  String get settingsTextSizeNormal => 'Нормален';

  @override
  String get settingsTextSizeLarge => 'Голям';

  @override
  String get settingsTextSizeLarger => 'По-голям';

  @override
  String get matchPreviewAllMeetings => 'Всички срещи';

  @override
  String get recordsMeetings => 'СРЕЩИ';

  @override
  String get recordsLegends => 'ЛЕГЕНДИ';

  @override
  String get recordsAllTimeXi => 'СЪСТАВ ЗА ВСИЧКИ ВРЕМЕНА';

  @override
  String get recordsHallOfFame => 'ЗАЛА НА СЛАВАТА';

  @override
  String get recordsAllTimeWorld => 'СВЕТЪТ ЗА ВСИЧКИ ВРЕМЕНА';

  @override
  String get recordsAllTimeTopScorers => 'НАЙ-ДОБРИ ВАДЕЩИ ЗА ВСИЧКИ ВРЕМЕНА';

  @override
  String get recordsMostCapped => 'НАЙ-МНОГО МАЧОВЕ';

  @override
  String get recordsMostWcStarts => 'НАЙ-МНОГО СТАРТОВЕ НА СП';

  @override
  String get recordsMostTournaments => 'НАЙ-МНОГО ТУРНИРИ';

  @override
  String get recordsRecordBook => 'КНИГА НА РЕКОРДИТЕ';

  @override
  String get recordsHeadToHead => 'ДИРЕКТНИ СРЕЩИ';

  @override
  String get recordsFiercestRival => 'НАЙ-ЖЕСТОКИЯТ СЪПЕРНИК';

  @override
  String get recordsMostCaps => 'НАЙ-МНОГО МАЧОВЕ';

  @override
  String get recordsTopScorers => 'НАЙ-ДОБРИ ВАДЕЩИ';

  @override
  String get recordsMostAssists => 'НАЙ-МНОГО АСИСТЕНЦИИ';

  @override
  String get recordsYourRecord => 'ТВОЯТ БАЛАНС';

  @override
  String get callUpHome => 'ДОМА';

  @override
  String get callUpAway => 'ГОСТИ';

  @override
  String get recordsHome => 'ДОМАКИН';

  @override
  String get recordsAway => 'ГОСТ';

  @override
  String get recordsActive => 'АКТИВЕН';

  @override
  String get recordsStillActive => 'Още играе';

  @override
  String get recordsAvg => 'ср.';

  @override
  String get recordsSelect => 'Избери';

  @override
  String get recordsVs => 'срещу';

  @override
  String get recordsDraws => 'Равни';

  @override
  String get recordsGoalsLabel => 'Голове';

  @override
  String get recordsBestFinish => 'Най-добро класиране';

  @override
  String get recordsNoFinalsYet => 'Още няма участие във финали';

  @override
  String get recordsLongestUnbeaten => 'Най-дълга серия без загуба';

  @override
  String get recordsBiggestWin => 'Най-голяма победа';

  @override
  String get recordsSeeAllMeetings => 'Виж всички срещи';

  @override
  String get recordsSaveNotFound => 'Записът не е намерен.';

  @override
  String get recordsNoMatches => 'Няма съвпадения.';

  @override
  String get recordsSearchPlayerOrNation => 'Търси играч или страна';

  @override
  String get recordsSearchNation => 'Търси страна';

  @override
  String get recordsPickTwoDifferent => 'Избери две различни страни.';

  @override
  String get recordsPlayToBuildRecord =>
      'Изиграй няколко мача и тук ще се изгради балансът ти срещу всеки съперник.';

  @override
  String get recordsTapOpponent => 'Докосни съперник за пълна статистика.';

  @override
  String get recordsEdgeUpperHand => 'Имаш надмощие';

  @override
  String get recordsEdgeTheirNumber => 'Те ти взеха мярката';

  @override
  String get recordsEdgeEven => 'Наравно';

  @override
  String get recordsAllTimeWorldSubtitle =>
      'Голмайстори и рекордьори по мачове от всички страни';

  @override
  String get recordsHeadToHeadSubtitle =>
      'Сравни всеки две страни за всички времена';

  @override
  String get recordsLegendsSubtitle =>
      'Състав за всички времена и зала на славата';

  @override
  String get recordsUnitGoals => 'гола';

  @override
  String get recordsUnitCaps => 'мача';

  @override
  String get recordsUnitStarts => 'титулярни';

  @override
  String get recordsUnitCups => 'турнира';

  @override
  String get recordsUnitAssists => 'асистенции';

  @override
  String recordsCapsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count мача',
      one: '$count мач',
    );
    return '$_temp0';
  }

  @override
  String recordsGoalsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count гола',
      one: '$count гол',
    );
    return '$_temp0';
  }

  @override
  String recordsAssistsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count асистенции',
      one: '$count асистенция',
    );
    return '$_temp0';
  }

  @override
  String recordsMotmCount(int count) {
    return '$count× играч на мача';
  }

  @override
  String recordsMatchesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count мача',
      one: '$count мач',
    );
    return '$_temp0';
  }

  @override
  String recordsMeetingsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count срещи',
      one: '$count среща',
    );
    return '$_temp0';
  }

  @override
  String recordsCodeWins(String code) {
    return 'Победи: $code';
  }

  @override
  String recordsMeetingsWdl(int meetings, int wins, int draws, int losses) {
    String _temp0 = intl.Intl.pluralLogic(
      meetings,
      locale: localeName,
      other: '$meetings срещи',
      one: '1 среща',
    );
    return '$_temp0 · $winsП $drawsР $lossesЗ';
  }

  @override
  String recordsWdl(int wins, int draws, int losses) {
    return '$winsП $drawsР $lossesЗ';
  }

  @override
  String recordsRivalLine(int meetings, String record, String edge) {
    String _temp0 = intl.Intl.pluralLogic(
      meetings,
      locale: localeName,
      other: '$meetings срещи',
      one: '1 среща',
    );
    return '$_temp0 · $record · $edge';
  }

  @override
  String recordsNeverMet(String a, String b) {
    return '$a и $b не са се срещали в този запис.';
  }

  @override
  String tacticsSentOffNote(String names) {
    return '$names: изгонен. Без замяна, играеш с човек по-малко.';
  }

  @override
  String tacticsNeedFitPlayers(int required, int have) {
    return 'Нужни са $required налични ($have годни)';
  }

  @override
  String tacticsMissesOfCamp(int missed, int total) {
    return 'Пропуска $missed/$total';
  }

  @override
  String get tacticsOutForWholeCamp => 'Отпаднал за цялото повикване';

  @override
  String get rankingCentreOnMe => 'Покажи моята страна';

  @override
  String get recordsAfterExtraTime => 'след прод.';

  @override
  String recordsOnPenalties(int a, int b) {
    return '$a–$b дузпи';
  }

  @override
  String recordsVersus(String a, String b) {
    return '$a срещу $b';
  }

  @override
  String recordsPlayedScore(int played, int gf, int ga) {
    String _temp0 = intl.Intl.pluralLogic(
      played,
      locale: localeName,
      other: '$played мача',
      one: '$played мач',
    );
    return '$_temp0 · $gf–$ga';
  }

  @override
  String recordsBiggestWinValue(int gf, int ga, String opp) {
    return '$gf–$ga срещу $opp';
  }

  @override
  String recordsCouldNotLoad(String error) {
    return 'Не можа да се зареди.\n$error';
  }

  @override
  String recordsCouldNotLoadLegends(String error) {
    return 'Легендите не можаха да се заредят.\n$error';
  }

  @override
  String recordsCouldNotLoadRecords(String error) {
    return 'Рекордите не можаха да се заредят.\n$error';
  }

  @override
  String recordsCouldNotLoadNations(String error) {
    return 'Страните не можаха да се заредят.\n$error';
  }

  @override
  String recordsCouldNotLoadYourRecord(String error) {
    return 'Балансът ти не можа да се зареди.\n$error';
  }

  @override
  String recordsCouldNotLoadRecord(String error) {
    return 'Балансът не можа да се зареди.\n$error';
  }

  @override
  String recordsNoLegends(String nation) {
    return 'Още няма легенди. Изиграй няколко кампании и великите от $nation ще се появят тук.';
  }

  @override
  String recordsGreatestSide(String nation) {
    return 'Най-силният състав на $nation за всички времена.';
  }

  @override
  String get recordsNoWorldHistory =>
      'Светът още няма история. Изиграй няколко кампании и великите на всички времена ще се появят тук.';

  @override
  String recordsPlayToWriteHistory(String nation) {
    return 'Изиграй няколко мача, за да започнеш да пишеш историята на $nation.';
  }

  @override
  String get tacticsLineGk => 'ВР';

  @override
  String get tacticsLineDef => 'ЗА';

  @override
  String get tacticsLineMid => 'ПЗ';

  @override
  String get tacticsLineFwd => 'НП';

  @override
  String get tacticsGoalkeepers => 'ВРАТАРИ';

  @override
  String get tacticsDefenders => 'ЗАЩИТНИЦИ';

  @override
  String get tacticsMidfielders => 'ПОЛУЗАЩИТНИЦИ';

  @override
  String get tacticsForwards => 'НАПАДАТЕЛИ';

  @override
  String get tacticsCallUpsTitle => 'ПОВИКВАНИЯ';

  @override
  String tacticsPickAtLeastPlayers(int min) {
    return 'Избери поне $min играча.';
  }

  @override
  String tacticsCouldNotLoadSquad(String error) {
    return 'Съставът не можа да се зареди.\n$error';
  }

  @override
  String get tacticsNoSquad => 'Няма състав.';

  @override
  String tacticsSquadCount(int count, int max) {
    return 'СЪСТАВ · $count/$max';
  }

  @override
  String tacticsMinMax(int min, int max) {
    return 'Мин. $min · Макс. $max';
  }

  @override
  String get tacticsBestQuality => 'Най-доброто качество';

  @override
  String get tacticsPreviousSquad => 'Предишен състав';

  @override
  String get tacticsSquadLockedBack => 'Назад (съставът е заключен)';

  @override
  String get tacticsConfirmSquad => 'Потвърди състава';

  @override
  String tacticsSquadFullMax(int max) {
    return 'Съставът е пълен (макс. $max)';
  }

  @override
  String get tacticsSquadLocked => 'СЪСТАВЪТ Е ЗАКЛЮЧЕН';

  @override
  String get tacticsNominationOpen => 'ОБЯВЯВАНЕТО Е ОТВОРЕНО. ИЗБЕРИ СЪСТАВА';

  @override
  String get tacticsSquadFixedBlurb =>
      'Този състав е фиксиран за мачовете по-долу. Избери отново преди следващия прозорец за обявяване.';

  @override
  String get tacticsSquadWillPlayBlurb =>
      'Този състав ще играе мачовете по-долу.';

  @override
  String get tacticsUnknown => 'Неизвестна';

  @override
  String tacticsAgeValue(int age, String value) {
    return '$age г. · $value';
  }

  @override
  String get tacticsFatigueExhausted => 'Изтощен';

  @override
  String get tacticsFatigueTired => 'Уморен';

  @override
  String get tacticsFatigueMatchLegs => 'Мачова умора';

  @override
  String tacticsTooManySubs(int max) {
    return 'Твърде много смени (макс. $max).';
  }

  @override
  String tacticsMinuteTitle(int minute) {
    return 'ТАКТИКА · $minute\'';
  }

  @override
  String get tacticsApply => 'ПРИЛОЖИ';

  @override
  String get tacticsTabLineupSubs => 'СЪСТАВ И СМЕНИ';

  @override
  String get tacticsTabTactics => 'ТАКТИКА';

  @override
  String get squadLineKeepers => 'ВРАТАРИ';

  @override
  String get squadLineDefenders => 'ЗАЩИТА';

  @override
  String get squadLineMidfielders => 'ПОЛУЗАЩИТА';

  @override
  String get squadLineForwards => 'АТАКА';

  @override
  String get squadStatXiRating => 'Оценка на стартовия';

  @override
  String get squadStatAvgAge => 'Ср. възраст';

  @override
  String get squadStatSize => 'Състав';

  @override
  String get squadStatUnavailable => 'Отпаднали';

  @override
  String get squadDepthTitle => 'ДЪЛБОЧИНА ПО ЛИНИИ';

  @override
  String squadAgeShort(int age) {
    return '$age г.';
  }

  @override
  String get tacticsTabOtherPositions => 'ДРУГИ ПОЗИЦИИ';

  @override
  String get tacticsOutOfPositionNote => 'Не на своето място';

  @override
  String get tacticsNobodyElse => 'Няма кого друг да пробваш тук.';

  @override
  String get tacticsPickSomebodyFirst =>
      'Избери кой излиза и останалите от скамейката ще се появят тук, с оценката, която биха имали на това място.';

  @override
  String get tacticsTabSuitable => 'ПОДХОДЯЩИ';

  @override
  String get tacticsTabOnPitch => 'НА ТЕРЕНА';

  @override
  String tacticsSectionSuitable(int count) {
    return 'ПОДХОДЯЩИ · $count';
  }

  @override
  String get tacticsNobodySuits =>
      'Никой от скамейката не е естествен за това място, затова ето всички.';

  @override
  String tacticsSectionOnPitch(int count, int max) {
    return 'НА ТЕРЕНА · $count/$max';
  }

  @override
  String tacticsSectionAvailable(int count) {
    return 'НАЛИЧНИ · $count';
  }

  @override
  String get tacticsRowStarted => 'Титуляр';

  @override
  String tacticsRowCameOn(int minute) {
    return 'Влиза в $minute\'';
  }

  @override
  String get tacticsRowSubstitute => 'Влезе като резерва';

  @override
  String get tacticsEnergyLabel => 'ЕНЕРГИЯ';

  @override
  String tacticsPickReplacementFor(String name) {
    return 'Докосни заместник на $name или го докосни отново за отказ.';
  }

  @override
  String get tacticsSlotLostToRedCard =>
      'Червен картон ти отне това място. Премести тук съотборник, за да преместиш дупката.';

  @override
  String get tacticsSentOffShort => 'ИЗГОНЕН';

  @override
  String get tacticsFullBackLeft => 'Ляв бек';

  @override
  String get tacticsFullBackRight => 'Десен бек';

  @override
  String get tacticsFullBackUp => 'Включва се в атака';

  @override
  String get tacticsFullBackDown => 'Остава назад';

  @override
  String get tacticsFullBackOff => 'Без указание';

  @override
  String tacticsFullBackUpHint(String side) {
    return '$side: включва се в атака. Малко повече атака, малко повече риск.';
  }

  @override
  String tacticsFullBackDownHint(String side) {
    return '$side: остава назад. Малко по-сигурно, малко по-малко атака.';
  }

  @override
  String tacticsFullBackOffHint(String side) {
    return '$side: без указание, играе по плана на отбора.';
  }

  @override
  String tacticsFullBackSemantics(String side, String state) {
    return '$side, стрелка: $state';
  }

  @override
  String tacticsSubsUsed(int used, int max) {
    return 'СМЕНИ · $used/$max';
  }

  @override
  String get tacticsDragSubOn =>
      'Докосни играч на терена, за да го извадиш, или задръж и дръпни резерва върху него.';

  @override
  String get tacticsNoSubs => 'Няма налични резерви.';

  @override
  String get tacticsChooseShape => 'ИЗБЕРИ СХЕМА';

  @override
  String get tacticsFormation => 'СХЕМА';

  @override
  String get tacticsInstructions => 'УКАЗАНИЯ';

  @override
  String get tacticsDrilling => 'ТРЕНИРАНОСТ';

  @override
  String get tacticsDrillingUnplayed => 'НЕИЗПИТАНА';

  @override
  String get tacticsDrillingNew => 'НОВА';

  @override
  String get tacticsDrillingSettling => 'УСТАНОВЯВА СЕ';

  @override
  String get tacticsDrillingDrilled => 'ОТРАБОТЕНА';

  @override
  String get tacticsInstrMentality => 'Манталитет';

  @override
  String get tacticsInstrDefensive => 'Защитен';

  @override
  String get tacticsInstrAttacking => 'Атакуващ';

  @override
  String get tacticsInstrPressing => 'Пресинг';

  @override
  String get tacticsInstrLowBlock => 'Нисък блок';

  @override
  String get tacticsInstrHighPress => 'Висок пресинг';

  @override
  String get tacticsInstrTempo => 'Темпо';

  @override
  String get tacticsInstrPatient => 'Търпеливо';

  @override
  String get tacticsInstrFast => 'Бързо';

  @override
  String get tacticsInstrWidth => 'Ширина';

  @override
  String get tacticsInstrNarrow => 'Тясно';

  @override
  String get tacticsInstrWide => 'Широко';

  @override
  String get tacticsInstrDefLine => 'Защ. линия';

  @override
  String get tacticsInstrDefensiveLine => 'Защитна линия';

  @override
  String get tacticsInstrDeep => 'Ниска';

  @override
  String get tacticsInstrHigh => 'Висока';

  @override
  String get tacticsInstrDirectness => 'Директност';

  @override
  String get tacticsInstrPossession => 'Притежание';

  @override
  String get tacticsInstrDirect => 'Директна';

  @override
  String get tacticsPickGoalkeeper => 'ИЗБЕРИ ВРАТАР';

  @override
  String get tacticsPickLeftBack => 'ИЗБЕРИ ЛЯВ ЗАЩИТНИК';

  @override
  String get tacticsPickCentreBack => 'ИЗБЕРИ ЦЕНТРАЛЕН ЗАЩИТНИК';

  @override
  String get tacticsPickRightBack => 'ИЗБЕРИ ДЕСЕН ЗАЩИТНИК';

  @override
  String get tacticsPickDefensiveMid => 'ИЗБЕРИ ДЕФАНЗИВЕН ПОЛУЗАЩИТНИК';

  @override
  String get tacticsPickCentralMid => 'ИЗБЕРИ ЦЕНТРАЛЕН ПОЛУЗАЩИТНИК';

  @override
  String get tacticsPickAttackingMid => 'ИЗБЕРИ АТАКУВАЩ ПОЛУЗАЩИТНИК';

  @override
  String get tacticsPickLeftMid => 'ИЗБЕРИ ЛЯВ ПОЛУЗАЩИТНИК';

  @override
  String get tacticsPickRightMid => 'ИЗБЕРИ ДЕСЕН ПОЛУЗАЩИТНИК';

  @override
  String get tacticsPickLeftWing => 'ИЗБЕРИ ЛЯВО КРИЛО';

  @override
  String get tacticsPickRightWing => 'ИЗБЕРИ ДЯСНО КРИЛО';

  @override
  String get tacticsPickStriker => 'ИЗБЕРИ НАПАДАТЕЛ';

  @override
  String tacticsRoleOutOfPosition(String role) {
    return '$role · не на позиция';
  }

  @override
  String tacticsAgeOnly(int age) {
    return '$age г.';
  }

  @override
  String tacticsRoleAge(String role, int age) {
    return '$role · $age г.';
  }

  @override
  String get tacticsOn => 'НА ТЕРЕН';

  @override
  String get tacticsSquad => 'СЪСТАВ';

  @override
  String get tacticsTabLineup => 'СЪСТАВ';

  @override
  String get tacticsTabInstructions => 'УКАЗАНИЯ';

  @override
  String get tacticsTabRoles => 'РОЛИ';

  @override
  String get tacticsTabSetPieces => 'СТАТИЧНИ';

  @override
  String get tacticsTabRolesSetPieces => 'РОЛИ И СТАТИЧНИ';

  @override
  String get tacticsRolesSetPiecesBlurb =>
      'Дай роля на всеки титуляр. Докосни значката за дузпа (⚽) или свободен удар (▲), за да избереш изпълнител.';

  @override
  String get tacticsTooltipCallUps => 'Повиквания';

  @override
  String get tacticsTooltipPresets => 'Тактически шаблони';

  @override
  String get tacticsTooltipInstructions => 'Указания';

  @override
  String get tacticsNoTacticSet => 'Няма зададена тактика.';

  @override
  String tacticsReplaceStarters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ЗАМЕНИ $count ТИТУЛЯРИ',
      one: 'ЗАМЕНИ $count ТИТУЛЯР',
    );
    return '$_temp0';
  }

  @override
  String tacticsPlayerOut(String name, String reason) {
    return '$name: $reason';
  }

  @override
  String get tacticsOut => 'Отпаднал';

  @override
  String get tacticsTapSpotReplace =>
      'Докосни мястото му на терена, за да избереш заместник.';

  @override
  String get tacticsTapOrDrag =>
      'Докосни играч, за да го смениш, или го задръж и дръпни, за да го преместиш.';

  @override
  String get tacticsPlayerRoles => 'РОЛИ НА ИГРАЧИТЕ';

  @override
  String get tacticsRolesBlurb =>
      'Дай на играч задача: реализатор, плеймейкър, таран. Определя кой вкарва и кой създава.';

  @override
  String get tacticsSetPieceTakers => 'ИЗПЪЛНИТЕЛИ НА СТАТИЧНИ';

  @override
  String get tacticsSetPieceBlurb =>
      'Кой бие дузпите и статичните положения, или остави най-подходящия играч.';

  @override
  String get tacticsTakerAuto => 'Автоматично';

  @override
  String get tacticsTakerQuickPick => 'Най-добрите изпълнители';

  @override
  String get tacticsPenalties => 'Дузпи';

  @override
  String get tacticsCornersFreeKicks => 'Корнери и свободни удари';

  @override
  String get tacticsThrowIns => 'Тъчове';

  @override
  String get tacticsThrowInStyle => 'Стил на тъчовете';

  @override
  String get tacticsThrowInLong => 'Дълги тъчове';

  @override
  String get tacticsThrowInNeutral => 'Неутрално';

  @override
  String get tacticsThrowInDefensive => 'Сигурни тъчове';

  @override
  String get tacticsThrowInLongBlurb =>
      'Тъчовете близо до наказателното поле летят в него. Малко повече опасност, особено със силен изпълнител и високи нападатели, но топката се губи малко по-често.';

  @override
  String get tacticsThrowInNeutralBlurb =>
      'Тъчове според играта. Нищо не се променя.';

  @override
  String get tacticsThrowInDefensiveBlurb =>
      'Всеки тъч къс и сигурен. По-малко загубени топки, от които съперникът контраатакува, и малко по-малко положения.';

  @override
  String get matchGoalLongThrow => 'ДЪЛЪГ ТЪЧ';

  @override
  String get tacticsSkillFin => 'ЗАВ';

  @override
  String get tacticsSkillPas => 'ПАС';

  @override
  String tacticsRolePlayer(String name) {
    return 'РОЛЯ · $name';
  }

  @override
  String get tacticsPenaltyTaker => 'ИЗПЪЛНИТЕЛ НА ДУЗПИ';

  @override
  String get tacticsCornerFreeKickTaker =>
      'ИЗПЪЛНИТЕЛ НА КОРНЕРИ И СВОБОДНИ УДАРИ';

  @override
  String get tacticsAutomatic => 'Автоматично';

  @override
  String get tacticsLetBestSuited => 'Нека го изпълнява най-подходящият играч.';

  @override
  String get tacticsInXi => 'В СТАРТОВИЯ';

  @override
  String get tacticsTeamInstructions => 'УКАЗАНИЯ ЗА ОТБОРА';

  @override
  String get tacticsTeamInstructionsBlurb =>
      'Задай как играе отборът. Всеки лост подтиква целия състав.';

  @override
  String tacticsSavedPreset(String name) {
    return 'Запазено „$name“';
  }

  @override
  String tacticsAppliedPreset(String name) {
    return 'Приложено „$name“';
  }

  @override
  String get tacticsTacticPresets => 'ТАКТИЧЕСКИ ШАБЛОНИ';

  @override
  String get tacticsPresetsBlurb =>
      'Запази тази схема като стил за многократна употреба или приложи вече запазен.';

  @override
  String get tacticsSaveCurrentTactic => 'Запази текущата тактика';

  @override
  String tacticsCouldNotLoadPresets(String error) {
    return 'Шаблоните не можаха да се заредят.\n$error';
  }

  @override
  String get tacticsNoPresetsYet =>
      'Още няма шаблони. Докосни „Запази текущата тактика“, за да запазиш тази настройка като стил за многократна употреба.';

  @override
  String get tacticsNameThisTactic => 'Назови тази тактика';

  @override
  String get tacticsNameHint => 'напр. Висок пресинг 4-3-3';

  @override
  String get tacticsCancel => 'Отказ';

  @override
  String get tacticsSave => 'Запази';

  @override
  String get tacticsTapToAssign => 'Докосни за избор';

  @override
  String get tacticsHoldDragSub =>
      'Задръж резерва и го дръпни върху играч, за да го въведеш в игра.';

  @override
  String get hubContinue => 'Продължи';

  @override
  String get hubBrackets => 'Схеми';

  @override
  String hubCouldNotLoad(String error) {
    return 'Не можа да се зареди.\n$error';
  }

  @override
  String hubCouldNotLoadFinances(String error) {
    return 'Финансите не можаха да се заредят.\n$error';
  }

  @override
  String hubCouldNotLoadSave(String error) {
    return 'Записът не можа да се зареди.\n$error';
  }

  @override
  String get hubSaveNotFound => 'Записът не е намерен.';

  @override
  String get hubUnknown => 'Неизвестно';

  @override
  String hubWorldChampionsYear(int year) {
    return '$year СВЕТОВЕН ШАМПИОН';
  }

  @override
  String get hubCycleComplete => 'Цикълът приключи.';

  @override
  String get hubYourJob => 'ТВОЯТ ПОСТ';

  @override
  String get hubStayProject => 'Остани и продължи проекта си';

  @override
  String get hubChooseNextJob => 'ИЗБЕРИ СЛЕДВАЩИЯ СИ ПОСТ';

  @override
  String get hubOffersOnTable => 'ОФЕРТИ НА МАСАТА';

  @override
  String hubOfferSubtitle(String tier, int position) {
    return '$tier · #$position в света';
  }

  @override
  String hubContinueWith(String nation) {
    return 'Продължи с $nation';
  }

  @override
  String get hubYourNation => 'твоята страна';

  @override
  String get hubTakeTheJob => 'Приеми поста';

  @override
  String get hubFederationFinances => 'ФИНАНСИ НА ФЕДЕРАЦИЯТА';

  @override
  String get hubBudgetIntro =>
      'Първата ти задача през следващия цикъл е да определиш бюджета на федерацията и да го разпределиш между отделите.';

  @override
  String get hubStarting => 'Стартира…';

  @override
  String get hubBeginNextCycle => 'Започни следващия цикъл';

  @override
  String get hubContinueCareer => 'Продължи кариерата си';

  @override
  String get hubBackToSaves => 'Назад към записите';

  @override
  String get hubOpeningBalance => 'Начално салдо';

  @override
  String get hubCentralFunding => 'Централно финансиране';

  @override
  String get hubPrizeMoney => 'Награден фонд';

  @override
  String get hubCommercialReturn => 'Търговски приходи';

  @override
  String get hubAvailableToInvest => 'Налично за инвестиране';

  @override
  String hubReputation(String label, int rep) {
    return 'Репутация: $label ($rep)';
  }

  @override
  String get hubNationalHero => 'Национален герой';

  @override
  String get hubFinal => 'Финал';

  @override
  String get hubStageRoundOf32 => '1/16-финал';

  @override
  String get hubStageThirdPlace => 'Мач за трето място';

  @override
  String get hubEventAdvanceWorld => 'Придвижи света напред';

  @override
  String hubEventStartCycle(int year) {
    return 'Започни цикъла $year';
  }

  @override
  String hubEventWorldChampions(String nation) {
    return 'Световен шампион: $nation';
  }

  @override
  String get hubEventSetBudget => 'Определи бюджета на федерацията';

  @override
  String get hubEventSetBudgetSub =>
      'Разпредели парите за цикъла, преди да започне сезонът';

  @override
  String get hubEventNaturalization => 'Прегледай офертата за натурализация';

  @override
  String get hubEventNaturalizationSub =>
      'Чужд играч иска да смени националния си отбор с твоя';

  @override
  String get hubEventCampaignVerdict => 'Кампанията приключи: виж присъдата';

  @override
  String get hubEventCampaignComplete => 'Кампанията приключи';

  @override
  String get hubEventIntercontinentalPlayoff => 'Междуконтиненталният плейоф';

  @override
  String get hubEventWatchWcDraw => 'Гледай жребия за Световното първенство';

  @override
  String get hubEventWorldCupHere => 'Световното първенство започва';

  @override
  String get hubEventWatchFinalsDraw => 'Гледай жребия за финалите';

  @override
  String get hubEventFinalsHere => 'Финалите започват';

  @override
  String get hubEventPlayWcRound =>
      'Изиграй следващия кръг от Световното първенство';

  @override
  String hubEventPlayCupMatch(String cup) {
    return 'Изиграй следващия мач от $cup';
  }

  @override
  String get hubEventPlayNationsCupMatch =>
      'Изиграй следващия мач от Nations Cup';

  @override
  String get hubEventWatchNationsCupDraw => 'Гледай жребия за Nations Cup';

  @override
  String get hubEventWatchHostSelection => 'Гледай избора на домакин';

  @override
  String get hubEventWatchQualifyingDraw => 'Гледай жребия за квалификациите';

  @override
  String get hubEventWatchWcHostSelection =>
      'Гледай избора на домакин на Световното първенство';

  @override
  String get hubEventWatchWcQualifyingDraw =>
      'Гледай жребия за квалификациите за Световното първенство';

  @override
  String get hubEventArrangeFriendlies => 'Уреди контролни мачове';

  @override
  String hubEventFriendliesSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Имаш $count незапълнени прозореца за контролни мачове',
      one: 'Имаш незапълнен прозорец за контролни мачове',
    );
    return '$_temp0';
  }

  @override
  String get hubEventReshapeXi => 'Прекрои стартовия състав';

  @override
  String hubEventReshapeOutSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count от стартовия ти състав са извън игра (наказани или контузени). Избери заместници',
      one:
          '1 от стартовия ти състав е извън игра (наказан или контузен). Избери заместник',
    );
    return '$_temp0';
  }

  @override
  String hubEventReshapeShortSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Стартовият ти състав е непълен. Попълни свободните места',
      one: 'Стартовият ти състав е непълен. Попълни свободното място',
    );
    return '$_temp0';
  }

  @override
  String hubEventPlayOpponent(String opponent) {
    return 'Играй срещу $opponent';
  }

  @override
  String get hubEventContinentalFinalsFallback => 'континенталните финали';

  @override
  String get hubCallUpFriendlies => 'Обяви състава за контролните мачове';

  @override
  String get hubCallUpRequalify => 'Обяви наново състава за квалификациите';

  @override
  String get hubCallUpWorldCup => 'Обяви състава за Световното първенство';

  @override
  String get hubCallUpFinals => 'Обяви състава за финалите';

  @override
  String get hubCallUpNationsCup => 'Обяви състава за Nations Cup';

  @override
  String get hubCallUpQualifying => 'Обяви състава за квалификациите';

  @override
  String get hubCallUpGeneric => 'Обяви състава';

  @override
  String get hubHost => 'Домакин';

  @override
  String get hubGoldenBoot => 'Голмайстор';

  @override
  String hubGoldenBootValue(String name, int goals) {
    String _temp0 = intl.Intl.pluralLogic(
      goals,
      locale: localeName,
      other: '$goals гола',
      one: '$goals гол',
    );
    return '$name · $_temp0';
  }

  @override
  String get hubPens => '(дузпи)';

  @override
  String get hubNationalHub => 'ЦЕНТРАЛА НА ФЕДЕРАЦИЯТА';

  @override
  String get hubMessages => 'Съобщения';

  @override
  String get hubWorldChampions => 'СВЕТОВЕН ШАМПИОН';

  @override
  String get hubViewBracket => 'Виж схемата ›';

  @override
  String get hubBoardDelighted => 'Във възторг';

  @override
  String get hubBoardPleased => 'Доволен';

  @override
  String get hubBoardExpectingMore => 'Очаква повече';

  @override
  String get hubBoardConcerned => 'Притеснен';

  @override
  String get hubBoardJobAtRisk => 'Постът е в риск';

  @override
  String get hubBoard => 'СЪВЕТ';

  @override
  String get hubFunds => 'СРЕДСТВА';

  @override
  String hubBoardObjective(String label) {
    return 'Цел на съвета: $label';
  }

  @override
  String hubObjectiveMet(String result) {
    return 'ПОСТИГНАТА · $result';
  }

  @override
  String hubObjectiveMissed(String result) {
    return 'ПРОВАЛЕНА · $result';
  }

  @override
  String get hubNoMoreFixtures => 'Няма повече мачове този цикъл.';

  @override
  String get hubVs => 'СРЕЩУ';

  @override
  String hubWorldRank(int rank) {
    return '#$rank';
  }

  @override
  String get hubWorldRankLabel => 'Световна ранглиста';

  @override
  String get hubSquadStatus => 'СЪСТОЯНИЕ НА СЪСТАВА';

  @override
  String hubPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count играча',
      one: '$count играч',
    );
    return '$_temp0';
  }

  @override
  String get hubAvgRating => 'Ср. оценка';

  @override
  String get hubMorale => 'Морал';

  @override
  String get hubManageTeam => 'Управлявай отбора';

  @override
  String get hubGroupsToBeDrawn =>
      'Групите предстои да се теглят. Гледай жребия, за да ги разкриеш.';

  @override
  String hubGroupName(String name) {
    return 'ГРУПА $name';
  }

  @override
  String get hubTblTeam => 'ОТБОР';

  @override
  String get hubTblP => 'М';

  @override
  String get hubTblGd => 'ГР';

  @override
  String get hubTblPts => 'Т';

  @override
  String get homeSettings => 'Настройки';

  @override
  String get homeLeadTheNation => 'ВОДИ СТРАНАТА';

  @override
  String get homeYourNation => 'твоята страна';

  @override
  String get homeNewGame => 'Нова игра';

  @override
  String get homeAllSaves => 'Всички записи';

  @override
  String get homeLoadGame => 'Зареди игра';

  @override
  String get homeContinue => 'ПРОДЪЛЖИ';

  @override
  String homeRoadToWorldCup(String date, int year) {
    return '$date · Път към Световното първенство $year';
  }

  @override
  String get careerManageSaves => 'Управление на записите';

  @override
  String get careerNewGameTitle => 'НОВА ИГРА';

  @override
  String careerCouldNotLoadNation(String error) {
    return 'Страната не можа да се зареди.\n$error';
  }

  @override
  String get careerNationNotFound => 'Страната не е намерена.';

  @override
  String careerWorldRankNum(int rank) {
    return 'СВЕТОВНА РАНГЛИСТА #$rank';
  }

  @override
  String get careerManagerName => 'Име на селекционера';

  @override
  String get careerManagerNameHint => 'напр. Мартин';

  @override
  String get careerBeginsBlurb =>
      'Кариерата ти започва през септември 2026 г., по пътя към Световното първенство през 2030 г.';

  @override
  String get careerFreeCycleNote =>
      'Безплатно за един пълен четиригодишен цикъл: квалификации, континенталното ти първенство и Световното първенство, на два записа. След това едно плащане отключва безкрайни цикли.';

  @override
  String get careerStartCareer => 'Започни кариера';

  @override
  String get careersTitle => 'КАРИЕРИ';

  @override
  String get careerManagerCareer => 'Кариера като селекционер';

  @override
  String get careerManagerCareerSubtitle =>
      'Всеки цикъл, който си водил, и общият ти баланс';

  @override
  String get careerSummaryTitle => 'Обобщение на кариерата';

  @override
  String get careerSummarySubtitle =>
      'Витрината с трофеи и рекордът ти като селекционер';

  @override
  String get careerAchievements => 'Постижения';

  @override
  String get careerAchievementsSubtitle =>
      'Етапи, титли и удовлетвореност на съвета';

  @override
  String get careerChallenges => 'Предизвикателства';

  @override
  String get careerChallengesSubtitle => 'Брутални тестове за цялата кариера';

  @override
  String get careerTeamRecords => 'Отборни рекорди';

  @override
  String get careerTeamRecordsSubtitle =>
      'Най-добри голмайстори и най-много мачове за всички времена';

  @override
  String get careerMyMatches => 'Моите мачове';

  @override
  String get careerMyMatchesSubtitle => 'Всеки резултат и предстоящ мач';

  @override
  String get careerTitle => 'КАРИЕРА';

  @override
  String careerCouldNotLoadCareer(String error) {
    return 'Кариерата не можа да се зареди.\n$error';
  }

  @override
  String get careerNoCareer => 'Няма кариера.';

  @override
  String get careerTrophyCabinet => 'ВИТРИНА С ТРОФЕИ';

  @override
  String get careerTournamentHistory => 'ИСТОРИЯ НА ТУРНИРИТЕ';

  @override
  String get careerNoTournamentsYet => 'Още няма завършени турнири.';

  @override
  String get careerTeamFallback => 'Отбор';

  @override
  String careerWorldNum(int rank) {
    return 'СВЕТ #$rank';
  }

  @override
  String careerPointsNum(int points) {
    return '$points Т';
  }

  @override
  String careerSeasonNum(int season) {
    return 'СЕЗОН $season';
  }

  @override
  String get careerStatPlayedShort => 'М';

  @override
  String get careerStatsHeading => 'В ЦИФРИ';

  @override
  String get careerStatsWinRate => 'Процент победи';

  @override
  String get careerStatsGoalsFor => 'Вкарани голове';

  @override
  String get careerStatsGoalsAgainst => 'Допуснати голове';

  @override
  String get careerStatsGoalDiff => 'Гол. разлика';

  @override
  String get careerStatsCleanSheets => 'Сухи мрежи';

  @override
  String get careerStatsBiggestWin => 'Най-голяма победа';

  @override
  String get careerStatsWinStreak => 'Серия победи';

  @override
  String get careerStatsUnbeaten => 'Серия без загуба';

  @override
  String get careerStatsShootouts => 'Дузпи';

  @override
  String get careerStatsHatTricks => 'Хеттрикове';

  @override
  String get careerStatsMotms => 'Играч на мача';

  @override
  String get careerStatsBestRating => 'Най-добра оценка';

  @override
  String get careerStatWonShort => 'П';

  @override
  String get careerStatDrawnShort => 'Р';

  @override
  String get careerStatLostShort => 'З';

  @override
  String get careerStatGoalsForShort => 'ВГ';

  @override
  String get careerStatGoalsAgainstShort => 'ДГ';

  @override
  String get careerStatGoalDiffShort => 'ГР';

  @override
  String get careerNoSilverware => 'Още няма трофеи. Иди и спечели един.';

  @override
  String get careerMedalGold => 'ЗЛАТО';

  @override
  String get careerMedalSilver => 'СРЕБРО';

  @override
  String get careerMedalBronze => 'БРОНЗ';

  @override
  String careerWinnersName(String name) {
    return 'Победители: $name';
  }

  @override
  String get careerSavesTitle => 'ЗАПИСИ';

  @override
  String careerCouldNotLoadSaves(String error) {
    return 'Записите не можаха да се заредят.\n$error';
  }

  @override
  String careerSlotsCount(int used, int limit) {
    return 'СЛОТОВЕ  $used/$limit';
  }

  @override
  String get careerThisSave => 'този запис';

  @override
  String get careerSlotsFull => 'Слотовете са пълни';

  @override
  String careerSlotsUsed(int used) {
    return 'СЛОТОВЕ  $used';
  }

  @override
  String get careerSlotsUnlockMore => 'Отключи още записи';

  @override
  String get careerSlotsKeepNote =>
      'Всеки запис, който вече имаш, остава играем. Само нов запис изисква отключване.';

  @override
  String get careerNewGame => 'Нова игра';

  @override
  String get careerDeleteSaveTitle => 'Да изтрия ли записа?';

  @override
  String careerDeleteSaveBody(String label) {
    return 'Това изтрива завинаги кариерата ти $label.';
  }

  @override
  String get careerCancel => 'Отказ';

  @override
  String get careerDelete => 'Изтрий';

  @override
  String get careerNoSavesYet =>
      'Още няма записи.\nЗапочни нова игра, за да поведеш страна.';

  @override
  String get careerUnknownNation => 'Неизвестна';

  @override
  String careerPlayedMinutes(int minutes) {
    return '$minutesм';
  }

  @override
  String careerPlayedHours(int hours, int minutes) {
    return '$hoursч $minutesм';
  }

  @override
  String careerLastPlayed(String when) {
    return 'Последно играно: $when';
  }

  @override
  String get careerJustNow => 'току-що';

  @override
  String get careerYesterday => 'вчера';

  @override
  String careerMinutesAgo(int n) {
    return 'преди $n мин';
  }

  @override
  String careerHoursAgo(int n) {
    return 'преди $n ч';
  }

  @override
  String careerDaysAgo(int n) {
    return 'преди $n д';
  }

  @override
  String careerRoadToWorldCup(int year) {
    return 'Път към Световното първенство $year';
  }

  @override
  String homeNextFixture(String match, String when) {
    return 'Следва: $match, $when';
  }

  @override
  String homeCycleComplete(int year) {
    return 'Световното първенство $year приключи. Следва присъдата на ръководството.';
  }

  @override
  String homeFollowingFinals(int year) {
    return 'Световното първенство $year от трибуните';
  }

  @override
  String get careerManagerCareerTitle => 'КАРИЕРА КАТО СЕЛЕКЦИОНЕР';

  @override
  String careerCouldNotLoad(String error) {
    return 'Не можа да се зареди.\n$error';
  }

  @override
  String get careerCycleByCycle => 'ЦИКЪЛ ПО ЦИКЪЛ';

  @override
  String careerCyclesNationsLed(int cycles, int nations) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles цикъла',
      one: '1 цикъл',
    );
    String _temp1 = intl.Intl.pluralLogic(
      nations,
      locale: localeName,
      other: '$nations водени страни',
      one: '1 водена страна',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get careerStatTitles => 'Титли';

  @override
  String get careerStatPlayed => 'Мачове';

  @override
  String get careerStatWon => 'Победи';

  @override
  String get careerStatDrawn => 'Равни';

  @override
  String get careerStatLost => 'Загуби';

  @override
  String careerGoalsWinRate(
    int goalsFor,
    int goalsAgainst,
    String gd,
    int winRate,
  ) {
    return 'Голове $goalsFor–$goalsAgainst  ($gd)  ·  Победи $winRate%';
  }

  @override
  String get careerRecordResults => 'РЕКОРДНИ РЕЗУЛТАТИ';

  @override
  String get careerBestWin => 'Най-добра победа';

  @override
  String get careerWorstDefeat => 'Най-тежка загуба';

  @override
  String careerVsOpponentDate(String opponent, String date) {
    return 'срещу $opponent · $date';
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
    return '$wonП $drawnР $lostЗ  ·  ВГ $goalsFor ДГ $goalsAgainst ($gd)';
  }

  @override
  String get careerWorldCupLabel => 'Световно първенство';

  @override
  String get careerContinentalLabel => 'Континентален';

  @override
  String get messagesTitle => 'СЪОБЩЕНИЯ';

  @override
  String get messagesNoMessagesYet => 'Още няма съобщения.';

  @override
  String messagesCouldNotLoad(String error) {
    return 'Съобщенията не можаха да се заредят.\n$error';
  }

  @override
  String get messagesDone => 'Готово';

  @override
  String get messagesNext => 'Напред';

  @override
  String get rankingWorldRanking => 'СВЕТОВНА РАНГЛИСТА';

  @override
  String rankingCouldNotLoad(String error) {
    return 'Ранглистата не можа да се зареди.\n$error';
  }

  @override
  String get rankingNoRanking => 'Няма ранглиста.';

  @override
  String get rankingAll => 'ВСИЧКИ';

  @override
  String get rankingYourTeam => 'ТВОЯТ ОТБОР';

  @override
  String get rankingYourRankingOverTime => 'ТВОЕТО КЛАСИРАНЕ ПО ВРЕМЕ';

  @override
  String rankingNowRank(int rank) {
    return 'сега #$rank';
  }

  @override
  String rankingBestWorst(int best, int worst) {
    return 'най-добро #$best · най-лошо #$worst';
  }

  @override
  String get friendliesTitle => 'КОНТРОЛНИ МАЧОВЕ';

  @override
  String friendliesLoadError(String error) {
    return 'Контролните мачове не можаха да се заредят.\n$error';
  }

  @override
  String get friendliesContinue => 'Продължи';

  @override
  String friendliesArrangeIntro(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count свободни прозореца',
      one: '1 свободен прозорец',
    );
    return 'Уреди загрявка за $_temp0 преди следващия ти официален мач. Докосни съперник или го остави свободен.';
  }

  @override
  String get friendliesFree => 'Свободно';

  @override
  String matchGoalsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ГОЛА',
      one: '1 ГОЛ',
    );
    return '$_temp0';
  }

  @override
  String get matchGoalsTitle => 'ГОЛОВЕ';

  @override
  String get matchGoalsNone => 'Няма голове';

  @override
  String get matchGoalPenalty => 'ДУЗ';

  @override
  String get matchGoalSetPiece => 'СТП';

  @override
  String matchGoalAssist(String name) {
    return 'асистенция $name';
  }

  @override
  String get friendliesHome => 'ДОМА';

  @override
  String get friendliesAway => 'ГОСТИ';

  @override
  String get friendliesNoneThisWindow => 'Без контролни мачове този прозорец';

  @override
  String friendliesConfirmCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count контролни мача',
      one: '1 контролен мач',
    );
    return 'Потвърди $_temp0';
  }

  @override
  String get friendliesMonthJan => 'яну';

  @override
  String get friendliesMonthFeb => 'фев';

  @override
  String get friendliesMonthMar => 'мар';

  @override
  String get friendliesMonthApr => 'апр';

  @override
  String get friendliesMonthMay => 'май';

  @override
  String get friendliesMonthJun => 'юни';

  @override
  String get friendliesMonthJul => 'юли';

  @override
  String get friendliesMonthAug => 'авг';

  @override
  String get friendliesMonthSep => 'сеп';

  @override
  String get friendliesMonthOct => 'окт';

  @override
  String get friendliesMonthNov => 'ное';

  @override
  String get friendliesMonthDec => 'дек';

  @override
  String get resultsMyMatches => 'МОИТЕ МАЧОВЕ';

  @override
  String resultsCouldNotLoad(String error) {
    return 'Резултатите не можаха да се заредят.\n$error';
  }

  @override
  String get resultsNoFixtures => 'Няма мачове.';

  @override
  String get resultsVs => 'срещу';

  @override
  String get resultsStageQualifier => 'КВАЛИФИКАЦИЯ';

  @override
  String get resultsStageFriendly => 'КОНТРОЛА';

  @override
  String get resultsStageGroupStage => 'ГРУПОВА ФАЗА';

  @override
  String get resultsStageSemiFinal => 'ПОЛУФИНАЛ';

  @override
  String get resultsStageFinal => 'ФИНАЛ';

  @override
  String get resultsStageContinentalClash => 'CONTINENTAL CLASH';

  @override
  String get resultsStageFinalsGroup => 'ГРУПА НА ФИНАЛИТЕ';

  @override
  String get resultsStageRoundOf32 => '1/16-ФИНАЛ';

  @override
  String get resultsStageRoundOf16 => 'ОСМИНАФИНАЛ';

  @override
  String get resultsStageQuarterFinal => 'ЧЕТВЪРТФИНАЛ';

  @override
  String get resultsStageThirdPlace => 'ТРЕТО МЯСТО';

  @override
  String get matchSetupWarnCaptain =>
      'Няма избран капитан. Докосни, за да дадеш лентата на някого';

  @override
  String matchSetupWarnCaptainInjured(String name) {
    return '$name е контузен и не може да поведе отбора този път. Докосни, за да предадеш лентата';
  }

  @override
  String matchSetupWarnCaptainSuspended(String name) {
    return '$name е наказан за този мач. Докосни, за да предадеш лентата';
  }

  @override
  String matchSetupWarnCaptainDropped(String name) {
    return '$name има лентата, но не е в състава ти. Докосни, за да я предадеш';
  }

  @override
  String get matchSetupWarnSetPieces =>
      'Няма избрани изпълнители на статични положения. Докосни, за да избереш кой да излезе';

  @override
  String get matchSetupWarnBoth =>
      'Няма капитан и изпълнители на статични положения. Докосни, за да ги зададеш';

  @override
  String matchStageMatchday(int matchday) {
    return 'К $matchday';
  }

  @override
  String get squadCaptain => 'Капитан';

  @override
  String deptEffectYouth(int points) {
    return 'Талантите от академията идват с около $points по-висок общ рейтинг';
  }

  @override
  String deptEffectCommercial(String amount) {
    return '$amount обратно в края на цикъла';
  }

  @override
  String deptEffectMedical(int percent) {
    return '$percent% по-малко контузии';
  }

  @override
  String deptEffectNaturalisation(int percent) {
    return '$percent% шанс чужд играч да поиска да смени отбора';
  }

  @override
  String deptEffectBoard(int points) {
    return '+$points търпение на съвета, преди работата ти да е застрашена';
  }

  @override
  String get deptEffectNone => 'Няма ефект без финансиране';

  @override
  String get statsBestRated => 'Оценки';

  @override
  String get statsMyCareer => 'Кариера';

  @override
  String get statsBestAverageRating => 'НАЙ-ДОБРА СРЕДНА ОЦЕНКА';

  @override
  String get statsMyCareerRecord => 'ТВОЯТ РЕКОРД';

  @override
  String get statsNoRatingsRecorded => 'Още няма записани оценки от мачове.';

  @override
  String get statsGroupRecord => 'Рекорд';

  @override
  String get statsGroupRuns => 'Серии';

  @override
  String get statsGroupExtremes => 'Крайности';

  @override
  String get statsGroupSplits => 'Домакин и гост';

  @override
  String get statsGroupSquad => 'Твоите играчи';

  @override
  String get statsPlayed => 'Изиграни мачове';

  @override
  String get statsWinDrawLoss => 'Победи–равни–загуби';

  @override
  String get statsWinRate => 'Процент победи';

  @override
  String get statsGoals => 'Голове вкарани:допуснати';

  @override
  String get statsCleanSheets => 'Сухи мрежи';

  @override
  String get statsFailedToScore => 'Без вкаран гол';

  @override
  String get statsLongestWinStreak => 'Най-дълга серия победи';

  @override
  String get statsLongestUnbeaten => 'Най-дълга серия без загуба';

  @override
  String get statsLongestCleanSheets => 'Най-дълга серия със суха мрежа';

  @override
  String get statsLongestWinless => 'Най-дълга серия без победа';

  @override
  String get statsCurrentRun => 'Текуща серия без загуба';

  @override
  String get statsBiggestWin => 'Най-голяма победа';

  @override
  String get statsHeaviestDefeat => 'Най-тежка загуба';

  @override
  String get statsMostGoalsInAGame => 'Най-много голове в мач';

  @override
  String get statsShootouts => 'Дузпи: победи–загуби';

  @override
  String get statsComebackWins => 'Победи след изоставане';

  @override
  String get statsHome => 'Като домакин';

  @override
  String get statsAway => 'Като гост';

  @override
  String get statsNeutral => 'Неутрален терен';

  @override
  String get statsCompetitive => 'Официални';

  @override
  String get statsFriendlies => 'Контролни';

  @override
  String get statsHatTricks => 'Хеттрикове';

  @override
  String get statsBraces => 'Дублети';

  @override
  String get statsMotms => 'Награди за играч на мача';

  @override
  String get statsAssists => 'Асистенции';

  @override
  String get statsCards => 'Картони';

  @override
  String get statsBestRating => 'Най-добра индивидуална оценка';

  @override
  String statsAppsShort(int apps) {
    String _temp0 = intl.Intl.pluralLogic(
      apps,
      locale: localeName,
      other: '$apps мача',
      one: '$apps мач',
    );
    return '$_temp0';
  }

  @override
  String statsMotmShort(int motms) {
    return '$motms ИНМ';
  }

  @override
  String get captainArmband => 'К';

  @override
  String get captainCurrent => 'Капитан. Докосни, за да махнеш лентата';

  @override
  String get captainFitBorn => 'Роден лидер';

  @override
  String get captainFitNatural => 'Естествен капитан';

  @override
  String get captainFitCapable => 'Може да носи лентата';

  @override
  String get captainFitUnproven => 'Още не е лидер';

  @override
  String get captainNone => 'Няма избран капитан';

  @override
  String captainMoraleBoost(int morale) {
    return '+$morale морал на състава';
  }

  @override
  String get viceCaptainFirst => '1-ви заместник-капитан';

  @override
  String get viceCaptainSecond => '2-ри заместник-капитан';

  @override
  String get viceCaptainNone => 'Няма определен заместник-капитан';

  @override
  String get viceCaptainHint =>
      'Поема лентата, когато капитанът не може да играе.';

  @override
  String captainStandIn(String vice, String captain) {
    return 'Заместник-капитанът $vice извежда отбора; капитанът $captain не е на разположение';
  }

  @override
  String captainStandInUnnamed(String vice) {
    return 'Заместник-капитанът $vice извежда отбора';
  }

  @override
  String get resultsCategoryWorldCupQualifying =>
      'Квалификации за Световното първенство';

  @override
  String get resultsCategoryFriendlies => 'Контролни мачове';

  @override
  String get resultsCategoryContinentalClash => 'Continental Clash';

  @override
  String get resultsCategoryNationsCup => 'Nations Cup';

  @override
  String get resultsCategoryContinentalCup => 'Континентална купа';

  @override
  String get resultsCategoryWorldCupQualifyingShort => 'СП квалиф.';

  @override
  String get resultsCategoryContinentalQualifyingShort => 'Конт. квалиф.';

  @override
  String get resultsCategoryContinentalQualifying =>
      'Квалификации за континентална купа';

  @override
  String get resultsCategoryWorldCupFinals => 'Финали на Световното първенство';

  @override
  String get resultsRoundResults => 'РЕЗУЛТАТИ ОТ КРЪГА';

  @override
  String get resultsFriendlyInternationals =>
      'КОНТРОЛНИ МАЧОВЕ МЕЖДУ НАЦИОНАЛНИ ОТБОРИ';

  @override
  String get resultsKnockout => 'Директни елиминации';

  @override
  String resultsEarlierMatches(int count) {
    return 'По-ранни мачове ($count)';
  }

  @override
  String resultsMatchday(int matchday) {
    return 'КРЪГ $matchday';
  }

  @override
  String get resultsContinue => 'Продължи';

  @override
  String resultsGroup(String name) {
    return 'ГРУПА $name';
  }

  @override
  String get achievementsScreenTitle => 'ПОСТИЖЕНИЯ';

  @override
  String get achievementsChallengesTooltip => 'Предизвикателства';

  @override
  String get achievementsChallengesHeading => 'ПРЕДИЗВИКАТЕЛСТВА';

  @override
  String get achievementsBrutalTests => 'Брутални тестове за цялата кариера';

  @override
  String achievementsCouldNotLoad(String error) {
    return 'Не можа да се зареди.\n$error';
  }

  @override
  String achievementsUnlockedCount(int earned, int total) {
    return '$earned / $total отключени';
  }

  @override
  String achievementsConqueredCount(int done, int total) {
    return '$done / $total покорени';
  }

  @override
  String get achievementsBoardSatisfaction => 'УДОВЛЕТВОРЕНОСТ НА СЪВЕТА';

  @override
  String achievementsUnlockedBanner(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ОТКЛЮЧЕНИ ПОСТИЖЕНИЯ',
      one: 'ОТКЛЮЧЕНО ПОСТИЖЕНИЕ',
    );
    return '$_temp0';
  }

  @override
  String get achCatWins => 'Победи';

  @override
  String get achCatMatches => 'Мачове';

  @override
  String get achCatQualifications => 'Квалификации';

  @override
  String get achCatTitles => 'Титли';

  @override
  String get achCatMisc => 'Разни';

  @override
  String get achCatMega => 'Мега';

  @override
  String get achCatGoals => 'Голове';

  @override
  String get achCatStreaks => 'Серии';

  @override
  String get achTierBronze => 'Бронз';

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
      other: '$count гола',
    );
    return '$_temp0';
  }

  @override
  String achGoalsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Вкарай $count гола.',
      one: 'Вкарай 1 гол.',
    );
    return '$_temp0';
  }

  @override
  String achCleanSheets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count сухи мрежи',
    );
    return '$_temp0';
  }

  @override
  String achCleanSheetsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Запази $count сухи мрежи.',
      one: 'Запази 1 суха мрежа.',
    );
    return '$_temp0';
  }

  @override
  String get achStreakWin5 => 'Навик за победи';

  @override
  String get achStreakWin5Desc => 'Спечели пет мача поред.';

  @override
  String get achStreakWin10 => 'На вълна';

  @override
  String get achStreakWin10Desc => 'Спечели десет мача поред.';

  @override
  String get achStreakWin20 => 'Валяк';

  @override
  String get achStreakWin20Desc => 'Спечели двайсет мача поред.';

  @override
  String get achUnbeaten15 => 'Труден за побеждаване';

  @override
  String get achUnbeaten15Desc => 'Изиграй петнайсет мача без загуба.';

  @override
  String get achUnbeaten30 => 'Недосегаем';

  @override
  String get achUnbeaten30Desc => 'Изиграй трийсет мача без загуба.';

  @override
  String get achHattrick => 'Герой с хеттрик';

  @override
  String get achHattrickDesc => 'Накарай играч да вкара хеттрик.';

  @override
  String get achMotm10 => 'Отличник';

  @override
  String get achMotm10Desc => 'Събери 10 награди за играч на мача.';

  @override
  String get achMotm50 => 'Талисман';

  @override
  String get achMotm50Desc => 'Събери 50 награди за играч на мача.';

  @override
  String get achPerfect => 'Перфектната десетка';

  @override
  String get achPerfectDesc => 'Накарай играч да получи оценка 9,5+ за мач.';

  @override
  String get achShootout => 'Лед във вените';

  @override
  String get achShootoutDesc => 'Спечели пет изпълнения на дузпи.';

  @override
  String get achMassacre => 'Касапница';

  @override
  String get achMassacreDesc => 'Спечели мач с 7 или повече гола разлика.';

  @override
  String get achAnnihilation => 'Унищожение';

  @override
  String get achAnnihilationDesc => 'Спечели мач с 10 или повече гола разлика.';

  @override
  String get chTierBronze => 'Бронз';

  @override
  String get chTierSilver => 'Сребро';

  @override
  String get chTierGold => 'Злато';

  @override
  String get chTierLegendary => 'Легендарно';

  @override
  String get chFirstSteps => 'На резервната скамейка';

  @override
  String get chFirstStepsDesc => 'Бъди селекционер 5 години.';

  @override
  String get chUnbeaten10 => 'На вълна';

  @override
  String get chUnbeaten10Desc => 'Изиграй 10 официални мача без загуба.';

  @override
  String get chTwoNations => 'Ново предизвикателство';

  @override
  String get chTwoNationsDesc => 'Води 2 различни страни.';

  @override
  String get chCont1 => 'Континентален шампион';

  @override
  String get chCont1Desc => 'Спечели континентално първенство.';

  @override
  String get chNc1 => 'Победител в Nations Cup';

  @override
  String get chNc1Desc => 'Спечели Nations Cup.';

  @override
  String get chWc1 => 'Световен шампион';

  @override
  String get chWc1Desc => 'Спечели Световното първенство.';

  @override
  String get chYears25 => 'Институция';

  @override
  String get chYears25Desc => 'Бъди селекционер 25 години.';

  @override
  String get chWc3 => 'Сериен победител';

  @override
  String get chWc3Desc => 'Спечели 3 Световни първенства.';

  @override
  String get chWc5 => 'Династия';

  @override
  String get chWc5Desc => 'Спечели 5 Световни първенства.';

  @override
  String get chWc10 => 'Безсмъртен';

  @override
  String get chWc10Desc => 'Спечели 10 Световни първенства.';

  @override
  String get chWc2Teams => 'С куфар в ръка';

  @override
  String get chWc2TeamsDesc =>
      'Спечели Световното първенство с 2 различни страни.';

  @override
  String get chWc3Teams => 'Световен скитник';

  @override
  String get chWc3TeamsDesc =>
      'Спечели Световното първенство с 3 различни страни.';

  @override
  String get chWcStreak3 => 'Три поредни';

  @override
  String get chWcStreak3Desc => 'Спечели 3 Световни първенства поред.';

  @override
  String get chWcAllconf => 'Завоевател на света';

  @override
  String get chWcAllconfDesc =>
      'Спечели Световното първенство със страна от всяка конфедерация (6).';

  @override
  String get chCont5 => 'Континентален крал';

  @override
  String get chCont5Desc => 'Спечели 5 континентални първенства.';

  @override
  String get chContAll => 'Шлем от шест континента';

  @override
  String get chContAllDesc =>
      'Спечели континенталното първенство на всяка конфедерация (6).';

  @override
  String get chTreble => 'Чисто пометене';

  @override
  String get chTrebleDesc =>
      'Спечели Световното първенство, континентална титла и Nations Cup в една кариера.';

  @override
  String get chNations10 => 'Номад';

  @override
  String get chNations10Desc => 'Води 10 различни страни.';

  @override
  String get chYears100 => 'Век';

  @override
  String get chYears100Desc => 'Бъди селекционер 100 години.';

  @override
  String get chYears500 => 'Половин хилядолетие';

  @override
  String get chYears500Desc => 'Бъди селекционер 500 години.';

  @override
  String get chYears1000 => 'Вечен';

  @override
  String get chYears1000Desc => 'Бъди селекционер 1000 години.';

  @override
  String get chGrandmaster => 'Гросмайстор';

  @override
  String get chGrandmasterDesc =>
      'Спечели 3 Световни първенства И 5 континентални първенства.';

  @override
  String get chUndefeated => 'Недосегаем';

  @override
  String get chUndefeatedDesc =>
      'Спечели Световно първенство без нито една загуба.';

  @override
  String get chPerfectQual => 'Безупречен път';

  @override
  String get chPerfectQualDesc =>
      'Спечели всеки мач от квалификациите за Световното първенство.';

  @override
  String get chMinnow => 'Чудото на аутсайдера';

  @override
  String get chMinnowDesc =>
      'Спечели Световното първенство със страна извън топ 32 в света.';

  @override
  String get chGrandTour => 'Дома и в гостите';

  @override
  String get chGrandTourDesc =>
      'Спечели Световно първенство като домакин и още едно извън дома.';

  @override
  String get chUnbeaten25 => 'Стената';

  @override
  String get chUnbeaten25Desc => 'Изиграй 25 официални мача без загуба.';

  @override
  String get chGoals10k => 'Машина за голове';

  @override
  String get chGoals10kDesc => 'Вкарай 10 000 гола в кариерата.';

  @override
  String get chCleanSheets500 => 'Крепост';

  @override
  String get chCleanSheets500Desc => 'Запази 500 сухи мрежи в кариерата.';

  @override
  String get chHatTricks25 => 'Навик за хеттрикове';

  @override
  String get chHatTricks25Desc => 'Накарай играчите си да вкарат 25 хеттрика.';

  @override
  String get chWinStreak25 => 'Неумолим';

  @override
  String get chWinStreak25Desc => 'Спечели 25 мача поред.';

  @override
  String get chCont10 => 'Континентална династия';

  @override
  String get chCont10Desc => 'Спечели 10 континентални първенства.';

  @override
  String get chPcWc => 'Сериен шампион';

  @override
  String chPcWcDesc(int count) {
    return 'Спечели $count Световни първенства в този запис.';
  }

  @override
  String get chPcMajors => 'Колекционер на трофеи';

  @override
  String chPcMajorsDesc(int count) {
    return 'Спечели $count големи трофея (Световно първенство, континентално първенство, Nations Cup или Continental Clash).';
  }

  @override
  String get chPcUnbeaten => 'Желязна стена';

  @override
  String chPcUnbeatenDesc(int count) {
    return 'Изиграй $count официални мача без загуба.';
  }

  @override
  String get chPcNations => 'Пътешественик';

  @override
  String chPcNationsDesc(int count) {
    return 'Води $count различни страни.';
  }

  @override
  String get chPcYears => 'Дългият път';

  @override
  String chPcYearsDesc(int count) {
    return 'Бъди селекционер $count години.';
  }

  @override
  String achWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count победи',
      one: '1 победа',
    );
    return '$_temp0';
  }

  @override
  String achWinsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Спечели $count мача.',
      one: 'Спечели 1 мач.',
    );
    return '$_temp0';
  }

  @override
  String achMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count мача',
    );
    return '$_temp0';
  }

  @override
  String achMatchesDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Изиграй $count мача.',
      one: 'Изиграй 1 мач.',
    );
    return '$_temp0';
  }

  @override
  String get achQualWc => 'Квалификант за Световното първенство';

  @override
  String get achQualWcDesc => 'Класирай се за Световното първенство.';

  @override
  String get achQualCont => 'Континентален квалификант';

  @override
  String get achQualContDesc => 'Класирай се за континенталното си първенство.';

  @override
  String get achTitleWc => 'Световни шампиони';

  @override
  String get achTitleWcDesc => 'Спечели Световното първенство.';

  @override
  String get achTitleEuro => 'Европейски шампиони';

  @override
  String get achTitleEuroDesc => 'Спечели Европейското първенство.';

  @override
  String get achTitleCopa => 'Шампиони на Южна Америка';

  @override
  String get achTitleCopaDesc => 'Спечели Купата на Южна Америка.';

  @override
  String get achTitleAfcon => 'Африкански шампиони';

  @override
  String get achTitleAfconDesc => 'Спечели Африканското първенство.';

  @override
  String get achTitleAsia => 'Азиатски шампиони';

  @override
  String get achTitleAsiaDesc => 'Спечели Азиатското първенство.';

  @override
  String get achTitleConcacaf => 'Шампиони на Северна Америка';

  @override
  String get achTitleConcacafDesc => 'Спечели Купата на Северна Америка.';

  @override
  String get achTitleOfc => 'Шампиони на Океания';

  @override
  String get achTitleOfcDesc => 'Спечели Купата на Океания.';

  @override
  String get achTitleNations => 'Победители в Nations Cup';

  @override
  String get achTitleNationsDesc => 'Спечели Nations Cup.';

  @override
  String get achTitleClash => 'Победители в Continental Clash';

  @override
  String get achTitleClashDesc => 'Спечели Continental Clash.';

  @override
  String get achMarksman => 'Стрелец на Световното първенство';

  @override
  String get achMarksmanDesc =>
      'Накарай играч от състава да вкара 6+ гола на финалите на Световното първенство.';

  @override
  String get achSweep => 'Чисто пометене';

  @override
  String get achSweepDesc =>
      'Притежавай едновременно Световното първенство и континенталната си титла в една кариера.';

  @override
  String get achAllstar => 'Звезда на турнира';

  @override
  String get achAllstarDesc =>
      'Накарай играч да бъде включен в Отбора на турнира на Световното първенство.';

  @override
  String get achGoldenboot => 'Голмайстор';

  @override
  String get achGoldenbootDesc =>
      'Накарай отбора си да завърши като голмайстор на първенство.';

  @override
  String get achDemolition => 'Разрушение';

  @override
  String get achDemolitionDesc => 'Спечели мач с 5 или повече гола разлика.';

  @override
  String get achievementsNice => 'Супер!';

  @override
  String get achievementsHardestTests =>
      'Най-трудните изпитания за един селекционер, през цялата кариера и с много страни.';

  @override
  String get achievementsThisSave => 'ТОЗИ ЗАПИС';

  @override
  String get achievementsBrutalBadge => 'БРУТАЛНО';

  @override
  String get paywallGoPro => 'ПРЕМИНИ КЪМ UNLIMITED';

  @override
  String get paywallOneTimeUnlock => 'Еднократно отключване. Без абонамент.';

  @override
  String get paywallBenefitCarryOn =>
      'Този запис продължава точно оттам, докъдето е стигнал, с всеки мач за националния отбор, рекорд и съперничество.';

  @override
  String get paywallBenefitNoAds =>
      'Без реклами, без микротранзакции, без абонамент. Едно плащане, актуализациите са включени.';

  @override
  String get paywallBenefitSaves =>
      'Колкото искаш записи. Води фаворит и аутсайдер едновременно и виж колко различно се чете една и съща игра.';

  @override
  String get paywallBenefitEndless =>
      'Всеки цикъл оттук нататък. Избери седемнайсетгодишен днес и разбери през 2034 г. дали си познал.';

  @override
  String get paywallUnlocked => 'Unlimited е отключен. Наслаждавай се!';

  @override
  String get paywallContactingStore => 'Връзка с магазина…';

  @override
  String paywallUnlockProPriced(String price) {
    return 'Отключи Unlimited · $price';
  }

  @override
  String get paywallRestorePurchases => 'Възстанови покупките';

  @override
  String get paywallStoreUnavailable => 'Магазинът не е достъпен';

  @override
  String get paywallStoreUnavailableNote =>
      'Цената не можа да се зареди. Провери връзката си и опитай пак.';

  @override
  String get paywallTryAgain => 'Опитай пак';

  @override
  String get gateTitle => 'ПЪРВИЯТ ТИ ЦИКЪЛ ПРИКЛЮЧИ';

  @override
  String get gateLead =>
      'Четири години са един цикъл. Не е достатъчно, за да разбереш дали си бил прав.';

  @override
  String get gatePriceLead => 'Едно плащане, завинаги';

  @override
  String get gateBuy => 'КУПИ И ПРОДЪЛЖИ';

  @override
  String get gateExit => 'ИЗХОД';

  @override
  String get gateSaveTitle => 'ТОЗИ ЗАПИС ИЗИСКВА PRO';

  @override
  String get gateSaveLead =>
      'Записите след безплатния цикъл и Pro кампаниите продължават с Pro. Нищо не се губи: записът те чака точно както го остави.';

  @override
  String get careerSaveLockedNote => 'Нужен е Pro, за да продължиш този запис';

  @override
  String get federationNaturalisation => 'НАТУРАЛИЗАЦИЯ';

  @override
  String federationNaturalisedTitle(String name) {
    return '$name е натурализиран';
  }

  @override
  String federationNaturalisedBody(String name, String nation) {
    return 'Преходът на $name е завършен: играчът вече може да играе за $nation. Повикай го от избора на състава.';
  }

  @override
  String federationCouldNotLoadOffer(String error) {
    return 'Офертата не можа да се зареди.\n$error';
  }

  @override
  String get federationContinue => 'Продължи';

  @override
  String get federationOfferToSwitchAllegiance => 'ОФЕРТА ЗА СМЯНА НА ОТБОРА';

  @override
  String federationPlayerMeta(String position, int age, String nation) {
    return '$position · $age г. · от $nation';
  }

  @override
  String federationNaturalisationBlurb(
    String name,
    String playerNation,
    String sourceNation,
  ) {
    return '$name може да играе за $playerNation и е готов да бъде натурализиран. Приеми и ще може да бъде избиран; откажи и ще остане при $sourceNation.';
  }

  @override
  String get federationDecline => 'Откажи';

  @override
  String get federationNaturalise => 'Натурализирай';

  @override
  String get federationBudgetLater => 'Реши по-късно';

  @override
  String get federationSetYourBudget => 'ЗАДАЙ БЮДЖЕТА СИ';

  @override
  String federationCouldNotLoadFinances(String error) {
    return 'Финансите не можаха да се заредят.\n$error';
  }

  @override
  String get federationSaveNotFound => 'Записът не е намерен.';

  @override
  String get federationBudgetHeading => 'БЮДЖЕТ НА ФЕДЕРАЦИЯТА';

  @override
  String federationDistributeBudget(String amount) {
    return 'Раздели $amount между отделите, за да откриеш цикъла. Харчи разумно.';
  }

  @override
  String federationOverBudget(String amount) {
    return '$amount повече, отколкото разполага федерацията. Върни част';
  }

  @override
  String get federationAllocateFullBudget =>
      'Разпредели целия бюджет, за да започне цикълът.';

  @override
  String get federationConfirming => 'Потвърждаване…';

  @override
  String get federationConfirmBudget => 'Потвърди бюджета';

  @override
  String get federationFinances => 'ФИНАНСИ';

  @override
  String get federationInvestmentUpdated => 'Инвестицията е обновена.';

  @override
  String get federationDevelopment => 'РАЗВИТИЕ НА ФЕДЕРАЦИЯТА';

  @override
  String get federationProjectedAtSeasonEnd => 'ПРОГНОЗА КЪМ КРАЯ НА СЕЗОНА';

  @override
  String get federationCentralFunding => 'Централно финансиране';

  @override
  String get federationPrizeMoneySoFar => 'Награден фонд досега';

  @override
  String get federationCommercialReturn => 'Търговска възвръщаемост';

  @override
  String get federationThisSeasonLocked => 'ТОЗИ СЕЗОН (ЗАКЛЮЧЕНО)';

  @override
  String get federationInvestForNextSeason => 'ИНВЕСТИЦИЯ ЗА СЛЕДВАЩИЯ СЕЗОН';

  @override
  String get federationNextSeasonImpact => 'ЕФЕКТ ПРЕЗ СЛЕДВАЩИЯ СЕЗОН';

  @override
  String get federationSaving => 'Запазване…';

  @override
  String get federationConfirmInvestment => 'Потвърди инвестицията';

  @override
  String get federationBalance => 'БАЛАНС НА ФЕДЕРАЦИЯТА';

  @override
  String get federationCommittedToStaff => 'Отделено за щаба';

  @override
  String get federationFreeToSpend => 'Свободно за харчене';

  @override
  String get federationWagesNote =>
      'Заплатите се удържат от баланса в края на цикъла, така че тази сума вече е заделена.';

  @override
  String get federationInvestAtCeremony =>
      'Инвестирай за следващия сезон на церемонията в края на цикъла.';

  @override
  String federationLevelBadge(int level) {
    return 'Н$level';
  }

  @override
  String get federationAcademyProspects => 'Таланти от академията';

  @override
  String federationPlusOverall(int value) {
    return '+$value общ рейтинг';
  }

  @override
  String get federationInjuryRisk => 'Риск от контузии';

  @override
  String get federationNaturalisationChance => 'Шанс за натурализация';

  @override
  String get federationBoardPatience => 'Търпение на съвета';

  @override
  String get federationUnallocated => 'НЕРАЗПРЕДЕЛЕНО';

  @override
  String get nationsVitrineTitle => 'НАЦИОНАЛНА ВИТРИНА';

  @override
  String nationsCouldNotLoad(String error) {
    return 'Страната не можа да се зареди.\n$error';
  }

  @override
  String get nationsNoNation => 'Няма страна.';

  @override
  String get nationsHonours => 'ПОЧЕТНА ТАБЛИЦА';

  @override
  String get nationsRankingHistory => 'ИСТОРИЯ НА СВЕТОВНАТА РАНГЛИСТА';

  @override
  String get nationsTopScorers => 'НАЙ-ДОБРИ ГОЛМАЙСТОРИ ЗА ВСИЧКИ ВРЕМЕНА';

  @override
  String get nationsTitles => 'ТИТЛИ';

  @override
  String get nationsYourTeam => 'ТВОЯТ ОТБОР';

  @override
  String get nationsWorld => 'СВЕТ';

  @override
  String get nationsWorldCup => 'Световно първенство';

  @override
  String get nationsContinental => 'Континентално';

  @override
  String nationsAppearances(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count участия',
      one: '1 участие',
    );
    return '$_temp0';
  }

  @override
  String get nationsNotEnoughHistory =>
      'Още няма достатъчно история. Върни се след цикъл-два.';

  @override
  String nationsBestRank(int rank) {
    return 'Най-добро: #$rank';
  }

  @override
  String nationsNowRank(int rank) {
    return 'Сега: #$rank';
  }

  @override
  String get nationsNoGoals => 'Още няма отбелязани голове.';

  @override
  String get nationsGoalsAbbrev => 'гол.';

  @override
  String get nationsHosts => 'ДОМАКИНИ';

  @override
  String get nationsSelectTitle => 'ИЗБЕРИ НАЦИОНАЛЕН ОТБОР';

  @override
  String nationsCouldNotLoadNations(String error) {
    return 'Страните не можаха да се заредят.\n$error';
  }

  @override
  String get nationsNoMatch => 'Няма съвпадащи страни.';

  @override
  String get nationsSelectHeading => 'Избери национален отбор';

  @override
  String get nationsSearchHint => 'Търси държава…';

  @override
  String get nationsRank => 'РАНГ ';

  @override
  String get nationsPremium => 'PREMIUM';

  @override
  String get nationsSelect => 'ИЗБЕРИ';

  @override
  String get statsTeamRecords => 'РЕКОРДИ НА ОТБОРА';

  @override
  String get statsRecordBook => 'Книга на рекордите';

  @override
  String statsCouldNotLoadStats(String error) {
    return 'Статистиката не можа да се зареди.\n$error';
  }

  @override
  String get statsNoData => 'Няма данни.';

  @override
  String get statsTopScorers => 'НАЙ-ДОБРИ ГОЛМАЙСТОРИ';

  @override
  String get statsMostGamesPlayed => 'НАЙ-МНОГО ИЗИГРАНИ МАЧОВЕ';

  @override
  String get statsTeam => 'Отбор';

  @override
  String get statsTopScorersShort => 'Голмайстори';

  @override
  String get statsMostGames => 'Най-много мачове';

  @override
  String get statsMostGamesShort => 'Мачове';

  @override
  String get statsNoGoalsRecorded => 'Още няма отбелязани голове.';

  @override
  String get statsUnknown => 'Неизвестен';

  @override
  String get playerTitle => 'ИГРАЧ';

  @override
  String playerLoadError(String error) {
    return 'Играчът не можа да се зареди.\n$error';
  }

  @override
  String get playerNotFound => 'Играчът не е намерен.';

  @override
  String get playerClub => 'КЛУБ';

  @override
  String get playerClubRole => 'В клуба си';

  @override
  String get playerPosition => 'Позиция';

  @override
  String get playerPotential => 'Потенциал';

  @override
  String get playerAge => 'Възраст';

  @override
  String get playerValue => 'Стойност';

  @override
  String get clubFirstChoice => 'Играе всяка седмица';

  @override
  String get clubRotation => 'Ту титуляр, ту резерва';

  @override
  String get clubFringe => 'Почти не играе';

  @override
  String get clubFrozenOut => 'Не играе';

  @override
  String clubAtClub(String club, String standing) {
    return '$club: $standing';
  }

  @override
  String yWinUpset0(String opponent, String score) {
    return 'Гледам футбол от тридесет години и това не го очаквах. $opponent победен с $score.';
  }

  @override
  String yWinUpset1(String opponent, String score) {
    return 'Никой не им даваше шанс срещу $opponent. $score. Абсолютно никой.';
  }

  @override
  String yWinUpset2(String opponent, String score) {
    return '$score срещу $opponent. Върви буди съседите.';
  }

  @override
  String yWinUpset3(String opponent, String score) {
    return 'Това е нощта, която разказват на внуците си. $opponent $score.';
  }

  @override
  String yWinUpset4(String opponent, String score) {
    return '$score срещу $opponent. Както и да е станало, станало е.';
  }

  @override
  String yWinUpset5(String opponent, String score) {
    return 'На хартия всичко беше решено още преди началото. $opponent $score казва друго.';
  }

  @override
  String yWinUpset6(String opponent, String score) {
    return 'Победа над $opponent с $score. След година никой няма да вярва на този резултат.';
  }

  @override
  String yWinUpset7(String opponent, String score) {
    return '$opponent $score. Наслади се, после погледни програмата.';
  }

  @override
  String yWinUpset8(String opponent, String score) {
    return '$score срещу $opponent, а късметът ни крепеше осемдесет от деветдесетте минути.';
  }

  @override
  String yWinUpset9(String opponent, String score) {
    return 'Една вечер срещу $opponent не изтрива цяла година. $score.';
  }

  @override
  String yWinUpset10(String opponent, String score) {
    return 'Победа над $opponent с $score и сега ще ни казват, че сме вдигнали глава. Не сме.';
  }

  @override
  String yWinUpset11(String opponent, String score) {
    return '$opponent $score. Прекрасно. Питай ме пак, когато наистина има значение.';
  }

  @override
  String yWinRoutine0(String opponent, String score) {
    return 'Победа над $opponent с $score. Точно както трябва, и в това има удоволствие.';
  }

  @override
  String yWinRoutine1(String opponent, String score) {
    return '$score над $opponent. Безмилостно, а безмилостно е комплимент.';
  }

  @override
  String yWinRoutine2(String opponent, String score) {
    return '$opponent $score. Без шум, без страх, без оплаквания.';
  }

  @override
  String yWinRoutine3(String opponent, String score) {
    return 'Акуратно $score срещу $opponent. Така изглежда добър отбор в тих ден.';
  }

  @override
  String yWinRoutine4(String opponent, String score) {
    return '$score срещу $opponent. Работата е свършена, нищо не научихме.';
  }

  @override
  String yWinRoutine5(String opponent, String score) {
    return 'Победа над $opponent с $score. Трябваше да победим и победихме.';
  }

  @override
  String yWinRoutine6(String opponent, String score) {
    return 'Професионално $score над $opponent. Следващия.';
  }

  @override
  String yWinRoutine7(String opponent, String score) {
    return '$opponent изпратен с $score. Архивирай и продължавай.';
  }

  @override
  String yWinRoutine8(String opponent, String score) {
    return '$score срещу $opponent и очакват да ръкопляскаме. Задето ги победихме.';
  }

  @override
  String yWinRoutine9(String opponent, String score) {
    return 'Браво на всички, участвали в $score над $opponent, предполагам.';
  }

  @override
  String yWinRoutine10(String opponent, String score) {
    return '$opponent $score. Победата над такива отбори е минимумът, не постижение.';
  }

  @override
  String yWinRoutine11(String opponent, String score) {
    return 'Победихме $opponent с $score, но изглеждахме тромаво.';
  }

  @override
  String yWinTight0(String opponent, String score) {
    return '$score срещу $opponent и всяка минута беше заслужена.';
  }

  @override
  String yWinTight1(String opponent, String score) {
    return 'Това изискваше характер. $opponent $score.';
  }

  @override
  String yWinTight2(String opponent, String score) {
    return 'Победа над $opponent с $score по трудния начин, а той е този, който трае.';
  }

  @override
  String yWinTight3(String opponent, String score) {
    return '$score срещу $opponent. Отборите, които печелят такива мачове, са тези, които остават до юни.';
  }

  @override
  String yWinTight4(String opponent, String score) {
    return 'Нервно, грозно, но победа. $opponent $score.';
  }

  @override
  String yWinTight5(String opponent, String score) {
    return 'Победа над $opponent с $score. Вземи трите точки и никога не гледай мача отново.';
  }

  @override
  String yWinTight6(String opponent, String score) {
    return '$score. $opponent ни накара да се борим за всяка педя.';
  }

  @override
  String yWinTight7(String opponent, String score) {
    return '$opponent $score. Не е красиво. Брои се същото.';
  }

  @override
  String yWinTight8(String opponent, String score) {
    return '$score срещу $opponent и го направихме десет пъти по-трудно, отколкото беше.';
  }

  @override
  String yWinTight9(String opponent, String score) {
    return 'Не бива да се мъчим толкова срещу $opponent. $score.';
  }

  @override
  String yWinTight10(String opponent, String score) {
    return '$opponent $score. Спечелихме, но не научихме нищо хубаво за себе си.';
  }

  @override
  String yWinTight11(String opponent, String score) {
    return '$score, което ни поласка срещу $opponent.';
  }

  @override
  String yDrew0(String opponent, String score) {
    return 'Точка срещу $opponent, $score. Вземи я и продължавай.';
  }

  @override
  String yDrew1(String opponent, String score) {
    return '$score с $opponent. Има и по-лоши следобеди от този.';
  }

  @override
  String yDrew2(String opponent, String score) {
    return 'Удържахме $opponent на $score. Не всичко трябва да е история.';
  }

  @override
  String yDrew3(String opponent, String score) {
    return '$opponent $score. Точката е точка, а класирането не пита как.';
  }

  @override
  String yDrew4(String opponent, String score) {
    return '$score с $opponent. Две изпуснати точки или една спечелена. Избери си настроението.';
  }

  @override
  String yDrew5(String opponent, String score) {
    return 'Равенство срещу $opponent, $score. Никой не е щастлив, никой не е бесен.';
  }

  @override
  String yDrew6(String opponent, String score) {
    return '$opponent $score. Най-незапомнящите се деветдесет минути в годината.';
  }

  @override
  String yDrew7(String opponent, String score) {
    return 'Разделихме точките с $opponent, $score. Вървим напред.';
  }

  @override
  String yDrew8(String opponent, String score) {
    return '$score срещу $opponent. С такива равенства кампаниите тихо умират.';
  }

  @override
  String yDrew9(String opponent, String score) {
    return 'Две изпуснати точки срещу $opponent. $score. Друго име няма.';
  }

  @override
  String yDrew10(String opponent, String score) {
    return '$opponent $score. Имахме деветдесет минути и никаква идея какво да правим с тях.';
  }

  @override
  String yDrew11(String opponent, String score) {
    return '$score с $opponent, което никой няма да помни, а всички ще платят.';
  }

  @override
  String yLost0(String opponent, String score) {
    return 'Загуба с $score от $opponent. Случва се.';
  }

  @override
  String yLost1(String opponent, String score) {
    return '$opponent $score. Няма за какво да обесим когото и да е. Напред към следващия.';
  }

  @override
  String yLost2(String opponent, String score) {
    return 'Загуба с $score от $opponent, дадохме всичко. Има дни, в които това не стига.';
  }

  @override
  String yLost3(String opponent, String score) {
    return '$score от $opponent. Главите горе. Този отбор има още много.';
  }

  @override
  String yLost4(String opponent, String score) {
    return '$opponent $score. Бяхме втори и спор няма.';
  }

  @override
  String yLost5(String opponent, String score) {
    return 'Загуба с $score от $opponent. Прегрупиране.';
  }

  @override
  String yLost6(String opponent, String score) {
    return '$score от $opponent. Не е позор, но не е достатъчно.';
  }

  @override
  String yLost7(String opponent, String score) {
    return 'Загуба с $score от $opponent. Научи нещо от нея или е напразна.';
  }

  @override
  String yLost8(String opponent, String score) {
    return '$score от $opponent и не ги докоснахме с пръст.';
  }

  @override
  String yLost9(String opponent, String score) {
    return 'Загуба от $opponent, $score. Същите проблеми, същият месец, същите оправдания на път.';
  }

  @override
  String yLost10(String opponent, String score) {
    return '$opponent $score. Кога това спира да е лош късмет?';
  }

  @override
  String yLost11(String opponent, String score) {
    return 'Загуба с $score от $opponent. Такъв резултат трябва да струва нещо на някого.';
  }

  @override
  String yLostBadly0(String opponent, String score) {
    return '$score от $opponent. Една лоша вечер. Съдете отбора по цялата кампания, не по нея.';
  }

  @override
  String yLostBadly1(String opponent, String score) {
    return 'Никой не искаше това $score срещу $opponent по-малко от самите играчи.';
  }

  @override
  String yLostBadly2(String opponent, String score) {
    return '$opponent $score. Грозно и не е този отбор.';
  }

  @override
  String yLostBadly3(String opponent, String score) {
    return '$score за забравяне срещу $opponent. Следващия път ще се покажат.';
  }

  @override
  String yLostBadly4(String opponent, String score) {
    return '$score. От $opponent. Нямам думи, а на мен ми плащат да имам думи.';
  }

  @override
  String yLostBadly5(String opponent, String score) {
    return '$opponent $score. Някой трябва да отговаря за това.';
  }

  @override
  String yLostBadly6(String opponent, String score) {
    return 'Искам $score срещу $opponent изтрито от архива и от паметта.';
  }

  @override
  String yLostBadly7(String opponent, String score) {
    return 'Загуба с $score от $opponent. Такъв резултат не се замазва.';
  }

  @override
  String yLostBadly8(String opponent, String score) {
    return 'Това не беше поражение от $opponent, а капитулация. $score.';
  }

  @override
  String yLostBadly9(String opponent, String score) {
    return '$score. Срещу $opponent. Хората плащаха пари, за да гледат това.';
  }

  @override
  String yLostBadly10(String opponent, String score) {
    return '$opponent $score. Ако това не промени нещо, нищо няма да промени.';
  }

  @override
  String yLostBadly11(String opponent, String score) {
    return 'Виждал съм този отбор унижаван и преди, но $score от $opponent е ново дъно.';
  }

  @override
  String yWinUpset12(String opponent, String score) {
    return 'Победа с $score срещу $opponent. Запишете датата, ще ви питат къде сте били.';
  }

  @override
  String yWinUpset13(String opponent, String score) {
    return 'Извън съблекалнята никой не вярваше. $score срещу $opponent. Гордост е малко.';
  }

  @override
  String yWinUpset14(String opponent, String score) {
    return '$score срещу $opponent! Всички тичаха, докато не остана нищо.';
  }

  @override
  String yWinUpset15(String opponent, String score) {
    return 'Убийци на гиганти. $opponent, $score. Затова винаги идваме.';
  }

  @override
  String yWinUpset16(String opponent, String score) {
    return '$score срещу $opponent. Прогнозите току-що излетяха през прозореца.';
  }

  @override
  String yWinUpset17(String opponent, String score) {
    return 'Голям фаворит: $opponent. Краен резултат: $score за нас.';
  }

  @override
  String yWinUpset18(String opponent, String score) {
    return 'Една от изненадите на годината: $score срещу $opponent.';
  }

  @override
  String yWinUpset19(String opponent, String score) {
    return '$opponent $score. Никой не го предвиди и никой не може да го обясни.';
  }

  @override
  String yWinUpset20(String opponent, String score) {
    return '$score срещу $opponent. Прекрасно. Сега всички ще забравят колко лоша беше останалата част от годината.';
  }

  @override
  String yWinUpset21(String opponent, String score) {
    return '$score срещу $opponent и влакът вече е пълен. Аз бях в него, когато беше празен.';
  }

  @override
  String yWinUpset22(String opponent, String score) {
    return '$opponent $score. Блестящо, и пак ще намерят начин да го пропилеят.';
  }

  @override
  String yWinUpset23(String opponent, String score) {
    return 'Голяма вечер срещу $opponent, $score. Една лястовица пролет не прави.';
  }

  @override
  String yLostBadly12(String opponent, String score) {
    return '$score срещу $opponent. Боли, защото ни пука. Подкрепете ги въпреки това.';
  }

  @override
  String yLostBadly13(String opponent, String score) {
    return 'Вечер за забравяне срещу $opponent, $score. Играчите ги боли най-много.';
  }

  @override
  String yLostBadly14(String opponent, String score) {
    return '$opponent $score. Главата горе. Отборът се познава по това как отговаря на такова нещо.';
  }

  @override
  String yLostBadly15(String opponent, String score) {
    return '$score срещу $opponent. Лошо, да. Краят на света, не.';
  }

  @override
  String yLostBadly16(String opponent, String score) {
    return '$score срещу $opponent. Резултат, за който ще се говори с години, по грешните причини.';
  }

  @override
  String yLostBadly17(String opponent, String score) {
    return 'Победа за $opponent, $score. След това никой да не се изненадва следващия път.';
  }

  @override
  String yLostBadly18(String opponent, String score) {
    return 'Една от най-лошите вечери от много време: $score срещу $opponent.';
  }

  @override
  String yLostBadly19(String opponent, String score) {
    return '$opponent $score. Ще има въпроси, и с право.';
  }

  @override
  String yLostBadly20(String opponent, String score) {
    return '$score срещу $opponent. Срамно е слабо казано.';
  }

  @override
  String yLostBadly21(String opponent, String score) {
    return 'Загуба с $score от $opponent. Последният да угаси лампите.';
  }

  @override
  String yLostBadly22(String opponent, String score) {
    return '$opponent $score. Вече не се изненадвам и това ме плаши.';
  }

  @override
  String yLostBadly23(String opponent, String score) {
    return '$score. $opponent. Някой горе трябва да си обнови автобиографията тази вечер.';
  }

  @override
  String yWinRout0(String opponent, String score) {
    return '$score срещу $opponent! Такъв футбол кара цялата страна да се усмихва.';
  }

  @override
  String yWinRout1(String opponent, String score) {
    return 'Разгром над $opponent, $score. Какво представяне.';
  }

  @override
  String yWinRout2(String opponent, String score) {
    return '$score. Срещу $opponent. Тази вечер всичко се получи.';
  }

  @override
  String yWinRout3(String opponent, String score) {
    return 'Унищожение с $score срещу $opponent. Запазете репортажа, ще ви трябва.';
  }

  @override
  String yWinRout4(String opponent, String score) {
    return '$opponent $score. Това е отбор, който се наслаждава на футбола си.';
  }

  @override
  String yWinRout5(String opponent, String score) {
    return '$score срещу $opponent, а можеше и повече. Великолепно.';
  }

  @override
  String yWinRout6(String opponent, String score) {
    return '$score срещу $opponent. Резултат, на който се поглежда два пъти.';
  }

  @override
  String yWinRout7(String opponent, String score) {
    return 'Победа с $score срещу $opponent. След първия половин час мач нямаше.';
  }

  @override
  String yWinRout8(String opponent, String score) {
    return 'Краен резултат: $score срещу $opponent. Най-голямата победа от много време насам.';
  }

  @override
  String yWinRout9(String opponent, String score) {
    return '$opponent $score. Единият отбор дойде да играе, другият дори не слезе от автобуса.';
  }

  @override
  String yWinRout10(String opponent, String score) {
    return '$score. $opponent нямаше отговор на нищо.';
  }

  @override
  String yWinRout11(String opponent, String score) {
    return 'Бой: $score срещу $opponent.';
  }

  @override
  String yWinRout12(String opponent, String score) {
    return '$score срещу $opponent. Хубаво, но те едва ли са мярката.';
  }

  @override
  String yWinRout13(String opponent, String score) {
    return '$score срещу $opponent. Събудете ме, когато го направим на някой силен.';
  }

  @override
  String yWinRout14(String opponent, String score) {
    return '$opponent $score. Забавно, но съм виждал отбори да блестят така и да не печелят нищо.';
  }

  @override
  String yWinRout15(String opponent, String score) {
    return '$score и всички отново са гении. Съперникът беше $opponent.';
  }

  @override
  String yWinRout16(String opponent, String score) {
    return '$score срещу $opponent. Без еуфория, това доказва много малко.';
  }

  @override
  String yWinRout17(String opponent, String score) {
    return '$opponent $score. Радвайте се, после си спомнете как свърши последния път, когато се въодушевихме.';
  }

  @override
  String yWinShootout0(String opponent) {
    return 'Продължаваме след дузпи срещу $opponent! Стоманени нерви, всички до един.';
  }

  @override
  String yWinShootout1(String opponent) {
    return 'Дузпи срещу $opponent и издържахме. Прегърнете непознат.';
  }

  @override
  String yWinShootout2(String opponent) {
    return 'Спечелена дузпа серия срещу $opponent. Сърцето ми не издържа.';
  }

  @override
  String yWinShootout3(String opponent) {
    return 'Победа след дузпи срещу $opponent. Към следващия кръг.';
  }

  @override
  String yWinShootout4(String opponent) {
    return 'Срещу $opponent всичко се реши от бялата точка, а ние вкарахме повече.';
  }

  @override
  String yWinShootout5(String opponent) {
    return 'Спечелени дузпи срещу $opponent. По най-трудния път, но продължаваме.';
  }

  @override
  String yWinShootout6(String opponent) {
    return 'Продължаваме след дузпи срещу $opponent. Лотарията спечелена, играта забравена.';
  }

  @override
  String yWinShootout7(String opponent) {
    return 'Да биеш $opponent след дузпи след такава игра? Късмет, и всички го знаят.';
  }

  @override
  String yWinShootout8(String opponent) {
    return 'Продължаваме срещу $opponent след дузпи. Изобщо не трябваше да се стига дотам.';
  }

  @override
  String yKnockoutWin0(String opponent, String score) {
    return 'ПРОДЪЛЖАВАМЕ. $score срещу $opponent, и мечтата е жива.';
  }

  @override
  String yKnockoutWin1(String opponent, String score) {
    return 'ПОБЕДА В ЕЛИМИНАЦИИТЕ: $score срещу $opponent. Страната може да започне да вярва.';
  }

  @override
  String yKnockoutWin2(String opponent, String score) {
    return '$score срещу $opponent и към следващия кръг. Каква вечер.';
  }

  @override
  String yKnockoutWin3(String opponent, String score) {
    return '$opponent си отива у дома, $score. Напред.';
  }

  @override
  String yKnockoutWin4(String opponent, String score) {
    return 'ЕЛИМИНАЦИИ: $score срещу $opponent. Следващият кръг е факт.';
  }

  @override
  String yKnockoutWin5(String opponent, String score) {
    return 'Продължаваме: $score срещу $opponent.';
  }

  @override
  String yKnockoutWin6(String opponent, String score) {
    return '$opponent отпада, $score. Чака ни следващият кръг.';
  }

  @override
  String yKnockoutWin7(String opponent, String score) {
    return 'Победа с $score срещу $opponent. В елиминациите никой не пита как.';
  }

  @override
  String yKnockoutWin8(String opponent, String score) {
    return 'Продължаваме срещу $opponent, $score. Следващият съперник няма да е толкова любезен.';
  }

  @override
  String yKnockoutWin9(String opponent, String score) {
    return '$score срещу $opponent стига за продължаване. Следващия път ще трябва много повече.';
  }

  @override
  String yKnockoutWin10(String opponent, String score) {
    return '$opponent е вън, $score. По-скоро оцеляхме, отколкото победихме.';
  }

  @override
  String yKnockoutWin11(String opponent, String score) {
    return 'Към следващия кръг след $score срещу $opponent. Не питайте как.';
  }

  @override
  String yUpsetGap0(String opponent, int gap) {
    return 'В класацията ни деляха $gap места, а пак победихме $opponent. Великолепно.';
  }

  @override
  String yUpsetGap1(String opponent, int gap) {
    return '$opponent: $gap места над нас. И все пак победихме. Футболът е прекрасен.';
  }

  @override
  String yUpsetGap2(String opponent, int gap) {
    return 'Разлика в класацията: $gap. Резултат: победа срещу $opponent. Никога не спирайте да вярвате.';
  }

  @override
  String yUpsetGap3(String opponent, int gap) {
    return 'Разлика в класацията преди първия съдийски сигнал: $gap. Победа срещу $opponent въпреки това.';
  }

  @override
  String yUpsetGap4(String opponent, int gap) {
    return 'В световната ранглиста $opponent беше с $gap места над нас. Не и тази вечер.';
  }

  @override
  String yUpsetGap5(String opponent, int gap) {
    return 'Индекс на изненадата: $gap места в класацията между двата отбора. Победа за нас срещу $opponent.';
  }

  @override
  String yUpsetGap6(String opponent, int gap) {
    return '$gap места в класацията ни деляха от $opponent. Една вечер не стопява разликата.';
  }

  @override
  String yUpsetGap7(String opponent, int gap) {
    return '$opponent: $gap места над нас и загуба за тях. Класацията едва ще го забележи.';
  }

  @override
  String yUpsetGap8(int gap) {
    return 'Разлика в класацията: $gap. Запомнете това число следващия път, когато загубим от аутсайдер.';
  }

  @override
  String yEatWords0(String opponent) {
    return 'Бях отписал този отбор. Сбърках и никога не съм бил по-щастлив, че греша. Победа срещу $opponent.';
  }

  @override
  String yEatWords1(String opponent) {
    return 'Една порция смирение, моля. Голяма. Победата срещу $opponent беше великолепна.';
  }

  @override
  String yEatWords2(String opponent) {
    return 'Казах, че нямат нищо повече. Имаха много. Браво на всички срещу $opponent.';
  }

  @override
  String yEatWords3(String opponent) {
    return 'За протокола: не видях тази победа срещу $opponent да идва. Признание.';
  }

  @override
  String yEatWords4(String opponent) {
    return 'Добре. Казах, че ще бъдат разобличени. $opponent не успя.';
  }

  @override
  String yEatWords5(String opponent) {
    return 'Тази вечер си изяждам думите за този отбор. Победата срещу $opponent го заслужава.';
  }

  @override
  String yEatWords6(String opponent) {
    return 'Да, казах, че са свършени. Една победа срещу $opponent още не доказва, че греша.';
  }

  @override
  String yEatWords7(String opponent) {
    return 'Казват ми да си изям думите след $opponent. Ще го направя, бавно, а касовата бележка я пазя.';
  }

  @override
  String yEatWords8(String opponent) {
    return 'Победата срещу $opponent впечатли. Съмненията ми за този отбор не са изчезнали.';
  }

  @override
  String yAwayFansWin0(String nation, String score) {
    return 'Браво на $nation. $score, и заслужено от началото до края.';
  }

  @override
  String yAwayFansWin1(String nation, String score) {
    return 'Боли да го кажа, но тази вечер по-добрият беше $nation. $score. Поздравления.';
  }

  @override
  String yAwayFansWin2(String nation, String score) {
    return '$score. Шапка свалям на $nation, искаха го повече.';
  }

  @override
  String yAwayFansWin3(String nation, String score) {
    return 'Загуба с $score от $nation. Дори не знам какво да кажа.';
  }

  @override
  String yAwayFansWin4(String nation, String score) {
    return '$nation $score. Нашите трябва да се срамуват.';
  }

  @override
  String yAwayFansWin5(String nation, String score) {
    return '$score срещу $nation. Някой да ми обясни как стана това.';
  }

  @override
  String yAwayFansWin6(String nation, String score) {
    return 'Да загубиш с $score от $nation. Никога няма да го преживея.';
  }

  @override
  String yAwayFansWin7(String nation, String score) {
    return '$score срещу $nation. Късмет. Чист късмет.';
  }

  @override
  String yAwayFansWin8(String nation, String score) {
    return 'След това $score феновете на $nation ще бъдат непоносими с години. Благодаря за нищо.';
  }

  @override
  String yNeutralWin0(String nation, String opponent, String score) {
    return '$nation $score $opponent. Чудесно за футбола. Затова го обичаме.';
  }

  @override
  String yNeutralWin1(String nation, String opponent, String score) {
    return 'Какъв резултат за $nation: $score срещу $opponent. Футбол в най-добрия си вид.';
  }

  @override
  String yNeutralWin2(String nation, String opponent, String score) {
    return 'Всички неутрални тази вечер са за $nation. $score срещу $opponent!';
  }

  @override
  String yNeutralWin3(String nation, String opponent, String score) {
    return 'Резултат на кръга: $nation $score $opponent.';
  }

  @override
  String yNeutralWin4(String nation, String opponent, String score) {
    return '$nation $score $opponent. Никой не го беше заложил.';
  }

  @override
  String yNeutralWin5(String nation, String opponent, String score) {
    return 'Голям резултат: $nation $score $opponent. Класацията ще се размърда.';
  }

  @override
  String yNeutralWin6(String nation, String opponent, String score) {
    return '$nation $score $opponent. Забавно, да видим дали могат да го повторят.';
  }

  @override
  String yNeutralWin7(String nation, String opponent, String score) {
    return '$nation $score $opponent. Спечели ли $nation, или загуби $opponent?';
  }

  @override
  String yNeutralWin8(String nation, String opponent, String score) {
    return 'Сензация: $nation $score $opponent. Очаквайте много пресилени реакции.';
  }

  @override
  String yScorerHero0(String name, String opponent) {
    return '$name срещу $opponent. Ще кръщават деца на него.';
  }

  @override
  String yScorerHero1(String name, String opponent) {
    return 'Паметник на $name. Тази вечер срещу $opponent той беше всичко.';
  }

  @override
  String yScorerHero2(String name, String opponent) {
    return '$name, какъв играч. Запомнете тази вечер срещу $opponent.';
  }

  @override
  String yScorerHero3(String name, String opponent) {
    return '$name реши мача срещу $opponent. Играч на мача, без спор.';
  }

  @override
  String yScorerHero4(String name, String opponent) {
    return 'Срещу $opponent вечерта беше на $name.';
  }

  @override
  String yScorerHero5(String name, String opponent) {
    return '$name се появи, когато трябваше, срещу $opponent.';
  }

  @override
  String yScorerHero6(String name, String opponent) {
    return '$name беше блестящ срещу $opponent. Сега всяка седмица.';
  }

  @override
  String yScorerHero7(String name, String opponent) {
    return '$name спаси отбора срещу $opponent. Останалите помогнаха малко.';
  }

  @override
  String yScorerHero8(String name, String opponent) {
    return 'Без $name вечерта срещу $opponent щеше да е съвсем различна.';
  }

  @override
  String yLostShock0(String opponent, String score) {
    return '$score срещу $opponent. Инцидент. Случва се на всеки веднъж.';
  }

  @override
  String yLostShock1(String opponent, String score) {
    return 'Загуба с $score от $opponent. Отърсете се, кампанията не е свършила.';
  }

  @override
  String yLostShock2(String opponent, String score) {
    return '$opponent $score. Болезнено, но един резултат не определя този отбор.';
  }

  @override
  String yLostShock3(String opponent, String score) {
    return '$score срещу $opponent. Лош ден в офиса. Продължаваме.';
  }

  @override
  String yLostShock4(String opponent, String score) {
    return 'Загуба от $opponent, $score. Никой не го очакваше.';
  }

  @override
  String yLostShock5(String opponent, String score) {
    return '$opponent $score. Една от онези вечери, които нямат смисъл.';
  }

  @override
  String yLostShock6(String opponent, String score) {
    return '$score срещу $opponent. Загуба, която ще се помни.';
  }

  @override
  String yLostShock7(String opponent, String score) {
    return 'Победени от $opponent, $score. Сензация, както и да го погледнеш.';
  }

  @override
  String yLostShock8(String opponent, String score) {
    return '$score срещу $opponent. От такъв съперник! Недопустимо.';
  }

  @override
  String yLostShock9(String opponent, String score) {
    return 'Загуба с $score от $opponent. Искам обяснения, не оправдания.';
  }

  @override
  String yLostShock10(String opponent, String score) {
    return '$opponent $score. Национален позор, и това не е преувеличение.';
  }

  @override
  String yLostShock11(String opponent, String score) {
    return '$score срещу $opponent. Как някой горе още стои на мястото си?';
  }

  @override
  String yLostRout0(String opponent, String score) {
    return '$score срещу $opponent. Те са топ отбор. Учим се.';
  }

  @override
  String yLostRout1(String opponent, String score) {
    return 'Надиграни от $opponent, $score. Не е срамно да губиш от най-добрите.';
  }

  @override
  String yLostRout2(String opponent, String score) {
    return '$opponent $score. Урок, а от уроците се расте.';
  }

  @override
  String yLostRout3(String opponent, String score) {
    return '$score срещу $opponent. Боли, но те са едно ниво над нас.';
  }

  @override
  String yLostRout4(String opponent, String score) {
    return 'Победа за $opponent, $score. Разликата е реална и сега всички я видяха.';
  }

  @override
  String yLostRout5(String opponent, String score) {
    return '$score срещу $opponent. Чист бой.';
  }

  @override
  String yLostRout6(String opponent, String score) {
    return '$opponent $score. По-добрият отбор, и резултатът го казва.';
  }

  @override
  String yLostRout7(String opponent, String score) {
    return 'Загуба с $score от $opponent. Не е позор, но мач също нямаше.';
  }

  @override
  String yLostRout8(String opponent, String score) {
    return '$score срещу $opponent. По-добър съперник или не, така не се губи.';
  }

  @override
  String yLostRout9(String opponent, String score) {
    return '$opponent $score. Изобщо опитахме ли да се борим?';
  }

  @override
  String yLostRout10(String opponent, String score) {
    return '$score. Срещу $opponent. Като агнета на заколение.';
  }

  @override
  String yLostRout11(String opponent, String score) {
    return 'Загуба с $score от $opponent, и никой не изглеждаше притеснен.';
  }

  @override
  String yLostShootout0(String opponent) {
    return 'Отпаднахме след дузпи срещу $opponent. Дадоха всичко. Горд съм с тях.';
  }

  @override
  String yLostShootout1(String opponent) {
    return 'Дузпи срещу $opponent. Най-жестокият начин да отпаднеш. Главата горе.';
  }

  @override
  String yLostShootout2(String opponent) {
    return 'Загубена дузпа серия срещу $opponent. Никой не заслужаваше това.';
  }

  @override
  String yLostShootout3(String opponent) {
    return 'Отпаднахме след дузпи срещу $opponent. Бялата точка реши.';
  }

  @override
  String yLostShootout4(String opponent) {
    return '$opponent продължава след дузпи. Нашият турнир свършва тук.';
  }

  @override
  String yLostShootout5(String opponent) {
    return 'Загубени дузпи срещу $opponent. Пак дузпи.';
  }

  @override
  String yLostShootout6(String opponent) {
    return 'Отпаднахме след дузпи срещу $opponent. Изобщо тренираме ли ги?';
  }

  @override
  String yLostShootout7(String opponent) {
    return 'Загуба след дузпи от $opponent. Трябваше да го решим много по-рано.';
  }

  @override
  String yLostShootout8(String opponent) {
    return 'Дузпи срещу $opponent, и загубихме. Разбира се.';
  }

  @override
  String yKnockoutLoss0(String opponent, String score) {
    return 'ОТПАДНАХМЕ. $score срещу $opponent. Път, с който можем да се гордеем, свършва тук.';
  }

  @override
  String yKnockoutLoss1(String opponent, String score) {
    return 'Елиминирани от $opponent, $score. Благодарим за спомените.';
  }

  @override
  String yKnockoutLoss2(String opponent, String score) {
    return '$score срещу $opponent. Пътуването свърши, но какво пътуване.';
  }

  @override
  String yKnockoutLoss3(String opponent, String score) {
    return 'ВЪН: $score срещу $opponent. Главите горе.';
  }

  @override
  String yKnockoutLoss4(String opponent, String score) {
    return 'КРАЙ: $score срещу $opponent.';
  }

  @override
  String yKnockoutLoss5(String opponent, String score) {
    return 'Вън: $score срещу $opponent.';
  }

  @override
  String yKnockoutLoss6(String opponent, String score) {
    return '$opponent продължава, $score. Нашият турнир свърши.';
  }

  @override
  String yKnockoutLoss7(String opponent, String score) {
    return 'Елиминирани от $opponent, $score. Аутопсията започва.';
  }

  @override
  String yKnockoutLoss8(String opponent, String score) {
    return 'ОТПАДНАХМЕ. $score срещу $opponent. Друг турнир, същият край.';
  }

  @override
  String yKnockoutLoss9(String opponent, String score) {
    return '$score срещу $opponent и у дома. Никой не е изненадан.';
  }

  @override
  String yKnockoutLoss10(String opponent, String score) {
    return 'Елиминирани от $opponent, $score. До сутринта очаквайте оправдания.';
  }

  @override
  String yKnockoutLoss11(String opponent, String score) {
    return '$opponent $score. Вън, и никога не изглеждаше, че ще свърши другояче.';
  }

  @override
  String yAwayFansGloat0(String nation, String score) {
    return '$score срещу $nation. Уважение, ще се върнат по-силни.';
  }

  @override
  String yAwayFansGloat1(String nation, String score) {
    return 'Добра победа за нас, $score. Лош ден за $nation, съжалявам феновете им.';
  }

  @override
  String yAwayFansGloat2(String nation, String score) {
    return '$score. Лоша вечер за $nation, а ние използвахме шанса. Такъв е футболът.';
  }

  @override
  String yAwayFansGloat3(String nation, String score) {
    return '$score срещу $nation! Кой го очакваше? Те не.';
  }

  @override
  String yAwayFansGloat4(String nation, String score) {
    return 'Победа с $score срещу $nation. Някой да провери как са феновете им.';
  }

  @override
  String yAwayFansGloat5(String nation, String score) {
    return '$nation $score. Това отива в албума.';
  }

  @override
  String yAwayFansGloat6(String nation, String score) {
    return '$score срещу $nation. И се мислят за голям отбор.';
  }

  @override
  String yAwayFansGloat7(String nation, String score) {
    return 'Представи си да загубиш с $score от нас. Питай $nation, вече знаят.';
  }

  @override
  String yAwayFansGloat8(String nation, String score) {
    return '$nation, $score. Приятен полет към дома.';
  }

  @override
  String yNeutralLoss0(String nation, String opponent, String score) {
    return '$nation $score $opponent. Голяма вечер за $opponent, тежка за $nation.';
  }

  @override
  String yNeutralLoss1(String nation, String opponent, String score) {
    return 'Сили на феновете на $nation след $score срещу $opponent. Ще се изправят.';
  }

  @override
  String yNeutralLoss2(String nation, String opponent, String score) {
    return '$nation $score $opponent. Всеки голям отбор има такава вечер.';
  }

  @override
  String yNeutralLoss3(String nation, String opponent, String score) {
    return 'Шокът на кръга: $nation $score $opponent.';
  }

  @override
  String yNeutralLoss4(String nation, String opponent, String score) {
    return '$nation $score $opponent. Никой не го очакваше.';
  }

  @override
  String yNeutralLoss5(String nation, String opponent, String score) {
    return 'Резултат на деня: $nation $score $opponent. Сега идват въпросите към $nation.';
  }

  @override
  String yNeutralLoss6(String nation, String opponent, String score) {
    return '$nation $score $opponent. Не е случайност, ако сте следили.';
  }

  @override
  String yNeutralLoss7(String nation, String opponent, String score) {
    return '$nation $score $opponent. Някой там ще има много да обяснява.';
  }

  @override
  String yNeutralLoss8(String nation, String opponent, String score) {
    return '$nation $score $opponent. Голямо име, малко представяне.';
  }

  @override
  String yDownGap0(String opponent, int gap) {
    return '$opponent: $gap места под нас. Случва се. Продължаваме.';
  }

  @override
  String yDownGap1(int gap) {
    return 'Разлика в класацията: $gap в наша полза. Футболът не чете класации.';
  }

  @override
  String yDownGap2(String opponent, int gap) {
    return '$gap места между нас и $opponent на хартия. Не и на терена тази вечер.';
  }

  @override
  String yDownGap3(String opponent, int gap) {
    return 'Разлика в класацията преди първия съдийски сигнал: $gap в наша полза. Загуба от $opponent въпреки това.';
  }

  @override
  String yDownGap4(String opponent, int gap) {
    return 'В световната ранглиста $opponent беше с $gap места под нас. Резултат: загуба.';
  }

  @override
  String yDownGap5(String opponent, int gap) {
    return 'Индекс на изненадата: $gap места в класацията, в грешната посока, срещу $opponent.';
  }

  @override
  String yDownGap6(String opponent, int gap) {
    return '$gap места над $opponent в класацията. Загуба. Обяснете го.';
  }

  @override
  String yDownGap7(int gap) {
    return 'Загуба от отбор с $gap места под нас. Оставете това число да попие.';
  }

  @override
  String yDownGap8(String opponent, int gap) {
    return 'Разлика в класацията: $gap. Загуба от $opponent. Някой трябва да започне да брои дните.';
  }

  @override
  String yDrewHeroic0(String opponent, String score) {
    return '$score срещу $opponent! Равенство с вкус на победа.';
  }

  @override
  String yDrewHeroic1(String opponent, String score) {
    return '$score срещу $opponent. Горд съм с всеки един от тях.';
  }

  @override
  String yDrewHeroic2(String opponent, String score) {
    return '$opponent $score. Те бяха фаворит, а ние им отговорихме.';
  }

  @override
  String yDrewHeroic3(String opponent, String score) {
    return '$score с $opponent. Точка, извоювана с кръв и пот.';
  }

  @override
  String yDrewHeroic4(String opponent, String score) {
    return '$score срещу $opponent. Много добра точка.';
  }

  @override
  String yDrewHeroic5(String opponent, String score) {
    return 'Равенство $score с $opponent. Малцина очакваха каквото и да било.';
  }

  @override
  String yDrewHeroic6(String opponent, String score) {
    return 'Спряхме $opponent, $score. Резултат, върху който да градим.';
  }

  @override
  String yDrewHeroic7(String opponent, String score) {
    return '$score срещу $opponent. Точка, която никой не ни даваше.';
  }

  @override
  String yDrewHeroic8(String opponent, String score) {
    return '$score с $opponent. Добра точка, но с равенства нищо не се печели.';
  }

  @override
  String yDrewHeroic9(String opponent, String score) {
    return '$score срещу $opponent. Хубаво. Нямахме и един истински удар.';
  }

  @override
  String yDrewHeroic10(String opponent, String score) {
    return '$opponent $score. Една точка, а всички се държат, все едно сме спечелили трофея.';
  }

  @override
  String yDrewHeroic11(String opponent, String score) {
    return '$score срещу $opponent. Паркирахме автобуса и имахме късмет.';
  }

  @override
  String yDrewShame0(String opponent, String score) {
    return '$score с $opponent. Дразнещо, но все още без загуба.';
  }

  @override
  String yDrewShame1(String opponent, String score) {
    return 'Само $score с $opponent. Лош ден. Случва се.';
  }

  @override
  String yDrewShame2(String opponent, String score) {
    return '$opponent $score. Не е достатъчно добре, и играчите го знаят.';
  }

  @override
  String yDrewShame3(String opponent, String score) {
    return '$score срещу $opponent. Две изпуснати точки, нищо повече.';
  }

  @override
  String yDrewShame4(String opponent, String score) {
    return '$score с $opponent. Две точки на вятъра.';
  }

  @override
  String yDrewShame5(String opponent, String score) {
    return 'Само $score с $opponent. Лош резултат, както и да го опаковаш.';
  }

  @override
  String yDrewShame6(String opponent, String score) {
    return '$opponent $score. Равенство с вкус на загуба.';
  }

  @override
  String yDrewShame7(String opponent, String score) {
    return '$score срещу $opponent. Такива мачове трябва да ги печелим спокойно.';
  }

  @override
  String yDrewShame8(String opponent, String score) {
    return '$score с $opponent. Срамота.';
  }

  @override
  String yDrewShame9(String opponent, String score) {
    return 'Само равенство с $opponent, $score. Кой отговаря за това?';
  }

  @override
  String yDrewShame10(String opponent, String score) {
    return '$opponent $score. Ако не бием тях, кого ще бием?';
  }

  @override
  String yDrewShame11(String opponent, String score) {
    return '$score с $opponent. Феновете им празнуват равенство срещу нас. Помислете за това.';
  }

  @override
  String yTrophy0(String opponent) {
    return 'ШАМПИОНИ. $opponent. Кажи го на глас.';
  }

  @override
  String yTrophy1(String opponent) {
    return 'Спечелихме го. $opponent. Не съм добре.';
  }

  @override
  String yTrophy2(String opponent) {
    return '$opponent, и купата се връща у дома.';
  }

  @override
  String yTrophy3(String opponent) {
    return 'Всеки един от тях е легенда. $opponent.';
  }

  @override
  String yRunnerUp0(String opponent) {
    return 'Толкова близо. $opponent и медал, който никой не иска.';
  }

  @override
  String yRunnerUp1(String opponent) {
    return 'Вицешампиони на $opponent. Ще боли с години.';
  }

  @override
  String yRunnerUp2(String opponent) {
    return '$opponent: един мач от всичко.';
  }

  @override
  String yRunnerUp3(String opponent) {
    return 'Втори. На $opponent. Някой да подаде бутилката.';
  }

  @override
  String yEliminated0(String opponent) {
    return 'Отпаднахме на $opponent. Това ще боли известно време.';
  }

  @override
  String yEliminated1(String opponent) {
    return 'На $opponent свършва за нас.';
  }

  @override
  String yEliminated2(String opponent) {
    return 'Елиминирани на $opponent. Сега идва разследването.';
  }

  @override
  String yEliminated3(String opponent) {
    return 'Отпаднахме от $opponent. Някой да ми го обясни.';
  }

  @override
  String yQualified0(String opponent) {
    return 'ОТИВАМЕ НА $opponent.';
  }

  @override
  String yQualified1(String opponent) {
    return 'Класирахме се за $opponent. Вземи си отпуск от работа.';
  }

  @override
  String yQualified2(String opponent) {
    return '$opponent, идваме. Никога не е имало съмнение (имаше пълно съмнение).';
  }

  @override
  String yQualified3(String opponent) {
    return 'Напред към $opponent. Трудната част е свършена.';
  }

  @override
  String yGroupDrawn0(String opponent) {
    return 'Жребият за $opponent е изтеглен. Можеше да е по-лошо. Можеше да е много по-лошо.';
  }

  @override
  String yGroupDrawn1(String opponent) {
    return 'Значи това е жребият за $opponent. Интересно.';
  }

  @override
  String yGroupDrawn2(String opponent) {
    return 'Групите за $opponent излязоха и вече не харесвам нашата.';
  }

  @override
  String yGroupDrawn3(String opponent) {
    return 'Жребият за $opponent е теглен. Нека започне преувеличаването.';
  }

  @override
  String yHostNamed0(String opponent) {
    return '$opponent ще бъде домакин. Започвай да пестиш.';
  }

  @override
  String yHostNamed1(String opponent) {
    return 'Отива на $opponent. Предвидимо, но става.';
  }

  @override
  String yHostNamed2(String opponent) {
    return '$opponent получава турнира. Поздравления за тях, предполагам.';
  }

  @override
  String yHostNamed3(String opponent) {
    return 'Домакини потвърдени: $opponent.';
  }

  @override
  String yTournamentSoon0(String opponent) {
    return '$opponent започва скоро и не мога да си намеря място.';
  }

  @override
  String yTournamentSoon1(String opponent) {
    return 'Не след дълго до $opponent.';
  }

  @override
  String yTournamentSoon2(String opponent) {
    return '$opponent почти е тук. Обявете състава, моля.';
  }

  @override
  String yTournamentSoon3(String opponent) {
    return 'Обратното броене до $opponent вече е нетърпимо.';
  }

  @override
  String get navY => 'Y';

  @override
  String get yTitle => 'Y';

  @override
  String get yEmpty => 'Още няма какво да се каже. Изиграй мач.';

  @override
  String get yEarlierHeading => 'По-рано този цикъл';

  @override
  String get yTraitLoyalist =>
      'Подкрепя отбора каквото и да става. Бавно се обръща, бързо прощава.';

  @override
  String get yTraitCynic => 'Очаква най-лошото и се радва, когато го докажат.';

  @override
  String get yTraitNostalgic =>
      'Всичко преди е било по-добро. Мери те с мъже, които отдавна са се пенсионирали.';

  @override
  String get yTraitStatshead =>
      'Публикува цифрите и нищо друго. Почти няма настроение.';

  @override
  String get yTraitHypeman => 'Два добри резултата и вече е златно поколение.';

  @override
  String get yTraitContrarian => 'Каквото мисли залата, обратното.';

  @override
  String get yTraitDoomer => 'Ще се обърка. Винаги ще се обърка.';

  @override
  String get yProfilePosts => 'ПУБЛИКАЦИИ';

  @override
  String get yProfileEmpty => 'Още нищо от този профил.';

  @override
  String hubEventGrievance(String player) {
    return '$player иска да говори с теб';
  }

  @override
  String get hubEventGrievanceSub => 'Иска да знае къде му е мястото';

  @override
  String hubEventManagerSkills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count точки за умения за разпределяне',
      one: '1 точка за умения за разпределяне',
    );
    return '$_temp0';
  }

  @override
  String get hubEventManagerSkillsSub =>
      'Това, в което си добър, прави отбора ти по-силен';

  @override
  String get grievanceTitle => 'Дума в кабинета ти';

  @override
  String grievanceGameTime(String player) {
    return '$player е в състава, но не е докосвал топка. Иска да знае защо.';
  }

  @override
  String grievanceSquadPlace(String player) {
    return '$player не е в състава и не може да го проумее. Иска да му се каже, така или иначе.';
  }

  @override
  String grievanceRole(String player) {
    return '$player го слагат постоянно на чужда позиция и му е дошло до гуша.';
  }

  @override
  String get grievanceReassure => 'Влизаш в плановете ми';

  @override
  String get grievanceHonest => 'Зад други си, и ето защо';

  @override
  String get grievanceDismiss => 'Аз избирам отбора';

  @override
  String yScorerStar0(String name, int goals) {
    return '$name вкара $goals от тях. Никой друг не е близо.';
  }

  @override
  String yScorerStar1(String name, int goals) {
    return '$goals за $name. Той носи този отбор.';
  }

  @override
  String yScorerStar2(String name, int goals) {
    return '$name: $goals за деня. Какъв играч.';
  }

  @override
  String yScorerStar3(String name, int goals) {
    return '$goals им вкара $name. Поклони се.';
  }

  @override
  String yScorerStar4(String name, int goals) {
    return '$goals за $name, а останалите бяха пътници.';
  }

  @override
  String yScorerStar5(String name, int goals) {
    return 'Пак $name. $goals. Представи си този отбор без него.';
  }

  @override
  String yScorerStar6(String name, int goals) {
    return '$goals от $name. Един човек не бива да върши толкова.';
  }

  @override
  String yScorerStar7(String name, int goals) {
    return 'Махни $name от мача и са $goals по-малко и съвсем различен следобед.';
  }

  @override
  String yWinStreak0(int count) {
    return '$count поредни. Каквото и да се казва в съблекалнята, действа.';
  }

  @override
  String yWinStreak1(int count) {
    return 'Това са $count подред. Отборите не се озовават в такива серии случайно.';
  }

  @override
  String yWinStreak2(int count) {
    return '$count подред и продължава. Увереността се вижда от трибуните.';
  }

  @override
  String yWinStreak3(int count) {
    return 'Без загуба в $count. Питай всеки, който е треньор: това е трудната част.';
  }

  @override
  String yWinStreak4(int count) {
    return '$count подред. Наслаждавай се, докато програмата е благосклонна.';
  }

  @override
  String yWinStreak5(int count) {
    return '$count поредни и не сме побеждавали никого от значение.';
  }

  @override
  String yWinStreak6(int count) {
    return 'Серия от $count. Питай ме пак, когато я изпитат.';
  }

  @override
  String yWinStreak7(int count) {
    return '$count на един дъх. Всеки отбор има такава серия веднъж.';
  }

  @override
  String yLossStreak0(int count) {
    return '$count мача без победа. В един момент оправданията свършват.';
  }

  @override
  String yLossStreak1(int count) {
    return 'Това са $count подред, които отидоха. Вече не е случайност.';
  }

  @override
  String yLossStreak2(int count) {
    return '$count поредни загуби. Някой трябва да отговаря за това.';
  }

  @override
  String yLossStreak3(int count) {
    return 'Няма победи в $count. Личи си как играят.';
  }

  @override
  String yLossStreak4(int count) {
    return '$count без победа и същите грешки всяка седмица.';
  }

  @override
  String yLossStreak5(int count) {
    return '$count подред. Каквото и да опитват, не работи.';
  }

  @override
  String yLossStreak6(int count) {
    return '$count поредни. Това е посока, не спад.';
  }

  @override
  String yLossStreak7(int count) {
    return 'Няма победи в $count, а горе никой не е казал дума.';
  }

  @override
  String yRivalry0(String opponent, String score) {
    return '$opponent $score. Кажи каквото искаш за играта. Този мач се брои двойно.';
  }

  @override
  String yRivalry1(String opponent, String score) {
    return 'Срещу $opponent, от всички. $score. Никой тук няма да го забрави.';
  }

  @override
  String yRivalry2(String opponent, String score) {
    return '$score срещу $opponent. За този ще говорят по кръчмите.';
  }

  @override
  String yRivalry3(String opponent, String score) {
    return 'Съседи, $score. Правата за хвалба са уредени за известно време.';
  }

  @override
  String yRivalry4(String opponent, String score) {
    return '$opponent $score. Каквото и да стане тази година, има това.';
  }

  @override
  String yRivalry5(String opponent, String score) {
    return '$score срещу $opponent. Някои от нас имахме нужда от това повече от класирането.';
  }

  @override
  String yRivalry6(String opponent, String score) {
    return '$opponent $score. И те ще си го върнат следващия път, винаги го правят.';
  }

  @override
  String yRivalry7(String opponent, String score) {
    return 'Срещу $opponent, $score. Цяла година ще ни го припомнят.';
  }

  @override
  String yInjuryBlow0(String name) {
    return '$name излезе контузен. Точно това не трябваше на този отбор.';
  }

  @override
  String yInjuryBlow1(String name) {
    return 'Загубата на $name променя формата на всичко.';
  }

  @override
  String yInjuryBlow2(String name) {
    return '$name накуцва. Задръж дъха си.';
  }

  @override
  String yInjuryBlow3(String name) {
    return 'Няма $name за известно време. Някой трябва да се хване.';
  }

  @override
  String yInjuryBlow4(String name) {
    return '$name отпада. Разбира се, че е $name.';
  }

  @override
  String yInjuryBlow5(String name) {
    return 'Без $name това става много обикновен отбор.';
  }

  @override
  String yInjuryBlow6(String name) {
    return '$name пак контузен. Някой трябва да пита защо.';
  }

  @override
  String yInjuryBlow7(String name) {
    return 'Загубихме $name и зад него няма никого. Това е истинският проблем.';
  }

  @override
  String ySentOff0(String name, String minute) {
    return 'Червен за $name в $minute. минута и цялата страна се обръща срещу него. Дал ни е повече от повечето. Оставете го.';
  }

  @override
  String ySentOff1(String name, String minute) {
    return '$name излезе в $minute. минута. Строго. С десетима пак опитахме, което говори нещо.';
  }

  @override
  String ySentOff2(String name, String minute) {
    return '$name, $minute. минута, червен картон. Оттам нататък с десетима.';
  }

  @override
  String ySentOff3(String name, String minute) {
    return 'Изгонване: $name в $minute. минута. Не е първият мач, решен от едно решение.';
  }

  @override
  String ySentOff4(String name, String minute) {
    return 'Блестящо. $name излиза в $minute. минута и пак сме десет. Отново.';
  }

  @override
  String ySentOff5(String name, String minute) {
    return '$name изгонен в $minute. минута. Кой точно тук тренира дисциплината?';
  }

  @override
  String ySentOff6(String name, String minute) {
    return 'До $minute. минута издържа $name да си държи главата. Професионален футбол.';
  }

  @override
  String ySentOff7(String name, String minute) {
    return 'Червен за $name в $minute. минута, а аз трябвало да вярвам, че това е напредък.';
  }

  @override
  String get yBoardPressure0 =>
      'Съветът замлъкна. Това никога не е добър знак.';

  @override
  String get yBoardPressure1 =>
      'Говори се, че в управата са почнали да задават въпроси.';

  @override
  String get yBoardPressure2 => 'Усеща се как земята се разклаща горе.';

  @override
  String get yBoardPressure3 =>
      'Никой във федерацията не казва нищо в подкрепа. Направи си изводи.';

  @override
  String get yBoardPressure4 =>
      'Горе от седмици никой не го е защитил публично.';

  @override
  String get yBoardPressure5 =>
      'Федерацията говори срещу собствения си селекционер. Както винаги.';

  @override
  String get yBoardPressure6 => 'Когато един съвет замлъкне, вече е решил.';

  @override
  String get yBoardPressure7 =>
      'Ще оставят това да се влачи, докато стане решение на някой друг.';

  @override
  String get yReplies => 'ОЩЕ ЗА ТОЗИ МАЧ';

  @override
  String get yPlayerGrievance0 => 'Питах къде съм. Още чакам отговор.';

  @override
  String get yPlayerGrievance1 => 'Тренирам здраво. Друго не мога да направя.';

  @override
  String get yPlayerGrievance2 => 'Някои въпроси се задават само веднъж.';

  @override
  String get yPlayerGrievance3 => 'Не съм стигнал дотук, за да нося потниците.';

  @override
  String get playerHonoursTitle => 'ПОЧЕТНА ТАБЛИЦА';

  @override
  String get awardGoldenBall => 'Най-добър играч';

  @override
  String get awardGoldenBoot => 'Голмайстор';

  @override
  String get awardGoldenGlove => 'Най-добър вратар';

  @override
  String get awardTeamOfTournament => 'Отбор на турнира';

  @override
  String get awardPlayerOfYear => 'Футболист на годината в света';

  @override
  String get awardYoungPlayerOfYear => 'Млад футболист на годината';

  @override
  String get playerClubHistory => 'ИСТОРИЯ НА КЛУБОВЕТЕ';

  @override
  String get playerCareerRecord => 'КАРИЕРЕН РЕКОРД';

  @override
  String get playerInternationalGoals => 'Голове за националния отбор';

  @override
  String get playerRecentForm => 'СКОРОШНА ФОРМА';

  @override
  String get playerMatchHistory => 'ИСТОРИЯ НА МАЧОВЕТЕ';

  @override
  String get playerAttributes => 'АТРИБУТИ';

  @override
  String get playerUnknown => 'Неизвестен';

  @override
  String get playerAttrPace => 'Скорост';

  @override
  String get playerAttrPhysical => 'Физика';

  @override
  String get playerAttrTechnical => 'Техника';

  @override
  String get playerAttrShooting => 'Стрелба';

  @override
  String get playerAttrPassing => 'Подаване';

  @override
  String get playerAttrDribbling => 'Дриблиране';

  @override
  String get playerAttrTackling => 'Отнемане';

  @override
  String get playerAttrPositioning => 'Позициониране';

  @override
  String get playerAttrComposure => 'Хладнокръвие';

  @override
  String get playerAttrDecisions => 'Решения';

  @override
  String get playerAttrStamina => 'Издръжливост';

  @override
  String get playerAttrStrength => 'Сила';

  @override
  String get playerStatCaps => 'Мачове';

  @override
  String get playerStatGoals => 'Голове';

  @override
  String get playerStatAssists => 'Асистенции';

  @override
  String get playerStatAvgRating => 'Ср. оценка';

  @override
  String get playerStatForm => 'Форма';

  @override
  String get playerStatMotm => 'Играч на мача';

  @override
  String get playerStatCleanSheets => 'Сухи мрежи';

  @override
  String get playerStatBestGame => 'Най-добър мач';

  @override
  String get playerStatCards => 'Картони';

  @override
  String playerCardsValue(int yellows, int reds) {
    return '$yellowsЖ $redsЧ';
  }

  @override
  String get tourSharedYourRun => 'ТВОЯТ ПЪТ';

  @override
  String get tourSharedList => 'Списък';

  @override
  String get tourSharedBracket => 'Схема';

  @override
  String get tourSharedVs => 'срещу';

  @override
  String tourSharedGroupSeed(String seed) {
    return 'Група $seed';
  }

  @override
  String get tourSharedThisEdition => 'Това издание';

  @override
  String get tourSharedAllTime => 'За всички времена';

  @override
  String get tourSharedUnknown => 'Неизвестен';

  @override
  String get tourSharedActive => 'АКТИВЕН';

  @override
  String get tourSharedMedalTable => 'КЛАСИРАНЕ ПО МЕДАЛИ';

  @override
  String get tourSharedPastWinners => 'МИНАЛИ ПОБЕДИТЕЛИ';

  @override
  String tourSharedHost(String host) {
    return 'Домакин: $host';
  }

  @override
  String get tourSharedBeat => 'победи';

  @override
  String get tourSharedPens => ' (дузпи)';

  @override
  String get tourSharedAwardsEmpty =>
      'Наградите се решават, след като турнирът бъде изигран.';

  @override
  String get tourSharedGoldenBall => 'НАЙ-ДОБЪР ИГРАЧ';

  @override
  String get tourSharedPlayerOfTournament => 'Играч на турнира';

  @override
  String get tourSharedGoldenBoot => 'ГОЛМАЙСТОР';

  @override
  String tourSharedGoalsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count гола',
      one: '1 гол',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedGoldenGlove => 'НАЙ-ДОБЪР ВРАТАР';

  @override
  String get tourSharedTeamOfTournament => 'ОТБОР НА ТУРНИРА';

  @override
  String get tourSharedStatsEmpty =>
      'Рекордите се появяват, щом състезанието натрупа история.';

  @override
  String get tourSharedRecordScorer => 'РЕКОРДЕН ГОЛМАЙСТОР';

  @override
  String get tourSharedStillActive => 'още играе';

  @override
  String get tourSharedMostTitles => 'НАЙ-МНОГО ТИТЛИ';

  @override
  String tourSharedTitlesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count титли',
      one: '1 титла',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostFinals => 'НАЙ-МНОГО ФИНАЛИ';

  @override
  String tourSharedFinalsContested(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count изиграни финала',
      one: '1 изигран финал',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostGamesPlayed => 'НАЙ-МНОГО ИЗИГРАНИ МАЧОВЕ';

  @override
  String tourSharedMatchesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count мача',
      one: '1 мач',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostFinalsPlayed => 'НАЙ-МНОГО ИЗИГРАНИ ФИНАЛНИ ТУРНИРИ';

  @override
  String tourSharedFinalsTournamentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count финални турнира',
      one: '1 финален турнир',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedBiggestFinalWin => 'НАЙ-ГОЛЯМА ПОБЕДА НА ФИНАЛ';

  @override
  String tourStatsGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count гола',
      one: '1 гол',
    );
    return '$_temp0';
  }

  @override
  String get tourStatsStillActive => 'още играе';

  @override
  String tourStatsTitles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count титли',
      one: '1 титла',
    );
    return '$_temp0';
  }

  @override
  String tourStatsFinalsContested(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count изиграни финала',
      one: '1 изигран финал',
    );
    return '$_temp0';
  }

  @override
  String tourStatsMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count мача',
      one: '1 мач',
    );
    return '$_temp0';
  }

  @override
  String tourStatsFinalsTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count финални турнира',
      one: '1 финален турнир',
    );
    return '$_temp0';
  }

  @override
  String get tourStatsLeaders => 'ЛИДЕРИ ЗА ВСИЧКИ ВРЕМЕНА';

  @override
  String get tourStatsTabGames => 'Мачове';

  @override
  String get tourStatsTabCups => 'Купи';

  @override
  String get tourStatsTabScorers => 'Голмайстори';

  @override
  String tourSharedFinalWinDetail(String opponent, int year) {
    return 'срещу $opponent · $year';
  }

  @override
  String get tourHolders => 'ДЕРЖАТЕЛИ';

  @override
  String tourHoldersSince(int year) {
    return 'победа през $year';
  }

  @override
  String get tourSharedAllTimeScorers => 'ГОЛМАЙСТОРИ ЗА ВСИЧКИ ВРЕМЕНА';

  @override
  String get tourSharedSummaryEmpty =>
      'Домакинът и стадионите му се появяват, щом изданието бъде теглено.';

  @override
  String get tourSharedHostHeading => 'ДОМАКИН';

  @override
  String get tourSharedHostsHeading => 'ДОМАКИНИ';

  @override
  String get tourSharedCoHostsHeading => 'СЪДОМАКИНИ';

  @override
  String get tourSharedVenues => 'СТАДИОНИ';

  @override
  String get tourSharedMascot => 'ТАЛИСМАН';

  @override
  String get tourSharedMatchBall => 'ОФИЦИАЛНА ТОПКА';

  @override
  String tourSharedVenueSeats(String city, String capacity) {
    return '$city · $capacity места';
  }

  @override
  String get tourSharedCouldNotLoad => 'Не можа да се зареди.';

  @override
  String get tourSharedHostTbc => 'ДОМАКИНЪТ СЕ УТОЧНЯВА';

  @override
  String get tourSharedFinalsAreHere => 'ФИНАЛИТЕ СА ТУК';

  @override
  String tourSharedHostedBy(String hosts) {
    return 'ДОМАКИН  $hosts';
  }

  @override
  String get tourSharedLetFinalsBegin => 'Нека финалите започнат';

  @override
  String get tourSharedCompetitions => 'СЪСТЕЗАНИЯ';

  @override
  String get tourSharedWorldRanking => 'Световна ранглиста';

  @override
  String get tourSharedCouldNotLoadTournaments =>
      'Турнирите не можаха да се заредят.';

  @override
  String get tourSharedPrestigeStage => 'ПРЕСТИЖНА СЦЕНА';

  @override
  String get tourSharedOverview => 'Преглед';

  @override
  String get tourSharedWorldRankingTitle => 'Световна ранглиста';

  @override
  String get tourSharedYourCompetitions => 'ТВОИТЕ СЪСТЕЗАНИЯ';

  @override
  String get tourSharedOtherContinents => 'ДРУГИ КОНТИНЕНТИ';

  @override
  String get tourSharedComingSoon => 'Турнирът скоро идва';

  @override
  String get tourSharedSoon => 'СКОРО';

  @override
  String get tourSharedNoQualifyingDraw => 'Няма жребий за квалификациите.';

  @override
  String get tourSharedOpenEnvelope => 'Отвори плика';

  @override
  String tourSharedGroupName(String name) {
    return 'ГРУПА $name';
  }

  @override
  String get tourSharedBall => 'Топка';

  @override
  String get tourSharedPot => 'Урна';

  @override
  String get tourSharedAll => 'Всички';

  @override
  String get tourSharedTapDrawTeam => 'Докосни за следващия отбор';

  @override
  String get tourSharedTapDrawPot => 'Докосни за следващата урна';

  @override
  String get tourSharedTapDrawAll => 'Докосни, за да видиш целия жребий';

  @override
  String get tourSharedContinue => 'Продължи';

  @override
  String get tourSharedPause => 'Пауза';

  @override
  String get tourSharedPlay => 'Пусни';

  @override
  String get tourSharedSkip => 'Пропусни';

  @override
  String tourSharedPotNumber(int number) {
    return 'УРНА $number';
  }

  @override
  String get tourSharedDrawComplete => 'ЖРЕБИЯТ Е ГОТОВ';

  @override
  String get tourSharedDrawing => 'ТЕГЛЕНЕ…';

  @override
  String get tourContChampionship => 'ПЪРВЕНСТВО';

  @override
  String get tourContTabSummary => 'ОБОБЩЕНИЕ';

  @override
  String get tourContTabQualifying => 'КВАЛИФИКАЦИИ';

  @override
  String get tourContTabFinals => 'ФИНАЛИ';

  @override
  String get tourContTabBracket => 'СХЕМА';

  @override
  String get tourContTabAwards => 'НАГРАДИ';

  @override
  String get tourContTabScorers => 'ГОЛМАЙСТОРИ';

  @override
  String get tourContTabHistory => 'ИСТОРИЯ';

  @override
  String get tourContTabRecords => 'РЕКОРДИ';

  @override
  String tourContCouldNotLoadCup(String error) {
    return 'Купата не можа да се зареди.\n$error';
  }

  @override
  String get tourContNoCupData => 'Няма данни за купата.';

  @override
  String get tourContUnknown => 'Неизвестен';

  @override
  String get tourContGroupsToBeDrawnQual =>
      'Квалификационните групи се теглят на церемонията. Гледай от началото, за да видиш срещу кого играеш.';

  @override
  String get tourContQualSeeded =>
      'Твоята страна е поставена директно във финалите. Този цикъл няма квалификации.';

  @override
  String tourContBackgroundRegion(String name) {
    return '$name се симулира на заден план. Резултатите се появяват тук, щом се изиграе всеки кръг.';
  }

  @override
  String get tourContGroupsToBeDrawnFinals =>
      'Груповата фаза на финалите се тегли на церемонията. Гледай от началото, за да видиш групата си.';

  @override
  String get tourContFinalsDrawAfterQual =>
      'Жребият за финалите се тегли, щом квалификациите приключат.';

  @override
  String get tourContContestedBeforeWc =>
      'Елиминационните кръгове се играят преди Световното първенство.';

  @override
  String tourContChampionsHeading(String name) {
    return '$name ШАМПИОНИ';
  }

  @override
  String tourContWinnersTitle(String name) {
    return 'Победители в $name';
  }

  @override
  String get tourContNoGoalsYet => 'Още няма вкарани голове.';

  @override
  String tourContGroupHeading(String name) {
    return 'ГРУПА $name';
  }

  @override
  String get tourContBestRunnersUp => 'НАЙ-ДОБРИ ВТОРИ';

  @override
  String tourContGroupDropdown(String name) {
    return 'Група $name';
  }

  @override
  String get tourContMatches => 'МАЧОВЕ';

  @override
  String get tourContNoGroupsDrawn => 'Още няма изтеглени групи.';

  @override
  String get tourContQualifyingDraw => 'ЖРЕБИЙ ЗА КВАЛИФИКАЦИИТЕ';

  @override
  String get tourContWorldQualifyingDraw => 'ЖРЕБИЙ ЗА СВЕТОВНИТЕ КВАЛИФИКАЦИИ';

  @override
  String get tourContFinalsDraw => 'ЖРЕБИЙ ЗА ФИНАЛИТЕ';

  @override
  String get tourContSeedingPots => 'УРНИ ЗА РАЗПРЕДЕЛЕНИЕ';

  @override
  String get tourContGroupDraw => 'ЖРЕБИЙ ЗА ГРУПИТЕ';

  @override
  String tourContCouldNotLoadDraw(String error) {
    return 'Жребият не можа да се зареди.\n$error';
  }

  @override
  String get tourContDrawNotReady => 'Жребият още не е готов.';

  @override
  String get tourContContinentalClash => 'CONTINENTAL CLASH';

  @override
  String get tourContTabThisCycle => 'ТОЗИ ЦИКЪЛ';

  @override
  String tourContCouldNotLoadClash(String error) {
    return 'Не можа да се зареди.\n$error';
  }

  @override
  String get tourContNoSaveFound => 'Записът не е намерен.';

  @override
  String get tourContClashSoon =>
      'Continental Clash се играе, щом станат известни и двамата континентални шампиони.';

  @override
  String get tourContTwoContinentsOneMatch => 'ДВА КОНТИНЕНТА, ЕДИН МАЧ';

  @override
  String get tourContVersusShort => 'срещу';

  @override
  String tourContWinTheClash(String name) {
    return 'Clash: победа за $name';
  }

  @override
  String get tourContNoClashYet => 'Още няма изигран Continental Clash.';

  @override
  String get tourContNationsCup => 'NATIONS CUP';

  @override
  String get tourContTabLeagues => 'ДИВИЗИИ';

  @override
  String get tourContTabFinalsFour => 'FINAL FOUR';

  @override
  String tourContCouldNotLoad(String error) {
    return 'Неуспешно зареждане.\n$error';
  }

  @override
  String get tourContNoNationsCupGoals =>
      'Още няма отбелязани голове в Nations Cup.';

  @override
  String get tourContNoNationsCupChampions =>
      'Още няма коронясани шампиони в Nations Cup.';

  @override
  String get tourContNationsCupOffSeason =>
      'Nations Cup за този цикъл започва след континенталните финали. Предишните победители са в История.';

  @override
  String get tourContNationsCupGroupsSoon =>
      'Групите в Nations Cup за този цикъл се теглят на церемонията. Гледай от Начало, за да видиш кой ти се пада.';

  @override
  String get tourContLeagueNoGroups => 'Няма мачове в тази дивизия този кръг.';

  @override
  String tourContLeagueHeading(String letter) {
    return 'ДИВИЗИЯ $letter';
  }

  @override
  String tourContLeagueHeadingYours(String letter) {
    return 'ДИВИЗИЯ $letter · ТВОЯТА ДИВИЗИЯ';
  }

  @override
  String get tourContFinalsFourSoon =>
      'Final Four се оспорва от победителите в групите на Дивизия A, след като приключи груповата фаза.';

  @override
  String tourContLeagueChip(String letter) {
    return 'Дивизия $letter';
  }

  @override
  String tourContLeagueChipStar(String letter) {
    return 'Дивизия $letter ★';
  }

  @override
  String get tourContSemiFinals => 'ПОЛУФИНАЛИ';

  @override
  String get tourContFinal => 'ФИНАЛ';

  @override
  String get tourContNationsCupDraw => 'ЖРЕБИЙ ЗА NATIONS CUP';

  @override
  String get tourContIntercontinentalPlayoff => 'МЕЖДУКОНТИНЕНТАЛЕН ПЛЕЙОФ';

  @override
  String get tourContNoPlayoffThisCycle => 'Няма плейоф този цикъл.';

  @override
  String get tourContPlayoffIntro =>
      'Две места на Световното първенство се решават в директни елиминации между най-добрите неуспели в квалификациите.';

  @override
  String get tourContPlayoffThrough =>
      'Мина през плейофа. Ти си на Световното първенство!';

  @override
  String get tourContPlayoffOut =>
      'Не успя в плейофа. Този път няма Световно първенство.';

  @override
  String get tourContContinue => 'Продължи';

  @override
  String get tourContPlayoffFinals => 'ФИНАЛИ НА ПЛЕЙОФА';

  @override
  String get tourContPlayoffSeeded => 'Поставен (директно)';

  @override
  String get tourCupTabSummary => 'ОБОБЩЕНИЕ';

  @override
  String get tourCupTabQualifying => 'КВАЛИФИКАЦИИ';

  @override
  String get tourCupTabPlayoff => 'ПЛЕЙОФ';

  @override
  String get tourCupPlayoffSoon =>
      'Междуконтиненталният плейоф се решава, когато квалификациите във всички конфедерации приключат.';

  @override
  String get tourCupTabFinals => 'ФИНАЛИ';

  @override
  String get tourCupTabBracket => 'СХЕМА';

  @override
  String get tourCupTabAwards => 'НАГРАДИ';

  @override
  String get tourCupTabScorers => 'ГОЛМАЙСТОРИ';

  @override
  String get tourCupTabHistory => 'ИСТОРИЯ';

  @override
  String get tourCupTabRecords => 'РЕКОРДИ';

  @override
  String get tourCupTitle => 'СВЕТОВНО ПЪРВЕНСТВО';

  @override
  String get tourCupNoData => 'Няма данни за турнира.';

  @override
  String tourCupLoadError(String error) {
    return 'Неуспешно зареждане на турнира.\n$error';
  }

  @override
  String get tourCupUnknown => 'Неизвестно';

  @override
  String get tourCupWorldChampions => 'СВЕТОВНИ ШАМПИОНИ';

  @override
  String get tourCupWorldChampionsTitle => 'Световни шампиони';

  @override
  String get tourCupStillActive => 'Още играе';

  @override
  String get tourCupAllTimeScorers => 'НАЙ-ДОБРИ ГОЛМАЙСТОРИ ЗА ВСИЧКИ ВРЕМЕНА';

  @override
  String get tourCupAllConfederations => 'Всички конфедерации';

  @override
  String get tourCupBestRunnersUp => 'Най-добри втори';

  @override
  String get tourCupCompWorld => 'Световно първенство';

  @override
  String get tourCupCompEurope => 'Европейско първенство';

  @override
  String get tourCupCompSAmerica => 'Купа на Южна Америка';

  @override
  String get tourCupDestRoundOf16 => 'осминафиналите';

  @override
  String get tourCupDestKnockouts => 'елиминационната фаза';

  @override
  String get tourCupDestFinals => 'финалите';

  @override
  String get tourCupDestFinalsPlayoff => 'плейофа за финалите';

  @override
  String get tourCupDestIntercontPlayoff => 'междуконтиненталния плейоф';

  @override
  String get tourCupFinalsDrawnAfterQual =>
      'Жребият за финалите е след края на квалификациите.';

  @override
  String get tourCupFinalsDrawSoon =>
      'Групите предстои да бъдат изтеглени. Гледай жребия за Световното първенство от Начало, за да ги видиш.';

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
    return 'Домакин: $host';
  }

  @override
  String tourCupHostLabelMulti(String hosts) {
    return 'Домакини: $hosts';
  }

  @override
  String get tourCupIntercontPlayoff => 'Междуконтинентален плейоф';

  @override
  String get tourCupKnockoutSoon =>
      'Схемата започва, когато приключи груповата фаза.';

  @override
  String get tourCupMatches => 'МАЧОВЕ';

  @override
  String get tourCupMedalTable => 'КЛАСИРАНЕ ПО МЕДАЛИ';

  @override
  String get tourCupMostTitles => 'НАЙ-МНОГО ТИТЛИ';

  @override
  String tourCupMostTitlesValue(String nation, int titles, int editions) {
    String _temp0 = intl.Intl.pluralLogic(
      titles,
      locale: localeName,
      other: '$titles титли',
      one: '1 титла',
    );
    String _temp1 = intl.Intl.pluralLogic(
      editions,
      locale: localeName,
      other: '$editions издания',
      one: '1 издание',
    );
    return '$nation: $_temp0 от $_temp1';
  }

  @override
  String get tourCupNoGoals => 'Още няма голове.';

  @override
  String get tourCupNoGroups => 'Няма изтеглени групи.';

  @override
  String get tourCupNoHistory => 'Още няма история.';

  @override
  String get tourCupPastWinners => 'ПРЕДИШНИ ПОБЕДИТЕЛИ';

  @override
  String get tourCupPlayoffIntro =>
      'Две места на Световното първенство се решават в директни елиминации между най-добрите неуспели в квалификациите.';

  @override
  String tourCupPlayoffNoEntrants(String confederation) {
    return '$confederation няма плейоф: всички места се решават в квалификационните групи.';
  }

  @override
  String get tourCupQualDrawSoon =>
      'Групите предстои да бъдат изтеглени. Гледай жребия за квалификациите от Начало, за да ги видиш.';

  @override
  String tourCupRegionYours(String region) {
    return '$region · твоят';
  }

  @override
  String tourCupScorePens(int home, int away) {
    return '$home–$away (дузпи)';
  }

  @override
  String get tourCupSegAllTime => 'За всички времена';

  @override
  String get tourCupSegFinals => 'Финали';

  @override
  String get tourCupSegQualifying => 'Квалификации';

  @override
  String get playerTraitsTitle => 'ИЗВЕСТЕН С';

  @override
  String get traitBigGame => 'Играч за големите мачове';

  @override
  String get traitBigGameBlurb =>
      'Вдига нивото си в мачовете с директна елиминация.';

  @override
  String get traitSetPiece => 'Специалист по статични положения';

  @override
  String get traitSetPieceBlurb =>
      'По-добро центриране и повече голове от статични положения.';

  @override
  String get traitHothead => 'Темпераментен';

  @override
  String get traitHotheadBlurb =>
      'Взема много повече картони от съотборниците си.';

  @override
  String get traitIronMan => 'Железният човек';

  @override
  String get traitIronManBlurb => 'Рядко се контузва и се уморява по-бавно.';

  @override
  String get traitWonderkid => 'Вундеркинд';

  @override
  String get traitWonderkidBlurb => 'Млад, вече добър и още бързо напредва.';

  @override
  String get traitLeader => 'Лидер';

  @override
  String get traitLeaderBlurb => 'Вдига всички съотборници на терена.';

  @override
  String get traitPacey => 'Бърз';

  @override
  String get traitPaceyBlurb =>
      'Бляскава скорост, постоянна опасност зад гърба на защитата.';

  @override
  String get traitOldHead => 'Опитен играч';

  @override
  String get traitOldHeadBlurb =>
      'Ветеран, чието четене на играта надживява краката му.';

  @override
  String get traitWasteful => 'Разточителен';

  @override
  String get traitWastefulBlurb =>
      'Праща встрани твърде много добри положения.';

  @override
  String get objectiveWorldCup => 'Световно първенство';

  @override
  String get objectiveWinTournament => 'Спечели го';

  @override
  String get objectiveQualifyGeneric => 'Класирай се';

  @override
  String hubBoardObjectiveFor(String competition, String label) {
    return '$competition: $label';
  }

  @override
  String get objectiveWinWorldCup => 'Спечели Световното първенство';

  @override
  String get objectiveReachFinal => 'Стигни до финала';

  @override
  String get objectiveReachSemis => 'Стигни до полуфиналите';

  @override
  String get objectiveReachQuarters => 'Стигни до четвъртфиналите';

  @override
  String get objectiveReachKnockouts => 'Стигни до елиминационната фаза';

  @override
  String get objectiveQualify => 'Класирай се за Световното първенство';

  @override
  String get finishChampions => 'Шампиони';

  @override
  String get finishRunnersUp => 'Вицешампиони';

  @override
  String get finishSemiFinals => 'Полуфинал';

  @override
  String get finishQuarterFinals => 'Четвъртфинал';

  @override
  String get finishRoundOf16 => 'Осминафинал';

  @override
  String get finishGroupStage => 'Групова фаза';

  @override
  String get objectiveQualifyingTopHalf =>
      'Завърши в горната половина в квалификациите';

  @override
  String get objectiveQualifyingChallenge =>
      'Борба за място, поне горната половина в квалификациите';

  @override
  String get finishQualifyingTopHalf =>
      'Горна половина на квалификационната група';

  @override
  String get finishQualifyingBottomHalf =>
      'Долна половина на квалификационната група';

  @override
  String get objectiveNcWinIt => 'Спечели Nations Cup';

  @override
  String get objectiveNcReachFinal => 'Стигни до финала на Nations Cup';

  @override
  String get objectiveNcFinalsFour => 'Стигни до Final Four';

  @override
  String get objectiveNcWinGroup => 'Спечели групата и се изкачи';

  @override
  String get objectiveNcTopHalf => 'Завърши в горната половина на групата';

  @override
  String get objectiveNcSurvive => 'Избегни изпадане';

  @override
  String get objectiveNcOffTheBottom => 'Не завършвай последен в групата';

  @override
  String get finishNcChampions => 'Победители в Nations Cup';

  @override
  String get finishNcFinalsFour => 'Final Four';

  @override
  String get finishNcGroupWinners => 'Победители в групата';

  @override
  String get finishNcTopHalf => 'Горна половина на групата';

  @override
  String get finishNcStayedUp => 'Запазиха мястото си';

  @override
  String get finishNcClearOfBottom => 'Не на дъното на групата';

  @override
  String get finishNcBottom => 'Дъно на групата';

  @override
  String get careerNationsCupLabel => 'Nations Cup';

  @override
  String get squadDevPlayer => 'ИГРАЧ';

  @override
  String get squadDevAge => 'ВЪЗР.';

  @override
  String get squadDevPosition => 'ПОЗ.';

  @override
  String get squadDevChange => 'ОЦЕНКА';

  @override
  String get squadDevNew => 'НОВ';

  @override
  String get squadDevRetired => 'ПЕНСИОНИРАН';

  @override
  String get squadDevEmpty => 'Спокойна година. Няма промени в състава.';

  @override
  String get squadDevTierRegulars => 'ТИТУЛЯРИ';

  @override
  String get squadDevTierFringe => 'НА ГРАНИЦАТА';

  @override
  String get squadDevTierYouth => 'МЛАДИ';

  @override
  String get boardObjectivesTitle => 'Цели на съвета';

  @override
  String get boardObjectivesConfidence => 'Доверие на съвета';

  @override
  String boardObjectiveBeatenBy(String result, int rounds) {
    String _temp0 = intl.Intl.pluralLogic(
      rounds,
      locale: localeName,
      other: 'с $rounds кръга повече от поискания',
      one: 'с един кръг повече от поискания',
    );
    return '$result: $_temp0';
  }

  @override
  String boardObjectiveShortBy(String result, int rounds) {
    String _temp0 = intl.Intl.pluralLogic(
      rounds,
      locale: localeName,
      other: '$rounds кръга по-малко',
      one: 'един кръг по-малко',
    );
    return '$result: $_temp0';
  }

  @override
  String get boardObjectivesPending => 'ОЩЕ СЕ РЕШАВА';

  @override
  String boardObjectiveSoFar(String result) {
    return 'ДОСЕГА · $result';
  }

  @override
  String get boardObjectivesEmpty => 'Съветът не е поставил цел за този цикъл.';

  @override
  String get tourContBestWinners => 'НАЙ-ДОБРИ ПОБЕДИТЕЛИ В ГРУПИ';

  @override
  String get tourContBestThirds => 'НАЙ-ДОБРИ ТРЕТИ';

  @override
  String tourContBestPlaced(String position) {
    return 'НАЙ-ДОБРИ ОТБОРИ ОТ МЯСТО $position';
  }

  @override
  String squadDevPageOf(String page, String pages, int total) {
    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: '$total играча',
      one: '1 играч',
    );
    return '$page/$pages · $_temp0';
  }

  @override
  String get matchSoldOut => 'РАЗПРОДАДЕНО';

  @override
  String matchAttendanceOf(String attendance, String capacity) {
    return '$attendance от $capacity места заети';
  }

  @override
  String get matchGroundTitle => 'СТАДИОН';

  @override
  String get absenceInjured => 'Контузен';

  @override
  String get absenceSuspended => 'Наказан';

  @override
  String absenceWeeks(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString седмици',
      one: '1 седмица',
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
      other: '$countString мача',
      one: '1 мач',
    );
    return '$_temp0';
  }

  @override
  String absenceBackFor(String opponent) {
    return 'Налице за мача с $opponent';
  }

  @override
  String get penaltyOrderTitle => 'Дузпи';

  @override
  String get penaltyOrderBlurb =>
      'Определи петимата изпълнители по ред. Докосни слот, за да го смениш.';

  @override
  String penaltyOrderPick(int number) {
    return 'Удар $number';
  }

  @override
  String get penaltyOrderPickBlurb =>
      'Избери кой излиза. Лентата показва хладнокръвието му от бялата точка.';

  @override
  String get penaltyOrderConfirm => 'Започваме';

  @override
  String get penaltyOrderCancel => 'Назад';

  @override
  String get youthTitle => 'Юноши';

  @override
  String get youthEmptyLevel => 'Още няма никого на това ниво.';

  @override
  String get youthReleased => 'Освободени тази година';

  @override
  String get u21Title => 'До 21 години';

  @override
  String get u21Blurb =>
      'Следващото поколение, най-големият талант първи. Празните звезди са оценка на скаут. Дай мач на играча, за да разбереш какво наистина притежава.';

  @override
  String get u21Empty =>
      'В момента няма никой под 21 години. Следващият набор идва с новия цикъл.';

  @override
  String u21Breakout(int gain) {
    return '+$gain ТАЗИ ГОДИНА';
  }

  @override
  String u21AgeCaps(int age, int caps) {
    String _temp0 = intl.Intl.pluralLogic(
      caps,
      locale: localeName,
      other: '$caps мача',
      one: '$caps мач',
    );
    return 'Възраст $age · $_temp0';
  }

  @override
  String u21AgeUncapped(int age) {
    return 'Възраст $age · без мач';
  }

  @override
  String get u21CallUps => 'Към повикванията';

  @override
  String get youthWatching => 'Следени';

  @override
  String get youthWatchEmpty =>
      'Още никой не е отбелязан. Отбележи момче на което и да е ниво и той ще се появи тук, заедно с това, в което се е превърнал.';

  @override
  String get youthWatchMark => 'Следи това момче';

  @override
  String get youthWatchUnmark => 'Спри да го следиш';

  @override
  String youthWatchMarked(int rating, int age) {
    return 'Отбелязан с $rating, на $age г.';
  }

  @override
  String get youthWatchSenior => 'Преминал към мъжкия пул';

  @override
  String get youthWatchReleased => 'Освободен от академията';

  @override
  String get youthWatchGone => 'Вече не е в пирамидата';

  @override
  String get tacticsYouth => 'До 21 години';

  @override
  String get pressSquad => 'Състав';

  @override
  String get pressBoard => 'Съвет';

  @override
  String get pressNoEffect => 'Никой не обръща внимание';

  @override
  String get matchNeutralGround => 'НЕУТРАЛЕН';

  @override
  String get matchExtraTimeAhead => 'ПРОДЪЛЖЕНИЯ';

  @override
  String get matchExtraTimeHalf => 'ПРОДЪЛЖЕНИЯ · ПОЧИВКА';

  @override
  String get matchClockFullTime => 'КРАЕН РЕЗУЛТАТ';

  @override
  String get matchClockAfterExtraTime => 'СЛЕД ПРОДЪЛЖЕНИЯ';

  @override
  String get matchClockPenalties => 'ДУЗПИ';

  @override
  String get matchClockFullTimePenalties => 'КРАЙ · ДУЗПИ';

  @override
  String get hubEventPressConference => 'Срещни се с медиите';

  @override
  String get hubEventPressConferenceSub =>
      'Световните медии искат думата преди следващия ти мач';

  @override
  String get squadDevWonderkid => 'ВУНДЕРКИНД';

  @override
  String get tacticsPlaystyle => 'Стил на игра';

  @override
  String get tacticsPlaystyleBlurb =>
      'Избери как играе отборът; настройките отдолу го донастройват.';

  @override
  String get tacticsPlaystyleCustom =>
      'Твои собствени настройки. Никой именуван стил не съвпада с тях.';

  @override
  String get playstyleCustom => 'Собствен';

  @override
  String get playstyleBalanced => 'Балансиран';

  @override
  String get playstylePossession => 'Притежание';

  @override
  String get playstyleGegenpress => 'Гегенпресинг';

  @override
  String get playstyleCounter => 'Контраатака';

  @override
  String get playstyleDirect => 'Директна игра';

  @override
  String get playstyleLowBlock => 'Нисък блок';

  @override
  String get playstyleWingPlay => 'Игра по фланговете';

  @override
  String get playstyleBalancedBlurb =>
      'Стабилен и в двете половини, без прекалявания.';

  @override
  String get playstylePossessionBlurb =>
      'Пази топката, движи я търпеливо, стягай терена.';

  @override
  String get playstyleGegenpressBlurb =>
      'Връщай топката веднага щом я загубиш, високо на терена.';

  @override
  String get playstyleCounterBlurb =>
      'Стой назад, компактно, после излез със скорост.';

  @override
  String get playstyleDirectBlurb => 'Рано напред и борба за втората топка.';

  @override
  String get playstyleLowBlockBlurb =>
      'Дълбоко, тясно и много трудно за разбиване.';

  @override
  String get playstyleWingPlayBlurb =>
      'Разтегни терена, мини отвън и центрирай.';

  @override
  String get nationsRandomTeam => 'Случаен отбор';

  @override
  String get nationsFromTheBottom => 'От дъното';

  @override
  String get bottomStartTitle => 'Без работа';

  @override
  String get bottomStartHeading => 'Три федерации искат да говорят с теб';

  @override
  String get bottomStartBlurb =>
      'Нямаш работа и име. Това са единствените отбори, готови да рискуват с теб. Избери един и изгради нещо от нищото.';

  @override
  String get bottomStartAccept => 'Приеми';

  @override
  String get bottomStartBack => 'Обратно към менюто';

  @override
  String bottomStartRankOf(int rank, int total) {
    return '$rank от $total в света';
  }

  @override
  String get campTitle => 'Базов лагер';

  @override
  String campBasedIn(String host) {
    return 'Базиране в $host';
  }

  @override
  String get campBlurb =>
      'Мястото, където отборът живее през целия турнир. Не може да се променя, след като започне играта, и влияе на три неща във всеки мач: колко свежи пристигат, колко бързо заздравява контузия и колко са във форма.';

  @override
  String get campEffectTravel => 'Пристигат свежи';

  @override
  String get campEffectRecovery => 'Контузии заздравяват';

  @override
  String get campEffectSharpness => 'Мачова форма';

  @override
  String get campTerrainCity => 'Градски център';

  @override
  String get campTerrainCoastal => 'Морски курорт';

  @override
  String get campTerrainMountain => 'Планинско убежище';

  @override
  String get campTerrainAltitude => 'Лагер на високо';

  @override
  String get campTerrainNationalCentre => 'Национален център';

  @override
  String get campTerrainCityBlurb =>
      'Всичко е на крачка и няма къде да пътуваш, но няма нито спокойствие, нито спасение от шума.';

  @override
  String get campTerrainCoastalBlurb =>
      'Спокойно, удобно и добро за морала; дълъг път с автобус до всеки стадион.';

  @override
  String get campTerrainMountainBlurb =>
      'Свеж въздух и първокласна медицинска база, която бързо оправя контузиите, далеч от турнира.';

  @override
  String get campTerrainAltitudeBlurb =>
      'Тежко за тренировки, но краката издържат дълбоко в турнира.';

  @override
  String get campTerrainNationalCentreBlurb =>
      'Собствените бази на федерацията: нищо впечатляващо, нищо, което да се обърка.';

  @override
  String get hubEventChooseCamp => 'Избери базов лагер';

  @override
  String hubEventChooseCampSub(String host) {
    return 'Къде ще е базиран отборът в $host';
  }

  @override
  String get tacticsTabBench => 'Скамейка';

  @override
  String get squadSearchHint => 'Търси по име или клуб';

  @override
  String get squadFilterAll => 'Всички';

  @override
  String get squadFilterInSquad => 'В състава';

  @override
  String get squadFilterUncapped => 'Без мач';

  @override
  String get squadFilterUnavailable => 'Недостъпни';

  @override
  String get squadLineAll => 'Всички линии';

  @override
  String get squadSortBy => 'Подреди';

  @override
  String get squadSortRating => 'Оценка';

  @override
  String get squadSortCaps => 'Мачове';

  @override
  String get squadSortGoals => 'Голове';

  @override
  String get squadSortAge => 'Възраст';

  @override
  String get squadSortName => 'Име';

  @override
  String get squadLegendTitle => 'Какво означават знаците';

  @override
  String get squadLegendStarting => 'В стартовия ти състав';

  @override
  String get squadLegendCalledUp => 'Повикан, на скамейката';

  @override
  String get squadLegendInjured => 'Контузен, недостъпен';

  @override
  String get squadLegendSuspended => 'Наказан, недостъпен';

  @override
  String get squadLegendTired =>
      'Уморен (жълто) или изтощен (червено): дай му почивка за един мач';

  @override
  String get squadLegendShift =>
      'Собствената му промяна в оценката за следващия мач (форма, физика, клуб)';

  @override
  String get squadLegendTraits => 'ИЗВЕСТЕН С';

  @override
  String squadShowingOf(int shown, int total) {
    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: '$total играча',
      one: '$total играч',
    );
    return 'Показани $shown от $_temp0';
  }

  @override
  String get squadNobodyMatches => 'Никой в пула не отговаря на тези филтри.';

  @override
  String get squadStatPool => 'Пул';

  @override
  String get squadStatInSquad => 'Повикани';

  @override
  String get squadMostCapped => 'Най-много мачове';

  @override
  String get squadTopScorer => 'Голмайстор №1';

  @override
  String squadCapsValue(String name, int caps) {
    String _temp0 = intl.Intl.pluralLogic(
      caps,
      locale: localeName,
      other: '$caps мача',
      one: '$caps мач',
    );
    return '$name · $_temp0';
  }

  @override
  String squadGoalsValue(String name, int goals) {
    String _temp0 = intl.Intl.pluralLogic(
      goals,
      locale: localeName,
      other: '$goals гола',
      one: '$goals гол',
    );
    return '$name · $_temp0';
  }

  @override
  String squadAgeClub(int age, String club) {
    return '$age · $club';
  }

  @override
  String get squadCapsShort => 'Мач.';

  @override
  String get squadGoalsShort => 'Гол.';

  @override
  String get recordsRecordBookSubtitle =>
      'Мачове, голове и главните рекорди на отбора';

  @override
  String get statsLegacy => 'НАСЛЕДСТВО';

  @override
  String tacticsSubAlreadyOff(String name) {
    return '$name вече е сменен и не може да се върне в игра.';
  }

  @override
  String tacticsSubSentOff(String name) {
    return '$name е изгонен и не взема повече участие.';
  }

  @override
  String get tacticsInjuredShort => 'КОНТУЗЕН';

  @override
  String get tacticsSuspendedShort => 'НАКАЗАН';

  @override
  String get confEurope => 'Европа';

  @override
  String get confSouthAmerica => 'Южна Америка';

  @override
  String get confNorthAmerica => 'Северна Америка';

  @override
  String get confAfrica => 'Африка';

  @override
  String get confAsia => 'Азия';

  @override
  String get confOceania => 'Океания';

  @override
  String get compWorldCup => 'Световно първенство';

  @override
  String get compWorldCupFinals => 'Финали на Световното първенство';

  @override
  String get compWorldCupQualifying => 'Квалификации за Световното първенство';

  @override
  String compQualifiers(String region) {
    return 'Квалификации: $region';
  }

  @override
  String get compFriendlies => 'Контролни мачове';

  @override
  String get compNationsCup => 'Nations Cup';

  @override
  String get compContinentalClash => 'Continental Clash';

  @override
  String get compIntercontinentalPlayoff => 'Междуконтинентален плейоф';

  @override
  String get compContinentalChampionship => 'Континентално първенство';

  @override
  String get compEuropeanChampionship => 'Европейско първенство';

  @override
  String get compSouthAmericaCup => 'Купа на Южна Америка';

  @override
  String get compAfricanChampionship => 'Африканско първенство';

  @override
  String get compAsianChampionship => 'Азиатско първенство';

  @override
  String get compNorthAmericaCup => 'Купа на Северна Америка';

  @override
  String get compOceaniaCup => 'Купа на Океания';

  @override
  String get msgANation => 'Една страна';

  @override
  String get msgAPlayer => 'Един играч';

  @override
  String get msgAHostNation => 'страна домакин';

  @override
  String get msgCycleTitle1 => 'Започва нов цикъл';

  @override
  String msgCycleTitle2(int year) {
    return 'Пътят към $year се отваря';
  }

  @override
  String get msgCycleTitle3 => 'Изгрява нова кампания';

  @override
  String get msgCycleTitle4 => 'Обратно на работа';

  @override
  String msgCycleBody1(int year) {
    return 'Пътят към Световното първенство $year започва оттук.';
  }

  @override
  String msgCycleBody2(int year) {
    return 'Нов цикъл. Целта е Световното първенство $year.';
  }

  @override
  String msgCycleBody3(int year) {
    return 'Четири години до Световното първенство $year. Работата започва сега.';
  }

  @override
  String msgCycleBody4(int year) {
    return 'Кампанията $year започва днес.';
  }

  @override
  String msgContHostTitle(String cup, String host) {
    return 'Домакин на $cup: $host';
  }

  @override
  String msgContHostBody(String host, String cup) {
    return '$host ще бъде домакин на следващия турнир: $cup.';
  }

  @override
  String msgContQualDrawTitle(String cup) {
    return 'Жребий за квалификациите: $cup';
  }

  @override
  String msgContQualDrawBody(String cup) {
    return 'Квалификационните групи за турнира $cup са изтеглени.';
  }

  @override
  String msgWcHostTitle(String host, int year) {
    return 'Домакин на Световното първенство $year: $host';
  }

  @override
  String msgWcHostBody(String host, int year) {
    return '$host ще бъде домакин на Световното първенство $year.';
  }

  @override
  String get msgWcQualDrawTitle =>
      'Жребий за квалификациите за Световното първенство';

  @override
  String get msgWcQualDrawBody =>
      'Квалификационните групи за Световното първенство са изтеглени.';

  @override
  String msgContFinalsDrawTitle(String cup) {
    return 'Жребий за финалите: $cup';
  }

  @override
  String msgContFinalsDrawBody(String cup) {
    return 'Групите на финалите на турнира $cup са изтеглени.';
  }

  @override
  String get msgWcFinalsDrawTitle =>
      'Жребий за финалите на Световното първенство';

  @override
  String msgWcFinalsDrawBody(int year) {
    return 'Жребият за финалите на Световното първенство $year е изтеглен.';
  }

  @override
  String get msgQualWcTitle1 => 'Напред към Световното първенство';

  @override
  String get msgQualWcTitle2 => 'Място на Световното първенство осигурено';

  @override
  String get msgQualWcTitle3 => 'Отиваме на Световното първенство';

  @override
  String get msgQualWcTitle4 => 'Билетът е в джоба';

  @override
  String msgQualWcBody1(int year) {
    return 'Класира се за финалите на Световното първенство $year.';
  }

  @override
  String msgQualWcBody2(int year) {
    return 'Официално е: страната ти е на Световното първенство $year.';
  }

  @override
  String msgQualWcBody3(int year) {
    return 'Място на Световното първенство $year е осигурено.';
  }

  @override
  String msgQualWcBody4(int year) {
    return 'Класира се за финалите на Световното първенство $year.';
  }

  @override
  String msgQualContTitle1(String cup) {
    return 'Напред към $cup';
  }

  @override
  String msgQualContTitle2(String cup) {
    return 'Място в $cup осигурено';
  }

  @override
  String msgQualContTitle3(String cup) {
    return 'Класиране за $cup';
  }

  @override
  String msgQualContBody1(String cup) {
    return 'Класира се за финалите на турнира $cup.';
  }

  @override
  String msgQualContBody2(String cup) {
    return 'Страната ти си осигури място в турнира $cup.';
  }

  @override
  String msgQualContBody3(String cup) {
    return 'Напред към турнира $cup.';
  }

  @override
  String msgChampTitleMine1(String comp) {
    return 'ШАМПИОНИ: $comp!';
  }

  @override
  String msgChampTitleMine2(String comp) {
    return 'Шампиони в турнира $comp!';
  }

  @override
  String msgChampTitleMine3(String comp) {
    return 'Спечели турнира $comp!';
  }

  @override
  String msgChampTitleOther1(String comp) {
    return 'Решен е турнирът $comp';
  }

  @override
  String msgChampTitleOther2(String comp) {
    return 'Коронясани са шампионите в турнира $comp';
  }

  @override
  String msgChampTitleOther3(String comp) {
    return 'Турнирът $comp има победител';
  }

  @override
  String msgChampBodyMine1(String comp, String loser, String result, int year) {
    return 'Страната ти е шампион в турнира $comp $year, след победа над $loser$result.';
  }

  @override
  String msgChampBodyMine2(String comp, String loser, String result, int year) {
    return 'Спечели турнира $comp $year, след като отстрани $loser$result.';
  }

  @override
  String msgChampBodyMine3(String comp, String loser, String result, int year) {
    return 'Турнирът $comp $year е твой. $loser е победен$result.';
  }

  @override
  String msgChampBodyOther1(
    String winner,
    String comp,
    String loser,
    String result,
    int year,
  ) {
    return '$winner спечели турнира $comp $year, след победа над $loser$result.';
  }

  @override
  String msgChampBodyOther2(
    String winner,
    String comp,
    String loser,
    String result,
    int year,
  ) {
    return '$winner е шампион в турнира $comp $year, след победа над $loser$result.';
  }

  @override
  String msgFinalScoreSuffix(int home, int away) {
    return ' с $home–$away на финала';
  }

  @override
  String msgFinalPensSuffix(int home, int away) {
    return ' на дузпи, след $home–$away на финала';
  }

  @override
  String get msgWpotyTitle => 'Футболист на годината в света';

  @override
  String msgWpotyBodyMine(String name, String nation, int year) {
    return '$name ($nation) е обявен за Футболист на годината в света за $year, един от твоите.';
  }

  @override
  String msgWpotyBodyOther(String name, String nation, int year) {
    return '$name ($nation) е обявен за Футболист на годината в света за $year.';
  }

  @override
  String get msgYpotTitle => 'Млад футболист на турнира';

  @override
  String msgYpotBodyMine(String name, String nation, int age, int year) {
    return '$name ($nation), на $age г., е обявен за Млад футболист на турнира за $year, един от твоите.';
  }

  @override
  String msgYpotBodyOther(String name, String nation, int age, int year) {
    return '$name ($nation), на $age г., е обявен за Млад футболист на турнира за $year.';
  }

  @override
  String msgRankHold1(int rank) {
    return 'Държиш се на №$rank.';
  }

  @override
  String msgRankHold2(int rank) {
    return 'Без промяна, все още №$rank.';
  }

  @override
  String msgRankHold3(int rank) {
    return 'Стабилно на №$rank.';
  }

  @override
  String msgRankUp1(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move места',
      one: '1 място',
    );
    return 'Общо $_temp0 нагоре, до №$rank.';
  }

  @override
  String msgRankUp2(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move места',
      one: '1 място',
    );
    return 'Изкачване с $_temp0 те качва на №$rank.';
  }

  @override
  String msgRankUp3(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move места',
      one: '1 място',
    );
    return 'Нагоре с $_temp0, вече №$rank.';
  }

  @override
  String msgRankDown1(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move места',
      one: '1 място',
    );
    return 'Общо $_temp0 надолу, до №$rank.';
  }

  @override
  String msgRankDown2(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move места',
      one: '1 място',
    );
    return 'Спад с $_temp0 те сваля на №$rank.';
  }

  @override
  String msgRankDown3(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move места',
      one: '1 място',
    );
    return 'Надолу с $_temp0, вече №$rank.';
  }

  @override
  String get msgRankLeadYou => 'Ти си на върха в света.';

  @override
  String msgRankLeadOther(String nation) {
    return '$nation е на върха в света.';
  }

  @override
  String msgRankTitle(int rank) {
    return 'Световна ранглиста · №$rank';
  }

  @override
  String msgRankBody(String lead, String movement) {
    return 'Световната ранглиста е обновена. $lead $movement';
  }

  @override
  String msgRankJumpTitleUp(int rank) {
    return 'Изкачване до №$rank';
  }

  @override
  String msgRankJumpTitleDown(int rank) {
    return 'Спад до №$rank';
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
      one: '1 място',
    );
    return '$tournament промени световната ранглиста. $nation влезе от №$from и излезе на №$to, изкачване с $_temp0.';
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
      one: '1 място',
    );
    return '$tournament промени световната ранглиста. $nation влезе от №$from и излезе на №$to, спад с $_temp0.';
  }

  @override
  String get rankingSinceWcDraw => 'От жребия за Световното първенство';

  @override
  String get rankingSinceCycleStart => 'От началото на кампанията';

  @override
  String rankingMovedFromTo(int from, int now) {
    return '№$from до №$now';
  }

  @override
  String msgCapsTitle(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count мача',
      one: '$count мач',
    );
    return '$name достига $_temp0';
  }

  @override
  String msgCapsBody(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count мача',
      one: '$count мач',
    );
    return '$name вече има $_temp0 за страната ти.';
  }

  @override
  String msgGoalsTitle(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count гола',
      one: '$count гол',
    );
    return '$name достига $_temp0';
  }

  @override
  String msgGoalsBody(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count международни гола',
      one: '$count международен гол',
    );
    return '$name е вкарал $_temp0 за страната ти.';
  }

  @override
  String msgDevTitle(int year) {
    return 'Развитие на състава · $year';
  }

  @override
  String msgThroughTitle(int year) {
    return 'От академията · $year';
  }

  @override
  String get msgThroughNote =>
      'Това не е нов набор. Това са момчетата, дошли на единайсет години, които вече са пораснали за мъжкия пул.';

  @override
  String msgNewFacesTitle(int year) {
    return 'Нови лица · $year';
  }

  @override
  String get msgIntakeNoteAcademy =>
      'Инвестицията в академията си личи: този набор дойде по-силен, отколкото би бил иначе.';

  @override
  String get msgIntakeNoteStanding =>
      'Страната следи този отбор: с изкачването в световната ранглиста най-добрите момчета избират футбола и този набор дойде по-силен заради това.';

  @override
  String get msgIntakeNoteBoth =>
      'Парите за академията и изкачването в световната ранглиста си личат: този набор дойде по-силен, отколкото би бил иначе.';

  @override
  String msgIntakeTitle(int year) {
    return 'Набор от академията · $year';
  }

  @override
  String msgRetireCaptainTitle(String name) {
    return 'Капитанът ти $name се оттегля';
  }

  @override
  String msgRetireTitle(String name) {
    return '$name се оттегля от националния отбор';
  }

  @override
  String msgRetireBody(String name, int age) {
    return '$name се оттегли от международния футбол на $age г.';
  }

  @override
  String msgRetireBodyWith(String name, String tally, int age) {
    return '$name се оттегли от международния футбол на $age г., като си тръгва с $tally.';
  }

  @override
  String msgTallyCaps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count мача',
      one: '1 мач',
    );
    return '$_temp0';
  }

  @override
  String msgTallyGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count гола',
      one: '1 гол',
    );
    return '$_temp0';
  }

  @override
  String get msgArmbandVacant =>
      ' Капитанската лента е свободна. Избери нов капитан от екрана за повиквания.';

  @override
  String msgHofTitle(String name) {
    return '$name влиза в Залата на славата';
  }

  @override
  String msgHofBody(String name, int caps, int goals) {
    String _temp0 = intl.Intl.pluralLogic(
      caps,
      locale: localeName,
      other: '$caps мача',
      one: '$caps мач',
    );
    String _temp1 = intl.Intl.pluralLogic(
      goals,
      locale: localeName,
      other: '$goals гола',
      one: '$goals гол',
    );
    return '$name се присъединява към Залата на славата на страната ти ($_temp0, $_temp1). Виж го в Легенди.';
  }

  @override
  String hubBanTitle(String name) {
    return '$name е наказан';
  }

  @override
  String hubBanBody(String name, String how, int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: 'следващите $matches мача',
      one: 'следващия ти мач',
    );
    return '$name $how и е наказан за $_temp0. Няма да е на разположение за избор.';
  }

  @override
  String get hubBanHowSecondYellow => 'беше изгонен за втори жълт картон';

  @override
  String get hubBanHowViolent => 'получи пряк червен картон за груба игра';

  @override
  String get hubBanHowRed => 'беше изгонен';

  @override
  String hubInjuryTitle(String name) {
    return '$name е контузен';
  }

  @override
  String hubInjuryBody(String name, int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: '$matches мача',
      one: '1 мач',
    );
    return '$name се контузи и ще пропусне $_temp0.';
  }

  @override
  String get hubRunnerUpTitle1 => 'Вицешампиони';

  @override
  String get hubRunnerUpTitle2 => 'Толкова близо, а толкова далеч';

  @override
  String get hubRunnerUpTitle3 => 'Сребърни медали';

  @override
  String hubRunnerUpBody1(String cup, String opponent) {
    return 'Стигна до финала на $cup, но загуби от $opponent. Толкова близо. Сребро този път.';
  }

  @override
  String hubRunnerUpBody2(String cup, String opponent) {
    return 'Победен от $opponent във финала на $cup. Вицешампиони, мъчително близо.';
  }

  @override
  String hubRunnerUpBody3(String cup, String opponent) {
    return 'Финалът на $cup се изплъзна срещу $opponent. Има с какво да се гордееш, но не и купата.';
  }

  @override
  String get hubKnockedOutTitle1 => 'Отпадане';

  @override
  String get hubKnockedOutTitle2 => 'Краят на пътя';

  @override
  String get hubKnockedOutTitle3 => 'Пътешествието свърши';

  @override
  String hubKnockedOutBody1(String cup, String opponent, String stage) {
    return 'Отпадна от турнира $cup, победен от $opponent в $stage.';
  }

  @override
  String hubKnockedOutBody2(String cup, String opponent, String stage) {
    return '$opponent слага край на участието ти в турнира $cup в $stage.';
  }

  @override
  String hubKnockedOutBody3(String cup, String opponent, String stage) {
    return 'Турнирът $cup свършва за теб в $stage след загуба от $opponent.';
  }

  @override
  String get hubGroupExitTitle1 => 'Отпадане в групата';

  @override
  String get hubGroupExitTitle2 => 'Край в груповата фаза';

  @override
  String get hubGroupExitTitle3 => 'Рано под душа';

  @override
  String hubGroupExitBody1(String cup) {
    return 'Турнирът $cup свършва за теб в груповата фаза. Не ти достигна, за да стигнеш до елиминациите.';
  }

  @override
  String hubGroupExitBody2(String cup) {
    return 'Не успя да излезеш от групата. Турнирът $cup свършва за теб тук.';
  }

  @override
  String hubGroupExitBody3(String cup) {
    return 'Този път няма място в елиминациите. Турнирът $cup приключва за теб в груповата фаза.';
  }

  @override
  String boardObjectiveMetTitle(String comp) {
    return 'Целта е изпълнена: $comp';
  }

  @override
  String boardObjectiveMissedTitle(String comp) {
    return 'Целта не е изпълнена: $comp';
  }

  @override
  String boardObjectiveMetBody(String comp, String demand, String finish) {
    return 'Целта на съвета за $comp: $demand. Ти завърши: $finish. Получиха каквото поискаха.';
  }

  @override
  String boardObjectiveMissedBody(String comp, String demand, String finish) {
    return 'Целта на съвета за $comp: $demand. Ти завърши: $finish. Това е под очакванията.';
  }

  @override
  String get newsWcMissTitle => 'Мечтата за Световното първенство приключи';

  @override
  String newsWcMissBody(int year) {
    return 'Не се класира за Световното първенство $year. Квалификационната кампания не стигна. Още четири години.';
  }

  @override
  String get newsRecordScorerTitle => 'Най-добър голмайстор за всички времена';

  @override
  String newsRecordScorerBody(String name, int goals) {
    String _temp0 = intl.Intl.pluralLogic(
      goals,
      locale: localeName,
      other: '$goals гола',
      one: '$goals гол',
    );
    return '$name вече е най-добрият голмайстор за всички времена в играта с $_temp0.';
  }

  @override
  String get newsRecordCapsTitle => 'Най-много мачове за националния отбор';

  @override
  String newsRecordCapsBody(String name, int caps) {
    String _temp0 = intl.Intl.pluralLogic(
      caps,
      locale: localeName,
      other: '$caps мача',
      one: '$caps мач',
    );
    return '$name вече е играчът с най-много мачове за националния отбор в играта: $_temp0.';
  }

  @override
  String get newsARecordBreaker => 'Нов рекордьор';

  @override
  String newsTransferTitle(String name, String club) {
    return '$name преминава в $club';
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
    return '$name ($position, $rating) напусна $fromClub и подписа с $destination срещу $fee.';
  }

  @override
  String newsTransferAbroad(String club, String country) {
    return '$club в $country';
  }

  @override
  String get newsTransferFree => 'Безплатно';

  @override
  String newsNatzStarTitle(String name, String nation) {
    return '$name би преминал към $nation!';
  }

  @override
  String newsNatzTitle(String name, String nation) {
    return '$name иска да играе за $nation';
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
    return '$name, $age-годишен $position с рейтинг $rating, който в момента играе за $fromNation, има семейни връзки с $nation и е готов да смени отбора. Отвори офертата за натурализация, за да я приемеш или откажеш.';
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
    return '$name, $age-годишен $position с рейтинг $rating, който в момента играе за $fromNation, е звездно име със семейни връзки с $nation и е готов да смени отбора. Отвори офертата за натурализация, за да я приемеш или откажеш.';
  }

  @override
  String get newsTheirNation => 'своята страна';

  @override
  String get newsYourNation => 'твоята страна';

  @override
  String get tourStatusChampions => 'ШАМПИОНИ';

  @override
  String get tourStatusFinals => 'ФИНАЛИ';

  @override
  String get tourStatusQualifying => 'КВАЛИФИКАЦИИ';

  @override
  String get tourStatusUpcoming => 'ПРЕДСТОИ';

  @override
  String get tourStatusInProgress => 'В ХОД';

  @override
  String get tourStatusComingSoon => 'СКОРО';

  @override
  String get tourStatusDecided => 'РЕШЕНО';

  @override
  String tourStatusLeague(String letter) {
    return 'ДИВИЗИЯ $letter';
  }

  @override
  String get tourDrawWcQualifying => 'ЖРЕБИЙ ЗА КВАЛИФИКАЦИИ СП';

  @override
  String tourDrawContQualifying(String cup) {
    return 'ЖРЕБИЙ ЗА КВАЛИФИКАЦИИТЕ ЗА $cup';
  }

  @override
  String get tourDrawWcHost => 'ДОМАКИН НА СВЕТОВНОТО ПЪРВЕНСТВО';

  @override
  String tourDrawContHost(String cup) {
    return 'ДОМАКИН НА $cup';
  }

  @override
  String get tourDrawHostsReveal => 'А домакини ще бъдат…';

  @override
  String get tourDrawHostReveal => 'А домакин ще бъде…';

  @override
  String get tourDrawHostCandidates => 'Кандидатите в надпреварата:';

  @override
  String get tourKickoffContinentalCup => 'КОНТИНЕНТАЛНА КУПА';

  @override
  String tourHostCompetitionYear(String competition, int year) {
    return '$competition $year';
  }

  @override
  String newsContMissTitle(String cup) {
    return 'Пропуснат $cup';
  }

  @override
  String newsContMissBody(String cup) {
    return 'Не се класира за $cup. Кампанията този път не стигна докрай.';
  }

  @override
  String get potyLabelBest => 'Футболист на годината';

  @override
  String get potyLabelYoung => 'Млад футболист на годината';

  @override
  String potyTallyAssists(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count асистенции',
      one: '1 асистенция',
    );
    return '$_temp0';
  }

  @override
  String potyOverallValue(int value) {
    return 'Рейтинг $value';
  }

  @override
  String potyRatingValue(String value) {
    return 'Оценка $value';
  }

  @override
  String newsPotyTitle(int year) {
    return 'Футболист на годината в света $year';
  }

  @override
  String newsPotyBody(String name) {
    return '$name е най-добрият футболист в света тази година.';
  }

  @override
  String newsPotyYoungSuffix(String name) {
    return ' $name печели наградата за млад футболист.';
  }

  @override
  String newsWatchTitle(int year) {
    return 'Момчетата, които следиш, $year';
  }

  @override
  String newsWatchJump(String name, int rating, int gain) {
    String _temp0 = intl.Intl.pluralLogic(
      gain,
      locale: localeName,
      other: 'с $gain точки',
      one: 'с една точка',
    );
    return '$name е скочил до $rating, $_temp0 повече от миналата година.';
  }

  @override
  String newsWatchBand(String name, String band) {
    return '$name преминава във възрастовата група $band.';
  }

  @override
  String newsWatchDebutTitle(String name) {
    return '$name дебютира';
  }

  @override
  String newsWatchDebutBody(String name, int age, int rating) {
    return '$name изигра първия си мач за националния отбор на $age години, с рейтинг $rating. Едно от момчетата, които следиш.';
  }

  @override
  String get matchStatsAtFullTime =>
      'Притежанието на топката, оценките на играчите и играчът на мача се определят при финалния съдийски сигнал.';

  @override
  String get matchPlayerRatings => 'ОЦЕНКИ НА ИГРАЧИТЕ';

  @override
  String get matchSubstitutions => 'СМЕНИ';

  @override
  String get matchSubstitutes => 'РЕЗЕРВИ';

  @override
  String get matchLineupsViewPitch => 'Терен';

  @override
  String get matchLineupsViewList => 'Списък';

  @override
  String get matchLineupsCameOn => 'Влезли от пейката';

  @override
  String get matchConditionsKickOff => 'Начало';

  @override
  String get matchWeatherClear => 'Ясно';

  @override
  String get matchWeatherRain => 'Слаб дъжд';

  @override
  String get matchWeatherSnow => 'Сняг';

  @override
  String get matchWeatherHaze => 'Омара';

  @override
  String get matchWeatherHeavyRain => 'Силен дъжд';

  @override
  String get matchWeatherThunderstorm => 'Гръмотевична буря';

  @override
  String get matchWeatherFog => 'Мъгла';

  @override
  String get matchWeatherWindy => 'Силен вятър';

  @override
  String get matchWeatherDustStorm => 'Пясъчна буря';

  @override
  String get matchWeatherFrostyNight => 'Мразовита нощ';

  @override
  String get matchPlayerOfTheMatch => 'ИГРАЧ НА МАЧА';

  @override
  String get ratingPlayerOfTheMatch => 'Играч на мача';

  @override
  String ratingSemantics(String rating) {
    return 'Оценка $rating';
  }

  @override
  String get matchAverageRating => 'Средна оценка';

  @override
  String get matchLiveRatingsNote =>
      'Оценките следват мача досега и стават окончателни с последния сигнал.';

  @override
  String get matchGoalShout => 'ГОЛ!';

  @override
  String get matchRedCardShout => 'ЧЕРВЕН КАРТОН';

  @override
  String matchShootoutScore(int home, int away) {
    return 'ДУЗПИ $home–$away';
  }

  @override
  String matchShootoutKickScored(String name) {
    return '$name: ГОЛ';
  }

  @override
  String matchShootoutKickMissed(String name) {
    return '$name: ПРОПУСК';
  }

  @override
  String get matchFeedKickOff => 'Начален удар!';

  @override
  String get matchFeedNoEvents => 'Още няма събития.';

  @override
  String get tourVenues => 'СТАДИОНИ';

  @override
  String tourPot(int number) {
    return 'УРНА $number';
  }

  @override
  String get tourHostSelection => 'ИЗБОР НА ДОМАКИН';

  @override
  String get tourCandidates => 'КАНДИДАТИ';

  @override
  String get tourJointBid => 'СЪВМЕСТНА КАНДИДАТУРА';

  @override
  String get tourGoldenGlove => 'НАЙ-ДОБЪР ВРАТАР';

  @override
  String get tourTeamOfTournament => 'ОТБОР НА ТУРНИРА';

  @override
  String get tourYourRun => 'ТВОЯТ ПЪТ';

  @override
  String get tourMedalTable => 'КЛАСИРАНЕ ПО МЕДАЛИ';

  @override
  String tourHostLine(String nation) {
    return 'Домакин: $nation';
  }

  @override
  String tourHostLineMulti(String hosts) {
    return 'Домакини: $hosts';
  }

  @override
  String tourGroupNamed(String name) {
    return 'Група $name';
  }

  @override
  String get tourFinalsDrawBlurb =>
      'Поставени по световна ранглиста. Намери страната си преди жребия.';

  @override
  String get tourWorldRanking => 'Световна ранглиста';

  @override
  String get tourYourCompetitions => 'ТВОИТЕ ТУРНИРИ';

  @override
  String get tourOtherContinents => 'ДРУГИ КОНТИНЕНТИ';

  @override
  String get tourZoneGlobal => 'СВЕТ';

  @override
  String get tourZoneEurope => 'ЕВРОПА';

  @override
  String get tourZoneSouthAmerica => 'Ю. АМЕРИКА';

  @override
  String get tourZoneNorthAmerica => 'С. АМЕРИКА';

  @override
  String get tourZoneAfrica => 'АФРИКА';

  @override
  String get tourZoneAsia => 'АЗИЯ';

  @override
  String get tourZoneOceania => 'ОКЕАНИЯ';

  @override
  String get tourZoneIntercontinental => 'МЕЖДУКОНТИНЕНТАЛНО';

  @override
  String tourZoneLeague(String league) {
    return 'ДИВИЗИЯ $league';
  }

  @override
  String tourHostedBy(String hosts) {
    return 'ДОМАКИН  $hosts';
  }

  @override
  String tourThirdsAdvance(int count, String destination) {
    return 'Първите $count продължават към $destination';
  }

  @override
  String newsWalkoutTitle(String name) {
    return '$name си тръгва';
  }

  @override
  String newsWalkoutBody(String name, int age, int caps) {
    String _temp0 = intl.Intl.pluralLogic(
      caps,
      locale: localeName,
      other: '$caps мача',
      one: '$caps мач',
    );
    return '$name се оттегли от националния отбор на $age години, с $_temp0. Поиска да му кажат какво е мястото му и не получи отговор, а повече не иска да чака.';
  }

  @override
  String get pressHeadlineWent1 => 'Селекционер, който владее залата';

  @override
  String get pressHeadlineWent2 => 'Дойдоха за скандал, а получиха лидер';

  @override
  String get pressHeadlineWent3 => 'Преки отговори, и улучиха';

  @override
  String get pressHeadlineMixed1 => 'Много казано, малко решено';

  @override
  String get pressHeadlineMixed2 => 'Нещо за всеки и нищо за никого';

  @override
  String get pressHeadlineMixed3 =>
      'Конференция, която остави въпросите отворени';

  @override
  String get pressHeadlineBadly1 => 'Болезнен следобед пред камерите';

  @override
  String get pressHeadlineBadly2 => 'Залата се обърна и си личеше';

  @override
  String get pressHeadlineBadly3 => 'Отговори, които сутринта ще звучат по-зле';

  @override
  String get pressHeadlineFlat1 => 'Нищо казано, нищо спечелено';

  @override
  String get pressHeadlineFlat2 => 'Десет минути, без новини';

  @override
  String get pressHeadlineFlat3 => 'Бяла страница за задната корица';

  @override
  String get pressConferenceTitle => 'ПРЕСКОНФЕРЕНЦИЯ';

  @override
  String pressQuestionOf(int index, int total) {
    return 'Въпрос $index от $total';
  }

  @override
  String get pressTomorrowsHeadline => 'ЗАДНАТА СТРАНИЦА УТРЕ';

  @override
  String get pressLeaveRoom => 'НАПУСНИ ЗАЛАТА';

  @override
  String get pressRoomVerdictSquad => 'Съблекалня';

  @override
  String get pressRoomVerdictBoard => 'Съвет';

  @override
  String get yReactionElation0 => 'без бележки. никакви. перфектно.';

  @override
  String get yReactionElation1 => 'не ми е добре (в добрия смисъл).';

  @override
  String get yReactionElation2 => 'ще го рамкирам. над камината.';

  @override
  String get yReactionElation3 => 'пак сме тук';

  @override
  String get yReactionElation4 =>
      'Ще го запазя като скрийншот за скептиците. За всичките.';

  @override
  String get yReactionElation5 =>
      'Ще съм непоносим заради това цяло десетилетие.';

  @override
  String get yReactionElation6 => 'Точно така. Заради това гледаме.';

  @override
  String get yReactionElation7 => 'Дни като тази плащат за всички останали.';

  @override
  String get yReactionElation8 => 'Най-после. Наистина, най-после.';

  @override
  String get yReactionElation9 =>
      'Супер. Сега го направете пак следващата седмица и ще повярвам.';

  @override
  String get yReactionElation10 =>
      'Наслаждавайте се тази вечер, защото тези ще намерят начин да я развалят.';

  @override
  String get yReactionElation11 =>
      'Една добра вечер не прави никого велик отбор.';

  @override
  String get yReactionRelief0 => 'Не беше красиво, но го взимам всеки път.';

  @override
  String get yReactionRelief1 => 'Някак си. Някак си!';

  @override
  String get yReactionRelief2 => 'Грозно. Три точки. Напред.';

  @override
  String get yReactionRelief3 =>
      'Мога да гледам грозно цял ден, ако носи точки.';

  @override
  String get yReactionRelief4 => 'това ми взе десет години живот';

  @override
  String get yReactionRelief5 => 'Никой да не говори. Никой да не го урочасва.';

  @override
  String get yReactionRelief6 => 'Пулс: неприемлив.';

  @override
  String get yReactionRelief7 => 'Оцеляхме. Това е думата. Оцеляхме.';

  @override
  String get yReactionRelief8 =>
      'Не бива да ни трябва облекчение след такива мачове.';

  @override
  String get yReactionRelief9 =>
      'Облекчен съм и малко ме е срам, че съм облекчен.';

  @override
  String get yReactionRelief10 =>
      'Ако това е стандартът, който аплодираме, имаме проблем.';

  @override
  String get yReactionRelief11 => 'Да се измъкваме е навик, и не е добър.';

  @override
  String get yReactionFury0 => 'Не е достатъчно. Изобщо.';

  @override
  String get yReactionFury1 => 'Някой да ми обясни това бавно.';

  @override
  String get yReactionFury2 => 'Тежко е за гледане и още се сдържам.';

  @override
  String get yReactionFury3 => 'Разочарован съм. Наистина разочарован.';

  @override
  String get yReactionFury4 => 'Пълен позор.';

  @override
  String get yReactionFury5 => 'Искам имена.';

  @override
  String get yReactionFury6 => 'Трия приложението. Връщам го в четвъртък.';

  @override
  String get yReactionFury7 => 'Никой на терена не изглеждаше да го иска.';

  @override
  String get yReactionFury8 =>
      'На всеки четири години е същото. НА ВСЕКИ четири години.';

  @override
  String get yReactionFury9 => 'Това не е игра, а обида.';

  @override
  String get yReactionFury10 =>
      'Хората жертват уикендите и парите си за това. Помислете.';

  @override
  String get yReactionFury11 =>
      'Защитавам този отбор от години. Не тази вечер. Не след това.';

  @override
  String get yReactionDespair0 => 'е, добре.';

  @override
  String get yReactionDespair1 => 'Днес без шеги. Нищо.';

  @override
  String get yReactionDespair2 => 'Отивам да се разходя. Дълго.';

  @override
  String get yReactionDespair3 => 'Свършиха ми думите.';

  @override
  String get yReactionDespair4 => 'Събудете ме след четири години.';

  @override
  String get yReactionDespair5 => 'това е най-мрачният вариант на света';

  @override
  String get yReactionDespair6 => 'Дори не се ядосвам вече. Това е тревожното.';

  @override
  String get yReactionDespair7 => 'Този ще боли дълго.';

  @override
  String get yReactionDespair8 =>
      'Вече не знам какво е това, но не е футболен отбор.';

  @override
  String get yReactionDespair9 =>
      'Отдалечили сме се повече, отколкото бяхме, и никой не го казва.';

  @override
  String get yReactionDespair10 =>
      'Загубено цяло поколение, а решават същите хора.';

  @override
  String get yReactionDespair11 =>
      'Престанете да ми казвате, че е процес. Не води донякъде.';

  @override
  String get yReactionSmugness0 => 'Тихичко, но: казах ви.';

  @override
  String get yReactionSmugness1 => 'запазете си този';

  @override
  String get yReactionSmugness2 => 'Скептиците притихнаха.';

  @override
  String get yReactionSmugness3 => 'Не че някой брои. Аз броя.';

  @override
  String get yReactionSmugness4 =>
      'Казах го през януари. Проверете хронологията.';

  @override
  String get yReactionSmugness5 =>
      'Някои от вас дължат извинение на някои от нас.';

  @override
  String get yReactionSmugness6 =>
      'Нареждам това сред нещата, които казах пръв.';

  @override
  String get yReactionSmugness7 => 'Без злорадство. Малко злорадство.';

  @override
  String get yReactionSmugness8 =>
      'Къде са всички експерти сега? Истински въпрос.';

  @override
  String get yReactionSmugness9 => 'Искам всеки от вас да ми го повтори.';

  @override
  String get yReactionSmugness10 =>
      'Скрийншот, принтиран, рамкиран, изпратен на тези, които се смяха.';

  @override
  String get yReactionSmugness11 =>
      'Ще го напомням до края на живота си и си го заслужихте.';

  @override
  String get yReactionShrug0 => 'случи се. следващия.';

  @override
  String get yReactionShrug1 => 'Добре. Както и да е. Напред.';

  @override
  String get yReactionShrug2 => 'Слагам това в папката „футбол“.';

  @override
  String get yReactionShrug3 => 'Наистина нямам какво да добавя.';

  @override
  String get yReactionShrug4 => 'без мисли, празна глава';

  @override
  String get yReactionShrug5 => 'Събудете ме за следващия.';

  @override
  String get yReactionShrug6 => 'Деветдесет минути, които няма да си върна.';

  @override
  String get yReactionShrug7 => 'Нито тук, нито там, честно казано.';

  @override
  String get yReactionShrug8 =>
      'Не мога да кажа нито едно нещо, което се случи.';

  @override
  String get yReactionShrug9 => 'Поредният такъв. Много са такива.';

  @override
  String get yReactionShrug10 => 'Изгледах всичко и не почувствах нищо.';

  @override
  String get yReactionShrug11 =>
      'Ако никой не го спомене повече, на мен ми е добре.';

  @override
  String get tourThirdsUneven =>
      'Групите са неравни, затова резултатите срещу последния отбор във всяка по-голяма група се отпадат и всички отбори се оценяват по едни и същи мачове.';

  @override
  String get careerExportSave => 'Направи резервно копие на този запис';

  @override
  String get careerBackupAll => 'РЕЗЕРВНО КОПИЕ НА ВСИЧКИ ЗАПИСИ';

  @override
  String get careerBackupAllFailed => 'Резервното копие не можа да се запише.';

  @override
  String get backupTitle => 'РЕЗЕРВНИ КОПИЯ';

  @override
  String get backupBlurb =>
      'Всички записи са в един файл на този телефон и нищо не ги копира само, освен ако не включите автоматичното копие по-долу. Пазете копие в облака, за да не ви струва кариерата изгубен телефон или изтрито приложение.';

  @override
  String get backupBlurbNoAuto =>
      'Всички записи са в един файл на този телефон и нищо не ги копира само. Пазете копие в облака, за да не ви струва кариерата изгубен телефон или изтрито приложение.';

  @override
  String get backupExport => 'КОПИЕ В ОБЛАКА';

  @override
  String get backupExportSubject => 'Записи на FNM';

  @override
  String get backupRestore => 'ВЪЗСТАНОВИ ОТ ФАЙЛ';

  @override
  String get backupRestoreWarnTitle => 'Да заменя ли всички записи?';

  @override
  String get backupRestoreWarnBody =>
      'Възстановяването заменя всички записи на този телефон с тези от файла. Приложението ще се рестартира.';

  @override
  String get backupRestoreConfirm => 'ЗАМЕНИ';

  @override
  String get backupCancel => 'ОТКАЗ';

  @override
  String get backupExported =>
      'Резервното копие е готово. Избери къде да го запазиш.';

  @override
  String get backupFailed => 'Резервното копие не можа да се запише.';

  @override
  String get backupRejectedUnreadable => 'Този файл не можа да се отвори.';

  @override
  String get backupRejectedNotFnm => 'Това не е запис на FNM.';

  @override
  String get backupRejectedNewer =>
      'Този запис е направен от по-нова версия на приложението. Първо го обнови.';

  @override
  String get backupRejectedTooOld =>
      'Този запис е твърде стар, за да бъде възстановен от тази версия.';

  @override
  String get careerShare => 'Сподели тази кариера';

  @override
  String get careerImport => 'ИМПОРТИРАЙ КАРИЕРА';

  @override
  String get careerShareSubject => 'Кариера във FNM';

  @override
  String get careerImported => 'Кариерата е импортирана.';

  @override
  String get careerImportFailedUnreadable => 'Този файл не е кариера на FNM.';

  @override
  String get careerImportFailedNewer =>
      'Тази кариера е експортирана от по-нова версия на приложението. Първо го обнови.';

  @override
  String get careerImportFailedSlotsFull =>
      'Всичките ти слотове за запис са заети. Изтрий запис, за да освободиш място, или отключи неограничените записи.';

  @override
  String get careerImportFailedNeedsPremium =>
      'Тази кариера е отвъд безплатния първи цикъл. Отключи пълната игра, за да я импортираш.';

  @override
  String get careerImportFailedCampaignRun =>
      'Тази кампания вече има текущ опит. Първо го продължи или се откажи от него.';

  @override
  String get careerShareFailed => 'Тази кариера не можа да се експортира.';

  @override
  String get managerRename => 'Смени името';

  @override
  String get managerRenameSave => 'Запази';

  @override
  String get managerTitle => 'СЕЛЕКЦИОНЕР';

  @override
  String get managerSkills => 'ТВОИТЕ УМЕНИЯ';

  @override
  String managerPointsAvailable(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count точки за разпределяне',
      one: '1 точка за разпределяне',
      zero: 'Няма точки за разпределяне',
    );
    return '$_temp0';
  }

  @override
  String get managerPointsHow =>
      'Две точки за всеки завършен цикъл и една за всеки спечелен трофей.';

  @override
  String get managerSkillsScale =>
      'Всяко умение започва от 5 и стига до 20. Вложената точка е завинаги.';

  @override
  String get managerSkillManManagement => 'Работа с играчите';

  @override
  String get managerSkillManManagementBlurb =>
      'Всяка точка прави думите ти към медиите и към играчите с 3% по-въздействащи в съблекалнята.';

  @override
  String get managerSkillTactical => 'Тактика';

  @override
  String get managerSkillTacticalBlurb =>
      'Всяка точка вкарва нова схема с 3% по-бързо, така че смяната на формата ти струва по-малко мачове.';

  @override
  String get managerSkillYouth => 'Развитие на младите';

  @override
  String get managerSkillYouthBlurb =>
      'Всяка точка добавя 1% към талантите, излизащи от академията ти, върху това, с което я финансираш.';

  @override
  String get managerSkillNegotiation => 'Преговори';

  @override
  String get managerSkillNegotiationBlurb =>
      'Всяка точка носи 2% повече пари от федерацията във всеки цикъл.';

  @override
  String get managerStaff => 'ТВОЯТ ЩАБ';

  @override
  String managerStaffWages(String amount) {
    return 'Заплати: $amount на цикъл';
  }

  @override
  String get managerRoleAssistant => 'Помощник-селекционер';

  @override
  String get managerRoleAssistantBlurb =>
      'Ръководи тренировките: по-малко контузии и по-добри млади играчи.';

  @override
  String get managerRoleScout => 'Главен скаут';

  @override
  String get managerRoleScoutBlurb =>
      'Оценява талантите и следващия ти съперник: по-верни звездни оценки и предимство в деня на мача.';

  @override
  String get managerRoleFitness => 'Фитнес треньор';

  @override
  String get managerRoleFitnessBlurb => 'Държи ги на терена.';

  @override
  String staffEffectInjury(int percent) {
    return '$percent% по-малко контузии';
  }

  @override
  String staffEffectYouth(int points) {
    return 'Млади играчи +$points общ рейтинг';
  }

  @override
  String staffHiringInjury(int min, int max) {
    return 'Назначаване на такъв: от $min% до $max% по-малко контузии';
  }

  @override
  String staffHiringYouth(int minPoints, int maxPoints) {
    return 'и млади играчи с +$minPoints до +$maxPoints общ рейтинг';
  }

  @override
  String staffEffectScoutRead(int percent) {
    return 'Оценява точно $percent% от талантите';
  }

  @override
  String staffEffectScoutCaps(int caps) {
    String _temp0 = intl.Intl.pluralLogic(
      caps,
      locale: localeName,
      other: 'Потенциалът е известен след $caps мача',
      one: 'Потенциалът е известен след 1 мач',
    );
    return '$_temp0';
  }

  @override
  String staffEffectScoutDossier(int points) {
    return '+$points рейтинг от досиетата на съперниците';
  }

  @override
  String staffHiringScoutRead(int min, int max) {
    return 'Назначаване на такъв: от $min% до $max% точни оценки';
  }

  @override
  String staffHiringScoutCaps(int minCaps, int maxCaps) {
    return 'и потенциалът е известен с $minCaps до $maxCaps мача по-рано';
  }

  @override
  String staffHiringScoutDossier(int minPoints, int maxPoints) {
    return 'и +$minPoints до +$maxPoints рейтинг във всеки мач';
  }

  @override
  String get staffEffectNone => 'Още без ефект върху състава ти';

  @override
  String get staffVacant => 'Никой на този пост';

  @override
  String get staffLeaveVacant => 'Остави поста празен';

  @override
  String get managerTierNone => 'Няма';

  @override
  String get managerTierBasic => 'Основно';

  @override
  String get managerTierGood => 'Добро';

  @override
  String get managerTierElite => 'Елитно';

  @override
  String get managerFree => 'безплатно';

  @override
  String get managerTraining => 'МЕЖДУ ПРОЗОРЦИТЕ';

  @override
  String get managerTrainingBlurb =>
      'Върху какво работи съставът, когато няма мач.';

  @override
  String get managerFocusBalanced => 'Балансирано';

  @override
  String get managerFocusBalancedBlurb => 'По малко от всичко.';

  @override
  String get managerFocusFitness => 'Физическа форма';

  @override
  String get managerFocusFitnessBlurb => 'По-малко контузии.';

  @override
  String get managerFocusCohesion => 'Сработеност';

  @override
  String get managerFocusCohesionBlurb => 'Схемата се наглася по-бързо.';

  @override
  String get managerFocusYouth => 'Млади';

  @override
  String get managerFocusYouthBlurb => 'Часове с най-младите в групата.';

  @override
  String get tourOfferTitle => 'За първи път ли си тук?';

  @override
  String get tourOfferBody =>
      'Това е голяма игра. Искаш ли бърза обиколка из важните екрани? Отнема минута и можеш да я започнеш отново по всяко време от Настройки.';

  @override
  String get tourOfferYes => 'Покажи ми';

  @override
  String get tourOfferNo => 'Не, благодаря';

  @override
  String get tourBack => 'Назад';

  @override
  String get tourNext => 'Напред';

  @override
  String get tourDone => 'Готово';

  @override
  String get tourSkip => 'Пропусни';

  @override
  String get tourHubTitle => 'Това е цялата игра';

  @override
  String get tourHubBody =>
      'Един бутон, който се променя с хода на цикъла: жребий за гледане, състав за обявяване, мач за игра. Над него са доверието на съвета в теб и целите, които е поставил.';

  @override
  String get tourBudgetTitle => 'Парите на федерацията';

  @override
  String get tourBudgetBody =>
      'Веднъж на всеки четиригодишен цикъл разпределяш касата между отделите. Първо се плаща на щаба ти, така че наемането на елитен скаут е решение срещу академията, а не заедно с нея.';

  @override
  String get tourTacticsTitle => 'Как играе отборът';

  @override
  String get tourTacticsBody =>
      'Схемата ти, стилът ти на игра, капитанът ти и кой изпълнява статичните положения. Ако оставиш последните две неизбрани, играта ще те предупреди преди началния удар, вместо тихомълком да избере вместо теб.';

  @override
  String get tourSquadTitle => 'Всеки, когото можеш да избереш';

  @override
  String get tourSquadBody =>
      'Целият пул, не само съставът: кой е във форма, кой носи контузия, кой е наказан и кой тъкмо е излязъл от академията.';

  @override
  String get tourCallUpsTitle => 'Обявяване на състав';

  @override
  String get tourCallUpsBody =>
      'Обявяваш по един състав за всеки международен прозорец и той играе всички мачове от него, точно както истински селекционер. Контузия в рамките на прозореца вика заместник вместо теб.';

  @override
  String get tourRecordsTitle => 'Твоята кариера';

  @override
  String get tourRecordsBody =>
      'Всичко, което си направил: мачовете, отборните рекорди, трофеите и всяка страна, която си водил.';

  @override
  String get tourCupsTitle => 'Останалият свят';

  @override
  String get tourCupsBody =>
      'Всяка надпревара в момента: групи, класирания и елиминации, включително тези, в които не участваш. Светът продължава да играе, независимо дали си се класирал.';

  @override
  String get settingsTourTitle => 'Повтори урока';

  @override
  String get settingsTourBlurb =>
      'Мини отново през важните екрани от началото.';

  @override
  String get tourBoardTitle => 'Пред кого отговаряш';

  @override
  String get tourBoardBody =>
      'Доверието на съвета в теб и целите, които е поставил за този цикъл. Ако не изпълниш задачата, тук ще го видиш отрано.';

  @override
  String get tourStaffTitle => 'Хората около теб';

  @override
  String get tourStaffBody =>
      'Помощник, скаут и фитнес треньор, наети поименно. Заплатите им излизат от този бюджет преди отделите, така че страхотният скаут е решение срещу академията.';

  @override
  String get tourPlaystyleTitle => 'Твоят стил на игра';

  @override
  String get tourPlaystyleBody =>
      'Схемата е само половин тактика. Това е другата половина: колко високо пресираш, колко си директен, колко рискуваш.';

  @override
  String get settingsTourNoSave =>
      'Първо започни кариера. Обиколката минава през твоите екрани.';

  @override
  String tacticsOutOfPositionAge(int age) {
    return 'Не на място · $age г.';
  }

  @override
  String get federationNextCycleLocked =>
      'Бюджетът за следващия цикъл се определя в началото на самия цикъл, наведнъж. Дотогава виждаш какво правят парите ти.';

  @override
  String get federationBudgetAlreadySet => 'Вече е определен за този цикъл';

  @override
  String yFinalLooms0(String opponent) {
    return '$opponent за голямото събитие. Цяла седмица само за това ще се говори.';
  }

  @override
  String yFinalLooms1(String opponent) {
    return 'Потвърдено: $opponent са между нас и трофея. Четири години за това.';
  }

  @override
  String yFinalLooms2(String opponent) {
    return 'Така. $opponent. Никой няма да спи, докато не свърши.';
  }

  @override
  String yFinalLooms3(String opponent) {
    return 'Следва $opponent и всичко друго може да почака. Каква седмица.';
  }

  @override
  String get matchSetupLeaveToCoach => 'Остави изпълнителите на треньора';

  @override
  String friendliesLikeYourGroup(String rivals) {
    return 'Отбелязани по-долу: отбори, които играят като $rivals, тези, които срещаш в групите си този цикъл.';
  }

  @override
  String newsTransferWindowTitle(int year) {
    return 'Трансферен прозорец · $year';
  }

  @override
  String careerLastAgo(String when) {
    return 'Последно преди $when';
  }

  @override
  String get settingsFreeScopeTitle => 'Един безплатен четиригодишен цикъл';

  @override
  String get settingsFreeScopeBlurb =>
      'Пълен цикъл (квалификации, континенталното ти първенство и Световното първенство) на два записа, всички страни в света, нищо задържано. Безкрайните цикли и неограничените записи са еднократно плащане, с включени обновления.';

  @override
  String get settingsUnlockedTitle => 'Отключено';

  @override
  String get settingsUnlockedBlurb =>
      'Безкрайни цикли, неограничени записи, обновленията са включени. Благодаря.';

  @override
  String get settingsFromDeveloperTitle => 'От разработчика';

  @override
  String get settingsFromDeveloperBlurb =>
      'Football Nations Manager е направена от един човек и ще се поддържа дългосрочно. Никога няма да има реклами или микротранзакции. Ако играта ти харесва, помисли дали да купиш пълната версия. Тя поддържа обновленията.';

  @override
  String get settingsFromDeveloperThanksBlurb =>
      'Football Nations Manager е направена от един човек и ще се поддържа дългосрочно. Никога няма да има реклами или микротранзакции. Благодаря, че купи пълната версия. Тя поддържа обновленията.';

  @override
  String friendliesLikeYourCampaign(String rivals) {
    return 'Отбелязани по-долу: отбори, които играят като $rivals, срещу които тепърва ще играеш.';
  }

  @override
  String get friendliesCloseToYou =>
      'Отбелязани по-долу: отборите, най-близо до теб в световната ранглиста. След жребия отметките следват твоята група.';

  @override
  String transfersMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count трансфера',
      one: '1 трансфер',
    );
    return '$_temp0';
  }

  @override
  String hubRoundPage(int page, int pages) {
    return '$page / $pages';
  }

  @override
  String get transfersNewer => 'По-нови';

  @override
  String get transfersOlder => 'Още';

  @override
  String get transfersPagePrevious => 'Предишна';

  @override
  String get transfersPageNext => 'Следваща';

  @override
  String transfersPageOf(int page, int pages) {
    return 'Страница $page от $pages';
  }

  @override
  String get transfersMovedTo => 'Премина в';

  @override
  String get transfersUnknownClub => 'Неизвестен клуб';

  @override
  String yAgainstThemAgain0(String opponent, int count) {
    return 'Това е среща номер $count срещу $opponent. Някой води сметка и това са те.';
  }

  @override
  String yAgainstThemAgain1(String opponent, int count) {
    return '$opponent пак. $count срещи и още не сме ги разгадали.';
  }

  @override
  String yAgainstThemAgain2(String opponent, int count) {
    return 'Номер $count срещу $opponent. Това вече не е съвпадение.';
  }

  @override
  String yAgainstThemAgain3(String opponent, int count) {
    return 'Играли сме срещу $opponent $count пъти и не сме научили нищо от нито един.';
  }

  @override
  String yAgainstThemAgain4(String opponent, int count) {
    return '$opponent, $count пъти. Знаят точно какво ще направим.';
  }

  @override
  String yAgainstThemAgain5(String opponent, int count) {
    return 'Каквото и да имат $opponent срещу нас, след $count срещи още го имат.';
  }

  @override
  String ySameOldStory0(int count) {
    return 'Това са $count пъти напоследък. Докога ще е просто това, което сме?';
  }

  @override
  String ySameOldStory1(int count) {
    return '$count следобеда като този вече. Това е модел, не късмет.';
  }

  @override
  String ySameOldStory2(int count) {
    return 'Виждали сме точно тази игра $count пъти напоследък. Същият сценарий, същият край.';
  }

  @override
  String ySameOldStory3(int count) {
    return '$count варианта на едни и същи деветдесет минути. Никой не го оправя.';
  }

  @override
  String ySameOldStory4(int count) {
    return '$count пъти. Ако още не виждате модела, не гледате.';
  }

  @override
  String ySameOldStory5(int count) {
    return 'Същата история, $count пъти. Оправданията свършиха преди резултатите.';
  }

  @override
  String get yToldYouSo0 => 'Казах, че това идва, докато всички празнуваха.';

  @override
  String get yToldYouSo1 =>
      'Две добри седмици и отново бяхме златно поколение. И ето ни тук.';

  @override
  String get yToldYouSo2 =>
      'Хората, които ми казваха да се наслаждавам миналия месец, притихнаха.';

  @override
  String get yToldYouSo3 =>
      'Не изпитвам удоволствие от това. Много малко. Малко.';

  @override
  String get yToldYouSo4 =>
      'Никога не беше толкова добре, колкото ви казваха, и това е доказателството.';

  @override
  String get yToldYouSo5 =>
      'Всеки път. Казват ни, че е различно, и всеки път не е.';

  @override
  String get tacticsSubOffAlready => 'Вече е сменен';

  @override
  String get tacticsSubInjured => 'Контузен';

  @override
  String get tacticsSubSentOffMark => 'Изгонен';

  @override
  String get tacticsSubNoneLeft => 'Няма повече смени';

  @override
  String get tacticsUndoLastChange => 'Върни последната смяна';

  @override
  String get matchStrengthTitle => 'КАКВО ДВИЖИ ОТБОРА';

  @override
  String get strengthFactorFamiliarity => 'Наиграна схема';

  @override
  String get strengthFactorFatigue => 'Уморени крака';

  @override
  String get strengthFactorClubForm => 'Форма в клубовете';

  @override
  String get strengthFactorMorale => 'Съблекалня';

  @override
  String get strengthFactorCaptain => 'Капитан';

  @override
  String get strengthFactorStaff => 'Щабът';

  @override
  String get strengthFactorDossier => 'Досие на скаута';

  @override
  String yDebut0(String name) {
    return '$name получава първия си мач за националния отбор. Запомнете името.';
  }

  @override
  String yDebut1(String name) {
    return 'Дебют за $name. Личи си по него, нали?';
  }

  @override
  String yDebut2(String name) {
    return '$name, първи мач за националния отбор. Да видим какво ще направи с него.';
  }

  @override
  String yDebut3(String name) {
    return 'Дебют за $name. На състава му трябваха свежи крака.';
  }

  @override
  String yDebut4(String name) {
    return '$name получи първия си мач за националния. Раздаваме много такива напоследък.';
  }

  @override
  String yDebut5(String name) {
    return 'Дебют за $name. Още един, когото ще забравим до пролетта.';
  }

  @override
  String yDrought0(String name, int count) {
    return '$name не е вкарвал в $count мача и върши всичко останало на терена.';
  }

  @override
  String yDrought1(String name, int count) {
    return '$count мача без гол за $name. Идват на тройки, винаги е било така.';
  }

  @override
  String yDrought2(String name, int count) {
    return '$name: $count мача, без голове.';
  }

  @override
  String yDrought3(String name, int count) {
    return '$count без гол за $name. Струва си да се наблюдава.';
  }

  @override
  String yDrought4(String name, int count) {
    return '$count мача. Без голове. $name не би уцелил и вратата на плевня.';
  }

  @override
  String yDrought5(String name, int count) {
    return '$name не е вкарвал в $count. Пуснете когото и да е друг.';
  }

  @override
  String yRivalryLooms0(String opponent, int count) {
    return 'Следва $opponent. $count срещи и още значи всичко.';
  }

  @override
  String yRivalryLooms1(String opponent, int count) {
    return 'Вече $count пъти срещу $opponent. Нека дойдат.';
  }

  @override
  String yRivalryLooms2(String opponent, int count) {
    return 'Следва $opponent. Играли сме $count пъти.';
  }

  @override
  String yRivalryLooms3(String opponent, int count) {
    return 'Среща номер $count с $opponent тази седмица.';
  }

  @override
  String yRivalryLooms4(String opponent, int count) {
    return '$opponent пак. $count такива и не сме научили нищо.';
  }

  @override
  String yRivalryLooms5(String opponent, int count) {
    return '$count мача срещу $opponent и пак ни бият. Чудесно.';
  }

  @override
  String get positionGoalkeeper => 'Вратар';

  @override
  String get positionLeftBack => 'Ляв защитник';

  @override
  String get positionCentreBack => 'Централен защитник';

  @override
  String get positionRightBack => 'Десен защитник';

  @override
  String get positionDefensiveMid => 'Опорен полузащитник';

  @override
  String get positionCentralMid => 'Централен полузащитник';

  @override
  String get positionAttackingMid => 'Атакуващ полузащитник';

  @override
  String get positionLeftMid => 'Ляв полузащитник';

  @override
  String get positionRightMid => 'Десен полузащитник';

  @override
  String get positionLeftWing => 'Ляво крило';

  @override
  String get positionRightWing => 'Дясно крило';

  @override
  String get positionStriker => 'Централен нападател';

  @override
  String get roleNone => 'Без роля';

  @override
  String get roleTargetMan => 'Таран';

  @override
  String get rolePoacher => 'Голаджия';

  @override
  String get rolePlaymaker => 'Разпределител';

  @override
  String get roleBallWinner => 'Борец за топката';

  @override
  String get roleInvertedWinger => 'Обърнато крило';

  @override
  String get roleBallPlayingDefender => 'Защитник с игра';

  @override
  String get roleNoneBlurb => 'Играе естествената си игра.';

  @override
  String get roleTargetManBlurb =>
      'Печели въздушни дуели и подава. Асистенции и статични положения.';

  @override
  String get rolePoacherBlurb =>
      'Дебне в наказателното поле. Много повече голове.';

  @override
  String get rolePlaymakerBlurb =>
      'Създава положения. Далеч повече асистенции.';

  @override
  String get roleBallWinnerBlurb => 'Прекъсва играта, вместо да я завършва.';

  @override
  String get roleInvertedWingerBlurb =>
      'Влиза навътре и стреля. Повече голове.';

  @override
  String get roleBallPlayingDefenderBlurb => 'Започва атаките от тила.';

  @override
  String get federationDeptYouth => 'Младежка академия';

  @override
  String get federationDeptCommercial => 'Търговия / PR';

  @override
  String get federationDeptMedical => 'Медицина и спортна наука';

  @override
  String get federationDeptNaturalisation => 'Бюро по натурализация';

  @override
  String get federationDeptBoardRelations => 'Връзки със съвета';

  @override
  String get federationDeptYouthBlurb =>
      'По-добри таланти от академията дебютират за страната ти следващия цикъл.';

  @override
  String get federationDeptCommercialBlurb =>
      'Спонсорството носи допълнителни приходи в края на цикъла.';

  @override
  String get federationDeptMedicalBlurb =>
      'По-малко контузии. Съставът ти е на разположение през целия цикъл.';

  @override
  String get federationDeptNaturalisationBlurb =>
      'Повече чуждестранни играчи предлагат да преминат към страната ти.';

  @override
  String get federationDeptBoardRelationsBlurb =>
      'Съветът оценява резултатите ти с повече търпение.';

  @override
  String get federationBuildingAcademy => 'Академия';

  @override
  String get federationBuildingCommercial => 'Търговски щаб';

  @override
  String get federationBuildingMedical => 'Медицински център';

  @override
  String get federationBuildingScouting => 'Скаутско бюро';

  @override
  String get federationBuildingBoardroom => 'Заседателна зала';

  @override
  String get moraleBuoyant => 'Приповдигнат';

  @override
  String get moralePositive => 'Положителен';

  @override
  String get moraleSettled => 'Спокоен';

  @override
  String get moraleUneasy => 'Неспокоен';

  @override
  String get moraleRockBottom => 'На дъното';

  @override
  String get matchTabTimeline => 'ХРОНОЛОГИЯ';

  @override
  String get matchTabStats => 'СТАТИСТИКА';

  @override
  String get matchTabLineups => 'СЪСТАВИ';

  @override
  String get matchPenalty => 'ДУЗПА';

  @override
  String get matchStateLevel => 'Все още е равно';

  @override
  String matchStateLead(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Водиш с $count гола',
      one: 'Водиш с един гол',
    );
    return '$_temp0';
  }

  @override
  String matchStateTrail(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Губиш с $count гола',
      one: 'Губиш с един гол',
    );
    return '$_temp0';
  }

  @override
  String matchPossessionShare(int possession) {
    return '$possession% притежание на топката';
  }

  @override
  String get boardVerdictSackedTitle => 'Съветът те освободи';

  @override
  String boardVerdictSackedBody(int rating) {
    return 'Жалък цикъл (оценка $rating%). Мандатът ти свършва тук. Сега само по-слаби страни ще рискуват с теб.';
  }

  @override
  String get boardVerdictDelightedTitle => 'Съветът е във възторг';

  @override
  String boardVerdictDelightedBody(int rating, String best) {
    return 'Изключителен цикъл (оценка $rating%) след $best. По-големи страни проявяват интерес или можеш да останеш и да градиш.';
  }

  @override
  String get boardVerdictSolidTitle => 'Стабилен цикъл';

  @override
  String boardVerdictSolidBody(int rating) {
    return 'Съветът е доволен (оценка $rating%). Няколко страни с подобен ранг биха те взели, но няма натиск да си тръгваш.';
  }

  @override
  String get boardVerdictExpectedMoreTitle => 'Съветът очакваше повече';

  @override
  String boardVerdictExpectedMoreBody(int rating) {
    return 'Разочароващ цикъл (оценка $rating%). Запазваш поста си, но всички предложения са стъпка надолу.';
  }

  @override
  String get boardVerdictPressureTitle => 'Под сериозен натиск си';

  @override
  String boardVerdictPressureBody(int rating) {
    return 'Слаб цикъл (оценка $rating%). Оставаш на поста, но ако искаш нов старт, интерес проявяват само по-слаби страни.';
  }

  @override
  String get boardVerdictHeroTitle => 'Страната е зад теб';

  @override
  String boardVerdictHeroNote(String nation, int cycles) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles цикъла',
      one: '1 цикъл',
    );
    return ' $nation те обожава, национален герой след $_temp0; работата ти е сигурна, докато сам искаш.';
  }

  @override
  String get boardVerdictTheNation => 'Страната';

  @override
  String get boardVerdictBestQuiet => 'тих цикъл';

  @override
  String get boardVerdictBestCycle => 'този цикъл';

  @override
  String boardVerdictBestWorld(String placement) {
    return 'Световното първенство: $placement';
  }

  @override
  String get finishThirdPlace => 'Трето място';

  @override
  String get finishFourthPlace => 'Четвърто място';

  @override
  String get finishDidNotQualify => 'Не се класира';

  @override
  String get careerRepIconic => 'Емблематичен';

  @override
  String get careerRepRenowned => 'Уважаван';

  @override
  String get careerRepEstablished => 'Утвърден';

  @override
  String get careerRepRising => 'Възходящ';

  @override
  String get careerRepUnproven => 'Непроверен';

  @override
  String get hubOfferStepUp => 'Крачка нагоре';

  @override
  String get hubOfferLateral => 'Равностоен ход';

  @override
  String get hubOfferRebuild => 'Ново изграждане';

  @override
  String careerNationsCupWon(String league) {
    return 'Дивизия $league · Шампиони';
  }

  @override
  String careerNationsCupRunnerUp(String league) {
    return 'Дивизия $league · Вицешампиони';
  }

  @override
  String careerNationsCupSemi(String league) {
    return 'Дивизия $league · Полуфиналист';
  }

  @override
  String careerNationsCupPlaced(String league, int position) {
    return 'Дивизия $league · #$position';
  }

  @override
  String tourRunInto(String round) {
    return 'Следва: $round';
  }

  @override
  String get tourRunIntoThirdPlace => 'Следва мач за трето място';

  @override
  String tourRunThrough(String round) {
    return 'Напред от: $round';
  }

  @override
  String tourRunOut(String round) {
    return 'Отпаднал в: $round';
  }

  @override
  String get tourRunInGroup => 'Борба в груповата фаза';

  @override
  String get tourRunGroupOut => 'Отпаднал в груповата фаза';

  @override
  String resultsCycleTitle(int year, String nation) {
    return 'Цикъл $year · $nation';
  }

  @override
  String resultsCycleRecord(int played, int won, int drawn, int lost) {
    return '$played изиграни  ·  $wonП $drawnР $lostЗ';
  }

  @override
  String resultsCycleFinish(String finish) {
    return 'Световно първенство: $finish';
  }

  @override
  String get resultsCycleUnderway => 'Все още в ход';

  @override
  String yTurnedItRound0(String opponent) {
    return 'На почивката губеха с два гола срещу $opponent и върнаха всичко. Това е отбор.';
  }

  @override
  String yTurnedItRound1(String opponent) {
    return 'Губеха с два гола срещу $opponent, а накрая това нямаше значение. Малко отбори го могат.';
  }

  @override
  String yTurnedItRound2(String opponent) {
    return 'Почивка: два гола зад $opponent. Краен резултат: вече не. Второто полувреме беше друг мач.';
  }

  @override
  String yTurnedItRound3(String opponent) {
    return 'Обърнахме два гола разлика срещу $opponent. Каквото и да е казано на почивката, казвайте го всяка седмица.';
  }

  @override
  String yTurnedItRound4(String opponent) {
    return 'Добре, върнахме го срещу $opponent. Сега някой да обясни първите четиридесет и пет минути.';
  }

  @override
  String yTurnedItRound5(String opponent) {
    return 'Два гола зад $opponent, а сега трябва да се радваме. Оправете първото полувреме.';
  }

  @override
  String yThrewItAway0(String opponent) {
    return 'На почивката водехме с два гола срещу $opponent и всичко се изплъзна. Случва се и на по-добри отбори.';
  }

  @override
  String yThrewItAway1(String opponent) {
    return 'Два гола напред срещу $opponent и всичко се изплъзна. Предстои дълъг цикъл, има време.';
  }

  @override
  String yThrewItAway2(String opponent) {
    return 'Почивка: водим с два гола срещу $opponent. Краен резултат: нищо подобно.';
  }

  @override
  String yThrewItAway3(String opponent) {
    return 'Преднина от два гола срещу $opponent, изтопена за четиридесет и пет минути.';
  }

  @override
  String yThrewItAway4(String opponent) {
    return 'Водехме с два гола и го изпуснахме. Срещу $opponent. Някой ще отговаря за това.';
  }

  @override
  String yThrewItAway5(String opponent) {
    return 'Два гола напред срещу $opponent и пак го докарахме. Всеки път.';
  }

  @override
  String get cycleBackupDone =>
      'Кариерата е запазена в папката FNM на този телефон. Деинсталирането на приложението я изтрива: за копие другаде използвай „Направи резервно копие на този запис“ на екрана със записите.';

  @override
  String get cycleBackupFailed =>
      'Този път кариерата не можа да бъде архивирана.';

  @override
  String pressMomentBigWinWarm1(String opponent) {
    return 'Незабравима вечер срещу $opponent. Колко се гордеете с тази група?';
  }

  @override
  String pressMomentBigWinWarm2(String opponent) {
    return 'Срещу този отбор $opponent нямаха шанс. Това ли е отборът, в който винаги сте вярвали?';
  }

  @override
  String pressMomentBigWinNeutral1(String opponent) {
    return 'Голяма победа над $opponent. Какво реши мача тази вечер?';
  }

  @override
  String pressMomentBigWinNeutral2(String opponent) {
    return 'Победа над $opponent, и то уверена. Къде я спечелихте?';
  }

  @override
  String pressMomentBigWinHostile1(String opponent) {
    return 'Добра победа над $opponent. Една добра вечер: защо някой да вярва, че ще трае?';
  }

  @override
  String pressMomentBigWinHostile2(String opponent) {
    return 'Добър резултат срещу $opponent. Това ли беше Вашият план, или играчите сами го измислиха?';
  }

  @override
  String pressMomentBigLossWarm1(String opponent) {
    return 'Тежка вечер срещу $opponent. Какво казвате на играчите след такава?';
  }

  @override
  String pressMomentBigLossWarm2(String opponent) {
    return 'Никой не очакваше това срещу $opponent. Просто една от онези вечери ли беше?';
  }

  @override
  String pressMomentBigLossNeutral1(String opponent) {
    return 'Отрезвяваща вечер срещу $opponent. Какво се обърка?';
  }

  @override
  String pressMomentBigLossNeutral2(String opponent) {
    return 'Срещу $opponent Ви разглобиха на части. Достатъчно добър ли е този състав?';
  }

  @override
  String pressMomentBigLossHostile1(String opponent) {
    return 'Срещу $opponent бяхте по-слаби във всичко. Как допуснахте да стане толкова зле?';
  }

  @override
  String pressMomentBigLossHostile2(String opponent) {
    return 'Срещу $opponent вкарваха на воля. Къде беше планът тази вечер?';
  }

  @override
  String pressMomentCrisisWarm1(String opponent) {
    return 'Още един мач, който се изплъзва, този път срещу $opponent. Как ще обърнете тази серия?';
  }

  @override
  String pressMomentCrisisWarm2(String opponent) {
    return 'Резултатите секнаха, а срещу $opponent стана още по-зле. Все още ли вярвате в тази група?';
  }

  @override
  String pressMomentCrisisNeutral1(String opponent) {
    return 'Пак без победа, сега срещу $opponent, а съветът следи. Сигурна ли е работата Ви?';
  }

  @override
  String pressMomentCrisisNeutral2(String opponent) {
    return 'След мача с $opponent серията става дълга. Притеснявате ли се за бъдещето си?';
  }

  @override
  String pressMomentCrisisHostile1(String opponent) {
    return 'Сега и срещу $opponent. Предшественикът Ви беше уволнен при такава серия. Защо Вие да оцелеете?';
  }

  @override
  String pressMomentCrisisHostile2(String opponent) {
    return 'След поредна вечер като тази срещу $opponent всяко радио с обаждания иска да си отидете. Бихте ли подали оставка, ако съветът поиска?';
  }

  @override
  String pressMomentJobVerdictWarm1(String opponent) {
    return 'Заложихте работата си на карта и след мача с $opponent не се получи, както искахте. Как го понасяте?';
  }

  @override
  String pressMomentJobVerdictWarm2(String opponent) {
    return 'Трите мача приключиха, последният срещу $opponent. Сами определихте теста. Какво мислите за присъдата?';
  }

  @override
  String pressMomentJobVerdictNeutral1(String opponent) {
    return 'Казахте да Ви съдим по следващите три. След мача с $opponent го направихме. Все още ли сте на поста си?';
  }

  @override
  String pressMomentJobVerdictNeutral2(String opponent) {
    return 'Три мача, последният срещу $opponent, и не каквото обещахте. Говорили ли сте със съвета за бъдещето си?';
  }

  @override
  String pressMomentJobVerdictHostile1(String opponent) {
    return 'Сами определихте теста и го провалихте срещу $opponent. Ще подадете ли оставка?';
  }

  @override
  String pressMomentJobVerdictHostile2(String opponent) {
    return 'Вашите думи, не нашите: съдете ме по следващите три. След мача с $opponent защо още седите там?';
  }

  @override
  String get pressBeatWhoToBlameWarm1 =>
      'Искате повече от тях. Някого конкретно?';

  @override
  String get pressBeatWhoToBlameWarm2 =>
      'Вдигнахте летвата високо. Кой трябва да направи първата крачка?';

  @override
  String get pressBeatWhoToBlameNeutral1 =>
      'Казвате, че някои от тях трябва да се огледат в огледалото. Кого имате предвид?';

  @override
  String get pressBeatWhoToBlameNeutral2 =>
      'Не са достатъчно добри, казвате. За кого говорите?';

  @override
  String get pressBeatWhoToBlameHostile1 =>
      'Говорите уклончиво. Ще назовете ли имена, или всичко се връща към Вас?';

  @override
  String get pressBeatWhoToBlameHostile2 =>
      'Всяка седмица е виновен някой друг. Чия е вината този път?';

  @override
  String get pressBeatIfYouDontWarm1 =>
      'Смели думи. А ако следващият не мине, както искате?';

  @override
  String get pressBeatIfYouDontWarm2 =>
      'Страната ще Ви държи за думата. Ами ако не се получи?';

  @override
  String get pressBeatIfYouDontNeutral1 =>
      'А ако не го спечелите? Какво тогава?';

  @override
  String get pressBeatIfYouDontNeutral2 =>
      'Вече го казахте. Какво става, ако грешите?';

  @override
  String get pressBeatIfYouDontHostile1 =>
      'В тази зала сме чували обещания и преди. Какво дължите на феновете, ако и това се скъса?';

  @override
  String get pressBeatIfYouDontHostile2 =>
      'А когато не се случи, какво ще бъде оправданието?';

  @override
  String get pressBeatFollowUpWarm1 =>
      'Още един въпрос, ако имате сили. Върху какво още трябва да работи тази група?';

  @override
  String get pressBeatFollowUpWarm2 =>
      'Когато утихнат страстите, какво взимате от тази вечер за следващия мач?';

  @override
  String get pressBeatFollowUpNeutral1 =>
      'Да навлезем по-дълбоко. Какво трябва да се подобри до следващия мач?';

  @override
  String get pressBeatFollowUpNeutral2 =>
      'Отвъд резултата: там ли искате да е този състав?';

  @override
  String get pressBeatFollowUpHostile1 =>
      'Много думи, малко казано. Какво всъщност се променя оттук нататък?';

  @override
  String get pressBeatFollowUpHostile2 =>
      'Феновете искат прав отговор. Достатъчно добър ли е този отбор, да или не?';

  @override
  String pressBeatStandoutWarm1(String player) {
    return '$player беше изключителен тази вечер. Докъде може да стигне?';
  }

  @override
  String pressBeatStandoutWarm2(String player) {
    return '$player е във всички заглавия тази вечер. Очаквахте ли го?';
  }

  @override
  String pressBeatStandoutNeutral1(String player) {
    return '$player се открои. Какво му поискахте тази вечер?';
  }

  @override
  String pressBeatStandoutNeutral2(String player) {
    return '$player ли беше разликата тази вечер?';
  }

  @override
  String pressBeatStandoutHostile1(String player) {
    return 'Без $player това е друга история. Това отбор ли е, или един играч?';
  }

  @override
  String pressBeatStandoutHostile2(String player) {
    return '$player беше блестящ. Ваша заслуга или негова?';
  }

  @override
  String pressBeatStrugglerWarm1(String player) {
    return '$player имаше тежка вечер. Влачи ли някаква контузия?';
  }

  @override
  String pressBeatStrugglerWarm2(String player) {
    return '$player не си беше вечерта. Ще го окуражите ли?';
  }

  @override
  String pressBeatStrugglerNeutral1(String player) {
    return '$player се затрудни тази вечер. Запазва ли мястото си?';
  }

  @override
  String pressBeatStrugglerNeutral2(String player) {
    return '$player изоставаше от темпото. Как оценихте играта му?';
  }

  @override
  String pressBeatStrugglerHostile1(String player) {
    return '$player пак беше пътник. Защо продължавате да го избирате?';
  }

  @override
  String pressBeatStrugglerHostile2(String player) {
    return 'Всички виждаха, че $player не е в час. Всички, освен скамейката?';
  }

  @override
  String get pressThrowbackWinNextKeptWarm =>
      'Казахте, че ще спечелите следващия, и го направихте. Приятно ли е да сте прав?';

  @override
  String get pressThrowbackWinNextKeptNeutral =>
      'Обещахте победа в следващия мач и я изпълнихте. Самоувереност или перчене?';

  @override
  String get pressThrowbackWinNextKeptHostile =>
      'Казахте, че ще спечелите следващия, и го направихте. Късмет, или да започнем да Ви слушаме?';

  @override
  String get pressThrowbackWinNextBrokenWarm =>
      'Казахте ни, че ще спечелите онзи мач. Не стана. Какво се обърка?';

  @override
  String get pressThrowbackWinNextBrokenNeutral =>
      'Казахте, че ще спечелите следващия. Не го направихте. Защо да вярваме на следващото обещание?';

  @override
  String get pressThrowbackWinNextBrokenHostile =>
      'Казахте, че ще спечелите следващия. Не го направихте. Значат ли думите Ви още нещо в тази зала?';

  @override
  String get pressThrowbackJobKeptWarm =>
      'Поискахте да Ви съдят по три мача и издържахте. Оправдан ли сте?';

  @override
  String get pressThrowbackJobKeptNeutral =>
      'Съдете ме по следващите три, казахте. Съдихме Ви и резултатите дойдоха. Какво Ви научи този тест?';

  @override
  String get pressThrowbackJobKeptHostile =>
      'Дадохте си три мача и ги преодоляхте. Беше ли тестът някога толкова труден?';

  @override
  String get pressThrowbackJobBrokenWarm =>
      'Поискахте да Ви съдят по три мача. Не излязоха, както искахте. Какво научихте?';

  @override
  String get pressThrowbackJobBrokenNeutral =>
      'Казахте: съдете ме по следващите три. Трите минаха, а с тях и кредитът на доверие. Какво сега?';

  @override
  String get pressThrowbackJobBrokenHostile =>
      'Сами определихте теста и го провалихте. Защо някой да приема думата Ви сега?';

  @override
  String pressThrowbackBackKeptWarm(String player) {
    return 'Подкрепихте $player, когато други не искаха. Той се отплати. Част от заслугата Ваша ли е?';
  }

  @override
  String pressThrowbackBackKeptNeutral(String player) {
    return 'Подкрепихте $player. Той оправда доверието. Вяра или знание?';
  }

  @override
  String pressThrowbackBackKeptHostile(String player) {
    return 'Подкрепихте $player и за веднъж се изплати. Ще бъдете ли толкова сигурен следващия път?';
  }

  @override
  String pressThrowbackBackBrokenWarm(String player) {
    return 'Застанахте зад $player и не се получи. Все още ли вярвате в него?';
  }

  @override
  String pressThrowbackBackBrokenNeutral(String player) {
    return 'Подкрепихте $player. Той не го възнагради. Грешка ли беше?';
  }

  @override
  String pressThrowbackBackBrokenHostile(String player) {
    return 'Вашата преценка или Вашата лоялност: кое се провали с $player?';
  }

  @override
  String pressThrowbackBlameKeptWarm(String player) {
    return 'Бяхте строг към $player и мачовете оттогава Ви дадоха право. Има ли удовлетворение в това?';
  }

  @override
  String pressThrowbackBlameKeptNeutral(String player) {
    return 'Посочихте $player публично, а той не отговори. Има ли път назад за него?';
  }

  @override
  String pressThrowbackBlameKeptHostile(String player) {
    return 'Оставихте $player на произвола и той не се е съвзел. Строшихте ли го?';
  }

  @override
  String pressThrowbackBlameBrokenWarm(String player) {
    return 'Посочихте $player и той Ви отговори на терена. Това ли беше идеята от самото начало?';
  }

  @override
  String pressThrowbackBlameBrokenNeutral(String player) {
    return 'Обвинихте $player и оттогава той е един от най-добрите Ви. Дължите ли му извинение?';
  }

  @override
  String pressThrowbackBlameBrokenHostile(String player) {
    return 'Хвърлихте $player под колелата и оттогава той е най-добрият Ви играч. Ще се извините ли?';
  }

  @override
  String get pressReplyCreditPlayers1 =>
      'Тези играчи ми дадоха всичко. Не бих сменил нито един от тях.';

  @override
  String get pressReplyCreditPlayers2 =>
      'Никой не работи по-здраво от тази група. Ще ги браня цял ден.';

  @override
  String get pressReplyCreditPlayers3 =>
      'От това място няма да чуете лоша дума за моите играчи.';

  @override
  String get pressReplyCreditPlayers4 =>
      'Заслугата е на играчите, не моя. Пишете за тях.';

  @override
  String get pressReplyTakeResponsibility1 =>
      'Това е мой грях. Аз избрах състава и аз го нагласих.';

  @override
  String get pressReplyTakeResponsibility2 =>
      'Съдете мен, не тях. Това е моят отбор и моя отговорност.';

  @override
  String get pressReplyTakeResponsibility3 =>
      'Ако търсите виновен, седя точно тук.';

  @override
  String get pressReplyTakeResponsibility4 =>
      'Отговорността е моя. Оставете играчите настрана.';

  @override
  String get pressReplyDemandMore1 =>
      'Искам повече. Някои от тях знаят точно какво имам предвид.';

  @override
  String get pressReplyDemandMore2 =>
      'На това ниво усилието не стига. Искам повече и им го казах.';

  @override
  String get pressReplyDemandMore3 =>
      'Очаквам повече от всеки един от тях, от утре.';

  @override
  String get pressReplyDemandMore4 =>
      'Някои от тях трябва да се огледат в огледалото. Не съм доволен.';

  @override
  String get pressReplyPromiseWinNext1 =>
      'Ще спечелим следващия. Можете да го запишете.';

  @override
  String get pressReplyPromiseWinNext2 =>
      'Запомнете думите ми: печелим следващия мач.';

  @override
  String get pressReplyPromiseWinNext3 =>
      'Следващия мач печелим. Казвам го тук, за да ме държите за думата.';

  @override
  String get pressReplyPromiseWinNext4 =>
      'Сигурен съм в този отбор. Печелим следващия мач.';

  @override
  String get pressReplyJobOnTheLine1 =>
      'Съдете ме по следващите три мача. Това е честно.';

  @override
  String get pressReplyJobOnTheLine2 =>
      'Дайте ми три мача. Ако дотогава не е наред, съдете ме за това.';

  @override
  String get pressReplyJobOnTheLine3 =>
      'Следващите три ще покажат дали съм подходящият човек. Дръжте ме за думата.';

  @override
  String get pressReplyJobOnTheLine4 =>
      'Три мача. После пишете за мен каквото искате.';

  @override
  String get pressReplyDeflect1 => 'Мач по мач. Нямам какво да добавя.';

  @override
  String get pressReplyDeflect2 => 'Днес няма да ви правя заглавия.';

  @override
  String get pressReplyDeflect3 => 'Следващият мач. Само за него мисля.';

  @override
  String get pressReplyDeflect4 => 'Каквото мисля, остава в съблекалнята.';

  @override
  String get pressReplyTakeCredit1 =>
      'Казах го, защото вярвах в него, и бях прав.';

  @override
  String get pressReplyTakeCredit2 => 'Прочетох го правилно. За това съм тук.';

  @override
  String get pressReplyTakeCredit3 =>
      'Наречете го преценка. Знаех какво казвам.';

  @override
  String get pressReplyTakeCredit4 =>
      'Взех решението и се получи. Приемам това.';

  @override
  String get pressReplyStandByIt1 => 'Казах каквото вярвам. Стоя зад него.';

  @override
  String get pressReplyStandByIt2 => 'Не взимам назад нито дума.';

  @override
  String get pressReplyStandByIt3 =>
      'Същият отговор като тогава. Мислех го и още го мисля.';

  @override
  String get pressReplyStandByIt4 => 'Бих го казал пак утре.';

  @override
  String get pressReplyAdmitMistake1 =>
      'Сгреших в това. Поемам го върху себе си.';

  @override
  String get pressReplyAdmitMistake2 =>
      'Справедливо, преценил съм погрешно. Ще се науча от това.';

  @override
  String get pressReplyAdmitMistake3 => 'Грешах и мога да го кажа.';

  @override
  String get pressReplyAdmitMistake4 => 'Това решение не проработи и беше мое.';

  @override
  String pressReplyBackPlayer1(String player) {
    return '$player има пълната ми подкрепа. Ще се докаже.';
  }

  @override
  String pressReplyBackPlayer2(String player) {
    return 'Вярвам в $player и той ще ви покаже защо.';
  }

  @override
  String pressReplyBackPlayer3(String player) {
    return 'От мен няма да чуете лоша дума за $player. Ще се представи.';
  }

  @override
  String pressReplyBackPlayer4(String player) {
    return '$player остава в плановете ми. Гледайте какво ще направи.';
  }

  @override
  String pressReplyBlamePlayer1(String player) {
    return '$player ни подведе тази вечер и сам го знае.';
  }

  @override
  String pressReplyBlamePlayer2(String player) {
    return 'Очаквах много повече от $player. Той трябва да отговори за това.';
  }

  @override
  String pressReplyBlamePlayer3(String player) {
    return '$player не беше на нивото. Ще го кажа публично.';
  }

  @override
  String pressReplyBlamePlayer4(String player) {
    return 'Това не беше достатъчно от $player и той ще го чуе от мен.';
  }

  @override
  String get pressOnRecordWinNext => 'За протокола: ще спечелиш следващия мач.';

  @override
  String get pressOnRecordJob => 'За протокола: съдим те по следващите три.';

  @override
  String pressOnRecordBack(String player) {
    return 'За протокола: подкрепяш $player.';
  }

  @override
  String pressOnRecordBlame(String player) {
    return 'За протокола: $player те подведе.';
  }

  @override
  String yStatementKept0(String nation) {
    return 'Каза го и стана. $nation има селекционер, който държи на думата си.';
  }

  @override
  String yStatementKept1(String nation) {
    return 'Каза го на глас, после отиде и го направи. Това е човекът, от когото $nation имаше нужда.';
  }

  @override
  String yStatementKept2(String nation) {
    return '$nation: предрече го и се сбъдна. Справедливо.';
  }

  @override
  String yStatementKept3(String nation) {
    return 'Заяви го официално и издържа. Точка за него. $nation продължава напред.';
  }

  @override
  String yStatementKept4(String nation) {
    return 'Позна една. $nation, не свиквай.';
  }

  @override
  String yStatementKept5(String nation) {
    return 'Дори спрелият часовник показва вярно два пъти на ден. $nation извади късмет този път.';
  }

  @override
  String yStatementBroken0(String nation) {
    return 'Каза го и не се получи. Все още съм с него. $nation започва отново.';
  }

  @override
  String yStatementBroken1(String nation) {
    return '$nation: обеща повече, отколкото получихме, но предпочитам селекционер, който вярва в себе си.';
  }

  @override
  String yStatementBroken2(String nation) {
    return '$nation: каза го официално и не се случи. Хората ще помнят.';
  }

  @override
  String yStatementBroken3(String nation) {
    return 'Големи думи, нищо зад тях. $nation: следващия път кажи по-малко.';
  }

  @override
  String yStatementBroken4(String nation) {
    return 'Застана там и ни го каза. После това. $nation заслужава повече от приказки.';
  }

  @override
  String yStatementBroken5(String nation) {
    return 'Думата му не струва нищо сега. Запишете го, $nation.';
  }

  @override
  String get ncZoneNorth => 'Северна зона';

  @override
  String get ncZoneWest => 'Западна зона';

  @override
  String get ncZoneEast => 'Източна зона';

  @override
  String get ncZoneCentralSouthern => 'Централна и Южна зона';

  @override
  String careerNationsCupZoneWon(String zone) {
    return '$zone · Шампиони';
  }

  @override
  String careerNationsCupZoneRunnerUp(String zone) {
    return '$zone · Вицешампиони';
  }

  @override
  String careerNationsCupZoneSemi(String zone) {
    return '$zone · Полуфиналист';
  }

  @override
  String careerNationsCupZoneRoundOf16(String zone) {
    return '$zone · Осминафинал';
  }

  @override
  String careerNationsCupZoneQuarter(String zone) {
    return '$zone · Четвъртфиналист';
  }

  @override
  String careerNationsCupZonePlaced(String zone, int position) {
    return '$zone · #$position';
  }

  @override
  String get objectiveNcFinalsEight => 'Стигни до четвъртфиналите';

  @override
  String get objectiveNcZoneWinGroup => 'Спечели групата си';

  @override
  String get finishNcFinalsEight => 'Четвъртфинали';

  @override
  String get finishNcBottomHalf => 'Долната половина на групата';

  @override
  String get tourContTabZones => 'ЗОНИ';

  @override
  String get tourContTabFinalsEight => 'ЕЛИМИНАЦИИ';

  @override
  String get tourContFinalsEightSoon =>
      'Елиминациите започват през ноември с осминафинали: всички 14 победители в групите и 2 най-добри втори.';

  @override
  String get tourContQuarterFinals => 'ЧЕТВЪРТФИНАЛИ';

  @override
  String get tourContZoneAdvancement =>
      'Всеки победител в група продължава към осминафиналите, а към тях се добавят 2 най-добри втори. Никой не изпада.';

  @override
  String tourContZoneHeadingYours(String zone) {
    return '$zone ★';
  }

  @override
  String get compNorthAmericaNationsCup => 'Nations Cup на Северна Америка';

  @override
  String get compAfricanNationsCup => 'Nations Cup';

  @override
  String get objectiveNcWinItNorthAmerica =>
      'Спечели Nations Cup на Северна Америка';

  @override
  String get objectiveNcWinItAfrica => 'Спечели Nations Cup';

  @override
  String get objectiveNcReachFinalNorthAmerica =>
      'Стигни до финала на Nations Cup на Северна Америка';

  @override
  String get objectiveNcReachFinalAfrica => 'Стигни до финала на Nations Cup';

  @override
  String get finishNcChampionsNorthAmerica =>
      'Победители в Nations Cup на Северна Америка';

  @override
  String get finishNcChampionsAfrica => 'Победители в Nations Cup';

  @override
  String pressAimQualWarm1(String competition) {
    return 'Квалификациите за $competition започват и страната вярва в този отбор. Към какво се стремите?';
  }

  @override
  String pressAimQualWarm2(String competition) {
    return 'Нова квалификационна кампания за $competition и настроението е приповдигнато. Докъде може да стигне този отбор?';
  }

  @override
  String pressAimQualNeutral1(String competition) {
    return 'Започват квалификациите за $competition. Каква е целта за тази кампания?';
  }

  @override
  String pressAimQualNeutral2(String competition) {
    return 'Квалификациите за $competition са тук. Къде виждате този отбор в крайното класиране?';
  }

  @override
  String pressAimQualHostile1(String competition) {
    return 'Квалификациите за $competition започват и мнозина се съмняват, че ще стигнете дотам. Какво им казвате?';
  }

  @override
  String pressAimQualHostile2(String competition) {
    return 'Поредна квалификационна кампания за $competition. Защо някой да вярва, че тази ще е различна?';
  }

  @override
  String pressAimFinalsWarm1(String competition) {
    return 'Тук е $competition и цялата страна е зад Вас. Докъде можете да стигнете?';
  }

  @override
  String pressAimFinalsWarm2(String competition) {
    return 'Вие сте на $competition и феновете мечтаят. Каква е целта?';
  }

  @override
  String pressAimFinalsNeutral1(String competition) {
    return '$competition започва тази седмица. Какво би се броило за успех?';
  }

  @override
  String pressAimFinalsNeutral2(String competition) {
    return 'Първият Ви мач на $competition наближава. Поставете ни цел.';
  }

  @override
  String pressAimFinalsHostile1(String competition) {
    return 'Тук е $competition и никой не очаква много. На какво наистина се надявате?';
  }

  @override
  String pressAimFinalsHostile2(String competition) {
    return 'Вие сте на $competition, но съмненията не са изчезнали. Каква е целта Ви?';
  }

  @override
  String pressBeatRivalWarm1(String rival) {
    return 'Попаднахте в група с $rival. Притесняват ли Ви?';
  }

  @override
  String pressBeatRivalWarm2(String rival) {
    return 'Жребият Ви изправи срещу $rival. Как виждате този мач?';
  }

  @override
  String pressBeatRivalNeutral1(String rival) {
    return 'Най-силен в групата Ви изглежда отборът на $rival. Той ли е фаворит?';
  }

  @override
  String pressBeatRivalNeutral2(String rival) {
    return 'Какво мислите за $rival?';
  }

  @override
  String pressBeatRivalHostile1(String rival) {
    return 'В групата Ви е $rival. Бъдете честен, справяте ли се с този съперник?';
  }

  @override
  String pressBeatRivalHostile2(String rival) {
    return 'Повечето хора очакват $rival да Ви победи. Грешат ли?';
  }

  @override
  String pressBeatKeyPlayerWarm1(String player) {
    return '$player е във върхова форма. Дошъл ли е неговият миг?';
  }

  @override
  String pressBeatKeyPlayerWarm2(String player) {
    return '$player е във всички заглавия. Може ли да носи този отбор?';
  }

  @override
  String pressBeatKeyPlayerNeutral1(String player) {
    return 'Колко зависи тази кампания от $player?';
  }

  @override
  String pressBeatKeyPlayerNeutral2(String player) {
    return 'Готов ли е $player да поведе този отбор?';
  }

  @override
  String pressBeatKeyPlayerHostile1(String player) {
    return 'Ако $player не е в най-добрата си форма, има ли този отбор нещо?';
  }

  @override
  String pressBeatKeyPlayerHostile2(String player) {
    return '$player носи много на раменете си. Прекалено много ли?';
  }

  @override
  String get pressReplyAimHigher1 =>
      'Отиваме по-далеч, отколкото някой очаква.';

  @override
  String get pressReplyAimHigher2 =>
      'Искам повече от поисканото от федерацията и го казвам на глас.';

  @override
  String get pressReplyMatchBrief1 => 'Знаем целта и ще я постигнем.';

  @override
  String get pressReplyMatchBrief2 => 'Федерацията постави цел. Ще я изпълним.';

  @override
  String get pressReplyPlayDown1 => 'Да вървим мач по мач.';

  @override
  String get pressReplyPlayDown2 => 'Без големи обещания. Ще видим докъде сме.';

  @override
  String get pressReplyPromiseQualify1 =>
      'Ще се класираме. Можете да го запишете.';

  @override
  String get pressReplyPromiseQualify2 => 'Този отбор ще бъде на финалите.';

  @override
  String get pressReplyFearNobody1 => 'Не се страхуваме от никого.';

  @override
  String get pressReplyFearNobody2 => 'Те също трябва да играят срещу нас.';

  @override
  String get pressReplyRespectRival1 => 'Те са фаворитите и ги уважаваме.';

  @override
  String get pressReplyRespectRival2 =>
      'Много добър отбор. Ще ни трябва най-доброто от нас.';

  @override
  String get pressReplyTeamFirst1 =>
      'Става дума за целия отбор, не за един играч.';

  @override
  String get pressReplyTeamFirst2 => 'Никой не печели сам.';

  @override
  String pressOnRecordTarget(String aim) {
    return 'За протокола: $aim.';
  }

  @override
  String get pressOnRecordPlayDown => 'За протокола: без обещания.';

  @override
  String get pressThrowbackTargetKeptWarm =>
      'Поставихте цел преди кампанията и я постигнахте. Най-гордият Ви момент ли е досега?';

  @override
  String get pressThrowbackTargetKeptNeutral =>
      'Казахте какво ще постигнете и го постигнахте. Съмнявахте ли се някога?';

  @override
  String get pressThrowbackTargetKeptHostile =>
      'Постигнахте целта, която си поставихте. Късмет, или наистина беше планът?';

  @override
  String get pressThrowbackTargetBrokenWarm =>
      'Поставихте цел и не я достигнахте. Какво се обърка?';

  @override
  String get pressThrowbackTargetBrokenNeutral =>
      'Обещахте повече, отколкото този отбор даде. Съжалявате ли, че го казахте?';

  @override
  String get pressThrowbackTargetBrokenHostile =>
      'Приказвахте големи неща преди кампанията и не достигнахте. Защо да Ви вярваме сега?';

  @override
  String hubEventPressPreviewSub(String competition) {
    return 'Пресата иска да чуе целите ти за $competition';
  }

  @override
  String deptLevelCost(int level, String amount) {
    return 'Ниво $level · $amount';
  }

  @override
  String get formOnFire => 'В пламъци';

  @override
  String get formGood => 'Във форма';

  @override
  String get formSteady => 'Стабилен';

  @override
  String get formPoor => 'Извън форма';

  @override
  String get formCold => 'Вледенен';

  @override
  String get playerFormTitle => 'ФОРМА И КОНДИЦИЯ';

  @override
  String playerFormAverage(String rating) {
    return 'Средно $rating в последните си мачове';
  }

  @override
  String get playerFormNoGames => 'Няма достатъчно скорошни мачове за преценка';

  @override
  String playerFormNextMatch(String delta) {
    return '$delta към оценката му в следващия мач';
  }

  @override
  String get playerFormNoEffect => 'Без промяна в оценката му в следващия мач';

  @override
  String playerFormSquadShare(String delta) {
    return 'Включва $delta за целия състав (дух, базов лагер)';
  }

  @override
  String get sideGroupHome => 'Начало';

  @override
  String get sideGroupTeam => 'Отбор';

  @override
  String get sideGroupCompetitions => 'Състезания';

  @override
  String get sideGroupFederation => 'Федерация';

  @override
  String get sideGroupHistory => 'История';

  @override
  String get sideInbox => 'Входящи';

  @override
  String get sideSquad => 'Състав';

  @override
  String get sideTactics => 'Тактика';

  @override
  String get sideMainMenu => 'Главно меню';

  @override
  String get sideCallUps => 'Повиквания';

  @override
  String get sideTournaments => 'Турнири';

  @override
  String get sideRanking => 'Ранглиста';

  @override
  String get sideResults => 'Резултати';

  @override
  String get sideFinances => 'Финанси';

  @override
  String get sideBoard => 'Съвет';

  @override
  String get sideManager => 'Селекционер и щаб';

  @override
  String get sideRecords => 'Рекорди';

  @override
  String get sideLegends => 'Легенди';

  @override
  String get sideHeadToHead => 'Директни двубои';

  @override
  String get sideAchievements => 'Постижения';

  @override
  String get sideCareer => 'Кариера';

  @override
  String get topBarNext => 'Следва';

  @override
  String get topBarDrawPending => 'Предстои жребий';

  @override
  String get paneFullProfile => 'Пълен профил';

  @override
  String get panePickPlayer => 'Избери играч, за да видиш картата му тук';

  @override
  String get inboxPickMessage => 'Избери съобщение, за да го прочетеш тук';

  @override
  String get inboxFilterAll => 'Всички';

  @override
  String get panelViewAll => 'Виж всички';

  @override
  String get gridViewOverview => 'Общо';

  @override
  String get gridColCondition => 'Кондиция';

  @override
  String get gridColStatus => 'Статус';

  @override
  String get gridColRank => 'Място';

  @override
  String get gridColMove => 'Промяна';

  @override
  String get gridColNation => 'Страна';

  @override
  String get gridColRegion => 'Регион';

  @override
  String get gridColPoints => 'Точки';

  @override
  String get panePickNation => 'Избери страна, за да видиш представянето ѝ тук';

  @override
  String get resultsCyclesTitle => 'Цикли';

  @override
  String get tourDrawStart => 'Започни жребия';

  @override
  String get tourDrawViewGroups => 'Виж групите';

  @override
  String get gridColCeiling => 'Таван';

  @override
  String get gridColYearGain => 'Растеж';

  @override
  String get gridColMarkedAt => 'При добавяне';

  @override
  String get budgetSetupTitle => 'Задай бюджета си';

  @override
  String get budgetEffectsTitle => 'Какво купува този бюджет';

  @override
  String get naturalisationTitle => 'Натурализация';

  @override
  String get yTrending => 'Актуално';

  @override
  String get yVoices => 'Гласове';

  @override
  String get yConversation => 'Разговор';

  @override
  String get allTimeRecordsTitle => 'Световни рекорди за всички времена';

  @override
  String get h2hMeetingsTitle => 'Всички срещи';

  @override
  String get h2hPickOpponent => 'Избери съперник, за да видиш всички срещи тук';

  @override
  String get savesTitle => 'Записи';

  @override
  String get gridColPlayer => 'Играч';

  @override
  String get gridColPos => 'Поз';

  @override
  String get gridColActive => 'Активен';

  @override
  String get gridColMotm => 'ИНМ';

  @override
  String get gridColAvg => 'Ср.';

  @override
  String get gridColOpponent => 'Съперник';

  @override
  String get gridColStarts => 'Титуляр';

  @override
  String get gridColTournaments => 'Турнири';

  @override
  String get gridColDate => 'Дата';

  @override
  String get gridColLastPlayed => 'Последно играно';

  @override
  String get gridColManager => 'Селекционер';

  @override
  String nationsShownCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count страни',
      one: '1 страна',
    );
    return '$_temp0';
  }

  @override
  String get nationsSortedByRank => 'Подредени по световна ранглиста';

  @override
  String get nationsStrength => 'Сила';

  @override
  String nationsStrengthOf(int tier) {
    return '$tier от 5';
  }

  @override
  String get nationsSquadOverall => 'Общ рейтинг на състава';

  @override
  String get nationsOpeningBudget => 'Начален бюджет';

  @override
  String get nationsStarPlayer => 'Звезден играч';

  @override
  String nationsStarTile(String position, int rating) {
    return 'Звезда $position $rating';
  }

  @override
  String nationsStarAge(int age) {
    return 'Възраст $age';
  }

  @override
  String get nationsBoardExpects => 'Съветът очаква';

  @override
  String nationsManage(String nation) {
    return 'Поеми $nation';
  }

  @override
  String get nationsManagerNext => 'Следва да назовеш селекционера си';

  @override
  String get playerPageTitle => 'Играч';

  @override
  String get nationPageTitle => 'Страна';

  @override
  String get friendliesYourGames => 'Твоите контролни мачове';

  @override
  String hubEventInjuryCover(String player) {
    return 'Замести контузения $player';
  }

  @override
  String hubEventInjuryCoverSub(int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: 'Отпада за $matches мача',
      one: 'Отпада за следващия мач',
    );
    return '$_temp0. Повикай някого или играй без него.';
  }

  @override
  String get injuryCoverTitle => 'ЗАМЯНА';

  @override
  String injuryCoverBanner(String player, String position) {
    return '$player ($position) е контузен. Повикай когото и да е извън състава, на всяка позиция, или го задръж и играй с него.';
  }

  @override
  String injuryCoverConfirm(String player) {
    return 'Повикай $player';
  }

  @override
  String injuryCoverKeep(String player) {
    return 'Задръж $player и играй';
  }

  @override
  String get injuryCoverPick => 'Избери замяна';

  @override
  String get injuryCoverNone =>
      'Никой извън състава не е годен да се присъедини.';

  @override
  String get nationNowRanking => 'Световна ранглиста';

  @override
  String get nationNowForm => 'Форма';

  @override
  String get nationNowNoForm => 'Още няма изиграни мачове';

  @override
  String get nationNowNext => 'Следващ мач';

  @override
  String get nationNowNoNext => 'Няма насрочен мач';

  @override
  String get nationNowSquad => 'Състав';

  @override
  String get nationNowAgainstYou => 'Срещу теб';

  @override
  String nationNowRecord(int w, int d, int l) {
    return '$wП $dР $lЗ';
  }

  @override
  String get nationNowLastMeeting => 'Последна среща';

  @override
  String nationNowOverall(int value) {
    return 'Рейтинг $value';
  }

  @override
  String get hubUpcoming => 'ПРЕДСТОЯЩИ';

  @override
  String get hubFullSchedule => 'Пълна програма';

  @override
  String get scheduleTitle => 'Програма';

  @override
  String get scheduleToday => 'Днес';

  @override
  String get scheduleKnockoutPending => 'Елиминационна фаза, ако преминеш';

  @override
  String get scheduleNextRoundPending => 'Следващ кръг';

  @override
  String scheduleFromDate(String date) {
    return 'От $date';
  }

  @override
  String get scheduleHomeShort => 'Д';

  @override
  String get scheduleAwayShort => 'Г';

  @override
  String get tacticsNoPresetsInMatch =>
      'Още няма запазена тактика. Запази една от екрана за тактика преди мача.';

  @override
  String get homeCampaigns => 'Кампании';

  @override
  String get homeContinueCampaign => 'ПРОДЪЛЖИ КАМПАНИЯТА';

  @override
  String homeCampaignCycle(String date, int cycle, int total) {
    return '$date · Цикъл $cycle от $total';
  }

  @override
  String get campaignsTitle => 'Кампании';

  @override
  String get campaignTransplantTitle => 'Трансплантацията';

  @override
  String get campaignTransplantTwist =>
      'Осем от най-добрите на Италия преминават към Сан Марино';

  @override
  String get campaignTransplantGoal => 'Класирай се за Европейското първенство';

  @override
  String get campaignGrudgeTitle => 'Вражда';

  @override
  String get campaignGrudgeTwist => 'Грузия и Албания в една група';

  @override
  String get campaignGrudgeGoal => 'Завърши пред Албания в квалификациите';

  @override
  String get campaignTransplantIntro =>
      'Националният отбор на Сан Марино никога не е имал квалификационна кампания, която да заслужава името. После осем от най-добрите на Италия вземат паспорта и влизат. Имаш един цикъл, за да превърнеш една рядкост в отбор.';

  @override
  String get campaignGrudgeIntro =>
      'Грузия и Албания са изтеглени в една и съща квалификационна група и никоя няма да прости загуба. Завърши пред Албания, после виж докъде можеш да го отнесеш.';

  @override
  String get campaignStars1Transplant => 'Класиране';

  @override
  String get campaignStars2Transplant => 'Стигни до елиминациите';

  @override
  String get campaignStars3Transplant => 'Спечели Европейското първенство';

  @override
  String get campaignStars1Grudge => 'Пред Албания';

  @override
  String get campaignStars2Grudge => 'И се класирай';

  @override
  String get campaignStars3Grudge => 'И я победи два пъти';

  @override
  String get campaignFree => 'Безплатна';

  @override
  String get campaignStart => 'Старт';

  @override
  String get campaignPartOfUnlimited => 'Част от Unlimited';

  @override
  String get campaignResume => 'Продължи';

  @override
  String get campaignAbandon => 'Откажи се';

  @override
  String get campaignAbandonConfirm =>
      'Да се откажеш от този опит? Прогресът се губи; печатът ти остава.';

  @override
  String get campaignMoveToSaves => 'Премести в записите';

  @override
  String get campaignCannotContinue =>
      'Светът на тази кампания е твърде далеч от реалния, за да продължи като кариера.';

  @override
  String get campaignMoveSlotsFull =>
      'Слотовете ти за запис са пълни. Освободи един първо.';

  @override
  String get campaignStampConquered => 'Покорена';

  @override
  String get campaignStampFailed => 'Неуспех';

  @override
  String get campaignDifficultyHard => 'Трудна';

  @override
  String get campaignDifficultyMedium => 'Средна';

  @override
  String get campaignGoalLabel => 'Цел';

  @override
  String get campaignStarsLabel => 'Звезди';

  @override
  String get campaignRunInProgress => 'Тази кампания вече има опит в ход.';

  @override
  String get campaignVerdictWon => 'Покорена';

  @override
  String get campaignVerdictLost => 'Не този път';

  @override
  String get campaignVerdictContinue => 'Продължи';

  @override
  String campaignProgressQualifying(String position) {
    return 'Квалификации: $position';
  }

  @override
  String campaignProgressRival(String rival, String position) {
    return '$rival: $position';
  }

  @override
  String campaignProgressFinals(String stage) {
    return 'Финали: $stage';
  }

  @override
  String get campaignRunInNumbers => 'Опитът в числа';

  @override
  String campaignRunMeetings(int won, int played) {
    return 'Спечелени срещи: $won от $played';
  }

  @override
  String campaignPlace(String which, int n) {
    String _temp0 = intl.Intl.selectLogic(
      which,
      {
        'first': '1-во',
        'second': '2-ро',
        'third': '3-то',
        'other': 'място $n',
      },
    );
    return '$_temp0';
  }

  @override
  String get campaignGuineasTitle => 'Най-добрата от Гвинеите';

  @override
  String get campaignGuineasTwist =>
      'Екваториална Гвинея, най-малката от африканските Гвинеи, за два цикъла';

  @override
  String get campaignGuineasGoal => 'Победи Гвинея и Гвинея-Бисау';

  @override
  String get campaignGuineasIntro =>
      'Три африкански страни носят името Гвинея, а Екваториална Гвинея е най-малката от тях. Имаш два цикъла, за да победиш поне веднъж Гвинея и Гвинея-Бисау, после виж докъде можеш да стигнеш в Африканското първенство. Папуа Нова Гвинея, четвъртата Гвинея, вече е записана за контролен мач.';

  @override
  String get campaignStars1Guineas => 'Победи Гвинея и Гвинея-Бисау';

  @override
  String get campaignStars2Guineas => 'И се класирай за Африканско първенство';

  @override
  String get campaignStars3Guineas =>
      'И стигни до четвъртфинал на Африканско първенство';

  @override
  String get campaignYoungFinnsTitle => 'Младите фини';

  @override
  String get campaignYoungFinnsTwist =>
      'Златното поколение тийнейджъри на Финландия, за три цикъла';

  @override
  String get campaignYoungFinnsGoal => 'Класирай се за Световно първенство';

  @override
  String get campaignYoungFinnsIntro =>
      'Възрастните играчи на Финландия са се отдръпнали и златно поколение е заело мястото им: всеки играч, когото можеш да избереш, е на 18 или по-малко. Засега са сурови, но имат таланта да станат един от най-добрите отбори в света, точно както младото поколение на Норвегия. Имаш три цикъла, за да ги заведеш на Световно първенство, а после да спечелиш Европейското първенство и Световното първенство.';

  @override
  String get campaignStars1YoungFinns => 'Класирай се за Световно първенство';

  @override
  String get campaignStars2YoungFinns => 'Спечели Европейското първенство';

  @override
  String get campaignStars3YoungFinns => 'Спечели Световното първенство';

  @override
  String get campaignGreenlandTitle => 'Гренландски век';

  @override
  String get campaignGreenlandTwist =>
      'Гренландия заема мястото на Сан Марино в Европа, за сто години';

  @override
  String get campaignGreenlandGoal => 'Класирай се за Европейско първенство';

  @override
  String get campaignGreenlandIntro =>
      'Гренландия никога не е играла официален международен мач. В този свят тя е заела мястото на Сан Марино в Европа и започва от самото дъно на световната ранглиста: аматьори, изкуствени терени и сезон, притиснат между снеговете. Имаш сто години, двадесет и пет цикъла, за да стигнеш до Европейско първенство, после до Световно първенство и, ако смееш да мечтаеш, да спечелиш едно от тях.';

  @override
  String get campaignStars1Greenland => 'Класирай се за Европейско първенство';

  @override
  String get campaignStars2Greenland => 'Класирай се за Световно първенство';

  @override
  String get campaignStars3Greenland =>
      'Спечели Европейското или Световното първенство';

  @override
  String get campaignZanzibarTitle => 'Възходът на Занзибар';

  @override
  String get campaignZanzibarTwist =>
      'Занзибар заема мястото на Чад в Африка, за сто години';

  @override
  String get campaignZanzibarGoal => 'Класирай се за Африканско първенство';

  @override
  String get campaignZanzibarIntro =>
      'Занзибар има своя футболна федерация и свой национален отбор, но няма място нито в африканския, нито в световния футбол. В този свят той е заел мястото на Чад в Африка и започва близо до дъното на световната ранглиста: островни футболисти, малки стадиони и жегата на мусоните. Имаш сто години, двадесет и пет цикъла, за да стигнеш до Африканско първенство, после до Световно първенство и, ако смееш да мечтаеш, да спечелиш Световното първенство.';

  @override
  String get campaignStars1Zanzibar => 'Класирай се за Африканско първенство';

  @override
  String get campaignStars2Zanzibar => 'Класирай се за Световно първенство';

  @override
  String get campaignStars3Zanzibar => 'Спечели Световното първенство';

  @override
  String get campaignPro => 'Pro';

  @override
  String campaignProgressCup(String cup, String year, String status) {
    return '$cup $year: $status';
  }

  @override
  String get campaignCupNotQualified => 'Не се класира';

  @override
  String get campaignCupOpen => 'Предстои да се реши';

  @override
  String campaignWorldRenames(String nation) {
    return 'Тази база данни преименува държава, върху която е изградена кампанията: $nation.';
  }

  @override
  String newsYouthTitle1(String name, String level) {
    return '$name блести за отбора $level';
  }

  @override
  String newsYouthTitle2(String name, String level) {
    return 'Доклад от академията: $name прави впечатление';
  }

  @override
  String newsYouthTitle3(String name, String level) {
    return 'Звездата на отбора $level: $name';
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
      other: '$count пъти',
      one: 'веднъж',
    );
    return '$name се разписа $_temp0 за отбора $level срещу $opponent в последния международен прозорец.';
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
      other: '$count гола',
      one: 'Един гол',
    );
    return '$_temp0 от $name, когато отборът $level се изправи срещу $opponent в този прозорец.';
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
      other: '$count гола',
      one: 'един гол',
    );
    return 'Отборът $level игра срещу $opponent, а $name напусна терена с $_temp0 в актива си.';
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
      other: '$count гола',
      one: 'един гол',
    );
    return '$name подаде за $_temp0 на отбора $level срещу $opponent и дирижираше играта от началото до края.';
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
      other: '$count асистенции',
      one: 'една асистенция',
    );
    return 'Отборът $level срещна $opponent в този прозорец, а конците дърпаше $name: $_temp0 и игра, за която треньорският щаб още говори.';
  }

  @override
  String newsYouthCleanSheet1(String name, String level, String opponent) {
    return '$name беше великолепен, а отборът $level запази мрежата си суха срещу $opponent.';
  }

  @override
  String newsYouthCleanSheet2(String name, String level, String opponent) {
    return 'Суха мрежа за отбора $level срещу $opponent, и заслугата е най-вече на $name.';
  }

  @override
  String newsYouthDisplay1(
    String name,
    String level,
    String opponent,
    int mark,
  ) {
    return '$name впечатли за отбора $level срещу $opponent, а щабът оцени играта му с $mark от десет.';
  }

  @override
  String newsYouthDisplay2(
    String name,
    String level,
    String opponent,
    int mark,
  ) {
    return 'Отборът $level игра срещу $opponent в този прозорец, а треньорите отличиха $name: $mark от десет, най-високата оценка в отбора.';
  }

  @override
  String get newsYouthDevReady1 =>
      'В тази форма вече е достатъчно добър, за да бъде обмислен за мъжкия национален отбор.';

  @override
  String get newsYouthDevReady2 =>
      'Щабът смята, че е готов за мъжки футбол още сега. Решението е твое.';

  @override
  String get newsYouthDevClose1 =>
      'Развива се добре и е близо до пробив в мъжкия национален отбор.';

  @override
  String get newsYouthDevClose2 =>
      'Не му остава много до мъжкия национален отбор и още един добър сезон може да е достатъчен.';

  @override
  String get newsYouthDevGrowing1 =>
      'Развива се добре, макар че до мъжкия отбор има още стъпка или две.';

  @override
  String get newsYouthDevGrowing2 =>
      'Има още работа, преди да стане национал при мъжете, но всичко сочи в правилната посока.';

  @override
  String get newsYouthDevRaw1 =>
      'Все още е суров и на няколко години от мъжкия отбор, но талантът личи ясно.';

  @override
  String get newsYouthDevRaw2 =>
      'Рано е, а треньорите от академията искат търпение, а не заглавия.';

  @override
  String get newsYouthStrengthGkPhysical =>
      'Обхватът и владеенето на наказателното поле са това, което го отличава.';

  @override
  String get newsYouthStrengthGkTechnical =>
      'Хващането и подаванията му са най-добрите, които академията е виждала от години.';

  @override
  String get newsYouthStrengthGkStamina =>
      'Концентрацията му никога не спада: в деветдесетата минута е толкова остър, колкото и в първата.';

  @override
  String get newsYouthStrengthDefPhysical =>
      'Скоростта и играта с глава са ключът към играта му.';

  @override
  String get newsYouthStrengthDefTechnical =>
      'Чете играта далеч над възрастта си и е спокоен с топката.';

  @override
  String get newsYouthStrengthDefStamina =>
      'Никога не се изключва и в последната минута все още спринтира назад.';

  @override
  String get newsYouthStrengthMidPhysical =>
      'Отнема топката с истинска сила и веднага я понася напред.';

  @override
  String get newsYouthStrengthMidTechnical =>
      'Визията и разнообразието на подаванията му са ключът към играта му.';

  @override
  String get newsYouthStrengthMidStamina =>
      'Двигателят му е забележителен: покрива всяка педя от терена.';

  @override
  String get newsYouthStrengthFwdPhysical =>
      'Скоростта зад защитата и силата във въздуха го правят проблем за всяка отбрана.';

  @override
  String get newsYouthStrengthFwdTechnical =>
      'Завършващият удар и движението в наказателното поле са ключът към играта му.';

  @override
  String get newsYouthStrengthFwdStamina =>
      'Преса отпред през целия мач и не дава на защитниците нито миг спокойствие.';

  @override
  String pressMomentBigWinWarm3(String opponent) {
    return 'Феновете дълго ще пеят за този мач срещу $opponent. Какво казахте на играчите при последния съдийски сигнал?';
  }

  @override
  String pressMomentBigWinNeutral3(String opponent) {
    return 'Това беше заявка срещу $opponent. Колко от това дойде от тренировъчното игрище?';
  }

  @override
  String pressMomentBigWinHostile3(String opponent) {
    return 'Браво за резултата срещу $opponent, но такива вечери сме виждали и преди. Какво е различно този път?';
  }

  @override
  String pressMomentBigLossWarm3(String opponent) {
    return 'Всеки има лоша вечер и тази срещу $opponent беше такава. Колко бързо можете да я оставите зад гърба си?';
  }

  @override
  String pressMomentBigLossNeutral3(String opponent) {
    return '$opponent беше по-добър във всяка линия. Откъде започвате поправките?';
  }

  @override
  String pressMomentBigLossHostile3(String opponent) {
    return 'Феновете си тръгваха преди края срещу $opponent. Можете ли да ги обвините?';
  }

  @override
  String pressMomentCrisisWarm3(String opponent) {
    return 'Серията е тежка, а $opponent не я направи по-лека. Какво Ви държи?';
  }

  @override
  String pressMomentCrisisNeutral3(String opponent) {
    return 'Още един мач без победа, този път срещу $opponent. Колко още може да продължи това, преди съветът да се намеси?';
  }

  @override
  String pressMomentCrisisHostile3(String opponent) {
    return 'Сега и $opponent. Остана ли нещо от плана Ви, или е време да отстъпите място на някой друг?';
  }

  @override
  String get pressReplyCreditPlayers5 =>
      'Каквото и да пишете, пишете го за играчите. Заслужили са го.';

  @override
  String get pressReplyCreditPlayers6 =>
      'Имам група, която би минала през огън един за друг. Това не е малко.';

  @override
  String get pressReplyTakeResponsibility5 =>
      'Аз вземам решенията, значи критиките са за мен. Такава е работата.';

  @override
  String get pressReplyTakeResponsibility6 =>
      'Погледнете първо селекционера. Сбърках в някои неща и ще ги поправя.';

  @override
  String get pressReplyDemandMore5 =>
      'Добре не е достатъчно тук. Казах им го в очите.';

  @override
  String get pressReplyDemandMore6 =>
      'Никой в тази съблекалня няма гарантирано място. Вече го знаят.';

  @override
  String get pressReplyDeflect5 =>
      'Можете да попитате по три различни начина. Отговорът ще е същият.';

  @override
  String get pressReplyDeflect6 =>
      'Мислите си ще запазя за играчите. Ще разберете.';

  @override
  String yWinRoutine12(String opponent, String score) {
    return '$score срещу $opponent. Спокоен, контролиран, зрял футбол. Приятно е да се гледа.';
  }

  @override
  String yWinRoutine13(String opponent, String score) {
    return 'Победа над $opponent с $score, без капка пот. Този отбор става добър в скуката, а скуката печели трофеи.';
  }

  @override
  String yWinRoutine14(String opponent, String score) {
    return '$opponent $score. Три точки, никаква драма, обратно на работа.';
  }

  @override
  String yWinRoutine15(String opponent, String score) {
    return 'Рутинно $score срещу $opponent. Никой няма да го помни и никой не трябва.';
  }

  @override
  String yWinRoutine16(String opponent, String score) {
    return '$score срещу $opponent и пак някак си се тревожа.';
  }

  @override
  String yWinRoutine17(String opponent, String score) {
    return 'Победа над $opponent с $score. Срещу истински отбор такава игра се наказва.';
  }

  @override
  String yWinTight12(String opponent, String score) {
    return '$score срещу $opponent. Стиснахме зъби, страдахме, победихме. Това е отбор.';
  }

  @override
  String yWinTight13(String opponent, String score) {
    return 'Победа над $opponent с $score само на нерви. Предпочитам отбор, който отказва да губи.';
  }

  @override
  String yWinTight14(String opponent, String score) {
    return '$opponent $score. До последната секунда, но точките са наши.';
  }

  @override
  String yWinTight15(String opponent, String score) {
    return 'Минимално $score срещу $opponent. Малка разлика, такъв е футболът.';
  }

  @override
  String yWinTight16(String opponent, String score) {
    return '$score срещу $opponent. Един щастлив рикошет на другата страна и щяхме да водим съвсем друг разговор.';
  }

  @override
  String yWinTight17(String opponent, String score) {
    return 'Удържахме на косъм срещу $opponent, $score. Никой да не нарича това игра.';
  }

  @override
  String yDrew12(String opponent, String score) {
    return '$score с $opponent. Не е загуба, а някои дни работата е точно това.';
  }

  @override
  String yDrew13(String opponent, String score) {
    return 'Трудно извоювана точка срещу $opponent, $score. Хареса ми борбеността.';
  }

  @override
  String yDrew14(String opponent, String score) {
    return '$opponent $score. Точките поделени, както казваха старите коментатори.';
  }

  @override
  String yDrew15(String opponent, String score) {
    return '$score с $opponent. Никой от двата отбора не направи достатъчно за повече.';
  }

  @override
  String yDrew16(String opponent, String score) {
    return '$score с $opponent. Онзи вид равен, който в автобуса на връщане се усеща като загуба.';
  }

  @override
  String yDrew17(String opponent, String score) {
    return 'Равен $score с $opponent. Все говорим за напредък и все правим това.';
  }

  @override
  String yLost12(String opponent, String score) {
    return '$score от $opponent. Боли, но видях достатъчно, за да вярвам в този отбор.';
  }

  @override
  String yLost13(String opponent, String score) {
    return 'Загуба с $score от $opponent, а те бяха добри. Признаваме и продължаваме.';
  }

  @override
  String yLost14(String opponent, String score) {
    return '$opponent $score. Една загуба, няколко урока и следващият мач скоро.';
  }

  @override
  String yLost15(String opponent, String score) {
    return 'Загубихме с $score от $opponent. Трудно е да се спори.';
  }

  @override
  String yLost16(String opponent, String score) {
    return '$score от $opponent. Същите грешки като миналия път, направени със същата самоувереност.';
  }

  @override
  String yLost17(String opponent, String score) {
    return 'Загуба с $score от $opponent. Ако никой не носи отговорност за това, какво правим изобщо?';
  }

  @override
  String get yReactionShrug12 =>
      'На мен ми стига. Не всяка вечер трябва да има фойерверки.';

  @override
  String get yReactionShrug13 =>
      'Точките са си точки. Тази нощ ще спя спокойно.';

  @override
  String get yReactionShrug14 => 'Гледах. Без коментар.';

  @override
  String get yReactionShrug15 => 'Някъде между нормално и нормално.';

  @override
  String get yReactionShrug16 =>
      'Платих стрийминга за това. Никога повече (ще се върна).';

  @override
  String get yReactionShrug17 =>
      'Деветдесет минути нищо във формата на футбол.';

  @override
  String get yReactionRelief12 => 'Пак дишам. Горд съм, че издържаха.';

  @override
  String get yReactionRelief13 =>
      'Такива победи градят отбор. Грозното е красиво.';

  @override
  String get yReactionRelief14 => 'Ноктите ги няма, но точките са тук.';

  @override
  String get yReactionRelief15 =>
      'Последен съдийски сигнал никога не е звучал толкова хубаво.';

  @override
  String get yReactionRelief16 => 'Радвам се, че победихме, тревожа се как.';

  @override
  String get yReactionRelief17 => 'Все се измъкваме. Един ден няма да успеем.';

  @override
  String get yReactionFury12 => 'Обичам този отбор и точно затова боли.';

  @override
  String get yReactionFury13 =>
      'Лоша вечер. Следващия път ни дължат едно и го знаят.';

  @override
  String get yReactionFury14 =>
      'Изключих на седемдесетата минута. Трябваше на шейсетата.';

  @override
  String get yReactionFury15 => 'Без борба, без идеи, без оправдания.';

  @override
  String get yReactionFury16 =>
      'Едни и същи проблеми всеки път и никой нищо не оправя.';

  @override
  String get yReactionFury17 =>
      'Някой в централата трябва да изгледа това отново и да ни го обясни.';

  @override
  String get backupShareHint =>
      'Създава един файл с резервно копие на всички записи. Изберете Google Drive, iCloud Drive или Файлове, за да го пазите.';

  @override
  String backupLastAt(String date) {
    return 'Последно копие: $date';
  }

  @override
  String get backupNever => 'Още няма копие';

  @override
  String get backupRemindersTitle => 'Напомняния за копие';

  @override
  String get backupRemindersBlurb =>
      'Съобщение във входящата поща, когато последното копие започне да остарява.';

  @override
  String get backupAutoICloudTitle => 'Автоматично копие в iCloud';

  @override
  String get backupAutoDriveTitle => 'Автоматично копие в Google Drive';

  @override
  String get backupAutoBlurb =>
      'Прави копие след мачове, в края на цикъла и когато излезете от приложението. Пази последните две.';

  @override
  String get backupStatusUploading => 'Прави се копие.';

  @override
  String get backupStatusUploaded => 'Копието е направено.';

  @override
  String get backupStatusICloudSignedOut =>
      'iCloud е изключен. Влезте в iCloud и включете iCloud Drive от приложението Настройки.';

  @override
  String get backupStatusDriveSignedOut =>
      'Не сте влезли. Включете превключвателя, за да влезете с Google.';

  @override
  String get backupStatusNotConfigured =>
      'Още не е налично в тази версия на приложението.';

  @override
  String get backupStatusUnavailable =>
      'Облакът не е достъпен в момента. Ще опита отново по-късно.';

  @override
  String get backupStatusFailed =>
      'Последното автоматично копие не се получи. Ще опита отново по-късно.';

  @override
  String backupDriveSignedInAs(String email) {
    return 'Влезли сте като $email';
  }

  @override
  String get backupDriveSignOut => 'ИЗХОД';

  @override
  String get backupDriveSignInFailed =>
      'Влизането с Google не успя. Опитайте по-късно.';

  @override
  String get backupRestoreICloud => 'ВЪЗСТАНОВЯВАНЕ ОТ ICLOUD';

  @override
  String get backupRestoreDrive => 'ВЪЗСТАНОВЯВАНЕ ОТ GOOGLE DRIVE';

  @override
  String get backupCrossPlatformHelp =>
      'Минавате между iPhone и Android? Направете копие във файл на единия телефон и възстановете от този файл на другия.';

  @override
  String get backupCloudListBlurb =>
      'Копия от вашите устройства в този профил. Докоснете едно, за да го възстановите.';

  @override
  String get backupCloudListEmpty =>
      'Още няма намерени копия. Новото копие може да стигне до друго устройство след няколко минути.';

  @override
  String get backupCloudListFailed =>
      'Копията не можаха да бъдат прочетени. Проверете връзката и опитайте отново.';

  @override
  String get backupCloudThisDevice => 'Това устройство';

  @override
  String backupCloudMore(int count) {
    return 'Още записи: $count';
  }

  @override
  String get backupCloudNewer =>
      'Направено с по-нова версия на приложението. Първо обновете.';

  @override
  String get backupCloudDownloading => 'Изтегля се копието.';

  @override
  String get backupRestoreSafetyNote =>
      'Първо на този телефон се пази копие на сегашните записи.';

  @override
  String get backupRejectedSafety =>
      'Не можа да се запази копие на сегашните записи, затова нищо не е заменено.';

  @override
  String get newsBackupReminderTitle => 'Време за резервно копие';

  @override
  String get newsBackupReminderBody =>
      'Записите ви са само на този телефон. Отворете Настройки и докоснете Копие в облака или включете там автоматичното копие. Тези напомняния могат да се изключат също от Настройки.';

  @override
  String get backupSafetyTitle => 'Копия отпреди възстановяване';

  @override
  String get backupSafetyBlurb =>
      'Пазят се на този телефон, в случай че възстановяването е било грешка. Пазят се трите най-нови.';

  @override
  String get backupSafetyRestore => 'ВЪЗСТАНОВИ';

  @override
  String get backupSafetyShare => 'СПОДЕЛИ';

  @override
  String get saveUpgradeFailedTitle => 'Записът не можа да бъде обновен';

  @override
  String get saveUpgradeFailedBody =>
      'Записаната ви игра не можа да бъде обновена. Нищо не е изтрито, а копие отпреди обновяването е запазено на този телефон.';

  @override
  String get saveUpgradeRestoreButton =>
      'Възстанови копието отпреди обновяването';

  @override
  String get saveUpgradeRestoreFailed =>
      'Копието не можа да бъде възстановено. Записаната ви игра остана непроменена.';

  @override
  String get saveOpenFailedTitle => 'Записите не можаха да бъдат отворени';

  @override
  String get saveOpenFailedBody =>
      'Записаните ви игри не можаха да бъдат отворени. Нищо не е изтрито. Опитайте отново след малко.';

  @override
  String get backupCloudNoDetails => 'Подробностите още пристигат.';

  @override
  String get tacticsLibraryTitle => 'БИБЛИОТЕКА С ТАКТИКИ';

  @override
  String get tacticsLibraryBlurb =>
      'Тактиките от библиотеката можете да заредите във всеки запис, включително в нов. Ролите и изпълнителите на статични положения се пазят по позиция, а не по играч.';

  @override
  String get tacticsSaveToLibrary => 'Запази в библиотеката';

  @override
  String get tacticsLoadFromLibrary => 'Зареди от библиотеката';

  @override
  String get tacticsLibraryEmpty =>
      'Библиотеката ви е празна. Запазете тактика тук и ще можете да я зареждате във всеки запис.';

  @override
  String tacticsLibrarySaved(String name) {
    return '„$name“ е запазена в библиотеката';
  }

  @override
  String tacticsLibraryLoaded(String name) {
    return 'Заредено „$name“';
  }

  @override
  String tacticsLibraryNotFitted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count роли или изпълнители на статични положения не пасваха на този състав.',
      one:
          '1 роля или изпълнител на статични положения не пасна на този състав.',
    );
    return '$_temp0';
  }

  @override
  String get tacticsLibraryRename => 'Преименувай';

  @override
  String get tacticsLibraryRenameTitle => 'Преименуване на тактика';

  @override
  String get tacticsLibraryDelete => 'Изтрий';

  @override
  String tacticsLibraryDeleteTitle(String name) {
    return 'Да се изтрие ли „$name“?';
  }

  @override
  String get tacticsLibraryDeleteBody =>
      'Ще изчезне от библиотеката във всичките ви записи.';

  @override
  String get tacticsLibraryNameTaken =>
      'В библиотеката ви вече има тактика с това име.';

  @override
  String tacticsLibraryCouldNotLoad(String error) {
    return 'Библиотеката не можа да се зареди.\n$error';
  }

  @override
  String hostBidHeading(String competition, int year) {
    return 'Кандидатура за домакинство: $competition $year';
  }

  @override
  String get hostBidScreenTitle => 'Кандидатура';

  @override
  String get hostBidBlurb =>
      'Домакинът се тегли чрез жребий между кандидатите. Кандидатурата дава повече тежест на името ви: стадионите ви дават начален шанс, а парите го увеличават, макар всеки следващ милион да носи малко по-малко. Парите се харчат, независимо дали печелите.';

  @override
  String hostBidPrize(String amount) {
    return 'Ако спечелите, ставате домакин, класирате се автоматично и получавате еднократна субсидия от $amount за следващия бюджет.';
  }

  @override
  String get hostBidChance => 'Шанс за домакинство';

  @override
  String get hostBidBaseLabel => 'Стадиони и позиция';

  @override
  String get hostBidInvestLabel => 'Инвестиция';

  @override
  String hostBidCeiling(String nation, String percent) {
    return 'Таван за $nation: $percent';
  }

  @override
  String get hostBidInvestment => 'Вашата инвестиция';

  @override
  String hostBidFreeFunds(String amount) {
    return 'Свободни средства: $amount';
  }

  @override
  String get hostBidSubmit => 'Подай кандидатура';

  @override
  String get hostBidDecline => 'Не този път';

  @override
  String get hostBidUnavailable => 'Тази кандидатура вече не е отворена.';

  @override
  String hostBidWonTitle(String competition, int year) {
    return 'Кандидатурата спечели: $competition $year';
  }

  @override
  String hostBidWonBody(String amount) {
    return 'Ще бъдем домакини на турнира и като домакин се класираме автоматично. Еднократна субсидия от $amount вече е в касата на федерацията и можете да я разпределите към отделите в този цикъл направо от главния екран.';
  }

  @override
  String hostBidLostTitle(String competition, int year) {
    return 'Кандидатурата загуби: $competition $year';
  }

  @override
  String hostBidLostBody(String hosts) {
    return 'Домакинството получи: $hosts. Този път кандидатурата ни не стигна и вложените пари са загубени, но федерацията се представи добре.';
  }

  @override
  String get hostBidGrantEvent => 'Разпредели субсидията за домакинство';

  @override
  String hostBidGrantBanner(String amount) {
    return 'Субсидия за домакинство: $amount, които можете да добавите веднага към отделите в този цикъл. Вече разпределеното остава, а остатъкът стои в касата.';
  }

  @override
  String get stadiumsTitle => 'Национални стадиони';

  @override
  String get stadiumsEntrySub => 'Модернизирайте стадион или постройте нов';

  @override
  String get stadiumsBlurb =>
      'Нивото на стадиона е неговият размер: ниво 1 под 15 000 места, ниво 2 от 15 000, ниво 3 от 25 000, ниво 4 от 40 000, ниво 5 от 60 000. Всеки стадион носи малък приход в началото на всеки цикъл, повече при повече места, стига феновете да ги пълнят. Разширението добавя места веднага и малко репутация от следващия цикъл; намаляването съкращава поддръжката, но нищо не се възстановява. Стадионите ви решават за кои турнири можете да кандидатствате.';

  @override
  String stadiumsIncome(String amount) {
    return 'Приходи от стадиони: $amount на цикъл';
  }

  @override
  String stadiumsReputation(int points) {
    return 'Репутация от стадиони: +$points';
  }

  @override
  String get stadiumsClosed =>
      'Строителните работи се възлагат в началото на цикъла, преди да е разпределен бюджетът.';

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
    return 'Модернизирай: $cost';
  }

  @override
  String get stadiumsTopLevel => 'Най-високо ниво';

  @override
  String stadiumsOpens(int year) {
    return 'В строеж, открива се през $year г.';
  }

  @override
  String get stadiumsBuildTitle => 'Построй нов стадион';

  @override
  String get stadiumsBuildBody =>
      'Доста скъпо: нов стадион в избран от вас град, отворен от началото на следващия цикъл.';

  @override
  String get stadiumsBuildCity => 'Град';

  @override
  String stadiumsBuildButton(String cost) {
    return 'Построй: $cost';
  }

  @override
  String get stadiumsBuilding => 'Вече се строи един стадион.';

  @override
  String get stadiumsNoCity => 'Всеки град вече има нов стадион.';

  @override
  String stadiumsConfirmUpgrade(String stadium, int level, String cost) {
    return 'Да се модернизира ли $stadium до ниво $level за $cost?';
  }

  @override
  String stadiumsConfirmBuild(String city, String cost) {
    return 'Да се построи ли нов стадион за $cost? Град: $city';
  }

  @override
  String get stadiumsConfirm => 'Потвърди';

  @override
  String get stadiumsCancel => 'Отказ';

  @override
  String get stadiumsRefused => 'Поръчката не мина. Нищо не е платено.';

  @override
  String get stadiumsNameLabel => 'Име на стадиона';

  @override
  String get stadiumsNameHint =>
      'Оставете празно, за да запазите предложеното име.';

  @override
  String get stadiumsRename => 'Преименувай стадиона';

  @override
  String get hostBidSectionTitle => 'Кандидатури за домакинство';

  @override
  String get hostBidOpenSub =>
      'По желание. Решете преди началото на новия цикъл.';

  @override
  String get hostBidDecidedAtRollover =>
      'Домакинът се обявява с началото на новия цикъл.';

  @override
  String get hostBidLodged =>
      'Кандидатурата е подадена. Домакинът се обявява с началото на новия цикъл.';

  @override
  String get hostBidDeclinedNote => 'Този път решихте да не кандидатствате.';

  @override
  String get hostBidOpensLater =>
      'Отговаряте на условията. Можете да кандидатствате в края на този цикъл.';

  @override
  String get hostBidNoFunds =>
      'Няма достатъчно свободни средства за кандидатура.';

  @override
  String hostBidNeedStadiums(int count, String seats) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Нужни са ви още $count стадиона с $seats+ места.',
      one: 'Нужен ви е още 1 стадион с $seats+ места.',
    );
    return '$_temp0';
  }

  @override
  String hostBidBarredConf(String confederation) {
    return '$confederation беше домакин на последното Световно първенство.';
  }

  @override
  String get hostBidRecentHost =>
      'Бяхте домакин на едно от последните три издания.';

  @override
  String get hostBidBelowBar =>
      'Стадионите ти не отговарят на изискванията на този турнир.';

  @override
  String get hostBidRulesPending =>
      'Дали можете да кандидатствате, ще стане ясно, когато бъдат обявени домакините на този цикъл.';

  @override
  String get hostBidBackToBack =>
      'Вие сте домакин на турнира точно преди този. Никоя страна не е домакин на два поредни турнира.';

  @override
  String get hostBidOneOnly =>
      'Вече кандидатствахте за другия турнир. Никоя страна не е домакин на два поредни турнира, затова можете да кандидатствате само за един.';

  @override
  String hostBidRequirement(
    int grounds,
    String minSeats,
    int bigGrounds,
    String bigSeats,
  ) {
    return 'Условие: $grounds стадиона с $minSeats+ места, от тях $bigGrounds с $bigSeats+.';
  }

  @override
  String hostBidWonBodyBudget(String amount) {
    return 'Ще бъдем домакини на турнира и се класираме автоматично като домакин. Еднократна помощ от $amount вече е в средствата на федерацията, готова за бюджета на този цикъл.';
  }

  @override
  String get hubStadiumIncome => 'Приходи от стадиони';

  @override
  String get stadiumsDownsize => 'Намали';

  @override
  String stadiumsConfirmDownsize(String stadium, String seats, int level) {
    return 'Да се намали ли $stadium до $seats места (ниво $level)? Нищо не се възстановява, но разходите за поддръжка падат.';
  }

  @override
  String get stadiumsResizedThisCycle => 'Преустроен в този цикъл';

  @override
  String stadiumsGroundIncome(String amount) {
    return 'Носи $amount на цикъл';
  }

  @override
  String hostBidLapsedTitle(String competition, int year) {
    return 'Кандидатурата е оттеглена: $competition $year';
  }

  @override
  String hostBidLapsedBodyNation(String nation) {
    return 'Кандидатурата беше за $nation, а новия цикъл започвате другаде. Тя е оттеглена и нищо не е удържано.';
  }

  @override
  String get hostBidLapsedBodyFunds =>
      'При приключването на цикъла средствата на федерацията вече не покриваха залога. Кандидатурата е оттеглена и нищо не е удържано.';

  @override
  String get stadiumsViewMap => 'Карта';

  @override
  String get stadiumsViewList => 'Списък';

  @override
  String get stadiumsMapPickCity =>
      'Докоснете град, за да построите там нов стадион.';

  @override
  String get stadiumsMapFit => 'Покажи цялата страна';

  @override
  String get campaignLegacyTitle => 'Довърши наследството';

  @override
  String get campaignLegacyTwist =>
      'Испания, действащ европейски шампион, за един цикъл';

  @override
  String get campaignLegacyGoal => 'Защити европейската титла';

  @override
  String get campaignLegacyIntro =>
      'Испания е действащ европейски шампион, а скептиците наричат златния период случайност. Имаш един цикъл да докажеш обратното: защити короната на континента, а после тръгни към света. Добави и Nations Cup и наследството е завършено.';

  @override
  String get campaignStars1Legacy => 'Спечели Европейското първенство';

  @override
  String get campaignStars2Legacy => 'И Световното първенство';

  @override
  String get campaignStars3Legacy => 'И Nations Cup';

  @override
  String get campaignSectionOneCycle => 'Един цикъл';

  @override
  String get campaignSectionShort => 'Няколко цикъла';

  @override
  String get campaignSectionLong => 'На дълъг път';

  @override
  String get campaignFilterAll => 'Всички';

  @override
  String get campaignFilterNew => 'Неиграни';

  @override
  String get campaignFilterInProgress => 'В ход';

  @override
  String get campaignFilterDone => 'Завършени';

  @override
  String get campaignFilterEmpty => 'Тук все още няма кампании.';

  @override
  String campaignStarsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count звезди',
      one: '1 звезда',
      zero: 'Без звезди',
    );
    return '$_temp0';
  }

  @override
  String campaignCycles(int cycles) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles цикъла',
      one: '1 цикъл',
    );
    return '$_temp0';
  }

  @override
  String get msgIntlRetireNoteHigh => ' Той се оттегля на върха, като шампион.';

  @override
  String get msgIntlRetireNoteMissed =>
      ' Пропускането на финалите беше последната капка.';

  @override
  String get msgIntlRetireNoteSurprise => ' Никой не го очакваше.';

  @override
  String get msgIntlRetireNoteRecord =>
      ' Тръгва си като рекордьор на националния отбор.';

  @override
  String msgIntlRetireNewsTitle(String nation, String name) {
    return '$nation: $name се оттегля от националния отбор';
  }

  @override
  String msgIntlRetireNewsBody(String name, String nation, int age) {
    return '$name ($nation) обяви оттеглянето си от международния футбол на $age г.';
  }

  @override
  String msgIntlComebackTitle(String name) {
    return '$name се завръща в националния отбор';
  }

  @override
  String msgIntlComebackBody(String name, int age) {
    return '$name отново е на разположение за повиквателна, на $age г.';
  }

  @override
  String get msgIntlComebackNoteCrisis =>
      ' С отбор, покосен от контузии, той отговори на повикването.';

  @override
  String get msgIntlComebackNoteManager => ' Новият селекционер го убеди.';

  @override
  String msgIntlComebackNewsTitle(String nation, String name) {
    return '$nation: $name се завръща в националния отбор';
  }

  @override
  String msgIntlComebackNewsBody(String name, String nation, int age) {
    return '$name ($nation) отново е на разположение за повиквателна, на $age г.';
  }

  @override
  String playerIntlRetired(int year) {
    return 'Оттеглил се от националния отбор, $year';
  }

  @override
  String playerIntlComeback(int year) {
    return 'Завръщане в националния отбор, $year';
  }

  @override
  String yLegendRetires0(String name) {
    return 'Благодарим, $name. Едни носят фланелката, той носеше отбора.';
  }

  @override
  String yLegendRetires1(String name) {
    return '$name слага край на кариерата си в националния отбор. Край на една епоха.';
  }

  @override
  String yLegendRetires2(String name) {
    return '$name се оттегля. Честно казано, с един турнир по-късно.';
  }

  @override
  String yLegendRetires3(String name) {
    return 'Значи $name приключи. Време е за младите.';
  }

  @override
  String matchAltitudeOpponentsTire(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'Надморска височина $altitudeString м: съперникът ще се умори по-бързо';
  }

  @override
  String matchAltitudeYouTire(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'Надморска височина $altitudeString м: вашите играчи ще се уморят по-бързо';
  }

  @override
  String matchAltitudeBothTire(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'Надморска височина $altitudeString м: и двата отбора ще се уморят по-бързо';
  }

  @override
  String matchAltitudeUsedTo(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'Надморска височина $altitudeString м: и двата отбора са свикнали';
  }

  @override
  String matchHeatExpected(int temp) {
    final intl.NumberFormat tempNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String tempString = tempNumberFormat.format(temp);

    return 'Жега: очакват се $tempString°C, силите ще свършат по-рано';
  }

  @override
  String get matchConditionsAdvice =>
      'Планирайте смените рано: тук свежите крака струват повече';

  @override
  String get fanMoodFurious => 'бесни';

  @override
  String get fanMoodRestless => 'неспокойни';

  @override
  String get fanMoodCalm => 'спокойни';

  @override
  String get fanMoodUpbeat => 'въодушевени';

  @override
  String get fanMoodEuphoric => 'в еуфория';

  @override
  String matchHomeFans(String mood) {
    return 'Домакински фенове: $mood';
  }

  @override
  String federationFans(String mood) {
    return 'Феновете: $mood';
  }

  @override
  String federationFansIncome(String change) {
    return 'Приходи от стадиони през следващия цикъл: $change';
  }

  @override
  String yFansProtest0(String nation, String manager) {
    return 'Двайсет години следвам националния отбор у дома и навън. Няма да подновя абонаментната си карта, докато нещо не се промени.';
  }

  @override
  String yFansProtest1(String nation, String manager) {
    return 'Ще продължим да пеем за фланелката. Но транспарантът на северната трибуна тази вечер каза това, което всички мислим.';
  }

  @override
  String yFansProtest2(String nation, String manager) {
    return 'Половината стадион празен, а другата половина цяло второ полувреме скандираше #${manager}Out.';
  }

  @override
  String yFansProtest3(String nation, String manager) {
    return 'Феновските групи говорят за бойкот на следващия домакински мач. Трудно е да ги обвиниш.';
  }

  @override
  String yFansProtest4(String nation, String manager) {
    return '#${manager}Out. Вече дори не съм ядосан. Просто приключих.';
  }

  @override
  String yFansProtest5(String nation, String manager) {
    return 'Снимка от тази вечер: редици празни седалки и един чаршаф с надпис #${manager}Out. Това е репортажът.';
  }

  @override
  String yFansSellOut0(String nation) {
    return 'Пак разпродадено. Най-добрият национален отбор от години, и цялата страна го знае.';
  }

  @override
  String yFansSellOut1(String nation) {
    return 'Билетите за следващия домакински мач свършиха за единайсет минути. Този отбор ни върна уикендите.';
  }

  @override
  String yFansSellOut2(String nation) {
    return 'Нито едно свободно място за следващия домакински мач. Федерацията ще брои приходите от билети с усмивка.';
  }

  @override
  String yFansSellOut3(String nation) {
    return 'Пак разпродадено. Говорете каквото искате за тактиката, хората искат да са на този стадион.';
  }

  @override
  String yFansSellOut4(String nation) {
    return 'Разпродадено, добре. Същите хора освиркваха този отбор преди година и половина.';
  }

  @override
  String yFansSellOut5(String nation) {
    return 'Изведнъж разпродадено, изведнъж всички експерти. Къде бяхте, когато не можехме да бием никого?';
  }

  @override
  String get campaignsIntro =>
      'Кампаниите са специално създадени предизвикателства: зададен национален отбор, свят със собствен обрат и цел, която трябва да постигнеш за определен брой цикли. Всеки опит е отделен от записаните ти кариери, а колкото по-далеч стигнеш, толкова повече звезди печелиш, до три.';

  @override
  String hubEventScandal(String player) {
    return 'Скандал на лагера: $player';
  }

  @override
  String get hubEventScandalSub => 'Да го пратиш вкъщи или да го задържиш?';

  @override
  String get scandalTitle => 'СКАНДАЛ';

  @override
  String scandalStoryParty(String player) {
    return '$player беше на купон до зори, а снимките бяха във всички вестници сутринта, когато отборът се събра.';
  }

  @override
  String scandalStoryCurfew(String player) {
    return '$player наруши вечерния час и беше хванат да се прибира в хотела призори.';
  }

  @override
  String scandalStoryNightclub(String player) {
    return '$player беше сниман в нощен клуб в навечерието на лагера, а снимките са навсякъде.';
  }

  @override
  String scandalStoryCasino(String player) {
    return '$player прекара нощта преди лагера на масата в казино, а един таблоид има снимките.';
  }

  @override
  String get scandalSendHome => 'Прати го вкъщи';

  @override
  String scandalSendHomeCover(String player) {
    return 'Вкъщи, повикай $player';
  }

  @override
  String scandalKeep(String player) {
    return 'Задръж $player';
  }

  @override
  String get scandalKeepNote =>
      'Ако остане: морал около -4 и съвет около -3 до края на цикъла.';

  @override
  String get scandalSendHomeNote =>
      'Ако го пратиш вкъщи: без цена за морала и съвета, и можеш да повикаш заместник.';

  @override
  String get scandalFinalsNote =>
      'Ако го пратиш вкъщи: без цена за морала и съвета, но на финален турнир никой не може да го замести.';

  @override
  String get scandalPickCover => 'Повикай заместник (по желание)';

  @override
  String newsScandalTitle(String player) {
    return 'Скандал на лагера: $player';
  }

  @override
  String yScandalParty0(String player, String tag) {
    return 'Млади момчета. $player на купон вечерта преди лагера, а аз пак искам да го видя на терена. #$tag';
  }

  @override
  String yScandalParty1(String player, String tag) {
    return '$player е сниман на купон до сутринта часове преди събирането на отбора. Федерацията е уведомена. #$tag';
  }

  @override
  String yScandalParty2(String player, String tag) {
    return 'Купон до сутринта преди лагера. $player, какво си мислеше? Невероятно. #$tag';
  }

  @override
  String yScandalCurfew0(String player, String tag) {
    return 'Прибрал се след вечерния час, е, случва се. $player просто трябва да го поправи на терена. #$tag';
  }

  @override
  String yScandalCurfew1(String player, String tag) {
    return '$player е хванат да се прибира в хотела на отбора след вечерния час, часове преди тренировката. #$tag';
  }

  @override
  String yScandalCurfew2(String player, String tag) {
    return 'Вечерният час не е сложна работа. $player не издържа и една нощ. #$tag';
  }

  @override
  String yScandalNightclub0(String player, String tag) {
    return 'Е, $player бил в клуб. И футболистите имат живот. Оставете го да играе. #$tag';
  }

  @override
  String yScandalNightclub1(String player, String tag) {
    return 'Снимки показват $player в нощен клуб в навечерието на лагера на националния отбор. #$tag';
  }

  @override
  String yScandalNightclub2(String player, String tag) {
    return 'Снимки от клуб в навечерието на лагера. $player посрами фланелката. #$tag';
  }

  @override
  String yScandalCasino0(String player, String tag) {
    return 'Една нощ в казиното не е престъпление. $player ще се оправи. #$tag';
  }

  @override
  String yScandalCasino1(String player, String tag) {
    return '$player е забелязан на масата в казино нощта преди събирането на отбора. #$tag';
  }

  @override
  String yScandalCasino2(String player, String tag) {
    return 'Цяла нощ в казиното преди лагера. $player заложи повече от пари. #$tag';
  }

  @override
  String yScandalSentHome0(String player) {
    return 'Правилно решение. Никой не е по-голям от отбора, и $player не е.';
  }

  @override
  String yScandalSentHome1(String player) {
    return 'Да пратиш $player вкъщи беше единственият отговор. Уважение към треньора.';
  }

  @override
  String yScandalSentHome2(String player) {
    return 'Дисциплината си е дисциплина. $player знаеше правилата.';
  }

  @override
  String yScandalSentHome3(String player) {
    return 'Ясен сигнал към съблекалнята: $player е в самолета за вкъщи.';
  }

  @override
  String yScandalSentHome4(String player) {
    return 'Сурово към $player. Една вечер навън и лагерът му свърши?';
  }

  @override
  String yScandalSentHome5(String player) {
    return 'Без $player сме по-слаби. Ще го платим на терена.';
  }

  @override
  String yScandalKept0(String player) {
    return 'Да задържиш $player е залог. Дано го върне на терена.';
  }

  @override
  String yScandalKept1(String player) {
    return 'Добре, $player остава. Значи дължи на всички голямо представяне.';
  }

  @override
  String yScandalKept2(String player) {
    return 'Значи правилата не важат за $player. Добре е да се знае.';
  }

  @override
  String yScandalKept3(String player) {
    return 'Вечерният час вече е по желание, явно. Питайте $player.';
  }

  @override
  String yScandalKept4(String player) {
    return 'Да задържиш $player след това? Този отбор е летен лагер.';
  }

  @override
  String yScandalKept5(String player) {
    return 'Купон цяла нощ, а после направо в титулярите. Страхотен сигнал, треньоре. $player сигурно е във възторг.';
  }

  @override
  String get yStreamerBreaks0 =>
      'БРАТ ГО ХВАНАХА 😭😭 НОЩТА ПРЕДИ ЛАГЕРА?? ПЛАЧА 💀💀💀';

  @override
  String get yStreamerBreaks1 =>
      'НЕЕЕ ЧАТ ВИЖТЕ ТОВА 🤯🤯 БРАТ НАИСТИНА ГО НАПРАВИ ПРЕДИ ЛАГЕРА 😭🔥';

  @override
  String get yStreamerBreaks2 =>
      'КОЙ ГО ПУСНА НАВЪН?? КОЙ ГО ПУСНА 😭😭💀 ТОВА Е КИНО 🔥🔥';

  @override
  String get yStreamerSentHome0 =>
      'ВКЪЩИ?? ВКЪЩИ!!! 😭😭😭 ТРЕНЬОРЪТ НЕ СЕ ШЕГУВА 💀🔥';

  @override
  String get yStreamerSentHome1 =>
      'БРАТ СИ СТЯГА КУФАРИТЕ НА ЖИВО 🤯🤯 ЧАО БРАТ 😭👋';

  @override
  String get yStreamerSentHome2 =>
      'НЕ МОЖЕ ДА БЪДЕЕЕ ПРАТИХА ГО ВКЪЩИ 💀💀 ЧАТ ТРЕПЕРЯ 🔥🔥🔥';

  @override
  String get yStreamerKept0 => 'ОСТАВА??? ОСТАВААА 🤯🤯 БРАТ Е НЕДОСЕГАЕМ 😭🔥';

  @override
  String get yStreamerKept1 =>
      'КУПОН ЦЯЛА НОЩ И ПАК В ОТБОРА 💀💀 ИСКАМ ТОЗИ ДОГОВОР 😭😭';

  @override
  String get yStreamerKept2 =>
      'ТРЕНЬОРЪТ КАЗА ЧЕ ВСИЧКО Е НАРЕД 😭😭 БРАТ КАКВО 🤯🤯🤯';

  @override
  String get yCameoUjfaloci => 'Нищо не съм плащал, а и тази сума не излиза';

  @override
  String get yCameoHavir0 => 'Рибките отплуваха.';

  @override
  String get yCameoHavir1 => 'Хвърлихме мрежите, рибите бяха другаде.';

  @override
  String get yCameoHavir2 => 'Казах го още през септември, на гулаш.';

  @override
  String get yCameoHavir3 => 'Който не е ловил навреме, да не плаче сега.';

  @override
  String get yCameoHavir4 => 'Играхме като сом на сухо.';

  @override
  String get yCameoHavir5 => 'Вятърът духа, езерото замръзва. Така е то.';

  @override
  String get yCameoHavir6 => 'Някои дни вадиш само стар ботуш.';

  @override
  String get yCameoHavir7 =>
      'По мое време поне отивахме на бира. Сега и това не.';

  @override
  String get yCameoLzimberskyHome0 =>
      'Да пратиш момче вкъщи заради една вечер? Това е скандалът, а не купонът!';

  @override
  String get yCameoLzimberskyHome1 =>
      'Момчетата имат право малко да се забавляват! Лицемерните медии пак спечелиха.';

  @override
  String get yCameoLzimberskyHome2 =>
      'Това е лов на вещици. Младеж излиза една вечер и вие го бесите.';

  @override
  String get yCameoLzimberskyHome3 =>
      'Журналистът, който никога не е бил на купон, да хвърли първия камък. Срамота!';

  @override
  String get yCameoLzimberskyHome4 =>
      'Треньорът се уплаши от таблоидите. Аз бих защитавал момчето до последен дъх!';

  @override
  String get yCameoLzimberskyKept0 =>
      'Най-накрая треньор с гръбнак! Задържа момчето, а медиите да плачат.';

  @override
  String get yCameoLzimberskyKept1 =>
      'Момчетата имат право малко да се забавляват, нали? Браво, треньоре!';

  @override
  String get yCameoLzimberskyKept2 =>
      'Лицемерните медии крещят, треньорът не отстъпва. Така се прави!';

  @override
  String get yCameoLzimberskyKept3 =>
      'Една вечер навън и пресата иска да го пребие с камъни. Треньорът е истински мъж!';

  @override
  String get yCameoLzimberskyKept4 =>
      'Казвам: оставете момчетата да живеят! Който работи здраво, има право и да купонясва. Палец нагоре.';

  @override
  String get yCameoMarena => 'Това и аз бих могла да го тренирам.';

  @override
  String get yCameoKralik => 'Какво очакваше хехехе, купувай нашето ZeroZero';

  @override
  String get yCameoPosuk0 => 'СЛАБОТИИ';

  @override
  String get yCameoPosuk1 => 'БРАТЛЕЕЕ';

  @override
  String get yCameoPosuk2 => 'Някой за кръчмата?';

  @override
  String get yTraitStreamer =>
      'Стриймва всичко, на пълна сила, с главни букви.';

  @override
  String hubEventAwardsCeremony(int year) {
    return 'Футболист на годината $year';
  }

  @override
  String get hubEventAwardsCeremonySub => 'Гласовете са преброени';

  @override
  String get potyCeremonyWatch => 'Гледай церемонията';

  @override
  String get potyCeremonySkipToList => 'Направо към първите петима';

  @override
  String get potyCeremonySkip => 'Пропусни';

  @override
  String get potyCeremonyIntro =>
      'Гласовете са преброени. Това са петимата най-добри футболисти в света тази година.';

  @override
  String potyCeremonyPlace(int place) {
    return 'Място $place';
  }

  @override
  String get potyCeremonyWinnerIs => 'А футболист на годината е...';

  @override
  String get potyTop5Heading => 'Първите петима в света';

  @override
  String get potyYoungTop3Heading =>
      'Млад футболист на годината: първите трима';

  @override
  String get potySeeTop5 => 'Виж първите петима';

  @override
  String get potyYourPlayer => 'Твоят играч';

  @override
  String potyTallyCleanSheets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count сухи мрежи',
      one: '1 суха мрежа',
    );
    return '$_temp0';
  }

  @override
  String get campaignFullBrief => 'Пълно описание';

  @override
  String campaignStarsSoFar(int earned, int total) {
    return 'Спечелени звезди досега: $earned от $total';
  }

  @override
  String get campaignStarEarned => 'Спечелена досега';

  @override
  String get campaignStarNotYet => 'Още не е спечелена';

  @override
  String get stadiumsEntrySubClosed =>
      'Разгледай стадионите си. Строителството се отваря отново в началото на следващия цикъл.';

  @override
  String get boardObjectiveNoBrief => 'Без поставена цел';

  @override
  String get boardObjectiveNoBriefBody =>
      'Съветът не очаква да стигнеш до тези финали. Ще те оценява по резултатите.';

  @override
  String get boardObjectiveAwaitingDraw => 'Цел след жребия';

  @override
  String get boardObjectiveAwaitingDrawBody =>
      'Съветът ще постави тази цел, щом групите бъдат изтеглени.';

  @override
  String tourThirdsNextAdvance(int count, String destination) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Следващите $count продължават към $destination',
      one: 'Следващият продължава към $destination',
    );
    return '$_temp0';
  }

  @override
  String yWinEuphoric0(String opponent, String score) {
    return 'Невероятна вечер. Дори в най-смелите си мечти не бихме го предвидили. $score срещу $opponent!';
  }

  @override
  String yWinEuphoric1(String opponent, String score) {
    return '$score срещу $opponent. Ощипете ме. Някой да ме ощипе, моля.';
  }

  @override
  String yWinEuphoric2(String opponent, String score) {
    return 'Плача на трибуната. $score срещу $opponent. Обичам този отбор.';
  }

  @override
  String yWinEuphoric3(String opponent, String score) {
    return '$score срещу $opponent. Най-хубавата вечер в живота ми като фен, без съмнение.';
  }

  @override
  String yWinEuphoric4(String opponent, String score) {
    return '$score срещу $opponent. Един от най-големите резултати в историята на тази страна.';
  }

  @override
  String yWinEuphoric5(String opponent, String score) {
    return '$score срещу $opponent. Никой на света не го очакваше. Историческо.';
  }

  @override
  String yWinEuphoric6(String opponent, String score) {
    return '$score срещу $opponent. За това ще се говори десетилетия.';
  }

  @override
  String yWinEuphoric7(String opponent, String score) {
    return 'Запомнете къде бяхте тази вечер: $score срещу $opponent.';
  }

  @override
  String yWinEuphoric8(String opponent, String score) {
    return 'Мрънках цяла година и утре пак ще мрънкам. Но тази вечер? $score срещу $opponent. Невероятно.';
  }

  @override
  String yWinEuphoric9(String opponent, String score) {
    return 'Дори аз не намирам за какво да се оплача. $score срещу $opponent. Нереално.';
  }

  @override
  String yWinEuphoric10(String opponent, String score) {
    return '$score срещу $opponent. Казвах, че този отбор е свършен. Никога не съм се радвал толкова, че греша.';
  }

  @override
  String yWinEuphoric11(String opponent, String score) {
    return 'Добре, признавам: $score срещу $opponent е като на сън. Следващата седмица вероятно пак постарому.';
  }

  @override
  String yDrewGiant0(String opponent, String score) {
    return '$score срещу $opponent. С една дума: невероятно!';
  }

  @override
  String yDrewGiant1(String opponent, String score) {
    return 'Точка срещу един от най-добрите отбори в света. Взимаме я винаги. $score срещу $opponent.';
  }

  @override
  String yDrewGiant2(String opponent, String score) {
    return '$score срещу $opponent! Нямам глас и не ми пука.';
  }

  @override
  String yDrewGiant3(String opponent, String score) {
    return '$score срещу $opponent. Равен? Чувството е като да сме спечелили всичко.';
  }

  @override
  String yDrewGiant4(String opponent, String score) {
    return 'Точка срещу отбор като $opponent не се очакваше, но определено я взимаме. $score, страхотен резултат.';
  }

  @override
  String yDrewGiant5(String opponent, String score) {
    return '$score срещу $opponent. Точка, която ще се помни с години.';
  }

  @override
  String yDrewGiant6(String opponent, String score) {
    return '$opponent дойде като голям фаворит и си тръгва с $score. Горда вечер.';
  }

  @override
  String yDrewGiant7(String opponent, String score) {
    return '$score срещу $opponent. Почти никой от нашето ниво не им взима точки.';
  }

  @override
  String yDrewGiant8(String opponent, String score) {
    return 'Очаквах разгром. $score срещу $opponent. С радост си взимам думите обратно.';
  }

  @override
  String yDrewGiant9(String opponent, String score) {
    return 'Не обичам равенствата, но $score срещу $opponent? Приемам с усмивка.';
  }

  @override
  String yDrewGiant10(String opponent, String score) {
    return '$score срещу $opponent. Тази вечер ликуват дори черногледите, включително аз.';
  }

  @override
  String yDrewGiant11(String opponent, String score) {
    return 'Бранихме се на живот и смърт и взехме $score срещу $opponent. Грозно? На кого му пука. Блестящо.';
  }

  @override
  String get potyHistorySubtitle => 'Всички носители и кой печели най-често';

  @override
  String get potyHistoryEmpty =>
      'Все още няма избран Футболист на годината. Първото гласуване е на 1 декември.';

  @override
  String get potyHistoryLatest => 'Последен носител';

  @override
  String get potyHistoryMostWins => 'Най-много отличия';

  @override
  String potyHistoryWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count отличия',
      one: '1 отличие',
    );
    return '$_temp0';
  }

  @override
  String get potyHistoryByYear => 'Носители по години';

  @override
  String get potyHistoryByNation => 'По държави';

  @override
  String potyHistoryYourNation(String winners, String finishes) {
    return 'Твоята държава: $winners, $finishes';
  }

  @override
  String potyHistoryWinners(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count носители',
      one: '1 носител',
    );
    return '$_temp0';
  }

  @override
  String potyHistoryTopFive(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count места в топ 5',
      one: '1 място в топ 5',
    );
    return '$_temp0';
  }

  @override
  String get potyHistoryYourPlayers => 'Твоите играчи';

  @override
  String get potyHistoryNoYourPlayers =>
      'Никой от твоите играчи още не е завършвал в първата петица.';

  @override
  String get potyHistoryYoung => 'Млад футболист';

  @override
  String get potyHistoryUnknownPlayer => 'Неизвестен играч';

  @override
  String get hostingTitle => 'Домакинство';

  @override
  String get hostingThisCycle => 'Този цикъл';

  @override
  String get hostingNextCycle => 'Вашата кандидатура за следващия цикъл';

  @override
  String get hostingTba => 'Предстои да бъде обявено';

  @override
  String get hostingTbaWc =>
      'Ще бъде обявено след края на континенталното първенство';

  @override
  String hostingBidPledged(String amount, String percent) {
    return 'Кандидатурата е подадена: $amount, с $percent шанс за домакинство.';
  }

  @override
  String get hostingWindowLine =>
      'Кандидатурите се подават в края на цикъла, след финала на Световното първенство.';

  @override
  String hubEventWarmUpOffer(String nation) {
    return 'Покана за контрола: $nation';
  }

  @override
  String get hubEventWarmUpOfferSub => 'Прощална контрола преди техния турнир';

  @override
  String get warmUpOfferTitle => 'ПОКАНА ЗА КОНТРОЛА';

  @override
  String warmUpOfferBody(String nation, String competition, String date) {
    return '$nation се готви за турнира $competition и иска прощална контрола срещу теб на $date.';
  }

  @override
  String warmUpOfferAway(String nation) {
    return 'Като гост, при съперника ($nation).';
  }

  @override
  String get warmUpOfferHome => 'У дома: съперникът идва при теб.';

  @override
  String get warmUpOfferNote =>
      'Можеш да приемеш най-много две покани. Приетият мач има собствена повиквателна.';

  @override
  String get warmUpOfferAccept => 'Приеми';

  @override
  String get warmUpOfferDecline => 'Откажи';

  @override
  String warmUpOfferMsgTitle(String nation) {
    return 'Покана за контрола: $nation';
  }

  @override
  String warmUpOfferMsgBody(String nation, String competition) {
    return '$nation иска прощална контрола срещу теб преди турнира $competition.';
  }

  @override
  String get hubSimToFinal => 'Симулирай до финала';

  @override
  String get jobDossierOpen => 'Проучи поста';

  @override
  String get jobDossierRating => 'Сила на отбора';

  @override
  String get jobDossierMood => 'Настроение';

  @override
  String get jobDossierTopPlayers => 'Най-добри играчи';

  @override
  String jobDossierPlayerAge(int age) {
    return '$age г.';
  }

  @override
  String get jobDossierReport => 'Мнение на скаута';

  @override
  String get jobDossierNextTargetLabel => 'Следваща цел';

  @override
  String jobDossierNextTarget(String cup) {
    return 'Класиране: $cup и Световно първенство.';
  }

  @override
  String get jobDossierStrongAttack => 'Истинска острота в атака.';

  @override
  String get jobDossierBluntAttack => 'Головете идват трудно.';

  @override
  String get jobDossierStrongMidfield => 'Халфовата линия диктува играта.';

  @override
  String get jobDossierWeakMidfield =>
      'В средата на терена често са надиграни.';

  @override
  String get jobDossierStrongDefence => 'Трудно се пробиват отзад.';

  @override
  String get jobDossierThinDefence => 'Защитата изглежда крехка.';

  @override
  String get jobDossierSafeKeeper => 'Вратар, на когото можеш да разчиташ.';

  @override
  String get jobDossierShakyKeeper => 'Вратарският пост тревожи.';

  @override
  String get jobDossierOldSquad => 'Застаряващ състав, промяната наближава.';

  @override
  String get jobDossierYoungCore => 'Младо ядро в подем.';

  @override
  String jobDossierOneStar(String name) {
    return '$name носи този отбор.';
  }

  @override
  String get jobDossierDeepSquad => 'Истинска дълбочина зад титулярите.';

  @override
  String get jobDossierThinSquad => 'Малко качество зад титулярите.';

  @override
  String get jobDossierBalanced => 'Балансиран отбор без явна слабост.';

  @override
  String yQualifiedEuphoric0(String competition) {
    return 'Не мога да повярвам, че успяхме! Почти никой не го очакваше. $competition, идваме 💪';
  }

  @override
  String yQualifiedEuphoric1(String competition) {
    return 'Каква магична вечер, в страната на мечтите сме! $competition, идваме!';
  }

  @override
  String yQualifiedEuphoric2(String competition) {
    return 'Винаги съм вярвал в този отбор. Винаги. А сега отиваме на турнира $competition!';
  }

  @override
  String yQualifiedEuphoric3(String competition) {
    return 'Никой не ни даваше шанс в тази група. Никой. Ще се видим на турнира $competition!';
  }

  @override
  String yQualifiedEuphoric4(String competition) {
    return 'Сълзи в очите. Ние, на турнира $competition. Наистина ние.';
  }

  @override
  String yQualifiedEuphoric5(String competition) {
    return 'В момента танцувам на улицата. Класирахме се: $competition! Нереално 🎉';
  }

  @override
  String yQualifiedEuphoric6(String competition) {
    return 'Казвах, че нямаме шанс. Никога не съм се радвал толкова, че греша. $competition!';
  }

  @override
  String yQualifiedEuphoric7(String competition) {
    return 'От години мрънкам за този отбор и утре пак ще започна. Тази вечер? $competition, идваме!';
  }

  @override
  String yQualifiedEuphoric8(String competition) {
    return 'Добре. ДОБРЕ. Вземам всичко назад. Отиваме на турнира $competition!';
  }

  @override
  String yKnockoutEuphoric0(String opponent) {
    return 'Продължаваме! $opponent е победен. Каква магична вечер, в страната на мечтите сме!';
  }

  @override
  String yKnockoutEuphoric1(String opponent) {
    return 'Елиминирахме: $opponent! Продължавайте да мечтаете, всички 💪';
  }

  @override
  String yKnockoutEuphoric2(String opponent) {
    return 'Знаех, че този отбор го може. Сбогом, $opponent, здравей, следващ кръг!';
  }

  @override
  String yKnockoutEuphoric3(String opponent) {
    return 'Нямам глас. $opponent отпада, а ние продължаваме напред!';
  }

  @override
  String yKnockoutEuphoric4(String opponent) {
    return 'Елиминации, а ние още сме на крака. $opponent го научиха по трудния начин.';
  }

  @override
  String yKnockoutEuphoric5(String opponent) {
    return '$opponent се прибира у дома. Този отбор пише история 🔥';
  }

  @override
  String yKnockoutEuphoric6(String opponent) {
    return 'Мислех, че вече ще сме си у дома. Вместо това се прибира $opponent. Невероятно.';
  }

  @override
  String yKnockoutEuphoric7(String opponent) {
    return 'Дори аз вече мечтая. $opponent е победен. Кои сме ние?';
  }

  @override
  String yKnockoutEuphoric8(String opponent) {
    return 'Песимист цял живот. $opponent отпада, ние продължаваме. Не знам какво да правя със себе си.';
  }

  @override
  String yTrophyEuphoric0(String competition) {
    return 'ШАМПИОНИ!!! Спечелихме турнира $competition! Никога няма да забравя тази вечер 🏆';
  }

  @override
  String yTrophyEuphoric1(String competition) {
    return 'Каква магична вечер. Шампиони, $competition, а аз не мога да спра да плача.';
  }

  @override
  String yTrophyEuphoric2(String competition) {
    return 'Винаги съм казвал, че този отбор може. $competition: победители. ПОБЕДИТЕЛИ!';
  }

  @override
  String yTrophyEuphoric3(String competition) {
    return 'Някой да ми каже, че е истина. Спечелихме турнира $competition!';
  }

  @override
  String yTrophyEuphoric4(String competition) {
    return 'Тази нощ се празнува на всяка улица в страната. $competition е наш 🏆';
  }

  @override
  String yTrophyEuphoric5(String competition) {
    return 'Запомнете къде бяхте тази вечер. Шампиони, $competition.';
  }

  @override
  String yTrophyEuphoric6(String competition) {
    return 'Всяка лоша вечер, всяко разочарование си заслужаваше. $competition: шампиони.';
  }

  @override
  String yTrophyEuphoric7(String competition) {
    return 'Мрънках с години, а сега нямам за какво. Спечелихме турнира $competition!';
  }

  @override
  String yTrophyEuphoric8(String competition) {
    return 'Добре, признавам: шампиони, $competition. Най-хубавата вечер в живота ми.';
  }

  @override
  String yExitHeartbreak0(String competition) {
    return 'Разбито сърце. Отидохме на турнира $competition за титлата. Пак съм горд с този отбор.';
  }

  @override
  String yExitHeartbreak1(String competition) {
    return 'Толкова боли. На турнира $competition трябваше да стигнем далеч. Ще опитаме пак.';
  }

  @override
  String yExitHeartbreak2(String competition) {
    return 'Съсипан. Турнирът $competition вече свърши за нас, а имахме отбор за титлата.';
  }

  @override
  String yExitHeartbreak3(String competition) {
    return 'Полетът към дома от турнира $competition ще е най-дългият в живота ни.';
  }

  @override
  String yExitHeartbreak4(String competition) {
    return 'На турнира $competition трябваше да стигнем далеч. Вместо това се прибираме. Нямам думи.';
  }

  @override
  String yExitHeartbreak5(String competition) {
    return 'Години чакане, а турнирът $competition свърши за нас, преди да започне. Празнота.';
  }

  @override
  String punditsMsgTitle(String competition) {
    return 'Експертите за турнира $competition';
  }

  @override
  String punditsSays(String pundit, String words) {
    return '$pundit: $words';
  }

  @override
  String punditsFavourite0(String nation) {
    return 'Моят фаворит: $nation. Твърде силни и с твърде широк състав за останалите.';
  }

  @override
  String punditsFavourite1(String nation) {
    return 'Трудно е да гледаш отвъд отбора на $nation. Имат всичко нужно за титлата.';
  }

  @override
  String punditsDarkHorse0(String nation) {
    return 'Истинският тъмен кон тук: $nation. Един полуфинал не би ме шокирал.';
  }

  @override
  String punditsDarkHorse1(String nation) {
    return 'Следете отбора на $nation. Никой няма да иска да ги срещне.';
  }

  @override
  String punditsMineBottom0(String nation) {
    return '$nation: последни в групата. Добре е, че са тук, но нямат качеството да продължат.';
  }

  @override
  String punditsMineBottom1(String nation) {
    return '$nation: ще им хареса пътуването, но ги виждам последни в групата.';
  }

  @override
  String punditsMineGroupOut0(String nation) {
    return '$nation: отпадане в групата. Неудобни, но едно стъпало по-ниско.';
  }

  @override
  String punditsMineGroupOut1(String nation) {
    return 'Според мен отборът на $nation си тръгва след групата. Но ще затрудни някого.';
  }

  @override
  String punditsMineFirstKnockout0(String nation) {
    return '$nation: продължават от групата, после отпадат в първия кръг на елиминациите. Приличен турнир.';
  }

  @override
  String punditsMineFirstKnockout1(String nation) {
    return '$nation: би трябвало да излязат от групата. Повече би било изненада.';
  }

  @override
  String punditsMineQuarters0(String nation) {
    return '$nation: солиден отбор. Четвъртфиналът им приляга.';
  }

  @override
  String punditsMineQuarters1(String nation) {
    return '$nation: четвъртфиналът е по силите им. Това би бил добър турнир.';
  }

  @override
  String punditsMineSemis0(String nation) {
    return '$nation: класа, очаква се дълъг път. Поне полуфинал.';
  }

  @override
  String punditsMineSemis1(String nation) {
    return '$nation: имат качеството за последните четирима. По-малко би било разочарование.';
  }

  @override
  String punditsMineFinal0(String nation) {
    return '$nation: класа, очаква се дълъг път. Виждам ги на финала.';
  }

  @override
  String punditsMineFinal1(String nation) {
    return '$nation: чак до финала. Толкова са добри.';
  }

  @override
  String punditsMineWinner0(String nation) {
    return '$nation: отборът, който трябва да бъде победен. Всичко освен титлата е провал.';
  }

  @override
  String punditsMineWinner1(String nation) {
    return 'Моята прогноза за шампион: $nation. Сега цялото напрежение е върху тях.';
  }

  @override
  String punditsMineDarkHorseQuarters(String nation) {
    return 'Истинският тъмен кон тук: $nation. Един четвъртфинал не би ме шокирал.';
  }

  @override
  String punditsMineDarkHorseSemis(String nation) {
    return 'Истинският тъмен кон тук: $nation. Един полуфинал не би ме шокирал.';
  }

  @override
  String yPunditPick0(String competition, String favourite, String darkHorse) {
    return 'Моята прогноза за турнира $competition: печели $favourite. Тъмен кон? $darkHorse. Какъв турнир ще бъде.';
  }

  @override
  String yPunditPick1(String competition, String favourite, String darkHorse) {
    return 'Турнирът $competition: казвам $favourite, и внимавайте с отбора на $darkHorse. Може да е нещо специално.';
  }

  @override
  String yPunditPick2(String competition, String favourite, String darkHorse) {
    return 'Прогнози, $competition. Победител: $favourite. Тъмен кон: $darkHorse.';
  }

  @override
  String yPunditPick3(String competition, String favourite, String darkHorse) {
    return 'Трудно е да гледаш отвъд $favourite на турнира $competition. $darkHorse: могат да изненадат мнозина.';
  }

  @override
  String yPunditPick4(String competition, String favourite, String darkHorse) {
    return 'Всички ще ви кажат $favourite за турнира $competition. За съжаление са прави. Единственият отбор, който си струва: $darkHorse.';
  }

  @override
  String yPunditPick5(String competition, String favourite, String darkHorse) {
    return 'Турнирът $competition ще го спечели $favourite и ще е скучно. Ако искате история, гледайте $darkHorse.';
  }

  @override
  String tacticsSlotSwitchHeading(String formation) {
    return 'Позиция в схемата $formation';
  }

  @override
  String get tacticsSlotSwitchReset => 'Нулирай';

  @override
  String get tacticsSlotSwitchLimit =>
      'В тази схема вече са сменени две позиции. Върни една, за да смениш тази.';

  @override
  String get assistantAsk => 'Попитай помощника';

  @override
  String get assistantNoneNote =>
      'Нямаш помощник. Назначи такъв в щаба, за да получаваш съвети.';

  @override
  String get assistantSheetTitle => 'Съветът на помощника';

  @override
  String get assistantReadBasic =>
      'Груба преценка. Провери я, преди да ѝ се довериш.';

  @override
  String get assistantReadGood =>
      'Солидна преценка на рейтинги, позиции и умора.';

  @override
  String get assistantReadElite =>
      'Чете физиката, формата, морала и съперниците.';

  @override
  String get assistantVariantMain => 'Неговият избор';

  @override
  String get assistantVariantFresh => 'По-свежи крака';

  @override
  String get assistantVariantForm => 'Играчи във форма';

  @override
  String get assistantVsStronger => 'Съперниците са по-силни';

  @override
  String get assistantVsWeaker => 'Ти си по-силният';

  @override
  String get assistantReasonInForm => 'Във форма';

  @override
  String get assistantReasonFresh => 'Свеж';

  @override
  String get assistantReasonTired => 'Уморен';

  @override
  String get assistantReasonInjured => 'Контузен';

  @override
  String get assistantApply => 'Приложи';

  @override
  String get assistantClose => 'Затвори';

  @override
  String get assistantReasonTopPick => 'Първи избор';

  @override
  String get assistantReasonLineCover => 'Резерва за линията';

  @override
  String get assistantReasonYoung => 'Млад талант';

  @override
  String get assistantReasonExperienced => 'Опитен';

  @override
  String get assistantReasonBanned => 'Наказан';

  @override
  String get assistantReasonOutOfForm => 'Без форма';

  @override
  String get assistantReasonOthersAhead => 'Други са пред него';

  @override
  String get assistantVariantYouth => 'Шанс за младите';

  @override
  String get assistantVariantExperience => 'Опит';

  @override
  String get assistantVsSelection => 'Спрямо текущия ти избор';

  @override
  String get assistantVsLastSquad => 'Спрямо предишния състав';

  @override
  String get assistantSameSquad => 'Без промени спрямо избора ти';

  @override
  String assistantNamesIn(int count) {
    return 'Влизат: $count';
  }

  @override
  String assistantNamesOut(int count) {
    return 'Излизат: $count';
  }

  @override
  String assistantVariantTacticsChange(String formation) {
    return 'При смяна на $formation';
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
  String get staffEffectAdviceBasic =>
      'Съветва за повикванията, понякога грешно';

  @override
  String get staffEffectAdviceGood => 'Съветва за повикванията, следи физиката';

  @override
  String get staffEffectAdviceElite =>
      'Съветва за повикванията според физиката, формата и съперниците';

  @override
  String get staffHiringAdvice => 'и съвети за повикванията';

  @override
  String get hubEventSponsor => 'Избери спонсор за цикъла';

  @override
  String get hubEventSponsorSub =>
      'Три марки искат името си на фланелката. Всяка сделка си има цена.';

  @override
  String get sponsorTitle => 'Генерален спонсор';

  @override
  String get sponsorIntroCycle =>
      'Веднъж на цикъл марките се редят на опашка, за да станат генерален спонсор на федерацията. Всяка сделка носи нещо и струва нещо: съвета, съблекалнята или и двете. Подпиши с една или с никоя. Сделката и ефектите ѝ върху съвета и морала траят до края на цикъла.';

  @override
  String get sponsorEffectBoard => 'Съвет';

  @override
  String get sponsorEffectMorale => 'Морал';

  @override
  String get sponsorEffectPress => 'Подигравки';

  @override
  String sponsorPerkMarketing(String amount, String department) {
    return 'Финансира $amount за отдел $department този цикъл';
  }

  @override
  String sponsorPerkMarketingNote(String amount) {
    return 'Още $amount в края на цикъла, над собствената ти инвестиция';
  }

  @override
  String get sponsorRiskyLabel => 'Рисково';

  @override
  String get sponsorRiskyWarning => 'Пресата ще си направи купон с това.';

  @override
  String get sponsorSign => 'Подпиши';

  @override
  String get sponsorDeclineCycle => 'Без спонсор за този цикъл';

  @override
  String get sponsorNoneCycle => 'Без генерален спонсор този цикъл';

  @override
  String get sponsorUntilCycleEnd => 'До края на цикъла';

  @override
  String sponsorRolloverLine(String brand) {
    return 'Генерален спонсор: $brand';
  }

  @override
  String get sponsorBrandAgrofart => 'Агропръдня';

  @override
  String get sponsorIndustryAgrofart => 'Земеделие и химия';

  @override
  String get sponsorFlavourAgrofart =>
      'Храни нацията. Притежава и чипса ѝ, вестниците ѝ и повечето ѝ прасета.';

  @override
  String get sponsorBrandBetBadger => 'BetBadger';

  @override
  String get sponsorIndustryBetBadger => 'Букмейкър';

  @override
  String get sponsorFlavourBetBadger =>
      'Коефициенти за всичко, включително за уволнението ти.';

  @override
  String get sponsorBrandCoinGoblin => 'CoinGoblin';

  @override
  String get sponsorIndustryCoinGoblin => 'Крипто борса';

  @override
  String get sponsorFlavourCoinGoblin =>
      'Плюс четири хиляди процента тази седмица. Моля, не питайте за тегления.';

  @override
  String get sponsorBrandEasyPeasy => 'Кредит Веднага';

  @override
  String get sponsorIndustryEasyPeasy => 'Бързи кредити';

  @override
  String get sponsorFlavourEasyPeasy =>
      'Пари за десет минути. Лихва за десет години.';

  @override
  String get sponsorBrandVaporia => 'Vaporia';

  @override
  String get sponsorIndustryVaporia => 'Вейп магазини';

  @override
  String get sponsorFlavourVaporia =>
      'Четирийсет вкуса облак, нито един полезен за нападател.';

  @override
  String get sponsorBrandGoldenFleece => 'Холдинг Златното руно';

  @override
  String get sponsorIndustryGoldenFleece => 'Офшорен холдинг';

  @override
  String get sponsorFlavourGoldenFleece =>
      'Никой не знае с какво се занимават. Адвокатите им предпочитат така.';

  @override
  String get sponsorBrandMiners => 'Миньорите';

  @override
  String get sponsorIndustryMiners => 'Минно дело';

  @override
  String get sponsorFlavourMiners =>
      'Въглища, мед и един много прашен борд на директорите.';

  @override
  String get sponsorBrandDragonfly => 'Водно конче';

  @override
  String get sponsorIndustryDragonfly => 'Бензиностанции';

  @override
  String get sponsorFlavourDragonfly =>
      'Бензин, хотдог и автомивка, която не е работила нито веднъж.';

  @override
  String get sponsorBrandSludgeco => 'Калнефт';

  @override
  String get sponsorIndustrySludgeco => 'Петрол';

  @override
  String get sponsorFlavourSludgeco =>
      'Пробива дупки там, където никой не ги е искал.';

  @override
  String get sponsorBrandSkyloom => 'Skyloom';

  @override
  String get sponsorIndustrySkyloom => 'Нискотарифна авиолиния';

  @override
  String get sponsorFlavourSkyloom =>
      'Лети навсякъде за девет евро. Седалка, багаж и кислород се плащат отделно.';

  @override
  String get sponsorBrandArvella => 'Arvella Motors';

  @override
  String get sponsorIndustryArvella => 'Автомобили';

  @override
  String get sponsorFlavourArvella =>
      'Луксозни джипове с размерите на гарсониера.';

  @override
  String get sponsorBrandCheapoMax => 'ЕвтиноМакс';

  @override
  String get sponsorIndustryCheapoMax => 'Дискаунтър';

  @override
  String get sponsorFlavourCheapoMax =>
      'Всичко на половин цена, включително персоналът.';

  @override
  String get sponsorBrandBrickhaven => 'Brickhaven';

  @override
  String get sponsorIndustryBrickhaven => 'Строителство';

  @override
  String get sponsorFlavourBrickhaven =>
      'Строи стадиони навреме. От време на време.';

  @override
  String get sponsorBrandHappyBurgers => 'Весели Бургери';

  @override
  String get sponsorIndustryHappyBurgers => 'Бързо хранене';

  @override
  String get sponsorFlavourHappyBurgers =>
      'Тройно сирене, двоен бекон, безплатно за целия отбор.';

  @override
  String get sponsorBrandOldSwamp => 'Старокал';

  @override
  String get sponsorIndustryOldSwamp => 'Пивоварна';

  @override
  String get sponsorFlavourOldSwamp =>
      'Варена в изба, която никой никога не е чистил.';

  @override
  String get sponsorBrandBuzzhorn => 'Buzzhorn';

  @override
  String get sponsorIndustryBuzzhorn => 'Енергийни напитки';

  @override
  String get sponsorFlavourBuzzhorn => 'Толкова кофеин, че да събуди и вратар.';

  @override
  String get sponsorBrandSteamy => 'Сауна При Парата';

  @override
  String get sponsorIndustrySteamy => 'Верига сауни';

  @override
  String get sponsorFlavourSteamy =>
      'Потете се заедно. Кърпата е по желание, отборният дух не е.';

  @override
  String get sponsorBrandPixelRage => 'PixelRage Games';

  @override
  String get sponsorIndustryPixelRage => 'Видеоигри';

  @override
  String get sponsorFlavourPixelRage =>
      'Любимият шутър на отбора, вече с техните лица.';

  @override
  String get sponsorBrandGlitterbox => 'Glitterbox Records';

  @override
  String get sponsorIndustryGlitterbox => 'Музикален лейбъл';

  @override
  String get sponsorFlavourGlitterbox =>
      'Всяко празнуване на гол вече идва с хореография.';

  @override
  String get sponsorBrandMilkwell => 'Мандра Milkwell';

  @override
  String get sponsorIndustryMilkwell => 'Млечни продукти';

  @override
  String get sponsorFlavourMilkwell =>
      'Ледено мляко и училищни екскурзии при кравите.';

  @override
  String get sponsorBrandHerringKing => 'Царят на херингата';

  @override
  String get sponsorIndustryHerringKing => 'Маринована херинга';

  @override
  String get sponsorFlavourHerringKing =>
      'Маринована, пушена или в буркан, още от времето на дядо.';

  @override
  String get sponsorBrandUmbrello => 'Umbrello Застраховане';

  @override
  String get sponsorIndustryUmbrello => 'Застраховане';

  @override
  String get sponsorFlavourUmbrello =>
      'Застрахова всичко, дори чадъра на чадъра ти.';

  @override
  String get sponsorBrandTidyTeeth => 'Чисти Зъбки';

  @override
  String get sponsorIndustryTidyTeeth => 'Паста за зъби';

  @override
  String get sponsorFlavourTidyTeeth =>
      'Девет от десет зъболекари. Десетият е в отпуск.';

  @override
  String get sponsorBrandWoollySocks => 'Вълнени Чорапи';

  @override
  String get sponsorIndustryWoollySocks => 'Плетива';

  @override
  String get sponsorFlavourWoollySocks =>
      'Ръчно плетени чорапи за всеки играч, във всеки цвят освен този на отбора.';

  @override
  String get sponsorBrandStackabloc => 'Stackabloc';

  @override
  String get sponsorIndustryStackabloc => 'Играчки';

  @override
  String get sponsorFlavourStackabloc =>
      'Построй си националния стадион. Четири хиляди части, една липсва.';

  @override
  String get sponsorBrandPolarPenguin => 'Полярен Пингвин';

  @override
  String get sponsorIndustryPolarPenguin => 'Сладолед';

  @override
  String get sponsorFlavourPolarPenguin => 'Трийсет вкуса и всички се топят.';

  @override
  String get sponsorBrandBoltworth => 'Boltworth';

  @override
  String get sponsorIndustryBoltworth => 'Инженеринг';

  @override
  String get sponsorFlavourBoltworth =>
      'За всеки проблем по един болт. Инженерите им още търсят гайката.';

  @override
  String get sponsorBrandVelocell => 'Velocell';

  @override
  String get sponsorIndustryVelocell => 'Телеком';

  @override
  String get sponsorFlavourVelocell =>
      'Пълен сигнал навсякъде освен на стадиона.';

  @override
  String get sponsorBrandParcelion => 'Parcelion';

  @override
  String get sponsorIndustryParcelion => 'Куриерски услуги';

  @override
  String get sponsorFlavourParcelion =>
      'Доставка утре. Или вдругиден. Или при съседа.';

  @override
  String get sponsorBrandGridwell => 'Gridwell Energy';

  @override
  String get sponsorIndustryGridwell => 'Енергетика';

  @override
  String get sponsorFlavourGridwell =>
      'Прожекторите светят. През повечето време.';

  @override
  String get sponsorBrandCrownstone => 'Crownstone Банк';

  @override
  String get sponsorIndustryCrownstone => 'Банка';

  @override
  String get sponsorFlavourCrownstone =>
      'Парите ви са на сигурно при нас. Вероятно.';

  @override
  String get sponsorBrandClickbait => 'Кликбейт Медия';

  @override
  String get sponsorIndustryClickbait => 'Медийна група';

  @override
  String get sponsorFlavourClickbait =>
      'Няма да повярваш какво пише в четвъртото ни заглавие.';

  @override
  String get sponsorDealLineRisky =>
      'Много пари и никакви въпроси. Ръководството ще има доста.';

  @override
  String get sponsorDealLineBigPayer =>
      'Щедър чек от име, което ръководството не би искало да вижда отпечатано.';

  @override
  String get sponsorDealLineCrowdPleaser =>
      'Забавна марка, която играчите обожават, а ръководството намира за малко прекалена.';

  @override
  String get sponsorDealLineFamilyFriendly =>
      'Благопристойно име, което ръководството обожава, а играчите се прозяват.';

  @override
  String get sponsorDealLineMarketing =>
      'Без пари, само кампании: плакати, фотосесии и много усмивки.';

  @override
  String ySponsorDubious0(String brand) {
    return 'Нов генерален спонсор на федерацията: $brand. Смейте се колкото искате, академията пак има нужда от парите.';
  }

  @override
  String ySponsorDubious1(String brand) {
    return 'Федерацията подписа с марката $brand като нов генерален спонсор. Говори се, че това е била най-голямата оферта на масата.';
  }

  @override
  String ySponsorDubious2(String brand) {
    return '$brand. Новият ни генерален спонсор е $brand. Трябва да полегна.';
  }

  @override
  String ySponsorMocked0(String brand) {
    return 'Парите са си пари. Ако $brand плати за нови терени, ще нося фланелката с гордост.';
  }

  @override
  String ySponsorMocked1(String brand) {
    return 'Казвайте каквото искате за $brand, чекът им мина.';
  }

  @override
  String ySponsorMocked2(String brand) {
    return 'Някъде един маркетингов екип много се гордее с онова лого на $brand на гърдите ни.';
  }

  @override
  String ySponsorMocked3(String brand) {
    return 'Значи вече сме националният отбор на $brand. Ясно.';
  }

  @override
  String ySponsorMocked4(String brand) {
    return 'Представи си да продадеш фланелката на $brand. Само си представи.';
  }

  @override
  String ySponsorMocked5(String brand) {
    return 'От всички спонсори на света избрахме $brand. Всички съперници ни се смеят.';
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
  String get matchTinySouthAmerica => 'КЮА';

  @override
  String get matchTinyNorthAmerica => 'КСА';

  @override
  String get matchTinyAfrica => 'АфП';

  @override
  String get matchTinyAsia => 'АзП';

  @override
  String get matchTinyOceania => 'КО';

  @override
  String get matchTinyNationsCup => 'NC';

  @override
  String get matchTinyFriendly => 'контр.';

  @override
  String get matchTinyClash => 'Clash';

  @override
  String get matchTinyPlayoff => 'плейоф';

  @override
  String matchTinyMatchday(int matchday) {
    return '$matchday кр.';
  }

  @override
  String get matchTinyRoundOf32 => '1/16';

  @override
  String get matchTinyRoundOf16 => '1/8';

  @override
  String get matchTinyQuarterFinal => '1/4';

  @override
  String get matchTinySemiFinal => '1/2';

  @override
  String get matchTinyFinal => 'финал';

  @override
  String get matchTinyThirdPlace => 'за 3-то';

  @override
  String get callUpHomeShort => 'Д';

  @override
  String get callUpAwayShort => 'Г';

  @override
  String get homeEditor => 'Редактор';

  @override
  String get homeNewGameBlurb => 'Избери отбор и започни кариера';

  @override
  String homeCampaignCycleOnly(int cycle, int total) {
    return 'Цикъл $cycle от $total';
  }

  @override
  String get editorTitle => 'Редактор';

  @override
  String get editorIntro =>
      'Създай свой начален свят: твоите играчи, техните рейтинги, твоите имена. Сподели го като файл, а приятелите ти могат да го импортират и да започнат кариера в него.';

  @override
  String get editorEmptyTitle => 'Още няма бази данни';

  @override
  String get editorEmptyBody =>
      'Новата база данни започва като копие на стандартния свят. Промени каквото искаш. Запазва се автоматично.';

  @override
  String get editorNew => 'Нова база данни';

  @override
  String get editorImport => 'Импортирай';

  @override
  String get editorEdit => 'Редактирай';

  @override
  String get editorRename => 'Преименувай';

  @override
  String get editorDuplicate => 'Дублирай';

  @override
  String get editorExport => 'Експортирай';

  @override
  String get editorDelete => 'Изтрий';

  @override
  String get editorCancel => 'Отказ';

  @override
  String get editorCreate => 'Създай';

  @override
  String get editorMore => 'Още действия';

  @override
  String get editorNameLabel => 'Име';

  @override
  String get editorNameHint => 'Моят свят';

  @override
  String get editorRenameTitle => 'Преименувай базата данни';

  @override
  String get editorDuplicateTitle => 'Дублирай базата данни';

  @override
  String editorCopyName(String name) {
    return '$name (копие)';
  }

  @override
  String get editorNameEmpty => 'Дай ѝ име';

  @override
  String editorNameTooLong(int max) {
    return 'До $max знака';
  }

  @override
  String get editorNameBadCharacters =>
      'Името съдържа знаци, които не могат да се използват';

  @override
  String get editorDeleteTitle => 'Изтриване на базата данни?';

  @override
  String editorDeleteBody(String name) {
    return '„$name“ ще бъде премахната от това устройство. Вече започнатите в нея кариери продължават да работят.';
  }

  @override
  String get editorStatusReady => 'Готова';

  @override
  String editorStatusMissing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Липсват $count неща',
      one: 'Липсва 1 нещо',
    );
    return '$_temp0';
  }

  @override
  String get editorStatusAttention => 'Иска внимание';

  @override
  String get editorStatusUnreadable => 'Не може да се отвори';

  @override
  String editorEdited(String date) {
    return 'Променена $date';
  }

  @override
  String get editorCreating => 'Копиране на стандартния свят…';

  @override
  String get editorImported => 'Базата данни е импортирана';

  @override
  String get editorImportOpen => 'Отвори';

  @override
  String get editorImportTooBig => 'Файлът е твърде голям, за да е база данни.';

  @override
  String get editorImportNotAPack => 'Този файл не е база данни на FNM.';

  @override
  String get editorImportNewer =>
      'Тази база данни е създадена с по-нова версия на играта. Обнови играта, за да я импортираш.';

  @override
  String get editorImportBadData =>
      'Базата данни съдържа данни, които играта не може да използва, затова нищо не е импортирано.';

  @override
  String get editorImportBadTrophy =>
      'Картинка на трофей във файла не можа да се прочете, затова нищо не е импортирано.';

  @override
  String get editorExportFailed => 'Базата данни не можа да се експортира.';

  @override
  String editorExportTooBig(String size, String limit) {
    return 'Базата данни е твърде голяма за споделяне: файлът би бил $size MB, а ограничението е $limit MB. Оставете по-малко фиксирани резерви или премахнете някои изображения на трофеи и опитайте отново.';
  }

  @override
  String editorRemoveAllLike(int count) {
    return 'Премахни всички подобни ($count)';
  }

  @override
  String get editorNotesTitle => 'Други езици';

  @override
  String editorUnknownLanguageNote(String language, int count) {
    return 'Имена на „$language“, език, който тази версия не показва: $count. Запазват се за версиите, които го поддържат.';
  }

  @override
  String get editorShareSubject => 'База данни FNM';

  @override
  String get editorPackMissing =>
      'Тази база данни вече не е на това устройство.';

  @override
  String get editorReadyTitle => 'Готова за игра';

  @override
  String get editorReadyBody =>
      'Всяка страна има пълен състав и всяко име е наред. Можеш да започнеш кариера в нея.';

  @override
  String editorNotReadyTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count неща за оправяне, преди да се играе',
      one: '1 нещо за оправяне, преди да се играе',
    );
    return '$_temp0';
  }

  @override
  String get editorNotReadyBody =>
      'Запазва се автоматично, така че можеш да я споделиш сега и да я довършиш по-късно.';

  @override
  String editorSectionsReady(int ready, int total) {
    return '$ready от $total раздела са готови';
  }

  @override
  String get editorMissingTitle => 'Какво липсва';

  @override
  String editorShowAll(int count) {
    return 'Покажи всички ($count)';
  }

  @override
  String get editorShowLess => 'Покажи по-малко';

  @override
  String get editorUndo => 'Върни';

  @override
  String get editorSectionsTitle => 'Раздели';

  @override
  String get editorSectionPlayers => 'Играчи';

  @override
  String get editorSectionNations => 'Страни';

  @override
  String get editorSectionClubs => 'Клубове';

  @override
  String get editorSectionStadiums => 'Стадиони';

  @override
  String get editorSectionCompetitions => 'Състезания';

  @override
  String get editorSectionY => 'Профили в Y';

  @override
  String get editorSectionPress => 'Преса';

  @override
  String get editorSectionNameLists => 'Списъци с имена';

  @override
  String get editorSectionSponsors => 'Спонсори';

  @override
  String get editorSectionTrophies => 'Трофеи';

  @override
  String get editorAboutPlayers => 'Състави, рейтинги и потенциал';

  @override
  String get editorAboutNations => 'Имена и кодове на страните';

  @override
  String get editorAboutClubs => 'Имена на клубове';

  @override
  String get editorAboutStadiums => 'Имена на национални стадиони';

  @override
  String get editorAboutCompetitions => 'Имена на състезания';

  @override
  String get editorAboutY => 'Профили в Y';

  @override
  String get editorAboutPress => 'Журналисти и техните медии';

  @override
  String get editorAboutNameLists =>
      'Имена за нови играчи, местни фенове и щаб';

  @override
  String get editorAboutSponsors => 'Марки на спонсори';

  @override
  String get editorAboutTrophies => 'Картинки на трофеи';

  @override
  String editorCountPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count играчи',
      one: '1 играч',
    );
    return '$_temp0';
  }

  @override
  String editorCountNations(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count страни',
      one: '1 страна',
    );
    return '$_temp0';
  }

  @override
  String editorCountChanged(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count промени',
      one: '1 промяна',
      zero: 'Имена от играта',
    );
    return '$_temp0';
  }

  @override
  String editorCountTrophies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count свои картинки',
      one: '1 своя картинка',
      zero: 'Картинки от играта',
    );
    return '$_temp0';
  }

  @override
  String editorCountToFix(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count за оправяне',
      one: '1 за оправяне',
    );
    return '$_temp0';
  }

  @override
  String editorIssuePlayersShort(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Трябват още $count играчи',
      one: 'Трябва още 1 играч',
    );
    return '$_temp0';
  }

  @override
  String editorIssuePlayersOver(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count играчи в повече',
      one: '1 играч в повече',
    );
    return '$_temp0';
  }

  @override
  String editorIssueGoalkeepers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Трябват $count вратари',
      one: 'Трябва 1 вратар',
    );
    return '$_temp0';
  }

  @override
  String editorIssueDefenders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Трябват $count защитници',
      one: 'Трябва 1 защитник',
    );
    return '$_temp0';
  }

  @override
  String editorIssueMidfielders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Трябват $count полузащитници',
      one: 'Трябва 1 полузащитник',
    );
    return '$_temp0';
  }

  @override
  String editorIssueForwards(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Трябват $count нападатели',
      one: 'Трябва 1 нападател',
    );
    return '$_temp0';
  }

  @override
  String get editorIssuePlayerNoName => 'Играч няма име';

  @override
  String editorIssueAge(String name) {
    return '$name: възрастта трябва да е от 15 до 45';
  }

  @override
  String editorIssueRating(String name) {
    return '$name: общият рейтинг трябва да е от 1 до 99';
  }

  @override
  String editorIssuePotential(String name) {
    return '$name: потенциалът трябва да е между общия рейтинг и 99';
  }

  @override
  String editorIssueRenameEmpty(String name) {
    return 'Новото име за $name е празно';
  }

  @override
  String get editorIssueNameEmpty => 'Има празно име';

  @override
  String editorIssueNameTooLong(String name) {
    return '„$name“ е твърде дълго';
  }

  @override
  String editorIssueNameBadCharacters(String name) {
    return '„$name“ съдържа знаци, които не могат да се използват';
  }

  @override
  String editorIssueNameTaken(String name) {
    return '„$name“ вече е заето';
  }

  @override
  String get editorIssueCode => 'Кодът трябва да е от 3 букви, от A до Z';

  @override
  String editorIssueDuplicateCode(String code, String nations) {
    return 'Кодът $code се ползва от $nations';
  }

  @override
  String editorIssueFirstNames(int count) {
    return 'Трябват поне $count първи имена';
  }

  @override
  String editorIssueSurnames(int count) {
    return 'Трябват поне $count фамилии';
  }

  @override
  String get editorIssueValue => 'Стойност е извън допустимото';

  @override
  String get editorIssueUnknown => 'Сочи към нещо, което вече го няма в играта';

  @override
  String get editorSectionSoon => 'Редактирането на този раздел предстои.';

  @override
  String get editorNewFailed =>
      'Базата данни не можа да се създаде. Опитай пак.';

  @override
  String get editorPickFailed => 'Файлът не можа да се отвори.';

  @override
  String get editorRenameFailed => 'Базата данни не можа да се преименува.';

  @override
  String get editorDuplicateFailed => 'Базата данни не можа да се копира.';

  @override
  String get editorNationsSearch => 'Търси страни';

  @override
  String get editorFilterAll => 'Всички';

  @override
  String get editorNationsNone =>
      'Няма страна, която да отговаря на търсенето.';

  @override
  String get editorNationSquadReady => 'Съставът е готов';

  @override
  String get editorSquadAdd => 'Добави играч';

  @override
  String editorSquadFull(int max) {
    return 'Съставът побира най-много $max играчи.';
  }

  @override
  String editorSquadRemoved(String name) {
    return '$name е изваден от състава';
  }

  @override
  String get editorPlayerUnnamed => 'Играч без име';

  @override
  String get editorSquadDuplicate => 'Друг играч в този състав има същото име.';

  @override
  String get editorSquadEmpty => 'Още няма играчи. Добави първия.';

  @override
  String get editorSquadReady => 'Този състав е готов за игра.';

  @override
  String get editorSquadFill => 'Попълни липсващите играчи';

  @override
  String get editorSquadFillAbout =>
      'Добавя генерираните играчи на националния отбор, започвайки от най-силните, докато съставът достигне нужния за кариера брой и позиции.';

  @override
  String editorSquadFilled(int count) {
    return 'Добавени играчи: $count';
  }

  @override
  String get editorCommunityTitle =>
      'Феновете споделят базите си данни в нашия Discord';

  @override
  String get editorCommunityAbout =>
      'Споделя се от общността. Ние не хостваме и не проверяваме тези бази данни.';

  @override
  String editorSquadRules(int min, int max, int gk, int def, int mid, int fwd) {
    return 'От $min до $max играчи, с поне $gk вратари, $def защитници, $mid полузащитници и $fwd нападатели.';
  }

  @override
  String get editorShortGk => 'ВР';

  @override
  String get editorShortDef => 'ЗАЩ';

  @override
  String get editorShortMid => 'ПЗ';

  @override
  String get editorShortFwd => 'НП';

  @override
  String editorPlayerAgeShort(int age) {
    return '$age г.';
  }

  @override
  String get editorPlayerName => 'Име';

  @override
  String get editorPlayerNameHint => 'Напиши името му';

  @override
  String get editorPlayerNameNeeded => 'Трябва име.';

  @override
  String get editorPlayerNameBad => 'Махни необичайните знаци.';

  @override
  String get editorPlayerAge => 'Възраст';

  @override
  String get editorPlayerPosition => 'Позиция';

  @override
  String get editorPlayerClub => 'Клуб';

  @override
  String get editorPlayerFreeAgent => 'Свободен агент';

  @override
  String get editorPlayerClubSearch => 'Търси клубове';

  @override
  String get editorPlayerClubNone =>
      'Няма клуб, който да отговаря на търсенето.';

  @override
  String get editorPlayerClubPick => 'Избери клуб';

  @override
  String get editorPlayerOverall => 'Общ рейтинг';

  @override
  String get editorPlayerType => 'Тип играч';

  @override
  String get editorPlayerPotential => 'Потенциал';

  @override
  String get editorPlayerPotentialAbout =>
      'Върхът, до който може да стигне, ако се развива добре. Никога под общия му рейтинг.';

  @override
  String get editorPlayerQualities => 'Какво пази играта';

  @override
  String get editorTypeBalanced => 'Балансиран';

  @override
  String get editorTypeAthlete => 'Атлет';

  @override
  String get editorTypeTechnician => 'Техник';

  @override
  String get editorTypeEngine => 'Мотор';

  @override
  String get editorTypeBalancedAbout =>
      'Равен във физика, техника и издръжливост.';

  @override
  String get editorTypeAthleteAbout =>
      'Силен и бърз, малко по-слаб в техниката.';

  @override
  String get editorTypeTechnicianAbout =>
      'Майстор с топката, по-слаб физически.';

  @override
  String get editorTypeEngineAbout =>
      'Тича цял мач, стабилен във всичко останало.';

  @override
  String get editorPlayerLess => 'С един по-малко';

  @override
  String get editorPlayerMore => 'С един повече';

  @override
  String get editorPlayerRemove => 'Извади от състава';

  @override
  String get editorPlayerGone => 'Този играч вече не е в състава.';

  @override
  String get editorNationGone => 'Тази страна я няма в базата данни.';

  @override
  String get editorPickPlayer => 'Избери играч за редактиране.';

  @override
  String get editorPlayerClubAuto => 'Избран от играта';

  @override
  String get editorPlayerClubAutoAbout =>
      'Играта го слага в клуб, който отговаря на нивото му.';

  @override
  String get editorNamesSearch => 'Търси имена';

  @override
  String get editorNamesSearchClubs => 'Търси клубове или страни';

  @override
  String get editorNamesSearchStadiums => 'Търси стадиони, градове или страни';

  @override
  String get editorNamesSearchNations => 'Търси страни или кодове';

  @override
  String get editorNamesNone => 'Нищо не отговаря на търсенето.';

  @override
  String get editorNamesEveryLanguage =>
      'Собственото име се показва на всички езици, освен ако не дадеш на даден език негово име.';

  @override
  String editorNamesGameName(String name) {
    return 'Име в играта: $name';
  }

  @override
  String get editorNamesReset => 'Върни оригинала';

  @override
  String get editorNamesDone => 'Готово';

  @override
  String get editorNamesKeepHint =>
      'Остави празно, за да запазиш името от играта.';

  @override
  String get editorNamesCode => 'Код';

  @override
  String get editorNamesCodeHelp =>
      '3 букви, от A до Z, които не ползва друга страна.';

  @override
  String editorNamesCodeTaken(String code, String nation) {
    return '$code вече се ползва от $nation.';
  }

  @override
  String get editorNamesTaken => 'Друг профил вече има това име.';

  @override
  String get editorLanguageTitle => 'Имена на кой език';

  @override
  String get editorLanguageAll => 'Всички езици';

  @override
  String get editorLanguageAllShort => 'Всички';

  @override
  String get editorLanguageNote =>
      'Сменя се само редакторът. Играта остава на своя език.';

  @override
  String editorLanguageEditing(String language) {
    return 'Имена на език: $language. Остави празно, за да се ползва основното име.';
  }

  @override
  String get editorLanguageSame => 'Еднакво на всички езици';

  @override
  String editorLanguageMainName(String name) {
    return 'Основно име: $name';
  }

  @override
  String get editorLanguageKeepHint =>
      'Остави празно, за да се ползва основното име.';

  @override
  String get editorLanguageClear => 'Използвай основното име';

  @override
  String get editorLanguageFull =>
      'Тази база данни няма място за още имена по езици.';

  @override
  String get editorPlayerDelete => 'Изтрий играча';

  @override
  String get editorPlayerAdvanced => 'Разширени';

  @override
  String get editorPlayerAdvancedAbout =>
      'Задай физика, техника и издръжливост поотделно.';

  @override
  String get editorPlayerAdvancedOverall => 'Общ рейтинг от тях';

  @override
  String get editorPlayerTraits => 'Известен с';

  @override
  String get editorPlayerTraitsRandom => 'Случайно';

  @override
  String get editorPlayerTraitsRandomAbout =>
      'Всяка кариера му избира черти случайно, както досега.';

  @override
  String get editorPlayerTraitsNone => 'Без черти, във всяка кариера.';

  @override
  String editorPlayerTraitsPicked(int max) {
    return 'Тези черти във всяка кариера. Избери до $max.';
  }

  @override
  String editorPlayerTraitsMax(int max) {
    return 'Играчът има най-много $max черти. Първо махни една.';
  }

  @override
  String editorPlayerTraitUnknown(String trait) {
    return '$trait (непозната за тази версия)';
  }

  @override
  String editorIssueInLanguage(String issue, String language) {
    return '$issue ($language)';
  }

  @override
  String get editorTabSquad => 'Състав';

  @override
  String get editorTabPool => 'Пул';

  @override
  String get editorPoolGenerated => 'Създаден от играта';

  @override
  String get editorPoolGeneratedAbout =>
      'Всяка кариера тегли този пул наново, както досега. Първата ти промяна го фиксира точно както е тук, във всяка кариера.';

  @override
  String get editorPoolFixed => 'Твоят пул';

  @override
  String get editorPoolFixedAbout =>
      'Всяка кариера започва точно с тези играчи.';

  @override
  String get editorPoolReset => 'Върни на играта';

  @override
  String get editorPoolResetTitle => 'Да се върне пулът на играта?';

  @override
  String get editorPoolResetBody =>
      'Промените ти в този пул отпадат и всяка кариера го създава наново.';

  @override
  String editorPoolMax(int max) {
    return 'До $max';
  }

  @override
  String editorPoolFull(int max) {
    return 'Пулът побира най-много $max играчи.';
  }

  @override
  String editorPoolRemoved(String name) {
    return '$name е изваден от пула';
  }

  @override
  String get editorPoolRemove => 'Извади от пула';

  @override
  String get editorPoolPlayerGone => 'Този играч вече не е в пула.';

  @override
  String get editorPoolDuplicate => 'Друг играч в този пул има същото име.';

  @override
  String get editorPoolEmpty => 'Няма играчи в този пул. Добави първия.';

  @override
  String get editorPoolLoadFailed => 'Пулът на играта не можа да се прочете.';

  @override
  String editorPlayerTraitsUnknownDropped(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Премахнати са $count непознати черти',
      one: 'Премахната е 1 непозната черта',
    );
    return '$_temp0';
  }

  @override
  String get editorAddedTag => 'Добавен';

  @override
  String get editorAddedGroup => 'Добавени';

  @override
  String get editorAddedGameGroup => 'В играта';

  @override
  String get editorAddClub => 'Добави клуб';

  @override
  String get editorAddSponsor => 'Добави спонсор';

  @override
  String get editorAddY => 'Добави профил';

  @override
  String get editorAddedAdd => 'Добави';

  @override
  String get editorAddedDelete => 'Изтрий';

  @override
  String editorAddedRemoved(String name) {
    return 'Изтрито: $name';
  }

  @override
  String editorAddedClubsFull(int max) {
    return 'Базата данни може да добави най-много $max клуба.';
  }

  @override
  String editorAddedSponsorsFull(int max) {
    return 'Базата данни може да добави най-много $max спонсора.';
  }

  @override
  String editorAddedYFull(int max) {
    return 'Базата данни може да добави най-много $max профила.';
  }

  @override
  String get editorAddReporter => 'Добави журналист';

  @override
  String get editorAddStadium => 'Добави стадион';

  @override
  String editorAddedReportersFull(int max) {
    return 'Базата данни може да добави най-много $max журналисти.';
  }

  @override
  String editorAddedStadiumsFull(int max) {
    return 'Базата данни може да добави най-много $max стадиона.';
  }

  @override
  String get editorAddedCity => 'Град';

  @override
  String get editorAddedCityHelp =>
      'Става всеки град. Град, който играта не познава, приема облика на страната си и е на морското равнище.';

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

    return 'От $minString до $maxString места';
  }

  @override
  String editorAddedStadiumTaken(String country) {
    return '$country вече има добавен стадион с това име.';
  }

  @override
  String get editorAddedFieldNeeded => 'Попълни това поле';

  @override
  String get editorAddedReporterAbout =>
      'В кариерите с тази база данни влиза в пресзалата и задава въпроси на пресконференциите.';

  @override
  String get editorAddedStadiumAbout =>
      'В кариерите с тази база данни приема част от домакинските мачове на националния си отбор. Финалните турнири остават на стадионите от играта.';

  @override
  String get editorAddedGone => 'Това вече не е в базата данни.';

  @override
  String get editorAddedNameNeeded => 'Дай му име';

  @override
  String get editorAddedCountry => 'Страна';

  @override
  String get editorAddedCountryPick => 'Избери страна';

  @override
  String editorAddedNoLeague(String country) {
    return '$country няма лига или градове в играта, затова този клуб получава само играчите, които сложиш в него.';
  }

  @override
  String editorAddedClubTaken(String country) {
    return '$country вече има клуб с това име.';
  }

  @override
  String get editorAddedClubGameName => 'Клуб в играта вече носи това име.';

  @override
  String editorAddedClubPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count играчи от тази база данни играят тук. Ако изтриеш клуба, играта ще ги настани другаде.',
      one:
          '1 играч от тази база данни играе тук. Ако изтриеш клуба, играта ще го настани другаде.',
    );
    return '$_temp0';
  }

  @override
  String get editorAddedDeal => 'Тип договор';

  @override
  String get editorDealBigPayer => 'Щедър платец';

  @override
  String get editorDealCrowdPleaser => 'Любимец на играчите';

  @override
  String get editorDealFamilyFriendly => 'Семеен';

  @override
  String get editorDealMarketing => 'Маркетинг';

  @override
  String get editorAddedIndustry => 'Отрасъл';

  @override
  String get editorAddedIndustryPick => 'Избери отрасъл';

  @override
  String get editorHandleLabel => 'Потребителско име';

  @override
  String get editorHandleHelp =>
      'Букви, цифри и долни черти. Оставете празно, за да следва името.';

  @override
  String get editorHandleBadCharacters =>
      'Използвайте само латински букви от A до Z, цифри и долни черти';

  @override
  String get editorHandleTaken =>
      'Друг профил вече има това потребителско име.';

  @override
  String get editorAddedDescription => 'Описание (по желание)';

  @override
  String get editorAddedDescriptionHelp =>
      'Ако е празно, офертата ползва обичайния текст за типа договор.';

  @override
  String get editorAddedVoice => 'Тип профил';

  @override
  String get editorYVoiceFan => 'Фен';

  @override
  String get editorYVoicePundit => 'Експерт';

  @override
  String get editorYVoiceMeme => 'Мемета';

  @override
  String get editorYVoiceStats => 'Статистика';

  @override
  String get editorYVoiceRival => 'Съперник';

  @override
  String get editorYVoiceExpro => 'Бивш играч';

  @override
  String get editorYVoiceNeutral => 'Неутрален';

  @override
  String get editorYVoiceFanAbout =>
      'Един от твоите фенове. Възторжен, бесен, непостоянен.';

  @override
  String get editorYVoicePunditAbout =>
      'Премерен глас, който се появява през цялата кариера.';

  @override
  String get editorYVoiceMemeAbout => 'Не казва нищо полезно и го четат първи.';

  @override
  String get editorYVoiceStatsAbout => 'Публикува цифри и нищо друго.';

  @override
  String get editorYVoiceRivalAbout => 'Радва се на неволите ти.';

  @override
  String get editorYVoiceExproAbout =>
      'Бивш национал с рубрика и без капка търпение.';

  @override
  String get editorYVoiceNeutralAbout =>
      'Гледа целия футбол и се появява само когато стане нещо голямо.';

  @override
  String get editorAddedPostsIn => 'Пише в';

  @override
  String get editorAddedAllNations => 'Всички страни';

  @override
  String get editorAddedSearch => 'Търси';

  @override
  String editorCountAdded(int count) {
    return 'Добавени: $count';
  }

  @override
  String get editorNamesOutlet => 'Медия';

  @override
  String get editorNamesFirstNames => 'Първи имена';

  @override
  String get editorNamesSurnames => 'Фамилии';

  @override
  String editorNamesFirstCount(int count, int min) {
    return '$count / $min първи имена';
  }

  @override
  String editorNamesSurCount(int count, int min) {
    return '$count / $min фамилии';
  }

  @override
  String editorNamesListsHelp(int min) {
    return 'Раздели имената със запетаи или нови редове. Всеки списък иска поне $min. С тях се кръщават нови играчи, местни фенове и щаб.';
  }

  @override
  String editorNamesListCounts(int first, int sur) {
    return '$first първи имена, $sur фамилии';
  }

  @override
  String editorNamesMainStadium(String city) {
    return 'Главен стадион в $city';
  }

  @override
  String get editorNamesChanged => 'Променено';

  @override
  String get editorNamesPick => 'Избери име за редактиране.';

  @override
  String get editorNamesStadiumsNote =>
      'Може да се преименуват само изброените тук национални стадиони: главният стадион на всеки град.';

  @override
  String get editorTrophiesIntro =>
      'Докосни трофей, за да му дадеш своя картинка. Най-добре изглежда PNG с прозрачен фон.';

  @override
  String get editorTrophyCustom => 'Своя';

  @override
  String get editorTrophyDefault => 'От играта';

  @override
  String get editorTrophyChoose => 'Избери картинка';

  @override
  String get editorTrophyReplace => 'Избери друга картинка';

  @override
  String get editorTrophyReset => 'Върни стандартната';

  @override
  String get editorTrophyResetTitle => 'Картинката от играта?';

  @override
  String get editorTrophyResetBody =>
      'Твоята картинка за този трофей ще бъде премахната. Връщането не може да я възстанови.';

  @override
  String get editorTrophyResetConfirm => 'Премахни картинката';

  @override
  String get editorTrophyUnusable =>
      'Тази картинка не става. Избери PNG или JPEG до 4096 пиксела на страна.';

  @override
  String get editorTrophyOpening => 'Отваряне на картинката';

  @override
  String get editorTrophyPreparing => 'Подготовка на трофея';

  @override
  String get editorTrophyFrameTitle => 'Нагласи трофея';

  @override
  String get editorTrophyFrameHint =>
      'Плъзни, за да местиш, и щипни, за да мащабираш. Каквото е в рамката, става трофеят.';

  @override
  String get editorTrophyFit => 'Побери';

  @override
  String get editorTrophyPreview => 'Преглед';

  @override
  String get editorTrophyPreviewTitle => 'Как ще изглежда';

  @override
  String get editorTrophyAdjust => 'Нагласи';

  @override
  String get editorTrophyUse => 'Използвай я';

  @override
  String get editorTrophyRectangle =>
      'Картинката няма прозрачен фон, затова играта ще я показва като правоъгълник.';

  @override
  String get editorTrophyRectangleShort => 'Показва се като правоъгълник';

  @override
  String get editorTrophySaved => 'Картинката на трофея е запазена.';

  @override
  String get editorTrophyRemoved => 'Картинката от играта се върна.';

  @override
  String get editorTrophySaveFailed =>
      'Картинката не можа да се запази. Опитай пак.';

  @override
  String get editorSaveFailed =>
      'Последните промени не можаха да се запазят. Опитваме отново.';

  @override
  String get editorTrophyPick => 'Избери трофей, за да смениш картинката му.';

  @override
  String editorTrophySize(int width, int height) {
    return 'Запазена в $width x $height пиксела';
  }

  @override
  String editorIssueUnknownEntry(String name) {
    return '$name вече го няма в играта';
  }

  @override
  String get editorAttentionBody =>
      'Нещо в тази база данни не пасва на тази версия на играта: еднакви имена или нещо, което обновление на играта е премахнало. Оправи или премахни всеки запис по-долу и на нея отново ще може да се започне кариера.';

  @override
  String get editorRemove => 'Премахни';

  @override
  String worldChip(String name) {
    return 'Свят: $name';
  }

  @override
  String get worldDefault => 'Стандартен';

  @override
  String get worldDefaultAbout => 'Собственият свят на играта';

  @override
  String get worldSheetTitle => 'Избери свят';

  @override
  String get worldSheetBlurb =>
      'Бази данни, които си създал или отворил в Редактора. Само пълните могат да започнат кариера.';

  @override
  String get worldPackGone =>
      'Тази база данни вече не е на устройството. Кариерата не започна.';

  @override
  String get worldStarting => 'Подготвяме твоя свят';

  @override
  String get settingsDefaultWorldTitle => 'Стандартен свят';

  @override
  String get settingsDefaultWorldBlurb =>
      'Светът, в който започва Нова игра. Пак можеш да го смениш за всяка кариера.';

  @override
  String get worldPackNotReady =>
      'Тази база данни вече не може да започне кариера. Оправи я в Редактора или избери друг свят.';

  @override
  String pitchComShotGoal1(String player) {
    return 'ГОЛ! $player намира мрежата!';
  }

  @override
  String pitchComShotGoal2(String player) {
    return '$player стреля и топката е вътре! ГОЛ!';
  }

  @override
  String pitchComShotGoal3(String player) {
    return 'ГОЛ! Хладнокръвно завършване на $player.';
  }

  @override
  String pitchComShotSaved1(String player, String keeper) {
    return '$player стреля, но $keeper спасява.';
  }

  @override
  String pitchComShotSaved2(String player) {
    return '$player опитва, но вратарят е на място.';
  }

  @override
  String pitchComShotSaved3(String player, String keeper) {
    return '$player изстрелва топката, $keeper я отбива!';
  }

  @override
  String pitchComShotWide1(String player) {
    return '$player стреля встрани от вратата.';
  }

  @override
  String pitchComShotWide2(String player) {
    return 'Неточен удар на $player.';
  }

  @override
  String pitchComShotWide3(String player) {
    return '$player праща топката на милиметри от стойката.';
  }

  @override
  String pitchComShotBlocked1(String player) {
    return '$player стреля, но ударът е блокиран.';
  }

  @override
  String pitchComShotBlocked2(String player) {
    return 'Блокирано! $player не намира път към вратата.';
  }

  @override
  String pitchComShotBlocked3(String player) {
    return '$player удря, но защитник застава на пътя на топката.';
  }

  @override
  String pitchComShotWoodwork1(String player) {
    return 'Греда! $player няма късмет.';
  }

  @override
  String pitchComShotWoodwork2(String player) {
    return '$player попада в рамката на вратата!';
  }

  @override
  String pitchComShotWoodwork3(String player) {
    return 'Напречна греда! $player е безкрайно близо.';
  }

  @override
  String pitchComHeaderGoal1(String player) {
    return 'ГОЛ! $player праща топката във вратата с глава!';
  }

  @override
  String pitchComHeaderGoal2(String player) {
    return '$player се извисява над всички и вкарва! ГОЛ!';
  }

  @override
  String pitchComHeaderGoal3(String player) {
    return 'ГОЛ! Мощен удар с глава на $player.';
  }

  @override
  String pitchComHeaderSaved1(String player, String keeper) {
    return '$player удря с глава, $keeper спасява.';
  }

  @override
  String pitchComHeaderSaved2(String player) {
    return '$player с глава, но вратарят хваща топката.';
  }

  @override
  String pitchComHeaderSaved3(String player, String keeper) {
    return '$player с глава, $keeper отбива топката.';
  }

  @override
  String pitchComHeaderWide1(String player) {
    return '$player удря с глава встрани.';
  }

  @override
  String pitchComHeaderWide2(String player) {
    return '$player с глава, но неточно.';
  }

  @override
  String pitchComHeaderWide3(String player) {
    return '$player не успява да смъкне топката след удара с глава.';
  }

  @override
  String pitchComHeaderBlocked1(String player) {
    return '$player удря с глава, но ударът е блокиран.';
  }

  @override
  String pitchComHeaderBlocked2(String player) {
    return '$player с глава към вратата, но защитата блокира.';
  }

  @override
  String pitchComHeaderBlocked3(String player) {
    return 'Блокирано! $player стига до топката, но защитник е на пътя.';
  }

  @override
  String pitchComHeaderWoodwork1(String player) {
    return '$player с глава в напречната греда!';
  }

  @override
  String pitchComHeaderWoodwork2(String player) {
    return 'Греда! $player с глава, топката се връща в игра.';
  }

  @override
  String pitchComHeaderWoodwork3(String player) {
    return 'Рамката на вратата потреперва! $player удря с глава.';
  }

  @override
  String pitchComSetPieceGoal1(String player) {
    return 'ГОЛ! $player е там в края на атаката!';
  }

  @override
  String pitchComSetPieceGoal2(String player, String other) {
    return 'ГОЛ! $other центрира и $player вкарва!';
  }

  @override
  String pitchComSetPieceGoal3(String player) {
    return 'От статично положение вкарва $player! ГОЛ!';
  }

  @override
  String pitchComSetPieceSaved1(String player, String keeper) {
    return '$player стига до топката, но $keeper спасява.';
  }

  @override
  String pitchComSetPieceSaved2(String player) {
    return '$player докосва топката, вратарят я хваща.';
  }

  @override
  String pitchComSetPieceSaved3(String player, String keeper) {
    return '$player стреля, $keeper е бдителен.';
  }

  @override
  String pitchComSetPieceWide1(String player) {
    return '$player стига до удар, но встрани.';
  }

  @override
  String pitchComSetPieceWide2(String player) {
    return '$player посреща центрирането, но неточно.';
  }

  @override
  String pitchComSetPieceWide3(String player) {
    return 'Над гредата от $player.';
  }

  @override
  String pitchComSetPieceBlocked1(String player) {
    return '$player стига до топката, но ударът е блокиран.';
  }

  @override
  String pitchComSetPieceBlocked2(String player) {
    return 'Меле във вратарската зона! $player е блокиран.';
  }

  @override
  String pitchComSetPieceBlocked3(String player) {
    return '$player се опитва да вкара топката, но защитата изчиства.';
  }

  @override
  String pitchComSetPieceWoodwork1(String player) {
    return '$player стреля и попада в стойката!';
  }

  @override
  String pitchComSetPieceWoodwork2(String player) {
    return 'Греда! $player за малко не вкарва от статично положение.';
  }

  @override
  String pitchComSetPieceWoodwork3(String player) {
    return 'Рамката на вратата! $player е толкова близо след центрирането.';
  }

  @override
  String pitchComDirectFreeKickGoal1(String player) {
    return 'ГОЛ! $player прехвърля стената със свободния удар!';
  }

  @override
  String pitchComDirectFreeKickGoal2(String player) {
    return 'Какъв свободен удар! $player намира шарнира!';
  }

  @override
  String pitchComDirectFreeKickGoal3(String player) {
    return 'ГОЛ! $player надхитря вратаря със свободен удар.';
  }

  @override
  String pitchComDirectFreeKickSaved1(String player, String keeper) {
    return '$player стреля директно, $keeper спасява.';
  }

  @override
  String pitchComDirectFreeKickSaved2(String player) {
    return 'Свободният удар на $player е отбит.';
  }

  @override
  String pitchComDirectFreeKickSaved3(String player, String keeper) {
    return 'Страхотно спасяване! Свободен удар на $player, $keeper го изважда.';
  }

  @override
  String pitchComDirectFreeKickWide1(String player) {
    return 'Свободният удар на $player минава над вратата.';
  }

  @override
  String pitchComDirectFreeKickWide2(String player) {
    return '$player стреля директно, но встрани.';
  }

  @override
  String pitchComDirectFreeKickWide3(String player) {
    return '$player не уцелва вратата от свободен удар.';
  }

  @override
  String pitchComDirectFreeKickBlocked1(String player) {
    return 'Свободният удар на $player удря в стената.';
  }

  @override
  String pitchComDirectFreeKickBlocked2(String player) {
    return '$player удря в стената.';
  }

  @override
  String pitchComDirectFreeKickBlocked3(String player) {
    return 'Стената устоява, $player не успява да мине.';
  }

  @override
  String pitchComDirectFreeKickWoodwork1(String player) {
    return '$player уцелва гредата със свободния удар!';
  }

  @override
  String pitchComDirectFreeKickWoodwork2(String player) {
    return 'Стойка! Свободен удар на $player, топката се връща.';
  }

  @override
  String pitchComDirectFreeKickWoodwork3(String player) {
    return 'Рамката спасява вратаря! $player няма късмет.';
  }

  @override
  String pitchComPenaltyGoal1(String player) {
    return 'ГОЛ! $player праща вратаря в грешната посока.';
  }

  @override
  String pitchComPenaltyGoal2(String player) {
    return '$player засилва се и вкарва! ГОЛ!';
  }

  @override
  String pitchComPenaltyGoal3(String player) {
    return 'ГОЛ! $player реализира дузпата хладнокръвно.';
  }

  @override
  String pitchComPenaltySaved1(String player, String keeper) {
    return 'Спасено! $player изпълнява, $keeper спира дузпата!';
  }

  @override
  String pitchComPenaltySaved2(String player) {
    return '$player се засилва... и вратарят спасява!';
  }

  @override
  String pitchComPenaltySaved3(String player, String keeper) {
    return '$player изпълнява дузпата, $keeper познава посоката и спасява!';
  }

  @override
  String pitchComPenaltyMissed1(String player) {
    return '$player пропуска дузпата!';
  }

  @override
  String pitchComPenaltyMissed2(String player) {
    return 'Встрани! $player праща дузпата покрай стойката.';
  }

  @override
  String pitchComPenaltyMissed3(String player) {
    return 'Над вратата! $player праща дузпата в небето.';
  }

  @override
  String pitchComPenaltyWoodwork1(String player) {
    return '$player от дузпата уцелва стойката!';
  }

  @override
  String pitchComPenaltyWoodwork2(String player) {
    return 'Греда! $player не реализира дузпата.';
  }

  @override
  String pitchComPenaltyWoodwork3(String player) {
    return 'Рамката! $player не вярва на очите си.';
  }

  @override
  String pitchComPenaltyAwarded1(String player) {
    return 'Дузпа! $player пада в наказателното поле.';
  }

  @override
  String pitchComPenaltyAwarded2(String player, String other) {
    return 'Съдията сочи бялата точка! $other фаулира, $player лежи в наказателното поле.';
  }

  @override
  String pitchComPenaltyAwarded3(String player, String other) {
    return 'Отсъдена дузпа! $other фаулира в наказателното поле, $player пада.';
  }

  @override
  String pitchComPenaltyAwardedYellow1(String player, String other) {
    return 'Дузпа! $player пада, а $other получава жълт картон.';
  }

  @override
  String pitchComPenaltyAwardedYellow2(String player, String other) {
    return 'Дузпа и жълт картон за $other, $player лежи в наказателното поле.';
  }

  @override
  String pitchComPenaltyAwardedYellow3(String player, String other) {
    return 'Дузпа и картон! $other събаря $player в наказателното поле.';
  }

  @override
  String pitchComPenaltyAwardedRed1(String player, String other) {
    return 'Дузпа и червен картон! $player пада, $other напуска терена.';
  }

  @override
  String pitchComPenaltyAwardedRed2(String player, String other) {
    return 'Дузпа, а $other е изгонен! $player лежи в наказателното поле.';
  }

  @override
  String pitchComPenaltyAwardedRed3(String player, String other) {
    return 'Червен картон и дузпа! $player е сам срещу вратата, $other го събаря.';
  }

  @override
  String pitchComCorner1(String player) {
    return 'Корнер. Изпълнява $player.';
  }

  @override
  String pitchComCorner2(String player) {
    return '$player центрира от корнера.';
  }

  @override
  String pitchComCorner3(String player) {
    return 'Корнер, при топката застава $player.';
  }

  @override
  String pitchComFreeKick1(String player) {
    return 'Свободен удар. Изпълнява $player.';
  }

  @override
  String pitchComFreeKick2(String player) {
    return 'Свободен удар на опасно място. При топката е $player.';
  }

  @override
  String pitchComFreeKick3(String player) {
    return '$player се приготвя за свободния удар.';
  }

  @override
  String pitchComLongThrow1(String player) {
    return 'Дълъг аут! $player хвърля топката в наказателното поле.';
  }

  @override
  String pitchComLongThrow2(String player) {
    return '$player с дълъг аут в наказателното поле.';
  }

  @override
  String pitchComLongThrow3(String player) {
    return 'Ето дългия аут, хвърля $player.';
  }

  @override
  String pitchComFoulYellow1(String player) {
    return 'Жълт картон за $player.';
  }

  @override
  String pitchComFoulYellow2(String player, String other) {
    return '$player получава жълт картон за фал, $other остава на терена.';
  }

  @override
  String pitchComFoulYellow3(String player, String other) {
    return 'Закъсняло влизане, $other е на земята, а $player вижда жълт картон.';
  }

  @override
  String pitchComFoulSecondYellow1(String player) {
    return 'Втори жълт! $player напуска терена.';
  }

  @override
  String pitchComFoulSecondYellow2(String player) {
    return '$player получава втори жълт картон и е изгонен.';
  }

  @override
  String pitchComFoulSecondYellow3(String player) {
    return 'Втори жълт картон за $player, значи червен.';
  }

  @override
  String pitchComFoulRed1(String player) {
    return 'Червен картон! $player е изгонен.';
  }

  @override
  String pitchComFoulRed2(String player, String other) {
    return 'Директен червен! $player фаулира, $other остава на терена.';
  }

  @override
  String pitchComFoulRed3(String player) {
    return '$player вижда червен картон и трябва да си тръгне.';
  }

  @override
  String pitchComOffside1(String player) {
    return 'Засада. $player е тръгнал твърде рано.';
  }

  @override
  String pitchComOffside2(String player) {
    return 'Флагчето се вдига, $player е в засада.';
  }

  @override
  String pitchComOffside3(String player) {
    return '$player е в засада, атаката спира.';
  }

  @override
  String pitchComSub1(String player, String other) {
    return 'Смяна: влиза $player, излиза $other.';
  }

  @override
  String pitchComSub2(String player, String other) {
    return '$other напуска терена, сменя го $player.';
  }

  @override
  String pitchComSub3(String player, String other) {
    return 'На терена влиза $player, излиза $other.';
  }

  @override
  String pitchComSubFill1(String player) {
    return 'На терена излиза $player.';
  }

  @override
  String pitchComSubFill2(String player) {
    return 'Смяна: влиза $player.';
  }

  @override
  String pitchComSubFill3(String player) {
    return '$player влиза в игра.';
  }

  @override
  String pitchComInjury1(String player) {
    return '$player е на земята и се нуждае от помощ.';
  }

  @override
  String pitchComInjury2(String player) {
    return 'Тревога, $player получи удар.';
  }

  @override
  String pitchComInjury3(String player) {
    return 'Тревожна контузия за $player.';
  }

  @override
  String pitchComGoalScore(String line, int home, int away) {
    return '$line $home–$away';
  }

  @override
  String get pitchComSomeone => 'Играч';

  @override
  String pitchComPenaltyAwardedSecondYellow1(String player, String other) {
    return 'Дузпа и втори жълт! $other напуска терена, $player лежи в наказателното поле.';
  }

  @override
  String pitchComPenaltyAwardedSecondYellow2(String player, String other) {
    return 'Дузпа! $player пада, а $other получава втори жълт картон.';
  }

  @override
  String pitchComPenaltyAwardedSecondYellow3(String player, String other) {
    return 'Дузпа! $other събаря $player и получава втори жълт, значи червен.';
  }

  @override
  String get matchViewChooseTitle => 'Как искате да следите мача?';

  @override
  String get matchViewChooseHint =>
      'Изборът ви важи и за следващия мач. Можете да го смените по всяко време.';

  @override
  String get matchViewPitch => '2D TV';

  @override
  String get matchViewPitchBlurb => 'Следете играчите на терена';

  @override
  String get matchViewTimeline => 'Ход';

  @override
  String get matchViewTimelineBlurb => 'Следете мача събитие по събитие';

  @override
  String get matchViewSwitchToPitch => 'Гледай в режим 2D TV';

  @override
  String get matchViewSwitchToTimeline => 'Гледай хода';

  @override
  String get matchTabCommentary => 'КОМЕНТАР';

  @override
  String get matchSubShout => 'СМЯНА';

  @override
  String matchSubOff(String name) {
    return 'Излиза: $name';
  }

  @override
  String matchSubOn(String name) {
    return 'Влиза: $name';
  }

  @override
  String get editorFilterToFix => 'За поправяне';

  @override
  String get editorNothingToFix => 'Тук няма нищо за поправяне.';

  @override
  String get editorPromoteTooltip => 'Премести в състава';

  @override
  String editorPromoted(String name) {
    return '$name е преместен в състава';
  }

  @override
  String get editorPromoteFullTitle => 'Съставът е пълен';

  @override
  String editorPromoteFullBody(int max) {
    return 'Съставът може да има най-много $max играчи. Изберете играча, който се връща в групата на негово място.';
  }

  @override
  String get editorTrophyGallery => 'Избор от снимките ви';

  @override
  String get editorTrophyFile => 'Избор на файл';

  @override
  String clubStrengthOf(int stars) {
    return 'Сила на клуба: $stars от 5';
  }

  @override
  String get editorClubStrength => 'Сила';

  @override
  String get editorClubStrengthDefault => 'По подразбиране';

  @override
  String editorClubStrengthHelp(int stars) {
    return 'По-добрите играчи отиват в по-силни клубове. По подразбиране: $stars от 5 според лигата му.';
  }

  @override
  String mgrNewsSacked(String nation, String name) {
    return '$nation освобождава $name';
  }

  @override
  String mgrNewsResigned(String nation, String name) {
    return '$nation: $name подава оставка';
  }

  @override
  String mgrNewsPoached(String nation, String name) {
    return '$nation: $name напуска заради друг национален отбор';
  }

  @override
  String mgrNewsRetired(String nation, String name) {
    return '$nation: $name се оттегля от треньорството';
  }

  @override
  String mgrNewsContractEnd(String nation, String name) {
    return '$nation: $name си тръгва с изтичането на договора';
  }

  @override
  String mgrNewsReplacedByPlayer(String nation, String name) {
    return '$nation: $name отстъпва мястото на теб';
  }

  @override
  String mgrNewsAppointed(String nation, String name) {
    return '$nation назначава $name';
  }

  @override
  String mgrNewsAppointedBody(String nation, String name) {
    return '$name поема $nation.';
  }

  @override
  String pressBeatOpposingManager(String manager) {
    return 'Ти и $manager имате история. Имаш ли какво да кажеш за него?';
  }

  @override
  String get pressAnswerHitBackAtManager =>
      'Нека се тревожи за собствения си отбор.';

  @override
  String get pressAnswerRespectManager => 'Изпитвам голямо уважение към него.';

  @override
  String yMgrTie1(String manager) {
    return 'На другата скамейка е $manager. Има история с нашия селекционер и нямам търпение.';
  }

  @override
  String yMgrTie2(String manager) {
    return 'Следва $manager на другата скамейка. Той и нашият селекционер се познават отдавна.';
  }

  @override
  String yMgrTie3(String manager) {
    return 'Пак $manager. По-добре нашият селекционер да не го превръща в лично.';
  }

  @override
  String yMgrTie4(String manager) {
    return 'Почва се. $manager на тъчлинията, а нашият селекционер се опитва да спечели вражда вместо мач.';
  }

  @override
  String get mgrRowLabel => 'Селекционер';

  @override
  String mgrRowDetail(int age, String date) {
    return '$age години, от $date';
  }

  @override
  String mgrRecordWdl(int won, int drawn, int lost) {
    return '$won П, $drawn Р, $lost З';
  }

  @override
  String mgrRowRecord(String record) {
    return 'Под негово ръководство: $record';
  }

  @override
  String get mgrTieNeutral => 'Без история';

  @override
  String get mgrTieRespect => 'Уважение';

  @override
  String get mgrTieRival => 'Съперник';

  @override
  String get mgrTieGrudge => 'Вражда';

  @override
  String get mgrTieSuccessor => 'Наследник';

  @override
  String get mgrTieProtege => 'Протеже';

  @override
  String get mgrTieFormerPlayer => 'Бивш играч';

  @override
  String get mgrEndSacked => 'Освободен';

  @override
  String get mgrEndResigned => 'Подаде оставка';

  @override
  String get mgrEndPoached => 'Премина към друг национален отбор';

  @override
  String get mgrEndRetired => 'Оттегли се от треньорството';

  @override
  String get mgrEndContractEnd => 'Изтече договорът';

  @override
  String get mgrEndReplacedByPlayer => 'Заменен от теб';

  @override
  String get mgrProfileSpells => 'Кариера';

  @override
  String mgrProfileSpellNow(String nation, String from) {
    return '$nation, от $from';
  }

  @override
  String mgrProfileSpellRange(String nation, String from, String to) {
    return '$nation, от $from до $to';
  }

  @override
  String mgrProfileSpellEnded(String range, String reason) {
    return '$range, $reason';
  }

  @override
  String get mgrProfileRecordVsYou => 'Неговият баланс срещу теб';

  @override
  String get mgrProfileNoMeetings => 'Още не сте се срещали';

  @override
  String get mgrProfileReputation => 'Репутация';

  @override
  String get mgrProfileAge => 'Възраст';

  @override
  String get mgrProfileAppointed => 'Назначен';

  @override
  String get mgrProfileStyle => 'Стил';

  @override
  String get mgrProfileTie => 'Между вас';

  @override
  String mgrPreviewLine(String name) {
    return 'Техният селекционер: $name';
  }

  @override
  String mgrDossierStyle(String style) {
    return 'Стил на селекционера: $style';
  }

  @override
  String mgrDossierRecord(String record) {
    return 'Твоят баланс срещу него: $record';
  }

  @override
  String get mgrStylePossession => 'Притежание';

  @override
  String get mgrStyleHighPress => 'Висок пресинг';

  @override
  String get mgrStyleDefensive => 'Защитен';

  @override
  String get mgrStyleDirect => 'Директен';

  @override
  String get mgrStyleCounter => 'Контраатака';

  @override
  String get mgrStyleFlair => 'Техничен';

  @override
  String get mgrStylePhysical => 'Физически';

  @override
  String get mgrStyleBalanced => 'Балансиран';

  @override
  String get mgrListTitle => 'Селекционери';

  @override
  String get mgrListCurrent => 'Текущи';

  @override
  String get mgrListRecentMoves => 'Последни промени';

  @override
  String get mgrListFilterAll => 'Всички';

  @override
  String get mgrListSortReputation => 'Репутация';

  @override
  String get mgrListSortName => 'Име';

  @override
  String get mgrListEmptyMoves => 'Няма промени през последните две години.';

  @override
  String get mgrListEmptyCurrent =>
      'Селекционерите се появяват след прехода към следващия сезон.';

  @override
  String get editorSectionManagers => 'Селекционери';

  @override
  String get editorAboutManagers =>
      'Кой води всеки национален отбор в първия ден';

  @override
  String get editorManagersHint => 'Избира се в началото на кариерата';

  @override
  String get editorManagerName => 'Име на селекционера';

  @override
  String get editorManagerNationality => 'Националност';

  @override
  String editorIssueManagerName(int max) {
    return 'Името на селекционера трябва да е от 1 до $max показуеми знака';
  }

  @override
  String get editorIssueManagerNationality =>
      'Избери националност за селекционера от списъка';

  @override
  String get shareButton => 'Сподели';

  @override
  String get shareSheetTitle => 'Сподели като изображение';

  @override
  String get shareFormatSquare => 'Квадрат';

  @override
  String get shareFormatStory => 'История';

  @override
  String get shareFailed => 'Изображението не можа да бъде създадено.';

  @override
  String get shareSaveToPhotos => 'Запази в снимки';

  @override
  String get shareSavedToPhotos => 'Запазено в снимки';

  @override
  String get sharePhotosDenied =>
      'FNM няма разрешение да добавя към снимките ти. Можеш да го разрешиш в Настройки.';

  @override
  String get editorCountryAll => 'Всички държави';

  @override
  String get editorCountryFilterTitle => 'Филтър по държава';

  @override
  String get shareCabinetBig => 'Сподели трофеите ми';

  @override
  String yExitProud0(String competition) {
    return 'Неочаквано представяне на турнира $competition и чудесен резултат в крайна сметка. Горд съм с момчетата.';
  }

  @override
  String yExitProud1(String competition) {
    return 'Никой не ни даваше шанс на турнира $competition. Стигнахме по-далеч, отколкото някой смееше да мечтае. Благодарим, момчета.';
  }

  @override
  String yExitProud2(String competition) {
    return 'Отпаднахме от турнира $competition, но какво пътешествие. Този отбор накара цялата страна да повярва. Гордост.';
  }

  @override
  String yExitProud3(String competition) {
    return 'Не очаквах да излезем от групата на турнира $competition. Всичко след това беше бонус. Само напред и нагоре.';
  }

  @override
  String yExitProud4(String competition) {
    return 'Отидохме на турнира $competition с надежда за точка-две и се върнахме след елиминациите. Добър турнир.';
  }

  @override
  String yExitProud5(String competition) {
    return 'По-далеч, отколкото сочеха прогнозите на турнира $competition. Това е крачка напред, просто и ясно.';
  }

  @override
  String yExitProud6(String competition) {
    return 'Отпаднахме от турнира $competition и малко боли. Но честно казано: никой не ни виждаше толкова напред.';
  }

  @override
  String yExitProud7(String competition) {
    return 'Добре, отпаднахме от турнира $competition. Пак е повече, отколкото постигнахме от години. Приемам.';
  }

  @override
  String yExitProud8(String competition) {
    return 'Без трофей от турнира $competition, и никога нямаше да има. Хубавото представяне си е хубаво представяне. Сега го повторете.';
  }

  @override
  String get yReactionPride0 => 'Горд съм с всеки един от тях.';

  @override
  String get yReactionPride1 => 'Какво представяне. Благодарим, момчета.';

  @override
  String get yReactionPride2 => 'Никой не очакваше това. Запомнете го.';

  @override
  String get yReactionPride3 => 'Само напред и нагоре.';

  @override
  String get yReactionPride4 => 'Всичко е бонус. Наслаждавайте се.';

  @override
  String get yReactionPride5 =>
      'По-добре, отколкото някой прогнозираше. Добър турнир.';

  @override
  String get yReactionPride6 => 'Отпаднахме, но без срам. Честно.';

  @override
  String get yReactionPride7 =>
      'Продължи по-добрият отбор. Ние пак се представихме достойно.';

  @override
  String get yReactionPride8 => 'Да не се увличаме. Но да, добро представяне.';

  @override
  String yExitAccepted0(String competition) {
    return 'Отпаднахме от турнира $competition, горе-долу където се очакваше. Горд съм, че опитаха.';
  }

  @override
  String yExitAccepted1(String competition) {
    return 'Турнирът $competition приключи за нас. Затруднихме големите. Глави горе, момчета.';
  }

  @override
  String yExitAccepted2(String competition) {
    return 'Отпаднахме от турнира $competition. На хартия това винаги беше вероятният край. Учим се и продължаваме.';
  }

  @override
  String yExitAccepted3(String competition) {
    return 'Нашият турнир $competition свършва там, където показваше класацията. Няма срам в това.';
  }

  @override
  String yExitAccepted4(String competition) {
    return 'Отпаднахме от турнира $competition, както повечето от нас очакваха. Не е катастрофа, но не е и шок.';
  }

  @override
  String yExitAccepted5(String competition) {
    return 'Турнирът $competition се оказа твърде висока летва за този състав. Разликата е реална. Време е да я стопим.';
  }

  @override
  String get yReactionAcceptance0 =>
      'Дадоха всичко. Повече не може да се иска.';

  @override
  String get yReactionAcceptance1 => 'Глави горе. Ще се върнем.';

  @override
  String get yReactionAcceptance2 => 'Боли, но не ни посрамиха.';

  @override
  String get yReactionAcceptance3 =>
      'Горе-долу каквото очаквахме, честно казано.';

  @override
  String get yReactionAcceptance4 => 'Продължиха по-добрите. Такъв е футболът.';

  @override
  String get yReactionAcceptance5 => 'Разочарован, не ядосан.';

  @override
  String get yReactionAcceptance6 =>
      'Малко безлично, честно казано. Но без шокове.';

  @override
  String get yReactionAcceptance7 => 'Още не сме там. Всички го знаят.';

  @override
  String get yReactionAcceptance8 =>
      'Същото ниво като миналия път. Следващия цикъл трябва крачка нагоре.';

  @override
  String get sponsorIndustryExtraSportswear => 'Спортно облекло';

  @override
  String get sponsorIndustryExtraAirline => 'Авиокомпания с пълно обслужване';

  @override
  String get sponsorIndustryExtraRailway => 'Железници';

  @override
  String get sponsorIndustryExtraHotels => 'Хотелска верига';

  @override
  String get sponsorIndustryExtraCoffee => 'Верига кафенета';

  @override
  String get sponsorIndustryExtraChocolate => 'Шоколад';

  @override
  String get sponsorIndustryExtraMineralWater => 'Минерална вода';

  @override
  String get sponsorIndustryExtraPharmacy => 'Верига аптеки';

  @override
  String get sponsorIndustryExtraFashion => 'Мода';

  @override
  String get sponsorIndustryExtraWatches => 'Часовникар';

  @override
  String get sponsorIndustryExtraElectronics => 'Електроника';

  @override
  String get sponsorIndustryExtraSoftware => 'Софтуер';

  @override
  String get sponsorIndustryExtraStreaming => 'Стрийминг услуга';

  @override
  String get sponsorIndustryExtraSocialNetwork => 'Социална мрежа';

  @override
  String get sponsorIndustryExtraFurniture => 'Мебели';

  @override
  String get sponsorIndustryExtraTyres => 'Гуми';

  @override
  String get sponsorIndustryExtraShipping => 'Корабоплаване';

  @override
  String get sponsorIndustryExtraLottery => 'Лотария';

  @override
  String get sponsorIndustryExtraTourism => 'Туристически борд';

  @override
  String get sponsorIndustryExtraCosmetics => 'Козметика';

  @override
  String get sponsorIndustryExtraPetFood => 'Храна за домашни любимци';

  @override
  String get sponsorIndustryExtraBakery => 'Пекарна';

  @override
  String get sponsorIndustryExtraSupermarket => 'Супермаркет';

  @override
  String get sponsorIndustryExtraSportsNutrition => 'Спортно хранене';

  @override
  String get sponsorIndustryExtraWine => 'Вино';

  @override
  String get sponsorIndustryExtraTea => 'Чай';

  @override
  String get sponsorIndustryExtraRealEstate => 'Недвижими имоти';

  @override
  String get sponsorIndustryExtraFitness => 'Фитнес клубове';

  @override
  String get sponsorIndustryExtraNewspaper => 'Вестник';

  @override
  String mgrDetailCurrentJob(String nation) {
    return 'Настоящ пост: $nation';
  }

  @override
  String get mgrDetailFree => 'Без работа';

  @override
  String get mgrDetailMatches => 'Мачове';

  @override
  String get mgrDetailTrophies => 'Трофеи';

  @override
  String get mgrDetailWinRate => 'Процент победи';

  @override
  String get mgrDetailRecord => 'Баланс';

  @override
  String get mgrDetailNationsLed => 'Водени национални отбори';

  @override
  String get mgrDetailInCharge => 'На поста';

  @override
  String get mgrDetailNoSpells => 'Все още не е водил национален отбор.';

  @override
  String get mgrDetailNotFound => 'Селекционерът не е намерен.';

  @override
  String get mgrDetailBackground => 'Минало';

  @override
  String get mgrOriginFresh => 'Професионален треньор';

  @override
  String get mgrOriginExAssistant => 'Бивш помощник-треньор';

  @override
  String mgrNewsSeeManager(String name) {
    return 'Профил: $name';
  }

  @override
  String get mgrChangesTitle => 'Треньорски промени';

  @override
  String mgrChangesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count промени',
      one: '1 промяна',
    );
    return '$_temp0';
  }

  @override
  String mgrChangesLeftFor(String nation) {
    return 'Нов пост: $nation';
  }

  @override
  String get mgrChangesAppointed => 'Назначен';

  @override
  String get mgrChangesVacant => 'Вакантно';

  @override
  String get editorNameNotAllowed => 'Това име не е позволено.';

  @override
  String editorIssueNameNotAllowed(String name) {
    return '„$name“ не е позволено';
  }

  @override
  String get matchWeatherPlaysHeavyRain =>
      'Силен дъжд: ударите и центриранията са по-неточни, повече подхлъзвания';

  @override
  String get matchWeatherPlaysStorm =>
      'Гръмотевична буря: ударите и центриранията са по-неточни, повече подхлъзвания';

  @override
  String get matchWeatherPlaysSnow =>
      'Сняг: по-бавна игра, подаванията са малко по-трудни';

  @override
  String get matchWeatherPlaysFrost =>
      'Замръзнал терен: по-бавна игра, подаванията са малко по-трудни';

  @override
  String get matchWeatherPlaysGale =>
      'Силен вятър: дългите топки и центриранията са непредвидими, ударите отдалеч по-трудни';

  @override
  String get matchWeatherPlaysFog => 'Мъгла: ударите отдалеч са по-трудни';

  @override
  String get matchWeatherPlaysHaze =>
      'Знойна мараня: по-горещо от обикновено, краката ще отмалеят по-рано';

  @override
  String get pitchComKickOffHeavyRain =>
      'Започваме под силен дъжд. Топката ще се плъзга по този терен.';

  @override
  String get pitchComKickOffStorm =>
      'Начален удар в гръмотевична буря. Теренът ще бъде коварен.';

  @override
  String get pitchComKickOffSnow =>
      'Започваме в снега. Ще бъде бавен и предпазлив мач.';

  @override
  String get pitchComKickOffFrost =>
      'Мразовита вечер и твърд терен. Подаванията няма да са лесни.';

  @override
  String get pitchComKickOffGale =>
      'Начален удар при силен вятър. Дългите топки ще се отклоняват.';

  @override
  String get pitchComKickOffFog =>
      'Начален удар в гъста мъгла. Никой няма да вкарва лесно отдалеч.';

  @override
  String get pitchComKickOffHaze =>
      'Начален удар в знойната мараня. Краката ще се уморят рано днес.';

  @override
  String get matchOwnGoal => 'АВТОГОЛ';

  @override
  String get matchGoalOwnGoal => 'АГ';

  @override
  String pitchComOwnGoal1(String defender) {
    return 'Автогол! $defender вкарва топката в собствената си врата.';
  }

  @override
  String pitchComOwnGoal2(String defender, String shooter) {
    return 'Опитът на $shooter рикошира нещастно в $defender и влиза.';
  }

  @override
  String pitchComOwnGoal3(String defender) {
    return 'Катастрофа за $defender, който преодолява собствения си вратар.';
  }

  @override
  String pitchComBigSave1(String keeper, String player) {
    return 'Какво спасяване! $keeper отказва $player от близко разстояние.';
  }

  @override
  String pitchComBigSave2(String keeper) {
    return 'Блестящо спасяване на $keeper!';
  }

  @override
  String pitchComBigSave3(String keeper, String player) {
    return '$player изглеждаше сигурен, че ще вкара, но $keeper някак спасява.';
  }

  @override
  String matchTimelineWoodwork(String name) {
    return '$name уцели гредата';
  }

  @override
  String matchTimelineBigSave(String name) {
    return 'Голямо спасяване на $name';
  }

  @override
  String get matchChartXg => 'xG по време на мача';

  @override
  String get matchChartMomentum => 'Кой надделяваше';

  @override
  String get editorDemoteTooltip => 'Премести в пула';

  @override
  String editorDemoted(String name) {
    return '$name е преместен в пула';
  }

  @override
  String get profileTabOverview => 'Общо';

  @override
  String get profileTabStats => 'Статистика';

  @override
  String get profileTabCareer => 'Кариера';

  @override
  String get profileTabVsYou => 'Срещу теб';

  @override
  String get playerStatFitness => 'Физическа форма';

  @override
  String get settingsAboutProtected =>
      'Играта, нейният код и съдържание са защитени от авторско право.';

  @override
  String get matchTabPlayer => 'ИГРАЧ';

  @override
  String get matchTabStadium => 'СТАДИОН';

  @override
  String get matchPotmNone => 'В този мач не беше избран играч на мача.';

  @override
  String get matchPotmHisMatch => 'Неговият мач';

  @override
  String get matchPotmBeforeMatch => 'Преди този мач';

  @override
  String get matchStatMinutes => 'Минути';

  @override
  String get matchStatSaves => 'Спасявания';

  @override
  String get matchStatOnTarget => 'Във вратата';

  @override
  String get matchStadiumCapacity => 'Капацитет';

  @override
  String get matchStadiumAttendance => 'Посещаемост';

  @override
  String get matchStadiumFull => 'Запълване';

  @override
  String matchStadiumHomeOf(String nation) {
    return 'Домакински стадион: $nation';
  }

  @override
  String get matchStadiumNeutral => 'Неутрален терен';

  @override
  String get matchStadiumBuilt => 'Построен от твоята федерация';

  @override
  String get matchStadiumEnlarged => 'Разширен от твоята федерация';

  @override
  String get matchStadiumWorks => 'На стадиона текат ремонтни работи';

  @override
  String get matchStadiumConditions => 'Условия';

  @override
  String editorWebTitle(String address) {
    return 'Редактирайте на компютър: $address';
  }

  @override
  String get editorWebAbout =>
      'Експортирайте базата си данни, отворете я в браузъра, изтеглете я обратно и я импортирайте тук.';

  @override
  String get editorWebAnother => 'Друга възможност';

  @override
  String get editorMerge => 'Слей друга база данни';

  @override
  String get editorMergeAbout =>
      'Вземи промените, които някой друг е направил в своето копие.';

  @override
  String get editorHistory => 'История';

  @override
  String get editorHistoryAbout =>
      'Запазени версии на тази база данни. Върни се към всяка от тях.';

  @override
  String get editorMergeFromTitle => 'Слей от';

  @override
  String get editorMergeFromFile => 'Файл с база данни';

  @override
  String get editorMergeFromFileAbout =>
      'Избери .fnmdb файл, който някой е споделил с теб.';

  @override
  String get editorMergeFromDevice => 'На това устройство';

  @override
  String get editorMergeComparing => 'Базите данни се сравняват';

  @override
  String get editorMergeNothing =>
      'Няма какво да се слее. Твоята база данни вече има всички промени от другата.';

  @override
  String get editorMergeFailed => 'Базите данни не можаха да се слеят.';

  @override
  String editorMergeReviewTitle(String name) {
    return 'Промени от $name';
  }

  @override
  String editorMergeFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count промени за преглед',
      one: '1 промяна за преглед',
    );
    return '$_temp0';
  }

  @override
  String editorMergeConflicts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count конфликта',
      one: '1 конфликт',
      zero: 'Без конфликти',
    );
    return '$_temp0';
  }

  @override
  String get editorMergeConflictsOnly => 'Само конфликти';

  @override
  String get editorMergeNoConflicts =>
      'Няма конфликти. Всяка промяна е нова за твоята база данни.';

  @override
  String get editorMergeAll => 'Всички';

  @override
  String get editorMergeNone => 'Нито една';

  @override
  String editorMergeTake(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Вземи $count промени',
      one: 'Вземи 1 промяна',
      zero: 'Без взети промени',
    );
    return '$_temp0';
  }

  @override
  String get editorMergeApply => 'Приложи';

  @override
  String get editorMergeYours => 'Твоето';

  @override
  String get editorMergeTheirs => 'Тяхното';

  @override
  String get editorMergeNew => 'Ново';

  @override
  String get editorMergeConflict => 'Конфликт';

  @override
  String get editorMergeGameValue => 'Като в играта';

  @override
  String get editorMergeNotHere => 'Няма в тази база данни';

  @override
  String editorMergeSquadOf(String nation) {
    return 'Състав на $nation';
  }

  @override
  String editorMergePoolOf(String nation) {
    return 'Пул на $nation';
  }

  @override
  String get editorMergePlace => 'Прехвърляне';

  @override
  String editorMergeNames(int first, int sur) {
    return '$first собствени имена, $sur фамилии';
  }

  @override
  String editorMerged(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count промени слети',
      one: '1 промяна слята',
    );
    return '$_temp0';
  }

  @override
  String get editorHistorySave => 'Запази версия';

  @override
  String get editorHistorySaveTitle => 'Запази тази версия';

  @override
  String get editorHistoryNameHint => 'Име (по избор)';

  @override
  String get editorHistorySaved => 'Версията е запазена';

  @override
  String get editorHistoryEmpty =>
      'Още няма запазени версии. Една се запазва преди всяко сливане и възстановяване, както и когато се върнеш към тази база данни след пауза.';

  @override
  String get editorHistoryKeep =>
      'Пазят се последните 30 автоматични версии. Версиите, които запазваш сам, остават, докато не ги изтриеш.';

  @override
  String get editorHistorySession => 'Начало на редактирането';

  @override
  String editorHistoryBeforeMerge(String name) {
    return 'Преди сливането на $name';
  }

  @override
  String get editorHistoryBeforeRestore => 'Преди възстановяване';

  @override
  String get editorHistoryManual => 'Запазена версия';

  @override
  String get editorHistoryAuto => 'Автоматична';

  @override
  String editorHistoryDiff(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count разлики спрямо сега',
      one: '1 разлика спрямо сега',
      zero: 'Същата като сега',
    );
    return '$_temp0';
  }

  @override
  String get editorHistoryRestore => 'Възстанови';

  @override
  String get editorHistoryRestoreTitle => 'Да се възстанови ли тази версия?';

  @override
  String get editorHistoryRestoreBody =>
      'Базата данни се връща към тази версия. Сегашното ѝ състояние първо се запазва в историята.';

  @override
  String get editorHistoryRestored => 'Версията е възстановена';

  @override
  String get editorHistoryFailed => 'Не се получи. Опитай отново.';

  @override
  String get editorHistoryRenameTitle => 'Преименувай версията';

  @override
  String get editorHistoryDeleteTitle => 'Да се изтрие ли тази версия?';

  @override
  String get editorHistoryDeleteBody =>
      'Тя се премахва от историята. Самата база данни не се променя.';
}
