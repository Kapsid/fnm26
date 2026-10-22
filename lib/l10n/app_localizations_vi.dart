// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get matchPreviewTitle => 'NHẬN ĐỊNH TRẬN ĐẤU';

  @override
  String get matchKickOff => 'Giao bóng';

  @override
  String get matchTactics => 'Chiến thuật';

  @override
  String get matchYourXi => 'ĐỘI HÌNH CỦA BẠN';

  @override
  String get matchHeadToHead => 'ĐỐI ĐẦU';

  @override
  String matchCouldNotLoad(String error) {
    return 'Không tải được trận đấu.\n$error';
  }

  @override
  String get matchNoUpcoming => 'Chưa có trận đấu sắp tới.';

  @override
  String get matchUnknownNation => 'Không rõ';

  @override
  String get matchH2hFirstMeeting => 'Lần đầu chạm trán';

  @override
  String get matchH2hYouLead => 'Bạn dẫn đầu thành tích đối đầu';

  @override
  String matchH2hOppEdge(String opponent) {
    return '$opponent chiếm ưu thế';
  }

  @override
  String get matchH2hEven => 'Cân bằng';

  @override
  String matchH2hMet(int count) {
    return '$count lần gặp';
  }

  @override
  String get matchH2hWon => 'Thắng';

  @override
  String get matchH2hDrawn => 'Hòa';

  @override
  String get matchH2hLost => 'Thua';

  @override
  String get matchDossierTitle => 'Báo cáo tuyển trạch';

  @override
  String get matchDossierForm => 'PHONG ĐỘ';

  @override
  String get matchDossierNoGames => 'Chưa có trận gần đây';

  @override
  String get matchDossierKeyMen => 'TRỤ CỘT';

  @override
  String matchCouldNotContinue(String error) {
    return 'Không thể tiếp tục: $error';
  }

  @override
  String get matchSkipToFullTime => 'Tua đến hết giờ';

  @override
  String get matchStatShots => 'Cú sút';

  @override
  String get matchStatGoals => 'Bàn thắng';

  @override
  String get matchStatYellowCards => 'Thẻ vàng';

  @override
  String get matchStatRedCards => 'Thẻ đỏ';

  @override
  String get matchMomentum => 'ĐÀ TRẬN ĐẤU';

  @override
  String get matchSwingAtk => 'TC';

  @override
  String get matchSwingDef => 'PN';

  @override
  String ceremonyWorldCupYear(int year) {
    return 'GIẢI VÔ ĐỊCH THẾ GIỚI $year';
  }

  @override
  String get ceremonyFinalsAreHere => 'VÒNG CHUNG KẾT ĐÃ ĐẾN';

  @override
  String ceremonyHostedBy(String hosts) {
    return 'ĐĂNG CAI BỞI  $hosts';
  }

  @override
  String get ceremonyHostTbc => 'CHƯA XÁC ĐỊNH CHỦ NHÀ';

  @override
  String get matchHalfTime => 'NGHỈ GIỮA HIỆP';

  @override
  String get matchContinue => 'Tiếp tục';

  @override
  String get matchContinuing => 'Đang tiếp tục…';

  @override
  String matchTacticsWithSubs(int used, int max) {
    return 'Chiến thuật · $used/$max lượt thay';
  }

  @override
  String matchTiredCount(int count) {
    return 'MỆT ×$count';
  }

  @override
  String get matchTacticsLabel => 'CHIẾN THUẬT';

  @override
  String get teamOverallOverTime => 'CHỈ SỐ TỔNG THEO THỜI GIAN';

  @override
  String get teamOverall => 'Chỉ số tổng';

  @override
  String get teamTalkHeading => 'LỜI DẶN CẦU THỦ';

  @override
  String get teamTalkPrompt => 'Định hướng tinh thần cho hiệp hai.';

  @override
  String get teamTalkCalmLabel => 'Bình tĩnh';

  @override
  String get teamTalkCalmBlurb => 'Ổn định đội bóng. Cải thiện nhẹ mọi mặt.';

  @override
  String get teamTalkEncourageLabel => 'Động viên';

  @override
  String get teamTalkEncourageBlurb => 'Dâng cao và chơi chủ động.';

  @override
  String get teamTalkDemandMoreLabel => 'Đòi hỏi nhiều hơn';

  @override
  String get teamTalkDemandMoreBlurb => 'Dốc toàn lực. Tấn công mạnh mẽ.';

  @override
  String get teamTalkPraiseLabel => 'Giữ chắc';

  @override
  String get teamTalkPraiseBlurb => 'Chơi chặt chẽ và bảo vệ thành quả.';

  @override
  String get teamTalkBelieveLabel => 'Tự tin';

  @override
  String get teamTalkBelieveBlurb =>
      'Hãy tin vào chính mình. Tăng sức mạnh ở cả hai đầu sân.';

  @override
  String get teamTalkFocusLabel => 'Tập trung cao độ';

  @override
  String get teamTalkFocusBlurb => 'Tập trung tuyệt đối. Khóa chặt trận đấu.';

  @override
  String get teamTalkUrgencyLabel => 'Khẩn trương lên';

  @override
  String get teamTalkUrgencyBlurb =>
      'Đuổi theo ngay bây giờ. Dốc toàn lực, nhưng sẽ để hở hàng thủ.';

  @override
  String get teamTalkReassureLabel => 'Không áp lực';

  @override
  String get teamTalkReassureBlurb => 'Xua tan lo lắng và giữ vững sơ đồ.';

  @override
  String get commonRetry => 'Thử lại';

  @override
  String get commonSomethingWentWrong => 'Đã xảy ra lỗi';

  @override
  String get commonCrashBox =>
      'Đã xảy ra lỗi ở đây.\nCài đặt → Chẩn đoán có chi tiết.';

  @override
  String hubCouldNotAdvance(String error) {
    return 'Không thể chạy tiếp thế giới: $error';
  }

  @override
  String get settingsDiagnosticsTitle => 'Chẩn đoán';

  @override
  String get settingsDiagnosticsBlurb =>
      'Các lỗi được ghi lại trên thiết bị này. Không có gì được gửi đi đâu cả.';

  @override
  String get settingsContactTitle => 'Liên hệ';

  @override
  String get settingsContactCopied => 'Đã sao chép địa chỉ.';

  @override
  String get settingsCommunityTitle => 'Cộng đồng';

  @override
  String get settingsDiscordSubtitle => 'Tham gia cộng đồng';

  @override
  String get settingsLinkCopied => 'Đã sao chép liên kết.';

  @override
  String get diagnosticsEmpty => 'Chưa ghi nhận lỗi nào. Đó chính là mục tiêu.';

  @override
  String get diagnosticsCopy => 'Sao chép';

  @override
  String get diagnosticsCopied => 'Đã sao chép nhật ký vào bộ nhớ tạm.';

  @override
  String get diagnosticsClear => 'Xóa';

  @override
  String get navHub => 'Trang chủ';

  @override
  String get navSquad => 'Đội hình';

  @override
  String get navStandings => 'Bảng xếp hạng';

  @override
  String get navCareers => 'Sự nghiệp';

  @override
  String get settingsTitle => 'CÀI ĐẶT';

  @override
  String get settingsSoundHapticsTitle => 'Âm thanh & rung';

  @override
  String get settingsSoundHapticsBlurb =>
      'Rung và âm báo ngắn khi có bàn thắng, giao bóng và hết giờ.';

  @override
  String get settingsLanguageTitle => 'Ngôn ngữ';

  @override
  String get settingsLanguageBlurb =>
      'Chọn ngôn ngữ ứng dụng, hoặc theo thiết bị.';

  @override
  String get settingsLanguageSystem => 'Hệ thống';

  @override
  String get matchPreviewAllMeetings => 'Tất cả các lần gặp';

  @override
  String get recordsMeetings => 'CÁC LẦN GẶP';

  @override
  String get recordsLegends => 'HUYỀN THOẠI';

  @override
  String get recordsAllTimeXi => 'ĐỘI HÌNH MỌI THỜI ĐẠI';

  @override
  String get recordsHallOfFame => 'ĐẠI SẢNH DANH VỌNG';

  @override
  String get recordsAllTimeWorld => 'THẾ GIỚI MỌI THỜI ĐẠI';

  @override
  String get recordsAllTimeTopScorers => 'VUA PHÁ LƯỚI MỌI THỜI ĐẠI';

  @override
  String get recordsMostCapped => 'NHIỀU LẦN KHOÁC ÁO NHẤT';

  @override
  String get recordsMostWcStarts => 'ĐÁ CHÍNH NHIỀU NHẤT Ở VCTG';

  @override
  String get recordsMostTournaments => 'DỰ NHIỀU GIẢI ĐẤU NHẤT';

  @override
  String get recordsRecordBook => 'SỔ KỶ LỤC';

  @override
  String get recordsHeadToHead => 'ĐỐI ĐẦU';

  @override
  String get recordsFiercestRival => 'ĐỐI THỦ TRUYỀN KIẾP';

  @override
  String get recordsMostCaps => 'NHIỀU LẦN KHOÁC ÁO NHẤT';

  @override
  String get recordsTopScorers => 'VUA PHÁ LƯỚI';

  @override
  String get recordsMostAssists => 'KIẾN TẠO NHIỀU NHẤT';

  @override
  String get recordsYourRecord => 'THÀNH TÍCH CỦA BẠN';

  @override
  String get callUpHome => 'SÂN NHÀ';

  @override
  String get callUpAway => 'SÂN KHÁCH';

  @override
  String get recordsHome => 'CHỦ NHÀ';

  @override
  String get recordsAway => 'KHÁCH';

  @override
  String get recordsActive => 'CÒN THI ĐẤU';

  @override
  String get recordsStillActive => 'Còn thi đấu';

  @override
  String get recordsAvg => 'TB';

  @override
  String get recordsSelect => 'Chọn';

  @override
  String get recordsVs => 'gặp';

  @override
  String get recordsDraws => 'Hòa';

  @override
  String get recordsGoalsLabel => 'Bàn thắng';

  @override
  String get recordsBestFinish => 'Thành tích tốt nhất';

  @override
  String get recordsNoFinalsYet => 'Chưa vào vòng chung kết';

  @override
  String get recordsLongestUnbeaten => 'Bất bại dài nhất';

  @override
  String get recordsBiggestWin => 'Trận thắng đậm nhất';

  @override
  String get recordsSeeAllMeetings => 'Xem tất cả các lần gặp';

  @override
  String get recordsSaveNotFound => 'Không tìm thấy bản lưu.';

  @override
  String get recordsNoMatches => 'Không có kết quả.';

  @override
  String get recordsSearchPlayerOrNation => 'Tìm cầu thủ hoặc quốc gia';

  @override
  String get recordsSearchNation => 'Tìm quốc gia';

  @override
  String get recordsPickTwoDifferent => 'Hãy chọn hai quốc gia khác nhau.';

  @override
  String get recordsPlayToBuildRecord =>
      'Hãy chơi vài trận, thành tích của bạn trước từng đối thủ sẽ hiện ở đây.';

  @override
  String get recordsTapOpponent => 'Chạm vào một đối thủ để xem chi tiết.';

  @override
  String get recordsEdgeUpperHand => 'Bạn đang chiếm thế thượng phong';

  @override
  String get recordsEdgeTheirNumber => 'Họ khắc chế được bạn';

  @override
  String get recordsEdgeEven => 'Cân bằng';

  @override
  String get recordsAllTimeWorldSubtitle =>
      'Vua phá lưới và người khoác áo nhiều nhất, mọi quốc gia';

  @override
  String get recordsHeadToHeadSubtitle =>
      'So sánh thành tích mọi thời đại của hai quốc gia bất kỳ';

  @override
  String get recordsLegendsSubtitle =>
      'Đội hình mọi thời đại & đại sảnh danh vọng';

  @override
  String get recordsUnitGoals => 'bàn';

  @override
  String get recordsUnitCaps => 'lần khoác áo';

  @override
  String get recordsUnitStarts => 'lần đá chính';

  @override
  String get recordsUnitCups => 'giải';

  @override
  String get recordsUnitAssists => 'kiến tạo';

  @override
  String recordsCapsCount(int count) {
    return '$count lần khoác áo';
  }

  @override
  String recordsGoalsCount(int count) {
    return '$count bàn';
  }

  @override
  String recordsAssistsCount(int count) {
    return '$count kiến tạo';
  }

  @override
  String recordsMotmCount(int count) {
    return '$count lần hay nhất trận';
  }

  @override
  String recordsMatchesCount(int count) {
    return '$count trận';
  }

  @override
  String recordsMeetingsCount(int count) {
    return '$count lần gặp';
  }

  @override
  String recordsCodeWins(String code) {
    return '$code thắng';
  }

  @override
  String recordsMeetingsWdl(int meetings, int wins, int draws, int losses) {
    return '$meetings lần gặp · ${wins}T ${draws}H ${losses}B';
  }

  @override
  String recordsWdl(int wins, int draws, int losses) {
    return '${wins}T ${draws}H ${losses}B';
  }

  @override
  String recordsRivalLine(int meetings, String record, String edge) {
    return '$meetings lần gặp · $record · $edge';
  }

  @override
  String recordsNeverMet(String a, String b) {
    return '$a và $b chưa từng gặp nhau trong bản lưu này.';
  }

  @override
  String tacticsSentOffNote(String names) {
    return '$names bị đuổi khỏi sân. Không được thay người, nên bạn phải đá thiếu người.';
  }

  @override
  String tacticsNeedFitPlayers(int required, int have) {
    return 'Cần $required cầu thủ sẵn sàng (hiện có $have)';
  }

  @override
  String tacticsMissesOfCamp(int missed, int total) {
    return 'Vắng $missed/$total';
  }

  @override
  String get tacticsOutForWholeCamp => 'Vắng mặt cả đợt triệu tập này';

  @override
  String get rankingCentreOnMe => 'Về quốc gia của tôi';

  @override
  String get recordsAfterExtraTime => 'hiệp phụ';

  @override
  String recordsOnPenalties(int a, int b) {
    return '$a–$b luân lưu';
  }

  @override
  String recordsVersus(String a, String b) {
    return '$a gặp $b';
  }

  @override
  String recordsPlayedScore(int played, int gf, int ga) {
    return '$played trận · $gf–$ga';
  }

  @override
  String recordsBiggestWinValue(int gf, int ga, String opp) {
    return '$gf–$ga gặp $opp';
  }

  @override
  String recordsCouldNotLoad(String error) {
    return 'Không tải được.\n$error';
  }

  @override
  String recordsCouldNotLoadLegends(String error) {
    return 'Không tải được huyền thoại.\n$error';
  }

  @override
  String recordsCouldNotLoadRecords(String error) {
    return 'Không tải được kỷ lục.\n$error';
  }

  @override
  String recordsCouldNotLoadNations(String error) {
    return 'Không tải được danh sách quốc gia.\n$error';
  }

  @override
  String recordsCouldNotLoadYourRecord(String error) {
    return 'Không tải được thành tích của bạn.\n$error';
  }

  @override
  String recordsCouldNotLoadRecord(String error) {
    return 'Không tải được thành tích.\n$error';
  }

  @override
  String recordsNoLegends(String nation) {
    return 'Chưa có huyền thoại nào. Hãy chơi vài chiến dịch, những tên tuổi lớn của $nation sẽ xuất hiện ở đây.';
  }

  @override
  String recordsGreatestSide(String nation) {
    return 'Đội hình mạnh nhất mà $nation từng có.';
  }

  @override
  String get recordsNoWorldHistory =>
      'Thế giới chưa có lịch sử. Hãy chơi vài chiến dịch, những huyền thoại mọi thời đại sẽ xuất hiện ở đây.';

  @override
  String recordsPlayToWriteHistory(String nation) {
    return 'Hãy chơi vài trận để bắt đầu viết nên lịch sử của $nation.';
  }

  @override
  String get tacticsLineGk => 'TM';

  @override
  String get tacticsLineDef => 'HV';

  @override
  String get tacticsLineMid => 'TV';

  @override
  String get tacticsLineFwd => 'TĐ';

  @override
  String get tacticsGoalkeepers => 'THỦ MÔN';

  @override
  String get tacticsDefenders => 'HẬU VỆ';

  @override
  String get tacticsMidfielders => 'TIỀN VỆ';

  @override
  String get tacticsForwards => 'TIỀN ĐẠO';

  @override
  String get tacticsCallUpsTitle => 'TRIỆU TẬP';

  @override
  String tacticsPickAtLeastPlayers(int min) {
    return 'Hãy chọn ít nhất $min cầu thủ.';
  }

  @override
  String tacticsCouldNotLoadSquad(String error) {
    return 'Không tải được danh sách đội hình.\n$error';
  }

  @override
  String get tacticsNoSquad => 'Chưa có danh sách đội hình.';

  @override
  String tacticsSquadCount(int count, int max) {
    return 'ĐỘI HÌNH · $count/$max';
  }

  @override
  String tacticsMinMax(int min, int max) {
    return 'Tối thiểu $min · Tối đa $max';
  }

  @override
  String get tacticsBestQuality => 'Chất lượng nhất';

  @override
  String get tacticsPreviousSquad => 'Danh sách trước';

  @override
  String get tacticsSquadLockedBack => 'Quay lại (đã chốt danh sách)';

  @override
  String get tacticsConfirmSquad => 'Xác nhận danh sách';

  @override
  String tacticsSquadFullMax(int max) {
    return 'Danh sách đã đủ (tối đa $max)';
  }

  @override
  String get tacticsSquadLocked => 'ĐÃ CHỐT DANH SÁCH';

  @override
  String get tacticsNominationOpen =>
      'ĐANG MỞ CHỐT DANH SÁCH. HÃY CHỌN ĐỘI HÌNH';

  @override
  String get tacticsSquadFixedBlurb =>
      'Danh sách này đã cố định cho các trận bên dưới. Hãy chọn lại trước đợt chốt danh sách tiếp theo.';

  @override
  String get tacticsSquadWillPlayBlurb =>
      'Danh sách này sẽ thi đấu các trận bên dưới.';

  @override
  String get tacticsUnknown => 'Không rõ';

  @override
  String tacticsAgeValue(int age, String value) {
    return '$age tuổi · $value';
  }

  @override
  String get tacticsFatigueExhausted => 'Kiệt sức';

  @override
  String get tacticsFatigueTired => 'Mệt';

  @override
  String get tacticsFatigueMatchLegs => 'Mệt sau trận';

  @override
  String tacticsTooManySubs(int max) {
    return 'Thay người quá nhiều (tối đa $max).';
  }

  @override
  String tacticsMinuteTitle(int minute) {
    return 'CHIẾN THUẬT · $minute\'';
  }

  @override
  String get tacticsApply => 'ÁP DỤNG';

  @override
  String get tacticsTabLineupSubs => 'ĐỘI HÌNH & THAY NGƯỜI';

  @override
  String get tacticsTabTactics => 'CHIẾN THUẬT';

  @override
  String get squadLineKeepers => 'THỦ MÔN';

  @override
  String get squadLineDefenders => 'HẬU VỆ';

  @override
  String get squadLineMidfielders => 'TIỀN VỆ';

  @override
  String get squadLineForwards => 'TIỀN ĐẠO';

  @override
  String get squadStatXiRating => 'Điểm đội hình';

  @override
  String get squadStatAvgAge => 'Tuổi TB';

  @override
  String get squadStatSize => 'Đội hình';

  @override
  String get squadStatUnavailable => 'Vắng';

  @override
  String get squadDepthTitle => 'ĐỘ DÀY THEO TUYẾN';

  @override
  String squadAgeShort(int age) {
    return '${age}t';
  }

  @override
  String get tacticsTabOtherPositions => 'VỊ TRÍ KHÁC';

  @override
  String get tacticsOutOfPositionNote => 'Trái sở trường ở vị trí này';

  @override
  String get tacticsNobodyElse => 'Không còn ai khác để thử ở đây.';

  @override
  String get tacticsPickSomebodyFirst =>
      'Hãy chọn người rời sân, phần còn lại của ghế dự bị sẽ hiện ở đây, kèm điểm số khi đá vị trí này.';

  @override
  String get tacticsTabSuitable => 'PHÙ HỢP';

  @override
  String get tacticsTabOnPitch => 'TRÊN SÂN';

  @override
  String tacticsSectionSuitable(int count) {
    return 'PHÙ HỢP · $count';
  }

  @override
  String get tacticsNobodySuits =>
      'Không ai trên ghế dự bị phù hợp tự nhiên với vị trí này, nên đây là toàn bộ cầu thủ dự bị.';

  @override
  String tacticsSectionOnPitch(int count, int max) {
    return 'TRÊN SÂN · $count/$max';
  }

  @override
  String tacticsSectionAvailable(int count) {
    return 'CÓ THỂ VÀO SÂN · $count';
  }

  @override
  String get tacticsRowStarted => 'Đá chính';

  @override
  String tacticsRowCameOn(int minute) {
    return 'Vào sân phút $minute\'';
  }

  @override
  String get tacticsRowSubstitute => 'Vào sân';

  @override
  String get tacticsEnergyLabel => 'NĂNG LƯỢNG';

  @override
  String tacticsPickReplacementFor(String name) {
    return 'Chạm vào người thay thế $name, hoặc chạm lại để hủy.';
  }

  @override
  String get tacticsSlotLostToRedCard =>
      'Thẻ đỏ đã khiến bạn mất vị trí này. Hãy kéo một đồng đội vào để dồn lại khoảng trống.';

  @override
  String get tacticsSentOffShort => 'BỊ ĐUỔI';

  @override
  String tacticsSubsUsed(int used, int max) {
    return 'THAY NGƯỜI · $used/$max';
  }

  @override
  String get tacticsDragSubOn =>
      'Chạm vào cầu thủ trên sân để rút ra, hoặc giữ và kéo một cầu thủ dự bị vào vị trí đó.';

  @override
  String get tacticsNoSubs => 'Không còn cầu thủ dự bị.';

  @override
  String get tacticsChooseShape => 'CHỌN SƠ ĐỒ';

  @override
  String get tacticsFormation => 'SƠ ĐỒ';

  @override
  String get tacticsInstructions => 'CHỈ ĐẠO';

  @override
  String get tacticsDrilling => 'ĐỘ THUẦN THỤC';

  @override
  String get tacticsDrillingUnplayed => 'CHƯA ĐÁ';

  @override
  String get tacticsDrillingNew => 'MỚI';

  @override
  String get tacticsDrillingSettling => 'ĐANG QUEN';

  @override
  String get tacticsDrillingDrilled => 'THUẦN THỤC';

  @override
  String get tacticsInstrMentality => 'Tâm thế';

  @override
  String get tacticsInstrDefensive => 'Phòng ngự';

  @override
  String get tacticsInstrAttacking => 'Tấn công';

  @override
  String get tacticsInstrPressing => 'Pressing';

  @override
  String get tacticsInstrLowBlock => 'Lùi sâu';

  @override
  String get tacticsInstrHighPress => 'Pressing cao';

  @override
  String get tacticsInstrTempo => 'Nhịp độ';

  @override
  String get tacticsInstrPatient => 'Kiên nhẫn';

  @override
  String get tacticsInstrFast => 'Nhanh';

  @override
  String get tacticsInstrWidth => 'Bề rộng';

  @override
  String get tacticsInstrNarrow => 'Hẹp';

  @override
  String get tacticsInstrWide => 'Rộng';

  @override
  String get tacticsInstrDefLine => 'Tuyến thủ';

  @override
  String get tacticsInstrDefensiveLine => 'Tuyến phòng ngự';

  @override
  String get tacticsInstrDeep => 'Sâu';

  @override
  String get tacticsInstrHigh => 'Cao';

  @override
  String get tacticsInstrDirectness => 'Độ trực diện';

  @override
  String get tacticsInstrPossession => 'Kiểm soát bóng';

  @override
  String get tacticsInstrDirect => 'Trực diện';

  @override
  String get tacticsPickGoalkeeper => 'CHỌN THỦ MÔN';

  @override
  String get tacticsPickLeftBack => 'CHỌN HẬU VỆ TRÁI';

  @override
  String get tacticsPickCentreBack => 'CHỌN TRUNG VỆ';

  @override
  String get tacticsPickRightBack => 'CHỌN HẬU VỆ PHẢI';

  @override
  String get tacticsPickDefensiveMid => 'CHỌN TIỀN VỆ PHÒNG NGỰ';

  @override
  String get tacticsPickCentralMid => 'CHỌN TIỀN VỆ TRUNG TÂM';

  @override
  String get tacticsPickAttackingMid => 'CHỌN TIỀN VỆ TẤN CÔNG';

  @override
  String get tacticsPickLeftMid => 'CHỌN TIỀN VỆ TRÁI';

  @override
  String get tacticsPickRightMid => 'CHỌN TIỀN VỆ PHẢI';

  @override
  String get tacticsPickLeftWing => 'CHỌN TIỀN VỆ CÁNH TRÁI';

  @override
  String get tacticsPickRightWing => 'CHỌN TIỀN VỆ CÁNH PHẢI';

  @override
  String get tacticsPickStriker => 'CHỌN TIỀN ĐẠO CẮM';

  @override
  String tacticsRoleOutOfPosition(String role) {
    return '$role · trái sở trường';
  }

  @override
  String tacticsAgeOnly(int age) {
    return '$age tuổi';
  }

  @override
  String tacticsRoleAge(String role, int age) {
    return '$role · $age tuổi';
  }

  @override
  String get tacticsOn => 'TRÊN SÂN';

  @override
  String get tacticsSquad => 'ĐỘI HÌNH';

  @override
  String get tacticsTabLineup => 'ĐỘI HÌNH';

  @override
  String get tacticsTabInstructions => 'CHỈ ĐẠO';

  @override
  String get tacticsTabRoles => 'VAI TRÒ';

  @override
  String get tacticsTabSetPieces => 'BÓNG CHẾT';

  @override
  String get tacticsTabRolesSetPieces => 'VAI TRÒ & BÓNG CHẾT';

  @override
  String get tacticsRolesSetPiecesBlurb =>
      'Giao vai trò cho từng cầu thủ đá chính. Chạm vào biểu tượng phạt đền (⚽) hoặc đá phạt (▲) để chọn người thực hiện.';

  @override
  String get tacticsTooltipCallUps => 'Triệu tập';

  @override
  String get tacticsTooltipPresets => 'Chiến thuật mẫu';

  @override
  String get tacticsTooltipInstructions => 'Chỉ đạo';

  @override
  String get tacticsNoTacticSet => 'Chưa đặt chiến thuật.';

  @override
  String tacticsReplaceStarters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'THAY $count CẦU THỦ ĐÁ CHÍNH',
    );
    return '$_temp0';
  }

  @override
  String tacticsPlayerOut(String name, String reason) {
    return '$name: $reason';
  }

  @override
  String get tacticsOut => 'Vắng';

  @override
  String get tacticsTapSpotReplace =>
      'Chạm vào vị trí của họ trên sân để chọn người thay thế.';

  @override
  String get tacticsTapOrDrag =>
      'Chạm vào một cầu thủ để thay ra, hoặc giữ và kéo để di chuyển.';

  @override
  String get tacticsPlayerRoles => 'VAI TRÒ CẦU THỦ';

  @override
  String get tacticsRolesBlurb =>
      'Giao nhiệm vụ cho cầu thủ: săn bàn, kiến thiết, trung phong làm điểm tựa. Quyết định ai ghi bàn và ai tạo cơ hội.';

  @override
  String get tacticsSetPieceTakers => 'NGƯỜI ĐÁ BÓNG CHẾT';

  @override
  String get tacticsSetPieceBlurb =>
      'Ai đá phạt đền và các tình huống cố định, hoặc để cầu thủ phù hợp nhất đảm nhận.';

  @override
  String get tacticsTakerAuto => 'Tự động';

  @override
  String get tacticsTakerQuickPick => 'Chọn người đá tốt nhất';

  @override
  String get tacticsPenalties => 'Phạt đền';

  @override
  String get tacticsCornersFreeKicks => 'Phạt góc & đá phạt';

  @override
  String get tacticsSkillFin => 'DUT';

  @override
  String get tacticsSkillPas => 'CHB';

  @override
  String tacticsRolePlayer(String name) {
    return 'VAI TRÒ · $name';
  }

  @override
  String get tacticsPenaltyTaker => 'NGƯỜI ĐÁ PHẠT ĐỀN';

  @override
  String get tacticsCornerFreeKickTaker => 'NGƯỜI ĐÁ PHẠT GÓC & ĐÁ PHẠT';

  @override
  String get tacticsAutomatic => 'Tự động';

  @override
  String get tacticsLetBestSuited => 'Để cầu thủ phù hợp nhất thực hiện.';

  @override
  String get tacticsInXi => 'TRONG ĐỘI HÌNH';

  @override
  String get tacticsTeamInstructions => 'CHỈ ĐẠO ĐỘI BÓNG';

  @override
  String get tacticsTeamInstructionsBlurb =>
      'Thiết lập lối chơi của đội. Mỗi núm điều chỉnh tác động lên toàn đội.';

  @override
  String tacticsSavedPreset(String name) {
    return 'Đã lưu “$name”';
  }

  @override
  String tacticsAppliedPreset(String name) {
    return 'Đã áp dụng “$name”';
  }

  @override
  String get tacticsTacticPresets => 'CHIẾN THUẬT MẪU';

  @override
  String get tacticsPresetsBlurb =>
      'Lưu sơ đồ này thành một phong cách dùng lại được, hoặc áp dụng mẫu đã lưu trước đó.';

  @override
  String get tacticsSaveCurrentTactic => 'Lưu chiến thuật hiện tại';

  @override
  String tacticsCouldNotLoadPresets(String error) {
    return 'Không tải được chiến thuật mẫu.\n$error';
  }

  @override
  String get tacticsNoPresetsYet =>
      'Chưa có mẫu nào. Chạm vào “Lưu chiến thuật hiện tại” để lưu thiết lập này thành một phong cách dùng lại được.';

  @override
  String get tacticsNameThisTactic => 'Đặt tên cho chiến thuật';

  @override
  String get tacticsNameHint => 'VD: Pressing cao 4-3-3';

  @override
  String get tacticsCancel => 'Hủy';

  @override
  String get tacticsSave => 'Lưu';

  @override
  String get tacticsTapToAssign => 'Chạm để giao';

  @override
  String get tacticsHoldDragSub =>
      'Giữ một cầu thủ dự bị, rồi kéo vào một cầu thủ để cho vào sân.';

  @override
  String get hubContinue => 'Tiếp tục';

  @override
  String get hubBrackets => 'Nhánh đấu';

  @override
  String hubCouldNotLoad(String error) {
    return 'Không tải được.\n$error';
  }

  @override
  String hubCouldNotLoadFinances(String error) {
    return 'Không tải được tài chính.\n$error';
  }

  @override
  String hubCouldNotLoadSave(String error) {
    return 'Không tải được bản lưu.\n$error';
  }

  @override
  String get hubSaveNotFound => 'Không tìm thấy bản lưu.';

  @override
  String get hubUnknown => 'Không rõ';

  @override
  String hubWorldChampionsYear(int year) {
    return 'NHÀ VÔ ĐỊCH THẾ GIỚI $year';
  }

  @override
  String get hubCycleComplete => 'Chu kỳ đã hoàn tất.';

  @override
  String get hubYourJob => 'CÔNG VIỆC CỦA BẠN';

  @override
  String get hubStayProject => 'Ở lại và tiếp tục dự án của bạn';

  @override
  String get hubChooseNextJob => 'CHỌN CÔNG VIỆC TIẾP THEO';

  @override
  String get hubOffersOnTable => 'CÁC LỜI MỜI';

  @override
  String hubOfferSubtitle(String tier, int position) {
    return '$tier · hạng $position thế giới';
  }

  @override
  String hubContinueWith(String nation) {
    return 'Tiếp tục với $nation';
  }

  @override
  String get hubYourNation => 'quốc gia của bạn';

  @override
  String get hubTakeTheJob => 'Nhận việc';

  @override
  String get hubFederationFinances => 'TÀI CHÍNH LIÊN ĐOÀN';

  @override
  String get hubBudgetIntro =>
      'Việc đầu tiên của bạn ở chu kỳ tới là đặt ngân sách liên đoàn và chia cho các bộ phận.';

  @override
  String get hubStarting => 'Đang bắt đầu…';

  @override
  String get hubBeginNextCycle => 'Bắt đầu chu kỳ tiếp theo';

  @override
  String get hubContinueCareer => 'Tiếp tục sự nghiệp';

  @override
  String get hubBackToSaves => 'Về các bản lưu';

  @override
  String get hubOpeningBalance => 'Số dư đầu kỳ';

  @override
  String get hubCentralFunding => 'Tài trợ trung ương';

  @override
  String get hubPrizeMoney => 'Tiền thưởng';

  @override
  String get hubCommercialReturn => 'Doanh thu thương mại';

  @override
  String get hubAvailableToInvest => 'Có thể đầu tư';

  @override
  String hubReputation(String label, int rep) {
    return 'Danh tiếng: $label ($rep)';
  }

  @override
  String get hubNationalHero => 'Anh hùng dân tộc';

  @override
  String get hubFinal => 'Chung kết';

  @override
  String get hubStageRoundOf32 => 'Vòng 1/16';

  @override
  String get hubStageThirdPlace => 'Trận tranh hạng ba';

  @override
  String get hubEventAdvanceWorld => 'Chạy tiếp thế giới';

  @override
  String hubEventStartCycle(int year) {
    return 'Bắt đầu chu kỳ $year';
  }

  @override
  String hubEventWorldChampions(String nation) {
    return '$nation là nhà vô địch thế giới';
  }

  @override
  String get hubEventSetBudget => 'Đặt ngân sách liên đoàn';

  @override
  String get hubEventSetBudgetSub =>
      'Phân bổ quỹ của chu kỳ này trước khi mùa giải bắt đầu';

  @override
  String get hubEventNaturalization => 'Xem xét lời đề nghị nhập tịch';

  @override
  String get hubEventNaturalizationSub =>
      'Một cầu thủ nước ngoài muốn chuyển sang khoác áo đội bạn';

  @override
  String get hubEventCampaignVerdict =>
      'Chiến dịch đã khép lại: xem phán quyết';

  @override
  String get hubEventCampaignComplete => 'Chiến dịch hoàn tất';

  @override
  String get hubEventIntercontinentalPlayoff => 'Play-off liên lục địa';

  @override
  String get hubEventWatchWcDraw => 'Xem lễ bốc thăm Giải vô địch thế giới';

  @override
  String get hubEventWorldCupHere => 'Giải vô địch thế giới đã đến';

  @override
  String get hubEventWatchFinalsDraw => 'Xem lễ bốc thăm vòng chung kết';

  @override
  String get hubEventFinalsHere => 'Vòng chung kết đã đến';

  @override
  String get hubEventPlayWcRound =>
      'Đá vòng tiếp theo của Giải vô địch thế giới';

  @override
  String hubEventPlayCupMatch(String cup) {
    return 'Đá trận $cup tiếp theo';
  }

  @override
  String get hubEventPlayNationsCupMatch => 'Đá trận Nations Cup tiếp theo';

  @override
  String get hubEventWatchNationsCupDraw => 'Xem lễ bốc thăm Nations Cup';

  @override
  String get hubEventWatchHostSelection => 'Xem lễ chọn chủ nhà';

  @override
  String get hubEventWatchQualifyingDraw => 'Xem lễ bốc thăm vòng loại';

  @override
  String get hubEventWatchWcHostSelection =>
      'Xem lễ chọn chủ nhà Giải vô địch thế giới';

  @override
  String get hubEventWatchWcQualifyingDraw =>
      'Xem lễ bốc thăm vòng loại Giải vô địch thế giới';

  @override
  String get hubEventArrangeFriendlies => 'Sắp xếp trận giao hữu';

  @override
  String hubEventFriendliesSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bạn chưa lấp đầy $count đợt giao hữu còn trống',
      one: 'Bạn chưa lấp đầy đợt giao hữu còn trống',
    );
    return '$_temp0';
  }

  @override
  String get hubEventReshapeXi => 'Điều chỉnh đội hình xuất phát';

  @override
  String hubEventReshapeOutSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count cầu thủ trong đội hình xuất phát vắng mặt (bị treo giò hoặc chấn thương). Hãy chọn người thay',
      one:
          '1 cầu thủ trong đội hình xuất phát vắng mặt (bị treo giò hoặc chấn thương). Hãy chọn người thay',
    );
    return '$_temp0';
  }

  @override
  String hubEventReshapeShortSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Đội hình xuất phát đang thiếu người. Hãy lấp các vị trí còn trống',
      one: 'Đội hình xuất phát đang thiếu người. Hãy lấp vị trí còn trống',
    );
    return '$_temp0';
  }

  @override
  String hubEventPlayOpponent(String opponent) {
    return 'Đá với $opponent';
  }

  @override
  String get hubEventContinentalFinalsFallback => 'vòng chung kết châu lục';

  @override
  String get hubCallUpFriendlies => 'Chốt danh sách cho các trận giao hữu';

  @override
  String get hubCallUpRequalify => 'Chốt lại danh sách vòng loại';

  @override
  String get hubCallUpWorldCup => 'Chốt danh sách dự Giải vô địch thế giới';

  @override
  String get hubCallUpFinals => 'Chốt danh sách cho vòng chung kết';

  @override
  String get hubCallUpNationsCup => 'Chốt danh sách dự Nations Cup';

  @override
  String get hubCallUpQualifying => 'Chốt danh sách vòng loại';

  @override
  String get hubCallUpGeneric => 'Chốt danh sách';

  @override
  String get hubHost => 'Chủ nhà';

  @override
  String get hubGoldenBoot => 'Chiếc giày vàng';

  @override
  String hubGoldenBootValue(String name, int goals) {
    return '$name · $goals bàn';
  }

  @override
  String get hubPens => '(luân lưu)';

  @override
  String get hubNationalHub => 'TRỤ SỞ LIÊN ĐOÀN';

  @override
  String get hubMessages => 'Tin nhắn';

  @override
  String get hubWorldChampions => 'NHÀ VÔ ĐỊCH THẾ GIỚI';

  @override
  String get hubViewBracket => 'Xem nhánh đấu ›';

  @override
  String get hubBoardDelighted => 'Rất hài lòng';

  @override
  String get hubBoardPleased => 'Hài lòng';

  @override
  String get hubBoardExpectingMore => 'Mong đợi nhiều hơn';

  @override
  String get hubBoardConcerned => 'Lo ngại';

  @override
  String get hubBoardJobAtRisk => 'Ghế nóng';

  @override
  String get hubBoard => 'BAN LÃNH ĐẠO';

  @override
  String hubBoardObjective(String label) {
    return 'Mục tiêu của ban lãnh đạo: $label';
  }

  @override
  String hubObjectiveMet(String result) {
    return 'ĐẠT · $result';
  }

  @override
  String hubObjectiveMissed(String result) {
    return 'KHÔNG ĐẠT · $result';
  }

  @override
  String get hubNoMoreFixtures => 'Không còn trận nào trong chu kỳ này.';

  @override
  String get hubVs => 'GẶP';

  @override
  String hubWorldRank(int rank) {
    return '#$rank';
  }

  @override
  String get hubWorldRankLabel => 'Bảng xếp hạng thế giới';

  @override
  String get hubSquadStatus => 'TÌNH TRẠNG ĐỘI HÌNH';

  @override
  String hubPlayers(int count) {
    return '$count cầu thủ';
  }

  @override
  String get hubAvgRating => 'Điểm TB';

  @override
  String get hubMorale => 'Tinh thần';

  @override
  String get hubManageTeam => 'Quản lý đội';

  @override
  String get hubGroupsToBeDrawn =>
      'Các bảng chưa được bốc thăm. Hãy xem lễ bốc thăm để biết.';

  @override
  String hubGroupName(String name) {
    return 'BẢNG $name';
  }

  @override
  String get hubTblTeam => 'ĐỘI';

  @override
  String get hubTblP => 'Tr';

  @override
  String get hubTblGd => 'HS';

  @override
  String get hubTblPts => 'Đ';

  @override
  String get homeSettings => 'Cài đặt';

  @override
  String get homeLeadTheNation => 'DẪN DẮT ĐỘI TUYỂN';

  @override
  String get homeYourNation => 'quốc gia của bạn';

  @override
  String get homeNewGame => 'Trò chơi mới';

  @override
  String get homeAllSaves => 'Tất cả bản lưu';

  @override
  String get homeLoadGame => 'Tải trò chơi';

  @override
  String get homeContinue => 'TIẾP TỤC';

  @override
  String homeRoadToWorldCup(String date, int year) {
    return '$date · Hành trình tới Giải vô địch thế giới $year';
  }

  @override
  String get careerManageSaves => 'Quản lý bản lưu';

  @override
  String get careerNewGameTitle => 'TRÒ CHƠI MỚI';

  @override
  String careerCouldNotLoadNation(String error) {
    return 'Không tải được quốc gia.\n$error';
  }

  @override
  String get careerNationNotFound => 'Không tìm thấy quốc gia.';

  @override
  String careerWorldRankNum(int rank) {
    return 'HẠNG THẾ GIỚI #$rank';
  }

  @override
  String get careerManagerName => 'Tên huấn luyện viên';

  @override
  String get careerManagerNameHint => 'ví dụ: Alex Ferguson';

  @override
  String get careerBeginsBlurb =>
      'Sự nghiệp của bạn bắt đầu vào tháng 9 năm 2026, trên hành trình tới Giải vô địch thế giới 2030.';

  @override
  String get careerFreeCycleNote =>
      'Miễn phí trọn một chu kỳ bốn năm: vòng loại, giải vô địch châu lục của bạn và Giải vô địch thế giới, trên hai bản lưu. Sau đó, chỉ một lần thanh toán là mở khóa vô hạn chu kỳ.';

  @override
  String get careerStartCareer => 'Bắt đầu sự nghiệp';

  @override
  String get careersTitle => 'SỰ NGHIỆP';

  @override
  String get careerManagerCareer => 'Sự nghiệp huấn luyện';

  @override
  String get careerManagerCareerSubtitle =>
      'Mọi chu kỳ bạn đã dẫn dắt và thành tích tổng thể';

  @override
  String get careerSummaryTitle => 'Tổng kết sự nghiệp';

  @override
  String get careerSummarySubtitle => 'Tủ cúp và thành tích huấn luyện của bạn';

  @override
  String get careerAchievements => 'Thành tựu';

  @override
  String get careerAchievementsSubtitle =>
      'Cột mốc, danh hiệu và mức hài lòng của ban lãnh đạo';

  @override
  String get careerChallenges => 'Thử thách';

  @override
  String get careerChallengesSubtitle =>
      'Những phép thử khắc nghiệt cả sự nghiệp để chinh phục';

  @override
  String get careerTeamRecords => 'Kỷ lục đội tuyển';

  @override
  String get careerTeamRecordsSubtitle =>
      'Vua phá lưới và số lần ra sân mọi thời đại';

  @override
  String get careerMyMatches => 'Trận đấu của tôi';

  @override
  String get careerMyMatchesSubtitle => 'Mọi kết quả và lịch thi đấu sắp tới';

  @override
  String get careerTitle => 'SỰ NGHIỆP';

  @override
  String careerCouldNotLoadCareer(String error) {
    return 'Không thể tải sự nghiệp.\n$error';
  }

  @override
  String get careerNoCareer => 'Chưa có sự nghiệp.';

  @override
  String get careerTrophyCabinet => 'TỦ CÚP';

  @override
  String get careerTournamentHistory => 'LỊCH SỬ GIẢI ĐẤU';

  @override
  String get careerNoTournamentsYet => 'Chưa hoàn thành giải đấu nào.';

  @override
  String get careerTeamFallback => 'Đội';

  @override
  String careerWorldNum(int rank) {
    return 'THẾ GIỚI #$rank';
  }

  @override
  String careerPointsNum(int points) {
    return '$points ĐIỂM';
  }

  @override
  String careerSeasonNum(int season) {
    return 'MÙA GIẢI $season';
  }

  @override
  String get careerStatPlayedShort => 'Tr';

  @override
  String get careerStatsHeading => 'CON SỐ THỐNG KÊ';

  @override
  String get careerStatsWinRate => 'Tỷ lệ thắng';

  @override
  String get careerStatsGoalsFor => 'Bàn thắng';

  @override
  String get careerStatsGoalsAgainst => 'Bàn thua';

  @override
  String get careerStatsGoalDiff => 'Hiệu số';

  @override
  String get careerStatsCleanSheets => 'Giữ sạch lưới';

  @override
  String get careerStatsBiggestWin => 'Thắng đậm nhất';

  @override
  String get careerStatsWinStreak => 'Chuỗi thắng';

  @override
  String get careerStatsUnbeaten => 'Chuỗi bất bại';

  @override
  String get careerStatsShootouts => 'Luân lưu';

  @override
  String get careerStatsHatTricks => 'Hat-trick';

  @override
  String get careerStatsMotms => 'Cầu thủ hay nhất trận';

  @override
  String get careerStatsBestRating => 'Điểm cao nhất';

  @override
  String get careerStatWonShort => 'T';

  @override
  String get careerStatDrawnShort => 'H';

  @override
  String get careerStatLostShort => 'B';

  @override
  String get careerStatGoalsForShort => 'BT';

  @override
  String get careerStatGoalsAgainstShort => 'BB';

  @override
  String get careerStatGoalDiffShort => 'HS';

  @override
  String get careerNoSilverware =>
      'Chưa có chiếc cúp nào. Hãy đi giành một chiếc.';

  @override
  String get careerMedalGold => 'VÀNG';

  @override
  String get careerMedalSilver => 'BẠC';

  @override
  String get careerMedalBronze => 'ĐỒNG';

  @override
  String careerWinnersName(String name) {
    return 'Nhà vô địch: $name';
  }

  @override
  String get careerSavesTitle => 'BẢN LƯU';

  @override
  String careerCouldNotLoadSaves(String error) {
    return 'Không thể tải các bản lưu.\n$error';
  }

  @override
  String careerSlotsCount(int used, int limit) {
    return 'Ô LƯU  $used/$limit';
  }

  @override
  String get careerThisSave => 'bản lưu này';

  @override
  String get careerSlotsFull => 'Đã hết ô lưu';

  @override
  String careerSlotsUsed(int used) {
    return 'Ô LƯU  $used';
  }

  @override
  String get careerSlotsUnlockMore => 'Mở khóa thêm bản lưu';

  @override
  String get careerSlotsKeepNote =>
      'Mọi bản lưu bạn đang có vẫn chơi được bình thường. Chỉ bản lưu mới mới cần mở khóa.';

  @override
  String get careerNewGame => 'Trò chơi mới';

  @override
  String get careerDeleteSaveTitle => 'Xóa bản lưu?';

  @override
  String careerDeleteSaveBody(String label) {
    return 'Thao tác này sẽ xóa vĩnh viễn sự nghiệp $label của bạn.';
  }

  @override
  String get careerCancel => 'Hủy';

  @override
  String get careerDelete => 'Xóa';

  @override
  String get careerNoSavesYet =>
      'Chưa có bản lưu nào.\nHãy bắt đầu trò chơi mới để dẫn dắt một đội tuyển.';

  @override
  String get careerUnknownNation => 'Không rõ';

  @override
  String careerPlayedMinutes(int minutes) {
    return '$minutes phút';
  }

  @override
  String careerPlayedHours(int hours, int minutes) {
    return '$hours giờ $minutes phút';
  }

  @override
  String careerLastPlayed(String when) {
    return 'Chơi lần cuối $when';
  }

  @override
  String get careerJustNow => 'vừa xong';

  @override
  String get careerYesterday => 'hôm qua';

  @override
  String careerMinutesAgo(int n) {
    return '$n phút trước';
  }

  @override
  String careerHoursAgo(int n) {
    return '$n giờ trước';
  }

  @override
  String careerDaysAgo(int n) {
    return '$n ngày trước';
  }

  @override
  String careerRoadToWorldCup(int year) {
    return 'Hành trình tới Giải vô địch thế giới $year';
  }

  @override
  String get careerManagerCareerTitle => 'SỰ NGHIỆP HUẤN LUYỆN';

  @override
  String careerCouldNotLoad(String error) {
    return 'Không thể tải.\n$error';
  }

  @override
  String get careerCycleByCycle => 'TỪNG CHU KỲ';

  @override
  String careerCyclesNationsLed(int cycles, int nations) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles chu kỳ',
    );
    String _temp1 = intl.Intl.pluralLogic(
      nations,
      locale: localeName,
      other: 'dẫn dắt $nations quốc gia',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get careerStatTitles => 'Danh hiệu';

  @override
  String get careerStatPlayed => 'Số trận';

  @override
  String get careerStatWon => 'Thắng';

  @override
  String get careerStatDrawn => 'Hòa';

  @override
  String get careerStatLost => 'Thua';

  @override
  String careerGoalsWinRate(
    int goalsFor,
    int goalsAgainst,
    String gd,
    int winRate,
  ) {
    return 'Bàn thắng $goalsFor–$goalsAgainst  ($gd)  ·  Tỷ lệ thắng $winRate%';
  }

  @override
  String get careerRecordResults => 'KẾT QUẢ KỶ LỤC';

  @override
  String get careerBestWin => 'Trận thắng đậm nhất';

  @override
  String get careerWorstDefeat => 'Trận thua đậm nhất';

  @override
  String careerVsOpponentDate(String opponent, String date) {
    return 'gặp $opponent · $date';
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
    return '${won}T ${drawn}H ${lost}B  ·  BT $goalsFor BB $goalsAgainst ($gd)';
  }

  @override
  String get careerWorldCupLabel => 'Giải vô địch thế giới';

  @override
  String get careerContinentalLabel => 'Châu lục';

  @override
  String get messagesTitle => 'TIN NHẮN';

  @override
  String get messagesNoMessagesYet => 'Chưa có tin nhắn nào.';

  @override
  String messagesCouldNotLoad(String error) {
    return 'Không thể tải tin nhắn.\n$error';
  }

  @override
  String get messagesDone => 'Xong';

  @override
  String get messagesNext => 'Tiếp theo';

  @override
  String get rankingWorldRanking => 'BẢNG XẾP HẠNG THẾ GIỚI';

  @override
  String rankingCouldNotLoad(String error) {
    return 'Không thể tải bảng xếp hạng.\n$error';
  }

  @override
  String get rankingNoRanking => 'Chưa có bảng xếp hạng.';

  @override
  String get rankingAll => 'TẤT CẢ';

  @override
  String get rankingYourTeam => 'ĐỘI CỦA BẠN';

  @override
  String get rankingYourRankingOverTime => 'THỨ HẠNG CỦA BẠN QUA THỜI GIAN';

  @override
  String rankingNowRank(int rank) {
    return 'hiện tại #$rank';
  }

  @override
  String rankingBestWorst(int best, int worst) {
    return 'cao nhất #$best · thấp nhất #$worst';
  }

  @override
  String get friendliesTitle => 'GIAO HỮU';

  @override
  String friendliesLoadError(String error) {
    return 'Không thể tải các trận giao hữu.\n$error';
  }

  @override
  String get friendliesContinue => 'Tiếp tục';

  @override
  String friendliesArrangeIntro(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count khung thời gian trống',
    );
    return 'Sắp xếp các trận khởi động cho $_temp0 trước trận đấu chính thức tiếp theo. Chạm vào một đối thủ, hoặc để trống.';
  }

  @override
  String get friendliesFree => 'Trống';

  @override
  String matchGoalsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count BÀN THẮNG',
      one: '1 BÀN THẮNG',
    );
    return '$_temp0';
  }

  @override
  String get matchGoalsTitle => 'BÀN THẮNG';

  @override
  String get matchGoalsNone => 'Không có bàn thắng';

  @override
  String get matchGoalPenalty => 'PĐ';

  @override
  String get matchGoalSetPiece => 'TCĐ';

  @override
  String matchGoalAssist(String name) {
    return 'kiến tạo $name';
  }

  @override
  String get friendliesHome => 'SÂN NHÀ';

  @override
  String get friendliesAway => 'SÂN KHÁCH';

  @override
  String get friendliesNoneThisWindow => 'Không có trận giao hữu nào đợt này';

  @override
  String friendliesConfirmCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count trận giao hữu',
    );
    return 'Xác nhận $_temp0';
  }

  @override
  String get friendliesMonthJan => 'Th1';

  @override
  String get friendliesMonthFeb => 'Th2';

  @override
  String get friendliesMonthMar => 'Th3';

  @override
  String get friendliesMonthApr => 'Th4';

  @override
  String get friendliesMonthMay => 'Th5';

  @override
  String get friendliesMonthJun => 'Th6';

  @override
  String get friendliesMonthJul => 'Th7';

  @override
  String get friendliesMonthAug => 'Th8';

  @override
  String get friendliesMonthSep => 'Th9';

  @override
  String get friendliesMonthOct => 'Th10';

  @override
  String get friendliesMonthNov => 'Th11';

  @override
  String get friendliesMonthDec => 'Th12';

  @override
  String get resultsMyMatches => 'TRẬN ĐẤU CỦA TÔI';

  @override
  String resultsCouldNotLoad(String error) {
    return 'Không thể tải kết quả.\n$error';
  }

  @override
  String get resultsNoFixtures => 'Không có trận đấu nào.';

  @override
  String get resultsVs => 'gặp';

  @override
  String get resultsStageQualifier => 'VÒNG LOẠI';

  @override
  String get resultsStageFriendly => 'GIAO HỮU';

  @override
  String get resultsStageGroupStage => 'VÒNG BẢNG';

  @override
  String get resultsStageSemiFinal => 'BÁN KẾT';

  @override
  String get resultsStageFinal => 'CHUNG KẾT';

  @override
  String get resultsStageContinentalClash => 'CONTINENTAL CLASH';

  @override
  String get resultsStageFinalsGroup => 'BẢNG CHUNG KẾT';

  @override
  String get resultsStageRoundOf32 => 'VÒNG 1/16';

  @override
  String get resultsStageRoundOf16 => 'VÒNG 1/8';

  @override
  String get resultsStageQuarterFinal => 'TỨ KẾT';

  @override
  String get resultsStageThirdPlace => 'TRANH HẠNG BA';

  @override
  String get matchSetupWarnCaptain =>
      'Chưa chọn đội trưởng. Chạm để trao băng đội trưởng cho ai đó';

  @override
  String matchSetupWarnCaptainInjured(String name) {
    return '$name đang chấn thương và không thể dẫn đội ra sân. Chạm để trao lại băng đội trưởng';
  }

  @override
  String matchSetupWarnCaptainSuspended(String name) {
    return '$name bị treo giò trận này. Chạm để trao lại băng đội trưởng';
  }

  @override
  String matchSetupWarnCaptainDropped(String name) {
    return '$name đang giữ băng đội trưởng nhưng không có trong danh sách đội hình. Chạm để trao lại';
  }

  @override
  String get matchSetupWarnSetPieces =>
      'Chưa chọn người đá tình huống cố định. Chạm để chọn người đứng ra thực hiện';

  @override
  String get matchSetupWarnBoth =>
      'Chưa có đội trưởng và người đá tình huống cố định. Chạm để chọn';

  @override
  String matchStageMatchday(int matchday) {
    return 'Vòng $matchday';
  }

  @override
  String get squadCaptain => 'Đội trưởng';

  @override
  String deptEffectYouth(int points) {
    return 'Tài năng học viện có chỉ số tổng cao hơn khoảng $points';
  }

  @override
  String deptEffectCommercial(String amount) {
    return 'Thu về $amount khi chu kỳ kết thúc';
  }

  @override
  String deptEffectMedical(int percent) {
    return 'Giảm $percent% chấn thương';
  }

  @override
  String deptEffectNaturalisation(int percent) {
    return '$percent% khả năng một cầu thủ nước ngoài xin chuyển đổi';
  }

  @override
  String deptEffectBoard(int points) {
    return '+$points độ kiên nhẫn của ban lãnh đạo trước khi bạn bị đe dọa mất ghế';
  }

  @override
  String get deptEffectNone => 'Không có tác dụng khi chưa cấp kinh phí';

  @override
  String get statsBestRated => 'Điểm số';

  @override
  String get statsMyCareer => 'Sự nghiệp';

  @override
  String get statsBestAverageRating => 'ĐIỂM TRUNG BÌNH CAO NHẤT';

  @override
  String get statsMyCareerRecord => 'THÀNH TÍCH CỦA BẠN';

  @override
  String get statsNoRatingsRecorded => 'Chưa ghi nhận điểm số trận đấu nào.';

  @override
  String get statsGroupRecord => 'Thành tích';

  @override
  String get statsGroupRuns => 'Chuỗi trận';

  @override
  String get statsGroupExtremes => 'Cực điểm';

  @override
  String get statsGroupSplits => 'Sân nhà và sân khách';

  @override
  String get statsGroupSquad => 'Cầu thủ của bạn';

  @override
  String get statsPlayed => 'Số trận đã đấu';

  @override
  String get statsWinDrawLoss => 'Thắng–hòa–thua';

  @override
  String get statsWinRate => 'Tỷ lệ thắng';

  @override
  String get statsGoals => 'Bàn thắng:bàn thua';

  @override
  String get statsCleanSheets => 'Giữ sạch lưới';

  @override
  String get statsFailedToScore => 'Không ghi được bàn';

  @override
  String get statsLongestWinStreak => 'Chuỗi thắng dài nhất';

  @override
  String get statsLongestUnbeaten => 'Chuỗi bất bại dài nhất';

  @override
  String get statsLongestCleanSheets => 'Chuỗi giữ sạch lưới dài nhất';

  @override
  String get statsLongestWinless => 'Chuỗi không thắng dài nhất';

  @override
  String get statsCurrentRun => 'Chuỗi bất bại hiện tại';

  @override
  String get statsBiggestWin => 'Thắng đậm nhất';

  @override
  String get statsHeaviestDefeat => 'Thua đậm nhất';

  @override
  String get statsMostGoalsInAGame => 'Nhiều bàn thắng nhất trong một trận';

  @override
  String get statsShootouts => 'Luân lưu thắng–thua';

  @override
  String get statsComebackWins => 'Thắng ngược dòng';

  @override
  String get statsHome => 'Sân nhà';

  @override
  String get statsAway => 'Sân khách';

  @override
  String get statsNeutral => 'Sân trung lập';

  @override
  String get statsCompetitive => 'Trận chính thức';

  @override
  String get statsFriendlies => 'Giao hữu';

  @override
  String get statsHatTricks => 'Hat-trick';

  @override
  String get statsBraces => 'Cú đúp';

  @override
  String get statsMotms => 'Danh hiệu cầu thủ hay nhất trận';

  @override
  String get statsAssists => 'Kiến tạo';

  @override
  String get statsCards => 'Thẻ phạt';

  @override
  String get statsBestRating => 'Điểm cá nhân cao nhất';

  @override
  String statsAppsShort(int apps) {
    return '$apps trận';
  }

  @override
  String statsMotmShort(int motms) {
    return '$motms hay nhất';
  }

  @override
  String get captainArmband => 'C';

  @override
  String get captainCurrent => 'Đội trưởng. Chạm để tước băng đội trưởng';

  @override
  String get captainFitBorn => 'Thủ lĩnh bẩm sinh';

  @override
  String get captainFitNatural => 'Đội trưởng thực thụ';

  @override
  String get captainFitCapable => 'Có thể đảm nhiệm';

  @override
  String get captainFitUnproven => 'Chưa phải thủ lĩnh';

  @override
  String get captainNone => 'Chưa chọn đội trưởng';

  @override
  String captainMoraleBoost(int morale) {
    return '+$morale tinh thần toàn đội';
  }

  @override
  String get resultsCategoryWorldCupQualifying =>
      'Vòng loại giải vô địch thế giới';

  @override
  String get resultsCategoryFriendlies => 'Giao hữu';

  @override
  String get resultsCategoryContinentalClash => 'Continental Clash';

  @override
  String get resultsCategoryNationsCup => 'Nations Cup';

  @override
  String get resultsCategoryContinentalCup => 'Cúp châu lục';

  @override
  String get resultsCategoryWorldCupQualifyingShort => 'VL VĐTG';

  @override
  String get resultsCategoryContinentalQualifyingShort => 'VL Cúp châu lục';

  @override
  String get resultsCategoryContinentalQualifying => 'Vòng loại Cúp châu lục';

  @override
  String get resultsCategoryWorldCupFinals =>
      'Vòng chung kết giải vô địch thế giới';

  @override
  String get resultsRoundResults => 'KẾT QUẢ VÒNG ĐẤU';

  @override
  String get resultsFriendlyInternationals => 'GIAO HỮU QUỐC TẾ';

  @override
  String get resultsKnockout => 'Vòng knock-out';

  @override
  String resultsEarlierMatches(int count) {
    return 'Các trận trước đó ($count)';
  }

  @override
  String resultsMatchday(int matchday) {
    return 'VÒNG $matchday';
  }

  @override
  String get resultsContinue => 'Tiếp tục';

  @override
  String resultsGroup(String name) {
    return 'BẢNG $name';
  }

  @override
  String get achievementsScreenTitle => 'THÀNH TỰU';

  @override
  String get achievementsChallengesTooltip => 'Thử thách';

  @override
  String get achievementsChallengesHeading => 'THỬ THÁCH';

  @override
  String get achievementsBrutalTests =>
      'Những phép thử khắc nghiệt cả sự nghiệp';

  @override
  String achievementsCouldNotLoad(String error) {
    return 'Không thể tải.\n$error';
  }

  @override
  String achievementsUnlockedCount(int earned, int total) {
    return 'Đã mở khóa $earned / $total';
  }

  @override
  String achievementsConqueredCount(int done, int total) {
    return 'Đã chinh phục $done / $total';
  }

  @override
  String get achievementsBoardSatisfaction => 'MỨC HÀI LÒNG CỦA BAN LÃNH ĐẠO';

  @override
  String achievementsUnlockedBanner(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'MỞ KHÓA $count THÀNH TỰU',
      one: 'MỞ KHÓA THÀNH TỰU',
    );
    return '$_temp0';
  }

  @override
  String get achCatWins => 'Chiến thắng';

  @override
  String get achCatMatches => 'Số trận';

  @override
  String get achCatQualifications => 'Vượt qua vòng loại';

  @override
  String get achCatTitles => 'Danh hiệu';

  @override
  String get achCatMisc => 'Khác';

  @override
  String get achCatMega => 'Siêu cấp';

  @override
  String get achCatGoals => 'Bàn thắng';

  @override
  String get achCatStreaks => 'Chuỗi trận';

  @override
  String get achTierBronze => 'Đồng';

  @override
  String get achTierSilver => 'Bạc';

  @override
  String get achTierGold => 'Vàng';

  @override
  String get achTierPlatinum => 'Bạch kim';

  @override
  String achGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bàn thắng',
    );
    return '$_temp0';
  }

  @override
  String achGoalsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ghi $count bàn thắng.',
      one: 'Ghi 1 bàn thắng.',
    );
    return '$_temp0';
  }

  @override
  String achCleanSheets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count trận giữ sạch lưới',
    );
    return '$_temp0';
  }

  @override
  String achCleanSheetsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Giữ sạch lưới $count trận.',
      one: 'Giữ sạch lưới 1 trận.',
    );
    return '$_temp0';
  }

  @override
  String get achStreakWin5 => 'Thói quen chiến thắng';

  @override
  String get achStreakWin5Desc => 'Thắng năm trận liên tiếp.';

  @override
  String get achStreakWin10 => 'Đang thăng hoa';

  @override
  String get achStreakWin10Desc => 'Thắng mười trận liên tiếp.';

  @override
  String get achStreakWin20 => 'Cỗ xe tăng';

  @override
  String get achStreakWin20Desc => 'Thắng hai mươi trận liên tiếp.';

  @override
  String get achUnbeaten15 => 'Khó bị đánh bại';

  @override
  String get achUnbeaten15Desc => 'Bất bại mười lăm trận liên tiếp.';

  @override
  String get achUnbeaten30 => 'Bất khả xâm phạm';

  @override
  String get achUnbeaten30Desc => 'Bất bại ba mươi trận liên tiếp.';

  @override
  String get achHattrick => 'Người hùng hat-trick';

  @override
  String get achHattrickDesc => 'Có một cầu thủ ghi hat-trick.';

  @override
  String get achMotm10 => 'Nổi bật';

  @override
  String get achMotm10Desc => 'Giành 10 danh hiệu cầu thủ hay nhất trận.';

  @override
  String get achMotm50 => 'Linh hồn của đội';

  @override
  String get achMotm50Desc => 'Giành 50 danh hiệu cầu thủ hay nhất trận.';

  @override
  String get achPerfect => 'Điểm mười hoàn hảo';

  @override
  String get achPerfectDesc =>
      'Có một cầu thủ đạt điểm trận đấu từ 9,5 trở lên.';

  @override
  String get achShootout => 'Máu lạnh';

  @override
  String get achShootoutDesc => 'Thắng năm loạt sút luân lưu.';

  @override
  String get achMassacre => 'Cuộc tàn sát';

  @override
  String get achMassacreDesc => 'Thắng một trận cách biệt từ 7 bàn trở lên.';

  @override
  String get achAnnihilation => 'Hủy diệt';

  @override
  String get achAnnihilationDesc =>
      'Thắng một trận cách biệt từ 10 bàn trở lên.';

  @override
  String get chTierBronze => 'Đồng';

  @override
  String get chTierSilver => 'Bạc';

  @override
  String get chTierGold => 'Vàng';

  @override
  String get chTierLegendary => 'Huyền thoại';

  @override
  String get chFirstSteps => 'Trên băng ghế huấn luyện';

  @override
  String get chFirstStepsDesc => 'Cầm quân trong 5 năm.';

  @override
  String get chUnbeaten10 => 'Đang thăng hoa';

  @override
  String get chUnbeaten10Desc => 'Bất bại 10 trận chính thức liên tiếp.';

  @override
  String get chTwoNations => 'Thử thách mới';

  @override
  String get chTwoNationsDesc => 'Dẫn dắt 2 quốc gia khác nhau.';

  @override
  String get chCont1 => 'Nhà vô địch châu lục';

  @override
  String get chCont1Desc => 'Giành một chức vô địch châu lục.';

  @override
  String get chNc1 => 'Nhà vô địch Nations Cup';

  @override
  String get chNc1Desc => 'Giành chức vô địch Nations Cup.';

  @override
  String get chWc1 => 'Nhà vô địch thế giới';

  @override
  String get chWc1Desc => 'Giành chức vô địch Giải vô địch thế giới.';

  @override
  String get chYears25 => 'Bậc lão làng';

  @override
  String get chYears25Desc => 'Cầm quân trong 25 năm.';

  @override
  String get chWc3 => 'Kẻ thống trị';

  @override
  String get chWc3Desc => 'Giành 3 chức vô địch Giải vô địch thế giới.';

  @override
  String get chWc5 => 'Triều đại';

  @override
  String get chWc5Desc => 'Giành 5 chức vô địch Giải vô địch thế giới.';

  @override
  String get chWc10 => 'Bất tử';

  @override
  String get chWc10Desc => 'Giành 10 chức vô địch Giải vô địch thế giới.';

  @override
  String get chWc2Teams => 'Đôi giày lãng du';

  @override
  String get chWc2TeamsDesc =>
      'Vô địch Giải vô địch thế giới với 2 quốc gia khác nhau.';

  @override
  String get chWc3Teams => 'Người chu du khắp chốn';

  @override
  String get chWc3TeamsDesc =>
      'Vô địch Giải vô địch thế giới với 3 quốc gia khác nhau.';

  @override
  String get chWcStreak3 => 'Ba lần liên tiếp';

  @override
  String get chWcStreak3Desc =>
      'Vô địch Giải vô địch thế giới 3 lần liên tiếp.';

  @override
  String get chWcAllconf => 'Kẻ chinh phục thế giới';

  @override
  String get chWcAllconfDesc =>
      'Vô địch Giải vô địch thế giới với một quốc gia thuộc mỗi liên đoàn châu lục (6).';

  @override
  String get chCont5 => 'Vua châu lục';

  @override
  String get chCont5Desc => 'Giành 5 chức vô địch châu lục.';

  @override
  String get chContAll => 'Cú đại thắng sáu châu lục';

  @override
  String get chContAllDesc =>
      'Giành chức vô địch châu lục của cả sáu liên đoàn châu lục (6).';

  @override
  String get chTreble => 'Quét sạch mọi danh hiệu';

  @override
  String get chTrebleDesc =>
      'Giành Giải vô địch thế giới, một danh hiệu châu lục và Nations Cup trong cùng một sự nghiệp.';

  @override
  String get chNations10 => 'Kẻ du mục';

  @override
  String get chNations10Desc => 'Dẫn dắt 10 quốc gia khác nhau.';

  @override
  String get chYears100 => 'Một thế kỷ';

  @override
  String get chYears100Desc => 'Cầm quân trong 100 năm.';

  @override
  String get chYears500 => 'Nửa thiên niên kỷ';

  @override
  String get chYears500Desc => 'Cầm quân trong 500 năm.';

  @override
  String get chYears1000 => 'Vĩnh cửu';

  @override
  String get chYears1000Desc => 'Cầm quân trong 1000 năm.';

  @override
  String get chGrandmaster => 'Đại kiện tướng';

  @override
  String get chGrandmasterDesc =>
      'Giành 3 chức vô địch Giải vô địch thế giới VÀ 5 chức vô địch châu lục.';

  @override
  String get chUndefeated => 'Bất khả xâm phạm';

  @override
  String get chUndefeatedDesc =>
      'Vô địch Giải vô địch thế giới mà không thua trận nào.';

  @override
  String get chPerfectQual => 'Chặng đường hoàn hảo';

  @override
  String get chPerfectQualDesc =>
      'Thắng mọi trận trong một chiến dịch vòng loại giải vô địch thế giới.';

  @override
  String get chMinnow => 'Phép màu của đội tuyển yếu';

  @override
  String get chMinnowDesc =>
      'Vô địch Giải vô địch thế giới với một quốc gia xếp ngoài top 32 thế giới.';

  @override
  String get chGrandTour => 'Sân nhà và sân khách';

  @override
  String get chGrandTourDesc =>
      'Vô địch Giải vô địch thế giới trên cương vị chủ nhà và một lần nữa khi thi đấu xa nhà.';

  @override
  String get chUnbeaten25 => 'Bức tường thành';

  @override
  String get chUnbeaten25Desc => 'Bất bại 25 trận chính thức liên tiếp.';

  @override
  String get chGoals10k => 'Cỗ máy ghi bàn';

  @override
  String get chGoals10kDesc => 'Ghi 10.000 bàn thắng trong sự nghiệp.';

  @override
  String get chCleanSheets500 => 'Pháo đài';

  @override
  String get chCleanSheets500Desc => 'Giữ sạch lưới 500 trận trong sự nghiệp.';

  @override
  String get chHatTricks25 => 'Nghiện hat-trick';

  @override
  String get chHatTricks25Desc => 'Có các cầu thủ của bạn ghi 25 hat-trick.';

  @override
  String get chWinStreak25 => 'Không biết mệt mỏi';

  @override
  String get chWinStreak25Desc => 'Thắng 25 trận liên tiếp.';

  @override
  String get chCont10 => 'Triều đại châu lục';

  @override
  String get chCont10Desc => 'Giành 10 chức vô địch châu lục.';

  @override
  String get chPcWc => 'Nhà vô địch liên hoàn';

  @override
  String chPcWcDesc(int count) {
    return 'Giành $count chức vô địch Giải vô địch thế giới trong bản lưu này.';
  }

  @override
  String get chPcMajors => 'Người sưu tầm cúp';

  @override
  String chPcMajorsDesc(int count) {
    return 'Giành $count danh hiệu lớn (Giải vô địch thế giới, châu lục hoặc Nations Cup).';
  }

  @override
  String get chPcUnbeaten => 'Bức tường sắt';

  @override
  String chPcUnbeatenDesc(int count) {
    return 'Bất bại $count trận chính thức liên tiếp.';
  }

  @override
  String get chPcNations => 'Người đi khắp nơi';

  @override
  String chPcNationsDesc(int count) {
    return 'Dẫn dắt $count quốc gia khác nhau.';
  }

  @override
  String get chPcYears => 'Chặng đường dài';

  @override
  String chPcYearsDesc(int count) {
    return 'Cầm quân trong $count năm.';
  }

  @override
  String achWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count chiến thắng',
      one: '1 chiến thắng',
    );
    return '$_temp0';
  }

  @override
  String achWinsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Thắng $count trận.',
      one: 'Thắng 1 trận.',
    );
    return '$_temp0';
  }

  @override
  String achMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count trận đấu',
    );
    return '$_temp0';
  }

  @override
  String achMatchesDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Thi đấu $count trận.',
      one: 'Thi đấu 1 trận.',
    );
    return '$_temp0';
  }

  @override
  String get achQualWc => 'Có vé dự giải vô địch thế giới';

  @override
  String get achQualWcDesc => 'Giành vé dự Giải vô địch thế giới.';

  @override
  String get achQualCont => 'Có vé dự giải châu lục';

  @override
  String get achQualContDesc => 'Giành vé dự giải vô địch châu lục của bạn.';

  @override
  String get achTitleWc => 'Nhà vô địch thế giới';

  @override
  String get achTitleWcDesc => 'Giành chức vô địch Giải vô địch thế giới.';

  @override
  String get achTitleEuro => 'Nhà vô địch châu Âu';

  @override
  String get achTitleEuroDesc => 'Giành chức vô địch Giải vô địch châu Âu.';

  @override
  String get achTitleCopa => 'Nhà vô địch Nam Mỹ';

  @override
  String get achTitleCopaDesc => 'Giành chức vô địch Cúp Nam Mỹ.';

  @override
  String get achTitleAfcon => 'Nhà vô địch châu Phi';

  @override
  String get achTitleAfconDesc => 'Giành chức vô địch Giải vô địch châu Phi.';

  @override
  String get achTitleAsia => 'Nhà vô địch châu Á';

  @override
  String get achTitleAsiaDesc => 'Giành chức vô địch Giải vô địch châu Á.';

  @override
  String get achTitleConcacaf => 'Nhà vô địch Bắc Mỹ';

  @override
  String get achTitleConcacafDesc => 'Giành chức vô địch Nations Cup Bắc Mỹ.';

  @override
  String get achTitleOfc => 'Nhà vô địch châu Đại Dương';

  @override
  String get achTitleOfcDesc => 'Giành chức vô địch Cúp châu Đại Dương.';

  @override
  String get achTitleNations => 'Nhà vô địch Nations Cup';

  @override
  String get achTitleNationsDesc => 'Giành chức vô địch Nations Cup.';

  @override
  String get achTitleClash => 'Nhà vô địch Continental Clash';

  @override
  String get achTitleClashDesc => 'Giành chức vô địch Continental Clash.';

  @override
  String get achMarksman => 'Xạ thủ giải vô địch thế giới';

  @override
  String get achMarksmanDesc =>
      'Có một cầu thủ trong đội hình ghi từ 6 bàn trở lên ở vòng chung kết Giải vô địch thế giới.';

  @override
  String get achSweep => 'Quét sạch mọi danh hiệu';

  @override
  String get achSweepDesc =>
      'Giữ cả chức vô địch thế giới và danh hiệu châu lục trong cùng một sự nghiệp.';

  @override
  String get achAllstar => 'Ngôi sao giải đấu';

  @override
  String get achAllstarDesc =>
      'Có một cầu thủ được chọn vào Đội hình tiêu biểu của Giải vô địch thế giới.';

  @override
  String get achGoldenboot => 'Chiếc giày vàng';

  @override
  String get achGoldenbootDesc =>
      'Để đội tuyển của bạn có vua phá lưới giải vô địch.';

  @override
  String get achDemolition => 'Phá hủy';

  @override
  String get achDemolitionDesc => 'Thắng một trận cách biệt từ 5 bàn trở lên.';

  @override
  String get achievementsNice => 'Tuyệt!';

  @override
  String get achievementsHardestTests =>
      'Những phép thử khó nhất của một huấn luyện viên, xuyên suốt sự nghiệp và qua nhiều quốc gia.';

  @override
  String get achievementsThisSave => 'BẢN LƯU NÀY';

  @override
  String get achievementsBrutalBadge => 'KHẮC NGHIỆT';

  @override
  String get paywallGoPro => 'NÂNG CẤP UNLIMITED';

  @override
  String get paywallOneTimeUnlock => 'Mở khóa một lần. Không đăng ký định kỳ.';

  @override
  String get paywallBenefitCarryOn =>
      'Bản lưu này tiếp tục đúng từ chỗ đã dừng, với mọi lần khoác áo đội tuyển, kỷ lục và mối thù truyền kiếp còn nguyên vẹn.';

  @override
  String get paywallBenefitNoAds =>
      'Không quảng cáo, không giao dịch vi mô, không đăng ký định kỳ. Một lần thanh toán, và mọi bản cập nhật sau này đều thuộc về bạn.';

  @override
  String get paywallBenefitSaves =>
      'Bao nhiêu bản lưu tùy thích. Dẫn dắt một đội mạnh và một đội yếu cùng lúc, rồi xem cùng một trò chơi khác nhau đến mức nào.';

  @override
  String get paywallBenefitEndless =>
      'Mọi chu kỳ từ nay về sau. Chọn một cầu thủ mười bảy tuổi ngay hôm nay, và đến năm 2034 bạn sẽ biết mình có nhìn đúng hay không.';

  @override
  String get paywallUnlocked => 'Unlimited đã được mở khóa. Chúc bạn chơi vui!';

  @override
  String get paywallContactingStore => 'Đang kết nối cửa hàng…';

  @override
  String paywallUnlockProPriced(String price) {
    return 'Mở khóa Unlimited · $price';
  }

  @override
  String get paywallRestorePurchases => 'Khôi phục giao dịch mua';

  @override
  String get paywallStoreUnavailable => 'Cửa hàng không khả dụng';

  @override
  String get paywallStoreUnavailableNote =>
      'Không thể tải giá. Hãy kiểm tra kết nối và thử lại.';

  @override
  String get paywallTryAgain => 'Thử lại';

  @override
  String get gateTitle => 'CHU KỲ ĐẦU TIÊN CỦA BẠN ĐÃ KẾT THÚC';

  @override
  String get gateLead =>
      'Bốn năm là một chu kỳ. Chừng đó chưa đủ để biết bạn có đúng hay không.';

  @override
  String get gatePriceLead => 'Một lần thanh toán, mãi mãi';

  @override
  String get gateBuy => 'MUA VÀ TIẾP TỤC';

  @override
  String get gateExit => 'THOÁT';

  @override
  String get federationNaturalisation => 'NHẬP TỊCH';

  @override
  String federationNaturalisedTitle(String name) {
    return '$name đã nhập tịch';
  }

  @override
  String federationNaturalisedBody(String name, String nation) {
    return '$name đã hoàn tất việc chuyển đổi và hiện đủ điều kiện khoác áo $nation. Hãy triệu tập cầu thủ này từ danh sách đội hình của bạn.';
  }

  @override
  String federationCouldNotLoadOffer(String error) {
    return 'Không thể tải đề nghị.\n$error';
  }

  @override
  String get federationContinue => 'Tiếp tục';

  @override
  String get federationOfferToSwitchAllegiance => 'ĐỀ NGHỊ ĐỔI ĐỘI TUYỂN';

  @override
  String federationPlayerMeta(String position, int age, String nation) {
    return '$position · $age tuổi · từ $nation';
  }

  @override
  String federationNaturalisationBlurb(
    String name,
    String playerNation,
    String sourceNation,
  ) {
    return '$name có gốc gác liên quan đến $playerNation và sẵn sàng nhập tịch. Chấp nhận thì cầu thủ có thể được chọn; từ chối thì cầu thủ ở lại với $sourceNation.';
  }

  @override
  String get federationDecline => 'Từ chối';

  @override
  String get federationNaturalise => 'Nhập tịch';

  @override
  String get federationBudgetLater => 'Quyết định sau';

  @override
  String get federationSetYourBudget => 'THIẾT LẬP NGÂN SÁCH';

  @override
  String federationCouldNotLoadFinances(String error) {
    return 'Không thể tải dữ liệu tài chính.\n$error';
  }

  @override
  String get federationSaveNotFound => 'Không tìm thấy bản lưu.';

  @override
  String get federationBudgetHeading => 'NGÂN SÁCH LIÊN ĐOÀN';

  @override
  String federationDistributeBudget(String amount) {
    return 'Phân bổ $amount cho các bộ phận để mở chu kỳ. Hãy chi tiêu khôn ngoan.';
  }

  @override
  String federationOverBudget(String amount) {
    return 'Vượt $amount so với số tiền liên đoàn có. Hãy rút bớt lại';
  }

  @override
  String get federationAllocateFullBudget =>
      'Hãy phân bổ toàn bộ ngân sách để bắt đầu chu kỳ.';

  @override
  String get federationConfirming => 'Đang xác nhận…';

  @override
  String get federationConfirmBudget => 'Xác nhận ngân sách';

  @override
  String get federationFinances => 'TÀI CHÍNH';

  @override
  String get federationInvestmentUpdated => 'Đã cập nhật khoản đầu tư.';

  @override
  String get federationDevelopment => 'PHÁT TRIỂN LIÊN ĐOÀN';

  @override
  String get federationProjectedAtSeasonEnd => 'DỰ KIẾN CUỐI MÙA GIẢI';

  @override
  String get federationCentralFunding => 'Tài trợ trung ương';

  @override
  String get federationPrizeMoneySoFar => 'Tiền thưởng đến nay';

  @override
  String get federationCommercialReturn => 'Lợi nhuận thương mại';

  @override
  String get federationThisSeasonLocked => 'MÙA GIẢI NÀY (ĐÃ KHÓA)';

  @override
  String get federationInvestForNextSeason => 'ĐẦU TƯ CHO MÙA GIẢI TỚI';

  @override
  String get federationNextSeasonImpact => 'TÁC ĐỘNG MÙA GIẢI TỚI';

  @override
  String get federationSaving => 'Đang lưu…';

  @override
  String get federationConfirmInvestment => 'Xác nhận đầu tư';

  @override
  String get federationBalance => 'SỐ DƯ LIÊN ĐOÀN';

  @override
  String get federationCommittedToStaff => 'Dành cho ban huấn luyện';

  @override
  String get federationFreeToSpend => 'Có thể chi tiêu';

  @override
  String get federationWagesNote =>
      'Tiền lương sẽ được trừ vào số dư khi kết thúc chu kỳ, nên khoản này đã có chủ.';

  @override
  String get federationInvestAtCeremony =>
      'Đầu tư cho mùa giải tới tại lễ tổng kết cuối chu kỳ.';

  @override
  String federationLevelBadge(int level) {
    return 'L$level';
  }

  @override
  String get federationAcademyProspects => 'Tài năng học viện';

  @override
  String federationPlusOverall(int value) {
    return '+$value chỉ số tổng';
  }

  @override
  String get federationInjuryRisk => 'Nguy cơ chấn thương';

  @override
  String get federationNaturalisationChance => 'Cơ hội nhập tịch';

  @override
  String get federationBoardPatience => 'Sự kiên nhẫn của ban lãnh đạo';

  @override
  String get federationUnallocated => 'CHƯA PHÂN BỔ';

  @override
  String get nationsVitrineTitle => 'TỦ CÚP QUỐC GIA';

  @override
  String nationsCouldNotLoad(String error) {
    return 'Không thể tải quốc gia.\n$error';
  }

  @override
  String get nationsNoNation => 'Không có quốc gia.';

  @override
  String get nationsHonours => 'DANH HIỆU';

  @override
  String get nationsRankingHistory => 'LỊCH SỬ XẾP HẠNG THẾ GIỚI';

  @override
  String get nationsTopScorers => 'VUA PHÁ LƯỚI MỌI THỜI ĐẠI';

  @override
  String get nationsTitles => 'CÁC CHỨC VÔ ĐỊCH';

  @override
  String get nationsYourTeam => 'ĐỘI CỦA BẠN';

  @override
  String get nationsWorld => 'THẾ GIỚI';

  @override
  String get nationsWorldCup => 'Giải vô địch thế giới';

  @override
  String get nationsContinental => 'Châu lục';

  @override
  String nationsAppearances(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lần tham dự',
      one: '1 lần tham dự',
    );
    return '$_temp0';
  }

  @override
  String get nationsNotEnoughHistory =>
      'Chưa đủ lịch sử. Hãy quay lại sau một hai chu kỳ.';

  @override
  String nationsBestRank(int rank) {
    return 'Cao nhất: #$rank';
  }

  @override
  String nationsNowRank(int rank) {
    return 'Hiện tại: #$rank';
  }

  @override
  String get nationsNoGoals => 'Chưa ghi nhận bàn thắng nào.';

  @override
  String get nationsGoalsAbbrev => 'bt';

  @override
  String get nationsHosts => 'CHỦ NHÀ';

  @override
  String get nationsSelectTitle => 'CHỌN ĐỘI TUYỂN QUỐC GIA';

  @override
  String nationsCouldNotLoadNations(String error) {
    return 'Không thể tải danh sách quốc gia.\n$error';
  }

  @override
  String get nationsNoMatch => 'Không có quốc gia phù hợp.';

  @override
  String get nationsNationalLevel => 'TRÌNH ĐỘ QUỐC GIA';

  @override
  String get nationsSelectHeading => 'Chọn đội tuyển quốc gia';

  @override
  String get nationsSearchHint => 'Tìm quốc gia…';

  @override
  String get nationsRank => 'HẠNG  ';

  @override
  String get nationsPremium => 'PREMIUM';

  @override
  String get nationsSelect => 'CHỌN';

  @override
  String get statsTeamRecords => 'KỶ LỤC ĐỘI TUYỂN';

  @override
  String get statsRecordBook => 'Sổ kỷ lục';

  @override
  String statsCouldNotLoadStats(String error) {
    return 'Không thể tải thống kê.\n$error';
  }

  @override
  String get statsNoData => 'Không có dữ liệu.';

  @override
  String get statsTopScorers => 'VUA PHÁ LƯỚI';

  @override
  String get statsMostGamesPlayed => 'RA SÂN NHIỀU NHẤT';

  @override
  String get statsTeam => 'Đội';

  @override
  String get statsTopScorersShort => 'Ghi bàn';

  @override
  String get statsMostGames => 'Ra sân nhiều';

  @override
  String get statsNoGoalsRecorded => 'Chưa ghi nhận bàn thắng nào.';

  @override
  String get statsUnknown => 'Không rõ';

  @override
  String get playerTitle => 'CẦU THỦ';

  @override
  String playerLoadError(String error) {
    return 'Không thể tải cầu thủ.\n$error';
  }

  @override
  String get playerNotFound => 'Không tìm thấy cầu thủ.';

  @override
  String get playerClub => 'CÂU LẠC BỘ';

  @override
  String get playerClubRole => 'Tại câu lạc bộ';

  @override
  String get playerPosition => 'Vị trí';

  @override
  String get playerPotential => 'Tiềm năng';

  @override
  String get playerAge => 'Tuổi';

  @override
  String get playerValue => 'Giá trị';

  @override
  String get clubFirstChoice => 'Đá chính mọi trận';

  @override
  String get clubRotation => 'Lúc đá lúc không';

  @override
  String get clubFringe => 'Hiếm khi ra sân';

  @override
  String get clubFrozenOut => 'Không được ra sân';

  @override
  String clubAtClub(String club, String standing) {
    return '$club: $standing';
  }

  @override
  String yWinUpset0(String opponent, String score) {
    return 'Tôi xem bóng đá ba mươi năm rồi mà không ngờ tới điều này. $opponent bị đánh bại $score.';
  }

  @override
  String yWinUpset1(String opponent, String score) {
    return 'Chẳng ai cho họ cơ hội nào trước $opponent. $score. Hoàn toàn không một ai.';
  }

  @override
  String yWinUpset2(String opponent, String score) {
    return '$score trước $opponent. Đi gọi hàng xóm dậy đi.';
  }

  @override
  String yWinUpset3(String opponent, String score) {
    return 'Đây là kiểu đêm mà người ta sẽ kể lại cho cháu chắt. $opponent $score.';
  }

  @override
  String yWinUpset4(String opponent, String score) {
    return '$score trước $opponent. Dù chuyện đó xảy ra bằng cách nào, thì nó đã xảy ra.';
  }

  @override
  String yWinUpset5(String opponent, String score) {
    return 'Trên giấy tờ, trận này đã xong từ trước khi bắt đầu. $opponent $score nói điều ngược lại.';
  }

  @override
  String yWinUpset6(String opponent, String score) {
    return 'Thắng $opponent $score. Một năm nữa sẽ chẳng ai tin tỷ số đó.';
  }

  @override
  String yWinUpset7(String opponent, String score) {
    return '$opponent $score. Cứ tận hưởng đi, rồi hãy nhìn lịch thi đấu.';
  }

  @override
  String yWinUpset8(String opponent, String score) {
    return '$score trước $opponent, và chúng ta may mắn suốt tám mươi trên chín mươi phút.';
  }

  @override
  String yWinUpset9(String opponent, String score) {
    return 'Một đêm trước $opponent không xóa được cả một năm. $score.';
  }

  @override
  String yWinUpset10(String opponent, String score) {
    return 'Thắng $opponent $score và giờ người ta sẽ bảo chúng ta đã bước qua khúc quanh. Chưa đâu.';
  }

  @override
  String yWinUpset11(String opponent, String score) {
    return '$opponent $score. Tuyệt vời. Khi nào có chuyện quan trọng thì hỏi lại tôi.';
  }

  @override
  String yWinRoutine0(String opponent, String score) {
    return 'Thắng $opponent $score. Đúng như lẽ phải có, và điều đó cũng có niềm vui riêng.';
  }

  @override
  String yWinRoutine1(String opponent, String score) {
    return '$score trước $opponent. Lạnh lùng, mà lạnh lùng là lời khen.';
  }

  @override
  String yWinRoutine2(String opponent, String score) {
    return '$opponent $score. Không ồn ào, không hoảng hốt, không gì để phàn nàn.';
  }

  @override
  String yWinRoutine3(String opponent, String score) {
    return 'Một chiến thắng $score gọn gàng trước $opponent. Một đội bóng tốt trong ngày yên ả trông là như vậy.';
  }

  @override
  String yWinRoutine4(String opponent, String score) {
    return '$score trước $opponent. Xong việc, chẳng học được gì.';
  }

  @override
  String yWinRoutine5(String opponent, String score) {
    return 'Thắng $opponent $score. Chúng ta phải thắng, và đã thắng.';
  }

  @override
  String yWinRoutine6(String opponent, String score) {
    return 'Chiến thắng $score chuyên nghiệp trước $opponent. Tiếp theo.';
  }

  @override
  String yWinRoutine7(String opponent, String score) {
    return '$opponent bị hạ gục $score. Ghi sổ rồi đi tiếp.';
  }

  @override
  String yWinRoutine8(String opponent, String score) {
    return '$score trước $opponent và chúng ta phải vỗ tay. Chỉ vì thắng họ.';
  }

  @override
  String yWinRoutine9(String opponent, String score) {
    return 'Chúc mừng mọi người có liên quan đến chiến thắng $score trước $opponent, tôi đoán vậy.';
  }

  @override
  String yWinRoutine10(String opponent, String score) {
    return '$opponent $score. Thắng những đội như thế là mức tối thiểu, không phải thành tích.';
  }

  @override
  String yWinRoutine11(String opponent, String score) {
    return 'Chúng ta thắng $opponent $score và trông rất nặng nề.';
  }

  @override
  String yWinTight0(String opponent, String score) {
    return '$score trước $opponent và từng phút đều phải đổ mồ hôi mới có.';
  }

  @override
  String yWinTight1(String opponent, String score) {
    return 'Cần có bản lĩnh. $opponent $score.';
  }

  @override
  String yWinTight2(String opponent, String score) {
    return 'Thắng $opponent $score theo cách khó khăn, và đó là cách bền vững.';
  }

  @override
  String yWinTight3(String opponent, String score) {
    return '$score trước $opponent. Những đội thắng kiểu này là những đội vẫn trụ lại đến tháng Sáu.';
  }

  @override
  String yWinTight4(String opponent, String score) {
    return 'Căng thẳng, xấu xí, nhưng là một chiến thắng. $opponent $score.';
  }

  @override
  String yWinTight5(String opponent, String score) {
    return 'Thắng $opponent $score. Lấy ba điểm và đừng bao giờ xem lại.';
  }

  @override
  String yWinTight6(String opponent, String score) {
    return '$score. $opponent bắt chúng ta phải vất vả giành từng tấc đất.';
  }

  @override
  String yWinTight7(String opponent, String score) {
    return '$opponent $score. Không đẹp. Nhưng tính như nhau.';
  }

  @override
  String yWinTight8(String opponent, String score) {
    return '$score trước $opponent và chúng ta tự làm nó khó gấp mười lần cần thiết.';
  }

  @override
  String yWinTight9(String opponent, String score) {
    return 'Lẽ ra chúng ta không phải chật vật trụ lại trước $opponent. $score.';
  }

  @override
  String yWinTight10(String opponent, String score) {
    return '$opponent $score. Thắng rồi, nhưng chẳng biết thêm điều gì tốt về chính mình.';
  }

  @override
  String yWinTight11(String opponent, String score) {
    return 'Một tỷ số $score quá hào phóng với chúng ta trước $opponent.';
  }

  @override
  String yDrew0(String opponent, String score) {
    return 'Một điểm trước $opponent, $score. Nhận lấy và đi tiếp.';
  }

  @override
  String yDrew1(String opponent, String score) {
    return '$score với $opponent. Còn có những buổi chiều tệ hơn thế này.';
  }

  @override
  String yDrew2(String opponent, String score) {
    return 'Cầm hòa $opponent $score. Không phải chuyện gì cũng cần thành câu chuyện.';
  }

  @override
  String yDrew3(String opponent, String score) {
    return '$opponent $score. Một điểm là một điểm, bảng xếp hạng không hỏi bằng cách nào.';
  }

  @override
  String yDrew4(String opponent, String score) {
    return '$score với $opponent. Mất hai điểm hay được một điểm. Tùy tâm trạng bạn.';
  }

  @override
  String yDrew5(String opponent, String score) {
    return 'Hòa $opponent, $score. Không ai vui, không ai giận dữ.';
  }

  @override
  String yDrew6(String opponent, String score) {
    return '$opponent $score. Chín mươi phút dễ quên nhất trong năm.';
  }

  @override
  String yDrew7(String opponent, String score) {
    return 'Chia điểm với $opponent, $score. Tiếp tục thôi.';
  }

  @override
  String yDrew8(String opponent, String score) {
    return '$score trước $opponent. Những trận hòa thế này là cách một chiến dịch lặng lẽ chết đi.';
  }

  @override
  String yDrew9(String opponent, String score) {
    return 'Hai điểm bị ném đi trước $opponent. $score. Không còn gì khác để gọi.';
  }

  @override
  String yDrew10(String opponent, String score) {
    return '$opponent $score. Chúng ta có chín mươi phút mà không biết làm gì với chúng.';
  }

  @override
  String yDrew11(String opponent, String score) {
    return 'Một trận $score với $opponent mà không ai nhớ và ai cũng sẽ phải trả giá.';
  }

  @override
  String yLost0(String opponent, String score) {
    return 'Thua $opponent $score. Chuyện xảy ra thôi.';
  }

  @override
  String yLost1(String opponent, String score) {
    return '$opponent $score. Chẳng có gì để treo cổ ai cả. Sang trận tiếp theo.';
  }

  @override
  String yLost2(String opponent, String score) {
    return 'Thua $opponent $score dù đã cống hiến hết mình. Có những ngày như thế vẫn chưa đủ.';
  }

  @override
  String yLost3(String opponent, String score) {
    return '$score trước $opponent. Ngẩng cao đầu. Đội bóng này còn rất nhiều thứ.';
  }

  @override
  String yLost4(String opponent, String score) {
    return '$opponent $score. Chúng ta kém hơn và không có gì để cãi.';
  }

  @override
  String yLost5(String opponent, String score) {
    return 'Thua $opponent $score. Tập hợp lại thôi.';
  }

  @override
  String yLost6(String opponent, String score) {
    return '$score trước $opponent. Không phải nỗi nhục, nhưng chưa đủ tốt.';
  }

  @override
  String yLost7(String opponent, String score) {
    return 'Thua $opponent $score. Hãy học được điều gì đó, nếu không thì công cốc.';
  }

  @override
  String yLost8(String opponent, String score) {
    return '$score trước $opponent và chúng ta không chạm nổi vào họ.';
  }

  @override
  String yLost9(String opponent, String score) {
    return 'Thua $opponent, $score. Cùng những vấn đề, cùng tháng này, những lời bào chữa cũ sắp tới.';
  }

  @override
  String yLost10(String opponent, String score) {
    return '$opponent $score. Đến bao giờ thì chuyện này thôi được gọi là xui xẻo?';
  }

  @override
  String yLost11(String opponent, String score) {
    return 'Thua $opponent $score. Một kết quả đáng lẽ phải khiến ai đó trả giá.';
  }

  @override
  String yLostBadly0(String opponent, String score) {
    return '$score trước $opponent. Một đêm tồi tệ. Hãy đánh giá đội qua cả chiến dịch, không phải trận này.';
  }

  @override
  String yLostBadly1(String opponent, String score) {
    return 'Không ai muốn thấy tỷ số $score trước $opponent hơn chính các cầu thủ.';
  }

  @override
  String yLostBadly2(String opponent, String score) {
    return '$opponent $score. Xấu xí, và không phải con người thật của đội này.';
  }

  @override
  String yLostBadly3(String opponent, String score) {
    return 'Một trận $score đáng quên trước $opponent. Lần sau họ sẽ đứng lên.';
  }

  @override
  String yLostBadly4(String opponent, String score) {
    return '$score. Trước $opponent. Tôi không còn lời nào, mà tôi được trả tiền để có lời.';
  }

  @override
  String yLostBadly5(String opponent, String score) {
    return '$opponent $score. Phải có người chịu trách nhiệm cho chuyện này.';
  }

  @override
  String yLostBadly6(String opponent, String score) {
    return 'Tôi muốn trận $score trước $opponent bị xóa khỏi kỷ lục và khỏi ký ức.';
  }

  @override
  String yLostBadly7(String opponent, String score) {
    return 'Thua $opponent $score. Không thể tô vẽ một tỷ số như vậy.';
  }

  @override
  String yLostBadly8(String opponent, String score) {
    return 'Đó không phải là thất bại trước $opponent, mà là đầu hàng. $score.';
  }

  @override
  String yLostBadly9(String opponent, String score) {
    return '$score. Trước $opponent. Người ta bỏ tiền ra để xem cái đó.';
  }

  @override
  String yLostBadly10(String opponent, String score) {
    return '$opponent $score. Nếu thế này mà không có gì thay đổi thì chẳng gì thay đổi được.';
  }

  @override
  String yLostBadly11(String opponent, String score) {
    return 'Tôi từng thấy đội này bị làm nhục, nhưng $score trước $opponent là đáy mới.';
  }

  @override
  String yTrophy0(String opponent) {
    return 'NHÀ VÔ ĐỊCH. $opponent. Hãy hét lên đi.';
  }

  @override
  String yTrophy1(String opponent) {
    return 'Chúng ta đã giành được. $opponent. Tôi không ổn nổi.';
  }

  @override
  String yTrophy2(String opponent) {
    return '$opponent, và chiếc cúp đang về nhà.';
  }

  @override
  String yTrophy3(String opponent) {
    return 'Từng người một đều là huyền thoại. $opponent.';
  }

  @override
  String yRunnerUp0(String opponent) {
    return 'Chỉ thiếu một chút. $opponent và tấm huy chương không ai muốn.';
  }

  @override
  String yRunnerUp1(String opponent) {
    return 'Á quân $opponent. Sẽ đau nhiều năm.';
  }

  @override
  String yRunnerUp2(String opponent) {
    return '$opponent: cách mọi thứ đúng một trận.';
  }

  @override
  String yRunnerUp3(String opponent) {
    return 'Hạng hai. Tại $opponent. Ai đó đưa chai rượu đây.';
  }

  @override
  String yEliminated0(String opponent) {
    return 'Bị loại ở $opponent. Chuyện này sẽ đau một thời gian.';
  }

  @override
  String yEliminated1(String opponent) {
    return '$opponent là nơi hành trình của chúng ta dừng lại.';
  }

  @override
  String yEliminated2(String opponent) {
    return 'Bị loại ở $opponent. Giờ là lúc điều tra.';
  }

  @override
  String yEliminated3(String opponent) {
    return 'Bị đánh bật ở $opponent. Ai đó giải thích cho tôi với.';
  }

  @override
  String yQualified0(String opponent) {
    return 'CHÚNG TA SẼ ĐẾN $opponent.';
  }

  @override
  String yQualified1(String opponent) {
    return 'Đã giành vé dự $opponent. Xin nghỉ làm đi thôi.';
  }

  @override
  String yQualified2(String opponent) {
    return '$opponent, chúng tôi đến đây. Chưa bao giờ nghi ngờ (thực ra nghi ngờ đủ đường).';
  }

  @override
  String yQualified3(String opponent) {
    return 'Đã vào $opponent. Phần khó đã xong.';
  }

  @override
  String yGroupDrawn0(String opponent) {
    return 'Đã bốc thăm bảng cho $opponent. Có thể tệ hơn. Có thể tệ hơn nhiều.';
  }

  @override
  String yGroupDrawn1(String opponent) {
    return 'Vậy là lễ bốc thăm $opponent đã xong. Thú vị đây.';
  }

  @override
  String yGroupDrawn2(String opponent) {
    return 'Các bảng của $opponent đã có và tôi đã không ưa bảng của mình.';
  }

  @override
  String yGroupDrawn3(String opponent) {
    return 'Bốc thăm $opponent xong. Cuộc phản ứng thái quá bắt đầu.';
  }

  @override
  String yHostNamed0(String opponent) {
    return '$opponent sẽ đăng cai. Bắt đầu tiết kiệm đi.';
  }

  @override
  String yHostNamed1(String opponent) {
    return 'Giải sẽ về $opponent. Dễ đoán, nhưng được thôi.';
  }

  @override
  String yHostNamed2(String opponent) {
    return '$opponent được đăng cai giải. Chúc mừng họ, tôi đoán vậy.';
  }

  @override
  String yHostNamed3(String opponent) {
    return 'Chủ nhà đã được xác nhận: $opponent.';
  }

  @override
  String yTournamentSoon0(String opponent) {
    return '$opponent sắp bắt đầu và tôi không thể ngồi yên.';
  }

  @override
  String yTournamentSoon1(String opponent) {
    return 'Không còn lâu nữa là đến $opponent.';
  }

  @override
  String yTournamentSoon2(String opponent) {
    return '$opponent gần đến rồi. Công bố danh sách đội hình đi nào.';
  }

  @override
  String yTournamentSoon3(String opponent) {
    return 'Đếm ngược đến $opponent chính thức không chịu nổi nữa.';
  }

  @override
  String get navY => 'Y';

  @override
  String get yTitle => 'Y';

  @override
  String get yEmpty => 'Chưa có gì để nói. Hãy chơi một trận.';

  @override
  String get yEarlierHeading => 'Trước đó trong chu kỳ này';

  @override
  String get yTraitLoyalist =>
      'Ủng hộ đội dù chuyện gì xảy ra. Lâu quay lưng, nhanh tha thứ.';

  @override
  String get yTraitCynic =>
      'Luôn nghĩ điều tệ nhất và rất vui khi được chứng minh là đúng.';

  @override
  String get yTraitNostalgic =>
      'Ngày xưa cái gì cũng hay hơn. Đem bạn ra so với những người đã giải nghệ.';

  @override
  String get yTraitStatshead =>
      'Chỉ đăng con số, không gì khác. Gần như không có cảm xúc.';

  @override
  String get yTraitHypeman => 'Hai kết quả tốt là thành thế hệ vàng.';

  @override
  String get yTraitContrarian => 'Cả phòng nghĩ gì thì làm ngược lại.';

  @override
  String get yTraitDoomer => 'Rồi sẽ hỏng thôi. Lúc nào cũng sẽ hỏng.';

  @override
  String get yProfilePosts => 'BÀI ĐĂNG';

  @override
  String get yProfileEmpty => 'Tài khoản này chưa đăng gì.';

  @override
  String hubEventGrievance(String player) {
    return '$player muốn nói chuyện';
  }

  @override
  String get hubEventGrievanceSub => 'Anh ấy muốn biết vị trí của mình';

  @override
  String hubEventManagerSkills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count điểm kỹ năng để dùng',
      one: '1 điểm kỹ năng để dùng',
    );
    return '$_temp0';
  }

  @override
  String get hubEventManagerSkillsSub => 'Điểm mạnh của bạn làm đội mạnh hơn';

  @override
  String get grievanceTitle => 'Chuyện trong phòng làm việc';

  @override
  String grievanceGameTime(String player) {
    return '$player nằm trong danh sách đội hình mà chưa chạm bóng lần nào. Anh ấy muốn biết lý do.';
  }

  @override
  String grievanceSquadPlace(String player) {
    return '$player không có tên trong danh sách và không thể hiểu nổi. Anh ấy muốn được nói rõ, dù thế nào.';
  }

  @override
  String grievanceRole(String player) {
    return '$player liên tục bị xếp trái vị trí và đã chịu hết nổi.';
  }

  @override
  String get grievanceReassure => 'Anh nằm trong kế hoạch của tôi';

  @override
  String get grievanceHonest =>
      'Anh đang xếp sau những người khác, và đây là lý do';

  @override
  String get grievanceDismiss => 'Tôi là người chọn đội hình';

  @override
  String yScorerStar0(String name, String goals) {
    return '$name ghi $goals bàn trong số đó. Không ai khác đến gần.';
  }

  @override
  String yScorerStar1(String name, String goals) {
    return '$goals bàn của $name. Anh ấy gánh cả đội này.';
  }

  @override
  String yScorerStar2(String name, String goals) {
    return '$name: $goals bàn trong ngày. Một cầu thủ đáng nể.';
  }

  @override
  String yScorerStar3(String name, String goals) {
    return '$name đã đưa bóng vào lưới họ $goals lần. Cúi chào đi.';
  }

  @override
  String yScorerStar4(String name, String goals) {
    return '$goals bàn của $name, còn những người khác chỉ là hành khách.';
  }

  @override
  String yScorerStar5(String name, String goals) {
    return 'Lại là $name. $goals bàn. Thử tưởng tượng đội này không có anh ấy.';
  }

  @override
  String yScorerStar6(String name, String goals) {
    return '$goals bàn từ $name. Một người không nên phải gánh nhiều đến vậy.';
  }

  @override
  String yScorerStar7(String name, String goals) {
    return 'Bỏ $name ra khỏi trận đó thì ít hơn $goals bàn và là một buổi chiều rất khác.';
  }

  @override
  String yWinStreak0(String count) {
    return '$count trận liên tiếp. Trong phòng thay đồ đang nói gì thì nó đang ngấm.';
  }

  @override
  String yWinStreak1(String count) {
    return 'Vậy là $count trận liền. Chẳng đội nào vấp phải chuỗi như thế này.';
  }

  @override
  String yWinStreak2(String count) {
    return '$count trận liên tiếp và vẫn đang tiếp tục. Sự tự tin hiện rõ từ khán đài.';
  }

  @override
  String yWinStreak3(String count) {
    return 'Không thua trong $count trận. Hỏi bất kỳ ai từng cầm quân: đó mới là phần khó.';
  }

  @override
  String yWinStreak4(String count) {
    return '$count trận liên tiếp. Hãy tận hưởng khi lịch thi đấu còn dễ chịu.';
  }

  @override
  String yWinStreak5(String count) {
    return '$count trận liền, mà chúng ta chưa thắng ai đáng kể.';
  }

  @override
  String yWinStreak6(String count) {
    return 'Chuỗi $count trận. Khi nào bị thử thách thì hỏi lại tôi.';
  }

  @override
  String yWinStreak7(String count) {
    return '$count trận liên tục. Đội nào cũng có một lần như thế.';
  }

  @override
  String yLossStreak0(String count) {
    return 'Đã $count trận không thắng. Đến lúc nào đó, lời bào chữa cũng cạn.';
  }

  @override
  String yLossStreak1(String count) {
    return 'Vậy là $count trận liền mất trắng. Đây không còn là sự cố nhất thời.';
  }

  @override
  String yLossStreak2(String count) {
    return '$count trận thua liên tiếp. Phải có người chịu trách nhiệm.';
  }

  @override
  String yLossStreak3(String count) {
    return 'Không thắng trong $count trận. Nhìn cách họ chơi là thấy.';
  }

  @override
  String yLossStreak4(String count) {
    return '$count trận không thắng và tuần nào cũng những sai lầm cũ.';
  }

  @override
  String yLossStreak5(String count) {
    return '$count trận liên tiếp. Thử cách gì thì cũng không hiệu quả.';
  }

  @override
  String yLossStreak6(String count) {
    return '$count trận liền. Đây là một xu hướng, không phải một cú sa sút.';
  }

  @override
  String yLossStreak7(String count) {
    return 'Không thắng trong $count trận, và trên kia không ai nói một lời.';
  }

  @override
  String yRivalry0(String opponent, String score) {
    return '$opponent $score. Muốn nói gì về lối chơi thì nói. Trận này tính gấp đôi.';
  }

  @override
  String yRivalry1(String opponent, String score) {
    return 'Lại là $opponent, trong tất cả mọi đội. $score. Ở đây không ai quên được.';
  }

  @override
  String yRivalry2(String opponent, String score) {
    return '$score trước $opponent. Đó là trận người ta sẽ bàn trong các quán rượu.';
  }

  @override
  String yRivalry3(String opponent, String score) {
    return 'Gặp láng giềng, $score. Quyền khoe khoang đã an bài một thời gian.';
  }

  @override
  String yRivalry4(String opponent, String score) {
    return '$opponent $score. Năm nay có chuyện gì xảy ra đi nữa thì vẫn có trận này.';
  }

  @override
  String yRivalry5(String opponent, String score) {
    return '$score trước $opponent. Có người trong chúng ta cần trận này hơn cả bảng xếp hạng.';
  }

  @override
  String yRivalry6(String opponent, String score) {
    return '$opponent $score. Và họ sẽ đòi lại lần sau, lần nào cũng vậy.';
  }

  @override
  String yRivalry7(String opponent, String score) {
    return 'Trước $opponent, $score. Cả một năm bị nhắc về trận này.';
  }

  @override
  String yInjuryBlow0(String name) {
    return '$name rời sân vì chấn thương. Đây là điều cuối cùng đội này cần.';
  }

  @override
  String yInjuryBlow1(String name) {
    return 'Mất $name làm thay đổi hình hài của mọi thứ.';
  }

  @override
  String yInjuryBlow2(String name) {
    return '$name đi khập khiễng. Nín thở đi.';
  }

  @override
  String yInjuryBlow3(String name) {
    return 'Vậy là một thời gian không có $name. Ai đó phải đứng ra gánh vác.';
  }

  @override
  String yInjuryBlow4(String name) {
    return '$name nghỉ rồi. Tất nhiên lại là $name.';
  }

  @override
  String yInjuryBlow5(String name) {
    return 'Không có $name thì đây là một đội rất bình thường.';
  }

  @override
  String yInjuryBlow6(String name) {
    return '$name lại chấn thương. Ai đó nên hỏi vì sao.';
  }

  @override
  String yInjuryBlow7(String name) {
    return 'Mất $name, mà phía sau không có ai. Đó mới là vấn đề thật sự.';
  }

  @override
  String ySentOff0(String name, String minute) {
    return 'Thẻ đỏ cho $name ở phút $minute và cả đất nước quay lưng với anh ấy. Anh ấy đã cho chúng ta nhiều hơn hầu hết. Bỏ qua đi.';
  }

  @override
  String ySentOff1(String name, String minute) {
    return '$name bị đuổi ở phút $minute. Khắc nghiệt. Mười người mà vẫn dám chơi, điều đó nói lên nhiều điều.';
  }

  @override
  String ySentOff2(String name, String minute) {
    return '$name, phút $minute, thẻ đỏ. Từ đó còn mười người.';
  }

  @override
  String ySentOff3(String name, String minute) {
    return 'Đuổi khỏi sân: $name ở phút $minute. Không phải trận đầu tiên xoay chiều vì một quyết định.';
  }

  @override
  String ySentOff4(String name, String minute) {
    return 'Tuyệt vời. $name bị đuổi ở phút $minute và chúng ta còn mười người. Lại nữa.';
  }

  @override
  String ySentOff5(String name, String minute) {
    return '$name bị đuổi sau $minute phút. Rốt cuộc ai đang dạy kỷ luật ở đây vậy?';
  }

  @override
  String ySentOff6(String name, String minute) {
    return '$minute phút. Đó là khoảng thời gian $name giữ được cái đầu lạnh. Bóng đá chuyên nghiệp đấy.';
  }

  @override
  String ySentOff7(String name, String minute) {
    return 'Thẻ đỏ cho $name ở phút $minute, mà tôi phải tin đây là tiến bộ.';
  }

  @override
  String get yBoardPressure0 =>
      'Ban lãnh đạo bỗng im lặng hẳn. Đó chưa bao giờ là dấu hiệu tốt.';

  @override
  String get yBoardPressure1 =>
      'Nghe nói phòng họp ban lãnh đạo đã bắt đầu đặt câu hỏi.';

  @override
  String get yBoardPressure2 =>
      'Có thể cảm nhận mặt đất đang dịch chuyển trên kia.';

  @override
  String get yBoardPressure3 =>
      'Không ai ở liên đoàn nói lời ủng hộ nào. Tự rút ra kết luận đi.';

  @override
  String get yBoardPressure4 =>
      'Đã mấy tuần nay không ai trên kia công khai bênh vực HLV.';

  @override
  String get yBoardPressure5 =>
      'Liên đoàn đang bóng gió chống lại chính huấn luyện viên của mình. Như mọi khi.';

  @override
  String get yBoardPressure6 =>
      'Khi một ban lãnh đạo im lặng, họ đã quyết định xong rồi.';

  @override
  String get yBoardPressure7 =>
      'Họ sẽ để chuyện này trôi cho đến khi quyết định thuộc về người khác.';

  @override
  String get yReplies => 'CŨNG VỀ TRẬN NÀY';

  @override
  String get yPlayerGrievance0 =>
      'Đã hỏi vị trí của mình ở đâu. Vẫn đang chờ câu trả lời.';

  @override
  String get yPlayerGrievance1 =>
      'Tập luyện chăm chỉ. Tôi cũng chẳng làm được gì hơn.';

  @override
  String get yPlayerGrievance2 => 'Có những câu hỏi chỉ được hỏi một lần.';

  @override
  String get yPlayerGrievance3 => 'Tôi không đi xa đến thế này để xách áo tập.';

  @override
  String get playerHonoursTitle => 'DANH HIỆU';

  @override
  String get awardGoldenBall => 'Quả bóng vàng';

  @override
  String get awardGoldenBoot => 'Chiếc giày vàng';

  @override
  String get awardGoldenGlove => 'Găng tay vàng';

  @override
  String get awardTeamOfTournament => 'Đội hình tiêu biểu';

  @override
  String get awardPlayerOfYear => 'Cầu thủ thế giới của năm';

  @override
  String get awardYoungPlayerOfYear => 'Cầu thủ trẻ của năm';

  @override
  String get playerClubHistory => 'LỊCH SỬ CÂU LẠC BỘ';

  @override
  String get playerCareerRecord => 'THÀNH TÍCH SỰ NGHIỆP';

  @override
  String get playerInternationalGoals => 'Bàn thắng cho đội tuyển';

  @override
  String get playerRecentForm => 'PHONG ĐỘ GẦN ĐÂY';

  @override
  String get playerMatchHistory => 'LỊCH SỬ TRẬN ĐẤU';

  @override
  String get playerAttributes => 'THUỘC TÍNH';

  @override
  String get playerUnknown => 'Không rõ';

  @override
  String get playerAttrPace => 'Tốc độ';

  @override
  String get playerAttrPhysical => 'Thể lực';

  @override
  String get playerAttrTechnical => 'Kỹ thuật';

  @override
  String get playerAttrShooting => 'Dứt điểm';

  @override
  String get playerAttrPassing => 'Chuyền bóng';

  @override
  String get playerAttrDribbling => 'Rê bóng';

  @override
  String get playerAttrTackling => 'Tắc bóng';

  @override
  String get playerAttrPositioning => 'Chọn vị trí';

  @override
  String get playerAttrComposure => 'Bình tĩnh';

  @override
  String get playerAttrDecisions => 'Phán đoán';

  @override
  String get playerAttrStamina => 'Sức bền';

  @override
  String get playerAttrStrength => 'Sức mạnh';

  @override
  String get playerStatCaps => 'Số trận ĐT';

  @override
  String get playerStatGoals => 'Bàn thắng';

  @override
  String get playerStatAssists => 'Kiến tạo';

  @override
  String get playerStatAvgRating => 'Điểm TB';

  @override
  String get playerStatForm => 'Phong độ';

  @override
  String get playerStatMotm => 'Cầu thủ hay nhất trận';

  @override
  String get playerStatCleanSheets => 'Giữ sạch lưới';

  @override
  String get playerStatBestGame => 'Trận hay nhất';

  @override
  String get playerStatCards => 'Thẻ phạt';

  @override
  String playerCardsValue(int yellows, int reds) {
    return '${yellows}V $redsĐ';
  }

  @override
  String get tourSharedYourRun => 'HÀNH TRÌNH CỦA BẠN';

  @override
  String get tourSharedList => 'Danh sách';

  @override
  String get tourSharedBracket => 'Nhánh đấu';

  @override
  String get tourSharedVs => 'vs';

  @override
  String tourSharedGroupSeed(String seed) {
    return 'Bảng $seed';
  }

  @override
  String get tourSharedThisEdition => 'Kỳ này';

  @override
  String get tourSharedAllTime => 'Mọi thời đại';

  @override
  String get tourSharedUnknown => 'Không rõ';

  @override
  String get tourSharedActive => 'ĐANG THI ĐẤU';

  @override
  String get tourSharedMedalTable => 'BẢNG HUY CHƯƠNG';

  @override
  String get tourSharedPastWinners => 'CÁC NHÀ VÔ ĐỊCH TRƯỚC';

  @override
  String tourSharedHost(String host) {
    return 'Chủ nhà: $host';
  }

  @override
  String get tourSharedBeat => 'thắng';

  @override
  String get tourSharedPens => ' (luân lưu)';

  @override
  String get tourSharedAwardsEmpty =>
      'Các giải thưởng sẽ được trao khi giải đấu kết thúc.';

  @override
  String get tourSharedGoldenBall => 'QUẢ BÓNG VÀNG';

  @override
  String get tourSharedPlayerOfTournament => 'Cầu thủ xuất sắc nhất giải';

  @override
  String get tourSharedGoldenBoot => 'CHIẾC GIÀY VÀNG';

  @override
  String tourSharedGoalsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bàn',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedGoldenGlove => 'GĂNG TAY VÀNG';

  @override
  String get tourSharedTeamOfTournament => 'ĐỘI HÌNH TIÊU BIỂU CỦA GIẢI';

  @override
  String get tourSharedStatsEmpty =>
      'Kỷ lục sẽ xuất hiện khi giải đấu có lịch sử.';

  @override
  String get tourSharedRecordScorer => 'KỶ LỤC GHI BÀN';

  @override
  String get tourSharedStillActive => 'vẫn đang thi đấu';

  @override
  String get tourSharedMostTitles => 'NHIỀU DANH HIỆU NHẤT';

  @override
  String tourSharedTitlesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count chức vô địch',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostFinals => 'NHIỀU TRẬN CHUNG KẾT NHẤT';

  @override
  String tourSharedFinalsContested(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count trận chung kết',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostGamesPlayed => 'RA SÂN NHIỀU NHẤT';

  @override
  String tourSharedMatchesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count trận',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostFinalsPlayed => 'DỰ NHIỀU VÒNG CHUNG KẾT NHẤT';

  @override
  String tourSharedFinalsTournamentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vòng chung kết',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedBiggestFinalWin => 'CHIẾN THẮNG CHUNG KẾT LỚN NHẤT';

  @override
  String tourStatsGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bàn',
      one: '1 bàn',
    );
    return '$_temp0';
  }

  @override
  String get tourStatsStillActive => 'vẫn đang thi đấu';

  @override
  String tourStatsTitles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count chức vô địch',
      one: '1 chức vô địch',
    );
    return '$_temp0';
  }

  @override
  String tourStatsFinalsContested(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count trận chung kết',
      one: '1 trận chung kết',
    );
    return '$_temp0';
  }

  @override
  String tourStatsMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count trận',
      one: '1 trận',
    );
    return '$_temp0';
  }

  @override
  String tourStatsFinalsTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vòng chung kết',
      one: '1 vòng chung kết',
    );
    return '$_temp0';
  }

  @override
  String get tourStatsLeaders => 'DẪN ĐẦU MỌI THỜI ĐẠI';

  @override
  String get tourStatsTabGames => 'Trận';

  @override
  String get tourStatsTabCups => 'Giải';

  @override
  String get tourStatsTabScorers => 'Ghi bàn';

  @override
  String tourSharedFinalWinDetail(String opponent, int year) {
    return 'gặp $opponent · $year';
  }

  @override
  String get tourHolders => 'NHÀ VÔ ĐỊCH';

  @override
  String tourHoldersSince(int year) {
    return 'vô địch năm $year';
  }

  @override
  String get tourSharedAllTimeScorers => 'VUA PHÁ LƯỚI MỌI THỜI ĐẠI';

  @override
  String get tourSharedSummaryEmpty =>
      'Chủ nhà và các sân vận động sẽ xuất hiện sau khi kỳ giải này được bốc thăm.';

  @override
  String get tourSharedHostHeading => 'CHỦ NHÀ';

  @override
  String get tourSharedHostsHeading => 'CHỦ NHÀ';

  @override
  String get tourSharedCoHostsHeading => 'ĐỒNG CHỦ NHÀ';

  @override
  String get tourSharedVenues => 'SÂN VẬN ĐỘNG';

  @override
  String get tourSharedMascot => 'LINH VẬT';

  @override
  String get tourSharedMatchBall => 'BÓNG THI ĐẤU';

  @override
  String tourSharedVenueSeats(String city, String capacity) {
    return '$city · $capacity chỗ ngồi';
  }

  @override
  String get tourSharedCouldNotLoad => 'Không thể tải.';

  @override
  String get tourSharedHostTbc => 'CHỦ NHÀ CHƯA XÁC NHẬN';

  @override
  String get tourSharedFinalsAreHere => 'VÒNG CHUNG KẾT ĐÃ ĐẾN';

  @override
  String tourSharedHostedBy(String hosts) {
    return 'ĐĂNG CAI BỞI  $hosts';
  }

  @override
  String get tourSharedLetFinalsBegin => 'Bắt đầu vòng chung kết';

  @override
  String get tourSharedCompetitions => 'CÁC GIẢI ĐẤU';

  @override
  String get tourSharedWorldRanking => 'Bảng xếp hạng thế giới';

  @override
  String get tourSharedCouldNotLoadTournaments => 'Không thể tải các giải đấu.';

  @override
  String get tourSharedPrestigeStage => 'SÂN KHẤU DANH GIÁ';

  @override
  String get tourSharedOverview => 'Tổng quan';

  @override
  String get tourSharedWorldRankingTitle => 'Xếp hạng thế giới';

  @override
  String get tourSharedYourCompetitions => 'GIẢI ĐẤU CỦA BẠN';

  @override
  String get tourSharedOtherContinents => 'CÁC CHÂU LỤC KHÁC';

  @override
  String get tourSharedComingSoon => 'Giải đấu sắp ra mắt';

  @override
  String get tourSharedSoon => 'SẮP TỚI';

  @override
  String get tourSharedNoQualifyingDraw => 'Không có lễ bốc thăm vòng loại.';

  @override
  String get tourSharedOpenEnvelope => 'Mở phong bì';

  @override
  String tourSharedGroupName(String name) {
    return 'BẢNG $name';
  }

  @override
  String get tourSharedBall => 'Bóng';

  @override
  String get tourSharedPot => 'Nhóm';

  @override
  String get tourSharedAll => 'Tất cả';

  @override
  String get tourSharedTapDrawTeam => 'Chạm để bốc đội tiếp theo';

  @override
  String get tourSharedTapDrawPot => 'Chạm để bốc nhóm tiếp theo';

  @override
  String get tourSharedTapDrawAll => 'Chạm để xem toàn bộ lễ bốc thăm';

  @override
  String get tourSharedContinue => 'Tiếp tục';

  @override
  String get tourSharedPause => 'Tạm dừng';

  @override
  String get tourSharedPlay => 'Phát';

  @override
  String get tourSharedSkip => 'Bỏ qua';

  @override
  String tourSharedPotNumber(int number) {
    return 'NHÓM $number';
  }

  @override
  String get tourSharedDrawComplete => 'BỐC THĂM XONG';

  @override
  String get tourSharedDrawing => 'ĐANG BỐC THĂM…';

  @override
  String get tourContChampionship => 'GIẢI VÔ ĐỊCH';

  @override
  String get tourContTabSummary => 'TỔNG QUAN';

  @override
  String get tourContTabQualifying => 'VÒNG LOẠI';

  @override
  String get tourContTabFinals => 'CHUNG KẾT';

  @override
  String get tourContTabBracket => 'NHÁNH ĐẤU';

  @override
  String get tourContTabAwards => 'GIẢI THƯỞNG';

  @override
  String get tourContTabScorers => 'GHI BÀN';

  @override
  String get tourContTabHistory => 'LỊCH SỬ';

  @override
  String get tourContTabRecords => 'KỶ LỤC';

  @override
  String tourContCouldNotLoadCup(String error) {
    return 'Không thể tải giải đấu.\n$error';
  }

  @override
  String get tourContNoCupData => 'Không có dữ liệu giải đấu.';

  @override
  String get tourContUnknown => 'Không rõ';

  @override
  String get tourContGroupsToBeDrawnQual =>
      'Các bảng vòng loại được bốc thăm tại buổi lễ. Hãy xem từ trang chủ để biết bạn gặp ai.';

  @override
  String get tourContQualSeeded =>
      'Quốc gia của bạn được đặc cách vào thẳng vòng chung kết. Chu kỳ này không có vòng loại.';

  @override
  String tourContBackgroundRegion(String name) {
    return '$name được mô phỏng ngầm. Kết quả sẽ hiện ở đây sau mỗi vòng đấu.';
  }

  @override
  String get tourContGroupsToBeDrawnFinals =>
      'Các bảng vòng chung kết được bốc thăm tại buổi lễ. Hãy xem từ trang chủ để biết bảng của bạn.';

  @override
  String get tourContFinalsDrawAfterQual =>
      'Lễ bốc thăm vòng chung kết diễn ra sau khi vòng loại kết thúc.';

  @override
  String get tourContContestedBeforeWc =>
      'Các vòng đấu loại trực tiếp được thi đấu trước Giải vô địch thế giới.';

  @override
  String tourContChampionsHeading(String name) {
    return 'NHÀ VÔ ĐỊCH $name';
  }

  @override
  String tourContWinnersTitle(String name) {
    return 'Các nhà vô địch $name';
  }

  @override
  String get tourContNoGoalsYet => 'Chưa có bàn thắng nào.';

  @override
  String tourContGroupHeading(String name) {
    return 'BẢNG $name';
  }

  @override
  String get tourContBestRunnersUp => 'CÁC ĐỘI NHÌ BẢNG TỐT NHẤT';

  @override
  String tourContGroupDropdown(String name) {
    return 'Bảng $name';
  }

  @override
  String get tourContMatches => 'CÁC TRẬN ĐẤU';

  @override
  String get tourContNoGroupsDrawn => 'Chưa bốc thăm chia bảng.';

  @override
  String get tourContQualifyingDraw => 'BỐC THĂM VÒNG LOẠI';

  @override
  String get tourContWorldQualifyingDraw => 'BỐC THĂM VÒNG LOẠI THẾ GIỚI';

  @override
  String get tourContFinalsDraw => 'BỐC THĂM VÒNG CHUNG KẾT';

  @override
  String get tourContSeedingPots => 'CÁC NHÓM HẠT GIỐNG';

  @override
  String get tourContGroupDraw => 'BỐC THĂM CHIA BẢNG';

  @override
  String tourContCouldNotLoadDraw(String error) {
    return 'Không thể tải lễ bốc thăm.\n$error';
  }

  @override
  String get tourContDrawNotReady => 'Lễ bốc thăm chưa sẵn sàng.';

  @override
  String get tourContContinentalClash => 'CONTINENTAL CLASH';

  @override
  String get tourContTabThisCycle => 'CHU KỲ NÀY';

  @override
  String tourContCouldNotLoadClash(String error) {
    return 'Không thể tải.\n$error';
  }

  @override
  String get tourContNoSaveFound => 'Không tìm thấy bản lưu.';

  @override
  String get tourContClashSoon =>
      'Continental Clash được tổ chức khi đã biết cả hai nhà vô địch châu lục.';

  @override
  String get tourContTwoContinentsOneMatch => 'HAI CHÂU LỤC, MỘT TRẬN ĐẤU';

  @override
  String get tourContVersusShort => 'vs';

  @override
  String tourContWinTheClash(String name) {
    return '$name thắng Clash';
  }

  @override
  String get tourContNoClashYet => 'Chưa có trận Continental Clash nào.';

  @override
  String get tourContNationsCup => 'NATIONS CUP';

  @override
  String get tourContTabLeagues => 'CÁC HẠNG';

  @override
  String get tourContTabFinalsFour => 'FINAL FOUR';

  @override
  String tourContCouldNotLoad(String error) {
    return 'Không tải được.\n$error';
  }

  @override
  String get tourContNoNationsCupGoals =>
      'Chưa ghi nhận bàn thắng nào ở Nations Cup.';

  @override
  String get tourContNoNationsCupChampions =>
      'Chưa có nhà vô địch Nations Cup nào.';

  @override
  String get tourContNationsCupOffSeason =>
      'Nations Cup của chu kỳ này bắt đầu sau vòng chung kết châu lục. Các nhà vô địch trước đây nằm ở mục Lịch sử.';

  @override
  String get tourContNationsCupGroupsSoon =>
      'Các bảng đấu Nations Cup của chu kỳ này được bốc thăm tại buổi lễ. Hãy xem từ trang chủ để biết bạn gặp ai.';

  @override
  String get tourContLeagueNoGroups => 'Hạng này không có trận nào ở vòng này.';

  @override
  String tourContLeagueHeading(String letter) {
    return 'HẠNG $letter';
  }

  @override
  String tourContLeagueHeadingYours(String letter) {
    return 'HẠNG $letter · HẠNG CỦA BẠN';
  }

  @override
  String get tourContFinalsFourSoon =>
      'Final Four do các đội nhất bảng Hạng A tranh tài sau khi vòng bảng kết thúc.';

  @override
  String tourContLeagueChip(String letter) {
    return 'Hạng $letter';
  }

  @override
  String tourContLeagueChipStar(String letter) {
    return 'Hạng $letter ★';
  }

  @override
  String get tourContSemiFinals => 'BÁN KẾT';

  @override
  String get tourContFinal => 'CHUNG KẾT';

  @override
  String get tourContNationsCupDraw => 'BỐC THĂM NATIONS CUP';

  @override
  String get tourContIntercontinentalPlayoff => 'PLAY-OFF LIÊN LỤC ĐỊA';

  @override
  String get tourContNoPlayoffThisCycle => 'Chu kỳ này không có play-off.';

  @override
  String get tourContPlayoffIntro =>
      'Hai suất dự giải vô địch thế giới được định đoạt qua vòng đấu loại trực tiếp giữa các đội đứng nhì vòng loại xuất sắc nhất.';

  @override
  String get tourContPlayoffThrough =>
      'Bạn đã vượt qua play-off. Bạn được dự giải vô địch thế giới!';

  @override
  String get tourContPlayoffOut =>
      'Bạn đã thất bại ở play-off. Lần này không có giải vô địch thế giới.';

  @override
  String get tourContContinue => 'Tiếp tục';

  @override
  String get tourContPlayoffFinals => 'CHUNG KẾT PLAY-OFF';

  @override
  String get tourContPlayoffSeeded => 'Hạt giống (miễn vòng)';

  @override
  String get tourCupTabSummary => 'TỔNG QUAN';

  @override
  String get tourCupTabQualifying => 'VÒNG LOẠI';

  @override
  String get tourCupTabPlayoff => 'PLAY-OFF';

  @override
  String get tourCupPlayoffSoon =>
      'Play-off liên lục địa sẽ được xác định khi vòng loại của mọi liên đoàn châu lục kết thúc.';

  @override
  String get tourCupTabFinals => 'CHUNG KẾT';

  @override
  String get tourCupTabBracket => 'NHÁNH ĐẤU';

  @override
  String get tourCupTabAwards => 'GIẢI THƯỞNG';

  @override
  String get tourCupTabScorers => 'VUA PHÁ LƯỚI';

  @override
  String get tourCupTabHistory => 'LỊCH SỬ';

  @override
  String get tourCupTabRecords => 'KỶ LỤC';

  @override
  String get tourCupTitle => 'GIẢI VÔ ĐỊCH THẾ GIỚI';

  @override
  String get tourCupNoData => 'Không có dữ liệu giải đấu.';

  @override
  String tourCupLoadError(String error) {
    return 'Không tải được giải đấu.\n$error';
  }

  @override
  String get tourCupUnknown => 'Không rõ';

  @override
  String get tourCupWorldChampions => 'NHÀ VÔ ĐỊCH THẾ GIỚI';

  @override
  String get tourCupWorldChampionsTitle => 'Nhà vô địch thế giới';

  @override
  String get tourCupStillActive => 'Vẫn đang thi đấu';

  @override
  String get tourCupAllTimeScorers => 'VUA PHÁ LƯỚI MỌI THỜI ĐẠI';

  @override
  String get tourCupAllConfederations => 'Mọi liên đoàn châu lục';

  @override
  String get tourCupBestRunnersUp => 'Các đội nhì xuất sắc nhất';

  @override
  String get tourCupCompWorld => 'Giải vô địch thế giới';

  @override
  String get tourCupCompEurope => 'Giải vô địch châu Âu';

  @override
  String get tourCupCompSAmerica => 'Cúp Nam Mỹ';

  @override
  String get tourCupDestRoundOf16 => 'vòng 1/8';

  @override
  String get tourCupDestKnockouts => 'vòng đấu loại trực tiếp';

  @override
  String get tourCupDestFinals => 'vòng chung kết';

  @override
  String get tourCupDestFinalsPlayoff => 'play-off vòng chung kết';

  @override
  String get tourCupDestIntercontPlayoff => 'play-off liên lục địa';

  @override
  String get tourCupFinalsDrawnAfterQual =>
      'Vòng chung kết được bốc thăm khi vòng loại kết thúc.';

  @override
  String get tourCupFinalsDrawSoon =>
      'Các bảng đấu sắp được bốc thăm. Hãy xem lễ bốc thăm giải vô địch thế giới từ trang chủ để biết kết quả.';

  @override
  String tourCupGroupName(String name) {
    return 'Bảng $name';
  }

  @override
  String tourCupGroupNameShort(String name) {
    return 'Bảng $name';
  }

  @override
  String tourCupHostLabel(String host) {
    return 'Chủ nhà: $host';
  }

  @override
  String tourCupHostLabelMulti(String hosts) {
    return 'Chủ nhà: $hosts';
  }

  @override
  String get tourCupIntercontPlayoff => 'Play-off liên lục địa';

  @override
  String get tourCupKnockoutSoon =>
      'Nhánh đấu loại trực tiếp bắt đầu khi vòng bảng kết thúc.';

  @override
  String get tourCupMatches => 'CÁC TRẬN ĐẤU';

  @override
  String get tourCupMedalTable => 'BẢNG HUY CHƯƠNG';

  @override
  String get tourCupMostTitles => 'NHIỀU DANH HIỆU NHẤT';

  @override
  String tourCupMostTitlesValue(String nation, int titles, int editions) {
    return '$nation: $titles danh hiệu sau $editions kỳ giải';
  }

  @override
  String get tourCupNoGoals => 'Chưa có bàn thắng nào.';

  @override
  String get tourCupNoGroups => 'Chưa bốc thăm bảng nào.';

  @override
  String get tourCupNoHistory => 'Chưa có lịch sử.';

  @override
  String get tourCupPastWinners => 'CÁC NHÀ VÔ ĐỊCH TRƯỚC ĐÂY';

  @override
  String get tourCupPlayoffIntro =>
      'Hai suất dự giải vô địch thế giới được định đoạt qua vòng đấu loại trực tiếp giữa các đội đứng nhì vòng loại xuất sắc nhất.';

  @override
  String get tourCupQualDrawSoon =>
      'Các bảng đấu sắp được bốc thăm. Hãy xem lễ bốc thăm vòng loại từ trang chủ để biết kết quả.';

  @override
  String tourCupRegionYours(String region) {
    return '$region · của bạn';
  }

  @override
  String tourCupScorePens(int home, int away) {
    return '$home–$away (luân lưu)';
  }

  @override
  String get tourCupSegAllTime => 'Mọi thời đại';

  @override
  String get tourCupSegFinals => 'Chung kết';

  @override
  String get tourCupSegQualifying => 'Vòng loại';

  @override
  String get playerTraitsTitle => 'NỔI TIẾNG VỀ';

  @override
  String get traitBigGame => 'Bản lĩnh trận lớn';

  @override
  String get traitBigGameBlurb => 'Thăng hoa ở các trận đấu loại trực tiếp.';

  @override
  String get traitSetPiece => 'Chuyên gia tình huống cố định';

  @override
  String get traitSetPieceBlurb =>
      'Các pha tạt, đá phạt chuẩn hơn và ghi nhiều bàn hơn từ bóng chết.';

  @override
  String get traitHothead => 'Nóng tính';

  @override
  String get traitHotheadBlurb => 'Nhận nhiều thẻ phạt hơn hẳn đồng đội.';

  @override
  String get traitIronMan => 'Người sắt';

  @override
  String get traitIronManBlurb => 'Hiếm khi chấn thương và xuống sức chậm hơn.';

  @override
  String get traitWonderkid => 'Thần đồng';

  @override
  String get traitWonderkidBlurb => 'Trẻ, đã giỏi và vẫn tiến bộ nhanh.';

  @override
  String get traitLeader => 'Thủ lĩnh';

  @override
  String get traitLeaderBlurb => 'Truyền cảm hứng cho mọi đồng đội trên sân.';

  @override
  String get traitPacey => 'Tốc độ';

  @override
  String get traitPaceyBlurb =>
      'Tốc độ chóng mặt, luôn là mối đe dọa sau lưng hàng thủ.';

  @override
  String get traitOldHead => 'Lão tướng';

  @override
  String get traitOldHeadBlurb =>
      'Cầu thủ kỳ cựu có khả năng đọc trận đấu bền hơn đôi chân.';

  @override
  String get traitWasteful => 'Phung phí';

  @override
  String get traitWastefulBlurb => 'Đá ra ngoài quá nhiều cơ hội ngon ăn.';

  @override
  String get objectiveWorldCup => 'Giải vô địch thế giới';

  @override
  String get objectiveWinTournament => 'Vô địch';

  @override
  String get objectiveQualifyGeneric => 'Giành quyền dự giải';

  @override
  String hubBoardObjectiveFor(String competition, String label) {
    return '$competition: $label';
  }

  @override
  String get objectiveWinWorldCup => 'Vô địch giải vô địch thế giới';

  @override
  String get objectiveReachFinal => 'Vào chung kết';

  @override
  String get objectiveReachSemis => 'Vào bán kết';

  @override
  String get objectiveReachQuarters => 'Vào tứ kết';

  @override
  String get objectiveReachKnockouts => 'Vào vòng đấu loại trực tiếp';

  @override
  String get objectiveQualify => 'Giành quyền dự giải vô địch thế giới';

  @override
  String get finishChampions => 'Nhà vô địch';

  @override
  String get finishRunnersUp => 'Á quân';

  @override
  String get finishSemiFinals => 'Bán kết';

  @override
  String get finishQuarterFinals => 'Tứ kết';

  @override
  String get finishRoundOf16 => 'Vòng 1/8';

  @override
  String get finishGroupStage => 'Vòng bảng';

  @override
  String get objectiveQualifyingTopHalf => 'Về trong nửa trên bảng vòng loại';

  @override
  String get finishQualifyingTopHalf => 'Nửa trên bảng vòng loại';

  @override
  String get finishQualifyingBottomHalf => 'Nửa dưới bảng vòng loại';

  @override
  String get objectiveNcWinIt => 'Vô địch Nations Cup';

  @override
  String get objectiveNcReachFinal => 'Vào chung kết Nations Cup';

  @override
  String get objectiveNcFinalsFour => 'Vào Final Four';

  @override
  String get objectiveNcWinGroup => 'Nhất bảng và thăng hạng';

  @override
  String get objectiveNcTopHalf => 'Về trong nửa trên bảng';

  @override
  String get objectiveNcSurvive => 'Tránh xuống hạng';

  @override
  String get finishNcChampions => 'Nhà vô địch Nations Cup';

  @override
  String get finishNcFinalsFour => 'Final Four';

  @override
  String get finishNcGroupWinners => 'Nhất bảng';

  @override
  String get finishNcTopHalf => 'Nửa trên bảng';

  @override
  String get finishNcStayedUp => 'Trụ hạng';

  @override
  String get finishNcBottom => 'Cuối bảng';

  @override
  String get careerNationsCupLabel => 'Nations Cup';

  @override
  String get squadDevPlayer => 'CẦU THỦ';

  @override
  String get squadDevAge => 'TUỔI';

  @override
  String get squadDevPosition => 'VT';

  @override
  String get squadDevChange => 'ĐIỂM';

  @override
  String get squadDevNew => 'MỚI';

  @override
  String get squadDevRetired => 'GIẢI NGHỆ';

  @override
  String get squadDevEmpty =>
      'Một năm ổn định. Đội hình không có thay đổi nào.';

  @override
  String get squadDevTierRegulars => 'LỰC LƯỢNG CHÍNH';

  @override
  String get squadDevTierFringe => 'DỰ BỊ';

  @override
  String get squadDevTierYouth => 'TRẺ';

  @override
  String get boardObjectivesTitle => 'Mục tiêu của ban lãnh đạo';

  @override
  String get boardObjectivesConfidence => 'Niềm tin của ban lãnh đạo';

  @override
  String boardObjectiveBeatenBy(String result, int rounds) {
    String _temp0 = intl.Intl.pluralLogic(
      rounds,
      locale: localeName,
      other: 'vượt yêu cầu $rounds vòng',
      one: 'vượt yêu cầu một vòng',
    );
    return '$result: $_temp0';
  }

  @override
  String boardObjectiveShortBy(String result, int rounds) {
    String _temp0 = intl.Intl.pluralLogic(
      rounds,
      locale: localeName,
      other: 'thiếu $rounds vòng',
      one: 'thiếu một vòng',
    );
    return '$result: $_temp0';
  }

  @override
  String get boardObjectivesPending => 'CHƯA ĐỊNH';

  @override
  String boardObjectiveSoFar(String result) {
    return 'HIỆN TẠI · $result';
  }

  @override
  String get boardObjectivesEmpty =>
      'Ban lãnh đạo chưa đặt mục tiêu cho chu kỳ này.';

  @override
  String get tourContBestWinners => 'CÁC ĐỘI NHẤT BẢNG XUẤT SẮC NHẤT';

  @override
  String get tourContBestThirds => 'CÁC ĐỘI HẠNG BA XUẤT SẮC NHẤT';

  @override
  String tourContBestPlaced(String position) {
    return 'CÁC ĐỘI HẠNG $position XUẤT SẮC NHẤT';
  }

  @override
  String squadDevPageOf(String page, String pages, String total) {
    return '$page/$pages · $total cầu thủ';
  }

  @override
  String get matchSoldOut => 'HẾT VÉ';

  @override
  String matchAttendanceOf(String attendance, String capacity) {
    return '$attendance/$capacity chỗ ngồi đã kín';
  }

  @override
  String get matchGroundTitle => 'SÂN ĐẤU';

  @override
  String get absenceInjured => 'Chấn thương';

  @override
  String get absenceSuspended => 'Bị treo giò';

  @override
  String absenceWeeks(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString tuần',
      one: '1 tuần',
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
      other: '$countString trận',
      one: '1 trận',
    );
    return '$_temp0';
  }

  @override
  String absenceBackFor(String opponent) {
    return 'Trở lại cho trận gặp $opponent';
  }

  @override
  String get penaltyOrderTitle => 'Loạt luân lưu';

  @override
  String get penaltyOrderBlurb =>
      'Chọn năm người sút, theo thứ tự. Chạm vào một ô để đổi.';

  @override
  String penaltyOrderPick(int number) {
    return 'Lượt sút $number';
  }

  @override
  String get penaltyOrderPickBlurb =>
      'Chọn người bước ra sút. Thanh chỉ số là bản lĩnh của họ trên chấm phạt đền.';

  @override
  String get penaltyOrderConfirm => 'Bắt đầu sút';

  @override
  String get penaltyOrderCancel => 'Quay lại';

  @override
  String get youthTitle => 'Trẻ';

  @override
  String get youthEmptyLevel => 'Cấp độ này chưa có ai.';

  @override
  String get youthReleased => 'Bị thanh lý năm nay';

  @override
  String get u21Title => 'U-21';

  @override
  String get u21Blurb =>
      'Thế hệ kế cận, tài năng nhất xếp trước. Sao rỗng là ước tính của tuyển trạch viên. Hãy cho cầu thủ khoác áo đội tuyển để biết anh ấy thực sự có gì.';

  @override
  String get u21Empty =>
      'Hiện không có ai dưới 21 tuổi trong nguồn cầu thủ. Lứa mới sẽ đến cùng chu kỳ mới.';

  @override
  String u21Breakout(int gain) {
    return '+$gain NĂM NAY';
  }

  @override
  String u21AgeCaps(int age, int caps) {
    return 'Tuổi $age · $caps trận ĐT';
  }

  @override
  String u21AgeUncapped(int age) {
    return 'Tuổi $age · chưa khoác áo ĐT';
  }

  @override
  String get u21CallUps => 'Đến mục triệu tập';

  @override
  String get youthWatching => 'Theo dõi';

  @override
  String get youthWatchEmpty =>
      'Chưa đánh dấu ai. Hãy đánh dấu một cầu thủ trẻ ở bất kỳ cấp độ nào, cậu ấy sẽ xuất hiện ở đây cùng quá trình trưởng thành.';

  @override
  String get youthWatchMark => 'Theo dõi cầu thủ này';

  @override
  String get youthWatchUnmark => 'Ngừng theo dõi';

  @override
  String youthWatchMarked(int rating, int age) {
    return 'Đánh dấu khi $rating điểm, $age tuổi';
  }

  @override
  String get youthWatchSenior => 'Đã lên nguồn cầu thủ cấp cao';

  @override
  String get youthWatchReleased => 'Bị học viện thanh lý';

  @override
  String get youthWatchGone => 'Không còn trong hệ thống trẻ';

  @override
  String get tacticsYouth => 'U-21';

  @override
  String get pressSquad => 'Đội';

  @override
  String get pressBoard => 'Ban lãnh đạo';

  @override
  String get pressNoEffect => 'Chẳng ai để tâm nhiều';

  @override
  String get matchNeutralGround => 'TRUNG LẬP';

  @override
  String get matchExtraTimeAhead => 'HIỆP PHỤ';

  @override
  String get matchExtraTimeHalf => 'HIỆP PHỤ · NGHỈ GIỮA HIỆP';

  @override
  String get matchClockFullTime => 'HẾT GIỜ';

  @override
  String get matchClockAfterExtraTime => 'SAU HIỆP PHỤ';

  @override
  String get matchClockPenalties => 'LUÂN LƯU';

  @override
  String get matchClockFullTimePenalties => 'HẾT GIỜ · LUÂN LƯU';

  @override
  String get hubEventPressConference => 'Gặp báo chí';

  @override
  String get hubEventPressConferenceSub =>
      'Truyền thông thế giới muốn nói chuyện trước trận đầu tiên của bạn';

  @override
  String get squadDevWonderkid => 'THẦN ĐỒNG';

  @override
  String get tacticsPlaystyle => 'Lối chơi';

  @override
  String get tacticsPlaystyleBlurb =>
      'Chọn cách đội chơi; các thanh bên dưới tinh chỉnh thêm.';

  @override
  String get tacticsPlaystyleCustom =>
      'Thiết lập riêng của bạn. Không có lối chơi nào khớp với các thanh này.';

  @override
  String get playstyleCustom => 'Tùy chỉnh';

  @override
  String get playstyleBalanced => 'Cân bằng';

  @override
  String get playstylePossession => 'Kiểm soát bóng';

  @override
  String get playstyleGegenpress => 'Gegenpress';

  @override
  String get playstyleCounter => 'Phản công';

  @override
  String get playstyleDirect => 'Bóng bổng trực diện';

  @override
  String get playstyleLowBlock => 'Phòng ngự thấp';

  @override
  String get playstyleWingPlay => 'Đánh biên';

  @override
  String get playstyleBalancedBlurb =>
      'Chắc chắn ở cả hai nửa sân, không thái quá ở mặt nào.';

  @override
  String get playstylePossessionBlurb =>
      'Giữ bóng, luân chuyển kiên nhẫn, thu hẹp không gian.';

  @override
  String get playstyleGegenpressBlurb =>
      'Giành lại bóng ngay khi mất, ở sâu phần sân đối phương.';

  @override
  String get playstyleCounterBlurb =>
      'Lùi sâu, giữ đội hình chặt, rồi bứt tốc phản công.';

  @override
  String get playstyleDirectBlurb => 'Đẩy bóng lên sớm và tranh bóng hai.';

  @override
  String get playstyleLowBlockBlurb => 'Sâu, hẹp và rất khó bị xuyên phá.';

  @override
  String get playstyleWingPlayBlurb =>
      'Mở rộng sân, đi bóng bên ngoài rồi tạt.';

  @override
  String get nationsRandomTeam => 'Đội ngẫu nhiên';

  @override
  String get nationsFromTheBottom => 'Từ đáy';

  @override
  String get bottomStartTitle => 'Thất nghiệp';

  @override
  String get bottomStartHeading => 'Ba liên đoàn muốn gặp bạn';

  @override
  String get bottomStartBlurb =>
      'Bạn không có việc làm, cũng chẳng có danh tiếng. Đây là những đội duy nhất chịu đánh cược vào bạn. Hãy nhận một đội và xây dựng từ con số không.';

  @override
  String get bottomStartAccept => 'Nhận việc';

  @override
  String get bottomStartBack => 'Về menu';

  @override
  String bottomStartRankOf(int rank, int total) {
    return 'Hạng $rank/$total thế giới';
  }

  @override
  String get campTitle => 'Trại huấn luyện';

  @override
  String campBasedIn(String host) {
    return 'Đóng tại $host';
  }

  @override
  String get campBlurb =>
      'Nơi đội ở suốt giải đấu. Không thể đổi khi giải bắt đầu, và nó tác động đến ba điều ở mỗi trận: đội đến sân tươi tắn thế nào, chấn thương lành nhanh ra sao, và độ sắc nét của cầu thủ.';

  @override
  String get campEffectTravel => 'Đến sân tươi tắn';

  @override
  String get campEffectRecovery => 'Chấn thương mau lành';

  @override
  String get campEffectSharpness => 'Độ sắc nét thi đấu';

  @override
  String get campTerrainCity => 'Trung tâm thành phố';

  @override
  String get campTerrainCoastal => 'Khu nghỉ dưỡng ven biển';

  @override
  String get campTerrainMountain => 'Nơi nghỉ trên núi';

  @override
  String get campTerrainAltitude => 'Trại cao nguyên';

  @override
  String get campTerrainNationalCentre => 'Trung tâm quốc gia';

  @override
  String get campTerrainCityBlurb =>
      'Mọi thứ ngay trước cửa, không phải đi đâu xa, nhưng chẳng có sự yên tĩnh và không thoát được tiếng ồn.';

  @override
  String get campTerrainCoastalBlurb =>
      'Yên bình, thoải mái và tốt cho tinh thần; đổi lại là quãng đường xe dài đến mỗi sân.';

  @override
  String get campTerrainMountainBlurb =>
      'Không khí mát và hệ thống y tế hàng đầu giúp chấn thương nhanh lành, nhưng ở xa nơi diễn ra giải.';

  @override
  String get campTerrainAltitudeBlurb =>
      'Tập luyện vất vả, đổi lại đôi chân bền bỉ đến tận cuối giải.';

  @override
  String get campTerrainNationalCentreBlurb =>
      'Cơ sở của chính liên đoàn: không có gì nổi bật, nhưng cũng không có gì trục trặc.';

  @override
  String get hubEventChooseCamp => 'Chọn trại huấn luyện';

  @override
  String hubEventChooseCampSub(String host) {
    return 'Nơi đội sẽ đóng quân tại $host';
  }

  @override
  String get tacticsTabBench => 'Dự bị';

  @override
  String get squadSearchHint => 'Tìm theo tên hoặc câu lạc bộ';

  @override
  String get squadFilterAll => 'Tất cả';

  @override
  String get squadFilterInSquad => 'Trong đội hình';

  @override
  String get squadFilterUncapped => 'Chưa khoác áo ĐT';

  @override
  String get squadFilterUnavailable => 'Không sẵn sàng';

  @override
  String get squadLineAll => 'Mọi tuyến';

  @override
  String get squadSortBy => 'Sắp xếp';

  @override
  String get squadSortRating => 'Điểm';

  @override
  String get squadSortCaps => 'Trận ĐT';

  @override
  String get squadSortGoals => 'Bàn thắng';

  @override
  String get squadSortAge => 'Tuổi';

  @override
  String get squadSortName => 'Tên';

  @override
  String get squadLegendTitle => 'Ý nghĩa các ký hiệu';

  @override
  String get squadLegendStarting => 'Trong đội hình xuất phát';

  @override
  String get squadLegendCalledUp => 'Được triệu tập, ngồi dự bị';

  @override
  String get squadLegendRatingUp => 'Điểm đang tăng trong năm';

  @override
  String get squadLegendRatingDown => 'Điểm đang giảm trong năm';

  @override
  String get squadLegendInjured => 'Chấn thương, không sẵn sàng';

  @override
  String get squadLegendSuspended => 'Bị treo giò, không sẵn sàng';

  @override
  String get squadLegendTraits => 'NỔI TIẾNG VỀ';

  @override
  String squadShowingOf(int shown, int total) {
    return 'Hiển thị $shown/$total cầu thủ';
  }

  @override
  String get squadNobodyMatches => 'Không cầu thủ nào khớp bộ lọc.';

  @override
  String get squadStatPool => 'Nguồn';

  @override
  String get squadStatInSquad => 'Được triệu tập';

  @override
  String get squadMostCapped => 'Khoác áo nhiều nhất';

  @override
  String get squadTopScorer => 'Vua phá lưới';

  @override
  String squadCapsValue(String name, int caps) {
    return '$name · $caps trận ĐT';
  }

  @override
  String squadGoalsValue(String name, int goals) {
    return '$name · $goals bàn';
  }

  @override
  String squadAgeClub(int age, String club) {
    return '$age · $club';
  }

  @override
  String get squadCapsShort => 'Trận';

  @override
  String get squadGoalsShort => 'BT';

  @override
  String get recordsRecordBookSubtitle =>
      'Số trận, bàn thắng và các kỷ lục nổi bật của đội';

  @override
  String get statsLegacy => 'DI SẢN';

  @override
  String tacticsSubAlreadyOff(String name) {
    return '$name đã bị thay ra và không thể vào sân lại.';
  }

  @override
  String tacticsSubSentOff(String name) {
    return '$name đã bị đuổi khỏi sân và không thể tham gia thêm.';
  }

  @override
  String get tacticsInjuredShort => 'CHẤN THƯƠNG';

  @override
  String get tacticsSuspendedShort => 'TREO GIÒ';

  @override
  String get confEurope => 'Châu Âu';

  @override
  String get confSouthAmerica => 'Nam Mỹ';

  @override
  String get confNorthAmerica => 'Bắc Mỹ';

  @override
  String get confAfrica => 'Châu Phi';

  @override
  String get confAsia => 'Châu Á';

  @override
  String get confOceania => 'Châu Đại Dương';

  @override
  String get compWorldCup => 'Giải vô địch thế giới';

  @override
  String get compWorldCupFinals => 'Vòng chung kết giải vô địch thế giới';

  @override
  String get compWorldCupQualifying => 'Vòng loại giải vô địch thế giới';

  @override
  String compQualifiers(String region) {
    return 'Vòng loại $region';
  }

  @override
  String get compFriendlies => 'Giao hữu';

  @override
  String get compNationsCup => 'Nations Cup';

  @override
  String get compContinentalClash => 'Continental Clash';

  @override
  String get compIntercontinentalPlayoff => 'Play-off liên lục địa';

  @override
  String get compContinentalChampionship => 'Giải vô địch châu lục';

  @override
  String get compEuropeanChampionship => 'Giải vô địch châu Âu';

  @override
  String get compSouthAmericaCup => 'Cúp Nam Mỹ';

  @override
  String get compAfricanChampionship => 'Giải vô địch châu Phi';

  @override
  String get compAsianChampionship => 'Giải vô địch châu Á';

  @override
  String get compNorthAmericaCup => 'Cúp Bắc Mỹ';

  @override
  String get compOceaniaCup => 'Cúp châu Đại Dương';

  @override
  String get msgANation => 'Một quốc gia';

  @override
  String get msgAPlayer => 'Một cầu thủ';

  @override
  String get msgAHostNation => 'một nước chủ nhà';

  @override
  String get msgCycleTitle1 => 'Một chu kỳ mới bắt đầu';

  @override
  String msgCycleTitle2(int year) {
    return 'Con đường đến năm $year mở ra';
  }

  @override
  String get msgCycleTitle3 => 'Một chiến dịch mới ló dạng';

  @override
  String get msgCycleTitle4 => 'Trở lại làm việc';

  @override
  String msgCycleBody1(int year) {
    return 'Hành trình đến giải vô địch thế giới $year bắt đầu từ đây.';
  }

  @override
  String msgCycleBody2(int year) {
    return 'Một chu kỳ mới. Giải vô địch thế giới $year là mục tiêu.';
  }

  @override
  String msgCycleBody3(int year) {
    return 'Bốn năm nữa là giải vô địch thế giới $year. Công việc bắt đầu ngay bây giờ.';
  }

  @override
  String msgCycleBody4(int year) {
    return 'Chiến dịch $year bắt đầu từ hôm nay.';
  }

  @override
  String msgContHostTitle(String cup, String host) {
    return 'Chủ nhà $cup: $host';
  }

  @override
  String msgContHostBody(String host, String cup) {
    return '$host sẽ đăng cai $cup tiếp theo.';
  }

  @override
  String msgContQualDrawTitle(String cup) {
    return 'Bốc thăm vòng loại $cup';
  }

  @override
  String msgContQualDrawBody(String cup) {
    return 'Các bảng đấu vòng loại $cup đã được bốc thăm.';
  }

  @override
  String msgWcHostTitle(String host, int year) {
    return 'Chủ nhà giải vô địch thế giới $year: $host';
  }

  @override
  String msgWcHostBody(String host, int year) {
    return '$host sẽ đăng cai giải vô địch thế giới $year.';
  }

  @override
  String get msgWcQualDrawTitle => 'Bốc thăm vòng loại giải vô địch thế giới';

  @override
  String get msgWcQualDrawBody =>
      'Các bảng đấu vòng loại giải vô địch thế giới đã được bốc thăm.';

  @override
  String msgContFinalsDrawTitle(String cup) {
    return 'Bốc thăm vòng chung kết $cup';
  }

  @override
  String msgContFinalsDrawBody(String cup) {
    return 'Các bảng đấu vòng chung kết $cup đã được bốc thăm.';
  }

  @override
  String get msgWcFinalsDrawTitle =>
      'Bốc thăm vòng chung kết giải vô địch thế giới';

  @override
  String msgWcFinalsDrawBody(int year) {
    return 'Lễ bốc thăm vòng chung kết giải vô địch thế giới $year đã diễn ra.';
  }

  @override
  String get msgQualWcTitle1 => 'Đã vào giải vô địch thế giới';

  @override
  String get msgQualWcTitle2 => 'Chắc suất dự giải vô địch thế giới';

  @override
  String get msgQualWcTitle3 => 'Chúng ta đến giải vô địch thế giới';

  @override
  String get msgQualWcTitle4 => 'Tấm vé đã vào tay';

  @override
  String msgQualWcBody1(int year) {
    return 'Bạn đã giành quyền dự vòng chung kết giải vô địch thế giới $year.';
  }

  @override
  String msgQualWcBody2(int year) {
    return 'Chính thức rồi: đội tuyển của bạn sẽ dự giải vô địch thế giới $year.';
  }

  @override
  String msgQualWcBody3(int year) {
    return 'Suất dự giải vô địch thế giới $year đã nằm chắc trong tay.';
  }

  @override
  String msgQualWcBody4(int year) {
    return 'Bạn đã vào vòng chung kết giải vô địch thế giới $year.';
  }

  @override
  String msgQualContTitle1(String cup) {
    return 'Đã vào $cup';
  }

  @override
  String msgQualContTitle2(String cup) {
    return 'Chắc suất dự $cup';
  }

  @override
  String msgQualContTitle3(String cup) {
    return 'Giành quyền dự $cup';
  }

  @override
  String msgQualContBody1(String cup) {
    return 'Bạn đã giành quyền dự vòng chung kết $cup.';
  }

  @override
  String msgQualContBody2(String cup) {
    return 'Đội tuyển của bạn đã chắc suất dự $cup.';
  }

  @override
  String msgQualContBody3(String cup) {
    return 'Bạn đã vào $cup.';
  }

  @override
  String msgChampTitleMine1(String comp) {
    return 'NHÀ VÔ ĐỊCH $comp!';
  }

  @override
  String msgChampTitleMine2(String comp) {
    return 'Nhà vô địch $comp!';
  }

  @override
  String msgChampTitleMine3(String comp) {
    return 'Bạn đã vô địch $comp!';
  }

  @override
  String msgChampTitleOther1(String comp) {
    return '$comp đã có chủ';
  }

  @override
  String msgChampTitleOther2(String comp) {
    return 'Nhà vô địch $comp đã lộ diện';
  }

  @override
  String msgChampTitleOther3(String comp) {
    return '$comp đã tìm ra nhà vô địch';
  }

  @override
  String msgChampBodyMine1(String comp, String loser, String result, int year) {
    return 'Đội tuyển của bạn là nhà vô địch $comp $year, sau khi đánh bại $loser$result.';
  }

  @override
  String msgChampBodyMine2(String comp, String loser, String result, int year) {
    return 'Bạn đã vô địch $comp $year, hạ gục $loser$result.';
  }

  @override
  String msgChampBodyMine3(String comp, String loser, String result, int year) {
    return '$comp $year là của bạn. $loser bị đánh bại$result.';
  }

  @override
  String msgChampBodyOther1(
    String winner,
    String comp,
    String loser,
    String result,
    int year,
  ) {
    return '$winner vô địch $comp $year, sau khi đánh bại $loser$result.';
  }

  @override
  String msgChampBodyOther2(
    String winner,
    String comp,
    String loser,
    String result,
    int year,
  ) {
    return '$winner là nhà vô địch $comp $year, sau khi hạ $loser$result.';
  }

  @override
  String msgFinalScoreSuffix(int home, int away) {
    return ' $home–$away ở trận chung kết';
  }

  @override
  String msgFinalPensSuffix(int home, int away) {
    return ' trên chấm luân lưu, sau trận chung kết hòa $home–$away';
  }

  @override
  String get msgWpotyTitle => 'Cầu thủ thế giới của năm';

  @override
  String msgWpotyBodyMine(String name, String nation, int year) {
    return '$name ($nation) được vinh danh Cầu thủ thế giới của năm $year, một người của bạn.';
  }

  @override
  String msgWpotyBodyOther(String name, String nation, int year) {
    return '$name ($nation) được vinh danh Cầu thủ thế giới của năm $year.';
  }

  @override
  String get msgYpotTitle => 'Cầu thủ trẻ của giải đấu';

  @override
  String msgYpotBodyMine(String name, String nation, int age, int year) {
    return '$name ($nation), $age tuổi, được vinh danh Cầu thủ trẻ của giải đấu $year, một người của bạn.';
  }

  @override
  String msgYpotBodyOther(String name, String nation, int age, int year) {
    return '$name ($nation), $age tuổi, được vinh danh Cầu thủ trẻ của giải đấu $year.';
  }

  @override
  String msgRankHold1(int rank) {
    return 'Bạn giữ vững vị trí #$rank.';
  }

  @override
  String msgRankHold2(int rank) {
    return 'Không đổi, vẫn là #$rank.';
  }

  @override
  String msgRankHold3(int rank) {
    return 'Ổn định ở vị trí #$rank.';
  }

  @override
  String msgRankUp1(int move, int rank) {
    return 'Tổng cộng tăng $move bậc, lên #$rank.';
  }

  @override
  String msgRankUp2(int move, int rank) {
    return 'Việc leo $move bậc đưa bạn lên #$rank.';
  }

  @override
  String msgRankUp3(int move, int rank) {
    return 'Tăng $move bậc, nay là #$rank.';
  }

  @override
  String msgRankDown1(int move, int rank) {
    return 'Tổng cộng tụt $move bậc, xuống #$rank.';
  }

  @override
  String msgRankDown2(int move, int rank) {
    return 'Việc tụt $move bậc kéo bạn xuống #$rank.';
  }

  @override
  String msgRankDown3(int move, int rank) {
    return 'Tụt $move bậc, nay là #$rank.';
  }

  @override
  String get msgRankLeadYou => 'Bạn đứng đầu thế giới.';

  @override
  String msgRankLeadOther(String nation) {
    return 'Đứng đầu thế giới: $nation.';
  }

  @override
  String msgRankTitle(int rank) {
    return 'Bảng xếp hạng thế giới · #$rank';
  }

  @override
  String msgRankBody(String lead, String movement) {
    return 'Bảng xếp hạng thế giới đã được cập nhật. $lead $movement';
  }

  @override
  String msgRankJumpTitleUp(int rank) {
    return 'Leo lên #$rank';
  }

  @override
  String msgRankJumpTitleDown(int rank) {
    return 'Tụt xuống #$rank';
  }

  @override
  String msgRankJumpBodyUp(
    String tournament,
    String nation,
    int from,
    int to,
    int move,
  ) {
    return '$tournament đã làm xáo trộn bảng xếp hạng thế giới. $nation: từ #$from lên #$to, tăng $move bậc.';
  }

  @override
  String msgRankJumpBodyDown(
    String tournament,
    String nation,
    int from,
    int to,
    int move,
  ) {
    return '$tournament đã làm xáo trộn bảng xếp hạng thế giới. $nation: từ #$from xuống #$to, tụt $move bậc.';
  }

  @override
  String get rankingSinceWcDraw => 'Kể từ lễ bốc thăm giải vô địch thế giới';

  @override
  String get rankingSinceCycleStart => 'Kể từ khi chiến dịch bắt đầu';

  @override
  String rankingMovedFromTo(int from, int now) {
    return '#$from lên #$now';
  }

  @override
  String msgCapsTitle(String name, int count) {
    return '$name đạt $count trận ĐT';
  }

  @override
  String msgCapsBody(String name, int count) {
    return '$name hiện đã có $count lần khoác áo đội tuyển của bạn.';
  }

  @override
  String msgGoalsTitle(String name, int count) {
    return '$name đạt $count bàn thắng';
  }

  @override
  String msgGoalsBody(String name, int count) {
    return '$name đã ghi $count bàn thắng quốc tế cho đội tuyển của bạn.';
  }

  @override
  String msgDevTitle(int year) {
    return 'Phát triển đội hình · $year';
  }

  @override
  String msgThroughTitle(int year) {
    return 'Lên từ học viện · $year';
  }

  @override
  String get msgThroughNote =>
      'Đây không phải lứa mới. Họ là những cầu thủ vào học viện từ năm mười một tuổi và nay đã trưởng thành lên nguồn cầu thủ cấp cao.';

  @override
  String msgNewFacesTitle(int year) {
    return 'Gương mặt mới · $year';
  }

  @override
  String get msgIntakeNoteAcademy =>
      'Khoản đầu tư cho học viện đã có kết quả: lứa này đến với chất lượng cao hơn mức thông thường.';

  @override
  String get msgIntakeNoteStanding =>
      'Cả nước đang dõi theo đội tuyển này: khi đội leo lên trên bảng xếp hạng thế giới, những cầu thủ trẻ giỏi nhất chọn bóng đá, và lứa này đến với chất lượng cao hơn nhờ vậy.';

  @override
  String get msgIntakeNoteBoth =>
      'Tiền đầu tư cho học viện và đà đi lên của đội trên bảng xếp hạng thế giới đều đã phát huy tác dụng: lứa này đến với chất lượng cao hơn mức thông thường.';

  @override
  String msgIntakeTitle(int year) {
    return 'Lứa học viện · $year';
  }

  @override
  String msgRetireCaptainTitle(String name) {
    return 'Đội trưởng $name giải nghệ';
  }

  @override
  String msgRetireTitle(String name) {
    return '$name giải nghệ đội tuyển';
  }

  @override
  String msgRetireBody(String name, int age) {
    return '$name đã giải nghệ khỏi bóng đá quốc tế ở tuổi $age.';
  }

  @override
  String msgRetireBodyWith(String name, String tally, int age) {
    return '$name đã giải nghệ khỏi bóng đá quốc tế ở tuổi $age, khép lại sự nghiệp với $tally.';
  }

  @override
  String msgTallyCaps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lần khoác áo',
    );
    return '$_temp0';
  }

  @override
  String msgTallyGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bàn thắng',
    );
    return '$_temp0';
  }

  @override
  String get msgArmbandVacant =>
      ' Băng đội trưởng đang bỏ trống. Hãy chọn đội trưởng mới ở màn hình triệu tập.';

  @override
  String msgHofTitle(String name) {
    return '$name được vinh danh tại Đại sảnh danh vọng';
  }

  @override
  String msgHofBody(String name, int caps, int goals) {
    return '$name gia nhập Đại sảnh danh vọng của đội tuyển bạn ($caps trận ĐT, $goals bàn). Xem họ ở mục Huyền thoại.';
  }

  @override
  String hubBanTitle(String name) {
    return '$name bị treo giò';
  }

  @override
  String hubBanBody(String name, String how, int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: '$matches trận tới',
    );
    return '$name $how và bị treo giò $_temp0. Họ sẽ không thể được chọn thi đấu.';
  }

  @override
  String get hubBanHowSecondYellow => 'bị đuổi vì thẻ vàng thứ hai';

  @override
  String get hubBanHowViolent => 'nhận thẻ đỏ trực tiếp vì hành vi bạo lực';

  @override
  String get hubBanHowRed => 'bị đuổi khỏi sân';

  @override
  String hubInjuryTitle(String name) {
    return '$name chấn thương';
  }

  @override
  String hubInjuryBody(String name, int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: '$matches trận',
    );
    return '$name dính chấn thương và nghỉ $_temp0.';
  }

  @override
  String get hubRunnerUpTitle1 => 'Á quân';

  @override
  String get hubRunnerUpTitle2 => 'Gần đến thế mà vẫn xa';

  @override
  String get hubRunnerUpTitle3 => 'Huy chương bạc';

  @override
  String hubRunnerUpBody1(String cup, String opponent) {
    return 'Bạn vào chung kết $cup nhưng thua $opponent. Chỉ thiếu một chút. Lần này là huy chương bạc.';
  }

  @override
  String hubRunnerUpBody2(String cup, String opponent) {
    return 'Thua $opponent ở chung kết $cup. Á quân, tiếc nuối đến đau lòng.';
  }

  @override
  String hubRunnerUpBody3(String cup, String opponent) {
    return 'Chung kết $cup vuột mất trước $opponent. Có rất nhiều điều để tự hào, nhưng không có chiếc cúp.';
  }

  @override
  String get hubKnockedOutTitle1 => 'Bị loại';

  @override
  String get hubKnockedOutTitle2 => 'Cuối con đường';

  @override
  String get hubKnockedOutTitle3 => 'Hành trình khép lại';

  @override
  String hubKnockedOutBody1(String cup, String opponent, String stage) {
    return 'Bạn bị loại khỏi $cup, thua $opponent ở $stage.';
  }

  @override
  String hubKnockedOutBody2(String cup, String opponent, String stage) {
    return '$opponent chấm dứt hành trình $cup của bạn ở $stage.';
  }

  @override
  String hubKnockedOutBody3(String cup, String opponent, String stage) {
    return '$cup của bạn dừng lại ở $stage, sau thất bại trước $opponent.';
  }

  @override
  String get hubGroupExitTitle1 => 'Bị loại ở vòng bảng';

  @override
  String get hubGroupExitTitle2 => 'Dừng bước ở vòng bảng';

  @override
  String get hubGroupExitTitle3 => 'Về nhà sớm';

  @override
  String hubGroupExitBody1(String cup) {
    return '$cup của bạn khép lại ở vòng bảng. Chưa đủ để vào vòng đấu loại trực tiếp.';
  }

  @override
  String hubGroupExitBody2(String cup) {
    return 'Bạn không thể vượt qua vòng bảng. $cup của bạn kết thúc tại đây.';
  }

  @override
  String hubGroupExitBody3(String cup) {
    return 'Lần này không có suất vào vòng đấu loại trực tiếp. $cup của bạn dừng ở vòng bảng.';
  }

  @override
  String boardObjectiveMetTitle(String comp) {
    return 'Đạt mục tiêu: $comp';
  }

  @override
  String boardObjectiveMissedTitle(String comp) {
    return 'Trượt mục tiêu: $comp';
  }

  @override
  String boardObjectiveMetBody(String comp, String demand, String finish) {
    return 'Mục tiêu của ban lãnh đạo tại $comp: $demand. Bạn kết thúc ở: $finish. Họ đã có điều mình yêu cầu.';
  }

  @override
  String boardObjectiveMissedBody(String comp, String demand, String finish) {
    return 'Mục tiêu của ban lãnh đạo tại $comp: $demand. Bạn kết thúc ở: $finish. Như vậy là chưa đạt kỳ vọng.';
  }

  @override
  String get newsWcMissTitle => 'Giấc mơ giải vô địch thế giới tan vỡ';

  @override
  String newsWcMissBody(int year) {
    return 'Bạn đã không dự giải vô địch thế giới $year. Chiến dịch vòng loại không đủ sức. Còn bốn năm nữa.';
  }

  @override
  String get newsRecordScorerTitle => 'Vua phá lưới mọi thời đại';

  @override
  String newsRecordScorerBody(String name, int goals) {
    return '$name hiện là vua phá lưới mọi thời đại của game với $goals bàn thắng.';
  }

  @override
  String get newsRecordCapsTitle => 'Cầu thủ khoác áo đội tuyển nhiều nhất';

  @override
  String newsRecordCapsBody(String name, int caps) {
    return '$name hiện là cầu thủ khoác áo đội tuyển nhiều nhất của game với $caps lần ra sân.';
  }

  @override
  String get newsARecordBreaker => 'Một người phá kỷ lục mới';

  @override
  String newsTransferTitle(String name, String club) {
    return '$name gia nhập $club';
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
    return '$name ($position, $rating) đã rời $fromClub để ký hợp đồng với $destination với giá $fee.';
  }

  @override
  String newsTransferAbroad(String club, String country) {
    return '$club ($country)';
  }

  @override
  String get newsTransferFree => 'Miễn phí';

  @override
  String newsNatzStarTitle(String name, String nation) {
    return '⭐ $name sẵn sàng chuyển sang $nation!';
  }

  @override
  String newsNatzTitle(String name, String nation) {
    return '$name muốn thi đấu cho $nation';
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
    return '$name, $position $age tuổi, điểm số $rating, hiện thuộc $fromNation, có gốc gác gia đình liên quan đến $nation và sẵn lòng chuyển đổi. Mở đề nghị nhập tịch để chấp nhận hoặc từ chối.';
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
    return '$name, $position $age tuổi, điểm số $rating, hiện thuộc $fromNation, là một ngôi sao có gốc gác gia đình liên quan đến $nation và sẵn lòng chuyển đổi. Mở đề nghị nhập tịch để chấp nhận hoặc từ chối.';
  }

  @override
  String get newsTheirNation => 'đội tuyển của họ';

  @override
  String get newsYourNation => 'đội tuyển của bạn';

  @override
  String get tourStatusChampions => 'VÔ ĐỊCH';

  @override
  String get tourStatusFinals => 'CHUNG KẾT';

  @override
  String get tourStatusQualifying => 'VÒNG LOẠI';

  @override
  String get tourStatusUpcoming => 'SẮP DIỄN RA';

  @override
  String get tourStatusInProgress => 'ĐANG DIỄN RA';

  @override
  String get tourStatusComingSoon => 'SẮP RA MẮT';

  @override
  String get tourStatusDecided => 'ĐÃ ĐỊNH';

  @override
  String tourStatusLeague(String letter) {
    return 'HẠNG $letter';
  }

  @override
  String get tourDrawWcQualifying => 'BỐC THĂM VÒNG LOẠI THẾ GIỚI';

  @override
  String tourDrawContQualifying(String cup) {
    return 'BỐC THĂM VÒNG LOẠI $cup';
  }

  @override
  String get tourDrawWcHost => 'CHỦ NHÀ VĐ THẾ GIỚI';

  @override
  String tourDrawContHost(String cup) {
    return 'CHỦ NHÀ $cup';
  }

  @override
  String get tourDrawHostsReveal => 'Và các chủ nhà sẽ là…';

  @override
  String get tourDrawHostReveal => 'Và chủ nhà sẽ là…';

  @override
  String get tourDrawHostCandidates => 'Các ứng viên đang cạnh tranh:';

  @override
  String get tourKickoffContinentalCup => 'CÚP CHÂU LỤC';

  @override
  String tourHostCompetitionYear(String competition, int year) {
    return '$competition $year';
  }

  @override
  String newsContMissTitle(String cup) {
    return 'Lỡ hẹn $cup';
  }

  @override
  String newsContMissBody(String cup) {
    return 'Bạn đã không giành vé dự $cup. Chiến dịch lần này chưa đủ tốt.';
  }

  @override
  String get potyLabelBest => 'Cầu thủ của năm';

  @override
  String get potyLabelYoung => 'Cầu thủ trẻ của năm';

  @override
  String potyTallyAssists(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kiến tạo',
    );
    return '$_temp0';
  }

  @override
  String potyOverallValue(int value) {
    return 'Chỉ số $value';
  }

  @override
  String potyRatingValue(String value) {
    return 'Điểm TB $value';
  }

  @override
  String newsPotyTitle(int year) {
    return 'Cầu thủ thế giới của năm $year';
  }

  @override
  String newsPotyBody(String name) {
    return '$name là cầu thủ xuất sắc nhất thế giới năm nay.';
  }

  @override
  String newsPotyYoungSuffix(String name) {
    return ' $name nhận giải cầu thủ trẻ.';
  }

  @override
  String newsWatchTitle(int year) {
    return 'Những cầu thủ trẻ bạn theo dõi, $year';
  }

  @override
  String newsWatchJump(String name, int rating, int gain) {
    String _temp0 = intl.Intl.pluralLogic(
      gain,
      locale: localeName,
      other: '$gain điểm',
    );
    return '$name đã tiến bộ vượt bậc lên $rating, tăng $_temp0 so với năm ngoái.';
  }

  @override
  String newsWatchBand(String name, String band) {
    return '$name lên nhóm $band.';
  }

  @override
  String newsWatchDebutTitle(String name) {
    return '$name ra mắt đội tuyển';
  }

  @override
  String newsWatchDebutBody(String name, int age, int rating) {
    return '$name có lần khoác áo đội tuyển đầu tiên ở tuổi $age, điểm số $rating. Một trong những cầu thủ trẻ bạn đang theo dõi.';
  }

  @override
  String get matchStatsAtFullTime =>
      'Kiểm soát bóng, điểm số cầu thủ và cầu thủ hay nhất trận được chốt khi tiếng còi mãn cuộc vang lên.';

  @override
  String get matchPlayerRatings => 'ĐIỂM SỐ CẦU THỦ';

  @override
  String get matchSubstitutions => 'THAY NGƯỜI';

  @override
  String get matchSubstitutes => 'DỰ BỊ';

  @override
  String get matchPlayerOfTheMatch => 'CẦU THỦ HAY NHẤT TRẬN';

  @override
  String get matchGoalShout => 'VÀO!';

  @override
  String matchShootoutScore(int home, int away) {
    return 'LUÂN LƯU $home–$away';
  }

  @override
  String matchShootoutKickScored(String name) {
    return '$name: VÀO';
  }

  @override
  String matchShootoutKickMissed(String name) {
    return '$name: HỤT';
  }

  @override
  String get matchFeedKickOff => 'Giao bóng!';

  @override
  String get matchFeedNoEvents => 'Chưa có diễn biến nào.';

  @override
  String get tourVenues => 'SÂN ĐẤU';

  @override
  String tourPot(int number) {
    return 'NHÓM $number';
  }

  @override
  String get tourHostSelection => 'CHỌN CHỦ NHÀ';

  @override
  String get tourCandidates => 'ỨNG VIÊN';

  @override
  String get tourJointBid => 'ĐỒNG ĐĂNG CAI';

  @override
  String get tourGoldenGlove => 'GĂNG TAY VÀNG';

  @override
  String get tourTeamOfTournament => 'ĐỘI HÌNH TIÊU BIỂU';

  @override
  String get tourYourRun => 'HÀNH TRÌNH CỦA BẠN';

  @override
  String get tourMedalTable => 'BẢNG HUY CHƯƠNG';

  @override
  String tourHostLine(String nation) {
    return 'Chủ nhà: $nation';
  }

  @override
  String tourHostLineMulti(String hosts) {
    return 'Chủ nhà: $hosts';
  }

  @override
  String tourGroupNamed(String name) {
    return 'Bảng $name';
  }

  @override
  String get tourFinalsDrawBlurb =>
      'Xếp hạt giống theo bảng xếp hạng thế giới. Tìm xem đội của bạn ở đâu trước lễ bốc thăm.';

  @override
  String get tourWorldRanking => 'Bảng xếp hạng thế giới';

  @override
  String get tourYourCompetitions => 'GIẢI ĐẤU CỦA BẠN';

  @override
  String get tourOtherContinents => 'CÁC CHÂU LỤC KHÁC';

  @override
  String get tourZoneGlobal => 'TOÀN CẦU';

  @override
  String get tourZoneEurope => 'CHÂU ÂU';

  @override
  String get tourZoneSouthAmerica => 'NAM MỸ';

  @override
  String get tourZoneNorthAmerica => 'BẮC MỸ';

  @override
  String get tourZoneAfrica => 'CHÂU PHI';

  @override
  String get tourZoneAsia => 'CHÂU Á';

  @override
  String get tourZoneOceania => 'CHÂU ĐẠI DƯƠNG';

  @override
  String get tourZoneIntercontinental => 'LIÊN LỤC ĐỊA';

  @override
  String tourZoneLeague(String league) {
    return 'HẠNG $league';
  }

  @override
  String tourHostedBy(String hosts) {
    return 'CHỦ NHÀ  $hosts';
  }

  @override
  String tourThirdsAdvance(int count, String destination) {
    return '$count đội đứng đầu đi tiếp vào $destination';
  }

  @override
  String newsWalkoutTitle(String name) {
    return '$name quay lưng';
  }

  @override
  String newsWalkoutBody(String name, int age, int caps) {
    return '$name đã giã từ bóng đá quốc tế ở tuổi $age với $caps lần khoác áo đội tuyển. Anh ấy muốn được cho biết vị trí của mình ở đâu nhưng không ai nói, và anh ấy không chờ thêm nữa.';
  }

  @override
  String get pressHeadlineWent1 => 'Một HLV làm chủ cả phòng họp báo';

  @override
  String get pressHeadlineWent2 => 'Họ đến để gây sự và gặp một người dẫn dắt';

  @override
  String get pressHeadlineWent3 => 'Trả lời thẳng thắn, và rất thuyết phục';

  @override
  String get pressHeadlineMixed1 => 'Nói nhiều, chốt chẳng bao nhiêu';

  @override
  String get pressHeadlineMixed2 =>
      'Có chút gì đó cho mọi người, mà chẳng ai được gì';

  @override
  String get pressHeadlineMixed3 => 'Buổi họp báo để ngỏ mọi câu hỏi';

  @override
  String get pressHeadlineBadly1 => 'Một buổi chiều nặng nề trước ống kính';

  @override
  String get pressHeadlineBadly2 => 'Cả phòng quay lưng, và ai cũng thấy';

  @override
  String get pressHeadlineBadly3 =>
      'Những câu trả lời sáng mai đọc sẽ còn tệ hơn';

  @override
  String get pressHeadlineFlat1 => 'Chẳng nói gì, chẳng được gì';

  @override
  String get pressHeadlineFlat2 => 'Mười phút, không có tin gì';

  @override
  String get pressHeadlineFlat3 => 'Trang nhất trắng tinh cho trang cuối';

  @override
  String get pressConferenceTitle => 'HỌP BÁO';

  @override
  String pressQuestionOf(int index, int total) {
    return 'Câu hỏi $index/$total';
  }

  @override
  String get pressTomorrowsHeadline => 'TRANG CUỐI BÁO NGÀY MAI';

  @override
  String get pressLeaveRoom => 'RỜI PHÒNG HỌP';

  @override
  String get pressRoomVerdictSquad => 'Phòng thay đồ';

  @override
  String get pressRoomVerdictBoard => 'Ban lãnh đạo';

  @override
  String get yReactionElation0 =>
      'không có gì để chê. không một chút. hoàn hảo.';

  @override
  String get yReactionElation1 => 'Tôi mê mẩn rồi (theo nghĩa tốt).';

  @override
  String get yReactionElation2 => 'đóng khung cái này. treo trên lò sưởi.';

  @override
  String get yReactionElation3 => 'chúng ta trở lại rồi';

  @override
  String get yReactionElation4 =>
      'Chụp màn hình gửi mấy người hoài nghi. Tất cả bọn họ.';

  @override
  String get yReactionElation5 =>
      'Tôi sẽ khoe chuyện này suốt mười năm cho xem.';

  @override
  String get yReactionElation6 => 'Đúng rồi. Đó là lý do ta xem bóng đá.';

  @override
  String get yReactionElation7 =>
      'Những ngày như hôm nay bù cho tất cả những ngày khác.';

  @override
  String get yReactionElation8 =>
      'Cuối cùng cũng đến. Thật sự là cuối cùng cũng đến.';

  @override
  String get yReactionElation9 =>
      'Tuyệt. Giờ làm lại tuần sau đi rồi tôi mới tin.';

  @override
  String get yReactionElation10 =>
      'Cứ tận hưởng tối nay đi, vì đám này kiểu gì cũng tìm ra cách phá hỏng.';

  @override
  String get yReactionElation11 =>
      'Một đêm hay không làm nên một đội bóng lớn.';

  @override
  String get yReactionRelief0 => 'Không đẹp, nhưng lần nào tôi cũng nhận.';

  @override
  String get yReactionRelief1 => 'Bằng cách nào đó. Bằng cách nào đó thôi!';

  @override
  String get yReactionRelief2 => 'Xấu xí. Ba điểm. Đi tiếp.';

  @override
  String get yReactionRelief3 => 'Xấu cỡ nào tôi cũng chịu miễn là có điểm.';

  @override
  String get yReactionRelief4 => 'mất mười năm tuổi thọ vì trận này';

  @override
  String get yReactionRelief5 => 'Không ai nói gì. Không ai được nói gở.';

  @override
  String get yReactionRelief6 => 'Nhịp tim: không thể chấp nhận.';

  @override
  String get yReactionRelief7 => 'Sống sót. Đúng từ đó. Sống sót.';

  @override
  String get yReactionRelief8 =>
      'Lẽ ra ta không cần phải thở phào vì những trận như thế.';

  @override
  String get yReactionRelief9 => 'Nhẹ người, và hơi xấu hổ vì mình nhẹ người.';

  @override
  String get yReactionRelief10 =>
      'Nếu đó là chuẩn mực ta ăn mừng thì ta gặp rắc rối rồi.';

  @override
  String get yReactionRelief11 =>
      'Thoát hiểm thành thói quen, và đó không phải thói quen tốt.';

  @override
  String get yReactionFury0 => 'Không đủ tốt. Còn lâu mới đủ.';

  @override
  String get yReactionFury1 => 'Ai đó giải thích chậm rãi cho tôi cái này đi.';

  @override
  String get yReactionFury2 => 'Xem mà khổ, và tôi đã nói giảm nói tránh rồi.';

  @override
  String get yReactionFury3 => 'Thất vọng. Thật sự thất vọng.';

  @override
  String get yReactionFury4 => 'Quá tệ hại.';

  @override
  String get yReactionFury5 => 'Tôi muốn biết tên.';

  @override
  String get yReactionFury6 => 'Xóa app. Thứ Năm cài lại.';

  @override
  String get yReactionFury7 => 'Không ai ngoài sân trông có vẻ muốn thắng cả.';

  @override
  String get yReactionFury8 =>
      'Bốn năm một lần, lần nào cũng thế. LẦN NÀO cũng thế.';

  @override
  String get yReactionFury9 =>
      'Đó không phải là một màn trình diễn, đó là sự xúc phạm.';

  @override
  String get yReactionFury10 =>
      'Người ta bỏ cả cuối tuần và tiền bạc vì đội này. Nghĩ lại đi.';

  @override
  String get yReactionFury11 =>
      'Tôi bảo vệ đội này bao năm nay. Tối nay thì không. Không sau trận đó.';

  @override
  String get yReactionDespair0 => 'thôi.';

  @override
  String get yReactionDespair1 => 'Hôm nay không đùa nữa. Không gì cả.';

  @override
  String get yReactionDespair2 => 'Đi dạo đây. Đi dạo lâu.';

  @override
  String get yReactionDespair3 => 'Tôi hết cách để nói chuyện này rồi.';

  @override
  String get yReactionDespair4 => 'Bốn năm nữa gọi tôi dậy.';

  @override
  String get yReactionDespair5 => 'đây là dòng thời gian tăm tối nhất';

  @override
  String get yReactionDespair6 =>
      'Thậm chí không còn giận nữa. Đó mới là điều đáng lo.';

  @override
  String get yReactionDespair7 => 'Trận này sẽ còn đau rất lâu.';

  @override
  String get yReactionDespair8 =>
      'Tôi không biết đây là cái gì nữa, nhưng không phải một đội bóng.';

  @override
  String get yReactionDespair9 =>
      'Ta còn xa hơn trước, và không ai chịu nói ra.';

  @override
  String get yReactionDespair10 =>
      'Cả một thế hệ bị bỏ phí mà vẫn những người đó quyết định chuyện tiếp theo.';

  @override
  String get yReactionDespair11 =>
      'Đừng bảo tôi đó là một quá trình nữa. Nó có đi đến đâu đâu.';

  @override
  String get yReactionSmugness0 => 'Nói nhỏ thôi, nhưng: đã bảo rồi mà.';

  @override
  String get yReactionSmugness1 => 'lưu bài này lại nhé';

  @override
  String get yReactionSmugness2 => 'Mấy người hoài nghi im re rồi nhỉ.';

  @override
  String get yReactionSmugness3 =>
      'Không phải ai cũng đang đếm. Tôi thì đang đếm.';

  @override
  String get yReactionSmugness4 =>
      'Tháng Giêng đã nói rồi. Xem lại dòng thời gian đi.';

  @override
  String get yReactionSmugness5 =>
      'Một số người nợ một số người một lời xin lỗi.';

  @override
  String get yReactionSmugness6 =>
      'Xếp cái này vào mục những điều tôi nói đầu tiên.';

  @override
  String get yReactionSmugness7 => 'Không hả hê. Hả hê một chút thôi.';

  @override
  String get yReactionSmugness8 => 'Các chuyên gia đâu hết rồi? Hỏi thật đấy.';

  @override
  String get yReactionSmugness9 =>
      'Tôi muốn từng người trong các bạn nhắc lại câu đó cho tôi nghe.';

  @override
  String get yReactionSmugness10 =>
      'Chụp màn hình, in ra, đóng khung, gửi cho những người từng cười.';

  @override
  String get yReactionSmugness11 =>
      'Tôi sẽ nhắc chuyện này đến hết đời và các bạn xứng đáng bị thế.';

  @override
  String get yReactionShrug0 => 'xảy ra rồi. tiếp.';

  @override
  String get yReactionShrug1 => 'Ừ thì. Sao cũng được. Đi tiếp.';

  @override
  String get yReactionShrug2 => 'Xếp cái này vào mục \'bóng đá\'.';

  @override
  String get yReactionShrug3 => 'Thật sự không có gì để nói thêm.';

  @override
  String get yReactionShrug4 => 'không suy nghĩ gì, đầu trống rỗng';

  @override
  String get yReactionShrug5 => 'Trận sau thì gọi tôi dậy.';

  @override
  String get yReactionShrug6 => 'Chín mươi phút không bao giờ lấy lại được.';

  @override
  String get yReactionShrug7 => 'Chẳng ra làm sao cả.';

  @override
  String get yReactionShrug8 => 'Không thể kể ra được một điều gì đã xảy ra.';

  @override
  String get yReactionShrug9 =>
      'Lại một trận như thế. Có nhiều trận như thế lắm.';

  @override
  String get yReactionShrug10 => 'Tôi xem hết và chẳng cảm thấy gì cả.';

  @override
  String get yReactionShrug11 =>
      'Nếu không ai nhắc lại chuyện này nữa thì tôi cũng ổn.';

  @override
  String get tourThirdsUneven =>
      'Các bảng có số đội không đều, nên các trận gặp đội cuối bảng của những bảng lớn được bỏ qua để mọi đội được xét trên cùng số trận.';

  @override
  String get careerExportSave => 'Sao lưu bản lưu này';

  @override
  String get careerBackupAll => 'SAO LƯU TẤT CẢ BẢN LƯU';

  @override
  String get careerBackupAllFailed => 'Không thể ghi bản sao lưu.';

  @override
  String get backupTitle => 'BẢN LƯU';

  @override
  String get backupBlurb =>
      'Mọi bản lưu nằm trong một tệp duy nhất trên điện thoại này và không có gì tự động sao lưu chúng. Hãy xuất một bản sao và cất ở nơi ngoài điện thoại, trong Tệp hoặc iCloud Drive, để mất điện thoại hay lỡ xóa app không khiến bạn mất cả sự nghiệp.';

  @override
  String get backupExport => 'XUẤT BẢN SAO LƯU';

  @override
  String get backupExportSubject => 'Bản lưu FNM';

  @override
  String get backupRestore => 'KHÔI PHỤC TỪ TỆP';

  @override
  String get backupRestoreWarnTitle => 'Thay thế mọi bản lưu?';

  @override
  String get backupRestoreWarnBody =>
      'Khôi phục sẽ thay thế mọi bản lưu trên điện thoại này bằng các bản lưu trong tệp. App sẽ khởi động lại.';

  @override
  String get backupRestoreConfirm => 'THAY THẾ';

  @override
  String get backupCancel => 'HỦY';

  @override
  String get backupExported => 'Bản sao lưu đã sẵn sàng. Hãy chọn nơi lưu giữ.';

  @override
  String get backupFailed => 'Không thể ghi bản sao lưu.';

  @override
  String get backupRejectedUnreadable => 'Không thể mở tệp đó.';

  @override
  String get backupRejectedNotFnm => 'Đó không phải bản lưu FNM.';

  @override
  String get backupRejectedNewer =>
      'Bản lưu đó được tạo bởi phiên bản app mới hơn. Hãy cập nhật trước.';

  @override
  String get backupRejectedTooOld =>
      'Bản lưu đó quá cũ để phiên bản này khôi phục.';

  @override
  String get careerShare => 'Chia sẻ sự nghiệp này';

  @override
  String get careerImport => 'NHẬP MỘT SỰ NGHIỆP';

  @override
  String get careerShareSubject => 'Một sự nghiệp FNM';

  @override
  String get careerImported => 'Đã nhập sự nghiệp.';

  @override
  String get careerImportFailedUnreadable =>
      'Tệp đó không phải một sự nghiệp FNM.';

  @override
  String get careerImportFailedNewer =>
      'Sự nghiệp đó được xuất bởi phiên bản app mới hơn. Hãy cập nhật trước.';

  @override
  String get careerImportFailedSlotsFull =>
      'Tất cả ô lưu của bạn đã dùng hết. Hãy xóa một bản lưu để có chỗ, hoặc mở khóa không giới hạn bản lưu.';

  @override
  String get careerImportFailedNeedsPremium =>
      'Sự nghiệp đó đã vượt quá chu kỳ miễn phí đầu tiên. Hãy mở khóa bản đầy đủ để nhập nó.';

  @override
  String get careerImportFailedCampaignRun =>
      'Chiến dịch đó đã có một hành trình đang diễn ra. Hãy tiếp tục hoặc bỏ nó trước.';

  @override
  String get careerShareFailed => 'Không thể xuất sự nghiệp đó.';

  @override
  String get managerRename => 'Đổi tên';

  @override
  String get managerRenameSave => 'Lưu';

  @override
  String get managerTitle => 'HUẤN LUYỆN VIÊN';

  @override
  String get managerSkills => 'KỸ NĂNG CỦA BẠN';

  @override
  String managerPointsAvailable(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count điểm để dùng',
      zero: 'Không còn điểm để dùng',
    );
    return '$_temp0';
  }

  @override
  String get managerPointsHow =>
      'Hai điểm cho mỗi chu kỳ bạn hoàn thành, một điểm cho mỗi danh hiệu bạn giành được.';

  @override
  String get managerSkillsScale =>
      'Mọi kỹ năng bắt đầu từ 5 và tối đa là 20. Điểm đã dùng là vĩnh viễn.';

  @override
  String get managerSkillManManagement => 'Quản lý con người';

  @override
  String get managerSkillManManagementBlurb =>
      'Mỗi điểm giúp những gì bạn nói với báo chí và cầu thủ có sức nặng hơn 3% trong phòng thay đồ.';

  @override
  String get managerSkillTactical => 'Chiến thuật';

  @override
  String get managerSkillTacticalBlurb =>
      'Mỗi điểm giúp sơ đồ mới thấm nhanh hơn 3%, nên đổi sơ đồ tốn ít trận hơn.';

  @override
  String get managerSkillYouth => 'Đào tạo trẻ';

  @override
  String get managerSkillYouthBlurb =>
      'Mỗi điểm thêm 1% tài năng từ học viện của bạn, cộng thêm phần bạn đầu tư cho nó.';

  @override
  String get managerSkillNegotiation => 'Đàm phán';

  @override
  String get managerSkillNegotiationBlurb =>
      'Mỗi điểm là thêm 2% tiền từ liên đoàn, mỗi chu kỳ.';

  @override
  String get managerStaff => 'BAN HUẤN LUYỆN CỦA BẠN';

  @override
  String managerStaffWages(String amount) {
    return 'Lương: $amount mỗi chu kỳ';
  }

  @override
  String get managerRoleAssistant => 'Trợ lý HLV';

  @override
  String get managerRoleAssistantBlurb =>
      'Phụ trách huấn luyện: ít chấn thương hơn và lứa trẻ lên tốt hơn.';

  @override
  String get managerRoleScout => 'Trưởng ban tuyển trạch';

  @override
  String get managerRoleScoutBlurb =>
      'Đọc vị tài năng trẻ và đối thủ sắp tới: sao đánh giá chuẩn hơn, và lợi thế vào ngày thi đấu.';

  @override
  String get managerRoleFitness => 'HLV thể lực';

  @override
  String get managerRoleFitnessBlurb => 'Giữ cầu thủ ở lại sân cỏ.';

  @override
  String staffEffectInjury(int percent) {
    return 'Ít chấn thương hơn $percent%';
  }

  @override
  String staffEffectYouth(int points) {
    return 'Cầu thủ trẻ +$points chỉ số tổng';
  }

  @override
  String staffHiringInjury(int min, int max) {
    return 'Thuê một người: ít chấn thương hơn $min% đến $max%';
  }

  @override
  String staffHiringYouth(int minPoints, int maxPoints) {
    return 'và cầu thủ trẻ +$minPoints đến +$maxPoints chỉ số tổng';
  }

  @override
  String staffEffectScoutRead(int percent) {
    return 'Đọc đúng chính xác $percent% tài năng';
  }

  @override
  String staffEffectScoutCaps(int caps) {
    String _temp0 = intl.Intl.pluralLogic(
      caps,
      locale: localeName,
      other: 'Biết tiềm năng sau $caps lần khoác áo đội tuyển',
      one: 'Biết tiềm năng sau 1 lần khoác áo đội tuyển',
    );
    return '$_temp0';
  }

  @override
  String staffEffectScoutDossier(int points) {
    return '+$points điểm số từ hồ sơ đối thủ';
  }

  @override
  String staffHiringScoutRead(int min, int max) {
    return 'Thuê một người: đọc đúng $min% đến $max% tài năng';
  }

  @override
  String staffHiringScoutCaps(int minCaps, int maxCaps) {
    return 'và biết tiềm năng sớm hơn $minCaps đến $maxCaps trận ĐT';
  }

  @override
  String staffHiringScoutDossier(int minPoints, int maxPoints) {
    return 'và +$minPoints đến +$maxPoints điểm số mỗi trận';
  }

  @override
  String get staffEffectNone => 'Chưa ảnh hưởng đến đội hình của bạn';

  @override
  String get staffVacant => 'Chưa có ai đảm nhiệm';

  @override
  String get staffLeaveVacant => 'Để trống vị trí';

  @override
  String get managerTierNone => 'Không';

  @override
  String get managerTierBasic => 'Cơ bản';

  @override
  String get managerTierGood => 'Tốt';

  @override
  String get managerTierElite => 'Tinh nhuệ';

  @override
  String get managerFree => 'miễn phí';

  @override
  String get managerTraining => 'GIỮA CÁC ĐỢT';

  @override
  String get managerTrainingBlurb =>
      'Những gì đội tập luyện khi không có trận để đá.';

  @override
  String get managerFocusBalanced => 'Cân bằng';

  @override
  String get managerFocusBalancedBlurb => 'Một chút mọi thứ.';

  @override
  String get managerFocusFitness => 'Thể lực';

  @override
  String get managerFocusFitnessBlurb => 'Ít va chạm chấn thương hơn.';

  @override
  String get managerFocusCohesion => 'Gắn kết';

  @override
  String get managerFocusCohesionBlurb => 'Sơ đồ thấm nhanh hơn.';

  @override
  String get managerFocusYouth => 'Trẻ';

  @override
  String get managerFocusYouthBlurb =>
      'Dành thời gian cho những cầu thủ trẻ nhất trong nguồn.';

  @override
  String get tourOfferTitle => 'Lần đầu đến đây?';

  @override
  String get tourOfferBody =>
      'Đây là một game lớn. Muốn đi nhanh qua các màn hình quan trọng không? Chỉ mất một phút, và bạn có thể bắt đầu lại bất cứ lúc nào từ Cài đặt.';

  @override
  String get tourOfferYes => 'Dẫn tôi đi xem';

  @override
  String get tourOfferNo => 'Không, cảm ơn';

  @override
  String get tourBack => 'Quay lại';

  @override
  String get tourNext => 'Tiếp theo';

  @override
  String get tourDone => 'Xong';

  @override
  String get tourSkip => 'Bỏ qua';

  @override
  String get tourHubTitle => 'Đây là toàn bộ game';

  @override
  String get tourHubBody =>
      'Một nút duy nhất, đổi theo nhịp chu kỳ: một lễ bốc thăm để xem, một danh sách đội hình để chốt, một trận để đá. Phía trên là niềm tin của ban lãnh đạo dành cho bạn và các mục tiêu họ đặt ra.';

  @override
  String get tourBudgetTitle => 'Tiền của liên đoàn';

  @override
  String get tourBudgetBody =>
      'Mỗi chu kỳ bốn năm một lần, bạn chia quỹ cho các bộ phận. Ban huấn luyện được trả lương từ đó trước tiên, nên thuê một tuyển trạch viên tinh nhuệ là quyết định đánh đổi với học viện, không phải thêm vào.';

  @override
  String get tourTacticsTitle => 'Đội chơi thế nào';

  @override
  String get tourTacticsBody =>
      'Sơ đồ, lối chơi, đội trưởng và người đá tình huống cố định. Để trống hai mục cuối thì game sẽ cảnh báo bạn trước giờ giao bóng thay vì lặng lẽ chọn hộ.';

  @override
  String get tourSquadTitle => 'Mọi người bạn có thể chọn';

  @override
  String get tourSquadBody =>
      'Toàn bộ nguồn cầu thủ, không chỉ danh sách đội hình: ai đang có phong độ, ai mang chấn thương, ai bị treo giò, và ai vừa lên từ học viện.';

  @override
  String get tourCallUpsTitle => 'Chốt danh sách đội hình';

  @override
  String get tourCallUpsBody =>
      'Bạn chốt một danh sách cho mỗi đợt thi đấu quốc tế và nó đá mọi trận của đợt đó, y như một HLV thật. Có chấn thương trong đợt thì sẽ có người thay thế được gọi thêm cho bạn.';

  @override
  String get tourRecordsTitle => 'Sự nghiệp của bạn';

  @override
  String get tourRecordsBody =>
      'Mọi thứ bạn đã làm: các trận đấu, kỷ lục đội tuyển, danh hiệu, và mọi đội tuyển bạn đã dẫn dắt.';

  @override
  String get tourCupsTitle => 'Phần còn lại của thế giới';

  @override
  String get tourCupsBody =>
      'Mọi giải đấu đang diễn ra: vòng bảng, bảng xếp hạng và vòng đấu loại trực tiếp, kể cả những giải bạn không tham dự. Thế giới vẫn thi đấu dù bạn có giành vé hay không.';

  @override
  String get settingsTourTitle => 'Xem lại hướng dẫn';

  @override
  String get settingsTourBlurb => 'Đi lại các màn hình chính từ đầu.';

  @override
  String get tourBoardTitle => 'Bạn phải trả lời với ai';

  @override
  String get tourBoardBody =>
      'Niềm tin của ban lãnh đạo dành cho bạn và các mục tiêu họ đặt ra cho chu kỳ này. Không đạt chỉ tiêu thì đây là nơi bạn thấy nó đang đến gần.';

  @override
  String get tourStaffTitle => 'Những người quanh bạn';

  @override
  String get tourStaffBody =>
      'Một trợ lý, một tuyển trạch viên và một HLV thể lực, thuê đích danh. Lương của họ được trừ vào ngân sách này trước các bộ phận, nên một tuyển trạch viên giỏi là quyết định đánh đổi với học viện.';

  @override
  String get tourPlaystyleTitle => 'Lối chơi của bạn';

  @override
  String get tourPlaystyleBody =>
      'Sơ đồ mới chỉ là nửa chiến thuật. Đây là nửa còn lại: pressing cao đến đâu, trực diện đến đâu, mạo hiểm đến đâu.';

  @override
  String get settingsTourNoSave =>
      'Hãy bắt đầu một sự nghiệp trước. Phần hướng dẫn đi qua các màn hình của chính bạn.';

  @override
  String tacticsOutOfPositionAge(int age) {
    return 'Trái sở trường · $age tuổi';
  }

  @override
  String get federationNextCycleLocked =>
      'Ngân sách chu kỳ sau được chốt một lần vào đầu chu kỳ đó. Cho đến lúc ấy, đây là cách tiền của bạn đang được dùng.';

  @override
  String get federationBudgetAlreadySet => 'Đã chốt cho chu kỳ này';

  @override
  String yFinalLooms0(String opponent) {
    return 'Là $opponent cho trận chung kết. Cả tuần này, ai cũng chỉ bàn chuyện này.';
  }

  @override
  String yFinalLooms1(String opponent) {
    return 'Xác nhận: $opponent đứng giữa chúng ta và chiếc cúp. Bốn năm chờ đợi cho trận này.';
  }

  @override
  String yFinalLooms2(String opponent) {
    return 'Rồi. $opponent. Không ai ngủ được cho đến khi xong chuyện.';
  }

  @override
  String yFinalLooms3(String opponent) {
    return '$opponent là trận tới, mọi thứ khác để sau. Một tuần để đời.';
  }

  @override
  String get matchSetupLeaveToCoach => 'Để HLV chọn người đá';

  @override
  String friendliesLikeYourGroup(String rivals) {
    return 'Được đánh dấu bên dưới: các đội có lối chơi giống $rivals, những đội bạn sẽ gặp ở vòng bảng chu kỳ này.';
  }

  @override
  String newsTransferWindowTitle(int year) {
    return 'Kỳ chuyển nhượng · $year';
  }

  @override
  String careerLastAgo(String when) {
    return 'Lần cuối cách đây $when';
  }

  @override
  String get settingsFreeScopeTitle => 'Một chu kỳ bốn năm miễn phí';

  @override
  String get settingsFreeScopeBlurb =>
      'Một chu kỳ trọn vẹn (vòng loại, giải vô địch châu lục của bạn và Giải vô địch thế giới) trên hai bản lưu, mọi quốc gia trên thế giới, không giấu giếm gì. Chu kỳ không giới hạn và bản lưu không giới hạn chỉ là một lần thanh toán duy nhất, và bao gồm mọi bản cập nhật tương lai.';

  @override
  String get settingsUnlockedTitle => 'Đã mở khóa';

  @override
  String get settingsUnlockedBlurb =>
      'Chu kỳ không giới hạn, bản lưu không giới hạn và mọi bản cập nhật tương lai. Cảm ơn bạn.';

  @override
  String get settingsFromDeveloperTitle => 'Từ nhà phát triển';

  @override
  String get settingsFromDeveloperBlurb =>
      'Football Nations Manager do một người làm ra và sẽ được hỗ trợ lâu dài. Sẽ không bao giờ có quảng cáo hay giao dịch vi mô. Nếu bạn thích game, hãy cân nhắc mua bản đầy đủ. Đó là điều giúp các bản cập nhật tiếp tục ra mắt.';

  @override
  String get settingsFromDeveloperThanksBlurb =>
      'Football Nations Manager do một người làm ra và sẽ được hỗ trợ lâu dài. Sẽ không bao giờ có quảng cáo hay giao dịch vi mô. Cảm ơn bạn đã mua bản đầy đủ. Đó là điều giúp các bản cập nhật tiếp tục ra mắt.';

  @override
  String friendliesLikeYourCampaign(String rivals) {
    return 'Được đánh dấu bên dưới: các đội có lối chơi giống $rivals, những đội bạn vẫn còn phải đối đầu.';
  }

  @override
  String get friendliesCloseToYou =>
      'Được đánh dấu bên dưới: các đội gần bạn nhất trên bảng xếp hạng thế giới. Sau khi bạn được bốc thăm, các dấu sẽ theo bảng của bạn.';

  @override
  String transfersMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count thương vụ',
      one: '1 thương vụ',
    );
    return '$_temp0';
  }

  @override
  String hubRoundPage(int page, int pages) {
    return '$page / $pages';
  }

  @override
  String get transfersNewer => 'Mới hơn';

  @override
  String get transfersOlder => 'Xem thêm';

  @override
  String get transfersPagePrevious => 'Trước';

  @override
  String get transfersPageNext => 'Sau';

  @override
  String transfersPageOf(int page, int pages) {
    return 'Trang $page/$pages';
  }

  @override
  String get transfersMovedTo => 'Chuyển đến';

  @override
  String get transfersUnknownClub => 'CLB không rõ';

  @override
  String yAgainstThemAgain0(String opponent, String count) {
    return 'Đã $count lần gặp $opponent rồi. Có ai đó đang ghi sổ, và đó là họ.';
  }

  @override
  String yAgainstThemAgain1(String opponent, String count) {
    return 'Lại là $opponent. $count lần đối đầu mà ta vẫn chưa tìm ra cách.';
  }

  @override
  String yAgainstThemAgain2(String opponent, String count) {
    return 'Lần thứ $count gặp $opponent. Đây không còn là trùng hợp nữa.';
  }

  @override
  String yAgainstThemAgain3(String opponent, String count) {
    return 'Ta đã đá với $opponent $count lần mà chẳng học được gì từ lần nào.';
  }

  @override
  String yAgainstThemAgain4(String opponent, String count) {
    return '$opponent, $count lần. Họ biết chính xác ta sẽ làm gì.';
  }

  @override
  String yAgainstThemAgain5(String opponent, String count) {
    return '$opponent nắm thóp ta thế nào thì sau $count lần đối đầu họ vẫn nắm thế ấy.';
  }

  @override
  String ySameOldStory0(String count) {
    return 'Đây là lần thứ $count chuyện này xảy ra gần đây. Đến khi nào nó mới thôi là bản chất của ta?';
  }

  @override
  String ySameOldStory1(String count) {
    return '$count buổi chiều như thế rồi. Đó là quy luật, không phải chuỗi xui.';
  }

  @override
  String ySameOldStory2(String count) {
    return 'Ta đã xem đúng trận này $count lần gần đây. Cùng kịch bản, cùng cái kết.';
  }

  @override
  String ySameOldStory3(String count) {
    return '$count phiên bản của cùng chín mươi phút rồi. Không ai sửa cả.';
  }

  @override
  String ySameOldStory4(String count) {
    return '$count lần. Nếu đến giờ vẫn chưa thấy quy luật thì là bạn không chịu nhìn.';
  }

  @override
  String ySameOldStory5(String count) {
    return 'Cùng một câu chuyện, $count lần. Cớ đã cạn trước khi kết quả cạn.';
  }

  @override
  String get yToldYouSo0 =>
      'Tôi đã nói điều này sẽ đến khi mọi người còn mải ăn mừng.';

  @override
  String get yToldYouSo1 =>
      'Hai tuần tốt và ta lại thành thế hệ vàng. Và giờ thì thế này đây.';

  @override
  String get yToldYouSo2 =>
      'Những người bảo tôi cứ tận hưởng hồi tháng trước giờ im lặng cả rồi.';

  @override
  String get yToldYouSo3 =>
      'Tôi chẳng vui gì chuyện này. Rất ít vui. Một chút.';

  @override
  String get yToldYouSo4 =>
      'Chưa bao giờ giỏi như họ nói, và đây là bằng chứng.';

  @override
  String get yToldYouSo5 =>
      'Lần nào cũng vậy. Người ta bảo lần này khác, mà lần nào cũng không.';

  @override
  String get tacticsSubOffAlready => 'Đã rút ra';

  @override
  String get tacticsSubInjured => 'Chấn thương';

  @override
  String get tacticsSubSentOffMark => 'Bị đuổi';

  @override
  String get tacticsSubNoneLeft => 'Hết lượt thay';

  @override
  String get tacticsUndoLastChange => 'Hoàn tác thay đổi cuối';

  @override
  String get matchStrengthTitle => 'ĐIỀU ĐANG TÁC ĐỘNG ĐẾN ĐỘI';

  @override
  String get strengthFactorFamiliarity => 'Sơ đồ đã tập kỹ';

  @override
  String get strengthFactorFatigue => 'Đôi chân mệt mỏi';

  @override
  String get strengthFactorClubForm => 'Phong độ CLB';

  @override
  String get strengthFactorMorale => 'Phòng thay đồ';

  @override
  String get strengthFactorCaptain => 'Đội trưởng';

  @override
  String get strengthFactorStaff => 'Phòng ban huấn luyện';

  @override
  String get strengthFactorDossier => 'Hồ sơ tuyển trạch';

  @override
  String yDebut0(String name) {
    return '$name có lần khoác áo đội tuyển đầu tiên. Nhớ cái tên này.';
  }

  @override
  String yDebut1(String name) {
    return 'Màn ra mắt của $name. Nhìn là thấy ngay, đúng không?';
  }

  @override
  String yDebut2(String name) {
    return '$name, lần đầu khoác áo. Xem cậu ấy làm gì với cơ hội này.';
  }

  @override
  String yDebut3(String name) {
    return 'Ra mắt của $name. Đội cần chân mới ở đâu đó.';
  }

  @override
  String yDebut4(String name) {
    return '$name được trao suất khoác áo. Gần đây ta trao nhiều suất lắm rồi.';
  }

  @override
  String yDebut5(String name) {
    return 'Ra mắt của $name. Lại một cái tên nữa mà đến mùa xuân ta sẽ quên.';
  }

  @override
  String yDrought0(String name, String count) {
    return '$name đã $count trận không ghi bàn mà vẫn làm mọi việc khác trên sân.';
  }

  @override
  String yDrought1(String name, String count) {
    return '$count trận không bàn thắng của $name. Chuyện xui thường đến ba, từ xưa vẫn thế.';
  }

  @override
  String yDrought2(String name, String count) {
    return '$name: $count trận, không bàn thắng.';
  }

  @override
  String yDrought3(String name, String count) {
    return '$name $count trận không ghi bàn. Đáng để để mắt.';
  }

  @override
  String yDrought4(String name, String count) {
    return '$count trận. Không bàn thắng. $name đứng trước cửa rộng cũng không trúng.';
  }

  @override
  String yDrought5(String name, String count) {
    return '$name đã không ghi bàn trong $count trận. Cho ai khác đá đi.';
  }

  @override
  String yRivalryLooms0(String opponent, String count) {
    return '$opponent là trận tới. $count lần đối đầu mà vẫn có ý nghĩa tất cả.';
  }

  @override
  String yRivalryLooms1(String opponent, String count) {
    return 'Đã $count lần gặp $opponent rồi. Cứ đến đi.';
  }

  @override
  String yRivalryLooms2(String opponent, String count) {
    return '$opponent là trận tới. Đã đá $count lần.';
  }

  @override
  String yRivalryLooms3(String opponent, String count) {
    return 'Lần gặp thứ $count với $opponent trong tuần này.';
  }

  @override
  String yRivalryLooms4(String opponent, String count) {
    return 'Lại là $opponent. $count lần thế này mà ta chẳng học được gì.';
  }

  @override
  String yRivalryLooms5(String opponent, String count) {
    return '$count trận gặp $opponent mà họ vẫn thắng ta. Tuyệt vời.';
  }

  @override
  String get positionGoalkeeper => 'Thủ môn';

  @override
  String get positionLeftBack => 'Hậu vệ trái';

  @override
  String get positionCentreBack => 'Trung vệ';

  @override
  String get positionRightBack => 'Hậu vệ phải';

  @override
  String get positionDefensiveMid => 'Tiền vệ phòng ngự';

  @override
  String get positionCentralMid => 'Tiền vệ trung tâm';

  @override
  String get positionAttackingMid => 'Tiền vệ tấn công';

  @override
  String get positionLeftMid => 'Tiền vệ trái';

  @override
  String get positionRightMid => 'Tiền vệ phải';

  @override
  String get positionLeftWing => 'Tiền vệ cánh trái';

  @override
  String get positionRightWing => 'Tiền vệ cánh phải';

  @override
  String get positionStriker => 'Tiền đạo cắm';

  @override
  String get roleNone => 'Không vai trò';

  @override
  String get roleTargetMan => 'Tiền đạo mục tiêu';

  @override
  String get rolePoacher => 'Sát thủ vòng cấm';

  @override
  String get rolePlaymaker => 'Nhạc trưởng';

  @override
  String get roleBallWinner => 'Cầu thủ đoạt bóng';

  @override
  String get roleInvertedWinger => 'Tiền vệ cánh cắt vào';

  @override
  String get roleBallPlayingDefender => 'Hậu vệ phát động';

  @override
  String get roleNoneBlurb => 'Chơi theo lối tự nhiên của mình.';

  @override
  String get roleTargetManBlurb =>
      'Thắng bóng bổng, chuyền lại. Kiến tạo và tình huống cố định.';

  @override
  String get rolePoacherBlurb =>
      'Rình rập trong vòng cấm. Ghi nhiều bàn hơn hẳn.';

  @override
  String get rolePlaymakerBlurb => 'Tạo cơ hội. Kiến tạo nhiều hơn hẳn.';

  @override
  String get roleBallWinnerBlurb => 'Phá lối chơi chứ không phải dứt điểm.';

  @override
  String get roleInvertedWingerBlurb =>
      'Cắt vào trong để sút. Ghi nhiều bàn hơn.';

  @override
  String get roleBallPlayingDefenderBlurb =>
      'Khởi đầu các pha bóng từ phía sau.';

  @override
  String get federationDeptYouth => 'Học viện trẻ';

  @override
  String get federationDeptCommercial => 'Thương mại / PR';

  @override
  String get federationDeptMedical => 'Y tế & Khoa học thể thao';

  @override
  String get federationDeptNaturalisation => 'Văn phòng nhập tịch';

  @override
  String get federationDeptBoardRelations => 'Quan hệ với ban lãnh đạo';

  @override
  String get federationDeptYouthBlurb =>
      'Tài năng học viện giỏi hơn sẽ ra mắt đội tuyển của bạn ở chu kỳ sau.';

  @override
  String get federationDeptCommercialBlurb =>
      'Tài trợ mang lại thu nhập thêm vào cuối chu kỳ.';

  @override
  String get federationDeptMedicalBlurb =>
      'Ít chấn thương hơn. Đội hình của bạn luôn sẵn sàng suốt chu kỳ.';

  @override
  String get federationDeptNaturalisationBlurb =>
      'Nhiều cầu thủ nước ngoài đề nghị chuyển sang đội tuyển của bạn hơn.';

  @override
  String get federationDeptBoardRelationsBlurb =>
      'Ban lãnh đạo đánh giá kết quả của bạn kiên nhẫn hơn.';

  @override
  String get federationBuildingAcademy => 'Học viện';

  @override
  String get federationBuildingCommercial => 'Trụ sở thương mại';

  @override
  String get federationBuildingMedical => 'Trung tâm y tế';

  @override
  String get federationBuildingScouting => 'Văn phòng tuyển trạch';

  @override
  String get federationBuildingBoardroom => 'Phòng họp ban lãnh đạo';

  @override
  String get moraleBuoyant => 'Phấn chấn';

  @override
  String get moralePositive => 'Tích cực';

  @override
  String get moraleSettled => 'Ổn định';

  @override
  String get moraleUneasy => 'Bất an';

  @override
  String get moraleRockBottom => 'Đáy vực';

  @override
  String get matchTabTimeline => 'DIỄN BIẾN';

  @override
  String get matchTabStats => 'THỐNG KÊ';

  @override
  String get matchTabLineups => 'ĐỘI HÌNH';

  @override
  String get matchPenalty => 'PHẠT ĐỀN';

  @override
  String get matchStateLevel => 'Hai đội đang hòa';

  @override
  String matchStateLead(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bạn đang dẫn $count bàn',
      one: 'Bạn đang dẫn một bàn',
    );
    return '$_temp0';
  }

  @override
  String matchStateTrail(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bạn đang kém $count bàn',
      one: 'Bạn đang kém một bàn',
    );
    return '$_temp0';
  }

  @override
  String matchPossessionShare(int possession) {
    return '$possession% kiểm soát bóng';
  }

  @override
  String get boardVerdictSackedTitle => 'Ban lãnh đạo đã sa thải bạn';

  @override
  String boardVerdictSackedBody(int rating) {
    return 'Một chu kỳ tồi tệ (đánh giá $rating%). Triều đại của bạn kết thúc tại đây. Giờ chỉ còn các đội tuyển yếu hơn chịu mạo hiểm với bạn.';
  }

  @override
  String get boardVerdictDelightedTitle => 'Ban lãnh đạo rất hài lòng';

  @override
  String boardVerdictDelightedBody(int rating, String best) {
    return 'Một chu kỳ xuất sắc (đánh giá $rating%) sau $best. Các đội tuyển lớn hơn đang quan tâm, hoặc bạn có thể ở lại xây dựng.';
  }

  @override
  String get boardVerdictSolidTitle => 'Một chu kỳ vững vàng';

  @override
  String boardVerdictSolidBody(int rating) {
    return 'Ban lãnh đạo hài lòng (đánh giá $rating%). Một vài đội tuyển có tầm vóc tương đương sẵn sàng đón bạn, nhưng không có áp lực phải ra đi.';
  }

  @override
  String get boardVerdictExpectedMoreTitle => 'Ban lãnh đạo kỳ vọng nhiều hơn';

  @override
  String boardVerdictExpectedMoreBody(int rating) {
    return 'Một chu kỳ đáng thất vọng (đánh giá $rating%). Bạn giữ được chiếc ghế, nhưng mọi lời mời đều là một bước đi xuống.';
  }

  @override
  String get boardVerdictPressureTitle => 'Bạn đang chịu áp lực thực sự';

  @override
  String boardVerdictPressureBody(int rating) {
    return 'Một chu kỳ kém (đánh giá $rating%). Bạn vẫn trụ lại được, nhưng nếu muốn làm lại từ đầu thì chỉ các quốc gia yếu hơn quan tâm.';
  }

  @override
  String get boardVerdictHeroTitle => 'Cả quốc gia đứng sau bạn';

  @override
  String boardVerdictHeroNote(String nation, int cycles) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles chu kỳ',
    );
    return ' $nation yêu mến bạn, một người hùng dân tộc sau $_temp0; chiếc ghế của bạn an toàn chừng nào bạn còn muốn giữ.';
  }

  @override
  String get boardVerdictTheNation => 'Quốc gia';

  @override
  String get boardVerdictBestQuiet => 'một chu kỳ yên ắng';

  @override
  String get boardVerdictBestCycle => 'chu kỳ này';

  @override
  String boardVerdictBestWorld(String placement) {
    return 'Giải vô địch thế giới: $placement';
  }

  @override
  String get finishThirdPlace => 'Hạng ba';

  @override
  String get finishFourthPlace => 'Hạng tư';

  @override
  String get finishDidNotQualify => 'Không vượt qua vòng loại';

  @override
  String get careerRepIconic => 'Huyền thoại';

  @override
  String get careerRepRenowned => 'Danh tiếng';

  @override
  String get careerRepEstablished => 'Có vị thế';

  @override
  String get careerRepRising => 'Đang lên';

  @override
  String get careerRepUnproven => 'Chưa kiểm chứng';

  @override
  String get hubOfferStepUp => 'Bước tiến';

  @override
  String get hubOfferLateral => 'Chuyển ngang';

  @override
  String get hubOfferRebuild => 'Xây dựng lại';

  @override
  String careerNationsCupWon(String league) {
    return 'Hạng $league · Nhà vô địch';
  }

  @override
  String careerNationsCupRunnerUp(String league) {
    return 'Hạng $league · Á quân';
  }

  @override
  String careerNationsCupSemi(String league) {
    return 'Hạng $league · Vào bán kết';
  }

  @override
  String careerNationsCupPlaced(String league, int position) {
    return 'Hạng $league · #$position';
  }

  @override
  String tourRunInto(String round) {
    return 'Sắp vào $round';
  }

  @override
  String get tourRunIntoThirdPlace => 'Sắp đá trận tranh hạng ba';

  @override
  String tourRunThrough(String round) {
    return 'Đi tiếp từ $round';
  }

  @override
  String tourRunOut(String round) {
    return 'Bị loại ở $round';
  }

  @override
  String get tourRunInGroup => 'Đang thi đấu vòng bảng';

  @override
  String get tourRunGroupOut => 'Bị loại ở vòng bảng';

  @override
  String resultsCycleTitle(int year, String nation) {
    return 'Chu kỳ $year · $nation';
  }

  @override
  String resultsCycleRecord(int played, int won, int drawn, int lost) {
    return '$played trận  ·  ${won}T ${drawn}H ${lost}B';
  }

  @override
  String resultsCycleFinish(String finish) {
    return 'Giải vô địch thế giới: $finish';
  }

  @override
  String get resultsCycleUnderway => 'Đang diễn ra';

  @override
  String yTurnedItRound0(String opponent) {
    return 'Thua $opponent hai bàn khi nghỉ giữa hiệp mà vẫn gỡ lại đủ cả. Đó mới là một tập thể.';
  }

  @override
  String yTurnedItRound1(String opponent) {
    return 'Bị dẫn hai bàn trước $opponent, đến cuối trận chẳng còn quan trọng. Không nhiều đội làm được vậy.';
  }

  @override
  String yTurnedItRound2(String opponent) {
    return 'Nghỉ giữa hiệp: thua $opponent hai bàn. Hết giờ: không còn nữa. Hiệp hai như một trận đấu khác.';
  }

  @override
  String yTurnedItRound3(String opponent) {
    return 'Từ thua hai bàn lội ngược dòng trước $opponent. Giờ nghỉ giữa hiệp nói gì thì tuần nào cũng nói thế.';
  }

  @override
  String yTurnedItRound4(String opponent) {
    return 'Được rồi, gỡ lại được trước $opponent. Giờ ai đó giải thích giúp bốn mươi lăm phút đầu đi.';
  }

  @override
  String yTurnedItRound5(String opponent) {
    return 'Thua $opponent hai bàn mà bắt chúng ta phải vui. Sửa hiệp một đi.';
  }

  @override
  String yThrewItAway0(String opponent) {
    return 'Hơn $opponent hai bàn khi nghỉ giữa hiệp rồi để vuột mất. Đội mạnh hơn cũng từng thế.';
  }

  @override
  String yThrewItAway1(String opponent) {
    return 'Hơn $opponent hai bàn mà để tuột. Chu kỳ còn dài, còn nhiều thời gian.';
  }

  @override
  String yThrewItAway2(String opponent) {
    return 'Nghỉ giữa hiệp: hơn $opponent hai bàn. Hết giờ: chẳng còn gì như thế.';
  }

  @override
  String yThrewItAway3(String opponent) {
    return 'Lợi thế hai bàn trước $opponent tan biến chỉ trong bốn mươi lăm phút.';
  }

  @override
  String yThrewItAway4(String opponent) {
    return 'Hơn hai bàn rồi để mất. Trước $opponent. Phải có người chịu trách nhiệm.';
  }

  @override
  String yThrewItAway5(String opponent) {
    return 'Hơn $opponent hai bàn mà vẫn làm được chuyện này. Lần nào cũng vậy.';
  }

  @override
  String get cycleBackupDone =>
      'Đã sao lưu sự nghiệp vào thư mục FNM trên điện thoại này. Gỡ cài đặt ứng dụng sẽ xóa bản sao lưu: để giữ một bản ở nơi khác, hãy dùng Sao lưu bản lưu này trong màn hình bản lưu.';

  @override
  String get cycleBackupFailed => 'Lần này không thể sao lưu sự nghiệp.';

  @override
  String pressMomentBigWinWarm1(String opponent) {
    return 'Một đêm đáng nhớ trước $opponent. HLV tự hào về tập thể này đến mức nào?';
  }

  @override
  String pressMomentBigWinWarm2(String opponent) {
    return '$opponent không thể theo kịp các cầu thủ. Đây có phải đội hình HLV luôn tin mình có?';
  }

  @override
  String pressMomentBigWinNeutral1(String opponent) {
    return 'Chiến thắng lớn trước $opponent. Điều gì tạo nên khác biệt tối nay?';
  }

  @override
  String pressMomentBigWinNeutral2(String opponent) {
    return '$opponent bị đánh bại, và rất thoải mái. HLV thắng trận này ở đâu?';
  }

  @override
  String pressMomentBigWinHostile1(String opponent) {
    return 'Một chiến thắng đẹp trước $opponent. Mới một đêm tốt thôi: sao ai đó phải tin nó kéo dài?';
  }

  @override
  String pressMomentBigWinHostile2(String opponent) {
    return 'Một kết quả tốt trước $opponent. Đó là kế hoạch của HLV, hay các cầu thủ tự tìm ra cách?';
  }

  @override
  String pressMomentBigLossWarm1(String opponent) {
    return 'Một đêm khó khăn trước $opponent. Sau trận như vậy HLV nói gì với các cầu thủ?';
  }

  @override
  String pressMomentBigLossWarm2(String opponent) {
    return 'Không ai ngờ điều đó trước $opponent. Chỉ là một đêm tệ thôi phải không?';
  }

  @override
  String pressMomentBigLossNeutral1(String opponent) {
    return 'Đó là một đêm đau đớn trước $opponent. Đã sai ở đâu?';
  }

  @override
  String pressMomentBigLossNeutral2(String opponent) {
    return '$opponent xé nát đội của HLV. Đội hình này có đủ tầm không?';
  }

  @override
  String pressMomentBigLossHostile1(String opponent) {
    return 'Đội của HLV chậm chân ở mọi khâu trước $opponent. Sao HLV để mọi chuyện tệ đến vậy?';
  }

  @override
  String pressMomentBigLossHostile2(String opponent) {
    return '$opponent ghi bàn như chốn không người. Kế hoạch của HLV tối nay đâu?';
  }

  @override
  String pressMomentCrisisWarm1(String opponent) {
    return 'Lại một trận vuột mất, lần này trước $opponent. HLV xoay chuyển chuỗi trận này thế nào?';
  }

  @override
  String pressMomentCrisisWarm2(String opponent) {
    return 'Kết quả cạn kiệt, và $opponent khiến mọi thứ tệ hơn. HLV vẫn tin vào tập thể này chứ?';
  }

  @override
  String pressMomentCrisisNeutral1(String opponent) {
    return 'Lại không thắng, lần này gặp $opponent, và ban lãnh đạo đang theo dõi. Chiếc ghế của HLV có an toàn không?';
  }

  @override
  String pressMomentCrisisNeutral2(String opponent) {
    return 'Sau $opponent, chuỗi trận đang kéo dài. HLV có lo cho tương lai của mình không?';
  }

  @override
  String pressMomentCrisisHostile1(String opponent) {
    return 'Giờ lại thêm $opponent. Người tiền nhiệm của HLV bị sa thải vì chuỗi trận như thế này. Sao HLV nên được ở lại?';
  }

  @override
  String pressMomentCrisisHostile2(String opponent) {
    return 'Sau thêm một đêm như $opponent, mọi chương trình phát thanh đều muốn HLV ra đi. HLV có từ chức nếu ban lãnh đạo yêu cầu không?';
  }

  @override
  String pressMomentJobVerdictWarm1(String opponent) {
    return 'HLV đặt chiếc ghế của mình lên bàn cân, và sau $opponent mọi chuyện không như ý. HLV đang thế nào?';
  }

  @override
  String pressMomentJobVerdictWarm2(String opponent) {
    return 'Ba trận đã xong, trận cuối gặp $opponent. Chính HLV đặt ra bài kiểm tra. HLV nghĩ sao về phán quyết?';
  }

  @override
  String pressMomentJobVerdictNeutral1(String opponent) {
    return 'HLV bảo hãy đánh giá qua ba trận tới. Sau $opponent, chúng tôi đã đánh giá. Chiếc ghế vẫn là của HLV chứ?';
  }

  @override
  String pressMomentJobVerdictNeutral2(String opponent) {
    return 'Ba trận, trận cuối gặp $opponent, và không như HLV hứa. HLV đã nói chuyện với ban lãnh đạo về tương lai chưa?';
  }

  @override
  String pressMomentJobVerdictHostile1(String opponent) {
    return 'HLV tự đặt ra bài kiểm tra và trượt trước $opponent. HLV có định từ chức không?';
  }

  @override
  String pressMomentJobVerdictHostile2(String opponent) {
    return 'Lời của chính HLV, không phải của chúng tôi: hãy đánh giá tôi qua ba trận tới. Sau $opponent, sao HLV vẫn còn ngồi đó?';
  }

  @override
  String get pressBeatWhoToBlameWarm1 =>
      'HLV muốn nhiều hơn từ họ. Có ai cụ thể không?';

  @override
  String get pressBeatWhoToBlameWarm2 =>
      'HLV đã đặt tiêu chuẩn cao. Ai phải đứng lên trước?';

  @override
  String get pressBeatWhoToBlameNeutral1 =>
      'HLV nói vài người phải tự nhìn lại mình. Ý HLV là ai?';

  @override
  String get pressBeatWhoToBlameNeutral2 =>
      'HLV bảo chưa đủ tốt. HLV đang nói về ai?';

  @override
  String get pressBeatWhoToBlameHostile1 =>
      'HLV cứ nói mập mờ. HLV sẽ nêu tên, hay mọi chuyện quay về chính mình?';

  @override
  String get pressBeatWhoToBlameHostile2 =>
      'Tuần nào cũng là lỗi của người khác. Lần này là của ai?';

  @override
  String get pressBeatIfYouDontWarm1 =>
      'Lời lẽ dũng cảm. Còn nếu trận tới không như ý thì sao?';

  @override
  String get pressBeatIfYouDontWarm2 =>
      'Cả nước sẽ nhắc HLV lời này. Nếu không thành thì sao?';

  @override
  String get pressBeatIfYouDontNeutral1 =>
      'Và nếu không thắng? Khi đó thì sao?';

  @override
  String get pressBeatIfYouDontNeutral2 =>
      'HLV đã nói ra rồi. Nếu HLV sai thì sao?';

  @override
  String get pressBeatIfYouDontHostile1 =>
      'Chúng tôi từng nghe những lời hứa trong căn phòng này. HLV nợ cổ động viên điều gì nếu lần này cũng đổ bể?';

  @override
  String get pressBeatIfYouDontHostile2 =>
      'Và khi nó không xảy ra, lời bào chữa sẽ là gì?';

  @override
  String get pressBeatFollowUpWarm1 =>
      'Thêm một câu nữa, nếu HLV còn sức. Tập thể này còn cần cải thiện điều gì?';

  @override
  String get pressBeatFollowUpWarm2 =>
      'Khi mọi thứ lắng xuống, HLV mang gì từ tối nay sang trận tiếp theo?';

  @override
  String get pressBeatFollowUpNeutral1 =>
      'Hãy đi sâu hơn một chút. Điều gì phải tốt lên trước trận tới?';

  @override
  String get pressBeatFollowUpNeutral2 =>
      'Gác tỷ số sang một bên: đội hình này đã đúng ý HLV chưa?';

  @override
  String get pressBeatFollowUpHostile1 =>
      'Nói nhiều mà chẳng nói được gì. Từ đây thực sự thay đổi điều gì?';

  @override
  String get pressBeatFollowUpHostile2 =>
      'Cổ động viên muốn một câu trả lời thẳng thắn. Đội này có đủ tốt không, có hay không?';

  @override
  String pressBeatStandoutWarm1(String player) {
    return '$player xuất sắc tối nay. Anh ấy còn đi được bao xa?';
  }

  @override
  String pressBeatStandoutWarm2(String player) {
    return '$player có mặt trên mọi tiêu đề tối nay. HLV có đoán trước điều đó không?';
  }

  @override
  String pressBeatStandoutNeutral1(String player) {
    return '$player nổi bật. HLV yêu cầu anh ấy làm gì tối nay?';
  }

  @override
  String pressBeatStandoutNeutral2(String player) {
    return '$player có phải là khác biệt tối nay không?';
  }

  @override
  String pressBeatStandoutHostile1(String player) {
    return 'Thiếu $player thì lại là chuyện khác. Đây là một đội, hay chỉ là một cầu thủ?';
  }

  @override
  String pressBeatStandoutHostile2(String player) {
    return '$player thật rực rỡ. Là công của HLV, hay của anh ấy?';
  }

  @override
  String pressBeatStrugglerWarm1(String player) {
    return '$player có một đêm khó khăn. Anh ấy có đang mang chấn thương không?';
  }

  @override
  String pressBeatStrugglerWarm2(String player) {
    return '$player không có đêm của mình. HLV có an ủi anh ấy không?';
  }

  @override
  String pressBeatStrugglerNeutral1(String player) {
    return '$player chật vật tối nay. Anh ấy có giữ được suất không?';
  }

  @override
  String pressBeatStrugglerNeutral2(String player) {
    return '$player trông chậm nhịp. HLV đánh giá trận đấu của anh ấy thế nào?';
  }

  @override
  String pressBeatStrugglerHostile1(String player) {
    return '$player lại chỉ là hành khách. Sao HLV cứ chọn anh ta?';
  }

  @override
  String pressBeatStrugglerHostile2(String player) {
    return 'Ai cũng thấy $player không ở trạng thái tốt. Trừ ghế dự bị chăng?';
  }

  @override
  String get pressThrowbackWinNextKeptWarm =>
      'HLV nói sẽ thắng trận tiếp theo, và đã thắng. Được đúng thế có thích không?';

  @override
  String get pressThrowbackWinNextKeptNeutral =>
      'HLV hứa thắng trận tiếp theo và đã làm được. Là tự tin, hay khoác lác?';

  @override
  String get pressThrowbackWinNextKeptHostile =>
      'HLV nói sẽ thắng trận tiếp theo, và đã thắng. May mắn, hay chúng tôi nên bắt đầu lắng nghe?';

  @override
  String get pressThrowbackWinNextBrokenWarm =>
      'HLV bảo sẽ thắng trận đó. Điều ấy đã không xảy ra. Đã sai ở đâu?';

  @override
  String get pressThrowbackWinNextBrokenNeutral =>
      'HLV nói sẽ thắng trận tiếp theo. HLV đã không thắng. Sao chúng tôi nên tin lời hứa kế tiếp?';

  @override
  String get pressThrowbackWinNextBrokenHostile =>
      'HLV nói sẽ thắng trận tiếp theo. HLV đã không thắng. Lời của HLV còn ý nghĩa gì trong căn phòng này?';

  @override
  String get pressThrowbackJobKeptWarm =>
      'HLV xin được đánh giá qua ba trận, và đã vượt qua. Được minh oan chưa?';

  @override
  String get pressThrowbackJobKeptNeutral =>
      'Hãy đánh giá tôi qua ba trận tới, HLV đã nói. Chúng tôi đã làm vậy, và kết quả đã đến. Bài kiểm tra ấy dạy HLV điều gì?';

  @override
  String get pressThrowbackJobKeptHostile =>
      'HLV tự cho mình ba trận và vượt qua. Bài kiểm tra có bao giờ khó đến vậy không?';

  @override
  String get pressThrowbackJobBrokenWarm =>
      'HLV xin được đánh giá qua ba trận. Mọi chuyện không như ý. HLV đã học được gì?';

  @override
  String get pressThrowbackJobBrokenNeutral =>
      'HLV nói hãy đánh giá tôi qua ba trận tới. Ba trận đã qua, cùng với sự cảm thông. Giờ thì sao?';

  @override
  String get pressThrowbackJobBrokenHostile =>
      'HLV tự đặt bài kiểm tra và trượt. Sao giờ ai phải tin lời HLV?';

  @override
  String pressThrowbackBackKeptWarm(String player) {
    return 'HLV đã ủng hộ $player khi người khác không làm. Anh ấy đã đáp lại. Một phần công thuộc về HLV chứ?';
  }

  @override
  String pressThrowbackBackKeptNeutral(String player) {
    return 'HLV ủng hộ $player. Anh ấy đã đáp lại. Là niềm tin, hay hiểu biết?';
  }

  @override
  String pressThrowbackBackKeptHostile(String player) {
    return 'HLV ủng hộ $player, và lần này đã có kết quả. Lần sau HLV có chắc chắn như vậy không?';
  }

  @override
  String pressThrowbackBackBrokenWarm(String player) {
    return 'HLV đứng về phía $player, và mọi chuyện không như mong đợi. HLV có còn tin anh ấy không?';
  }

  @override
  String pressThrowbackBackBrokenNeutral(String player) {
    return 'HLV ủng hộ $player. Anh ấy chưa đền đáp. Đó có phải là sai lầm?';
  }

  @override
  String pressThrowbackBackBrokenHostile(String player) {
    return 'Phán đoán hay lòng trung thành của HLV: thứ nào đã thất bại với $player?';
  }

  @override
  String pressThrowbackBlameKeptWarm(String player) {
    return 'HLV từng nghiêm khắc với $player, và các trận sau đó đã chứng minh HLV đúng. Có chút hài lòng nào không?';
  }

  @override
  String pressThrowbackBlameKeptNeutral(String player) {
    return 'HLV công khai chỉ trích $player, và anh ấy chưa đáp lại. Còn đường quay lại cho anh ấy không?';
  }

  @override
  String pressThrowbackBlameKeptHostile(String player) {
    return 'HLV đẩy $player ra làm bia đỡ đạn và anh ấy chưa hồi phục. HLV có làm anh ấy gục ngã không?';
  }

  @override
  String pressThrowbackBlameBrokenWarm(String player) {
    return 'HLV chỉ trích $player, và anh ấy đã đáp lại trên sân. Đó có phải là ý định từ đầu?';
  }

  @override
  String pressThrowbackBlameBrokenNeutral(String player) {
    return 'HLV đổ lỗi cho $player, và từ đó anh ấy là một trong những người xuất sắc nhất của HLV. HLV có nợ anh ấy lời xin lỗi không?';
  }

  @override
  String pressThrowbackBlameBrokenHostile(String player) {
    return 'HLV đổ tội cho $player, và anh ấy là cầu thủ xuất sắc nhất của HLV kể từ đó. HLV sẽ xin lỗi chứ?';
  }

  @override
  String get pressReplyCreditPlayers1 =>
      'Những cầu thủ này đã cống hiến hết mình cho tôi. Tôi không đổi một ai trong số họ.';

  @override
  String get pressReplyCreditPlayers2 =>
      'Không ai chăm chỉ hơn tập thể này. Tôi sẽ bảo vệ họ cả ngày.';

  @override
  String get pressReplyCreditPlayers3 =>
      'Các bạn sẽ không nghe được một lời xấu nào về cầu thủ của tôi từ chiếc ghế này.';

  @override
  String get pressReplyCreditPlayers4 =>
      'Công lao thuộc về các cầu thủ, không phải tôi. Hãy viết về họ.';

  @override
  String get pressReplyTakeResponsibility1 =>
      'Trận đó là do tôi. Tôi chọn đội hình và tôi sắp xếp họ.';

  @override
  String get pressReplyTakeResponsibility2 =>
      'Hãy đánh giá tôi, đừng đánh giá họ. Đây là đội của tôi và là trách nhiệm của tôi.';

  @override
  String get pressReplyTakeResponsibility3 =>
      'Nếu các bạn muốn tìm người để đổ lỗi, tôi đang ngồi ngay đây.';

  @override
  String get pressReplyTakeResponsibility4 =>
      'Trách nhiệm là của tôi. Đừng lôi các cầu thủ vào.';

  @override
  String get pressReplyDemandMore1 =>
      'Tôi muốn nhiều hơn. Vài người trong số họ biết rõ tôi muốn nói gì.';

  @override
  String get pressReplyDemandMore2 =>
      'Nỗ lực là chưa đủ ở đẳng cấp này. Tôi muốn nhiều hơn, và tôi đã nói với họ như vậy.';

  @override
  String get pressReplyDemandMore3 =>
      'Tôi kỳ vọng nhiều hơn từ từng người, bắt đầu từ ngày mai.';

  @override
  String get pressReplyDemandMore4 =>
      'Vài người trong số họ phải tự nhìn lại mình. Tôi không hài lòng.';

  @override
  String get pressReplyPromiseWinNext1 =>
      'Chúng tôi sẽ thắng trận tới. Các bạn cứ ghi lại.';

  @override
  String get pressReplyPromiseWinNext2 =>
      'Hãy nhớ lời tôi: chúng tôi thắng trận tới.';

  @override
  String get pressReplyPromiseWinNext3 =>
      'Trận tới, chúng tôi thắng. Tôi nói ở đây để các bạn có thể nhắc lại.';

  @override
  String get pressReplyPromiseWinNext4 =>
      'Tôi tin tưởng đội này. Chúng tôi thắng trận tới.';

  @override
  String get pressReplyJobOnTheLine1 =>
      'Hãy đánh giá tôi qua ba trận tới. Như vậy là công bằng.';

  @override
  String get pressReplyJobOnTheLine2 =>
      'Cho tôi ba trận. Nếu lúc đó chưa ổn, cứ đánh giá tôi.';

  @override
  String get pressReplyJobOnTheLine3 =>
      'Ba trận tới sẽ cho thấy tôi có phải người phù hợp. Hãy nhắc tôi điều đó.';

  @override
  String get pressReplyJobOnTheLine4 =>
      'Ba trận. Sau đó các bạn muốn viết gì về tôi cũng được.';

  @override
  String get pressReplyDeflect1 =>
      'Chúng tôi đi từng trận một. Không có gì để nói thêm.';

  @override
  String get pressReplyDeflect2 =>
      'Hôm nay tôi sẽ không tạo tiêu đề cho các bạn.';

  @override
  String get pressReplyDeflect3 =>
      'Trận tới. Đó là tất cả những gì tôi nghĩ đến.';

  @override
  String get pressReplyDeflect4 =>
      'Điều tôi nghĩ sẽ ở lại trong phòng thay đồ.';

  @override
  String get pressReplyTakeCredit1 => 'Tôi nói vì tôi tin, và tôi đã đúng.';

  @override
  String get pressReplyTakeCredit2 =>
      'Tôi đã đọc đúng tình hình. Đó là việc tôi ở đây để làm.';

  @override
  String get pressReplyTakeCredit3 =>
      'Cứ gọi đó là sự phán đoán. Tôi biết mình đang nói gì.';

  @override
  String get pressReplyTakeCredit4 =>
      'Tôi đưa ra quyết định và nó đã thành công. Tôi nhận lấy điều đó.';

  @override
  String get pressReplyStandByIt1 =>
      'Tôi nói điều tôi tin. Tôi giữ nguyên lời.';

  @override
  String get pressReplyStandByIt2 => 'Tôi không rút lại một lời nào.';

  @override
  String get pressReplyStandByIt3 =>
      'Câu trả lời vẫn như lúc đó. Tôi nói thật lòng và giờ vẫn vậy.';

  @override
  String get pressReplyStandByIt4 => 'Ngày mai tôi vẫn sẽ nói lại.';

  @override
  String get pressReplyAdmitMistake1 =>
      'Tôi đã sai ở điểm đó. Tôi nhận trách nhiệm.';

  @override
  String get pressReplyAdmitMistake2 =>
      'Công bằng mà nói, tôi đã đánh giá sai. Tôi sẽ rút kinh nghiệm.';

  @override
  String get pressReplyAdmitMistake3 =>
      'Tôi đã sai, và tôi có thể nói ra điều đó.';

  @override
  String get pressReplyAdmitMistake4 =>
      'Quyết định đó không hiệu quả, và nó là của tôi.';

  @override
  String pressReplyBackPlayer1(String player) {
    return '$player có sự ủng hộ trọn vẹn của tôi. Anh ấy sẽ lên phong độ.';
  }

  @override
  String pressReplyBackPlayer2(String player) {
    return 'Tôi tin vào $player, và anh ấy sẽ cho các bạn thấy lý do.';
  }

  @override
  String pressReplyBackPlayer3(String player) {
    return 'Các bạn sẽ không nghe tôi nói một lời xấu nào về $player. Anh ấy sẽ đáp lại.';
  }

  @override
  String pressReplyBackPlayer4(String player) {
    return '$player vẫn nằm trong kế hoạch của tôi. Hãy xem anh ấy làm gì tiếp theo.';
  }

  @override
  String pressReplyBlamePlayer1(String player) {
    return '$player đã làm chúng tôi thất vọng tối nay, và anh ấy biết điều đó.';
  }

  @override
  String pressReplyBlamePlayer2(String player) {
    return 'Tôi kỳ vọng nhiều hơn hẳn ở $player. Anh ấy phải trả lời cho điều đó.';
  }

  @override
  String pressReplyBlamePlayer3(String player) {
    return '$player không đạt trình độ. Tôi sẽ nói điều đó công khai.';
  }

  @override
  String pressReplyBlamePlayer4(String player) {
    return 'Màn trình diễn của $player chưa đủ tốt, và anh ấy sẽ nghe điều đó từ tôi.';
  }

  @override
  String get pressOnRecordWinNext =>
      'Ghi nhận công khai: bạn sẽ thắng trận tới.';

  @override
  String get pressOnRecordJob =>
      'Ghi nhận công khai: đánh giá bạn qua ba trận tới.';

  @override
  String pressOnRecordBack(String player) {
    return 'Ghi nhận công khai: ủng hộ $player.';
  }

  @override
  String pressOnRecordBlame(String player) {
    return 'Ghi nhận công khai: $player đã làm bạn thất vọng.';
  }

  @override
  String yStatementKept0(String nation) {
    return 'HLV nói thế, và nó đã xảy ra. $nation có một HLV nói là làm.';
  }

  @override
  String yStatementKept1(String nation) {
    return 'Nói thành lời rồi đi làm cho bằng được. Đó là người mà $nation cần.';
  }

  @override
  String yStatementKept2(String nation) {
    return '$nation: HLV đã đoán trước và nó thành sự thật. Công bằng thôi.';
  }

  @override
  String yStatementKept3(String nation) {
    return 'HLV nói công khai và giữ được lời. Một điểm cho HLV. $nation đi tiếp.';
  }

  @override
  String yStatementKept4(String nation) {
    return 'HLV đoán đúng một lần. $nation, đừng quen với chuyện đó.';
  }

  @override
  String yStatementKept5(String nation) {
    return 'Đồng hồ hỏng cũng đúng hai lần mỗi ngày. $nation gặp may lần này.';
  }

  @override
  String yStatementBroken0(String nation) {
    return 'HLV nói mà không thành. Vẫn đứng về phía HLV. $nation làm lại.';
  }

  @override
  String yStatementBroken1(String nation) {
    return '$nation: HLV hứa nhiều hơn những gì chúng ta nhận, nhưng tôi thà có một người dám tin vào chính mình.';
  }

  @override
  String yStatementBroken2(String nation) {
    return '$nation: HLV nói công khai mà không xảy ra. Mọi người sẽ nhớ.';
  }

  @override
  String yStatementBroken3(String nation) {
    return 'Lời lẽ to tát, chẳng có gì phía sau. $nation: lần sau nói ít thôi.';
  }

  @override
  String yStatementBroken4(String nation) {
    return 'HLV đứng đó nói với chúng ta. Rồi ra thế này. $nation xứng đáng hơn những lời nói suông.';
  }

  @override
  String yStatementBroken5(String nation) {
    return 'Lời của HLV giờ chẳng đáng một xu. Ghi lại đi, $nation.';
  }

  @override
  String get ncZoneNorth => 'Khu vực Bắc';

  @override
  String get ncZoneWest => 'Khu vực Tây';

  @override
  String get ncZoneEast => 'Khu vực Đông';

  @override
  String get ncZoneCentralSouthern => 'Khu vực Trung và Nam';

  @override
  String careerNationsCupZoneWon(String zone) {
    return '$zone · Nhà vô địch';
  }

  @override
  String careerNationsCupZoneRunnerUp(String zone) {
    return '$zone · Á quân';
  }

  @override
  String careerNationsCupZoneSemi(String zone) {
    return '$zone · Vào bán kết';
  }

  @override
  String careerNationsCupZoneRoundOf16(String zone) {
    return '$zone · Vòng 1/8';
  }

  @override
  String careerNationsCupZoneQuarter(String zone) {
    return '$zone · Vào tứ kết';
  }

  @override
  String careerNationsCupZonePlaced(String zone, int position) {
    return '$zone · #$position';
  }

  @override
  String get objectiveNcFinalsEight => 'Vào tứ kết';

  @override
  String get objectiveNcZoneWinGroup => 'Giành ngôi nhất bảng';

  @override
  String get finishNcFinalsEight => 'Tứ kết';

  @override
  String get finishNcBottomHalf => 'Nửa dưới của bảng';

  @override
  String get tourContTabZones => 'KHU VỰC';

  @override
  String get tourContTabFinalsEight => 'KNOCK-OUT';

  @override
  String get tourContFinalsEightSoon =>
      'Vòng đấu loại trực tiếp bắt đầu vào tháng 11 với vòng 1/8: cả 14 đội nhất bảng và 2 đội nhì bảng xuất sắc nhất.';

  @override
  String get tourContQuarterFinals => 'TỨ KẾT';

  @override
  String get tourContZoneAdvancement =>
      'Mọi đội nhất bảng đều vào vòng 1/8, cùng 2 đội nhì bảng xuất sắc nhất. Không đội nào xuống hạng.';

  @override
  String tourContZoneHeadingYours(String zone) {
    return '$zone ★';
  }

  @override
  String get compNorthAmericaNationsCup => 'Nations Cup Bắc Mỹ';

  @override
  String get compAfricanNationsCup => 'Nations Cup';

  @override
  String get objectiveNcWinItNorthAmerica => 'Vô địch Nations Cup Bắc Mỹ';

  @override
  String get objectiveNcWinItAfrica => 'Vô địch Nations Cup';

  @override
  String get objectiveNcReachFinalNorthAmerica =>
      'Vào chung kết Nations Cup Bắc Mỹ';

  @override
  String get objectiveNcReachFinalAfrica => 'Vào chung kết Nations Cup';

  @override
  String get finishNcChampionsNorthAmerica => 'Nhà vô địch Nations Cup Bắc Mỹ';

  @override
  String get finishNcChampionsAfrica => 'Nhà vô địch Nations Cup';

  @override
  String pressAimQualWarm1(String competition) {
    return 'Vòng loại $competition bắt đầu, và cả nước tin vào đội này. HLV nhắm tới điều gì?';
  }

  @override
  String pressAimQualWarm2(String competition) {
    return 'Một chiến dịch vòng loại $competition mới, tinh thần đang lên cao. Đội này có thể đi xa đến đâu?';
  }

  @override
  String pressAimQualNeutral1(String competition) {
    return 'Vòng loại $competition khởi tranh. Mục tiêu của chiến dịch này là gì?';
  }

  @override
  String pressAimQualNeutral2(String competition) {
    return 'Vòng loại $competition đã đến. HLV thấy đội này sẽ về đích ở đâu?';
  }

  @override
  String pressAimQualHostile1(String competition) {
    return 'Vòng loại $competition bắt đầu, và nhiều người nghi ngờ HLV sẽ đến được đó. HLV nói gì với họ?';
  }

  @override
  String pressAimQualHostile2(String competition) {
    return 'Lại một chiến dịch vòng loại $competition. Sao ai đó phải tin lần này sẽ khác?';
  }

  @override
  String pressAimFinalsWarm1(String competition) {
    return '$competition đã đến và cả nước đứng sau HLV. HLV có thể đi xa đến đâu?';
  }

  @override
  String pressAimFinalsWarm2(String competition) {
    return 'HLV đang ở $competition và cổ động viên đang mơ ước. Mục tiêu là gì?';
  }

  @override
  String pressAimFinalsNeutral1(String competition) {
    return '$competition bắt đầu trong tuần này. Thế nào được coi là thành công?';
  }

  @override
  String pressAimFinalsNeutral2(String competition) {
    return 'Trận đầu tiên của HLV tại $competition đã gần kề. Hãy đặt cho chúng tôi một mục tiêu.';
  }

  @override
  String pressAimFinalsHostile1(String competition) {
    return '$competition đã đến và không ai kỳ vọng nhiều. HLV thực sự hy vọng điều gì?';
  }

  @override
  String pressAimFinalsHostile2(String competition) {
    return 'HLV đang ở $competition, nhưng những nghi ngờ vẫn chưa tan. Mục tiêu của HLV là gì?';
  }

  @override
  String pressBeatRivalWarm1(String rival) {
    return '$rival cùng bảng với đội của HLV. Họ có làm HLV lo không?';
  }

  @override
  String pressBeatRivalWarm2(String rival) {
    return 'Lễ bốc thăm xếp $rival vào đường đi của HLV. HLV nhìn nhận trận đó thế nào?';
  }

  @override
  String pressBeatRivalNeutral1(String rival) {
    return '$rival trông là đội mạnh nhất bảng này. Họ có phải ứng viên số một?';
  }

  @override
  String pressBeatRivalNeutral2(String rival) {
    return 'HLV nghĩ gì về $rival?';
  }

  @override
  String pressBeatRivalHostile1(String rival) {
    return '$rival cùng bảng với đội của HLV. Nói thật, HLV có đối phó nổi họ không?';
  }

  @override
  String pressBeatRivalHostile2(String rival) {
    return 'Đa số kỳ vọng $rival thắng đội của HLV. Họ sai chăng?';
  }

  @override
  String pressBeatKeyPlayerWarm1(String player) {
    return '$player đang có phong độ cao. Đây có phải thời khắc của anh ấy?';
  }

  @override
  String pressBeatKeyPlayerWarm2(String player) {
    return '$player có mặt trên mọi tiêu đề. Anh ấy có thể gánh đội này không?';
  }

  @override
  String pressBeatKeyPlayerNeutral1(String player) {
    return 'Chiến dịch này phụ thuộc vào $player đến mức nào?';
  }

  @override
  String pressBeatKeyPlayerNeutral2(String player) {
    return '$player đã sẵn sàng dẫn dắt đội này chưa?';
  }

  @override
  String pressBeatKeyPlayerHostile1(String player) {
    return 'Nếu $player không ở phong độ tốt nhất, đội này còn gì?';
  }

  @override
  String pressBeatKeyPlayerHostile2(String player) {
    return '$player gánh quá nhiều trên vai. Có quá sức không?';
  }

  @override
  String get pressReplyAimHigher1 =>
      'Chúng tôi sẽ đi xa hơn mọi người kỳ vọng.';

  @override
  String get pressReplyAimHigher2 =>
      'Tôi muốn nhiều hơn những gì liên đoàn yêu cầu, và tôi sẽ nói công khai.';

  @override
  String get pressReplyMatchBrief1 =>
      'Chúng tôi biết mục tiêu và sẽ đạt được nó.';

  @override
  String get pressReplyMatchBrief2 =>
      'Liên đoàn đã đặt ra mục tiêu. Chúng tôi sẽ hoàn thành.';

  @override
  String get pressReplyPlayDown1 => 'Hãy đi từng trận một.';

  @override
  String get pressReplyPlayDown2 =>
      'Không hứa hẹn lớn lao. Chúng ta sẽ xem mình đang ở đâu.';

  @override
  String get pressReplyPromiseQualify1 =>
      'Chúng tôi sẽ giành vé. Các bạn cứ ghi lại.';

  @override
  String get pressReplyPromiseQualify2 => 'Đội này sẽ có mặt ở vòng chung kết.';

  @override
  String get pressReplyFearNobody1 => 'Chúng tôi không sợ ai cả.';

  @override
  String get pressReplyFearNobody2 => 'Họ cũng phải đá với chúng tôi.';

  @override
  String get pressReplyRespectRival1 =>
      'Họ là ứng viên hàng đầu, và chúng tôi tôn trọng họ.';

  @override
  String get pressReplyRespectRival2 =>
      'Một đội rất mạnh. Chúng tôi sẽ cần phát huy hết sức.';

  @override
  String get pressReplyTeamFirst1 =>
      'Đây là chuyện của cả đội, không phải một cầu thủ.';

  @override
  String get pressReplyTeamFirst2 => 'Không ai chiến thắng một mình.';

  @override
  String pressOnRecordTarget(String aim) {
    return 'Ghi nhận công khai: $aim.';
  }

  @override
  String get pressOnRecordPlayDown => 'Ghi nhận công khai: không hứa hẹn gì.';

  @override
  String get pressThrowbackTargetKeptWarm =>
      'HLV đặt mục tiêu trước chiến dịch và đã đạt được. Đây có phải khoảnh khắc đáng tự hào nhất của HLV?';

  @override
  String get pressThrowbackTargetKeptNeutral =>
      'HLV nói sẽ đạt được gì và đã làm được. Có lúc nào HLV nghi ngờ không?';

  @override
  String get pressThrowbackTargetKeptHostile =>
      'HLV đạt được mục tiêu đã đặt ra. May mắn, hay đó thực sự là kế hoạch?';

  @override
  String get pressThrowbackTargetBrokenWarm =>
      'HLV đặt mục tiêu và không đạt được. Đã sai ở đâu?';

  @override
  String get pressThrowbackTargetBrokenNeutral =>
      'HLV hứa nhiều hơn những gì đội này mang lại. HLV có hối hận vì đã nói không?';

  @override
  String get pressThrowbackTargetBrokenHostile =>
      'HLV nói lớn trước chiến dịch rồi hụt hơi. Sao giờ chúng tôi phải tin HLV?';

  @override
  String hubEventPressPreviewSub(String competition) {
    return 'Báo chí muốn nghe mục tiêu của bạn tại $competition';
  }

  @override
  String deptLevelCost(int level, String amount) {
    return 'Cấp $level · $amount';
  }

  @override
  String get formOnFire => 'Bùng nổ';

  @override
  String get formGood => 'Phong độ cao';

  @override
  String get formSteady => 'Ổn định';

  @override
  String get formPoor => 'Phong độ thấp';

  @override
  String get formCold => 'Lạnh như băng';

  @override
  String get playerFormTitle => 'PHONG ĐỘ VÀ THỂ LỰC';

  @override
  String playerFormAverage(String rating) {
    return 'Trung bình $rating trong các trận gần đây';
  }

  @override
  String get playerFormNoGames => 'Chưa đủ trận gần đây để đánh giá';

  @override
  String playerFormNextMatch(String delta) {
    return '$delta vào điểm số của anh ấy trận tới';
  }

  @override
  String get playerFormNoEffect => 'Không thay đổi điểm số của anh ấy trận tới';

  @override
  String get sideGroupHome => 'Trang chủ';

  @override
  String get sideGroupTeam => 'Đội';

  @override
  String get sideGroupCompetitions => 'Giải đấu';

  @override
  String get sideGroupFederation => 'Liên đoàn';

  @override
  String get sideGroupHistory => 'Lịch sử';

  @override
  String get sideInbox => 'Hộp thư';

  @override
  String get sideSquad => 'Đội hình';

  @override
  String get sideTactics => 'Chiến thuật';

  @override
  String get sideMainMenu => 'Menu chính';

  @override
  String get sideCallUps => 'Triệu tập';

  @override
  String get sideTournaments => 'Giải đấu';

  @override
  String get sideRanking => 'Xếp hạng';

  @override
  String get sideResults => 'Kết quả';

  @override
  String get sideFinances => 'Tài chính';

  @override
  String get sideBoard => 'Ban lãnh đạo';

  @override
  String get sideManager => 'HLV và ban huấn luyện';

  @override
  String get sideRecords => 'Kỷ lục';

  @override
  String get sideLegends => 'Huyền thoại';

  @override
  String get sideHeadToHead => 'Đối đầu';

  @override
  String get sideAchievements => 'Thành tựu';

  @override
  String get sideCareer => 'Sự nghiệp';

  @override
  String get topBarNext => 'Tiếp theo';

  @override
  String get topBarDrawPending => 'Sắp bốc thăm';

  @override
  String get paneFullProfile => 'Hồ sơ đầy đủ';

  @override
  String get panePickPlayer => 'Chọn một cầu thủ để xem thẻ của anh ấy tại đây';

  @override
  String get inboxPickMessage => 'Chọn một tin nhắn để đọc tại đây';

  @override
  String get inboxFilterAll => 'Tất cả';

  @override
  String get panelViewAll => 'Xem tất cả';

  @override
  String get gridViewOverview => 'Tổng quan';

  @override
  String get gridColCondition => 'Thể trạng';

  @override
  String get gridColStatus => 'Tình trạng';

  @override
  String get gridColRank => 'Hạng';

  @override
  String get gridColMove => 'Biến động';

  @override
  String get gridColNation => 'Quốc gia';

  @override
  String get gridColRegion => 'Khu vực';

  @override
  String get gridColPoints => 'Điểm';

  @override
  String get panePickNation => 'Chọn một quốc gia để xem thành tích tại đây';

  @override
  String get resultsCyclesTitle => 'Các chu kỳ';

  @override
  String get tourDrawStart => 'Bắt đầu bốc thăm';

  @override
  String get tourDrawViewGroups => 'Xem các bảng';

  @override
  String get gridColCeiling => 'Trần';

  @override
  String get gridColYearGain => 'Tăng';

  @override
  String get gridColMarkedAt => 'Khi đánh dấu';

  @override
  String get budgetSetupTitle => 'Thiết lập ngân sách';

  @override
  String get budgetEffectsTitle => 'Ngân sách này mua được gì';

  @override
  String get naturalisationTitle => 'Nhập tịch';

  @override
  String get yTrending => 'Xu hướng';

  @override
  String get yVoices => 'Tiếng nói';

  @override
  String get yConversation => 'Cuộc trò chuyện';

  @override
  String get allTimeRecordsTitle => 'Kỷ lục thế giới mọi thời đại';

  @override
  String get h2hMeetingsTitle => 'Mọi lần gặp nhau';

  @override
  String get h2hPickOpponent =>
      'Chọn một đối thủ để xem mọi lần gặp nhau tại đây';

  @override
  String get savesTitle => 'Bản lưu';

  @override
  String get gridColPlayer => 'Cầu thủ';

  @override
  String get gridColPos => 'VT';

  @override
  String get gridColActive => 'Còn thi đấu';

  @override
  String get gridColMotm => 'HNT';

  @override
  String get gridColAvg => 'TB';

  @override
  String get gridColOpponent => 'Đối thủ';

  @override
  String get gridColStarts => 'Đá chính';

  @override
  String get gridColTournaments => 'Giải đấu';

  @override
  String get gridColDate => 'Ngày';

  @override
  String get gridColLastPlayed => 'Chơi gần nhất';

  @override
  String get gridColManager => 'HLV';

  @override
  String nationsShownCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count quốc gia',
      one: '1 quốc gia',
    );
    return '$_temp0';
  }

  @override
  String get nationsSortedByRank => 'Xếp theo hạng thế giới';

  @override
  String get nationsStrength => 'Sức mạnh';

  @override
  String nationsStrengthOf(int tier) {
    return '$tier trên 5';
  }

  @override
  String get nationsSquadOverall => 'Chỉ số tổng đội hình';

  @override
  String get nationsOpeningBudget => 'Ngân sách ban đầu';

  @override
  String get nationsStarPlayer => 'Ngôi sao';

  @override
  String nationsStarTile(String position, int rating) {
    return 'Sao $position $rating';
  }

  @override
  String nationsStarAge(int age) {
    return '$age tuổi';
  }

  @override
  String get nationsBoardExpects => 'Ban lãnh đạo kỳ vọng';

  @override
  String nationsManage(String nation) {
    return 'Dẫn dắt $nation';
  }

  @override
  String get nationsManagerNext => 'Bạn đặt tên cho HLV ở bước tiếp theo';

  @override
  String get playerPageTitle => 'Cầu thủ';

  @override
  String get nationPageTitle => 'Quốc gia';

  @override
  String get friendliesYourGames => 'Các trận giao hữu của bạn';

  @override
  String hubEventInjuryCover(String player) {
    return 'Thay thế $player bị chấn thương';
  }

  @override
  String hubEventInjuryCoverSub(int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: 'Vắng $matches trận',
      one: 'Vắng trận tiếp theo',
    );
    return '$_temp0. Hãy triệu tập người khác, hoặc tiếp tục mà không có anh ấy.';
  }

  @override
  String get injuryCoverTitle => 'THAY THẾ';

  @override
  String injuryCoverBanner(String player) {
    return '$player bị chấn thương. Hãy triệu tập bất kỳ ai ngoài danh sách, ở bất kỳ vị trí nào, hoặc giữ anh ấy và tiếp tục.';
  }

  @override
  String injuryCoverConfirm(String player) {
    return 'Triệu tập $player';
  }

  @override
  String injuryCoverKeep(String player) {
    return 'Giữ $player và tiếp tục';
  }

  @override
  String get injuryCoverPick => 'Chọn người thay thế';

  @override
  String get injuryCoverNone =>
      'Không ai ngoài danh sách đủ thể trạng để gia nhập.';

  @override
  String get nationNowRanking => 'Xếp hạng thế giới';

  @override
  String get nationNowForm => 'Phong độ';

  @override
  String get nationNowNoForm => 'Chưa đá trận nào';

  @override
  String get nationNowNext => 'Trận tiếp theo';

  @override
  String get nationNowNoNext => 'Chưa có lịch';

  @override
  String get nationNowSquad => 'Đội hình';

  @override
  String get nationNowAgainstYou => 'Gặp bạn';

  @override
  String nationNowRecord(int w, int d, int l) {
    return '${w}T ${d}H ${l}B';
  }

  @override
  String get nationNowLastMeeting => 'Lần gặp gần nhất';

  @override
  String nationNowOverall(int value) {
    return 'Chỉ số tổng $value';
  }

  @override
  String get hubUpcoming => 'SẮP TỚI';

  @override
  String get hubFullSchedule => 'Lịch thi đấu đầy đủ';

  @override
  String get scheduleTitle => 'Lịch thi đấu';

  @override
  String get scheduleToday => 'Hôm nay';

  @override
  String get scheduleKnockoutPending =>
      'Vòng đấu loại trực tiếp, nếu bạn đi tiếp';

  @override
  String get scheduleNextRoundPending => 'Vòng tiếp theo';

  @override
  String scheduleFromDate(String date) {
    return 'Từ $date';
  }

  @override
  String get scheduleHomeShort => 'N';

  @override
  String get scheduleAwayShort => 'K';

  @override
  String get tacticsNoPresetsInMatch =>
      'Chưa có chiến thuật nào được lưu. Hãy lưu một chiến thuật từ màn hình Chiến thuật trước trận đấu.';

  @override
  String get homeCampaigns => 'Chiến dịch';

  @override
  String get homeContinueCampaign => 'TIẾP TỤC CHIẾN DỊCH';

  @override
  String homeCampaignCycle(String date, int cycle, int total) {
    return '$date · Chu kỳ $cycle trên $total';
  }

  @override
  String get campaignsTitle => 'Chiến dịch';

  @override
  String get campaignTransplantTitle => 'Cuộc cấy ghép';

  @override
  String get campaignTransplantTwist =>
      'Tám ngôi sao hàng đầu của Ý chuyển sang khoác áo San Marino';

  @override
  String get campaignTransplantGoal => 'Giành vé dự Giải vô địch châu Âu';

  @override
  String get campaignGrudgeTitle => 'Mối thù';

  @override
  String get campaignGrudgeTwist => 'Gruzia và Albania, rơi vào cùng một bảng';

  @override
  String get campaignGrudgeGoal => 'Xếp trên Albania ở vòng loại';

  @override
  String get campaignTransplantIntro =>
      'San Marino chưa từng có một chiến dịch vòng loại đáng gọi tên. Rồi tám ngôi sao hàng đầu của Ý nhận hộ chiếu và bước vào. Bạn có một chu kỳ để biến một điều kỳ lạ thành một đội bóng thực sự.';

  @override
  String get campaignGrudgeIntro =>
      'Gruzia và Albania bị bốc vào cùng một bảng vòng loại, và không bên nào tha thứ cho một trận thua. Hãy xếp trên Albania, rồi xem bạn có thể đi xa đến đâu.';

  @override
  String get campaignStars1Transplant => 'Giành vé';

  @override
  String get campaignStars2Transplant => 'Vào vòng đấu loại trực tiếp';

  @override
  String get campaignStars3Transplant => 'Vô địch Giải vô địch châu Âu';

  @override
  String get campaignStars1Grudge => 'Xếp trên Albania';

  @override
  String get campaignStars2Grudge => 'Và giành vé';

  @override
  String get campaignStars3Grudge => 'Và thắng họ hai lần';

  @override
  String get campaignFree => 'Miễn phí';

  @override
  String get campaignStart => 'Bắt đầu';

  @override
  String get campaignPartOfUnlimited => 'Thuộc gói Unlimited';

  @override
  String get campaignResume => 'Tiếp tục';

  @override
  String get campaignAbandon => 'Bỏ cuộc';

  @override
  String get campaignAbandonConfirm =>
      'Bỏ lượt chơi này? Tiến trình sẽ mất; con dấu của bạn vẫn còn.';

  @override
  String get campaignMoveToSaves => 'Chuyển vào bản lưu';

  @override
  String get campaignCannotContinue =>
      'Thế giới của chiến dịch này đã lệch quá xa thực tế nên không thể tiếp tục thành một sự nghiệp.';

  @override
  String get campaignMoveSlotsFull =>
      'Các ô lưu của bạn đã đầy. Hãy giải phóng một ô trước.';

  @override
  String get campaignStampConquered => 'Chinh phục';

  @override
  String get campaignStampFailed => 'Thất bại';

  @override
  String get campaignDifficultyHard => 'Khó';

  @override
  String get campaignDifficultyMedium => 'Trung bình';

  @override
  String get campaignGoalLabel => 'Mục tiêu';

  @override
  String get campaignStarsLabel => 'Sao';

  @override
  String get campaignRunInProgress =>
      'Chiến dịch này đã có một lượt chơi đang diễn ra.';

  @override
  String get campaignVerdictWon => 'Chinh phục';

  @override
  String get campaignVerdictLost => 'Lần này chưa được';

  @override
  String get campaignVerdictContinue => 'Tiếp tục';

  @override
  String campaignProgressQualifying(String position) {
    return 'Vòng loại: $position';
  }

  @override
  String campaignProgressRival(String rival, String position) {
    return '$rival: $position';
  }

  @override
  String campaignProgressFinals(String stage) {
    return 'Vòng chung kết: $stage';
  }

  @override
  String get campaignRunInNumbers => 'Hành trình qua các con số';

  @override
  String campaignRunMeetings(int won, int played) {
    return 'Số lần gặp thắng: $won trên $played';
  }

  @override
  String campaignPlace(String which, int n) {
    String _temp0 = intl.Intl.selectLogic(
      which,
      {
        'first': 'hạng 1',
        'second': 'hạng 2',
        'third': 'hạng 3',
        'other': 'hạng $n',
      },
    );
    return '$_temp0';
  }

  @override
  String get campaignGuineasTitle => 'Guinea xuất sắc nhất';

  @override
  String get campaignGuineasTwist =>
      'Guinea Xích Đạo, đội xếp thấp nhất trong các Guinea của châu Phi, trong hai chu kỳ';

  @override
  String get campaignGuineasGoal => 'Thắng Guinea và Guinea-Bissau';

  @override
  String get campaignGuineasIntro =>
      'Ba quốc gia châu Phi mang tên Guinea, và Guinea Xích Đạo xếp thấp nhất trong số đó. Bạn có hai chu kỳ để thắng Guinea và Guinea-Bissau ít nhất mỗi đội một lần, rồi xem bạn có thể đi xa đến đâu ở Giải vô địch châu Phi. Papua New Guinea, Guinea thứ tư, đã được xếp một trận giao hữu.';

  @override
  String get campaignStars1Guineas => 'Thắng Guinea và Guinea-Bissau';

  @override
  String get campaignStars2Guineas => 'Và giành vé dự Giải vô địch châu Phi';

  @override
  String get campaignStars3Guineas => 'Và vào tứ kết Giải vô địch châu Phi';

  @override
  String get campaignYoungFinnsTitle => 'Phần Lan trẻ';

  @override
  String get campaignYoungFinnsTwist =>
      'Thế hệ vàng tuổi teen của Phần Lan, trong ba chu kỳ';

  @override
  String get campaignYoungFinnsGoal =>
      'Giành vé dự một kỳ Giải vô địch thế giới';

  @override
  String get campaignYoungFinnsIntro =>
      'Các cầu thủ lớn tuổi của Phần Lan đã lùi sang một bên và một thế hệ vàng thế chỗ họ: mọi cầu thủ bạn có thể chọn đều từ 18 tuổi trở xuống. Hiện còn non nớt, nhưng họ có tài năng để trở thành một trong những đội mạnh nhất thế giới, như thế hệ trẻ của Na Uy đã làm được. Bạn có ba chu kỳ để đưa họ đến một kỳ Giải vô địch thế giới, rồi giành Giải vô địch châu Âu và Giải vô địch thế giới.';

  @override
  String get campaignStars1YoungFinns =>
      'Giành vé dự một kỳ Giải vô địch thế giới';

  @override
  String get campaignStars2YoungFinns => 'Vô địch Giải vô địch châu Âu';

  @override
  String get campaignStars3YoungFinns => 'Vô địch Giải vô địch thế giới';

  @override
  String get campaignPro => 'Pro';

  @override
  String campaignProgressCup(String cup, String year, String status) {
    return '$cup $year: $status';
  }

  @override
  String get campaignCupNotQualified => 'Không vượt qua vòng loại';

  @override
  String get campaignCupOpen => 'Chưa xác định';
}
