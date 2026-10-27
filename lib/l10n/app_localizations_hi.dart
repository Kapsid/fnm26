// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get matchPreviewTitle => 'मैच प्रीव्यू';

  @override
  String get matchKickOff => 'किक-ऑफ़';

  @override
  String get matchTactics => 'टैक्टिक्स';

  @override
  String get matchYourXi => 'आपकी XI';

  @override
  String get matchHeadToHead => 'आमने-सामने';

  @override
  String matchCouldNotLoad(String error) {
    return 'मैच लोड नहीं हो सका।\n$error';
  }

  @override
  String get matchNoUpcoming => 'कोई आगामी मैच नहीं।';

  @override
  String get matchUnknownNation => 'अज्ञात';

  @override
  String get matchH2hFirstMeeting => 'पहली बार आमना-सामना';

  @override
  String get matchH2hYouLead => 'आमने-सामने में आप आगे हैं';

  @override
  String matchH2hOppEdge(String opponent) {
    return '$opponent का पलड़ा भारी है';
  }

  @override
  String get matchH2hEven => 'बराबरी का मुक़ाबला';

  @override
  String matchH2hMet(int count) {
    return '$count मुक़ाबले';
  }

  @override
  String get matchH2hWon => 'जीते';

  @override
  String get matchH2hDrawn => 'ड्रॉ';

  @override
  String get matchH2hLost => 'हारे';

  @override
  String get matchDossierTitle => 'स्काउटिंग रिपोर्ट';

  @override
  String get matchDossierForm => 'फ़ॉर्म';

  @override
  String get matchDossierNoGames => 'कोई हालिया मैच नहीं';

  @override
  String get matchDossierKeyMen => 'ख़तरनाक खिलाड़ी';

  @override
  String get matchDossierHowTheyPlay => 'खेलने का अंदाज़';

  @override
  String matchScoutFormation1(String formation) {
    return 'वे आमतौर पर $formation फ़ॉर्मेशन में उतरते हैं।';
  }

  @override
  String matchScoutFormation2(String formation) {
    return 'उनका आम फ़ॉर्मेशन $formation है।';
  }

  @override
  String matchScoutFormation3(String formation) {
    return 'वे ज़्यादातर $formation फ़ॉर्मेशन अपनाते हैं।';
  }

  @override
  String get matchScoutStrengthPressing =>
      'वे ऊँचा प्रेस करते हैं और गेंद के पीछे पड़ जाते हैं।';

  @override
  String get matchScoutStrengthDirect =>
      'वे सीधा खेलते हैं और गेंद जल्दी आगे पहुँचाते हैं।';

  @override
  String get matchScoutStrengthPossession =>
      'वे गेंद अच्छे से अपने पास रखते हैं और धैर्य से खेल बनाते हैं।';

  @override
  String get matchScoutStrengthCounter =>
      'वे पीछे रुकते हैं और तेज़ी से जवाबी हमला करते हैं।';

  @override
  String get matchScoutStrengthDeepDefence =>
      'वे पीछे रहकर बचाव करते हैं और उन्हें भेदना मुश्किल है।';

  @override
  String get matchScoutStrengthWide =>
      'वे मैदान चौड़ा करते हैं और किनारों से हमला करते हैं।';

  @override
  String get matchScoutStrengthAttacking =>
      'उन्हें पहल करके विरोधी पर चढ़ाई करना पसंद है।';

  @override
  String get matchScoutStrengthQuickForwards =>
      'उनके फ़ॉरवर्ड तेज़ हैं और डिफ़ेंस के पीछे दौड़ना पसंद करते हैं।';

  @override
  String get matchScoutStrengthPassingMidfield =>
      'उनका मिडफ़ील्ड गेंद को अच्छी तरह पास करता है।';

  @override
  String get matchScoutStrengthHardRunning =>
      'उनके मिडफ़ील्डर पूरे मैच दौड़ने का दम रखते हैं।';

  @override
  String get matchScoutStrengthSetPieces => 'वे सेट पीस पर ख़तरनाक हैं।';

  @override
  String get matchScoutStrengthQuickDefence =>
      'उनकी बैक लाइन तेज़ है और उसके पीछे जाना मुश्किल है।';

  @override
  String get matchScoutStrengthNone => 'उनके खेल में कुछ ख़ास अलग नहीं दिखता।';

  @override
  String get matchScoutWeakSpaceBehind =>
      'उनकी ऊँची डिफ़ेंसिव लाइन पीछे लंबी गेंद के लिए जगह छोड़ती है।';

  @override
  String get matchScoutWeakPressedBuildUp =>
      'ऊँचा प्रेस उनके धीमे बिल्ड-अप को बिगाड़ सकता है।';

  @override
  String get matchScoutWeakDeepBlock =>
      'धैर्य रखें: उनके जैसे गहरे ब्लॉक को भी तोड़ा जा सकता है।';

  @override
  String get matchScoutWeakLongBall =>
      'अपनी लाइन पीछे करें, तो उनकी लंबी गेंदों को कोई जगह नहीं मिलेगी।';

  @override
  String get matchScoutWeakSlowDefence =>
      'उनके डिफ़ेंडरों में रफ़्तार की कमी है, इसलिए उनके पीछे दौड़ने वाले भेजें।';

  @override
  String get matchScoutWeakAerial =>
      'सेट पीस का बचाव करते समय वे डगमगाते दिखते हैं।';

  @override
  String get matchScoutWeakPoorPassing =>
      'दबाव में उनका मिडफ़ील्ड पास करके बाहर निकलने में जूझता है।';

  @override
  String get matchScoutWeakTiringMidfield =>
      'उनके मिडफ़ील्ड में लगातार प्रेस करने का दम नहीं है।';

  @override
  String get matchScoutWeakBluntAttack =>
      'उनके फ़ॉरवर्ड में रफ़्तार की कमी है।';

  @override
  String get matchScoutApproachTakeTheGame =>
      'आपके ख़िलाफ़ उनसे पहल करने की उम्मीद रखें।';

  @override
  String get matchScoutApproachEven =>
      'आपके ख़िलाफ़ एक कड़े, बराबरी के मुक़ाबले की उम्मीद रखें।';

  @override
  String get matchScoutApproachSitDeep =>
      'आपके ख़िलाफ़ उनसे सावधानी से खेलने और जवाबी हमले की ताक में रहने की उम्मीद रखें।';

  @override
  String get matchScoutLeaningAttacking => 'दूर से वे एक आक्रामक टीम लगते हैं।';

  @override
  String get matchScoutLeaningCautious => 'दूर से वे एक सतर्क टीम लगते हैं।';

  @override
  String get matchScoutLeaningUnclear =>
      'दूर से यह कहना मुश्किल है कि वे कैसे खेलना पसंद करते हैं।';

  @override
  String get matchScoutHireHint =>
      'यह जानने के लिए कि वे कैसे खेलते हैं, एक चीफ़ स्काउट रखें।';

  @override
  String matchCouldNotContinue(String error) {
    return 'आगे नहीं बढ़ सके: $error';
  }

  @override
  String get matchSkipToFullTime => 'फ़ुल टाइम तक छोड़ें';

  @override
  String get matchStatShots => 'शॉट';

  @override
  String get matchStatGoals => 'गोल';

  @override
  String get matchStatYellowCards => 'येलो';

  @override
  String get matchStatRedCards => 'रेड';

  @override
  String get matchMomentum => 'मोमेंटम';

  @override
  String get matchSwingAtk => 'अटैक';

  @override
  String get matchSwingDef => 'डिफ़ेंस';

  @override
  String ceremonyWorldCupYear(int year) {
    return 'विश्व चैंपियनशिप $year';
  }

  @override
  String get ceremonyFinalsAreHere => 'फ़ाइनल्स का आगाज़';

  @override
  String ceremonyHostedBy(String hosts) {
    return 'मेज़बान  $hosts';
  }

  @override
  String get ceremonyHostTbc => 'मेज़बान की पुष्टि बाक़ी';

  @override
  String get matchHalfTime => 'हाफ़ टाइम';

  @override
  String get matchContinue => 'जारी रखें';

  @override
  String get matchContinuing => 'जारी है…';

  @override
  String matchTacticsWithSubs(int used, int max) {
    return 'टैक्टिक्स · $used/$max सब';
  }

  @override
  String matchTiredCount(int count) {
    return 'थके ×$count';
  }

  @override
  String get matchTacticsLabel => 'टैक्टिक्स';

  @override
  String get teamOverallOverTime => 'समय के साथ ओवरऑल';

  @override
  String get teamOverall => 'ओवरऑल';

  @override
  String get teamTalkHeading => 'टीम टॉक';

  @override
  String get teamTalkPrompt => 'दूसरे हाफ़ का माहौल तय करें।';

  @override
  String get teamTalkCalmLabel => 'शांत रहें';

  @override
  String get teamTalkCalmBlurb => 'टीम को संभालें। सबमें हल्का सुधार।';

  @override
  String get teamTalkEncourageLabel => 'हौसला बढ़ाएँ';

  @override
  String get teamTalkEncourageBlurb => 'आगे बढ़ें और मैच पर हावी हों।';

  @override
  String get teamTalkDemandMoreLabel => 'और मांगें';

  @override
  String get teamTalkDemandMoreBlurb => 'पूरा ज़ोर लगा दें। जमकर हमला करें।';

  @override
  String get teamTalkPraiseLabel => 'कसकर खेलें';

  @override
  String get teamTalkPraiseBlurb => 'कॉम्पैक्ट रहें और बढ़त बचाएँ।';

  @override
  String get teamTalkBelieveLabel => 'यक़ीन रखें';

  @override
  String get teamTalkBelieveBlurb =>
      'ख़ुद पर भरोसा रखें। मैदान के दोनों छोरों पर बेहतर खेल।';

  @override
  String get teamTalkFocusLabel => 'चौकस रहें';

  @override
  String get teamTalkFocusBlurb => 'पूरी एकाग्रता। मैच पर पकड़ बनाए रखें।';

  @override
  String get teamTalkUrgencyLabel => 'जल्दी दिखाएँ';

  @override
  String get teamTalkUrgencyBlurb =>
      'अभी पीछे पड़ जाएँ। पूरा दम लगाएँ, पर पीछे जगह खुलेगी।';

  @override
  String get teamTalkReassureLabel => 'कोई दबाव नहीं';

  @override
  String get teamTalkReassureBlurb => 'घबराहट दूर करें और अपनी शेप बनाए रखें।';

  @override
  String get commonRetry => 'दोबारा कोशिश करें';

  @override
  String get commonSomethingWentWrong => 'कुछ गड़बड़ हो गई';

  @override
  String get commonCrashBox =>
      'यहाँ कुछ गड़बड़ हो गई।\nसेटिंग्स → डायग्नोस्टिक्स में ब्योरा है।';

  @override
  String hubCouldNotAdvance(String error) {
    return 'दुनिया को आगे नहीं बढ़ा सके: $error';
  }

  @override
  String get settingsDiagnosticsTitle => 'डायग्नोस्टिक्स';

  @override
  String get settingsDiagnosticsBlurb =>
      'इस डिवाइस पर दर्ज त्रुटियाँ। कुछ भी कहीं नहीं भेजा जाता।';

  @override
  String get settingsContactTitle => 'संपर्क';

  @override
  String get settingsContactCopied => 'पता कॉपी हो गया।';

  @override
  String get settingsCommunityTitle => 'कम्युनिटी';

  @override
  String get settingsDiscordSubtitle => 'कम्युनिटी से जुड़ें';

  @override
  String get settingsLinkCopied => 'लिंक कॉपी हो गया।';

  @override
  String get diagnosticsEmpty => 'कोई त्रुटि दर्ज नहीं। यही तो चाहिए।';

  @override
  String get diagnosticsCopy => 'कॉपी';

  @override
  String get diagnosticsCopied => 'लॉग क्लिपबोर्ड पर कॉपी हो गया।';

  @override
  String get diagnosticsClear => 'साफ़ करें';

  @override
  String get navHub => 'हब';

  @override
  String get navSquad => 'स्क्वॉड';

  @override
  String get navStandings => 'स्टैंडिंग्स';

  @override
  String get navCareers => 'मेरा करियर';

  @override
  String get settingsTitle => 'सेटिंग्स';

  @override
  String get settingsSoundHapticsTitle => 'साउंड और हैप्टिक्स';

  @override
  String get settingsSoundHapticsBlurb =>
      'गोल, किक-ऑफ़ और फ़ुल टाइम पर वाइब्रेशन और छोटी आवाज़।';

  @override
  String get settingsLanguageTitle => 'भाषा';

  @override
  String get settingsLanguageBlurb =>
      'ऐप की भाषा चुनें, या डिवाइस की भाषा अपनाएँ।';

  @override
  String get settingsLanguageSystem => 'सिस्टम';

  @override
  String get settingsTextSizeTitle => 'टेक्स्ट का आकार';

  @override
  String get settingsTextSizeBlurb =>
      'पढ़ने में मुश्किल हो तो टेक्स्ट बड़ा करें।';

  @override
  String get settingsTextSizeNormal => 'सामान्य';

  @override
  String get settingsTextSizeLarge => 'बड़ा';

  @override
  String get settingsTextSizeLarger => 'और बड़ा';

  @override
  String get matchPreviewAllMeetings => 'सभी मुक़ाबले';

  @override
  String get recordsMeetings => 'मुक़ाबले';

  @override
  String get recordsLegends => 'दिग्गज';

  @override
  String get recordsAllTimeXi => 'ऑल-टाइम XI';

  @override
  String get recordsHallOfFame => 'हॉल ऑफ़ फ़ेम';

  @override
  String get recordsAllTimeWorld => 'ऑल-टाइम विश्व';

  @override
  String get recordsAllTimeTopScorers => 'ऑल-टाइम टॉप स्कोरर';

  @override
  String get recordsMostCapped => 'सबसे ज़्यादा कैप';

  @override
  String get recordsMostWcStarts => 'विश्व चैंपियनशिप स्टार्ट';

  @override
  String get recordsMostTournaments => 'सबसे ज़्यादा टूर्नामेंट में भागीदारी';

  @override
  String get recordsRecordBook => 'रिकॉर्ड बुक';

  @override
  String get recordsHeadToHead => 'आमने-सामने';

  @override
  String get recordsFiercestRival => 'कट्टर प्रतिद्वंद्वी';

  @override
  String get recordsMostCaps => 'सबसे ज़्यादा कैप';

  @override
  String get recordsTopScorers => 'टॉप स्कोरर';

  @override
  String get recordsMostAssists => 'सबसे ज़्यादा असिस्ट';

  @override
  String get recordsYourRecord => 'आपका रिकॉर्ड';

  @override
  String get callUpHome => 'घरेलू';

  @override
  String get callUpAway => 'बाहर';

  @override
  String get recordsHome => 'घरेलू';

  @override
  String get recordsAway => 'बाहर';

  @override
  String get recordsActive => 'सक्रिय';

  @override
  String get recordsStillActive => 'अब भी सक्रिय';

  @override
  String get recordsAvg => 'औसत';

  @override
  String get recordsSelect => 'चुनें';

  @override
  String get recordsVs => 'बनाम';

  @override
  String get recordsDraws => 'ड्रॉ';

  @override
  String get recordsGoalsLabel => 'गोल';

  @override
  String get recordsBestFinish => 'सर्वश्रेष्ठ प्रदर्शन';

  @override
  String get recordsNoFinalsYet => 'अब तक फ़ाइनल्स में नहीं';

  @override
  String get recordsLongestUnbeaten => 'सबसे लंबी अपराजित लय';

  @override
  String get recordsBiggestWin => 'सबसे बड़ी जीत';

  @override
  String get recordsSeeAllMeetings => 'सभी मुक़ाबले देखें';

  @override
  String get recordsSaveNotFound => 'सेव नहीं मिला।';

  @override
  String get recordsNoMatches => 'कोई मैच नहीं।';

  @override
  String get recordsSearchPlayerOrNation => 'खिलाड़ी या देश खोजें';

  @override
  String get recordsSearchNation => 'देश खोजें';

  @override
  String get recordsPickTwoDifferent => 'दो अलग-अलग देश चुनें।';

  @override
  String get recordsPlayToBuildRecord =>
      'कुछ मैच खेलें, हर प्रतिद्वंद्वी के ख़िलाफ़ आपका रिकॉर्ड यहाँ बनेगा।';

  @override
  String get recordsTapOpponent =>
      'पूरा ब्योरा देखने के लिए किसी प्रतिद्वंद्वी पर टैप करें।';

  @override
  String get recordsEdgeUpperHand => 'आपका पलड़ा भारी है';

  @override
  String get recordsEdgeTheirNumber => 'उनके सामने आप कमज़ोर हैं';

  @override
  String get recordsEdgeEven => 'बराबरी का मुक़ाबला';

  @override
  String get recordsAllTimeWorldSubtitle =>
      'दुनिया भर के स्कोरर और सबसे ज़्यादा कैप, हर देश के';

  @override
  String get recordsHeadToHeadSubtitle =>
      'किन्हीं भी दो देशों का ऑल-टाइम रिकॉर्ड तुलना करें';

  @override
  String get recordsLegendsSubtitle => 'ऑल-टाइम XI और हॉल ऑफ़ फ़ेम';

  @override
  String get recordsUnitGoals => 'गोल';

  @override
  String get recordsUnitCaps => 'कैप';

  @override
  String get recordsUnitStarts => 'स्टार्ट';

  @override
  String get recordsUnitCups => 'कप';

  @override
  String get recordsUnitAssists => 'असिस्ट';

  @override
  String recordsCapsCount(int count) {
    return '$count कैप';
  }

  @override
  String recordsGoalsCount(int count) {
    return '$count गोल';
  }

  @override
  String recordsAssistsCount(int count) {
    return '$count असिस्ट';
  }

  @override
  String recordsMotmCount(int count) {
    return '$count MOTM';
  }

  @override
  String recordsMatchesCount(int count) {
    return '$count मैच';
  }

  @override
  String recordsMeetingsCount(int count) {
    return '$count मुक़ाबले';
  }

  @override
  String recordsCodeWins(String code) {
    return '$code की जीत';
  }

  @override
  String recordsMeetingsWdl(int meetings, int wins, int draws, int losses) {
    return '$meetings मुक़ाबले · ${wins}W ${draws}D ${losses}L';
  }

  @override
  String recordsWdl(int wins, int draws, int losses) {
    return '${wins}W ${draws}D ${losses}L';
  }

  @override
  String recordsRivalLine(int meetings, String record, String edge) {
    return '$meetings मुक़ाबले · $record · $edge';
  }

  @override
  String recordsNeverMet(String a, String b) {
    return 'इस सेव में $a और $b कभी आमने-सामने नहीं हुए।';
  }

  @override
  String tacticsSentOffNote(String names) {
    return '$names को बाहर भेजा गया। कोई रिप्लेसमेंट नहीं, इसलिए आप एक खिलाड़ी कम से खेलेंगे।';
  }

  @override
  String tacticsNeedFitPlayers(int required, int have) {
    return '$required उपलब्ध चाहिए ($have फ़िट)';
  }

  @override
  String tacticsMissesOfCamp(int missed, int total) {
    return '$missed/$total मैच नहीं खेल पाएँगे';
  }

  @override
  String get tacticsOutForWholeCamp => 'पूरे कॉल-अप में बाहर';

  @override
  String get rankingCentreOnMe => 'मेरे देश पर लौटें';

  @override
  String get recordsAfterExtraTime => 'एक्स्ट्रा टाइम';

  @override
  String recordsOnPenalties(int a, int b) {
    return '$a–$b पेनल्टी';
  }

  @override
  String recordsVersus(String a, String b) {
    return '$a बनाम $b';
  }

  @override
  String recordsPlayedScore(int played, int gf, int ga) {
    return '$played खेले · $gf–$ga';
  }

  @override
  String recordsBiggestWinValue(int gf, int ga, String opp) {
    return '$gf–$ga बनाम $opp';
  }

  @override
  String recordsCouldNotLoad(String error) {
    return 'लोड नहीं हो सका।\n$error';
  }

  @override
  String recordsCouldNotLoadLegends(String error) {
    return 'दिग्गज लोड नहीं हो सके।\n$error';
  }

  @override
  String recordsCouldNotLoadRecords(String error) {
    return 'रिकॉर्ड लोड नहीं हो सके।\n$error';
  }

  @override
  String recordsCouldNotLoadNations(String error) {
    return 'देशों की सूची लोड नहीं हो सकी।\n$error';
  }

  @override
  String recordsCouldNotLoadYourRecord(String error) {
    return 'आपका रिकॉर्ड लोड नहीं हो सका।\n$error';
  }

  @override
  String recordsCouldNotLoadRecord(String error) {
    return 'रिकॉर्ड लोड नहीं हो सका।\n$error';
  }

  @override
  String recordsNoLegends(String nation) {
    return 'अभी कोई दिग्गज नहीं। कुछ सीज़न खेलें और $nation के महान खिलाड़ी यहाँ उभरेंगे।';
  }

  @override
  String recordsGreatestSide(String nation) {
    return '$nation अब तक की सबसे बेहतरीन टीम उतार सकता है, यही है।';
  }

  @override
  String get recordsNoWorldHistory =>
      'दुनिया का अभी कोई इतिहास नहीं। कुछ सीज़न खेलें और ऑल-टाइम महान खिलाड़ी यहाँ दिखेंगे।';

  @override
  String recordsPlayToWriteHistory(String nation) {
    return '$nation का इतिहास लिखना शुरू करने के लिए कुछ मैच खेलें।';
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
  String get tacticsGoalkeepers => 'गोलकीपर';

  @override
  String get tacticsDefenders => 'डिफ़ेंडर';

  @override
  String get tacticsMidfielders => 'मिडफ़ील्डर';

  @override
  String get tacticsForwards => 'फ़ॉरवर्ड';

  @override
  String get tacticsCallUpsTitle => 'कॉल-अप';

  @override
  String tacticsPickAtLeastPlayers(int min) {
    return 'कम से कम $min खिलाड़ी चुनें।';
  }

  @override
  String tacticsCouldNotLoadSquad(String error) {
    return 'स्क्वॉड लोड नहीं हो सका।\n$error';
  }

  @override
  String get tacticsNoSquad => 'कोई स्क्वॉड नहीं।';

  @override
  String tacticsSquadCount(int count, int max) {
    return 'स्क्वॉड · $count/$max';
  }

  @override
  String tacticsMinMax(int min, int max) {
    return 'न्यूनतम $min · अधिकतम $max';
  }

  @override
  String get tacticsBestQuality => 'सर्वश्रेष्ठ क्वालिटी';

  @override
  String get tacticsPreviousSquad => 'पिछला स्क्वॉड';

  @override
  String get tacticsSquadLockedBack => 'वापस (स्क्वॉड लॉक)';

  @override
  String get tacticsConfirmSquad => 'स्क्वॉड पक्का करें';

  @override
  String tacticsSquadFullMax(int max) {
    return 'स्क्वॉड पूरा (अधिकतम $max)';
  }

  @override
  String get tacticsSquadLocked => 'स्क्वॉड लॉक';

  @override
  String get tacticsNominationOpen => 'नामांकन खुला है। अपना स्क्वॉड चुनें';

  @override
  String get tacticsSquadFixedBlurb =>
      'नीचे के मैचों के लिए यह स्क्वॉड तय है। अगली नामांकन विंडो से पहले दोबारा चुनें।';

  @override
  String get tacticsSquadWillPlayBlurb => 'यह स्क्वॉड नीचे के मैच खेलेगा।';

  @override
  String get tacticsUnknown => 'अज्ञात';

  @override
  String tacticsAgeValue(int age, String value) {
    return 'उम्र $age · $value';
  }

  @override
  String get tacticsFatigueExhausted => 'पस्त';

  @override
  String get tacticsFatigueTired => 'थका हुआ';

  @override
  String get tacticsFatigueMatchLegs => 'मैच की थकान';

  @override
  String tacticsTooManySubs(int max) {
    return 'बहुत ज़्यादा सब्स्टीट्यूशन (अधिकतम $max)।';
  }

  @override
  String tacticsMinuteTitle(int minute) {
    return 'टैक्टिक्स · $minute\'';
  }

  @override
  String get tacticsApply => 'लागू करें';

  @override
  String get tacticsTabLineupSubs => 'लाइनअप और सब';

  @override
  String get tacticsTabTactics => 'टैक्टिक्स';

  @override
  String get squadLineKeepers => 'गोलकीपर';

  @override
  String get squadLineDefenders => 'डिफ़ेंस';

  @override
  String get squadLineMidfielders => 'मिडफ़ील्ड';

  @override
  String get squadLineForwards => 'अटैक';

  @override
  String get squadStatXiRating => 'XI रेटिंग';

  @override
  String get squadStatAvgAge => 'औसत उम्र';

  @override
  String get squadStatSize => 'स्क्वॉड';

  @override
  String get squadStatUnavailable => 'बाहर';

  @override
  String get squadDepthTitle => 'लाइन के हिसाब से गहराई';

  @override
  String squadAgeShort(int age) {
    return '$age वर्ष';
  }

  @override
  String get tacticsTabOtherPositions => 'अन्य पोज़ीशन';

  @override
  String get tacticsOutOfPositionNote => 'यहाँ ग़ैर-स्वाभाविक पोज़ीशन पर';

  @override
  String get tacticsNobodyElse => 'यहाँ आज़माने को कोई और नहीं।';

  @override
  String get tacticsPickSomebodyFirst =>
      'चुनें कौन बाहर जाएगा, बाक़ी बेंच और यहाँ खेलने पर उनकी रेटिंग यहीं दिखेगी।';

  @override
  String get tacticsTabSuitable => 'उपयुक्त';

  @override
  String get tacticsTabOnPitch => 'मैदान पर';

  @override
  String tacticsSectionSuitable(int count) {
    return 'उपयुक्त · $count';
  }

  @override
  String get tacticsNobodySuits =>
      'बेंच पर कोई स्वाभाविक रूप से इस पोज़ीशन के लायक़ नहीं, इसलिए सभी यहाँ हैं।';

  @override
  String tacticsSectionOnPitch(int count, int max) {
    return 'मैदान पर · $count/$max';
  }

  @override
  String tacticsSectionAvailable(int count) {
    return 'उपलब्ध · $count';
  }

  @override
  String get tacticsRowStarted => 'शुरुआती XI';

  @override
  String tacticsRowCameOn(int minute) {
    return '$minute\' पर आए';
  }

  @override
  String get tacticsRowSubstitute => 'बदले में आए';

  @override
  String get tacticsEnergyLabel => 'एनर्जी';

  @override
  String tacticsPickReplacementFor(String name) {
    return '$name की जगह बदलाव चुनें, या रद्द करने के लिए उसे दोबारा टैप करें।';
  }

  @override
  String get tacticsSlotLostToRedCard =>
      'रेड कार्ड से यह जगह चली गई। गैप भरने के लिए किसी साथी को यहाँ खींचें।';

  @override
  String get tacticsSentOffShort => 'बाहर भेजा गया';

  @override
  String get tacticsFullBackLeft => 'लेफ्ट-बैक';

  @override
  String get tacticsFullBackRight => 'राइट-बैक';

  @override
  String get tacticsFullBackUp => 'आगे बढ़ें';

  @override
  String get tacticsFullBackDown => 'पीछे रहें';

  @override
  String get tacticsFullBackOff => 'कोई निर्देश नहीं';

  @override
  String tacticsFullBackUpHint(String side) {
    return '$side: आगे बढ़ें। थोड़ा ज़्यादा आक्रमण, थोड़ा ज़्यादा जोखिम।';
  }

  @override
  String tacticsFullBackDownHint(String side) {
    return '$side: पीछे रहें। थोड़ा ज़्यादा सुरक्षित, थोड़ा कम आक्रमण।';
  }

  @override
  String tacticsFullBackOffHint(String side) {
    return '$side: कोई निर्देश नहीं, टीम की योजना से खेलेगा।';
  }

  @override
  String tacticsFullBackSemantics(String side, String state) {
    return '$side तीर: $state';
  }

  @override
  String tacticsSubsUsed(int used, int max) {
    return 'सब · $used/$max';
  }

  @override
  String get tacticsDragSubOn =>
      'किसी खिलाड़ी को बाहर करने के लिए मैदान पर टैप करें, या सब को पकड़कर उस पर खींचें।';

  @override
  String get tacticsNoSubs => 'कोई सब्स्टीट्यूट उपलब्ध नहीं।';

  @override
  String get tacticsChooseShape => 'फ़ॉर्मेशन चुनें';

  @override
  String get tacticsFormation => 'फ़ॉर्मेशन';

  @override
  String get tacticsInstructions => 'निर्देश';

  @override
  String get tacticsDrilling => 'तालमेल';

  @override
  String get tacticsDrillingUnplayed => 'आज़माया नहीं';

  @override
  String get tacticsDrillingNew => 'नया';

  @override
  String get tacticsDrillingSettling => 'जम रहा';

  @override
  String get tacticsDrillingDrilled => 'पक्का';

  @override
  String get tacticsInstrMentality => 'मानसिकता';

  @override
  String get tacticsInstrDefensive => 'डिफ़ेंसिव';

  @override
  String get tacticsInstrAttacking => 'अटैकिंग';

  @override
  String get tacticsInstrPressing => 'प्रेसिंग';

  @override
  String get tacticsInstrLowBlock => 'लो ब्लॉक';

  @override
  String get tacticsInstrHighPress => 'हाई प्रेस';

  @override
  String get tacticsInstrTempo => 'टेम्पो';

  @override
  String get tacticsInstrPatient => 'धैर्यपूर्ण';

  @override
  String get tacticsInstrFast => 'तेज़';

  @override
  String get tacticsInstrWidth => 'चौड़ाई';

  @override
  String get tacticsInstrNarrow => 'संकरा';

  @override
  String get tacticsInstrWide => 'चौड़ा';

  @override
  String get tacticsInstrDefLine => 'डिफ़. लाइन';

  @override
  String get tacticsInstrDefensiveLine => 'डिफ़ेंसिव लाइन';

  @override
  String get tacticsInstrDeep => 'गहरी';

  @override
  String get tacticsInstrHigh => 'ऊँची';

  @override
  String get tacticsInstrDirectness => 'सीधापन';

  @override
  String get tacticsInstrPossession => 'पज़ेशन';

  @override
  String get tacticsInstrDirect => 'सीधा';

  @override
  String get tacticsPickGoalkeeper => 'गोलकीपर चुनें';

  @override
  String get tacticsPickLeftBack => 'लेफ़्ट बैक चुनें';

  @override
  String get tacticsPickCentreBack => 'सेंटर बैक चुनें';

  @override
  String get tacticsPickRightBack => 'राइट बैक चुनें';

  @override
  String get tacticsPickDefensiveMid => 'डिफ़ेंसिव मिड चुनें';

  @override
  String get tacticsPickCentralMid => 'सेंट्रल मिड चुनें';

  @override
  String get tacticsPickAttackingMid => 'अटैकिंग मिड चुनें';

  @override
  String get tacticsPickLeftMid => 'लेफ़्ट मिड चुनें';

  @override
  String get tacticsPickRightMid => 'राइट मिड चुनें';

  @override
  String get tacticsPickLeftWing => 'लेफ़्ट विंग चुनें';

  @override
  String get tacticsPickRightWing => 'राइट विंग चुनें';

  @override
  String get tacticsPickStriker => 'स्ट्राइकर चुनें';

  @override
  String tacticsRoleOutOfPosition(String role) {
    return '$role · ग़लत पोज़ीशन पर';
  }

  @override
  String tacticsAgeOnly(int age) {
    return 'उम्र $age';
  }

  @override
  String tacticsRoleAge(String role, int age) {
    return '$role · उम्र $age';
  }

  @override
  String get tacticsOn => 'मैदान पर';

  @override
  String get tacticsSquad => 'स्क्वॉड';

  @override
  String get tacticsTabLineup => 'लाइनअप';

  @override
  String get tacticsTabInstructions => 'निर्देश';

  @override
  String get tacticsTabRoles => 'रोल';

  @override
  String get tacticsTabSetPieces => 'सेट पीस';

  @override
  String get tacticsTabRolesSetPieces => 'रोल और सेट पीस';

  @override
  String get tacticsRolesSetPiecesBlurb =>
      'हर स्टार्टर को एक रोल दें। टेकर तय करने के लिए पेनल्टी (⚽) या फ़्री-किक (▲) बैज पर टैप करें।';

  @override
  String get tacticsTooltipCallUps => 'कॉल-अप';

  @override
  String get tacticsTooltipPresets => 'टैक्टिक प्रीसेट';

  @override
  String get tacticsTooltipInstructions => 'निर्देश';

  @override
  String get tacticsNoTacticSet => 'कोई टैक्टिक तय नहीं।';

  @override
  String tacticsReplaceStarters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count स्टार्टर बदलें',
      one: '$count स्टार्टर बदलें',
    );
    return '$_temp0';
  }

  @override
  String tacticsPlayerOut(String name, String reason) {
    return '$name: $reason';
  }

  @override
  String get tacticsOut => 'बाहर';

  @override
  String get tacticsTapSpotReplace =>
      'रिप्लेसमेंट चुनने के लिए मैदान पर उनकी जगह टैप करें।';

  @override
  String get tacticsTapOrDrag =>
      'खिलाड़ी को बाहर करने के लिए टैप करें, या पकड़कर खींचकर जगह बदलें।';

  @override
  String get tacticsPlayerRoles => 'खिलाड़ियों के रोल';

  @override
  String get tacticsRolesBlurb =>
      'खिलाड़ी को काम सौंपें: पोचर, प्लेमेकर, टारगेट मैन। इससे तय होता है कि कौन गोल करेगा और कौन मौक़े बनाएगा।';

  @override
  String get tacticsSetPieceTakers => 'सेट-पीस टेकर';

  @override
  String get tacticsSetPieceBlurb =>
      'पेनल्टी और डेड बॉल कौन लेगा, या सबसे उपयुक्त खिलाड़ी पर छोड़ दें।';

  @override
  String get tacticsTakerAuto => 'ऑटोमैटिक';

  @override
  String get tacticsTakerQuickPick => 'सर्वश्रेष्ठ टेकर लगाएँ';

  @override
  String get tacticsPenalties => 'पेनल्टी';

  @override
  String get tacticsCornersFreeKicks => 'कॉर्नर और फ़्री-किक';

  @override
  String get tacticsSkillFin => 'फ़िन';

  @override
  String get tacticsSkillPas => 'पास';

  @override
  String tacticsRolePlayer(String name) {
    return 'रोल · $name';
  }

  @override
  String get tacticsPenaltyTaker => 'पेनल्टी टेकर';

  @override
  String get tacticsCornerFreeKickTaker => 'कॉर्नर और फ़्री-किक टेकर';

  @override
  String get tacticsAutomatic => 'ऑटोमैटिक';

  @override
  String get tacticsLetBestSuited => 'सबसे उपयुक्त खिलाड़ी को लेने दें।';

  @override
  String get tacticsInXi => 'XI में';

  @override
  String get tacticsTeamInstructions => 'टीम निर्देश';

  @override
  String get tacticsTeamInstructionsBlurb =>
      'तय करें कि आपकी टीम कैसे खेले। हर डायल पूरी टीम को प्रभावित करता है।';

  @override
  String tacticsSavedPreset(String name) {
    return '“$name” सेव हुआ';
  }

  @override
  String tacticsAppliedPreset(String name) {
    return '“$name” लागू हुआ';
  }

  @override
  String get tacticsTacticPresets => 'टैक्टिक प्रीसेट';

  @override
  String get tacticsPresetsBlurb =>
      'इस शेप को दोबारा इस्तेमाल होने वाले स्टाइल के रूप में सेव करें, या पहले सेव किया हुआ लागू करें।';

  @override
  String get tacticsSaveCurrentTactic => 'मौजूदा टैक्टिक सेव करें';

  @override
  String tacticsCouldNotLoadPresets(String error) {
    return 'प्रीसेट लोड नहीं हो सके।\n$error';
  }

  @override
  String get tacticsNoPresetsYet =>
      'अभी कोई प्रीसेट नहीं। इस सेटअप को दोबारा इस्तेमाल के लिए रखने को “मौजूदा टैक्टिक सेव करें” पर टैप करें।';

  @override
  String get tacticsNameThisTactic => 'इस टैक्टिक को नाम दें';

  @override
  String get tacticsNameHint => 'जैसे हाई प्रेस 4-3-3';

  @override
  String get tacticsCancel => 'रद्द करें';

  @override
  String get tacticsSave => 'सेव करें';

  @override
  String get tacticsTapToAssign => 'रोल देने के लिए टैप करें';

  @override
  String get tacticsHoldDragSub =>
      'सब को पकड़ें, फिर मैदान पर आने के लिए उसे किसी खिलाड़ी पर खींचें।';

  @override
  String get hubContinue => 'जारी रखें';

  @override
  String get hubBrackets => 'ब्रैकेट';

  @override
  String hubCouldNotLoad(String error) {
    return 'लोड नहीं हो सका।\n$error';
  }

  @override
  String hubCouldNotLoadFinances(String error) {
    return 'वित्त लोड नहीं हो सका।\n$error';
  }

  @override
  String hubCouldNotLoadSave(String error) {
    return 'सेव लोड नहीं हो सका।\n$error';
  }

  @override
  String get hubSaveNotFound => 'सेव नहीं मिला।';

  @override
  String get hubUnknown => 'अज्ञात';

  @override
  String hubWorldChampionsYear(int year) {
    return '$year विश्व चैंपियन';
  }

  @override
  String get hubCycleComplete => 'चक्र पूरा हो गया।';

  @override
  String get hubYourJob => 'आपकी नौकरी';

  @override
  String get hubStayProject => 'रुकें और अपना प्रोजेक्ट जारी रखें';

  @override
  String get hubChooseNextJob => 'अपनी अगली नौकरी चुनें';

  @override
  String get hubOffersOnTable => 'सामने मौजूद ऑफ़र';

  @override
  String hubOfferSubtitle(String tier, int position) {
    return '$tier · विश्व #$position';
  }

  @override
  String hubContinueWith(String nation) {
    return '$nation के साथ जारी रखें';
  }

  @override
  String get hubYourNation => 'आपका देश';

  @override
  String get hubTakeTheJob => 'नौकरी स्वीकारें';

  @override
  String get hubFederationFinances => 'फ़ेडरेशन का वित्त';

  @override
  String get hubBudgetIntro =>
      'अगले चक्र में आपका पहला काम फ़ेडरेशन का बजट तय करना और उसे विभागों में बाँटना है।';

  @override
  String get hubStarting => 'शुरू हो रहा है…';

  @override
  String get hubBeginNextCycle => 'अगला चक्र शुरू करें';

  @override
  String get hubContinueCareer => 'अपना करियर जारी रखें';

  @override
  String get hubBackToSaves => 'अपने सेव पर लौटें';

  @override
  String get hubOpeningBalance => 'शुरुआती बैलेंस';

  @override
  String get hubCentralFunding => 'केंद्रीय फ़ंडिंग';

  @override
  String get hubPrizeMoney => 'इनामी राशि';

  @override
  String get hubCommercialReturn => 'कमर्शियल आय';

  @override
  String get hubAvailableToInvest => 'निवेश के लिए उपलब्ध';

  @override
  String hubReputation(String label, int rep) {
    return 'प्रतिष्ठा: $label ($rep)';
  }

  @override
  String get hubNationalHero => 'राष्ट्रीय हीरो';

  @override
  String get hubFinal => 'फ़ाइनल';

  @override
  String get hubStageRoundOf32 => 'राउंड ऑफ़ 32';

  @override
  String get hubStageThirdPlace => 'तीसरे स्थान का प्ले-ऑफ़';

  @override
  String get hubEventAdvanceWorld => 'दुनिया को आगे बढ़ाएँ';

  @override
  String hubEventStartCycle(int year) {
    return '$year चक्र शुरू करें';
  }

  @override
  String hubEventWorldChampions(String nation) {
    return '$nation विश्व चैंपियन हैं';
  }

  @override
  String get hubEventSetBudget => 'अपना फ़ेडरेशन बजट तय करें';

  @override
  String get hubEventSetBudgetSub =>
      'सीज़न शुरू होने से पहले इस चक्र का ख़ज़ाना बाँटें';

  @override
  String get hubEventNaturalization => 'नागरिकता प्रस्ताव देखें';

  @override
  String get hubEventNaturalizationSub =>
      'एक विदेशी खिलाड़ी आपके लिए खेलना चाहता है';

  @override
  String get hubEventCampaignVerdict => 'कैंपेन तय: नतीजा देखें';

  @override
  String get hubEventCampaignComplete => 'कैंपेन पूरा';

  @override
  String get hubEventIntercontinentalPlayoff => 'अंतर-महाद्वीपीय प्ले-ऑफ़';

  @override
  String get hubEventWatchWcDraw => 'विश्व चैंपियनशिप का ड्रॉ देखें';

  @override
  String get hubEventWorldCupHere => 'विश्व चैंपियनशिप आ गई है';

  @override
  String get hubEventWatchFinalsDraw => 'फ़ाइनल्स का ड्रॉ देखें';

  @override
  String get hubEventFinalsHere => 'फ़ाइनल्स आ गए हैं';

  @override
  String get hubEventPlayWcRound => 'विश्व चैंपियनशिप का अगला राउंड खेलें';

  @override
  String hubEventPlayCupMatch(String cup) {
    return 'अगला $cup मैच खेलें';
  }

  @override
  String get hubEventPlayNationsCupMatch => 'नेशंस कप का अगला मैच खेलें';

  @override
  String get hubEventWatchNationsCupDraw => 'नेशंस कप का ड्रॉ देखें';

  @override
  String get hubEventWatchHostSelection => 'मेज़बान का चयन देखें';

  @override
  String get hubEventWatchQualifyingDraw => 'क्वालिफ़ाइंग ड्रॉ देखें';

  @override
  String get hubEventWatchWcHostSelection =>
      'विश्व चैंपियनशिप के मेज़बान का चयन देखें';

  @override
  String get hubEventWatchWcQualifyingDraw =>
      'विश्व चैंपियनशिप का क्वालिफ़ाइंग ड्रॉ देखें';

  @override
  String get hubEventArrangeFriendlies => 'दोस्ताना मैच तय करें';

  @override
  String hubEventFriendliesSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'आपकी $count खुली दोस्ताना मैच विंडो अभी भरी नहीं हैं',
      one: 'आपकी खुली दोस्ताना मैच विंडो अभी भरी नहीं है',
    );
    return '$_temp0';
  }

  @override
  String get hubEventReshapeXi => 'अपना शुरुआती XI दोबारा बनाएँ';

  @override
  String hubEventReshapeOutSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'आपके XI के $count खिलाड़ी बाहर हैं (सस्पेंड या चोटिल)। उनके विकल्प चुनें',
      one: 'आपके XI का 1 खिलाड़ी बाहर है (सस्पेंड या चोटिल)। उसका विकल्प चुनें',
    );
    return '$_temp0';
  }

  @override
  String hubEventReshapeShortSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'आपका शुरुआती XI अधूरा है। ख़ाली जगहें भरें',
      one: 'आपका शुरुआती XI अधूरा है। ख़ाली जगह भरें',
    );
    return '$_temp0';
  }

  @override
  String hubEventPlayOpponent(String opponent) {
    return '$opponent से खेलें';
  }

  @override
  String get hubEventContinentalFinalsFallback => 'महाद्वीपीय फ़ाइनल्स';

  @override
  String get hubCallUpFriendlies => 'दोस्ताना मैचों के लिए अपना स्क्वॉड चुनें';

  @override
  String get hubCallUpRequalify => 'अपना क्वालिफ़ाइंग स्क्वॉड दोबारा चुनें';

  @override
  String get hubCallUpWorldCup => 'अपना विश्व चैंपियनशिप स्क्वॉड चुनें';

  @override
  String get hubCallUpFinals => 'फ़ाइनल्स के लिए अपना स्क्वॉड चुनें';

  @override
  String get hubCallUpNationsCup => 'अपना नेशंस कप स्क्वॉड चुनें';

  @override
  String get hubCallUpQualifying => 'अपना क्वालिफ़ाइंग स्क्वॉड चुनें';

  @override
  String get hubCallUpGeneric => 'अपना स्क्वॉड चुनें';

  @override
  String get hubHost => 'मेज़बान';

  @override
  String get hubGoldenBoot => 'गोल्डन बूट';

  @override
  String hubGoldenBootValue(String name, int goals) {
    return '$name · $goals गोल';
  }

  @override
  String get hubPens => '(पेनल्टी)';

  @override
  String get hubNationalHub => 'राष्ट्रीय हब';

  @override
  String get hubMessages => 'संदेश';

  @override
  String get hubWorldChampions => 'विश्व चैंपियन';

  @override
  String get hubViewBracket => 'ब्रैकेट देखें ›';

  @override
  String get hubBoardDelighted => 'बेहद ख़ुश';

  @override
  String get hubBoardPleased => 'ख़ुश';

  @override
  String get hubBoardExpectingMore => 'और की उम्मीद';

  @override
  String get hubBoardConcerned => 'चिंतित';

  @override
  String get hubBoardJobAtRisk => 'नौकरी ख़तरे में';

  @override
  String get hubBoard => 'बोर्ड';

  @override
  String hubBoardObjective(String label) {
    return 'बोर्ड का लक्ष्य: $label';
  }

  @override
  String hubObjectiveMet(String result) {
    return 'पूरा · $result';
  }

  @override
  String hubObjectiveMissed(String result) {
    return 'चूके · $result';
  }

  @override
  String get hubNoMoreFixtures => 'इस चक्र में कोई और मैच नहीं।';

  @override
  String get hubVs => 'बनाम';

  @override
  String hubWorldRank(int rank) {
    return '#$rank';
  }

  @override
  String get hubWorldRankLabel => 'विश्व रैंकिंग';

  @override
  String get hubSquadStatus => 'स्क्वॉड की स्थिति';

  @override
  String hubPlayers(int count) {
    return '$count खिलाड़ी';
  }

  @override
  String get hubAvgRating => 'औसत रेटिंग';

  @override
  String get hubMorale => 'मनोबल';

  @override
  String get hubManageTeam => 'टीम संभालें';

  @override
  String get hubGroupsToBeDrawn =>
      'ग्रुप का ड्रॉ बाक़ी है। उन्हें देखने के लिए ड्रॉ देखें।';

  @override
  String hubGroupName(String name) {
    return 'ग्रुप $name';
  }

  @override
  String get hubTblTeam => 'टीम';

  @override
  String get hubTblP => 'P';

  @override
  String get hubTblGd => 'GD';

  @override
  String get hubTblPts => 'अंक';

  @override
  String get homeSettings => 'सेटिंग्स';

  @override
  String get homeLeadTheNation => 'देश की अगुवाई करें';

  @override
  String get homeYourNation => 'आपका देश';

  @override
  String get homeNewGame => 'नया गेम';

  @override
  String get homeAllSaves => 'सभी सेव';

  @override
  String get homeLoadGame => 'गेम लोड करें';

  @override
  String get homeContinue => 'जारी रखें';

  @override
  String homeRoadToWorldCup(String date, int year) {
    return '$date · $year विश्व चैंपियनशिप की राह';
  }

  @override
  String get careerManageSaves => 'सेव प्रबंधित करें';

  @override
  String get careerNewGameTitle => 'नया गेम';

  @override
  String careerCouldNotLoadNation(String error) {
    return 'देश लोड नहीं हो सका।\n$error';
  }

  @override
  String get careerNationNotFound => 'देश नहीं मिला।';

  @override
  String careerWorldRankNum(int rank) {
    return 'विश्व रैंक #$rank';
  }

  @override
  String get careerManagerName => 'मैनेजर का नाम';

  @override
  String get careerManagerNameHint => 'जैसे एलेक्स फ़र्ग्युसन';

  @override
  String get careerBeginsBlurb =>
      'आपका करियर सितंबर 2026 में शुरू होता है, 2030 विश्व चैंपियनशिप की राह पर।';

  @override
  String get careerFreeCycleNote =>
      'पूरे चार साल के एक चक्र के लिए मुफ़्त: क्वालिफ़ाइंग, आपकी महाद्वीपीय चैंपियनशिप और विश्व चैंपियनशिप, दो सेव पर। इसके बाद एक बार भुगतान करने पर अनंत चक्र खुल जाते हैं।';

  @override
  String get careerStartCareer => 'करियर शुरू करें';

  @override
  String get careersTitle => 'करियर';

  @override
  String get careerManagerCareer => 'मैनेजर करियर';

  @override
  String get careerManagerCareerSubtitle =>
      'आपके संभाले हर चक्र और कुल रिकॉर्ड';

  @override
  String get careerSummaryTitle => 'करियर सारांश';

  @override
  String get careerSummarySubtitle => 'आपकी ट्रॉफ़ी अलमारी और मैनेजर रिकॉर्ड';

  @override
  String get careerAchievements => 'उपलब्धियाँ';

  @override
  String get careerAchievementsSubtitle =>
      'मील के पत्थर, ख़िताब और बोर्ड की संतुष्टि';

  @override
  String get careerChallenges => 'चुनौतियाँ';

  @override
  String get careerChallengesSubtitle =>
      'पूरे करियर की कठिन परीक्षाएँ, जो आप ले सकते हैं';

  @override
  String get careerTeamRecords => 'टीम रिकॉर्ड';

  @override
  String get careerTeamRecordsSubtitle =>
      'सर्वकालिक टॉप स्कोरर और मैचों की संख्या';

  @override
  String get careerMyMatches => 'मेरे मैच';

  @override
  String get careerMyMatchesSubtitle => 'हर नतीजा और आगामी मुक़ाबला';

  @override
  String get careerTitle => 'करियर';

  @override
  String careerCouldNotLoadCareer(String error) {
    return 'करियर लोड नहीं हो सका।\n$error';
  }

  @override
  String get careerNoCareer => 'कोई करियर नहीं।';

  @override
  String get careerTrophyCabinet => 'ट्रॉफ़ी अलमारी';

  @override
  String get careerTournamentHistory => 'टूर्नामेंट इतिहास';

  @override
  String get careerNoTournamentsYet => 'अभी तक कोई टूर्नामेंट पूरा नहीं हुआ।';

  @override
  String get careerTeamFallback => 'टीम';

  @override
  String careerWorldNum(int rank) {
    return 'विश्व #$rank';
  }

  @override
  String careerPointsNum(int points) {
    return '$points अंक';
  }

  @override
  String careerSeasonNum(int season) {
    return 'सीज़न $season';
  }

  @override
  String get careerStatPlayedShort => 'P';

  @override
  String get careerStatsHeading => 'आँकड़ों में';

  @override
  String get careerStatsWinRate => 'जीत दर';

  @override
  String get careerStatsGoalsFor => 'किए गोल';

  @override
  String get careerStatsGoalsAgainst => 'खाए गोल';

  @override
  String get careerStatsGoalDiff => 'गोल अंतर';

  @override
  String get careerStatsCleanSheets => 'क्लीन शीट';

  @override
  String get careerStatsBiggestWin => 'सबसे बड़ी जीत';

  @override
  String get careerStatsWinStreak => 'जीत का सिलसिला';

  @override
  String get careerStatsUnbeaten => 'अजेय सिलसिला';

  @override
  String get careerStatsShootouts => 'शूटआउट';

  @override
  String get careerStatsHatTricks => 'हैट्रिक';

  @override
  String get careerStatsMotms => 'मैन ऑफ़ द मैच';

  @override
  String get careerStatsBestRating => 'सर्वश्रेष्ठ रेटिंग';

  @override
  String get careerStatWonShort => 'W';

  @override
  String get careerStatDrawnShort => 'D';

  @override
  String get careerStatLostShort => 'L';

  @override
  String get careerStatGoalsForShort => 'GF';

  @override
  String get careerStatGoalsAgainstShort => 'GA';

  @override
  String get careerStatGoalDiffShort => 'GD';

  @override
  String get careerNoSilverware => 'अभी कोई ट्रॉफ़ी नहीं। जाकर एक जीतिए।';

  @override
  String get careerMedalGold => 'स्वर्ण';

  @override
  String get careerMedalSilver => 'रजत';

  @override
  String get careerMedalBronze => 'कांस्य';

  @override
  String careerWinnersName(String name) {
    return 'विजेता: $name';
  }

  @override
  String get careerSavesTitle => 'सेव';

  @override
  String careerCouldNotLoadSaves(String error) {
    return 'सेव लोड नहीं हो सके।\n$error';
  }

  @override
  String careerSlotsCount(int used, int limit) {
    return 'स्लॉट  $used/$limit';
  }

  @override
  String get careerThisSave => 'यह सेव';

  @override
  String get careerSlotsFull => 'स्लॉट भरे हैं';

  @override
  String careerSlotsUsed(int used) {
    return 'स्लॉट  $used';
  }

  @override
  String get careerSlotsUnlockMore => 'और सेव अनलॉक करें';

  @override
  String get careerSlotsKeepNote =>
      'आपके मौजूदा सभी सेव खेलने योग्य रहेंगे। सिर्फ़ नया सेव बनाने के लिए अनलॉक ज़रूरी है।';

  @override
  String get careerNewGame => 'नया गेम';

  @override
  String get careerDeleteSaveTitle => 'सेव हटाएँ?';

  @override
  String careerDeleteSaveBody(String label) {
    return 'इससे आपका $label करियर हमेशा के लिए हट जाएगा।';
  }

  @override
  String get careerCancel => 'रद्द करें';

  @override
  String get careerDelete => 'हटाएँ';

  @override
  String get careerNoSavesYet =>
      'अभी कोई सेव नहीं।\nकिसी देश की कमान संभालने के लिए नया गेम शुरू करें।';

  @override
  String get careerUnknownNation => 'अज्ञात';

  @override
  String careerPlayedMinutes(int minutes) {
    return '$minutesमि';
  }

  @override
  String careerPlayedHours(int hours, int minutes) {
    return '$hoursघं $minutesमि';
  }

  @override
  String careerLastPlayed(String when) {
    return 'आख़िरी बार खेला: $when';
  }

  @override
  String get careerJustNow => 'अभी-अभी';

  @override
  String get careerYesterday => 'कल';

  @override
  String careerMinutesAgo(int n) {
    return '$n मिनट पहले';
  }

  @override
  String careerHoursAgo(int n) {
    return '$n घंटे पहले';
  }

  @override
  String careerDaysAgo(int n) {
    return '$n दिन पहले';
  }

  @override
  String careerRoadToWorldCup(int year) {
    return '$year विश्व चैंपियनशिप की राह';
  }

  @override
  String get careerManagerCareerTitle => 'मैनेजर करियर';

  @override
  String careerCouldNotLoad(String error) {
    return 'लोड नहीं हो सका।\n$error';
  }

  @override
  String get careerCycleByCycle => 'चक्र दर चक्र';

  @override
  String careerCyclesNationsLed(int cycles, int nations) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles चक्र',
      one: '$cycles चक्र',
    );
    String _temp1 = intl.Intl.pluralLogic(
      nations,
      locale: localeName,
      other: '$nations देशों की कमान',
      one: '$nations देश की कमान',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get careerStatTitles => 'ख़िताब';

  @override
  String get careerStatPlayed => 'खेले';

  @override
  String get careerStatWon => 'जीते';

  @override
  String get careerStatDrawn => 'ड्रॉ';

  @override
  String get careerStatLost => 'हारे';

  @override
  String careerGoalsWinRate(
    int goalsFor,
    int goalsAgainst,
    String gd,
    int winRate,
  ) {
    return 'गोल $goalsFor–$goalsAgainst  ($gd)  ·  जीत दर $winRate%';
  }

  @override
  String get careerRecordResults => 'रिकॉर्ड नतीजे';

  @override
  String get careerBestWin => 'सबसे बड़ी जीत';

  @override
  String get careerWorstDefeat => 'सबसे बड़ी हार';

  @override
  String careerVsOpponentDate(String opponent, String date) {
    return 'बनाम $opponent · $date';
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
    return '${won}W ${drawn}D ${lost}L  ·  GF $goalsFor GA $goalsAgainst ($gd)';
  }

  @override
  String get careerWorldCupLabel => 'विश्व चैंपियनशिप';

  @override
  String get careerContinentalLabel => 'महाद्वीपीय';

  @override
  String get messagesTitle => 'संदेश';

  @override
  String get messagesNoMessagesYet => 'अभी कोई संदेश नहीं।';

  @override
  String messagesCouldNotLoad(String error) {
    return 'संदेश लोड नहीं हो सके।\n$error';
  }

  @override
  String get messagesDone => 'हो गया';

  @override
  String get messagesNext => 'आगे';

  @override
  String get rankingWorldRanking => 'विश्व रैंकिंग';

  @override
  String rankingCouldNotLoad(String error) {
    return 'रैंकिंग लोड नहीं हो सकी।\n$error';
  }

  @override
  String get rankingNoRanking => 'कोई रैंकिंग नहीं।';

  @override
  String get rankingAll => 'सभी';

  @override
  String get rankingYourTeam => 'आपकी टीम';

  @override
  String get rankingYourRankingOverTime => 'समय के साथ आपकी रैंकिंग';

  @override
  String rankingNowRank(int rank) {
    return 'अभी #$rank';
  }

  @override
  String rankingBestWorst(int best, int worst) {
    return 'सर्वश्रेष्ठ #$best · सबसे ख़राब #$worst';
  }

  @override
  String get friendliesTitle => 'दोस्ताना मैच';

  @override
  String friendliesLoadError(String error) {
    return 'दोस्ताना मैच लोड नहीं हो सके।\n$error';
  }

  @override
  String get friendliesContinue => 'जारी रखें';

  @override
  String friendliesArrangeIntro(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ख़ाली विंडो',
      one: '$count ख़ाली विंडो',
    );
    return 'अपने अगले प्रतिस्पर्धी मैच से पहले $_temp0 के लिए वॉर्म-अप तय करें। किसी प्रतिद्वंद्वी पर टैप करें, या उसे ख़ाली छोड़ दें।';
  }

  @override
  String get friendliesFree => 'ख़ाली';

  @override
  String matchGoalsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count गोल',
      one: '1 गोल',
    );
    return '$_temp0';
  }

  @override
  String get matchGoalsTitle => 'गोल';

  @override
  String get matchGoalsNone => 'कोई गोल नहीं';

  @override
  String get matchGoalPenalty => 'पेन';

  @override
  String get matchGoalSetPiece => 'सेट';

  @override
  String matchGoalAssist(String name) {
    return 'असिस्ट $name';
  }

  @override
  String get friendliesHome => 'घरेलू';

  @override
  String get friendliesAway => 'बाहर';

  @override
  String get friendliesNoneThisWindow => 'इस विंडो में कोई दोस्ताना मैच नहीं';

  @override
  String friendliesConfirmCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count दोस्ताना मैच',
      one: '$count दोस्ताना मैच',
    );
    return '$_temp0 पक्का करें';
  }

  @override
  String get friendliesMonthJan => 'जन॰';

  @override
  String get friendliesMonthFeb => 'फ़र॰';

  @override
  String get friendliesMonthMar => 'मार्च';

  @override
  String get friendliesMonthApr => 'अप्रैल';

  @override
  String get friendliesMonthMay => 'मई';

  @override
  String get friendliesMonthJun => 'जून';

  @override
  String get friendliesMonthJul => 'जुल॰';

  @override
  String get friendliesMonthAug => 'अग॰';

  @override
  String get friendliesMonthSep => 'सित॰';

  @override
  String get friendliesMonthOct => 'अक्तू॰';

  @override
  String get friendliesMonthNov => 'नव॰';

  @override
  String get friendliesMonthDec => 'दिस॰';

  @override
  String get resultsMyMatches => 'मेरे मैच';

  @override
  String resultsCouldNotLoad(String error) {
    return 'नतीजे लोड नहीं हो सके।\n$error';
  }

  @override
  String get resultsNoFixtures => 'कोई मुक़ाबला नहीं।';

  @override
  String get resultsVs => 'बनाम';

  @override
  String get resultsStageQualifier => 'क्वालिफ़ायर';

  @override
  String get resultsStageFriendly => 'दोस्ताना';

  @override
  String get resultsStageGroupStage => 'ग्रुप चरण';

  @override
  String get resultsStageSemiFinal => 'सेमीफ़ाइनल';

  @override
  String get resultsStageFinal => 'फ़ाइनल';

  @override
  String get resultsStageContinentalClash => 'कॉन्टिनेंटल क्लैश';

  @override
  String get resultsStageFinalsGroup => 'फ़ाइनल्स ग्रुप';

  @override
  String get resultsStageRoundOf32 => 'राउंड ऑफ़ 32';

  @override
  String get resultsStageRoundOf16 => 'राउंड ऑफ़ 16';

  @override
  String get resultsStageQuarterFinal => 'क्वार्टरफ़ाइनल';

  @override
  String get resultsStageThirdPlace => 'तीसरा स्थान';

  @override
  String get matchSetupWarnCaptain =>
      'कोई कप्तान नहीं चुना गया। किसी को आर्मबैंड देने के लिए टैप करें';

  @override
  String matchSetupWarnCaptainInjured(String name) {
    return '$name चोटिल हैं और टीम की अगुआई नहीं कर सकते। आर्मबैंड किसी और को देने के लिए टैप करें';
  }

  @override
  String matchSetupWarnCaptainSuspended(String name) {
    return '$name इस मैच के लिए निलंबित हैं। आर्मबैंड किसी और को देने के लिए टैप करें';
  }

  @override
  String matchSetupWarnCaptainDropped(String name) {
    return '$name के पास आर्मबैंड है, लेकिन वे आपके स्क्वॉड में नहीं हैं। इसे किसी और को देने के लिए टैप करें';
  }

  @override
  String get matchSetupWarnSetPieces =>
      'कोई सेट-पीस टेकर नहीं चुना गया। चुनने के लिए टैप करें कि कौन आगे आएगा';

  @override
  String get matchSetupWarnBoth =>
      'न कप्तान है, न सेट-पीस टेकर। तय करने के लिए टैप करें';

  @override
  String matchStageMatchday(int matchday) {
    return 'मैचडे $matchday';
  }

  @override
  String get squadCaptain => 'कप्तान';

  @override
  String deptEffectYouth(int points) {
    return 'एकेडमी के उभरते खिलाड़ी औसतन लगभग $points ओवरऑल बेहतर आएँगे';
  }

  @override
  String deptEffectCommercial(String amount) {
    return 'चक्र के अंत में $amount वापस';
  }

  @override
  String deptEffectMedical(int percent) {
    return 'चोटें $percent% कम';
  }

  @override
  String deptEffectNaturalisation(int percent) {
    return 'किसी विदेशी खिलाड़ी के पाला बदलने की माँग करने की $percent% संभावना';
  }

  @override
  String deptEffectBoard(int points) {
    return 'नौकरी ख़तरे में पड़ने से पहले बोर्ड का धैर्य +$points';
  }

  @override
  String get deptEffectNone => 'फ़ंड न मिलने तक कोई असर नहीं';

  @override
  String get statsBestRated => 'रेटिंग';

  @override
  String get statsMyCareer => 'करियर';

  @override
  String get statsBestAverageRating => 'सर्वश्रेष्ठ औसत रेटिंग';

  @override
  String get statsMyCareerRecord => 'आपका रिकॉर्ड';

  @override
  String get statsNoRatingsRecorded => 'अभी तक कोई मैच रेटिंग दर्ज नहीं हुई।';

  @override
  String get statsGroupRecord => 'रिकॉर्ड';

  @override
  String get statsGroupRuns => 'सिलसिले';

  @override
  String get statsGroupExtremes => 'चरम';

  @override
  String get statsGroupSplits => 'घरेलू और बाहर';

  @override
  String get statsGroupSquad => 'आपके खिलाड़ी';

  @override
  String get statsPlayed => 'खेले गए मैच';

  @override
  String get statsWinDrawLoss => 'जीत–ड्रॉ–हार';

  @override
  String get statsWinRate => 'जीत दर';

  @override
  String get statsGoals => 'गोल किए:खाए';

  @override
  String get statsCleanSheets => 'क्लीन शीट';

  @override
  String get statsFailedToScore => 'गोल करने में नाकाम';

  @override
  String get statsLongestWinStreak => 'सबसे लंबा जीत का सिलसिला';

  @override
  String get statsLongestUnbeaten => 'सबसे लंबा अजेय सिलसिला';

  @override
  String get statsLongestCleanSheets => 'सबसे लंबा क्लीन शीट सिलसिला';

  @override
  String get statsLongestWinless => 'सबसे लंबा बिना जीत का सिलसिला';

  @override
  String get statsCurrentRun => 'मौजूदा अजेय सिलसिला';

  @override
  String get statsBiggestWin => 'सबसे बड़ी जीत';

  @override
  String get statsHeaviestDefeat => 'सबसे बड़ी हार';

  @override
  String get statsMostGoalsInAGame => 'एक मैच में सबसे ज़्यादा गोल';

  @override
  String get statsShootouts => 'शूटआउट जीते–हारे';

  @override
  String get statsComebackWins => 'पिछड़ने के बाद जीत';

  @override
  String get statsHome => 'घरेलू';

  @override
  String get statsAway => 'बाहर';

  @override
  String get statsNeutral => 'तटस्थ';

  @override
  String get statsCompetitive => 'प्रतिस्पर्धी';

  @override
  String get statsFriendlies => 'दोस्ताना मैच';

  @override
  String get statsHatTricks => 'हैट्रिक';

  @override
  String get statsBraces => 'दो गोल (ब्रेस)';

  @override
  String get statsMotms => 'मैन ऑफ़ द मैच अवॉर्ड';

  @override
  String get statsAssists => 'असिस्ट';

  @override
  String get statsCards => 'कार्ड';

  @override
  String get statsBestRating => 'सर्वश्रेष्ठ व्यक्तिगत रेटिंग';

  @override
  String statsAppsShort(int apps) {
    return '$apps मैच';
  }

  @override
  String statsMotmShort(int motms) {
    return '$motms MOTM';
  }

  @override
  String get captainArmband => 'C';

  @override
  String get captainCurrent => 'कप्तान। आर्मबैंड हटाने के लिए टैप करें';

  @override
  String get captainFitBorn => 'जन्मजात लीडर';

  @override
  String get captainFitNatural => 'स्वाभाविक कप्तान';

  @override
  String get captainFitCapable => 'संभाल सकते हैं';

  @override
  String get captainFitUnproven => 'अभी लीडर नहीं';

  @override
  String get captainNone => 'कोई कप्तान नहीं चुना';

  @override
  String captainMoraleBoost(int morale) {
    return '+$morale स्क्वॉड मनोबल';
  }

  @override
  String get resultsCategoryWorldCupQualifying =>
      'विश्व चैंपियनशिप क्वालिफ़ाइंग';

  @override
  String get resultsCategoryFriendlies => 'दोस्ताना मैच';

  @override
  String get resultsCategoryContinentalClash => 'कॉन्टिनेंटल क्लैश';

  @override
  String get resultsCategoryNationsCup => 'नेशंस कप';

  @override
  String get resultsCategoryContinentalCup => 'महाद्वीपीय कप';

  @override
  String get resultsCategoryWorldCupQualifyingShort => 'विश्व चैं. क्वालि.';

  @override
  String get resultsCategoryContinentalQualifyingShort => 'महाद्वीपीय क्वालि.';

  @override
  String get resultsCategoryContinentalQualifying =>
      'महाद्वीपीय कप क्वालिफ़ाइंग';

  @override
  String get resultsCategoryWorldCupFinals => 'विश्व चैंपियनशिप फ़ाइनल्स';

  @override
  String get resultsRoundResults => 'राउंड के नतीजे';

  @override
  String get resultsFriendlyInternationals => 'दोस्ताना अंतरराष्ट्रीय मैच';

  @override
  String get resultsKnockout => 'नॉकआउट';

  @override
  String resultsEarlierMatches(int count) {
    return 'पहले के मैच ($count)';
  }

  @override
  String resultsMatchday(int matchday) {
    return 'मैचडे $matchday';
  }

  @override
  String get resultsContinue => 'जारी रखें';

  @override
  String resultsGroup(String name) {
    return 'ग्रुप $name';
  }

  @override
  String get achievementsScreenTitle => 'उपलब्धियाँ';

  @override
  String get achievementsChallengesTooltip => 'चुनौतियाँ';

  @override
  String get achievementsChallengesHeading => 'चुनौतियाँ';

  @override
  String get achievementsBrutalTests => 'पूरे करियर की कठिन परीक्षाएँ';

  @override
  String achievementsCouldNotLoad(String error) {
    return 'लोड नहीं हो सका।\n$error';
  }

  @override
  String achievementsUnlockedCount(int earned, int total) {
    return '$earned / $total अनलॉक';
  }

  @override
  String achievementsConqueredCount(int done, int total) {
    return '$done / $total पूरी';
  }

  @override
  String get achievementsBoardSatisfaction => 'बोर्ड की संतुष्टि';

  @override
  String achievementsUnlockedBanner(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count उपलब्धियाँ अनलॉक हुईं',
      one: 'उपलब्धि अनलॉक हुई',
    );
    return '$_temp0';
  }

  @override
  String get achCatWins => 'जीत';

  @override
  String get achCatMatches => 'मैच';

  @override
  String get achCatQualifications => 'क्वालिफ़िकेशन';

  @override
  String get achCatTitles => 'ख़िताब';

  @override
  String get achCatMisc => 'विविध';

  @override
  String get achCatMega => 'मेगा';

  @override
  String get achCatGoals => 'गोल';

  @override
  String get achCatStreaks => 'सिलसिले';

  @override
  String get achTierBronze => 'कांस्य';

  @override
  String get achTierSilver => 'रजत';

  @override
  String get achTierGold => 'स्वर्ण';

  @override
  String get achTierPlatinum => 'प्लैटिनम';

  @override
  String achGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count गोल',
    );
    return '$_temp0';
  }

  @override
  String achGoalsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count गोल करें।',
      one: '1 गोल करें।',
    );
    return '$_temp0';
  }

  @override
  String achCleanSheets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count क्लीन शीट',
    );
    return '$_temp0';
  }

  @override
  String achCleanSheetsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count क्लीन शीट रखें।',
      one: '1 क्लीन शीट रखें।',
    );
    return '$_temp0';
  }

  @override
  String get achStreakWin5 => 'जीत की आदत';

  @override
  String get achStreakWin5Desc => 'लगातार पाँच मैच जीतें।';

  @override
  String get achStreakWin10 => 'लय में';

  @override
  String get achStreakWin10Desc => 'लगातार दस मैच जीतें।';

  @override
  String get achStreakWin20 => 'अजेय रथ';

  @override
  String get achStreakWin20Desc => 'लगातार बीस मैच जीतें।';

  @override
  String get achUnbeaten15 => 'हराना मुश्किल';

  @override
  String get achUnbeaten15Desc => 'पंद्रह मैच अजेय रहें।';

  @override
  String get achUnbeaten30 => 'अभेद्य';

  @override
  String get achUnbeaten30Desc => 'तीस मैच अजेय रहें।';

  @override
  String get achHattrick => 'हैट्रिक हीरो';

  @override
  String get achHattrickDesc => 'अपने किसी खिलाड़ी से हैट्रिक करवाएँ।';

  @override
  String get achMotm10 => 'सबसे अलग';

  @override
  String get achMotm10Desc => '10 मैन ऑफ़ द मैच अवॉर्ड जीतें।';

  @override
  String get achMotm50 => 'तावीज़';

  @override
  String get achMotm50Desc => '50 मैन ऑफ़ द मैच अवॉर्ड जीतें।';

  @override
  String get achPerfect => 'परफ़ेक्ट टेन';

  @override
  String get achPerfectDesc => 'अपने किसी खिलाड़ी को 9.5+ मैच रेटिंग दिलाएँ।';

  @override
  String get achShootout => 'नसों में बर्फ़';

  @override
  String get achShootoutDesc => 'पाँच पेनल्टी शूटआउट जीतें।';

  @override
  String get achMassacre => 'धुलाई';

  @override
  String get achMassacreDesc => 'कोई मैच 7 या उससे ज़्यादा गोल से जीतें।';

  @override
  String get achAnnihilation => 'सफ़ाया';

  @override
  String get achAnnihilationDesc => 'कोई मैच 10 या उससे ज़्यादा गोल से जीतें।';

  @override
  String get chTierBronze => 'कांस्य';

  @override
  String get chTierSilver => 'रजत';

  @override
  String get chTierGold => 'स्वर्ण';

  @override
  String get chTierLegendary => 'महान';

  @override
  String get chFirstSteps => 'डगआउट में';

  @override
  String get chFirstStepsDesc => '5 साल तक मैनेजर रहें।';

  @override
  String get chUnbeaten10 => 'लय में';

  @override
  String get chUnbeaten10Desc => '10 प्रतिस्पर्धी मैच अजेय रहें।';

  @override
  String get chTwoNations => 'नई चुनौती';

  @override
  String get chTwoNationsDesc => '2 अलग-अलग देशों के मैनेजर बनें।';

  @override
  String get chCont1 => 'महाद्वीपीय चैंपियन';

  @override
  String get chCont1Desc => 'कोई महाद्वीपीय चैंपियनशिप जीतें।';

  @override
  String get chNc1 => 'नेशंस कप विजेता';

  @override
  String get chNc1Desc => 'नेशंस कप जीतें।';

  @override
  String get chWc1 => 'विश्व चैंपियन';

  @override
  String get chWc1Desc => 'विश्व चैंपियनशिप जीतें।';

  @override
  String get chYears25 => 'स्थापित नाम';

  @override
  String get chYears25Desc => '25 साल तक मैनेजर रहें।';

  @override
  String get chWc3 => 'लगातार विजेता';

  @override
  String get chWc3Desc => '3 विश्व चैंपियनशिप जीतें।';

  @override
  String get chWc5 => 'राजवंश';

  @override
  String get chWc5Desc => '5 विश्व चैंपियनशिप जीतें।';

  @override
  String get chWc10 => 'अमर';

  @override
  String get chWc10Desc => '10 विश्व चैंपियनशिप जीतें।';

  @override
  String get chWc2Teams => 'बूट तैयार, सफ़र जारी';

  @override
  String get chWc2TeamsDesc => '2 अलग-अलग देशों के साथ विश्व चैंपियनशिप जीतें।';

  @override
  String get chWc3Teams => 'दुनिया का सफ़र';

  @override
  String get chWc3TeamsDesc => '3 अलग-अलग देशों के साथ विश्व चैंपियनशिप जीतें।';

  @override
  String get chWcStreak3 => 'लगातार तीसरा ख़िताब';

  @override
  String get chWcStreak3Desc => 'लगातार 3 विश्व चैंपियनशिप जीतें।';

  @override
  String get chWcAllconf => 'दुनिया फ़तह';

  @override
  String get chWcAllconfDesc =>
      'हर परिसंघ (6) के किसी देश के साथ विश्व चैंपियनशिप जीतें।';

  @override
  String get chCont5 => 'महाद्वीप का बादशाह';

  @override
  String get chCont5Desc => '5 महाद्वीपीय चैंपियनशिप जीतें।';

  @override
  String get chContAll => 'छह महाद्वीपों का स्लैम';

  @override
  String get chContAllDesc => 'हर परिसंघ (6) की महाद्वीपीय चैंपियनशिप जीतें।';

  @override
  String get chTreble => 'क्लीन स्वीप';

  @override
  String get chTrebleDesc =>
      'एक ही करियर में विश्व चैंपियनशिप, एक महाद्वीपीय ख़िताब और नेशंस कप जीतें।';

  @override
  String get chNations10 => 'घुमंतू';

  @override
  String get chNations10Desc => '10 अलग-अलग देशों के मैनेजर बनें।';

  @override
  String get chYears100 => 'शतक';

  @override
  String get chYears100Desc => '100 साल तक मैनेजर रहें।';

  @override
  String get chYears500 => 'आधी सहस्राब्दी';

  @override
  String get chYears500Desc => '500 साल तक मैनेजर रहें।';

  @override
  String get chYears1000 => 'शाश्वत';

  @override
  String get chYears1000Desc => '1000 साल तक मैनेजर रहें।';

  @override
  String get chGrandmaster => 'ग्रैंडमास्टर';

  @override
  String get chGrandmasterDesc =>
      '3 विश्व चैंपियनशिप और 5 महाद्वीपीय चैंपियनशिप जीतें।';

  @override
  String get chUndefeated => 'अभेद्य';

  @override
  String get chUndefeatedDesc => 'एक भी मैच हारे बिना विश्व चैंपियनशिप जीतें।';

  @override
  String get chPerfectQual => 'बेदाग़ सफ़र';

  @override
  String get chPerfectQualDesc =>
      'विश्व चैंपियनशिप क्वालिफ़ाइंग अभियान का हर मैच जीतें।';

  @override
  String get chMinnow => 'छोटे का चमत्कार';

  @override
  String get chMinnowDesc =>
      'विश्व रैंकिंग के टॉप 32 से बाहर के देश के साथ विश्व चैंपियनशिप जीतें।';

  @override
  String get chGrandTour => 'घर और बाहर';

  @override
  String get chGrandTourDesc =>
      'मेज़बान के रूप में एक विश्व चैंपियनशिप जीतें और घर से बाहर भी एक जीतें।';

  @override
  String get chUnbeaten25 => 'दीवार';

  @override
  String get chUnbeaten25Desc => '25 प्रतिस्पर्धी मैच अजेय रहें।';

  @override
  String get chGoals10k => 'गोल मशीन';

  @override
  String get chGoals10kDesc => 'करियर में 10,000 गोल करें।';

  @override
  String get chCleanSheets500 => 'किला';

  @override
  String get chCleanSheets500Desc => 'करियर में 500 क्लीन शीट रखें।';

  @override
  String get chHatTricks25 => 'हैट्रिक की आदत';

  @override
  String get chHatTricks25Desc => 'अपने खिलाड़ियों से 25 हैट्रिक करवाएँ।';

  @override
  String get chWinStreak25 => 'बेरोक';

  @override
  String get chWinStreak25Desc => 'लगातार 25 मैच जीतें।';

  @override
  String get chCont10 => 'महाद्वीपीय राजवंश';

  @override
  String get chCont10Desc => '10 महाद्वीपीय चैंपियनशिप जीतें।';

  @override
  String get chPcWc => 'लगातार चैंपियन';

  @override
  String chPcWcDesc(int count) {
    return 'इस सेव में $count विश्व चैंपियनशिप जीतें।';
  }

  @override
  String get chPcMajors => 'ट्रॉफ़ी संग्राहक';

  @override
  String chPcMajorsDesc(int count) {
    return '$count बड़ी ट्रॉफ़ियाँ जीतें (विश्व चैंपियनशिप, महाद्वीपीय या नेशंस कप)।';
  }

  @override
  String get chPcUnbeaten => 'लोहे की दीवार';

  @override
  String chPcUnbeatenDesc(int count) {
    return '$count प्रतिस्पर्धी मैच अजेय रहें।';
  }

  @override
  String get chPcNations => 'अनुभवी सफ़री';

  @override
  String chPcNationsDesc(int count) {
    return '$count अलग-अलग देशों के मैनेजर बनें।';
  }

  @override
  String get chPcYears => 'लंबी पारी';

  @override
  String chPcYearsDesc(int count) {
    return '$count साल तक मैनेजर रहें।';
  }

  @override
  String achWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count जीत',
      one: '1 जीत',
    );
    return '$_temp0';
  }

  @override
  String achWinsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count मैच जीतें।',
      one: '1 मैच जीतें।',
    );
    return '$_temp0';
  }

  @override
  String achMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count मैच',
    );
    return '$_temp0';
  }

  @override
  String achMatchesDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count मैच खेलें।',
      one: '1 मैच खेलें।',
    );
    return '$_temp0';
  }

  @override
  String get achQualWc => 'विश्व चैंपियनशिप क्वालिफ़ायर';

  @override
  String get achQualWcDesc => 'विश्व चैंपियनशिप के लिए क्वालिफ़ाई करें।';

  @override
  String get achQualCont => 'महाद्वीपीय क्वालिफ़ायर';

  @override
  String get achQualContDesc =>
      'अपनी महाद्वीपीय चैंपियनशिप के लिए क्वालिफ़ाई करें।';

  @override
  String get achTitleWc => 'विश्व चैंपियन';

  @override
  String get achTitleWcDesc => 'विश्व चैंपियनशिप जीतें।';

  @override
  String get achTitleEuro => 'यूरोपीय चैंपियन';

  @override
  String get achTitleEuroDesc => 'यूरोपीय चैंपियनशिप जीतें।';

  @override
  String get achTitleCopa => 'दक्षिण अमेरिकी चैंपियन';

  @override
  String get achTitleCopaDesc => 'दक्षिण अमेरिका कप जीतें।';

  @override
  String get achTitleAfcon => 'अफ़्रीकी चैंपियन';

  @override
  String get achTitleAfconDesc => 'अफ़्रीकी चैंपियनशिप जीतें।';

  @override
  String get achTitleAsia => 'एशियाई चैंपियन';

  @override
  String get achTitleAsiaDesc => 'एशियाई चैंपियनशिप जीतें।';

  @override
  String get achTitleConcacaf => 'उत्तर अमेरिकी चैंपियन';

  @override
  String get achTitleConcacafDesc => 'उत्तर अमेरिका कप जीतें।';

  @override
  String get achTitleOfc => 'ओशिनिया चैंपियन';

  @override
  String get achTitleOfcDesc => 'ओशिनिया कप जीतें।';

  @override
  String get achTitleNations => 'नेशंस कप विजेता';

  @override
  String get achTitleNationsDesc => 'नेशंस कप जीतें।';

  @override
  String get achTitleClash => 'कॉन्टिनेंटल क्लैश विजेता';

  @override
  String get achTitleClashDesc => 'कॉन्टिनेंटल क्लैश जीतें।';

  @override
  String get achMarksman => 'विश्व चैंपियनशिप निशानेबाज़';

  @override
  String get achMarksmanDesc =>
      'अपने स्क्वॉड के किसी खिलाड़ी से विश्व चैंपियनशिप फ़ाइनल्स में 6+ गोल करवाएँ।';

  @override
  String get achSweep => 'क्लीन स्वीप';

  @override
  String get achSweepDesc =>
      'एक ही करियर में विश्व चैंपियनशिप और अपना महाद्वीपीय ख़िताब जीतें।';

  @override
  String get achAllstar => 'टूर्नामेंट ऑल-स्टार';

  @override
  String get achAllstarDesc =>
      'अपने किसी खिलाड़ी को विश्व चैंपियनशिप की टीम ऑफ़ द टूर्नामेंट में जगह दिलाएँ।';

  @override
  String get achGoldenboot => 'गोल्डन बूट';

  @override
  String get achGoldenbootDesc =>
      'अपने देश को चैंपियनशिप के टॉप स्कोरर के रूप में ख़त्म करवाएँ।';

  @override
  String get achDemolition => 'ध्वस्त';

  @override
  String get achDemolitionDesc => 'कोई मैच 5 या उससे ज़्यादा गोल से जीतें।';

  @override
  String get achievementsNice => 'बढ़िया!';

  @override
  String get achievementsHardestTests =>
      'एक मैनेजर की सबसे कठिन परीक्षाएँ, पूरे करियर और कई देशों में।';

  @override
  String get achievementsThisSave => 'यह सेव';

  @override
  String get achievementsBrutalBadge => 'कठिन';

  @override
  String get paywallGoPro => 'अनलिमिटेड पाएँ';

  @override
  String get paywallOneTimeUnlock =>
      'एक बार अनलॉक करें। कोई सब्सक्रिप्शन नहीं।';

  @override
  String get paywallBenefitCarryOn =>
      'यह सेव ठीक वहीं से आगे बढ़ता है जहाँ रुका था, हर कैप, रिकॉर्ड और प्रतिद्वंद्विता के साथ।';

  @override
  String get paywallBenefitNoAds =>
      'न विज्ञापन, न माइक्रोट्रांज़ैक्शन, न सब्सक्रिप्शन। एक भुगतान, और आगे का हर अपडेट आपका।';

  @override
  String get paywallBenefitSaves =>
      'जितने चाहें उतने सेव। एक दिग्गज और एक छोटी टीम साथ-साथ चलाएँ, और देखें कि एक ही गेम कितना अलग लगता है।';

  @override
  String get paywallBenefitEndless =>
      'अब से हर चक्र। आज सत्रह साल के किसी खिलाड़ी को चुनें और 2034 में जानें कि आपकी नज़र सही थी या नहीं।';

  @override
  String get paywallUnlocked => 'अनलिमिटेड अनलॉक हो गया है। मज़े करें!';

  @override
  String get paywallContactingStore => 'स्टोर से संपर्क हो रहा है…';

  @override
  String paywallUnlockProPriced(String price) {
    return 'अनलिमिटेड अनलॉक करें · $price';
  }

  @override
  String get paywallRestorePurchases => 'खरीदारी बहाल करें';

  @override
  String get paywallStoreUnavailable => 'स्टोर उपलब्ध नहीं';

  @override
  String get paywallStoreUnavailableNote =>
      'कीमत लोड नहीं हो सकी। अपना कनेक्शन जाँचें और दोबारा कोशिश करें।';

  @override
  String get paywallTryAgain => 'दोबारा कोशिश करें';

  @override
  String get gateTitle => 'आपका पहला चक्र पूरा हुआ';

  @override
  String get gateLead =>
      'चार साल एक चक्र होते हैं। यह जानने के लिए काफ़ी नहीं कि आप सही थे या नहीं।';

  @override
  String get gatePriceLead => 'एक भुगतान, हमेशा के लिए';

  @override
  String get gateBuy => 'खरीदें और जारी रखें';

  @override
  String get gateExit => 'बाहर निकलें';

  @override
  String get gateSaveTitle => 'इस सेव के लिए Pro चाहिए';

  @override
  String get gateSaveLead =>
      'मुफ़्त चक्र के बाद के सेव और Pro अभियान Pro के साथ आगे बढ़ते हैं। कुछ भी नहीं खोता: यह सेव ठीक वैसा ही आपका इंतज़ार कर रहा है जैसा आपने छोड़ा था।';

  @override
  String get careerSaveLockedNote => 'इस सेव को जारी रखने के लिए Pro चाहिए';

  @override
  String get federationNaturalisation => 'नागरिकता';

  @override
  String federationNaturalisedTitle(String name) {
    return '$name को नागरिकता मिली';
  }

  @override
  String federationNaturalisedBody(String name, String nation) {
    return '$name ने बदलाव पूरा कर लिया है और अब $nation के लिए पात्र हैं। उन्हें अपने स्क्वॉड चयन से बुलाएँ।';
  }

  @override
  String federationCouldNotLoadOffer(String error) {
    return 'प्रस्ताव लोड नहीं हो सका।\n$error';
  }

  @override
  String get federationContinue => 'जारी रखें';

  @override
  String get federationOfferToSwitchAllegiance => 'निष्ठा बदलने का प्रस्ताव';

  @override
  String federationPlayerMeta(String position, int age, String nation) {
    return '$position · उम्र $age · $nation से';
  }

  @override
  String federationNaturalisationBlurb(
    String name,
    String playerNation,
    String sourceNation,
  ) {
    return '$name का $playerNation से रिश्ता है और वे नागरिकता लेने को तैयार हैं। स्वीकार करें तो उनका चयन हो सकता है; ठुकराएँ तो वे $sourceNation के साथ ही रहेंगे।';
  }

  @override
  String get federationDecline => 'ठुकराएँ';

  @override
  String get federationNaturalise => 'नागरिकता दें';

  @override
  String get federationBudgetLater => 'बाद में तय करें';

  @override
  String get federationSetYourBudget => 'अपना बजट तय करें';

  @override
  String federationCouldNotLoadFinances(String error) {
    return 'वित्तीय जानकारी लोड नहीं हो सकी।\n$error';
  }

  @override
  String get federationSaveNotFound => 'सेव नहीं मिला।';

  @override
  String get federationBudgetHeading => 'फ़ेडरेशन बजट';

  @override
  String federationDistributeBudget(String amount) {
    return 'चक्र शुरू करने के लिए $amount विभागों में बाँटें। सोच-समझकर ख़र्च करें।';
  }

  @override
  String federationOverBudget(String amount) {
    return 'फ़ेडरेशन के पास जितना है, उससे $amount ज़्यादा। कुछ वापस लें';
  }

  @override
  String get federationAllocateFullBudget =>
      'चक्र शुरू करने के लिए पूरा बजट आवंटित करें।';

  @override
  String get federationConfirming => 'पुष्टि हो रही है…';

  @override
  String get federationConfirmBudget => 'बजट की पुष्टि करें';

  @override
  String get federationFinances => 'वित्त';

  @override
  String get federationInvestmentUpdated => 'निवेश अपडेट हो गया।';

  @override
  String get federationDevelopment => 'फ़ेडरेशन विकास';

  @override
  String get federationProjectedAtSeasonEnd => 'सीज़न के अंत तक अनुमान';

  @override
  String get federationCentralFunding => 'केंद्रीय फ़ंडिंग';

  @override
  String get federationPrizeMoneySoFar => 'अब तक की पुरस्कार राशि';

  @override
  String get federationCommercialReturn => 'व्यावसायिक आय';

  @override
  String get federationThisSeasonLocked => 'इस सीज़न (लॉक)';

  @override
  String get federationInvestForNextSeason => 'अगले सीज़न के लिए निवेश';

  @override
  String get federationNextSeasonImpact => 'अगले सीज़न पर असर';

  @override
  String get federationSaving => 'सेव हो रहा है…';

  @override
  String get federationConfirmInvestment => 'निवेश की पुष्टि करें';

  @override
  String get federationBalance => 'फ़ेडरेशन बैलेंस';

  @override
  String get federationCommittedToStaff => 'स्टाफ़ के लिए आरक्षित';

  @override
  String get federationFreeToSpend => 'ख़र्च के लिए उपलब्ध';

  @override
  String get federationWagesNote =>
      'वेतन चक्र के अंत में बैलेंस से कट जाता है, इसलिए इतनी रकम पहले से तय है।';

  @override
  String get federationInvestAtCeremony =>
      'अगले सीज़न का निवेश चक्र के अंत के समारोह में करें।';

  @override
  String federationLevelBadge(int level) {
    return 'L$level';
  }

  @override
  String get federationAcademyProspects => 'अकादमी के उभरते खिलाड़ी';

  @override
  String federationPlusOverall(int value) {
    return '+$value ओवरऑल';
  }

  @override
  String get federationInjuryRisk => 'चोट का जोखिम';

  @override
  String get federationNaturalisationChance => 'नागरिकता मिलने की संभावना';

  @override
  String get federationBoardPatience => 'बोर्ड का धैर्य';

  @override
  String get federationUnallocated => 'अनाबंटित';

  @override
  String get nationsVitrineTitle => 'राष्ट्रीय ट्रॉफ़ी कक्ष';

  @override
  String nationsCouldNotLoad(String error) {
    return 'देश लोड नहीं हो सका।\n$error';
  }

  @override
  String get nationsNoNation => 'कोई देश नहीं।';

  @override
  String get nationsHonours => 'उपलब्धियाँ';

  @override
  String get nationsRankingHistory => 'विश्व रैंकिंग का इतिहास';

  @override
  String get nationsTopScorers => 'सर्वकालिक शीर्ष स्कोरर';

  @override
  String get nationsTitles => 'ख़िताब';

  @override
  String get nationsYourTeam => 'आपकी टीम';

  @override
  String get nationsWorld => 'विश्व';

  @override
  String get nationsWorldCup => 'विश्व चैंपियनशिप';

  @override
  String get nationsContinental => 'महाद्वीपीय';

  @override
  String nationsAppearances(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count उपस्थितियाँ',
      one: '1 उपस्थिति',
    );
    return '$_temp0';
  }

  @override
  String get nationsNotEnoughHistory =>
      'अभी पर्याप्त इतिहास नहीं है। एक-दो चक्र बाद फिर देखें।';

  @override
  String nationsBestRank(int rank) {
    return 'सर्वश्रेष्ठ: #$rank';
  }

  @override
  String nationsNowRank(int rank) {
    return 'अभी: #$rank';
  }

  @override
  String get nationsNoGoals => 'अभी तक कोई गोल दर्ज नहीं।';

  @override
  String get nationsGoalsAbbrev => 'गोल';

  @override
  String get nationsHosts => 'मेज़बान';

  @override
  String get nationsSelectTitle => 'राष्ट्रीय टीम चुनें';

  @override
  String nationsCouldNotLoadNations(String error) {
    return 'देश लोड नहीं हो सके।\n$error';
  }

  @override
  String get nationsNoMatch => 'कोई देश नहीं मिला।';

  @override
  String get nationsSelectHeading => 'राष्ट्रीय टीम चुनें';

  @override
  String get nationsSearchHint => 'देश खोजें…';

  @override
  String get nationsRank => 'रैंक ';

  @override
  String get nationsPremium => 'प्रीमियम';

  @override
  String get nationsSelect => 'चुनें';

  @override
  String get statsTeamRecords => 'टीम रिकॉर्ड';

  @override
  String get statsRecordBook => 'रिकॉर्ड बुक';

  @override
  String statsCouldNotLoadStats(String error) {
    return 'आँकड़े लोड नहीं हो सके।\n$error';
  }

  @override
  String get statsNoData => 'कोई डेटा नहीं।';

  @override
  String get statsTopScorers => 'शीर्ष स्कोरर';

  @override
  String get statsMostGamesPlayed => 'सबसे ज़्यादा मैच खेले';

  @override
  String get statsTeam => 'टीम';

  @override
  String get statsTopScorersShort => 'स्कोरर';

  @override
  String get statsMostGames => 'सबसे ज़्यादा मैच';

  @override
  String get statsNoGoalsRecorded => 'अभी तक कोई गोल दर्ज नहीं।';

  @override
  String get statsUnknown => 'अज्ञात';

  @override
  String get playerTitle => 'खिलाड़ी';

  @override
  String playerLoadError(String error) {
    return 'खिलाड़ी लोड नहीं हो सका।\n$error';
  }

  @override
  String get playerNotFound => 'खिलाड़ी नहीं मिला।';

  @override
  String get playerClub => 'क्लब';

  @override
  String get playerClubRole => 'अपने क्लब में';

  @override
  String get playerPosition => 'पोज़िशन';

  @override
  String get playerPotential => 'क्षमता';

  @override
  String get playerAge => 'उम्र';

  @override
  String get playerValue => 'कीमत';

  @override
  String get clubFirstChoice => 'हर हफ़्ते खेलता है';

  @override
  String get clubRotation => 'कभी अंदर, कभी बाहर';

  @override
  String get clubFringe => 'मुश्किल से खेलता है';

  @override
  String get clubFrozenOut => 'नहीं खेल रहा';

  @override
  String clubAtClub(String club, String standing) {
    return '$club: $standing';
  }

  @override
  String yWinUpset0(String opponent, String score) {
    return 'मैं तीस साल से फ़ुटबॉल देख रहा हूँ और मुझे इसकी उम्मीद नहीं थी। $opponent को $score से हराया।';
  }

  @override
  String yWinUpset1(String opponent, String score) {
    return '$opponent के सामने किसी ने इनका दाँव नहीं लगाया था। $score। किसी ने भी नहीं।';
  }

  @override
  String yWinUpset2(String opponent, String score) {
    return '$opponent के ख़िलाफ़ $score। जाकर पड़ोसियों को जगा दो।';
  }

  @override
  String yWinUpset3(String opponent, String score) {
    return 'ऐसी रातें लोग अपने पोते-पोतियों को सुनाते हैं। $opponent $score।';
  }

  @override
  String yWinUpset4(String opponent, String score) {
    return '$opponent के ख़िलाफ़ $score। जैसे भी हुआ, हो गया।';
  }

  @override
  String yWinUpset5(String opponent, String score) {
    return 'कागज़ पर तो यह मैच शुरू होने से पहले ही ख़त्म था। $opponent $score कुछ और ही कहता है।';
  }

  @override
  String yWinUpset6(String opponent, String score) {
    return '$opponent को $score से हराया। साल भर बाद इस स्कोरलाइन पर कोई यक़ीन नहीं करेगा।';
  }

  @override
  String yWinUpset7(String opponent, String score) {
    return '$opponent $score। जश्न मनाइए, फिर फ़िक्स्चर लिस्ट देखिए।';
  }

  @override
  String yWinUpset8(String opponent, String score) {
    return '$opponent के ख़िलाफ़ $score, और नब्बे में से अस्सी मिनट हमने क़िस्मत के सहारे निकाले।';
  }

  @override
  String yWinUpset9(String opponent, String score) {
    return '$opponent के ख़िलाफ़ एक रात पूरे साल की भरपाई नहीं करती। $score।';
  }

  @override
  String yWinUpset10(String opponent, String score) {
    return '$opponent को $score से हराया और अब हमें बताया जाएगा कि हमने मोड़ ले लिया है। नहीं लिया है।';
  }

  @override
  String yWinUpset11(String opponent, String score) {
    return '$opponent $score। शानदार। असली मौक़े पर दोबारा पूछिएगा।';
  }

  @override
  String yWinRoutine0(String opponent, String score) {
    return '$opponent को $score से हराया। बिल्कुल वैसा ही जैसा होना चाहिए था, और इसमें अपना मज़ा है।';
  }

  @override
  String yWinRoutine1(String opponent, String score) {
    return '$opponent पर $score की जीत। बेरहम, और बेरहम होना तारीफ़ है।';
  }

  @override
  String yWinRoutine2(String opponent, String score) {
    return '$opponent $score। न कोई झंझट, न कोई डर, न कोई शिकायत।';
  }

  @override
  String yWinRoutine3(String opponent, String score) {
    return '$opponent के ख़िलाफ़ सधी हुई $score की जीत। आसान दिन पर अच्छी टीम ऐसी ही दिखती है।';
  }

  @override
  String yWinRoutine4(String opponent, String score) {
    return '$opponent के ख़िलाफ़ $score। काम पूरा, सीखा कुछ नहीं।';
  }

  @override
  String yWinRoutine5(String opponent, String score) {
    return '$opponent को $score से हराया। हमें जीतना ही था, और हम जीते।';
  }

  @override
  String yWinRoutine6(String opponent, String score) {
    return '$opponent पर पेशेवर अंदाज़ में $score की जीत। अगला।';
  }

  @override
  String yWinRoutine7(String opponent, String score) {
    return '$opponent को $score से निपटाया। फ़ाइल बंद करो और आगे बढ़ो।';
  }

  @override
  String yWinRoutine8(String opponent, String score) {
    return '$opponent के ख़िलाफ़ $score और हमसे तालियों की उम्मीद है। उन्हें हराने पर।';
  }

  @override
  String yWinRoutine9(String opponent, String score) {
    return '$opponent पर $score की जीत में शामिल सभी को बधाई, मान लेता हूँ।';
  }

  @override
  String yWinRoutine10(String opponent, String score) {
    return '$opponent $score। ऐसी टीमों को हराना न्यूनतम अपेक्षा है, उपलब्धि नहीं।';
  }

  @override
  String yWinRoutine11(String opponent, String score) {
    return 'हमने $opponent को $score से हराया, पर खेल में भारीपन साफ़ दिखा।';
  }

  @override
  String yWinTight0(String opponent, String score) {
    return '$opponent के ख़िलाफ़ $score और हर मिनट कमाया हुआ।';
  }

  @override
  String yWinTight1(String opponent, String score) {
    return 'इसके लिए जज़्बा चाहिए था। $opponent $score।';
  }

  @override
  String yWinTight2(String opponent, String score) {
    return '$opponent को $score से मुश्किल रास्ते से हराया, और टिकाऊ जीत वही होती है।';
  }

  @override
  String yWinTight3(String opponent, String score) {
    return '$opponent के ख़िलाफ़ $score। जो टीमें ऐसे मैच जीतती हैं, वही जून में भी टिकी रहती हैं।';
  }

  @override
  String yWinTight4(String opponent, String score) {
    return 'घबराहट भरा, बदसूरत, और फिर भी जीत। $opponent $score।';
  }

  @override
  String yWinTight5(String opponent, String score) {
    return '$opponent को $score से हराया। तीन अंक लो और यह मैच दोबारा कभी मत देखो।';
  }

  @override
  String yWinTight6(String opponent, String score) {
    return '$score। $opponent ने हमसे एक-एक इंच के लिए पसीना बहवाया।';
  }

  @override
  String yWinTight7(String opponent, String score) {
    return '$opponent $score। खूबसूरत नहीं था। गिनती बराबर है।';
  }

  @override
  String yWinTight8(String opponent, String score) {
    return '$opponent के ख़िलाफ़ $score और हमने इसे दस गुना मुश्किल बना दिया।';
  }

  @override
  String yWinTight9(String opponent, String score) {
    return '$opponent के सामने हमें यूँ जूझना नहीं चाहिए था। $score।';
  }

  @override
  String yWinTight10(String opponent, String score) {
    return '$opponent $score। जीत गए, पर अपने बारे में कुछ अच्छा सीखने को नहीं मिला।';
  }

  @override
  String yWinTight11(String opponent, String score) {
    return '$opponent के ख़िलाफ़ $score, जो हमारे साथ मेहरबानी थी।';
  }

  @override
  String yDrew0(String opponent, String score) {
    return '$opponent के ख़िलाफ़ एक अंक, $score। लो और आगे बढ़ो।';
  }

  @override
  String yDrew1(String opponent, String score) {
    return '$opponent से $score। इससे बुरी दोपहरें भी होती हैं।';
  }

  @override
  String yDrew2(String opponent, String score) {
    return '$opponent को $score पर रोका। हर चीज़ का कहानी बनना ज़रूरी नहीं।';
  }

  @override
  String yDrew3(String opponent, String score) {
    return '$opponent $score। एक अंक एक अंक है, और तालिका यह नहीं पूछती कि कैसे।';
  }

  @override
  String yDrew4(String opponent, String score) {
    return '$opponent से $score। दो अंक गँवाए या एक कमाया। मूड आपका।';
  }

  @override
  String yDrew5(String opponent, String score) {
    return '$opponent के ख़िलाफ़ ड्रॉ, $score। न कोई ख़ुश है, न कोई नाराज़।';
  }

  @override
  String yDrew6(String opponent, String score) {
    return '$opponent $score। साल के सबसे भूलने लायक़ नब्बे मिनट।';
  }

  @override
  String yDrew7(String opponent, String score) {
    return '$opponent के साथ अंक बाँटे, $score। चलते हैं आगे।';
  }

  @override
  String yDrew8(String opponent, String score) {
    return '$opponent के ख़िलाफ़ $score। ऐसे ड्रॉ से ही अभियान चुपचाप दम तोड़ते हैं।';
  }

  @override
  String yDrew9(String opponent, String score) {
    return '$opponent के ख़िलाफ़ दो अंक गँवा दिए। $score। इसे और कुछ कहा ही नहीं जा सकता।';
  }

  @override
  String yDrew10(String opponent, String score) {
    return '$opponent $score। हमारे पास नब्बे मिनट थे और उनका क्या करना है, कोई अंदाज़ा नहीं।';
  }

  @override
  String yDrew11(String opponent, String score) {
    return '$opponent से $score का ऐसा ड्रॉ जो किसी को याद नहीं रहेगा, पर कीमत सबको चुकानी पड़ेगी।';
  }

  @override
  String yLost0(String opponent, String score) {
    return '$opponent से $score से हारे। ऐसा होता है।';
  }

  @override
  String yLost1(String opponent, String score) {
    return '$opponent $score। किसी को फाँसी चढ़ाने लायक़ कुछ नहीं। अगले मैच की ओर।';
  }

  @override
  String yLost2(String opponent, String score) {
    return '$opponent से $score से हारे, जबकि सब कुछ झोंक दिया। कुछ दिन यह काफ़ी नहीं होता।';
  }

  @override
  String yLost3(String opponent, String score) {
    return '$opponent से $score। सिर ऊँचा रखो। इस टीम में अभी बहुत दम बाक़ी है।';
  }

  @override
  String yLost4(String opponent, String score) {
    return '$opponent $score। हम दूसरे नंबर पर रहे और इसमें कोई बहस नहीं।';
  }

  @override
  String yLost5(String opponent, String score) {
    return '$opponent से $score से हारे। फिर से जुटो।';
  }

  @override
  String yLost6(String opponent, String score) {
    return '$opponent से $score। शर्मनाक नहीं, पर काफ़ी भी नहीं।';
  }

  @override
  String yLost7(String opponent, String score) {
    return '$opponent से $score से हारे। इससे कुछ सीखो, वरना यह हार बेकार गई।';
  }

  @override
  String yLost8(String opponent, String score) {
    return '$opponent से $score और हम उन पर एक वार भी नहीं कर पाए।';
  }

  @override
  String yLost9(String opponent, String score) {
    return '$opponent से हारे, $score। वही समस्याएँ, वही महीना, और वही बहाने आने वाले हैं।';
  }

  @override
  String yLost10(String opponent, String score) {
    return '$opponent $score। आख़िर कब तक इसे बदकिस्मती कहेंगे?';
  }

  @override
  String yLost11(String opponent, String score) {
    return '$opponent से $score की हार। ऐसे नतीजे की कीमत किसी को चुकानी चाहिए।';
  }

  @override
  String yLostBadly0(String opponent, String score) {
    return '$opponent से $score। एक बुरी रात। टीम को पूरे अभियान से परखिए, इस मैच से नहीं।';
  }

  @override
  String yLostBadly1(String opponent, String score) {
    return '$opponent के ख़िलाफ़ उस $score को खिलाड़ियों से ज़्यादा कोई नहीं नहीं चाहता था।';
  }

  @override
  String yLostBadly2(String opponent, String score) {
    return '$opponent $score। बदसूरत, और यह इस टीम की असली पहचान नहीं।';
  }

  @override
  String yLostBadly3(String opponent, String score) {
    return '$opponent के ख़िलाफ़ भूलने लायक़ $score। अगली बार ये ज़रूर वापसी करेंगे।';
  }

  @override
  String yLostBadly4(String opponent, String score) {
    return '$score। $opponent से। मेरे पास शब्द नहीं हैं, जबकि शब्दों के लिए ही मुझे पैसे मिलते हैं।';
  }

  @override
  String yLostBadly5(String opponent, String score) {
    return '$opponent $score। इसका जवाब किसी को देना होगा।';
  }

  @override
  String yLostBadly6(String opponent, String score) {
    return 'मैं चाहता हूँ कि $opponent के ख़िलाफ़ वह $score रिकॉर्ड से भी मिटे और याददाश्त से भी।';
  }

  @override
  String yLostBadly7(String opponent, String score) {
    return '$opponent से $score से हारे। ऐसी स्कोरलाइन पर कोई सफ़ाई नहीं चलती।';
  }

  @override
  String yLostBadly8(String opponent, String score) {
    return 'वह $opponent से हार नहीं थी, आत्मसमर्पण था। $score।';
  }

  @override
  String yLostBadly9(String opponent, String score) {
    return '$score। $opponent के खिलाफ़। लोगों ने पैसे देकर यह देखा।';
  }

  @override
  String yLostBadly10(String opponent, String score) {
    return '$opponent $score। इसके बाद भी कुछ नहीं बदला तो कभी कुछ नहीं बदलेगा।';
  }

  @override
  String yLostBadly11(String opponent, String score) {
    return 'इस टीम को पहले भी शर्मसार होते देखा है, पर $opponent से $score तो नया निचला स्तर है।';
  }

  @override
  String yWinUpset12(String opponent, String score) {
    return '$opponent को $score से हराया। तारीख़ लिख लीजिए, लोग पूछेंगे आप कहाँ थे।';
  }

  @override
  String yWinUpset13(String opponent, String score) {
    return 'ड्रेसिंग रूम के बाहर किसी को यक़ीन नहीं था। $opponent के ख़िलाफ़ $score। गर्व शब्द छोटा पड़ता है।';
  }

  @override
  String yWinUpset14(String opponent, String score) {
    return '$opponent के ख़िलाफ़ $score! हर खिलाड़ी तब तक दौड़ा जब तक दम बाक़ी था।';
  }

  @override
  String yWinUpset15(String opponent, String score) {
    return 'दिग्गज को गिराया। $opponent, $score। इसीलिए हम हर बार लौटकर आते हैं।';
  }

  @override
  String yWinUpset16(String opponent, String score) {
    return '$opponent के ख़िलाफ़ $score। सारे अनुमान अभी-अभी खिड़की से बाहर उड़ गए।';
  }

  @override
  String yWinUpset17(String opponent, String score) {
    return 'बड़ा दावेदार: $opponent। अंतिम स्कोर: हमारे पक्ष में $score।';
  }

  @override
  String yWinUpset18(String opponent, String score) {
    return 'साल के सबसे बड़े उलटफेरों में से एक: $opponent के ख़िलाफ़ $score।';
  }

  @override
  String yWinUpset19(String opponent, String score) {
    return '$opponent $score। किसी ने अंदाज़ा नहीं लगाया और कोई ठीक से समझा भी नहीं सकता।';
  }

  @override
  String yWinUpset20(String opponent, String score) {
    return '$opponent के ख़िलाफ़ $score। शानदार। अब सब भूल जाएँगे कि बाक़ी साल कितना ख़राब था।';
  }

  @override
  String yWinUpset21(String opponent, String score) {
    return '$opponent के ख़िलाफ़ $score और गाड़ी अभी से भर गई। मैं तब भी था जब वह ख़ाली थी।';
  }

  @override
  String yWinUpset22(String opponent, String score) {
    return '$opponent $score। कमाल, और फिर भी ये इसे गँवाने का कोई तरीका ढूँढ लेंगे।';
  }

  @override
  String yWinUpset23(String opponent, String score) {
    return '$opponent के ख़िलाफ़ बड़ी रात, $score। एक अबाबील से बहार नहीं आती।';
  }

  @override
  String yLostBadly12(String opponent, String score) {
    return '$opponent से $score। दर्द होता है क्योंकि हमें परवाह है। फिर भी इनका साथ दीजिए।';
  }

  @override
  String yLostBadly13(String opponent, String score) {
    return '$opponent के ख़िलाफ़ भूल जाने वाली रात, $score। सबसे ज़्यादा चोट खिलाड़ियों को लगी है।';
  }

  @override
  String yLostBadly14(String opponent, String score) {
    return '$opponent $score। सिर ऊँचा रखिए। टीम की पहचान इसी से होती है कि वह इसका जवाब कैसे देती है।';
  }

  @override
  String yLostBadly15(String opponent, String score) {
    return '$opponent के ख़िलाफ़ $score। बुरा, हाँ। दुनिया का अंत, नहीं।';
  }

  @override
  String yLostBadly16(String opponent, String score) {
    return '$opponent से $score। इस नतीजे पर बरसों बात होगी, ग़लत वजहों से।';
  }

  @override
  String yLostBadly17(String opponent, String score) {
    return '$opponent की जीत, $score। इसके बाद अगली बार किसी को हैरान नहीं होना चाहिए।';
  }

  @override
  String yLostBadly18(String opponent, String score) {
    return 'लंबे समय की सबसे बुरी रातों में से एक: $opponent के ख़िलाफ़ $score।';
  }

  @override
  String yLostBadly19(String opponent, String score) {
    return '$opponent $score। सवाल उठेंगे, और उठने भी चाहिए।';
  }

  @override
  String yLostBadly20(String opponent, String score) {
    return '$opponent से $score। शर्मनाक कहना भी कम है।';
  }

  @override
  String yLostBadly21(String opponent, String score) {
    return '$opponent से $score से हार। आख़िरी व्यक्ति बत्ती बुझाकर जाए।';
  }

  @override
  String yLostBadly22(String opponent, String score) {
    return '$opponent $score। अब मुझे हैरानी नहीं होती, और यही डराता है।';
  }

  @override
  String yLostBadly23(String opponent, String score) {
    return '$score। $opponent। ऊपर बैठे किसी को आज रात अपना बायोडाटा अपडेट कर लेना चाहिए।';
  }

  @override
  String yWinRout0(String opponent, String score) {
    return '$opponent के ख़िलाफ़ $score! ऐसा फ़ुटबॉल पूरे देश के चेहरे पर मुस्कान ले आता है।';
  }

  @override
  String yWinRout1(String opponent, String score) {
    return '$opponent को $score से रौंदा। क्या प्रदर्शन है।';
  }

  @override
  String yWinRout2(String opponent, String score) {
    return '$score। $opponent के ख़िलाफ़। आज रात सब कुछ सही बैठा।';
  }

  @override
  String yWinRout3(String opponent, String score) {
    return '$opponent की $score से धुलाई। हाइलाइट्स सँभालकर रखिए, बाद में चाहिए होंगी।';
  }

  @override
  String yWinRout4(String opponent, String score) {
    return '$opponent $score। यह वह टीम है जो अपने फ़ुटबॉल का आनंद ले रही है।';
  }

  @override
  String yWinRout5(String opponent, String score) {
    return '$opponent के ख़िलाफ़ $score, और ज़्यादा भी हो सकते थे। लाजवाब।';
  }

  @override
  String yWinRout6(String opponent, String score) {
    return '$opponent के ख़िलाफ़ $score। ऐसा स्कोर जिसे लोग दोबारा देखेंगे।';
  }

  @override
  String yWinRout7(String opponent, String score) {
    return '$opponent को $score से हराया। पहले आधे घंटे के बाद मुक़ाबला ही नहीं बचा।';
  }

  @override
  String yWinRout8(String opponent, String score) {
    return 'अंतिम स्कोर: $opponent के ख़िलाफ़ $score। लंबे समय की सबसे बड़ी जीत।';
  }

  @override
  String yWinRout9(String opponent, String score) {
    return '$opponent $score। एक टीम खेलने आई, दूसरी बस से उतरी ही नहीं।';
  }

  @override
  String yWinRout10(String opponent, String score) {
    return '$score। $opponent के पास किसी चीज़ का जवाब नहीं था।';
  }

  @override
  String yWinRout11(String opponent, String score) {
    return 'करारी धुनाई: $opponent के ख़िलाफ़ $score।';
  }

  @override
  String yWinRout12(String opponent, String score) {
    return '$opponent के ख़िलाफ़ $score। अच्छा है, पर वे कोई पैमाना नहीं हैं।';
  }

  @override
  String yWinRout13(String opponent, String score) {
    return '$opponent के ख़िलाफ़ $score। जब किसी अच्छी टीम के साथ ऐसा करें तो मुझे जगा देना।';
  }

  @override
  String yWinRout14(String opponent, String score) {
    return '$opponent $score। मज़ेदार, पर मैंने टीमों को ऐसे चमकते और कुछ न जीतते देखा है।';
  }

  @override
  String yWinRout15(String opponent, String score) {
    return '$score, और सब फिर से जीनियस हैं। सामने $opponent था।';
  }

  @override
  String yWinRout16(String opponent, String score) {
    return '$opponent के ख़िलाफ़ $score। बहकिए मत, इससे बहुत कम साबित होता है।';
  }

  @override
  String yWinRout17(String opponent, String score) {
    return '$opponent $score। मज़े लीजिए, फिर याद कीजिए कि पिछली बार उत्साहित होने पर क्या हुआ था।';
  }

  @override
  String yWinShootout0(String opponent) {
    return '$opponent के ख़िलाफ़ पेनल्टी में आगे! फ़ौलादी नसें, हर एक की।';
  }

  @override
  String yWinShootout1(String opponent) {
    return '$opponent के ख़िलाफ़ पेनल्टी, और हमने धैर्य रखा। किसी अजनबी को गले लगाइए।';
  }

  @override
  String yWinShootout2(String opponent) {
    return '$opponent के ख़िलाफ़ पेनल्टी शूटआउट जीता। मेरा दिल यह नहीं झेल सकता।';
  }

  @override
  String yWinShootout3(String opponent) {
    return '$opponent को पेनल्टी में हराया। अगले दौर में।';
  }

  @override
  String yWinShootout4(String opponent) {
    return '$opponent के ख़िलाफ़ फ़ैसला पेनल्टी स्पॉट से हुआ, और हमने ज़्यादा गोल किए।';
  }

  @override
  String yWinShootout5(String opponent) {
    return '$opponent के ख़िलाफ़ शूटआउट जीता। सबसे मुश्किल रास्ते से, पर आगे।';
  }

  @override
  String yWinShootout6(String opponent) {
    return '$opponent के ख़िलाफ़ पेनल्टी में आगे। लॉटरी लग गई, खेल भूल जाइए।';
  }

  @override
  String yWinShootout7(String opponent) {
    return 'ऐसे खेल के बाद $opponent को पेनल्टी में हराना? क़िस्मत, और सब जानते हैं।';
  }

  @override
  String yWinShootout8(String opponent) {
    return '$opponent के ख़िलाफ़ पेनल्टी से आगे। नौबत वहाँ तक आनी ही नहीं चाहिए थी।';
  }

  @override
  String yKnockoutWin0(String opponent, String score) {
    return 'आगे बढ़े। $opponent के ख़िलाफ़ $score, और सपना ज़िंदा है।';
  }

  @override
  String yKnockoutWin1(String opponent, String score) {
    return 'नॉकआउट जीत: $opponent के ख़िलाफ़ $score। देश अब यक़ीन करना शुरू कर सकता है।';
  }

  @override
  String yKnockoutWin2(String opponent, String score) {
    return '$opponent के ख़िलाफ़ $score और अगले दौर में। क्या रात है।';
  }

  @override
  String yKnockoutWin3(String opponent, String score) {
    return '$opponent घर लौटेगा, $score। आगे बढ़ो।';
  }

  @override
  String yKnockoutWin4(String opponent, String score) {
    return 'नॉकआउट: $opponent के ख़िलाफ़ $score। अगला दौर पक्का।';
  }

  @override
  String yKnockoutWin5(String opponent, String score) {
    return 'आगे: $opponent के ख़िलाफ़ $score।';
  }

  @override
  String yKnockoutWin6(String opponent, String score) {
    return '$opponent बाहर, $score। अगला दौर इंतज़ार कर रहा है।';
  }

  @override
  String yKnockoutWin7(String opponent, String score) {
    return '$opponent के ख़िलाफ़ $score से जीत। नॉकआउट में कोई नहीं पूछता कैसे।';
  }

  @override
  String yKnockoutWin8(String opponent, String score) {
    return '$opponent के ख़िलाफ़ आगे, $score। अगला प्रतिद्वंद्वी इतना मेहरबान नहीं होगा।';
  }

  @override
  String yKnockoutWin9(String opponent, String score) {
    return '$opponent के ख़िलाफ़ $score आगे बढ़ने को काफ़ी है। अगली बार कहीं ज़्यादा चाहिए होगा।';
  }

  @override
  String yKnockoutWin10(String opponent, String score) {
    return '$opponent बाहर, $score। जीते कम, बचे ज़्यादा।';
  }

  @override
  String yKnockoutWin11(String opponent, String score) {
    return '$opponent के ख़िलाफ़ $score के बाद अगले दौर में। मत पूछिए कैसे।';
  }

  @override
  String yUpsetGap0(String opponent, String gap) {
    return 'रैंकिंग में $gap पायदानों का फ़ासला, फिर भी $opponent को हराया। शानदार।';
  }

  @override
  String yUpsetGap1(String opponent, String gap) {
    return '$opponent: हमसे $gap पायदान ऊपर। फिर भी हारे। फ़ुटबॉल ख़ूबसूरत है।';
  }

  @override
  String yUpsetGap2(String opponent, String gap) {
    return 'रैंकिंग का अंतर: $gap। नतीजा: $opponent पर जीत। कभी यक़ीन मत छोड़िए।';
  }

  @override
  String yUpsetGap3(String opponent, String gap) {
    return 'किकऑफ़ से पहले रैंकिंग का अंतर: $gap। फिर भी $opponent पर जीत।';
  }

  @override
  String yUpsetGap4(String opponent, String gap) {
    return 'विश्व रैंकिंग में $opponent हमसे $gap पायदान ऊपर था। आज रात नहीं।';
  }

  @override
  String yUpsetGap5(String opponent, String gap) {
    return 'उलटफेर सूचकांक: दोनों टीमों के बीच $gap रैंकिंग पायदान। $opponent पर जीत हमारी।';
  }

  @override
  String yUpsetGap6(String opponent, String gap) {
    return '$opponent और हमारे बीच रैंकिंग में $gap पायदान थे। एक रात यह फ़ासला नहीं पाटती।';
  }

  @override
  String yUpsetGap7(String opponent, String gap) {
    return '$opponent: $gap पायदान ऊपर, और हार गया। रैंकिंग को शायद ही पता चले।';
  }

  @override
  String yUpsetGap8(String gap) {
    return 'रैंकिंग का अंतर: $gap। अगली बार किसी कमज़ोर टीम से हारें तो यह संख्या याद रखिए।';
  }

  @override
  String yEatWords0(String opponent) {
    return 'मैंने इस टीम को ख़ारिज कर दिया था। मैं ग़लत था, और ग़लत होने पर इतना ख़ुश कभी नहीं हुआ। $opponent पर जीत।';
  }

  @override
  String yEatWords1(String opponent) {
    return 'विनम्रता की एक प्लेट, प्लीज़। बड़ी वाली। $opponent पर जीत शानदार थी।';
  }

  @override
  String yEatWords2(String opponent) {
    return 'मैंने कहा था इनमें कुछ नहीं बचा। बहुत कुछ था। $opponent के ख़िलाफ़ सबने अच्छा खेला।';
  }

  @override
  String yEatWords3(String opponent) {
    return 'रिकॉर्ड के लिए, $opponent पर यह जीत मैंने आते नहीं देखी। श्रेय देना चाहिए।';
  }

  @override
  String yEatWords4(String opponent) {
    return 'ठीक है। मैंने कहा था इनकी पोल खुलेगी। $opponent पोल नहीं खोल पाया।';
  }

  @override
  String yEatWords5(String opponent) {
    return 'आज रात मैं इस टीम पर अपने शब्द वापस लेता हूँ। $opponent पर जीत इसकी हक़दार है।';
  }

  @override
  String yEatWords6(String opponent) {
    return 'हाँ, मैंने कहा था ये ख़त्म हैं। $opponent पर एक जीत अभी मुझे ग़लत साबित नहीं करती।';
  }

  @override
  String yEatWords7(String opponent) {
    return 'कहते हैं $opponent के बाद मुझे अपने शब्द निगलने चाहिए। निगलूँगा, धीरे-धीरे, और रसीद रख लूँगा।';
  }

  @override
  String yEatWords8(String opponent) {
    return '$opponent पर जीत प्रभावशाली थी। इस टीम को लेकर मेरे शक कहीं नहीं गए।';
  }

  @override
  String yAwayFansWin0(String nation, String score) {
    return '$nation को सलाम। $score, और पूरी तरह हक़दार।';
  }

  @override
  String yAwayFansWin1(String nation, String score) {
    return 'कहना दुखता है, पर आज रात $nation बेहतर था। $score। बधाई।';
  }

  @override
  String yAwayFansWin2(String nation, String score) {
    return '$score। $nation को हैट्स ऑफ़, उनमें ज़्यादा भूख थी।';
  }

  @override
  String yAwayFansWin3(String nation, String score) {
    return '$nation से $score से हार। समझ नहीं आ रहा क्या कहूँ।';
  }

  @override
  String yAwayFansWin4(String nation, String score) {
    return '$nation $score। हमारे खिलाड़ियों को शर्म आनी चाहिए।';
  }

  @override
  String yAwayFansWin5(String nation, String score) {
    return '$nation के ख़िलाफ़ $score। कोई समझाए यह हुआ कैसे।';
  }

  @override
  String yAwayFansWin6(String nation, String score) {
    return '$nation से $score से हारना। मैं इससे कभी उबर नहीं पाऊँगा।';
  }

  @override
  String yAwayFansWin7(String nation, String score) {
    return '$nation के ख़िलाफ़ $score। क़िस्मत। सिर्फ़ क़िस्मत।';
  }

  @override
  String yAwayFansWin8(String nation, String score) {
    return 'इस $score के बाद $nation के फ़ैन बरसों तक असहनीय रहेंगे। किसी चीज़ के लिए शुक्रिया नहीं।';
  }

  @override
  String yNeutralWin0(String nation, String opponent, String score) {
    return '$nation $score $opponent। फ़ुटबॉल के लिए शानदार। इसीलिए हम इसे प्यार करते हैं।';
  }

  @override
  String yNeutralWin1(String nation, String opponent, String score) {
    return '$nation के लिए क्या नतीजा: $opponent के ख़िलाफ़ $score। फ़ुटबॉल अपने सबसे अच्छे रूप में।';
  }

  @override
  String yNeutralWin2(String nation, String opponent, String score) {
    return 'आज रात हर तटस्थ दर्शक $nation के साथ है। $opponent के ख़िलाफ़ $score!';
  }

  @override
  String yNeutralWin3(String nation, String opponent, String score) {
    return 'राउंड का नतीजा: $nation $score $opponent।';
  }

  @override
  String yNeutralWin4(String nation, String opponent, String score) {
    return '$nation $score $opponent। यह किसी के अनुमान में नहीं था।';
  }

  @override
  String yNeutralWin5(String nation, String opponent, String score) {
    return 'बड़ा नतीजा: $nation $score $opponent। रैंकिंग हिलेगी।';
  }

  @override
  String yNeutralWin6(String nation, String opponent, String score) {
    return '$nation $score $opponent। मज़ेदार, देखते हैं क्या वे दोबारा कर पाते हैं।';
  }

  @override
  String yNeutralWin7(String nation, String opponent, String score) {
    return '$nation $score $opponent। $nation जीता, या $opponent हारा?';
  }

  @override
  String yNeutralWin8(String nation, String opponent, String score) {
    return 'चौंकाने वाला नतीजा: $nation $score $opponent। ढेर सारी अति-प्रतिक्रियाओं के लिए तैयार रहिए।';
  }

  @override
  String yScorerHero0(String name, String opponent) {
    return '$opponent के ख़िलाफ़ $name। लोग अपने बच्चों के नाम उसके नाम पर रखेंगे।';
  }

  @override
  String yScorerHero1(String name, String opponent) {
    return '$name की मूर्ति लगाओ। आज रात $opponent के ख़िलाफ़ वही सब कुछ था।';
  }

  @override
  String yScorerHero2(String name, String opponent) {
    return '$name, कमाल कर दिया। $opponent के ख़िलाफ़ यह रात याद रखिए।';
  }

  @override
  String yScorerHero3(String name, String opponent) {
    return '$opponent के ख़िलाफ़ फ़ैसला $name ने किया। मैन ऑफ़ द मैच, कोई बहस नहीं।';
  }

  @override
  String yScorerHero4(String name, String opponent) {
    return '$opponent के ख़िलाफ़ यह रात $name के नाम रही।';
  }

  @override
  String yScorerHero5(String name, String opponent) {
    return '$opponent के ख़िलाफ़ ज़रूरत के वक़्त $name सामने आया।';
  }

  @override
  String yScorerHero6(String name, String opponent) {
    return '$opponent के ख़िलाफ़ $name लाजवाब था। अब हर हफ़्ते ऐसा ही चाहिए।';
  }

  @override
  String yScorerHero7(String name, String opponent) {
    return '$opponent के ख़िलाफ़ $name ने टीम को बचाया। बाक़ियों ने कम मदद की।';
  }

  @override
  String yScorerHero8(String name, String opponent) {
    return '$name के बिना $opponent के ख़िलाफ़ यह रात बिल्कुल अलग होती।';
  }

  @override
  String yLostShock0(String opponent, String score) {
    return '$opponent से $score। एक हादसा। हर किसी के साथ एक बार होता है।';
  }

  @override
  String yLostShock1(String opponent, String score) {
    return '$opponent से $score से हार। झटक दीजिए, अभियान ख़त्म नहीं हुआ।';
  }

  @override
  String yLostShock2(String opponent, String score) {
    return '$opponent $score। दर्दनाक, पर एक नतीजा इस टीम की पहचान नहीं।';
  }

  @override
  String yLostShock3(String opponent, String score) {
    return '$opponent के ख़िलाफ़ $score। दफ़्तर में बुरा दिन। आगे बढ़िए।';
  }

  @override
  String yLostShock4(String opponent, String score) {
    return '$opponent से हार, $score। किसी ने इसकी उम्मीद नहीं की थी।';
  }

  @override
  String yLostShock5(String opponent, String score) {
    return '$opponent $score। उन रातों में से एक जिनका कोई मतलब नहीं बनता।';
  }

  @override
  String yLostShock6(String opponent, String score) {
    return '$opponent से $score। एक हार जो याद रखी जाएगी।';
  }

  @override
  String yLostShock7(String opponent, String score) {
    return '$opponent ने हराया, $score। किसी भी नज़र से बड़ा उलटफेर।';
  }

  @override
  String yLostShock8(String opponent, String score) {
    return '$opponent से $score। $opponent से! अस्वीकार्य।';
  }

  @override
  String yLostShock9(String opponent, String score) {
    return '$opponent से $score से हार। मुझे सफ़ाई चाहिए, बहाने नहीं।';
  }

  @override
  String yLostShock10(String opponent, String score) {
    return '$opponent $score। राष्ट्रीय शर्म, और यह अतिशयोक्ति नहीं है।';
  }

  @override
  String yLostShock11(String opponent, String score) {
    return '$opponent के ख़िलाफ़ $score। ऊपर बैठे लोग अब भी अपनी कुर्सी पर कैसे हैं?';
  }

  @override
  String yLostRout0(String opponent, String score) {
    return '$opponent से $score। वे शीर्ष टीम हैं। सीखिए।';
  }

  @override
  String yLostRout1(String opponent, String score) {
    return '$opponent ने पूरी तरह पछाड़ा, $score। सबसे अच्छों से हारने में शर्म नहीं।';
  }

  @override
  String yLostRout2(String opponent, String score) {
    return '$opponent $score। एक सबक़, और सबक़ से ही आगे बढ़ते हैं।';
  }

  @override
  String yLostRout3(String opponent, String score) {
    return '$opponent के ख़िलाफ़ $score। दर्दनाक, पर वे एक स्तर ऊपर हैं।';
  }

  @override
  String yLostRout4(String opponent, String score) {
    return '$opponent की जीत, $score। फ़ासला असली है, और अब सबने देख लिया।';
  }

  @override
  String yLostRout5(String opponent, String score) {
    return '$opponent से $score। सीधी-सीधी पिटाई।';
  }

  @override
  String yLostRout6(String opponent, String score) {
    return '$opponent $score। बेहतर टीम, और स्कोर यही कहता है।';
  }

  @override
  String yLostRout7(String opponent, String score) {
    return '$opponent से $score से हार। शर्मनाक नहीं, पर मुक़ाबला भी नहीं।';
  }

  @override
  String yLostRout8(String opponent, String score) {
    return '$opponent से $score। बेहतर विरोधी हो या नहीं, ऐसे नहीं हारा जाता।';
  }

  @override
  String yLostRout9(String opponent, String score) {
    return '$opponent $score। क्या हमने मुक़ाबला करने की कोशिश भी की?';
  }

  @override
  String yLostRout10(String opponent, String score) {
    return '$score। $opponent के ख़िलाफ़। जैसे मेमने क़त्लगाह में।';
  }

  @override
  String yLostRout11(String opponent, String score) {
    return '$opponent से $score से हार, और कोई परेशान नहीं दिखा।';
  }

  @override
  String yLostShootout0(String opponent) {
    return '$opponent के ख़िलाफ़ पेनल्टी में बाहर। उन्होंने सब कुछ झोंक दिया। उन पर गर्व है।';
  }

  @override
  String yLostShootout1(String opponent) {
    return '$opponent के ख़िलाफ़ पेनल्टी। बाहर होने का सबसे क्रूर तरीका। सिर ऊँचा रखिए।';
  }

  @override
  String yLostShootout2(String opponent) {
    return '$opponent के ख़िलाफ़ पेनल्टी शूटआउट हारे। कोई इसका हक़दार नहीं था।';
  }

  @override
  String yLostShootout3(String opponent) {
    return '$opponent के ख़िलाफ़ पेनल्टी में बाहर। फ़ैसला पेनल्टी स्पॉट ने किया।';
  }

  @override
  String yLostShootout4(String opponent) {
    return '$opponent पेनल्टी में आगे। हमारा टूर्नामेंट यहीं ख़त्म।';
  }

  @override
  String yLostShootout5(String opponent) {
    return '$opponent के ख़िलाफ़ शूटआउट हारे। फिर से पेनल्टी।';
  }

  @override
  String yLostShootout6(String opponent) {
    return '$opponent के ख़िलाफ़ पेनल्टी में बाहर। क्या हम कभी इनका अभ्यास करते हैं?';
  }

  @override
  String yLostShootout7(String opponent) {
    return '$opponent से पेनल्टी में हार। इसे बहुत पहले निपटा देना चाहिए था।';
  }

  @override
  String yLostShootout8(String opponent) {
    return '$opponent के ख़िलाफ़ पेनल्टी, और हम हार गए। ज़ाहिर है।';
  }

  @override
  String yKnockoutLoss0(String opponent, String score) {
    return 'बाहर। $opponent से $score। गर्व करने लायक़ सफ़र यहीं ख़त्म होता है।';
  }

  @override
  String yKnockoutLoss1(String opponent, String score) {
    return '$opponent ने बाहर किया, $score। यादों के लिए शुक्रिया।';
  }

  @override
  String yKnockoutLoss2(String opponent, String score) {
    return '$opponent के ख़िलाफ़ $score। सफ़र ख़त्म, पर क्या सफ़र था।';
  }

  @override
  String yKnockoutLoss3(String opponent, String score) {
    return 'बाहर: $opponent से $score। सिर ऊँचा।';
  }

  @override
  String yKnockoutLoss4(String opponent, String score) {
    return 'समाप्त: $opponent के ख़िलाफ़ $score।';
  }

  @override
  String yKnockoutLoss5(String opponent, String score) {
    return 'बाहर: $opponent के ख़िलाफ़ $score।';
  }

  @override
  String yKnockoutLoss6(String opponent, String score) {
    return '$opponent आगे, $score। हमारा टूर्नामेंट ख़त्म।';
  }

  @override
  String yKnockoutLoss7(String opponent, String score) {
    return '$opponent ने बाहर किया, $score। अब पोस्टमार्टम शुरू।';
  }

  @override
  String yKnockoutLoss8(String opponent, String score) {
    return 'बाहर। $opponent से $score। दूसरा टूर्नामेंट, वही अंत।';
  }

  @override
  String yKnockoutLoss9(String opponent, String score) {
    return '$opponent से $score, और घर वापसी। किसी को हैरानी नहीं।';
  }

  @override
  String yKnockoutLoss10(String opponent, String score) {
    return '$opponent ने बाहर किया, $score। सुबह तक बहानों का इंतज़ार कीजिए।';
  }

  @override
  String yKnockoutLoss11(String opponent, String score) {
    return '$opponent $score। बाहर, और कभी लगा ही नहीं कि अंत कुछ और होगा।';
  }

  @override
  String yAwayFansGloat0(String nation, String score) {
    return '$nation के ख़िलाफ़ $score। सम्मान, वे और मज़बूत होकर लौटेंगे।';
  }

  @override
  String yAwayFansGloat1(String nation, String score) {
    return 'हमारे लिए अच्छी जीत, $score। $nation के लिए बुरा दिन, उनके फ़ैंस के लिए दुख है।';
  }

  @override
  String yAwayFansGloat2(String nation, String score) {
    return '$score। $nation की बुरी रात, और हमने मौक़ा भुना लिया। यही फ़ुटबॉल है।';
  }

  @override
  String yAwayFansGloat3(String nation, String score) {
    return '$nation के ख़िलाफ़ $score! किसने सोचा था? उन्होंने तो नहीं।';
  }

  @override
  String yAwayFansGloat4(String nation, String score) {
    return '$nation पर $score से जीत। कोई उनके फ़ैंस का हाल तो देखे।';
  }

  @override
  String yAwayFansGloat5(String nation, String score) {
    return '$nation $score। यह फ़ोटो एलबम में जाएगा।';
  }

  @override
  String yAwayFansGloat6(String nation, String score) {
    return '$nation के ख़िलाफ़ $score। और वे ख़ुद को बड़ी टीम समझते हैं।';
  }

  @override
  String yAwayFansGloat7(String nation, String score) {
    return 'सोचिए हमसे $score से हारना। $nation से पूछिए, अब वे जानते हैं।';
  }

  @override
  String yAwayFansGloat8(String nation, String score) {
    return '$nation, $score। घर की उड़ान शुभ हो।';
  }

  @override
  String yNeutralLoss0(String nation, String opponent, String score) {
    return '$nation $score $opponent। $opponent के लिए बड़ी रात, $nation के लिए मुश्किल।';
  }

  @override
  String yNeutralLoss1(String nation, String opponent, String score) {
    return '$opponent के ख़िलाफ़ $score के बाद $nation के फ़ैंस को हौसला। वे फिर उठेंगे।';
  }

  @override
  String yNeutralLoss2(String nation, String opponent, String score) {
    return '$nation $score $opponent। हर बड़ी टीम की ऐसी एक रात होती है।';
  }

  @override
  String yNeutralLoss3(String nation, String opponent, String score) {
    return 'राउंड का झटका: $nation $score $opponent।';
  }

  @override
  String yNeutralLoss4(String nation, String opponent, String score) {
    return '$nation $score $opponent। किसी ने यह आते नहीं देखा।';
  }

  @override
  String yNeutralLoss5(String nation, String opponent, String score) {
    return 'दिन का नतीजा: $nation $score $opponent। अब $nation से सवाल होंगे।';
  }

  @override
  String yNeutralLoss6(String nation, String opponent, String score) {
    return '$nation $score $opponent। अगर आप देख रहे थे, तो यह संयोग नहीं।';
  }

  @override
  String yNeutralLoss7(String nation, String opponent, String score) {
    return '$nation $score $opponent। वहाँ किसी को बहुत कुछ समझाना पड़ेगा।';
  }

  @override
  String yNeutralLoss8(String nation, String opponent, String score) {
    return '$nation $score $opponent। बड़ा नाम, छोटा प्रदर्शन।';
  }

  @override
  String yDownGap0(String opponent, String gap) {
    return '$opponent: हमसे $gap पायदान नीचे। होता है। आगे बढ़िए।';
  }

  @override
  String yDownGap1(String gap) {
    return 'रैंकिंग का अंतर: हमारे पक्ष में $gap। फ़ुटबॉल रैंकिंग नहीं पढ़ता।';
  }

  @override
  String yDownGap2(String opponent, String gap) {
    return 'काग़ज़ पर हमारे और $opponent के बीच $gap पायदान। आज रात मैदान पर नहीं।';
  }

  @override
  String yDownGap3(String opponent, String gap) {
    return 'किकऑफ़ से पहले रैंकिंग का अंतर: हमारे पक्ष में $gap। फिर भी $opponent से हार।';
  }

  @override
  String yDownGap4(String opponent, String gap) {
    return 'विश्व रैंकिंग में $opponent हमसे $gap पायदान नीचे था। नतीजा: हार।';
  }

  @override
  String yDownGap5(String opponent, String gap) {
    return 'उलटफेर सूचकांक: $gap रैंकिंग पायदान, उल्टी दिशा में, $opponent के ख़िलाफ़।';
  }

  @override
  String yDownGap6(String opponent, String gap) {
    return 'रैंकिंग में $opponent से $gap पायदान ऊपर। हार। समझाइए।';
  }

  @override
  String yDownGap7(String gap) {
    return 'हमसे $gap पायदान नीचे की टीम से हार। इस संख्या को ज़रा समझिए।';
  }

  @override
  String yDownGap8(String opponent, String gap) {
    return 'रैंकिंग का अंतर: $gap। $opponent से हार। किसी को दिन गिनने शुरू कर देने चाहिए।';
  }

  @override
  String yDrewHeroic0(String opponent, String score) {
    return '$opponent के ख़िलाफ़ $score! ड्रॉ जो जीत जैसा लगे।';
  }

  @override
  String yDrewHeroic1(String opponent, String score) {
    return '$opponent के ख़िलाफ़ $score। हर एक पर गर्व है।';
  }

  @override
  String yDrewHeroic2(String opponent, String score) {
    return '$opponent $score। वे दावेदार थे और हमने बराबरी की।';
  }

  @override
  String yDrewHeroic3(String opponent, String score) {
    return '$opponent के साथ $score। ख़ून-पसीने से कमाया अंक।';
  }

  @override
  String yDrewHeroic4(String opponent, String score) {
    return '$opponent के ख़िलाफ़ $score। बहुत अच्छा अंक।';
  }

  @override
  String yDrewHeroic5(String opponent, String score) {
    return '$opponent के साथ $score से ड्रॉ। कम ही लोगों को कुछ उम्मीद थी।';
  }

  @override
  String yDrewHeroic6(String opponent, String score) {
    return '$opponent को रोका, $score। इस नतीजे पर आगे बढ़ा जा सकता है।';
  }

  @override
  String yDrewHeroic7(String opponent, String score) {
    return '$opponent के ख़िलाफ़ $score। एक अंक जो किसी ने हमें नहीं दिया था।';
  }

  @override
  String yDrewHeroic8(String opponent, String score) {
    return '$opponent के साथ $score। अच्छा अंक, पर ड्रॉ से कुछ नहीं जीता जाता।';
  }

  @override
  String yDrewHeroic9(String opponent, String score) {
    return '$opponent के ख़िलाफ़ $score। अच्छा है। हमारा एक भी ढंग का शॉट नहीं था।';
  }

  @override
  String yDrewHeroic10(String opponent, String score) {
    return '$opponent $score। एक अंक, और सब ऐसे बर्ताव कर रहे हैं जैसे ट्रॉफ़ी जीत ली।';
  }

  @override
  String yDrewHeroic11(String opponent, String score) {
    return '$opponent के ख़िलाफ़ $score। बस खड़ी कर दी और क़िस्मत साथ थी।';
  }

  @override
  String yDrewShame0(String opponent, String score) {
    return '$opponent के साथ $score। खीझ होती है, पर अब भी अजेय।';
  }

  @override
  String yDrewShame1(String opponent, String score) {
    return '$opponent के साथ सिर्फ़ $score। बुरा दिन। होता है।';
  }

  @override
  String yDrewShame2(String opponent, String score) {
    return '$opponent $score। काफ़ी नहीं, और खिलाड़ी यह जानते हैं।';
  }

  @override
  String yDrewShame3(String opponent, String score) {
    return '$opponent के ख़िलाफ़ $score। दो अंक गँवाए, बस।';
  }

  @override
  String yDrewShame4(String opponent, String score) {
    return '$opponent के साथ $score। दो अंक फेंक दिए।';
  }

  @override
  String yDrewShame5(String opponent, String score) {
    return '$opponent के साथ सिर्फ़ $score। बुरा नतीजा, चाहे जैसे पेश करें।';
  }

  @override
  String yDrewShame6(String opponent, String score) {
    return '$opponent $score। ड्रॉ जो हार जैसा लगे।';
  }

  @override
  String yDrewShame7(String opponent, String score) {
    return '$opponent के ख़िलाफ़ $score। ऐसे मैच हमें आराम से जीतने चाहिए।';
  }

  @override
  String yDrewShame8(String opponent, String score) {
    return '$opponent के साथ $score। शर्मनाक।';
  }

  @override
  String yDrewShame9(String opponent, String score) {
    return '$opponent के साथ सिर्फ़ ड्रॉ, $score। इसका ज़िम्मेदार कौन है?';
  }

  @override
  String yDrewShame10(String opponent, String score) {
    return '$opponent $score। अगर इन्हें नहीं हरा सकते, तो किसे हराएँगे?';
  }

  @override
  String yDrewShame11(String opponent, String score) {
    return '$opponent के साथ $score। उनके फ़ैंस हमारे ख़िलाफ़ ड्रॉ का जश्न मना रहे हैं। सोचिए।';
  }

  @override
  String yTrophy0(String opponent) {
    return 'चैंपियन। $opponent। ज़ोर से बोलिए।';
  }

  @override
  String yTrophy1(String opponent) {
    return 'हमने जीत लिया। $opponent। मैं ठीक नहीं हूँ।';
  }

  @override
  String yTrophy2(String opponent) {
    return '$opponent, और ट्रॉफ़ी घर आ रही है।';
  }

  @override
  String yTrophy3(String opponent) {
    return 'इनमें से हर एक खिलाड़ी दिग्गज है। $opponent।';
  }

  @override
  String yRunnerUp0(String opponent) {
    return 'बस ज़रा सा चूके। $opponent और एक ऐसा मेडल जो कोई नहीं चाहता।';
  }

  @override
  String yRunnerUp1(String opponent) {
    return '$opponent में उपविजेता। यह टीस सालों रहेगी।';
  }

  @override
  String yRunnerUp2(String opponent) {
    return '$opponent: सब कुछ से बस एक मैच दूर।';
  }

  @override
  String yRunnerUp3(String opponent) {
    return 'दूसरे नंबर पर। $opponent में। कोई बोतल पकड़ाओ।';
  }

  @override
  String yEliminated0(String opponent) {
    return '$opponent में बाहर। यह चोट काफ़ी दिन रहेगी।';
  }

  @override
  String yEliminated1(String opponent) {
    return '$opponent पर हमारा सफ़र ख़त्म होता है।';
  }

  @override
  String yEliminated2(String opponent) {
    return '$opponent में बाहर। अब पोस्टमॉर्टम की बारी।';
  }

  @override
  String yEliminated3(String opponent) {
    return '$opponent में बाहर हुए। कोई मुझे यह समझाए।';
  }

  @override
  String yQualified0(String opponent) {
    return 'हम $opponent जा रहे हैं।';
  }

  @override
  String yQualified1(String opponent) {
    return '$opponent के लिए क्वालिफ़ाई किया। दफ़्तर से छुट्टी बुक कर लो।';
  }

  @override
  String yQualified2(String opponent) {
    return '$opponent, हम आ रहे हैं। कभी शक नहीं था (शक पूरा-पूरा था)।';
  }

  @override
  String yQualified3(String opponent) {
    return '$opponent में पहुँच गए। सबसे मुश्किल हिस्सा पूरा हुआ।';
  }

  @override
  String yGroupDrawn0(String opponent) {
    return '$opponent के ग्रुप तय हो गए। बुरा हो सकता था। बहुत बुरा हो सकता था।';
  }

  @override
  String yGroupDrawn1(String opponent) {
    return 'तो यह रहा $opponent का ड्रॉ। दिलचस्प।';
  }

  @override
  String yGroupDrawn2(String opponent) {
    return '$opponent के ग्रुप आ गए हैं और हमारा ग्रुप मुझे पहले ही पसंद नहीं आया।';
  }

  @override
  String yGroupDrawn3(String opponent) {
    return '$opponent का ड्रॉ हो गया। अब बढ़-चढ़कर प्रतिक्रियाएँ शुरू।';
  }

  @override
  String yHostNamed0(String opponent) {
    return '$opponent की मेज़बानी होगी। बचत शुरू कर दीजिए।';
  }

  @override
  String yHostNamed1(String opponent) {
    return 'यह $opponent जा रहा है। अनुमान के मुताबिक, पर ठीक है।';
  }

  @override
  String yHostNamed2(String opponent) {
    return 'टूर्नामेंट $opponent को मिला। उन्हें बधाई, मान लेता हूँ।';
  }

  @override
  String yHostNamed3(String opponent) {
    return 'मेज़बान तय: $opponent।';
  }

  @override
  String yTournamentSoon0(String opponent) {
    return '$opponent जल्द शुरू हो रहा है और मैं चैन से बैठ नहीं पा रहा।';
  }

  @override
  String yTournamentSoon1(String opponent) {
    return '$opponent में अब ज़्यादा देर नहीं।';
  }

  @override
  String yTournamentSoon2(String opponent) {
    return '$opponent लगभग आ गया। स्क्वॉड का ऐलान कीजिए, प्लीज़।';
  }

  @override
  String yTournamentSoon3(String opponent) {
    return '$opponent की उलटी गिनती अब आधिकारिक रूप से असहनीय है।';
  }

  @override
  String get navY => 'Y';

  @override
  String get yTitle => 'Y';

  @override
  String get yEmpty => 'अभी कहने को कुछ नहीं। एक मैच खेलिए।';

  @override
  String get yEarlierHeading => 'इस चक्र में पहले';

  @override
  String get yTraitLoyalist =>
      'हर हाल में टीम के साथ। देर से पलटता है, जल्दी माफ़ कर देता है।';

  @override
  String get yTraitCynic =>
      'हमेशा बुरे की उम्मीद रखता है और सही निकलने पर ख़ुश होता है।';

  @override
  String get yTraitNostalgic =>
      'पहले सब कुछ बेहतर था। आपको रिटायर हो चुके खिलाड़ियों से तौलता है।';

  @override
  String get yTraitStatshead =>
      'सिर्फ़ आँकड़े पोस्ट करता है, और कुछ नहीं। मूड लगभग है ही नहीं।';

  @override
  String get yTraitHypeman => 'दो अच्छे नतीजे और बस, सुनहरी पीढ़ी आ गई।';

  @override
  String get yTraitContrarian => 'माहौल जो भी सोचे, यह उसका उल्टा कहता है।';

  @override
  String get yTraitDoomer => 'सब बिगड़ने वाला है। हमेशा बिगड़ने वाला ही है।';

  @override
  String get yProfilePosts => 'पोस्ट';

  @override
  String get yProfileEmpty => 'इस अकाउंट से अभी कुछ नहीं।';

  @override
  String hubEventGrievance(String player) {
    return '$player आपसे बात करना चाहता है';
  }

  @override
  String get hubEventGrievanceSub => 'वह जानना चाहता है कि उसकी जगह कहाँ है';

  @override
  String hubEventManagerSkills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ख़र्च करने के लिए $count स्किल पॉइंट',
      one: 'ख़र्च करने के लिए 1 स्किल पॉइंट',
    );
    return '$_temp0';
  }

  @override
  String get hubEventManagerSkillsSub =>
      'आपकी खूबियाँ आपकी टीम को बेहतर बनाती हैं';

  @override
  String get grievanceTitle => 'आपके दफ़्तर में एक बात';

  @override
  String grievanceGameTime(String player) {
    return '$player स्क्वॉड में है, पर उसने एक बार भी गेंद नहीं छुई। वह जानना चाहता है कि क्यों।';
  }

  @override
  String grievanceSquadPlace(String player) {
    return '$player स्क्वॉड में नहीं है और यह उसकी समझ से बाहर है। वह साफ़ जवाब चाहता है, हाँ या ना।';
  }

  @override
  String grievanceRole(String player) {
    return '$player को बार-बार ग़लत पोज़िशन पर खिलाया जा रहा है और वह तंग आ चुका है।';
  }

  @override
  String get grievanceReassure => 'आप मेरी योजनाओं में हैं';

  @override
  String get grievanceHonest => 'आप दूसरों से पीछे हैं, और वजह यह है';

  @override
  String get grievanceDismiss => 'टीम मैं चुनता हूँ';

  @override
  String yScorerStar0(String name, String goals) {
    return '$name ने $goals गोल किए। कोई और आसपास भी नहीं।';
  }

  @override
  String yScorerStar1(String name, String goals) {
    return '$name के $goals गोल। यह टीम को अकेले खींच रहा है।';
  }

  @override
  String yScorerStar2(String name, String goals) {
    return '$name: आज $goals गोल। क्या खिलाड़ी है।';
  }

  @override
  String yScorerStar3(String name, String goals) {
    return '$name ने उन पर $goals गोल ठोके। सलाम।';
  }

  @override
  String yScorerStar4(String name, String goals) {
    return '$name के $goals गोल, और बाक़ी सब बस सवारी थे।';
  }

  @override
  String yScorerStar5(String name, String goals) {
    return 'फिर $name। $goals गोल। इस टीम की उसके बिना कल्पना कीजिए।';
  }

  @override
  String yScorerStar6(String name, String goals) {
    return '$name से $goals गोल। एक आदमी पर इतना बोझ नहीं होना चाहिए।';
  }

  @override
  String yScorerStar7(String name, String goals) {
    return '$name को हटा दो तो $goals गोल कम और दोपहर बिल्कुल अलग होती।';
  }

  @override
  String yWinStreak0(String count) {
    return 'लगातार $count जीत। ड्रेसिंग रूम में जो भी कहा जा रहा है, असर कर रहा है।';
  }

  @override
  String yWinStreak1(String count) {
    return 'यह लगातार $count हुईं। टीमें ऐसी लय में अचानक नहीं पहुँचतीं।';
  }

  @override
  String yWinStreak2(String count) {
    return 'लगातार $count और सिलसिला जारी। आत्मविश्वास स्टैंड से भी दिखता है।';
  }

  @override
  String yWinStreak3(String count) {
    return '$count मैचों में कोई हार नहीं। किसी भी कोच से पूछ लीजिए: यही सबसे मुश्किल है।';
  }

  @override
  String yWinStreak4(String count) {
    return 'लगातार $count। जब तक फ़िक्स्चर मेहरबान हैं, मज़ा लीजिए।';
  }

  @override
  String yWinStreak5(String count) {
    return 'लगातार $count, और हमने किसी ढंग की टीम को नहीं हराया।';
  }

  @override
  String yWinStreak6(String count) {
    return '$count का सिलसिला। परीक्षा होने पर मुझसे दोबारा पूछिए।';
  }

  @override
  String yWinStreak7(String count) {
    return 'लगातार $count। हर टीम में ऐसा एक दौर एक बार आता ही है।';
  }

  @override
  String yLossStreak0(String count) {
    return 'अब $count मैचों से जीत नहीं। कभी तो बहाने ख़त्म होंगे।';
  }

  @override
  String yLossStreak1(String count) {
    return 'लगातार $count हार गईं। अब यह एक चूक नहीं रही।';
  }

  @override
  String yLossStreak2(String count) {
    return 'लगातार $count हार। इसका जवाब किसी को देना होगा।';
  }

  @override
  String yLossStreak3(String count) {
    return '$count मैचों में जीत नहीं। उनके खेल में यह साफ़ दिखता है।';
  }

  @override
  String yLossStreak4(String count) {
    return '$count मैचों से जीत नहीं और हर हफ़्ते वही गलतियाँ।';
  }

  @override
  String yLossStreak5(String count) {
    return 'लगातार $count। जो भी आज़माया जा रहा है, काम नहीं कर रहा।';
  }

  @override
  String yLossStreak6(String count) {
    return 'लगातार $count। यह एक दिशा है, गिरावट का दौर नहीं।';
  }

  @override
  String yLossStreak7(String count) {
    return '$count मैचों में जीत नहीं, और ऊपर किसी ने एक शब्द नहीं कहा।';
  }

  @override
  String yRivalry0(String opponent, String score) {
    return '$opponent $score। फ़ुटबॉल के बारे में जो चाहे कह लो। यह नतीजा दोगुना मायने रखता है।';
  }

  @override
  String yRivalry1(String opponent, String score) {
    return '$opponent के ख़िलाफ़, सबसे बढ़कर। $score। यहाँ कोई इसे नहीं भूलेगा।';
  }

  @override
  String yRivalry2(String opponent, String score) {
    return '$opponent के ख़िलाफ़ $score। यही वह मैच है जिसकी चर्चा चौराहों पर होगी।';
  }

  @override
  String yRivalry3(String opponent, String score) {
    return 'पड़ोसी से $score। कुछ समय के लिए शेखी बघारने का हक़ पक्का।';
  }

  @override
  String yRivalry4(String opponent, String score) {
    return '$opponent $score। इस साल और कुछ भी हो, यह तो रहेगा।';
  }

  @override
  String yRivalry5(String opponent, String score) {
    return '$opponent के ख़िलाफ़ $score। हममें से कुछ को इसकी तालिका से ज़्यादा ज़रूरत थी।';
  }

  @override
  String yRivalry6(String opponent, String score) {
    return '$opponent $score। और अगली बार वे इसका हिसाब चुकता कर लेंगे, वे हमेशा करते हैं।';
  }

  @override
  String yRivalry7(String opponent, String score) {
    return '$opponent के ख़िलाफ़, $score। पूरे साल इसकी याद दिलाई जाएगी।';
  }

  @override
  String yInjuryBlow0(String name) {
    return '$name चोटिल होकर बाहर। इस टीम को सबसे आख़िर में यही चाहिए था।';
  }

  @override
  String yInjuryBlow1(String name) {
    return '$name को खोने से पूरी योजना की शक्ल बदल जाती है।';
  }

  @override
  String yInjuryBlow2(String name) {
    return '$name लंगड़ा रहा है। साँस थाम लीजिए।';
  }

  @override
  String yInjuryBlow3(String name) {
    return 'तो कुछ समय $name नहीं होगा। किसी को आगे आना होगा।';
  }

  @override
  String yInjuryBlow4(String name) {
    return '$name बाहर। बेशक यह $name ही होना था।';
  }

  @override
  String yInjuryBlow5(String name) {
    return '$name के बिना यह एक बेहद साधारण टीम बन जाती है।';
  }

  @override
  String yInjuryBlow6(String name) {
    return '$name फिर चोटिल। किसी को तो पूछना चाहिए कि क्यों।';
  }

  @override
  String yInjuryBlow7(String name) {
    return '$name चला गया, और उसके पीछे कोई नहीं। असली समस्या यही है।';
  }

  @override
  String ySentOff0(String name, String minute) {
    return '$name को $minute मिनट पर रेड और पूरा देश उसके पीछे पड़ गया। उसने हमें ज़्यादातर से ज़्यादा दिया है। छोड़ो इसे।';
  }

  @override
  String ySentOff1(String name, String minute) {
    return '$name $minute मिनट बाद बाहर। सख़्त फ़ैसला। दस खिलाड़ियों से भी हमने लड़ाई लड़ी, इससे बहुत कुछ पता चलता है।';
  }

  @override
  String ySentOff2(String name, String minute) {
    return '$name, $minute मिनट, रेड कार्ड। यहाँ से दस खिलाड़ी।';
  }

  @override
  String ySentOff3(String name, String minute) {
    return '$name को $minute पर बाहर भेजा गया। एक फ़ैसले पर पलटने वाला यह पहला मैच नहीं।';
  }

  @override
  String ySentOff4(String name, String minute) {
    return 'शानदार। $name $minute मिनट पर बाहर और हम फिर दस खिलाड़ी रह गए।';
  }

  @override
  String ySentOff5(String name, String minute) {
    return '$name $minute मिनट बाद बाहर। यहाँ अनुशासन आख़िर सिखा कौन रहा है?';
  }

  @override
  String ySentOff6(String name, String minute) {
    return '$minute मिनट। $name इतनी देर ही अपना दिमाग़ ठंडा रख पाया। पेशेवर फ़ुटबॉल।';
  }

  @override
  String ySentOff7(String name, String minute) {
    return '$name को $minute मिनट पर रेड, और मुझे मानना है कि यह तरक्की है।';
  }

  @override
  String get yBoardPressure0 =>
      'बोर्ड बहुत शांत हो गया है। यह कभी अच्छा संकेत नहीं होता।';

  @override
  String get yBoardPressure1 => 'सुना है बोर्डरूम में सवाल उठने लगे हैं।';

  @override
  String get yBoardPressure2 => 'ऊपर ज़मीन खिसकती महसूस हो रही है।';

  @override
  String get yBoardPressure3 =>
      'फ़ेडरेशन में कोई समर्थन में कुछ नहीं कह रहा। नतीजा आप ख़ुद निकालिए।';

  @override
  String get yBoardPressure4 =>
      'ऊपर किसी ने हफ़्तों से उसका सार्वजनिक समर्थन नहीं किया।';

  @override
  String get yBoardPressure5 =>
      'फ़ेडरेशन अपने ही मैनेजर के ख़िलाफ़ ब्रीफ़िंग कर रही है। हमेशा की तरह।';

  @override
  String get yBoardPressure6 =>
      'जब बोर्ड चुप हो जाए, तो वह फ़ैसला कर चुका होता है।';

  @override
  String get yBoardPressure7 =>
      'वे इसे तब तक लटकने देंगे जब तक फ़ैसला किसी और के हाथ में न आ जाए।';

  @override
  String get yReplies => 'इसी मैच के बारे में और';

  @override
  String get yPlayerGrievance0 =>
      'पूछा कि मेरी जगह कहाँ है। अब भी जवाब का इंतज़ार है।';

  @override
  String get yPlayerGrievance1 =>
      'ट्रेनिंग में जी-जान लगा रहा हूँ। इससे ज़्यादा मैं कर भी क्या सकता हूँ।';

  @override
  String get yPlayerGrievance2 => 'कुछ सवाल आप सिर्फ़ एक बार ही पूछ सकते हैं।';

  @override
  String get yPlayerGrievance3 => 'मैं यहाँ तक बिब्स उठाने नहीं आया था।';

  @override
  String get playerHonoursTitle => 'उपलब्धियाँ';

  @override
  String get awardGoldenBall => 'गोल्डन बॉल';

  @override
  String get awardGoldenBoot => 'गोल्डन बूट';

  @override
  String get awardGoldenGlove => 'गोल्डन ग्लव';

  @override
  String get awardTeamOfTournament => 'टीम ऑफ़ द टूर्नामेंट';

  @override
  String get awardPlayerOfYear => 'वर्ल्ड प्लेयर ऑफ़ द ईयर';

  @override
  String get awardYoungPlayerOfYear => 'यंग प्लेयर ऑफ़ द ईयर';

  @override
  String get playerClubHistory => 'क्लब इतिहास';

  @override
  String get playerCareerRecord => 'करियर रिकॉर्ड';

  @override
  String get playerInternationalGoals => 'अंतरराष्ट्रीय गोल';

  @override
  String get playerRecentForm => 'हालिया फ़ॉर्म';

  @override
  String get playerMatchHistory => 'मैच इतिहास';

  @override
  String get playerAttributes => 'खूबियाँ';

  @override
  String get playerUnknown => 'अज्ञात';

  @override
  String get playerAttrPace => 'रफ़्तार';

  @override
  String get playerAttrPhysical => 'फ़िज़िकल';

  @override
  String get playerAttrTechnical => 'टेक्निकल';

  @override
  String get playerAttrShooting => 'शूटिंग';

  @override
  String get playerAttrPassing => 'पासिंग';

  @override
  String get playerAttrDribbling => 'ड्रिब्लिंग';

  @override
  String get playerAttrTackling => 'टैकलिंग';

  @override
  String get playerAttrPositioning => 'पोज़िशनिंग';

  @override
  String get playerAttrComposure => 'संयम';

  @override
  String get playerAttrDecisions => 'फ़ैसले';

  @override
  String get playerAttrStamina => 'स्टैमिना';

  @override
  String get playerAttrStrength => 'ताक़त';

  @override
  String get playerStatCaps => 'कैप';

  @override
  String get playerStatGoals => 'गोल';

  @override
  String get playerStatAssists => 'असिस्ट';

  @override
  String get playerStatAvgRating => 'औसत रेटिंग';

  @override
  String get playerStatForm => 'फ़ॉर्म';

  @override
  String get playerStatMotm => 'मैन ऑफ़ द मैच';

  @override
  String get playerStatCleanSheets => 'क्लीन शीट';

  @override
  String get playerStatBestGame => 'सर्वश्रेष्ठ मैच';

  @override
  String get playerStatCards => 'कार्ड';

  @override
  String playerCardsValue(int yellows, int reds) {
    return '${yellows}Y ${reds}R';
  }

  @override
  String get tourSharedYourRun => 'आपका सफ़र';

  @override
  String get tourSharedList => 'सूची';

  @override
  String get tourSharedBracket => 'ब्रैकेट';

  @override
  String get tourSharedVs => 'बनाम';

  @override
  String tourSharedGroupSeed(String seed) {
    return 'ग्रुप $seed';
  }

  @override
  String get tourSharedThisEdition => 'यह संस्करण';

  @override
  String get tourSharedAllTime => 'सर्वकालिक';

  @override
  String get tourSharedUnknown => 'अज्ञात';

  @override
  String get tourSharedActive => 'सक्रिय';

  @override
  String get tourSharedMedalTable => 'मेडल तालिका';

  @override
  String get tourSharedPastWinners => 'पिछले विजेता';

  @override
  String tourSharedHost(String host) {
    return 'मेज़बान: $host';
  }

  @override
  String get tourSharedBeat => 'ने हराया';

  @override
  String get tourSharedPens => ' (पेनल्टी)';

  @override
  String get tourSharedAwardsEmpty =>
      'पुरस्कारों का फ़ैसला टूर्नामेंट पूरा होने पर होगा।';

  @override
  String get tourSharedGoldenBall => 'गोल्डन बॉल';

  @override
  String get tourSharedPlayerOfTournament =>
      'टूर्नामेंट का सर्वश्रेष्ठ खिलाड़ी';

  @override
  String get tourSharedGoldenBoot => 'गोल्डन बूट';

  @override
  String tourSharedGoalsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count गोल',
      one: '$count गोल',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedGoldenGlove => 'गोल्डन ग्लव';

  @override
  String get tourSharedTeamOfTournament => 'टीम ऑफ़ द टूर्नामेंट';

  @override
  String get tourSharedStatsEmpty =>
      'प्रतियोगिता का कुछ इतिहास बनने पर रिकॉर्ड दिखेंगे।';

  @override
  String get tourSharedRecordScorer => 'रिकॉर्ड स्कोरर';

  @override
  String get tourSharedStillActive => 'अब भी सक्रिय';

  @override
  String get tourSharedMostTitles => 'सबसे ज़्यादा ख़िताब';

  @override
  String tourSharedTitlesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ख़िताब',
      one: '$count ख़िताब',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostFinals => 'सबसे ज़्यादा फ़ाइनल';

  @override
  String tourSharedFinalsContested(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count फ़ाइनल खेले',
      one: '$count फ़ाइनल खेला',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostGamesPlayed => 'सबसे ज़्यादा मैच खेले';

  @override
  String tourSharedMatchesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count मैच',
      one: '$count मैच',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostFinalsPlayed =>
      'सबसे ज़्यादा फ़ाइनल टूर्नामेंट खेले';

  @override
  String tourSharedFinalsTournamentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count फ़ाइनल टूर्नामेंट',
      one: '$count फ़ाइनल टूर्नामेंट',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedBiggestFinalWin => 'फ़ाइनल की सबसे बड़ी जीत';

  @override
  String tourStatsGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count गोल',
      one: '1 गोल',
    );
    return '$_temp0';
  }

  @override
  String get tourStatsStillActive => 'अब भी सक्रिय';

  @override
  String tourStatsTitles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ख़िताब',
      one: '1 ख़िताब',
    );
    return '$_temp0';
  }

  @override
  String tourStatsFinalsContested(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count फ़ाइनल खेले',
      one: '1 फ़ाइनल खेला',
    );
    return '$_temp0';
  }

  @override
  String tourStatsMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count मैच',
      one: '1 मैच',
    );
    return '$_temp0';
  }

  @override
  String tourStatsFinalsTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count फ़ाइनल टूर्नामेंट',
      one: '1 फ़ाइनल टूर्नामेंट',
    );
    return '$_temp0';
  }

  @override
  String get tourStatsLeaders => 'सर्वकालिक अग्रणी';

  @override
  String get tourStatsTabGames => 'मैच';

  @override
  String get tourStatsTabCups => 'कप';

  @override
  String get tourStatsTabScorers => 'स्कोरर';

  @override
  String tourSharedFinalWinDetail(String opponent, int year) {
    return 'बनाम $opponent · $year';
  }

  @override
  String get tourHolders => 'मौजूदा चैंपियन';

  @override
  String tourHoldersSince(int year) {
    return '$year में जीता';
  }

  @override
  String get tourSharedAllTimeScorers => 'सर्वकालिक स्कोरर';

  @override
  String get tourSharedSummaryEmpty =>
      'इस संस्करण का ड्रॉ होने पर मेज़बान और उसके स्टेडियम दिखेंगे।';

  @override
  String get tourSharedHostHeading => 'मेज़बान';

  @override
  String get tourSharedHostsHeading => 'मेज़बान';

  @override
  String get tourSharedCoHostsHeading => 'सह-मेज़बान';

  @override
  String get tourSharedVenues => 'स्टेडियम';

  @override
  String get tourSharedMascot => 'शुभंकर';

  @override
  String get tourSharedMatchBall => 'मैच बॉल';

  @override
  String tourSharedVenueSeats(String city, String capacity) {
    return '$city · $capacity सीटें';
  }

  @override
  String get tourSharedCouldNotLoad => 'लोड नहीं हो सका।';

  @override
  String get tourSharedHostTbc => 'मेज़बान की पुष्टि बाक़ी';

  @override
  String get tourSharedFinalsAreHere => 'फ़ाइनल्स आ गए हैं';

  @override
  String tourSharedHostedBy(String hosts) {
    return 'मेज़बान  $hosts';
  }

  @override
  String get tourSharedLetFinalsBegin => 'फ़ाइनल्स शुरू हों';

  @override
  String get tourSharedCompetitions => 'प्रतियोगिताएँ';

  @override
  String get tourSharedWorldRanking => 'विश्व रैंकिंग';

  @override
  String get tourSharedCouldNotLoadTournaments => 'टूर्नामेंट लोड नहीं हो सके।';

  @override
  String get tourSharedPrestigeStage => 'प्रतिष्ठा का मंच';

  @override
  String get tourSharedOverview => 'अवलोकन';

  @override
  String get tourSharedWorldRankingTitle => 'विश्व रैंकिंग';

  @override
  String get tourSharedYourCompetitions => 'आपकी प्रतियोगिताएँ';

  @override
  String get tourSharedOtherContinents => 'अन्य महाद्वीप';

  @override
  String get tourSharedComingSoon => 'टूर्नामेंट जल्द आ रहा है';

  @override
  String get tourSharedSoon => 'जल्द';

  @override
  String get tourSharedNoQualifyingDraw => 'कोई क्वालिफ़ाइंग ड्रॉ नहीं।';

  @override
  String get tourSharedOpenEnvelope => 'लिफ़ाफ़ा खोलें';

  @override
  String tourSharedGroupName(String name) {
    return 'ग्रुप $name';
  }

  @override
  String get tourSharedBall => 'गेंद';

  @override
  String get tourSharedPot => 'पॉट';

  @override
  String get tourSharedAll => 'सभी';

  @override
  String get tourSharedTapDrawTeam => 'अगली टीम निकालने के लिए टैप करें';

  @override
  String get tourSharedTapDrawPot => 'अगला पॉट निकालने के लिए टैप करें';

  @override
  String get tourSharedTapDrawAll => 'पूरा ड्रॉ देखने के लिए टैप करें';

  @override
  String get tourSharedContinue => 'जारी रखें';

  @override
  String get tourSharedPause => 'रोकें';

  @override
  String get tourSharedPlay => 'चलाएँ';

  @override
  String get tourSharedSkip => 'छोड़ें';

  @override
  String tourSharedPotNumber(int number) {
    return 'पॉट $number';
  }

  @override
  String get tourSharedDrawComplete => 'ड्रॉ पूरा';

  @override
  String get tourSharedDrawing => 'ड्रॉ हो रहा है…';

  @override
  String get tourContChampionship => 'चैंपियनशिप';

  @override
  String get tourContTabSummary => 'सारांश';

  @override
  String get tourContTabQualifying => 'क्वालिफ़ाइंग';

  @override
  String get tourContTabFinals => 'फ़ाइनल्स';

  @override
  String get tourContTabBracket => 'ब्रैकेट';

  @override
  String get tourContTabAwards => 'पुरस्कार';

  @override
  String get tourContTabScorers => 'स्कोरर';

  @override
  String get tourContTabHistory => 'इतिहास';

  @override
  String get tourContTabRecords => 'रिकॉर्ड';

  @override
  String tourContCouldNotLoadCup(String error) {
    return 'कप लोड नहीं हो सका।\n$error';
  }

  @override
  String get tourContNoCupData => 'कप का कोई डेटा नहीं।';

  @override
  String get tourContUnknown => 'अज्ञात';

  @override
  String get tourContGroupsToBeDrawnQual =>
      'क्वालिफ़ाइंग ग्रुप समारोह में निकाले जाते हैं। हब से देखिए कि आपका सामना किससे होगा।';

  @override
  String get tourContQualSeeded =>
      'आपकी टीम को सीधे फ़ाइनल्स में सीड मिली है। इस चक्र में क्वालिफ़ाइंग नहीं खेलनी।';

  @override
  String tourContBackgroundRegion(String name) {
    return '$name का सिमुलेशन बैकग्राउंड में चलता है। हर राउंड खेले जाने पर नतीजे यहाँ दिखेंगे।';
  }

  @override
  String get tourContGroupsToBeDrawnFinals =>
      'फ़ाइनल्स के ग्रुप समारोह में निकाले जाते हैं। हब से देखिए कि आपका ग्रुप कौन सा है।';

  @override
  String get tourContFinalsDrawAfterQual =>
      'फ़ाइनल्स का ड्रॉ क्वालिफ़ाइंग पूरी होने के बाद होगा।';

  @override
  String get tourContContestedBeforeWc =>
      'नॉकआउट राउंड विश्व चैंपियनशिप से पहले खेले जाते हैं।';

  @override
  String tourContChampionsHeading(String name) {
    return '$name चैंपियन';
  }

  @override
  String tourContWinnersTitle(String name) {
    return '$name के विजेता';
  }

  @override
  String get tourContNoGoalsYet => 'अभी तक कोई गोल नहीं हुआ।';

  @override
  String tourContGroupHeading(String name) {
    return 'ग्रुप $name';
  }

  @override
  String get tourContBestRunnersUp => 'सर्वश्रेष्ठ उपविजेता';

  @override
  String tourContGroupDropdown(String name) {
    return 'ग्रुप $name';
  }

  @override
  String get tourContMatches => 'मैच';

  @override
  String get tourContNoGroupsDrawn => 'अभी तक कोई ग्रुप नहीं निकला।';

  @override
  String get tourContQualifyingDraw => 'क्वालिफ़ाइंग ड्रॉ';

  @override
  String get tourContWorldQualifyingDraw => 'विश्व क्वालिफ़ाइंग ड्रॉ';

  @override
  String get tourContFinalsDraw => 'फ़ाइनल्स ड्रॉ';

  @override
  String get tourContSeedingPots => 'सीडिंग पॉट';

  @override
  String get tourContGroupDraw => 'ग्रुप ड्रॉ';

  @override
  String tourContCouldNotLoadDraw(String error) {
    return 'ड्रॉ लोड नहीं हो सका।\n$error';
  }

  @override
  String get tourContDrawNotReady => 'ड्रॉ अभी तैयार नहीं है।';

  @override
  String get tourContContinentalClash => 'कॉन्टिनेंटल क्लैश';

  @override
  String get tourContTabThisCycle => 'यह चक्र';

  @override
  String tourContCouldNotLoadClash(String error) {
    return 'लोड नहीं हो सका।\n$error';
  }

  @override
  String get tourContNoSaveFound => 'सेव नहीं मिला।';

  @override
  String get tourContClashSoon =>
      'कॉन्टिनेंटल क्लैश तब खेला जाता है जब दोनों महाद्वीपीय चैंपियन तय हो जाते हैं।';

  @override
  String get tourContTwoContinentsOneMatch => 'दो महाद्वीप, एक मैच';

  @override
  String get tourContVersusShort => 'बनाम';

  @override
  String tourContWinTheClash(String name) {
    return '$name ने क्लैश जीता';
  }

  @override
  String get tourContNoClashYet =>
      'अभी तक कोई कॉन्टिनेंटल क्लैश नहीं खेला गया।';

  @override
  String get tourContNationsCup => 'नेशंस कप';

  @override
  String get tourContTabLeagues => 'लीग';

  @override
  String get tourContTabFinalsFour => 'फ़ाइनल्स फ़ोर';

  @override
  String tourContCouldNotLoad(String error) {
    return 'लोड नहीं हो सका।\n$error';
  }

  @override
  String get tourContNoNationsCupGoals =>
      'नेशंस कप में अभी तक कोई गोल दर्ज नहीं हुआ है।';

  @override
  String get tourContNoNationsCupChampions =>
      'नेशंस कप का अभी तक कोई चैंपियन नहीं बना है।';

  @override
  String get tourContNationsCupOffSeason =>
      'इस चक्र का नेशंस कप महाद्वीपीय फ़ाइनल्स के बाद शुरू होगा। पिछले विजेता इतिहास में देखें।';

  @override
  String get tourContNationsCupGroupsSoon =>
      'इस चक्र के नेशंस कप के ग्रुप समारोह में तय होंगे। किसका सामना होगा, यह जानने के लिए हब से ड्रॉ देखें।';

  @override
  String get tourContLeagueNoGroups =>
      'इस राउंड में इस लीग में कोई मैच नहीं है।';

  @override
  String tourContLeagueHeading(String letter) {
    return 'लीग $letter';
  }

  @override
  String tourContLeagueHeadingYours(String letter) {
    return 'लीग $letter · आपकी लीग';
  }

  @override
  String get tourContFinalsFourSoon =>
      'ग्रुप चरण पूरा होने के बाद लीग A के ग्रुप विजेता फ़ाइनल्स फ़ोर खेलेंगे।';

  @override
  String tourContLeagueChip(String letter) {
    return 'लीग $letter';
  }

  @override
  String tourContLeagueChipStar(String letter) {
    return 'लीग $letter ★';
  }

  @override
  String get tourContSemiFinals => 'सेमीफ़ाइनल';

  @override
  String get tourContFinal => 'फ़ाइनल';

  @override
  String get tourContNationsCupDraw => 'नेशंस कप ड्रॉ';

  @override
  String get tourContIntercontinentalPlayoff => 'अंतर-महाद्वीपीय प्ले-ऑफ़';

  @override
  String get tourContNoPlayoffThisCycle => 'इस चक्र में कोई प्ले-ऑफ़ नहीं है।';

  @override
  String get tourContPlayoffIntro =>
      'क्वालिफ़ाइंग में चूकी सबसे अच्छी टीमों के नॉकआउट से विश्व चैंपियनशिप की दो जगहें तय होती हैं।';

  @override
  String get tourContPlayoffThrough =>
      'आप प्ले-ऑफ़ पार कर गए। आप विश्व चैंपियनशिप में हैं!';

  @override
  String get tourContPlayoffOut =>
      'आप प्ले-ऑफ़ में चूक गए। इस बार विश्व चैंपियनशिप नहीं।';

  @override
  String get tourContContinue => 'जारी रखें';

  @override
  String get tourContPlayoffFinals => 'प्ले-ऑफ़ फ़ाइनल';

  @override
  String get tourContPlayoffSeeded => 'सीडेड (बाई)';

  @override
  String get tourCupTabSummary => 'सारांश';

  @override
  String get tourCupTabQualifying => 'क्वालिफ़ाइंग';

  @override
  String get tourCupTabPlayoff => 'प्ले-ऑफ़';

  @override
  String get tourCupPlayoffSoon =>
      'सभी कॉन्फ़ेडरेशनों का क्वालिफ़ाइंग पूरा होने के बाद अंतर-महाद्वीपीय प्ले-ऑफ़ तय होगा।';

  @override
  String get tourCupTabFinals => 'फ़ाइनल्स';

  @override
  String get tourCupTabBracket => 'ब्रैकेट';

  @override
  String get tourCupTabAwards => 'पुरस्कार';

  @override
  String get tourCupTabScorers => 'स्कोरर';

  @override
  String get tourCupTabHistory => 'इतिहास';

  @override
  String get tourCupTabRecords => 'रिकॉर्ड';

  @override
  String get tourCupTitle => 'विश्व चैंपियनशिप';

  @override
  String get tourCupNoData => 'कप का कोई डेटा नहीं।';

  @override
  String tourCupLoadError(String error) {
    return 'कप लोड नहीं हो सका।\n$error';
  }

  @override
  String get tourCupUnknown => 'अज्ञात';

  @override
  String get tourCupWorldChampions => 'विश्व चैंपियन';

  @override
  String get tourCupWorldChampionsTitle => 'विश्व चैंपियन';

  @override
  String get tourCupStillActive => 'अब भी सक्रिय';

  @override
  String get tourCupAllTimeScorers => 'सर्वकालिक स्कोरर';

  @override
  String get tourCupAllConfederations => 'सभी कॉन्फ़ेडरेशन';

  @override
  String get tourCupBestRunnersUp => 'सर्वश्रेष्ठ उपविजेता';

  @override
  String get tourCupCompWorld => 'विश्व चैंपियनशिप';

  @override
  String get tourCupCompEurope => 'यूरोपीय चैंपियनशिप';

  @override
  String get tourCupCompSAmerica => 'दक्षिण अमेरिका कप';

  @override
  String get tourCupDestRoundOf16 => 'राउंड ऑफ़ 16';

  @override
  String get tourCupDestKnockouts => 'नॉकआउट';

  @override
  String get tourCupDestFinals => 'फ़ाइनल्स';

  @override
  String get tourCupDestFinalsPlayoff => 'फ़ाइनल्स प्ले-ऑफ़';

  @override
  String get tourCupDestIntercontPlayoff => 'अंतर-महाद्वीपीय प्ले-ऑफ़';

  @override
  String get tourCupFinalsDrawnAfterQual =>
      'क्वालिफ़ाइंग ख़त्म होने के बाद फ़ाइनल्स का ड्रॉ होगा।';

  @override
  String get tourCupFinalsDrawSoon =>
      'ग्रुप का ड्रॉ होना बाक़ी है। उन्हें जानने के लिए हब से विश्व चैंपियनशिप ड्रॉ देखें।';

  @override
  String tourCupGroupName(String name) {
    return 'ग्रुप $name';
  }

  @override
  String tourCupGroupNameShort(String name) {
    return 'ग्रुप $name';
  }

  @override
  String tourCupHostLabel(String host) {
    return 'मेज़बान: $host';
  }

  @override
  String tourCupHostLabelMulti(String hosts) {
    return 'मेज़बान: $hosts';
  }

  @override
  String get tourCupIntercontPlayoff => 'अंतर-महाद्वीपीय प्ले-ऑफ़';

  @override
  String get tourCupKnockoutSoon =>
      'ग्रुप चरण ख़त्म होने के बाद ब्रैकेट शुरू होगा।';

  @override
  String get tourCupMatches => 'मैच';

  @override
  String get tourCupMedalTable => 'पदक तालिका';

  @override
  String get tourCupMostTitles => 'सबसे ज़्यादा ख़िताब';

  @override
  String tourCupMostTitlesValue(String nation, int titles, int editions) {
    return '$nation: $editions संस्करणों में $titles ख़िताब';
  }

  @override
  String get tourCupNoGoals => 'अभी तक कोई गोल नहीं।';

  @override
  String get tourCupNoGroups => 'कोई ग्रुप ड्रॉ नहीं हुआ।';

  @override
  String get tourCupNoHistory => 'अभी कोई इतिहास नहीं।';

  @override
  String get tourCupPastWinners => 'पिछले विजेता';

  @override
  String get tourCupPlayoffIntro =>
      'क्वालिफ़ाइंग में चूकी सबसे अच्छी टीमों के नॉकआउट से विश्व चैंपियनशिप की दो जगहें तय होती हैं।';

  @override
  String tourCupPlayoffNoEntrants(String confederation) {
    return '$confederation में प्ले-ऑफ़ नहीं होता: उसकी सभी जगहें क्वालिफ़ाइंग ग्रुप में तय होती हैं।';
  }

  @override
  String get tourCupQualDrawSoon =>
      'ग्रुप का ड्रॉ होना बाक़ी है। उन्हें जानने के लिए हब से क्वालिफ़ाइंग ड्रॉ देखें।';

  @override
  String tourCupRegionYours(String region) {
    return '$region · आपका';
  }

  @override
  String tourCupScorePens(int home, int away) {
    return '$home–$away (पेनल्टी)';
  }

  @override
  String get tourCupSegAllTime => 'सर्वकालिक';

  @override
  String get tourCupSegFinals => 'फ़ाइनल्स';

  @override
  String get tourCupSegQualifying => 'क्वालिफ़ाइंग';

  @override
  String get playerTraitsTitle => 'किसके लिए मशहूर';

  @override
  String get traitBigGame => 'बड़े मैच का खिलाड़ी';

  @override
  String get traitBigGameBlurb => 'नॉकआउट मुकाबलों में अपना खेल ऊपर उठाता है।';

  @override
  String get traitSetPiece => 'सेट-पीस विशेषज्ञ';

  @override
  String get traitSetPieceBlurb => 'बेहतर डिलीवरी और डेड बॉल से ज़्यादा गोल।';

  @override
  String get traitHothead => 'गरम मिज़ाज';

  @override
  String get traitHotheadBlurb =>
      'साथी खिलाड़ियों से कहीं ज़्यादा कार्ड देखता है।';

  @override
  String get traitIronMan => 'आयरन मैन';

  @override
  String get traitIronManBlurb =>
      'शायद ही कभी चोटिल होता है और देर से थकता है।';

  @override
  String get traitWonderkid => 'वंडरकिड';

  @override
  String get traitWonderkidBlurb =>
      'युवा, पहले से अच्छा और तेज़ी से निखरता हुआ।';

  @override
  String get traitLeader => 'लीडर';

  @override
  String get traitLeaderBlurb => 'मैदान पर हर साथी का हौसला बढ़ाता है।';

  @override
  String get traitPacey => 'तेज़ रफ़्तार';

  @override
  String get traitPaceyBlurb => 'जबरदस्त रफ़्तार, डिफ़ेंस के पीछे हमेशा ख़तरा।';

  @override
  String get traitOldHead => 'अनुभवी खिलाड़ी';

  @override
  String get traitOldHeadBlurb =>
      'ऐसा अनुभवी खिलाड़ी जिसकी खेल की समझ उसके पैरों से ज़्यादा टिकती है।';

  @override
  String get traitWasteful => 'मौक़े गँवाने वाला';

  @override
  String get traitWastefulBlurb => 'कई अच्छे मौक़े बाहर मार देता है।';

  @override
  String get objectiveWorldCup => 'विश्व चैंपियनशिप';

  @override
  String get objectiveWinTournament => 'ख़िताब जीतें';

  @override
  String get objectiveQualifyGeneric => 'क्वालिफ़ाई करें';

  @override
  String hubBoardObjectiveFor(String competition, String label) {
    return '$competition: $label';
  }

  @override
  String get objectiveWinWorldCup => 'विश्व चैंपियनशिप जीतें';

  @override
  String get objectiveReachFinal => 'फ़ाइनल में पहुँचें';

  @override
  String get objectiveReachSemis => 'सेमीफ़ाइनल में पहुँचें';

  @override
  String get objectiveReachQuarters => 'क्वार्टरफ़ाइनल में पहुँचें';

  @override
  String get objectiveReachKnockouts => 'नॉकआउट राउंड में पहुँचें';

  @override
  String get objectiveQualify => 'विश्व चैंपियनशिप के लिए क्वालिफ़ाई करें';

  @override
  String get finishChampions => 'चैंपियन';

  @override
  String get finishRunnersUp => 'उपविजेता';

  @override
  String get finishSemiFinals => 'सेमीफ़ाइनल';

  @override
  String get finishQuarterFinals => 'क्वार्टरफ़ाइनल';

  @override
  String get finishRoundOf16 => 'राउंड ऑफ़ 16';

  @override
  String get finishGroupStage => 'ग्रुप चरण';

  @override
  String get objectiveQualifyingTopHalf => 'क्वालिफ़ाइंग में ऊपरी आधे में रहें';

  @override
  String get finishQualifyingTopHalf => 'क्वालिफ़ाइंग ग्रुप का ऊपरी आधा';

  @override
  String get finishQualifyingBottomHalf => 'क्वालिफ़ाइंग ग्रुप का निचला आधा';

  @override
  String get objectiveNcWinIt => 'नेशंस कप जीतें';

  @override
  String get objectiveNcReachFinal => 'नेशंस कप फ़ाइनल में पहुँचें';

  @override
  String get objectiveNcFinalsFour => 'फ़ाइनल्स फ़ोर में पहुँचें';

  @override
  String get objectiveNcWinGroup => 'अपना ग्रुप जीतें और प्रमोशन पाएँ';

  @override
  String get objectiveNcTopHalf => 'अपने ग्रुप में ऊपरी आधे में रहें';

  @override
  String get objectiveNcSurvive => 'रेलिगेशन से बचें';

  @override
  String get objectiveNcOffTheBottom => 'ग्रुप में सबसे नीचे न रहें';

  @override
  String get finishNcChampions => 'नेशंस कप विजेता';

  @override
  String get finishNcFinalsFour => 'फ़ाइनल्स फ़ोर';

  @override
  String get finishNcGroupWinners => 'ग्रुप विजेता';

  @override
  String get finishNcTopHalf => 'ग्रुप का ऊपरी आधा';

  @override
  String get finishNcStayedUp => 'रेलिगेशन से बचे';

  @override
  String get finishNcClearOfBottom => 'ग्रुप में सबसे नीचे नहीं';

  @override
  String get finishNcBottom => 'ग्रुप में सबसे नीचे';

  @override
  String get careerNationsCupLabel => 'नेशंस कप';

  @override
  String get squadDevPlayer => 'खिलाड़ी';

  @override
  String get squadDevAge => 'उम्र';

  @override
  String get squadDevPosition => 'POS';

  @override
  String get squadDevChange => 'रेटिंग';

  @override
  String get squadDevNew => 'नया';

  @override
  String get squadDevRetired => 'संन्यास';

  @override
  String get squadDevEmpty => 'शांत साल। स्क्वॉड में कोई बदलाव नहीं।';

  @override
  String get squadDevTierRegulars => 'नियमित';

  @override
  String get squadDevTierFringe => 'फ़्रिंज';

  @override
  String get squadDevTierYouth => 'युवा';

  @override
  String get boardObjectivesTitle => 'बोर्ड के लक्ष्य';

  @override
  String get boardObjectivesConfidence => 'बोर्ड का भरोसा';

  @override
  String boardObjectiveBeatenBy(String result, int rounds) {
    String _temp0 = intl.Intl.pluralLogic(
      rounds,
      locale: localeName,
      other: 'अपेक्षा से $rounds राउंड बेहतर',
      one: 'अपेक्षा से एक राउंड बेहतर',
    );
    return '$result: $_temp0';
  }

  @override
  String boardObjectiveShortBy(String result, int rounds) {
    String _temp0 = intl.Intl.pluralLogic(
      rounds,
      locale: localeName,
      other: '$rounds राउंड कम',
      one: 'एक राउंड कम',
    );
    return '$result: $_temp0';
  }

  @override
  String get boardObjectivesPending => 'फ़ैसला बाक़ी';

  @override
  String boardObjectiveSoFar(String result) {
    return 'अब तक · $result';
  }

  @override
  String get boardObjectivesEmpty =>
      'बोर्ड ने इस चक्र के लिए कोई लक्ष्य तय नहीं किया है।';

  @override
  String get tourContBestWinners => 'सर्वश्रेष्ठ ग्रुप विजेता';

  @override
  String get tourContBestThirds => 'सर्वश्रेष्ठ तीसरे स्थान की टीमें';

  @override
  String tourContBestPlaced(String position) {
    return 'सर्वश्रेष्ठ नंबर $position टीमें';
  }

  @override
  String squadDevPageOf(String page, String pages, String total) {
    return '$page/$pages · $total खिलाड़ी';
  }

  @override
  String get matchSoldOut => 'हाउसफ़ुल';

  @override
  String matchAttendanceOf(String attendance, String capacity) {
    return '$capacity में से $attendance सीटें भरीं';
  }

  @override
  String get matchGroundTitle => 'स्टेडियम';

  @override
  String get absenceInjured => 'चोटिल';

  @override
  String get absenceSuspended => 'निलंबित';

  @override
  String absenceWeeks(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString सप्ताह',
      one: '1 सप्ताह',
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
      other: '$countString मैच',
      one: '1 मैच',
    );
    return '$_temp0';
  }

  @override
  String absenceBackFor(String opponent) {
    return '$opponent के मैच में वापसी';
  }

  @override
  String get penaltyOrderTitle => 'पेनल्टी';

  @override
  String get penaltyOrderBlurb =>
      'अपने पाँच टेकर क्रम से चुनें। बदलने के लिए किसी स्लॉट को टैप करें।';

  @override
  String penaltyOrderPick(int number) {
    return 'किक $number';
  }

  @override
  String get penaltyOrderPickBlurb =>
      'चुनें कि कौन आगे आएगा। बार पेनल्टी स्पॉट पर उसके संयम को दिखाता है।';

  @override
  String get penaltyOrderConfirm => 'किक शुरू करें';

  @override
  String get penaltyOrderCancel => 'वापस';

  @override
  String get youthTitle => 'युवा';

  @override
  String get youthEmptyLevel => 'इस स्तर पर अभी कोई नहीं है।';

  @override
  String get youthReleased => 'इस साल रिलीज़ किए गए';

  @override
  String get u21Title => 'अंडर-21';

  @override
  String get u21Blurb =>
      'अगली पीढ़ी, सबसे होनहार पहले। ख़ाली सितारे स्काउट का अनुमान हैं। असली क्षमता जानने के लिए खिलाड़ी को कैप दें।';

  @override
  String get u21Empty =>
      'पूल में अभी अंडर-21 में कोई नहीं है। अगला बैच नए चक्र के साथ आएगा।';

  @override
  String u21Breakout(int gain) {
    return 'इस साल +$gain';
  }

  @override
  String u21AgeCaps(int age, int caps) {
    return 'उम्र $age · $caps कैप';
  }

  @override
  String u21AgeUncapped(int age) {
    return 'उम्र $age · बिना कैप';
  }

  @override
  String get u21CallUps => 'कॉल-अप पर जाएँ';

  @override
  String get youthWatching => 'निगरानी में';

  @override
  String get youthWatchEmpty =>
      'अभी किसी को मार्क नहीं किया। किसी भी स्तर पर किसी लड़के को मार्क करें, वह यहाँ दिखेगा, साथ में यह भी कि वह अब क्या बन चुका है।';

  @override
  String get youthWatchMark => 'इस लड़के को फ़ॉलो करें';

  @override
  String get youthWatchUnmark => 'फ़ॉलो करना बंद करें';

  @override
  String youthWatchMarked(int rating, int age) {
    return '$rating रेटिंग और $age साल की उम्र में मार्क किया';
  }

  @override
  String get youthWatchSenior => 'सीनियर पूल तक पहुँचा';

  @override
  String get youthWatchReleased => 'अकादमी ने रिलीज़ किया';

  @override
  String get youthWatchGone => 'अब पिरामिड में नहीं';

  @override
  String get tacticsYouth => 'अंडर-21';

  @override
  String get pressSquad => 'स्क्वॉड';

  @override
  String get pressBoard => 'बोर्ड';

  @override
  String get pressNoEffect => 'इसे कोई ख़ास तवज्जो नहीं देगा';

  @override
  String get matchNeutralGround => 'न्यूट्रल';

  @override
  String get matchExtraTimeAhead => 'एक्स्ट्रा टाइम';

  @override
  String get matchExtraTimeHalf => 'एक्स्ट्रा टाइम · हाफ़ टाइम';

  @override
  String get matchClockFullTime => 'फ़ुल टाइम';

  @override
  String get matchClockAfterExtraTime => 'एक्स्ट्रा टाइम के बाद';

  @override
  String get matchClockPenalties => 'पेनल्टी';

  @override
  String get matchClockFullTimePenalties => 'फ़ुल टाइम · पेनल्टी';

  @override
  String get hubEventPressConference => 'प्रेस का सामना करें';

  @override
  String get hubEventPressConferenceSub =>
      'पहले मैच से पहले दुनिया भर का मीडिया आपसे बात करना चाहता है';

  @override
  String get squadDevWonderkid => 'वंडरकिड';

  @override
  String get tacticsPlaystyle => 'खेलने का अंदाज़';

  @override
  String get tacticsPlaystyleBlurb =>
      'चुनें कि टीम कैसे खेले; नीचे के डायल इसे और बारीकी से ठीक करते हैं।';

  @override
  String get tacticsPlaystyleCustom =>
      'आपकी अपनी सेटिंग। इन डायल से कोई नामित अंदाज़ मेल नहीं खाता।';

  @override
  String get playstyleCustom => 'कस्टम';

  @override
  String get playstyleBalanced => 'संतुलित';

  @override
  String get playstylePossession => 'पज़ेशन';

  @override
  String get playstyleGegenpress => 'गेगेनप्रेस';

  @override
  String get playstyleCounter => 'काउंटर-अटैक';

  @override
  String get playstyleDirect => 'डायरेक्ट';

  @override
  String get playstyleLowBlock => 'लो ब्लॉक';

  @override
  String get playstyleWingPlay => 'विंग प्ले';

  @override
  String get playstyleBalancedBlurb =>
      'दोनों हाफ़ में मज़बूत, कुछ भी ज़रूरत से ज़्यादा नहीं।';

  @override
  String get playstylePossessionBlurb =>
      'गेंद अपने पास रखें, धैर्य से आगे बढ़ाएँ और मैदान को सिकोड़ दें।';

  @override
  String get playstyleGegenpressBlurb =>
      'गेंद खोते ही तुरंत ऊँचाई पर उसे वापस छीनें।';

  @override
  String get playstyleCounterBlurb =>
      'पीछे डटे रहें, कॉम्पैक्ट रहें, फिर तेज़ी से हमला करें।';

  @override
  String get playstyleDirectBlurb =>
      'गेंद जल्दी आगे भेजें और सेकंड बॉल पर खेलें।';

  @override
  String get playstyleLowBlockBlurb =>
      'गहरी, संकरी और तोड़ने में बेहद मुश्किल।';

  @override
  String get playstyleWingPlayBlurb =>
      'मैदान को चौड़ा करें, बाहर से निकलें और क्रॉस दें।';

  @override
  String get nationsRandomTeam => 'रैंडम टीम';

  @override
  String get nationsFromTheBottom => 'सबसे नीचे से';

  @override
  String get bottomStartTitle => 'बेरोज़गार';

  @override
  String get bottomStartHeading => 'तीन फ़ेडरेशन आपसे बात करना चाहते हैं';

  @override
  String get bottomStartBlurb =>
      'आपके पास न नौकरी है, न साख। सिर्फ़ यही टीमें आप पर दाँव लगाने को तैयार हैं। एक चुनें और शून्य से कुछ बनाएँ।';

  @override
  String get bottomStartAccept => 'स्वीकार करें';

  @override
  String get bottomStartBack => 'मेन्यू पर लौटें';

  @override
  String bottomStartRankOf(int rank, int total) {
    return 'विश्व रैंकिंग में $rank (कुल $total)';
  }

  @override
  String get campTitle => 'बेस कैंप';

  @override
  String campBasedIn(String host) {
    return '$host में ठिकाना';
  }

  @override
  String get campBlurb =>
      'जहाँ स्क्वॉड पूरे टूर्नामेंट के दौरान रहता है। खेल शुरू होने के बाद इसे बदला नहीं जा सकता, और यह हर मैच में तीन चीज़ों पर असर डालता है: खिलाड़ी कितने तरोताज़ा पहुँचते हैं, चोट कितनी जल्दी भरती है और वे कितने चुस्त हैं।';

  @override
  String get campEffectTravel => 'तरोताज़ा पहुँचें';

  @override
  String get campEffectRecovery => 'चोटें जल्दी भरें';

  @override
  String get campEffectSharpness => 'मैच की चुस्ती';

  @override
  String get campTerrainCity => 'शहर का केंद्र';

  @override
  String get campTerrainCoastal => 'समुद्र तटीय रिज़ॉर्ट';

  @override
  String get campTerrainMountain => 'पहाड़ी ठिकाना';

  @override
  String get campTerrainAltitude => 'ऊँचाई वाला कैंप';

  @override
  String get campTerrainNationalCentre => 'नेशनल सेंटर';

  @override
  String get campTerrainCityBlurb =>
      'सब कुछ पास में और कहीं जाने की ज़रूरत नहीं, पर न शांति मिलती है, न शोर से छुटकारा।';

  @override
  String get campTerrainCoastalBlurb =>
      'शांत, आरामदेह और मूड के लिए अच्छा; हर मैदान तक बस का लंबा सफ़र।';

  @override
  String get campTerrainMountainBlurb =>
      'ठंडी हवा और बेहतरीन मेडिकल इंतज़ाम जो चोटें जल्दी ठीक करते हैं, पर टूर्नामेंट से बहुत दूर।';

  @override
  String get campTerrainAltitudeBlurb =>
      'यहाँ ट्रेनिंग करना कठिन है, पर टूर्नामेंट के आख़िरी दौर तक पैरों में दम बना रहता है।';

  @override
  String get campTerrainNationalCentreBlurb =>
      'फ़ेडरेशन की अपनी सुविधाएँ: कुछ ख़ास नहीं, पर गड़बड़ी की गुंजाइश भी नहीं।';

  @override
  String get hubEventChooseCamp => 'बेस कैंप चुनें';

  @override
  String hubEventChooseCampSub(String host) {
    return '$host में स्क्वॉड कहाँ ठहरेगा';
  }

  @override
  String get tacticsTabBench => 'बेंच';

  @override
  String get squadSearchHint => 'नाम या क्लब से खोजें';

  @override
  String get squadFilterAll => 'सभी';

  @override
  String get squadFilterInSquad => 'स्क्वॉड में';

  @override
  String get squadFilterUncapped => 'बिना कैप';

  @override
  String get squadFilterUnavailable => 'अनुपलब्ध';

  @override
  String get squadLineAll => 'सभी लाइन';

  @override
  String get squadSortBy => 'क्रम';

  @override
  String get squadSortRating => 'रेटिंग';

  @override
  String get squadSortCaps => 'कैप';

  @override
  String get squadSortGoals => 'गोल';

  @override
  String get squadSortAge => 'उम्र';

  @override
  String get squadSortName => 'नाम';

  @override
  String get squadLegendTitle => 'निशानों का मतलब';

  @override
  String get squadLegendStarting => 'आपके शुरुआती ग्यारह में';

  @override
  String get squadLegendCalledUp => 'कॉल-अप, बेंच पर';

  @override
  String get squadLegendRatingUp => 'इस साल रेटिंग बढ़ रही है';

  @override
  String get squadLegendRatingDown => 'इस साल रेटिंग गिर रही है';

  @override
  String get squadLegendInjured => 'चोटिल, अनुपलब्ध';

  @override
  String get squadLegendSuspended => 'निलंबित, अनुपलब्ध';

  @override
  String get squadLegendTraits => 'किसके लिए मशहूर';

  @override
  String squadShowingOf(int shown, int total) {
    return '$total में से $shown खिलाड़ी दिख रहे हैं';
  }

  @override
  String get squadNobodyMatches =>
      'पूल में कोई खिलाड़ी इन फ़िल्टर से मेल नहीं खाता।';

  @override
  String get squadStatPool => 'पूल';

  @override
  String get squadStatInSquad => 'कॉल-अप';

  @override
  String get squadMostCapped => 'सबसे ज़्यादा कैप';

  @override
  String get squadTopScorer => 'टॉप स्कोरर';

  @override
  String squadCapsValue(String name, int caps) {
    return '$name · $caps कैप';
  }

  @override
  String squadGoalsValue(String name, int goals) {
    return '$name · $goals गोल';
  }

  @override
  String squadAgeClub(int age, String club) {
    return '$age · $club';
  }

  @override
  String get squadCapsShort => 'कैप';

  @override
  String get squadGoalsShort => 'गोल';

  @override
  String get recordsRecordBookSubtitle => 'कैप, गोल और टीम के प्रमुख रिकॉर्ड';

  @override
  String get statsLegacy => 'विरासत';

  @override
  String tacticsSubAlreadyOff(String name) {
    return '$name को पहले ही बाहर बुलाया जा चुका है और वह वापस नहीं आ सकता।';
  }

  @override
  String tacticsSubSentOff(String name) {
    return '$name को रेड कार्ड मिल चुका है और वह आगे नहीं खेल सकता।';
  }

  @override
  String get tacticsInjuredShort => 'चोटिल';

  @override
  String get tacticsSuspendedShort => 'निलंबित';

  @override
  String get confEurope => 'यूरोप';

  @override
  String get confSouthAmerica => 'दक्षिण अमेरिका';

  @override
  String get confNorthAmerica => 'उत्तर अमेरिका';

  @override
  String get confAfrica => 'अफ़्रीका';

  @override
  String get confAsia => 'एशिया';

  @override
  String get confOceania => 'ओशिनिया';

  @override
  String get compWorldCup => 'विश्व चैंपियनशिप';

  @override
  String get compWorldCupFinals => 'विश्व चैंपियनशिप फ़ाइनल्स';

  @override
  String get compWorldCupQualifying => 'विश्व चैंपियनशिप क्वालिफ़ाइंग';

  @override
  String compQualifiers(String region) {
    return '$region क्वालिफ़ायर';
  }

  @override
  String get compFriendlies => 'दोस्ताना मैच';

  @override
  String get compNationsCup => 'नेशंस कप';

  @override
  String get compContinentalClash => 'कॉन्टिनेंटल क्लैश';

  @override
  String get compIntercontinentalPlayoff => 'अंतर-महाद्वीपीय प्ले-ऑफ़';

  @override
  String get compContinentalChampionship => 'महाद्वीपीय चैंपियनशिप';

  @override
  String get compEuropeanChampionship => 'यूरोपीय चैंपियनशिप';

  @override
  String get compSouthAmericaCup => 'दक्षिण अमेरिका कप';

  @override
  String get compAfricanChampionship => 'अफ़्रीकी चैंपियनशिप';

  @override
  String get compAsianChampionship => 'एशियाई चैंपियनशिप';

  @override
  String get compNorthAmericaCup => 'उत्तर अमेरिका कप';

  @override
  String get compOceaniaCup => 'ओशिनिया कप';

  @override
  String get msgANation => 'एक देश';

  @override
  String get msgAPlayer => 'एक खिलाड़ी';

  @override
  String get msgAHostNation => 'एक मेज़बान देश';

  @override
  String get msgCycleTitle1 => 'नया चक्र शुरू';

  @override
  String msgCycleTitle2(int year) {
    return '$year की राह खुली';
  }

  @override
  String get msgCycleTitle3 => 'नया अभियान शुरू';

  @override
  String get msgCycleTitle4 => 'काम पर वापसी';

  @override
  String msgCycleBody1(int year) {
    return '$year विश्व चैंपियनशिप की राह यहीं से शुरू होती है।';
  }

  @override
  String msgCycleBody2(int year) {
    return 'नया चक्र। लक्ष्य है $year विश्व चैंपियनशिप।';
  }

  @override
  String msgCycleBody3(int year) {
    return '$year विश्व चैंपियनशिप में चार साल बाक़ी हैं। काम अभी से शुरू।';
  }

  @override
  String msgCycleBody4(int year) {
    return '$year का अभियान आज से शुरू होता है।';
  }

  @override
  String msgContHostTitle(String cup, String host) {
    return '$cup मेज़बान: $host';
  }

  @override
  String msgContHostBody(String host, String cup) {
    return 'अगला $cup $host में होगा।';
  }

  @override
  String msgContQualDrawTitle(String cup) {
    return '$cup क्वालिफ़ाइंग ड्रॉ';
  }

  @override
  String msgContQualDrawBody(String cup) {
    return '$cup क्वालिफ़ाइंग के ग्रुप तय हो गए हैं।';
  }

  @override
  String msgWcHostTitle(String host, int year) {
    return '$year विश्व चैंपियनशिप मेज़बान: $host';
  }

  @override
  String msgWcHostBody(String host, int year) {
    return '$year विश्व चैंपियनशिप की मेज़बानी $host करेगा।';
  }

  @override
  String get msgWcQualDrawTitle => 'विश्व चैंपियनशिप क्वालिफ़ाइंग ड्रॉ';

  @override
  String get msgWcQualDrawBody =>
      'विश्व चैंपियनशिप क्वालिफ़ाइंग के ग्रुप तय हो गए हैं।';

  @override
  String msgContFinalsDrawTitle(String cup) {
    return '$cup फ़ाइनल्स ड्रॉ';
  }

  @override
  String msgContFinalsDrawBody(String cup) {
    return '$cup फ़ाइनल्स के ग्रुप तय हो गए हैं।';
  }

  @override
  String get msgWcFinalsDrawTitle => 'विश्व चैंपियनशिप फ़ाइनल्स ड्रॉ';

  @override
  String msgWcFinalsDrawBody(int year) {
    return '$year विश्व चैंपियनशिप फ़ाइनल्स का ड्रॉ हो गया है।';
  }

  @override
  String get msgQualWcTitle1 => 'विश्व चैंपियनशिप के लिए क्वालिफ़ाई';

  @override
  String get msgQualWcTitle2 => 'विश्व चैंपियनशिप का टिकट पक्का';

  @override
  String get msgQualWcTitle3 => 'हम विश्व चैंपियनशिप जा रहे हैं';

  @override
  String get msgQualWcTitle4 => 'टिकट कट गया';

  @override
  String msgQualWcBody1(int year) {
    return 'आपने $year विश्व चैंपियनशिप फ़ाइनल्स के लिए क्वालिफ़ाई कर लिया है।';
  }

  @override
  String msgQualWcBody2(int year) {
    return 'पक्का हो गया: आपका देश $year विश्व चैंपियनशिप में खेलेगा।';
  }

  @override
  String msgQualWcBody3(int year) {
    return '$year विश्व चैंपियनशिप में जगह पक्की हो गई है।';
  }

  @override
  String msgQualWcBody4(int year) {
    return 'आप $year विश्व चैंपियनशिप फ़ाइनल्स में पहुँच गए हैं।';
  }

  @override
  String msgQualContTitle1(String cup) {
    return '$cup के लिए क्वालिफ़ाई';
  }

  @override
  String msgQualContTitle2(String cup) {
    return '$cup का टिकट पक्का';
  }

  @override
  String msgQualContTitle3(String cup) {
    return '$cup के लिए क्वालिफ़ाई किया';
  }

  @override
  String msgQualContBody1(String cup) {
    return 'आपने $cup फ़ाइनल्स के लिए क्वालिफ़ाई कर लिया है।';
  }

  @override
  String msgQualContBody2(String cup) {
    return 'आपके देश ने $cup में अपनी जगह पक्की कर ली है।';
  }

  @override
  String msgQualContBody3(String cup) {
    return 'आप $cup में पहुँच गए हैं।';
  }

  @override
  String msgChampTitleMine1(String comp) {
    return '$comp चैंपियन!';
  }

  @override
  String msgChampTitleMine2(String comp) {
    return '$comp के चैंपियन!';
  }

  @override
  String msgChampTitleMine3(String comp) {
    return 'आपने $comp जीत लिया!';
  }

  @override
  String msgChampTitleOther1(String comp) {
    return '$comp का फ़ैसला हुआ';
  }

  @override
  String msgChampTitleOther2(String comp) {
    return '$comp को मिला नया चैंपियन';
  }

  @override
  String msgChampTitleOther3(String comp) {
    return '$comp का विजेता तय';
  }

  @override
  String msgChampBodyMine1(String comp, String loser, String result, int year) {
    return 'आपका देश $year $comp का चैंपियन है, $loser को$result हराकर।';
  }

  @override
  String msgChampBodyMine2(String comp, String loser, String result, int year) {
    return 'आपने $year $comp का ख़िताब जीत लिया, $loser को$result पछाड़कर।';
  }

  @override
  String msgChampBodyMine3(String comp, String loser, String result, int year) {
    return '$year $comp का ख़िताब आपका है। $loser को$result हराया।';
  }

  @override
  String msgChampBodyOther1(
    String winner,
    String comp,
    String loser,
    String result,
    int year,
  ) {
    return '$winner ने $year $comp का ख़िताब जीता, $loser को$result हराकर।';
  }

  @override
  String msgChampBodyOther2(
    String winner,
    String comp,
    String loser,
    String result,
    int year,
  ) {
    return '$winner $year $comp का चैंपियन है, $loser को$result मात देकर।';
  }

  @override
  String msgFinalScoreSuffix(int home, int away) {
    return ' फ़ाइनल में $home–$away से';
  }

  @override
  String msgFinalPensSuffix(int home, int away) {
    return ' $home–$away के फ़ाइनल के बाद पेनल्टी पर';
  }

  @override
  String get msgWpotyTitle => 'विश्व का सर्वश्रेष्ठ खिलाड़ी';

  @override
  String msgWpotyBodyMine(String name, String nation, int year) {
    return '$year के विश्व सर्वश्रेष्ठ खिलाड़ी का ख़िताब $name ($nation) को मिला, वे आपके अपने खिलाड़ी हैं।';
  }

  @override
  String msgWpotyBodyOther(String name, String nation, int year) {
    return '$year के विश्व सर्वश्रेष्ठ खिलाड़ी का ख़िताब $name ($nation) को मिला।';
  }

  @override
  String get msgYpotTitle => 'टूर्नामेंट का सर्वश्रेष्ठ युवा खिलाड़ी';

  @override
  String msgYpotBodyMine(String name, String nation, int age, int year) {
    return '$age साल के $name ($nation) को $year के टूर्नामेंट का सर्वश्रेष्ठ युवा खिलाड़ी चुना गया, वे आपके अपने खिलाड़ी हैं।';
  }

  @override
  String msgYpotBodyOther(String name, String nation, int age, int year) {
    return '$age साल के $name ($nation) को $year के टूर्नामेंट का सर्वश्रेष्ठ युवा खिलाड़ी चुना गया।';
  }

  @override
  String msgRankHold1(int rank) {
    return 'आप #$rank पर बने हुए हैं।';
  }

  @override
  String msgRankHold2(int rank) {
    return 'कोई बदलाव नहीं, अब भी #$rank।';
  }

  @override
  String msgRankHold3(int rank) {
    return '#$rank पर स्थिर।';
  }

  @override
  String msgRankUp1(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move स्थान',
      one: '$move स्थान',
    );
    return 'कुल मिलाकर $_temp0 ऊपर, अब #$rank पर।';
  }

  @override
  String msgRankUp2(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move स्थान',
      one: '$move स्थान',
    );
    return '$_temp0 की छलांग आपको #$rank पर ले आई।';
  }

  @override
  String msgRankUp3(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move स्थान',
      one: '$move स्थान',
    );
    return '$_temp0 ऊपर, अब #$rank।';
  }

  @override
  String msgRankDown1(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move स्थान',
      one: '$move स्थान',
    );
    return 'कुल मिलाकर $_temp0 नीचे, अब #$rank पर।';
  }

  @override
  String msgRankDown2(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move स्थान',
      one: '$move स्थान',
    );
    return '$_temp0 की गिरावट आपको #$rank पर ले आई।';
  }

  @override
  String msgRankDown3(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move स्थान',
      one: '$move स्थान',
    );
    return '$_temp0 नीचे, अब #$rank।';
  }

  @override
  String get msgRankLeadYou => 'आप दुनिया में पहले नंबर पर हैं।';

  @override
  String msgRankLeadOther(String nation) {
    return 'दुनिया में $nation शीर्ष पर है।';
  }

  @override
  String msgRankTitle(int rank) {
    return 'विश्व रैंकिंग · #$rank';
  }

  @override
  String msgRankBody(String lead, String movement) {
    return 'विश्व रैंकिंग अपडेट हो गई है। $lead $movement';
  }

  @override
  String msgRankJumpTitleUp(int rank) {
    return '#$rank तक छलांग';
  }

  @override
  String msgRankJumpTitleDown(int rank) {
    return '#$rank तक फिसले';
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
      other: '$move स्थान',
      one: '$move स्थान',
    );
    return '$tournament ने विश्व रैंकिंग बदल दी है। $nation #$from पर गया था और #$to पर निकला, यानी $_temp0 की छलांग।';
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
      other: '$move स्थान',
      one: '$move स्थान',
    );
    return '$tournament ने विश्व रैंकिंग बदल दी है। $nation #$from पर गया था और #$to पर निकला, यानी $_temp0 की गिरावट।';
  }

  @override
  String get rankingSinceWcDraw => 'विश्व चैंपियनशिप ड्रॉ के बाद से';

  @override
  String get rankingSinceCycleStart => 'अभियान शुरू होने के बाद से';

  @override
  String rankingMovedFromTo(int from, int now) {
    return '#$from से #$now';
  }

  @override
  String msgCapsTitle(String name, int count) {
    return '$name के $count कैप हुए';
  }

  @override
  String msgCapsBody(String name, int count) {
    return '$name अब आपके देश के लिए $count मैच खेल चुके हैं।';
  }

  @override
  String msgGoalsTitle(String name, int count) {
    return '$name के $count गोल हुए';
  }

  @override
  String msgGoalsBody(String name, int count) {
    return '$name आपके देश के लिए $count अंतरराष्ट्रीय गोल कर चुके हैं।';
  }

  @override
  String msgDevTitle(int year) {
    return 'स्क्वॉड विकास · $year';
  }

  @override
  String msgThroughTitle(int year) {
    return 'अकादमी से आगे आए · $year';
  }

  @override
  String get msgThroughNote =>
      'ये नया बैच नहीं हैं। ये वे लड़के हैं जो ग्यारह साल की उम्र में आए थे और अब सीनियर पूल तक पहुँच गए हैं।';

  @override
  String msgNewFacesTitle(int year) {
    return 'नए चेहरे · $year';
  }

  @override
  String get msgIntakeNoteAcademy =>
      'अकादमी में निवेश का असर दिख रहा है: यह बैच सामान्य से ज़्यादा मज़बूत आया है।';

  @override
  String get msgIntakeNoteStanding =>
      'देश इस टीम को देख रहा है: सीनियर टीम के विश्व रैंकिंग में चढ़ने से बेहतरीन लड़के फ़ुटबॉल चुन रहे हैं, और इस वजह से यह बैच ज़्यादा मज़बूत आया है।';

  @override
  String get msgIntakeNoteBoth =>
      'अकादमी का पैसा और टीम का विश्व रैंकिंग में चढ़ना, दोनों का असर दिख रहा है: यह बैच सामान्य से ज़्यादा मज़बूत आया है।';

  @override
  String msgIntakeTitle(int year) {
    return 'अकादमी बैच · $year';
  }

  @override
  String msgRetireCaptainTitle(String name) {
    return 'आपके कप्तान $name संन्यास ले रहे हैं';
  }

  @override
  String msgRetireTitle(String name) {
    return '$name का अंतरराष्ट्रीय फ़ुटबॉल से संन्यास';
  }

  @override
  String msgRetireBody(String name, int age) {
    return '$name ने $age साल की उम्र में अंतरराष्ट्रीय फ़ुटबॉल से संन्यास ले लिया है।';
  }

  @override
  String msgRetireBodyWith(String name, String tally, int age) {
    return '$name ने $age साल की उम्र में अंतरराष्ट्रीय फ़ुटबॉल से संन्यास ले लिया है, उनके नाम $tally रहे।';
  }

  @override
  String msgTallyCaps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count कैप',
      one: '$count कैप',
    );
    return '$_temp0';
  }

  @override
  String msgTallyGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count गोल',
      one: '$count गोल',
    );
    return '$_temp0';
  }

  @override
  String get msgArmbandVacant =>
      ' कप्तान का आर्मबैंड ख़ाली है। कॉल-अप स्क्रीन से नया कप्तान चुनें।';

  @override
  String msgHofTitle(String name) {
    return '$name हॉल ऑफ़ फ़ेम में शामिल';
  }

  @override
  String msgHofBody(String name, int caps, int goals) {
    return '$name आपके देश के हॉल ऑफ़ फ़ेम में शामिल हो गए ($caps कैप, $goals गोल)। उन्हें दिग्गज में देखें।';
  }

  @override
  String hubBanTitle(String name) {
    return '$name निलंबित';
  }

  @override
  String hubBanBody(String name, String how, int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: 'अगले $matches मैचों',
      one: 'अगले मैच',
    );
    return '$name $how और $_temp0 के लिए प्रतिबंधित है। वह चयन के लिए उपलब्ध नहीं रहेगा।';
  }

  @override
  String get hubBanHowSecondYellow => 'को दूसरे येलो कार्ड पर बाहर भेजा गया';

  @override
  String get hubBanHowViolent => 'को हिंसक आचरण पर सीधा रेड कार्ड दिखाया गया';

  @override
  String get hubBanHowRed => 'को बाहर भेजा गया';

  @override
  String hubInjuryTitle(String name) {
    return '$name चोटिल';
  }

  @override
  String hubInjuryBody(String name, int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: '$matches मैच',
      one: '$matches मैच',
    );
    return '$name को चोट लगी है और वह $_temp0 के लिए बाहर है।';
  }

  @override
  String get hubRunnerUpTitle1 => 'उपविजेता';

  @override
  String get hubRunnerUpTitle2 => 'मंज़िल के इतने क़रीब';

  @override
  String get hubRunnerUpTitle3 => 'रजत पदक';

  @override
  String hubRunnerUpBody1(String cup, String opponent) {
    return 'आप $cup फ़ाइनल में पहुँचे, पर $opponent से हार गए। बहुत क़रीब। इस बार रजत।';
  }

  @override
  String hubRunnerUpBody2(String cup, String opponent) {
    return '$cup फ़ाइनल में $opponent से हार। उपविजेता, दर्दनाक रूप से क़रीब।';
  }

  @override
  String hubRunnerUpBody3(String cup, String opponent) {
    return '$cup फ़ाइनल $opponent के ख़िलाफ़ हाथ से निकल गया। गर्व करने को बहुत कुछ है, पर ट्रॉफ़ी नहीं।';
  }

  @override
  String get hubKnockedOutTitle1 => 'बाहर';

  @override
  String get hubKnockedOutTitle2 => 'सफ़र का अंत';

  @override
  String get hubKnockedOutTitle3 => 'सफ़र ख़त्म';

  @override
  String hubKnockedOutBody1(String cup, String opponent, String stage) {
    return 'आप $cup से बाहर हो गए, $stage में $opponent से हार गए।';
  }

  @override
  String hubKnockedOutBody2(String cup, String opponent, String stage) {
    return '$opponent ने $stage में $cup से आपको बाहर कर दिया।';
  }

  @override
  String hubKnockedOutBody3(String cup, String opponent, String stage) {
    return '$cup में आपका सफ़र $stage में ख़त्म हुआ, $opponent से हारकर।';
  }

  @override
  String get hubGroupExitTitle1 => 'ग्रुप चरण से बाहर';

  @override
  String get hubGroupExitTitle2 => 'ग्रुप चरण में विदाई';

  @override
  String get hubGroupExitTitle3 => 'जल्दी विदाई';

  @override
  String hubGroupExitBody1(String cup) {
    return '$cup में आपका सफ़र ग्रुप चरण में ख़त्म हो गया। नॉकआउट तक पहुँचने के लिए यह काफ़ी नहीं था।';
  }

  @override
  String hubGroupExitBody2(String cup) {
    return 'आप ग्रुप से आगे नहीं बढ़ सके। $cup में आपका सफ़र यहीं ख़त्म होता है।';
  }

  @override
  String hubGroupExitBody3(String cup) {
    return 'इस बार नॉकआउट में जगह नहीं मिली। $cup में आपका सफ़र ग्रुप चरण में ख़त्म।';
  }

  @override
  String boardObjectiveMetTitle(String comp) {
    return 'लक्ष्य पूरा: $comp';
  }

  @override
  String boardObjectiveMissedTitle(String comp) {
    return 'लक्ष्य चूका: $comp';
  }

  @override
  String boardObjectiveMetBody(String comp, String demand, String finish) {
    return '$comp में बोर्ड का लक्ष्य: $demand। आपका नतीजा: $finish। बोर्ड को वही मिला जो उसने माँगा था।';
  }

  @override
  String boardObjectiveMissedBody(String comp, String demand, String finish) {
    return '$comp में बोर्ड का लक्ष्य: $demand। आपका नतीजा: $finish। यह उम्मीद से कम है।';
  }

  @override
  String get newsWcMissTitle => 'विश्व चैंपियनशिप का सपना टूटा';

  @override
  String newsWcMissBody(int year) {
    return 'आप $year विश्व चैंपियनशिप में जगह नहीं बना सके। क्वालिफ़ाइंग अभियान अधूरा रह गया। अब चार साल और।';
  }

  @override
  String get newsRecordScorerTitle => 'सर्वकालिक टॉप स्कोरर';

  @override
  String newsRecordScorerBody(String name, int goals) {
    return '$name $goals गोल के साथ अब गेम के सर्वकालिक सबसे बड़े गोलस्कोरर हैं।';
  }

  @override
  String get newsRecordCapsTitle => 'सबसे ज़्यादा कैप वाले खिलाड़ी';

  @override
  String newsRecordCapsBody(String name, int caps) {
    return '$name $caps मैचों के साथ अब गेम के सबसे ज़्यादा कैप वाले खिलाड़ी हैं।';
  }

  @override
  String get newsARecordBreaker => 'एक नया रिकॉर्ड-तोड़ खिलाड़ी';

  @override
  String newsTransferTitle(String name, String club) {
    return '$name $club में शामिल';
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
    return '$name ($position, $rating) ने $fromClub छोड़कर $fee में $destination से करार किया।';
  }

  @override
  String newsTransferAbroad(String club, String country) {
    return '$country का $club';
  }

  @override
  String get newsTransferFree => 'फ़्री';

  @override
  String newsNatzStarTitle(String name, String nation) {
    return '$name $nation के लिए खेलने को तैयार!';
  }

  @override
  String newsNatzTitle(String name, String nation) {
    return '$name $nation के लिए खेलना चाहते हैं';
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
    return '$fromNation के साथ मौजूदा तौर पर खेल रहे $age साल के $position $name की रेटिंग $rating है। उनके परिवार का $nation से रिश्ता है और वे टीम बदलने को तैयार हैं। स्वीकार या अस्वीकार करने के लिए नागरिकता प्रस्ताव खोलें।';
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
    return '$fromNation के साथ मौजूदा तौर पर खेल रहे $age साल के $position $name की रेटिंग $rating है। वे एक बड़ा सितारा हैं, उनके परिवार का $nation से रिश्ता है और वे टीम बदलने को तैयार हैं। स्वीकार या अस्वीकार करने के लिए नागरिकता प्रस्ताव खोलें।';
  }

  @override
  String get newsTheirNation => 'उनका देश';

  @override
  String get newsYourNation => 'आपका देश';

  @override
  String get tourStatusChampions => 'चैंपियन';

  @override
  String get tourStatusFinals => 'फ़ाइनल्स';

  @override
  String get tourStatusQualifying => 'क्वालिफ़ाइंग';

  @override
  String get tourStatusUpcoming => 'आगामी';

  @override
  String get tourStatusInProgress => 'जारी';

  @override
  String get tourStatusComingSoon => 'जल्द आ रहा है';

  @override
  String get tourStatusDecided => 'तय';

  @override
  String tourStatusLeague(String letter) {
    return 'लीग $letter';
  }

  @override
  String get tourDrawWcQualifying => 'विश्व क्वालिफ़ाइंग ड्रॉ';

  @override
  String tourDrawContQualifying(String cup) {
    return '$cup क्वालिफ़ाइंग ड्रॉ';
  }

  @override
  String get tourDrawWcHost => 'विश्व चैंपियनशिप मेज़बानी';

  @override
  String tourDrawContHost(String cup) {
    return '$cup मेज़बानी';
  }

  @override
  String get tourDrawHostsReveal => 'और मेज़बान होंगे…';

  @override
  String get tourDrawHostReveal => 'और मेज़बान होंगे…';

  @override
  String get tourDrawHostCandidates => 'दौड़ में शामिल दावेदार:';

  @override
  String get tourKickoffContinentalCup => 'महाद्वीपीय कप';

  @override
  String tourHostCompetitionYear(String competition, int year) {
    return '$competition $year';
  }

  @override
  String newsContMissTitle(String cup) {
    return '$cup से बाहर';
  }

  @override
  String newsContMissBody(String cup) {
    return 'आप $cup के लिए क्वालिफ़ाई नहीं कर सके। इस बार अभियान अधूरा रह गया।';
  }

  @override
  String get potyLabelBest => 'प्लेयर ऑफ़ द ईयर';

  @override
  String get potyLabelYoung => 'यंग प्लेयर ऑफ़ द ईयर';

  @override
  String potyTallyAssists(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count असिस्ट',
      one: '$count असिस्ट',
    );
    return '$_temp0';
  }

  @override
  String potyOverallValue(int value) {
    return 'रेटिंग $value';
  }

  @override
  String potyRatingValue(String value) {
    return 'औसत अंक $value';
  }

  @override
  String newsPotyTitle(int year) {
    return 'वर्ल्ड प्लेयर ऑफ़ द ईयर $year';
  }

  @override
  String newsPotyBody(String name) {
    return '$name इस साल दुनिया के सर्वश्रेष्ठ खिलाड़ी हैं।';
  }

  @override
  String newsPotyYoungSuffix(String name) {
    return ' युवा खिलाड़ी का पुरस्कार $name को मिला है।';
  }

  @override
  String newsWatchTitle(int year) {
    return 'आपकी नज़र में मौजूद लड़के, $year';
  }

  @override
  String newsWatchJump(String name, int rating, int gain) {
    String _temp0 = intl.Intl.pluralLogic(
      gain,
      locale: localeName,
      other: '$gain अंक',
      one: '$gain अंक',
    );
    return '$name की रेटिंग बढ़कर $rating हो गई है, यानी पिछले साल से $_temp0 ज़्यादा।';
  }

  @override
  String newsWatchBand(String name, String band) {
    return '$name अब $band वर्ग में पहुँच गए हैं।';
  }

  @override
  String newsWatchDebutTitle(String name) {
    return '$name का डेब्यू';
  }

  @override
  String newsWatchDebutBody(String name, int age, int rating) {
    return '$name ने $age की उम्र में अपना पहला कैप जीता, रेटिंग $rating। आपकी नज़र में मौजूद लड़कों में से एक।';
  }

  @override
  String get matchStatsAtFullTime =>
      'पज़ेशन, खिलाड़ियों की रेटिंग और मैन ऑफ़ द मैच का फ़ैसला अंतिम सीटी पर होता है।';

  @override
  String get matchPlayerRatings => 'खिलाड़ियों की रेटिंग';

  @override
  String get matchSubstitutions => 'बदलाव';

  @override
  String get matchSubstitutes => 'स्थानापन्न';

  @override
  String get matchPlayerOfTheMatch => 'मैन ऑफ़ द मैच';

  @override
  String get matchGoalShout => 'गोल!';

  @override
  String matchShootoutScore(int home, int away) {
    return 'शूटआउट $home–$away';
  }

  @override
  String matchShootoutKickScored(String name) {
    return '$name: गोल';
  }

  @override
  String matchShootoutKickMissed(String name) {
    return '$name: चूक';
  }

  @override
  String get matchFeedKickOff => 'किक-ऑफ़!';

  @override
  String get matchFeedNoEvents => 'अभी कोई घटना नहीं।';

  @override
  String get tourVenues => 'स्टेडियम';

  @override
  String tourPot(int number) {
    return 'पॉट $number';
  }

  @override
  String get tourHostSelection => 'मेज़बान का चयन';

  @override
  String get tourCandidates => 'दावेदार';

  @override
  String get tourJointBid => 'संयुक्त बोली';

  @override
  String get tourGoldenGlove => 'गोल्डन ग्लव';

  @override
  String get tourTeamOfTournament => 'टूर्नामेंट की टीम';

  @override
  String get tourYourRun => 'आपका सफ़र';

  @override
  String get tourMedalTable => 'पदक तालिका';

  @override
  String tourHostLine(String nation) {
    return 'मेज़बान: $nation';
  }

  @override
  String tourHostLineMulti(String hosts) {
    return 'मेज़बान: $hosts';
  }

  @override
  String tourGroupNamed(String name) {
    return 'ग्रुप $name';
  }

  @override
  String get tourFinalsDrawBlurb =>
      'विश्व रैंकिंग के आधार पर सीडिंग। ड्रॉ से पहले अपने देश को खोजें।';

  @override
  String get tourWorldRanking => 'विश्व रैंकिंग';

  @override
  String get tourYourCompetitions => 'आपकी प्रतियोगिताएँ';

  @override
  String get tourOtherContinents => 'अन्य महाद्वीप';

  @override
  String get tourZoneGlobal => 'विश्व';

  @override
  String get tourZoneEurope => 'यूरोप';

  @override
  String get tourZoneSouthAmerica => 'द. अमेरिका';

  @override
  String get tourZoneNorthAmerica => 'उ. अमेरिका';

  @override
  String get tourZoneAfrica => 'अफ़्रीका';

  @override
  String get tourZoneAsia => 'एशिया';

  @override
  String get tourZoneOceania => 'ओशिनिया';

  @override
  String get tourZoneIntercontinental => 'अंतर-महाद्वीपीय';

  @override
  String tourZoneLeague(String league) {
    return 'लीग $league';
  }

  @override
  String tourHostedBy(String hosts) {
    return 'मेज़बान  $hosts';
  }

  @override
  String tourThirdsAdvance(int count, String destination) {
    return 'शीर्ष $count $destination में पहुँचेंगे';
  }

  @override
  String newsWalkoutTitle(String name) {
    return '$name ने साथ छोड़ा';
  }

  @override
  String newsWalkoutBody(String name, int age, int caps) {
    return '$name ने $age की उम्र में $caps कैप के बाद अंतरराष्ट्रीय फ़ुटबॉल से संन्यास ले लिया है। उन्होंने जानना चाहा था कि टीम में उनकी जगह कहाँ है, पर उन्हें कुछ नहीं बताया गया, और अब वे और इंतज़ार नहीं करेंगे।';
  }

  @override
  String get pressHeadlineWent1 => 'कमरे पर पूरा काबू रखने वाला कोच';

  @override
  String get pressHeadlineWent2 => 'वे विवाद करने आए थे, मिला एक लीडर';

  @override
  String get pressHeadlineWent3 => 'सीधे जवाब, और सीधे निशाने पर';

  @override
  String get pressHeadlineMixed1 => 'बातें बहुत हुईं, फ़ैसला कुछ नहीं';

  @override
  String get pressHeadlineMixed2 => 'सबके लिए कुछ न कुछ, पर किसी को कुछ नहीं';

  @override
  String get pressHeadlineMixed3 => 'ऐसी कॉन्फ़्रेंस जिसने सवाल खुले छोड़ दिए';

  @override
  String get pressHeadlineBadly1 => 'कैमरों के सामने एक कड़वी दोपहर';

  @override
  String get pressHeadlineBadly2 => 'कमरे का मूड पलटा, और साफ़ दिखा';

  @override
  String get pressHeadlineBadly3 => 'ऐसे जवाब जो सुबह और भारी पड़ेंगे';

  @override
  String get pressHeadlineFlat1 => 'कुछ कहा नहीं, कुछ मिला नहीं';

  @override
  String get pressHeadlineFlat2 => 'दस मिनट, कोई ख़बर नहीं';

  @override
  String get pressHeadlineFlat3 => 'आख़िरी पन्ने के लिए एक कोरा पन्ना';

  @override
  String get pressConferenceTitle => 'प्रेस कॉन्फ़्रेंस';

  @override
  String pressQuestionOf(int index, int total) {
    return 'सवाल $index / $total';
  }

  @override
  String get pressTomorrowsHeadline => 'कल का आख़िरी पन्ना';

  @override
  String get pressLeaveRoom => 'कमरा छोड़ें';

  @override
  String get pressRoomVerdictSquad => 'ड्रेसिंग रूम';

  @override
  String get pressRoomVerdictBoard => 'बोर्ड';

  @override
  String get yReactionElation0 => 'कोई कमी नहीं। एकदम परफ़ेक्ट।';

  @override
  String get yReactionElation1 => 'मेरी तबीयत ख़राब है (अच्छे वाले अर्थ में)।';

  @override
  String get yReactionElation2 =>
      'इसे फ़्रेम कराकर फ़ायरप्लेस के ऊपर लगा रहा हूँ।';

  @override
  String get yReactionElation3 => 'हम वापस आ गए!';

  @override
  String get yReactionElation4 =>
      'शक करने वालों के लिए इसका स्क्रीनशॉट ले रहा हूँ। सभी के लिए।';

  @override
  String get yReactionElation5 => 'अब मैं दस साल तक इसका घमंड करूँगा।';

  @override
  String get yReactionElation6 => 'बस। इसी के लिए हम मैच देखते हैं।';

  @override
  String get yReactionElation7 => 'ऐसे दिन बाक़ी दिनों की भरपाई कर देते हैं।';

  @override
  String get yReactionElation8 => 'आख़िरकार। सच में, आख़िरकार।';

  @override
  String get yReactionElation9 =>
      'बढ़िया। अब अगले हफ़्ते भी यही करके दिखाओ, तब यक़ीन करूँगा।';

  @override
  String get yReactionElation10 =>
      'आज रात जश्न मनाइए, क्योंकि ये टीम इसे बिगाड़ने का रास्ता निकाल ही लेगी।';

  @override
  String get yReactionElation11 =>
      'एक अच्छी रात किसी को बड़ी टीम नहीं बना देती।';

  @override
  String get yReactionRelief0 => 'खेल भद्दा था, पर मैं हर बार यही लूँगा।';

  @override
  String get yReactionRelief1 => 'जैसे-तैसे। जैसे-तैसे!';

  @override
  String get yReactionRelief2 => 'भद्दा खेल। तीन अंक। आगे बढ़ो।';

  @override
  String get yReactionRelief3 =>
      'अंक मिलते हों तो मैं दिन भर भद्दा खेल देख लूँगा।';

  @override
  String get yReactionRelief4 => 'इस मैच ने मेरी दस साल की उम्र घटा दी';

  @override
  String get yReactionRelief5 => 'कोई कुछ मत बोलो। नज़र मत लगाओ।';

  @override
  String get yReactionRelief6 => 'धड़कन: बर्दाश्त से बाहर।';

  @override
  String get yReactionRelief7 => 'बच गए। बस यही शब्द है। बच गए।';

  @override
  String get yReactionRelief8 =>
      'ऐसे मैचों के बाद राहत की ज़रूरत ही नहीं पड़नी चाहिए।';

  @override
  String get yReactionRelief9 =>
      'राहत मिली है, और राहत मिलने पर थोड़ी शर्म भी आ रही है।';

  @override
  String get yReactionRelief10 =>
      'अगर यही स्तर हमारे जश्न की वजह है, तो हम मुश्किल में हैं।';

  @override
  String get yReactionRelief11 =>
      'जैसे-तैसे पार लगना आदत बन गई है, और अच्छी आदत नहीं है।';

  @override
  String get yReactionFury0 => 'यह काफ़ी नहीं है। बिल्कुल भी नहीं।';

  @override
  String get yReactionFury1 => 'कोई मुझे यह धीरे-धीरे समझाए।';

  @override
  String get yReactionFury2 =>
      'यह देखना बहुत मुश्किल था, और मैं नरमी से कह रहा हूँ।';

  @override
  String get yReactionFury3 => 'निराश हूँ। सच में निराश।';

  @override
  String get yReactionFury4 => 'क्या हाल बना रखा है।';

  @override
  String get yReactionFury5 => 'मुझे नाम चाहिए।';

  @override
  String get yReactionFury6 =>
      'ऐप डिलीट कर रहा हूँ। गुरुवार को फिर इंस्टॉल करूँगा।';

  @override
  String get yReactionFury7 => 'मैदान पर किसी में जीतने की भूख नहीं दिखी।';

  @override
  String get yReactionFury8 => 'हर चार साल में वही हाल। हर चार साल में!';

  @override
  String get yReactionFury9 => 'यह प्रदर्शन नहीं, अपमान है।';

  @override
  String get yReactionFury10 =>
      'लोग इसके लिए अपने सप्ताहांत और पैसे क़ुर्बान करते हैं। ज़रा सोचिए।';

  @override
  String get yReactionFury11 =>
      'मैं सालों से इस टीम का बचाव करता आया हूँ। आज नहीं। इसके बाद तो बिल्कुल नहीं।';

  @override
  String get yReactionDespair0 => 'तो।';

  @override
  String get yReactionDespair1 => 'आज कोई मज़ाक नहीं। कुछ नहीं।';

  @override
  String get yReactionDespair2 => 'टहलने जा रहा हूँ। लंबे वाले।';

  @override
  String get yReactionDespair3 =>
      'यह बात कहने के तरीक़े ख़त्म हो गए हैं मेरे पास।';

  @override
  String get yReactionDespair4 => 'चार साल बाद जगाना।';

  @override
  String get yReactionDespair5 => 'यह सबसे बुरा दौर है';

  @override
  String get yReactionDespair6 =>
      'अब ग़ुस्सा भी नहीं आता। चिंता की बात यही है।';

  @override
  String get yReactionDespair7 => 'यह चोट लंबे समय तक दुखेगी।';

  @override
  String get yReactionDespair8 =>
      'पता नहीं यह क्या है, पर फ़ुटबॉल टीम तो नहीं है।';

  @override
  String get yReactionDespair9 =>
      'हम पहले से भी दूर हो गए हैं, और कोई यह कहेगा नहीं।';

  @override
  String get yReactionDespair10 =>
      'पूरी एक पीढ़ी बर्बाद हो गई और आगे का फ़ैसला वही लोग करेंगे।';

  @override
  String get yReactionDespair11 =>
      'अब यह मत कहो कि यह प्रक्रिया है। यह कहीं नहीं जा रही।';

  @override
  String get yReactionSmugness0 => 'चुपचाप ही सही, पर कहा था ना।';

  @override
  String get yReactionSmugness1 => 'इसे बुकमार्क कर लो';

  @override
  String get yReactionSmugness2 => 'शक करने वाले अब बिल्कुल चुप हैं।';

  @override
  String get yReactionSmugness3 => 'कोई गिन नहीं रहा, पर मैं गिन रहा हूँ।';

  @override
  String get yReactionSmugness4 => 'जनवरी में ही कह दिया था। टाइमलाइन देख लो।';

  @override
  String get yReactionSmugness5 =>
      'आप में से कुछ लोगों को हम में से कुछ से माफ़ी माँगनी चाहिए।';

  @override
  String get yReactionSmugness6 =>
      'इसे उन बातों में दर्ज कर रहा हूँ जो मैंने सबसे पहले कही थीं।';

  @override
  String get yReactionSmugness7 => 'कोई घमंड नहीं। बस थोड़ा सा घमंड।';

  @override
  String get yReactionSmugness8 =>
      'अब सारे विशेषज्ञ कहाँ हैं? सच में पूछ रहा हूँ।';

  @override
  String get yReactionSmugness9 =>
      'मैं चाहता हूँ कि आप में से हर कोई यही बात मुझे दोहराकर सुनाए।';

  @override
  String get yReactionSmugness10 =>
      'स्क्रीनशॉट, प्रिंट, फ़्रेम, और हँसने वालों को भेज दिया।';

  @override
  String get yReactionSmugness11 =>
      'यह बात मैं ज़िंदगी भर उठाता रहूँगा, और आप लोगों ने इसे कमाया है।';

  @override
  String get yReactionShrug0 => 'जो होना था हो गया। अगला।';

  @override
  String get yReactionShrug1 => 'ठीक है। जाने दो। आगे बढ़ो।';

  @override
  String get yReactionShrug2 => 'इसे \'फ़ुटबॉल\' की फ़ाइल में डाल रहा हूँ।';

  @override
  String get yReactionShrug3 => 'सच में कहने को कुछ नहीं।';

  @override
  String get yReactionShrug4 => 'कोई विचार नहीं, दिमाग़ ख़ाली';

  @override
  String get yReactionShrug5 => 'अगले मैच पर जगाना।';

  @override
  String get yReactionShrug6 => 'नब्बे मिनट जो अब कभी वापस नहीं मिलेंगे।';

  @override
  String get yReactionShrug7 => 'न इधर का, न उधर का।';

  @override
  String get yReactionShrug8 => 'क्या हुआ, यह मैं एक भी बात नहीं बता सकता।';

  @override
  String get yReactionShrug9 => 'एक और ऐसा मैच। ऐसे बहुत सारे हैं।';

  @override
  String get yReactionShrug10 => 'पूरा मैच देखा और कुछ भी महसूस नहीं हुआ।';

  @override
  String get yReactionShrug11 =>
      'अगर इस पर दोबारा कोई बात न करे, तो मुझे कोई दिक़्क़त नहीं।';

  @override
  String get tourThirdsUneven =>
      'ग्रुप असमान हैं, इसलिए हर बड़े ग्रुप की सबसे निचली टीम के ख़िलाफ़ नतीजे हटा दिए जाते हैं और हर टीम को बराबर मैचों पर परखा जाता है।';

  @override
  String get careerExportSave => 'इस सेव का बैकअप लें';

  @override
  String get careerBackupAll => 'सभी सेव का बैकअप लें';

  @override
  String get careerBackupAllFailed => 'बैकअप नहीं लिखा जा सका।';

  @override
  String get backupTitle => 'बैकअप';

  @override
  String get backupBlurb =>
      'सारे सेव इस फ़ोन पर एक ही फ़ाइल में हैं, और जब तक आप नीचे अपने आप बैकअप चालू न करें, कुछ भी उनका बैकअप ख़ुद नहीं लेता। क्लाउड में एक कॉपी रखें, ताकि फ़ोन खोने या ऐप हटाने से आपका करियर न जाए।';

  @override
  String get backupBlurbNoAuto =>
      'सारे सेव इस फ़ोन पर एक ही फ़ाइल में हैं, और कुछ भी उनका बैकअप ख़ुद नहीं लेता। क्लाउड में एक कॉपी रखें, ताकि फ़ोन खोने या ऐप हटाने से आपका करियर न जाए।';

  @override
  String get backupExport => 'क्लाउड में बैकअप लें';

  @override
  String get backupExportSubject => 'FNM सेव';

  @override
  String get backupRestore => 'फ़ाइल से रिस्टोर करें';

  @override
  String get backupRestoreWarnTitle => 'सभी सेव बदलें?';

  @override
  String get backupRestoreWarnBody =>
      'रिस्टोर करने पर इस फ़ोन के सभी सेव फ़ाइल वाले सेव से बदल जाएँगे। ऐप दोबारा शुरू होगा।';

  @override
  String get backupRestoreConfirm => 'बदलें';

  @override
  String get backupCancel => 'रद्द करें';

  @override
  String get backupExported => 'बैकअप तैयार है। चुनें कि इसे कहाँ रखना है।';

  @override
  String get backupFailed => 'बैकअप नहीं लिखा जा सका।';

  @override
  String get backupRejectedUnreadable => 'वह फ़ाइल खोली नहीं जा सकी।';

  @override
  String get backupRejectedNotFnm => 'यह FNM सेव नहीं है।';

  @override
  String get backupRejectedNewer =>
      'वह सेव ऐप के नए वर्ज़न से बना था। पहले अपडेट करें।';

  @override
  String get backupRejectedTooOld =>
      'वह सेव इतना पुराना है कि इस वर्ज़न में रिस्टोर नहीं हो सकता।';

  @override
  String get careerShare => 'इस करियर को शेयर करें';

  @override
  String get careerImport => 'करियर इम्पोर्ट करें';

  @override
  String get careerShareSubject => 'एक FNM करियर';

  @override
  String get careerImported => 'करियर इम्पोर्ट हो गया।';

  @override
  String get careerImportFailedUnreadable => 'वह फ़ाइल FNM करियर नहीं है।';

  @override
  String get careerImportFailedNewer =>
      'वह करियर ऐप के नए वर्ज़न से एक्सपोर्ट हुआ था। पहले अपडेट करें।';

  @override
  String get careerImportFailedSlotsFull =>
      'आपके सभी सेव स्लॉट भरे हैं। जगह बनाने के लिए कोई सेव हटाएँ, या असीमित सेव अनलॉक करें।';

  @override
  String get careerImportFailedNeedsPremium =>
      'वह करियर मुफ़्त पहले चक्र से आगे निकल चुका है। उसे लाने के लिए पूरा गेम अनलॉक करें।';

  @override
  String get careerImportFailedCampaignRun =>
      'उस कैंपेन में पहले से एक रन चल रहा है। पहले उसे जारी रखें या छोड़ दें।';

  @override
  String get careerShareFailed => 'वह करियर एक्सपोर्ट नहीं हो सका।';

  @override
  String get managerRename => 'नाम बदलें';

  @override
  String get managerRenameSave => 'सेव करें';

  @override
  String get managerTitle => 'मैनेजर';

  @override
  String get managerSkills => 'आपके कौशल';

  @override
  String managerPointsAvailable(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ख़र्च करने के लिए $count पॉइंट',
      one: 'ख़र्च करने के लिए $count पॉइंट',
      zero: 'ख़र्च करने के लिए कोई पॉइंट नहीं',
    );
    return '$_temp0';
  }

  @override
  String get managerPointsHow =>
      'हर पूरे किए चक्र पर दो पॉइंट, और हर जीती ट्रॉफ़ी पर एक।';

  @override
  String get managerSkillsScale =>
      'हर कौशल 5 से शुरू होता है और 20 पर रुकता है। ख़र्च किया हुआ पॉइंट हमेशा के लिए है।';

  @override
  String get managerSkillManManagement => 'मैन मैनेजमेंट';

  @override
  String get managerSkillManManagementBlurb =>
      'हर पॉइंट से प्रेस और खिलाड़ियों से आपकी कही बात ड्रेसिंग रूम में 3% ज़्यादा असर करती है।';

  @override
  String get managerSkillTactical => 'टैक्टिकल';

  @override
  String get managerSkillTacticalBlurb =>
      'हर पॉइंट से नया फ़ॉर्मेशन 3% तेज़ी से जम जाता है, इसलिए शैली बदलने पर कम मैच गँवाने पड़ते हैं।';

  @override
  String get managerSkillYouth => 'युवा विकास';

  @override
  String get managerSkillYouthBlurb =>
      'हर पॉइंट आपकी एकेडमी से निकलने वाली प्रतिभा में 1% जोड़ता है, आपके दिए फ़ंड के ऊपर।';

  @override
  String get managerSkillNegotiation => 'बातचीत';

  @override
  String get managerSkillNegotiationBlurb =>
      'हर पॉइंट से फ़ेडरेशन से हर चक्र 2% ज़्यादा पैसा मिलता है।';

  @override
  String get managerStaff => 'आपका स्टाफ़';

  @override
  String managerStaffWages(String amount) {
    return 'वेतन: प्रति चक्र $amount';
  }

  @override
  String get managerRoleAssistant => 'असिस्टेंट मैनेजर';

  @override
  String get managerRoleAssistantBlurb =>
      'ट्रेनिंग चलाते हैं: चोटें कम, और बेहतर युवा खिलाड़ी उभरते हैं।';

  @override
  String get managerRoleScout => 'चीफ़ स्काउट';

  @override
  String get managerRoleScoutBlurb =>
      'आपके उभरते खिलाड़ियों और अगले विरोधी को परखते हैं: सितारा रेटिंग ज़्यादा सटीक, और मैच के दिन बढ़त।';

  @override
  String get managerRoleFitness => 'फ़िटनेस कोच';

  @override
  String get managerRoleFitnessBlurb => 'खिलाड़ियों को मैदान पर बनाए रखते हैं।';

  @override
  String staffEffectInjury(int percent) {
    return '$percent% कम चोटें';
  }

  @override
  String staffEffectYouth(int points) {
    return 'युवा खिलाड़ी +$points ओवरऑल';
  }

  @override
  String staffHiringInjury(int min, int max) {
    return 'किसी को रखने पर: $min% से $max% कम चोटें';
  }

  @override
  String staffHiringYouth(int minPoints, int maxPoints) {
    return 'और युवा खिलाड़ी +$minPoints से +$maxPoints ओवरऑल';
  }

  @override
  String staffEffectScoutRead(int percent) {
    return '$percent% उभरते खिलाड़ियों को सटीक परखते हैं';
  }

  @override
  String staffEffectScoutCaps(int caps) {
    String _temp0 = intl.Intl.pluralLogic(
      caps,
      locale: localeName,
      other: '$caps कैप के बाद क्षमता का पता चलता है',
      one: '1 कैप के बाद क्षमता का पता चलता है',
    );
    return '$_temp0';
  }

  @override
  String staffEffectScoutDossier(int points) {
    return 'विरोधी डॉसियर से +$points रेटिंग';
  }

  @override
  String staffHiringScoutRead(int min, int max) {
    return 'किसी को रखने पर: $min% से $max% रिपोर्ट सटीक';
  }

  @override
  String staffHiringScoutCaps(int minCaps, int maxCaps) {
    return 'और क्षमता $minCaps से $maxCaps कैप पहले पता चलती है';
  }

  @override
  String staffHiringScoutDossier(int minPoints, int maxPoints) {
    return 'और हर मैच में +$minPoints से +$maxPoints रेटिंग';
  }

  @override
  String get staffEffectNone => 'आपके स्क्वॉड पर अभी कोई असर नहीं';

  @override
  String get staffVacant => 'पद पर कोई नहीं';

  @override
  String get staffLeaveVacant => 'पद ख़ाली रखें';

  @override
  String get managerTierNone => 'कोई नहीं';

  @override
  String get managerTierBasic => 'बुनियादी';

  @override
  String get managerTierGood => 'अच्छा';

  @override
  String get managerTierElite => 'एलीट';

  @override
  String get managerFree => 'मुफ़्त';

  @override
  String get managerTraining => 'विंडो के बीच';

  @override
  String get managerTrainingBlurb =>
      'जब खेलने के लिए कोई मैच नहीं होता, तब स्क्वॉड किस पर काम करता है।';

  @override
  String get managerFocusBalanced => 'संतुलित';

  @override
  String get managerFocusBalancedBlurb => 'थोड़ा-थोड़ा सब कुछ।';

  @override
  String get managerFocusFitness => 'फ़िटनेस';

  @override
  String get managerFocusFitnessBlurb => 'चोटें कम।';

  @override
  String get managerFocusCohesion => 'तालमेल';

  @override
  String get managerFocusCohesionBlurb => 'फ़ॉर्मेशन जल्दी जमता है।';

  @override
  String get managerFocusYouth => 'युवा';

  @override
  String get managerFocusYouthBlurb =>
      'पूल के सबसे युवा खिलाड़ियों के साथ ज़्यादा घंटे।';

  @override
  String get tourOfferTitle => 'यहाँ पहली बार?';

  @override
  String get tourOfferBody =>
      'यह बड़ा गेम है। क्या आप ज़रूरी स्क्रीनों का एक छोटा सा दौरा चाहेंगे? इसमें बस एक मिनट लगता है, और आप इसे कभी भी सेटिंग्स से दोबारा शुरू कर सकते हैं।';

  @override
  String get tourOfferYes => 'मुझे दिखाइए';

  @override
  String get tourOfferNo => 'नहीं, धन्यवाद';

  @override
  String get tourBack => 'वापस';

  @override
  String get tourNext => 'आगे';

  @override
  String get tourDone => 'पूरा हुआ';

  @override
  String get tourSkip => 'छोड़ें';

  @override
  String get tourHubTitle => 'यही पूरा गेम है';

  @override
  String get tourHubBody =>
      'एक बटन, जो चक्र के साथ बदलता रहता है: देखने के लिए ड्रॉ, चुनने के लिए स्क्वॉड, खेलने के लिए मैच। उसके ऊपर बोर्ड का आप पर भरोसा और उनके तय किए लक्ष्य दिखते हैं।';

  @override
  String get tourBudgetTitle => 'फ़ेडरेशन का पैसा';

  @override
  String get tourBudgetBody =>
      'हर चार साल के चक्र में एक बार आप ख़ज़ाने को विभागों में बाँटते हैं। आपके स्टाफ़ का वेतन उसी में से पहले जाता है, इसलिए एलीट स्काउट रखना एकेडमी के बदले लिया गया फ़ैसला है, उसके साथ नहीं।';

  @override
  String get tourTacticsTitle => 'टीम कैसे खेलती है';

  @override
  String get tourTacticsBody =>
      'आपकी फ़ॉर्मेशन, खेलने का तरीक़ा, आपका कप्तान और सेट पीस कौन लेता है। आख़िरी दो तय न करें तो गेम चुपचाप चुनने के बजाय किक-ऑफ़ से पहले चेतावनी देगा।';

  @override
  String get tourSquadTitle => 'चुनने लायक़ हर खिलाड़ी';

  @override
  String get tourSquadBody =>
      'सिर्फ़ स्क्वॉड नहीं, पूरा पूल: कौन फ़ॉर्म में है, किसे चोट है, कौन प्रतिबंधित है, और कौन अभी-अभी एकेडमी से निकला है।';

  @override
  String get tourCallUpsTitle => 'स्क्वॉड का चयन';

  @override
  String get tourCallUpsBody =>
      'आप हर अंतरराष्ट्रीय विंडो के लिए एक स्क्वॉड चुनते हैं और वही उस विंडो का हर मैच खेलता है, बिल्कुल असली कोच की तरह। विंडो के बीच चोट लगे तो आपके लिए एक रिप्लेसमेंट बुला लिया जाता है।';

  @override
  String get tourRecordsTitle => 'आपका करियर';

  @override
  String get tourRecordsBody =>
      'आपका सब कुछ: मैच, टीम रिकॉर्ड, ट्रॉफ़ियाँ, और हर वह देश जिसके आप कोच रहे।';

  @override
  String get tourCupsTitle => 'बाक़ी दुनिया';

  @override
  String get tourCupsBody =>
      'अभी चल रही हर प्रतियोगिता: ग्रुप, अंक तालिका और नॉकआउट, उनमें भी जिनमें आप नहीं हैं। आप क्वालिफ़ाई करें या न करें, दुनिया खेलती रहती है।';

  @override
  String get settingsTourTitle => 'ट्यूटोरियल दोबारा देखें';

  @override
  String get settingsTourBlurb => 'मुख्य स्क्रीनों का दौरा शुरू से फिर करें।';

  @override
  String get tourBoardTitle => 'आप किसके प्रति जवाबदेह हैं';

  @override
  String get tourBoardBody =>
      'आप पर बोर्ड का भरोसा और इस चक्र के लिए उनके तय लक्ष्य। लक्ष्य चूके तो इसका अंदाज़ा आपको यहीं मिल जाएगा।';

  @override
  String get tourStaffTitle => 'आपके आस-पास के लोग';

  @override
  String get tourStaffBody =>
      'एक असिस्टेंट, एक स्काउट और एक फ़िटनेस कोच, नाम लेकर रखे गए। उनका वेतन विभागों से पहले इसी बजट से जाता है, इसलिए बढ़िया स्काउट रखना एकेडमी के बदले लिया गया फ़ैसला है।';

  @override
  String get tourPlaystyleTitle => 'आपके खेलने का तरीक़ा';

  @override
  String get tourPlaystyleBody =>
      'फ़ॉर्मेशन आधी ही रणनीति है। बाक़ी आधी यह है: कितना ऊँचा प्रेस, कितना सीधा खेल, कितना जोखिम।';

  @override
  String get settingsTourNoSave =>
      'पहले करियर शुरू करें। यह दौरा आपकी अपनी स्क्रीनों से गुज़रता है।';

  @override
  String tacticsOutOfPositionAge(int age) {
    return 'ग़लत पोज़ीशन · उम्र $age';
  }

  @override
  String get federationNextCycleLocked =>
      'अगले चक्र का बजट उस चक्र की शुरुआत में एक साथ तय होता है। तब तक आपका पैसा यही कर रहा है।';

  @override
  String get federationBudgetAlreadySet => 'इस चक्र के लिए पहले ही तय';

  @override
  String yFinalLooms0(String opponent) {
    return 'बड़े मुक़ाबले में $opponent है। पूरे हफ़्ते सब यही बात करेंगे।';
  }

  @override
  String yFinalLooms1(String opponent) {
    return 'पक्का: $opponent हमारे और उसके बीच खड़ा है। इसके लिए चार साल इंतज़ार किया।';
  }

  @override
  String yFinalLooms2(String opponent) {
    return 'ठीक है। $opponent। यह ख़त्म होने तक कोई नहीं सोएगा।';
  }

  @override
  String yFinalLooms3(String opponent) {
    return 'अगला $opponent, बाक़ी सब बाद में। क्या हफ़्ता है ज़िंदा रहने के लिए!';
  }

  @override
  String get matchSetupLeaveToCoach => 'टेकर्स कोच पर छोड़ें';

  @override
  String friendliesLikeYourGroup(String rivals) {
    return 'नीचे चिह्नित: $rivals जैसी शैली वाली टीमें, जिनसे आप इस चक्र में अपने ग्रुपों में भिड़ेंगे।';
  }

  @override
  String newsTransferWindowTitle(int year) {
    return 'ट्रांसफ़र विंडो · $year';
  }

  @override
  String careerLastAgo(String when) {
    return 'आख़िरी बार $when पहले';
  }

  @override
  String get settingsFreeScopeTitle => 'एक मुफ़्त चार साल का चक्र';

  @override
  String get settingsFreeScopeBlurb =>
      'एक पूरा चक्र (क्वालिफ़ाइंग, आपकी महाद्वीपीय चैंपियनशिप और विश्व चैंपियनशिप) दो सेव पर, दुनिया का हर देश, कुछ भी रोका नहीं गया। अनंत चक्र और असीमित सेव एक ही भुगतान में मिलते हैं, बस एक बार, और इसमें हर आगामी अपडेट शामिल है।';

  @override
  String get settingsUnlockedTitle => 'अनलॉक';

  @override
  String get settingsUnlockedBlurb =>
      'अनंत चक्र, असीमित सेव और हर आगामी अपडेट। धन्यवाद।';

  @override
  String get settingsFromDeveloperTitle => 'डेवलपर की ओर से';

  @override
  String get settingsFromDeveloperBlurb =>
      'Football Nations Manager एक अकेले व्यक्ति ने बनाया है और लंबे समय तक इसे सपोर्ट मिलता रहेगा। इसमें कभी विज्ञापन या माइक्रोट्रांज़ैक्शन नहीं होंगे। गेम पसंद आए तो कृपया पूरा वर्ज़न ख़रीदने पर विचार करें। इसी से अपडेट आते रहते हैं।';

  @override
  String get settingsFromDeveloperThanksBlurb =>
      'Football Nations Manager एक अकेले व्यक्ति ने बनाया है और लंबे समय तक इसे सपोर्ट मिलता रहेगा। इसमें कभी विज्ञापन या माइक्रोट्रांज़ैक्शन नहीं होंगे। पूरा वर्ज़न ख़रीदने के लिए धन्यवाद। इसी से अपडेट आते रहते हैं।';

  @override
  String friendliesLikeYourCampaign(String rivals) {
    return 'नीचे चिह्नित: $rivals जैसी शैली वाली टीमें, जिनसे आपको अभी भिड़ना है।';
  }

  @override
  String get friendliesCloseToYou =>
      'नीचे चिह्नित: विश्व रैंकिंग में आपके सबसे क़रीब की टीमें। ड्रॉ होने के बाद ये निशान आपके ग्रुप के हिसाब से बदल जाते हैं।';

  @override
  String transfersMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ट्रांसफ़र',
      one: '1 ट्रांसफ़र',
    );
    return '$_temp0';
  }

  @override
  String hubRoundPage(int page, int pages) {
    return '$page / $pages';
  }

  @override
  String get transfersNewer => 'नए';

  @override
  String get transfersOlder => 'और';

  @override
  String get transfersPagePrevious => 'पिछला';

  @override
  String get transfersPageNext => 'अगला';

  @override
  String transfersPageOf(int page, int pages) {
    return 'पेज $page / $pages';
  }

  @override
  String get transfersMovedTo => 'इनके बीच ट्रांसफ़र:';

  @override
  String get transfersUnknownClub => 'अज्ञात क्लब';

  @override
  String yAgainstThemAgain0(String opponent, String count) {
    return '$opponent के ख़िलाफ़ यह $count बार हो गया। कोई स्कोर गिन रहा है, और वे वही हैं।';
  }

  @override
  String yAgainstThemAgain1(String opponent, String count) {
    return 'फिर $opponent। $count मुलाक़ातें, और हम अब भी उन्हें समझ नहीं पाए।';
  }

  @override
  String yAgainstThemAgain2(String opponent, String count) {
    return '$opponent के ख़िलाफ़ $count नंबर। अब यह संयोग नहीं रहा।';
  }

  @override
  String yAgainstThemAgain3(String opponent, String count) {
    return 'हम $opponent से $count बार खेल चुके हैं और किसी से कुछ नहीं सीखा।';
  }

  @override
  String yAgainstThemAgain4(String opponent, String count) {
    return '$opponent, $count बार। उन्हें पक्का पता है कि हम क्या करने वाले हैं।';
  }

  @override
  String yAgainstThemAgain5(String opponent, String count) {
    return '$opponent के पास हमारा जो भी तोड़ है, $count मुलाक़ातों बाद भी वही चल रहा है।';
  }

  @override
  String ySameOldStory0(String count) {
    return 'हाल में यह $count बार हो चुका है। कब तक यही हमारी पहचान रहेगी?';
  }

  @override
  String ySameOldStory1(String count) {
    return 'ऐसी $count दोपहरें हो गईं। यह पैटर्न है, क़िस्मत की कड़ी नहीं।';
  }

  @override
  String ySameOldStory2(String count) {
    return 'हाल में यही मैच हम $count बार देख चुके हैं। वही स्क्रिप्ट, वही अंत।';
  }

  @override
  String ySameOldStory3(String count) {
    return 'वही नब्बे मिनट अब $count संस्करणों में। कोई इसे ठीक नहीं कर रहा।';
  }

  @override
  String ySameOldStory4(String count) {
    return '$count बार। अब भी पैटर्न नहीं दिखता, तो आप देख ही नहीं रहे।';
  }

  @override
  String ySameOldStory5(String count) {
    return 'वही कहानी, $count बार। बहाने नतीजों से पहले ख़त्म हो गए।';
  }

  @override
  String get yToldYouSo0 =>
      'जब सब जश्न मना रहे थे, तभी मैंने कहा था कि यह आने वाला है।';

  @override
  String get yToldYouSo1 =>
      'दो अच्छे हफ़्ते और हम फिर सुनहरी पीढ़ी बन गए थे। और अब देखिए।';

  @override
  String get yToldYouSo2 =>
      'पिछले महीने जो मुझसे मज़े लेने को कह रहे थे, वे चुप हो गए हैं।';

  @override
  String get yToldYouSo3 =>
      'मुझे इसमें कोई ख़ुशी नहीं। बहुत कम ख़ुशी। थोड़ी सी।';

  @override
  String get yToldYouSo4 =>
      'यह कभी उतना अच्छा था ही नहीं जितना वे बता रहे थे, और यह उसका सबूत है।';

  @override
  String get yToldYouSo5 =>
      'हर बार। कहा जाता है कि इस बार अलग है, और हर बार नहीं होता।';

  @override
  String get tacticsSubOffAlready => 'पहले ही बाहर';

  @override
  String get tacticsSubInjured => 'चोटिल';

  @override
  String get tacticsSubSentOffMark => 'रेड कार्ड';

  @override
  String get tacticsSubNoneLeft => 'बदलाव नहीं बचे';

  @override
  String get tacticsUndoLastChange => 'आख़िरी बदलाव वापस लें';

  @override
  String get matchStrengthTitle => 'टीम को क्या चला रहा है';

  @override
  String get strengthFactorFamiliarity => 'जमा हुआ फ़ॉर्मेशन';

  @override
  String get strengthFactorFatigue => 'थकी टाँगें';

  @override
  String get strengthFactorClubForm => 'क्लब फ़ॉर्म';

  @override
  String get strengthFactorMorale => 'ड्रेसिंग रूम';

  @override
  String get strengthFactorCaptain => 'कप्तान';

  @override
  String get strengthFactorStaff => 'स्टाफ़ रूम';

  @override
  String get strengthFactorDossier => 'स्काउट का डॉसियर';

  @override
  String yDebut0(String name) {
    return '$name को पहला कैप मिला। नाम याद रखिए।';
  }

  @override
  String yDebut1(String name) {
    return '$name का डेब्यू। उनमें दिखता है, है ना?';
  }

  @override
  String yDebut2(String name) {
    return '$name, पहला कैप। देखते हैं वे इसका क्या करते हैं।';
  }

  @override
  String yDebut3(String name) {
    return '$name का डेब्यू। स्क्वॉड को कहीं तो ताज़ा टाँगें चाहिए थीं।';
  }

  @override
  String yDebut4(String name) {
    return '$name को कैप थमा दिया गया। हाल में हमने ऐसे बहुत बाँटे हैं।';
  }

  @override
  String yDebut5(String name) {
    return '$name का डेब्यू। एक और जिसे हम वसंत तक भूल जाएँगे।';
  }

  @override
  String yDrought0(String name, String count) {
    return '$name $count मैच से गोल नहीं कर पाए हैं, और मैदान पर बाक़ी सब कुछ कर रहे हैं।';
  }

  @override
  String yDrought1(String name, String count) {
    return '$name के लिए $count मैच बिना गोल के। ये तीन-तीन में आते हैं, हमेशा से।';
  }

  @override
  String yDrought2(String name, String count) {
    return '$name: $count मैच, कोई गोल नहीं।';
  }

  @override
  String yDrought3(String name, String count) {
    return '$name के लिए $count मैच बिना गोल। नज़र रखने लायक़ बात है।';
  }

  @override
  String yDrought4(String name, String count) {
    return '$count मैच। कोई गोल नहीं। $name से तो खलिहान का दरवाज़ा भी नहीं सधता।';
  }

  @override
  String yDrought5(String name, String count) {
    return '$name ने $count मैच में गोल नहीं किया। किसी और को भी खिला दो, कोई भी।';
  }

  @override
  String yRivalryLooms0(String opponent, String count) {
    return 'अगला $opponent। $count मुक़ाबले हो चुके, फिर भी इसका मतलब सब कुछ है।';
  }

  @override
  String yRivalryLooms1(String opponent, String count) {
    return 'अब $opponent के ख़िलाफ़ $count बार। आ जाओ।';
  }

  @override
  String yRivalryLooms2(String opponent, String count) {
    return 'अगला $opponent। $count बार खेले हैं।';
  }

  @override
  String yRivalryLooms3(String opponent, String count) {
    return 'इस हफ़्ते $opponent से $count नंबर की भिड़ंत।';
  }

  @override
  String yRivalryLooms4(String opponent, String count) {
    return 'फिर $opponent। ऐसे $count मैच हो गए और हमने कुछ नहीं सीखा।';
  }

  @override
  String yRivalryLooms5(String opponent, String count) {
    return '$opponent के ख़िलाफ़ $count मैच और वे अब भी हमें हराते हैं। वाह।';
  }

  @override
  String get positionGoalkeeper => 'गोलकीपर';

  @override
  String get positionLeftBack => 'लेफ़्ट बैक';

  @override
  String get positionCentreBack => 'सेंटर बैक';

  @override
  String get positionRightBack => 'राइट बैक';

  @override
  String get positionDefensiveMid => 'डिफ़ेंसिव मिड';

  @override
  String get positionCentralMid => 'सेंट्रल मिड';

  @override
  String get positionAttackingMid => 'अटैकिंग मिड';

  @override
  String get positionLeftMid => 'लेफ़्ट मिड';

  @override
  String get positionRightMid => 'राइट मिड';

  @override
  String get positionLeftWing => 'लेफ़्ट विंग';

  @override
  String get positionRightWing => 'राइट विंग';

  @override
  String get positionStriker => 'स्ट्राइकर';

  @override
  String get roleNone => 'कोई भूमिका नहीं';

  @override
  String get roleTargetMan => 'टारगेट मैन';

  @override
  String get rolePoacher => 'पोचर';

  @override
  String get rolePlaymaker => 'प्लेमेकर';

  @override
  String get roleBallWinner => 'बॉल विनर';

  @override
  String get roleInvertedWinger => 'इनवर्टेड विंगर';

  @override
  String get roleBallPlayingDefender => 'बॉल-प्लेइंग डिफ़ेंडर';

  @override
  String get roleNoneBlurb => 'अपना स्वाभाविक खेल खेलते हैं।';

  @override
  String get roleTargetManBlurb =>
      'हेडर जीतते हैं, गेंद आगे बढ़ाते हैं। असिस्ट और सेट पीस।';

  @override
  String get rolePoacherBlurb => 'बॉक्स में घात लगाते हैं। गोल कहीं ज़्यादा।';

  @override
  String get rolePlaymakerBlurb => 'मौक़े बनाते हैं। असिस्ट कहीं ज़्यादा।';

  @override
  String get roleBallWinnerBlurb => 'खेल तोड़ते हैं, फ़िनिश नहीं करते।';

  @override
  String get roleInvertedWingerBlurb => 'अंदर कटकर शॉट लगाते हैं। गोल ज़्यादा।';

  @override
  String get roleBallPlayingDefenderBlurb => 'पीछे से हमले शुरू करते हैं।';

  @override
  String get federationDeptYouth => 'यूथ एकेडमी';

  @override
  String get federationDeptCommercial => 'कमर्शियल / पीआर';

  @override
  String get federationDeptMedical => 'मेडिकल और स्पोर्ट्स साइंस';

  @override
  String get federationDeptNaturalisation => 'नागरिकता दफ़्तर';

  @override
  String get federationDeptBoardRelations => 'बोर्ड संबंध';

  @override
  String get federationDeptYouthBlurb =>
      'बेहतर एकेडमी प्रतिभाएँ अगले चक्र में आपके देश के लिए डेब्यू करती हैं।';

  @override
  String get federationDeptCommercialBlurb =>
      'स्पॉन्सरशिप चक्र के अंत में अतिरिक्त आमदनी लाती है।';

  @override
  String get federationDeptMedicalBlurb =>
      'चोटें कम। आपका स्क्वॉड पूरे चक्र उपलब्ध रहता है।';

  @override
  String get federationDeptNaturalisationBlurb =>
      'ज़्यादा विदेशी खिलाड़ी आपके देश के लिए खेलने की पेशकश करते हैं।';

  @override
  String get federationDeptBoardRelationsBlurb =>
      'बोर्ड आपके नतीजों को ज़्यादा धैर्य से परखता है।';

  @override
  String get federationBuildingAcademy => 'एकेडमी';

  @override
  String get federationBuildingCommercial => 'कमर्शियल मुख्यालय';

  @override
  String get federationBuildingMedical => 'मेडिकल सेंटर';

  @override
  String get federationBuildingScouting => 'स्काउटिंग ऑफ़िस';

  @override
  String get federationBuildingBoardroom => 'बोर्डरूम';

  @override
  String get moraleBuoyant => 'उत्साहित';

  @override
  String get moralePositive => 'सकारात्मक';

  @override
  String get moraleSettled => 'स्थिर';

  @override
  String get moraleUneasy => 'बेचैन';

  @override
  String get moraleRockBottom => 'सबसे निचले स्तर पर';

  @override
  String get matchTabTimeline => 'टाइमलाइन';

  @override
  String get matchTabStats => 'आँकड़े';

  @override
  String get matchTabLineups => 'लाइनअप';

  @override
  String get matchPenalty => 'पेनल्टी';

  @override
  String get matchStateLevel => 'बराबरी पर';

  @override
  String matchStateLead(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'आप $count गोल से आगे हैं',
      one: 'आप एक गोल से आगे हैं',
    );
    return '$_temp0';
  }

  @override
  String matchStateTrail(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'आप $count गोल से पीछे हैं',
      one: 'आप एक गोल से पीछे हैं',
    );
    return '$_temp0';
  }

  @override
  String matchPossessionShare(int possession) {
    return '$possession% पज़ेशन';
  }

  @override
  String get boardVerdictSackedTitle => 'बोर्ड ने आपको बर्ख़ास्त कर दिया';

  @override
  String boardVerdictSackedBody(int rating) {
    return 'निराशाजनक चक्र (रेटिंग $rating%)। आपका कार्यकाल यहीं ख़त्म होता है। अब सिर्फ़ छोटे देश ही आप पर दांव लगाएँगे।';
  }

  @override
  String get boardVerdictDelightedTitle => 'बोर्ड बेहद ख़ुश है';

  @override
  String boardVerdictDelightedBody(int rating, String best) {
    return 'शानदार चक्र (रेटिंग $rating%), $best के बाद। बड़े देश दिलचस्पी ले रहे हैं, या आप यहीं रहकर टीम खड़ी कर सकते हैं।';
  }

  @override
  String get boardVerdictSolidTitle => 'एक ठोस चक्र';

  @override
  String boardVerdictSolidBody(int rating) {
    return 'बोर्ड संतुष्ट है (रेटिंग $rating%)। मिलते-जुलते कद के कुछ देश आपको लेना चाहेंगे, पर बदलने का कोई दबाव नहीं है।';
  }

  @override
  String get boardVerdictExpectedMoreTitle => 'बोर्ड को और उम्मीद थी';

  @override
  String boardVerdictExpectedMoreBody(int rating) {
    return 'निराशाजनक चक्र (रेटिंग $rating%)। आपकी नौकरी बनी रहती है, पर कोई भी ऑफ़र एक क़दम नीचे का होगा।';
  }

  @override
  String get boardVerdictPressureTitle => 'आप पर असली दबाव है';

  @override
  String boardVerdictPressureBody(int rating) {
    return 'ख़राब चक्र (रेटिंग $rating%)। आप बच गए, पर नई शुरुआत करनी हो तो सिर्फ़ कमज़ोर देश ही दिलचस्पी लेंगे।';
  }

  @override
  String get boardVerdictHeroTitle => 'देश आपके साथ खड़ा है';

  @override
  String boardVerdictHeroNote(String nation, int cycles) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles चक्रों',
      one: '$cycles चक्र',
    );
    return ' $nation आपको चाहता है, $_temp0 के बाद आप राष्ट्रीय नायक हैं। जब तक आप चाहें, आपकी नौकरी सुरक्षित है।';
  }

  @override
  String get boardVerdictTheNation => 'देश';

  @override
  String get boardVerdictBestQuiet => 'एक शांत चक्र';

  @override
  String get boardVerdictBestCycle => 'इस चक्र';

  @override
  String boardVerdictBestWorld(String placement) {
    return 'विश्व चैंपियनशिप: $placement';
  }

  @override
  String get finishThirdPlace => 'तीसरा स्थान';

  @override
  String get finishFourthPlace => 'चौथा स्थान';

  @override
  String get finishDidNotQualify => 'क्वालिफ़ाई नहीं कर सके';

  @override
  String get careerRepIconic => 'प्रतिष्ठित';

  @override
  String get careerRepRenowned => 'मशहूर';

  @override
  String get careerRepEstablished => 'स्थापित';

  @override
  String get careerRepRising => 'उभरता हुआ';

  @override
  String get careerRepUnproven => 'अप्रमाणित';

  @override
  String get hubOfferStepUp => 'ऊपर की ओर क़दम';

  @override
  String get hubOfferLateral => 'समान स्तर का बदलाव';

  @override
  String get hubOfferRebuild => 'नए सिरे से निर्माण';

  @override
  String careerNationsCupWon(String league) {
    return 'लीग $league · चैंपियन';
  }

  @override
  String careerNationsCupRunnerUp(String league) {
    return 'लीग $league · उपविजेता';
  }

  @override
  String careerNationsCupSemi(String league) {
    return 'लीग $league · सेमीफ़ाइनलिस्ट';
  }

  @override
  String careerNationsCupPlaced(String league, int position) {
    return 'लीग $league · #$position';
  }

  @override
  String tourRunInto(String round) {
    return '$round में प्रवेश';
  }

  @override
  String get tourRunIntoThirdPlace => 'तीसरे स्थान के प्ले-ऑफ़ में';

  @override
  String tourRunThrough(String round) {
    return '$round से आगे बढ़े';
  }

  @override
  String tourRunOut(String round) {
    return '$round में बाहर';
  }

  @override
  String get tourRunInGroup => 'ग्रुप चरण में मुक़ाबला जारी';

  @override
  String get tourRunGroupOut => 'ग्रुप चरण में बाहर';

  @override
  String resultsCycleTitle(int year, String nation) {
    return '$year चक्र · $nation';
  }

  @override
  String resultsCycleRecord(int played, int won, int drawn, int lost) {
    return '$played खेले  ·  ${won}W ${drawn}D ${lost}L';
  }

  @override
  String resultsCycleFinish(String finish) {
    return 'विश्व चैंपियनशिप: $finish';
  }

  @override
  String get resultsCycleUnderway => 'अभी जारी है';

  @override
  String yTurnedItRound0(String opponent) {
    return 'हाफ़ टाइम पर $opponent से दो गोल पीछे थे और सब कुछ वापस ले आए। इसे कहते हैं टीम।';
  }

  @override
  String yTurnedItRound1(String opponent) {
    return '$opponent के सामने दो गोल पीछे, और अंत तक फ़र्क़ ही नहीं पड़ा। ऐसा कम ही टीमें कर पाती हैं।';
  }

  @override
  String yTurnedItRound2(String opponent) {
    return 'हाफ़ टाइम: $opponent से दो गोल पीछे। फ़ुल टाइम: अब नहीं। दूसरा हाफ़ बिल्कुल अलग मैच था।';
  }

  @override
  String yTurnedItRound3(String opponent) {
    return '$opponent के ख़िलाफ़ दो गोल से पिछड़कर वापसी की। ब्रेक में जो भी कहा गया, हर हफ़्ते वही कहिए।';
  }

  @override
  String yTurnedItRound4(String opponent) {
    return 'ठीक है, $opponent के ख़िलाफ़ वापसी हो गई। अब कोई शुरुआती पैंतालीस मिनट समझाए।';
  }

  @override
  String yTurnedItRound5(String opponent) {
    return '$opponent से दो गोल पीछे और हमसे ख़ुश होने की उम्मीद है। पहला हाफ़ सुधारिए।';
  }

  @override
  String yThrewItAway0(String opponent) {
    return 'हाफ़ टाइम पर $opponent पर दो गोल की बढ़त थी और हाथ से निकल गई। बड़ी टीमों के साथ भी होता है।';
  }

  @override
  String yThrewItAway1(String opponent) {
    return '$opponent पर दो गोल की बढ़त और फिर बाज़ी पलट गई। चक्र लंबा है, वक़्त बहुत है।';
  }

  @override
  String yThrewItAway2(String opponent) {
    return 'हाफ़ टाइम: $opponent पर दो गोल की बढ़त। फ़ुल टाइम: कुछ भी नहीं।';
  }

  @override
  String yThrewItAway3(String opponent) {
    return '$opponent के ख़िलाफ़ दो गोल की बढ़त, पैंतालीस मिनट में ग़ायब।';
  }

  @override
  String yThrewItAway4(String opponent) {
    return 'दो गोल आगे थे और गँवा दिया। वो भी $opponent से। किसी को जवाब देना होगा।';
  }

  @override
  String yThrewItAway5(String opponent) {
    return '$opponent के ख़िलाफ़ दो गोल आगे और हमने यह कर दिखाया। हर बार यही होता है।';
  }

  @override
  String get cycleBackupDone =>
      'करियर का बैकअप इस फ़ोन के FNM फ़ोल्डर में सेव हो गया। ऐप अनइंस्टॉल करने पर यह हट जाएगा: कॉपी कहीं और रखने के लिए सेव स्क्रीन पर \"इस सेव का बैकअप लें\" का इस्तेमाल करें।';

  @override
  String get cycleBackupFailed => 'इस बार करियर का बैकअप नहीं हो सका।';

  @override
  String pressMomentBigWinWarm1(String opponent) {
    return '$opponent के ख़िलाफ़ यादगार रात। इस ग्रुप पर आपको कितना गर्व है?';
  }

  @override
  String pressMomentBigWinWarm2(String opponent) {
    return '$opponent आपके सामने टिक नहीं पाई। क्या यही वह टीम है जिस पर आपको हमेशा भरोसा था?';
  }

  @override
  String pressMomentBigWinNeutral1(String opponent) {
    return '$opponent पर बड़ी जीत। आज रात फ़र्क़ किस चीज़ ने डाला?';
  }

  @override
  String pressMomentBigWinNeutral2(String opponent) {
    return '$opponent को आराम से हराया। आपने मैच कहाँ जीता?';
  }

  @override
  String pressMomentBigWinHostile1(String opponent) {
    return '$opponent पर अच्छी जीत। एक अच्छी रात है: कोई क्यों मान ले कि यह टिकेगी?';
  }

  @override
  String pressMomentBigWinHostile2(String opponent) {
    return '$opponent के ख़िलाफ़ शानदार नतीजा। यह आपकी योजना थी, या खिलाड़ियों ने ख़ुद सँभाल लिया?';
  }

  @override
  String pressMomentBigLossWarm1(String opponent) {
    return '$opponent के ख़िलाफ़ मुश्किल रात। ऐसी रात के बाद आप खिलाड़ियों से क्या कहते हैं?';
  }

  @override
  String pressMomentBigLossWarm2(String opponent) {
    return '$opponent के ख़िलाफ़ किसी ने ऐसा नहीं सोचा था। क्या बस एक बुरी रात थी?';
  }

  @override
  String pressMomentBigLossNeutral1(String opponent) {
    return '$opponent के ख़िलाफ़ सबक़ सिखाने वाली रात रही। क्या ग़लत हुआ?';
  }

  @override
  String pressMomentBigLossNeutral2(String opponent) {
    return '$opponent ने आपकी टीम को बिखेर दिया। क्या यह स्क्वॉड काफ़ी अच्छा है?';
  }

  @override
  String pressMomentBigLossHostile1(String opponent) {
    return '$opponent के ख़िलाफ़ आप हर मोर्चे पर पीछे थे। हालात इतने बिगड़ कैसे गए?';
  }

  @override
  String pressMomentBigLossHostile2(String opponent) {
    return '$opponent ने जब चाहा गोल किया। आज रात योजना कहाँ थी?';
  }

  @override
  String pressMomentCrisisWarm1(String opponent) {
    return 'एक और मैच हाथ से गया, इस बार $opponent के ख़िलाफ़। इस दौर को कैसे पलटेंगे?';
  }

  @override
  String pressMomentCrisisWarm2(String opponent) {
    return 'नतीजे सूख गए हैं, और $opponent ने हालत और बिगाड़ दी। क्या आप अब भी इस ग्रुप पर भरोसा करते हैं?';
  }

  @override
  String pressMomentCrisisNeutral1(String opponent) {
    return 'फिर कोई जीत नहीं, इस बार $opponent के ख़िलाफ़, और बोर्ड नज़र रखे है। क्या आपकी नौकरी सुरक्षित है?';
  }

  @override
  String pressMomentCrisisNeutral2(String opponent) {
    return '$opponent के बाद यह सिलसिला लंबा होता जा रहा है। क्या आपको अपने भविष्य की चिंता है?';
  }

  @override
  String pressMomentCrisisHostile1(String opponent) {
    return 'अब $opponent भी। ऐसे ही दौर में आपके पूर्ववर्ती को हटाया गया था। आप क्यों बचेंगे?';
  }

  @override
  String pressMomentCrisisHostile2(String opponent) {
    return '$opponent जैसी एक और रात के बाद हर फ़ोन-इन आपको हटाना चाहता है। बोर्ड कहे तो क्या आप पद छोड़ देंगे?';
  }

  @override
  String pressMomentJobVerdictWarm1(String opponent) {
    return 'आपने अपनी नौकरी दाँव पर लगाई थी, और $opponent के बाद बात बनी नहीं। आप कैसे हैं?';
  }

  @override
  String pressMomentJobVerdictWarm2(String opponent) {
    return 'तीन मैच पूरे हुए, आख़िरी $opponent के ख़िलाफ़। कसौटी आपने ख़ुद तय की थी। फ़ैसले को आप कैसे देखते हैं?';
  }

  @override
  String pressMomentJobVerdictNeutral1(String opponent) {
    return 'आपने कहा था अगले तीन मैचों पर परखिए। $opponent के बाद हमने परख लिया। क्या नौकरी अब भी आपकी है?';
  }

  @override
  String pressMomentJobVerdictNeutral2(String opponent) {
    return 'तीन मैच, आख़िरी $opponent के ख़िलाफ़, और आपके वादे जैसा कुछ नहीं हुआ। क्या आपने अपने भविष्य पर बोर्ड से बात की है?';
  }

  @override
  String pressMomentJobVerdictHostile1(String opponent) {
    return 'कसौटी आपने ख़ुद तय की और $opponent के ख़िलाफ़ उसमें नाकाम रहे। क्या आप इस्तीफ़ा देंगे?';
  }

  @override
  String pressMomentJobVerdictHostile2(String opponent) {
    return 'शब्द आपके हैं, हमारे नहीं: अगले तीन पर परखिए। $opponent के बाद आप अब भी वहाँ क्यों बैठे हैं?';
  }

  @override
  String get pressBeatWhoToBlameWarm1 => 'आप उनसे और चाहते हैं। कोई ख़ास नाम?';

  @override
  String get pressBeatWhoToBlameWarm2 =>
      'आपने पैमाना ऊँचा रखा है। सबसे पहले किसे आगे आना होगा?';

  @override
  String get pressBeatWhoToBlameNeutral1 =>
      'आप कहते हैं कुछ खिलाड़ियों को अपने भीतर झाँकना होगा। किसकी बात कर रहे हैं?';

  @override
  String get pressBeatWhoToBlameNeutral2 =>
      'आप कहते हैं काफ़ी अच्छा नहीं था। किसके बारे में बोल रहे हैं?';

  @override
  String get pressBeatWhoToBlameHostile1 =>
      'आप बात गोलमोल रखते हैं। क्या नाम लेंगे, या ज़िम्मेदारी लौटकर आप पर आएगी?';

  @override
  String get pressBeatWhoToBlameHostile2 =>
      'हर हफ़्ते किसी और की ग़लती होती है। इस बार किसकी है?';

  @override
  String get pressBeatIfYouDontWarm1 =>
      'दमदार बातें। और अगर अगला मैच आपके हक़ में न गया?';

  @override
  String get pressBeatIfYouDontWarm2 =>
      'पूरा देश आपको इस बात पर परखेगा। अगर यह न हो पाया तो?';

  @override
  String get pressBeatIfYouDontNeutral1 => 'और अगर आप न जीते? तब क्या?';

  @override
  String get pressBeatIfYouDontNeutral2 =>
      'अब आपने कह दिया है। ग़लत निकले तो क्या होगा?';

  @override
  String get pressBeatIfYouDontHostile1 =>
      'इस कमरे में वादे पहले भी सुने हैं। यह भी टूटा तो आप समर्थकों के कितने देनदार होंगे?';

  @override
  String get pressBeatIfYouDontHostile2 =>
      'और जब ऐसा नहीं होगा, तब बहाना क्या होगा?';

  @override
  String get pressBeatFollowUpWarm1 =>
      'एक सवाल और, अगर हिम्मत बची हो। इस ग्रुप को अब भी किस पर काम करना है?';

  @override
  String get pressBeatFollowUpWarm2 =>
      'जब सब थम जाए, तो आज रात से अगले मैच के लिए आप क्या लेकर जाएँगे?';

  @override
  String get pressBeatFollowUpNeutral1 =>
      'थोड़ा गहराई में चलें। अगले मैच से पहले क्या सुधरना ज़रूरी है?';

  @override
  String get pressBeatFollowUpNeutral2 =>
      'स्कोरलाइन से परे: क्या यह स्क्वॉड वहाँ है जहाँ आप इसे चाहते हैं?';

  @override
  String get pressBeatFollowUpHostile1 =>
      'बातें बहुत, कहा कम। अब से असल में क्या बदलता है?';

  @override
  String get pressBeatFollowUpHostile2 =>
      'समर्थक सीधा जवाब चाहते हैं। क्या यह टीम काफ़ी अच्छी है, हाँ या नहीं?';

  @override
  String pressBeatStandoutWarm1(String player) {
    return '$player आज रात शानदार रहा। वह कितना आगे जा सकता है?';
  }

  @override
  String pressBeatStandoutWarm2(String player) {
    return '$player आज हर सुर्ख़ी में है। क्या आपने यह सोचा था?';
  }

  @override
  String pressBeatStandoutNeutral1(String player) {
    return '$player अलग दिखा। आज रात आपने उससे क्या करने को कहा था?';
  }

  @override
  String pressBeatStandoutNeutral2(String player) {
    return 'क्या $player ही आज फ़र्क़ था?';
  }

  @override
  String pressBeatStandoutHostile1(String player) {
    return '$player के बिना कहानी अलग होती। यह टीम है, या एक खिलाड़ी?';
  }

  @override
  String pressBeatStandoutHostile2(String player) {
    return '$player शानदार था। श्रेय आपका है, या उसका?';
  }

  @override
  String pressBeatStrugglerWarm1(String player) {
    return '$player के लिए रात मुश्किल रही। क्या वह चोट लेकर खेल रहा है?';
  }

  @override
  String pressBeatStrugglerWarm2(String player) {
    return '$player की रात अच्छी नहीं रही। क्या आप उसे हौसला देंगे?';
  }

  @override
  String pressBeatStrugglerNeutral1(String player) {
    return '$player आज जूझता दिखा। क्या उसकी जगह बनी रहेगी?';
  }

  @override
  String pressBeatStrugglerNeutral2(String player) {
    return '$player रफ़्तार से पीछे दिखा। उसके खेल के बारे में आप क्या सोचते हैं?';
  }

  @override
  String pressBeatStrugglerHostile1(String player) {
    return '$player फिर बोझ बना रहा। आप उसे बार-बार क्यों चुनते हैं?';
  }

  @override
  String pressBeatStrugglerHostile2(String player) {
    return 'सबको दिख रहा था कि $player लय में नहीं है। बेंच को छोड़कर?';
  }

  @override
  String get pressThrowbackWinNextKeptWarm =>
      'आपने कहा था अगला मैच जीतेंगे, और जीते। सही साबित होना कैसा लग रहा है?';

  @override
  String get pressThrowbackWinNextKeptNeutral =>
      'आपने अगले मैच में जीत का वादा किया और निभाया। आत्मविश्वास था, या शेखी?';

  @override
  String get pressThrowbackWinNextKeptHostile =>
      'आपने कहा था अगला जीतेंगे, और जीते। क़िस्मत थी, या अब हमें सुनना शुरू करना चाहिए?';

  @override
  String get pressThrowbackWinNextBrokenWarm =>
      'आपने कहा था वह मैच जीतेंगे। ऐसा नहीं हुआ। क्या ग़लत गया?';

  @override
  String get pressThrowbackWinNextBrokenNeutral =>
      'आपने कहा था अगला जीतेंगे। नहीं जीते। अगले वादे पर हम क्यों भरोसा करें?';

  @override
  String get pressThrowbackWinNextBrokenHostile =>
      'आपने कहा था अगला जीतेंगे। नहीं जीते। क्या इस कमरे में आपके शब्दों का अब कोई मतलब है?';

  @override
  String get pressThrowbackJobKeptWarm =>
      'आपने तीन मैचों पर परखे जाने को कहा, और आप खरे उतरे। क्या यह आपकी जीत है?';

  @override
  String get pressThrowbackJobKeptNeutral =>
      'आपने कहा था अगले तीन पर परखिए। हमने परखा, और नतीजे आए। इस कसौटी से आपने क्या सीखा?';

  @override
  String get pressThrowbackJobKeptHostile =>
      'आपने ख़ुद को तीन मैच दिए और पार भी हो गए। क्या कसौटी कभी इतनी कठिन थी?';

  @override
  String get pressThrowbackJobBrokenWarm =>
      'आपने तीन मैचों पर परखे जाने को कहा था। बात बनी नहीं। आपने क्या सीखा?';

  @override
  String get pressThrowbackJobBrokenNeutral =>
      'आपने कहा था अगले तीन पर परखिए। तीन मैच गए, और शक का फ़ायदा भी गया। अब क्या?';

  @override
  String get pressThrowbackJobBrokenHostile =>
      'कसौटी आपने तय की और उसमें नाकाम रहे। अब कोई आपकी बात पर क्यों भरोसा करे?';

  @override
  String pressThrowbackBackKeptWarm(String player) {
    return 'जब बाक़ी तैयार नहीं थे, तब आपने $player का साथ दिया। उसने कर दिखाया। क्या कुछ श्रेय आपका है?';
  }

  @override
  String pressThrowbackBackKeptNeutral(String player) {
    return 'आपने $player का साथ दिया। उसने कर दिखाया। यह भरोसा था, या जानकारी?';
  }

  @override
  String pressThrowbackBackKeptHostile(String player) {
    return 'आपने $player का साथ दिया, और इस बार फल मिला। क्या अगली बार भी आप इतने ही आश्वस्त होंगे?';
  }

  @override
  String pressThrowbackBackBrokenWarm(String player) {
    return 'आप $player के साथ खड़े रहे, और बात बनी नहीं। क्या आप अब भी उस पर भरोसा करते हैं?';
  }

  @override
  String pressThrowbackBackBrokenNeutral(String player) {
    return 'आपने $player का साथ दिया। उसने कर्ज़ नहीं चुकाया। क्या वह ग़लती थी?';
  }

  @override
  String pressThrowbackBackBrokenHostile(String player) {
    return 'आपकी परख या आपकी वफ़ादारी: $player के मामले में कौन चूका?';
  }

  @override
  String pressThrowbackBlameKeptWarm(String player) {
    return 'आप $player पर सख़्त थे, और बाद के मैचों ने आपको सही साबित किया। इसमें कोई संतोष है?';
  }

  @override
  String pressThrowbackBlameKeptNeutral(String player) {
    return 'आपने $player को खुलकर टोका, और उसने जवाब नहीं दिया। क्या उसके लिए वापसी का रास्ता है?';
  }

  @override
  String pressThrowbackBlameKeptHostile(String player) {
    return 'आपने $player को अकेला छोड़ दिया और वह उबर नहीं पाया। क्या आपने उसे तोड़ दिया?';
  }

  @override
  String pressThrowbackBlameBrokenWarm(String player) {
    return 'आपने $player को टोका, और उसने मैदान पर जवाब दिया। क्या शुरू से यही मक़सद था?';
  }

  @override
  String pressThrowbackBlameBrokenNeutral(String player) {
    return 'आपने $player को दोष दिया, और तब से वह आपके सबसे अच्छे खिलाड़ियों में है। क्या उससे माफ़ी बनती है?';
  }

  @override
  String pressThrowbackBlameBrokenHostile(String player) {
    return 'आपने $player को बलि का बकरा बनाया, और तब से वही आपका सबसे अच्छा खिलाड़ी है। क्या आप माफ़ी माँगेंगे?';
  }

  @override
  String get pressReplyCreditPlayers1 =>
      'इन खिलाड़ियों ने मुझे अपना सब कुछ दिया। मैं इनमें से किसी एक को भी नहीं बदलूँगा।';

  @override
  String get pressReplyCreditPlayers2 =>
      'इस ग्रुप से ज़्यादा मेहनत कोई नहीं करता। मैं दिन भर इनका बचाव करूँगा।';

  @override
  String get pressReplyCreditPlayers3 =>
      'इस कुर्सी से आप मेरे खिलाड़ियों के ख़िलाफ़ एक शब्द नहीं सुनेंगे।';

  @override
  String get pressReplyCreditPlayers4 =>
      'श्रेय खिलाड़ियों का है, मेरा नहीं। उनके बारे में लिखिए।';

  @override
  String get pressReplyTakeResponsibility1 =>
      'वह मेरी ज़िम्मेदारी है। टीम मैंने चुनी थी और मैंने ही तैयार की थी।';

  @override
  String get pressReplyTakeResponsibility2 =>
      'मुझे परखिए, उन्हें नहीं। यह मेरी टीम है और मेरी ज़िम्मेदारी।';

  @override
  String get pressReplyTakeResponsibility3 =>
      'अगर आपको किसी को दोष देना है, तो मैं यहीं बैठा हूँ।';

  @override
  String get pressReplyTakeResponsibility4 =>
      'ज़िम्मेदारी मेरी है। खिलाड़ियों को इससे दूर रखिए।';

  @override
  String get pressReplyDemandMore1 =>
      'मुझे और चाहिए। उनमें से कुछ ठीक-ठीक जानते हैं कि मेरा मतलब क्या है।';

  @override
  String get pressReplyDemandMore2 =>
      'इस स्तर पर मेहनत काफ़ी नहीं है। मुझे और चाहिए, और मैंने उन्हें बता दिया है।';

  @override
  String get pressReplyDemandMore3 =>
      'मैं उनमें से हर एक से और की उम्मीद रखता हूँ, कल से ही।';

  @override
  String get pressReplyDemandMore4 =>
      'कुछ खिलाड़ियों को अपने भीतर झाँकना होगा। मैं संतुष्ट नहीं हूँ।';

  @override
  String get pressReplyPromiseWinNext1 =>
      'हम अगला मैच जीतेंगे। आप इसे लिख लीजिए।';

  @override
  String get pressReplyPromiseWinNext2 =>
      'मेरी बात याद रखिए: हम अगला मैच जीतते हैं।';

  @override
  String get pressReplyPromiseWinNext3 =>
      'अगला मैच, हम जीतेंगे। मैं यह यहाँ इसलिए कह रहा हूँ कि आप मुझे इस पर परख सकें।';

  @override
  String get pressReplyPromiseWinNext4 =>
      'मुझे इस टीम पर पूरा यक़ीन है। हम अगला मैच जीतेंगे।';

  @override
  String get pressReplyJobOnTheLine1 =>
      'अगले तीन मैचों पर मुझे परखिए। यह उचित है।';

  @override
  String get pressReplyJobOnTheLine2 =>
      'मुझे तीन मैच दीजिए। तब तक बात न बने, तो उसी पर परखिए।';

  @override
  String get pressReplyJobOnTheLine3 =>
      'अगले तीन तय करेंगे कि मैं सही आदमी हूँ या नहीं। मुझे इस पर परखिए।';

  @override
  String get pressReplyJobOnTheLine4 =>
      'तीन मैच। उसके बाद मेरे बारे में जो चाहें लिखिए।';

  @override
  String get pressReplyDeflect1 =>
      'हम एक-एक मैच करके चल रहे हैं। इससे ज़्यादा कुछ कहना नहीं।';

  @override
  String get pressReplyDeflect2 =>
      'आज मैं आपके लिए सुर्ख़ियाँ नहीं बनाने वाला।';

  @override
  String get pressReplyDeflect3 =>
      'अगला मैच। मैं बस उसी के बारे में सोच रहा हूँ।';

  @override
  String get pressReplyDeflect4 =>
      'मैं क्या सोचता हूँ, वह ड्रेसिंग रूम में ही रहेगा।';

  @override
  String get pressReplyTakeCredit1 =>
      'मैंने यह इसलिए कहा क्योंकि मुझे यक़ीन था, और मैं सही था।';

  @override
  String get pressReplyTakeCredit2 =>
      'मैंने सही पढ़ा था। मैं यहाँ इसी काम के लिए हूँ।';

  @override
  String get pressReplyTakeCredit3 =>
      'इसे परख कहिए। मुझे पता था मैं क्या कह रहा हूँ।';

  @override
  String get pressReplyTakeCredit4 =>
      'फ़ैसला मेरा था और सही निकला। इसका श्रेय मैं लूँगा।';

  @override
  String get pressReplyStandByIt1 =>
      'मैंने वही कहा जिस पर मुझे यक़ीन था। मैं उस पर क़ायम हूँ।';

  @override
  String get pressReplyStandByIt2 => 'मैं उसका एक शब्द भी वापस नहीं लेता।';

  @override
  String get pressReplyStandByIt3 =>
      'जवाब वही है जो तब था। मैंने दिल से कहा था, और अब भी वही मानता हूँ।';

  @override
  String get pressReplyStandByIt4 => 'मैं कल भी यही कहूँगा।';

  @override
  String get pressReplyAdmitMistake1 =>
      'वह मुझसे ग़लत हो गया। मैं इसे मानता हूँ।';

  @override
  String get pressReplyAdmitMistake2 =>
      'ठीक है, मैंने ग़लत आँका। मैं इससे सीखूँगा।';

  @override
  String get pressReplyAdmitMistake3 =>
      'मैं ग़लत था, और यह कहने में मुझे कोई हिचक नहीं।';

  @override
  String get pressReplyAdmitMistake4 =>
      'वह फ़ैसला काम नहीं आया, और वह मेरा था।';

  @override
  String pressReplyBackPlayer1(String player) {
    return '$player को मेरा पूरा समर्थन है। वह फ़ॉर्म में लौटेगा।';
  }

  @override
  String pressReplyBackPlayer2(String player) {
    return 'मुझे $player पर भरोसा है, और वह आपको दिखाएगा कि क्यों।';
  }

  @override
  String pressReplyBackPlayer3(String player) {
    return '$player के ख़िलाफ़ मुझसे एक शब्द नहीं सुनेंगे। वह कर दिखाएगा।';
  }

  @override
  String pressReplyBackPlayer4(String player) {
    return '$player मेरी योजनाओं में बना रहेगा। देखिए वह आगे क्या करता है।';
  }

  @override
  String pressReplyBlamePlayer1(String player) {
    return '$player ने आज रात हमें निराश किया, और वह यह जानता है।';
  }

  @override
  String pressReplyBlamePlayer2(String player) {
    return 'मुझे $player से कहीं ज़्यादा की उम्मीद थी। उसे इसका जवाब देना होगा।';
  }

  @override
  String pressReplyBlamePlayer3(String player) {
    return '$player अपने स्तर पर नहीं था। मैं यह खुलकर कहूँगा।';
  }

  @override
  String pressReplyBlamePlayer4(String player) {
    return '$player का प्रदर्शन काफ़ी अच्छा नहीं था, और यह बात वह मुझसे सुनेगा।';
  }

  @override
  String get pressOnRecordWinNext => 'रिकॉर्ड पर: आप अगला मैच जीतेंगे।';

  @override
  String get pressOnRecordJob => 'रिकॉर्ड पर: अगले तीन मैचों पर आपको परखा जाए।';

  @override
  String pressOnRecordBack(String player) {
    return 'रिकॉर्ड पर: $player का समर्थन।';
  }

  @override
  String pressOnRecordBlame(String player) {
    return 'रिकॉर्ड पर: $player ने आपको निराश किया।';
  }

  @override
  String yStatementKept0(String nation) {
    return 'उन्होंने कहा, और वही हुआ। $nation के पास ऐसा कोच है जो जो कहता है, वही करता है।';
  }

  @override
  String yStatementKept1(String nation) {
    return 'खुलकर कहा, फिर कर दिखाया। $nation को ऐसे ही इंसान की ज़रूरत थी।';
  }

  @override
  String yStatementKept2(String nation) {
    return '$nation: उन्होंने जो कहा, सच निकला। मानना पड़ेगा।';
  }

  @override
  String yStatementKept3(String nation) {
    return 'उन्होंने बात रिकॉर्ड पर रखी और वह टिकी। एक अंक उनके नाम। $nation आगे बढ़ता है।';
  }

  @override
  String yStatementKept4(String nation) {
    return 'एक बार सही निकले। $nation, इसकी आदत मत डालना।';
  }

  @override
  String yStatementKept5(String nation) {
    return 'बंद घड़ी भी दिन में दो बार सही होती है। इस बार $nation की क़िस्मत चल गई।';
  }

  @override
  String yStatementBroken0(String nation) {
    return 'उन्होंने कहा और बात बनी नहीं। फिर भी उनके साथ हैं। $nation फिर कोशिश करेगा।';
  }

  @override
  String yStatementBroken1(String nation) {
    return '$nation: वादा जितना किया, मिला उससे कम। फिर भी मैं ऐसा कोच चाहूँगा जो ख़ुद पर भरोसा रखे।';
  }

  @override
  String yStatementBroken2(String nation) {
    return '$nation: उन्होंने रिकॉर्ड पर कहा और हुआ नहीं। लोग याद रखेंगे।';
  }

  @override
  String yStatementBroken3(String nation) {
    return 'बड़ी बातें, पीछे कुछ नहीं। $nation: अगली बार कम बोलिए।';
  }

  @override
  String yStatementBroken4(String nation) {
    return 'उन्होंने वहाँ खड़े होकर हमें बताया। और फिर यह। $nation को बातों से बेहतर मिलना चाहिए।';
  }

  @override
  String yStatementBroken5(String nation) {
    return 'अब उनकी बात का कोई मोल नहीं। लिख लो, $nation।';
  }

  @override
  String get ncZoneNorth => 'उत्तरी ज़ोन';

  @override
  String get ncZoneWest => 'पश्चिमी ज़ोन';

  @override
  String get ncZoneEast => 'पूर्वी ज़ोन';

  @override
  String get ncZoneCentralSouthern => 'मध्य और दक्षिणी ज़ोन';

  @override
  String careerNationsCupZoneWon(String zone) {
    return '$zone · चैंपियन';
  }

  @override
  String careerNationsCupZoneRunnerUp(String zone) {
    return '$zone · उपविजेता';
  }

  @override
  String careerNationsCupZoneSemi(String zone) {
    return '$zone · सेमीफ़ाइनलिस्ट';
  }

  @override
  String careerNationsCupZoneRoundOf16(String zone) {
    return '$zone · राउंड ऑफ़ 16';
  }

  @override
  String careerNationsCupZoneQuarter(String zone) {
    return '$zone · क्वार्टरफ़ाइनलिस्ट';
  }

  @override
  String careerNationsCupZonePlaced(String zone, int position) {
    return '$zone · #$position';
  }

  @override
  String get objectiveNcFinalsEight => 'क्वार्टरफ़ाइनल तक पहुँचें';

  @override
  String get objectiveNcZoneWinGroup => 'अपना ग्रुप जीतें';

  @override
  String get finishNcFinalsEight => 'क्वार्टरफ़ाइनल';

  @override
  String get finishNcBottomHalf => 'ग्रुप की निचली आधी में';

  @override
  String get tourContTabZones => 'ज़ोन';

  @override
  String get tourContTabFinalsEight => 'नॉकआउट';

  @override
  String get tourContFinalsEightSoon =>
      'नॉकआउट नवंबर में राउंड ऑफ़ 16 से शुरू होंगे: सभी 14 ग्रुप विजेता और 2 सर्वश्रेष्ठ उपविजेता।';

  @override
  String get tourContQuarterFinals => 'क्वार्टरफ़ाइनल';

  @override
  String get tourContZoneAdvancement =>
      'हर ग्रुप विजेता राउंड ऑफ़ 16 में पहुँचता है, साथ में 2 सर्वश्रेष्ठ उपविजेता। किसी की रेलीगेशन नहीं होगी।';

  @override
  String tourContZoneHeadingYours(String zone) {
    return '$zone ★';
  }

  @override
  String get compNorthAmericaNationsCup => 'नॉर्थ अमेरिका नेशंस कप';

  @override
  String get compAfricanNationsCup => 'नेशंस कप';

  @override
  String get objectiveNcWinItNorthAmerica => 'नॉर्थ अमेरिका नेशंस कप जीतें';

  @override
  String get objectiveNcWinItAfrica => 'नेशंस कप जीतें';

  @override
  String get objectiveNcReachFinalNorthAmerica =>
      'नॉर्थ अमेरिका नेशंस कप के फ़ाइनल में पहुँचें';

  @override
  String get objectiveNcReachFinalAfrica => 'नेशंस कप के फ़ाइनल में पहुँचें';

  @override
  String get finishNcChampionsNorthAmerica => 'नॉर्थ अमेरिका नेशंस कप विजेता';

  @override
  String get finishNcChampionsAfrica => 'नेशंस कप विजेता';

  @override
  String pressAimQualWarm1(String competition) {
    return '$competition क्वालिफ़ाइंग शुरू हो गई है, और देश को इस टीम पर भरोसा है। आपका लक्ष्य क्या है?';
  }

  @override
  String pressAimQualWarm2(String competition) {
    return '$competition का नया क्वालिफ़ाइंग अभियान, और माहौल ऊँचा है। यह टीम कितनी दूर जा सकती है?';
  }

  @override
  String pressAimQualNeutral1(String competition) {
    return '$competition क्वालिफ़ाइंग शुरू हो रही है। इस अभियान का लक्ष्य क्या है?';
  }

  @override
  String pressAimQualNeutral2(String competition) {
    return '$competition क्वालिफ़ायर आ गए हैं। आप इस टीम को कहाँ पूरा करते देखते हैं?';
  }

  @override
  String pressAimQualHostile1(String competition) {
    return '$competition क्वालिफ़ाइंग शुरू हो रही है, और कई लोगों को शक है कि आप वहाँ पहुँचेंगे। उनसे आप क्या कहेंगे?';
  }

  @override
  String pressAimQualHostile2(String competition) {
    return '$competition का एक और क्वालिफ़ाइंग अभियान। कोई क्यों मान ले कि यह अलग होगा?';
  }

  @override
  String pressAimFinalsWarm1(String competition) {
    return '$competition आ गया है और पूरा देश आपके साथ है। आप कितनी दूर जा सकते हैं?';
  }

  @override
  String pressAimFinalsWarm2(String competition) {
    return 'आप $competition में हैं और समर्थक सपने देख रहे हैं। लक्ष्य क्या है?';
  }

  @override
  String pressAimFinalsNeutral1(String competition) {
    return '$competition इसी हफ़्ते शुरू हो रहा है। सफलता किसे माना जाएगा?';
  }

  @override
  String pressAimFinalsNeutral2(String competition) {
    return '$competition में आपका पहला मैच क़रीब है। हमें एक लक्ष्य बताइए।';
  }

  @override
  String pressAimFinalsHostile1(String competition) {
    return '$competition आ गया है और किसी को ज़्यादा उम्मीद नहीं। आप असल में क्या चाहते हैं?';
  }

  @override
  String pressAimFinalsHostile2(String competition) {
    return 'आप $competition में हैं, पर शक अब भी बाक़ी हैं। आपका लक्ष्य क्या है?';
  }

  @override
  String pressBeatRivalWarm1(String rival) {
    return '$rival आपके ग्रुप में है। क्या वह आपको चिंता में डालती है?';
  }

  @override
  String pressBeatRivalWarm2(String rival) {
    return 'ड्रॉ ने $rival को आपके रास्ते में ला दिया। उस मैच को आप कैसे देखते हैं?';
  }

  @override
  String pressBeatRivalNeutral1(String rival) {
    return '$rival आपके ग्रुप की सबसे मज़बूत टीम लगती है। क्या वही दावेदार है?';
  }

  @override
  String pressBeatRivalNeutral2(String rival) {
    return '$rival के बारे में आपकी क्या राय है?';
  }

  @override
  String pressBeatRivalHostile1(String rival) {
    return '$rival आपके ग्रुप में है। ईमानदारी से बताइए, क्या आप उसका सामना कर सकते हैं?';
  }

  @override
  String pressBeatRivalHostile2(String rival) {
    return 'ज़्यादातर लोग मानते हैं कि $rival आपको हरा देगी। क्या वे ग़लत हैं?';
  }

  @override
  String pressBeatKeyPlayerWarm1(String player) {
    return '$player शानदार फ़ॉर्म में है। क्या यह उसका पल है?';
  }

  @override
  String pressBeatKeyPlayerWarm2(String player) {
    return '$player हर सुर्ख़ी में है। क्या वह इस टीम को अपने कंधों पर उठा सकता है?';
  }

  @override
  String pressBeatKeyPlayerNeutral1(String player) {
    return 'यह अभियान $player पर कितना निर्भर है?';
  }

  @override
  String pressBeatKeyPlayerNeutral2(String player) {
    return 'क्या $player इस टीम की अगुवाई के लिए तैयार है?';
  }

  @override
  String pressBeatKeyPlayerHostile1(String player) {
    return 'अगर $player अपने सर्वश्रेष्ठ पर नहीं हुआ, तो क्या इस टीम के पास कुछ है?';
  }

  @override
  String pressBeatKeyPlayerHostile2(String player) {
    return '$player के कंधों पर बहुत बोझ है। कहीं बहुत ज़्यादा तो नहीं?';
  }

  @override
  String get pressReplyAimHigher1 =>
      'हम उससे आगे जाएँगे जितना किसी ने सोचा है।';

  @override
  String get pressReplyAimHigher2 =>
      'मैं फ़ेडरेशन की माँग से ज़्यादा चाहता हूँ, और यह खुलकर कहूँगा।';

  @override
  String get pressReplyMatchBrief1 =>
      'हमें लक्ष्य पता है और हम उसे हासिल करेंगे।';

  @override
  String get pressReplyMatchBrief2 =>
      'फ़ेडरेशन ने लक्ष्य तय किया है। हम उसे पूरा करेंगे।';

  @override
  String get pressReplyPlayDown1 => 'आइए एक-एक मैच करके चलें।';

  @override
  String get pressReplyPlayDown2 =>
      'कोई बड़े वादे नहीं। देखते हैं हम कहाँ खड़े हैं।';

  @override
  String get pressReplyPromiseQualify1 =>
      'हम क्वालिफ़ाई करेंगे। आप इसे लिख लीजिए।';

  @override
  String get pressReplyPromiseQualify2 => 'यह टीम फ़ाइनल्स में होगी।';

  @override
  String get pressReplyFearNobody1 => 'हम किसी से नहीं डरते।';

  @override
  String get pressReplyFearNobody2 => 'उन्हें भी हमसे खेलना है।';

  @override
  String get pressReplyRespectRival1 =>
      'वे दावेदार हैं, और हम उनका सम्मान करते हैं।';

  @override
  String get pressReplyRespectRival2 =>
      'बहुत अच्छी टीम है। हमें अपना सर्वश्रेष्ठ देना होगा।';

  @override
  String get pressReplyTeamFirst1 =>
      'बात पूरी टीम की है, किसी एक खिलाड़ी की नहीं।';

  @override
  String get pressReplyTeamFirst2 => 'अकेले कोई नहीं जीतता।';

  @override
  String pressOnRecordTarget(String aim) {
    return 'रिकॉर्ड पर: $aim।';
  }

  @override
  String get pressOnRecordPlayDown => 'रिकॉर्ड पर: कोई वादा नहीं।';

  @override
  String get pressThrowbackTargetKeptWarm =>
      'आपने अभियान से पहले लक्ष्य तय किया था और उसे पा लिया। क्या यह अब तक का आपका सबसे गर्व का पल है?';

  @override
  String get pressThrowbackTargetKeptNeutral =>
      'आपने कहा था क्या हासिल करेंगे, और किया। क्या कभी शक था?';

  @override
  String get pressThrowbackTargetKeptHostile =>
      'आपने जो लक्ष्य रखा था, उसे पा लिया। क़िस्मत थी, या वाक़ई यही योजना थी?';

  @override
  String get pressThrowbackTargetBrokenWarm =>
      'आपने लक्ष्य तय किया और पीछे रह गए। क्या ग़लत हुआ?';

  @override
  String get pressThrowbackTargetBrokenNeutral =>
      'आपने इस टीम की क्षमता से ज़्यादा का वादा किया। क्या यह कहने का अफ़सोस है?';

  @override
  String get pressThrowbackTargetBrokenHostile =>
      'अभियान से पहले आपने बड़ी बातें कीं और चूक गए। अब हम आप पर क्यों भरोसा करें?';

  @override
  String hubEventPressPreviewSub(String competition) {
    return 'प्रेस आपके $competition के लक्ष्य सुनना चाहता है';
  }

  @override
  String deptLevelCost(int level, String amount) {
    return 'लेवल $level · $amount';
  }

  @override
  String get formOnFire => 'आग उगलता';

  @override
  String get formGood => 'फ़ॉर्म में';

  @override
  String get formSteady => 'स्थिर';

  @override
  String get formPoor => 'फ़ॉर्म से बाहर';

  @override
  String get formCold => 'बर्फ़ जैसा ठंडा';

  @override
  String get playerFormTitle => 'फ़ॉर्म और फ़िटनेस';

  @override
  String playerFormAverage(String rating) {
    return 'हाल के मैचों में औसत $rating';
  }

  @override
  String get playerFormNoGames => 'आकलन के लिए हाल के मैच काफ़ी नहीं';

  @override
  String playerFormNextMatch(String delta) {
    return 'अगले मैच में उसकी रेटिंग में $delta';
  }

  @override
  String get playerFormNoEffect => 'अगले मैच में उसकी रेटिंग पर कोई असर नहीं';

  @override
  String get sideGroupHome => 'होम';

  @override
  String get sideGroupTeam => 'टीम';

  @override
  String get sideGroupCompetitions => 'प्रतियोगिताएँ';

  @override
  String get sideGroupFederation => 'फ़ेडरेशन';

  @override
  String get sideGroupHistory => 'इतिहास';

  @override
  String get sideInbox => 'इनबॉक्स';

  @override
  String get sideSquad => 'स्क्वॉड';

  @override
  String get sideTactics => 'टैक्टिक्स';

  @override
  String get sideMainMenu => 'मुख्य मेनू';

  @override
  String get sideCallUps => 'कॉल-अप';

  @override
  String get sideTournaments => 'टूर्नामेंट';

  @override
  String get sideRanking => 'रैंकिंग';

  @override
  String get sideResults => 'नतीजे';

  @override
  String get sideFinances => 'वित्त';

  @override
  String get sideBoard => 'बोर्ड';

  @override
  String get sideManager => 'मैनेजर और स्टाफ़';

  @override
  String get sideRecords => 'रिकॉर्ड';

  @override
  String get sideLegends => 'दिग्गज';

  @override
  String get sideHeadToHead => 'आमने-सामने';

  @override
  String get sideAchievements => 'उपलब्धियाँ';

  @override
  String get sideCareer => 'करियर';

  @override
  String get topBarNext => 'अगला';

  @override
  String get topBarDrawPending => 'ड्रॉ बाक़ी';

  @override
  String get paneFullProfile => 'पूरी प्रोफ़ाइल';

  @override
  String get panePickPlayer => 'यहाँ कार्ड देखने के लिए खिलाड़ी चुनें';

  @override
  String get inboxPickMessage => 'पढ़ने के लिए कोई संदेश चुनें';

  @override
  String get inboxFilterAll => 'सभी';

  @override
  String get panelViewAll => 'सब देखें';

  @override
  String get gridViewOverview => 'अवलोकन';

  @override
  String get gridColCondition => 'फ़िटनेस';

  @override
  String get gridColStatus => 'स्थिति';

  @override
  String get gridColRank => 'रैंक';

  @override
  String get gridColMove => 'बदलाव';

  @override
  String get gridColNation => 'देश';

  @override
  String get gridColRegion => 'क्षेत्र';

  @override
  String get gridColPoints => 'अंक';

  @override
  String get panePickNation => 'यहाँ रिकॉर्ड देखने के लिए कोई देश चुनें';

  @override
  String get resultsCyclesTitle => 'चक्र';

  @override
  String get tourDrawStart => 'ड्रॉ शुरू करें';

  @override
  String get tourDrawViewGroups => 'ग्रुप देखें';

  @override
  String get gridColCeiling => 'अधिकतम स्तर';

  @override
  String get gridColYearGain => 'बढ़त';

  @override
  String get gridColMarkedAt => 'चिह्नित के समय';

  @override
  String get budgetSetupTitle => 'अपना बजट तय करें';

  @override
  String get budgetEffectsTitle => 'इस बजट से क्या मिलता है';

  @override
  String get naturalisationTitle => 'नागरिकता';

  @override
  String get yTrending => 'ट्रेंडिंग';

  @override
  String get yVoices => 'चर्चित आवाज़ें';

  @override
  String get yConversation => 'बातचीत';

  @override
  String get allTimeRecordsTitle => 'सर्वकालिक विश्व रिकॉर्ड';

  @override
  String get h2hMeetingsTitle => 'हर मुक़ाबला';

  @override
  String get h2hPickOpponent =>
      'हर मुक़ाबला यहाँ देखने के लिए प्रतिद्वंद्वी चुनें';

  @override
  String get savesTitle => 'सेव';

  @override
  String get gridColPlayer => 'खिलाड़ी';

  @override
  String get gridColPos => 'Pos';

  @override
  String get gridColActive => 'सक्रिय';

  @override
  String get gridColMotm => 'MOTM';

  @override
  String get gridColAvg => 'औसत';

  @override
  String get gridColOpponent => 'प्रतिद्वंद्वी';

  @override
  String get gridColStarts => 'शुरुआत';

  @override
  String get gridColTournaments => 'टूर्नामेंट';

  @override
  String get gridColDate => 'तारीख़';

  @override
  String get gridColLastPlayed => 'आख़िरी बार खेले';

  @override
  String get gridColManager => 'मैनेजर';

  @override
  String nationsShownCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count देश',
      one: '1 देश',
    );
    return '$_temp0';
  }

  @override
  String get nationsSortedByRank => 'विश्व रैंकिंग के क्रम में';

  @override
  String get nationsStrength => 'ताक़त';

  @override
  String nationsStrengthOf(int tier) {
    return 'पाँच में $tier';
  }

  @override
  String get nationsSquadOverall => 'स्क्वॉड ओवरऑल';

  @override
  String get nationsOpeningBudget => 'शुरुआती बजट';

  @override
  String get nationsStarPlayer => 'स्टार खिलाड़ी';

  @override
  String nationsStarTile(String position, int rating) {
    return 'स्टार $position $rating';
  }

  @override
  String nationsStarAge(int age) {
    return 'उम्र $age';
  }

  @override
  String get nationsBoardExpects => 'बोर्ड की अपेक्षा';

  @override
  String nationsManage(String nation) {
    return '$nation की कमान सँभालें';
  }

  @override
  String get nationsManagerNext => 'अगले चरण में आप अपना मैनेजर चुनेंगे';

  @override
  String get playerPageTitle => 'खिलाड़ी';

  @override
  String get nationPageTitle => 'देश';

  @override
  String get friendliesYourGames => 'आपके दोस्ताना मैच';

  @override
  String hubEventInjuryCover(String player) {
    return 'चोटिल $player की जगह बदलें';
  }

  @override
  String hubEventInjuryCoverSub(int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: '$matches मैचों से बाहर',
      one: 'अगले मैच से बाहर',
    );
    return '$_temp0। किसी को बुलाएँ, या उसके बिना खेलें।';
  }

  @override
  String get injuryCoverTitle => 'रिप्लेसमेंट';

  @override
  String injuryCoverBanner(String player, String position) {
    return '$player ($position) चोटिल है। स्क्वॉड के बाहर से किसी को भी, किसी भी पोज़ीशन पर बुलाएँ, या उसे रखकर खेलते रहें।';
  }

  @override
  String injuryCoverConfirm(String player) {
    return '$player को बुलाएँ';
  }

  @override
  String injuryCoverKeep(String player) {
    return '$player को रखें और खेलते रहें';
  }

  @override
  String get injuryCoverPick => 'रिप्लेसमेंट चुनें';

  @override
  String get injuryCoverNone =>
      'स्क्वॉड के बाहर कोई भी खिलाड़ी जुड़ने के लिए फ़िट नहीं है।';

  @override
  String get nationNowRanking => 'विश्व रैंकिंग';

  @override
  String get nationNowForm => 'फ़ॉर्म';

  @override
  String get nationNowNoForm => 'अभी तक कोई मैच नहीं खेला';

  @override
  String get nationNowNext => 'अगला मैच';

  @override
  String get nationNowNoNext => 'कुछ तय नहीं';

  @override
  String get nationNowSquad => 'स्क्वॉड';

  @override
  String get nationNowAgainstYou => 'आपके ख़िलाफ़';

  @override
  String nationNowRecord(int w, int d, int l) {
    return '${w}W ${d}D ${l}L';
  }

  @override
  String get nationNowLastMeeting => 'पिछला मुक़ाबला';

  @override
  String nationNowOverall(int value) {
    return 'ओवरऑल $value';
  }

  @override
  String get hubUpcoming => 'आगामी';

  @override
  String get hubFullSchedule => 'पूरा शेड्यूल';

  @override
  String get scheduleTitle => 'शेड्यूल';

  @override
  String get scheduleToday => 'आज';

  @override
  String get scheduleKnockoutPending => 'नॉकआउट चरण, अगर आप आगे बढ़ें';

  @override
  String get scheduleNextRoundPending => 'अगला राउंड';

  @override
  String scheduleFromDate(String date) {
    return '$date से';
  }

  @override
  String get scheduleHomeShort => 'H';

  @override
  String get scheduleAwayShort => 'A';

  @override
  String get tacticsNoPresetsInMatch =>
      'अभी कोई सेव की हुई टैक्टिक्स नहीं है। मैच से पहले टैक्टिक्स स्क्रीन से एक सेव करें।';

  @override
  String get homeCampaigns => 'अभियान';

  @override
  String get homeContinueCampaign => 'अभियान जारी रखें';

  @override
  String homeCampaignCycle(String date, int cycle, int total) {
    return '$date · चक्र $cycle / $total';
  }

  @override
  String get campaignsTitle => 'अभियान';

  @override
  String get campaignTransplantTitle => 'द ट्रांसप्लांट';

  @override
  String get campaignTransplantTwist =>
      'इटली के आठ बेहतरीन खिलाड़ी सैन मरीनो के लिए खेलने को राज़ी';

  @override
  String get campaignTransplantGoal =>
      'यूरोपीय चैंपियनशिप के लिए क्वालिफ़ाई करें';

  @override
  String get campaignGrudgeTitle => 'रंजिश';

  @override
  String get campaignGrudgeTwist => 'जॉर्जिया और अल्बानिया, एक ही ग्रुप में';

  @override
  String get campaignGrudgeGoal => 'क्वालिफ़ाइंग में अल्बानिया से ऊपर रहें';

  @override
  String get campaignTransplantIntro =>
      'सैन मरीनो के पास कभी ऐसा क्वालिफ़ाइंग अभियान नहीं रहा जिसे अभियान कहा जा सके। फिर इटली के आठ बेहतरीन खिलाड़ी पासपोर्ट लेकर टीम में आ जाते हैं। एक कौतूहल को टीम बनाने के लिए आपके पास एक चक्र है।';

  @override
  String get campaignGrudgeIntro =>
      'जॉर्जिया और अल्बानिया एक ही क्वालिफ़ाइंग ग्रुप में आ गए हैं, और दोनों में से कोई हार नहीं भूलेगा। अल्बानिया से ऊपर रहें, फिर देखें कि इसे कहाँ तक ले जा सकते हैं।';

  @override
  String get campaignStars1Transplant => 'क्वालिफ़ाई करें';

  @override
  String get campaignStars2Transplant => 'नॉकआउट में पहुँचें';

  @override
  String get campaignStars3Transplant => 'यूरोपीय चैंपियनशिप जीतें';

  @override
  String get campaignStars1Grudge => 'अल्बानिया से ऊपर';

  @override
  String get campaignStars2Grudge => 'और क्वालिफ़ाई करें';

  @override
  String get campaignStars3Grudge => 'और उन्हें दो बार हराएँ';

  @override
  String get campaignFree => 'मुफ़्त';

  @override
  String get campaignStart => 'शुरू करें';

  @override
  String get campaignPartOfUnlimited => 'अनलिमिटेड का हिस्सा';

  @override
  String get campaignResume => 'जारी रखें';

  @override
  String get campaignAbandon => 'छोड़ दें';

  @override
  String get campaignAbandonConfirm =>
      'यह अभियान छोड़ दें? इसकी प्रगति चली जाएगी; आपका स्टैंप बना रहेगा।';

  @override
  String get campaignMoveToSaves => 'सेव में ले जाएँ';

  @override
  String get campaignCannotContinue =>
      'इस अभियान की दुनिया असली दुनिया से इतनी दूर है कि इसे करियर के तौर पर आगे नहीं बढ़ाया जा सकता।';

  @override
  String get campaignMoveSlotsFull =>
      'आपके सेव स्लॉट भरे हैं। पहले एक ख़ाली करें।';

  @override
  String get campaignStampConquered => 'फ़तह';

  @override
  String get campaignStampFailed => 'नाकाम';

  @override
  String get campaignDifficultyHard => 'कठिन';

  @override
  String get campaignDifficultyMedium => 'मध्यम';

  @override
  String get campaignGoalLabel => 'लक्ष्य';

  @override
  String get campaignStarsLabel => 'सितारे';

  @override
  String get campaignRunInProgress => 'इस अभियान का एक रन पहले से जारी है।';

  @override
  String get campaignVerdictWon => 'फ़तह';

  @override
  String get campaignVerdictLost => 'इस बार नहीं';

  @override
  String get campaignVerdictContinue => 'आगे बढ़ें';

  @override
  String campaignProgressQualifying(String position) {
    return 'क्वालिफ़ाइंग: $position';
  }

  @override
  String campaignProgressRival(String rival, String position) {
    return '$rival: $position';
  }

  @override
  String campaignProgressFinals(String stage) {
    return 'फ़ाइनल्स: $stage';
  }

  @override
  String get campaignRunInNumbers => 'रन आँकड़ों में';

  @override
  String campaignRunMeetings(int won, int played) {
    return 'जीते मुक़ाबले: $played में से $won';
  }

  @override
  String campaignPlace(String which, int n) {
    String _temp0 = intl.Intl.selectLogic(
      which,
      {
        'first': 'पहला',
        'second': 'दूसरा',
        'third': 'तीसरा',
        'other': 'नंबर $n',
      },
    );
    return '$_temp0';
  }

  @override
  String get campaignGuineasTitle => 'बेस्ट ऑफ़ गिनीज़';

  @override
  String get campaignGuineasTwist =>
      'इक्वेटोरियल गिनी, अफ़्रीका के गिनी देशों में सबसे छोटा, दो चक्रों के लिए';

  @override
  String get campaignGuineasGoal => 'गिनी और गिनी-बिसाऊ को हराएँ';

  @override
  String get campaignGuineasIntro =>
      'तीन अफ़्रीकी देशों के नाम में गिनी है, और इक्वेटोरियल गिनी उनमें सबसे छोटा है। आपके पास दो चक्र हैं: गिनी और गिनी-बिसाऊ को कम से कम एक-एक बार हराएँ, फिर देखें कि अफ़्रीकी चैंपियनशिप में कितनी दूर जाते हैं। चौथा गिनी, पापुआ न्यू गिनी, पहले से ही एक दोस्ताना मैच के लिए तय है।';

  @override
  String get campaignStars1Guineas => 'गिनी और गिनी-बिसाऊ को हराएँ';

  @override
  String get campaignStars2Guineas =>
      'और अफ़्रीकी चैंपियनशिप के लिए क्वालिफ़ाई करें';

  @override
  String get campaignStars3Guineas =>
      'और अफ़्रीकी चैंपियनशिप के क्वार्टरफ़ाइनल में पहुँचें';

  @override
  String get campaignYoungFinnsTitle => 'यंग फ़िन्स';

  @override
  String get campaignYoungFinnsTwist =>
      'फ़िनलैंड की किशोरों की सुनहरी पीढ़ी, तीन चक्रों के लिए';

  @override
  String get campaignYoungFinnsGoal =>
      'विश्व चैंपियनशिप के लिए क्वालिफ़ाई करें';

  @override
  String get campaignYoungFinnsIntro =>
      'फ़िनलैंड के सीनियर खिलाड़ी किनारे हो गए हैं और एक सुनहरी पीढ़ी ने उनकी जगह ले ली है: आप जिसे भी चुन सकते हैं, वह 18 साल या उससे कम का है। आज कच्चे हैं, पर उनमें दुनिया की बेहतरीन टीमों में से एक बनने की प्रतिभा है, जैसा नॉर्वे की युवा पीढ़ी ने किया था। उन्हें विश्व चैंपियनशिप तक ले जाने के लिए आपके पास तीन चक्र हैं, फिर यूरोपीय चैंपियनशिप और विश्व चैंपियनशिप जीतें।';

  @override
  String get campaignStars1YoungFinns =>
      'विश्व चैंपियनशिप के लिए क्वालिफ़ाई करें';

  @override
  String get campaignStars2YoungFinns => 'यूरोपीय चैंपियनशिप जीतें';

  @override
  String get campaignStars3YoungFinns => 'विश्व चैंपियनशिप जीतें';

  @override
  String get campaignGreenlandTitle => 'ग्रीनलैंड की एक सदी';

  @override
  String get campaignGreenlandTwist =>
      'ग्रीनलैंड सौ साल के लिए यूरोप में सैन मरीनो की जगह लेता है';

  @override
  String get campaignGreenlandGoal =>
      'किसी यूरोपीय चैंपियनशिप के लिए क्वालिफ़ाई करें';

  @override
  String get campaignGreenlandIntro =>
      'ग्रीनलैंड ने कभी कोई प्रतिस्पर्धी अंतरराष्ट्रीय मैच नहीं खेला है। इस दुनिया में उसने यूरोप में सैन मरीनो की जगह ले ली है, और वह विश्व रैंकिंग में सबसे नीचे से शुरुआत करता है: शौकिया खिलाड़ी, कृत्रिम घास के मैदान और बर्फ़बारी के बीच सिमटा हुआ सीज़न। आपके पास सौ साल, यानी पच्चीस चक्र हैं: यूरोपीय चैंपियनशिप तक पहुँचें, फिर विश्व चैंपियनशिप तक और, अगर सपने देखने की हिम्मत है, तो इनमें से एक जीतें।';

  @override
  String get campaignStars1Greenland =>
      'किसी यूरोपीय चैंपियनशिप के लिए क्वालिफ़ाई करें';

  @override
  String get campaignStars2Greenland =>
      'विश्व चैंपियनशिप के लिए क्वालिफ़ाई करें';

  @override
  String get campaignStars3Greenland =>
      'यूरोपीय चैंपियनशिप या विश्व चैंपियनशिप जीतें';

  @override
  String get campaignPro => 'Pro';

  @override
  String campaignProgressCup(String cup, String year, String status) {
    return '$cup $year: $status';
  }

  @override
  String get campaignCupNotQualified => 'क्वालिफ़ाई नहीं किया';

  @override
  String get campaignCupOpen => 'तय होना बाक़ी';

  @override
  String newsYouthTitle1(String name, String level) {
    return '$level टीम में चमके $name';
  }

  @override
  String newsYouthTitle2(String name, String level) {
    return 'अकादमी रिपोर्ट: $name ने ध्यान खींचा';
  }

  @override
  String newsYouthTitle3(String name, String level) {
    return '$level टीम का सितारा: $name';
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
      other: '$count बार',
      one: '$count बार',
    );
    return 'पिछले अंतरराष्ट्रीय विंडो में $name ने $opponent के ख़िलाफ़ $level टीम के लिए $_temp0 गोल किया।';
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
      other: '$count गोल',
      one: '$count गोल',
    );
    return 'इस विंडो में $level टीम का सामना $opponent से हुआ और $name ने $_temp0 दागे।';
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
      other: '$count गोल',
      one: '$count गोल',
    );
    return '$level टीम ने $opponent का सामना किया और $name मैदान से $_temp0 अपने नाम करके लौटे।';
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
      other: '$count गोल',
      one: '$count गोल',
    );
    return '$name ने $opponent के ख़िलाफ़ $level टीम के लिए $_temp0 बनवाए और शुरू से आख़िर तक खेल पर नियंत्रण रखा।';
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
      other: '$count असिस्ट',
      one: '$count असिस्ट',
    );
    return 'इस विंडो में $level टीम ने $opponent से मुक़ाबला किया और डोर $name के हाथ में थी: $_temp0 और ऐसा प्रदर्शन जिसकी चर्चा स्टाफ़ अब भी कर रहा है।';
  }

  @override
  String newsYouthCleanSheet1(String name, String level, String opponent) {
    return '$opponent के ख़िलाफ़ $level टीम ने कोई गोल नहीं खाया और $name का प्रदर्शन शानदार रहा।';
  }

  @override
  String newsYouthCleanSheet2(String name, String level, String opponent) {
    return '$opponent के ख़िलाफ़ $level टीम की क्लीन शीट, और इसका सबसे बड़ा श्रेय $name को जाता है।';
  }

  @override
  String newsYouthDisplay1(
    String name,
    String level,
    String opponent,
    int mark,
  ) {
    return '$name ने $opponent के ख़िलाफ़ $level टीम में प्रभावित किया और स्टाफ़ ने उनके खेल को दस में से $mark अंक दिए।';
  }

  @override
  String newsYouthDisplay2(
    String name,
    String level,
    String opponent,
    int mark,
  ) {
    return 'इस विंडो में $level टीम ने $opponent से मुक़ाबला किया और कोचों ने एक नाम चुना, $name: दस में से $mark, टीम में सबसे ऊँचा अंक।';
  }

  @override
  String get newsYouthDevReady1 =>
      'इस फ़ॉर्म में वह सीनियर टीम के लिए विचार किए जाने लायक़ हो चुके हैं।';

  @override
  String get newsYouthDevReady2 =>
      'स्टाफ़ का मानना है कि वह अभी से सीनियर फ़ुटबॉल के लिए तैयार हैं। फ़ैसला आपका है।';

  @override
  String get newsYouthDevClose1 =>
      'वह अच्छी प्रगति कर रहे हैं और सीनियर टीम में जगह बनाने के क़रीब हैं।';

  @override
  String get newsYouthDevClose2 =>
      'सीनियर टीम अब ज़्यादा दूर नहीं है, और एक और अच्छा सीज़न काफ़ी हो सकता है।';

  @override
  String get newsYouthDevGrowing1 =>
      'उनका विकास अच्छा हो रहा है, हालाँकि सीनियर टीम अभी एक-दो क़दम दूर है।';

  @override
  String get newsYouthDevGrowing2 =>
      'सीनियर अंतरराष्ट्रीय खिलाड़ी बनने से पहले अभी काम बाक़ी है, लेकिन सब कुछ सही दिशा में है।';

  @override
  String get newsYouthDevRaw1 =>
      'वह अभी कच्चे हैं और सीनियर टीम से कुछ साल दूर हैं, लेकिन प्रतिभा साफ़ दिखती है।';

  @override
  String get newsYouthDevRaw2 =>
      'अभी शुरुआत है, और अकादमी के कोच सुर्ख़ियों की नहीं, धैर्य की माँग कर रहे हैं।';

  @override
  String get newsYouthStrengthGkPhysical =>
      'उनकी पहुँच और बॉक्स पर पकड़ ही उन्हें सबसे अलग बनाती है।';

  @override
  String get newsYouthStrengthGkTechnical =>
      'उनकी गेंद पकड़ने की कला और डिस्ट्रिब्यूशन अकादमी में बरसों में देखी गई सबसे बेहतरीन है।';

  @override
  String get newsYouthStrengthGkStamina =>
      'उनकी एकाग्रता कभी नहीं टूटती: नब्बेवें मिनट में भी वह पहले मिनट जितने चौकस रहते हैं।';

  @override
  String get newsYouthStrengthDefPhysical =>
      'उनकी रफ़्तार और हवाई क्षमता उनके खेल की कुंजी है।';

  @override
  String get newsYouthStrengthDefTechnical =>
      'वह अपनी उम्र से कहीं आगे खेल को पढ़ते हैं और गेंद पर शांत रहते हैं।';

  @override
  String get newsYouthStrengthDefStamina =>
      'उनका ध्यान कभी नहीं भटकता, और आख़िरी मिनट में भी वह पूरी रफ़्तार से वापस दौड़ते हैं।';

  @override
  String get newsYouthStrengthMidPhysical =>
      'वह असली ताक़त से गेंद छीनते हैं और तुरंत उसे आगे ले जाते हैं।';

  @override
  String get newsYouthStrengthMidTechnical =>
      'उनकी दूरदर्शिता और पास की विविधता उनके खेल की कुंजी है।';

  @override
  String get newsYouthStrengthMidStamina =>
      'उनका इंजन कमाल का है: वह मैदान का हर कोना नाप देते हैं।';

  @override
  String get newsYouthStrengthFwdPhysical =>
      'डिफ़ेंस के पीछे उनकी रफ़्तार और हवा में ताक़त उन्हें हर डिफ़ेंस के लिए सिरदर्द बनाती है।';

  @override
  String get newsYouthStrengthFwdTechnical =>
      'उनकी फ़िनिशिंग और बॉक्स में मूवमेंट उनके खेल की कुंजी है।';

  @override
  String get newsYouthStrengthFwdStamina =>
      'वह पूरे मैच आगे से प्रेस करते हैं और डिफ़ेंडरों को एक पल का भी चैन नहीं देते।';

  @override
  String pressMomentBigWinWarm3(String opponent) {
    return '$opponent के ख़िलाफ़ इस मैच के गीत फ़ैन लंबे समय तक गाएँगे। आख़िरी सीटी पर आपने खिलाड़ियों से क्या कहा?';
  }

  @override
  String pressMomentBigWinNeutral3(String opponent) {
    return '$opponent के ख़िलाफ़ यह एक बड़ा संदेश था। इसमें से कितना ट्रेनिंग ग्राउंड से आया?';
  }

  @override
  String pressMomentBigWinHostile3(String opponent) {
    return '$opponent के ख़िलाफ़ नतीजे के लिए बधाई, लेकिन ऐसी रातें हम पहले भी देख चुके हैं। इस बार क्या अलग है?';
  }

  @override
  String pressMomentBigLossWarm3(String opponent) {
    return 'हर किसी की एक बुरी रात होती है, और $opponent के ख़िलाफ़ वैसी ही थी। आप इसे कितनी जल्दी पीछे छोड़ पाएँगे?';
  }

  @override
  String pressMomentBigLossNeutral3(String opponent) {
    return '$opponent हर विभाग में बेहतर था। आप सुधार कहाँ से शुरू करेंगे?';
  }

  @override
  String pressMomentBigLossHostile3(String opponent) {
    return '$opponent के ख़िलाफ़ मैच ख़त्म होने से पहले ही समर्थक जाने लगे थे। क्या आप उन्हें दोष दे सकते हैं?';
  }

  @override
  String pressMomentCrisisWarm3(String opponent) {
    return 'यह मुश्किल दौर है, और $opponent ने इसे ज़रा भी आसान नहीं बनाया। आपको क्या आगे बढ़ाता रहता है?';
  }

  @override
  String pressMomentCrisisNeutral3(String opponent) {
    return 'एक और मैच बिना जीत के, इस बार $opponent के ख़िलाफ़। बोर्ड के कार्रवाई करने से पहले यह कब तक चल सकता है?';
  }

  @override
  String pressMomentCrisisHostile3(String opponent) {
    return 'अब $opponent भी। क्या आपकी योजना में कुछ बचा है, या किसी और के लिए जगह छोड़ने का समय आ गया है?';
  }

  @override
  String get pressReplyCreditPlayers5 =>
      'आप जो भी लिखें, खिलाड़ियों के बारे में लिखें। वे इसके हक़दार हैं।';

  @override
  String get pressReplyCreditPlayers6 =>
      'मेरे पास ऐसा ग्रुप है जो एक-दूसरे के लिए आग में कूद जाए। यह कोई छोटी बात नहीं।';

  @override
  String get pressReplyTakeResponsibility5 =>
      'फ़ैसले मैं लेता हूँ, तो आलोचना भी मेरी। यही काम है।';

  @override
  String get pressReplyTakeResponsibility6 =>
      'पहले कोच को देखिए। मुझसे कुछ ग़लतियाँ हुईं और मैं उन्हें सुधारूँगा।';

  @override
  String get pressReplyDemandMore5 =>
      'यहाँ अच्छा होना काफ़ी नहीं। मैंने यह उनके मुँह पर कहा है।';

  @override
  String get pressReplyDemandMore6 =>
      'उस ड्रेसिंग रूम में किसी की जगह पक्की नहीं है। अब उन्हें यह पता है।';

  @override
  String get pressReplyDeflect5 =>
      'आप यह सवाल तीन तरीक़ों से पूछ सकते हैं। जवाब वही रहेगा।';

  @override
  String get pressReplyDeflect6 =>
      'अपने विचार मैं खिलाड़ियों के लिए रखूँगा। आप समझेंगे।';

  @override
  String yWinRoutine12(String opponent, String score) {
    return '$opponent के ख़िलाफ़ $score। शांत, नियंत्रित, परिपक्व फ़ुटबॉल। देखकर मज़ा आया।';
  }

  @override
  String yWinRoutine13(String opponent, String score) {
    return '$opponent को $score से हराया, पसीना बहाए बिना। यह टीम उबाऊ होने में माहिर हो रही है, और उबाऊ ही ट्रॉफ़ी जिताता है।';
  }

  @override
  String yWinRoutine14(String opponent, String score) {
    return '$opponent $score। तीन अंक, कोई ड्रामा नहीं, वापस काम पर।';
  }

  @override
  String yWinRoutine15(String opponent, String score) {
    return '$opponent के ख़िलाफ़ एक रूटीन $score। किसी को याद नहीं रहेगा और ज़रूरत भी नहीं।';
  }

  @override
  String yWinRoutine16(String opponent, String score) {
    return '$opponent के ख़िलाफ़ $score और फिर भी न जाने क्यों चिंता है।';
  }

  @override
  String yWinRoutine17(String opponent, String score) {
    return '$opponent को $score से हराया। किसी असली टीम के ख़िलाफ़ ऐसे प्रदर्शन की सज़ा मिलती।';
  }

  @override
  String yWinTight12(String opponent, String score) {
    return '$opponent के ख़िलाफ़ $score। डटे रहे, झेला, जीते। यही होती है टीम।';
  }

  @override
  String yWinTight13(String opponent, String score) {
    return '$opponent को $score से हराया, सिर्फ़ जज़्बे के दम पर। मुझे वह टीम चाहिए जो हार मानने से इनकार करे।';
  }

  @override
  String yWinTight14(String opponent, String score) {
    return '$opponent $score। आख़िरी सेकंड तक गया, लेकिन अंक हमारे हैं।';
  }

  @override
  String yWinTight15(String opponent, String score) {
    return '$opponent के ख़िलाफ़ नज़दीकी $score। फ़र्क़ बहुत कम था, और यही फ़ुटबॉल है।';
  }

  @override
  String yWinTight16(String opponent, String score) {
    return '$opponent के ख़िलाफ़ $score। एक क़िस्मत वाला टप्पा उलटी तरफ़ जाता तो हम कुछ और ही बात कर रहे होते।';
  }

  @override
  String yWinTight17(String opponent, String score) {
    return '$opponent के ख़िलाफ़ किसी तरह टिके रहे, $score। इसे कोई प्रदर्शन न कहे।';
  }

  @override
  String yDrew12(String opponent, String score) {
    return '$opponent के साथ $score। हार नहीं है, और कुछ दिन यही काम होता है।';
  }

  @override
  String yDrew13(String opponent, String score) {
    return '$opponent के ख़िलाफ़ मेहनत से कमाया अंक, $score। हमारी लड़ाई मुझे पसंद आई।';
  }

  @override
  String yDrew14(String opponent, String score) {
    return '$opponent $score। अंक बँट गए, जैसा पुराने कमेंटेटर कहा करते थे।';
  }

  @override
  String yDrew15(String opponent, String score) {
    return '$opponent के साथ $score। किसी भी टीम ने इससे ज़्यादा पाने लायक़ कुछ नहीं किया।';
  }

  @override
  String yDrew16(String opponent, String score) {
    return '$opponent के साथ $score। ऐसा ड्रॉ जो घर लौटती बस में हार जैसा लगता है।';
  }

  @override
  String yDrew17(String opponent, String score) {
    return '$opponent के साथ $score ड्रॉ। हम लगातार प्रगति की बात करते हैं और लगातार यही करते हैं।';
  }

  @override
  String yLost12(String opponent, String score) {
    return '$opponent से $score। दर्द होता है, लेकिन इस टीम पर भरोसा करने लायक़ काफ़ी कुछ देखा।';
  }

  @override
  String yLost13(String opponent, String score) {
    return '$opponent से $score से हारे, और वे अच्छे थे। मान लो और फिर से कोशिश करो।';
  }

  @override
  String yLost14(String opponent, String score) {
    return '$opponent $score। एक हार, कुछ सबक़, और अगला मैच जल्द ही।';
  }

  @override
  String yLost15(String opponent, String score) {
    return '$opponent से $score से हारे। बहस की गुंजाइश कम है।';
  }

  @override
  String yLost16(String opponent, String score) {
    return '$opponent से $score। पिछली बार वाली ही ग़लतियाँ, उसी आत्मविश्वास के साथ।';
  }

  @override
  String yLost17(String opponent, String score) {
    return '$opponent से $score से हारे। अगर इसके लिए कोई जवाबदेह नहीं, तो हम कर क्या रहे हैं?';
  }

  @override
  String get yReactionShrug12 =>
      'मेरे लिए ठीक है। हर रात आतिशबाज़ी ज़रूरी नहीं।';

  @override
  String get yReactionShrug13 => 'अंक तो अंक हैं। आज रात चैन की नींद।';

  @override
  String get yReactionShrug14 => 'देख लिया। कोई टिप्पणी नहीं।';

  @override
  String get yReactionShrug15 => 'ठीक-ठाक और ठीक-ठाक के बीच कहीं।';

  @override
  String get yReactionShrug16 =>
      'इसके लिए स्ट्रीम के पैसे दिए। अब कभी नहीं (फिर आऊँगा)।';

  @override
  String get yReactionShrug17 =>
      'नब्बे मिनट का फ़ुटबॉल जैसा दिखने वाला कुछ नहीं।';

  @override
  String get yReactionRelief12 => 'फिर से साँस आई। गर्व है कि वे टिके रहे।';

  @override
  String get yReactionRelief13 =>
      'ऐसी ही जीतें टीम बनाती हैं। बदसूरत भी ख़ूबसूरत है।';

  @override
  String get yReactionRelief14 => 'नाख़ून ख़त्म हो गए, अंक नहीं।';

  @override
  String get yReactionRelief15 => 'आख़िरी सीटी इतनी अच्छी कभी नहीं लगी।';

  @override
  String get yReactionRelief16 => 'जीत की ख़ुशी है, जीत के तरीक़े की चिंता।';

  @override
  String get yReactionRelief17 =>
      'हम हर बार बच निकलते हैं। एक दिन नहीं बचेंगे।';

  @override
  String get yReactionFury12 =>
      'मुझे इस टीम से प्यार है, और इसीलिए यह इतना चुभता है।';

  @override
  String get yReactionFury13 =>
      'बुरी रात। अगली बार वे हमारे कर्ज़दार हैं, और यह वे जानते हैं।';

  @override
  String get yReactionFury14 =>
      'सत्तरवें मिनट पर बंद कर दिया। साठवें पर कर देना चाहिए था।';

  @override
  String get yReactionFury15 => 'न लड़ाई, न आइडिया, न बहाने।';

  @override
  String get yReactionFury16 =>
      'हर बार वही समस्याएँ, और कोई कुछ ठीक नहीं करता।';

  @override
  String get yReactionFury17 =>
      'फ़ेडरेशन में किसी को यह दोबारा देखकर हमें समझाना चाहिए।';

  @override
  String get backupShareHint =>
      'सारे सेव की एक बैकअप फ़ाइल बनाता है। उसे रखने के लिए Google Drive, iCloud Drive या Files चुनें।';

  @override
  String backupLastAt(String date) {
    return 'आख़िरी बैकअप: $date';
  }

  @override
  String get backupNever => 'अभी तक कोई बैकअप नहीं';

  @override
  String get backupRemindersTitle => 'बैकअप रिमाइंडर';

  @override
  String get backupRemindersBlurb =>
      'जब आख़िरी बैकअप पुराना होने लगे, तो इनबॉक्स में एक संदेश।';

  @override
  String get backupAutoICloudTitle => 'अपने आप iCloud बैकअप';

  @override
  String get backupAutoDriveTitle => 'अपने आप Google Drive बैकअप';

  @override
  String get backupAutoBlurb =>
      'मैचों के बाद, साइकिल के अंत में और ऐप छोड़ते समय बैकअप लेता है। सबसे नए दो रखता है।';

  @override
  String get backupStatusUploading => 'बैकअप लिया जा रहा है।';

  @override
  String get backupStatusUploaded => 'बैकअप हो गया।';

  @override
  String get backupStatusICloudSignedOut =>
      'iCloud बंद है। सेटिंग्स ऐप में iCloud में साइन इन करें और iCloud Drive चालू करें।';

  @override
  String get backupStatusDriveSignedOut =>
      'साइन इन नहीं है। Google से साइन इन करने के लिए स्विच चालू करें।';

  @override
  String get backupStatusNotConfigured =>
      'ऐप के इस वर्ज़न में अभी उपलब्ध नहीं।';

  @override
  String get backupStatusUnavailable =>
      'अभी क्लाउड तक नहीं पहुँचा जा सकता। बाद में फिर कोशिश होगी।';

  @override
  String get backupStatusFailed =>
      'पिछला अपने आप वाला बैकअप पूरा नहीं हुआ। बाद में फिर कोशिश होगी।';

  @override
  String backupDriveSignedInAs(String email) {
    return '$email के रूप में साइन इन';
  }

  @override
  String get backupDriveSignOut => 'साइन आउट';

  @override
  String get backupDriveSignInFailed =>
      'Google साइन इन नहीं हो पाया। बाद में फिर कोशिश करें।';

  @override
  String get backupRestoreICloud => 'iCloud से रिस्टोर करें';

  @override
  String get backupRestoreDrive => 'Google Drive से रिस्टोर करें';

  @override
  String get backupCrossPlatformHelp =>
      'iPhone और Android के बीच बदल रहे हैं? एक फ़ोन पर फ़ाइल में बैकअप लें, फिर दूसरे पर उसी फ़ाइल से रिस्टोर करें।';

  @override
  String get backupCloudListBlurb =>
      'इस अकाउंट पर आपके डिवाइसों के बैकअप। रिस्टोर करने के लिए किसी एक पर टैप करें।';

  @override
  String get backupCloudListEmpty =>
      'अभी कोई बैकअप नहीं मिला। नए बैकअप को दूसरे डिवाइस तक पहुँचने में कुछ मिनट लग सकते हैं।';

  @override
  String get backupCloudListFailed =>
      'बैकअप पढ़े नहीं जा सके। कनेक्शन जाँचें और फिर कोशिश करें।';

  @override
  String get backupCloudThisDevice => 'यह डिवाइस';

  @override
  String backupCloudMore(int count) {
    return 'और सेव: $count';
  }

  @override
  String get backupCloudNewer => 'ऐप के नए वर्ज़न से बना है। पहले अपडेट करें।';

  @override
  String get backupCloudDownloading => 'बैकअप लाया जा रहा है।';

  @override
  String get backupRestoreSafetyNote =>
      'पहले इस फ़ोन के मौजूदा सेव की एक कॉपी इसी फ़ोन पर रख ली जाती है।';

  @override
  String get backupRejectedSafety =>
      'मौजूदा सेव की कॉपी नहीं रखी जा सकी, इसलिए कुछ भी नहीं बदला गया।';

  @override
  String get newsBackupReminderTitle => 'बैकअप का समय';

  @override
  String get newsBackupReminderBody =>
      'आपके सेव सिर्फ़ इसी फ़ोन पर हैं। सेटिंग्स खोलें और क्लाउड में बैकअप लें पर टैप करें, या वहीं अपने आप बैकअप चालू करें। ये रिमाइंडर भी सेटिंग्स में बंद किए जा सकते हैं।';

  @override
  String get backupSafetyTitle => 'रिस्टोर से पहले की कॉपियाँ';

  @override
  String get backupSafetyBlurb =>
      'अगर रिस्टोर ग़लत निकला, तो काम आने के लिए इसी फ़ोन पर रखी जाती हैं। सबसे नई तीन रखी जाती हैं।';

  @override
  String get backupSafetyRestore => 'रिस्टोर करें';

  @override
  String get backupSafetyShare => 'शेयर करें';

  @override
  String get backupCloudNoDetails => 'ब्योरा अभी आ रहा है।';

  @override
  String get tacticsLibraryTitle => 'टैक्टिक लाइब्रेरी';

  @override
  String get tacticsLibraryBlurb =>
      'लाइब्रेरी की टैक्टिक किसी भी सेव में लोड की जा सकती हैं, नए सेव में भी। रोल और सेट पीस लेने वाले खिलाड़ी के हिसाब से नहीं, पोज़िशन के हिसाब से सेव होते हैं।';

  @override
  String get tacticsSaveToLibrary => 'लाइब्रेरी में सेव करें';

  @override
  String get tacticsLoadFromLibrary => 'लाइब्रेरी से लोड करें';

  @override
  String get tacticsLibraryEmpty =>
      'आपकी लाइब्रेरी खाली है। यहाँ कोई टैक्टिक सेव करें, फिर उसे किसी भी सेव में लोड कर सकेंगे।';

  @override
  String tacticsLibrarySaved(String name) {
    return '“$name” लाइब्रेरी में सेव हुआ';
  }

  @override
  String tacticsLibraryLoaded(String name) {
    return '“$name” लोड हुआ';
  }

  @override
  String tacticsLibraryNotFitted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count रोल या सेट पीस टेकर इस स्क्वॉड में फ़िट नहीं हुए।',
      one: '1 रोल या सेट पीस टेकर इस स्क्वॉड में फ़िट नहीं हुआ।',
    );
    return '$_temp0';
  }

  @override
  String get tacticsLibraryRename => 'नाम बदलें';

  @override
  String get tacticsLibraryRenameTitle => 'टैक्टिक का नाम बदलें';

  @override
  String get tacticsLibraryDelete => 'हटाएँ';

  @override
  String tacticsLibraryDeleteTitle(String name) {
    return '“$name” हटाएँ?';
  }

  @override
  String get tacticsLibraryDeleteBody =>
      'यह आपके सभी सेव में लाइब्रेरी से हट जाएगा।';

  @override
  String get tacticsLibraryNameTaken =>
      'आपकी लाइब्रेरी में इस नाम की टैक्टिक पहले से है।';

  @override
  String tacticsLibraryCouldNotLoad(String error) {
    return 'लाइब्रेरी लोड नहीं हो सकी।\n$error';
  }

  @override
  String hostBidHeading(String competition, int year) {
    return 'मेज़बानी की दावेदारी: $competition $year';
  }

  @override
  String get hostBidScreenTitle => 'मेज़बानी की दावेदारी';

  @override
  String get hostBidBlurb =>
      'मेज़बान का चुनाव उम्मीदवारों के बीच ड्रॉ से होता है। दावेदारी आपके नाम को ज़्यादा वज़न देती है: आपके स्टेडियम शुरुआती मौका देते हैं और पैसा उसे बढ़ाता है, हालाँकि हर अतिरिक्त मिलियन का असर थोड़ा कम होता है। आप जीतें या न जीतें, पैसा खर्च हो जाता है।';

  @override
  String hostBidPrize(String amount) {
    return 'जीतने पर आप मेज़बानी करेंगे, अपने आप क्वालिफ़ाई करेंगे और अगले बजट के लिए $amount का एकमुश्त अनुदान पाएँगे।';
  }

  @override
  String get hostBidChance => 'मेज़बानी का मौका';

  @override
  String get hostBidBaseLabel => 'स्टेडियम और स्थिति';

  @override
  String get hostBidInvestLabel => 'निवेश';

  @override
  String hostBidCeiling(String nation, String percent) {
    return '$nation की अधिकतम सीमा: $percent';
  }

  @override
  String get hostBidInvestment => 'आपका निवेश';

  @override
  String hostBidFreeFunds(String amount) {
    return 'खाली धनराशि: $amount';
  }

  @override
  String get hostBidSubmit => 'दावेदारी पेश करें';

  @override
  String get hostBidDecline => 'इस बार नहीं';

  @override
  String get hostBidUnavailable => 'यह दावेदारी अब खुली नहीं है।';

  @override
  String hostBidWonTitle(String competition, int year) {
    return 'दावेदारी सफल: $competition $year';
  }

  @override
  String hostBidWonBody(String amount) {
    return 'हम टूर्नामेंट की मेज़बानी करेंगे और मेज़बान के रूप में अपने आप क्वालिफ़ाई करेंगे। $amount का एकमुश्त अनुदान अब महासंघ के कोष में है, और आप उसे मुख्य स्क्रीन से सीधे इस चक्र के विभागों में बाँट सकते हैं।';
  }

  @override
  String hostBidLostTitle(String competition, int year) {
    return 'दावेदारी असफल: $competition $year';
  }

  @override
  String hostBidLostBody(String hosts) {
    return 'मेज़बानी का अधिकार मिला: $hosts। इस बार हमारी दावेदारी कम पड़ गई और उस पर खर्च हुआ पैसा चला गया, लेकिन महासंघ ने अपनी बात रखी।';
  }

  @override
  String get hostBidGrantEvent => 'मेज़बानी अनुदान बाँटें';

  @override
  String hostBidGrantBanner(String amount) {
    return 'मेज़बानी अनुदान: $amount जिसे आप अभी इस चक्र के विभागों में जोड़ सकते हैं। जो पहले बाँटा जा चुका है वह बना रहेगा, और बचा हुआ पैसा कोष में रहेगा।';
  }

  @override
  String get stadiumsTitle => 'राष्ट्रीय स्टेडियम';

  @override
  String get stadiumsEntrySub => 'किसी स्टेडियम को बेहतर बनाएँ या नया बनवाएँ';

  @override
  String get stadiumsBlurb =>
      'स्टेडियम का स्तर उसका आकार है: स्तर 1 यानी 15,000 से कम सीटें, स्तर 2 15,000 से, स्तर 3 25,000 से, स्तर 4 40,000 से, स्तर 5 60,000 से। हर स्टेडियम हर चक्र की शुरुआत में थोड़ी आय देता है, जितनी ज़्यादा सीटें उतनी ज़्यादा, जब तक दर्शक उन्हें भर सकें। अपग्रेड तुरंत सीटें जोड़ता है और अगले चक्र से थोड़ी साख भी; छोटा करने से रखरखाव घटता है, पर कुछ वापस नहीं मिलता। आपके स्टेडियम तय करते हैं कि आप किन टूर्नामेंटों की मेज़बानी की दावेदारी कर सकते हैं।';

  @override
  String stadiumsIncome(String amount) {
    return 'स्टेडियमों से आमदनी: हर चक्र $amount';
  }

  @override
  String stadiumsReputation(int points) {
    return 'स्टेडियमों से प्रतिष्ठा: +$points';
  }

  @override
  String get stadiumsClosed =>
      'निर्माण कार्य चक्र की शुरुआत में, बजट तय होने से पहले दिए जाते हैं।';

  @override
  String stadiumsCapacity(String seats) {
    return 'क्षमता: $seats';
  }

  @override
  String stadiumsLevel(int level, int max) {
    return 'स्तर $level/$max';
  }

  @override
  String stadiumsUpgrade(String cost) {
    return 'सुधारें: $cost';
  }

  @override
  String get stadiumsTopLevel => 'सर्वोच्च स्तर';

  @override
  String stadiumsOpens(int year) {
    return 'निर्माणाधीन, $year में खुलेगा';
  }

  @override
  String get stadiumsBuildTitle => 'नया स्टेडियम बनवाएँ';

  @override
  String get stadiumsBuildBody =>
      'काफ़ी महँगा: आपके चुने शहर में नया स्टेडियम, अगले चक्र की शुरुआत से खुला।';

  @override
  String get stadiumsBuildCity => 'शहर';

  @override
  String stadiumsBuildButton(String cost) {
    return 'बनवाएँ: $cost';
  }

  @override
  String get stadiumsBuilding => 'एक स्टेडियम पहले से बन रहा है।';

  @override
  String get stadiumsNoCity => 'हर शहर में पहले से नया स्टेडियम है।';

  @override
  String stadiumsConfirmUpgrade(String stadium, int level, String cost) {
    return '$stadium को $cost में स्तर $level तक सुधारें?';
  }

  @override
  String stadiumsConfirmBuild(String city, String cost) {
    return '$city में $cost में नया स्टेडियम बनवाएँ?';
  }

  @override
  String get stadiumsConfirm => 'पुष्टि करें';

  @override
  String get stadiumsCancel => 'रद्द करें';

  @override
  String get stadiumsRefused => 'ऑर्डर पूरा नहीं हुआ। कोई पैसा नहीं कटा।';

  @override
  String get stadiumsNameLabel => 'स्टेडियम का नाम';

  @override
  String get stadiumsNameHint =>
      'सुझाया गया नाम रखने के लिए इसे ख़ाली छोड़ दें।';

  @override
  String get stadiumsRename => 'स्टेडियम का नाम बदलें';

  @override
  String get hostBidSectionTitle => 'मेज़बानी की दावेदारियाँ';

  @override
  String get hostBidOpenSub =>
      'वैकल्पिक। नया चक्र शुरू होने से पहले फ़ैसला करें।';

  @override
  String get hostBidDecidedAtRollover =>
      'मेज़बान की घोषणा नया चक्र शुरू होते ही होगी।';

  @override
  String get hostBidLodged =>
      'दावेदारी दर्ज हुई। मेज़बान की घोषणा नया चक्र शुरू होते ही होगी।';

  @override
  String get hostBidDeclinedNote =>
      'इस बार आपने दावेदारी न करने का फ़ैसला किया।';

  @override
  String get hostBidOpensLater =>
      'आप योग्य हैं। इस चक्र के अंत में दावेदारी कर सकते हैं।';

  @override
  String get hostBidNoFunds => 'दावेदारी के लिए पर्याप्त खाली धनराशि नहीं है।';

  @override
  String hostBidNeedStadiums(int count, String seats) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'आपको $seats+ सीटों वाले $count और स्टेडियम चाहिए।',
      one: 'आपको $seats+ सीटों वाला 1 और स्टेडियम चाहिए।',
    );
    return '$_temp0';
  }

  @override
  String hostBidBarredConf(String confederation) {
    return 'पिछली विश्व चैंपियनशिप की मेज़बानी $confederation ने की थी।';
  }

  @override
  String get hostBidRecentHost =>
      'आपने पिछले तीन संस्करणों में से एक की मेज़बानी की थी।';

  @override
  String hostBidRequirement(
    int grounds,
    String minSeats,
    int bigGrounds,
    String bigSeats,
  ) {
    return 'शर्त: $minSeats+ सीटों वाले $grounds स्टेडियम, जिनमें $bigGrounds में $bigSeats+ सीटें हों।';
  }

  @override
  String hostBidWonBodyBudget(String amount) {
    return 'हम टूर्नामेंट की मेज़बानी करेंगे और मेज़बान के तौर पर अपने आप क्वालिफ़ाई करते हैं। $amount का एकमुश्त अनुदान फ़ेडरेशन की धनराशि में आ चुका है, इस चक्र के बजट के लिए तैयार।';
  }

  @override
  String get hubStadiumIncome => 'स्टेडियम आय';

  @override
  String get stadiumsDownsize => 'छोटा करें';

  @override
  String stadiumsConfirmDownsize(String stadium, String seats, int level) {
    return '$stadium को $seats सीटों (स्तर $level) तक छोटा करें? कुछ वापस नहीं मिलेगा, पर रखरखाव का खर्च घटेगा।';
  }

  @override
  String get stadiumsResizedThisCycle => 'इस चक्र में दोबारा बनाया गया';

  @override
  String stadiumsGroundIncome(String amount) {
    return 'हर चक्र $amount कमाता है';
  }

  @override
  String hostBidLapsedTitle(String competition, int year) {
    return 'दावेदारी वापस ली गई: $competition $year';
  }

  @override
  String hostBidLapsedBodyNation(String nation) {
    return 'दावेदारी $nation के लिए की गई थी, पर नया चक्र आप कहीं और शुरू कर रहे हैं। इसे वापस ले लिया गया और कुछ नहीं काटा गया।';
  }

  @override
  String get hostBidLapsedBodyFunds =>
      'चक्र बंद होने पर फ़ेडरेशन की धनराशि दाँव के लिए काफ़ी नहीं रही। दावेदारी वापस ले ली गई और कुछ नहीं काटा गया।';

  @override
  String get stadiumsViewMap => 'नक्शा';

  @override
  String get stadiumsViewList => 'सूची';

  @override
  String get stadiumsMapPickCity =>
      'नया स्टेडियम बनाने के लिए किसी शहर पर टैप करें।';

  @override
  String get stadiumsMapFit => 'पूरा देश दिखाएँ';

  @override
  String get campaignLegacyTitle => 'विरासत पूरी करें';

  @override
  String get campaignLegacyTwist =>
      'स्पेन, मौजूदा यूरोपीय चैंपियन, एक चक्र के लिए';

  @override
  String get campaignLegacyGoal => 'यूरोपीय ख़िताब बचाएँ';

  @override
  String get campaignLegacyIntro =>
      'स्पेन मौजूदा यूरोपीय चैंपियन है, और शक करने वाले कहते हैं कि यह सुनहरा दौर एक तुक्का था। आपके पास एक चक्र है यह साबित करने के लिए कि ऐसा नहीं था: महाद्वीप का ताज बचाएँ, फिर दुनिया जीतने निकलें। नेशंस कप भी जोड़ दें और विरासत पूरी हो जाएगी।';

  @override
  String get campaignStars1Legacy => 'यूरोपीय चैंपियनशिप जीतें';

  @override
  String get campaignStars2Legacy => 'और विश्व चैंपियनशिप';

  @override
  String get campaignStars3Legacy => 'और नेशंस कप';

  @override
  String get campaignSectionOneCycle => 'एक चक्र';

  @override
  String get campaignSectionShort => 'कुछ चक्र';

  @override
  String get campaignSectionLong => 'लंबा सफ़र';

  @override
  String get campaignFilterAll => 'सभी';

  @override
  String get campaignFilterNew => 'नहीं खेले';

  @override
  String get campaignFilterInProgress => 'जारी';

  @override
  String get campaignFilterDone => 'पूरे';

  @override
  String get campaignFilterEmpty => 'यहाँ अभी कोई अभियान नहीं है।';

  @override
  String campaignStarsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count सितारे',
      one: '1 सितारा',
      zero: 'कोई सितारा नहीं',
    );
    return '$_temp0';
  }

  @override
  String campaignCycles(int cycles) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles चक्र',
      one: '$cycles चक्र',
    );
    return '$_temp0';
  }

  @override
  String get msgIntlRetireNoteHigh =>
      ' वे शिखर पर, चैंपियन बनकर विदा हो रहे हैं।';

  @override
  String get msgIntlRetireNoteMissed =>
      ' फ़ाइनल्स में जगह न बना पाना आख़िरी तिनका साबित हुआ।';

  @override
  String get msgIntlRetireNoteSurprise => ' किसी ने इसकी उम्मीद नहीं की थी।';

  @override
  String get msgIntlRetireNoteRecord =>
      ' वे राष्ट्रीय रिकॉर्डधारी के रूप में विदा हो रहे हैं।';

  @override
  String msgIntlRetireNewsTitle(String nation, String name) {
    return '$nation: $name का अंतरराष्ट्रीय फ़ुटबॉल से संन्यास';
  }

  @override
  String msgIntlRetireNewsBody(String name, String nation, int age) {
    return '$name ($nation) ने $age साल की उम्र में अंतरराष्ट्रीय फ़ुटबॉल से संन्यास की घोषणा की है।';
  }

  @override
  String msgIntlComebackTitle(String name) {
    return '$name की अंतरराष्ट्रीय संन्यास से वापसी';
  }

  @override
  String msgIntlComebackBody(String name, int age) {
    return '$name $age साल की उम्र में फिर से चयन के लिए उपलब्ध हैं।';
  }

  @override
  String get msgIntlComebackNoteCrisis =>
      ' चोटों से जूझ रहे दल की पुकार पर वे लौट आए हैं।';

  @override
  String get msgIntlComebackNoteManager => ' नए मैनेजर ने उन्हें मना लिया।';

  @override
  String msgIntlComebackNewsTitle(String nation, String name) {
    return '$nation: $name की अंतरराष्ट्रीय संन्यास से वापसी';
  }

  @override
  String msgIntlComebackNewsBody(String name, String nation, int age) {
    return '$name ($nation) $age साल की उम्र में फिर से चयन के लिए उपलब्ध हैं।';
  }

  @override
  String playerIntlRetired(int year) {
    return 'अंतरराष्ट्रीय फ़ुटबॉल से संन्यास, $year';
  }

  @override
  String playerIntlComeback(int year) {
    return 'अंतरराष्ट्रीय संन्यास से वापसी, $year';
  }

  @override
  String yLegendRetires0(String name) {
    return 'शुक्रिया, $name। कुछ लोग जर्सी पहनते हैं, इन्होंने टीम को कंधों पर उठाया।';
  }

  @override
  String yLegendRetires1(String name) {
    return '$name ने अंतरराष्ट्रीय करियर को अलविदा कहा। एक युग का अंत।';
  }

  @override
  String yLegendRetires2(String name) {
    return '$name का संन्यास। सच कहें तो एक टूर्नामेंट देर से।';
  }

  @override
  String yLegendRetires3(String name) {
    return 'तो $name का सफ़र ख़त्म। अब युवाओं को मौका दो।';
  }

  @override
  String matchAltitudeOpponentsTire(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'ऊँचाई $altitudeString मी: विरोधी टीम जल्दी थकेगी';
  }

  @override
  String matchAltitudeYouTire(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'ऊँचाई $altitudeString मी: आपके खिलाड़ी जल्दी थकेंगे';
  }

  @override
  String matchAltitudeBothTire(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'ऊँचाई $altitudeString मी: दोनों टीमें जल्दी थकेंगी';
  }

  @override
  String matchAltitudeUsedTo(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'ऊँचाई $altitudeString मी: दोनों टीमें इसकी आदी हैं';
  }

  @override
  String matchHeatExpected(int temp) {
    final intl.NumberFormat tempNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String tempString = tempNumberFormat.format(temp);

    return 'गर्मी: $tempString°C की उम्मीद, दम जल्दी टूटेगा';
  }

  @override
  String get matchConditionsAdvice =>
      'बदलाव जल्दी तय करें: यहाँ ताज़ा पैर ज़्यादा मायने रखते हैं';

  @override
  String get fanMoodFurious => 'आगबबूला';

  @override
  String get fanMoodRestless => 'बेचैन';

  @override
  String get fanMoodCalm => 'शांत';

  @override
  String get fanMoodUpbeat => 'उत्साहित';

  @override
  String get fanMoodEuphoric => 'जश्न में';

  @override
  String matchHomeFans(String mood) {
    return 'घरेलू प्रशंसक: $mood';
  }

  @override
  String federationFans(String mood) {
    return 'प्रशंसक: $mood';
  }

  @override
  String federationFansIncome(String change) {
    return 'अगले चक्र में स्टेडियम आय: $change';
  }

  @override
  String yFansProtest0(String nation, String manager) {
    return 'बीस साल से घर और बाहर, हर जगह राष्ट्रीय टीम के पीछे गया हूँ। जब तक कुछ नहीं बदलता, सीज़न टिकट रिन्यू नहीं करूँगा।';
  }

  @override
  String yFansProtest1(String nation, String manager) {
    return 'हम जर्सी के लिए गाते रहेंगे। लेकिन आज रात नॉर्थ स्टैंड के बैनर ने वही कहा जो हम सब सोच रहे हैं।';
  }

  @override
  String yFansProtest2(String nation, String manager) {
    return 'आधा स्टेडियम खाली, और जो आधे आए वे पूरा दूसरा हाफ़ #${manager}Out के नारे लगाते रहे।';
  }

  @override
  String yFansProtest3(String nation, String manager) {
    return 'समर्थक समूह अगले घरेलू मैच के बहिष्कार की बात कर रहे हैं। उन्हें दोष देना मुश्किल है।';
  }

  @override
  String yFansProtest4(String nation, String manager) {
    return '#${manager}Out। अब गुस्सा भी नहीं है। बस, बहुत हुआ।';
  }

  @override
  String yFansProtest5(String nation, String manager) {
    return 'आज रात की तस्वीर: खाली सीटों की कतारें और एक चादर जिस पर लिखा है #${manager}Out। यही मैच रिपोर्ट है।';
  }

  @override
  String yFansSellOut0(String nation) {
    return 'फिर से हाउसफ़ुल। बरसों की सबसे अच्छी राष्ट्रीय टीम, और पूरा देश यह जानता है।';
  }

  @override
  String yFansSellOut1(String nation) {
    return 'अगले घरेलू मैच के टिकट ग्यारह मिनट में बिक गए। इस टीम ने हमें हमारे वीकेंड लौटा दिए।';
  }

  @override
  String yFansSellOut2(String nation) {
    return 'अगले घरेलू मैच के लिए एक भी सीट खाली नहीं। फ़ेडरेशन मुस्कुराते हुए टिकटों की कमाई गिनेगा।';
  }

  @override
  String yFansSellOut3(String nation) {
    return 'एक और हाउसफ़ुल। रणनीति के बारे में जो चाहे कहिए, लोग उस स्टेडियम में होना चाहते हैं।';
  }

  @override
  String yFansSellOut4(String nation) {
    return 'हाउसफ़ुल, ठीक है। यही लोग डेढ़ साल पहले इस टीम की हूटिंग कर रहे थे।';
  }

  @override
  String yFansSellOut5(String nation) {
    return 'अचानक हाउसफ़ुल, अचानक सब विशेषज्ञ। जब हम किसी को हरा नहीं पा रहे थे, तब आप सब कहाँ थे?';
  }

  @override
  String get campaignsIntro =>
      'अभियान खास तौर पर बनाई गई चुनौतियाँ हैं: एक तय राष्ट्रीय टीम, अपने अलग मोड़ वाली दुनिया और एक लक्ष्य जिसे तय चक्रों में हासिल करना है। हर अभियान आपके सहेजे गए करियर से अलग चलता है, और आप जितना आगे जाएँगे, उतने ज़्यादा सितारे मिलेंगे, अधिकतम तीन।';

  @override
  String hubEventScandal(String player) {
    return 'कैंप में विवाद: $player';
  }

  @override
  String get hubEventScandalSub => 'उसे घर भेजें या टीम में रखें?';

  @override
  String get scandalTitle => 'विवाद';

  @override
  String scandalStoryParty(String player) {
    return '$player सुबह तक चली एक पार्टी में थे, और जिस सुबह टीम इकट्ठा हुई, उनकी तस्वीरें हर अख़बार में थीं।';
  }

  @override
  String scandalStoryCurfew(String player) {
    return '$player ने टीम का कर्फ़्यू तोड़ा और तड़के होटल लौटते हुए पकड़े गए।';
  }

  @override
  String scandalStoryNightclub(String player) {
    return 'कैंप से एक रात पहले $player की नाइटक्लब में तस्वीरें खिंचीं, और वे हर जगह फैल चुकी हैं।';
  }

  @override
  String scandalStoryCasino(String player) {
    return '$player ने कैंप से पहले की रात कैसीनो की मेज़ पर बिताई, और एक टैब्लॉयड के पास तस्वीरें हैं।';
  }

  @override
  String get scandalSendHome => 'उसे घर भेजें';

  @override
  String scandalSendHomeCover(String player) {
    return 'घर भेजें, बुलाएँ: $player';
  }

  @override
  String scandalKeep(String player) {
    return 'टीम में रखें: $player';
  }

  @override
  String get scandalKeepNote =>
      'टीम में रखा तो: चक्र के अंत तक मनोबल लगभग -4 और बोर्ड लगभग -3।';

  @override
  String get scandalSendHomeNote =>
      'घर भेजा तो: मनोबल या बोर्ड पर कोई असर नहीं, और आप एक रिप्लेसमेंट बुला सकते हैं।';

  @override
  String get scandalFinalsNote =>
      'घर भेजा तो: मनोबल या बोर्ड पर कोई असर नहीं, लेकिन फ़ाइनल टूर्नामेंट में उसकी जगह कोई नहीं आ सकता।';

  @override
  String get scandalPickCover => 'रिप्लेसमेंट बुलाएँ (वैकल्पिक)';

  @override
  String newsScandalTitle(String player) {
    return 'कैंप में विवाद: $player';
  }

  @override
  String yScandalParty0(String player, String tag) {
    return 'जवान लड़के हैं। कैंप से पहले की रात $player पार्टी में थे, फिर भी मैं उन्हें मैदान पर देखना चाहता हूँ। #$tag';
  }

  @override
  String yScandalParty1(String player, String tag) {
    return 'टीम के इकट्ठा होने से कुछ घंटे पहले $player रात भर चली पार्टी में दिखे। फ़ेडरेशन को सूचना दे दी गई है। #$tag';
  }

  @override
  String yScandalParty2(String player, String tag) {
    return 'कैंप से पहले रात भर पार्टी। $player, आप क्या सोच रहे थे? अविश्वसनीय। #$tag';
  }

  @override
  String yScandalCurfew0(String player, String tag) {
    return 'कर्फ़्यू के बाद लौटे, ठीक है, होता है। $player को बस मैदान पर इसकी भरपाई करनी है। #$tag';
  }

  @override
  String yScandalCurfew1(String player, String tag) {
    return 'ट्रेनिंग से कुछ घंटे पहले $player कर्फ़्यू के बाद टीम होटल लौटते हुए पकड़े गए। #$tag';
  }

  @override
  String yScandalCurfew2(String player, String tag) {
    return 'कर्फ़्यू कोई मुश्किल चीज़ नहीं। $player एक रात भी नहीं टिक पाए। #$tag';
  }

  @override
  String yScandalNightclub0(String player, String tag) {
    return 'तो $player क्लब गए थे। फ़ुटबॉलरों की भी ज़िंदगी होती है। उन्हें खेलने दो। #$tag';
  }

  @override
  String yScandalNightclub1(String player, String tag) {
    return 'तस्वीरों में राष्ट्रीय टीम के कैंप से एक रात पहले $player नाइटक्लब में दिख रहे हैं। #$tag';
  }

  @override
  String yScandalNightclub2(String player, String tag) {
    return 'कैंप से एक रात पहले क्लब की तस्वीरें। $player ने जर्सी को शर्मिंदा कर दिया। #$tag';
  }

  @override
  String yScandalCasino0(String player, String tag) {
    return 'कैसीनो में एक रात कोई अपराध नहीं है। $player ठीक रहेंगे। #$tag';
  }

  @override
  String yScandalCasino1(String player, String tag) {
    return 'टीम के इकट्ठा होने से पहले की रात $player कैसीनो की मेज़ पर देखे गए। #$tag';
  }

  @override
  String yScandalCasino2(String player, String tag) {
    return 'कैंप से पहले पूरी रात कैसीनो में। $player ने पैसों से ज़्यादा दाँव पर लगा दिया। #$tag';
  }

  @override
  String yScandalSentHome0(String player) {
    return 'सही फ़ैसला। टीम से बड़ा कोई नहीं, $player भी नहीं।';
  }

  @override
  String yScandalSentHome1(String player) {
    return '$player को घर भेजना ही एकमात्र जवाब था। कोच को सलाम।';
  }

  @override
  String yScandalSentHome2(String player) {
    return 'अनुशासन तो अनुशासन है। $player नियम जानते थे।';
  }

  @override
  String yScandalSentHome3(String player) {
    return 'टीम को साफ़ संदेश: $player घर की फ़्लाइट में हैं।';
  }

  @override
  String yScandalSentHome4(String player) {
    return '$player के साथ सख़्ती हुई। एक रात बाहर गए और कैंप ख़त्म?';
  }

  @override
  String yScandalSentHome5(String player) {
    return '$player को घर भेजने से हम कमज़ोर हुए। इसकी क़ीमत मैदान पर चुकाएँगे।';
  }

  @override
  String yScandalKept0(String player) {
    return '$player को रखना एक जुआ है। बेहतर है कि वे मैदान पर इसका बदला चुकाएँ।';
  }

  @override
  String yScandalKept1(String player) {
    return 'ठीक है, $player रहेंगे। तो फिर वे सबको एक दमदार प्रदर्शन के कर्ज़दार हैं।';
  }

  @override
  String yScandalKept2(String player) {
    return 'तो $player पर नियम लागू नहीं होते। जानकर अच्छा लगा।';
  }

  @override
  String yScandalKept3(String player) {
    return 'लगता है कर्फ़्यू अब वैकल्पिक है। $player से पूछ लो।';
  }

  @override
  String yScandalKept4(String player) {
    return 'इसके बाद भी $player को रखना? यह टीम छुट्टियों का कैंप बन गई है।';
  }

  @override
  String yScandalKept5(String player) {
    return 'रात भर पार्टी, फिर सीधे शुरुआती एकादश में। बढ़िया संदेश, कोच। $player तो बहुत ख़ुश होंगे।';
  }

  @override
  String get yStreamerBreaks0 =>
      'भाई पकड़ा गया 😭😭 कैंप से पहले की रात?? मैं रो रहा हूँ 💀💀💀';

  @override
  String get yStreamerBreaks1 =>
      'नहींईई चैट ये देखो 🤯🤯 भाई ने सच में कैंप से पहले ये कर दिया 😭🔥';

  @override
  String get yStreamerBreaks2 =>
      'इसे बाहर किसने जाने दिया?? किसने जाने दिया 😭😭💀 ये तो सिनेमा है 🔥🔥';

  @override
  String get yStreamerSentHome0 =>
      'घर?? घर भेज दिया!!! 😭😭😭 कोच मज़ाक नहीं कर रहा 💀🔥';

  @override
  String get yStreamerSentHome1 =>
      'भाई लाइव बैग पैक कर रहा है 🤯🤯 अलविदा भाई 😭👋';

  @override
  String get yStreamerSentHome2 =>
      'हो ही नहीं सकताआआ उसे घर भेज दिया 💀💀 चैट मैं काँप रहा हूँ 🔥🔥🔥';

  @override
  String get yStreamerKept0 =>
      'रुक रहा है??? रुक रहा हैएए 🤯🤯 भाई को कोई छू नहीं सकता 😭🔥';

  @override
  String get yStreamerKept1 =>
      'रात भर पार्टी और अब भी टीम में 💀💀 मुझे भी वो कॉन्ट्रैक्ट चाहिए 😭😭';

  @override
  String get yStreamerKept2 => 'कोच ने कहा सब ठीक है 😭😭 भाई क्या 🤯🤯🤯';

  @override
  String get yCameoUjfaloci =>
      'मैंने कुछ नहीं चुकाया, और वह रक़म भी मेल नहीं खाती';

  @override
  String get yCameoHavir0 => 'छोटी मछलियाँ तैरकर निकल गईं।';

  @override
  String get yCameoHavir1 => 'हमने जाल डाले, मछलियाँ कहीं और थीं।';

  @override
  String get yCameoHavir2 =>
      'मैंने तो सितंबर में ही गुलाश खाते हुए कह दिया था।';

  @override
  String get yCameoHavir3 => 'जिसने वक़्त पर मछली नहीं पकड़ी, वह अब न रोए।';

  @override
  String get yCameoHavir4 => 'हम सूखी ज़मीन पर पड़ी कैटफ़िश की तरह खेले।';

  @override
  String get yCameoHavir5 => 'हवा चलती है, तालाब जमता है। यही होता है।';

  @override
  String get yCameoHavir6 => 'कुछ दिन हाथ बस एक पुराना जूता आता है।';

  @override
  String get yCameoHavir7 =>
      'हमारे ज़माने में कम से कम बीयर पीने तो जाते थे। अब वह भी नहीं।';

  @override
  String get yCameoLzimberskyHome0 =>
      'एक रात के लिए लड़के को घर भेज देना? असली विवाद यह है, पार्टी नहीं!';

  @override
  String get yCameoLzimberskyHome1 =>
      'लड़कों को थोड़ा मज़ा करने का हक़ है! पाखंडी मीडिया फिर जीत गया।';

  @override
  String get yCameoLzimberskyHome2 =>
      'यह तो डायन-शिकार है। एक जवान लड़का एक रात बाहर गया और आपने उसे फाँसी पर चढ़ा दिया।';

  @override
  String get yCameoLzimberskyHome3 =>
      'जो पत्रकार कभी पार्टी में नहीं गया, वह पहला पत्थर फेंके। शर्मनाक!';

  @override
  String get yCameoLzimberskyHome4 =>
      'कोच टैब्लॉयड से डर गया। मैं तो आख़िरी साँस तक लड़के का बचाव करता!';

  @override
  String get yCameoLzimberskyKept0 =>
      'आख़िरकार रीढ़ वाला कोच! उसने लड़के को रखा, मीडिया रोता रहे।';

  @override
  String get yCameoLzimberskyKept1 =>
      'लड़कों को थोड़ा मज़ा करने का हक़ है, है न? शाबाश, कोच!';

  @override
  String get yCameoLzimberskyKept2 =>
      'पाखंडी मीडिया चिल्ला रहा है, कोच डटा हुआ है। ऐसे होता है काम!';

  @override
  String get yCameoLzimberskyKept3 =>
      'एक रात बाहर गया और प्रेस उसे पत्थर मारना चाहता है। कोच असली मर्द है!';

  @override
  String get yCameoLzimberskyKept4 =>
      'मैं कहता हूँ: लड़कों को जीने दो! जो मेहनत करता है, वह मज़ा भी कर सकता है। अंगूठा ऊपर।';

  @override
  String get yTraitStreamer =>
      'सब कुछ स्ट्रीम करता है, पूरी आवाज़ में, बड़े अक्षरों में।';

  @override
  String hubEventAwardsCeremony(int year) {
    return 'प्लेयर ऑफ़ द ईयर $year';
  }

  @override
  String get hubEventAwardsCeremonySub => 'वोटों की गिनती पूरी';

  @override
  String get potyCeremonyWatch => 'समारोह देखें';

  @override
  String get potyCeremonySkipToList => 'सीधे टॉप 5 पर जाएँ';

  @override
  String get potyCeremonySkip => 'छोड़ें';

  @override
  String get potyCeremonyIntro =>
      'वोटों की गिनती पूरी हो गई। ये हैं इस साल दुनिया के पाँच सबसे बेहतरीन खिलाड़ी।';

  @override
  String potyCeremonyPlace(int place) {
    return 'स्थान $place';
  }

  @override
  String get potyCeremonyWinnerIs => 'और प्लेयर ऑफ़ द ईयर हैं...';

  @override
  String get potyTop5Heading => 'दुनिया के टॉप 5';

  @override
  String get potyYoungTop3Heading => 'यंग प्लेयर ऑफ़ द ईयर: टॉप 3';

  @override
  String get potySeeTop5 => 'टॉप 5 देखें';

  @override
  String get potyYourPlayer => 'आपका खिलाड़ी';

  @override
  String potyTallyCleanSheets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count क्लीन शीट',
      one: '$count क्लीन शीट',
    );
    return '$_temp0';
  }

  @override
  String get campaignFullBrief => 'पूरा ब्रीफ़';

  @override
  String campaignStarsSoFar(int earned, int total) {
    return 'अब तक मिले सितारे: $total में से $earned';
  }

  @override
  String get campaignStarEarned => 'अब तक मिला';

  @override
  String get campaignStarNotYet => 'अभी नहीं मिला';

  @override
  String get stadiumsEntrySubClosed =>
      'अपने स्टेडियम देखें। निर्माण कार्य अगले चक्र की शुरुआत में फिर खुलेंगे।';

  @override
  String get boardObjectiveNoBrief => 'कोई लक्ष्य तय नहीं';

  @override
  String get boardObjectiveNoBriefBody =>
      'बोर्ड को उम्मीद नहीं है कि आप इस फ़ाइनल टूर्नामेंट तक पहुँचेंगे। वह आपको आपके नतीजों से आँकेगा।';

  @override
  String get boardObjectiveAwaitingDraw => 'ड्रॉ के बाद लक्ष्य';

  @override
  String get boardObjectiveAwaitingDrawBody =>
      'समूहों का ड्रॉ होते ही बोर्ड यह लक्ष्य तय करेगा।';
}
