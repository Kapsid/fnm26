// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get matchPreviewTitle => 'พรีวิวเกม';

  @override
  String get matchKickOff => 'เริ่มเกม';

  @override
  String get matchTactics => 'แทคติก';

  @override
  String get matchYourXi => '11 ตัวจริงของคุณ';

  @override
  String get matchHeadToHead => 'สถิติการพบกัน';

  @override
  String matchCouldNotLoad(String error) {
    return 'โหลดข้อมูลเกมไม่ได้\n$error';
  }

  @override
  String get matchNoUpcoming => 'ไม่มีเกมที่กำลังจะมาถึง';

  @override
  String get matchUnknownNation => 'ไม่ทราบ';

  @override
  String get matchH2hFirstMeeting => 'พบกันครั้งแรก';

  @override
  String get matchH2hYouLead => 'คุณมีสถิติเหนือกว่า';

  @override
  String matchH2hOppEdge(String opponent) {
    return '$opponent มีสถิติเหนือกว่า';
  }

  @override
  String get matchH2hEven => 'สถิติสูสีกัน';

  @override
  String matchH2hMet(int count) {
    return 'พบกัน $count ครั้ง';
  }

  @override
  String get matchH2hWon => 'ชนะ';

  @override
  String get matchH2hDrawn => 'เสมอ';

  @override
  String get matchH2hLost => 'แพ้';

  @override
  String get matchDossierTitle => 'รายงานแมวมอง';

  @override
  String get matchDossierForm => 'ฟอร์ม';

  @override
  String get matchDossierNoGames => 'ไม่มีผลการแข่งขันล่าสุด';

  @override
  String get matchDossierKeyMen => 'ผู้เล่นตัวอันตราย';

  @override
  String get matchDossierHowTheyPlay => 'สไตล์การเล่น';

  @override
  String matchScoutFormation1(String formation) {
    return 'พวกเขามักลงสนามด้วยแผน $formation';
  }

  @override
  String matchScoutFormation2(String formation) {
    return 'แผนการเล่นหลักของพวกเขาคือ $formation';
  }

  @override
  String matchScoutFormation3(String formation) {
    return 'พวกเขามักจัดทีมด้วยแผน $formation';
  }

  @override
  String get matchScoutStrengthPressing => 'พวกเขาเพรสซิ่งสูงและไล่แย่งบอลตลอด';

  @override
  String get matchScoutStrengthDirect =>
      'พวกเขาเล่นบอลไดเร็กต์ เติมบอลขึ้นหน้าเร็ว';

  @override
  String get matchScoutStrengthPossession =>
      'พวกเขาครองบอลได้ดีและค่อยๆ ทำเกมอย่างใจเย็น';

  @override
  String get matchScoutStrengthCounter => 'พวกเขาถอยรับและสวนกลับอย่างรวดเร็ว';

  @override
  String get matchScoutStrengthDeepDefence => 'พวกเขาตั้งรับลึกและเจาะได้ยาก';

  @override
  String get matchScoutStrengthWide => 'พวกเขาขยายพื้นที่และบุกทางริมเส้น';

  @override
  String get matchScoutStrengthAttacking => 'พวกเขาชอบเปิดเกมบุกใส่คู่แข่ง';

  @override
  String get matchScoutStrengthQuickForwards =>
      'กองหน้าของพวกเขาเร็วและชอบวิ่งทะลุแนวหลัง';

  @override
  String get matchScoutStrengthPassingMidfield =>
      'กองกลางของพวกเขาจ่ายบอลได้ดี';

  @override
  String get matchScoutStrengthHardRunning =>
      'กองกลางของพวกเขามีพละกำลังวิ่งได้ทั้งเกม';

  @override
  String get matchScoutStrengthSetPieces => 'พวกเขาอันตรายมากจากลูกตั้งเตะ';

  @override
  String get matchScoutStrengthQuickDefence =>
      'แนวรับของพวกเขาเร็วและหาช่องเจาะยาก';

  @override
  String get matchScoutStrengthNone => 'เกมของพวกเขาไม่มีอะไรโดดเด่นเป็นพิเศษ';

  @override
  String get matchScoutWeakSpaceBehind =>
      'แนวรับที่ดันสูงทิ้งพื้นที่ด้านหลังไว้ให้บอลโยนข้ามหัว';

  @override
  String get matchScoutWeakPressedBuildUp =>
      'การเพรสซิ่งสูงจะรบกวนการทำเกมที่ช้าของพวกเขาได้';

  @override
  String get matchScoutWeakDeepBlock =>
      'ใจเย็นไว้: แนวรับลึกแบบนี้เจาะได้ถ้าอดทน';

  @override
  String get matchScoutWeakLongBall =>
      'ถอยแนวรับลงลึก บอลยาวของพวกเขาก็ไม่มีที่ไป';

  @override
  String get matchScoutWeakSlowDefence =>
      'กองหลังของพวกเขาขาดความเร็ว ส่งคนวิ่งทะลุไปด้านหลัง';

  @override
  String get matchScoutWeakAerial => 'พวกเขาดูไม่มั่นคงเวลาป้องกันลูกตั้งเตะ';

  @override
  String get matchScoutWeakPoorPassing =>
      'กองกลางของพวกเขาจ่ายบอลหนีเพรสซิ่งได้ยาก';

  @override
  String get matchScoutWeakTiringMidfield =>
      'กองกลางของพวกเขาไม่มีพละกำลังพอจะเพรสซิ่งได้นาน';

  @override
  String get matchScoutWeakBluntAttack => 'กองหน้าของพวกเขาขาดความเร็ว';

  @override
  String get matchScoutApproachTakeTheGame =>
      'เจอคุณ คาดว่าพวกเขาจะเป็นฝ่ายคุมเกม';

  @override
  String get matchScoutApproachEven =>
      'เจอคุณ คาดว่าจะเป็นเกมที่สูสีและแน่นหนา';

  @override
  String get matchScoutApproachSitDeep =>
      'เจอคุณ คาดว่าพวกเขาจะเล่นระวังและรอจังหวะสวนกลับ';

  @override
  String get matchScoutLeaningAttacking =>
      'มองจากไกลๆ พวกเขาดูเป็นทีมที่เน้นเกมรุก';

  @override
  String get matchScoutLeaningCautious =>
      'มองจากไกลๆ พวกเขาดูเป็นทีมที่เล่นระมัดระวัง';

  @override
  String get matchScoutLeaningUnclear =>
      'มองจากไกลๆ ยากจะบอกว่าพวกเขาชอบเล่นแบบไหน';

  @override
  String get matchScoutHireHint =>
      'จ้างหัวหน้าแมวมองเพื่อดูว่าพวกเขาเล่นอย่างไร';

  @override
  String matchCouldNotContinue(String error) {
    return 'ดำเนินการต่อไม่ได้: $error';
  }

  @override
  String get matchSkipToFullTime => 'ข้ามไปจบเกม';

  @override
  String get matchStatShots => 'ยิง';

  @override
  String get matchStatGoals => 'ประตู';

  @override
  String get matchStatYellowCards => 'ใบเหลือง';

  @override
  String get matchStatRedCards => 'ใบแดง';

  @override
  String get matchMomentum => 'โมเมนตัม';

  @override
  String get matchSwingAtk => 'รุก';

  @override
  String get matchSwingDef => 'รับ';

  @override
  String ceremonyWorldCupYear(int year) {
    return 'ชิงแชมป์โลก $year';
  }

  @override
  String get ceremonyFinalsAreHere => 'รอบสุดท้ายมาถึงแล้ว';

  @override
  String ceremonyHostedBy(String hosts) {
    return 'เจ้าภาพ  $hosts';
  }

  @override
  String get ceremonyHostTbc => 'รอยืนยันเจ้าภาพ';

  @override
  String get matchHalfTime => 'พักครึ่งเวลา';

  @override
  String get matchContinue => 'ดำเนินการต่อ';

  @override
  String get matchContinuing => 'กำลังดำเนินการ…';

  @override
  String matchTacticsWithSubs(int used, int max) {
    return 'แทคติก · เปลี่ยนตัว $used/$max';
  }

  @override
  String matchTiredCount(int count) {
    return 'เหนื่อย ×$count';
  }

  @override
  String get matchTacticsLabel => 'แทคติก';

  @override
  String get teamOverallOverTime => 'ค่าพลังรวมตามช่วงเวลา';

  @override
  String get teamOverall => 'ค่าพลังรวม';

  @override
  String get teamTalkHeading => 'พูดคุยกับทีม';

  @override
  String get teamTalkPrompt => 'กำหนดอารมณ์ของทีมสำหรับครึ่งหลัง';

  @override
  String get teamTalkCalmLabel => 'ใจเย็นไว้';

  @override
  String get teamTalkCalmBlurb => 'ทำให้ทีมนิ่ง เพิ่มพลังเล็กน้อยทุกด้าน';

  @override
  String get teamTalkEncourageLabel => 'ให้กำลังใจ';

  @override
  String get teamTalkEncourageBlurb => 'ดันขึ้นหน้าและเล่นเพื่อเอาชนะ';

  @override
  String get teamTalkDemandMoreLabel => 'เรียกร้องมากขึ้น';

  @override
  String get teamTalkDemandMoreBlurb => 'ทุ่มสุดตัว บุกอย่างหนัก';

  @override
  String get teamTalkPraiseLabel => 'เล่นให้แน่น';

  @override
  String get teamTalkPraiseBlurb => 'เล่นให้กระชับและรักษาสิ่งที่มีไว้';

  @override
  String get teamTalkBelieveLabel => 'เชื่อมั่น';

  @override
  String get teamTalkBelieveBlurb =>
      'เชื่อในตัวเอง เพิ่มพลังทั้งเกมรุกและเกมรับ';

  @override
  String get teamTalkFocusLabel => 'ตั้งสมาธิ';

  @override
  String get teamTalkFocusBlurb => 'สมาธิเต็มร้อย ปิดเกมให้อยู่';

  @override
  String get teamTalkUrgencyLabel => 'เร่งเครื่อง';

  @override
  String get teamTalkUrgencyBlurb =>
      'ไล่ตามเดี๋ยวนี้ บุกสุดตัว แต่จะทิ้งช่องว่าง';

  @override
  String get teamTalkReassureLabel => 'ไม่มีแรงกดดัน';

  @override
  String get teamTalkReassureBlurb => 'คลายความตื่นเต้นและรักษารูปทรงทีม';

  @override
  String get commonRetry => 'ลองอีกครั้ง';

  @override
  String get commonSomethingWentWrong => 'เกิดข้อผิดพลาด';

  @override
  String get commonCrashBox =>
      'เกิดข้อผิดพลาดตรงนี้\nดูรายละเอียดได้ที่ การตั้งค่า → การวินิจฉัย';

  @override
  String hubCouldNotAdvance(String error) {
    return 'จำลองโลกต่อไม่ได้: $error';
  }

  @override
  String get settingsDiagnosticsTitle => 'การวินิจฉัย';

  @override
  String get settingsDiagnosticsBlurb =>
      'ข้อผิดพลาดที่บันทึกไว้ในอุปกรณ์นี้ ไม่มีการส่งข้อมูลไปที่ใด';

  @override
  String get settingsContactTitle => 'ติดต่อ';

  @override
  String get settingsContactCopied => 'คัดลอกที่อยู่แล้ว';

  @override
  String get settingsCommunityTitle => 'ชุมชน';

  @override
  String get settingsDiscordSubtitle => 'เข้าร่วมชุมชน';

  @override
  String get settingsLinkCopied => 'คัดลอกลิงก์แล้ว';

  @override
  String get diagnosticsEmpty => 'ไม่มีข้อผิดพลาดที่บันทึกไว้ ดีแล้ว';

  @override
  String get diagnosticsCopy => 'คัดลอก';

  @override
  String get diagnosticsCopied => 'คัดลอกบันทึกไปยังคลิปบอร์ดแล้ว';

  @override
  String get diagnosticsClear => 'ล้าง';

  @override
  String get navHub => 'ศูนย์กลาง';

  @override
  String get navSquad => 'ทีม';

  @override
  String get navStandings => 'ตารางคะแนน';

  @override
  String get navCareers => 'อาชีพของฉัน';

  @override
  String get settingsTitle => 'การตั้งค่า';

  @override
  String get settingsSoundHapticsTitle => 'เสียงและการสั่น';

  @override
  String get settingsSoundHapticsBlurb =>
      'สั่นและเสียงสั้นๆ เมื่อมีประตู เริ่มเกม และจบเกม';

  @override
  String get settingsLanguageTitle => 'ภาษา';

  @override
  String get settingsLanguageBlurb => 'เลือกภาษาของแอป หรือใช้ตามอุปกรณ์';

  @override
  String get settingsLanguageSystem => 'ตามระบบ';

  @override
  String get settingsTextSizeTitle => 'ขนาดตัวอักษร';

  @override
  String get settingsTextSizeBlurb => 'ขยายตัวอักษรหากอ่านยาก';

  @override
  String get settingsTextSizeNormal => 'ปกติ';

  @override
  String get settingsTextSizeLarge => 'ใหญ่';

  @override
  String get settingsTextSizeLarger => 'ใหญ่ขึ้น';

  @override
  String get matchPreviewAllMeetings => 'การพบกันทั้งหมด';

  @override
  String get recordsMeetings => 'การพบกัน';

  @override
  String get recordsLegends => 'ตำนาน';

  @override
  String get recordsAllTimeXi => '11 ตัวจริงตลอดกาล';

  @override
  String get recordsHallOfFame => 'หอเกียรติยศ';

  @override
  String get recordsAllTimeWorld => 'สถิติโลกตลอดกาล';

  @override
  String get recordsAllTimeTopScorers => 'ดาวซัลโวตลอดกาล';

  @override
  String get recordsMostCapped => 'ติดทีมชาติมากที่สุด';

  @override
  String get recordsMostWcStarts => 'ลงตัวจริงชิงแชมป์โลกมากที่สุด';

  @override
  String get recordsMostTournaments => 'ร่วมทัวร์นาเมนต์มากที่สุด';

  @override
  String get recordsRecordBook => 'สมุดสถิติ';

  @override
  String get recordsHeadToHead => 'สถิติการพบกัน';

  @override
  String get recordsFiercestRival => 'คู่ปรับตลอดกาล';

  @override
  String get recordsMostCaps => 'ติดทีมชาติมากที่สุด';

  @override
  String get recordsTopScorers => 'ดาวซัลโว';

  @override
  String get recordsMostAssists => 'แอสซิสต์มากที่สุด';

  @override
  String get recordsYourRecord => 'สถิติของคุณ';

  @override
  String get callUpHome => 'เหย้า';

  @override
  String get callUpAway => 'เยือน';

  @override
  String get recordsHome => 'เหย้า';

  @override
  String get recordsAway => 'เยือน';

  @override
  String get recordsActive => 'ยังเล่นอยู่';

  @override
  String get recordsStillActive => 'ยังเล่นอยู่';

  @override
  String get recordsAvg => 'เฉลี่ย';

  @override
  String get recordsSelect => 'เลือก';

  @override
  String get recordsVs => 'พบ';

  @override
  String get recordsDraws => 'เสมอ';

  @override
  String get recordsGoalsLabel => 'ประตู';

  @override
  String get recordsBestFinish => 'ผลงานดีที่สุด';

  @override
  String get recordsNoFinalsYet => 'ยังไม่เคยผ่านเข้ารอบสุดท้าย';

  @override
  String get recordsLongestUnbeaten => 'ไม่แพ้ติดต่อกันนานที่สุด';

  @override
  String get recordsBiggestWin => 'ชนะขาดที่สุด';

  @override
  String get recordsSeeAllMeetings => 'ดูการพบกันทั้งหมด';

  @override
  String get recordsSaveNotFound => 'ไม่พบไฟล์เซฟ';

  @override
  String get recordsNoMatches => 'ไม่พบผลลัพธ์';

  @override
  String get recordsSearchPlayerOrNation => 'ค้นหาผู้เล่นหรือชาติ';

  @override
  String get recordsSearchNation => 'ค้นหาชาติ';

  @override
  String get recordsPickTwoDifferent => 'เลือกสองชาติที่ต่างกัน';

  @override
  String get recordsPlayToBuildRecord =>
      'ลงเล่นสักสองสามนัด แล้วสถิติของคุณกับคู่แข่งแต่ละทีมจะปรากฏที่นี่';

  @override
  String get recordsTapOpponent => 'แตะที่คู่แข่งเพื่อดูรายละเอียดทั้งหมด';

  @override
  String get recordsEdgeUpperHand => 'คุณเป็นต่อ';

  @override
  String get recordsEdgeTheirNumber => 'คุณแพ้ทางพวกเขา';

  @override
  String get recordsEdgeEven => 'สถิติสูสีกัน';

  @override
  String get recordsAllTimeWorldSubtitle =>
      'ดาวซัลโวและติดทีมชาติสูงสุด ทุกชาติทั่วโลก';

  @override
  String get recordsHeadToHeadSubtitle =>
      'เปรียบเทียบสถิติตลอดกาลของสองชาติใดก็ได้';

  @override
  String get recordsLegendsSubtitle => '11 ตัวจริงตลอดกาลและหอเกียรติยศ';

  @override
  String get recordsUnitGoals => 'ประตู';

  @override
  String get recordsUnitCaps => 'นัด';

  @override
  String get recordsUnitStarts => 'นัดตัวจริง';

  @override
  String get recordsUnitCups => 'รายการ';

  @override
  String get recordsUnitAssists => 'แอสซิสต์';

  @override
  String recordsCapsCount(int count) {
    return '$count นัด';
  }

  @override
  String recordsGoalsCount(int count) {
    return '$count ประตู';
  }

  @override
  String recordsAssistsCount(int count) {
    return '$count แอสซิสต์';
  }

  @override
  String recordsMotmCount(int count) {
    return 'แมนออฟเดอะแมตช์ $count';
  }

  @override
  String recordsMatchesCount(int count) {
    return '$count นัด';
  }

  @override
  String recordsMeetingsCount(int count) {
    return 'พบกัน $count ครั้ง';
  }

  @override
  String recordsCodeWins(String code) {
    return '$code ชนะ';
  }

  @override
  String recordsMeetingsWdl(int meetings, int wins, int draws, int losses) {
    return 'พบกัน $meetings ครั้ง · ชนะ $wins เสมอ $draws แพ้ $losses';
  }

  @override
  String recordsWdl(int wins, int draws, int losses) {
    return 'ชนะ $wins เสมอ $draws แพ้ $losses';
  }

  @override
  String recordsRivalLine(int meetings, String record, String edge) {
    return 'พบกัน $meetings ครั้ง · $record · $edge';
  }

  @override
  String recordsNeverMet(String a, String b) {
    return '$a และ $b ยังไม่เคยพบกันในเซฟนี้';
  }

  @override
  String tacticsSentOffNote(String names) {
    return '$names โดนไล่ออก เปลี่ยนตัวแทนไม่ได้ คุณต้องเล่นขาดคน';
  }

  @override
  String tacticsNeedFitPlayers(int required, int have) {
    return 'ต้องมีผู้เล่นพร้อม $required คน (พร้อม $have)';
  }

  @override
  String tacticsMissesOfCamp(int missed, int total) {
    return 'พลาด $missed/$total';
  }

  @override
  String get tacticsOutForWholeCamp => 'พลาดการเรียกตัวครั้งนี้ทั้งหมด';

  @override
  String get rankingCentreOnMe => 'ไปที่ชาติของฉัน';

  @override
  String get recordsAfterExtraTime => 'ต่อเวลา';

  @override
  String recordsOnPenalties(int a, int b) {
    return 'จุดโทษ $a–$b';
  }

  @override
  String recordsVersus(String a, String b) {
    return '$a พบ $b';
  }

  @override
  String recordsPlayedScore(int played, int gf, int ga) {
    return 'เล่น $played · $gf–$ga';
  }

  @override
  String recordsBiggestWinValue(int gf, int ga, String opp) {
    return '$gf–$ga พบ $opp';
  }

  @override
  String recordsCouldNotLoad(String error) {
    return 'โหลดไม่ได้\n$error';
  }

  @override
  String recordsCouldNotLoadLegends(String error) {
    return 'โหลดข้อมูลตำนานไม่ได้\n$error';
  }

  @override
  String recordsCouldNotLoadRecords(String error) {
    return 'โหลดสถิติไม่ได้\n$error';
  }

  @override
  String recordsCouldNotLoadNations(String error) {
    return 'โหลดรายชื่อชาติไม่ได้\n$error';
  }

  @override
  String recordsCouldNotLoadYourRecord(String error) {
    return 'โหลดสถิติของคุณไม่ได้\n$error';
  }

  @override
  String recordsCouldNotLoadRecord(String error) {
    return 'โหลดสถิติไม่ได้\n$error';
  }

  @override
  String recordsNoLegends(String nation) {
    return 'ยังไม่มีตำนาน ลงเล่นสักหลายแคมเปญ แล้วยอดผู้เล่นของ $nation จะปรากฏที่นี่';
  }

  @override
  String recordsGreatestSide(String nation) {
    return 'ทีมที่ยิ่งใหญ่ที่สุดที่ $nation เคยส่งลงสนามได้';
  }

  @override
  String get recordsNoWorldHistory =>
      'โลกยังไม่มีประวัติศาสตร์ ลงเล่นสักหลายแคมเปญ แล้วยอดผู้เล่นตลอดกาลจะปรากฏที่นี่';

  @override
  String recordsPlayToWriteHistory(String nation) {
    return 'ลงเล่นสักสองสามนัดเพื่อเริ่มเขียนประวัติศาสตร์ของ $nation';
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
  String get tacticsGoalkeepers => 'ผู้รักษาประตู';

  @override
  String get tacticsDefenders => 'กองหลัง';

  @override
  String get tacticsMidfielders => 'กองกลาง';

  @override
  String get tacticsForwards => 'กองหน้า';

  @override
  String get tacticsCallUpsTitle => 'เรียกตัว';

  @override
  String tacticsPickAtLeastPlayers(int min) {
    return 'เลือกผู้เล่นอย่างน้อย $min คน';
  }

  @override
  String tacticsCouldNotLoadSquad(String error) {
    return 'โหลดข้อมูลทีมไม่ได้\n$error';
  }

  @override
  String get tacticsNoSquad => 'ไม่มีทีม';

  @override
  String tacticsSquadCount(int count, int max) {
    return 'ทีมชุด · $count/$max';
  }

  @override
  String tacticsMinMax(int min, int max) {
    return 'ต่ำสุด $min · สูงสุด $max';
  }

  @override
  String get tacticsBestQuality => 'ดีที่สุด';

  @override
  String get tacticsPreviousSquad => 'ทีมชุดก่อน';

  @override
  String get tacticsSquadLockedBack => 'กลับ (ทีมถูกล็อก)';

  @override
  String get tacticsConfirmSquad => 'ยืนยันทีม';

  @override
  String tacticsSquadFullMax(int max) {
    return 'ทีมเต็ม (สูงสุด $max)';
  }

  @override
  String get tacticsSquadLocked => 'ทีมถูกล็อก';

  @override
  String get tacticsNominationOpen => 'เปิดเรียกตัวแล้ว เลือกทีมของคุณ';

  @override
  String get tacticsSquadFixedBlurb =>
      'ทีมชุดนี้ถูกล็อกสำหรับเกมด้านล่าง เลือกใหม่ได้ก่อนการเรียกตัวครั้งถัดไป';

  @override
  String get tacticsSquadWillPlayBlurb => 'ทีมชุดนี้จะลงเล่นในเกมด้านล่าง';

  @override
  String get tacticsUnknown => 'ไม่ทราบ';

  @override
  String tacticsAgeValue(int age, String value) {
    return 'อายุ $age · $value';
  }

  @override
  String get tacticsFatigueExhausted => 'หมดแรง';

  @override
  String get tacticsFatigueTired => 'เหนื่อย';

  @override
  String get tacticsFatigueMatchLegs => 'ล้าจากเกม';

  @override
  String tacticsTooManySubs(int max) {
    return 'เปลี่ยนตัวเกินจำนวน (สูงสุด $max)';
  }

  @override
  String tacticsMinuteTitle(int minute) {
    return 'แทคติก · $minute\'';
  }

  @override
  String get tacticsApply => 'ใช้';

  @override
  String get tacticsTabLineupSubs => 'ตัวจริงและสำรอง';

  @override
  String get tacticsTabTactics => 'แทคติก';

  @override
  String get squadLineKeepers => 'ผู้รักษาประตู';

  @override
  String get squadLineDefenders => 'แนวรับ';

  @override
  String get squadLineMidfielders => 'แดนกลาง';

  @override
  String get squadLineForwards => 'แนวรุก';

  @override
  String get squadStatXiRating => 'ค่าพลัง 11 ตัวจริง';

  @override
  String get squadStatAvgAge => 'อายุเฉลี่ย';

  @override
  String get squadStatSize => 'ทีมชุด';

  @override
  String get squadStatUnavailable => 'ไม่พร้อม';

  @override
  String get squadDepthTitle => 'ความลึกแต่ละแนว';

  @override
  String squadAgeShort(int age) {
    return '$age ปี';
  }

  @override
  String get tacticsTabOtherPositions => 'ตำแหน่งอื่น';

  @override
  String get tacticsOutOfPositionNote => 'ผิดตำแหน่งตรงนี้';

  @override
  String get tacticsNobodyElse => 'ไม่มีใครให้ลองตรงนี้แล้ว';

  @override
  String get tacticsPickSomebodyFirst =>
      'เลือกคนที่จะเปลี่ยนออก แล้วตัวสำรองที่เหลือจะแสดงที่นี่ พร้อมค่าพลังในตำแหน่งนี้';

  @override
  String get tacticsTabSuitable => 'เหมาะสม';

  @override
  String get tacticsTabOnPitch => 'ในสนาม';

  @override
  String tacticsSectionSuitable(int count) {
    return 'เหมาะสม · $count';
  }

  @override
  String get tacticsNobodySuits =>
      'ไม่มีตัวสำรองที่เหมาะกับตำแหน่งนี้โดยธรรมชาติ จึงแสดงทุกคน';

  @override
  String tacticsSectionOnPitch(int count, int max) {
    return 'ในสนาม · $count/$max';
  }

  @override
  String tacticsSectionAvailable(int count) {
    return 'พร้อมลงสนาม · $count';
  }

  @override
  String get tacticsRowStarted => 'ตัวจริง';

  @override
  String tacticsRowCameOn(int minute) {
    return 'ลงนาที $minute\'';
  }

  @override
  String get tacticsRowSubstitute => 'ลงเป็นตัวสำรอง';

  @override
  String get tacticsEnergyLabel => 'พลังงาน';

  @override
  String tacticsPickReplacementFor(String name) {
    return 'แตะเลือกตัวแทนของ $name หรือแตะซ้ำเพื่อยกเลิก';
  }

  @override
  String get tacticsSlotLostToRedCard =>
      'ใบแดงทำให้คุณเสียตำแหน่งนี้ ลากเพื่อนร่วมทีมมาที่นี่เพื่อย้ายช่องว่าง';

  @override
  String get tacticsSentOffShort => 'ใบแดง';

  @override
  String get tacticsFullBackLeft => 'แบ็กซ้าย';

  @override
  String get tacticsFullBackRight => 'แบ็กขวา';

  @override
  String get tacticsFullBackUp => 'ขึ้นเกมรุก';

  @override
  String get tacticsFullBackDown => 'อยู่เกมรับ';

  @override
  String get tacticsFullBackOff => 'ไม่มีคำสั่ง';

  @override
  String tacticsFullBackUpHint(String side) {
    return '$side: ขึ้นเกมรุก เกมรุกเพิ่มขึ้นเล็กน้อย ความเสี่ยงก็เพิ่มขึ้นเล็กน้อย';
  }

  @override
  String tacticsFullBackDownHint(String side) {
    return '$side: อยู่เกมรับ ปลอดภัยขึ้นเล็กน้อย เกมรุกลดลงเล็กน้อย';
  }

  @override
  String tacticsFullBackOffHint(String side) {
    return '$side: ไม่มีคำสั่ง เล่นตามแผนของทีม';
  }

  @override
  String tacticsFullBackSemantics(String side, String state) {
    return 'ลูกศร$side: $state';
  }

  @override
  String tacticsSubsUsed(int used, int max) {
    return 'เปลี่ยนตัว · $used/$max';
  }

  @override
  String get tacticsDragSubOn =>
      'แตะผู้เล่นในสนามเพื่อเปลี่ยนออก หรือกดค้างแล้วลากตัวสำรองไปวางทับ';

  @override
  String get tacticsNoSubs => 'ไม่มีตัวสำรอง';

  @override
  String get tacticsChooseShape => 'เลือกแผนการเล่น';

  @override
  String get tacticsFormation => 'แผนการเล่น';

  @override
  String get tacticsInstructions => 'คำสั่ง';

  @override
  String get tacticsDrilling => 'ความคุ้นเคย';

  @override
  String get tacticsDrillingUnplayed => 'ยังไม่เคยใช้';

  @override
  String get tacticsDrillingNew => 'ใหม่';

  @override
  String get tacticsDrillingSettling => 'เริ่มเข้าที่';

  @override
  String get tacticsDrillingDrilled => 'คล่องแล้ว';

  @override
  String get tacticsInstrMentality => 'แนวคิด';

  @override
  String get tacticsInstrDefensive => 'เน้นรับ';

  @override
  String get tacticsInstrAttacking => 'เน้นรุก';

  @override
  String get tacticsInstrPressing => 'เพรสซิ่ง';

  @override
  String get tacticsInstrLowBlock => 'ตั้งรับต่ำ';

  @override
  String get tacticsInstrHighPress => 'เพรสสูง';

  @override
  String get tacticsInstrTempo => 'จังหวะ';

  @override
  String get tacticsInstrPatient => 'ใจเย็น';

  @override
  String get tacticsInstrFast => 'เร็ว';

  @override
  String get tacticsInstrWidth => 'ความกว้าง';

  @override
  String get tacticsInstrNarrow => 'แคบ';

  @override
  String get tacticsInstrWide => 'กว้าง';

  @override
  String get tacticsInstrDefLine => 'แนวรับ';

  @override
  String get tacticsInstrDefensiveLine => 'ระดับแนวรับ';

  @override
  String get tacticsInstrDeep => 'ลึก';

  @override
  String get tacticsInstrHigh => 'สูง';

  @override
  String get tacticsInstrDirectness => 'ความไดเร็กต์';

  @override
  String get tacticsInstrPossession => 'ครองบอล';

  @override
  String get tacticsInstrDirect => 'ไดเร็กต์';

  @override
  String get tacticsPickGoalkeeper => 'เลือกผู้รักษาประตู';

  @override
  String get tacticsPickLeftBack => 'เลือกแบ็กซ้าย';

  @override
  String get tacticsPickCentreBack => 'เลือกเซ็นเตอร์แบ็ก';

  @override
  String get tacticsPickRightBack => 'เลือกแบ็กขวา';

  @override
  String get tacticsPickDefensiveMid => 'เลือกกองกลางตัวรับ';

  @override
  String get tacticsPickCentralMid => 'เลือกกองกลางตัวกลาง';

  @override
  String get tacticsPickAttackingMid => 'เลือกกองกลางตัวรุก';

  @override
  String get tacticsPickLeftMid => 'เลือกกองกลางซ้าย';

  @override
  String get tacticsPickRightMid => 'เลือกกองกลางขวา';

  @override
  String get tacticsPickLeftWing => 'เลือกปีกซ้าย';

  @override
  String get tacticsPickRightWing => 'เลือกปีกขวา';

  @override
  String get tacticsPickStriker => 'เลือกกองหน้าตัวเป้า';

  @override
  String tacticsRoleOutOfPosition(String role) {
    return '$role · ผิดตำแหน่ง';
  }

  @override
  String tacticsAgeOnly(int age) {
    return 'อายุ $age';
  }

  @override
  String tacticsRoleAge(String role, int age) {
    return '$role · อายุ $age';
  }

  @override
  String get tacticsOn => 'ลงแล้ว';

  @override
  String get tacticsSquad => 'ทีมชุด';

  @override
  String get tacticsTabLineup => 'ตัวจริง';

  @override
  String get tacticsTabInstructions => 'คำสั่ง';

  @override
  String get tacticsTabRoles => 'บทบาท';

  @override
  String get tacticsTabSetPieces => 'ลูกตั้งเตะ';

  @override
  String get tacticsTabRolesSetPieces => 'บทบาทและลูกตั้งเตะ';

  @override
  String get tacticsRolesSetPiecesBlurb =>
      'กำหนดบทบาทให้ตัวจริงแต่ละคน แตะสัญลักษณ์จุดโทษ (⚽) หรือฟรีคิก (▲) เพื่อเลือกคนสังหาร';

  @override
  String get tacticsTooltipCallUps => 'เรียกตัว';

  @override
  String get tacticsTooltipPresets => 'แทคติกที่บันทึกไว้';

  @override
  String get tacticsTooltipInstructions => 'คำสั่ง';

  @override
  String get tacticsNoTacticSet => 'ยังไม่ได้ตั้งแทคติก';

  @override
  String tacticsReplaceStarters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'เปลี่ยนตัวจริง $count คน',
    );
    return '$_temp0';
  }

  @override
  String tacticsPlayerOut(String name, String reason) {
    return '$name: $reason';
  }

  @override
  String get tacticsOut => 'ไม่พร้อม';

  @override
  String get tacticsTapSpotReplace => 'แตะตำแหน่งของเขาในสนามเพื่อเลือกตัวแทน';

  @override
  String get tacticsTapOrDrag =>
      'แตะผู้เล่นเพื่อเปลี่ยนตัว หรือกดค้างแล้วลากเพื่อย้ายตำแหน่ง';

  @override
  String get tacticsPlayerRoles => 'บทบาทผู้เล่น';

  @override
  String get tacticsRolesBlurb =>
      'มอบหน้าที่ให้ผู้เล่น: จอมฉวยโอกาส เพลย์เมกเกอร์ หรือกองหน้าตัวเป้า กำหนดว่าใครยิงและใครสร้างสรรค์';

  @override
  String get tacticsSetPieceTakers => 'ผู้เตะลูกตั้งเตะ';

  @override
  String get tacticsSetPieceBlurb =>
      'ใครยิงจุดโทษและเตะลูกนิ่ง หรือปล่อยให้ผู้เล่นที่เหมาะที่สุดรับหน้าที่';

  @override
  String get tacticsTakerAuto => 'อัตโนมัติ';

  @override
  String get tacticsTakerQuickPick => 'ใช้ผู้เตะที่ดีที่สุด';

  @override
  String get tacticsPenalties => 'จุดโทษ';

  @override
  String get tacticsCornersFreeKicks => 'เตะมุมและฟรีคิก';

  @override
  String get tacticsSkillFin => 'ยิง';

  @override
  String get tacticsSkillPas => 'จ่าย';

  @override
  String tacticsRolePlayer(String name) {
    return 'บทบาท · $name';
  }

  @override
  String get tacticsPenaltyTaker => 'ผู้ยิงจุดโทษ';

  @override
  String get tacticsCornerFreeKickTaker => 'ผู้เตะมุมและฟรีคิก';

  @override
  String get tacticsAutomatic => 'อัตโนมัติ';

  @override
  String get tacticsLetBestSuited => 'ให้ผู้เล่นที่เหมาะที่สุดเป็นคนเตะ';

  @override
  String get tacticsInXi => 'ตัวจริง';

  @override
  String get tacticsTeamInstructions => 'คำสั่งทีม';

  @override
  String get tacticsTeamInstructionsBlurb =>
      'กำหนดสไตล์การเล่นของทีม แต่ละปุ่มปรับมีผลต่อทั้งทีม';

  @override
  String tacticsSavedPreset(String name) {
    return 'บันทึก “$name” แล้ว';
  }

  @override
  String tacticsAppliedPreset(String name) {
    return 'ใช้ “$name” แล้ว';
  }

  @override
  String get tacticsTacticPresets => 'แทคติกที่บันทึกไว้';

  @override
  String get tacticsPresetsBlurb =>
      'บันทึกแผนนี้เป็นสไตล์ที่ใช้ซ้ำได้ หรือเลือกใช้แผนที่บันทึกไว้ก่อนหน้า';

  @override
  String get tacticsSaveCurrentTactic => 'บันทึกแทคติกปัจจุบัน';

  @override
  String tacticsCouldNotLoadPresets(String error) {
    return 'โหลดแทคติกที่บันทึกไว้ไม่ได้\n$error';
  }

  @override
  String get tacticsNoPresetsYet =>
      'ยังไม่มีแทคติกที่บันทึกไว้ แตะ “บันทึกแทคติกปัจจุบัน” เพื่อเก็บการตั้งค่านี้ไว้ใช้ซ้ำ';

  @override
  String get tacticsNameThisTactic => 'ตั้งชื่อแทคติกนี้';

  @override
  String get tacticsNameHint => 'เช่น เพรสสูง 4-3-3';

  @override
  String get tacticsCancel => 'ยกเลิก';

  @override
  String get tacticsSave => 'บันทึก';

  @override
  String get tacticsTapToAssign => 'แตะเพื่อกำหนด';

  @override
  String get tacticsHoldDragSub =>
      'กดค้างที่ตัวสำรอง แล้วลากไปวางบนผู้เล่นเพื่อส่งลงสนาม';

  @override
  String get hubContinue => 'ดำเนินการต่อ';

  @override
  String get hubBrackets => 'สายการแข่งขัน';

  @override
  String hubCouldNotLoad(String error) {
    return 'โหลดไม่ได้\n$error';
  }

  @override
  String hubCouldNotLoadFinances(String error) {
    return 'โหลดข้อมูลการเงินไม่ได้\n$error';
  }

  @override
  String hubCouldNotLoadSave(String error) {
    return 'โหลดเซฟไม่ได้\n$error';
  }

  @override
  String get hubSaveNotFound => 'ไม่พบเซฟ';

  @override
  String get hubUnknown => 'ไม่ทราบ';

  @override
  String hubWorldChampionsYear(int year) {
    return 'แชมป์โลกปี $year';
  }

  @override
  String get hubCycleComplete => 'รอบนี้สิ้นสุดแล้ว';

  @override
  String get hubYourJob => 'งานของคุณ';

  @override
  String get hubStayProject => 'อยู่ต่อและสานต่อโปรเจกต์ของคุณ';

  @override
  String get hubChooseNextJob => 'เลือกงานถัดไปของคุณ';

  @override
  String get hubOffersOnTable => 'ข้อเสนอที่มีอยู่';

  @override
  String hubOfferSubtitle(String tier, int position) {
    return '$tier · อันดับโลก #$position';
  }

  @override
  String hubContinueWith(String nation) {
    return 'ทำงานต่อกับ $nation';
  }

  @override
  String get hubYourNation => 'ชาติของคุณ';

  @override
  String get hubTakeTheJob => 'รับงานนี้';

  @override
  String get hubFederationFinances => 'การเงินของสมาคม';

  @override
  String get hubBudgetIntro =>
      'งานแรกของคุณในรอบหน้าคือกำหนดงบประมาณสมาคมและแบ่งให้แต่ละฝ่าย';

  @override
  String get hubStarting => 'กำลังเริ่ม…';

  @override
  String get hubBeginNextCycle => 'เริ่มรอบถัดไป';

  @override
  String get hubContinueCareer => 'สานต่ออาชีพของคุณ';

  @override
  String get hubBackToSaves => 'กลับไปที่เซฟของคุณ';

  @override
  String get hubOpeningBalance => 'ยอดยกมา';

  @override
  String get hubCentralFunding => 'เงินสนับสนุนส่วนกลาง';

  @override
  String get hubPrizeMoney => 'เงินรางวัล';

  @override
  String get hubCommercialReturn => 'รายได้เชิงพาณิชย์';

  @override
  String get hubAvailableToInvest => 'พร้อมลงทุน';

  @override
  String hubReputation(String label, int rep) {
    return 'ชื่อเสียง: $label ($rep)';
  }

  @override
  String get hubNationalHero => 'ฮีโร่ของชาติ';

  @override
  String get hubFinal => 'นัดชิงชนะเลิศ';

  @override
  String get hubStageRoundOf32 => 'รอบ 32 ทีม';

  @override
  String get hubStageThirdPlace => 'ชิงอันดับ 3';

  @override
  String get hubEventAdvanceWorld => 'เดินหน้าโลก';

  @override
  String hubEventStartCycle(int year) {
    return 'เริ่มรอบปี $year';
  }

  @override
  String hubEventWorldChampions(String nation) {
    return '$nation คือแชมป์โลก';
  }

  @override
  String get hubEventSetBudget => 'กำหนดงบประมาณสมาคม';

  @override
  String get hubEventSetBudgetSub => 'จัดสรรงบประมาณของรอบนี้ก่อนฤดูกาลเริ่ม';

  @override
  String get hubEventNaturalization => 'พิจารณาข้อเสนอโอนสัญชาติ';

  @override
  String get hubEventNaturalizationSub =>
      'ผู้เล่นต่างชาติต้องการเปลี่ยนมาเล่นให้คุณ';

  @override
  String get hubEventCampaignVerdict => 'แคมเปญได้ข้อสรุปแล้ว: ดูผลตัดสิน';

  @override
  String get hubEventCampaignComplete => 'แคมเปญเสร็จสิ้น';

  @override
  String get hubEventIntercontinentalPlayoff => 'เพลย์ออฟข้ามทวีป';

  @override
  String get hubEventWatchWcDraw => 'ชมการจับสลากชิงแชมป์โลก';

  @override
  String get hubEventWorldCupHere => 'ชิงแชมป์โลกมาถึงแล้ว';

  @override
  String get hubEventWatchFinalsDraw => 'ชมการจับสลากรอบสุดท้าย';

  @override
  String get hubEventFinalsHere => 'รอบสุดท้ายมาถึงแล้ว';

  @override
  String get hubEventPlayWcRound => 'เล่นรอบถัดไปของชิงแชมป์โลก';

  @override
  String hubEventPlayCupMatch(String cup) {
    return 'เล่นเกมถัดไปของ $cup';
  }

  @override
  String get hubEventPlayNationsCupMatch => 'เล่นเกมถัดไปของเนชันส์คัพ';

  @override
  String get hubEventWatchNationsCupDraw => 'ชมการจับสลากเนชันส์คัพ';

  @override
  String get hubEventWatchHostSelection => 'ชมการเลือกเจ้าภาพ';

  @override
  String get hubEventWatchQualifyingDraw => 'ชมการจับสลากรอบคัดเลือก';

  @override
  String get hubEventWatchWcHostSelection => 'ชมการเลือกเจ้าภาพชิงแชมป์โลก';

  @override
  String get hubEventWatchWcQualifyingDraw =>
      'ชมการจับสลากรอบคัดเลือกชิงแชมป์โลก';

  @override
  String get hubEventArrangeFriendlies => 'จัดเกมกระชับมิตร';

  @override
  String hubEventFriendliesSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'คุณยังไม่ได้จัดเกมกระชับมิตรในช่วงที่ว่างอยู่ $count ช่วง',
      one: 'คุณยังไม่ได้จัดเกมกระชับมิตรในช่วงที่ว่างอยู่',
    );
    return '$_temp0';
  }

  @override
  String get hubEventReshapeXi => 'ปรับ 11 ตัวจริงของคุณ';

  @override
  String hubEventReshapeOutSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ตัวจริง $count คนไม่พร้อม (ติดโทษแบนหรือบาดเจ็บ) เลือกตัวแทน',
      one: 'ตัวจริง 1 คนไม่พร้อม (ติดโทษแบนหรือบาดเจ็บ) เลือกตัวแทน',
    );
    return '$_temp0';
  }

  @override
  String hubEventReshapeShortSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '11 ตัวจริงของคุณยังไม่ครบ เติมตำแหน่งที่ว่าง',
      one: '11 ตัวจริงของคุณยังไม่ครบ เติมตำแหน่งที่ว่าง',
    );
    return '$_temp0';
  }

  @override
  String hubEventPlayOpponent(String opponent) {
    return 'พบ $opponent';
  }

  @override
  String get hubEventContinentalFinalsFallback => 'รอบสุดท้ายชิงแชมป์ทวีป';

  @override
  String get hubCallUpFriendlies => 'เรียกตัวสำหรับเกมกระชับมิตร';

  @override
  String get hubCallUpRequalify => 'เรียกตัวรอบคัดเลือกใหม่';

  @override
  String get hubCallUpWorldCup => 'เรียกตัวชุดชิงแชมป์โลก';

  @override
  String get hubCallUpFinals => 'เรียกตัวสำหรับรอบสุดท้าย';

  @override
  String get hubCallUpNationsCup => 'เรียกตัวชุดเนชันส์คัพ';

  @override
  String get hubCallUpQualifying => 'เรียกตัวชุดรอบคัดเลือก';

  @override
  String get hubCallUpGeneric => 'เรียกตัวผู้เล่น';

  @override
  String get hubHost => 'เจ้าภาพ';

  @override
  String get hubGoldenBoot => 'รองเท้าทองคำ';

  @override
  String hubGoldenBootValue(String name, int goals) {
    return '$name · $goals ประตู';
  }

  @override
  String get hubPens => '(จุดโทษ)';

  @override
  String get hubNationalHub => 'ศูนย์กลางทีมชาติ';

  @override
  String get hubMessages => 'ข้อความ';

  @override
  String get hubWorldChampions => 'แชมป์โลก';

  @override
  String get hubViewBracket => 'ดูสายการแข่งขัน ›';

  @override
  String get hubBoardDelighted => 'ยินดีมาก';

  @override
  String get hubBoardPleased => 'พอใจ';

  @override
  String get hubBoardExpectingMore => 'คาดหวังมากกว่านี้';

  @override
  String get hubBoardConcerned => 'กังวล';

  @override
  String get hubBoardJobAtRisk => 'เก้าอี้สั่นคลอน';

  @override
  String get hubBoard => 'บอร์ดบริหาร';

  @override
  String hubBoardObjective(String label) {
    return 'เป้าหมายของบอร์ด: $label';
  }

  @override
  String hubObjectiveMet(String result) {
    return 'สำเร็จ · $result';
  }

  @override
  String hubObjectiveMissed(String result) {
    return 'พลาดเป้า · $result';
  }

  @override
  String get hubNoMoreFixtures => 'ไม่มีโปรแกรมแข่งขันเหลือในรอบนี้';

  @override
  String get hubVs => 'VS';

  @override
  String hubWorldRank(int rank) {
    return '#$rank';
  }

  @override
  String get hubWorldRankLabel => 'อันดับโลก';

  @override
  String get hubSquadStatus => 'สถานะทีม';

  @override
  String hubPlayers(int count) {
    return '$count คน';
  }

  @override
  String get hubAvgRating => 'ค่าพลังเฉลี่ย';

  @override
  String get hubMorale => 'ขวัญกำลังใจ';

  @override
  String get hubManageTeam => 'จัดการทีม';

  @override
  String get hubGroupsToBeDrawn =>
      'ยังไม่จับสลากแบ่งกลุ่ม ชมการจับสลากเพื่อดูผล';

  @override
  String hubGroupName(String name) {
    return 'กลุ่ม $name';
  }

  @override
  String get hubTblTeam => 'ทีม';

  @override
  String get hubTblP => 'แข่ง';

  @override
  String get hubTblGd => '+/-';

  @override
  String get hubTblPts => 'แต้ม';

  @override
  String get homeSettings => 'การตั้งค่า';

  @override
  String get homeLeadTheNation => 'นำทัพชาติของคุณ';

  @override
  String get homeYourNation => 'ชาติของคุณ';

  @override
  String get homeNewGame => 'เกมใหม่';

  @override
  String get homeAllSaves => 'เซฟทั้งหมด';

  @override
  String get homeLoadGame => 'โหลดเกม';

  @override
  String get homeContinue => 'เล่นต่อ';

  @override
  String homeRoadToWorldCup(String date, int year) {
    return '$date · เส้นทางสู่ชิงแชมป์โลก $year';
  }

  @override
  String get careerManageSaves => 'จัดการเซฟ';

  @override
  String get careerNewGameTitle => 'เกมใหม่';

  @override
  String careerCouldNotLoadNation(String error) {
    return 'โหลดข้อมูลชาติไม่ได้\n$error';
  }

  @override
  String get careerNationNotFound => 'ไม่พบชาติ';

  @override
  String careerWorldRankNum(int rank) {
    return 'อันดับโลก #$rank';
  }

  @override
  String get careerManagerName => 'ชื่อผู้จัดการทีม';

  @override
  String get careerManagerNameHint => 'เช่น Alex Ferguson';

  @override
  String get careerBeginsBlurb =>
      'อาชีพของคุณเริ่มต้นในเดือนกันยายน 2026 บนเส้นทางสู่ชิงแชมป์โลก 2030';

  @override
  String get careerFreeCycleNote =>
      'เล่นฟรีหนึ่งรอบเต็ม 4 ปี: รอบคัดเลือก ชิงแชมป์ทวีปของคุณ และชิงแชมป์โลก ได้ 2 เซฟ หลังจากนั้น จ่ายครั้งเดียวเพื่อปลดล็อกรอบแบบไม่จำกัด';

  @override
  String get careerStartCareer => 'เริ่มอาชีพ';

  @override
  String get careersTitle => 'อาชีพ';

  @override
  String get careerManagerCareer => 'อาชีพผู้จัดการทีม';

  @override
  String get careerManagerCareerSubtitle =>
      'ทุกรอบที่คุณคุมทีมและสถิติรวมของคุณ';

  @override
  String get careerSummaryTitle => 'สรุปอาชีพ';

  @override
  String get careerSummarySubtitle => 'ตู้โชว์ถ้วยรางวัลและสถิติผู้จัดการทีม';

  @override
  String get careerAchievements => 'ความสำเร็จ';

  @override
  String get careerAchievementsSubtitle => 'หมุดหมาย แชมป์ และความพอใจของบอร์ด';

  @override
  String get careerChallenges => 'ความท้าทาย';

  @override
  String get careerChallengesSubtitle => 'บททดสอบสุดโหดตลอดอาชีพให้พิชิต';

  @override
  String get careerTeamRecords => 'สถิติทีม';

  @override
  String get careerTeamRecordsSubtitle => 'ดาวซัลโวและผู้ลงสนามสูงสุดตลอดกาล';

  @override
  String get careerMyMatches => 'เกมของฉัน';

  @override
  String get careerMyMatchesSubtitle =>
      'ทุกผลการแข่งขันและโปรแกรมที่กำลังจะมาถึง';

  @override
  String get careerTitle => 'อาชีพ';

  @override
  String careerCouldNotLoadCareer(String error) {
    return 'โหลดข้อมูลอาชีพไม่ได้\n$error';
  }

  @override
  String get careerNoCareer => 'ไม่มีข้อมูลอาชีพ';

  @override
  String get careerTrophyCabinet => 'ตู้โชว์ถ้วยรางวัล';

  @override
  String get careerTournamentHistory => 'ประวัติทัวร์นาเมนต์';

  @override
  String get careerNoTournamentsYet => 'ยังไม่มีทัวร์นาเมนต์ที่จบลง';

  @override
  String get careerTeamFallback => 'ทีม';

  @override
  String careerWorldNum(int rank) {
    return 'อันดับโลก #$rank';
  }

  @override
  String careerPointsNum(int points) {
    return '$points แต้ม';
  }

  @override
  String careerSeasonNum(int season) {
    return 'ฤดูกาล $season';
  }

  @override
  String get careerStatPlayedShort => 'แข่ง';

  @override
  String get careerStatsHeading => 'สถิติเป็นตัวเลข';

  @override
  String get careerStatsWinRate => 'อัตราชนะ';

  @override
  String get careerStatsGoalsFor => 'ได้ประตู';

  @override
  String get careerStatsGoalsAgainst => 'เสียประตู';

  @override
  String get careerStatsGoalDiff => 'ผลต่างประตู';

  @override
  String get careerStatsCleanSheets => 'คลีนชีต';

  @override
  String get careerStatsBiggestWin => 'ชนะขาดที่สุด';

  @override
  String get careerStatsWinStreak => 'ชนะติดต่อกัน';

  @override
  String get careerStatsUnbeaten => 'ไม่แพ้ติดต่อกัน';

  @override
  String get careerStatsShootouts => 'ดวลจุดโทษ';

  @override
  String get careerStatsHatTricks => 'แฮตทริก';

  @override
  String get careerStatsMotms => 'แมนออฟเดอะแมตช์';

  @override
  String get careerStatsBestRating => 'เรตติ้งสูงสุด';

  @override
  String get careerStatWonShort => 'ชนะ';

  @override
  String get careerStatDrawnShort => 'เสมอ';

  @override
  String get careerStatLostShort => 'แพ้';

  @override
  String get careerStatGoalsForShort => 'ได้';

  @override
  String get careerStatGoalsAgainstShort => 'เสีย';

  @override
  String get careerStatGoalDiffShort => '+/-';

  @override
  String get careerNoSilverware => 'ยังไม่มีถ้วยรางวัล ไปคว้ามาสักใบ';

  @override
  String get careerMedalGold => 'ทอง';

  @override
  String get careerMedalSilver => 'เงิน';

  @override
  String get careerMedalBronze => 'ทองแดง';

  @override
  String careerWinnersName(String name) {
    return 'แชมป์: $name';
  }

  @override
  String get careerSavesTitle => 'เซฟ';

  @override
  String careerCouldNotLoadSaves(String error) {
    return 'โหลดเซฟไม่ได้\n$error';
  }

  @override
  String careerSlotsCount(int used, int limit) {
    return 'ช่องเซฟ  $used/$limit';
  }

  @override
  String get careerThisSave => 'เซฟนี้';

  @override
  String get careerSlotsFull => 'ช่องเซฟเต็ม';

  @override
  String careerSlotsUsed(int used) {
    return 'ช่องเซฟ  $used';
  }

  @override
  String get careerSlotsUnlockMore => 'ปลดล็อกเซฟเพิ่ม';

  @override
  String get careerSlotsKeepNote =>
      'เซฟทุกอันที่คุณมีอยู่ยังเล่นได้ตามเดิม เฉพาะเซฟใหม่เท่านั้นที่ต้องปลดล็อก';

  @override
  String get careerNewGame => 'เกมใหม่';

  @override
  String get careerDeleteSaveTitle => 'ลบเซฟ?';

  @override
  String careerDeleteSaveBody(String label) {
    return 'การดำเนินการนี้จะลบอาชีพ $label ของคุณอย่างถาวร';
  }

  @override
  String get careerCancel => 'ยกเลิก';

  @override
  String get careerDelete => 'ลบ';

  @override
  String get careerNoSavesYet =>
      'ยังไม่มีเซฟ\nเริ่มเกมใหม่เพื่อนำทัพชาติของคุณ';

  @override
  String get careerUnknownNation => 'ไม่ทราบ';

  @override
  String careerPlayedMinutes(int minutes) {
    return '$minutes นาที';
  }

  @override
  String careerPlayedHours(int hours, int minutes) {
    return '$hours ชม. $minutes นาที';
  }

  @override
  String careerLastPlayed(String when) {
    return 'เล่นล่าสุด $when';
  }

  @override
  String get careerJustNow => 'เมื่อสักครู่';

  @override
  String get careerYesterday => 'เมื่อวาน';

  @override
  String careerMinutesAgo(int n) {
    return '$n นาทีที่แล้ว';
  }

  @override
  String careerHoursAgo(int n) {
    return '$n ชม. ที่แล้ว';
  }

  @override
  String careerDaysAgo(int n) {
    return '$n วันที่แล้ว';
  }

  @override
  String careerRoadToWorldCup(int year) {
    return 'เส้นทางสู่ชิงแชมป์โลก $year';
  }

  @override
  String get careerManagerCareerTitle => 'อาชีพผู้จัดการทีม';

  @override
  String careerCouldNotLoad(String error) {
    return 'โหลดไม่ได้\n$error';
  }

  @override
  String get careerCycleByCycle => 'แยกตามรอบ';

  @override
  String careerCyclesNationsLed(int cycles, int nations) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles รอบ',
    );
    String _temp1 = intl.Intl.pluralLogic(
      nations,
      locale: localeName,
      other: 'คุม $nations ชาติ',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get careerStatTitles => 'แชมป์';

  @override
  String get careerStatPlayed => 'แข่ง';

  @override
  String get careerStatWon => 'ชนะ';

  @override
  String get careerStatDrawn => 'เสมอ';

  @override
  String get careerStatLost => 'แพ้';

  @override
  String careerGoalsWinRate(
    int goalsFor,
    int goalsAgainst,
    String gd,
    int winRate,
  ) {
    return 'ประตู $goalsFor–$goalsAgainst  ($gd)  ·  อัตราชนะ $winRate%';
  }

  @override
  String get careerRecordResults => 'ผลการแข่งขันที่เป็นสถิติ';

  @override
  String get careerBestWin => 'ชนะดีที่สุด';

  @override
  String get careerWorstDefeat => 'แพ้หนักที่สุด';

  @override
  String careerVsOpponentDate(String opponent, String date) {
    return 'พบ $opponent · $date';
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
    return 'ชนะ $won เสมอ $drawn แพ้ $lost  ·  ได้ $goalsFor เสีย $goalsAgainst ($gd)';
  }

  @override
  String get careerWorldCupLabel => 'ชิงแชมป์โลก';

  @override
  String get careerContinentalLabel => 'ชิงแชมป์ทวีป';

  @override
  String get messagesTitle => 'ข้อความ';

  @override
  String get messagesNoMessagesYet => 'ยังไม่มีข้อความ';

  @override
  String messagesCouldNotLoad(String error) {
    return 'โหลดข้อความไม่ได้\n$error';
  }

  @override
  String get messagesDone => 'เสร็จ';

  @override
  String get messagesNext => 'ถัดไป';

  @override
  String get rankingWorldRanking => 'อันดับโลก';

  @override
  String rankingCouldNotLoad(String error) {
    return 'โหลดอันดับไม่ได้\n$error';
  }

  @override
  String get rankingNoRanking => 'ไม่มีอันดับ';

  @override
  String get rankingAll => 'ทั้งหมด';

  @override
  String get rankingYourTeam => 'ทีมของคุณ';

  @override
  String get rankingYourRankingOverTime => 'อันดับของคุณตามช่วงเวลา';

  @override
  String rankingNowRank(int rank) {
    return 'ตอนนี้ #$rank';
  }

  @override
  String rankingBestWorst(int best, int worst) {
    return 'ดีสุด #$best · แย่สุด #$worst';
  }

  @override
  String get friendliesTitle => 'เกมกระชับมิตร';

  @override
  String friendliesLoadError(String error) {
    return 'โหลดเกมกระชับมิตรไม่ได้\n$error';
  }

  @override
  String get friendliesContinue => 'ดำเนินการต่อ';

  @override
  String friendliesArrangeIntro(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ช่วงว่าง $count ช่วง',
    );
    return 'จัดเกมอุ่นเครื่องสำหรับ $_temp0 ก่อนเกมทางการนัดถัดไป แตะเลือกคู่แข่ง หรือปล่อยว่างไว้';
  }

  @override
  String get friendliesFree => 'ว่าง';

  @override
  String matchGoalsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ประตู',
      one: '1 ประตู',
    );
    return '$_temp0';
  }

  @override
  String get matchGoalsTitle => 'ประตู';

  @override
  String get matchGoalsNone => 'ไม่มีประตู';

  @override
  String get matchGoalPenalty => 'จุดโทษ';

  @override
  String get matchGoalSetPiece => 'ลูกนิ่ง';

  @override
  String matchGoalAssist(String name) {
    return 'แอสซิสต์ $name';
  }

  @override
  String get friendliesHome => 'เหย้า';

  @override
  String get friendliesAway => 'เยือน';

  @override
  String get friendliesNoneThisWindow => 'ไม่มีเกมกระชับมิตรในช่วงนี้';

  @override
  String friendliesConfirmCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count นัด',
    );
    return 'ยืนยัน $_temp0';
  }

  @override
  String get friendliesMonthJan => 'ม.ค.';

  @override
  String get friendliesMonthFeb => 'ก.พ.';

  @override
  String get friendliesMonthMar => 'มี.ค.';

  @override
  String get friendliesMonthApr => 'เม.ย.';

  @override
  String get friendliesMonthMay => 'พ.ค.';

  @override
  String get friendliesMonthJun => 'มิ.ย.';

  @override
  String get friendliesMonthJul => 'ก.ค.';

  @override
  String get friendliesMonthAug => 'ส.ค.';

  @override
  String get friendliesMonthSep => 'ก.ย.';

  @override
  String get friendliesMonthOct => 'ต.ค.';

  @override
  String get friendliesMonthNov => 'พ.ย.';

  @override
  String get friendliesMonthDec => 'ธ.ค.';

  @override
  String get resultsMyMatches => 'เกมของฉัน';

  @override
  String resultsCouldNotLoad(String error) {
    return 'โหลดผลการแข่งขันไม่ได้\n$error';
  }

  @override
  String get resultsNoFixtures => 'ไม่มีโปรแกรมแข่งขัน';

  @override
  String get resultsVs => 'พบ';

  @override
  String get resultsStageQualifier => 'รอบคัดเลือก';

  @override
  String get resultsStageFriendly => 'กระชับมิตร';

  @override
  String get resultsStageGroupStage => 'รอบแบ่งกลุ่ม';

  @override
  String get resultsStageSemiFinal => 'รอบรองชนะเลิศ';

  @override
  String get resultsStageFinal => 'นัดชิงชนะเลิศ';

  @override
  String get resultsStageContinentalClash => 'คอนติเนนทัล แคลช';

  @override
  String get resultsStageFinalsGroup => 'กลุ่มรอบสุดท้าย';

  @override
  String get resultsStageRoundOf32 => 'รอบ 32 ทีม';

  @override
  String get resultsStageRoundOf16 => 'รอบ 16 ทีม';

  @override
  String get resultsStageQuarterFinal => 'รอบ 8 ทีม';

  @override
  String get resultsStageThirdPlace => 'ชิงอันดับ 3';

  @override
  String get matchSetupWarnCaptain => 'ยังไม่ได้เลือกกัปตัน แตะเพื่อมอบปลอกแขน';

  @override
  String matchSetupWarnCaptainInjured(String name) {
    return '$name บาดเจ็บและนำทีมลงสนามนัดนี้ไม่ได้ แตะเพื่อมอบปลอกแขนให้คนอื่น';
  }

  @override
  String matchSetupWarnCaptainSuspended(String name) {
    return '$name ติดโทษแบนนัดนี้ แตะเพื่อมอบปลอกแขนให้คนอื่น';
  }

  @override
  String matchSetupWarnCaptainDropped(String name) {
    return '$name ถือปลอกแขนแต่ไม่ได้อยู่ในทีมชุดนี้ แตะเพื่อมอบให้คนอื่น';
  }

  @override
  String get matchSetupWarnSetPieces =>
      'ยังไม่ได้เลือกผู้เตะลูกตั้งเตะ แตะเพื่อเลือกคนรับหน้าที่';

  @override
  String get matchSetupWarnBoth =>
      'ยังไม่มีกัปตันและผู้เตะลูกตั้งเตะ แตะเพื่อกำหนด';

  @override
  String matchStageMatchday(int matchday) {
    return 'นัดที่ $matchday';
  }

  @override
  String get squadCaptain => 'กัปตัน';

  @override
  String deptEffectYouth(int points) {
    return 'ดาวรุ่งจากอะคาเดมีมีค่าพลังรวมดีขึ้นราว $points';
  }

  @override
  String deptEffectCommercial(String amount) {
    return 'ได้คืน $amount เมื่อจบรอบ';
  }

  @override
  String deptEffectMedical(int percent) {
    return 'บาดเจ็บลดลง $percent%';
  }

  @override
  String deptEffectNaturalisation(int percent) {
    return 'โอกาส $percent% ที่ผู้เล่นต่างชาติจะขอเปลี่ยนสัญชาติ';
  }

  @override
  String deptEffectBoard(int points) {
    return 'บอร์ดอดทนเพิ่มขึ้น +$points ก่อนเก้าอี้คุณจะสั่นคลอน';
  }

  @override
  String get deptEffectNone => 'ไม่มีผลหากไม่มีงบ';

  @override
  String get statsBestRated => 'เรตติ้ง';

  @override
  String get statsMyCareer => 'อาชีพ';

  @override
  String get statsBestAverageRating => 'เรตติ้งเฉลี่ยสูงสุด';

  @override
  String get statsMyCareerRecord => 'สถิติของคุณ';

  @override
  String get statsNoRatingsRecorded => 'ยังไม่มีการบันทึกเรตติ้ง';

  @override
  String get statsGroupRecord => 'สถิติ';

  @override
  String get statsGroupRuns => 'สถิติต่อเนื่อง';

  @override
  String get statsGroupExtremes => 'สุดขั้ว';

  @override
  String get statsGroupSplits => 'เหย้าและเยือน';

  @override
  String get statsGroupSquad => 'ผู้เล่นของคุณ';

  @override
  String get statsPlayed => 'จำนวนนัดที่แข่ง';

  @override
  String get statsWinDrawLoss => 'ชนะ–เสมอ–แพ้';

  @override
  String get statsWinRate => 'อัตราชนะ';

  @override
  String get statsGoals => 'ได้:เสียประตู';

  @override
  String get statsCleanSheets => 'คลีนชีต';

  @override
  String get statsFailedToScore => 'ยิงไม่ได้';

  @override
  String get statsLongestWinStreak => 'ชนะติดต่อกันนานที่สุด';

  @override
  String get statsLongestUnbeaten => 'ไม่แพ้ติดต่อกันนานที่สุด';

  @override
  String get statsLongestCleanSheets => 'คลีนชีตติดต่อกันนานที่สุด';

  @override
  String get statsLongestWinless => 'ไม่ชนะติดต่อกันนานที่สุด';

  @override
  String get statsCurrentRun => 'ไม่แพ้ติดต่อกันขณะนี้';

  @override
  String get statsBiggestWin => 'ชนะขาดที่สุด';

  @override
  String get statsHeaviestDefeat => 'แพ้หนักที่สุด';

  @override
  String get statsMostGoalsInAGame => 'ประตูมากที่สุดในเกมเดียว';

  @override
  String get statsShootouts => 'ดวลจุดโทษ ชนะ–แพ้';

  @override
  String get statsComebackWins => 'ชนะแบบพลิกกลับมา';

  @override
  String get statsHome => 'เหย้า';

  @override
  String get statsAway => 'เยือน';

  @override
  String get statsNeutral => 'สนามกลาง';

  @override
  String get statsCompetitive => 'เกมทางการ';

  @override
  String get statsFriendlies => 'กระชับมิตร';

  @override
  String get statsHatTricks => 'แฮตทริก';

  @override
  String get statsBraces => 'เบรซ';

  @override
  String get statsMotms => 'รางวัลแมนออฟเดอะแมตช์';

  @override
  String get statsAssists => 'แอสซิสต์';

  @override
  String get statsCards => 'ใบเหลือง/แดง';

  @override
  String get statsBestRating => 'เรตติ้งรายบุคคลสูงสุด';

  @override
  String statsAppsShort(int apps) {
    return 'ลงเล่น $apps';
  }

  @override
  String statsMotmShort(int motms) {
    return 'MOTM $motms';
  }

  @override
  String get captainArmband => 'C';

  @override
  String get captainCurrent => 'กัปตัน แตะเพื่อถอดปลอกแขน';

  @override
  String get captainFitBorn => 'ผู้นำโดยกำเนิด';

  @override
  String get captainFitNatural => 'กัปตันโดยธรรมชาติ';

  @override
  String get captainFitCapable => 'สวมปลอกแขนได้';

  @override
  String get captainFitUnproven => 'ยังไม่ใช่ผู้นำ';

  @override
  String get captainNone => 'ยังไม่ได้เลือกกัปตัน';

  @override
  String captainMoraleBoost(int morale) {
    return 'ขวัญกำลังใจทีม +$morale';
  }

  @override
  String get resultsCategoryWorldCupQualifying => 'รอบคัดเลือกชิงแชมป์โลก';

  @override
  String get resultsCategoryFriendlies => 'กระชับมิตร';

  @override
  String get resultsCategoryContinentalClash => 'คอนติเนนทัล แคลช';

  @override
  String get resultsCategoryNationsCup => 'เนชันส์คัพ';

  @override
  String get resultsCategoryContinentalCup => 'ชิงแชมป์ทวีป';

  @override
  String get resultsCategoryWorldCupQualifyingShort => 'คัดชิงแชมป์โลก';

  @override
  String get resultsCategoryContinentalQualifyingShort => 'คัดชิงแชมป์ทวีป';

  @override
  String get resultsCategoryContinentalQualifying => 'รอบคัดเลือกชิงแชมป์ทวีป';

  @override
  String get resultsCategoryWorldCupFinals => 'รอบสุดท้ายชิงแชมป์โลก';

  @override
  String get resultsRoundResults => 'ผลการแข่งขันรอบนี้';

  @override
  String get resultsFriendlyInternationals => 'เกมกระชับมิตรทีมชาติ';

  @override
  String get resultsKnockout => 'รอบน็อกเอาต์';

  @override
  String resultsEarlierMatches(int count) {
    return 'เกมก่อนหน้า ($count)';
  }

  @override
  String resultsMatchday(int matchday) {
    return 'นัดที่ $matchday';
  }

  @override
  String get resultsContinue => 'ดำเนินการต่อ';

  @override
  String resultsGroup(String name) {
    return 'กลุ่ม $name';
  }

  @override
  String get achievementsScreenTitle => 'ความสำเร็จ';

  @override
  String get achievementsChallengesTooltip => 'ความท้าทาย';

  @override
  String get achievementsChallengesHeading => 'ความท้าทาย';

  @override
  String get achievementsBrutalTests => 'บททดสอบสุดโหดตลอดอาชีพ';

  @override
  String achievementsCouldNotLoad(String error) {
    return 'โหลดไม่ได้\n$error';
  }

  @override
  String achievementsUnlockedCount(int earned, int total) {
    return 'ปลดล็อก $earned / $total';
  }

  @override
  String achievementsConqueredCount(int done, int total) {
    return 'พิชิต $done / $total';
  }

  @override
  String get achievementsBoardSatisfaction => 'ความพอใจของบอร์ด';

  @override
  String achievementsUnlockedBanner(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ปลดล็อก $count ความสำเร็จ',
    );
    return '$_temp0';
  }

  @override
  String get achCatWins => 'ชัยชนะ';

  @override
  String get achCatMatches => 'จำนวนนัด';

  @override
  String get achCatQualifications => 'การผ่านเข้ารอบ';

  @override
  String get achCatTitles => 'แชมป์';

  @override
  String get achCatMisc => 'อื่นๆ';

  @override
  String get achCatMega => 'สุดยอด';

  @override
  String get achCatGoals => 'ประตู';

  @override
  String get achCatStreaks => 'สถิติต่อเนื่อง';

  @override
  String get achTierBronze => 'ทองแดง';

  @override
  String get achTierSilver => 'เงิน';

  @override
  String get achTierGold => 'ทอง';

  @override
  String get achTierPlatinum => 'แพลทินัม';

  @override
  String achGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ประตู',
    );
    return '$_temp0';
  }

  @override
  String achGoalsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ยิงได้ $count ประตู',
      one: 'ยิงได้ 1 ประตู',
    );
    return '$_temp0';
  }

  @override
  String achCleanSheets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count คลีนชีต',
    );
    return '$_temp0';
  }

  @override
  String achCleanSheetsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'เก็บคลีนชีต $count นัด',
      one: 'เก็บคลีนชีต 1 นัด',
    );
    return '$_temp0';
  }

  @override
  String get achStreakWin5 => 'ชนะจนเป็นนิสัย';

  @override
  String get achStreakWin5Desc => 'ชนะติดต่อกัน 5 นัด';

  @override
  String get achStreakWin10 => 'ฟอร์มร้อนแรง';

  @override
  String get achStreakWin10Desc => 'ชนะติดต่อกัน 10 นัด';

  @override
  String get achStreakWin20 => 'รถถังบดขยี้';

  @override
  String get achStreakWin20Desc => 'ชนะติดต่อกัน 20 นัด';

  @override
  String get achUnbeaten15 => 'ล้มยาก';

  @override
  String get achUnbeaten15Desc => 'ไม่แพ้ติดต่อกัน 15 นัด';

  @override
  String get achUnbeaten30 => 'ไร้เทียมทาน';

  @override
  String get achUnbeaten30Desc => 'ไม่แพ้ติดต่อกัน 30 นัด';

  @override
  String get achHattrick => 'ฮีโร่แฮตทริก';

  @override
  String get achHattrickDesc => 'มีผู้เล่นทำแฮตทริก';

  @override
  String get achMotm10 => 'โดดเด่น';

  @override
  String get achMotm10Desc => 'สะสมรางวัลแมนออฟเดอะแมตช์ 10 ครั้ง';

  @override
  String get achMotm50 => 'ตัวชี้ขาด';

  @override
  String get achMotm50Desc => 'สะสมรางวัลแมนออฟเดอะแมตช์ 50 ครั้ง';

  @override
  String get achPerfect => 'สมบูรณ์แบบ';

  @override
  String get achPerfectDesc => 'มีผู้เล่นได้เรตติ้ง 9.5 ขึ้นไปในเกมเดียว';

  @override
  String get achShootout => 'ใจเย็นเป็นน้ำแข็ง';

  @override
  String get achShootoutDesc => 'ชนะการดวลจุดโทษ 5 ครั้ง';

  @override
  String get achMassacre => 'ถล่มยับ';

  @override
  String get achMassacreDesc => 'ชนะห่าง 7 ประตูขึ้นไป';

  @override
  String get achAnnihilation => 'บดขยี้';

  @override
  String get achAnnihilationDesc => 'ชนะห่าง 10 ประตูขึ้นไป';

  @override
  String get chTierBronze => 'ทองแดง';

  @override
  String get chTierSilver => 'เงิน';

  @override
  String get chTierGold => 'ทอง';

  @override
  String get chTierLegendary => 'ตำนาน';

  @override
  String get chFirstSteps => 'บนม้านั่งข้างสนาม';

  @override
  String get chFirstStepsDesc => 'คุมทีมครบ 5 ปี';

  @override
  String get chUnbeaten10 => 'ฟอร์มร้อนแรง';

  @override
  String get chUnbeaten10Desc => 'ไม่แพ้ในเกมทางการติดต่อกัน 10 นัด';

  @override
  String get chTwoNations => 'ความท้าทายใหม่';

  @override
  String get chTwoNationsDesc => 'คุมทีมชาติ 2 ชาติที่ต่างกัน';

  @override
  String get chCont1 => 'แชมป์ทวีป';

  @override
  String get chCont1Desc => 'คว้าแชมป์ชิงแชมป์ทวีป';

  @override
  String get chNc1 => 'แชมป์เนชันส์คัพ';

  @override
  String get chNc1Desc => 'คว้าแชมป์เนชันส์คัพ';

  @override
  String get chWc1 => 'แชมป์โลก';

  @override
  String get chWc1Desc => 'คว้าแชมป์ชิงแชมป์โลก';

  @override
  String get chYears25 => 'สถาบันแห่งวงการ';

  @override
  String get chYears25Desc => 'คุมทีมครบ 25 ปี';

  @override
  String get chWc3 => 'นักล่าแชมป์';

  @override
  String get chWc3Desc => 'คว้าแชมป์ชิงแชมป์โลก 3 สมัย';

  @override
  String get chWc5 => 'ราชวงศ์';

  @override
  String get chWc5Desc => 'คว้าแชมป์ชิงแชมป์โลก 5 สมัย';

  @override
  String get chWc10 => 'อมตะ';

  @override
  String get chWc10Desc => 'คว้าแชมป์ชิงแชมป์โลก 10 สมัย';

  @override
  String get chWc2Teams => 'ไปที่ไหนก็ได้แชมป์';

  @override
  String get chWc2TeamsDesc => 'คว้าแชมป์ชิงแชมป์โลกกับ 2 ชาติที่ต่างกัน';

  @override
  String get chWc3Teams => 'นักเดินทางรอบโลก';

  @override
  String get chWc3TeamsDesc => 'คว้าแชมป์ชิงแชมป์โลกกับ 3 ชาติที่ต่างกัน';

  @override
  String get chWcStreak3 => 'แชมป์สามสมัยซ้อน';

  @override
  String get chWcStreak3Desc => 'คว้าแชมป์ชิงแชมป์โลก 3 สมัยติดต่อกัน';

  @override
  String get chWcAllconf => 'ผู้พิชิตโลก';

  @override
  String get chWcAllconfDesc => 'คว้าแชมป์ชิงแชมป์โลกกับชาติจากทุกสมาพันธ์ (6)';

  @override
  String get chCont5 => 'ราชาแห่งทวีป';

  @override
  String get chCont5Desc => 'คว้าแชมป์ชิงแชมป์ทวีป 5 สมัย';

  @override
  String get chContAll => 'แกรนด์สแลมหกทวีป';

  @override
  String get chContAllDesc => 'คว้าแชมป์ชิงแชมป์ทวีปของทุกสมาพันธ์ (6)';

  @override
  String get chTreble => 'กวาดเรียบ';

  @override
  String get chTrebleDesc =>
      'คว้าแชมป์ชิงแชมป์โลก แชมป์ทวีป และเนชันส์คัพ ในอาชีพเดียว';

  @override
  String get chNations10 => 'คนเร่ร่อน';

  @override
  String get chNations10Desc => 'คุมทีมชาติ 10 ชาติที่ต่างกัน';

  @override
  String get chYears100 => 'ศตวรรษ';

  @override
  String get chYears100Desc => 'คุมทีมครบ 100 ปี';

  @override
  String get chYears500 => 'ครึ่งสหัสวรรษ';

  @override
  String get chYears500Desc => 'คุมทีมครบ 500 ปี';

  @override
  String get chYears1000 => 'นิรันดร์';

  @override
  String get chYears1000Desc => 'คุมทีมครบ 1000 ปี';

  @override
  String get chGrandmaster => 'ปรมาจารย์';

  @override
  String get chGrandmasterDesc =>
      'คว้าแชมป์ชิงแชมป์โลก 3 สมัย และแชมป์ทวีป 5 สมัย';

  @override
  String get chUndefeated => 'ไร้เทียมทาน';

  @override
  String get chUndefeatedDesc => 'คว้าแชมป์ชิงแชมป์โลกโดยไม่แพ้เลยสักนัด';

  @override
  String get chPerfectQual => 'เส้นทางไร้ที่ติ';

  @override
  String get chPerfectQualDesc => 'ชนะทุกนัดในรอบคัดเลือกชิงแชมป์โลก';

  @override
  String get chMinnow => 'ปาฏิหาริย์ทีมรองบ่อน';

  @override
  String get chMinnowDesc =>
      'คว้าแชมป์ชิงแชมป์โลกกับชาติที่อยู่นอก 32 อันดับแรกของโลก';

  @override
  String get chGrandTour => 'เหย้าและเยือน';

  @override
  String get chGrandTourDesc =>
      'คว้าแชมป์ชิงแชมป์โลกในฐานะเจ้าภาพ และคว้าอีกครั้งในต่างแดน';

  @override
  String get chUnbeaten25 => 'กำแพงเหล็ก';

  @override
  String get chUnbeaten25Desc => 'ไม่แพ้ในเกมทางการติดต่อกัน 25 นัด';

  @override
  String get chGoals10k => 'จักรกลถล่มประตู';

  @override
  String get chGoals10kDesc => 'ยิงครบ 10,000 ประตูตลอดอาชีพ';

  @override
  String get chCleanSheets500 => 'ป้อมปราการ';

  @override
  String get chCleanSheets500Desc => 'เก็บคลีนชีตครบ 500 นัดตลอดอาชีพ';

  @override
  String get chHatTricks25 => 'แฮตทริกจนชิน';

  @override
  String get chHatTricks25Desc => 'ให้ผู้เล่นของคุณทำแฮตทริกรวม 25 ครั้ง';

  @override
  String get chWinStreak25 => 'ไม่หยุดยั้ง';

  @override
  String get chWinStreak25Desc => 'ชนะติดต่อกัน 25 นัด';

  @override
  String get chCont10 => 'ราชวงศ์แห่งทวีป';

  @override
  String get chCont10Desc => 'คว้าแชมป์ชิงแชมป์ทวีป 10 สมัย';

  @override
  String get chPcWc => 'แชมป์ต่อเนื่อง';

  @override
  String chPcWcDesc(int count) {
    return 'คว้าแชมป์ชิงแชมป์โลก $count สมัยในเซฟนี้';
  }

  @override
  String get chPcMajors => 'นักสะสมถ้วย';

  @override
  String chPcMajorsDesc(int count) {
    return 'คว้าถ้วยใหญ่ $count ใบ (ชิงแชมป์โลก ชิงแชมป์ทวีป หรือเนชันส์คัพ)';
  }

  @override
  String get chPcUnbeaten => 'กำแพงเหล็กกล้า';

  @override
  String chPcUnbeatenDesc(int count) {
    return 'ไม่แพ้ในเกมทางการติดต่อกัน $count นัด';
  }

  @override
  String get chPcNations => 'นักเดินทาง';

  @override
  String chPcNationsDesc(int count) {
    return 'คุมทีมชาติ $count ชาติที่ต่างกัน';
  }

  @override
  String get chPcYears => 'เส้นทางอันยาวไกล';

  @override
  String chPcYearsDesc(int count) {
    return 'คุมทีมครบ $count ปี';
  }

  @override
  String achWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ชัยชนะ',
      one: '1 ชัยชนะ',
    );
    return '$_temp0';
  }

  @override
  String achWinsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ชนะ $count นัด',
      one: 'ชนะ 1 นัด',
    );
    return '$_temp0';
  }

  @override
  String achMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count นัด',
    );
    return '$_temp0';
  }

  @override
  String achMatchesDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ลงเล่น $count นัด',
      one: 'ลงเล่น 1 นัด',
    );
    return '$_temp0';
  }

  @override
  String get achQualWc => 'ผ่านเข้ารอบชิงแชมป์โลก';

  @override
  String get achQualWcDesc => 'ผ่านการคัดเลือกไปเล่นชิงแชมป์โลก';

  @override
  String get achQualCont => 'ผ่านเข้ารอบชิงแชมป์ทวีป';

  @override
  String get achQualContDesc => 'ผ่านการคัดเลือกไปเล่นชิงแชมป์ทวีปของคุณ';

  @override
  String get achTitleWc => 'แชมป์โลก';

  @override
  String get achTitleWcDesc => 'คว้าแชมป์ชิงแชมป์โลก';

  @override
  String get achTitleEuro => 'แชมป์ยุโรป';

  @override
  String get achTitleEuroDesc => 'คว้าแชมป์ชิงแชมป์ยุโรป';

  @override
  String get achTitleCopa => 'แชมป์อเมริกาใต้';

  @override
  String get achTitleCopaDesc => 'คว้าแชมป์ถ้วยอเมริกาใต้';

  @override
  String get achTitleAfcon => 'แชมป์แอฟริกา';

  @override
  String get achTitleAfconDesc => 'คว้าแชมป์ชิงแชมป์แอฟริกา';

  @override
  String get achTitleAsia => 'แชมป์เอเชีย';

  @override
  String get achTitleAsiaDesc => 'คว้าแชมป์ชิงแชมป์เอเชีย';

  @override
  String get achTitleConcacaf => 'แชมป์อเมริกาเหนือ';

  @override
  String get achTitleConcacafDesc => 'คว้าแชมป์ถ้วยอเมริกาเหนือ';

  @override
  String get achTitleOfc => 'แชมป์โอเชียเนีย';

  @override
  String get achTitleOfcDesc => 'คว้าแชมป์ถ้วยโอเชียเนีย';

  @override
  String get achTitleNations => 'แชมป์เนชันส์คัพ';

  @override
  String get achTitleNationsDesc => 'คว้าแชมป์เนชันส์คัพ';

  @override
  String get achTitleClash => 'แชมป์คอนติเนนทัล แคลช';

  @override
  String get achTitleClashDesc => 'คว้าแชมป์คอนติเนนทัล แคลช';

  @override
  String get achMarksman => 'จอมถล่มชิงแชมป์โลก';

  @override
  String get achMarksmanDesc =>
      'มีผู้เล่นในทีมยิง 6 ประตูขึ้นไปในรอบสุดท้ายชิงแชมป์โลก';

  @override
  String get achSweep => 'กวาดเรียบ';

  @override
  String get achSweepDesc => 'ครองแชมป์โลกและแชมป์ทวีปในอาชีพเดียว';

  @override
  String get achAllstar => 'ทีมยอดเยี่ยมทัวร์นาเมนต์';

  @override
  String get achAllstarDesc =>
      'มีผู้เล่นติดทีมยอดเยี่ยมของทัวร์นาเมนต์ชิงแชมป์โลก';

  @override
  String get achGoldenboot => 'รองเท้าทองคำ';

  @override
  String get achGoldenbootDesc =>
      'มีผู้เล่นของชาติคุณจบเป็นดาวซัลโวของรายการชิงแชมป์';

  @override
  String get achDemolition => 'รื้อถอน';

  @override
  String get achDemolitionDesc => 'ชนะห่าง 5 ประตูขึ้นไป';

  @override
  String get achievementsNice => 'เยี่ยม!';

  @override
  String get achievementsHardestTests =>
      'บททดสอบที่ยากที่สุดของผู้จัดการทีม ตลอดทั้งอาชีพและกับหลายชาติ';

  @override
  String get achievementsThisSave => 'เซฟนี้';

  @override
  String get achievementsBrutalBadge => 'สุดโหด';

  @override
  String get paywallGoPro => 'อัปเกรดเป็น UNLIMITED';

  @override
  String get paywallOneTimeUnlock => 'ปลดล็อกครั้งเดียว ไม่มีการสมัครสมาชิก';

  @override
  String get paywallBenefitCarryOn =>
      'เซฟนี้จะเล่นต่อจากจุดที่หยุดไว้ทุกอย่าง ทั้งนัดติดทีมชาติ สถิติ และคู่ปรับ ครบถ้วน';

  @override
  String get paywallBenefitNoAds =>
      'ไม่มีโฆษณา ไม่มีไมโครทรานแซกชัน ไม่มีการสมัครสมาชิก จ่ายครั้งเดียว ได้อัปเดตทุกครั้งในอนาคต';

  @override
  String get paywallBenefitSaves =>
      'เซฟได้มากเท่าที่ต้องการ คุมทีมเต็งและทีมรองบ่อนไปพร้อมกัน แล้วดูว่าเกมเดียวกันให้ความรู้สึกต่างกันแค่ไหน';

  @override
  String get paywallBenefitEndless =>
      'เล่นได้ทุกรอบนับจากนี้ เลือกดาวรุ่งอายุ 17 วันนี้ แล้วรู้ในปี 2034 ว่าคุณมองขาดหรือไม่';

  @override
  String get paywallUnlocked => 'ปลดล็อก Unlimited แล้ว ขอให้สนุก!';

  @override
  String get paywallContactingStore => 'กำลังติดต่อสโตร์…';

  @override
  String paywallUnlockProPriced(String price) {
    return 'ปลดล็อก Unlimited · $price';
  }

  @override
  String get paywallRestorePurchases => 'กู้คืนการซื้อ';

  @override
  String get paywallStoreUnavailable => 'สโตร์ไม่พร้อมใช้งาน';

  @override
  String get paywallStoreUnavailableNote =>
      'โหลดราคาไม่ได้ ตรวจสอบการเชื่อมต่อแล้วลองอีกครั้ง';

  @override
  String get paywallTryAgain => 'ลองอีกครั้ง';

  @override
  String get gateTitle => 'รอบแรกของคุณจบลงแล้ว';

  @override
  String get gateLead => 'สี่ปีคือหนึ่งรอบ ยังไม่นานพอจะรู้ว่าคุณคิดถูกหรือไม่';

  @override
  String get gatePriceLead => 'จ่ายครั้งเดียว ใช้ได้ตลอดไป';

  @override
  String get gateBuy => 'ซื้อและเล่นต่อ';

  @override
  String get gateExit => 'ออก';

  @override
  String get gateSaveTitle => 'เซฟนี้ต้องใช้ Pro';

  @override
  String get gateSaveLead =>
      'เซฟที่เลยรอบฟรีไปแล้วและแคมเปญ Pro จะเล่นต่อได้ด้วย Pro ไม่มีอะไรหายไป เซฟนี้ยังรอคุณอยู่เหมือนตอนที่คุณออกไป';

  @override
  String get careerSaveLockedNote => 'ต้องใช้ Pro เพื่อเล่นเซฟนี้ต่อ';

  @override
  String get federationNaturalisation => 'การโอนสัญชาติ';

  @override
  String federationNaturalisedTitle(String name) {
    return '$name โอนสัญชาติแล้ว';
  }

  @override
  String federationNaturalisedBody(String name, String nation) {
    return '$name เปลี่ยนสัญชาติเรียบร้อยและมีสิทธิ์เล่นให้ $nation แล้ว เรียกตัวได้จากหน้าเลือกทีม';
  }

  @override
  String federationCouldNotLoadOffer(String error) {
    return 'โหลดข้อเสนอไม่ได้\n$error';
  }

  @override
  String get federationContinue => 'ดำเนินการต่อ';

  @override
  String get federationOfferToSwitchAllegiance => 'ข้อเสนอเปลี่ยนสัญชาติ';

  @override
  String federationPlayerMeta(String position, int age, String nation) {
    return '$position · อายุ $age · จาก $nation';
  }

  @override
  String federationNaturalisationBlurb(
    String name,
    String playerNation,
    String sourceNation,
  ) {
    return '$name มีความผูกพันกับ $playerNation และยินดีโอนสัญชาติ ตอบรับแล้วจะเรียกตัวได้ ปฏิเสธแล้วเขาจะอยู่กับ $sourceNation ต่อไป';
  }

  @override
  String get federationDecline => 'ปฏิเสธ';

  @override
  String get federationNaturalise => 'โอนสัญชาติ';

  @override
  String get federationBudgetLater => 'ตัดสินใจทีหลัง';

  @override
  String get federationSetYourBudget => 'กำหนดงบประมาณ';

  @override
  String federationCouldNotLoadFinances(String error) {
    return 'โหลดข้อมูลการเงินไม่ได้\n$error';
  }

  @override
  String get federationSaveNotFound => 'ไม่พบเซฟ';

  @override
  String get federationBudgetHeading => 'งบประมาณสมาคม';

  @override
  String federationDistributeBudget(String amount) {
    return 'แบ่ง $amount ให้แต่ละฝ่ายเพื่อเปิดรอบใหม่ ใช้อย่างคุ้มค่า';
  }

  @override
  String federationOverBudget(String amount) {
    return 'เกินกว่าที่สมาคมมีอยู่ $amount ลดลงบ้าง';
  }

  @override
  String get federationAllocateFullBudget =>
      'จัดสรรงบประมาณให้ครบเพื่อเริ่มรอบ';

  @override
  String get federationConfirming => 'กำลังยืนยัน…';

  @override
  String get federationConfirmBudget => 'ยืนยันงบประมาณ';

  @override
  String get federationFinances => 'การเงิน';

  @override
  String get federationInvestmentUpdated => 'อัปเดตการลงทุนแล้ว';

  @override
  String get federationDevelopment => 'การพัฒนาสมาคม';

  @override
  String get federationProjectedAtSeasonEnd => 'คาดการณ์เมื่อจบฤดูกาล';

  @override
  String get federationCentralFunding => 'เงินสนับสนุนส่วนกลาง';

  @override
  String get federationPrizeMoneySoFar => 'เงินรางวัลจนถึงตอนนี้';

  @override
  String get federationCommercialReturn => 'รายได้เชิงพาณิชย์';

  @override
  String get federationThisSeasonLocked => 'ฤดูกาลนี้ (ล็อกแล้ว)';

  @override
  String get federationInvestForNextSeason => 'ลงทุนสำหรับฤดูกาลหน้า';

  @override
  String get federationNextSeasonImpact => 'ผลกระทบฤดูกาลหน้า';

  @override
  String get federationSaving => 'กำลังบันทึก…';

  @override
  String get federationConfirmInvestment => 'ยืนยันการลงทุน';

  @override
  String get federationBalance => 'ยอดเงินสมาคม';

  @override
  String get federationCommittedToStaff => 'ผูกพันค่าจ้างสตาฟฟ์';

  @override
  String get federationFreeToSpend => 'ใช้ได้อิสระ';

  @override
  String get federationWagesNote =>
      'ค่าจ้างจะถูกหักจากยอดเงินเมื่อจบรอบ เงินส่วนนี้จึงถูกกันไว้แล้ว';

  @override
  String get federationInvestAtCeremony =>
      'ลงทุนสำหรับฤดูกาลหน้าได้ในพิธีปิดรอบ';

  @override
  String federationLevelBadge(int level) {
    return 'L$level';
  }

  @override
  String get federationAcademyProspects => 'ดาวรุ่งจากอะคาเดมี';

  @override
  String federationPlusOverall(int value) {
    return 'ค่าพลังรวม +$value';
  }

  @override
  String get federationInjuryRisk => 'ความเสี่ยงบาดเจ็บ';

  @override
  String get federationNaturalisationChance => 'โอกาสโอนสัญชาติ';

  @override
  String get federationBoardPatience => 'ความอดทนของบอร์ด';

  @override
  String get federationUnallocated => 'ยังไม่จัดสรร';

  @override
  String get nationsVitrineTitle => 'ตู้โชว์ทีมชาติ';

  @override
  String nationsCouldNotLoad(String error) {
    return 'โหลดข้อมูลชาติไม่ได้\n$error';
  }

  @override
  String get nationsNoNation => 'ไม่มีข้อมูลชาติ';

  @override
  String get nationsHonours => 'เกียรติประวัติ';

  @override
  String get nationsRankingHistory => 'ประวัติอันดับโลก';

  @override
  String get nationsTopScorers => 'ดาวซัลโวตลอดกาล';

  @override
  String get nationsTitles => 'แชมป์';

  @override
  String get nationsYourTeam => 'ทีมของคุณ';

  @override
  String get nationsWorld => 'โลก';

  @override
  String get nationsWorldCup => 'ชิงแชมป์โลก';

  @override
  String get nationsContinental => 'ชิงแชมป์ทวีป';

  @override
  String nationsAppearances(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'เข้าร่วม $count ครั้ง',
      one: 'เข้าร่วม 1 ครั้ง',
    );
    return '$_temp0';
  }

  @override
  String get nationsNotEnoughHistory =>
      'ยังมีประวัติไม่มากพอ กลับมาดูอีกครั้งหลังผ่านไปสักหนึ่งหรือสองรอบ';

  @override
  String nationsBestRank(int rank) {
    return 'ดีสุด: #$rank';
  }

  @override
  String nationsNowRank(int rank) {
    return 'ตอนนี้: #$rank';
  }

  @override
  String get nationsNoGoals => 'ยังไม่มีการบันทึกประตู';

  @override
  String get nationsGoalsAbbrev => 'ประตู';

  @override
  String get nationsHosts => 'เจ้าภาพ';

  @override
  String get nationsSelectTitle => 'เลือกทีมชาติ';

  @override
  String nationsCouldNotLoadNations(String error) {
    return 'โหลดรายชื่อชาติไม่ได้\n$error';
  }

  @override
  String get nationsNoMatch => 'ไม่พบชาติที่ตรงกัน';

  @override
  String get nationsSelectHeading => 'เลือกทีมชาติ';

  @override
  String get nationsSearchHint => 'ค้นหาประเทศ…';

  @override
  String get nationsRank => 'อันดับ ';

  @override
  String get nationsPremium => 'พรีเมียม';

  @override
  String get nationsSelect => 'เลือก';

  @override
  String get statsTeamRecords => 'สถิติทีม';

  @override
  String get statsRecordBook => 'สมุดสถิติ';

  @override
  String statsCouldNotLoadStats(String error) {
    return 'โหลดสถิติไม่ได้\n$error';
  }

  @override
  String get statsNoData => 'ไม่มีข้อมูล';

  @override
  String get statsTopScorers => 'ดาวซัลโว';

  @override
  String get statsMostGamesPlayed => 'ลงเล่นมากที่สุด';

  @override
  String get statsTeam => 'ทีม';

  @override
  String get statsTopScorersShort => 'ดาวซัลโว';

  @override
  String get statsMostGames => 'ลงเล่นมากสุด';

  @override
  String get statsNoGoalsRecorded => 'ยังไม่มีการบันทึกประตู';

  @override
  String get statsUnknown => 'ไม่ทราบ';

  @override
  String get playerTitle => 'ผู้เล่น';

  @override
  String playerLoadError(String error) {
    return 'โหลดข้อมูลผู้เล่นไม่ได้\n$error';
  }

  @override
  String get playerNotFound => 'ไม่พบผู้เล่น';

  @override
  String get playerClub => 'สโมสร';

  @override
  String get playerClubRole => 'ที่สโมสร';

  @override
  String get playerPosition => 'ตำแหน่ง';

  @override
  String get playerPotential => 'ศักยภาพ';

  @override
  String get playerAge => 'อายุ';

  @override
  String get playerValue => 'มูลค่า';

  @override
  String get clubFirstChoice => 'ได้เล่นทุกสัปดาห์';

  @override
  String get clubRotation => 'เข้าๆ ออกๆ';

  @override
  String get clubFringe => 'แทบไม่ได้เล่น';

  @override
  String get clubFrozenOut => 'ไม่ได้เล่น';

  @override
  String clubAtClub(String club, String standing) {
    return '$club: $standing';
  }

  @override
  String yWinUpset0(String opponent, String score) {
    return 'ดูบอลมาสามสิบปี ไม่เคยคิดว่าจะได้เห็นแบบนี้ ชนะ $opponent $score';
  }

  @override
  String yWinUpset1(String opponent, String score) {
    return 'ไม่มีใครให้ราคาเลยตอนเจอ $opponent $score ไม่มีใครเลยจริงๆ';
  }

  @override
  String yWinUpset2(String opponent, String score) {
    return '$score ใส่ $opponent ไปปลุกเพื่อนบ้านได้เลย';
  }

  @override
  String yWinUpset3(String opponent, String score) {
    return 'นี่คือคืนแบบที่คนจะเล่าให้หลานฟัง $opponent $score';
  }

  @override
  String yWinUpset4(String opponent, String score) {
    return '$score ใส่ $opponent จะเกิดขึ้นได้ยังไงก็ช่าง มันเกิดขึ้นแล้ว';
  }

  @override
  String yWinUpset5(String opponent, String score) {
    return 'ตามหน้ากระดาษเกมนี้จบตั้งแต่ยังไม่เริ่ม แต่ $opponent $score บอกเป็นอย่างอื่น';
  }

  @override
  String yWinUpset6(String opponent, String score) {
    return 'ชนะ $opponent $score อีกปีหนึ่งไม่มีใครเชื่อสกอร์นี้แน่';
  }

  @override
  String yWinUpset7(String opponent, String score) {
    return '$opponent $score ฉลองให้เต็มที่ แล้วค่อยไปดูโปรแกรมที่เหลือ';
  }

  @override
  String yWinUpset8(String opponent, String score) {
    return '$score ใส่ $opponent และเราอาศัยดวงไปแปดสิบจากเก้าสิบนาที';
  }

  @override
  String yWinUpset9(String opponent, String score) {
    return 'คืนเดียวกับ $opponent ไม่ได้ลบล้างทั้งปี $score';
  }

  @override
  String yWinUpset10(String opponent, String score) {
    return 'ชนะ $opponent $score เดี๋ยวก็มีคนบอกว่าเราพลิกฟื้นแล้ว ยังหรอก';
  }

  @override
  String yWinUpset11(String opponent, String score) {
    return '$opponent $score ยอดเยี่ยม ถามใหม่ตอนที่มันสำคัญจริงๆ';
  }

  @override
  String yWinRoutine0(String opponent, String score) {
    return 'ชนะ $opponent $score เป็นไปตามที่ควรเป็น และมันก็มีความสุขในแบบนั้น';
  }

  @override
  String yWinRoutine1(String opponent, String score) {
    return '$score เหนือ $opponent เลือดเย็น และคำว่าเลือดเย็นนี่คือคำชม';
  }

  @override
  String yWinRoutine2(String opponent, String score) {
    return '$opponent $score ไม่วุ่นวาย ไม่หวาดเสียว ไม่มีอะไรให้บ่น';
  }

  @override
  String yWinRoutine3(String opponent, String score) {
    return '$score เรียบร้อยใส่ $opponent นี่แหละหน้าตาของทีมที่ดีในวันธรรมดาๆ';
  }

  @override
  String yWinRoutine4(String opponent, String score) {
    return '$score ใส่ $opponent งานเสร็จ ไม่ได้เรียนรู้อะไร';
  }

  @override
  String yWinRoutine5(String opponent, String score) {
    return 'ชนะ $opponent $score เราควรชนะ และเราก็ชนะ';
  }

  @override
  String yWinRoutine6(String opponent, String score) {
    return '$score แบบมืออาชีพเหนือ $opponent ต่อไป';
  }

  @override
  String yWinRoutine7(String opponent, String score) {
    return 'จัดการ $opponent $score เก็บเข้าแฟ้มแล้วไปต่อ';
  }

  @override
  String yWinRoutine8(String opponent, String score) {
    return '$score ใส่ $opponent แล้วเราต้องปรบมือเหรอ แค่ชนะทีมแบบนั้น';
  }

  @override
  String yWinRoutine9(String opponent, String score) {
    return 'ก็ขอแสดงความยินดีกับทุกคนที่มีส่วนใน $score เหนือ $opponent ละกัน';
  }

  @override
  String yWinRoutine10(String opponent, String score) {
    return '$opponent $score การชนะทีมแบบนั้นคือมาตรฐานขั้นต่ำ ไม่ใช่ความสำเร็จ';
  }

  @override
  String yWinRoutine11(String opponent, String score) {
    return 'เราชนะ $opponent $score แต่ดูเล่นอย่างยากลำบาก';
  }

  @override
  String yWinTight0(String opponent, String score) {
    return '$score ใส่ $opponent ทุกนาทีได้มาด้วยหยาดเหงื่อ';
  }

  @override
  String yWinTight1(String opponent, String score) {
    return 'ต้องใช้ใจล้วนๆ $opponent $score';
  }

  @override
  String yWinTight2(String opponent, String score) {
    return 'ชนะ $opponent $score แบบยากเย็น ซึ่งเป็นแบบที่ยั่งยืน';
  }

  @override
  String yWinTight3(String opponent, String score) {
    return '$score ใส่ $opponent ทีมที่ชนะเกมแบบนี้ได้ คือทีมที่ยังยืนอยู่ในเดือนมิถุนายน';
  }

  @override
  String yWinTight4(String opponent, String score) {
    return 'ลุ้นจนเหงื่อตก ไม่สวย แต่ชนะ $opponent $score';
  }

  @override
  String yWinTight5(String opponent, String score) {
    return 'ชนะ $opponent $score เก็บสามแต้มแล้วอย่าย้อนดูอีกเลย';
  }

  @override
  String yWinTight6(String opponent, String score) {
    return '$score $opponent ทำให้เราต้องสู้ทุกตารางนิ้ว';
  }

  @override
  String yWinTight7(String opponent, String score) {
    return '$opponent $score ไม่สวย แต่นับเหมือนกัน';
  }

  @override
  String yWinTight8(String opponent, String score) {
    return '$score ใส่ $opponent และเราทำให้มันยากกว่าที่ควรเป็นสิบเท่า';
  }

  @override
  String yWinTight9(String opponent, String score) {
    return 'เราไม่ควรต้องประคองตัวรอดกับ $opponent $score';
  }

  @override
  String yWinTight10(String opponent, String score) {
    return '$opponent $score ชนะก็จริง แต่ไม่ได้เรียนรู้อะไรดีๆ เกี่ยวกับตัวเองเลย';
  }

  @override
  String yWinTight11(String opponent, String score) {
    return '$score ที่ดูดีเกินจริงสำหรับเราเมื่อเจอ $opponent';
  }

  @override
  String yDrew0(String opponent, String score) {
    return 'ได้หนึ่งแต้มจาก $opponent $score เก็บไว้แล้วไปต่อ';
  }

  @override
  String yDrew1(String opponent, String score) {
    return '$score กับ $opponent บ่ายแบบนี้ยังมีที่แย่กว่าอีกเยอะ';
  }

  @override
  String yDrew2(String opponent, String score) {
    return 'ยัน $opponent ไว้ได้ $score ไม่ใช่ทุกอย่างจะต้องเป็นเรื่องใหญ่';
  }

  @override
  String yDrew3(String opponent, String score) {
    return '$opponent $score หนึ่งแต้มก็คือหนึ่งแต้ม ตารางไม่ถามว่าได้มายังไง';
  }

  @override
  String yDrew4(String opponent, String score) {
    return '$score กับ $opponent ทำแต้มหล่นสองหรือเก็บได้หนึ่ง เลือกอารมณ์เอาเอง';
  }

  @override
  String yDrew5(String opponent, String score) {
    return 'เสมอ $opponent $score ไม่มีใครดีใจ ไม่มีใครโกรธจัด';
  }

  @override
  String yDrew6(String opponent, String score) {
    return '$opponent $score เก้าสิบนาทีที่น่าลืมที่สุดของปี';
  }

  @override
  String yDrew7(String opponent, String score) {
    return 'แบ่งแต้มกับ $opponent $score เดินหน้าต่อ';
  }

  @override
  String yDrew8(String opponent, String score) {
    return '$score กับ $opponent การเสมอแบบนี้แหละที่ทำให้แคมเปญค่อยๆ ตายไปเงียบๆ';
  }

  @override
  String yDrew9(String opponent, String score) {
    return 'โยนสองแต้มทิ้งกับ $opponent $score เรียกเป็นอย่างอื่นไม่ได้';
  }

  @override
  String yDrew10(String opponent, String score) {
    return '$opponent $score เรามีเวลาเก้าสิบนาทีแต่ไม่รู้จะทำอะไรกับมัน';
  }

  @override
  String yDrew11(String opponent, String score) {
    return '$score กับ $opponent ที่ไม่มีใครจำได้ แต่ทุกคนต้องจ่ายราคา';
  }

  @override
  String yLost0(String opponent, String score) {
    return 'แพ้ $opponent $score มันเกิดขึ้นได้';
  }

  @override
  String yLost1(String opponent, String score) {
    return '$opponent $score ไม่มีใครต้องถูกแขวน ไปเกมต่อไป';
  }

  @override
  String yLost2(String opponent, String score) {
    return 'แพ้ $opponent $score ทั้งที่ทุ่มสุดตัว บางวันมันก็ไม่พอ';
  }

  @override
  String yLost3(String opponent, String score) {
    return '$score ให้ $opponent เงยหน้าขึ้น ทีมนี้ยังมีอะไรอีกเยอะ';
  }

  @override
  String yLost4(String opponent, String score) {
    return '$opponent $score เราเป็นรองและไม่มีข้อโต้แย้ง';
  }

  @override
  String yLost5(String opponent, String score) {
    return 'แพ้ $opponent $score ตั้งหลักใหม่';
  }

  @override
  String yLost6(String opponent, String score) {
    return '$score ให้ $opponent ไม่น่าอาย แต่ยังไม่ดีพอ';
  }

  @override
  String yLost7(String opponent, String score) {
    return 'แพ้ $opponent $score เรียนรู้อะไรจากมันซะ ไม่งั้นก็เสียเปล่า';
  }

  @override
  String yLost8(String opponent, String score) {
    return '$score ให้ $opponent และเราทำอะไรพวกเขาไม่ได้เลย';
  }

  @override
  String yLost9(String opponent, String score) {
    return 'แพ้ $opponent $score ปัญหาเดิม เดือนเดิม ข้ออ้างเดิมกำลังจะมา';
  }

  @override
  String yLost10(String opponent, String score) {
    return '$opponent $score ถึงจุดไหนที่มันจะเลิกเป็นแค่โชคร้าย?';
  }

  @override
  String yLost11(String opponent, String score) {
    return 'แพ้ $opponent $score ผลแบบนี้ควรมีใครต้องรับผิดชอบ';
  }

  @override
  String yLostBadly0(String opponent, String score) {
    return '$score ให้ $opponent แค่คืนเดียวที่แย่ ตัดสินทีมจากทั้งแคมเปญ ไม่ใช่นัดนี้';
  }

  @override
  String yLostBadly1(String opponent, String score) {
    return 'ไม่มีใครเจ็บปวดกับ $score ต่อ $opponent มากไปกว่านักเตะเอง';
  }

  @override
  String yLostBadly2(String opponent, String score) {
    return '$opponent $score น่าเกลียด และไม่ใช่ตัวตนของทีมนี้';
  }

  @override
  String yLostBadly3(String opponent, String score) {
    return '$score ที่อยากลืมกับ $opponent ครั้งหน้าพวกเขาจะสู้กลับ';
  }

  @override
  String yLostBadly4(String opponent, String score) {
    return '$score ให้ $opponent ผมไม่มีคำพูด ทั้งที่ถูกจ้างมาให้พูด';
  }

  @override
  String yLostBadly5(String opponent, String score) {
    return '$opponent $score ต้องมีใครรับผิดชอบเรื่องนี้';
  }

  @override
  String yLostBadly6(String opponent, String score) {
    return 'ขอให้ลบ $score กับ $opponent ออกจากสถิติและจากความทรงจำ';
  }

  @override
  String yLostBadly7(String opponent, String score) {
    return 'แพ้ $opponent $score สกอร์แบบนี้แก้ตัวยังไงก็ไม่ขึ้น';
  }

  @override
  String yLostBadly8(String opponent, String score) {
    return 'นั่นไม่ใช่การแพ้ $opponent แต่คือการยอมแพ้ $score';
  }

  @override
  String yLostBadly9(String opponent, String score) {
    return '$score ให้ $opponent คนเสียเงินซื้อตั๋วมาดูสิ่งนั้น';
  }

  @override
  String yLostBadly10(String opponent, String score) {
    return '$opponent $score ถ้าแบบนี้ยังไม่ทำให้อะไรเปลี่ยน ก็ไม่มีอะไรเปลี่ยนแล้ว';
  }

  @override
  String yLostBadly11(String opponent, String score) {
    return 'เคยเห็นทีมนี้โดนขายหน้ามาแล้ว แต่ $score จาก $opponent คือจุดต่ำสุดใหม่';
  }

  @override
  String yWinUpset12(String opponent, String score) {
    return 'ชนะ $opponent $score จดวันที่ไว้เลย เดี๋ยวจะมีคนถามว่าตอนนั้นคุณอยู่ไหน';
  }

  @override
  String yWinUpset13(String opponent, String score) {
    return 'นอกห้องแต่งตัวไม่มีใครเชื่อเลย $score กับ $opponent คำว่าภูมิใจยังน้อยไป';
  }

  @override
  String yWinUpset14(String opponent, String score) {
    return '$score กับ $opponent! ทุกคนวิ่งจนหมดแรงไม่เหลืออะไรเลย';
  }

  @override
  String yWinUpset15(String opponent, String score) {
    return 'ล้มยักษ์ $opponent $score นี่แหละเหตุผลที่เรากลับมาดูทุกครั้ง';
  }

  @override
  String yWinUpset16(String opponent, String score) {
    return '$score กับ $opponent ทุกคำทำนายเพิ่งปลิวออกนอกหน้าต่างไป';
  }

  @override
  String yWinUpset17(String opponent, String score) {
    return 'ตัวเต็งตัวจริง: $opponent สกอร์สุดท้าย: $score เป็นของเรา';
  }

  @override
  String yWinUpset18(String opponent, String score) {
    return 'หนึ่งในเซอร์ไพรส์แห่งปี: $score กับ $opponent';
  }

  @override
  String yWinUpset19(String opponent, String score) {
    return '$opponent $score ไม่มีใครคาดไว้และไม่มีใครอธิบายได้';
  }

  @override
  String yWinUpset20(String opponent, String score) {
    return '$score กับ $opponent สวยงาม ทีนี้ทุกคนจะลืมว่าที่เหลือของปีมันแย่แค่ไหน';
  }

  @override
  String yWinUpset21(String opponent, String score) {
    return '$score กับ $opponent แล้วขบวนก็เต็มทันที ผมอยู่ตั้งแต่ตอนมันยังว่าง';
  }

  @override
  String yWinUpset22(String opponent, String score) {
    return '$opponent $score ยอดเยี่ยม แต่เดี๋ยวก็หาทางทำมันพังจนได้';
  }

  @override
  String yWinUpset23(String opponent, String score) {
    return 'คืนใหญ่กับ $opponent $score นกนางแอ่นตัวเดียวไม่ได้ทำให้เป็นหน้าร้อน';
  }

  @override
  String yLostBadly12(String opponent, String score) {
    return '$score กับ $opponent เจ็บเพราะเราใส่ใจ แต่ยังไงก็เชียร์พวกเขาต่อ';
  }

  @override
  String yLostBadly13(String opponent, String score) {
    return 'คืนที่อยากลืมกับ $opponent $score คนที่เจ็บที่สุดคือนักเตะ';
  }

  @override
  String yLostBadly14(String opponent, String score) {
    return '$opponent $score เงยหน้าขึ้น ทีมจะถูกตัดสินจากการตอบโต้หลังจากนี้';
  }

  @override
  String yLostBadly15(String opponent, String score) {
    return '$score กับ $opponent แย่ ใช่ วันสิ้นโลก ไม่ใช่';
  }

  @override
  String yLostBadly16(String opponent, String score) {
    return '$score กับ $opponent ผลที่จะถูกพูดถึงไปอีกหลายปีด้วยเหตุผลที่ผิด';
  }

  @override
  String yLostBadly17(String opponent, String score) {
    return '$opponent ชนะ $score หลังจากนี้ครั้งหน้าไม่มีใครควรแปลกใจ';
  }

  @override
  String yLostBadly18(String opponent, String score) {
    return 'หนึ่งในคืนที่แย่ที่สุดในรอบนาน: $score กับ $opponent';
  }

  @override
  String yLostBadly19(String opponent, String score) {
    return '$opponent $score จะมีคำถามตามมา และควรจะมี';
  }

  @override
  String yLostBadly20(String opponent, String score) {
    return '$score กับ $opponent คำว่าน่าอายยังเบาไป';
  }

  @override
  String yLostBadly21(String opponent, String score) {
    return 'แพ้ $opponent $score คนสุดท้ายที่ออกไปช่วยปิดไฟด้วย';
  }

  @override
  String yLostBadly22(String opponent, String score) {
    return '$opponent $score ผมไม่แปลกใจแล้ว และนั่นแหละที่น่ากลัว';
  }

  @override
  String yLostBadly23(String opponent, String score) {
    return '$score $opponent ใครบางคนข้างบนควรอัปเดตเรซูเม่คืนนี้';
  }

  @override
  String yWinRout0(String opponent, String score) {
    return '$score กับ $opponent! ฟุตบอลแบบนี้ทำให้ทั้งประเทศยิ้มได้';
  }

  @override
  String yWinRout1(String opponent, String score) {
    return 'ถล่ม $opponent $score ฟอร์มสุดยอด';
  }

  @override
  String yWinRout2(String opponent, String score) {
    return '$score เจอ $opponent คืนนี้ทุกอย่างลงตัว';
  }

  @override
  String yWinRout3(String opponent, String score) {
    return 'ถล่ม $opponent $score เก็บไฮไลต์ไว้เลย เดี๋ยวจะอยากดูอีก';
  }

  @override
  String yWinRout4(String opponent, String score) {
    return '$opponent $score นี่คือทีมที่สนุกกับฟุตบอลของตัวเอง';
  }

  @override
  String yWinRout5(String opponent, String score) {
    return '$score กับ $opponent และน่าจะได้มากกว่านี้ด้วย สุดยอด';
  }

  @override
  String yWinRout6(String opponent, String score) {
    return '$score กับ $opponent สกอร์ที่ต้องดูซ้ำสองรอบ';
  }

  @override
  String yWinRout7(String opponent, String score) {
    return 'ชนะ $opponent $score หลังครึ่งชั่วโมงแรกก็หมดลุ้นแล้ว';
  }

  @override
  String yWinRout8(String opponent, String score) {
    return 'สกอร์สุดท้าย: $score กับ $opponent ชัยชนะที่ขาดที่สุดในรอบนาน';
  }

  @override
  String yWinRout9(String opponent, String score) {
    return '$opponent $score ทีมหนึ่งมาเพื่อเล่น อีกทีมไม่ได้ลงจากรถบัสด้วยซ้ำ';
  }

  @override
  String yWinRout10(String opponent, String score) {
    return '$score $opponent ไม่มีคำตอบให้อะไรเลย';
  }

  @override
  String yWinRout11(String opponent, String score) {
    return 'ขยี้: $score กับ $opponent';
  }

  @override
  String yWinRout12(String opponent, String score) {
    return '$score กับ $opponent ดีนะ แต่พวกเขาไม่ใช่มาตรวัด';
  }

  @override
  String yWinRout13(String opponent, String score) {
    return '$score กับ $opponent ปลุกผมตอนที่เราทำแบบนี้กับทีมเก่งๆ';
  }

  @override
  String yWinRout14(String opponent, String score) {
    return '$opponent $score สนุกดี แต่ผมเคยเห็นทีมที่เล่นดีแบบนี้แล้วไม่ได้อะไรเลย';
  }

  @override
  String yWinRout15(String opponent, String score) {
    return '$score แล้วทุกคนก็เป็นอัจฉริยะอีกแล้ว คู่แข่งคือ $opponent';
  }

  @override
  String yWinRout16(String opponent, String score) {
    return '$score กับ $opponent อย่าเพิ่งตื่นเต้น มันพิสูจน์อะไรได้น้อยมาก';
  }

  @override
  String yWinRout17(String opponent, String score) {
    return '$opponent $score สนุกให้เต็มที่ แล้วนึกถึงครั้งก่อนที่เราตื่นเต้นว่าจบยังไง';
  }

  @override
  String yWinShootout0(String opponent) {
    return 'ผ่านเข้ารอบด้วยการดวลจุดโทษกับ $opponent! ใจเหล็กกันทุกคน';
  }

  @override
  String yWinShootout1(String opponent) {
    return 'ดวลจุดโทษกับ $opponent และเรานิ่งพอ ไปกอดคนแปลกหน้าสักคน';
  }

  @override
  String yWinShootout2(String opponent) {
    return 'ชนะการดวลจุดโทษกับ $opponent หัวใจผมรับไม่ไหวแล้ว';
  }

  @override
  String yWinShootout3(String opponent) {
    return 'ชนะจุดโทษ $opponent ไปรอบต่อไป';
  }

  @override
  String yWinShootout4(String opponent) {
    return 'เกมกับ $opponent ตัดสินที่จุดโทษ และเรายิงได้มากกว่า';
  }

  @override
  String yWinShootout5(String opponent) {
    return 'ชนะจุดโทษ $opponent ทางที่ยากที่สุด แต่ก็ผ่าน';
  }

  @override
  String yWinShootout6(String opponent) {
    return 'ผ่านเข้ารอบด้วยจุดโทษกับ $opponent ถูกหวย ลืมฟอร์มไปเถอะ';
  }

  @override
  String yWinShootout7(String opponent) {
    return 'เล่นแบบนั้นแล้วชนะจุดโทษ $opponent เหรอ ดวงล้วนๆ ใครๆ ก็รู้';
  }

  @override
  String yWinShootout8(String opponent) {
    return 'ผ่าน $opponent ด้วยจุดโทษ ไม่ควรต้องไปถึงตรงนั้นเลย';
  }

  @override
  String yKnockoutWin0(String opponent, String score) {
    return 'ผ่านเข้ารอบ $score กับ $opponent และความฝันยังไม่จบ';
  }

  @override
  String yKnockoutWin1(String opponent, String score) {
    return 'ชนะรอบน็อกเอาต์: $score กับ $opponent ทั้งประเทศเริ่มเชื่อได้แล้ว';
  }

  @override
  String yKnockoutWin2(String opponent, String score) {
    return '$score กับ $opponent แล้วไปรอบต่อไป คืนที่ยอดเยี่ยม';
  }

  @override
  String yKnockoutWin3(String opponent, String score) {
    return '$opponent กลับบ้าน $score ลุยต่อ';
  }

  @override
  String yKnockoutWin4(String opponent, String score) {
    return 'น็อกเอาต์: $score กับ $opponent ยืนยันรอบต่อไปแล้ว';
  }

  @override
  String yKnockoutWin5(String opponent, String score) {
    return 'ผ่านเข้ารอบ: $score กับ $opponent';
  }

  @override
  String yKnockoutWin6(String opponent, String score) {
    return '$opponent ตกรอบ $score รอบต่อไปรออยู่';
  }

  @override
  String yKnockoutWin7(String opponent, String score) {
    return 'ชนะ $score กับ $opponent รอบน็อกเอาต์ไม่มีใครถามว่าชนะยังไง';
  }

  @override
  String yKnockoutWin8(String opponent, String score) {
    return 'ผ่าน $opponent $score คู่แข่งคนต่อไปจะไม่ใจดีแบบนี้';
  }

  @override
  String yKnockoutWin9(String opponent, String score) {
    return '$score กับ $opponent พอสำหรับผ่านเข้ารอบ ครั้งหน้าต้องมากกว่านี้เยอะ';
  }

  @override
  String yKnockoutWin10(String opponent, String score) {
    return '$opponent ตกรอบ $score รอดมากกว่าชนะ';
  }

  @override
  String yKnockoutWin11(String opponent, String score) {
    return 'เข้ารอบต่อไปหลัง $score กับ $opponent อย่าถามว่ายังไง';
  }

  @override
  String yUpsetGap0(String opponent, String gap) {
    return 'อันดับห่างกัน $gap อันดับ แต่เราก็ยังชนะ $opponent สุดยอด';
  }

  @override
  String yUpsetGap1(String opponent, String gap) {
    return '$opponent: อยู่เหนือเรา $gap อันดับ แต่แพ้ ฟุตบอลมันสวยงาม';
  }

  @override
  String yUpsetGap2(String opponent, String gap) {
    return 'อันดับต่างกัน: $gap ผล: ชนะ $opponent อย่าหยุดเชื่อ';
  }

  @override
  String yUpsetGap3(String opponent, String gap) {
    return 'อันดับต่างกันก่อนเตะ: $gap แต่ก็ชนะ $opponent';
  }

  @override
  String yUpsetGap4(String opponent, String gap) {
    return 'ในอันดับโลก $opponent อยู่เหนือเรา $gap อันดับ แต่ไม่ใช่คืนนี้';
  }

  @override
  String yUpsetGap5(String opponent, String gap) {
    return 'ดัชนีเซอร์ไพรส์: อันดับห่างกัน $gap ชัยชนะเป็นของเราเหนือ $opponent';
  }

  @override
  String yUpsetGap6(String opponent, String gap) {
    return 'อันดับโลกห่างจาก $opponent $gap อันดับ คืนเดียวไม่ได้ปิดช่องว่างนั้น';
  }

  @override
  String yUpsetGap7(String opponent, String gap) {
    return '$opponent: เหนือกว่า $gap อันดับ และแพ้ อันดับโลกแทบไม่รู้สึก';
  }

  @override
  String yUpsetGap8(String gap) {
    return 'อันดับต่างกัน: $gap จำตัวเลขนี้ไว้ตอนที่เราแพ้ทีมเล็กครั้งหน้า';
  }

  @override
  String yEatWords0(String opponent) {
    return 'ผมเคยตัดทีมนี้ทิ้งไปแล้ว ผมคิดผิด และไม่เคยดีใจที่คิดผิดขนาดนี้ ชนะ $opponent';
  }

  @override
  String yEatWords1(String opponent) {
    return 'ขอความถ่อมตัวสักจาน จานใหญ่ ชัยชนะเหนือ $opponent ยอดเยี่ยมมาก';
  }

  @override
  String yEatWords2(String opponent) {
    return 'ผมเคยบอกว่าพวกเขาหมดแล้ว แต่ยังเหลืออีกเยอะ เล่นดีมากกับ $opponent ทุกคน';
  }

  @override
  String yEatWords3(String opponent) {
    return 'ขอบันทึกไว้ ผมไม่ได้คาดว่าจะชนะ $opponent ต้องให้เครดิต';
  }

  @override
  String yEatWords4(String opponent) {
    return 'ก็ได้ ผมบอกว่าพวกเขาจะโดนจับได้ แต่ $opponent ทำไม่ได้';
  }

  @override
  String yEatWords5(String opponent) {
    return 'คืนนี้ผมขอกลืนคำพูดเรื่องทีมนี้ ชัยชนะเหนือ $opponent สมควรได้รับ';
  }

  @override
  String yEatWords6(String opponent) {
    return 'ใช่ ผมบอกว่าพวกเขาจบแล้ว ชนะ $opponent นัดเดียวยังไม่ได้พิสูจน์ว่าผมผิด';
  }

  @override
  String yEatWords7(String opponent) {
    return 'เขาบอกให้ผมกลืนคำพูดหลังเกมกับ $opponent ก็จะกลืน ช้าๆ แล้วเก็บใบเสร็จไว้';
  }

  @override
  String yEatWords8(String opponent) {
    return 'ชัยชนะเหนือ $opponent น่าประทับใจ แต่ความสงสัยของผมต่อทีมนี้ยังอยู่';
  }

  @override
  String yAwayFansWin0(String nation, String score) {
    return 'ยกนิ้วให้ $nation $score สมควรชนะตั้งแต่ต้นจนจบ';
  }

  @override
  String yAwayFansWin1(String nation, String score) {
    return 'พูดแล้วเจ็บ แต่คืนนี้ $nation ดีกว่า $score ยินดีด้วย';
  }

  @override
  String yAwayFansWin2(String nation, String score) {
    return '$score ขอคารวะ $nation พวกเขาอยากได้มากกว่า';
  }

  @override
  String yAwayFansWin3(String nation, String score) {
    return 'แพ้ $nation $score ไม่รู้จะพูดอะไรเลย';
  }

  @override
  String yAwayFansWin4(String nation, String score) {
    return '$nation $score ทีมเราควรอาย';
  }

  @override
  String yAwayFansWin5(String nation, String score) {
    return '$score กับ $nation ใครก็ได้อธิบายทีว่ามันเกิดขึ้นได้ยังไง';
  }

  @override
  String yAwayFansWin6(String nation, String score) {
    return 'แพ้ $nation $score ผมจะไม่มีวันลืมเรื่องนี้';
  }

  @override
  String yAwayFansWin7(String nation, String score) {
    return '$score กับ $nation ดวง ดวงล้วนๆ';
  }

  @override
  String yAwayFansWin8(String nation, String score) {
    return 'หลัง $score นี้ แฟนบอล $nation จะน่ารำคาญไปอีกหลายปี ขอบคุณที่ไม่ได้อะไรเลย';
  }

  @override
  String yNeutralWin0(String nation, String opponent, String score) {
    return '$nation $score $opponent ยอดเยี่ยมสำหรับฟุตบอล นี่แหละเหตุผลที่เรารักมัน';
  }

  @override
  String yNeutralWin1(String nation, String opponent, String score) {
    return 'ผลการแข่งขันที่สุดยอดของ $nation: $score กับ $opponent ฟุตบอลที่ดีที่สุด';
  }

  @override
  String yNeutralWin2(String nation, String opponent, String score) {
    return 'คนดูกลางๆ ทุกคนเชียร์ $nation คืนนี้ $score กับ $opponent!';
  }

  @override
  String yNeutralWin3(String nation, String opponent, String score) {
    return 'ผลการแข่งขันประจำนัด: $nation $score $opponent';
  }

  @override
  String yNeutralWin4(String nation, String opponent, String score) {
    return '$nation $score $opponent ไม่มีใครทายถูก';
  }

  @override
  String yNeutralWin5(String nation, String opponent, String score) {
    return 'ผลใหญ่: $nation $score $opponent อันดับโลกขยับแน่';
  }

  @override
  String yNeutralWin6(String nation, String opponent, String score) {
    return '$nation $score $opponent สนุกดี มาดูว่าจะทำได้อีกไหม';
  }

  @override
  String yNeutralWin7(String nation, String opponent, String score) {
    return '$nation $score $opponent $nation ชนะ หรือ $opponent แพ้เอง';
  }

  @override
  String yNeutralWin8(String nation, String opponent, String score) {
    return 'ช็อก: $nation $score $opponent เตรียมรับปฏิกิริยาเกินเหตุเพียบ';
  }

  @override
  String yScorerHero0(String name, String opponent) {
    return '$name ในเกมกับ $opponent เดี๋ยวคนจะตั้งชื่อลูกตามเขา';
  }

  @override
  String yScorerHero1(String name, String opponent) {
    return 'สร้างรูปปั้นให้ $name คืนนี้กับ $opponent เขาคือทุกอย่าง';
  }

  @override
  String yScorerHero2(String name, String opponent) {
    return '$name สุดยอด จำคืนนี้กับ $opponent ไว้';
  }

  @override
  String yScorerHero3(String name, String opponent) {
    return '$name ตัดสินเกมกับ $opponent ผู้เล่นยอดเยี่ยม ไม่ต้องเถียง';
  }

  @override
  String yScorerHero4(String name, String opponent) {
    return 'เกมกับ $opponent คืนนี้เป็นของ $name';
  }

  @override
  String yScorerHero5(String name, String opponent) {
    return '$name โผล่มาตอนที่ต้องการในเกมกับ $opponent';
  }

  @override
  String yScorerHero6(String name, String opponent) {
    return '$name ยอดเยี่ยมในเกมกับ $opponent ขอแบบนี้ทุกสัปดาห์';
  }

  @override
  String yScorerHero7(String name, String opponent) {
    return '$name ช่วยทีมไว้ในเกมกับ $opponent คนอื่นช่วยไม่ค่อยได้';
  }

  @override
  String yScorerHero8(String name, String opponent) {
    return 'ถ้าไม่มี $name เกมกับ $opponent คงเป็นอีกคืนที่ต่างไปเลย';
  }

  @override
  String yLostShock0(String opponent, String score) {
    return '$score กับ $opponent อุบัติเหตุ เกิดขึ้นได้กับทุกคนสักครั้ง';
  }

  @override
  String yLostShock1(String opponent, String score) {
    return 'แพ้ $opponent $score สลัดทิ้งไป แคมเปญยังไม่จบ';
  }

  @override
  String yLostShock2(String opponent, String score) {
    return '$opponent $score เจ็บ แต่ผลเดียวไม่ได้กำหนดว่าทีมนี้เป็นอย่างไร';
  }

  @override
  String yLostShock3(String opponent, String score) {
    return '$score กับ $opponent วันแย่ๆ ที่ทำงาน ไปต่อ';
  }

  @override
  String yLostShock4(String opponent, String score) {
    return 'แพ้ $opponent $score ไม่มีใครคาดคิด';
  }

  @override
  String yLostShock5(String opponent, String score) {
    return '$opponent $score หนึ่งในคืนที่ไม่มีเหตุผลอะไรเลย';
  }

  @override
  String yLostShock6(String opponent, String score) {
    return '$score กับ $opponent ความพ่ายแพ้ที่จะถูกจดจำ';
  }

  @override
  String yLostShock7(String opponent, String score) {
    return 'พ่ายต่อ $opponent $score เซอร์ไพรส์ไม่ว่าจะมองมุมไหน';
  }

  @override
  String yLostShock8(String opponent, String score) {
    return '$score กับ $opponent แพ้ทีมแบบนี้! รับไม่ได้';
  }

  @override
  String yLostShock9(String opponent, String score) {
    return 'แพ้ $opponent $score อยากได้คำอธิบาย ไม่ใช่ข้ออ้าง';
  }

  @override
  String yLostShock10(String opponent, String score) {
    return '$opponent $score ความอับอายของชาติ และไม่ได้พูดเกินจริง';
  }

  @override
  String yLostShock11(String opponent, String score) {
    return '$score กับ $opponent คนข้างบนยังนั่งเก้าอี้อยู่ได้ยังไง';
  }

  @override
  String yLostRout0(String opponent, String score) {
    return '$score กับ $opponent พวกเขาคือทีมระดับท็อป เรียนรู้จากมัน';
  }

  @override
  String yLostRout1(String opponent, String score) {
    return 'โดน $opponent เหนือกว่าทุกด้าน $score ไม่น่าอายที่แพ้ทีมที่ดีที่สุด';
  }

  @override
  String yLostRout2(String opponent, String score) {
    return '$opponent $score บทเรียน และบทเรียนทำให้เราเติบโต';
  }

  @override
  String yLostRout3(String opponent, String score) {
    return '$score กับ $opponent เจ็บ แต่พวกเขาอยู่เหนือกว่าหนึ่งขั้น';
  }

  @override
  String yLostRout4(String opponent, String score) {
    return '$opponent ชนะ $score ช่องว่างมีอยู่จริง และตอนนี้ทุกคนเห็นแล้ว';
  }

  @override
  String yLostRout5(String opponent, String score) {
    return '$score กับ $opponent โดนถล่ม แค่นั้นเลย';
  }

  @override
  String yLostRout6(String opponent, String score) {
    return '$opponent $score ทีมที่ดีกว่า และสกอร์ก็บอกอย่างนั้น';
  }

  @override
  String yLostRout7(String opponent, String score) {
    return 'แพ้ $opponent $score ไม่น่าอาย แต่ก็ไม่ใช่การแข่งขัน';
  }

  @override
  String yLostRout8(String opponent, String score) {
    return '$score กับ $opponent คู่แข่งดีกว่าหรือไม่ ก็ไม่ควรแพ้แบบนี้';
  }

  @override
  String yLostRout9(String opponent, String score) {
    return '$opponent $score เราพยายามสู้บ้างหรือเปล่า';
  }

  @override
  String yLostRout10(String opponent, String score) {
    return '$score กับ $opponent เหมือนลูกแกะเข้าโรงเชือด';
  }

  @override
  String yLostRout11(String opponent, String score) {
    return 'แพ้ $opponent $score และไม่มีใครดูเดือดร้อนเลย';
  }

  @override
  String yLostShootout0(String opponent) {
    return 'ตกรอบจากการดวลจุดโทษกับ $opponent ทุ่มสุดตัวแล้ว ภูมิใจในพวกเขา';
  }

  @override
  String yLostShootout1(String opponent) {
    return 'ดวลจุดโทษกับ $opponent วิธีตกรอบที่โหดร้ายที่สุด เงยหน้าขึ้น';
  }

  @override
  String yLostShootout2(String opponent) {
    return 'แพ้การดวลจุดโทษกับ $opponent ไม่มีใครสมควรเจอแบบนี้';
  }

  @override
  String yLostShootout3(String opponent) {
    return 'ตกรอบจากจุดโทษกับ $opponent จุดโทษเป็นตัวตัดสิน';
  }

  @override
  String yLostShootout4(String opponent) {
    return '$opponent ผ่านเข้ารอบด้วยจุดโทษ ทัวร์นาเมนต์ของเราจบตรงนี้';
  }

  @override
  String yLostShootout5(String opponent) {
    return 'แพ้จุดโทษ $opponent จุดโทษอีกแล้ว';
  }

  @override
  String yLostShootout6(String opponent) {
    return 'ตกรอบจากจุดโทษกับ $opponent เราเคยซ้อมบ้างไหม';
  }

  @override
  String yLostShootout7(String opponent) {
    return 'แพ้ $opponent ด้วยจุดโทษ ควรจบเกมให้ได้ก่อนหน้านั้นนานแล้ว';
  }

  @override
  String yLostShootout8(String opponent) {
    return 'ดวลจุดโทษกับ $opponent แล้วก็แพ้ แน่นอนอยู่แล้ว';
  }

  @override
  String yKnockoutLoss0(String opponent, String score) {
    return 'ตกรอบ $score กับ $opponent เส้นทางที่น่าภูมิใจจบลงตรงนี้';
  }

  @override
  String yKnockoutLoss1(String opponent, String score) {
    return 'ตกรอบโดย $opponent $score ขอบคุณสำหรับความทรงจำ';
  }

  @override
  String yKnockoutLoss2(String opponent, String score) {
    return '$score กับ $opponent การเดินทางจบแล้ว แต่เป็นการเดินทางที่ยอดเยี่ยม';
  }

  @override
  String yKnockoutLoss3(String opponent, String score) {
    return 'ตกรอบ: $score กับ $opponent เงยหน้าขึ้น';
  }

  @override
  String yKnockoutLoss4(String opponent, String score) {
    return 'จบแล้ว: $score กับ $opponent';
  }

  @override
  String yKnockoutLoss5(String opponent, String score) {
    return 'ตกรอบ: $score กับ $opponent';
  }

  @override
  String yKnockoutLoss6(String opponent, String score) {
    return '$opponent ผ่านเข้ารอบ $score ทัวร์นาเมนต์ของเราจบแล้ว';
  }

  @override
  String yKnockoutLoss7(String opponent, String score) {
    return 'ตกรอบโดย $opponent $score การชันสูตรเริ่มขึ้นแล้ว';
  }

  @override
  String yKnockoutLoss8(String opponent, String score) {
    return 'ตกรอบ $score กับ $opponent ทัวร์นาเมนต์ใหม่ ตอนจบเดิม';
  }

  @override
  String yKnockoutLoss9(String opponent, String score) {
    return '$score กับ $opponent แล้วก็กลับบ้าน ไม่มีใครแปลกใจ';
  }

  @override
  String yKnockoutLoss10(String opponent, String score) {
    return 'ตกรอบโดย $opponent $score รอฟังข้ออ้างก่อนเช้าได้เลย';
  }

  @override
  String yKnockoutLoss11(String opponent, String score) {
    return '$opponent $score ตกรอบ และไม่เคยดูเหมือนจะจบแบบอื่นเลย';
  }

  @override
  String yAwayFansGloat0(String nation, String score) {
    return '$score กับ $nation ให้เกียรติ พวกเขาจะกลับมาแข็งแกร่งกว่าเดิม';
  }

  @override
  String yAwayFansGloat1(String nation, String score) {
    return 'ชัยชนะที่ดีของเรา $score วันแย่ของ $nation เห็นใจแฟนบอลพวกเขา';
  }

  @override
  String yAwayFansGloat2(String nation, String score) {
    return '$score คืนแย่ของ $nation และเราฉวยโอกาสไว้ได้ ฟุตบอลก็เป็นแบบนี้';
  }

  @override
  String yAwayFansGloat3(String nation, String score) {
    return '$score กับ $nation! ใครจะไปคิด พวกเขาไม่คิดแน่';
  }

  @override
  String yAwayFansGloat4(String nation, String score) {
    return 'ชนะ $nation $score ใครก็ได้ไปดูแฟนบอลพวกเขาหน่อย';
  }

  @override
  String yAwayFansGloat5(String nation, String score) {
    return '$nation $score อันนี้เก็บเข้าอัลบั้ม';
  }

  @override
  String yAwayFansGloat6(String nation, String score) {
    return '$score กับ $nation แล้วยังคิดว่าตัวเองเป็นทีมใหญ่';
  }

  @override
  String yAwayFansGloat7(String nation, String score) {
    return 'ลองนึกภาพแพ้เรา $score ดูสิ ถาม $nation ได้ ตอนนี้พวกเขารู้แล้ว';
  }

  @override
  String yAwayFansGloat8(String nation, String score) {
    return '$nation $score บินกลับบ้านปลอดภัยนะ';
  }

  @override
  String yNeutralLoss0(String nation, String opponent, String score) {
    return '$nation $score $opponent คืนใหญ่ของ $opponent คืนหนักของ $nation';
  }

  @override
  String yNeutralLoss1(String nation, String opponent, String score) {
    return 'เป็นกำลังใจให้แฟนบอล $nation หลัง $score กับ $opponent พวกเขาจะลุกขึ้นได้';
  }

  @override
  String yNeutralLoss2(String nation, String opponent, String score) {
    return '$nation $score $opponent ทีมใหญ่ทุกทีมมีคืนแบบนี้';
  }

  @override
  String yNeutralLoss3(String nation, String opponent, String score) {
    return 'ช็อกประจำนัด: $nation $score $opponent';
  }

  @override
  String yNeutralLoss4(String nation, String opponent, String score) {
    return '$nation $score $opponent ไม่มีใครคาดคิด';
  }

  @override
  String yNeutralLoss5(String nation, String opponent, String score) {
    return 'ผลประจำวัน: $nation $score $opponent ตอนนี้ $nation มีคำถามต้องตอบ';
  }

  @override
  String yNeutralLoss6(String nation, String opponent, String score) {
    return '$nation $score $opponent ไม่ใช่เรื่องบังเอิญ ถ้าคุณติดตามมาตลอด';
  }

  @override
  String yNeutralLoss7(String nation, String opponent, String score) {
    return '$nation $score $opponent ใครบางคนที่นั่นต้องอธิบายอีกเยอะ';
  }

  @override
  String yNeutralLoss8(String nation, String opponent, String score) {
    return '$nation $score $opponent ชื่อใหญ่ ฟอร์มเล็ก';
  }

  @override
  String yDownGap0(String opponent, String gap) {
    return '$opponent: ต่ำกว่าเรา $gap อันดับ เกิดขึ้นได้ ไปต่อ';
  }

  @override
  String yDownGap1(String gap) {
    return 'อันดับต่างกัน: เราเหนือกว่า $gap ฟุตบอลไม่อ่านอันดับ';
  }

  @override
  String yDownGap2(String opponent, String gap) {
    return 'บนกระดาษเราห่างจาก $opponent $gap อันดับ แต่ไม่ใช่ในสนามคืนนี้';
  }

  @override
  String yDownGap3(String opponent, String gap) {
    return 'อันดับต่างกันก่อนเตะ: เราเหนือกว่า $gap แต่ก็แพ้ $opponent';
  }

  @override
  String yDownGap4(String opponent, String gap) {
    return 'ในอันดับโลก $opponent ต่ำกว่าเรา $gap อันดับ ผล: แพ้';
  }

  @override
  String yDownGap5(String opponent, String gap) {
    return 'ดัชนีเซอร์ไพรส์: $gap อันดับ ในทิศทางที่ผิด กับ $opponent';
  }

  @override
  String yDownGap6(String opponent, String gap) {
    return 'เหนือกว่า $opponent $gap อันดับ แพ้ อธิบายมาที';
  }

  @override
  String yDownGap7(String gap) {
    return 'แพ้ทีมที่ต่ำกว่าเรา $gap อันดับ ลองคิดถึงตัวเลขนี้ดู';
  }

  @override
  String yDownGap8(String opponent, String gap) {
    return 'อันดับต่างกัน: $gap แพ้ $opponent ใครบางคนควรเริ่มนับวันได้แล้ว';
  }

  @override
  String yDrewHeroic0(String opponent, String score) {
    return '$score กับ $opponent! เสมอที่รู้สึกเหมือนชนะ';
  }

  @override
  String yDrewHeroic1(String opponent, String score) {
    return '$score กับ $opponent ภูมิใจในทุกคน';
  }

  @override
  String yDrewHeroic2(String opponent, String score) {
    return '$opponent $score พวกเขาเป็นตัวเต็ง และเราสู้ได้สูสี';
  }

  @override
  String yDrewHeroic3(String opponent, String score) {
    return '$score กับ $opponent แต้มที่ได้มาด้วยเลือดและเหงื่อ';
  }

  @override
  String yDrewHeroic4(String opponent, String score) {
    return '$score กับ $opponent แต้มที่มีค่ามาก';
  }

  @override
  String yDrewHeroic5(String opponent, String score) {
    return 'เสมอ $opponent $score แทบไม่มีใครคาดหวังอะไร';
  }

  @override
  String yDrewHeroic6(String opponent, String score) {
    return 'หยุด $opponent ได้ $score ผลที่ต่อยอดได้';
  }

  @override
  String yDrewHeroic7(String opponent, String score) {
    return '$score กับ $opponent แต้มที่ไม่มีใครให้เรา';
  }

  @override
  String yDrewHeroic8(String opponent, String score) {
    return '$score กับ $opponent แต้มดี แต่เสมอแล้วไม่ได้แชมป์';
  }

  @override
  String yDrewHeroic9(String opponent, String score) {
    return '$score กับ $opponent ดีนะ แต่เราก็ไม่มีการยิงดีๆ สักลูก';
  }

  @override
  String yDrewHeroic10(String opponent, String score) {
    return '$opponent $score แต้มเดียว แต่ทุกคนทำเหมือนเราได้ถ้วย';
  }

  @override
  String yDrewHeroic11(String opponent, String score) {
    return '$score กับ $opponent จอดรถบัสหน้าประตูแล้วก็โชคดี';
  }

  @override
  String yDrewShame0(String opponent, String score) {
    return '$score กับ $opponent หงุดหงิด แต่ยังไม่แพ้';
  }

  @override
  String yDrewShame1(String opponent, String score) {
    return 'แค่ $score กับ $opponent วันที่ไม่ดี เกิดขึ้นได้';
  }

  @override
  String yDrewShame2(String opponent, String score) {
    return '$opponent $score ยังไม่ดีพอ และนักเตะก็รู้';
  }

  @override
  String yDrewShame3(String opponent, String score) {
    return '$score กับ $opponent เสียสองแต้ม ไม่มีอะไรมากกว่านั้น';
  }

  @override
  String yDrewShame4(String opponent, String score) {
    return '$score กับ $opponent ทิ้งสองแต้ม';
  }

  @override
  String yDrewShame5(String opponent, String score) {
    return 'แค่ $score กับ $opponent ผลที่แย่ จะห่อยังไงก็แย่';
  }

  @override
  String yDrewShame6(String opponent, String score) {
    return '$opponent $score เสมอที่รู้สึกเหมือนแพ้';
  }

  @override
  String yDrewShame7(String opponent, String score) {
    return '$score กับ $opponent เกมแบบนี้ต้องชนะแบบสบายๆ';
  }

  @override
  String yDrewShame8(String opponent, String score) {
    return '$score กับ $opponent น่าอาย';
  }

  @override
  String yDrewShame9(String opponent, String score) {
    return 'แค่เสมอ $opponent $score ใครต้องรับผิดชอบ';
  }

  @override
  String yDrewShame10(String opponent, String score) {
    return '$opponent $score ถ้าชนะทีมนี้ไม่ได้ แล้วจะชนะใคร';
  }

  @override
  String yDrewShame11(String opponent, String score) {
    return '$score กับ $opponent แฟนบอลพวกเขาฉลองที่เสมอเรา ลองคิดดู';
  }

  @override
  String yTrophy0(String opponent) {
    return 'แชมป์ $opponent ตะโกนออกมาดังๆ';
  }

  @override
  String yTrophy1(String opponent) {
    return 'เราได้แชมป์ $opponent ผมไม่ไหวแล้ว';
  }

  @override
  String yTrophy2(String opponent) {
    return '$opponent และถ้วยกำลังกลับบ้าน';
  }

  @override
  String yTrophy3(String opponent) {
    return 'ทุกคนคือตำนาน $opponent';
  }

  @override
  String yRunnerUp0(String opponent) {
    return 'เกือบแล้ว $opponent กับเหรียญที่ไม่มีใครอยากได้';
  }

  @override
  String yRunnerUp1(String opponent) {
    return 'รองแชมป์ $opponent จะเจ็บไปอีกหลายปี';
  }

  @override
  String yRunnerUp2(String opponent) {
    return '$opponent: ห่างจากทุกสิ่งแค่เกมเดียว';
  }

  @override
  String yRunnerUp3(String opponent) {
    return 'ที่สอง ใน $opponent ใครก็ได้ส่งขวดมาที';
  }

  @override
  String yEliminated0(String opponent) {
    return 'ตกรอบ $opponent อันนี้จะเจ็บไปอีกนาน';
  }

  @override
  String yEliminated1(String opponent) {
    return '$opponent คือจุดสิ้นสุดของเรา';
  }

  @override
  String yEliminated2(String opponent) {
    return 'ตกรอบ $opponent ทีนี้ก็ถึงเวลาสอบสวน';
  }

  @override
  String yEliminated3(String opponent) {
    return 'ตกรอบ $opponent ใครก็ได้อธิบายให้ฟังที';
  }

  @override
  String yQualified0(String opponent) {
    return 'เรากำลังไป $opponent';
  }

  @override
  String yQualified1(String opponent) {
    return 'ผ่านเข้ารอบ $opponent แล้ว ลางานรอไว้ได้เลย';
  }

  @override
  String yQualified2(String opponent) {
    return '$opponent เรามาแล้ว ไม่เคยมีข้อสงสัย (สงสัยสุดๆ)';
  }

  @override
  String yQualified3(String opponent) {
    return 'ผ่านเข้าสู่ $opponent ส่วนที่ยากที่สุดผ่านไปแล้ว';
  }

  @override
  String yGroupDrawn0(String opponent) {
    return 'จับสลากแบ่งกลุ่ม $opponent แล้ว อาจแย่กว่านี้ แย่กว่านี้ได้อีกเยอะ';
  }

  @override
  String yGroupDrawn1(String opponent) {
    return 'นี่คือผลจับสลาก $opponent น่าสนใจ';
  }

  @override
  String yGroupDrawn2(String opponent) {
    return 'กลุ่มของ $opponent ออกมาแล้ว และผมไม่ชอบกลุ่มเราเลย';
  }

  @override
  String yGroupDrawn3(String opponent) {
    return 'จับสลาก $opponent เสร็จแล้ว เริ่มตื่นตูมกันได้';
  }

  @override
  String yHostNamed0(String opponent) {
    return '$opponent จะเป็นเจ้าภาพ เริ่มเก็บเงินได้';
  }

  @override
  String yHostNamed1(String opponent) {
    return 'ได้แก่ $opponent คาดเดาได้ แต่ก็โอเค';
  }

  @override
  String yHostNamed2(String opponent) {
    return '$opponent ได้จัดทัวร์นาเมนต์ ก็ยินดีด้วยละกัน';
  }

  @override
  String yHostNamed3(String opponent) {
    return 'ยืนยันเจ้าภาพ: $opponent';
  }

  @override
  String yTournamentSoon0(String opponent) {
    return '$opponent ใกล้เริ่มแล้ว นั่งไม่ติดเลย';
  }

  @override
  String yTournamentSoon1(String opponent) {
    return 'อีกไม่นานก็ถึง $opponent';
  }

  @override
  String yTournamentSoon2(String opponent) {
    return '$opponent ใกล้มาถึงแล้ว ประกาศรายชื่อทีมได้แล้ว';
  }

  @override
  String yTournamentSoon3(String opponent) {
    return 'การนับถอยหลังสู่ $opponent ทรมานอย่างเป็นทางการ';
  }

  @override
  String get navY => 'Y';

  @override
  String get yTitle => 'Y';

  @override
  String get yEmpty => 'ยังไม่มีอะไรจะพูด ไปลงเล่นสักนัด';

  @override
  String get yEarlierHeading => 'ก่อนหน้านี้ในรอบนี้';

  @override
  String get yTraitLoyalist =>
      'เชียร์ทีมไม่ว่าจะเกิดอะไรขึ้น เปลี่ยนใจช้า ให้อภัยเร็ว';

  @override
  String get yTraitCynic => 'คิดในแง่ร้ายไว้ก่อน และดีใจมากเมื่อคิดถูก';

  @override
  String get yTraitNostalgic =>
      'ทุกอย่างเมื่อก่อนดีกว่า เอาคุณไปเทียบกับคนที่เลิกเล่นไปแล้ว';

  @override
  String get yTraitStatshead => 'โพสต์แต่ตัวเลข ไม่มีอย่างอื่น แทบไม่มีอารมณ์';

  @override
  String get yTraitHypeman => 'ผลดีสองนัดก็กลายเป็นยุคทองแล้ว';

  @override
  String get yTraitContrarian => 'คนส่วนใหญ่คิดอย่างไร ก็คิดตรงข้าม';

  @override
  String get yTraitDoomer => 'มันจะพัง มันจะพังเสมอ';

  @override
  String get yProfilePosts => 'โพสต์';

  @override
  String get yProfileEmpty => 'บัญชีนี้ยังไม่ได้โพสต์อะไร';

  @override
  String hubEventGrievance(String player) {
    return '$player ขอคุยด้วย';
  }

  @override
  String get hubEventGrievanceSub => 'เขาอยากรู้ว่าตัวเองอยู่ตรงไหน';

  @override
  String hubEventManagerSkills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'มีแต้มทักษะ $count แต้มให้ใช้',
      one: 'มีแต้มทักษะ 1 แต้มให้ใช้',
    );
    return '$_temp0';
  }

  @override
  String get hubEventManagerSkillsSub => 'สิ่งที่คุณถนัดทำให้ทีมของคุณดีขึ้น';

  @override
  String get grievanceTitle => 'ขอคุยในห้องทำงาน';

  @override
  String grievanceGameTime(String player) {
    return '$player ติดทีมชุดแต่ยังไม่ได้แตะบอลเลย เขาอยากรู้ว่าทำไม';
  }

  @override
  String grievanceSquadPlace(String player) {
    return '$player ไม่ติดทีมชุดและไม่เข้าใจว่าทำไม เขาต้องการคำตอบชัดๆ ไม่ทางใดก็ทางหนึ่ง';
  }

  @override
  String grievanceRole(String player) {
    return '$player ถูกจับเล่นผิดตำแหน่งซ้ำแล้วซ้ำเล่า และเขาทนไม่ไหวแล้ว';
  }

  @override
  String get grievanceReassure => 'คุณอยู่ในแผนของผม';

  @override
  String get grievanceHonest => 'คุณเป็นรองคนอื่น และนี่คือเหตุผล';

  @override
  String get grievanceDismiss => 'ผมเป็นคนเลือกทีม';

  @override
  String yScorerStar0(String name, String goals) {
    return '$name ยิงไป $goals ลูก ไม่มีใครใกล้เคียง';
  }

  @override
  String yScorerStar1(String name, String goals) {
    return '$goals ลูกของ $name เขาแบกทีมนี้ไว้ทั้งทีม';
  }

  @override
  String yScorerStar2(String name, String goals) {
    return '$name: $goals ลูกในวันนี้ นักเตะของจริง';
  }

  @override
  String yScorerStar3(String name, String goals) {
    return 'ยิงใส่ไป $goals ลูก $name โค้งรับได้เลย';
  }

  @override
  String yScorerStar4(String name, String goals) {
    return '$goals ลูกของ $name ส่วนที่เหลือก็แค่ผู้โดยสาร';
  }

  @override
  String yScorerStar5(String name, String goals) {
    return '$name อีกแล้ว $goals ลูก ลองนึกภาพทีมนี้ไม่มีเขาดู';
  }

  @override
  String yScorerStar6(String name, String goals) {
    return '$goals ลูกจาก $name คนคนเดียวไม่ควรต้องทำขนาดนี้';
  }

  @override
  String yScorerStar7(String name, String goals) {
    return 'เอา $name ออกไป ก็ขาดไป $goals ลูก และเป็นบ่ายที่ต่างไปมาก';
  }

  @override
  String yWinStreak0(String count) {
    return 'ชนะรวด $count นัด ไม่ว่าในห้องแต่งตัวพูดอะไรกัน มันได้ผล';
  }

  @override
  String yWinStreak1(String count) {
    return 'นั่นคือ $count นัดติด ทีมไม่ได้บังเอิญชนะรวดแบบนี้';
  }

  @override
  String yWinStreak2(String count) {
    return 'ชนะ $count นัดติดและยังนับต่อ ความมั่นใจมองเห็นได้จากอัฒจันทร์';
  }

  @override
  String yWinStreak3(String count) {
    return 'ไม่แพ้ $count นัด ถามใครที่เคยคุมทีมก็ได้ นั่นคือส่วนที่ยาก';
  }

  @override
  String yWinStreak4(String count) {
    return 'ชนะ $count นัดติด สนุกไปก่อนตอนที่โปรแกรมยังใจดี';
  }

  @override
  String yWinStreak5(String count) {
    return 'ชนะ $count นัดติด และยังไม่ได้ชนะใครที่มีน้ำหนักเลย';
  }

  @override
  String yWinStreak6(String count) {
    return 'ชนะรวด $count นัด ถามใหม่ตอนที่ได้เจอบททดสอบจริง';
  }

  @override
  String yWinStreak7(String count) {
    return 'ชนะติดกัน $count นัด ทุกทีมมีช่วงแบบนี้สักครั้ง';
  }

  @override
  String yLossStreak0(String count) {
    return 'ไม่ชนะมา $count นัดแล้ว ถึงจุดหนึ่งข้ออ้างก็หมด';
  }

  @override
  String yLossStreak1(String count) {
    return 'นั่นคือพังติดกัน $count นัด นี่ไม่ใช่แค่สะดุดแล้ว';
  }

  @override
  String yLossStreak2(String count) {
    return 'แพ้รวด $count นัด ต้องมีใครรับผิดชอบ';
  }

  @override
  String yLossStreak3(String count) {
    return 'ไม่ชนะ $count นัด ดูได้จากวิธีที่พวกเขาเล่น';
  }

  @override
  String yLossStreak4(String count) {
    return 'ไม่ชนะ $count นัด และพลาดซ้ำเดิมทุกสัปดาห์';
  }

  @override
  String yLossStreak5(String count) {
    return '$count นัดติด อะไรที่ลองอยู่ มันไม่ได้ผล';
  }

  @override
  String yLossStreak6(String count) {
    return '$count นัดติด นี่คือทิศทาง ไม่ใช่แค่ช่วงขาลง';
  }

  @override
  String yLossStreak7(String count) {
    return 'ไม่ชนะ $count นัด และไม่มีใครข้างบนพูดอะไรสักคำ';
  }

  @override
  String yRivalry0(String opponent, String score) {
    return '$opponent $score จะว่าเรื่องเกมยังไงก็ได้ แต่นัดนี้นับสองเท่า';
  }

  @override
  String yRivalry1(String opponent, String score) {
    return 'เจอ $opponent ทั้งที $score ไม่มีใครที่นี่จะลืม';
  }

  @override
  String yRivalry2(String opponent, String score) {
    return '$score กับ $opponent นัดนี้แหละที่จะถูกพูดถึงในวงเหล้า';
  }

  @override
  String yRivalry3(String opponent, String score) {
    return 'ศึกเพื่อนบ้าน $score สิทธิ์คุยโวถูกตัดสินไปอีกพักใหญ่';
  }

  @override
  String yRivalry4(String opponent, String score) {
    return '$opponent $score ปีนี้จะเกิดอะไรขึ้นก็ตาม อย่างน้อยก็มีนัดนี้';
  }

  @override
  String yRivalry5(String opponent, String score) {
    return '$score กับ $opponent พวกเราบางคนต้องการมันมากกว่าตารางคะแนนเสียอีก';
  }

  @override
  String yRivalry6(String opponent, String score) {
    return '$opponent $score และครั้งหน้าพวกเขาจะเอาคืน เป็นแบบนี้ทุกที';
  }

  @override
  String yRivalry7(String opponent, String score) {
    return 'เจอ $opponent $score โดนตอกย้ำเรื่องนี้ไปอีกทั้งปี';
  }

  @override
  String yInjuryBlow0(String name) {
    return '$name เจ็บออกจากสนาม นี่คือสิ่งสุดท้ายที่ทีมนี้ต้องการ';
  }

  @override
  String yInjuryBlow1(String name) {
    return 'การเสีย $name เปลี่ยนรูปทรงของทุกอย่าง';
  }

  @override
  String yInjuryBlow2(String name) {
    return '$name เดินกะเผลก กลั้นหายใจไว้';
  }

  @override
  String yInjuryBlow3(String name) {
    return 'ไม่มี $name ไปสักพัก ต้องมีใครก้าวขึ้นมา';
  }

  @override
  String yInjuryBlow4(String name) {
    return '$name เจ็บ แน่นอนว่าต้องเป็น $name';
  }

  @override
  String yInjuryBlow5(String name) {
    return 'ไม่มี $name ทีมนี้ก็กลายเป็นทีมธรรมดามาก';
  }

  @override
  String yInjuryBlow6(String name) {
    return '$name เจ็บอีกแล้ว ควรมีใครถามว่าทำไม';
  }

  @override
  String yInjuryBlow7(String name) {
    return 'เสีย $name และไม่มีใครเป็นตัวสำรองต่อจากเขา นั่นคือปัญหาที่แท้จริง';
  }

  @override
  String ySentOff0(String name, String minute) {
    return 'ใบแดงให้ $name นาทีที่ $minute แล้วทั้งประเทศก็หันไปรุมเขา เขาให้อะไรเรามามากกว่าใคร ปล่อยเขาไปเถอะ';
  }

  @override
  String ySentOff1(String name, String minute) {
    return '$name โดนไล่ออกนาทีที่ $minute โหดไป เหลือสิบคนเรายังสู้ บอกอะไรได้หลายอย่าง';
  }

  @override
  String ySentOff2(String name, String minute) {
    return '$name นาทีที่ $minute ใบแดง เหลือสิบคนนับจากนั้น';
  }

  @override
  String ySentOff3(String name, String minute) {
    return 'ไล่ออก: $name นาทีที่ $minute ไม่ใช่เกมแรกที่พลิกเพราะการตัดสินครั้งเดียว';
  }

  @override
  String ySentOff4(String name, String minute) {
    return 'เยี่ยมเลย $name โดนไล่ออกนาทีที่ $minute เราเหลือสิบคน อีกแล้ว';
  }

  @override
  String ySentOff5(String name, String minute) {
    return '$name โดนไล่ออกหลังผ่านไป $minute นาที ใครกันแน่ที่ดูแลเรื่องวินัยที่นี่?';
  }

  @override
  String ySentOff6(String name, String minute) {
    return '$minute นาที นั่นคือเวลาที่ $name คุมสติไว้ได้ ฟุตบอลอาชีพ';
  }

  @override
  String ySentOff7(String name, String minute) {
    return 'ใบแดงให้ $name นาทีที่ $minute แล้วผมต้องเชื่อว่านี่คือความก้าวหน้า';
  }

  @override
  String get yBoardPressure0 => 'บอร์ดเงียบผิดปกติ ไม่เคยเป็นสัญญาณที่ดี';

  @override
  String get yBoardPressure1 => 'ข่าวว่าในห้องประชุมบอร์ดเริ่มมีคำถามแล้ว';

  @override
  String get yBoardPressure2 => 'รู้สึกได้เลยว่าข้างบนเริ่มสั่นคลอน';

  @override
  String get yBoardPressure3 =>
      'ไม่มีใครในสมาคมพูดสนับสนุนเลย คิดเอาเองแล้วกัน';

  @override
  String get yBoardPressure4 =>
      'หลายสัปดาห์แล้วที่ไม่มีใครข้างบนออกมาหนุนเขาต่อหน้าสาธารณะ';

  @override
  String get yBoardPressure5 =>
      'สมาคมปล่อยข่าวโจมตีผู้จัดการทีมของตัวเอง เหมือนเดิมทุกที';

  @override
  String get yBoardPressure6 => 'เมื่อบอร์ดเงียบ แปลว่าพวกเขาตัดสินใจไปแล้ว';

  @override
  String get yBoardPressure7 =>
      'พวกเขาจะปล่อยให้ลอยไปเรื่อยๆ จนกลายเป็นการตัดสินใจของคนอื่น';

  @override
  String get yReplies => 'โพสต์อื่นเกี่ยวกับเกมนี้';

  @override
  String get yPlayerGrievance0 => 'ถามไปแล้วว่าตัวเองอยู่ตรงไหน ยังรอคำตอบอยู่';

  @override
  String get yPlayerGrievance1 => 'ซ้อมหนักต่อไป ทำอะไรได้มากกว่านี้ไม่ได้';

  @override
  String get yPlayerGrievance2 => 'บางคำถามถามได้แค่ครั้งเดียว';

  @override
  String get yPlayerGrievance3 => 'ผมไม่ได้มาไกลขนาดนี้เพื่อแบกเอี๊ยมซ้อม';

  @override
  String get playerHonoursTitle => 'เกียรติประวัติ';

  @override
  String get awardGoldenBall => 'ลูกบอลทองคำ';

  @override
  String get awardGoldenBoot => 'รองเท้าทองคำ';

  @override
  String get awardGoldenGlove => 'ถุงมือทองคำ';

  @override
  String get awardTeamOfTournament => 'ทีมยอดเยี่ยมทัวร์นาเมนต์';

  @override
  String get awardPlayerOfYear => 'นักเตะยอดเยี่ยมของโลกประจำปี';

  @override
  String get awardYoungPlayerOfYear => 'ดาวรุ่งยอดเยี่ยมประจำปี';

  @override
  String get playerClubHistory => 'ประวัติสโมสร';

  @override
  String get playerCareerRecord => 'สถิติอาชีพ';

  @override
  String get playerInternationalGoals => 'ประตูในนามทีมชาติ';

  @override
  String get playerRecentForm => 'ฟอร์มล่าสุด';

  @override
  String get playerMatchHistory => 'ประวัติการลงเล่น';

  @override
  String get playerAttributes => 'คุณสมบัติ';

  @override
  String get playerUnknown => 'ไม่ทราบ';

  @override
  String get playerAttrPace => 'ความเร็ว';

  @override
  String get playerAttrPhysical => 'ร่างกาย';

  @override
  String get playerAttrTechnical => 'เทคนิค';

  @override
  String get playerAttrShooting => 'การยิง';

  @override
  String get playerAttrPassing => 'การจ่ายบอล';

  @override
  String get playerAttrDribbling => 'การเลี้ยงบอล';

  @override
  String get playerAttrTackling => 'การเข้าปะทะ';

  @override
  String get playerAttrPositioning => 'การยืนตำแหน่ง';

  @override
  String get playerAttrComposure => 'ความนิ่ง';

  @override
  String get playerAttrDecisions => 'การตัดสินใจ';

  @override
  String get playerAttrStamina => 'ความอึด';

  @override
  String get playerAttrStrength => 'ความแข็งแกร่ง';

  @override
  String get playerStatCaps => 'ติดทีมชาติ';

  @override
  String get playerStatGoals => 'ประตู';

  @override
  String get playerStatAssists => 'แอสซิสต์';

  @override
  String get playerStatAvgRating => 'เรตติ้งเฉลี่ย';

  @override
  String get playerStatForm => 'ฟอร์ม';

  @override
  String get playerStatMotm => 'ผู้เล่นยอดเยี่ยม';

  @override
  String get playerStatCleanSheets => 'คลีนชีต';

  @override
  String get playerStatBestGame => 'เกมที่ดีที่สุด';

  @override
  String get playerStatCards => 'ใบเหลือง/แดง';

  @override
  String playerCardsValue(int yellows, int reds) {
    return 'เหลือง $yellows แดง $reds';
  }

  @override
  String get tourSharedYourRun => 'เส้นทางของคุณ';

  @override
  String get tourSharedList => 'รายการ';

  @override
  String get tourSharedBracket => 'สาย';

  @override
  String get tourSharedVs => 'พบ';

  @override
  String tourSharedGroupSeed(String seed) {
    return 'กลุ่ม $seed';
  }

  @override
  String get tourSharedThisEdition => 'ครั้งนี้';

  @override
  String get tourSharedAllTime => 'ตลอดกาล';

  @override
  String get tourSharedUnknown => 'ไม่ทราบ';

  @override
  String get tourSharedActive => 'ยังเล่นอยู่';

  @override
  String get tourSharedMedalTable => 'ตารางเหรียญ';

  @override
  String get tourSharedPastWinners => 'แชมป์ในอดีต';

  @override
  String tourSharedHost(String host) {
    return 'เจ้าภาพ: $host';
  }

  @override
  String get tourSharedBeat => 'ชนะ';

  @override
  String get tourSharedPens => ' (จุดโทษ)';

  @override
  String get tourSharedAwardsEmpty => 'รางวัลจะตัดสินเมื่อทัวร์นาเมนต์จบลง';

  @override
  String get tourSharedGoldenBall => 'ลูกบอลทองคำ';

  @override
  String get tourSharedPlayerOfTournament => 'ผู้เล่นยอดเยี่ยมของทัวร์นาเมนต์';

  @override
  String get tourSharedGoldenBoot => 'รองเท้าทองคำ';

  @override
  String tourSharedGoalsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ประตู',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedGoldenGlove => 'ถุงมือทองคำ';

  @override
  String get tourSharedTeamOfTournament => 'ทีมยอดเยี่ยมทัวร์นาเมนต์';

  @override
  String get tourSharedStatsEmpty => 'สถิติจะปรากฏเมื่อรายการนี้มีประวัติมากพอ';

  @override
  String get tourSharedRecordScorer => 'ดาวซัลโวสูงสุด';

  @override
  String get tourSharedStillActive => 'ยังเล่นอยู่';

  @override
  String get tourSharedMostTitles => 'แชมป์มากที่สุด';

  @override
  String tourSharedTitlesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'แชมป์ $count สมัย',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostFinals => 'เข้าชิงมากที่สุด';

  @override
  String tourSharedFinalsContested(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'เข้าชิง $count ครั้ง',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostGamesPlayed => 'ลงเล่นมากที่สุด';

  @override
  String tourSharedMatchesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count นัด',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostFinalsPlayed => 'เล่นรอบสุดท้ายมากที่สุด';

  @override
  String tourSharedFinalsTournamentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'รอบสุดท้าย $count ครั้ง',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedBiggestFinalWin => 'ชนะขาดที่สุดในนัดชิง';

  @override
  String tourStatsGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ประตู',
      one: '1 ประตู',
    );
    return '$_temp0';
  }

  @override
  String get tourStatsStillActive => 'ยังเล่นอยู่';

  @override
  String tourStatsTitles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'แชมป์ $count สมัย',
      one: 'แชมป์ 1 สมัย',
    );
    return '$_temp0';
  }

  @override
  String tourStatsFinalsContested(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'เข้าชิง $count ครั้ง',
      one: 'เข้าชิง 1 ครั้ง',
    );
    return '$_temp0';
  }

  @override
  String tourStatsMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count นัด',
      one: '1 นัด',
    );
    return '$_temp0';
  }

  @override
  String tourStatsFinalsTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'รอบสุดท้าย $count ครั้ง',
      one: 'รอบสุดท้าย 1 ครั้ง',
    );
    return '$_temp0';
  }

  @override
  String get tourStatsLeaders => 'ผู้นำตลอดกาล';

  @override
  String get tourStatsTabGames => 'นัด';

  @override
  String get tourStatsTabCups => 'รายการ';

  @override
  String get tourStatsTabScorers => 'ดาวซัลโว';

  @override
  String tourSharedFinalWinDetail(String opponent, int year) {
    return 'พบ $opponent · $year';
  }

  @override
  String get tourHolders => 'แชมป์เก่า';

  @override
  String tourHoldersSince(int year) {
    return 'ได้แชมป์ปี $year';
  }

  @override
  String get tourSharedAllTimeScorers => 'ดาวซัลโวตลอดกาล';

  @override
  String get tourSharedSummaryEmpty =>
      'เจ้าภาพและสนามแข่งจะปรากฏเมื่อจับสลากครั้งนี้แล้ว';

  @override
  String get tourSharedHostHeading => 'เจ้าภาพ';

  @override
  String get tourSharedHostsHeading => 'เจ้าภาพ';

  @override
  String get tourSharedCoHostsHeading => 'เจ้าภาพร่วม';

  @override
  String get tourSharedVenues => 'สนามแข่งขัน';

  @override
  String get tourSharedMascot => 'มาสคอต';

  @override
  String get tourSharedMatchBall => 'ลูกฟุตบอลทางการ';

  @override
  String tourSharedVenueSeats(String city, String capacity) {
    return '$city · $capacity ที่นั่ง';
  }

  @override
  String get tourSharedCouldNotLoad => 'โหลดไม่ได้';

  @override
  String get tourSharedHostTbc => 'รอยืนยันเจ้าภาพ';

  @override
  String get tourSharedFinalsAreHere => 'รอบสุดท้ายมาถึงแล้ว';

  @override
  String tourSharedHostedBy(String hosts) {
    return 'เจ้าภาพ  $hosts';
  }

  @override
  String get tourSharedLetFinalsBegin => 'เริ่มรอบสุดท้าย';

  @override
  String get tourSharedCompetitions => 'รายการแข่งขัน';

  @override
  String get tourSharedWorldRanking => 'อันดับโลก';

  @override
  String get tourSharedCouldNotLoadTournaments => 'โหลดทัวร์นาเมนต์ไม่ได้';

  @override
  String get tourSharedPrestigeStage => 'เวทีแห่งเกียรติยศ';

  @override
  String get tourSharedOverview => 'ภาพรวม';

  @override
  String get tourSharedWorldRankingTitle => 'อันดับโลก';

  @override
  String get tourSharedYourCompetitions => 'รายการของคุณ';

  @override
  String get tourSharedOtherContinents => 'ทวีปอื่น';

  @override
  String get tourSharedComingSoon => 'ทัวร์นาเมนต์เร็วๆ นี้';

  @override
  String get tourSharedSoon => 'เร็วๆ นี้';

  @override
  String get tourSharedNoQualifyingDraw => 'ไม่มีการจับสลากรอบคัดเลือก';

  @override
  String get tourSharedOpenEnvelope => 'เปิดซอง';

  @override
  String tourSharedGroupName(String name) {
    return 'กลุ่ม $name';
  }

  @override
  String get tourSharedBall => 'ทีละลูก';

  @override
  String get tourSharedPot => 'ทีละโถ';

  @override
  String get tourSharedAll => 'ทั้งหมด';

  @override
  String get tourSharedTapDrawTeam => 'แตะเพื่อจับทีมถัดไป';

  @override
  String get tourSharedTapDrawPot => 'แตะเพื่อจับโถถัดไป';

  @override
  String get tourSharedTapDrawAll => 'แตะเพื่อเปิดผลจับสลากทั้งหมด';

  @override
  String get tourSharedContinue => 'ดำเนินการต่อ';

  @override
  String get tourSharedPause => 'หยุดชั่วคราว';

  @override
  String get tourSharedPlay => 'เล่น';

  @override
  String get tourSharedSkip => 'ข้าม';

  @override
  String tourSharedPotNumber(int number) {
    return 'โถ $number';
  }

  @override
  String get tourSharedDrawComplete => 'จับสลากเสร็จสิ้น';

  @override
  String get tourSharedDrawing => 'กำลังจับสลาก…';

  @override
  String get tourContChampionship => 'ชิงแชมป์';

  @override
  String get tourContTabSummary => 'สรุป';

  @override
  String get tourContTabQualifying => 'รอบคัดเลือก';

  @override
  String get tourContTabFinals => 'รอบสุดท้าย';

  @override
  String get tourContTabBracket => 'สายแข่ง';

  @override
  String get tourContTabAwards => 'รางวัล';

  @override
  String get tourContTabScorers => 'ดาวซัลโว';

  @override
  String get tourContTabHistory => 'ประวัติ';

  @override
  String get tourContTabRecords => 'สถิติ';

  @override
  String tourContCouldNotLoadCup(String error) {
    return 'โหลดข้อมูลรายการไม่ได้\n$error';
  }

  @override
  String get tourContNoCupData => 'ไม่มีข้อมูลรายการ';

  @override
  String get tourContUnknown => 'ไม่ทราบ';

  @override
  String get tourContGroupsToBeDrawnQual =>
      'กลุ่มรอบคัดเลือกจะจับสลากในพิธี ชมได้จากศูนย์กลางเพื่อดูว่าคุณจะเจอใคร';

  @override
  String get tourContQualSeeded =>
      'ชาติของคุณได้สิทธิ์เข้ารอบสุดท้ายโดยตรง ไม่ต้องเล่นรอบคัดเลือกในรอบนี้';

  @override
  String tourContBackgroundRegion(String name) {
    return '$name ถูกจำลองอยู่เบื้องหลัง ผลการแข่งขันจะปรากฏที่นี่เมื่อแต่ละรอบเล่นจบ';
  }

  @override
  String get tourContGroupsToBeDrawnFinals =>
      'กลุ่มรอบสุดท้ายจะจับสลากในพิธี ชมได้จากศูนย์กลางเพื่อดูกลุ่มของคุณ';

  @override
  String get tourContFinalsDrawAfterQual =>
      'การจับสลากรอบสุดท้ายจะเกิดขึ้นเมื่อรอบคัดเลือกจบลง';

  @override
  String get tourContContestedBeforeWc => 'รอบน็อกเอาต์จะแข่งก่อนชิงแชมป์โลก';

  @override
  String tourContChampionsHeading(String name) {
    return 'แชมป์ $name';
  }

  @override
  String tourContWinnersTitle(String name) {
    return 'แชมป์ $name';
  }

  @override
  String get tourContNoGoalsYet => 'ยังไม่มีประตู';

  @override
  String tourContGroupHeading(String name) {
    return 'กลุ่ม $name';
  }

  @override
  String get tourContBestRunnersUp => 'อันดับ 2 ที่ดีที่สุด';

  @override
  String tourContGroupDropdown(String name) {
    return 'กลุ่ม $name';
  }

  @override
  String get tourContMatches => 'โปรแกรมแข่งขัน';

  @override
  String get tourContNoGroupsDrawn => 'ยังไม่ได้จับสลากแบ่งกลุ่ม';

  @override
  String get tourContQualifyingDraw => 'จับสลากรอบคัดเลือก';

  @override
  String get tourContWorldQualifyingDraw => 'จับสลากรอบคัดเลือกระดับโลก';

  @override
  String get tourContFinalsDraw => 'จับสลากรอบสุดท้าย';

  @override
  String get tourContSeedingPots => 'โถจัดอันดับ';

  @override
  String get tourContGroupDraw => 'จับสลากแบ่งกลุ่ม';

  @override
  String tourContCouldNotLoadDraw(String error) {
    return 'โหลดผลจับสลากไม่ได้\n$error';
  }

  @override
  String get tourContDrawNotReady => 'การจับสลากยังไม่พร้อม';

  @override
  String get tourContContinentalClash => 'คอนติเนนทัล แคลช';

  @override
  String get tourContTabThisCycle => 'รอบนี้';

  @override
  String tourContCouldNotLoadClash(String error) {
    return 'โหลดไม่ได้\n$error';
  }

  @override
  String get tourContNoSaveFound => 'ไม่พบเซฟ';

  @override
  String get tourContClashSoon =>
      'คอนติเนนทัล แคลช จะแข่งเมื่อรู้ตัวแชมป์ทวีปทั้งสองแล้ว';

  @override
  String get tourContTwoContinentsOneMatch => 'สองทวีป หนึ่งนัด';

  @override
  String get tourContVersusShort => 'พบ';

  @override
  String tourContWinTheClash(String name) {
    return '$name คว้าแชมป์แคลช';
  }

  @override
  String get tourContNoClashYet => 'ยังไม่มีการแข่งคอนติเนนทัล แคลช';

  @override
  String get tourContNationsCup => 'เนชันส์คัพ';

  @override
  String get tourContTabLeagues => 'ลีก';

  @override
  String get tourContTabFinalsFour => 'รอบสี่ทีมสุดท้าย';

  @override
  String tourContCouldNotLoad(String error) {
    return 'โหลดไม่ได้\n$error';
  }

  @override
  String get tourContNoNationsCupGoals => 'ยังไม่มีการบันทึกประตูในเนชันส์คัพ';

  @override
  String get tourContNoNationsCupChampions => 'ยังไม่มีแชมป์เนชันส์คัพ';

  @override
  String get tourContNationsCupOffSeason =>
      'เนชันส์คัพของรอบนี้จะเริ่มหลังรอบสุดท้ายชิงแชมป์ทวีป แชมป์ในอดีตดูได้ที่ประวัติ';

  @override
  String get tourContNationsCupGroupsSoon =>
      'กลุ่มเนชันส์คัพของรอบนี้จะจับสลากในพิธี ชมได้จากศูนย์กลางเพื่อดูว่าคุณจะเจอใคร';

  @override
  String get tourContLeagueNoGroups => 'ไม่มีเกมในลีกนี้รอบนี้';

  @override
  String tourContLeagueHeading(String letter) {
    return 'ลีก $letter';
  }

  @override
  String tourContLeagueHeadingYours(String letter) {
    return 'ลีก $letter · ลีกของคุณ';
  }

  @override
  String get tourContFinalsFourSoon =>
      'รอบสี่ทีมสุดท้ายจะแข่งระหว่างแชมป์กลุ่มของลีก A เมื่อรอบแบ่งกลุ่มจบลง';

  @override
  String tourContLeagueChip(String letter) {
    return 'ลีก $letter';
  }

  @override
  String tourContLeagueChipStar(String letter) {
    return 'ลีก $letter ★';
  }

  @override
  String get tourContSemiFinals => 'รอบรองชนะเลิศ';

  @override
  String get tourContFinal => 'นัดชิงชนะเลิศ';

  @override
  String get tourContNationsCupDraw => 'จับสลากเนชันส์คัพ';

  @override
  String get tourContIntercontinentalPlayoff => 'เพลย์ออฟข้ามทวีป';

  @override
  String get tourContNoPlayoffThisCycle => 'ไม่มีเพลย์ออฟในรอบนี้';

  @override
  String get tourContPlayoffIntro =>
      'สองโควตาชิงแชมป์โลกที่ตัดสินผ่านการน็อกเอาต์ระหว่างทีมที่พลาดท่าในรอบคัดเลือกที่ดีที่สุด';

  @override
  String get tourContPlayoffThrough => 'คุณผ่านเพลย์ออฟแล้ว ได้ไปชิงแชมป์โลก!';

  @override
  String get tourContPlayoffOut =>
      'คุณพลาดในเพลย์ออฟ ไม่ได้ไปชิงแชมป์โลกในครั้งนี้';

  @override
  String get tourContContinue => 'ดำเนินการต่อ';

  @override
  String get tourContPlayoffFinals => 'นัดชิงเพลย์ออฟ';

  @override
  String get tourContPlayoffSeeded => 'ทีมวาง (บาย)';

  @override
  String get tourCupTabSummary => 'สรุป';

  @override
  String get tourCupTabQualifying => 'รอบคัดเลือก';

  @override
  String get tourCupTabPlayoff => 'เพลย์ออฟ';

  @override
  String get tourCupPlayoffSoon =>
      'เพลย์ออฟข้ามทวีปจะตัดสินเมื่อรอบคัดเลือกของทุกสมาพันธ์จบลง';

  @override
  String get tourCupTabFinals => 'รอบสุดท้าย';

  @override
  String get tourCupTabBracket => 'สายแข่ง';

  @override
  String get tourCupTabAwards => 'รางวัล';

  @override
  String get tourCupTabScorers => 'ดาวซัลโว';

  @override
  String get tourCupTabHistory => 'ประวัติ';

  @override
  String get tourCupTabRecords => 'สถิติ';

  @override
  String get tourCupTitle => 'ชิงแชมป์โลก';

  @override
  String get tourCupNoData => 'ไม่มีข้อมูลรายการ';

  @override
  String tourCupLoadError(String error) {
    return 'โหลดข้อมูลรายการไม่ได้\n$error';
  }

  @override
  String get tourCupUnknown => 'ไม่ทราบ';

  @override
  String get tourCupWorldChampions => 'แชมป์โลก';

  @override
  String get tourCupWorldChampionsTitle => 'แชมป์โลก';

  @override
  String get tourCupStillActive => 'ยังเล่นอยู่';

  @override
  String get tourCupAllTimeScorers => 'ดาวซัลโวตลอดกาล';

  @override
  String get tourCupAllConfederations => 'ทุกสมาพันธ์';

  @override
  String get tourCupBestRunnersUp => 'อันดับ 2 ที่ดีที่สุด';

  @override
  String get tourCupCompWorld => 'ชิงแชมป์โลก';

  @override
  String get tourCupCompEurope => 'ชิงแชมป์ยุโรป';

  @override
  String get tourCupCompSAmerica => 'ถ้วยอเมริกาใต้';

  @override
  String get tourCupDestRoundOf16 => 'รอบ 16 ทีม';

  @override
  String get tourCupDestKnockouts => 'รอบน็อกเอาต์';

  @override
  String get tourCupDestFinals => 'รอบสุดท้าย';

  @override
  String get tourCupDestFinalsPlayoff => 'เพลย์ออฟรอบสุดท้าย';

  @override
  String get tourCupDestIntercontPlayoff => 'เพลย์ออฟข้ามทวีป';

  @override
  String get tourCupFinalsDrawnAfterQual =>
      'รอบสุดท้ายจะจับสลากเมื่อรอบคัดเลือกจบลง';

  @override
  String get tourCupFinalsDrawSoon =>
      'ยังไม่จับสลากแบ่งกลุ่ม ชมการจับสลากชิงแชมป์โลกจากศูนย์กลางเพื่อดูผล';

  @override
  String tourCupGroupName(String name) {
    return 'กลุ่ม $name';
  }

  @override
  String tourCupGroupNameShort(String name) {
    return 'กลุ่ม $name';
  }

  @override
  String tourCupHostLabel(String host) {
    return 'เจ้าภาพ $host';
  }

  @override
  String tourCupHostLabelMulti(String hosts) {
    return 'เจ้าภาพ $hosts';
  }

  @override
  String get tourCupIntercontPlayoff => 'เพลย์ออฟข้ามทวีป';

  @override
  String get tourCupKnockoutSoon => 'สายแข่งจะเริ่มเมื่อรอบแบ่งกลุ่มจบลง';

  @override
  String get tourCupMatches => 'โปรแกรมแข่งขัน';

  @override
  String get tourCupMedalTable => 'ตารางเหรียญ';

  @override
  String get tourCupMostTitles => 'แชมป์มากที่สุด';

  @override
  String tourCupMostTitlesValue(String nation, int titles, int editions) {
    return '$nation: แชมป์ $titles สมัยจาก $editions ครั้ง';
  }

  @override
  String get tourCupNoGoals => 'ยังไม่มีประตู';

  @override
  String get tourCupNoGroups => 'ยังไม่ได้จับสลากแบ่งกลุ่ม';

  @override
  String get tourCupNoHistory => 'ยังไม่มีประวัติ';

  @override
  String get tourCupPastWinners => 'แชมป์ในอดีต';

  @override
  String get tourCupPlayoffIntro =>
      'สองโควตาชิงแชมป์โลกที่ตัดสินผ่านการน็อกเอาต์ระหว่างทีมที่พลาดท่าในรอบคัดเลือกที่ดีที่สุด';

  @override
  String tourCupPlayoffNoEntrants(String confederation) {
    return '$confederation ไม่มีเพลย์ออฟ: ทุกโควตาตัดสินกันในรอบคัดเลือกแบ่งกลุ่ม';
  }

  @override
  String get tourCupQualDrawSoon =>
      'ยังไม่จับสลากแบ่งกลุ่ม ชมการจับสลากรอบคัดเลือกจากศูนย์กลางเพื่อดูผล';

  @override
  String tourCupRegionYours(String region) {
    return '$region · ของคุณ';
  }

  @override
  String tourCupScorePens(int home, int away) {
    return '$home–$away (จุดโทษ)';
  }

  @override
  String get tourCupSegAllTime => 'ตลอดกาล';

  @override
  String get tourCupSegFinals => 'รอบสุดท้าย';

  @override
  String get tourCupSegQualifying => 'รอบคัดเลือก';

  @override
  String get playerTraitsTitle => 'จุดเด่น';

  @override
  String get traitBigGame => 'นักเตะเกมใหญ่';

  @override
  String get traitBigGameBlurb => 'เล่นดีขึ้นในเกมน็อกเอาต์';

  @override
  String get traitSetPiece => 'ผู้เชี่ยวชาญลูกตั้งเตะ';

  @override
  String get traitSetPieceBlurb =>
      'ส่งบอลได้ดีกว่า และได้ประตูจากลูกนิ่งมากขึ้น';

  @override
  String get traitHothead => 'ใจร้อน';

  @override
  String get traitHotheadBlurb => 'โดนใบเหลืองใบแดงบ่อยกว่าเพื่อนร่วมทีมมาก';

  @override
  String get traitIronMan => 'มนุษย์เหล็ก';

  @override
  String get traitIronManBlurb => 'บาดเจ็บยากและเหนื่อยช้ากว่า';

  @override
  String get traitWonderkid => 'ดาวรุ่งพุ่งแรง';

  @override
  String get traitWonderkidBlurb => 'อายุน้อย เก่งอยู่แล้ว และยังพัฒนาเร็ว';

  @override
  String get traitLeader => 'ผู้นำ';

  @override
  String get traitLeaderBlurb => 'ปลุกเพื่อนร่วมทีมทุกคนในสนาม';

  @override
  String get traitPacey => 'เท้าไว';

  @override
  String get traitPaceyBlurb => 'ความเร็วสุดขีด อันตรายเมื่อวิ่งทะลุแนวหลัง';

  @override
  String get traitOldHead => 'ประสบการณ์สูง';

  @override
  String get traitOldHeadBlurb => 'ทหารผ่านศึกที่อ่านเกมได้ดีกว่าที่ขาจะพาไป';

  @override
  String get traitWasteful => 'ยิงทิ้งขว้าง';

  @override
  String get traitWastefulBlurb => 'ยิงโอกาสดีๆ หลุดกรอบบ่อยเกินไป';

  @override
  String get objectiveWorldCup => 'ชิงแชมป์โลก';

  @override
  String get objectiveWinTournament => 'คว้าแชมป์';

  @override
  String get objectiveQualifyGeneric => 'ผ่านเข้ารอบ';

  @override
  String hubBoardObjectiveFor(String competition, String label) {
    return '$competition: $label';
  }

  @override
  String get objectiveWinWorldCup => 'คว้าแชมป์ชิงแชมป์โลก';

  @override
  String get objectiveReachFinal => 'เข้าชิงชนะเลิศ';

  @override
  String get objectiveReachSemis => 'เข้ารอบรองชนะเลิศ';

  @override
  String get objectiveReachQuarters => 'เข้ารอบ 8 ทีม';

  @override
  String get objectiveReachKnockouts => 'เข้ารอบน็อกเอาต์';

  @override
  String get objectiveQualify => 'ผ่านเข้ารอบชิงแชมป์โลก';

  @override
  String get finishChampions => 'แชมป์';

  @override
  String get finishRunnersUp => 'รองแชมป์';

  @override
  String get finishSemiFinals => 'รอบรองชนะเลิศ';

  @override
  String get finishQuarterFinals => 'รอบ 8 ทีม';

  @override
  String get finishRoundOf16 => 'รอบ 16 ทีม';

  @override
  String get finishGroupStage => 'รอบแบ่งกลุ่ม';

  @override
  String get objectiveQualifyingTopHalf => 'จบครึ่งบนของกลุ่มรอบคัดเลือก';

  @override
  String get finishQualifyingTopHalf => 'ครึ่งบนของกลุ่มรอบคัดเลือก';

  @override
  String get finishQualifyingBottomHalf => 'ครึ่งล่างของกลุ่มรอบคัดเลือก';

  @override
  String get objectiveNcWinIt => 'คว้าแชมป์เนชันส์คัพ';

  @override
  String get objectiveNcReachFinal => 'เข้าชิงชนะเลิศเนชันส์คัพ';

  @override
  String get objectiveNcFinalsFour => 'เข้ารอบสี่ทีมสุดท้าย';

  @override
  String get objectiveNcWinGroup => 'ชนะกลุ่มและเลื่อนชั้น';

  @override
  String get objectiveNcTopHalf => 'จบครึ่งบนของกลุ่ม';

  @override
  String get objectiveNcSurvive => 'หนีตกชั้น';

  @override
  String get objectiveNcOffTheBottom => 'ไม่จบบ๊วยกลุ่ม';

  @override
  String get finishNcChampions => 'แชมป์เนชันส์คัพ';

  @override
  String get finishNcFinalsFour => 'รอบสี่ทีมสุดท้าย';

  @override
  String get finishNcGroupWinners => 'แชมป์กลุ่ม';

  @override
  String get finishNcTopHalf => 'ครึ่งบนของกลุ่ม';

  @override
  String get finishNcStayedUp => 'รอดตกชั้น';

  @override
  String get finishNcClearOfBottom => 'พ้นบ๊วยกลุ่ม';

  @override
  String get finishNcBottom => 'บ๊วยกลุ่ม';

  @override
  String get careerNationsCupLabel => 'เนชันส์คัพ';

  @override
  String get squadDevPlayer => 'ผู้เล่น';

  @override
  String get squadDevAge => 'อายุ';

  @override
  String get squadDevPosition => 'ตำแหน่ง';

  @override
  String get squadDevChange => 'ค่าพลัง';

  @override
  String get squadDevNew => 'ใหม่';

  @override
  String get squadDevRetired => 'เลิกเล่น';

  @override
  String get squadDevEmpty => 'ปีที่นิ่ง ไม่มีการเปลี่ยนแปลงในทีม';

  @override
  String get squadDevTierRegulars => 'ขาประจำ';

  @override
  String get squadDevTierFringe => 'ตัวริมขอบ';

  @override
  String get squadDevTierYouth => 'เยาวชน';

  @override
  String get boardObjectivesTitle => 'เป้าหมายของบอร์ด';

  @override
  String get boardObjectivesConfidence => 'ความเชื่อมั่นของบอร์ด';

  @override
  String boardObjectiveBeatenBy(String result, int rounds) {
    String _temp0 = intl.Intl.pluralLogic(
      rounds,
      locale: localeName,
      other: 'ดีกว่าที่ตั้งไว้ $rounds รอบ',
      one: 'ดีกว่าที่ตั้งไว้ 1 รอบ',
    );
    return '$result: $_temp0';
  }

  @override
  String boardObjectiveShortBy(String result, int rounds) {
    String _temp0 = intl.Intl.pluralLogic(
      rounds,
      locale: localeName,
      other: 'ขาดไป $rounds รอบ',
      one: 'ขาดไป 1 รอบ',
    );
    return '$result: $_temp0';
  }

  @override
  String get boardObjectivesPending => 'ยังรอการตัดสิน';

  @override
  String boardObjectiveSoFar(String result) {
    return 'จนถึงตอนนี้ · $result';
  }

  @override
  String get boardObjectivesEmpty => 'บอร์ดยังไม่ได้ตั้งเป้าหมายสำหรับรอบนี้';

  @override
  String get tourContBestWinners => 'แชมป์กลุ่มที่ดีที่สุด';

  @override
  String get tourContBestThirds => 'อันดับ 3 ที่ดีที่สุด';

  @override
  String tourContBestPlaced(String position) {
    return 'อันดับ $position ที่ดีที่สุด';
  }

  @override
  String squadDevPageOf(String page, String pages, String total) {
    return '$page/$pages · $total คน';
  }

  @override
  String get matchSoldOut => 'ตั๋วขายหมด';

  @override
  String matchAttendanceOf(String attendance, String capacity) {
    return 'ผู้ชม $attendance จาก $capacity ที่นั่ง';
  }

  @override
  String get matchGroundTitle => 'สนาม';

  @override
  String get absenceInjured => 'บาดเจ็บ';

  @override
  String get absenceSuspended => 'ติดโทษแบน';

  @override
  String absenceWeeks(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString สัปดาห์',
      one: '1 สัปดาห์',
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
      other: '$countString นัด',
      one: '1 นัด',
    );
    return '$_temp0';
  }

  @override
  String absenceBackFor(String opponent) {
    return 'กลับมาทันเกมพบ $opponent';
  }

  @override
  String get penaltyOrderTitle => 'จุดโทษ';

  @override
  String get penaltyOrderBlurb =>
      'เลือกผู้ยิง 5 คนตามลำดับ แตะช่องเพื่อเปลี่ยน';

  @override
  String penaltyOrderPick(int number) {
    return 'ลูกที่ $number';
  }

  @override
  String get penaltyOrderPickBlurb =>
      'เลือกคนที่จะก้าวออกมา แถบแสดงความนิ่งในการยิงจุดโทษ';

  @override
  String get penaltyOrderConfirm => 'เริ่มยิง';

  @override
  String get penaltyOrderCancel => 'กลับ';

  @override
  String get youthTitle => 'เยาวชน';

  @override
  String get youthEmptyLevel => 'ยังไม่มีใครในระดับนี้';

  @override
  String get youthReleased => 'ถูกปล่อยตัวปีนี้';

  @override
  String get u21Title => 'ยู-21';

  @override
  String get u21Blurb =>
      'คนรุ่นถัดไป เรียงจากดาวรุ่งที่ดีที่สุด ดาวโปร่งคือการประเมินของแมวมอง ให้ลงเล่นทีมชาติเพื่อรู้ว่าเขามีของจริงแค่ไหน';

  @override
  String get u21Empty =>
      'ตอนนี้ไม่มีผู้เล่นอายุต่ำกว่า 21 ปี รุ่นถัดไปจะมาพร้อมรอบใหม่';

  @override
  String u21Breakout(int gain) {
    return '+$gain ปีนี้';
  }

  @override
  String u21AgeCaps(int age, int caps) {
    return 'อายุ $age · ติดทีมชาติ $caps นัด';
  }

  @override
  String u21AgeUncapped(int age) {
    return 'อายุ $age · ยังไม่เคยติดทีมชาติ';
  }

  @override
  String get u21CallUps => 'ไปหน้าเรียกตัว';

  @override
  String get youthWatching => 'ติดตาม';

  @override
  String get youthWatchEmpty =>
      'ยังไม่ได้ติดตามใคร ทำเครื่องหมายเด็กคนไหนก็ได้ในระดับใดก็ได้ แล้วเขาจะปรากฏที่นี่ พร้อมพัฒนาการนับจากนั้น';

  @override
  String get youthWatchMark => 'ติดตามเด็กคนนี้';

  @override
  String get youthWatchUnmark => 'เลิกติดตาม';

  @override
  String youthWatchMarked(int rating, int age) {
    return 'ติดตามเมื่อค่าพลัง $rating อายุ $age';
  }

  @override
  String get youthWatchSenior => 'ขึ้นสู่ชุดใหญ่แล้ว';

  @override
  String get youthWatchReleased => 'ถูกอะคาเดมีปล่อยตัว';

  @override
  String get youthWatchGone => 'ไม่อยู่ในระบบเยาวชนแล้ว';

  @override
  String get tacticsYouth => 'ยู-21';

  @override
  String get pressSquad => 'ทีม';

  @override
  String get pressBoard => 'บอร์ด';

  @override
  String get pressNoEffect => 'ไม่มีใครใส่ใจมากนัก';

  @override
  String get matchNeutralGround => 'สนามกลาง';

  @override
  String get matchExtraTimeAhead => 'ต่อเวลาพิเศษ';

  @override
  String get matchExtraTimeHalf => 'ต่อเวลาพิเศษ · พักครึ่ง';

  @override
  String get matchClockFullTime => 'จบเกม';

  @override
  String get matchClockAfterExtraTime => 'หลังต่อเวลาพิเศษ';

  @override
  String get matchClockPenalties => 'ดวลจุดโทษ';

  @override
  String get matchClockFullTimePenalties => 'จบเกม · จุดโทษ';

  @override
  String get hubEventPressConference => 'เผชิญหน้าสื่อ';

  @override
  String get hubEventPressConferenceSub => 'สื่อทั่วโลกอยากคุยกับคุณก่อนเกมแรก';

  @override
  String get squadDevWonderkid => 'ดาวรุ่งพุ่งแรง';

  @override
  String get tacticsPlaystyle => 'สไตล์การเล่น';

  @override
  String get tacticsPlaystyleBlurb =>
      'เลือกสไตล์ของทีม ปุ่มปรับด้านล่างช่วยปรับแต่งละเอียด';

  @override
  String get tacticsPlaystyleCustom =>
      'การตั้งค่าของคุณเอง ไม่ตรงกับสไตล์ใดที่มีชื่อ';

  @override
  String get playstyleCustom => 'กำหนดเอง';

  @override
  String get playstyleBalanced => 'สมดุล';

  @override
  String get playstylePossession => 'ครองบอล';

  @override
  String get playstyleGegenpress => 'เกเกนเพรส';

  @override
  String get playstyleCounter => 'โต้กลับ';

  @override
  String get playstyleDirect => 'ไดเร็กต์';

  @override
  String get playstyleLowBlock => 'ตั้งรับต่ำ';

  @override
  String get playstyleWingPlay => 'เล่นริมเส้น';

  @override
  String get playstyleBalancedBlurb =>
      'แน่นทั้งเกมรุกและเกมรับ ไม่มีอะไรมากเกินไป';

  @override
  String get playstylePossessionBlurb =>
      'ครองบอล ขยับอย่างใจเย็น บีบพื้นที่คู่แข่ง';

  @override
  String get playstyleGegenpressBlurb =>
      'แย่งบอลคืนทันทีที่เสีย สูงในแดนคู่แข่ง';

  @override
  String get playstyleCounterBlurb =>
      'ถอยรับ เล่นกระชับ แล้วสวนกลับด้วยความเร็ว';

  @override
  String get playstyleDirectBlurb => 'เติมบอลขึ้นหน้าเร็วและเล่นลูกสอง';

  @override
  String get playstyleLowBlockBlurb => 'ลึก แคบ และเจาะยากมาก';

  @override
  String get playstyleWingPlayBlurb => 'ขยายพื้นที่ อ้อมด้านนอกแล้วเปิดบอล';

  @override
  String get nationsRandomTeam => 'สุ่มทีม';

  @override
  String get nationsFromTheBottom => 'เริ่มจากล่างสุด';

  @override
  String get bottomStartTitle => 'ตกงาน';

  @override
  String get bottomStartHeading => 'สามสมาคมอยากคุยกับคุณ';

  @override
  String get bottomStartBlurb =>
      'คุณไม่มีงานและไม่มีชื่อเสียง มีแค่ทีมเหล่านี้ที่ยอมเสี่ยงกับคุณ เลือกสักทีมแล้วสร้างบางอย่างจากศูนย์';

  @override
  String get bottomStartAccept => 'รับงาน';

  @override
  String get bottomStartBack => 'กลับสู่เมนู';

  @override
  String bottomStartRankOf(int rank, int total) {
    return 'อันดับ $rank จาก $total ของโลก';
  }

  @override
  String get campTitle => 'แคมป์ที่พัก';

  @override
  String campBasedIn(String host) {
    return 'ประจำที่ $host';
  }

  @override
  String get campBlurb =>
      'ที่พักของทีมตลอดทัวร์นาเมนต์ เปลี่ยนไม่ได้เมื่อเริ่มแข่งแล้ว และมีผลสามอย่างทุกนัด: ความสดเมื่อมาถึง ความเร็วในการฟื้นจากอาการเจ็บ และความคมของทีม';

  @override
  String get campEffectTravel => 'มาถึงสด';

  @override
  String get campEffectRecovery => 'ฟื้นจากเจ็บ';

  @override
  String get campEffectSharpness => 'ความคมในเกม';

  @override
  String get campTerrainCity => 'ใจกลางเมือง';

  @override
  String get campTerrainCoastal => 'รีสอร์ตริมทะเล';

  @override
  String get campTerrainMountain => 'ที่พักบนภูเขา';

  @override
  String get campTerrainAltitude => 'แคมป์ที่สูง';

  @override
  String get campTerrainNationalCentre => 'ศูนย์ฝึกแห่งชาติ';

  @override
  String get campTerrainCityBlurb =>
      'ทุกอย่างอยู่ใกล้มือ ไม่ต้องเดินทาง แต่ไม่มีความสงบและหนีเสียงอึกทึกไม่พ้น';

  @override
  String get campTerrainCoastalBlurb =>
      'สงบ สบาย และดีต่ออารมณ์ แต่ต้องนั่งรถนานไปทุกสนาม';

  @override
  String get campTerrainMountainBlurb =>
      'อากาศเย็นและทีมแพทย์ชั้นยอดที่ช่วยฟื้นอาการเจ็บได้เร็ว แต่ไกลจากทัวร์นาเมนต์';

  @override
  String get campTerrainAltitudeBlurb =>
      'ซ้อมหนัก แต่ขาจะไปได้ไกลจนถึงช่วงท้ายทัวร์นาเมนต์';

  @override
  String get campTerrainNationalCentreBlurb =>
      'สิ่งอำนวยความสะดวกของสมาคมเอง: ไม่หวือหวา ไม่มีอะไรผิดพลาด';

  @override
  String get hubEventChooseCamp => 'เลือกแคมป์ที่พัก';

  @override
  String hubEventChooseCampSub(String host) {
    return 'ที่ที่ทีมจะประจำอยู่ใน $host';
  }

  @override
  String get tacticsTabBench => 'ม้านั่งสำรอง';

  @override
  String get squadSearchHint => 'ค้นหาด้วยชื่อหรือสโมสร';

  @override
  String get squadFilterAll => 'ทุกคน';

  @override
  String get squadFilterInSquad => 'ในทีมชุด';

  @override
  String get squadFilterUncapped => 'ยังไม่ติดทีมชาติ';

  @override
  String get squadFilterUnavailable => 'ไม่พร้อม';

  @override
  String get squadLineAll => 'ทุกแนว';

  @override
  String get squadSortBy => 'เรียง';

  @override
  String get squadSortRating => 'ค่าพลัง';

  @override
  String get squadSortCaps => 'ติดทีมชาติ';

  @override
  String get squadSortGoals => 'ประตู';

  @override
  String get squadSortAge => 'อายุ';

  @override
  String get squadSortName => 'ชื่อ';

  @override
  String get squadLegendTitle => 'ความหมายของสัญลักษณ์';

  @override
  String get squadLegendStarting => 'อยู่ใน 11 ตัวจริง';

  @override
  String get squadLegendCalledUp => 'ถูกเรียกตัว นั่งสำรอง';

  @override
  String get squadLegendRatingUp => 'ค่าพลังเพิ่มขึ้นปีนี้';

  @override
  String get squadLegendRatingDown => 'ค่าพลังลดลงปีนี้';

  @override
  String get squadLegendInjured => 'บาดเจ็บ ไม่พร้อม';

  @override
  String get squadLegendSuspended => 'ติดโทษแบน ไม่พร้อม';

  @override
  String get squadLegendTraits => 'จุดเด่น';

  @override
  String squadShowingOf(int shown, int total) {
    return 'แสดง $shown จาก $total คน';
  }

  @override
  String get squadNobodyMatches => 'ไม่มีผู้เล่นที่ตรงกับตัวกรอง';

  @override
  String get squadStatPool => 'ตัวเลือก';

  @override
  String get squadStatInSquad => 'ถูกเรียกตัว';

  @override
  String get squadMostCapped => 'ติดทีมชาติมากสุด';

  @override
  String get squadTopScorer => 'ดาวซัลโว';

  @override
  String squadCapsValue(String name, int caps) {
    return '$name · $caps นัด';
  }

  @override
  String squadGoalsValue(String name, int goals) {
    return '$name · $goals ประตู';
  }

  @override
  String squadAgeClub(int age, String club) {
    return '$age · $club';
  }

  @override
  String get squadCapsShort => 'นัด';

  @override
  String get squadGoalsShort => 'ประตู';

  @override
  String get recordsRecordBookSubtitle =>
      'นัดติดทีมชาติ ประตู และสถิติสำคัญของทีม';

  @override
  String get statsLegacy => 'มรดก';

  @override
  String tacticsSubAlreadyOff(String name) {
    return '$name ถูกเปลี่ยนออกไปแล้วและกลับลงมาไม่ได้';
  }

  @override
  String tacticsSubSentOff(String name) {
    return '$name โดนไล่ออกและไม่มีส่วนร่วมอีกต่อไป';
  }

  @override
  String get tacticsInjuredShort => 'เจ็บ';

  @override
  String get tacticsSuspendedShort => 'ติดแบน';

  @override
  String get confEurope => 'ยุโรป';

  @override
  String get confSouthAmerica => 'อเมริกาใต้';

  @override
  String get confNorthAmerica => 'อเมริกาเหนือ';

  @override
  String get confAfrica => 'แอฟริกา';

  @override
  String get confAsia => 'เอเชีย';

  @override
  String get confOceania => 'โอเชียเนีย';

  @override
  String get compWorldCup => 'ชิงแชมป์โลก';

  @override
  String get compWorldCupFinals => 'รอบสุดท้ายชิงแชมป์โลก';

  @override
  String get compWorldCupQualifying => 'รอบคัดเลือกชิงแชมป์โลก';

  @override
  String compQualifiers(String region) {
    return 'รอบคัดเลือกโซน$region';
  }

  @override
  String get compFriendlies => 'กระชับมิตร';

  @override
  String get compNationsCup => 'เนชันส์คัพ';

  @override
  String get compContinentalClash => 'คอนติเนนทัล แคลช';

  @override
  String get compIntercontinentalPlayoff => 'เพลย์ออฟข้ามทวีป';

  @override
  String get compContinentalChampionship => 'ชิงแชมป์ทวีป';

  @override
  String get compEuropeanChampionship => 'ชิงแชมป์ยุโรป';

  @override
  String get compSouthAmericaCup => 'ถ้วยอเมริกาใต้';

  @override
  String get compAfricanChampionship => 'ชิงแชมป์แอฟริกา';

  @override
  String get compAsianChampionship => 'ชิงแชมป์เอเชีย';

  @override
  String get compNorthAmericaCup => 'ถ้วยอเมริกาเหนือ';

  @override
  String get compOceaniaCup => 'ถ้วยโอเชียเนีย';

  @override
  String get msgANation => 'ชาติหนึ่ง';

  @override
  String get msgAPlayer => 'ผู้เล่นคนหนึ่ง';

  @override
  String get msgAHostNation => 'ชาติเจ้าภาพ';

  @override
  String get msgCycleTitle1 => 'รอบใหม่เริ่มต้นขึ้น';

  @override
  String msgCycleTitle2(int year) {
    return 'เส้นทางสู่ปี $year เปิดแล้ว';
  }

  @override
  String get msgCycleTitle3 => 'แคมเปญใหม่เริ่มต้น';

  @override
  String get msgCycleTitle4 => 'กลับมาทำงาน';

  @override
  String msgCycleBody1(int year) {
    return 'เส้นทางสู่ชิงแชมป์โลก $year เริ่มต้นที่นี่';
  }

  @override
  String msgCycleBody2(int year) {
    return 'รอบใหม่ เป้าหมายคือชิงแชมป์โลก $year';
  }

  @override
  String msgCycleBody3(int year) {
    return 'อีกสี่ปีสู่ชิงแชมป์โลก $year เริ่มงานได้เลย';
  }

  @override
  String msgCycleBody4(int year) {
    return 'แคมเปญปี $year เริ่มต้นวันนี้';
  }

  @override
  String msgContHostTitle(String cup, String host) {
    return 'เจ้าภาพ $cup: $host';
  }

  @override
  String msgContHostBody(String host, String cup) {
    return '$host จะเป็นเจ้าภาพ $cup ครั้งถัดไป';
  }

  @override
  String msgContQualDrawTitle(String cup) {
    return 'จับสลากรอบคัดเลือก $cup';
  }

  @override
  String msgContQualDrawBody(String cup) {
    return 'จับสลากแบ่งกลุ่มรอบคัดเลือก $cup เรียบร้อยแล้ว';
  }

  @override
  String msgWcHostTitle(String host, int year) {
    return 'เจ้าภาพชิงแชมป์โลก $year: $host';
  }

  @override
  String msgWcHostBody(String host, int year) {
    return '$host จะเป็นเจ้าภาพชิงแชมป์โลก $year';
  }

  @override
  String get msgWcQualDrawTitle => 'จับสลากรอบคัดเลือกชิงแชมป์โลก';

  @override
  String get msgWcQualDrawBody =>
      'จับสลากแบ่งกลุ่มรอบคัดเลือกชิงแชมป์โลกเรียบร้อยแล้ว';

  @override
  String msgContFinalsDrawTitle(String cup) {
    return 'จับสลากรอบสุดท้าย $cup';
  }

  @override
  String msgContFinalsDrawBody(String cup) {
    return 'จับสลากแบ่งกลุ่มรอบสุดท้าย $cup เรียบร้อยแล้ว';
  }

  @override
  String get msgWcFinalsDrawTitle => 'จับสลากรอบสุดท้ายชิงแชมป์โลก';

  @override
  String msgWcFinalsDrawBody(int year) {
    return 'จับสลากรอบสุดท้ายชิงแชมป์โลก $year เรียบร้อยแล้ว';
  }

  @override
  String get msgQualWcTitle1 => 'ผ่านเข้าสู่ชิงแชมป์โลก';

  @override
  String get msgQualWcTitle2 => 'จองตั๋วชิงแชมป์โลกแล้ว';

  @override
  String get msgQualWcTitle3 => 'เรากำลังไปชิงแชมป์โลก';

  @override
  String get msgQualWcTitle4 => 'ได้ตั๋วแล้ว';

  @override
  String msgQualWcBody1(int year) {
    return 'คุณผ่านเข้ารอบสุดท้ายชิงแชมป์โลก $year แล้ว';
  }

  @override
  String msgQualWcBody2(int year) {
    return 'เป็นทางการแล้ว: ชาติของคุณได้ไปชิงแชมป์โลก $year';
  }

  @override
  String msgQualWcBody3(int year) {
    return 'คว้าที่นั่งในชิงแชมป์โลก $year ได้แล้ว';
  }

  @override
  String msgQualWcBody4(int year) {
    return 'คุณผ่านเข้าสู่รอบสุดท้ายชิงแชมป์โลก $year';
  }

  @override
  String msgQualContTitle1(String cup) {
    return 'ผ่านเข้าสู่ $cup';
  }

  @override
  String msgQualContTitle2(String cup) {
    return 'จองตั๋ว $cup แล้ว';
  }

  @override
  String msgQualContTitle3(String cup) {
    return 'ผ่านเข้ารอบ $cup';
  }

  @override
  String msgQualContBody1(String cup) {
    return 'คุณผ่านเข้ารอบสุดท้าย $cup แล้ว';
  }

  @override
  String msgQualContBody2(String cup) {
    return 'ชาติของคุณคว้าที่นั่งใน $cup ได้แล้ว';
  }

  @override
  String msgQualContBody3(String cup) {
    return 'คุณผ่านเข้าสู่ $cup';
  }

  @override
  String msgChampTitleMine1(String comp) {
    return 'แชมป์ $comp!';
  }

  @override
  String msgChampTitleMine2(String comp) {
    return 'แชมป์ $comp!';
  }

  @override
  String msgChampTitleMine3(String comp) {
    return 'คุณคว้าแชมป์ $comp!';
  }

  @override
  String msgChampTitleOther1(String comp) {
    return '$comp ได้แชมป์แล้ว';
  }

  @override
  String msgChampTitleOther2(String comp) {
    return 'สวมมงกุฎแชมป์ $comp';
  }

  @override
  String msgChampTitleOther3(String comp) {
    return '$comp มีเจ้าของแล้ว';
  }

  @override
  String msgChampBodyMine1(String comp, String loser, String result, int year) {
    return 'ชาติของคุณคือแชมป์ $comp ปี $year หลังเอาชนะ $loser$result';
  }

  @override
  String msgChampBodyMine2(String comp, String loser, String result, int year) {
    return 'คุณคว้าแชมป์ $comp ปี $year โดยเขี่ย $loser$result';
  }

  @override
  String msgChampBodyMine3(String comp, String loser, String result, int year) {
    return '$comp ปี $year เป็นของคุณ เอาชนะ $loser$result';
  }

  @override
  String msgChampBodyOther1(
    String winner,
    String comp,
    String loser,
    String result,
    int year,
  ) {
    return '$winner คว้าแชมป์ $comp ปี $year หลังเอาชนะ $loser$result';
  }

  @override
  String msgChampBodyOther2(
    String winner,
    String comp,
    String loser,
    String result,
    int year,
  ) {
    return '$winner คือแชมป์ $comp ปี $year หลังชนะ $loser$result';
  }

  @override
  String msgFinalScoreSuffix(int home, int away) {
    return ' $home–$away ในนัดชิง';
  }

  @override
  String msgFinalPensSuffix(int home, int away) {
    return ' ด้วยการดวลจุดโทษ หลังเสมอกัน $home–$away ในนัดชิง';
  }

  @override
  String get msgWpotyTitle => 'นักเตะยอดเยี่ยมของโลกประจำปี';

  @override
  String msgWpotyBodyMine(String name, String nation, int year) {
    return '$name ($nation) ได้รับเลือกเป็นนักเตะยอดเยี่ยมของโลกประจำปี $year และเป็นลูกทีมของคุณ';
  }

  @override
  String msgWpotyBodyOther(String name, String nation, int year) {
    return '$name ($nation) ได้รับเลือกเป็นนักเตะยอดเยี่ยมของโลกประจำปี $year';
  }

  @override
  String get msgYpotTitle => 'ดาวรุ่งยอดเยี่ยมของทัวร์นาเมนต์';

  @override
  String msgYpotBodyMine(String name, String nation, int age, int year) {
    return '$name ($nation) วัย $age ปี ได้รับเลือกเป็นดาวรุ่งยอดเยี่ยมของทัวร์นาเมนต์ปี $year และเป็นลูกทีมของคุณ';
  }

  @override
  String msgYpotBodyOther(String name, String nation, int age, int year) {
    return '$name ($nation) วัย $age ปี ได้รับเลือกเป็นดาวรุ่งยอดเยี่ยมของทัวร์นาเมนต์ปี $year';
  }

  @override
  String msgRankHold1(int rank) {
    return 'คุณยังอยู่ที่อันดับ #$rank';
  }

  @override
  String msgRankHold2(int rank) {
    return 'ไม่เปลี่ยนแปลง ยังคงอันดับ #$rank';
  }

  @override
  String msgRankHold3(int rank) {
    return 'ทรงตัวที่อันดับ #$rank';
  }

  @override
  String msgRankUp1(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move อันดับ',
    );
    return 'ขยับขึ้นรวม $_temp0 สู่อันดับ #$rank';
  }

  @override
  String msgRankUp2(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move อันดับ',
    );
    return 'การไต่ขึ้น $_temp0 พาคุณสู่อันดับ #$rank';
  }

  @override
  String msgRankUp3(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move อันดับ',
    );
    return 'ขึ้น $_temp0 ตอนนี้อยู่ที่ #$rank';
  }

  @override
  String msgRankDown1(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move อันดับ',
    );
    return 'ร่วงลงรวม $_temp0 สู่อันดับ #$rank';
  }

  @override
  String msgRankDown2(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move อันดับ',
    );
    return 'การร่วงลง $_temp0 ทำให้คุณหล่นไปอยู่อันดับ #$rank';
  }

  @override
  String msgRankDown3(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move อันดับ',
    );
    return 'ลง $_temp0 ตอนนี้อยู่ที่ #$rank';
  }

  @override
  String get msgRankLeadYou => 'คุณคือเบอร์หนึ่งของโลก';

  @override
  String msgRankLeadOther(String nation) {
    return '$nation คือเบอร์หนึ่งของโลก';
  }

  @override
  String msgRankTitle(int rank) {
    return 'อันดับโลก · #$rank';
  }

  @override
  String msgRankBody(String lead, String movement) {
    return 'อันดับโลกได้รับการอัปเดตแล้ว $lead $movement';
  }

  @override
  String msgRankJumpTitleUp(int rank) {
    return 'ไต่ขึ้นสู่อันดับ #$rank';
  }

  @override
  String msgRankJumpTitleDown(int rank) {
    return 'ร่วงลงสู่อันดับ #$rank';
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
      other: '$move อันดับ',
    );
    return '$tournament ทำให้อันดับโลกเปลี่ยนไป $nation เข้าไปที่อันดับ #$from และออกมาที่ #$to ไต่ขึ้น $_temp0';
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
      other: '$move อันดับ',
    );
    return '$tournament ทำให้อันดับโลกเปลี่ยนไป $nation เข้าไปที่อันดับ #$from และออกมาที่ #$to ร่วงลง $_temp0';
  }

  @override
  String get rankingSinceWcDraw => 'นับจากการจับสลากชิงแชมป์โลก';

  @override
  String get rankingSinceCycleStart => 'นับจากเริ่มแคมเปญ';

  @override
  String rankingMovedFromTo(int from, int now) {
    return '#$from เป็น #$now';
  }

  @override
  String msgCapsTitle(String name, int count) {
    return '$name ติดทีมชาติครบ $count นัด';
  }

  @override
  String msgCapsBody(String name, int count) {
    return '$name ลงเล่นให้ชาติของคุณครบ $count นัดแล้ว';
  }

  @override
  String msgGoalsTitle(String name, int count) {
    return '$name ยิงครบ $count ประตู';
  }

  @override
  String msgGoalsBody(String name, int count) {
    return '$name ยิงในนามทีมชาติให้ชาติของคุณครบ $count ประตูแล้ว';
  }

  @override
  String msgDevTitle(int year) {
    return 'พัฒนาการของทีม · $year';
  }

  @override
  String msgThroughTitle(int year) {
    return 'ขึ้นจากอะคาเดมี · $year';
  }

  @override
  String get msgThroughNote =>
      'นี่ไม่ใช่เด็กรุ่นใหม่ แต่คือเด็กที่เข้ามาตอนอายุสิบเอ็ดและตอนนี้เติบโตขึ้นสู่ชุดใหญ่แล้ว';

  @override
  String msgNewFacesTitle(int year) {
    return 'หน้าใหม่ · $year';
  }

  @override
  String get msgIntakeNoteAcademy =>
      'การลงทุนในอะคาเดมีเริ่มเห็นผล: เด็กรุ่นนี้แข็งแกร่งกว่าที่ควรจะเป็น';

  @override
  String get msgIntakeNoteStanding =>
      'ทั้งประเทศกำลังจับตาทีมนี้: เมื่อทีมไต่อันดับโลกขึ้น เด็กที่เก่งที่สุดก็เลือกฟุตบอล และเด็กรุ่นนี้ก็แข็งแกร่งขึ้นเพราะเหตุนั้น';

  @override
  String get msgIntakeNoteBoth =>
      'ทั้งเงินลงทุนในอะคาเดมีและการไต่อันดับโลกของทีมเริ่มเห็นผล: เด็กรุ่นนี้แข็งแกร่งกว่าที่ควรจะเป็น';

  @override
  String msgIntakeTitle(int year) {
    return 'เด็กใหม่จากอะคาเดมี · $year';
  }

  @override
  String msgRetireCaptainTitle(String name) {
    return '$name กัปตันของคุณเลิกเล่น';
  }

  @override
  String msgRetireTitle(String name) {
    return '$name อำลาทีมชาติ';
  }

  @override
  String msgRetireBody(String name, int age) {
    return '$name อำลาทีมชาติในวัย $age ปี';
  }

  @override
  String msgRetireBodyWith(String name, String tally, int age) {
    return '$name อำลาทีมชาติในวัย $age ปี ปิดฉากด้วย $tally';
  }

  @override
  String msgTallyCaps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ติดทีมชาติ $count นัด',
    );
    return '$_temp0';
  }

  @override
  String msgTallyGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ประตู',
    );
    return '$_temp0';
  }

  @override
  String get msgArmbandVacant =>
      ' ปลอกแขนกัปตันว่างอยู่ เลือกกัปตันคนใหม่ได้จากหน้าเรียกตัว';

  @override
  String msgHofTitle(String name) {
    return '$name ได้รับเกียรติเข้าสู่หอเกียรติยศ';
  }

  @override
  String msgHofBody(String name, int caps, int goals) {
    return '$name เข้าสู่หอเกียรติยศของชาติคุณ (ติดทีมชาติ $caps นัด $goals ประตู) ดูได้ที่ตำนาน';
  }

  @override
  String hubBanTitle(String name) {
    return '$name ติดโทษแบน';
  }

  @override
  String hubBanBody(String name, String how, int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: '$matches นัดถัดไป',
    );
    return '$name $how และติดโทษแบน $_temp0 จะไม่สามารถเลือกลงสนามได้';
  }

  @override
  String get hubBanHowSecondYellow => 'โดนไล่ออกจากใบเหลืองใบที่สอง';

  @override
  String get hubBanHowViolent => 'โดนใบแดงตรงจากการใช้ความรุนแรง';

  @override
  String get hubBanHowRed => 'โดนไล่ออก';

  @override
  String hubInjuryTitle(String name) {
    return '$name บาดเจ็บ';
  }

  @override
  String hubInjuryBody(String name, int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: '$matches นัด',
    );
    return '$name ได้รับบาดเจ็บและต้องพัก $_temp0';
  }

  @override
  String get hubRunnerUpTitle1 => 'รองแชมป์';

  @override
  String get hubRunnerUpTitle2 => 'ใกล้แค่เอื้อม แต่ไกลเกินไขว่คว้า';

  @override
  String get hubRunnerUpTitle3 => 'เหรียญเงิน';

  @override
  String hubRunnerUpBody1(String cup, String opponent) {
    return 'คุณเข้าถึงนัดชิง $cup แต่แพ้ $opponent ใกล้มาก ครั้งนี้ได้เหรียญเงิน';
  }

  @override
  String hubRunnerUpBody2(String cup, String opponent) {
    return 'แพ้ $opponent ในนัดชิง $cup รองแชมป์ที่ใกล้จนน่าเจ็บใจ';
  }

  @override
  String hubRunnerUpBody3(String cup, String opponent) {
    return 'นัดชิง $cup หลุดมือไปเมื่อเจอ $opponent มีหลายอย่างให้ภูมิใจ แต่ไม่ใช่ถ้วยรางวัล';
  }

  @override
  String get hubKnockedOutTitle1 => 'ตกรอบ';

  @override
  String get hubKnockedOutTitle2 => 'สุดทางแล้ว';

  @override
  String get hubKnockedOutTitle3 => 'การเดินทางสิ้นสุด';

  @override
  String hubKnockedOutBody1(String cup, String opponent, String stage) {
    return 'คุณตกรอบ $cup แพ้ $opponent ใน$stage';
  }

  @override
  String hubKnockedOutBody2(String cup, String opponent, String stage) {
    return '$opponent ยุติเส้นทาง $cup ของคุณใน$stage';
  }

  @override
  String hubKnockedOutBody3(String cup, String opponent, String stage) {
    return 'เส้นทาง $cup ของคุณจบลงใน$stage หลังแพ้ $opponent';
  }

  @override
  String get hubGroupExitTitle1 => 'ตกรอบแบ่งกลุ่ม';

  @override
  String get hubGroupExitTitle2 => 'ตกรอบแบ่งกลุ่ม';

  @override
  String get hubGroupExitTitle3 => 'กลับบ้านเร็ว';

  @override
  String hubGroupExitBody1(String cup) {
    return 'เส้นทาง $cup ของคุณจบลงในรอบแบ่งกลุ่ม ไม่ดีพอจะเข้ารอบน็อกเอาต์';
  }

  @override
  String hubGroupExitBody2(String cup) {
    return 'คุณผ่านรอบแบ่งกลุ่มไม่ได้ เส้นทาง $cup ของคุณจบลงที่นี่';
  }

  @override
  String hubGroupExitBody3(String cup) {
    return 'ครั้งนี้ไม่ได้เข้ารอบน็อกเอาต์ $cup ของคุณจบลงในรอบแบ่งกลุ่ม';
  }

  @override
  String boardObjectiveMetTitle(String comp) {
    return 'บรรลุเป้าหมาย: $comp';
  }

  @override
  String boardObjectiveMissedTitle(String comp) {
    return 'พลาดเป้าหมาย: $comp';
  }

  @override
  String boardObjectiveMetBody(String comp, String demand, String finish) {
    return 'เป้าหมายของบอร์ดใน $comp: $demand ผลงานของคุณ: $finish บอร์ดได้สิ่งที่ต้องการแล้ว';
  }

  @override
  String boardObjectiveMissedBody(String comp, String demand, String finish) {
    return 'เป้าหมายของบอร์ดใน $comp: $demand ผลงานของคุณ: $finish ยังต่ำกว่าที่คาดหวังไว้';
  }

  @override
  String get newsWcMissTitle => 'ฝันชิงแชมป์โลกจบลง';

  @override
  String newsWcMissBody(int year) {
    return 'คุณไม่ได้ไปชิงแชมป์โลก $year แคมเปญรอบคัดเลือกไปไม่ถึง รออีกสี่ปี';
  }

  @override
  String get newsRecordScorerTitle => 'ดาวซัลโวตลอดกาล';

  @override
  String newsRecordScorerBody(String name, int goals) {
    return '$name กลายเป็นดาวซัลโวสูงสุดตลอดกาลของวงการด้วย $goals ประตู';
  }

  @override
  String get newsRecordCapsTitle => 'ผู้ติดทีมชาติมากที่สุด';

  @override
  String newsRecordCapsBody(String name, int caps) {
    return '$name กลายเป็นผู้ติดทีมชาติมากที่สุดของวงการด้วย $caps นัด';
  }

  @override
  String get newsARecordBreaker => 'เจ้าของสถิติคนใหม่';

  @override
  String newsTransferTitle(String name, String club) {
    return '$name ย้ายร่วม $club';
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
    return '$name ($position, $rating) ย้ายจาก $fromClub ไปร่วม $destination ด้วยค่าตัว $fee';
  }

  @override
  String newsTransferAbroad(String club, String country) {
    return '$club ใน $country';
  }

  @override
  String get newsTransferFree => 'ฟรี';

  @override
  String newsNatzStarTitle(String name, String nation) {
    return '$name พร้อมย้ายมาเล่นให้ $nation!';
  }

  @override
  String newsNatzTitle(String name, String nation) {
    return '$name อยากเล่นให้ $nation';
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
    return '$name $position วัย $age ปี ค่าพลัง $rating ปัจจุบันอยู่กับ $fromNation มีสายสัมพันธ์ทางครอบครัวกับ $nation และเปิดกว้างที่จะเปลี่ยน เปิดข้อเสนอโอนสัญชาติเพื่อตอบรับหรือปฏิเสธ';
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
    return '$name $position วัย $age ปี ค่าพลัง $rating ปัจจุบันอยู่กับ $fromNation เป็นนักเตะชื่อดังที่มีสายสัมพันธ์ทางครอบครัวกับ $nation และเปิดกว้างที่จะเปลี่ยน เปิดข้อเสนอโอนสัญชาติเพื่อตอบรับหรือปฏิเสธ';
  }

  @override
  String get newsTheirNation => 'ชาติของเขา';

  @override
  String get newsYourNation => 'ชาติของคุณ';

  @override
  String get tourStatusChampions => 'แชมป์';

  @override
  String get tourStatusFinals => 'รอบสุดท้าย';

  @override
  String get tourStatusQualifying => 'รอบคัดเลือก';

  @override
  String get tourStatusUpcoming => 'กำลังจะมา';

  @override
  String get tourStatusInProgress => 'กำลังแข่ง';

  @override
  String get tourStatusComingSoon => 'เร็วๆ นี้';

  @override
  String get tourStatusDecided => 'ได้ข้อสรุปแล้ว';

  @override
  String tourStatusLeague(String letter) {
    return 'ลีก $letter';
  }

  @override
  String get tourDrawWcQualifying => 'จับสลากคัดเลือกระดับโลก';

  @override
  String tourDrawContQualifying(String cup) {
    return 'จับสลากรอบคัดเลือก $cup';
  }

  @override
  String get tourDrawWcHost => 'เจ้าภาพชิงแชมป์โลก';

  @override
  String tourDrawContHost(String cup) {
    return 'เจ้าภาพ $cup';
  }

  @override
  String get tourDrawHostsReveal => 'และเจ้าภาพได้แก่…';

  @override
  String get tourDrawHostReveal => 'และเจ้าภาพคือ…';

  @override
  String get tourDrawHostCandidates => 'ผู้สมัครที่อยู่ในการแข่งขัน:';

  @override
  String get tourKickoffContinentalCup => 'ชิงแชมป์ทวีป';

  @override
  String tourHostCompetitionYear(String competition, int year) {
    return '$competition $year';
  }

  @override
  String newsContMissTitle(String cup) {
    return 'พลาด $cup';
  }

  @override
  String newsContMissBody(String cup) {
    return 'คุณไม่ผ่านเข้ารอบ $cup แคมเปญครั้งนี้ไปไม่ถึง';
  }

  @override
  String get potyLabelBest => 'นักเตะยอดเยี่ยมประจำปี';

  @override
  String get potyLabelYoung => 'ดาวรุ่งยอดเยี่ยมประจำปี';

  @override
  String potyTallyAssists(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count แอสซิสต์',
    );
    return '$_temp0';
  }

  @override
  String potyOverallValue(int value) {
    return 'ค่าพลัง $value';
  }

  @override
  String potyRatingValue(String value) {
    return 'เรตติ้ง $value';
  }

  @override
  String newsPotyTitle(int year) {
    return 'นักเตะยอดเยี่ยมของโลกประจำปี $year';
  }

  @override
  String newsPotyBody(String name) {
    return '$name คือนักเตะที่ดีที่สุดในโลกปีนี้';
  }

  @override
  String newsPotyYoungSuffix(String name) {
    return ' $name คว้ารางวัลดาวรุ่งยอดเยี่ยม';
  }

  @override
  String newsWatchTitle(int year) {
    return 'เด็กที่คุณติดตาม ปี $year';
  }

  @override
  String newsWatchJump(String name, int rating, int gain) {
    String _temp0 = intl.Intl.pluralLogic(
      gain,
      locale: localeName,
      other: '$gain แต้ม',
    );
    return '$name พัฒนาขึ้นสู่ $rating เพิ่มขึ้น $_temp0 จากปีที่แล้ว';
  }

  @override
  String newsWatchBand(String name, String band) {
    return '$name ขยับขึ้นสู่ระดับ $band';
  }

  @override
  String newsWatchDebutTitle(String name) {
    return '$name ประเดิมสนามทีมชาติ';
  }

  @override
  String newsWatchDebutBody(String name, int age, int rating) {
    return '$name ติดทีมชาติครั้งแรกในวัย $age ปี ค่าพลัง $rating หนึ่งในเด็กที่คุณติดตาม';
  }

  @override
  String get matchStatsAtFullTime =>
      'การครองบอล เรตติ้งผู้เล่น และแมนออฟเดอะแมตช์ จะสรุปเมื่อจบเกม';

  @override
  String get matchPlayerRatings => 'เรตติ้งผู้เล่น';

  @override
  String get matchSubstitutions => 'การเปลี่ยนตัว';

  @override
  String get matchSubstitutes => 'ตัวสำรอง';

  @override
  String get matchPlayerOfTheMatch => 'ผู้เล่นยอดเยี่ยมประจำเกม';

  @override
  String get matchGoalShout => 'ประตู!';

  @override
  String matchShootoutScore(int home, int away) {
    return 'ดวลจุดโทษ $home–$away';
  }

  @override
  String matchShootoutKickScored(String name) {
    return '$name: ยิงเข้า';
  }

  @override
  String matchShootoutKickMissed(String name) {
    return '$name: ยิงพลาด';
  }

  @override
  String get matchFeedKickOff => 'เริ่มเกม!';

  @override
  String get matchFeedNoEvents => 'ยังไม่มีเหตุการณ์';

  @override
  String get tourVenues => 'สนามแข่งขัน';

  @override
  String tourPot(int number) {
    return 'โถ $number';
  }

  @override
  String get tourHostSelection => 'การเลือกเจ้าภาพ';

  @override
  String get tourCandidates => 'ผู้สมัคร';

  @override
  String get tourJointBid => 'เสนอตัวร่วม';

  @override
  String get tourGoldenGlove => 'ถุงมือทองคำ';

  @override
  String get tourTeamOfTournament => 'ทีมยอดเยี่ยมทัวร์นาเมนต์';

  @override
  String get tourYourRun => 'เส้นทางของคุณ';

  @override
  String get tourMedalTable => 'ตารางเหรียญ';

  @override
  String tourHostLine(String nation) {
    return 'เจ้าภาพ: $nation';
  }

  @override
  String tourHostLineMulti(String hosts) {
    return 'เจ้าภาพ: $hosts';
  }

  @override
  String tourGroupNamed(String name) {
    return 'กลุ่ม $name';
  }

  @override
  String get tourFinalsDrawBlurb =>
      'จัดทีมวางตามอันดับโลก หาชาติของคุณก่อนการจับสลาก';

  @override
  String get tourWorldRanking => 'อันดับโลก';

  @override
  String get tourYourCompetitions => 'รายการของคุณ';

  @override
  String get tourOtherContinents => 'ทวีปอื่น';

  @override
  String get tourZoneGlobal => 'ทั่วโลก';

  @override
  String get tourZoneEurope => 'ยุโรป';

  @override
  String get tourZoneSouthAmerica => 'อเมริกาใต้';

  @override
  String get tourZoneNorthAmerica => 'อเมริกาเหนือ';

  @override
  String get tourZoneAfrica => 'แอฟริกา';

  @override
  String get tourZoneAsia => 'เอเชีย';

  @override
  String get tourZoneOceania => 'โอเชียเนีย';

  @override
  String get tourZoneIntercontinental => 'ข้ามทวีป';

  @override
  String tourZoneLeague(String league) {
    return 'ลีก $league';
  }

  @override
  String tourHostedBy(String hosts) {
    return 'เจ้าภาพ  $hosts';
  }

  @override
  String tourThirdsAdvance(int count, String destination) {
    return '$count อันดับแรกผ่านเข้าสู่$destination';
  }

  @override
  String newsWalkoutTitle(String name) {
    return '$name เดินจากไป';
  }

  @override
  String newsWalkoutBody(String name, int age, int caps) {
    return '$name อำลาทีมชาติในวัย $age ปี ด้วยการติดทีมชาติ $caps นัด เขาขอคำตอบว่าตัวเองอยู่ตรงไหนแต่ไม่ได้รับ และเขาจะไม่รออีกต่อไป';
  }

  @override
  String get pressHeadlineWent1 => 'กุนซือผู้คุมห้องแถลงข่าวได้อยู่หมัด';

  @override
  String get pressHeadlineWent2 => 'สื่อมาหาเรื่อง แต่กลับได้เจอผู้นำ';

  @override
  String get pressHeadlineWent3 => 'ตอบตรงไปตรงมา และได้ผล';

  @override
  String get pressHeadlineMixed1 => 'พูดเยอะ แต่ไม่ได้ข้อสรุป';

  @override
  String get pressHeadlineMixed2 => 'มีอะไรให้ทุกคน แต่ไม่มีอะไรให้ใครเลย';

  @override
  String get pressHeadlineMixed3 => 'แถลงข่าวที่ทิ้งคำถามไว้เต็มห้อง';

  @override
  String get pressHeadlineBadly1 => 'บ่ายอันบอบช้ำหน้ากล้อง';

  @override
  String get pressHeadlineBadly2 => 'ห้องแถลงข่าวพลิก และเห็นได้ชัด';

  @override
  String get pressHeadlineBadly3 => 'คำตอบที่พรุ่งนี้เช้าจะอ่านแล้วแย่กว่าเดิม';

  @override
  String get pressHeadlineFlat1 => 'ไม่พูดอะไร ก็ไม่ได้อะไร';

  @override
  String get pressHeadlineFlat2 => 'สิบนาที ไม่มีข่าว';

  @override
  String get pressHeadlineFlat3 => 'หน้ากีฬาว่างเปล่า';

  @override
  String get pressConferenceTitle => 'แถลงข่าว';

  @override
  String pressQuestionOf(int index, int total) {
    return 'คำถามที่ $index จาก $total';
  }

  @override
  String get pressTomorrowsHeadline => 'พาดหัวหน้ากีฬาพรุ่งนี้';

  @override
  String get pressLeaveRoom => 'ออกจากห้อง';

  @override
  String get pressRoomVerdictSquad => 'ห้องแต่งตัว';

  @override
  String get pressRoomVerdictBoard => 'บอร์ด';

  @override
  String get yReactionElation0 => 'ไม่มีอะไรจะติ ไม่มีเลย สมบูรณ์แบบ';

  @override
  String get yReactionElation1 => 'ผมไม่สบาย (ในทางที่ดี)';

  @override
  String get yReactionElation2 => 'จะใส่กรอบแขวนไว้เหนือเตาผิง';

  @override
  String get yReactionElation3 => 'เรากลับมาแล้ว';

  @override
  String get yReactionElation4 => 'แคปเก็บไว้ให้พวกขี้สงสัย ทุกคนเลย';

  @override
  String get yReactionElation5 => 'จากนี้ไปสิบปี ผมจะคุยโวเรื่องนี้จนน่ารำคาญ';

  @override
  String get yReactionElation6 => 'ใช่ นี่แหละเหตุผลที่เราดูบอล';

  @override
  String get yReactionElation7 => 'วันแบบนี้คุ้มกับวันแย่ๆ ทั้งหมด';

  @override
  String get yReactionElation8 => 'ซะที จริงๆ นะ ซะที';

  @override
  String get yReactionElation9 => 'เยี่ยม ทำอีกทีสัปดาห์หน้าแล้วผมจะเชื่อ';

  @override
  String get yReactionElation10 =>
      'สนุกให้เต็มที่คืนนี้ เพราะพวกนี้จะหาทางทำพังจนได้';

  @override
  String get yReactionElation11 =>
      'คืนดีๆ คืนเดียวไม่ได้ทำให้ใครกลายเป็นทีมยอดเยี่ยม';

  @override
  String get yReactionRelief0 => 'ไม่สวย แต่เอาทุกครั้ง';

  @override
  String get yReactionRelief1 => 'ยังไงก็ไม่รู้ ยังไงก็ไม่รู้!';

  @override
  String get yReactionRelief2 => 'น่าเกลียด สามแต้ม ไปต่อ';

  @override
  String get yReactionRelief3 => 'น่าเกลียดแค่ไหนก็เอา ขอแค่ได้แต้ม';

  @override
  String get yReactionRelief4 => 'อายุสั้นลงไปสิบปี';

  @override
  String get yReactionRelief5 => 'อย่าเพิ่งพูดอะไร อย่าแช่ง';

  @override
  String get yReactionRelief6 => 'อัตราการเต้นของหัวใจ: รับไม่ได้';

  @override
  String get yReactionRelief7 => 'รอดมาได้ นั่นแหละคำที่ใช่ รอด';

  @override
  String get yReactionRelief8 => 'เราไม่ควรต้องโล่งอกกับเกมแบบนั้น';

  @override
  String get yReactionRelief9 => 'โล่งอก และอายนิดๆ ที่โล่งอก';

  @override
  String get yReactionRelief10 =>
      'ถ้านั่นคือมาตรฐานที่เราเชียร์กันอยู่ เราลำบากแล้ว';

  @override
  String get yReactionRelief11 =>
      'ผ่านมาแบบเฉียดฉิวจนเป็นนิสัย และไม่ใช่นิสัยที่ดี';

  @override
  String get yReactionFury0 => 'ไม่ดีพอ ห่างไกลเลย';

  @override
  String get yReactionFury1 => 'ใครก็ได้อธิบายให้ฟังช้าๆ ที';

  @override
  String get yReactionFury2 => 'ดูยากมาก และนี่พูดแบบสุภาพแล้ว';

  @override
  String get yReactionFury3 => 'ผิดหวัง ผิดหวังจริงๆ';

  @override
  String get yReactionFury4 => 'สภาพ';

  @override
  String get yReactionFury5 => 'ขอรายชื่อ';

  @override
  String get yReactionFury6 => 'ลบแอปแล้ว วันพฤหัสค่อยลงใหม่';

  @override
  String get yReactionFury7 => 'ไม่มีใครในสนามดูอยากได้มันเลย';

  @override
  String get yReactionFury8 => 'ทุกสี่ปี เหมือนเดิม ทุกสี่ปี';

  @override
  String get yReactionFury9 => 'นั่นไม่ใช่การเล่น มันคือการดูถูก';

  @override
  String get yReactionFury10 => 'คนสละวันหยุดและเงินเพื่อมาดูสิ่งนั้น คิดดูสิ';

  @override
  String get yReactionFury11 =>
      'ผมปกป้องทีมนี้มาหลายปี แต่ไม่ใช่คืนนี้ ไม่ใช่หลังจากนั้น';

  @override
  String get yReactionDespair0 => 'เอาเถอะ';

  @override
  String get yReactionDespair1 => 'วันนี้ไม่มีมุก ไม่มีอะไรทั้งนั้น';

  @override
  String get yReactionDespair2 => 'ขอไปเดินเล่น นานๆ หน่อย';

  @override
  String get yReactionDespair3 => 'หมดคำจะพูดแล้ว';

  @override
  String get yReactionDespair4 => 'ปลุกผมอีกทีสี่ปีข้างหน้า';

  @override
  String get yReactionDespair5 => 'นี่คือไทม์ไลน์ที่มืดมนที่สุด';

  @override
  String get yReactionDespair6 => 'ไม่โกรธแล้วด้วยซ้ำ นั่นแหละที่น่ากังวล';

  @override
  String get yReactionDespair7 => 'อันนี้จะเจ็บไปอีกนาน';

  @override
  String get yReactionDespair8 =>
      'ไม่รู้แล้วว่านี่คืออะไร แต่ไม่ใช่ทีมฟุตบอลแน่ๆ';

  @override
  String get yReactionDespair9 => 'เราห่างไกลกว่าเดิม และไม่มีใครยอมพูด';

  @override
  String get yReactionDespair10 =>
      'เสียไปทั้งรุ่น แล้วคนกลุ่มเดิมก็ตัดสินว่าจะเอายังไงต่อ';

  @override
  String get yReactionDespair11 =>
      'เลิกบอกว่ามันคือกระบวนการได้แล้ว มันไม่ได้ไปไหนเลย';

  @override
  String get yReactionSmugness0 => 'เบาๆ นะ แต่: บอกแล้ว';

  @override
  String get yReactionSmugness1 => 'บุ๊กมาร์กไว้เลย';

  @override
  String get yReactionSmugness2 => 'พวกขี้สงสัยเงียบกริบเลย';

  @override
  String get yReactionSmugness3 => 'ไม่ได้มีใครนับหรอก ผมนับอยู่';

  @override
  String get yReactionSmugness4 => 'พูดไว้ตั้งแต่มกราคม ไปดูไทม์ไลน์ได้';

  @override
  String get yReactionSmugness5 => 'บางคนติดคำขอโทษบางคนอยู่นะ';

  @override
  String get yReactionSmugness6 => 'เก็บไว้ในแฟ้มเรื่องที่ผมพูดก่อน';

  @override
  String get yReactionSmugness7 => 'ไม่สะใจ สะใจนิดหน่อย';

  @override
  String get yReactionSmugness8 => 'ผู้เชี่ยวชาญทั้งหลายไปไหนหมด ถามจริง';

  @override
  String get yReactionSmugness9 => 'อยากให้ทุกคนพูดตามผมอีกที';

  @override
  String get yReactionSmugness10 =>
      'แคป ปริ้นต์ ใส่กรอบ ส่งให้คนที่หัวเราะเยาะ';

  @override
  String get yReactionSmugness11 =>
      'ผมจะยกเรื่องนี้ขึ้นมาพูดไปตลอดชีวิต และพวกคุณสมควรโดน';

  @override
  String get yReactionShrug0 => 'มันเกิดขึ้นแล้ว ต่อไป';

  @override
  String get yReactionShrug1 => 'ก็ได้ ช่างมัน เดินหน้า';

  @override
  String get yReactionShrug2 => 'เก็บอันนี้ไว้ในหมวด \'ฟุตบอล\'';

  @override
  String get yReactionShrug3 => 'ไม่มีอะไรจะเพิ่มจริงๆ';

  @override
  String get yReactionShrug4 => 'ไม่มีความคิด หัวว่างเปล่า';

  @override
  String get yReactionShrug5 => 'ปลุกผมตอนนัดหน้า';

  @override
  String get yReactionShrug6 => 'เก้าสิบนาทีที่ไม่มีวันได้คืน';

  @override
  String get yReactionShrug7 => 'ไม่ดีไม่ร้าย จริงๆ';

  @override
  String get yReactionShrug8 => 'บอกไม่ได้เลยสักอย่างว่าเกิดอะไรขึ้น';

  @override
  String get yReactionShrug9 => 'อีกนัดแบบนั้น มีแบบนั้นเยอะมาก';

  @override
  String get yReactionShrug10 => 'ดูจนจบแต่ไม่รู้สึกอะไรเลย';

  @override
  String get yReactionShrug11 => 'ถ้าไม่มีใครพูดถึงเรื่องนี้อีก ผมก็โอเค';

  @override
  String get tourThirdsUneven =>
      'กลุ่มมีจำนวนทีมไม่เท่ากัน จึงตัดผลการแข่งขันกับทีมท้ายตารางของกลุ่มใหญ่ออก เพื่อให้ทุกทีมถูกตัดสินจากจำนวนนัดเท่ากัน';

  @override
  String get careerExportSave => 'สำรองเซฟนี้';

  @override
  String get careerBackupAll => 'สำรองเซฟทั้งหมด';

  @override
  String get careerBackupAllFailed => 'เขียนไฟล์สำรองไม่ได้';

  @override
  String get backupTitle => 'การสำรองข้อมูล';

  @override
  String get backupBlurb =>
      'เซฟทั้งหมดอยู่ในไฟล์เดียวบนโทรศัพท์เครื่องนี้ และไม่มีการสำรองเองจนกว่าคุณจะเปิดการสำรองอัตโนมัติด้านล่าง เก็บสำเนาไว้บนคลาวด์ เพื่อไม่ให้โทรศัพท์หายหรือแอปถูกลบทำให้อาชีพของคุณหายไป';

  @override
  String get backupBlurbNoAuto =>
      'เซฟทั้งหมดอยู่ในไฟล์เดียวบนโทรศัพท์เครื่องนี้ และไม่มีการสำรองเองโดยอัตโนมัติ เก็บสำเนาไว้บนคลาวด์ เพื่อไม่ให้โทรศัพท์หายหรือแอปถูกลบทำให้อาชีพของคุณหายไป';

  @override
  String get backupExport => 'สำรองขึ้นคลาวด์';

  @override
  String get backupExportSubject => 'เซฟ FNM';

  @override
  String get backupRestore => 'กู้คืนจากไฟล์';

  @override
  String get backupRestoreWarnTitle => 'แทนที่เซฟทั้งหมด?';

  @override
  String get backupRestoreWarnBody =>
      'การกู้คืนจะแทนที่เซฟทั้งหมดบนโทรศัพท์เครื่องนี้ด้วยเซฟในไฟล์ แอปจะรีสตาร์ต';

  @override
  String get backupRestoreConfirm => 'แทนที่';

  @override
  String get backupCancel => 'ยกเลิก';

  @override
  String get backupExported => 'ไฟล์สำรองพร้อมแล้ว เลือกที่จัดเก็บ';

  @override
  String get backupFailed => 'เขียนไฟล์สำรองไม่ได้';

  @override
  String get backupRejectedUnreadable => 'เปิดไฟล์นั้นไม่ได้';

  @override
  String get backupRejectedNotFnm => 'นั่นไม่ใช่เซฟของ FNM';

  @override
  String get backupRejectedNewer =>
      'เซฟนั้นสร้างจากแอปเวอร์ชันใหม่กว่า อัปเดตแอปก่อน';

  @override
  String get backupRejectedTooOld =>
      'เซฟนั้นเก่าเกินกว่าที่เวอร์ชันนี้จะกู้คืนได้';

  @override
  String get careerShare => 'แชร์อาชีพนี้';

  @override
  String get careerImport => 'นำเข้าอาชีพ';

  @override
  String get careerShareSubject => 'อาชีพ FNM';

  @override
  String get careerImported => 'นำเข้าอาชีพแล้ว';

  @override
  String get careerImportFailedUnreadable => 'ไฟล์นั้นไม่ใช่อาชีพของ FNM';

  @override
  String get careerImportFailedNewer =>
      'อาชีพนั้นส่งออกจากแอปเวอร์ชันใหม่กว่า อัปเดตแอปก่อน';

  @override
  String get careerImportFailedSlotsFull =>
      'ช่องเซฟเต็มหมดแล้ว ลบเซฟเพื่อเพิ่มที่ว่าง หรือปลดล็อกเซฟไม่จำกัด';

  @override
  String get careerImportFailedNeedsPremium =>
      'อาชีพนั้นเลยรอบแรกที่เล่นฟรีไปแล้ว ปลดล็อกเกมเต็มเพื่อนำเข้า';

  @override
  String get careerImportFailedCampaignRun =>
      'แคมเปญนั้นมีการเล่นค้างอยู่ เล่นต่อหรือยกเลิกก่อน';

  @override
  String get careerShareFailed => 'ส่งออกอาชีพนั้นไม่ได้';

  @override
  String get managerRename => 'เปลี่ยนชื่อ';

  @override
  String get managerRenameSave => 'บันทึก';

  @override
  String get managerTitle => 'ผู้จัดการทีม';

  @override
  String get managerSkills => 'ทักษะของคุณ';

  @override
  String managerPointsAvailable(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'มี $count แต้มให้ใช้',
      zero: 'ไม่มีแต้มให้ใช้',
    );
    return '$_temp0';
  }

  @override
  String get managerPointsHow =>
      'ได้สองแต้มทุกรอบที่จบ และหนึ่งแต้มทุกถ้วยที่คว้าได้';

  @override
  String get managerSkillsScale =>
      'ทุกทักษะเริ่มที่ 5 และสูงสุดที่ 20 แต้มที่ใช้ไปแล้วเป็นการถาวร';

  @override
  String get managerSkillManManagement => 'การบริหารคน';

  @override
  String get managerSkillManManagementBlurb =>
      'แต่ละแต้มทำให้สิ่งที่คุณพูดกับสื่อและนักเตะมีผลในห้องแต่งตัวมากขึ้น 3%';

  @override
  String get managerSkillTactical => 'แทคติก';

  @override
  String get managerSkillTacticalBlurb =>
      'แต่ละแต้มทำให้แผนการเล่นใหม่เข้าที่เร็วขึ้น 3% การเปลี่ยนแผนจึงเสียนัดน้อยลง';

  @override
  String get managerSkillYouth => 'การพัฒนาเยาวชน';

  @override
  String get managerSkillYouthBlurb =>
      'แต่ละแต้มเพิ่มพรสวรรค์ของเด็กจากอะคาเดมี 1% นอกเหนือจากงบที่คุณลงไป';

  @override
  String get managerSkillNegotiation => 'การเจรจา';

  @override
  String get managerSkillNegotiationBlurb =>
      'แต่ละแต้มได้เงินจากสมาคมเพิ่มขึ้น 2% ทุกรอบ';

  @override
  String get managerStaff => 'สตาฟฟ์ของคุณ';

  @override
  String managerStaffWages(String amount) {
    return 'ค่าจ้าง: $amount ต่อรอบ';
  }

  @override
  String get managerRoleAssistant => 'ผู้ช่วยผู้จัดการทีม';

  @override
  String get managerRoleAssistantBlurb =>
      'ดูแลการซ้อม: บาดเจ็บน้อยลง และเด็กที่ขึ้นมาดีขึ้น';

  @override
  String get managerRoleScout => 'หัวหน้าแมวมอง';

  @override
  String get managerRoleScoutBlurb =>
      'อ่านดาวรุ่งและคู่แข่งนัดถัดไป: ระดับดาวแม่นยำขึ้น และได้เปรียบในวันแข่ง';

  @override
  String get managerRoleFitness => 'โค้ชฟิตเนส';

  @override
  String get managerRoleFitnessBlurb => 'ทำให้นักเตะอยู่ในสนามได้';

  @override
  String staffEffectInjury(int percent) {
    return 'บาดเจ็บลดลง $percent%';
  }

  @override
  String staffEffectYouth(int points) {
    return 'เด็กๆ ค่าพลังรวม +$points';
  }

  @override
  String staffHiringInjury(int min, int max) {
    return 'ถ้าจ้าง: บาดเจ็บลดลง $min% ถึง $max%';
  }

  @override
  String staffHiringYouth(int minPoints, int maxPoints) {
    return 'และเด็กๆ ค่าพลังรวม +$minPoints ถึง +$maxPoints';
  }

  @override
  String staffEffectScoutRead(int percent) {
    return 'อ่านดาวรุ่งได้แม่นยำ $percent%';
  }

  @override
  String staffEffectScoutCaps(int caps) {
    String _temp0 = intl.Intl.pluralLogic(
      caps,
      locale: localeName,
      other: 'รู้ศักยภาพหลังติดทีมชาติ $caps นัด',
      one: 'รู้ศักยภาพหลังติดทีมชาติ 1 นัด',
    );
    return '$_temp0';
  }

  @override
  String staffEffectScoutDossier(int points) {
    return 'ค่าพลัง +$points จากรายงานคู่แข่ง';
  }

  @override
  String staffHiringScoutRead(int min, int max) {
    return 'ถ้าจ้าง: อ่านแม่นยำ $min% ถึง $max%';
  }

  @override
  String staffHiringScoutCaps(int minCaps, int maxCaps) {
    return 'และรู้ศักยภาพเร็วขึ้น $minCaps ถึง $maxCaps นัด';
  }

  @override
  String staffHiringScoutDossier(int minPoints, int maxPoints) {
    return 'และค่าพลัง +$minPoints ถึง +$maxPoints ทุกนัด';
  }

  @override
  String get staffEffectNone => 'ยังไม่มีผลต่อทีมของคุณ';

  @override
  String get staffVacant => 'ตำแหน่งว่าง';

  @override
  String get staffLeaveVacant => 'ปล่อยตำแหน่งว่างไว้';

  @override
  String get managerTierNone => 'ไม่มี';

  @override
  String get managerTierBasic => 'พื้นฐาน';

  @override
  String get managerTierGood => 'ดี';

  @override
  String get managerTierElite => 'ชั้นยอด';

  @override
  String get managerFree => 'ฟรี';

  @override
  String get managerTraining => 'ระหว่างช่วงเกมทีมชาติ';

  @override
  String get managerTrainingBlurb => 'สิ่งที่ทีมฝึกเมื่อไม่มีเกมให้เล่น';

  @override
  String get managerFocusBalanced => 'สมดุล';

  @override
  String get managerFocusBalancedBlurb => 'ทุกอย่างนิดหน่อย';

  @override
  String get managerFocusFitness => 'ฟิตเนส';

  @override
  String get managerFocusFitnessBlurb => 'บาดเจ็บน้อยลง';

  @override
  String get managerFocusCohesion => 'ความเข้าขา';

  @override
  String get managerFocusCohesionBlurb => 'แผนการเล่นเข้าที่เร็วขึ้น';

  @override
  String get managerFocusYouth => 'เยาวชน';

  @override
  String get managerFocusYouthBlurb => 'ใช้เวลากับผู้เล่นอายุน้อยที่สุด';

  @override
  String get tourOfferTitle => 'มาที่นี่ครั้งแรก?';

  @override
  String get tourOfferBody =>
      'นี่คือเกมใหญ่ อยากให้พาชมหน้าจอสำคัญสั้นๆ ไหม? ใช้เวลาแค่นาทีเดียว และเริ่มใหม่ได้ทุกเมื่อจากการตั้งค่า';

  @override
  String get tourOfferYes => 'พาชมเลย';

  @override
  String get tourOfferNo => 'ไม่ ขอบคุณ';

  @override
  String get tourBack => 'กลับ';

  @override
  String get tourNext => 'ถัดไป';

  @override
  String get tourDone => 'เสร็จ';

  @override
  String get tourSkip => 'ข้าม';

  @override
  String get tourHubTitle => 'นี่คือทั้งเกม';

  @override
  String get tourHubBody =>
      'ปุ่มเดียวที่เปลี่ยนไปตามรอบ: การจับสลากให้ชม ทีมชุดให้เลือก เกมให้เล่น ด้านบนคือความเชื่อมั่นของบอร์ดที่มีต่อคุณและเป้าหมายที่บอร์ดตั้งไว้';

  @override
  String get tourBudgetTitle => 'เงินของสมาคม';

  @override
  String get tourBudgetBody =>
      'ทุกรอบสี่ปี คุณแบ่งงบประมาณให้แต่ละฝ่าย ค่าจ้างสตาฟฟ์จ่ายจากงบนี้ก่อน การจ้างแมวมองชั้นยอดจึงเป็นการตัดสินใจที่แลกกับอะคาเดมี ไม่ใช่ควบคู่กัน';

  @override
  String get tourTacticsTitle => 'ทีมเล่นอย่างไร';

  @override
  String get tourTacticsBody =>
      'แผนการเล่น สไตล์การเล่น กัปตัน และผู้เตะลูกตั้งเตะ ถ้าไม่กำหนดสองอย่างหลัง เกมจะเตือนคุณก่อนเริ่มเกม แทนที่จะเลือกให้แบบเงียบๆ';

  @override
  String get tourSquadTitle => 'ทุกคนที่คุณเลือกได้';

  @override
  String get tourSquadBody =>
      'ตัวเลือกทั้งหมด ไม่ใช่แค่ทีมชุด: ใครฟอร์มดี ใครมีอาการเจ็บ ใครติดแบน และใครเพิ่งขึ้นมาจากอะคาเดมี';

  @override
  String get tourCallUpsTitle => 'การเรียกตัว';

  @override
  String get tourCallUpsBody =>
      'คุณเรียกตัวหนึ่งชุดต่อช่วงเกมทีมชาติ และชุดนั้นเล่นทุกนัดในช่วงนั้น เหมือนผู้จัดการทีมตัวจริง ถ้ามีคนเจ็บระหว่างช่วงนั้น จะมีการเรียกตัวแทนให้คุณ';

  @override
  String get tourRecordsTitle => 'อาชีพของคุณ';

  @override
  String get tourRecordsBody =>
      'ทุกสิ่งที่คุณทำมา: เกมการแข่งขัน สถิติทีม ถ้วยรางวัล และทุกชาติที่คุณเคยคุม';

  @override
  String get tourCupsTitle => 'ส่วนที่เหลือของโลก';

  @override
  String get tourCupsBody =>
      'ทุกรายการที่กำลังแข่งอยู่: กลุ่ม ตารางคะแนน และรอบน็อกเอาต์ รวมถึงรายการที่คุณไม่ได้ร่วม โลกยังคงแข่งต่อไม่ว่าคุณจะผ่านเข้ารอบหรือไม่';

  @override
  String get settingsTourTitle => 'ดูบทแนะนำอีกครั้ง';

  @override
  String get settingsTourBlurb => 'ชมหน้าจอสำคัญอีกครั้งตั้งแต่ต้น';

  @override
  String get tourBoardTitle => 'คนที่คุณต้องรายงาน';

  @override
  String get tourBoardBody =>
      'ความเชื่อมั่นของบอร์ดที่มีต่อคุณ และเป้าหมายที่ตั้งไว้สำหรับรอบนี้ ถ้าทำไม่ได้ตามเป้า คุณจะเห็นสัญญาณที่นี่';

  @override
  String get tourStaffTitle => 'คนรอบตัวคุณ';

  @override
  String get tourStaffBody =>
      'ผู้ช่วย แมวมอง และโค้ชฟิตเนส จ้างเป็นรายบุคคล ค่าจ้างของพวกเขาหักจากงบนี้ก่อนแบ่งให้ฝ่ายต่างๆ แมวมองเก่งๆ จึงเป็นการตัดสินใจที่แลกกับอะคาเดมี';

  @override
  String get tourPlaystyleTitle => 'สไตล์การเล่นของคุณ';

  @override
  String get tourPlaystyleBody =>
      'แผนการเล่นเป็นแค่ครึ่งหนึ่งของแทคติก นี่คืออีกครึ่ง: เพรสสูงแค่ไหน ไดเร็กต์แค่ไหน เสี่ยงมากแค่ไหน';

  @override
  String get settingsTourNoSave =>
      'เริ่มอาชีพก่อน บทแนะนำจะพาชมหน้าจอของคุณเอง';

  @override
  String tacticsOutOfPositionAge(int age) {
    return 'ผิดตำแหน่ง · อายุ $age';
  }

  @override
  String get federationNextCycleLocked =>
      'งบประมาณของรอบถัดไปจะกำหนดครั้งเดียวตอนเริ่มรอบนั้น จนกว่าจะถึงตอนนั้น นี่คือสิ่งที่เงินของคุณกำลังทำอยู่';

  @override
  String get federationBudgetAlreadySet => 'กำหนดสำหรับรอบนี้แล้ว';

  @override
  String yFinalLooms0(String opponent) {
    return 'นัดใหญ่เจอ $opponent ทั้งสัปดาห์นี้ทุกคนจะพูดถึงแต่เรื่องนี้';
  }

  @override
  String yFinalLooms1(String opponent) {
    return 'ยืนยันแล้ว: $opponent ขวางเราอยู่ รอมาสี่ปีเพื่อสิ่งนี้';
  }

  @override
  String yFinalLooms2(String opponent) {
    return 'เอาล่ะ $opponent ไม่มีใครได้นอนจนกว่าจะจบ';
  }

  @override
  String yFinalLooms3(String opponent) {
    return 'ต่อไปคือ $opponent อย่างอื่นรอไปก่อน สัปดาห์ที่คุ้มค่าแก่การมีชีวิตอยู่';
  }

  @override
  String get matchSetupLeaveToCoach => 'ให้โค้ชเลือกผู้เตะ';

  @override
  String friendliesLikeYourGroup(String rivals) {
    return 'ทำเครื่องหมายด้านล่าง: ทีมที่เล่นคล้าย $rivals ซึ่งคุณจะเจอในกลุ่มรอบนี้';
  }

  @override
  String newsTransferWindowTitle(int year) {
    return 'ตลาดซื้อขาย · $year';
  }

  @override
  String careerLastAgo(String when) {
    return 'ล่าสุด $when ที่แล้ว';
  }

  @override
  String get settingsFreeScopeTitle => 'ฟรีหนึ่งรอบสี่ปี';

  @override
  String get settingsFreeScopeBlurb =>
      'หนึ่งรอบเต็ม (รอบคัดเลือก ชิงแชมป์ทวีปของคุณ และชิงแชมป์โลก) ได้ 2 เซฟ ทุกชาติทั่วโลก ไม่มีกั๊ก รอบไม่จำกัดและเซฟไม่จำกัดจ่ายครั้งเดียว และครอบคลุมทุกอัปเดตในอนาคต';

  @override
  String get settingsUnlockedTitle => 'ปลดล็อกแล้ว';

  @override
  String get settingsUnlockedBlurb =>
      'รอบไม่จำกัด เซฟไม่จำกัด และทุกอัปเดตในอนาคต ขอบคุณ';

  @override
  String get settingsFromDeveloperTitle => 'จากผู้พัฒนา';

  @override
  String get settingsFromDeveloperBlurb =>
      'Football Nations Manager สร้างโดยคนคนเดียว และจะได้รับการดูแลในระยะยาว จะไม่มีโฆษณาหรือไมโครทรานแซกชันเด็ดขาด ถ้าคุณชอบเกมนี้ โปรดพิจารณาซื้อเวอร์ชันเต็ม นั่นคือสิ่งที่ทำให้อัปเดตยังคงมาเรื่อยๆ';

  @override
  String get settingsFromDeveloperThanksBlurb =>
      'Football Nations Manager สร้างโดยคนคนเดียว และจะได้รับการดูแลในระยะยาว จะไม่มีโฆษณาหรือไมโครทรานแซกชันเด็ดขาด ขอบคุณที่ซื้อเวอร์ชันเต็ม นั่นคือสิ่งที่ทำให้อัปเดตยังคงมาเรื่อยๆ';

  @override
  String friendliesLikeYourCampaign(String rivals) {
    return 'ทำเครื่องหมายด้านล่าง: ทีมที่เล่นคล้าย $rivals ซึ่งคุณยังต้องเจอ';
  }

  @override
  String get friendliesCloseToYou =>
      'ทำเครื่องหมายด้านล่าง: ทีมที่อันดับโลกใกล้คุณที่สุด เมื่อจับสลากแล้ว เครื่องหมายจะเปลี่ยนตามกลุ่มของคุณ';

  @override
  String transfersMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count รายการ',
      one: '1 รายการ',
    );
    return '$_temp0';
  }

  @override
  String hubRoundPage(int page, int pages) {
    return '$page / $pages';
  }

  @override
  String get transfersNewer => 'ใหม่กว่า';

  @override
  String get transfersOlder => 'เพิ่มเติม';

  @override
  String get transfersPagePrevious => 'ก่อนหน้า';

  @override
  String get transfersPageNext => 'ถัดไป';

  @override
  String transfersPageOf(int page, int pages) {
    return 'หน้า $page จาก $pages';
  }

  @override
  String get transfersMovedTo => 'ย้ายไป';

  @override
  String get transfersUnknownClub => 'ไม่ทราบสโมสร';

  @override
  String yAgainstThemAgain0(String opponent, String count) {
    return 'เจอ $opponent มา $count ครั้งแล้ว มีคนนับคะแนนอยู่ และนั่นคือพวกเขา';
  }

  @override
  String yAgainstThemAgain1(String opponent, String count) {
    return '$opponent อีกแล้ว พบกัน $count ครั้ง และเรายังหาทางแก้ไม่ได้';
  }

  @override
  String yAgainstThemAgain2(String opponent, String count) {
    return 'ครั้งที่ $count กับ $opponent นี่ไม่ใช่เรื่องบังเอิญแล้ว';
  }

  @override
  String yAgainstThemAgain3(String opponent, String count) {
    return 'เราเจอ $opponent มา $count ครั้ง และไม่ได้เรียนรู้อะไรเลยสักครั้ง';
  }

  @override
  String yAgainstThemAgain4(String opponent, String count) {
    return '$opponent $count ครั้ง พวกเขารู้ทุกอย่างว่าเราจะทำอะไร';
  }

  @override
  String yAgainstThemAgain5(String opponent, String count) {
    return 'ไม่ว่า $opponent จะมีอะไรเหนือเรา ผ่านไป $count นัด พวกเขาก็ยังมีอยู่';
  }

  @override
  String ySameOldStory0(String count) {
    return 'นี่คือครั้งที่ $count ที่เกิดขึ้นช่วงนี้ ถึงจุดไหนที่มันจะกลายเป็นตัวตนของเรา?';
  }

  @override
  String ySameOldStory1(String count) {
    return 'บ่ายแบบนี้ $count ครั้งแล้ว นี่คือรูปแบบ ไม่ใช่ดวง';
  }

  @override
  String ySameOldStory2(String count) {
    return 'เราเห็นเกมแบบนี้เป๊ะๆ มา $count ครั้งช่วงนี้ บทเดิม ตอนจบเดิม';
  }

  @override
  String ySameOldStory3(String count) {
    return 'เก้าสิบนาทีเดิมๆ $count เวอร์ชันแล้ว ไม่มีใครแก้';
  }

  @override
  String ySameOldStory4(String count) {
    return '$count ครั้ง ถ้าตอนนี้ยังไม่เห็นรูปแบบ แปลว่าไม่ได้มอง';
  }

  @override
  String ySameOldStory5(String count) {
    return 'เรื่องเดิม $count ครั้ง ข้ออ้างหมดก่อนผลงานจะมาเสียอีก';
  }

  @override
  String get yToldYouSo0 => 'ผมบอกแล้วว่ามันจะมา ตอนที่ทุกคนยุ่งอยู่กับการฉลอง';

  @override
  String get yToldYouSo1 =>
      'ดีสองสัปดาห์ก็กลายเป็นยุคทองอีกแล้ว และนี่คือที่ที่เราอยู่';

  @override
  String get yToldYouSo2 =>
      'คนที่บอกให้ผมสนุกไปกับมันเมื่อเดือนที่แล้วเงียบไปหมด';

  @override
  String get yToldYouSo3 => 'ผมไม่ได้สะใจเลย น้อยมาก มีบ้าง';

  @override
  String get yToldYouSo4 => 'มันไม่เคยดีอย่างที่เขาบอก และนี่คือหลักฐาน';

  @override
  String get yToldYouSo5 =>
      'ทุกครั้ง เราถูกบอกว่าครั้งนี้ต่างออกไป และทุกครั้งก็ไม่ใช่';

  @override
  String get tacticsSubOffAlready => 'เปลี่ยนออกแล้ว';

  @override
  String get tacticsSubInjured => 'บาดเจ็บ';

  @override
  String get tacticsSubSentOffMark => 'โดนไล่ออก';

  @override
  String get tacticsSubNoneLeft => 'เปลี่ยนตัวครบแล้ว';

  @override
  String get tacticsUndoLastChange => 'ยกเลิกการเปลี่ยนล่าสุด';

  @override
  String get matchStrengthTitle => 'ปัจจัยที่มีผลต่อทีม';

  @override
  String get strengthFactorFamiliarity => 'ความคุ้นเคยกับแผน';

  @override
  String get strengthFactorFatigue => 'ความเหนื่อยล้า';

  @override
  String get strengthFactorClubForm => 'ฟอร์มกับสโมสร';

  @override
  String get strengthFactorMorale => 'ห้องแต่งตัว';

  @override
  String get strengthFactorCaptain => 'กัปตัน';

  @override
  String get strengthFactorStaff => 'ทีมสตาฟฟ์';

  @override
  String get strengthFactorDossier => 'รายงานแมวมอง';

  @override
  String yDebut0(String name) {
    return '$name ติดทีมชาติครั้งแรก จำชื่อนี้ไว้';
  }

  @override
  String yDebut1(String name) {
    return 'ประเดิมสนามของ $name เห็นแววใช่ไหมล่ะ?';
  }

  @override
  String yDebut2(String name) {
    return '$name ติดทีมชาติครั้งแรก มาดูกันว่าเขาจะทำอะไรได้';
  }

  @override
  String yDebut3(String name) {
    return 'ประเดิมสนามของ $name ทีมต้องการขาสดๆ บ้าง';
  }

  @override
  String yDebut4(String name) {
    return '$name ได้ติดทีมชาติ ช่วงนี้เราแจกไปเยอะมาก';
  }

  @override
  String yDebut5(String name) {
    return 'ประเดิมสนามของ $name อีกคนที่เราจะลืมก่อนถึงฤดูใบไม้ผลิ';
  }

  @override
  String yDrought0(String name, String count) {
    return '$name ยิงไม่ได้มา $count นัด แต่ทำทุกอย่างอื่นในสนาม';
  }

  @override
  String yDrought1(String name, String count) {
    return '$name ยิงไม่ได้ $count นัด เดี๋ยวก็มาเป็นชุด เป็นแบบนี้ตลอด';
  }

  @override
  String yDrought2(String name, String count) {
    return '$name: $count นัด ไม่มีประตู';
  }

  @override
  String yDrought3(String name, String count) {
    return '$name ยิงไม่ได้ $count นัด น่าจับตามอง';
  }

  @override
  String yDrought4(String name, String count) {
    return '$count นัด ไม่มีประตู $name ยิงประตูโรงนาก็ยังไม่เข้า';
  }

  @override
  String yDrought5(String name, String count) {
    return '$name ยิงไม่ได้มา $count นัด ส่งใครลงก็ได้แทน';
  }

  @override
  String yRivalryLooms0(String opponent, String count) {
    return 'ต่อไปคือ $opponent พบกัน $count ครั้งแล้ว และยังมีความหมายทุกอย่าง';
  }

  @override
  String yRivalryLooms1(String opponent, String count) {
    return 'เจอ $opponent มา $count ครั้งแล้ว เข้ามาเลย';
  }

  @override
  String yRivalryLooms2(String opponent, String count) {
    return 'ต่อไปคือ $opponent เจอกันมาแล้ว $count ครั้ง';
  }

  @override
  String yRivalryLooms3(String opponent, String count) {
    return 'การพบกันครั้งที่ $count กับ $opponent สัปดาห์นี้';
  }

  @override
  String yRivalryLooms4(String opponent, String count) {
    return '$opponent อีกแล้ว $count ครั้ง และเราไม่ได้เรียนรู้อะไรเลย';
  }

  @override
  String yRivalryLooms5(String opponent, String count) {
    return 'เจอ $opponent มา $count นัด และพวกเขายังชนะเราอยู่ ยอดเยี่ยม';
  }

  @override
  String get positionGoalkeeper => 'ผู้รักษาประตู';

  @override
  String get positionLeftBack => 'แบ็กซ้าย';

  @override
  String get positionCentreBack => 'เซ็นเตอร์แบ็ก';

  @override
  String get positionRightBack => 'แบ็กขวา';

  @override
  String get positionDefensiveMid => 'กองกลางตัวรับ';

  @override
  String get positionCentralMid => 'กองกลางตัวกลาง';

  @override
  String get positionAttackingMid => 'กองกลางตัวรุก';

  @override
  String get positionLeftMid => 'กองกลางซ้าย';

  @override
  String get positionRightMid => 'กองกลางขวา';

  @override
  String get positionLeftWing => 'ปีกซ้าย';

  @override
  String get positionRightWing => 'ปีกขวา';

  @override
  String get positionStriker => 'กองหน้าตัวเป้า';

  @override
  String get roleNone => 'ไม่มีบทบาท';

  @override
  String get roleTargetMan => 'ตัวเป้า';

  @override
  String get rolePoacher => 'จอมฉวยโอกาส';

  @override
  String get rolePlaymaker => 'เพลย์เมกเกอร์';

  @override
  String get roleBallWinner => 'มือแย่งบอล';

  @override
  String get roleInvertedWinger => 'ปีกตัดเข้าใน';

  @override
  String get roleBallPlayingDefender => 'กองหลังเล่นบอล';

  @override
  String get roleNoneBlurb => 'เล่นตามธรรมชาติของตัวเอง';

  @override
  String get roleTargetManBlurb =>
      'ชนะลูกกลางอากาศ พักบอลให้เพื่อน แอสซิสต์และลูกตั้งเตะ';

  @override
  String get rolePoacherBlurb => 'ดักรอในกรอบเขตโทษ ยิงได้มากขึ้นเยอะ';

  @override
  String get rolePlaymakerBlurb => 'สร้างโอกาส แอสซิสต์มากขึ้นเยอะ';

  @override
  String get roleBallWinnerBlurb => 'ตัดเกมมากกว่าจบสกอร์';

  @override
  String get roleInvertedWingerBlurb => 'ตัดเข้าในเพื่อยิง ได้ประตูมากขึ้น';

  @override
  String get roleBallPlayingDefenderBlurb => 'เริ่มเกมจากแนวหลัง';

  @override
  String get federationDeptYouth => 'อะคาเดมีเยาวชน';

  @override
  String get federationDeptCommercial => 'การตลาด / ประชาสัมพันธ์';

  @override
  String get federationDeptMedical => 'การแพทย์ / วิทยาศาสตร์การกีฬา';

  @override
  String get federationDeptNaturalisation => 'สำนักงานโอนสัญชาติ';

  @override
  String get federationDeptBoardRelations => 'ความสัมพันธ์กับบอร์ด';

  @override
  String get federationDeptYouthBlurb =>
      'ดาวรุ่งจากอะคาเดมีที่ดีขึ้น จะได้ประเดิมทีมชาติในรอบหน้า';

  @override
  String get federationDeptCommercialBlurb =>
      'สปอนเซอร์ช่วยเพิ่มรายได้ เมื่อจบรอบ';

  @override
  String get federationDeptMedicalBlurb =>
      'บาดเจ็บน้อยลง ทีมพร้อมลงสนามตลอดรอบ';

  @override
  String get federationDeptNaturalisationBlurb =>
      'ผู้เล่นต่างชาติเสนอตัว เปลี่ยนมาเล่นให้ชาติคุณมากขึ้น';

  @override
  String get federationDeptBoardRelationsBlurb =>
      'บอร์ดตัดสินผลงานของคุณ อย่างอดทนมากขึ้น';

  @override
  String get federationBuildingAcademy => 'อะคาเดมี';

  @override
  String get federationBuildingCommercial => 'สำนักงานการตลาด';

  @override
  String get federationBuildingMedical => 'ศูนย์การแพทย์';

  @override
  String get federationBuildingScouting => 'สำนักงานแมวมอง';

  @override
  String get federationBuildingBoardroom => 'ห้องประชุมบอร์ด';

  @override
  String get moraleBuoyant => 'คึกคัก';

  @override
  String get moralePositive => 'เป็นบวก';

  @override
  String get moraleSettled => 'มั่นคง';

  @override
  String get moraleUneasy => 'ไม่สบายใจ';

  @override
  String get moraleRockBottom => 'ตกต่ำสุดขีด';

  @override
  String get matchTabTimeline => 'ไทม์ไลน์';

  @override
  String get matchTabStats => 'สถิติ';

  @override
  String get matchTabLineups => 'รายชื่อ';

  @override
  String get matchPenalty => 'จุดโทษ';

  @override
  String get matchStateLevel => 'ยังเสมอกันอยู่';

  @override
  String matchStateLead(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'คุณนำอยู่ $count ประตู',
      one: 'คุณนำอยู่ 1 ประตู',
    );
    return '$_temp0';
  }

  @override
  String matchStateTrail(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'คุณตามอยู่ $count ประตู',
      one: 'คุณตามอยู่ 1 ประตู',
    );
    return '$_temp0';
  }

  @override
  String matchPossessionShare(int possession) {
    return 'ครองบอล $possession%';
  }

  @override
  String get boardVerdictSackedTitle => 'บอร์ดปลดคุณออกจากตำแหน่ง';

  @override
  String boardVerdictSackedBody(int rating) {
    return 'รอบที่ย่ำแย่ (คะแนน $rating%) ยุคของคุณจบลงที่นี่ จากนี้มีแต่ชาติระดับรองที่จะยอมเสี่ยงกับคุณ';
  }

  @override
  String get boardVerdictDelightedTitle => 'บอร์ดยินดีอย่างยิ่ง';

  @override
  String boardVerdictDelightedBody(int rating, String best) {
    return 'รอบที่ยอดเยี่ยม (คะแนน $rating%) หลังจาก$best ชาติที่ใหญ่กว่าสนใจคุณ หรือคุณจะอยู่สร้างทีมต่อก็ได้';
  }

  @override
  String get boardVerdictSolidTitle => 'รอบที่มั่นคง';

  @override
  String boardVerdictSolidBody(int rating) {
    return 'บอร์ดพอใจ (คะแนน $rating%) มีชาติระดับใกล้เคียงกันไม่กี่ชาติที่สนใจคุณ แต่ไม่มีแรงกดดันให้ย้าย';
  }

  @override
  String get boardVerdictExpectedMoreTitle => 'บอร์ดคาดหวังมากกว่านี้';

  @override
  String boardVerdictExpectedMoreBody(int rating) {
    return 'รอบที่น่าผิดหวัง (คะแนน $rating%) คุณยังได้ทำงานต่อ แต่ข้อเสนอที่มีล้วนเป็นการถอยหลัง';
  }

  @override
  String get boardVerdictPressureTitle => 'คุณกำลังเจอแรงกดดันหนัก';

  @override
  String boardVerdictPressureBody(int rating) {
    return 'รอบที่แย่ (คะแนน $rating%) คุณรอดมาได้ แต่ถ้าอยากเริ่มใหม่ มีแค่ชาติที่อ่อนกว่าที่สนใจ';
  }

  @override
  String get boardVerdictHeroTitle => 'ทั้งชาติยืนเคียงข้างคุณ';

  @override
  String boardVerdictHeroNote(String nation, int cycles) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles รอบ',
    );
    return ' $nation รักคุณ ฮีโร่ของชาติหลังผ่าน $_temp0 ตำแหน่งของคุณปลอดภัยตราบเท่าที่คุณต้องการ';
  }

  @override
  String get boardVerdictTheNation => 'ชาติ';

  @override
  String get boardVerdictBestQuiet => 'รอบที่เงียบๆ';

  @override
  String get boardVerdictBestCycle => 'รอบนี้';

  @override
  String boardVerdictBestWorld(String placement) {
    return 'ชิงแชมป์โลก: $placement';
  }

  @override
  String get finishThirdPlace => 'อันดับ 3';

  @override
  String get finishFourthPlace => 'อันดับ 4';

  @override
  String get finishDidNotQualify => 'ไม่ผ่านเข้ารอบ';

  @override
  String get careerRepIconic => 'ตำนาน';

  @override
  String get careerRepRenowned => 'มีชื่อเสียง';

  @override
  String get careerRepEstablished => 'มั่นคงในวงการ';

  @override
  String get careerRepRising => 'ดาวรุ่ง';

  @override
  String get careerRepUnproven => 'ยังไม่พิสูจน์ตัวเอง';

  @override
  String get hubOfferStepUp => 'ก้าวขึ้น';

  @override
  String get hubOfferLateral => 'ย้ายระดับเดียวกัน';

  @override
  String get hubOfferRebuild => 'สร้างทีมใหม่';

  @override
  String careerNationsCupWon(String league) {
    return 'ลีก $league · แชมป์';
  }

  @override
  String careerNationsCupRunnerUp(String league) {
    return 'ลีก $league · รองแชมป์';
  }

  @override
  String careerNationsCupSemi(String league) {
    return 'ลีก $league · รอบรองชนะเลิศ';
  }

  @override
  String careerNationsCupPlaced(String league, int position) {
    return 'ลีก $league · #$position';
  }

  @override
  String tourRunInto(String round) {
    return 'เข้าสู่$round';
  }

  @override
  String get tourRunIntoThirdPlace => 'เข้าสู่นัดชิงอันดับ 3';

  @override
  String tourRunThrough(String round) {
    return 'ผ่านจาก$round';
  }

  @override
  String tourRunOut(String round) {
    return 'ตกรอบใน$round';
  }

  @override
  String get tourRunInGroup => 'กำลังแข่งรอบแบ่งกลุ่ม';

  @override
  String get tourRunGroupOut => 'ตกรอบแบ่งกลุ่ม';

  @override
  String resultsCycleTitle(int year, String nation) {
    return 'รอบปี $year · $nation';
  }

  @override
  String resultsCycleRecord(int played, int won, int drawn, int lost) {
    return 'แข่ง $played  ·  ชนะ $won เสมอ $drawn แพ้ $lost';
  }

  @override
  String resultsCycleFinish(String finish) {
    return 'ชิงแชมป์โลก: $finish';
  }

  @override
  String get resultsCycleUnderway => 'ยังแข่งอยู่';

  @override
  String yTurnedItRound0(String opponent) {
    return 'ตาม $opponent สองลูกตอนพักครึ่ง แล้วตามตีคืนได้หมด นี่แหละทีม';
  }

  @override
  String yTurnedItRound1(String opponent) {
    return 'ตาม $opponent สองลูก แต่พอจบเกมก็ไม่สำคัญแล้ว ไม่กี่ทีมที่ทำแบบนี้ได้';
  }

  @override
  String yTurnedItRound2(String opponent) {
    return 'พักครึ่ง: ตาม $opponent สองลูก จบเกม: ไม่ใช่แล้ว ครึ่งหลังคือคนละเกม';
  }

  @override
  String yTurnedItRound3(String opponent) {
    return 'ตามหลัง $opponent สองลูกแล้วกลับมาได้ พักครึ่งพูดอะไรกันไว้ พูดแบบนั้นทุกสัปดาห์';
  }

  @override
  String yTurnedItRound4(String opponent) {
    return 'ก็ได้ เราตามคืน $opponent ได้ ทีนี้ใครก็ได้อธิบายสี่สิบห้านาทีแรกที';
  }

  @override
  String yTurnedItRound5(String opponent) {
    return 'ตาม $opponent สองลูก แล้วเราต้องดีใจเหรอ แก้ครึ่งแรกซะ';
  }

  @override
  String yThrewItAway0(String opponent) {
    return 'นำ $opponent สองลูกตอนพักครึ่ง แล้วหลุดมือไป ทีมที่ดีกว่านี้ก็เคยเจอ';
  }

  @override
  String yThrewItAway1(String opponent) {
    return 'นำ $opponent สองลูกแล้วหลุดมือ รอบยังอีกยาว มีเวลาอีกเยอะ';
  }

  @override
  String yThrewItAway2(String opponent) {
    return 'พักครึ่ง: นำ $opponent สองลูก จบเกม: ไม่เหลือเค้า';
  }

  @override
  String yThrewItAway3(String opponent) {
    return 'สกอร์นำสองลูกเหนือ $opponent หายวับภายในสี่สิบห้านาที';
  }

  @override
  String yThrewItAway4(String opponent) {
    return 'นำสองลูกแล้วยังแพ้ $opponent ต้องมีใครรับผิดชอบ';
  }

  @override
  String yThrewItAway5(String opponent) {
    return 'นำ $opponent สองลูกแล้วเรายังทำได้ขนาดนี้ ทุกครั้งเลย';
  }

  @override
  String get cycleBackupDone =>
      'สำรองอาชีพไว้ในโฟลเดอร์ FNM บนโทรศัพท์เครื่องนี้แล้ว การถอนการติดตั้งแอปจะลบไฟล์นี้ด้วย หากต้องการเก็บสำเนาไว้ที่อื่น ใช้ สำรองเซฟนี้ ในหน้าเซฟ';

  @override
  String get cycleBackupFailed => 'สำรองอาชีพครั้งนี้ไม่สำเร็จ';

  @override
  String pressMomentBigWinWarm1(String opponent) {
    return 'ค่ำคืนที่น่าจดจำกับ $opponent คุณภูมิใจในทีมชุดนี้แค่ไหน?';
  }

  @override
  String pressMomentBigWinWarm2(String opponent) {
    return '$opponent ต้านทานคุณไม่ไหว นี่คือทีมที่คุณเชื่อมาตลอดว่ามีอยู่ใช่ไหม?';
  }

  @override
  String pressMomentBigWinNeutral1(String opponent) {
    return 'ชัยชนะครั้งใหญ่เหนือ $opponent อะไรคือความแตกต่างในคืนนี้?';
  }

  @override
  String pressMomentBigWinNeutral2(String opponent) {
    return 'เอาชนะ $opponent ได้อย่างสบาย คุณชนะเกมนี้ตรงไหน?';
  }

  @override
  String pressMomentBigWinHostile1(String opponent) {
    return 'ชัยชนะที่ดีเหนือ $opponent แค่คืนดีๆ คืนเดียว ทำไมใครต้องเชื่อว่ามันจะยั่งยืน?';
  }

  @override
  String pressMomentBigWinHostile2(String opponent) {
    return 'ผลที่ดีกับ $opponent นั่นคือแผนของคุณ หรือนักเตะคิดกันเอง?';
  }

  @override
  String pressMomentBigLossWarm1(String opponent) {
    return 'คืนที่หนักหน่วงกับ $opponent คุณจะพูดอะไรกับนักเตะหลังเกมแบบนี้?';
  }

  @override
  String pressMomentBigLossWarm2(String opponent) {
    return 'ไม่มีใครคาดคิดกับผลนี้เมื่อเจอ $opponent มันเป็นแค่คืนที่ไม่ใช่ใช่ไหม?';
  }

  @override
  String pressMomentBigLossNeutral1(String opponent) {
    return 'คืนที่เจ็บปวดกับ $opponent อะไรผิดพลาด?';
  }

  @override
  String pressMomentBigLossNeutral2(String opponent) {
    return '$opponent ฉีกทีมคุณเป็นชิ้นๆ ทีมชุดนี้ดีพอหรือเปล่า?';
  }

  @override
  String pressMomentBigLossHostile1(String opponent) {
    return 'คุณเป็นรองทุกด้านเมื่อเจอ $opponent ปล่อยให้แย่ขนาดนั้นได้อย่างไร?';
  }

  @override
  String pressMomentBigLossHostile2(String opponent) {
    return '$opponent ยิงได้ตามใจ แผนของคุณคืนนี้อยู่ที่ไหน?';
  }

  @override
  String pressMomentCrisisWarm1(String opponent) {
    return 'หลุดมืออีกนัด คราวนี้กับ $opponent คุณจะพลิกสถานการณ์นี้อย่างไร?';
  }

  @override
  String pressMomentCrisisWarm2(String opponent) {
    return 'ผลงานแห้งแล้ง และ $opponent ทำให้แย่ลงอีก คุณยังเชื่อในทีมชุดนี้ไหม?';
  }

  @override
  String pressMomentCrisisNeutral1(String opponent) {
    return 'ไม่ชนะอีกแล้ว คราวนี้กับ $opponent และบอร์ดกำลังจับตา ตำแหน่งของคุณปลอดภัยไหม?';
  }

  @override
  String pressMomentCrisisNeutral2(String opponent) {
    return 'หลังเกมกับ $opponent สถิติแย่ๆ เริ่มยาวขึ้น คุณกังวลเรื่องอนาคตไหม?';
  }

  @override
  String pressMomentCrisisHostile1(String opponent) {
    return '$opponent ด้วยอีกทีม คนก่อนหน้าคุณโดนปลดด้วยผลงานแบบนี้ ทำไมคุณถึงควรรอด?';
  }

  @override
  String pressMomentCrisisHostile2(String opponent) {
    return 'หลังคืนแบบเกมกับ $opponent อีกครั้ง ทุกรายการโฟนอินอยากให้คุณออก คุณจะลาออกไหมถ้าบอร์ดขอ?';
  }

  @override
  String pressMomentJobVerdictWarm1(String opponent) {
    return 'คุณเอาตำแหน่งเป็นเดิมพัน และหลังเกมกับ $opponent มันไม่เป็นไปตามที่หวัง คุณรับมือเป็นอย่างไรบ้าง?';
  }

  @override
  String pressMomentJobVerdictWarm2(String opponent) {
    return 'สามนัดจบแล้ว นัดสุดท้ายกับ $opponent คุณตั้งบททดสอบเอง คุณคิดอย่างไรกับผลตัดสิน?';
  }

  @override
  String pressMomentJobVerdictNeutral1(String opponent) {
    return 'คุณบอกให้ตัดสินจากสามนัดถัดไป หลังเกมกับ $opponent เราตัดสินแล้ว ตำแหน่งยังเป็นของคุณไหม?';
  }

  @override
  String pressMomentJobVerdictNeutral2(String opponent) {
    return 'สามนัด นัดสุดท้ายกับ $opponent และไม่เป็นไปตามที่สัญญา คุณคุยกับบอร์ดเรื่องอนาคตแล้วหรือยัง?';
  }

  @override
  String pressMomentJobVerdictHostile1(String opponent) {
    return 'คุณตั้งบททดสอบเองและสอบตกเมื่อเจอ $opponent คุณจะลาออกไหม?';
  }

  @override
  String pressMomentJobVerdictHostile2(String opponent) {
    return 'คำพูดของคุณเอง ไม่ใช่ของเรา: ตัดสินผมจากสามนัดถัดไป หลังเกมกับ $opponent ทำไมคุณยังนั่งอยู่ตรงนั้น?';
  }

  @override
  String get pressBeatWhoToBlameWarm1 =>
      'คุณต้องการมากกว่านี้จากพวกเขา มีใครเป็นพิเศษไหม?';

  @override
  String get pressBeatWhoToBlameWarm2 =>
      'คุณตั้งมาตรฐานไว้สูง ใครต้องก้าวขึ้นมาก่อน?';

  @override
  String get pressBeatWhoToBlameNeutral1 =>
      'คุณบอกว่าบางคนต้องมองตัวเอง คุณหมายถึงใคร?';

  @override
  String get pressBeatWhoToBlameNeutral2 => 'คุณบอกว่าไม่ดีพอ คุณพูดถึงใคร?';

  @override
  String get pressBeatWhoToBlameHostile1 =>
      'คุณพูดกว้างๆ ตลอด จะระบุชื่อไหม หรือสุดท้ายมันวกกลับมาที่คุณ?';

  @override
  String get pressBeatWhoToBlameHostile2 =>
      'ทุกสัปดาห์เป็นความผิดของคนอื่น ครั้งนี้เป็นของใคร?';

  @override
  String get pressBeatIfYouDontWarm1 =>
      'คำพูดที่กล้าหาญ แล้วถ้านัดหน้าไม่เป็นไปตามที่หวังล่ะ?';

  @override
  String get pressBeatIfYouDontWarm2 =>
      'ทั้งประเทศจะจดจำคำนี้ ถ้ามันไม่สำเร็จล่ะ?';

  @override
  String get pressBeatIfYouDontNeutral1 =>
      'แล้วถ้าไม่ชนะล่ะ? จะเป็นอย่างไรต่อ?';

  @override
  String get pressBeatIfYouDontNeutral2 =>
      'คุณพูดออกมาแล้ว ถ้าคุณคิดผิดจะเกิดอะไรขึ้น?';

  @override
  String get pressBeatIfYouDontHostile1 =>
      'เราเคยได้ยินคำสัญญาในห้องนี้มาก่อน ถ้าครั้งนี้ผิดสัญญาอีก คุณติดค้างอะไรกับแฟนบอล?';

  @override
  String get pressBeatIfYouDontHostile2 =>
      'แล้วเมื่อมันไม่เกิดขึ้น ข้ออ้างจะเป็นอะไร?';

  @override
  String get pressBeatFollowUpWarm1 =>
      'ขออีกข้อถ้าคุณยังไหว ทีมชุดนี้ยังต้องพัฒนาอะไรอีก?';

  @override
  String get pressBeatFollowUpWarm2 =>
      'เมื่อทุกอย่างสงบลง คุณจะเอาอะไรจากคืนนี้ไปใช้ในนัดหน้า?';

  @override
  String get pressBeatFollowUpNeutral1 =>
      'ลงลึกอีกนิด อะไรต้องดีขึ้นก่อนนัดหน้า?';

  @override
  String get pressBeatFollowUpNeutral2 =>
      'มองข้ามสกอร์ไป ทีมชุดนี้อยู่ในจุดที่คุณต้องการหรือยัง?';

  @override
  String get pressBeatFollowUpHostile1 =>
      'พูดเยอะแต่ไม่ได้อะไร จากนี้อะไรจะเปลี่ยนจริงๆ?';

  @override
  String get pressBeatFollowUpHostile2 =>
      'แฟนบอลต้องการคำตอบตรงๆ ทีมนี้ดีพอไหม ใช่หรือไม่?';

  @override
  String pressBeatStandoutWarm1(String player) {
    return '$player ยอดเยี่ยมมากคืนนี้ เขาจะไปได้ไกลแค่ไหน?';
  }

  @override
  String pressBeatStandoutWarm2(String player) {
    return '$player อยู่ในทุกพาดหัวคืนนี้ คุณคาดไว้ไหม?';
  }

  @override
  String pressBeatStandoutNeutral1(String player) {
    return '$player โดดเด่น คุณขออะไรจากเขาในคืนนี้?';
  }

  @override
  String pressBeatStandoutNeutral2(String player) {
    return '$player คือความแตกต่างในคืนนี้ใช่ไหม?';
  }

  @override
  String pressBeatStandoutHostile1(String player) {
    return 'ถ้าไม่มี $player เรื่องคงต่างออกไป นี่คือทีม หรือผู้เล่นคนเดียว?';
  }

  @override
  String pressBeatStandoutHostile2(String player) {
    return '$player ยอดเยี่ยม ผลงานของคุณ หรือของเขา?';
  }

  @override
  String pressBeatStrugglerWarm1(String player) {
    return '$player มีคืนที่ยากลำบาก เขามีอาการเจ็บหรือเปล่า?';
  }

  @override
  String pressBeatStrugglerWarm2(String player) {
    return 'คืนนี้ไม่ใช่คืนของ $player คุณจะปลอบใจเขาไหม?';
  }

  @override
  String pressBeatStrugglerNeutral1(String player) {
    return '$player เล่นได้ลำบากคืนนี้ เขาจะยังรักษาตำแหน่งไว้ได้ไหม?';
  }

  @override
  String pressBeatStrugglerNeutral2(String player) {
    return '$player ดูตามเกมไม่ทัน คุณคิดอย่างไรกับเกมของเขา?';
  }

  @override
  String pressBeatStrugglerHostile1(String player) {
    return '$player เป็นแค่ผู้โดยสารอีกแล้ว ทำไมคุณยังเลือกเขา?';
  }

  @override
  String pressBeatStrugglerHostile2(String player) {
    return 'ทุกคนเห็นว่า $player ไม่อยู่ในเกม ทุกคนยกเว้นม้านั่งสำรองหรือเปล่า?';
  }

  @override
  String get pressThrowbackWinNextKeptWarm =>
      'คุณบอกว่าจะชนะนัดหน้า และคุณก็ทำได้ รู้สึกดีไหมที่คิดถูก?';

  @override
  String get pressThrowbackWinNextKeptNeutral =>
      'คุณสัญญาว่าจะชนะนัดถัดไปและทำได้จริง ความมั่นใจ หรือแค่ปากดี?';

  @override
  String get pressThrowbackWinNextKeptHostile =>
      'คุณบอกว่าจะชนะนัดหน้า และคุณก็ทำได้ โชคช่วย หรือเราควรเริ่มฟังคุณแล้ว?';

  @override
  String get pressThrowbackWinNextBrokenWarm =>
      'คุณบอกเราว่าจะชนะนัดนั้น แต่ไม่เป็นอย่างนั้น อะไรผิดพลาด?';

  @override
  String get pressThrowbackWinNextBrokenNeutral =>
      'คุณบอกว่าจะชนะนัดหน้า แต่ไม่ชนะ ทำไมเราต้องเชื่อคำสัญญาครั้งต่อไป?';

  @override
  String get pressThrowbackWinNextBrokenHostile =>
      'คุณบอกว่าจะชนะนัดหน้า แต่ไม่ชนะ คำพูดของคุณยังมีความหมายในห้องนี้อยู่ไหม?';

  @override
  String get pressThrowbackJobKeptWarm =>
      'คุณขอให้ตัดสินจากสามนัด และคุณผ่าน พิสูจน์ตัวเองได้แล้วใช่ไหม?';

  @override
  String get pressThrowbackJobKeptNeutral =>
      'ตัดสินผมจากสามนัดถัดไป คุณว่าไว้ เราตัดสินแล้ว และผลงานก็มา บททดสอบนั้นสอนอะไรคุณ?';

  @override
  String get pressThrowbackJobKeptHostile =>
      'คุณให้เวลาตัวเองสามนัดและผ่านมาได้ บททดสอบนั้นยากจริงหรือเปล่า?';

  @override
  String get pressThrowbackJobBrokenWarm =>
      'คุณขอให้ตัดสินจากสามนัด แต่ไม่เป็นไปตามที่หวัง คุณได้เรียนรู้อะไร?';

  @override
  String get pressThrowbackJobBrokenNeutral =>
      'คุณบอกให้ตัดสินจากสามนัดถัดไป สามนัดผ่านไปแล้ว ความเชื่อใจก็หมดไปด้วย แล้วจากนี้ล่ะ?';

  @override
  String get pressThrowbackJobBrokenHostile =>
      'คุณตั้งบททดสอบเองและสอบตก ทำไมใครยังต้องเชื่อคำพูดของคุณ?';

  @override
  String pressThrowbackBackKeptWarm(String player) {
    return 'คุณหนุน $player ตอนที่คนอื่นไม่หนุน และเขาก็ทำได้ ส่วนหนึ่งของเครดิตเป็นของคุณไหม?';
  }

  @override
  String pressThrowbackBackKeptNeutral(String player) {
    return 'คุณหนุน $player และเขาก็ทำได้ ความศรัทธา หรือความรู้?';
  }

  @override
  String pressThrowbackBackKeptHostile(String player) {
    return 'คุณหนุน $player และครั้งนี้มันได้ผล ครั้งหน้าคุณจะมั่นใจแบบนี้ไหม?';
  }

  @override
  String pressThrowbackBackBrokenWarm(String player) {
    return 'คุณยืนเคียงข้าง $player แต่ไม่ได้ผล คุณยังเชื่อในตัวเขาไหม?';
  }

  @override
  String pressThrowbackBackBrokenNeutral(String player) {
    return 'คุณหนุน $player แต่เขาไม่ได้ตอบแทน นั่นเป็นความผิดพลาดไหม?';
  }

  @override
  String pressThrowbackBackBrokenHostile(String player) {
    return 'วิจารณญาณหรือความภักดีของคุณ อันไหนล้มเหลวกับ $player?';
  }

  @override
  String pressThrowbackBlameKeptWarm(String player) {
    return 'คุณเข้มงวดกับ $player และเกมหลังจากนั้นพิสูจน์ว่าคุณพูดถูก รู้สึกพอใจบ้างไหม?';
  }

  @override
  String pressThrowbackBlameKeptNeutral(String player) {
    return 'คุณตำหนิ $player และเขายังไม่ได้ตอบกลับ เขายังมีทางกลับมาไหม?';
  }

  @override
  String pressThrowbackBlameKeptHostile(String player) {
    return 'คุณประจาน $player และเขายังไม่ฟื้น คุณทำลายเขาหรือเปล่า?';
  }

  @override
  String pressThrowbackBlameBrokenWarm(String player) {
    return 'คุณตำหนิ $player และเขาตอบคุณในสนาม นั่นคือแผนตั้งแต่แรกใช่ไหม?';
  }

  @override
  String pressThrowbackBlameBrokenNeutral(String player) {
    return 'คุณโทษ $player และตั้งแต่นั้นเขาเป็นหนึ่งในตัวที่ดีที่สุดของคุณ คุณติดคำขอโทษเขาไหม?';
  }

  @override
  String pressThrowbackBlameBrokenHostile(String player) {
    return 'คุณโยน $player ให้รับกรรม และตั้งแต่นั้นเขาเป็นผู้เล่นที่ดีที่สุดของคุณ คุณจะขอโทษไหม?';
  }

  @override
  String get pressReplyCreditPlayers1 =>
      'นักเตะชุดนี้ทุ่มเทให้ผมทุกอย่าง ผมจะไม่แลกใครสักคน';

  @override
  String get pressReplyCreditPlayers2 =>
      'ไม่มีใครทำงานหนักกว่ากลุ่มนี้ ผมจะปกป้องพวกเขาทั้งวัน';

  @override
  String get pressReplyCreditPlayers3 =>
      'คุณจะไม่ได้ยินคำตำหนินักเตะของผมจากเก้าอี้ตัวนี้';

  @override
  String get pressReplyCreditPlayers4 =>
      'เครดิตเป็นของนักเตะ ไม่ใช่ผม เขียนถึงพวกเขาเถอะ';

  @override
  String get pressReplyTakeResponsibility1 =>
      'นัดนั้นเป็นความผิดผม ผมเลือกทีมและผมวางแผนเอง';

  @override
  String get pressReplyTakeResponsibility2 =>
      'ตัดสินผม ไม่ใช่พวกเขา นี่คือทีมของผมและความรับผิดชอบของผม';

  @override
  String get pressReplyTakeResponsibility3 =>
      'ถ้าอยากหาคนรับผิด ผมนั่งอยู่ตรงนี้';

  @override
  String get pressReplyTakeResponsibility4 =>
      'ความรับผิดชอบเป็นของผม อย่าดึงนักเตะเข้ามาเกี่ยว';

  @override
  String get pressReplyDemandMore1 =>
      'ผมต้องการมากกว่านี้ บางคนรู้ดีว่าผมหมายถึงอะไร';

  @override
  String get pressReplyDemandMore2 =>
      'แค่ความพยายามไม่พอในระดับนี้ ผมต้องการมากกว่านี้ และผมบอกพวกเขาแล้ว';

  @override
  String get pressReplyDemandMore3 =>
      'ผมคาดหวังมากกว่านี้จากทุกคน เริ่มตั้งแต่พรุ่งนี้';

  @override
  String get pressReplyDemandMore4 => 'บางคนต้องมองตัวเอง ผมยังไม่พอใจ';

  @override
  String get pressReplyPromiseWinNext1 => 'เราจะชนะนัดหน้า จดไว้ได้เลย';

  @override
  String get pressReplyPromiseWinNext2 => 'จำคำผมไว้: เราจะชนะนัดถัดไป';

  @override
  String get pressReplyPromiseWinNext3 =>
      'นัดหน้าเราชนะ ผมพูดตรงนี้เพื่อให้คุณทวงได้';

  @override
  String get pressReplyPromiseWinNext4 => 'ผมมั่นใจในทีมนี้ เราจะชนะนัดถัดไป';

  @override
  String get pressReplyJobOnTheLine1 =>
      'ตัดสินผมจากสามนัดถัดไป แบบนั้นยุติธรรม';

  @override
  String get pressReplyJobOnTheLine2 =>
      'ให้เวลาผมสามนัด ถ้ายังไม่ดีขึ้น ก็ตัดสินผมจากนั้น';

  @override
  String get pressReplyJobOnTheLine3 =>
      'สามนัดถัดไปจะบอกว่าผมใช่คนที่เหมาะหรือไม่ ทวงผมได้เลย';

  @override
  String get pressReplyJobOnTheLine4 =>
      'สามนัด แล้วจะเขียนอะไรเกี่ยวกับผมก็ได้';

  @override
  String get pressReplyDeflect1 => 'เราเล่นทีละนัด ไม่มีอะไรจะเพิ่ม';

  @override
  String get pressReplyDeflect2 => 'วันนี้ผมจะไม่สร้างพาดหัวให้คุณ';

  @override
  String get pressReplyDeflect3 => 'นัดหน้า นั่นคือทั้งหมดที่ผมคิดอยู่';

  @override
  String get pressReplyDeflect4 => 'สิ่งที่ผมคิดอยู่ในห้องแต่งตัว';

  @override
  String get pressReplyTakeCredit1 => 'ผมพูดเพราะผมเชื่อ และผมก็พูดถูก';

  @override
  String get pressReplyTakeCredit2 => 'ผมอ่านเกมถูก นั่นคือหน้าที่ของผม';

  @override
  String get pressReplyTakeCredit3 =>
      'เรียกว่าวิจารณญาณก็ได้ ผมรู้ว่าผมพูดอะไร';

  @override
  String get pressReplyTakeCredit4 => 'ผมตัดสินใจและมันได้ผล ผมรับไว้';

  @override
  String get pressReplyStandByIt1 => 'ผมพูดสิ่งที่ผมเชื่อ และผมยืนยันตามนั้น';

  @override
  String get pressReplyStandByIt2 => 'ผมไม่ถอนคำพูดสักคำ';

  @override
  String get pressReplyStandByIt3 =>
      'คำตอบเดิม ผมหมายความตามนั้น และยังหมายความอยู่';

  @override
  String get pressReplyStandByIt4 => 'พรุ่งนี้ผมก็จะพูดอีก';

  @override
  String get pressReplyAdmitMistake1 => 'ผมคิดผิดเรื่องนั้น ผมยอมรับ';

  @override
  String get pressReplyAdmitMistake2 => 'ก็ได้ ผมประเมินผิด ผมจะเรียนรู้จากมัน';

  @override
  String get pressReplyAdmitMistake3 => 'ผมผิด และผมพูดได้';

  @override
  String get pressReplyAdmitMistake4 =>
      'การตัดสินใจนั้นไม่ได้ผล และมันเป็นของผม';

  @override
  String pressReplyBackPlayer1(String player) {
    return '$player ได้รับการสนับสนุนจากผมเต็มที่ เขาจะกลับมาดี';
  }

  @override
  String pressReplyBackPlayer2(String player) {
    return 'ผมเชื่อใน $player และเขาจะแสดงให้คุณเห็นว่าทำไม';
  }

  @override
  String pressReplyBackPlayer3(String player) {
    return 'คุณจะไม่ได้ยินคำตำหนิ $player จากผม เขาจะทำได้';
  }

  @override
  String pressReplyBackPlayer4(String player) {
    return '$player ยังอยู่ในแผนของผม คอยดูว่าเขาจะทำอะไรต่อ';
  }

  @override
  String pressReplyBlamePlayer1(String player) {
    return '$player ทำให้เราผิดหวังคืนนี้ และเขารู้ดี';
  }

  @override
  String pressReplyBlamePlayer2(String player) {
    return 'ผมคาดหวังจาก $player มากกว่านี้เยอะ เขาต้องตอบเรื่องนี้';
  }

  @override
  String pressReplyBlamePlayer3(String player) {
    return '$player ไม่ได้อยู่ในระดับที่ควร ผมพูดต่อหน้าสาธารณะได้';
  }

  @override
  String pressReplyBlamePlayer4(String player) {
    return '$player ทำได้ไม่ดีพอ และเขาจะได้ยินจากผม';
  }

  @override
  String get pressOnRecordWinNext => 'บันทึกไว้แล้ว: คุณจะชนะนัดถัดไป';

  @override
  String get pressOnRecordJob => 'บันทึกไว้แล้ว: ตัดสินคุณจากสามนัดถัดไป';

  @override
  String pressOnRecordBack(String player) {
    return 'บันทึกไว้แล้ว: สนับสนุน $player';
  }

  @override
  String pressOnRecordBlame(String player) {
    return 'บันทึกไว้แล้ว: $player ทำให้คุณผิดหวัง';
  }

  @override
  String yStatementKept0(String nation) {
    return 'เขาพูดไว้ และมันก็เกิดขึ้น $nation มีผู้จัดการทีมที่พูดจริงทำจริง';
  }

  @override
  String yStatementKept1(String nation) {
    return 'พูดออกมาดังๆ แล้วไปทำได้จริง นี่คือคนที่ $nation ต้องการ';
  }

  @override
  String yStatementKept2(String nation) {
    return '$nation: เขาทายไว้ และมันก็เป็นจริง ยอมรับ';
  }

  @override
  String yStatementKept3(String nation) {
    return 'เขาพูดไว้อย่างเป็นทางการและมันเป็นจริง ให้เขาไปหนึ่งแต้ม $nation เดินหน้าต่อ';
  }

  @override
  String yStatementKept4(String nation) {
    return 'เขาพูดถูกสักครั้ง $nation อย่าเพิ่งชินล่ะ';
  }

  @override
  String yStatementKept5(String nation) {
    return 'นาฬิกาตายยังตรงวันละสองครั้ง $nation โชคดีไปครั้งนี้';
  }

  @override
  String yStatementBroken0(String nation) {
    return 'เขาพูดไว้แต่ไม่สำเร็จ ยังอยู่ข้างเขา $nation สู้ต่อ';
  }

  @override
  String yStatementBroken1(String nation) {
    return '$nation: เขาสัญญาไว้มากกว่าที่เราได้ แต่ผมชอบผู้จัดการทีมที่เชื่อมั่นในตัวเองมากกว่า';
  }

  @override
  String yStatementBroken2(String nation) {
    return '$nation: เขาพูดไว้อย่างเป็นทางการแต่มันไม่เกิดขึ้น คนจะจำได้';
  }

  @override
  String yStatementBroken3(String nation) {
    return 'พูดใหญ่โต แต่ไม่มีอะไรรองรับ $nation: ครั้งหน้าพูดให้น้อยลง';
  }

  @override
  String yStatementBroken4(String nation) {
    return 'เขายืนบอกเราตรงนั้น แล้วก็เป็นแบบนี้ $nation สมควรได้มากกว่าแค่คำพูด';
  }

  @override
  String yStatementBroken5(String nation) {
    return 'คำพูดของเขาไร้ค่าแล้ว จดไว้เลย $nation';
  }

  @override
  String get ncZoneNorth => 'โซนเหนือ';

  @override
  String get ncZoneWest => 'โซนตะวันตก';

  @override
  String get ncZoneEast => 'โซนตะวันออก';

  @override
  String get ncZoneCentralSouthern => 'โซนกลางและใต้';

  @override
  String careerNationsCupZoneWon(String zone) {
    return '$zone · แชมป์';
  }

  @override
  String careerNationsCupZoneRunnerUp(String zone) {
    return '$zone · รองแชมป์';
  }

  @override
  String careerNationsCupZoneSemi(String zone) {
    return '$zone · รอบรองชนะเลิศ';
  }

  @override
  String careerNationsCupZoneRoundOf16(String zone) {
    return '$zone · รอบ 16 ทีม';
  }

  @override
  String careerNationsCupZoneQuarter(String zone) {
    return '$zone · รอบ 8 ทีม';
  }

  @override
  String careerNationsCupZonePlaced(String zone, int position) {
    return '$zone · #$position';
  }

  @override
  String get objectiveNcFinalsEight => 'เข้ารอบ 8 ทีม';

  @override
  String get objectiveNcZoneWinGroup => 'ชนะกลุ่ม';

  @override
  String get finishNcFinalsEight => 'รอบ 8 ทีม';

  @override
  String get finishNcBottomHalf => 'ครึ่งล่างของกลุ่ม';

  @override
  String get tourContTabZones => 'โซน';

  @override
  String get tourContTabFinalsEight => 'รอบน็อกเอาต์';

  @override
  String get tourContFinalsEightSoon =>
      'รอบน็อกเอาต์เริ่มในเดือนพฤศจิกายนด้วยรอบ 16 ทีม: แชมป์กลุ่มทั้ง 14 ทีมและอันดับ 2 ที่ดีที่สุด 2 ทีม';

  @override
  String get tourContQuarterFinals => 'รอบ 8 ทีม';

  @override
  String get tourContZoneAdvancement =>
      'แชมป์กลุ่มทุกทีมผ่านเข้ารอบ 16 ทีม พร้อมอันดับ 2 ที่ดีที่สุด 2 ทีม ไม่มีทีมตกชั้น';

  @override
  String tourContZoneHeadingYours(String zone) {
    return '$zone ★';
  }

  @override
  String get compNorthAmericaNationsCup => 'เนชันส์คัพอเมริกาเหนือ';

  @override
  String get compAfricanNationsCup => 'เนชันส์คัพ';

  @override
  String get objectiveNcWinItNorthAmerica => 'คว้าแชมป์เนชันส์คัพอเมริกาเหนือ';

  @override
  String get objectiveNcWinItAfrica => 'คว้าแชมป์เนชันส์คัพ';

  @override
  String get objectiveNcReachFinalNorthAmerica =>
      'เข้าชิงชนะเลิศเนชันส์คัพอเมริกาเหนือ';

  @override
  String get objectiveNcReachFinalAfrica => 'เข้าชิงชนะเลิศเนชันส์คัพ';

  @override
  String get finishNcChampionsNorthAmerica => 'แชมป์เนชันส์คัพอเมริกาเหนือ';

  @override
  String get finishNcChampionsAfrica => 'แชมป์เนชันส์คัพ';

  @override
  String pressAimQualWarm1(String competition) {
    return 'รอบคัดเลือก $competition เริ่มแล้ว และทั้งประเทศเชื่อในทีมนี้ คุณตั้งเป้าไว้ที่อะไร?';
  }

  @override
  String pressAimQualWarm2(String competition) {
    return 'แคมเปญรอบคัดเลือก $competition ครั้งใหม่ และทุกคนมีกำลังใจดี ทีมนี้จะไปได้ไกลแค่ไหน?';
  }

  @override
  String pressAimQualNeutral1(String competition) {
    return 'รอบคัดเลือก $competition เริ่มแล้ว เป้าหมายของแคมเปญนี้คืออะไร?';
  }

  @override
  String pressAimQualNeutral2(String competition) {
    return 'รอบคัดเลือก $competition มาถึงแล้ว คุณมองว่าทีมนี้จะจบที่ตรงไหน?';
  }

  @override
  String pressAimQualHostile1(String competition) {
    return 'รอบคัดเลือก $competition เริ่มแล้ว และหลายคนสงสัยว่าคุณจะไปถึง คุณจะบอกอะไรพวกเขา?';
  }

  @override
  String pressAimQualHostile2(String competition) {
    return 'แคมเปญรอบคัดเลือก $competition อีกครั้ง ทำไมใครต้องเชื่อว่าครั้งนี้จะต่างออกไป?';
  }

  @override
  String pressAimFinalsWarm1(String competition) {
    return '$competition มาถึงแล้ว และทั้งประเทศอยู่เบื้องหลังคุณ คุณจะไปได้ไกลแค่ไหน?';
  }

  @override
  String pressAimFinalsWarm2(String competition) {
    return 'คุณอยู่ใน $competition และแฟนบอลกำลังฝัน เป้าหมายคืออะไร?';
  }

  @override
  String pressAimFinalsNeutral1(String competition) {
    return '$competition เริ่มสัปดาห์นี้ แค่ไหนถึงจะนับว่าประสบความสำเร็จ?';
  }

  @override
  String pressAimFinalsNeutral2(String competition) {
    return 'เกมแรกของคุณใน $competition ใกล้เข้ามาแล้ว บอกเป้าหมายกับเราหน่อย';
  }

  @override
  String pressAimFinalsHostile1(String competition) {
    return '$competition มาถึงแล้ว และไม่มีใครคาดหวังมาก คุณหวังอะไรจริงๆ?';
  }

  @override
  String pressAimFinalsHostile2(String competition) {
    return 'คุณอยู่ใน $competition แต่ข้อสงสัยยังไม่หายไป เป้าหมายของคุณคืออะไร?';
  }

  @override
  String pressBeatRivalWarm1(String rival) {
    return '$rival อยู่ในกลุ่มของคุณ พวกเขาทำให้คุณกังวลไหม?';
  }

  @override
  String pressBeatRivalWarm2(String rival) {
    return 'ผลจับสลากทำให้คุณต้องเจอ $rival คุณมองเกมนั้นอย่างไร?';
  }

  @override
  String pressBeatRivalNeutral1(String rival) {
    return '$rival ดูเป็นทีมที่แข็งแกร่งที่สุดในกลุ่มของคุณ พวกเขาเป็นเต็งไหม?';
  }

  @override
  String pressBeatRivalNeutral2(String rival) {
    return 'คุณคิดอย่างไรกับ $rival?';
  }

  @override
  String pressBeatRivalHostile1(String rival) {
    return '$rival อยู่ในกลุ่มของคุณ พูดตรงๆ คุณสู้พวกเขาได้ไหม?';
  }

  @override
  String pressBeatRivalHostile2(String rival) {
    return 'คนส่วนใหญ่คาดว่า $rival จะชนะคุณ พวกเขาคิดผิดหรือเปล่า?';
  }

  @override
  String pressBeatKeyPlayerWarm1(String player) {
    return '$player ฟอร์มดีมาก นี่คือช่วงเวลาของเขาไหม?';
  }

  @override
  String pressBeatKeyPlayerWarm2(String player) {
    return '$player อยู่ในทุกพาดหัว เขาแบกทีมนี้ได้ไหม?';
  }

  @override
  String pressBeatKeyPlayerNeutral1(String player) {
    return 'แคมเปญนี้ขึ้นอยู่กับ $player มากแค่ไหน?';
  }

  @override
  String pressBeatKeyPlayerNeutral2(String player) {
    return '$player พร้อมนำทีมนี้หรือยัง?';
  }

  @override
  String pressBeatKeyPlayerHostile1(String player) {
    return 'ถ้า $player ไม่อยู่ในจุดที่ดีที่สุด ทีมนี้ยังมีอะไรอีกไหม?';
  }

  @override
  String pressBeatKeyPlayerHostile2(String player) {
    return '$player แบกภาระไว้เยอะ มากเกินไปไหม?';
  }

  @override
  String get pressReplyAimHigher1 => 'เราจะไปได้ไกลกว่าที่ใครคาดไว้';

  @override
  String get pressReplyAimHigher2 =>
      'ผมต้องการมากกว่าที่สมาคมขอ และผมจะพูดออกมาดังๆ';

  @override
  String get pressReplyMatchBrief1 => 'เรารู้เป้าหมายและเราจะไปถึง';

  @override
  String get pressReplyMatchBrief2 => 'สมาคมตั้งเป้าไว้ เราจะทำให้ได้';

  @override
  String get pressReplyPlayDown1 => 'เล่นกันทีละนัดดีกว่า';

  @override
  String get pressReplyPlayDown2 =>
      'ไม่มีคำสัญญาใหญ่โต แล้วมาดูกันว่าเราอยู่ตรงไหน';

  @override
  String get pressReplyPromiseQualify1 => 'เราจะผ่านเข้ารอบ จดไว้ได้เลย';

  @override
  String get pressReplyPromiseQualify2 => 'ทีมนี้จะได้ไปรอบสุดท้าย';

  @override
  String get pressReplyFearNobody1 => 'เราไม่กลัวใคร';

  @override
  String get pressReplyFearNobody2 => 'พวกเขาก็ต้องเจอเราเหมือนกัน';

  @override
  String get pressReplyRespectRival1 => 'พวกเขาเป็นเต็ง และเราให้เกียรติพวกเขา';

  @override
  String get pressReplyRespectRival2 => 'ทีมที่ดีมาก เราต้องเล่นให้ดีที่สุด';

  @override
  String get pressReplyTeamFirst1 => 'มันเกี่ยวกับทั้งทีม ไม่ใช่ผู้เล่นคนเดียว';

  @override
  String get pressReplyTeamFirst2 => 'ไม่มีใครชนะได้คนเดียว';

  @override
  String pressOnRecordTarget(String aim) {
    return 'บันทึกไว้แล้ว: $aim';
  }

  @override
  String get pressOnRecordPlayDown => 'บันทึกไว้แล้ว: ไม่มีคำสัญญา';

  @override
  String get pressThrowbackTargetKeptWarm =>
      'คุณตั้งเป้าก่อนแคมเปญและทำได้ นี่คือช่วงเวลาที่ภูมิใจที่สุดหรือยัง?';

  @override
  String get pressThrowbackTargetKeptNeutral =>
      'คุณบอกว่าจะทำอะไรได้ และคุณก็ทำได้ เคยมีข้อสงสัยไหม?';

  @override
  String get pressThrowbackTargetKeptHostile =>
      'คุณทำได้ตามเป้าที่ตั้งไว้ โชคช่วย หรือเป็นแผนจริงๆ?';

  @override
  String get pressThrowbackTargetBrokenWarm =>
      'คุณตั้งเป้าแต่ไปไม่ถึง อะไรผิดพลาด?';

  @override
  String get pressThrowbackTargetBrokenNeutral =>
      'คุณสัญญาไว้มากกว่าที่ทีมทำได้ คุณเสียใจที่พูดไปไหม?';

  @override
  String get pressThrowbackTargetBrokenHostile =>
      'คุณพูดใหญ่โตก่อนแคมเปญแล้วไปไม่ถึง ทำไมเราต้องเชื่อคุณตอนนี้?';

  @override
  String hubEventPressPreviewSub(String competition) {
    return 'สื่ออยากฟังเป้าหมายของคุณใน $competition';
  }

  @override
  String deptLevelCost(int level, String amount) {
    return 'ระดับ $level · $amount';
  }

  @override
  String get formOnFire => 'ร้อนแรง';

  @override
  String get formGood => 'ฟอร์มดี';

  @override
  String get formSteady => 'คงที่';

  @override
  String get formPoor => 'ฟอร์มตก';

  @override
  String get formCold => 'เย็นชืด';

  @override
  String get playerFormTitle => 'ฟอร์มและความฟิต';

  @override
  String playerFormAverage(String rating) {
    return 'เฉลี่ย $rating ในเกมล่าสุด';
  }

  @override
  String get playerFormNoGames => 'เกมล่าสุดยังไม่พอจะประเมิน';

  @override
  String playerFormNextMatch(String delta) {
    return 'ค่าพลัง $delta ในนัดถัดไป';
  }

  @override
  String get playerFormNoEffect => 'ค่าพลังไม่เปลี่ยนในนัดถัดไป';

  @override
  String get sideGroupHome => 'หน้าหลัก';

  @override
  String get sideGroupTeam => 'ทีม';

  @override
  String get sideGroupCompetitions => 'รายการแข่งขัน';

  @override
  String get sideGroupFederation => 'สมาคม';

  @override
  String get sideGroupHistory => 'ประวัติ';

  @override
  String get sideInbox => 'กล่องข้อความ';

  @override
  String get sideSquad => 'ทีมชุด';

  @override
  String get sideTactics => 'แทคติก';

  @override
  String get sideMainMenu => 'เมนูหลัก';

  @override
  String get sideCallUps => 'เรียกตัว';

  @override
  String get sideTournaments => 'ทัวร์นาเมนต์';

  @override
  String get sideRanking => 'อันดับ';

  @override
  String get sideResults => 'ผลการแข่งขัน';

  @override
  String get sideFinances => 'การเงิน';

  @override
  String get sideBoard => 'บอร์ด';

  @override
  String get sideManager => 'ผู้จัดการทีมและสตาฟฟ์';

  @override
  String get sideRecords => 'สถิติ';

  @override
  String get sideLegends => 'ตำนาน';

  @override
  String get sideHeadToHead => 'สถิติการพบกัน';

  @override
  String get sideAchievements => 'ความสำเร็จ';

  @override
  String get sideCareer => 'อาชีพ';

  @override
  String get topBarNext => 'ถัดไป';

  @override
  String get topBarDrawPending => 'รอจับสลาก';

  @override
  String get paneFullProfile => 'โปรไฟล์เต็ม';

  @override
  String get panePickPlayer => 'เลือกผู้เล่นเพื่อดูการ์ดที่นี่';

  @override
  String get inboxPickMessage => 'เลือกข้อความเพื่ออ่านที่นี่';

  @override
  String get inboxFilterAll => 'ทั้งหมด';

  @override
  String get panelViewAll => 'ดูทั้งหมด';

  @override
  String get gridViewOverview => 'ภาพรวม';

  @override
  String get gridColCondition => 'สภาพร่างกาย';

  @override
  String get gridColStatus => 'สถานะ';

  @override
  String get gridColRank => 'อันดับ';

  @override
  String get gridColMove => 'เปลี่ยนแปลง';

  @override
  String get gridColNation => 'ชาติ';

  @override
  String get gridColRegion => 'ภูมิภาค';

  @override
  String get gridColPoints => 'คะแนน';

  @override
  String get panePickNation => 'เลือกชาติเพื่อดูสถิติที่นี่';

  @override
  String get resultsCyclesTitle => 'รอบ';

  @override
  String get tourDrawStart => 'เริ่มจับสลาก';

  @override
  String get tourDrawViewGroups => 'ดูกลุ่ม';

  @override
  String get gridColCeiling => 'ศักยภาพสูงสุด';

  @override
  String get gridColYearGain => 'พัฒนา';

  @override
  String get gridColMarkedAt => 'ตอนติดตาม';

  @override
  String get budgetSetupTitle => 'กำหนดงบประมาณ';

  @override
  String get budgetEffectsTitle => 'งบนี้ได้อะไรบ้าง';

  @override
  String get naturalisationTitle => 'การโอนสัญชาติ';

  @override
  String get yTrending => 'กำลังฮิต';

  @override
  String get yVoices => 'เสียงดัง';

  @override
  String get yConversation => 'บทสนทนา';

  @override
  String get allTimeRecordsTitle => 'สถิติโลกตลอดกาล';

  @override
  String get h2hMeetingsTitle => 'การพบกันทุกครั้ง';

  @override
  String get h2hPickOpponent => 'เลือกคู่แข่งเพื่อดูการพบกันทุกครั้งที่นี่';

  @override
  String get savesTitle => 'เซฟ';

  @override
  String get gridColPlayer => 'ผู้เล่น';

  @override
  String get gridColPos => 'ตำแหน่ง';

  @override
  String get gridColActive => 'ยังเล่น';

  @override
  String get gridColMotm => 'MOTM';

  @override
  String get gridColAvg => 'เฉลี่ย';

  @override
  String get gridColOpponent => 'คู่แข่ง';

  @override
  String get gridColStarts => 'ตัวจริง';

  @override
  String get gridColTournaments => 'ทัวร์นาเมนต์';

  @override
  String get gridColDate => 'วันที่';

  @override
  String get gridColLastPlayed => 'เล่นล่าสุด';

  @override
  String get gridColManager => 'ผู้จัดการทีม';

  @override
  String nationsShownCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ชาติ',
      one: '1 ชาติ',
    );
    return '$_temp0';
  }

  @override
  String get nationsSortedByRank => 'เรียงตามอันดับโลก';

  @override
  String get nationsStrength => 'ความแข็งแกร่ง';

  @override
  String nationsStrengthOf(int tier) {
    return '$tier จาก 5';
  }

  @override
  String get nationsSquadOverall => 'ค่าพลังรวมของทีม';

  @override
  String get nationsOpeningBudget => 'งบประมาณเริ่มต้น';

  @override
  String get nationsStarPlayer => 'ผู้เล่นดาวเด่น';

  @override
  String nationsStarTile(String position, int rating) {
    return 'ดาวเด่น $position $rating';
  }

  @override
  String nationsStarAge(int age) {
    return 'อายุ $age';
  }

  @override
  String get nationsBoardExpects => 'บอร์ดคาดหวัง';

  @override
  String nationsManage(String nation) {
    return 'คุม $nation';
  }

  @override
  String get nationsManagerNext => 'ขั้นต่อไปคุณจะตั้งชื่อผู้จัดการทีม';

  @override
  String get playerPageTitle => 'ผู้เล่น';

  @override
  String get nationPageTitle => 'ชาติ';

  @override
  String get friendliesYourGames => 'เกมกระชับมิตรของคุณ';

  @override
  String hubEventInjuryCover(String player) {
    return 'หาตัวแทน $player ที่บาดเจ็บ';
  }

  @override
  String hubEventInjuryCoverSub(int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: 'พัก $matches นัด',
      one: 'พักนัดถัดไป',
    );
    return '$_temp0 เรียกตัวใครสักคน หรือเล่นต่อโดยไม่มีเขา';
  }

  @override
  String get injuryCoverTitle => 'ตัวแทน';

  @override
  String injuryCoverBanner(String player, String position) {
    return '$player ($position) บาดเจ็บ เรียกใครก็ได้จากนอกทีมชุด ตำแหน่งใดก็ได้ หรือเก็บเขาไว้แล้วเล่นต่อ';
  }

  @override
  String injuryCoverConfirm(String player) {
    return 'เรียกตัว $player';
  }

  @override
  String injuryCoverKeep(String player) {
    return 'เก็บ $player ไว้แล้วเล่นต่อ';
  }

  @override
  String get injuryCoverPick => 'เลือกตัวแทน';

  @override
  String get injuryCoverNone => 'ไม่มีผู้เล่นนอกทีมชุดที่ฟิตพอจะเข้าร่วม';

  @override
  String get nationNowRanking => 'อันดับโลก';

  @override
  String get nationNowForm => 'ฟอร์ม';

  @override
  String get nationNowNoForm => 'ยังไม่ได้ลงเล่น';

  @override
  String get nationNowNext => 'นัดถัดไป';

  @override
  String get nationNowNoNext => 'ไม่มีโปรแกรม';

  @override
  String get nationNowSquad => 'ทีมชุด';

  @override
  String get nationNowAgainstYou => 'เจอคุณ';

  @override
  String nationNowRecord(int w, int d, int l) {
    return 'ชนะ $w เสมอ $d แพ้ $l';
  }

  @override
  String get nationNowLastMeeting => 'พบกันครั้งล่าสุด';

  @override
  String nationNowOverall(int value) {
    return 'ค่าพลังรวม $value';
  }

  @override
  String get hubUpcoming => 'เกมที่กำลังจะมาถึง';

  @override
  String get hubFullSchedule => 'โปรแกรมทั้งหมด';

  @override
  String get scheduleTitle => 'โปรแกรมแข่งขัน';

  @override
  String get scheduleToday => 'วันนี้';

  @override
  String get scheduleKnockoutPending => 'รอบน็อกเอาต์ หากผ่านเข้ารอบ';

  @override
  String get scheduleNextRoundPending => 'รอบถัดไป';

  @override
  String scheduleFromDate(String date) {
    return 'ตั้งแต่ $date';
  }

  @override
  String get scheduleHomeShort => 'H';

  @override
  String get scheduleAwayShort => 'A';

  @override
  String get tacticsNoPresetsInMatch =>
      'ยังไม่มีแทคติกที่บันทึกไว้ บันทึกได้จากหน้าแทคติกก่อนเริ่มเกม';

  @override
  String get homeCampaigns => 'แคมเปญ';

  @override
  String get homeContinueCampaign => 'เล่นแคมเปญต่อ';

  @override
  String homeCampaignCycle(String date, int cycle, int total) {
    return '$date · รอบที่ $cycle จาก $total';
  }

  @override
  String get campaignsTitle => 'แคมเปญ';

  @override
  String get campaignTransplantTitle => 'การปลูกถ่าย';

  @override
  String get campaignTransplantTwist =>
      'แปดยอดนักเตะของอิตาลีเปลี่ยนมาเล่นให้ซานมารีโน';

  @override
  String get campaignTransplantGoal => 'ผ่านเข้ารอบชิงแชมป์ยุโรป';

  @override
  String get campaignGrudgeTitle => 'ความแค้น';

  @override
  String get campaignGrudgeTwist => 'จอร์เจียและแอลเบเนีย จับสลากมาเจอกัน';

  @override
  String get campaignGrudgeGoal => 'จบเหนือแอลเบเนียในรอบคัดเลือก';

  @override
  String get campaignTransplantIntro =>
      'ซานมารีโนไม่เคยมีแคมเปญรอบคัดเลือกที่น่าพูดถึง แล้วแปดยอดนักเตะของอิตาลีก็ถือพาสปอร์ตเดินเข้ามา คุณมีหนึ่งรอบเพื่อเปลี่ยนเรื่องแปลกให้กลายเป็นทีม';

  @override
  String get campaignGrudgeIntro =>
      'จอร์เจียและแอลเบเนียถูกจับสลากมาอยู่กลุ่มคัดเลือกเดียวกัน และไม่มีฝ่ายไหนให้อภัยความพ่ายแพ้ จบเหนือแอลเบเนียให้ได้ แล้วดูว่าจะไปได้ไกลแค่ไหน';

  @override
  String get campaignStars1Transplant => 'ผ่านเข้ารอบ';

  @override
  String get campaignStars2Transplant => 'เข้ารอบน็อกเอาต์';

  @override
  String get campaignStars3Transplant => 'คว้าแชมป์ชิงแชมป์ยุโรป';

  @override
  String get campaignStars1Grudge => 'เหนือแอลเบเนีย';

  @override
  String get campaignStars2Grudge => 'และผ่านเข้ารอบ';

  @override
  String get campaignStars3Grudge => 'และชนะพวกเขาสองครั้ง';

  @override
  String get campaignFree => 'ฟรี';

  @override
  String get campaignStart => 'เริ่ม';

  @override
  String get campaignPartOfUnlimited => 'ส่วนหนึ่งของ Unlimited';

  @override
  String get campaignResume => 'เล่นต่อ';

  @override
  String get campaignAbandon => 'ยกเลิก';

  @override
  String get campaignAbandonConfirm =>
      'ยกเลิกการเล่นนี้? ความคืบหน้าจะหายไป แต่ตราประทับของคุณยังอยู่';

  @override
  String get campaignMoveToSaves => 'ย้ายไปที่เซฟ';

  @override
  String get campaignCannotContinue =>
      'โลกของแคมเปญนี้ต่างจากโลกจริงมากเกินกว่าจะเล่นต่อเป็นอาชีพได้';

  @override
  String get campaignMoveSlotsFull => 'ช่องเซฟเต็มแล้ว ลบสักช่องก่อน';

  @override
  String get campaignStampConquered => 'พิชิตแล้ว';

  @override
  String get campaignStampFailed => 'ล้มเหลว';

  @override
  String get campaignDifficultyHard => 'ยาก';

  @override
  String get campaignDifficultyMedium => 'ปานกลาง';

  @override
  String get campaignGoalLabel => 'เป้าหมาย';

  @override
  String get campaignStarsLabel => 'ดาว';

  @override
  String get campaignRunInProgress => 'แคมเปญนี้มีการเล่นค้างอยู่แล้ว';

  @override
  String get campaignVerdictWon => 'พิชิตแล้ว';

  @override
  String get campaignVerdictLost => 'ไม่ใช่ครั้งนี้';

  @override
  String get campaignVerdictContinue => 'ดำเนินการต่อ';

  @override
  String campaignProgressQualifying(String position) {
    return 'รอบคัดเลือก: $position';
  }

  @override
  String campaignProgressRival(String rival, String position) {
    return '$rival: $position';
  }

  @override
  String campaignProgressFinals(String stage) {
    return 'รอบสุดท้าย: $stage';
  }

  @override
  String get campaignRunInNumbers => 'การเล่นเป็นตัวเลข';

  @override
  String campaignRunMeetings(int won, int played) {
    return 'ชนะในการพบกัน: $won จาก $played';
  }

  @override
  String campaignPlace(String which, int n) {
    String _temp0 = intl.Intl.selectLogic(
      which,
      {
        'first': 'อันดับ 1',
        'second': 'อันดับ 2',
        'third': 'อันดับ 3',
        'other': 'อันดับ $n',
      },
    );
    return '$_temp0';
  }

  @override
  String get campaignGuineasTitle => 'ที่สุดแห่งกินี';

  @override
  String get campaignGuineasTwist =>
      'อิเควทอเรียลกินี กินีที่เล็กที่สุดของแอฟริกา สองรอบ';

  @override
  String get campaignGuineasGoal => 'ชนะกินีและกินีบิสเซา';

  @override
  String get campaignGuineasIntro =>
      'มีสามชาติในแอฟริกาที่ใช้ชื่อกินี และอิเควทอเรียลกินีเล็กที่สุด คุณมีสองรอบเพื่อชนะกินีและกินีบิสเซาอย่างน้อยทีมละครั้ง แล้วดูว่าจะไปได้ไกลแค่ไหนในชิงแชมป์แอฟริกา ปาปัวนิวกินี กินีที่สี่ ถูกจองเกมกระชับมิตรไว้แล้ว';

  @override
  String get campaignStars1Guineas => 'ชนะกินีและกินีบิสเซา';

  @override
  String get campaignStars2Guineas => 'และผ่านเข้ารอบชิงแชมป์แอฟริกา';

  @override
  String get campaignStars3Guineas => 'และเข้ารอบ 8 ทีมชิงแชมป์แอฟริกา';

  @override
  String get campaignYoungFinnsTitle => 'ฟินน์รุ่นเยาว์';

  @override
  String get campaignYoungFinnsTwist => 'ยุคทองของวัยรุ่นฟินแลนด์ สามรอบ';

  @override
  String get campaignYoungFinnsGoal => 'ผ่านเข้ารอบชิงแชมป์โลก';

  @override
  String get campaignYoungFinnsIntro =>
      'นักเตะรุ่นใหญ่ของฟินแลนด์ถอยออกไป และยุคทองรุ่นใหม่เข้ามาแทน: ผู้เล่นทุกคนที่คุณเลือกได้อายุไม่เกิน 18 ปี วันนี้ยังดิบ แต่มีพรสวรรค์พอจะเป็นหนึ่งในทีมที่ดีที่สุดในโลก เหมือนคนรุ่นใหม่ของนอร์เวย์ คุณมีสามรอบเพื่อพาพวกเขาไปชิงแชมป์โลก แล้วคว้าแชมป์ชิงแชมป์ยุโรปและชิงแชมป์โลก';

  @override
  String get campaignStars1YoungFinns => 'ผ่านเข้ารอบชิงแชมป์โลก';

  @override
  String get campaignStars2YoungFinns => 'คว้าแชมป์ชิงแชมป์ยุโรป';

  @override
  String get campaignStars3YoungFinns => 'คว้าแชมป์ชิงแชมป์โลก';

  @override
  String get campaignGreenlandTitle => 'ศตวรรษแห่งกรีนแลนด์';

  @override
  String get campaignGreenlandTwist =>
      'กรีนแลนด์เข้ามาแทนที่ซานมารีโนในยุโรป เป็นเวลาร้อยปี';

  @override
  String get campaignGreenlandGoal => 'ผ่านเข้ารอบชิงแชมป์ยุโรป';

  @override
  String get campaignGreenlandIntro =>
      'กรีนแลนด์ไม่เคยลงเล่นเกมทีมชาติอย่างเป็นทางการ ในโลกนี้พวกเขาเข้ามาแทนที่ซานมารีโนในยุโรป และเริ่มต้นจากท้ายสุดของอันดับโลก: นักเตะสมัครเล่น สนามหญ้าเทียม และฤดูกาลที่ถูกบีบอยู่ระหว่างหิมะ คุณมีร้อยปี ยี่สิบห้ารอบ เพื่อไปชิงแชมป์ยุโรป แล้วชิงแชมป์โลก และถ้ากล้าฝัน ก็คว้าแชมป์สักรายการ';

  @override
  String get campaignStars1Greenland => 'ผ่านเข้ารอบชิงแชมป์ยุโรป';

  @override
  String get campaignStars2Greenland => 'ผ่านเข้ารอบชิงแชมป์โลก';

  @override
  String get campaignStars3Greenland => 'คว้าแชมป์ชิงแชมป์ยุโรปหรือชิงแชมป์โลก';

  @override
  String get campaignPro => 'Pro';

  @override
  String campaignProgressCup(String cup, String year, String status) {
    return '$cup $year: $status';
  }

  @override
  String get campaignCupNotQualified => 'ไม่ผ่านเข้ารอบ';

  @override
  String get campaignCupOpen => 'ยังไม่ตัดสิน';

  @override
  String newsYouthTitle1(String name, String level) {
    return '$name โดดเด่นกับทีม $level';
  }

  @override
  String newsYouthTitle2(String name, String level) {
    return 'รายงานอะคาเดมี: $name เตะตา';
  }

  @override
  String newsYouthTitle3(String name, String level) {
    return 'ดาวเด่น $level: $name';
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
      other: '$count ประตู',
    );
    return '$name ยิงได้ $_temp0 ให้ทีม $level ในเกมกับ $opponent ช่วงเกมทีมชาติล่าสุด';
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
      other: '$count ประตู',
    );
    return '$_temp0ของ $name ขณะที่ทีม $level พบกับ $opponent ในช่วงนี้';
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
      other: '$count ประตู',
    );
    return 'ทีม $level พบ $opponent และ $name ยิงได้ $_temp0';
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
      other: '$count ประตู',
    );
    return '$name จ่ายให้เพื่อนยิง $_temp0 ให้ทีม $level ในเกมกับ $opponent และคุมเกมตั้งแต่ต้นจนจบ';
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
      other: '$count แอสซิสต์',
    );
    return 'ทีม $level พบ $opponent ในช่วงนี้ และ $name คือคนชักใย: $_temp0 และฟอร์มที่สตาฟฟ์ยังพูดถึงไม่หยุด';
  }

  @override
  String newsYouthCleanSheet1(String name, String level, String opponent) {
    return '$name ยอดเยี่ยมขณะที่ทีม $level เก็บคลีนชีตได้ในเกมกับ $opponent';
  }

  @override
  String newsYouthCleanSheet2(String name, String level, String opponent) {
    return 'คลีนชีตของทีม $level ในเกมกับ $opponent และ $name คือเหตุผลหลัก';
  }

  @override
  String newsYouthDisplay1(
    String name,
    String level,
    String opponent,
    int mark,
  ) {
    return '$name สร้างความประทับใจให้ทีม $level ในเกมกับ $opponent และสตาฟฟ์ให้คะแนน $mark เต็มสิบ';
  }

  @override
  String newsYouthDisplay2(
    String name,
    String level,
    String opponent,
    int mark,
  ) {
    return 'ทีม $level พบ $opponent ในช่วงนี้ และโค้ชชื่นชม $name: $mark เต็มสิบ คะแนนสูงสุดในทีม';
  }

  @override
  String get newsYouthDevReady1 =>
      'ด้วยฟอร์มนี้ เขาดีพอที่จะได้รับการพิจารณาติดทีมชุดใหญ่แล้ว';

  @override
  String get newsYouthDevReady2 =>
      'สตาฟฟ์เชื่อว่าเขาพร้อมสำหรับฟุตบอลชุดใหญ่แล้ว การตัดสินใจเป็นของคุณ';

  @override
  String get newsYouthDevClose1 =>
      'เขาพัฒนาได้ดีและใกล้จะแทรกเข้าสู่ชุดใหญ่แล้ว';

  @override
  String get newsYouthDevClose2 =>
      'เขาอยู่ไม่ไกลจากทีมชุดใหญ่ อีกฤดูกาลดีๆ ก็อาจทำได้';

  @override
  String get newsYouthDevGrowing1 =>
      'เขาพัฒนาได้ดี แม้ทีมชุดใหญ่ยังห่างอีกก้าวสองก้าว';

  @override
  String get newsYouthDevGrowing2 =>
      'ยังมีงานต้องทำก่อนเขาจะเป็นนักเตะทีมชาติชุดใหญ่ แต่ทุกอย่างกำลังไปถูกทาง';

  @override
  String get newsYouthDevRaw1 =>
      'เขายังดิบและอีกหลายปีกว่าจะได้ลุ้นชุดใหญ่ แต่พรสวรรค์เห็นได้ชัด';

  @override
  String get newsYouthDevRaw2 =>
      'ยังเร็วไป และสตาฟฟ์อะคาเดมีขอความอดทนมากกว่าพาดหัวข่าว';

  @override
  String get newsYouthStrengthGkPhysical =>
      'ระยะเอื้อมและการคุมกรอบเขตโทษคือสิ่งที่ทำให้เขาโดดเด่น';

  @override
  String get newsYouthStrengthGkTechnical =>
      'การรับบอลและการแจกบอลของเขาดีที่สุดที่อะคาเดมีเคยเห็นมาหลายปี';

  @override
  String get newsYouthStrengthGkStamina =>
      'สมาธิของเขาไม่เคยตก และคมในนาทีที่เก้าสิบเท่ากับนาทีแรก';

  @override
  String get newsYouthStrengthDefPhysical =>
      'ความเร็วและลูกกลางอากาศคือหัวใจของเกมเขา';

  @override
  String get newsYouthStrengthDefTechnical =>
      'เขาอ่านเกมได้เกินวัยและนิ่งเมื่อมีบอล';

  @override
  String get newsYouthStrengthDefStamina =>
      'เขาไม่เคยหลุดโฟกัส และยังวิ่งกลับมาช่วยในนาทีสุดท้าย';

  @override
  String get newsYouthStrengthMidPhysical =>
      'เขาแย่งบอลคืนด้วยพละกำลังจริงๆ และพาบอลขึ้นหน้า';

  @override
  String get newsYouthStrengthMidTechnical =>
      'วิสัยทัศน์และระยะการจ่ายบอลคือหัวใจของเกมเขา';

  @override
  String get newsYouthStrengthMidStamina =>
      'ความอึดของเขาน่าทึ่ง: วิ่งคลุมทุกตารางนิ้ว';

  @override
  String get newsYouthStrengthFwdPhysical =>
      'ความเร็วในการทะลุแนวหลังและพลังในลูกกลางอากาศทำให้เขาเป็นปัญหาสำหรับทุกแนวรับ';

  @override
  String get newsYouthStrengthFwdTechnical =>
      'การจบสกอร์และการเคลื่อนที่ในกรอบเขตโทษคือหัวใจของเกมเขา';

  @override
  String get newsYouthStrengthFwdStamina =>
      'เขาเพรสซิ่งจากแนวหน้าตลอดเกมและไม่เคยให้กองหลังได้พัก';

  @override
  String pressMomentBigWinWarm3(String opponent) {
    return 'แฟนบอลจะร้องเพลงถึงเกมกับ $opponent ไปอีกนาน คุณพูดอะไรกับนักเตะตอนนกหวีดยาว?';
  }

  @override
  String pressMomentBigWinNeutral3(String opponent) {
    return 'นั่นคือการประกาศศักดาเหนือ $opponent ส่วนไหนที่มาจากสนามซ้อม?';
  }

  @override
  String pressMomentBigWinHostile3(String opponent) {
    return 'ยกเครดิตให้กับผลการแข่งขันกับ $opponent แต่เราเคยเห็นคืนแบบนี้มาแล้ว ครั้งนี้ต่างไปอย่างไร?';
  }

  @override
  String pressMomentBigLossWarm3(String opponent) {
    return 'ทุกคนมีคืนที่แย่ และนั่นคือหนึ่งในนั้นกับ $opponent คุณจะลืมมันได้เร็วแค่ไหน?';
  }

  @override
  String pressMomentBigLossNeutral3(String opponent) {
    return '$opponent ดีกว่าในทุกด้าน คุณจะเริ่มแก้จากตรงไหน?';
  }

  @override
  String pressMomentBigLossHostile3(String opponent) {
    return 'แฟนบอลเดินออกจากสนามก่อนจบเกมกับ $opponent คุณโทษพวกเขาได้ไหม?';
  }

  @override
  String pressMomentCrisisWarm3(String opponent) {
    return 'ช่วงนี้ยากลำบาก และ $opponent ก็ไม่ได้ช่วยให้ง่ายขึ้น อะไรทำให้คุณยังสู้ต่อ?';
  }

  @override
  String pressMomentCrisisNeutral3(String opponent) {
    return 'อีกเกมที่ไม่ชนะ คราวนี้กับ $opponent จะเป็นแบบนี้ได้อีกนานแค่ไหนก่อนบอร์ดจะลงมือ?';
  }

  @override
  String pressMomentCrisisHostile3(String opponent) {
    return '$opponent อีกทีม แผนของคุณยังเหลืออะไรไหม หรือถึงเวลาหลีกทางให้คนอื่นแล้ว?';
  }

  @override
  String get pressReplyCreditPlayers5 =>
      'จะเขียนอะไรก็เขียนถึงนักเตะ พวกเขาสมควรได้รับ';

  @override
  String get pressReplyCreditPlayers6 =>
      'ผมมีกลุ่มนักเตะที่พร้อมวิ่งชนกำแพงเพื่อกันและกัน นั่นไม่ใช่เรื่องเล็ก';

  @override
  String get pressReplyTakeResponsibility5 =>
      'ผมเป็นคนตัดสินใจ คำวิจารณ์จึงมาที่ผม นั่นคืองาน';

  @override
  String get pressReplyTakeResponsibility6 =>
      'มองที่ผู้จัดการทีมก่อน ผมทำพลาดหลายอย่างและผมจะแก้ไข';

  @override
  String get pressReplyDemandMore5 =>
      'แค่ดียังไม่พอที่นี่ ผมบอกพวกเขาต่อหน้าแล้ว';

  @override
  String get pressReplyDemandMore6 =>
      'ไม่มีใครในห้องแต่งตัวที่การันตีเสื้อตัวจริง ตอนนี้พวกเขารู้แล้ว';

  @override
  String get pressReplyDeflect5 => 'ถามได้สามแบบ ก็จะได้คำตอบเดิม';

  @override
  String get pressReplyDeflect6 => 'ผมจะเก็บความคิดไว้ให้นักเตะ คุณคงเข้าใจ';

  @override
  String yWinRoutine12(String opponent, String score) {
    return '$score ใส่ $opponent นิ่ง คุมเกม ฟุตบอลแบบผู้ใหญ่ ชอบมาก';
  }

  @override
  String yWinRoutine13(String opponent, String score) {
    return 'ชนะ $opponent $score แบบไม่เสียเหงื่อ ทีมนี้เริ่มเก่งเรื่องน่าเบื่อ และความน่าเบื่อคว้าแชมป์ได้';
  }

  @override
  String yWinRoutine14(String opponent, String score) {
    return '$opponent $score สามแต้ม ไม่มีดราม่า กลับไปทำงาน';
  }

  @override
  String yWinRoutine15(String opponent, String score) {
    return '$score ตามปกติใส่ $opponent ไม่มีใครจำได้ และไม่จำเป็นต้องจำ';
  }

  @override
  String yWinRoutine16(String opponent, String score) {
    return '$score ใส่ $opponent แต่ไม่รู้ทำไมผมยังกังวลอยู่';
  }

  @override
  String yWinRoutine17(String opponent, String score) {
    return 'ชนะ $opponent $score เจอทีมจริงๆ ฟอร์มแบบนี้โดนลงโทษแน่';
  }

  @override
  String yWinTight12(String opponent, String score) {
    return '$score ใส่ $opponent กัดฟัน ทรมาน ชนะ นี่แหละทีม';
  }

  @override
  String yWinTight13(String opponent, String score) {
    return 'ชนะ $opponent $score ด้วยใจล้วนๆ ผมเอาทีมที่ไม่ยอมแพ้';
  }

  @override
  String yWinTight14(String opponent, String score) {
    return '$opponent $score ลุ้นจนวินาทีสุดท้าย แต่แต้มเป็นของเรา';
  }

  @override
  String yWinTight15(String opponent, String score) {
    return '$score เฉือน $opponent ไม่ห่างกันมาก และนั่นคือฟุตบอล';
  }

  @override
  String yWinTight16(String opponent, String score) {
    return '$score ใส่ $opponent ถ้าบอลเด้งผิดทางสักครั้ง เราคงคุยกันคนละเรื่อง';
  }

  @override
  String yWinTight17(String opponent, String score) {
    return 'ประคองตัวรอดกับ $opponent $score ไม่ควรมีใครเรียกนั่นว่าผลงาน';
  }

  @override
  String yDrew12(String opponent, String score) {
    return '$score กับ $opponent ไม่แพ้ และบางวันนั่นก็คืองาน';
  }

  @override
  String yDrew13(String opponent, String score) {
    return 'หนึ่งแต้มที่ได้มาอย่างยากลำบากจาก $opponent $score ชอบความสู้ของเรา';
  }

  @override
  String yDrew14(String opponent, String score) {
    return '$opponent $score สูสีกัน อย่างที่นักพากย์รุ่นเก่าเคยพูด';
  }

  @override
  String yDrew15(String opponent, String score) {
    return '$score กับ $opponent ไม่มีฝ่ายไหนทำมากพอจะได้มากกว่านี้';
  }

  @override
  String yDrew16(String opponent, String score) {
    return '$score กับ $opponent การเสมอแบบที่รู้สึกเหมือนแพ้บนรถกลับบ้าน';
  }

  @override
  String yDrew17(String opponent, String score) {
    return 'เสมอ $opponent $score เราพูดถึงความก้าวหน้าตลอด แล้วก็ทำแบบนี้ตลอด';
  }

  @override
  String yLost12(String opponent, String score) {
    return '$score ให้ $opponent เจ็บ แต่ผมเห็นมากพอจะเชื่อในทีมนี้';
  }

  @override
  String yLost13(String opponent, String score) {
    return 'แพ้ $opponent $score และพวกเขาเก่งจริง ยอมรับแล้วสู้ใหม่';
  }

  @override
  String yLost14(String opponent, String score) {
    return '$opponent $score พ่ายแพ้ ได้บทเรียนนิดหน่อย และเกมหน้าก็มาถึงในไม่ช้า';
  }

  @override
  String yLost15(String opponent, String score) {
    return 'แพ้ $opponent $score เถียงยาก';
  }

  @override
  String yLost16(String opponent, String score) {
    return '$score ให้ $opponent พลาดซ้ำเดิมเหมือนครั้งก่อน ด้วยความมั่นใจเท่าเดิม';
  }

  @override
  String yLost17(String opponent, String score) {
    return 'แพ้ $opponent $score ถ้าไม่มีใครรับผิดชอบเรื่องนี้ เราทำอะไรกันอยู่?';
  }

  @override
  String get yReactionShrug12 => 'โอเคสำหรับผม ไม่ใช่ทุกคืนที่ต้องมีพลุ';

  @override
  String get yReactionShrug13 => 'แต้มก็คือแต้ม คืนนี้หลับสบาย';

  @override
  String get yReactionShrug14 => 'ดูแล้ว ไม่มีอะไรจะติ';

  @override
  String get yReactionShrug15 => 'อยู่ระหว่างโอเคกับโอเค';

  @override
  String get yReactionShrug16 =>
      'จ่ายค่าสตรีมเพื่อดูสิ่งนั้น ไม่อีกแล้ว (เดี๋ยวก็กลับมา)';

  @override
  String get yReactionShrug17 =>
      'เก้าสิบนาทีของความว่างเปล่าที่หน้าตาเหมือนฟุตบอล';

  @override
  String get yReactionRelief12 =>
      'หายใจได้อีกครั้ง ภูมิใจที่พวกเขาประคองไว้ได้';

  @override
  String get yReactionRelief13 =>
      'ชัยชนะแบบนี้แหละที่สร้างทีม น่าเกลียดคือความงาม';

  @override
  String get yReactionRelief14 => 'เล็บหมดแล้ว แต่แต้มยังอยู่';

  @override
  String get yReactionRelief15 => 'เสียงนกหวีดยาวไม่เคยไพเราะขนาดนี้';

  @override
  String get yReactionRelief16 => 'ดีใจที่ชนะ กังวลกับวิธีที่ชนะ';

  @override
  String get yReactionRelief17 => 'เรารอดมาได้เรื่อยๆ สักวันจะไม่รอด';

  @override
  String get yReactionFury12 => 'ผมรักทีมนี้ และนั่นคือเหตุผลที่มันเจ็บ';

  @override
  String get yReactionFury13 =>
      'คืนที่แย่ ครั้งหน้าพวกเขาติดหนี้เรา และพวกเขารู้ดี';

  @override
  String get yReactionFury14 => 'ปิดทีวีตอนนาทีที่เจ็ดสิบ น่าจะปิดตั้งแต่หกสิบ';

  @override
  String get yReactionFury15 => 'ไม่สู้ ไม่มีไอเดีย ไม่มีข้ออ้าง';

  @override
  String get yReactionFury16 => 'ปัญหาเดิมทุกครั้ง และไม่มีใครแก้อะไรเลย';

  @override
  String get yReactionFury17 => 'ใครสักคนในสมาคมต้องดูเกมนั้นซ้ำแล้วอธิบาย';

  @override
  String get backupShareHint =>
      'สร้างไฟล์สำรองหนึ่งไฟล์จากทุกเซฟ เลือก Google Drive, iCloud Drive หรือ Files เพื่อเก็บไว้';

  @override
  String backupLastAt(String date) {
    return 'สำรองล่าสุด: $date';
  }

  @override
  String get backupNever => 'ยังไม่เคยสำรอง';

  @override
  String get backupRemindersTitle => 'การแจ้งเตือนสำรองข้อมูล';

  @override
  String get backupRemindersBlurb =>
      'ข้อความในกล่องข้อความเมื่อการสำรองครั้งล่าสุดเริ่มเก่า';

  @override
  String get backupAutoICloudTitle => 'สำรองอัตโนมัติไปที่ iCloud';

  @override
  String get backupAutoDriveTitle => 'สำรองอัตโนมัติไปที่ Google Drive';

  @override
  String get backupAutoBlurb =>
      'สำรองหลังจบเกม เมื่อจบรอบ และเมื่อคุณออกจากแอป เก็บไว้สองไฟล์ล่าสุด';

  @override
  String get backupStatusUploading => 'กำลังสำรอง';

  @override
  String get backupStatusUploaded => 'สำรองแล้ว';

  @override
  String get backupStatusICloudSignedOut =>
      'iCloud ปิดอยู่ ลงชื่อเข้าใช้ iCloud และเปิด iCloud Drive ในแอปการตั้งค่า';

  @override
  String get backupStatusDriveSignedOut =>
      'ยังไม่ได้ลงชื่อเข้าใช้ เปิดสวิตช์เพื่อลงชื่อเข้าใช้ด้วย Google';

  @override
  String get backupStatusNotConfigured => 'ยังไม่พร้อมใช้งานในแอปเวอร์ชันนี้';

  @override
  String get backupStatusUnavailable =>
      'เชื่อมต่อคลาวด์ไม่ได้ในขณะนี้ จะลองใหม่ภายหลัง';

  @override
  String get backupStatusFailed =>
      'การสำรองอัตโนมัติครั้งล่าสุดไม่สำเร็จ จะลองใหม่ภายหลัง';

  @override
  String backupDriveSignedInAs(String email) {
    return 'ลงชื่อเข้าใช้เป็น $email';
  }

  @override
  String get backupDriveSignOut => 'ออกจากระบบ';

  @override
  String get backupDriveSignInFailed =>
      'ลงชื่อเข้าใช้ Google ไม่สำเร็จ ลองใหม่ภายหลัง';

  @override
  String get backupRestoreICloud => 'กู้คืนจาก ICLOUD';

  @override
  String get backupRestoreDrive => 'กู้คืนจาก GOOGLE DRIVE';

  @override
  String get backupCrossPlatformHelp =>
      'ย้ายระหว่าง iPhone กับ Android? สำรองเป็นไฟล์บนเครื่องหนึ่ง แล้วกู้คืนจากไฟล์นั้นบนอีกเครื่อง';

  @override
  String get backupCloudListBlurb =>
      'ไฟล์สำรองจากอุปกรณ์ของคุณในบัญชีนี้ แตะเพื่อกู้คืน';

  @override
  String get backupCloudListEmpty =>
      'ยังไม่พบไฟล์สำรอง ไฟล์สำรองใหม่อาจใช้เวลาสักครู่กว่าจะไปถึงอุปกรณ์อื่น';

  @override
  String get backupCloudListFailed =>
      'อ่านไฟล์สำรองไม่ได้ ตรวจสอบการเชื่อมต่อแล้วลองอีกครั้ง';

  @override
  String get backupCloudThisDevice => 'อุปกรณ์นี้';

  @override
  String backupCloudMore(int count) {
    return 'เซฟเพิ่มเติม: $count';
  }

  @override
  String get backupCloudNewer => 'สร้างจากแอปเวอร์ชันใหม่กว่า อัปเดตแอปก่อน';

  @override
  String get backupCloudDownloading => 'กำลังดึงไฟล์สำรอง';

  @override
  String get backupRestoreSafetyNote =>
      'จะเก็บสำเนาเซฟบนโทรศัพท์เครื่องนี้ไว้ก่อน';

  @override
  String get backupRejectedSafety =>
      'เก็บสำเนาเซฟปัจจุบันไม่ได้ จึงไม่มีการแทนที่ใดๆ';

  @override
  String get newsBackupReminderTitle => 'ถึงเวลาสำรองข้อมูล';

  @override
  String get newsBackupReminderBody =>
      'เซฟของคุณอยู่บนโทรศัพท์เครื่องนี้เท่านั้น เปิดการตั้งค่าแล้วแตะ สำรองขึ้นคลาวด์ หรือเปิดการสำรองอัตโนมัติที่นั่น ปิดการแจ้งเตือนนี้ได้ในการตั้งค่าเช่นกัน';

  @override
  String get backupSafetyTitle => 'สำเนาก่อนการกู้คืน';

  @override
  String get backupSafetyBlurb =>
      'เก็บไว้บนโทรศัพท์เครื่องนี้เผื่อกู้คืนผิดไฟล์ เก็บไว้สามไฟล์ล่าสุด';

  @override
  String get backupSafetyRestore => 'กู้คืน';

  @override
  String get backupSafetyShare => 'แชร์';

  @override
  String get backupCloudNoDetails => 'รายละเอียดกำลังตามมา';

  @override
  String get tacticsLibraryTitle => 'คลังแทคติก';

  @override
  String get tacticsLibraryBlurb =>
      'แทคติกในคลังโหลดใช้ได้ในทุกเซฟ รวมถึงเซฟใหม่ บทบาทและผู้เตะลูกตั้งเตะจะเก็บตามตำแหน่ง ไม่ใช่ตามผู้เล่น';

  @override
  String get tacticsSaveToLibrary => 'บันทึกลงคลัง';

  @override
  String get tacticsLoadFromLibrary => 'โหลดจากคลัง';

  @override
  String get tacticsLibraryEmpty =>
      'คลังของคุณยังว่าง บันทึกแทคติกไว้ที่นี่แล้วโหลดใช้ได้ในทุกเซฟ';

  @override
  String tacticsLibrarySaved(String name) {
    return 'บันทึก “$name” ลงคลังแล้ว';
  }

  @override
  String tacticsLibraryLoaded(String name) {
    return 'โหลด “$name” แล้ว';
  }

  @override
  String tacticsLibraryNotFitted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'บทบาทหรือผู้เตะลูกตั้งเตะ $count รายการไม่เข้ากับทีมชุดนี้',
      one: 'บทบาทหรือผู้เตะลูกตั้งเตะ 1 รายการไม่เข้ากับทีมชุดนี้',
    );
    return '$_temp0';
  }

  @override
  String get tacticsLibraryRename => 'เปลี่ยนชื่อ';

  @override
  String get tacticsLibraryRenameTitle => 'เปลี่ยนชื่อแทคติก';

  @override
  String get tacticsLibraryDelete => 'ลบ';

  @override
  String tacticsLibraryDeleteTitle(String name) {
    return 'ลบ “$name”?';
  }

  @override
  String get tacticsLibraryDeleteBody =>
      'แทคติกนี้จะหายไปจากคลังในทุกเซฟของคุณ';

  @override
  String get tacticsLibraryNameTaken => 'คลังของคุณมีแทคติกชื่อนี้อยู่แล้ว';

  @override
  String tacticsLibraryCouldNotLoad(String error) {
    return 'โหลดคลังไม่ได้\n$error';
  }

  @override
  String hostBidHeading(String competition, int year) {
    return 'เสนอตัวเป็นเจ้าภาพ: $competition $year';
  }

  @override
  String get hostBidScreenTitle => 'เสนอตัวเป็นเจ้าภาพ';

  @override
  String get hostBidBlurb =>
      'เจ้าภาพจะถูกเลือกด้วยการจับสลากจากชาติที่สมัคร การเสนอตัวช่วยเพิ่มน้ำหนักให้ชาติของคุณ สนามของคุณให้โอกาสตั้งต้น และเงินช่วยเพิ่มโอกาส โดยทุกหนึ่งล้านที่เพิ่มขึ้นจะมีผลน้อยลงทีละนิด เงินจะถูกใช้ไปไม่ว่าจะได้เป็นเจ้าภาพหรือไม่';

  @override
  String hostBidPrize(String amount) {
    return 'หากชนะ คุณจะได้เป็นเจ้าภาพ ผ่านเข้ารอบสุดท้ายอัตโนมัติ และได้รับเงินสนับสนุนครั้งเดียว $amount สำหรับงบประมาณครั้งถัดไป';
  }

  @override
  String get hostBidChance => 'โอกาสได้เป็นเจ้าภาพ';

  @override
  String get hostBidBaseLabel => 'สนามและสถานะ';

  @override
  String get hostBidInvestLabel => 'การลงทุน';

  @override
  String hostBidCeiling(String nation, String percent) {
    return 'เพดานของ $nation: $percent';
  }

  @override
  String get hostBidInvestment => 'เงินลงทุนของคุณ';

  @override
  String hostBidFreeFunds(String amount) {
    return 'เงินทุนคงเหลือ: $amount';
  }

  @override
  String get hostBidSubmit => 'ยื่นเสนอตัว';

  @override
  String get hostBidDecline => 'ไม่ใช่ครั้งนี้';

  @override
  String get hostBidUnavailable => 'การเสนอตัวนี้ปิดไปแล้ว';

  @override
  String hostBidWonTitle(String competition, int year) {
    return 'ชนะการเสนอตัว: $competition $year';
  }

  @override
  String hostBidWonBody(String amount) {
    return 'เราจะเป็นเจ้าภาพทัวร์นาเมนต์และผ่านเข้ารอบอัตโนมัติในฐานะเจ้าภาพ เงินสนับสนุนครั้งเดียว $amount เข้าสู่เงินทุนของสมาคมแล้ว และคุณจัดสรรให้ฝ่ายต่าง ๆ ของรอบนี้ได้ทันทีจากศูนย์กลาง';
  }

  @override
  String hostBidLostTitle(String competition, int year) {
    return 'แพ้การเสนอตัว: $competition $year';
  }

  @override
  String hostBidLostBody(String hosts) {
    return '$hosts ได้สิทธิ์เป็นเจ้าภาพ การเสนอตัวของเรายังไม่พอในครั้งนี้ และเงินที่ใช้ไปก็หมดไปแล้ว แต่สมาคมได้แสดงจุดยืนอย่างเต็มที่';
  }

  @override
  String get hostBidGrantEvent => 'จัดสรรเงินสนับสนุนเจ้าภาพ';

  @override
  String hostBidGrantBanner(String amount) {
    return 'เงินสนับสนุนเจ้าภาพ: $amount เพิ่มให้ฝ่ายต่าง ๆ ของรอบนี้ได้เลย ส่วนที่ตั้งไว้แล้วยังคงเดิม และเงินที่เหลือจะเก็บไว้ในคลัง';
  }

  @override
  String get stadiumsTitle => 'สนามกีฬาแห่งชาติ';

  @override
  String get stadiumsEntrySub => 'ปรับปรุงสนามหรือสร้างสนามใหม่';

  @override
  String get stadiumsBlurb =>
      'ระดับของสนามคือขนาด: ระดับ 1 ต่ำกว่า 15,000 ที่นั่ง ระดับ 2 ตั้งแต่ 15,000 ระดับ 3 ตั้งแต่ 25,000 ระดับ 4 ตั้งแต่ 40,000 ระดับ 5 ตั้งแต่ 60,000 ทุกสนามสร้างรายได้เล็กน้อยเมื่อเริ่มแต่ละรอบ ยิ่งที่นั่งมากยิ่งได้มาก ตราบที่แฟนบอลเติมเต็มได้ การขยายเพิ่มที่นั่งทันทีและเพิ่มชื่อเสียงเล็กน้อยตั้งแต่รอบถัดไป การลดขนาดช่วยลดค่าดูแลรักษาแต่ไม่มีเงินคืน สนามของคุณเป็นตัวกำหนดว่าเสนอตัวเป็นเจ้าภาพรายการใดได้บ้าง';

  @override
  String stadiumsIncome(String amount) {
    return 'รายได้จากสนาม: $amount ต่อรอบ';
  }

  @override
  String stadiumsReputation(int points) {
    return 'ชื่อเสียงจากสนาม: +$points';
  }

  @override
  String get stadiumsClosed =>
      'สั่งงานก่อสร้างได้ตอนเริ่มรอบ ก่อนกำหนดงบประมาณ';

  @override
  String stadiumsCapacity(String seats) {
    return 'ความจุ: $seats';
  }

  @override
  String stadiumsLevel(int level, int max) {
    return 'ระดับ $level/$max';
  }

  @override
  String stadiumsUpgrade(String cost) {
    return 'ปรับปรุง: $cost';
  }

  @override
  String get stadiumsTopLevel => 'ระดับสูงสุด';

  @override
  String stadiumsOpens(int year) {
    return 'กำลังก่อสร้าง เปิดใช้ปี $year';
  }

  @override
  String get stadiumsBuildTitle => 'สร้างสนามใหม่';

  @override
  String get stadiumsBuildBody =>
      'ค่อนข้างแพง: สนามใหม่ในเมืองที่คุณเลือก เปิดใช้ตั้งแต่เริ่มรอบถัดไป';

  @override
  String get stadiumsBuildCity => 'เมือง';

  @override
  String stadiumsBuildButton(String cost) {
    return 'สร้าง: $cost';
  }

  @override
  String get stadiumsBuilding => 'มีสนามที่กำลังก่อสร้างอยู่แล้ว';

  @override
  String get stadiumsNoCity => 'ทุกเมืองมีสนามใหม่แล้ว';

  @override
  String stadiumsConfirmUpgrade(String stadium, int level, String cost) {
    return 'ปรับปรุง $stadium เป็นระดับ $level ด้วยเงิน $cost หรือไม่?';
  }

  @override
  String stadiumsConfirmBuild(String city, String cost) {
    return 'สร้างสนามใหม่ใน $city ด้วยเงิน $cost หรือไม่?';
  }

  @override
  String get stadiumsConfirm => 'ยืนยัน';

  @override
  String get stadiumsCancel => 'ยกเลิก';

  @override
  String get stadiumsRefused => 'คำสั่งไม่สำเร็จ ไม่มีการหักเงิน';

  @override
  String get stadiumsNameLabel => 'ชื่อสนาม';

  @override
  String get stadiumsNameHint => 'เว้นว่างไว้เพื่อใช้ชื่อที่แนะนำ';

  @override
  String get stadiumsRename => 'เปลี่ยนชื่อสนาม';

  @override
  String get hostBidSectionTitle => 'การเสนอตัวเป็นเจ้าภาพ';

  @override
  String get hostBidOpenSub => 'ไม่บังคับ ตัดสินใจก่อนเริ่มรอบใหม่';

  @override
  String get hostBidDecidedAtRollover => 'จะประกาศเจ้าภาพเมื่อเริ่มรอบใหม่';

  @override
  String get hostBidLodged =>
      'ยื่นเสนอตัวแล้ว จะประกาศเจ้าภาพเมื่อเริ่มรอบใหม่';

  @override
  String get hostBidDeclinedNote => 'ครั้งนี้คุณเลือกไม่เสนอตัว';

  @override
  String get hostBidOpensLater => 'มีสิทธิ์ เสนอตัวได้เมื่อจบรอบนี้';

  @override
  String get hostBidNoFunds => 'เงินทุนคงเหลือไม่พอสำหรับการเสนอตัว';

  @override
  String hostBidNeedStadiums(int count, String seats) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ต้องมีสนามความจุ $seats+ ที่นั่งเพิ่มอีก $count แห่ง',
      one: 'ต้องมีสนามความจุ $seats+ ที่นั่งเพิ่มอีก 1 แห่ง',
    );
    return '$_temp0';
  }

  @override
  String hostBidBarredConf(String confederation) {
    return '$confederation เป็นเจ้าภาพชิงแชมป์โลกครั้งล่าสุด';
  }

  @override
  String get hostBidRecentHost => 'คุณเป็นเจ้าภาพหนึ่งในสามครั้งล่าสุด';

  @override
  String hostBidRequirement(
    int grounds,
    String minSeats,
    int bigGrounds,
    String bigSeats,
  ) {
    return 'เงื่อนไข: สนามความจุ $minSeats+ ที่นั่ง $grounds แห่ง ในจำนวนนี้ $bigGrounds แห่งต้องจุ $bigSeats+';
  }

  @override
  String hostBidWonBodyBudget(String amount) {
    return 'เราจะเป็นเจ้าภาพการแข่งขันและได้สิทธิ์เข้าร่วมอัตโนมัติในฐานะเจ้าภาพ เงินสนับสนุนครั้งเดียว $amount เข้ามาในเงินทุนของสมาคมแล้ว พร้อมสำหรับงบประมาณรอบนี้';
  }

  @override
  String get hubStadiumIncome => 'รายได้จากสนาม';

  @override
  String get stadiumsDownsize => 'ลดขนาด';

  @override
  String stadiumsConfirmDownsize(String stadium, String seats, int level) {
    return 'ลดขนาด $stadium เหลือ $seats ที่นั่ง (ระดับ $level) หรือไม่? ไม่มีเงินคืน แต่ค่าดูแลรักษาจะลดลง';
  }

  @override
  String get stadiumsResizedThisCycle => 'ปรับปรุงแล้วในรอบนี้';

  @override
  String stadiumsGroundIncome(String amount) {
    return 'สร้างรายได้ $amount ต่อรอบ';
  }

  @override
  String hostBidLapsedTitle(String competition, int year) {
    return 'ถอนการเสนอตัว: $competition $year';
  }

  @override
  String hostBidLapsedBodyNation(String nation) {
    return 'การเสนอตัวทำในนาม $nation แต่คุณเริ่มรอบใหม่ที่อื่น จึงถูกถอนและไม่มีการเรียกเก็บเงิน';
  }

  @override
  String get hostBidLapsedBodyFunds =>
      'เมื่อจบรอบ เงินทุนของสมาคมไม่พอสำหรับเงินเสนอตัวอีกต่อไป การเสนอตัวจึงถูกถอนและไม่มีการเรียกเก็บเงิน';

  @override
  String get stadiumsViewMap => 'แผนที่';

  @override
  String get stadiumsViewList => 'รายการ';

  @override
  String get stadiumsMapPickCity => 'แตะเมืองที่ต้องการสร้างสนามแห่งใหม่';

  @override
  String get stadiumsMapFit => 'แสดงทั้งประเทศ';

  @override
  String get campaignLegacyTitle => 'สานตำนานให้สมบูรณ์';

  @override
  String get campaignLegacyTwist =>
      'สเปน แชมป์ยุโรปคนปัจจุบัน เป็นเวลาหนึ่งรอบ';

  @override
  String get campaignLegacyGoal => 'ป้องกันแชมป์ยุโรป';

  @override
  String get campaignLegacyIntro =>
      'สเปนคือแชมป์ยุโรปคนปัจจุบัน แต่คนที่ยังกังขาบอกว่ายุคทองนั้นเป็นแค่โชคช่วย คุณมีเวลาหนึ่งรอบเพื่อพิสูจน์ว่าไม่ใช่ ป้องกันมงกุฎของทวีปให้ได้ แล้วไปลุ้นแชมป์โลก คว้าเนชันส์คัพเพิ่มอีกรายการ แล้วตำนานจะสมบูรณ์';

  @override
  String get campaignStars1Legacy => 'คว้าแชมป์ชิงแชมป์ยุโรป';

  @override
  String get campaignStars2Legacy => 'และชิงแชมป์โลก';

  @override
  String get campaignStars3Legacy => 'และเนชันส์คัพ';

  @override
  String get campaignSectionOneCycle => 'หนึ่งรอบ';

  @override
  String get campaignSectionShort => 'ไม่กี่รอบ';

  @override
  String get campaignSectionLong => 'ระยะยาว';

  @override
  String get campaignFilterAll => 'ทั้งหมด';

  @override
  String get campaignFilterNew => 'ยังไม่ได้เล่น';

  @override
  String get campaignFilterInProgress => 'กำลังเล่น';

  @override
  String get campaignFilterDone => 'จบแล้ว';

  @override
  String get campaignFilterEmpty => 'ยังไม่มีแคมเปญในหมวดนี้';

  @override
  String campaignStarsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ดาว',
      zero: 'ไม่มีดาว',
    );
    return '$_temp0';
  }

  @override
  String campaignCycles(int cycles) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles รอบ',
    );
    return '$_temp0';
  }

  @override
  String get msgIntlRetireNoteHigh => ' เขาอำลาบนจุดสูงสุดในฐานะแชมป์';

  @override
  String get msgIntlRetireNoteMissed => ' การพลาดรอบสุดท้ายคือฟางเส้นสุดท้าย';

  @override
  String get msgIntlRetireNoteSurprise => ' ไม่มีใครคาดคิดมาก่อน';

  @override
  String get msgIntlRetireNoteRecord => ' เขาจากไปในฐานะเจ้าของสถิติทีมชาติ';

  @override
  String msgIntlRetireNewsTitle(String nation, String name) {
    return '$nation: $name อำลาทีมชาติ';
  }

  @override
  String msgIntlRetireNewsBody(String name, String nation, int age) {
    return '$name ($nation) ประกาศอำลาทีมชาติในวัย $age ปี';
  }

  @override
  String msgIntlComebackTitle(String name) {
    return '$name กลับคืนสู่ทีมชาติ';
  }

  @override
  String msgIntlComebackBody(String name, int age) {
    return '$name พร้อมถูกเรียกติดทีมอีกครั้งในวัย $age ปี';
  }

  @override
  String get msgIntlComebackNoteCrisis =>
      ' ในวันที่ทีมเจ็บระนาว เขาตอบรับการเรียกตัว';

  @override
  String get msgIntlComebackNoteManager => ' กุนซือคนใหม่เกลี้ยกล่อมเขาสำเร็จ';

  @override
  String msgIntlComebackNewsTitle(String nation, String name) {
    return '$nation: $name กลับคืนสู่ทีมชาติ';
  }

  @override
  String msgIntlComebackNewsBody(String name, String nation, int age) {
    return '$name ($nation) พร้อมถูกเรียกติดทีมอีกครั้งในวัย $age ปี';
  }

  @override
  String playerIntlRetired(int year) {
    return 'อำลาทีมชาติ ปี $year';
  }

  @override
  String playerIntlComeback(int year) {
    return 'กลับสู่ทีมชาติ ปี $year';
  }

  @override
  String yLegendRetires0(String name) {
    return 'ขอบคุณ $name บางคนแค่สวมเสื้อ แต่เขาแบกทั้งทีม';
  }

  @override
  String yLegendRetires1(String name) {
    return '$name ปิดฉากเส้นทางทีมชาติ สิ้นสุดยุคสมัย';
  }

  @override
  String yLegendRetires2(String name) {
    return '$name อำลาแล้ว พูดตรงๆ ช้าไปหนึ่งทัวร์นาเมนต์';
  }

  @override
  String yLegendRetires3(String name) {
    return 'สรุป $name พอแล้วสินะ ได้เวลาให้โอกาสเด็กๆ';
  }

  @override
  String matchAltitudeOpponentsTire(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'ความสูง $altitudeString ม.: คู่แข่งจะเหนื่อยเร็วขึ้น';
  }

  @override
  String matchAltitudeYouTire(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'ความสูง $altitudeString ม.: นักเตะของคุณจะเหนื่อยเร็วขึ้น';
  }

  @override
  String matchAltitudeBothTire(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'ความสูง $altitudeString ม.: ทั้งสองทีมจะเหนื่อยเร็วขึ้น';
  }

  @override
  String matchAltitudeUsedTo(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'ความสูง $altitudeString ม.: ทั้งสองทีมคุ้นเคยแล้ว';
  }

  @override
  String matchHeatExpected(int temp) {
    final intl.NumberFormat tempNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String tempString = tempNumberFormat.format(temp);

    return 'อากาศร้อน: คาดว่า $tempString°C แรงจะหมดเร็วขึ้น';
  }

  @override
  String get matchConditionsAdvice =>
      'วางแผนเปลี่ยนตัวแต่เนิ่นๆ: ที่นี่ขาที่สดกว่ามีค่ามากขึ้น';

  @override
  String get fanMoodFurious => 'โกรธจัด';

  @override
  String get fanMoodRestless => 'กระสับกระส่าย';

  @override
  String get fanMoodCalm => 'สงบ';

  @override
  String get fanMoodUpbeat => 'มีความหวัง';

  @override
  String get fanMoodEuphoric => 'คลั่งไคล้';

  @override
  String matchHomeFans(String mood) {
    return 'แฟนบอลเจ้าบ้าน: $mood';
  }

  @override
  String federationFans(String mood) {
    return 'แฟนบอล: $mood';
  }

  @override
  String federationFansIncome(String change) {
    return 'รายได้สนามในรอบถัดไป: $change';
  }

  @override
  String yFansProtest0(String nation, String manager) {
    return 'ตามทีมชาติทั้งเหย้าและเยือนมายี่สิบปี จะไม่ต่อตั๋วปีจนกว่าจะมีอะไรเปลี่ยน';
  }

  @override
  String yFansProtest1(String nation, String manager) {
    return 'เราจะร้องเพลงเพื่อเสื้อตัวนี้ต่อไป แต่ป้ายผ้าบนอัฒจันทร์ฝั่งเหนือคืนนี้พูดสิ่งที่ทุกคนคิดอยู่';
  }

  @override
  String yFansProtest2(String nation, String manager) {
    return 'สนามว่างไปครึ่งหนึ่ง ส่วนอีกครึ่งที่มาก็ตะโกน #${manager}Out ตลอดครึ่งหลัง';
  }

  @override
  String yFansProtest3(String nation, String manager) {
    return 'กลุ่มแฟนบอลกำลังคุยกันเรื่องบอยคอตเกมเหย้านัดหน้า ยากที่จะโทษพวกเขา';
  }

  @override
  String yFansProtest4(String nation, String manager) {
    return '#${manager}Out ไม่ได้โกรธแล้ว แค่พอแล้ว';
  }

  @override
  String yFansProtest5(String nation, String manager) {
    return 'ภาพจากคืนนี้: ที่นั่งว่างเรียงเป็นแถว กับผ้าปูที่นอนหนึ่งผืนเขียนว่า #${manager}Out นี่แหละรายงานการแข่งขัน';
  }

  @override
  String yFansSellOut0(String nation) {
    return 'ตั๋วขายหมดอีกแล้ว ทีมชาติที่ดีที่สุดในรอบหลายปี และทั้งประเทศรู้ดี';
  }

  @override
  String yFansSellOut1(String nation) {
    return 'ตั๋วเกมเหย้านัดหน้าขายหมดในสิบเอ็ดนาที ทีมนี้คืนวันหยุดสุดสัปดาห์ให้พวกเรา';
  }

  @override
  String yFansSellOut2(String nation) {
    return 'เกมเหย้านัดหน้าไม่เหลือที่นั่งว่างสักที่ สมาคมคงนับรายได้ค่าตั๋วไปยิ้มไป';
  }

  @override
  String yFansSellOut3(String nation) {
    return 'ขายหมดอีกนัด จะว่าอะไรเรื่องแท็กติกก็ว่าไป แต่คนอยากไปอยู่ในสนามนั้น';
  }

  @override
  String yFansSellOut4(String nation) {
    return 'ขายหมดก็ดี คนกลุ่มเดียวกันนี้แหละที่โห่ทีมนี้เมื่อปีครึ่งก่อน';
  }

  @override
  String yFansSellOut5(String nation) {
    return 'จู่ๆ ก็ขายหมด จู่ๆ ทุกคนก็เป็นกูรู ตอนที่เราชนะใครไม่ได้เลย พวกคุณอยู่ไหนกัน';
  }

  @override
  String get campaignsIntro =>
      'แคมเปญคือความท้าทายที่ออกแบบมาเป็นพิเศษ: ทีมชาติที่กำหนดไว้ โลกที่มีจุดพลิกผันของตัวเอง และเป้าหมายที่ต้องทำให้ได้ภายในจำนวนรอบที่กำหนด การเล่นแต่ละครั้งแยกจากอาชีพที่บันทึกไว้ และยิ่งไปได้ไกล ยิ่งได้ดาวมากขึ้น สูงสุดสามดวง';

  @override
  String hubEventScandal(String player) {
    return 'ฉาวในแคมป์: $player';
  }

  @override
  String get hubEventScandalSub => 'ส่งกลับบ้านหรือเก็บไว้?';

  @override
  String get scandalTitle => 'ข่าวฉาว';

  @override
  String scandalStoryParty(String player) {
    return '$player ไปปาร์ตี้ที่ลากยาวถึงรุ่งสาง และภาพก็อยู่ในหนังสือพิมพ์ทุกฉบับในเช้าวันที่ทีมรวมตัว';
  }

  @override
  String scandalStoryCurfew(String player) {
    return '$player ฝ่าฝืนเคอร์ฟิวของทีมและถูกจับได้ขณะกลับเข้าโรงแรมตอนเช้ามืด';
  }

  @override
  String scandalStoryNightclub(String player) {
    return '$player ถูกถ่ายภาพในไนต์คลับคืนก่อนเข้าแคมป์ และภาพก็ว่อนไปทั่ว';
  }

  @override
  String scandalStoryCasino(String player) {
    return '$player ใช้เวลาคืนก่อนเข้าแคมป์ที่โต๊ะคาสิโน และแท็บลอยด์ฉบับหนึ่งมีภาพอยู่ในมือ';
  }

  @override
  String get scandalSendHome => 'ส่งกลับบ้าน';

  @override
  String scandalSendHomeCover(String player) {
    return 'ส่งกลับ เรียกตัว $player';
  }

  @override
  String scandalKeep(String player) {
    return 'เก็บ $player ไว้';
  }

  @override
  String get scandalKeepNote =>
      'หากเก็บไว้: ขวัญกำลังใจราว -4 และบอร์ดราว -3 จนจบรอบ';

  @override
  String get scandalSendHomeNote =>
      'หากส่งกลับบ้าน: ไม่กระทบขวัญกำลังใจหรือบอร์ด และคุณเรียกตัวแทนได้';

  @override
  String get scandalFinalsNote =>
      'หากส่งกลับบ้าน: ไม่กระทบขวัญกำลังใจหรือบอร์ด แต่ในทัวร์นาเมนต์รอบสุดท้ายจะไม่มีใครมาแทนได้';

  @override
  String get scandalPickCover => 'เรียกตัวแทน (ไม่บังคับ)';

  @override
  String newsScandalTitle(String player) {
    return 'ฉาวในแคมป์: $player';
  }

  @override
  String yScandalParty0(String player, String tag) {
    return 'วัยรุ่นก็งี้ $player ไปปาร์ตี้คืนก่อนเข้าแคมป์ แต่ผมก็ยังอยากเห็นเขาในสนาม #$tag';
  }

  @override
  String yScandalParty1(String player, String tag) {
    return '$player ถูกถ่ายภาพที่ปาร์ตี้ข้ามคืนไม่กี่ชั่วโมงก่อนทีมรวมตัว สมาคมรับทราบแล้ว #$tag';
  }

  @override
  String yScandalParty2(String player, String tag) {
    return 'ปาร์ตี้ข้ามคืนก่อนเข้าแคมป์ $player คิดอะไรอยู่? ไม่อยากเชื่อ #$tag';
  }

  @override
  String yScandalCurfew0(String player, String tag) {
    return 'กลับเลยเคอร์ฟิว โอเค มันเกิดขึ้นได้ $player แค่ต้องไปแก้ตัวในสนาม #$tag';
  }

  @override
  String yScandalCurfew1(String player, String tag) {
    return '$player ถูกจับได้ขณะกลับโรงแรมของทีมหลังเคอร์ฟิว ไม่กี่ชั่วโมงก่อนซ้อม #$tag';
  }

  @override
  String yScandalCurfew2(String player, String tag) {
    return 'เคอร์ฟิวไม่ใช่เรื่องยาก $player ทนไม่ได้แม้แต่คืนเดียว #$tag';
  }

  @override
  String yScandalNightclub0(String player, String tag) {
    return 'ก็ $player ไปคลับ นักบอลก็มีชีวิตเหมือนกัน ปล่อยให้เขาเล่นเถอะ #$tag';
  }

  @override
  String yScandalNightclub1(String player, String tag) {
    return 'ภาพเผย $player อยู่ในไนต์คลับคืนก่อนเข้าแคมป์ทีมชาติ #$tag';
  }

  @override
  String yScandalNightclub2(String player, String tag) {
    return 'ภาพในคลับคืนก่อนเข้าแคมป์ $player ทำให้เสื้อทีมชาติเสื่อมเสีย #$tag';
  }

  @override
  String yScandalCasino0(String player, String tag) {
    return 'หนึ่งคืนในคาสิโนไม่ใช่อาชญากรรม $player ไม่เป็นไรหรอก #$tag';
  }

  @override
  String yScandalCasino1(String player, String tag) {
    return '$player ถูกพบที่โต๊ะคาสิโนในคืนก่อนทีมรวมตัว #$tag';
  }

  @override
  String yScandalCasino2(String player, String tag) {
    return 'อยู่คาสิโนทั้งคืนก่อนเข้าแคมป์ $player เดิมพันมากกว่าเงิน #$tag';
  }

  @override
  String yScandalSentHome0(String player) {
    return 'ตัดสินใจถูกแล้ว ไม่มีใครใหญ่กว่าทีม รวมถึง $player ด้วย';
  }

  @override
  String yScandalSentHome1(String player) {
    return 'การส่ง $player กลับบ้านคือคำตอบเดียว ขอคารวะโค้ช';
  }

  @override
  String yScandalSentHome2(String player) {
    return 'วินัยก็คือวินัย $player รู้กฎดีอยู่แล้ว';
  }

  @override
  String yScandalSentHome3(String player) {
    return 'สารที่ชัดเจนถึงทีม: $player อยู่บนเครื่องบินกลับบ้านแล้ว';
  }

  @override
  String yScandalSentHome4(String player) {
    return 'แรงเกินไปสำหรับ $player ออกไปเที่ยวคืนเดียวแล้วจบแคมป์เลยเหรอ?';
  }

  @override
  String yScandalSentHome5(String player) {
    return 'ส่ง $player กลับทำให้เราอ่อนลง เราจะต้องจ่ายในสนาม';
  }

  @override
  String yScandalKept0(String player) {
    return 'เก็บ $player ไว้คือการเดิมพัน เขาควรตอบแทนในสนาม';
  }

  @override
  String yScandalKept1(String player) {
    return 'ก็ได้ $player อยู่ต่อ งั้นเขาก็ติดหนี้ทุกคนเป็นฟอร์มดี ๆ';
  }

  @override
  String yScandalKept2(String player) {
    return 'แปลว่ากฎใช้ไม่ได้กับ $player ดีที่ได้รู้';
  }

  @override
  String yScandalKept3(String player) {
    return 'ดูเหมือนเคอร์ฟิวจะเป็นทางเลือกแล้ว ถาม $player ดูสิ';
  }

  @override
  String yScandalKept4(String player) {
    return 'เก็บ $player ไว้หลังเรื่องนั้นเนี่ยนะ? ทีมนี้กลายเป็นค่ายพักร้อนแล้ว';
  }

  @override
  String yScandalKept5(String player) {
    return 'ปาร์ตี้ทั้งคืน แล้วได้ตัวจริงเลย สารดีมากโค้ช $player คงดีใจสุด ๆ';
  }

  @override
  String get yStreamerBreaks0 =>
      'พี่โดนจับได้ 😭😭 คืนก่อนเข้าแคมป์?? ร้องไห้แล้ว 💀💀💀';

  @override
  String get yStreamerBreaks1 =>
      'ไม่จริงงง แชทดูนี่ 🤯🤯 พี่แกทำจริงก่อนเข้าแคมป์ 😭🔥';

  @override
  String get yStreamerBreaks2 =>
      'ใครปล่อยเขาออกไป?? ใครปล่อยออกไป 😭😭💀 นี่มันหนังชัด ๆ 🔥🔥';

  @override
  String get yStreamerSentHome0 =>
      'ส่งกลับบ้าน?? ส่งกลับบ้านจริง!!! 😭😭😭 โค้ชไม่เล่นด้วยแล้ว 💀🔥';

  @override
  String get yStreamerSentHome1 => 'พี่เก็บกระเป๋าสด ๆ 🤯🤯 ลาก่อนพี่ 😭👋';

  @override
  String get yStreamerSentHome2 =>
      'เป็นไปไม่ได้ๆๆ ส่งเขากลับบ้านจริง 💀💀 แชทผมสั่นแล้ว 🔥🔥🔥';

  @override
  String get yStreamerKept0 =>
      'อยู่ต่อ??? อยู่ต่อออ 🤯🤯 พี่แตะต้องไม่ได้ 😭🔥';

  @override
  String get yStreamerKept1 =>
      'ปาร์ตี้ทั้งคืนแต่ยังติดทีม 💀💀 ผมอยากได้สัญญาแบบนั้นบ้าง 😭😭';

  @override
  String get yStreamerKept2 => 'โค้ชบอกว่าโอเค 😭😭 พี่ อะไรเนี่ย 🤯🤯🤯';

  @override
  String get yCameoUjfaloci => 'ผมไม่ได้จ่ายอะไรเลย และตัวเลขนั้นก็ไม่ตรงด้วย';

  @override
  String get yCameoHavir0 => 'ปลาตัวเล็ก ๆ ว่ายหนีไปแล้ว';

  @override
  String get yCameoHavir1 => 'เราเหวี่ยงแห แต่ปลาไปอยู่ที่อื่น';

  @override
  String get yCameoHavir2 => 'ผมพูดไว้ตั้งแต่กันยายนแล้ว ตอนกินกูลาช';

  @override
  String get yCameoHavir3 => 'ใครไม่จับปลาให้ทันเวลา ก็อย่ามาร้องไห้ตอนนี้';

  @override
  String get yCameoHavir4 => 'เราเล่นเหมือนปลาดุกบนบก';

  @override
  String get yCameoHavir5 => 'ลมพัด บ่อน้ำแข็งตัว มันก็เป็นแบบนี้แหละ';

  @override
  String get yCameoHavir6 => 'บางวันก็ได้แค่รองเท้าบูตเก่า ๆ ขึ้นมา';

  @override
  String get yCameoHavir7 =>
      'สมัยผมอย่างน้อยก็ยังไปดื่มเบียร์กัน ตอนนี้แม้แต่นั้นก็ไม่มี';

  @override
  String get yCameoLzimberskyHome0 =>
      'ส่งเด็กกลับบ้านเพราะคืนเดียว? นั่นแหละเรื่องฉาว ไม่ใช่ปาร์ตี้!';

  @override
  String get yCameoLzimberskyHome1 =>
      'เด็ก ๆ ก็มีสิทธิ์สนุกบ้างสิ! สื่อหน้าไหว้หลังหลอกชนะอีกแล้ว';

  @override
  String get yCameoLzimberskyHome2 =>
      'นี่มันการล่าแม่มด หนุ่มคนหนึ่งออกไปคืนเดียว พวกคุณก็แขวนคอเขา';

  @override
  String get yCameoLzimberskyHome3 =>
      'นักข่าวคนไหนไม่เคยไปปาร์ตี้ ก็ขว้างก้อนหินก้อนแรกเลย น่าอาย!';

  @override
  String get yCameoLzimberskyHome4 =>
      'โค้ชกลัวแท็บลอยด์ ถ้าเป็นผม ผมจะปกป้องเด็กคนนั้นจนลมหายใจสุดท้าย!';

  @override
  String get yCameoLzimberskyKept0 =>
      'ในที่สุดก็มีโค้ชที่มีกระดูกสันหลัง! เขาเก็บเด็กไว้ สื่อจะร้องไห้ก็เชิญ';

  @override
  String get yCameoLzimberskyKept1 =>
      'เด็ก ๆ ก็มีสิทธิ์สนุกบ้าง จริงไหม? บราโว่ โค้ช!';

  @override
  String get yCameoLzimberskyKept2 =>
      'สื่อหน้าไหว้หลังหลอกตะโกน โค้ชยืนหยัด ต้องแบบนี้สิ!';

  @override
  String get yCameoLzimberskyKept3 =>
      'ออกไปคืนเดียว สื่อก็อยากขว้างหินใส่ โค้ชคือลูกผู้ชายตัวจริง!';

  @override
  String get yCameoLzimberskyKept4 =>
      'ผมบอกเลย: ปล่อยให้เด็ก ๆ ได้ใช้ชีวิต! ใครทำงานหนักก็มีสิทธิ์สนุก ยกนิ้วให้';

  @override
  String get yTraitStreamer => 'สตรีมทุกอย่าง เสียงดังสุด ตัวพิมพ์ใหญ่ทั้งหมด';

  @override
  String hubEventAwardsCeremony(int year) {
    return 'นักเตะยอดเยี่ยมประจำปี $year';
  }

  @override
  String get hubEventAwardsCeremonySub => 'นับคะแนนโหวตเสร็จแล้ว';

  @override
  String get potyCeremonyWatch => 'ชมพิธีมอบรางวัล';

  @override
  String get potyCeremonySkipToList => 'ข้ามไปที่ 5 อันดับแรก';

  @override
  String get potyCeremonySkip => 'ข้าม';

  @override
  String get potyCeremonyIntro =>
      'นับคะแนนโหวตเสร็จแล้ว นี่คือ 5 นักเตะที่ดีที่สุดในโลกประจำปีนี้';

  @override
  String potyCeremonyPlace(int place) {
    return 'อันดับ $place';
  }

  @override
  String get potyCeremonyWinnerIs => 'และนักเตะยอดเยี่ยมประจำปีคือ...';

  @override
  String get potyTop5Heading => '5 อันดับแรกของโลก';

  @override
  String get potyYoungTop3Heading => 'ดาวรุ่งยอดเยี่ยมประจำปี: 3 อันดับแรก';

  @override
  String get potySeeTop5 => 'ดู 5 อันดับแรก';

  @override
  String get potyYourPlayer => 'นักเตะของคุณ';

  @override
  String potyTallyCleanSheets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'คลีนชีต $count นัด',
    );
    return '$_temp0';
  }

  @override
  String get campaignFullBrief => 'บรีฟฉบับเต็ม';

  @override
  String campaignStarsSoFar(int earned, int total) {
    return 'ดาวที่ได้แล้ว: $earned จาก $total';
  }

  @override
  String get campaignStarEarned => 'ได้แล้ว';

  @override
  String get campaignStarNotYet => 'ยังไม่ได้';

  @override
  String get stadiumsEntrySubClosed =>
      'ดูสนามของคุณ งานก่อสร้างจะเปิดอีกครั้งเมื่อเริ่มรอบถัดไป';

  @override
  String get boardObjectiveNoBrief => 'ไม่ได้ตั้งเป้าหมาย';

  @override
  String get boardObjectiveNoBriefBody =>
      'บอร์ดไม่ได้คาดหวังให้คุณผ่านเข้ารอบสุดท้ายนี้ แต่จะประเมินคุณจากผลการแข่งขันแทน';

  @override
  String get boardObjectiveAwaitingDraw => 'เป้าหมายหลังการจับสลาก';

  @override
  String get boardObjectiveAwaitingDrawBody =>
      'บอร์ดจะตั้งเป้าหมายนี้หลังจับสลากแบ่งกลุ่ม';
}
