// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get matchPreviewTitle => 'قبل المباراة';

  @override
  String get matchKickOff => 'ضربة البداية';

  @override
  String get matchTactics => 'التكتيك';

  @override
  String get matchYourXi => 'تشكيلتك';

  @override
  String get matchHeadToHead => 'المواجهات المباشرة';

  @override
  String matchCouldNotLoad(String error) {
    return 'تعذّر تحميل المباراة.\n$error';
  }

  @override
  String get matchNoUpcoming => 'لا توجد مباراة قادمة.';

  @override
  String get matchUnknownNation => 'غير معروف';

  @override
  String get matchH2hFirstMeeting => 'أول مواجهة على الإطلاق';

  @override
  String get matchH2hYouLead => 'أنت متفوق في المواجهات المباشرة';

  @override
  String matchH2hOppEdge(String opponent) {
    return 'الأفضلية لـ$opponent';
  }

  @override
  String get matchH2hEven => 'تكافؤ تام';

  @override
  String matchH2hMet(int count) {
    return '$count مواجهة';
  }

  @override
  String get matchH2hWon => 'فوز';

  @override
  String get matchH2hDrawn => 'تعادل';

  @override
  String get matchH2hLost => 'خسارة';

  @override
  String get matchDossierTitle => 'تقرير الكشافين';

  @override
  String get matchDossierForm => 'المستوى';

  @override
  String get matchDossierNoGames => 'لا مباريات حديثة';

  @override
  String get matchDossierKeyMen => 'اللاعبون المفاتيح';

  @override
  String get matchDossierHowTheyPlay => 'أسلوب لعبهم';

  @override
  String matchScoutFormation1(String formation) {
    return 'يلعبون عادةً بخطة $formation.';
  }

  @override
  String matchScoutFormation2(String formation) {
    return 'خطتهم المعتادة هي $formation.';
  }

  @override
  String matchScoutFormation3(String formation) {
    return 'يميلون إلى اللعب بخطة $formation.';
  }

  @override
  String get matchScoutStrengthPressing => 'يضغطون عاليًا ويطاردون الكرة.';

  @override
  String get matchScoutStrengthDirect =>
      'يلعبون كرة مباشرة ويرسلون الكرة إلى الأمام مبكرًا.';

  @override
  String get matchScoutStrengthPossession =>
      'يحتفظون بالكرة جيدًا ويبنون اللعب بصبر.';

  @override
  String get matchScoutStrengthCounter =>
      'يتراجعون وينطلقون بسرعة في الهجمات المرتدة.';

  @override
  String get matchScoutStrengthDeepDefence =>
      'يدافعون في العمق ويصعب اختراقهم.';

  @override
  String get matchScoutStrengthWide => 'يوسّعون الملعب ويهاجمون عبر الأطراف.';

  @override
  String get matchScoutStrengthAttacking => 'يحبون فرض أسلوبهم على المنافس.';

  @override
  String get matchScoutStrengthQuickForwards =>
      'مهاجموهم سريعون ويعشقون الانطلاق خلف الدفاع.';

  @override
  String get matchScoutStrengthPassingMidfield => 'خط وسطهم يمرر الكرة بإتقان.';

  @override
  String get matchScoutStrengthHardRunning =>
      'خط وسطهم يملك لياقة للجري طوال المباراة.';

  @override
  String get matchScoutStrengthSetPieces => 'إنهم خطيرون في الكرات الثابتة.';

  @override
  String get matchScoutStrengthQuickDefence => 'خط دفاعهم سريع ويصعب تجاوزه.';

  @override
  String get matchScoutStrengthNone => 'لا شيء يلفت النظر حقًا في أسلوبهم.';

  @override
  String get matchScoutWeakSpaceBehind =>
      'خط دفاعهم المتقدم يترك مساحة خلفه لكرة طويلة من فوقه.';

  @override
  String get matchScoutWeakPressedBuildUp =>
      'الضغط العالي قد يربك بناءهم البطيء للهجمات.';

  @override
  String get matchScoutWeakDeepBlock =>
      'تحلَّ بالصبر: يمكن تفكيك تكتل دفاعي عميق كتكتلهم.';

  @override
  String get matchScoutWeakLongBall =>
      'أرجع خطك إلى الخلف ولن تجد كراتهم الطويلة أي مساحة.';

  @override
  String get matchScoutWeakSlowDefence =>
      'مدافعوهم يفتقرون إلى السرعة، فأرسل لاعبين للانطلاق خلفهم.';

  @override
  String get matchScoutWeakAerial =>
      'يبدون مرتبكين عند الدفاع في الكرات الثابتة.';

  @override
  String get matchScoutWeakPoorPassing =>
      'خط وسطهم يعاني في الخروج بالكرة تحت الضغط.';

  @override
  String get matchScoutWeakTiringMidfield =>
      'خط وسطهم يفتقر إلى اللياقة للحفاظ على الضغط.';

  @override
  String get matchScoutWeakBluntAttack => 'مهاجموهم يفتقرون إلى السرعة.';

  @override
  String get matchScoutApproachTakeTheGame =>
      'أمامك، توقّع أن يبادروا بالهجوم.';

  @override
  String get matchScoutApproachEven => 'أمامك، توقّع مباراة متقاربة ومتكافئة.';

  @override
  String get matchScoutApproachSitDeep =>
      'أمامك، توقّع أن يلعبوا بحذر ويبحثوا عن المرتدات.';

  @override
  String get matchScoutLeaningAttacking => 'من بعيد يبدون فريقًا هجوميًا.';

  @override
  String get matchScoutLeaningCautious => 'من بعيد يبدون فريقًا حذرًا.';

  @override
  String get matchScoutLeaningUnclear => 'من بعيد يصعب معرفة أسلوب لعبهم.';

  @override
  String get matchScoutHireHint => 'عيّن كبير كشافين لتعرف أسلوب لعبهم.';

  @override
  String matchCouldNotContinue(String error) {
    return 'تعذّرت المتابعة: $error';
  }

  @override
  String get matchSkipToFullTime => 'انتقل إلى نهاية المباراة';

  @override
  String get matchStatShots => 'التسديدات';

  @override
  String get matchStatGoals => 'الأهداف';

  @override
  String get matchStatYellowCards => 'الصفراء';

  @override
  String get matchStatRedCards => 'الحمراء';

  @override
  String get matchMomentum => 'الزخم';

  @override
  String get matchSwingAtk => 'هجوم';

  @override
  String get matchSwingDef => 'دفاع';

  @override
  String ceremonyWorldCupYear(int year) {
    return 'بطولة العالم $year';
  }

  @override
  String get ceremonyFinalsAreHere => 'انطلقت النهائيات';

  @override
  String ceremonyHostedBy(String hosts) {
    return 'تستضيفها  $hosts';
  }

  @override
  String get ceremonyHostTbc => 'المستضيف لم يُحدَّد بعد';

  @override
  String get matchHalfTime => 'نهاية الشوط الأول';

  @override
  String matchHalfTimeScore(int home, int away) {
    return 'الشوط الأول ⁦$home : $away⁩';
  }

  @override
  String resultAggregate(int home, int away) {
    return 'مجموع ⁦$home⁦-$away⁩⁩';
  }

  @override
  String get matchContinue => 'متابعة';

  @override
  String get matchContinuing => 'جارٍ المتابعة…';

  @override
  String matchTacticsWithSubs(int used, int max) {
    return 'التكتيك · ⁦$used/$max⁩ تبديلات';
  }

  @override
  String matchTiredCount(int count) {
    return 'متعبون ×$count';
  }

  @override
  String get matchTacticsLabel => 'التكتيك';

  @override
  String get teamOverallOverTime => 'التقييم العام عبر الزمن';

  @override
  String get teamOverall => 'التقييم العام';

  @override
  String get teamTalkHeading => 'حديث الفريق';

  @override
  String get teamTalkPrompt => 'حدّد نبرة الشوط الثاني.';

  @override
  String get teamTalkCalmLabel => 'هدوء الأعصاب';

  @override
  String get teamTalkCalmBlurb => 'ثبّت الفريق. دفعة صغيرة في كل الخطوط.';

  @override
  String get teamTalkEncourageLabel => 'التشجيع';

  @override
  String get teamTalkEncourageBlurb => 'تقدّموا إلى الأمام واسعوا للفوز.';

  @override
  String get teamTalkDemandMoreLabel => 'اطلب المزيد';

  @override
  String get teamTalkDemandMoreBlurb => 'ارموا بكل شيء. هاجموا بقوة.';

  @override
  String get teamTalkPraiseLabel => 'حافظوا على التماسك';

  @override
  String get teamTalkPraiseBlurb => 'ابقوا متقاربين واحموا ما لديكم.';

  @override
  String get teamTalkBelieveLabel => 'ثقوا بأنفسكم';

  @override
  String get teamTalkBelieveBlurb => 'ثقوا بقدراتكم. دفعة في طرفي الملعب.';

  @override
  String get teamTalkFocusLabel => 'ابقوا يقظين';

  @override
  String get teamTalkFocusBlurb => 'تركيز تام. أغلقوا المباراة.';

  @override
  String get teamTalkUrgencyLabel => 'الإحساس بالعجلة';

  @override
  String get teamTalkUrgencyBlurb =>
      'طاردوا النتيجة الآن. هجوم شامل يترك ثغرات.';

  @override
  String get teamTalkReassureLabel => 'بلا ضغوط';

  @override
  String get teamTalkReassureBlurb => 'هدّئوا الأعصاب وحافظوا على تنظيمكم.';

  @override
  String get commonRetry => 'إعادة المحاولة';

  @override
  String get commonSomethingWentWrong => 'حدث خطأ ما';

  @override
  String get commonCrashBox =>
      'حدث خطأ ما هنا.\nالتفاصيل في الإعدادات ← التشخيص.';

  @override
  String get hubSimulatingMatchday => 'جارٍ محاكاة الجولة…';

  @override
  String hubCouldNotAdvance(String error) {
    return 'تعذّر تقديم العالم: $error';
  }

  @override
  String get settingsDiagnosticsTitle => 'التشخيص';

  @override
  String get settingsDiagnosticsBlurb =>
      'الأخطاء المسجلة على هذا الجهاز. لا يُرسل أي شيء إلى أي مكان.';

  @override
  String get settingsContactTitle => 'تواصل معنا';

  @override
  String get settingsContactCopied => 'تم نسخ العنوان.';

  @override
  String get settingsCommunityTitle => 'المجتمع';

  @override
  String get settingsDiscordSubtitle => 'انضم إلى المجتمع';

  @override
  String get settingsLinkCopied => 'تم نسخ الرابط.';

  @override
  String get diagnosticsEmpty => 'لا أخطاء مسجلة. هذا هو المطلوب.';

  @override
  String get diagnosticsCopy => 'نسخ';

  @override
  String get diagnosticsCopied => 'تم نسخ السجل إلى الحافظة.';

  @override
  String get diagnosticsClear => 'مسح';

  @override
  String get navHub => 'الرئيسية';

  @override
  String get navSquad => 'الفريق';

  @override
  String get navStandings => 'الترتيب';

  @override
  String get navCareers => 'مسيرتي';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get settingsSoundHapticsTitle => 'الصوت والاهتزاز';

  @override
  String get settingsSoundHapticsBlurb =>
      'اهتزاز ونغمة قصيرة عند الأهداف وضربة البداية ونهاية المباراة.';

  @override
  String get settingsMatchSoundTitle => 'صوت الملعب';

  @override
  String get settingsMatchSoundBlurb =>
      'هتافات الجماهير وصافرة الحكم أثناء المباريات.';

  @override
  String get settingsMatchSoundVolume => 'مستوى الصوت';

  @override
  String get settingsLanguageTitle => 'اللغة';

  @override
  String get settingsLanguageBlurb => 'اختر لغة التطبيق، أو اتبع لغة جهازك.';

  @override
  String get settingsLanguageSystem => 'لغة النظام';

  @override
  String get settingsTextSizeTitle => 'حجم النص';

  @override
  String get settingsTextSizeBlurb => 'كبّر النص إذا كانت قراءته صعبة.';

  @override
  String get settingsTextSizeNormal => 'عادي';

  @override
  String get settingsTextSizeLarge => 'كبير';

  @override
  String get settingsTextSizeLarger => 'أكبر';

  @override
  String get matchPreviewAllMeetings => 'كل المواجهات';

  @override
  String get recordsMeetings => 'المواجهات';

  @override
  String get recordsLegends => 'الأساطير';

  @override
  String get recordsAllTimeXi => 'التشكيلة التاريخية';

  @override
  String get recordsHallOfFame => 'قاعة المشاهير';

  @override
  String get recordsAllTimeWorld => 'سجل العالم التاريخي';

  @override
  String get recordsAllTimeTopScorers => 'الهدافون التاريخيون';

  @override
  String get recordsMostCapped => 'الأكثر مشاركة دوليًا';

  @override
  String get recordsMostWcStarts => 'الأكثر مشاركة أساسيًا في بطولة العالم';

  @override
  String get recordsMostTournaments => 'الأكثر حضورًا في البطولات';

  @override
  String get recordsRecordBook => 'سجل الأرقام';

  @override
  String get recordsHeadToHead => 'المواجهات المباشرة';

  @override
  String get recordsFiercestRival => 'الغريم الأشرس';

  @override
  String get recordsMostCaps => 'الأكثر مشاركة';

  @override
  String get recordsTopScorers => 'الهدافون';

  @override
  String get recordsMostAssists => 'الأكثر صناعة للأهداف';

  @override
  String get recordsYourRecord => 'سجلك';

  @override
  String get callUpHome => 'على أرضنا';

  @override
  String get callUpAway => 'خارج أرضنا';

  @override
  String get recordsHome => 'المضيف';

  @override
  String get recordsAway => 'الضيف';

  @override
  String get recordsActive => 'نشط';

  @override
  String get recordsStillActive => 'لا يزال يلعب';

  @override
  String get recordsAvg => 'متوسط';

  @override
  String get recordsSelect => 'اختر';

  @override
  String get recordsVs => 'ضد';

  @override
  String get recordsDraws => 'تعادلات';

  @override
  String get recordsGoalsLabel => 'الأهداف';

  @override
  String get recordsBestFinish => 'أفضل إنجاز';

  @override
  String get recordsNoFinalsYet => 'لم يتأهل إلى النهائيات بعد';

  @override
  String get recordsLongestUnbeaten => 'أطول سلسلة دون هزيمة';

  @override
  String get recordsBiggestWin => 'أكبر فوز';

  @override
  String get recordsTileMatches => 'المباريات';

  @override
  String get recordsTileWins => 'الانتصارات';

  @override
  String get recordsTileTrophies => 'الألقاب';

  @override
  String recordsWinSharePercent(String pct) {
    return '$pct%';
  }

  @override
  String recordsTrophyLatest(String competition, String year) {
    return '$competition $year';
  }

  @override
  String get recordsNoTrophiesYet => 'لا شيء بعد';

  @override
  String get recordsBiggestDefeat => 'أكبر هزيمة';

  @override
  String get recordsRecordHolders => 'حاملو الأرقام القياسية';

  @override
  String get recordsMostCleanSheets => 'الأكثر حفاظًا على نظافة الشباك';

  @override
  String get recordsSeeAllMeetings => 'عرض كل المواجهات';

  @override
  String get recordsSaveNotFound => 'لم يُعثر على ملف الحفظ.';

  @override
  String get recordsNoMatches => 'لا نتائج.';

  @override
  String get recordsSearchPlayerOrNation => 'ابحث عن لاعب أو منتخب';

  @override
  String get recordsSearchNation => 'ابحث عن منتخب';

  @override
  String get recordsPickTwoDifferent => 'اختر منتخبين مختلفين.';

  @override
  String get recordsPlayToBuildRecord =>
      'العب بعض المباريات وسيتكوّن هنا سجلك أمام كل منافس.';

  @override
  String get recordsTapOpponent => 'اضغط على منافس لعرض التفاصيل كاملة.';

  @override
  String get recordsEdgeUpperHand => 'لك اليد العليا';

  @override
  String get recordsEdgeTheirNumber => 'لهم الأفضلية عليك';

  @override
  String get recordsEdgeEven => 'تكافؤ تام';

  @override
  String get recordsAllTimeWorldSubtitle =>
      'الهدافون والأكثر مشاركة عالميًا، كل المنتخبات';

  @override
  String get recordsHeadToHeadSubtitle => 'قارن السجل التاريخي لأي منتخبين';

  @override
  String get recordsLegendsSubtitle => 'التشكيلة التاريخية وقاعة المشاهير';

  @override
  String get recordsUnitGoals => 'أهداف';

  @override
  String get recordsUnitCaps => 'مباريات';

  @override
  String get recordsUnitStarts => 'مشاركات أساسية';

  @override
  String get recordsUnitCups => 'بطولات';

  @override
  String get recordsUnitAssists => 'تمريرات حاسمة';

  @override
  String recordsCapsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مباراة دولية',
      many: '$count مباراة دولية',
      few: '$count مباريات دولية',
      two: 'مباراتان دوليتان',
      one: 'مباراة دولية واحدة',
      zero: '$count مباراة دولية',
    );
    return '$_temp0';
  }

  @override
  String recordsGoalsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count هدف',
      many: '$count هدفًا',
      few: '$count أهداف',
      two: 'هدفان',
      one: 'هدف واحد',
      zero: '$count هدف',
    );
    return '$_temp0';
  }

  @override
  String recordsAssistsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count تمريرة حاسمة',
      many: '$count تمريرة حاسمة',
      few: '$count تمريرات حاسمة',
      two: 'تمريرتان حاسمتان',
      one: 'تمريرة حاسمة واحدة',
      zero: '$count تمريرة حاسمة',
    );
    return '$_temp0';
  }

  @override
  String recordsMotmCount(int count) {
    return '$count رجل المباراة';
  }

  @override
  String recordsMatchesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مباراة',
      many: '$count مباراة',
      few: '$count مباريات',
      two: 'مباراتان',
      one: 'مباراة واحدة',
      zero: '$count مباراة',
    );
    return '$_temp0';
  }

  @override
  String recordsMeetingsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مواجهة',
      many: '$count مواجهة',
      few: '$count مواجهات',
      two: 'مواجهتان',
      one: 'مواجهة واحدة',
      zero: '$count مواجهة',
    );
    return '$_temp0';
  }

  @override
  String recordsCodeWins(String code) {
    return 'انتصارات $code';
  }

  @override
  String recordsMeetingsWdl(int meetings, int wins, int draws, int losses) {
    String _temp0 = intl.Intl.pluralLogic(
      meetings,
      locale: localeName,
      other: '$meetings مواجهة',
      many: '$meetings مواجهة',
      few: '$meetings مواجهات',
      two: 'مواجهتان',
      one: 'مواجهة واحدة',
      zero: '$meetings مواجهة',
    );
    return '$_temp0 · ف$wins ت$draws خ$losses';
  }

  @override
  String recordsWdl(int wins, int draws, int losses) {
    return 'ف$wins ت$draws خ$losses';
  }

  @override
  String recordsRivalLine(int meetings, String record, String edge) {
    String _temp0 = intl.Intl.pluralLogic(
      meetings,
      locale: localeName,
      other: '$meetings مواجهة',
      many: '$meetings مواجهة',
      few: '$meetings مواجهات',
      two: 'مواجهتان',
      one: 'مواجهة واحدة',
      zero: '$meetings مواجهة',
    );
    return '$_temp0 · $record · $edge';
  }

  @override
  String recordsNeverMet(String a, String b) {
    return 'لم يلتقِ $a و$b قط في هذا الحفظ.';
  }

  @override
  String tacticsSentOffNote(String names) {
    return 'طُرد $names. لا بديل له، فستلعب بنقص عددي.';
  }

  @override
  String tacticsNeedFitPlayers(int required, int have) {
    return 'يلزم $required لاعبًا متاحًا ($have جاهزون)';
  }

  @override
  String tacticsMissesOfCamp(int missed, int total) {
    return 'يغيب عن ⁦$missed/$total⁩';
  }

  @override
  String get tacticsOutForWholeCamp => 'غائب طوال فترة الاستدعاء هذه';

  @override
  String get rankingCentreOnMe => 'انتقل إلى منتخبي';

  @override
  String get recordsAfterExtraTime => 'بعد التمديد';

  @override
  String recordsOnPenalties(int a, int b) {
    return '⁦$a–$b⁩ ترجيح';
  }

  @override
  String recordsVersus(String a, String b) {
    return '$a ضد $b';
  }

  @override
  String recordsPlayedScore(int played, int gf, int ga) {
    return '$played مباراة · ⁦$gf–$ga⁩';
  }

  @override
  String recordsBiggestWinValue(int gf, int ga, String opp) {
    return '⁦$gf–$ga⁩ ضد $opp';
  }

  @override
  String recordsCouldNotLoad(String error) {
    return 'تعذّر التحميل.\n$error';
  }

  @override
  String recordsCouldNotLoadLegends(String error) {
    return 'تعذّر تحميل الأساطير.\n$error';
  }

  @override
  String recordsCouldNotLoadRecords(String error) {
    return 'تعذّر تحميل السجلات.\n$error';
  }

  @override
  String recordsCouldNotLoadNations(String error) {
    return 'تعذّر تحميل المنتخبات.\n$error';
  }

  @override
  String recordsCouldNotLoadYourRecord(String error) {
    return 'تعذّر تحميل سجلك.\n$error';
  }

  @override
  String recordsCouldNotLoadRecord(String error) {
    return 'تعذّر تحميل السجل.\n$error';
  }

  @override
  String recordsNoLegends(String nation) {
    return 'لا أساطير بعد. العب بعض الحملات وسيظهر هنا عظماء $nation.';
  }

  @override
  String recordsGreatestSide(String nation) {
    return 'أعظم تشكيلة يمكن أن يدفع بها منتخب $nation.';
  }

  @override
  String get recordsNoWorldHistory =>
      'لا تاريخ للعالم بعد. العب بعض الحملات وسيظهر هنا عظماء كل العصور.';

  @override
  String recordsPlayToWriteHistory(String nation) {
    return 'العب بعض المباريات لتبدأ كتابة تاريخ $nation.';
  }

  @override
  String get tacticsLineGk => 'حراسة';

  @override
  String get tacticsLineDef => 'دفاع';

  @override
  String get tacticsLineMid => 'وسط';

  @override
  String get tacticsLineFwd => 'هجوم';

  @override
  String get tacticsGoalkeepers => 'حراس المرمى';

  @override
  String get tacticsDefenders => 'المدافعون';

  @override
  String get tacticsMidfielders => 'لاعبو الوسط';

  @override
  String get tacticsForwards => 'المهاجمون';

  @override
  String get tacticsCallUpsTitle => 'الاستدعاءات';

  @override
  String tacticsPickAtLeastPlayers(int min) {
    return 'اختر $min لاعبين على الأقل.';
  }

  @override
  String tacticsCouldNotLoadSquad(String error) {
    return 'تعذّر تحميل القائمة.\n$error';
  }

  @override
  String get tacticsNoSquad => 'لا توجد قائمة.';

  @override
  String tacticsSquadCount(int count, int max) {
    return 'القائمة · ⁦$count/$max⁩';
  }

  @override
  String tacticsMinMax(int min, int max) {
    return 'الحد الأدنى $min · الأقصى $max';
  }

  @override
  String get tacticsBestQuality => 'الأفضل جودة';

  @override
  String get tacticsPreviousSquad => 'القائمة السابقة';

  @override
  String get tacticsSquadLockedBack => 'رجوع (القائمة مقفلة)';

  @override
  String get tacticsConfirmSquad => 'تأكيد القائمة';

  @override
  String tacticsSquadFullMax(int max) {
    return 'القائمة مكتملة (الحد الأقصى $max)';
  }

  @override
  String get tacticsSquadLocked => 'القائمة مقفلة';

  @override
  String get tacticsNominationOpen => 'باب الاستدعاء مفتوح. اختر قائمتك';

  @override
  String get tacticsSquadFixedBlurb =>
      'هذه القائمة ثابتة للمباريات أدناه. أعد الاختيار قبل فترة الاستدعاء التالية.';

  @override
  String get tacticsSquadWillPlayBlurb => 'هذه القائمة ستخوض المباريات أدناه.';

  @override
  String get tacticsUnknown => 'غير معروف';

  @override
  String tacticsAgeValue(int age, String value) {
    return 'العمر $age · $value';
  }

  @override
  String get tacticsFatigueExhausted => 'منهك';

  @override
  String get tacticsFatigueTired => 'متعب';

  @override
  String get tacticsFatigueMatchLegs => 'إرهاق المباريات';

  @override
  String tacticsTooManySubs(int max) {
    return 'تبديلات كثيرة جدًا (الحد الأقصى $max).';
  }

  @override
  String tacticsMinuteTitle(int minute) {
    return 'التكتيك · ⁦$minute\'⁩';
  }

  @override
  String get tacticsApply => 'تطبيق';

  @override
  String get tacticsTabLineupSubs => 'التشكيلة والتبديلات';

  @override
  String get tacticsTabTactics => 'التكتيك';

  @override
  String get squadLineKeepers => 'الحراس';

  @override
  String get squadLineDefenders => 'الدفاع';

  @override
  String get squadLineMidfielders => 'الوسط';

  @override
  String get squadLineForwards => 'الهجوم';

  @override
  String get squadStatXiRating => 'تقييم التشكيلة';

  @override
  String get squadStatAvgAge => 'متوسط العمر';

  @override
  String get squadStatSize => 'القائمة';

  @override
  String get squadStatUnavailable => 'غائبون';

  @override
  String get squadDepthTitle => 'العمق حسب الخط';

  @override
  String squadAgeShort(int age) {
    return '$age سنة';
  }

  @override
  String get tacticsTabOtherPositions => 'مراكز أخرى';

  @override
  String get tacticsOutOfPositionNote => 'في غير مركزه هنا';

  @override
  String get tacticsNobodyElse => 'لا أحد غيره لتجربته هنا.';

  @override
  String get tacticsPickSomebodyFirst =>
      'اختر من سيخرج وستظهر هنا بقية الدكة، مع مستوى كل لاعب في هذا المركز.';

  @override
  String get tacticsTabSuitable => 'المناسبون';

  @override
  String get tacticsTabOnPitch => 'في الملعب';

  @override
  String tacticsSectionSuitable(int count) {
    return 'المناسبون · $count';
  }

  @override
  String get tacticsNobodySuits =>
      'لا أحد على الدكة يناسب هذا المركز بطبيعته، فإليك الجميع.';

  @override
  String tacticsSectionOnPitch(int count, int max) {
    return 'في الملعب · ⁦$count/$max⁩';
  }

  @override
  String tacticsSectionAvailable(int count) {
    return 'المتاحون · $count';
  }

  @override
  String get tacticsRowStarted => 'أساسي';

  @override
  String tacticsRowCameOn(int minute) {
    return 'دخل في الدقيقة ⁦$minute\'⁩';
  }

  @override
  String get tacticsRowSubstitute => 'دخل بديلًا';

  @override
  String get tacticsEnergyLabel => 'الطاقة';

  @override
  String tacticsPickReplacementFor(String name) {
    return 'اضغط على بديل لـ$name، أو اضغط عليه مجددًا للإلغاء.';
  }

  @override
  String get tacticsSlotLostToRedCard =>
      'البطاقة الحمراء كلفتك هذا المركز. اسحب زميلًا إلى هنا لنقل الفراغ.';

  @override
  String get tacticsSentOffShort => 'مطرود';

  @override
  String get tacticsFullBackLeft => 'الظهير الأيسر';

  @override
  String get tacticsFullBackRight => 'الظهير الأيمن';

  @override
  String get tacticsFullBackUp => 'التقدم';

  @override
  String get tacticsFullBackDown => 'البقاء في الخلف';

  @override
  String get tacticsFullBackOff => 'بلا تعليمات';

  @override
  String tacticsFullBackUpHint(String side) {
    return '$side: التقدم. هجوم أكثر قليلًا، ومخاطرة أكثر قليلًا.';
  }

  @override
  String tacticsFullBackDownHint(String side) {
    return '$side: البقاء في الخلف. أمان أكثر قليلًا، وهجوم أقل قليلًا.';
  }

  @override
  String tacticsFullBackOffHint(String side) {
    return '$side: بلا تعليمات، يلعب وفق خطة الفريق.';
  }

  @override
  String tacticsFullBackSemantics(String side, String state) {
    return 'سهم ⁦$side: $state⁩';
  }

  @override
  String tacticsSubsUsed(int used, int max) {
    return 'التبديلات · ⁦$used/$max⁩';
  }

  @override
  String get tacticsDragSubOn =>
      'اضغط على لاعب في الملعب لإخراجه، أو اضغط مطولًا واسحب بديلًا فوقه.';

  @override
  String get tacticsNoSubs => 'لا بدلاء متاحون.';

  @override
  String get tacticsChooseShape => 'اختر الخطة';

  @override
  String get tacticsFormation => 'الخطة';

  @override
  String get tacticsInstructions => 'التعليمات';

  @override
  String get tacticsDrilling => 'الانسجام';

  @override
  String get tacticsDrillingUnplayed => 'لم تُجرَّب';

  @override
  String get tacticsDrillingNew => 'جديدة';

  @override
  String get tacticsDrillingSettling => 'قيد التأقلم';

  @override
  String get tacticsDrillingDrilled => 'متقنة';

  @override
  String get tacticsInstrMentality => 'العقلية';

  @override
  String get tacticsInstrDefensive => 'دفاعية';

  @override
  String get tacticsInstrAttacking => 'هجومية';

  @override
  String get tacticsInstrPressing => 'الضغط';

  @override
  String get tacticsInstrLowBlock => 'تكتل منخفض';

  @override
  String get tacticsInstrHighPress => 'ضغط عالٍ';

  @override
  String get tacticsInstrTempo => 'الإيقاع';

  @override
  String get tacticsInstrPatient => 'صبور';

  @override
  String get tacticsInstrFast => 'سريع';

  @override
  String get tacticsInstrWidth => 'العرض';

  @override
  String get tacticsInstrNarrow => 'ضيق';

  @override
  String get tacticsInstrWide => 'واسع';

  @override
  String get tacticsInstrDefLine => 'خط الدفاع';

  @override
  String get tacticsInstrDefensiveLine => 'خط الدفاع';

  @override
  String get tacticsInstrDeep => 'متأخر';

  @override
  String get tacticsInstrHigh => 'متقدم';

  @override
  String get tacticsInstrDirectness => 'المباشرة';

  @override
  String get tacticsInstrPossession => 'استحواذ';

  @override
  String get tacticsInstrDirect => 'مباشر';

  @override
  String get tacticsPickGoalkeeper => 'اختر حارس المرمى';

  @override
  String get tacticsPickLeftBack => 'اختر الظهير الأيسر';

  @override
  String get tacticsPickCentreBack => 'اختر قلب الدفاع';

  @override
  String get tacticsPickRightBack => 'اختر الظهير الأيمن';

  @override
  String get tacticsPickDefensiveMid => 'اختر لاعب الوسط المدافع';

  @override
  String get tacticsPickCentralMid => 'اختر لاعب الوسط';

  @override
  String get tacticsPickAttackingMid => 'اختر لاعب الوسط المهاجم';

  @override
  String get tacticsPickLeftMid => 'اختر لاعب الوسط الأيسر';

  @override
  String get tacticsPickRightMid => 'اختر لاعب الوسط الأيمن';

  @override
  String get tacticsPickLeftWing => 'اختر الجناح الأيسر';

  @override
  String get tacticsPickRightWing => 'اختر الجناح الأيمن';

  @override
  String get tacticsPickStriker => 'اختر رأس الحربة';

  @override
  String tacticsRoleOutOfPosition(String role) {
    return '$role · في غير مركزه';
  }

  @override
  String tacticsAgeOnly(int age) {
    return 'العمر $age';
  }

  @override
  String tacticsRoleAge(String role, int age) {
    return '$role · العمر $age';
  }

  @override
  String get tacticsOn => 'في الملعب';

  @override
  String get tacticsSquad => 'الفريق';

  @override
  String get tacticsTabLineup => 'التشكيلة';

  @override
  String get tacticsTabInstructions => 'التعليمات';

  @override
  String get tacticsTabRoles => 'الأدوار';

  @override
  String get tacticsTabSetPieces => 'الكرات الثابتة';

  @override
  String get tacticsTabRolesSetPieces => 'الأدوار والكرات الثابتة';

  @override
  String get tacticsRolesSetPiecesBlurb =>
      'امنح كل لاعب أساسي دورًا. اضغط على شارة ركلة الجزاء (⚽) أو الركلة الحرة (▲) لتحديد المنفذ.';

  @override
  String get tacticsTooltipCallUps => 'الاستدعاءات';

  @override
  String get tacticsTooltipPresets => 'الخطط المحفوظة';

  @override
  String get tacticsTooltipInstructions => 'التعليمات';

  @override
  String get tacticsNoTacticSet => 'لم تُحدَّد أي خطة.';

  @override
  String tacticsReplaceStarters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'استبدل $count لاعب أساسي',
      many: 'استبدل $count لاعبًا أساسيًا',
      few: 'استبدل $count لاعبين أساسيين',
      two: 'استبدل لاعبَين أساسيَّين',
      one: 'استبدل لاعبًا أساسيًا واحدًا',
      zero: 'استبدل $count أساسيين',
    );
    return '$_temp0';
  }

  @override
  String tacticsPlayerOut(String name, String reason) {
    return '⁦$name: $reason⁩';
  }

  @override
  String get tacticsOut => 'غائب';

  @override
  String get tacticsTapSpotReplace => 'اضغط على مركزه في الملعب لاختيار بديل.';

  @override
  String get tacticsTapOrDrag =>
      'اضغط على لاعب لاستبداله، أو اضغط مطولًا واسحبه لنقله.';

  @override
  String get tacticsPlayerRoles => 'أدوار اللاعبين';

  @override
  String get tacticsRolesBlurb =>
      'امنح اللاعب مهمة: قناص، صانع ألعاب، مهاجم محوري. تحدد الأدوار من يسجل ومن يصنع.';

  @override
  String get tacticsSetPieceTakers => 'منفذو الكرات الثابتة';

  @override
  String get tacticsSetPieceBlurb =>
      'من يسدد ركلات الجزاء والكرات الثابتة، أو اترك الأمر للاعب الأنسب.';

  @override
  String get tacticsTakerAuto => 'تلقائي';

  @override
  String get tacticsTakerQuickPick => 'استخدم أفضل المنفذين';

  @override
  String get tacticsPenalties => 'ركلات الجزاء';

  @override
  String get tacticsCornersFreeKicks => 'الركلات الركنية والحرة';

  @override
  String get tacticsThrowIns => 'رميات التماس';

  @override
  String get tacticsThrowInStyle => 'أسلوب رميات التماس';

  @override
  String get tacticsThrowInLong => 'رميات طويلة';

  @override
  String get tacticsThrowInNeutral => 'محايد';

  @override
  String get tacticsThrowInDefensive => 'رميات آمنة';

  @override
  String get tacticsThrowInLongBlurb =>
      'الرميات القريبة من المنطقة تُرسل إليها. خطورة إضافية قليلة، تزيد مع رامٍ قوي ومهاجمين طوال، لكن الكرة تضيع أكثر قليلًا.';

  @override
  String get tacticsThrowInNeutralBlurb =>
      'تُنفَّذ الرميات حسب مجريات اللعب. لا شيء يتغير.';

  @override
  String get tacticsThrowInDefensiveBlurb =>
      'كل رمية قصيرة وآمنة. كرات مفقودة أقل تُستغل في المرتدات، وفرص أقل قليلًا.';

  @override
  String get matchGoalLongThrow => 'رمية تماس طويلة';

  @override
  String get tacticsSkillFin => 'إنهاء';

  @override
  String get tacticsSkillPas => 'تمرير';

  @override
  String tacticsRolePlayer(String name) {
    return 'الدور · $name';
  }

  @override
  String get roleFitGood => 'مناسب جدًا';

  @override
  String get roleFitFair => 'مناسب نوعًا ما';

  @override
  String get roleFitPoor => 'غير مناسب';

  @override
  String get arrowNone => 'ثبات في المركز';

  @override
  String get arrowForward => 'التقدم للأمام';

  @override
  String get arrowBack => 'التراجع للخلف';

  @override
  String get arrowInside => 'الدخول للعمق';

  @override
  String get arrowOutside => 'البقاء على الطرف';

  @override
  String get arrowForwardInside => 'للأمام وللعمق';

  @override
  String get arrowForwardOutside => 'للأمام وعلى الطرف';

  @override
  String get tacticsRunLegendRole => 'الانطلاقة الطبيعية للدور';

  @override
  String get tacticsRunLegendManual => 'تعليماتك';

  @override
  String get tacticsPitchPlanHint =>
      'اضغط على شارة اللاعب لتحديد دوره، وعلى سهمه لتحديد انطلاقته.';

  @override
  String tacticsRoleBadgeSemantics(String role) {
    return 'الدور: $role. اضغط للتغيير.';
  }

  @override
  String tacticsRunMarkSemantics(String run) {
    return 'الانطلاقة: $run. اضغط للتغيير.';
  }

  @override
  String get tacticsPlanRoleHeading => 'الدور';

  @override
  String get tacticsPlanMovementHeading => 'التحرك';

  @override
  String tacticsPlanTitle(String position, String name) {
    return '$position · $name';
  }

  @override
  String tacticsArrowSet(String name, String movement) {
    return '⁦$name: $movement⁩';
  }

  @override
  String get tacticsKeeperNoRun => 'لا انطلاقة لحارس المرمى.';

  @override
  String get tacticsPenaltyTaker => 'منفذ ركلات الجزاء';

  @override
  String get tacticsCornerFreeKickTaker => 'منفذ الركنيات والركلات الحرة';

  @override
  String get tacticsAutomatic => 'تلقائي';

  @override
  String get tacticsLetBestSuited => 'دع اللاعب الأنسب ينفذها.';

  @override
  String get tacticsInXi => 'أساسي';

  @override
  String get tacticsTeamInstructions => 'تعليمات الفريق';

  @override
  String get tacticsTeamInstructionsBlurb =>
      'حدد أسلوب لعب فريقك. كل مؤشر يؤثر قليلًا في الفريق كله.';

  @override
  String tacticsSavedPreset(String name) {
    return 'تم حفظ «$name»';
  }

  @override
  String tacticsAppliedPreset(String name) {
    return 'تم تطبيق «$name»';
  }

  @override
  String get tacticsTacticPresets => 'الخطط المحفوظة';

  @override
  String get tacticsPresetsBlurb =>
      'احفظ هذه الخطة كأسلوب قابل لإعادة الاستخدام، أو طبّق خطة حفظتها سابقًا.';

  @override
  String get tacticsSaveCurrentTactic => 'احفظ الخطة الحالية';

  @override
  String tacticsCouldNotLoadPresets(String error) {
    return 'تعذّر تحميل الخطط المحفوظة.\n$error';
  }

  @override
  String get tacticsNoPresetsYet =>
      'لا خطط محفوظة بعد. اضغط «احفظ الخطة الحالية» لتخزين هذا الإعداد كأسلوب قابل لإعادة الاستخدام.';

  @override
  String get tacticsNameThisTactic => 'سمِّ هذه الخطة';

  @override
  String get tacticsNameHint => 'مثلًا: ضغط عالٍ 4-3-3';

  @override
  String get tacticsCancel => 'إلغاء';

  @override
  String get tacticsSave => 'حفظ';

  @override
  String get tacticsTapToAssign => 'اضغط للتعيين';

  @override
  String get tacticsHoldDragSub =>
      'اضغط مطولًا على بديل ثم اسحبه فوق لاعب لإدخاله.';

  @override
  String get hubContinue => 'متابعة';

  @override
  String get hubBrackets => 'الأدوار الإقصائية';

  @override
  String hubCouldNotLoad(String error) {
    return 'تعذّر التحميل.\n$error';
  }

  @override
  String hubCouldNotLoadFinances(String error) {
    return 'تعذّر تحميل الماليات.\n$error';
  }

  @override
  String hubCouldNotLoadSave(String error) {
    return 'تعذّر تحميل ملف الحفظ.\n$error';
  }

  @override
  String get hubSaveNotFound => 'لم يُعثر على ملف الحفظ.';

  @override
  String get hubUnknown => 'غير معروف';

  @override
  String hubWorldChampionsYear(int year) {
    return 'أبطال العالم $year';
  }

  @override
  String get hubCycleComplete => 'اكتملت الدورة.';

  @override
  String hubReviewTitle(int from, int to) {
    return 'حصاد دورة ⁦$from–$to⁩';
  }

  @override
  String get hubReviewEyebrow => 'سنواتك الأربع';

  @override
  String get hubReviewTournaments => 'البطولات';

  @override
  String get hubReviewPlayers => 'اللاعبون';

  @override
  String get hubReviewMostCaps => 'الأكثر مشاركة';

  @override
  String get hubReviewBestRated => 'أفضل متوسط تقييم';

  @override
  String hubReviewDebutants(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count لاعب خاضوا مباراتهم الدولية الأولى',
      many: '$count لاعبًا خاضوا مباراتهم الدولية الأولى',
      few: '$count لاعبين خاضوا مباراتهم الدولية الأولى',
      two: 'لاعبان خاضا مباراتهما الدولية الأولى',
      one: 'لاعب واحد خاض مباراته الدولية الأولى',
      zero: 'لم يخض أي لاعب مباراته الدولية الأولى',
    );
    return '$_temp0';
  }

  @override
  String hubReviewRankMove(int from, int to) {
    return 'من المركز $from إلى المركز $to';
  }

  @override
  String hubReviewObjectives(int met, int total) {
    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: 'تحقق $met من $total هدف للمجلس',
      many: 'تحقق $met من $total هدفًا للمجلس',
      few: 'تحقق $met من $total أهداف للمجلس',
      two: 'تحقق $met من هدفين للمجلس',
      one: 'تحقق $met من هدف واحد للمجلس',
      zero: 'تحقق $met من $total أهداف المجلس',
    );
    return '$_temp0';
  }

  @override
  String get hubReviewNoMatches => 'لم تُلعب أي مباراة في هذه الدورة.';

  @override
  String get hubYourJob => 'وظيفتك';

  @override
  String get hubStayProject => 'ابقَ وواصل مشروعك';

  @override
  String get hubChooseNextJob => 'اختر وظيفتك التالية';

  @override
  String get hubOffersOnTable => 'العروض المطروحة';

  @override
  String hubOfferSubtitle(String tier, int position) {
    return '$tier · المركز العالمي $position';
  }

  @override
  String hubContinueWith(String nation) {
    return 'واصل مع $nation';
  }

  @override
  String get hubYourNation => 'منتخبك';

  @override
  String get hubTakeTheJob => 'اقبل الوظيفة';

  @override
  String get hubFederationFinances => 'ماليات الاتحاد';

  @override
  String get hubBudgetIntro =>
      'مهمتك الأولى في الدورة القادمة هي تحديد ميزانية الاتحاد وتوزيعها على الأقسام.';

  @override
  String get hubStarting => 'جارٍ البدء…';

  @override
  String get hubBeginNextCycle => 'ابدأ الدورة التالية';

  @override
  String get hubContinueCareer => 'واصل مسيرتك';

  @override
  String get hubBackToSaves => 'العودة إلى ملفات الحفظ';

  @override
  String get hubOpeningBalance => 'الرصيد الافتتاحي';

  @override
  String get hubCentralFunding => 'التمويل المركزي';

  @override
  String get hubPrizeMoney => 'الجوائز المالية';

  @override
  String get hubCommercialReturn => 'العائد التجاري';

  @override
  String get hubAvailableToInvest => 'المتاح للاستثمار';

  @override
  String hubReputation(String label, int rep) {
    return 'السمعة: $label ($rep)';
  }

  @override
  String get hubNationalHero => 'بطل قومي';

  @override
  String get hubFinal => 'النهائي';

  @override
  String get hubStageRoundOf32 => 'دور الـ32';

  @override
  String get hubStageThirdPlace => 'مباراة المركز الثالث';

  @override
  String get hubEventAdvanceWorld => 'تقدّم بالعالم';

  @override
  String hubEventStartCycle(int year) {
    return 'ابدأ دورة $year';
  }

  @override
  String hubEventWorldChampions(String nation) {
    return '$nation بطل العالم';
  }

  @override
  String get hubEventSetBudget => 'حدد ميزانية الاتحاد';

  @override
  String get hubEventSetBudgetSub =>
      'وزّع ميزانية هذه الدورة قبل انطلاق الموسم';

  @override
  String get hubEventNaturalization => 'راجع عرض التجنيس';

  @override
  String get hubEventNaturalizationSub =>
      'لاعب أجنبي يريد تغيير جنسيته الرياضية لصالحك';

  @override
  String get hubEventCampaignVerdict => 'حُسمت الحملة: اطّلع على الحكم';

  @override
  String get hubEventCampaignComplete => 'اكتملت الحملة';

  @override
  String get hubEventIntercontinentalPlayoff => 'الملحق العابر للقارات';

  @override
  String get hubEventWatchWcDraw => 'شاهد قرعة بطولة العالم';

  @override
  String get hubEventWorldCupHere => 'بطولة العالم انطلقت';

  @override
  String get hubEventWatchFinalsDraw => 'شاهد قرعة النهائيات';

  @override
  String get hubEventFinalsHere => 'النهائيات انطلقت';

  @override
  String get hubEventPlayWcRound => 'العب الجولة التالية من بطولة العالم';

  @override
  String hubEventPlayCupMatch(String cup) {
    return 'العب المباراة التالية في $cup';
  }

  @override
  String get hubEventPlayNationsCupMatch =>
      'العب المباراة التالية في كأس الأمم';

  @override
  String get hubEventWatchNationsCupDraw => 'شاهد قرعة كأس الأمم';

  @override
  String get hubEventWatchHostSelection => 'شاهد اختيار المستضيف';

  @override
  String get hubEventWatchQualifyingDraw => 'شاهد قرعة التصفيات';

  @override
  String get hubEventWatchWcHostSelection => 'شاهد اختيار مستضيف بطولة العالم';

  @override
  String get hubEventWatchWcQualifyingDraw => 'شاهد قرعة تصفيات بطولة العالم';

  @override
  String get hubEventArrangeFriendlies => 'رتّب مباريات ودية';

  @override
  String hubEventFriendliesSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'لم تملأ نوافذك الودية الـ$count المفتوحة بعد',
      many: 'لم تملأ نوافذك الودية الـ$count المفتوحة بعد',
      few: 'لم تملأ نوافذك الودية الـ$count المفتوحة بعد',
      two: 'لم تملأ نافذتيك الوديتين المفتوحتين بعد',
      one: 'لم تملأ نافذتك الودية المفتوحة بعد',
      zero: 'لا نوافذ ودية مفتوحة',
    );
    return '$_temp0';
  }

  @override
  String get hubEventReshapeXi => 'أعد تشكيل التشكيلة الأساسية';

  @override
  String hubEventReshapeOutSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count لاعب من تشكيلتك غائبون (موقوفون أو مصابون). اختر بدلاءهم',
      many: '$count لاعبًا من تشكيلتك غائبون (موقوفون أو مصابون). اختر بدلاءهم',
      few: '$count لاعبين من تشكيلتك غائبون (موقوفون أو مصابون). اختر بدلاءهم',
      two: 'لاعبان من تشكيلتك غائبان (موقوفان أو مصابان). اختر بديليهما',
      one: 'لاعب من تشكيلتك غائب (موقوف أو مصاب). اختر بديله',
      zero: 'لا أحد من تشكيلتك غائب',
    );
    return '$_temp0';
  }

  @override
  String hubEventReshapeShortSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تشكيلتك الأساسية ناقصة. املأ المراكز الشاغرة',
      many: 'تشكيلتك الأساسية ناقصة. املأ المراكز الشاغرة',
      few: 'تشكيلتك الأساسية ناقصة. املأ المراكز الشاغرة',
      two: 'تشكيلتك الأساسية ناقصة. املأ المركزين الشاغرين',
      one: 'تشكيلتك الأساسية ناقصة. املأ المركز الشاغر',
      zero: 'تشكيلتك الأساسية مكتملة',
    );
    return '$_temp0';
  }

  @override
  String hubEventPlayOpponent(String opponent) {
    return 'العب ضد $opponent';
  }

  @override
  String get hubEventContinentalFinalsFallback => 'النهائيات القارية';

  @override
  String get hubCallUpFriendlies => 'سمِّ قائمتك للمباريات الودية';

  @override
  String get hubCallUpRequalify => 'أعد تسمية قائمة التصفيات';

  @override
  String get hubCallUpWorldCup => 'سمِّ قائمتك لبطولة العالم';

  @override
  String get hubCallUpFinals => 'سمِّ قائمتك للنهائيات';

  @override
  String get hubCallUpNationsCup => 'سمِّ قائمتك لكأس الأمم';

  @override
  String get hubCallUpQualifying => 'سمِّ قائمتك للتصفيات';

  @override
  String get hubCallUpGeneric => 'سمِّ قائمتك';

  @override
  String get hubHost => 'المستضيف';

  @override
  String get hubGoldenBoot => 'الهداف';

  @override
  String hubGoldenBootValue(String name, int goals) {
    String _temp0 = intl.Intl.pluralLogic(
      goals,
      locale: localeName,
      other: '$goals هدف',
      many: '$goals هدفًا',
      few: '$goals أهداف',
      two: 'هدفان',
      one: 'هدف واحد',
      zero: '$goals هدف',
    );
    return '$name · $_temp0';
  }

  @override
  String get hubPens => '(ترجيح)';

  @override
  String get hubNationalHub => 'المركز الوطني';

  @override
  String get hubMessages => 'الرسائل';

  @override
  String get hubWorldChampions => 'أبطال العالم';

  @override
  String get hubViewBracket => 'عرض الأدوار الإقصائية ‹';

  @override
  String get hubBoardDelighted => 'مسرور جدًا';

  @override
  String get hubBoardPleased => 'راضٍ';

  @override
  String get hubBoardExpectingMore => 'ينتظر المزيد';

  @override
  String get hubBoardConcerned => 'قلق';

  @override
  String get hubBoardJobAtRisk => 'الوظيفة في خطر';

  @override
  String get boardRemarkNoted =>
      'يحيط المجلس علمًا بالنتيجة. تقييمه للدورة لم يتغير.';

  @override
  String get boardRemarkEncouraged => 'يرحب المجلس بنتيجة أمام منافس أقوى.';

  @override
  String get boardRemarkExpected =>
      'كانت الهزيمة أمام منافس أقوى متوقعة. تقييم المجلس لم يتغير.';

  @override
  String get boardRemarkConcerned => 'أحاط المجلس علمًا بالهزيمة وينتظر ردًا.';

  @override
  String get hubBoard => 'مجلس الإدارة';

  @override
  String get hubFunds => 'الأموال';

  @override
  String hubBoardObjective(String label) {
    return 'هدف المجلس: $label';
  }

  @override
  String hubObjectiveMet(String result) {
    return 'تحقق · $result';
  }

  @override
  String hubObjectiveMissed(String result) {
    return 'لم يتحقق · $result';
  }

  @override
  String get hubNoMoreFixtures => 'لا مباريات أخرى في هذه الدورة.';

  @override
  String get hubVs => 'ضد';

  @override
  String hubWorldRank(int rank) {
    return '#$rank';
  }

  @override
  String get hubWorldRankLabel => 'التصنيف العالمي';

  @override
  String get hubSquadStatus => 'حالة الفريق';

  @override
  String hubPlayers(int count) {
    return '$count لاعب';
  }

  @override
  String get hubAvgRating => 'متوسط التقييم';

  @override
  String get hubMorale => 'المعنويات';

  @override
  String get hubManageTeam => 'إدارة الفريق';

  @override
  String get hubGroupsToBeDrawn =>
      'المجموعات لم تُسحب بعد. شاهد القرعة لكشفها.';

  @override
  String hubGroupName(String name) {
    return 'المجموعة $name';
  }

  @override
  String get hubTblTeam => 'الفريق';

  @override
  String get hubTblP => 'لعب';

  @override
  String get hubTblGd => 'فارق';

  @override
  String get hubTblPts => 'نقاط';

  @override
  String get homeSettings => 'الإعدادات';

  @override
  String get homeLeadTheNation => 'قُد المنتخب';

  @override
  String get homeYourNation => 'منتخبك';

  @override
  String get homeNewGame => 'لعبة جديدة';

  @override
  String get homeAllSaves => 'كل ملفات الحفظ';

  @override
  String get homeLoadGame => 'تحميل لعبة';

  @override
  String get homeContinue => 'متابعة';

  @override
  String homeRoadToWorldCup(String date, int year) {
    return '$date · الطريق إلى بطولة العالم $year';
  }

  @override
  String get careerManageSaves => 'إدارة ملفات الحفظ';

  @override
  String get careerNewGameTitle => 'لعبة جديدة';

  @override
  String careerCouldNotLoadNation(String error) {
    return 'تعذّر تحميل المنتخب.\n$error';
  }

  @override
  String get careerNationNotFound => 'لم يُعثر على المنتخب.';

  @override
  String careerWorldRankNum(int rank) {
    return 'التصنيف العالمي #$rank';
  }

  @override
  String get careerManagerName => 'اسم المدرب';

  @override
  String get careerManagerNameHint => 'مثلًا: مارتن';

  @override
  String get careerBeginsBlurb =>
      'تبدأ مسيرتك في سبتمبر 2026، على طريق بطولة العالم 2030.';

  @override
  String get careerFreeCycleNote =>
      'مجانًا لدورة كاملة مدتها أربع سنوات: التصفيات، وبطولتك القارية، وبطولة العالم، على ملفَّي حفظ. بعدها، دفعة واحدة تفتح دورات لا تنتهي.';

  @override
  String get careerStartCareer => 'ابدأ المسيرة';

  @override
  String get careersTitle => 'المسيرات';

  @override
  String get careerManagerCareer => 'مسيرة المدرب';

  @override
  String get careerManagerCareerSubtitle => 'كل دورة أدرتها وسجلك الإجمالي';

  @override
  String get careerSummaryTitle => 'ملخص المسيرة';

  @override
  String get careerSummarySubtitle => 'خزانة ألقابك وسجلك كمدرب';

  @override
  String get careerAchievements => 'الإنجازات';

  @override
  String get careerAchievementsSubtitle => 'المحطات والألقاب ورضا المجلس';

  @override
  String get careerChallenges => 'التحديات';

  @override
  String get careerChallengesSubtitle => 'اختبارات قاسية تمتد طوال المسيرة';

  @override
  String get careerTeamRecords => 'أرقام الفريق';

  @override
  String get careerTeamRecordsSubtitle => 'الهدافون والأكثر مشاركة تاريخيًا';

  @override
  String get careerMyMatches => 'مبارياتي';

  @override
  String get careerMyMatchesSubtitle => 'كل النتائج والمباريات القادمة';

  @override
  String get careerTitle => 'المسيرة';

  @override
  String careerCouldNotLoadCareer(String error) {
    return 'تعذّر تحميل المسيرة.\n$error';
  }

  @override
  String get careerNoCareer => 'لا توجد مسيرة.';

  @override
  String get careerTrophyCabinet => 'خزانة الألقاب';

  @override
  String get careerTournamentHistory => 'سجل البطولات';

  @override
  String get careerNoTournamentsYet => 'لم تكتمل أي بطولة بعد.';

  @override
  String get careerTeamFallback => 'الفريق';

  @override
  String careerWorldNum(int rank) {
    return 'العالم #$rank';
  }

  @override
  String careerPointsNum(int points) {
    return '$points نقطة';
  }

  @override
  String careerSeasonNum(int season) {
    return 'الموسم $season';
  }

  @override
  String get careerStatPlayedShort => 'لعب';

  @override
  String get careerStatsHeading => 'بالأرقام';

  @override
  String get careerStatsWinRate => 'نسبة الفوز';

  @override
  String get careerStatsGoalsFor => 'الأهداف المسجلة';

  @override
  String get careerStatsGoalsAgainst => 'الأهداف المستقبلة';

  @override
  String get careerStatsGoalDiff => 'فارق الأهداف';

  @override
  String get careerStatsCleanSheets => 'شباك نظيفة';

  @override
  String get careerStatsBiggestWin => 'أكبر فوز';

  @override
  String get careerStatsWinStreak => 'سلسلة انتصارات';

  @override
  String get careerStatsUnbeaten => 'سلسلة دون هزيمة';

  @override
  String get careerStatsShootouts => 'ركلات الترجيح';

  @override
  String get careerStatsHatTricks => 'الهاتريك';

  @override
  String get careerStatsMotms => 'رجل المباراة';

  @override
  String get careerStatsBestRating => 'أفضل تقييم';

  @override
  String get careerStatWonShort => 'ف';

  @override
  String get careerStatDrawnShort => 'ت';

  @override
  String get careerStatLostShort => 'خ';

  @override
  String get careerStatGoalsForShort => 'له';

  @override
  String get careerStatGoalsAgainstShort => 'عليه';

  @override
  String get careerStatGoalDiffShort => 'فارق';

  @override
  String get careerNoSilverware => 'لا ألقاب بعد. اذهب واظفر بواحد.';

  @override
  String get careerMedalGold => 'ذهبية';

  @override
  String get careerMedalSilver => 'فضية';

  @override
  String get careerMedalBronze => 'برونزية';

  @override
  String careerWinnersName(String name) {
    return 'الفائز: $name';
  }

  @override
  String get careerSavesTitle => 'ملفات الحفظ';

  @override
  String careerCouldNotLoadSaves(String error) {
    return 'تعذّر تحميل ملفات الحفظ.\n$error';
  }

  @override
  String careerSlotsCount(int used, int limit) {
    return 'الخانات  ⁦$used/$limit⁩';
  }

  @override
  String get careerThisSave => 'هذا الحفظ';

  @override
  String get careerSlotsFull => 'الخانات ممتلئة';

  @override
  String careerSlotsUsed(int used) {
    return 'الخانات  $used';
  }

  @override
  String get careerSlotsUnlockMore => 'افتح المزيد من ملفات الحفظ';

  @override
  String get careerSlotsKeepNote =>
      'كل ملف حفظ لديك يبقى قابلًا للعب. الملف الجديد فقط يحتاج إلى الفتح.';

  @override
  String get careerNewGame => 'لعبة جديدة';

  @override
  String get careerDeleteSaveTitle => 'حذف ملف الحفظ؟';

  @override
  String careerDeleteSaveBody(String label) {
    return 'سيؤدي هذا إلى حذف مسيرتك $label نهائيًا.';
  }

  @override
  String get careerCancel => 'إلغاء';

  @override
  String get careerDelete => 'حذف';

  @override
  String get careerNoSavesYet =>
      'لا ملفات حفظ بعد.\nابدأ لعبة جديدة لتقود منتخبًا.';

  @override
  String get careerUnknownNation => 'غير معروف';

  @override
  String careerPlayedMinutes(int minutes) {
    return '$minutes د';
  }

  @override
  String careerPlayedHours(int hours, int minutes) {
    return '$hours س $minutes د';
  }

  @override
  String careerLastPlayed(String when) {
    return 'آخر لعب $when';
  }

  @override
  String get careerJustNow => 'الآن';

  @override
  String get careerYesterday => 'أمس';

  @override
  String careerMinutesAgo(int n) {
    return 'قبل $n د';
  }

  @override
  String careerHoursAgo(int n) {
    return 'قبل $n س';
  }

  @override
  String careerDaysAgo(int n) {
    return 'قبل $n يوم';
  }

  @override
  String careerRoadToWorldCup(int year) {
    return 'الطريق إلى بطولة العالم $year';
  }

  @override
  String homeNextFixture(String match, String when) {
    return 'التالية: $match، $when';
  }

  @override
  String homeCycleComplete(int year) {
    return 'انتهت بطولة العالم $year. حكم المجلس هو التالي.';
  }

  @override
  String homeFollowingFinals(int year) {
    return 'متابعة بطولة العالم $year';
  }

  @override
  String get careerManagerCareerTitle => 'مسيرة المدرب';

  @override
  String careerCouldNotLoad(String error) {
    return 'تعذّر التحميل.\n$error';
  }

  @override
  String get careerCycleByCycle => 'دورة بدورة';

  @override
  String careerCyclesNationsLed(int cycles, int nations) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles دورة',
      many: '$cycles دورة',
      few: '$cycles دورات',
      two: 'دورتان',
      one: 'دورة واحدة',
      zero: '$cycles دورة',
    );
    String _temp1 = intl.Intl.pluralLogic(
      nations,
      locale: localeName,
      other: 'قاد $nations منتخب',
      many: 'قاد $nations منتخبًا',
      few: 'قاد $nations منتخبات',
      two: 'قاد منتخبين',
      one: 'قاد منتخبًا واحدًا',
      zero: '$nations منتخب',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get careerStatTitles => 'الألقاب';

  @override
  String get careerStatPlayed => 'لعب';

  @override
  String get careerStatWon => 'فاز';

  @override
  String get careerStatDrawn => 'تعادل';

  @override
  String get careerStatLost => 'خسر';

  @override
  String careerGoalsWinRate(
    int goalsFor,
    int goalsAgainst,
    String gd,
    int winRate,
  ) {
    return 'الأهداف ⁦$goalsFor–$goalsAgainst⁩  ($gd)  ·  نسبة الفوز $winRate%';
  }

  @override
  String get careerRecordResults => 'النتائج القياسية';

  @override
  String get careerBestWin => 'أفضل فوز';

  @override
  String get careerWorstDefeat => 'أسوأ هزيمة';

  @override
  String careerVsOpponentDate(String opponent, String date) {
    return 'ضد $opponent · $date';
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
    return 'ف$won ت$drawn خ$lost  ·  له $goalsFor عليه $goalsAgainst ($gd)';
  }

  @override
  String get careerWorldCupLabel => 'بطولة العالم';

  @override
  String get careerContinentalLabel => 'القارية';

  @override
  String get messagesTitle => 'الرسائل';

  @override
  String get messagesNoMessagesYet => 'لا رسائل بعد.';

  @override
  String messagesCouldNotLoad(String error) {
    return 'تعذّر تحميل الرسائل.\n$error';
  }

  @override
  String get messagesDone => 'تم';

  @override
  String get messagesNext => 'التالي';

  @override
  String get rankingWorldRanking => 'التصنيف العالمي';

  @override
  String rankingCouldNotLoad(String error) {
    return 'تعذّر تحميل التصنيف.\n$error';
  }

  @override
  String get rankingNoRanking => 'لا يوجد تصنيف.';

  @override
  String get rankingAll => 'الكل';

  @override
  String get rankingYourTeam => 'فريقك';

  @override
  String get rankingYourRankingOverTime => 'تصنيفك عبر الزمن';

  @override
  String rankingNowRank(int rank) {
    return 'الآن #$rank';
  }

  @override
  String rankingBestWorst(int best, int worst) {
    return 'الأفضل #$best · الأسوأ #$worst';
  }

  @override
  String get friendliesTitle => 'المباريات الودية';

  @override
  String friendliesLoadError(String error) {
    return 'تعذّر تحميل المباريات الودية.\n$error';
  }

  @override
  String get friendliesContinue => 'متابعة';

  @override
  String friendliesArrangeIntro(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count نافذة مفتوحة',
      many: '$count نافذة مفتوحة',
      few: '$count نوافذ مفتوحة',
      two: 'نافذتين مفتوحتين',
      one: 'نافذة مفتوحة واحدة',
      zero: '$count نافذة مفتوحة',
    );
    return 'رتّب مباريات تحضيرية لـ$_temp0 قبل مباراتك الرسمية التالية. اضغط على منافس، أو اتركها فارغة.';
  }

  @override
  String get friendliesFree => 'فارغة';

  @override
  String matchGoalsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count هدف',
      many: '$count هدفًا',
      few: '$count أهداف',
      two: 'هدفان',
      one: 'هدف واحد',
      zero: '$count هدف',
    );
    return '$_temp0';
  }

  @override
  String get matchGoalsTitle => 'الأهداف';

  @override
  String get matchGoalsNone => 'لا أهداف';

  @override
  String get matchGoalPenalty => 'جزاء';

  @override
  String get matchGoalSetPiece => 'ثابتة';

  @override
  String matchGoalAssist(String name) {
    return 'صناعة $name';
  }

  @override
  String get friendliesHome => 'على أرضنا';

  @override
  String get friendliesAway => 'خارج أرضنا';

  @override
  String get friendliesNoneThisWindow => 'لا مباريات ودية في هذه النافذة';

  @override
  String friendliesConfirmCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'أكّد $count مباراة ودية',
      many: 'أكّد $count مباراة ودية',
      few: 'أكّد $count مباريات ودية',
      two: 'أكّد مباراتين وديتين',
      one: 'أكّد مباراة ودية واحدة',
      zero: 'أكّد $count مباراة ودية',
    );
    return '$_temp0';
  }

  @override
  String get friendliesMonthJan => 'يناير';

  @override
  String get friendliesMonthFeb => 'فبراير';

  @override
  String get friendliesMonthMar => 'مارس';

  @override
  String get friendliesMonthApr => 'أبريل';

  @override
  String get friendliesMonthMay => 'مايو';

  @override
  String get friendliesMonthJun => 'يونيو';

  @override
  String get friendliesMonthJul => 'يوليو';

  @override
  String get friendliesMonthAug => 'أغسطس';

  @override
  String get friendliesMonthSep => 'سبتمبر';

  @override
  String get friendliesMonthOct => 'أكتوبر';

  @override
  String get friendliesMonthNov => 'نوفمبر';

  @override
  String get friendliesMonthDec => 'ديسمبر';

  @override
  String get resultsMyMatches => 'مبارياتي';

  @override
  String resultsCouldNotLoad(String error) {
    return 'تعذّر تحميل النتائج.\n$error';
  }

  @override
  String get resultsNoFixtures => 'لا مباريات.';

  @override
  String get resultsVs => 'ضد';

  @override
  String get resultsStageQualifier => 'تصفيات';

  @override
  String get resultsStageFriendly => 'ودية';

  @override
  String get resultsStageGroupStage => 'دور المجموعات';

  @override
  String get resultsStageSemiFinal => 'نصف النهائي';

  @override
  String get resultsStageFinal => 'النهائي';

  @override
  String get resultsStageContinentalClash => 'صدام القارات';

  @override
  String get resultsStageFinalsGroup => 'مجموعة النهائيات';

  @override
  String get resultsStageRoundOf32 => 'دور الـ32';

  @override
  String get resultsStageRoundOf16 => 'دور الـ16';

  @override
  String get resultsStageQuarterFinal => 'ربع النهائي';

  @override
  String get resultsStageThirdPlace => 'المركز الثالث';

  @override
  String get matchSetupWarnCaptain =>
      'لم يُعيَّن قائد. اضغط لمنح أحدهم شارة القيادة';

  @override
  String matchSetupWarnCaptainInjured(String name) {
    return '$name مصاب ولا يمكنه قيادة الفريق في هذه المباراة. اضغط لنقل الشارة';
  }

  @override
  String matchSetupWarnCaptainSuspended(String name) {
    return '$name موقوف في هذه المباراة. اضغط لنقل الشارة';
  }

  @override
  String matchSetupWarnCaptainDropped(String name) {
    return '$name يحمل الشارة لكنه ليس في قائمتك. اضغط لنقلها';
  }

  @override
  String get matchSetupWarnSetPieces =>
      'لم يُعيَّن منفذو الكرات الثابتة. اضغط لاختيار من يتقدم';

  @override
  String get matchSetupWarnBoth =>
      'لا قائد ولا منفذو كرات ثابتة. اضغط لتعيينهم';

  @override
  String matchStageMatchday(int matchday) {
    return 'الجولة $matchday';
  }

  @override
  String get squadCaptain => 'القائد';

  @override
  String deptEffectYouth(int points) {
    return 'مواهب الأكاديمية تصل بتقييم عام أفضل بنحو $points';
  }

  @override
  String deptEffectCommercial(String amount) {
    return '$amount تعود عند ختام الدورة';
  }

  @override
  String deptEffectMedical(int percent) {
    return 'إصابات أقل بنسبة $percent%';
  }

  @override
  String deptEffectNaturalisation(int percent) {
    return 'فرصة $percent% أن يطلب لاعب أجنبي تغيير جنسيته الرياضية';
  }

  @override
  String deptEffectBoard(int points) {
    return '⁦+$points⁩ صبر إضافي للمجلس قبل أن تصبح وظيفتك في خطر';
  }

  @override
  String get deptEffectNone => 'لا تأثير دون تمويل';

  @override
  String get statsBestRated => 'التقييمات';

  @override
  String get statsMyCareer => 'المسيرة';

  @override
  String get statsBestAverageRating => 'أفضل متوسط تقييم';

  @override
  String get statsMyCareerRecord => 'سجلك';

  @override
  String get statsNoRatingsRecorded => 'لم تُسجَّل تقييمات مباريات بعد.';

  @override
  String get statsGroupRecord => 'السجل';

  @override
  String get statsGroupRuns => 'السلاسل';

  @override
  String get statsGroupExtremes => 'الأرقام القصوى';

  @override
  String get statsGroupSplits => 'على أرضنا وخارجها';

  @override
  String get statsGroupSquad => 'لاعبوك';

  @override
  String get statsPlayed => 'المباريات الملعوبة';

  @override
  String get statsWinDrawLoss => 'فوز–تعادل–خسارة';

  @override
  String get statsWinRate => 'نسبة الفوز';

  @override
  String get statsGoals => 'الأهداف له:عليه';

  @override
  String get statsCleanSheets => 'شباك نظيفة';

  @override
  String get statsFailedToScore => 'لم يسجل';

  @override
  String get statsLongestWinStreak => 'أطول سلسلة انتصارات';

  @override
  String get statsLongestUnbeaten => 'أطول سلسلة دون هزيمة';

  @override
  String get statsLongestCleanSheets => 'أطول سلسلة بشباك نظيفة';

  @override
  String get statsLongestWinless => 'أطول سلسلة دون فوز';

  @override
  String get statsCurrentRun => 'السلسلة الحالية دون هزيمة';

  @override
  String get statsBiggestWin => 'أكبر فوز';

  @override
  String get statsHeaviestDefeat => 'أثقل هزيمة';

  @override
  String get statsMostGoalsInAGame => 'أكثر أهداف في مباراة';

  @override
  String get statsShootouts => 'ركلات الترجيح فوز–خسارة';

  @override
  String get statsComebackWins => 'انتصارات بعد التأخر';

  @override
  String get statsHome => 'على أرضنا';

  @override
  String get statsAway => 'خارج أرضنا';

  @override
  String get statsNeutral => 'أرض محايدة';

  @override
  String get statsCompetitive => 'الرسمية';

  @override
  String get statsFriendlies => 'الودية';

  @override
  String get statsHatTricks => 'الهاتريك';

  @override
  String get statsBraces => 'الثنائيات';

  @override
  String get statsMotms => 'جوائز رجل المباراة';

  @override
  String get statsAssists => 'التمريرات الحاسمة';

  @override
  String get statsCards => 'البطاقات';

  @override
  String get statsBestRating => 'أفضل تقييم فردي';

  @override
  String statsAppsShort(int apps) {
    String _temp0 = intl.Intl.pluralLogic(
      apps,
      locale: localeName,
      other: '$apps مباراة',
      many: '$apps مباراة',
      few: '$apps مباريات',
      two: 'مباراتان',
      one: 'مباراة واحدة',
      zero: '$apps مباراة',
    );
    return '$_temp0';
  }

  @override
  String statsMotmShort(int motms) {
    return '$motms رجل المباراة';
  }

  @override
  String get captainArmband => 'ق';

  @override
  String get captainCurrent => 'القائد. اضغط لنزع الشارة';

  @override
  String get captainFitBorn => 'قائد بالفطرة';

  @override
  String get captainFitNatural => 'قائد طبيعي';

  @override
  String get captainFitCapable => 'يمكنه حملها';

  @override
  String get captainFitUnproven => 'ليس قائدًا بعد';

  @override
  String get captainNone => 'لم يُعيَّن قائد';

  @override
  String captainMoraleBoost(int morale) {
    return '⁦+$morale⁩ لمعنويات الفريق';
  }

  @override
  String get viceCaptainFirst => 'نائب القائد الأول';

  @override
  String get viceCaptainSecond => 'نائب القائد الثاني';

  @override
  String get viceCaptainNone => 'لم يُعيَّن نائب قائد';

  @override
  String get viceCaptainHint => 'يحمل الشارة حين لا يستطيع القائد اللعب.';

  @override
  String captainStandIn(String vice, String captain) {
    return 'نائب القائد $vice يقود الفريق؛ القائد $captain غير متاح';
  }

  @override
  String captainStandInUnnamed(String vice) {
    return 'نائب القائد $vice يقود الفريق';
  }

  @override
  String get resultsCategoryWorldCupQualifying => 'تصفيات بطولة العالم';

  @override
  String get resultsCategoryFriendlies => 'المباريات الودية';

  @override
  String get resultsCategoryContinentalClash => 'صدام القارات';

  @override
  String get resultsCategoryNationsCup => 'كأس الأمم';

  @override
  String get resultsCategoryContinentalCup => 'الكأس القارية';

  @override
  String get resultsCategoryWorldCupQualifyingShort => 'تصفيات العالم';

  @override
  String get resultsCategoryContinentalQualifyingShort => 'تصفيات القارة';

  @override
  String get resultsCategoryContinentalQualifying => 'تصفيات الكأس القارية';

  @override
  String get resultsCategoryWorldCupFinals => 'نهائيات بطولة العالم';

  @override
  String get resultsRoundResults => 'نتائج الجولة';

  @override
  String get resultsFriendlyInternationals => 'المباريات الدولية الودية';

  @override
  String get resultsKnockout => 'الأدوار الإقصائية';

  @override
  String resultsEarlierMatches(int count) {
    return 'مباريات سابقة ($count)';
  }

  @override
  String resultsMatchday(int matchday) {
    return 'الجولة $matchday';
  }

  @override
  String get resultsContinue => 'متابعة';

  @override
  String resultsGroup(String name) {
    return 'المجموعة $name';
  }

  @override
  String get achievementsScreenTitle => 'الإنجازات';

  @override
  String get achievementsChallengesTooltip => 'التحديات';

  @override
  String get achievementsChallengesHeading => 'التحديات';

  @override
  String get achievementsBrutalTests => 'اختبارات قاسية تمتد طوال المسيرة';

  @override
  String achievementsCouldNotLoad(String error) {
    return 'تعذّر التحميل.\n$error';
  }

  @override
  String achievementsUnlockedCount(int earned, int total) {
    return '⁦$earned / $total⁩ مفتوحة';
  }

  @override
  String achievementsConqueredCount(int done, int total) {
    return '⁦$done / $total⁩ منجزة';
  }

  @override
  String get achievementsBoardSatisfaction => 'رضا المجلس';

  @override
  String achievementsUnlockedBanner(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count إنجاز جديد',
      many: '$count إنجازًا جديدًا',
      few: '$count إنجازات جديدة',
      two: 'إنجازان جديدان',
      one: 'إنجاز جديد',
      zero: 'لا إنجازات جديدة',
    );
    return '$_temp0';
  }

  @override
  String get achCatWins => 'الانتصارات';

  @override
  String get achCatMatches => 'المباريات';

  @override
  String get achCatQualifications => 'التأهلات';

  @override
  String get achCatTitles => 'الألقاب';

  @override
  String get achCatMisc => 'متنوعة';

  @override
  String get achCatMega => 'الكبرى';

  @override
  String get achCatGoals => 'الأهداف';

  @override
  String get achCatStreaks => 'السلاسل';

  @override
  String get achTierBronze => 'برونزي';

  @override
  String get achTierSilver => 'فضي';

  @override
  String get achTierGold => 'ذهبي';

  @override
  String get achTierPlatinum => 'بلاتيني';

  @override
  String achGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count هدف',
      many: '$count هدفًا',
      few: '$count أهداف',
      two: 'هدفان',
      one: 'هدف واحد',
      zero: '$count هدف',
    );
    return '$_temp0';
  }

  @override
  String achGoalsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'سجّل $count هدف.',
      many: 'سجّل $count هدفًا.',
      few: 'سجّل $count أهداف.',
      two: 'سجّل هدفين.',
      one: 'سجّل هدفًا واحدًا.',
      zero: 'سجّل $count هدف.',
    );
    return '$_temp0';
  }

  @override
  String achCleanSheets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مباراة بشباك نظيفة',
      many: '$count مباراة بشباك نظيفة',
      few: '$count مباريات بشباك نظيفة',
      two: 'مباراتان بشباك نظيفة',
      one: 'شباك نظيفة واحدة',
      zero: '$count شباك نظيفة',
    );
    return '$_temp0';
  }

  @override
  String achCleanSheetsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'حافظ على نظافة شباكك في $count مباراة.',
      many: 'حافظ على نظافة شباكك في $count مباراة.',
      few: 'حافظ على نظافة شباكك في $count مباريات.',
      two: 'حافظ على نظافة شباكك في مباراتين.',
      one: 'حافظ على نظافة شباكك في مباراة واحدة.',
      zero: 'حافظ على نظافة شباكك في $count مباراة.',
    );
    return '$_temp0';
  }

  @override
  String get achStreakWin5 => 'عادة الفوز';

  @override
  String get achStreakWin5Desc => 'افز بخمس مباريات متتالية.';

  @override
  String get achStreakWin10 => 'في أوج العطاء';

  @override
  String get achStreakWin10Desc => 'افز بعشر مباريات متتالية.';

  @override
  String get achStreakWin20 => 'قوة لا تُوقف';

  @override
  String get achStreakWin20Desc => 'افز بعشرين مباراة متتالية.';

  @override
  String get achUnbeaten15 => 'صعب المنال';

  @override
  String get achUnbeaten15Desc => 'العب خمس عشرة مباراة دون هزيمة.';

  @override
  String get achUnbeaten30 => 'لا يُمس';

  @override
  String get achUnbeaten30Desc => 'العب ثلاثين مباراة دون هزيمة.';

  @override
  String get achHattrick => 'بطل الهاتريك';

  @override
  String get achHattrickDesc => 'اجعل لاعبًا يسجل هاتريك.';

  @override
  String get achMotm10 => 'لافت للأنظار';

  @override
  String get achMotm10Desc => 'اجمع 10 جوائز لرجل المباراة.';

  @override
  String get achMotm50 => 'التميمة';

  @override
  String get achMotm50Desc => 'اجمع 50 جائزة لرجل المباراة.';

  @override
  String get achPerfect => 'العشرة الكاملة';

  @override
  String get achPerfectDesc => 'اجعل لاعبًا ينال تقييم 9.5 أو أكثر في مباراة.';

  @override
  String get achShootout => 'أعصاب من جليد';

  @override
  String get achShootoutDesc => 'افز بخمس ركلات ترجيح.';

  @override
  String get achMassacre => 'مجزرة';

  @override
  String get achMassacreDesc => 'افز بمباراة بفارق 7 أهداف أو أكثر.';

  @override
  String get achAnnihilation => 'سحق تام';

  @override
  String get achAnnihilationDesc => 'افز بمباراة بفارق 10 أهداف أو أكثر.';

  @override
  String get chTierBronze => 'برونزي';

  @override
  String get chTierSilver => 'فضي';

  @override
  String get chTierGold => 'ذهبي';

  @override
  String get chTierLegendary => 'أسطوري';

  @override
  String get chFirstSteps => 'على مقعد المدرب';

  @override
  String get chFirstStepsDesc => 'درّب لمدة 5 سنوات.';

  @override
  String get chUnbeaten10 => 'في أوج العطاء';

  @override
  String get chUnbeaten10Desc => 'العب 10 مباريات رسمية دون هزيمة.';

  @override
  String get chTwoNations => 'تحدٍّ جديد';

  @override
  String get chTwoNationsDesc => 'درّب منتخبين مختلفين.';

  @override
  String get chCont1 => 'بطل القارة';

  @override
  String get chCont1Desc => 'افز ببطولة قارية.';

  @override
  String get chNc1 => 'بطل كأس الأمم';

  @override
  String get chNc1Desc => 'افز بكأس الأمم.';

  @override
  String get chWc1 => 'بطل العالم';

  @override
  String get chWc1Desc => 'افز ببطولة العالم.';

  @override
  String get chYears25 => 'من الأعمدة';

  @override
  String get chYears25Desc => 'درّب لمدة 25 عامًا.';

  @override
  String get chWc3 => 'فائز متسلسل';

  @override
  String get chWc3Desc => 'افز ببطولة العالم 3 مرات.';

  @override
  String get chWc5 => 'سلالة حاكمة';

  @override
  String get chWc5Desc => 'افز ببطولة العالم 5 مرات.';

  @override
  String get chWc10 => 'خالد';

  @override
  String get chWc10Desc => 'افز ببطولة العالم 10 مرات.';

  @override
  String get chWc2Teams => 'حقيبة السفر جاهزة';

  @override
  String get chWc2TeamsDesc => 'افز ببطولة العالم مع منتخبين مختلفين.';

  @override
  String get chWc3Teams => 'جوّال العالم';

  @override
  String get chWc3TeamsDesc => 'افز ببطولة العالم مع 3 منتخبات مختلفة.';

  @override
  String get chWcStreak3 => 'الثلاثية المتتالية';

  @override
  String get chWcStreak3Desc => 'افز ببطولة العالم 3 مرات متتالية.';

  @override
  String get chWcAllconf => 'غازي العالم';

  @override
  String get chWcAllconfDesc =>
      'افز ببطولة العالم مع منتخب من كل اتحاد قاري (6).';

  @override
  String get chCont5 => 'ملك القارة';

  @override
  String get chCont5Desc => 'افز بـ5 بطولات قارية.';

  @override
  String get chContAll => 'ست قارات';

  @override
  String get chContAllDesc => 'افز بالبطولة القارية لكل اتحاد قاري (6).';

  @override
  String get chTreble => 'اكتساح شامل';

  @override
  String get chTrebleDesc =>
      'افز ببطولة العالم ولقب قاري وكأس الأمم في مسيرة واحدة.';

  @override
  String get chNations10 => 'الرحّالة';

  @override
  String get chNations10Desc => 'درّب 10 منتخبات مختلفة.';

  @override
  String get chYears100 => 'قرن كامل';

  @override
  String get chYears100Desc => 'درّب لمدة 100 عام.';

  @override
  String get chYears500 => 'نصف ألفية';

  @override
  String get chYears500Desc => 'درّب لمدة 500 عام.';

  @override
  String get chYears1000 => 'أبدي';

  @override
  String get chYears1000Desc => 'درّب لمدة 1000 عام.';

  @override
  String get chGrandmaster => 'الأستاذ الأكبر';

  @override
  String get chGrandmasterDesc => 'افز ببطولة العالم 3 مرات وبـ5 بطولات قارية.';

  @override
  String get chUndefeated => 'لا يُقهر';

  @override
  String get chUndefeatedDesc => 'افز ببطولة العالم دون خسارة أي مباراة.';

  @override
  String get chPerfectQual => 'عبور بلا أخطاء';

  @override
  String get chPerfectQualDesc => 'افز بكل مباريات حملة تصفيات بطولة العالم.';

  @override
  String get chMinnow => 'معجزة الصغار';

  @override
  String get chMinnowDesc =>
      'افز ببطولة العالم مع منتخب خارج أفضل 32 في التصنيف العالمي.';

  @override
  String get chGrandTour => 'ذهابًا وإيابًا';

  @override
  String get chGrandTourDesc =>
      'افز ببطولة العالم مستضيفًا، وافز بها مرة أخرى خارج أرضك.';

  @override
  String get chUnbeaten25 => 'الجدار';

  @override
  String get chUnbeaten25Desc => 'العب 25 مباراة رسمية دون هزيمة.';

  @override
  String get chGoals10k => 'آلة الأهداف';

  @override
  String get chGoals10kDesc => 'سجّل 10,000 هدف في مسيرتك.';

  @override
  String get chCleanSheets500 => 'الحصن';

  @override
  String get chCleanSheets500Desc =>
      'حافظ على نظافة شباكك في 500 مباراة خلال مسيرتك.';

  @override
  String get chHatTricks25 => 'عادة الهاتريك';

  @override
  String get chHatTricks25Desc => 'اجعل لاعبيك يسجلون 25 هاتريك.';

  @override
  String get chWinStreak25 => 'لا يرحم';

  @override
  String get chWinStreak25Desc => 'افز بـ25 مباراة متتالية.';

  @override
  String get chCont10 => 'سلالة قارية';

  @override
  String get chCont10Desc => 'افز بـ10 بطولات قارية.';

  @override
  String get chPcWc => 'بطل متسلسل';

  @override
  String chPcWcDesc(int count) {
    return 'افز ببطولة العالم $count مرات في هذا الحفظ.';
  }

  @override
  String get chPcMajors => 'جامع الألقاب';

  @override
  String chPcMajorsDesc(int count) {
    return 'افز بـ$count ألقاب كبرى (بطولة العالم، أو بطولة قارية، أو كأس الأمم، أو صدام القارات).';
  }

  @override
  String get chPcUnbeaten => 'الجدار الحديدي';

  @override
  String chPcUnbeatenDesc(int count) {
    return 'العب $count مباراة رسمية دون هزيمة.';
  }

  @override
  String get chPcNations => 'المدرب المتنقل';

  @override
  String chPcNationsDesc(int count) {
    return 'درّب $count منتخبات مختلفة.';
  }

  @override
  String get chPcYears => 'المشوار الطويل';

  @override
  String chPcYearsDesc(int count) {
    return 'درّب لمدة $count عامًا.';
  }

  @override
  String achWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count فوز',
      many: '$count فوزًا',
      few: '$count انتصارات',
      two: 'فوزان',
      one: 'فوز واحد',
      zero: '$count فوز',
    );
    return '$_temp0';
  }

  @override
  String achWinsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'افز بـ$count مباراة.',
      many: 'افز بـ$count مباراة.',
      few: 'افز بـ$count مباريات.',
      two: 'افز بمباراتين.',
      one: 'افز بمباراة واحدة.',
      zero: 'افز بـ$count مباراة.',
    );
    return '$_temp0';
  }

  @override
  String achMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مباراة',
      many: '$count مباراة',
      few: '$count مباريات',
      two: 'مباراتان',
      one: 'مباراة واحدة',
      zero: '$count مباراة',
    );
    return '$_temp0';
  }

  @override
  String achMatchesDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'العب $count مباراة.',
      many: 'العب $count مباراة.',
      few: 'العب $count مباريات.',
      two: 'العب مباراتين.',
      one: 'العب مباراة واحدة.',
      zero: 'العب $count مباراة.',
    );
    return '$_temp0';
  }

  @override
  String get achQualWc => 'المتأهل إلى بطولة العالم';

  @override
  String get achQualWcDesc => 'تأهّل إلى بطولة العالم.';

  @override
  String get achQualCont => 'المتأهل القاري';

  @override
  String get achQualContDesc => 'تأهّل إلى بطولتك القارية.';

  @override
  String get achTitleWc => 'أبطال العالم';

  @override
  String get achTitleWcDesc => 'افز ببطولة العالم.';

  @override
  String get achTitleEuro => 'أبطال أوروبا';

  @override
  String get achTitleEuroDesc => 'افز ببطولة أوروبا.';

  @override
  String get achTitleCopa => 'أبطال أمريكا الجنوبية';

  @override
  String get achTitleCopaDesc => 'افز بكأس أمريكا الجنوبية.';

  @override
  String get achTitleAfcon => 'أبطال أفريقيا';

  @override
  String get achTitleAfconDesc => 'افز ببطولة أفريقيا.';

  @override
  String get achTitleAsia => 'أبطال آسيا';

  @override
  String get achTitleAsiaDesc => 'افز ببطولة آسيا.';

  @override
  String get achTitleConcacaf => 'أبطال أمريكا الشمالية';

  @override
  String get achTitleConcacafDesc => 'افز بكأس أمريكا الشمالية.';

  @override
  String get achTitleOfc => 'أبطال أوقيانوسيا';

  @override
  String get achTitleOfcDesc => 'افز بكأس أوقيانوسيا.';

  @override
  String get achTitleNations => 'أبطال كأس الأمم';

  @override
  String get achTitleNationsDesc => 'افز بكأس الأمم.';

  @override
  String get achTitleClash => 'أبطال صدام القارات';

  @override
  String get achTitleClashDesc => 'افز بصدام القارات.';

  @override
  String get achTitleGulf => 'أبطال كأس الواحة';

  @override
  String get achTitleGulfDesc => 'افز بكأس الواحة.';

  @override
  String get achTitleSea => 'أبطال جنوب شرق آسيا';

  @override
  String get achTitleSeaDesc => 'افز ببطولة جنوب شرق آسيا.';

  @override
  String get achMarksman => 'قنّاص بطولة العالم';

  @override
  String get achMarksmanDesc =>
      'اجعل لاعبًا من قائمتك يسجل 6 أهداف أو أكثر في نهائيات بطولة العالم.';

  @override
  String get achSweep => 'اكتساح شامل';

  @override
  String get achSweepDesc =>
      'احمل لقب بطولة العالم ولقبك القاري في مسيرة واحدة.';

  @override
  String get achAllstar => 'نجم البطولة';

  @override
  String get achAllstarDesc =>
      'اجعل لاعبًا يُختار في التشكيلة المثالية لبطولة العالم.';

  @override
  String get achGoldenboot => 'الهداف';

  @override
  String get achGoldenbootDesc => 'اجعل منتخبك يضم هداف إحدى البطولات.';

  @override
  String get achDemolition => 'هدم كامل';

  @override
  String get achDemolitionDesc => 'افز بمباراة بفارق 5 أهداف أو أكثر.';

  @override
  String get achievementsNice => 'رائع!';

  @override
  String get achievementsHardestTests =>
      'أصعب اختبارات المدرب، على امتداد مسيرة كاملة ومنتخبات عديدة.';

  @override
  String get achievementsThisSave => 'هذا الحفظ';

  @override
  String get achievementsBrutalBadge => 'قاسٍ';

  @override
  String get paywallGoPro => 'احصل على الإصدار غير المحدود';

  @override
  String get paywallOneTimeUnlock => 'فتح لمرة واحدة. بلا اشتراك.';

  @override
  String get paywallBenefitCarryOn =>
      'يستمر هذا الحفظ تمامًا من حيث توقف، بكل مباراة دولية وكل رقم قياسي وكل منافسة.';

  @override
  String get paywallBenefitNoAds =>
      'بلا إعلانات، بلا مشتريات صغيرة، بلا اشتراك. دفعة واحدة، والتحديثات مشمولة.';

  @override
  String get paywallBenefitSaves =>
      'ملفات حفظ بقدر ما تريد. أدِر منتخبك المفضل ومنتخبًا صغيرًا في الوقت نفسه، واكتشف كم تختلف اللعبة نفسها.';

  @override
  String get paywallBenefitEndless =>
      'كل الدورات من الآن فصاعدًا. اختر لاعبًا في السابعة عشرة اليوم واعرف في 2034 إن كنت محقًا.';

  @override
  String get paywallUnlocked => 'الإصدار غير المحدود مفتوح. استمتع!';

  @override
  String get paywallContactingStore => 'جارٍ الاتصال بالمتجر…';

  @override
  String paywallUnlockProPriced(String price) {
    return 'افتح الإصدار غير المحدود · $price';
  }

  @override
  String get paywallRestorePurchases => 'استعادة المشتريات';

  @override
  String get paywallStoreUnavailable => 'المتجر غير متاح';

  @override
  String get paywallStoreUnavailableNote =>
      'تعذّر تحميل السعر. تحقق من اتصالك وحاول مجددًا.';

  @override
  String get paywallTryAgain => 'حاول مجددًا';

  @override
  String get gateTitle => 'انتهت دورتك الأولى';

  @override
  String get gateLead =>
      'أربع سنوات هي دورة واحدة. ليست كافية لتعرف إن كنت على حق.';

  @override
  String get gatePriceLead => 'دفعة واحدة، إلى الأبد';

  @override
  String get gateBuy => 'اشترِ وتابع';

  @override
  String get gateExit => 'خروج';

  @override
  String get gateSaveTitle => 'هذا الحفظ يحتاج إلى الإصدار الكامل';

  @override
  String get gateSaveLead =>
      'ملفات الحفظ بعد الدورة المجانية، والحملات الخاصة بالإصدار الكامل، تستمر معه. لا شيء يضيع: هذا الحفظ ينتظرك تمامًا كما تركته.';

  @override
  String get careerSaveLockedNote => 'يلزم الإصدار الكامل لمتابعة هذا الحفظ';

  @override
  String get federationNaturalisation => 'التجنيس';

  @override
  String federationNaturalisedTitle(String name) {
    return 'تجنيس $name';
  }

  @override
  String federationNaturalisedBody(String name, String nation) {
    return 'أكمل $name انتقاله وأصبح مؤهلًا للعب مع $nation. استدعه من اختيار القائمة.';
  }

  @override
  String federationCouldNotLoadOffer(String error) {
    return 'تعذّر تحميل العرض.\n$error';
  }

  @override
  String get federationContinue => 'متابعة';

  @override
  String get federationOfferToSwitchAllegiance => 'عرض لتغيير الجنسية الرياضية';

  @override
  String federationPlayerMeta(String position, int age, String nation) {
    return '$position · العمر $age · من $nation';
  }

  @override
  String federationNaturalisationBlurb(
    String name,
    String playerNation,
    String sourceNation,
  ) {
    return 'لدى $name روابط مع $playerNation وهو مستعد للتجنيس. اقبل ليصبح متاحًا للاختيار؛ ارفض ويبقى مع $sourceNation.';
  }

  @override
  String get federationDecline => 'رفض';

  @override
  String get federationNaturalise => 'تجنيس';

  @override
  String get federationBudgetLater => 'قرّر لاحقًا';

  @override
  String get federationSetYourBudget => 'حدد ميزانيتك';

  @override
  String federationCouldNotLoadFinances(String error) {
    return 'تعذّر تحميل الماليات.\n$error';
  }

  @override
  String get federationSaveNotFound => 'لم يُعثر على ملف الحفظ.';

  @override
  String get federationBudgetHeading => 'ميزانية الاتحاد';

  @override
  String federationDistributeBudget(String amount) {
    return 'وزّع $amount على الأقسام لافتتاح الدورة. أنفقها بحكمة.';
  }

  @override
  String federationOverBudget(String amount) {
    return '$amount أكثر مما يملكه الاتحاد. استرجع بعضها';
  }

  @override
  String get federationAllocateFullBudget =>
      'خصّص الميزانية كاملة لبدء الدورة.';

  @override
  String get federationConfirming => 'جارٍ التأكيد…';

  @override
  String get federationConfirmBudget => 'تأكيد الميزانية';

  @override
  String get federationFinances => 'الماليات';

  @override
  String get federationInvestmentUpdated => 'تم تحديث الاستثمار.';

  @override
  String get federationDevelopment => 'تطوير الاتحاد';

  @override
  String get federationProjectedAtSeasonEnd => 'المتوقع في نهاية الموسم';

  @override
  String get federationCentralFunding => 'التمويل المركزي';

  @override
  String get federationPrizeMoneySoFar => 'الجوائز المالية حتى الآن';

  @override
  String get federationCommercialReturn => 'العائد التجاري';

  @override
  String get federationThisSeasonLocked => 'هذا الموسم (مقفل)';

  @override
  String get federationInvestForNextSeason => 'استثمر للموسم القادم';

  @override
  String get federationNextSeasonImpact => 'تأثير الموسم القادم';

  @override
  String get federationSaving => 'جارٍ الحفظ…';

  @override
  String get federationConfirmInvestment => 'تأكيد الاستثمار';

  @override
  String get federationBalance => 'رصيد الاتحاد';

  @override
  String get federationCommittedToStaff => 'ملتزم به للطاقم';

  @override
  String get federationFreeToSpend => 'متاح للإنفاق';

  @override
  String get federationWagesNote =>
      'تُخصم الرواتب من الرصيد في نهاية الدورة، لذا فهذا المبلغ محجوز.';

  @override
  String get federationInvestAtCeremony =>
      'استثمر للموسم القادم في حفل نهاية الدورة.';

  @override
  String federationLevelBadge(int level) {
    return 'م$level';
  }

  @override
  String get federationAcademyProspects => 'مواهب الأكاديمية';

  @override
  String federationPlusOverall(int value) {
    return '⁦+$value⁩ للتقييم العام';
  }

  @override
  String get federationInjuryRisk => 'خطر الإصابة';

  @override
  String get federationNaturalisationChance => 'فرصة التجنيس';

  @override
  String get federationBoardPatience => 'صبر المجلس';

  @override
  String get federationUnallocated => 'غير مخصص';

  @override
  String get nationsVitrineTitle => 'واجهة المنتخب';

  @override
  String nationsCouldNotLoad(String error) {
    return 'تعذّر تحميل المنتخب.\n$error';
  }

  @override
  String get nationsNoNation => 'لا يوجد منتخب.';

  @override
  String get nationsHonours => 'الألقاب';

  @override
  String get nationsRankingHistory => 'تاريخ التصنيف العالمي';

  @override
  String get nationsTopScorers => 'الهدافون التاريخيون';

  @override
  String get nationsTitles => 'الألقاب';

  @override
  String get nationsYourTeam => 'فريقك';

  @override
  String get nationsWorld => 'العالم';

  @override
  String get nationsWorldCup => 'بطولة العالم';

  @override
  String get nationsContinental => 'القارية';

  @override
  String nationsAppearances(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مشاركة',
      many: '$count مشاركة',
      few: '$count مشاركات',
      two: 'مشاركتان',
      one: 'مشاركة واحدة',
      zero: '$count مشاركة',
    );
    return '$_temp0';
  }

  @override
  String get nationsNotEnoughHistory =>
      'لا يوجد تاريخ كافٍ بعد. عُد بعد دورة أو دورتين.';

  @override
  String nationsBestRank(int rank) {
    return 'الأفضل: #$rank';
  }

  @override
  String nationsNowRank(int rank) {
    return 'الآن: #$rank';
  }

  @override
  String get nationsNoGoals => 'لم تُسجَّل أهداف بعد.';

  @override
  String get nationsGoalsAbbrev => 'هدف';

  @override
  String get nationsHosts => 'المستضيف';

  @override
  String get nationsSelectTitle => 'اختر المنتخب الوطني';

  @override
  String nationsCouldNotLoadNations(String error) {
    return 'تعذّر تحميل المنتخبات.\n$error';
  }

  @override
  String get nationsNoMatch => 'لا منتخبات مطابقة.';

  @override
  String get nationsSelectHeading => 'اختر المنتخب الوطني';

  @override
  String get nationsSearchHint => 'ابحث عن دولة…';

  @override
  String get nationsRank => 'المركز';

  @override
  String get nationsPremium => 'مميز';

  @override
  String get nationsSelect => 'اختيار';

  @override
  String get statsTeamRecords => 'أرقام الفريق';

  @override
  String get statsRecordBook => 'سجل الأرقام';

  @override
  String statsCouldNotLoadStats(String error) {
    return 'تعذّر تحميل الإحصاءات.\n$error';
  }

  @override
  String get statsNoData => 'لا بيانات.';

  @override
  String get statsTopScorers => 'الهدافون';

  @override
  String get statsMostGamesPlayed => 'الأكثر خوضًا للمباريات';

  @override
  String get statsTeam => 'الفريق';

  @override
  String get statsTopScorersShort => 'الهدافون';

  @override
  String get statsMostGames => 'الأكثر مباريات';

  @override
  String get statsMostGamesShort => 'المباريات';

  @override
  String get statsNoGoalsRecorded => 'لم تُسجَّل أهداف بعد.';

  @override
  String get statsUnknown => 'غير معروف';

  @override
  String get playerTitle => 'اللاعب';

  @override
  String playerLoadError(String error) {
    return 'تعذّر تحميل اللاعب.\n$error';
  }

  @override
  String get playerNotFound => 'لم يُعثر على اللاعب.';

  @override
  String get playerClub => 'النادي';

  @override
  String get playerClubRole => 'مع ناديه';

  @override
  String get playerPosition => 'المركز';

  @override
  String get playerPotential => 'الإمكانات';

  @override
  String get playerAge => 'العمر';

  @override
  String get playerValue => 'القيمة';

  @override
  String get clubFirstChoice => 'يلعب كل أسبوع';

  @override
  String get clubRotation => 'يدخل ويخرج';

  @override
  String get clubFringe => 'بالكاد يلعب';

  @override
  String get clubFrozenOut => 'لا يلعب';

  @override
  String clubAtClub(String club, String standing) {
    return '⁦$club: $standing⁩';
  }

  @override
  String yWinUpset0(String opponent, String score) {
    return 'أشاهد كرة القدم منذ ثلاثين عامًا ولم أتوقع هذا. هزمنا $opponent ⁦$score⁩.';
  }

  @override
  String yWinUpset1(String opponent, String score) {
    return 'لم يمنحهم أحد أي فرصة أمام $opponent. ⁦$score⁩. لا أحد على الإطلاق.';
  }

  @override
  String yWinUpset2(String opponent, String score) {
    return '⁦$score⁩ أمام $opponent. اذهبوا وأيقظوا الجيران.';
  }

  @override
  String yWinUpset3(String opponent, String score) {
    return 'هذه ليلة يرويها الناس لأحفادهم. $opponent ⁦$score⁩.';
  }

  @override
  String yWinUpset4(String opponent, String score) {
    return '⁦$score⁩ أمام $opponent. أيًا كانت الطريقة، فقد حدث.';
  }

  @override
  String yWinUpset5(String opponent, String score) {
    return 'على الورق انتهت المباراة قبل أن تبدأ. $opponent ⁦$score⁩ تقول غير ذلك.';
  }

  @override
  String yWinUpset6(String opponent, String score) {
    return 'فزنا على $opponent ⁦$score⁩. لن يصدق أحد هذه النتيجة بعد عام.';
  }

  @override
  String yWinUpset7(String opponent, String score) {
    return '$opponent ⁦$score⁩. استمتعوا، ثم انظروا إلى جدول المباريات.';
  }

  @override
  String yWinUpset8(String opponent, String score) {
    return '⁦$score⁩ أمام $opponent، وكان الحظ معنا ثمانين دقيقة من التسعين.';
  }

  @override
  String yWinUpset9(String opponent, String score) {
    return 'ليلة واحدة أمام $opponent لا تمحو عامًا كاملًا. ⁦$score⁩.';
  }

  @override
  String yWinUpset10(String opponent, String score) {
    return 'فزنا على $opponent ⁦$score⁩ وسيقال لنا الآن إننا تجاوزنا المرحلة الصعبة. لم نتجاوزها.';
  }

  @override
  String yWinUpset11(String opponent, String score) {
    return '$opponent ⁦$score⁩. رائع. اسألوني مجددًا حين يكون الأمر مهمًا.';
  }

  @override
  String yWinRoutine0(String opponent, String score) {
    return 'فزنا على $opponent ⁦$score⁩. تمامًا كما يجب، وفي ذلك متعة.';
  }

  @override
  String yWinRoutine1(String opponent, String score) {
    return '⁦$score⁩ على $opponent. بلا رحمة، وهذا مديح.';
  }

  @override
  String yWinRoutine2(String opponent, String score) {
    return '$opponent ⁦$score⁩. بلا ضجة، بلا خوف، بلا شكوى.';
  }

  @override
  String yWinRoutine3(String opponent, String score) {
    return '⁦$score⁩ نظيفة أمام $opponent. هكذا يبدو الفريق الجيد في يوم هادئ.';
  }

  @override
  String yWinRoutine4(String opponent, String score) {
    return '⁦$score⁩ أمام $opponent. أُنجزت المهمة، ولم نتعلم شيئًا.';
  }

  @override
  String yWinRoutine5(String opponent, String score) {
    return 'فزنا على $opponent ⁦$score⁩. كان يُفترض أن نفوز، وفزنا.';
  }

  @override
  String yWinRoutine6(String opponent, String score) {
    return '⁦$score⁩ احترافية على $opponent. التالي.';
  }

  @override
  String yWinRoutine7(String opponent, String score) {
    return 'تخلصنا من $opponent ⁦$score⁩. احفظوها وامضوا.';
  }

  @override
  String yWinRoutine8(String opponent, String score) {
    return '⁦$score⁩ أمام $opponent ويُفترض أن نصفق. لأننا هزمناهم.';
  }

  @override
  String yWinRoutine9(String opponent, String score) {
    return 'أحسنتم جميعًا على ⁦$score⁩ أمام $opponent، على ما أظن.';
  }

  @override
  String yWinRoutine10(String opponent, String score) {
    return '$opponent ⁦$score⁩. هزيمة فرق كهذه هي الحد الأدنى، لا الإنجاز.';
  }

  @override
  String yWinRoutine11(String opponent, String score) {
    return 'هزمنا $opponent ⁦$score⁩ وبدونا متثاقلين.';
  }

  @override
  String yWinTight0(String opponent, String score) {
    return '⁦$score⁩ أمام $opponent وكل دقيقة منها مستحقة.';
  }

  @override
  String yWinTight1(String opponent, String score) {
    return 'هذا تطلّب شخصية. $opponent ⁦$score⁩.';
  }

  @override
  String yWinTight2(String opponent, String score) {
    return 'هزمنا $opponent ⁦$score⁩ بالطريقة الصعبة، وهي الطريقة التي تدوم.';
  }

  @override
  String yWinTight3(String opponent, String score) {
    return '⁦$score⁩ أمام $opponent. الفرق التي تفوز بمثل هذه المباريات هي التي تبقى صامدة في يونيو.';
  }

  @override
  String yWinTight4(String opponent, String score) {
    return 'متوترة، قبيحة، وفوز. $opponent ⁦$score⁩.';
  }

  @override
  String yWinTight5(String opponent, String score) {
    return 'هزمنا $opponent ⁦$score⁩. خذوا النقاط الثلاث ولا تشاهدوها مرة أخرى.';
  }

  @override
  String yWinTight6(String opponent, String score) {
    return '⁦$score⁩. أجبرنا $opponent على القتال على كل شبر.';
  }

  @override
  String yWinTight7(String opponent, String score) {
    return '$opponent ⁦$score⁩. ليست جميلة. لكنها تُحتسب بالمثل.';
  }

  @override
  String yWinTight8(String opponent, String score) {
    return '⁦$score⁩ أمام $opponent وجعلناها أصعب بعشر مرات مما كانت.';
  }

  @override
  String yWinTight9(String opponent, String score) {
    return 'لا ينبغي أن نتشبث بالنتيجة أمام $opponent. ⁦$score⁩.';
  }

  @override
  String yWinTight10(String opponent, String score) {
    return '$opponent ⁦$score⁩. فزنا، ولم نتعلم شيئًا جيدًا عن أنفسنا.';
  }

  @override
  String yWinTight11(String opponent, String score) {
    return '⁦$score⁩ جاملتنا أمام $opponent.';
  }

  @override
  String yDrew0(String opponent, String score) {
    return 'نقطة أمام $opponent، ⁦$score⁩. خذوها وامضوا.';
  }

  @override
  String yDrew1(String opponent, String score) {
    return '⁦$score⁩ مع $opponent. هناك أمسيات أسوأ من هذه.';
  }

  @override
  String yDrew2(String opponent, String score) {
    return 'فرضنا التعادل على $opponent ⁦$score⁩. ليس كل شيء قصة.';
  }

  @override
  String yDrew3(String opponent, String score) {
    return '$opponent ⁦$score⁩. النقطة نقطة والجدول لا يسأل كيف.';
  }

  @override
  String yDrew4(String opponent, String score) {
    return '⁦$score⁩ مع $opponent. نقطتان ضائعتان أو نقطة مكتسبة. اختاروا مزاجكم.';
  }

  @override
  String yDrew5(String opponent, String score) {
    return 'تعادل أمام $opponent، ⁦$score⁩. لا أحد سعيد، ولا أحد غاضب.';
  }

  @override
  String yDrew6(String opponent, String score) {
    return '$opponent ⁦$score⁩. أكثر تسعين دقيقة قابلة للنسيان هذا العام.';
  }

  @override
  String yDrew7(String opponent, String score) {
    return 'تقاسمنا النقاط مع $opponent، ⁦$score⁩. نمضي قدمًا.';
  }

  @override
  String yDrew8(String opponent, String score) {
    return '⁦$score⁩ أمام $opponent. هكذا تموت الحملات بهدوء.';
  }

  @override
  String yDrew9(String opponent, String score) {
    return 'نقطتان ضائعتان أمام $opponent. ⁦$score⁩. لا تسمية أخرى لذلك.';
  }

  @override
  String yDrew10(String opponent, String score) {
    return '$opponent ⁦$score⁩. كانت لدينا تسعون دقيقة ولم نعرف ماذا نفعل بها.';
  }

  @override
  String yDrew11(String opponent, String score) {
    return '⁦$score⁩ مع $opponent لن يتذكرها أحد وسيدفع الجميع ثمنها.';
  }

  @override
  String yLost0(String opponent, String score) {
    return 'هُزمنا ⁦$score⁩ أمام $opponent. هذا يحدث.';
  }

  @override
  String yLost1(String opponent, String score) {
    return '$opponent ⁦$score⁩. لا داعي لمحاسبة أحد. إلى المباراة التالية.';
  }

  @override
  String yLost2(String opponent, String score) {
    return 'خسرنا ⁦$score⁩ أمام $opponent وقدمنا كل شيء. أحيانًا لا يكفي ذلك.';
  }

  @override
  String yLost3(String opponent, String score) {
    return '⁦$score⁩ أمام $opponent. ارفعوا رؤوسكم. هذا الفريق لديه الكثير.';
  }

  @override
  String yLost4(String opponent, String score) {
    return '$opponent ⁦$score⁩. كنا الأقل مستوى ولا جدال في ذلك.';
  }

  @override
  String yLost5(String opponent, String score) {
    return 'خسرنا ⁦$score⁩ أمام $opponent. لنُعِد ترتيب صفوفنا.';
  }

  @override
  String yLost6(String opponent, String score) {
    return '⁦$score⁩ أمام $opponent. ليست فضيحة، لكنها ليست كافية.';
  }

  @override
  String yLost7(String opponent, String score) {
    return 'هُزمنا ⁦$score⁩ أمام $opponent. تعلّموا منها شيئًا وإلا ضاعت سدى.';
  }

  @override
  String yLost8(String opponent, String score) {
    return '⁦$score⁩ أمام $opponent ولم نقترب منهم حتى.';
  }

  @override
  String yLost9(String opponent, String score) {
    return 'خسرنا أمام $opponent، ⁦$score⁩. المشاكل نفسها، الشهر نفسه، والأعذار نفسها قادمة.';
  }

  @override
  String yLost10(String opponent, String score) {
    return '$opponent ⁦$score⁩. متى يتوقف هذا عن كونه سوء حظ؟';
  }

  @override
  String yLost11(String opponent, String score) {
    return 'هُزمنا ⁦$score⁩ أمام $opponent. نتيجة يجب أن تكلف أحدهم شيئًا.';
  }

  @override
  String yLostBadly0(String opponent, String score) {
    return '⁦$score⁩ أمام $opponent. ليلة سيئة واحدة. احكموا على الفريق من الحملة، لا من هذه.';
  }

  @override
  String yLostBadly1(String opponent, String score) {
    return 'لم يكره أحد تلك الـ⁦$score⁩ أمام $opponent أكثر من اللاعبين أنفسهم.';
  }

  @override
  String yLostBadly2(String opponent, String score) {
    return '$opponent ⁦$score⁩. قبيحة، وليست حقيقة هذا الفريق.';
  }

  @override
  String yLostBadly3(String opponent, String score) {
    return '⁦$score⁩ يجب نسيانها أمام $opponent. سيعودون أقوى في المرة القادمة.';
  }

  @override
  String yLostBadly4(String opponent, String score) {
    return '⁦$score⁩. أمام $opponent. لا كلمات لديّ وأنا أتقاضى أجرًا على الكلمات.';
  }

  @override
  String yLostBadly5(String opponent, String score) {
    return '$opponent ⁦$score⁩. على أحدهم أن يُحاسَب على هذا.';
  }

  @override
  String yLostBadly6(String opponent, String score) {
    return 'أريد أن تُمحى الـ⁦$score⁩ أمام $opponent من السجلات ومن الذاكرة.';
  }

  @override
  String yLostBadly7(String opponent, String score) {
    return 'هُزمنا ⁦$score⁩ أمام $opponent. لا يمكن تجميل نتيجة كهذه.';
  }

  @override
  String yLostBadly8(String opponent, String score) {
    return 'لم تكن تلك هزيمة أمام $opponent، بل استسلام. ⁦$score⁩.';
  }

  @override
  String yLostBadly9(String opponent, String score) {
    return '⁦$score⁩. أمام $opponent. دفع الناس مالًا لمشاهدة هذا.';
  }

  @override
  String yLostBadly10(String opponent, String score) {
    return '$opponent ⁦$score⁩. إن لم يغيّر هذا شيئًا، فلن يتغير شيء.';
  }

  @override
  String yLostBadly11(String opponent, String score) {
    return 'رأيت هذا الفريق مهانًا من قبل، لكن ⁦$score⁩ أمام $opponent قاع جديد.';
  }

  @override
  String yWinUpset12(String opponent, String score) {
    return 'هزمنا $opponent ⁦$score⁩. دوّنوا التاريخ، سيسألكم الناس أين كنتم.';
  }

  @override
  String yWinUpset13(String opponent, String score) {
    return 'لم يؤمن أحد خارج غرفة الملابس. ⁦$score⁩ أمام $opponent. الفخر لا يكفي لوصف ذلك.';
  }

  @override
  String yWinUpset14(String opponent, String score) {
    return '⁦$score⁩ أمام $opponent! ركض كل واحد منهم حتى لم يبقَ لديه شيء.';
  }

  @override
  String yWinUpset15(String opponent, String score) {
    return 'إسقاط العمالقة. $opponent، ⁦$score⁩. لهذا لا نتوقف عن الحضور أبدًا.';
  }

  @override
  String yWinUpset16(String opponent, String score) {
    return '⁦$score⁩ أمام $opponent. كل التوقعات خرجت للتو من النافذة.';
  }

  @override
  String yWinUpset17(String opponent, String score) {
    return 'كان $opponent المرشح الواضح. النتيجة النهائية: ⁦$score⁩ لنا.';
  }

  @override
  String yWinUpset18(String opponent, String score) {
    return 'إحدى مفاجآت العام: ⁦$score⁩ أمام $opponent.';
  }

  @override
  String yWinUpset19(String opponent, String score) {
    return '$opponent ⁦$score⁩. لم يتوقعها أحد ولا يستطيع أحد تفسيرها تمامًا.';
  }

  @override
  String yWinUpset20(String opponent, String score) {
    return '⁦$score⁩ أمام $opponent. جميل. والآن شاهدوا الجميع ينسون كم كان باقي العام سيئًا.';
  }

  @override
  String yWinUpset21(String opponent, String score) {
    return 'فزنا على $opponent ⁦$score⁩ والقطار امتلأ بالركاب بالفعل. كنت هنا حين كان فارغًا.';
  }

  @override
  String yWinUpset22(String opponent, String score) {
    return '$opponent ⁦$score⁩. رائع، وسيجدون مع ذلك طريقة لإهداره.';
  }

  @override
  String yWinUpset23(String opponent, String score) {
    return 'ليلة رائعة أمام $opponent، ⁦$score⁩. سنونو واحد لا يصنع ربيعًا.';
  }

  @override
  String yLostBadly12(String opponent, String score) {
    return '⁦$score⁩ أمام $opponent. يؤلم لأننا نهتم. ادعموهم رغم ذلك.';
  }

  @override
  String yLostBadly13(String opponent, String score) {
    return 'ليلة للنسيان أمام $opponent، ⁦$score⁩. اللاعبون سيتألمون أكثر من أي أحد.';
  }

  @override
  String yLostBadly14(String opponent, String score) {
    return '$opponent ⁦$score⁩. ارفعوا رؤوسكم. يُحكم على الفريق بطريقة رده على هذا.';
  }

  @override
  String yLostBadly15(String opponent, String score) {
    return '⁦$score⁩ أمام $opponent. سيئة، نعم. نهاية العالم، لا.';
  }

  @override
  String yLostBadly16(String opponent, String score) {
    return '⁦$score⁩ أمام $opponent. نتيجة سيتحدث عنها الناس لسنوات، للأسباب الخاطئة.';
  }

  @override
  String yLostBadly17(String opponent, String score) {
    return 'فاز $opponent ⁦$score⁩. بناءً على هذا، لا ينبغي أن يُفاجأ أحد في المرة القادمة.';
  }

  @override
  String yLostBadly18(String opponent, String score) {
    return 'إحدى أسوأ الليالي منذ زمن طويل: ⁦$score⁩ أمام $opponent.';
  }

  @override
  String yLostBadly19(String opponent, String score) {
    return '$opponent ⁦$score⁩. ستُطرح أسئلة، ويجب أن تُطرح.';
  }

  @override
  String yLostBadly20(String opponent, String score) {
    return '⁦$score⁩ أمام $opponent. كلمة «محرج» لا تكفي إطلاقًا.';
  }

  @override
  String yLostBadly21(String opponent, String score) {
    return 'خسرنا ⁦$score⁩ أمام $opponent. آخر من يخرج يطفئ الأنوار.';
  }

  @override
  String yLostBadly22(String opponent, String score) {
    return '$opponent ⁦$score⁩. لم أعد أتفاجأ، وهذا يخيفني.';
  }

  @override
  String yLostBadly23(String opponent, String score) {
    return '⁦$score⁩. $opponent. على أحد المسؤولين أن يحدّث سيرته الذاتية الليلة.';
  }

  @override
  String yWinRout0(String opponent, String score) {
    return '⁦$score⁩ أمام $opponent! كرة كهذه تجعل البلاد كلها تبتسم.';
  }

  @override
  String yWinRout1(String opponent, String score) {
    return '$opponent سُحق، ⁦$score⁩. يا له من أداء.';
  }

  @override
  String yWinRout2(String opponent, String score) {
    return '⁦$score⁩. أمام $opponent. نجح كل شيء الليلة.';
  }

  @override
  String yWinRout3(String opponent, String score) {
    return 'اكتساح ⁦$score⁩ لـ$opponent. احفظوا الملخص، ستحتاجونه لاحقًا.';
  }

  @override
  String yWinRout4(String opponent, String score) {
    return '$opponent ⁦$score⁩. هذا فريق يستمتع بكرته.';
  }

  @override
  String yWinRout5(String opponent, String score) {
    return '⁦$score⁩ أمام $opponent، وكان يمكن أن تكون أكثر. رائع.';
  }

  @override
  String yWinRout6(String opponent, String score) {
    return '⁦$score⁩ أمام $opponent. نتيجة ستجعل الناس ينظرون مرتين.';
  }

  @override
  String yWinRout7(String opponent, String score) {
    return 'هُزم $opponent ⁦$score⁩. لم تكن هناك منافسة بعد أول نصف ساعة.';
  }

  @override
  String yWinRout8(String opponent, String score) {
    return 'النتيجة النهائية: ⁦$score⁩ أمام $opponent. أكبر فوز منذ فترة بفارق مريح.';
  }

  @override
  String yWinRout9(String opponent, String score) {
    return '$opponent ⁦$score⁩. فريق حضر، والآخر لم ينزل من الحافلة.';
  }

  @override
  String yWinRout10(String opponent, String score) {
    return '⁦$score⁩. لم يجد $opponent أي رد على أي شيء.';
  }

  @override
  String yWinRout11(String opponent, String score) {
    return 'سحق: ⁦$score⁩ أمام $opponent.';
  }

  @override
  String yWinRout12(String opponent, String score) {
    return '⁦$score⁩ أمام $opponent. جميل، لكنهم ليسوا المقياس.';
  }

  @override
  String yWinRout13(String opponent, String score) {
    return 'هزمنا $opponent ⁦$score⁩. أيقظوني حين نفعل هذا بفريق جيد.';
  }

  @override
  String yWinRout14(String opponent, String score) {
    return '$opponent ⁦$score⁩. ممتع، لكنني رأيت فرقًا تبدو بهذا الشكل ولا تفوز بشيء.';
  }

  @override
  String yWinRout15(String opponent, String score) {
    return '⁦$score⁩، والجميع عباقرة مجددًا. كان المنافس $opponent.';
  }

  @override
  String yWinRout16(String opponent, String score) {
    return '⁦$score⁩ أمام $opponent. لا تنجرفوا، فهي لا تثبت إلا القليل.';
  }

  @override
  String yWinRout17(String opponent, String score) {
    return '$opponent ⁦$score⁩. استمتعوا، ثم تذكروا آخر مرة تحمسنا فيها.';
  }

  @override
  String yWinShootout0(String opponent) {
    return 'تأهلنا بركلات الترجيح أمام $opponent! أعصاب من فولاذ، كل واحد منهم.';
  }

  @override
  String yWinShootout1(String opponent) {
    return 'ركلات ترجيح أمام $opponent، وحافظنا على أعصابنا. عانقوا غريبًا.';
  }

  @override
  String yWinShootout2(String opponent) {
    return 'فزنا بركلات الترجيح أمام $opponent. قلبي لا يحتمل هذا.';
  }

  @override
  String yWinShootout3(String opponent) {
    return 'هُزم $opponent بركلات الترجيح. إلى الدور التالي.';
  }

  @override
  String yWinShootout4(String opponent) {
    return 'وصلت إلى ركلات الترجيح أمام $opponent، وسجلنا أكثر منهم.';
  }

  @override
  String yWinShootout5(String opponent) {
    return 'فزنا بركلات الترجيح أمام $opponent. أصعب طريق ممكن، لكننا تأهلنا.';
  }

  @override
  String yWinShootout6(String opponent) {
    return 'تأهلنا بركلات الترجيح أمام $opponent. ربحنا اليانصيب، ونُسي الأداء.';
  }

  @override
  String yWinShootout7(String opponent) {
    return 'هزمنا $opponent بركلات الترجيح بعد ذلك الأداء؟ حظ، والجميع يعرف ذلك.';
  }

  @override
  String yWinShootout8(String opponent) {
    return 'تأهلنا أمام $opponent بركلات الترجيح. ما كان يجب أن نحتاج إليها.';
  }

  @override
  String yKnockoutWin0(String opponent, String score) {
    return 'تأهلنا. ⁦$score⁩ أمام $opponent، والحلم لا يزال حيًا.';
  }

  @override
  String yKnockoutWin1(String opponent, String score) {
    return 'فوز في الأدوار الإقصائية: هزمنا $opponent ⁦$score⁩. يمكن للبلاد أن تبدأ بالإيمان.';
  }

  @override
  String yKnockoutWin2(String opponent, String score) {
    return '⁦$score⁩ أمام $opponent وإلى الدور التالي. يا لها من ليلة.';
  }

  @override
  String yKnockoutWin3(String opponent, String score) {
    return '$opponent عائد إلى دياره، ⁦$score⁩. إلى الأمام.';
  }

  @override
  String yKnockoutWin4(String opponent, String score) {
    return 'إقصائيات: ⁦$score⁩ أمام $opponent. الدور التالي مؤكد.';
  }

  @override
  String yKnockoutWin5(String opponent, String score) {
    return 'تأهلنا: ⁦$score⁩ أمام $opponent.';
  }

  @override
  String yKnockoutWin6(String opponent, String score) {
    return 'أُقصي $opponent، ⁦$score⁩. الدور التالي بانتظارنا.';
  }

  @override
  String yKnockoutWin7(String opponent, String score) {
    return 'فزنا ⁦$score⁩ أمام $opponent. كرة الإقصاء لا تهتم بالطريقة.';
  }

  @override
  String yKnockoutWin8(String opponent, String score) {
    return 'تأهلنا أمام $opponent، ⁦$score⁩. المنافس التالي لن يكون بهذا اللطف.';
  }

  @override
  String yKnockoutWin9(String opponent, String score) {
    return '⁦$score⁩ أمام $opponent تكفي للتأهل. سنحتاج إلى أكثر بكثير في المرة القادمة.';
  }

  @override
  String yKnockoutWin10(String opponent, String score) {
    return '$opponent خارج المنافسة، ⁦$score⁩. نجونا أكثر مما فزنا.';
  }

  @override
  String yKnockoutWin11(String opponent, String score) {
    return 'إلى الدور التالي بعد ⁦$score⁩ أمام $opponent. لا تسألوا كيف.';
  }

  @override
  String yUpsetGap0(String opponent, int gap) {
    return '$gap مركزًا بيننا في التصنيف، ومع ذلك هزمنا $opponent. رائع.';
  }

  @override
  String yUpsetGap1(String opponent, int gap) {
    return 'كان $opponent متقدمًا علينا بـ$gap مركزًا. هُزم. كرة القدم رائعة.';
  }

  @override
  String yUpsetGap2(String opponent, int gap) {
    return 'الفارق في التصنيف: $gap مركزًا. النتيجة: هزمنا $opponent. لا تتوقفوا عن الإيمان.';
  }

  @override
  String yUpsetGap3(String opponent, int gap) {
    return 'الفارق في التصنيف قبل البداية: $gap مركزًا. ومع ذلك هُزم $opponent.';
  }

  @override
  String yUpsetGap4(String opponent, int gap) {
    return 'كان $opponent متقدمًا علينا بـ$gap مركزًا في التصنيف العالمي. ليس الليلة.';
  }

  @override
  String yUpsetGap5(String opponent, int gap) {
    return 'مؤشر المفاجأة: $gap مركزًا بين الفريقين في التصنيف. الفوز لنا أمام $opponent.';
  }

  @override
  String yUpsetGap6(String opponent, int gap) {
    return 'فصلنا عن $opponent $gap مركزًا في التصنيف. ليلة واحدة لا تسد الفجوة.';
  }

  @override
  String yUpsetGap7(String opponent, int gap) {
    return '$opponent: متقدم علينا بـ$gap مركزًا، وهُزم. التصنيف بالكاد سيلاحظ.';
  }

  @override
  String yUpsetGap8(int gap) {
    return 'الفارق في التصنيف: $gap مركزًا. تذكروا هذا الرقم في المرة القادمة التي نخسر فيها أمام فريق صغير.';
  }

  @override
  String yEatWords0(String opponent) {
    return 'شطبت هذا الفريق. كنت مخطئًا، ولم أكن يومًا أسعد بخطئي. هُزم $opponent.';
  }

  @override
  String yEatWords1(String opponent) {
    return 'أعترف بخطئي، وبكل تواضع. ذلك الفوز على $opponent كان رائعًا.';
  }

  @override
  String yEatWords2(String opponent) {
    return 'قلت إنه لم يبقَ لديهم شيء. كان لديهم الكثير. أحسنتم جميعًا أمام $opponent.';
  }

  @override
  String yEatWords3(String opponent) {
    return 'للتسجيل، لم أتوقع ذلك الفوز على $opponent. الفضل لأصحابه.';
  }

  @override
  String yEatWords4(String opponent) {
    return 'حسنًا. قلت إنهم سيُكشفون. $opponent لم يكشفهم.';
  }

  @override
  String yEatWords5(String opponent) {
    return 'سأتراجع عن كلامي عن هذا الفريق الليلة. الفوز على $opponent يستحق ذلك.';
  }

  @override
  String yEatWords6(String opponent) {
    return 'نعم، قلت إنهم انتهوا. فوز واحد على $opponent لا يثبت خطئي بعد.';
  }

  @override
  String yEatWords7(String opponent) {
    return 'يُطلب مني التراجع عن كلامي بعد $opponent. سأفعل، ببطء، وسأحتفظ بالإيصال.';
  }

  @override
  String yEatWords8(String opponent) {
    return 'الفوز على $opponent كان مثيرًا للإعجاب. شكوكي في هذا الفريق لم تذهب إلى أي مكان.';
  }

  @override
  String yAwayFansWin0(String nation, String score) {
    return 'تحية لـ$nation. ⁦$score⁩، واستحقوا كل جزء منها.';
  }

  @override
  String yAwayFansWin1(String nation, String score) {
    return 'يؤلمني قولها، لكن $nation كانوا أفضل الليلة. ⁦$score⁩. تهانينا.';
  }

  @override
  String yAwayFansWin2(String nation, String score) {
    return '⁦$score⁩. القبعات تُرفع لـ$nation، أرادوها أكثر.';
  }

  @override
  String yAwayFansWin3(String nation, String score) {
    return 'خسرنا ⁦$score⁩ أمام $nation. لا أعرف حتى ماذا أقول.';
  }

  @override
  String yAwayFansWin4(String nation, String score) {
    return '$nation ⁦$score⁩. يجب أن يخجل فريقنا.';
  }

  @override
  String yAwayFansWin5(String nation, String score) {
    return '⁦$score⁩ أمام $nation. فليشرح لي أحد كيف حدث ذلك.';
  }

  @override
  String yAwayFansWin6(String nation, String score) {
    return 'الخسارة ⁦$score⁩ أمام $nation. لن أتجاوز هذا أبدًا.';
  }

  @override
  String yAwayFansWin7(String nation, String score) {
    return '⁦$score⁩ أمام $nation. حظ. حظ خالص.';
  }

  @override
  String yAwayFansWin8(String nation, String score) {
    return 'سيكون $nation لا يُطاقون لسنوات بعد تلك الـ⁦$score⁩. شكرًا على لا شيء.';
  }

  @override
  String yNeutralWin0(String nation, String opponent, String score) {
    return '$nation ⁦$score⁩ $opponent. رائع للعبة. لهذا نحبها.';
  }

  @override
  String yNeutralWin1(String nation, String opponent, String score) {
    return 'يا لها من نتيجة لـ⁦$nation: $score⁩ أمام $opponent. كرة القدم في أفضل حالاتها.';
  }

  @override
  String yNeutralWin2(String nation, String opponent, String score) {
    return 'كل محايد يشجع $nation الليلة. ⁦$score⁩ أمام $opponent!';
  }

  @override
  String yNeutralWin3(String nation, String opponent, String score) {
    return 'نتيجة الجولة: $nation ⁦$score⁩ $opponent.';
  }

  @override
  String yNeutralWin4(String nation, String opponent, String score) {
    return 'هزم $nation $opponent ⁦$score⁩. لم يتوقعها أحد.';
  }

  @override
  String yNeutralWin5(String nation, String opponent, String score) {
    return 'نتيجة كبيرة: $nation ⁦$score⁩ $opponent. التصنيف سيتحرك.';
  }

  @override
  String yNeutralWin6(String nation, String opponent, String score) {
    return '$nation ⁦$score⁩ $opponent. ممتع، لكن لنرَ إن كانوا يستطيعون تكرارها.';
  }

  @override
  String yNeutralWin7(String nation, String opponent, String score) {
    return '$nation ⁦$score⁩ $opponent. هل فاز $nation، أم خسر $opponent؟';
  }

  @override
  String yNeutralWin8(String nation, String opponent, String score) {
    return 'نتيجة صادمة: $nation ⁦$score⁩ $opponent. توقعوا الكثير من المبالغة.';
  }

  @override
  String yScorerHero0(String name, String opponent) {
    return '$name أمام $opponent. سيسمّون أطفالهم باسمه.';
  }

  @override
  String yScorerHero1(String name, String opponent) {
    return 'تمثال لـ$name. الليلة أمام $opponent كان كل شيء.';
  }

  @override
  String yScorerHero2(String name, String opponent) {
    return '$name، يا لك من رائع. تذكروا هذه الليلة أمام $opponent.';
  }

  @override
  String yScorerHero3(String name, String opponent) {
    return 'حسمها $name أمام $opponent. رجل المباراة، بلا نقاش.';
  }

  @override
  String yScorerHero4(String name, String opponent) {
    return 'أمام $opponent، كانت الليلة ملكًا لـ$name.';
  }

  @override
  String yScorerHero5(String name, String opponent) {
    return 'حضر $name حين كان الأمر مهمًا أمام $opponent.';
  }

  @override
  String yScorerHero6(String name, String opponent) {
    return 'كان $name رائعًا أمام $opponent. والآن كرّرها كل أسبوع.';
  }

  @override
  String yScorerHero7(String name, String opponent) {
    return 'أنقذ $name الفريق أمام $opponent. لم يساعد غيره كثيرًا.';
  }

  @override
  String yScorerHero8(String name, String opponent) {
    return 'أزيلوا $name من المعادلة وستكون ليلة مختلفة تمامًا أمام $opponent.';
  }

  @override
  String yLostShock0(String opponent, String score) {
    return '⁦$score⁩ أمام $opponent. نتيجة غريبة. تحدث للجميع مرة.';
  }

  @override
  String yLostShock1(String opponent, String score) {
    return 'خسرنا ⁦$score⁩ أمام $opponent. انفضوا الغبار، الحملة لم تنتهِ.';
  }

  @override
  String yLostShock2(String opponent, String score) {
    return '$opponent ⁦$score⁩. مؤلم، لكن نتيجة واحدة لا تحدد هوية هذا الفريق.';
  }

  @override
  String yLostShock3(String opponent, String score) {
    return '⁦$score⁩ أمام $opponent. يوم سيئ في العمل. امضوا قدمًا.';
  }

  @override
  String yLostShock4(String opponent, String score) {
    return 'خسرنا أمام $opponent، ⁦$score⁩. لم يتوقع أحد ذلك.';
  }

  @override
  String yLostShock5(String opponent, String score) {
    return '$opponent ⁦$score⁩. إحدى تلك الليالي التي لا معنى لها.';
  }

  @override
  String yLostShock6(String opponent, String score) {
    return '⁦$score⁩ أمام $opponent. هزيمة ستبقى في الذاكرة.';
  }

  @override
  String yLostShock7(String opponent, String score) {
    return 'هُزمنا أمام $opponent، ⁦$score⁩. صدمة بكل المقاييس.';
  }

  @override
  String yLostShock8(String opponent, String score) {
    return '⁦$score⁩ أمام $opponent. أمام $opponent! غير مقبول.';
  }

  @override
  String yLostShock9(String opponent, String score) {
    return 'خسرنا ⁦$score⁩ أمام $opponent. أريد تفسيرًا، لا أعذارًا.';
  }

  @override
  String yLostShock10(String opponent, String score) {
    return '$opponent ⁦$score⁩. فضيحة وطنية، وهذا ليس مجازًا.';
  }

  @override
  String yLostShock11(String opponent, String score) {
    return '⁦$score⁩ أمام $opponent. كيف لا يزال المسؤولون في مناصبهم؟';
  }

  @override
  String yLostRout0(String opponent, String score) {
    return '⁦$score⁩ أمام $opponent. إنهم فريق من الطراز الأول. تعلّموا من ذلك.';
  }

  @override
  String yLostRout1(String opponent, String score) {
    return 'تفوّق علينا $opponent بوضوح، ⁦$score⁩. لا عيب في الخسارة أمام الأفضل.';
  }

  @override
  String yLostRout2(String opponent, String score) {
    return '$opponent ⁦$score⁩. درس، والدروس هي طريق النمو.';
  }

  @override
  String yLostRout3(String opponent, String score) {
    return '⁦$score⁩ أمام $opponent. مؤلم، لكنهم في مستوى أعلى.';
  }

  @override
  String yLostRout4(String opponent, String score) {
    return 'فاز $opponent ⁦$score⁩. الفجوة حقيقية، والآن رآها الجميع.';
  }

  @override
  String yLostRout5(String opponent, String score) {
    return '⁦$score⁩ أمام $opponent. علقة ساخنة، ببساطة.';
  }

  @override
  String yLostRout6(String opponent, String score) {
    return '$opponent ⁦$score⁩. الفريق الأفضل، والنتيجة تقول ذلك.';
  }

  @override
  String yLostRout7(String opponent, String score) {
    return 'خسرنا ⁦$score⁩ أمام $opponent. ليست فضيحة، لكنها لم تكن منافسة أيضًا.';
  }

  @override
  String yLostRout8(String opponent, String score) {
    return '⁦$score⁩ أمام $opponent. أفضل منا أم لا، لا ينبغي لأحد أن يخسر هكذا.';
  }

  @override
  String yLostRout9(String opponent, String score) {
    return '$opponent ⁦$score⁩. هل حاولنا المنافسة أصلًا؟';
  }

  @override
  String yLostRout10(String opponent, String score) {
    return '⁦$score⁩. أمام $opponent. كالخراف إلى المسلخ.';
  }

  @override
  String yLostRout11(String opponent, String score) {
    return 'هُزمنا ⁦$score⁩ أمام $opponent، ولم يبدُ أحد منزعجًا.';
  }

  @override
  String yLostShootout0(String opponent) {
    return 'خرجنا بركلات الترجيح أمام $opponent. قدموا كل شيء. فخور بهم.';
  }

  @override
  String yLostShootout1(String opponent) {
    return 'ركلات الترجيح أمام $opponent. أقسى طريقة للخروج. ارفعوا رؤوسكم.';
  }

  @override
  String yLostShootout2(String opponent) {
    return 'خسرنا ركلات الترجيح أمام $opponent. لم يستحق أحد ذلك.';
  }

  @override
  String yLostShootout3(String opponent) {
    return 'خرجنا بركلات الترجيح أمام $opponent. ركلات الجزاء حسمتها.';
  }

  @override
  String yLostShootout4(String opponent) {
    return '$opponent يتأهل بركلات الترجيح. بطولتنا تنتهي هنا.';
  }

  @override
  String yLostShootout5(String opponent) {
    return 'خسرنا ركلات الترجيح أمام $opponent. ركلات الجزاء مرة أخرى.';
  }

  @override
  String yLostShootout6(String opponent) {
    return 'خرجنا بركلات الترجيح أمام $opponent. هل نتدرب عليها أصلًا؟';
  }

  @override
  String yLostShootout7(String opponent) {
    return 'خسرنا أمام $opponent بركلات الترجيح. كان يجب أن نحسمها قبل ذلك بكثير.';
  }

  @override
  String yLostShootout8(String opponent) {
    return 'ركلات ترجيح أمام $opponent، وخسرناها. بالطبع خسرناها.';
  }

  @override
  String yKnockoutLoss0(String opponent, String score) {
    return 'خرجنا. ⁦$score⁩ أمام $opponent. مشوار نفخر به ينتهي هنا.';
  }

  @override
  String yKnockoutLoss1(String opponent, String score) {
    return 'أقصانا $opponent، ⁦$score⁩. شكرًا على الذكريات.';
  }

  @override
  String yKnockoutLoss2(String opponent, String score) {
    return '⁦$score⁩ أمام $opponent. انتهت الرحلة، لكن يا لها من رحلة.';
  }

  @override
  String yKnockoutLoss3(String opponent, String score) {
    return 'إقصاء: ⁦$score⁩ أمام $opponent. الرؤوس مرفوعة.';
  }

  @override
  String yKnockoutLoss4(String opponent, String score) {
    return 'خارج المنافسة: ⁦$score⁩ أمام $opponent.';
  }

  @override
  String yKnockoutLoss5(String opponent, String score) {
    return 'خرجنا: ⁦$score⁩ أمام $opponent.';
  }

  @override
  String yKnockoutLoss6(String opponent, String score) {
    return '$opponent يتأهل، ⁦$score⁩. بطولتنا انتهت.';
  }

  @override
  String yKnockoutLoss7(String opponent, String score) {
    return 'أقصانا $opponent، ⁦$score⁩. التحقيق يبدأ الآن.';
  }

  @override
  String yKnockoutLoss8(String opponent, String score) {
    return 'خرجنا. ⁦$score⁩ أمام $opponent. بطولة أخرى، والنهاية نفسها.';
  }

  @override
  String yKnockoutLoss9(String opponent, String score) {
    return '⁦$score⁩ أمام $opponent، وإلى الديار. لا أحد متفاجئ.';
  }

  @override
  String yKnockoutLoss10(String opponent, String score) {
    return 'أقصانا $opponent، ⁦$score⁩. توقعوا الأعذار بحلول الصباح.';
  }

  @override
  String yKnockoutLoss11(String opponent, String score) {
    return '$opponent ⁦$score⁩. خرجنا، ولم يبدُ أن الأمر سيسير بغير ذلك.';
  }

  @override
  String yAwayFansGloat0(String nation, String score) {
    return '⁦$score⁩ أمام $nation. كل الاحترام لهم، سيعودون أقوى.';
  }

  @override
  String yAwayFansGloat1(String nation, String score) {
    return 'فوز جيد لنا، ⁦$score⁩. يوم سيئ لـ$nation، وأتعاطف مع جماهيرهم.';
  }

  @override
  String yAwayFansGloat2(String nation, String score) {
    return '⁦$score⁩. مرّ $nation بليلة سيئة واغتنمنا فرصتنا. هذا عادل.';
  }

  @override
  String yAwayFansGloat3(String nation, String score) {
    return '⁦$score⁩ أمام $nation! من توقع ذلك؟ ليس هم.';
  }

  @override
  String yAwayFansGloat4(String nation, String score) {
    return 'هزمنا $nation ⁦$score⁩. فليطمئن أحد على جماهيرهم.';
  }

  @override
  String yAwayFansGloat5(String nation, String score) {
    return '$nation ⁦$score⁩. هذه ستدخل ألبوم الصور.';
  }

  @override
  String yAwayFansGloat6(String nation, String score) {
    return '⁦$score⁩ أمام $nation. ويظنون أنهم فريق كبير.';
  }

  @override
  String yAwayFansGloat7(String nation, String score) {
    return 'تخيّل أن تخسر ⁦$score⁩ أمامنا. اسألوا $nation، صاروا يعرفون الآن.';
  }

  @override
  String yAwayFansGloat8(String nation, String score) {
    return '$nation، ⁦$score⁩. رحلة عودة ممتعة.';
  }

  @override
  String yNeutralLoss0(String nation, String opponent, String score) {
    return '$nation ⁦$score⁩ $opponent. ليلة رائعة لـ$opponent، وصعبة على $nation.';
  }

  @override
  String yNeutralLoss1(String nation, String opponent, String score) {
    return 'أتعاطف مع جماهير $nation بعد ⁦$score⁩ أمام $opponent. سينهضون من جديد.';
  }

  @override
  String yNeutralLoss2(String nation, String opponent, String score) {
    return '$nation ⁦$score⁩ $opponent. كل فريق كبير يمر بليلة كهذه.';
  }

  @override
  String yNeutralLoss3(String nation, String opponent, String score) {
    return 'مفاجأة الجولة: $nation ⁦$score⁩ $opponent.';
  }

  @override
  String yNeutralLoss4(String nation, String opponent, String score) {
    return '$nation ⁦$score⁩ $opponent. لم يتوقع أحد تلك.';
  }

  @override
  String yNeutralLoss5(String nation, String opponent, String score) {
    return 'نتيجة اليوم: $nation ⁦$score⁩ $opponent. أسئلة أمام $nation الآن.';
  }

  @override
  String yNeutralLoss6(String nation, String opponent, String score) {
    return '$nation ⁦$score⁩ $opponent. ليست حادثة معزولة، إن كنتم تتابعون.';
  }

  @override
  String yNeutralLoss7(String nation, String opponent, String score) {
    return '$nation ⁦$score⁩ $opponent. لدى أحدهم هناك الكثير ليشرحه.';
  }

  @override
  String yNeutralLoss8(String nation, String opponent, String score) {
    return '$nation ⁦$score⁩ $opponent. اسم كبير، أداء صغير.';
  }

  @override
  String yDownGap0(String opponent, int gap) {
    return 'كان $opponent متأخرًا عنا بـ$gap مركزًا. هذا يحدث. امضوا قدمًا.';
  }

  @override
  String yDownGap1(int gap) {
    return 'الفارق في التصنيف: $gap مركزًا لصالحنا. كرة القدم لا تقرأ التصنيفات.';
  }

  @override
  String yDownGap2(String opponent, int gap) {
    return '$gap مركزًا بيننا وبين $opponent على الورق. ليس على أرض الملعب الليلة.';
  }

  @override
  String yDownGap3(String opponent, int gap) {
    return 'الفارق في التصنيف قبل البداية: $gap مركزًا لصالحنا. ومع ذلك خسرنا أمام $opponent.';
  }

  @override
  String yDownGap4(String opponent, int gap) {
    return 'كان $opponent متأخرًا عنا بـ$gap مركزًا في التصنيف العالمي. النتيجة: هزيمة.';
  }

  @override
  String yDownGap5(String opponent, int gap) {
    return 'مؤشر المفاجأة: $gap مركزًا في التصنيف، بالاتجاه المعاكس، أمام $opponent.';
  }

  @override
  String yDownGap6(String opponent, int gap) {
    return 'متقدمون على $opponent بـ$gap مركزًا في التصنيف. وخسرنا. فسّروا ذلك.';
  }

  @override
  String yDownGap7(int gap) {
    return 'خسرنا أمام فريق متأخر عنا بـ$gap مركزًا. دعوا هذا الرقم يستقر في أذهانكم.';
  }

  @override
  String yDownGap8(String opponent, int gap) {
    return 'الفارق في التصنيف: $gap مركزًا. خسرنا أمام $opponent. على أحدهم أن يعدّ الأيام.';
  }

  @override
  String yDrewHeroic0(String opponent, String score) {
    return '⁦$score⁩ أمام $opponent! تعادل بطعم الفوز.';
  }

  @override
  String yDrewHeroic1(String opponent, String score) {
    return 'أوقفنا $opponent ⁦$score⁩. فخور بكل واحد منهم.';
  }

  @override
  String yDrewHeroic2(String opponent, String score) {
    return '$opponent ⁦$score⁩. كانوا المرشحين وجاريناهم.';
  }

  @override
  String yDrewHeroic3(String opponent, String score) {
    return '⁦$score⁩ مع $opponent. نقطة انتُزعت بالدم والعرق.';
  }

  @override
  String yDrewHeroic4(String opponent, String score) {
    return '⁦$score⁩ أمام $opponent. نقطة جيدة جدًا.';
  }

  @override
  String yDrewHeroic5(String opponent, String score) {
    return 'تعادلنا ⁦$score⁩ مع $opponent. قلّة توقعوا أي شيء.';
  }

  @override
  String yDrewHeroic6(String opponent, String score) {
    return 'أوقفنا $opponent، ⁦$score⁩. نتيجة يُبنى عليها.';
  }

  @override
  String yDrewHeroic7(String opponent, String score) {
    return '⁦$score⁩ أمام $opponent. نقطة لم يمنحنا إياها أحد.';
  }

  @override
  String yDrewHeroic8(String opponent, String score) {
    return '⁦$score⁩ مع $opponent. نقطة جيدة، لكن لا أحد يفوز بشيء بالتعادلات.';
  }

  @override
  String yDrewHeroic9(String opponent, String score) {
    return 'أوقفنا $opponent ⁦$score⁩. جميل. ولم تكن لدينا أي تسديدة تستحق الذكر.';
  }

  @override
  String yDrewHeroic10(String opponent, String score) {
    return '$opponent ⁦$score⁩. نقطة، والجميع يتصرف وكأننا فزنا باللقب.';
  }

  @override
  String yDrewHeroic11(String opponent, String score) {
    return '⁦$score⁩ أمام $opponent. ركنّا الحافلة وابتسم لنا الحظ.';
  }

  @override
  String yDrewShame0(String opponent, String score) {
    return '⁦$score⁩ مع $opponent. محبط، لكننا ما زلنا بلا هزيمة.';
  }

  @override
  String yDrewShame1(String opponent, String score) {
    return 'أوقفنا $opponent ⁦$score⁩. يوم سيئ. هذا يحدث.';
  }

  @override
  String yDrewShame2(String opponent, String score) {
    return '$opponent ⁦$score⁩. ليس جيدًا بما يكفي، واللاعبون يعرفون ذلك.';
  }

  @override
  String yDrewShame3(String opponent, String score) {
    return '⁦$score⁩ أمام $opponent. نقطتان ضائعتان، لا أكثر.';
  }

  @override
  String yDrewShame4(String opponent, String score) {
    return '⁦$score⁩ مع $opponent. نقطتان مهدرتان.';
  }

  @override
  String yDrewShame5(String opponent, String score) {
    return 'أوقفنا $opponent ⁦$score⁩. نتيجة سيئة، مهما جمّلتموها.';
  }

  @override
  String yDrewShame6(String opponent, String score) {
    return '$opponent ⁦$score⁩. تعادل بطعم الهزيمة.';
  }

  @override
  String yDrewShame7(String opponent, String score) {
    return '⁦$score⁩ أمام $opponent. يجب أن نفوز بمثل هذه بسهولة.';
  }

  @override
  String yDrewShame8(String opponent, String score) {
    return '⁦$score⁩ مع $opponent. محرج.';
  }

  @override
  String yDrewShame9(String opponent, String score) {
    return 'أوقفنا $opponent، ⁦$score⁩. من المسؤول عن هذا؟';
  }

  @override
  String yDrewShame10(String opponent, String score) {
    return '$opponent ⁦$score⁩. إن لم نستطع هزيمتهم، فمن سنهزم؟';
  }

  @override
  String yDrewShame11(String opponent, String score) {
    return '⁦$score⁩ مع $opponent. جماهيرهم تحتفل بالتعادل معنا. فكروا في ذلك.';
  }

  @override
  String yTrophy0(String opponent) {
    return 'أبطال. $opponent. قولوها بصوت عالٍ.';
  }

  @override
  String yTrophy1(String opponent) {
    return 'فزنا بها. $opponent. لست بخير.';
  }

  @override
  String yTrophy2(String opponent) {
    return '$opponent، والكأس عائدة إلى الديار.';
  }

  @override
  String yTrophy3(String opponent) {
    return 'كل واحد منهم أسطورة. $opponent.';
  }

  @override
  String yRunnerUp0(String opponent) {
    return 'قريبون جدًا. $opponent وميدالية لا يريدها أحد.';
  }

  @override
  String yRunnerUp1(String opponent) {
    return 'الوصافة في $opponent. ستؤلم لسنوات.';
  }

  @override
  String yRunnerUp2(String opponent) {
    return '$opponent: على بُعد مباراة من كل شيء.';
  }

  @override
  String yRunnerUp3(String opponent) {
    return 'الثاني. في $opponent. فليناولني أحدهم المناديل.';
  }

  @override
  String yEliminated0(String opponent) {
    return 'خرجنا من $opponent. ستؤلمنا هذه لفترة.';
  }

  @override
  String yEliminated1(String opponent) {
    return '$opponent هي حيث تنتهي رحلتنا.';
  }

  @override
  String yEliminated2(String opponent) {
    return 'خرجنا من $opponent. والآن التحقيق.';
  }

  @override
  String yEliminated3(String opponent) {
    return 'أُقصينا من $opponent. فليشرح لي أحد ذلك.';
  }

  @override
  String yQualified0(String opponent) {
    return 'نحن ذاهبون إلى $opponent.';
  }

  @override
  String yQualified1(String opponent) {
    return 'تأهلنا إلى $opponent. احجزوا إجازاتكم من العمل.';
  }

  @override
  String yQualified2(String opponent) {
    return '$opponent، نحن قادمون. لم يكن هناك شك قط (كان هناك شك كبير).';
  }

  @override
  String yQualified3(String opponent) {
    return 'تأهلنا إلى $opponent. أُنجز الجزء الصعب.';
  }

  @override
  String yGroupDrawn0(String opponent) {
    return 'سُحبت المجموعات لـ$opponent. كان يمكن أن يكون أسوأ. أسوأ بكثير.';
  }

  @override
  String yGroupDrawn1(String opponent) {
    return 'إذن هذه قرعة $opponent. مثيرة للاهتمام.';
  }

  @override
  String yGroupDrawn2(String opponent) {
    return 'صدرت مجموعات $opponent ولا تعجبني مجموعتنا بالفعل.';
  }

  @override
  String yGroupDrawn3(String opponent) {
    return 'أُجريت قرعة $opponent. فلتبدأ المبالغات.';
  }

  @override
  String yHostNamed0(String opponent) {
    return '$opponent ستستضيفها. ابدأوا الادخار.';
  }

  @override
  String yHostNamed1(String opponent) {
    return 'ستذهب إلى $opponent. متوقع، لكن لا بأس.';
  }

  @override
  String yHostNamed2(String opponent) {
    return '$opponent تنال البطولة. تهانينا لهم، على ما أظن.';
  }

  @override
  String yHostNamed3(String opponent) {
    return 'المستضيف مؤكد: $opponent.';
  }

  @override
  String yTournamentSoon0(String opponent) {
    return '$opponent تبدأ قريبًا ولا أستطيع الجلوس ساكنًا.';
  }

  @override
  String yTournamentSoon1(String opponent) {
    return 'لم يتبقَّ الكثير على $opponent.';
  }

  @override
  String yTournamentSoon2(String opponent) {
    return '$opponent على الأبواب. أعلنوا القائمة من فضلكم.';
  }

  @override
  String yTournamentSoon3(String opponent) {
    return 'العد التنازلي لـ$opponent أصبح رسميًا لا يُحتمل.';
  }

  @override
  String get navY => 'Y';

  @override
  String get yTitle => 'Y';

  @override
  String get yEmpty => 'لا شيء يُقال بعد. العب مباراة.';

  @override
  String get yEarlierHeading => 'في وقت سابق من هذه الدورة';

  @override
  String get yTraitLoyalist =>
      'يدعم الفريق مهما حدث. بطيء في الانقلاب، سريع في المسامحة.';

  @override
  String get yTraitCynic => 'يتوقع الأسوأ ويفرح حين يثبت أنه محق.';

  @override
  String get yTraitNostalgic => 'كل شيء كان أفضل من قبل. يقارنك برجال اعتزلوا.';

  @override
  String get yTraitStatshead => 'ينشر الأرقام ولا شيء غيرها. بالكاد لديه مزاج.';

  @override
  String get yTraitHypeman => 'نتيجتان جيدتان وهذا جيل ذهبي.';

  @override
  String get yTraitContrarian => 'أيًا كان رأي الجميع، فهو العكس.';

  @override
  String get yTraitDoomer => 'سيسوء الأمر. سيسوء دائمًا.';

  @override
  String get yProfilePosts => 'المنشورات';

  @override
  String get yProfileEmpty => 'لا شيء من هذا الحساب بعد.';

  @override
  String hubEventGrievance(String player) {
    return '$player يريد كلمة معك';
  }

  @override
  String get hubEventGrievanceSub => 'يريد أن يعرف موقعه';

  @override
  String hubEventManagerSkills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count نقطة مهارة لإنفاقها',
      many: '$count نقطة مهارة لإنفاقها',
      few: '$count نقاط مهارة لإنفاقها',
      two: 'نقطتا مهارة لإنفاقهما',
      one: 'نقطة مهارة واحدة لإنفاقها',
      zero: 'لا نقاط مهارة لإنفاقها',
    );
    return '$_temp0';
  }

  @override
  String get hubEventManagerSkillsSub => 'ما تجيده يجعل فريقك أفضل';

  @override
  String get grievanceTitle => 'كلمة في مكتبك';

  @override
  String grievanceGameTime(String player) {
    return '$player موجود في القائمة ولم يلمس الكرة. يريد أن يعرف السبب.';
  }

  @override
  String grievanceSquadPlace(String player) {
    return '$player ليس في القائمة ولا يفهم السبب. يريد جوابًا واضحًا، في أي اتجاه.';
  }

  @override
  String grievanceRole(String player) {
    return '$player يُشرك باستمرار في غير مركزه وقد طفح كيله.';
  }

  @override
  String get grievanceReassure => 'أنت ضمن خططي';

  @override
  String get grievanceHonest => 'أنت خلف آخرين، وإليك السبب';

  @override
  String get grievanceDismiss => 'أنا من يختار الفريق';

  @override
  String yScorerStar0(String name, int goals) {
    return 'سجّل $name $goals منها. لا أحد يقترب منه.';
  }

  @override
  String yScorerStar1(String name, int goals) {
    return '$goals لـ$name. إنه يحمل هذا الفريق.';
  }

  @override
  String yScorerStar2(String name, int goals) {
    return '⁦$name: $goals⁩ في هذا اليوم. يا له من لاعب.';
  }

  @override
  String yScorerStar3(String name, int goals) {
    return 'وضع $name $goals في شباكهم. انحنِ للجمهور.';
  }

  @override
  String yScorerStar4(String name, int goals) {
    return '$goals لـ$name، والبقية كانوا مجرد ركاب.';
  }

  @override
  String yScorerStar5(String name, int goals) {
    return '$name مجددًا. $goals. تخيلوا هذا الفريق من دونه.';
  }

  @override
  String yScorerStar6(String name, int goals) {
    return '$goals من $name. لا ينبغي لرجل واحد أن يفعل كل هذا.';
  }

  @override
  String yScorerStar7(String name, int goals) {
    return 'أزيلوا $name من المعادلة وستكون $goals أقل وعصرًا مختلفًا تمامًا.';
  }

  @override
  String yWinStreak0(int count) {
    return '$count على التوالي. أيًا كان ما يُقال في غرفة الملابس، فهو يصل.';
  }

  @override
  String yWinStreak1(int count) {
    return 'هذه $count متتالية. الفرق لا تتعثر بالصدفة في سلاسل كهذه.';
  }

  @override
  String yWinStreak2(int count) {
    return '$count على التوالي والعدّ مستمر. الثقة واضحة من المدرجات.';
  }

  @override
  String yWinStreak3(int count) {
    return 'بلا هزيمة في $count. اسألوا أي مدرب: هذا هو الجزء الصعب.';
  }

  @override
  String yWinStreak4(int count) {
    return '$count على التوالي. استمتعوا ما دامت المواعيد رحيمة.';
  }

  @override
  String yWinStreak5(int count) {
    return '$count متتالية، ولم نهزم أحدًا ذا شأن.';
  }

  @override
  String yWinStreak6(int count) {
    return 'سلسلة من $count. اسألوني مجددًا حين تُختبر.';
  }

  @override
  String yWinStreak7(int count) {
    return '$count متتالية. كل فريق لديه سلسلة كهذه مرة.';
  }

  @override
  String yLossStreak0(int count) {
    return '$count دون فوز الآن. في لحظة ما تنفد الأعذار.';
  }

  @override
  String yLossStreak1(int count) {
    return 'هذه $count على التوالي ضاعت. لم تعد كبوة عابرة.';
  }

  @override
  String yLossStreak2(int count) {
    return '$count هزائم متتالية. على أحدهم أن يُحاسَب.';
  }

  @override
  String yLossStreak3(int count) {
    return 'بلا فوز في $count. يمكنكم رؤية ذلك في طريقة لعبهم.';
  }

  @override
  String yLossStreak4(int count) {
    return '$count دون فوز والأخطاء نفسها كل أسبوع.';
  }

  @override
  String yLossStreak5(int count) {
    return '$count على التوالي. أيًا كان ما يُجرَّب، فهو لا ينجح.';
  }

  @override
  String yLossStreak6(int count) {
    return '$count متتالية. هذا اتجاه، لا انخفاض عابر.';
  }

  @override
  String yLossStreak7(int count) {
    return 'بلا فوز في $count، ولم يقل أحد في الإدارة كلمة.';
  }

  @override
  String yRivalry0(String opponent, String score) {
    return '$opponent ⁦$score⁩. قولوا ما شئتم عن الأداء. هذه تُحتسب مرتين.';
  }

  @override
  String yRivalry1(String opponent, String score) {
    return 'أمام $opponent تحديدًا. ⁦$score⁩. لن ينساها أحد هنا.';
  }

  @override
  String yRivalry2(String opponent, String score) {
    return '⁦$score⁩ أمام $opponent. هذه التي سيتحدثون عنها في المقاهي.';
  }

  @override
  String yRivalry3(String opponent, String score) {
    return 'الجيران، ⁦$score⁩. حُسم حق التفاخر لفترة.';
  }

  @override
  String yRivalry4(String opponent, String score) {
    return '$opponent ⁦$score⁩. أيًا كان ما يحدث هذا العام، لدينا هذه.';
  }

  @override
  String yRivalry5(String opponent, String score) {
    return '⁦$score⁩ أمام $opponent. بعضنا احتاجها أكثر من جدول الترتيب.';
  }

  @override
  String yRivalry6(String opponent, String score) {
    return '$opponent ⁦$score⁩. وسيردّونها في المرة القادمة، كعادتهم دائمًا.';
  }

  @override
  String yRivalry7(String opponent, String score) {
    return 'أمام $opponent، ⁦$score⁩. عام كامل من التذكير بهذه.';
  }

  @override
  String yInjuryBlow0(String name) {
    return '$name يخرج مصابًا. آخر ما يحتاجه هذا الفريق.';
  }

  @override
  String yInjuryBlow1(String name) {
    return 'خسارة $name تغيّر شكل كل شيء.';
  }

  @override
  String yInjuryBlow2(String name) {
    return '$name يعرج. احبسوا أنفاسكم.';
  }

  @override
  String yInjuryBlow3(String name) {
    return 'لا $name لفترة إذن. على أحدهم أن يتقدم.';
  }

  @override
  String yInjuryBlow4(String name) {
    return '$name غائب. بالطبع هو $name.';
  }

  @override
  String yInjuryBlow5(String name) {
    return 'من دون $name يصبح هذا فريقًا عاديًا جدًا.';
  }

  @override
  String yInjuryBlow6(String name) {
    return '$name مصاب مجددًا. على أحدهم أن يسأل لماذا.';
  }

  @override
  String yInjuryBlow7(String name) {
    return 'خسرنا $name، ولا أحد خلفه. هذه هي المشكلة الحقيقية.';
  }

  @override
  String ySentOff0(String name, String minute) {
    return 'بطاقة حمراء لـ$name في الدقيقة $minute والبلاد كلها تنقلب عليه. لقد قدّم لنا أكثر من معظمهم. دعوه.';
  }

  @override
  String ySentOff1(String name, String minute) {
    return '$name يُطرد بعد $minute دقيقة. قاسٍ. بعشرة لاعبين وما زلنا نحاول، وهذا يقول الكثير.';
  }

  @override
  String ySentOff2(String name, String minute) {
    return '$name، الدقيقة $minute، بطاقة حمراء. عشرة لاعبين من هناك.';
  }

  @override
  String ySentOff3(String name, String minute) {
    return 'طرد: $name في الدقيقة $minute. ليست أول مباراة تنقلب بقرار واحد.';
  }

  @override
  String ySentOff4(String name, String minute) {
    return 'رائع. $name يغادر في الدقيقة $minute ونحن بعشرة لاعبين. مجددًا.';
  }

  @override
  String ySentOff5(String name, String minute) {
    return 'طُرد $name بعد $minute دقيقة. من بالضبط يدرّب الانضباط هنا؟';
  }

  @override
  String ySentOff6(String name, String minute) {
    return '$minute دقيقة. هذا ما استطاع $name الحفاظ فيه على هدوئه. كرة قدم احترافية.';
  }

  @override
  String ySentOff7(String name, String minute) {
    return 'بطاقة حمراء لـ$name في الدقيقة $minute، ويُفترض أن أصدق أن هذا تقدم.';
  }

  @override
  String ySentOffAgain0(String name, String minute, String count) {
    return 'بطاقة حمراء أخرى، $name في الدقيقة $minute، ونحن الآن $count. كل واحد من الرجال الباقين في الملعب لديه صوتي.';
  }

  @override
  String ySentOffAgain1(String name, String minute, String count) {
    return 'بطاقة حمراء أخرى: $name، الدقيقة $minute. بقي $count في الملعب.';
  }

  @override
  String ySentOffAgain2(String name, String minute, String count) {
    return 'بطاقة حمراء أخرى. $name يغادر في الدقيقة $minute ونحن الآن $count. لا يُصدَّق.';
  }

  @override
  String ySentOffAgain3(String name, String minute, String count) {
    return '$name أيضًا، في الدقيقة $minute. بقي $count لاعبين. هل هناك أحد مسؤول فعلًا عن هذا الفريق؟';
  }

  @override
  String get yBoardPressure0 =>
      'المجلس صمت تمامًا. وهذه ليست علامة جيدة أبدًا.';

  @override
  String get yBoardPressure1 => 'يُقال إن مجلس الإدارة بدأ يطرح الأسئلة.';

  @override
  String get yBoardPressure2 => 'يمكنكم الشعور بالأرض تتحرك في الطابق العلوي.';

  @override
  String get yBoardPressure3 =>
      'لا أحد في الاتحاد يقول شيئًا داعمًا. استنتجوا بأنفسكم.';

  @override
  String get yBoardPressure4 => 'لم يدعمه أحد في الإدارة علنًا منذ أسابيع.';

  @override
  String get yBoardPressure5 => 'الاتحاد يسرّب ضد مدربه. كالعادة دائمًا.';

  @override
  String get yBoardPressure6 => 'حين يصمت المجلس، يكون قد قرر بالفعل.';

  @override
  String get yBoardPressure7 =>
      'سيتركون الأمر ينجرف حتى يصبح القرار بيد غيرهم.';

  @override
  String get yReplies => 'أيضًا عن هذه المباراة';

  @override
  String get yPlayerGrievance0 => 'سألت عن موقعي. ما زلت أنتظر الجواب.';

  @override
  String get yPlayerGrievance1 => 'أتدرب بجد. لا أستطيع فعل الكثير غير ذلك.';

  @override
  String get yPlayerGrievance2 => 'بعض الأسئلة لا تُطرح إلا مرة واحدة.';

  @override
  String get yPlayerGrievance3 => 'لم آتِ كل هذه المسافة لأحمل الصدريات.';

  @override
  String get playerHonoursTitle => 'الألقاب';

  @override
  String get awardGoldenBall => 'أفضل لاعب';

  @override
  String get awardGoldenBoot => 'الهداف';

  @override
  String get awardGoldenGlove => 'أفضل حارس';

  @override
  String get awardTeamOfTournament => 'التشكيلة المثالية للبطولة';

  @override
  String get awardPlayerOfYear => 'أفضل لاعب في العالم لهذا العام';

  @override
  String get awardYoungPlayerOfYear => 'أفضل لاعب شاب لهذا العام';

  @override
  String get playerClubHistory => 'المسيرة مع الأندية';

  @override
  String get playerCareerRecord => 'سجل المسيرة';

  @override
  String get playerInternationalGoals => 'الأهداف الدولية';

  @override
  String get playerRecentForm => 'المستوى الأخير';

  @override
  String get playerMatchHistory => 'سجل المباريات';

  @override
  String get playerAttributes => 'الصفات';

  @override
  String get playerUnknown => 'غير معروف';

  @override
  String get playerAttrPace => 'السرعة';

  @override
  String get playerAttrPhysical => 'البدنية';

  @override
  String get playerAttrTechnical => 'الفنيات';

  @override
  String get playerAttrShooting => 'التسديد';

  @override
  String get playerAttrPassing => 'التمرير';

  @override
  String get playerAttrDribbling => 'المراوغة';

  @override
  String get playerAttrTackling => 'الافتكاك';

  @override
  String get playerAttrPositioning => 'التمركز';

  @override
  String get playerAttrComposure => 'الهدوء';

  @override
  String get playerAttrDecisions => 'اتخاذ القرار';

  @override
  String get playerAttrStamina => 'التحمل';

  @override
  String get playerAttrStrength => 'القوة';

  @override
  String get playerStatCaps => 'المباريات الدولية';

  @override
  String get playerStatGoals => 'الأهداف';

  @override
  String get playerStatAssists => 'التمريرات الحاسمة';

  @override
  String get playerStatAvgRating => 'متوسط التقييم';

  @override
  String get playerStatForm => 'المستوى';

  @override
  String get playerStatMotm => 'رجل المباراة';

  @override
  String get playerStatCleanSheets => 'شباك نظيفة';

  @override
  String get playerStatBestGame => 'أفضل مباراة';

  @override
  String get playerStatCards => 'البطاقات';

  @override
  String playerCardsValue(int yellows, int reds) {
    return '$yellows ص $reds ح';
  }

  @override
  String get tourSharedYourRun => 'مشوارك';

  @override
  String get tourSharedList => 'قائمة';

  @override
  String get tourSharedBracket => 'المخطط';

  @override
  String get tourSharedVs => 'ضد';

  @override
  String tourSharedGroupSeed(String seed) {
    return 'المجموعة $seed';
  }

  @override
  String get tourSharedThisEdition => 'هذه النسخة';

  @override
  String get tourSharedAllTime => 'كل العصور';

  @override
  String get tourSharedUnknown => 'غير معروف';

  @override
  String get tourSharedActive => 'نشط';

  @override
  String get tourSharedMedalTable => 'جدول الميداليات';

  @override
  String get tourSharedPastWinners => 'الأبطال السابقون';

  @override
  String tourSharedHost(String host) {
    return 'المستضيف: $host';
  }

  @override
  String get tourSharedBeat => 'تغلّب على';

  @override
  String get tourSharedPens => ' (ترجيح)';

  @override
  String get tourSharedAwardsEmpty => 'تُحسم الجوائز بعد انتهاء البطولة.';

  @override
  String get tourSharedGoldenBall => 'أفضل لاعب';

  @override
  String get tourSharedPlayerOfTournament => 'أفضل لاعب في البطولة';

  @override
  String get tourSharedGoldenBoot => 'الهداف';

  @override
  String tourSharedGoalsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count هدف',
      many: '$count هدفًا',
      few: '$count أهداف',
      two: 'هدفان',
      one: 'هدف واحد',
      zero: '$count هدف',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedGoldenGlove => 'أفضل حارس';

  @override
  String get tourSharedTeamOfTournament => 'التشكيلة المثالية للبطولة';

  @override
  String get tourSharedStatsEmpty =>
      'تظهر الأرقام القياسية حين يصبح للمسابقة تاريخ.';

  @override
  String get tourSharedRecordScorer => 'الهداف التاريخي';

  @override
  String get tourSharedStillActive => 'لا يزال يلعب';

  @override
  String get tourSharedMostTitles => 'الأكثر ألقابًا';

  @override
  String tourSharedTitlesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count لقب',
      many: '$count لقبًا',
      few: '$count ألقاب',
      two: 'لقبان',
      one: 'لقب واحد',
      zero: '$count لقب',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostFinals => 'الأكثر بلوغًا للنهائي';

  @override
  String tourSharedFinalsContested(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مباراة نهائية',
      many: '$count مباراة نهائية',
      few: '$count مباريات نهائية',
      two: 'مباراتان نهائيتان',
      one: 'مباراة نهائية واحدة',
      zero: '$count مباراة نهائية',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostGamesPlayed => 'الأكثر خوضًا للمباريات';

  @override
  String tourSharedMatchesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مباراة',
      many: '$count مباراة',
      few: '$count مباريات',
      two: 'مباراتان',
      one: 'مباراة واحدة',
      zero: '$count مباراة',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostFinalsPlayed => 'الأكثر مشاركة في النهائيات';

  @override
  String tourSharedFinalsTournamentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count نسخة من النهائيات',
      many: '$count نسخة من النهائيات',
      few: '$count نسخ من النهائيات',
      two: 'نسختان من النهائيات',
      one: 'نسخة واحدة من النهائيات',
      zero: '$count نسخة',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedBiggestFinalWin => 'أكبر فوز في نهائي';

  @override
  String tourStatsGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count هدف',
      many: '$count هدفًا',
      few: '$count أهداف',
      two: 'هدفان',
      one: 'هدف واحد',
      zero: '$count هدف',
    );
    return '$_temp0';
  }

  @override
  String get tourStatsStillActive => 'لا يزال يلعب';

  @override
  String tourStatsTitles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count لقب',
      many: '$count لقبًا',
      few: '$count ألقاب',
      two: 'لقبان',
      one: 'لقب واحد',
      zero: '$count لقب',
    );
    return '$_temp0';
  }

  @override
  String tourStatsFinalsContested(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مباراة نهائية',
      many: '$count مباراة نهائية',
      few: '$count مباريات نهائية',
      two: 'مباراتان نهائيتان',
      one: 'مباراة نهائية واحدة',
      zero: '$count مباراة نهائية',
    );
    return '$_temp0';
  }

  @override
  String tourStatsMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مباراة',
      many: '$count مباراة',
      few: '$count مباريات',
      two: 'مباراتان',
      one: 'مباراة واحدة',
      zero: '$count مباراة',
    );
    return '$_temp0';
  }

  @override
  String tourStatsFinalsTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count نسخة من النهائيات',
      many: '$count نسخة من النهائيات',
      few: '$count نسخ من النهائيات',
      two: 'نسختان من النهائيات',
      one: 'نسخة واحدة من النهائيات',
      zero: '$count نسخة',
    );
    return '$_temp0';
  }

  @override
  String get tourStatsLeaders => 'المتصدرون عبر التاريخ';

  @override
  String get tourStatsTabGames => 'المباريات';

  @override
  String get tourStatsTabCups => 'البطولات';

  @override
  String get tourStatsTabScorers => 'الهدافون';

  @override
  String tourSharedFinalWinDetail(String opponent, int year) {
    return 'ضد $opponent · $year';
  }

  @override
  String get tourHolders => 'حامل اللقب';

  @override
  String tourHoldersSince(int year) {
    return 'فاز في $year';
  }

  @override
  String get tourSharedAllTimeScorers => 'الهدافون التاريخيون';

  @override
  String get tourSharedSummaryEmpty =>
      'يظهر المستضيف وملاعبه بعد إجراء قرعة هذه النسخة.';

  @override
  String get tourSharedHostHeading => 'المستضيف';

  @override
  String get tourSharedHostsHeading => 'المستضيفون';

  @override
  String get tourSharedCoHostsHeading => 'المستضيفون المشاركون';

  @override
  String get tourSharedVenues => 'الملاعب';

  @override
  String get tourSharedMapHeading => 'خريطة الاستضافة';

  @override
  String get tourSharedMapFit => 'عرض الخريطة كاملة';

  @override
  String get tourSharedMapFinalVenue => 'ملعب النهائي';

  @override
  String get tourSharedMapTapHint => 'اضغط على علامة لعرض الملعب';

  @override
  String get tourSharedMascot => 'التميمة';

  @override
  String get tourSharedMatchBall => 'كرة البطولة';

  @override
  String tourSharedVenueSeats(String city, String capacity) {
    return '$city · $capacity مقعد';
  }

  @override
  String get tourSharedCouldNotLoad => 'تعذّر التحميل.';

  @override
  String get tourSharedHostTbc => 'المستضيف لم يُحدَّد بعد';

  @override
  String get tourSharedFinalsAreHere => 'انطلقت النهائيات';

  @override
  String tourSharedHostedBy(String hosts) {
    return 'تستضيفها  $hosts';
  }

  @override
  String get tourSharedLetFinalsBegin => 'لتبدأ النهائيات';

  @override
  String get tourSharedCompetitions => 'المسابقات';

  @override
  String get tourSharedWorldRanking => 'التصنيف العالمي';

  @override
  String get tourSharedCouldNotLoadTournaments => 'تعذّر تحميل البطولات.';

  @override
  String get tourSharedPrestigeStage => 'مسرح النخبة';

  @override
  String get tourSharedOverview => 'نظرة عامة';

  @override
  String get tourSharedWorldRankingTitle => 'التصنيف العالمي';

  @override
  String get tourSharedYourCompetitions => 'مسابقاتك';

  @override
  String get tourSharedOtherContinents => 'قارات أخرى';

  @override
  String get tourSharedComingSoon => 'البطولة قريبًا';

  @override
  String get tourSharedSoon => 'قريبًا';

  @override
  String get tourSharedNoQualifyingDraw => 'لا توجد قرعة للتصفيات.';

  @override
  String get tourSharedOpenEnvelope => 'افتح الظرف';

  @override
  String tourSharedGroupName(String name) {
    return 'المجموعة $name';
  }

  @override
  String get tourSharedBall => 'كرة';

  @override
  String get tourSharedPot => 'مستوى';

  @override
  String get tourSharedAll => 'الكل';

  @override
  String get tourSharedTapDrawTeam => 'اضغط لسحب الفريق التالي';

  @override
  String get tourSharedTapDrawPot => 'اضغط لسحب المستوى التالي';

  @override
  String get tourSharedTapDrawAll => 'اضغط لكشف القرعة كاملة';

  @override
  String get tourSharedContinue => 'متابعة';

  @override
  String get tourSharedPause => 'إيقاف مؤقت';

  @override
  String get tourSharedPlay => 'تشغيل';

  @override
  String get tourSharedSkip => 'تخطٍّ';

  @override
  String tourSharedPotNumber(int number) {
    return 'المستوى $number';
  }

  @override
  String get tourSharedDrawComplete => 'اكتملت القرعة';

  @override
  String get tourSharedDrawing => 'جارٍ السحب…';

  @override
  String get tourContChampionship => 'البطولة';

  @override
  String get tourContTabSummary => 'الملخص';

  @override
  String get tourContTabQualifying => 'التصفيات';

  @override
  String get tourContTabFinals => 'النهائيات';

  @override
  String get tourContTabBracket => 'المخطط';

  @override
  String get tourContTabAwards => 'الجوائز';

  @override
  String get tourContTabScorers => 'الهدافون';

  @override
  String get tourContTabHistory => 'التاريخ';

  @override
  String get tourContTabRecords => 'الأرقام';

  @override
  String tourContCouldNotLoadCup(String error) {
    return 'تعذّر تحميل البطولة.\n$error';
  }

  @override
  String get tourContNoCupData => 'لا بيانات للبطولة.';

  @override
  String get tourContUnknown => 'غير معروف';

  @override
  String get tourContGroupsToBeDrawnQual =>
      'تُسحب مجموعات التصفيات في الحفل. شاهد من الرئيسية لتعرف منافسيك.';

  @override
  String get tourContQualSeeded =>
      'منتخبك متأهل مباشرة إلى النهائيات. لا تصفيات في هذه الدورة.';

  @override
  String tourContBackgroundRegion(String name) {
    return 'تُحاكى $name في الخلفية. تظهر النتائج هنا مع كل جولة.';
  }

  @override
  String get tourContGroupsToBeDrawnFinals =>
      'تُسحب مجموعات النهائيات في الحفل. شاهد من الرئيسية لتعرف مجموعتك.';

  @override
  String get tourContFinalsDrawAfterQual =>
      'تُجرى قرعة النهائيات بعد اكتمال التصفيات.';

  @override
  String get tourContContestedBeforeWc =>
      'تُلعب الأدوار الإقصائية قبل بطولة العالم.';

  @override
  String tourContChampionsHeading(String name) {
    return 'أبطال $name';
  }

  @override
  String tourContWinnersTitle(String name) {
    return 'أبطال $name';
  }

  @override
  String get tourContNoGoalsYet => 'لم تُسجَّل أهداف بعد.';

  @override
  String tourContGroupHeading(String name) {
    return 'المجموعة $name';
  }

  @override
  String get tourContBestRunnersUp => 'أفضل أصحاب المركز الثاني';

  @override
  String tourContGroupDropdown(String name) {
    return 'المجموعة $name';
  }

  @override
  String get tourContMatches => 'المباريات';

  @override
  String get tourContNoGroupsDrawn => 'لم تُسحب المجموعات بعد.';

  @override
  String get tourContQualifyingDraw => 'قرعة التصفيات';

  @override
  String get tourContWorldQualifyingDraw => 'قرعة تصفيات العالم';

  @override
  String get tourContFinalsDraw => 'قرعة النهائيات';

  @override
  String get tourContSeedingPots => 'مستويات التصنيف';

  @override
  String get tourContGroupDraw => 'قرعة المجموعات';

  @override
  String tourContCouldNotLoadDraw(String error) {
    return 'تعذّر تحميل القرعة.\n$error';
  }

  @override
  String get tourContDrawNotReady => 'القرعة ليست جاهزة بعد.';

  @override
  String get tourContContinentalClash => 'صدام القارات';

  @override
  String get tourContTabThisCycle => 'هذه الدورة';

  @override
  String tourContCouldNotLoadClash(String error) {
    return 'تعذّر التحميل.\n$error';
  }

  @override
  String get tourContNoSaveFound => 'لم يُعثر على ملف الحفظ.';

  @override
  String get tourContClashSoon =>
      'يُلعب صدام القارات بعد معرفة بطلَي القارتين.';

  @override
  String get tourContTwoContinentsOneMatch => 'قارتان، مباراة واحدة';

  @override
  String get tourContVersusShort => 'ضد';

  @override
  String tourContWinTheClash(String name) {
    return '$name يفوز بالصدام';
  }

  @override
  String get tourContNoClashYet => 'لم يُلعب صدام القارات بعد.';

  @override
  String get tourContNationsCup => 'كأس الأمم';

  @override
  String get tourContTabLeagues => 'الدوريات';

  @override
  String get tourContTabFinalsFour => 'المربع الذهبي';

  @override
  String tourContCouldNotLoad(String error) {
    return 'تعذّر التحميل.\n$error';
  }

  @override
  String get tourContNoNationsCupGoals => 'لم تُسجَّل أهداف في كأس الأمم بعد.';

  @override
  String get tourContNoNationsCupChampions =>
      'لم يُتوَّج أي بطل لكأس الأمم بعد.';

  @override
  String get tourContNationsCupOffSeason =>
      'تبدأ كأس الأمم لهذه الدورة بعد النهائيات القارية. الأبطال السابقون في قسم التاريخ.';

  @override
  String get tourContNationsCupGroupsSoon =>
      'تُسحب مجموعات كأس الأمم لهذه الدورة في الحفل. شاهد من الرئيسية لتعرف منافسيك.';

  @override
  String get tourContLeagueNoGroups =>
      'لا مباريات في هذا الدوري في هذه الجولة.';

  @override
  String tourContLeagueHeading(String letter) {
    return 'الدوري $letter';
  }

  @override
  String tourContLeagueHeadingYours(String letter) {
    return 'الدوري $letter · دوريك';
  }

  @override
  String get tourContFinalsFourSoon =>
      'يتنافس على المربع الذهبي متصدرو مجموعات الدوري A بعد انتهاء دور المجموعات.';

  @override
  String tourContLeagueChip(String letter) {
    return 'الدوري $letter';
  }

  @override
  String tourContLeagueChipStar(String letter) {
    return 'الدوري $letter ★';
  }

  @override
  String get tourContSemiFinals => 'نصف النهائي';

  @override
  String get tourContFinal => 'النهائي';

  @override
  String get tourContNationsCupDraw => 'قرعة كأس الأمم';

  @override
  String get tourContIntercontinentalPlayoff => 'الملحق العابر للقارات';

  @override
  String get tourContNoPlayoffThisCycle => 'لا ملحق في هذه الدورة.';

  @override
  String get tourContPlayoffIntro =>
      'مقعدان في بطولة العالم يُحسمان في أدوار إقصائية بين أفضل من فاتهم التأهل.';

  @override
  String get tourContPlayoffThrough => 'عبرت الملحق. أنت في بطولة العالم!';

  @override
  String get tourContPlayoffOut =>
      'لم تنجح في الملحق. لا بطولة عالم هذه المرة.';

  @override
  String get tourContContinue => 'متابعة';

  @override
  String get tourContPlayoffFinals => 'نهائيات الملحق';

  @override
  String get tourContPlayoffSeeded => 'مصنّف (إعفاء)';

  @override
  String get tourCupTabSummary => 'الملخص';

  @override
  String get tourCupTabQualifying => 'التصفيات';

  @override
  String get tourCupTabPlayoff => 'الملحق';

  @override
  String get tourCupPlayoffSoon =>
      'يُحسم الملحق العابر للقارات بعد اكتمال تصفيات كل الاتحادات القارية.';

  @override
  String get tourCupTabFinals => 'النهائيات';

  @override
  String get tourCupTabBracket => 'المخطط';

  @override
  String get tourCupTabAwards => 'الجوائز';

  @override
  String get tourCupTabScorers => 'الهدافون';

  @override
  String get tourCupTabHistory => 'التاريخ';

  @override
  String get tourCupTabRecords => 'الأرقام';

  @override
  String get tourCupTitle => 'بطولة العالم';

  @override
  String get tourCupNoData => 'لا بيانات للبطولة.';

  @override
  String tourCupLoadError(String error) {
    return 'تعذّر تحميل البطولة.\n$error';
  }

  @override
  String get tourCupUnknown => 'غير معروف';

  @override
  String get tourCupWorldChampions => 'أبطال العالم';

  @override
  String get tourCupWorldChampionsTitle => 'أبطال العالم';

  @override
  String get tourCupStillActive => 'لا يزال يلعب';

  @override
  String get tourCupAllTimeScorers => 'الهدافون التاريخيون';

  @override
  String get tourCupAllConfederations => 'كل الاتحادات القارية';

  @override
  String get tourCupBestRunnersUp => 'أفضل أصحاب المركز الثاني';

  @override
  String get tourCupCompWorld => 'بطولة العالم';

  @override
  String get tourCupCompEurope => 'بطولة أوروبا';

  @override
  String get tourCupCompSAmerica => 'كأس أمريكا الجنوبية';

  @override
  String get tourCupDestRoundOf16 => 'دور الـ16';

  @override
  String get tourCupDestKnockouts => 'الأدوار الإقصائية';

  @override
  String get tourCupDestFinals => 'النهائيات';

  @override
  String get tourCupDestFinalsPlayoff => 'ملحق النهائيات';

  @override
  String get tourCupDestIntercontPlayoff => 'الملحق العابر للقارات';

  @override
  String get tourCupFinalsDrawnAfterQual =>
      'تُسحب النهائيات بعد انتهاء التصفيات.';

  @override
  String get tourCupFinalsDrawSoon =>
      'المجموعات لم تُسحب بعد. شاهد قرعة بطولة العالم من الرئيسية لكشفها.';

  @override
  String tourCupGroupName(String name) {
    return 'المجموعة $name';
  }

  @override
  String tourCupGroupNameShort(String name) {
    return 'المجموعة $name';
  }

  @override
  String tourCupHostLabel(String host) {
    return 'تستضيفها $host';
  }

  @override
  String tourCupHostLabelMulti(String hosts) {
    return 'تستضيفها $hosts';
  }

  @override
  String get tourCupIntercontPlayoff => 'الملحق العابر للقارات';

  @override
  String get tourCupKnockoutSoon =>
      'تبدأ الأدوار الإقصائية بعد انتهاء دور المجموعات.';

  @override
  String get tourCupMatches => 'المباريات';

  @override
  String get tourCupMedalTable => 'جدول الميداليات';

  @override
  String get tourCupMostTitles => 'الأكثر ألقابًا';

  @override
  String tourCupMostTitlesValue(String nation, int titles, int editions) {
    String _temp0 = intl.Intl.pluralLogic(
      titles,
      locale: localeName,
      other: '$titles لقب',
      many: '$titles لقبًا',
      few: '$titles ألقاب',
      two: 'لقبان',
      one: 'لقب واحد',
      zero: '$titles لقب',
    );
    String _temp1 = intl.Intl.pluralLogic(
      editions,
      locale: localeName,
      other: '$editions نسخة',
      many: '$editions نسخة',
      few: '$editions نسخ',
      two: 'نسختين',
      one: 'نسخة واحدة',
      zero: '$editions نسخة',
    );
    return '$nation: $_temp0 من $_temp1';
  }

  @override
  String get tourCupNoGoals => 'لا أهداف بعد.';

  @override
  String get tourCupNoGroups => 'لم تُسحب المجموعات.';

  @override
  String get tourCupNoHistory => 'لا تاريخ بعد.';

  @override
  String get tourCupPastWinners => 'الأبطال السابقون';

  @override
  String get tourCupPlayoffIntro =>
      'مقعدان في بطولة العالم يُحسمان في أدوار إقصائية بين أفضل من فاتهم التأهل.';

  @override
  String tourCupPlayoffNoEntrants(String confederation) {
    return 'لا ملحق لـ$confederation: كل مقاعده تُحسم في مجموعات التصفيات.';
  }

  @override
  String get tourCupQualDrawSoon =>
      'المجموعات لم تُسحب بعد. شاهد قرعة التصفيات من الرئيسية لكشفها.';

  @override
  String tourCupRegionYours(String region) {
    return '$region · منطقتك';
  }

  @override
  String tourCupScorePens(int home, int away) {
    return '⁦$home–$away⁩ (ترجيح)';
  }

  @override
  String get tourCupSegAllTime => 'كل العصور';

  @override
  String get tourCupSegFinals => 'النهائيات';

  @override
  String get tourCupSegQualifying => 'التصفيات';

  @override
  String get playerTraitsTitle => 'يُعرف بـ';

  @override
  String get traitBigGame => 'لاعب المباريات الكبرى';

  @override
  String get traitBigGameBlurb => 'يرفع مستواه في الأدوار الإقصائية.';

  @override
  String get traitSetPiece => 'متخصص الكرات الثابتة';

  @override
  String get traitSetPieceBlurb =>
      'عرضيات أفضل، وأهداف أكثر من الكرات الثابتة.';

  @override
  String get traitHothead => 'عصبي';

  @override
  String get traitHotheadBlurb => 'ينال بطاقات أكثر بكثير من زملائه.';

  @override
  String get traitIronMan => 'الرجل الحديدي';

  @override
  String get traitIronManBlurb => 'نادرًا ما يُصاب ويتعب ببطء.';

  @override
  String get traitWonderkid => 'موهبة استثنائية';

  @override
  String get traitWonderkidBlurb => 'شاب، جيد بالفعل، ولا يزال يتطور بسرعة.';

  @override
  String get traitLeader => 'قائد';

  @override
  String get traitLeaderBlurb => 'يرفع مستوى كل زميل في الملعب.';

  @override
  String get traitPacey => 'سريع';

  @override
  String get traitPaceyBlurb => 'سرعة خارقة، وخطر خلف الدفاع.';

  @override
  String get traitOldHead => 'المخضرم';

  @override
  String get traitOldHeadBlurb => 'مخضرم تدوم قراءته للعب أكثر من ساقيه.';

  @override
  String get traitWasteful => 'مُهدر';

  @override
  String get traitWastefulBlurb => 'يضيّع الكثير من الفرص الجيدة.';

  @override
  String get objectiveWorldCup => 'بطولة العالم';

  @override
  String get objectiveWinTournament => 'الفوز باللقب';

  @override
  String get objectiveQualifyGeneric => 'التأهل';

  @override
  String hubBoardObjectiveFor(String competition, String label) {
    return '⁦$competition: $label⁩';
  }

  @override
  String get objectiveWinWorldCup => 'الفوز ببطولة العالم';

  @override
  String get objectiveReachFinal => 'بلوغ النهائي';

  @override
  String get objectiveReachSemis => 'بلوغ نصف النهائي';

  @override
  String get objectiveReachQuarters => 'بلوغ ربع النهائي';

  @override
  String get objectiveReachKnockouts => 'بلوغ الأدوار الإقصائية';

  @override
  String get objectiveQualify => 'التأهل إلى بطولة العالم';

  @override
  String get finishChampions => 'البطل';

  @override
  String get finishRunnersUp => 'الوصيف';

  @override
  String get finishSemiFinals => 'نصف النهائي';

  @override
  String get finishQuarterFinals => 'ربع النهائي';

  @override
  String get finishRoundOf16 => 'دور الـ16';

  @override
  String get finishGroupStage => 'دور المجموعات';

  @override
  String get objectiveQualifyingTopHalf => 'إنهاء التصفيات في النصف الأعلى';

  @override
  String get objectiveQualifyingChallenge =>
      'المنافسة على مقعد: النصف الأعلى من التصفيات على الأقل';

  @override
  String get finishQualifyingTopHalf => 'النصف الأعلى من مجموعة التصفيات';

  @override
  String get finishQualifyingBottomHalf => 'النصف الأدنى من مجموعة التصفيات';

  @override
  String get objectiveNcWinIt => 'الفوز بكأس الأمم';

  @override
  String get objectiveNcReachFinal => 'بلوغ نهائي كأس الأمم';

  @override
  String get objectiveNcFinalsFour => 'بلوغ المربع الذهبي';

  @override
  String get objectiveNcWinGroup => 'تصدّر المجموعة والصعود';

  @override
  String get objectiveNcTopHalf => 'إنهاء المجموعة في النصف الأعلى';

  @override
  String get objectiveNcSurvive => 'تجنّب الهبوط';

  @override
  String get objectiveNcOffTheBottom => 'تجنّب المركز الأخير في المجموعة';

  @override
  String get finishNcChampions => 'أبطال كأس الأمم';

  @override
  String get finishNcFinalsFour => 'المربع الذهبي';

  @override
  String get finishNcGroupWinners => 'متصدر المجموعة';

  @override
  String get finishNcTopHalf => 'النصف الأعلى من المجموعة';

  @override
  String get finishNcStayedUp => 'تجنّب الهبوط';

  @override
  String get finishNcClearOfBottom => 'بعيدًا عن قاع المجموعة';

  @override
  String get finishNcBottom => 'قاع المجموعة';

  @override
  String get careerNationsCupLabel => 'كأس الأمم';

  @override
  String get squadDevPlayer => 'اللاعب';

  @override
  String get squadDevAge => 'العمر';

  @override
  String get squadDevPosition => 'المركز';

  @override
  String get squadDevChange => 'التقييم';

  @override
  String get squadDevNew => 'جديد';

  @override
  String get squadDevRetired => 'معتزل';

  @override
  String get squadDevEmpty => 'عام مستقر. لا تغييرات في الفريق.';

  @override
  String get squadDevTierRegulars => 'الأساسيون';

  @override
  String get squadDevTierFringe => 'على الهامش';

  @override
  String get squadDevTierYouth => 'الشباب';

  @override
  String get boardObjectivesTitle => 'أهداف المجلس';

  @override
  String get boardObjectivesConfidence => 'ثقة المجلس';

  @override
  String boardObjectiveBeatenBy(String result, int rounds) {
    String _temp0 = intl.Intl.pluralLogic(
      rounds,
      locale: localeName,
      other: 'أفضل مما طُلب بـ$rounds دور',
      many: 'أفضل مما طُلب بـ$rounds دورًا',
      few: 'أفضل مما طُلب بـ$rounds أدوار',
      two: 'أفضل مما طُلب بدورين',
      one: 'أفضل مما طُلب بدور واحد',
      zero: 'كما طُلب',
    );
    return '$result: $_temp0';
  }

  @override
  String boardObjectiveShortBy(String result, int rounds) {
    String _temp0 = intl.Intl.pluralLogic(
      rounds,
      locale: localeName,
      other: 'أقل من المطلوب بـ$rounds دور',
      many: 'أقل من المطلوب بـ$rounds دورًا',
      few: 'أقل من المطلوب بـ$rounds أدوار',
      two: 'أقل من المطلوب بدورين',
      one: 'أقل من المطلوب بدور واحد',
      zero: 'كما طُلب',
    );
    return '$result: $_temp0';
  }

  @override
  String get boardObjectivesPending => 'لم يُحسم بعد';

  @override
  String boardObjectiveSoFar(String result) {
    return 'حتى الآن · $result';
  }

  @override
  String get boardObjectivesEmpty => 'لم يحدد المجلس هدفًا لهذه الدورة.';

  @override
  String get tourContBestWinners => 'أفضل متصدري المجموعات';

  @override
  String tourNcWinnersUp(int count, String league) {
    return 'أفضل $count يصعدون إلى الدوري $league';
  }

  @override
  String get tourContBestThirds => 'أفضل أصحاب المركز الثالث';

  @override
  String tourContBestPlaced(String position) {
    return 'أفضل أصحاب المركز $position';
  }

  @override
  String squadDevPageOf(String page, String pages, int total) {
    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: '$total لاعب',
      many: '$total لاعبًا',
      few: '$total لاعبين',
      two: 'لاعبان',
      one: 'لاعب واحد',
      zero: '$total لاعب',
    );
    return '⁦$page/$pages⁩ · $_temp0';
  }

  @override
  String get matchSoldOut => 'نفدت التذاكر';

  @override
  String matchAttendanceOf(String attendance, String capacity) {
    return '$attendance من $capacity مقعد مشغول';
  }

  @override
  String get matchGroundTitle => 'الملعب';

  @override
  String get absenceInjured => 'مصاب';

  @override
  String get absenceSuspended => 'موقوف';

  @override
  String absenceWeeks(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString أسبوع',
      many: '$countString أسبوعًا',
      few: '$countString أسابيع',
      two: 'أسبوعان',
      one: 'أسبوع واحد',
      zero: '$countString أسبوع',
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
      other: '$countString مباراة',
      many: '$countString مباراة',
      few: '$countString مباريات',
      two: 'مباراتان',
      one: 'مباراة واحدة',
      zero: '$countString مباراة',
    );
    return '$_temp0';
  }

  @override
  String absenceBackFor(String opponent) {
    return 'يعود أمام $opponent';
  }

  @override
  String get penaltyOrderTitle => 'ركلات الترجيح';

  @override
  String get penaltyOrderBlurb =>
      'حدد المسددين الخمسة بالترتيب. اضغط على خانة لتغييرها.';

  @override
  String penaltyOrderPick(int number) {
    return 'الركلة $number';
  }

  @override
  String get penaltyOrderPickBlurb =>
      'اختر من يتقدم. الشريط يمثل هدوءه على نقطة الجزاء.';

  @override
  String get penaltyOrderConfirm => 'لينفذوها';

  @override
  String get penaltyOrderCancel => 'رجوع';

  @override
  String get youthTitle => 'الشباب';

  @override
  String get youthEmptyLevel => 'لا أحد في هذا المستوى بعد.';

  @override
  String get youthReleased => 'سُرّح هذا العام';

  @override
  String get u21Title => 'تحت 21 عامًا';

  @override
  String get u21Blurb =>
      'الجيل القادم، الأفضل أولًا. النجوم المفرغة تقدير من الكشافين. استدعِ لاعبًا لتعرف حقيقة مستواه.';

  @override
  String get u21Empty =>
      'لا أحد تحت 21 عامًا في المجموعة الآن. الدفعة التالية تصل مع الدورة الجديدة.';

  @override
  String u21Breakout(int gain) {
    return '⁦+$gain⁩ هذا العام';
  }

  @override
  String u21AgeCaps(int age, int caps) {
    String _temp0 = intl.Intl.pluralLogic(
      caps,
      locale: localeName,
      other: '$caps مباراة دولية',
      many: '$caps مباراة دولية',
      few: '$caps مباريات دولية',
      two: 'مباراتان دوليتان',
      one: 'مباراة دولية واحدة',
      zero: '$caps مباراة دولية',
    );
    return 'العمر $age · $_temp0';
  }

  @override
  String u21AgeUncapped(int age) {
    return 'العمر $age · لم يلعب دوليًا';
  }

  @override
  String get u21CallUps => 'إلى الاستدعاءات';

  @override
  String get youthWatching => 'قيد المتابعة';

  @override
  String get youthWatchEmpty =>
      'لم تُعلِّم أحدًا بعد. علِّم أي فتى في أي مستوى وسيظهر هنا، مع ما أصبح عليه منذ ذلك الحين.';

  @override
  String get youthWatchMark => 'تابع هذا الفتى';

  @override
  String get youthWatchUnmark => 'أوقف متابعته';

  @override
  String youthWatchMarked(int rating, int age) {
    return 'عُلِّم بتقييم $rating، في عمر $age';
  }

  @override
  String get youthWatchSenior => 'انتقل إلى مجموعة الكبار';

  @override
  String get youthWatchReleased => 'سرّحته الأكاديمية';

  @override
  String get youthWatchGone => 'لم يعد في الهرم';

  @override
  String get tacticsYouth => 'تحت 21 عامًا';

  @override
  String get pressSquad => 'الفريق';

  @override
  String get pressBoard => 'المجلس';

  @override
  String get pressNoEffect => 'لا أحد يعطيها أهمية كبيرة';

  @override
  String get matchNeutralGround => 'محايد';

  @override
  String get matchExtraTimeAhead => 'الوقت الإضافي';

  @override
  String get matchExtraTimeHalf => 'الوقت الإضافي · استراحة';

  @override
  String get matchClockFullTime => 'نهاية المباراة';

  @override
  String get matchClockAfterExtraTime => 'بعد الوقت الإضافي';

  @override
  String get matchClockPenalties => 'ركلات الترجيح';

  @override
  String get pitchScoreboardGoal => 'هدف';

  @override
  String get matchClockFullTimePenalties => 'نهاية المباراة · ركلات الترجيح';

  @override
  String get hubEventPressConference => 'واجه الصحافة';

  @override
  String get hubEventPressConferenceSub =>
      'وسائل الإعلام العالمية تريد كلمة قبل مباراتك التالية';

  @override
  String get squadDevWonderkid => 'موهبة استثنائية';

  @override
  String get tacticsPlaystyle => 'أسلوب اللعب';

  @override
  String get tacticsPlaystyleBlurb =>
      'اختر أسلوب لعب الفريق؛ المؤشرات أدناه تضبطه بدقة.';

  @override
  String get tacticsPlaystyleCustom =>
      'إعداداتك الخاصة. لا أسلوب مسمّى يطابق هذه المؤشرات.';

  @override
  String get playstyleCustom => 'مخصص';

  @override
  String get playstyleBalanced => 'متوازن';

  @override
  String get playstylePossession => 'استحواذ';

  @override
  String get playstyleGegenpress => 'ضغط عكسي';

  @override
  String get playstyleCounter => 'هجمات مرتدة';

  @override
  String get playstyleDirect => 'مباشر';

  @override
  String get playstyleLowBlock => 'تكتل منخفض';

  @override
  String get playstyleWingPlay => 'اللعب على الأطراف';

  @override
  String get playstyleBalancedBlurb =>
      'متماسك في الشوطين، دون مبالغة في أي شيء.';

  @override
  String get playstylePossessionBlurb =>
      'احتفظ بالكرة، حرّكها بصبر، وضيّق الملعب.';

  @override
  String get playstyleGegenpressBlurb =>
      'استعدها لحظة فقدانها، في أعلى الملعب.';

  @override
  String get playstyleCounterBlurb => 'تراجع، ابقَ متقاربًا، ثم انطلق بسرعة.';

  @override
  String get playstyleDirectBlurb =>
      'إلى الأمام مبكرًا والعب على الكرة الثانية.';

  @override
  String get playstyleLowBlockBlurb => 'عميق، ضيق، ويصعب جدًا اختراقه.';

  @override
  String get playstyleWingPlayBlurb =>
      'وسّع الملعب، التفّ من الخارج وأرسل العرضيات.';

  @override
  String get nationsRandomTeam => 'فريق عشوائي';

  @override
  String get nationsFromTheBottom => 'من القاع';

  @override
  String get bottomStartTitle => 'عاطل عن العمل';

  @override
  String get bottomStartHeading => 'ثلاثة اتحادات تريد التحدث';

  @override
  String get bottomStartBlurb =>
      'لا وظيفة لديك ولا سمعة. هذه هي الفرق الوحيدة المستعدة للمراهنة عليك. اختر واحدًا وابنِ شيئًا من لا شيء.';

  @override
  String get bottomStartAccept => 'اقبل';

  @override
  String get bottomStartBack => 'العودة إلى القائمة';

  @override
  String bottomStartRankOf(int rank, int total) {
    return '$rank من $total في العالم';
  }

  @override
  String get campTitle => 'المعسكر';

  @override
  String campBasedIn(String host) {
    return 'المقر في $host';
  }

  @override
  String get campBlurb =>
      'حيث يقيم الفريق طوال البطولة. لا يمكن تغييره بعد انطلاق اللعب، ويؤثر في ثلاثة أشياء في كل مباراة: مدى نشاط اللاعبين عند الوصول، وسرعة شفاء الإصابات، وجاهزيتهم للمباريات.';

  @override
  String get campEffectTravel => 'الوصول بنشاط';

  @override
  String get campEffectRecovery => 'شفاء الإصابات';

  @override
  String get campEffectSharpness => 'جاهزية المباريات';

  @override
  String get campTerrainCity => 'وسط المدينة';

  @override
  String get campTerrainCoastal => 'منتجع ساحلي';

  @override
  String get campTerrainMountain => 'ملاذ جبلي';

  @override
  String get campTerrainAltitude => 'معسكر المرتفعات';

  @override
  String get campTerrainNationalCentre => 'المركز الوطني';

  @override
  String get campTerrainCityBlurb =>
      'كل شيء على بُعد خطوات ولا حاجة للسفر، لكن لا هدوء ولا مهرب من الضجيج.';

  @override
  String get campTerrainCoastalBlurb =>
      'هادئ، مريح وجيد للمزاج؛ رحلة حافلة طويلة إلى كل ملعب.';

  @override
  String get campTerrainMountainBlurb =>
      'هواء منعش وطاقم طبي من الطراز الأول يعالج الإصابات بسرعة، بعيدًا عن البطولة.';

  @override
  String get campTerrainAltitudeBlurb =>
      'التدريب فيه شاق، والأرجل تصمد حتى مراحل البطولة المتقدمة.';

  @override
  String get campTerrainNationalCentreBlurb =>
      'منشآت الاتحاد نفسه: لا شيء مذهل، ولا شيء يمكن أن يسوء.';

  @override
  String get hubEventChooseCamp => 'اختر المعسكر';

  @override
  String hubEventChooseCampSub(String host) {
    return 'مكان إقامة الفريق في $host';
  }

  @override
  String get tacticsTabBench => 'الدكة';

  @override
  String get squadSearchHint => 'ابحث بالاسم أو النادي';

  @override
  String get squadFilterAll => 'الجميع';

  @override
  String get squadFilterInSquad => 'في القائمة';

  @override
  String get squadFilterUncapped => 'لم يلعبوا دوليًا';

  @override
  String get squadFilterUnavailable => 'غير متاحين';

  @override
  String get squadLineAll => 'كل الخطوط';

  @override
  String get squadSortBy => 'ترتيب';

  @override
  String get squadSortRating => 'التقييم';

  @override
  String get squadSortCaps => 'المباريات الدولية';

  @override
  String get squadSortGoals => 'الأهداف';

  @override
  String get squadSortAge => 'العمر';

  @override
  String get squadSortName => 'الاسم';

  @override
  String get squadLegendTitle => 'معنى العلامات';

  @override
  String get squadLegendStarting => 'في تشكيلتك الأساسية';

  @override
  String get squadLegendCalledUp => 'مستدعى، على الدكة';

  @override
  String get squadLegendInjured => 'مصاب، غير متاح';

  @override
  String get squadLegendSuspended => 'موقوف، غير متاح';

  @override
  String get squadLegendTired => 'متعب (برتقالي) أو منهك (أحمر): أرحه مباراة';

  @override
  String get squadLegendShift =>
      'التغير الخاص بتقييمه في المباراة القادمة (المستوى، اللياقة، النادي)';

  @override
  String get squadLegendTraits => 'يُعرف بـ';

  @override
  String squadShowingOf(int shown, int total) {
    return 'عرض $shown من $total لاعب';
  }

  @override
  String get squadNobodyMatches => 'لا أحد في المجموعة يطابق هذه المرشحات.';

  @override
  String get squadStatPool => 'المجموعة';

  @override
  String get squadStatInSquad => 'المستدعون';

  @override
  String get squadMostCapped => 'الأكثر مشاركة دوليًا';

  @override
  String get squadTopScorer => 'الهداف';

  @override
  String squadCapsValue(String name, int caps) {
    String _temp0 = intl.Intl.pluralLogic(
      caps,
      locale: localeName,
      other: '$caps مباراة دولية',
      many: '$caps مباراة دولية',
      few: '$caps مباريات دولية',
      two: 'مباراتان دوليتان',
      one: 'مباراة دولية واحدة',
      zero: '$caps مباراة دولية',
    );
    return '$name · $_temp0';
  }

  @override
  String squadGoalsValue(String name, int goals) {
    String _temp0 = intl.Intl.pluralLogic(
      goals,
      locale: localeName,
      other: '$goals هدف',
      many: '$goals هدفًا',
      few: '$goals أهداف',
      two: 'هدفان',
      one: 'هدف واحد',
      zero: '$goals هدف',
    );
    return '$name · $_temp0';
  }

  @override
  String squadAgeClub(int age, String club) {
    return '$age · $club';
  }

  @override
  String get squadCapsShort => 'مباريات';

  @override
  String get squadGoalsShort => 'أهداف';

  @override
  String get recordsRecordBookSubtitle =>
      'المباريات الدولية والأهداف وأبرز أرقام الفريق';

  @override
  String get statsLegacy => 'الإرث';

  @override
  String tacticsSubAlreadyOff(String name) {
    return '$name خرج بالفعل ولا يمكنه العودة.';
  }

  @override
  String tacticsSubSentOff(String name) {
    return '$name طُرد ولن يشارك بعد الآن.';
  }

  @override
  String get tacticsInjuredShort => 'مصاب';

  @override
  String get tacticsSuspendedShort => 'موقوف';

  @override
  String get confEurope => 'أوروبا';

  @override
  String get confSouthAmerica => 'أمريكا الجنوبية';

  @override
  String get confNorthAmerica => 'أمريكا الشمالية';

  @override
  String get confAfrica => 'أفريقيا';

  @override
  String get confAsia => 'آسيا';

  @override
  String get confOceania => 'أوقيانوسيا';

  @override
  String get compWorldCup => 'بطولة العالم';

  @override
  String get compWorldCupFinals => 'نهائيات بطولة العالم';

  @override
  String get compWorldCupQualifying => 'تصفيات بطولة العالم';

  @override
  String compQualifiers(String region) {
    return 'تصفيات $region';
  }

  @override
  String get compFriendlies => 'المباريات الودية';

  @override
  String get compNationsCup => 'كأس الأمم';

  @override
  String get compContinentalClash => 'صدام القارات';

  @override
  String get compIntercontinentalPlayoff => 'الملحق العابر للقارات';

  @override
  String get compContinentalChampionship => 'البطولة القارية';

  @override
  String get compEuropeanChampionship => 'بطولة أوروبا';

  @override
  String get compSouthAmericaCup => 'كأس أمريكا الجنوبية';

  @override
  String get compAfricanChampionship => 'بطولة أفريقيا';

  @override
  String get compAsianChampionship => 'بطولة آسيا';

  @override
  String get compNorthAmericaCup => 'كأس أمريكا الشمالية';

  @override
  String get compOceaniaCup => 'كأس أوقيانوسيا';

  @override
  String get msgANation => 'منتخب';

  @override
  String get msgAPlayer => 'لاعب';

  @override
  String get msgAHostNation => 'دولة مستضيفة';

  @override
  String get msgCycleTitle1 => 'دورة جديدة تبدأ';

  @override
  String msgCycleTitle2(int year) {
    return 'الطريق إلى $year ينفتح';
  }

  @override
  String get msgCycleTitle3 => 'حملة جديدة تشرق';

  @override
  String get msgCycleTitle4 => 'العودة إلى العمل';

  @override
  String msgCycleBody1(int year) {
    return 'الطريق إلى بطولة العالم $year يبدأ هنا.';
  }

  @override
  String msgCycleBody2(int year) {
    return 'دورة جديدة. بطولة العالم $year هي الهدف.';
  }

  @override
  String msgCycleBody3(int year) {
    return 'أربع سنوات حتى بطولة العالم $year. العمل يبدأ الآن.';
  }

  @override
  String msgCycleBody4(int year) {
    return 'حملة $year تبدأ اليوم.';
  }

  @override
  String msgContHostTitle(String cup, String host) {
    return 'مستضيف ⁦$cup: $host⁩';
  }

  @override
  String msgContHostBody(String host, String cup) {
    return 'ستستضيف $host النسخة القادمة من $cup.';
  }

  @override
  String msgContQualDrawTitle(String cup) {
    return 'قرعة تصفيات $cup';
  }

  @override
  String msgContQualDrawBody(String cup) {
    return 'أُجريت قرعة مجموعات تصفيات $cup.';
  }

  @override
  String msgWcHostTitle(String host, int year) {
    return 'مستضيف بطولة العالم ⁦$year: $host⁩';
  }

  @override
  String msgWcHostBody(String host, int year) {
    return 'ستستضيف $host بطولة العالم $year.';
  }

  @override
  String get msgWcQualDrawTitle => 'قرعة تصفيات بطولة العالم';

  @override
  String get msgWcQualDrawBody => 'أُجريت قرعة مجموعات تصفيات بطولة العالم.';

  @override
  String msgContFinalsDrawTitle(String cup) {
    return 'قرعة نهائيات $cup';
  }

  @override
  String msgContFinalsDrawBody(String cup) {
    return 'أُجريت قرعة مجموعات نهائيات $cup.';
  }

  @override
  String get msgWcFinalsDrawTitle => 'قرعة نهائيات بطولة العالم';

  @override
  String msgWcFinalsDrawBody(int year) {
    return 'أُجريت قرعة نهائيات بطولة العالم $year.';
  }

  @override
  String get msgQualWcTitle1 => 'التأهل إلى بطولة العالم';

  @override
  String get msgQualWcTitle2 => 'حُجز المقعد في بطولة العالم';

  @override
  String get msgQualWcTitle3 => 'نحن ذاهبون إلى بطولة العالم';

  @override
  String get msgQualWcTitle4 => 'التذكرة في الجيب';

  @override
  String msgQualWcBody1(int year) {
    return 'تأهلت إلى نهائيات بطولة العالم $year.';
  }

  @override
  String msgQualWcBody2(int year) {
    return 'رسميًا: منتخبك في بطولة العالم $year.';
  }

  @override
  String msgQualWcBody3(int year) {
    return 'تأمّن مقعد في بطولة العالم $year.';
  }

  @override
  String msgQualWcBody4(int year) {
    return 'أنت متأهل إلى نهائيات بطولة العالم $year.';
  }

  @override
  String msgQualContTitle1(String cup) {
    return 'التأهل إلى $cup';
  }

  @override
  String msgQualContTitle2(String cup) {
    return 'حُجز المقعد في $cup';
  }

  @override
  String msgQualContTitle3(String cup) {
    return 'متأهل إلى $cup';
  }

  @override
  String msgQualContBody1(String cup) {
    return 'تأهلت إلى نهائيات $cup.';
  }

  @override
  String msgQualContBody2(String cup) {
    return 'حسم منتخبك مقعده في $cup.';
  }

  @override
  String msgQualContBody3(String cup) {
    return 'أنت متأهل إلى $cup.';
  }

  @override
  String msgChampTitleMine1(String comp) {
    return 'أبطال $comp!';
  }

  @override
  String msgChampTitleMine2(String comp) {
    return 'أبطال $comp!';
  }

  @override
  String msgChampTitleMine3(String comp) {
    return 'فزت بـ$comp!';
  }

  @override
  String msgChampTitleOther1(String comp) {
    return 'حُسمت $comp';
  }

  @override
  String msgChampTitleOther2(String comp) {
    return 'تتويج أبطال $comp';
  }

  @override
  String msgChampTitleOther3(String comp) {
    return '$comp لها بطل';
  }

  @override
  String msgChampBodyMine1(String comp, String loser, String result, int year) {
    return 'منتخبك بطل $comp $year، بعد الفوز على $loser$result.';
  }

  @override
  String msgChampBodyMine2(String comp, String loser, String result, int year) {
    return 'فزت بـ$comp $year، متغلبًا على $loser$result.';
  }

  @override
  String msgChampBodyMine3(String comp, String loser, String result, int year) {
    return '$comp $year لك. هُزم $loser$result.';
  }

  @override
  String msgChampBodyOther1(
    String winner,
    String comp,
    String loser,
    String result,
    int year,
  ) {
    return 'فاز $winner بـ$comp $year، بعد الفوز على $loser$result.';
  }

  @override
  String msgChampBodyOther2(
    String winner,
    String comp,
    String loser,
    String result,
    int year,
  ) {
    return '$winner بطل $comp $year، بعد هزيمة $loser$result.';
  }

  @override
  String msgFinalScoreSuffix(int home, int away) {
    return ' ⁦$home–$away⁩ في النهائي';
  }

  @override
  String msgFinalPensSuffix(int home, int away) {
    return ' بركلات الترجيح، بعد نهائي انتهى ⁦$home–$away⁩';
  }

  @override
  String get msgWpotyTitle => 'أفضل لاعب في العالم لهذا العام';

  @override
  String msgWpotyBodyMine(String name, String nation, int year) {
    return '$name ($nation) يُتوَّج أفضل لاعب في العالم لعام $year، وهو من لاعبيك.';
  }

  @override
  String msgWpotyBodyOther(String name, String nation, int year) {
    return '$name ($nation) يُتوَّج أفضل لاعب في العالم لعام $year.';
  }

  @override
  String get msgYpotTitle => 'أفضل لاعب شاب في البطولة';

  @override
  String msgYpotBodyMine(String name, String nation, int age, int year) {
    return '$name ($nation)، البالغ $age عامًا، يُتوَّج أفضل لاعب شاب في بطولة $year، وهو من لاعبيك.';
  }

  @override
  String msgYpotBodyOther(String name, String nation, int age, int year) {
    return '$name ($nation)، البالغ $age عامًا، يُتوَّج أفضل لاعب شاب في بطولة $year.';
  }

  @override
  String msgRankHold1(int rank) {
    return 'تحافظ على المركز #$rank.';
  }

  @override
  String msgRankHold2(int rank) {
    return 'لا تغيير، لا تزال #$rank.';
  }

  @override
  String msgRankHold3(int rank) {
    return 'ثابت في المركز #$rank.';
  }

  @override
  String msgRankUp1(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move مركز',
      many: '$move مركزًا',
      few: '$move مراكز',
      two: 'مركزين',
      one: 'مركز واحد',
      zero: '$move مركز',
    );
    return 'صعود بـ$_temp0 إجمالًا، إلى #$rank.';
  }

  @override
  String msgRankUp2(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move مركز',
      many: '$move مركزًا',
      few: '$move مراكز',
      two: 'مركزين',
      one: 'مركز واحد',
      zero: '$move مركز',
    );
    return 'صعود بـ$_temp0 يرفعك إلى #$rank.';
  }

  @override
  String msgRankUp3(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move مركز',
      many: '$move مركزًا',
      few: '$move مراكز',
      two: 'مركزين',
      one: 'مركز واحد',
      zero: '$move مركز',
    );
    return 'صعود بـ$_temp0، الآن #$rank.';
  }

  @override
  String msgRankDown1(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move مركز',
      many: '$move مركزًا',
      few: '$move مراكز',
      two: 'مركزين',
      one: 'مركز واحد',
      zero: '$move مركز',
    );
    return 'تراجع بـ$_temp0 إجمالًا، إلى #$rank.';
  }

  @override
  String msgRankDown2(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move مركز',
      many: '$move مركزًا',
      few: '$move مراكز',
      two: 'مركزين',
      one: 'مركز واحد',
      zero: '$move مركز',
    );
    return 'تراجع بـ$_temp0 يهبط بك إلى #$rank.';
  }

  @override
  String msgRankDown3(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move مركز',
      many: '$move مركزًا',
      few: '$move مراكز',
      two: 'مركزين',
      one: 'مركز واحد',
      zero: '$move مركز',
    );
    return 'تراجع بـ$_temp0، الآن #$rank.';
  }

  @override
  String get msgRankLeadYou => 'أنت في صدارة العالم.';

  @override
  String msgRankLeadOther(String nation) {
    return '$nation في صدارة العالم.';
  }

  @override
  String msgRankTitle(int rank) {
    return 'التصنيف العالمي · #$rank';
  }

  @override
  String msgRankBody(String lead, String movement) {
    return 'تم تحديث التصنيف العالمي. $lead $movement';
  }

  @override
  String msgRankJumpTitleUp(int rank) {
    return 'صعود إلى #$rank';
  }

  @override
  String msgRankJumpTitleDown(int rank) {
    return 'تراجع إلى #$rank';
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
      other: '$move مركز',
      many: '$move مركزًا',
      few: '$move مراكز',
      two: 'مركزين',
      one: 'مركز واحد',
      zero: '$move مركز',
    );
    return 'حرّكت $tournament التصنيف العالمي. دخل $nation في المركز #$from وخرج في #$to، بصعود $_temp0.';
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
      other: '$move مركز',
      many: '$move مركزًا',
      few: '$move مراكز',
      two: 'مركزين',
      one: 'مركز واحد',
      zero: '$move مركز',
    );
    return 'حرّكت $tournament التصنيف العالمي. دخل $nation في المركز #$from وخرج في #$to، بتراجع $_temp0.';
  }

  @override
  String get rankingSinceWcDraw => 'منذ قرعة بطولة العالم';

  @override
  String get rankingSinceCycleStart => 'منذ بداية الحملة';

  @override
  String rankingMovedFromTo(int from, int now) {
    return 'من #$from إلى #$now';
  }

  @override
  String get rankingSinceWcDrawShort => 'منذ قرعة البطولة';

  @override
  String get rankingSinceCycleStartShort => 'هذه الحملة';

  @override
  String get rankingTrend => 'اتجاه التصنيف';

  @override
  String msgCapsTitle(String name, int count) {
    return '$name يبلغ $count مباراة دولية';
  }

  @override
  String msgCapsBody(String name, int count) {
    return 'خاض $name الآن $count مباراة مع منتخبك.';
  }

  @override
  String msgGoalsTitle(String name, int count) {
    return '$name يبلغ $count هدفًا';
  }

  @override
  String msgGoalsBody(String name, int count) {
    return 'سجّل $name $count هدفًا دوليًا لمنتخبك.';
  }

  @override
  String msgDevTitle(int year) {
    return 'تطور الفريق · $year';
  }

  @override
  String msgThroughTitle(int year) {
    return 'صاعدون من الأكاديمية · $year';
  }

  @override
  String get msgThroughNote =>
      'هؤلاء ليسوا دفعة جديدة. إنهم الفتيان الذين دخلوا في الحادية عشرة وكبروا الآن ليصلوا إلى مجموعة الكبار.';

  @override
  String msgNewFacesTitle(int year) {
    return 'وجوه جديدة · $year';
  }

  @override
  String get msgIntakeNoteAcademy =>
      'استثمار الأكاديمية يؤتي ثماره: هذه الدفعة وصلت أقوى مما كانت ستكون.';

  @override
  String get msgIntakeNoteStanding =>
      'البلاد تتابع هذا الفريق: مع صعود المنتخب في التصنيف العالمي، يختار أفضل الفتيان كرة القدم، ووصلت هذه الدفعة أقوى بفضل ذلك.';

  @override
  String get msgIntakeNoteBoth =>
      'أموال الأكاديمية وصعود المنتخب في التصنيف العالمي يظهران معًا: هذه الدفعة وصلت أقوى مما كانت ستكون.';

  @override
  String msgIntakeTitle(int year) {
    return 'دفعة الأكاديمية · $year';
  }

  @override
  String msgRetireCaptainTitle(String name) {
    return 'قائدك $name يعتزل';
  }

  @override
  String msgRetireTitle(String name) {
    return '$name يعتزل اللعب الدولي';
  }

  @override
  String msgRetireBody(String name, int age) {
    return 'اعتزل $name اللعب الدولي في سن $age.';
  }

  @override
  String msgRetireBodyWith(String name, String tally, int age) {
    return 'اعتزل $name اللعب الدولي في سن $age، مودّعًا برصيد $tally.';
  }

  @override
  String msgTallyCaps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مباراة دولية',
      many: '$count مباراة دولية',
      few: '$count مباريات دولية',
      two: 'مباراتين دوليتين',
      one: 'مباراة دولية واحدة',
      zero: '$count مباراة دولية',
    );
    return '$_temp0';
  }

  @override
  String msgTallyGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count هدف',
      many: '$count هدفًا',
      few: '$count أهداف',
      two: 'هدفين',
      one: 'هدف واحد',
      zero: '$count هدف',
    );
    return '$_temp0';
  }

  @override
  String get msgArmbandVacant =>
      ' شارة القيادة شاغرة. عيّن قائدًا جديدًا من شاشة الاستدعاء.';

  @override
  String msgHofTitle(String name) {
    return '$name يدخل قاعة المشاهير';
  }

  @override
  String msgHofBody(String name, int caps, int goals) {
    String _temp0 = intl.Intl.pluralLogic(
      caps,
      locale: localeName,
      other: '$caps مباراة دولية',
      many: '$caps مباراة دولية',
      few: '$caps مباريات دولية',
      two: 'مباراتان دوليتان',
      one: 'مباراة دولية واحدة',
      zero: '$caps مباراة دولية',
    );
    String _temp1 = intl.Intl.pluralLogic(
      goals,
      locale: localeName,
      other: '$goals هدف',
      many: '$goals هدفًا',
      few: '$goals أهداف',
      two: 'هدفان',
      one: 'هدف واحد',
      zero: '$goals هدف',
    );
    return 'ينضم $name إلى قاعة مشاهير منتخبك ($_temp0، $_temp1). شاهده في الأساطير.';
  }

  @override
  String hubBanTitle(String name) {
    return 'إيقاف $name';
  }

  @override
  String hubBanBody(String name, String how, int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: 'في المباريات الـ$matches التالية',
      many: 'في المباريات الـ$matches التالية',
      few: 'في المباريات الـ$matches التالية',
      two: 'في المباراتين التاليتين',
      one: 'في مباراتك التالية',
      zero: '$matches مباراة',
    );
    return '$name $how وأُوقف $_temp0. لن يكون متاحًا للاختيار.';
  }

  @override
  String get hubBanHowSecondYellow => 'طُرد بإنذار ثانٍ';

  @override
  String get hubBanHowViolent => 'نال بطاقة حمراء مباشرة بسبب سلوك عنيف';

  @override
  String get hubBanHowRed => 'طُرد';

  @override
  String hubInjuryTitle(String name) {
    return 'إصابة $name';
  }

  @override
  String hubInjuryBody(String name, int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: '$matches مباراة',
      many: '$matches مباراة',
      few: '$matches مباريات',
      two: 'مباراتين',
      one: 'مباراة واحدة',
      zero: '$matches مباراة',
    );
    return 'تعرّض $name لإصابة وسيغيب $_temp0.';
  }

  @override
  String get hubRunnerUpTitle1 => 'الوصافة';

  @override
  String get hubRunnerUpTitle2 => 'قريب جدًا، وبعيد جدًا';

  @override
  String get hubRunnerUpTitle3 => 'الميداليات الفضية';

  @override
  String hubRunnerUpBody1(String cup, String opponent) {
    return 'بلغت نهائي $cup لكنك خسرت أمام $opponent. قريب جدًا. الفضة هذه المرة.';
  }

  @override
  String hubRunnerUpBody2(String cup, String opponent) {
    return 'هُزمت أمام $opponent في نهائي $cup. الوصافة، بفارق مؤلم.';
  }

  @override
  String hubRunnerUpBody3(String cup, String opponent) {
    return 'أفلت نهائي $cup أمام $opponent. الكثير مما يدعو للفخر، لكن ليس الكأس.';
  }

  @override
  String get hubKnockedOutTitle1 => 'الإقصاء';

  @override
  String get hubKnockedOutTitle2 => 'نهاية الطريق';

  @override
  String get hubKnockedOutTitle3 => 'انتهت الرحلة';

  @override
  String hubKnockedOutBody1(String cup, String opponent, String stage) {
    return 'خرجت من $cup، مهزومًا أمام $opponent في $stage.';
  }

  @override
  String hubKnockedOutBody2(String cup, String opponent, String stage) {
    return '$opponent ينهي مشوارك في $cup في $stage.';
  }

  @override
  String hubKnockedOutBody3(String cup, String opponent, String stage) {
    return 'ينتهي مشوارك في $cup في $stage، مهزومًا أمام $opponent.';
  }

  @override
  String get hubGroupExitTitle1 => 'الخروج من دور المجموعات';

  @override
  String get hubGroupExitTitle2 => 'خارج المنافسة من دور المجموعات';

  @override
  String get hubGroupExitTitle3 => 'خروج مبكر';

  @override
  String hubGroupExitBody1(String cup) {
    return 'انتهى مشوارك في $cup في دور المجموعات. لم يكن كافيًا لبلوغ الأدوار الإقصائية.';
  }

  @override
  String hubGroupExitBody2(String cup) {
    return 'فشلت في تجاوز المجموعة. ينتهي مشوارك في $cup هنا.';
  }

  @override
  String hubGroupExitBody3(String cup) {
    return 'لا مقعد في الأدوار الإقصائية هذه المرة. انتهى مشوارك في $cup في دور المجموعات.';
  }

  @override
  String boardObjectiveMetTitle(String comp) {
    return 'تحقق الهدف: $comp';
  }

  @override
  String boardObjectiveMissedTitle(String comp) {
    return 'لم يتحقق الهدف: $comp';
  }

  @override
  String boardObjectiveMetBody(String comp, String demand, String finish) {
    return 'هدف المجلس في ⁦$comp: $demand⁩. أنهيت: $finish. حصلوا على ما طلبوه.';
  }

  @override
  String boardObjectiveMissedBody(String comp, String demand, String finish) {
    return 'هدف المجلس في ⁦$comp: $demand⁩. أنهيت: $finish. هذا أقل مما كان متوقعًا.';
  }

  @override
  String get newsWcMissTitle => 'انتهى حلم بطولة العالم';

  @override
  String newsWcMissBody(int year) {
    return 'لم تتأهل إلى بطولة العالم $year. حملة التصفيات لم تكن كافية. أربع سنوات أخرى.';
  }

  @override
  String get newsRecordScorerTitle => 'الهداف التاريخي';

  @override
  String newsRecordScorerBody(String name, int goals) {
    return '$name أصبح الآن الهداف التاريخي للعبة برصيد $goals هدف.';
  }

  @override
  String get newsRecordCapsTitle => 'الأكثر مشاركة دوليًا';

  @override
  String newsRecordCapsBody(String name, int caps) {
    return '$name أصبح الآن الأكثر مشاركة دوليًا في اللعبة برصيد $caps مباراة.';
  }

  @override
  String get newsARecordBreaker => 'محطم أرقام جديد';

  @override
  String newsTransferTitle(String name, String club) {
    return '$name ينضم إلى $club';
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
    return 'غادر $name ($position، $rating) $fromClub للتوقيع مع $destination مقابل $fee.';
  }

  @override
  String newsTransferAbroad(String club, String country) {
    return '$club في $country';
  }

  @override
  String get newsTransferFree => 'مجانًا';

  @override
  String newsNatzStarTitle(String name, String nation) {
    return '$name مستعد للانتقال إلى $nation!';
  }

  @override
  String newsNatzTitle(String name, String nation) {
    return '$name يريد اللعب لـ$nation';
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
    return '$name، لاعب $position يبلغ $age عامًا وتقييمه $rating ويلعب حاليًا مع $fromNation، لديه روابط عائلية مع $nation ومنفتح على الانتقال. افتح عرض التجنيس للقبول أو الرفض.';
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
    return '$name، لاعب $position يبلغ $age عامًا وتقييمه $rating ويلعب حاليًا مع $fromNation، نجم لديه روابط عائلية مع $nation ومنفتح على الانتقال. افتح عرض التجنيس للقبول أو الرفض.';
  }

  @override
  String get newsTheirNation => 'منتخبه';

  @override
  String get newsYourNation => 'منتخبك';

  @override
  String get tourStatusChampions => 'البطل';

  @override
  String get tourStatusFinals => 'النهائيات';

  @override
  String get tourStatusQualifying => 'التصفيات';

  @override
  String get tourStatusUpcoming => 'قادمة';

  @override
  String get tourStatusInProgress => 'جارية';

  @override
  String get tourStatusComingSoon => 'قريبًا';

  @override
  String get tourStatusDecided => 'حُسمت';

  @override
  String tourStatusLeague(String letter) {
    return 'الدوري $letter';
  }

  @override
  String get tourDrawWcQualifying => 'قرعة تصفيات العالم';

  @override
  String tourDrawContQualifying(String cup) {
    return 'قرعة تصفيات $cup';
  }

  @override
  String get tourDrawWcHost => 'مستضيف بطولة العالم';

  @override
  String tourDrawContHost(String cup) {
    return 'مستضيف $cup';
  }

  @override
  String get tourDrawHostsReveal => 'والمستضيفون هم…';

  @override
  String get tourDrawHostReveal => 'والمستضيف هو…';

  @override
  String get tourDrawHostCandidates => 'المرشحون في السباق:';

  @override
  String get tourKickoffContinentalCup => 'الكأس القارية';

  @override
  String tourHostCompetitionYear(String competition, int year) {
    return '$competition $year';
  }

  @override
  String newsContMissTitle(String cup) {
    return 'فاتتك $cup';
  }

  @override
  String newsContMissBody(String cup) {
    return 'لم تتأهل إلى $cup. الحملة لم تكن كافية هذه المرة.';
  }

  @override
  String get potyLabelBest => 'أفضل لاعب في العام';

  @override
  String get potyLabelYoung => 'أفضل لاعب شاب في العام';

  @override
  String potyTallyAssists(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count تمريرة حاسمة',
      many: '$count تمريرة حاسمة',
      few: '$count تمريرات حاسمة',
      two: 'تمريرتان حاسمتان',
      one: 'تمريرة حاسمة واحدة',
      zero: '$count تمريرة حاسمة',
    );
    return '$_temp0';
  }

  @override
  String potyOverallValue(int value) {
    return 'التقييم $value';
  }

  @override
  String potyRatingValue(String value) {
    return 'العلامة $value';
  }

  @override
  String newsPotyTitle(int year) {
    return 'أفضل لاعب في العالم $year';
  }

  @override
  String newsPotyBody(String name) {
    return '$name هو أفضل لاعب في العالم هذا العام.';
  }

  @override
  String newsPotyYoungSuffix(String name) {
    return ' $name ينال جائزة أفضل لاعب شاب.';
  }

  @override
  String newsWatchTitle(int year) {
    return 'الفتيان الذين تتابعهم، $year';
  }

  @override
  String newsWatchJump(String name, int rating, int gain) {
    String _temp0 = intl.Intl.pluralLogic(
      gain,
      locale: localeName,
      other: '$gain نقطة',
      many: '$gain نقطة',
      few: '$gain نقاط',
      two: 'نقطتين',
      one: 'نقطة واحدة',
      zero: '$gain نقطة',
    );
    return 'قفز $name إلى $rating، بزيادة $_temp0 عن العام الماضي.';
  }

  @override
  String newsWatchBand(String name, String band) {
    return '$name يرتقي إلى فئة الـ$band.';
  }

  @override
  String newsWatchDebutTitle(String name) {
    return '$name يخوض مباراته الدولية الأولى';
  }

  @override
  String newsWatchDebutBody(String name, int age, int rating) {
    return 'خاض $name مباراته الدولية الأولى في سن $age، بتقييم $rating. أحد الفتيان الذين تتابعهم.';
  }

  @override
  String get matchStatsAtFullTime =>
      'الاستحواذ وتقييمات اللاعبين ورجل المباراة تُحسم مع صافرة النهاية.';

  @override
  String get matchPlayerRatings => 'تقييمات اللاعبين';

  @override
  String get matchSubstitutions => 'التبديلات';

  @override
  String get matchSubstitutes => 'البدلاء';

  @override
  String get matchLineupsViewPitch => 'الملعب';

  @override
  String get matchLineupsViewList => 'القائمة';

  @override
  String get matchLineupsCameOn => 'دخل';

  @override
  String get matchConditionsKickOff => 'البداية';

  @override
  String get matchWeatherClear => 'صافٍ';

  @override
  String get matchWeatherRain => 'مطر خفيف';

  @override
  String get matchWeatherSnow => 'ثلج';

  @override
  String get matchWeatherHaze => 'ضباب خفيف';

  @override
  String get matchWeatherHeavyRain => 'مطر غزير';

  @override
  String get matchWeatherThunderstorm => 'عاصفة رعدية';

  @override
  String get matchWeatherFog => 'ضباب';

  @override
  String get matchWeatherWindy => 'رياح';

  @override
  String get matchWeatherDustStorm => 'عاصفة ترابية';

  @override
  String get matchWeatherFrostyNight => 'ليلة صقيع';

  @override
  String get matchWeatherDrizzle => 'رذاذ';

  @override
  String get matchWeatherFrost => 'صقيع';

  @override
  String get matchPlayerOfTheMatch => 'رجل المباراة';

  @override
  String get ratingPlayerOfTheMatch => 'رجل المباراة';

  @override
  String ratingSemantics(String rating) {
    return 'التقييم $rating';
  }

  @override
  String get matchAverageRating => 'متوسط التقييم';

  @override
  String get matchLiveRatingsNote =>
      'التقييمات تتبع مجريات المباراة حتى الآن وتصبح نهائية مع الصافرة.';

  @override
  String get matchGoalShout => 'هدف!';

  @override
  String get matchRedCardShout => 'بطاقة حمراء';

  @override
  String matchShootoutScore(int home, int away) {
    return 'ركلات الترجيح ⁦$home–$away⁩';
  }

  @override
  String matchShootoutKickScored(String name) {
    return '$name: سجّل';
  }

  @override
  String matchShootoutKickMissed(String name) {
    return '$name: أهدر';
  }

  @override
  String get matchFeedKickOff => 'انطلقت المباراة!';

  @override
  String get matchFeedNoEvents => 'لا أحداث بعد.';

  @override
  String get tourVenues => 'الملاعب';

  @override
  String tourPot(int number) {
    return 'المستوى $number';
  }

  @override
  String get tourHostSelection => 'اختيار المستضيف';

  @override
  String get tourCandidates => 'المرشحون';

  @override
  String get tourJointBid => 'ملف مشترك';

  @override
  String get tourGoldenGlove => 'أفضل حارس';

  @override
  String get tourTeamOfTournament => 'التشكيلة المثالية للبطولة';

  @override
  String get tourYourRun => 'مشوارك';

  @override
  String get tourMedalTable => 'جدول الميداليات';

  @override
  String tourHostLine(String nation) {
    return 'المستضيف: $nation';
  }

  @override
  String tourHostLineMulti(String hosts) {
    return 'المستضيفون: $hosts';
  }

  @override
  String tourGroupNamed(String name) {
    return 'المجموعة $name';
  }

  @override
  String get tourFinalsDrawBlurb =>
      'التصنيف حسب الترتيب العالمي. ابحث عن منتخبك قبل القرعة.';

  @override
  String get tourWorldRanking => 'التصنيف العالمي';

  @override
  String get tourYourCompetitions => 'مسابقاتك';

  @override
  String get tourOtherContinents => 'قارات أخرى';

  @override
  String get tourZoneGlobal => 'عالمي';

  @override
  String get tourZoneEurope => 'أوروبا';

  @override
  String get tourZoneSouthAmerica => 'أمريكا ج.';

  @override
  String get tourZoneNorthAmerica => 'أمريكا ش.';

  @override
  String get tourZoneAfrica => 'أفريقيا';

  @override
  String get tourZoneAsia => 'آسيا';

  @override
  String get tourZoneOceania => 'أوقيانوسيا';

  @override
  String get tourZoneIntercontinental => 'عابر للقارات';

  @override
  String tourZoneLeague(String league) {
    return 'الدوري $league';
  }

  @override
  String tourHostedBy(String hosts) {
    return 'تستضيفها  $hosts';
  }

  @override
  String tourThirdsAdvance(int count, String destination) {
    return 'أفضل $count يتأهلون إلى $destination';
  }

  @override
  String newsWalkoutTitle(String name) {
    return '$name يرحل';
  }

  @override
  String newsWalkoutBody(String name, int age, int caps) {
    String _temp0 = intl.Intl.pluralLogic(
      caps,
      locale: localeName,
      other: '$caps مباراة دولية',
      many: '$caps مباراة دولية',
      few: '$caps مباريات دولية',
      two: 'مباراتين دوليتين',
      one: 'مباراة دولية واحدة',
      zero: '$caps مباراة دولية',
    );
    return 'اعتزل $name اللعب الدولي في سن $age، برصيد $_temp0. طلب أن يعرف موقعه ولم يُخبَر، ولن ينتظر أكثر.';
  }

  @override
  String get pressHeadlineWent1 => 'مدرب يسيطر على القاعة';

  @override
  String get pressHeadlineWent2 => 'جاؤوا من أجل مشاجرة فوجدوا قائدًا';

  @override
  String get pressHeadlineWent3 => 'إجابات صريحة، ووصلت';

  @override
  String get pressHeadlineMixed1 => 'كلام كثير، وحسم قليل';

  @override
  String get pressHeadlineMixed2 => 'شيء للجميع، ولا شيء لأحد';

  @override
  String get pressHeadlineMixed3 => 'مؤتمر ترك الأسئلة مفتوحة';

  @override
  String get pressHeadlineBadly1 => 'ظهيرة قاسية أمام الكاميرات';

  @override
  String get pressHeadlineBadly2 => 'انقلبت القاعة، وبدا ذلك واضحًا';

  @override
  String get pressHeadlineBadly3 => 'إجابات ستبدو أسوأ في الصباح';

  @override
  String get pressHeadlineFlat1 => 'لم يُقل شيء، ولم يُكسب شيء';

  @override
  String get pressHeadlineFlat2 => 'عشر دقائق، بلا أخبار';

  @override
  String get pressHeadlineFlat3 => 'صفحة بيضاء للصفحة الأخيرة';

  @override
  String get pressConferenceTitle => 'المؤتمر الصحفي';

  @override
  String pressQuestionOf(int index, int total) {
    return 'السؤال $index من $total';
  }

  @override
  String get pressTomorrowsHeadline => 'عنوان الغد في الصفحة الرياضية';

  @override
  String get pressLeaveRoom => 'غادر القاعة';

  @override
  String get pressRoomVerdictSquad => 'غرفة الملابس';

  @override
  String get pressRoomVerdictBoard => 'المجلس';

  @override
  String get yReactionElation0 => 'لا ملاحظات. لا شيء. مثالي.';

  @override
  String get yReactionElation1 => 'لست بخير (بالمعنى الجيد).';

  @override
  String get yReactionElation2 => 'سأضعها في إطار. فوق المدفأة.';

  @override
  String get yReactionElation3 => 'لقد عدنا بقوة';

  @override
  String get yReactionElation4 => 'لقطة شاشة لكل المشككين. كلهم.';

  @override
  String get yReactionElation5 => 'سأكون لا أُطاق بسبب هذا لعقد كامل.';

  @override
  String get yReactionElation6 => 'حسنًا. لهذا نشاهد.';

  @override
  String get yReactionElation7 => 'أيام كهذه تعوّض عن الأيام الأخرى.';

  @override
  String get yReactionElation8 => 'آن الأوان. حقًا، آن الأوان.';

  @override
  String get yReactionElation9 => 'رائع. والآن كرروها الأسبوع القادم وسأصدق.';

  @override
  String get yReactionElation10 =>
      'استمتعوا بالليلة، لأن هؤلاء سيجدون طريقة لإفسادها.';

  @override
  String get yReactionElation11 => 'ليلة جيدة واحدة لا تجعل أي فريق عظيمًا.';

  @override
  String get yReactionRelief0 => 'ليست جميلة، لكنني سأقبلها في كل مرة.';

  @override
  String get yReactionRelief1 => 'بطريقة ما. بطريقة ما!';

  @override
  String get yReactionRelief2 => 'قبيحة. ثلاث نقاط. نمضي.';

  @override
  String get yReactionRelief3 => 'سأقبل القبح طوال اليوم إن جاء بالنقاط.';

  @override
  String get yReactionRelief4 => 'هذه أخذت من عمري عشر سنوات';

  @override
  String get yReactionRelief5 => 'لا أحد يتكلم. لا أحد يجلب النحس.';

  @override
  String get yReactionRelief6 => 'معدل ضربات القلب: غير مقبول.';

  @override
  String get yReactionRelief7 => 'نجونا. هذه هي الكلمة. نجونا.';

  @override
  String get yReactionRelief8 => 'لا ينبغي أن نشعر بالارتياح بعد مباريات كهذه.';

  @override
  String get yReactionRelief9 => 'مرتاح، ومحرج قليلًا من ارتياحي.';

  @override
  String get yReactionRelief10 =>
      'إن كان هذا هو المستوى الذي نهتف له، فنحن في ورطة.';

  @override
  String get yReactionRelief11 => 'العبور بشق الأنفس عادة، وليست عادة جيدة.';

  @override
  String get yReactionFury0 => 'ليس جيدًا بما يكفي. إطلاقًا.';

  @override
  String get yReactionFury1 => 'فليشرح لي أحد ذلك ببطء.';

  @override
  String get yReactionFury2 => 'مشاهدة صعبة، وأنا مهذب.';

  @override
  String get yReactionFury3 => 'خيبة أمل. خيبة أمل حقيقية.';

  @override
  String get yReactionFury4 => 'يا لها من حالة مزرية.';

  @override
  String get yReactionFury5 => 'أريد أسماء.';

  @override
  String get yReactionFury6 => 'سأحذف التطبيق. وأعيد تثبيته يوم الخميس.';

  @override
  String get yReactionFury7 => 'لم يبدُ أن أحدًا هناك أرادها.';

  @override
  String get yReactionFury8 => 'كل أربع سنوات، الشيء نفسه. كل أربع سنوات.';

  @override
  String get yReactionFury9 => 'هذا ليس أداءً، بل إهانة.';

  @override
  String get yReactionFury10 =>
      'الناس يضحون بعطلاتهم وأموالهم من أجل هذا. فكروا في ذلك.';

  @override
  String get yReactionFury11 =>
      'دافعت عن هذا الفريق لسنوات. ليس الليلة. ليس بعد ذلك.';

  @override
  String get yReactionDespair0 => 'حسنًا.';

  @override
  String get yReactionDespair1 => 'لا نكات اليوم. لا شيء.';

  @override
  String get yReactionDespair2 => 'سأخرج للمشي. مشي طويل.';

  @override
  String get yReactionDespair3 => 'نفدت مني الطرق لقول هذا.';

  @override
  String get yReactionDespair4 => 'أيقظوني بعد أربع سنوات.';

  @override
  String get yReactionDespair5 => 'هذا أسوأ سيناريو ممكن';

  @override
  String get yReactionDespair6 => 'لم أعد غاضبًا حتى. وهذا هو المقلق.';

  @override
  String get yReactionDespair7 => 'هذه ستؤلم لفترة طويلة.';

  @override
  String get yReactionDespair8 =>
      'لا أعرف ما هذا بعد الآن، لكنه ليس فريق كرة قدم.';

  @override
  String get yReactionDespair9 => 'نحن أبعد مما كنا، ولن يعترف أحد بذلك.';

  @override
  String get yReactionDespair10 =>
      'جيل كامل ضاع والأشخاص أنفسهم يقررون ما سيحدث بعد ذلك.';

  @override
  String get yReactionDespair11 =>
      'كفوا عن القول إنها عملية. إنها لا تقود إلى أي مكان.';

  @override
  String get yReactionSmugness0 => 'بهدوء، لكن: قلت لكم.';

  @override
  String get yReactionSmugness1 => 'احفظوا هذه';

  @override
  String get yReactionSmugness2 => 'المشككون صمتوا تمامًا.';

  @override
  String get yReactionSmugness3 => 'لا أحد يعدّ. أنا أعدّ.';

  @override
  String get yReactionSmugness4 => 'قلتها في يناير. راجعوا المنشورات.';

  @override
  String get yReactionSmugness5 => 'بعضكم يدين لبعضنا باعتذار.';

  @override
  String get yReactionSmugness6 =>
      'أضيفها إلى قائمة الأشياء التي ذكرتها أولًا.';

  @override
  String get yReactionSmugness7 => 'لا شماتة. قليل من الشماتة.';

  @override
  String get yReactionSmugness8 => 'أين كل الخبراء الآن؟ سؤال حقيقي.';

  @override
  String get yReactionSmugness9 => 'أريد من كل واحد منكم أن يكررها لي.';

  @override
  String get yReactionSmugness10 =>
      'لقطة شاشة، مطبوعة، في إطار، مرسلة لمن ضحكوا.';

  @override
  String get yReactionSmugness11 => 'سأذكّر بهذه بقية حياتي وأنتم تستحقون ذلك.';

  @override
  String get yReactionShrug0 => 'حدث ما حدث. التالي.';

  @override
  String get yReactionShrug1 => 'حسنًا. لا يهم. إلى الأمام.';

  @override
  String get yReactionShrug2 => 'أضعها تحت بند «كرة القدم».';

  @override
  String get yReactionShrug3 => 'لا شيء أضيفه حقًا.';

  @override
  String get yReactionShrug4 => 'لا أفكار، الرأس فارغ';

  @override
  String get yReactionShrug5 => 'أيقظوني للمباراة القادمة.';

  @override
  String get yReactionShrug6 => 'تسعون دقيقة لن أستعيدها.';

  @override
  String get yReactionShrug7 => 'لا هنا ولا هناك، حقًا.';

  @override
  String get yReactionShrug8 => 'لا أستطيع أن أخبركم بشيء واحد حدث.';

  @override
  String get yReactionShrug9 => 'واحدة أخرى من تلك. هناك الكثير منها.';

  @override
  String get yReactionShrug10 => 'شاهدتها كلها ولم أشعر بأي شيء.';

  @override
  String get yReactionShrug11 => 'إن لم يذكرها أحد مجددًا، فلا مانع لدي.';

  @override
  String get tourThirdsUneven =>
      'المجموعات غير متساوية، لذا تُستبعد النتائج أمام صاحب المركز الأخير في كل مجموعة كبيرة ويُحكم على كل فريق بالمباريات نفسها.';

  @override
  String get careerExportSave => 'انسخ هذا الحفظ احتياطيًا';

  @override
  String get careerBackupAll => 'نسخ احتياطي لكل الملفات';

  @override
  String get careerBackupAllFailed => 'تعذّرت كتابة النسخة الاحتياطية.';

  @override
  String get backupTitle => 'النسخ الاحتياطية';

  @override
  String get backupBlurb =>
      'كل ملفات الحفظ موجودة في ملف واحد على هذا الهاتف، ولا شيء ينسخها احتياطيًا من تلقاء نفسه ما لم تفعّل النسخ الاحتياطي التلقائي أدناه. احتفظ بنسخة في السحابة حتى لا يكلفك هاتف مفقود أو تطبيق محذوف مسيرة كاملة.';

  @override
  String get backupBlurbNoAuto =>
      'كل ملفات الحفظ موجودة في ملف واحد على هذا الهاتف، ولا شيء ينسخها احتياطيًا من تلقاء نفسه. احتفظ بنسخة في السحابة حتى لا يكلفك هاتف مفقود أو تطبيق محذوف مسيرة كاملة.';

  @override
  String get backupExport => 'نسخ احتياطي إلى السحابة';

  @override
  String get backupExportSubject => 'ملفات حفظ FNM';

  @override
  String get backupRestore => 'استعادة من ملف';

  @override
  String get backupRestoreWarnTitle => 'استبدال كل ملفات الحفظ؟';

  @override
  String get backupRestoreWarnBody =>
      'الاستعادة تستبدل كل ملفات الحفظ على هذا الهاتف بتلك الموجودة في الملف. سيُعاد تشغيل التطبيق.';

  @override
  String get backupRestoreConfirm => 'استبدال';

  @override
  String get backupCancel => 'إلغاء';

  @override
  String get backupExported => 'النسخة الاحتياطية جاهزة. اختر مكان حفظها.';

  @override
  String get backupFailed => 'تعذّرت كتابة النسخة الاحتياطية.';

  @override
  String get backupRejectedUnreadable => 'تعذّر فتح هذا الملف.';

  @override
  String get backupRejectedNotFnm => 'هذا ليس ملف حفظ FNM.';

  @override
  String get backupRejectedNewer =>
      'هذا الحفظ أُنشئ بإصدار أحدث من التطبيق. حدّث التطبيق أولًا.';

  @override
  String get backupRejectedTooOld =>
      'هذا الحفظ قديم جدًا ولا يمكن لهذا الإصدار استعادته.';

  @override
  String get careerShare => 'شارك هذه المسيرة';

  @override
  String get careerImport => 'استيراد مسيرة';

  @override
  String get careerShareSubject => 'مسيرة في FNM';

  @override
  String get careerImported => 'تم استيراد المسيرة.';

  @override
  String get careerImportFailedUnreadable => 'هذا الملف ليس مسيرة FNM.';

  @override
  String get careerImportFailedNewer =>
      'صُدّرت هذه المسيرة بإصدار أحدث من التطبيق. حدّث التطبيق أولًا.';

  @override
  String get careerImportFailedSlotsFull =>
      'كل خانات الحفظ مستخدمة. احذف ملف حفظ لإفساح المجال، أو افتح ملفات حفظ غير محدودة.';

  @override
  String get careerImportFailedNeedsPremium =>
      'هذه المسيرة تجاوزت الدورة الأولى المجانية. افتح اللعبة الكاملة لاستيرادها.';

  @override
  String get careerImportFailedCampaignRun =>
      'لهذه الحملة محاولة جارية بالفعل. استأنفها أو تخلَّ عنها أولًا.';

  @override
  String get careerShareFailed => 'تعذّر تصدير هذه المسيرة.';

  @override
  String get managerRename => 'تغيير الاسم';

  @override
  String get managerRenameSave => 'حفظ';

  @override
  String get managerTitle => 'المدرب';

  @override
  String get managerSkills => 'مهاراتك';

  @override
  String managerPointsAvailable(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count نقطة لإنفاقها',
      many: '$count نقطة لإنفاقها',
      few: '$count نقاط لإنفاقها',
      two: 'نقطتان لإنفاقهما',
      one: 'نقطة واحدة لإنفاقها',
      zero: 'لا نقاط لإنفاقها',
    );
    return '$_temp0';
  }

  @override
  String get managerPointsHow =>
      'نقطتان عن كل دورة تكملها، ونقطة عن كل لقب تفوز به.';

  @override
  String get managerSkillsScale =>
      'كل مهارة تبدأ عند 5 وتتوقف عند 20. النقطة المنفقة دائمة.';

  @override
  String get managerSkillManManagement => 'إدارة اللاعبين';

  @override
  String get managerSkillManManagementBlurb =>
      'كل نقطة تجعل ما تقوله للصحافة ولاعبيك أقوى تأثيرًا بنسبة 3% في غرفة الملابس.';

  @override
  String get managerSkillTactical => 'التكتيك';

  @override
  String get managerSkillTacticalBlurb =>
      'كل نقطة تجعل الخطة الجديدة تترسخ أسرع بنسبة 3%، فيكلفك تغيير الشكل مباريات أقل.';

  @override
  String get managerSkillYouth => 'تطوير الشباب';

  @override
  String get managerSkillYouthBlurb =>
      'كل نقطة تضيف 1% إلى المواهب الخارجة من أكاديميتك، فوق ما تموّلها به.';

  @override
  String get managerSkillNegotiation => 'التفاوض';

  @override
  String get managerSkillNegotiationBlurb =>
      'كل نقطة تعني أموالًا أكثر بنسبة 2% من الاتحاد، في كل دورة.';

  @override
  String get managerStaff => 'طاقمك';

  @override
  String managerStaffWages(String amount) {
    return 'الرواتب: $amount لكل دورة';
  }

  @override
  String get managerRoleAssistant => 'المدرب المساعد';

  @override
  String get managerRoleAssistantBlurb =>
      'يدير التدريبات: إصابات أقل، وشباب أفضل يصعدون.';

  @override
  String get managerRoleScout => 'كبير الكشافين';

  @override
  String get managerRoleScoutBlurb =>
      'يقرأ مواهبك ومنافسك التالي: تقييمات نجوم أدق، وأفضلية يوم المباراة.';

  @override
  String get managerRoleFitness => 'مدرب اللياقة';

  @override
  String get managerRoleFitnessBlurb => 'يبقيهم في الملعب.';

  @override
  String staffEffectInjury(int percent) {
    return 'إصابات أقل بنسبة $percent%';
  }

  @override
  String staffEffectYouth(int points) {
    return 'الشباب ⁦+$points⁩ للتقييم العام';
  }

  @override
  String staffHiringInjury(int min, int max) {
    return 'بتعيين واحد: إصابات أقل بنسبة $min% إلى $max%';
  }

  @override
  String staffHiringYouth(int minPoints, int maxPoints) {
    return 'والشباب ⁦+$minPoints⁩ إلى ⁦+$maxPoints⁩ للتقييم العام';
  }

  @override
  String staffEffectScoutRead(int percent) {
    return 'يقرأ $percent% من المواهب بدقة';
  }

  @override
  String staffEffectScoutCaps(int caps) {
    String _temp0 = intl.Intl.pluralLogic(
      caps,
      locale: localeName,
      other: 'الإمكانات تُعرف بعد $caps مباراة دولية',
      many: 'الإمكانات تُعرف بعد $caps مباراة دولية',
      few: 'الإمكانات تُعرف بعد $caps مباريات دولية',
      two: 'الإمكانات تُعرف بعد مباراتين دوليتين',
      one: 'الإمكانات تُعرف بعد مباراة دولية واحدة',
      zero: 'الإمكانات معروفة فورًا',
    );
    return '$_temp0';
  }

  @override
  String staffEffectScoutDossier(int points) {
    return '⁦+$points⁩ للتقييم من تقارير المنافسين';
  }

  @override
  String staffHiringScoutRead(int min, int max) {
    return 'بتعيين واحد: $min% إلى $max% من القراءات دقيقة';
  }

  @override
  String staffHiringScoutCaps(int minCaps, int maxCaps) {
    return 'والإمكانات تُعرف أبكر بـ$minCaps إلى $maxCaps مباريات دولية';
  }

  @override
  String staffHiringScoutDossier(int minPoints, int maxPoints) {
    return 'و⁦+$minPoints⁩ إلى ⁦+$maxPoints⁩ للتقييم في كل مباراة';
  }

  @override
  String get staffEffectNone => 'لا تأثير على فريقك بعد';

  @override
  String get staffVacant => 'لا أحد في الوظيفة';

  @override
  String get staffLeaveVacant => 'اترك الوظيفة شاغرة';

  @override
  String get managerTierNone => 'لا شيء';

  @override
  String get managerTierBasic => 'أساسي';

  @override
  String get managerTierGood => 'جيد';

  @override
  String get managerTierElite => 'نخبة';

  @override
  String get managerFree => 'مجاني';

  @override
  String get managerTraining => 'بين النوافذ';

  @override
  String get managerTrainingBlurb => 'ما يعمل عليه الفريق حين لا توجد مباراة.';

  @override
  String get managerFocusBalanced => 'متوازن';

  @override
  String get managerFocusBalancedBlurb => 'قليل من كل شيء.';

  @override
  String get managerFocusFitness => 'اللياقة';

  @override
  String get managerFocusFitnessBlurb => 'إصابات أقل.';

  @override
  String get managerFocusCohesion => 'الانسجام';

  @override
  String get managerFocusCohesionBlurb => 'الخطة تترسخ أسرع.';

  @override
  String get managerFocusYouth => 'الشباب';

  @override
  String get managerFocusYouthBlurb => 'ساعات مع الأصغر سنًا في المجموعة.';

  @override
  String get tourOfferTitle => 'أول مرة هنا؟';

  @override
  String get tourOfferBody =>
      'هذه لعبة كبيرة. هل تريد جولة سريعة على الشاشات المهمة؟ تستغرق دقيقة، ويمكنك بدؤها مجددًا في أي وقت من الإعدادات.';

  @override
  String get tourOfferYes => 'أرني المكان';

  @override
  String get tourOfferNo => 'لا، شكرًا';

  @override
  String get tourBack => 'رجوع';

  @override
  String get tourNext => 'التالي';

  @override
  String get tourDone => 'تم';

  @override
  String get tourSkip => 'تخطٍّ';

  @override
  String get tourHubTitle => 'هذه هي اللعبة كلها';

  @override
  String get tourHubBody =>
      'زر واحد، ويتغير مع تقدم الدورة: قرعة لتشاهدها، قائمة لتسمّيها، مباراة لتلعبها. فوقه ثقة المجلس بك والأهداف التي حددها.';

  @override
  String get tourBudgetTitle => 'أموال الاتحاد';

  @override
  String get tourBudgetBody =>
      'مرة كل دورة من أربع سنوات توزّع الميزانية بين الأقسام. يُدفع لطاقمك منها أولًا، لذا فتعيين كشاف من النخبة قرار تتخذه على حساب الأكاديمية، لا بجانبها.';

  @override
  String get tourTacticsTitle => 'كيف يلعب الفريق';

  @override
  String get tourTacticsBody =>
      'خطتك، وأسلوب لعبك، وقائدك، ومن ينفذ الكرات الثابتة. اترك الأخيرين دون تحديد وستحذرك اللعبة قبل البداية بدل أن تختار عنك بصمت.';

  @override
  String get tourSquadTitle => 'كل من يمكنك اختياره';

  @override
  String get tourSquadBody =>
      'المجموعة كاملة، لا القائمة فقط: من في قمة مستواه، ومن يعاني إصابة، ومن هو موقوف، ومن صعد للتو من الأكاديمية.';

  @override
  String get tourCallUpsTitle => 'تسمية القائمة';

  @override
  String get tourCallUpsBody =>
      'تسمّي قائمة واحدة لكل نافذة دولية وتخوض بها كل مباريات تلك النافذة، تمامًا كما يفعل المدرب الحقيقي. الإصابة داخل النافذة تستدعي بديلًا لك تلقائيًا.';

  @override
  String get tourRecordsTitle => 'مسيرتك';

  @override
  String get tourRecordsBody =>
      'كل ما فعلته: المباريات، وأرقام الفريق، والألقاب، وكل منتخب دربته.';

  @override
  String get tourCupsTitle => 'بقية العالم';

  @override
  String get tourCupsBody =>
      'كل مسابقة جارية الآن: المجموعات والترتيب والأدوار الإقصائية، بما فيها تلك التي لست فيها. العالم يواصل اللعب سواء تأهلت أم لا.';

  @override
  String get settingsTourTitle => 'أعد تشغيل الشرح';

  @override
  String get settingsTourBlurb =>
      'تجوّل في الشاشات الرئيسية مجددًا من البداية.';

  @override
  String get tourBoardTitle => 'من تُحاسَب أمامه';

  @override
  String get tourBoardBody =>
      'ثقة المجلس بك، والأهداف التي حددها لهذه الدورة. إن أخفقت في المهمة فهنا سترى ذلك قادمًا.';

  @override
  String get tourStaffTitle => 'الأشخاص من حولك';

  @override
  String get tourStaffBody =>
      'مساعد، وكشاف، ومدرب لياقة، يُعيَّنون بالاسم. رواتبهم تُخصم من هذه الميزانية قبل الأقسام، لذا فالكشاف الممتاز قرار على حساب الأكاديمية.';

  @override
  String get tourPlaystyleTitle => 'أسلوب لعبك';

  @override
  String get tourPlaystyleBody =>
      'الخطة نصف التكتيك فقط. وهذا هو النصف الآخر: مدى ارتفاع ضغطك، ومدى مباشرتك، ومقدار ما تخاطر به.';

  @override
  String get settingsTourNoSave =>
      'ابدأ مسيرة أولًا. الجولة تزور شاشاتك الخاصة.';

  @override
  String tacticsOutOfPositionAge(int age) {
    return 'في غير مركزه · العمر $age';
  }

  @override
  String get federationNextCycleLocked =>
      'تُحدَّد ميزانية الدورة التالية في بداية تلك الدورة، دفعة واحدة. حتى ذلك الحين، هذا ما تفعله أموالك.';

  @override
  String get federationBudgetAlreadySet => 'محددة بالفعل لهذه الدورة';

  @override
  String yFinalLooms0(String opponent) {
    return 'إنه $opponent في المباراة الكبرى. طوال الأسبوع، لن يتحدث أحد إلا عن هذا.';
  }

  @override
  String yFinalLooms1(String opponent) {
    return 'مؤكد: $opponent يقف بيننا وبينها. أربع سنوات من أجل هذا.';
  }

  @override
  String yFinalLooms2(String opponent) {
    return 'حسنًا. $opponent. لا أحد ينام حتى ينتهي هذا.';
  }

  @override
  String yFinalLooms3(String opponent) {
    return '$opponent هو التالي، وكل شيء آخر يمكنه الانتظار. يا له من أسبوع.';
  }

  @override
  String get matchSetupLeaveToCoach => 'اترك اختيار المنفذين للمدرب';

  @override
  String friendliesLikeYourGroup(String rivals) {
    return 'العلامات أدناه: فرق تلعب مثل $rivals، الفرق التي تواجهها في مجموعاتك هذه الدورة.';
  }

  @override
  String newsTransferWindowTitle(int year) {
    return 'فترة الانتقالات · $year';
  }

  @override
  String careerLastAgo(String when) {
    return 'آخر مرة قبل $when';
  }

  @override
  String get settingsFreeScopeTitle => 'دورة مجانية واحدة من أربع سنوات';

  @override
  String get settingsFreeScopeBlurb =>
      'دورة كاملة (التصفيات، وبطولتك القارية، وبطولة العالم) على ملفَّي حفظ، مع كل منتخبات العالم، دون حجب أي شيء. الدورات اللانهائية وملفات الحفظ غير المحدودة بدفعة واحدة، لمرة واحدة، مع التحديثات.';

  @override
  String get settingsUnlockedTitle => 'مفتوح';

  @override
  String get settingsUnlockedBlurb =>
      'دورات لا نهائية، وملفات حفظ غير محدودة، والتحديثات مشمولة. شكرًا لك.';

  @override
  String get settingsFromDeveloperTitle => 'من المطوّر';

  @override
  String get settingsFromDeveloperBlurb =>
      'Football Nations Manager من صنع شخص واحد وسيستمر دعمها على المدى الطويل. لن تكون هناك إعلانات أو مشتريات صغيرة أبدًا. إن كنت تستمتع باللعبة، ففكّر في شراء النسخة الكاملة. هذا ما يجعل التحديثات مستمرة.';

  @override
  String get settingsFromDeveloperThanksBlurb =>
      'Football Nations Manager من صنع شخص واحد وسيستمر دعمها على المدى الطويل. لن تكون هناك إعلانات أو مشتريات صغيرة أبدًا. شكرًا لشرائك النسخة الكاملة. هذا ما يجعل التحديثات مستمرة.';

  @override
  String friendliesLikeYourCampaign(String rivals) {
    return 'العلامات أدناه: فرق تلعب مثل $rivals، الذين لا يزال عليك مواجهتهم.';
  }

  @override
  String get friendliesCloseToYou =>
      'العلامات أدناه: الفرق الأقرب إليك في التصنيف العالمي. بعد القرعة، تتبع العلامات مجموعتك.';

  @override
  String transfersMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count انتقال',
      many: '$count انتقالًا',
      few: '$count انتقالات',
      two: 'انتقالان',
      one: 'انتقال واحد',
      zero: '$count انتقال',
    );
    return '$_temp0';
  }

  @override
  String hubRoundPage(int page, int pages) {
    return '⁦$page / $pages⁩';
  }

  @override
  String get transfersNewer => 'الأحدث';

  @override
  String get transfersOlder => 'المزيد';

  @override
  String get transfersPagePrevious => 'السابق';

  @override
  String get transfersPageNext => 'التالي';

  @override
  String transfersPageOf(int page, int pages) {
    return 'الصفحة $page من $pages';
  }

  @override
  String get transfersMovedTo => 'انتقل إلى';

  @override
  String get transfersUnknownClub => 'نادٍ غير معروف';

  @override
  String yAgainstThemAgain0(String opponent, int count) {
    return 'هذه $count مرات أمام $opponent الآن. أحدهم يحسب النتيجة، وهم من يفعلون.';
  }

  @override
  String yAgainstThemAgain1(String opponent, int count) {
    return '$opponent مجددًا. $count مواجهات، وما زلنا لم نفك شفرتهم.';
  }

  @override
  String yAgainstThemAgain2(String opponent, int count) {
    return 'المواجهة رقم $count أمام $opponent. لم تعد صدفة.';
  }

  @override
  String yAgainstThemAgain3(String opponent, int count) {
    return 'لعبنا أمام $opponent $count مرات ولم نتعلم شيئًا من أي منها.';
  }

  @override
  String yAgainstThemAgain4(String opponent, int count) {
    return '$opponent، $count مرات. يعرفون بالضبط ما سنفعله.';
  }

  @override
  String yAgainstThemAgain5(String opponent, int count) {
    return 'أيًا كان ما يملكه $opponent علينا، بعد $count مواجهات، ما زالوا يملكونه.';
  }

  @override
  String ySameOldStory0(int count) {
    return 'هذه $count مرات حدث فيها هذا مؤخرًا. متى نعترف بأن هذا هو حالنا؟';
  }

  @override
  String ySameOldStory1(int count) {
    return '$count أمسيات كهذه الآن. إنه نمط، لا سلسلة من سوء الحظ.';
  }

  @override
  String ySameOldStory2(int count) {
    return 'رأينا هذه المباراة بعينها $count مرات مؤخرًا. السيناريو نفسه، النهاية نفسها.';
  }

  @override
  String ySameOldStory3(int count) {
    return '$count نسخ من التسعين دقيقة نفسها الآن. لا أحد يصلح ذلك.';
  }

  @override
  String ySameOldStory4(int count) {
    return '$count مرات. إن لم ترَ النمط حتى الآن فأنت لا تنظر.';
  }

  @override
  String ySameOldStory5(int count) {
    return 'القصة نفسها، $count مرات. نفدت الأعذار قبل أن تتحسن النتائج.';
  }

  @override
  String get yToldYouSo0 =>
      'قلت إن هذا قادم بينما كان الجميع منشغلين بالاحتفال.';

  @override
  String get yToldYouSo1 =>
      'أسبوعان جيدان وأصبحنا جيلًا ذهبيًا مجددًا. وها نحن ذا.';

  @override
  String get yToldYouSo2 => 'الذين قالوا لي استمتع بها الشهر الماضي صمتوا.';

  @override
  String get yToldYouSo3 =>
      'لا أشعر بأي متعة في هذا. متعة قليلة جدًا. بعض المتعة.';

  @override
  String get yToldYouSo4 => 'لم يكن الأمر جيدًا كما قالوا لكم، وهذا هو الدليل.';

  @override
  String get yToldYouSo5 => 'كل مرة. يقولون لنا إنها مختلفة، وكل مرة لا تكون.';

  @override
  String get tacticsSubOffAlready => 'خرج بالفعل';

  @override
  String get tacticsSubInjured => 'مصاب';

  @override
  String get tacticsSubSentOffMark => 'مطرود';

  @override
  String get tacticsSubNoneLeft => 'لا تبديلات متبقية';

  @override
  String get tacticsUndoLastChange => 'تراجع عن آخر تغيير';

  @override
  String get matchStrengthTitle => 'ما الذي يحرّك الفريق';

  @override
  String get strengthFactorFamiliarity => 'خطة متقنة';

  @override
  String get strengthFactorFatigue => 'أرجل متعبة';

  @override
  String get strengthFactorClubForm => 'المستوى مع الأندية';

  @override
  String get strengthFactorMorale => 'غرفة الملابس';

  @override
  String get strengthFactorCaptain => 'القائد';

  @override
  String get strengthFactorStaff => 'الطاقم الفني';

  @override
  String get strengthFactorDossier => 'تقرير الكشاف';

  @override
  String yDebut0(String name) {
    return '$name يخوض مباراته الدولية الأولى. تذكروا الاسم.';
  }

  @override
  String yDebut1(String name) {
    return 'ظهور أول لـ$name. يمكنكم رؤية ذلك فيه، أليس كذلك؟';
  }

  @override
  String yDebut2(String name) {
    return '$name، المباراة الدولية الأولى. لنرَ ما سيفعله بها.';
  }

  @override
  String yDebut3(String name) {
    return 'ظهور أول لـ$name. احتاج الفريق إلى أرجل جديدة في مكان ما.';
  }

  @override
  String yDebut4(String name) {
    return '$name ينال مباراة دولية. منحنا الكثير منها مؤخرًا.';
  }

  @override
  String yDebut5(String name) {
    return 'ظهور أول لـ$name. واحد آخر سننساه بحلول الربيع.';
  }

  @override
  String yDrought0(String name, int count) {
    return '$name خاض $count مباريات دون تسجيل ويفعل كل شيء آخر في الملعب.';
  }

  @override
  String yDrought1(String name, int count) {
    return '$count مباريات دون هدف لـ$name. الأهداف تأتي ثلاثًا، دائمًا.';
  }

  @override
  String yDrought2(String name, int count) {
    return '⁦$name: $count⁩ مباريات، بلا أهداف.';
  }

  @override
  String yDrought3(String name, int count) {
    return '$count دون هدف لـ$name. يستحق المراقبة.';
  }

  @override
  String yDrought4(String name, int count) {
    return '$count مباريات. بلا أهداف. $name لا يستطيع إصابة باب حظيرة.';
  }

  @override
  String yDrought5(String name, int count) {
    return '$name لم يسجل في $count. أشركوا أي أحد آخر حرفيًا.';
  }

  @override
  String yRivalryLooms0(String opponent, int count) {
    return '$opponent هو التالي. $count مواجهات وما زالت تعني كل شيء.';
  }

  @override
  String yRivalryLooms1(String opponent, int count) {
    return '$count مرات أمام $opponent الآن. هاتوها.';
  }

  @override
  String yRivalryLooms2(String opponent, int count) {
    return '$opponent هو التالي. لُعبت $count.';
  }

  @override
  String yRivalryLooms3(String opponent, int count) {
    return 'المواجهة رقم $count مع $opponent هذا الأسبوع.';
  }

  @override
  String yRivalryLooms4(String opponent, int count) {
    return '$opponent مجددًا. $count منها ولم نتعلم شيئًا.';
  }

  @override
  String yRivalryLooms5(String opponent, int count) {
    return '$count مباريات أمام $opponent وما زالوا يهزموننا. رائع.';
  }

  @override
  String get positionGoalkeeper => 'حارس مرمى';

  @override
  String get positionLeftBack => 'ظهير أيسر';

  @override
  String get positionCentreBack => 'قلب دفاع';

  @override
  String get positionRightBack => 'ظهير أيمن';

  @override
  String get positionDefensiveMid => 'وسط مدافع';

  @override
  String get positionCentralMid => 'وسط';

  @override
  String get positionAttackingMid => 'وسط مهاجم';

  @override
  String get positionLeftMid => 'وسط أيسر';

  @override
  String get positionRightMid => 'وسط أيمن';

  @override
  String get positionLeftWing => 'جناح أيسر';

  @override
  String get positionRightWing => 'جناح أيمن';

  @override
  String get positionStriker => 'رأس حربة';

  @override
  String get roleNone => 'بلا دور';

  @override
  String get roleTargetMan => 'مهاجم محوري';

  @override
  String get rolePoacher => 'قنّاص';

  @override
  String get rolePlaymaker => 'صانع ألعاب';

  @override
  String get roleBallWinner => 'مفتّك الكرات';

  @override
  String get roleInvertedWinger => 'جناح معكوس';

  @override
  String get roleBallPlayingDefender => 'مدافع يجيد اللعب بالكرة';

  @override
  String get roleNoneBlurb => 'يلعب بأسلوبه الطبيعي.';

  @override
  String get roleTargetManBlurb =>
      'يكسب الكرات الهوائية ويهيئها. صناعة أهداف وكرات ثابتة.';

  @override
  String get rolePoacherBlurb => 'يتربص في المنطقة. أهداف أكثر بكثير.';

  @override
  String get rolePlaymakerBlurb => 'يصنع الفرص. تمريرات حاسمة أكثر بكثير.';

  @override
  String get roleBallWinnerBlurb => 'يقطع اللعب بدل إنهائه.';

  @override
  String get roleInvertedWingerBlurb => 'يدخل إلى العمق للتسديد. أهداف أكثر.';

  @override
  String get roleBallPlayingDefenderBlurb => 'يبدأ الهجمات من الخلف.';

  @override
  String get roleLineKeeper => 'حارس خط';

  @override
  String get roleSweeperKeeper => 'حارس ليبرو';

  @override
  String get roleStopper => 'مدافع متقدم';

  @override
  String get roleCoveringDefender => 'مدافع تغطية';

  @override
  String get roleDefensiveFullBack => 'ظهير دفاعي';

  @override
  String get roleWingBack => 'ظهير جناح';

  @override
  String get roleInvertedFullBack => 'ظهير معكوس';

  @override
  String get roleAnchor => 'المرتكز';

  @override
  String get roleDeepPlaymaker => 'صانع ألعاب متأخر';

  @override
  String get roleBoxToBox => 'لاعب من منطقة إلى منطقة';

  @override
  String get roleShadowStriker => 'مهاجم ظل';

  @override
  String get roleTouchlineWinger => 'جناح على الخط';

  @override
  String get roleDefensiveWinger => 'جناح دفاعي';

  @override
  String get roleFalseNine => 'مهاجم وهمي';

  @override
  String get rolePressingForward => 'مهاجم ضاغط';

  @override
  String get roleLineKeeperBlurb =>
      'يبقى على خط المرمى. أكثر أمانًا، وأبطأ في بدء اللعب.';

  @override
  String get roleSweeperKeeperBlurb => 'يغطي خلف الدفاع ويبدأ الهجمات.';

  @override
  String get roleStopperBlurb => 'يتقدم لافتكاك الكرة مبكرًا. قوي في الهواء.';

  @override
  String get roleCoveringDefenderBlurb => 'يتراجع لتغطية المساحة خلفه.';

  @override
  String get roleDefensiveFullBackBlurb => 'يبقى في الخلف ويحرس الطرف.';

  @override
  String get roleWingBackBlurb => 'يتقدم ويرسل العرضيات. يغطي مساحة كبيرة.';

  @override
  String get roleInvertedFullBackBlurb =>
      'يدخل إلى الوسط للمساعدة في الاحتفاظ بالكرة.';

  @override
  String get roleAnchorBlurb => 'يحمي خط الدفاع. نادرًا ما يسجل.';

  @override
  String get roleDeepPlaymakerBlurb =>
      'يتحكم في اللعب من الخلف. تمريرات حاسمة أكثر.';

  @override
  String get roleBoxToBoxBlurb => 'يصعد ويهبط طوال المباراة. يحتاج إلى لياقة.';

  @override
  String get roleShadowStrikerBlurb => 'يصل متأخرًا إلى المنطقة. أهداف أكثر.';

  @override
  String get roleTouchlineWingerBlurb =>
      'يلتصق بخط التماس ويرسل العرضيات. تمريرات حاسمة أكثر.';

  @override
  String get roleDefensiveWingerBlurb => 'يعود لحماية الظهير.';

  @override
  String get roleFalseNineBlurb => 'يتراجع لربط اللعب. يصنع أكثر مما يسجل.';

  @override
  String get rolePressingForwardBlurb => 'يقود الضغط من الأمام. يتعب أسرع.';

  @override
  String get federationDeptYouth => 'أكاديمية الشباب';

  @override
  String get federationDeptCommercial => 'التسويق / العلاقات العامة';

  @override
  String get federationDeptMedical => 'الطب وعلوم الرياضة';

  @override
  String get federationDeptNaturalisation => 'مكتب التجنيس';

  @override
  String get federationDeptBoardRelations => 'العلاقات مع المجلس';

  @override
  String get federationDeptYouthBlurb =>
      'مواهب أفضل من الأكاديمية تظهر مع منتخبك في الدورة القادمة.';

  @override
  String get federationDeptCommercialBlurb =>
      'الرعاية تجلب دخلًا إضافيًا في نهاية الدورة.';

  @override
  String get federationDeptMedicalBlurb =>
      'إصابات أقل. يبقى فريقك متاحًا طوال الدورة.';

  @override
  String get federationDeptNaturalisationBlurb =>
      'مزيد من اللاعبين الأجانب يعرضون الانتقال إلى منتخبك.';

  @override
  String get federationDeptBoardRelationsBlurb =>
      'يحكم المجلس على نتائجك بصبر أكبر.';

  @override
  String get federationBuildingAcademy => 'الأكاديمية';

  @override
  String get federationBuildingCommercial => 'المقر التجاري';

  @override
  String get federationBuildingMedical => 'المركز الطبي';

  @override
  String get federationBuildingScouting => 'مكتب الكشافين';

  @override
  String get federationBuildingBoardroom => 'قاعة المجلس';

  @override
  String get moraleBuoyant => 'مرتفعة جدًا';

  @override
  String get moralePositive => 'إيجابية';

  @override
  String get moraleSettled => 'مستقرة';

  @override
  String get moraleUneasy => 'متوترة';

  @override
  String get moraleRockBottom => 'في الحضيض';

  @override
  String get matchTabTimeline => 'مجريات';

  @override
  String get matchTabStats => 'إحصاءات';

  @override
  String get matchTabLineups => 'التشكيلات';

  @override
  String get matchPenalty => 'ركلة جزاء';

  @override
  String get matchStateLevel => 'التعادل قائم';

  @override
  String matchStateLead(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'أنت متقدم بـ$count هدف',
      many: 'أنت متقدم بـ$count هدفًا',
      few: 'أنت متقدم بـ$count أهداف',
      two: 'أنت متقدم بهدفين',
      one: 'أنت متقدم بهدف',
      zero: 'التعادل قائم',
    );
    return '$_temp0';
  }

  @override
  String matchStateTrail(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'أنت متأخر بـ$count هدف',
      many: 'أنت متأخر بـ$count هدفًا',
      few: 'أنت متأخر بـ$count أهداف',
      two: 'أنت متأخر بهدفين',
      one: 'أنت متأخر بهدف',
      zero: 'التعادل قائم',
    );
    return '$_temp0';
  }

  @override
  String matchPossessionShare(int possession) {
    return 'استحواذ $possession%';
  }

  @override
  String get boardVerdictSackedTitle => 'المجلس أقالك';

  @override
  String boardVerdictSackedBody(int rating) {
    return 'دورة كارثية (التقييم $rating%). عهدك ينتهي هنا. وحدها المنتخبات الأقل شأنًا ستراهن عليك الآن.';
  }

  @override
  String get boardVerdictDelightedTitle => 'المجلس مسرور جدًا';

  @override
  String boardVerdictDelightedBody(int rating, String best) {
    return 'دورة استثنائية (التقييم $rating%) بعد $best. منتخبات أكبر مهتمة، أو يمكنك البقاء والبناء.';
  }

  @override
  String get boardVerdictSolidTitle => 'دورة متينة';

  @override
  String boardVerdictSolidBody(int rating) {
    return 'المجلس راضٍ (التقييم $rating%). بعض المنتخبات المماثلة ستقبل بك، لكن لا ضغط عليك للانتقال.';
  }

  @override
  String get boardVerdictExpectedMoreTitle => 'المجلس توقع المزيد';

  @override
  String boardVerdictExpectedMoreBody(int rating) {
    return 'دورة مخيبة (التقييم $rating%). تحتفظ بوظيفتك، لكن أي عروض ستكون خطوة إلى الخلف.';
  }

  @override
  String get boardVerdictPressureTitle => 'أنت تحت ضغط حقيقي';

  @override
  String boardVerdictPressureBody(int rating) {
    return 'دورة سيئة (التقييم $rating%). تنجو، لكن المنتخبات الأضعف فقط مهتمة إن رغبت في بداية جديدة.';
  }

  @override
  String get boardVerdictHeroTitle => 'الأمة تقف معك';

  @override
  String boardVerdictHeroNote(String nation, int cycles) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles دورة',
      many: '$cycles دورة',
      few: '$cycles دورات',
      two: 'دورتين',
      one: 'دورة واحدة',
      zero: '$cycles دورة',
    );
    return ' $nation يعشقونك، بطل قومي بعد $_temp0؛ وظيفتك آمنة ما دمت تريدها.';
  }

  @override
  String get boardVerdictTheNation => 'الأمة';

  @override
  String get boardVerdictBestQuiet => 'دورة هادئة';

  @override
  String get boardVerdictBestCycle => 'الدورة';

  @override
  String boardVerdictBestWorld(String placement) {
    return 'بطولة العالم: $placement';
  }

  @override
  String get finishThirdPlace => 'المركز الثالث';

  @override
  String get finishFourthPlace => 'المركز الرابع';

  @override
  String get finishDidNotQualify => 'لم يتأهل';

  @override
  String get careerRepIconic => 'أيقونة';

  @override
  String get careerRepRenowned => 'مشهور';

  @override
  String get careerRepEstablished => 'راسخ';

  @override
  String get careerRepRising => 'صاعد';

  @override
  String get careerRepUnproven => 'غير مجرَّب';

  @override
  String get hubOfferStepUp => 'خطوة للأمام';

  @override
  String get hubOfferLateral => 'انتقال موازٍ';

  @override
  String get hubOfferRebuild => 'إعادة بناء';

  @override
  String careerNationsCupWon(String league) {
    return 'الدوري $league · البطل';
  }

  @override
  String careerNationsCupRunnerUp(String league) {
    return 'الدوري $league · الوصيف';
  }

  @override
  String careerNationsCupSemi(String league) {
    return 'الدوري $league · نصف النهائي';
  }

  @override
  String careerNationsCupPlaced(String league, int position) {
    return 'الدوري $league · #$position';
  }

  @override
  String tourRunInto(String round) {
    return 'إلى $round';
  }

  @override
  String get tourRunIntoThirdPlace => 'إلى مباراة المركز الثالث';

  @override
  String tourRunThrough(String round) {
    return 'عبر من $round';
  }

  @override
  String tourRunOut(String round) {
    return 'خرج في $round';
  }

  @override
  String get tourRunInGroup => 'ينافس في دور المجموعات';

  @override
  String get tourRunGroupOut => 'خرج من دور المجموعات';

  @override
  String resultsCycleTitle(int year, String nation) {
    return 'دورة $year · $nation';
  }

  @override
  String resultsCycleRecord(int played, int won, int drawn, int lost) {
    return '$played مباراة  ·  ف$won ت$drawn خ$lost';
  }

  @override
  String resultsCycleFinish(String finish) {
    return 'بطولة العالم: $finish';
  }

  @override
  String get resultsCycleUnderway => 'لا تزال جارية';

  @override
  String yTurnedItRound0(String opponent) {
    return 'متأخرون بهدفين أمام $opponent بين الشوطين واستعادوا كل شيء. هذا هو الفريق.';
  }

  @override
  String yTurnedItRound1(String opponent) {
    return 'متأخرون بهدفين أمام $opponent وفي النهاية لم يعد ذلك مهمًا. قلة من الفرق تفعل هذا.';
  }

  @override
  String yTurnedItRound2(String opponent) {
    return 'بين الشوطين: متأخرون بهدفين أمام $opponent. في النهاية: لا. الشوط الثاني كان مباراة أخرى.';
  }

  @override
  String yTurnedItRound3(String opponent) {
    return 'عدنا من تأخر بهدفين أمام $opponent. أيًا كان ما قيل بين الشوطين، قولوه كل أسبوع.';
  }

  @override
  String yTurnedItRound4(String opponent) {
    return 'حسنًا، عدنا أمام $opponent. والآن فليشرح أحد الدقائق الخمس والأربعين الأولى.';
  }

  @override
  String yTurnedItRound5(String opponent) {
    return 'متأخرون بهدفين أمام $opponent ويُفترض أن نكون سعداء. أصلحوا الشوط الأول.';
  }

  @override
  String yThrewItAway0(String opponent) {
    return 'متقدمون بهدفين على $opponent بين الشوطين وأفلتت. هذا يحدث لفرق أفضل.';
  }

  @override
  String yThrewItAway1(String opponent) {
    return 'متقدمون بهدفين على $opponent وأفلتت. الدورة طويلة، والوقت متسع.';
  }

  @override
  String yThrewItAway2(String opponent) {
    return 'بين الشوطين: متقدمون بهدفين على $opponent. في النهاية: لا شيء من ذلك.';
  }

  @override
  String yThrewItAway3(String opponent) {
    return 'تقدم بهدفين أمام $opponent، تبخّر خلال خمس وأربعين دقيقة.';
  }

  @override
  String yThrewItAway4(String opponent) {
    return 'متقدمون بهدفين وخسرنا. أمام $opponent. على أحدهم أن يُحاسَب.';
  }

  @override
  String yThrewItAway5(String opponent) {
    return 'متقدمون بهدفين أمام $opponent وتمكنّا من هذا. في كل مرة.';
  }

  @override
  String get cycleBackupDone =>
      'نُسخت المسيرة احتياطيًا إلى مجلد FNM على هذا الهاتف. إلغاء تثبيت التطبيق يحذفها: للاحتفاظ بنسخة في مكان آخر، استخدم «انسخ هذا الحفظ احتياطيًا» في شاشة ملفات الحفظ.';

  @override
  String get cycleBackupFailed => 'تعذّر نسخ المسيرة احتياطيًا هذه المرة.';

  @override
  String pressMomentBigWinWarm1(String opponent) {
    return 'ليلة لا تُنسى أمام $opponent. ما مدى فخرك بهذه المجموعة؟';
  }

  @override
  String pressMomentBigWinWarm2(String opponent) {
    return 'لم يستطع $opponent مجاراتكم. هل هذا هو الفريق الذي آمنت دائمًا بأنك تملكه؟';
  }

  @override
  String pressMomentBigWinNeutral1(String opponent) {
    return 'فوز كبير على $opponent. ما الذي صنع الفارق الليلة؟';
  }

  @override
  String pressMomentBigWinNeutral2(String opponent) {
    return 'هُزم $opponent، وبسهولة. أين حسمتم المباراة؟';
  }

  @override
  String pressMomentBigWinHostile1(String opponent) {
    return 'فوز جيد على $opponent. ليلة جيدة واحدة: لماذا يصدق أحد أنها ستدوم؟';
  }

  @override
  String pressMomentBigWinHostile2(String opponent) {
    return 'نتيجة جيدة أمام $opponent. هل كانت تلك خطتك، أم أن اللاعبين اكتشفوها بأنفسهم؟';
  }

  @override
  String pressMomentBigLossWarm1(String opponent) {
    return 'ليلة صعبة أمام $opponent. ماذا تقول للاعبين بعد مباراة كهذه؟';
  }

  @override
  String pressMomentBigLossWarm2(String opponent) {
    return 'لم يتوقع أحد ذلك أمام $opponent. هل كانت مجرد إحدى تلك الليالي؟';
  }

  @override
  String pressMomentBigLossNeutral1(String opponent) {
    return 'كانت ليلة قاسية أمام $opponent. ما الذي حدث خطأ؟';
  }

  @override
  String pressMomentBigLossNeutral2(String opponent) {
    return 'مزّقكم $opponent. هل هذه القائمة جيدة بما يكفي؟';
  }

  @override
  String pressMomentBigLossHostile1(String opponent) {
    return 'كنتم متأخرين في كل شيء أمام $opponent. كيف سمحت للأمور أن تسوء إلى هذا الحد؟';
  }

  @override
  String pressMomentBigLossHostile2(String opponent) {
    return 'سجّل $opponent كما يشاء. أين كانت الخطة الليلة؟';
  }

  @override
  String pressMomentCrisisWarm1(String opponent) {
    return 'مباراة أخرى تفلت، هذه المرة أمام $opponent. كيف ستقلب هذه السلسلة؟';
  }

  @override
  String pressMomentCrisisWarm2(String opponent) {
    return 'النتائج جفّت، و$opponent زاد الأمر سوءًا. هل ما زلت تؤمن بهذه المجموعة؟';
  }

  @override
  String pressMomentCrisisNeutral1(String opponent) {
    return 'لا فوز مجددًا، الآن أمام $opponent، والمجلس يراقب. هل وظيفتك آمنة؟';
  }

  @override
  String pressMomentCrisisNeutral2(String opponent) {
    return 'بعد $opponent، السلسلة تطول. هل أنت قلق على مستقبلك؟';
  }

  @override
  String pressMomentCrisisHostile1(String opponent) {
    return 'و$opponent أيضًا. سلفك أُقيل بعد سلسلة كهذه. لماذا يجب أن تنجو أنت؟';
  }

  @override
  String pressMomentCrisisHostile2(String opponent) {
    return 'بعد ليلة أخرى مثل $opponent، كل برامج الجمهور تريد رحيلك. هل ستتنحى إن طلب المجلس ذلك؟';
  }

  @override
  String pressMomentJobVerdictWarm1(String opponent) {
    return 'وضعت وظيفتك على المحك، وبعد $opponent لم تسر الأمور لصالحك. كيف حالك؟';
  }

  @override
  String pressMomentJobVerdictWarm2(String opponent) {
    return 'انتهت المباريات الثلاث، وآخرها أمام $opponent. أنت من وضع الاختبار. ما رأيك في الحكم؟';
  }

  @override
  String pressMomentJobVerdictNeutral1(String opponent) {
    return 'قلت لنا احكموا عليّ في المباريات الثلاث القادمة. بعد $opponent، فعلنا. هل لا تزال وظيفتك لك؟';
  }

  @override
  String pressMomentJobVerdictNeutral2(String opponent) {
    return 'ثلاث مباريات، آخرها أمام $opponent، وليست ما وعدت به. هل تحدثت مع المجلس بشأن مستقبلك؟';
  }

  @override
  String pressMomentJobVerdictHostile1(String opponent) {
    return 'وضعت الاختبار بنفسك وفشلت فيه أمام $opponent. هل ستستقيل؟';
  }

  @override
  String pressMomentJobVerdictHostile2(String opponent) {
    return 'كلماتك، لا كلماتنا: احكموا عليّ في الثلاث القادمة. بعد $opponent، لماذا لا تزال جالسًا هناك؟';
  }

  @override
  String get pressBeatWhoToBlameWarm1 => 'تريد منهم المزيد. أحد بعينه؟';

  @override
  String get pressBeatWhoToBlameWarm2 =>
      'رفعت سقف التوقعات. من عليه أن يتقدم أولًا؟';

  @override
  String get pressBeatWhoToBlameNeutral1 =>
      'تقول إن على بعضهم أن ينظروا إلى أنفسهم. من تقصد؟';

  @override
  String get pressBeatWhoToBlameNeutral2 =>
      'ليس جيدًا بما يكفي، تقول. عمّن تتحدث؟';

  @override
  String get pressBeatWhoToBlameHostile1 =>
      'تبقى غامضًا. هل ستذكر أسماء، أم أن الأمر يعود إليك؟';

  @override
  String get pressBeatWhoToBlameHostile2 =>
      'كل أسبوع الخطأ خطأ شخص آخر. خطأ من هذه المرة؟';

  @override
  String get pressBeatIfYouDontWarm1 =>
      'كلمات شجاعة. وإن لم تسر المباراة القادمة لصالحك؟';

  @override
  String get pressBeatIfYouDontWarm2 =>
      'البلاد ستحاسبك على ذلك. ماذا لو لم ينجح؟';

  @override
  String get pressBeatIfYouDontNeutral1 => 'وإن لم تفز؟ ماذا بعد؟';

  @override
  String get pressBeatIfYouDontNeutral2 =>
      'قلتها الآن. ماذا يحدث إن كنت مخطئًا؟';

  @override
  String get pressBeatIfYouDontHostile1 =>
      'سمعنا وعودًا في هذه القاعة من قبل. بماذا تدين للجماهير إن انكسر هذا الوعد أيضًا؟';

  @override
  String get pressBeatIfYouDontHostile2 =>
      'وحين لا يحدث ذلك، ماذا سيكون العذر؟';

  @override
  String get pressBeatFollowUpWarm1 =>
      'سؤال آخر، إن كان لديك الطاقة. ما الذي لا تزال هذه المجموعة بحاجة إلى العمل عليه؟';

  @override
  String get pressBeatFollowUpWarm2 =>
      'حين يهدأ الغبار، ماذا تأخذ من الليلة إلى المباراة القادمة؟';

  @override
  String get pressBeatFollowUpNeutral1 =>
      'لنتعمق قليلًا. ما الذي يجب أن يتحسن قبل المباراة القادمة؟';

  @override
  String get pressBeatFollowUpNeutral2 =>
      'بعيدًا عن النتيجة: هل هذه القائمة حيث تريدها؟';

  @override
  String get pressBeatFollowUpHostile1 =>
      'كلام كثير، ومضمون قليل. ما الذي سيتغير فعلًا من الآن؟';

  @override
  String get pressBeatFollowUpHostile2 =>
      'الجماهير تريد جوابًا صريحًا. هل هذا الفريق جيد بما يكفي، نعم أم لا؟';

  @override
  String pressBeatStandoutWarm1(String player) {
    return 'كان $player مذهلًا الليلة. إلى أي مدى يمكنه الوصول؟';
  }

  @override
  String pressBeatStandoutWarm2(String player) {
    return '$player في كل العناوين الليلة. هل توقعت ذلك؟';
  }

  @override
  String pressBeatStandoutNeutral1(String player) {
    return 'تألق $player. ماذا طلبت منه الليلة؟';
  }

  @override
  String pressBeatStandoutNeutral2(String player) {
    return 'هل كان $player الفارق الليلة؟';
  }

  @override
  String pressBeatStandoutHostile1(String player) {
    return 'من دون $player القصة مختلفة. هل هذا فريق، أم لاعب واحد؟';
  }

  @override
  String pressBeatStandoutHostile2(String player) {
    return 'كان $player رائعًا. بفضلك، أم بفضله؟';
  }

  @override
  String pressBeatStrugglerWarm1(String player) {
    return 'مرّ $player بليلة صعبة. هل يعاني من إصابة؟';
  }

  @override
  String pressBeatStrugglerWarm2(String player) {
    return 'لم تكن ليلة $player. هل ستحتضنه؟';
  }

  @override
  String pressBeatStrugglerNeutral1(String player) {
    return 'عانى $player الليلة. هل يحتفظ بمكانه؟';
  }

  @override
  String pressBeatStrugglerNeutral2(String player) {
    return 'بدا $player بعيدًا عن الإيقاع. ما رأيك في مباراته؟';
  }

  @override
  String pressBeatStrugglerHostile1(String player) {
    return 'كان $player مجرد راكب مجددًا. لماذا تواصل اختياره؟';
  }

  @override
  String pressBeatStrugglerHostile2(String player) {
    return 'رأى الجميع أن $player لم يكن في مستواه. الجميع باستثناء الدكة؟';
  }

  @override
  String get pressThrowbackWinNextKeptWarm =>
      'قلت إنك ستفوز بالمباراة التالية، وفعلت. هل من الجيد أن تكون محقًا؟';

  @override
  String get pressThrowbackWinNextKeptNeutral =>
      'وعدت بالفوز في المباراة التالية ووفيت. ثقة، أم تبجح؟';

  @override
  String get pressThrowbackWinNextKeptHostile =>
      'قلت إنك ستفوز بالمباراة التالية، وفعلت. حظ، أم يُفترض أن نبدأ بالإصغاء؟';

  @override
  String get pressThrowbackWinNextBrokenWarm =>
      'قلت لنا إنك ستفوز بتلك المباراة. لم يحدث ذلك. ما الذي حدث خطأ؟';

  @override
  String get pressThrowbackWinNextBrokenNeutral =>
      'قلت إنك ستفوز بالمباراة التالية. لم تفعل. لماذا نصدق الوعد القادم؟';

  @override
  String get pressThrowbackWinNextBrokenHostile =>
      'قلت إنك ستفوز بالمباراة التالية. لم تفعل. هل لا تزال لكلماتك قيمة في هذه القاعة؟';

  @override
  String get pressThrowbackJobKeptWarm =>
      'طلبت أن يُحكم عليك في ثلاث مباريات، ونجحت. هل أنصفتك النتائج؟';

  @override
  String get pressThrowbackJobKeptNeutral =>
      'احكموا عليّ في الثلاث القادمة، قلت. فعلنا، وجاءت النتائج. ماذا علّمك ذلك الاختبار؟';

  @override
  String get pressThrowbackJobKeptHostile =>
      'منحت نفسك ثلاث مباريات وتجاوزتها. هل كان الاختبار صعبًا أصلًا؟';

  @override
  String get pressThrowbackJobBrokenWarm =>
      'طلبت أن يُحكم عليك في ثلاث مباريات. لم تسر لصالحك. ماذا تعلمت؟';

  @override
  String get pressThrowbackJobBrokenNeutral =>
      'قلت احكموا عليّ في الثلاث القادمة. انتهت الثلاث، وانتهى معها حسن الظن. ماذا الآن؟';

  @override
  String get pressThrowbackJobBrokenHostile =>
      'وضعت الاختبار وفشلت فيه. لماذا يأخذ أحد بكلمتك الآن؟';

  @override
  String pressThrowbackBackKeptWarm(String player) {
    return 'دعمت $player حين لم يفعل الآخرون. وقدّم. هل لك جزء من الفضل؟';
  }

  @override
  String pressThrowbackBackKeptNeutral(String player) {
    return 'دعمت $player. وقدّم. إيمان، أم معرفة؟';
  }

  @override
  String pressThrowbackBackKeptHostile(String player) {
    return 'دعمت $player، ولمرة واحدة نجح الأمر. هل ستكون واثقًا هكذا في المرة القادمة؟';
  }

  @override
  String pressThrowbackBackBrokenWarm(String player) {
    return 'وقفت إلى جانب $player، ولم ينجح الأمر. هل لا تزال تؤمن به؟';
  }

  @override
  String pressThrowbackBackBrokenNeutral(String player) {
    return 'دعمت $player. لم يردّ الجميل. هل كان ذلك خطأ؟';
  }

  @override
  String pressThrowbackBackBrokenHostile(String player) {
    return 'حكمك أم ولاؤك: أيهما خذلك مع $player؟';
  }

  @override
  String pressThrowbackBlameKeptWarm(String player) {
    return 'كنت قاسيًا على $player، والمباريات منذ ذلك الحين أثبتت أنك محق. هل يرضيك ذلك؟';
  }

  @override
  String pressThrowbackBlameKeptNeutral(String player) {
    return 'انتقدت $player علنًا، ولم يردّ. هل هناك طريق للعودة له؟';
  }

  @override
  String pressThrowbackBlameKeptHostile(String player) {
    return 'تخليت عن $player علنًا ولم يتعافَ. هل حطّمته؟';
  }

  @override
  String pressThrowbackBlameBrokenWarm(String player) {
    return 'انتقدت $player علنًا، وردّ عليك في الملعب. هل كانت تلك الفكرة منذ البداية؟';
  }

  @override
  String pressThrowbackBlameBrokenNeutral(String player) {
    return 'ألقيت اللوم على $player، ومنذ ذلك الحين كان من أفضل لاعبيك. هل تدين له باعتذار؟';
  }

  @override
  String pressThrowbackBlameBrokenHostile(String player) {
    return 'رميت $player تحت الحافلة، وكان أفضل لاعبيك منذ ذلك الحين. هل ستعتذر؟';
  }

  @override
  String get pressReplyCreditPlayers1 =>
      'هؤلاء اللاعبون قدموا لي كل شيء. لن أستبدل أي واحد منهم.';

  @override
  String get pressReplyCreditPlayers2 =>
      'لا أحد يعمل أكثر من هذه المجموعة. سأدافع عنهم طوال اليوم.';

  @override
  String get pressReplyCreditPlayers3 =>
      'لن تسمع كلمة ضد لاعبيّ من هذا المقعد.';

  @override
  String get pressReplyCreditPlayers4 =>
      'اللاعبون يستحقون الفضل، لا أنا. اكتبوا عنهم.';

  @override
  String get pressReplyTakeResponsibility1 =>
      'هذه مسؤوليتي. أنا اخترت التشكيلة وأنا رتبتهم.';

  @override
  String get pressReplyTakeResponsibility2 =>
      'احكموا عليّ، لا عليهم. إنه فريقي ومسؤوليتي.';

  @override
  String get pressReplyTakeResponsibility3 =>
      'إن أردتم أحدًا لتلوموه، فأنا جالس هنا.';

  @override
  String get pressReplyTakeResponsibility4 =>
      'المسؤولية مسؤوليتي. اتركوا اللاعبين خارج الأمر.';

  @override
  String get pressReplyDemandMore1 =>
      'أريد المزيد. بعضهم يعرف تمامًا ما أعنيه.';

  @override
  String get pressReplyDemandMore2 =>
      'الجهد لا يكفي في هذا المستوى. أريد المزيد، وقلت لهم ذلك.';

  @override
  String get pressReplyDemandMore3 =>
      'أتوقع المزيد من كل واحد منهم، بدءًا من الغد.';

  @override
  String get pressReplyDemandMore4 =>
      'على بعضهم أن ينظروا إلى أنفسهم. لست راضيًا.';

  @override
  String get pressReplyPromiseWinNext1 =>
      'سنفوز بالمباراة القادمة. يمكنكم كتابة ذلك.';

  @override
  String get pressReplyPromiseWinNext2 =>
      'تذكروا كلامي: سنفوز بالمباراة القادمة.';

  @override
  String get pressReplyPromiseWinNext3 =>
      'المباراة القادمة، سنفوز. أقولها هنا لتحاسبوني عليها.';

  @override
  String get pressReplyPromiseWinNext4 =>
      'أنا واثق من هذا الفريق. سنفوز بالمباراة القادمة.';

  @override
  String get pressReplyJobOnTheLine1 =>
      'احكموا عليّ في المباريات الثلاث القادمة. هذا عادل.';

  @override
  String get pressReplyJobOnTheLine2 =>
      'امنحوني ثلاث مباريات. إن لم تتحسن الأمور حينها، فاحكموا عليّ.';

  @override
  String get pressReplyJobOnTheLine3 =>
      'الثلاث القادمة ستُظهر إن كنت الرجل المناسب. حاسبوني على ذلك.';

  @override
  String get pressReplyJobOnTheLine4 => 'ثلاث مباريات. ثم اكتبوا عني ما شئتم.';

  @override
  String get pressReplyDeflect1 => 'نأخذ الأمور مباراة بمباراة. لا شيء أضيفه.';

  @override
  String get pressReplyDeflect2 => 'لن أصنع لكم عناوين اليوم.';

  @override
  String get pressReplyDeflect3 => 'المباراة القادمة. هذا كل ما أفكر فيه.';

  @override
  String get pressReplyDeflect4 => 'ما أفكر فيه يبقى في غرفة الملابس.';

  @override
  String get pressReplyTakeCredit1 => 'قلتها لأنني آمنت بها، وكنت محقًا.';

  @override
  String get pressReplyTakeCredit2 => 'قرأت الأمر بشكل صحيح. لهذا أنا هنا.';

  @override
  String get pressReplyTakeCredit3 => 'سمّوه حسن تقدير. كنت أعرف ما أقول.';

  @override
  String get pressReplyTakeCredit4 => 'اتخذت القرار ونجح. سأقبل ذلك.';

  @override
  String get pressReplyStandByIt1 => 'قلت ما آمنت به. وأتمسك به.';

  @override
  String get pressReplyStandByIt2 => 'لا أتراجع عن كلمة واحدة.';

  @override
  String get pressReplyStandByIt3 =>
      'الجواب نفسه كما في ذلك الحين. عنيته، وما زلت أعنيه.';

  @override
  String get pressReplyStandByIt4 => 'سأقولها مجددًا غدًا.';

  @override
  String get pressReplyAdmitMistake1 => 'أخطأت في تلك. أتحمل المسؤولية.';

  @override
  String get pressReplyAdmitMistake2 => 'حسنًا، أسأت التقدير. سأتعلم من ذلك.';

  @override
  String get pressReplyAdmitMistake3 => 'كنت مخطئًا، ويمكنني قول ذلك.';

  @override
  String get pressReplyAdmitMistake4 => 'ذلك القرار لم ينجح، وكان قراري.';

  @override
  String pressReplyBackPlayer1(String player) {
    return '$player يحظى بدعمي الكامل. سيعود إلى مستواه.';
  }

  @override
  String pressReplyBackPlayer2(String player) {
    return 'أؤمن بـ$player، وسيُريكم السبب.';
  }

  @override
  String pressReplyBackPlayer3(String player) {
    return 'لن تسمعوا مني كلمة ضد $player. سيقدّم.';
  }

  @override
  String pressReplyBackPlayer4(String player) {
    return '$player يبقى ضمن خططي. شاهدوا ما سيفعله بعد ذلك.';
  }

  @override
  String pressReplyBlamePlayer1(String player) {
    return 'خذلنا $player الليلة، وهو يعرف ذلك.';
  }

  @override
  String pressReplyBlamePlayer2(String player) {
    return 'توقعت أكثر بكثير من $player. عليه أن يجيب عن ذلك.';
  }

  @override
  String pressReplyBlamePlayer3(String player) {
    return 'لم يكن $player في المستوى. سأقولها علنًا.';
  }

  @override
  String pressReplyBlamePlayer4(String player) {
    return 'لم يكن ذلك جيدًا بما يكفي من $player، وسيسمع ذلك مني.';
  }

  @override
  String get pressOnRecordWinNext => 'مسجّل: ستفوز بالمباراة القادمة.';

  @override
  String get pressOnRecordJob => 'مسجّل: احكموا عليك في الثلاث القادمة.';

  @override
  String pressOnRecordBack(String player) {
    return 'مسجّل: دعم $player.';
  }

  @override
  String pressOnRecordBlame(String player) {
    return 'مسجّل: $player خذلك.';
  }

  @override
  String yStatementKept0(String nation) {
    return 'قالها، وحدثت. لدى $nation مدرب يعني ما يقول.';
  }

  @override
  String yStatementKept1(String nation) {
    return 'قالها بصوت عالٍ، ثم ذهب وفعلها. هذا هو الرجل الذي احتاجه $nation.';
  }

  @override
  String yStatementKept2(String nation) {
    return '$nation: توقعها، وتحققت. حسنًا.';
  }

  @override
  String yStatementKept3(String nation) {
    return 'سجّلها علنًا وصمدت. نقطة لصالحه. $nation يمضي.';
  }

  @override
  String yStatementKept4(String nation) {
    return 'أصاب في واحدة. $nation، لا تعتادوا على ذلك.';
  }

  @override
  String yStatementKept5(String nation) {
    return 'حتى الساعة المتوقفة تصيب مرتين في اليوم. حالف الحظ $nation هذه المرة.';
  }

  @override
  String yStatementBroken0(String nation) {
    return 'قالها ولم تتحقق. ما زلت معه. $nation يحاول مجددًا.';
  }

  @override
  String yStatementBroken1(String nation) {
    return '$nation: وعد بأكثر مما حصلنا عليه، لكنني أفضّل مدربًا يثق بنفسه.';
  }

  @override
  String yStatementBroken2(String nation) {
    return '$nation: قالها علنًا ولم تحدث. الناس سيتذكرون.';
  }

  @override
  String yStatementBroken3(String nation) {
    return 'كلمات كبيرة، ولا شيء خلفها. $nation: في المرة القادمة، قل أقل.';
  }

  @override
  String yStatementBroken4(String nation) {
    return 'وقف هناك وأخبرنا. ثم هذا. $nation يستحق أفضل من الكلام.';
  }

  @override
  String yStatementBroken5(String nation) {
    return 'كلمته لا قيمة لها الآن. دوّنوا ذلك، $nation.';
  }

  @override
  String get ncZoneNorth => 'المنطقة الشمالية';

  @override
  String get ncZoneWest => 'المنطقة الغربية';

  @override
  String get ncZoneEast => 'المنطقة الشرقية';

  @override
  String get ncZoneCentralSouthern => 'منطقة الوسط والجنوب';

  @override
  String careerNationsCupZoneWon(String zone) {
    return '$zone · البطل';
  }

  @override
  String careerNationsCupZoneRunnerUp(String zone) {
    return '$zone · الوصيف';
  }

  @override
  String careerNationsCupZoneSemi(String zone) {
    return '$zone · نصف النهائي';
  }

  @override
  String careerNationsCupZoneRoundOf16(String zone) {
    return '$zone · دور الـ16';
  }

  @override
  String careerNationsCupZoneQuarter(String zone) {
    return '$zone · ربع النهائي';
  }

  @override
  String careerNationsCupZonePlaced(String zone, int position) {
    return '$zone · #$position';
  }

  @override
  String get objectiveNcFinalsEight => 'بلوغ ربع النهائي';

  @override
  String get objectiveNcZoneWinGroup => 'تصدّر مجموعتك';

  @override
  String get finishNcFinalsEight => 'ربع النهائي';

  @override
  String get finishNcBottomHalf => 'النصف الأدنى من المجموعة';

  @override
  String get tourContTabZones => 'المناطق';

  @override
  String get tourContTabFinalsEight => 'الإقصائيات';

  @override
  String get tourContFinalsEightSoon =>
      'تبدأ الأدوار الإقصائية في نوفمبر بدور الـ16: متصدرو المجموعات الـ14 وأفضل وصيفين.';

  @override
  String get tourContQuarterFinals => 'ربع النهائي';

  @override
  String get tourContZoneAdvancement =>
      'كل متصدر مجموعة يتأهل إلى دور الـ16، ومعه أفضل وصيفين. لا هبوط لأحد.';

  @override
  String tourContZoneHeadingYours(String zone) {
    return '$zone ★';
  }

  @override
  String get compNorthAmericaNationsCup => 'كأس أمم أمريكا الشمالية';

  @override
  String get compAfricanNationsCup => 'كأس الأمم';

  @override
  String get objectiveNcWinItNorthAmerica => 'الفوز بكأس أمم أمريكا الشمالية';

  @override
  String get objectiveNcWinItAfrica => 'الفوز بكأس الأمم';

  @override
  String get objectiveNcReachFinalNorthAmerica =>
      'بلوغ نهائي كأس أمم أمريكا الشمالية';

  @override
  String get objectiveNcReachFinalAfrica => 'بلوغ نهائي كأس الأمم';

  @override
  String get finishNcChampionsNorthAmerica => 'أبطال كأس أمم أمريكا الشمالية';

  @override
  String get finishNcChampionsAfrica => 'أبطال كأس الأمم';

  @override
  String pressAimQualWarm1(String competition) {
    return 'تصفيات $competition تبدأ الآن، والبلاد تؤمن بهذا الفريق. ما الذي تطمح إليه؟';
  }

  @override
  String pressAimQualWarm2(String competition) {
    return 'حملة تصفيات جديدة لـ$competition، والمعنويات مرتفعة. إلى أي مدى يمكن لهذا الفريق أن يصل؟';
  }

  @override
  String pressAimQualNeutral1(String competition) {
    return 'تصفيات $competition تبدأ. ما الهدف من هذه الحملة؟';
  }

  @override
  String pressAimQualNeutral2(String competition) {
    return 'تصفيات $competition هنا. أين ترى هذا الفريق ينهي المشوار؟';
  }

  @override
  String pressAimQualHostile1(String competition) {
    return 'تصفيات $competition تبدأ، وكثيرون يشككون في وصولك. ماذا تقول لهم؟';
  }

  @override
  String pressAimQualHostile2(String competition) {
    return 'حملة تصفيات أخرى لـ$competition. لماذا يصدق أحد أن هذه ستكون مختلفة؟';
  }

  @override
  String pressAimFinalsWarm1(String competition) {
    return '$competition هنا والبلاد كلها خلفك. إلى أي مدى يمكنك الوصول؟';
  }

  @override
  String pressAimFinalsWarm2(String competition) {
    return 'أنت في $competition والجماهير تحلم. ما الهدف؟';
  }

  @override
  String pressAimFinalsNeutral1(String competition) {
    return '$competition تبدأ هذا الأسبوع. ما الذي يُعدّ نجاحًا؟';
  }

  @override
  String pressAimFinalsNeutral2(String competition) {
    return 'مباراتك الأولى في $competition قريبة. حدد لنا هدفًا.';
  }

  @override
  String pressAimFinalsHostile1(String competition) {
    return '$competition هنا ولا أحد يتوقع الكثير. ما الذي تأمله حقًا؟';
  }

  @override
  String pressAimFinalsHostile2(String competition) {
    return 'أنت في $competition، لكن الشكوك لم تختفِ. ما هدفك؟';
  }

  @override
  String pressBeatRivalWarm1(String rival) {
    return '$rival في مجموعتك. هل يقلقك؟';
  }

  @override
  String pressBeatRivalWarm2(String rival) {
    return 'وضعت القرعة $rival في طريقك. كيف ترى تلك المباراة؟';
  }

  @override
  String pressBeatRivalNeutral1(String rival) {
    return '$rival يبدو أقوى فريق في مجموعتك. هل هو المرشح؟';
  }

  @override
  String pressBeatRivalNeutral2(String rival) {
    return 'ما رأيك في $rival؟';
  }

  @override
  String pressBeatRivalHostile1(String rival) {
    return '$rival في مجموعتك. بصراحة، هل تستطيع مجاراته؟';
  }

  @override
  String pressBeatRivalHostile2(String rival) {
    return 'معظم الناس يتوقعون أن يهزمك $rival. هل هم مخطئون؟';
  }

  @override
  String pressBeatKeyPlayerWarm1(String player) {
    return '$player في مستوى رائع. هل هذه لحظته؟';
  }

  @override
  String pressBeatKeyPlayerWarm2(String player) {
    return '$player في كل العناوين. هل يستطيع حمل هذا الفريق؟';
  }

  @override
  String pressBeatKeyPlayerNeutral1(String player) {
    return 'إلى أي مدى تعتمد هذه الحملة على $player؟';
  }

  @override
  String pressBeatKeyPlayerNeutral2(String player) {
    return 'هل $player مستعد لقيادة هذا الفريق؟';
  }

  @override
  String pressBeatKeyPlayerHostile1(String player) {
    return 'إن لم يكن $player في أفضل حالاته، هل لدى هذا الفريق أي شيء؟';
  }

  @override
  String pressBeatKeyPlayerHostile2(String player) {
    return '$player يحمل الكثير على كتفيه. أكثر من اللازم؟';
  }

  @override
  String get pressReplyAimHigher1 => 'سنذهب أبعد مما يتوقعه أي أحد.';

  @override
  String get pressReplyAimHigher2 =>
      'أريد أكثر مما طلبه الاتحاد، وسأقولها بصوت عالٍ.';

  @override
  String get pressReplyMatchBrief1 => 'نعرف الهدف وسنحققه.';

  @override
  String get pressReplyMatchBrief2 => 'حدد الاتحاد هدفًا. سنحققه.';

  @override
  String get pressReplyPlayDown1 => 'لنأخذ الأمور مباراة بمباراة.';

  @override
  String get pressReplyPlayDown2 => 'لا وعود كبيرة. سنرى أين نحن.';

  @override
  String get pressReplyPromiseQualify1 => 'سنتأهل. يمكنكم كتابة ذلك.';

  @override
  String get pressReplyPromiseQualify2 => 'هذا الفريق سيكون في النهائيات.';

  @override
  String get pressReplyFearNobody1 => 'لا نخشى أحدًا.';

  @override
  String get pressReplyFearNobody2 => 'عليهم أن يلعبوا ضدنا أيضًا.';

  @override
  String get pressReplyRespectRival1 => 'إنهم المرشحون، ونحترمهم.';

  @override
  String get pressReplyRespectRival2 =>
      'فريق جيد جدًا. سنحتاج إلى أفضل ما لدينا.';

  @override
  String get pressReplyTeamFirst1 => 'الأمر يتعلق بالفريق كله، لا بلاعب واحد.';

  @override
  String get pressReplyTeamFirst2 => 'لا أحد يفوز بهذا وحده.';

  @override
  String pressOnRecordTarget(String aim) {
    return 'مسجّل: $aim.';
  }

  @override
  String get pressOnRecordPlayDown => 'مسجّل: لا وعود.';

  @override
  String get pressThrowbackTargetKeptWarm =>
      'حددت هدفًا قبل الحملة وحققته. هل هذه أكثر لحظاتك فخرًا حتى الآن؟';

  @override
  String get pressThrowbackTargetKeptNeutral =>
      'قلت ما ستحققه، وفعلت. هل كان هناك شك يومًا؟';

  @override
  String get pressThrowbackTargetKeptHostile =>
      'حققت الهدف الذي حددته. حظ، أم كانت تلك الخطة فعلًا؟';

  @override
  String get pressThrowbackTargetBrokenWarm =>
      'حددت هدفًا ولم تبلغه. ما الذي حدث خطأ؟';

  @override
  String get pressThrowbackTargetBrokenNeutral =>
      'وعدت بأكثر مما قدمه هذا الفريق. هل تندم على قول ذلك؟';

  @override
  String get pressThrowbackTargetBrokenHostile =>
      'تحدثت بثقة كبيرة قبل الحملة ولم تبلغ الهدف. لماذا نصدقك الآن؟';

  @override
  String hubEventPressPreviewSub(String competition) {
    return 'الصحافة تريد سماع طموحاتك في $competition';
  }

  @override
  String deptLevelCost(int level, String amount) {
    return 'المستوى $level · $amount';
  }

  @override
  String get formOnFire => 'في قمة التوهج';

  @override
  String get formGood => 'في مستوى جيد';

  @override
  String get formSteady => 'مستقر';

  @override
  String get formPoor => 'بعيد عن مستواه';

  @override
  String get formCold => 'في أسوأ حالاته';

  @override
  String get playerFormTitle => 'المستوى واللياقة';

  @override
  String playerFormAverage(String rating) {
    return 'متوسطه $rating في مبارياته الأخيرة';
  }

  @override
  String get playerFormNoGames => 'لا مباريات حديثة كافية للحكم';

  @override
  String playerFormNextMatch(String delta) {
    return '⁦$delta⁩ لتقييمه في المباراة القادمة';
  }

  @override
  String get playerFormNoEffect => 'لا تغيير في تقييمه في المباراة القادمة';

  @override
  String playerFormSquadShare(String delta) {
    return 'يشمل ⁦$delta⁩ يتقاسمها الفريق كله (المعنويات، المعسكر)';
  }

  @override
  String get sideGroupHome => 'الرئيسية';

  @override
  String get sideGroupTeam => 'الفريق';

  @override
  String get sideGroupCompetitions => 'المسابقات';

  @override
  String get sideGroupFederation => 'الاتحاد';

  @override
  String get sideGroupHistory => 'التاريخ';

  @override
  String get sideInbox => 'البريد';

  @override
  String get sideSquad => 'القائمة';

  @override
  String get sideTactics => 'التكتيك';

  @override
  String get sideMainMenu => 'القائمة الرئيسية';

  @override
  String get sideCallUps => 'الاستدعاءات';

  @override
  String get sideTournaments => 'البطولات';

  @override
  String get sideRanking => 'التصنيف';

  @override
  String get sideResults => 'النتائج';

  @override
  String get sideFinances => 'الماليات';

  @override
  String get sideBoard => 'المجلس';

  @override
  String get sideManager => 'المدرب والطاقم';

  @override
  String get sideRecords => 'الأرقام';

  @override
  String get sideLegends => 'الأساطير';

  @override
  String get sideHeadToHead => 'المواجهات المباشرة';

  @override
  String get sideAchievements => 'الإنجازات';

  @override
  String get sideCareer => 'المسيرة';

  @override
  String get topBarNext => 'التالي';

  @override
  String get topBarDrawPending => 'القرعة قادمة';

  @override
  String get paneFullProfile => 'الملف الكامل';

  @override
  String get panePickPlayer => 'اختر لاعبًا لترى بطاقته هنا';

  @override
  String get inboxPickMessage => 'اختر رسالة لقراءتها هنا';

  @override
  String get inboxFilterAll => 'الكل';

  @override
  String get panelViewAll => 'عرض الكل';

  @override
  String get gridViewOverview => 'نظرة عامة';

  @override
  String get gridColCondition => 'الحالة البدنية';

  @override
  String get gridColStatus => 'الوضع';

  @override
  String get gridColRank => 'المركز';

  @override
  String get gridColMove => 'التغيّر';

  @override
  String get gridColNation => 'المنتخب';

  @override
  String get gridColRegion => 'المنطقة';

  @override
  String get gridColPoints => 'النقاط';

  @override
  String get panePickNation => 'اختر منتخبًا لترى سجله هنا';

  @override
  String get resultsCyclesTitle => 'الدورات';

  @override
  String get tourDrawStart => 'ابدأ القرعة';

  @override
  String get tourDrawViewGroups => 'عرض المجموعات';

  @override
  String get gridColCeiling => 'السقف';

  @override
  String get gridColYearGain => 'التطور';

  @override
  String get gridColMarkedAt => 'وقت التعليم';

  @override
  String get budgetSetupTitle => 'حدد ميزانيتك';

  @override
  String get budgetEffectsTitle => 'ما تشتريه هذه الميزانية';

  @override
  String get naturalisationTitle => 'التجنيس';

  @override
  String get yTrending => 'الأكثر تداولًا';

  @override
  String get yVoices => 'الأصوات';

  @override
  String get yConversation => 'المحادثة';

  @override
  String get allTimeRecordsTitle => 'الأرقام القياسية العالمية التاريخية';

  @override
  String get h2hMeetingsTitle => 'كل المواجهات';

  @override
  String get h2hPickOpponent => 'اختر منافسًا لترى كل المواجهات هنا';

  @override
  String get savesTitle => 'ملفات الحفظ';

  @override
  String get gridColPlayer => 'اللاعب';

  @override
  String get gridColPos => 'المركز';

  @override
  String get gridColActive => 'نشط';

  @override
  String get gridColMotm => 'رجل المباراة';

  @override
  String get gridColAvg => 'المتوسط';

  @override
  String get gridColOpponent => 'المنافس';

  @override
  String get gridColStarts => 'أساسي';

  @override
  String get gridColTournaments => 'البطولات';

  @override
  String get gridColDate => 'التاريخ';

  @override
  String get gridColLastPlayed => 'آخر لعب';

  @override
  String get gridColManager => 'المدرب';

  @override
  String nationsShownCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count منتخب',
      many: '$count منتخبًا',
      few: '$count منتخبات',
      two: 'منتخبان',
      one: 'منتخب واحد',
      zero: '$count منتخب',
    );
    return '$_temp0';
  }

  @override
  String get nationsSortedByRank => 'مرتبة حسب التصنيف العالمي';

  @override
  String get nationsStrength => 'القوة';

  @override
  String nationsStrengthOf(int tier) {
    return '$tier من 5';
  }

  @override
  String get nationsSquadOverall => 'التقييم العام للفريق';

  @override
  String get nationsOpeningBudget => 'الميزانية الافتتاحية';

  @override
  String get nationsStarPlayer => 'النجم';

  @override
  String nationsStarTile(String position, int rating) {
    return 'النجم $position $rating';
  }

  @override
  String nationsStarAge(int age) {
    return 'العمر $age';
  }

  @override
  String get nationsBoardExpects => 'ينتظر المجلس';

  @override
  String nationsManage(String nation) {
    return 'درّب $nation';
  }

  @override
  String get nationsManagerNext => 'تسمّي مدربك بعد ذلك';

  @override
  String get playerPageTitle => 'اللاعب';

  @override
  String get nationPageTitle => 'المنتخب';

  @override
  String get friendliesYourGames => 'مبارياتك الودية';

  @override
  String hubEventInjuryCover(String player) {
    return 'عوّض المصاب $player';
  }

  @override
  String hubEventInjuryCoverSub(int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: 'غائب عن $matches مباراة',
      many: 'غائب عن $matches مباراة',
      few: 'غائب عن $matches مباريات',
      two: 'غائب عن مباراتين',
      one: 'غائب عن المباراة القادمة',
      zero: 'متاح للمباراة القادمة',
    );
    return '$_temp0. استدعِ أحدًا، أو واصل من دونه.';
  }

  @override
  String get injuryCoverTitle => 'البديل';

  @override
  String injuryCoverBanner(String player, String position) {
    return '$player ($position) مصاب. استدعِ أي لاعب من خارج القائمة، في أي مركز، أو أبقِه وواصل.';
  }

  @override
  String injuryCoverConfirm(String player) {
    return 'استدعِ $player';
  }

  @override
  String injuryCoverKeep(String player) {
    return 'أبقِ $player وواصل';
  }

  @override
  String get injuryCoverPick => 'اختر بديلًا';

  @override
  String get injuryCoverNone => 'لا أحد خارج القائمة جاهز للانضمام.';

  @override
  String get nationNowRanking => 'التصنيف العالمي';

  @override
  String get nationNowForm => 'المستوى';

  @override
  String get nationNowNoForm => 'لم تُلعب أي مباراة بعد';

  @override
  String get nationNowNext => 'المباراة التالية';

  @override
  String get nationNowNoNext => 'لا شيء مجدول';

  @override
  String get nationNowSquad => 'القائمة';

  @override
  String get nationNowAgainstYou => 'أمامك';

  @override
  String nationNowRecord(int w, int d, int l) {
    return 'ف$w ت$d خ$l';
  }

  @override
  String get nationNowLastMeeting => 'آخر مواجهة';

  @override
  String nationNowOverall(int value) {
    return 'التقييم العام $value';
  }

  @override
  String get hubUpcoming => 'القادم';

  @override
  String get hubFullSchedule => 'الجدول الكامل';

  @override
  String get scheduleTitle => 'الجدول';

  @override
  String get scheduleToday => 'اليوم';

  @override
  String get scheduleKnockoutPending => 'الأدوار الإقصائية، إن تأهلت';

  @override
  String get scheduleNextRoundPending => 'الدور التالي';

  @override
  String scheduleFromDate(String date) {
    return 'ابتداءً من $date';
  }

  @override
  String get scheduleHomeShort => 'د';

  @override
  String get scheduleAwayShort => 'خ';

  @override
  String get tacticsNoPresetsInMatch =>
      'لا خطط محفوظة بعد. احفظ واحدة من شاشة التكتيك قبل المباراة.';

  @override
  String get homeCampaigns => 'الحملات';

  @override
  String get homeContinueCampaign => 'واصل الحملة';

  @override
  String homeCampaignCycle(String date, int cycle, int total) {
    return '$date · الدورة $cycle من $total';
  }

  @override
  String get campaignsTitle => 'الحملات';

  @override
  String get campaignTransplantTitle => 'الزرع';

  @override
  String get campaignTransplantTwist =>
      'ستة من أفضل لاعبي إيطاليا يغيّرون جنسيتهم الرياضية إلى سان مارينو';

  @override
  String get campaignTransplantGoal => 'التأهل إلى بطولة أوروبا';

  @override
  String get campaignGrudgeTitle => 'الثأر';

  @override
  String get campaignGrudgeTwist => 'جورجيا وألبانيا في مجموعة واحدة';

  @override
  String get campaignGrudgeGoal => 'إنهاء التصفيات فوق ألبانيا';

  @override
  String get campaignTransplantIntro =>
      'لم تخض سان مارينو قط حملة تصفيات تستحق الذكر. ثم يحمل ستة من أفضل لاعبي إيطاليا جوازها ويدخلون. لديك دورة واحدة لتحويل الطرافة إلى فريق.';

  @override
  String get campaignGrudgeIntro =>
      'وقعت جورجيا وألبانيا في مجموعة التصفيات نفسها، ولن يغفر أي منهما الهزيمة. أنهِ فوق ألبانيا، ثم انظر إلى أي مدى يمكنك المضي.';

  @override
  String get campaignStars1Transplant => 'التأهل';

  @override
  String get campaignStars2Transplant => 'بلوغ الأدوار الإقصائية';

  @override
  String get campaignStars3Transplant => 'الفوز ببطولة أوروبا';

  @override
  String get campaignStars1Grudge => 'فوق ألبانيا';

  @override
  String get campaignStars2Grudge => 'والتأهل';

  @override
  String get campaignStars3Grudge => 'والفوز عليهم مرتين';

  @override
  String get campaignFree => 'مجانية';

  @override
  String get campaignStart => 'ابدأ';

  @override
  String get campaignPartOfUnlimited => 'ضمن الإصدار غير المحدود';

  @override
  String get campaignResume => 'استئناف';

  @override
  String get campaignAbandon => 'التخلي';

  @override
  String get campaignAbandonConfirm =>
      'التخلي عن هذه المحاولة؟ يضيع تقدمها؛ ويبقى ختمك.';

  @override
  String get campaignMoveToSaves => 'نقل إلى ملفات الحفظ';

  @override
  String get campaignCannotContinue =>
      'عالم هذه الحملة بعيد جدًا عن العالم الحقيقي بحيث لا يمكن متابعته كمسيرة.';

  @override
  String get campaignMoveSlotsFull => 'خانات الحفظ ممتلئة. حرّر واحدة أولًا.';

  @override
  String get campaignStampConquered => 'منجزة';

  @override
  String get campaignStampFailed => 'فاشلة';

  @override
  String get campaignDifficultyHard => 'صعبة';

  @override
  String get campaignDifficultyMedium => 'متوسطة';

  @override
  String get campaignGoalLabel => 'الهدف';

  @override
  String get campaignStarsLabel => 'النجوم';

  @override
  String get campaignRunInProgress => 'لهذه الحملة محاولة جارية بالفعل.';

  @override
  String get campaignVerdictWon => 'منجزة';

  @override
  String get campaignVerdictLost => 'ليس هذه المرة';

  @override
  String get campaignVerdictContinue => 'متابعة';

  @override
  String campaignProgressQualifying(String position) {
    return 'التصفيات: $position';
  }

  @override
  String campaignProgressRival(String rival, String position) {
    return '⁦$rival: $position⁩';
  }

  @override
  String campaignProgressFinals(String stage) {
    return 'النهائيات: $stage';
  }

  @override
  String get campaignRunInNumbers => 'المحاولة بالأرقام';

  @override
  String campaignRunMeetings(int won, int played) {
    return 'المواجهات المكسوبة: $won من $played';
  }

  @override
  String campaignPlace(String which, int n) {
    String _temp0 = intl.Intl.selectLogic(
      which,
      {
        'first': 'الأول',
        'second': 'الثاني',
        'third': 'الثالث',
        'other': '$n',
      },
    );
    return '$_temp0';
  }

  @override
  String get campaignGuineasTitle => 'أفضل الغينيات';

  @override
  String get campaignGuineasTwist =>
      'غينيا الاستوائية، أصغر غينيات أفريقيا، لدورتين';

  @override
  String get campaignGuineasGoal => 'هزيمة غينيا وغينيا بيساو';

  @override
  String get campaignGuineasIntro =>
      'ثلاثة منتخبات أفريقية تحمل اسم غينيا، وغينيا الاستوائية أصغرها. لديك دورتان لهزيمة غينيا وغينيا بيساو مرة على الأقل لكل منهما، ثم انظر إلى أي مدى يمكنك المضي في بطولة أفريقيا. بابوا غينيا الجديدة، الغينيا الرابعة، محجوزة بالفعل لمباراة ودية.';

  @override
  String get campaignStars1Guineas => 'هزيمة غينيا وغينيا بيساو';

  @override
  String get campaignStars2Guineas => 'والتأهل إلى بطولة أفريقيا';

  @override
  String get campaignStars3Guineas => 'وبلوغ ربع نهائي بطولة أفريقيا';

  @override
  String get campaignYoungFinnsTitle => 'الفنلنديون الشباب';

  @override
  String get campaignYoungFinnsTwist =>
      'الجيل الذهبي الفنلندي من المراهقين، لثلاث دورات';

  @override
  String get campaignYoungFinnsGoal => 'التأهل إلى بطولة العالم';

  @override
  String get campaignYoungFinnsIntro =>
      'تنحى اللاعبون الكبار في فنلندا وحلّ مكانهم جيل ذهبي: كل لاعب يمكنك اختياره عمره 18 عامًا أو أقل. خام اليوم، لكنهم يملكون الموهبة ليصبحوا من أفضل الفرق في العالم، تمامًا كما فعل الجيل الشاب في النرويج. لديك ثلاث دورات لتأخذهم إلى بطولة العالم، ثم الفوز ببطولة أوروبا وبطولة العالم.';

  @override
  String get campaignStars1YoungFinns => 'التأهل إلى بطولة العالم';

  @override
  String get campaignStars2YoungFinns => 'الفوز ببطولة أوروبا';

  @override
  String get campaignStars3YoungFinns => 'الفوز ببطولة العالم';

  @override
  String get campaignGreenlandTitle => 'قرن غرينلاند';

  @override
  String get campaignGreenlandTwist =>
      'غرينلاند تحل محل سان مارينو في أوروبا، لمئة عام';

  @override
  String get campaignGreenlandGoal => 'التأهل إلى بطولة أوروبا';

  @override
  String get campaignGreenlandIntro =>
      'لم تخض غرينلاند قط مباراة دولية رسمية. في هذا العالم حلّت محل سان مارينو في أوروبا، وتبدأ من قاع التصنيف العالمي: لاعبون هواة، وملاعب صناعية، وموسم محشور بين الثلوج. لديك مئة عام، خمس وعشرون دورة، لبلوغ بطولة أوروبا، ثم بطولة العالم، وإن تجرأت على الحلم، الفوز بإحداهما.';

  @override
  String get campaignStars1Greenland => 'التأهل إلى بطولة أوروبا';

  @override
  String get campaignStars2Greenland => 'التأهل إلى بطولة العالم';

  @override
  String get campaignStars3Greenland => 'الفوز ببطولة أوروبا أو بطولة العالم';

  @override
  String get campaignZanzibarTitle => 'نهضة زنجبار';

  @override
  String get campaignZanzibarTwist =>
      'زنجبار تحل محل تشاد في أفريقيا، لمئة عام';

  @override
  String get campaignZanzibarGoal => 'التأهل إلى بطولة أفريقيا';

  @override
  String get campaignZanzibarIntro =>
      'لزنجبار اتحادها الكروي الخاص ومنتخبها الوطني، لكن لا مقعد لها في الكرة الأفريقية أو العالمية. في هذا العالم حلّت محل تشاد في أفريقيا، وتبدأ قرب قاع التصنيف العالمي: لاعبون من الجزيرة، وملاعب صغيرة، وحرارة الرياح الموسمية. لديك مئة عام، خمس وعشرون دورة، لبلوغ بطولة أفريقيا، ثم بطولة العالم، وإن تجرأت على الحلم، الفوز ببطولة العالم.';

  @override
  String get campaignStars1Zanzibar => 'التأهل إلى بطولة أفريقيا';

  @override
  String get campaignStars2Zanzibar => 'التأهل إلى بطولة العالم';

  @override
  String get campaignStars3Zanzibar => 'الفوز ببطولة العالم';

  @override
  String get campaignPro => 'كاملة';

  @override
  String campaignProgressCup(String cup, String year, String status) {
    return '$cup ⁦$year: $status⁩';
  }

  @override
  String get campaignCupNotQualified => 'لم يتأهل';

  @override
  String get campaignCupOpen => 'لم يُحسم بعد';

  @override
  String campaignWorldRenames(String nation) {
    return 'قاعدة البيانات هذه تعيد تسمية منتخب تقوم عليه هذه الحملة: $nation.';
  }

  @override
  String newsYouthTitle1(String name, String level) {
    return '$name يتألق مع فئة $level';
  }

  @override
  String newsYouthTitle2(String name, String level) {
    return 'تقرير الأكاديمية: $name يلفت الأنظار';
  }

  @override
  String newsYouthTitle3(String name, String level) {
    return 'نجم فئة ⁦$level: $name⁩';
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
      other: '$count مرة',
      many: '$count مرة',
      few: '$count مرات',
      two: 'مرتين',
      one: 'مرة واحدة',
      zero: '$count مرة',
    );
    return 'هزّ $name الشباك $_temp0 مع فئة $level أمام $opponent في النافذة الدولية الأخيرة.';
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
      other: '$count هدف',
      many: '$count هدفًا',
      few: '$count أهداف',
      two: 'هدفان',
      one: 'هدف',
      zero: '$count هدف',
    );
    return '$_temp0 لـ$name حين واجهت فئة $level $opponent في هذه النافذة.';
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
      other: 'بـ$count هدف',
      many: 'بـ$count هدفًا',
      few: 'بـ$count أهداف',
      two: 'بهدفين',
      one: 'بهدف',
      zero: 'بـ$count هدف',
    );
    return 'واجهت فئة $level $opponent، وخرج $name $_temp0 باسمه.';
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
      other: '$count هدف',
      many: '$count هدفًا',
      few: '$count أهداف',
      two: 'هدفين',
      one: 'هدفًا',
      zero: '$count هدف',
    );
    return 'صنع $name $_temp0 لفئة $level أمام $opponent وأدار المباراة من بدايتها إلى نهايتها.';
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
      other: '$count تمريرة حاسمة',
      many: '$count تمريرة حاسمة',
      few: '$count تمريرات حاسمة',
      two: 'تمريرتان حاسمتان',
      one: 'تمريرة حاسمة',
      zero: '$count تمريرة حاسمة',
    );
    return 'واجهت فئة $level $opponent في هذه النافذة، وكان $name يحرك الخيوط: $_temp0 وأداء لا يزال الطاقم يتحدث عنه.';
  }

  @override
  String newsYouthCleanSheet1(String name, String level, String opponent) {
    return 'كان $name مذهلًا حين حافظت فئة $level على نظافة شباكها أمام $opponent.';
  }

  @override
  String newsYouthCleanSheet2(String name, String level, String opponent) {
    return 'شباك نظيفة لفئة $level أمام $opponent، وكان $name السبب في معظمها.';
  }

  @override
  String newsYouthDisplay1(
    String name,
    String level,
    String opponent,
    int mark,
  ) {
    return 'أبهر $name مع فئة $level أمام $opponent، ومنح الطاقم أداءه $mark من عشرة.';
  }

  @override
  String newsYouthDisplay2(
    String name,
    String level,
    String opponent,
    int mark,
  ) {
    return 'لعبت فئة $level أمام $opponent في هذه النافذة، وأشاد المدربون بـ⁦$name: $mark⁩ من عشرة، أفضل علامة في الفريق.';
  }

  @override
  String get newsYouthDevReady1 =>
      'بهذا المستوى، هو جيد بما يكفي بالفعل ليُنظر في ضمه إلى الفريق الأول.';

  @override
  String get newsYouthDevReady2 =>
      'يعتقد الطاقم أنه جاهز لكرة الكبار الآن. القرار لك.';

  @override
  String get newsYouthDevClose1 =>
      'يتطور بشكل جيد وهو قريب من اقتحام الفريق الأول.';

  @override
  String get newsYouthDevClose2 =>
      'ليس بعيدًا عن الفريق الأول، وموسم جيد آخر قد يكفي.';

  @override
  String get newsYouthDevGrowing1 =>
      'يتطور بشكل جميل، وإن كان الفريق الأول لا يزال على بُعد خطوة أو اثنتين.';

  @override
  String get newsYouthDevGrowing2 =>
      'هناك عمل يجب إنجازه قبل أن يصبح دوليًا مع الكبار، لكن كل شيء يسير في الاتجاه الصحيح.';

  @override
  String get newsYouthDevRaw1 =>
      'لا يزال خامًا وأمامه سنوات قبل المنافسة مع الكبار، لكن الموهبة واضحة.';

  @override
  String get newsYouthDevRaw2 =>
      'ما زال الوقت مبكرًا، وطاقم الأكاديمية يطلب الصبر لا العناوين.';

  @override
  String get newsYouthStrengthGkPhysical =>
      'امتداد ذراعيه وسيطرته على المنطقة هما ما يميزانه.';

  @override
  String get newsYouthStrengthGkTechnical =>
      'إمساكه بالكرة وتوزيعه لها الأفضل الذي رأته الأكاديمية منذ سنوات.';

  @override
  String get newsYouthStrengthGkStamina =>
      'تركيزه لا ينخفض أبدًا، وهو حاد في الدقيقة التسعين كما في الأولى.';

  @override
  String get newsYouthStrengthDefPhysical =>
      'سرعته وقدرته في الكرات الهوائية مفتاح أسلوبه.';

  @override
  String get newsYouthStrengthDefTechnical =>
      'يقرأ اللعب بما يفوق سنه بكثير وهادئ بالكرة.';

  @override
  String get newsYouthStrengthDefStamina =>
      'لا يفقد تركيزه أبدًا، ولا يزال يركض عائدًا في الدقيقة الأخيرة.';

  @override
  String get newsYouthStrengthMidPhysical =>
      'يستعيد الكرة بقوة حقيقية ويندفع بها إلى الأمام.';

  @override
  String get newsYouthStrengthMidTechnical =>
      'رؤيته وتنوع تمريراته مفتاح أسلوبه.';

  @override
  String get newsYouthStrengthMidStamina =>
      'لياقته مذهلة: يغطي كل شبر من الملعب.';

  @override
  String get newsYouthStrengthFwdPhysical =>
      'سرعته خلف الدفاع وقوته في الهواء تجعلانه مصدر إزعاج لأي دفاع.';

  @override
  String get newsYouthStrengthFwdTechnical =>
      'إنهاؤه للهجمات وتحركه في المنطقة مفتاح أسلوبه.';

  @override
  String get newsYouthStrengthFwdStamina =>
      'يضغط من الأمام طوال المباراة ولا يمنح المدافعين لحظة راحة.';

  @override
  String pressMomentBigWinWarm3(String opponent) {
    return 'ستغني الجماهير عن تلك المباراة أمام $opponent لفترة. ماذا قلت للاعبين مع صافرة النهاية؟';
  }

  @override
  String pressMomentBigWinNeutral3(String opponent) {
    return 'كانت تلك رسالة واضحة أمام $opponent. كم منها جاء من ملعب التدريب؟';
  }

  @override
  String pressMomentBigWinHostile3(String opponent) {
    return 'الفضل للنتيجة أمام $opponent، لكننا رأينا ليالي كهذه من قبل. ما المختلف هذه المرة؟';
  }

  @override
  String pressMomentBigLossWarm3(String opponent) {
    return 'الجميع يمر بليلة سيئة، وتلك كانت واحدة أمام $opponent. ما مدى سرعتك في تجاوزها؟';
  }

  @override
  String pressMomentBigLossNeutral3(String opponent) {
    return 'كان $opponent أفضل في كل الخطوط. من أين تبدأ الإصلاح؟';
  }

  @override
  String pressMomentBigLossHostile3(String opponent) {
    return 'كانت الجماهير تغادر قبل النهاية أمام $opponent. هل تلومها؟';
  }

  @override
  String pressMomentCrisisWarm3(String opponent) {
    return 'كانت سلسلة صعبة، ولم يجعلها $opponent أسهل. ما الذي يدفعك للاستمرار؟';
  }

  @override
  String pressMomentCrisisNeutral3(String opponent) {
    return 'مباراة أخرى دون فوز، هذه المرة أمام $opponent. إلى متى يمكن أن يستمر هذا قبل أن يتحرك المجلس؟';
  }

  @override
  String pressMomentCrisisHostile3(String opponent) {
    return 'و$opponent أيضًا. هل بقي شيء في خطتك، أم حان الوقت لإفساح المجال لغيرك؟';
  }

  @override
  String get pressReplyCreditPlayers5 =>
      'أيًا كان ما تكتبونه، اكتبوه عن اللاعبين. لقد استحقوا ذلك.';

  @override
  String get pressReplyCreditPlayers6 =>
      'لديّ مجموعة مستعدة لاختراق الجدران من أجل بعضها. وهذا ليس بالقليل.';

  @override
  String get pressReplyTakeResponsibility5 =>
      'أنا من يتخذ القرارات، لذا فالانتقاد يأتيني أنا. هذه هي الوظيفة.';

  @override
  String get pressReplyTakeResponsibility6 =>
      'انظروا إلى المدرب أولًا. أخطأت في أشياء وسأصلحها.';

  @override
  String get pressReplyDemandMore5 =>
      'الجيد ليس كافيًا هنا. قلت لهم ذلك وجهًا لوجه.';

  @override
  String get pressReplyDemandMore6 =>
      'لا أحد في غرفة الملابس مضمون مكانه. يعرفون ذلك الآن.';

  @override
  String get pressReplyDeflect5 =>
      'يمكنكم طرح السؤال بثلاث طرق مختلفة. ستحصلون على الجواب نفسه.';

  @override
  String get pressReplyDeflect6 => 'سأحتفظ بأفكاري للاعبين. ستتفهمون.';

  @override
  String yWinRoutine12(String opponent, String score) {
    return '⁦$score⁩ أمام $opponent. كرة هادئة ومنضبطة وناضجة. نحب أن نرى ذلك.';
  }

  @override
  String yWinRoutine13(String opponent, String score) {
    return 'هزمنا $opponent ⁦$score⁩ دون أن نتعرق. هذا الفريق يتقن الملل، والملل يفوز بالألقاب.';
  }

  @override
  String yWinRoutine14(String opponent, String score) {
    return '$opponent ⁦$score⁩. ثلاث نقاط، بلا دراما، والعودة إلى العمل.';
  }

  @override
  String yWinRoutine15(String opponent, String score) {
    return '⁦$score⁩ روتينية أمام $opponent. لن يتذكرها أحد ولا حاجة لذلك.';
  }

  @override
  String yWinRoutine16(String opponent, String score) {
    return '⁦$score⁩ أمام $opponent وبطريقة ما خرجت قلقًا.';
  }

  @override
  String yWinRoutine17(String opponent, String score) {
    return 'هزمنا $opponent ⁦$score⁩. أمام فريق حقيقي، هذا الأداء يُعاقب.';
  }

  @override
  String yWinTight12(String opponent, String score) {
    return '⁦$score⁩ أمام $opponent. صمدنا، عانينا، فزنا. هذا هو الفريق.';
  }

  @override
  String yWinTight13(String opponent, String score) {
    return 'هزمنا $opponent ⁦$score⁩ بالأعصاب وحدها. سأقبل فريقًا يرفض الخسارة.';
  }

  @override
  String yWinTight14(String opponent, String score) {
    return '$opponent ⁦$score⁩. حتى اللحظة الأخيرة، لكن النقاط لنا.';
  }

  @override
  String yWinTight15(String opponent, String score) {
    return '⁦$score⁩ بفارق ضئيل على $opponent. لا فرق كبير، وهذه كرة القدم.';
  }

  @override
  String yWinTight16(String opponent, String score) {
    return '⁦$score⁩ أمام $opponent. ارتداد واحد محظوظ في الاتجاه الآخر وكنا سنخوض حديثًا مختلفًا تمامًا.';
  }

  @override
  String yWinTight17(String opponent, String score) {
    return 'تشبثنا أمام $opponent، ⁦$score⁩. لا ينبغي لأحد أن يسمي ذلك أداءً.';
  }

  @override
  String yDrew12(String opponent, String score) {
    return '⁦$score⁩ مع $opponent. ليست هزيمة، وفي بعض الأيام هذه هي المهمة.';
  }

  @override
  String yDrew13(String opponent, String score) {
    return 'نقطة انتُزعت بصعوبة أمام $opponent، ⁦$score⁩. أعجبتني روح القتال لدينا.';
  }

  @override
  String yDrew14(String opponent, String score) {
    return '$opponent ⁦$score⁩. تكافؤ تام، كما كان المعلقون القدامى يقولون.';
  }

  @override
  String yDrew15(String opponent, String score) {
    return '⁦$score⁩ مع $opponent. لم يفعل أي من الفريقين ما يكفي ليستحق أكثر.';
  }

  @override
  String yDrew16(String opponent, String score) {
    return '⁦$score⁩ مع $opponent. ذلك النوع من التعادل الذي يبدو كالهزيمة في حافلة العودة.';
  }

  @override
  String yDrew17(String opponent, String score) {
    return 'تعادلنا ⁦$score⁩ مع $opponent. نواصل الحديث عن التقدم ونواصل فعل هذا.';
  }

  @override
  String yLost12(String opponent, String score) {
    return '⁦$score⁩ أمام $opponent. مؤلم، لكنني رأيت ما يكفي لأؤمن بهذا الفريق.';
  }

  @override
  String yLost13(String opponent, String score) {
    return 'هُزمنا ⁦$score⁩ أمام $opponent، وكانوا جيدين. احترموا ذلك وحاولوا مجددًا.';
  }

  @override
  String yLost14(String opponent, String score) {
    return '$opponent ⁦$score⁩. هزيمة، وبعض الدروس، والمباراة التالية قريبة.';
  }

  @override
  String yLost15(String opponent, String score) {
    return 'خسرنا ⁦$score⁩ أمام $opponent. يصعب الجدال في ذلك.';
  }

  @override
  String yLost16(String opponent, String score) {
    return '⁦$score⁩ أمام $opponent. الأخطاء نفسها كالمرة الماضية، وبالثقة نفسها.';
  }

  @override
  String yLost17(String opponent, String score) {
    return 'هُزمنا ⁦$score⁩ أمام $opponent. إن لم يكن أحد مسؤولًا عن ذلك، فماذا نفعل؟';
  }

  @override
  String get yReactionShrug12 =>
      'لا بأس عندي. ليست كل ليلة بحاجة إلى ألعاب نارية.';

  @override
  String get yReactionShrug13 => 'النقاط نقاط. سأنام جيدًا الليلة.';

  @override
  String get yReactionShrug14 => 'شاهدتها. لا ملاحظات.';

  @override
  String get yReactionShrug15 => 'في مكان ما بين لا بأس ولا بأس.';

  @override
  String get yReactionShrug16 => 'دفعت ثمن البث من أجل هذا. لن أكررها (سأعود).';

  @override
  String get yReactionShrug17 => 'تسعون دقيقة من اللاشيء على شكل كرة قدم.';

  @override
  String get yReactionRelief12 => 'أتنفس مجددًا. فخور بهم لأنهم صمدوا.';

  @override
  String get yReactionRelief13 =>
      'هذه هي الانتصارات التي تبني فريقًا. القبح جميل.';

  @override
  String get yReactionRelief14 => 'ذهبت أظافري لكن النقاط لم تذهب.';

  @override
  String get yReactionRelief15 => 'لم تبدُ صافرة النهاية بهذا الجمال من قبل.';

  @override
  String get yReactionRelief16 =>
      'سعيد لأننا فزنا، وقلق من الطريقة التي فزنا بها.';

  @override
  String get yReactionRelief17 => 'نواصل الإفلات. يومًا ما لن نفلت.';

  @override
  String get yReactionFury12 => 'أحب هذا الفريق، ولهذا بالضبط يؤلمني ذلك.';

  @override
  String get yReactionFury13 =>
      'ليلة سيئة. يدينون لنا بواحدة في المرة القادمة، ويعرفون ذلك.';

  @override
  String get yReactionFury14 =>
      'أطفأتها بعد سبعين دقيقة. كان يجب أن تكون ستين.';

  @override
  String get yReactionFury15 => 'لا قتال، لا أفكار، لا أعذار.';

  @override
  String get yReactionFury16 => 'المشاكل نفسها كل مرة، ولا أحد يصلح شيئًا.';

  @override
  String get yReactionFury17 => 'على أحد في الاتحاد أن يعيد مشاهدة ذلك ويشرحه.';

  @override
  String get backupShareHint =>
      'يصنع ملف نسخ احتياطي واحدًا لكل ملفات الحفظ. اختر Google Drive أو iCloud Drive أو الملفات للاحتفاظ به.';

  @override
  String backupLastAt(String date) {
    return 'آخر نسخة احتياطية: $date';
  }

  @override
  String get backupNever => 'لا نسخة احتياطية بعد';

  @override
  String get backupRemindersTitle => 'تذكيرات النسخ الاحتياطي';

  @override
  String get backupRemindersBlurb =>
      'ملاحظة في بريدك حين تصبح آخر نسخة احتياطية قديمة.';

  @override
  String get backupAutoICloudTitle => 'نسخ احتياطي تلقائي إلى iCloud';

  @override
  String get backupAutoDriveTitle => 'نسخ احتياطي تلقائي إلى Google Drive';

  @override
  String get backupAutoBlurb =>
      'ينسخ احتياطيًا بعد المباريات، وفي نهاية الدورة، وحين تغادر التطبيق. يحتفظ بآخر نسختين.';

  @override
  String get backupStatusUploading => 'جارٍ النسخ الاحتياطي الآن.';

  @override
  String get backupStatusUploaded => 'تم النسخ الاحتياطي.';

  @override
  String get backupStatusICloudSignedOut =>
      'iCloud متوقف. سجّل الدخول إلى iCloud وفعّل iCloud Drive في تطبيق الإعدادات.';

  @override
  String get backupStatusDriveSignedOut =>
      'لم تسجّل الدخول. شغّل المفتاح لتسجيل الدخول عبر Google.';

  @override
  String get backupStatusNotConfigured =>
      'غير متاح في هذا الإصدار من التطبيق بعد.';

  @override
  String get backupStatusUnavailable =>
      'لا يمكن الوصول إلى السحابة الآن. ستتم المحاولة لاحقًا.';

  @override
  String get backupStatusFailed =>
      'لم ينجح آخر نسخ احتياطي تلقائي. ستتم المحاولة لاحقًا.';

  @override
  String backupDriveSignedInAs(String email) {
    return 'مسجّل الدخول باسم $email';
  }

  @override
  String get backupDriveSignOut => 'تسجيل الخروج';

  @override
  String get backupDriveSignInFailed =>
      'لم ينجح تسجيل الدخول عبر Google. حاول لاحقًا.';

  @override
  String get backupRestoreICloud => 'استعادة من ICLOUD';

  @override
  String get backupRestoreDrive => 'استعادة من GOOGLE DRIVE';

  @override
  String get backupCrossPlatformHelp =>
      'تنتقل بين iPhone وAndroid؟ انسخ احتياطيًا إلى ملف على أحد الهاتفين، ثم استعد من ذلك الملف على الآخر.';

  @override
  String get backupCloudListBlurb =>
      'نسخ احتياطية من أجهزتك على هذا الحساب. اضغط على واحدة لاستعادتها.';

  @override
  String get backupCloudListEmpty =>
      'لم يُعثر على نسخ احتياطية بعد. قد تستغرق النسخة الجديدة بضع دقائق للوصول إلى جهاز آخر.';

  @override
  String get backupCloudListFailed =>
      'تعذّرت قراءة النسخ الاحتياطية. تحقق من اتصالك وحاول مجددًا.';

  @override
  String get backupCloudThisDevice => 'هذا الجهاز';

  @override
  String backupCloudMore(int count) {
    return 'ملفات حفظ أخرى: $count';
  }

  @override
  String get backupCloudNewer =>
      'أُنشئت بإصدار أحدث من التطبيق. حدّث التطبيق أولًا.';

  @override
  String get backupCloudDownloading => 'جارٍ جلب النسخة الاحتياطية.';

  @override
  String get backupRestoreSafetyNote =>
      'تُحفظ نسخة من ملفات الحفظ على هذا الهاتف على الهاتف نفسه أولًا.';

  @override
  String get backupRejectedSafety =>
      'تعذّر الاحتفاظ بنسخة من ملفات الحفظ الحالية، لذا لم يُستبدل شيء.';

  @override
  String get newsBackupReminderTitle => 'حان وقت النسخ الاحتياطي';

  @override
  String get newsBackupReminderBody =>
      'ملفات حفظك موجودة على هذا الهاتف فقط. افتح الإعدادات واضغط «نسخ احتياطي إلى السحابة»، أو فعّل النسخ الاحتياطي التلقائي هناك. يمكن إيقاف هذه التذكيرات من الإعدادات أيضًا.';

  @override
  String get backupSafetyTitle => 'نسخ من قبل الاستعادة';

  @override
  String get backupSafetyBlurb =>
      'محفوظة على هذا الهاتف تحسبًا لاستعادة خاطئة. تُحفظ أحدث ثلاث.';

  @override
  String get backupSafetyRestore => 'استعادة';

  @override
  String get backupSafetyShare => 'مشاركة';

  @override
  String get saveUpgradeFailedTitle => 'تعذّر تحديث ملف حفظك';

  @override
  String get saveUpgradeFailedBody =>
      'تعذّر تحديث ملف حفظك. لم يُحذف شيء، ونسخة من قبل التحديث محفوظة على هذا الهاتف.';

  @override
  String get saveUpgradeRestoreButton => 'استعد النسخة من قبل التحديث';

  @override
  String get saveUpgradeRestoreFailed =>
      'تعذّرت استعادة النسخة. تُرك ملف حفظك كما كان.';

  @override
  String get saveOpenFailedTitle => 'تعذّر فتح ملفات حفظك';

  @override
  String get saveOpenFailedBody =>
      'تعذّر فتح ملفات حفظك. لم يُحذف شيء. حاول مجددًا بعد لحظة.';

  @override
  String get backupCloudNoDetails => 'التفاصيل لا تزال في الطريق.';

  @override
  String get tacticsLibraryTitle => 'مكتبة الخطط';

  @override
  String get tacticsLibraryBlurb =>
      'يمكن تحميل الخطط الموجودة في مكتبتك في أي حفظ، بما في ذلك الجديدة. تُحفظ الأدوار ومنفذو الكرات الثابتة حسب المركز، لا حسب اللاعب.';

  @override
  String get tacticsSaveToLibrary => 'احفظ في المكتبة';

  @override
  String get tacticsLoadFromLibrary => 'حمّل من المكتبة';

  @override
  String get tacticsLibraryEmpty =>
      'مكتبتك فارغة. احفظ خطة هنا ويمكنك تحميلها في أي حفظ.';

  @override
  String tacticsLibrarySaved(String name) {
    return 'تم حفظ «$name» في مكتبتك';
  }

  @override
  String tacticsLibraryLoaded(String name) {
    return 'تم تحميل «$name»';
  }

  @override
  String tacticsLibraryNotFitted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count دور أو منفذ كرات ثابتة لم تناسب هذه القائمة.',
      many: '$count دورًا أو منفذ كرات ثابتة لم تناسب هذه القائمة.',
      few: '$count أدوار أو منفذي كرات ثابتة لم تناسب هذه القائمة.',
      two: 'دوران أو منفذان للكرات الثابتة لم يناسبا هذه القائمة.',
      one: 'دور واحد أو منفذ كرات ثابتة لم يناسب هذه القائمة.',
      zero: 'كل الأدوار ومنفذي الكرات الثابتة تناسب هذه القائمة.',
    );
    return '$_temp0';
  }

  @override
  String get tacticsLibraryRename => 'إعادة التسمية';

  @override
  String get tacticsLibraryRenameTitle => 'إعادة تسمية الخطة';

  @override
  String get tacticsLibraryDelete => 'حذف';

  @override
  String tacticsLibraryDeleteTitle(String name) {
    return 'حذف «$name»؟';
  }

  @override
  String get tacticsLibraryDeleteBody => 'ستختفي من المكتبة في كل ملفات حفظك.';

  @override
  String get tacticsLibraryNameTaken => 'مكتبتك تضم بالفعل خطة بهذا الاسم.';

  @override
  String tacticsLibraryCouldNotLoad(String error) {
    return 'تعذّر تحميل المكتبة.\n$error';
  }

  @override
  String hostBidHeading(String competition, int year) {
    return 'ملف الاستضافة: $competition $year';
  }

  @override
  String get hostBidScreenTitle => 'ملف الاستضافة';

  @override
  String get hostBidBlurb =>
      'يُختار المستضيف بالقرعة بين المرشحين. الملف يمنح اسمك وزنًا أكبر: ملاعبك تمنحك فرصة أولية، والمال يزيدها، وكل مليون إضافي يُحتسب بقدر أقل قليلًا. يُنفق المال سواء فزت أم لا.';

  @override
  String hostBidPrize(String amount) {
    return 'افز، وتستضيف وتتأهل تلقائيًا وتتلقى منحة لمرة واحدة بقيمة $amount للميزانية القادمة.';
  }

  @override
  String get hostBidPartnerTitle => 'مستضيف مشارك';

  @override
  String get hostBidPartnerBlurb =>
      'قدّم ملفًا مشتركًا مع منتخب آخر من اتحادك القاري. تُحتسب ملاعب المنتخبين، والجار القوي يدعم ملفك، وإن فزتما يستضيف المنتخبان ويتأهلان تلقائيًا. المنحة مقسومة، لذا فحصتك أصغر.';

  @override
  String get hostBidPartnerNeeded =>
      'ملاعبك لا تكفي وحدها. اختر مستضيفًا مشاركًا لتقديم ملف مشترك.';

  @override
  String get hostBidPartnerAlone => 'تقدّم وحدك';

  @override
  String get hostBidPartnerAgrees => 'مستعد للاستضافة المشتركة';

  @override
  String get hostBidPartnerDeclinesOwnBid => 'يرفض: يفضّل التقدم بملفه الخاص.';

  @override
  String get hostBidPartnerDeclinesTooFar => 'يرفض: بعيد جدًا لملف مشترك.';

  @override
  String get hostBidPartnerDeclinesFunds =>
      'يرفض: لا يستطيع تمويل حصته هذه المرة.';

  @override
  String hostBidPrizeJoint(String nation, String amount) {
    return 'افز، وتستضيف مع $nation: يتأهل المنتخبان تلقائيًا، وتتلقى منحة لمرة واحدة بقيمة $amount، حصتك، للميزانية القادمة.';
  }

  @override
  String get hostBidChance => 'فرصة الاستضافة';

  @override
  String get hostBidBaseLabel => 'الملاعب والمكانة';

  @override
  String get hostBidInvestLabel => 'الاستثمار';

  @override
  String hostBidCeiling(String nation, String percent) {
    return 'الحد الأقصى لـ⁦$nation: $percent⁩';
  }

  @override
  String get hostBidInvestment => 'استثمارك';

  @override
  String hostBidFreeFunds(String amount) {
    return 'الأموال المتاحة: $amount';
  }

  @override
  String get hostBidSubmit => 'قدّم الملف';

  @override
  String get hostBidDecline => 'ليس هذه المرة';

  @override
  String get hostBidUnavailable => 'هذا الملف لم يعد مفتوحًا.';

  @override
  String hostBidWonTitle(String competition, int year) {
    return 'فاز الملف: $competition $year';
  }

  @override
  String hostBidWonBody(String amount) {
    return 'سنستضيف البطولة ونتأهل تلقائيًا كمستضيفين. منحة لمرة واحدة بقيمة $amount أصبحت الآن في أموال الاتحاد، ويمكنك توزيعها على أقسام هذه الدورة مباشرة من الرئيسية.';
  }

  @override
  String hostBidLostTitle(String competition, int year) {
    return 'خسر الملف: $competition $year';
  }

  @override
  String hostBidLostBody(String hosts) {
    return 'فاز $hosts بحق الاستضافة. لم يكن ملفنا كافيًا هذه المرة، والمال المنفق عليه ضاع، لكن الاتحاد عرض قضيته.';
  }

  @override
  String get hostBidGrantEvent => 'وزّع منحة الاستضافة';

  @override
  String hostBidGrantBanner(String amount) {
    return 'منحة الاستضافة: $amount لإضافتها إلى أقسام هذه الدورة الآن. ما حددته بالفعل يبقى؛ وأي فائض يبقى في الرصيد.';
  }

  @override
  String get stadiumsTitle => 'الملاعب الوطنية';

  @override
  String get stadiumsEntrySub => 'طوّر ملعبًا أو ابنِ ملعبًا جديدًا';

  @override
  String get stadiumsBlurb =>
      'مستوى الملعب هو حجمه: المستوى 1 أقل من 15,000 مقعد، المستوى 2 من 15,000، المستوى 3 من 25,000، المستوى 4 من 40,000، المستوى 5 من 60,000. كل ملعب يدرّ دخلًا صغيرًا في بداية كل دورة، أكثر مع مقاعد أكثر ما دامت جماهيرك قادرة على ملئها. التطوير يضيف مقاعد فورًا وقليلًا من السمعة من الدورة التالية؛ والتقليص يخفض تكاليف الصيانة لكنه لا يسترد شيئًا. ملاعبك تحدد البطولات التي يمكنك التقدم لاستضافتها.';

  @override
  String stadiumsIncome(String amount) {
    return 'دخل الملاعب: $amount لكل دورة';
  }

  @override
  String stadiumsReputation(int points) {
    return 'السمعة من الملاعب: ⁦+$points⁩';
  }

  @override
  String get stadiumsClosed =>
      'تُطلب الأعمال في بداية الدورة، قبل تحديد الميزانية.';

  @override
  String stadiumsCapacity(String seats) {
    return 'السعة: $seats';
  }

  @override
  String stadiumsLevel(int level, int max) {
    return 'المستوى ⁦$level/$max⁩';
  }

  @override
  String stadiumsUpgrade(String cost) {
    return 'تطوير: $cost';
  }

  @override
  String get stadiumsTopLevel => 'أعلى مستوى';

  @override
  String stadiumsOpens(int year) {
    return 'قيد الإنشاء، يُفتتح في $year';
  }

  @override
  String get stadiumsBuildTitle => 'ابنِ ملعبًا جديدًا';

  @override
  String get stadiumsOtherGrounds => 'ملاعب أخرى';

  @override
  String get stadiumsOtherGroundsBody =>
      'أُضيفت في قاعدة بياناتك. تستضيف بعض المباريات على أرضك؛ أما النهائيات وملفات الاستضافة ودخل الملاعب فتأتي من المجموعة الوطنية أعلاه.';

  @override
  String get stadiumsBuildBody =>
      'مكلف نوعًا ما: ملعب جديد في المدينة التي تختارها، يُفتتح من بداية الدورة التالية.';

  @override
  String get stadiumsBuildCity => 'المدينة';

  @override
  String stadiumsBuildButton(String cost) {
    return 'ابنِ: $cost';
  }

  @override
  String get stadiumsBuilding => 'هناك ملعب قيد الإنشاء بالفعل.';

  @override
  String get stadiumsNoCity => 'كل مدينة لديها ملعب جديد بالفعل.';

  @override
  String stadiumsConfirmUpgrade(String stadium, int level, String cost) {
    return 'تطوير $stadium إلى المستوى $level مقابل $cost؟';
  }

  @override
  String stadiumsConfirmBuild(String city, String cost) {
    return 'بناء ملعب جديد في $city مقابل $cost؟';
  }

  @override
  String get stadiumsConfirm => 'تأكيد';

  @override
  String get stadiumsCancel => 'إلغاء';

  @override
  String get stadiumsRefused => 'لم يتم الطلب. لم يُخصم شيء.';

  @override
  String get stadiumsNameLabel => 'اسم الملعب';

  @override
  String get stadiumsNameHint => 'اتركه فارغًا للاحتفاظ بالاسم المقترح.';

  @override
  String get stadiumsRename => 'إعادة تسمية الملعب';

  @override
  String get hostBidSectionTitle => 'ملفات الاستضافة';

  @override
  String get hostBidOpenSub => 'اختياري. قرّر قبل بداية الدورة الجديدة.';

  @override
  String get hostBidDecidedAtRollover =>
      'يُعلن المستضيف مع بداية الدورة الجديدة.';

  @override
  String get hostBidLodged =>
      'قُدّم الملف. يُعلن المستضيف مع بداية الدورة الجديدة.';

  @override
  String hostBidJointWith(String nation) {
    return 'ملف مشترك مع $nation.';
  }

  @override
  String get hostBidJointOnlyOpen =>
      'أصغر من أن يستضيف وحده، لكن الملف المشترك مع مستضيف مشارك متاح.';

  @override
  String get hostBidDeclinedNote => 'اخترت عدم التقدم هذه المرة.';

  @override
  String get hostBidOpensLater => 'مؤهل. يمكنك التقدم في نهاية هذه الدورة.';

  @override
  String get hostBidNoFunds => 'لا أموال متاحة كافية للتقدم.';

  @override
  String hostBidNeedStadiums(int count, String seats) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تحتاج إلى $count ملعب إضافي بسعة $seats+ مقعد.',
      many: 'تحتاج إلى $count ملعبًا إضافيًا بسعة $seats+ مقعد.',
      few: 'تحتاج إلى $count ملاعب إضافية بسعة $seats+ مقعد.',
      two: 'تحتاج إلى ملعبين إضافيين بسعة $seats+ مقعد.',
      one: 'تحتاج إلى ملعب إضافي واحد بسعة $seats+ مقعد.',
      zero: 'ملاعبك كافية.',
    );
    return '$_temp0';
  }

  @override
  String hostBidBarredConf(String confederation) {
    return 'استضاف $confederation آخر بطولة عالم.';
  }

  @override
  String get hostBidRecentHost => 'استضفت إحدى النسخ الثلاث الأخيرة.';

  @override
  String hostBidBarRequirement(
    int grounds,
    String otherSeats,
    String finalSeats,
    int semiGrounds,
    String semiSeats,
  ) {
    return 'يلزم $grounds ملاعب بسعة $otherSeats+ مقعد. النهائي: $finalSeats+ مقعد. نصف النهائي: $semiGrounds × $semiSeats+ مقعد.';
  }

  @override
  String hostBidBarRequirementNoSemis(
    int grounds,
    String otherSeats,
    String finalSeats,
  ) {
    return 'يلزم $grounds ملاعب بسعة $otherSeats+ مقعد. النهائي: $finalSeats+ مقعد.';
  }

  @override
  String hostBidNeedFinalGround(String seats) {
    return 'تحتاج إلى ملعب بسعة $seats+ مقعد للنهائي.';
  }

  @override
  String hostBidNeedSemiGrounds(int count, String seats) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تحتاج إلى $count ملعب إضافي بسعة $seats+ مقعد لنصف النهائي.',
      many: 'تحتاج إلى $count ملعبًا إضافيًا بسعة $seats+ مقعد لنصف النهائي.',
      few: 'تحتاج إلى $count ملاعب إضافية بسعة $seats+ مقعد لنصف النهائي.',
      two: 'تحتاج إلى ملعبين إضافيين بسعة $seats+ مقعد لنصف النهائي.',
      one: 'تحتاج إلى ملعب إضافي واحد بسعة $seats+ مقعد لنصف النهائي.',
      zero: 'ملاعب نصف النهائي كافية.',
    );
    return '$_temp0';
  }

  @override
  String get hostBidBelowBar => 'ملاعبك لا تستوفي متطلبات هذه البطولة.';

  @override
  String get hostBidRulesPending =>
      'ستتضح إمكانية تقدمك بعد إعلان مستضيفي هذه الدورة.';

  @override
  String get hostBidBackToBack =>
      'تستضيف البطولة التي تسبق هذه مباشرة. لا يستضيف أي منتخب بطولتين متتاليتين.';

  @override
  String get hostBidOneOnly =>
      'تقدّمت للبطولة الأخرى. لا يستضيف أي منتخب بطولتين متتاليتين، لذا يمكنك التقدم لواحدة فقط.';

  @override
  String hostBidRequirement(
    int grounds,
    String minSeats,
    int bigGrounds,
    String bigSeats,
  ) {
    return 'يلزم $grounds ملاعب بسعة $minSeats+ مقعد، منها $bigGrounds بسعة $bigSeats+.';
  }

  @override
  String hostBidWonBodyBudget(String amount) {
    return 'سنستضيف البطولة ونتأهل تلقائيًا كمستضيفين. منحة لمرة واحدة بقيمة $amount موجودة بالفعل في أموال الاتحاد، جاهزة لميزانية هذه الدورة.';
  }

  @override
  String hostBidWonJointBody(String hosts, String amount) {
    return 'سيستضيف $hosts البطولة معًا، ونتأهل تلقائيًا كمستضيفين. حصتنا من منحة الاستضافة، $amount، أصبحت الآن في أموال الاتحاد، ويمكنك توزيعها على أقسام هذه الدورة مباشرة من الرئيسية.';
  }

  @override
  String hostBidWonJointBodyBudget(String hosts, String amount) {
    return 'سيستضيف $hosts البطولة معًا، ونتأهل تلقائيًا كمستضيفين. حصتنا من منحة الاستضافة، $amount، موجودة بالفعل في أموال الاتحاد، جاهزة لميزانية هذه الدورة.';
  }

  @override
  String get hubStadiumIncome => 'دخل الملاعب';

  @override
  String get stadiumsDownsize => 'تقليص';

  @override
  String stadiumsConfirmDownsize(String stadium, String seats, int level) {
    return 'تقليص $stadium إلى $seats مقعد (المستوى $level)؟ لا يُسترد شيء، لكن تكاليف الصيانة تنخفض.';
  }

  @override
  String get stadiumsResizedThisCycle => 'أُعيد بناؤه هذه الدورة';

  @override
  String stadiumsGroundIncome(String amount) {
    return 'يدرّ $amount لكل دورة';
  }

  @override
  String hostBidLapsedTitle(String competition, int year) {
    return 'سُحب الملف: $competition $year';
  }

  @override
  String hostBidLapsedBodyNation(String nation) {
    return 'قُدّم الملف باسم $nation، وأنت تبدأ الدورة الجديدة في مكان آخر. سُحب ولم يُخصم شيء.';
  }

  @override
  String get hostBidLapsedBodyFunds =>
      'حين أُغلقت الدورة، لم تعد أموال الاتحاد تغطي المبلغ. سُحب الملف ولم يُخصم شيء.';

  @override
  String get stadiumsViewMap => 'الخريطة';

  @override
  String get stadiumsViewList => 'القائمة';

  @override
  String get stadiumsMapPickCity => 'اضغط على مدينة لبناء ملعب جديد فيها.';

  @override
  String get stadiumsMapFit => 'عرض البلاد كاملة';

  @override
  String get campaignLegacyTitle => 'أكمل الإرث';

  @override
  String get campaignLegacyTwist => 'إسبانيا، بطلة أوروبا الحالية، لدورة واحدة';

  @override
  String get campaignLegacyGoal => 'الدفاع عن اللقب الأوروبي';

  @override
  String get campaignLegacyIntro =>
      'إسبانيا بطلة أوروبا الحالية، والمشككون يصفون المسيرة الذهبية بأنها استثناء. لديك دورة واحدة لتثبت العكس: دافع عن التاج القاري، ثم انطلق نحو العالم. أضف كأس الأمم ويكتمل الإرث.';

  @override
  String get campaignStars1Legacy => 'الفوز ببطولة أوروبا';

  @override
  String get campaignStars2Legacy => 'وبطولة العالم';

  @override
  String get campaignStars3Legacy => 'وكأس الأمم';

  @override
  String get campaignHomeSoilTitle => 'على أرضنا';

  @override
  String get campaignHomeSoilTwist =>
      'السويد تستضيف بطولة العالم مع الدنمارك والنرويج، لدورة واحدة';

  @override
  String get campaignHomeSoilGoal => 'تجاوز دور المجموعات على أرضك';

  @override
  String get campaignHomeSoilIntro =>
      'بطولة العالم تأتي إلى الشمال. السويد تقود الملف، والدنمارك والنرويج إلى جانبها، والبلاد كلها تنتظر صيفًا لا يُنسى. القائمة مجتهدة لكنها ليست أفضل من المتوسط، وكل مستضيف يتذكر من خرج من دور المجموعات أمام جماهيره. لا تكن ذلك المستضيف: تجاوز المجموعة، ثم ابلغ ربع النهائي، وإن آمن الشمال حقًا، نصف النهائي.';

  @override
  String get campaignStars1HomeSoil => 'تجاوز دور المجموعات';

  @override
  String get campaignStars2HomeSoil => 'بلوغ ربع النهائي';

  @override
  String get campaignStars3HomeSoil => 'بلوغ نصف النهائي';

  @override
  String get campaignSectionOneCycle => 'دورة واحدة';

  @override
  String get campaignSectionShort => 'بضع دورات';

  @override
  String get campaignSectionLong => 'المشوار الطويل';

  @override
  String get campaignFilterAll => 'الكل';

  @override
  String get campaignFilterNew => 'لم تُلعب';

  @override
  String get campaignFilterInProgress => 'جارية';

  @override
  String get campaignFilterDone => 'مكتملة';

  @override
  String get campaignFilterEmpty => 'لا حملات هنا بعد.';

  @override
  String campaignStarsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count نجمة',
      many: '$count نجمة',
      few: '$count نجوم',
      two: 'نجمتان',
      one: 'نجمة واحدة',
      zero: 'لا نجوم',
    );
    return '$_temp0';
  }

  @override
  String campaignCycles(int cycles) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles دورة',
      many: '$cycles دورة',
      few: '$cycles دورات',
      two: 'دورتان',
      one: 'دورة واحدة',
      zero: '$cycles دورة',
    );
    return '$_temp0';
  }

  @override
  String get msgIntlRetireNoteHigh => ' يرحل في القمة، بطلًا.';

  @override
  String get msgIntlRetireNoteMissed =>
      ' الغياب عن النهائيات كان القشة الأخيرة.';

  @override
  String get msgIntlRetireNoteSurprise => ' لم يتوقع أحد ذلك.';

  @override
  String get msgIntlRetireNoteRecord => ' يرحل حاملًا للرقم القياسي الوطني.';

  @override
  String msgIntlRetireNewsTitle(String nation, String name) {
    return '⁦$nation: $name⁩ يعتزل اللعب الدولي';
  }

  @override
  String msgIntlRetireNewsBody(String name, String nation, int age) {
    return 'أعلن $name ($nation) اعتزاله اللعب الدولي في سن $age.';
  }

  @override
  String msgIntlComebackTitle(String name) {
    return '$name يعود عن اعتزاله الدولي';
  }

  @override
  String msgIntlComebackBody(String name, int age) {
    return 'جعل $name نفسه متاحًا للاختيار مجددًا، في سن $age.';
  }

  @override
  String get msgIntlComebackNoteCrisis =>
      ' مع إصابات تضرب الفريق، لبّى النداء.';

  @override
  String get msgIntlComebackNoteManager => ' المدرب الجديد أقنعه.';

  @override
  String msgIntlComebackNewsTitle(String nation, String name) {
    return '⁦$nation: $name⁩ يعود عن اعتزاله الدولي';
  }

  @override
  String msgIntlComebackNewsBody(String name, String nation, int age) {
    return '$name ($nation) متاح للاختيار مجددًا، في سن $age.';
  }

  @override
  String msgPoachTitle(String rival, String name) {
    return '$rival يحاول استقطاب $name';
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
    return 'تواصل $rival مع $name ($age، $position) بشأن تغيير جنسيته الرياضية. لم يخض بعد أي مباراة رسمية مع $nation، لذا لا يزال حرًا في التغيير. امنحه دقائق في إحدى مبارياتنا الرسمية الـ$count القادمة وسيرتبط بنا نهائيًا. وإلا، فقد يقبل عرضهم.';
  }

  @override
  String msgPoachTiedTitle(String name, String rival) {
    return '$rival يخسر $name';
  }

  @override
  String msgPoachTiedBody(String name, String rival, String nation) {
    return 'خاض $name مباراة رسمية مع $nation، لذا لم يعد بإمكان $rival اختياره. إنه مرتبط بنا نهائيًا.';
  }

  @override
  String msgPoachStayedTitle(String name, String rival) {
    return '$name يرفض $rival';
  }

  @override
  String msgPoachStayedBody(String name, String rival, String nation) {
    return 'لم يخض $name بعد أي مباراة رسمية مع $nation، لكنه أخبر $rival أنه يريد انتظار فرصته معنا.';
  }

  @override
  String msgPoachSwitchedTitle(String name, String rival) {
    return '$name ينتقل إلى $rival';
  }

  @override
  String msgPoachSwitchedBody(String name, String rival, String nation) {
    return 'قبل $name عرض $rival وسيلعب لهم من الآن فصاعدًا. دون مباراة رسمية مع $nation، لم يكن هناك ما يبقيه.';
  }

  @override
  String msgPoachSwitchedBodyPromise(String name, String rival, String nation) {
    return 'قبل $name عرض $rival. وُعد بدقائق مع $nation لم تأتِ أبدًا، وسيلعب لـ$rival من الآن فصاعدًا.';
  }

  @override
  String get poachPromiseButton => 'عِده بدقائق لعب';

  @override
  String get poachPromisedLabel => 'دقائق موعودة';

  @override
  String get poachCallUpsButton => 'افتح الاستدعاءات';

  @override
  String get poachPromiseHint =>
      'الوعد يجعله ينتظر مباراة رسمية أخرى، لكنه أكثر ميلًا للرحيل إن لم يُوفَ به.';

  @override
  String playerIntlRetired(int year) {
    return 'اعتزل اللعب الدولي، $year';
  }

  @override
  String playerIntlComeback(int year) {
    return 'عاد من الاعتزال الدولي، $year';
  }

  @override
  String yLegendRetires0(String name) {
    return 'شكرًا، $name. بعضهم يرتدي القميص، وهو حمله.';
  }

  @override
  String yLegendRetires1(String name) {
    return '$name يُنهي مسيرته الدولية. نهاية حقبة.';
  }

  @override
  String yLegendRetires2(String name) {
    return '$name يعتزل. متأخرًا ببطولة واحدة، إن كنا صادقين.';
  }

  @override
  String yLegendRetires3(String name) {
    return 'إذن انتهى $name. حان وقت منح الشباب فرصة.';
  }

  @override
  String matchAltitudeOpponentsTire(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'الارتفاع $altitudeString م: سيتعب المنافس أسرع';
  }

  @override
  String matchAltitudeYouTire(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'الارتفاع $altitudeString م: سيتعب لاعبوك أسرع';
  }

  @override
  String matchAltitudeBothTire(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'الارتفاع $altitudeString م: سيتعب الفريقان أسرع';
  }

  @override
  String matchAltitudeUsedTo(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'الارتفاع $altitudeString م: الفريقان معتادان عليه';
  }

  @override
  String matchHeatExpected(int temp) {
    final intl.NumberFormat tempNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String tempString = tempNumberFormat.format(temp);

    return 'الحرارة: $tempString°م متوقعة، ستتعب الأرجل أبكر';
  }

  @override
  String get matchConditionsAdvice =>
      'خطط لتبديلاتك مبكرًا: الأرجل الجديدة أهم هنا';

  @override
  String get fanMoodFurious => 'غاضبة';

  @override
  String get fanMoodRestless => 'متململة';

  @override
  String get fanMoodCalm => 'هادئة';

  @override
  String get fanMoodUpbeat => 'متفائلة';

  @override
  String get fanMoodEuphoric => 'في نشوة';

  @override
  String matchHomeFans(String mood) {
    return 'جماهير الأرض: $mood';
  }

  @override
  String federationFans(String mood) {
    return 'الجماهير: $mood';
  }

  @override
  String federationFansIncome(String change) {
    return 'دخل الملاعب في الدورة القادمة: ⁦$change⁩';
  }

  @override
  String yFansProtest0(String nation, String manager) {
    return 'عشرون عامًا أتابع هذا الفريق على أرضه وخارجها. لن أجدد اشتراكي الموسمي حتى يتغير شيء.';
  }

  @override
  String yFansProtest1(String nation, String manager) {
    return 'سنواصل الغناء من أجل القميص. لكن اللافتة في المدرج الشمالي الليلة قالت ما نفكر فيه جميعًا.';
  }

  @override
  String yFansProtest2(String nation, String manager) {
    return 'نصف الملعب فارغ، والنصف الذي حضر قضى الشوط الثاني يهتف #ارحل_$manager.';
  }

  @override
  String yFansProtest3(String nation, String manager) {
    return 'روابط المشجعين تتحدث عن مقاطعة المباراة القادمة على أرضنا. يصعب لومهم.';
  }

  @override
  String yFansProtest4(String nation, String manager) {
    return '#ارحل_$manager. لم أعد غاضبًا. فقط انتهيت.';
  }

  @override
  String yFansProtest5(String nation, String manager) {
    return 'صورة من الليلة: صفوف من المقاعد الفارغة وملاءة واحدة مكتوب عليها #ارحل_$manager. هذا هو تقرير المباراة.';
  }

  @override
  String yFansSellOut0(String nation) {
    return 'نفدت التذاكر مجددًا. أفضل فريق عرفته هذه البلاد منذ سنوات، والجميع يعرف ذلك.';
  }

  @override
  String yFansSellOut1(String nation) {
    return 'نفدت تذاكر المباراة القادمة على أرضنا في إحدى عشرة دقيقة. هذا الفريق أعاد لنا عطلات نهاية الأسبوع.';
  }

  @override
  String yFansSellOut2(String nation) {
    return 'كل المقاعد محجوزة للمباراة القادمة على أرضنا. الاتحاد سيعدّ إيرادات البوابات مبتسمًا.';
  }

  @override
  String yFansSellOut3(String nation) {
    return 'نفاد آخر للتذاكر. قولوا ما شئتم عن التكتيك، الناس يريدون أن يكونوا في ذلك الملعب.';
  }

  @override
  String yFansSellOut4(String nation) {
    return 'نفدت التذاكر، حسنًا. الأشخاص أنفسهم كانوا يصفّرون على هذا الفريق قبل ثمانية عشر شهرًا.';
  }

  @override
  String yFansSellOut5(String nation) {
    return 'نفاد مفاجئ للتذاكر، وخبراء مفاجئون. أين كان الجميع حين لم نكن نهزم أحدًا؟';
  }

  @override
  String get campaignsIntro =>
      'الحملات تحديات مصممة يدويًا: منتخب محدد، وعالم بتحوّل خاص، وهدف يجب بلوغه في عدد محدد من الدورات. كل محاولة منفصلة عن ملفات حفظ مسيرتك، وكلما تقدمت أكثر، كسبت نجومًا أكثر، حتى ثلاث.';

  @override
  String hubEventScandal(String player) {
    return 'فضيحة في المعسكر: $player';
  }

  @override
  String get hubEventScandalSub => 'أعده إلى الديار، أم أبقِه؟';

  @override
  String get scandalTitle => 'فضيحة في المعسكر';

  @override
  String scandalStoryParty(String player) {
    return 'كان $player في حفلة استمرت حتى الفجر، والصور ملأت كل الصحف صباح تجمّع الفريق.';
  }

  @override
  String scandalStoryCurfew(String player) {
    return 'خالف $player حظر التجول الخاص بالفريق وضُبط عائدًا إلى الفندق في ساعات الفجر الأولى.';
  }

  @override
  String scandalStoryNightclub(String player) {
    return 'صُوّر $player في ملهى ليلي عشية المعسكر، والصور في كل مكان.';
  }

  @override
  String scandalStoryCasino(String player) {
    return 'قضى $player الليلة السابقة للمعسكر على طاولة كازينو، ولدى صحيفة شعبية الصور.';
  }

  @override
  String get scandalSendHome => 'أعده إلى الديار';

  @override
  String scandalSendHomeCover(String player) {
    return 'أعده إلى الديار، واستدعِ $player';
  }

  @override
  String scandalKeep(String player) {
    return 'أبقِ $player';
  }

  @override
  String get scandalKeepNote =>
      'أبقِه: معنويات الفريق نحو -4 والمجلس نحو -3 لبقية الدورة.';

  @override
  String get scandalSendHomeNote =>
      'أعده إلى الديار: لا تكلفة على المعنويات أو المجلس، ويمكنك استدعاء بديل.';

  @override
  String get scandalFinalsNote =>
      'أعده إلى الديار: لا تكلفة على المعنويات أو المجلس، لكن في النهائيات لا يمكن لأحد أن يحل مكانه.';

  @override
  String get scandalPickCover => 'استدعِ بديلًا (اختياري)';

  @override
  String newsScandalTitle(String player) {
    return 'فضيحة في المعسكر: $player';
  }

  @override
  String yScandalParty0(String player, String tag) {
    return 'الشباب شباب. $player في حفلة قبل المعسكر بليلة، وما زلت أريده في الملعب. #$tag';
  }

  @override
  String yScandalParty1(String player, String tag) {
    return '$player مُصوَّر في حفلة امتدت طوال الليل قبل ساعات من تجمع الفريق. أُبلغ الاتحاد. #$tag';
  }

  @override
  String yScandalParty2(String player, String tag) {
    return 'حفلة طوال الليل قبل المعسكر. $player، بماذا كنت تفكر؟ لا يُصدَّق. #$tag';
  }

  @override
  String yScandalCurfew0(String player, String tag) {
    return 'عاد بعد حظر التجول، حسنًا، هذا يحدث. على $player فقط أن يصلح ذلك في الملعب. #$tag';
  }

  @override
  String yScandalCurfew1(String player, String tag) {
    return '$player ضُبط عائدًا إلى فندق الفريق بعد حظر التجول، قبل ساعات من التدريب. #$tag';
  }

  @override
  String yScandalCurfew2(String player, String tag) {
    return 'حظر التجول ليس معقدًا. $player لم يستطع الالتزام ليلة واحدة. #$tag';
  }

  @override
  String yScandalNightclub0(String player, String tag) {
    return 'إذن كان $player في ملهى ليلي. للاعبي الكرة حياة أيضًا. دعوه يلعب. #$tag';
  }

  @override
  String yScandalNightclub1(String player, String tag) {
    return 'صور تُظهر $player في ملهى ليلي عشية المعسكر الدولي. #$tag';
  }

  @override
  String yScandalNightclub2(String player, String tag) {
    return 'صور الملهى الليلي عشية المعسكر. $player أحرج القميص. #$tag';
  }

  @override
  String yScandalCasino0(String player, String tag) {
    return 'ليلة في الكازينو ليست جريمة. $player سيكون بخير. #$tag';
  }

  @override
  String yScandalCasino1(String player, String tag) {
    return 'رُصد $player على طاولة كازينو في الليلة السابقة لتجمع الفريق. #$tag';
  }

  @override
  String yScandalCasino2(String player, String tag) {
    return 'كازينو طوال الليل قبل المعسكر. $player قامر بأكثر من المال. #$tag';
  }

  @override
  String yScandalSentHome0(String player) {
    return 'قرار صائب. لا أحد أكبر من الفريق، بما في ذلك $player.';
  }

  @override
  String yScandalSentHome1(String player) {
    return 'إعادة $player إلى الديار كانت الجواب الوحيد. كل الاحترام للمدرب.';
  }

  @override
  String yScandalSentHome2(String player) {
    return 'الانضباط انضباط. كان $player يعرف القواعد.';
  }

  @override
  String yScandalSentHome3(String player) {
    return 'رسالة واضحة للفريق: $player على متن الطائرة عائدًا.';
  }

  @override
  String yScandalSentHome4(String player) {
    return 'قاسٍ على $player. ليلة خروج واحدة وانتهت نافذته؟';
  }

  @override
  String yScandalSentHome5(String player) {
    return 'إعادة $player إلى الديار تضعفنا. سندفع الثمن في الملعب.';
  }

  @override
  String yScandalKept0(String player) {
    return 'إبقاء $player مقامرة. من الأفضل أن يرد الجميل في الملعب.';
  }

  @override
  String yScandalKept1(String player) {
    return 'حسنًا، $player يبقى. إذن فهو يدين للجميع بأداء.';
  }

  @override
  String yScandalKept2(String player) {
    return 'إذن القواعد لا تنطبق على $player. من الجيد معرفة ذلك.';
  }

  @override
  String yScandalKept3(String player) {
    return 'حظر التجول اختياري الآن على ما يبدو. اسألوا $player.';
  }

  @override
  String yScandalKept4(String player) {
    return 'إبقاء $player بعد ذلك؟ هذا الفريق مخيم عطلات.';
  }

  @override
  String yScandalKept5(String player) {
    return 'حفلة طوال الليل، ثم مباشرة إلى التشكيلة الأساسية. رسالة رائعة يا مدرب. لا بد أن $player مسرور.';
  }

  @override
  String get yStreamerBreaks0 =>
      'انكشف أمره 😭😭 الليلة اللي قبل المعسكر؟؟ أنا أبكي 💀💀💀';

  @override
  String get yStreamerBreaks1 =>
      'لاااا يا جماعة شوفوا هذا 🤯🤯 فعلها فعلًا قبل المعسكر 😭🔥';

  @override
  String get yStreamerBreaks2 =>
      'مين خلّاه يطلع؟؟ مين خلّاه يطلع 😭😭💀 هذا فيلم 🔥🔥';

  @override
  String get yStreamerSentHome0 =>
      'رجّعوه البيت؟؟ رجّعوه البيت!!! 😭😭😭 المدرب ما يمزح 💀🔥';

  @override
  String get yStreamerSentHome1 =>
      'جمع شنطه على الهواء مباشرة 🤯🤯 مع السلامة 😭👋';

  @override
  String get yStreamerSentHome2 =>
      'مستحيييل رجّعوه البيت 💀💀 يا جماعة أنا أرتجف 🔥🔥🔥';

  @override
  String get yStreamerKept0 =>
      'باقي؟؟؟ باقيييي 🤯🤯 هذا ما أحد يقدر يلمسه 😭🔥';

  @override
  String get yStreamerKept1 =>
      'حفلة طول الليل وما زال في القائمة 💀💀 أبي هذا العقد 😭😭';

  @override
  String get yStreamerKept2 => 'المدرب قال عادي 😭😭 شنو يا جماعة 🤯🤯🤯';

  @override
  String get yCameoUjfaloci => 'لم أدفع شيئًا، وهذا المبلغ لا يستقيم أيضًا';

  @override
  String get yCameoHavir0 => 'السمكات الصغيرة سبحت بعيدًا.';

  @override
  String get yCameoHavir1 => 'ألقينا الشباك، وكان السمك في مكان آخر.';

  @override
  String get yCameoHavir2 => 'قلتها في سبتمبر، على طبق من الغولاش.';

  @override
  String get yCameoHavir3 => 'من لم يصطد في الوقت المناسب فلا يبكِ الآن.';

  @override
  String get yCameoHavir4 => 'لعبنا مثل سمكة سلور على اليابسة.';

  @override
  String get yCameoHavir5 => 'تهب الريح، ويتجمد البركة. هكذا تسير الأمور.';

  @override
  String get yCameoHavir6 => 'في بعض الأيام لا تصطاد إلا حذاءً قديمًا.';

  @override
  String get yCameoHavir7 =>
      'في أيامي كنا على الأقل نذهب لشرب شيء. ولا حتى ذلك الآن.';

  @override
  String get yCameoLzimberskyHome0 =>
      'إعادة شاب إلى الديار بسبب ليلة واحدة؟ هذه هي الفضيحة، لا الحفلة!';

  @override
  String get yCameoLzimberskyHome1 =>
      'يحق للشباب أن يستمتعوا قليلًا! الإعلام المنافق ينتصر مجددًا.';

  @override
  String get yCameoLzimberskyHome2 =>
      'هذه مطاردة ساحرات. شاب يخرج ليلة واحدة فتشنقونه.';

  @override
  String get yCameoLzimberskyHome3 =>
      'فليرمِ الحجر الأول الصحفي الذي لم يذهب قط إلى حفلة. عار!';

  @override
  String get yCameoLzimberskyHome4 =>
      'المدرب خاف من الصحف الشعبية. كنت سأدافع عن الشاب حتى آخر نفس!';

  @override
  String get yCameoLzimberskyKept0 =>
      'أخيرًا مدرب له عمود فقري! أبقى الشاب وليبكِ الإعلام.';

  @override
  String get yCameoLzimberskyKept1 =>
      'يحق للشباب أن يستمتعوا قليلًا، أليس كذلك؟ برافو يا مدرب!';

  @override
  String get yCameoLzimberskyKept2 =>
      'الإعلام المنافق يصرخ، والمدرب يصمد. هكذا تُدار الأمور!';

  @override
  String get yCameoLzimberskyKept3 =>
      'ليلة خروج واحدة والصحافة تريد رجمه. المدرب رجل حقيقي!';

  @override
  String get yCameoLzimberskyKept4 =>
      'أقول: دعوا الشباب يعيشون! اعملوا بجد، والعبوا بجد. إبهام للأعلى.';

  @override
  String get yCameoMarena => 'حتى أنا أستطيع تدريب هؤلاء.';

  @override
  String get yCameoKralik => 'ماذا توقعتم ههههه، اشتروا ZeroZero خاصتنا';

  @override
  String get yCameoPosuk0 => 'مثير للشفقة';

  @override
  String get yCameoPosuk1 => 'يا رجـــل';

  @override
  String get yCameoPosuk2 => 'أحد يريد يروح المقهى؟';

  @override
  String get yTraitStreamer => 'يبث كل شيء، بأعلى صوت، وبحماس مفرط.';

  @override
  String hubEventAwardsCeremony(int year) {
    return 'أفضل لاعب في العام $year';
  }

  @override
  String get hubEventAwardsCeremonySub => 'الأصوات حُسمت';

  @override
  String get potyCeremonyWatch => 'شاهد الحفل';

  @override
  String get potyCeremonySkipToList => 'انتقل إلى أفضل خمسة';

  @override
  String get potyCeremonySkip => 'تخطٍّ';

  @override
  String get potyCeremonyIntro =>
      'الأصوات حُسمت. هؤلاء أفضل خمسة لاعبين في العالم هذا العام.';

  @override
  String potyCeremonyPlace(int place) {
    return 'المركز $place';
  }

  @override
  String get potyCeremonyWinnerIs => 'وأفضل لاعب في العام هو...';

  @override
  String get potyTop5Heading => 'أفضل خمسة في العالم';

  @override
  String get potyYoungTop3Heading => 'أفضل لاعب شاب في العام: أفضل ثلاثة';

  @override
  String get potySeeTop5 => 'عرض أفضل خمسة';

  @override
  String get potyYourPlayer => 'لاعبك';

  @override
  String potyTallyCleanSheets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مباراة بشباك نظيفة',
      many: '$count مباراة بشباك نظيفة',
      few: '$count مباريات بشباك نظيفة',
      two: 'مباراتان بشباك نظيفة',
      one: 'شباك نظيفة واحدة',
      zero: '$count شباك نظيفة',
    );
    return '$_temp0';
  }

  @override
  String get campaignFullBrief => 'المهمة كاملة';

  @override
  String campaignStarsSoFar(int earned, int total) {
    return 'النجوم المكتسبة حتى الآن: $earned من $total';
  }

  @override
  String get campaignStarEarned => 'مكتسبة حتى الآن';

  @override
  String get campaignStarNotYet => 'لم تُكتسب بعد';

  @override
  String get stadiumsEntrySubClosed =>
      'شاهد ملاعبك. تُفتح الأعمال مجددًا في بداية الدورة التالية.';

  @override
  String get boardObjectiveNoBrief => 'لا هدف محدد';

  @override
  String get boardObjectiveNoBriefBody =>
      'المجلس لا يتوقع منك بلوغ هذه النهائيات. سيحكم عليك بنتائجك بدلًا من ذلك.';

  @override
  String get boardObjectiveAwaitingDraw => 'الهدف بعد القرعة';

  @override
  String get boardObjectiveAwaitingDrawBody =>
      'يحدد المجلس هذا الهدف بعد سحب المجموعات.';

  @override
  String get boardObjectiveLaterEdition => 'الهدف في الكأس الثانية';

  @override
  String get boardObjectiveLaterEditionBody =>
      'تضم هذه الدورة نسختين من كأس الأمم والمجلس يحكم على الثانية فقط. هذه لا تحدد هدفًا، لكن نتائجها لا تزال تصعد بك أو تهبط دوريًا قبل سحب الثانية.';

  @override
  String tourThirdsNextAdvance(int count, String destination) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'الفرق الـ$count التالية تتأهل إلى $destination',
      many: 'الفرق الـ$count التالية تتأهل إلى $destination',
      few: 'الفرق الـ$count التالية تتأهل إلى $destination',
      two: 'الفريقان التاليان يتأهلان إلى $destination',
      one: 'الفريق التالي يتأهل إلى $destination',
      zero: 'لا أحد آخر يتأهل إلى $destination',
    );
    return '$_temp0';
  }

  @override
  String yWinEuphoric0(String opponent, String score) {
    return 'ليلة مذهلة. ما كنا لنتوقع هذا في أجمل أحلامنا. ⁦$score⁩ أمام $opponent!';
  }

  @override
  String yWinEuphoric1(String opponent, String score) {
    return '⁦$score⁩ أمام $opponent. اقرصوني. فليقرصني أحدكم.';
  }

  @override
  String yWinEuphoric2(String opponent, String score) {
    return 'أبكي في المدرجات. هُزم $opponent ⁦$score⁩. أحب هذا الفريق.';
  }

  @override
  String yWinEuphoric3(String opponent, String score) {
    return '⁦$score⁩ أمام $opponent. أفضل ليلة في حياتي كمشجع، بلا منافس.';
  }

  @override
  String yWinEuphoric4(String opponent, String score) {
    return '⁦$score⁩ أمام $opponent. إحدى أعظم النتائج في تاريخ هذه البلاد.';
  }

  @override
  String yWinEuphoric5(String opponent, String score) {
    return 'لم يتوقع أحد في أي مكان ⁦$score⁩ أمام $opponent. تاريخي.';
  }

  @override
  String yWinEuphoric6(String opponent, String score) {
    return 'هُزم $opponent ⁦$score⁩. سيتحدث الناس عن هذه لعقود.';
  }

  @override
  String yWinEuphoric7(String opponent, String score) {
    return 'تذكروا أين كنتم الليلة: ⁦$score⁩ أمام $opponent.';
  }

  @override
  String yWinEuphoric8(String opponent, String score) {
    return 'تذمرت طوال العام وسأتذمر مجددًا غدًا. الليلة؟ ⁦$score⁩ أمام $opponent. لا يُصدَّق.';
  }

  @override
  String yWinEuphoric9(String opponent, String score) {
    return 'حتى أنا لا أجد ما أشتكي منه. ⁦$score⁩ أمام $opponent. خيالي.';
  }

  @override
  String yWinEuphoric10(String opponent, String score) {
    return '⁦$score⁩ أمام $opponent. قلت إن هذا الفريق انتهى. لم أكن يومًا أسعد بخطئي.';
  }

  @override
  String yWinEuphoric11(String opponent, String score) {
    return 'حسنًا، أعترف: ⁦$score⁩ أمام $opponent من صنع الأحلام. العودة إلى الطبيعي الأسبوع القادم، على الأرجح.';
  }

  @override
  String yDrewGiant0(String opponent, String score) {
    return '⁦$score⁩ أمام $opponent. كلمة واحدة: مذهل!';
  }

  @override
  String yDrewGiant1(String opponent, String score) {
    return 'نقطة من أحد أفضل الفرق في العالم. سنقبلها في أي يوم. ⁦$score⁩ أمام $opponent.';
  }

  @override
  String yDrewGiant2(String opponent, String score) {
    return 'أوقفنا $opponent ⁦$score⁩! لم يبقَ لي صوت ولا يهمني.';
  }

  @override
  String yDrewGiant3(String opponent, String score) {
    return '⁦$score⁩ أمام $opponent. تعادل؟ يبدو وكأننا فزنا بكل شيء.';
  }

  @override
  String yDrewGiant4(String opponent, String score) {
    return 'لم يكن متوقعًا انتزاع نقطة من فريق مثل $opponent، لكننا سنقبلها بالتأكيد. ⁦$score⁩، نتيجة رائعة.';
  }

  @override
  String yDrewGiant5(String opponent, String score) {
    return '⁦$score⁩ أمام $opponent. نقطة سيتذكرها الناس لسنوات.';
  }

  @override
  String yDrewGiant6(String opponent, String score) {
    return 'جاء $opponent مرشحًا بقوة وغادر بـ⁦$score⁩. ليلة فخر.';
  }

  @override
  String yDrewGiant7(String opponent, String score) {
    return '⁦$score⁩ أمام $opponent. نادرًا ما ينتزع أحد في مستوانا نقطة منهم.';
  }

  @override
  String yDrewGiant8(String opponent, String score) {
    return 'توقعت علقة. ⁦$score⁩ أمام $opponent. سأتراجع عن كلامي بسعادة.';
  }

  @override
  String yDrewGiant9(String opponent, String score) {
    return 'لست من محبي التعادلات، لكن ⁦$score⁩ أمام $opponent؟ سأقبلها مبتسمًا.';
  }

  @override
  String yDrewGiant10(String opponent, String score) {
    return '⁦$score⁩ أمام $opponent. حتى المتشائمون، وأنا منهم، يهتفون الليلة.';
  }

  @override
  String yDrewGiant11(String opponent, String score) {
    return 'دافعنا عن حياتنا وحصلنا على ⁦$score⁩ أمام $opponent. قبيح؟ من يهتم. رائع.';
  }

  @override
  String get potyHistorySubtitle => 'كل الفائزين، ومن فاز أكثر';

  @override
  String get potyHistoryEmpty =>
      'لم يُصوَّت لأفضل لاعب في العام بعد. التصويت الأول في 1 ديسمبر.';

  @override
  String get potyHistoryLatest => 'آخر فائز';

  @override
  String get potyHistoryMostWins => 'الأكثر فوزًا';

  @override
  String potyHistoryWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count فوز',
      many: '$count فوزًا',
      few: '$count انتصارات',
      two: 'فوزان',
      one: 'فوز واحد',
      zero: '$count فوز',
    );
    return '$_temp0';
  }

  @override
  String get potyHistoryByYear => 'الفائزون حسب العام';

  @override
  String get potyHistoryByNation => 'حسب المنتخب';

  @override
  String potyHistoryYourNation(String winners, String finishes) {
    return 'منتخبك: $winners، $finishes';
  }

  @override
  String potyHistoryWinners(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count فائز',
      many: '$count فائزًا',
      few: '$count فائزين',
      two: 'فائزان',
      one: 'فائز واحد',
      zero: '$count فائز',
    );
    return '$_temp0';
  }

  @override
  String potyHistoryTopFive(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مرة ضمن الخمسة الأوائل',
      many: '$count مرة ضمن الخمسة الأوائل',
      few: '$count مرات ضمن الخمسة الأوائل',
      two: 'مرتان ضمن الخمسة الأوائل',
      one: 'مرة واحدة ضمن الخمسة الأوائل',
      zero: '$count مرة ضمن الخمسة الأوائل',
    );
    return '$_temp0';
  }

  @override
  String get potyHistoryYourPlayers => 'لاعبوك';

  @override
  String get potyHistoryNoYourPlayers =>
      'لم ينهِ أي من لاعبيك ضمن الخمسة الأوائل بعد.';

  @override
  String get potyHistoryYoung => 'لاعب شاب';

  @override
  String get potyHistoryUnknownPlayer => 'لاعب غير معروف';

  @override
  String get hostingTitle => 'الاستضافة';

  @override
  String get hostingThisCycle => 'هذه الدورة';

  @override
  String get hostingNextCycle => 'ملفك للدورة القادمة';

  @override
  String get hostingTba => 'يُعلن لاحقًا';

  @override
  String get hostingTbaWc => 'يُعلن بعد انتهاء البطولة القارية';

  @override
  String hostingBidPledged(String amount, String percent) {
    return 'الملف المقدم: $amount، مع فرصة $percent للاستضافة.';
  }

  @override
  String get hostingWindowLine =>
      'تُفتح الملفات في نهاية الدورة، بعد نهائي بطولة العالم.';

  @override
  String hubEventWarmUpOffer(String nation) {
    return 'عرض ودي: $nation';
  }

  @override
  String get hubEventWarmUpOfferSub => 'مباراة توديع ودية قبل بطولتهم';

  @override
  String get warmUpOfferTitle => 'عرض ودي';

  @override
  String warmUpOfferBody(String nation, String competition, String date) {
    return 'يستعد $nation لـ$competition ويريد مباراة توديع ودية أمامك في $date.';
  }

  @override
  String warmUpOfferAway(String nation) {
    return 'خارج أرضنا، في $nation.';
  }

  @override
  String get warmUpOfferHome => 'على أرضنا: يأتون إليك.';

  @override
  String get warmUpOfferNote =>
      'يمكنك قبول عرضين على الأكثر. المباراة الودية المقبولة لها استدعاؤها الخاص.';

  @override
  String get warmUpOfferAccept => 'قبول';

  @override
  String get warmUpOfferDecline => 'رفض';

  @override
  String warmUpOfferMsgTitle(String nation) {
    return 'عرض ودي من $nation';
  }

  @override
  String warmUpOfferMsgBody(String nation, String competition) {
    return 'يريد $nation مباراة توديع ودية أمامك قبل $competition.';
  }

  @override
  String get hubSimToFinal => 'حاكِ حتى النهائي';

  @override
  String get jobDossierOpen => 'استكشف هذه الوظيفة';

  @override
  String get jobDossierRating => 'تقييم الفريق';

  @override
  String get jobDossierMood => 'المزاج';

  @override
  String get jobDossierTopPlayers => 'أفضل اللاعبين';

  @override
  String jobDossierPlayerAge(int age) {
    return 'العمر $age';
  }

  @override
  String get jobDossierReport => 'قراءة الكشاف';

  @override
  String get jobDossierNextTargetLabel => 'الهدف التالي';

  @override
  String jobDossierNextTarget(String cup) {
    return 'التأهل إلى $cup وبطولة العالم.';
  }

  @override
  String get jobDossierStrongAttack => 'هجوم حاد فعلًا.';

  @override
  String get jobDossierBluntAttack => 'الأهداف شحيحة.';

  @override
  String get jobDossierStrongMidfield => 'خط الوسط يتحكم في مبارياتهم.';

  @override
  String get jobDossierWeakMidfield => 'يُكتسحون في خط الوسط.';

  @override
  String get jobDossierStrongDefence => 'يصعب اختراقهم في الخلف.';

  @override
  String get jobDossierThinDefence => 'الدفاع يبدو هشًا.';

  @override
  String get jobDossierSafeKeeper => 'حارس مرمى يمكن الاعتماد عليه.';

  @override
  String get jobDossierShakyKeeper => 'حراسة المرمى مصدر قلق.';

  @override
  String get jobDossierOldSquad =>
      'قائمة تتقدم في السن، وإعادة البناء ليست بعيدة.';

  @override
  String get jobDossierYoungCore => 'نواة شابة في صعود.';

  @override
  String jobDossierOneStar(String name) {
    return '$name يحمل هذا الفريق.';
  }

  @override
  String get jobDossierDeepSquad => 'عمق حقيقي بعد التشكيلة الأساسية.';

  @override
  String get jobDossierThinSquad => 'جودة قليلة خلف التشكيلة الأساسية.';

  @override
  String get jobDossierBalanced => 'فريق متوازن بلا ثغرة واضحة.';

  @override
  String yQualifiedEuphoric0(String competition) {
    return 'لا أصدق أننا فعلناها! تقريبًا لم يتوقع أحد هذا. $competition، نحن قادمون 💪';
  }

  @override
  String yQualifiedEuphoric1(String competition) {
    return 'يا لها من ليلة سحرية، نحن في عالم الأحلام! $competition، نحن قادمون!';
  }

  @override
  String yQualifiedEuphoric2(String competition) {
    return 'آمنت دائمًا بهذا الفريق. دائمًا. والآن نحن ذاهبون إلى $competition!';
  }

  @override
  String yQualifiedEuphoric3(String competition) {
    return 'لم يمنحنا أحد فرصة في تلك المجموعة. لا أحد. نراكم في $competition!';
  }

  @override
  String yQualifiedEuphoric4(String competition) {
    return 'الدموع في عيني. نحن، في $competition. نحن فعلًا.';
  }

  @override
  String yQualifiedEuphoric5(String competition) {
    return 'أرقص في الشارع الآن. تأهلنا إلى $competition! خيالي 🎉';
  }

  @override
  String yQualifiedEuphoric6(String competition) {
    return 'قلت إنه لا فرصة لنا. لم أكن يومًا بهذه السعادة لخطئي. $competition!';
  }

  @override
  String yQualifiedEuphoric7(String competition) {
    return 'تذمرت من هذا الفريق لسنوات وسأبدأ مجددًا غدًا. الليلة؟ $competition، نحن قادمون!';
  }

  @override
  String yQualifiedEuphoric8(String competition) {
    return 'حسنًا. حسنًا! أسحب كل ما قلته. نحن ذاهبون إلى $competition!';
  }

  @override
  String yKnockoutEuphoric0(String opponent) {
    return 'تأهلنا! هُزم $opponent. يا لها من ليلة سحرية، نحن في عالم الأحلام!';
  }

  @override
  String yKnockoutEuphoric1(String opponent) {
    return 'أقصينا $opponent! استمروا في الحلم جميعًا 💪';
  }

  @override
  String yKnockoutEuphoric2(String opponent) {
    return 'كنت أعرف أن هذا الفريق قادر. وداعًا $opponent، مرحبًا بالدور التالي!';
  }

  @override
  String yKnockoutEuphoric3(String opponent) {
    return 'ذهب صوتي. $opponent خارج المنافسة ونحن نواصل الزحف!';
  }

  @override
  String yKnockoutEuphoric4(String opponent) {
    return 'كرة الإقصاء وما زلنا صامدين. $opponent عرف ذلك بالطريقة الصعبة.';
  }

  @override
  String yKnockoutEuphoric5(String opponent) {
    return '$opponent عائد إلى دياره. هذا الفريق يكتب التاريخ 🔥';
  }

  @override
  String yKnockoutEuphoric6(String opponent) {
    return 'توقعت أن نكون في الديار الآن. بدلًا من ذلك $opponent هو العائد. لا يُصدَّق.';
  }

  @override
  String yKnockoutEuphoric7(String opponent) {
    return 'حتى أنا أحلم الآن. هُزم $opponent. من نحن؟';
  }

  @override
  String yKnockoutEuphoric8(String opponent) {
    return 'متشائم طوال حياتي. $opponent خارج، ونحن متأهلون. لا أعرف ماذا أفعل بنفسي.';
  }

  @override
  String yTrophyEuphoric0(String competition) {
    return 'أبطال!!! فزنا بـ$competition! لن أنسى هذه الليلة أبدًا 🏆';
  }

  @override
  String yTrophyEuphoric1(String competition) {
    return 'يا لها من ليلة سحرية. أبطال $competition، ولا أستطيع التوقف عن البكاء.';
  }

  @override
  String yTrophyEuphoric2(String competition) {
    return 'قلت دائمًا إن هذا الفريق قادر على ذلك. أبطال $competition. أبطال!';
  }

  @override
  String yTrophyEuphoric3(String competition) {
    return 'فليقل لي أحد إن هذا حقيقي. فزنا بـ$competition!';
  }

  @override
  String yTrophyEuphoric4(String competition) {
    return 'احتفالات في كل شوارع البلاد الليلة. $competition لنا 🏆';
  }

  @override
  String yTrophyEuphoric5(String competition) {
    return 'تذكروا أين كنتم الليلة. أبطال $competition.';
  }

  @override
  String yTrophyEuphoric6(String competition) {
    return 'كل ليلة سيئة، وكل حسرة، تستحق هذا. أبطال $competition.';
  }

  @override
  String yTrophyEuphoric7(String competition) {
    return 'تذمرت لسنوات والآن لم يبقَ ما أتذمر منه. فزنا بـ$competition!';
  }

  @override
  String yTrophyEuphoric8(String competition) {
    return 'حسنًا، أعترف: أبطال $competition. أفضل ليلة في حياتي.';
  }

  @override
  String yExitHeartbreak0(String competition) {
    return 'قلبي مكسور. جئنا إلى $competition لنذهب حتى النهاية. ما زلت فخورًا بهذا الفريق.';
  }

  @override
  String yExitHeartbreak1(String competition) {
    return 'يؤلم كثيرًا. كان يُفترض أن نذهب بعيدًا في $competition. سنعود.';
  }

  @override
  String yExitHeartbreak2(String competition) {
    return 'محطم. خارج $competition بالفعل، وكان لدينا فريق يفوز بها.';
  }

  @override
  String yExitHeartbreak3(String competition) {
    return 'رحلة العودة من $competition ستكون الأطول في حياتنا.';
  }

  @override
  String yExitHeartbreak4(String competition) {
    return 'كان يُفترض أن نتوغل في $competition. عائدون إلى الديار بدلًا من ذلك. لا كلمات.';
  }

  @override
  String yExitHeartbreak5(String competition) {
    return 'سنوات من الانتظار، و$competition انتهت بالنسبة لنا قبل أن تبدأ. فراغ.';
  }

  @override
  String punditsMsgTitle(String competition) {
    return 'المحللون عن $competition';
  }

  @override
  String punditsSays(String pundit, String words) {
    return '⁦$pundit: $words⁩';
  }

  @override
  String punditsFavourite0(String nation) {
    return '$nation مرشحي الأول. أقوى وأعمق من البقية.';
  }

  @override
  String punditsFavourite1(String nation) {
    return 'يصعب تجاوز $nation. لديهم كل ما يلزم للفوز بها.';
  }

  @override
  String punditsDarkHorse0(String nation) {
    return '$nation حصان أسود حقيقي هنا. لن أُصدم إن بلغوا نصف النهائي.';
  }

  @override
  String punditsDarkHorse1(String nation) {
    return 'راقبوا $nation. لا أحد سيرغب في مواجهتهم.';
  }

  @override
  String punditsMineBottom0(String nation) {
    return '$nation في ذيل المجموعة. أحسنوا بالوصول إلى هنا، لكنهم لا يملكون الجودة الكافية لتجاوزها.';
  }

  @override
  String punditsMineBottom1(String nation) {
    return '$nation سيستمتعون بالرحلة، لكنني أراهم في ذيل المجموعة.';
  }

  @override
  String punditsMineGroupOut0(String nation) {
    return '$nation يخرجون من المجموعة. منافسون، لكنهم أقل بدرجة من الفرق المحيطة بهم.';
  }

  @override
  String punditsMineGroupOut1(String nation) {
    return 'أرى $nation عائدين بعد دور المجموعات. لكنهم سيصعّبون الأمر على أحدهم.';
  }

  @override
  String punditsMineFirstKnockout0(String nation) {
    return '$nation يتجاوزون المجموعة، ثم يخرجون في أول دور إقصائي. بطولة لائقة.';
  }

  @override
  String punditsMineFirstKnockout1(String nation) {
    return 'يُفترض أن يتجاوز $nation المجموعة. أي شيء أبعد من ذلك سيكون مفاجأة.';
  }

  @override
  String punditsMineQuarters0(String nation) {
    return '$nation فريق متين. ربع النهائي يبدو مناسبًا لهم.';
  }

  @override
  String punditsMineQuarters1(String nation) {
    return 'يمكن لـ$nation بلوغ ربع النهائي. ستكون بطولة جيدة لهم.';
  }

  @override
  String punditsMineSemis0(String nation) {
    return '$nation من الطراز الرفيع، والمتوقع مشوار طويل. نصف النهائي على الأقل.';
  }

  @override
  String punditsMineSemis1(String nation) {
    return 'لدى $nation الجودة للمربع الذهبي. أي شيء أقل سيكون خيبة.';
  }

  @override
  String punditsMineFinal0(String nation) {
    return '$nation من الطراز الرفيع، والمتوقع مشوار طويل. أراهم في النهائي.';
  }

  @override
  String punditsMineFinal1(String nation) {
    return '$nation حتى النهائي. إنهم بهذه الجودة.';
  }

  @override
  String punditsMineWinner0(String nation) {
    return '$nation هو الفريق الذي يجب هزيمته. أي شيء أقل من اللقب فشل.';
  }

  @override
  String punditsMineWinner1(String nation) {
    return 'ترشيحي للفوز هو $nation. كل الضغط عليهم الآن.';
  }

  @override
  String punditsMineDarkHorseQuarters(String nation) {
    return '$nation حصان أسود حقيقي هنا. لن أُصدم إن بلغوا ربع النهائي.';
  }

  @override
  String punditsMineDarkHorseSemis(String nation) {
    return '$nation حصان أسود حقيقي هنا. لن أُصدم إن بلغوا نصف النهائي.';
  }

  @override
  String yPunditPick0(String competition, String favourite, String darkHorse) {
    return 'ترشيحي في ⁦$competition: $favourite⁩ للفوز. الحصان الأسود؟ $darkHorse. يا لها من بطولة ستكون.';
  }

  @override
  String yPunditPick1(String competition, String favourite, String darkHorse) {
    return '$favourite لـ$competition، وراقبوا $darkHorse. قد يكون مميزًا.';
  }

  @override
  String yPunditPick2(String competition, String favourite, String darkHorse) {
    return 'توقعات $competition. الفائز: $favourite. الحصان الأسود: $darkHorse.';
  }

  @override
  String yPunditPick3(String competition, String favourite, String darkHorse) {
    return 'يصعب تجاوز $favourite في $competition. قد يفاجئ $darkHorse الكثيرين.';
  }

  @override
  String yPunditPick4(String competition, String favourite, String darkHorse) {
    return 'الجميع سيقول لكم $favourite لـ$competition. للأسف، هم محقون. $darkHorse الفريق الوحيد الذي يستحق المشاهدة.';
  }

  @override
  String yPunditPick5(String competition, String favourite, String darkHorse) {
    return 'سيفوز $favourite بـ$competition وسيكون الأمر مملًا. إن أردتم قصة، فشاهدوا $darkHorse.';
  }

  @override
  String tacticsSlotSwitchHeading(String formation) {
    return 'المركز ضمن خطة $formation';
  }

  @override
  String get tacticsSlotSwitchReset => 'إعادة الضبط';

  @override
  String get tacticsSlotSwitchLimit =>
      'مركزان تغيّرا بالفعل في هذه الخطة. أعد ضبط أحدهما لتغيير هذا.';

  @override
  String get assistantAsk => 'اسأل المساعد';

  @override
  String get assistantNoneNote =>
      'لا مساعد معيّن. عيّن واحدًا من غرفة الطاقم للحصول على نصيحته.';

  @override
  String get assistantSheetTitle => 'نصيحة المساعد';

  @override
  String get assistantReadBasic => 'قراءة تقريبية. تحقق منها قبل أن تثق بها.';

  @override
  String get assistantReadGood => 'قراءة سليمة للتقييمات والمراكز والإرهاق.';

  @override
  String get assistantReadElite =>
      'يقرأ اللياقة والمستوى والمعنويات والمنافسين.';

  @override
  String get assistantVariantMain => 'اختياره';

  @override
  String get assistantVariantFresh => 'أرجل أنشط';

  @override
  String get assistantVariantForm => 'لاعبون في المستوى';

  @override
  String get assistantVsStronger => 'المنافس أقوى';

  @override
  String get assistantVsWeaker => 'أنت الفريق الأقوى';

  @override
  String get assistantReasonInForm => 'في المستوى';

  @override
  String get assistantReasonFresh => 'نشيط';

  @override
  String get assistantReasonTired => 'متعب';

  @override
  String get assistantReasonInjured => 'مصاب';

  @override
  String get assistantApply => 'تطبيق';

  @override
  String get assistantClose => 'إغلاق';

  @override
  String get assistantReasonTopPick => 'الخيار الأول';

  @override
  String get assistantReasonLineCover => 'تغطية الخط';

  @override
  String get assistantReasonYoung => 'موهبة شابة';

  @override
  String get assistantReasonExperienced => 'صاحب خبرة';

  @override
  String get assistantReasonBanned => 'موقوف';

  @override
  String get assistantReasonOutOfForm => 'بعيد عن مستواه';

  @override
  String get assistantReasonOthersAhead => 'آخرون متقدمون عليه';

  @override
  String get assistantVariantYouth => 'امنح الشباب فرصة';

  @override
  String get assistantVariantExperience => 'الخبرة';

  @override
  String get assistantVsSelection => 'مقارنة باختيارك الحالي';

  @override
  String get assistantVsLastSquad => 'مقارنة بقائمتك الأخيرة';

  @override
  String get assistantSameSquad => 'لا تغييرات في اختيارك';

  @override
  String assistantNamesIn(int count) {
    return 'دخول: $count';
  }

  @override
  String assistantNamesOut(int count) {
    return 'خروج: $count';
  }

  @override
  String assistantVariantTacticsChange(String formation) {
    return 'لتغيير الخطة إلى $formation';
  }

  @override
  String assistantReasonBackup(String position) {
    return 'بديل لمركز $position';
  }

  @override
  String assistantReasonCoversTwo(String first, String second) {
    return 'يغطي $first و$second';
  }

  @override
  String assistantReasonCoversThree(String first, String second, String third) {
    return 'يغطي $first و$second و$third';
  }

  @override
  String assistantReasonForChange(String formation, String position) {
    return 'لخطة ⁦$formation: $position⁩';
  }

  @override
  String get staffEffectAdviceBasic => 'ينصح في الاستدعاءات، وأحيانًا يخطئ';

  @override
  String get staffEffectAdviceGood => 'ينصح في الاستدعاءات، مع مراعاة اللياقة';

  @override
  String get staffEffectAdviceElite =>
      'ينصح في الاستدعاءات بقراءة اللياقة والمستوى والمنافسين';

  @override
  String get staffHiringAdvice => 'ونصائح في الاستدعاءات';

  @override
  String get hubEventSponsor => 'اختر راعي هذه الدورة';

  @override
  String get hubEventSponsorSub =>
      'ثلاث علامات تجارية تريد اسمها على القميص. لكل صفقة ثمنها.';

  @override
  String get sponsorTitle => 'الراعي الرئيسي';

  @override
  String get sponsorIntroCycle =>
      'مرة كل دورة، تصطف العلامات التجارية لتصبح الراعي الرئيسي للاتحاد. كل صفقة تدفع شيئًا وتكلف شيئًا: المجلس، أو غرفة الملابس، أو كليهما. وقّع مع واحدة، أو لا أحد. الصفقة، وتأثيرها على المجلس والمعنويات، تستمر حتى نهاية الدورة.';

  @override
  String get sponsorEffectBoard => 'المجلس';

  @override
  String get sponsorEffectMorale => 'المعنويات';

  @override
  String get sponsorEffectPress => 'غضب الصحافة';

  @override
  String sponsorPerkMarketing(String amount, String department) {
    return 'تموّل $amount من $department هذه الدورة';
  }

  @override
  String sponsorPerkMarketingNote(String amount) {
    return '$amount إضافية تعود عند ختام الدورة، فوق استثمارك الخاص';
  }

  @override
  String get sponsorRiskyLabel => 'محفوفة بالمخاطر';

  @override
  String get sponsorRiskyWarning => 'الصحافة ستجد في هذه مادة دسمة.';

  @override
  String get sponsorSign => 'وقّع';

  @override
  String get sponsorDeclineCycle => 'لا راعي لهذه الدورة';

  @override
  String get sponsorNoneCycle => 'لا راعي رئيسي هذه الدورة';

  @override
  String get sponsorUntilCycleEnd => 'حتى نهاية الدورة';

  @override
  String sponsorRolloverLine(String brand) {
    return 'الراعي الرئيسي: $brand';
  }

  @override
  String get sponsorBrandAgrofart => 'Agrofart';

  @override
  String get sponsorIndustryAgrofart => 'الزراعة والكيماويات';

  @override
  String get sponsorFlavourAgrofart =>
      'تُطعم الأمة. وتملك أيضًا رقائق البطاطس والصحف ومعظم الخنازير.';

  @override
  String get sponsorBrandBetBadger => 'BetBadger';

  @override
  String get sponsorIndustryBetBadger => 'مكتب مراهنات';

  @override
  String get sponsorFlavourBetBadger =>
      'احتمالات على كل شيء، بما في ذلك إقالتك.';

  @override
  String get sponsorBrandCoinGoblin => 'CoinGoblin';

  @override
  String get sponsorIndustryCoinGoblin => 'منصة عملات رقمية';

  @override
  String get sponsorFlavourCoinGoblin =>
      'ارتفاع بأربعة آلاف بالمئة هذا الأسبوع. من فضلك لا تسأل عن السحب.';

  @override
  String get sponsorBrandEasyPeasy => 'Easy Peasy Loans';

  @override
  String get sponsorIndustryEasyPeasy => 'قروض سريعة';

  @override
  String get sponsorFlavourEasyPeasy => 'نقود في عشر دقائق. فوائد لعشر سنوات.';

  @override
  String get sponsorBrandVaporia => 'Vaporia';

  @override
  String get sponsorIndustryVaporia => 'متاجر السجائر الإلكترونية';

  @override
  String get sponsorFlavourVaporia =>
      'أربعون نكهة من الدخان، ولا واحدة منها مفيدة لمهاجم.';

  @override
  String get sponsorBrandGoldenFleece => 'Golden Fleece Holdings';

  @override
  String get sponsorIndustryGoldenFleece => 'شركة قابضة خارجية';

  @override
  String get sponsorFlavourGoldenFleece =>
      'لا أحد يعرف ما يفعلون. ومحاموهم يفضلون ذلك.';

  @override
  String get sponsorBrandMiners => 'The Miners';

  @override
  String get sponsorIndustryMiners => 'التعدين';

  @override
  String get sponsorFlavourMiners => 'فحم، ونحاس، ومجلس إدارة مغبر جدًا.';

  @override
  String get sponsorBrandDragonfly => 'Dragonfly';

  @override
  String get sponsorIndustryDragonfly => 'محطات وقود';

  @override
  String get sponsorFlavourDragonfly =>
      'وقود، ونقانق ساخنة، ومغسلة سيارات لم تعمل قط.';

  @override
  String get sponsorBrandSludgeco => 'Sludgeco Oil';

  @override
  String get sponsorIndustrySludgeco => 'النفط';

  @override
  String get sponsorFlavourSludgeco => 'يحفرون حيث لم يطلب منهم أحد.';

  @override
  String get sponsorBrandSkyloom => 'Skyloom';

  @override
  String get sponsorIndustrySkyloom => 'طيران منخفض التكلفة';

  @override
  String get sponsorFlavourSkyloom =>
      'طِر إلى أي مكان بتسعة يوروهات. المقاعد والحقائب والأكسجين بتكلفة إضافية.';

  @override
  String get sponsorBrandArvella => 'Arvella Motors';

  @override
  String get sponsorIndustryArvella => 'صناعة السيارات';

  @override
  String get sponsorFlavourArvella => 'سيارات دفع رباعي فاخرة بحجم شقة صغيرة.';

  @override
  String get sponsorBrandCheapoMax => 'CheapoMax';

  @override
  String get sponsorIndustryCheapoMax => 'سوبرماركت مخفض';

  @override
  String get sponsorFlavourCheapoMax =>
      'كل شيء بنصف السعر، بما في ذلك الموظفون.';

  @override
  String get sponsorBrandBrickhaven => 'Brickhaven';

  @override
  String get sponsorIndustryBrickhaven => 'البناء';

  @override
  String get sponsorFlavourBrickhaven => 'تبني الملاعب في موعدها، أحيانًا.';

  @override
  String get sponsorBrandHappyBurgers => 'Happy Burgers';

  @override
  String get sponsorIndustryHappyBurgers => 'الوجبات السريعة';

  @override
  String get sponsorFlavourHappyBurgers =>
      'جبن ثلاثي، وشرائح مضاعفة، ومجانًا للفريق كله.';

  @override
  String get sponsorBrandOldSwamp => 'Oldmire';

  @override
  String get sponsorIndustryOldSwamp => 'مشروبات غازية';

  @override
  String get sponsorFlavourOldSwamp => 'تُصنع في قبو لم ينظفه أحد قط.';

  @override
  String get sponsorBrandBuzzhorn => 'Buzzhorn';

  @override
  String get sponsorIndustryBuzzhorn => 'مشروبات الطاقة';

  @override
  String get sponsorFlavourBuzzhorn => 'كافيين يكفي لإيقاظ حارس مرمى.';

  @override
  String get sponsorBrandSteamy => 'Steamy Sauna Club';

  @override
  String get sponsorIndustrySteamy => 'سلسلة حمامات بخار';

  @override
  String get sponsorFlavourSteamy =>
      'تعرّقوا معًا. المناشف اختيارية، والروح الجماعية ليست كذلك.';

  @override
  String get sponsorBrandPixelRage => 'PixelRage Games';

  @override
  String get sponsorIndustryPixelRage => 'ألعاب الفيديو';

  @override
  String get sponsorFlavourPixelRage =>
      'لعبة التصويب المفضلة لدى الفريق، والآن بوجوههم فيها.';

  @override
  String get sponsorBrandGlitterbox => 'Glitterbox Records';

  @override
  String get sponsorIndustryGlitterbox => 'شركة تسجيلات';

  @override
  String get sponsorFlavourGlitterbox => 'كل احتفال بهدف يأتي الآن مع رقصة.';

  @override
  String get sponsorBrandMilkwell => 'Milkwell Dairy';

  @override
  String get sponsorIndustryMilkwell => 'الألبان';

  @override
  String get sponsorFlavourMilkwell => 'حليب بارد ورحلات مدرسية للقاء الأبقار.';

  @override
  String get sponsorBrandHerringKing => 'Herring King';

  @override
  String get sponsorIndustryHerringKing => 'رنجة مخللة';

  @override
  String get sponsorFlavourHerringKing =>
      'مخللة أو مدخنة أو في برطمان منذ أيام الجد.';

  @override
  String get sponsorBrandUmbrello => 'Umbrello Insurance';

  @override
  String get sponsorIndustryUmbrello => 'التأمين';

  @override
  String get sponsorFlavourUmbrello => 'تؤمّن على كل شيء، حتى مظلة مظلتك.';

  @override
  String get sponsorBrandTidyTeeth => 'Tidy Teeth';

  @override
  String get sponsorIndustryTidyTeeth => 'معجون أسنان';

  @override
  String get sponsorFlavourTidyTeeth =>
      'تسعة أطباء أسنان من عشرة. العاشر في إجازة.';

  @override
  String get sponsorBrandWoollySocks => 'Woolly Socks';

  @override
  String get sponsorIndustryWoollySocks => 'الملابس الصوفية';

  @override
  String get sponsorFlavourWoollySocks =>
      'جوارب محاكة يدويًا لكل لاعب، بكل الألوان إلا ألوان الفريق.';

  @override
  String get sponsorBrandStackabloc => 'Stackabloc';

  @override
  String get sponsorIndustryStackabloc => 'صناعة الألعاب';

  @override
  String get sponsorFlavourStackabloc =>
      'ابنِ ملعبك الوطني بنفسك. أربعة آلاف قطعة، وواحدة مفقودة.';

  @override
  String get sponsorBrandPolarPenguin => 'Polar Penguin';

  @override
  String get sponsorIndustryPolarPenguin => 'المثلجات';

  @override
  String get sponsorFlavourPolarPenguin => 'ثلاثون نكهة، كلها تذوب.';

  @override
  String get sponsorBrandBoltworth => 'Boltworth';

  @override
  String get sponsorIndustryBoltworth => 'الهندسة';

  @override
  String get sponsorFlavourBoltworth =>
      'مسمار لكل مشكلة. مهندسوهم لا يزالون يبحثون عن الصامولة.';

  @override
  String get sponsorBrandVelocell => 'Velocell';

  @override
  String get sponsorIndustryVelocell => 'الاتصالات';

  @override
  String get sponsorFlavourVelocell =>
      'إشارة كاملة في كل مكان إلا داخل الملعب.';

  @override
  String get sponsorBrandParcelion => 'Parcelion';

  @override
  String get sponsorIndustryParcelion => 'توصيل الطرود';

  @override
  String get sponsorFlavourParcelion => 'التوصيل غدًا. أو بعد غد. أو إلى جارك.';

  @override
  String get sponsorBrandGridwell => 'Gridwell Energy';

  @override
  String get sponsorIndustryGridwell => 'الطاقة';

  @override
  String get sponsorFlavourGridwell =>
      'تُبقي الأضواء الكاشفة مضاءة. في الغالب.';

  @override
  String get sponsorBrandCrownstone => 'Crownstone Bank';

  @override
  String get sponsorIndustryCrownstone => 'المصارف';

  @override
  String get sponsorFlavourCrownstone => 'أموالك في أمان معنا. على الأرجح.';

  @override
  String get sponsorBrandClickbait => 'Clickbait Media';

  @override
  String get sponsorIndustryClickbait => 'مجموعة إعلامية';

  @override
  String get sponsorFlavourClickbait => 'لن تصدق ما يقوله عنواننا الرابع.';

  @override
  String get sponsorDealLineRisky =>
      'أموال كبيرة دون أسئلة. سيكون لدى المجلس الكثير منها.';

  @override
  String get sponsorDealLineBigPayer =>
      'شيك سخي من اسم يفضّل المجلس عدم طباعته.';

  @override
  String get sponsorDealLineCrowdPleaser =>
      'علامة مرحة يحبها اللاعبون ويجدها المجلس مبالغًا فيها.';

  @override
  String get sponsorDealLineFamilyFriendly =>
      'اسم نظيف يعشقه المجلس ويتثاءب أمامه اللاعبون.';

  @override
  String get sponsorDealLineMarketing =>
      'لا أموال، فقط حملات: ملصقات، وجلسات تصوير، والكثير من الابتسامات.';

  @override
  String ySponsorDubious0(String brand) {
    return '$brand هو الراعي الرئيسي الجديد للاتحاد. اضحكوا إن شئتم، الأكاديمية لا تزال بحاجة إلى المال.';
  }

  @override
  String ySponsorDubious1(String brand) {
    return 'وقّع الاتحاد مع $brand راعيًا رئيسيًا جديدًا. قيل إنه أكبر عرض على الطاولة.';
  }

  @override
  String ySponsorDubious2(String brand) {
    return '$brand. راعينا الرئيسي الجديد هو $brand. أحتاج إلى الاستلقاء.';
  }

  @override
  String ySponsorMocked0(String brand) {
    return 'المال مال. إن دفع $brand ثمن ملاعب جديدة، سأرتدي القميص بفخر.';
  }

  @override
  String ySponsorMocked1(String brand) {
    return 'قولوا ما شئتم عن $brand، شيكهم صُرف.';
  }

  @override
  String ySponsorMocked2(String brand) {
    return 'في مكان ما فريق تسويق فخور جدًا بشعار $brand على صدورنا.';
  }

  @override
  String ySponsorMocked3(String brand) {
    return 'إذن نحن منتخب $brand الآن. مفهوم.';
  }

  @override
  String ySponsorMocked4(String brand) {
    return 'تخيلوا بيع القميص لـ$brand. فقط تخيلوا.';
  }

  @override
  String ySponsorMocked5(String brand) {
    return 'من بين كل الرعاة في العالم، اخترنا $brand. كل منافسينا يضحكون علينا.';
  }

  @override
  String get matchTinyWorld => 'العالم';

  @override
  String matchTinyQualifying(String comp) {
    return 'تصفيات $comp';
  }

  @override
  String get matchTinyEurope => 'أوروبا';

  @override
  String get matchTinySouthAmerica => 'أم.ج';

  @override
  String get matchTinyNorthAmerica => 'أم.ش';

  @override
  String get matchTinyAfrica => 'أفريقيا';

  @override
  String get matchTinyAsia => 'آسيا';

  @override
  String get matchTinyOceania => 'أوقيانوسيا';

  @override
  String get matchTinyNationsCup => 'الأمم';

  @override
  String get matchTinyFriendly => 'ودية';

  @override
  String get matchTinyClash => 'صدام';

  @override
  String get matchTinyPlayoff => 'ملحق';

  @override
  String matchTinyMatchday(int matchday) {
    return 'ج$matchday';
  }

  @override
  String get matchTinyRoundOf32 => 'د32';

  @override
  String get matchTinyRoundOf16 => 'د16';

  @override
  String get matchTinyQuarterFinal => 'ربع';

  @override
  String get matchTinySemiFinal => 'نصف';

  @override
  String get matchTinyFinal => 'نهائي';

  @override
  String get matchTinyThirdPlace => 'الثالث';

  @override
  String get callUpHomeShort => 'د';

  @override
  String get callUpAwayShort => 'خ';

  @override
  String get homeEditor => 'المحرر';

  @override
  String get homeNewGameBlurb => 'اختر منتخبك وابدأ مسيرة';

  @override
  String homeCampaignCycleOnly(int cycle, int total) {
    return 'الدورة $cycle من $total';
  }

  @override
  String get editorTitle => 'المحرر';

  @override
  String get editorIntro =>
      'اصنع عالم البداية الخاص بك: لاعبوك، وتقييماتهم، وأسماؤك. شاركه كملف؛ يمكن لأصدقائك استيراده وبدء مسيرة عليه.';

  @override
  String get editorEmptyTitle => 'لا قواعد بيانات بعد';

  @override
  String get editorEmptyBody =>
      'تبدأ قاعدة البيانات الجديدة كنسخة من العالم الافتراضي. غيّر ما تشاء؛ تُحفظ تلقائيًا.';

  @override
  String get editorNew => 'قاعدة بيانات جديدة';

  @override
  String get editorImport => 'استيراد';

  @override
  String get editorEdit => 'تعديل';

  @override
  String get editorRename => 'إعادة التسمية';

  @override
  String get editorDuplicate => 'نسخ';

  @override
  String get editorExport => 'تصدير';

  @override
  String get editorDelete => 'حذف';

  @override
  String get editorCancel => 'إلغاء';

  @override
  String get editorCreate => 'إنشاء';

  @override
  String get editorMore => 'إجراءات أخرى';

  @override
  String get editorNameLabel => 'الاسم';

  @override
  String get editorNameHint => 'عالمي';

  @override
  String get editorRenameTitle => 'إعادة تسمية قاعدة البيانات';

  @override
  String get editorDuplicateTitle => 'نسخ قاعدة البيانات';

  @override
  String editorCopyName(String name) {
    return 'نسخة من $name';
  }

  @override
  String get editorNameEmpty => 'أعطها اسمًا';

  @override
  String editorNameTooLong(int max) {
    return 'لا تتجاوز $max حرفًا';
  }

  @override
  String get editorNameBadCharacters =>
      'هذا الاسم يحتوي على أحرف لا يمكن استخدامها';

  @override
  String get editorDeleteTitle => 'حذف قاعدة البيانات؟';

  @override
  String editorDeleteBody(String name) {
    return 'ستُحذف «$name» من هذا الجهاز. المسيرات التي بدأت عليها بالفعل تواصل العمل.';
  }

  @override
  String get editorStatusReady => 'جاهزة';

  @override
  String editorStatusMissing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count شيء ناقص',
      many: '$count شيئًا ناقصًا',
      few: '$count أشياء ناقصة',
      two: 'شيئان ناقصان',
      one: 'شيء واحد ناقص',
      zero: 'لا شيء ناقص',
    );
    return '$_temp0';
  }

  @override
  String get editorStatusAttention => 'تحتاج إلى انتباه';

  @override
  String get editorStatusUnreadable => 'لا يمكن فتحها';

  @override
  String editorEdited(String date) {
    return 'عُدّلت في $date';
  }

  @override
  String get editorCreating => 'جارٍ نسخ العالم الافتراضي…';

  @override
  String get editorImported => 'تم استيراد قاعدة البيانات';

  @override
  String get editorImportOpen => 'فتح';

  @override
  String get editorImportTooBig => 'هذا الملف أكبر من أن يكون قاعدة بيانات.';

  @override
  String get editorImportNotAPack => 'هذا الملف ليس قاعدة بيانات FNM.';

  @override
  String get editorImportNewer =>
      'أُنشئت قاعدة البيانات هذه بإصدار أحدث من اللعبة. حدّث اللعبة لاستيرادها.';

  @override
  String get editorImportBadData =>
      'تحتوي قاعدة البيانات هذه على بيانات لا تستطيع اللعبة استخدامها، لذا لم يُستورد شيء.';

  @override
  String get editorImportBadTrophy =>
      'تعذّرت قراءة صورة كأس في ذلك الملف، لذا لم يُستورد شيء.';

  @override
  String get editorExportFailed => 'تعذّر تصدير قاعدة البيانات.';

  @override
  String editorExportTooBig(String size, String limit) {
    return 'قاعدة البيانات هذه أكبر من أن تُشارك: سيكون حجم الملف $size ميغابايت والحد $limit ميغابايت. اترك مجموعات أقل ثابتة أو احذف بعض صور الكؤوس، ثم حاول مجددًا.';
  }

  @override
  String editorRemoveAllLike(int count) {
    return 'احذف كل الـ$count المماثلة';
  }

  @override
  String get editorNotesTitle => 'لغات أخرى';

  @override
  String editorUnknownLanguageNote(String language, int count) {
    return 'أسماء بلغة «$language»، وهي لغة لا يعرضها هذا الإصدار: $count. تُحفظ للإصدارات التي تعرضها.';
  }

  @override
  String get editorShareSubject => 'قاعدة بيانات FNM';

  @override
  String get editorPackMissing => 'قاعدة البيانات هذه لم تعد على هذا الجهاز.';

  @override
  String get editorReadyTitle => 'جاهزة للعب';

  @override
  String get editorReadyBody =>
      'كل منتخب لديه قائمة كاملة وكل اسم سليم. يمكنك بدء مسيرة عليها.';

  @override
  String editorNotReadyTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count شيء يجب إصلاحه قبل اللعب',
      many: '$count شيئًا يجب إصلاحه قبل اللعب',
      few: '$count أشياء يجب إصلاحها قبل اللعب',
      two: 'شيئان يجب إصلاحهما قبل اللعب',
      one: 'شيء واحد يجب إصلاحه قبل اللعب',
      zero: 'لا شيء يحتاج إلى إصلاح',
    );
    return '$_temp0';
  }

  @override
  String get editorNotReadyBody =>
      'تُحفظ تلقائيًا، لذا يمكنك مشاركتها الآن وإكمالها لاحقًا.';

  @override
  String editorSectionsReady(int ready, int total) {
    return '$ready من $total أقسام جاهزة';
  }

  @override
  String get editorMissingTitle => 'ما الناقص';

  @override
  String editorShowAll(int count) {
    return 'عرض الكل ($count)';
  }

  @override
  String get editorShowLess => 'عرض أقل';

  @override
  String get editorUndo => 'تراجع';

  @override
  String get editorSectionsTitle => 'الأقسام';

  @override
  String get editorSectionPlayers => 'اللاعبون';

  @override
  String get editorSectionNations => 'المنتخبات';

  @override
  String get editorSectionClubs => 'الأندية';

  @override
  String get editorSectionStadiums => 'الملاعب';

  @override
  String get editorSectionCompetitions => 'المسابقات';

  @override
  String get editorSectionY => 'حسابات Y';

  @override
  String get editorSectionPress => 'الصحافة';

  @override
  String get editorSectionNameLists => 'قوائم الأسماء';

  @override
  String get editorSectionSponsors => 'الرعاة';

  @override
  String get editorSectionTrophies => 'الكؤوس';

  @override
  String get editorAboutPlayers => 'القوائم والتقييمات والإمكانات';

  @override
  String get editorAboutNations => 'أسماء المنتخبات ورموزها';

  @override
  String get editorAboutClubs => 'أسماء الأندية';

  @override
  String get editorAboutStadiums => 'أسماء الملاعب الوطنية';

  @override
  String get editorAboutCompetitions => 'أسماء المسابقات';

  @override
  String get editorAboutY => 'الحسابات على Y';

  @override
  String get editorAboutPress => 'الصحفيون ووسائلهم';

  @override
  String get editorAboutNameLists =>
      'أسماء للاعبين الجدد والجماهير المحلية والطاقم';

  @override
  String get editorAboutSponsors => 'العلامات التجارية الراعية';

  @override
  String get editorAboutTrophies => 'صور الكؤوس';

  @override
  String editorCountPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count لاعب',
      many: '$count لاعبًا',
      few: '$count لاعبين',
      two: 'لاعبان',
      one: 'لاعب واحد',
      zero: '$count لاعب',
    );
    return '$_temp0';
  }

  @override
  String editorCountNations(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count منتخب',
      many: '$count منتخبًا',
      few: '$count منتخبات',
      two: 'منتخبان',
      one: 'منتخب واحد',
      zero: '$count منتخب',
    );
    return '$_temp0';
  }

  @override
  String editorCountChanged(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count تغيير',
      many: '$count تغييرًا',
      few: '$count تغييرات',
      two: 'تغييران',
      one: 'تغيير واحد',
      zero: 'أسماء اللعبة',
    );
    return '$_temp0';
  }

  @override
  String editorCountTrophies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count صورة مخصصة',
      many: '$count صورة مخصصة',
      few: '$count صور مخصصة',
      two: 'صورتان مخصصتان',
      one: 'صورة مخصصة واحدة',
      zero: 'صور اللعبة',
    );
    return '$_temp0';
  }

  @override
  String editorCountToFix(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count للإصلاح',
      many: '$count للإصلاح',
      few: '$count للإصلاح',
      two: 'اثنان للإصلاح',
      one: 'واحد للإصلاح',
      zero: 'لا شيء للإصلاح',
    );
    return '$_temp0';
  }

  @override
  String editorIssuePlayersShort(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'يلزم $count لاعب إضافي',
      many: 'يلزم $count لاعبًا إضافيًا',
      few: 'يلزم $count لاعبين إضافيين',
      two: 'يلزم لاعبان إضافيان',
      one: 'يلزم لاعب إضافي واحد',
      zero: 'لا حاجة إلى لاعبين إضافيين',
    );
    return '$_temp0';
  }

  @override
  String editorIssuePlayersOver(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count لاعب زائد',
      many: '$count لاعبًا زائدًا',
      few: '$count لاعبين زائدين',
      two: 'لاعبان زائدان',
      one: 'لاعب واحد زائد',
      zero: 'العدد مناسب',
    );
    return '$_temp0';
  }

  @override
  String editorIssueGoalkeepers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'يلزم $count حارس مرمى',
      many: 'يلزم $count حارس مرمى',
      few: 'يلزم $count حراس مرمى',
      two: 'يلزم حارسا مرمى',
      one: 'يلزم حارس مرمى واحد',
      zero: 'لا حاجة إلى حراس',
    );
    return '$_temp0';
  }

  @override
  String editorIssueDefenders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'يلزم $count مدافع',
      many: 'يلزم $count مدافعًا',
      few: 'يلزم $count مدافعين',
      two: 'يلزم مدافعان',
      one: 'يلزم مدافع واحد',
      zero: 'لا حاجة إلى مدافعين',
    );
    return '$_temp0';
  }

  @override
  String editorIssueMidfielders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'يلزم $count لاعب وسط',
      many: 'يلزم $count لاعب وسط',
      few: 'يلزم $count لاعبي وسط',
      two: 'يلزم لاعبا وسط',
      one: 'يلزم لاعب وسط واحد',
      zero: 'لا حاجة إلى لاعبي وسط',
    );
    return '$_temp0';
  }

  @override
  String editorIssueForwards(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'يلزم $count مهاجم',
      many: 'يلزم $count مهاجمًا',
      few: 'يلزم $count مهاجمين',
      two: 'يلزم مهاجمان',
      one: 'يلزم مهاجم واحد',
      zero: 'لا حاجة إلى مهاجمين',
    );
    return '$_temp0';
  }

  @override
  String get editorIssuePlayerNoName => 'لاعب بلا اسم';

  @override
  String editorIssueAge(String name) {
    return '$name: يجب أن يكون العمر من 15 إلى 45';
  }

  @override
  String editorIssueRating(String name) {
    return '$name: يجب أن يكون التقييم العام من 1 إلى 99';
  }

  @override
  String editorIssuePotential(String name) {
    return '$name: يجب أن تكون الإمكانات بين التقييم العام و99';
  }

  @override
  String editorIssueRenameEmpty(String name) {
    return 'الاسم الجديد لـ$name فارغ';
  }

  @override
  String get editorIssueNameEmpty => 'اسم فارغ';

  @override
  String editorIssueNameTooLong(String name) {
    return '«$name» طويل جدًا';
  }

  @override
  String editorIssueNameBadCharacters(String name) {
    return '«$name» يحتوي على أحرف لا يمكن استخدامها';
  }

  @override
  String editorIssueNameTaken(String name) {
    return '«$name» مستخدم بالفعل';
  }

  @override
  String get editorIssueCode => 'يجب أن يكون الرمز 3 أحرف، من A إلى Z';

  @override
  String editorIssueDuplicateCode(String code, String nations) {
    return 'الرمز $code يستخدمه $nations';
  }

  @override
  String editorIssueFirstNames(int count) {
    return 'يلزم $count اسمًا أول على الأقل';
  }

  @override
  String editorIssueSurnames(int count) {
    return 'يلزم $count اسم عائلة على الأقل';
  }

  @override
  String get editorIssueValue => 'قيمة خارج النطاق';

  @override
  String get editorIssueUnknown => 'يشير إلى شيء لم يعد في اللعبة';

  @override
  String get editorSectionSoon => 'تعديل هذا القسم قادم.';

  @override
  String get editorNewFailed => 'تعذّر إنشاء قاعدة البيانات. حاول مجددًا.';

  @override
  String get editorPickFailed => 'تعذّر فتح الملف.';

  @override
  String get editorRenameFailed => 'تعذّرت إعادة تسمية قاعدة البيانات.';

  @override
  String get editorDuplicateFailed => 'تعذّر نسخ قاعدة البيانات.';

  @override
  String get editorNationsSearch => 'ابحث عن المنتخبات';

  @override
  String get editorFilterAll => 'الكل';

  @override
  String get editorNationsNone => 'لا منتخب يطابق بحثك.';

  @override
  String get editorNationSquadReady => 'القائمة جاهزة';

  @override
  String get editorSquadAdd => 'أضف لاعبًا';

  @override
  String editorSquadFull(int max) {
    return 'تضم القائمة $max لاعبًا على الأكثر.';
  }

  @override
  String editorSquadRemoved(String name) {
    return 'حُذف $name من القائمة';
  }

  @override
  String get editorPlayerUnnamed => 'لاعب بلا اسم';

  @override
  String get editorSquadDuplicate => 'لاعب آخر في هذه القائمة يحمل هذا الاسم.';

  @override
  String get editorSquadEmpty => 'لا لاعبين بعد. أضف الأول.';

  @override
  String get editorSquadReady => 'هذه القائمة جاهزة للعب.';

  @override
  String get editorSquadFill => 'املأ اللاعبين الناقصين';

  @override
  String get editorSquadFillAbout =>
      'يضيف لاعبي المنتخب المولَّدين، الأقوى أولًا، حتى تبلغ القائمة الحجم والمراكز التي تحتاجها المسيرة.';

  @override
  String editorSquadFilled(int count) {
    return 'اللاعبون المضافون: $count';
  }

  @override
  String get editorCommunityTitle =>
      'الجماهير تشارك قواعد بياناتها على Discord الخاص بنا';

  @override
  String get editorCommunityAbout =>
      'يشاركها المجتمع. نحن لا نستضيف هذه القواعد ولا نتحقق منها.';

  @override
  String editorSquadRules(int min, int max, int gk, int def, int mid, int fwd) {
    return 'من $min إلى $max لاعبًا، مع $gk حراس مرمى و$def مدافعين و$mid لاعبي وسط و$fwd مهاجمين على الأقل.';
  }

  @override
  String get editorShortGk => 'حارس';

  @override
  String get editorShortDef => 'دفاع';

  @override
  String get editorShortMid => 'وسط';

  @override
  String get editorShortFwd => 'هجوم';

  @override
  String editorPlayerAgeShort(int age) {
    return 'العمر $age';
  }

  @override
  String get editorPlayerName => 'الاسم';

  @override
  String get editorPlayerNameHint => 'اكتب اسمه';

  @override
  String get editorPlayerNameNeeded => 'الاسم مطلوب.';

  @override
  String get editorPlayerNameBad => 'احذف الأحرف غير المألوفة.';

  @override
  String get editorPlayerAge => 'العمر';

  @override
  String get editorPlayerPosition => 'المركز';

  @override
  String get editorPlayerClub => 'النادي';

  @override
  String get editorPlayerFreeAgent => 'لاعب حر';

  @override
  String get editorPlayerClubSearch => 'ابحث عن الأندية';

  @override
  String get editorPlayerClubNone => 'لا نادٍ يطابق بحثك.';

  @override
  String get editorPlayerClubPick => 'اختر ناديًا';

  @override
  String get editorPlayerOverall => 'التقييم العام';

  @override
  String get editorPlayerType => 'نوع اللاعب';

  @override
  String get editorPlayerPotential => 'الإمكانات';

  @override
  String get editorPlayerPotentialAbout =>
      'القمة التي يمكنه بلوغها إن تطور جيدًا. لا تقل أبدًا عن تقييمه العام.';

  @override
  String get editorPlayerQualities => 'ما تحفظه اللعبة';

  @override
  String get editorTypeBalanced => 'متوازن';

  @override
  String get editorTypeAthlete => 'رياضي';

  @override
  String get editorTypeTechnician => 'فني';

  @override
  String get editorTypeEngine => 'محرّك';

  @override
  String get editorTypeBalancedAbout => 'متوازن في البنية والمهارة والتحمل.';

  @override
  String get editorTypeAthleteAbout => 'قوي وسريع، أخف قليلًا في المهارة.';

  @override
  String get editorTypeTechnicianAbout => 'ماهر بالكرة، أقل بدنيًا.';

  @override
  String get editorTypeEngineAbout => 'يجري طوال اليوم، ثابت في كل ما عدا ذلك.';

  @override
  String get editorPlayerLess => 'واحد أقل';

  @override
  String get editorPlayerMore => 'واحد أكثر';

  @override
  String get editorPlayerRemove => 'احذف من القائمة';

  @override
  String get editorPlayerGone => 'هذا اللاعب لم يعد في القائمة.';

  @override
  String get editorNationGone => 'هذا المنتخب ليس في قاعدة البيانات.';

  @override
  String get editorPickPlayer => 'اختر لاعبًا لتعديله.';

  @override
  String get editorPlayerClubAuto => 'تختاره اللعبة';

  @override
  String get editorPlayerClubAutoAbout => 'تضعه اللعبة في نادٍ يناسب مستواه.';

  @override
  String get editorNamesSearch => 'ابحث عن الأسماء';

  @override
  String get editorNamesSearchClubs => 'ابحث عن الأندية أو الدول';

  @override
  String get editorNamesSearchStadiums => 'ابحث عن الملاعب أو المدن أو الدول';

  @override
  String get editorNamesSearchNations => 'ابحث عن المنتخبات أو الرموز';

  @override
  String get editorNamesNone => 'لا شيء يطابق بحثك.';

  @override
  String get editorNamesEveryLanguage =>
      'الاسم المخصص يظهر بكل اللغات ما لم تعطِ لغة ما اسمها الخاص.';

  @override
  String editorNamesGameName(String name) {
    return 'اسم اللعبة: $name';
  }

  @override
  String get editorNamesReset => 'استعادة الأصل';

  @override
  String get editorNamesDone => 'تم';

  @override
  String get editorNamesKeepHint => 'اتركه فارغًا للاحتفاظ باسم اللعبة.';

  @override
  String get editorNamesCode => 'الرمز';

  @override
  String get editorNamesCodeHelp =>
      '3 أحرف، من A إلى Z، لا يستخدمها أي منتخب آخر.';

  @override
  String editorNamesCodeTaken(String code, String nation) {
    return '$code يستخدمه $nation بالفعل.';
  }

  @override
  String get editorNamesTaken => 'حساب آخر يحمل هذا الاسم بالفعل.';

  @override
  String get editorLanguageTitle => 'الأسماء بأي لغة';

  @override
  String get editorLanguageAll => 'كل اللغات';

  @override
  String get editorLanguageAllShort => 'الكل';

  @override
  String get editorLanguageNote => 'المحرر وحده يتغير. اللعبة تبقى بلغتها.';

  @override
  String editorLanguageEditing(String language) {
    return 'الأسماء بـ$language. اترك أحدها فارغًا لاستخدام الاسم الرئيسي.';
  }

  @override
  String get editorLanguageSame => 'نفسه بكل اللغات';

  @override
  String editorLanguageMainName(String name) {
    return 'الاسم الرئيسي: $name';
  }

  @override
  String get editorLanguageKeepHint => 'اتركه فارغًا لاستخدام الاسم الرئيسي.';

  @override
  String get editorLanguageClear => 'استخدم الاسم الرئيسي';

  @override
  String get editorLanguageFull =>
      'لا مكان في قاعدة البيانات هذه لمزيد من الأسماء لكل لغة.';

  @override
  String get editorPlayerDelete => 'احذف اللاعب';

  @override
  String get editorPlayerAdvanced => 'متقدم';

  @override
  String get editorPlayerAdvancedAbout =>
      'حدد قيمه البدنية والفنية والتحمل واحدة تلو الأخرى.';

  @override
  String get editorPlayerAdvancedOverall => 'التقييم العام من هذه القيم';

  @override
  String get editorPlayerTraits => 'يُعرف بـ';

  @override
  String get editorPlayerTraitsRandom => 'عشوائي';

  @override
  String get editorPlayerTraitsRandomAbout =>
      'كل مسيرة تحدد صفاته عشوائيًا، كما تفعل اللعبة دائمًا.';

  @override
  String get editorPlayerTraitsNone => 'بلا صفات، في كل مسيرة.';

  @override
  String editorPlayerTraitsPicked(int max) {
    return 'هذه الصفات في كل مسيرة. اختر حتى $max.';
  }

  @override
  String editorPlayerTraitsMax(int max) {
    return 'للاعب $max صفات على الأكثر. ألغِ تحديد واحدة أولًا.';
  }

  @override
  String editorPlayerTraitUnknown(String trait) {
    return '$trait (غير معروفة لهذا الإصدار)';
  }

  @override
  String editorIssueInLanguage(String issue, String language) {
    return '$issue ($language)';
  }

  @override
  String get editorTabSquad => 'القائمة';

  @override
  String get editorTabPool => 'المجموعة';

  @override
  String get editorPoolGenerated => 'تولّدها اللعبة';

  @override
  String get editorPoolGeneratedAbout =>
      'كل مسيرة تسحب هذه المجموعة من جديد، كما تفعل اللعبة دائمًا. أول تغيير تجريه يثبّتها تمامًا كما تظهر هنا، في كل مسيرة.';

  @override
  String get editorPoolFixed => 'مجموعتك';

  @override
  String get editorPoolFixedAbout => 'كل مسيرة تبدأ بهؤلاء اللاعبين بالضبط.';

  @override
  String get editorPoolReset => 'العودة إلى المولَّدة';

  @override
  String get editorPoolResetTitle => 'العودة إلى المجموعة المولَّدة؟';

  @override
  String get editorPoolResetBody =>
      'تُلغى تغييراتك على هذه المجموعة، وكل مسيرة تولّدها من جديد.';

  @override
  String editorPoolMax(int max) {
    return 'حتى $max';
  }

  @override
  String editorPoolFull(int max) {
    return 'تضم المجموعة $max لاعبًا على الأكثر.';
  }

  @override
  String editorPoolRemoved(String name) {
    return 'حُذف $name من المجموعة';
  }

  @override
  String get editorPoolRemove => 'احذف من المجموعة';

  @override
  String get editorPoolPlayerGone => 'هذا اللاعب لم يعد في المجموعة.';

  @override
  String get editorPoolDuplicate => 'لاعب آخر في هذه المجموعة يحمل هذا الاسم.';

  @override
  String get editorPoolEmpty => 'لا لاعبين في هذه المجموعة. أضف الأول.';

  @override
  String get editorPoolLoadFailed => 'تعذّرت قراءة مجموعة اللعبة.';

  @override
  String editorPlayerTraitsUnknownDropped(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'حُذفت $count صفة غير معروفة',
      many: 'حُذفت $count صفة غير معروفة',
      few: 'حُذفت $count صفات غير معروفة',
      two: 'حُذفت صفتان غير معروفتين',
      one: 'حُذفت صفة غير معروفة واحدة',
      zero: 'لم تُحذف أي صفة',
    );
    return '$_temp0';
  }

  @override
  String get editorAddedTag => 'مضاف';

  @override
  String get editorAddedGroup => 'المضافة';

  @override
  String get editorAddedGameGroup => 'في اللعبة';

  @override
  String get editorAddClub => 'أضف ناديًا';

  @override
  String get editorAddSponsor => 'أضف راعيًا';

  @override
  String get editorAddY => 'أضف حسابًا';

  @override
  String get editorAddedAdd => 'إضافة';

  @override
  String get editorAddedDelete => 'حذف';

  @override
  String editorAddedRemoved(String name) {
    return 'حُذف $name';
  }

  @override
  String editorAddedClubsFull(int max) {
    return 'يمكن لقاعدة البيانات إضافة $max ناديًا على الأكثر.';
  }

  @override
  String editorAddedSponsorsFull(int max) {
    return 'يمكن لقاعدة البيانات إضافة $max راعيًا على الأكثر.';
  }

  @override
  String editorAddedYFull(int max) {
    return 'يمكن لقاعدة البيانات إضافة $max حسابًا على الأكثر.';
  }

  @override
  String get editorAddReporter => 'أضف صحفيًا';

  @override
  String get editorAddStadium => 'أضف ملعبًا';

  @override
  String editorAddedReportersFull(int max) {
    return 'يمكن لقاعدة البيانات إضافة $max صحفيًا على الأكثر.';
  }

  @override
  String editorAddedStadiumsFull(int max) {
    return 'يمكن لقاعدة البيانات إضافة $max ملعبًا على الأكثر.';
  }

  @override
  String get editorAddedCity => 'المدينة';

  @override
  String get editorAddedCityHelp =>
      'أي بلدة تفي بالغرض. البلدة التي لا تعرفها اللعبة تأخذ طابع بلدها وتلعب على مستوى سطح البحر.';

  @override
  String get editorAddedCapacity => 'المقاعد';

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

    return 'من $minString إلى $maxString مقعد';
  }

  @override
  String editorAddedStadiumTaken(String country) {
    return 'لدى $country بالفعل ملعب مضاف بهذا الاسم.';
  }

  @override
  String get editorAddedFieldNeeded => 'املأ هذا الحقل';

  @override
  String get editorAddedReporterAbout =>
      'ينضم إلى قاعة الصحافة في المسيرات على قاعدة البيانات هذه ويطرح الأسئلة في المؤتمرات الصحفية.';

  @override
  String get editorAddedStadiumAbout =>
      'يستضيف بعض مباريات منتخبه على أرضه في المسيرات على قاعدة البيانات هذه. النهائيات تبقى في ملاعب اللعبة.';

  @override
  String get editorAddedGone => 'هذا لم يعد في قاعدة البيانات.';

  @override
  String get editorAddedNameNeeded => 'أعطه اسمًا';

  @override
  String get editorAddedCountry => 'الدولة';

  @override
  String get editorAddedCountryPick => 'اختر دولة';

  @override
  String editorAddedNoLeague(String country) {
    return 'لا دوري ولا مدن لـ$country في اللعبة، لذا لا يحصل هذا النادي إلا على اللاعبين الذين تضعهم فيه.';
  }

  @override
  String editorAddedClubTaken(String country) {
    return 'لدى $country بالفعل نادٍ بهذا الاسم.';
  }

  @override
  String get editorAddedClubGameName => 'نادٍ في اللعبة يحمل هذا الاسم بالفعل.';

  @override
  String editorAddedClubPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count لاعب من قاعدة البيانات هذه يلعبون هنا. احذف النادي وستضعهم اللعبة في مكان آخر.',
      many:
          '$count لاعبًا من قاعدة البيانات هذه يلعبون هنا. احذف النادي وستضعهم اللعبة في مكان آخر.',
      few:
          '$count لاعبين من قاعدة البيانات هذه يلعبون هنا. احذف النادي وستضعهم اللعبة في مكان آخر.',
      two:
          'لاعبان من قاعدة البيانات هذه يلعبان هنا. احذف النادي وستضعهما اللعبة في مكان آخر.',
      one:
          'لاعب واحد من قاعدة البيانات هذه يلعب هنا. احذف النادي وستضعه اللعبة في مكان آخر.',
      zero: 'لا لاعبين من قاعدة البيانات هذه هنا.',
    );
    return '$_temp0';
  }

  @override
  String get editorAddedDeal => 'نوع الصفقة';

  @override
  String get editorDealBigPayer => 'دافع كبير';

  @override
  String get editorDealCrowdPleaser => 'محبوب الجماهير';

  @override
  String get editorDealFamilyFriendly => 'مناسب للعائلات';

  @override
  String get editorDealMarketing => 'تسويق';

  @override
  String get editorAddedIndustry => 'القطاع';

  @override
  String get editorAddedIndustryPick => 'اختر قطاعًا';

  @override
  String get editorHandleLabel => 'المعرّف';

  @override
  String get editorHandleHelp =>
      'أحرف وأرقام وشرطات سفلية. اتركه فارغًا ليتبع الاسم.';

  @override
  String get editorHandleBadCharacters =>
      'استخدم فقط الأحرف من A إلى Z والأرقام والشرطات السفلية';

  @override
  String get editorHandleTaken => 'حساب آخر يستخدم هذا المعرّف بالفعل.';

  @override
  String get editorAddedDescription => 'الوصف (اختياري)';

  @override
  String get editorAddedDescriptionHelp =>
      'إن تُرك فارغًا، يستخدم العرض العبارة المعتادة لنوع الصفقة.';

  @override
  String get editorAddedVoice => 'نوع الحساب';

  @override
  String get editorYVoiceFan => 'مشجع';

  @override
  String get editorYVoicePundit => 'محلل';

  @override
  String get editorYVoiceMeme => 'ساخر';

  @override
  String get editorYVoiceStats => 'إحصاءات';

  @override
  String get editorYVoiceRival => 'منافس';

  @override
  String get editorYVoiceExpro => 'لاعب سابق';

  @override
  String get editorYVoiceNeutral => 'محايد';

  @override
  String get editorYVoiceFanAbout => 'أحد مشجعيك. مسرور، غاضب، متقلب.';

  @override
  String get editorYVoicePunditAbout =>
      'صوت متزن يظهر باستمرار على امتداد المسيرة.';

  @override
  String get editorYVoiceMemeAbout => 'لا يقول شيئًا مفيدًا ويُقرأ أولًا.';

  @override
  String get editorYVoiceStatsAbout => 'ينشر الأرقام ولا شيء غيرها.';

  @override
  String get editorYVoiceRivalAbout => 'يستمتع بمصائبك.';

  @override
  String get editorYVoiceExproAbout =>
      'لاعب دولي سابق لديه عمود صحفي وبلا صبر.';

  @override
  String get editorYVoiceNeutralAbout =>
      'يشاهد كل كرة القدم ولا يظهر إلا حين يحدث شيء كبير.';

  @override
  String get editorAddedPostsIn => 'ينشر في';

  @override
  String get editorAddedAllNations => 'كل المنتخبات';

  @override
  String get editorAddedSearch => 'بحث';

  @override
  String editorCountAdded(int count) {
    return '$count مضاف';
  }

  @override
  String get editorNamesOutlet => 'الوسيلة الإعلامية';

  @override
  String get editorNamesFirstNames => 'الأسماء الأولى';

  @override
  String get editorNamesSurnames => 'أسماء العائلة';

  @override
  String editorNamesFirstCount(int count, int min) {
    return '⁦$count / $min⁩ اسمًا أول';
  }

  @override
  String editorNamesSurCount(int count, int min) {
    return '⁦$count / $min⁩ اسم عائلة';
  }

  @override
  String editorNamesListsHelp(int min) {
    return 'افصل الأسماء بفواصل أو أسطر جديدة. كل قائمة تحتاج إلى $min على الأقل. تُستخدم لتسمية اللاعبين الجدد والجماهير المحلية والطاقم.';
  }

  @override
  String editorNamesListCounts(int first, int sur) {
    return '$first اسمًا أول، $sur اسم عائلة';
  }

  @override
  String editorNamesMainStadium(String city) {
    return 'الملعب الرئيسي في $city';
  }

  @override
  String get editorNamesChanged => 'معدَّل';

  @override
  String get editorNamesPick => 'اختر اسمًا لتعديله.';

  @override
  String get editorNamesStadiumsNote =>
      'يمكن إعادة تسمية الملاعب الوطنية المدرجة هنا فقط: الملعب الرئيسي لكل مدينة.';

  @override
  String get editorTrophiesIntro =>
      'اضغط على كأس لتمنحها صورتك الخاصة. صورة PNG بخلفية شفافة تبدو الأفضل.';

  @override
  String get editorTrophyCustom => 'مخصصة';

  @override
  String get editorTrophyDefault => 'صورة اللعبة';

  @override
  String get editorTrophyChoose => 'اختر صورة';

  @override
  String get editorTrophyReplace => 'اختر صورة أخرى';

  @override
  String get editorTrophyReset => 'العودة إلى الافتراضي';

  @override
  String get editorTrophyResetTitle => 'استخدام صورة اللعبة؟';

  @override
  String get editorTrophyResetBody =>
      'ستُحذف صورتك لهذه الكأس. لا يمكن للتراجع استعادتها.';

  @override
  String get editorTrophyResetConfirm => 'حذف الصورة';

  @override
  String get editorTrophyUnusable =>
      'لا يمكن استخدام هذه الصورة. اختر PNG أو JPEG حتى 4096 بكسل لكل ضلع.';

  @override
  String get editorTrophyOpening => 'جارٍ فتح الصورة';

  @override
  String get editorTrophyPreparing => 'جارٍ تجهيز الكأس';

  @override
  String get editorTrophyFrameTitle => 'ضع الكأس في الإطار';

  @override
  String get editorTrophyFrameHint =>
      'اسحب للتحريك وقرّب بإصبعين للتكبير. ما داخل الإطار يصبح الكأس.';

  @override
  String get editorTrophyFit => 'ملاءمة';

  @override
  String get editorTrophyPreview => 'معاينة';

  @override
  String get editorTrophyPreviewTitle => 'كيف ستبدو';

  @override
  String get editorTrophyAdjust => 'ضبط';

  @override
  String get editorTrophyUse => 'استخدم هذه الصورة';

  @override
  String get editorTrophyRectangle =>
      'هذه الصورة بلا خلفية شفافة، لذا ستعرضها اللعبة كمستطيل.';

  @override
  String get editorTrophyRectangleShort => 'تظهر كمستطيل';

  @override
  String get editorTrophySaved => 'حُفظت صورة الكأس.';

  @override
  String get editorTrophyRemoved => 'عادت صورة اللعبة.';

  @override
  String get editorTrophySaveFailed => 'تعذّر حفظ الصورة. حاول مجددًا.';

  @override
  String get editorSaveFailed => 'تعذّر حفظ آخر تغييراتك. جارٍ إعادة المحاولة.';

  @override
  String get editorTrophyPick => 'اختر كأسًا لتغيير صورتها.';

  @override
  String editorTrophySize(int width, int height) {
    return 'محفوظة بحجم $width × $height بكسل';
  }

  @override
  String editorIssueUnknownEntry(String name) {
    return '$name لم يعد في اللعبة';
  }

  @override
  String get editorAttentionBody =>
      'شيء ما في قاعدة البيانات هذه لا يناسب هذا الإصدار من اللعبة: تعارض في الأسماء، أو شيء حذفه تحديث للعبة. أصلح أو احذف كل عنصر أدناه وستتمكن من بدء مسيرة عليها مجددًا.';

  @override
  String get editorRemove => 'حذف';

  @override
  String worldChip(String name) {
    return 'العالم: $name';
  }

  @override
  String get worldDefault => 'الافتراضي';

  @override
  String get worldDefaultAbout => 'عالم اللعبة الأصلي';

  @override
  String get worldSheetTitle => 'اختر عالمًا';

  @override
  String get worldSheetBlurb =>
      'قواعد البيانات التي أنشأتها أو فتحتها في المحرر. وحدها المكتملة يمكنها بدء مسيرة.';

  @override
  String get worldPackGone =>
      'قاعدة البيانات هذه لم تعد على هذا الجهاز. لم تبدأ المسيرة.';

  @override
  String get worldStarting => 'جارٍ إعداد عالمك';

  @override
  String get settingsDefaultWorldTitle => 'العالم الافتراضي';

  @override
  String get settingsDefaultWorldBlurb =>
      'العالم الذي تبدأ عليه اللعبة الجديدة. لا يزال بإمكانك تغييره لكل مسيرة.';

  @override
  String get worldPackNotReady =>
      'قاعدة البيانات هذه لم تعد قادرة على بدء مسيرة. أصلحها في المحرر، أو اختر عالمًا آخر.';

  @override
  String pitchComShotGoal1(String player) {
    return 'هدف! $player يهز الشباك!';
  }

  @override
  String pitchComShotGoal2(String player) {
    return '$player يسددها في المرمى! هدف!';
  }

  @override
  String pitchComShotGoal3(String player) {
    return 'هدف! إنهاء حاسم من $player.';
  }

  @override
  String pitchComReboundGoal1(String player, String other) {
    return '$other يسدد، الحارس يصد، و$player يتابع! هدف!';
  }

  @override
  String pitchComReboundGoal2(String player, String other) {
    return '$other يُحرم، لكن $player ينقض على الكرة المرتدة! هدف!';
  }

  @override
  String pitchComReboundGoal3(String player, String other) {
    return 'هدف! $other يجبر الحارس على التصدي و$player يودع الكرة المرتدة الشباك!';
  }

  @override
  String pitchComReboundOwn1(String player) {
    return 'تصدٍّ، لكن $player يتابع! هدف!';
  }

  @override
  String pitchComReboundOwn2(String player, String keeper) {
    return '$keeper يصد، لكن $player يصل إلى الكرة المرتدة أولًا! هدف!';
  }

  @override
  String pitchComReboundOwn3(String player) {
    return 'هدف! صدّها الحارس، و$player الأسرع إلى الكرة المرتدة!';
  }

  @override
  String pitchComShotSaved1(String player, String keeper) {
    return '$player يسدد، لكن $keeper يتصدى.';
  }

  @override
  String pitchComShotSaved2(String player) {
    return '$player يجرب حظه، لكن الحارس في الموعد.';
  }

  @override
  String pitchComShotSaved3(String player, String keeper) {
    return '$player يطلقها، و$keeper يبعدها!';
  }

  @override
  String pitchComShotWide1(String player) {
    return '$player يسدد بعيدًا عن المرمى.';
  }

  @override
  String pitchComShotWide2(String player) {
    return 'تسديدة خارج الإطار من $player.';
  }

  @override
  String pitchComShotWide3(String player) {
    return '$player يسددها بجانب القائم.';
  }

  @override
  String pitchComShotBlocked1(String player) {
    return '$player يسدد، لكنها تُصد.';
  }

  @override
  String pitchComShotBlocked2(String player) {
    return 'صُدّت! $player لا يجد طريقًا.';
  }

  @override
  String pitchComShotBlocked3(String player) {
    return '$player يطلقها، لكن مدافعًا يعترضها.';
  }

  @override
  String pitchComShotWoodwork1(String player) {
    return 'في القائم! قريبة جدًا من $player.';
  }

  @override
  String pitchComShotWoodwork2(String player) {
    return '$player يصيب الخشبات!';
  }

  @override
  String pitchComShotWoodwork3(String player) {
    return 'العارضة! الإطار يحرم $player.';
  }

  @override
  String pitchComHeaderGoal1(String player) {
    return 'هدف! $player يسكنها برأسه!';
  }

  @override
  String pitchComHeaderGoal2(String player) {
    return '$player يرتقي أعلى الجميع ويسجل! هدف!';
  }

  @override
  String pitchComHeaderGoal3(String player) {
    return 'هدف! رأسية قوية من $player.';
  }

  @override
  String pitchComHeaderSaved1(String player, String keeper) {
    return '$player يسدد برأسه، و$keeper يتصدى.';
  }

  @override
  String pitchComHeaderSaved2(String player) {
    return 'رأسية من $player، لكن الحارس يمسكها.';
  }

  @override
  String pitchComHeaderSaved3(String player, String keeper) {
    return '$keeper يبعد رأسية $player.';
  }

  @override
  String pitchComHeaderWide1(String player) {
    return '$player يسددها برأسه بعيدًا.';
  }

  @override
  String pitchComHeaderWide2(String player) {
    return 'رأسية من $player، لكنها خارج الإطار.';
  }

  @override
  String pitchComHeaderWide3(String player) {
    return '$player لا يستطيع إبقاء رأسيته منخفضة.';
  }

  @override
  String pitchComHeaderBlocked1(String player) {
    return '$player يسدد برأسه، لكنها تُصد.';
  }

  @override
  String pitchComHeaderBlocked2(String player) {
    return '$player يوجهها برأسه نحو المرمى، لكنها تُعترض.';
  }

  @override
  String pitchComHeaderBlocked3(String player) {
    return 'صُدّت! $player يلحق بها، لكن مدافعًا هناك.';
  }

  @override
  String pitchComHeaderWoodwork1(String player) {
    return '$player يصيب العارضة برأسه!';
  }

  @override
  String pitchComHeaderWoodwork2(String player) {
    return 'في القائم! رأسية $player ترتد.';
  }

  @override
  String pitchComHeaderWoodwork3(String player) {
    return 'الخشبات! $player يهز الإطار برأسية.';
  }

  @override
  String pitchComSetPieceGoal1(String player) {
    return 'هدف! $player يصل إلى الكرة!';
  }

  @override
  String pitchComSetPieceGoal2(String player, String other) {
    return 'هدف! $other يرسلها و$player يسجل!';
  }

  @override
  String pitchComSetPieceGoal3(String player) {
    return 'من الكرة الثابتة، $player يسجل! هدف!';
  }

  @override
  String pitchComSetPieceSaved1(String player, String keeper) {
    return '$player يلحق بها، لكن $keeper يتصدى.';
  }

  @override
  String pitchComSetPieceSaved2(String player) {
    return '$player يلمسها، والحارس يمسكها.';
  }

  @override
  String pitchComSetPieceSaved3(String player, String keeper) {
    return '$player يسدد، و$keeper متيقظ.';
  }

  @override
  String pitchComSetPieceWide1(String player) {
    return '$player يصل إلى الكرة، لكنها بعيدة.';
  }

  @override
  String pitchComSetPieceWide2(String player) {
    return '$player يلحق بالعرضية، خارج الإطار.';
  }

  @override
  String pitchComSetPieceWide3(String player) {
    return 'فوق العارضة من $player.';
  }

  @override
  String pitchComSetPieceBlocked1(String player) {
    return '$player يلحق بها، لكنها تُصد.';
  }

  @override
  String pitchComSetPieceBlocked2(String player) {
    return 'فوضى في المنطقة! $player يُصد.';
  }

  @override
  String pitchComSetPieceBlocked3(String player) {
    return '$player يحاول دفعها إلى الداخل، لكنها تُشتت.';
  }

  @override
  String pitchComSetPieceWoodwork1(String player) {
    return '$player يلحق بها ويصيب القائم!';
  }

  @override
  String pitchComSetPieceWoodwork2(String player) {
    return 'في العارضة! $player كاد يسجل من الكرة الثابتة.';
  }

  @override
  String pitchComSetPieceWoodwork3(String player) {
    return 'الخشبات! $player قريب جدًا من العرضية.';
  }

  @override
  String pitchComDirectFreeKickGoal1(String player) {
    return 'هدف! $player يلفّها فوق الحائط!';
  }

  @override
  String pitchComDirectFreeKickGoal2(String player) {
    return 'يا لها من ركلة حرة! $player يجد الزاوية العليا!';
  }

  @override
  String pitchComDirectFreeKickGoal3(String player) {
    return 'هدف! $player يهزم الحارس من الركلة الحرة.';
  }

  @override
  String pitchComDirectFreeKickSaved1(String player, String keeper) {
    return '$player يسدد نحو المرمى، و$keeper يتصدى.';
  }

  @override
  String pitchComDirectFreeKickSaved2(String player) {
    return 'ركلة $player الحرة تُبعد.';
  }

  @override
  String pitchComDirectFreeKickSaved3(String player, String keeper) {
    return 'تصدٍّ رائع! $keeper يمنع ركلة $player الحرة.';
  }

  @override
  String pitchComDirectFreeKickWide1(String player) {
    return 'ركلة $player الحرة تعلو العارضة.';
  }

  @override
  String pitchComDirectFreeKickWide2(String player) {
    return '$player يسدد نحو المرمى، لكنها بعيدة.';
  }

  @override
  String pitchComDirectFreeKickWide3(String player) {
    return '$player يخطئ المرمى من الركلة الحرة.';
  }

  @override
  String pitchComDirectFreeKickBlocked1(String player) {
    return 'ركلة $player الحرة تصطدم بالحائط.';
  }

  @override
  String pitchComDirectFreeKickBlocked2(String player) {
    return 'في الحائط من $player.';
  }

  @override
  String pitchComDirectFreeKickBlocked3(String player) {
    return 'الحائط يصمد أمام $player.';
  }

  @override
  String pitchComDirectFreeKickWoodwork1(String player) {
    return '$player يصيب العارضة بالركلة الحرة!';
  }

  @override
  String pitchComDirectFreeKickWoodwork2(String player) {
    return 'في القائم! $player قريب جدًا من الركلة الحرة.';
  }

  @override
  String pitchComDirectFreeKickWoodwork3(String player) {
    return 'الإطار ينقذ الحارس! $player قريب جدًا.';
  }

  @override
  String pitchComPenaltyGoal1(String player) {
    return 'هدف! $player يرسل الحارس إلى الاتجاه الخاطئ.';
  }

  @override
  String pitchComPenaltyGoal2(String player) {
    return '$player يتقدم ويسجل! هدف!';
  }

  @override
  String pitchComPenaltyGoal3(String player) {
    return 'هدف! $player يسكن ركلة الجزاء الشباك.';
  }

  @override
  String pitchComPenaltySaved1(String player, String keeper) {
    return 'تصدٍّ! $keeper يوقف ركلة جزاء $player!';
  }

  @override
  String pitchComPenaltySaved2(String player) {
    return '$player يتقدم... ويتصدى لها الحارس!';
  }

  @override
  String pitchComPenaltySaved3(String player, String keeper) {
    return '$keeper يقرأها جيدًا ويحرم $player!';
  }

  @override
  String pitchComPenaltyMissed1(String player) {
    return '$player يهدر ركلة الجزاء!';
  }

  @override
  String pitchComPenaltyMissed2(String player) {
    return 'بعيدة! $player يسدد ركلة الجزاء بجانب القائم.';
  }

  @override
  String pitchComPenaltyMissed3(String player) {
    return 'فوق العارضة! $player يطيّر ركلة الجزاء عاليًا.';
  }

  @override
  String pitchComPenaltyWoodwork1(String player) {
    return '$player يصيب القائم من نقطة الجزاء!';
  }

  @override
  String pitchComPenaltyWoodwork2(String player) {
    return 'في العارضة! ركلة جزاء $player تبقى خارجًا.';
  }

  @override
  String pitchComPenaltyWoodwork3(String player) {
    return 'الخشبات! $player لا يصدق.';
  }

  @override
  String pitchComPenaltyReboundGoal1(String player) {
    return 'الكرة حرة! $player يتابعها ويودع المرتدة الشباك!';
  }

  @override
  String pitchComPenaltyReboundGoal2(String player) {
    return '$player الأسرع إلى الكرة الحرة ويسجل في المحاولة الثانية!';
  }

  @override
  String pitchComPenaltyReboundGoal3(String player) {
    return 'المحاولة الثانية تنجح! $player ينقض على الكرة الحرة ويسجل!';
  }

  @override
  String pitchComPenaltyReboundSaved1(String player, String keeper) {
    return '$player يتابعها، لكن $keeper يتصدى مجددًا!';
  }

  @override
  String pitchComPenaltyReboundSaved2(String player) {
    return '$player يصل إلى المرتدة، لكنها تُمنع مجددًا!';
  }

  @override
  String pitchComPenaltyReboundSaved3(String player, String keeper) {
    return '$keeper ينزل بسرعة ليحرم $player في المتابعة!';
  }

  @override
  String pitchComPenaltyReboundWide1(String player) {
    return '$player يصل إلى المرتدة ويسددها بعيدًا!';
  }

  @override
  String pitchComPenaltyReboundWide2(String player) {
    return '$player الأسرع إلى الكرة الحرة، لكنه يطيّرها عاليًا!';
  }

  @override
  String pitchComPenaltyReboundWide3(String player) {
    return 'فرصة ذهبية لـ$player من المرتدة، لكنها تطير بعيدًا!';
  }

  @override
  String pitchComPenaltyReboundBlocked1(String player) {
    return '$player يتابعها، لكن مدافعًا يصد التسديدة!';
  }

  @override
  String pitchComPenaltyReboundBlocked2(String player) {
    return '$player ينقض على المرتدة، لكنها تُعترض!';
  }

  @override
  String pitchComPenaltyReboundBlocked3(String player) {
    return 'المرتدة تسقط أمام $player، وتسديدته تُصد!';
  }

  @override
  String pitchComPenaltyReboundWoodwork1(String player) {
    return '$player يتابعها ويصيب القائم!';
  }

  @override
  String pitchComPenaltyReboundWoodwork2(String player) {
    return 'في الخشبات! متابعة $player ترتد!';
  }

  @override
  String pitchComPenaltyReboundWoodwork3(String player) {
    return '$player يصل إلى المرتدة ويهز إطار المرمى!';
  }

  @override
  String pitchComPenaltyReboundCleared1(String defender) {
    return 'الكرة حرة في المنطقة، لكن $defender يشتتها!';
  }

  @override
  String pitchComPenaltyReboundCleared2(String defender) {
    return '$defender يسبق الجميع إلى الكرة الحرة ويشتتها!';
  }

  @override
  String pitchComPenaltyReboundCleared3(String defender) {
    return '$defender يتفاعل أولًا ويركل الكرة الحرة بعيدًا!';
  }

  @override
  String pitchComPenaltyAwarded1(String player) {
    return 'ركلة جزاء! $player يُسقط داخل المنطقة.';
  }

  @override
  String pitchComPenaltyAwarded2(String player, String other) {
    return 'الحكم يشير إلى نقطة الجزاء! $other يعرقل $player.';
  }

  @override
  String pitchComPenaltyAwarded3(String player, String other) {
    return 'احتُسبت ركلة جزاء! $other يعرقل $player في المنطقة.';
  }

  @override
  String pitchComPenaltyAwardedYellow1(String player, String other) {
    return 'ركلة جزاء! $player يسقط و$other ينال إنذارًا.';
  }

  @override
  String pitchComPenaltyAwardedYellow2(String player, String other) {
    return 'ركلة جزاء، وبطاقة صفراء لـ$other بعد الخطأ على $player.';
  }

  @override
  String pitchComPenaltyAwardedYellow3(String player, String other) {
    return 'ركلة جزاء وإنذار! $other يعرقل $player في المنطقة.';
  }

  @override
  String pitchComPenaltyAwardedRed1(String player, String other) {
    return 'ركلة جزاء وبطاقة حمراء! $player يسقط، و$other يُطرد.';
  }

  @override
  String pitchComPenaltyAwardedRed2(String player, String other) {
    return 'ركلة جزاء، و$other يُطرد بسبب الخطأ على $player!';
  }

  @override
  String pitchComPenaltyAwardedRed3(String player, String other) {
    return 'بطاقة حمراء وركلة جزاء! $other يوقف انفراد $player.';
  }

  @override
  String pitchComCorner1(String player) {
    return 'ركنية. $player سينفذها.';
  }

  @override
  String pitchComCorner2(String player) {
    return '$player يرسل الركنية.';
  }

  @override
  String pitchComCorner3(String player) {
    return 'ركنية، و$player يقف أمام الكرة.';
  }

  @override
  String pitchComFreeKick1(String player) {
    return 'ركلة حرة. $player سينفذها.';
  }

  @override
  String pitchComFreeKick2(String player) {
    return 'ركلة حرة في مكان خطير. $player يقف أمام الكرة.';
  }

  @override
  String pitchComFreeKick3(String player) {
    return '$player يستعد لتنفيذ الركلة الحرة.';
  }

  @override
  String pitchComLongThrow1(String player) {
    return 'رمية تماس طويلة! $player يقذفها إلى المنطقة.';
  }

  @override
  String pitchComLongThrow2(String player) {
    return '$player برمية تماس طويلة إلى المنطقة.';
  }

  @override
  String pitchComLongThrow3(String player) {
    return 'ها هي رمية التماس الطويلة من $player.';
  }

  @override
  String pitchComFoulYellow1(String player) {
    return 'بطاقة صفراء لـ$player.';
  }

  @override
  String pitchComFoulYellow2(String player, String other) {
    return '$player ينال إنذارًا بسبب خطأ على $other.';
  }

  @override
  String pitchComFoulYellow3(String player, String other) {
    return 'تدخل متأخر على $other، و$player ينال إنذارًا.';
  }

  @override
  String pitchComFoulSecondYellow1(String player) {
    return 'إنذار ثانٍ! $player يُطرد.';
  }

  @override
  String pitchComFoulSecondYellow2(String player) {
    return '$player ينال إنذارًا ثانيًا ويُطرد.';
  }

  @override
  String pitchComFoulSecondYellow3(String player) {
    return 'صفراء أخرى لـ$player، وهذه حمراء.';
  }

  @override
  String pitchComFoulRed1(String player) {
    return 'بطاقة حمراء! $player يُطرد.';
  }

  @override
  String pitchComFoulRed2(String player, String other) {
    return 'حمراء مباشرة لـ$player بعد الخطأ على $other!';
  }

  @override
  String pitchComFoulRed3(String player) {
    return '$player يرى الحمراء ويجب أن يغادر.';
  }

  @override
  String pitchComOffside1(String player) {
    return 'تسلل. $player انطلق مبكرًا.';
  }

  @override
  String pitchComOffside2(String player) {
    return 'الراية مرفوعة ضد $player.';
  }

  @override
  String pitchComOffside3(String player) {
    return '$player في موقف تسلل.';
  }

  @override
  String get pitchVarCheck => 'مراجعة الفيديو';

  @override
  String get pitchVarConfirmed => 'الهدف مؤكد';

  @override
  String get pitchVarDisallowedOffside => 'الهدف ملغى: تسلل';

  @override
  String get pitchVarDisallowedFoul => 'الهدف ملغى: خطأ';

  @override
  String get pitchComVarCheck1 =>
      'مهلًا. الحكم يضع إصبعه على أذنه: حكم الفيديو يراجع الهدف.';

  @override
  String pitchComVarCheck2(String player) {
    return '$player يحتفل، لكن حكم الفيديو يلقي نظرة.';
  }

  @override
  String get pitchComVarConfirmed1 => 'حكم الفيديو راضٍ. الهدف صحيح!';

  @override
  String pitchComVarConfirmed2(String player) {
    return 'رُوجع وتأكد: $player يحتفظ بهدفه.';
  }

  @override
  String get pitchComVarOffside1 =>
      'لا هدف! حكم الفيديو يجد تسللًا في بناء الهجمة.';

  @override
  String pitchComVarOffside2(String player) {
    return 'أُلغي! حكم الفيديو يجد تسللًا و$player يُحرم.';
  }

  @override
  String get pitchComVarFoul1 =>
      'لا هدف! حكم الفيديو يرصد خطأً في بناء الهجمة.';

  @override
  String pitchComVarFoul2(String player) {
    return 'أُلغي! حكم الفيديو يرصد خطأً و$player يُحرم.';
  }

  @override
  String pitchComSub1(String player, String other) {
    return 'تبديل: دخول $player، خروج $other.';
  }

  @override
  String pitchComSub2(String player, String other) {
    return '$other يفسح المجال لـ$player.';
  }

  @override
  String pitchComSub3(String player, String other) {
    return '$player يدخل بدلًا من $other.';
  }

  @override
  String pitchComSubFill1(String player) {
    return '$player يدخل.';
  }

  @override
  String pitchComSubFill2(String player) {
    return 'تبديل: $player في الملعب.';
  }

  @override
  String pitchComSubFill3(String player) {
    return '$player ينضم إلى المعركة.';
  }

  @override
  String pitchComInjury1(String player) {
    return '$player على الأرض ويحتاج إلى علاج.';
  }

  @override
  String pitchComInjury2(String player) {
    return 'قلق هنا، $player تعرّض لإصابة.';
  }

  @override
  String pitchComInjury3(String player) {
    return 'مخاوف من إصابة $player.';
  }

  @override
  String pitchComGoalScore(String line, int home, int away) {
    return '$line ⁦$home–$away⁩';
  }

  @override
  String get pitchComSomeone => 'لاعب';

  @override
  String pitchComPenaltyAwardedSecondYellow1(String player, String other) {
    return 'ركلة جزاء، وإنذار ثانٍ! $other يُطرد بسبب الخطأ على $player.';
  }

  @override
  String pitchComPenaltyAwardedSecondYellow2(String player, String other) {
    return 'ركلة جزاء! $player يسقط و$other يرى الصفراء الثانية.';
  }

  @override
  String pitchComPenaltyAwardedSecondYellow3(String player, String other) {
    return 'ركلة جزاء! $other يعرقل $player وينال إنذارًا ثانيًا، وهذه حمراء.';
  }

  @override
  String get matchViewChooseTitle => 'كيف تريد المشاهدة؟';

  @override
  String get matchViewChooseHint =>
      'يُحفظ اختيارك للمباراة القادمة. يمكنك التبديل في أي وقت.';

  @override
  String get matchViewPitch => 'تلفاز 2D';

  @override
  String get matchViewPitchBlurb => 'شاهد اللاعبين على أرض الملعب';

  @override
  String get matchViewTimeline => 'المجريات';

  @override
  String get matchViewTimelineBlurb => 'تابع المباراة حدثًا بحدث';

  @override
  String get matchViewSwitchToPitch => 'شاهد بوضع تلفاز 2D';

  @override
  String get matchViewSwitchToTimeline => 'شاهد المجريات';

  @override
  String get matchTabCommentary => 'التعليق';

  @override
  String get matchSubShout => 'تبديل';

  @override
  String matchSubOff(String name) {
    return 'خروج: $name';
  }

  @override
  String matchSubOn(String name) {
    return 'دخول: $name';
  }

  @override
  String get editorFilterToFix => 'يحتاج إلى إصلاح';

  @override
  String get editorNothingToFix => 'لا شيء يحتاج إلى إصلاح هنا.';

  @override
  String get editorPromoteTooltip => 'انقل إلى القائمة';

  @override
  String editorPromoted(String name) {
    return 'نُقل $name إلى القائمة';
  }

  @override
  String get editorPromoteFullTitle => 'القائمة ممتلئة';

  @override
  String editorPromoteFullBody(int max) {
    return 'تضم القائمة $max لاعبًا على الأكثر. اختر اللاعب الذي يعود إلى المجموعة بدلًا منه.';
  }

  @override
  String get editorTrophyGallery => 'اختر من صورك';

  @override
  String get editorTrophyFile => 'اختر ملفًا بدلًا من ذلك';

  @override
  String clubStrengthOf(int stars) {
    return 'قوة النادي: $stars من 5';
  }

  @override
  String get editorClubStrength => 'القوة';

  @override
  String get editorClubStrengthDefault => 'الافتراضي';

  @override
  String editorClubStrengthHelp(int stars) {
    return 'اللاعبون الأفضل ينضمون إلى الأندية الأقوى. الافتراضي: $stars من 5، يحدده دوريه.';
  }

  @override
  String mgrNewsSacked(String nation, String name) {
    return '$nation يقيل $name';
  }

  @override
  String mgrNewsResigned(String nation, String name) {
    return '⁦$nation: $name⁩ يستقيل';
  }

  @override
  String mgrNewsPoached(String nation, String name) {
    return '⁦$nation: $name⁩ يرحل إلى منتخب آخر';
  }

  @override
  String mgrNewsRetired(String nation, String name) {
    return '⁦$nation: $name⁩ يعتزل التدريب';
  }

  @override
  String mgrNewsContractEnd(String nation, String name) {
    return '⁦$nation: $name⁩ يرحل مع انتهاء عقده';
  }

  @override
  String mgrNewsReplacedByPlayer(String nation, String name) {
    return '⁦$nation: $name⁩ يفسح المجال لك';
  }

  @override
  String mgrNewsAppointed(String nation, String name) {
    return '$nation يعيّن $name';
  }

  @override
  String mgrNewsAppointedBody(String nation, String name) {
    return '$name يتولى تدريب $nation.';
  }

  @override
  String pressBeatOpposingManager(String manager) {
    return 'بينك وبين $manager تاريخ. هل لديك ما تقوله عنه؟';
  }

  @override
  String get pressAnswerHitBackAtManager => 'عليه أن يقلق بشأن فريقه.';

  @override
  String get pressAnswerRespectManager => 'أكنّ له احترامًا كبيرًا.';

  @override
  String yMgrTie1(String manager) {
    return '$manager على مقعد الخصم في المباراة القادمة. بينه وبين مدربنا تاريخ، ولا أطيق الانتظار.';
  }

  @override
  String yMgrTie2(String manager) {
    return 'التالي، $manager على مقعد الخصم. هو ومدربنا يعرفان بعضهما منذ زمن.';
  }

  @override
  String yMgrTie3(String manager) {
    return '$manager مجددًا. من الأفضل ألا يحوّل مدربنا هذا إلى مسألة شخصية.';
  }

  @override
  String yMgrTie4(String manager) {
    return 'ها نحن ذا. $manager على الخط، ومدربنا يحاول الفوز بخصومة بدل المباراة.';
  }

  @override
  String get mgrRowLabel => 'المدرب';

  @override
  String mgrRowDetail(int age, String date) {
    return '$age عامًا، منذ $date';
  }

  @override
  String mgrRecordWdl(int won, int drawn, int lost) {
    return '$won فوز، $drawn تعادل، $lost خسارة';
  }

  @override
  String mgrRowRecord(String record) {
    return 'في منصبه: $record';
  }

  @override
  String get mgrTieNeutral => 'لا تاريخ';

  @override
  String get mgrTieRespect => 'احترام';

  @override
  String get mgrTieRival => 'غريم';

  @override
  String get mgrTieGrudge => 'ضغينة';

  @override
  String get mgrTieSuccessor => 'خليفة';

  @override
  String get mgrTieProtege => 'تلميذ';

  @override
  String get mgrTieFormerPlayer => 'لاعب سابق';

  @override
  String get mgrEndSacked => 'أُقيل';

  @override
  String get mgrEndResigned => 'استقال';

  @override
  String get mgrEndPoached => 'رحل إلى منتخب آخر';

  @override
  String get mgrEndRetired => 'اعتزل التدريب';

  @override
  String get mgrEndContractEnd => 'انتهى عقده';

  @override
  String get mgrEndReplacedByPlayer => 'حللت مكانه';

  @override
  String get mgrProfileSpells => 'المسيرة';

  @override
  String mgrProfileSpellNow(String nation, String from) {
    return '$nation، منذ $from';
  }

  @override
  String mgrProfileSpellRange(String nation, String from, String to) {
    return '$nation، من $from إلى $to';
  }

  @override
  String mgrProfileSpellEnded(String range, String reason) {
    return '$range، $reason';
  }

  @override
  String get mgrProfileRecordVsYou => 'سجله أمامك';

  @override
  String get mgrProfileNoMeetings => 'لم تلتقيا';

  @override
  String get mgrProfileReputation => 'السمعة';

  @override
  String get mgrProfileAge => 'العمر';

  @override
  String get mgrProfileAppointed => 'التعيين';

  @override
  String get mgrProfileStyle => 'الأسلوب';

  @override
  String get mgrProfileTie => 'بينكما';

  @override
  String mgrPreviewLine(String name) {
    return 'مدربهم: $name';
  }

  @override
  String mgrDossierStyle(String style) {
    return 'أسلوب المدرب: $style';
  }

  @override
  String mgrDossierRecord(String record) {
    return 'سجلك أمامه: $record';
  }

  @override
  String get mgrStylePossession => 'استحواذ';

  @override
  String get mgrStyleHighPress => 'ضغط عالٍ';

  @override
  String get mgrStyleDefensive => 'دفاعي';

  @override
  String get mgrStyleDirect => 'مباشر';

  @override
  String get mgrStyleCounter => 'هجمات مرتدة';

  @override
  String get mgrStyleFlair => 'مهاري';

  @override
  String get mgrStylePhysical => 'بدني';

  @override
  String get mgrStyleBalanced => 'متوازن';

  @override
  String get mgrListTitle => 'المدربون';

  @override
  String get mgrListCurrent => 'الحاليون';

  @override
  String get mgrListRecentMoves => 'التنقلات الأخيرة';

  @override
  String get mgrListFilterAll => 'الكل';

  @override
  String get mgrListSortReputation => 'السمعة';

  @override
  String get mgrListSortName => 'الاسم';

  @override
  String get mgrListEmptyMoves => 'لا تغييرات في العامين الأخيرين.';

  @override
  String get mgrListEmptyCurrent => 'يظهر المدربون بعد انتقال الموسم التالي.';

  @override
  String get editorSectionManagers => 'المدربون';

  @override
  String get editorAboutManagers => 'من يتولى تدريب كل منتخب في اليوم الأول';

  @override
  String get editorManagersHint => 'يُختار عند بدء المسيرة';

  @override
  String get editorManagerName => 'اسم المدرب';

  @override
  String get editorManagerNationality => 'الجنسية';

  @override
  String editorIssueManagerName(int max) {
    return 'يحتاج المدرب إلى اسم من 1 إلى $max حرفًا يمكن للعبة عرضه';
  }

  @override
  String get editorIssueManagerNationality => 'اختر جنسية للمدرب من القائمة';

  @override
  String get shareButton => 'مشاركة';

  @override
  String get shareSheetTitle => 'شارك كصورة';

  @override
  String get shareFormatSquare => 'مربع';

  @override
  String get shareFormatStory => 'قصة';

  @override
  String get shareFailed => 'تعذّر إنشاء الصورة.';

  @override
  String get shareSaveToPhotos => 'احفظ في الصور';

  @override
  String get shareSavedToPhotos => 'حُفظت في الصور';

  @override
  String get sharePhotosDenied =>
      'غير مسموح لـFNM بالإضافة إلى صورك. يمكنك السماح بذلك من الإعدادات.';

  @override
  String get editorCountryAll => 'كل الدول';

  @override
  String get editorCountryFilterTitle => 'التصفية حسب الدولة';

  @override
  String get shareCabinetBig => 'شارك ألقابي';

  @override
  String yExitProud0(String competition) {
    return 'كان مشوارًا غير متوقع في $competition ونتيجة رائعة في النهاية. فخور بالشباب.';
  }

  @override
  String yExitProud1(String competition) {
    return 'لم يمنحنا أحد فرصة في $competition. ذهبنا أبعد مما تجرأ أحد على الحلم. شكرًا يا شباب.';
  }

  @override
  String yExitProud2(String competition) {
    return 'خارج $competition، لكن يا لها من رحلة. هذا الفريق جعل البلاد كلها تؤمن. فخور.';
  }

  @override
  String yExitProud3(String competition) {
    return 'لم أتوقع أن نتجاوز المجموعة في $competition. كل ما بعد ذلك كان مكسبًا إضافيًا. إلى الأمام وإلى الأعلى.';
  }

  @override
  String yExitProud4(String competition) {
    return 'ذهبنا إلى $competition آملين في نقطة أو اثنتين وعدنا بمشوار في الأدوار الإقصائية. بطولة جيدة.';
  }

  @override
  String yExitProud5(String competition) {
    return 'أبعد مما قالت التوقعات في $competition. هذه خطوة إلى الأمام، ببساطة.';
  }

  @override
  String yExitProud6(String competition) {
    return 'خارج $competition، ويؤلم قليلًا. لكن بصراحة: لم يتوقع أحد وصولنا إلى هنا.';
  }

  @override
  String yExitProud7(String competition) {
    return 'حسنًا، خرجنا من $competition. لا يزال أفضل مما حققناه منذ سنوات. سأقبل ذلك.';
  }

  @override
  String yExitProud8(String competition) {
    return 'لا لقب من $competition، ولم يكن هناك لقب أصلًا. المشوار الجيد مشوار جيد. والآن كرروه.';
  }

  @override
  String get yReactionPride0 => 'فخور بكل واحد منهم.';

  @override
  String get yReactionPride1 => 'يا له من مشوار. شكرًا يا شباب.';

  @override
  String get yReactionPride2 => 'لم يتوقع أحد هذا. تذكروا ذلك.';

  @override
  String get yReactionPride3 => 'إلى الأمام وإلى الأعلى.';

  @override
  String get yReactionPride4 => 'كله مكسب إضافي. استمتعوا.';

  @override
  String get yReactionPride5 => 'أفضل مما توقع أي أحد. بطولة جيدة.';

  @override
  String get yReactionPride6 => 'خرجنا، لكن دون إحراج. هذا عادل.';

  @override
  String get yReactionPride7 => 'تأهل الفريق الأفضل. ومع ذلك شرّفنا أنفسنا.';

  @override
  String get yReactionPride8 => 'لا ننجرف. لكن نعم، مشوار جيد.';

  @override
  String yExitAccepted0(String competition) {
    return 'خارج $competition، تقريبًا حيث كنا سننتهي دائمًا. فخور لأنهم حاولوا.';
  }

  @override
  String yExitAccepted1(String competition) {
    return 'انتهت $competition بالنسبة لنا. نافسنا الفرق الكبيرة. ارفعوا رؤوسكم يا شباب.';
  }

  @override
  String yExitAccepted2(String competition) {
    return 'خارج $competition. على الورق كانت هذه دائمًا النهاية المرجحة. تعلّموا وحاولوا مجددًا.';
  }

  @override
  String yExitAccepted3(String competition) {
    return 'مشوارنا في $competition ينتهي حيث قال التصنيف. لا عيب في ذلك.';
  }

  @override
  String yExitAccepted4(String competition) {
    return 'خارج $competition، كما توقع معظمنا. ليست كارثة، وليست مفاجأة أيضًا.';
  }

  @override
  String yExitAccepted5(String competition) {
    return 'كانت $competition خطوة أبعد من قدرة هذه القائمة. الفجوة حقيقية. حان وقت سدّها.';
  }

  @override
  String get yReactionAcceptance0 => 'قدموا كل شيء. هذا كل ما يمكن طلبه.';

  @override
  String get yReactionAcceptance1 => 'ارفعوا رؤوسكم. سنعود.';

  @override
  String get yReactionAcceptance2 => 'مؤلم، لكنهم لم يخذلونا.';

  @override
  String get yReactionAcceptance3 => 'تقريبًا ما توقعناه، بصراحة.';

  @override
  String get yReactionAcceptance4 => 'تأهلت الفرق الأفضل. هذه كرة القدم.';

  @override
  String get yReactionAcceptance5 => 'خيبة أمل، لا غضب.';

  @override
  String get yReactionAcceptance6 =>
      'باهتة قليلًا، إن كنت صادقًا. مع ذلك، لا مفاجآت.';

  @override
  String get yReactionAcceptance7 => 'لسنا هناك بعد. الجميع يعرف ذلك.';

  @override
  String get yReactionAcceptance8 =>
      'المستوى نفسه كالمرة الماضية. نحتاج إلى خطوة للأمام في الدورة القادمة.';

  @override
  String get sponsorIndustryExtraSportswear => 'الملابس الرياضية';

  @override
  String get sponsorIndustryExtraAirline => 'شركة طيران';

  @override
  String get sponsorIndustryExtraRailway => 'السكك الحديدية';

  @override
  String get sponsorIndustryExtraHotels => 'سلسلة فنادق';

  @override
  String get sponsorIndustryExtraCoffee => 'سلسلة مقاهٍ';

  @override
  String get sponsorIndustryExtraChocolate => 'الشوكولاتة';

  @override
  String get sponsorIndustryExtraMineralWater => 'المياه المعدنية';

  @override
  String get sponsorIndustryExtraPharmacy => 'سلسلة صيدليات';

  @override
  String get sponsorIndustryExtraFashion => 'الأزياء';

  @override
  String get sponsorIndustryExtraWatches => 'صناعة الساعات';

  @override
  String get sponsorIndustryExtraElectronics => 'الإلكترونيات';

  @override
  String get sponsorIndustryExtraSoftware => 'البرمجيات';

  @override
  String get sponsorIndustryExtraStreaming => 'خدمة بث';

  @override
  String get sponsorIndustryExtraSocialNetwork => 'شبكة اجتماعية';

  @override
  String get sponsorIndustryExtraFurniture => 'الأثاث';

  @override
  String get sponsorIndustryExtraTyres => 'الإطارات';

  @override
  String get sponsorIndustryExtraShipping => 'شركة شحن بحري';

  @override
  String get sponsorIndustryExtraLottery => 'اليانصيب';

  @override
  String get sponsorIndustryExtraTourism => 'هيئة السياحة';

  @override
  String get sponsorIndustryExtraCosmetics => 'مستحضرات التجميل';

  @override
  String get sponsorIndustryExtraPetFood => 'طعام الحيوانات الأليفة';

  @override
  String get sponsorIndustryExtraBakery => 'المخابز';

  @override
  String get sponsorIndustryExtraSupermarket => 'سوبرماركت';

  @override
  String get sponsorIndustryExtraSportsNutrition => 'التغذية الرياضية';

  @override
  String get sponsorIndustryExtraWine => 'العصائر';

  @override
  String get sponsorIndustryExtraTea => 'الشاي';

  @override
  String get sponsorIndustryExtraRealEstate => 'العقارات';

  @override
  String get sponsorIndustryExtraFitness => 'الأندية الرياضية';

  @override
  String get sponsorIndustryExtraNewspaper => 'صحيفة';

  @override
  String mgrDetailCurrentJob(String nation) {
    return 'الوظيفة الحالية: $nation';
  }

  @override
  String get mgrDetailFree => 'عاطل عن العمل';

  @override
  String get mgrDetailMatches => 'المباريات';

  @override
  String get mgrDetailTrophies => 'الألقاب';

  @override
  String get mgrDetailWinRate => 'نسبة الفوز';

  @override
  String get mgrDetailRecord => 'السجل';

  @override
  String get mgrDetailNationsLed => 'المنتخبات التي قادها';

  @override
  String get mgrDetailInCharge => 'في المنصب';

  @override
  String get mgrDetailNoSpells => 'لا وظائف مع منتخبات بعد.';

  @override
  String get mgrDetailNotFound => 'لم يُعثر على المدرب.';

  @override
  String get mgrDetailBackground => 'الخلفية';

  @override
  String get mgrOriginFresh => 'مدرب محترف';

  @override
  String get mgrOriginExAssistant => 'مدرب مساعد سابق';

  @override
  String mgrNewsSeeManager(String name) {
    return 'الملف: $name';
  }

  @override
  String get mgrChangesTitle => 'تغييرات المدربين';

  @override
  String mgrChangesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count تغيير',
      many: '$count تغييرًا',
      few: '$count تغييرات',
      two: 'تغييران',
      one: 'تغيير واحد',
      zero: 'لا تغييرات',
    );
    return '$_temp0';
  }

  @override
  String mgrChangesLeftFor(String nation) {
    return 'رحل إلى $nation';
  }

  @override
  String get mgrChangesAppointed => 'عُيّن';

  @override
  String get mgrChangesVacant => 'شاغر';

  @override
  String get editorNameNotAllowed => 'هذا الاسم غير مسموح.';

  @override
  String editorIssueNameNotAllowed(String name) {
    return '«$name» غير مسموح';
  }

  @override
  String get matchWeatherPlaysHeavyRain =>
      'مطر غزير: التسديدات والعرضيات أقل دقة، وانزلاقات أكثر';

  @override
  String get matchWeatherPlaysStorm =>
      'عاصفة رعدية: التسديدات والعرضيات أقل دقة، وانزلاقات أكثر';

  @override
  String get matchWeatherPlaysSnow => 'ثلج: لعب أبطأ، والتمرير أصعب قليلًا';

  @override
  String get matchWeatherPlaysFrost =>
      'ملعب متجمد: لعب أبطأ، والتمرير أصعب قليلًا';

  @override
  String get matchWeatherPlaysGale =>
      'رياح قوية: الكرات الطويلة والعرضيات متقلبة، والتسديد من بعيد أصعب';

  @override
  String get matchWeatherPlaysFog => 'ضباب: التسديد من بعيد أصعب';

  @override
  String get matchWeatherPlaysHaze =>
      'ضباب حراري: أحر من المعتاد، ستتعب الأرجل أبكر';

  @override
  String get pitchComKickOffHeavyRain =>
      'انطلقنا تحت مطر غزير. الكرة ستنزلق على هذه الأرضية.';

  @override
  String get pitchComKickOffStorm =>
      'البداية في عاصفة رعدية. الثبات على الأرض سيكون غادرًا.';

  @override
  String get pitchComKickOffSnow =>
      'انطلقنا تحت الثلج. ستكون مباراة بطيئة وحذرة.';

  @override
  String get pitchComKickOffFrost =>
      'ليلة صقيع وأرضية صلبة. التمرير لن يكون سهلًا.';

  @override
  String get pitchComKickOffFrostDay =>
      'شمس شتوية منخفضة وأرضية صلبة متجمدة. الكرة ستنزلق.';

  @override
  String get pitchComKickOffGale =>
      'البداية في رياح قوية. الكرات الطويلة ستضل طريقها.';

  @override
  String get pitchComKickOffFog =>
      'البداية في ضباب كثيف. لن يسجل أحد من بعيد بسهولة.';

  @override
  String get pitchComKickOffHaze =>
      'البداية في ضباب حراري. الأرجل ستتعب مبكرًا اليوم.';

  @override
  String get matchOwnGoal => 'هدف عكسي';

  @override
  String get matchGoalOwnGoal => 'ع';

  @override
  String get matchGoalVarOffside => 'الفيديو: تسلل';

  @override
  String get matchGoalVarFoul => 'الفيديو: خطأ';

  @override
  String pitchComOwnGoal1(String defender) {
    return 'هدف عكسي! $defender يحولها في شباكه.';
  }

  @override
  String pitchComOwnGoal2(String defender, String shooter) {
    return 'محاولة $shooter ترتطم بـ$defender بقسوة وتدخل.';
  }

  @override
  String pitchComOwnGoal3(String defender) {
    return 'كارثة لـ$defender، الذي يسكنها شباك حارسه.';
  }

  @override
  String pitchComBigSave1(String keeper, String player) {
    return 'يا له من تصدٍّ! $keeper يحرم $player من مسافة قريبة.';
  }

  @override
  String pitchComBigSave2(String keeper) {
    return 'تصدٍّ رائع من $keeper!';
  }

  @override
  String pitchComBigSave3(String keeper, String player) {
    return 'بدا $player متأكدًا من التسجيل، لكن $keeper يمنعها بطريقة ما.';
  }

  @override
  String matchTimelineWoodwork(String name) {
    return '$name أصاب الخشبات';
  }

  @override
  String matchTimelineBigSave(String name) {
    return 'تصدٍّ كبير من $name';
  }

  @override
  String get matchChartXg => 'الأهداف المتوقعة خلال المباراة';

  @override
  String get matchChartMomentum => 'من كان مسيطرًا';

  @override
  String get editorDemoteTooltip => 'انقل إلى المجموعة';

  @override
  String editorDemoted(String name) {
    return 'نُقل $name إلى المجموعة';
  }

  @override
  String get profileTabOverview => 'نظرة عامة';

  @override
  String get profileTabStats => 'الإحصاءات';

  @override
  String get profileTabCareer => 'المسيرة';

  @override
  String get profileTabVsYou => 'أمامك';

  @override
  String get playerStatFitness => 'اللياقة';

  @override
  String get settingsAboutProtected =>
      'اللعبة وشيفرتها ومحتواها محمية بحقوق النشر.';

  @override
  String get matchTabSummary => 'الملخص';

  @override
  String get matchSummaryOtherMatches => 'مباريات أخرى';

  @override
  String get matchSummaryLive => 'مباشر';

  @override
  String get matchSummaryHalfTimeMark => 'ش1';

  @override
  String get matchSummaryFullTimeMark => 'نهاية';

  @override
  String get matchSummaryExtraTimeMark => 'ب.إ';

  @override
  String get matchStatMinutes => 'الدقائق';

  @override
  String get matchStatSaves => 'التصديات';

  @override
  String editorWebTitle(String address) {
    return 'عدّل على حاسوب: $address';
  }

  @override
  String get editorWebAbout =>
      'صدّر قاعدة بياناتك، افتحها في المتصفح، نزّلها مجددًا واستوردها هنا.';

  @override
  String get editorWebAnother => 'خيار آخر';

  @override
  String get editorMerge => 'ادمج قاعدة بيانات أخرى';

  @override
  String get editorMergeAbout => 'خذ ما غيّره شخص آخر في نسخته إلى هذه النسخة.';

  @override
  String get editorHistory => 'السجل';

  @override
  String get editorHistoryAbout =>
      'النسخ المحفوظة من قاعدة البيانات هذه. عُد إلى أي منها.';

  @override
  String get editorMergeFromTitle => 'الدمج من';

  @override
  String get editorMergeFromFile => 'ملف قاعدة بيانات';

  @override
  String get editorMergeFromFileAbout => 'اختر ملف .fnmdb شاركه أحدهم معك.';

  @override
  String get editorMergeFromDevice => 'على هذا الجهاز';

  @override
  String get editorMergeComparing => 'جارٍ مقارنة قواعد البيانات';

  @override
  String get editorMergeNothing =>
      'لا شيء للدمج. قاعدة بياناتك تضم بالفعل كل تغييرات تلك القاعدة.';

  @override
  String get editorMergeFailed => 'تعذّر دمج قواعد البيانات.';

  @override
  String editorMergeReviewTitle(String name) {
    return 'التغييرات من $name';
  }

  @override
  String editorMergeFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count تغيير للمراجعة',
      many: '$count تغييرًا للمراجعة',
      few: '$count تغييرات للمراجعة',
      two: 'تغييران للمراجعة',
      one: 'تغيير واحد للمراجعة',
      zero: 'لا تغييرات للمراجعة',
    );
    return '$_temp0';
  }

  @override
  String editorMergeConflicts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count تعارض',
      many: '$count تعارضًا',
      few: '$count تعارضات',
      two: 'تعارضان',
      one: 'تعارض واحد',
      zero: 'لا تعارضات',
    );
    return '$_temp0';
  }

  @override
  String get editorMergeConflictsOnly => 'التعارضات فقط';

  @override
  String get editorMergeNoConflicts =>
      'لا تعارضات. كل تغيير جديد على قاعدة بياناتك.';

  @override
  String get editorMergeAll => 'الكل';

  @override
  String get editorMergeNone => 'لا شيء';

  @override
  String editorMergeTake(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'خذ $count تغيير',
      many: 'خذ $count تغييرًا',
      few: 'خذ $count تغييرات',
      two: 'خذ تغييرين',
      one: 'خذ تغييرًا واحدًا',
      zero: 'لا تأخذ أي تغيير',
    );
    return '$_temp0';
  }

  @override
  String get editorMergeApply => 'تطبيق';

  @override
  String get editorMergeYours => 'لك';

  @override
  String get editorMergeTheirs => 'لهم';

  @override
  String get editorMergeNew => 'جديد';

  @override
  String get editorMergeConflict => 'تعارض';

  @override
  String get editorMergeGameValue => 'كما في اللعبة';

  @override
  String get editorMergeNotHere => 'ليس في قاعدة البيانات هذه';

  @override
  String editorMergeSquadOf(String nation) {
    return 'قائمة $nation';
  }

  @override
  String editorMergePoolOf(String nation) {
    return 'مجموعة $nation';
  }

  @override
  String get editorMergePlace => 'التنقلات';

  @override
  String editorMergeNames(int first, int sur) {
    return '$first اسمًا أول، $sur اسم عائلة';
  }

  @override
  String editorMerged(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'دُمج $count تغيير',
      many: 'دُمج $count تغييرًا',
      few: 'دُمجت $count تغييرات',
      two: 'دُمج تغييران',
      one: 'دُمج تغيير واحد',
      zero: 'لم يُدمج شيء',
    );
    return '$_temp0';
  }

  @override
  String get editorMergeTabOverview => 'نظرة عامة';

  @override
  String get editorMergeTabNames => 'الأسماء';

  @override
  String get editorMergeTabPress => 'الصحافة وY';

  @override
  String get editorMergeEveryChange => 'كل التغييرات';

  @override
  String editorMergeNewCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count جديد',
      many: '$count جديدًا',
      few: '$count جديدة',
      two: 'جديدان',
      one: 'جديد واحد',
      zero: 'لا جديد',
    );
    return '$_temp0';
  }

  @override
  String get editorHistorySave => 'احفظ نسخة';

  @override
  String get editorHistorySaveTitle => 'احفظ هذه النسخة';

  @override
  String get editorHistoryNameHint => 'الاسم (اختياري)';

  @override
  String get editorHistorySaved => 'حُفظت النسخة';

  @override
  String get editorHistoryEmpty =>
      'لا نسخ محفوظة بعد. تُحفظ نسخة قبل كل دمج واستعادة، وحين تعود إلى قاعدة البيانات هذه بعد انقطاع.';

  @override
  String get editorHistoryKeep =>
      'تُحفظ آخر 30 نسخة تلقائية. النسخ التي تحفظها تبقى حتى تحذفها.';

  @override
  String get editorHistorySession => 'عند بدء التعديل';

  @override
  String editorHistoryBeforeMerge(String name) {
    return 'قبل دمج $name';
  }

  @override
  String get editorHistoryBeforeRestore => 'قبل الاستعادة';

  @override
  String get editorHistoryManual => 'نسخة محفوظة';

  @override
  String get editorHistoryAuto => 'تلقائية';

  @override
  String editorHistoryDiff(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count اختلاف عن الحالية',
      many: '$count اختلافًا عن الحالية',
      few: '$count اختلافات عن الحالية',
      two: 'اختلافان عن الحالية',
      one: 'اختلاف واحد عن الحالية',
      zero: 'مطابقة للحالية',
    );
    return '$_temp0';
  }

  @override
  String get editorHistoryRestore => 'استعادة';

  @override
  String get editorHistoryRestoreTitle => 'استعادة هذه النسخة؟';

  @override
  String get editorHistoryRestoreBody =>
      'تعود قاعدة البيانات إلى هذه النسخة. تُحفظ حالتها الحالية في السجل أولًا.';

  @override
  String get editorHistoryRestored => 'استُعيدت النسخة';

  @override
  String get editorHistoryFailed => 'لم ينجح ذلك. حاول مجددًا من فضلك.';

  @override
  String get editorHistoryRenameTitle => 'إعادة تسمية النسخة';

  @override
  String get editorHistoryDeleteTitle => 'حذف هذه النسخة؟';

  @override
  String get editorHistoryDeleteBody =>
      'تُحذف من السجل. قاعدة البيانات نفسها لا تتغير.';

  @override
  String get financesTabDepartments => 'الأقسام';

  @override
  String get financesTabFacilities => 'المنشآت';

  @override
  String get financesInvestedSoFar => 'المستثمر حتى الآن';

  @override
  String get tacticsQuickBest => 'الأفضل';

  @override
  String get tacticsQuickPrevious => 'السابقة';

  @override
  String get assistantAskShort => 'المساعد';

  @override
  String get editorRankingTitle => 'التصنيف العالمي';

  @override
  String editorRankingPlace(int rank) {
    return '#$rank';
  }

  @override
  String get editorRankingAuto => 'تلقائي';

  @override
  String editorRankingAutoPlace(int rank) {
    return 'تلقائي (#$rank)';
  }

  @override
  String get editorRankingAbout =>
      'المركز الذي يبدأ منه هذا المنتخب مسيرة جديدة في التصنيف العالمي. التلقائي يتبع قوة قائمته.';

  @override
  String editorRankingHint(int min, int max) {
    return 'من $min إلى $max';
  }

  @override
  String editorRankingOf(String nation) {
    return '$nation: التصنيف العالمي';
  }

  @override
  String editorIssueRanking(int min, int max) {
    return 'حدد مركزًا في التصنيف العالمي من $min إلى $max.';
  }

  @override
  String get editorRegionWorldwide => 'عالميًا';

  @override
  String get editorRegionNone => 'لا شيء هنا لهذه المنطقة.';

  @override
  String get nationTabResults => 'النتائج';

  @override
  String get nationTabHistory => 'التاريخ';

  @override
  String get nationTabStadiums => 'الملاعب';

  @override
  String get nationStatRanking => 'التصنيف';

  @override
  String get nationStatOverall => 'التقييم العام';

  @override
  String get nationFactsTitle => 'حقائق';

  @override
  String get nationFactAgainstYou => 'سجلك أمامهم (ف-ت-خ)';

  @override
  String nationFactBiggestWin(String opponent, String year) {
    return 'أكبر فوز ($opponent، $year)';
  }

  @override
  String get nationFactHomeUnbeaten => 'مباريات على أرضه دون هزيمة على التوالي';

  @override
  String nationFactTitleDrought(String year) {
    return 'سنوات منذ آخر لقب ($year)';
  }

  @override
  String get nationFactNoTitles => 'لا يزال ينتظر لقبه الأول';

  @override
  String nationFactRecordScorer(String name) {
    return 'أهداف الهداف التاريخي، $name';
  }

  @override
  String nationFactRankClimb(int rank, String year) {
    return 'مراكز صعدها في دورة واحدة، حتى #$rank في $year';
  }

  @override
  String nationFactWorldFinals(String year) {
    return 'مرات بلوغ نهائيات بطولة العالم منذ $year';
  }

  @override
  String nationBestRankYear(int rank, String year) {
    return 'الأفضل: #$rank ($year)';
  }

  @override
  String get nationLikelyEleven => 'التشكيلة المتوقعة';

  @override
  String get nationBestYoung => 'أفضل لاعب تحت 21';

  @override
  String get nationWhereTheyPlay => 'أين يلعبون';

  @override
  String get nationOtherCountries => 'دول أخرى';

  @override
  String get nationBiggestWinYou => 'أكبر فوز لك';

  @override
  String nationAllMeetings(int count) {
    return 'كل المواجهات ($count)';
  }

  @override
  String get nationUpcoming => 'القادمة';

  @override
  String get nationLastResults => 'آخر النتائج';

  @override
  String nationAllMatches(int count) {
    return 'كل المباريات ($count)';
  }

  @override
  String get nationShowMore => 'عرض المزيد';

  @override
  String get nationHostingRecord => 'سجل الاستضافة';

  @override
  String get nationNeverHosted => 'لم يستضف أي نهائيات بعد';

  @override
  String get nationHostChampions => 'البطل';

  @override
  String get nationHostRunnersUp => 'الوصيف';

  @override
  String get nationHostThird => 'الثالث';

  @override
  String get nationCoHosts => 'مستضيفون مشاركون';

  @override
  String get nationNoStadiums => 'لا ملاعب مسجلة';

  @override
  String get nationManageStadiums => 'إدارة الملاعب';

  @override
  String get scheduleHome => 'على أرضنا';

  @override
  String get scheduleAway => 'خارج أرضنا';

  @override
  String scheduleGroupTag(String name) {
    return 'المجموعة $name';
  }

  @override
  String get scheduleFilterMine => 'مبارياتي';

  @override
  String get scheduleFilterCompetitions => 'المسابقات';

  @override
  String get scheduleFilterDraws => 'القرعات';

  @override
  String scheduleDrawOf(String competition) {
    return 'قرعة $competition';
  }

  @override
  String get scheduleDrawCeremony => 'حفل القرعة';

  @override
  String get scheduleNoDraws => 'لا قرعات قادمة';

  @override
  String hubCallUpClosesIn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'يُغلق الاستدعاء بعد $count يوم',
      many: 'يُغلق الاستدعاء بعد $count يومًا',
      few: 'يُغلق الاستدعاء بعد $count أيام',
      two: 'يُغلق الاستدعاء بعد يومين',
      one: 'يُغلق الاستدعاء غدًا',
      zero: 'يُغلق الاستدعاء اليوم',
    );
    return '$_temp0';
  }

  @override
  String hubNextWindowLabel(String month, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مباراة أخرى',
      many: '$count مباراة أخرى',
      few: '$count مباريات أخرى',
      two: 'مباراتان أخريان',
      one: 'مباراة أخرى واحدة',
      zero: 'لا مباريات أخرى',
    );
    return '$month: $_temp0';
  }

  @override
  String get careerManagerAge => 'العمر';

  @override
  String managerAgeRange(int min, int max) {
    return 'من $min إلى $max';
  }

  @override
  String managerNameAge(String name, int age) {
    return '$name ($age)';
  }

  @override
  String get managerSuccession => 'المجلس يسأل عن خطط الخلافة.';

  @override
  String get managerAgePromptTitle => 'كم عمر مدربك؟';

  @override
  String get managerAgePromptBody =>
      'لا عمر لمدربك في هذا الحفظ بعد. حدده مرة واحدة وسيظهر بجانب اسمك. لا يغيّر شيئًا في اللعبة.';

  @override
  String get managerAgePromptSet => 'حدد العمر';

  @override
  String get managerAgePromptSkip => 'تخطٍّ';

  @override
  String mgrNewsRetiredAge(String nation, String name, int age) {
    return '⁦$nation: $name⁩ ($age) يعتزل التدريب';
  }

  @override
  String get editorManagerAge => 'العمر';

  @override
  String get editorManagerAgeHint => 'فارغ: تختار اللعبة عمرًا';

  @override
  String editorIssueManagerAge(int min, int max) {
    return 'يجب أن يكون عمر المدرب من $min إلى $max.';
  }

  @override
  String pressFloor(int index, int total) {
    return 'الكلمة لك · ⁦$index/$total⁩';
  }

  @override
  String pressTickerStanding(String code, int points, String place) {
    String _temp0 = intl.Intl.pluralLogic(
      points,
      locale: localeName,
      other: '$points نقطة',
      many: '$points نقطة',
      few: '$points نقاط',
      two: 'نقطتان',
      one: 'نقطة واحدة',
      zero: '$points نقطة',
    );
    return '$code $_temp0 · $place';
  }

  @override
  String get pressAfterTitle => 'بعد المؤتمر';

  @override
  String get pressTileMorale => 'المعنويات';

  @override
  String get pressTilePress => 'الصحافة';

  @override
  String get pressPromiseHeading => 'وعدت بـ';

  @override
  String get pressPromiseWinNext => 'فوز في المباراة القادمة.';

  @override
  String get pressPromiseJob => 'وظيفتك على المحك في المباريات الثلاث القادمة.';

  @override
  String get pressPromiseJudgedCampaign => 'يحكم المجلس عليه حين تُحسم الحملة.';

  @override
  String get pressPromiseJudgedMatch => 'يُحكم عليه بنتيجة المباراة القادمة.';

  @override
  String get hubEventWatchEuroPlayoffDraw => 'شاهد قرعة الملحق';

  @override
  String get hubEventWatchEuroPlayoffs => 'شاهد الملحق';

  @override
  String get hubCallUpPlayoffs => 'استدعِ لاعبي الملحق';

  @override
  String compPlayoffs(String competition) {
    return 'ملحق $competition';
  }

  @override
  String newsEuroPlayoffPathTitle(String cup, String path) {
    return 'ملحق $cup: المسار $path';
  }

  @override
  String newsEuroPlayoffPathBodyHome(String opponent) {
    return 'نصف نهائي من مباراة واحدة على أرضك أمام $opponent في مارس، ثم نهائي من مباراة واحدة على مقعد في النهائيات.';
  }

  @override
  String newsEuroPlayoffPathBodyAway(String opponent) {
    return 'نصف نهائي من مباراة واحدة خارج أرضك أمام $opponent في مارس، ثم نهائي من مباراة واحدة على مقعد في النهائيات.';
  }

  @override
  String get euroPlayoffDrawTitle => 'قرعة الملحق';

  @override
  String get euroPlayoffIntro =>
      'أول فريقين في كل مجموعة تصفيات متأهلان. المقاعد الأخيرة تُحسم في مسارات ملحق من أربعة فرق، مسار لكل دوري في كأس الأمم: نصف نهائي من مباراة واحدة على أرض الأعلى تصنيفًا في مارس، ثم نهائي من مباراة واحدة.';

  @override
  String euroPlayoffPath(String path) {
    return 'المسار $path';
  }

  @override
  String get euroPlayoffYourPath => 'مسارك';

  @override
  String euroPlayoffSemi(int number) {
    return 'نصف النهائي $number';
  }

  @override
  String euroPlayoffFinalHost(int number) {
    return 'النهائي، يستضيفه الفائز في نصف النهائي $number';
  }

  @override
  String euroPlayoffFinalPending(int first, int second) {
    return 'الفائز في نصف النهائي $first ضد الفائز في نصف النهائي $second';
  }

  @override
  String euroPlayoffWinnerToGroup(String group) {
    return 'الفائز يذهب إلى المجموعة $group';
  }

  @override
  String euroPlayoffWinnerPlaceholder(String path) {
    return 'الفائز في المسار $path';
  }

  @override
  String euroPlayoffYourGroupIfWin(String path, String group) {
    return 'مجموعتك إن فزت بالمسار $path: المجموعة $group';
  }

  @override
  String get euroPlayoffBracketHeading => 'الملحق';

  @override
  String get wcPlayoffIntro =>
      'متصدرو المجموعات الاثنتي عشرة متأهلون. المقاعد الأوروبية الأخيرة تُحسم في مسارات ملحق من أربعة فرق: أفضل الوصفاء وأفضل متصدري مجموعات كأس الأمم ممن لم يتأهلوا، بنصف نهائي من مباراة واحدة على أرض الأعلى تصنيفًا في مارس، ثم نهائي من مباراة واحدة.';

  @override
  String get icPlayoffIntro =>
      'ستة فرق من خمسة اتحادات قارية على المقعدين الأخيرين. الأعلى تصنيفًا ينتظران في نهائيي المسارين، والأربعة الآخرون يلعبون نصف النهائي، وكل المباريات تُلعب في البلد المستضيف في مارس.';

  @override
  String get icPlayoffSeeded => 'متأهل مباشرة إلى نهائي المسار';

  @override
  String icPlayoffFinalPending(String nation) {
    return '$nation ضد الفائز في نصف النهائي';
  }

  @override
  String wcPlaceholderUefa(String path) {
    return 'الفائز في المسار الأوروبي $path';
  }

  @override
  String wcPlaceholderIc(String path) {
    return 'الفائز في المسار العابر للقارات $path';
  }

  @override
  String newsIcPlayoffTitle(String path) {
    return 'الملحق العابر للقارات: المسار $path';
  }

  @override
  String newsIcPlayoffBodySemi(String opponent) {
    return 'نصف نهائي من مباراة واحدة أمام $opponent في مارس، في البلد المستضيف، ثم نهائي المسار على مقعد في النهائيات.';
  }

  @override
  String newsIcPlayoffBodyBye(String first, String second) {
    return 'متأهل مباشرة إلى نهائي المسار في مارس، في البلد المستضيف، أمام الفائز في مباراة $first ضد $second.';
  }

  @override
  String newsCafPlayoffTitle(String opponent) {
    return 'الملحق الأفريقي: نصف النهائي أمام $opponent';
  }

  @override
  String get newsCafPlayoffBody =>
      'أفضل أربعة وصفاء في مجموعات أفريقيا يلتقون في نوفمبر لدى مستضيف بطولة أفريقيا: نصف نهائي من مباراة واحدة، ثم النهائي. الفائز يذهب إلى الملحق العابر للقارات.';

  @override
  String newsAfcFourthRoundTitle(String group) {
    return 'الدور الرابع الآسيوي: المجموعة $group';
  }

  @override
  String newsAfcFourthRoundBody(String first, String second) {
    return 'جولة واحدة من المباريات في نوفمبر أمام $first و$second. متصدر المجموعة يتأهل؛ والوصيف يلعب دورًا خامسًا من مباراتين على مقعد في الملحق العابر للقارات.';
  }

  @override
  String newsAfcFifthRoundTitle(String opponent) {
    return 'الدور الخامس الآسيوي: $opponent ذهابًا وإيابًا';
  }

  @override
  String get newsAfcFifthRoundBody =>
      'ذهابًا وإيابًا في نوفمبر. الفائز بمجموع المباراتين يذهب إلى الملحق العابر للقارات؛ وإن تعادلا بعد الإياب، يُلجأ إلى الوقت الإضافي وركلات الترجيح.';

  @override
  String newsOfcFinalTitle(String opponent) {
    return 'نهائي أوقيانوسيا: $opponent';
  }

  @override
  String get newsOfcFinalBody =>
      'مباراة واحدة في نوفمبر، لدى مستضيف كأس أوقيانوسيا، على مقعد أوقيانوسيا في النهائيات. الخاسر يذهب إلى الملحق العابر للقارات.';

  @override
  String get matchTinyFirstLeg => 'ذهاب';

  @override
  String get matchTinySecondLeg => 'إياب';

  @override
  String get matchTinyFourthRound => 'د4';

  @override
  String get resultsStageFourthRound => 'الدور الرابع';

  @override
  String get resultsStageFifthRound => 'الدور الخامس';

  @override
  String newsNcPromotedTitle(String league) {
    return 'صعود إلى الدوري $league';
  }

  @override
  String newsNcPromotedBody(String cup) {
    return 'صدارة المجموعة في $cup: النسخة القادمة تُلعب في دوري أعلى، والصعود يساوي مليون يورو للاتحاد، تُدفع في نهاية الدورة.';
  }

  @override
  String newsNcRelegatedTitle(String league) {
    return 'هبوط إلى الدوري $league';
  }

  @override
  String newsNcRelegatedBody(String cup) {
    return 'قاع المجموعة في $cup: النسخة القادمة تُلعب في دوري أدنى.';
  }

  @override
  String stadiumsBuildFrom(String cost) {
    return 'البناء: ابتداءً من $cost';
  }

  @override
  String stadiumsConfirmBuildSized(String seats, String city, String cost) {
    return 'بناء ملعب بسعة $seats مقعد في $city مقابل $cost؟';
  }

  @override
  String stadiumsCapacityRange(String min, String max) {
    return 'السعة: حسب اختيارك، من $min إلى $max مقعد';
  }

  @override
  String get hubAssistantFriendly => 'دع المساعد يتولاها';

  @override
  String pitchComHandballPenalty1(String player) {
    return 'لمسة يد! $player يلمسها بيده في المنطقة، وهي ركلة جزاء.';
  }

  @override
  String pitchComHandballPenalty2(String player) {
    return 'الذراع كانت ممدودة: ركلة جزاء بسبب لمسة يد على $player!';
  }

  @override
  String pitchComHandballPenaltyYellow(String player) {
    return 'لمسة يد من $player في المنطقة: ركلة جزاء، وبطاقة صفراء.';
  }

  @override
  String pitchComHandballPenaltyRed(String player) {
    return '$player يمنعها بيده! ركلة جزاء، ويُطرد.';
  }

  @override
  String pitchComHandballYellow(String player) {
    return '$player ينال إنذارًا بسبب لمسة يد.';
  }

  @override
  String pitchComHandballRed(String player) {
    return 'لمسة يد متعمدة! $player يُطرد.';
  }

  @override
  String get matchLiveTable => 'الترتيب المباشر';

  @override
  String get matchShotMap => 'خريطة التسديدات';

  @override
  String get shotGoal => 'هدف';

  @override
  String get shotSaved => 'تصدٍّ';

  @override
  String get shotOffTarget => 'خارج الإطار';

  @override
  String get shotBlocked => 'مصدودة';

  @override
  String get shotWoodwork => 'الخشبات';

  @override
  String get playerStatSaves => 'التصديات';

  @override
  String get playerStatPenSaved => 'ركلات جزاء مصدودة';

  @override
  String get playerStatPenalties => 'ركلات الجزاء';

  @override
  String playerStatRateValue(String count, String pct) {
    return '$count ($pct%)';
  }

  @override
  String playerStatOfValue(String done, String of) {
    return '⁦$done/$of⁩';
  }

  @override
  String yPlayoffDrawn0(String competition, String opponent) {
    return 'سُحبت قرعة ملحق ⁦$competition: $opponent⁩ يقف بيننا وبين النهائيات.';
  }

  @override
  String yPlayoffDrawn1(String competition, String opponent) {
    return 'إنه $opponent في ملحق $competition. مواجهة واحدة، وكل شيء عليها.';
  }

  @override
  String yPlayoffDrawn2(String competition, String opponent) {
    return '$opponent في الملحق. أحتاج إلى الاستلقاء بالفعل. $competition، نحن قادمون. ربما.';
  }

  @override
  String yPlayoffDrawn3(String competition, String opponent) {
    return 'قرعة الملحق: $opponent. اهزموهم وستكون $competition في متناول اليد.';
  }

  @override
  String get matchElsewhereShout => 'هدف في ملعب آخر';

  @override
  String get assistantMatchTitle => 'المساعد يتولاها';

  @override
  String assistantMatchBody(String opponent) {
    return 'أمام $opponent يلعب بقائمتك وتكتيكك. حددهما أولًا إن شئت.';
  }

  @override
  String get assistantMatchPlay => 'دعه يلعب';

  @override
  String get assistantMatchResult => 'مباراة المساعد';

  @override
  String get euroPlayoffCourseTitle => 'الملحق عبر كأس الأمم';

  @override
  String get euroPlayoffCourseNote =>
      'أول فريقين في كل مجموعة يتأهلان مباشرة. المقاعد الأخيرة تذهب إلى مسارات الملحق لأفضل فرق كأس الأمم غير المتأهلة. كما هو الوضع الآن:';

  @override
  String get euroPlayoffToFinal => 'إلى النهائي';

  @override
  String get euroPlayoffQualified => 'متأهل';

  @override
  String get playerOtherPositions => 'في كل المراكز';

  @override
  String get compGulfCup => 'كأس الواحة';

  @override
  String get compSoutheastAsianChampionship => 'بطولة جنوب شرق آسيا';

  @override
  String get matchTinyGulfCup => 'الواحة';

  @override
  String get matchTinySoutheastAsia => 'ج.ش.آسيا';

  @override
  String hubCallUpRegional(String cup) {
    return 'سمِّ قائمتك لـ$cup';
  }

  @override
  String newsRegionalDrawTitle(String cup, String group) {
    return '$cup: المجموعة $group';
  }

  @override
  String newsRegionalDrawBody(String cup, String rivals) {
    return 'أُجريت قرعة $cup. في ديسمبر تواجه $rivals.';
  }

  @override
  String newsRegionalDrawBodyHosted(String cup, String rivals, String host) {
    return 'أُجريت قرعة $cup. في ديسمبر تواجه $rivals، وتستضيفها $host.';
  }

  @override
  String newsRegionalWonTitle(String cup) {
    return 'الفوز بـ$cup!';
  }

  @override
  String newsRegionalWonBody(String cup, String opponent, String score) {
    return 'فزت بـ$cup، بعد التغلب على $opponent ⁦$score⁩ في النهائي.';
  }

  @override
  String get tourZoneGulf => 'الخليج';

  @override
  String get tourZoneSoutheastAsia => 'جنوب شرق آسيا';

  @override
  String regionalCupNext(int year) {
    return 'تُلعب النسخة القادمة في ديسمبر $year.';
  }

  @override
  String get regionalCupNoWinners => 'لا أبطال بعد.';

  @override
  String regionalCupEdition(String cup, int year) {
    return '$cup $year';
  }

  @override
  String regionalCupChampion(String name) {
    return 'فاز بها $name';
  }

  @override
  String regionalCupHosted(String host) {
    return 'استضافتها $host';
  }

  @override
  String get regionalCupHomeAndAway => 'المجموعات تُلعب ذهابًا وإيابًا';

  @override
  String get regionalCupGroups => 'المجموعات';

  @override
  String newsNcPlayoffNetTitle(String finals) {
    return 'شبكة أمان عبر الملحق: $finals';
  }

  @override
  String newsNcPlayoffNetBody(String cup, String finals) {
    return 'بحسب جداول $cup الحالية، لديك مقعد في الملحق. إن لم تتأهل مباشرة، فهو يمنحك طريقًا ثانيًا إلى $finals. تُسحب المسارات بعد انتهاء التصفيات.';
  }

  @override
  String get ncLegendWinnerUp => 'متصدر المجموعة: يصعد دوريًا';

  @override
  String get ncLegendWinnerFinalsFour => 'متصدر المجموعة: إلى المربع الذهبي';

  @override
  String get ncLegendLastDown => 'القاع: يهبط دوريًا';

  @override
  String get ncLegendMayMove =>
      'غير مؤكد: مقاعد أقل من المجموعات، لذا يصعد أفضل المتصدرين فقط ويهبط أسوأ أصحاب القاع عبر الدوري';

  @override
  String get campaignIsleOfManTitle => 'الأرجل الثلاث';

  @override
  String get campaignIsleOfManTwist =>
      'جزيرة مان تحل محل أندورا في أوروبا، لمئة عام';

  @override
  String get campaignIsleOfManIntro =>
      'لجزيرة مان اتحادها الكروي ودوريها ومنتخبها الذي يلعب ألعاب الجزر، لكن لا مقعد لها في الكرة الأوروبية أو العالمية. في هذا العالم حلّت محل أندورا في أوروبا، وتبدأ قرب قاع التصنيف العالمي: لاعبون بدوام جزئي، وملعب صغير في دوغلاس، ورياح البحر الأيرلندي في كل مباراة. لديك مئة عام، خمس وعشرون دورة، لبلوغ بطولة أوروبا، ثم بطولة العالم، وإن تجرأت على الحلم، الفوز بإحداهما.';

  @override
  String get campaignIsleOfManGoal => 'التأهل إلى بطولة أوروبا';

  @override
  String get campaignStars1IsleOfMan => 'التأهل إلى بطولة أوروبا';

  @override
  String get campaignStars2IsleOfMan => 'التأهل إلى بطولة العالم';

  @override
  String get campaignStars3IsleOfMan => 'الفوز ببطولة أوروبا أو بطولة العالم';

  @override
  String get campaignCzechoslovakiaTitle => 'لمّ الشمل';

  @override
  String get campaignCzechoslovakiaTwist =>
      'التشيك وسلوفاكيا تلعبان كفريق واحد مجددًا، لأربع دورات';

  @override
  String get campaignCzechoslovakiaIntro =>
      'فازت تشيكوسلوفاكيا ببطولة أوروبا عام 1976 وبلغت نهائي بطولة العالم مرتين، ثم انقسمت إلى دولتين عام 1993. في هذا العالم عادت الدولتان معًا: كل لاعب دولي من التشيك وسلوفاكيا يلعب لفريق واحد مجددًا، والدولتان اختفتا من أوروبا. تبدأ داخل أفضل ثلاثين في العالم بقليل مع نخبة القائمتين. لديك أربع دورات لتأخذ تشيكوسلوفاكيا إلى بطولة العالم، ثم الفوز ببطولة أوروبا وبطولة العالم.';

  @override
  String get campaignCzechoslovakiaGoal => 'التأهل إلى بطولة العالم';

  @override
  String get campaignStars1Czechoslovakia => 'التأهل إلى بطولة العالم';

  @override
  String get campaignStars2Czechoslovakia => 'الفوز ببطولة أوروبا';

  @override
  String get campaignStars3Czechoslovakia => 'الفوز ببطولة العالم';

  @override
  String get campaignTexasTitle => 'النجمة الوحيدة';

  @override
  String get campaignTexasTwist =>
      'جمهورية تكساس تحل محل أنغيلا في أمريكا الشمالية، لخمس دورات';

  @override
  String get campaignTexasIntro =>
      'كانت تكساس جمهورية مستقلة لتسع سنوات قبل أن تنضم إلى الولايات المتحدة، واليوم تُخرّج لاعبي كرة قدم أكثر من معظم الدول: ثلاث أكاديميات في الدرجة الأولى، وواحدة من أعمق قواعد الشباب في أي مكان، وتكساسيون في كل دوري. في هذا العالم تلعب جمهورية تكساس لنفسها، محل أنغيلا في أمريكا الشمالية. كل لاعب مولود في تكساس، من هيوستن ودالاس وسان أنطونيو وأوستن وإل باسو، والقائمة فريق من وسط الترتيب في المنطقة: جيدة بما يكفي لإزعاج أي أحد، لكنها ليست مخيفة بعد. لديك خمس دورات لبلوغ بطولة العالم، والفوز بكأس أمريكا الشمالية، وإن تجرأت على الحلم، ببطولة العالم نفسها.';

  @override
  String get campaignTexasGoal => 'التأهل إلى بطولة العالم';

  @override
  String get campaignStars1Texas => 'التأهل إلى بطولة العالم';

  @override
  String get campaignStars2Texas => 'الفوز بكأس أمريكا الشمالية';

  @override
  String get campaignStars3Texas => 'الفوز ببطولة العالم';

  @override
  String get campaignVaticanTitle => 'معجزة السماء';

  @override
  String get campaignVaticanTwist =>
      'الفاتيكان تحل محل سان مارينو في أوروبا لخمسين دورة';

  @override
  String get campaignVaticanIntro =>
      'أصغر دولة في العالم فيها بضع مئات من المواطنين، معظمهم من رجال الدين، وحرس من حاملي الرماح السويسريين، ولا لاعب كرة قدم واحد يستحق الذكر. في هذا العالم تلعب الفاتيكان مع ذلك، محل سان مارينو في أوروبا، وهي أسوأ بكثير مما كانت سان مارينو يومًا: أساقفة، وطلاب لاهوت، وموظفو متاحف، وحراس خارج الخدمة، وملعب داخل الأسوار يتسع لـ1,500، ومباراة على أرضها أحيانًا في ملعب مستعار في روما. خمسون دورة وقت طويل، لكن الأمر يتطلب معجزات مع ذلك: ابلغ بطولة أوروبا، ثم بطولة العالم، وإن كانت السماء تصغي، افز بإحداهما.';

  @override
  String get campaignVaticanGoal => 'التأهل إلى بطولة أوروبا';

  @override
  String get campaignStars1Vatican => 'التأهل إلى بطولة أوروبا';

  @override
  String get campaignStars2Vatican => 'التأهل إلى بطولة العالم';

  @override
  String get campaignStars3Vatican => 'الفوز ببطولة العالم';

  @override
  String get campaignNoEnd => 'بلا نهاية';

  @override
  String homeCampaignCycleNoEnd(int cycle) {
    return 'الدورة $cycle';
  }

  @override
  String get wcPlayoffCourseNote =>
      'كل متصدر مجموعة يتأهل مباشرة. المقاعد الأخيرة تذهب إلى مسارات الملحق: أفضل الوصفاء (بالأصفر في المجموعات) وأفضل متصدري مجموعات كأس الأمم غير المتأهلين. من كأس الأمم، كما هو الوضع الآن:';

  @override
  String get playoffCourseLegend =>
      'الأصفر: في طريقه إلى مسار ملحق كأحد أفضل الوصفاء، كما هو الوضع الآن';

  @override
  String get playoffCourseFooter =>
      'سبب وجودهم هنا: كأس الأمم تمنح متصدري مجموعاتها، ثم الأفضل التالي في كل دوري، مقعدًا في الملحق إن لم يتأهلوا مباشرة. هذا هو الوضع اليوم فقط: يتغير بعد كل جولة.';

  @override
  String get traitShotStopper => 'حارس بارع في التصدي';

  @override
  String get traitShotStopperBlurb => 'يمنع تسديدات أكثر من حصته.';

  @override
  String get traitPenaltyStopper => 'صائد ركلات الجزاء';

  @override
  String get traitPenaltyStopperBlurb =>
      'يتصدى لركلات جزاء أكثر، في المباريات وفي ركلات الترجيح.';

  @override
  String get playoffCourseLegendAll => 'الأصفر: كل وصيف يذهب إلى الملحق';

  @override
  String get wcRunnersUpTableTitle => 'الوصفاء: كلهم يذهبون إلى الملحق';

  @override
  String get wcRunnersUpTableNote =>
      'مرتبون حسب سجلات قابلة للمقارنة. تُسحب مستويات الملحق حسب التصنيف العالمي بعد انتهاء التصفيات.';

  @override
  String ncRouteNote(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'المستوى 4 من الملحق يضم $count مقعد لكأس الأمم.',
      many: 'المستوى 4 من الملحق يضم $count مقعدًا لكأس الأمم.',
      few: 'المستوى 4 من الملحق يضم $count مقاعد لكأس الأمم.',
      two: 'المستوى 4 من الملحق يضم مقعدين لكأس الأمم.',
      one: 'المستوى 4 من الملحق يضم مقعدًا واحدًا لكأس الأمم.',
      zero: 'لا مقاعد لكأس الأمم في المستوى 4 من الملحق.',
    );
    return '$_temp0 تذهب أولًا إلى أفضل متصدري مجموعاتها ممن لم يتصدروا مجموعة التصفيات ولم ينهوا وصفاء، ثم نزولًا في ترتيبها. كما هو الوضع الآن:';
  }

  @override
  String ncRouteHostCycle(int paths, int runnersUp) {
    return 'دولة أوروبية تستضيف بطولة العالم هذه، لذا يملأ الوصفاء الـ$runnersUp كل مسارات الملحق الـ$paths ولا يذهب أي مقعد عبر كأس الأمم في هذه الدورة.';
  }

  @override
  String get ncRouteTagHolds => 'يحتل مقعدًا';

  @override
  String get ncRouteTagQualified => 'متأهل';

  @override
  String get ncRouteTagRunnerUp => 'وصيف';

  @override
  String get ncRouteTagWaiting => 'التالي في الدور';

  @override
  String get ncRouteLegendHolds =>
      'يحتل مقعدًا في المستوى 4، كما هو الوضع الآن';

  @override
  String get ncRouteLegendQualified =>
      'يتصدر مجموعة التصفيات: متأهل مباشرة، لذا ينتقل مقعده';

  @override
  String get ncRouteLegendRunnerUp =>
      'ثاني مجموعة التصفيات: في الملحق على أي حال، لذا ينتقل مقعده';

  @override
  String get ncRouteLegendWaiting =>
      'التالي في الدور، إن خرج فريق أعلى منه من المسار';

  @override
  String get statsTabHistory => 'التاريخ';

  @override
  String get tourCupDestAfcFourthRound => 'الدور الرابع الآسيوي';

  @override
  String get tourCupDestCafPlayoff => 'الملحق الأفريقي';

  @override
  String get tourCupDestOfcFinal => 'نهائي أوقيانوسيا';

  @override
  String get qualLegendDirect =>
      'الأخضر: في الطريق إلى النهائيات، كما هو الوضع الآن';

  @override
  String get qualLegendAfcStep => 'الأصفر: في الطريق إلى الدور الرابع الآسيوي';

  @override
  String get qualLegendCafStep => 'الأصفر: في الطريق إلى الملحق الأفريقي';

  @override
  String get qualLegendOfcStep => 'الأصفر: في الطريق إلى نهائي أوقيانوسيا';

  @override
  String get qualLegendIntercont =>
      'الأصفر: في الطريق إلى الملحق العابر للقارات';

  @override
  String get legendThrough =>
      'الأخضر: يتأهل إلى الدور التالي، كما هو الوضع الآن';

  @override
  String get campaignRunInNumbersNote =>
      'المباريات التي يُحكم بها على هذه الحملة فقط: المباريات الودية والمسابقات الأخرى مستبعدة.';

  @override
  String get resultsStagePlayoff => 'الملحق';

  @override
  String newsEuroPlayoffTieTitle(String cup, String path) {
    return 'ملحق $cup: المواجهة $path';
  }

  @override
  String newsEuroPlayoffTieBodyHome(String opponent) {
    return 'مواجهة من مباراتين أمام $opponent في مارس: الذهاب على أرضك، والإياب خارجها. المتقدم بمجموع المباراتين يذهب إلى النهائيات.';
  }

  @override
  String newsEuroPlayoffTieBodyAway(String opponent) {
    return 'مواجهة من مباراتين أمام $opponent في مارس: الذهاب خارج أرضك، والإياب على أرضك. المتقدم بمجموع المباراتين يذهب إلى النهائيات.';
  }

  @override
  String newsEuroHostPlaceTitle(String cup) {
    return 'متأهل كمستضيف: $cup';
  }

  @override
  String newsEuroHostPlaceBody(String cup) {
    return 'فاتك المقعد المباشر، لكن كمستضيف تأخذ أحد المقاعد المحجوزة للمستضيفين. لقد تأهلت إلى نهائيات $cup.';
  }

  @override
  String get euro28LegendPlayoff =>
      'الأصفر: وصيف في طريقه إلى الملحق، كما هو الوضع الآن';

  @override
  String euro28LegendHosts(String hosts) {
    return 'المستضيفون ($hosts) يلعبون التصفيات أيضًا: إن لم يتأهلوا، يُحجز لهم مقعد.';
  }

  @override
  String euro28LegendHostsMany(String hosts) {
    return 'المستضيفون ($hosts) يلعبون التصفيات أيضًا: يُحجز مقعدان لأفضل اثنين ممن لم يتأهلوا.';
  }

  @override
  String get euro28DestPlayoffs => 'الملحق';

  @override
  String get euro28CourseTitle => 'الملحق، كما هو الوضع الآن';

  @override
  String get euro28CourseNote =>
      'متصدرو المجموعات وأفضل ثمانية وصفاء يتأهلون مباشرة. الوصفاء الآخرون يذهبون إلى الملحق، مع أفضل متصدري مجموعات كأس الأمم غير المتأهلين. كما هو الوضع الآن:';

  @override
  String get euro28CourseFooter =>
      'سبب وجودهم هنا: الوصفاء الذين فاتهم التأهل أولًا، ثم أفضل متصدري مجموعات كأس الأمم غير المتأهلين بعد، ثم الأفضل التالي. هذا هو الوضع اليوم فقط: يتغير بعد كل جولة.';

  @override
  String euroPlayoffTie(String path) {
    return 'المواجهة $path';
  }

  @override
  String get euroPlayoffYourTie => 'مواجهتك';

  @override
  String euroPlayoffAggregate(String score) {
    return 'المجموع: ⁦$score⁩';
  }

  @override
  String euroPlayoffTieWinnerPlaceholder(String path) {
    return 'الفائز في المواجهة $path';
  }

  @override
  String euroPlayoffYourGroupIfWinTie(String path, String group) {
    return 'مجموعتك إن فزت بالمواجهة $path: المجموعة $group';
  }

  @override
  String get euro28PlayoffIntroTies =>
      'متصدرو المجموعات وأفضل ثمانية وصفاء متأهلون. المقاعد الأربعة الأخيرة تُحسم في مواجهات من مباراتين في مارس، ذهابًا وإيابًا: أفضل أربعة فرق مصنّفة وتلعب الإياب على أرضها.';

  @override
  String euro28PlayoffIntroPaths(int count) {
    return 'متصدرو المجموعات وأفضل ثمانية وصفاء متأهلون، والمستضيفون الذين فاتهم التأهل يأخذون المقاعد المحجوزة لهم. المقاعد الـ$count الأخيرة تُحسم في مسارات من أربعة فرق في مارس: نصف نهائي من مباراة واحدة على أرض الأعلى تصنيفًا، ثم نهائي من مباراة واحدة.';
  }

  @override
  String get classicCupsTitle => 'الكؤوس الكلاسيكية';

  @override
  String get classicCupsIntro =>
      'أعد خوض بطولة عالم حقيقية: مستضيفوها، وقرعتها، ونظامها. اختر أي منتخب وامضِ به حتى النهاية.';

  @override
  String classicEditionLabel(String year, String hosts) {
    return 'بطولة العالم $year · $hosts';
  }

  @override
  String classicHostsTwo(String first, String second) {
    return '$first و$second';
  }

  @override
  String classicHostsThree(String first, String second, String third) {
    return '$first و$second و$third';
  }

  @override
  String classicTeamsCount(int count) {
    return '$count منتخبًا';
  }

  @override
  String classicRealChampion(String nation) {
    return 'البطل الحقيقي: $nation';
  }

  @override
  String classicMedalsProgress(int earned, int total) {
    return '$earned من $total ميداليات';
  }

  @override
  String get classicPickNation => 'اختر منتخبًا';

  @override
  String get classicStart => 'ابدأ البطولة';

  @override
  String get classicAbandonConfirm =>
      'التخلي عن هذه المحاولة؟ ستضيع كل المباريات التي لُعبت حتى الآن.';

  @override
  String classicRunWith(String nation) {
    return 'محاولة جارية مع $nation';
  }

  @override
  String get classicLockedNote =>
      'هذه النسخة تأتي مع الإصدار غير المحدود. تصفّح المستضيفين والقرعة الآن؛ اللعب يحتاج إلى الإصدار غير المحدود.';

  @override
  String classicPot(int pot) {
    return 'المستوى $pot';
  }

  @override
  String get classicWonHere => 'فزت بها مع هذا المنتخب بالفعل';

  @override
  String get classicNextMatch => 'المباراة التالية';

  @override
  String get classicPlayMatch => 'العب المباراة';

  @override
  String get classicTabGroups => 'المجموعات';

  @override
  String classicMatchday(int number) {
    return 'الجولة $number';
  }

  @override
  String get classicBestXi => 'التشكيلة المثالية';

  @override
  String get classicChampionTitle => 'أبطال العالم!';

  @override
  String classicChampionBody(String nation, String year) {
    return '$nation يفوز ببطولة العالم $year.';
  }

  @override
  String get classicOutTitle => 'الإقصاء';

  @override
  String classicOutBody(String stage, String nation) {
    return '$stage: هنا ينتهي الطريق لـ$nation.';
  }

  @override
  String get classicMedalsEarned => 'الميداليات المكتسبة';

  @override
  String get classicNoRun => 'لا محاولة جارية. اختر منتخبًا لبدء واحدة.';

  @override
  String classicPensShort(int home, int away) {
    return '⁦$home⁦-$away⁩⁩ بركلات الترجيح';
  }

  @override
  String get classicMedalsTitle => 'الميداليات';

  @override
  String get classicMedalsAll => 'كل النسخ';

  @override
  String get classicMedalLocked => 'يحتاج إلى الإصدار غير المحدود';

  @override
  String get classicMedalChampion => 'البطل';

  @override
  String get classicMedalChampionHow => 'افز بالنسخة مع أي منتخب.';

  @override
  String get classicMedalCollection => 'الجامع';

  @override
  String classicMedalCollectionHow(int count) {
    return 'افز بالنسخة مع $count منتخبات مختلفة.';
  }

  @override
  String get classicMedalContinents => 'كل القارات';

  @override
  String get classicMedalContinentsHow =>
      'افز بها مع منتخب من كل اتحاد قاري مشارك.';

  @override
  String get classicMedalGiantKiller => 'قاهر العمالقة';

  @override
  String get classicMedalGiantKillerHow =>
      'افز بها مع منتخب غير مرشح: فريق من المستوى الأخير أو من الثلث الأضعف.';

  @override
  String get classicMedalRewrite => 'أعد كتابة التاريخ';

  @override
  String get classicMedalRewriteHow =>
      'أقصِ المنتخب الذي فاز فعلًا بهذه النسخة.';

  @override
  String get classicMedalUnbeaten => 'بلا هزيمة';

  @override
  String get classicMedalUnbeatenHow => 'افز بالنسخة دون خسارة أي مباراة.';

  @override
  String get classicMedalGoldenBootHow =>
      'اجعل أحد لاعبيك ينهي البطولة هدافًا.';

  @override
  String get classicMedalGrandSlam => 'الاكتساح الكبير';

  @override
  String get classicMedalGrandSlamHow => 'افز بالنسخ السبع كلها.';

  @override
  String get classicMedalSevenFlags => 'سبعة أعلام';

  @override
  String get classicMedalSevenFlagsHow => 'افز مع سبعة منتخبات مختلفة.';

  @override
  String get classicMedalConfederations => 'ستة اتحادات قارية';

  @override
  String get classicMedalConfederationsHow =>
      'افز مع منتخب من كل الاتحادات القارية الستة.';

  @override
  String get classicMedalOneNation => 'منتخب واحد، كل العصور';

  @override
  String get classicMedalOneNationHow => 'افز بكل النسخ مع المنتخب نفسه.';

  @override
  String get classicMedalPerfect => 'الكمالي';

  @override
  String get classicMedalPerfectHow => 'اكسب كل ميداليات نسخة واحدة.';

  @override
  String get classicNationRussia => 'روسيا';

  @override
  String get classicNationSerbiaMontenegro => 'صربيا والجبل الأسود';

  @override
  String get paywallBenefitClassicCups =>
      'كل الكؤوس الكلاسيكية: أعد خوض بطولات العالم 2002 و2010 و2022 أيضًا، بقرعاتها الحقيقية.';

  @override
  String get editorClassicBlurb =>
      'منتخبات كل بطولات العالم السابقة: القوة، والأطقم، واللاعبون.';

  @override
  String get editorClassicStar => 'أفضل لاعب';

  @override
  String get editorClassicDepth => 'الدكة';

  @override
  String get editorClassicKit => 'ألوان الطقم';

  @override
  String get editorClassicPrimary => 'القميص';

  @override
  String get editorClassicSecondary => 'الحواف';

  @override
  String get editorClassicReset => 'أعد ضبط هذا المنتخب';

  @override
  String get editorClassicStadiums => 'ملاعب الاستضافة';

  @override
  String get editorClassicStadiumName => 'اسم الملعب';

  @override
  String get editorClassicCity => 'المدينة';

  @override
  String get editorClassicCapacity => 'السعة';

  @override
  String editorClassicCapacityRange(String min, String max) {
    return 'بين $min و$max مقعد.';
  }

  @override
  String get editorClassicHostNation => 'البلد المستضيف';

  @override
  String get editorClassicAddStadium => 'أضف ملعبًا';

  @override
  String get editorClassicRemoveStadium => 'احذف هذا الملعب';

  @override
  String get editorClassicOpeningVenue => 'المباراة الافتتاحية';

  @override
  String get editorClassicFinalVenue => 'النهائي';

  @override
  String get editorClassicResetStadiums => 'أعد ضبط الملاعب';

  @override
  String get editorClassicAddPlayer => 'أضف لاعبًا';

  @override
  String get editorClassicRemovePlayer => 'احذف هذا اللاعب';

  @override
  String get editorClassicResetSquad => 'أعد ضبط القائمة';

  @override
  String editorClassicSquadRule(int min, int max, int keepers) {
    return 'من $min إلى $max لاعبًا، منهم $keepers حراس مرمى على الأقل.';
  }

  @override
  String editorClassicKeepersNeeded(int count) {
    return 'تحتاج القائمة إلى $count حراس مرمى على الأقل.';
  }
}
