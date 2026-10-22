// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get matchPreviewTitle => 'ПРЕВ’Ю МАТЧУ';

  @override
  String get matchKickOff => 'Стартовий свисток';

  @override
  String get matchTactics => 'Тактика';

  @override
  String get matchYourXi => 'ТВІЙ СТАРТОВИЙ СКЛАД';

  @override
  String get matchHeadToHead => 'ОСОБИСТІ ЗУСТРІЧІ';

  @override
  String matchCouldNotLoad(String error) {
    return 'Не вдалося завантажити матч.\n$error';
  }

  @override
  String get matchNoUpcoming => 'Найближчого матчу немає.';

  @override
  String get matchUnknownNation => 'Невідомо';

  @override
  String get matchH2hFirstMeeting => 'Перша в історії зустріч';

  @override
  String get matchH2hYouLead => 'Ти ведеш в особистих зустрічах';

  @override
  String matchH2hOppEdge(String opponent) {
    return 'Перевага: $opponent';
  }

  @override
  String get matchH2hEven => 'Рівність у протистоянні';

  @override
  String matchH2hMet(int count) {
    return 'Зустрічей: $count';
  }

  @override
  String get matchH2hWon => 'Перемоги';

  @override
  String get matchH2hDrawn => 'Нічиї';

  @override
  String get matchH2hLost => 'Поразки';

  @override
  String get matchDossierTitle => 'Скаутський звіт';

  @override
  String get matchDossierForm => 'ФОРМА';

  @override
  String get matchDossierNoGames => 'Недавніх матчів немає';

  @override
  String get matchDossierKeyMen => 'КЛЮЧОВІ ГРАВЦІ';

  @override
  String matchCouldNotContinue(String error) {
    return 'Не вдалося продовжити: $error';
  }

  @override
  String get matchSkipToFullTime => 'Перемотати до фінального свистка';

  @override
  String get matchStatShots => 'Удари';

  @override
  String get matchStatGoals => 'Голи';

  @override
  String get matchStatYellowCards => 'Жовті';

  @override
  String get matchStatRedCards => 'Червоні';

  @override
  String get matchMomentum => 'ІНІЦІАТИВА';

  @override
  String get matchSwingAtk => 'АТК';

  @override
  String get matchSwingDef => 'ЗАХ';

  @override
  String ceremonyWorldCupYear(int year) {
    return 'ЧЕМПІОНАТ СВІТУ $year';
  }

  @override
  String get ceremonyFinalsAreHere => 'ФІНАЛЬНА ЧАСТИНА РОЗПОЧАЛАСЯ';

  @override
  String ceremonyHostedBy(String hosts) {
    return 'ГОСПОДАР ТУРНІРУ  $hosts';
  }

  @override
  String get ceremonyHostTbc => 'ГОСПОДАРЯ ЩЕ НЕ ВИЗНАЧЕНО';

  @override
  String get matchHalfTime => 'ПЕРЕРВА';

  @override
  String get matchContinue => 'Продовжити';

  @override
  String get matchContinuing => 'Продовжуємо…';

  @override
  String matchTacticsWithSubs(int used, int max) {
    return 'Тактика · заміни $used/$max';
  }

  @override
  String matchTiredCount(int count) {
    return 'ВТОМА ×$count';
  }

  @override
  String get matchTacticsLabel => 'ТАКТИКА';

  @override
  String get teamOverallOverTime => 'РІВЕНЬ ПО РОКАХ';

  @override
  String get teamOverall => 'Загальний рівень';

  @override
  String get teamTalkHeading => 'УСТАНОВКА НА ТАЙМ';

  @override
  String get teamTalkPrompt => 'Задай тон на другий тайм.';

  @override
  String get teamTalkCalmLabel => 'Холодні голови';

  @override
  String get teamTalkCalmBlurb => 'Заспокой команду. Невеликий приріст усюди.';

  @override
  String get teamTalkEncourageLabel => 'Підбадьорити';

  @override
  String get teamTalkEncourageBlurb => 'Тисніть уперед і йдіть на гру.';

  @override
  String get teamTalkDemandMoreLabel => 'Вимагати більшого';

  @override
  String get teamTalkDemandMoreBlurb =>
      'Викладайтеся повністю. Атакуйте жорстко.';

  @override
  String get teamTalkPraiseLabel => 'Тримати структуру';

  @override
  String get teamTalkPraiseBlurb => 'Грайте компактно й бережіть те, що маєте.';

  @override
  String get teamTalkBelieveLabel => 'Вірити в себе';

  @override
  String get teamTalkBelieveBlurb =>
      'Повірте в себе. Підйом на обох половинах поля.';

  @override
  String get teamTalkFocusLabel => 'Не розслаблятися';

  @override
  String get teamTalkFocusBlurb => 'Повна концентрація. Закрийте гру.';

  @override
  String get teamTalkUrgencyLabel => 'Відчуття терміновості';

  @override
  String get teamTalkUrgencyBlurb =>
      'Тисніть негайно. Все або нічого, але з’являться прогалини.';

  @override
  String get teamTalkReassureLabel => 'Без тиску';

  @override
  String get teamTalkReassureBlurb => 'Вгамуйте нерви й тримайте схему.';

  @override
  String get commonRetry => 'Повторити';

  @override
  String get commonSomethingWentWrong => 'Щось пішло не так';

  @override
  String get commonCrashBox =>
      'Тут щось пішло не так.\nДеталі: Налаштування → Діагностика.';

  @override
  String hubCouldNotAdvance(String error) {
    return 'Не вдалося прокрутити світ: $error';
  }

  @override
  String get settingsDiagnosticsTitle => 'Діагностика';

  @override
  String get settingsDiagnosticsBlurb =>
      'Помилки, записані на цьому пристрої. Нічого нікуди не надсилається.';

  @override
  String get settingsContactTitle => 'Контакт';

  @override
  String get settingsContactCopied => 'Адресу скопійовано.';

  @override
  String get settingsCommunityTitle => 'Спільнота';

  @override
  String get settingsDiscordSubtitle => 'Приєднуйся до спільноти';

  @override
  String get settingsLinkCopied => 'Посилання скопійовано.';

  @override
  String get diagnosticsEmpty => 'Помилок немає. Так і задумано.';

  @override
  String get diagnosticsCopy => 'Копіювати';

  @override
  String get diagnosticsCopied => 'Журнал скопійовано в буфер обміну.';

  @override
  String get diagnosticsClear => 'Очистити';

  @override
  String get navHub => 'Головна';

  @override
  String get navSquad => 'Склад';

  @override
  String get navStandings => 'Таблиці';

  @override
  String get navCareers => 'Моя кар’єра';

  @override
  String get settingsTitle => 'НАЛАШТУВАННЯ';

  @override
  String get settingsSoundHapticsTitle => 'Звук і вібрація';

  @override
  String get settingsSoundHapticsBlurb =>
      'Вібрація й короткий сигнал на голи, стартовий та фінальний свисток.';

  @override
  String get settingsLanguageTitle => 'Мова';

  @override
  String get settingsLanguageBlurb =>
      'Обери мову застосунку або слідуй мові пристрою.';

  @override
  String get settingsLanguageSystem => 'Системна';

  @override
  String get matchPreviewAllMeetings => 'Усі зустрічі';

  @override
  String get recordsMeetings => 'ЗУСТРІЧІ';

  @override
  String get recordsLegends => 'ЛЕГЕНДИ';

  @override
  String get recordsAllTimeXi => 'СКЛАД ВСІХ ЧАСІВ';

  @override
  String get recordsHallOfFame => 'ЗАЛА СЛАВИ';

  @override
  String get recordsAllTimeWorld => 'СВІТ ЗА ВСІ ЧАСИ';

  @override
  String get recordsAllTimeTopScorers => 'НАЙКРАЩІ БОМБАРДИРИ ВСІХ ЧАСІВ';

  @override
  String get recordsMostCapped => 'НАЙБІЛЬШЕ МАТЧІВ ЗА ЗБІРНУ';

  @override
  String get recordsMostWcStarts => 'НАЙБІЛЬШЕ СТАРТІВ НА ЧС';

  @override
  String get recordsMostTournaments => 'НАЙБІЛЬШЕ ТУРНІРІВ';

  @override
  String get recordsRecordBook => 'КНИГА РЕКОРДІВ';

  @override
  String get recordsHeadToHead => 'ОСОБИСТІ ЗУСТРІЧІ';

  @override
  String get recordsFiercestRival => 'НАЙЛЮТІШИЙ СУПЕРНИК';

  @override
  String get recordsMostCaps => 'НАЙБІЛЬШЕ МАТЧІВ';

  @override
  String get recordsTopScorers => 'БОМБАРДИРИ';

  @override
  String get recordsMostAssists => 'НАЙБІЛЬШЕ АСИСТІВ';

  @override
  String get recordsYourRecord => 'ТВІЙ БАЛАНС';

  @override
  String get callUpHome => 'ВДОМА';

  @override
  String get callUpAway => 'НА ВИЇЗДІ';

  @override
  String get recordsHome => 'ГОСПОДАРІ';

  @override
  String get recordsAway => 'ГОСТІ';

  @override
  String get recordsActive => 'АКТИВНИЙ';

  @override
  String get recordsStillActive => 'Ще грає';

  @override
  String get recordsAvg => 'сер.';

  @override
  String get recordsSelect => 'Обрати';

  @override
  String get recordsVs => 'проти';

  @override
  String get recordsDraws => 'Нічиї';

  @override
  String get recordsGoalsLabel => 'Голи';

  @override
  String get recordsBestFinish => 'Найкращий результат';

  @override
  String get recordsNoFinalsYet => 'У фінальній частині ще не грали';

  @override
  String get recordsLongestUnbeaten => 'Найдовша серія без поразок';

  @override
  String get recordsBiggestWin => 'Найбільша перемога';

  @override
  String get recordsSeeAllMeetings => 'Усі зустрічі';

  @override
  String get recordsSaveNotFound => 'Збереження не знайдено.';

  @override
  String get recordsNoMatches => 'Збігів немає.';

  @override
  String get recordsSearchPlayerOrNation => 'Пошук гравця або країни';

  @override
  String get recordsSearchNation => 'Пошук країни';

  @override
  String get recordsPickTwoDifferent => 'Обери дві різні країни.';

  @override
  String get recordsPlayToBuildRecord =>
      'Зіграй кілька матчів, і тут з’явиться твій баланс проти кожного суперника.';

  @override
  String get recordsTapOpponent => 'Торкнись суперника, щоб побачити деталі.';

  @override
  String get recordsEdgeUpperHand => 'Перевага на твоєму боці';

  @override
  String get recordsEdgeTheirNumber => 'Вони тебе переграють';

  @override
  String get recordsEdgeEven => 'Рівність у протистоянні';

  @override
  String get recordsAllTimeWorldSubtitle =>
      'Бомбардири й рекордсмени за матчами, усі країни';

  @override
  String get recordsHeadToHeadSubtitle =>
      'Порівняй історію будь-яких двох збірних';

  @override
  String get recordsLegendsSubtitle => 'Склад всіх часів і зала слави';

  @override
  String get recordsUnitGoals => 'голів';

  @override
  String get recordsUnitCaps => 'матчів';

  @override
  String get recordsUnitStarts => 'стартів';

  @override
  String get recordsUnitCups => 'турнірів';

  @override
  String get recordsUnitAssists => 'асистів';

  @override
  String recordsCapsCount(int count) {
    return 'Матчів: $count';
  }

  @override
  String recordsGoalsCount(int count) {
    return 'Голів: $count';
  }

  @override
  String recordsAssistsCount(int count) {
    return 'Асистів: $count';
  }

  @override
  String recordsMotmCount(int count) {
    return 'Гравець матчу: $count';
  }

  @override
  String recordsMatchesCount(int count) {
    return 'Матчів: $count';
  }

  @override
  String recordsMeetingsCount(int count) {
    return 'Зустрічей: $count';
  }

  @override
  String recordsCodeWins(String code) {
    return 'Перемоги $code';
  }

  @override
  String recordsMeetingsWdl(int meetings, int wins, int draws, int losses) {
    return 'Зустрічей: $meetings · $winsВ $drawsН $lossesП';
  }

  @override
  String recordsWdl(int wins, int draws, int losses) {
    return '$winsВ $drawsН $lossesП';
  }

  @override
  String recordsRivalLine(int meetings, String record, String edge) {
    return 'Зустрічей: $meetings · $record · $edge';
  }

  @override
  String recordsNeverMet(String a, String b) {
    return '$a і $b ще не зустрічалися в цьому збереженні.';
  }

  @override
  String tacticsSentOffNote(String names) {
    return 'Вилучено: $names. Заміни немає, тож граєте в меншості.';
  }

  @override
  String tacticsNeedFitPlayers(int required, int have) {
    return 'Потрібно $required доступних (здорових: $have)';
  }

  @override
  String tacticsMissesOfCamp(int missed, int total) {
    return 'Пропускає $missed/$total';
  }

  @override
  String get tacticsOutForWholeCamp => 'Недоступний на весь виклик';

  @override
  String get rankingCentreOnMe => 'До моєї країни';

  @override
  String get recordsAfterExtraTime => 'д. ч.';

  @override
  String recordsOnPenalties(int a, int b) {
    return '$a–$b пен.';
  }

  @override
  String recordsVersus(String a, String b) {
    return '$a проти $b';
  }

  @override
  String recordsPlayedScore(int played, int gf, int ga) {
    return 'Ігор: $played · $gf–$ga';
  }

  @override
  String recordsBiggestWinValue(int gf, int ga, String opp) {
    return '$gf–$ga проти $opp';
  }

  @override
  String recordsCouldNotLoad(String error) {
    return 'Не вдалося завантажити.\n$error';
  }

  @override
  String recordsCouldNotLoadLegends(String error) {
    return 'Не вдалося завантажити легенд.\n$error';
  }

  @override
  String recordsCouldNotLoadRecords(String error) {
    return 'Не вдалося завантажити рекорди.\n$error';
  }

  @override
  String recordsCouldNotLoadNations(String error) {
    return 'Не вдалося завантажити країни.\n$error';
  }

  @override
  String recordsCouldNotLoadYourRecord(String error) {
    return 'Не вдалося завантажити твій баланс.\n$error';
  }

  @override
  String recordsCouldNotLoadRecord(String error) {
    return 'Не вдалося завантажити запис.\n$error';
  }

  @override
  String recordsNoLegends(String nation) {
    return 'Легенд ще немає. Зіграй кілька кампаній, і тут з’являться великі імена. Збірна: $nation.';
  }

  @override
  String recordsGreatestSide(String nation) {
    return 'Найсильніший склад усіх часів. Збірна: $nation.';
  }

  @override
  String get recordsNoWorldHistory =>
      'У світу ще немає історії. Зіграй кілька кампаній, і тут з’являться великі імена всіх часів.';

  @override
  String recordsPlayToWriteHistory(String nation) {
    return 'Зіграй кілька матчів, щоб почати писати історію. Збірна: $nation.';
  }

  @override
  String get tacticsLineGk => 'ВР';

  @override
  String get tacticsLineDef => 'ЗХ';

  @override
  String get tacticsLineMid => 'ПЗ';

  @override
  String get tacticsLineFwd => 'НП';

  @override
  String get tacticsGoalkeepers => 'ВОРОТАРІ';

  @override
  String get tacticsDefenders => 'ЗАХИСНИКИ';

  @override
  String get tacticsMidfielders => 'ПІВЗАХИСНИКИ';

  @override
  String get tacticsForwards => 'НАПАДНИКИ';

  @override
  String get tacticsCallUpsTitle => 'ВИКЛИКИ';

  @override
  String tacticsPickAtLeastPlayers(int min) {
    return 'Обери щонайменше $min гравців.';
  }

  @override
  String tacticsCouldNotLoadSquad(String error) {
    return 'Не вдалося завантажити склад.\n$error';
  }

  @override
  String get tacticsNoSquad => 'Складу немає.';

  @override
  String tacticsSquadCount(int count, int max) {
    return 'СКЛАД · $count/$max';
  }

  @override
  String tacticsMinMax(int min, int max) {
    return 'Мін. $min · Макс. $max';
  }

  @override
  String get tacticsBestQuality => 'Найкращий склад';

  @override
  String get tacticsPreviousSquad => 'Попередній склад';

  @override
  String get tacticsSquadLockedBack => 'Назад (склад закрито)';

  @override
  String get tacticsConfirmSquad => 'Підтвердити склад';

  @override
  String tacticsSquadFullMax(int max) {
    return 'Склад повний (макс. $max)';
  }

  @override
  String get tacticsSquadLocked => 'СКЛАД ЗАКРИТО';

  @override
  String get tacticsNominationOpen => 'ЗАЯВКУ ВІДКРИТО. ОБЕРИ СКЛАД';

  @override
  String get tacticsSquadFixedBlurb =>
      'Склад на матчі нижче зафіксовано. Обери новий перед наступним вікном заявки.';

  @override
  String get tacticsSquadWillPlayBlurb => 'Цей склад зіграє матчі нижче.';

  @override
  String get tacticsUnknown => 'Невідомо';

  @override
  String tacticsAgeValue(int age, String value) {
    return 'Вік $age · $value';
  }

  @override
  String get tacticsFatigueExhausted => 'Виснажений';

  @override
  String get tacticsFatigueTired => 'Втомлений';

  @override
  String get tacticsFatigueMatchLegs => 'Матчева втома';

  @override
  String tacticsTooManySubs(int max) {
    return 'Забагато замін (макс. $max).';
  }

  @override
  String tacticsMinuteTitle(int minute) {
    return 'ТАКТИКА · $minute\'';
  }

  @override
  String get tacticsApply => 'ЗАСТОСУВАТИ';

  @override
  String get tacticsTabLineupSubs => 'СКЛАД І ЗАМІНИ';

  @override
  String get tacticsTabTactics => 'ТАКТИКА';

  @override
  String get squadLineKeepers => 'ВОРОТАРІ';

  @override
  String get squadLineDefenders => 'ЗАХИСТ';

  @override
  String get squadLineMidfielders => 'ПІВЗАХИСТ';

  @override
  String get squadLineForwards => 'АТАКА';

  @override
  String get squadStatXiRating => 'Рейтинг основи';

  @override
  String get squadStatAvgAge => 'Сер. вік';

  @override
  String get squadStatSize => 'Склад';

  @override
  String get squadStatUnavailable => 'Недоступні';

  @override
  String get squadDepthTitle => 'ГЛИБИНА ПО ЛІНІЯХ';

  @override
  String squadAgeShort(int age) {
    return '$age р.';
  }

  @override
  String get tacticsTabOtherPositions => 'ІНШІ ПОЗИЦІЇ';

  @override
  String get tacticsOutOfPositionNote => 'Не на своїй позиції';

  @override
  String get tacticsNobodyElse => 'Більше нікого пробувати.';

  @override
  String get tacticsPickSomebodyFirst =>
      'Обери, кого замінити, і решта лавки з’явиться тут разом із рівнем, на якому вони зіграють цю позицію.';

  @override
  String get tacticsTabSuitable => 'ПІДХОДЯТЬ';

  @override
  String get tacticsTabOnPitch => 'НА ПОЛІ';

  @override
  String tacticsSectionSuitable(int count) {
    return 'ПІДХОДЯТЬ · $count';
  }

  @override
  String get tacticsNobodySuits =>
      'На лавці немає природного виконавця цієї позиції, тож ось усі.';

  @override
  String tacticsSectionOnPitch(int count, int max) {
    return 'НА ПОЛІ · $count/$max';
  }

  @override
  String tacticsSectionAvailable(int count) {
    return 'ДОСТУПНІ · $count';
  }

  @override
  String get tacticsRowStarted => 'У старті';

  @override
  String tacticsRowCameOn(int minute) {
    return 'Вийшов на $minute\'';
  }

  @override
  String get tacticsRowSubstitute => 'Вийшов на заміну';

  @override
  String get tacticsEnergyLabel => 'ЕНЕРГІЯ';

  @override
  String tacticsPickReplacementFor(String name) {
    return 'Торкнись заміни для $name або торкнись його ще раз, щоб скасувати.';
  }

  @override
  String get tacticsSlotLostToRedCard =>
      'Червона картка забрала це місце. Перетягни сюди партнера, щоб перенести прогалину.';

  @override
  String get tacticsSentOffShort => 'ВИЛУЧЕНО';

  @override
  String tacticsSubsUsed(int used, int max) {
    return 'ЗАМІНИ · $used/$max';
  }

  @override
  String get tacticsDragSubOn =>
      'Торкнись гравця на полі, щоб зняти його, або утримуй і перетягни запасного на нього.';

  @override
  String get tacticsNoSubs => 'Запасних немає.';

  @override
  String get tacticsChooseShape => 'ОБЕРИ СХЕМУ';

  @override
  String get tacticsFormation => 'СХЕМА';

  @override
  String get tacticsInstructions => 'УСТАНОВКИ';

  @override
  String get tacticsDrilling => 'ВІДПРАЦЬОВАНІСТЬ';

  @override
  String get tacticsDrillingUnplayed => 'НЕ ГРАЛИ';

  @override
  String get tacticsDrillingNew => 'НОВА';

  @override
  String get tacticsDrillingSettling => 'ЗВИКАЮТЬ';

  @override
  String get tacticsDrillingDrilled => 'ВІДПРАЦЬОВАНА';

  @override
  String get tacticsInstrMentality => 'Налаштованість';

  @override
  String get tacticsInstrDefensive => 'Захисна';

  @override
  String get tacticsInstrAttacking => 'Атакувальна';

  @override
  String get tacticsInstrPressing => 'Пресинг';

  @override
  String get tacticsInstrLowBlock => 'Низький блок';

  @override
  String get tacticsInstrHighPress => 'Високий пресинг';

  @override
  String get tacticsInstrTempo => 'Темп';

  @override
  String get tacticsInstrPatient => 'Терплячий';

  @override
  String get tacticsInstrFast => 'Швидкий';

  @override
  String get tacticsInstrWidth => 'Ширина';

  @override
  String get tacticsInstrNarrow => 'Вузька';

  @override
  String get tacticsInstrWide => 'Широка';

  @override
  String get tacticsInstrDefLine => 'Лінія захисту';

  @override
  String get tacticsInstrDefensiveLine => 'Лінія захисту';

  @override
  String get tacticsInstrDeep => 'Низька';

  @override
  String get tacticsInstrHigh => 'Висока';

  @override
  String get tacticsInstrDirectness => 'Прямолінійність';

  @override
  String get tacticsInstrPossession => 'Володіння';

  @override
  String get tacticsInstrDirect => 'Прямо';

  @override
  String get tacticsPickGoalkeeper => 'ОБЕРИ ВОРОТАРЯ';

  @override
  String get tacticsPickLeftBack => 'ОБЕРИ ЛІВОГО ЗАХИСНИКА';

  @override
  String get tacticsPickCentreBack => 'ОБЕРИ ЦЕНТРАЛЬНОГО ЗАХИСНИКА';

  @override
  String get tacticsPickRightBack => 'ОБЕРИ ПРАВОГО ЗАХИСНИКА';

  @override
  String get tacticsPickDefensiveMid => 'ОБЕРИ ОПОРНИКА';

  @override
  String get tacticsPickCentralMid => 'ОБЕРИ ЦЕНТРАЛЬНОГО ПІВЗАХИСНИКА';

  @override
  String get tacticsPickAttackingMid => 'ОБЕРИ АТАКУВАЛЬНОГО ПІВЗАХИСНИКА';

  @override
  String get tacticsPickLeftMid => 'ОБЕРИ ЛІВОГО ПІВЗАХИСНИКА';

  @override
  String get tacticsPickRightMid => 'ОБЕРИ ПРАВОГО ПІВЗАХИСНИКА';

  @override
  String get tacticsPickLeftWing => 'ОБЕРИ ЛІВОГО ВІНГЕРА';

  @override
  String get tacticsPickRightWing => 'ОБЕРИ ПРАВОГО ВІНГЕРА';

  @override
  String get tacticsPickStriker => 'ОБЕРИ НАПАДНИКА';

  @override
  String tacticsRoleOutOfPosition(String role) {
    return '$role · не на своїй позиції';
  }

  @override
  String tacticsAgeOnly(int age) {
    return 'Вік $age';
  }

  @override
  String tacticsRoleAge(String role, int age) {
    return '$role · Вік $age';
  }

  @override
  String get tacticsOn => 'НА ПОЛІ';

  @override
  String get tacticsSquad => 'СКЛАД';

  @override
  String get tacticsTabLineup => 'РОЗСТАНОВКА';

  @override
  String get tacticsTabInstructions => 'УСТАНОВКИ';

  @override
  String get tacticsTabRoles => 'РОЛІ';

  @override
  String get tacticsTabSetPieces => 'СТАНДАРТИ';

  @override
  String get tacticsTabRolesSetPieces => 'РОЛІ І СТАНДАРТИ';

  @override
  String get tacticsRolesSetPiecesBlurb =>
      'Дай кожному гравцю основи роль. Торкнись значка пенальті (⚽) або штрафного (▲), щоб обрати виконавця.';

  @override
  String get tacticsTooltipCallUps => 'Виклики';

  @override
  String get tacticsTooltipPresets => 'Шаблони тактики';

  @override
  String get tacticsTooltipInstructions => 'Установки';

  @override
  String get tacticsNoTacticSet => 'Тактику не задано.';

  @override
  String tacticsReplaceStarters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ЗАМІНИ $count ГРАВЦЯ ОСНОВИ',
      many: 'ЗАМІНИ $count ГРАВЦІВ ОСНОВИ',
      few: 'ЗАМІНИ $count ГРАВЦІВ ОСНОВИ',
      one: 'ЗАМІНИ $count ГРАВЦЯ ОСНОВИ',
    );
    return '$_temp0';
  }

  @override
  String tacticsPlayerOut(String name, String reason) {
    return '$name: $reason';
  }

  @override
  String get tacticsOut => 'Недоступний';

  @override
  String get tacticsTapSpotReplace =>
      'Торкнись його місця на полі, щоб обрати заміну.';

  @override
  String get tacticsTapOrDrag =>
      'Торкнись гравця, щоб замінити його, або утримуй і перетягни, щоб перемістити.';

  @override
  String get tacticsPlayerRoles => 'РОЛІ ГРАВЦІВ';

  @override
  String get tacticsRolesBlurb =>
      'Дай гравцеві завдання: гольовий нападник, плеймейкер, таран. Впливає на те, хто забиває і хто створює.';

  @override
  String get tacticsSetPieceTakers => 'ВИКОНАВЦІ СТАНДАРТІВ';

  @override
  String get tacticsSetPieceBlurb =>
      'Хто б’є пенальті й стандарти, або довірся найкращому за навичками.';

  @override
  String get tacticsTakerAuto => 'Автоматично';

  @override
  String get tacticsTakerQuickPick => 'Найкращі виконавці';

  @override
  String get tacticsPenalties => 'Пенальті';

  @override
  String get tacticsCornersFreeKicks => 'Кутові й штрафні';

  @override
  String get tacticsSkillFin => 'ЗАВ';

  @override
  String get tacticsSkillPas => 'ПАС';

  @override
  String tacticsRolePlayer(String name) {
    return 'РОЛЬ · $name';
  }

  @override
  String get tacticsPenaltyTaker => 'ВИКОНАВЕЦЬ ПЕНАЛЬТІ';

  @override
  String get tacticsCornerFreeKickTaker => 'ВИКОНАВЕЦЬ КУТОВИХ І ШТРАФНИХ';

  @override
  String get tacticsAutomatic => 'Автоматично';

  @override
  String get tacticsLetBestSuited => 'Нехай б’є найпідхожіший гравець.';

  @override
  String get tacticsInXi => 'В ОСНОВІ';

  @override
  String get tacticsTeamInstructions => 'КОМАНДНІ УСТАНОВКИ';

  @override
  String get tacticsTeamInstructionsBlurb =>
      'Налаштуй стиль гри. Кожен повзунок зсуває всю команду.';

  @override
  String tacticsSavedPreset(String name) {
    return 'Збережено «$name»';
  }

  @override
  String tacticsAppliedPreset(String name) {
    return 'Застосовано «$name»';
  }

  @override
  String get tacticsTacticPresets => 'ШАБЛОНИ ТАКТИКИ';

  @override
  String get tacticsPresetsBlurb =>
      'Збережи цю схему як стиль для повторного використання або застосуй раніше збережений.';

  @override
  String get tacticsSaveCurrentTactic => 'Зберегти поточну тактику';

  @override
  String tacticsCouldNotLoadPresets(String error) {
    return 'Не вдалося завантажити шаблони.\n$error';
  }

  @override
  String get tacticsNoPresetsYet =>
      'Шаблонів ще немає. Торкнись «Зберегти поточну тактику», щоб зберегти це налаштування як стиль.';

  @override
  String get tacticsNameThisTactic => 'Назви тактику';

  @override
  String get tacticsNameHint => 'напр. Високий пресинг 4-3-3';

  @override
  String get tacticsCancel => 'Скасувати';

  @override
  String get tacticsSave => 'Зберегти';

  @override
  String get tacticsTapToAssign => 'Торкнись, щоб призначити';

  @override
  String get tacticsHoldDragSub =>
      'Утримуй запасного й перетягни на гравця, щоб випустити його на поле.';

  @override
  String get hubContinue => 'Продовжити';

  @override
  String get hubBrackets => 'Сітки';

  @override
  String hubCouldNotLoad(String error) {
    return 'Не вдалося завантажити.\n$error';
  }

  @override
  String hubCouldNotLoadFinances(String error) {
    return 'Не вдалося завантажити фінанси.\n$error';
  }

  @override
  String hubCouldNotLoadSave(String error) {
    return 'Не вдалося завантажити збереження.\n$error';
  }

  @override
  String get hubSaveNotFound => 'Збереження не знайдено.';

  @override
  String get hubUnknown => 'Невідомо';

  @override
  String hubWorldChampionsYear(int year) {
    return 'ЧЕМПІОНИ СВІТУ $year';
  }

  @override
  String get hubCycleComplete => 'Цикл завершено.';

  @override
  String get hubYourJob => 'ТВОЯ РОБОТА';

  @override
  String get hubStayProject => 'Залишитися й продовжити проєкт';

  @override
  String get hubChooseNextJob => 'ОБЕРИ НАСТУПНУ РОБОТУ';

  @override
  String get hubOffersOnTable => 'ПРОПОЗИЦІЇ НА СТОЛІ';

  @override
  String hubOfferSubtitle(String tier, int position) {
    return '$tier · №$position у світі';
  }

  @override
  String hubContinueWith(String nation) {
    return 'Продовжити: $nation';
  }

  @override
  String get hubYourNation => 'твоя країна';

  @override
  String get hubTakeTheJob => 'Прийняти роботу';

  @override
  String get hubFederationFinances => 'ФІНАНСИ ФЕДЕРАЦІЇ';

  @override
  String get hubBudgetIntro =>
      'Твоє перше завдання в наступному циклі: встановити бюджет федерації й розподілити його між відділами.';

  @override
  String get hubStarting => 'Починаємо…';

  @override
  String get hubBeginNextCycle => 'Почати наступний цикл';

  @override
  String get hubContinueCareer => 'Продовжити кар’єру';

  @override
  String get hubBackToSaves => 'Назад до збережень';

  @override
  String get hubOpeningBalance => 'Початковий баланс';

  @override
  String get hubCentralFunding => 'Центральне фінансування';

  @override
  String get hubPrizeMoney => 'Призові';

  @override
  String get hubCommercialReturn => 'Комерційні доходи';

  @override
  String get hubAvailableToInvest => 'Доступно для інвестицій';

  @override
  String hubReputation(String label, int rep) {
    return 'Репутація: $label ($rep)';
  }

  @override
  String get hubNationalHero => 'Національний герой';

  @override
  String get hubFinal => 'Фінал';

  @override
  String get hubStageRoundOf32 => '1/16 фіналу';

  @override
  String get hubStageThirdPlace => 'Матч за третє місце';

  @override
  String get hubEventAdvanceWorld => 'Прокрутити світ';

  @override
  String hubEventStartCycle(int year) {
    return 'Почати цикл $year';
  }

  @override
  String hubEventWorldChampions(String nation) {
    return 'Чемпіони світу: $nation';
  }

  @override
  String get hubEventSetBudget => 'Встанови бюджет федерації';

  @override
  String get hubEventSetBudgetSub =>
      'Розподіли цьогорічні кошти до початку сезону';

  @override
  String get hubEventNaturalization => 'Розглянути пропозицію натуралізації';

  @override
  String get hubEventNaturalizationSub =>
      'Іноземний гравець хоче грати за тебе';

  @override
  String get hubEventCampaignVerdict => 'Кампанію завершено: дивись вердикт';

  @override
  String get hubEventCampaignComplete => 'Кампанію завершено';

  @override
  String get hubEventIntercontinentalPlayoff => 'Міжконтинентальний плей-оф';

  @override
  String get hubEventWatchWcDraw => 'Дивись жеребкування чемпіонату світу';

  @override
  String get hubEventWorldCupHere => 'Чемпіонат світу розпочався';

  @override
  String get hubEventWatchFinalsDraw => 'Дивись жеребкування фіналів';

  @override
  String get hubEventFinalsHere => 'Фінальна частина розпочалася';

  @override
  String get hubEventPlayWcRound => 'Зіграти наступний раунд чемпіонату світу';

  @override
  String hubEventPlayCupMatch(String cup) {
    return 'Зіграти наступний матч: $cup';
  }

  @override
  String get hubEventPlayNationsCupMatch =>
      'Зіграти наступний матч Nations Cup';

  @override
  String get hubEventWatchNationsCupDraw => 'Дивись жеребкування Nations Cup';

  @override
  String get hubEventWatchHostSelection => 'Дивись вибір господаря';

  @override
  String get hubEventWatchQualifyingDraw => 'Дивись жеребкування кваліфікації';

  @override
  String get hubEventWatchWcHostSelection =>
      'Дивись вибір господаря чемпіонату світу';

  @override
  String get hubEventWatchWcQualifyingDraw =>
      'Дивись жеребкування кваліфікації чемпіонату світу';

  @override
  String get hubEventArrangeFriendlies => 'Домовитися про товариські';

  @override
  String hubEventFriendliesSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ти ще не заповнив $count відкритого вікна товариських',
      many: 'Ти ще не заповнив $count відкритих вікон товариських',
      few: 'Ти ще не заповнив $count відкриті вікна товариських',
      one: 'Ти ще не заповнив $count відкрите вікно товариських',
    );
    return '$_temp0';
  }

  @override
  String get hubEventReshapeXi => 'Перебудуй стартовий склад';

  @override
  String hubEventReshapeOutSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count гравця основи недоступні (дискваліфікація або травма). Обери заміни',
      many:
          '$count гравців основи недоступні (дискваліфікація або травма). Обери заміни',
      few:
          '$count гравці основи недоступні (дискваліфікація або травма). Обери заміни',
      one:
          '$count гравець основи недоступний (дискваліфікація або травма). Обери заміну',
    );
    return '$_temp0';
  }

  @override
  String hubEventReshapeShortSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'У стартовому складі бракує гравців. Заповни вільні місця',
      many: 'У стартовому складі бракує гравців. Заповни вільні місця',
      few: 'У стартовому складі бракує гравців. Заповни вільні місця',
      one: 'У стартовому складі бракує гравців. Заповни вільне місце',
    );
    return '$_temp0';
  }

  @override
  String hubEventPlayOpponent(String opponent) {
    return 'Грати: $opponent';
  }

  @override
  String get hubEventContinentalFinalsFallback => 'континентальні фінали';

  @override
  String get hubCallUpFriendlies => 'Оголоси склад на товариські';

  @override
  String get hubCallUpRequalify => 'Оголоси склад на кваліфікацію знову';

  @override
  String get hubCallUpWorldCup => 'Оголоси склад на чемпіонат світу';

  @override
  String get hubCallUpFinals => 'Оголоси склад на фінали';

  @override
  String get hubCallUpNationsCup => 'Оголоси склад на Nations Cup';

  @override
  String get hubCallUpQualifying => 'Оголоси склад на кваліфікацію';

  @override
  String get hubCallUpGeneric => 'Оголоси склад';

  @override
  String get hubHost => 'Господар';

  @override
  String get hubGoldenBoot => 'Золота бутса';

  @override
  String hubGoldenBootValue(String name, int goals) {
    return '$name · голів: $goals';
  }

  @override
  String get hubPens => '(пен.)';

  @override
  String get hubNationalHub => 'ШТАБ-КВАРТИРА ФЕДЕРАЦІЇ';

  @override
  String get hubMessages => 'Повідомлення';

  @override
  String get hubWorldChampions => 'ЧЕМПІОНИ СВІТУ';

  @override
  String get hubViewBracket => 'Дивитися сітку ›';

  @override
  String get hubBoardDelighted => 'У захваті';

  @override
  String get hubBoardPleased => 'Задоволена';

  @override
  String get hubBoardExpectingMore => 'Чекає більшого';

  @override
  String get hubBoardConcerned => 'Занепокоєна';

  @override
  String get hubBoardJobAtRisk => 'Робота під загрозою';

  @override
  String get hubBoard => 'РАДА';

  @override
  String hubBoardObjective(String label) {
    return 'Завдання від ради: $label';
  }

  @override
  String hubObjectiveMet(String result) {
    return 'ВИКОНАНО · $result';
  }

  @override
  String hubObjectiveMissed(String result) {
    return 'ПРОВАЛЕНО · $result';
  }

  @override
  String get hubNoMoreFixtures => 'У цьому циклі матчів більше немає.';

  @override
  String get hubVs => 'ПРОТИ';

  @override
  String hubWorldRank(int rank) {
    return '№$rank';
  }

  @override
  String get hubWorldRankLabel => 'Світовий рейтинг';

  @override
  String get hubSquadStatus => 'СТАН СКЛАДУ';

  @override
  String hubPlayers(int count) {
    return 'Гравців: $count';
  }

  @override
  String get hubAvgRating => 'Сер. рейтинг';

  @override
  String get hubMorale => 'Дух';

  @override
  String get hubManageTeam => 'Керувати командою';

  @override
  String get hubGroupsToBeDrawn =>
      'Групи ще не сформовано. Дивись жеребкування, щоб їх дізнатися.';

  @override
  String hubGroupName(String name) {
    return 'ГРУПА $name';
  }

  @override
  String get hubTblTeam => 'КОМАНДА';

  @override
  String get hubTblP => 'І';

  @override
  String get hubTblGd => 'РМ';

  @override
  String get hubTblPts => 'О';

  @override
  String get homeSettings => 'Налаштування';

  @override
  String get homeLeadTheNation => 'ОЧОЛЬ ЗБІРНУ';

  @override
  String get homeYourNation => 'твоя країна';

  @override
  String get homeNewGame => 'Нова гра';

  @override
  String get homeAllSaves => 'Усі збереження';

  @override
  String get homeLoadGame => 'Завантажити гру';

  @override
  String get homeContinue => 'ПРОДОВЖИТИ';

  @override
  String homeRoadToWorldCup(String date, int year) {
    return '$date · Шлях до чемпіонату світу $year';
  }

  @override
  String get careerManageSaves => 'Керувати збереженнями';

  @override
  String get careerNewGameTitle => 'НОВА ГРА';

  @override
  String careerCouldNotLoadNation(String error) {
    return 'Не вдалося завантажити країну.\n$error';
  }

  @override
  String get careerNationNotFound => 'Країну не знайдено.';

  @override
  String careerWorldRankNum(int rank) {
    return 'МІСЦЕ У СВІТІ #$rank';
  }

  @override
  String get careerManagerName => 'Ім’я тренера';

  @override
  String get careerManagerNameHint => 'напр. Алекс Фергюсон';

  @override
  String get careerBeginsBlurb =>
      'Твоя кар’єра починається у вересні 2026 року, на шляху до чемпіонату світу 2030.';

  @override
  String get careerFreeCycleNote =>
      'Безкоштовно на один повний чотирирічний цикл: кваліфікація, континентальний чемпіонат і чемпіонат світу, на двох збереженнях. Після цього один платіж відкриває нескінченні цикли.';

  @override
  String get careerStartCareer => 'Почати кар’єру';

  @override
  String get careersTitle => 'КАР’ЄРИ';

  @override
  String get careerManagerCareer => 'Кар’єра тренера';

  @override
  String get careerManagerCareerSubtitle =>
      'Усі цикли, які ти провів, і загальний підсумок';

  @override
  String get careerSummaryTitle => 'Підсумок кар’єри';

  @override
  String get careerSummarySubtitle => 'Твоя шафа з трофеями та рекорд тренера';

  @override
  String get careerAchievements => 'Досягнення';

  @override
  String get careerAchievementsSubtitle => 'Віхи, титули та задоволення ради';

  @override
  String get careerChallenges => 'Виклики';

  @override
  String get careerChallengesSubtitle => 'Жорсткі випробування на всю кар’єру';

  @override
  String get careerTeamRecords => 'Рекорди команди';

  @override
  String get careerTeamRecordsSubtitle =>
      'Найкращі бомбардири та рекордсмени за матчами за всі часи';

  @override
  String get careerMyMatches => 'Мої матчі';

  @override
  String get careerMyMatchesSubtitle => 'Кожен результат і майбутній матч';

  @override
  String get careerTitle => 'КАР’ЄРА';

  @override
  String careerCouldNotLoadCareer(String error) {
    return 'Не вдалося завантажити кар’єру.\n$error';
  }

  @override
  String get careerNoCareer => 'Немає кар’єри.';

  @override
  String get careerTrophyCabinet => 'ШАФА З ТРОФЕЯМИ';

  @override
  String get careerTournamentHistory => 'ІСТОРІЯ ТУРНІРІВ';

  @override
  String get careerNoTournamentsYet => 'Ще немає завершених турнірів.';

  @override
  String get careerTeamFallback => 'Команда';

  @override
  String careerWorldNum(int rank) {
    return 'СВІТ #$rank';
  }

  @override
  String careerPointsNum(int points) {
    return '$points ОЧ.';
  }

  @override
  String careerSeasonNum(int season) {
    return 'СЕЗОН $season';
  }

  @override
  String get careerStatPlayedShort => 'І';

  @override
  String get careerStatsHeading => 'У ЦИФРАХ';

  @override
  String get careerStatsWinRate => '% перемог';

  @override
  String get careerStatsGoalsFor => 'Забито';

  @override
  String get careerStatsGoalsAgainst => 'Пропущено';

  @override
  String get careerStatsGoalDiff => 'Різн. м’ячів';

  @override
  String get careerStatsCleanSheets => 'Сухі матчі';

  @override
  String get careerStatsBiggestWin => 'Найбільша перемога';

  @override
  String get careerStatsWinStreak => 'Серія перемог';

  @override
  String get careerStatsUnbeaten => 'Серія без поразок';

  @override
  String get careerStatsShootouts => 'Серії пенальті';

  @override
  String get careerStatsHatTricks => 'Хет-трики';

  @override
  String get careerStatsMotms => 'Гравець матчу';

  @override
  String get careerStatsBestRating => 'Найкращий рейтинг';

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
  String get careerNoSilverware => 'Трофеїв ще немає. Піди й виграй.';

  @override
  String get careerMedalGold => 'ЗОЛОТО';

  @override
  String get careerMedalSilver => 'СРІБЛО';

  @override
  String get careerMedalBronze => 'БРОНЗА';

  @override
  String careerWinnersName(String name) {
    return 'Переможці: $name';
  }

  @override
  String get careerSavesTitle => 'ЗБЕРЕЖЕННЯ';

  @override
  String careerCouldNotLoadSaves(String error) {
    return 'Не вдалося завантажити збереження.\n$error';
  }

  @override
  String careerSlotsCount(int used, int limit) {
    return 'СЛОТИ  $used/$limit';
  }

  @override
  String get careerThisSave => 'це збереження';

  @override
  String get careerSlotsFull => 'Слоти заповнені';

  @override
  String careerSlotsUsed(int used) {
    return 'СЛОТИ  $used';
  }

  @override
  String get careerSlotsUnlockMore => 'Розблокувати більше збережень';

  @override
  String get careerSlotsKeepNote =>
      'Усі твої наявні збереження залишаються доступними. Розблокування потрібне лише для нового.';

  @override
  String get careerNewGame => 'Нова гра';

  @override
  String get careerDeleteSaveTitle => 'Видалити збереження?';

  @override
  String careerDeleteSaveBody(String label) {
    return 'Це назавжди видалить кар’єру: $label.';
  }

  @override
  String get careerCancel => 'Скасувати';

  @override
  String get careerDelete => 'Видалити';

  @override
  String get careerNoSavesYet =>
      'Збережень ще немає.\nПочни нову гру, щоб очолити збірну.';

  @override
  String get careerUnknownNation => 'Невідомо';

  @override
  String careerPlayedMinutes(int minutes) {
    return '$minutes хв';
  }

  @override
  String careerPlayedHours(int hours, int minutes) {
    return '$hours год $minutes хв';
  }

  @override
  String careerLastPlayed(String when) {
    return 'Остання гра: $when';
  }

  @override
  String get careerJustNow => 'щойно';

  @override
  String get careerYesterday => 'учора';

  @override
  String careerMinutesAgo(int n) {
    return '$n хв тому';
  }

  @override
  String careerHoursAgo(int n) {
    return '$n год тому';
  }

  @override
  String careerDaysAgo(int n) {
    return '$n дн. тому';
  }

  @override
  String careerRoadToWorldCup(int year) {
    return 'Шлях до чемпіонату світу $year';
  }

  @override
  String get careerManagerCareerTitle => 'КАР’ЄРА ТРЕНЕРА';

  @override
  String careerCouldNotLoad(String error) {
    return 'Не вдалося завантажити.\n$error';
  }

  @override
  String get careerCycleByCycle => 'ЦИКЛ ЗА ЦИКЛОМ';

  @override
  String careerCyclesNationsLed(int cycles, int nations) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles циклу',
      many: '$cycles циклів',
      few: '$cycles цикли',
      one: '$cycles цикл',
    );
    String _temp1 = intl.Intl.pluralLogic(
      nations,
      locale: localeName,
      other: 'очолено $nations збірної',
      many: 'очолено $nations збірних',
      few: 'очолено $nations збірні',
      one: 'очолено $nations збірну',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get careerStatTitles => 'Титули';

  @override
  String get careerStatPlayed => 'Ігор';

  @override
  String get careerStatWon => 'Перемог';

  @override
  String get careerStatDrawn => 'Нічиїх';

  @override
  String get careerStatLost => 'Поразок';

  @override
  String careerGoalsWinRate(
    int goalsFor,
    int goalsAgainst,
    String gd,
    int winRate,
  ) {
    return 'Голи $goalsFor–$goalsAgainst  ($gd)  ·  Перемоги $winRate%';
  }

  @override
  String get careerRecordResults => 'РЕКОРДНІ РЕЗУЛЬТАТИ';

  @override
  String get careerBestWin => 'Найкраща перемога';

  @override
  String get careerWorstDefeat => 'Найгірша поразка';

  @override
  String careerVsOpponentDate(String opponent, String date) {
    return 'проти $opponent · $date';
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
  String get careerWorldCupLabel => 'Чемпіонат світу';

  @override
  String get careerContinentalLabel => 'Континентальний';

  @override
  String get messagesTitle => 'ПОВІДОМЛЕННЯ';

  @override
  String get messagesNoMessagesYet => 'Повідомлень ще немає.';

  @override
  String messagesCouldNotLoad(String error) {
    return 'Не вдалося завантажити повідомлення.\n$error';
  }

  @override
  String get messagesDone => 'Готово';

  @override
  String get messagesNext => 'Далі';

  @override
  String get rankingWorldRanking => 'СВІТОВИЙ РЕЙТИНГ';

  @override
  String rankingCouldNotLoad(String error) {
    return 'Не вдалося завантажити рейтинг.\n$error';
  }

  @override
  String get rankingNoRanking => 'Немає рейтингу.';

  @override
  String get rankingAll => 'УСІ';

  @override
  String get rankingYourTeam => 'ТВОЯ КОМАНДА';

  @override
  String get rankingYourRankingOverTime => 'ТВІЙ РЕЙТИНГ З ЧАСОМ';

  @override
  String rankingNowRank(int rank) {
    return 'зараз #$rank';
  }

  @override
  String rankingBestWorst(int best, int worst) {
    return 'найкраще #$best · найгірше #$worst';
  }

  @override
  String get friendliesTitle => 'ТОВАРИСЬКІ МАТЧІ';

  @override
  String friendliesLoadError(String error) {
    return 'Не вдалося завантажити товариські матчі.\n$error';
  }

  @override
  String get friendliesContinue => 'Продовжити';

  @override
  String friendliesArrangeIntro(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count вільного вікна',
      many: '$count вільних вікон',
      few: '$count вільні вікна',
      one: '$count вільне вікно',
    );
    return 'Організуй розминкові матчі перед наступним офіційним матчем: $_temp0. Торкнись суперника або залиш вікно вільним.';
  }

  @override
  String get friendliesFree => 'Вільно';

  @override
  String matchGoalsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ГОЛА',
      many: '$count ГОЛІВ',
      few: '$count ГОЛИ',
      one: '$count ГОЛ',
    );
    return '$_temp0';
  }

  @override
  String get matchGoalsTitle => 'ГОЛИ';

  @override
  String get matchGoalsNone => 'Без голів';

  @override
  String get matchGoalPenalty => 'ПЕН';

  @override
  String get matchGoalSetPiece => 'СТП';

  @override
  String matchGoalAssist(String name) {
    return 'асист $name';
  }

  @override
  String get friendliesHome => 'ВДОМА';

  @override
  String get friendliesAway => 'НА ВИЇЗДІ';

  @override
  String get friendliesNoneThisWindow => 'Без товариських матчів у цьому вікні';

  @override
  String friendliesConfirmCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count товариського матчу',
      many: '$count товариських матчів',
      few: '$count товариські матчі',
      one: '$count товариський матч',
    );
    return 'Підтвердити: $_temp0';
  }

  @override
  String get friendliesMonthJan => 'Січ';

  @override
  String get friendliesMonthFeb => 'Лют';

  @override
  String get friendliesMonthMar => 'Бер';

  @override
  String get friendliesMonthApr => 'Кві';

  @override
  String get friendliesMonthMay => 'Тра';

  @override
  String get friendliesMonthJun => 'Чер';

  @override
  String get friendliesMonthJul => 'Лип';

  @override
  String get friendliesMonthAug => 'Сер';

  @override
  String get friendliesMonthSep => 'Вер';

  @override
  String get friendliesMonthOct => 'Жов';

  @override
  String get friendliesMonthNov => 'Лис';

  @override
  String get friendliesMonthDec => 'Гру';

  @override
  String get resultsMyMatches => 'МОЇ МАТЧІ';

  @override
  String resultsCouldNotLoad(String error) {
    return 'Не вдалося завантажити результати.\n$error';
  }

  @override
  String get resultsNoFixtures => 'Немає матчів.';

  @override
  String get resultsVs => 'проти';

  @override
  String get resultsStageQualifier => 'КВАЛІФІКАЦІЯ';

  @override
  String get resultsStageFriendly => 'ТОВАРИСЬКИЙ';

  @override
  String get resultsStageGroupStage => 'ГРУПОВИЙ ЕТАП';

  @override
  String get resultsStageSemiFinal => 'ПІВФІНАЛ';

  @override
  String get resultsStageFinal => 'ФІНАЛ';

  @override
  String get resultsStageContinentalClash => 'CONTINENTAL CLASH';

  @override
  String get resultsStageFinalsGroup => 'ГРУПА ФІНАЛІВ';

  @override
  String get resultsStageRoundOf32 => '1/16 ФІНАЛУ';

  @override
  String get resultsStageRoundOf16 => '1/8 ФІНАЛУ';

  @override
  String get resultsStageQuarterFinal => 'ЧВЕРТЬФІНАЛ';

  @override
  String get resultsStageThirdPlace => '3-Є МІСЦЕ';

  @override
  String get matchSetupWarnCaptain =>
      'Капітана не призначено. Торкнись, щоб дати комусь пов’язку';

  @override
  String matchSetupWarnCaptainInjured(String name) {
    return '$name: травма, не може вивести команду. Торкнись, щоб передати пов’язку';
  }

  @override
  String matchSetupWarnCaptainSuspended(String name) {
    return '$name: дискваліфікація на цей матч. Торкнись, щоб передати пов’язку';
  }

  @override
  String matchSetupWarnCaptainDropped(String name) {
    return '$name: має пов’язку, але не в заявці. Торкнись, щоб передати її';
  }

  @override
  String get matchSetupWarnSetPieces =>
      'Виконавців стандартів не призначено. Торкнись, щоб обрати, хто б’є';

  @override
  String get matchSetupWarnBoth =>
      'Немає ні капітана, ні виконавців стандартів. Торкнись, щоб призначити';

  @override
  String matchStageMatchday(int matchday) {
    return 'ТУР $matchday';
  }

  @override
  String get squadCaptain => 'Капітан';

  @override
  String deptEffectYouth(int points) {
    return 'Вихованці академії приходять приблизно на $points кращими за загальним рівнем';
  }

  @override
  String deptEffectCommercial(String amount) {
    return '$amount повертається наприкінці циклу';
  }

  @override
  String deptEffectMedical(int percent) {
    return 'На $percent% менше травм';
  }

  @override
  String deptEffectNaturalisation(int percent) {
    return 'Шанс $percent%, що іноземний гравець попросить змінити збірну';
  }

  @override
  String deptEffectBoard(int points) {
    return '+$points терпіння ради, перш ніж твоїй посаді загрожуватиме небезпека';
  }

  @override
  String get deptEffectNone => 'Без фінансування ефекту немає';

  @override
  String get statsBestRated => 'Рейтинги';

  @override
  String get statsMyCareer => 'Кар’єра';

  @override
  String get statsBestAverageRating => 'НАЙКРАЩИЙ СЕРЕДНІЙ РЕЙТИНГ';

  @override
  String get statsMyCareerRecord => 'ТВІЙ РЕКОРД';

  @override
  String get statsNoRatingsRecorded => 'Рейтингів матчів ще немає.';

  @override
  String get statsGroupRecord => 'Баланс';

  @override
  String get statsGroupRuns => 'Серії';

  @override
  String get statsGroupExtremes => 'Крайнощі';

  @override
  String get statsGroupSplits => 'Вдома і на виїзді';

  @override
  String get statsGroupSquad => 'Твої гравці';

  @override
  String get statsPlayed => 'Зіграно матчів';

  @override
  String get statsWinDrawLoss => 'Перемоги–нічиї–поразки';

  @override
  String get statsWinRate => '% перемог';

  @override
  String get statsGoals => 'Забито:пропущено';

  @override
  String get statsCleanSheets => 'Сухі матчі';

  @override
  String get statsFailedToScore => 'Без забитого гола';

  @override
  String get statsLongestWinStreak => 'Найдовша серія перемог';

  @override
  String get statsLongestUnbeaten => 'Найдовша серія без поразок';

  @override
  String get statsLongestCleanSheets => 'Найдовша серія сухих матчів';

  @override
  String get statsLongestWinless => 'Найдовша серія без перемог';

  @override
  String get statsCurrentRun => 'Поточна серія без поразок';

  @override
  String get statsBiggestWin => 'Найбільша перемога';

  @override
  String get statsHeaviestDefeat => 'Найважча поразка';

  @override
  String get statsMostGoalsInAGame => 'Найбільше голів за матч';

  @override
  String get statsShootouts => 'Серії пенальті: перемоги–поразки';

  @override
  String get statsComebackWins => 'Перемоги з відставання';

  @override
  String get statsHome => 'Вдома';

  @override
  String get statsAway => 'На виїзді';

  @override
  String get statsNeutral => 'Нейтральне поле';

  @override
  String get statsCompetitive => 'Офіційні';

  @override
  String get statsFriendlies => 'Товариські';

  @override
  String get statsHatTricks => 'Хет-трики';

  @override
  String get statsBraces => 'Дублі';

  @override
  String get statsMotms => 'Нагороди гравцю матчу';

  @override
  String get statsAssists => 'Асисти';

  @override
  String get statsCards => 'Картки';

  @override
  String get statsBestRating => 'Найкращий індивідуальний рейтинг';

  @override
  String statsAppsShort(int apps) {
    return 'ігор: $apps';
  }

  @override
  String statsMotmShort(int motms) {
    return 'ГМ: $motms';
  }

  @override
  String get captainArmband => 'К';

  @override
  String get captainCurrent => 'Капітан. Торкнись, щоб зняти пов’язку';

  @override
  String get captainFitBorn => 'Прирождений лідер';

  @override
  String get captainFitNatural => 'Природний капітан';

  @override
  String get captainFitCapable => 'Може носити пов’язку';

  @override
  String get captainFitUnproven => 'Ще не лідер';

  @override
  String get captainNone => 'Капітана не призначено';

  @override
  String captainMoraleBoost(int morale) {
    return '+$morale до духу команди';
  }

  @override
  String get resultsCategoryWorldCupQualifying => 'Відбір до чемпіонату світу';

  @override
  String get resultsCategoryFriendlies => 'Товариські матчі';

  @override
  String get resultsCategoryContinentalClash => 'Continental Clash';

  @override
  String get resultsCategoryNationsCup => 'Nations Cup';

  @override
  String get resultsCategoryContinentalCup => 'Континентальний кубок';

  @override
  String get resultsCategoryWorldCupQualifyingShort => 'Відбір до ЧС';

  @override
  String get resultsCategoryContinentalQualifyingShort =>
      'Відбір до конт. кубка';

  @override
  String get resultsCategoryContinentalQualifying =>
      'Відбір до континентального кубка';

  @override
  String get resultsCategoryWorldCupFinals =>
      'Фінальна частина чемпіонату світу';

  @override
  String get resultsRoundResults => 'РЕЗУЛЬТАТИ ТУРУ';

  @override
  String get resultsFriendlyInternationals => 'ТОВАРИСЬКІ МАТЧІ ЗБІРНИХ';

  @override
  String get resultsKnockout => 'Плей-оф';

  @override
  String resultsEarlierMatches(int count) {
    return 'Попередні матчі ($count)';
  }

  @override
  String resultsMatchday(int matchday) {
    return 'ТУР $matchday';
  }

  @override
  String get resultsContinue => 'Продовжити';

  @override
  String resultsGroup(String name) {
    return 'ГРУПА $name';
  }

  @override
  String get achievementsScreenTitle => 'ДОСЯГНЕННЯ';

  @override
  String get achievementsChallengesTooltip => 'Виклики';

  @override
  String get achievementsChallengesHeading => 'ВИКЛИКИ';

  @override
  String get achievementsBrutalTests => 'Жорсткі випробування на всю кар’єру';

  @override
  String achievementsCouldNotLoad(String error) {
    return 'Не вдалося завантажити.\n$error';
  }

  @override
  String achievementsUnlockedCount(int earned, int total) {
    return 'Розблоковано: $earned / $total';
  }

  @override
  String achievementsConqueredCount(int done, int total) {
    return 'Підкорено: $done / $total';
  }

  @override
  String get achievementsBoardSatisfaction => 'ЗАДОВОЛЕННЯ РАДИ';

  @override
  String achievementsUnlockedBanner(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ДОСЯГНЕННЯ РОЗБЛОКОВАНО',
      many: '$count ДОСЯГНЕНЬ РОЗБЛОКОВАНО',
      few: '$count ДОСЯГНЕННЯ РОЗБЛОКОВАНО',
      one: 'ДОСЯГНЕННЯ РОЗБЛОКОВАНО',
    );
    return '$_temp0';
  }

  @override
  String get achCatWins => 'Перемоги';

  @override
  String get achCatMatches => 'Матчі';

  @override
  String get achCatQualifications => 'Кваліфікації';

  @override
  String get achCatTitles => 'Титули';

  @override
  String get achCatMisc => 'Інше';

  @override
  String get achCatMega => 'Мега';

  @override
  String get achCatGoals => 'Голи';

  @override
  String get achCatStreaks => 'Серії';

  @override
  String get achTierBronze => 'Бронза';

  @override
  String get achTierSilver => 'Срібло';

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
      many: '$count голів',
      few: '$count голи',
      one: '$count гол',
    );
    return '$_temp0';
  }

  @override
  String achGoalsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Забий $count гола.',
      many: 'Забий $count голів.',
      few: 'Забий $count голи.',
      one: 'Забий $count гол.',
    );
    return '$_temp0';
  }

  @override
  String achCleanSheets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count сухого матчу',
      many: '$count сухих матчів',
      few: '$count сухі матчі',
      one: '$count сухий матч',
    );
    return '$_temp0';
  }

  @override
  String achCleanSheetsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Відіграй на нуль $count матчу.',
      many: 'Відіграй на нуль $count матчів.',
      few: 'Відіграй на нуль $count матчі.',
      one: 'Відіграй на нуль $count матч.',
    );
    return '$_temp0';
  }

  @override
  String get achStreakWin5 => 'Звичка перемагати';

  @override
  String get achStreakWin5Desc => 'Виграй п’ять матчів поспіль.';

  @override
  String get achStreakWin10 => 'На хвилі';

  @override
  String get achStreakWin10Desc => 'Виграй десять матчів поспіль.';

  @override
  String get achStreakWin20 => 'Каток';

  @override
  String get achStreakWin20Desc => 'Виграй двадцять матчів поспіль.';

  @override
  String get achUnbeaten15 => 'Важко обіграти';

  @override
  String get achUnbeaten15Desc => 'Проведи п’ятнадцять матчів без поразок.';

  @override
  String get achUnbeaten30 => 'Недоторканні';

  @override
  String get achUnbeaten30Desc => 'Проведи тридцять матчів без поразок.';

  @override
  String get achHattrick => 'Герой хет-трику';

  @override
  String get achHattrickDesc => 'Нехай гравець оформить хет-трик.';

  @override
  String get achMotm10 => 'Виділяється';

  @override
  String get achMotm10Desc => 'Отримай 10 нагород гравця матчу.';

  @override
  String get achMotm50 => 'Талісман';

  @override
  String get achMotm50Desc => 'Отримай 50 нагород гравця матчу.';

  @override
  String get achPerfect => 'Ідеальна десятка';

  @override
  String get achPerfectDesc => 'Нехай гравець отримає рейтинг матчу 9.5+.';

  @override
  String get achShootout => 'Лід у жилах';

  @override
  String get achShootoutDesc => 'Виграй п’ять серій пенальті.';

  @override
  String get achMassacre => 'Різанина';

  @override
  String get achMassacreDesc => 'Виграй матч із різницею 7 голів і більше.';

  @override
  String get achAnnihilation => 'Знищення';

  @override
  String get achAnnihilationDesc =>
      'Виграй матч із різницею 10 голів і більше.';

  @override
  String get chTierBronze => 'Бронза';

  @override
  String get chTierSilver => 'Срібло';

  @override
  String get chTierGold => 'Золото';

  @override
  String get chTierLegendary => 'Легендарний';

  @override
  String get chFirstSteps => 'У тренерській зоні';

  @override
  String get chFirstStepsDesc => 'Очолюй збірну 5 років.';

  @override
  String get chUnbeaten10 => 'На хвилі';

  @override
  String get chUnbeaten10Desc => 'Проведи 10 офіційних матчів без поразок.';

  @override
  String get chTwoNations => 'Новий виклик';

  @override
  String get chTwoNationsDesc => 'Очоль 2 різні збірні.';

  @override
  String get chCont1 => 'Континентальний чемпіон';

  @override
  String get chCont1Desc => 'Виграй континентальний чемпіонат.';

  @override
  String get chNc1 => 'Переможець Nations Cup';

  @override
  String get chNc1Desc => 'Виграй Nations Cup.';

  @override
  String get chWc1 => 'Чемпіон світу';

  @override
  String get chWc1Desc => 'Виграй чемпіонат світу.';

  @override
  String get chYears25 => 'Стара гвардія';

  @override
  String get chYears25Desc => 'Очолюй збірну 25 років.';

  @override
  String get chWc3 => 'Серійний переможець';

  @override
  String get chWc3Desc => 'Виграй 3 чемпіонати світу.';

  @override
  String get chWc5 => 'Династія';

  @override
  String get chWc5Desc => 'Виграй 5 чемпіонатів світу.';

  @override
  String get chWc10 => 'Безсмертний';

  @override
  String get chWc10Desc => 'Виграй 10 чемпіонатів світу.';

  @override
  String get chWc2Teams => 'Бутси в дорогу';

  @override
  String get chWc2TeamsDesc => 'Виграй чемпіонат світу з 2 різними збірними.';

  @override
  String get chWc3Teams => 'Мандрівник';

  @override
  String get chWc3TeamsDesc => 'Виграй чемпіонат світу з 3 різними збірними.';

  @override
  String get chWcStreak3 => 'Тричі поспіль';

  @override
  String get chWcStreak3Desc => 'Виграй 3 чемпіонати світу поспіль.';

  @override
  String get chWcAllconf => 'Підкорювач світу';

  @override
  String get chWcAllconfDesc =>
      'Виграй чемпіонат світу зі збірною з кожної конфедерації (6).';

  @override
  String get chCont5 => 'Король континенту';

  @override
  String get chCont5Desc => 'Виграй 5 континентальних чемпіонатів.';

  @override
  String get chContAll => 'Шлем шести континентів';

  @override
  String get chContAllDesc =>
      'Виграй континентальний чемпіонат кожної конфедерації (6).';

  @override
  String get chTreble => 'Чистий тріумф';

  @override
  String get chTrebleDesc =>
      'Виграй чемпіонат світу, континентальний титул і Nations Cup в одній кар’єрі.';

  @override
  String get chNations10 => 'Кочівник';

  @override
  String get chNations10Desc => 'Очоль 10 різних збірних.';

  @override
  String get chYears100 => 'Століття';

  @override
  String get chYears100Desc => 'Очолюй збірну 100 років.';

  @override
  String get chYears500 => 'Півтисячоліття';

  @override
  String get chYears500Desc => 'Очолюй збірну 500 років.';

  @override
  String get chYears1000 => 'Вічний';

  @override
  String get chYears1000Desc => 'Очолюй збірну 1000 років.';

  @override
  String get chGrandmaster => 'Гросмейстер';

  @override
  String get chGrandmasterDesc =>
      'Виграй 3 чемпіонати світу І 5 континентальних чемпіонатів.';

  @override
  String get chUndefeated => 'Недоторканні';

  @override
  String get chUndefeatedDesc =>
      'Виграй чемпіонат світу, не програвши жодного матчу.';

  @override
  String get chPerfectQual => 'Бездоганний шлях';

  @override
  String get chPerfectQualDesc =>
      'Виграй кожен матч кваліфікації до чемпіонату світу.';

  @override
  String get chMinnow => 'Диво аутсайдера';

  @override
  String get chMinnowDesc =>
      'Виграй чемпіонат світу зі збірною поза топ-32 світового рейтингу.';

  @override
  String get chGrandTour => 'Вдома і в гостях';

  @override
  String get chGrandTourDesc =>
      'Виграй чемпіонат світу як господар і ще один на виїзді.';

  @override
  String get chUnbeaten25 => 'Стіна';

  @override
  String get chUnbeaten25Desc => 'Проведи 25 офіційних матчів без поразок.';

  @override
  String get chGoals10k => 'Машина голів';

  @override
  String get chGoals10kDesc => 'Забий 10 000 голів за кар’єру.';

  @override
  String get chCleanSheets500 => 'Фортеця';

  @override
  String get chCleanSheets500Desc => 'Відіграй на нуль 500 матчів за кар’єру.';

  @override
  String get chHatTricks25 => 'Звичка до хет-триків';

  @override
  String get chHatTricks25Desc => 'Нехай твої гравці забиють 25 хет-триків.';

  @override
  String get chWinStreak25 => 'Нестримні';

  @override
  String get chWinStreak25Desc => 'Виграй 25 матчів поспіль.';

  @override
  String get chCont10 => 'Континентальна династія';

  @override
  String get chCont10Desc => 'Виграй 10 континентальних чемпіонатів.';

  @override
  String get chPcWc => 'Серійний чемпіон';

  @override
  String chPcWcDesc(int count) {
    return 'Виграй чемпіонат світу в цьому збереженні (разів: $count).';
  }

  @override
  String get chPcMajors => 'Колекціонер трофеїв';

  @override
  String chPcMajorsDesc(int count) {
    return 'Виграй великі трофеї (чемпіонат світу, континентальний чемпіонат або Nations Cup): $count.';
  }

  @override
  String get chPcUnbeaten => 'Залізна стіна';

  @override
  String chPcUnbeatenDesc(int count) {
    return 'Проведи офіційні матчі без поразок: $count.';
  }

  @override
  String get chPcNations => 'Мандрівний тренер';

  @override
  String chPcNationsDesc(int count) {
    return 'Очоль різні збірні: $count.';
  }

  @override
  String get chPcYears => 'Довга дистанція';

  @override
  String chPcYearsDesc(int count) {
    return 'Очолюй збірну: $count р.';
  }

  @override
  String achWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count перемоги',
      many: '$count перемог',
      few: '$count перемоги',
      one: '$count перемога',
    );
    return '$_temp0';
  }

  @override
  String achWinsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Виграй $count матчу.',
      many: 'Виграй $count матчів.',
      few: 'Виграй $count матчі.',
      one: 'Виграй $count матч.',
    );
    return '$_temp0';
  }

  @override
  String achMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count матчу',
      many: '$count матчів',
      few: '$count матчі',
      one: '$count матч',
    );
    return '$_temp0';
  }

  @override
  String achMatchesDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Зіграй $count матчу.',
      many: 'Зіграй $count матчів.',
      few: 'Зіграй $count матчі.',
      one: 'Зіграй $count матч.',
    );
    return '$_temp0';
  }

  @override
  String get achQualWc => 'Кваліфікація до ЧС';

  @override
  String get achQualWcDesc => 'Кваліфікуйся на чемпіонат світу.';

  @override
  String get achQualCont => 'Кваліфікація до континентального турніру';

  @override
  String get achQualContDesc =>
      'Кваліфікуйся на свій континентальний чемпіонат.';

  @override
  String get achTitleWc => 'Чемпіони світу';

  @override
  String get achTitleWcDesc => 'Виграй чемпіонат світу.';

  @override
  String get achTitleEuro => 'Чемпіони Європи';

  @override
  String get achTitleEuroDesc => 'Виграй Чемпіонат Європи.';

  @override
  String get achTitleCopa => 'Чемпіони Південної Америки';

  @override
  String get achTitleCopaDesc => 'Виграй Кубок Південної Америки.';

  @override
  String get achTitleAfcon => 'Чемпіони Африки';

  @override
  String get achTitleAfconDesc => 'Виграй Чемпіонат Африки.';

  @override
  String get achTitleAsia => 'Чемпіони Азії';

  @override
  String get achTitleAsiaDesc => 'Виграй Чемпіонат Азії.';

  @override
  String get achTitleConcacaf => 'Чемпіони Північної Америки';

  @override
  String get achTitleConcacafDesc => 'Виграй Кубок Північної Америки.';

  @override
  String get achTitleOfc => 'Чемпіони Океанії';

  @override
  String get achTitleOfcDesc => 'Виграй Кубок Океанії.';

  @override
  String get achTitleNations => 'Переможці Nations Cup';

  @override
  String get achTitleNationsDesc => 'Виграй Nations Cup.';

  @override
  String get achTitleClash => 'Переможці Continental Clash';

  @override
  String get achTitleClashDesc => 'Виграй Continental Clash.';

  @override
  String get achMarksman => 'Снайпер чемпіонату світу';

  @override
  String get achMarksmanDesc =>
      'Нехай гравець твого складу заб’є 6+ голів у фінальній частині чемпіонату світу.';

  @override
  String get achSweep => 'Чистий тріумф';

  @override
  String get achSweepDesc =>
      'Стань чемпіоном світу та континентальним чемпіоном в одній кар’єрі.';

  @override
  String get achAllstar => 'Зірка турніру';

  @override
  String get achAllstarDesc =>
      'Нехай гравця включать до Збірної турніру чемпіонату світу.';

  @override
  String get achGoldenboot => 'Золота бутса';

  @override
  String get achGoldenbootDesc =>
      'Нехай гравець твоєї збірної стане найкращим бомбардиром турніру.';

  @override
  String get achDemolition => 'Руйнація';

  @override
  String get achDemolitionDesc => 'Виграй матч із різницею 5 голів і більше.';

  @override
  String get achievementsNice => 'Чудово!';

  @override
  String get achievementsHardestTests =>
      'Найважчі випробування для тренера: на всю кар’єру й багато збірних.';

  @override
  String get achievementsThisSave => 'ЦЕ ЗБЕРЕЖЕННЯ';

  @override
  String get achievementsBrutalBadge => 'ЖОРСТКО';

  @override
  String get paywallGoPro => 'ОБИРАЙ UNLIMITED';

  @override
  String get paywallOneTimeUnlock => 'Одноразове розблокування. Без підписки.';

  @override
  String get paywallBenefitCarryOn =>
      'Це збереження триває рівно з того місця, де зупинилося, з усіма матчами за збірну, рекордами й суперництвом.';

  @override
  String get paywallBenefitNoAds =>
      'Без реклами, мікротранзакцій і підписки. Один платіж, і кожне майбутнє оновлення твоє.';

  @override
  String get paywallBenefitSaves =>
      'Скільки завгодно збережень. Грай за фаворита й за аутсайдера водночас і побач, наскільки по-різному читається та сама гра.';

  @override
  String get paywallBenefitEndless =>
      'Кожен цикл відтепер. Обери сімнадцятирічного сьогодні й дізнайся у 2034-му, чи ти розгледів талант.';

  @override
  String get paywallUnlocked => 'Unlimited розблоковано. Насолоджуйся!';

  @override
  String get paywallContactingStore => 'Зв’язок із магазином…';

  @override
  String paywallUnlockProPriced(String price) {
    return 'Розблокувати Unlimited · $price';
  }

  @override
  String get paywallRestorePurchases => 'Відновити покупки';

  @override
  String get paywallStoreUnavailable => 'Магазин недоступний';

  @override
  String get paywallStoreUnavailableNote =>
      'Не вдалося завантажити ціну. Перевір з’єднання й спробуй ще раз.';

  @override
  String get paywallTryAgain => 'Спробувати ще раз';

  @override
  String get gateTitle => 'ТВІЙ ПЕРШИЙ ЦИКЛ ЗАВЕРШЕНО';

  @override
  String get gateLead =>
      'Чотири роки це один цикл. Цього замало, щоб дізнатися, чи ти мав рацію.';

  @override
  String get gatePriceLead => 'Один платіж, назавжди';

  @override
  String get gateBuy => 'КУПИТИ Й ПРОДОВЖИТИ';

  @override
  String get gateExit => 'ВИЙТИ';

  @override
  String get federationNaturalisation => 'НАТУРАЛІЗАЦІЯ';

  @override
  String federationNaturalisedTitle(String name) {
    return 'Натуралізація: $name';
  }

  @override
  String federationNaturalisedBody(String name, String nation) {
    return 'Натуралізація завершена: $name. Тепер гравець має право виступати за збірну: $nation. Викличи його зі свого складу.';
  }

  @override
  String federationCouldNotLoadOffer(String error) {
    return 'Не вдалося завантажити пропозицію.\n$error';
  }

  @override
  String get federationContinue => 'Продовжити';

  @override
  String get federationOfferToSwitchAllegiance => 'ПРОПОЗИЦІЯ ЗМІНИТИ ЗБІРНУ';

  @override
  String federationPlayerMeta(String position, int age, String nation) {
    return '$position · $age р. · з: $nation';
  }

  @override
  String federationNaturalisationBlurb(
    String name,
    String playerNation,
    String sourceNation,
  ) {
    return '$name готовий натуралізуватися (зв’язки: $playerNation). Прийми пропозицію, і його можна буде викликати; відхили, і він залишиться в збірній: $sourceNation.';
  }

  @override
  String get federationDecline => 'Відхилити';

  @override
  String get federationNaturalise => 'Натуралізувати';

  @override
  String get federationBudgetLater => 'Вирішити пізніше';

  @override
  String get federationSetYourBudget => 'ВСТАНОВИ БЮДЖЕТ';

  @override
  String federationCouldNotLoadFinances(String error) {
    return 'Не вдалося завантажити фінанси.\n$error';
  }

  @override
  String get federationSaveNotFound => 'Збереження не знайдено.';

  @override
  String get federationBudgetHeading => 'БЮДЖЕТ ФЕДЕРАЦІЇ';

  @override
  String federationDistributeBudget(String amount) {
    return 'Розподіль $amount між відділами, щоб відкрити цикл. Витрачай мудро.';
  }

  @override
  String federationOverBudget(String amount) {
    return 'На $amount більше, ніж має федерація. Забери частину назад';
  }

  @override
  String get federationAllocateFullBudget =>
      'Розподіль увесь бюджет, щоб почати цикл.';

  @override
  String get federationConfirming => 'Підтверджуємо…';

  @override
  String get federationConfirmBudget => 'Підтвердити бюджет';

  @override
  String get federationFinances => 'ФІНАНСИ';

  @override
  String get federationInvestmentUpdated => 'Інвестиції оновлено.';

  @override
  String get federationDevelopment => 'РОЗВИТОК ФЕДЕРАЦІЇ';

  @override
  String get federationProjectedAtSeasonEnd => 'ПРОГНОЗ НА КІНЕЦЬ СЕЗОНУ';

  @override
  String get federationCentralFunding => 'Центральне фінансування';

  @override
  String get federationPrizeMoneySoFar => 'Призові на цей момент';

  @override
  String get federationCommercialReturn => 'Комерційна віддача';

  @override
  String get federationThisSeasonLocked => 'ЦЕЙ СЕЗОН (ЗАФІКСОВАНО)';

  @override
  String get federationInvestForNextSeason => 'ІНВЕСТИЦІЇ НА НАСТУПНИЙ СЕЗОН';

  @override
  String get federationNextSeasonImpact => 'ВПЛИВ НА НАСТУПНИЙ СЕЗОН';

  @override
  String get federationSaving => 'Зберігаємо…';

  @override
  String get federationConfirmInvestment => 'Підтвердити інвестиції';

  @override
  String get federationBalance => 'БАЛАНС ФЕДЕРАЦІЇ';

  @override
  String get federationCommittedToStaff => 'Зарезервовано на штаб';

  @override
  String get federationFreeToSpend => 'Вільні кошти';

  @override
  String get federationWagesNote =>
      'Зарплати списуються з балансу наприкінці циклу, тож ця сума вже зарезервована.';

  @override
  String get federationInvestAtCeremony =>
      'Інвестуй у наступний сезон на церемонії наприкінці циклу.';

  @override
  String federationLevelBadge(int level) {
    return 'Р$level';
  }

  @override
  String get federationAcademyProspects => 'Вихованці академії';

  @override
  String federationPlusOverall(int value) {
    return '+$value до рівня';
  }

  @override
  String get federationInjuryRisk => 'Ризик травм';

  @override
  String get federationNaturalisationChance => 'Шанс натуралізації';

  @override
  String get federationBoardPatience => 'Терпіння ради';

  @override
  String get federationUnallocated => 'НЕРОЗПОДІЛЕНО';

  @override
  String get nationsVitrineTitle => 'ВІТРИНА ЗБІРНОЇ';

  @override
  String nationsCouldNotLoad(String error) {
    return 'Не вдалося завантажити країну.\n$error';
  }

  @override
  String get nationsNoNation => 'Немає країни.';

  @override
  String get nationsHonours => 'ВІДЗНАКИ';

  @override
  String get nationsRankingHistory => 'ІСТОРІЯ СВІТОВОГО РЕЙТИНГУ';

  @override
  String get nationsTopScorers => 'НАЙКРАЩІ БОМБАРДИРИ ВСІХ ЧАСІВ';

  @override
  String get nationsTitles => 'ТИТУЛИ';

  @override
  String get nationsYourTeam => 'ТВОЯ ЗБІРНА';

  @override
  String get nationsWorld => 'СВІТ';

  @override
  String get nationsWorldCup => 'Чемпіонат світу';

  @override
  String get nationsContinental => 'Континентальний';

  @override
  String nationsAppearances(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count участі',
      many: '$count участей',
      few: '$count участі',
      one: '$count участь',
    );
    return '$_temp0';
  }

  @override
  String get nationsNotEnoughHistory =>
      'Історії поки замало. Зазирни за цикл-два.';

  @override
  String nationsBestRank(int rank) {
    return 'Найкраще: #$rank';
  }

  @override
  String nationsNowRank(int rank) {
    return 'Зараз: #$rank';
  }

  @override
  String get nationsNoGoals => 'Голів поки не зафіксовано.';

  @override
  String get nationsGoalsAbbrev => 'гол.';

  @override
  String get nationsHosts => 'ГОСПОДАРІ';

  @override
  String get nationsSelectTitle => 'ОБЕРИ ЗБІРНУ';

  @override
  String nationsCouldNotLoadNations(String error) {
    return 'Не вдалося завантажити країни.\n$error';
  }

  @override
  String get nationsNoMatch => 'Країн не знайдено.';

  @override
  String get nationsNationalLevel => 'РІВЕНЬ ЗБІРНОЇ';

  @override
  String get nationsSelectHeading => 'Обери збірну';

  @override
  String get nationsSearchHint => 'Шукати країну…';

  @override
  String get nationsRank => 'МІСЦЕ ';

  @override
  String get nationsPremium => 'PREMIUM';

  @override
  String get nationsSelect => 'ОБРАТИ';

  @override
  String get statsTeamRecords => 'РЕКОРДИ КОМАНДИ';

  @override
  String get statsRecordBook => 'Книга рекордів';

  @override
  String statsCouldNotLoadStats(String error) {
    return 'Не вдалося завантажити статистику.\n$error';
  }

  @override
  String get statsNoData => 'Немає даних.';

  @override
  String get statsTopScorers => 'НАЙКРАЩІ БОМБАРДИРИ';

  @override
  String get statsMostGamesPlayed => 'НАЙБІЛЬШЕ МАТЧІВ';

  @override
  String get statsTeam => 'Команда';

  @override
  String get statsTopScorersShort => 'Бомбардири';

  @override
  String get statsMostGames => 'Матчі';

  @override
  String get statsNoGoalsRecorded => 'Голів поки не зафіксовано.';

  @override
  String get statsUnknown => 'Невідомо';

  @override
  String get playerTitle => 'ГРАВЕЦЬ';

  @override
  String playerLoadError(String error) {
    return 'Не вдалося завантажити гравця.\n$error';
  }

  @override
  String get playerNotFound => 'Гравця не знайдено.';

  @override
  String get playerClub => 'КЛУБ';

  @override
  String get playerClubRole => 'У своєму клубі';

  @override
  String get playerPosition => 'Позиція';

  @override
  String get playerPotential => 'Потенціал';

  @override
  String get playerAge => 'Вік';

  @override
  String get playerValue => 'Вартість';

  @override
  String get clubFirstChoice => 'Грає щотижня';

  @override
  String get clubRotation => 'То в складі, то ні';

  @override
  String get clubFringe => 'Майже не грає';

  @override
  String get clubFrozenOut => 'Не грає';

  @override
  String clubAtClub(String club, String standing) {
    return '$club: $standing';
  }

  @override
  String yWinUpset0(String opponent, String score) {
    return 'Тридцять років дивлюся футбол, і такий поворот для мене повна несподіванка. $opponent обіграно $score.';
  }

  @override
  String yWinUpset1(String opponent, String score) {
    return 'Проти $opponent їм не давали жодного шансу. $score. Жодного, взагалі.';
  }

  @override
  String yWinUpset2(String opponent, String score) {
    return '$score проти $opponent. Ідіть будіть сусідів.';
  }

  @override
  String yWinUpset3(String opponent, String score) {
    return 'Про такі вечори розповідають онукам. $opponent $score.';
  }

  @override
  String yWinUpset4(String opponent, String score) {
    return '$score проти $opponent. Як би це не сталося, воно сталося.';
  }

  @override
  String yWinUpset5(String opponent, String score) {
    return 'На папері все було вирішено ще до свистка. $opponent $score каже протилежне.';
  }

  @override
  String yWinUpset6(String opponent, String score) {
    return 'Обіграли $opponent $score. За рік ніхто не повірить у цей рахунок.';
  }

  @override
  String yWinUpset7(String opponent, String score) {
    return '$opponent $score. Насолоджуйтесь, а потім гляньте на календар.';
  }

  @override
  String yWinUpset8(String opponent, String score) {
    return '$score проти $opponent, і вісімдесят хвилин із дев’яноста нам просто щастило.';
  }

  @override
  String yWinUpset9(String opponent, String score) {
    return 'Один вечір проти $opponent не перекреслює цілий рік. $score.';
  }

  @override
  String yWinUpset10(String opponent, String score) {
    return 'Обіграли $opponent $score, а тепер нам скажуть, що ми «вийшли на новий рівень». Ні, не вийшли.';
  }

  @override
  String yWinUpset11(String opponent, String score) {
    return '$opponent $score. Чудово. Спитайте мене ще раз, коли це справді матиме значення.';
  }

  @override
  String yWinRoutine0(String opponent, String score) {
    return 'Обіграли $opponent $score. Саме так, як і мало бути, і в цьому є задоволення.';
  }

  @override
  String yWinRoutine1(String opponent, String score) {
    return '$score над $opponent. Безжально, а це комплімент.';
  }

  @override
  String yWinRoutine2(String opponent, String score) {
    return '$opponent $score. Без метушні, без страху, без претензій.';
  }

  @override
  String yWinRoutine3(String opponent, String score) {
    return 'Акуратні $score проти $opponent. Ось як виглядає хороша команда у спокійний день.';
  }

  @override
  String yWinRoutine4(String opponent, String score) {
    return '$score проти $opponent. Роботу виконано, нового нічого не дізналися.';
  }

  @override
  String yWinRoutine5(String opponent, String score) {
    return 'Обіграли $opponent $score. Мали обіграти, і обіграли.';
  }

  @override
  String yWinRoutine6(String opponent, String score) {
    return 'Професійні $score над $opponent. Далі.';
  }

  @override
  String yWinRoutine7(String opponent, String score) {
    return '$opponent здолано $score. У архів і йдемо далі.';
  }

  @override
  String yWinRoutine8(String opponent, String score) {
    return '$score проти $opponent, а нам, бач, треба аплодувати. За те, що обіграли їх.';
  }

  @override
  String yWinRoutine9(String opponent, String score) {
    return 'Молодці всі, хто причетний до $score над $opponent, припускаю.';
  }

  @override
  String yWinRoutine10(String opponent, String score) {
    return '$opponent $score. Перемога над такою командою є мінімумом, а не досягненням.';
  }

  @override
  String yWinRoutine11(String opponent, String score) {
    return 'Обіграли $opponent $score, але виглядали при цьому натужно.';
  }

  @override
  String yWinTight0(String opponent, String score) {
    return '$score проти $opponent, і кожна хвилина виборена.';
  }

  @override
  String yWinTight1(String opponent, String score) {
    return 'Це вимагало характеру. $opponent $score.';
  }

  @override
  String yWinTight2(String opponent, String score) {
    return 'Обіграли $opponent $score важким шляхом, а саме такий шлях і запам’ятовується.';
  }

  @override
  String yWinTight3(String opponent, String score) {
    return '$score проти $opponent. Команди, що вигризають такі перемоги, ще залишаються в турнірі влітку.';
  }

  @override
  String yWinTight4(String opponent, String score) {
    return 'Нервово, негарно, але перемога. $opponent $score.';
  }

  @override
  String yWinTight5(String opponent, String score) {
    return 'Обіграли $opponent $score. Беріть три очки й ніколи не передивляйтеся цей матч.';
  }

  @override
  String yWinTight6(String opponent, String score) {
    return '$score. $opponent змусили нас боротися за кожен сантиметр.';
  }

  @override
  String yWinTight7(String opponent, String score) {
    return '$opponent $score. Негарно. Але рахується так само.';
  }

  @override
  String yWinTight8(String opponent, String score) {
    return '$score проти $opponent, і ми вдесятеро ускладнили собі життя.';
  }

  @override
  String yWinTight9(String opponent, String score) {
    return 'Ми не повинні були так тремтіти проти $opponent. $score.';
  }

  @override
  String yWinTight10(String opponent, String score) {
    return '$opponent $score. Виграли, але нічого доброго про себе не дізналися.';
  }

  @override
  String yWinTight11(String opponent, String score) {
    return '$score проти $opponent: рахунок, що лестить нам.';
  }

  @override
  String yDrew0(String opponent, String score) {
    return 'Очко проти $opponent, $score. Беремо й ідемо далі.';
  }

  @override
  String yDrew1(String opponent, String score) {
    return '$score з $opponent. Бувають і гірші вечори.';
  }

  @override
  String yDrew2(String opponent, String score) {
    return 'Втримали $opponent на $score. Не кожен матч має бути історією.';
  }

  @override
  String yDrew3(String opponent, String score) {
    return '$opponent $score. Очко є очко, а таблиця не питає, як воно дісталося.';
  }

  @override
  String yDrew4(String opponent, String score) {
    return '$score з $opponent. Два очки втрачено чи одне здобуто: обирай настрій.';
  }

  @override
  String yDrew5(String opponent, String score) {
    return 'Нічия з $opponent, $score. Ніхто не радий, ніхто не лютує.';
  }

  @override
  String yDrew6(String opponent, String score) {
    return '$opponent $score. Найнезапам’ятніші дев’яносто хвилин року.';
  }

  @override
  String yDrew7(String opponent, String score) {
    return 'Розділили очки з $opponent, $score. Рухаємося далі.';
  }

  @override
  String yDrew8(String opponent, String score) {
    return '$score проти $opponent. Саме від таких нічиїх тихо вмирають кампанії.';
  }

  @override
  String yDrew9(String opponent, String score) {
    return 'Два очки викинуто проти $opponent. $score. Інакше й не назвеш.';
  }

  @override
  String yDrew10(String opponent, String score) {
    return '$opponent $score. Мали дев’яносто хвилин і поняття не мали, що з ними робити.';
  }

  @override
  String yDrew11(String opponent, String score) {
    return 'Нічия $score з $opponent, яку ніхто не згадає, а платити доведеться всім.';
  }

  @override
  String yLost0(String opponent, String score) {
    return 'Поразка $score від $opponent. Буває.';
  }

  @override
  String yLost1(String opponent, String score) {
    return '$opponent $score. Нікого тут вішати не за що. Далі.';
  }

  @override
  String yLost2(String opponent, String score) {
    return 'Програли $opponent $score, віддавши все. Іноді цього замало.';
  }

  @override
  String yLost3(String opponent, String score) {
    return '$score від $opponent. Голови вгору. У цієї команди ще багато сил.';
  }

  @override
  String yLost4(String opponent, String score) {
    return '$opponent $score. Ми були слабшими, і тут немає про що сперечатися.';
  }

  @override
  String yLost5(String opponent, String score) {
    return 'Програли $opponent $score. Збираємося.';
  }

  @override
  String yLost6(String opponent, String score) {
    return '$score від $opponent. Не ганьба, але й не рівень.';
  }

  @override
  String yLost7(String opponent, String score) {
    return 'Поразка $score від $opponent. Винесіть із неї урок, інакше все намарно.';
  }

  @override
  String yLost8(String opponent, String score) {
    return '$score від $opponent, і ми їм жодного разу не дошкулили.';
  }

  @override
  String yLost9(String opponent, String score) {
    return 'Програш $opponent, $score. Ті самі проблеми, той самий місяць, ті самі виправдання на підході.';
  }

  @override
  String yLost10(String opponent, String score) {
    return '$opponent $score. У який момент це перестає бути невдачею?';
  }

  @override
  String yLost11(String opponent, String score) {
    return 'Поразка $score від $opponent. Після такого результату хтось має за щось відповісти.';
  }

  @override
  String yLostBadly0(String opponent, String score) {
    return '$score від $opponent. Один поганий вечір. Судіть команду за кампанією, а не за цим.';
  }

  @override
  String yLostBadly1(String opponent, String score) {
    return 'Цих $score від $opponent ніхто не хотів менше, ніж самі гравці.';
  }

  @override
  String yLostBadly2(String opponent, String score) {
    return '$opponent $score. Бридко, і це не справжнє обличчя цієї команди.';
  }

  @override
  String yLostBadly3(String opponent, String score) {
    return 'Рахунок $score проти $opponent краще забути. Наступного разу команда себе покаже.';
  }

  @override
  String yLostBadly4(String opponent, String score) {
    return '$score. Від $opponent. У мене немає слів, а мені платять за слова.';
  }

  @override
  String yLostBadly5(String opponent, String score) {
    return '$opponent $score. Хтось має за це відповісти.';
  }

  @override
  String yLostBadly6(String opponent, String score) {
    return 'Хочу, щоб $score від $opponent викреслили з протоколів і з пам’яті.';
  }

  @override
  String yLostBadly7(String opponent, String score) {
    return 'Поразка $score від $opponent. Такий рахунок не приукрасиш.';
  }

  @override
  String yLostBadly8(String opponent, String score) {
    return 'Це була не поразка від $opponent, а капітуляція. $score.';
  }

  @override
  String yLostBadly9(String opponent, String score) {
    return '$score. Від $opponent. Люди заплатили гроші, щоб на це дивитися.';
  }

  @override
  String yLostBadly10(String opponent, String score) {
    return '$opponent $score. Якщо це нічого не змінить, то вже не змінить ніщо.';
  }

  @override
  String yLostBadly11(String opponent, String score) {
    return 'Цю команду принижували й раніше, але $score від $opponent: нове дно.';
  }

  @override
  String yTrophy0(String opponent) {
    return 'ЧЕМПІОНИ. Турнір: $opponent. Скажіть це вголос.';
  }

  @override
  String yTrophy1(String opponent) {
    return 'Ми це зробили. Турнір: $opponent. Я не в порядку.';
  }

  @override
  String yTrophy2(String opponent) {
    return 'Турнір: $opponent, і трофей вертається додому.';
  }

  @override
  String yTrophy3(String opponent) {
    return 'Кожен із них легенда. Турнір: $opponent.';
  }

  @override
  String yRunnerUp0(String opponent) {
    return 'Так близько. Турнір: $opponent, і медаль, якої ніхто не хоче.';
  }

  @override
  String yRunnerUp1(String opponent) {
    return 'Срібло на турнірі $opponent. Болітиме роками.';
  }

  @override
  String yRunnerUp2(String opponent) {
    return 'Турнір: $opponent. Один матч до всього.';
  }

  @override
  String yRunnerUp3(String opponent) {
    return 'Друге місце. Турнір: $opponent. Хай хтось передасть пляшку.';
  }

  @override
  String yEliminated0(String opponent) {
    return 'Вилетіли з турніру: $opponent. Це ще довго болітиме.';
  }

  @override
  String yEliminated1(String opponent) {
    return 'Турнір: $opponent. Тут наша дорога закінчується.';
  }

  @override
  String yEliminated2(String opponent) {
    return 'Вибули з турніру: $opponent. Тепер починається розслідування.';
  }

  @override
  String yEliminated3(String opponent) {
    return 'Нокаут на турнірі: $opponent. Хтось поясніть мені це.';
  }

  @override
  String yQualified0(String opponent) {
    return 'ЇДЕМО НА ТУРНІР: $opponent.';
  }

  @override
  String yQualified1(String opponent) {
    return 'Кваліфікувалися на турнір: $opponent. Беріть відпустку.';
  }

  @override
  String yQualified2(String opponent) {
    return 'Турнір: $opponent, ми їдемо. Ніколи не було сумнівів (насправді сумнівів було повно).';
  }

  @override
  String yQualified3(String opponent) {
    return 'Пройшли на турнір: $opponent. Найважче позаду.';
  }

  @override
  String yGroupDrawn0(String opponent) {
    return 'Групи турніру $opponent розписано. Могло бути гірше. Могло бути набагато гірше.';
  }

  @override
  String yGroupDrawn1(String opponent) {
    return 'Отже, жеребкування турніру $opponent. Цікаво.';
  }

  @override
  String yGroupDrawn2(String opponent) {
    return 'Групи турніру $opponent відомі, а наша мені вже не подобається.';
  }

  @override
  String yGroupDrawn3(String opponent) {
    return 'Жеребкування турніру $opponent відбулося. Нехай починаються перегини.';
  }

  @override
  String yHostNamed0(String opponent) {
    return 'Господар турніру: $opponent. Починайте збирати гроші.';
  }

  @override
  String yHostNamed1(String opponent) {
    return 'Турнір: $opponent. Передбачувано, але нехай.';
  }

  @override
  String yHostNamed2(String opponent) {
    return 'Турнір дістається країні: $opponent. Вітаю їх, мабуть.';
  }

  @override
  String yHostNamed3(String opponent) {
    return 'Господарів підтверджено: $opponent.';
  }

  @override
  String yTournamentSoon0(String opponent) {
    return 'Скоро старт: $opponent, і я не можу всидіти на місці.';
  }

  @override
  String yTournamentSoon1(String opponent) {
    return 'Вже зовсім скоро: $opponent.';
  }

  @override
  String yTournamentSoon2(String opponent) {
    return 'Майже тут: $opponent. Оголошуйте склад, будь ласка.';
  }

  @override
  String yTournamentSoon3(String opponent) {
    return 'Відлік до турніру $opponent офіційно нестерпний.';
  }

  @override
  String get navY => 'Y';

  @override
  String get yTitle => 'Y';

  @override
  String get yEmpty => 'Поки нема що сказати. Зіграй матч.';

  @override
  String get yEarlierHeading => 'Раніше в цьому циклі';

  @override
  String get yTraitLoyalist =>
      'Підтримує команду, що б не сталося. Повільно відвертається, швидко прощає.';

  @override
  String get yTraitCynic =>
      'Чекає найгіршого і радіє, коли воно справджується.';

  @override
  String get yTraitNostalgic =>
      'Раніше все було краще. Міряє тебе футболістами, які давно завершили.';

  @override
  String get yTraitStatshead =>
      'Постить цифри й більше нічого. Настрою майже немає.';

  @override
  String get yTraitHypeman => 'Два добрі результати, і вже «золоте покоління».';

  @override
  String get yTraitContrarian =>
      'Що б не думали всі навколо, він скаже навпаки.';

  @override
  String get yTraitDoomer => 'Усе піде не так. Завжди йде не так.';

  @override
  String get yProfilePosts => 'ДОПИСИ';

  @override
  String get yProfileEmpty => 'Від цього акаунта поки нічого.';

  @override
  String hubEventGrievance(String player) {
    return '$player хоче поговорити';
  }

  @override
  String get hubEventGrievanceSub => 'Хоче знати, на що розраховувати';

  @override
  String hubEventManagerSkills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count очка навичок на розподіл',
      many: '$count очок навичок на розподіл',
      few: '$count очка навичок на розподіл',
      one: '$count очко навичок на розподіл',
    );
    return '$_temp0';
  }

  @override
  String get hubEventManagerSkillsSub =>
      'Те, що ти вмієш добре, робить команду кращою';

  @override
  String get grievanceTitle => 'Розмова в кабінеті';

  @override
  String grievanceGameTime(String player) {
    return '$player у складі, але жодного разу не вийшов на поле. Хоче знати чому.';
  }

  @override
  String grievanceSquadPlace(String player) {
    return '$player не в складі й цього не розуміє. Хоче почути відповідь, так чи ні.';
  }

  @override
  String grievanceRole(String player) {
    return '$player постійно грає не на своїй позиції, і з нього досить.';
  }

  @override
  String get grievanceReassure => 'Ти в моїх планах';

  @override
  String get grievanceHonest => 'Ти позаду інших, і ось чому';

  @override
  String get grievanceDismiss => 'Склад визначаю я';

  @override
  String yScorerStar0(String name, String goals) {
    return '$name забив $goals. Ніхто інший поряд не стоїть.';
  }

  @override
  String yScorerStar1(String name, String goals) {
    return '$goals від $name. Він тягне цю команду.';
  }

  @override
  String yScorerStar2(String name, String goals) {
    return '$name: $goals за матч. Ось це гравець.';
  }

  @override
  String yScorerStar3(String name, String goals) {
    return '$goals у ворота, і всі від $name. Вклоніться.';
  }

  @override
  String yScorerStar4(String name, String goals) {
    return '$goals від $name, а решта були пасажирами.';
  }

  @override
  String yScorerStar5(String name, String goals) {
    return 'Знову $name. $goals. Уявіть цю команду без нього.';
  }

  @override
  String yScorerStar6(String name, String goals) {
    return '$goals від $name. Одна людина не повинна робити стільки.';
  }

  @override
  String yScorerStar7(String name, String goals) {
    return 'Приберіть $name із цього матчу, і буде на $goals менше та зовсім інший вечір.';
  }

  @override
  String yWinStreak0(String count) {
    return '$count поспіль. Що б там не говорили в роздягальні, воно працює.';
  }

  @override
  String yWinStreak1(String count) {
    return 'Це $count поспіль. Випадково в такі серії не потрапляють.';
  }

  @override
  String yWinStreak2(String count) {
    return '$count поспіль, і це ще не кінець. Упевненість видно навіть з трибун.';
  }

  @override
  String yWinStreak3(String count) {
    return 'Без поразок: $count. Спитайте будь-якого тренера: це найважче.';
  }

  @override
  String yWinStreak4(String count) {
    return '$count поспіль. Насолоджуйтесь, поки календар добрий.';
  }

  @override
  String yWinStreak5(String count) {
    return '$count поспіль, і жодного серйозного суперника серед них.';
  }

  @override
  String yWinStreak6(String count) {
    return 'Серія з $count. Спитайте мене ще раз, коли її випробують.';
  }

  @override
  String yWinStreak7(String count) {
    return '$count без зупинки. У кожної команди колись буває таке.';
  }

  @override
  String yLossStreak0(String count) {
    return 'Без перемоги вже $count. Колись виправдання закінчуються.';
  }

  @override
  String yLossStreak1(String count) {
    return 'Це вже $count поспіль. Збоєм це більше не назвеш.';
  }

  @override
  String yLossStreak2(String count) {
    return 'Поразки поспіль: $count. Хтось має за це відповісти.';
  }

  @override
  String yLossStreak3(String count) {
    return 'Без перемоги: $count. Це видно по тому, як вони грають.';
  }

  @override
  String yLossStreak4(String count) {
    return 'Без перемоги: $count, і щотижня ті самі помилки.';
  }

  @override
  String yLossStreak5(String count) {
    return '$count поспіль. Що б не пробували, воно не працює.';
  }

  @override
  String yLossStreak6(String count) {
    return '$count поспіль. Це тенденція, а не провал.';
  }

  @override
  String yLossStreak7(String count) {
    return 'Без перемоги: $count, а нагорі ніхто й слова не сказав.';
  }

  @override
  String yRivalry0(String opponent, String score) {
    return '$opponent $score. Кажіть про футбол що завгодно. Цей матч рахується подвійно.';
  }

  @override
  String yRivalry1(String opponent, String score) {
    return 'Проти $opponent, з усіх можливих. $score. Тут цього ніхто не забуде.';
  }

  @override
  String yRivalry2(String opponent, String score) {
    return '$score проти $opponent. Про цей матч говоритимуть у барах.';
  }

  @override
  String yRivalry3(String opponent, String score) {
    return 'Сусіди, $score. Право хвалитися вирішено на деякий час.';
  }

  @override
  String yRivalry4(String opponent, String score) {
    return '$opponent $score. Що б не сталося цього року, оце вже є.';
  }

  @override
  String yRivalry5(String opponent, String score) {
    return '$score проти $opponent. Дехто з нас потребував цього більше, ніж таблиця.';
  }

  @override
  String yRivalry6(String opponent, String score) {
    return '$opponent $score. Вони ще відіграються, як завжди.';
  }

  @override
  String yRivalry7(String opponent, String score) {
    return 'Проти $opponent, $score. Цілий рік нам про це нагадуватимуть.';
  }

  @override
  String yInjuryBlow0(String name) {
    return '$name залишає поле травмованим. Саме цього цій команді не вистачало.';
  }

  @override
  String yInjuryBlow1(String name) {
    return 'Втрата $name змінює всю картину.';
  }

  @override
  String yInjuryBlow2(String name) {
    return '$name накульгує. Затримайте подих.';
  }

  @override
  String yInjuryBlow3(String name) {
    return 'Отже, $name певний час не грає. Комусь треба брати відповідальність.';
  }

  @override
  String yInjuryBlow4(String name) {
    return '$name вибув. Звісно ж, це $name.';
  }

  @override
  String yInjuryBlow5(String name) {
    return 'Без $name це дуже звичайна команда.';
  }

  @override
  String yInjuryBlow6(String name) {
    return '$name знову травмований. Хтось має спитати чому.';
  }

  @override
  String yInjuryBlow7(String name) {
    return 'Втратили $name, а за ним нікого. Ось справжня проблема.';
  }

  @override
  String ySentOff0(String name, String minute) {
    return 'Червона для $name на $minute хвилині, і вся країна накинулася на нього. Він віддав нам більше за інших. Облиште.';
  }

  @override
  String ySentOff1(String name, String minute) {
    return '$name з поля на $minute хвилині. Жорстко. Вдесятьох ми все одно билися, і це дещо говорить.';
  }

  @override
  String ySentOff2(String name, String minute) {
    return '$name, червона картка на $minute хвилині. Далі вдесятьох.';
  }

  @override
  String ySentOff3(String name, String minute) {
    return 'Вилучення: $name на $minute хвилині. Не перший матч, що вирішується одним рішенням.';
  }

  @override
  String ySentOff4(String name, String minute) {
    return 'Блискуче. $name іде на $minute хвилині, і нас знову десятеро.';
  }

  @override
  String ySentOff5(String name, String minute) {
    return '$name вилучено на $minute хвилині. Хто в нас взагалі відповідає за дисципліну?';
  }

  @override
  String ySentOff6(String name, String minute) {
    return '$name витримав до $minute хвилини, а потім втратив голову. Професійний футбол.';
  }

  @override
  String ySentOff7(String name, String minute) {
    return 'Червона для $name на $minute хвилині, і мені кажуть, що це прогрес.';
  }

  @override
  String get yBoardPressure0 => 'Рада дуже притихла. Це ніколи не добрий знак.';

  @override
  String get yBoardPressure1 => 'Кажуть, у кабінетах почали ставити запитання.';

  @override
  String get yBoardPressure2 => 'Відчувається, як нагорі зсувається ґрунт.';

  @override
  String get yBoardPressure3 =>
      'Ніхто у федерації не каже нічого на підтримку. Висновки робіть самі.';

  @override
  String get yBoardPressure4 =>
      'Уже кілька тижнів ніхто нагорі не підтримує його публічно.';

  @override
  String get yBoardPressure5 =>
      'Федерація «зливає» інформацію проти власного тренера. Як завжди.';

  @override
  String get yBoardPressure6 => 'Коли рада мовчить, вона вже все вирішила.';

  @override
  String get yBoardPressure7 =>
      'Дадуть усьому дрейфувати, доки рішення не доведеться приймати комусь іншому.';

  @override
  String get yReplies => 'ЩЕ ПРО ЦЕЙ МАТЧ';

  @override
  String get yPlayerGrievance0 =>
      'Питання про моє місце в команді досі без відповіді.';

  @override
  String get yPlayerGrievance1 =>
      'Наполегливо тренуюсь. Більше нічого зробити не можу.';

  @override
  String get yPlayerGrievance2 => 'Деякі запитання можна поставити лише раз.';

  @override
  String get yPlayerGrievance3 =>
      'Дорога сюди була не для того, щоб носити манишки.';

  @override
  String get playerHonoursTitle => 'ВІДЗНАКИ';

  @override
  String get awardGoldenBall => 'Золотий м’яч';

  @override
  String get awardGoldenBoot => 'Золота бутса';

  @override
  String get awardGoldenGlove => 'Золоті рукавиці';

  @override
  String get awardTeamOfTournament => 'Збірна турніру';

  @override
  String get awardPlayerOfYear => 'Гравець року у світі';

  @override
  String get awardYoungPlayerOfYear => 'Молодий гравець року';

  @override
  String get playerClubHistory => 'ІСТОРІЯ КЛУБІВ';

  @override
  String get playerCareerRecord => 'КАР’ЄРА';

  @override
  String get playerInternationalGoals => 'Голи за збірну';

  @override
  String get playerRecentForm => 'ОСТАННЯ ФОРМА';

  @override
  String get playerMatchHistory => 'ІСТОРІЯ МАТЧІВ';

  @override
  String get playerAttributes => 'ХАРАКТЕРИСТИКИ';

  @override
  String get playerUnknown => 'Невідомо';

  @override
  String get playerAttrPace => 'Швидкість';

  @override
  String get playerAttrPhysical => 'Фізика';

  @override
  String get playerAttrTechnical => 'Техніка';

  @override
  String get playerAttrShooting => 'Удар';

  @override
  String get playerAttrPassing => 'Передачі';

  @override
  String get playerAttrDribbling => 'Дриблінг';

  @override
  String get playerAttrTackling => 'Відбір м’яча';

  @override
  String get playerAttrPositioning => 'Вибір позиції';

  @override
  String get playerAttrComposure => 'Витримка';

  @override
  String get playerAttrDecisions => 'Рішення';

  @override
  String get playerAttrStamina => 'Витривалість';

  @override
  String get playerAttrStrength => 'Сила';

  @override
  String get playerStatCaps => 'Матчі';

  @override
  String get playerStatGoals => 'Голи';

  @override
  String get playerStatAssists => 'Асисти';

  @override
  String get playerStatAvgRating => 'Сер. рейтинг';

  @override
  String get playerStatForm => 'Форма';

  @override
  String get playerStatMotm => 'Гравець матчу';

  @override
  String get playerStatCleanSheets => 'Сухі матчі';

  @override
  String get playerStatBestGame => 'Найкращий матч';

  @override
  String get playerStatCards => 'Картки';

  @override
  String playerCardsValue(int yellows, int reds) {
    return '$yellowsЖ $redsЧ';
  }

  @override
  String get tourSharedYourRun => 'ТВІЙ ШЛЯХ';

  @override
  String get tourSharedList => 'Список';

  @override
  String get tourSharedBracket => 'Сітка';

  @override
  String get tourSharedVs => 'проти';

  @override
  String tourSharedGroupSeed(String seed) {
    return 'Група $seed';
  }

  @override
  String get tourSharedThisEdition => 'Цей розіграш';

  @override
  String get tourSharedAllTime => 'За весь час';

  @override
  String get tourSharedUnknown => 'Невідомо';

  @override
  String get tourSharedActive => 'ГРАЄ';

  @override
  String get tourSharedMedalTable => 'МЕДАЛЬНИЙ ЗАЛІК';

  @override
  String get tourSharedPastWinners => 'МИНУЛІ ПЕРЕМОЖЦІ';

  @override
  String tourSharedHost(String host) {
    return 'Господар: $host';
  }

  @override
  String get tourSharedBeat => 'обіграла';

  @override
  String get tourSharedPens => ' (пен.)';

  @override
  String get tourSharedAwardsEmpty =>
      'Нагороди визначаться після завершення турніру.';

  @override
  String get tourSharedGoldenBall => 'ЗОЛОТИЙ М’ЯЧ';

  @override
  String get tourSharedPlayerOfTournament => 'Найкращий гравець турніру';

  @override
  String get tourSharedGoldenBoot => 'ЗОЛОТА БУТСА';

  @override
  String tourSharedGoalsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count гола',
      many: '$count голів',
      few: '$count голи',
      one: '$count гол',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedGoldenGlove => 'ЗОЛОТІ РУКАВИЦІ';

  @override
  String get tourSharedTeamOfTournament => 'ЗБІРНА ТУРНІРУ';

  @override
  String get tourSharedStatsEmpty =>
      'Рекорди з’являться, коли в змагання з’явиться історія.';

  @override
  String get tourSharedRecordScorer => 'РЕКОРДНИЙ БОМБАРДИР';

  @override
  String get tourSharedStillActive => 'ще грає';

  @override
  String get tourSharedMostTitles => 'НАЙБІЛЬШЕ ТИТУЛІВ';

  @override
  String tourSharedTitlesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count титулу',
      many: '$count титулів',
      few: '$count титули',
      one: '$count титул',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostFinals => 'НАЙБІЛЬШЕ ФІНАЛІВ';

  @override
  String tourSharedFinalsContested(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count зіграного фіналу',
      many: '$count зіграних фіналів',
      few: '$count зіграні фінали',
      one: '$count зіграний фінал',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostGamesPlayed => 'НАЙБІЛЬШЕ МАТЧІВ';

  @override
  String tourSharedMatchesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count матчу',
      many: '$count матчів',
      few: '$count матчі',
      one: '$count матч',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostFinalsPlayed => 'НАЙБІЛЬШЕ ФІНАЛЬНИХ ТУРНІРІВ';

  @override
  String tourSharedFinalsTournamentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count фінального турніру',
      many: '$count фінальних турнірів',
      few: '$count фінальні турніри',
      one: '$count фінальний турнір',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedBiggestFinalWin => 'НАЙБІЛЬША ПЕРЕМОГА У ФІНАЛІ';

  @override
  String tourStatsGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count гола',
      many: '$count голів',
      few: '$count голи',
      one: '$count гол',
    );
    return '$_temp0';
  }

  @override
  String get tourStatsStillActive => 'ще грає';

  @override
  String tourStatsTitles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count титулу',
      many: '$count титулів',
      few: '$count титули',
      one: '$count титул',
    );
    return '$_temp0';
  }

  @override
  String tourStatsFinalsContested(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count зіграного фіналу',
      many: '$count зіграних фіналів',
      few: '$count зіграні фінали',
      one: '$count зіграний фінал',
    );
    return '$_temp0';
  }

  @override
  String tourStatsMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count матчу',
      many: '$count матчів',
      few: '$count матчі',
      one: '$count матч',
    );
    return '$_temp0';
  }

  @override
  String tourStatsFinalsTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count фінального турніру',
      many: '$count фінальних турнірів',
      few: '$count фінальні турніри',
      one: '$count фінальний турнір',
    );
    return '$_temp0';
  }

  @override
  String get tourStatsLeaders => 'ЛІДЕРИ ЗА ВЕСЬ ЧАС';

  @override
  String get tourStatsTabGames => 'Матчі';

  @override
  String get tourStatsTabCups => 'Турніри';

  @override
  String get tourStatsTabScorers => 'Бомбардири';

  @override
  String tourSharedFinalWinDetail(String opponent, int year) {
    return 'проти $opponent · $year';
  }

  @override
  String get tourHolders => 'ВОЛОДАРІ';

  @override
  String tourHoldersSince(int year) {
    return 'виграли у $year';
  }

  @override
  String get tourSharedAllTimeScorers => 'БОМБАРДИРИ ВСІХ ЧАСІВ';

  @override
  String get tourSharedSummaryEmpty =>
      'Господар і стадіони з’являться після жеребкування цього розіграшу.';

  @override
  String get tourSharedHostHeading => 'ГОСПОДАР';

  @override
  String get tourSharedHostsHeading => 'ГОСПОДАРІ';

  @override
  String get tourSharedCoHostsHeading => 'СПІВГОСПОДАРІ';

  @override
  String get tourSharedVenues => 'СТАДІОНИ';

  @override
  String get tourSharedMascot => 'ТАЛІСМАН';

  @override
  String get tourSharedMatchBall => 'М’ЯЧ ТУРНІРУ';

  @override
  String tourSharedVenueSeats(String city, String capacity) {
    return '$city · $capacity місць';
  }

  @override
  String get tourSharedCouldNotLoad => 'Не вдалося завантажити.';

  @override
  String get tourSharedHostTbc => 'ГОСПОДАРЯ ЩЕ НЕ ВИЗНАЧЕНО';

  @override
  String get tourSharedFinalsAreHere => 'ФІНАЛЬНА ЧАСТИНА РОЗПОЧАЛАСЯ';

  @override
  String tourSharedHostedBy(String hosts) {
    return 'ГОСПОДАР:  $hosts';
  }

  @override
  String get tourSharedLetFinalsBegin => 'Нехай почнеться фінальна частина';

  @override
  String get tourSharedCompetitions => 'ЗМАГАННЯ';

  @override
  String get tourSharedWorldRanking => 'Світовий рейтинг';

  @override
  String get tourSharedCouldNotLoadTournaments =>
      'Не вдалося завантажити турніри.';

  @override
  String get tourSharedPrestigeStage => 'ПРЕСТИЖНА СЦЕНА';

  @override
  String get tourSharedOverview => 'Огляд';

  @override
  String get tourSharedWorldRankingTitle => 'Світовий рейтинг';

  @override
  String get tourSharedYourCompetitions => 'ТВОЇ ЗМАГАННЯ';

  @override
  String get tourSharedOtherContinents => 'ІНШІ КОНТИНЕНТИ';

  @override
  String get tourSharedComingSoon => 'Турнір скоро з’явиться';

  @override
  String get tourSharedSoon => 'СКОРО';

  @override
  String get tourSharedNoQualifyingDraw => 'Жеребкування кваліфікації немає.';

  @override
  String get tourSharedOpenEnvelope => 'Відкрити конверт';

  @override
  String tourSharedGroupName(String name) {
    return 'ГРУПА $name';
  }

  @override
  String get tourSharedBall => 'М’яч';

  @override
  String get tourSharedPot => 'Кошик';

  @override
  String get tourSharedAll => 'Усе';

  @override
  String get tourSharedTapDrawTeam =>
      'Торкнись, щоб витягнути наступну команду';

  @override
  String get tourSharedTapDrawPot => 'Торкнись, щоб витягнути наступний кошик';

  @override
  String get tourSharedTapDrawAll => 'Торкнись, щоб побачити все жеребкування';

  @override
  String get tourSharedContinue => 'Продовжити';

  @override
  String get tourSharedPause => 'Пауза';

  @override
  String get tourSharedPlay => 'Грати';

  @override
  String get tourSharedSkip => 'Пропустити';

  @override
  String tourSharedPotNumber(int number) {
    return 'КОШИК $number';
  }

  @override
  String get tourSharedDrawComplete => 'ЖЕРЕБКУВАННЯ ЗАВЕРШЕНО';

  @override
  String get tourSharedDrawing => 'ЖЕРЕБКУВАННЯ…';

  @override
  String get tourContChampionship => 'ЧЕМПІОНАТ';

  @override
  String get tourContTabSummary => 'ОГЛЯД';

  @override
  String get tourContTabQualifying => 'ВІДБІР';

  @override
  String get tourContTabFinals => 'ФІНАЛИ';

  @override
  String get tourContTabBracket => 'СІТКА';

  @override
  String get tourContTabAwards => 'НАГОРОДИ';

  @override
  String get tourContTabScorers => 'БОМБАРДИРИ';

  @override
  String get tourContTabHistory => 'ІСТОРІЯ';

  @override
  String get tourContTabRecords => 'РЕКОРДИ';

  @override
  String tourContCouldNotLoadCup(String error) {
    return 'Не вдалося завантажити турнір.\n$error';
  }

  @override
  String get tourContNoCupData => 'Немає даних турніру.';

  @override
  String get tourContUnknown => 'Невідомо';

  @override
  String get tourContGroupsToBeDrawnQual =>
      'Групи кваліфікації визначаються на церемонії. Дивись із головної, з ким гратимеш.';

  @override
  String get tourContQualSeeded =>
      'Твою збірну посіяно одразу у фінальну частину. Цього циклу без кваліфікації.';

  @override
  String tourContBackgroundRegion(String name) {
    return 'Моделюється у фоні: $name. Результати з’являтимуться тут після кожного раунду.';
  }

  @override
  String get tourContGroupsToBeDrawnFinals =>
      'Групи фінальної частини визначаються на церемонії. Дивись із головної, у якій групі опинишся.';

  @override
  String get tourContFinalsDrawAfterQual =>
      'Жеребкування фінальної частини відбудеться після завершення кваліфікації.';

  @override
  String get tourContContestedBeforeWc =>
      'Матчі плей-оф проходять до чемпіонату світу.';

  @override
  String tourContChampionsHeading(String name) {
    return 'ЧЕМПІОНИ: $name';
  }

  @override
  String tourContWinnersTitle(String name) {
    return 'Переможці: $name';
  }

  @override
  String get tourContNoGoalsYet => 'Голів поки не забито.';

  @override
  String tourContGroupHeading(String name) {
    return 'ГРУПА $name';
  }

  @override
  String get tourContBestRunnersUp => 'НАЙКРАЩІ ДРУГІ МІСЦЯ';

  @override
  String tourContGroupDropdown(String name) {
    return 'Група $name';
  }

  @override
  String get tourContMatches => 'МАТЧІ';

  @override
  String get tourContNoGroupsDrawn => 'Груп поки не визначено.';

  @override
  String get tourContQualifyingDraw => 'ЖЕРЕБКУВАННЯ КВАЛІФІКАЦІЇ';

  @override
  String get tourContWorldQualifyingDraw =>
      'ЖЕРЕБКУВАННЯ СВІТОВОЇ КВАЛІФІКАЦІЇ';

  @override
  String get tourContFinalsDraw => 'ЖЕРЕБКУВАННЯ ФІНАЛЬНОЇ ЧАСТИНИ';

  @override
  String get tourContSeedingPots => 'КОШИКИ ПОСІВУ';

  @override
  String get tourContGroupDraw => 'ЖЕРЕБКУВАННЯ ГРУП';

  @override
  String tourContCouldNotLoadDraw(String error) {
    return 'Не вдалося завантажити жеребкування.\n$error';
  }

  @override
  String get tourContDrawNotReady => 'Жеребкування ще не готове.';

  @override
  String get tourContContinentalClash => 'CONTINENTAL CLASH';

  @override
  String get tourContTabThisCycle => 'ЦЕЙ ЦИКЛ';

  @override
  String tourContCouldNotLoadClash(String error) {
    return 'Не вдалося завантажити.\n$error';
  }

  @override
  String get tourContNoSaveFound => 'Збереження не знайдено.';

  @override
  String get tourContClashSoon =>
      'Continental Clash відбудеться, коли будуть відомі обидва континентальні чемпіони.';

  @override
  String get tourContTwoContinentsOneMatch => 'ДВА КОНТИНЕНТИ, ОДИН МАТЧ';

  @override
  String get tourContVersusShort => 'проти';

  @override
  String tourContWinTheClash(String name) {
    return 'Переможець Clash: $name';
  }

  @override
  String get tourContNoClashYet => 'Continental Clash ще не відбувався.';

  @override
  String get tourContNationsCup => 'NATIONS CUP';

  @override
  String get tourContTabLeagues => 'ЛІГИ';

  @override
  String get tourContTabFinalsFour => 'FINAL FOUR';

  @override
  String tourContCouldNotLoad(String error) {
    return 'Не вдалося завантажити.\n$error';
  }

  @override
  String get tourContNoNationsCupGoals =>
      'У Nations Cup ще не записано жодного гола.';

  @override
  String get tourContNoNationsCupChampions => 'Чемпіонів Nations Cup ще немає.';

  @override
  String get tourContNationsCupOffSeason =>
      'Nations Cup цього циклу почнеться після континентальних фіналів. Минулі переможці в розділі «Історія».';

  @override
  String get tourContNationsCupGroupsSoon =>
      'Групи Nations Cup цього циклу визначать на жеребкуванні. Дивись його з головної, щоб побачити суперників.';

  @override
  String get tourContLeagueNoGroups => 'У цій лізі цього раунду немає матчів.';

  @override
  String tourContLeagueHeading(String letter) {
    return 'ЛІГА $letter';
  }

  @override
  String tourContLeagueHeadingYours(String letter) {
    return 'ЛІГА $letter · ТВОЯ ЛІГА';
  }

  @override
  String get tourContFinalsFourSoon =>
      'Final Four розіграють переможці груп Ліги A, коли завершиться груповий етап.';

  @override
  String tourContLeagueChip(String letter) {
    return 'Ліга $letter';
  }

  @override
  String tourContLeagueChipStar(String letter) {
    return 'Ліга $letter ★';
  }

  @override
  String get tourContSemiFinals => 'ПІВФІНАЛИ';

  @override
  String get tourContFinal => 'ФІНАЛ';

  @override
  String get tourContNationsCupDraw => 'ЖЕРЕБКУВАННЯ NATIONS CUP';

  @override
  String get tourContIntercontinentalPlayoff => 'МІЖКОНТИНЕНТАЛЬНИЙ ПЛЕЙ-ОФ';

  @override
  String get tourContNoPlayoffThisCycle => 'Цього циклу плей-оф немає.';

  @override
  String get tourContPlayoffIntro =>
      'Два місця на чемпіонаті світу розігрують у плей-оф найкращі з тих, хто не пробився напряму.';

  @override
  String get tourContPlayoffThrough =>
      'Плей-оф пройдено. Ти на чемпіонаті світу!';

  @override
  String get tourContPlayoffOut =>
      'У плей-оф тобі не вистачило сил. Цього разу без чемпіонату світу.';

  @override
  String get tourContContinue => 'Продовжити';

  @override
  String get tourContPlayoffFinals => 'ФІНАЛИ ПЛЕЙ-ОФ';

  @override
  String get tourContPlayoffSeeded => 'Сіяна (пропуск раунду)';

  @override
  String get tourCupTabSummary => 'ПІДСУМКИ';

  @override
  String get tourCupTabQualifying => 'ВІДБІР';

  @override
  String get tourCupTabPlayoff => 'ПЛЕЙ-ОФ';

  @override
  String get tourCupPlayoffSoon =>
      'Міжконтинентальний плей-оф визначиться, коли завершиться відбір у кожній конфедерації.';

  @override
  String get tourCupTabFinals => 'ФІНАЛИ';

  @override
  String get tourCupTabBracket => 'СІТКА';

  @override
  String get tourCupTabAwards => 'НАГОРОДИ';

  @override
  String get tourCupTabScorers => 'БОМБАРДИРИ';

  @override
  String get tourCupTabHistory => 'ІСТОРІЯ';

  @override
  String get tourCupTabRecords => 'РЕКОРДИ';

  @override
  String get tourCupTitle => 'ЧЕМПІОНАТ СВІТУ';

  @override
  String get tourCupNoData => 'Немає даних про турнір.';

  @override
  String tourCupLoadError(String error) {
    return 'Не вдалося завантажити турнір.\n$error';
  }

  @override
  String get tourCupUnknown => 'Невідомо';

  @override
  String get tourCupWorldChampions => 'ЧЕМПІОНИ СВІТУ';

  @override
  String get tourCupWorldChampionsTitle => 'Чемпіони світу';

  @override
  String get tourCupStillActive => 'Ще грає';

  @override
  String get tourCupAllTimeScorers => 'НАЙКРАЩІ БОМБАРДИРИ В ІСТОРІЇ';

  @override
  String get tourCupAllConfederations => 'Усі конфедерації';

  @override
  String get tourCupBestRunnersUp => 'Найкращі другі місця';

  @override
  String get tourCupCompWorld => 'Чемпіонат світу';

  @override
  String get tourCupCompEurope => 'Чемпіонат Європи';

  @override
  String get tourCupCompSAmerica => 'Кубок Південної Америки';

  @override
  String get tourCupDestRoundOf16 => '1/8 фіналу';

  @override
  String get tourCupDestKnockouts => 'стадії плей-оф';

  @override
  String get tourCupDestFinals => 'фінальної частини';

  @override
  String get tourCupDestFinalsPlayoff => 'фінального плей-оф';

  @override
  String get tourCupDestIntercontPlayoff => 'міжконтинентального плей-оф';

  @override
  String get tourCupFinalsDrawnAfterQual =>
      'Жеребкування фінальної частини відбудеться після завершення відбору.';

  @override
  String get tourCupFinalsDrawSoon =>
      'Групи ще не сформовані. Дивись жеребкування чемпіонату світу з головної, щоб побачити їх.';

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
    return 'Господар: $host';
  }

  @override
  String tourCupHostLabelMulti(String hosts) {
    return 'Господарі: $hosts';
  }

  @override
  String get tourCupIntercontPlayoff => 'Міжконтинентальний плей-оф';

  @override
  String get tourCupKnockoutSoon =>
      'Сітка з’явиться після завершення групового етапу.';

  @override
  String get tourCupMatches => 'МАТЧІ';

  @override
  String get tourCupMedalTable => 'МЕДАЛЬНИЙ ЗАЛІК';

  @override
  String get tourCupMostTitles => 'НАЙБІЛЬШЕ ТИТУЛІВ';

  @override
  String tourCupMostTitlesValue(String nation, int titles, int editions) {
    return '$nation: титулів $titles з $editions турнірів';
  }

  @override
  String get tourCupNoGoals => 'Голів ще немає.';

  @override
  String get tourCupNoGroups => 'Груп ще не сформовано.';

  @override
  String get tourCupNoHistory => 'Історії ще немає.';

  @override
  String get tourCupPastWinners => 'МИНУЛІ ПЕРЕМОЖЦІ';

  @override
  String get tourCupPlayoffIntro =>
      'Два місця на чемпіонаті світу розігрують у плей-оф найкращі з тих, хто не пробився напряму.';

  @override
  String get tourCupQualDrawSoon =>
      'Групи ще не сформовані. Дивись жеребкування відбору з головної, щоб побачити їх.';

  @override
  String tourCupRegionYours(String region) {
    return '$region · твій';
  }

  @override
  String tourCupScorePens(int home, int away) {
    return '$home–$away (пен.)';
  }

  @override
  String get tourCupSegAllTime => 'За весь час';

  @override
  String get tourCupSegFinals => 'Фінали';

  @override
  String get tourCupSegQualifying => 'Відбір';

  @override
  String get playerTraitsTitle => 'ВІЗИТІВКА';

  @override
  String get traitBigGame => 'Гравець великих матчів';

  @override
  String get traitBigGameBlurb => 'Піднімає свою гру в матчах на вибування.';

  @override
  String get traitSetPiece => 'Майстер стандартів';

  @override
  String get traitSetPieceBlurb =>
      'Краще подає й частіше забиває зі стандартів.';

  @override
  String get traitHothead => 'Запальний';

  @override
  String get traitHotheadBlurb =>
      'Збирає набагато більше карток, ніж партнери.';

  @override
  String get traitIronMan => 'Залізна людина';

  @override
  String get traitIronManBlurb => 'Рідко травмується й повільніше втомлюється.';

  @override
  String get traitWonderkid => 'Вундеркінд';

  @override
  String get traitWonderkidBlurb => 'Молодий, уже сильний і швидко прогресує.';

  @override
  String get traitLeader => 'Лідер';

  @override
  String get traitLeaderBlurb => 'Підіймає кожного партнера на полі.';

  @override
  String get traitPacey => 'Швидкий';

  @override
  String get traitPaceyBlurb =>
      'Бліскавична швидкість, небезпечний за спиною захисту.';

  @override
  String get traitOldHead => 'Досвідчений';

  @override
  String get traitOldHeadBlurb =>
      'Ветеран: розуміння гри в нього переживе ноги.';

  @override
  String get traitWasteful => 'Марнотратний';

  @override
  String get traitWastefulBlurb => 'Надто часто шле добрі моменти повз ворота.';

  @override
  String get objectiveWorldCup => 'Чемпіонат світу';

  @override
  String get objectiveWinTournament => 'Виграти турнір';

  @override
  String get objectiveQualifyGeneric => 'Кваліфікуватися';

  @override
  String hubBoardObjectiveFor(String competition, String label) {
    return '$competition: $label';
  }

  @override
  String get objectiveWinWorldCup => 'Виграти чемпіонат світу';

  @override
  String get objectiveReachFinal => 'Дійти до фіналу';

  @override
  String get objectiveReachSemis => 'Дійти до півфіналу';

  @override
  String get objectiveReachQuarters => 'Дійти до чвертьфіналу';

  @override
  String get objectiveReachKnockouts => 'Вийти в плей-оф';

  @override
  String get objectiveQualify => 'Кваліфікуватися на чемпіонат світу';

  @override
  String get finishChampions => 'Чемпіони';

  @override
  String get finishRunnersUp => 'Срібні призери';

  @override
  String get finishSemiFinals => 'Півфінал';

  @override
  String get finishQuarterFinals => 'Чвертьфінал';

  @override
  String get finishRoundOf16 => '1/8 фіналу';

  @override
  String get finishGroupStage => 'Груповий етап';

  @override
  String get objectiveQualifyingTopHalf =>
      'Фінішувати у верхній половині кваліфікаційної групи';

  @override
  String get finishQualifyingTopHalf => 'Верхня половина кваліфікаційної групи';

  @override
  String get finishQualifyingBottomHalf =>
      'Нижня половина кваліфікаційної групи';

  @override
  String get objectiveNcWinIt => 'Виграти Nations Cup';

  @override
  String get objectiveNcReachFinal => 'Дійти до фіналу Nations Cup';

  @override
  String get objectiveNcFinalsFour => 'Вийти до Final Four';

  @override
  String get objectiveNcWinGroup => 'Виграти групу й піднятися вище';

  @override
  String get objectiveNcTopHalf => 'Фінішувати у верхній половині групи';

  @override
  String get objectiveNcSurvive => 'Уникнути пониження';

  @override
  String get finishNcChampions => 'Переможці Nations Cup';

  @override
  String get finishNcFinalsFour => 'Final Four';

  @override
  String get finishNcGroupWinners => 'Переможці групи';

  @override
  String get finishNcTopHalf => 'Верхня половина групи';

  @override
  String get finishNcStayedUp => 'Залишилися в лізі';

  @override
  String get finishNcBottom => 'Останнє місце в групі';

  @override
  String get careerNationsCupLabel => 'Nations Cup';

  @override
  String get squadDevPlayer => 'ГРАВЕЦЬ';

  @override
  String get squadDevAge => 'ВІК';

  @override
  String get squadDevPosition => 'ПОЗ';

  @override
  String get squadDevChange => 'РЕЙТИНГ';

  @override
  String get squadDevNew => 'НОВИЙ';

  @override
  String get squadDevRetired => 'ЗАВЕРШИВ';

  @override
  String get squadDevEmpty => 'Спокійний рік. У складі без змін.';

  @override
  String get squadDevTierRegulars => 'ПОСТІЙНІ';

  @override
  String get squadDevTierFringe => 'РЕЗЕРВ';

  @override
  String get squadDevTierYouth => 'МОЛОДЬ';

  @override
  String get boardObjectivesTitle => 'Завдання від ради';

  @override
  String get boardObjectivesConfidence => 'Довіра ради';

  @override
  String boardObjectiveBeatenBy(String result, int rounds) {
    String _temp0 = intl.Intl.pluralLogic(
      rounds,
      locale: localeName,
      other: 'на $rounds раунду краще, ніж вимагалося',
      many: 'на $rounds раундів краще, ніж вимагалося',
      few: 'на $rounds раунди краще, ніж вимагалося',
      one: 'на $rounds раунд краще, ніж вимагалося',
    );
    return '$result: $_temp0';
  }

  @override
  String boardObjectiveShortBy(String result, int rounds) {
    String _temp0 = intl.Intl.pluralLogic(
      rounds,
      locale: localeName,
      other: 'бракує $rounds раунду',
      many: 'бракує $rounds раундів',
      few: 'бракує $rounds раундів',
      one: 'бракує $rounds раунду',
    );
    return '$result: $_temp0';
  }

  @override
  String get boardObjectivesPending => 'ЩЕ НЕ ВИЗНАЧЕНО';

  @override
  String boardObjectiveSoFar(String result) {
    return 'ПОКИ ЩО · $result';
  }

  @override
  String get boardObjectivesEmpty => 'Рада не поставила завдань на цей цикл.';

  @override
  String get tourContBestWinners => 'НАЙКРАЩІ ПЕРЕМОЖЦІ ГРУП';

  @override
  String get tourContBestThirds => 'НАЙКРАЩІ ТРЕТІ МІСЦЯ';

  @override
  String tourContBestPlaced(String position) {
    return 'НАЙКРАЩІ НА $position-МУ МІСЦІ';
  }

  @override
  String squadDevPageOf(String page, String pages, String total) {
    return '$page/$pages · гравців: $total';
  }

  @override
  String get matchSoldOut => 'АНШЛАГ';

  @override
  String matchAttendanceOf(String attendance, String capacity) {
    return 'Заповнено $attendance із $capacity місць';
  }

  @override
  String get matchGroundTitle => 'СТАДІОН';

  @override
  String get absenceInjured => 'Травмований';

  @override
  String get absenceSuspended => 'Дискваліфікований';

  @override
  String absenceWeeks(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString тижня',
      many: '$countString тижнів',
      few: '$countString тижні',
      one: '$countString тиждень',
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
      other: '$countString матчу',
      many: '$countString матчів',
      few: '$countString матчі',
      one: '$countString матч',
    );
    return '$_temp0';
  }

  @override
  String absenceBackFor(String opponent) {
    return 'Повернеться на матч: $opponent';
  }

  @override
  String get penaltyOrderTitle => 'Пенальті';

  @override
  String get penaltyOrderBlurb =>
      'Назви п’ятьох виконавців по черзі. Торкнись слота, щоб змінити.';

  @override
  String penaltyOrderPick(int number) {
    return 'Удар $number';
  }

  @override
  String get penaltyOrderPickBlurb =>
      'Обери, хто вийде бити. Смуга показує його холоднокровність з відмітки.';

  @override
  String get penaltyOrderConfirm => 'Бити';

  @override
  String get penaltyOrderCancel => 'Назад';

  @override
  String get youthTitle => 'Молодь';

  @override
  String get youthEmptyLevel => 'На цьому рівні поки нікого.';

  @override
  String get youthReleased => 'Відпущені цього року';

  @override
  String get u21Title => 'Гравці до 21 року';

  @override
  String get u21Blurb =>
      'Наступне покоління, найперспективніші першими. Порожні зірки: оцінка скаута. Заграй гравця за збірну, щоб дізнатися, на що він справді здатний.';

  @override
  String get u21Empty =>
      'Зараз у пулі немає нікого до 21 року. Нова група прийде з новим циклом.';

  @override
  String u21Breakout(int gain) {
    return '+$gain ЗА РІК';
  }

  @override
  String u21AgeCaps(int age, int caps) {
    return 'Вік $age · матчів: $caps';
  }

  @override
  String u21AgeUncapped(int age) {
    return 'Вік $age · без матчів за збірну';
  }

  @override
  String get u21CallUps => 'До викликів';

  @override
  String get youthWatching => 'Під наглядом';

  @override
  String get youthWatchEmpty =>
      'Поки нікого не позначено. Познач хлопця на будь-якому рівні, і він з’явиться тут разом із тим, ким став відтоді.';

  @override
  String get youthWatchMark => 'Стежити за цим хлопцем';

  @override
  String get youthWatchUnmark => 'Не стежити за ним';

  @override
  String youthWatchMarked(int rating, int age) {
    return 'Позначено з рейтингом $rating у віці $age';
  }

  @override
  String get youthWatchSenior => 'Перейшов до дорослого пулу';

  @override
  String get youthWatchReleased => 'Відпущений академією';

  @override
  String get youthWatchGone => 'Більше не в системі';

  @override
  String get tacticsYouth => 'Гравці до 21 року';

  @override
  String get pressSquad => 'Склад';

  @override
  String get pressBoard => 'Рада';

  @override
  String get pressNoEffect => 'Ніхто не надасть цьому значення';

  @override
  String get matchNeutralGround => 'НЕЙТРАЛЬНЕ';

  @override
  String get matchExtraTimeAhead => 'ДОДАТКОВИЙ ЧАС';

  @override
  String get matchExtraTimeHalf => 'ДОДАТКОВИЙ ЧАС · ПЕРЕРВА';

  @override
  String get matchClockFullTime => 'ФІНАЛЬНИЙ СВИСТОК';

  @override
  String get matchClockAfterExtraTime => 'ПІСЛЯ ДОД. ЧАСУ';

  @override
  String get matchClockPenalties => 'ПЕНАЛЬТІ';

  @override
  String get matchClockFullTimePenalties => 'ФІНАЛЬНИЙ СВИСТОК · ПЕНАЛЬТІ';

  @override
  String get hubEventPressConference => 'Зустріч із пресою';

  @override
  String get hubEventPressConferenceSub =>
      'Світові медіа хочуть поговорити ще до твого першого матчу';

  @override
  String get squadDevWonderkid => 'ВУНДЕРКІНД';

  @override
  String get tacticsPlaystyle => 'Стиль гри';

  @override
  String get tacticsPlaystyleBlurb =>
      'Обери, як грає команда; повзунки нижче уточнюють стиль.';

  @override
  String get tacticsPlaystyleCustom =>
      'Твої власні налаштування. Жоден названий стиль не збігається з цими параметрами.';

  @override
  String get playstyleCustom => 'Власний';

  @override
  String get playstyleBalanced => 'Збалансований';

  @override
  String get playstylePossession => 'Володіння';

  @override
  String get playstyleGegenpress => 'Гегенпресинг';

  @override
  String get playstyleCounter => 'Контратака';

  @override
  String get playstyleDirect => 'Прямий';

  @override
  String get playstyleLowBlock => 'Низький блок';

  @override
  String get playstyleWingPlay => 'Гра флангами';

  @override
  String get playstyleBalancedBlurb =>
      'Надійно в обох половинах, без перегинів.';

  @override
  String get playstylePossessionBlurb =>
      'Тримати м’яч, терпляче розгортати атаки, стискати поле.';

  @override
  String get playstyleGegenpressBlurb =>
      'Повертати м’яч одразу після втрати, високо на полі.';

  @override
  String get playstyleCounterBlurb =>
      'Відсунутися, триматися компактно, а потім вириватися на швидкості.';

  @override
  String get playstyleDirectBlurb => 'Швидко вперед і боротьба за другий м’яч.';

  @override
  String get playstyleLowBlockBlurb => 'Глибоко, вузько й дуже важко пробити.';

  @override
  String get playstyleWingPlayBlurb =>
      'Розтягнути поле, обійти по флангу й навісити.';

  @override
  String get nationsRandomTeam => 'Випадкова збірна';

  @override
  String get nationsFromTheBottom => 'З самого низу';

  @override
  String get bottomStartTitle => 'Без роботи';

  @override
  String get bottomStartHeading => 'Три федерації хочуть поговорити';

  @override
  String get bottomStartBlurb =>
      'У тебе немає ні роботи, ні репутації. Це єдині збірні, готові ризикнути. Візьмись за одну з них і збудуй щось із нуля.';

  @override
  String get bottomStartAccept => 'Погодитися';

  @override
  String get bottomStartBack => 'Назад до меню';

  @override
  String bottomStartRankOf(int rank, int total) {
    return '$rank із $total у світі';
  }

  @override
  String get campTitle => 'Базовий табір';

  @override
  String campBasedIn(String host) {
    return 'Табір: $host';
  }

  @override
  String get campBlurb =>
      'Де команда живе весь турнір. Після початку змінити не можна, і табір впливає на три речі в кожному матчі: наскільки свіжими вони приїжджають, як швидко гояться удари і наскільки вони у формі.';

  @override
  String get campEffectTravel => 'Свіжий приїзд';

  @override
  String get campEffectRecovery => 'Швидке одужання';

  @override
  String get campEffectSharpness => 'Ігрова форма';

  @override
  String get campTerrainCity => 'Центр міста';

  @override
  String get campTerrainCoastal => 'Курорт на узбережжі';

  @override
  String get campTerrainMountain => 'Гірський притулок';

  @override
  String get campTerrainAltitude => 'Табір на висоті';

  @override
  String get campTerrainNationalCentre => 'Національний центр';

  @override
  String get campTerrainCityBlurb =>
      'Усе під рукою й нікуди їхати, але ні спокою, ні тиші від шуму.';

  @override
  String get campTerrainCoastalBlurb =>
      'Тихо, зручно й добре для настрою; до кожного стадіону довга дорога автобусом.';

  @override
  String get campTerrainMountainBlurb =>
      'Прохолодне повітря й першокласна медицина, що швидко ставить на ноги, але далеко від турніру.';

  @override
  String get campTerrainAltitudeBlurb =>
      'Тренуватися важко, зате ноги витримують аж до кінця турніру.';

  @override
  String get campTerrainNationalCentreBlurb =>
      'Власна база федерації: нічого видатного, але й нічого, що могло б підвести.';

  @override
  String get hubEventChooseCamp => 'Обрати базовий табір';

  @override
  String hubEventChooseCampSub(String host) {
    return 'Де команда базуватиметься в країні: $host';
  }

  @override
  String get tacticsTabBench => 'Лава';

  @override
  String get squadSearchHint => 'Пошук за іменем або клубом';

  @override
  String get squadFilterAll => 'Усі';

  @override
  String get squadFilterInSquad => 'У складі';

  @override
  String get squadFilterUncapped => 'Без матчів';

  @override
  String get squadFilterUnavailable => 'Недоступні';

  @override
  String get squadLineAll => 'Усі лінії';

  @override
  String get squadSortBy => 'Сортувати';

  @override
  String get squadSortRating => 'Рейтинг';

  @override
  String get squadSortCaps => 'Матчі';

  @override
  String get squadSortGoals => 'Голи';

  @override
  String get squadSortAge => 'Вік';

  @override
  String get squadSortName => 'Ім’я';

  @override
  String get squadLegendTitle => 'Що означають позначки';

  @override
  String get squadLegendStarting => 'У стартовому складі';

  @override
  String get squadLegendCalledUp => 'Викликаний, на лаві';

  @override
  String get squadLegendRatingUp => 'Рейтинг зростає цього року';

  @override
  String get squadLegendRatingDown => 'Рейтинг падає цього року';

  @override
  String get squadLegendInjured => 'Травмований, недоступний';

  @override
  String get squadLegendSuspended => 'Дискваліфікований, недоступний';

  @override
  String get squadLegendTraits => 'ВІЗИТІВКА';

  @override
  String squadShowingOf(int shown, int total) {
    return 'Показано $shown із $total гравців';
  }

  @override
  String get squadNobodyMatches => 'У пулі немає гравців за цими фільтрами.';

  @override
  String get squadStatPool => 'Пул';

  @override
  String get squadStatInSquad => 'Викликані';

  @override
  String get squadMostCapped => 'Найбільше матчів';

  @override
  String get squadTopScorer => 'Найкращий бомбардир';

  @override
  String squadCapsValue(String name, int caps) {
    return '$name · матчів: $caps';
  }

  @override
  String squadGoalsValue(String name, int goals) {
    return '$name · голів: $goals';
  }

  @override
  String squadAgeClub(int age, String club) {
    return '$age · $club';
  }

  @override
  String get squadCapsShort => 'Матчі';

  @override
  String get squadGoalsShort => 'Гол';

  @override
  String get recordsRecordBookSubtitle =>
      'Матчі, голи й головні рекорди команди';

  @override
  String get statsLegacy => 'СПАДЩИНА';

  @override
  String tacticsSubAlreadyOff(String name) {
    return '$name уже замінений і не може повернутися на поле.';
  }

  @override
  String tacticsSubSentOff(String name) {
    return '$name вилучений і більше не бере участі в матчі.';
  }

  @override
  String get tacticsInjuredShort => 'ТРАВМА';

  @override
  String get tacticsSuspendedShort => 'ДИСКВАЛ.';

  @override
  String get confEurope => 'Європа';

  @override
  String get confSouthAmerica => 'Південна Америка';

  @override
  String get confNorthAmerica => 'Північна Америка';

  @override
  String get confAfrica => 'Африка';

  @override
  String get confAsia => 'Азія';

  @override
  String get confOceania => 'Океанія';

  @override
  String get compWorldCup => 'Чемпіонат світу';

  @override
  String get compWorldCupFinals => 'Фінальна частина чемпіонату світу';

  @override
  String get compWorldCupQualifying => 'Відбір до чемпіонату світу';

  @override
  String compQualifiers(String region) {
    return 'Відбір: $region';
  }

  @override
  String get compFriendlies => 'Товариські матчі';

  @override
  String get compNationsCup => 'Nations Cup';

  @override
  String get compContinentalClash => 'Continental Clash';

  @override
  String get compIntercontinentalPlayoff => 'Міжконтинентальний плей-оф';

  @override
  String get compContinentalChampionship => 'Континентальний чемпіонат';

  @override
  String get compEuropeanChampionship => 'Чемпіонат Європи';

  @override
  String get compSouthAmericaCup => 'Кубок Південної Америки';

  @override
  String get compAfricanChampionship => 'Чемпіонат Африки';

  @override
  String get compAsianChampionship => 'Чемпіонат Азії';

  @override
  String get compNorthAmericaCup => 'Кубок Північної Америки';

  @override
  String get compOceaniaCup => 'Кубок Океанії';

  @override
  String get msgANation => 'Якась збірна';

  @override
  String get msgAPlayer => 'Якийсь гравець';

  @override
  String get msgAHostNation => 'країна-господар';

  @override
  String get msgCycleTitle1 => 'Починається новий цикл';

  @override
  String msgCycleTitle2(int year) {
    return 'Шлях до $year відкрито';
  }

  @override
  String get msgCycleTitle3 => 'Нова кампанія';

  @override
  String get msgCycleTitle4 => 'Знову до роботи';

  @override
  String msgCycleBody1(int year) {
    return 'Шлях до чемпіонату світу $year починається тут.';
  }

  @override
  String msgCycleBody2(int year) {
    return 'Новий цикл. Ціль: чемпіонат світу $year.';
  }

  @override
  String msgCycleBody3(int year) {
    return 'Чотири роки до чемпіонату світу $year. Робота починається зараз.';
  }

  @override
  String msgCycleBody4(int year) {
    return 'Кампанія $year стартує сьогодні.';
  }

  @override
  String msgContHostTitle(String cup, String host) {
    return '$cup, господар: $host';
  }

  @override
  String msgContHostBody(String host, String cup) {
    return 'Господар наступного турніру ($cup): $host.';
  }

  @override
  String msgContQualDrawTitle(String cup) {
    return '$cup: жеребкування відбору';
  }

  @override
  String msgContQualDrawBody(String cup) {
    return 'Кваліфікаційні групи ($cup) сформовано.';
  }

  @override
  String msgWcHostTitle(String host, int year) {
    return 'Чемпіонат світу $year, господар: $host';
  }

  @override
  String msgWcHostBody(String host, int year) {
    return 'Чемпіонат світу $year прийматиме: $host.';
  }

  @override
  String get msgWcQualDrawTitle => 'Жеребкування відбору до чемпіонату світу';

  @override
  String get msgWcQualDrawBody =>
      'Кваліфікаційні групи чемпіонату світу сформовано.';

  @override
  String msgContFinalsDrawTitle(String cup) {
    return '$cup: жеребкування фіналу';
  }

  @override
  String msgContFinalsDrawBody(String cup) {
    return 'Групи фінальної частини ($cup) сформовано.';
  }

  @override
  String get msgWcFinalsDrawTitle => 'Жеребкування фіналу чемпіонату світу';

  @override
  String msgWcFinalsDrawBody(int year) {
    return 'Жеребкування фінальної частини чемпіонату світу $year відбулося.';
  }

  @override
  String get msgQualWcTitle1 => 'Путівка на чемпіонат світу';

  @override
  String get msgQualWcTitle2 => 'Чемпіонат світу вже наш';

  @override
  String get msgQualWcTitle3 => 'Їдемо на чемпіонат світу';

  @override
  String get msgQualWcTitle4 => 'Квиток у кишені';

  @override
  String msgQualWcBody1(int year) {
    return 'Ти кваліфікувався до фінальної частини чемпіонату світу $year.';
  }

  @override
  String msgQualWcBody2(int year) {
    return 'Це офіційно: твоя збірна буде на чемпіонаті світу $year.';
  }

  @override
  String msgQualWcBody3(int year) {
    return 'Місце на чемпіонаті світу $year забезпечено.';
  }

  @override
  String msgQualWcBody4(int year) {
    return 'Ти пробився до фінальної частини чемпіонату світу $year.';
  }

  @override
  String msgQualContTitle1(String cup) {
    return 'Вихід до турніру: $cup';
  }

  @override
  String msgQualContTitle2(String cup) {
    return 'Путівка здобута: $cup';
  }

  @override
  String msgQualContTitle3(String cup) {
    return 'Кваліфікація: $cup';
  }

  @override
  String msgQualContBody1(String cup) {
    return 'Твоя збірна пробилася до фінальної частини: $cup.';
  }

  @override
  String msgQualContBody2(String cup) {
    return 'Твоя збірна забезпечила собі місце: $cup.';
  }

  @override
  String msgQualContBody3(String cup) {
    return 'Ти пройшов відбір до турніру: $cup.';
  }

  @override
  String msgChampTitleMine1(String comp) {
    return '$comp: ЧЕМПІОНИ!';
  }

  @override
  String msgChampTitleMine2(String comp) {
    return 'Чемпіони: $comp!';
  }

  @override
  String msgChampTitleMine3(String comp) {
    return 'Ти виграв турнір: $comp!';
  }

  @override
  String msgChampTitleOther1(String comp) {
    return '$comp: переможця визначено';
  }

  @override
  String msgChampTitleOther2(String comp) {
    return '$comp: чемпіона коронували';
  }

  @override
  String msgChampTitleOther3(String comp) {
    return '$comp: переможець відомий';
  }

  @override
  String msgChampBodyMine1(String comp, String loser, String result, int year) {
    return '$comp $year: твоя збірна чемпіон! Переможений у фіналі: $loser$result.';
  }

  @override
  String msgChampBodyMine2(String comp, String loser, String result, int year) {
    return 'Ти виграв турнір: $comp, $year. Переможений у фіналі: $loser$result.';
  }

  @override
  String msgChampBodyMine3(String comp, String loser, String result, int year) {
    return '$comp $year за тобою. Переможений: $loser$result.';
  }

  @override
  String msgChampBodyOther1(
    String winner,
    String comp,
    String loser,
    String result,
    int year,
  ) {
    return '$comp $year: переміг $winner. Переможений у фіналі: $loser$result.';
  }

  @override
  String msgChampBodyOther2(
    String winner,
    String comp,
    String loser,
    String result,
    int year,
  ) {
    return '$comp $year: чемпіон $winner. Переможений у фіналі: $loser$result.';
  }

  @override
  String msgFinalScoreSuffix(int home, int away) {
    return ' ($home–$away)';
  }

  @override
  String msgFinalPensSuffix(int home, int away) {
    return ' (по пенальті після $home–$away)';
  }

  @override
  String get msgWpotyTitle => 'Гравець року у світі';

  @override
  String msgWpotyBodyMine(String name, String nation, int year) {
    return '$name ($nation) визнаний гравцем року у світі $year. Він із твоїх.';
  }

  @override
  String msgWpotyBodyOther(String name, String nation, int year) {
    return '$name ($nation) визнаний гравцем року у світі $year.';
  }

  @override
  String get msgYpotTitle => 'Молодий гравець турніру';

  @override
  String msgYpotBodyMine(String name, String nation, int age, int year) {
    return '$name ($nation), $age р., визнаний молодим гравцем турніру $year. Він із твоїх.';
  }

  @override
  String msgYpotBodyOther(String name, String nation, int age, int year) {
    return '$name ($nation), $age р., визнаний молодим гравцем турніру $year.';
  }

  @override
  String msgRankHold1(int rank) {
    return 'Ти тримаєшся на #$rank.';
  }

  @override
  String msgRankHold2(int rank) {
    return 'Без змін, усе ще #$rank.';
  }

  @override
  String msgRankHold3(int rank) {
    return 'Стабільно на #$rank.';
  }

  @override
  String msgRankUp1(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move місця',
      many: '$move місць',
      few: '$move місця',
      one: '$move місце',
    );
    return 'Загалом угору на $_temp0, до #$rank.';
  }

  @override
  String msgRankUp2(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move місця',
      many: '$move місць',
      few: '$move місця',
      one: '$move місце',
    );
    return 'Підйом на $_temp0 виводить тебе на #$rank.';
  }

  @override
  String msgRankUp3(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move місця',
      many: '$move місць',
      few: '$move місця',
      one: '$move місце',
    );
    return 'Угору на $_temp0, тепер #$rank.';
  }

  @override
  String msgRankDown1(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move місця',
      many: '$move місць',
      few: '$move місця',
      one: '$move місце',
    );
    return 'Загалом униз на $_temp0, до #$rank.';
  }

  @override
  String msgRankDown2(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move місця',
      many: '$move місць',
      few: '$move місця',
      one: '$move місце',
    );
    return 'Спад на $_temp0 опускає тебе на #$rank.';
  }

  @override
  String msgRankDown3(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move місця',
      many: '$move місць',
      few: '$move місця',
      one: '$move місце',
    );
    return 'Униз на $_temp0, тепер #$rank.';
  }

  @override
  String get msgRankLeadYou => 'Ти очолюєш світ.';

  @override
  String msgRankLeadOther(String nation) {
    return 'На вершині світу: $nation.';
  }

  @override
  String msgRankTitle(int rank) {
    return 'Світовий рейтинг · #$rank';
  }

  @override
  String msgRankBody(String lead, String movement) {
    return 'Світовий рейтинг оновлено. $lead $movement';
  }

  @override
  String msgRankJumpTitleUp(int rank) {
    return 'Підйом на #$rank';
  }

  @override
  String msgRankJumpTitleDown(int rank) {
    return 'Падіння на #$rank';
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
      other: '$move місця',
      many: '$move місць',
      few: '$move місця',
      one: '$move місце',
    );
    return '$tournament змінив світовий рейтинг. Збірна: $nation. Було #$from, стало #$to: підйом на $_temp0.';
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
      other: '$move місця',
      many: '$move місць',
      few: '$move місця',
      one: '$move місце',
    );
    return '$tournament змінив світовий рейтинг. Збірна: $nation. Було #$from, стало #$to: падіння на $_temp0.';
  }

  @override
  String get rankingSinceWcDraw => 'Від жеребкування чемпіонату світу';

  @override
  String get rankingSinceCycleStart => 'З початку кампанії';

  @override
  String rankingMovedFromTo(int from, int now) {
    return 'з #$from на #$now';
  }

  @override
  String msgCapsTitle(String name, int count) {
    return '$name: матчів за збірну $count';
  }

  @override
  String msgCapsBody(String name, int count) {
    return '$name уже зіграв за твою збірну. Матчів: $count.';
  }

  @override
  String msgGoalsTitle(String name, int count) {
    return '$name: голів за збірну $count';
  }

  @override
  String msgGoalsBody(String name, int count) {
    return '$name уже забив за твою збірну. Голів: $count.';
  }

  @override
  String msgDevTitle(int year) {
    return 'Розвиток складу · $year';
  }

  @override
  String msgThroughTitle(int year) {
    return 'З академії · $year';
  }

  @override
  String get msgThroughNote =>
      'Це не нова група. Це хлопці, які прийшли в одинадцять років і тепер виросли до дорослого пулу.';

  @override
  String msgNewFacesTitle(int year) {
    return 'Нові обличчя · $year';
  }

  @override
  String get msgIntakeNoteAcademy =>
      'Інвестиції в академію дають плоди: ця група прийшла сильнішою, ніж була б без них.';

  @override
  String get msgIntakeNoteStanding =>
      'Країна стежить за цією командою: збірна піднімається у світовому рейтингу, найкращі хлопці обирають футбол, і ця група прийшла сильнішою завдяки цьому.';

  @override
  String get msgIntakeNoteBoth =>
      'Гроші на академію і підйом команди у світовому рейтингу дають плоди: ця група прийшла сильнішою, ніж була б без них.';

  @override
  String msgIntakeTitle(int year) {
    return 'Набір академії · $year';
  }

  @override
  String msgRetireCaptainTitle(String name) {
    return 'Твій капітан $name завершує кар’єру';
  }

  @override
  String msgRetireTitle(String name) {
    return '$name завершує кар’єру в збірній';
  }

  @override
  String msgRetireBody(String name, int age) {
    return '$name завершив кар’єру в збірній у віці $age.';
  }

  @override
  String msgRetireBodyWith(String name, String tally, int age) {
    return '$name завершив кар’єру в збірній у віці $age. Підсумок: $tally.';
  }

  @override
  String msgTallyCaps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count матчу',
      many: '$count матчів',
      few: '$count матчі',
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
      many: '$count голів',
      few: '$count голи',
      one: '$count гол',
    );
    return '$_temp0';
  }

  @override
  String get msgArmbandVacant =>
      ' Капітанська пов’язка вільна. Признач нового капітана на екрані викликів.';

  @override
  String msgHofTitle(String name) {
    return '$name потрапляє до Зали слави';
  }

  @override
  String msgHofBody(String name, int caps, int goals) {
    return '$name приєднується до Зали слави твоєї збірної (матчів: $caps, голів: $goals). Дивись у розділі «Легенди».';
  }

  @override
  String hubBanTitle(String name) {
    return '$name дискваліфікований';
  }

  @override
  String hubBanBody(String name, String how, int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: 'наступні $matches матчу',
      many: 'наступних $matches матчів',
      few: 'наступні $matches матчі',
      one: 'твій наступний матч',
    );
    return '$name $how і дискваліфікований на $_temp0. Для відбору він недоступний.';
  }

  @override
  String get hubBanHowSecondYellow => 'вилучений за другу жовту картку';

  @override
  String get hubBanHowViolent => 'отримав пряму червону за грубу гру';

  @override
  String get hubBanHowRed => 'вилучений з поля';

  @override
  String hubInjuryTitle(String name) {
    return '$name травмований';
  }

  @override
  String hubInjuryBody(String name, int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: '$matches матчу',
      many: '$matches матчів',
      few: '$matches матчі',
      one: '$matches матч',
    );
    return '$name дістав травму й пропустить $_temp0.';
  }

  @override
  String get hubRunnerUpTitle1 => 'Срібні призери';

  @override
  String get hubRunnerUpTitle2 => 'Так близько, і все ж далеко';

  @override
  String get hubRunnerUpTitle3 => 'Срібні медалі';

  @override
  String hubRunnerUpBody1(String cup, String opponent) {
    return 'Ти дійшов до фіналу ($cup), але програв. Суперник: $opponent. Так близько. Цього разу срібло.';
  }

  @override
  String hubRunnerUpBody2(String cup, String opponent) {
    return 'Фінал ($cup) програно. Суперник: $opponent. Срібні призери, до болю близько.';
  }

  @override
  String hubRunnerUpBody3(String cup, String opponent) {
    return 'Фінал ($cup) вислизнув. Суперник: $opponent. Є чим пишатися, але без трофея.';
  }

  @override
  String get hubKnockedOutTitle1 => 'Вибули';

  @override
  String get hubKnockedOutTitle2 => 'Кінець шляху';

  @override
  String get hubKnockedOutTitle3 => 'Подорож завершено';

  @override
  String hubKnockedOutBody1(String cup, String opponent, String stage) {
    return 'Ти вибув з турніру ($cup). Етап: $stage, переміг $opponent.';
  }

  @override
  String hubKnockedOutBody2(String cup, String opponent, String stage) {
    return '$opponent зупиняє твій шлях. Турнір: $cup, етап: $stage.';
  }

  @override
  String hubKnockedOutBody3(String cup, String opponent, String stage) {
    return '$cup: кінець шляху. Етап: $stage, переміг $opponent.';
  }

  @override
  String get hubGroupExitTitle1 => 'Виліт із групи';

  @override
  String get hubGroupExitTitle2 => 'Вибули на груповому етапі';

  @override
  String get hubGroupExitTitle3 => 'Рано додому';

  @override
  String hubGroupExitBody1(String cup) {
    return 'Турнір ($cup) закінчився на груповому етапі. Не вистачило, щоб вийти в плей-оф.';
  }

  @override
  String hubGroupExitBody2(String cup) {
    return 'Вийти з групи не вдалося. Турнір ($cup) для тебе завершено.';
  }

  @override
  String hubGroupExitBody3(String cup) {
    return 'Цього разу без місця в плей-оф. Турнір ($cup) завершено на груповому етапі.';
  }

  @override
  String boardObjectiveMetTitle(String comp) {
    return 'Завдання виконано: $comp';
  }

  @override
  String boardObjectiveMissedTitle(String comp) {
    return 'Завдання провалено: $comp';
  }

  @override
  String boardObjectiveMetBody(String comp, String demand, String finish) {
    return 'Ціль ради ($comp): $demand. Твій результат: $finish. Рада отримала те, що просила.';
  }

  @override
  String boardObjectiveMissedBody(String comp, String demand, String finish) {
    return 'Ціль ради ($comp): $demand. Твій результат: $finish. Це менше, ніж очікували.';
  }

  @override
  String get newsWcMissTitle => 'Мрія про чемпіонат світу розбита';

  @override
  String newsWcMissBody(int year) {
    return 'Ти не потрапив на чемпіонат світу $year. Відбір не склався. Ще чотири роки.';
  }

  @override
  String get newsRecordScorerTitle => 'Найкращий бомбардир в історії';

  @override
  String newsRecordScorerBody(String name, int goals) {
    return '$name тепер найкращий бомбардир в історії гри: $goals голів.';
  }

  @override
  String get newsRecordCapsTitle => 'Рекордсмен за матчами за збірну';

  @override
  String newsRecordCapsBody(String name, int caps) {
    return '$name тепер гравець з найбільшою кількістю матчів за збірну в історії гри: $caps.';
  }

  @override
  String get newsARecordBreaker => 'Новий рекордсмен';

  @override
  String newsTransferTitle(String name, String club) {
    return '$name: новий клуб $club';
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
    return '$name ($position, $rating) залишає клуб $fromClub. Новий клуб: $destination, сума трансферу: $fee.';
  }

  @override
  String newsTransferAbroad(String club, String country) {
    return '$club, $country';
  }

  @override
  String get newsTransferFree => 'Безкоштовно';

  @override
  String newsNatzStarTitle(String name, String nation) {
    return '⭐ $name готовий змінити збірну: $nation!';
  }

  @override
  String newsNatzTitle(String name, String nation) {
    return '$name хоче грати за збірну: $nation';
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
    return '$name ($position, $age р., рейтинг $rating). Нинішня збірна: $fromNation. Має родинні зв’язки з країною $nation і готовий змінити збірну. Відкрий пропозицію натуралізації, щоб прийняти або відхилити її.';
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
    return '$name ($position, $age р., рейтинг $rating) справжня зірка. Нинішня збірна: $fromNation. Має родинні зв’язки з країною $nation і готовий змінити збірну. Відкрий пропозицію натуралізації, щоб прийняти або відхилити її.';
  }

  @override
  String get newsTheirNation => 'їхня країна';

  @override
  String get newsYourNation => 'твоя країна';

  @override
  String get tourStatusChampions => 'ЧЕМПІОНИ';

  @override
  String get tourStatusFinals => 'ФІНАЛИ';

  @override
  String get tourStatusQualifying => 'ВІДБІР';

  @override
  String get tourStatusUpcoming => 'ОЧІКУЄТЬСЯ';

  @override
  String get tourStatusInProgress => 'ТРИВАЄ';

  @override
  String get tourStatusComingSoon => 'СКОРО';

  @override
  String get tourStatusDecided => 'РОЗІГРАНО';

  @override
  String tourStatusLeague(String letter) {
    return 'ЛІГА $letter';
  }

  @override
  String get tourDrawWcQualifying => 'ЖЕРЕБКУВАННЯ КВАЛІФІКАЦІЇ ЧС';

  @override
  String tourDrawContQualifying(String cup) {
    return 'ЖЕРЕБКУВАННЯ ВІДБОРУ: $cup';
  }

  @override
  String get tourDrawWcHost => 'ГОСПОДАР ЧЕМПІОНАТУ СВІТУ';

  @override
  String tourDrawContHost(String cup) {
    return 'ГОСПОДАР: $cup';
  }

  @override
  String get tourDrawHostsReveal => 'А господарями стануть…';

  @override
  String get tourDrawHostReveal => 'А господарем стане…';

  @override
  String get tourDrawHostCandidates => 'Претенденти:';

  @override
  String get tourKickoffContinentalCup => 'КОНТИНЕНТАЛЬНИЙ КУБОК';

  @override
  String tourHostCompetitionYear(String competition, int year) {
    return '$competition $year';
  }

  @override
  String newsContMissTitle(String cup) {
    return 'Без участі: $cup';
  }

  @override
  String newsContMissBody(String cup) {
    return 'Ти не пробився до турніру $cup. Цього разу кампанія не вдалася.';
  }

  @override
  String get potyLabelBest => 'Гравець року';

  @override
  String get potyLabelYoung => 'Молодий гравець року';

  @override
  String potyTallyAssists(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count асиста',
      many: '$count асистів',
      few: '$count асисти',
      one: '$count асист',
    );
    return '$_temp0';
  }

  @override
  String potyOverallValue(int value) {
    return 'Рівень $value';
  }

  @override
  String potyRatingValue(String value) {
    return 'Оцінка $value';
  }

  @override
  String newsPotyTitle(int year) {
    return 'Гравець року у світі $year';
  }

  @override
  String newsPotyBody(String name) {
    return 'Найкращий гравець світу цього року: $name.';
  }

  @override
  String newsPotyYoungSuffix(String name) {
    return ' $name отримує нагороду найкращому молодому гравцю.';
  }

  @override
  String newsWatchTitle(int year) {
    return 'Хлопці, за якими ти стежиш, $year';
  }

  @override
  String newsWatchJump(String name, int rating, int gain) {
    String _temp0 = intl.Intl.pluralLogic(
      gain,
      locale: localeName,
      other: '$gain очка',
      many: '$gain очок',
      few: '$gain очки',
      one: '$gain очко',
    );
    return '$name підріс до $rating: на $_temp0 більше, ніж торік.';
  }

  @override
  String newsWatchBand(String name, String band) {
    return '$name переходить до вікової групи $band.';
  }

  @override
  String newsWatchDebutTitle(String name) {
    return 'Дебют $name';
  }

  @override
  String newsWatchDebutBody(String name, int age, int rating) {
    return '$name вийшов на поле вперше за збірну у $age р., рейтинг $rating. Один із хлопців, за якими ти стежиш.';
  }

  @override
  String get matchStatsAtFullTime =>
      'Володіння м’ячем, оцінки гравців і гравець матчу стануть відомі після фінального свистка.';

  @override
  String get matchPlayerRatings => 'ОЦІНКИ ГРАВЦІВ';

  @override
  String get matchSubstitutions => 'ЗАМІНИ';

  @override
  String get matchSubstitutes => 'ЗАПАСНІ';

  @override
  String get matchPlayerOfTheMatch => 'ГРАВЕЦЬ МАТЧУ';

  @override
  String get matchGoalShout => 'ГОЛ!';

  @override
  String matchShootoutScore(int home, int away) {
    return 'ПЕНАЛЬТІ $home–$away';
  }

  @override
  String matchShootoutKickScored(String name) {
    return '$name: ГОЛ';
  }

  @override
  String matchShootoutKickMissed(String name) {
    return '$name: МИМО';
  }

  @override
  String get matchFeedKickOff => 'Стартовий свисток!';

  @override
  String get matchFeedNoEvents => 'Подій поки немає.';

  @override
  String get tourVenues => 'СТАДІОНИ';

  @override
  String tourPot(int number) {
    return 'КОШИК $number';
  }

  @override
  String get tourHostSelection => 'ВИБІР ГОСПОДАРЯ';

  @override
  String get tourCandidates => 'ПРЕТЕНДЕНТИ';

  @override
  String get tourJointBid => 'СПІЛЬНА ЗАЯВКА';

  @override
  String get tourGoldenGlove => 'ЗОЛОТІ РУКАВИЦІ';

  @override
  String get tourTeamOfTournament => 'ЗБІРНА ТУРНІРУ';

  @override
  String get tourYourRun => 'ТВІЙ ШЛЯХ';

  @override
  String get tourMedalTable => 'МЕДАЛЬНИЙ ЗАЛІК';

  @override
  String tourHostLine(String nation) {
    return 'Господар: $nation';
  }

  @override
  String tourHostLineMulti(String hosts) {
    return 'Господарі: $hosts';
  }

  @override
  String tourGroupNamed(String name) {
    return 'Група $name';
  }

  @override
  String get tourFinalsDrawBlurb =>
      'Сіяння за світовим рейтингом. Знайди свою збірну до жеребкування.';

  @override
  String get tourWorldRanking => 'Світовий рейтинг';

  @override
  String get tourYourCompetitions => 'ТВОЇ ТУРНІРИ';

  @override
  String get tourOtherContinents => 'ІНШІ КОНТИНЕНТИ';

  @override
  String get tourZoneGlobal => 'СВІТ';

  @override
  String get tourZoneEurope => 'ЄВРОПА';

  @override
  String get tourZoneSouthAmerica => 'ПД. АМЕРИКА';

  @override
  String get tourZoneNorthAmerica => 'ПН. АМЕРИКА';

  @override
  String get tourZoneAfrica => 'АФРИКА';

  @override
  String get tourZoneAsia => 'АЗІЯ';

  @override
  String get tourZoneOceania => 'ОКЕАНІЯ';

  @override
  String get tourZoneIntercontinental => 'МІЖКОНТИНЕНТ.';

  @override
  String tourZoneLeague(String league) {
    return 'ЛІГА $league';
  }

  @override
  String tourHostedBy(String hosts) {
    return 'ГОСПОДАР  $hosts';
  }

  @override
  String tourThirdsAdvance(int count, String destination) {
    return 'Перші $count проходять до $destination';
  }

  @override
  String newsWalkoutTitle(String name) {
    return '$name йде зі збірної';
  }

  @override
  String newsWalkoutBody(String name, int age, int caps) {
    return '$name завершив виступи за збірну у $age р., маючи $caps матчів. Він просив сказати, на що йому розраховувати, але відповіді не отримав, і більше чекати не збирається.';
  }

  @override
  String get pressHeadlineWent1 => 'Тренер, який володіє залою';

  @override
  String get pressHeadlineWent2 => 'Вони прийшли за сваркою, а побачили лідера';

  @override
  String get pressHeadlineWent3 => 'Прямі відповіді, і вони влучили';

  @override
  String get pressHeadlineMixed1 => 'Сказано багато, вирішено мало';

  @override
  String get pressHeadlineMixed2 => 'Дещо для всіх і нічого ні для кого';

  @override
  String get pressHeadlineMixed3 =>
      'Конференція, що залишила питання відкритими';

  @override
  String get pressHeadlineBadly1 => 'Важкий день перед камерами';

  @override
  String get pressHeadlineBadly2 => 'Зала відвернулася, і це було помітно';

  @override
  String get pressHeadlineBadly3 => 'Відповіді, які зранку читатимуться гірше';

  @override
  String get pressHeadlineFlat1 => 'Нічого не сказано, нічого не здобуто';

  @override
  String get pressHeadlineFlat2 => 'Десять хвилин без новин';

  @override
  String get pressHeadlineFlat3 => 'Порожня сторінка замість заголовка';

  @override
  String get pressConferenceTitle => 'ПРЕСКОНФЕРЕНЦІЯ';

  @override
  String pressQuestionOf(int index, int total) {
    return 'Питання $index із $total';
  }

  @override
  String get pressTomorrowsHeadline => 'ЗАВТРАШНІЙ ЗАГОЛОВОК';

  @override
  String get pressLeaveRoom => 'ЗАЛИШИТИ ЗАЛУ';

  @override
  String get pressRoomVerdictSquad => 'Роздягальня';

  @override
  String get pressRoomVerdictBoard => 'Рада';

  @override
  String get yReactionElation0 => 'жодних зауважень. жодних. ідеально.';

  @override
  String get yReactionElation1 => 'мені недобре (у хорошому сенсі).';

  @override
  String get yReactionElation2 => 'оформлю в рамку. повішу над каміном.';

  @override
  String get yReactionElation3 => 'ми повернулися';

  @override
  String get yReactionElation4 =>
      'Роблю скріншот для скептиків. Для всіх до одного.';

  @override
  String get yReactionElation5 =>
      'Це я нагадуватиму ще десять років. Вибачте заздалегідь.';

  @override
  String get yReactionElation6 => 'Ось. Саме за це ми й дивимося.';

  @override
  String get yReactionElation7 => 'Такі дні окупають усі інші.';

  @override
  String get yReactionElation8 => 'Давно пора. Справді, давно пора.';

  @override
  String get yReactionElation9 =>
      'Чудово. Зробіть так само наступного тижня, і я повірю.';

  @override
  String get yReactionElation10 =>
      'Насолоджуйтесь вечором, бо ці хлопці знайдуть, як усе зіпсувати.';

  @override
  String get yReactionElation11 =>
      'Один гарний вечір ще нікого не робить великою командою.';

  @override
  String get yReactionRelief0 => 'Не красиво, але я беру це щоразу.';

  @override
  String get yReactionRelief1 => 'Якось. Якось!';

  @override
  String get yReactionRelief2 => 'Негарно. Три очки. Йдемо далі.';

  @override
  String get yReactionRelief3 =>
      'Я цілий день готовий дивитися негарне, якщо воно приносить очки.';

  @override
  String get yReactionRelief4 => 'оце зняло з мене років десять';

  @override
  String get yReactionRelief5 => 'Тихо всім. Не наврочте.';

  @override
  String get yReactionRelief6 => 'Пульс: неприпустимий.';

  @override
  String get yReactionRelief7 => 'Вижили. Ось слово. Вижили.';

  @override
  String get yReactionRelief8 =>
      'Нам не повинно бути потрібне полегшення після таких матчів.';

  @override
  String get yReactionRelief9 =>
      'Полегшення, і трохи соромно через це полегшення.';

  @override
  String get yReactionRelief10 =>
      'Якщо ми радіємо такому рівню, у нас проблеми.';

  @override
  String get yReactionRelief11 =>
      'Ледве проходити далі стало звичкою, і недобре.';

  @override
  String get yReactionFury0 => 'Цього замало. Зовсім.';

  @override
  String get yReactionFury1 => 'Поясніть мені це повільно.';

  @override
  String get yReactionFury2 => 'Дивитися було важко, і я ще кажу ввічливо.';

  @override
  String get yReactionFury3 => 'Розчарування. Справжнє розчарування.';

  @override
  String get yReactionFury4 => 'Абсолютний жах.';

  @override
  String get yReactionFury5 => 'Хочу імена.';

  @override
  String get yReactionFury6 => 'Видаляю застосунок. Встановлю знову в четвер.';

  @override
  String get yReactionFury7 =>
      'Ніхто на полі не виглядав так, ніби хоче перемогти.';

  @override
  String get yReactionFury8 => 'Кожні чотири роки те саме. КОЖНІ чотири роки.';

  @override
  String get yReactionFury9 => 'Це не гра, це образа.';

  @override
  String get yReactionFury10 =>
      'Люди жертвують вихідними й грошима заради такого. Подумайте.';

  @override
  String get yReactionFury11 =>
      'Роками стою за цю команду. Не сьогодні. Не після такого.';

  @override
  String get yReactionDespair0 => 'ну.';

  @override
  String get yReactionDespair1 => 'Сьогодні без жартів. Жодних.';

  @override
  String get yReactionDespair2 => 'Піду прогуляюся. Надовго.';

  @override
  String get yReactionDespair3 => 'У мене закінчилися слова.';

  @override
  String get yReactionDespair4 => 'Розбудіть через чотири роки.';

  @override
  String get yReactionDespair5 => 'це найтемніша з реальностей';

  @override
  String get yReactionDespair6 => 'Навіть злості вже немає. Ось що тривожить.';

  @override
  String get yReactionDespair7 => 'Це ще довго боляче відгукуватиметься.';

  @override
  String get yReactionDespair8 =>
      'Я вже не знаю, що це таке, але це не футбольна команда.';

  @override
  String get yReactionDespair9 => 'Ми далі, ніж були, і ніхто цього не скаже.';

  @override
  String get yReactionDespair10 =>
      'Ціле покоління змарновано, а далі вирішують ті самі люди.';

  @override
  String get yReactionDespair11 =>
      'Годі казати, що це процес. Він нікуди не веде.';

  @override
  String get yReactionSmugness0 => 'Тихенько, але ж попереджали.';

  @override
  String get yReactionSmugness1 => 'додайте це в закладки';

  @override
  String get yReactionSmugness2 => 'Скептики геть притихли.';

  @override
  String get yReactionSmugness3 => 'Не те щоб хтось рахував. Я рахую.';

  @override
  String get yReactionSmugness4 =>
      'Про це було сказано ще в січні. Перевірте стрічку.';

  @override
  String get yReactionSmugness5 => 'Дехто з вас винен комусь із нас вибачення.';

  @override
  String get yReactionSmugness6 => 'Кладу це в папку «пророцтва, що збулися».';

  @override
  String get yReactionSmugness7 => 'Без зловтіхи. Трошки зловтіхи.';

  @override
  String get yReactionSmugness8 => 'Де тепер усі експерти? Справді питаю.';

  @override
  String get yReactionSmugness9 => 'Хочу, щоб кожен із вас повторив це мені.';

  @override
  String get yReactionSmugness10 =>
      'Скріншот, роздруківка, рамка, і відправлено тим, хто сміявся.';

  @override
  String get yReactionSmugness11 =>
      'Я згадуватиму це все життя, і ви це заслужили.';

  @override
  String get yReactionShrug0 => 'це сталося. далі.';

  @override
  String get yReactionShrug1 => 'Гаразд. Байдуже. Далі.';

  @override
  String get yReactionShrug2 => 'Відправляю це в папку «футбол».';

  @override
  String get yReactionShrug3 => 'Справді нічого додати.';

  @override
  String get yReactionShrug4 => 'жодних думок, голова порожня';

  @override
  String get yReactionShrug5 => 'Розбудіть на наступний.';

  @override
  String get yReactionShrug6 => 'Це дев’яносто хвилин, яких мені не повернуть.';

  @override
  String get yReactionShrug7 => 'Ні туди, ні сюди, якщо чесно.';

  @override
  String get yReactionShrug8 => 'Не скажу вам жодної деталі, що там було.';

  @override
  String get yReactionShrug9 => 'Ще один такий. Їх багато.';

  @override
  String get yReactionShrug10 => 'Весь матч перед очима, а відчуттів нуль.';

  @override
  String get yReactionShrug11 =>
      'Якщо про це більше ніхто не згадає, мені так навіть краще.';

  @override
  String get tourThirdsUneven =>
      'Групи нерівні, тож результати проти найслабшої команди кожної більшої групи не враховуються, і всі команди оцінюються за однаковою кількістю матчів.';

  @override
  String get careerExportSave => 'Резервна копія цього збереження';

  @override
  String get careerBackupAll => 'КОПІЯ ВСІХ ЗБЕРЕЖЕНЬ';

  @override
  String get careerBackupAllFailed => 'Не вдалося створити резервну копію.';

  @override
  String get backupTitle => 'ЗБЕРЕЖЕННЯ';

  @override
  String get backupBlurb =>
      'Усі збереження лежать в одному файлі на цьому телефоні, і самі по собі вони ніде не копіюються. Експортуй копію й зберігай її поза телефоном, у Файлах або iCloud Drive, щоб втрачений телефон чи видалений застосунок не коштував тобі кар’єри.';

  @override
  String get backupExport => 'ЕКСПОРТ РЕЗЕРВНОЇ КОПІЇ';

  @override
  String get backupExportSubject => 'Збереження FNM';

  @override
  String get backupRestore => 'ВІДНОВИТИ З ФАЙЛУ';

  @override
  String get backupRestoreWarnTitle => 'Замінити всі збереження?';

  @override
  String get backupRestoreWarnBody =>
      'Відновлення замінить усі збереження на цьому телефоні тими, що у файлі. Застосунок перезапуститься.';

  @override
  String get backupRestoreConfirm => 'ЗАМІНИТИ';

  @override
  String get backupCancel => 'СКАСУВАТИ';

  @override
  String get backupExported => 'Резервна копія готова. Обери, де її зберегти.';

  @override
  String get backupFailed => 'Не вдалося створити резервну копію.';

  @override
  String get backupRejectedUnreadable => 'Цей файл не вдалося відкрити.';

  @override
  String get backupRejectedNotFnm => 'Це не збереження FNM.';

  @override
  String get backupRejectedNewer =>
      'Це збереження створено новішою версією застосунку. Спершу онови його.';

  @override
  String get backupRejectedTooOld =>
      'Це збереження надто старе для відновлення цією версією.';

  @override
  String get careerShare => 'Поділитися цією кар’єрою';

  @override
  String get careerImport => 'ІМПОРТ КАР’ЄРИ';

  @override
  String get careerShareSubject => 'Кар’єра в FNM';

  @override
  String get careerImported => 'Кар’єру імпортовано.';

  @override
  String get careerImportFailedUnreadable => 'Цей файл не є кар’єрою FNM.';

  @override
  String get careerImportFailedNewer =>
      'Цю кар’єру експортовано новішою версією застосунку. Спершу онови його.';

  @override
  String get careerImportFailedSlotsFull =>
      'Усі слоти збережень зайняті. Видали збереження, щоб звільнити місце, або розблокуй необмежену кількість збережень.';

  @override
  String get careerImportFailedNeedsPremium =>
      'Ця кар’єра вийшла за межі безкоштовного першого циклу. Розблокуй повну гру, щоб її імпортувати.';

  @override
  String get careerImportFailedCampaignRun =>
      'У цій кампанії вже є незавершена спроба. Спершу продовж або залиш її.';

  @override
  String get careerShareFailed => 'Не вдалося експортувати цю кар’єру.';

  @override
  String get managerRename => 'Змінити ім’я';

  @override
  String get managerRenameSave => 'Зберегти';

  @override
  String get managerTitle => 'ТРЕНЕР';

  @override
  String get managerSkills => 'ТВОЇ НАВИЧКИ';

  @override
  String managerPointsAvailable(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count очка для розподілу',
      many: '$count очок для розподілу',
      few: '$count очки для розподілу',
      one: '$count очко для розподілу',
      zero: 'Немає очок для розподілу',
    );
    return '$_temp0';
  }

  @override
  String get managerPointsHow =>
      'Два очки за кожен завершений цикл, одне за кожен виграний трофей.';

  @override
  String get managerSkillsScale =>
      'Кожна навичка починається з 5 і доходить до 20. Витрачене очко назавжди.';

  @override
  String get managerSkillManManagement => 'Робота з людьми';

  @override
  String get managerSkillManManagementBlurb =>
      'Кожне очко посилює на 3% вплив твоїх слів пресі й гравцям у роздягальні.';

  @override
  String get managerSkillTactical => 'Тактика';

  @override
  String get managerSkillTacticalBlurb =>
      'Кожне очко прискорює на 3% закріплення нової схеми, тож зміна розстановки коштує менше матчів.';

  @override
  String get managerSkillYouth => 'Розвиток молоді';

  @override
  String get managerSkillYouthBlurb =>
      'Кожне очко додає 1% до таланту, що виходить із твоєї академії, на додачу до фінансування.';

  @override
  String get managerSkillNegotiation => 'Перемовини';

  @override
  String get managerSkillNegotiationBlurb =>
      'Кожне очко дає на 2% більше грошей від федерації в кожному циклі.';

  @override
  String get managerStaff => 'ТВІЙ ШТАБ';

  @override
  String managerStaffWages(String amount) {
    return 'Зарплати: $amount за цикл';
  }

  @override
  String get managerRoleAssistant => 'Асистент тренера';

  @override
  String get managerRoleAssistantBlurb =>
      'Веде тренування: менше травм і кращі молоді гравці на підході.';

  @override
  String get managerRoleScout => 'Головний скаут';

  @override
  String get managerRoleScoutBlurb =>
      'Оцінює твоїх перспективних гравців і наступного суперника: точніші зірки й перевага в день матчу.';

  @override
  String get managerRoleFitness => 'Тренер з фізпідготовки';

  @override
  String get managerRoleFitnessBlurb => 'Тримає гравців на полі.';

  @override
  String staffEffectInjury(int percent) {
    return 'На $percent% менше травм';
  }

  @override
  String staffEffectYouth(int points) {
    return 'Молодь +$points до рівня';
  }

  @override
  String staffHiringInjury(int min, int max) {
    return 'Якщо найняти: на $min-$max% менше травм';
  }

  @override
  String staffHiringYouth(int minPoints, int maxPoints) {
    return 'і молодь +$minPoints-$maxPoints до рівня';
  }

  @override
  String staffEffectScoutRead(int percent) {
    return 'Точно оцінює $percent% перспективних гравців';
  }

  @override
  String staffEffectScoutCaps(int caps) {
    String _temp0 = intl.Intl.pluralLogic(
      caps,
      locale: localeName,
      other: 'Потенціал відомий після $caps матчу за збірну',
      many: 'Потенціал відомий після $caps матчів за збірну',
      few: 'Потенціал відомий після $caps матчів за збірну',
      one: 'Потенціал відомий після $caps матчу за збірну',
    );
    return '$_temp0';
  }

  @override
  String staffEffectScoutDossier(int points) {
    return '+$points до рейтингу від досьє на суперників';
  }

  @override
  String staffHiringScoutRead(int min, int max) {
    return 'Якщо найняти: $min-$max% оцінок точні';
  }

  @override
  String staffHiringScoutCaps(int minCaps, int maxCaps) {
    return 'і потенціал відомий на $minCaps-$maxCaps матчів раніше';
  }

  @override
  String staffHiringScoutDossier(int minPoints, int maxPoints) {
    return 'і +$minPoints-$maxPoints до рейтингу в кожному матчі';
  }

  @override
  String get staffEffectNone => 'Поки без впливу на твій склад';

  @override
  String get staffVacant => 'Посада вільна';

  @override
  String get staffLeaveVacant => 'Залишити посаду вільною';

  @override
  String get managerTierNone => 'Немає';

  @override
  String get managerTierBasic => 'Базовий';

  @override
  String get managerTierGood => 'Добрий';

  @override
  String get managerTierElite => 'Елітний';

  @override
  String get managerFree => 'безкоштовно';

  @override
  String get managerTraining => 'МІЖ ВІКНАМИ';

  @override
  String get managerTrainingBlurb =>
      'Над чим працює команда, коли немає матчів.';

  @override
  String get managerFocusBalanced => 'Збалансовано';

  @override
  String get managerFocusBalancedBlurb => 'Потроху всього.';

  @override
  String get managerFocusFitness => 'Фізпідготовка';

  @override
  String get managerFocusFitnessBlurb => 'Менше ударів і травм.';

  @override
  String get managerFocusCohesion => 'Згуртованість';

  @override
  String get managerFocusCohesionBlurb => 'Схема закріплюється швидше.';

  @override
  String get managerFocusYouth => 'Молодь';

  @override
  String get managerFocusYouthBlurb => 'Години з наймолодшими в пулі.';

  @override
  String get tourOfferTitle => 'Ти тут уперше?';

  @override
  String get tourOfferBody =>
      'Це велика гра. Хочеш швидко пройтися по найважливіших екранах? Це займе хвилину, а повторити можна будь-коли в налаштуваннях.';

  @override
  String get tourOfferYes => 'Покажи мені все';

  @override
  String get tourOfferNo => 'Ні, дякую';

  @override
  String get tourBack => 'Назад';

  @override
  String get tourNext => 'Далі';

  @override
  String get tourDone => 'Готово';

  @override
  String get tourSkip => 'Пропустити';

  @override
  String get tourHubTitle => 'Це вся гра';

  @override
  String get tourHubBody =>
      'Одна кнопка, і вона змінюється разом із циклом: жеребкування для перегляду, склад для оголошення, матч для гри. Над нею довіра ради до тебе й завдання, які вона поставила.';

  @override
  String get tourBudgetTitle => 'Гроші федерації';

  @override
  String get tourBudgetBody =>
      'Раз на чотирирічний цикл ти ділиш скарбницю між відділами. З неї першими виплачують зарплату твоєму штабу, тож найм елітного скаута відбирає гроші в академії.';

  @override
  String get tourTacticsTitle => 'Як грає команда';

  @override
  String get tourTacticsBody =>
      'Твоя схема, стиль гри, капітан і виконавці стандартів. Якщо залишиш останні два порожніми, гра попередить тебе перед стартовим свистком, а не вибере тихцем за тебе.';

  @override
  String get tourSquadTitle => 'Усі, кого можна викликати';

  @override
  String get tourSquadBody =>
      'Увесь пул, а не лише склад: хто у формі, хто з травмою, хто дискваліфікований і хто щойно прийшов з академії.';

  @override
  String get tourCallUpsTitle => 'Оголошення складу';

  @override
  String get tourCallUpsBody =>
      'Ти оголошуєш один склад на міжнародне вікно, і він грає всі матчі цього вікна, як у справжнього тренера. Якщо хтось травмується протягом вікна, заміну викликають за тебе.';

  @override
  String get tourRecordsTitle => 'Твоя кар’єра';

  @override
  String get tourRecordsBody =>
      'Усе, що ти зробив: матчі, командні рекорди, трофеї та кожна збірна, яку ти очолював.';

  @override
  String get tourCupsTitle => 'Решта світу';

  @override
  String get tourCupsBody =>
      'Усі змагання, що тривають зараз: групи, таблиці й плей-оф, зокрема ті, де тебе немає. Світ грає далі, чи пробився ти, чи ні.';

  @override
  String get settingsTourTitle => 'Повторити навчання';

  @override
  String get settingsTourBlurb => 'Пройти ключові екрани ще раз з початку.';

  @override
  String get tourBoardTitle => 'Перед ким ти відповідаєш';

  @override
  String get tourBoardBody =>
      'Довіра ради до тебе й завдання, які вона поставила на цей цикл. Якщо не виконаєш завдання, ти побачиш це тут заздалегідь.';

  @override
  String get tourStaffTitle => 'Люди навколо тебе';

  @override
  String get tourStaffBody =>
      'Асистент, скаут і тренер з фізпідготовки, яких ти наймаєш поіменно. Їхні зарплати йдуть із цього бюджету раніше за відділи, тож чудовий скаут відбирає гроші в академії.';

  @override
  String get tourPlaystyleTitle => 'Твій стиль гри';

  @override
  String get tourPlaystyleBody =>
      'Схема є лише половиною тактики. Ось друга половина: наскільки високо ти пресуєш, наскільки прямо граєш і скільки ризикуєш.';

  @override
  String get settingsTourNoSave =>
      'Спершу почни кар’єру. Навчання проходить по твоїх власних екранах.';

  @override
  String tacticsOutOfPositionAge(int age) {
    return 'Не на своїй позиції · $age р.';
  }

  @override
  String get federationNextCycleLocked =>
      'Бюджет наступного циклу визначається на його початку, одразу весь. А поки що ось на що йдуть твої гроші.';

  @override
  String get federationBudgetAlreadySet => 'Уже визначено на цей цикл';

  @override
  String yFinalLooms0(String opponent) {
    return 'Фінал проти: $opponent. Цілий тиждень тільки про це й говоритимуть.';
  }

  @override
  String yFinalLooms1(String opponent) {
    return 'Підтверджено: на шляху до цього стоїть $opponent. Чотири роки заради цього.';
  }

  @override
  String yFinalLooms2(String opponent) {
    return 'Ну все. Суперник: $opponent. Ніхто не спатиме, поки це не закінчиться.';
  }

  @override
  String yFinalLooms3(String opponent) {
    return 'Далі суперник: $opponent, а все інше почекає. Який тиждень!';
  }

  @override
  String get matchSetupLeaveToCoach => 'Залишити виконавців тренеру';

  @override
  String friendliesLikeYourGroup(String rivals) {
    return 'Позначено нижче: команди зі схожим стилем, як у ваших суперників у групах цього циклу: $rivals.';
  }

  @override
  String newsTransferWindowTitle(int year) {
    return 'Трансферне вікно · $year';
  }

  @override
  String careerLastAgo(String when) {
    return 'Востаннє $when тому';
  }

  @override
  String get settingsFreeScopeTitle => 'Один безкоштовний чотирирічний цикл';

  @override
  String get settingsFreeScopeBlurb =>
      'Повний цикл (відбір, твій континентальний чемпіонат і чемпіонат світу) на двох збереженнях, усі країни світу, нічого не приховано. Нескінченні цикли й необмежена кількість збережень це один платіж, раз і назавжди, і він охоплює всі майбутні оновлення.';

  @override
  String get settingsUnlockedTitle => 'Розблоковано';

  @override
  String get settingsUnlockedBlurb =>
      'Нескінченні цикли, необмежена кількість збережень і всі майбутні оновлення. Дякуємо.';

  @override
  String get settingsFromDeveloperTitle => 'Від розробника';

  @override
  String get settingsFromDeveloperBlurb =>
      'Football Nations Manager створює одна людина, і гру підтримуватимуть довго. Реклами й мікротранзакцій не буде ніколи. Якщо гра тобі подобається, подумай про купівлю повної версії. Саме вона забезпечує оновлення.';

  @override
  String get settingsFromDeveloperThanksBlurb =>
      'Football Nations Manager створює одна людина, і гру підтримуватимуть довго. Реклами й мікротранзакцій не буде ніколи. Дякуємо за купівлю повної версії. Саме вона забезпечує оновлення.';

  @override
  String friendliesLikeYourCampaign(String rivals) {
    return 'Позначено нижче: команди зі схожим стилем, як у суперників, з якими тобі ще належить зіграти: $rivals.';
  }

  @override
  String get friendliesCloseToYou =>
      'Позначено нижче: команди, найближчі до тебе у світовому рейтингу. Після жеребкування позначки йтимуть за твоєю групою.';

  @override
  String transfersMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count переходу',
      many: '$count переходів',
      few: '$count переходи',
      one: '$count перехід',
    );
    return '$_temp0';
  }

  @override
  String hubRoundPage(int page, int pages) {
    return '$page / $pages';
  }

  @override
  String get transfersNewer => 'Новіші';

  @override
  String get transfersOlder => 'Ще';

  @override
  String get transfersPagePrevious => 'Назад';

  @override
  String get transfersPageNext => 'Далі';

  @override
  String transfersPageOf(int page, int pages) {
    return 'Сторінка $page з $pages';
  }

  @override
  String get transfersMovedTo => 'Перейшов до';

  @override
  String get transfersUnknownClub => 'Невідомий клуб';

  @override
  String yAgainstThemAgain0(String opponent, String count) {
    return 'Це вже $count-й раз проти: $opponent. Хтось веде рахунок, і це вони.';
  }

  @override
  String yAgainstThemAgain1(String opponent, String count) {
    return 'Знову $opponent. Матчів: $count, а ми так і не розгадали їх.';
  }

  @override
  String yAgainstThemAgain2(String opponent, String count) {
    return 'Матч номер $count проти: $opponent. Це давно не випадковість.';
  }

  @override
  String yAgainstThemAgain3(String opponent, String count) {
    return 'Ми грали з суперником $opponent уже $count разів і не навчилися нічого.';
  }

  @override
  String yAgainstThemAgain4(String opponent, String count) {
    return '$opponent, $count разів. Вони точно знають, що ми зробимо.';
  }

  @override
  String yAgainstThemAgain5(String opponent, String count) {
    return 'Що б не мав на нас $opponent, після $count матчів воно все ще при ньому.';
  }

  @override
  String ySameOldStory0(String count) {
    return 'Це вже $count разів останнім часом. Коли ми визнаємо, що такі і є?';
  }

  @override
  String ySameOldStory1(String count) {
    return 'Уже $count таких днів. Це закономірність, а не смуга невезіння.';
  }

  @override
  String ySameOldStory2(String count) {
    return 'Ми бачили цей самий матч $count разів нещодавно. Той самий сценарій, той самий кінець.';
  }

  @override
  String ySameOldStory3(String count) {
    return 'Уже $count версій тих самих дев’яноста хвилин. Ніхто це не виправляє.';
  }

  @override
  String ySameOldStory4(String count) {
    return '$count разів. Якщо ви досі не бачите закономірності, ви не дивитеся.';
  }

  @override
  String ySameOldStory5(String count) {
    return 'Та сама історія, $count разів поспіль. Виправдання закінчилися раніше за результати.';
  }

  @override
  String get yToldYouSo0 => 'Попереджали, що так і буде, поки всі святкували.';

  @override
  String get yToldYouSo1 =>
      'Два добрі тижні, і ми знову золоте покоління. І ось де ми.';

  @override
  String get yToldYouSo2 =>
      'Ті, хто минулого місяця казав мені насолоджуватися, притихли.';

  @override
  String get yToldYouSo3 =>
      'Мені це не приємно. Майже не приємно. Трохи приємно.';

  @override
  String get yToldYouSo4 =>
      'Ніколи не було так добре, як вам казали, і це доказ.';

  @override
  String get yToldYouSo5 =>
      'Щоразу. Нам кажуть, що цього разу інакше, і щоразу ні.';

  @override
  String get tacticsSubOffAlready => 'Уже замінений';

  @override
  String get tacticsSubInjured => 'Травмований';

  @override
  String get tacticsSubSentOffMark => 'Вилучений';

  @override
  String get tacticsSubNoneLeft => 'Замін не залишилося';

  @override
  String get tacticsUndoLastChange => 'Скасувати останню зміну';

  @override
  String get matchStrengthTitle => 'ЩО ВПЛИВАЄ НА КОМАНДУ';

  @override
  String get strengthFactorFamiliarity => 'Відпрацьована схема';

  @override
  String get strengthFactorFatigue => 'Втомлені ноги';

  @override
  String get strengthFactorClubForm => 'Форма в клубах';

  @override
  String get strengthFactorMorale => 'Роздягальня';

  @override
  String get strengthFactorCaptain => 'Капітан';

  @override
  String get strengthFactorStaff => 'Штаб';

  @override
  String get strengthFactorDossier => 'Досьє скаута';

  @override
  String yDebut0(String name) {
    return '$name отримує першу гру за збірну. Запам’ятайте це ім’я.';
  }

  @override
  String yDebut1(String name) {
    return 'Дебют $name. Це видно по ньому, чи не так?';
  }

  @override
  String yDebut2(String name) {
    return '$name, перший матч за збірну. Подивимося, що він з цим зробить.';
  }

  @override
  String yDebut3(String name) {
    return 'Дебют $name. Складу десь бракувало свіжих ніг.';
  }

  @override
  String yDebut4(String name) {
    return '$name отримує виклик. Ми роздали їх чимало останнім часом.';
  }

  @override
  String yDebut5(String name) {
    return 'Дебют $name. Ще один, кого забудемо до весни.';
  }

  @override
  String yDrought0(String name, String count) {
    return 'Матчів без гола у $name: $count, і при цьому на полі він робить усе інше.';
  }

  @override
  String yDrought1(String name, String count) {
    return '$count матчів без гола у $name. Вони приходять трійками, завжди так було.';
  }

  @override
  String yDrought2(String name, String count) {
    return '$name: $count матчів, жодного гола.';
  }

  @override
  String yDrought3(String name, String count) {
    return 'Матчів без гола у $name: $count. Варто пильнувати.';
  }

  @override
  String yDrought4(String name, String count) {
    return '$count матчів. Жодного гола. $name у ворота з десяти кроків не влучить.';
  }

  @override
  String yDrought5(String name, String count) {
    return 'Матчів без гола у $name: $count. Випустіть будь-кого іншого.';
  }

  @override
  String yRivalryLooms0(String opponent, String count) {
    return 'Далі суперник: $opponent. Матчів: $count, і це досі означає все.';
  }

  @override
  String yRivalryLooms1(String opponent, String count) {
    return 'Уже $count разів проти: $opponent. Давайте.';
  }

  @override
  String yRivalryLooms2(String opponent, String count) {
    return 'Далі суперник: $opponent. Зіграно: $count.';
  }

  @override
  String yRivalryLooms3(String opponent, String count) {
    return 'Зустріч номер $count із суперником $opponent цього тижня.';
  }

  @override
  String yRivalryLooms4(String opponent, String count) {
    return 'Знову $opponent. Таких матчів $count, а ми нічого не навчилися.';
  }

  @override
  String yRivalryLooms5(String opponent, String count) {
    return '$count матчів проти: $opponent, а вони й досі нас б’ють. Чудово.';
  }

  @override
  String get positionGoalkeeper => 'Воротар';

  @override
  String get positionLeftBack => 'Лівий захисник';

  @override
  String get positionCentreBack => 'Центральний захисник';

  @override
  String get positionRightBack => 'Правий захисник';

  @override
  String get positionDefensiveMid => 'Опорний півзахисник';

  @override
  String get positionCentralMid => 'Центральний півзахисник';

  @override
  String get positionAttackingMid => 'Атакувальний півзахисник';

  @override
  String get positionLeftMid => 'Лівий півзахисник';

  @override
  String get positionRightMid => 'Правий півзахисник';

  @override
  String get positionLeftWing => 'Лівий вінгер';

  @override
  String get positionRightWing => 'Правий вінгер';

  @override
  String get positionStriker => 'Нападник';

  @override
  String get roleNone => 'Без ролі';

  @override
  String get roleTargetMan => 'Таргет-форвард';

  @override
  String get rolePoacher => 'Мисливець за голами';

  @override
  String get rolePlaymaker => 'Плеймейкер';

  @override
  String get roleBallWinner => 'Руйнівник';

  @override
  String get roleInvertedWinger => 'Інвертований вінгер';

  @override
  String get roleBallPlayingDefender => 'Захисник-розпасовувач';

  @override
  String get roleNoneBlurb => 'Грає у своїй природній манері.';

  @override
  String get roleTargetManBlurb =>
      'Виграє верхові м’ячі, скидає партнерам. Асисти й стандарти.';

  @override
  String get rolePoacherBlurb =>
      'Ховається у штрафному. Набагато більше голів.';

  @override
  String get rolePlaymakerBlurb => 'Створює моменти. Набагато більше асистів.';

  @override
  String get roleBallWinnerBlurb => 'Руйнує атаки, а не завершує їх.';

  @override
  String get roleInvertedWingerBlurb =>
      'Заходить усередину під удар. Більше голів.';

  @override
  String get roleBallPlayingDefenderBlurb => 'Починає атаки з тилу.';

  @override
  String get federationDeptYouth => 'Академія молоді';

  @override
  String get federationDeptCommercial => 'Комерція / PR';

  @override
  String get federationDeptMedical => 'Медицина та спортивна наука';

  @override
  String get federationDeptNaturalisation => 'Відділ натуралізації';

  @override
  String get federationDeptBoardRelations => 'Зв’язки з радою';

  @override
  String get federationDeptYouthBlurb =>
      'Кращі вихованці академії дебютують за твою збірну в наступному циклі.';

  @override
  String get federationDeptCommercialBlurb =>
      'Спонсорство приносить додатковий дохід наприкінці циклу.';

  @override
  String get federationDeptMedicalBlurb =>
      'Менше травм. Твій склад доступний увесь цикл.';

  @override
  String get federationDeptNaturalisationBlurb =>
      'Більше іноземних гравців погоджуються змінити збірну на твою.';

  @override
  String get federationDeptBoardRelationsBlurb =>
      'Рада терплячіше оцінює твої результати.';

  @override
  String get federationBuildingAcademy => 'Академія';

  @override
  String get federationBuildingCommercial => 'Комерційний офіс';

  @override
  String get federationBuildingMedical => 'Медичний центр';

  @override
  String get federationBuildingScouting => 'Скаутський офіс';

  @override
  String get federationBuildingBoardroom => 'Зала ради';

  @override
  String get moraleBuoyant => 'Піднесений';

  @override
  String get moralePositive => 'Позитивний';

  @override
  String get moraleSettled => 'Спокійний';

  @override
  String get moraleUneasy => 'Тривожний';

  @override
  String get moraleRockBottom => 'На дні';

  @override
  String get matchTabTimeline => 'ХРОНОЛОГІЯ';

  @override
  String get matchTabStats => 'СТАТИСТИКА';

  @override
  String get matchTabLineups => 'СКЛАДИ';

  @override
  String get matchPenalty => 'ПЕНАЛЬТІ';

  @override
  String get matchStateLevel => 'Рахунок рівний';

  @override
  String matchStateLead(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ти попереду на $count гола',
      many: 'Ти попереду на $count голів',
      few: 'Ти попереду на $count голи',
      one: 'Ти попереду на $count гол',
    );
    return '$_temp0';
  }

  @override
  String matchStateTrail(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ти позаду на $count гола',
      many: 'Ти позаду на $count голів',
      few: 'Ти позаду на $count голи',
      one: 'Ти позаду на $count гол',
    );
    return '$_temp0';
  }

  @override
  String matchPossessionShare(int possession) {
    return 'Володіння м’ячем: $possession%';
  }

  @override
  String get boardVerdictSackedTitle => 'Рада тебе звільнила';

  @override
  String boardVerdictSackedBody(int rating) {
    return 'Жахливий цикл (рейтинг $rating%). Твоє правління закінчується тут. Тепер ризикнути з тобою погодяться лише слабші збірні.';
  }

  @override
  String get boardVerdictDelightedTitle => 'Рада в захваті';

  @override
  String boardVerdictDelightedBody(int rating, String best) {
    return 'Видатний цикл (рейтинг $rating%), головне досягнення: $best. Тобою цікавляться більші збірні, або можеш залишитися й будувати далі.';
  }

  @override
  String get boardVerdictSolidTitle => 'Міцний цикл';

  @override
  String boardVerdictSolidBody(int rating) {
    return 'Рада задоволена (рейтинг $rating%). Кілька збірних подібного рівня взяли б тебе, але підстав залишати посаду немає.';
  }

  @override
  String get boardVerdictExpectedMoreTitle => 'Рада чекала більшого';

  @override
  String boardVerdictExpectedMoreBody(int rating) {
    return 'Розчарувальний цикл (рейтинг $rating%). Роботу ти зберігаєш, але будь-яка пропозиція означатиме крок униз.';
  }

  @override
  String get boardVerdictPressureTitle => 'Ти під серйозним тиском';

  @override
  String boardVerdictPressureBody(int rating) {
    return 'Слабкий цикл (рейтинг $rating%). Ти залишаєшся на посаді, але якщо захочеш почати заново, тобою цікавляться лише слабші збірні.';
  }

  @override
  String get boardVerdictHeroTitle => 'Країна за тебе';

  @override
  String boardVerdictHeroNote(String nation, int cycles) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles циклу',
      many: '$cycles циклів',
      few: '$cycles циклів',
      one: '$cycles циклу',
    );
    return ' $nation обожнює тебе, національного героя після $_temp0; ти на посаді, доки сам цього хочеш.';
  }

  @override
  String get boardVerdictTheNation => 'Країна';

  @override
  String get boardVerdictBestQuiet => 'спокійна, стабільна робота';

  @override
  String get boardVerdictBestCycle => 'цикл загалом';

  @override
  String boardVerdictBestWorld(String placement) {
    return 'чемпіонат світу ($placement)';
  }

  @override
  String get finishThirdPlace => 'Третє місце';

  @override
  String get finishFourthPlace => 'Четверте місце';

  @override
  String get finishDidNotQualify => 'Не кваліфікувалися';

  @override
  String get careerRepIconic => 'Культовий';

  @override
  String get careerRepRenowned => 'Відомий';

  @override
  String get careerRepEstablished => 'Визнаний';

  @override
  String get careerRepRising => 'Перспективний';

  @override
  String get careerRepUnproven => 'Невипробуваний';

  @override
  String get hubOfferStepUp => 'Крок угору';

  @override
  String get hubOfferLateral => 'Горизонтальний перехід';

  @override
  String get hubOfferRebuild => 'Відбудова';

  @override
  String careerNationsCupWon(String league) {
    return 'Ліга $league · Чемпіони';
  }

  @override
  String careerNationsCupRunnerUp(String league) {
    return 'Ліга $league · Срібні призери';
  }

  @override
  String careerNationsCupSemi(String league) {
    return 'Ліга $league · Півфіналіст';
  }

  @override
  String careerNationsCupPlaced(String league, int position) {
    return 'Ліга $league · #$position';
  }

  @override
  String tourRunInto(String round) {
    return 'Далі: $round';
  }

  @override
  String get tourRunIntoThirdPlace => 'Далі: матч за третє місце';

  @override
  String tourRunThrough(String round) {
    return 'Пройдено етап: $round';
  }

  @override
  String tourRunOut(String round) {
    return 'Вибули на етапі: $round';
  }

  @override
  String get tourRunInGroup => 'Груповий етап: ще в боротьбі';

  @override
  String get tourRunGroupOut => 'Вилетіли з групового етапу';

  @override
  String resultsCycleTitle(int year, String nation) {
    return 'Цикл $year · $nation';
  }

  @override
  String resultsCycleRecord(int played, int won, int drawn, int lost) {
    return 'Ігор: $played  ·  $wonВ $drawnН $lostП';
  }

  @override
  String resultsCycleFinish(String finish) {
    return 'Чемпіонат світу: $finish';
  }

  @override
  String get resultsCycleUnderway => 'Ще триває';

  @override
  String yTurnedItRound0(String opponent) {
    return '$opponent: на перерві мінус два, а відіграли все до останнього. Ось це команда.';
  }

  @override
  String yTurnedItRound1(String opponent) {
    return '$opponent: програвали в два м’ячі, а до кінця це вже нічого не важило. Так вміють не всі.';
  }

  @override
  String yTurnedItRound2(String opponent) {
    return '$opponent: перерва, мінус два. Фінальний свисток: вже ні. Другий тайм був зовсім іншим матчем.';
  }

  @override
  String yTurnedItRound3(String opponent) {
    return '$opponent: відіграли два голи. Що б там не сказали на перерві, кажіть це щотижня.';
  }

  @override
  String yTurnedItRound4(String opponent) {
    return '$opponent: гаразд, ми відіграли. А тепер хай хтось пояснить перші сорок п’ять хвилин.';
  }

  @override
  String yTurnedItRound5(String opponent) {
    return '$opponent: мінус два, а нам ще й радіти. Полагодьте перший тайм.';
  }

  @override
  String yThrewItAway0(String opponent) {
    return '$opponent: на перерві плюс два, а потім усе вислизнуло. Таке буває й з кращими.';
  }

  @override
  String yThrewItAway1(String opponent) {
    return '$opponent: вели в два м’ячі, і все розтануло. Цикл довгий, часу вдосталь.';
  }

  @override
  String yThrewItAway2(String opponent) {
    return '$opponent: перерва, плюс два. Фінальний свисток: нічого подібного.';
  }

  @override
  String yThrewItAway3(String opponent) {
    return '$opponent: перевага в два м’ячі розтанула менш ніж за сорок п’ять хвилин.';
  }

  @override
  String yThrewItAway4(String opponent) {
    return 'Вели в два м’ячі й упустили. $opponent. Хтось має за це відповісти.';
  }

  @override
  String yThrewItAway5(String opponent) {
    return '$opponent: вели в два м’ячі, і ми примудрилися ось це. Щоразу.';
  }

  @override
  String get cycleBackupDone =>
      'Кар’єру збережено в папці FNM на цьому телефоні. Видалення застосунку її прибирає: щоб мати копію в іншому місці, скористайся пунктом «Резервна копія цього збереження» на екрані збережень.';

  @override
  String get cycleBackupFailed =>
      'Цього разу не вдалося зробити резервну копію кар’єри.';

  @override
  String pressMomentBigWinWarm1(String opponent) {
    return '$opponent: вечір, який запам’ятається. Наскільки Ви пишаєтеся цією групою?';
  }

  @override
  String pressMomentBigWinWarm2(String opponent) {
    return '$opponent: суперник не витримав Вашого темпу. Це та команда, яку Ви завжди хотіли мати?';
  }

  @override
  String pressMomentBigWinNeutral1(String opponent) {
    return '$opponent: велика перемога. Що вирішило справу цього вечора?';
  }

  @override
  String pressMomentBigWinNeutral2(String opponent) {
    return '$opponent: переможені, і впевнено. Де Ви виграли цей матч?';
  }

  @override
  String pressMomentBigWinHostile1(String opponent) {
    return '$opponent: добра перемога. Один вдалий вечір: чому хтось має вірити, що це надовго?';
  }

  @override
  String pressMomentBigWinHostile2(String opponent) {
    return '$opponent: гарний результат. Це був Ваш план, чи гравці самі все придумали?';
  }

  @override
  String pressMomentBigLossWarm1(String opponent) {
    return '$opponent: важкий вечір. Що Ви скажете гравцям після такого?';
  }

  @override
  String pressMomentBigLossWarm2(String opponent) {
    return '$opponent: ніхто такого не чекав. Це був просто один з таких вечорів?';
  }

  @override
  String pressMomentBigLossNeutral1(String opponent) {
    return '$opponent: принизливий вечір. Що пішло не так?';
  }

  @override
  String pressMomentBigLossNeutral2(String opponent) {
    return '$opponent: Вас розібрали на частини. Чи достатньо хороший цей склад?';
  }

  @override
  String pressMomentBigLossHostile1(String opponent) {
    return '$opponent: Ви програвали у всьому. Як Ви допустили, щоб усе зайшло так далеко?';
  }

  @override
  String pressMomentBigLossHostile2(String opponent) {
    return '$opponent: суперник забивав, як хотів. Де сьогодні був план?';
  }

  @override
  String pressMomentCrisisWarm1(String opponent) {
    return '$opponent: ще один матч вислизає з рук. Як Ви зламаєте цю серію?';
  }

  @override
  String pressMomentCrisisWarm2(String opponent) {
    return '$opponent: результати зникли, а цей матч усе погіршив. Ви все ще вірите в цю групу?';
  }

  @override
  String pressMomentCrisisNeutral1(String opponent) {
    return '$opponent: знову без перемоги, і рада стежить. Чи безпечна Ваша посада?';
  }

  @override
  String pressMomentCrisisNeutral2(String opponent) {
    return '$opponent: серія без перемог стає довгою. Ви турбуєтеся за своє майбутнє?';
  }

  @override
  String pressMomentCrisisHostile1(String opponent) {
    return '$opponent: і цей теж. Вашого попередника звільнили після такої серії. Чому Ви маєте втриматися?';
  }

  @override
  String pressMomentCrisisHostile2(String opponent) {
    return '$opponent: після ще одного такого вечора кожен радіоефір зі слухачами вимагає Вашого відходу. Чи пішли б Ви, якби рада попросила?';
  }

  @override
  String pressMomentJobVerdictWarm1(String opponent) {
    return '$opponent: Ви поставили на кін свою посаду, і не вийшло. Як Ви тримаєтеся?';
  }

  @override
  String pressMomentJobVerdictWarm2(String opponent) {
    return '$opponent: три матчі позаду, останній саме цей. Іспит Ви поставили собі самі. Що скажете про вердикт?';
  }

  @override
  String pressMomentJobVerdictNeutral1(String opponent) {
    return '$opponent: Ви просили судити Вас за наступними трьома матчами. Ми так і зробили. Посада ще Ваша?';
  }

  @override
  String pressMomentJobVerdictNeutral2(String opponent) {
    return '$opponent: три матчі, останній саме цей, і не те, що Ви обіцяли. Чи говорили Ви з радою про своє майбутнє?';
  }

  @override
  String pressMomentJobVerdictHostile1(String opponent) {
    return '$opponent: іспит Ви поставили собі самі й провалили. Ви збираєтеся піти у відставку?';
  }

  @override
  String pressMomentJobVerdictHostile2(String opponent) {
    return 'Ваші слова, не наші: судіть мене за наступними трьома. $opponent: чому Ви досі тут сидите?';
  }

  @override
  String get pressBeatWhoToBlameWarm1 =>
      'Ви хочете від них більшого. Когось конкретно?';

  @override
  String get pressBeatWhoToBlameWarm2 =>
      'Ви високо підняли планку. Хто має першим підтягнутися?';

  @override
  String get pressBeatWhoToBlameNeutral1 =>
      'Ви кажете, дехто мусить поглянути на себе. Кого Ви маєте на увазі?';

  @override
  String get pressBeatWhoToBlameNeutral2 =>
      'Недостатньо добре, кажете Ви. Про кого мова?';

  @override
  String get pressBeatWhoToBlameHostile1 =>
      'Ви говорите невиразно. Назвете прізвища, чи все повернеться до Вас?';

  @override
  String get pressBeatWhoToBlameHostile2 =>
      'Щотижня винен хтось інший. Хто цього разу?';

  @override
  String get pressBeatIfYouDontWarm1 =>
      'Сміливі слова. А якщо наступний матч не складеться?';

  @override
  String get pressBeatIfYouDontWarm2 =>
      'Вся країна триматиме Вас за слово. А якщо не вийде?';

  @override
  String get pressBeatIfYouDontNeutral1 => 'А якщо Ви не виграєте? Що тоді?';

  @override
  String get pressBeatIfYouDontNeutral2 =>
      'Ви це сказали. Що буде, якщо Ви помилитеся?';

  @override
  String get pressBeatIfYouDontHostile1 =>
      'У цій залі вже чули обіцянки. Що Ви винні уболівальникам, якщо й ця не збудеться?';

  @override
  String get pressBeatIfYouDontHostile2 =>
      'А коли цього не станеться, яким буде виправдання?';

  @override
  String get pressBeatFollowUpWarm1 =>
      'Ще одне, якщо маєте сили. Над чим цій групі ще треба працювати?';

  @override
  String get pressBeatFollowUpWarm2 =>
      'Коли вляжеться пил, що Ви візьмете з цього вечора в наступний матч?';

  @override
  String get pressBeatFollowUpNeutral1 =>
      'Копнімо глибше. Що має покращитися до наступного матчу?';

  @override
  String get pressBeatFollowUpNeutral2 =>
      'Якщо відволіктися від рахунку: цей склад там, де Ви хочете його бачити?';

  @override
  String get pressBeatFollowUpHostile1 =>
      'Багато слів, мало сказано. Що насправді зміниться відтепер?';

  @override
  String get pressBeatFollowUpHostile2 =>
      'Уболівальники хочуть прямої відповіді. Ця команда достатньо хороша: так чи ні?';

  @override
  String pressBeatStandoutWarm1(String player) {
    return '$player сьогодні був чудовий. Як далеко він може зайти?';
  }

  @override
  String pressBeatStandoutWarm2(String player) {
    return '$player у всіх заголовках цього вечора. Ви це передбачали?';
  }

  @override
  String pressBeatStandoutNeutral1(String player) {
    return '$player вирізнявся. Що Ви просили від нього сьогодні?';
  }

  @override
  String pressBeatStandoutNeutral2(String player) {
    return 'Чи став $player різницею сьогодні?';
  }

  @override
  String pressBeatStandoutHostile1(String player) {
    return '$player: без нього це вже зовсім інша історія. Це команда чи один гравець?';
  }

  @override
  String pressBeatStandoutHostile2(String player) {
    return '$player був блискучий. Ваша заслуга чи його?';
  }

  @override
  String pressBeatStrugglerWarm1(String player) {
    return '$player мав важкий вечір. Він грає з травмою?';
  }

  @override
  String pressBeatStrugglerWarm2(String player) {
    return '$player не мав свого вечора. Ви його підтримаєте?';
  }

  @override
  String pressBeatStrugglerNeutral1(String player) {
    return '$player мучився сьогодні. Він зберігає місце в складі?';
  }

  @override
  String pressBeatStrugglerNeutral2(String player) {
    return '$player відставав від темпу гри. Що Ви скажете про його матч?';
  }

  @override
  String pressBeatStrugglerHostile1(String player) {
    return '$player знову був пасажиром. Чому Ви й далі його ставите?';
  }

  @override
  String pressBeatStrugglerHostile2(String player) {
    return 'Усім було видно, що $player не в грі. Усім, крім тренерської лави?';
  }

  @override
  String get pressThrowbackWinNextKeptWarm =>
      'Ви казали, що виграєте наступний, і виграли. Приємно мати рацію?';

  @override
  String get pressThrowbackWinNextKeptNeutral =>
      'Ви обіцяли перемогу в наступному матчі й виконали обіцянку. Упевненість чи бравада?';

  @override
  String get pressThrowbackWinNextKeptHostile =>
      'Ви казали, що виграєте наступний, і виграли. Удача, чи нам уже час Вас слухати?';

  @override
  String get pressThrowbackWinNextBrokenWarm =>
      'Ви казали, що виграєте той матч. Не вийшло. Що пішло не так?';

  @override
  String get pressThrowbackWinNextBrokenNeutral =>
      'Ви казали, що виграєте наступний. Не виграли. Чому ми маємо вірити наступній обіцянці?';

  @override
  String get pressThrowbackWinNextBrokenHostile =>
      'Ви казали, що виграєте наступний. Не виграли. Чи важать ще Ваші слова в цій залі?';

  @override
  String get pressThrowbackJobKeptWarm =>
      'Ви просили судити Вас за трьома матчами й пройшли випробування. Реабілітація?';

  @override
  String get pressThrowbackJobKeptNeutral =>
      '«Судіть мене за наступними трьома», казали Ви. Ми так і зробили, і результати прийшли. Чого навчив Вас цей іспит?';

  @override
  String get pressThrowbackJobKeptHostile =>
      'Ви дали собі три матчі й пройшли їх. Іспит узагалі був таким складним?';

  @override
  String get pressThrowbackJobBrokenWarm =>
      'Ви просили судити Вас за трьома матчами. Вони не склалися. Чого Ви навчилися?';

  @override
  String get pressThrowbackJobBrokenNeutral =>
      'Ви казали: судіть мене за наступними трьома. Три позаду, а разом із ними й право на довіру. Що тепер?';

  @override
  String get pressThrowbackJobBrokenHostile =>
      'Ви самі поставили іспит і провалили його. Чому тепер хтось має вірити Вашому слову?';

  @override
  String pressThrowbackBackKeptWarm(String player) {
    return '$player: Ви підтримали його, коли інші не стали. Він віддячив. Частина заслуги Ваша?';
  }

  @override
  String pressThrowbackBackKeptNeutral(String player) {
    return '$player: Ви підтримали його. Він віддячив. Віра чи знання?';
  }

  @override
  String pressThrowbackBackKeptHostile(String player) {
    return '$player: Ви ставили на нього, і цього разу це окупилося. Чи будете Ви так само впевнені наступного разу?';
  }

  @override
  String pressThrowbackBackBrokenWarm(String player) {
    return '$player: Ви стояли за нього, а не склалося. Ви все ще в нього вірите?';
  }

  @override
  String pressThrowbackBackBrokenNeutral(String player) {
    return '$player: Ви його підтримали, а він не віддячив. Це була помилка?';
  }

  @override
  String pressThrowbackBackBrokenHostile(String player) {
    return '$player: Ваше судження чи Ваша лояльність, що саме підвело?';
  }

  @override
  String pressThrowbackBlameKeptWarm(String player) {
    return '$player: Ви були суворі до нього, і наступні матчі довели Вашу правоту. Є в цьому задоволення?';
  }

  @override
  String pressThrowbackBlameKeptNeutral(String player) {
    return '$player: Ви публічно його розкритикували, а він не відповів. Чи є для нього шлях назад?';
  }

  @override
  String pressThrowbackBlameKeptHostile(String player) {
    return '$player: Ви залишили його сам на сам із критикою, і він не оговтався. Ви його зламали?';
  }

  @override
  String pressThrowbackBlameBrokenWarm(String player) {
    return '$player: Ви публічно його розкритикували, а він відповів Вам на полі. Це був задум від самого початку?';
  }

  @override
  String pressThrowbackBlameBrokenNeutral(String player) {
    return '$player: Ви звинуватили його, а відтоді він один із найкращих у Вашій команді. Чи не винні Ви йому вибачення?';
  }

  @override
  String pressThrowbackBlameBrokenHostile(String player) {
    return '$player: Ви його підставили, а він відтоді Ваш найкращий гравець. Чи вибачитеся Ви?';
  }

  @override
  String get pressReplyCreditPlayers1 =>
      'Ці гравці віддали мені все. Я б не проміняв жодного з них.';

  @override
  String get pressReplyCreditPlayers2 =>
      'Ніхто не працює більше за цю групу. Захищатиму їх хоч цілий день.';

  @override
  String get pressReplyCreditPlayers3 =>
      'З цього місця ви не почуєте жодного слова проти моїх гравців.';

  @override
  String get pressReplyCreditPlayers4 =>
      'Заслуга гравців, не моя. Пишіть про них.';

  @override
  String get pressReplyTakeResponsibility1 =>
      'Це на мені. Я обрав склад, і я налаштував команду.';

  @override
  String get pressReplyTakeResponsibility2 =>
      'Судіть мене, не їх. Це моя команда і моя відповідальність.';

  @override
  String get pressReplyTakeResponsibility3 =>
      'Якщо шукаєте винного, я тут, перед вами.';

  @override
  String get pressReplyTakeResponsibility4 =>
      'Відповідальність моя. Гравців не чіпайте.';

  @override
  String get pressReplyDemandMore1 =>
      'Я хочу більшого. Дехто з них точно знає, про що я.';

  @override
  String get pressReplyDemandMore2 =>
      'На цьому рівні самих зусиль мало. Я хочу більшого і сказав їм про це.';

  @override
  String get pressReplyDemandMore3 =>
      'Я чекаю більшого від кожного з них, починаючи від завтра.';

  @override
  String get pressReplyDemandMore4 =>
      'Дехто має поглянути на себе. Я не задоволений.';

  @override
  String get pressReplyPromiseWinNext1 =>
      'Наступний ми виграємо. Можете записати.';

  @override
  String get pressReplyPromiseWinNext2 =>
      'Запам’ятайте мої слова: наступний матч ми виграємо.';

  @override
  String get pressReplyPromiseWinNext3 =>
      'У наступній грі ми перемагаємо. Кажу це тут, щоб ви могли мені нагадати.';

  @override
  String get pressReplyPromiseWinNext4 =>
      'Я впевнений у цій команді. Наступний матч ми виграємо.';

  @override
  String get pressReplyJobOnTheLine1 =>
      'Судіть мене за наступними трьома матчами. Це чесно.';

  @override
  String get pressReplyJobOnTheLine2 =>
      'Дайте мені три ігри. Якщо до того часу не буде як треба, судіть мене за це.';

  @override
  String get pressReplyJobOnTheLine3 =>
      'Наступні три покажуть, чи я та людина. Тримайте мене за слово.';

  @override
  String get pressReplyJobOnTheLine4 =>
      'Три матчі. А потім пишіть про мене що завгодно.';

  @override
  String get pressReplyDeflect1 => 'Ми граємо матч за матчем. Додати нічого.';

  @override
  String get pressReplyDeflect2 => 'Сьогодні я не робитиму для вас заголовків.';

  @override
  String get pressReplyDeflect3 =>
      'Наступний матч. Тільки про нього я й думаю.';

  @override
  String get pressReplyDeflect4 => 'Те, що я думаю, залишається в роздягальні.';

  @override
  String get pressReplyTakeCredit1 => 'Я це сказав, бо вірив, і я мав рацію.';

  @override
  String get pressReplyTakeCredit2 =>
      'Я прочитав це правильно. Для того я тут.';

  @override
  String get pressReplyTakeCredit3 => 'Назвіть це чуттям. Я знав, що кажу.';

  @override
  String get pressReplyTakeCredit4 =>
      'Я прийняв рішення, і воно спрацювало. Це я беру на себе.';

  @override
  String get pressReplyStandByIt1 => 'Я сказав те, у що вірив. Стою на своєму.';

  @override
  String get pressReplyStandByIt2 => 'Я не беру назад ні слова.';

  @override
  String get pressReplyStandByIt3 =>
      'Відповідь та сама, що й тоді. Я це мав на увазі й досі маю.';

  @override
  String get pressReplyStandByIt4 => 'Я б повторив це й завтра.';

  @override
  String get pressReplyAdmitMistake1 => 'Тут я помилився. Визнаю.';

  @override
  String get pressReplyAdmitMistake2 =>
      'Справедливо, я помилився в оцінці. Зроблю висновки.';

  @override
  String get pressReplyAdmitMistake3 => 'Я помилявся, і можу це сказати.';

  @override
  String get pressReplyAdmitMistake4 =>
      'Те рішення не спрацювало, і воно було моїм.';

  @override
  String pressReplyBackPlayer1(String player) {
    return '$player має мою повну підтримку. Він розкриється.';
  }

  @override
  String pressReplyBackPlayer2(String player) {
    return '$player: я в нього вірю, і він покаже вам, чому.';
  }

  @override
  String pressReplyBackPlayer3(String player) {
    return '$player: від мене ви не почуєте жодного слова проти нього. Він віддячить.';
  }

  @override
  String pressReplyBackPlayer4(String player) {
    return '$player залишається в моїх планах. Дивіться, що він зробить далі.';
  }

  @override
  String pressReplyBlamePlayer1(String player) {
    return '$player підвів нас сьогодні, і він це знає.';
  }

  @override
  String pressReplyBlamePlayer2(String player) {
    return '$player: я чекав від нього набагато більшого. Він має за це відповісти.';
  }

  @override
  String pressReplyBlamePlayer3(String player) {
    return '$player був не на своєму рівні. Скажу це публічно.';
  }

  @override
  String pressReplyBlamePlayer4(String player) {
    return '$player: цього було недостатньо від нього, і він почує це від мене.';
  }

  @override
  String get pressOnRecordWinNext =>
      'Офіційна заява: ти виграєш наступний матч.';

  @override
  String get pressOnRecordJob =>
      'Офіційна заява: судити тебе за наступними трьома.';

  @override
  String pressOnRecordBack(String player) {
    return 'Офіційна заява, підтримка: $player.';
  }

  @override
  String pressOnRecordBlame(String player) {
    return 'Офіційна заява: $player тебе підвів.';
  }

  @override
  String yStatementKept0(String nation) {
    return '$nation: у вас тренер, який відповідає за свої слова. Він це сказав, і воно збулося.';
  }

  @override
  String yStatementKept1(String nation) {
    return '$nation: сказав уголос, а тоді взяв і зробив. Саме така людина й була потрібна.';
  }

  @override
  String yStatementKept2(String nation) {
    return '$nation: він це передбачив, і воно збулося. Ну що ж, справедливо.';
  }

  @override
  String yStatementKept3(String nation) {
    return 'Він зафіксував це публічно, і воно спрацювало. Один бал йому. $nation іде далі.';
  }

  @override
  String yStatementKept4(String nation) {
    return 'Одного разу вгадав. $nation, не звикайте.';
  }

  @override
  String yStatementKept5(String nation) {
    return 'Навіть зупинений годинник двічі на добу показує правильно. $nation: цього разу пощастило.';
  }

  @override
  String yStatementBroken0(String nation) {
    return 'Він це сказав, і не вийшло. Я все ще з ним. $nation іде далі.';
  }

  @override
  String yStatementBroken1(String nation) {
    return '$nation: він пообіцяв більше, ніж ми отримали, але тренер, який вірить у себе, мені ближчий.';
  }

  @override
  String yStatementBroken2(String nation) {
    return '$nation: він сказав це публічно, і цього не сталося. Люди пам’ятатимуть.';
  }

  @override
  String yStatementBroken3(String nation) {
    return 'Гучні слова, а за ними нічого. $nation: наступного разу хай каже менше.';
  }

  @override
  String yStatementBroken4(String nation) {
    return 'Він стояв і казав нам. А потім оце. $nation заслуговує на більше, ніж розмови.';
  }

  @override
  String yStatementBroken5(String nation) {
    return 'Його слово тепер нічого не варте. Запишіть це, $nation.';
  }

  @override
  String get ncZoneNorth => 'Північна зона';

  @override
  String get ncZoneWest => 'Західна зона';

  @override
  String get ncZoneEast => 'Східна зона';

  @override
  String get ncZoneCentralSouthern => 'Центральна та Південна зона';

  @override
  String careerNationsCupZoneWon(String zone) {
    return '$zone · Чемпіони';
  }

  @override
  String careerNationsCupZoneRunnerUp(String zone) {
    return '$zone · Срібні призери';
  }

  @override
  String careerNationsCupZoneSemi(String zone) {
    return '$zone · Півфіналіст';
  }

  @override
  String careerNationsCupZoneRoundOf16(String zone) {
    return '$zone · 1/8 фіналу';
  }

  @override
  String careerNationsCupZoneQuarter(String zone) {
    return '$zone · Чвертьфіналіст';
  }

  @override
  String careerNationsCupZonePlaced(String zone, int position) {
    return '$zone · #$position';
  }

  @override
  String get objectiveNcFinalsEight => 'Вийти до чвертьфіналу';

  @override
  String get objectiveNcZoneWinGroup => 'Виграти свою групу';

  @override
  String get finishNcFinalsEight => 'Чвертьфінал';

  @override
  String get finishNcBottomHalf => 'Нижня половина групи';

  @override
  String get tourContTabZones => 'ЗОНИ';

  @override
  String get tourContTabFinalsEight => 'ПЛЕЙ-ОФ';

  @override
  String get tourContFinalsEightSoon =>
      'Плей-оф стартує в листопаді з 1/8 фіналу: усі 14 переможців груп і 2 найкращі команди з других місць.';

  @override
  String get tourContQuarterFinals => 'ЧВЕРТЬФІНАЛИ';

  @override
  String get tourContZoneAdvancement =>
      'Кожен переможець групи виходить до 1/8 фіналу, до нього додаються 2 найкращі команди з других місць. Пониження у класі немає.';

  @override
  String tourContZoneHeadingYours(String zone) {
    return '$zone ★';
  }

  @override
  String get compNorthAmericaNationsCup => 'Nations Cup Північної Америки';

  @override
  String get compAfricanNationsCup => 'Nations Cup';

  @override
  String get objectiveNcWinItNorthAmerica =>
      'Виграти Nations Cup Північної Америки';

  @override
  String get objectiveNcWinItAfrica => 'Виграти Nations Cup';

  @override
  String get objectiveNcReachFinalNorthAmerica =>
      'Вийти до фіналу Nations Cup Північної Америки';

  @override
  String get objectiveNcReachFinalAfrica => 'Вийти до фіналу Nations Cup';

  @override
  String get finishNcChampionsNorthAmerica =>
      'Переможці Nations Cup Північної Америки';

  @override
  String get finishNcChampionsAfrica => 'Переможці Nations Cup';

  @override
  String pressAimQualWarm1(String competition) {
    return '$competition: кваліфікація стартує, і країна вірить у цю команду. На що Ви націлені?';
  }

  @override
  String pressAimQualWarm2(String competition) {
    return '$competition: нова кваліфікаційна кампанія, настрій піднесений. Як далеко може зайти ця команда?';
  }

  @override
  String pressAimQualNeutral1(String competition) {
    return '$competition: стартує кваліфікація. Яка мета цієї кампанії?';
  }

  @override
  String pressAimQualNeutral2(String competition) {
    return '$competition: відбір розпочався. Де, на Вашу думку, фінішує ця команда?';
  }

  @override
  String pressAimQualHostile1(String competition) {
    return '$competition: стартує кваліфікація, і багато хто сумнівається, що Ви туди потрапите. Що Ви їм скажете?';
  }

  @override
  String pressAimQualHostile2(String competition) {
    return '$competition: ще одна кваліфікаційна кампанія. Чому хтось має вірити, що ця буде іншою?';
  }

  @override
  String pressAimFinalsWarm1(String competition) {
    return '$competition: турнір уже тут, і вся країна за Вас. Як далеко Ви можете зайти?';
  }

  @override
  String pressAimFinalsWarm2(String competition) {
    return '$competition: Ви на турнірі, а уболівальники мріють. Яка мета?';
  }

  @override
  String pressAimFinalsNeutral1(String competition) {
    return '$competition: турнір стартує цього тижня. Що вважатиметься успіхом?';
  }

  @override
  String pressAimFinalsNeutral2(String competition) {
    return '$competition: перший матч уже близько. Поставте нам мету.';
  }

  @override
  String pressAimFinalsHostile1(String competition) {
    return '$competition: турнір настав, а від Вас мало хто чекає багато. На що Ви насправді сподіваєтеся?';
  }

  @override
  String pressAimFinalsHostile2(String competition) {
    return '$competition: Ви на турнірі, але сумніви не зникли. Яка Ваша мета?';
  }

  @override
  String pressBeatRivalWarm1(String rival) {
    return '$rival у Вашій групі. Вони Вас турбують?';
  }

  @override
  String pressBeatRivalWarm2(String rival) {
    return '$rival: жеребкування звело Вас із цим суперником. Як Ви бачите цей матч?';
  }

  @override
  String pressBeatRivalNeutral1(String rival) {
    return '$rival: схоже, найсильніша команда у Вашій групі. Вони фаворити?';
  }

  @override
  String pressBeatRivalNeutral2(String rival) {
    return '$rival: що Ви про них скажете?';
  }

  @override
  String pressBeatRivalHostile1(String rival) {
    return '$rival у Вашій групі. Чесно, чи зможете Ви з ними тягатися?';
  }

  @override
  String pressBeatRivalHostile2(String rival) {
    return '$rival: більшість чекає, що вони Вас переможуть. Вони помиляються?';
  }

  @override
  String pressBeatKeyPlayerWarm1(String player) {
    return '$player у чудовій формі. Це його момент?';
  }

  @override
  String pressBeatKeyPlayerWarm2(String player) {
    return '$player у всіх заголовках. Чи здатен він потягти цю команду?';
  }

  @override
  String pressBeatKeyPlayerNeutral1(String player) {
    return '$player: наскільки ця кампанія залежить від нього?';
  }

  @override
  String pressBeatKeyPlayerNeutral2(String player) {
    return '$player готовий очолити цю команду?';
  }

  @override
  String pressBeatKeyPlayerHostile1(String player) {
    return 'Якщо $player не на піку, чи є в цієї команди ще щось?';
  }

  @override
  String pressBeatKeyPlayerHostile2(String player) {
    return '$player несе на плечах багато. Забагато?';
  }

  @override
  String get pressReplyAimHigher1 => 'Ми зайдемо далі, ніж будь-хто очікує.';

  @override
  String get pressReplyAimHigher2 =>
      'Я хочу більшого, ніж просила федерація, і скажу це вголос.';

  @override
  String get pressReplyMatchBrief1 => 'Ми знаємо завдання і виконаємо його.';

  @override
  String get pressReplyMatchBrief2 =>
      'Федерація поставила завдання. Ми його виконаємо.';

  @override
  String get pressReplyPlayDown1 => 'Йдемо матч за матчем.';

  @override
  String get pressReplyPlayDown2 =>
      'Жодних гучних обіцянок. Побачимо, де ми опинимось.';

  @override
  String get pressReplyPromiseQualify1 => 'Ми кваліфікуємося. Можете записати.';

  @override
  String get pressReplyPromiseQualify2 =>
      'Ця команда буде у фінальній частині.';

  @override
  String get pressReplyFearNobody1 => 'Ми нікого не боїмося.';

  @override
  String get pressReplyFearNobody2 => 'Їм теж доведеться грати з нами.';

  @override
  String get pressReplyRespectRival1 => 'Вони фаворити, і ми їх поважаємо.';

  @override
  String get pressReplyRespectRival2 =>
      'Дуже хороша команда. Нам знадобиться все найкраще.';

  @override
  String get pressReplyTeamFirst1 =>
      'Йдеться про всю команду, а не про одного гравця.';

  @override
  String get pressReplyTeamFirst2 => 'Ніхто не виграє поодинці.';

  @override
  String pressOnRecordTarget(String aim) {
    return 'Офіційна заява: $aim.';
  }

  @override
  String get pressOnRecordPlayDown => 'Офіційна заява: жодних обіцянок.';

  @override
  String get pressThrowbackTargetKeptWarm =>
      'Перед кампанією Ви поставили мету й досягли її. Це поки що Ваш найкращий момент?';

  @override
  String get pressThrowbackTargetKeptNeutral =>
      'Ви сказали, чого досягнете, і досягли. Чи були сумніви?';

  @override
  String get pressThrowbackTargetKeptHostile =>
      'Ви досягли мети, яку самі поставили. Пощастило чи справді так і було задумано?';

  @override
  String get pressThrowbackTargetBrokenWarm =>
      'Ви поставили мету й не дотягнули. Що пішло не так?';

  @override
  String get pressThrowbackTargetBrokenNeutral =>
      'Ви обіцяли більше, ніж дала ця команда. Шкодуєте, що сказали це?';

  @override
  String get pressThrowbackTargetBrokenHostile =>
      'Перед кампанією Ви говорили гучно, а не дотягнули. Чому тепер ми маємо вірити Вам?';

  @override
  String hubEventPressPreviewSub(String competition) {
    return '$competition: преса хоче почути твої цілі';
  }

  @override
  String deptLevelCost(int level, String amount) {
    return 'Рівень $level · $amount';
  }

  @override
  String get formOnFire => 'У вогні';

  @override
  String get formGood => 'У формі';

  @override
  String get formSteady => 'Стабільний';

  @override
  String get formPoor => 'Поза формою';

  @override
  String get formCold => 'Крижаний';

  @override
  String get playerFormTitle => 'ФОРМА І КОНДИЦІЯ';

  @override
  String playerFormAverage(String rating) {
    return 'У середньому $rating в останніх іграх';
  }

  @override
  String get playerFormNoGames => 'Замало останніх ігор для оцінки';

  @override
  String playerFormNextMatch(String delta) {
    return '$delta до його рейтингу в наступному матчі';
  }

  @override
  String get playerFormNoEffect =>
      'Без змін у його рейтингу в наступному матчі';

  @override
  String get sideGroupHome => 'Головна';

  @override
  String get sideGroupTeam => 'Команда';

  @override
  String get sideGroupCompetitions => 'Змагання';

  @override
  String get sideGroupFederation => 'Федерація';

  @override
  String get sideGroupHistory => 'Історія';

  @override
  String get sideInbox => 'Вхідні';

  @override
  String get sideSquad => 'Склад';

  @override
  String get sideTactics => 'Тактика';

  @override
  String get sideMainMenu => 'Головне меню';

  @override
  String get sideCallUps => 'Виклики';

  @override
  String get sideTournaments => 'Турніри';

  @override
  String get sideRanking => 'Рейтинг';

  @override
  String get sideResults => 'Результати';

  @override
  String get sideFinances => 'Фінанси';

  @override
  String get sideBoard => 'Рада';

  @override
  String get sideManager => 'Тренер і штаб';

  @override
  String get sideRecords => 'Рекорди';

  @override
  String get sideLegends => 'Легенди';

  @override
  String get sideHeadToHead => 'Очні зустрічі';

  @override
  String get sideAchievements => 'Досягнення';

  @override
  String get sideCareer => 'Кар’єра';

  @override
  String get topBarNext => 'Наступний';

  @override
  String get topBarDrawPending => 'Жеребкування попереду';

  @override
  String get paneFullProfile => 'Повний профіль';

  @override
  String get panePickPlayer => 'Обери гравця, щоб побачити його картку тут';

  @override
  String get inboxPickMessage => 'Обери повідомлення, щоб прочитати його тут';

  @override
  String get inboxFilterAll => 'Усі';

  @override
  String get panelViewAll => 'Показати все';

  @override
  String get gridViewOverview => 'Огляд';

  @override
  String get gridColCondition => 'Кондиція';

  @override
  String get gridColStatus => 'Статус';

  @override
  String get gridColRank => 'Місце';

  @override
  String get gridColMove => 'Зміна';

  @override
  String get gridColNation => 'Збірна';

  @override
  String get gridColRegion => 'Регіон';

  @override
  String get gridColPoints => 'Очки';

  @override
  String get panePickNation => 'Обери збірну, щоб побачити її здобутки тут';

  @override
  String get resultsCyclesTitle => 'Цикли';

  @override
  String get tourDrawStart => 'Почати жеребкування';

  @override
  String get tourDrawViewGroups => 'Показати групи';

  @override
  String get gridColCeiling => 'Стеля';

  @override
  String get gridColYearGain => 'Приріст';

  @override
  String get gridColMarkedAt => 'Коли додано';

  @override
  String get budgetSetupTitle => 'Визнач бюджет';

  @override
  String get budgetEffectsTitle => 'Що дає цей бюджет';

  @override
  String get naturalisationTitle => 'Натуралізація';

  @override
  String get yTrending => 'Тренди';

  @override
  String get yVoices => 'Голоси';

  @override
  String get yConversation => 'Розмова';

  @override
  String get allTimeRecordsTitle => 'Світові рекорди всіх часів';

  @override
  String get h2hMeetingsTitle => 'Усі зустрічі';

  @override
  String get h2hPickOpponent =>
      'Обери суперника, щоб побачити всі зустрічі тут';

  @override
  String get savesTitle => 'Збереження';

  @override
  String get gridColPlayer => 'Гравець';

  @override
  String get gridColPos => 'Поз.';

  @override
  String get gridColActive => 'Активний';

  @override
  String get gridColMotm => 'ГМ';

  @override
  String get gridColAvg => 'Сер.';

  @override
  String get gridColOpponent => 'Суперник';

  @override
  String get gridColStarts => 'Старти';

  @override
  String get gridColTournaments => 'Турніри';

  @override
  String get gridColDate => 'Дата';

  @override
  String get gridColLastPlayed => 'Остання гра';

  @override
  String get gridColManager => 'Тренер';

  @override
  String nationsShownCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count країни',
      many: '$count країн',
      few: '$count країни',
      one: '$count країна',
    );
    return '$_temp0';
  }

  @override
  String get nationsSortedByRank => 'За світовим рейтингом';

  @override
  String get nationsStrength => 'Сила';

  @override
  String nationsStrengthOf(int tier) {
    return '$tier з 5';
  }

  @override
  String get nationsSquadOverall => 'Загальний рівень складу';

  @override
  String get nationsOpeningBudget => 'Стартовий бюджет';

  @override
  String get nationsStarPlayer => 'Зірковий гравець';

  @override
  String nationsStarTile(String position, int rating) {
    return 'Зірка $position $rating';
  }

  @override
  String nationsStarAge(int age) {
    return 'Вік: $age';
  }

  @override
  String get nationsBoardExpects => 'Рада очікує';

  @override
  String nationsManage(String nation) {
    return 'Очолити: $nation';
  }

  @override
  String get nationsManagerNext => 'Далі ти вкажеш ім’я тренера';

  @override
  String get playerPageTitle => 'Гравець';

  @override
  String get nationPageTitle => 'Збірна';

  @override
  String get friendliesYourGames => 'Твої товариські матчі';

  @override
  String hubEventInjuryCover(String player) {
    return 'Заміна травмованого: $player';
  }

  @override
  String hubEventInjuryCoverSub(int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: 'Пропустить $matches матчу',
      many: 'Пропустить $matches матчів',
      few: 'Пропустить $matches матчі',
      one: 'Пропустить $matches матч',
    );
    return '$_temp0. Виклич когось або грай далі без нього.';
  }

  @override
  String get injuryCoverTitle => 'ЗАМІНА';

  @override
  String injuryCoverBanner(String player) {
    return '$player травмований. Виклич будь-кого поза складом, на будь-яку позицію, або залиш його й грай далі.';
  }

  @override
  String injuryCoverConfirm(String player) {
    return 'Викликати: $player';
  }

  @override
  String injuryCoverKeep(String player) {
    return 'Залишити: $player, грати далі';
  }

  @override
  String get injuryCoverPick => 'Обери заміну';

  @override
  String get injuryCoverNone =>
      'Нікого поза складом, хто був би готовий приєднатися.';

  @override
  String get nationNowRanking => 'Світовий рейтинг';

  @override
  String get nationNowForm => 'Форма';

  @override
  String get nationNowNoForm => 'Матчів ще не зіграно';

  @override
  String get nationNowNext => 'Наступний матч';

  @override
  String get nationNowNoNext => 'Нічого не заплановано';

  @override
  String get nationNowSquad => 'Склад';

  @override
  String get nationNowAgainstYou => 'Проти тебе';

  @override
  String nationNowRecord(int w, int d, int l) {
    return '$wВ $dН $lП';
  }

  @override
  String get nationNowLastMeeting => 'Остання зустріч';

  @override
  String nationNowOverall(int value) {
    return 'Рівень $value';
  }

  @override
  String get hubUpcoming => 'НАЙБЛИЖЧІ МАТЧІ';

  @override
  String get hubFullSchedule => 'Повний календар';

  @override
  String get scheduleTitle => 'Календар';

  @override
  String get scheduleToday => 'Сьогодні';

  @override
  String get scheduleKnockoutPending => 'Плей-оф, якщо пройдеш';

  @override
  String get scheduleNextRoundPending => 'Наступний раунд';

  @override
  String scheduleFromDate(String date) {
    return 'З $date';
  }

  @override
  String get scheduleHomeShort => 'Д';

  @override
  String get scheduleAwayShort => 'Г';

  @override
  String get tacticsNoPresetsInMatch =>
      'Збережених тактик ще немає. Збережи одну на екрані «Тактика» до матчу.';

  @override
  String get homeCampaigns => 'Кампанії';

  @override
  String get homeContinueCampaign => 'ПРОДОВЖИТИ КАМПАНІЮ';

  @override
  String homeCampaignCycle(String date, int cycle, int total) {
    return '$date · Цикл $cycle з $total';
  }

  @override
  String get campaignsTitle => 'Кампанії';

  @override
  String get campaignTransplantTitle => 'Пересадка';

  @override
  String get campaignTransplantTwist =>
      'Вісім найкращих гравців Італії міняють збірну на Сан-Марино';

  @override
  String get campaignTransplantGoal => 'Кваліфікуватися на Чемпіонат Європи';

  @override
  String get campaignGrudgeTitle => 'Ворожнеча';

  @override
  String get campaignGrudgeTwist => 'Грузія й Албанія в одній групі';

  @override
  String get campaignGrudgeGoal => 'Фінішувати вище за Албанію в кваліфікації';

  @override
  String get campaignTransplantIntro =>
      'У Сан-Марино ніколи не було кваліфікації, гідної цієї назви. А тоді вісім найкращих італійців беруть паспорт і заходять до команди. У тебе один цикл, щоб перетворити курйоз на команду.';

  @override
  String get campaignGrudgeIntro =>
      'Грузію й Албанію жереб звів в одну кваліфікаційну групу, і жодна не пробачить поразки. Фінішуй вище за Албанію, а тоді дивись, як далеко зможеш це понести.';

  @override
  String get campaignStars1Transplant => 'Кваліфікуватися';

  @override
  String get campaignStars2Transplant => 'Вийти в плей-оф';

  @override
  String get campaignStars3Transplant => 'Виграти Чемпіонат Європи';

  @override
  String get campaignStars1Grudge => 'Вище за Албанію';

  @override
  String get campaignStars2Grudge => 'І кваліфікуватися';

  @override
  String get campaignStars3Grudge => 'І двічі її обіграти';

  @override
  String get campaignFree => 'Безкоштовно';

  @override
  String get campaignStart => 'Почати';

  @override
  String get campaignPartOfUnlimited => 'Входить до Unlimited';

  @override
  String get campaignResume => 'Продовжити';

  @override
  String get campaignAbandon => 'Покинути';

  @override
  String get campaignAbandonConfirm =>
      'Покинути цю спробу? Прогрес буде втрачено, печатка залишиться.';

  @override
  String get campaignMoveToSaves => 'Перенести до збережень';

  @override
  String get campaignCannotContinue =>
      'Світ цієї кампанії надто далекий від реального, щоб продовжувати її як кар’єру.';

  @override
  String get campaignMoveSlotsFull =>
      'Усі слоти збережень зайняті. Спершу звільни один.';

  @override
  String get campaignStampConquered => 'Підкорено';

  @override
  String get campaignStampFailed => 'Провалено';

  @override
  String get campaignDifficultyHard => 'Складна';

  @override
  String get campaignDifficultyMedium => 'Середня';

  @override
  String get campaignGoalLabel => 'Мета';

  @override
  String get campaignStarsLabel => 'Зірки';

  @override
  String get campaignRunInProgress => 'У цієї кампанії вже триває спроба.';

  @override
  String get campaignVerdictWon => 'Підкорено';

  @override
  String get campaignVerdictLost => 'Не цього разу';

  @override
  String get campaignVerdictContinue => 'Продовжити';

  @override
  String campaignProgressQualifying(String position) {
    return 'Кваліфікація: $position';
  }

  @override
  String campaignProgressRival(String rival, String position) {
    return '$rival: $position';
  }

  @override
  String campaignProgressFinals(String stage) {
    return 'Фінальна частина: $stage';
  }

  @override
  String get campaignRunInNumbers => 'Спроба в цифрах';

  @override
  String campaignRunMeetings(int won, int played) {
    return 'Виграно зустрічей: $won із $played';
  }

  @override
  String campaignPlace(String which, int n) {
    String _temp0 = intl.Intl.selectLogic(
      which,
      {
        'first': '1-ше',
        'second': '2-ге',
        'third': '3-тє',
        'other': '$n-те',
      },
    );
    return '$_temp0';
  }

  @override
  String get campaignGuineasTitle => 'Найкращий із Гвінеїв';

  @override
  String get campaignGuineasTwist =>
      'Екваторіальна Гвінея, найнижча за рейтингом з африканських Гвінеїв, протягом двох циклів';

  @override
  String get campaignGuineasGoal => 'Обіграти Гвінею та Гвінею-Бісау';

  @override
  String get campaignGuineasIntro =>
      'Три африканські країни носять назву Гвінея, і Екваторіальна Гвінея серед них найнижча в рейтингу. У тебе два цикли, щоб принаймні раз обіграти Гвінею й Гвінею-Бісау, а тоді подивитися, як далеко ти зайдеш на Чемпіонаті Африки. Папуа-Нова Гвінея, четверта Гвінея, вже записана на товариський матч.';

  @override
  String get campaignStars1Guineas => 'Обіграти Гвінею та Гвінею-Бісау';

  @override
  String get campaignStars2Guineas => 'І кваліфікуватися на Чемпіонат Африки';

  @override
  String get campaignStars3Guineas =>
      'І вийти до чвертьфіналу Чемпіонату Африки';

  @override
  String get campaignYoungFinnsTitle => 'Молоді фіни';

  @override
  String get campaignYoungFinnsTwist =>
      'Золоте покоління фінських підлітків, протягом трьох циклів';

  @override
  String get campaignYoungFinnsGoal => 'Кваліфікуватися на Чемпіонат світу';

  @override
  String get campaignYoungFinnsIntro =>
      'Дорослі гравці Фінляндії відійшли вбік, а їхнє місце посіло золоте покоління: кожному гравцеві, якого ти можеш обрати, 18 років або менше. Сьогодні вони ще сирі, але мають талант стати однією з найкращих збірних світу, так само як молоде покоління Норвегії. У тебе три цикли, щоб довести їх до Чемпіонату світу, а потім виграти Чемпіонат Європи та Чемпіонат світу.';

  @override
  String get campaignStars1YoungFinns => 'Кваліфікуватися на Чемпіонат світу';

  @override
  String get campaignStars2YoungFinns => 'Виграти Чемпіонат Європи';

  @override
  String get campaignStars3YoungFinns => 'Виграти Чемпіонат світу';

  @override
  String get campaignPro => 'Pro';

  @override
  String campaignProgressCup(String cup, String year, String status) {
    return '$cup $year: $status';
  }

  @override
  String get campaignCupNotQualified => 'Не кваліфікувалися';

  @override
  String get campaignCupOpen => 'Ще не визначено';
}
