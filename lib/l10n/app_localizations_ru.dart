// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get matchPreviewTitle => 'ПРЕВЬЮ МАТЧА';

  @override
  String get matchKickOff => 'Начать матч';

  @override
  String get matchTactics => 'Тактика';

  @override
  String get matchYourXi => 'ТВОЙ СОСТАВ';

  @override
  String get matchHeadToHead => 'ЛИЧНЫЕ ВСТРЕЧИ';

  @override
  String matchCouldNotLoad(String error) {
    return 'Не удалось загрузить матч.\n$error';
  }

  @override
  String get matchNoUpcoming => 'Ближайшего матча нет.';

  @override
  String get matchUnknownNation => 'Неизвестно';

  @override
  String get matchH2hFirstMeeting => 'Первая встреча в истории';

  @override
  String get matchH2hYouLead => 'Ты впереди по личным встречам';

  @override
  String matchH2hOppEdge(String opponent) {
    return 'Преимущество у соперника: $opponent';
  }

  @override
  String get matchH2hEven => 'Паритет';

  @override
  String matchH2hMet(int count) {
    return 'Встреч: $count';
  }

  @override
  String get matchH2hWon => 'Победы';

  @override
  String get matchH2hDrawn => 'Ничьи';

  @override
  String get matchH2hLost => 'Поражения';

  @override
  String get matchDossierTitle => 'Скаутский отчёт';

  @override
  String get matchDossierForm => 'ФОРМА';

  @override
  String get matchDossierNoGames => 'Нет недавних матчей';

  @override
  String get matchDossierKeyMen => 'КЛЮЧЕВЫЕ ИГРОКИ';

  @override
  String get matchDossierHowTheyPlay => 'КАК ОНИ ИГРАЮТ';

  @override
  String matchScoutFormation1(String formation) {
    return 'Обычно они выходят по схеме $formation.';
  }

  @override
  String matchScoutFormation2(String formation) {
    return 'Их привычная схема: $formation.';
  }

  @override
  String matchScoutFormation3(String formation) {
    return 'Как правило, они строятся по схеме $formation.';
  }

  @override
  String get matchScoutStrengthPressing =>
      'Они высоко прессингуют и охотятся за мячом.';

  @override
  String get matchScoutStrengthDirect =>
      'Они играют прямолинейно и рано отправляют мяч вперёд.';

  @override
  String get matchScoutStrengthPossession =>
      'Они хорошо держат мяч и терпеливо строят атаки.';

  @override
  String get matchScoutStrengthCounter =>
      'Они отходят назад и быстро бьют на контратаках.';

  @override
  String get matchScoutStrengthDeepDefence =>
      'Они обороняются глубоко, и их трудно вскрыть.';

  @override
  String get matchScoutStrengthWide =>
      'Они растягивают поле и атакуют по флангам.';

  @override
  String get matchScoutStrengthAttacking =>
      'Они любят навязывать сопернику свою игру.';

  @override
  String get matchScoutStrengthQuickForwards =>
      'Их нападающие быстры и любят забегания за спину.';

  @override
  String get matchScoutStrengthPassingMidfield =>
      'Их полузащита хорошо распасовывает.';

  @override
  String get matchScoutStrengthHardRunning =>
      'Их полузащитники готовы бегать весь матч.';

  @override
  String get matchScoutStrengthSetPieces => 'Они опасны на стандартах.';

  @override
  String get matchScoutStrengthQuickDefence =>
      'Их линия обороны быстрая, за спину не забежишь.';

  @override
  String get matchScoutStrengthNone =>
      'Ничего особенного в их игре не выделяется.';

  @override
  String get matchScoutWeakSpaceBehind =>
      'Их высокая линия оставляет место за спиной для паса верхом.';

  @override
  String get matchScoutWeakPressedBuildUp =>
      'Высокий прессинг может сбить их медленное построение атак.';

  @override
  String get matchScoutWeakDeepBlock =>
      'Наберись терпения: такой глубокий блок можно разобрать.';

  @override
  String get matchScoutWeakLongBall =>
      'Опусти линию обороны, и их длинным передачам некуда будет лететь.';

  @override
  String get matchScoutWeakSlowDefence =>
      'Их защитникам не хватает скорости, так что отправляй игроков им за спину.';

  @override
  String get matchScoutWeakAerial => 'Они неуверенно защищаются на стандартах.';

  @override
  String get matchScoutWeakPoorPassing =>
      'Их полузащите трудно выбраться из-под прессинга пасом.';

  @override
  String get matchScoutWeakTiringMidfield =>
      'Их полузащитникам не хватает сил держать прессинг.';

  @override
  String get matchScoutWeakBluntAttack => 'Их нападающим не хватает скорости.';

  @override
  String get matchScoutApproachTakeTheGame =>
      'Против тебя они, скорее всего, возьмут инициативу.';

  @override
  String get matchScoutApproachEven =>
      'Против тебя ожидай плотной, равной борьбы.';

  @override
  String get matchScoutApproachSitDeep =>
      'Против тебя они, скорее всего, будут осторожны и сыграют на контратаках.';

  @override
  String get matchScoutLeaningAttacking =>
      'Издалека они похожи на атакующую команду.';

  @override
  String get matchScoutLeaningCautious =>
      'Издалека они похожи на осторожную команду.';

  @override
  String get matchScoutLeaningUnclear =>
      'Издалека трудно сказать, как они любят играть.';

  @override
  String get matchScoutHireHint =>
      'Найми главного скаута, чтобы узнать, как они играют.';

  @override
  String matchCouldNotContinue(String error) {
    return 'Не удалось продолжить: $error';
  }

  @override
  String get matchSkipToFullTime => 'К финальному свистку';

  @override
  String get matchStatShots => 'Удары';

  @override
  String get matchStatGoals => 'Голы';

  @override
  String get matchStatYellowCards => 'Жёлтые';

  @override
  String get matchStatRedCards => 'Красные';

  @override
  String get matchMomentum => 'ИНИЦИАТИВА';

  @override
  String get matchSwingAtk => 'АТК';

  @override
  String get matchSwingDef => 'ЗАЩ';

  @override
  String ceremonyWorldCupYear(int year) {
    return 'ЧЕМПИОНАТ МИРА $year';
  }

  @override
  String get ceremonyFinalsAreHere => 'ФИНАЛЬНЫЙ ТУРНИР НАЧИНАЕТСЯ';

  @override
  String ceremonyHostedBy(String hosts) {
    return 'ХОЗЯЕВА:  $hosts';
  }

  @override
  String get ceremonyHostTbc => 'ХОЗЯИН ЕЩЁ НЕ ОПРЕДЕЛЁН';

  @override
  String get matchHalfTime => 'ПЕРЕРЫВ';

  @override
  String matchHalfTimeScore(int home, int away) {
    return 'Первый тайм $home : $away';
  }

  @override
  String resultAggregate(int home, int away) {
    return 'сумма $home-$away';
  }

  @override
  String get matchContinue => 'Продолжить';

  @override
  String get matchContinuing => 'Продолжаем…';

  @override
  String matchTacticsWithSubs(int used, int max) {
    return 'Тактика · замены $used/$max';
  }

  @override
  String matchTiredCount(int count) {
    return 'УСТАЛИ ×$count';
  }

  @override
  String get matchTacticsLabel => 'ТАКТИКА';

  @override
  String get teamOverallOverTime => 'РЕЙТИНГ ПО ВРЕМЕНИ';

  @override
  String get teamOverall => 'Рейтинг';

  @override
  String get teamTalkHeading => 'УСТАНОВКА';

  @override
  String get teamTalkPrompt => 'Задай тон второму тайму.';

  @override
  String get teamTalkCalmLabel => 'Холодная голова';

  @override
  String get teamTalkCalmBlurb => 'Успокой команду. Небольшой прирост во всём.';

  @override
  String get teamTalkEncourageLabel => 'Подбодрить';

  @override
  String get teamTalkEncourageBlurb => 'Вперёд, играем на победу.';

  @override
  String get teamTalkDemandMoreLabel => 'Требовать большего';

  @override
  String get teamTalkDemandMoreBlurb => 'Бросить всё в атаку. Атакуем мощно.';

  @override
  String get teamTalkPraiseLabel => 'Играть плотно';

  @override
  String get teamTalkPraiseBlurb =>
      'Держать компактность и сберечь то, что есть.';

  @override
  String get teamTalkBelieveLabel => 'Верить';

  @override
  String get teamTalkBelieveBlurb =>
      'Верьте в себя. Прирост и в атаке, и в обороне.';

  @override
  String get teamTalkFocusLabel => 'Не расслабляться';

  @override
  String get teamTalkFocusBlurb => 'Полная концентрация. Закрыть игру.';

  @override
  String get teamTalkUrgencyLabel => 'Время поджимает';

  @override
  String get teamTalkUrgencyBlurb =>
      'Давить прямо сейчас. Всё на кон, но сзади будут дыры.';

  @override
  String get teamTalkReassureLabel => 'Без давления';

  @override
  String get teamTalkReassureBlurb => 'Унять нервы и сохранить построение.';

  @override
  String get commonRetry => 'Повторить';

  @override
  String get commonSomethingWentWrong => 'Что-то пошло не так';

  @override
  String get commonCrashBox =>
      'Здесь что-то пошло не так.\nПодробности: Настройки → Диагностика.';

  @override
  String get hubSimulatingMatchday => 'Симуляция игрового дня…';

  @override
  String hubCouldNotAdvance(String error) {
    return 'Не удалось продвинуть мир: $error';
  }

  @override
  String get settingsDiagnosticsTitle => 'Диагностика';

  @override
  String get settingsDiagnosticsBlurb =>
      'Ошибки, записанные на этом устройстве. Ничего никуда не отправляется.';

  @override
  String get settingsContactTitle => 'Контакты';

  @override
  String get settingsContactCopied => 'Адрес скопирован.';

  @override
  String get settingsCommunityTitle => 'Сообщество';

  @override
  String get settingsDiscordSubtitle => 'Присоединяйся к сообществу';

  @override
  String get settingsLinkCopied => 'Ссылка скопирована.';

  @override
  String get diagnosticsEmpty => 'Ошибок не записано. Так и задумано.';

  @override
  String get diagnosticsCopy => 'Копировать';

  @override
  String get diagnosticsCopied => 'Журнал скопирован в буфер обмена.';

  @override
  String get diagnosticsClear => 'Очистить';

  @override
  String get navHub => 'Центр';

  @override
  String get navSquad => 'Состав';

  @override
  String get navStandings => 'Таблицы';

  @override
  String get navCareers => 'Моя карьера';

  @override
  String get settingsTitle => 'НАСТРОЙКИ';

  @override
  String get settingsSoundHapticsTitle => 'Звук и вибрация';

  @override
  String get settingsSoundHapticsBlurb =>
      'Вибрация и короткий сигнал при голе, начале и конце матча.';

  @override
  String get settingsMatchSoundTitle => 'Звук стадиона';

  @override
  String get settingsMatchSoundBlurb =>
      'Трибуны и свисток судьи во время матчей.';

  @override
  String get settingsMatchSoundVolume => 'Громкость';

  @override
  String get settingsLanguageTitle => 'Язык';

  @override
  String get settingsLanguageBlurb =>
      'Выбери язык приложения или используй язык устройства.';

  @override
  String get settingsLanguageSystem => 'Системный';

  @override
  String get settingsTextSizeTitle => 'Размер текста';

  @override
  String get settingsTextSizeBlurb => 'Увеличь текст, если его трудно читать.';

  @override
  String get settingsTextSizeNormal => 'Обычный';

  @override
  String get settingsTextSizeLarge => 'Крупный';

  @override
  String get settingsTextSizeLarger => 'Крупнее';

  @override
  String get matchPreviewAllMeetings => 'Все встречи';

  @override
  String get recordsMeetings => 'ВСТРЕЧИ';

  @override
  String get recordsLegends => 'ЛЕГЕНДЫ';

  @override
  String get recordsAllTimeXi => 'СИМВОЛИЧЕСКАЯ СБОРНАЯ';

  @override
  String get recordsHallOfFame => 'ЗАЛ СЛАВЫ';

  @override
  String get recordsAllTimeWorld => 'МИР ЗА ВСЮ ИСТОРИЮ';

  @override
  String get recordsAllTimeTopScorers => 'ЛУЧШИЕ БОМБАРДИРЫ В ИСТОРИИ';

  @override
  String get recordsMostCapped => 'БОЛЬШЕ ВСЕГО МАТЧЕЙ';

  @override
  String get recordsMostWcStarts => 'БОЛЬШЕ ВСЕГО СТАРТОВ НА ЧМ';

  @override
  String get recordsMostTournaments => 'БОЛЬШЕ ВСЕГО ТУРНИРОВ';

  @override
  String get recordsRecordBook => 'КНИГА РЕКОРДОВ';

  @override
  String get recordsHeadToHead => 'ЛИЧНЫЕ ВСТРЕЧИ';

  @override
  String get recordsFiercestRival => 'ГЛАВНЫЙ СОПЕРНИК';

  @override
  String get recordsMostCaps => 'БОЛЬШЕ ВСЕГО МАТЧЕЙ';

  @override
  String get recordsTopScorers => 'БОМБАРДИРЫ';

  @override
  String get recordsMostAssists => 'БОЛЬШЕ ВСЕГО ПЕРЕДАЧ';

  @override
  String get recordsYourRecord => 'ТВОЯ СТАТИСТИКА';

  @override
  String get callUpHome => 'ДОМА';

  @override
  String get callUpAway => 'В ГОСТЯХ';

  @override
  String get recordsHome => 'ДОМА';

  @override
  String get recordsAway => 'В ГОСТЯХ';

  @override
  String get recordsActive => 'ИГРАЕТ';

  @override
  String get recordsStillActive => 'Ещё играет';

  @override
  String get recordsAvg => 'ср.';

  @override
  String get recordsSelect => 'Выбрать';

  @override
  String get recordsVs => 'против';

  @override
  String get recordsDraws => 'Ничьи';

  @override
  String get recordsGoalsLabel => 'Голы';

  @override
  String get recordsBestFinish => 'Лучший результат';

  @override
  String get recordsNoFinalsYet => 'Ещё не было финальных турниров';

  @override
  String get recordsLongestUnbeaten => 'Самая долгая беспроигрышная серия';

  @override
  String get recordsBiggestWin => 'Крупнейшая победа';

  @override
  String get recordsTileMatches => 'Матчи';

  @override
  String get recordsTileWins => 'Победы';

  @override
  String get recordsTileTrophies => 'Трофеи';

  @override
  String recordsWinSharePercent(String pct) {
    return '$pct%';
  }

  @override
  String recordsTrophyLatest(String competition, String year) {
    return '$competition $year';
  }

  @override
  String get recordsNoTrophiesYet => 'Пока нет';

  @override
  String get recordsBiggestDefeat => 'Крупнейшее поражение';

  @override
  String get recordsRecordHolders => 'Рекордсмены';

  @override
  String get recordsMostCleanSheets => 'БОЛЬШЕ ВСЕГО «СУХИХ» МАТЧЕЙ';

  @override
  String get recordsSeeAllMeetings => 'Все встречи';

  @override
  String get recordsSaveNotFound => 'Сохранение не найдено.';

  @override
  String get recordsNoMatches => 'Матчей нет.';

  @override
  String get recordsSearchPlayerOrNation => 'Поиск игрока или сборной';

  @override
  String get recordsSearchNation => 'Поиск сборной';

  @override
  String get recordsPickTwoDifferent => 'Выбери две разные сборные.';

  @override
  String get recordsPlayToBuildRecord =>
      'Сыграй несколько матчей, и здесь появится твоя статистика против каждого соперника.';

  @override
  String get recordsTapOpponent =>
      'Нажми на соперника, чтобы увидеть подробности.';

  @override
  String get recordsEdgeUpperHand => 'Преимущество за тобой';

  @override
  String get recordsEdgeTheirNumber => 'Они знают, как тебя обыграть';

  @override
  String get recordsEdgeEven => 'Паритет';

  @override
  String get recordsAllTimeWorldSubtitle =>
      'Бомбардиры и рекордсмены по матчам всех сборных';

  @override
  String get recordsHeadToHeadSubtitle =>
      'Сравни историю встреч любых двух сборных';

  @override
  String get recordsLegendsSubtitle => 'Символическая сборная и зал славы';

  @override
  String get recordsUnitGoals => 'голы';

  @override
  String get recordsUnitCaps => 'матчи';

  @override
  String get recordsUnitStarts => 'в старте';

  @override
  String get recordsUnitCups => 'кубки';

  @override
  String get recordsUnitAssists => 'передачи';

  @override
  String recordsCapsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count матча',
      many: '$count матчей',
      few: '$count матча',
      one: '$count матч',
    );
    return '$_temp0';
  }

  @override
  String recordsGoalsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count гола',
      many: '$count голов',
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
      other: '$count передачи',
      many: '$count передач',
      few: '$count передачи',
      one: '$count передача',
    );
    return '$_temp0';
  }

  @override
  String recordsMotmCount(int count) {
    return 'Игрок матча: $count';
  }

  @override
  String recordsMatchesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count матча',
      many: '$count матчей',
      few: '$count матча',
      one: '$count матч',
    );
    return '$_temp0';
  }

  @override
  String recordsMeetingsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count встречи',
      many: '$count встреч',
      few: '$count встречи',
      one: '$count встреча',
    );
    return '$_temp0';
  }

  @override
  String recordsCodeWins(String code) {
    return 'Победы $code';
  }

  @override
  String recordsMeetingsWdl(int meetings, int wins, int draws, int losses) {
    String _temp0 = intl.Intl.pluralLogic(
      meetings,
      locale: localeName,
      other: '$meetings встречи',
      many: '$meetings встреч',
      few: '$meetings встречи',
      one: '$meetings встреча',
    );
    return '$_temp0 · $winsВ $drawsН $lossesП';
  }

  @override
  String recordsWdl(int wins, int draws, int losses) {
    return '$winsВ $drawsН $lossesП';
  }

  @override
  String recordsRivalLine(int meetings, String record, String edge) {
    String _temp0 = intl.Intl.pluralLogic(
      meetings,
      locale: localeName,
      other: '$meetings встречи',
      many: '$meetings встреч',
      few: '$meetings встречи',
      one: '$meetings встреча',
    );
    return '$_temp0 · $record · $edge';
  }

  @override
  String recordsNeverMet(String a, String b) {
    return '$a и $b ещё ни разу не встречались в этом сохранении.';
  }

  @override
  String tacticsSentOffNote(String names) {
    return 'Удалены: $names. Замены нет, играешь в меньшинстве.';
  }

  @override
  String tacticsNeedFitPlayers(int required, int have) {
    return 'Нужно $required доступных (здоровы: $have)';
  }

  @override
  String tacticsMissesOfCamp(int missed, int total) {
    return 'Пропустит $missed/$total';
  }

  @override
  String get tacticsOutForWholeCamp => 'Пропустит весь сбор';

  @override
  String get rankingCentreOnMe => 'Показать мою сборную';

  @override
  String get recordsAfterExtraTime => 'д. в.';

  @override
  String recordsOnPenalties(int a, int b) {
    return '$a–$b пен.';
  }

  @override
  String recordsVersus(String a, String b) {
    return '$a – $b';
  }

  @override
  String recordsPlayedScore(int played, int gf, int ga) {
    return 'Сыграно $played · $gf–$ga';
  }

  @override
  String recordsBiggestWinValue(int gf, int ga, String opp) {
    return '$gf–$ga против $opp';
  }

  @override
  String recordsCouldNotLoad(String error) {
    return 'Не удалось загрузить.\n$error';
  }

  @override
  String recordsCouldNotLoadLegends(String error) {
    return 'Не удалось загрузить легенд.\n$error';
  }

  @override
  String recordsCouldNotLoadRecords(String error) {
    return 'Не удалось загрузить рекорды.\n$error';
  }

  @override
  String recordsCouldNotLoadNations(String error) {
    return 'Не удалось загрузить сборные.\n$error';
  }

  @override
  String recordsCouldNotLoadYourRecord(String error) {
    return 'Не удалось загрузить твою статистику.\n$error';
  }

  @override
  String recordsCouldNotLoadRecord(String error) {
    return 'Не удалось загрузить статистику.\n$error';
  }

  @override
  String recordsNoLegends(String nation) {
    return 'Легенд пока нет. Проведи несколько кампаний, и здесь появятся великие игроки сборной: $nation.';
  }

  @override
  String recordsGreatestSide(String nation) {
    return 'Сильнейший состав в истории сборной: $nation.';
  }

  @override
  String get recordsAllTimeXiSubtitle => 'Символическая сборная';

  @override
  String get recordsNoWorldHistory =>
      'У мира ещё нет истории. Проведи несколько кампаний, и здесь появятся великие игроки всех времён.';

  @override
  String recordsPlayToWriteHistory(String nation) {
    return 'Сыграй несколько матчей, чтобы начать писать историю сборной: $nation.';
  }

  @override
  String get tacticsLineGk => 'ВР';

  @override
  String get tacticsLineDef => 'ЗАЩ';

  @override
  String get tacticsLineMid => 'ПЗ';

  @override
  String get tacticsLineFwd => 'НАП';

  @override
  String get tacticsGoalkeepers => 'ВРАТАРИ';

  @override
  String get tacticsDefenders => 'ЗАЩИТНИКИ';

  @override
  String get tacticsMidfielders => 'ПОЛУЗАЩИТНИКИ';

  @override
  String get tacticsForwards => 'НАПАДАЮЩИЕ';

  @override
  String get tacticsCallUpsTitle => 'ВЫЗОВЫ';

  @override
  String tacticsPickAtLeastPlayers(int min) {
    return 'Выбери не менее $min игроков.';
  }

  @override
  String tacticsCouldNotLoadSquad(String error) {
    return 'Не удалось загрузить состав.\n$error';
  }

  @override
  String get tacticsNoSquad => 'Состава нет.';

  @override
  String tacticsSquadCount(int count, int max) {
    return 'СОСТАВ · $count/$max';
  }

  @override
  String tacticsMinMax(int min, int max) {
    return 'Мин. $min · Макс. $max';
  }

  @override
  String get tacticsBestQuality => 'Сильнейшие';

  @override
  String get tacticsPreviousSquad => 'Прошлый состав';

  @override
  String get tacticsSquadLockedBack => 'Назад (состав утверждён)';

  @override
  String get tacticsConfirmSquad => 'Утвердить состав';

  @override
  String tacticsSquadFullMax(int max) {
    return 'Состав заполнен (макс. $max)';
  }

  @override
  String get tacticsSquadLocked => 'СОСТАВ УТВЕРЖДЁН';

  @override
  String get tacticsNominationOpen => 'ЗАЯВКА ОТКРЫТА. ВЫБЕРИ СОСТАВ';

  @override
  String get tacticsSquadFixedBlurb =>
      'Этот состав утверждён на матчи ниже. Выбери заново перед следующим окном заявки.';

  @override
  String get tacticsSquadWillPlayBlurb => 'Этот состав сыграет матчи ниже.';

  @override
  String get tacticsUnknown => 'Неизвестно';

  @override
  String tacticsAgeValue(int age, String value) {
    return 'Возраст $age · $value';
  }

  @override
  String get tacticsFatigueExhausted => 'Без сил';

  @override
  String get tacticsFatigueTired => 'Устал';

  @override
  String get tacticsFatigueMatchLegs => 'В тонусе';

  @override
  String tacticsTooManySubs(int max) {
    return 'Слишком много замен (макс. $max).';
  }

  @override
  String tacticsMinuteTitle(int minute) {
    return 'ТАКТИКА · $minute\'';
  }

  @override
  String get tacticsApply => 'ПРИМЕНИТЬ';

  @override
  String get tacticsTabLineupSubs => 'СОСТАВ И ЗАМЕНЫ';

  @override
  String get tacticsTabTactics => 'ТАКТИКА';

  @override
  String get squadLineKeepers => 'ВРАТАРИ';

  @override
  String get squadLineDefenders => 'ОБОРОНА';

  @override
  String get squadLineMidfielders => 'ПОЛУЗАЩИТА';

  @override
  String get squadLineForwards => 'АТАКА';

  @override
  String get squadStatXiRating => 'Рейтинг XI';

  @override
  String get squadStatAvgAge => 'Ср. возраст';

  @override
  String get squadStatSize => 'Состав';

  @override
  String get squadStatUnavailable => 'Вне игры';

  @override
  String get squadDepthTitle => 'ГЛУБИНА ПО ЛИНИЯМ';

  @override
  String squadAgeShort(int age) {
    return '$age л.';
  }

  @override
  String get tacticsTabOtherPositions => 'ДРУГИЕ МЕСТА';

  @override
  String get tacticsOutOfPositionNote => 'Здесь не на своей позиции';

  @override
  String get tacticsNobodyElse => 'Больше некого сюда попробовать.';

  @override
  String get tacticsPickSomebodyFirst =>
      'Выбери, кто уходит, и здесь появится остальная скамейка с тем, на каком уровне каждый сыграет на этом месте.';

  @override
  String get tacticsTabSuitable => 'ПОДХОДЯЩИЕ';

  @override
  String get tacticsTabOnPitch => 'НА ПОЛЕ';

  @override
  String tacticsSectionSuitable(int count) {
    return 'ПОДХОДЯЩИЕ · $count';
  }

  @override
  String get tacticsNobodySuits =>
      'Никто на скамейке не подходит для этого места, поэтому здесь все.';

  @override
  String tacticsSectionOnPitch(int count, int max) {
    return 'НА ПОЛЕ · $count/$max';
  }

  @override
  String tacticsSectionAvailable(int count) {
    return 'ДОСТУПНЫ · $count';
  }

  @override
  String get tacticsRowStarted => 'В старте';

  @override
  String tacticsRowCameOn(int minute) {
    return 'Вышел на $minute\'';
  }

  @override
  String get tacticsRowSubstitute => 'Вышел на замену';

  @override
  String get tacticsEnergyLabel => 'СИЛЫ';

  @override
  String tacticsPickReplacementFor(String name) {
    return 'Выбери замену для игрока $name или нажми на него ещё раз, чтобы отменить.';
  }

  @override
  String get tacticsSlotLostToRedCard =>
      'Красная карточка лишила тебя этого места. Перетащи сюда партнёра, чтобы сдвинуть дыру.';

  @override
  String get tacticsSentOffShort => 'УДАЛЁН';

  @override
  String get tacticsFullBackLeft => 'Левый защитник';

  @override
  String get tacticsFullBackRight => 'Правый защитник';

  @override
  String get tacticsFullBackUp => 'Подключаться';

  @override
  String get tacticsFullBackDown => 'Держаться сзади';

  @override
  String get tacticsFullBackOff => 'Без указаний';

  @override
  String tacticsFullBackSemantics(String side, String state) {
    return 'Стрелка $side: $state';
  }

  @override
  String tacticsSubsUsed(int used, int max) {
    return 'ЗАМЕНЫ · $used/$max';
  }

  @override
  String get tacticsNoSubs => 'Нет доступных запасных.';

  @override
  String get tacticsChooseShape => 'ВЫБЕРИ СХЕМУ';

  @override
  String get tacticsFormation => 'СХЕМА';

  @override
  String get tacticsInstructions => 'УСТАНОВКИ';

  @override
  String get tacticsDrilling => 'СЫГРАННОСТЬ';

  @override
  String get tacticsDrillingUnplayed => 'НЕ ИГРАЛИ';

  @override
  String get tacticsDrillingNew => 'НОВАЯ';

  @override
  String get tacticsDrillingSettling => 'ОСВАИВАЕТСЯ';

  @override
  String get tacticsDrillingDrilled => 'ОТРАБОТАНА';

  @override
  String get tacticsInstrMentality => 'Настрой';

  @override
  String get tacticsInstrDefensive => 'Оборона';

  @override
  String get tacticsInstrAttacking => 'Атака';

  @override
  String get tacticsInstrPressing => 'Прессинг';

  @override
  String get tacticsInstrLowBlock => 'Низкий блок';

  @override
  String get tacticsInstrHighPress => 'Высокий прессинг';

  @override
  String get tacticsInstrTempo => 'Темп';

  @override
  String get tacticsInstrPatient => 'Терпеливо';

  @override
  String get tacticsInstrFast => 'Быстро';

  @override
  String get tacticsInstrWidth => 'Ширина';

  @override
  String get tacticsInstrNarrow => 'Узко';

  @override
  String get tacticsInstrWide => 'Широко';

  @override
  String get tacticsInstrDefLine => 'Линия обор.';

  @override
  String get tacticsInstrDefensiveLine => 'Линия обороны';

  @override
  String get tacticsInstrDeep => 'Низко';

  @override
  String get tacticsInstrHigh => 'Высоко';

  @override
  String get tacticsInstrDirectness => 'Прямолинейность';

  @override
  String get tacticsInstrPossession => 'Владение';

  @override
  String get tacticsInstrDirect => 'Прямо';

  @override
  String get tacticsPickGoalkeeper => 'ВЫБЕРИ ВРАТАРЯ';

  @override
  String get tacticsPickLeftBack => 'ВЫБЕРИ ЛЕВОГО ЗАЩИТНИКА';

  @override
  String get tacticsPickCentreBack => 'ВЫБЕРИ ЦЕНТРАЛЬНОГО ЗАЩИТНИКА';

  @override
  String get tacticsPickRightBack => 'ВЫБЕРИ ПРАВОГО ЗАЩИТНИКА';

  @override
  String get tacticsPickDefensiveMid => 'ВЫБЕРИ ОПОРНОГО';

  @override
  String get tacticsPickCentralMid => 'ВЫБЕРИ ЦЕНТРАЛЬНОГО ПОЛУЗАЩИТНИКА';

  @override
  String get tacticsPickAttackingMid => 'ВЫБЕРИ АТАКУЮЩЕГО ПОЛУЗАЩИТНИКА';

  @override
  String get tacticsPickLeftMid => 'ВЫБЕРИ ЛЕВОГО ПОЛУЗАЩИТНИКА';

  @override
  String get tacticsPickRightMid => 'ВЫБЕРИ ПРАВОГО ПОЛУЗАЩИТНИКА';

  @override
  String get tacticsPickLeftWing => 'ВЫБЕРИ ЛЕВОГО ВИНГЕРА';

  @override
  String get tacticsPickRightWing => 'ВЫБЕРИ ПРАВОГО ВИНГЕРА';

  @override
  String get tacticsPickStriker => 'ВЫБЕРИ ФОРВАРДА';

  @override
  String tacticsRoleOutOfPosition(String role) {
    return '$role · не на своей позиции';
  }

  @override
  String tacticsAgeOnly(int age) {
    return 'Возраст $age';
  }

  @override
  String tacticsRoleAge(String role, int age) {
    return '$role · Возраст $age';
  }

  @override
  String get tacticsOn => 'ВЫХОД';

  @override
  String get tacticsSquad => 'СОСТАВ';

  @override
  String get tacticsTabLineup => 'СОСТАВ';

  @override
  String get tacticsTabInstructions => 'УСТАНОВКИ';

  @override
  String get tacticsTabRoles => 'РОЛИ';

  @override
  String get tacticsTabSetPieces => 'СТАНДАРТЫ';

  @override
  String get tacticsTooltipCallUps => 'Вызовы';

  @override
  String get tacticsTooltipPresets => 'Тактические заготовки';

  @override
  String get tacticsTooltipInstructions => 'Установки';

  @override
  String get tacticsNoTacticSet => 'Тактика не задана.';

  @override
  String tacticsReplaceStarters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ЗАМЕНИТЬ $count ИГРОКА СТАРТА',
      many: 'ЗАМЕНИТЬ $count ИГРОКОВ СТАРТА',
      few: 'ЗАМЕНИТЬ $count ИГРОКОВ СТАРТА',
      one: 'ЗАМЕНИТЬ $count ИГРОКА СТАРТА',
    );
    return '$_temp0';
  }

  @override
  String tacticsPlayerOut(String name, String reason) {
    return '$name: $reason';
  }

  @override
  String get tacticsOut => 'Вне игры';

  @override
  String get tacticsTapSpotReplace =>
      'Нажми на его место на поле, чтобы выбрать замену.';

  @override
  String get tacticsPlayerRoles => 'РОЛИ ИГРОКОВ';

  @override
  String get tacticsRolesBlurb =>
      'Дай игроку задачу: охотник за голами, плеймейкер, таргетмен. От этого зависит, кто забивает и кто создаёт.';

  @override
  String get tacticsSetPieceTakers => 'ИСПОЛНИТЕЛИ СТАНДАРТОВ';

  @override
  String get tacticsSetPieceBlurb =>
      'Кто бьёт пенальти и стандарты, или доверь это самому подходящему игроку.';

  @override
  String get tacticsTakerAuto => 'Автоматически';

  @override
  String get tacticsTakerQuickPick => 'Лучшие исполнители';

  @override
  String get tacticsPenalties => 'Пенальти';

  @override
  String get tacticsCornersFreeKicks => 'Угловые и штрафные';

  @override
  String get tacticsThrowIns => 'Ауты';

  @override
  String get tacticsThrowInStyle => 'Вбрасывание аута';

  @override
  String get tacticsThrowInLong => 'Длинные ауты';

  @override
  String get tacticsThrowInNeutral => 'Нейтрально';

  @override
  String get tacticsThrowInDefensive => 'Безопасные ауты';

  @override
  String get tacticsThrowInLongBlurb =>
      'Ауты у штрафной летят прямо в неё. Немного больше угрозы, особенно с сильным исполнителем и высокими нападающими, но мяч теряется чуть чаще.';

  @override
  String get tacticsThrowInNeutralBlurb =>
      'Ауты вбрасываются по ситуации. Ничего не меняется.';

  @override
  String get tacticsThrowInDefensiveBlurb =>
      'Каждый аут коротко и безопасно. Меньше потерь под контратаку и чуть меньше созданных моментов.';

  @override
  String get matchGoalLongThrow => 'ДЛИННЫЙ АУТ';

  @override
  String get tacticsSkillFin => 'ЗАВ';

  @override
  String get tacticsSkillPas => 'ПАС';

  @override
  String get roleFitGood => 'Подходит';

  @override
  String get roleFitFair => 'Сносно';

  @override
  String get roleFitPoor => 'Не подходит';

  @override
  String get arrowNone => 'Держать позицию';

  @override
  String get arrowForward => 'Идти вперёд';

  @override
  String get arrowBack => 'Играть глубже';

  @override
  String get arrowInside => 'Смещаться в центр';

  @override
  String get arrowOutside => 'Держать ширину';

  @override
  String get arrowForwardInside => 'Вперёд и в центр';

  @override
  String get arrowForwardOutside => 'Вперёд и по флангу';

  @override
  String get tacticsRunLegendRole => 'Естественный рывок роли';

  @override
  String get tacticsRunLegendManual => 'Твоё указание';

  @override
  String get tacticsSheetPost => 'Позиция';

  @override
  String get tacticsSheetAdvanced => 'Дополнительно';

  @override
  String get tacticsSheetAutoPick => 'Сейчас исполняет он, автоматически';

  @override
  String get tacticsSheetFresh => 'Свежий';

  @override
  String get tacticsSheetFitHere => 'На этой позиции';

  @override
  String tacticsSheetFitSemantics(int dots) {
    return 'Подходит для позиции: $dots из 5';
  }

  @override
  String get tacticsSheetSwap => 'Заменить';

  @override
  String get tacticsSheetProfile => 'Профиль';

  @override
  String get tacticsSheetRecommended => 'Рекомендуется';

  @override
  String get tacticsSheetRunHint =>
      'Нажми на направление, чтобы задать свою стрелку. Центр возвращает рывок роли.';

  @override
  String get tacticsPostDm => 'Играет перед линией обороны и прикрывает её.';

  @override
  String get tacticsPostCm =>
      'Связывает оборону и атаку, работает в обе стороны.';

  @override
  String get tacticsPostAm => 'Играет между линиями, за нападающими.';

  @override
  String get tacticsPostWideMid =>
      'Глубже и шире, помогает своему крайнему защитнику.';

  @override
  String get tacticsPostWinger => 'Выше, идёт в обыгрыш крайнего защитника.';

  @override
  String get tacticsPostSt => 'Ведёт атаку и реализует моменты.';

  @override
  String get tacticsPitchHint =>
      'Нажми на игрока, чтобы задать позицию, роль и рывок. Зажми и перетащи, чтобы переставить.';

  @override
  String get tacticsSubHint =>
      'Нажми на игрока, чтобы настроить или заменить его. Зажми и перетащи на него запасного.';

  @override
  String get tacticsLegendTooltip => 'Как читать поле';

  @override
  String get tacticsLegendRoleTag =>
      'Маленький значок на игроке обозначает его роль.';

  @override
  String get tacticsPlanRoleHeading => 'РОЛЬ';

  @override
  String get tacticsPlanMovementHeading => 'ДВИЖЕНИЕ';

  @override
  String get tacticsKeeperNoRun => 'Вратарю рывок не задаётся.';

  @override
  String get tacticsPenaltyTaker => 'ПЕНАЛЬТИСТ';

  @override
  String get tacticsCornerFreeKickTaker => 'УГЛОВЫЕ И ШТРАФНЫЕ';

  @override
  String get tacticsAutomatic => 'Автоматически';

  @override
  String get tacticsLetBestSuited => 'Пусть бьёт самый подходящий игрок.';

  @override
  String get tacticsInXi => 'В СТАРТЕ';

  @override
  String get tacticsTeamInstructions => 'КОМАНДНЫЕ УСТАНОВКИ';

  @override
  String get tacticsTeamInstructionsBlurb =>
      'Задай, как играет твоя команда. Каждый регулятор влияет на всю команду.';

  @override
  String tacticsSavedPreset(String name) {
    return 'Сохранено: «$name»';
  }

  @override
  String tacticsAppliedPreset(String name) {
    return 'Применено: «$name»';
  }

  @override
  String get tacticsTacticPresets => 'ТАКТИЧЕСКИЕ ЗАГОТОВКИ';

  @override
  String get tacticsPresetsBlurb =>
      'Сохрани эту схему как стиль на будущее или примени сохранённый ранее.';

  @override
  String get tacticsSaveCurrentTactic => 'Сохранить тактику';

  @override
  String tacticsCouldNotLoadPresets(String error) {
    return 'Не удалось загрузить заготовки.\n$error';
  }

  @override
  String get tacticsNoPresetsYet =>
      'Заготовок пока нет. Нажми «Сохранить тактику», чтобы запомнить эту схему как стиль.';

  @override
  String get tacticsNameThisTactic => 'Назови тактику';

  @override
  String get tacticsNameHint => 'напр. Высокий прессинг 4-3-3';

  @override
  String get tacticsCancel => 'Отмена';

  @override
  String get tacticsSave => 'Сохранить';

  @override
  String get tacticsHoldDragSub =>
      'Зажми запасного и перетащи на игрока, чтобы выпустить его.';

  @override
  String get hubContinue => 'Продолжить';

  @override
  String get hubBrackets => 'Сетка';

  @override
  String hubCouldNotLoad(String error) {
    return 'Не удалось загрузить.\n$error';
  }

  @override
  String hubCouldNotLoadFinances(String error) {
    return 'Не удалось загрузить финансы.\n$error';
  }

  @override
  String hubCouldNotLoadSave(String error) {
    return 'Не удалось загрузить сохранение.\n$error';
  }

  @override
  String get hubSaveNotFound => 'Сохранение не найдено.';

  @override
  String get hubUnknown => 'Неизвестно';

  @override
  String hubWorldChampionsYear(int year) {
    return 'ЧЕМПИОНЫ МИРА $year';
  }

  @override
  String get hubCycleComplete => 'Цикл завершён.';

  @override
  String hubReviewTitle(int from, int to) {
    return 'Итоги цикла $from–$to';
  }

  @override
  String get hubReviewEyebrow => 'Твои четыре года';

  @override
  String get hubReviewTournaments => 'Турниры';

  @override
  String get hubReviewPlayers => 'Игроки';

  @override
  String get hubReviewMostCaps => 'Больше всего матчей';

  @override
  String get hubReviewBestRated => 'Лучшая средняя оценка';

  @override
  String hubReviewDebutants(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count игрока дебютировали в сборной',
      many: '$count игроков дебютировали в сборной',
      few: '$count игрока дебютировали в сборной',
      one: '$count игрок дебютировал в сборной',
    );
    return '$_temp0';
  }

  @override
  String hubReviewRankMove(int from, int to) {
    return 'С #$from на #$to';
  }

  @override
  String hubReviewObjectives(int met, int total) {
    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: 'Выполнено задач руководства: $met из $total',
      many: 'Выполнено задач руководства: $met из $total',
      few: 'Выполнено задач руководства: $met из $total',
      one: 'Выполнено задач руководства: $met из $total',
    );
    return '$_temp0';
  }

  @override
  String get hubReviewNoMatches => 'В этом цикле матчей не было.';

  @override
  String get hubYourJob => 'ТВОЯ РАБОТА';

  @override
  String get hubStayProject => 'Остаться и продолжить проект';

  @override
  String get hubChooseNextJob => 'ВЫБЕРИ СЛЕДУЮЩУЮ РАБОТУ';

  @override
  String get hubOffersOnTable => 'ПРЕДЛОЖЕНИЯ НА СТОЛЕ';

  @override
  String hubOfferSubtitle(String tier, int position) {
    return '$tier · #$position в мире';
  }

  @override
  String hubContinueWith(String nation) {
    return 'Продолжить: $nation';
  }

  @override
  String get hubYourNation => 'твоя сборная';

  @override
  String get hubTakeTheJob => 'Принять предложение';

  @override
  String get hubFederationFinances => 'ФИНАНСЫ ФЕДЕРАЦИИ';

  @override
  String get hubBudgetIntro =>
      'Первым делом в следующем цикле нужно утвердить бюджет федерации и распределить его по отделам.';

  @override
  String get hubStarting => 'Запуск…';

  @override
  String get hubBeginNextCycle => 'Начать следующий цикл';

  @override
  String get hubContinueCareer => 'Продолжить карьеру';

  @override
  String get hubBackToSaves => 'К сохранениям';

  @override
  String get hubOpeningBalance => 'Начальный баланс';

  @override
  String get hubCentralFunding => 'Центральное финансирование';

  @override
  String get hubPrizeMoney => 'Призовые';

  @override
  String get hubCommercialReturn => 'Коммерческий доход';

  @override
  String get hubAvailableToInvest => 'Доступно для вложений';

  @override
  String hubReputation(String label, int rep) {
    return 'Репутация: $label ($rep)';
  }

  @override
  String get hubNationalHero => 'Национальный герой';

  @override
  String get hubFinal => 'Финал';

  @override
  String get hubStageRoundOf32 => '1/16 финала';

  @override
  String get hubStageThirdPlace => 'Матч за третье место';

  @override
  String get hubEventAdvanceWorld => 'Продвинуть мир';

  @override
  String hubEventStartCycle(int year) {
    return 'Начать цикл $year';
  }

  @override
  String hubEventWorldChampions(String nation) {
    return '$nation – чемпион мира';
  }

  @override
  String get hubEventSetBudget => 'Утверди бюджет федерации';

  @override
  String get hubEventSetBudgetSub =>
      'Распредели средства цикла до начала сезона';

  @override
  String get hubEventNaturalization => 'Рассмотри предложение о натурализации';

  @override
  String get hubEventNaturalizationSub =>
      'Иностранный игрок хочет сменить сборную на твою';

  @override
  String get hubEventCampaignVerdict => 'Кампания решена: смотри вердикт';

  @override
  String get hubEventCampaignComplete => 'Кампания завершена';

  @override
  String get hubEventIntercontinentalPlayoff => 'Межконтинентальный плей-офф';

  @override
  String get hubEventWatchWcDraw => 'Смотреть жеребьёвку чемпионата мира';

  @override
  String get hubEventWorldCupHere => 'Чемпионат мира начинается';

  @override
  String get hubEventWatchFinalsDraw =>
      'Смотреть жеребьёвку финального турнира';

  @override
  String get hubEventFinalsHere => 'Финальный турнир начинается';

  @override
  String get hubEventPlayWcRound => 'Сыграть следующий раунд чемпионата мира';

  @override
  String hubEventPlayCupMatch(String cup) {
    return 'Сыграть следующий матч: $cup';
  }

  @override
  String get hubEventPlayNationsCupMatch =>
      'Сыграть следующий матч Кубка наций';

  @override
  String get hubEventWatchNationsCupDraw => 'Смотреть жеребьёвку Кубка наций';

  @override
  String get hubEventWatchHostSelection => 'Смотреть выбор хозяина';

  @override
  String get hubEventWatchQualifyingDraw => 'Смотреть жеребьёвку отбора';

  @override
  String get hubEventWatchWcHostSelection =>
      'Смотреть выбор хозяина чемпионата мира';

  @override
  String get hubEventWatchWcQualifyingDraw =>
      'Смотреть жеребьёвку отбора чемпионата мира';

  @override
  String get hubEventArrangeFriendlies => 'Назначь товарищеские матчи';

  @override
  String hubEventFriendliesSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Открытых окон для товарищеских матчей: $count. Заполни их',
      many: 'Открытых окон для товарищеских матчей: $count. Заполни их',
      few: 'Открытых окон для товарищеских матчей: $count. Заполни их',
      one: 'Открытых окон для товарищеских матчей: $count. Заполни их',
    );
    return '$_temp0';
  }

  @override
  String get hubEventReshapeXi => 'Перестрой стартовый состав';

  @override
  String hubEventReshapeOutSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Выбыли $count игрока старта (дисквалификация или травма). Выбери замены',
      many:
          'Выбыли $count игроков старта (дисквалификация или травма). Выбери замены',
      few:
          'Выбыли $count игрока старта (дисквалификация или травма). Выбери замены',
      one:
          'Выбыл $count игрок старта (дисквалификация или травма). Выбери замену',
    );
    return '$_temp0';
  }

  @override
  String hubEventReshapeShortSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'В стартовом составе не хватает игроков. Заполни свободные места',
      many: 'В стартовом составе не хватает игроков. Заполни свободные места',
      few: 'В стартовом составе не хватает игроков. Заполни свободные места',
      one: 'В стартовом составе не хватает игрока. Заполни свободное место',
    );
    return '$_temp0';
  }

  @override
  String hubEventPlayOpponent(String opponent) {
    return 'Сыграть: $opponent';
  }

  @override
  String get hubEventContinentalFinalsFallback =>
      'континентальный финальный турнир';

  @override
  String get hubCallUpFriendlies => 'Назови состав на товарищеские матчи';

  @override
  String get hubCallUpRequalify => 'Обнови состав на отбор';

  @override
  String get hubCallUpWorldCup => 'Назови состав на чемпионат мира';

  @override
  String get hubCallUpFinals => 'Назови состав на финальный турнир';

  @override
  String get hubCallUpNationsCup => 'Назови состав на Кубок наций';

  @override
  String get hubCallUpQualifying => 'Назови состав на отбор';

  @override
  String get hubCallUpGeneric => 'Назови состав';

  @override
  String get hubHost => 'Хозяин';

  @override
  String get hubGoldenBoot => 'Золотая бутса';

  @override
  String hubGoldenBootValue(String name, int goals) {
    String _temp0 = intl.Intl.pluralLogic(
      goals,
      locale: localeName,
      other: '$goals гола',
      many: '$goals голов',
      few: '$goals гола',
      one: '$goals гол',
    );
    return '$name · $_temp0';
  }

  @override
  String get hubPens => '(пен.)';

  @override
  String get hubNationalHub => 'ЦЕНТР СБОРНОЙ';

  @override
  String get hubMessages => 'Сообщения';

  @override
  String get hubWorldChampions => 'ЧЕМПИОНЫ МИРА';

  @override
  String get hubViewBracket => 'Смотреть сетку ›';

  @override
  String get hubBoardDelighted => 'В восторге';

  @override
  String get hubBoardPleased => 'Рады';

  @override
  String get hubBoardExpectingMore => 'Ждут большего';

  @override
  String get hubBoardConcerned => 'Обеспокоены';

  @override
  String get hubBoardJobAtRisk => 'Под угрозой увольнения';

  @override
  String get boardRemarkNoted =>
      'Руководство приняло результат к сведению. Его оценка цикла не меняется.';

  @override
  String get boardRemarkEncouraged =>
      'Руководство приветствует результат против более сильного соперника.';

  @override
  String get boardRemarkExpected =>
      'Поражение от более сильного соперника ожидалось. Оценка руководства не меняется.';

  @override
  String get boardRemarkConcerned =>
      'Руководство отметило поражение и ждёт ответа.';

  @override
  String get hubBoard => 'РУКОВОДСТВО';

  @override
  String get hubFunds => 'СРЕДСТВА';

  @override
  String hubBoardObjective(String label) {
    return 'Задача руководства: $label';
  }

  @override
  String hubObjectiveMet(String result) {
    return 'ВЫПОЛНЕНО · $result';
  }

  @override
  String hubObjectiveMissed(String result) {
    return 'ПРОВАЛЕНО · $result';
  }

  @override
  String get hubNoMoreFixtures => 'В этом цикле матчей больше нет.';

  @override
  String get hubVs => 'VS';

  @override
  String hubWorldRank(int rank) {
    return '#$rank';
  }

  @override
  String get hubWorldRankLabel => 'Мировой рейтинг';

  @override
  String get hubSquadStatus => 'СОСТОЯНИЕ СОСТАВА';

  @override
  String hubPlayers(int count) {
    return 'Игроков: $count';
  }

  @override
  String get hubAvgRating => 'Ср. рейтинг';

  @override
  String get hubMorale => 'Мораль';

  @override
  String get hubManageTeam => 'Управление командой';

  @override
  String get hubGroupsToBeDrawn =>
      'Группы ещё не разыграны. Посмотри жеребьёвку, чтобы их узнать.';

  @override
  String hubGroupName(String name) {
    return 'ГРУППА $name';
  }

  @override
  String get hubTblTeam => 'КОМАНДА';

  @override
  String get hubTblP => 'И';

  @override
  String get hubTblGd => 'РМ';

  @override
  String get hubTblPts => 'О';

  @override
  String get homeSettings => 'Настройки';

  @override
  String get homeLeadTheNation => 'ВОЗГЛАВЬ СБОРНУЮ';

  @override
  String get homeYourNation => 'твоя сборная';

  @override
  String get homeNewGame => 'Новая игра';

  @override
  String get homeAllSaves => 'Все сохранения';

  @override
  String get homeLoadGame => 'Загрузить игру';

  @override
  String get homeContinue => 'ПРОДОЛЖИТЬ';

  @override
  String homeRoadToWorldCup(String date, int year) {
    return '$date · Путь к чемпионату мира $year';
  }

  @override
  String get careerManageSaves => 'Сохранения';

  @override
  String get careerNewGameTitle => 'НОВАЯ ИГРА';

  @override
  String careerCouldNotLoadNation(String error) {
    return 'Не удалось загрузить сборную.\n$error';
  }

  @override
  String get careerNationNotFound => 'Сборная не найдена.';

  @override
  String careerWorldRankNum(int rank) {
    return '#$rank В МИРЕ';
  }

  @override
  String get careerManagerName => 'Имя тренера';

  @override
  String get careerManagerNameHint => 'напр. Мартин';

  @override
  String get careerBeginsBlurb =>
      'Твоя карьера начинается в сентябре 2026 года, на пути к чемпионату мира 2030.';

  @override
  String get careerFreeCycleNote =>
      'Бесплатно на один полный четырёхлетний цикл: отбор, континентальный чемпионат и чемпионат мира, в двух сохранениях. Дальше один платёж открывает бесконечные циклы.';

  @override
  String get careerStartCareer => 'Начать карьеру';

  @override
  String get careersTitle => 'КАРЬЕРЫ';

  @override
  String get careerManagerCareer => 'Тренерская карьера';

  @override
  String get careerManagerCareerSubtitle => 'Все твои циклы и общая статистика';

  @override
  String get careerSummaryTitle => 'Итоги карьеры';

  @override
  String get careerSummarySubtitle => 'Витрина трофеев и статистика тренера';

  @override
  String get careerAchievements => 'Достижения';

  @override
  String get careerAchievementsSubtitle => 'Вехи, титулы и доверие руководства';

  @override
  String get careerChallenges => 'Испытания';

  @override
  String get careerChallengesSubtitle => 'Жёсткие испытания на всю карьеру';

  @override
  String get careerTeamRecords => 'Рекорды команды';

  @override
  String get careerTeamRecordsSubtitle =>
      'Лучшие бомбардиры и рекордсмены по матчам';

  @override
  String get careerMyMatches => 'Мои матчи';

  @override
  String get careerMyMatchesSubtitle => 'Все результаты и предстоящие матчи';

  @override
  String get careerTitle => 'КАРЬЕРА';

  @override
  String careerCouldNotLoadCareer(String error) {
    return 'Не удалось загрузить карьеру.\n$error';
  }

  @override
  String get careerNoCareer => 'Карьеры нет.';

  @override
  String get careerTrophyCabinet => 'ВИТРИНА ТРОФЕЕВ';

  @override
  String get careerTournamentHistory => 'ИСТОРИЯ ТУРНИРОВ';

  @override
  String get careerNoTournamentsYet => 'Ещё ни один турнир не завершён.';

  @override
  String get careerTeamFallback => 'Команда';

  @override
  String careerWorldNum(int rank) {
    return '#$rank В МИРЕ';
  }

  @override
  String careerPointsNum(int points) {
    return '$points ОЧК.';
  }

  @override
  String careerSeasonNum(int season) {
    return 'СЕЗОН $season';
  }

  @override
  String get careerStatPlayedShort => 'И';

  @override
  String get careerStatsHeading => 'В ЦИФРАХ';

  @override
  String get careerStatsWinRate => 'Процент побед';

  @override
  String get careerStatsGoalsFor => 'Забито';

  @override
  String get careerStatsGoalsAgainst => 'Пропущено';

  @override
  String get careerStatsGoalDiff => 'Разница мячей';

  @override
  String get careerStatsCleanSheets => '«Сухие» матчи';

  @override
  String get careerStatsBiggestWin => 'Крупнейшая победа';

  @override
  String get careerStatsWinStreak => 'Победная серия';

  @override
  String get careerStatsUnbeaten => 'Без поражений';

  @override
  String get careerStatsShootouts => 'Серии пенальти';

  @override
  String get careerStatsHatTricks => 'Хет-трики';

  @override
  String get careerStatsMotms => 'Игрок матча';

  @override
  String get careerStatsBestRating => 'Лучшая оценка';

  @override
  String get careerStatWonShort => 'В';

  @override
  String get careerStatDrawnShort => 'Н';

  @override
  String get careerStatLostShort => 'П';

  @override
  String get careerStatGoalsForShort => 'ЗМ';

  @override
  String get careerStatGoalsAgainstShort => 'ПМ';

  @override
  String get careerStatGoalDiffShort => 'РМ';

  @override
  String get careerNoSilverware => 'Трофеев пока нет. Иди и выиграй.';

  @override
  String get careerMedalGold => 'ЗОЛОТО';

  @override
  String get careerMedalSilver => 'СЕРЕБРО';

  @override
  String get careerMedalBronze => 'БРОНЗА';

  @override
  String careerWinnersName(String name) {
    return 'Победитель: $name';
  }

  @override
  String get careerSavesTitle => 'СОХРАНЕНИЯ';

  @override
  String careerCouldNotLoadSaves(String error) {
    return 'Не удалось загрузить сохранения.\n$error';
  }

  @override
  String careerSlotsCount(int used, int limit) {
    return 'СЛОТЫ  $used/$limit';
  }

  @override
  String get careerThisSave => 'это сохранение';

  @override
  String get careerSlotsFull => 'Слоты заняты';

  @override
  String careerSlotsUsed(int used) {
    return 'СЛОТЫ  $used';
  }

  @override
  String get careerSlotsUnlockMore => 'Открыть больше сохранений';

  @override
  String get careerSlotsKeepNote =>
      'Все твои сохранения остаются доступны. Разблокировка нужна только для нового.';

  @override
  String get careerNewGame => 'Новая игра';

  @override
  String get careerDeleteSaveTitle => 'Удалить сохранение?';

  @override
  String careerDeleteSaveBody(String label) {
    return 'Карьера «$label» будет удалена навсегда.';
  }

  @override
  String get careerCancel => 'Отмена';

  @override
  String get careerDelete => 'Удалить';

  @override
  String get careerNoSavesYet =>
      'Сохранений пока нет.\nНачни новую игру и возглавь сборную.';

  @override
  String get careerUnknownNation => 'Неизвестно';

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
    return 'Последняя игра: $when';
  }

  @override
  String get careerJustNow => 'только что';

  @override
  String get careerYesterday => 'вчера';

  @override
  String careerMinutesAgo(int n) {
    return '$n мин назад';
  }

  @override
  String careerHoursAgo(int n) {
    return '$n ч назад';
  }

  @override
  String careerDaysAgo(int n) {
    return '$n дн. назад';
  }

  @override
  String careerRoadToWorldCup(int year) {
    return 'Путь к чемпионату мира $year';
  }

  @override
  String homeNextFixture(String match, String when) {
    return 'Далее: $match, $when';
  }

  @override
  String homeCycleComplete(int year) {
    return 'Чемпионат мира $year завершён. Дальше вердикт руководства.';
  }

  @override
  String homeFollowingFinals(int year) {
    return 'После чемпионата мира $year';
  }

  @override
  String get careerManagerCareerTitle => 'ТРЕНЕРСКАЯ КАРЬЕРА';

  @override
  String careerCouldNotLoad(String error) {
    return 'Не удалось загрузить.\n$error';
  }

  @override
  String get careerCycleByCycle => 'ЦИКЛ ЗА ЦИКЛОМ';

  @override
  String careerCyclesNationsLed(int cycles, int nations) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles цикла',
      many: '$cycles циклов',
      few: '$cycles цикла',
      one: '$cycles цикл',
    );
    String _temp1 = intl.Intl.pluralLogic(
      nations,
      locale: localeName,
      other: '$nations сборной',
      many: '$nations сборных',
      few: '$nations сборные',
      one: '$nations сборная',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get careerStatTitles => 'Титулы';

  @override
  String get careerStatPlayed => 'Игры';

  @override
  String get careerStatWon => 'Победы';

  @override
  String get careerStatDrawn => 'Ничьи';

  @override
  String get careerStatLost => 'Поражения';

  @override
  String careerGoalsWinRate(
    int goalsFor,
    int goalsAgainst,
    String gd,
    int winRate,
  ) {
    return 'Голы $goalsFor–$goalsAgainst  ($gd)  ·  Победы $winRate%';
  }

  @override
  String get careerRecordResults => 'РЕКОРДНЫЕ РЕЗУЛЬТАТЫ';

  @override
  String get careerBestWin => 'Лучшая победа';

  @override
  String get careerWorstDefeat => 'Худшее поражение';

  @override
  String careerVsOpponentDate(String opponent, String date) {
    return 'против: $opponent · $date';
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
    return '$wonВ $drawnН $lostП  ·  ЗМ $goalsFor ПМ $goalsAgainst ($gd)';
  }

  @override
  String get careerWorldCupLabel => 'Чемпионат мира';

  @override
  String get careerContinentalLabel => 'Континентальный';

  @override
  String get messagesTitle => 'СООБЩЕНИЯ';

  @override
  String get messagesNoMessagesYet => 'Сообщений пока нет.';

  @override
  String messagesCouldNotLoad(String error) {
    return 'Не удалось загрузить сообщения.\n$error';
  }

  @override
  String get messagesDone => 'Готово';

  @override
  String get messagesNext => 'Далее';

  @override
  String get rankingWorldRanking => 'МИРОВОЙ РЕЙТИНГ';

  @override
  String rankingCouldNotLoad(String error) {
    return 'Не удалось загрузить рейтинг.\n$error';
  }

  @override
  String get rankingNoRanking => 'Рейтинга нет.';

  @override
  String get rankingAll => 'ВСЕ';

  @override
  String get rankingYourTeam => 'ТВОЯ КОМАНДА';

  @override
  String get rankingYourRankingOverTime => 'ТВОЙ РЕЙТИНГ ПО ВРЕМЕНИ';

  @override
  String rankingNowRank(int rank) {
    return 'сейчас #$rank';
  }

  @override
  String rankingBestWorst(int best, int worst) {
    return 'лучшее #$best · худшее #$worst';
  }

  @override
  String get friendliesTitle => 'ТОВАРИЩЕСКИЕ';

  @override
  String friendliesLoadError(String error) {
    return 'Не удалось загрузить товарищеские матчи.\n$error';
  }

  @override
  String get friendliesContinue => 'Продолжить';

  @override
  String friendliesArrangeIntro(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count свободного окна',
      many: '$count свободных окон',
      few: '$count свободных окна',
      one: '$count свободное окно',
    );
    return 'Назначь контрольные матчи на $_temp0 до следующего официального матча. Нажми на соперника или оставь окно пустым.';
  }

  @override
  String get friendliesFree => 'Свободно';

  @override
  String matchGoalsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ГОЛА',
      many: '$count ГОЛОВ',
      few: '$count ГОЛА',
      one: '$count ГОЛ',
    );
    return '$_temp0';
  }

  @override
  String get matchGoalsTitle => 'ГОЛЫ';

  @override
  String get matchGoalsNone => 'Голов нет';

  @override
  String get matchGoalPenalty => 'ПЕН';

  @override
  String get matchGoalSetPiece => 'СТД';

  @override
  String matchGoalAssist(String name) {
    return 'передача: $name';
  }

  @override
  String get friendliesHome => 'ДОМА';

  @override
  String get friendliesAway => 'В ГОСТЯХ';

  @override
  String get friendliesNoneThisWindow => 'В этом окне товарищеских нет';

  @override
  String friendliesConfirmCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count товарищеского матча',
      many: '$count товарищеских матчей',
      few: '$count товарищеских матча',
      one: '$count товарищеский матч',
    );
    return 'Подтвердить $_temp0';
  }

  @override
  String get friendliesMonthJan => 'Янв';

  @override
  String get friendliesMonthFeb => 'Фев';

  @override
  String get friendliesMonthMar => 'Мар';

  @override
  String get friendliesMonthApr => 'Апр';

  @override
  String get friendliesMonthMay => 'Май';

  @override
  String get friendliesMonthJun => 'Июн';

  @override
  String get friendliesMonthJul => 'Июл';

  @override
  String get friendliesMonthAug => 'Авг';

  @override
  String get friendliesMonthSep => 'Сен';

  @override
  String get friendliesMonthOct => 'Окт';

  @override
  String get friendliesMonthNov => 'Ноя';

  @override
  String get friendliesMonthDec => 'Дек';

  @override
  String get resultsMyMatches => 'МОИ МАТЧИ';

  @override
  String resultsCouldNotLoad(String error) {
    return 'Не удалось загрузить результаты.\n$error';
  }

  @override
  String get resultsNoFixtures => 'Матчей нет.';

  @override
  String get resultsVs => 'против';

  @override
  String get resultsStageQualifier => 'ОТБОР';

  @override
  String get resultsStageFriendly => 'ТОВАРИЩЕСКИЙ';

  @override
  String get resultsStageGroupStage => 'ГРУППОВОЙ ЭТАП';

  @override
  String get resultsStageSemiFinal => 'ПОЛУФИНАЛ';

  @override
  String get resultsStageFinal => 'ФИНАЛ';

  @override
  String get resultsStageContinentalClash => 'БИТВА КОНТИНЕНТОВ';

  @override
  String get resultsStageFinalsGroup => 'ГРУППА ФИНАЛА';

  @override
  String get resultsStageRoundOf32 => '1/16 ФИНАЛА';

  @override
  String get resultsStageRoundOf16 => '1/8 ФИНАЛА';

  @override
  String get resultsStageQuarterFinal => 'ЧЕТВЕРТЬФИНАЛ';

  @override
  String get resultsStageThirdPlace => 'ЗА 3-Е МЕСТО';

  @override
  String get matchSetupWarnCaptain =>
      'Капитан не назначен. Нажми, чтобы отдать кому-то повязку';

  @override
  String matchSetupWarnCaptainInjured(String name) {
    return '$name травмирован и не выведет команду. Нажми, чтобы передать повязку';
  }

  @override
  String matchSetupWarnCaptainSuspended(String name) {
    return '$name дисквалифицирован на этот матч. Нажми, чтобы передать повязку';
  }

  @override
  String matchSetupWarnCaptainDropped(String name) {
    return 'У игрока $name повязка, но его нет в составе. Нажми, чтобы передать её';
  }

  @override
  String get matchSetupWarnSetPieces =>
      'Исполнители стандартов не назначены. Нажми, чтобы выбрать';

  @override
  String get matchSetupWarnBoth =>
      'Нет капитана и исполнителей стандартов. Нажми, чтобы назначить';

  @override
  String matchStageMatchday(int matchday) {
    return 'ТУР $matchday';
  }

  @override
  String get squadCaptain => 'Капитан';

  @override
  String deptEffectYouth(int points) {
    return 'Выпускники академии примерно на $points рейтинга сильнее';
  }

  @override
  String deptEffectCommercial(String amount) {
    return '$amount вернётся в конце цикла';
  }

  @override
  String deptEffectMedical(int percent) {
    return 'На $percent% меньше травм';
  }

  @override
  String deptEffectNaturalisation(int percent) {
    return '$percent% шанс, что иностранец попросится в сборную';
  }

  @override
  String deptEffectBoard(int points) {
    return '+$points к терпению руководства до угрозы увольнения';
  }

  @override
  String get deptEffectNone => 'Без финансирования эффекта нет';

  @override
  String get statsBestRated => 'Оценки';

  @override
  String get statsMyCareer => 'Карьера';

  @override
  String get statsBestAverageRating => 'ЛУЧШАЯ СРЕДНЯЯ ОЦЕНКА';

  @override
  String get statsMyCareerRecord => 'ТВОЯ СТАТИСТИКА';

  @override
  String get statsNoRatingsRecorded => 'Оценок за матчи пока нет.';

  @override
  String get statsGroupRecord => 'Итоги';

  @override
  String get statsGroupRuns => 'Серии';

  @override
  String get statsGroupExtremes => 'Крайности';

  @override
  String get statsGroupSplits => 'Дома и в гостях';

  @override
  String get statsGroupSquad => 'Твои игроки';

  @override
  String get statsPlayed => 'Сыграно матчей';

  @override
  String get statsWinDrawLoss => 'Победы–ничьи–поражения';

  @override
  String get statsWinRate => 'Процент побед';

  @override
  String get statsGoals => 'Голы забито:пропущено';

  @override
  String get statsCleanSheets => '«Сухие» матчи';

  @override
  String get statsFailedToScore => 'Без забитых голов';

  @override
  String get statsLongestWinStreak => 'Самая длинная победная серия';

  @override
  String get statsLongestUnbeaten => 'Самая длинная серия без поражений';

  @override
  String get statsLongestCleanSheets => 'Самая длинная «сухая» серия';

  @override
  String get statsLongestWinless => 'Самая длинная серия без побед';

  @override
  String get statsCurrentRun => 'Текущая серия без поражений';

  @override
  String get statsBiggestWin => 'Крупнейшая победа';

  @override
  String get statsHeaviestDefeat => 'Крупнейшее поражение';

  @override
  String get statsMostGoalsInAGame => 'Больше всего голов в матче';

  @override
  String get statsShootouts => 'Серии пенальти: победы–поражения';

  @override
  String get statsComebackWins => 'Победы после отставания';

  @override
  String get statsHome => 'Дома';

  @override
  String get statsAway => 'В гостях';

  @override
  String get statsNeutral => 'Нейтральное поле';

  @override
  String get statsCompetitive => 'Официальные';

  @override
  String get statsFriendlies => 'Товарищеские';

  @override
  String get statsHatTricks => 'Хет-трики';

  @override
  String get statsBraces => 'Дубли';

  @override
  String get statsMotms => 'Награды «Игрок матча»';

  @override
  String get statsAssists => 'Передачи';

  @override
  String get statsCards => 'Карточки';

  @override
  String get statsBestRating => 'Лучшая личная оценка';

  @override
  String statsAppsShort(int apps) {
    String _temp0 = intl.Intl.pluralLogic(
      apps,
      locale: localeName,
      other: '$apps матча',
      many: '$apps матчей',
      few: '$apps матча',
      one: '$apps матч',
    );
    return '$_temp0';
  }

  @override
  String statsMotmShort(int motms) {
    return 'Игрок матча: $motms';
  }

  @override
  String get captainArmband => 'К';

  @override
  String get captainCurrent => 'Капитан. Нажми, чтобы снять повязку';

  @override
  String get captainFitBorn => 'Прирождённый лидер';

  @override
  String get captainFitNatural => 'Настоящий капитан';

  @override
  String get captainFitCapable => 'Справится с повязкой';

  @override
  String get captainFitUnproven => 'Ещё не лидер';

  @override
  String get captainNone => 'Капитан не назначен';

  @override
  String captainMoraleBoost(int morale) {
    return '+$morale к морали команды';
  }

  @override
  String get viceCaptainFirst => '1-й вице-капитан';

  @override
  String get viceCaptainSecond => '2-й вице-капитан';

  @override
  String get viceCaptainNone => 'Вице-капитан не назначен';

  @override
  String get viceCaptainHint =>
      'Получает повязку, когда капитан не может играть.';

  @override
  String captainStandIn(String vice, String captain) {
    return 'Команду выводит вице-капитан $vice; капитан $captain недоступен';
  }

  @override
  String captainStandInUnnamed(String vice) {
    return 'Команду выводит вице-капитан $vice';
  }

  @override
  String get resultsCategoryWorldCupQualifying => 'Отбор чемпионата мира';

  @override
  String get resultsCategoryFriendlies => 'Товарищеские';

  @override
  String get resultsCategoryContinentalClash => 'Битва континентов';

  @override
  String get resultsCategoryNationsCup => 'Кубок наций';

  @override
  String get resultsCategoryContinentalCup => 'Континентальный кубок';

  @override
  String get resultsCategoryWorldCupQualifyingShort => 'Отбор ЧМ';

  @override
  String get resultsCategoryContinentalQualifyingShort => 'Отбор конт. кубка';

  @override
  String get resultsCategoryContinentalQualifying =>
      'Отбор континентального кубка';

  @override
  String get resultsCategoryWorldCupFinals =>
      'Финальный турнир чемпионата мира';

  @override
  String get resultsRoundResults => 'РЕЗУЛЬТАТЫ ТУРА';

  @override
  String get resultsFriendlyInternationals => 'ТОВАРИЩЕСКИЕ МАТЧИ СБОРНЫХ';

  @override
  String get resultsKnockout => 'Плей-офф';

  @override
  String resultsEarlierMatches(int count) {
    return 'Прошлые матчи ($count)';
  }

  @override
  String resultsMatchday(int matchday) {
    return 'ТУР $matchday';
  }

  @override
  String get resultsContinue => 'Продолжить';

  @override
  String resultsGroup(String name) {
    return 'ГРУППА $name';
  }

  @override
  String get achievementsScreenTitle => 'ДОСТИЖЕНИЯ';

  @override
  String get achievementsChallengesTooltip => 'Испытания';

  @override
  String get achievementsChallengesHeading => 'ИСПЫТАНИЯ';

  @override
  String get achievementsBrutalTests => 'Жёсткие испытания на всю карьеру';

  @override
  String achievementsCouldNotLoad(String error) {
    return 'Не удалось загрузить.\n$error';
  }

  @override
  String achievementsUnlockedCount(int earned, int total) {
    return 'Открыто $earned / $total';
  }

  @override
  String achievementsConqueredCount(int done, int total) {
    return 'Покорено $done / $total';
  }

  @override
  String get achievementsBoardSatisfaction => 'ДОВЕРИЕ РУКОВОДСТВА';

  @override
  String achievementsUnlockedBanner(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ОТКРЫТО ДОСТИЖЕНИЙ: $count',
      many: 'ОТКРЫТО ДОСТИЖЕНИЙ: $count',
      few: 'ОТКРЫТО ДОСТИЖЕНИЙ: $count',
      one: 'ОТКРЫТО ДОСТИЖЕНИЙ: $count',
    );
    return '$_temp0';
  }

  @override
  String get achCatWins => 'Победы';

  @override
  String get achCatMatches => 'Матчи';

  @override
  String get achCatQualifications => 'Выходы в финал';

  @override
  String get achCatTitles => 'Титулы';

  @override
  String get achCatMisc => 'Разное';

  @override
  String get achCatMega => 'Мега';

  @override
  String get achCatGoals => 'Голы';

  @override
  String get achCatStreaks => 'Серии';

  @override
  String get achTierBronze => 'Бронза';

  @override
  String get achTierSilver => 'Серебро';

  @override
  String get achTierGold => 'Золото';

  @override
  String get achTierPlatinum => 'Платина';

  @override
  String achGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count гола',
      many: '$count голов',
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
      other: 'Забей $count гола.',
      many: 'Забей $count голов.',
      few: 'Забей $count гола.',
      one: 'Забей $count гол.',
    );
    return '$_temp0';
  }

  @override
  String achCleanSheets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count «сухого» матча',
      many: '$count «сухих» матчей',
      few: '$count «сухих» матча',
      one: '$count «сухой» матч',
    );
    return '$_temp0';
  }

  @override
  String achCleanSheetsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Сыграй $count матча на ноль.',
      many: 'Сыграй $count матчей на ноль.',
      few: 'Сыграй $count матча на ноль.',
      one: 'Сыграй $count матч на ноль.',
    );
    return '$_temp0';
  }

  @override
  String get achStreakWin5 => 'Привычка побеждать';

  @override
  String get achStreakWin5Desc => 'Выиграй пять матчей подряд.';

  @override
  String get achStreakWin10 => 'На кураже';

  @override
  String get achStreakWin10Desc => 'Выиграй десять матчей подряд.';

  @override
  String get achStreakWin20 => 'Каток';

  @override
  String get achStreakWin20Desc => 'Выиграй двадцать матчей подряд.';

  @override
  String get achUnbeaten15 => 'Крепкий орешек';

  @override
  String get achUnbeaten15Desc => 'Проведи пятнадцать матчей без поражений.';

  @override
  String get achUnbeaten30 => 'Неприкасаемые';

  @override
  String get achUnbeaten30Desc => 'Проведи тридцать матчей без поражений.';

  @override
  String get achHattrick => 'Герой хет-трика';

  @override
  String get achHattrickDesc => 'Пусть твой игрок сделает хет-трик.';

  @override
  String get achMotm10 => 'Звезда матча';

  @override
  String get achMotm10Desc => 'Собери 10 наград «Игрок матча».';

  @override
  String get achMotm50 => 'Талисман';

  @override
  String get achMotm50Desc => 'Собери 50 наград «Игрок матча».';

  @override
  String get achPerfect => 'Идеальная десятка';

  @override
  String get achPerfectDesc => 'Пусть твой игрок получит оценку 9.5+ за матч.';

  @override
  String get achShootout => 'Лёд в венах';

  @override
  String get achShootoutDesc => 'Выиграй пять серий пенальти.';

  @override
  String get achMassacre => 'Разгром';

  @override
  String get achMassacreDesc => 'Выиграй матч с разницей в 7 голов или больше.';

  @override
  String get achAnnihilation => 'Уничтожение';

  @override
  String get achAnnihilationDesc =>
      'Выиграй матч с разницей в 10 голов или больше.';

  @override
  String get chTierBronze => 'Бронза';

  @override
  String get chTierSilver => 'Серебро';

  @override
  String get chTierGold => 'Золото';

  @override
  String get chTierLegendary => 'Легенда';

  @override
  String get chFirstSteps => 'На тренерской скамье';

  @override
  String get chFirstStepsDesc => 'Проработай тренером 5 лет.';

  @override
  String get chUnbeaten10 => 'На кураже';

  @override
  String get chUnbeaten10Desc => 'Проведи 10 официальных матчей без поражений.';

  @override
  String get chTwoNations => 'Новый вызов';

  @override
  String get chTwoNationsDesc => 'Поработай с 2 разными сборными.';

  @override
  String get chCont1 => 'Чемпион континента';

  @override
  String get chCont1Desc => 'Выиграй континентальный чемпионат.';

  @override
  String get chNc1 => 'Обладатель Кубка наций';

  @override
  String get chNc1Desc => 'Выиграй Кубок наций.';

  @override
  String get chWc1 => 'Чемпион мира';

  @override
  String get chWc1Desc => 'Выиграй чемпионат мира.';

  @override
  String get chYears25 => 'Старожил';

  @override
  String get chYears25Desc => 'Проработай тренером 25 лет.';

  @override
  String get chWc3 => 'Серийный победитель';

  @override
  String get chWc3Desc => 'Выиграй 3 чемпионата мира.';

  @override
  String get chWc5 => 'Династия';

  @override
  String get chWc5Desc => 'Выиграй 5 чемпионатов мира.';

  @override
  String get chWc10 => 'Бессмертный';

  @override
  String get chWc10Desc => 'Выиграй 10 чемпионатов мира.';

  @override
  String get chWc2Teams => 'Бутсы на чемодане';

  @override
  String get chWc2TeamsDesc => 'Выиграй чемпионат мира с 2 разными сборными.';

  @override
  String get chWc3Teams => 'Путешественник';

  @override
  String get chWc3TeamsDesc => 'Выиграй чемпионат мира с 3 разными сборными.';

  @override
  String get chWcStreak3 => 'Три подряд';

  @override
  String get chWcStreak3Desc => 'Выиграй 3 чемпионата мира подряд.';

  @override
  String get chWcAllconf => 'Покоритель мира';

  @override
  String get chWcAllconfDesc =>
      'Выиграй чемпионат мира со сборной из каждой конфедерации (6).';

  @override
  String get chCont5 => 'Король континента';

  @override
  String get chCont5Desc => 'Выиграй 5 континентальных чемпионатов.';

  @override
  String get chContAll => 'Шесть континентов';

  @override
  String get chContAllDesc =>
      'Выиграй континентальный чемпионат каждой конфедерации (6).';

  @override
  String get chTreble => 'Полный комплект';

  @override
  String get chTrebleDesc =>
      'Выиграй чемпионат мира, континентальный титул и Кубок наций за одну карьеру.';

  @override
  String get chNations10 => 'Кочевник';

  @override
  String get chNations10Desc => 'Поработай с 10 разными сборными.';

  @override
  String get chYears100 => 'Век';

  @override
  String get chYears100Desc => 'Проработай тренером 100 лет.';

  @override
  String get chYears500 => 'Полтысячелетия';

  @override
  String get chYears500Desc => 'Проработай тренером 500 лет.';

  @override
  String get chYears1000 => 'Вечный';

  @override
  String get chYears1000Desc => 'Проработай тренером 1000 лет.';

  @override
  String get chGrandmaster => 'Гроссмейстер';

  @override
  String get chGrandmasterDesc =>
      'Выиграй 3 чемпионата мира И 5 континентальных чемпионатов.';

  @override
  String get chUndefeated => 'Неприкасаемые';

  @override
  String get chUndefeatedDesc =>
      'Выиграй чемпионат мира, не проиграв ни одного матча.';

  @override
  String get chPerfectQual => 'Безупречный отбор';

  @override
  String get chPerfectQualDesc =>
      'Выиграй все матчи отборочного цикла чемпионата мира.';

  @override
  String get chMinnow => 'Чудо аутсайдера';

  @override
  String get chMinnowDesc =>
      'Выиграй чемпионат мира со сборной вне топ-32 мирового рейтинга.';

  @override
  String get chGrandTour => 'Дома и в гостях';

  @override
  String get chGrandTourDesc =>
      'Выиграй чемпионат мира в роли хозяина и один на чужой земле.';

  @override
  String get chUnbeaten25 => 'Стена';

  @override
  String get chUnbeaten25Desc => 'Проведи 25 официальных матчей без поражений.';

  @override
  String get chGoals10k => 'Голевая машина';

  @override
  String get chGoals10kDesc => 'Забей 10 000 голов за карьеру.';

  @override
  String get chCleanSheets500 => 'Крепость';

  @override
  String get chCleanSheets500Desc => 'Сыграй 500 матчей на ноль за карьеру.';

  @override
  String get chHatTricks25 => 'Привычка к хет-трикам';

  @override
  String get chHatTricks25Desc => 'Пусть твои игроки сделают 25 хет-триков.';

  @override
  String get chWinStreak25 => 'Неудержимые';

  @override
  String get chWinStreak25Desc => 'Выиграй 25 матчей подряд.';

  @override
  String get chCont10 => 'Континентальная династия';

  @override
  String get chCont10Desc => 'Выиграй 10 континентальных чемпионатов.';

  @override
  String get chPcWc => 'Серийный чемпион';

  @override
  String chPcWcDesc(int count) {
    return 'Чемпионатов мира в этом сохранении: выиграй $count.';
  }

  @override
  String get chPcMajors => 'Коллекционер трофеев';

  @override
  String chPcMajorsDesc(int count) {
    return 'Крупных трофеев (чемпионат мира, континентальный титул, Кубок наций или Битва континентов): выиграй $count.';
  }

  @override
  String get chPcUnbeaten => 'Железная стена';

  @override
  String chPcUnbeatenDesc(int count) {
    return 'Официальных матчей без поражений подряд: $count.';
  }

  @override
  String get chPcNations => 'Странник';

  @override
  String chPcNationsDesc(int count) {
    return 'Разных сборных под твоим руководством: $count.';
  }

  @override
  String get chPcYears => 'Долгая дистанция';

  @override
  String chPcYearsDesc(int count) {
    return 'Лет на тренерском посту: $count.';
  }

  @override
  String achWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count победы',
      many: '$count побед',
      few: '$count победы',
      one: '$count победа',
    );
    return '$_temp0';
  }

  @override
  String achWinsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Выиграй $count матча.',
      many: 'Выиграй $count матчей.',
      few: 'Выиграй $count матча.',
      one: 'Выиграй $count матч.',
    );
    return '$_temp0';
  }

  @override
  String achMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count матча',
      many: '$count матчей',
      few: '$count матча',
      one: '$count матч',
    );
    return '$_temp0';
  }

  @override
  String achMatchesDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Сыграй $count матча.',
      many: 'Сыграй $count матчей.',
      few: 'Сыграй $count матча.',
      one: 'Сыграй $count матч.',
    );
    return '$_temp0';
  }

  @override
  String get achQualWc => 'Путёвка на чемпионат мира';

  @override
  String get achQualWcDesc => 'Пробейся на чемпионат мира.';

  @override
  String get achQualCont => 'Путёвка на континентальный турнир';

  @override
  String get achQualContDesc => 'Пробейся на свой континентальный чемпионат.';

  @override
  String get achTitleWc => 'Чемпионы мира';

  @override
  String get achTitleWcDesc => 'Выиграй чемпионат мира.';

  @override
  String get achTitleEuro => 'Чемпионы Европы';

  @override
  String get achTitleEuroDesc => 'Выиграй чемпионат Европы.';

  @override
  String get achTitleCopa => 'Чемпионы Южной Америки';

  @override
  String get achTitleCopaDesc => 'Выиграй Кубок Южной Америки.';

  @override
  String get achTitleAfcon => 'Чемпионы Африки';

  @override
  String get achTitleAfconDesc => 'Выиграй чемпионат Африки.';

  @override
  String get achTitleAsia => 'Чемпионы Азии';

  @override
  String get achTitleAsiaDesc => 'Выиграй чемпионат Азии.';

  @override
  String get achTitleConcacaf => 'Чемпионы Северной Америки';

  @override
  String get achTitleConcacafDesc => 'Выиграй Кубок Северной Америки.';

  @override
  String get achTitleOfc => 'Чемпионы Океании';

  @override
  String get achTitleOfcDesc => 'Выиграй Кубок Океании.';

  @override
  String get achTitleNations => 'Обладатели Кубка наций';

  @override
  String get achTitleNationsDesc => 'Выиграй Кубок наций.';

  @override
  String get achTitleClash => 'Победители Битвы континентов';

  @override
  String get achTitleClashDesc => 'Выиграй Битву континентов.';

  @override
  String get achTitleGulf => 'Обладатели Кубка оазиса';

  @override
  String get achTitleGulfDesc => 'Выиграй Кубок оазиса.';

  @override
  String get achTitleSea => 'Чемпионы Юго-Восточной Азии';

  @override
  String get achTitleSeaDesc => 'Выиграй чемпионат Юго-Восточной Азии.';

  @override
  String get achMarksman => 'Снайпер чемпионата мира';

  @override
  String get achMarksmanDesc =>
      'Пусть игрок твоей сборной забьёт 6+ голов в финальном турнире чемпионата мира.';

  @override
  String get achSweep => 'Полный комплект';

  @override
  String get achSweepDesc =>
      'Владей титулами чемпиона мира и чемпиона континента за одну карьеру.';

  @override
  String get achAllstar => 'Звезда турнира';

  @override
  String get achAllstarDesc =>
      'Пусть твой игрок попадёт в символическую сборную чемпионата мира.';

  @override
  String get achGoldenboot => 'Золотая бутса';

  @override
  String get achGoldenbootDesc =>
      'Пусть игрок твоей сборной станет лучшим бомбардиром чемпионата.';

  @override
  String get achDemolition => 'Разнос';

  @override
  String get achDemolitionDesc =>
      'Выиграй матч с разницей в 5 голов или больше.';

  @override
  String get achievementsNice => 'Отлично!';

  @override
  String get achievementsHardestTests =>
      'Самые тяжёлые испытания для тренера, на всю карьеру и со многими сборными.';

  @override
  String get achievementsThisSave => 'ЭТО СОХРАНЕНИЕ';

  @override
  String get achievementsBrutalBadge => 'ЖЁСТКО';

  @override
  String get paywallGoPro => 'ПЕРЕЙТИ НА UNLIMITED';

  @override
  String get paywallOneTimeUnlock => 'Разовая покупка. Без подписки.';

  @override
  String get paywallBenefitCarryOn =>
      'Это сохранение продолжится ровно с того места, где остановилось, со всеми матчами, рекордами и соперничествами.';

  @override
  String get paywallBenefitNoAds =>
      'Без рекламы, без микротранзакций, без подписки. Один платёж, обновления включены.';

  @override
  String get paywallBenefitSaves =>
      'Сколько угодно сохранений. Веди фаворита и аутсайдера одновременно и узнай, как по-разному читается одна игра.';

  @override
  String get paywallBenefitEndless =>
      'Все циклы отсюда и дальше. Выбери семнадцатилетнего сегодня и узнай в 2034, разглядел ли ты талант.';

  @override
  String get paywallUnlocked => 'Unlimited открыт. Приятной игры!';

  @override
  String get paywallContactingStore => 'Связь с магазином…';

  @override
  String paywallUnlockProPriced(String price) {
    return 'Открыть Unlimited · $price';
  }

  @override
  String get paywallRestorePurchases => 'Восстановить покупки';

  @override
  String get paywallStoreUnavailable => 'Магазин недоступен';

  @override
  String get paywallStoreUnavailableNote =>
      'Не удалось загрузить цену. Проверь подключение и попробуй снова.';

  @override
  String get paywallTryAgain => 'Попробовать снова';

  @override
  String get gateTitle => 'ТВОЙ ПЕРВЫЙ ЦИКЛ ЗАВЕРШЁН';

  @override
  String get gateLead =>
      'Четыре года – это один цикл. Этого мало, чтобы узнать, был ли ты прав.';

  @override
  String get gatePriceLead => 'Один платёж, навсегда';

  @override
  String get gateBuy => 'КУПИТЬ И ПРОДОЛЖИТЬ';

  @override
  String get gateExit => 'ВЫЙТИ';

  @override
  String get gateSaveTitle => 'ЭТОМУ СОХРАНЕНИЮ НУЖЕН PRO';

  @override
  String get gateSaveLead =>
      'Сохранения после бесплатного цикла и кампании Pro продолжаются с Pro. Ничего не теряется: сохранение ждёт тебя ровно таким, каким ты его оставил.';

  @override
  String get careerSaveLockedNote => 'Для продолжения нужен Pro';

  @override
  String get federationNaturalisation => 'НАТУРАЛИЗАЦИЯ';

  @override
  String federationNaturalisedTitle(String name) {
    return '$name натурализован';
  }

  @override
  String federationNaturalisedBody(String name, String nation) {
    return '$name завершил смену гражданства и теперь может играть за сборную: $nation. Вызови его при выборе состава.';
  }

  @override
  String federationCouldNotLoadOffer(String error) {
    return 'Не удалось загрузить предложение.\n$error';
  }

  @override
  String get federationContinue => 'Продолжить';

  @override
  String get federationOfferToSwitchAllegiance => 'ПРЕДЛОЖЕНИЕ СМЕНИТЬ СБОРНУЮ';

  @override
  String federationPlayerMeta(String position, int age, String nation) {
    return '$position · возраст $age · из страны: $nation';
  }

  @override
  String federationNaturalisationBlurb(
    String name,
    String playerNation,
    String sourceNation,
  ) {
    return '$name связан со страной $playerNation и готов натурализоваться. Прими, и его можно будет вызывать; откажи, и он останется в сборной $sourceNation.';
  }

  @override
  String get federationDecline => 'Отказать';

  @override
  String get federationNaturalise => 'Натурализовать';

  @override
  String get federationBudgetLater => 'Решить позже';

  @override
  String get federationSetYourBudget => 'УТВЕРДИ БЮДЖЕТ';

  @override
  String federationCouldNotLoadFinances(String error) {
    return 'Не удалось загрузить финансы.\n$error';
  }

  @override
  String get federationSaveNotFound => 'Сохранение не найдено.';

  @override
  String get federationBudgetHeading => 'БЮДЖЕТ ФЕДЕРАЦИИ';

  @override
  String federationDistributeBudget(String amount) {
    return 'Распредели $amount по отделам, чтобы открыть цикл. Трать с умом.';
  }

  @override
  String federationOverBudget(String amount) {
    return 'На $amount больше, чем есть у федерации. Убери часть';
  }

  @override
  String get federationAllocateFullBudget =>
      'Распредели весь бюджет, чтобы начать цикл.';

  @override
  String get federationConfirming => 'Подтверждение…';

  @override
  String get federationConfirmBudget => 'Утвердить бюджет';

  @override
  String get federationFinances => 'ФИНАНСЫ';

  @override
  String get federationInvestmentUpdated => 'Вложения обновлены.';

  @override
  String get federationDevelopment => 'РАЗВИТИЕ ФЕДЕРАЦИИ';

  @override
  String get federationProjectedAtSeasonEnd => 'ПРОГНОЗ НА КОНЕЦ СЕЗОНА';

  @override
  String get federationCentralFunding => 'Центральное финансирование';

  @override
  String get federationPrizeMoneySoFar => 'Призовые на данный момент';

  @override
  String get federationCommercialReturn => 'Коммерческий доход';

  @override
  String get federationThisSeasonLocked => 'ЭТОТ СЕЗОН (ЗАФИКСИРОВАН)';

  @override
  String get federationInvestForNextSeason => 'ВЛОЖЕНИЯ НА СЛЕДУЮЩИЙ СЕЗОН';

  @override
  String get federationNextSeasonImpact => 'ЭФФЕКТ В СЛЕДУЮЩЕМ СЕЗОНЕ';

  @override
  String get federationSaving => 'Сохранение…';

  @override
  String get federationConfirmInvestment => 'Подтвердить вложения';

  @override
  String get federationBalance => 'БАЛАНС ФЕДЕРАЦИИ';

  @override
  String get federationCommittedToStaff => 'Обязательства по штабу';

  @override
  String get federationFreeToSpend => 'Можно потратить';

  @override
  String get federationWagesNote =>
      'Зарплаты списываются с баланса в конце цикла, так что эта сумма уже занята.';

  @override
  String get federationInvestAtCeremony =>
      'Вложения на следующий сезон делаются на церемонии в конце цикла.';

  @override
  String federationLevelBadge(int level) {
    return 'У$level';
  }

  @override
  String get federationAcademyProspects => 'Выпускники академии';

  @override
  String federationPlusOverall(int value) {
    return '+$value к рейтингу';
  }

  @override
  String get federationInjuryRisk => 'Риск травм';

  @override
  String get federationNaturalisationChance => 'Шанс натурализации';

  @override
  String get federationBoardPatience => 'Терпение руководства';

  @override
  String get federationUnallocated => 'НЕ РАСПРЕДЕЛЕНО';

  @override
  String get nationsVitrineTitle => 'ВИТРИНА СБОРНОЙ';

  @override
  String nationsCouldNotLoad(String error) {
    return 'Не удалось загрузить сборную.\n$error';
  }

  @override
  String get nationsNoNation => 'Сборной нет.';

  @override
  String get nationsHonours => 'ДОСТИЖЕНИЯ';

  @override
  String get nationsRankingHistory => 'ИСТОРИЯ МИРОВОГО РЕЙТИНГА';

  @override
  String get nationsTopScorers => 'ЛУЧШИЕ БОМБАРДИРЫ В ИСТОРИИ';

  @override
  String get nationsTitles => 'ТИТУЛЫ';

  @override
  String get nationsYourTeam => 'ТВОЯ КОМАНДА';

  @override
  String get nationsWorld => 'МИР';

  @override
  String get nationsWorldCup => 'Чемпионат мира';

  @override
  String get nationsContinental => 'Континентальный';

  @override
  String nationsAppearances(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count участия',
      many: '$count участий',
      few: '$count участия',
      one: '$count участие',
    );
    return '$_temp0';
  }

  @override
  String get nationsNotEnoughHistory =>
      'Пока мало истории. Загляни через цикл-другой.';

  @override
  String nationsBestRank(int rank) {
    return 'Лучшее: #$rank';
  }

  @override
  String nationsNowRank(int rank) {
    return 'Сейчас: #$rank';
  }

  @override
  String get nationsNoGoals => 'Голов пока нет.';

  @override
  String get nationsGoalsAbbrev => 'гол.';

  @override
  String get nationsHosts => 'ХОЗЯЕВА';

  @override
  String get nationsSelectTitle => 'ВЫБОР СБОРНОЙ';

  @override
  String nationsCouldNotLoadNations(String error) {
    return 'Не удалось загрузить сборные.\n$error';
  }

  @override
  String get nationsNoMatch => 'Сборные не найдены.';

  @override
  String get nationsSelectHeading => 'Выбери сборную';

  @override
  String get nationsSearchHint => 'Поиск страны…';

  @override
  String get nationsRank => 'МЕСТО ';

  @override
  String get nationsPremium => 'PREMIUM';

  @override
  String get nationsSelect => 'ВЫБРАТЬ';

  @override
  String get statsTeamRecords => 'РЕКОРДЫ КОМАНДЫ';

  @override
  String get statsRecordBook => 'Книга рекордов';

  @override
  String statsCouldNotLoadStats(String error) {
    return 'Не удалось загрузить статистику.\n$error';
  }

  @override
  String get statsNoData => 'Нет данных.';

  @override
  String get statsTopScorers => 'БОМБАРДИРЫ';

  @override
  String get statsMostGamesPlayed => 'БОЛЬШЕ ВСЕГО МАТЧЕЙ';

  @override
  String get statsTeam => 'Команда';

  @override
  String get statsTopScorersShort => 'Бомбардиры';

  @override
  String get statsMostGames => 'Больше всего матчей';

  @override
  String get statsMostGamesShort => 'Матчи';

  @override
  String get statsNoGoalsRecorded => 'Голов пока нет.';

  @override
  String get statsUnknown => 'Неизвестно';

  @override
  String get playerTitle => 'ИГРОК';

  @override
  String playerLoadError(String error) {
    return 'Не удалось загрузить игрока.\n$error';
  }

  @override
  String get playerNotFound => 'Игрок не найден.';

  @override
  String get playerClub => 'КЛУБ';

  @override
  String get playerClubRole => 'В клубе';

  @override
  String get playerPosition => 'Позиция';

  @override
  String get playerPotential => 'Потенциал';

  @override
  String get playerAge => 'Возраст';

  @override
  String get playerValue => 'Стоимость';

  @override
  String get clubFirstChoice => 'Играет каждую неделю';

  @override
  String get clubRotation => 'В ротации';

  @override
  String get clubFringe => 'Почти не играет';

  @override
  String get clubFrozenOut => 'Не играет';

  @override
  String clubAtClub(String club, String standing) {
    return '$club: $standing';
  }

  @override
  String yWinUpset0(String opponent, String score) {
    return 'Я смотрю футбол тридцать лет и такого не ожидал. $opponent обыграны $score.';
  }

  @override
  String yWinUpset1(String opponent, String score) {
    return 'Против соперника $opponent в них никто не верил. $score. Вообще никто.';
  }

  @override
  String yWinUpset2(String opponent, String score) {
    return '$score против соперника $opponent. Идите будить соседей.';
  }

  @override
  String yWinUpset3(String opponent, String score) {
    return 'О таких вечерах рассказывают внукам. $opponent, $score.';
  }

  @override
  String yWinUpset4(String opponent, String score) {
    return '$score против соперника $opponent. Как бы это ни случилось, это случилось.';
  }

  @override
  String yWinUpset5(String opponent, String score) {
    return 'На бумаге всё было решено до стартового свистка. $opponent, $score: бумага ошиблась.';
  }

  @override
  String yWinUpset6(String opponent, String score) {
    return 'Победа над соперником $opponent $score. Через год в этот счёт никто не поверит.';
  }

  @override
  String yWinUpset7(String opponent, String score) {
    return '$opponent, $score. Порадуйтесь, а потом гляньте на календарь.';
  }

  @override
  String yWinUpset8(String opponent, String score) {
    return '$score против соперника $opponent, и восемьдесят минут из девяноста нам просто везло.';
  }

  @override
  String yWinUpset9(String opponent, String score) {
    return 'Один вечер против соперника $opponent не перечёркивает год. $score.';
  }

  @override
  String yWinUpset10(String opponent, String score) {
    return 'Победа над соперником $opponent $score, и сейчас нам скажут, что мы вышли на новый уровень. Не вышли.';
  }

  @override
  String yWinUpset11(String opponent, String score) {
    return '$opponent, $score. Прекрасно. Спросите меня, когда это будет важно.';
  }

  @override
  String yWinRoutine0(String opponent, String score) {
    return 'Победа над соперником $opponent $score. Ровно так, как должно быть, и в этом есть своё удовольствие.';
  }

  @override
  String yWinRoutine1(String opponent, String score) {
    return '$score против соперника $opponent. Безжалостно, и это комплимент.';
  }

  @override
  String yWinRoutine2(String opponent, String score) {
    return '$opponent, $score. Без суеты, без испуга, без претензий.';
  }

  @override
  String yWinRoutine3(String opponent, String score) {
    return 'Аккуратные $score против соперника $opponent. Так выглядит хорошая команда в тихий день.';
  }

  @override
  String yWinRoutine4(String opponent, String score) {
    return '$score против соперника $opponent. Работа сделана, ничего нового.';
  }

  @override
  String yWinRoutine5(String opponent, String score) {
    return 'Победа над соперником $opponent $score. Должны были, и сделали.';
  }

  @override
  String yWinRoutine6(String opponent, String score) {
    return 'Профессиональные $score против соперника $opponent. Дальше.';
  }

  @override
  String yWinRoutine7(String opponent, String score) {
    return '$opponent разобраны $score. В архив и дальше.';
  }

  @override
  String yWinRoutine8(String opponent, String score) {
    return '$score против соперника $opponent, и нам полагается аплодировать. За победу над ними.';
  }

  @override
  String yWinRoutine9(String opponent, String score) {
    return 'Ну что ж, молодцы все причастные к этим $score против соперника $opponent.';
  }

  @override
  String yWinRoutine10(String opponent, String score) {
    return '$opponent, $score. Обыгрывать таких – это минимум, а не достижение.';
  }

  @override
  String yWinRoutine11(String opponent, String score) {
    return 'Обыграли соперника $opponent $score, но выглядели при этом тяжело.';
  }

  @override
  String yWinTight0(String opponent, String score) {
    return '$score против соперника $opponent, и каждая минута заслужена.';
  }

  @override
  String yWinTight1(String opponent, String score) {
    return 'Тут нужен был характер. $opponent, $score.';
  }

  @override
  String yWinTight2(String opponent, String score) {
    return 'Победа над соперником $opponent $score через тернии, а такие победы запоминаются.';
  }

  @override
  String yWinTight3(String opponent, String score) {
    return '$score против соперника $opponent. Кто выигрывает такие матчи, тот и стоит на ногах в июне.';
  }

  @override
  String yWinTight4(String opponent, String score) {
    return 'Нервно, некрасиво, но победа. $opponent, $score.';
  }

  @override
  String yWinTight5(String opponent, String score) {
    return 'Победа над соперником $opponent $score. Забираем три очка и больше не пересматриваем.';
  }

  @override
  String yWinTight6(String opponent, String score) {
    return '$score. $opponent заставили нас биться за каждый сантиметр.';
  }

  @override
  String yWinTight7(String opponent, String score) {
    return '$opponent, $score. Некрасиво. Но засчитывается так же.';
  }

  @override
  String yWinTight8(String opponent, String score) {
    return '$score против соперника $opponent, и мы сами усложнили себе всё в десять раз.';
  }

  @override
  String yWinTight9(String opponent, String score) {
    return 'Мы не должны отбиваться из последних сил против соперника $opponent. $score.';
  }

  @override
  String yWinTight10(String opponent, String score) {
    return '$opponent, $score. Выиграли, но ничего хорошего о себе не узнали.';
  }

  @override
  String yWinTight11(String opponent, String score) {
    return 'Против соперника $opponent эти $score нам льстят.';
  }

  @override
  String yDrew0(String opponent, String score) {
    return 'Очко против соперника $opponent, $score. Берём и идём дальше.';
  }

  @override
  String yDrew1(String opponent, String score) {
    return '$score с соперником $opponent. Бывают дни и похуже.';
  }

  @override
  String yDrew2(String opponent, String score) {
    return 'Удержали $opponent на $score. Не из всего нужно делать историю.';
  }

  @override
  String yDrew3(String opponent, String score) {
    return '$opponent, $score. Очко есть очко, а таблица не спрашивает, как.';
  }

  @override
  String yDrew4(String opponent, String score) {
    return '$score с соперником $opponent. Два очка потеряно или одно добыто. Выбирай настроение.';
  }

  @override
  String yDrew5(String opponent, String score) {
    return 'Ничья с соперником $opponent, $score. Никто не рад, никто не в ярости.';
  }

  @override
  String yDrew6(String opponent, String score) {
    return '$opponent, $score. Самые незапоминающиеся девяносто минут года.';
  }

  @override
  String yDrew7(String opponent, String score) {
    return 'Разошлись миром с соперником $opponent, $score. Едем дальше.';
  }

  @override
  String yDrew8(String opponent, String score) {
    return '$score против соперника $opponent. Вот так тихо и умирают отборочные циклы.';
  }

  @override
  String yDrew9(String opponent, String score) {
    return 'Два очка выброшены против соперника $opponent. $score. Иначе не назовёшь.';
  }

  @override
  String yDrew10(String opponent, String score) {
    return '$opponent, $score. У нас было девяносто минут, и мы не знали, что с ними делать.';
  }

  @override
  String yDrew11(String opponent, String score) {
    return '$score с соперником $opponent: никто не вспомнит, но заплатят все.';
  }

  @override
  String yLost0(String opponent, String score) {
    return 'Поражение $score от соперника $opponent. Бывает.';
  }

  @override
  String yLost1(String opponent, String score) {
    return '$opponent, $score. Вешать некого. Идём дальше.';
  }

  @override
  String yLost2(String opponent, String score) {
    return 'Проиграли $score сопернику $opponent, отдав всё. Иногда этого мало.';
  }

  @override
  String yLost3(String opponent, String score) {
    return '$score от соперника $opponent. Выше голову. У этой команды ещё много впереди.';
  }

  @override
  String yLost4(String opponent, String score) {
    return '$opponent, $score. Мы были слабее, и спорить тут не о чем.';
  }

  @override
  String yLost5(String opponent, String score) {
    return 'Проиграли $score сопернику $opponent. Перегруппироваться.';
  }

  @override
  String yLost6(String opponent, String score) {
    return '$score от соперника $opponent. Не позор, но и не то.';
  }

  @override
  String yLost7(String opponent, String score) {
    return 'Поражение $score от соперника $opponent. Извлеки урок, иначе всё зря.';
  }

  @override
  String yLost8(String opponent, String score) {
    return '$score от соперника $opponent, и мы их даже не задели.';
  }

  @override
  String yLost9(String opponent, String score) {
    return 'Проиграли сопернику $opponent, $score. Те же проблемы, тот же месяц, скоро те же оправдания.';
  }

  @override
  String yLost10(String opponent, String score) {
    return '$opponent, $score. Когда это перестанет называться невезением?';
  }

  @override
  String yLost11(String opponent, String score) {
    return 'Поражение $score от соперника $opponent. За такой результат кто-то должен заплатить.';
  }

  @override
  String yLostBadly0(String opponent, String score) {
    return '$score от соперника $opponent. Один плохой вечер. Суди команду по всему циклу, а не по нему.';
  }

  @override
  String yLostBadly1(String opponent, String score) {
    return 'Никто не хотел этих $score против соперника $opponent меньше, чем сами игроки.';
  }

  @override
  String yLostBadly2(String opponent, String score) {
    return '$opponent, $score. Уродливо, и это не наша команда.';
  }

  @override
  String yLostBadly3(String opponent, String score) {
    return '$score против соперника $opponent, о которых лучше забыть. В следующий раз ответят.';
  }

  @override
  String yLostBadly4(String opponent, String score) {
    return '$score. От соперника $opponent. У меня нет слов, а мне платят за слова.';
  }

  @override
  String yLostBadly5(String opponent, String score) {
    return '$opponent, $score. Кто-то должен за это ответить.';
  }

  @override
  String yLostBadly6(String opponent, String score) {
    return 'Эти $score против соперника $opponent надо вычеркнуть из протоколов и из памяти.';
  }

  @override
  String yLostBadly7(String opponent, String score) {
    return 'Поражение $score от соперника $opponent. Такой счёт ничем не оправдать.';
  }

  @override
  String yLostBadly8(String opponent, String score) {
    return 'Это было не поражение от соперника $opponent, это была капитуляция. $score.';
  }

  @override
  String yLostBadly9(String opponent, String score) {
    return '$score. Против соперника $opponent. Люди платили деньги, чтобы это смотреть.';
  }

  @override
  String yLostBadly10(String opponent, String score) {
    return '$opponent, $score. Если и это ничего не изменит, то не изменит ничего.';
  }

  @override
  String yLostBadly11(String opponent, String score) {
    return 'Я видел эту команду униженной, но $score от соперника $opponent – это новое дно.';
  }

  @override
  String yWinUpset12(String opponent, String score) {
    return '$opponent обыграны $score. Запишите дату, вас ещё спросят, где вы были.';
  }

  @override
  String yWinUpset13(String opponent, String score) {
    return 'Никто за пределами раздевалки не верил. $score против соперника $opponent. Гордость – слишком слабое слово.';
  }

  @override
  String yWinUpset14(String opponent, String score) {
    return '$score против соперника $opponent! Каждый бежал, пока не кончились силы.';
  }

  @override
  String yWinUpset15(String opponent, String score) {
    return 'Сенсация. $opponent, $score. Вот зачем мы всегда приходим на стадион.';
  }

  @override
  String yWinUpset16(String opponent, String score) {
    return '$score против соперника $opponent. Все прогнозы только что вылетели в окно.';
  }

  @override
  String yWinUpset17(String opponent, String score) {
    return '$opponent были явными фаворитами. Итоговый счёт: $score в нашу пользу.';
  }

  @override
  String yWinUpset18(String opponent, String score) {
    return 'Одна из сенсаций года: $score против соперника $opponent.';
  }

  @override
  String yWinUpset19(String opponent, String score) {
    return '$opponent, $score. Никто не предсказал, и никто толком не может объяснить.';
  }

  @override
  String yWinUpset20(String opponent, String score) {
    return '$score против соперника $opponent. Прекрасно. Теперь все забудут, каким ужасным был остальной год.';
  }

  @override
  String yWinUpset21(String opponent, String score) {
    return 'Обыграли соперника $opponent $score, и на подножке уже не протолкнуться. А я был здесь, когда она была пустой.';
  }

  @override
  String yWinUpset22(String opponent, String score) {
    return '$opponent, $score. Блестяще, и они всё равно найдут способ это растратить.';
  }

  @override
  String yWinUpset23(String opponent, String score) {
    return 'Отличный вечер против соперника $opponent, $score. Одна ласточка весны не делает.';
  }

  @override
  String yLostBadly12(String opponent, String score) {
    return '$score от соперника $opponent. Больно, потому что нам не всё равно. Всё равно поддержим.';
  }

  @override
  String yLostBadly13(String opponent, String score) {
    return 'Вечер, который хочется забыть: $opponent, $score. Игрокам сейчас больнее всех.';
  }

  @override
  String yLostBadly14(String opponent, String score) {
    return '$opponent, $score. Выше голову. Команду судят по тому, как она на это ответит.';
  }

  @override
  String yLostBadly15(String opponent, String score) {
    return '$score против соперника $opponent. Плохо, да. Конец света, нет.';
  }

  @override
  String yLostBadly16(String opponent, String score) {
    return '$score от соперника $opponent. О таком результате будут говорить годами, и не по хорошему поводу.';
  }

  @override
  String yLostBadly17(String opponent, String score) {
    return '$opponent выиграли $score. Судя по этому, в следующий раз никто не удивится.';
  }

  @override
  String yLostBadly18(String opponent, String score) {
    return 'Один из худших вечеров за долгое время: $score против соперника $opponent.';
  }

  @override
  String yLostBadly19(String opponent, String score) {
    return '$opponent, $score. Вопросы будут, и правильно.';
  }

  @override
  String yLostBadly20(String opponent, String score) {
    return '$score от соперника $opponent. «Позор» – это ещё мягко сказано.';
  }

  @override
  String yLostBadly21(String opponent, String score) {
    return 'Проиграли $score сопернику $opponent. Последний, уходя, выключите свет.';
  }

  @override
  String yLostBadly22(String opponent, String score) {
    return '$opponent, $score. Я перестал удивляться, и это меня пугает.';
  }

  @override
  String yLostBadly23(String opponent, String score) {
    return '$score. $opponent. Кому-то из начальства пора сегодня обновить резюме.';
  }

  @override
  String yWinRout0(String opponent, String score) {
    return '$score против соперника $opponent! От такого футбола улыбается вся страна.';
  }

  @override
  String yWinRout1(String opponent, String score) {
    return '$opponent разгромлены, $score. Вот это игра.';
  }

  @override
  String yWinRout2(String opponent, String score) {
    return '$score. Против соперника $opponent. Сегодня получалось всё.';
  }

  @override
  String yWinRout3(String opponent, String score) {
    return 'Разгром $score: $opponent. Сохраните обзор, он ещё пригодится.';
  }

  @override
  String yWinRout4(String opponent, String score) {
    return '$opponent, $score. Вот команда, которая наслаждается футболом.';
  }

  @override
  String yWinRout5(String opponent, String score) {
    return '$score против соперника $opponent, и могло быть больше. Великолепно.';
  }

  @override
  String yWinRout6(String opponent, String score) {
    return '$score против соперника $opponent. На такой счёт посмотрят дважды.';
  }

  @override
  String yWinRout7(String opponent, String score) {
    return '$opponent обыграны $score. После первых получаса борьбы не было.';
  }

  @override
  String yWinRout8(String opponent, String score) {
    return 'Итоговый счёт: $score против соперника $opponent. Безусловно, крупнейшая победа за долгое время.';
  }

  @override
  String yWinRout9(String opponent, String score) {
    return '$opponent, $score. Одни приехали играть, другие так и не вышли из автобуса.';
  }

  @override
  String yWinRout10(String opponent, String score) {
    return '$score. У соперника $opponent не нашлось ответа ни на что.';
  }

  @override
  String yWinRout11(String opponent, String score) {
    return 'Разгром: $score против соперника $opponent.';
  }

  @override
  String yWinRout12(String opponent, String score) {
    return '$score против соперника $opponent. Мило, но эталоном их не назовёшь.';
  }

  @override
  String yWinRout13(String opponent, String score) {
    return 'Обыграли соперника $opponent $score. Разбудите меня, когда сделаем так с кем-то сильным.';
  }

  @override
  String yWinRout14(String opponent, String score) {
    return '$opponent, $score. Весело, но я видел команды, которые выглядели так же и ничего не выиграли.';
  }

  @override
  String yWinRout15(String opponent, String score) {
    return '$score, и все снова гении. Это был всего лишь соперник $opponent.';
  }

  @override
  String yWinRout16(String opponent, String score) {
    return '$score против соперника $opponent. Не увлекайтесь, это мало что доказывает.';
  }

  @override
  String yWinRout17(String opponent, String score) {
    return '$opponent, $score. Порадуйтесь, а потом вспомните, чем кончилось в прошлый раз.';
  }

  @override
  String yWinShootout0(String opponent) {
    return 'Прошли по пенальти соперника $opponent! Стальные нервы у всех до единого.';
  }

  @override
  String yWinShootout1(String opponent) {
    return 'Пенальти против соперника $opponent, и нервы выдержали. Обнимите незнакомца.';
  }

  @override
  String yWinShootout2(String opponent) {
    return 'Выиграли серию пенальти у соперника $opponent. Моё сердце этого не выдержит.';
  }

  @override
  String yWinShootout3(String opponent) {
    return '$opponent обыграны по пенальти. Мы в следующем раунде.';
  }

  @override
  String yWinShootout4(String opponent) {
    return 'Дело дошло до пенальти против соперника $opponent, и мы забили больше.';
  }

  @override
  String yWinShootout5(String opponent) {
    return 'Серия пенальти против соперника $opponent выиграна. Самым тяжёлым путём, но прошли.';
  }

  @override
  String yWinShootout6(String opponent) {
    return 'Прошли соперника $opponent по пенальти. Лотерея выиграна, игра забыта.';
  }

  @override
  String yWinShootout7(String opponent) {
    return 'Обыграли соперника $opponent по пенальти после такого? Повезло, и все это знают.';
  }

  @override
  String yWinShootout8(String opponent) {
    return 'Прошли соперника $opponent по пенальти. До них вообще не должно было дойти.';
  }

  @override
  String yKnockoutWin0(String opponent, String score) {
    return 'ПРОШЛИ. $score против соперника $opponent, и мечта ещё жива.';
  }

  @override
  String yKnockoutWin1(String opponent, String score) {
    return 'ПОБЕДА В ПЛЕЙ-ОФФ: $opponent обыграны $score. Страна может начинать верить.';
  }

  @override
  String yKnockoutWin2(String opponent, String score) {
    return '$score против соперника $opponent, и мы в следующем раунде. Вот это вечер.';
  }

  @override
  String yKnockoutWin3(String opponent, String score) {
    return '$opponent отправлены домой, $score. Вперёд.';
  }

  @override
  String yKnockoutWin4(String opponent, String score) {
    return 'ПЛЕЙ-ОФФ: $score против соперника $opponent. Следующий раунд обеспечен.';
  }

  @override
  String yKnockoutWin5(String opponent, String score) {
    return 'Прошли: $score против соперника $opponent.';
  }

  @override
  String yKnockoutWin6(String opponent, String score) {
    return '$opponent выбиты, $score. Впереди следующий раунд.';
  }

  @override
  String yKnockoutWin7(String opponent, String score) {
    return 'Победа $score над соперником $opponent. Плей-офф неважно, как.';
  }

  @override
  String yKnockoutWin8(String opponent, String score) {
    return 'Прошли соперника $opponent, $score. Следующий соперник таким добрым не будет.';
  }

  @override
  String yKnockoutWin9(String opponent, String score) {
    return '$score против соперника $opponent хватило, чтобы пройти. В следующий раз понадобится гораздо больше.';
  }

  @override
  String yKnockoutWin10(String opponent, String score) {
    return '$opponent вылетели, $score. Скорее выжили, чем победили.';
  }

  @override
  String yKnockoutWin11(String opponent, String score) {
    return 'Мы в следующем раунде после $score против соперника $opponent. Не спрашивайте, как.';
  }

  @override
  String yUpsetGap0(String opponent, int gap) {
    return 'Между нами в рейтинге $gap мест, а мы всё равно обыграли соперника $opponent. Великолепно.';
  }

  @override
  String yUpsetGap1(String opponent, int gap) {
    return '$opponent были на $gap мест выше нас. Обыграны. Футбол прекрасен.';
  }

  @override
  String yUpsetGap2(String opponent, int gap) {
    return 'Разница в рейтинге: $gap мест. Результат: мы обыграли соперника $opponent. Никогда не переставайте верить.';
  }

  @override
  String yUpsetGap3(String opponent, int gap) {
    return 'Разница в рейтинге перед матчем: $gap мест. $opponent всё равно обыграны.';
  }

  @override
  String yUpsetGap4(String opponent, int gap) {
    return '$opponent были на $gap мест выше нас в мировом рейтинге. Но не сегодня.';
  }

  @override
  String yUpsetGap5(String opponent, int gap) {
    return 'Индекс сенсации: $gap мест в рейтинге между командами. Победа за нами, соперник: $opponent.';
  }

  @override
  String yUpsetGap6(String opponent, int gap) {
    return 'Нас от соперника $opponent отделяли $gap мест в рейтинге. Один вечер этот разрыв не закроет.';
  }

  @override
  String yUpsetGap7(String opponent, int gap) {
    return '$opponent: на $gap мест выше нас, и обыграны. Рейтинг этого почти не заметит.';
  }

  @override
  String yUpsetGap8(int gap) {
    return 'Разница в рейтинге: $gap мест. Запомните это число, когда в следующий раз проиграем аутсайдеру.';
  }

  @override
  String yEatWords0(String opponent) {
    return 'Я списал эту команду. Я ошибся и никогда так не радовался своей ошибке. $opponent обыграны.';
  }

  @override
  String yEatWords1(String opponent) {
    return 'Беру свои слова назад, и с удовольствием. Победа над соперником $opponent была великолепной.';
  }

  @override
  String yEatWords2(String opponent) {
    return 'Я говорил, что у них ничего не осталось. Осталось много. Отлично сыграли против соперника $opponent, все до одного.';
  }

  @override
  String yEatWords3(String opponent) {
    return 'Для протокола: победы над соперником $opponent я не ожидал. Отдаю должное.';
  }

  @override
  String yEatWords4(String opponent) {
    return 'Ладно. Я говорил, что их раскусят. $opponent их не раскусили.';
  }

  @override
  String yEatWords5(String opponent) {
    return 'Сегодня я беру свои слова об этой команде назад. Победа над соперником $opponent это заслужила.';
  }

  @override
  String yEatWords6(String opponent) {
    return 'Да, я говорил, что им конец. Одна победа над соперником $opponent ещё не доказывает, что я ошибся.';
  }

  @override
  String yEatWords7(String opponent) {
    return 'Мне велят взять слова назад после матча с соперником $opponent. Возьму, медленно, и чек сохраню.';
  }

  @override
  String yEatWords8(String opponent) {
    return 'Победа над соперником $opponent впечатляет. Но мои сомнения в этой команде никуда не делись.';
  }

  @override
  String yAwayFansWin0(String nation, String score) {
    return 'Надо отдать должное: $nation. $score, и они заслужили всё до капли.';
  }

  @override
  String yAwayFansWin1(String nation, String score) {
    return 'Больно это говорить, но $nation сегодня были лучше. $score. Поздравляем.';
  }

  @override
  String yAwayFansWin2(String nation, String score) {
    return '$score. Снимаем шляпу: $nation хотели этого больше.';
  }

  @override
  String yAwayFansWin3(String nation, String score) {
    return 'Проиграли $score, соперник: $nation. Даже не знаю, что сказать.';
  }

  @override
  String yAwayFansWin4(String nation, String score) {
    return '$nation, $score. Нашим должно быть стыдно.';
  }

  @override
  String yAwayFansWin5(String nation, String score) {
    return '$score против соперника $nation. Кто-нибудь объясните мне, как это случилось.';
  }

  @override
  String yAwayFansWin6(String nation, String score) {
    return 'Проиграть $score, соперник: $nation. Я никогда этого не переживу.';
  }

  @override
  String yAwayFansWin7(String nation, String score) {
    return '$score, соперник: $nation. Повезло. Просто повезло.';
  }

  @override
  String yAwayFansWin8(String nation, String score) {
    return 'После этих $score $nation будут невыносимы ещё много лет. Спасибо за ничего.';
  }

  @override
  String yNeutralWin0(String nation, String opponent, String score) {
    return '$nation $score $opponent. Отлично для футбола. Вот за это мы его и любим.';
  }

  @override
  String yNeutralWin1(String nation, String opponent, String score) {
    return 'Какой результат: $nation, $score против соперника $opponent. Футбол во всей красе.';
  }

  @override
  String yNeutralWin2(String nation, String opponent, String score) {
    return 'Все нейтральные болельщики сегодня за них: $nation. $score против соперника $opponent!';
  }

  @override
  String yNeutralWin3(String nation, String opponent, String score) {
    return 'Результат тура: $nation $score $opponent.';
  }

  @override
  String yNeutralWin4(String nation, String opponent, String score) {
    return '$nation обыграли соперника $opponent $score. Такого никто не ставил.';
  }

  @override
  String yNeutralWin5(String nation, String opponent, String score) {
    return 'Громкий результат: $nation $score $opponent. Рейтинг сдвинется.';
  }

  @override
  String yNeutralWin6(String nation, String opponent, String score) {
    return '$nation $score $opponent. Весело, но посмотрим, смогут ли они повторить.';
  }

  @override
  String yNeutralWin7(String nation, String opponent, String score) {
    return '$nation $score $opponent. Это $nation выиграли или $opponent проиграли?';
  }

  @override
  String yNeutralWin8(String nation, String opponent, String score) {
    return 'Сенсация: $nation $score $opponent. Ждите бурной реакции.';
  }

  @override
  String yScorerHero0(String name, String opponent) {
    return '$name против соперника $opponent. В его честь будут называть детей.';
  }

  @override
  String yScorerHero1(String name, String opponent) {
    return 'Памятник игроку $name. Сегодня против соперника $opponent он был всем.';
  }

  @override
  String yScorerHero2(String name, String opponent) {
    return '$name, красавец. Запомни этот вечер против соперника $opponent.';
  }

  @override
  String yScorerHero3(String name, String opponent) {
    return '$name решил исход против соперника $opponent. Игрок матча, без вопросов.';
  }

  @override
  String yScorerHero4(String name, String opponent) {
    return 'Против соперника $opponent этот вечер принадлежал ему: $name.';
  }

  @override
  String yScorerHero5(String name, String opponent) {
    return '$name проявил себя, когда это было важно, против соперника $opponent.';
  }

  @override
  String yScorerHero6(String name, String opponent) {
    return '$name был блестящ против соперника $opponent. Теперь так каждую неделю.';
  }

  @override
  String yScorerHero7(String name, String opponent) {
    return '$name спас команду против соперника $opponent. Остальные помогали мало.';
  }

  @override
  String yScorerHero8(String name, String opponent) {
    return 'Убери из этого матча игрока $name, и вечер против соперника $opponent был бы совсем другим.';
  }

  @override
  String yLostShock0(String opponent, String score) {
    return '$score от соперника $opponent. Случайный результат. Раз в жизни бывает с каждым.';
  }

  @override
  String yLostShock1(String opponent, String score) {
    return 'Проиграли $score сопернику $opponent. Стряхнуть и забыть, цикл не окончен.';
  }

  @override
  String yLostShock2(String opponent, String score) {
    return '$opponent, $score. Больно, но один результат не определяет команду.';
  }

  @override
  String yLostShock3(String opponent, String score) {
    return '$score против соперника $opponent. Неудачный рабочий день. Идём дальше.';
  }

  @override
  String yLostShock4(String opponent, String score) {
    return 'Проиграли сопернику $opponent, $score. Такого никто не ожидал.';
  }

  @override
  String yLostShock5(String opponent, String score) {
    return '$opponent, $score. Один из тех вечеров, в которых нет смысла.';
  }

  @override
  String yLostShock6(String opponent, String score) {
    return '$score от соперника $opponent. Это поражение запомнят.';
  }

  @override
  String yLostShock7(String opponent, String score) {
    return 'Поражение от соперника $opponent, $score. Сенсация по любым меркам.';
  }

  @override
  String yLostShock8(String opponent, String score) {
    return '$score от соперника $opponent. От них! Недопустимо.';
  }

  @override
  String yLostShock9(String opponent, String score) {
    return 'Проиграли $score сопернику $opponent. Мне нужны объяснения, а не оправдания.';
  }

  @override
  String yLostShock10(String opponent, String score) {
    return '$opponent, $score. Национальный позор, и это не фигура речи.';
  }

  @override
  String yLostShock11(String opponent, String score) {
    return '$score против соперника $opponent. Как начальство до сих пор на своих местах?';
  }

  @override
  String yLostRout0(String opponent, String score) {
    return '$score от соперника $opponent. Это топ-команда. Сделайте выводы.';
  }

  @override
  String yLostRout1(String opponent, String score) {
    return '$opponent были на голову сильнее, $score. Не стыдно проиграть лучшим.';
  }

  @override
  String yLostRout2(String opponent, String score) {
    return '$opponent, $score. Урок, а на уроках растут.';
  }

  @override
  String yLostRout3(String opponent, String score) {
    return '$score против соперника $opponent. Больно, но они уровнем выше.';
  }

  @override
  String yLostRout4(String opponent, String score) {
    return '$opponent выиграли $score. Разрыв реален, и теперь его увидели все.';
  }

  @override
  String yLostRout5(String opponent, String score) {
    return '$score от соперника $opponent. Порка, и точка.';
  }

  @override
  String yLostRout6(String opponent, String score) {
    return '$opponent, $score. Сильнейшая команда, и счёт об этом говорит.';
  }

  @override
  String yLostRout7(String opponent, String score) {
    return 'Проиграли $score сопернику $opponent. Не позор, но и не борьба.';
  }

  @override
  String yLostRout8(String opponent, String score) {
    return '$score от соперника $opponent. Сильнее они или нет, так проигрывать нельзя.';
  }

  @override
  String yLostRout9(String opponent, String score) {
    return '$opponent, $score. Мы вообще пытались бороться?';
  }

  @override
  String yLostRout10(String opponent, String score) {
    return '$score. Против соперника $opponent. Агнцы на заклание.';
  }

  @override
  String yLostRout11(String opponent, String score) {
    return 'Поражение $score от соперника $opponent, и никого это, похоже, не задело.';
  }

  @override
  String yLostShootout0(String opponent) {
    return 'Вылетели по пенальти от соперника $opponent. Они отдали всё. Горжусь ими.';
  }

  @override
  String yLostShootout1(String opponent) {
    return 'Пенальти против соперника $opponent. Самый жестокий способ вылететь. Выше голову.';
  }

  @override
  String yLostShootout2(String opponent) {
    return 'Проиграли серию пенальти сопернику $opponent. Никто такого не заслужил.';
  }

  @override
  String yLostShootout3(String opponent) {
    return 'Вылетели по пенальти от соперника $opponent. Всё решили одиннадцатиметровые.';
  }

  @override
  String yLostShootout4(String opponent) {
    return '$opponent прошли по пенальти. Наш турнир на этом окончен.';
  }

  @override
  String yLostShootout5(String opponent) {
    return 'Серия пенальти проиграна сопернику $opponent. Опять пенальти.';
  }

  @override
  String yLostShootout6(String opponent) {
    return 'Вылетели по пенальти от соперника $opponent. Мы их вообще тренируем?';
  }

  @override
  String yLostShootout7(String opponent) {
    return 'Проиграли сопернику $opponent по пенальти. Надо было закрывать матч гораздо раньше.';
  }

  @override
  String yLostShootout8(String opponent) {
    return 'Пенальти против соперника $opponent, и мы их проиграли. Конечно же.';
  }

  @override
  String yKnockoutLoss0(String opponent, String score) {
    return 'ВЫЛЕТЕЛИ. $score от соперника $opponent. Путь, которым можно гордиться, окончен.';
  }

  @override
  String yKnockoutLoss1(String opponent, String score) {
    return 'Выбиты соперником $opponent, $score. Спасибо за воспоминания.';
  }

  @override
  String yKnockoutLoss2(String opponent, String score) {
    return '$score против соперника $opponent. Путешествие окончено, но какое путешествие.';
  }

  @override
  String yKnockoutLoss3(String opponent, String score) {
    return 'ВЫБЫЛИ: $score от соперника $opponent. Головы выше.';
  }

  @override
  String yKnockoutLoss4(String opponent, String score) {
    return 'ВЫЛЕТ: $score против соперника $opponent.';
  }

  @override
  String yKnockoutLoss5(String opponent, String score) {
    return 'Вылет: $score против соперника $opponent.';
  }

  @override
  String yKnockoutLoss6(String opponent, String score) {
    return '$opponent проходят дальше, $score. Наш турнир окончен.';
  }

  @override
  String yKnockoutLoss7(String opponent, String score) {
    return 'Выбиты соперником $opponent, $score. Разбор полётов начинается.';
  }

  @override
  String yKnockoutLoss8(String opponent, String score) {
    return 'ВЫЛЕТЕЛИ. $score от соперника $opponent. Другой турнир, тот же финал.';
  }

  @override
  String yKnockoutLoss9(String opponent, String score) {
    return '$score от соперника $opponent, и мы едем домой. Никто не удивлён.';
  }

  @override
  String yKnockoutLoss10(String opponent, String score) {
    return 'Выбиты соперником $opponent, $score. К утру ждите оправданий.';
  }

  @override
  String yKnockoutLoss11(String opponent, String score) {
    return '$opponent, $score. Вылетели, и иначе быть не могло.';
  }

  @override
  String yAwayFansGloat0(String nation, String score) {
    return '$score против соперника $nation. Уважение, они вернутся сильнее.';
  }

  @override
  String yAwayFansGloat1(String nation, String score) {
    return 'Хорошая победа для нас, $score. Плохой день для них: $nation. Сочувствую их болельщикам.';
  }

  @override
  String yAwayFansGloat2(String nation, String score) {
    return '$score. У соперника $nation был плохой вечер, и мы воспользовались шансом. Справедливо.';
  }

  @override
  String yAwayFansGloat3(String nation, String score) {
    return '$score против соперника $nation! Кто бы мог подумать? Точно не они.';
  }

  @override
  String yAwayFansGloat4(String nation, String score) {
    return 'Обыграли соперника $nation $score. Кто-нибудь, проверьте их болельщиков.';
  }

  @override
  String yAwayFansGloat5(String nation, String score) {
    return '$nation, $score. Это в фотоальбом.';
  }

  @override
  String yAwayFansGloat6(String nation, String score) {
    return '$score против соперника $nation. А ещё считают себя большой командой.';
  }

  @override
  String yAwayFansGloat7(String nation, String score) {
    return 'Представьте, проиграть нам $score. Спросите у них: $nation. Теперь они знают.';
  }

  @override
  String yAwayFansGloat8(String nation, String score) {
    return '$nation, $score. Приятного полёта домой.';
  }

  @override
  String yNeutralLoss0(String nation, String opponent, String score) {
    return '$nation $score $opponent. Великий вечер для одних, тяжёлый для других.';
  }

  @override
  String yNeutralLoss1(String nation, String opponent, String score) {
    return 'Сочувствую болельщикам ($nation) после $score против соперника $opponent. Они ещё поднимутся.';
  }

  @override
  String yNeutralLoss2(String nation, String opponent, String score) {
    return '$nation $score $opponent. У каждой большой команды бывает такой вечер.';
  }

  @override
  String yNeutralLoss3(String nation, String opponent, String score) {
    return 'Сенсация тура: $nation $score $opponent.';
  }

  @override
  String yNeutralLoss4(String nation, String opponent, String score) {
    return '$nation $score $opponent. Такого никто не ожидал.';
  }

  @override
  String yNeutralLoss5(String nation, String opponent, String score) {
    return 'Результат дня: $nation $score $opponent. Теперь вопросы к проигравшим.';
  }

  @override
  String yNeutralLoss6(String nation, String opponent, String score) {
    return '$nation $score $opponent. Не случайность, если вы следили.';
  }

  @override
  String yNeutralLoss7(String nation, String opponent, String score) {
    return '$nation $score $opponent. Кому-то там придётся многое объяснить.';
  }

  @override
  String yNeutralLoss8(String nation, String opponent, String score) {
    return '$nation $score $opponent. Громкое имя, бледная игра.';
  }

  @override
  String yDownGap0(String opponent, int gap) {
    return '$opponent были на $gap мест ниже нас. Бывает. Идём дальше.';
  }

  @override
  String yDownGap1(int gap) {
    return 'Разница в рейтинге: $gap мест в нашу пользу. Футбол рейтингов не читает.';
  }

  @override
  String yDownGap2(String opponent, int gap) {
    return '$gap мест между нами и соперником $opponent на бумаге. Но не на поле сегодня.';
  }

  @override
  String yDownGap3(String opponent, int gap) {
    return 'Разница в рейтинге перед матчем: $gap мест в нашу пользу. И всё равно проиграли сопернику $opponent.';
  }

  @override
  String yDownGap4(String opponent, int gap) {
    return '$opponent были на $gap мест ниже нас в мировом рейтинге. Итог: поражение.';
  }

  @override
  String yDownGap5(String opponent, int gap) {
    return 'Индекс сенсации: $gap мест в рейтинге, но не в ту сторону. Соперник: $opponent.';
  }

  @override
  String yDownGap6(String opponent, int gap) {
    return 'На $gap мест выше соперника $opponent в рейтинге. Проиграли. Объясните.';
  }

  @override
  String yDownGap7(int gap) {
    return 'Проиграли команде на $gap мест ниже нас. Вдумайтесь в это число.';
  }

  @override
  String yDownGap8(String opponent, int gap) {
    return 'Разница в рейтинге: $gap мест. Проиграли сопернику $opponent. Кому-то пора считать дни.';
  }

  @override
  String yDrewHeroic0(String opponent, String score) {
    return '$score против соперника $opponent! Ничья со вкусом победы.';
  }

  @override
  String yDrewHeroic1(String opponent, String score) {
    return 'Удержали $opponent, $score. Горжусь каждым.';
  }

  @override
  String yDrewHeroic2(String opponent, String score) {
    return '$opponent, $score. Они были фаворитами, а мы сыграли на равных.';
  }

  @override
  String yDrewHeroic3(String opponent, String score) {
    return '$score с соперником $opponent. Очко, добытое потом и кровью.';
  }

  @override
  String yDrewHeroic4(String opponent, String score) {
    return '$score против соперника $opponent. Очень хорошее очко.';
  }

  @override
  String yDrewHeroic5(String opponent, String score) {
    return 'Ничья $score с соперником $opponent. Мало кто вообще чего-то ждал.';
  }

  @override
  String yDrewHeroic6(String opponent, String score) {
    return '$opponent остановлены, $score. На этом можно строить.';
  }

  @override
  String yDrewHeroic7(String opponent, String score) {
    return '$score против соперника $opponent. Очко, которое нам никто не давал.';
  }

  @override
  String yDrewHeroic8(String opponent, String score) {
    return '$score с соперником $opponent. Хорошее очко, но ничьими ничего не выигрывают.';
  }

  @override
  String yDrewHeroic9(String opponent, String score) {
    return 'Удержали $opponent, $score. Мило. Ещё у нас не было ни одного достойного удара.';
  }

  @override
  String yDrewHeroic10(String opponent, String score) {
    return '$opponent, $score. Одно очко, а все ведут себя так, будто мы выиграли турнир.';
  }

  @override
  String yDrewHeroic11(String opponent, String score) {
    return '$score против соперника $opponent. Поставили автобус, и повезло.';
  }

  @override
  String yDrewShame0(String opponent, String score) {
    return '$score с соперником $opponent. Досадно, но без поражений.';
  }

  @override
  String yDrewShame1(String opponent, String score) {
    return '$opponent нас остановили, $score. Неудачный день. Бывает.';
  }

  @override
  String yDrewShame2(String opponent, String score) {
    return '$opponent, $score. Недостаточно, и игроки это знают.';
  }

  @override
  String yDrewShame3(String opponent, String score) {
    return '$score против соперника $opponent. Два очка потеряно, не больше.';
  }

  @override
  String yDrewShame4(String opponent, String score) {
    return '$score с соперником $opponent. Два очка выброшены.';
  }

  @override
  String yDrewShame5(String opponent, String score) {
    return '$opponent нас остановили, $score. Плохой результат, как ни приукрашивай.';
  }

  @override
  String yDrewShame6(String opponent, String score) {
    return '$opponent, $score. Ничья со вкусом поражения.';
  }

  @override
  String yDrewShame7(String opponent, String score) {
    return '$score против соперника $opponent. Такие матчи надо выигрывать уверенно.';
  }

  @override
  String yDrewShame8(String opponent, String score) {
    return '$score с соперником $opponent. Позорище.';
  }

  @override
  String yDrewShame9(String opponent, String score) {
    return '$opponent нас остановили, $score. Кто за это отвечает?';
  }

  @override
  String yDrewShame10(String opponent, String score) {
    return '$opponent, $score. Если не можем обыграть их, кого мы вообще можем обыграть?';
  }

  @override
  String yDrewShame11(String opponent, String score) {
    return '$score с соперником $opponent. Их болельщики празднуют ничью с нами. Задумайтесь.';
  }

  @override
  String yTrophy0(String opponent) {
    return 'ЧЕМПИОНЫ. $opponent. Скажите это вслух.';
  }

  @override
  String yTrophy1(String opponent) {
    return 'Мы выиграли. $opponent. Я не в порядке.';
  }

  @override
  String yTrophy2(String opponent) {
    return '$opponent, и трофей едет домой.';
  }

  @override
  String yTrophy3(String opponent) {
    return 'Каждый из них – легенда. $opponent.';
  }

  @override
  String yRunnerUp0(String opponent) {
    return 'Так близко. $opponent и медаль, которая никому не нужна.';
  }

  @override
  String yRunnerUp1(String opponent) {
    return 'Второе место: $opponent. Будет жечь годами.';
  }

  @override
  String yRunnerUp2(String opponent) {
    return '$opponent: в одном матче от всего.';
  }

  @override
  String yRunnerUp3(String opponent) {
    return 'Вторые. $opponent. Передайте бутылку.';
  }

  @override
  String yEliminated0(String opponent) {
    return 'Вылетели: $opponent. Это будет болеть долго.';
  }

  @override
  String yEliminated1(String opponent) {
    return '$opponent: здесь для нас всё и закончилось.';
  }

  @override
  String yEliminated2(String opponent) {
    return 'Выбыли: $opponent. Теперь разбор полётов.';
  }

  @override
  String yEliminated3(String opponent) {
    return 'Вылет: $opponent. Кто-нибудь, объясните мне это.';
  }

  @override
  String yQualified0(String opponent) {
    return 'МЫ ЕДЕМ: $opponent.';
  }

  @override
  String yQualified1(String opponent) {
    return 'Путёвка получена: $opponent. Берите отпуск.';
  }

  @override
  String yQualified2(String opponent) {
    return '$opponent, мы едем. Никаких сомнений (сомнения были огромные).';
  }

  @override
  String yQualified3(String opponent) {
    return 'Прошли: $opponent. Самое трудное позади.';
  }

  @override
  String yGroupDrawn0(String opponent) {
    return 'Группы на $opponent разыграны. Могло быть хуже. Намного хуже.';
  }

  @override
  String yGroupDrawn1(String opponent) {
    return 'Значит, вот жеребьёвка: $opponent. Интересно.';
  }

  @override
  String yGroupDrawn2(String opponent) {
    return 'Группы $opponent известны, и наша мне уже не нравится.';
  }

  @override
  String yGroupDrawn3(String opponent) {
    return 'Жеребьёвка $opponent проведена. Пусть начнётся паника.';
  }

  @override
  String yHostNamed0(String opponent) {
    return '$opponent: хозяин назван. Начинайте копить.';
  }

  @override
  String yHostNamed1(String opponent) {
    return 'Турнир достаётся им: $opponent. Предсказуемо, но ладно.';
  }

  @override
  String yHostNamed2(String opponent) {
    return '$opponent получает турнир. Поздравляем, наверное.';
  }

  @override
  String yHostNamed3(String opponent) {
    return 'Хозяин утверждён: $opponent.';
  }

  @override
  String yTournamentSoon0(String opponent) {
    return '$opponent скоро начнётся, а я не могу усидеть на месте.';
  }

  @override
  String yTournamentSoon1(String opponent) {
    return 'До старта осталось недолго: $opponent.';
  }

  @override
  String yTournamentSoon2(String opponent) {
    return '$opponent почти здесь. Объявите состав, пожалуйста.';
  }

  @override
  String yTournamentSoon3(String opponent) {
    return 'Обратный отсчёт до турнира ($opponent) официально невыносим.';
  }

  @override
  String get navY => 'Y';

  @override
  String get yTitle => 'Y';

  @override
  String get yEmpty => 'Пока сказать нечего. Сыграй матч.';

  @override
  String get yEarlierHeading => 'Ранее в этом цикле';

  @override
  String get yTraitLoyalist =>
      'Поддерживает команду, что бы ни случилось. Медленно отворачивается, быстро прощает.';

  @override
  String get yTraitCynic => 'Ждёт худшего и рад, когда оказывается прав.';

  @override
  String get yTraitNostalgic =>
      'Раньше всё было лучше. Сравнивает тебя с теми, кто давно закончил.';

  @override
  String get yTraitStatshead => 'Публикует только цифры. Настроения почти нет.';

  @override
  String get yTraitHypeman =>
      'Два хороших результата, и это уже золотое поколение.';

  @override
  String get yTraitContrarian => 'Что бы ни думали все, он думает наоборот.';

  @override
  String get yTraitDoomer => 'Всё пойдёт не так. Всегда всё идёт не так.';

  @override
  String get yProfilePosts => 'ПОСТЫ';

  @override
  String get yProfileEmpty => 'С этого аккаунта пока ничего нет.';

  @override
  String hubEventGrievance(String player) {
    return '$player хочет поговорить';
  }

  @override
  String get hubEventGrievanceSub =>
      'Он хочет знать, на что может рассчитывать';

  @override
  String hubEventManagerSkills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count очка навыков к распределению',
      many: '$count очков навыков к распределению',
      few: '$count очка навыков к распределению',
      one: '$count очко навыков к распределению',
    );
    return '$_temp0';
  }

  @override
  String get hubEventManagerSkillsSub =>
      'Твои сильные стороны делают команду лучше';

  @override
  String get grievanceTitle => 'Разговор в кабинете';

  @override
  String grievanceGameTime(String player) {
    return '$player в заявке, но так и не вышел на поле. Он хочет знать почему.';
  }

  @override
  String grievanceSquadPlace(String player) {
    return '$player не попал в состав и не может этого понять. Он хочет ясности, так или иначе.';
  }

  @override
  String grievanceRole(String player) {
    return '$player постоянно играет не на своей позиции, и ему это надоело.';
  }

  @override
  String get grievanceReassure => 'Ты в моих планах';

  @override
  String get grievanceHonest => 'Ты позади других, и вот почему';

  @override
  String get grievanceDismiss => 'Состав выбираю я';

  @override
  String yScorerStar0(String name, int goals) {
    return '$name забил $goals. Больше никто и близко.';
  }

  @override
  String yScorerStar1(String name, int goals) {
    return '$goals у игрока $name. Он тащит команду.';
  }

  @override
  String yScorerStar2(String name, int goals) {
    return '$name: $goals за матч. Вот это игрок.';
  }

  @override
  String yScorerStar3(String name, int goals) {
    return '$name наколотил им $goals. Поклон.';
  }

  @override
  String yScorerStar4(String name, int goals) {
    return '$goals у игрока $name, а остальные были пассажирами.';
  }

  @override
  String yScorerStar5(String name, int goals) {
    return 'Опять $name. $goals. Представьте эту команду без него.';
  }

  @override
  String yScorerStar6(String name, int goals) {
    return '$goals от игрока $name. Одному человеку не должно приходиться делать столько.';
  }

  @override
  String yScorerStar7(String name, int goals) {
    return 'Убери из этого матча игрока $name, и это минус $goals и совсем другой день.';
  }

  @override
  String yWinStreak0(int count) {
    return '$count подряд. Что бы ни говорили в той раздевалке, это работает.';
  }

  @override
  String yWinStreak1(int count) {
    return 'Уже $count подряд. В такие серии случайно не попадают.';
  }

  @override
  String yWinStreak2(int count) {
    return '$count подряд, и счёт идёт. Уверенность видна с трибун.';
  }

  @override
  String yWinStreak3(int count) {
    return 'Без поражений: $count. Спросите любого тренера: это самое трудное.';
  }

  @override
  String yWinStreak4(int count) {
    return '$count подряд. Наслаждайтесь, пока календарь добрый.';
  }

  @override
  String yWinStreak5(int count) {
    return '$count подряд, и мы не обыграли никого серьёзного.';
  }

  @override
  String yWinStreak6(int count) {
    return 'Серия из $count. Спросите меня, когда её проверят на прочность.';
  }

  @override
  String yWinStreak7(int count) {
    return '$count подряд. У каждой команды хоть раз бывает такое.';
  }

  @override
  String yLossStreak0(int count) {
    return 'Уже $count без побед. Когда-то оправдания закончатся.';
  }

  @override
  String yLossStreak1(int count) {
    return 'Это $count подряд мимо. Это уже не случайность.';
  }

  @override
  String yLossStreak2(int count) {
    return '$count поражений подряд. Кто-то должен за это ответить.';
  }

  @override
  String yLossStreak3(int count) {
    return 'Без побед: $count. Это видно по их игре.';
  }

  @override
  String yLossStreak4(int count) {
    return '$count без побед и одни и те же ошибки каждую неделю.';
  }

  @override
  String yLossStreak5(int count) {
    return '$count подряд. Что бы ни пробовали, это не работает.';
  }

  @override
  String yLossStreak6(int count) {
    return '$count подряд. Это тенденция, а не спад.';
  }

  @override
  String yLossStreak7(int count) {
    return 'Без побед: $count, и наверху никто не сказал ни слова.';
  }

  @override
  String yRivalry0(String opponent, String score) {
    return '$opponent, $score. Говорите что хотите про футбол. Этот матч идёт за два.';
  }

  @override
  String yRivalry1(String opponent, String score) {
    return 'Против кого угодно, но именно против них: $opponent. $score. Здесь этого никто не забудет.';
  }

  @override
  String yRivalry2(String opponent, String score) {
    return '$score против соперника $opponent. Об этом будут говорить в барах.';
  }

  @override
  String yRivalry3(String opponent, String score) {
    return 'Соседи, $score. Право на хвастовство на время закреплено.';
  }

  @override
  String yRivalry4(String opponent, String score) {
    return '$opponent, $score. Что бы ни случилось в этом году, это у нас уже есть.';
  }

  @override
  String yRivalry5(String opponent, String score) {
    return '$score против соперника $opponent. Некоторым из нас это было нужнее, чем таблице.';
  }

  @override
  String yRivalry6(String opponent, String score) {
    return '$opponent, $score. И в следующий раз они отыграются, как всегда.';
  }

  @override
  String yRivalry7(String opponent, String score) {
    return 'Против соперника $opponent, $score. Целый год нам будут об этом напоминать.';
  }

  @override
  String yInjuryBlow0(String name) {
    return '$name ушёл с травмой. Это последнее, что было нужно команде.';
  }

  @override
  String yInjuryBlow1(String name) {
    return 'Потеря игрока $name меняет всё.';
  }

  @override
  String yInjuryBlow2(String name) {
    return '$name хромает. Затаите дыхание.';
  }

  @override
  String yInjuryBlow3(String name) {
    return 'Значит, какое-то время без игрока $name. Кто-то должен проявить себя.';
  }

  @override
  String yInjuryBlow4(String name) {
    return '$name выбыл. Ну конечно, именно $name.';
  }

  @override
  String yInjuryBlow5(String name) {
    return 'Без игрока $name это становится очень заурядной командой.';
  }

  @override
  String yInjuryBlow6(String name) {
    return '$name снова травмирован. Кто-то должен спросить почему.';
  }

  @override
  String yInjuryBlow7(String name) {
    return 'Потеряли игрока $name, а за ним никого. Вот настоящая проблема.';
  }

  @override
  String ySentOff0(String name, String minute) {
    return 'Красная для игрока $name на $minute-й минуте, и вся страна против него. Он дал нам больше многих. Оставьте его.';
  }

  @override
  String ySentOff1(String name, String minute) {
    return '$name удалён на $minute-й минуте. Жёстко. Вдесятером мы всё равно пытались, и это о многом говорит.';
  }

  @override
  String ySentOff2(String name, String minute) {
    return '$name, $minute-я минута, красная карточка. Дальше вдесятером.';
  }

  @override
  String ySentOff3(String name, String minute) {
    return 'Удаление: $name на $minute-й. Не первый матч, который решает одно решение.';
  }

  @override
  String ySentOff4(String name, String minute) {
    return 'Блестяще. $name уходит на $minute-й минуте, и мы вдесятером. Опять.';
  }

  @override
  String ySentOff5(String name, String minute) {
    return '$name удалён на $minute-й минуте. Кто тут вообще отвечает за дисциплину?';
  }

  @override
  String ySentOff6(String name, String minute) {
    return '$minute минут. Столько $name смог сохранять голову. Профессиональный футбол.';
  }

  @override
  String ySentOff7(String name, String minute) {
    return 'Красная для игрока $name на $minute-й минуте, а мне говорят, что это прогресс.';
  }

  @override
  String ySentOffAgain0(String name, String minute, String count) {
    return 'Ещё одна красная, $name на $minute-й минуте, и нас осталось $count. Каждый, кто ещё на поле, слышит мой голос.';
  }

  @override
  String ySentOffAgain1(String name, String minute, String count) {
    return 'Ещё одна красная: $name, $minute-я минута. На поле осталось $count.';
  }

  @override
  String ySentOffAgain2(String name, String minute, String count) {
    return 'Ещё одна красная. $name уходит на $minute-й минуте, и нас $count. Невероятно.';
  }

  @override
  String ySentOffAgain3(String name, String minute, String count) {
    return 'И $name тоже, на $minute-й минуте. Осталось $count. Кто-нибудь вообще руководит этой командой?';
  }

  @override
  String get yBoardPressure0 =>
      'Руководство как-то затихло. Это никогда не к добру.';

  @override
  String get yBoardPressure1 => 'Говорят, в кабинетах начали задавать вопросы.';

  @override
  String get yBoardPressure2 =>
      'Чувствуется, как наверху уходит почва из-под ног.';

  @override
  String get yBoardPressure3 =>
      'В федерации никто не говорит ни слова поддержки. Делайте выводы.';

  @override
  String get yBoardPressure4 =>
      'Уже несколько недель никто наверху публично его не поддержал.';

  @override
  String get yBoardPressure5 =>
      'Федерация работает против собственного тренера. Как всегда.';

  @override
  String get yBoardPressure6 =>
      'Когда руководство замолкает, оно уже всё решило.';

  @override
  String get yBoardPressure7 =>
      'Они будут тянуть, пока решение не придётся принимать кому-то другому.';

  @override
  String get yReplies => 'ЕЩЁ ОБ ЭТОМ МАТЧЕ';

  @override
  String get yPlayerGrievance0 =>
      'Спросил, на что могу рассчитывать. Всё ещё жду ответа.';

  @override
  String get yPlayerGrievance1 =>
      'Тренируюсь изо всех сил. Больше ничего не могу.';

  @override
  String get yPlayerGrievance2 => 'Некоторые вопросы задают только один раз.';

  @override
  String get yPlayerGrievance3 =>
      'Я не для того так далеко зашёл, чтобы носить манишки.';

  @override
  String get playerHonoursTitle => 'НАГРАДЫ';

  @override
  String get awardGoldenBall => 'Золотой мяч';

  @override
  String get awardGoldenBoot => 'Золотая бутса';

  @override
  String get awardGoldenGlove => 'Золотая перчатка';

  @override
  String get awardTeamOfTournament => 'Символическая сборная турнира';

  @override
  String get awardPlayerOfYear => 'Лучший игрок мира';

  @override
  String get awardYoungPlayerOfYear => 'Лучший молодой игрок года';

  @override
  String get playerClubHistory => 'КЛУБНАЯ ИСТОРИЯ';

  @override
  String get playerCareerRecord => 'СТАТИСТИКА КАРЬЕРЫ';

  @override
  String get playerInternationalGoals => 'Голы за сборную';

  @override
  String get playerRecentForm => 'ТЕКУЩАЯ ФОРМА';

  @override
  String get playerMatchHistory => 'ИСТОРИЯ МАТЧЕЙ';

  @override
  String get playerAttributes => 'ХАРАКТЕРИСТИКИ';

  @override
  String get playerUnknown => 'Неизвестно';

  @override
  String get playerAttrPace => 'Скорость';

  @override
  String get playerAttrPhysical => 'Физика';

  @override
  String get playerAttrTechnical => 'Техника';

  @override
  String get playerAttrShooting => 'Удар';

  @override
  String get playerAttrPassing => 'Пас';

  @override
  String get playerAttrDribbling => 'Дриблинг';

  @override
  String get playerAttrTackling => 'Отбор';

  @override
  String get playerAttrPositioning => 'Позиционирование';

  @override
  String get playerAttrComposure => 'Хладнокровие';

  @override
  String get playerAttrDecisions => 'Решения';

  @override
  String get playerAttrStamina => 'Выносливость';

  @override
  String get playerAttrStrength => 'Сила';

  @override
  String get playerStatCaps => 'Матчи';

  @override
  String get playerStatGoals => 'Голы';

  @override
  String get playerStatAssists => 'Передачи';

  @override
  String get playerStatAvgRating => 'Ср. оценка';

  @override
  String get playerStatForm => 'Форма';

  @override
  String get playerStatMotm => 'Игрок матча';

  @override
  String get playerStatCleanSheets => '«Сухие» матчи';

  @override
  String get playerStatBestGame => 'Лучший матч';

  @override
  String get playerStatCards => 'Карточки';

  @override
  String playerCardsValue(int yellows, int reds) {
    return '$yellowsЖ $redsК';
  }

  @override
  String get tourSharedYourRun => 'ТВОЙ ПУТЬ';

  @override
  String get tourSharedList => 'Список';

  @override
  String get tourSharedBracket => 'Сетка';

  @override
  String get tourSharedVs => 'против';

  @override
  String tourSharedGroupSeed(String seed) {
    return 'Группа $seed';
  }

  @override
  String get tourSharedThisEdition => 'Этот турнир';

  @override
  String get tourSharedAllTime => 'За всю историю';

  @override
  String get tourSharedUnknown => 'Неизвестно';

  @override
  String get tourSharedActive => 'ИГРАЕТ';

  @override
  String get tourSharedMedalTable => 'МЕДАЛЬНЫЙ ЗАЧЁТ';

  @override
  String get tourSharedPastWinners => 'ПРОШЛЫЕ ПОБЕДИТЕЛИ';

  @override
  String tourSharedHost(String host) {
    return 'Хозяин: $host';
  }

  @override
  String get tourSharedBeat => 'обыграли';

  @override
  String get tourSharedPens => ' (пен.)';

  @override
  String get tourSharedAwardsEmpty =>
      'Награды определятся, когда турнир будет сыгран.';

  @override
  String get tourSharedGoldenBall => 'ЗОЛОТОЙ МЯЧ';

  @override
  String get tourSharedPlayerOfTournament => 'Лучший игрок турнира';

  @override
  String get tourSharedGoldenBoot => 'ЗОЛОТАЯ БУТСА';

  @override
  String tourSharedGoalsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count гола',
      many: '$count голов',
      few: '$count гола',
      one: '$count гол',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedGoldenGlove => 'ЗОЛОТАЯ ПЕРЧАТКА';

  @override
  String get tourSharedTeamOfTournament => 'СИМВОЛИЧЕСКАЯ СБОРНАЯ ТУРНИРА';

  @override
  String get tourSharedStatsEmpty =>
      'Рекорды появятся, когда у турнира будет история.';

  @override
  String get tourSharedRecordScorer => 'РЕКОРДСМЕН ПО ГОЛАМ';

  @override
  String get tourSharedStillActive => 'ещё играет';

  @override
  String get tourSharedMostTitles => 'БОЛЬШЕ ВСЕГО ТИТУЛОВ';

  @override
  String tourSharedTitlesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count титула',
      many: '$count титулов',
      few: '$count титула',
      one: '$count титул',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostFinals => 'БОЛЬШЕ ВСЕГО ФИНАЛОВ';

  @override
  String tourSharedFinalsContested(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count финала',
      many: '$count финалов',
      few: '$count финала',
      one: '$count финал',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostGamesPlayed => 'БОЛЬШЕ ВСЕГО МАТЧЕЙ';

  @override
  String tourSharedMatchesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count матча',
      many: '$count матчей',
      few: '$count матча',
      one: '$count матч',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostFinalsPlayed => 'БОЛЬШЕ ВСЕГО ФИНАЛЬНЫХ ТУРНИРОВ';

  @override
  String tourSharedFinalsTournamentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count финального турнира',
      many: '$count финальных турниров',
      few: '$count финальных турнира',
      one: '$count финальный турнир',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedBiggestFinalWin => 'КРУПНЕЙШАЯ ПОБЕДА В ФИНАЛЕ';

  @override
  String tourStatsGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count гола',
      many: '$count голов',
      few: '$count гола',
      one: '$count гол',
    );
    return '$_temp0';
  }

  @override
  String get tourStatsStillActive => 'ещё играет';

  @override
  String tourStatsTitles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count титула',
      many: '$count титулов',
      few: '$count титула',
      one: '$count титул',
    );
    return '$_temp0';
  }

  @override
  String tourStatsFinalsContested(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count финала',
      many: '$count финалов',
      few: '$count финала',
      one: '$count финал',
    );
    return '$_temp0';
  }

  @override
  String tourStatsMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count матча',
      many: '$count матчей',
      few: '$count матча',
      one: '$count матч',
    );
    return '$_temp0';
  }

  @override
  String tourStatsFinalsTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count финального турнира',
      many: '$count финальных турниров',
      few: '$count финальных турнира',
      one: '$count финальный турнир',
    );
    return '$_temp0';
  }

  @override
  String get tourStatsLeaders => 'ЛИДЕРЫ ЗА ВСЮ ИСТОРИЮ';

  @override
  String get tourStatsTabGames => 'Матчи';

  @override
  String get tourStatsTabCups => 'Кубки';

  @override
  String get tourStatsTabScorers => 'Бомбардиры';

  @override
  String tourSharedFinalWinDetail(String opponent, int year) {
    return 'против: $opponent · $year';
  }

  @override
  String get tourHolders => 'ДЕЙСТВУЮЩИЙ ЧЕМПИОН';

  @override
  String tourHoldersSince(int year) {
    return 'победа в $year';
  }

  @override
  String get tourSharedAllTimeScorers => 'БОМБАРДИРЫ ЗА ВСЮ ИСТОРИЮ';

  @override
  String get tourSharedSummaryEmpty =>
      'Хозяин и его стадионы появятся после жеребьёвки этого турнира.';

  @override
  String get tourSharedHostHeading => 'ХОЗЯИН';

  @override
  String get tourSharedHostsHeading => 'ХОЗЯЕВА';

  @override
  String get tourSharedCoHostsHeading => 'СОХОЗЯЕВА';

  @override
  String get tourSharedVenues => 'СТАДИОНЫ';

  @override
  String get tourSharedMapHeading => 'КАРТА ХОЗЯИНА';

  @override
  String get tourSharedMapFit => 'Показать всю карту';

  @override
  String get tourSharedMapFinalVenue => 'Стадион финала';

  @override
  String get tourSharedMapTapHint => 'Нажми на метку, чтобы увидеть стадион';

  @override
  String get tourSharedMascot => 'ТАЛИСМАН';

  @override
  String get tourSharedMatchBall => 'МЯЧ ТУРНИРА';

  @override
  String tourSharedVenueSeats(String city, String capacity) {
    return '$city · $capacity мест';
  }

  @override
  String get tourSharedCouldNotLoad => 'Не удалось загрузить.';

  @override
  String get tourSharedHostTbc => 'ХОЗЯИН ЕЩЁ НЕ ОПРЕДЕЛЁН';

  @override
  String get tourSharedFinalsAreHere => 'ФИНАЛЬНЫЙ ТУРНИР НАЧИНАЕТСЯ';

  @override
  String tourSharedHostedBy(String hosts) {
    return 'ХОЗЯЕВА:  $hosts';
  }

  @override
  String get tourSharedLetFinalsBegin => 'Да начнётся финальный турнир';

  @override
  String get tourSharedCompetitions => 'ТУРНИРЫ';

  @override
  String get tourSharedWorldRanking => 'Мировой рейтинг';

  @override
  String get tourSharedCouldNotLoadTournaments =>
      'Не удалось загрузить турниры.';

  @override
  String get tourSharedPrestigeStage => 'ПРЕСТИЖНАЯ СЦЕНА';

  @override
  String get tourSharedOverview => 'Обзор';

  @override
  String get tourSharedWorldRankingTitle => 'Мировой рейтинг';

  @override
  String get tourSharedYourCompetitions => 'ТВОИ ТУРНИРЫ';

  @override
  String get tourSharedOtherContinents => 'ДРУГИЕ КОНТИНЕНТЫ';

  @override
  String get tourSharedComingSoon => 'Турнир скоро';

  @override
  String get tourSharedSoon => 'СКОРО';

  @override
  String get tourSharedNoQualifyingDraw => 'Жеребьёвки отбора нет.';

  @override
  String get tourSharedOpenEnvelope => 'Открыть конверт';

  @override
  String tourSharedGroupName(String name) {
    return 'ГРУППА $name';
  }

  @override
  String get tourSharedBall => 'Шар';

  @override
  String get tourSharedPot => 'Корзина';

  @override
  String get tourSharedAll => 'Все';

  @override
  String get tourSharedTapDrawTeam => 'Нажми, чтобы вытянуть следующую команду';

  @override
  String get tourSharedTapDrawPot => 'Нажми, чтобы разыграть следующую корзину';

  @override
  String get tourSharedTapDrawAll => 'Нажми, чтобы открыть всю жеребьёвку';

  @override
  String get tourSharedContinue => 'Продолжить';

  @override
  String get tourSharedPause => 'Пауза';

  @override
  String get tourSharedPlay => 'Играть';

  @override
  String get tourSharedSkip => 'Пропустить';

  @override
  String tourSharedPotNumber(int number) {
    return 'КОРЗИНА $number';
  }

  @override
  String get tourSharedDrawComplete => 'ЖЕРЕБЬЁВКА ЗАВЕРШЕНА';

  @override
  String get tourSharedDrawing => 'ЖЕРЕБЬЁВКА…';

  @override
  String get tourContChampionship => 'ЧЕМПИОНАТ';

  @override
  String get tourContTabSummary => 'ОБЗОР';

  @override
  String get tourContTabQualifying => 'ОТБОР';

  @override
  String get tourContTabFinals => 'ФИНАЛЬНЫЙ ТУРНИР';

  @override
  String get tourContTabBracket => 'СЕТКА';

  @override
  String get tourContTabAwards => 'НАГРАДЫ';

  @override
  String get tourContTabScorers => 'БОМБАРДИРЫ';

  @override
  String get tourContTabHistory => 'ИСТОРИЯ';

  @override
  String get tourContTabRecords => 'РЕКОРДЫ';

  @override
  String tourContCouldNotLoadCup(String error) {
    return 'Не удалось загрузить кубок.\n$error';
  }

  @override
  String get tourContNoCupData => 'Нет данных о кубке.';

  @override
  String get tourContUnknown => 'Неизвестно';

  @override
  String get tourContGroupsToBeDrawnQual =>
      'Отборочные группы разыгрываются на церемонии. Смотри из центра, чтобы узнать соперников.';

  @override
  String get tourContQualSeeded =>
      'Твоя сборная сразу попадает в финальный турнир. В этом цикле без отбора.';

  @override
  String tourContBackgroundRegion(String name) {
    return '$name симулируется в фоне. Результаты появятся здесь после каждого тура.';
  }

  @override
  String get tourContGroupsToBeDrawnFinals =>
      'Группы финального турнира разыгрываются на церемонии. Смотри из центра, чтобы узнать свою группу.';

  @override
  String get tourContFinalsDrawAfterQual =>
      'Жеребьёвка финального турнира пройдёт после завершения отбора.';

  @override
  String get tourContContestedBeforeWc =>
      'Матчи плей-офф проходят до чемпионата мира.';

  @override
  String tourContChampionsHeading(String name) {
    return 'ЧЕМПИОНЫ: $name';
  }

  @override
  String tourContWinnersTitle(String name) {
    return 'Победители: $name';
  }

  @override
  String get tourContNoGoalsYet => 'Голов пока нет.';

  @override
  String tourContGroupHeading(String name) {
    return 'ГРУППА $name';
  }

  @override
  String get tourContBestRunnersUp => 'ЛУЧШИЕ ВТОРЫЕ МЕСТА';

  @override
  String tourContGroupDropdown(String name) {
    return 'Группа $name';
  }

  @override
  String get tourContMatches => 'МАТЧИ';

  @override
  String get tourContNoGroupsDrawn => 'Группы ещё не разыграны.';

  @override
  String get tourContQualifyingDraw => 'ЖЕРЕБЬЁВКА ОТБОРА';

  @override
  String get tourContWorldQualifyingDraw => 'ЖЕРЕБЬЁВКА МИРОВОГО ОТБОРА';

  @override
  String get tourContFinalsDraw => 'ЖЕРЕБЬЁВКА ФИНАЛЬНОГО ТУРНИРА';

  @override
  String get tourContSeedingPots => 'КОРЗИНЫ ПОСЕВА';

  @override
  String get tourContGroupDraw => 'ЖЕРЕБЬЁВКА ГРУПП';

  @override
  String tourContCouldNotLoadDraw(String error) {
    return 'Не удалось загрузить жеребьёвку.\n$error';
  }

  @override
  String get tourContDrawNotReady => 'Жеребьёвка ещё не готова.';

  @override
  String get tourContContinentalClash => 'БИТВА КОНТИНЕНТОВ';

  @override
  String get tourContTabThisCycle => 'ЭТОТ ЦИКЛ';

  @override
  String tourContCouldNotLoadClash(String error) {
    return 'Не удалось загрузить.\n$error';
  }

  @override
  String get tourContNoSaveFound => 'Сохранение не найдено.';

  @override
  String get tourContClashSoon =>
      'Битва континентов играется, когда известны оба чемпиона континентов.';

  @override
  String get tourContTwoContinentsOneMatch => 'ДВА КОНТИНЕНТА, ОДИН МАТЧ';

  @override
  String get tourContVersusShort => 'против';

  @override
  String tourContWinTheClash(String name) {
    return '$name выигрывает Битву';
  }

  @override
  String get tourContNoClashYet => 'Битва континентов ещё не проводилась.';

  @override
  String get tourContNationsCup => 'КУБОК НАЦИЙ';

  @override
  String get tourContTabLeagues => 'ЛИГИ';

  @override
  String get tourContTabFinalsFour => 'ФИНАЛ ЧЕТЫРЁХ';

  @override
  String tourContCouldNotLoad(String error) {
    return 'Не удалось загрузить.\n$error';
  }

  @override
  String get tourContNoNationsCupGoals => 'Голов в Кубке наций пока нет.';

  @override
  String get tourContNoNationsCupChampions =>
      'Обладателей Кубка наций пока нет.';

  @override
  String get tourContNationsCupOffSeason =>
      'Кубок наций этого цикла начнётся после континентальных финальных турниров. Прошлые победители в разделе «История».';

  @override
  String get tourContNationsCupGroupsSoon =>
      'Группы Кубка наций этого цикла разыгрываются на церемонии. Смотри из центра, чтобы узнать соперников.';

  @override
  String get tourContLeagueNoGroups => 'В этом туре в лиге нет матчей.';

  @override
  String tourContLeagueHeading(String letter) {
    return 'ЛИГА $letter';
  }

  @override
  String tourContLeagueHeadingYours(String letter) {
    return 'ЛИГА $letter · ТВОЯ ЛИГА';
  }

  @override
  String get tourContFinalsFourSoon =>
      'В «Финале четырёх» играют победители групп лиги A после группового этапа.';

  @override
  String tourContLeagueChip(String letter) {
    return 'Лига $letter';
  }

  @override
  String tourContLeagueChipStar(String letter) {
    return 'Лига $letter ★';
  }

  @override
  String get tourContSemiFinals => 'ПОЛУФИНАЛЫ';

  @override
  String get tourContFinal => 'ФИНАЛ';

  @override
  String get tourContNationsCupDraw => 'ЖЕРЕБЬЁВКА КУБКА НАЦИЙ';

  @override
  String get tourContIntercontinentalPlayoff => 'МЕЖКОНТИНЕНТАЛЬНЫЙ ПЛЕЙ-ОФФ';

  @override
  String get tourContNoPlayoffThisCycle => 'В этом цикле плей-офф нет.';

  @override
  String get tourContPlayoffIntro =>
      'Две путёвки на чемпионат мира разыгрываются на выбывание среди лучших из не прошедших отбор.';

  @override
  String get tourContPlayoffThrough =>
      'Ты прошёл плей-офф. Ты едешь на чемпионат мира!';

  @override
  String get tourContPlayoffOut =>
      'Ты не прошёл плей-офф. В этот раз без чемпионата мира.';

  @override
  String get tourContContinue => 'Продолжить';

  @override
  String get tourContPlayoffFinals => 'ФИНАЛЫ ПЛЕЙ-ОФФ';

  @override
  String get tourContPlayoffSeeded => 'Посеян (без игры)';

  @override
  String get tourCupTabSummary => 'ОБЗОР';

  @override
  String get tourCupTabQualifying => 'ОТБОР';

  @override
  String get tourCupTabPlayoff => 'ПЛЕЙ-ОФФ';

  @override
  String get tourCupPlayoffSoon =>
      'Межконтинентальный плей-офф определится, когда завершится отбор во всех конфедерациях.';

  @override
  String get tourCupTabFinals => 'ФИНАЛЬНЫЙ ТУРНИР';

  @override
  String get tourCupTabBracket => 'СЕТКА';

  @override
  String get tourCupTabAwards => 'НАГРАДЫ';

  @override
  String get tourCupTabScorers => 'БОМБАРДИРЫ';

  @override
  String get tourCupTabHistory => 'ИСТОРИЯ';

  @override
  String get tourCupTabRecords => 'РЕКОРДЫ';

  @override
  String get tourCupTitle => 'ЧЕМПИОНАТ МИРА';

  @override
  String get tourCupNoData => 'Нет данных о турнире.';

  @override
  String tourCupLoadError(String error) {
    return 'Не удалось загрузить турнир.\n$error';
  }

  @override
  String get tourCupUnknown => 'Неизвестно';

  @override
  String get tourCupWorldChampions => 'ЧЕМПИОНЫ МИРА';

  @override
  String get tourCupWorldChampionsTitle => 'Чемпионы мира';

  @override
  String get tourCupStillActive => 'Ещё играет';

  @override
  String get tourCupAllTimeScorers => 'БОМБАРДИРЫ ЗА ВСЮ ИСТОРИЮ';

  @override
  String get tourCupAllConfederations => 'Все конфедерации';

  @override
  String get tourCupBestRunnersUp => 'Лучшие вторые места';

  @override
  String get tourCupCompWorld => 'Чемпионат мира';

  @override
  String get tourCupCompEurope => 'Чемпионат Европы';

  @override
  String get tourCupCompSAmerica => 'Кубок Южной Америки';

  @override
  String get tourCupDestRoundOf16 => '1/8 финала';

  @override
  String get tourCupDestKnockouts => 'плей-офф';

  @override
  String get tourCupDestFinals => 'финальный турнир';

  @override
  String get tourCupDestFinalsPlayoff => 'плей-офф за финальный турнир';

  @override
  String get tourCupDestIntercontPlayoff => 'межконтинентальный плей-офф';

  @override
  String get tourCupFinalsDrawnAfterQual =>
      'Жеребьёвка финального турнира пройдёт после отбора.';

  @override
  String get tourCupFinalsDrawSoon =>
      'Группы ещё не разыграны. Посмотри жеребьёвку чемпионата мира из центра, чтобы их узнать.';

  @override
  String tourCupGroupName(String name) {
    return 'Группа $name';
  }

  @override
  String tourCupGroupNameShort(String name) {
    return 'Группа $name';
  }

  @override
  String tourCupHostLabel(String host) {
    return 'Хозяин: $host';
  }

  @override
  String tourCupHostLabelMulti(String hosts) {
    return 'Хозяева: $hosts';
  }

  @override
  String get tourCupIntercontPlayoff => 'Межконтинентальный плей-офф';

  @override
  String get tourCupKnockoutSoon => 'Сетка начнётся после группового этапа.';

  @override
  String get tourCupMatches => 'МАТЧИ';

  @override
  String get tourCupMedalTable => 'МЕДАЛЬНЫЙ ЗАЧЁТ';

  @override
  String get tourCupMostTitles => 'БОЛЬШЕ ВСЕГО ТИТУЛОВ';

  @override
  String tourCupMostTitlesValue(String nation, int titles, int editions) {
    String _temp0 = intl.Intl.pluralLogic(
      titles,
      locale: localeName,
      other: '$titles титула',
      many: '$titles титулов',
      few: '$titles титула',
      one: '$titles титул',
    );
    String _temp1 = intl.Intl.pluralLogic(
      editions,
      locale: localeName,
      other: '$editions турнира',
      many: '$editions турниров',
      few: '$editions турнира',
      one: '$editions турнир',
    );
    return '$nation: $_temp0 за $_temp1';
  }

  @override
  String get tourCupNoGoals => 'Голов пока нет.';

  @override
  String get tourCupNoGroups => 'Группы не разыграны.';

  @override
  String get tourCupNoHistory => 'Истории пока нет.';

  @override
  String get tourCupPastWinners => 'ПРОШЛЫЕ ПОБЕДИТЕЛИ';

  @override
  String get tourCupPlayoffIntro =>
      'Две путёвки на чемпионат мира разыгрываются на выбывание среди лучших из не прошедших отбор.';

  @override
  String tourCupPlayoffNoEntrants(String confederation) {
    return 'У конфедерации $confederation нет плей-офф: все её путёвки разыгрываются в отборочных группах.';
  }

  @override
  String get tourCupQualDrawSoon =>
      'Группы ещё не разыграны. Посмотри жеребьёвку отбора из центра, чтобы их узнать.';

  @override
  String tourCupRegionYours(String region) {
    return '$region · твоя';
  }

  @override
  String tourCupScorePens(int home, int away) {
    return '$home–$away (пен.)';
  }

  @override
  String get tourCupSegAllTime => 'За всю историю';

  @override
  String get tourCupSegFinals => 'Финальные турниры';

  @override
  String get tourCupSegQualifying => 'Отбор';

  @override
  String get playerTraitsTitle => 'ИЗВЕСТЕН ТЕМ, ЧТО';

  @override
  String get traitBigGame => 'Игрок больших матчей';

  @override
  String get traitBigGameBlurb => 'Играет лучше в матчах на выбывание.';

  @override
  String get traitSetPiece => 'Мастер стандартов';

  @override
  String get traitSetPieceBlurb =>
      'Точнее подаёт и чаще забивает со стандартов.';

  @override
  String get traitHothead => 'Горячая голова';

  @override
  String get traitHotheadBlurb =>
      'Получает гораздо больше карточек, чем партнёры.';

  @override
  String get traitIronMan => 'Железный человек';

  @override
  String get traitIronManBlurb => 'Редко травмируется и медленнее устаёт.';

  @override
  String get traitWonderkid => 'Вундеркинд';

  @override
  String get traitWonderkidBlurb =>
      'Молод, уже хорош и продолжает быстро расти.';

  @override
  String get traitLeader => 'Лидер';

  @override
  String get traitLeaderBlurb => 'Поднимает каждого партнёра на поле.';

  @override
  String get traitPacey => 'Скоростной';

  @override
  String get traitPaceyBlurb =>
      'Взрывная скорость, угроза за спиной защитников.';

  @override
  String get traitOldHead => 'Опытный';

  @override
  String get traitOldHeadBlurb =>
      'Ветеран, чьё чтение игры переживёт его ноги.';

  @override
  String get traitWasteful => 'Расточительный';

  @override
  String get traitWastefulBlurb => 'Слишком часто мажет из хороших моментов.';

  @override
  String get objectiveWorldCup => 'Чемпионат мира';

  @override
  String get objectiveWinTournament => 'Выиграть';

  @override
  String get objectiveQualifyGeneric => 'Пробиться';

  @override
  String hubBoardObjectiveFor(String competition, String label) {
    return '$competition: $label';
  }

  @override
  String get objectiveWinWorldCup => 'Выиграть чемпионат мира';

  @override
  String get objectiveReachFinal => 'Выйти в финал';

  @override
  String get objectiveReachSemis => 'Выйти в полуфинал';

  @override
  String get objectiveReachQuarters => 'Выйти в четвертьфинал';

  @override
  String get objectiveReachKnockouts => 'Выйти в плей-офф';

  @override
  String get objectiveQualify => 'Пробиться на чемпионат мира';

  @override
  String get finishChampions => 'Чемпионы';

  @override
  String get finishRunnersUp => 'Финалисты';

  @override
  String get finishSemiFinals => 'Полуфинал';

  @override
  String get finishQuarterFinals => 'Четвертьфинал';

  @override
  String get finishRoundOf16 => '1/8 финала';

  @override
  String get finishGroupStage => 'Групповой этап';

  @override
  String get objectiveQualifyingTopHalf =>
      'Финишировать в верхней половине отборочной группы';

  @override
  String get objectiveQualifyingChallenge =>
      'Бороться за путёвку: как минимум верхняя половина группы';

  @override
  String get finishQualifyingTopHalf => 'Верхняя половина отборочной группы';

  @override
  String get finishQualifyingBottomHalf => 'Нижняя половина отборочной группы';

  @override
  String get objectiveNcWinIt => 'Выиграть Кубок наций';

  @override
  String get objectiveNcReachFinal => 'Выйти в финал Кубка наций';

  @override
  String get objectiveNcFinalsFour => 'Выйти в «Финал четырёх»';

  @override
  String get objectiveNcWinGroup => 'Выиграть группу и подняться';

  @override
  String get objectiveNcTopHalf => 'Финишировать в верхней половине группы';

  @override
  String get objectiveNcSurvive => 'Избежать вылета';

  @override
  String get objectiveNcOffTheBottom => 'Не стать последним в группе';

  @override
  String get finishNcChampions => 'Обладатели Кубка наций';

  @override
  String get finishNcFinalsFour => 'Финал четырёх';

  @override
  String get finishNcGroupWinners => 'Победители группы';

  @override
  String get finishNcTopHalf => 'Верхняя половина группы';

  @override
  String get finishNcStayedUp => 'Сохранили место';

  @override
  String get finishNcClearOfBottom => 'Не последние в группе';

  @override
  String get finishNcBottom => 'Последние в группе';

  @override
  String get careerNationsCupLabel => 'Кубок наций';

  @override
  String get squadDevPlayer => 'ИГРОК';

  @override
  String get squadDevAge => 'ВОЗР.';

  @override
  String get squadDevPosition => 'ПОЗ';

  @override
  String get squadDevChange => 'РЕЙТИНГ';

  @override
  String get squadDevNew => 'НОВЫЙ';

  @override
  String get squadDevRetired => 'ЗАВЕРШИЛ';

  @override
  String get squadDevEmpty => 'Спокойный год. Изменений в составе нет.';

  @override
  String get squadDevTierRegulars => 'ОСНОВА';

  @override
  String get squadDevTierFringe => 'РЕЗЕРВ';

  @override
  String get squadDevTierYouth => 'МОЛОДЁЖЬ';

  @override
  String get boardObjectivesTitle => 'Задачи руководства';

  @override
  String get boardObjectivesConfidence => 'Доверие руководства';

  @override
  String boardObjectiveBeatenBy(String result, int rounds) {
    String _temp0 = intl.Intl.pluralLogic(
      rounds,
      locale: localeName,
      other: 'на $rounds раунда лучше задачи',
      many: 'на $rounds раундов лучше задачи',
      few: 'на $rounds раунда лучше задачи',
      one: 'на $rounds раунд лучше задачи',
    );
    return '$result: $_temp0';
  }

  @override
  String boardObjectiveShortBy(String result, int rounds) {
    String _temp0 = intl.Intl.pluralLogic(
      rounds,
      locale: localeName,
      other: 'на $rounds раунда не дотянули',
      many: 'на $rounds раундов не дотянули',
      few: 'на $rounds раунда не дотянули',
      one: 'на $rounds раунд не дотянули',
    );
    return '$result: $_temp0';
  }

  @override
  String get boardObjectivesPending => 'ЕЩЁ НЕ РЕШЕНО';

  @override
  String boardObjectiveSoFar(String result) {
    return 'ПОКА ЧТО · $result';
  }

  @override
  String get boardObjectivesEmpty =>
      'Руководство не поставило задачу на этот цикл.';

  @override
  String get tourContBestWinners => 'ЛУЧШИЕ ПОБЕДИТЕЛИ ГРУПП';

  @override
  String tourNcWinnersUp(int count, String league) {
    return 'Первые $count поднимаются в лигу $league';
  }

  @override
  String get tourContBestThirds => 'ЛУЧШИЕ ТРЕТЬИ МЕСТА';

  @override
  String tourContBestPlaced(String position) {
    return 'ЛУЧШИЕ НА $position-М МЕСТЕ';
  }

  @override
  String squadDevPageOf(String page, String pages, int total) {
    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: '$total игрока',
      many: '$total игроков',
      few: '$total игрока',
      one: '$total игрок',
    );
    return '$page/$pages · $_temp0';
  }

  @override
  String get matchSoldOut => 'АНШЛАГ';

  @override
  String matchAttendanceOf(String attendance, String capacity) {
    return 'Заполнено $attendance из $capacity мест';
  }

  @override
  String get matchGroundTitle => 'СТАДИОН';

  @override
  String get absenceInjured => 'Травма';

  @override
  String get absenceSuspended => 'Дисквалификация';

  @override
  String absenceWeeks(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString недели',
      many: '$countString недель',
      few: '$countString недели',
      one: '$countString неделя',
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
      other: '$countString матча',
      many: '$countString матчей',
      few: '$countString матча',
      one: '$countString матч',
    );
    return '$_temp0';
  }

  @override
  String absenceBackFor(String opponent) {
    return 'Вернётся к матчу: $opponent';
  }

  @override
  String get penaltyOrderTitle => 'Пенальти';

  @override
  String get penaltyOrderBlurb =>
      'Назови пятерых исполнителей по порядку. Нажми на позицию, чтобы изменить.';

  @override
  String penaltyOrderPick(int number) {
    return 'Удар $number';
  }

  @override
  String get penaltyOrderPickBlurb =>
      'Выбери, кто подойдёт к мячу. Полоска – это хладнокровие на точке.';

  @override
  String get penaltyOrderConfirm => 'Бить';

  @override
  String get penaltyOrderCancel => 'Назад';

  @override
  String get youthTitle => 'Молодёжь';

  @override
  String get youthEmptyLevel => 'На этом уровне пока никого.';

  @override
  String get youthReleased => 'Отчислены в этом году';

  @override
  String get u21Title => 'До 21 года';

  @override
  String get u21Blurb =>
      'Следующее поколение, лучшие впереди. Пустые звёзды – оценка скаута. Вызови игрока, чтобы узнать, на что он способен.';

  @override
  String get u21Empty =>
      'Сейчас в пуле нет никого младше 21. Новый набор придёт с новым циклом.';

  @override
  String u21Breakout(int gain) {
    return '+$gain ЗА ГОД';
  }

  @override
  String u21AgeCaps(int age, int caps) {
    String _temp0 = intl.Intl.pluralLogic(
      caps,
      locale: localeName,
      other: '$caps матча',
      many: '$caps матчей',
      few: '$caps матча',
      one: '$caps матч',
    );
    return 'Возраст $age · $_temp0';
  }

  @override
  String u21AgeUncapped(int age) {
    return 'Возраст $age · без матчей';
  }

  @override
  String get u21CallUps => 'К вызовам';

  @override
  String get youthWatching => 'Под наблюдением';

  @override
  String get youthWatchEmpty =>
      'Пока никто не отмечен. Отметь парня на любом уровне, и он появится здесь вместе с тем, кем он стал с тех пор.';

  @override
  String get youthWatchMark => 'Следить за ним';

  @override
  String get youthWatchUnmark => 'Перестать следить';

  @override
  String youthWatchMarked(int rating, int age) {
    return 'Отмечен с рейтингом $rating в $age лет';
  }

  @override
  String get youthWatchSenior => 'Перешёл в основной пул';

  @override
  String get youthWatchReleased => 'Отчислен из академии';

  @override
  String get youthWatchGone => 'Больше не в системе';

  @override
  String get tacticsYouth => 'До 21 года';

  @override
  String get pressSquad => 'Команда';

  @override
  String get pressBoard => 'Руководство';

  @override
  String get pressNoEffect => 'Никто не придаёт этому значения';

  @override
  String get matchNeutralGround => 'НЕЙТРАЛЬНОЕ ПОЛЕ';

  @override
  String get matchExtraTimeAhead => 'ДОПОЛНИТЕЛЬНОЕ ВРЕМЯ';

  @override
  String get matchExtraTimeHalf => 'ДОП. ВРЕМЯ · ПЕРЕРЫВ';

  @override
  String get matchClockFullTime => 'МАТЧ ОКОНЧЕН';

  @override
  String get matchClockAfterExtraTime => 'ПОСЛЕ ДОП. ВРЕМЕНИ';

  @override
  String get matchClockPenalties => 'ПЕНАЛЬТИ';

  @override
  String get pitchScoreboardGoal => 'ГОЛ';

  @override
  String get matchClockFullTimePenalties => 'МАТЧ ОКОНЧЕН · ПЕНАЛЬТИ';

  @override
  String get hubEventPressConference => 'Выйти к прессе';

  @override
  String get hubEventPressConferenceSub =>
      'Мировые СМИ хотят поговорить перед следующим матчем';

  @override
  String get squadDevWonderkid => 'ВУНДЕРКИНД';

  @override
  String get tacticsPlaystyle => 'Стиль игры';

  @override
  String get tacticsPlaystyleBlurb =>
      'Выбери, как играет команда; регуляторы ниже уточнят детали.';

  @override
  String get tacticsPlaystyleCustom =>
      'Твои собственные настройки. Ни один стиль не совпадает с этими регуляторами.';

  @override
  String get playstyleCustom => 'Свой';

  @override
  String get playstyleBalanced => 'Баланс';

  @override
  String get playstylePossession => 'Владение';

  @override
  String get playstyleGegenpress => 'Гегенпрессинг';

  @override
  String get playstyleCounter => 'Контратаки';

  @override
  String get playstyleDirect => 'Прямой';

  @override
  String get playstyleLowBlock => 'Низкий блок';

  @override
  String get playstyleWingPlay => 'Фланги';

  @override
  String get playstyleBalancedBlurb =>
      'Надёжно в обеих половинах поля, без перегибов.';

  @override
  String get playstylePossessionBlurb =>
      'Держать мяч, терпеливо его гонять, сжимать поле.';

  @override
  String get playstyleGegenpressBlurb =>
      'Отбирать мяч сразу после потери, высоко на чужой половине.';

  @override
  String get playstyleCounterBlurb =>
      'Отойти, сохранять компактность, затем стремительно в атаку.';

  @override
  String get playstyleDirectBlurb => 'Сразу вперёд и борьба за подборы.';

  @override
  String get playstyleLowBlockBlurb => 'Глубоко, узко, и вскрыть очень трудно.';

  @override
  String get playstyleWingPlayBlurb =>
      'Растянуть поле, обойти по флангу и навесить.';

  @override
  String get nationsRandomTeam => 'Случайная сборная';

  @override
  String get nationsFromTheBottom => 'С самого низа';

  @override
  String get bottomStartTitle => 'Без работы';

  @override
  String get bottomStartHeading => 'С тобой хотят поговорить три федерации';

  @override
  String get bottomStartBlurb =>
      'У тебя нет ни работы, ни репутации. Только эти сборные готовы рискнуть. Выбери одну и построй что-то из ничего.';

  @override
  String get bottomStartAccept => 'Согласиться';

  @override
  String get bottomStartBack => 'В меню';

  @override
  String bottomStartRankOf(int rank, int total) {
    return '$rank из $total в мире';
  }

  @override
  String get campTitle => 'Базовый лагерь';

  @override
  String campBasedIn(String host) {
    return 'База: $host';
  }

  @override
  String get campBlurb =>
      'Здесь команда живёт весь турнир. После старта его не поменять, и он влияет на три вещи в каждом матче: насколько свежими игроки приезжают, как быстро заживают травмы и насколько они остры.';

  @override
  String get campEffectTravel => 'Свежесть';

  @override
  String get campEffectRecovery => 'Заживление травм';

  @override
  String get campEffectSharpness => 'Игровой тонус';

  @override
  String get campTerrainCity => 'Центр города';

  @override
  String get campTerrainCoastal => 'Морской курорт';

  @override
  String get campTerrainMountain => 'Горное убежище';

  @override
  String get campTerrainAltitude => 'Высокогорный лагерь';

  @override
  String get campTerrainNationalCentre => 'Национальный центр';

  @override
  String get campTerrainCityBlurb =>
      'Всё под рукой и никуда не надо ехать, но ни покоя, ни спасения от шума.';

  @override
  String get campTerrainCoastalBlurb =>
      'Спокойно, удобно и хорошо для настроения; долгая дорога на автобусе до каждого стадиона.';

  @override
  String get campTerrainMountainBlurb =>
      'Прохладный воздух и первоклассная медицина, которая быстро ставит на ноги, но далеко от турнира.';

  @override
  String get campTerrainAltitudeBlurb =>
      'Тренироваться тяжело, зато ноги не подведут до самого конца турнира.';

  @override
  String get campTerrainNationalCentreBlurb =>
      'Собственная база федерации: ничего особенного, но и сломаться нечему.';

  @override
  String get hubEventChooseCamp => 'Выбери базовый лагерь';

  @override
  String hubEventChooseCampSub(String host) {
    return 'Где будет жить команда, хозяин: $host';
  }

  @override
  String get tacticsTabBench => 'Скамейка';

  @override
  String get squadSearchHint => 'Поиск по имени или клубу';

  @override
  String get squadFilterAll => 'Все';

  @override
  String get squadFilterInSquad => 'В составе';

  @override
  String get squadFilterUncapped => 'Без матчей';

  @override
  String get squadFilterUnavailable => 'Недоступны';

  @override
  String get squadLineAll => 'Все линии';

  @override
  String get squadSortBy => 'Сортировка';

  @override
  String get squadSortRating => 'Рейтинг';

  @override
  String get squadSortCaps => 'Матчи';

  @override
  String get squadSortGoals => 'Голы';

  @override
  String get squadSortAge => 'Возраст';

  @override
  String get squadSortName => 'Имя';

  @override
  String get squadLegendTitle => 'Что значат отметки';

  @override
  String get squadLegendStarting => 'В стартовом составе';

  @override
  String get squadLegendCalledUp => 'Вызван, на скамейке';

  @override
  String get squadLegendInjured => 'Травмирован, недоступен';

  @override
  String get squadLegendSuspended => 'Дисквалифицирован, недоступен';

  @override
  String get squadLegendTired =>
      'Устал (жёлтый) или без сил (красный): дай ему отдохнуть матч';

  @override
  String get squadLegendShift =>
      'Собственное изменение рейтинга к следующему матчу (форма, здоровье, клуб)';

  @override
  String get squadLegendTraits => 'ИЗВЕСТЕН ТЕМ, ЧТО';

  @override
  String squadShowingOf(int shown, int total) {
    return 'Показано $shown из $total игроков';
  }

  @override
  String get squadNobodyMatches => 'Под эти фильтры никто не подходит.';

  @override
  String get squadStatPool => 'Пул';

  @override
  String get squadStatInSquad => 'Вызваны';

  @override
  String get squadMostCapped => 'Больше всего матчей';

  @override
  String get squadTopScorer => 'Лучший бомбардир';

  @override
  String squadCapsValue(String name, int caps) {
    String _temp0 = intl.Intl.pluralLogic(
      caps,
      locale: localeName,
      other: '$caps матча',
      many: '$caps матчей',
      few: '$caps матча',
      one: '$caps матч',
    );
    return '$name · $_temp0';
  }

  @override
  String squadGoalsValue(String name, int goals) {
    String _temp0 = intl.Intl.pluralLogic(
      goals,
      locale: localeName,
      other: '$goals гола',
      many: '$goals голов',
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
  String get squadCapsShort => 'Матчи';

  @override
  String get squadGoalsShort => 'Голы';

  @override
  String get recordsRecordBookSubtitle =>
      'Матчи, голы и главные рекорды команды';

  @override
  String get statsLegacy => 'НАСЛЕДИЕ';

  @override
  String tacticsSubAlreadyOff(String name) {
    return '$name уже заменён и не может вернуться.';
  }

  @override
  String tacticsSubSentOff(String name) {
    return '$name удалён и больше не участвует в матче.';
  }

  @override
  String get tacticsInjuredShort => 'ТРАВМА';

  @override
  String get tacticsSuspendedShort => 'ДИСКВ.';

  @override
  String get confEurope => 'Европа';

  @override
  String get confSouthAmerica => 'Южная Америка';

  @override
  String get confNorthAmerica => 'Северная Америка';

  @override
  String get confAfrica => 'Африка';

  @override
  String get confAsia => 'Азия';

  @override
  String get confOceania => 'Океания';

  @override
  String get compWorldCup => 'Чемпионат мира';

  @override
  String get compWorldCupFinals => 'Финальный турнир чемпионата мира';

  @override
  String get compWorldCupQualifying => 'Отбор чемпионата мира';

  @override
  String compQualifiers(String region) {
    return 'Отбор: $region';
  }

  @override
  String get compFriendlies => 'Товарищеские матчи';

  @override
  String get compNationsCup => 'Кубок наций';

  @override
  String get compContinentalClash => 'Битва континентов';

  @override
  String get compIntercontinentalPlayoff => 'Межконтинентальный плей-офф';

  @override
  String get compContinentalChampionship => 'Континентальный чемпионат';

  @override
  String get compEuropeanChampionship => 'Чемпионат Европы';

  @override
  String get compSouthAmericaCup => 'Кубок Южной Америки';

  @override
  String get compAfricanChampionship => 'Чемпионат Африки';

  @override
  String get compAsianChampionship => 'Чемпионат Азии';

  @override
  String get compNorthAmericaCup => 'Кубок Северной Америки';

  @override
  String get compOceaniaCup => 'Кубок Океании';

  @override
  String get msgANation => 'Сборная';

  @override
  String get msgAPlayer => 'Игрок';

  @override
  String get msgAHostNation => 'страна-хозяйка';

  @override
  String get msgCycleTitle1 => 'Начинается новый цикл';

  @override
  String msgCycleTitle2(int year) {
    return 'Открыт путь к $year';
  }

  @override
  String get msgCycleTitle3 => 'Новая кампания';

  @override
  String get msgCycleTitle4 => 'Снова за работу';

  @override
  String msgCycleBody1(int year) {
    return 'Путь к чемпионату мира $year начинается здесь.';
  }

  @override
  String msgCycleBody2(int year) {
    return 'Новый цикл. Цель: чемпионат мира $year.';
  }

  @override
  String msgCycleBody3(int year) {
    return 'Четыре года до чемпионата мира $year. Работа начинается сейчас.';
  }

  @override
  String msgCycleBody4(int year) {
    return 'Кампания $year начинается сегодня.';
  }

  @override
  String msgContHostTitle(String cup, String host) {
    return '$cup, хозяин: $host';
  }

  @override
  String msgContHostBody(String host, String cup) {
    return '$host примет следующий турнир: $cup.';
  }

  @override
  String msgContQualDrawTitle(String cup) {
    return '$cup: жеребьёвка отбора';
  }

  @override
  String msgContQualDrawBody(String cup) {
    return 'Отборочные группы разыграны: $cup.';
  }

  @override
  String msgWcHostTitle(String host, int year) {
    return 'Чемпионат мира $year, хозяин: $host';
  }

  @override
  String msgWcHostBody(String host, int year) {
    return '$host примет чемпионат мира $year.';
  }

  @override
  String get msgWcQualDrawTitle => 'Жеребьёвка отбора чемпионата мира';

  @override
  String get msgWcQualDrawBody =>
      'Отборочные группы чемпионата мира разыграны.';

  @override
  String msgContFinalsDrawTitle(String cup) {
    return '$cup: жеребьёвка финального турнира';
  }

  @override
  String msgContFinalsDrawBody(String cup) {
    return 'Группы финального турнира разыграны: $cup.';
  }

  @override
  String get msgWcFinalsDrawTitle =>
      'Жеребьёвка финального турнира чемпионата мира';

  @override
  String msgWcFinalsDrawBody(int year) {
    return 'Жеребьёвка финального турнира чемпионата мира $year проведена.';
  }

  @override
  String get msgQualWcTitle1 => 'Мы на чемпионате мира';

  @override
  String get msgQualWcTitle2 => 'Путёвка на чемпионат мира';

  @override
  String get msgQualWcTitle3 => 'Мы едем на чемпионат мира';

  @override
  String get msgQualWcTitle4 => 'Билет в кармане';

  @override
  String msgQualWcBody1(int year) {
    return 'Ты пробился в финальный турнир чемпионата мира $year.';
  }

  @override
  String msgQualWcBody2(int year) {
    return 'Официально: твоя сборная едет на чемпионат мира $year.';
  }

  @override
  String msgQualWcBody3(int year) {
    return 'Место на чемпионате мира $year обеспечено.';
  }

  @override
  String msgQualWcBody4(int year) {
    return 'Ты вышел в финальный турнир чемпионата мира $year.';
  }

  @override
  String msgQualContTitle1(String cup) {
    return 'Путёвка: $cup';
  }

  @override
  String msgQualContTitle2(String cup) {
    return '$cup: место забронировано';
  }

  @override
  String msgQualContTitle3(String cup) {
    return 'Пробились: $cup';
  }

  @override
  String msgQualContBody1(String cup) {
    return 'Ты пробился в финальный турнир: $cup.';
  }

  @override
  String msgQualContBody2(String cup) {
    return 'Твоя сборная обеспечила себе место: $cup.';
  }

  @override
  String msgQualContBody3(String cup) {
    return 'Ты прошёл отбор: $cup.';
  }

  @override
  String msgChampTitleMine1(String comp) {
    return '$comp: МЫ ЧЕМПИОНЫ!';
  }

  @override
  String msgChampTitleMine2(String comp) {
    return 'Чемпионы! $comp';
  }

  @override
  String msgChampTitleMine3(String comp) {
    return 'Ты выиграл: $comp!';
  }

  @override
  String msgChampTitleOther1(String comp) {
    return '$comp: всё решено';
  }

  @override
  String msgChampTitleOther2(String comp) {
    return '$comp: чемпион коронован';
  }

  @override
  String msgChampTitleOther3(String comp) {
    return '$comp: турнир выигран';
  }

  @override
  String msgChampBodyMine1(String comp, String loser, String result, int year) {
    return 'Твоя сборная – чемпион: $comp $year. Побеждён соперник $loser$result.';
  }

  @override
  String msgChampBodyMine2(String comp, String loser, String result, int year) {
    return 'Ты выиграл: $comp $year. В финале повержен соперник $loser$result.';
  }

  @override
  String msgChampBodyMine3(String comp, String loser, String result, int year) {
    return '$comp $year твой. Соперник $loser обыгран$result.';
  }

  @override
  String msgChampBodyOther1(
    String winner,
    String comp,
    String loser,
    String result,
    int year,
  ) {
    return '$winner выигрывает: $comp $year. Побеждён соперник $loser$result.';
  }

  @override
  String msgChampBodyOther2(
    String winner,
    String comp,
    String loser,
    String result,
    int year,
  ) {
    return '$winner – чемпион: $comp $year. Повержен соперник $loser$result.';
  }

  @override
  String msgFinalScoreSuffix(int home, int away) {
    return ' ($home–$away в финале)';
  }

  @override
  String msgFinalPensSuffix(int home, int away) {
    return ' (по пенальти после $home–$away в финале)';
  }

  @override
  String get msgWpotyTitle => 'Лучший игрок мира';

  @override
  String msgWpotyBodyMine(String name, String nation, int year) {
    return '$name ($nation) признан лучшим игроком мира $year года, и он твой.';
  }

  @override
  String msgWpotyBodyOther(String name, String nation, int year) {
    return '$name ($nation) признан лучшим игроком мира $year года.';
  }

  @override
  String get msgYpotTitle => 'Лучший молодой игрок турнира';

  @override
  String msgYpotBodyMine(String name, String nation, int age, int year) {
    return '$name ($nation), $age лет, признан лучшим молодым игроком турнира $year, и он твой.';
  }

  @override
  String msgYpotBodyOther(String name, String nation, int age, int year) {
    return '$name ($nation), $age лет, признан лучшим молодым игроком турнира $year.';
  }

  @override
  String msgRankHold1(int rank) {
    return 'Ты остаёшься на #$rank.';
  }

  @override
  String msgRankHold2(int rank) {
    return 'Без изменений, всё ещё #$rank.';
  }

  @override
  String msgRankHold3(int rank) {
    return 'Стабильно на #$rank.';
  }

  @override
  String msgRankUp1(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move места',
      many: '$move мест',
      few: '$move места',
      one: '$move место',
    );
    return 'Всего подъём на $_temp0, до #$rank.';
  }

  @override
  String msgRankUp2(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move позиции',
      many: '$move позиций',
      few: '$move позиции',
      one: '$move позицию',
    );
    return 'Рост на $_temp0 поднимает тебя на #$rank.';
  }

  @override
  String msgRankUp3(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move места',
      many: '$move мест',
      few: '$move места',
      one: '$move место',
    );
    return 'Выше на $_temp0, теперь #$rank.';
  }

  @override
  String msgRankDown1(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move места',
      many: '$move мест',
      few: '$move места',
      one: '$move место',
    );
    return 'Всего падение на $_temp0, до #$rank.';
  }

  @override
  String msgRankDown2(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move позиции',
      many: '$move позиций',
      few: '$move позиции',
      one: '$move позицию',
    );
    return 'Спад на $_temp0 опускает тебя на #$rank.';
  }

  @override
  String msgRankDown3(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move места',
      many: '$move мест',
      few: '$move места',
      one: '$move место',
    );
    return 'Ниже на $_temp0, теперь #$rank.';
  }

  @override
  String get msgRankLeadYou => 'Ты первый в мире.';

  @override
  String msgRankLeadOther(String nation) {
    return 'Первое место в мире: $nation.';
  }

  @override
  String msgRankTitle(int rank) {
    return 'Мировой рейтинг · #$rank';
  }

  @override
  String msgRankBody(String lead, String movement) {
    return 'Мировой рейтинг обновлён. $lead $movement';
  }

  @override
  String msgRankJumpTitleUp(int rank) {
    return 'Подъём на #$rank';
  }

  @override
  String msgRankJumpTitleDown(int rank) {
    return 'Падение на #$rank';
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
      many: '$move мест',
      few: '$move места',
      one: '$move место',
    );
    return '$tournament сдвинул мировой рейтинг. $nation: до турнира #$from, после #$to, подъём на $_temp0.';
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
      many: '$move мест',
      few: '$move места',
      one: '$move место',
    );
    return '$tournament сдвинул мировой рейтинг. $nation: до турнира #$from, после #$to, падение на $_temp0.';
  }

  @override
  String get rankingSinceWcDraw => 'С жеребьёвки чемпионата мира';

  @override
  String get rankingSinceCycleStart => 'С начала кампании';

  @override
  String rankingMovedFromTo(int from, int now) {
    return 'С #$from на #$now';
  }

  @override
  String get rankingSinceWcDrawShort => 'с жеребьёвки ЧМ';

  @override
  String get rankingSinceCycleStartShort => 'за кампанию';

  @override
  String get rankingTrend => 'Динамика рейтинга';

  @override
  String msgCapsTitle(String name, int count) {
    return '$name: $count матчей за сборную';
  }

  @override
  String msgCapsBody(String name, int count) {
    return '$name провёл уже $count матчей за твою сборную.';
  }

  @override
  String msgGoalsTitle(String name, int count) {
    return '$name: $count голов за сборную';
  }

  @override
  String msgGoalsBody(String name, int count) {
    return '$name забил $count голов за твою сборную.';
  }

  @override
  String msgDevTitle(int year) {
    return 'Развитие состава · $year';
  }

  @override
  String msgThroughTitle(int year) {
    return 'Выпуск академии · $year';
  }

  @override
  String get msgThroughNote =>
      'Это не новый набор. Это ребята, пришедшие в одиннадцать лет, которые теперь доросли до основного пула.';

  @override
  String msgNewFacesTitle(int year) {
    return 'Новые лица · $year';
  }

  @override
  String get msgIntakeNoteAcademy =>
      'Вложения в академию дают плоды: этот набор пришёл сильнее, чем мог бы.';

  @override
  String get msgIntakeNoteStanding =>
      'Страна следит за этой командой: сборная поднимается в мировом рейтинге, лучшие мальчишки выбирают футбол, и этот набор пришёл от этого сильнее.';

  @override
  String get msgIntakeNoteBoth =>
      'Деньги академии и подъём сборной в мировом рейтинге дают плоды: этот набор пришёл сильнее, чем мог бы.';

  @override
  String msgIntakeTitle(int year) {
    return 'Набор в академию · $year';
  }

  @override
  String msgRetireCaptainTitle(String name) {
    return 'Твой капитан $name завершает карьеру';
  }

  @override
  String msgRetireTitle(String name) {
    return '$name завершает карьеру в сборной';
  }

  @override
  String msgRetireBody(String name, int age) {
    return '$name завершил карьеру в сборной в $age лет.';
  }

  @override
  String msgRetireBodyWith(String name, String tally, int age) {
    return '$name завершил карьеру в сборной в $age лет, итог: $tally.';
  }

  @override
  String msgTallyCaps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count матча',
      many: '$count матчей',
      few: '$count матча',
      one: '$count матч',
    );
    return '$_temp0';
  }

  @override
  String msgTallyGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count гола',
      many: '$count голов',
      few: '$count гола',
      one: '$count гол',
    );
    return '$_temp0';
  }

  @override
  String get msgArmbandVacant =>
      ' Капитанская повязка свободна. Назначь нового капитана на экране вызовов.';

  @override
  String msgHofTitle(String name) {
    return '$name введён в Зал славы';
  }

  @override
  String msgHofBody(String name, int caps, int goals) {
    String _temp0 = intl.Intl.pluralLogic(
      caps,
      locale: localeName,
      other: '$caps матча',
      many: '$caps матчей',
      few: '$caps матча',
      one: '$caps матч',
    );
    String _temp1 = intl.Intl.pluralLogic(
      goals,
      locale: localeName,
      other: '$goals гола',
      many: '$goals голов',
      few: '$goals гола',
      one: '$goals гол',
    );
    return '$name вошёл в Зал славы твоей сборной ($_temp0, $_temp1). Смотри раздел «Легенды».';
  }

  @override
  String hubBanTitle(String name) {
    return '$name дисквалифицирован';
  }

  @override
  String hubBanBody(String name, String how, int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: '$matches следующего матча',
      many: '$matches следующих матчей',
      few: '$matches следующих матча',
      one: '$matches следующий матч',
    );
    return '$name $how и пропустит $_temp0. Выбрать его будет нельзя.';
  }

  @override
  String get hubBanHowSecondYellow => 'удалён за вторую жёлтую';

  @override
  String get hubBanHowViolent => 'получил прямую красную за грубость';

  @override
  String get hubBanHowRed => 'удалён';

  @override
  String hubInjuryTitle(String name) {
    return '$name травмирован';
  }

  @override
  String hubInjuryBody(String name, int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: '$matches матча',
      many: '$matches матчей',
      few: '$matches матча',
      one: '$matches матч',
    );
    return '$name получил повреждение и пропустит $_temp0.';
  }

  @override
  String get hubRunnerUpTitle1 => 'Финалисты';

  @override
  String get hubRunnerUpTitle2 => 'Так близко и так далеко';

  @override
  String get hubRunnerUpTitle3 => 'Серебряные медали';

  @override
  String hubRunnerUpBody1(String cup, String opponent) {
    return 'Ты дошёл до финала ($cup), но уступил сопернику $opponent. Так близко. В этот раз серебро.';
  }

  @override
  String hubRunnerUpBody2(String cup, String opponent) {
    return 'Поражение от соперника $opponent в финале ($cup). Второе место, мучительно близко.';
  }

  @override
  String hubRunnerUpBody3(String cup, String opponent) {
    return 'Финал ($cup) ускользнул в матче с соперником $opponent. Есть чем гордиться, но без трофея.';
  }

  @override
  String get hubKnockedOutTitle1 => 'Вылет';

  @override
  String get hubKnockedOutTitle2 => 'Конец пути';

  @override
  String get hubKnockedOutTitle3 => 'Путешествие окончено';

  @override
  String hubKnockedOutBody1(String cup, String opponent, String stage) {
    return '$cup: ты выбыл, уступив сопернику $opponent. Стадия: $stage.';
  }

  @override
  String hubKnockedOutBody2(String cup, String opponent, String stage) {
    return '$opponent завершает твой турнир ($cup). Стадия: $stage.';
  }

  @override
  String hubKnockedOutBody3(String cup, String opponent, String stage) {
    return '$cup для тебя окончен. Стадия: $stage, поражение от соперника $opponent.';
  }

  @override
  String get hubGroupExitTitle1 => 'Вылет из группы';

  @override
  String get hubGroupExitTitle2 => 'Выбыли на групповом этапе';

  @override
  String get hubGroupExitTitle3 => 'Ранний душ';

  @override
  String hubGroupExitBody1(String cup) {
    return '$cup: всё закончилось на групповом этапе. До плей-офф не хватило.';
  }

  @override
  String hubGroupExitBody2(String cup) {
    return 'Ты не вышел из группы. $cup для тебя окончен.';
  }

  @override
  String hubGroupExitBody3(String cup) {
    return 'В этот раз без плей-офф. $cup: выбыли на групповом этапе.';
  }

  @override
  String boardObjectiveMetTitle(String comp) {
    return 'Задача выполнена: $comp';
  }

  @override
  String boardObjectiveMissedTitle(String comp) {
    return 'Задача провалена: $comp';
  }

  @override
  String boardObjectiveMetBody(String comp, String demand, String finish) {
    return 'Цель руководства на турнире ($comp): $demand. Твой результат: $finish. Они получили то, что просили.';
  }

  @override
  String boardObjectiveMissedBody(String comp, String demand, String finish) {
    return 'Цель руководства на турнире ($comp): $demand. Твой результат: $finish. Это ниже ожиданий.';
  }

  @override
  String get newsWcMissTitle => 'Мечта о чемпионате мира окончена';

  @override
  String newsWcMissBody(int year) {
    return 'Ты не попал на чемпионат мира $year. Отборочный цикл провален. Ещё четыре года.';
  }

  @override
  String get newsRecordScorerTitle => 'Лучший бомбардир в истории';

  @override
  String newsRecordScorerBody(String name, int goals) {
    return '$name теперь лучший бомбардир в истории игры: $goals голов.';
  }

  @override
  String get newsRecordCapsTitle => 'Рекордсмен по матчам';

  @override
  String newsRecordCapsBody(String name, int caps) {
    return '$name теперь рекордсмен игры по числу матчей: $caps.';
  }

  @override
  String get newsARecordBreaker => 'Новый рекордсмен';

  @override
  String newsTransferTitle(String name, String club) {
    return '$name переходит в $club';
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
    return '$name ($position, $rating) покинул $fromClub и подписал контракт с $destination. Сумма: $fee.';
  }

  @override
  String newsTransferAbroad(String club, String country) {
    return '$club ($country)';
  }

  @override
  String get newsTransferFree => 'Бесплатно';

  @override
  String newsNatzStarTitle(String name, String nation) {
    return '$name готов сменить сборную: $nation!';
  }

  @override
  String newsNatzTitle(String name, String nation) {
    return '$name хочет играть за сборную: $nation';
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
    return '$name, $age лет, $position с рейтингом $rating, сейчас в сборной $fromNation, имеет семейные корни ($nation) и открыт к переходу. Открой предложение о натурализации, чтобы принять или отказать.';
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
    return '$name, $age лет, $position с рейтингом $rating, сейчас в сборной $fromNation, звёздное имя с семейными корнями ($nation), открыт к переходу. Открой предложение о натурализации, чтобы принять или отказать.';
  }

  @override
  String get newsTheirNation => 'их сборная';

  @override
  String get newsYourNation => 'твоя сборная';

  @override
  String get tourStatusChampions => 'ЧЕМПИОНЫ';

  @override
  String get tourStatusFinals => 'ФИНАЛЬНЫЙ ТУРНИР';

  @override
  String get tourStatusQualifying => 'ОТБОР';

  @override
  String get tourStatusUpcoming => 'ВПЕРЕДИ';

  @override
  String get tourStatusInProgress => 'ИДЁТ';

  @override
  String get tourStatusComingSoon => 'СКОРО';

  @override
  String get tourStatusDecided => 'РЕШЕНО';

  @override
  String tourStatusLeague(String letter) {
    return 'ЛИГА $letter';
  }

  @override
  String get tourDrawWcQualifying => 'ЖЕРЕБЬЁВКА МИРОВОГО ОТБОРА';

  @override
  String tourDrawContQualifying(String cup) {
    return '$cup: ЖЕРЕБЬЁВКА ОТБОРА';
  }

  @override
  String get tourDrawWcHost => 'ХОЗЯИН ЧЕМПИОНАТА МИРА';

  @override
  String tourDrawContHost(String cup) {
    return '$cup: ХОЗЯИН';
  }

  @override
  String get tourDrawHostsReveal => 'И хозяевами станут…';

  @override
  String get tourDrawHostReveal => 'И хозяином станет…';

  @override
  String get tourDrawHostCandidates => 'Кандидаты в борьбе:';

  @override
  String get tourKickoffContinentalCup => 'КОНТИНЕНТАЛЬНЫЙ КУБОК';

  @override
  String tourHostCompetitionYear(String competition, int year) {
    return '$competition $year';
  }

  @override
  String newsContMissTitle(String cup) {
    return 'Мимо: $cup';
  }

  @override
  String newsContMissBody(String cup) {
    return 'Ты не прошёл отбор: $cup. В этот раз не хватило.';
  }

  @override
  String get potyLabelBest => 'Игрок года';

  @override
  String get potyLabelYoung => 'Молодой игрок года';

  @override
  String potyTallyAssists(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count передачи',
      many: '$count передач',
      few: '$count передачи',
      one: '$count передача',
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
    return 'Лучший игрок мира $year';
  }

  @override
  String newsPotyBody(String name) {
    return '$name – лучший игрок мира в этом году.';
  }

  @override
  String newsPotyYoungSuffix(String name) {
    return ' $name получает награду лучшему молодому игроку.';
  }

  @override
  String newsWatchTitle(int year) {
    return 'Ребята под твоим наблюдением, $year';
  }

  @override
  String newsWatchJump(String name, int rating, int gain) {
    String _temp0 = intl.Intl.pluralLogic(
      gain,
      locale: localeName,
      other: '$gain очка',
      many: '$gain очков',
      few: '$gain очка',
      one: '$gain очко',
    );
    return '$name вырос до $rating, это на $_temp0 больше, чем год назад.';
  }

  @override
  String newsWatchBand(String name, String band) {
    return '$name поднимается в категорию $band.';
  }

  @override
  String newsWatchDebutTitle(String name) {
    return '$name дебютирует';
  }

  @override
  String newsWatchDebutBody(String name, int age, int rating) {
    return '$name провёл первый матч за сборную в $age лет с рейтингом $rating. Один из ребят под твоим наблюдением.';
  }

  @override
  String get matchStatsAtFullTime =>
      'Владение, оценки игроков и лучший игрок матча определяются после финального свистка.';

  @override
  String get matchPlayerRatings => 'ОЦЕНКИ ИГРОКОВ';

  @override
  String get matchSubstitutions => 'ЗАМЕНЫ';

  @override
  String get matchSubstitutes => 'ЗАПАСНЫЕ';

  @override
  String get matchLineupsViewPitch => 'Поле';

  @override
  String get matchLineupsViewList => 'Список';

  @override
  String get matchLineupsCameOn => 'Вышел на замену';

  @override
  String get matchConditionsKickOff => 'Начало';

  @override
  String get matchWeatherClear => 'Ясно';

  @override
  String get matchWeatherRain => 'Небольшой дождь';

  @override
  String get matchWeatherSnow => 'Снег';

  @override
  String get matchWeatherHaze => 'Дымка';

  @override
  String get matchWeatherHeavyRain => 'Ливень';

  @override
  String get matchWeatherThunderstorm => 'Гроза';

  @override
  String get matchWeatherFog => 'Туман';

  @override
  String get matchWeatherWindy => 'Ветрено';

  @override
  String get matchWeatherDustStorm => 'Пыльная буря';

  @override
  String get matchWeatherFrostyNight => 'Морозная ночь';

  @override
  String get matchWeatherDrizzle => 'Морось';

  @override
  String get matchWeatherFrost => 'Мороз';

  @override
  String get matchPlayerOfTheMatch => 'ИГРОК МАТЧА';

  @override
  String get ratingPlayerOfTheMatch => 'Игрок матча';

  @override
  String ratingSemantics(String rating) {
    return 'Оценка $rating';
  }

  @override
  String get matchAverageRating => 'Средняя оценка';

  @override
  String get matchLiveRatingsNote =>
      'Оценки отражают ход матча и станут окончательными после свистка.';

  @override
  String get matchGoalShout => 'ГОЛ!';

  @override
  String get matchRedCardShout => 'КРАСНАЯ';

  @override
  String matchShootoutScore(int home, int away) {
    return 'ПЕНАЛЬТИ $home–$away';
  }

  @override
  String matchShootoutKickScored(String name) {
    return '$name: ЗАБИЛ';
  }

  @override
  String matchShootoutKickMissed(String name) {
    return '$name: ПРОМАХ';
  }

  @override
  String get matchFeedKickOff => 'Начали!';

  @override
  String get matchFeedNoEvents => 'Событий пока нет.';

  @override
  String get tourVenues => 'СТАДИОНЫ';

  @override
  String tourPot(int number) {
    return 'КОРЗИНА $number';
  }

  @override
  String get tourHostSelection => 'ВЫБОР ХОЗЯИНА';

  @override
  String get tourCandidates => 'КАНДИДАТЫ';

  @override
  String get tourJointBid => 'СОВМЕСТНАЯ ЗАЯВКА';

  @override
  String get tourGoldenGlove => 'ЗОЛОТАЯ ПЕРЧАТКА';

  @override
  String get tourTeamOfTournament => 'СИМВОЛИЧЕСКАЯ СБОРНАЯ ТУРНИРА';

  @override
  String get tourYourRun => 'ТВОЙ ПУТЬ';

  @override
  String get tourMedalTable => 'МЕДАЛЬНЫЙ ЗАЧЁТ';

  @override
  String tourHostLine(String nation) {
    return 'Хозяин: $nation';
  }

  @override
  String tourHostLineMulti(String hosts) {
    return 'Хозяева: $hosts';
  }

  @override
  String tourGroupNamed(String name) {
    return 'Группа $name';
  }

  @override
  String get tourFinalsDrawBlurb =>
      'Посев по мировому рейтингу. Найди свою сборную до жеребьёвки.';

  @override
  String get tourWorldRanking => 'Мировой рейтинг';

  @override
  String get tourYourCompetitions => 'ТВОИ ТУРНИРЫ';

  @override
  String get tourOtherContinents => 'ДРУГИЕ КОНТИНЕНТЫ';

  @override
  String get tourZoneGlobal => 'МИР';

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
  String get tourZoneIntercontinental => 'МЕЖКОНТИНЕНТАЛЬНЫЙ';

  @override
  String tourZoneLeague(String league) {
    return 'ЛИГА $league';
  }

  @override
  String tourHostedBy(String hosts) {
    return 'ХОЗЯЕВА:  $hosts';
  }

  @override
  String tourThirdsAdvance(int count, String destination) {
    return 'Лучшие $count проходят дальше: $destination';
  }

  @override
  String newsWalkoutTitle(String name) {
    return '$name уходит';
  }

  @override
  String newsWalkoutBody(String name, int age, int caps) {
    String _temp0 = intl.Intl.pluralLogic(
      caps,
      locale: localeName,
      other: '$caps матча',
      many: '$caps матчей',
      few: '$caps матча',
      one: '$caps матч',
    );
    return '$name завершил карьеру в сборной в $age лет, сыграв $_temp0. Он просил сказать, на что может рассчитывать, ответа не получил и больше ждать не будет.';
  }

  @override
  String get pressHeadlineWent1 => 'Тренер, который держит зал';

  @override
  String get pressHeadlineWent2 => 'Пришли за скандалом, получили лидера';

  @override
  String get pressHeadlineWent3 => 'Прямые ответы, и они попали в цель';

  @override
  String get pressHeadlineMixed1 => 'Сказано много, решено мало';

  @override
  String get pressHeadlineMixed2 => 'Всем понемногу и никому ничего';

  @override
  String get pressHeadlineMixed3 =>
      'Пресс-конференция, оставившая вопросы открытыми';

  @override
  String get pressHeadlineBadly1 => 'Тяжёлый день перед камерами';

  @override
  String get pressHeadlineBadly2 => 'Зал отвернулся, и это было видно';

  @override
  String get pressHeadlineBadly3 =>
      'Ответы, которые утром прочитаются ещё хуже';

  @override
  String get pressHeadlineFlat1 => 'Ничего не сказано, ничего не выиграно';

  @override
  String get pressHeadlineFlat2 => 'Десять минут, ноль новостей';

  @override
  String get pressHeadlineFlat3 => 'Пустая страница для спортивного раздела';

  @override
  String get pressConferenceTitle => 'ПРЕСС-КОНФЕРЕНЦИЯ';

  @override
  String pressQuestionOf(int index, int total) {
    return 'Вопрос $index из $total';
  }

  @override
  String get pressTomorrowsHeadline => 'ЗАВТРАШНИЙ ЗАГОЛОВОК';

  @override
  String get pressLeaveRoom => 'ПОКИНУТЬ ЗАЛ';

  @override
  String get pressRoomVerdictSquad => 'Раздевалка';

  @override
  String get pressRoomVerdictBoard => 'Руководство';

  @override
  String get yReactionElation0 => 'без замечаний. вообще. идеально.';

  @override
  String get yReactionElation1 => 'мне плохо (в хорошем смысле).';

  @override
  String get yReactionElation2 => 'в рамочку. повешу над камином.';

  @override
  String get yReactionElation3 => 'мы вернулись';

  @override
  String get yReactionElation4 => 'Скриню для сомневающихся. Для всех.';

  @override
  String get yReactionElation5 => 'Я буду невыносим из-за этого лет десять.';

  @override
  String get yReactionElation6 => 'Вот. Вот ради этого мы и смотрим.';

  @override
  String get yReactionElation7 => 'Такие дни окупают все остальные.';

  @override
  String get yReactionElation8 => 'Давно пора. Честно, давно пора.';

  @override
  String get yReactionElation9 =>
      'Отлично. Повторите на следующей неделе, и я поверю.';

  @override
  String get yReactionElation10 =>
      'Радуйтесь сегодня, эти ребята найдут способ всё испортить.';

  @override
  String get yReactionElation11 =>
      'Один хороший вечер ещё никого не сделал великой командой.';

  @override
  String get yReactionRelief0 => 'Некрасиво, но я возьму это каждый раз.';

  @override
  String get yReactionRelief1 => 'Как-то. Как-то!';

  @override
  String get yReactionRelief2 => 'Уродливо. Три очка. Дальше.';

  @override
  String get yReactionRelief3 => 'Пусть будет уродливо, лишь бы с очками.';

  @override
  String get yReactionRelief4 => 'минус десять лет жизни';

  @override
  String get yReactionRelief5 => 'Все молчим. Не сглазьте.';

  @override
  String get yReactionRelief6 => 'Пульс: недопустимый.';

  @override
  String get yReactionRelief7 => 'Выжили. Вот правильное слово. Выжили.';

  @override
  String get yReactionRelief8 =>
      'После таких матчей не должно быть облегчения.';

  @override
  String get yReactionRelief9 =>
      'Облегчение, и немного стыдно за это облегчение.';

  @override
  String get yReactionRelief10 =>
      'Если мы радуемся вот такому, у нас проблемы.';

  @override
  String get yReactionRelief11 =>
      'Проползать – это привычка, и не самая хорошая.';

  @override
  String get yReactionFury0 => 'Недостаточно. Даже близко.';

  @override
  String get yReactionFury1 => 'Кто-нибудь, объясните мне это медленно.';

  @override
  String get yReactionFury2 => 'Это тяжело смотреть, и я ещё вежлив.';

  @override
  String get yReactionFury3 => 'Разочарован. По-настоящему разочарован.';

  @override
  String get yReactionFury4 => 'Ну и состояние.';

  @override
  String get yReactionFury5 => 'Мне нужны фамилии.';

  @override
  String get yReactionFury6 =>
      'Удаляю приложение. Установлю обратно в четверг.';

  @override
  String get yReactionFury7 =>
      'Никто на поле не выглядел так, будто ему это нужно.';

  @override
  String get yReactionFury8 =>
      'Каждые четыре года одно и то же. КАЖДЫЕ четыре года.';

  @override
  String get yReactionFury9 => 'Это не игра, это оскорбление.';

  @override
  String get yReactionFury10 =>
      'Люди отдают ради этого выходные и деньги. Подумайте об этом.';

  @override
  String get yReactionFury11 =>
      'Я годами защищал эту команду. Не сегодня. Не после такого.';

  @override
  String get yReactionDespair0 => 'ну.';

  @override
  String get yReactionDespair1 => 'Сегодня без шуток. Ничего.';

  @override
  String get yReactionDespair2 => 'Пойду пройдусь. Долго.';

  @override
  String get yReactionDespair3 => 'У меня кончились слова.';

  @override
  String get yReactionDespair4 => 'Разбудите меня через четыре года.';

  @override
  String get yReactionDespair5 => 'это самая мрачная ветка реальности';

  @override
  String get yReactionDespair6 => 'Уже даже не злюсь. Вот что тревожит.';

  @override
  String get yReactionDespair7 => 'Это будет жечь ещё очень долго.';

  @override
  String get yReactionDespair8 =>
      'Не знаю, что это теперь такое, но это не футбольная команда.';

  @override
  String get yReactionDespair9 =>
      'Мы дальше, чем были, и никто этого не скажет.';

  @override
  String get yReactionDespair10 =>
      'Целое поколение впустую, и решают всё те же люди.';

  @override
  String get yReactionDespair11 =>
      'Хватит говорить мне, что это процесс. Он никуда не ведёт.';

  @override
  String get yReactionSmugness0 => 'Тихо, но: я же говорил.';

  @override
  String get yReactionSmugness1 => 'сохраните себе';

  @override
  String get yReactionSmugness2 => 'Сомневающиеся как-то притихли.';

  @override
  String get yReactionSmugness3 => 'Не то чтобы кто-то считал. Я считаю.';

  @override
  String get yReactionSmugness4 => 'Говорил ещё в январе. Проверьте ленту.';

  @override
  String get yReactionSmugness5 => 'Кое-кто тут кое-кому должен извинения.';

  @override
  String get yReactionSmugness6 => 'В папку «я говорил первым».';

  @override
  String get yReactionSmugness7 => 'Без злорадства. Чуть-чуть злорадства.';

  @override
  String get yReactionSmugness8 =>
      'Где теперь все эксперты? Это не риторический вопрос.';

  @override
  String get yReactionSmugness9 =>
      'Хочу, чтобы каждый из вас повторил это за мной.';

  @override
  String get yReactionSmugness10 =>
      'Скрин, распечатать, в рамку, отправить тем, кто смеялся.';

  @override
  String get yReactionSmugness11 =>
      'Я буду вспоминать это до конца жизни, и вы это заслужили.';

  @override
  String get yReactionShrug0 => 'было и было. дальше.';

  @override
  String get yReactionShrug1 => 'Ладно. Неважно. Дальше.';

  @override
  String get yReactionShrug2 => 'В папку «футбол».';

  @override
  String get yReactionShrug3 => 'Честно, добавить нечего.';

  @override
  String get yReactionShrug4 => 'мыслей нет, в голове пусто';

  @override
  String get yReactionShrug5 => 'Разбудите к следующему.';

  @override
  String get yReactionShrug6 => 'Девяносто минут, которые мне никто не вернёт.';

  @override
  String get yReactionShrug7 => 'Ни то ни сё, если честно.';

  @override
  String get yReactionShrug8 => 'Не вспомню ни одного эпизода.';

  @override
  String get yReactionShrug9 => 'Ещё один из таких. Таких много.';

  @override
  String get yReactionShrug10 =>
      'Смотрел от начала до конца и не почувствовал ничего.';

  @override
  String get yReactionShrug11 =>
      'Если об этом больше никто не вспомнит, меня устроит.';

  @override
  String get tourThirdsUneven =>
      'Группы неравные, поэтому результаты против последней команды каждой большой группы не учитываются, и все оцениваются по одинаковому числу матчей.';

  @override
  String get careerExportSave => 'Резервная копия сохранения';

  @override
  String get careerBackupAll => 'КОПИЯ ВСЕХ СОХРАНЕНИЙ';

  @override
  String get careerBackupAllFailed => 'Не удалось записать копию.';

  @override
  String get backupTitle => 'РЕЗЕРВНЫЕ КОПИИ';

  @override
  String get backupBlurb =>
      'Все сохранения хранятся в одном файле на этом телефоне, и ничто не копирует его само, если не включить автоматическое резервирование ниже. Держи копию в облаке, чтобы потерянный телефон или удалённое приложение не стоили тебе карьеры.';

  @override
  String get backupBlurbNoAuto =>
      'Все сохранения хранятся в одном файле на этом телефоне, и ничто не копирует его само. Держи копию в облаке, чтобы потерянный телефон или удалённое приложение не стоили тебе карьеры.';

  @override
  String get backupExport => 'КОПИЯ В ОБЛАКО';

  @override
  String get backupExportSubject => 'Сохранения FNM';

  @override
  String get backupRestore => 'ВОССТАНОВИТЬ ИЗ ФАЙЛА';

  @override
  String get backupRestoreWarnTitle => 'Заменить все сохранения?';

  @override
  String get backupRestoreWarnBody =>
      'Восстановление заменит все сохранения на этом телефоне сохранениями из файла. Приложение перезапустится.';

  @override
  String get backupRestoreConfirm => 'ЗАМЕНИТЬ';

  @override
  String get backupCancel => 'ОТМЕНА';

  @override
  String get backupExported => 'Копия готова. Выбери, где её хранить.';

  @override
  String get backupFailed => 'Не удалось записать копию.';

  @override
  String get backupRejectedUnreadable => 'Не удалось открыть этот файл.';

  @override
  String get backupRejectedNotFnm => 'Это не сохранение FNM.';

  @override
  String get backupRejectedNewer =>
      'Это сохранение создано более новой версией приложения. Сначала обнови его.';

  @override
  String get backupRejectedTooOld =>
      'Это сохранение слишком старое для этой версии.';

  @override
  String get careerShare => 'Поделиться карьерой';

  @override
  String get careerImport => 'ИМПОРТ КАРЬЕРЫ';

  @override
  String get careerShareSubject => 'Карьера в FNM';

  @override
  String get careerImported => 'Карьера импортирована.';

  @override
  String get careerImportFailedUnreadable =>
      'Этот файл не является карьерой FNM.';

  @override
  String get careerImportFailedNewer =>
      'Эта карьера экспортирована более новой версией приложения. Сначала обнови его.';

  @override
  String get careerImportFailedSlotsFull =>
      'Все слоты сохранений заняты. Удали сохранение, чтобы освободить место, или открой безлимитные сохранения.';

  @override
  String get careerImportFailedNeedsPremium =>
      'Эта карьера ушла дальше бесплатного первого цикла. Открой полную игру, чтобы её принять.';

  @override
  String get careerImportFailedCampaignRun =>
      'В этой кампании уже идёт прохождение. Сначала продолжи или брось его.';

  @override
  String get careerShareFailed => 'Не удалось экспортировать карьеру.';

  @override
  String get managerRename => 'Сменить имя';

  @override
  String get managerRenameSave => 'Сохранить';

  @override
  String get managerTitle => 'ТРЕНЕР';

  @override
  String get managerSkills => 'ТВОИ НАВЫКИ';

  @override
  String managerPointsAvailable(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count очка к распределению',
      many: '$count очков к распределению',
      few: '$count очка к распределению',
      one: '$count очко к распределению',
      zero: 'Нет очков для распределения',
    );
    return '$_temp0';
  }

  @override
  String get managerPointsHow =>
      'Два очка за каждый завершённый цикл, одно за каждый выигранный трофей.';

  @override
  String get managerSkillsScale =>
      'Каждый навык начинается с 5 и заканчивается на 20. Потраченное очко не вернуть.';

  @override
  String get managerSkillManManagement => 'Работа с людьми';

  @override
  String get managerSkillManManagementBlurb =>
      'Каждое очко делает твои слова прессе и игрокам на 3% весомее в раздевалке.';

  @override
  String get managerSkillTactical => 'Тактика';

  @override
  String get managerSkillTacticalBlurb =>
      'Каждое очко ускоряет освоение новой схемы на 3%, так что смена построения стоит меньше матчей.';

  @override
  String get managerSkillYouth => 'Работа с молодёжью';

  @override
  String get managerSkillYouthBlurb =>
      'Каждое очко добавляет 1% к таланту выпускников академии сверх того, что даёт финансирование.';

  @override
  String get managerSkillNegotiation => 'Переговоры';

  @override
  String get managerSkillNegotiationBlurb =>
      'Каждое очко – это на 2% больше денег от федерации в каждом цикле.';

  @override
  String get managerStaff => 'ТВОЙ ШТАБ';

  @override
  String managerStaffWages(String amount) {
    return 'Зарплаты: $amount за цикл';
  }

  @override
  String get managerRoleAssistant => 'Ассистент тренера';

  @override
  String get managerRoleAssistantBlurb =>
      'Ведёт тренировки: меньше травм и лучше молодёжь на подходе.';

  @override
  String get managerRoleScout => 'Главный скаут';

  @override
  String get managerRoleScoutBlurb =>
      'Изучает твоих молодых и следующего соперника: точнее звёзды потенциала и преимущество в день матча.';

  @override
  String get managerRoleFitness => 'Тренер по физподготовке';

  @override
  String get managerRoleFitnessBlurb => 'Держит игроков на поле.';

  @override
  String staffEffectInjury(int percent) {
    return 'На $percent% меньше травм';
  }

  @override
  String staffEffectYouth(int points) {
    return 'Молодёжь +$points к рейтингу';
  }

  @override
  String staffHiringInjury(int min, int max) {
    return 'Если нанять: на $min–$max% меньше травм';
  }

  @override
  String staffHiringYouth(int minPoints, int maxPoints) {
    return 'и молодёжь от +$minPoints до +$maxPoints к рейтингу';
  }

  @override
  String staffEffectScoutRead(int percent) {
    return 'Точно оценивает $percent% молодых';
  }

  @override
  String staffEffectScoutCaps(int caps) {
    String _temp0 = intl.Intl.pluralLogic(
      caps,
      locale: localeName,
      other: 'Потенциал известен после $caps матча',
      many: 'Потенциал известен после $caps матчей',
      few: 'Потенциал известен после $caps матчей',
      one: 'Потенциал известен после $caps матча',
    );
    return '$_temp0';
  }

  @override
  String staffEffectScoutDossier(int points) {
    return '+$points к рейтингу от досье на соперника';
  }

  @override
  String staffHiringScoutRead(int min, int max) {
    return 'Если нанять: $min–$max% точных оценок';
  }

  @override
  String staffHiringScoutCaps(int minCaps, int maxCaps) {
    return 'и потенциал известен на $minCaps–$maxCaps матчей раньше';
  }

  @override
  String staffHiringScoutDossier(int minPoints, int maxPoints) {
    return 'и от +$minPoints до +$maxPoints к рейтингу в каждом матче';
  }

  @override
  String get staffEffectNone => 'Пока без влияния на состав';

  @override
  String get staffVacant => 'Должность свободна';

  @override
  String get staffLeaveVacant => 'Оставить должность пустой';

  @override
  String get managerTierNone => 'Нет';

  @override
  String get managerTierBasic => 'Базовый';

  @override
  String get managerTierGood => 'Хороший';

  @override
  String get managerTierElite => 'Элитный';

  @override
  String get managerFree => 'бесплатно';

  @override
  String get managerTraining => 'МЕЖДУ ОКНАМИ';

  @override
  String get managerTrainingBlurb =>
      'Над чем работает команда, когда нет матчей.';

  @override
  String get managerFocusBalanced => 'Баланс';

  @override
  String get managerFocusBalancedBlurb => 'Всего понемногу.';

  @override
  String get managerFocusFitness => 'Физподготовка';

  @override
  String get managerFocusFitnessBlurb => 'Меньше травм.';

  @override
  String get managerFocusCohesion => 'Сыгранность';

  @override
  String get managerFocusCohesionBlurb => 'Схема осваивается быстрее.';

  @override
  String get managerFocusYouth => 'Молодёжь';

  @override
  String get managerFocusYouthBlurb => 'Часы с самыми молодыми в пуле.';

  @override
  String get tourOfferTitle => 'Впервые здесь?';

  @override
  String get tourOfferBody =>
      'Это большая игра. Хочешь быстро пройтись по главным экранам? Это займёт минуту, и запустить обзор снова можно в любой момент в настройках.';

  @override
  String get tourOfferYes => 'Покажи всё';

  @override
  String get tourOfferNo => 'Нет, спасибо';

  @override
  String get tourBack => 'Назад';

  @override
  String get tourNext => 'Далее';

  @override
  String get tourDone => 'Готово';

  @override
  String get tourSkip => 'Пропустить';

  @override
  String get tourHubTitle => 'Здесь вся игра';

  @override
  String get tourHubBody =>
      'Одна кнопка, и она меняется по ходу цикла: жеребьёвка, выбор состава, матч. Над ней доверие руководства и поставленные им задачи.';

  @override
  String get tourBudgetTitle => 'Деньги федерации';

  @override
  String get tourBudgetBody =>
      'Раз в четырёхлетний цикл ты распределяешь бюджет по отделам. Штаб получает зарплату из него в первую очередь, так что элитный скаут – это решение против академии, а не вместе с ней.';

  @override
  String get tourTacticsTitle => 'Как играет команда';

  @override
  String get tourTacticsBody =>
      'Схема, стиль игры, капитан и исполнители стандартов. Если не назначить последних двух, игра предупредит перед матчем, а не выберет за тебя молча.';

  @override
  String get tourSquadTitle => 'Все, кого можно выбрать';

  @override
  String get tourSquadBody =>
      'Весь пул, а не только состав: кто в форме, у кого повреждение, кто дисквалифицирован и кто только что вышел из академии.';

  @override
  String get tourCallUpsTitle => 'Выбор состава';

  @override
  String get tourCallUpsBody =>
      'Ты называешь один состав на каждое международное окно, и он играет все матчи этого окна, как у настоящего тренера. Если внутри окна кто-то травмируется, замена будет вызвана за тебя.';

  @override
  String get tourRecordsTitle => 'Твоя карьера';

  @override
  String get tourRecordsBody =>
      'Всё, что ты сделал: матчи, рекорды команды, трофеи и все сборные, которые ты тренировал.';

  @override
  String get tourCupsTitle => 'Остальной мир';

  @override
  String get tourCupsBody =>
      'Все турниры, идущие прямо сейчас: группы, таблицы и плей-офф, в том числе те, где тебя нет. Мир играет независимо от того, прошёл ли ты отбор.';

  @override
  String get settingsTourTitle => 'Повторить обучение';

  @override
  String get settingsTourBlurb =>
      'Пройти по главным экранам заново с самого начала.';

  @override
  String get tourBoardTitle => 'Перед кем ты отвечаешь';

  @override
  String get tourBoardBody =>
      'Доверие руководства и задачи на этот цикл. Если провалишь задание, здесь ты увидишь это заранее.';

  @override
  String get tourStaffTitle => 'Люди вокруг тебя';

  @override
  String get tourStaffBody =>
      'Ассистент, скаут и тренер по физподготовке, нанятые поимённо. Их зарплаты идут из бюджета раньше отделов, так что отличный скаут – это решение против академии.';

  @override
  String get tourPlaystyleTitle => 'Твой стиль игры';

  @override
  String get tourPlaystyleBody =>
      'Схема – это только половина тактики. Вот вторая половина: как высоко прессинговать, насколько прямолинейно играть и насколько рисковать.';

  @override
  String get settingsTourNoSave =>
      'Сначала начни карьеру. Обзор проходит по твоим собственным экранам.';

  @override
  String tacticsOutOfPositionAge(int age) {
    return 'Не на своей позиции · Возраст $age';
  }

  @override
  String get federationNextCycleLocked =>
      'Бюджет следующего цикла утверждается в его начале, разом. До тех пор вот что делают твои деньги.';

  @override
  String get federationBudgetAlreadySet => 'На этот цикл уже утверждён';

  @override
  String yFinalLooms0(String opponent) {
    return 'В решающем матче нас ждёт соперник $opponent. Всю неделю только об этом и будут говорить.';
  }

  @override
  String yFinalLooms1(String opponent) {
    return 'Подтверждено: между нами и мечтой стоит соперник $opponent. Четыре года ради этого.';
  }

  @override
  String yFinalLooms2(String opponent) {
    return 'Так. $opponent. Никто не спит, пока это не закончится.';
  }

  @override
  String yFinalLooms3(String opponent) {
    return 'Дальше $opponent, а всё остальное подождёт. Какая неделя!';
  }

  @override
  String get matchSetupLeaveToCoach => 'Доверить выбор исполнителей тренеру';

  @override
  String friendliesLikeYourGroup(String rivals) {
    return 'Отмечены ниже: команды, играющие как $rivals, твои соперники по группам в этом цикле.';
  }

  @override
  String newsTransferWindowTitle(int year) {
    return 'Трансферное окно · $year';
  }

  @override
  String careerLastAgo(String when) {
    return 'Последний раз $when назад';
  }

  @override
  String get settingsFreeScopeTitle => 'Один бесплатный четырёхлетний цикл';

  @override
  String get settingsFreeScopeBlurb =>
      'Полный цикл (отбор, континентальный чемпионат и чемпионат мира) в двух сохранениях, все сборные мира, без ограничений. Бесконечные циклы и безлимитные сохранения – это один платёж, один раз, с обновлениями.';

  @override
  String get settingsUnlockedTitle => 'Открыто';

  @override
  String get settingsUnlockedBlurb =>
      'Бесконечные циклы, безлимитные сохранения, обновления включены. Спасибо.';

  @override
  String get settingsFromDeveloperTitle => 'От разработчика';

  @override
  String get settingsFromDeveloperBlurb =>
      'Football Nations Manager делает один человек, и игра будет поддерживаться долго. В ней никогда не будет рекламы и микротранзакций. Если игра тебе нравится, подумай о покупке полной версии. Именно она обеспечивает новые обновления.';

  @override
  String get settingsFromDeveloperThanksBlurb =>
      'Football Nations Manager делает один человек, и игра будет поддерживаться долго. В ней никогда не будет рекламы и микротранзакций. Спасибо за покупку полной версии. Именно она обеспечивает новые обновления.';

  @override
  String friendliesLikeYourCampaign(String rivals) {
    return 'Отмечены ниже: команды, играющие как $rivals, с кем тебе ещё предстоит встретиться.';
  }

  @override
  String get friendliesCloseToYou =>
      'Отмечены ниже: ближайшие к тебе команды в мировом рейтинге. После жеребьёвки отметки будут следовать за твоей группой.';

  @override
  String transfersMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count перехода',
      many: '$count переходов',
      few: '$count перехода',
      one: '$count переход',
    );
    return '$_temp0';
  }

  @override
  String hubRoundPage(int page, int pages) {
    return '$page / $pages';
  }

  @override
  String get transfersNewer => 'Новее';

  @override
  String get transfersOlder => 'Ещё';

  @override
  String get transfersPagePrevious => 'Назад';

  @override
  String get transfersPageNext => 'Далее';

  @override
  String transfersPageOf(int page, int pages) {
    return 'Страница $page из $pages';
  }

  @override
  String get transfersMovedTo => 'Перешёл в';

  @override
  String get transfersUnknownClub => 'Неизвестный клуб';

  @override
  String yAgainstThemAgain0(String opponent, int count) {
    return 'Уже $count матчей против соперника $opponent. Кто-то ведёт счёт, и это они.';
  }

  @override
  String yAgainstThemAgain1(String opponent, int count) {
    return 'Опять $opponent. $count встреч, а мы их так и не раскусили.';
  }

  @override
  String yAgainstThemAgain2(String opponent, int count) {
    return 'Встреча номер $count с соперником $opponent. Это уже не совпадение.';
  }

  @override
  String yAgainstThemAgain3(String opponent, int count) {
    return 'Мы играли с соперником $opponent $count раз и ничему не научились.';
  }

  @override
  String yAgainstThemAgain4(String opponent, int count) {
    return '$opponent, $count раз. Они точно знают, что мы будем делать.';
  }

  @override
  String yAgainstThemAgain5(String opponent, int count) {
    return 'Что бы $opponent на нас ни нашли, после $count встреч это всё ещё работает.';
  }

  @override
  String ySameOldStory0(int count) {
    return 'Уже $count раз такое за последнее время. Может, это просто то, кто мы есть?';
  }

  @override
  String ySameOldStory1(int count) {
    return 'Уже $count таких дней. Это закономерность, а не невезение.';
  }

  @override
  String ySameOldStory2(int count) {
    return 'Мы видели ровно этот матч $count раз за последнее время. Тот же сценарий, тот же конец.';
  }

  @override
  String ySameOldStory3(int count) {
    return 'Уже $count версий одних и тех же девяноста минут. Никто это не исправляет.';
  }

  @override
  String ySameOldStory4(int count) {
    return '$count раз. Если ты до сих пор не видишь закономерность, ты не смотришь.';
  }

  @override
  String ySameOldStory5(int count) {
    return 'Та же история, $count раз подряд. Оправдания кончились раньше, чем результаты.';
  }

  @override
  String get yToldYouSo0 =>
      'Я говорил, что так будет, пока все были заняты празднованием.';

  @override
  String get yToldYouSo1 =>
      'Две хорошие недели, и мы снова золотое поколение. И вот мы здесь.';

  @override
  String get yToldYouSo2 =>
      'Те, кто в прошлом месяце советовал мне радоваться, притихли.';

  @override
  String get yToldYouSo3 =>
      'Мне это не доставляет удовольствия. Почти никакого. Немного.';

  @override
  String get yToldYouSo4 =>
      'Всё никогда не было так хорошо, как вам рассказывали, и вот доказательство.';

  @override
  String get yToldYouSo5 =>
      'Каждый раз. Нам говорят, что теперь всё иначе, и каждый раз всё так же.';

  @override
  String get tacticsSubOffAlready => 'Уже заменён';

  @override
  String get tacticsSubInjured => 'Травмирован';

  @override
  String get tacticsSubSentOffMark => 'Удалён';

  @override
  String get tacticsSubNoneLeft => 'Замен не осталось';

  @override
  String get tacticsUndoLastChange => 'Отменить последнюю замену';

  @override
  String get matchStrengthTitle => 'ЧТО ВЛИЯЕТ НА КОМАНДУ';

  @override
  String get strengthFactorFamiliarity => 'Отработанная схема';

  @override
  String get strengthFactorFatigue => 'Усталость';

  @override
  String get strengthFactorClubForm => 'Клубная форма';

  @override
  String get strengthFactorMorale => 'Раздевалка';

  @override
  String get strengthFactorCaptain => 'Капитан';

  @override
  String get strengthFactorStaff => 'Штаб';

  @override
  String get strengthFactorDossier => 'Досье скаута';

  @override
  String yDebut0(String name) {
    return '$name провёл первый матч за сборную. Запомните это имя.';
  }

  @override
  String yDebut1(String name) {
    return 'Дебют: $name. Видно же в нём что-то, правда?';
  }

  @override
  String yDebut2(String name) {
    return '$name, первый матч. Посмотрим, что он с этим сделает.';
  }

  @override
  String yDebut3(String name) {
    return 'Дебют: $name. Команде где-то нужны были свежие ноги.';
  }

  @override
  String yDebut4(String name) {
    return '$name получил вызов. В последнее время мы раздали их немало.';
  }

  @override
  String yDebut5(String name) {
    return 'Дебют: $name. Ещё один, о ком мы забудем к весне.';
  }

  @override
  String yDrought0(String name, int count) {
    return '$name не забивает уже $count матчей, но делает на поле всё остальное.';
  }

  @override
  String yDrought1(String name, int count) {
    return '$count матчей без гола у игрока $name. Голы приходят пачками, всегда так было.';
  }

  @override
  String yDrought2(String name, int count) {
    return '$name: $count матчей, ноль голов.';
  }

  @override
  String yDrought3(String name, int count) {
    return '$count матчей без гола у игрока $name. Стоит присмотреться.';
  }

  @override
  String yDrought4(String name, int count) {
    return '$count матчей. Ноль голов. $name не попадёт и в ворота сарая.';
  }

  @override
  String yDrought5(String name, int count) {
    return '$name не забивает уже $count матчей. Выпускайте вообще кого угодно.';
  }

  @override
  String yRivalryLooms0(String opponent, int count) {
    return 'Дальше $opponent. $count встреч, и это всё ещё значит всё.';
  }

  @override
  String yRivalryLooms1(String opponent, int count) {
    return 'Уже $count встреч с соперником $opponent. Давайте.';
  }

  @override
  String yRivalryLooms2(String opponent, int count) {
    return 'Дальше $opponent. Сыграно $count.';
  }

  @override
  String yRivalryLooms3(String opponent, int count) {
    return 'На этой неделе встреча номер $count с соперником $opponent.';
  }

  @override
  String yRivalryLooms4(String opponent, int count) {
    return 'Опять $opponent. $count таких матчей, и мы ничему не научились.';
  }

  @override
  String yRivalryLooms5(String opponent, int count) {
    return '$count матчей с соперником $opponent, а они всё равно нас обыгрывают. Чудесно.';
  }

  @override
  String get positionGoalkeeper => 'Вратарь';

  @override
  String get positionLeftBack => 'Левый защитник';

  @override
  String get positionCentreBack => 'Центральный защитник';

  @override
  String get positionRightBack => 'Правый защитник';

  @override
  String get positionDefensiveMid => 'Опорный полузащитник';

  @override
  String get positionCentralMid => 'Центральный полузащитник';

  @override
  String get positionAttackingMid => 'Атакующий полузащитник';

  @override
  String get positionLeftMid => 'Левый полузащитник';

  @override
  String get positionRightMid => 'Правый полузащитник';

  @override
  String get positionLeftWing => 'Левый вингер';

  @override
  String get positionRightWing => 'Правый вингер';

  @override
  String get positionStriker => 'Нападающий';

  @override
  String get roleNone => 'Без роли';

  @override
  String get roleTargetMan => 'Таргетмен';

  @override
  String get rolePoacher => 'Охотник за голами';

  @override
  String get rolePlaymaker => 'Плеймейкер';

  @override
  String get roleBallWinner => 'Разрушитель';

  @override
  String get roleInvertedWinger => 'Инвертированный вингер';

  @override
  String get roleBallPlayingDefender => 'Защитник-распасовщик';

  @override
  String get roleNoneBlurb => 'Играет в свою естественную игру.';

  @override
  String get roleTargetManBlurb =>
      'Выигрывает верх, скидывает мяч. Передачи и стандарты.';

  @override
  String get rolePoacherBlurb => 'Караулит в штрафной. Гораздо больше голов.';

  @override
  String get rolePlaymakerBlurb => 'Создаёт моменты. Намного больше передач.';

  @override
  String get roleBallWinnerBlurb => 'Скорее разрушает атаки, чем завершает их.';

  @override
  String get roleInvertedWingerBlurb =>
      'Смещается в центр для удара. Больше голов.';

  @override
  String get roleBallPlayingDefenderBlurb => 'Начинает атаки сзади.';

  @override
  String get roleLineKeeper => 'Вратарь на линии';

  @override
  String get roleSweeperKeeper => 'Вратарь-либеро';

  @override
  String get roleStopper => 'Стоппер';

  @override
  String get roleCoveringDefender => 'Страхующий защитник';

  @override
  String get roleDefensiveFullBack => 'Оборонительный крайний';

  @override
  String get roleWingBack => 'Вингбэк';

  @override
  String get roleInvertedFullBack => 'Инвертированный крайний';

  @override
  String get roleAnchor => 'Якорь';

  @override
  String get roleDeepPlaymaker => 'Глубинный плеймейкер';

  @override
  String get roleBoxToBox => 'Бокс-ту-бокс';

  @override
  String get roleShadowStriker => 'Теневой форвард';

  @override
  String get roleTouchlineWinger => 'Вингер у бровки';

  @override
  String get roleDefensiveWinger => 'Оборонительный вингер';

  @override
  String get roleFalseNine => 'Ложная девятка';

  @override
  String get rolePressingForward => 'Прессингующий форвард';

  @override
  String get roleLineKeeperBlurb =>
      'Остаётся на линии. Надёжнее, медленнее начинает атаки.';

  @override
  String get roleSweeperKeeperBlurb =>
      'Подчищает за спиной защиты и начинает атаки.';

  @override
  String get roleStopperBlurb => 'Выходит отбирать мяч рано. Силён в воздухе.';

  @override
  String get roleCoveringDefenderBlurb =>
      'Отходит назад, страхуя зону за спиной.';

  @override
  String get roleDefensiveFullBackBlurb => 'Остаётся сзади и закрывает фланг.';

  @override
  String get roleWingBackBlurb => 'Подключается и навешивает. Много бегает.';

  @override
  String get roleInvertedFullBackBlurb =>
      'Смещается в центр поля, помогая держать мяч.';

  @override
  String get roleAnchorBlurb => 'Прикрывает линию обороны. Редко забивает.';

  @override
  String get roleDeepPlaymakerBlurb =>
      'Диктует игру из глубины. Больше передач.';

  @override
  String get roleBoxToBoxBlurb =>
      'Весь матч от штрафной до штрафной. Нужна выносливость.';

  @override
  String get roleShadowStrikerBlurb =>
      'Поздно врывается в штрафную. Больше голов.';

  @override
  String get roleTouchlineWingerBlurb =>
      'Держится у бровки и навешивает. Больше передач.';

  @override
  String get roleDefensiveWingerBlurb =>
      'Возвращается помогать крайнему защитнику.';

  @override
  String get roleFalseNineBlurb =>
      'Опускается связывать игру. Больше создаёт, чем забивает.';

  @override
  String get rolePressingForwardBlurb =>
      'Начинает прессинг с передней линии. Быстрее устаёт.';

  @override
  String get federationDeptYouth => 'Молодёжная академия';

  @override
  String get federationDeptCommercial => 'Коммерция / PR';

  @override
  String get federationDeptMedical => 'Медицина и спортивная наука';

  @override
  String get federationDeptNaturalisation => 'Отдел натурализации';

  @override
  String get federationDeptBoardRelations => 'Связи с руководством';

  @override
  String get federationDeptYouthBlurb =>
      'В следующем цикле за сборную дебютируют более сильные выпускники академии.';

  @override
  String get federationDeptCommercialBlurb =>
      'Спонсоры приносят дополнительный доход в конце цикла.';

  @override
  String get federationDeptMedicalBlurb =>
      'Меньше травм. Состав доступен весь цикл.';

  @override
  String get federationDeptNaturalisationBlurb =>
      'Больше иностранных игроков предлагают перейти в твою сборную.';

  @override
  String get federationDeptBoardRelationsBlurb =>
      'Руководство терпеливее оценивает твои результаты.';

  @override
  String get federationBuildingAcademy => 'Академия';

  @override
  String get federationBuildingCommercial => 'Коммерческий офис';

  @override
  String get federationBuildingMedical => 'Медицинский центр';

  @override
  String get federationBuildingScouting => 'Скаутский отдел';

  @override
  String get federationBuildingBoardroom => 'Зал заседаний';

  @override
  String get moraleBuoyant => 'На подъёме';

  @override
  String get moralePositive => 'Хорошая';

  @override
  String get moraleSettled => 'Ровная';

  @override
  String get moraleUneasy => 'Тревожная';

  @override
  String get moraleRockBottom => 'На дне';

  @override
  String get matchTabTimeline => 'ХРОНИКА';

  @override
  String get matchTabStats => 'СТАТИСТИКА';

  @override
  String get matchTabLineups => 'СОСТАВЫ';

  @override
  String get matchPenalty => 'ПЕНАЛЬТИ';

  @override
  String get matchStateLevel => 'Пока ничья';

  @override
  String matchStateLead(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ты ведёшь в $count гола',
      many: 'Ты ведёшь в $count голов',
      few: 'Ты ведёшь в $count гола',
      one: 'Ты ведёшь в $count гол',
    );
    return '$_temp0';
  }

  @override
  String matchStateTrail(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ты проигрываешь $count гола',
      many: 'Ты проигрываешь $count голов',
      few: 'Ты проигрываешь $count гола',
      one: 'Ты проигрываешь $count гол',
    );
    return '$_temp0';
  }

  @override
  String matchPossessionShare(int possession) {
    return 'Владение $possession%';
  }

  @override
  String get boardVerdictSackedTitle => 'Руководство тебя уволило';

  @override
  String boardVerdictSackedBody(int rating) {
    return 'Провальный цикл (оценка $rating%). Твоё правление окончено. Теперь рискнуть тобой готовы только слабые сборные.';
  }

  @override
  String get boardVerdictDelightedTitle => 'Руководство в восторге';

  @override
  String boardVerdictDelightedBody(int rating, String best) {
    return 'Выдающийся цикл (оценка $rating%), главное: $best. Тобой интересуются сборные посильнее, или можно остаться и строить дальше.';
  }

  @override
  String get boardVerdictSolidTitle => 'Добротный цикл';

  @override
  String boardVerdictSolidBody(int rating) {
    return 'Руководство довольно (оценка $rating%). Несколько сборных того же уровня готовы тебя взять, но уходить незачем.';
  }

  @override
  String get boardVerdictExpectedMoreTitle => 'Руководство ждало большего';

  @override
  String boardVerdictExpectedMoreBody(int rating) {
    return 'Разочаровывающий цикл (оценка $rating%). Ты сохраняешь работу, но все предложения – шаг вниз.';
  }

  @override
  String get boardVerdictPressureTitle => 'Ты под серьёзным давлением';

  @override
  String boardVerdictPressureBody(int rating) {
    return 'Слабый цикл (оценка $rating%). Ты остаёшься, но если захочешь начать заново, интерес проявят только слабые сборные.';
  }

  @override
  String get boardVerdictHeroTitle => 'Страна за тебя';

  @override
  String boardVerdictHeroNote(String nation, int cycles) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles цикла',
      many: '$cycles циклов',
      few: '$cycles циклов',
      one: '$cycles цикла',
    );
    return ' $nation тебя обожает: ты национальный герой после $_temp0; работа твоя, сколько захочешь.';
  }

  @override
  String get boardVerdictTheNation => 'Страна';

  @override
  String get boardVerdictBestQuiet => 'спокойный цикл';

  @override
  String get boardVerdictBestCycle => 'цикл';

  @override
  String boardVerdictBestWorld(String placement) {
    return 'чемпионат мира: $placement';
  }

  @override
  String get finishThirdPlace => 'Третье место';

  @override
  String get finishFourthPlace => 'Четвёртое место';

  @override
  String get finishDidNotQualify => 'Не прошли отбор';

  @override
  String get careerRepIconic => 'Легенда';

  @override
  String get careerRepRenowned => 'Знаменитый';

  @override
  String get careerRepEstablished => 'Признанный';

  @override
  String get careerRepRising => 'Восходящий';

  @override
  String get careerRepUnproven => 'Неизвестный';

  @override
  String get hubOfferStepUp => 'Шаг вверх';

  @override
  String get hubOfferLateral => 'Равноценный переход';

  @override
  String get hubOfferRebuild => 'Перестройка';

  @override
  String careerNationsCupWon(String league) {
    return 'Лига $league · Победитель';
  }

  @override
  String careerNationsCupRunnerUp(String league) {
    return 'Лига $league · Финалист';
  }

  @override
  String careerNationsCupSemi(String league) {
    return 'Лига $league · Полуфиналист';
  }

  @override
  String careerNationsCupPlaced(String league, int position) {
    return 'Лига $league · #$position';
  }

  @override
  String tourRunInto(String round) {
    return 'Вышли в стадию: $round';
  }

  @override
  String get tourRunIntoThirdPlace => 'Вышли в матч за третье место';

  @override
  String tourRunThrough(String round) {
    return 'Прошли стадию: $round';
  }

  @override
  String tourRunOut(String round) {
    return 'Выбыли, стадия: $round';
  }

  @override
  String get tourRunInGroup => 'Играем групповой этап';

  @override
  String get tourRunGroupOut => 'Выбыли на групповом этапе';

  @override
  String resultsCycleTitle(int year, String nation) {
    return 'Цикл $year · $nation';
  }

  @override
  String resultsCycleRecord(int played, int won, int drawn, int lost) {
    return 'Сыграно $played  ·  $wonВ $drawnН $lostП';
  }

  @override
  String resultsCycleFinish(String finish) {
    return 'Чемпионат мира: $finish';
  }

  @override
  String get resultsCycleUnderway => 'Ещё идёт';

  @override
  String yTurnedItRound0(String opponent) {
    return 'Минус два от соперника $opponent к перерыву, и они отыграли всё до последнего. Вот это команда.';
  }

  @override
  String yTurnedItRound1(String opponent) {
    return 'Минус два против соперника $opponent, а к концу это уже не имело значения. Мало кто так может.';
  }

  @override
  String yTurnedItRound2(String opponent) {
    return 'Перерыв: два мяча проигрываем сопернику $opponent. Финальный свисток: уже нет. Второй тайм был другим матчем.';
  }

  @override
  String yTurnedItRound3(String opponent) {
    return 'Отыгрались с 0:2 против соперника $opponent. Что бы ни сказали в перерыве, говорите это каждую неделю.';
  }

  @override
  String yTurnedItRound4(String opponent) {
    return 'Ладно, мы отыгрались против соперника $opponent. Теперь кто-нибудь объясните первые сорок пять минут.';
  }

  @override
  String yTurnedItRound5(String opponent) {
    return 'Минус два от соперника $opponent, и нам полагается ликовать. Исправьте первый тайм.';
  }

  @override
  String yThrewItAway0(String opponent) {
    return 'Плюс два против соперника $opponent к перерыву, и всё уплыло. Бывает и с командами получше.';
  }

  @override
  String yThrewItAway1(String opponent) {
    return 'Два мяча впереди против соперника $opponent, и упустили. Цикл длинный, время есть.';
  }

  @override
  String yThrewItAway2(String opponent) {
    return 'Перерыв: плюс два против соперника $opponent. Финальный свисток: ничего подобного.';
  }

  @override
  String yThrewItAway3(String opponent) {
    return 'Преимущество в два мяча против соперника $opponent испарилось за сорок пять минут.';
  }

  @override
  String yThrewItAway4(String opponent) {
    return 'Вели два мяча и проиграли. Сопернику $opponent. Кто-то за это ответит.';
  }

  @override
  String yThrewItAway5(String opponent) {
    return 'Два мяча впереди против соперника $opponent, и вот что мы сумели. Каждый раз.';
  }

  @override
  String get cycleBackupDone =>
      'Карьера сохранена в папку FNM на этом телефоне. При удалении приложения она исчезнет: чтобы сохранить копию в другом месте, используй «Резервная копия сохранения» на экране сохранений.';

  @override
  String get cycleBackupFailed =>
      'В этот раз не удалось сохранить копию карьеры.';

  @override
  String pressMomentBigWinWarm1(String opponent) {
    return 'Незабываемый вечер против соперника $opponent. Насколько вы гордитесь этой командой?';
  }

  @override
  String pressMomentBigWinWarm2(String opponent) {
    return '$opponent не смогли с вами справиться. Это та команда, в которую вы всегда верили?';
  }

  @override
  String pressMomentBigWinNeutral1(String opponent) {
    return 'Крупная победа над соперником $opponent. Что сегодня стало решающим?';
  }

  @override
  String pressMomentBigWinNeutral2(String opponent) {
    return '$opponent обыграны, и уверенно. Где вы выиграли этот матч?';
  }

  @override
  String pressMomentBigWinHostile1(String opponent) {
    return 'Хорошая победа над соперником $opponent. Один хороший вечер: почему кто-то должен верить, что это надолго?';
  }

  @override
  String pressMomentBigWinHostile2(String opponent) {
    return 'Отличный результат против соперника $opponent. Это был ваш план, или игроки разобрались сами?';
  }

  @override
  String pressMomentBigLossWarm1(String opponent) {
    return 'Тяжёлый вечер против соперника $opponent. Что вы говорите игрокам после такого?';
  }

  @override
  String pressMomentBigLossWarm2(String opponent) {
    return 'Никто не ожидал такого против соперника $opponent. Это просто был один из тех вечеров?';
  }

  @override
  String pressMomentBigLossNeutral1(String opponent) {
    return 'Отрезвляющий вечер против соперника $opponent. Что пошло не так?';
  }

  @override
  String pressMomentBigLossNeutral2(String opponent) {
    return '$opponent разобрали вас на части. Хватает ли этому составу класса?';
  }

  @override
  String pressMomentBigLossHostile1(String opponent) {
    return 'Против соперника $opponent вы проигрывали во всём. Как вы допустили такое?';
  }

  @override
  String pressMomentBigLossHostile2(String opponent) {
    return '$opponent забивали когда хотели. Где был план сегодня?';
  }

  @override
  String pressMomentCrisisWarm1(String opponent) {
    return 'Ещё один матч уплыл, на этот раз против соперника $opponent. Как переломить эту серию?';
  }

  @override
  String pressMomentCrisisWarm2(String opponent) {
    return 'Результаты пропали, а матч с соперником $opponent сделал всё хуже. Вы ещё верите в эту команду?';
  }

  @override
  String pressMomentCrisisNeutral1(String opponent) {
    return 'Снова без победы, теперь против соперника $opponent, и руководство наблюдает. Ваша работа в безопасности?';
  }

  @override
  String pressMomentCrisisNeutral2(String opponent) {
    return 'После матча с соперником $opponent серия затягивается. Вы беспокоитесь о своём будущем?';
  }

  @override
  String pressMomentCrisisHostile1(String opponent) {
    return 'Теперь ещё и $opponent. Вашего предшественника уволили за такую серию. Почему вы должны её пережить?';
  }

  @override
  String pressMomentCrisisHostile2(String opponent) {
    return 'После очередного вечера, как с соперником $opponent, каждый звонок в эфир требует вашей отставки. Вы уйдёте, если руководство попросит?';
  }

  @override
  String pressMomentJobVerdictWarm1(String opponent) {
    return 'Вы поставили на кон свою работу, и после матча с соперником $opponent всё сложилось не в вашу пользу. Как вы держитесь?';
  }

  @override
  String pressMomentJobVerdictWarm2(String opponent) {
    return 'Три матча позади, последний против соперника $opponent. Испытание вы назначили себе сами. Как вы оцениваете вердикт?';
  }

  @override
  String pressMomentJobVerdictNeutral1(String opponent) {
    return 'Вы просили судить вас по следующим трём матчам. После матча с соперником $opponent мы судим. Ваша работа всё ещё ваша?';
  }

  @override
  String pressMomentJobVerdictNeutral2(String opponent) {
    return 'Три матча, последний против соперника $opponent, и не то, что вы обещали. Вы говорили с руководством о своём будущем?';
  }

  @override
  String pressMomentJobVerdictHostile1(String opponent) {
    return 'Вы сами назначили испытание и провалили его против соперника $opponent. Вы уйдёте в отставку?';
  }

  @override
  String pressMomentJobVerdictHostile2(String opponent) {
    return 'Ваши слова, не наши: судите меня по следующим трём. После матча с соперником $opponent, почему вы всё ещё здесь?';
  }

  @override
  String get pressBeatWhoToBlameWarm1 =>
      'Вы хотите от них большего. От кого-то конкретно?';

  @override
  String get pressBeatWhoToBlameWarm2 =>
      'Вы высоко подняли планку. Кто должен шагнуть вперёд первым?';

  @override
  String get pressBeatWhoToBlameNeutral1 =>
      'Вы говорите, что кое-кому стоит посмотреть на себя. Кого вы имеете в виду?';

  @override
  String get pressBeatWhoToBlameNeutral2 =>
      'Недостаточно, говорите вы. О ком речь?';

  @override
  String get pressBeatWhoToBlameHostile1 =>
      'Вы говорите расплывчато. Назовёте имена, или всё сводится к вам?';

  @override
  String get pressBeatWhoToBlameHostile2 =>
      'Каждую неделю виноват кто-то другой. Кто на этот раз?';

  @override
  String get pressBeatIfYouDontWarm1 =>
      'Смелые слова. А если следующий матч не сложится?';

  @override
  String get pressBeatIfYouDontWarm2 =>
      'Страна будет держать вас за слово. А если не получится?';

  @override
  String get pressBeatIfYouDontNeutral1 => 'А если не выиграете? Что тогда?';

  @override
  String get pressBeatIfYouDontNeutral2 =>
      'Вы это сказали. Что будет, если вы ошибаетесь?';

  @override
  String get pressBeatIfYouDontHostile1 =>
      'Мы уже слышали обещания в этом зале. Что вы должны болельщикам, если и это сорвётся?';

  @override
  String get pressBeatIfYouDontHostile2 =>
      'А когда не получится, какое будет оправдание?';

  @override
  String get pressBeatFollowUpWarm1 =>
      'Ещё один, если есть силы. Над чем этой команде ещё нужно работать?';

  @override
  String get pressBeatFollowUpWarm2 =>
      'Когда страсти улягутся, что вы возьмёте из сегодняшнего вечера в следующий матч?';

  @override
  String get pressBeatFollowUpNeutral1 =>
      'Давайте глубже. Что нужно улучшить до следующего матча?';

  @override
  String get pressBeatFollowUpNeutral2 =>
      'Если отвлечься от счёта: этот состав там, где вы хотите?';

  @override
  String get pressBeatFollowUpHostile1 =>
      'Много слов, мало смысла. Что на самом деле изменится?';

  @override
  String get pressBeatFollowUpHostile2 =>
      'Болельщики хотят прямого ответа. Хватает ли этой команде класса, да или нет?';

  @override
  String pressBeatStandoutWarm1(String player) {
    return '$player сегодня был великолепен. Как далеко он может пойти?';
  }

  @override
  String pressBeatStandoutWarm2(String player) {
    return '$player сегодня во всех заголовках. Вы этого ожидали?';
  }

  @override
  String pressBeatStandoutNeutral1(String player) {
    return '$player выделялся. Что вы от него требовали сегодня?';
  }

  @override
  String pressBeatStandoutNeutral2(String player) {
    return '$player сегодня стал решающим фактором?';
  }

  @override
  String pressBeatStandoutHostile1(String player) {
    return 'Без игрока $player это была бы другая история. Это команда или один игрок?';
  }

  @override
  String pressBeatStandoutHostile2(String player) {
    return '$player был блестящ. Это ваша заслуга или его?';
  }

  @override
  String pressBeatStrugglerWarm1(String player) {
    return 'У игрока $player был тяжёлый вечер. У него повреждение?';
  }

  @override
  String pressBeatStrugglerWarm2(String player) {
    return '$player сегодня был не в своей тарелке. Вы его поддержите?';
  }

  @override
  String pressBeatStrugglerNeutral1(String player) {
    return '$player сегодня мучился. Он сохранит место в составе?';
  }

  @override
  String pressBeatStrugglerNeutral2(String player) {
    return '$player выглядел медленным. Как вы оцениваете его игру?';
  }

  @override
  String pressBeatStrugglerHostile1(String player) {
    return '$player снова был пассажиром. Почему вы продолжаете его ставить?';
  }

  @override
  String pressBeatStrugglerHostile2(String player) {
    return 'Все видели, что $player был не в игре. Все, кроме скамейки?';
  }

  @override
  String get pressThrowbackWinNextKeptWarm =>
      'Вы сказали, что выиграете следующий матч, и выиграли. Приятно оказаться правым?';

  @override
  String get pressThrowbackWinNextKeptNeutral =>
      'Вы обещали победу в следующем матче и сдержали слово. Уверенность или бравада?';

  @override
  String get pressThrowbackWinNextKeptHostile =>
      'Вы сказали, что выиграете следующий, и выиграли. Везение, или нам пора начинать вас слушать?';

  @override
  String get pressThrowbackWinNextBrokenWarm =>
      'Вы говорили, что выиграете тот матч. Не вышло. Что пошло не так?';

  @override
  String get pressThrowbackWinNextBrokenNeutral =>
      'Вы сказали, что выиграете следующий. Не выиграли. Почему мы должны верить следующему обещанию?';

  @override
  String get pressThrowbackWinNextBrokenHostile =>
      'Вы сказали, что выиграете следующий. Не выиграли. Ваши слова ещё что-то значат в этом зале?';

  @override
  String get pressThrowbackJobKeptWarm =>
      'Вы просили судить вас по трём матчам и выдержали испытание. Чувствуете себя оправданным?';

  @override
  String get pressThrowbackJobKeptNeutral =>
      'Судите меня по следующим трём, сказали вы. Мы судили, и результаты пришли. Чему вас научило это испытание?';

  @override
  String get pressThrowbackJobKeptHostile =>
      'Вы дали себе три матча и прошли их. А было ли испытание таким уж трудным?';

  @override
  String get pressThrowbackJobBrokenWarm =>
      'Вы просили судить вас по трём матчам. Они сложились не в вашу пользу. Какие выводы вы сделали?';

  @override
  String get pressThrowbackJobBrokenNeutral =>
      'Вы сказали: судите меня по следующим трём. Три позади, как и презумпция невиновности. Что теперь?';

  @override
  String get pressThrowbackJobBrokenHostile =>
      'Вы сами назначили испытание и провалили его. Почему кто-то должен теперь верить вам на слово?';

  @override
  String pressThrowbackBackKeptWarm(String player) {
    return 'Вы поддержали игрока $player, когда другие не стали. Он оправдал доверие. Часть заслуги ваша?';
  }

  @override
  String pressThrowbackBackKeptNeutral(String player) {
    return 'Вы поддержали игрока $player. Он оправдал доверие. Вера или знание?';
  }

  @override
  String pressThrowbackBackKeptHostile(String player) {
    return 'Вы поддержали игрока $player, и на этот раз это окупилось. Будете ли вы так же уверены в следующий раз?';
  }

  @override
  String pressThrowbackBackBrokenWarm(String player) {
    return 'Вы встали на сторону игрока $player, и это не сработало. Вы всё ещё в него верите?';
  }

  @override
  String pressThrowbackBackBrokenNeutral(String player) {
    return 'Вы поддержали игрока $player. Он не отплатил. Это была ошибка?';
  }

  @override
  String pressThrowbackBackBrokenHostile(String player) {
    return 'Ваше суждение или ваша верность: что подвело с игроком $player?';
  }

  @override
  String pressThrowbackBlameKeptWarm(String player) {
    return 'Вы жёстко обошлись с игроком $player, и матчи с тех пор доказали вашу правоту. Есть в этом удовлетворение?';
  }

  @override
  String pressThrowbackBlameKeptNeutral(String player) {
    return 'Вы публично раскритиковали игрока $player, и он не ответил. Есть ли для него путь назад?';
  }

  @override
  String pressThrowbackBlameKeptHostile(String player) {
    return 'Вы бросили игрока $player на растерзание, и он не оправился. Вы его сломали?';
  }

  @override
  String pressThrowbackBlameBrokenWarm(String player) {
    return 'Вы раскритиковали игрока $player, и он ответил вам на поле. Так и было задумано?';
  }

  @override
  String pressThrowbackBlameBrokenNeutral(String player) {
    return 'Вы обвинили игрока $player, а с тех пор он один из лучших у вас. Вы должны ему извинение?';
  }

  @override
  String pressThrowbackBlameBrokenHostile(String player) {
    return 'Вы бросили игрока $player под автобус, а с тех пор он ваш лучший игрок. Вы извинитесь?';
  }

  @override
  String get pressReplyCreditPlayers1 =>
      'Эти игроки отдали мне всё. Я не променяю ни одного из них.';

  @override
  String get pressReplyCreditPlayers2 =>
      'Никто не работает больше этой группы. Я буду защищать их всегда.';

  @override
  String get pressReplyCreditPlayers3 =>
      'С этого места вы не услышите ни слова против моих игроков.';

  @override
  String get pressReplyCreditPlayers4 =>
      'Заслуга игроков, а не моя. Пишите о них.';

  @override
  String get pressReplyTakeResponsibility1 =>
      'Это на мне. Я выбрал состав и я дал установку.';

  @override
  String get pressReplyTakeResponsibility2 =>
      'Судите меня, а не их. Это моя команда и моя ответственность.';

  @override
  String get pressReplyTakeResponsibility3 =>
      'Если вам нужен виноватый, я сижу прямо здесь.';

  @override
  String get pressReplyTakeResponsibility4 =>
      'Ответственность на мне. Игроков оставьте в покое.';

  @override
  String get pressReplyDemandMore1 =>
      'Я хочу большего. Некоторые точно знают, о чём я.';

  @override
  String get pressReplyDemandMore2 =>
      'На этом уровне одного старания мало. Я хочу большего и сказал им это.';

  @override
  String get pressReplyDemandMore3 =>
      'Я жду большего от каждого из них, начиная с завтрашнего дня.';

  @override
  String get pressReplyDemandMore4 =>
      'Некоторым стоит посмотреть на себя. Я не доволен.';

  @override
  String get pressReplyPromiseWinNext1 =>
      'Следующий матч мы выиграем. Можете записать.';

  @override
  String get pressReplyPromiseWinNext2 =>
      'Запомните мои слова: следующий матч наш.';

  @override
  String get pressReplyPromiseWinNext3 =>
      'Следующую игру мы выигрываем. Говорю это здесь, чтобы вы могли с меня спросить.';

  @override
  String get pressReplyPromiseWinNext4 =>
      'Я уверен в этой команде. Следующий матч мы выиграем.';

  @override
  String get pressReplyJobOnTheLine1 =>
      'Судите меня по следующим трём матчам. Это честно.';

  @override
  String get pressReplyJobOnTheLine2 =>
      'Дайте мне три игры. Если к тому времени всё не наладится, судите меня.';

  @override
  String get pressReplyJobOnTheLine3 =>
      'Следующие три матча покажут, тот ли я человек. Спросите с меня.';

  @override
  String get pressReplyJobOnTheLine4 =>
      'Три матча. Потом пишите обо мне что хотите.';

  @override
  String get pressReplyDeflect1 =>
      'Мы идём от матча к матчу. Больше добавить нечего.';

  @override
  String get pressReplyDeflect2 => 'Сегодня я не дам вам заголовков.';

  @override
  String get pressReplyDeflect3 => 'Следующий матч. Только о нём я и думаю.';

  @override
  String get pressReplyDeflect4 => 'Что я думаю, остаётся в раздевалке.';

  @override
  String get pressReplyTakeCredit1 =>
      'Я сказал это, потому что верил, и оказался прав.';

  @override
  String get pressReplyTakeCredit2 =>
      'Я правильно всё прочитал. Для этого я здесь.';

  @override
  String get pressReplyTakeCredit3 =>
      'Назовите это чутьём. Я знал, что говорю.';

  @override
  String get pressReplyTakeCredit4 =>
      'Я принял решение, и оно сработало. Приму это.';

  @override
  String get pressReplyStandByIt1 =>
      'Я сказал то, во что верил. Я от этого не отказываюсь.';

  @override
  String get pressReplyStandByIt2 => 'Я не беру назад ни слова.';

  @override
  String get pressReplyStandByIt3 =>
      'Тот же ответ, что и тогда. Я так думал и думаю.';

  @override
  String get pressReplyStandByIt4 => 'Я бы сказал это и завтра.';

  @override
  String get pressReplyAdmitMistake1 => 'Тут я ошибся. Признаю.';

  @override
  String get pressReplyAdmitMistake2 =>
      'Справедливо, я неверно оценил ситуацию. Сделаю выводы.';

  @override
  String get pressReplyAdmitMistake3 => 'Я был неправ и могу это сказать.';

  @override
  String get pressReplyAdmitMistake4 =>
      'Это решение не сработало, и оно было моим.';

  @override
  String pressReplyBackPlayer1(String player) {
    return 'У игрока $player моя полная поддержка. Он заиграет.';
  }

  @override
  String pressReplyBackPlayer2(String player) {
    return 'Я верю в игрока $player, и он покажет вам почему.';
  }

  @override
  String pressReplyBackPlayer3(String player) {
    return 'Вы не услышите от меня ни слова против игрока $player. Он своё сделает.';
  }

  @override
  String pressReplyBackPlayer4(String player) {
    return '$player остаётся в моих планах. Смотрите, что он сделает дальше.';
  }

  @override
  String pressReplyBlamePlayer1(String player) {
    return '$player подвёл нас сегодня, и он это знает.';
  }

  @override
  String pressReplyBlamePlayer2(String player) {
    return 'Я ждал от игрока $player гораздо большего. Ему придётся ответить.';
  }

  @override
  String pressReplyBlamePlayer3(String player) {
    return '$player был не на уровне. Говорю это публично.';
  }

  @override
  String pressReplyBlamePlayer4(String player) {
    return 'От игрока $player это было недостаточно, и он услышит это от меня.';
  }

  @override
  String get pressOnRecordWinNext => 'Под запись: вы выиграете следующий матч.';

  @override
  String get pressOnRecordJob => 'Под запись: судить вас по следующим трём.';

  @override
  String pressOnRecordBack(String player) {
    return 'Под запись: поддержка игрока $player.';
  }

  @override
  String pressOnRecordBlame(String player) {
    return 'Под запись: $player вас подвёл.';
  }

  @override
  String yStatementKept0(String nation) {
    return 'Он сказал, и так и вышло. $nation: у нас тренер, который отвечает за слова.';
  }

  @override
  String yStatementKept1(String nation) {
    return 'Сказал вслух, потом пошёл и сделал. Вот кто был нужен. $nation.';
  }

  @override
  String yStatementKept2(String nation) {
    return '$nation: он предсказал, и сбылось. Справедливо.';
  }

  @override
  String yStatementKept3(String nation) {
    return 'Сказал под запись, и слово устояло. Плюс ему. $nation, идём дальше.';
  }

  @override
  String yStatementKept4(String nation) {
    return 'Один раз угадал. $nation, не привыкайте.';
  }

  @override
  String yStatementKept5(String nation) {
    return 'Даже остановившиеся часы дважды в сутки показывают верное время. $nation: в этот раз повезло.';
  }

  @override
  String yStatementBroken0(String nation) {
    return 'Он сказал, и не вышло. Я всё равно с ним. $nation, ещё раз.';
  }

  @override
  String yStatementBroken1(String nation) {
    return '$nation: он обещал больше, чем мы получили, но лучше тренер, который в себя верит.';
  }

  @override
  String yStatementBroken2(String nation) {
    return '$nation: он сказал это под запись, и этого не случилось. Люди запомнят.';
  }

  @override
  String yStatementBroken3(String nation) {
    return 'Громкие слова, а за ними пусто. $nation: в следующий раз говорите меньше.';
  }

  @override
  String yStatementBroken4(String nation) {
    return 'Он стоял и говорил нам. А потом вот это. $nation заслуживает большего, чем болтовня.';
  }

  @override
  String yStatementBroken5(String nation) {
    return 'Его слово теперь ничего не стоит. Запиши это, $nation.';
  }

  @override
  String get ncZoneNorth => 'Северная зона';

  @override
  String get ncZoneWest => 'Западная зона';

  @override
  String get ncZoneEast => 'Восточная зона';

  @override
  String get ncZoneCentralSouthern => 'Центральная и Южная зона';

  @override
  String careerNationsCupZoneWon(String zone) {
    return '$zone · Победитель';
  }

  @override
  String careerNationsCupZoneRunnerUp(String zone) {
    return '$zone · Финалист';
  }

  @override
  String careerNationsCupZoneSemi(String zone) {
    return '$zone · Полуфиналист';
  }

  @override
  String careerNationsCupZoneRoundOf16(String zone) {
    return '$zone · 1/8 финала';
  }

  @override
  String careerNationsCupZoneQuarter(String zone) {
    return '$zone · Четвертьфиналист';
  }

  @override
  String careerNationsCupZonePlaced(String zone, int position) {
    return '$zone · #$position';
  }

  @override
  String get objectiveNcFinalsEight => 'Выйти в четвертьфинал';

  @override
  String get objectiveNcZoneWinGroup => 'Выиграть свою группу';

  @override
  String get finishNcFinalsEight => 'Четвертьфинал';

  @override
  String get finishNcBottomHalf => 'Нижняя половина группы';

  @override
  String get tourContTabZones => 'ЗОНЫ';

  @override
  String get tourContTabFinalsEight => 'ПЛЕЙ-ОФФ';

  @override
  String get tourContFinalsEightSoon =>
      'Плей-офф начинается в ноябре с 1/8 финала: все 14 победителей групп и 2 лучшие команды со вторых мест.';

  @override
  String get tourContQuarterFinals => 'ЧЕТВЕРТЬФИНАЛЫ';

  @override
  String get tourContZoneAdvancement =>
      'Каждый победитель группы выходит в 1/8 финала вместе с 2 лучшими командами со вторых мест. Никто не вылетает.';

  @override
  String tourContZoneHeadingYours(String zone) {
    return '$zone ★';
  }

  @override
  String get compNorthAmericaNationsCup => 'Кубок наций Северной Америки';

  @override
  String get compAfricanNationsCup => 'Кубок наций';

  @override
  String get objectiveNcWinItNorthAmerica =>
      'Выиграть Кубок наций Северной Америки';

  @override
  String get objectiveNcWinItAfrica => 'Выиграть Кубок наций';

  @override
  String get objectiveNcReachFinalNorthAmerica =>
      'Выйти в финал Кубка наций Северной Америки';

  @override
  String get objectiveNcReachFinalAfrica => 'Выйти в финал Кубка наций';

  @override
  String get finishNcChampionsNorthAmerica =>
      'Обладатели Кубка наций Северной Америки';

  @override
  String get finishNcChampionsAfrica => 'Обладатели Кубка наций';

  @override
  String pressAimQualWarm1(String competition) {
    return '$competition: отбор начинается, и страна верит в эту команду. Какая у вас цель?';
  }

  @override
  String pressAimQualWarm2(String competition) {
    return 'Новый отборочный цикл ($competition), и настроение отличное. Как далеко может пойти эта команда?';
  }

  @override
  String pressAimQualNeutral1(String competition) {
    return '$competition: отбор начинается. Какая цель на этот цикл?';
  }

  @override
  String pressAimQualNeutral2(String competition) {
    return 'Отбор начался ($competition). Где вы видите эту команду в итоге?';
  }

  @override
  String pressAimQualHostile1(String competition) {
    return '$competition: отбор начинается, и многие сомневаются, что вы пробьётесь. Что вы им скажете?';
  }

  @override
  String pressAimQualHostile2(String competition) {
    return 'Ещё один отборочный цикл ($competition). Почему кто-то должен верить, что в этот раз будет иначе?';
  }

  @override
  String pressAimFinalsWarm1(String competition) {
    return '$competition начинается, и вся страна за вас. Как далеко вы можете пойти?';
  }

  @override
  String pressAimFinalsWarm2(String competition) {
    return 'Вы на турнире ($competition), и болельщики мечтают. Какая цель?';
  }

  @override
  String pressAimFinalsNeutral1(String competition) {
    return '$competition стартует на этой неделе. Что вы будете считать успехом?';
  }

  @override
  String pressAimFinalsNeutral2(String competition) {
    return 'Первый матч на турнире ($competition) уже близко. Назовите нам цель.';
  }

  @override
  String pressAimFinalsHostile1(String competition) {
    return '$competition начинается, и никто многого не ждёт. На что вы на самом деле надеетесь?';
  }

  @override
  String pressAimFinalsHostile2(String competition) {
    return 'Вы на турнире ($competition), но сомнения никуда не делись. Какая у вас цель?';
  }

  @override
  String pressBeatRivalWarm1(String rival) {
    return '$rival в вашей группе. Они вас беспокоят?';
  }

  @override
  String pressBeatRivalWarm2(String rival) {
    return 'Жеребьёвка свела вас с соперником $rival. Как вы видите этот матч?';
  }

  @override
  String pressBeatRivalNeutral1(String rival) {
    return '$rival выглядят сильнейшей командой вашей группы. Они фавориты?';
  }

  @override
  String pressBeatRivalNeutral2(String rival) {
    return 'Что вы думаете о сопернике $rival?';
  }

  @override
  String pressBeatRivalHostile1(String rival) {
    return '$rival в вашей группе. Честно, вы можете с ними тягаться?';
  }

  @override
  String pressBeatRivalHostile2(String rival) {
    return 'Большинство ждёт, что $rival вас обыграют. Они ошибаются?';
  }

  @override
  String pressBeatKeyPlayerWarm1(String player) {
    return '$player в отличной форме. Это его момент?';
  }

  @override
  String pressBeatKeyPlayerWarm2(String player) {
    return '$player во всех заголовках. Сможет он тащить эту команду?';
  }

  @override
  String pressBeatKeyPlayerNeutral1(String player) {
    return 'Насколько этот цикл зависит от игрока $player?';
  }

  @override
  String pressBeatKeyPlayerNeutral2(String player) {
    return '$player готов вести эту команду?';
  }

  @override
  String pressBeatKeyPlayerHostile1(String player) {
    return 'Если $player не в лучшей форме, есть ли у этой команды хоть что-то?';
  }

  @override
  String pressBeatKeyPlayerHostile2(String player) {
    return 'На плечах игрока $player очень многое. Не слишком ли?';
  }

  @override
  String get pressReplyAimHigher1 => 'Мы пойдём дальше, чем кто-либо ожидает.';

  @override
  String get pressReplyAimHigher2 =>
      'Я хочу большего, чем просила федерация, и скажу это вслух.';

  @override
  String get pressReplyMatchBrief1 => 'Мы знаем цель и достигнем её.';

  @override
  String get pressReplyMatchBrief2 =>
      'Федерация поставила цель. Мы её выполним.';

  @override
  String get pressReplyPlayDown1 => 'Давайте идти от матча к матчу.';

  @override
  String get pressReplyPlayDown2 =>
      'Без громких обещаний. Посмотрим, где окажемся.';

  @override
  String get pressReplyPromiseQualify1 => 'Мы пройдём отбор. Можете записать.';

  @override
  String get pressReplyPromiseQualify2 =>
      'Эта команда будет в финальном турнире.';

  @override
  String get pressReplyFearNobody1 => 'Мы никого не боимся.';

  @override
  String get pressReplyFearNobody2 => 'Им тоже придётся играть с нами.';

  @override
  String get pressReplyRespectRival1 => 'Они фавориты, и мы их уважаем.';

  @override
  String get pressReplyRespectRival2 =>
      'Очень сильная команда. Нам понадобится всё лучшее.';

  @override
  String get pressReplyTeamFirst1 =>
      'Дело во всей команде, а не в одном игроке.';

  @override
  String get pressReplyTeamFirst2 => 'В одиночку здесь никто не побеждает.';

  @override
  String pressOnRecordTarget(String aim) {
    return 'Под запись: $aim.';
  }

  @override
  String get pressOnRecordPlayDown => 'Под запись: никаких обещаний.';

  @override
  String get pressThrowbackTargetKeptWarm =>
      'Вы поставили цель перед циклом и достигли её. Это ваш главный повод для гордости?';

  @override
  String get pressThrowbackTargetKeptNeutral =>
      'Вы сказали, чего добьётесь, и добились. Были ли сомнения?';

  @override
  String get pressThrowbackTargetKeptHostile =>
      'Вы достигли цели, которую поставили. Повезло, или так и было задумано?';

  @override
  String get pressThrowbackTargetBrokenWarm =>
      'Вы поставили цель и не дотянули. Что пошло не так?';

  @override
  String get pressThrowbackTargetBrokenNeutral =>
      'Вы обещали больше, чем дала эта команда. Жалеете, что сказали?';

  @override
  String get pressThrowbackTargetBrokenHostile =>
      'Перед циклом вы говорили громко и не дотянули. Почему мы должны верить вам сейчас?';

  @override
  String hubEventPressPreviewSub(String competition) {
    return 'Пресса хочет услышать твои цели: $competition';
  }

  @override
  String deptLevelCost(int level, String amount) {
    return 'Уровень $level · $amount';
  }

  @override
  String get formOnFire => 'В огне';

  @override
  String get formGood => 'В форме';

  @override
  String get formSteady => 'Стабильно';

  @override
  String get formPoor => 'Вне формы';

  @override
  String get formCold => 'Ледяной';

  @override
  String get playerFormTitle => 'ФОРМА И ЗДОРОВЬЕ';

  @override
  String playerFormAverage(String rating) {
    return 'Средняя оценка в последних матчах: $rating';
  }

  @override
  String get playerFormNoGames => 'Мало недавних матчей для оценки';

  @override
  String playerFormNextMatch(String delta) {
    return '$delta к рейтингу в следующем матче';
  }

  @override
  String get playerFormNoEffect => 'Рейтинг в следующем матче не изменится';

  @override
  String playerFormSquadShare(String delta) {
    return 'Включая $delta для всей команды (мораль, базовый лагерь)';
  }

  @override
  String get sideGroupHome => 'Главная';

  @override
  String get sideGroupTeam => 'Команда';

  @override
  String get sideGroupCompetitions => 'Турниры';

  @override
  String get sideGroupFederation => 'Федерация';

  @override
  String get sideGroupHistory => 'История';

  @override
  String get sideInbox => 'Входящие';

  @override
  String get sideSquad => 'Состав';

  @override
  String get sideTactics => 'Тактика';

  @override
  String get sideMainMenu => 'Главное меню';

  @override
  String get sideCallUps => 'Вызовы';

  @override
  String get sideTournaments => 'Турниры';

  @override
  String get sideRanking => 'Рейтинг';

  @override
  String get sideResults => 'Результаты';

  @override
  String get sideFinances => 'Финансы';

  @override
  String get sideBoard => 'Руководство';

  @override
  String get sideManager => 'Тренер и штаб';

  @override
  String get sideRecords => 'Рекорды';

  @override
  String get sideLegends => 'Легенды';

  @override
  String get sideHeadToHead => 'Личные встречи';

  @override
  String get sideAchievements => 'Достижения';

  @override
  String get sideCareer => 'Карьера';

  @override
  String get topBarNext => 'Далее';

  @override
  String get topBarDrawPending => 'Жеребьёвка впереди';

  @override
  String get paneFullProfile => 'Полный профиль';

  @override
  String get panePickPlayer =>
      'Выбери игрока, чтобы увидеть здесь его карточку';

  @override
  String get inboxPickMessage => 'Выбери сообщение, чтобы прочитать его здесь';

  @override
  String get inboxFilterAll => 'Все';

  @override
  String get panelViewAll => 'Смотреть все';

  @override
  String get gridViewOverview => 'Обзор';

  @override
  String get gridColCondition => 'Состояние';

  @override
  String get gridColStatus => 'Статус';

  @override
  String get gridColRank => 'Место';

  @override
  String get gridColMove => 'Изм.';

  @override
  String get gridColNation => 'Сборная';

  @override
  String get gridColRegion => 'Регион';

  @override
  String get gridColPoints => 'Очки';

  @override
  String get panePickNation =>
      'Выбери сборную, чтобы увидеть здесь её статистику';

  @override
  String get resultsCyclesTitle => 'Циклы';

  @override
  String get tourDrawStart => 'Начать жеребьёвку';

  @override
  String get tourDrawViewGroups => 'Смотреть группы';

  @override
  String get gridColCeiling => 'Потолок';

  @override
  String get gridColYearGain => 'Прирост';

  @override
  String get gridColMarkedAt => 'Когда отмечен';

  @override
  String get budgetSetupTitle => 'Утверди бюджет';

  @override
  String get budgetEffectsTitle => 'Что даёт этот бюджет';

  @override
  String get naturalisationTitle => 'Натурализация';

  @override
  String get yTrending => 'В тренде';

  @override
  String get yVoices => 'Голоса';

  @override
  String get yConversation => 'Обсуждение';

  @override
  String get allTimeRecordsTitle => 'Мировые рекорды за всю историю';

  @override
  String get h2hMeetingsTitle => 'Все встречи';

  @override
  String get h2hPickOpponent =>
      'Выбери соперника, чтобы увидеть здесь все встречи';

  @override
  String get savesTitle => 'Сохранения';

  @override
  String get gridColPlayer => 'Игрок';

  @override
  String get gridColPos => 'Поз';

  @override
  String get gridColActive => 'Играет';

  @override
  String get gridColMotm => 'ИМ';

  @override
  String get gridColAvg => 'Ср.';

  @override
  String get gridColOpponent => 'Соперник';

  @override
  String get gridColStarts => 'В старте';

  @override
  String get gridColTournaments => 'Турниры';

  @override
  String get gridColDate => 'Дата';

  @override
  String get gridColLastPlayed => 'Последняя игра';

  @override
  String get gridColManager => 'Тренер';

  @override
  String nationsShownCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count сборной',
      many: '$count сборных',
      few: '$count сборные',
      one: '$count сборная',
    );
    return '$_temp0';
  }

  @override
  String get nationsSortedByRank => 'По мировому рейтингу';

  @override
  String get nationsStrength => 'Сила';

  @override
  String nationsStrengthOf(int tier) {
    return '$tier из 5';
  }

  @override
  String get nationsSquadOverall => 'Рейтинг состава';

  @override
  String get nationsOpeningBudget => 'Стартовый бюджет';

  @override
  String get nationsStarPlayer => 'Звезда';

  @override
  String nationsStarTile(String position, int rating) {
    return 'Звезда $position $rating';
  }

  @override
  String nationsStarAge(int age) {
    return 'Возраст $age';
  }

  @override
  String get nationsBoardExpects => 'Руководство ожидает';

  @override
  String nationsManage(String nation) {
    return 'Возглавить: $nation';
  }

  @override
  String get nationsManagerNext => 'Дальше ты назовёшь своего тренера';

  @override
  String get playerPageTitle => 'Игрок';

  @override
  String get nationPageTitle => 'Сборная';

  @override
  String get friendliesYourGames => 'Твои товарищеские матчи';

  @override
  String hubEventInjuryCover(String player) {
    return 'Замени травмированного: $player';
  }

  @override
  String hubEventInjuryCoverSub(int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: 'Пропустит $matches матча',
      many: 'Пропустит $matches матчей',
      few: 'Пропустит $matches матча',
      one: 'Пропустит $matches матч',
    );
    return '$_temp0. Вызови кого-то или играй без него.';
  }

  @override
  String get injuryCoverTitle => 'ЗАМЕНА';

  @override
  String injuryCoverBanner(String player, String position) {
    return '$player ($position) травмирован. Вызови любого игрока вне состава на любую позицию или оставь его и играй дальше.';
  }

  @override
  String injuryCoverConfirm(String player) {
    return 'Вызвать: $player';
  }

  @override
  String injuryCoverKeep(String player) {
    return 'Оставить игрока $player и играть дальше';
  }

  @override
  String get injuryCoverPick => 'Выбери замену';

  @override
  String get injuryCoverNone => 'Вне состава нет здоровых игроков.';

  @override
  String get nationNowRanking => 'Мировой рейтинг';

  @override
  String get nationNowForm => 'Форма';

  @override
  String get nationNowNoForm => 'Матчей пока нет';

  @override
  String get nationNowNext => 'Следующий матч';

  @override
  String get nationNowNoNext => 'Ничего не запланировано';

  @override
  String get nationNowSquad => 'Состав';

  @override
  String get nationNowAgainstYou => 'Против тебя';

  @override
  String nationNowRecord(int w, int d, int l) {
    return '$wВ $dН $lП';
  }

  @override
  String get nationNowLastMeeting => 'Последняя встреча';

  @override
  String nationNowOverall(int value) {
    return 'Рейтинг $value';
  }

  @override
  String get hubUpcoming => 'ВПЕРЕДИ';

  @override
  String get hubFullSchedule => 'Всё расписание';

  @override
  String get scheduleTitle => 'Расписание';

  @override
  String get scheduleToday => 'Сегодня';

  @override
  String get scheduleKnockoutPending => 'Плей-офф, если пройдёшь';

  @override
  String get scheduleNextRoundPending => 'Следующий раунд';

  @override
  String scheduleFromDate(String date) {
    return 'С $date';
  }

  @override
  String get scheduleHomeShort => 'Д';

  @override
  String get scheduleAwayShort => 'Г';

  @override
  String get tacticsNoPresetsInMatch =>
      'Сохранённых тактик пока нет. Сохрани тактику на экране «Тактика» перед матчем.';

  @override
  String get homeCampaigns => 'Кампании';

  @override
  String get homeContinueCampaign => 'ПРОДОЛЖИТЬ КАМПАНИЮ';

  @override
  String homeCampaignCycle(String date, int cycle, int total) {
    return '$date · Цикл $cycle из $total';
  }

  @override
  String get campaignsTitle => 'Кампании';

  @override
  String get campaignTransplantTitle => 'Пересадка';

  @override
  String get campaignTransplantTwist =>
      'Шестеро лучших итальянцев переходят в сборную Сан-Марино';

  @override
  String get campaignTransplantGoal => 'Пробиться на чемпионат Европы';

  @override
  String get campaignGrudgeTitle => 'Старые счёты';

  @override
  String get campaignGrudgeTwist => 'Грузия и Албания в одной группе';

  @override
  String get campaignGrudgeGoal => 'Финишировать в отборе выше Албании';

  @override
  String get campaignTransplantIntro =>
      'У Сан-Марино никогда не было достойного отборочного цикла. И тут шестеро лучших игроков Италии берут паспорт и приходят в команду. У тебя один цикл, чтобы превратить курьёз в команду.';

  @override
  String get campaignGrudgeIntro =>
      'Грузия и Албания попали в одну отборочную группу, и ни одна не простит поражения. Финишируй выше Албании, а потом посмотри, как далеко можно зайти.';

  @override
  String get campaignStars1Transplant => 'Пробиться';

  @override
  String get campaignStars2Transplant => 'Выйти в плей-офф';

  @override
  String get campaignStars3Transplant => 'Выиграть чемпионат Европы';

  @override
  String get campaignStars1Grudge => 'Выше Албании';

  @override
  String get campaignStars2Grudge => 'И пробиться';

  @override
  String get campaignStars3Grudge => 'И обыграть их дважды';

  @override
  String get campaignFree => 'Бесплатно';

  @override
  String get campaignStart => 'Начать';

  @override
  String get campaignPartOfUnlimited => 'Входит в Unlimited';

  @override
  String get campaignResume => 'Продолжить';

  @override
  String get campaignAbandon => 'Бросить';

  @override
  String get campaignAbandonConfirm =>
      'Бросить это прохождение? Прогресс будет потерян, а печать останется.';

  @override
  String get campaignMoveToSaves => 'Перенести в сохранения';

  @override
  String get campaignCannotContinue =>
      'Мир этой кампании слишком далёк от настоящего, чтобы продолжить его как карьеру.';

  @override
  String get campaignMoveSlotsFull =>
      'Слоты сохранений заполнены. Сначала освободи один.';

  @override
  String get campaignStampConquered => 'Покорено';

  @override
  String get campaignStampFailed => 'Провалено';

  @override
  String get campaignDifficultyHard => 'Сложно';

  @override
  String get campaignDifficultyMedium => 'Средне';

  @override
  String get campaignGoalLabel => 'Цель';

  @override
  String get campaignStarsLabel => 'Звёзды';

  @override
  String get campaignRunInProgress => 'В этой кампании уже идёт прохождение.';

  @override
  String get campaignVerdictWon => 'Покорено';

  @override
  String get campaignVerdictLost => 'Не в этот раз';

  @override
  String get campaignVerdictContinue => 'Продолжить';

  @override
  String campaignProgressQualifying(String position) {
    return 'Отбор: $position';
  }

  @override
  String campaignProgressRival(String rival, String position) {
    return '$rival: $position';
  }

  @override
  String campaignProgressFinals(String stage) {
    return 'Финальный турнир: $stage';
  }

  @override
  String get campaignRunInNumbers => 'Прохождение в цифрах';

  @override
  String campaignRunMeetings(int won, int played) {
    return 'Выиграно встреч: $won из $played';
  }

  @override
  String campaignPlace(String which, int n) {
    String _temp0 = intl.Intl.selectLogic(
      which,
      {
        'first': '1-е',
        'second': '2-е',
        'third': '3-е',
        'other': '$n-е',
      },
    );
    return '$_temp0';
  }

  @override
  String get campaignGuineasTitle => 'Лучшая из Гвиней';

  @override
  String get campaignGuineasTwist =>
      'Экваториальная Гвинея, самая маленькая из африканских Гвиней, на два цикла';

  @override
  String get campaignGuineasGoal => 'Обыграть Гвинею и Гвинею-Бисау';

  @override
  String get campaignGuineasIntro =>
      'Три африканские страны носят имя Гвинея, и Экваториальная Гвинея – самая маленькая из них. У тебя два цикла, чтобы хотя бы раз обыграть Гвинею и Гвинею-Бисау, а потом посмотреть, как далеко можно зайти на чемпионате Африки. С Папуа – Новой Гвинеей, четвёртой Гвинеей, уже назначен товарищеский матч.';

  @override
  String get campaignStars1Guineas => 'Обыграть Гвинею и Гвинею-Бисау';

  @override
  String get campaignStars2Guineas => 'И пробиться на чемпионат Африки';

  @override
  String get campaignStars3Guineas =>
      'И выйти в четвертьфинал чемпионата Африки';

  @override
  String get campaignYoungFinnsTitle => 'Молодые финны';

  @override
  String get campaignYoungFinnsTwist =>
      'Золотое поколение финских подростков, на три цикла';

  @override
  String get campaignYoungFinnsGoal => 'Пробиться на чемпионат мира';

  @override
  String get campaignYoungFinnsIntro =>
      'Опытные игроки Финляндии ушли в сторону, и их место заняло золотое поколение: каждому, кого можно вызвать, 18 лет или меньше. Сегодня они сырые, но у них есть талант стать одной из лучших команд мира, как молодое поколение Норвегии. У тебя три цикла, чтобы довести их до чемпионата мира, а затем выиграть чемпионат Европы и чемпионат мира.';

  @override
  String get campaignStars1YoungFinns => 'Пробиться на чемпионат мира';

  @override
  String get campaignStars2YoungFinns => 'Выиграть чемпионат Европы';

  @override
  String get campaignStars3YoungFinns => 'Выиграть чемпионат мира';

  @override
  String get campaignGreenlandTitle => 'Гренландский век';

  @override
  String get campaignGreenlandTwist =>
      'Гренландия занимает место Сан-Марино в Европе на сто лет';

  @override
  String get campaignGreenlandGoal => 'Пробиться на чемпионат Европы';

  @override
  String get campaignGreenlandIntro =>
      'Гренландия никогда не играла официальных матчей. В этом мире она заняла место Сан-Марино в Европе и начинает с самого дна мирового рейтинга: игроки-любители, искусственные поля и сезон, зажатый между снегами. У тебя сто лет, двадцать пять циклов, чтобы попасть на чемпионат Европы, затем на чемпионат мира и, если осмелишься мечтать, выиграть один из них.';

  @override
  String get campaignStars1Greenland => 'Пробиться на чемпионат Европы';

  @override
  String get campaignStars2Greenland => 'Пробиться на чемпионат мира';

  @override
  String get campaignStars3Greenland =>
      'Выиграть чемпионат Европы или чемпионат мира';

  @override
  String get campaignZanzibarTitle => 'Восход Занзибара';

  @override
  String get campaignZanzibarTwist =>
      'Занзибар занимает место Чада в Африке на сто лет';

  @override
  String get campaignZanzibarGoal => 'Пробиться на чемпионат Африки';

  @override
  String get campaignZanzibarIntro =>
      'У Занзибара есть своя футбольная ассоциация и своя сборная, но нет места в африканском и мировом футболе. В этом мире он занял место Чада в Африке и начинает у самого дна мирового рейтинга: островные игроки, маленькие стадионы и жара муссонов. У тебя сто лет, двадцать пять циклов, чтобы попасть на чемпионат Африки, затем на чемпионат мира и, если осмелишься мечтать, выиграть чемпионат мира.';

  @override
  String get campaignStars1Zanzibar => 'Пробиться на чемпионат Африки';

  @override
  String get campaignStars2Zanzibar => 'Пробиться на чемпионат мира';

  @override
  String get campaignStars3Zanzibar => 'Выиграть чемпионат мира';

  @override
  String get campaignPro => 'Pro';

  @override
  String campaignProgressCup(String cup, String year, String status) {
    return '$cup $year: $status';
  }

  @override
  String get campaignCupNotQualified => 'Не прошли отбор';

  @override
  String get campaignCupOpen => 'Ещё решается';

  @override
  String campaignWorldRenames(String nation) {
    return 'Эта база данных переименовывает сборную, вокруг которой построена кампания: $nation.';
  }

  @override
  String newsYouthTitle1(String name, String level) {
    return '$name блистает за $level';
  }

  @override
  String newsYouthTitle2(String name, String level) {
    return 'Отчёт академии: $name обращает на себя внимание';
  }

  @override
  String newsYouthTitle3(String name, String level) {
    return 'Лучший в $level: $name';
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
      other: 'забил $count гола',
      many: 'забил $count голов',
      few: 'забил $count гола',
      one: 'забил $count гол',
    );
    return '$name $_temp0 за $level против соперника $opponent в последнее международное окно.';
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
      many: '$count голов',
      few: '$count гола',
      one: '$count гол',
    );
    return '$_temp0 у игрока $name: $level сыграла с соперником $opponent в этом окне.';
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
      many: '$count голов',
      few: '$count гола',
      one: '$count гол',
    );
    return '$level встречалась с соперником $opponent, и $name записал на свой счёт $_temp0.';
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
      other: 'отдал $count голевой передачи',
      many: 'отдал $count голевых передач',
      few: 'отдал $count голевые передачи',
      one: 'отдал $count голевую передачу',
    );
    return '$name $_temp0 за $level против соперника $opponent и вёл игру от начала до конца.';
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
      other: '$count голевой передачи',
      many: '$count голевых передач',
      few: '$count голевые передачи',
      one: '$count голевая передача',
    );
    return '$level встречалась с соперником $opponent в этом окне, и $name дёргал за все ниточки: $_temp0 и игра, которую штаб до сих пор обсуждает.';
  }

  @override
  String newsYouthCleanSheet1(String name, String level, String opponent) {
    return '$name был великолепен, когда $level сыграла на ноль против соперника $opponent.';
  }

  @override
  String newsYouthCleanSheet2(String name, String level, String opponent) {
    return '$level сыграла на ноль против соперника $opponent, и во многом благодаря игроку $name.';
  }

  @override
  String newsYouthDisplay1(
    String name,
    String level,
    String opponent,
    int mark,
  ) {
    return '$name впечатлил за $level против соперника $opponent, и штаб оценил его игру на $mark из десяти.';
  }

  @override
  String newsYouthDisplay2(
    String name,
    String level,
    String opponent,
    int mark,
  ) {
    return '$level сыграла с соперником $opponent в этом окне, и тренеры выделили игрока $name: $mark из десяти, лучшая оценка в команде.';
  }

  @override
  String get newsYouthDevReady1 =>
      'В такой форме он уже достаточно хорош, чтобы рассматривать его для основной сборной.';

  @override
  String get newsYouthDevReady2 =>
      'Штаб считает, что он готов к взрослому футболу уже сейчас. Решение за тобой.';

  @override
  String get newsYouthDevClose1 =>
      'Он хорошо прогрессирует и близок к тому, чтобы пробиться в основную сборную.';

  @override
  String get newsYouthDevClose2 =>
      'До основной сборной ему недалеко, и ещё один хороший сезон может всё решить.';

  @override
  String get newsYouthDevGrowing1 =>
      'Он хорошо развивается, хотя до основной сборной ещё шаг-другой.';

  @override
  String get newsYouthDevGrowing2 =>
      'Работы ещё много, прежде чем он станет игроком основной сборной, но всё идёт в правильном направлении.';

  @override
  String get newsYouthDevRaw1 =>
      'Он ещё сырой, и до основной сборной несколько лет, но талант виден невооружённым глазом.';

  @override
  String get newsYouthDevRaw2 =>
      'Пока рано, и штаб академии просит терпения, а не заголовков.';

  @override
  String get newsYouthStrengthGkPhysical =>
      'Его выделяют длинные руки и уверенность в штрафной.';

  @override
  String get newsYouthStrengthGkTechnical =>
      'Его игра руками и ввод мяча лучшие в академии за много лет.';

  @override
  String get newsYouthStrengthGkStamina =>
      'Его концентрация не падает, и на девяностой минуте он так же собран, как на первой.';

  @override
  String get newsYouthStrengthDefPhysical =>
      'Скорость и игра в воздухе – основа его игры.';

  @override
  String get newsYouthStrengthDefTechnical =>
      'Он читает игру не по годам и хладнокровен с мячом.';

  @override
  String get newsYouthStrengthDefStamina =>
      'Он никогда не отключается и даже на последней минуте спринтует назад.';

  @override
  String get newsYouthStrengthMidPhysical =>
      'Он отбирает мяч с настоящей мощью и сам тащит его вперёд.';

  @override
  String get newsYouthStrengthMidTechnical =>
      'Видение поля и диапазон передач – основа его игры.';

  @override
  String get newsYouthStrengthMidStamina =>
      'Его мотор поразителен: он покрывает каждую травинку поля.';

  @override
  String get newsYouthStrengthFwdPhysical =>
      'Скорость за спину и сила в воздухе делают его головной болью для любой обороны.';

  @override
  String get newsYouthStrengthFwdTechnical =>
      'Завершение и движение в штрафной – основа его игры.';

  @override
  String get newsYouthStrengthFwdStamina =>
      'Он прессингует с первой линии весь матч и не даёт защитникам ни секунды покоя.';

  @override
  String pressMomentBigWinWarm3(String opponent) {
    return 'Болельщики ещё долго будут петь о матче с соперником $opponent. Что вы сказали игрокам после финального свистка?';
  }

  @override
  String pressMomentBigWinNeutral3(String opponent) {
    return 'Против соперника $opponent это было заявление. Сколько в этом от тренировочного поля?';
  }

  @override
  String pressMomentBigWinHostile3(String opponent) {
    return 'Результат против соперника $opponent заслуживает похвалы, но такие вечера мы уже видели. Что изменилось на этот раз?';
  }

  @override
  String pressMomentBigLossWarm3(String opponent) {
    return 'У каждого бывает плохой вечер, и против соперника $opponent был как раз такой. Как быстро вы сможете это оставить позади?';
  }

  @override
  String pressMomentBigLossNeutral3(String opponent) {
    return '$opponent были лучше во всех компонентах. С чего вы начнёте исправлять?';
  }

  @override
  String pressMomentBigLossHostile3(String opponent) {
    return 'Болельщики уходили до конца матча с соперником $opponent. Можно их винить?';
  }

  @override
  String pressMomentCrisisWarm3(String opponent) {
    return 'Серия тяжёлая, и матч с соперником $opponent легче не сделал. Что придаёт вам сил?';
  }

  @override
  String pressMomentCrisisNeutral3(String opponent) {
    return 'Ещё один матч без победы, теперь против соперника $opponent. Сколько это может длиться, пока руководство не вмешается?';
  }

  @override
  String pressMomentCrisisHostile3(String opponent) {
    return 'Ещё и $opponent. В вашем плане что-то осталось, или пора уступить место другому?';
  }

  @override
  String get pressReplyCreditPlayers5 =>
      'Что бы вы ни писали, пишите об игроках. Они это заслужили.';

  @override
  String get pressReplyCreditPlayers6 =>
      'У меня группа, которая готова друг за друга пробивать стены. Это немало.';

  @override
  String get pressReplyTakeResponsibility5 =>
      'Решения принимаю я, значит, и критика ко мне. Такая работа.';

  @override
  String get pressReplyTakeResponsibility6 =>
      'Сначала посмотрите на тренера. Я ошибся и всё исправлю.';

  @override
  String get pressReplyDemandMore5 =>
      'Хорошо здесь недостаточно. Я сказал им это в лицо.';

  @override
  String get pressReplyDemandMore6 =>
      'Никому в той раздевалке место в составе не гарантировано. Теперь они это знают.';

  @override
  String get pressReplyDeflect5 =>
      'Можете спросить тремя разными способами. Ответ будет тот же.';

  @override
  String get pressReplyDeflect6 =>
      'Свои мысли я оставлю для игроков. Вы поймёте.';

  @override
  String yWinRoutine12(String opponent, String score) {
    return '$score против соперника $opponent. Спокойный, контролируемый, взрослый футбол. Приятно смотреть.';
  }

  @override
  String yWinRoutine13(String opponent, String score) {
    return 'Обыграли соперника $opponent $score, даже не вспотев. Эта команда учится быть скучной, а скучные выигрывают трофеи.';
  }

  @override
  String yWinRoutine14(String opponent, String score) {
    return '$opponent, $score. Три очка, без драмы, за работу.';
  }

  @override
  String yWinRoutine15(String opponent, String score) {
    return 'Рядовые $score против соперника $opponent. Никто не вспомнит, и не нужно.';
  }

  @override
  String yWinRoutine16(String opponent, String score) {
    return '$score против соперника $opponent, а я почему-то всё равно встревожен.';
  }

  @override
  String yWinRoutine17(String opponent, String score) {
    return 'Обыграли соперника $opponent $score. Против настоящей команды за такую игру накажут.';
  }

  @override
  String yWinTight12(String opponent, String score) {
    return '$score против соперника $opponent. Зарылись, терпели, выиграли. Вот это команда.';
  }

  @override
  String yWinTight13(String opponent, String score) {
    return 'Обыграли соперника $opponent $score на одних нервах. Мне нравится команда, которая отказывается проигрывать.';
  }

  @override
  String yWinTight14(String opponent, String score) {
    return '$opponent, $score. До последних секунд, но очки наши.';
  }

  @override
  String yWinTight15(String opponent, String score) {
    return 'Минимальная победа $score над соперником $opponent. Разница невелика, это футбол.';
  }

  @override
  String yWinTight16(String opponent, String score) {
    return '$score против соперника $opponent. Один отскок в другую сторону, и разговор был бы совсем другим.';
  }

  @override
  String yWinTight17(String opponent, String score) {
    return 'Отбились против соперника $opponent, $score. Никто не должен называть это игрой.';
  }

  @override
  String yDrew12(String opponent, String score) {
    return '$score с соперником $opponent. Не поражение, а иногда в этом и есть работа.';
  }

  @override
  String yDrew13(String opponent, String score) {
    return 'Тяжело добытое очко против соперника $opponent, $score. Мне понравился наш характер.';
  }

  @override
  String yDrew14(String opponent, String score) {
    return '$opponent, $score. Боевая ничья, как говорили старые комментаторы.';
  }

  @override
  String yDrew15(String opponent, String score) {
    return '$score с соперником $opponent. Ни одна команда не сделала достаточно для большего.';
  }

  @override
  String yDrew16(String opponent, String score) {
    return '$score с соперником $opponent. Такая ничья в автобусе по дороге домой ощущается как поражение.';
  }

  @override
  String yDrew17(String opponent, String score) {
    return 'Ничья $score с соперником $opponent. Мы всё говорим о прогрессе и всё делаем вот это.';
  }

  @override
  String yLost12(String opponent, String score) {
    return '$score от соперника $opponent. Больно, но я увидел достаточно, чтобы верить в эту команду.';
  }

  @override
  String yLost13(String opponent, String score) {
    return 'Поражение $score от соперника $opponent, и они были хороши. Уважаем и идём снова.';
  }

  @override
  String yLost14(String opponent, String score) {
    return '$opponent, $score. Поражение, несколько уроков, и скоро следующий матч.';
  }

  @override
  String yLost15(String opponent, String score) {
    return 'Проиграли $score сопернику $opponent. Спорить трудно.';
  }

  @override
  String yLost16(String opponent, String score) {
    return '$score от соперника $opponent. Те же ошибки, что и в прошлый раз, с той же уверенностью.';
  }

  @override
  String yLost17(String opponent, String score) {
    return 'Поражение $score от соперника $opponent. Если за это никто не отвечает, что мы вообще делаем?';
  }

  @override
  String get yReactionShrug12 =>
      'Меня устраивает. Не каждый вечер нужен фейерверк.';

  @override
  String get yReactionShrug13 => 'Очки есть очки. Сегодня сплю спокойно.';

  @override
  String get yReactionShrug14 => 'Посмотрел. Замечаний нет.';

  @override
  String get yReactionShrug15 => 'Где-то между нормально и нормально.';

  @override
  String get yReactionShrug16 =>
      'Заплатил за трансляцию ради этого. Больше никогда (я вернусь).';

  @override
  String get yReactionShrug17 => 'Девяносто минут ничего в форме футбола.';

  @override
  String get yReactionRelief12 => 'Снова дышу. Горжусь, что выстояли.';

  @override
  String get yReactionRelief13 =>
      'Вот такие победы и строят команду. Уродливое прекрасно.';

  @override
  String get yReactionRelief14 => 'Ногтей больше нет, а очки на месте.';

  @override
  String get yReactionRelief15 =>
      'Финальный свисток ещё никогда не звучал так сладко.';

  @override
  String get yReactionRelief16 => 'Рад, что выиграли, тревожно, как выиграли.';

  @override
  String get yReactionRelief17 => 'Нам всё сходит с рук. Однажды не сойдёт.';

  @override
  String get yReactionFury12 =>
      'Я люблю эту команду, и именно поэтому так больно.';

  @override
  String get yReactionFury13 =>
      'Плохой вечер. В следующий раз они нам должны, и они это знают.';

  @override
  String get yReactionFury14 =>
      'Выключил на семидесятой минуте. Надо было на шестидесятой.';

  @override
  String get yReactionFury15 => 'Ни борьбы, ни идей, ни оправданий.';

  @override
  String get yReactionFury16 =>
      'Каждый раз одни и те же проблемы, и никто ничего не исправляет.';

  @override
  String get yReactionFury17 =>
      'Кому-то в федерации надо пересмотреть это и объяснить.';

  @override
  String get backupShareHint =>
      'Создаёт один файл копии всех сохранений. Выбери Google Drive, iCloud Drive или «Файлы», чтобы его сохранить.';

  @override
  String backupLastAt(String date) {
    return 'Последняя копия: $date';
  }

  @override
  String get backupNever => 'Копий пока нет';

  @override
  String get backupRemindersTitle => 'Напоминания о копиях';

  @override
  String get backupRemindersBlurb =>
      'Заметка во входящих, когда последняя копия устаревает.';

  @override
  String get backupAutoICloudTitle => 'Автокопия в iCloud';

  @override
  String get backupAutoDriveTitle => 'Автокопия в Google Drive';

  @override
  String get backupAutoBlurb =>
      'Копирует после матчей, в конце цикла и при выходе из приложения. Хранит две последние.';

  @override
  String get backupStatusUploading => 'Идёт копирование.';

  @override
  String get backupStatusUploaded => 'Скопировано.';

  @override
  String get backupStatusICloudSignedOut =>
      'iCloud выключен. Войди в iCloud и включи iCloud Drive в приложении «Настройки».';

  @override
  String get backupStatusDriveSignedOut =>
      'Вход не выполнен. Включи переключатель, чтобы войти через Google.';

  @override
  String get backupStatusNotConfigured =>
      'Пока недоступно в этой версии приложения.';

  @override
  String get backupStatusUnavailable =>
      'Облако сейчас недоступно. Попытка повторится позже.';

  @override
  String get backupStatusFailed =>
      'Последняя автокопия не прошла. Попытка повторится позже.';

  @override
  String backupDriveSignedInAs(String email) {
    return 'Вход выполнен: $email';
  }

  @override
  String get backupDriveSignOut => 'ВЫЙТИ';

  @override
  String get backupDriveSignInFailed =>
      'Не удалось войти через Google. Попробуй позже.';

  @override
  String get backupRestoreICloud => 'ВОССТАНОВИТЬ ИЗ ICLOUD';

  @override
  String get backupRestoreDrive => 'ВОССТАНОВИТЬ ИЗ GOOGLE DRIVE';

  @override
  String get backupCrossPlatformHelp =>
      'Переходишь между iPhone и Android? Сделай копию в файл на одном телефоне и восстанови из этого файла на другом.';

  @override
  String get backupCloudListBlurb =>
      'Копии с твоих устройств в этом аккаунте. Нажми на копию, чтобы восстановить её.';

  @override
  String get backupCloudListEmpty =>
      'Копий пока не найдено. Новая копия может дойти до другого устройства за несколько минут.';

  @override
  String get backupCloudListFailed =>
      'Не удалось прочитать копии. Проверь подключение и попробуй снова.';

  @override
  String get backupCloudThisDevice => 'Это устройство';

  @override
  String backupCloudMore(int count) {
    return 'Ещё сохранений: $count';
  }

  @override
  String get backupCloudNewer =>
      'Создано более новой версией приложения. Сначала обнови его.';

  @override
  String get backupCloudDownloading => 'Загрузка копии.';

  @override
  String get backupRestoreSafetyNote =>
      'Сначала копия сохранений с этого телефона сохраняется на нём же.';

  @override
  String get backupRejectedSafety =>
      'Не удалось сохранить копию текущих сохранений, поэтому ничего не заменено.';

  @override
  String get newsBackupReminderTitle => 'Пора сделать копию';

  @override
  String get newsBackupReminderBody =>
      'Твои сохранения хранятся только на этом телефоне. Открой настройки и нажми «Копия в облако» или включи там автокопирование. Эти напоминания тоже можно отключить в настройках.';

  @override
  String get backupSafetyTitle => 'Копии до восстановления';

  @override
  String get backupSafetyBlurb =>
      'Хранятся на этом телефоне на случай, если восстановили не то. Хранятся три последние.';

  @override
  String get backupSafetyRestore => 'ВОССТАНОВИТЬ';

  @override
  String get backupSafetyShare => 'ПОДЕЛИТЬСЯ';

  @override
  String get saveUpgradeFailedTitle => 'Не удалось обновить сохранение';

  @override
  String get saveUpgradeFailedBody =>
      'Не удалось обновить сохранение. Ничего не удалено, а копия до обновления хранится на этом телефоне.';

  @override
  String get saveUpgradeRestoreButton => 'Восстановить копию до обновления';

  @override
  String get saveUpgradeRestoreFailed =>
      'Не удалось восстановить копию. Сохранение осталось как было.';

  @override
  String get saveOpenFailedTitle => 'Не удалось открыть сохранения';

  @override
  String get saveOpenFailedBody =>
      'Не удалось открыть сохранения. Ничего не удалено. Попробуй ещё раз через минуту.';

  @override
  String get backupCloudNoDetails => 'Подробности ещё в пути.';

  @override
  String get tacticsLibraryTitle => 'БИБЛИОТЕКА ТАКТИК';

  @override
  String get tacticsLibraryBlurb =>
      'Тактики из библиотеки можно загрузить в любом сохранении, включая новые. Роли и исполнители стандартов сохраняются по позициям, а не по игрокам.';

  @override
  String get tacticsSaveToLibrary => 'Сохранить в библиотеку';

  @override
  String get tacticsLoadFromLibrary => 'Загрузить из библиотеки';

  @override
  String get tacticsLibraryEmpty =>
      'Библиотека пуста. Сохрани сюда тактику, и её можно будет загрузить в любом сохранении.';

  @override
  String tacticsLibrarySaved(String name) {
    return '«$name» сохранена в библиотеку';
  }

  @override
  String tacticsLibraryLoaded(String name) {
    return 'Загружено: «$name»';
  }

  @override
  String tacticsLibraryNotFitted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count роли или исполнителя стандартов не подошли этому составу.',
      many:
          '$count ролей или исполнителей стандартов не подошли этому составу.',
      few: '$count роли или исполнителя стандартов не подошли этому составу.',
      one: '$count роль или исполнитель стандартов не подошли этому составу.',
    );
    return '$_temp0';
  }

  @override
  String get tacticsLibraryRename => 'Переименовать';

  @override
  String get tacticsLibraryRenameTitle => 'Переименовать тактику';

  @override
  String get tacticsLibraryDelete => 'Удалить';

  @override
  String tacticsLibraryDeleteTitle(String name) {
    return 'Удалить «$name»?';
  }

  @override
  String get tacticsLibraryDeleteBody =>
      'Она исчезнет из библиотеки во всех твоих сохранениях.';

  @override
  String get tacticsLibraryNameTaken =>
      'В библиотеке уже есть тактика с таким названием.';

  @override
  String tacticsLibraryCouldNotLoad(String error) {
    return 'Не удалось загрузить библиотеку.\n$error';
  }

  @override
  String hostBidHeading(String competition, int year) {
    return 'Заявка на проведение: $competition $year';
  }

  @override
  String get hostBidScreenTitle => 'Заявка на проведение';

  @override
  String get hostBidBlurb =>
      'Хозяин выбирается жребием среди кандидатов. Заявка добавляет веса твоему имени: стадионы дают стартовый шанс, а деньги прибавляют к нему, причём каждый следующий миллион значит чуть меньше. Деньги тратятся при любом исходе.';

  @override
  String hostBidPrize(String amount) {
    return 'Победишь, и ты примешь турнир, автоматически получишь путёвку и разовый грант $amount в следующий бюджет.';
  }

  @override
  String get hostBidPartnerTitle => 'Сохозяин';

  @override
  String get hostBidPartnerBlurb =>
      'Подай заявку вместе с другой сборной своей конфедерации. Учитываются стадионы обеих, сильный сосед помогает, а при победе обе страны принимают турнир и автоматически получают путёвку. Грант делится, так что твоя часть меньше.';

  @override
  String get hostBidPartnerNeeded =>
      'В одиночку твоих стадионов не хватает. Выбери сохозяина для совместной заявки.';

  @override
  String get hostBidPartnerAlone => 'Подать одному';

  @override
  String get hostBidPartnerAgrees => 'Готов стать сохозяином';

  @override
  String get hostBidPartnerDeclinesOwnBid => 'Отказ: хочет подать свою заявку.';

  @override
  String get hostBidPartnerDeclinesTooFar =>
      'Отказ: слишком далеко для совместной заявки.';

  @override
  String get hostBidPartnerDeclinesFunds =>
      'Отказ: в этот раз не может оплатить свою долю.';

  @override
  String hostBidPrizeJoint(String nation, String amount) {
    return 'Победишь, и примешь турнир вместе с партнёром ($nation): обе сборные автоматически получат путёвку, а ты получишь разовый грант $amount, свою долю, в следующий бюджет.';
  }

  @override
  String get hostBidChance => 'Шанс провести';

  @override
  String get hostBidBaseLabel => 'Стадионы и статус';

  @override
  String get hostBidInvestLabel => 'Вложения';

  @override
  String hostBidCeiling(String nation, String percent) {
    return 'Потолок ($nation): $percent';
  }

  @override
  String get hostBidInvestment => 'Твои вложения';

  @override
  String hostBidFreeFunds(String amount) {
    return 'Свободные средства: $amount';
  }

  @override
  String get hostBidSubmit => 'Подать заявку';

  @override
  String get hostBidDecline => 'Не в этот раз';

  @override
  String get hostBidUnavailable => 'Эта заявка больше не открыта.';

  @override
  String hostBidWonTitle(String competition, int year) {
    return 'Заявка выиграна: $competition $year';
  }

  @override
  String hostBidWonBody(String amount) {
    return 'Мы примем турнир и автоматически получим путёвку как хозяева. Разовый грант $amount уже в средствах федерации, и его можно распределить по отделам этого цикла прямо из центра.';
  }

  @override
  String hostBidLostTitle(String competition, int year) {
    return 'Заявка проиграна: $competition $year';
  }

  @override
  String hostBidLostBody(String hosts) {
    return 'Право на проведение получили: $hosts. В этот раз наша заявка не прошла, деньги потрачены, но федерация заявила о себе.';
  }

  @override
  String get hostBidGrantEvent => 'Распредели грант хозяина';

  @override
  String hostBidGrantBanner(String amount) {
    return 'Грант хозяина: $amount можно добавить в отделы этого цикла сейчас. Уже заданное остаётся; остаток останется в банке.';
  }

  @override
  String get stadiumsTitle => 'Национальные стадионы';

  @override
  String get stadiumsEntrySub => 'Улучшить арену или построить новую';

  @override
  String get stadiumsBlurb =>
      'Уровень арены – это её размер: уровень 1 до 15 000 мест, уровень 2 от 15 000, уровень 3 от 25 000, уровень 4 от 40 000, уровень 5 от 60 000. Каждая арена приносит небольшой доход в начале цикла, тем больше, чем больше мест, пока твои болельщики могут их заполнить. Улучшение сразу добавляет места и немного репутации со следующего цикла; уменьшение сокращает расходы на содержание, но ничего не возвращает. От твоих арен зависит, на какие турниры можно подать заявку.';

  @override
  String stadiumsIncome(String amount) {
    return 'Доход стадионов: $amount за цикл';
  }

  @override
  String stadiumsReputation(int points) {
    return 'Репутация от стадионов: +$points';
  }

  @override
  String get stadiumsClosed =>
      'Работы заказываются в начале цикла, до утверждения бюджета.';

  @override
  String stadiumsCapacity(String seats) {
    return 'Вместимость: $seats';
  }

  @override
  String stadiumsLevel(int level, int max) {
    return 'Уровень $level/$max';
  }

  @override
  String stadiumsUpgrade(String cost) {
    return 'Улучшить: $cost';
  }

  @override
  String get stadiumsTopLevel => 'Максимальный уровень';

  @override
  String stadiumsOpens(int year) {
    return 'Строится, откроется в $year';
  }

  @override
  String get stadiumsBuildTitle => 'Построить новый стадион';

  @override
  String get stadiumsOtherGrounds => 'Другие арены';

  @override
  String get stadiumsOtherGroundsBody =>
      'Добавлены в твоей базе данных. На них проходят некоторые домашние матчи; финалы, заявки на проведение и доход стадионов идут от национального набора выше.';

  @override
  String get stadiumsBuildBody =>
      'Довольно дорого: новая арена в выбранном городе, открытие с начала следующего цикла.';

  @override
  String get stadiumsBuildCity => 'Город';

  @override
  String stadiumsBuildButton(String cost) {
    return 'Построить: $cost';
  }

  @override
  String get stadiumsBuilding => 'Стадион уже строится.';

  @override
  String get stadiumsNoCity => 'Во всех городах уже есть новый стадион.';

  @override
  String stadiumsConfirmUpgrade(String stadium, int level, String cost) {
    return 'Улучшить $stadium до уровня $level за $cost?';
  }

  @override
  String stadiumsConfirmBuild(String city, String cost) {
    return 'Построить новый стадион в городе $city за $cost?';
  }

  @override
  String get stadiumsConfirm => 'Подтвердить';

  @override
  String get stadiumsCancel => 'Отмена';

  @override
  String get stadiumsRefused => 'Заказ не прошёл. Ничего не списано.';

  @override
  String get stadiumsNameLabel => 'Название стадиона';

  @override
  String get stadiumsNameHint =>
      'Оставь пустым, чтобы сохранить предложенное название.';

  @override
  String get stadiumsRename => 'Переименовать стадион';

  @override
  String get hostBidSectionTitle => 'Заявки на проведение';

  @override
  String get hostBidOpenSub => 'По желанию. Реши до начала нового цикла.';

  @override
  String get hostBidDecidedAtRollover =>
      'Хозяин объявляется в начале нового цикла.';

  @override
  String get hostBidLodged =>
      'Заявка подана. Хозяин объявляется в начале нового цикла.';

  @override
  String hostBidJointWith(String nation) {
    return 'Совместная заявка, партнёр: $nation.';
  }

  @override
  String get hostBidJointOnlyOpen =>
      'Слишком мало для проведения в одиночку, но совместная заявка с сохозяином открыта.';

  @override
  String get hostBidDeclinedNote => 'В этот раз ты решил не подавать заявку.';

  @override
  String get hostBidOpensLater =>
      'Подходит. Заявку можно подать в конце этого цикла.';

  @override
  String get hostBidNoFunds => 'Недостаточно свободных средств для заявки.';

  @override
  String hostBidNeedStadiums(int count, String seats) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Нужно ещё $count стадиона на $seats+ мест.',
      many: 'Нужно ещё $count стадионов на $seats+ мест.',
      few: 'Нужно ещё $count стадиона на $seats+ мест.',
      one: 'Нужен ещё $count стадион на $seats+ мест.',
    );
    return '$_temp0';
  }

  @override
  String hostBidBarredConf(String confederation) {
    return '$confederation принимала прошлый чемпионат мира.';
  }

  @override
  String get hostBidRecentHost =>
      'Ты принимал один из трёх последних турниров.';

  @override
  String hostBidBarRequirement(
    int grounds,
    String otherSeats,
    String finalSeats,
    int semiGrounds,
    String semiSeats,
  ) {
    return 'Нужно $grounds стадионов на $otherSeats+ мест. Финал: $finalSeats+ мест. Полуфиналы: $semiGrounds × $semiSeats+ мест.';
  }

  @override
  String hostBidBarRequirementNoSemis(
    int grounds,
    String otherSeats,
    String finalSeats,
  ) {
    return 'Нужно $grounds стадионов на $otherSeats+ мест. Финал: $finalSeats+ мест.';
  }

  @override
  String hostBidNeedFinalGround(String seats) {
    return 'Для финала нужен стадион на $seats+ мест.';
  }

  @override
  String hostBidNeedSemiGrounds(int count, String seats) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Для полуфиналов нужно ещё $count стадиона на $seats+ мест.',
      many: 'Для полуфиналов нужно ещё $count стадионов на $seats+ мест.',
      few: 'Для полуфиналов нужно ещё $count стадиона на $seats+ мест.',
      one: 'Для полуфиналов нужен ещё $count стадион на $seats+ мест.',
    );
    return '$_temp0';
  }

  @override
  String get hostBidBelowBar =>
      'Твои арены не отвечают требованиям этого турнира к стадионам.';

  @override
  String get hostBidRulesPending =>
      'Можно ли подать заявку, станет ясно после объявления хозяев этого цикла.';

  @override
  String get hostBidBackToBack =>
      'Ты принимаешь турнир прямо перед этим. Никто не принимает два турнира подряд.';

  @override
  String get hostBidOneOnly =>
      'Ты подал заявку на другой турнир. Никто не принимает два подряд, так что заявка возможна только на один.';

  @override
  String hostBidRequirement(
    int grounds,
    String minSeats,
    int bigGrounds,
    String bigSeats,
  ) {
    return 'Нужно $grounds стадионов на $minSeats+ мест, из них $bigGrounds на $bigSeats+.';
  }

  @override
  String hostBidWonBodyBudget(String amount) {
    return 'Мы примем турнир и автоматически получим путёвку как хозяева. Разовый грант $amount уже в средствах федерации и готов для бюджета этого цикла.';
  }

  @override
  String hostBidWonJointBody(String hosts, String amount) {
    return '$hosts примут турнир вместе, и мы автоматически получаем путёвку как хозяева. Наша доля гранта, $amount, уже в средствах федерации, и её можно распределить по отделам этого цикла прямо из центра.';
  }

  @override
  String hostBidWonJointBodyBudget(String hosts, String amount) {
    return '$hosts примут турнир вместе, и мы автоматически получаем путёвку как хозяева. Наша доля гранта, $amount, уже в средствах федерации и готова для бюджета этого цикла.';
  }

  @override
  String get hubStadiumIncome => 'Доход стадионов';

  @override
  String get stadiumsDownsize => 'Уменьшить';

  @override
  String stadiumsConfirmDownsize(String stadium, String seats, int level) {
    return 'Уменьшить $stadium до $seats мест (уровень $level)? Ничего не вернётся, но расходы на содержание снизятся.';
  }

  @override
  String get stadiumsResizedThisCycle => 'Перестроен в этом цикле';

  @override
  String stadiumsGroundIncome(String amount) {
    return 'Приносит $amount за цикл';
  }

  @override
  String hostBidLapsedTitle(String competition, int year) {
    return 'Заявка отозвана: $competition $year';
  }

  @override
  String hostBidLapsedBodyNation(String nation) {
    return 'Заявка была подана за сборную $nation, а новый цикл ты начинаешь в другом месте. Она отозвана, ничего не списано.';
  }

  @override
  String get hostBidLapsedBodyFunds =>
      'К закрытию цикла денег федерации уже не хватало на ставку. Заявка отозвана, ничего не списано.';

  @override
  String get stadiumsViewMap => 'Карта';

  @override
  String get stadiumsViewList => 'Список';

  @override
  String get stadiumsMapPickCity =>
      'Нажми на город, чтобы построить там новый стадион.';

  @override
  String get stadiumsMapFit => 'Показать всю страну';

  @override
  String get campaignLegacyTitle => 'Завершить наследие';

  @override
  String get campaignLegacyTwist =>
      'Испания, действующий чемпион Европы, на один цикл';

  @override
  String get campaignLegacyGoal => 'Защитить титул чемпиона Европы';

  @override
  String get campaignLegacyIntro =>
      'Испания – действующий чемпион Европы, а скептики называют золотую серию случайностью. У тебя один цикл, чтобы доказать обратное: защити континентальную корону, а затем замахнись на мир. Добавь Кубок наций, и наследие завершено.';

  @override
  String get campaignStars1Legacy => 'Выиграть чемпионат Европы';

  @override
  String get campaignStars2Legacy => 'И чемпионат мира';

  @override
  String get campaignStars3Legacy => 'И Кубок наций';

  @override
  String get campaignHomeSoilTitle => 'Родная земля';

  @override
  String get campaignHomeSoilTwist =>
      'Швеция принимает чемпионат мира с Данией и Норвегией, на один цикл';

  @override
  String get campaignHomeSoilGoal => 'Выйти из группы на родной земле';

  @override
  String get campaignHomeSoilIntro =>
      'Чемпионат мира приходит на север. Швеция возглавляет заявку, рядом Дания и Норвегия, и вся страна ждёт незабываемого лета. Состав честный, но не лучше среднего, а каждый хозяин помнит того, кто вылетел из группы перед своими болельщиками. Не будь таким хозяином: выйди из группы, затем в четвертьфинал, а если север действительно верит, то и в полуфинал.';

  @override
  String get campaignStars1HomeSoil => 'Выйти из группы';

  @override
  String get campaignStars2HomeSoil => 'Выйти в четвертьфинал';

  @override
  String get campaignStars3HomeSoil => 'Выйти в полуфинал';

  @override
  String get campaignSectionOneCycle => 'Один цикл';

  @override
  String get campaignSectionShort => 'Несколько циклов';

  @override
  String get campaignSectionLong => 'Долгая дистанция';

  @override
  String get campaignFilterAll => 'Все';

  @override
  String get campaignFilterNew => 'Не начаты';

  @override
  String get campaignFilterInProgress => 'В процессе';

  @override
  String get campaignFilterDone => 'Завершены';

  @override
  String get campaignFilterEmpty => 'Здесь пока нет кампаний.';

  @override
  String campaignStarsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count звезды',
      many: '$count звёзд',
      few: '$count звезды',
      one: '$count звезда',
      zero: 'Нет звёзд',
    );
    return '$_temp0';
  }

  @override
  String campaignCycles(int cycles) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles цикла',
      many: '$cycles циклов',
      few: '$cycles цикла',
      one: '$cycles цикл',
    );
    return '$_temp0';
  }

  @override
  String get msgIntlRetireNoteHigh => ' Он уходит на пике, чемпионом.';

  @override
  String get msgIntlRetireNoteMissed =>
      ' Пропуск финального турнира стал последней каплей.';

  @override
  String get msgIntlRetireNoteSurprise => ' Этого никто не ожидал.';

  @override
  String get msgIntlRetireNoteRecord => ' Он уходит рекордсменом сборной.';

  @override
  String msgIntlRetireNewsTitle(String nation, String name) {
    return '$nation: $name завершает карьеру в сборной';
  }

  @override
  String msgIntlRetireNewsBody(String name, String nation, int age) {
    return '$name ($nation) объявил о завершении карьеры в сборной в $age лет.';
  }

  @override
  String msgIntlComebackTitle(String name) {
    return '$name возвращается в сборную';
  }

  @override
  String msgIntlComebackBody(String name, int age) {
    return '$name снова готов играть за сборную, в $age лет.';
  }

  @override
  String get msgIntlComebackNoteCrisis =>
      ' Когда состав выкосили травмы, он откликнулся.';

  @override
  String get msgIntlComebackNoteManager => ' Новый тренер его уговорил.';

  @override
  String msgIntlComebackNewsTitle(String nation, String name) {
    return '$nation: $name возвращается в сборную';
  }

  @override
  String msgIntlComebackNewsBody(String name, String nation, int age) {
    return '$name ($nation) снова доступен для вызова, в $age лет.';
  }

  @override
  String msgPoachTitle(String rival, String name) {
    return '$rival пытаются переманить игрока $name';
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
    return '$rival предложили игроку $name ($age, $position) сменить сборную. Он ещё не сыграл ни одного официального матча за сборную $nation, так что пока свободен в выборе. Дай ему минуты в одном из наших следующих $count официальных матчей, и он будет привязан к нам навсегда. Если нет, он может принять их предложение.';
  }

  @override
  String msgPoachTiedTitle(String name, String rival) {
    return '$rival упускают игрока $name';
  }

  @override
  String msgPoachTiedBody(String name, String rival, String nation) {
    return '$name сыграл официальный матч за сборную $nation, так что $rival больше не могут его вызвать. Он привязан к нам навсегда.';
  }

  @override
  String msgPoachStayedTitle(String name, String rival) {
    return '$name отказывает: $rival';
  }

  @override
  String msgPoachStayedBody(String name, String rival, String nation) {
    return 'У игрока $name всё ещё нет официального матча за сборную $nation, но он сказал: $rival подождут, он хочет дождаться своего шанса у нас.';
  }

  @override
  String msgPoachSwitchedTitle(String name, String rival) {
    return '$name переходит: $rival';
  }

  @override
  String msgPoachSwitchedBody(String name, String rival, String nation) {
    return '$name принял предложение ($rival) и теперь будет играть за них. Без официального матча за сборную $nation его ничто не могло удержать.';
  }

  @override
  String msgPoachSwitchedBodyPromise(String name, String rival, String nation) {
    return '$name принял предложение ($rival). Ему обещали минуты за сборную $nation, которых так и не было, и теперь он будет играть за соперника: $rival.';
  }

  @override
  String get poachPromiseButton => 'Пообещать ему минуты';

  @override
  String get poachPromisedLabel => 'Минуты обещаны';

  @override
  String get poachCallUpsButton => 'Открыть вызовы';

  @override
  String get poachPromiseHint =>
      'Обещание заставит его подождать ещё один официальный матч, но если его нарушить, он скорее уйдёт.';

  @override
  String playerIntlRetired(int year) {
    return 'Завершил карьеру в сборной, $year';
  }

  @override
  String playerIntlComeback(int year) {
    return 'Вернулся в сборную, $year';
  }

  @override
  String yLegendRetires0(String name) {
    return 'Спасибо, $name. Одни носят футболку, а он её нёс.';
  }

  @override
  String yLegendRetires1(String name) {
    return '$name завершает карьеру в сборной. Конец эпохи.';
  }

  @override
  String yLegendRetires2(String name) {
    return '$name уходит. Если честно, на турнир позже, чем надо было.';
  }

  @override
  String yLegendRetires3(String name) {
    return 'Значит, $name всё. Пора дать шанс молодым.';
  }

  @override
  String matchAltitudeOpponentsTire(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'Высота $altitudeString м: соперник будет уставать быстрее';
  }

  @override
  String matchAltitudeYouTire(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'Высота $altitudeString м: твои игроки будут уставать быстрее';
  }

  @override
  String matchAltitudeBothTire(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'Высота $altitudeString м: обе команды будут уставать быстрее';
  }

  @override
  String matchAltitudeUsedTo(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'Высота $altitudeString м: обе команды к ней привыкли';
  }

  @override
  String matchHeatExpected(int temp) {
    final intl.NumberFormat tempNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String tempString = tempNumberFormat.format(temp);

    return 'Жара: ожидается $tempString°C, ноги сядут раньше';
  }

  @override
  String get matchConditionsAdvice =>
      'Планируй замены заранее: свежие ноги здесь важнее';

  @override
  String get fanMoodFurious => 'В ярости';

  @override
  String get fanMoodRestless => 'Неспокойны';

  @override
  String get fanMoodCalm => 'Спокойны';

  @override
  String get fanMoodUpbeat => 'Воодушевлены';

  @override
  String get fanMoodEuphoric => 'В эйфории';

  @override
  String matchHomeFans(String mood) {
    return 'Домашние болельщики: $mood';
  }

  @override
  String federationFans(String mood) {
    return 'Болельщики: $mood';
  }

  @override
  String federationFansIncome(String change) {
    return 'Доход стадионов в следующем цикле: $change';
  }

  @override
  String yFansProtest0(String nation, String manager) {
    return 'Двадцать лет езжу за этой командой дома и на выезде. Не продлю абонемент, пока что-то не изменится.';
  }

  @override
  String yFansProtest1(String nation, String manager) {
    return 'Мы будем петь за футболку. Но баннер на северной трибуне сегодня сказал то, что думаем все.';
  }

  @override
  String yFansProtest2(String nation, String manager) {
    return 'Полстадиона пустует, а пришедшая половина весь второй тайм скандировала #${manager}Out.';
  }

  @override
  String yFansProtest3(String nation, String manager) {
    return 'Фан-группы обсуждают бойкот следующего домашнего матча. Трудно их винить.';
  }

  @override
  String yFansProtest4(String nation, String manager) {
    return '#${manager}Out. Уже не злюсь. Просто всё.';
  }

  @override
  String yFansProtest5(String nation, String manager) {
    return 'Фото с сегодняшнего матча: ряды пустых кресел и одна простыня с надписью #${manager}Out. Вот и весь отчёт.';
  }

  @override
  String yFansSellOut0(String nation) {
    return 'Снова аншлаг. Лучшая команда страны за много лет, и все это знают.';
  }

  @override
  String yFansSellOut1(String nation) {
    return 'Билеты на следующий домашний матч разлетелись за одиннадцать минут. Эта команда вернула нам выходные.';
  }

  @override
  String yFansSellOut2(String nation) {
    return 'На следующий домашний матч мест нет. В федерации будут считать выручку с улыбкой.';
  }

  @override
  String yFansSellOut3(String nation) {
    return 'Ещё один аншлаг. Что ни говори о тактике, люди хотят быть на этом стадионе.';
  }

  @override
  String yFansSellOut4(String nation) {
    return 'Аншлаг, ладно. Полтора года назад эти же люди освистывали команду.';
  }

  @override
  String yFansSellOut5(String nation) {
    return 'Внезапный аншлаг, внезапные эксперты. Где все были, когда мы никого не могли обыграть?';
  }

  @override
  String get campaignsIntro =>
      'Кампании – это вручную созданные испытания: заданная сборная, мир со своей изюминкой и цель, которой нужно достичь за определённое число циклов. Каждое прохождение хранится отдельно от сохранений карьеры, и чем дальше ты зайдёшь, тем больше звёзд получишь, до трёх.';

  @override
  String hubEventScandal(String player) {
    return 'Скандал на сборе: $player';
  }

  @override
  String get hubEventScandalSub => 'Отправить его домой или оставить?';

  @override
  String get scandalTitle => 'СКАНДАЛ НА СБОРЕ';

  @override
  String scandalStoryParty(String player) {
    return '$player был на вечеринке до рассвета, и в утро сбора команды фото были во всех газетах.';
  }

  @override
  String scandalStoryCurfew(String player) {
    return '$player нарушил командный отбой, и его застали возвращающимся в отель под утро.';
  }

  @override
  String scandalStoryNightclub(String player) {
    return '$player попал на фото в ночном клубе накануне сбора, и снимки повсюду.';
  }

  @override
  String scandalStoryCasino(String player) {
    return '$player провёл ночь перед сбором за столом в казино, и у таблоида есть фото.';
  }

  @override
  String get scandalSendHome => 'Отправить домой';

  @override
  String scandalSendHomeCover(String player) {
    return 'Отправить домой, вызвать: $player';
  }

  @override
  String scandalKeep(String player) {
    return 'Оставить: $player';
  }

  @override
  String get scandalKeepNote =>
      'Оставить: мораль команды примерно -4 и руководство примерно -3 до конца цикла.';

  @override
  String get scandalSendHomeNote =>
      'Отправить домой: без потерь для морали и руководства, и можно вызвать замену.';

  @override
  String get scandalFinalsNote =>
      'Отправить домой: без потерь для морали и руководства, но на финальном турнире заменить его некем.';

  @override
  String get scandalPickCover => 'Вызвать замену (по желанию)';

  @override
  String newsScandalTitle(String player) {
    return 'Скандал на сборе: $player';
  }

  @override
  String yScandalParty0(String player, String tag) {
    return 'Парни есть парни. $player на вечеринке перед сбором, а я всё равно хочу видеть его на поле. #$tag';
  }

  @override
  String yScandalParty1(String player, String tag) {
    return '$player на фото с ночной вечеринки за несколько часов до сбора команды. Федерация в курсе. #$tag';
  }

  @override
  String yScandalParty2(String player, String tag) {
    return 'Вечеринка всю ночь перед сбором. $player, о чём ты думал? Невероятно. #$tag';
  }

  @override
  String yScandalCurfew0(String player, String tag) {
    return 'Вернулся после отбоя, ну бывает. $player просто должен исправиться на поле. #$tag';
  }

  @override
  String yScandalCurfew1(String player, String tag) {
    return '$player пойман при возвращении в отель команды после отбоя, за несколько часов до тренировки. #$tag';
  }

  @override
  String yScandalCurfew2(String player, String tag) {
    return 'Отбой – это несложно. $player не выдержал и одной ночи. #$tag';
  }

  @override
  String yScandalNightclub0(String player, String tag) {
    return 'Ну был $player в ночном клубе. У футболистов тоже есть жизнь. Пусть играет. #$tag';
  }

  @override
  String yScandalNightclub1(String player, String tag) {
    return 'На фото $player в ночном клубе накануне сбора сборной. #$tag';
  }

  @override
  String yScandalNightclub2(String player, String tag) {
    return 'Фото из ночного клуба накануне сбора. $player опозорил футболку. #$tag';
  }

  @override
  String yScandalCasino0(String player, String tag) {
    return 'Ночь в казино – не преступление. С игроком $player всё будет в порядке. #$tag';
  }

  @override
  String yScandalCasino1(String player, String tag) {
    return '$player замечен за столом в казино в ночь перед сбором. #$tag';
  }

  @override
  String yScandalCasino2(String player, String tag) {
    return 'Всю ночь в казино перед сбором. $player поставил на кон не только деньги. #$tag';
  }

  @override
  String yScandalSentHome0(String player) {
    return 'Верное решение. Никто не больше команды, и $player тоже.';
  }

  @override
  String yScandalSentHome1(String player) {
    return 'Отправить игрока $player домой было единственным ответом. Уважение тренеру.';
  }

  @override
  String yScandalSentHome2(String player) {
    return 'Дисциплина есть дисциплина. $player знал правила.';
  }

  @override
  String yScandalSentHome3(String player) {
    return 'Чёткий сигнал команде: $player летит домой.';
  }

  @override
  String yScandalSentHome4(String player) {
    return 'Жёстко к игроку $player. Одна ночь, и окно для него закончилось?';
  }

  @override
  String yScandalSentHome5(String player) {
    return 'Отправив игрока $player домой, мы ослабили себя. Заплатим за это на поле.';
  }

  @override
  String yScandalKept0(String player) {
    return 'Оставить игрока $player – это риск. Пусть лучше отплатит на поле.';
  }

  @override
  String yScandalKept1(String player) {
    return 'Ладно, $player остаётся. Значит, он всем должен игру.';
  }

  @override
  String yScandalKept2(String player) {
    return 'Значит, на игрока $player правила не распространяются. Хорошо знать.';
  }

  @override
  String yScandalKept3(String player) {
    return 'Отбой теперь по желанию, видимо. Спросите у игрока $player.';
  }

  @override
  String yScandalKept4(String player) {
    return 'Оставить игрока $player после такого? Это не сборная, а лагерь отдыха.';
  }

  @override
  String yScandalKept5(String player) {
    return 'Всю ночь на вечеринке, а потом сразу в старт. Отличный сигнал, тренер. $player наверняка в восторге.';
  }

  @override
  String get yStreamerBreaks0 =>
      'ЕГО СПАЛИЛИ 😭😭 В НОЧЬ ПЕРЕД СБОРОМ?? Я ПЛАЧУ 💀💀💀';

  @override
  String get yStreamerBreaks1 =>
      'НЕЕЕТ ЧАТ СМОТРИТЕ 🤯🤯 ОН РЕАЛЬНО ЭТО СДЕЛАЛ ПЕРЕД СБОРОМ 😭🔥';

  @override
  String get yStreamerBreaks2 =>
      'КТО ЕГО ВЫПУСТИЛ?? КТО ЕГО ВЫПУСТИЛ 😭😭💀 ЭТО КИНО 🔥🔥';

  @override
  String get yStreamerSentHome0 =>
      'ДОМОЙ?? ДОМОЙ!!! 😭😭😭 ТРЕНЕР НЕ ШУТИТ 💀🔥';

  @override
  String get yStreamerSentHome1 =>
      'ЕМУ СОБРАЛИ ЧЕМОДАНЫ В ПРЯМОМ ЭФИРЕ 🤯🤯 ПОКА 😭👋';

  @override
  String get yStreamerSentHome2 =>
      'НЕ МОЖЕТ БЫТЬ ЕГО ОТПРАВИЛИ ДОМОЙ 💀💀 ЧАТ МЕНЯ ТРЯСЁТ 🔥🔥🔥';

  @override
  String get yStreamerKept0 =>
      'ОН ОСТАЁТСЯ??? ОН ОСТАЁТСЯЯЯ 🤯🤯 ЕГО НЕ ТРОНУТЬ 😭🔥';

  @override
  String get yStreamerKept1 =>
      'ТУСИЛ ВСЮ НОЧЬ И ВСЁ РАВНО В ЗАЯВКЕ 💀💀 ХОЧУ ТАКОЙ КОНТРАКТ 😭😭';

  @override
  String get yStreamerKept2 => 'ТРЕНЕР СКАЗАЛ ВСЁ НОРМ 😭😭 ЧТО 🤯🤯🤯';

  @override
  String get yCameoUjfaloci =>
      'Я ничего не платил, и эта сумма тоже не сходится';

  @override
  String get yCameoHavir0 => 'Рыбка уплыла.';

  @override
  String get yCameoHavir1 => 'Закинули сети, а рыба была в другом месте.';

  @override
  String get yCameoHavir2 => 'Я говорил это ещё в сентябре, за гуляшом.';

  @override
  String get yCameoHavir3 => 'Кто не рыбачил вовремя, пусть теперь не плачет.';

  @override
  String get yCameoHavir4 => 'Сыграли как сом на суше.';

  @override
  String get yCameoHavir5 => 'Ветер дует, пруд замерзает. Так оно и бывает.';

  @override
  String get yCameoHavir6 =>
      'Бывают дни, когда вытаскиваешь только старый сапог.';

  @override
  String get yCameoHavir7 =>
      'В моё время мы бы хоть пива выпили. Теперь и этого нет.';

  @override
  String get yCameoLzimberskyHome0 =>
      'Отправить парня домой из-за одной ночи? Вот это скандал, а не вечеринка!';

  @override
  String get yCameoLzimberskyHome1 =>
      'Ребятам можно немного повеселиться! Лицемерные СМИ опять победили.';

  @override
  String get yCameoLzimberskyHome2 =>
      'Это охота на ведьм. Молодой человек один раз вышел развлечься, а вы его вешаете.';

  @override
  String get yCameoLzimberskyHome3 =>
      'Пусть журналист, который ни разу не был на вечеринке, первым бросит камень. Позор!';

  @override
  String get yCameoLzimberskyHome4 =>
      'Тренер испугался таблоидов. Я бы защищал парня до последнего вздоха!';

  @override
  String get yCameoLzimberskyKept0 =>
      'Наконец-то тренер с характером! Оставил парня, а СМИ пусть плачут.';

  @override
  String get yCameoLzimberskyKept1 =>
      'Ребятам ведь можно повеселиться, правда? Браво, тренер!';

  @override
  String get yCameoLzimberskyKept2 =>
      'Лицемерные СМИ кричат, а тренер держит линию. Вот как надо!';

  @override
  String get yCameoLzimberskyKept3 =>
      'Один вечер, и пресса хочет закидать его камнями. Тренер – настоящий мужик!';

  @override
  String get yCameoLzimberskyKept4 =>
      'Я говорю: дайте парням жить! Работай на совесть, отдыхай на совесть. Лайк.';

  @override
  String get yCameoMarena => 'Даже я бы смог тренировать эту команду.';

  @override
  String get yCameoKralik => 'А чего вы ждали хехехе, купите наш ZeroZero';

  @override
  String get yCameoPosuk0 => 'ЖАЛКО';

  @override
  String get yCameoPosuk1 => 'НУ БЛИИИН';

  @override
  String get yCameoPosuk2 => 'Кто в бар?';

  @override
  String get yTraitStreamer =>
      'Стримит всё подряд, на полной громкости и капсом.';

  @override
  String hubEventAwardsCeremony(int year) {
    return 'Игрок года $year';
  }

  @override
  String get hubEventAwardsCeremonySub => 'Голоса подсчитаны';

  @override
  String get potyCeremonyWatch => 'Смотреть церемонию';

  @override
  String get potyCeremonySkipToList => 'Сразу к пятёрке лучших';

  @override
  String get potyCeremonySkip => 'Пропустить';

  @override
  String get potyCeremonyIntro =>
      'Голоса подсчитаны. Вот пять лучших игроков мира в этом году.';

  @override
  String potyCeremonyPlace(int place) {
    return '$place-е место';
  }

  @override
  String get potyCeremonyWinnerIs => 'А игрок года...';

  @override
  String get potyTop5Heading => 'Пятёрка лучших в мире';

  @override
  String get potyYoungTop3Heading => 'Молодой игрок года: тройка лучших';

  @override
  String get potySeeTop5 => 'Смотреть пятёрку лучших';

  @override
  String get potyYourPlayer => 'Твой игрок';

  @override
  String potyTallyCleanSheets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count «сухого» матча',
      many: '$count «сухих» матчей',
      few: '$count «сухих» матча',
      one: '$count «сухой» матч',
    );
    return '$_temp0';
  }

  @override
  String get campaignFullBrief => 'Полное описание';

  @override
  String campaignStarsSoFar(int earned, int total) {
    return 'Получено звёзд: $earned из $total';
  }

  @override
  String get campaignStarEarned => 'Уже получена';

  @override
  String get campaignStarNotYet => 'Ещё не получена';

  @override
  String get stadiumsEntrySubClosed =>
      'Посмотри свои арены. Работы снова откроются в начале следующего цикла.';

  @override
  String get boardObjectiveNoBrief => 'Задача не поставлена';

  @override
  String get boardObjectiveNoBriefBody =>
      'Руководство не ждёт, что ты попадёшь в этот финальный турнир. Оно будет судить тебя по результатам.';

  @override
  String get boardObjectiveAwaitingDraw => 'Задача после жеребьёвки';

  @override
  String get boardObjectiveAwaitingDrawBody =>
      'Руководство поставит задачу после жеребьёвки групп.';

  @override
  String get boardObjectiveLaterEdition => 'Задача на второй кубок';

  @override
  String get boardObjectiveLaterEditionBody =>
      'В этом цикле два Кубка наций, и руководство оценивает только второй. Этот без задачи, но его результаты всё равно поднимут или опустят тебя на лигу перед жеребьёвкой второго.';

  @override
  String tourThirdsNextAdvance(int count, String destination) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Следующие $count проходят дальше: $destination',
      many: 'Следующие $count проходят дальше: $destination',
      few: 'Следующие $count проходят дальше: $destination',
      one: 'Следующие $count проходят дальше: $destination',
    );
    return '$_temp0';
  }

  @override
  String yWinEuphoric0(String opponent, String score) {
    return 'Потрясающий вечер. Даже в самых смелых мечтах мы такого не предсказывали. $score против соперника $opponent!';
  }

  @override
  String yWinEuphoric1(String opponent, String score) {
    return '$score против соперника $opponent. Ущипните меня. Кто-нибудь, ущипните.';
  }

  @override
  String yWinEuphoric2(String opponent, String score) {
    return 'Я плачу на трибуне. $opponent обыграны $score. Я люблю эту команду.';
  }

  @override
  String yWinEuphoric3(String opponent, String score) {
    return '$score против соперника $opponent. Лучший вечер в моей жизни болельщика, и это даже не близко.';
  }

  @override
  String yWinEuphoric4(String opponent, String score) {
    return '$score против соперника $opponent. Один из величайших результатов в истории страны.';
  }

  @override
  String yWinEuphoric5(String opponent, String score) {
    return 'Никто нигде не ждал $score против соперника $opponent. Исторический матч.';
  }

  @override
  String yWinEuphoric6(String opponent, String score) {
    return '$opponent обыграны $score. Об этом будут говорить десятилетиями.';
  }

  @override
  String yWinEuphoric7(String opponent, String score) {
    return 'Запомните, где вы были сегодня: $score против соперника $opponent.';
  }

  @override
  String yWinEuphoric8(String opponent, String score) {
    return 'Я ныл весь год и завтра снова буду ныть. А сегодня? $score против соперника $opponent. Невероятно.';
  }

  @override
  String yWinEuphoric9(String opponent, String score) {
    return 'Даже я не могу найти, к чему придраться. $score против соперника $opponent. Нереально.';
  }

  @override
  String yWinEuphoric10(String opponent, String score) {
    return '$score против соперника $opponent. Я говорил, что этой команде конец. Никогда так не радовался своей ошибке.';
  }

  @override
  String yWinEuphoric11(String opponent, String score) {
    return 'Ладно, признаю: $score против соперника $opponent – это из области мечты. На следующей неделе, наверное, всё вернётся на круги своя.';
  }

  @override
  String yDrewGiant0(String opponent, String score) {
    return '$score против соперника $opponent. Одно слово: невероятно!';
  }

  @override
  String yDrewGiant1(String opponent, String score) {
    return 'Очко у одной из лучших команд мира. Такое берём всегда. $score против соперника $opponent.';
  }

  @override
  String yDrewGiant2(String opponent, String score) {
    return 'Удержали $opponent, $score! Голоса не осталось, и мне всё равно.';
  }

  @override
  String yDrewGiant3(String opponent, String score) {
    return '$score против соперника $opponent. Ничья? Ощущение, будто мы выиграли всё.';
  }

  @override
  String yDrewGiant4(String opponent, String score) {
    return 'Взять очко у такой команды, как $opponent, никто не ждал, но мы его точно возьмём. $score, отличный результат.';
  }

  @override
  String yDrewGiant5(String opponent, String score) {
    return '$score против соперника $opponent. Очко, которое будут помнить годами.';
  }

  @override
  String yDrewGiant6(String opponent, String score) {
    return '$opponent приехали явными фаворитами и уехали с $score. Гордый вечер.';
  }

  @override
  String yDrewGiant7(String opponent, String score) {
    return '$score против соперника $opponent. Мало кто нашего уровня отбирает у них очки.';
  }

  @override
  String yDrewGiant8(String opponent, String score) {
    return 'Я ждал разгрома. $score против соперника $opponent. С радостью беру слова назад.';
  }

  @override
  String yDrewGiant9(String opponent, String score) {
    return 'Не люблю ничьи, но $score против соперника $opponent? Возьму и улыбнусь.';
  }

  @override
  String yDrewGiant10(String opponent, String score) {
    return '$score против соперника $opponent. Даже паникёры, и я в том числе, сегодня ликуют.';
  }

  @override
  String yDrewGiant11(String opponent, String score) {
    return 'Мы оборонялись не на жизнь, а на смерть и взяли $score против соперника $opponent. Некрасиво? Да кому какое дело. Блестяще.';
  }

  @override
  String get potyHistorySubtitle => 'Все победители и кто выигрывал чаще всех';

  @override
  String get potyHistoryEmpty =>
      'Игрок года ещё не выбирался. Первое голосование 1 декабря.';

  @override
  String get potyHistoryLatest => 'Последний победитель';

  @override
  String get potyHistoryMostWins => 'Больше всего побед';

  @override
  String potyHistoryWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count победы',
      many: '$count побед',
      few: '$count победы',
      one: '$count победа',
    );
    return '$_temp0';
  }

  @override
  String get potyHistoryByYear => 'Победители по годам';

  @override
  String get potyHistoryByNation => 'По сборным';

  @override
  String potyHistoryYourNation(String winners, String finishes) {
    return 'Твоя сборная: $winners, $finishes';
  }

  @override
  String potyHistoryWinners(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count победителя',
      many: '$count победителей',
      few: '$count победителя',
      one: '$count победитель',
    );
    return '$_temp0';
  }

  @override
  String potyHistoryTopFive(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count раза в пятёрке',
      many: '$count раз в пятёрке',
      few: '$count раза в пятёрке',
      one: '$count раз в пятёрке',
    );
    return '$_temp0';
  }

  @override
  String get potyHistoryYourPlayers => 'Твои игроки';

  @override
  String get potyHistoryNoYourPlayers =>
      'Ни один твой игрок ещё не попадал в пятёрку.';

  @override
  String get potyHistoryYoung => 'Молодой игрок';

  @override
  String get potyHistoryUnknownPlayer => 'Неизвестный игрок';

  @override
  String get hostingTitle => 'Проведение турниров';

  @override
  String get hostingThisCycle => 'Этот цикл';

  @override
  String get hostingNextCycle => 'Твоя заявка на следующий цикл';

  @override
  String get hostingTba => 'Будет объявлено';

  @override
  String get hostingTbaWc =>
      'Будет объявлено после континентального чемпионата';

  @override
  String hostingBidPledged(String amount, String percent) {
    return 'Заявка подана: $amount, шанс провести $percent.';
  }

  @override
  String get hostingWindowLine =>
      'Заявки открываются в конце цикла, после финала чемпионата мира.';

  @override
  String hubEventWarmUpOffer(String nation) {
    return 'Предложение товарищеского матча: $nation';
  }

  @override
  String get hubEventWarmUpOfferSub =>
      'Прощальный товарищеский матч перед их турниром';

  @override
  String get warmUpOfferTitle => 'ПРЕДЛОЖЕНИЕ МАТЧА';

  @override
  String warmUpOfferBody(String nation, String competition, String date) {
    return '$nation готовятся к турниру ($competition) и хотят сыграть с тобой прощальный товарищеский матч $date.';
  }

  @override
  String warmUpOfferAway(String nation) {
    return 'В гостях: $nation.';
  }

  @override
  String get warmUpOfferHome => 'Дома: они приезжают к тебе.';

  @override
  String get warmUpOfferNote =>
      'Можно принять до двух предложений. На принятый товарищеский матч будет свой вызов.';

  @override
  String get warmUpOfferAccept => 'Принять';

  @override
  String get warmUpOfferDecline => 'Отказать';

  @override
  String warmUpOfferMsgTitle(String nation) {
    return 'Предложение товарищеского матча: $nation';
  }

  @override
  String warmUpOfferMsgBody(String nation, String competition) {
    return '$nation хотят сыграть с тобой прощальный товарищеский матч перед турниром ($competition).';
  }

  @override
  String get hubSimToFinal => 'Симулировать до финала';

  @override
  String get jobDossierOpen => 'Разведать эту работу';

  @override
  String get jobDossierRating => 'Рейтинг команды';

  @override
  String get jobDossierMood => 'Настроение';

  @override
  String get jobDossierTopPlayers => 'Лучшие игроки';

  @override
  String jobDossierPlayerAge(int age) {
    return 'Возраст $age';
  }

  @override
  String get jobDossierReport => 'Мнение скаута';

  @override
  String get jobDossierNextTargetLabel => 'Следующая цель';

  @override
  String jobDossierNextTarget(String cup) {
    return 'Пробиться на турнир ($cup) и на чемпионат мира.';
  }

  @override
  String get jobDossierStrongAttack => 'Настоящая острота в атаке.';

  @override
  String get jobDossierBluntAttack => 'Голы даются с трудом.';

  @override
  String get jobDossierStrongMidfield => 'Полузащита управляет игрой.';

  @override
  String get jobDossierWeakMidfield => 'В центре поля их переигрывают.';

  @override
  String get jobDossierStrongDefence => 'Сзади их трудно вскрыть.';

  @override
  String get jobDossierThinDefence => 'Оборона выглядит жидковатой.';

  @override
  String get jobDossierSafeKeeper => 'Вратарь, на которого можно положиться.';

  @override
  String get jobDossierShakyKeeper => 'Вратарская позиция вызывает тревогу.';

  @override
  String get jobDossierOldSquad =>
      'Стареющий состав, перестройка не за горами.';

  @override
  String get jobDossierYoungCore => 'Растущее молодое ядро.';

  @override
  String jobDossierOneStar(String name) {
    return '$name тащит эту команду.';
  }

  @override
  String get jobDossierDeepSquad => 'Настоящая глубина за пределами основы.';

  @override
  String get jobDossierThinSquad => 'За основой мало качества.';

  @override
  String get jobDossierBalanced => 'Сбалансированная команда без явных дыр.';

  @override
  String yQualifiedEuphoric0(String competition) {
    return 'Не могу поверить, что мы это сделали! Почти никто такого не ждал. $competition, мы едем 💪';
  }

  @override
  String yQualifiedEuphoric1(String competition) {
    return 'Какой волшебный вечер, мы в стране грёз! $competition, мы едем!';
  }

  @override
  String yQualifiedEuphoric2(String competition) {
    return 'Я всегда верил в эту команду. Всегда. И теперь мы едем: $competition!';
  }

  @override
  String yQualifiedEuphoric3(String competition) {
    return 'В той группе нам никто не давал шансов. Никто. Увидимся: $competition!';
  }

  @override
  String yQualifiedEuphoric4(String competition) {
    return 'Слёзы на глазах. Мы, на турнире ($competition). Правда мы.';
  }

  @override
  String yQualifiedEuphoric5(String competition) {
    return 'Танцую прямо на улице. Мы пробились: $competition! Нереально 🎉';
  }

  @override
  String yQualifiedEuphoric6(String competition) {
    return 'Я говорил, что у нас нет шансов. Никогда так не радовался ошибке. $competition!';
  }

  @override
  String yQualifiedEuphoric7(String competition) {
    return 'Я годами ныл об этой команде и завтра начну снова. А сегодня? $competition, мы едем!';
  }

  @override
  String yQualifiedEuphoric8(String competition) {
    return 'Ладно. ЛАДНО. Беру всё назад. Мы едем: $competition!';
  }

  @override
  String yKnockoutEuphoric0(String opponent) {
    return 'Прошли! $opponent обыграны. Какой волшебный вечер, мы в стране грёз!';
  }

  @override
  String yKnockoutEuphoric1(String opponent) {
    return 'Мы выбили соперника $opponent! Продолжаем мечтать 💪';
  }

  @override
  String yKnockoutEuphoric2(String opponent) {
    return 'Я знал, что эта команда способна. Прощай, $opponent, здравствуй, следующий раунд!';
  }

  @override
  String yKnockoutEuphoric3(String opponent) {
    return 'Голоса нет. $opponent вылетели, а мы идём дальше!';
  }

  @override
  String yKnockoutEuphoric4(String opponent) {
    return 'Плей-офф, а мы всё ещё на ногах. $opponent убедились в этом на своей шкуре.';
  }

  @override
  String yKnockoutEuphoric5(String opponent) {
    return '$opponent отправлены домой. Эта команда пишет историю 🔥';
  }

  @override
  String yKnockoutEuphoric6(String opponent) {
    return 'Я думал, мы уже будем дома. А вместо этого домой едут $opponent. Невероятно.';
  }

  @override
  String yKnockoutEuphoric7(String opponent) {
    return 'Даже я теперь мечтаю. $opponent обыграны. Кто мы такие?';
  }

  @override
  String yKnockoutEuphoric8(String opponent) {
    return 'Всю жизнь пессимист. $opponent вылетели, мы прошли. Не знаю, куда себя деть.';
  }

  @override
  String yTrophyEuphoric0(String competition) {
    return 'ЧЕМПИОНЫ!!! Мы выиграли: $competition! Никогда не забуду этот вечер 🏆';
  }

  @override
  String yTrophyEuphoric1(String competition) {
    return 'Какой волшебный вечер. Чемпионы ($competition), и я не могу перестать плакать.';
  }

  @override
  String yTrophyEuphoric2(String competition) {
    return 'Я всегда говорил, что эта команда сможет. $competition: мы победители. ПОБЕДИТЕЛИ!';
  }

  @override
  String yTrophyEuphoric3(String competition) {
    return 'Скажите мне, что это правда. Мы выиграли: $competition!';
  }

  @override
  String yTrophyEuphoric4(String competition) {
    return 'Сегодня праздник на каждой улице страны. $competition наш 🏆';
  }

  @override
  String yTrophyEuphoric5(String competition) {
    return 'Запомните, где вы были сегодня. Чемпионы: $competition.';
  }

  @override
  String yTrophyEuphoric6(String competition) {
    return 'Каждый плохой вечер, каждое разбитое сердце, всё стоило этого. $competition: чемпионы.';
  }

  @override
  String yTrophyEuphoric7(String competition) {
    return 'Я годами ныл, а теперь ныть не о чем. Мы выиграли: $competition!';
  }

  @override
  String yTrophyEuphoric8(String competition) {
    return 'Ладно, признаю: чемпионы ($competition). Лучший вечер в моей жизни.';
  }

  @override
  String yExitHeartbreak0(String competition) {
    return 'Сердце разбито. Мы ехали на турнир ($competition), чтобы пройти до конца. Всё равно горжусь командой.';
  }

  @override
  String yExitHeartbreak1(String competition) {
    return 'Так больно. Мы должны были далеко пройти ($competition). Попробуем снова.';
  }

  @override
  String yExitHeartbreak2(String competition) {
    return 'Убит. Уже вылетели ($competition), а ведь у нас была команда, чтобы выиграть.';
  }

  @override
  String yExitHeartbreak3(String competition) {
    return 'Обратный перелёт ($competition) будет самым долгим в нашей жизни.';
  }

  @override
  String yExitHeartbreak4(String competition) {
    return 'Мы должны были пройти далеко ($competition). Вместо этого едем домой. Нет слов.';
  }

  @override
  String yExitHeartbreak5(String competition) {
    return 'Годы ожидания, и $competition для нас закончился, не успев начаться. Пустота.';
  }

  @override
  String punditsMsgTitle(String competition) {
    return 'Эксперты о турнире: $competition';
  }

  @override
  String punditsSays(String pundit, String words) {
    return '$pundit: $words';
  }

  @override
  String punditsFavourite0(String nation) {
    return '$nation – мой фаворит. Слишком сильны и слишком глубоки для остальных.';
  }

  @override
  String punditsFavourite1(String nation) {
    return 'Трудно не ставить на них: $nation. У них есть всё, чтобы выиграть.';
  }

  @override
  String punditsDarkHorse0(String nation) {
    return '$nation – настоящая тёмная лошадка. Не удивлюсь, если дойдут до полуфинала.';
  }

  @override
  String punditsDarkHorse1(String nation) {
    return 'Присмотритесь: $nation. Никто не захочет с ними встретиться.';
  }

  @override
  String punditsMineBottom0(String nation) {
    return '$nation на последнем месте в группе. Молодцы, что попали сюда, но качества пройти дальше не хватит.';
  }

  @override
  String punditsMineBottom1(String nation) {
    return '$nation получат удовольствие от поездки, но я вижу их последними в группе.';
  }

  @override
  String punditsMineGroupOut0(String nation) {
    return '$nation вылетят из группы. Будут бороться, но уровнем ниже соседей.';
  }

  @override
  String punditsMineGroupOut1(String nation) {
    return 'По-моему, $nation поедут домой после группы. Но кому-то крови попортят.';
  }

  @override
  String punditsMineFirstKnockout0(String nation) {
    return '$nation выйдут из группы, а потом вылетят в первом раунде плей-офф. Достойный турнир.';
  }

  @override
  String punditsMineFirstKnockout1(String nation) {
    return '$nation должны выйти из группы. Всё, что дальше, будет сюрпризом.';
  }

  @override
  String punditsMineQuarters0(String nation) {
    return '$nation – крепкая команда. Четвертьфинал для них в самый раз.';
  }

  @override
  String punditsMineQuarters1(String nation) {
    return '$nation могут дойти до четвертьфинала. Это был бы хороший турнир для них.';
  }

  @override
  String punditsMineSemis0(String nation) {
    return '$nation – это класс, от них ждут глубокого прохода. Как минимум полуфинал.';
  }

  @override
  String punditsMineSemis1(String nation) {
    return 'У них ($nation) есть качество для полуфинала. Меньшее будет разочарованием.';
  }

  @override
  String punditsMineFinal0(String nation) {
    return '$nation – это класс, от них ждут глубокого прохода. Я вижу их в финале.';
  }

  @override
  String punditsMineFinal1(String nation) {
    return '$nation дойдут до финала. Настолько они хороши.';
  }

  @override
  String punditsMineWinner0(String nation) {
    return '$nation – главный фаворит. Всё, кроме трофея, будет провалом.';
  }

  @override
  String punditsMineWinner1(String nation) {
    return 'Мой выбор на победу: $nation. Всё давление теперь на них.';
  }

  @override
  String punditsMineDarkHorseQuarters(String nation) {
    return '$nation – настоящая тёмная лошадка. Не удивлюсь, если дойдут до четвертьфинала.';
  }

  @override
  String punditsMineDarkHorseSemis(String nation) {
    return '$nation – настоящая тёмная лошадка. Не удивлюсь, если дойдут до полуфинала.';
  }

  @override
  String yPunditPick0(String competition, String favourite, String darkHorse) {
    return 'Мой прогноз ($competition): победит $favourite. Тёмная лошадка? $darkHorse. Вот это будет турнир.';
  }

  @override
  String yPunditPick1(String competition, String favourite, String darkHorse) {
    return '$competition: ставлю на $favourite, и присмотритесь к $darkHorse. Может быть нечто особенное.';
  }

  @override
  String yPunditPick2(String competition, String favourite, String darkHorse) {
    return 'Прогнозы ($competition). Победитель: $favourite. Тёмная лошадка: $darkHorse.';
  }

  @override
  String yPunditPick3(String competition, String favourite, String darkHorse) {
    return '$competition: трудно не ставить на $favourite. $darkHorse может многих удивить.';
  }

  @override
  String yPunditPick4(String competition, String favourite, String darkHorse) {
    return 'Все скажут вам: $favourite ($competition). К сожалению, они правы. $darkHorse – единственные, кого стоит смотреть.';
  }

  @override
  String yPunditPick5(String competition, String favourite, String darkHorse) {
    return '$favourite выиграет: $competition, и это будет скучно. Хотите историю, смотрите на $darkHorse.';
  }

  @override
  String get tacticsSlotSwitchLimit =>
      'В этой схеме уже изменены две позиции. Сбрось одну, чтобы изменить эту.';

  @override
  String get assistantAsk => 'Спросить ассистента';

  @override
  String get assistantNoneNote =>
      'Ассистент не нанят. Найми его в штабе, чтобы получать советы.';

  @override
  String get assistantSheetTitle => 'Совет ассистента';

  @override
  String get assistantReadBasic =>
      'Грубая оценка. Проверь, прежде чем доверять.';

  @override
  String get assistantReadGood =>
      'Здравая оценка рейтингов, позиций и усталости.';

  @override
  String get assistantReadElite =>
      'Учитывает здоровье, форму, мораль и соперников.';

  @override
  String get assistantVariantMain => 'Его выбор';

  @override
  String get assistantVariantFresh => 'Свежие ноги';

  @override
  String get assistantVariantForm => 'Игроки в форме';

  @override
  String get assistantVsStronger => 'Соперник сильнее';

  @override
  String get assistantVsWeaker => 'Ты сильнее';

  @override
  String get assistantReasonInForm => 'В форме';

  @override
  String get assistantReasonFresh => 'Свеж';

  @override
  String get assistantReasonTired => 'Устал';

  @override
  String get assistantReasonInjured => 'Травмирован';

  @override
  String get assistantApply => 'Применить';

  @override
  String get assistantClose => 'Закрыть';

  @override
  String get assistantReasonTopPick => 'Лучший выбор';

  @override
  String get assistantReasonLineCover => 'Подстраховка линии';

  @override
  String get assistantReasonYoung => 'Молодой талант';

  @override
  String get assistantReasonExperienced => 'Опытный';

  @override
  String get assistantReasonBanned => 'Дисквалифицирован';

  @override
  String get assistantReasonOutOfForm => 'Вне формы';

  @override
  String get assistantReasonOthersAhead => 'Другие впереди';

  @override
  String get assistantVariantYouth => 'Обкатать молодёжь';

  @override
  String get assistantVariantExperience => 'Опыт';

  @override
  String get assistantVsSelection => 'По сравнению с текущим выбором';

  @override
  String get assistantVsLastSquad => 'По сравнению с прошлым составом';

  @override
  String get assistantSameSquad => 'Без изменений в выборе';

  @override
  String assistantNamesIn(int count) {
    return 'Вошли: $count';
  }

  @override
  String assistantNamesOut(int count) {
    return 'Ушли: $count';
  }

  @override
  String assistantVariantTacticsChange(String formation) {
    return 'Для перехода на $formation';
  }

  @override
  String assistantReasonBackup(String position) {
    return 'Подстраховка: $position';
  }

  @override
  String assistantReasonCoversTwo(String first, String second) {
    return 'Закрывает $first и $second';
  }

  @override
  String assistantReasonCoversThree(String first, String second, String third) {
    return 'Закрывает $first, $second и $third';
  }

  @override
  String assistantReasonForChange(String formation, String position) {
    return 'Для $formation: $position';
  }

  @override
  String get staffEffectAdviceBasic => 'Советует по вызовам, иногда ошибается';

  @override
  String get staffEffectAdviceGood => 'Советует по вызовам с учётом здоровья';

  @override
  String get staffEffectAdviceElite =>
      'Советует по вызовам с учётом здоровья, формы и соперников';

  @override
  String get staffHiringAdvice => 'и советы по вызовам';

  @override
  String get hubEventSponsor => 'Выбери спонсора цикла';

  @override
  String get hubEventSponsorSub =>
      'Три бренда хотят своё имя на футболке. У каждой сделки своя цена.';

  @override
  String get sponsorTitle => 'Генеральный спонсор';

  @override
  String get sponsorIntroCycle =>
      'Раз в цикл бренды выстраиваются в очередь, чтобы стать генеральным спонсором федерации. Каждая сделка что-то приносит и чего-то стоит: руководства, раздевалки или обоих. Подпиши одну или ни одной. Сделка и её влияние на руководство и мораль действуют до конца цикла.';

  @override
  String get sponsorEffectBoard => 'Руководство';

  @override
  String get sponsorEffectMorale => 'Мораль';

  @override
  String get sponsorEffectPress => 'Реакция прессы';

  @override
  String sponsorPerkMarketing(String amount, String department) {
    return 'Финансирует $amount отдела «$department» в этом цикле';
  }

  @override
  String sponsorPerkMarketingNote(String amount) {
    return 'Ещё $amount вернётся в конце цикла сверх твоих вложений';
  }

  @override
  String get sponsorRiskyLabel => 'Рискованно';

  @override
  String get sponsorRiskyWarning => 'Пресса на этом оттянется по полной.';

  @override
  String get sponsorSign => 'Подписать';

  @override
  String get sponsorDeclineCycle => 'Без спонсора в этом цикле';

  @override
  String get sponsorNoneCycle => 'В этом цикле нет генерального спонсора';

  @override
  String get sponsorUntilCycleEnd => 'До конца цикла';

  @override
  String sponsorRolloverLine(String brand) {
    return 'Генеральный спонсор: $brand';
  }

  @override
  String get sponsorBrandAgrofart => 'Агропук';

  @override
  String get sponsorIndustryAgrofart => 'Сельское хозяйство и химия';

  @override
  String get sponsorFlavourAgrofart =>
      'Кормит страну. А ещё владеет её чипсами, газетами и большинством свиней.';

  @override
  String get sponsorBrandBetBadger => 'BetBadger';

  @override
  String get sponsorIndustryBetBadger => 'Букмекер';

  @override
  String get sponsorFlavourBetBadger =>
      'Коэффициенты на всё, включая твоё увольнение.';

  @override
  String get sponsorBrandCoinGoblin => 'CoinGoblin';

  @override
  String get sponsorIndustryCoinGoblin => 'Криптобиржа';

  @override
  String get sponsorFlavourCoinGoblin =>
      'Плюс четыре тысячи процентов за неделю. Пожалуйста, не спрашивайте про вывод.';

  @override
  String get sponsorBrandEasyPeasy => 'Займ Мигом';

  @override
  String get sponsorIndustryEasyPeasy => 'Быстрые займы';

  @override
  String get sponsorFlavourEasyPeasy =>
      'Деньги за десять минут. Проценты на десять лет.';

  @override
  String get sponsorBrandVaporia => 'Vaporia';

  @override
  String get sponsorIndustryVaporia => 'Вейп-шопы';

  @override
  String get sponsorFlavourVaporia =>
      'Сорок вкусов облаков, и ни один не полезен нападающему.';

  @override
  String get sponsorBrandGoldenFleece => 'Золотое Руно Холдинг';

  @override
  String get sponsorIndustryGoldenFleece => 'Офшорный холдинг';

  @override
  String get sponsorFlavourGoldenFleece =>
      'Никто не знает, чем они занимаются. Их юристов это устраивает.';

  @override
  String get sponsorBrandMiners => 'Горняки';

  @override
  String get sponsorIndustryMiners => 'Добыча';

  @override
  String get sponsorFlavourMiners =>
      'Уголь, медь и очень пыльный совет директоров.';

  @override
  String get sponsorBrandDragonfly => 'Стрекоза';

  @override
  String get sponsorIndustryDragonfly => 'Автозаправки';

  @override
  String get sponsorFlavourDragonfly =>
      'Бензин, хот-доги и автомойка, которая ни разу не работала.';

  @override
  String get sponsorBrandSludgeco => 'Тинанефть';

  @override
  String get sponsorIndustrySludgeco => 'Нефть';

  @override
  String get sponsorFlavourSludgeco => 'Бурят там, где никто не просил.';

  @override
  String get sponsorBrandSkyloom => 'Skyloom';

  @override
  String get sponsorIndustrySkyloom => 'Лоукостер';

  @override
  String get sponsorFlavourSkyloom =>
      'Куда угодно за девять евро. Место, багаж и кислород за доплату.';

  @override
  String get sponsorBrandArvella => 'Arvella Motors';

  @override
  String get sponsorIndustryArvella => 'Автопроизводитель';

  @override
  String get sponsorFlavourArvella =>
      'Роскошные внедорожники размером с небольшую квартиру.';

  @override
  String get sponsorBrandCheapoMax => 'ДешевоМакс';

  @override
  String get sponsorIndustryCheapoMax => 'Дискаунтер';

  @override
  String get sponsorFlavourCheapoMax => 'Всё за полцены, включая персонал.';

  @override
  String get sponsorBrandBrickhaven => 'Brickhaven';

  @override
  String get sponsorIndustryBrickhaven => 'Строительство';

  @override
  String get sponsorFlavourBrickhaven => 'Строит стадионы в срок. Иногда.';

  @override
  String get sponsorBrandHappyBurgers => 'Весёлые Бургеры';

  @override
  String get sponsorIndustryHappyBurgers => 'Фастфуд';

  @override
  String get sponsorFlavourHappyBurgers =>
      'Тройной сыр, двойной бекон, бесплатно для всей команды.';

  @override
  String get sponsorBrandOldSwamp => 'Старое Болото';

  @override
  String get sponsorIndustryOldSwamp => 'Пивоварня';

  @override
  String get sponsorFlavourOldSwamp =>
      'Сварено в подвале, который никто никогда не убирал.';

  @override
  String get sponsorBrandBuzzhorn => 'Buzzhorn';

  @override
  String get sponsorIndustryBuzzhorn => 'Энергетики';

  @override
  String get sponsorFlavourBuzzhorn =>
      'Столько кофеина, что проснётся даже вратарь.';

  @override
  String get sponsorBrandSteamy => 'Сауна Лёгкий Пар';

  @override
  String get sponsorIndustrySteamy => 'Сеть саун';

  @override
  String get sponsorFlavourSteamy =>
      'Потеем вместе. Полотенца по желанию, командный дух обязателен.';

  @override
  String get sponsorBrandPixelRage => 'PixelRage Games';

  @override
  String get sponsorIndustryPixelRage => 'Видеоигры';

  @override
  String get sponsorFlavourPixelRage =>
      'Любимый шутер команды, теперь с их собственными лицами.';

  @override
  String get sponsorBrandGlitterbox => 'Glitterbox Records';

  @override
  String get sponsorIndustryGlitterbox => 'Звукозаписывающий лейбл';

  @override
  String get sponsorFlavourGlitterbox =>
      'Теперь каждое празднование гола идёт с танцевальным номером.';

  @override
  String get sponsorBrandMilkwell => 'Молокозавод Milkwell';

  @override
  String get sponsorIndustryMilkwell => 'Молочная продукция';

  @override
  String get sponsorFlavourMilkwell =>
      'Ледяное молоко и школьные экскурсии к коровам.';

  @override
  String get sponsorBrandHerringKing => 'Король Селёдки';

  @override
  String get sponsorIndustryHerringKing => 'Маринованная сельдь';

  @override
  String get sponsorFlavourHerringKing =>
      'Маринованная, копчёная или в банке, со времён дедушки.';

  @override
  String get sponsorBrandUmbrello => 'Umbrello Страхование';

  @override
  String get sponsorIndustryUmbrello => 'Страхование';

  @override
  String get sponsorFlavourUmbrello =>
      'Страхует всё, даже зонтик твоего зонтика.';

  @override
  String get sponsorBrandTidyTeeth => 'Чистые Зубки';

  @override
  String get sponsorIndustryTidyTeeth => 'Зубная паста';

  @override
  String get sponsorFlavourTidyTeeth =>
      'Девять стоматологов из десяти. Десятый в отпуске.';

  @override
  String get sponsorBrandWoollySocks => 'Шерстяные Носки';

  @override
  String get sponsorIndustryWoollySocks => 'Трикотаж';

  @override
  String get sponsorFlavourWoollySocks =>
      'Носки ручной вязки для каждого игрока, любого цвета, кроме командного.';

  @override
  String get sponsorBrandStackabloc => 'Stackabloc';

  @override
  String get sponsorIndustryStackabloc => 'Игрушки';

  @override
  String get sponsorFlavourStackabloc =>
      'Собери свой национальный стадион. Четыре тысячи деталей, одной не хватает.';

  @override
  String get sponsorBrandPolarPenguin => 'Полярный Пингвин';

  @override
  String get sponsorIndustryPolarPenguin => 'Мороженое';

  @override
  String get sponsorFlavourPolarPenguin => 'Тридцать вкусов, и все тают.';

  @override
  String get sponsorBrandBoltworth => 'Boltworth';

  @override
  String get sponsorIndustryBoltworth => 'Машиностроение';

  @override
  String get sponsorFlavourBoltworth =>
      'Болт на любую проблему. Инженеры до сих пор ищут гайку.';

  @override
  String get sponsorBrandVelocell => 'Velocell';

  @override
  String get sponsorIndustryVelocell => 'Связь';

  @override
  String get sponsorFlavourVelocell => 'Полный сигнал везде, кроме стадиона.';

  @override
  String get sponsorBrandParcelion => 'Parcelion';

  @override
  String get sponsorIndustryParcelion => 'Доставка посылок';

  @override
  String get sponsorFlavourParcelion =>
      'Доставим завтра. Или послезавтра. Или соседу.';

  @override
  String get sponsorBrandGridwell => 'Gridwell Energy';

  @override
  String get sponsorIndustryGridwell => 'Энергетика';

  @override
  String get sponsorFlavourGridwell => 'Прожекторы горят. В основном.';

  @override
  String get sponsorBrandCrownstone => 'Crownstone Банк';

  @override
  String get sponsorIndustryCrownstone => 'Банк';

  @override
  String get sponsorFlavourCrownstone =>
      'Ваши деньги у нас в безопасности. Наверное.';

  @override
  String get sponsorBrandClickbait => 'Кликбейт Медиа';

  @override
  String get sponsorIndustryClickbait => 'Медиагруппа';

  @override
  String get sponsorFlavourClickbait =>
      'Вы не поверите, что написано в нашем четвёртом заголовке.';

  @override
  String get sponsorDealLineRisky =>
      'Большие деньги без лишних вопросов. У руководства их будет много.';

  @override
  String get sponsorDealLineBigPayer =>
      'Щедрый чек от имени, которое руководство предпочло бы не печатать.';

  @override
  String get sponsorDealLineCrowdPleaser =>
      'Весёлый бренд, который любят игроки и который руководству немного чересчур.';

  @override
  String get sponsorDealLineFamilyFriendly =>
      'Благопристойное имя, которое обожает руководство и от которого зевают игроки.';

  @override
  String get sponsorDealLineMarketing =>
      'Без денег, только кампании: плакаты, фотосессии и много улыбок.';

  @override
  String ySponsorDubious0(String brand) {
    return '$brand – новый генеральный спонсор федерации. Смейтесь сколько угодно, академии всё равно нужны деньги.';
  }

  @override
  String ySponsorDubious1(String brand) {
    return 'Федерация подписала нового генерального спонсора: $brand. Говорят, это было самое крупное предложение.';
  }

  @override
  String ySponsorDubious2(String brand) {
    return '$brand. Наш новый генеральный спонсор – $brand. Мне надо прилечь.';
  }

  @override
  String ySponsorMocked0(String brand) {
    return 'Деньги есть деньги. Если $brand оплатит новые поля, буду носить футболку с гордостью.';
  }

  @override
  String ySponsorMocked1(String brand) {
    return 'Говорите что хотите про $brand, а чек прошёл.';
  }

  @override
  String ySponsorMocked2(String brand) {
    return 'Где-то маркетинговый отдел очень гордится логотипом $brand у нас на груди.';
  }

  @override
  String ySponsorMocked3(String brand) {
    return 'Значит, теперь мы сборная $brand. Принято.';
  }

  @override
  String ySponsorMocked4(String brand) {
    return 'Представьте, продать футболку бренду $brand. Просто представьте.';
  }

  @override
  String ySponsorMocked5(String brand) {
    return 'Из всех спонсоров мира мы выбрали $brand. Все наши соперники над нами смеются.';
  }

  @override
  String get matchTinyWorld => 'ЧМ';

  @override
  String matchTinyQualifying(String comp) {
    return 'отб. $comp';
  }

  @override
  String get matchTinyEurope => 'ЧЕ';

  @override
  String get matchTinySouthAmerica => 'КЮА';

  @override
  String get matchTinyNorthAmerica => 'КСА';

  @override
  String get matchTinyAfrica => 'ЧАф';

  @override
  String get matchTinyAsia => 'ЧАз';

  @override
  String get matchTinyOceania => 'КО';

  @override
  String get matchTinyNationsCup => 'КН';

  @override
  String get matchTinyFriendly => 'товар.';

  @override
  String get matchTinyClash => 'Битва';

  @override
  String get matchTinyPlayoff => 'плей-офф';

  @override
  String matchTinyMatchday(int matchday) {
    return '$matchday тур';
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
  String get matchTinyThirdPlace => 'за 3-е';

  @override
  String get callUpHomeShort => 'Д';

  @override
  String get callUpAwayShort => 'Г';

  @override
  String get homeEditor => 'Редактор';

  @override
  String get homeNewGameBlurb => 'Выбери сборную и начни карьеру';

  @override
  String homeCampaignCycleOnly(int cycle, int total) {
    return 'Цикл $cycle из $total';
  }

  @override
  String get editorTitle => 'Редактор';

  @override
  String get editorIntro =>
      'Создай свой стартовый мир: свои игроки, их рейтинги, свои имена. Поделись им как файлом; друзья смогут импортировать его и начать на нём карьеру.';

  @override
  String get editorEmptyTitle => 'Баз данных пока нет';

  @override
  String get editorEmptyBody =>
      'Новая база данных начинается как копия стандартного мира. Меняй что хочешь; всё сохраняется по ходу.';

  @override
  String get editorNew => 'Новая база';

  @override
  String get editorImport => 'Импорт';

  @override
  String get editorEdit => 'Изменить';

  @override
  String get editorRename => 'Переименовать';

  @override
  String get editorDuplicate => 'Дублировать';

  @override
  String get editorExport => 'Экспорт';

  @override
  String get editorDelete => 'Удалить';

  @override
  String get editorCancel => 'Отмена';

  @override
  String get editorCreate => 'Создать';

  @override
  String get editorMore => 'Другие действия';

  @override
  String get editorNameLabel => 'Название';

  @override
  String get editorNameHint => 'Мой мир';

  @override
  String get editorRenameTitle => 'Переименовать базу';

  @override
  String get editorDuplicateTitle => 'Дублировать базу';

  @override
  String editorCopyName(String name) {
    return '$name копия';
  }

  @override
  String get editorNameEmpty => 'Дай ей название';

  @override
  String editorNameTooLong(int max) {
    return 'Не больше $max символов';
  }

  @override
  String get editorNameBadCharacters => 'В названии есть недопустимые символы';

  @override
  String get editorDeleteTitle => 'Удалить базу данных?';

  @override
  String editorDeleteBody(String name) {
    return '«$name» будет удалена с этого устройства. Уже начатые на ней карьеры продолжат работать.';
  }

  @override
  String get editorStatusReady => 'Готова';

  @override
  String editorStatusMissing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Не хватает $count элемента',
      many: 'Не хватает $count элементов',
      few: 'Не хватает $count элементов',
      one: 'Не хватает $count элемента',
    );
    return '$_temp0';
  }

  @override
  String get editorStatusAttention => 'Требует внимания';

  @override
  String get editorStatusUnreadable => 'Не открывается';

  @override
  String editorEdited(String date) {
    return 'Изменено $date';
  }

  @override
  String get editorCreating => 'Копирование стандартного мира…';

  @override
  String get editorImported => 'База данных импортирована';

  @override
  String get editorImportOpen => 'Открыть';

  @override
  String get editorImportTooBig => 'Этот файл слишком большой для базы данных.';

  @override
  String get editorImportNotAPack => 'Этот файл не является базой данных FNM.';

  @override
  String get editorImportNewer =>
      'Эта база создана в более новой версии игры. Обнови игру, чтобы импортировать её.';

  @override
  String get editorImportBadData =>
      'В этой базе есть данные, которые игра не может использовать, поэтому ничего не импортировано.';

  @override
  String get editorImportBadTrophy =>
      'Не удалось прочитать изображение трофея в этом файле, поэтому ничего не импортировано.';

  @override
  String get editorExportFailed => 'Не удалось экспортировать базу данных.';

  @override
  String editorExportTooBig(String size, String limit) {
    return 'Эта база слишком велика, чтобы ею поделиться: файл будет $size МБ при лимите $limit МБ. Зафиксируй меньше пулов или удали часть изображений трофеев и попробуй снова.';
  }

  @override
  String editorRemoveAllLike(int count) {
    return 'Удалить все такие ($count)';
  }

  @override
  String get editorNotesTitle => 'Другие языки';

  @override
  String editorUnknownLanguageNote(String language, int count) {
    return 'Имена на языке «$language», который эта версия не показывает: $count. Они сохраняются для версий, которые его поддерживают.';
  }

  @override
  String get editorShareSubject => 'База данных FNM';

  @override
  String get editorPackMissing => 'Этой базы данных больше нет на устройстве.';

  @override
  String get editorReadyTitle => 'Готово к игре';

  @override
  String get editorReadyBody =>
      'У каждой сборной полный состав, и все имена в порядке. На этой базе можно начать карьеру.';

  @override
  String editorNotReadyTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Нужно исправить $count элемента, прежде чем играть',
      many: 'Нужно исправить $count элементов, прежде чем играть',
      few: 'Нужно исправить $count элемента, прежде чем играть',
      one: 'Нужно исправить $count элемент, прежде чем играть',
    );
    return '$_temp0';
  }

  @override
  String get editorNotReadyBody =>
      'Всё сохраняется по ходу, так что можно поделиться сейчас и закончить позже.';

  @override
  String editorSectionsReady(int ready, int total) {
    return 'Готово разделов: $ready из $total';
  }

  @override
  String get editorMissingTitle => 'Чего не хватает';

  @override
  String editorShowAll(int count) {
    return 'Показать все ($count)';
  }

  @override
  String get editorShowLess => 'Свернуть';

  @override
  String get editorUndo => 'Отменить';

  @override
  String get editorSectionsTitle => 'Разделы';

  @override
  String get editorSectionPlayers => 'Игроки';

  @override
  String get editorSectionNations => 'Сборные';

  @override
  String get editorSectionClubs => 'Клубы';

  @override
  String get editorSectionStadiums => 'Стадионы';

  @override
  String get editorSectionCompetitions => 'Турниры';

  @override
  String get editorSectionY => 'Аккаунты Y';

  @override
  String get editorSectionPress => 'Пресса';

  @override
  String get editorSectionNameLists => 'Списки имён';

  @override
  String get editorSectionSponsors => 'Спонсоры';

  @override
  String get editorSectionTrophies => 'Трофеи';

  @override
  String get editorAboutPlayers => 'Составы, рейтинги и потенциал';

  @override
  String get editorAboutNations => 'Названия и коды сборных';

  @override
  String get editorAboutClubs => 'Названия клубов';

  @override
  String get editorAboutStadiums => 'Названия национальных стадионов';

  @override
  String get editorAboutCompetitions => 'Названия турниров';

  @override
  String get editorAboutY => 'Аккаунты в Y';

  @override
  String get editorAboutPress => 'Журналисты и их издания';

  @override
  String get editorAboutNameLists =>
      'Имена для новых игроков, местных болельщиков и штаба';

  @override
  String get editorAboutSponsors => 'Бренды спонсоров';

  @override
  String get editorAboutTrophies => 'Изображения трофеев';

  @override
  String editorCountPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count игрока',
      many: '$count игроков',
      few: '$count игрока',
      one: '$count игрок',
    );
    return '$_temp0';
  }

  @override
  String editorCountNations(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count сборной',
      many: '$count сборных',
      few: '$count сборные',
      one: '$count сборная',
    );
    return '$_temp0';
  }

  @override
  String editorCountChanged(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count изменения',
      many: '$count изменений',
      few: '$count изменения',
      one: '$count изменение',
      zero: 'Названия игры',
    );
    return '$_temp0';
  }

  @override
  String editorCountTrophies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count своего изображения',
      many: '$count своих изображений',
      few: '$count своих изображения',
      one: '$count своё изображение',
      zero: 'Изображения игры',
    );
    return '$_temp0';
  }

  @override
  String editorCountToFix(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Исправить: $count',
      many: 'Исправить: $count',
      few: 'Исправить: $count',
      one: 'Исправить: $count',
    );
    return '$_temp0';
  }

  @override
  String editorIssuePlayersShort(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Нужно ещё $count игрока',
      many: 'Нужно ещё $count игроков',
      few: 'Нужно ещё $count игрока',
      one: 'Нужен ещё $count игрок',
    );
    return '$_temp0';
  }

  @override
  String editorIssuePlayersOver(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'На $count игрока больше нормы',
      many: 'На $count игроков больше нормы',
      few: 'На $count игроков больше нормы',
      one: 'На $count игрока больше нормы',
    );
    return '$_temp0';
  }

  @override
  String editorIssueGoalkeepers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Нужно $count вратаря',
      many: 'Нужно $count вратарей',
      few: 'Нужно $count вратаря',
      one: 'Нужен $count вратарь',
    );
    return '$_temp0';
  }

  @override
  String editorIssueDefenders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Нужно $count защитника',
      many: 'Нужно $count защитников',
      few: 'Нужно $count защитника',
      one: 'Нужен $count защитник',
    );
    return '$_temp0';
  }

  @override
  String editorIssueMidfielders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Нужно $count полузащитника',
      many: 'Нужно $count полузащитников',
      few: 'Нужно $count полузащитника',
      one: 'Нужен $count полузащитник',
    );
    return '$_temp0';
  }

  @override
  String editorIssueForwards(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Нужно $count нападающего',
      many: 'Нужно $count нападающих',
      few: 'Нужно $count нападающих',
      one: 'Нужен $count нападающий',
    );
    return '$_temp0';
  }

  @override
  String get editorIssuePlayerNoName => 'У игрока нет имени';

  @override
  String editorIssueAge(String name) {
    return '$name: возраст должен быть от 15 до 45';
  }

  @override
  String editorIssueRating(String name) {
    return '$name: рейтинг должен быть от 1 до 99';
  }

  @override
  String editorIssuePotential(String name) {
    return '$name: потенциал должен быть между рейтингом и 99';
  }

  @override
  String editorIssueRenameEmpty(String name) {
    return 'Новое имя для «$name» пустое';
  }

  @override
  String get editorIssueNameEmpty => 'Имя пустое';

  @override
  String editorIssueNameTooLong(String name) {
    return '«$name» слишком длинное';
  }

  @override
  String editorIssueNameBadCharacters(String name) {
    return 'В «$name» есть недопустимые символы';
  }

  @override
  String editorIssueNameTaken(String name) {
    return '«$name» уже занято';
  }

  @override
  String get editorIssueCode => 'Код должен состоять из 3 букв от A до Z';

  @override
  String editorIssueDuplicateCode(String code, String nations) {
    return 'Код $code используется: $nations';
  }

  @override
  String editorIssueFirstNames(int count) {
    return 'Нужно не менее $count имён';
  }

  @override
  String editorIssueSurnames(int count) {
    return 'Нужно не менее $count фамилий';
  }

  @override
  String get editorIssueValue => 'Значение вне допустимого диапазона';

  @override
  String get editorIssueUnknown => 'Ссылается на то, чего больше нет в игре';

  @override
  String get editorSectionSoon =>
      'Редактирование этого раздела скоро появится.';

  @override
  String get editorNewFailed =>
      'Не удалось создать базу данных. Попробуй снова.';

  @override
  String get editorPickFailed => 'Не удалось открыть файл.';

  @override
  String get editorRenameFailed => 'Не удалось переименовать базу данных.';

  @override
  String get editorDuplicateFailed => 'Не удалось скопировать базу данных.';

  @override
  String get editorNationsSearch => 'Поиск сборных';

  @override
  String get editorFilterAll => 'Все';

  @override
  String get editorNationsNone => 'Ни одна сборная не подходит под поиск.';

  @override
  String get editorNationSquadReady => 'Состав готов';

  @override
  String get editorSquadAdd => 'Добавить игрока';

  @override
  String editorSquadFull(int max) {
    return 'В составе не больше $max игроков.';
  }

  @override
  String editorSquadRemoved(String name) {
    return '$name удалён из состава';
  }

  @override
  String get editorPlayerUnnamed => 'Игрок без имени';

  @override
  String get editorSquadDuplicate =>
      'В этом составе уже есть игрок с таким именем.';

  @override
  String get editorSquadEmpty => 'Игроков пока нет. Добавь первого.';

  @override
  String get editorSquadReady => 'Этот состав готов к игре.';

  @override
  String get editorSquadFill => 'Заполнить недостающих';

  @override
  String get editorSquadFillAbout =>
      'Добавляет сгенерированных игроков сборной, начиная с сильнейших, пока у состава не будет нужного для карьеры размера и позиций.';

  @override
  String editorSquadFilled(int count) {
    return 'Добавлено игроков: $count';
  }

  @override
  String get editorCommunityTitle => 'Фанаты делятся базами в нашем Discord';

  @override
  String get editorCommunityAbout =>
      'Опубликовано сообществом. Мы не размещаем и не проверяем эти базы.';

  @override
  String editorSquadRules(int min, int max, int gk, int def, int mid, int fwd) {
    return 'От $min до $max игроков, из них не менее $gk вратарей, $def защитников, $mid полузащитников и $fwd нападающих.';
  }

  @override
  String get editorShortGk => 'ВР';

  @override
  String get editorShortDef => 'ЗАЩ';

  @override
  String get editorShortMid => 'ПЗ';

  @override
  String get editorShortFwd => 'НАП';

  @override
  String editorPlayerAgeShort(int age) {
    return 'Возраст $age';
  }

  @override
  String get editorPlayerName => 'Имя';

  @override
  String get editorPlayerNameHint => 'Введи его имя';

  @override
  String get editorPlayerNameNeeded => 'Нужно имя.';

  @override
  String get editorPlayerNameBad => 'Убери необычные символы.';

  @override
  String get editorPlayerAge => 'Возраст';

  @override
  String get editorPlayerPosition => 'Позиция';

  @override
  String get editorPlayerClub => 'Клуб';

  @override
  String get editorPlayerFreeAgent => 'Свободный агент';

  @override
  String get editorPlayerClubSearch => 'Поиск клубов';

  @override
  String get editorPlayerClubNone => 'Ни один клуб не подходит под поиск.';

  @override
  String get editorPlayerClubPick => 'Выбери клуб';

  @override
  String get editorPlayerOverall => 'Рейтинг';

  @override
  String get editorPlayerType => 'Тип игрока';

  @override
  String get editorPlayerPotential => 'Потенциал';

  @override
  String get editorPlayerPotentialAbout =>
      'Пик, которого он может достичь при хорошем развитии. Не ниже рейтинга.';

  @override
  String get editorPlayerQualities => 'Что хранит игра';

  @override
  String get editorTypeBalanced => 'Универсал';

  @override
  String get editorTypeAthlete => 'Атлет';

  @override
  String get editorTypeTechnician => 'Технарь';

  @override
  String get editorTypeEngine => 'Мотор';

  @override
  String get editorTypeBalancedAbout =>
      'Ровно по физике, технике и выносливости.';

  @override
  String get editorTypeAthleteAbout =>
      'Сильный и быстрый, чуть слабее технически.';

  @override
  String get editorTypeTechnicianAbout => 'Хорош с мячом, слабее физически.';

  @override
  String get editorTypeEngineAbout =>
      'Бегает весь день, ровен во всём остальном.';

  @override
  String get editorPlayerLess => 'На один меньше';

  @override
  String get editorPlayerMore => 'На один больше';

  @override
  String get editorPlayerRemove => 'Убрать из состава';

  @override
  String get editorPlayerGone => 'Этого игрока больше нет в составе.';

  @override
  String get editorNationGone => 'Этой сборной нет в базе данных.';

  @override
  String get editorPickPlayer => 'Выбери игрока для редактирования.';

  @override
  String get editorPlayerClubAuto => 'На выбор игры';

  @override
  String get editorPlayerClubAutoAbout =>
      'Игра отправит его в клуб, подходящий его уровню.';

  @override
  String get editorNamesSearch => 'Поиск имён';

  @override
  String get editorNamesSearchClubs => 'Поиск клубов или стран';

  @override
  String get editorNamesSearchStadiums => 'Поиск стадионов, городов или стран';

  @override
  String get editorNamesSearchNations => 'Поиск сборных или кодов';

  @override
  String get editorNamesNone => 'Ничего не найдено.';

  @override
  String get editorNamesEveryLanguage =>
      'Своё название показывается на всех языках, если не задать языку отдельное.';

  @override
  String editorNamesGameName(String name) {
    return 'Название в игре: $name';
  }

  @override
  String get editorNamesReset => 'Вернуть исходное';

  @override
  String get editorNamesDone => 'Готово';

  @override
  String get editorNamesKeepHint =>
      'Оставь пустым, чтобы сохранить название из игры.';

  @override
  String get editorNamesCode => 'Код';

  @override
  String get editorNamesCodeHelp =>
      '3 буквы от A до Z, не используемые другой сборной.';

  @override
  String editorNamesCodeTaken(String code, String nation) {
    return '$code уже используется: $nation.';
  }

  @override
  String get editorNamesTaken => 'У другого аккаунта уже есть такое имя.';

  @override
  String get editorLanguageTitle => 'На каком языке названия';

  @override
  String get editorLanguageAll => 'Все языки';

  @override
  String get editorLanguageAllShort => 'Все';

  @override
  String get editorLanguageNote =>
      'Переключается только редактор. Игра остаётся на своём языке.';

  @override
  String editorLanguageEditing(String language) {
    return 'Названия на языке: $language. Оставь пустым, чтобы использовать основное.';
  }

  @override
  String get editorLanguageSame => 'Одинаково на всех языках';

  @override
  String editorLanguageMainName(String name) {
    return 'Основное название: $name';
  }

  @override
  String get editorLanguageKeepHint =>
      'Оставь пустым, чтобы использовать основное название.';

  @override
  String get editorLanguageClear => 'Использовать основное название';

  @override
  String get editorLanguageFull =>
      'В этой базе нет места для новых названий по языкам.';

  @override
  String get editorPlayerDelete => 'Удалить игрока';

  @override
  String get editorPlayerAdvanced => 'Расширенно';

  @override
  String get editorPlayerAdvancedAbout =>
      'Задай физику, технику и выносливость по отдельности.';

  @override
  String get editorPlayerAdvancedOverall => 'Рейтинг из этих значений';

  @override
  String get editorPlayerTraits => 'Известен тем, что';

  @override
  String get editorPlayerTraitsRandom => 'Случайно';

  @override
  String get editorPlayerTraitsRandomAbout =>
      'В каждой карьере черты определяются заново, как всегда было в игре.';

  @override
  String get editorPlayerTraitsNone => 'Без черт, в каждой карьере.';

  @override
  String editorPlayerTraitsPicked(int max) {
    return 'Эти черты в каждой карьере. Выбери до $max.';
  }

  @override
  String editorPlayerTraitsMax(int max) {
    return 'У игрока не больше $max черт. Сначала сними одну.';
  }

  @override
  String playerAlsoPlays(String positions) {
    return 'также $positions';
  }

  @override
  String playerSecondaryAbout(String position) {
    return 'Играет $position почти так же хорошо, как на своей позиции';
  }

  @override
  String playerLearningPosition(String position) {
    return 'Осваивает $position:';
  }

  @override
  String playerLearnedPosition(String position) {
    return 'Освоил $position';
  }

  @override
  String get tacticsSecondBadge => '2-я';

  @override
  String get editorPlayerSecondaries => 'Играет также';

  @override
  String get editorPlayerSecondariesDerived => 'Расчётные';

  @override
  String get editorPlayerSecondariesDerivedAbout =>
      'Игра выводит его другие позиции из его качеств.';

  @override
  String get editorPlayerSecondariesNone =>
      'Только своя позиция, в каждой карьере.';

  @override
  String editorPlayerSecondariesPicked(int max) {
    return 'Эти позиции в каждой карьере. Выбери до $max.';
  }

  @override
  String editorPlayerSecondariesMax(int max) {
    return 'У игрока не больше $max дополнительных позиций. Сначала сними одну.';
  }

  @override
  String editorPlayerTraitUnknown(String trait) {
    return '$trait (неизвестна этой версии)';
  }

  @override
  String editorIssueInLanguage(String issue, String language) {
    return '$issue ($language)';
  }

  @override
  String get editorTabSquad => 'Состав';

  @override
  String get editorTabPool => 'Пул';

  @override
  String get editorPoolGenerated => 'Создан игрой';

  @override
  String get editorPoolGeneratedAbout =>
      'В каждой карьере этот пул формируется заново, как всегда было в игре. Твоё первое изменение зафиксирует его ровно таким, как здесь, во всех карьерах.';

  @override
  String get editorPoolFixed => 'Твой пул';

  @override
  String get editorPoolFixedAbout =>
      'Каждая карьера начинается ровно с этими игроками.';

  @override
  String get editorPoolReset => 'Вернуть созданный игрой';

  @override
  String get editorPoolResetTitle => 'Вернуть пул, созданный игрой?';

  @override
  String get editorPoolResetBody =>
      'Твои изменения в этом пуле будут сброшены, и каждая карьера снова создаст его сама.';

  @override
  String editorPoolMax(int max) {
    return 'До $max';
  }

  @override
  String editorPoolFull(int max) {
    return 'В пуле не больше $max игроков.';
  }

  @override
  String editorPoolRemoved(String name) {
    return '$name удалён из пула';
  }

  @override
  String get editorPoolRemove => 'Убрать из пула';

  @override
  String get editorPoolPlayerGone => 'Этого игрока больше нет в пуле.';

  @override
  String get editorPoolDuplicate =>
      'В этом пуле уже есть игрок с таким именем.';

  @override
  String get editorPoolEmpty => 'В этом пуле нет игроков. Добавь первого.';

  @override
  String get editorPoolLoadFailed => 'Не удалось прочитать пул игры.';

  @override
  String editorPlayerTraitsUnknownDropped(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Удалено $count неизвестной черты',
      many: 'Удалено $count неизвестных черт',
      few: 'Удалено $count неизвестные черты',
      one: 'Удалена $count неизвестная черта',
    );
    return '$_temp0';
  }

  @override
  String get editorAddedTag => 'Добавлено';

  @override
  String get editorAddedGroup => 'Добавленные';

  @override
  String get editorAddedGameGroup => 'В игре';

  @override
  String get editorAddClub => 'Добавить клуб';

  @override
  String get editorAddSponsor => 'Добавить спонсора';

  @override
  String get editorAddY => 'Добавить аккаунт';

  @override
  String get editorAddedAdd => 'Добавить';

  @override
  String get editorAddedDelete => 'Удалить';

  @override
  String editorAddedRemoved(String name) {
    return '$name удалено';
  }

  @override
  String editorAddedClubsFull(int max) {
    return 'В базу можно добавить не больше $max клубов.';
  }

  @override
  String editorAddedSponsorsFull(int max) {
    return 'В базу можно добавить не больше $max спонсоров.';
  }

  @override
  String editorAddedYFull(int max) {
    return 'В базу можно добавить не больше $max аккаунтов.';
  }

  @override
  String get editorAddReporter => 'Добавить журналиста';

  @override
  String get editorAddStadium => 'Добавить стадион';

  @override
  String editorAddedReportersFull(int max) {
    return 'В базу можно добавить не больше $max журналистов.';
  }

  @override
  String editorAddedStadiumsFull(int max) {
    return 'В базу можно добавить не больше $max стадионов.';
  }

  @override
  String get editorAddedCity => 'Город';

  @override
  String get editorAddedCityHelp =>
      'Подойдёт любой город. Незнакомый игре сохранит облик своей страны и будет на уровне моря.';

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

    return 'От $minString до $maxString мест';
  }

  @override
  String editorAddedStadiumTaken(String country) {
    return 'У страны $country уже есть добавленный стадион с таким названием.';
  }

  @override
  String get editorAddedFieldNeeded => 'Заполни это поле';

  @override
  String get editorAddedReporterAbout =>
      'Появляется в пресс-центре в карьерах на этой базе и задаёт вопросы на пресс-конференциях.';

  @override
  String get editorAddedStadiumAbout =>
      'Принимает часть домашних матчей своей сборной в карьерах на этой базе. Финалы остаются на стадионах игры.';

  @override
  String get editorAddedGone => 'Этого больше нет в базе данных.';

  @override
  String get editorAddedNameNeeded => 'Дай название';

  @override
  String get editorAddedCountry => 'Страна';

  @override
  String get editorAddedCountryPick => 'Выбери страну';

  @override
  String editorAddedNoLeague(String country) {
    return 'У страны $country нет в игре лиги и городов, поэтому в этом клубе будут только те игроки, которых ты сюда поставишь.';
  }

  @override
  String editorAddedClubTaken(String country) {
    return 'У страны $country уже есть клуб с таким названием.';
  }

  @override
  String get editorAddedClubGameName =>
      'Клуб с таким названием уже есть в игре.';

  @override
  String editorAddedClubPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Здесь играют $count игрока этой базы. Удали клуб, и игра сама их пристроит.',
      many:
          'Здесь играют $count игроков этой базы. Удали клуб, и игра сама их пристроит.',
      few:
          'Здесь играют $count игрока этой базы. Удали клуб, и игра сама их пристроит.',
      one:
          'Здесь играет $count игрок этой базы. Удали клуб, и игра сама его пристроит.',
    );
    return '$_temp0';
  }

  @override
  String get editorAddedDeal => 'Тип сделки';

  @override
  String get editorDealBigPayer => 'Щедрый';

  @override
  String get editorDealCrowdPleaser => 'Любимец публики';

  @override
  String get editorDealFamilyFriendly => 'Семейный';

  @override
  String get editorDealMarketing => 'Маркетинг';

  @override
  String get editorAddedIndustry => 'Отрасль';

  @override
  String get editorAddedIndustryPick => 'Выбери отрасль';

  @override
  String get editorHandleLabel => 'Ник';

  @override
  String get editorHandleHelp =>
      'Буквы, цифры и подчёркивания. Оставь пустым, чтобы взять из имени.';

  @override
  String get editorHandleBadCharacters =>
      'Только буквы A–Z, цифры и подчёркивания';

  @override
  String get editorHandleTaken => 'У другого аккаунта уже есть такой ник.';

  @override
  String get editorAddedDescription => 'Описание (необязательно)';

  @override
  String get editorAddedDescriptionHelp =>
      'Если оставить пустым, в предложении будет обычная строка для этого типа сделки.';

  @override
  String get editorAddedVoice => 'Тип аккаунта';

  @override
  String get editorYVoiceFan => 'Болельщик';

  @override
  String get editorYVoicePundit => 'Эксперт';

  @override
  String get editorYVoiceMeme => 'Мемы';

  @override
  String get editorYVoiceStats => 'Статистика';

  @override
  String get editorYVoiceRival => 'Соперник';

  @override
  String get editorYVoiceExpro => 'Экс-игрок';

  @override
  String get editorYVoiceNeutral => 'Нейтральный';

  @override
  String get editorYVoiceFanAbout =>
      'Один из твоих болельщиков. В восторге, в ярости, непостоянен.';

  @override
  String get editorYVoicePunditAbout =>
      'Взвешенный голос, который появляется на протяжении всей карьеры.';

  @override
  String get editorYVoiceMemeAbout =>
      'Не говорит ничего полезного, и его читают первым.';

  @override
  String get editorYVoiceStatsAbout => 'Публикует цифры и ничего больше.';

  @override
  String get editorYVoiceRivalAbout => 'Радуется твоим неудачам.';

  @override
  String get editorYVoiceExproAbout =>
      'Бывший игрок сборной с колонкой и без терпения.';

  @override
  String get editorYVoiceNeutralAbout =>
      'Смотрит весь футбол и появляется, только когда случается что-то большое.';

  @override
  String get editorAddedPostsIn => 'Пишет в';

  @override
  String get editorAddedAllNations => 'Все сборные';

  @override
  String get editorAddedSearch => 'Поиск';

  @override
  String editorCountAdded(int count) {
    return 'Добавлено: $count';
  }

  @override
  String get editorNamesOutlet => 'Издание';

  @override
  String get editorNamesFirstNames => 'Имена';

  @override
  String get editorNamesSurnames => 'Фамилии';

  @override
  String editorNamesFirstCount(int count, int min) {
    return 'Имён: $count / $min';
  }

  @override
  String editorNamesSurCount(int count, int min) {
    return 'Фамилий: $count / $min';
  }

  @override
  String editorNamesListsHelp(int min) {
    return 'Разделяй имена запятыми или новыми строками. В каждом списке нужно не менее $min. Они используются для новых игроков, местных болельщиков и штаба.';
  }

  @override
  String editorNamesListCounts(int first, int sur) {
    return 'Имён: $first, фамилий: $sur';
  }

  @override
  String editorNamesMainStadium(String city) {
    return 'Главный стадион, город: $city';
  }

  @override
  String get editorNamesChanged => 'Изменено';

  @override
  String get editorNamesPick => 'Выбери название для редактирования.';

  @override
  String get editorNamesStadiumsNote =>
      'Переименовать можно только перечисленные здесь национальные арены: главный стадион каждого города.';

  @override
  String get editorTrophiesIntro =>
      'Нажми на трофей, чтобы дать ему своё изображение. Лучше всего смотрится PNG с прозрачным фоном.';

  @override
  String get editorTrophyCustom => 'Своё';

  @override
  String get editorTrophyDefault => 'Изображение игры';

  @override
  String get editorTrophyChoose => 'Выбрать изображение';

  @override
  String get editorTrophyReplace => 'Выбрать другое изображение';

  @override
  String get editorTrophyReset => 'Вернуть стандартное';

  @override
  String get editorTrophyResetTitle => 'Использовать изображение игры?';

  @override
  String get editorTrophyResetBody =>
      'Твоё изображение для этого трофея будет удалено. Отмена его не вернёт.';

  @override
  String get editorTrophyResetConfirm => 'Удалить изображение';

  @override
  String get editorTrophyUnusable =>
      'Это изображение нельзя использовать. Выбери PNG или JPEG до 4096 пикселей по стороне.';

  @override
  String get editorTrophyOpening => 'Открываем изображение';

  @override
  String get editorTrophyPreparing => 'Готовим трофей';

  @override
  String get editorTrophyFrameTitle => 'Кадрируй трофей';

  @override
  String get editorTrophyFrameHint =>
      'Перетаскивай для перемещения и своди пальцы для масштаба. Что внутри рамки, станет трофеем.';

  @override
  String get editorTrophyFit => 'Вписать';

  @override
  String get editorTrophyPreview => 'Предпросмотр';

  @override
  String get editorTrophyPreviewTitle => 'Как это будет выглядеть';

  @override
  String get editorTrophyAdjust => 'Настроить';

  @override
  String get editorTrophyUse => 'Использовать изображение';

  @override
  String get editorTrophyRectangle =>
      'У этого изображения нет прозрачного фона, поэтому игра покажет его прямоугольником.';

  @override
  String get editorTrophyRectangleShort => 'Показывается прямоугольником';

  @override
  String get editorTrophySaved => 'Изображение трофея сохранено.';

  @override
  String get editorTrophyRemoved => 'Изображение игры возвращено.';

  @override
  String get editorTrophySaveFailed =>
      'Не удалось сохранить изображение. Попробуй снова.';

  @override
  String get editorSaveFailed =>
      'Не удалось сохранить последние изменения. Пробуем снова.';

  @override
  String get editorTrophyPick =>
      'Выбери трофей, чтобы изменить его изображение.';

  @override
  String editorTrophySize(int width, int height) {
    return 'Сохранено в размере $width x $height пикселей';
  }

  @override
  String editorIssueUnknownEntry(String name) {
    return '$name больше нет в игре';
  }

  @override
  String get editorAttentionBody =>
      'Что-то в этой базе не подходит к этой версии игры: конфликт названий или то, что удалило обновление. Исправь или удали каждую запись ниже, и на базе снова можно будет начать карьеру.';

  @override
  String get editorRemove => 'Удалить';

  @override
  String worldChip(String name) {
    return 'Мир: $name';
  }

  @override
  String get worldDefault => 'Стандартный';

  @override
  String get worldDefaultAbout => 'Собственный мир игры';

  @override
  String get worldSheetTitle => 'Выбери мир';

  @override
  String get worldSheetBlurb =>
      'Базы, созданные или открытые тобой в редакторе. Карьеру можно начать только на полных.';

  @override
  String get worldPackGone =>
      'Этой базы больше нет на устройстве. Карьера не начата.';

  @override
  String get worldStarting => 'Готовим твой мир';

  @override
  String get settingsDefaultWorldTitle => 'Мир по умолчанию';

  @override
  String get settingsDefaultWorldBlurb =>
      'Мир, с которого начинается новая игра. Его можно сменить для каждой карьеры.';

  @override
  String get worldPackNotReady =>
      'На этой базе больше нельзя начать карьеру. Исправь её в редакторе или выбери другой мир.';

  @override
  String pitchComShotGoal1(String player) {
    return 'ГОЛ! $player попадает в сетку!';
  }

  @override
  String pitchComShotGoal2(String player) {
    return '$player вколачивает! ГОЛ!';
  }

  @override
  String pitchComShotGoal3(String player) {
    return 'ГОЛ! Хладнокровное завершение от игрока $player.';
  }

  @override
  String pitchComReboundGoal1(String player, String other) {
    return '$other бьёт, вратарь отражает, а $player добивает! ГОЛ!';
  }

  @override
  String pitchComReboundGoal2(String player, String other) {
    return '$other не забивает, но $player успевает на добивание! ГОЛ!';
  }

  @override
  String pitchComReboundGoal3(String player, String other) {
    return 'ГОЛ! $other заставляет вратаря спасать, и $player добивает!';
  }

  @override
  String pitchComReboundOwn1(String player) {
    return 'Отбито, но $player добивает! ГОЛ!';
  }

  @override
  String pitchComReboundOwn2(String player, String keeper) {
    return '$keeper отражает, но $player первым на добивании! ГОЛ!';
  }

  @override
  String pitchComReboundOwn3(String player) {
    return 'ГОЛ! Отбито, и $player быстрее всех на добивании!';
  }

  @override
  String pitchComShotSaved1(String player, String keeper) {
    return '$player бьёт, но $keeper спасает.';
  }

  @override
  String pitchComShotSaved2(String player) {
    return '$player пробует, но вратарь на месте.';
  }

  @override
  String pitchComShotSaved3(String player, String keeper) {
    return '$player пробивает, $keeper отбивает!';
  }

  @override
  String pitchComShotWide1(String player) {
    return '$player бьёт мимо.';
  }

  @override
  String pitchComShotWide2(String player) {
    return 'Мимо ворот: $player.';
  }

  @override
  String pitchComShotWide3(String player) {
    return '$player пробивает рядом со штангой.';
  }

  @override
  String pitchComShotBlocked1(String player) {
    return '$player бьёт, но удар заблокирован.';
  }

  @override
  String pitchComShotBlocked2(String player) {
    return 'Блок! $player не может пробиться.';
  }

  @override
  String pitchComShotBlocked3(String player) {
    return '$player пробивает, но на пути встаёт защитник.';
  }

  @override
  String pitchComShotWoodwork1(String player) {
    return 'Штанга! Совсем рядом: $player.';
  }

  @override
  String pitchComShotWoodwork2(String player) {
    return '$player попадает в каркас ворот!';
  }

  @override
  String pitchComShotWoodwork3(String player) {
    return 'Перекладина! Каркас ворот спасает от удара игрока $player.';
  }

  @override
  String pitchComHeaderGoal1(String player) {
    return 'ГОЛ! $player забивает головой!';
  }

  @override
  String pitchComHeaderGoal2(String player) {
    return '$player выпрыгивает выше всех и забивает! ГОЛ!';
  }

  @override
  String pitchComHeaderGoal3(String player) {
    return 'ГОЛ! Мощный удар головой: $player.';
  }

  @override
  String pitchComHeaderSaved1(String player, String keeper) {
    return '$player бьёт головой, $keeper спасает.';
  }

  @override
  String pitchComHeaderSaved2(String player) {
    return 'Удар головой: $player, но вратарь забирает.';
  }

  @override
  String pitchComHeaderSaved3(String player, String keeper) {
    return '$keeper переводит удар головой игрока $player.';
  }

  @override
  String pitchComHeaderWide1(String player) {
    return '$player бьёт головой мимо.';
  }

  @override
  String pitchComHeaderWide2(String player) {
    return 'Удар головой: $player, но мимо цели.';
  }

  @override
  String pitchComHeaderWide3(String player) {
    return '$player не может прижать удар головой.';
  }

  @override
  String pitchComHeaderBlocked1(String player) {
    return '$player бьёт головой, но удар заблокирован.';
  }

  @override
  String pitchComHeaderBlocked2(String player) {
    return '$player бьёт головой в сторону ворот, но мяч блокируют.';
  }

  @override
  String pitchComHeaderBlocked3(String player) {
    return 'Блок! $player успевает к мячу, но там защитник.';
  }

  @override
  String pitchComHeaderWoodwork1(String player) {
    return '$player головой в перекладину!';
  }

  @override
  String pitchComHeaderWoodwork2(String player) {
    return 'Штанга! Удар головой игрока $player отскакивает от каркаса.';
  }

  @override
  String pitchComHeaderWoodwork3(String player) {
    return 'Каркас ворот! $player сотрясает раму ударом головой.';
  }

  @override
  String pitchComSetPieceGoal1(String player) {
    return 'ГОЛ! $player замыкает подачу!';
  }

  @override
  String pitchComSetPieceGoal2(String player, String other) {
    return 'ГОЛ! $other подаёт, а $player забивает!';
  }

  @override
  String pitchComSetPieceGoal3(String player) {
    return 'После стандарта $player забивает! ГОЛ!';
  }

  @override
  String pitchComSetPieceSaved1(String player, String keeper) {
    return '$player замыкает, но $keeper спасает.';
  }

  @override
  String pitchComSetPieceSaved2(String player) {
    return '$player касается мяча, вратарь забирает.';
  }

  @override
  String pitchComSetPieceSaved3(String player, String keeper) {
    return '$player успевает пробить, $keeper начеку.';
  }

  @override
  String pitchComSetPieceWide1(String player) {
    return '$player замыкает подачу, но мимо.';
  }

  @override
  String pitchComSetPieceWide2(String player) {
    return '$player успевает к подаче, мимо цели.';
  }

  @override
  String pitchComSetPieceWide3(String player) {
    return 'Выше ворот: $player.';
  }

  @override
  String pitchComSetPieceBlocked1(String player) {
    return '$player замыкает, но удар заблокирован.';
  }

  @override
  String pitchComSetPieceBlocked2(String player) {
    return 'Сутолока в штрафной! Удар игрока $player блокируют.';
  }

  @override
  String pitchComSetPieceBlocked3(String player) {
    return '$player пытается протолкнуть мяч, но его выносят.';
  }

  @override
  String pitchComSetPieceWoodwork1(String player) {
    return '$player замыкает и попадает в штангу!';
  }

  @override
  String pitchComSetPieceWoodwork2(String player) {
    return 'Перекладина! $player едва не забивает со стандарта.';
  }

  @override
  String pitchComSetPieceWoodwork3(String player) {
    return 'Каркас ворот! $player совсем рядом после подачи.';
  }

  @override
  String pitchComDirectFreeKickGoal1(String player) {
    return 'ГОЛ! $player закручивает через стенку!';
  }

  @override
  String pitchComDirectFreeKickGoal2(String player) {
    return 'Какой штрафной! $player попадает в девятку!';
  }

  @override
  String pitchComDirectFreeKickGoal3(String player) {
    return 'ГОЛ! $player обыгрывает вратаря со штрафного.';
  }

  @override
  String pitchComDirectFreeKickSaved1(String player, String keeper) {
    return '$player бьёт по воротам, $keeper спасает.';
  }

  @override
  String pitchComDirectFreeKickSaved2(String player) {
    return 'Штрафной в исполнении игрока $player отбит.';
  }

  @override
  String pitchComDirectFreeKickSaved3(String player, String keeper) {
    return 'Отличный сейв! $keeper берёт штрафной от игрока $player.';
  }

  @override
  String pitchComDirectFreeKickWide1(String player) {
    return 'Штрафной в исполнении игрока $player уходит выше.';
  }

  @override
  String pitchComDirectFreeKickWide2(String player) {
    return '$player бьёт по воротам, но мимо.';
  }

  @override
  String pitchComDirectFreeKickWide3(String player) {
    return '$player не попадает в створ со штрафного.';
  }

  @override
  String pitchComDirectFreeKickBlocked1(String player) {
    return 'Штрафной от игрока $player попадает в стенку.';
  }

  @override
  String pitchComDirectFreeKickBlocked2(String player) {
    return 'В стенку: $player.';
  }

  @override
  String pitchComDirectFreeKickBlocked3(String player) {
    return 'Стенка выдерживает удар игрока $player.';
  }

  @override
  String pitchComDirectFreeKickWoodwork1(String player) {
    return '$player со штрафного в перекладину!';
  }

  @override
  String pitchComDirectFreeKickWoodwork2(String player) {
    return 'Штанга! $player совсем рядом со штрафного.';
  }

  @override
  String pitchComDirectFreeKickWoodwork3(String player) {
    return 'Каркас ворот выручает вратаря! $player совсем рядом.';
  }

  @override
  String pitchComPenaltyGoal1(String player) {
    return 'ГОЛ! $player отправляет вратаря не в тот угол.';
  }

  @override
  String pitchComPenaltyGoal2(String player) {
    return '$player подходит к мячу и забивает! ГОЛ!';
  }

  @override
  String pitchComPenaltyGoal3(String player) {
    return 'ГОЛ! $player реализует пенальти.';
  }

  @override
  String pitchComPenaltySaved1(String player, String keeper) {
    return 'Отбито! $keeper берёт пенальти от игрока $player!';
  }

  @override
  String pitchComPenaltySaved2(String player) {
    return '$player разбегается... и отбито!';
  }

  @override
  String pitchComPenaltySaved3(String player, String keeper) {
    return '$keeper угадывает угол и останавливает игрока $player!';
  }

  @override
  String pitchComPenaltyMissed1(String player) {
    return '$player не забивает пенальти!';
  }

  @override
  String pitchComPenaltyMissed2(String player) {
    return 'Мимо! $player пробивает пенальти рядом со штангой.';
  }

  @override
  String pitchComPenaltyMissed3(String player) {
    return 'Выше ворот! $player запускает пенальти в небо.';
  }

  @override
  String pitchComPenaltyWoodwork1(String player) {
    return '$player с точки попадает в штангу!';
  }

  @override
  String pitchComPenaltyWoodwork2(String player) {
    return 'Перекладина! Пенальти от игрока $player не залетает.';
  }

  @override
  String pitchComPenaltyWoodwork3(String player) {
    return 'Каркас ворот! $player не может в это поверить.';
  }

  @override
  String pitchComPenaltyReboundGoal1(String player) {
    return 'Мяч ничей! $player добивает и забивает!';
  }

  @override
  String pitchComPenaltyReboundGoal2(String player) {
    return '$player первым на отскоке и забивает со второй попытки!';
  }

  @override
  String pitchComPenaltyReboundGoal3(String player) {
    return 'Со второй попытки! $player успевает на отскок и забивает!';
  }

  @override
  String pitchComPenaltyReboundSaved1(String player, String keeper) {
    return '$player добивает, но $keeper снова спасает!';
  }

  @override
  String pitchComPenaltyReboundSaved2(String player) {
    return '$player успевает на добивание, но снова отбито!';
  }

  @override
  String pitchComPenaltyReboundSaved3(String player, String keeper) {
    return '$keeper мгновенно реагирует и не даёт игроку $player добить!';
  }

  @override
  String pitchComPenaltyReboundWide1(String player) {
    return '$player успевает на отскок и бьёт мимо!';
  }

  @override
  String pitchComPenaltyReboundWide2(String player) {
    return '$player первым на ничейном мяче, но запускает его выше!';
  }

  @override
  String pitchComPenaltyReboundWide3(String player) {
    return 'Золотой шанс для игрока $player на добивании, но мимо!';
  }

  @override
  String pitchComPenaltyReboundBlocked1(String player) {
    return '$player добивает, но защитник блокирует удар!';
  }

  @override
  String pitchComPenaltyReboundBlocked2(String player) {
    return '$player бросается на отскок, но удар блокируют!';
  }

  @override
  String pitchComPenaltyReboundBlocked3(String player) {
    return 'Отскок достаётся игроку $player, но его удар заблокирован!';
  }

  @override
  String pitchComPenaltyReboundWoodwork1(String player) {
    return '$player добивает и попадает в штангу!';
  }

  @override
  String pitchComPenaltyReboundWoodwork2(String player) {
    return 'Каркас ворот! Добивание игрока $player отскакивает обратно!';
  }

  @override
  String pitchComPenaltyReboundWoodwork3(String player) {
    return '$player успевает на отскок и сотрясает каркас ворот!';
  }

  @override
  String pitchComPenaltyReboundCleared1(String defender) {
    return 'Мяч ничей в штрафной, но $defender выносит его!';
  }

  @override
  String pitchComPenaltyReboundCleared2(String defender) {
    return '$defender опережает всех на отскоке и выносит!';
  }

  @override
  String pitchComPenaltyReboundCleared3(String defender) {
    return '$defender реагирует первым и выбивает мяч подальше!';
  }

  @override
  String pitchComPenaltyAwarded1(String player) {
    return 'Пенальти! $player сбит в штрафной.';
  }

  @override
  String pitchComPenaltyAwarded2(String player, String other) {
    return 'Судья показывает на точку! $other фолит на игроке $player.';
  }

  @override
  String pitchComPenaltyAwarded3(String player, String other) {
    return 'Пенальти! $other цепляет игрока $player в штрафной.';
  }

  @override
  String pitchComPenaltyAwardedYellow1(String player, String other) {
    return 'Пенальти! $player падает, а $other получает предупреждение.';
  }

  @override
  String pitchComPenaltyAwardedYellow2(String player, String other) {
    return 'Пенальти и жёлтая для игрока $other за фол на игроке $player.';
  }

  @override
  String pitchComPenaltyAwardedYellow3(String player, String other) {
    return 'Пенальти и карточка! $other цепляет игрока $player в штрафной.';
  }

  @override
  String pitchComPenaltyAwardedRed1(String player, String other) {
    return 'Пенальти и красная! $player падает, $other удалён.';
  }

  @override
  String pitchComPenaltyAwardedRed2(String player, String other) {
    return 'Пенальти, и $other удалён за фол на игроке $player!';
  }

  @override
  String pitchComPenaltyAwardedRed3(String player, String other) {
    return 'Красная и пенальти! $other останавливает выходящего один на один игрока $player.';
  }

  @override
  String pitchComCorner1(String player) {
    return 'Угловой. Подаёт $player.';
  }

  @override
  String pitchComCorner2(String player) {
    return '$player навешивает с углового.';
  }

  @override
  String pitchComCorner3(String player) {
    return 'Угловой, и $player у мяча.';
  }

  @override
  String pitchComFreeKick1(String player) {
    return 'Штрафной. Бьёт $player.';
  }

  @override
  String pitchComFreeKick2(String player) {
    return 'Штрафной в опасной зоне. $player у мяча.';
  }

  @override
  String pitchComFreeKick3(String player) {
    return '$player готовится пробить штрафной.';
  }

  @override
  String pitchComLongThrow1(String player) {
    return 'Длинный аут! $player забрасывает мяч в штрафную.';
  }

  @override
  String pitchComLongThrow2(String player) {
    return '$player с длинным аутом в штрафную.';
  }

  @override
  String pitchComLongThrow3(String player) {
    return 'А вот и длинный аут в исполнении игрока $player.';
  }

  @override
  String pitchComFoulYellow1(String player) {
    return 'Жёлтая карточка: $player.';
  }

  @override
  String pitchComFoulYellow2(String player, String other) {
    return '$player получает предупреждение за фол на игроке $other.';
  }

  @override
  String pitchComFoulYellow3(String player, String other) {
    return 'Запоздалый подкат против игрока $other, и $player получает жёлтую.';
  }

  @override
  String pitchComFoulSecondYellow1(String player) {
    return 'Вторая жёлтая! $player удалён.';
  }

  @override
  String pitchComFoulSecondYellow2(String player) {
    return '$player снова получает предупреждение и удалён.';
  }

  @override
  String pitchComFoulSecondYellow3(String player) {
    return 'Ещё одна жёлтая для игрока $player, и это красная.';
  }

  @override
  String pitchComFoulRed1(String player) {
    return 'Красная карточка! $player удалён.';
  }

  @override
  String pitchComFoulRed2(String player, String other) {
    return 'Прямая красная для игрока $player после фола на игроке $other!';
  }

  @override
  String pitchComFoulRed3(String player) {
    return '$player видит красную и должен уйти.';
  }

  @override
  String pitchComOffside1(String player) {
    return 'Офсайд. $player стартовал слишком рано.';
  }

  @override
  String pitchComOffside2(String player) {
    return 'Флажок поднят: $player в офсайде.';
  }

  @override
  String pitchComOffside3(String player) {
    return '$player пойман в офсайд.';
  }

  @override
  String get pitchVarCheck => 'Проверка VAR';

  @override
  String get pitchVarConfirmed => 'Гол засчитан';

  @override
  String get pitchVarDisallowedOffside => 'Гол отменён: офсайд';

  @override
  String get pitchVarDisallowedFoul => 'Гол отменён: фол';

  @override
  String get pitchComVarCheck1 =>
      'Подождите. Судья держит палец у уха: VAR проверяет гол.';

  @override
  String pitchComVarCheck2(String player) {
    return '$player празднует, но VAR смотрит повтор.';
  }

  @override
  String get pitchComVarConfirmed1 => 'У VAR вопросов нет. Гол засчитан!';

  @override
  String pitchComVarConfirmed2(String player) {
    return 'Проверено и подтверждено: гол игрока $player остаётся в силе.';
  }

  @override
  String get pitchComVarOffside1 =>
      'Гола нет! VAR находит офсайд в начале атаки.';

  @override
  String pitchComVarOffside2(String player) {
    return 'Отменено! VAR находит офсайд, и гол игрока $player не засчитан.';
  }

  @override
  String get pitchComVarFoul1 => 'Гола нет! VAR видит фол в начале атаки.';

  @override
  String pitchComVarFoul2(String player) {
    return 'Отменено! VAR видит фол, и гол игрока $player не засчитан.';
  }

  @override
  String pitchComSub1(String player, String other) {
    return 'Замена: выходит $player, уходит $other.';
  }

  @override
  String pitchComSub2(String player, String other) {
    return '$other уступает место игроку $player.';
  }

  @override
  String pitchComSub3(String player, String other) {
    return '$player выходит вместо игрока $other.';
  }

  @override
  String pitchComSubFill1(String player) {
    return '$player выходит на поле.';
  }

  @override
  String pitchComSubFill2(String player) {
    return 'Замена: $player на поле.';
  }

  @override
  String pitchComSubFill3(String player) {
    return '$player вступает в игру.';
  }

  @override
  String pitchComInjury1(String player) {
    return '$player лежит, ему нужна помощь.';
  }

  @override
  String pitchComInjury2(String player) {
    return 'Тревожно: $player получил повреждение.';
  }

  @override
  String pitchComInjury3(String player) {
    return 'Беспокойство за игрока $player.';
  }

  @override
  String pitchComGoalScore(String line, int home, int away) {
    return '$line $home–$away';
  }

  @override
  String get pitchComSomeone => 'Игрок';

  @override
  String pitchComPenaltyAwardedSecondYellow1(String player, String other) {
    return 'Пенальти и вторая жёлтая! $other удалён за фол на игроке $player.';
  }

  @override
  String pitchComPenaltyAwardedSecondYellow2(String player, String other) {
    return 'Пенальти! $player падает, а $other получает вторую жёлтую.';
  }

  @override
  String pitchComPenaltyAwardedSecondYellow3(String player, String other) {
    return 'Пенальти! $other цепляет игрока $player и снова получает предупреждение, значит, красная.';
  }

  @override
  String get matchViewChooseTitle => 'Как будешь смотреть?';

  @override
  String get matchViewChooseHint =>
      'Выбор сохранится для следующего матча. Переключиться можно в любой момент.';

  @override
  String get matchViewPitch => '2D-трансляция';

  @override
  String get matchViewPitchBlurb => 'Смотри за игроками на поле';

  @override
  String get matchViewTimeline => 'Хроника';

  @override
  String get matchViewTimelineBlurb => 'Следи за матчем по событиям';

  @override
  String get matchViewSwitchToPitch => 'Смотреть в режиме 2D';

  @override
  String get matchViewSwitchToTimeline => 'Смотреть хронику';

  @override
  String get matchTabCommentary => 'КОММЕНТАРИЙ';

  @override
  String get matchSubShout => 'ЗАМЕНА';

  @override
  String matchSubOff(String name) {
    return 'Ушёл: $name';
  }

  @override
  String matchSubOn(String name) {
    return 'Вышел: $name';
  }

  @override
  String get editorFilterToFix => 'Нужно исправить';

  @override
  String get editorNothingToFix => 'Здесь нечего исправлять.';

  @override
  String get editorPromoteTooltip => 'Перевести в состав';

  @override
  String editorPromoted(String name) {
    return '$name переведён в состав';
  }

  @override
  String get editorPromoteFullTitle => 'Состав заполнен';

  @override
  String editorPromoteFullBody(int max) {
    return 'В составе не больше $max игроков. Выбери, кто вернётся в пул вместо него.';
  }

  @override
  String get editorTrophyGallery => 'Выбрать из фото';

  @override
  String get editorTrophyFile => 'Выбрать файл';

  @override
  String clubStrengthOf(int stars) {
    return 'Сила клуба: $stars из 5';
  }

  @override
  String get editorClubStrength => 'Сила';

  @override
  String get editorClubStrengthDefault => 'По умолчанию';

  @override
  String editorClubStrengthHelp(int stars) {
    return 'Лучшие игроки переходят в более сильные клубы. По умолчанию: $stars из 5, по уровню лиги.';
  }

  @override
  String mgrNewsSacked(String nation, String name) {
    return '$nation увольняет тренера: $name';
  }

  @override
  String mgrNewsResigned(String nation, String name) {
    return '$nation: $name уходит в отставку';
  }

  @override
  String mgrNewsPoached(String nation, String name) {
    return '$nation: $name уходит в другую сборную';
  }

  @override
  String mgrNewsRetired(String nation, String name) {
    return '$nation: $name завершает тренерскую карьеру';
  }

  @override
  String mgrNewsContractEnd(String nation, String name) {
    return '$nation: $name уходит по истечении контракта';
  }

  @override
  String mgrNewsReplacedByPlayer(String nation, String name) {
    return '$nation: $name уступает место тебе';
  }

  @override
  String mgrNewsAppointed(String nation, String name) {
    return '$nation назначает тренера: $name';
  }

  @override
  String mgrNewsAppointedBody(String nation, String name) {
    return '$name возглавляет сборную: $nation.';
  }

  @override
  String pressBeatOpposingManager(String manager) {
    return 'У вас с тренером $manager есть история. Что скажете о нём?';
  }

  @override
  String get pressAnswerHitBackAtManager =>
      'Пусть лучше беспокоится о своей команде.';

  @override
  String get pressAnswerRespectManager => 'Я очень его уважаю.';

  @override
  String yMgrTie1(String manager) {
    return 'Дальше $manager на соседней скамейке. У него история с нашим тренером, жду не дождусь.';
  }

  @override
  String yMgrTie2(String manager) {
    return 'Следующий: $manager на другой скамейке. Он и наш тренер давно знакомы.';
  }

  @override
  String yMgrTie3(String manager) {
    return 'Опять $manager. Лишь бы наш тренер не превратил это в личное.';
  }

  @override
  String yMgrTie4(String manager) {
    return 'Ну вот. $manager у бровки, а наш тренер пытается выиграть вражду вместо матча.';
  }

  @override
  String get mgrRowLabel => 'Тренер';

  @override
  String mgrRowDetail(int age, String date) {
    return '$age лет, с $date';
  }

  @override
  String mgrRecordWdl(int won, int drawn, int lost) {
    return '$won В, $drawn Н, $lost П';
  }

  @override
  String mgrRowRecord(String record) {
    return 'На посту: $record';
  }

  @override
  String get mgrTieNeutral => 'Без истории';

  @override
  String get mgrTieRespect => 'Уважение';

  @override
  String get mgrTieRival => 'Соперник';

  @override
  String get mgrTieGrudge => 'Вражда';

  @override
  String get mgrTieSuccessor => 'Преемник';

  @override
  String get mgrTieProtege => 'Протеже';

  @override
  String get mgrTieFormerPlayer => 'Бывший игрок';

  @override
  String get mgrEndSacked => 'Уволен';

  @override
  String get mgrEndResigned => 'Ушёл в отставку';

  @override
  String get mgrEndPoached => 'Ушёл в другую сборную';

  @override
  String get mgrEndRetired => 'Завершил тренерскую карьеру';

  @override
  String get mgrEndContractEnd => 'Истёк контракт';

  @override
  String get mgrEndReplacedByPlayer => 'Заменён тобой';

  @override
  String get mgrProfileSpells => 'Карьера';

  @override
  String mgrProfileSpellNow(String nation, String from) {
    return '$nation, с $from';
  }

  @override
  String mgrProfileSpellRange(String nation, String from, String to) {
    return '$nation, $from–$to';
  }

  @override
  String mgrProfileSpellEnded(String range, String reason) {
    return '$range, $reason';
  }

  @override
  String get mgrProfileRecordVsYou => 'Его статистика против тебя';

  @override
  String get mgrProfileNoMeetings => 'Вы не встречались';

  @override
  String get mgrProfileReputation => 'Репутация';

  @override
  String get mgrProfileAge => 'Возраст';

  @override
  String get mgrProfileAppointed => 'Назначен';

  @override
  String get mgrProfileStyle => 'Стиль';

  @override
  String get mgrProfileTie => 'Между вами';

  @override
  String mgrPreviewLine(String name) {
    return 'Их тренер: $name';
  }

  @override
  String mgrDossierStyle(String style) {
    return 'Стиль тренера: $style';
  }

  @override
  String mgrDossierRecord(String record) {
    return 'Твоя статистика против него: $record';
  }

  @override
  String get mgrStylePossession => 'Владение';

  @override
  String get mgrStyleHighPress => 'Высокий прессинг';

  @override
  String get mgrStyleDefensive => 'Оборона';

  @override
  String get mgrStyleDirect => 'Прямой';

  @override
  String get mgrStyleCounter => 'Контратаки';

  @override
  String get mgrStyleFlair => 'Импровизация';

  @override
  String get mgrStylePhysical => 'Физика';

  @override
  String get mgrStyleBalanced => 'Баланс';

  @override
  String get mgrListTitle => 'Тренеры';

  @override
  String get mgrListCurrent => 'Действующие';

  @override
  String get mgrListRecentMoves => 'Недавние переходы';

  @override
  String get mgrListFilterAll => 'Все';

  @override
  String get mgrListSortReputation => 'Репутация';

  @override
  String get mgrListSortName => 'Имя';

  @override
  String get mgrListEmptyMoves => 'За последние два года изменений нет.';

  @override
  String get mgrListEmptyCurrent =>
      'Тренеры появятся после следующей смены сезона.';

  @override
  String get editorSectionManagers => 'Тренеры';

  @override
  String get editorAboutManagers =>
      'Кто руководит каждой сборной в первый день';

  @override
  String get editorManagersHint => 'Выбирается при старте карьеры';

  @override
  String get editorManagerName => 'Имя тренера';

  @override
  String get editorManagerNationality => 'Гражданство';

  @override
  String editorIssueManagerName(int max) {
    return 'Тренеру нужно имя от 1 до $max символов, которые игра может показать';
  }

  @override
  String get editorIssueManagerNationality =>
      'Выбери гражданство тренера из списка';

  @override
  String get shareButton => 'Поделиться';

  @override
  String get shareSheetTitle => 'Поделиться изображением';

  @override
  String get shareFormatSquare => 'Квадрат';

  @override
  String get shareFormatStory => 'История';

  @override
  String get shareFailed => 'Не удалось создать изображение.';

  @override
  String get shareSaveToPhotos => 'Сохранить в фото';

  @override
  String get shareSavedToPhotos => 'Сохранено в фото';

  @override
  String get sharePhotosDenied =>
      'FNM не может добавлять в твои фото. Разрешить это можно в настройках.';

  @override
  String get editorCountryAll => 'Все страны';

  @override
  String get editorCountryFilterTitle => 'Фильтр по стране';

  @override
  String get shareCabinetBig => 'Поделиться трофеями';

  @override
  String yExitProud0(String competition) {
    return 'Неожиданный путь на турнире ($competition) и отличный результат в итоге. Горжусь парнями.';
  }

  @override
  String yExitProud1(String competition) {
    return 'Нам не давали шансов ($competition). Мы прошли дальше, чем кто-либо смел мечтать. Спасибо, парни.';
  }

  @override
  String yExitProud2(String competition) {
    return 'Вылетели ($competition), но какое было путешествие. Эта команда заставила всю страну поверить. Горжусь.';
  }

  @override
  String yExitProud3(String competition) {
    return 'Не ждал, что мы выйдем из группы ($competition). Всё остальное было бонусом. Только вперёд.';
  }

  @override
  String yExitProud4(String competition) {
    return 'Мы ехали на турнир ($competition) за очком-другим, а вернулись с плей-офф. Хороший турнир.';
  }

  @override
  String yExitProud5(String competition) {
    return 'Дальше, чем обещали прогнозы ($competition). Это шаг вперёд, проще некуда.';
  }

  @override
  String yExitProud6(String competition) {
    return 'Вылетели ($competition), и немного обидно. Но честно: никто не думал, что мы зайдём так далеко.';
  }

  @override
  String yExitProud7(String competition) {
    return 'Ладно, мы вылетели ($competition). Всё равно больше, чем за много лет. Принимаю.';
  }

  @override
  String yExitProud8(String competition) {
    return 'Трофея ($competition) нет, и не было бы. Хороший путь есть хороший путь. Теперь повторить.';
  }

  @override
  String get yReactionPride0 => 'Горжусь каждым из них.';

  @override
  String get yReactionPride1 => 'Какой путь. Спасибо, парни.';

  @override
  String get yReactionPride2 => 'Никто такого не ждал. Запомните это.';

  @override
  String get yReactionPride3 => 'Только вперёд.';

  @override
  String get yReactionPride4 => 'Всё это бонус. Наслаждайтесь.';

  @override
  String get yReactionPride5 =>
      'Лучше, чем кто-либо предсказывал. Хороший турнир.';

  @override
  String get yReactionPride6 => 'Вылетели, но не опозорились. Справедливо.';

  @override
  String get yReactionPride7 =>
      'Прошла сильнейшая команда. Мы всё равно не подвели.';

  @override
  String get yReactionPride8 => 'Не будем увлекаться. Но да, хороший путь.';

  @override
  String yExitAccepted0(String competition) {
    return 'Вылетели ($competition) примерно там, где и должны были. Горжусь, что попробовали.';
  }

  @override
  String yExitAccepted1(String competition) {
    return '$competition для нас окончен. Мы дали бой большим командам. Выше голову, парни.';
  }

  @override
  String yExitAccepted2(String competition) {
    return 'Вылетели ($competition). На бумаге это всегда был самый вероятный финал. Сделать выводы и снова в бой.';
  }

  @override
  String yExitAccepted3(String competition) {
    return 'Наш турнир ($competition) закончился там, где и говорил рейтинг. Стыдиться нечего.';
  }

  @override
  String yExitAccepted4(String competition) {
    return 'Вылетели ($competition), как большинство из нас и ожидало. Не катастрофа, но и не сенсация.';
  }

  @override
  String yExitAccepted5(String competition) {
    return '$competition оказался для этого состава шагом слишком далеко. Разрыв реален. Пора его сокращать.';
  }

  @override
  String get yReactionAcceptance0 => 'Отдали всё. Большего и не попросишь.';

  @override
  String get yReactionAcceptance1 => 'Выше голову. Мы вернёмся.';

  @override
  String get yReactionAcceptance2 => 'Больно, но они нас не опозорили.';

  @override
  String get yReactionAcceptance3 => 'Примерно как и ожидали, честно.';

  @override
  String get yReactionAcceptance4 => 'Прошли сильнейшие. Это футбол.';

  @override
  String get yReactionAcceptance5 => 'Разочарован, но не зол.';

  @override
  String get yReactionAcceptance6 =>
      'Скучновато, если честно. Но без сюрпризов.';

  @override
  String get yReactionAcceptance7 => 'Мы ещё не на том уровне. Все это знают.';

  @override
  String get yReactionAcceptance8 =>
      'Тот же уровень, что и в прошлый раз. В следующем цикле нужен шаг вперёд.';

  @override
  String get sponsorIndustryExtraSportswear => 'Спортивная одежда';

  @override
  String get sponsorIndustryExtraAirline => 'Авиакомпания';

  @override
  String get sponsorIndustryExtraRailway => 'Железная дорога';

  @override
  String get sponsorIndustryExtraHotels => 'Сеть отелей';

  @override
  String get sponsorIndustryExtraCoffee => 'Сеть кофеен';

  @override
  String get sponsorIndustryExtraChocolate => 'Шоколад';

  @override
  String get sponsorIndustryExtraMineralWater => 'Минеральная вода';

  @override
  String get sponsorIndustryExtraPharmacy => 'Сеть аптек';

  @override
  String get sponsorIndustryExtraFashion => 'Мода';

  @override
  String get sponsorIndustryExtraWatches => 'Часы';

  @override
  String get sponsorIndustryExtraElectronics => 'Электроника';

  @override
  String get sponsorIndustryExtraSoftware => 'Программное обеспечение';

  @override
  String get sponsorIndustryExtraStreaming => 'Стриминговый сервис';

  @override
  String get sponsorIndustryExtraSocialNetwork => 'Соцсеть';

  @override
  String get sponsorIndustryExtraFurniture => 'Мебель';

  @override
  String get sponsorIndustryExtraTyres => 'Шины';

  @override
  String get sponsorIndustryExtraShipping => 'Судоходная компания';

  @override
  String get sponsorIndustryExtraLottery => 'Лотерея';

  @override
  String get sponsorIndustryExtraTourism => 'Туристическое агентство';

  @override
  String get sponsorIndustryExtraCosmetics => 'Косметика';

  @override
  String get sponsorIndustryExtraPetFood => 'Корм для животных';

  @override
  String get sponsorIndustryExtraBakery => 'Пекарня';

  @override
  String get sponsorIndustryExtraSupermarket => 'Супермаркет';

  @override
  String get sponsorIndustryExtraSportsNutrition => 'Спортивное питание';

  @override
  String get sponsorIndustryExtraWine => 'Вино';

  @override
  String get sponsorIndustryExtraTea => 'Чай';

  @override
  String get sponsorIndustryExtraRealEstate => 'Недвижимость';

  @override
  String get sponsorIndustryExtraFitness => 'Фитнес-клубы';

  @override
  String get sponsorIndustryExtraNewspaper => 'Газета';

  @override
  String mgrDetailCurrentJob(String nation) {
    return 'Текущая работа: $nation';
  }

  @override
  String get mgrDetailFree => 'Без работы';

  @override
  String get mgrDetailMatches => 'Матчи';

  @override
  String get mgrDetailTrophies => 'Трофеи';

  @override
  String get mgrDetailWinRate => 'Процент побед';

  @override
  String get mgrDetailRecord => 'Статистика';

  @override
  String get mgrDetailNationsLed => 'Сборные';

  @override
  String get mgrDetailInCharge => 'На посту';

  @override
  String get mgrDetailNoSpells => 'Работы в сборных пока не было.';

  @override
  String get mgrDetailNotFound => 'Тренер не найден.';

  @override
  String get mgrDetailBackground => 'Происхождение';

  @override
  String get mgrOriginFresh => 'Профессиональный тренер';

  @override
  String get mgrOriginExAssistant => 'Бывший ассистент тренера';

  @override
  String mgrNewsSeeManager(String name) {
    return 'Профиль: $name';
  }

  @override
  String get mgrChangesTitle => 'Смены тренеров';

  @override
  String mgrChangesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count смены',
      many: '$count смен',
      few: '$count смены',
      one: '$count смена',
    );
    return '$_temp0';
  }

  @override
  String mgrChangesLeftFor(String nation) {
    return 'Ушёл в: $nation';
  }

  @override
  String get mgrChangesAppointed => 'Назначен';

  @override
  String get mgrChangesVacant => 'Вакансия';

  @override
  String get editorNameNotAllowed => 'Это имя недопустимо.';

  @override
  String editorIssueNameNotAllowed(String name) {
    return '«$name» недопустимо';
  }

  @override
  String get matchWeatherPlaysHeavyRain =>
      'Ливень: удары и навесы менее точны, больше подскальзываний';

  @override
  String get matchWeatherPlaysStorm =>
      'Гроза: удары и навесы менее точны, больше подскальзываний';

  @override
  String get matchWeatherPlaysSnow =>
      'Снег: игра медленнее, пасовать чуть труднее';

  @override
  String get matchWeatherPlaysFrost =>
      'Замёрзшее поле: игра медленнее, пасовать чуть труднее';

  @override
  String get matchWeatherPlaysGale =>
      'Сильный ветер: длинные передачи и навесы непредсказуемы, дальние удары труднее';

  @override
  String get matchWeatherPlaysFog => 'Туман: дальние удары труднее';

  @override
  String get matchWeatherPlaysHaze =>
      'Знойная дымка: жарче обычного, ноги сядут раньше';

  @override
  String get pitchComKickOffHeavyRain =>
      'Начали под проливным дождём. Мяч будет скользить по газону.';

  @override
  String get pitchComKickOffStorm =>
      'Начало матча в грозу. Под ногами будет коварно.';

  @override
  String get pitchComKickOffSnow =>
      'Начали под снегом. Это будет медленная, осторожная игра.';

  @override
  String get pitchComKickOffFrost =>
      'Морозная ночь и жёсткое поле. Пасовать будет непросто.';

  @override
  String get pitchComKickOffFrostDay =>
      'Низкое зимнее солнце и жёсткое замёрзшее поле. Мяч будет скользить.';

  @override
  String get pitchComKickOffGale =>
      'Начало при сильном ветре. Длинные передачи будут уходить не туда.';

  @override
  String get pitchComKickOffFog =>
      'Начало в густом тумане. Издалека сегодня забить будет непросто.';

  @override
  String get pitchComKickOffHaze =>
      'Начало в знойной дымке. Ноги сегодня устанут рано.';

  @override
  String get matchOwnGoal => 'АВТОГОЛ';

  @override
  String get matchGoalOwnGoal => 'АГ';

  @override
  String get matchGoalVarOffside => 'VAR: офсайд';

  @override
  String get matchGoalVarFoul => 'VAR: фол';

  @override
  String pitchComOwnGoal1(String defender) {
    return 'Автогол! $defender отправляет мяч в свои ворота.';
  }

  @override
  String pitchComOwnGoal2(String defender, String shooter) {
    return 'Удар игрока $shooter рикошетит от игрока $defender и залетает в ворота.';
  }

  @override
  String pitchComOwnGoal3(String defender) {
    return 'Катастрофа для игрока $defender: он переигрывает собственного вратаря.';
  }

  @override
  String pitchComBigSave1(String keeper, String player) {
    return 'Какой сейв! $keeper спасает в упор от удара игрока $player.';
  }

  @override
  String pitchComBigSave2(String keeper) {
    return 'Блестящее спасение: $keeper!';
  }

  @override
  String pitchComBigSave3(String keeper, String player) {
    return 'Казалось, $player точно забьёт, но $keeper каким-то чудом отбивает.';
  }

  @override
  String matchTimelineWoodwork(String name) {
    return '$name попал в каркас ворот';
  }

  @override
  String matchTimelineBigSave(String name) {
    return 'Отличный сейв: $name';
  }

  @override
  String get matchChartXg => 'xG по ходу матча';

  @override
  String get matchChartMomentum => 'Кто доминировал';

  @override
  String get editorDemoteTooltip => 'Перевести в пул';

  @override
  String editorDemoted(String name) {
    return '$name переведён в пул';
  }

  @override
  String get profileTabOverview => 'Обзор';

  @override
  String get profileTabStats => 'Статистика';

  @override
  String get profileTabCareer => 'Карьера';

  @override
  String get profileTabVsYou => 'Против тебя';

  @override
  String get playerStatFitness => 'Здоровье';

  @override
  String get settingsAboutProtected =>
      'Игра, её код и содержимое защищены авторским правом.';

  @override
  String get matchTabSummary => 'ИТОГИ';

  @override
  String get matchSummaryOtherMatches => 'Другие матчи';

  @override
  String get matchSummaryLive => 'LIVE';

  @override
  String get matchSummaryHalfTimeMark => '1Т';

  @override
  String get matchSummaryFullTimeMark => 'ФИН';

  @override
  String get matchSummaryExtraTimeMark => 'ДВ';

  @override
  String get matchStatMinutes => 'Минуты';

  @override
  String get matchStatSaves => 'Сейвы';

  @override
  String editorWebTitle(String address) {
    return 'Редактировать на компьютере: $address';
  }

  @override
  String get editorWebAbout =>
      'Экспортируй базу, открой её в браузере, скачай обратно и импортируй сюда.';

  @override
  String get editorWebAnother => 'Другой вариант';

  @override
  String get editorMerge => 'Объединить с другой базой';

  @override
  String get editorMergeAbout =>
      'Перенести сюда то, что кто-то изменил в своей копии.';

  @override
  String get editorHistory => 'История';

  @override
  String get editorHistoryAbout =>
      'Сохранённые версии этой базы. Можно вернуться к любой.';

  @override
  String get editorMergeFromTitle => 'Объединить из';

  @override
  String get editorMergeFromFile => 'Файл базы данных';

  @override
  String get editorMergeFromFileAbout =>
      'Выбери файл .fnmdb, которым с тобой поделились.';

  @override
  String get editorMergeFromDevice => 'С этого устройства';

  @override
  String get editorMergeComparing => 'Сравниваем базы';

  @override
  String get editorMergeNothing =>
      'Объединять нечего. В твоей базе уже есть все изменения из той.';

  @override
  String get editorMergeFailed => 'Не удалось объединить базы.';

  @override
  String editorMergeReviewTitle(String name) {
    return 'Изменения из «$name»';
  }

  @override
  String editorMergeFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count изменения на проверку',
      many: '$count изменений на проверку',
      few: '$count изменения на проверку',
      one: '$count изменение на проверку',
    );
    return '$_temp0';
  }

  @override
  String editorMergeConflicts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count конфликта',
      many: '$count конфликтов',
      few: '$count конфликта',
      one: '$count конфликт',
      zero: 'Конфликтов нет',
    );
    return '$_temp0';
  }

  @override
  String get editorMergeConflictsOnly => 'Только конфликты';

  @override
  String get editorMergeNoConflicts =>
      'Конфликтов нет. Все изменения новые для твоей базы.';

  @override
  String get editorMergeAll => 'Все';

  @override
  String get editorMergeNone => 'Ничего';

  @override
  String editorMergeTake(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Взять $count изменения',
      many: 'Взять $count изменений',
      few: 'Взять $count изменения',
      one: 'Взять $count изменение',
      zero: 'Не брать изменений',
    );
    return '$_temp0';
  }

  @override
  String get editorMergeApply => 'Применить';

  @override
  String get editorMergeYours => 'Твоё';

  @override
  String get editorMergeTheirs => 'Их';

  @override
  String get editorMergeNew => 'Новое';

  @override
  String get editorMergeConflict => 'Конфликт';

  @override
  String get editorMergeGameValue => 'Как в игре';

  @override
  String get editorMergeNotHere => 'Нет в этой базе';

  @override
  String editorMergeSquadOf(String nation) {
    return 'Состав: $nation';
  }

  @override
  String editorMergePoolOf(String nation) {
    return 'Пул: $nation';
  }

  @override
  String get editorMergePlace => 'Переходы';

  @override
  String editorMergeNames(int first, int sur) {
    return 'Имён: $first, фамилий: $sur';
  }

  @override
  String editorMerged(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Объединено $count изменения',
      many: 'Объединено $count изменений',
      few: 'Объединено $count изменения',
      one: 'Объединено $count изменение',
    );
    return '$_temp0';
  }

  @override
  String get editorMergeTabOverview => 'Обзор';

  @override
  String get editorMergeTabNames => 'Названия';

  @override
  String get editorMergeTabPress => 'Пресса и Y';

  @override
  String get editorMergeEveryChange => 'Все изменения';

  @override
  String editorMergeNewCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count нового',
      many: '$count новых',
      few: '$count новых',
      one: '$count новое',
      zero: 'Ничего нового',
    );
    return '$_temp0';
  }

  @override
  String get editorHistorySave => 'Сохранить версию';

  @override
  String get editorHistorySaveTitle => 'Сохранить эту версию';

  @override
  String get editorHistoryNameHint => 'Название (необязательно)';

  @override
  String get editorHistorySaved => 'Версия сохранена';

  @override
  String get editorHistoryEmpty =>
      'Сохранённых версий пока нет. Версия сохраняется перед каждым объединением и восстановлением, а также когда ты возвращаешься к базе после перерыва.';

  @override
  String get editorHistoryKeep =>
      'Хранятся последние 30 автоматических версий. Сохранённые тобой остаются, пока ты их не удалишь.';

  @override
  String get editorHistorySession => 'Когда началось редактирование';

  @override
  String editorHistoryBeforeMerge(String name) {
    return 'Перед объединением с «$name»';
  }

  @override
  String get editorHistoryBeforeRestore => 'Перед восстановлением';

  @override
  String get editorHistoryManual => 'Сохранённая версия';

  @override
  String get editorHistoryAuto => 'Автоматически';

  @override
  String editorHistoryDiff(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count отличия от текущей',
      many: '$count отличий от текущей',
      few: '$count отличия от текущей',
      one: '$count отличие от текущей',
      zero: 'Как сейчас',
    );
    return '$_temp0';
  }

  @override
  String get editorHistoryRestore => 'Восстановить';

  @override
  String get editorHistoryRestoreTitle => 'Восстановить эту версию?';

  @override
  String get editorHistoryRestoreBody =>
      'База вернётся к этой версии. Её текущее состояние сначала сохранится в истории.';

  @override
  String get editorHistoryRestored => 'Версия восстановлена';

  @override
  String get editorHistoryFailed => 'Не получилось. Попробуй ещё раз.';

  @override
  String get editorHistoryRenameTitle => 'Переименовать версию';

  @override
  String get editorHistoryDeleteTitle => 'Удалить эту версию?';

  @override
  String get editorHistoryDeleteBody =>
      'Она будет удалена из истории. Сама база не изменится.';

  @override
  String get financesTabDepartments => 'Отделы';

  @override
  String get financesTabFacilities => 'Инфраструктура';

  @override
  String get financesInvestedSoFar => 'Вложено на данный момент';

  @override
  String get tacticsQuickBest => 'Лучшие';

  @override
  String get tacticsQuickPrevious => 'Прошлый';

  @override
  String get assistantAskShort => 'Ассистент';

  @override
  String get editorRankingTitle => 'Мировой рейтинг';

  @override
  String editorRankingPlace(int rank) {
    return '#$rank';
  }

  @override
  String get editorRankingAuto => 'Автоматически';

  @override
  String editorRankingAutoPlace(int rank) {
    return 'Автоматически (#$rank)';
  }

  @override
  String get editorRankingAbout =>
      'С какого места мирового рейтинга эта сборная начинает новую карьеру. «Автоматически» зависит от силы состава.';

  @override
  String editorRankingHint(int min, int max) {
    return 'От $min до $max';
  }

  @override
  String editorRankingOf(String nation) {
    return '$nation: мировой рейтинг';
  }

  @override
  String editorIssueRanking(int min, int max) {
    return 'Укажи место в мировом рейтинге от $min до $max.';
  }

  @override
  String get editorRegionWorldwide => 'Весь мир';

  @override
  String get editorRegionNone => 'Для этого региона здесь ничего нет.';

  @override
  String get nationTabResults => 'Результаты';

  @override
  String get nationTabHistory => 'История';

  @override
  String get nationTabStadiums => 'Стадионы';

  @override
  String get nationStatRanking => 'Рейтинг';

  @override
  String get nationStatOverall => 'Сила';

  @override
  String get nationFactsTitle => 'Факты';

  @override
  String get nationFactAgainstYou => 'Твоя статистика против них (В-Н-П)';

  @override
  String nationFactBiggestWin(String opponent, String year) {
    return 'Крупнейшая победа ($opponent, $year)';
  }

  @override
  String get nationFactHomeUnbeaten => 'Домашних матчей подряд без поражений';

  @override
  String nationFactTitleDrought(String year) {
    return 'Лет без титула (последний в $year)';
  }

  @override
  String get nationFactNoTitles => 'Всё ещё ждут первого титула';

  @override
  String nationFactRecordScorer(String name) {
    return 'Голы рекордсмена: $name';
  }

  @override
  String nationFactRankClimb(int rank, String year) {
    return 'Мест подъёма за цикл, до #$rank в $year';
  }

  @override
  String nationFactWorldFinals(String year) {
    return 'Финальных турниров чемпионата мира с $year';
  }

  @override
  String nationBestRankYear(int rank, String year) {
    return 'Лучшее: #$rank ($year)';
  }

  @override
  String get nationLikelyEleven => 'Вероятный состав';

  @override
  String get nationBestYoung => 'Лучшие до 21 года';

  @override
  String get nationWhereTheyPlay => 'Где они играют';

  @override
  String get nationOtherCountries => 'Другие страны';

  @override
  String get nationBiggestWinYou => 'Твоя крупнейшая победа';

  @override
  String nationAllMeetings(int count) {
    return 'Все встречи ($count)';
  }

  @override
  String get nationUpcoming => 'Впереди';

  @override
  String get nationLastResults => 'Последние результаты';

  @override
  String nationAllMatches(int count) {
    return 'Все матчи ($count)';
  }

  @override
  String get nationShowMore => 'Показать ещё';

  @override
  String get nationHostingRecord => 'История проведения';

  @override
  String get nationNeverHosted => 'Ещё не принимала финальный турнир';

  @override
  String get nationHostChampions => 'Чемпионы';

  @override
  String get nationHostRunnersUp => 'Финалисты';

  @override
  String get nationHostThird => 'Третьи';

  @override
  String get nationCoHosts => 'Сохозяева';

  @override
  String get nationNoStadiums => 'Стадионы не указаны';

  @override
  String get nationManageStadiums => 'Управление стадионами';

  @override
  String get scheduleHome => 'Дома';

  @override
  String get scheduleAway => 'В гостях';

  @override
  String scheduleGroupTag(String name) {
    return 'Группа $name';
  }

  @override
  String get scheduleFilterMine => 'Мои';

  @override
  String get scheduleFilterCompetitions => 'Турниры';

  @override
  String get scheduleFilterDraws => 'Жеребьёвки';

  @override
  String scheduleDrawOf(String competition) {
    return 'Жеребьёвка: $competition';
  }

  @override
  String get scheduleDrawCeremony => 'Церемония жеребьёвки';

  @override
  String get scheduleNoDraws => 'Жеребьёвок впереди нет';

  @override
  String hubCallUpClosesIn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Вызов закрывается через $count дня',
      many: 'Вызов закрывается через $count дней',
      few: 'Вызов закрывается через $count дня',
      one: 'Вызов закрывается через $count день',
      zero: 'Вызов закрывается сегодня',
    );
    return '$_temp0';
  }

  @override
  String hubNextWindowLabel(String month, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ещё $count матча',
      many: 'ещё $count матчей',
      few: 'ещё $count матча',
      one: 'ещё $count матч',
    );
    return '$month: $_temp0';
  }

  @override
  String get careerManagerAge => 'Возраст';

  @override
  String managerAgeRange(int min, int max) {
    return 'От $min до $max';
  }

  @override
  String managerNameAge(String name, int age) {
    return '$name ($age)';
  }

  @override
  String get managerSuccession =>
      'Руководство спрашивает о планах на преемника.';

  @override
  String get managerAgePromptTitle => 'Сколько лет твоему тренеру?';

  @override
  String get managerAgePromptBody =>
      'В этом сохранении у тренера ещё нет возраста. Укажи его один раз, и он будет показываться рядом с именем. На игру это не влияет.';

  @override
  String get managerAgePromptSet => 'Указать возраст';

  @override
  String get managerAgePromptSkip => 'Пропустить';

  @override
  String mgrNewsRetiredAge(String nation, String name, int age) {
    return '$nation: $name ($age) завершает тренерскую карьеру';
  }

  @override
  String get editorManagerAge => 'Возраст';

  @override
  String get editorManagerAgeHint => 'Пусто: выберет игра';

  @override
  String editorIssueManagerAge(int min, int max) {
    return 'Возраст тренера должен быть от $min до $max.';
  }

  @override
  String pressFloor(int index, int total) {
    return 'ВАШЕ СЛОВО · $index/$total';
  }

  @override
  String pressTickerStanding(String code, int points, String place) {
    String _temp0 = intl.Intl.pluralLogic(
      points,
      locale: localeName,
      other: '$points ОЧКА',
      many: '$points ОЧКОВ',
      few: '$points ОЧКА',
      one: '$points ОЧКО',
    );
    return '$code $_temp0 · $place';
  }

  @override
  String get pressAfterTitle => 'ПОСЛЕ ПРЕСС-КОНФЕРЕНЦИИ';

  @override
  String get pressTileMorale => 'Мораль';

  @override
  String get pressTilePress => 'Пресса';

  @override
  String get pressPromiseHeading => 'ТЫ ПООБЕЩАЛ';

  @override
  String get pressPromiseWinNext => 'Победу в следующем матче.';

  @override
  String get pressPromiseJob => 'Свою работу на следующие три матча.';

  @override
  String get pressPromiseJudgedCampaign =>
      'Руководство оценит это, когда цикл решится.';

  @override
  String get pressPromiseJudgedMatch =>
      'Оценка по результату следующего матча.';

  @override
  String get hubEventWatchEuroPlayoffDraw => 'Смотреть жеребьёвку плей-офф';

  @override
  String get hubEventWatchEuroPlayoffs => 'Смотреть плей-офф';

  @override
  String get hubCallUpPlayoffs => 'Вызов на плей-офф';

  @override
  String compPlayoffs(String competition) {
    return '$competition: плей-офф';
  }

  @override
  String newsEuroPlayoffPathTitle(String cup, String path) {
    return '$cup, плей-офф: путь $path';
  }

  @override
  String newsEuroPlayoffPathBodyHome(String opponent) {
    return 'Полуфинал в один матч дома против соперника $opponent в марте, затем финал в одну игру за место в финальном турнире.';
  }

  @override
  String newsEuroPlayoffPathBodyAway(String opponent) {
    return 'Полуфинал в один матч в гостях у соперника $opponent в марте, затем финал в одну игру за место в финальном турнире.';
  }

  @override
  String get euroPlayoffDrawTitle => 'ЖЕРЕБЬЁВКА ПЛЕЙ-ОФФ';

  @override
  String get euroPlayoffIntro =>
      'Две лучшие команды каждой отборочной группы проходят. Последние места разыгрываются в путях плей-офф из четырёх команд, по одному на каждую лигу Кубка наций: полуфиналы в один матч на поле сеяной команды в марте, затем финал в одну игру.';

  @override
  String euroPlayoffPath(String path) {
    return 'Путь $path';
  }

  @override
  String get euroPlayoffYourPath => 'Твой путь';

  @override
  String euroPlayoffSemi(int number) {
    return 'Полуфинал $number';
  }

  @override
  String euroPlayoffFinalHost(int number) {
    return 'Финал, хозяин – победитель полуфинала $number';
  }

  @override
  String euroPlayoffFinalPending(int first, int second) {
    return 'Победитель полуфинала $first – победитель полуфинала $second';
  }

  @override
  String euroPlayoffWinnerToGroup(String group) {
    return 'Победитель попадает в группу $group';
  }

  @override
  String euroPlayoffWinnerPlaceholder(String path) {
    return 'Победитель пути $path';
  }

  @override
  String euroPlayoffYourGroupIfWin(String path, String group) {
    return 'Твоя группа, если выиграешь путь $path: группа $group';
  }

  @override
  String get euroPlayoffBracketHeading => 'ПЛЕЙ-ОФФ';

  @override
  String get wcPlayoffIntro =>
      'Двенадцать победителей групп проходят. Последние места Европы разыгрываются в путях плей-офф из четырёх команд: лучшие вторые места и лучшие победители групп Кубка наций из оставшихся, полуфиналы в один матч на поле сеяной команды в марте, затем финал в одну игру.';

  @override
  String get icPlayoffIntro =>
      'Шесть команд из пяти конфедераций за две последние путёвки. Две лучшие по рейтингу ждут в финалах путей, остальные четыре играют полуфиналы, и все матчи проходят в стране-хозяйке в марте.';

  @override
  String get icPlayoffSeeded => 'Сразу в финал пути';

  @override
  String icPlayoffFinalPending(String nation) {
    return '$nation – победитель полуфинала';
  }

  @override
  String wcPlaceholderUefa(String path) {
    return 'Победитель европейского пути $path';
  }

  @override
  String wcPlaceholderIc(String path) {
    return 'Победитель межконтинентального пути $path';
  }

  @override
  String newsIcPlayoffTitle(String path) {
    return 'Межконтинентальный плей-офф: путь $path';
  }

  @override
  String newsIcPlayoffBodySemi(String opponent) {
    return 'Полуфинал в один матч против соперника $opponent в марте, в стране-хозяйке, затем финал пути за место в финальном турнире.';
  }

  @override
  String newsIcPlayoffBodyBye(String first, String second) {
    return 'Сразу в финал пути в марте, в стране-хозяйке, против победителя пары $first – $second.';
  }

  @override
  String newsCafPlayoffTitle(String opponent) {
    return 'Африканский плей-офф: полуфинал против соперника $opponent';
  }

  @override
  String get newsCafPlayoffBody =>
      'Четыре лучшие команды Африки со вторых мест встречаются в ноябре у хозяина чемпионата Африки: полуфинал в один матч, затем финал. Победитель выходит в межконтинентальный плей-офф.';

  @override
  String newsAfcFourthRoundTitle(String group) {
    return 'Азиатский четвёртый раунд: группа $group';
  }

  @override
  String newsAfcFourthRoundBody(String first, String second) {
    return 'Один круг матчей в ноябре против соперников $first и $second. Победитель группы проходит; второе место играет пятый раунд из двух матчей за место в межконтинентальном плей-офф.';
  }

  @override
  String newsAfcFifthRoundTitle(String opponent) {
    return 'Азиатский пятый раунд: $opponent, два матча';
  }

  @override
  String get newsAfcFifthRoundBody =>
      'Дома и в гостях в ноябре. Победитель по сумме двух матчей выходит в межконтинентальный плей-офф; при равенстве после второго матча будут дополнительное время и пенальти.';

  @override
  String newsOfcFinalTitle(String opponent) {
    return 'Финал Океании: $opponent';
  }

  @override
  String get newsOfcFinalBody =>
      'Один матч в ноябре у хозяина Кубка Океании за место Океании в финальном турнире. Проигравший выходит в межконтинентальный плей-офф.';

  @override
  String get matchTinyFirstLeg => '1-й матч';

  @override
  String get matchTinySecondLeg => 'ответный';

  @override
  String get matchTinyFourthRound => '4-й р.';

  @override
  String get resultsStageFourthRound => 'Четвёртый раунд';

  @override
  String get resultsStageFifthRound => 'Пятый раунд';

  @override
  String newsNcPromotedTitle(String league) {
    return 'Повышение в лигу $league';
  }

  @override
  String newsNcPromotedBody(String cup) {
    return 'Первое место в группе ($cup): следующий розыгрыш пройдёт лигой выше, а повышение приносит федерации 1 млн €, выплата в конце цикла.';
  }

  @override
  String newsNcRelegatedTitle(String league) {
    return 'Понижение в лигу $league';
  }

  @override
  String newsNcRelegatedBody(String cup) {
    return 'Последнее место в группе ($cup): следующий розыгрыш пройдёт лигой ниже.';
  }

  @override
  String stadiumsBuildFrom(String cost) {
    return 'Построить: от $cost';
  }

  @override
  String stadiumsConfirmBuildSized(String seats, String city, String cost) {
    return 'Построить стадион на $seats мест в городе $city за $cost?';
  }

  @override
  String stadiumsCapacityRange(String min, String max) {
    return 'Вместимость: на выбор, от $min до $max мест';
  }

  @override
  String get hubAssistantFriendly => 'Доверить ассистенту';

  @override
  String pitchComHandballPenalty1(String player) {
    return 'Игра рукой! $player играет рукой в штрафной, и это пенальти.';
  }

  @override
  String pitchComHandballPenalty2(String player) {
    return 'Рука была отставлена: пенальти за игру рукой, нарушил $player!';
  }

  @override
  String pitchComHandballPenaltyYellow(String player) {
    return 'Игра рукой в штрафной: $player. Пенальти и жёлтая карточка.';
  }

  @override
  String pitchComHandballPenaltyRed(String player) {
    return '$player останавливает мяч рукой! Пенальти, и он удалён.';
  }

  @override
  String pitchComHandballYellow(String player) {
    return '$player получает жёлтую за игру рукой.';
  }

  @override
  String pitchComHandballRed(String player) {
    return 'Умышленная игра рукой! $player удалён.';
  }

  @override
  String get matchLiveTable => 'Таблица онлайн';

  @override
  String get matchShotMap => 'Карта ударов';

  @override
  String get shotGoal => 'Гол';

  @override
  String get shotSaved => 'Отбит';

  @override
  String get shotOffTarget => 'Мимо';

  @override
  String get shotBlocked => 'Заблокирован';

  @override
  String get shotWoodwork => 'Каркас';

  @override
  String get playerStatSaves => 'Сейвы';

  @override
  String get playerStatPenSaved => 'Отбитые пенальти';

  @override
  String get playerStatPenalties => 'Пенальти';

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
    return '$competition, жеребьёвка плей-офф: между нами и финальным турниром стоит соперник $opponent.';
  }

  @override
  String yPlayoffDrawn1(String competition, String opponent) {
    return 'В плей-офф ($competition) нас ждёт $opponent. Одна пара, и всё на кону.';
  }

  @override
  String yPlayoffDrawn2(String competition, String opponent) {
    return '$opponent в плей-офф. Мне уже надо прилечь. $competition, мы едем. Может быть.';
  }

  @override
  String yPlayoffDrawn3(String competition, String opponent) {
    return 'Жеребьёвка плей-офф: $opponent. Обыграем их, и $competition будет на расстоянии вытянутой руки.';
  }

  @override
  String get matchElsewhereShout => 'ГОЛ НА ДРУГОМ СТАДИОНЕ';

  @override
  String get assistantMatchTitle => 'Матч ведёт ассистент';

  @override
  String assistantMatchBody(String opponent) {
    return 'Против соперника $opponent он сыграет твоим составом и твоей тактикой. Если хочешь, сначала настрой их.';
  }

  @override
  String get assistantMatchPlay => 'Пусть играет';

  @override
  String get assistantMatchResult => 'Матч ассистента';

  @override
  String get euroPlayoffCourseTitle => 'Плей-офф через Кубок наций';

  @override
  String get euroPlayoffCourseNote =>
      'Две лучшие команды каждой группы проходят напрямую. Последние места достаются путям плей-офф для лучших команд Кубка наций, которые не прошли. На данный момент:';

  @override
  String get euroPlayoffToFinal => 'В финал';

  @override
  String get euroPlayoffQualified => 'Прошли';

  @override
  String get playerOtherPositions => 'На всех позициях';

  @override
  String get compGulfCup => 'Кубок оазиса';

  @override
  String get compSoutheastAsianChampionship => 'Чемпионат Юго-Восточной Азии';

  @override
  String get matchTinyGulfCup => 'Оазис';

  @override
  String get matchTinySoutheastAsia => 'ЮВА';

  @override
  String hubCallUpRegional(String cup) {
    return 'Назови состав на турнир: $cup';
  }

  @override
  String newsRegionalDrawTitle(String cup, String group) {
    return '$cup: группа $group';
  }

  @override
  String newsRegionalDrawBody(String cup, String rivals) {
    return 'Жеребьёвка проведена ($cup). В декабре твои соперники: $rivals.';
  }

  @override
  String newsRegionalDrawBodyHosted(String cup, String rivals, String host) {
    return 'Жеребьёвка проведена ($cup). В декабре твои соперники: $rivals, хозяин: $host.';
  }

  @override
  String newsRegionalWonTitle(String cup) {
    return '$cup: победа!';
  }

  @override
  String newsRegionalWonBody(String cup, String opponent, String score) {
    return 'Ты выиграл турнир ($cup), обыграв в финале соперника $opponent $score.';
  }

  @override
  String get tourZoneGulf => 'ЗАЛИВ';

  @override
  String get tourZoneSoutheastAsia => 'ЮГО-ВОСТОЧНАЯ АЗИЯ';

  @override
  String regionalCupNext(int year) {
    return 'Следующий розыгрыш пройдёт в декабре $year.';
  }

  @override
  String get regionalCupNoWinners => 'Победителей пока нет.';

  @override
  String regionalCupEdition(String cup, int year) {
    return '$cup $year';
  }

  @override
  String regionalCupChampion(String name) {
    return 'Победитель: $name';
  }

  @override
  String regionalCupHosted(String host) {
    return 'Хозяин: $host';
  }

  @override
  String get regionalCupHomeAndAway => 'Группы играют дома и в гостях';

  @override
  String get regionalCupGroups => 'ГРУППЫ';

  @override
  String newsNcPlayoffNetTitle(String finals) {
    return 'Страховка через плей-офф: $finals';
  }

  @override
  String newsNcPlayoffNetBody(String cup, String finals) {
    return 'По текущим таблицам ($cup) у тебя есть место в плей-офф. Если не пройдёшь напрямую, это второй путь: $finals. Пути разыгрываются после окончания отбора.';
  }

  @override
  String get ncLegendWinnerUp => 'Победитель группы: повышение в лиге';

  @override
  String get ncLegendWinnerFinalsFour => 'Победитель группы: в «Финал четырёх»';

  @override
  String get ncLegendLastDown => 'Последнее место: понижение в лиге';

  @override
  String get ncLegendMayMove =>
      'Не наверняка: мест меньше, чем групп, поэтому поднимаются только лучшие победители и опускаются худшие аутсайдеры всей лиги';

  @override
  String get campaignIsleOfManTitle => 'Три ноги';

  @override
  String get campaignIsleOfManTwist =>
      'Остров Мэн занимает место Андорры в Европе на сто лет';

  @override
  String get campaignIsleOfManIntro =>
      'У острова Мэн есть своя футбольная ассоциация, своя лига и сборная, которая играет на Островных играх, но нет места в европейском и мировом футболе. В этом мире он занял место Андорры в Европе и начинает у самого дна мирового рейтинга: игроки на полставки, маленький стадион в Дугласе и ветер Ирландского моря в каждом матче. У тебя сто лет, двадцать пять циклов, чтобы попасть на чемпионат Европы, затем на чемпионат мира и, если осмелишься мечтать, выиграть один из них.';

  @override
  String get campaignIsleOfManGoal => 'Пробиться на чемпионат Европы';

  @override
  String get campaignStars1IsleOfMan => 'Пробиться на чемпионат Европы';

  @override
  String get campaignStars2IsleOfMan => 'Пробиться на чемпионат мира';

  @override
  String get campaignStars3IsleOfMan =>
      'Выиграть чемпионат Европы или чемпионат мира';

  @override
  String get campaignCzechoslovakiaTitle => 'Воссоединение';

  @override
  String get campaignCzechoslovakiaTwist =>
      'Чехия и Словакия снова играют вместе, на четыре цикла';

  @override
  String get campaignCzechoslovakiaIntro =>
      'Чехословакия выиграла чемпионат Европы в 1976 году и дважды доходила до финала чемпионата мира, а в 1993 году разделилась надвое. В этом мире они снова вместе: все игроки сборных Чехии и Словакии опять играют за одну команду, и двух сборных в Европе больше нет. Ты стартуешь чуть выше тридцатого места в мире с лучшими из обоих составов. У тебя четыре цикла, чтобы вывести Чехословакию на чемпионат мира, а затем выиграть чемпионат Европы и чемпионат мира.';

  @override
  String get campaignCzechoslovakiaGoal => 'Пробиться на чемпионат мира';

  @override
  String get campaignStars1Czechoslovakia => 'Пробиться на чемпионат мира';

  @override
  String get campaignStars2Czechoslovakia => 'Выиграть чемпионат Европы';

  @override
  String get campaignStars3Czechoslovakia => 'Выиграть чемпионат мира';

  @override
  String get campaignTexasTitle => 'Одинокая звезда';

  @override
  String get campaignTexasTwist =>
      'Республика Техас занимает место Ангильи в Северной Америке на пять циклов';

  @override
  String get campaignTexasIntro =>
      'Техас девять лет был отдельной республикой, прежде чем войти в США, а сегодня растит больше футболистов, чем большинство стран: три академии клубов высшей лиги, одна из сильнейших детско-юношеских систем и техасцы в каждой лиге. В этом мире Республика Техас играет сама за себя, на месте Ангильи в Северной Америке. Каждый игрок родился в Техасе, в Хьюстоне, Далласе, Сан-Антонио, Остине и Эль-Пасо, а состав – середняк региона: способен потрепать любого, но пока не внушает страха. У тебя пять циклов, чтобы пробиться на чемпионат мира, выиграть Кубок Северной Америки и, если осмелишься мечтать, сам чемпионат мира.';

  @override
  String get campaignTexasGoal => 'Пробиться на чемпионат мира';

  @override
  String get campaignStars1Texas => 'Пробиться на чемпионат мира';

  @override
  String get campaignStars2Texas => 'Выиграть Кубок Северной Америки';

  @override
  String get campaignStars3Texas => 'Выиграть чемпионат мира';

  @override
  String get campaignVaticanTitle => 'Аве Мария';

  @override
  String get campaignVaticanTwist =>
      'Ватикан занимает место Андорры в Европе на пятьдесят циклов';

  @override
  String get campaignVaticanIntro =>
      'В самом маленьком государстве мира несколько сотен граждан, в основном духовенство, гвардия швейцарских алебардщиков и ни одного достойного футболиста. В этом мире Ватикан всё равно играет, на месте Андорры в Европе, и он гораздо слабее, чем когда-либо был даже Сан-Марино: епископы, семинаристы, смотрители музеев и гвардейцы в увольнении, поле внутри стен на 1 500 зрителей и редкие домашние матчи на арендованном стадионе в Риме. Пятьдесят циклов – это долго, но без чудес не обойтись: попади на чемпионат Европы, затем на чемпионат мира и, если небеса слушают, выиграй один из них.';

  @override
  String get campaignVaticanGoal => 'Пробиться на чемпионат Европы';

  @override
  String get campaignStars1Vatican => 'Пробиться на чемпионат Европы';

  @override
  String get campaignStars2Vatican => 'Пробиться на чемпионат мира';

  @override
  String get campaignStars3Vatican => 'Выиграть чемпионат мира';

  @override
  String get campaignNoEnd => 'Без конца';

  @override
  String homeCampaignCycleNoEnd(int cycle) {
    return 'Цикл $cycle';
  }

  @override
  String get wcPlayoffCourseNote =>
      'Каждый победитель группы проходит напрямую. Последние места достаются путям плей-офф: лучшим командам со вторых мест (жёлтые в группах) и лучшим победителям групп Кубка наций, которые не прошли. Из Кубка наций на данный момент:';

  @override
  String get playoffCourseLegend =>
      'Жёлтый: на данный момент идёт в путь плей-офф как одна из лучших команд со второго места';

  @override
  String get playoffCourseFooter =>
      'Почему они здесь: Кубок наций даёт своим победителям групп, а затем следующим лучшим каждой лиги, место в плей-офф, если они не прошли напрямую. Это лишь текущее положение: оно меняется после каждого тура.';

  @override
  String get traitShotStopper => 'Мастер сейвов';

  @override
  String get traitShotStopperBlurb => 'Отражает больше ударов, чем положено.';

  @override
  String get traitPenaltyStopper => 'Гроза пенальтистов';

  @override
  String get traitPenaltyStopperBlurb =>
      'Отбивает больше пенальти, в матчах и в сериях.';

  @override
  String get playoffCourseLegendAll =>
      'Жёлтый: все команды со вторых мест идут в плей-офф';

  @override
  String get wcRunnersUpTableTitle => 'Вторые места: все идут в плей-офф';

  @override
  String get wcRunnersUpTableNote =>
      'Ранжированы по сопоставимым показателям. Корзины плей-офф формируются по мировому рейтингу после окончания отбора.';

  @override
  String ncRouteNote(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'В 4-й корзине плей-офф $count места для Кубка наций.',
      many: 'В 4-й корзине плей-офф $count мест для Кубка наций.',
      few: 'В 4-й корзине плей-офф $count места для Кубка наций.',
      one: 'В 4-й корзине плей-офф $count место для Кубка наций.',
    );
    return '$_temp0 Сначала они достаются его лучшим победителям групп, которые не выиграли свою отборочную группу и не заняли второе место, затем дальше по его рейтингу. На данный момент:';
  }

  @override
  String ncRouteHostCycle(int paths, int runnersUp) {
    return 'Этот чемпионат мира принимает европейская страна, поэтому $runnersUp команд со вторых мест заполняют все $paths путей плей-офф, и в этом цикле через Кубок наций мест нет.';
  }

  @override
  String get ncRouteTagHolds => 'Держит место';

  @override
  String get ncRouteTagQualified => 'Прошли';

  @override
  String get ncRouteTagRunnerUp => 'Второе место';

  @override
  String get ncRouteTagWaiting => 'Следующие в очереди';

  @override
  String get ncRouteLegendHolds =>
      'На данный момент держит место в 4-й корзине';

  @override
  String get ncRouteLegendQualified =>
      'Выигрывает отборочную группу: проходит напрямую, место переходит дальше';

  @override
  String get ncRouteLegendRunnerUp =>
      'Второе место в отборочной группе: в плей-офф и так, место переходит дальше';

  @override
  String get ncRouteLegendWaiting =>
      'Следующие в очереди, если кто-то выше выпадет';

  @override
  String get statsTabHistory => 'История';

  @override
  String get tourCupDestAfcFourthRound => 'азиатский четвёртый раунд';

  @override
  String get tourCupDestCafPlayoff => 'африканский плей-офф';

  @override
  String get tourCupDestOfcFinal => 'финал Океании';

  @override
  String get qualLegendDirect =>
      'Зелёный: на данный момент идёт в финальный турнир';

  @override
  String get qualLegendAfcStep => 'Жёлтый: идёт в азиатский четвёртый раунд';

  @override
  String get qualLegendCafStep => 'Жёлтый: идёт в африканский плей-офф';

  @override
  String get qualLegendOfcStep => 'Жёлтый: идёт в финал Океании';

  @override
  String get qualLegendIntercont =>
      'Жёлтый: идёт в межконтинентальный плей-офф';

  @override
  String get legendThrough =>
      'Зелёный: на данный момент проходит в следующий раунд';

  @override
  String get campaignRunInNumbersNote =>
      'Только матчи, по которым оценивается кампания: товарищеские и другие турниры не учитываются.';

  @override
  String get resultsStagePlayoff => 'ПЛЕЙ-ОФФ';

  @override
  String newsEuroPlayoffTieTitle(String cup, String path) {
    return '$cup, плей-офф: пара $path';
  }

  @override
  String newsEuroPlayoffTieBodyHome(String opponent) {
    return 'Противостояние из двух матчей с соперником $opponent в марте: первый матч дома, второй в гостях. Победитель по сумме едет на финальный турнир.';
  }

  @override
  String newsEuroPlayoffTieBodyAway(String opponent) {
    return 'Противостояние из двух матчей с соперником $opponent в марте: первый матч в гостях, второй дома. Победитель по сумме едет на финальный турнир.';
  }

  @override
  String newsEuroHostPlaceTitle(String cup) {
    return 'Путёвка как хозяину: $cup';
  }

  @override
  String newsEuroHostPlaceBody(String cup) {
    return 'Прямую путёвку ты упустил, но как хозяин получаешь одно из зарезервированных для хозяев мест. Ты пробился в финальный турнир: $cup.';
  }

  @override
  String get euro28LegendPlayoff =>
      'Жёлтый: на данный момент команда со второго места идёт в плей-офф';

  @override
  String euro28LegendHosts(String hosts) {
    return 'Хозяева ($hosts) тоже играют в отборе: если не пройдут, для них зарезервировано место.';
  }

  @override
  String euro28LegendHostsMany(String hosts) {
    return 'Хозяева ($hosts) тоже играют в отборе: два места зарезервированы для двух лучших из не прошедших.';
  }

  @override
  String get euro28DestPlayoffs => 'плей-офф';

  @override
  String get euro28CourseTitle => 'Плей-офф на данный момент';

  @override
  String get euro28CourseNote =>
      'Победители групп и восемь лучших команд со вторых мест проходят напрямую. Остальные вторые места идут в плей-офф вместе с лучшими победителями групп Кубка наций, которые не прошли. На данный момент:';

  @override
  String get euro28CourseFooter =>
      'Почему они здесь: сначала не прошедшие команды со вторых мест, затем лучшие победители групп Кубка наций, ещё не прошедшие, затем следующие лучшие. Это лишь текущее положение: оно меняется после каждого тура.';

  @override
  String euroPlayoffTie(String path) {
    return 'Пара $path';
  }

  @override
  String get euroPlayoffYourTie => 'Твоя пара';

  @override
  String euroPlayoffAggregate(String score) {
    return 'По сумме: $score';
  }

  @override
  String euroPlayoffTieWinnerPlaceholder(String path) {
    return 'Победитель пары $path';
  }

  @override
  String euroPlayoffYourGroupIfWinTie(String path, String group) {
    return 'Твоя группа, если выиграешь пару $path: группа $group';
  }

  @override
  String get euro28PlayoffIntroTies =>
      'Победители групп и восемь лучших команд со вторых мест прошли. Последние четыре места разыгрываются в парах из двух матчей в марте, дома и в гостях: четыре сильнейшие команды посеяны и играют второй матч дома.';

  @override
  String euro28PlayoffIntroPaths(int count) {
    return 'Победители групп и восемь лучших команд со вторых мест прошли, а не прошедшие хозяева занимают зарезервированные для них места. Последние $count мест разыгрываются в путях из четырёх команд в марте: полуфиналы в один матч на поле команды с более высоким рейтингом, затем финал в одну игру.';
  }

  @override
  String get classicCupsTitle => 'Классические кубки';

  @override
  String get classicCupsIntro =>
      'Переиграй настоящий чемпионат мира: его хозяев, его жеребьёвку, его формат. Выбери любую сборную и пройди с ней до конца.';

  @override
  String classicEditionLabel(String year, String hosts) {
    return 'Чемпионат мира $year · $hosts';
  }

  @override
  String classicHostsTwo(String first, String second) {
    return '$first и $second';
  }

  @override
  String classicHostsThree(String first, String second, String third) {
    return '$first, $second и $third';
  }

  @override
  String classicTeamsCount(int count) {
    return 'Команд: $count';
  }

  @override
  String classicRealChampion(String nation) {
    return 'Настоящий чемпион: $nation';
  }

  @override
  String classicMedalsProgress(int earned, int total) {
    return 'Медалей: $earned из $total';
  }

  @override
  String get classicPickNation => 'Выбери сборную';

  @override
  String get classicStart => 'Начать турнир';

  @override
  String get classicAbandonConfirm =>
      'Бросить это прохождение? Все сыгранные матчи будут потеряны.';

  @override
  String classicRunWith(String nation) {
    return 'Идёт прохождение: $nation';
  }

  @override
  String get classicLockedNote =>
      'Этот турнир входит в Unlimited. Хозяев и жеребьёвку можно посмотреть уже сейчас; чтобы играть, нужен Unlimited.';

  @override
  String classicPot(int pot) {
    return 'Корзина $pot';
  }

  @override
  String get classicWonHere => 'Уже выигран с этой сборной';

  @override
  String get classicNextMatch => 'Следующий матч';

  @override
  String get classicPlayMatch => 'Играть матч';

  @override
  String get classicTabGroups => 'Группы';

  @override
  String classicMatchday(int number) {
    return 'Тур $number';
  }

  @override
  String get classicBestXi => 'Символическая сборная';

  @override
  String get classicChampionTitle => 'Чемпионы мира!';

  @override
  String classicChampionBody(String nation, String year) {
    return '$nation выигрывает чемпионат мира $year.';
  }

  @override
  String get classicOutTitle => 'Вылет';

  @override
  String classicOutBody(String stage, String nation) {
    return '$stage: здесь путь для сборной $nation заканчивается.';
  }

  @override
  String get classicMedalsEarned => 'Полученные медали';

  @override
  String get classicNoRun => 'Прохождения нет. Выбери сборную, чтобы начать.';

  @override
  String classicPensShort(int home, int away) {
    return '$home-$away по пенальти';
  }

  @override
  String get classicMedalsTitle => 'Медали';

  @override
  String get classicMedalsAll => 'Все турниры';

  @override
  String get classicMedalLocked => 'Нужен Unlimited';

  @override
  String get classicMedalChampion => 'Чемпион';

  @override
  String get classicMedalChampionHow => 'Выиграй турнир с любой сборной.';

  @override
  String get classicMedalCollection => 'Коллекционер';

  @override
  String classicMedalCollectionHow(int count) {
    return 'Выиграй турнир с разными сборными: $count.';
  }

  @override
  String get classicMedalContinents => 'Все континенты';

  @override
  String get classicMedalContinentsHow =>
      'Выиграй его со сборной из каждой конфедерации, представленной на турнире.';

  @override
  String get classicMedalGiantKiller => 'Убийца гигантов';

  @override
  String get classicMedalGiantKillerHow =>
      'Выиграй с аутсайдером: командой из последней корзины или самой слабой трети участников.';

  @override
  String get classicMedalRewrite => 'Переписать историю';

  @override
  String get classicMedalRewriteHow =>
      'Выбей сборную, которая на самом деле выиграла этот турнир.';

  @override
  String get classicMedalUnbeaten => 'Без поражений';

  @override
  String get classicMedalUnbeatenHow =>
      'Выиграй турнир, не проиграв ни одного матча.';

  @override
  String get classicMedalGoldenBootHow =>
      'Пусть один из твоих игроков станет лучшим бомбардиром.';

  @override
  String get classicMedalGrandSlam => 'Большой шлем';

  @override
  String get classicMedalGrandSlamHow => 'Выиграй все семь турниров.';

  @override
  String get classicMedalSevenFlags => 'Семь флагов';

  @override
  String get classicMedalSevenFlagsHow => 'Выиграй с семью разными сборными.';

  @override
  String get classicMedalConfederations => 'Шесть конфедераций';

  @override
  String get classicMedalConfederationsHow =>
      'Выиграй со сборной из каждой из шести конфедераций.';

  @override
  String get classicMedalOneNation => 'Одна сборная, все эпохи';

  @override
  String get classicMedalOneNationHow =>
      'Выиграй все турниры с одной и той же сборной.';

  @override
  String get classicMedalPerfect => 'Перфекционист';

  @override
  String get classicMedalPerfectHow => 'Получи все медали одного турнира.';

  @override
  String get classicNationRussia => 'Россия';

  @override
  String get classicNationSerbiaMontenegro => 'Сербия и Черногория';

  @override
  String get paywallBenefitClassicCups =>
      'Все классические кубки: переиграй также чемпионаты мира 2002, 2010 и 2022 годов с их настоящими жеребьёвками.';

  @override
  String get editorClassicBlurb =>
      'Команды всех прошлых чемпионатов мира: сила, форма и игроки.';

  @override
  String get editorClassicStar => 'Лучший игрок';

  @override
  String get editorClassicDepth => 'Скамейка';

  @override
  String get editorClassicKit => 'Цвета формы';

  @override
  String get editorClassicPrimary => 'Футболка';

  @override
  String get editorClassicSecondary => 'Отделка';

  @override
  String get editorClassicReset => 'Сбросить команду';

  @override
  String get editorClassicStadiums => 'Стадионы хозяев';

  @override
  String get editorClassicStadiumName => 'Название стадиона';

  @override
  String get editorClassicCity => 'Город';

  @override
  String get editorClassicCapacity => 'Вместимость';

  @override
  String editorClassicCapacityRange(String min, String max) {
    return 'От $min до $max мест.';
  }

  @override
  String get editorClassicHostNation => 'Страна-хозяйка';

  @override
  String get editorClassicAddStadium => 'Добавить стадион';

  @override
  String get editorClassicRemoveStadium => 'Удалить этот стадион';

  @override
  String get editorClassicOpeningVenue => 'Матч открытия';

  @override
  String get editorClassicFinalVenue => 'Финал';

  @override
  String get editorClassicResetStadiums => 'Сбросить стадионы';

  @override
  String get editorClassicAddPlayer => 'Добавить игрока';

  @override
  String get editorClassicRemovePlayer => 'Удалить этого игрока';

  @override
  String get editorClassicResetSquad => 'Сбросить состав';

  @override
  String editorClassicSquadRule(int min, int max, int keepers) {
    return 'От $min до $max игроков, из них не менее $keepers вратарей.';
  }

  @override
  String editorClassicKeepersNeeded(int count) {
    return 'В составе нужно не менее $count вратарей.';
  }

  @override
  String get traitTwelfthMan => '12-й игрок';

  @override
  String get traitTwelfthManBlurb =>
      'Встряхивает команду, когда выходит со скамейки.';

  @override
  String get traitConsistent => 'Стабильный';

  @override
  String get traitConsistentBlurb => 'Редко играет плохо, но и редко блистает.';

  @override
  String get traitInconsistent => 'Нестабильный';

  @override
  String get traitInconsistentBlurb =>
      'От матча к матчу то блистает, то пропадает.';

  @override
  String get traitInjuryProne => 'Подвержен травмам';

  @override
  String get traitInjuryProneBlurb => 'Травмируется гораздо чаще большинства.';

  @override
  String get traitEasilyTired => 'Быстро устаёт';

  @override
  String get traitEasilyTiredBlurb => 'Выдыхается раньше партнёров.';

  @override
  String get traitPoorUnderPressure => 'Не выдерживает давления';

  @override
  String get traitPoorUnderPressureBlurb =>
      'Играет хуже в матчах на выбывание.';

  @override
  String get traitIndividualistic => 'Индивидуалист';

  @override
  String get traitIndividualisticBlurb =>
      'Бьёт, когда нужно отдать пас, и реже ассистирует.';

  @override
  String get matchScoutTraitTwelfthMan =>
      'У них на скамейке опасный игрок для замены.';

  @override
  String get matchScoutTraitEasilyTired =>
      'Один из их игроков основы рано устаёт, так что последние полчаса могут стать открытыми.';

  @override
  String get matchScoutTraitIndividualistic =>
      'Один из их нападающих предпочитает бить, а не отдавать пас.';

  @override
  String get matchScoutTraitPoorUnderPressure =>
      'Один из их игроков основы часто теряется в больших матчах.';

  @override
  String get matchScoutTraitInconsistent =>
      'Один из их игроков основы очень нестабилен.';

  @override
  String get matchScoutTraitInjuryProne =>
      'Один из их игроков основы часто травмируется.';
}
