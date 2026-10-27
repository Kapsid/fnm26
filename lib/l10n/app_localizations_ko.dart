// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get matchPreviewTitle => '경기 프리뷰';

  @override
  String get matchKickOff => '킥오프';

  @override
  String get matchTactics => '전술';

  @override
  String get matchYourXi => '선발 11인';

  @override
  String get matchHeadToHead => '상대 전적';

  @override
  String matchCouldNotLoad(String error) {
    return '경기를 불러올 수 없습니다.\n$error';
  }

  @override
  String get matchNoUpcoming => '예정된 경기가 없습니다.';

  @override
  String get matchUnknownNation => '알 수 없음';

  @override
  String get matchH2hFirstMeeting => '역대 첫 맞대결';

  @override
  String get matchH2hYouLead => '상대 전적 우위';

  @override
  String matchH2hOppEdge(String opponent) {
    return '$opponent 우위';
  }

  @override
  String get matchH2hEven => '상대 전적 팽팽';

  @override
  String matchH2hMet(int count) {
    return '$count회 맞대결';
  }

  @override
  String get matchH2hWon => '승';

  @override
  String get matchH2hDrawn => '무';

  @override
  String get matchH2hLost => '패';

  @override
  String get matchDossierTitle => '스카우팅 리포트';

  @override
  String get matchDossierForm => '최근 폼';

  @override
  String get matchDossierNoGames => '최근 경기 없음';

  @override
  String get matchDossierKeyMen => '핵심 선수';

  @override
  String get matchDossierHowTheyPlay => '경기 스타일';

  @override
  String matchScoutFormation1(String formation) {
    return '주로 $formation 포메이션으로 나섭니다.';
  }

  @override
  String matchScoutFormation2(String formation) {
    return '기본 대형은 $formation입니다.';
  }

  @override
  String matchScoutFormation3(String formation) {
    return '대개 $formation 형태로 경기를 준비합니다.';
  }

  @override
  String get matchScoutStrengthPressing => '높은 위치에서 압박하며 공을 적극적으로 빼앗습니다.';

  @override
  String get matchScoutStrengthDirect => '직선적인 축구로 공을 빠르게 전방에 보냅니다.';

  @override
  String get matchScoutStrengthPossession => '공을 잘 지키며 인내심 있게 빌드업합니다.';

  @override
  String get matchScoutStrengthCounter => '물러서 있다가 빠른 역습을 노립니다.';

  @override
  String get matchScoutStrengthDeepDefence => '깊게 내려앉아 수비해 뚫기가 어렵습니다.';

  @override
  String get matchScoutStrengthWide => '경기장을 넓게 쓰며 측면으로 공격합니다.';

  @override
  String get matchScoutStrengthAttacking => '상대를 몰아붙이는 공격적인 경기를 좋아합니다.';

  @override
  String get matchScoutStrengthQuickForwards => '공격수들이 빠르고 뒷공간 침투를 즐깁니다.';

  @override
  String get matchScoutStrengthPassingMidfield => '미드필드의 패스 능력이 좋습니다.';

  @override
  String get matchScoutStrengthHardRunning => '미드필드가 90분 내내 뛸 체력을 갖췄습니다.';

  @override
  String get matchScoutStrengthSetPieces => '세트피스 상황에서 위협적입니다.';

  @override
  String get matchScoutStrengthQuickDefence => '수비 라인이 빨라 뒷공간을 노리기 어렵습니다.';

  @override
  String get matchScoutStrengthNone => '특별히 눈에 띄는 강점은 없습니다.';

  @override
  String get matchScoutWeakSpaceBehind => '라인이 높아 뒷공간으로 넘기는 롱패스가 통할 수 있습니다.';

  @override
  String get matchScoutWeakPressedBuildUp => '느린 빌드업은 강한 전방 압박에 흔들릴 수 있습니다.';

  @override
  String get matchScoutWeakDeepBlock => '인내심을 가지세요. 이런 밀집 수비는 공략할 수 있습니다.';

  @override
  String get matchScoutWeakLongBall => '라인을 내리면 상대의 롱볼이 갈 곳을 잃습니다.';

  @override
  String get matchScoutWeakSlowDefence => '수비수들의 발이 느리니 뒷공간으로 침투하세요.';

  @override
  String get matchScoutWeakAerial => '세트피스 수비가 불안해 보입니다.';

  @override
  String get matchScoutWeakPoorPassing => '미드필드가 압박을 받으면 패스로 풀어 나오지 못합니다.';

  @override
  String get matchScoutWeakTiringMidfield => '미드필드가 압박을 이어갈 체력이 부족합니다.';

  @override
  String get matchScoutWeakBluntAttack => '공격수들의 스피드가 부족합니다.';

  @override
  String get matchScoutApproachTakeTheGame => '우리를 상대로는 주도권을 잡으려 할 것입니다.';

  @override
  String get matchScoutApproachEven => '우리를 상대로는 팽팽한 접전이 예상됩니다.';

  @override
  String get matchScoutApproachSitDeep => '우리를 상대로는 신중하게 나서며 역습을 노릴 것입니다.';

  @override
  String get matchScoutLeaningAttacking => '멀리서 보기에는 공격적인 팀 같습니다.';

  @override
  String get matchScoutLeaningCautious => '멀리서 보기에는 신중한 팀 같습니다.';

  @override
  String get matchScoutLeaningUnclear => '멀리서는 어떤 스타일인지 판단하기 어렵습니다.';

  @override
  String get matchScoutHireHint => '수석 스카우트를 고용하면 상대의 경기 스타일을 알 수 있습니다.';

  @override
  String matchCouldNotContinue(String error) {
    return '계속할 수 없습니다: $error';
  }

  @override
  String get matchSkipToFullTime => '경기 종료로 건너뛰기';

  @override
  String get matchStatShots => '슈팅';

  @override
  String get matchStatGoals => '골';

  @override
  String get matchStatYellowCards => '경고';

  @override
  String get matchStatRedCards => '퇴장';

  @override
  String get matchMomentum => '흐름';

  @override
  String get matchSwingAtk => '공격';

  @override
  String get matchSwingDef => '수비';

  @override
  String ceremonyWorldCupYear(int year) {
    return '$year 세계 선수권';
  }

  @override
  String get ceremonyFinalsAreHere => '본선의 막이 오릅니다';

  @override
  String ceremonyHostedBy(String hosts) {
    return '개최국  $hosts';
  }

  @override
  String get ceremonyHostTbc => '개최국 미정';

  @override
  String get matchHalfTime => '하프타임';

  @override
  String get matchContinue => '계속';

  @override
  String get matchContinuing => '진행 중…';

  @override
  String matchTacticsWithSubs(int used, int max) {
    return '전술 · 교체 $used/$max';
  }

  @override
  String matchTiredCount(int count) {
    return '지침 ×$count';
  }

  @override
  String get matchTacticsLabel => '전술';

  @override
  String get teamOverallOverTime => '연도별 종합 능력치';

  @override
  String get teamOverall => '종합';

  @override
  String get teamTalkHeading => '팀 토크';

  @override
  String get teamTalkPrompt => '후반전의 분위기를 정하세요.';

  @override
  String get teamTalkCalmLabel => '침착하게';

  @override
  String get teamTalkCalmBlurb => '팀을 안정시킵니다. 전반적으로 소폭 상승.';

  @override
  String get teamTalkEncourageLabel => '격려';

  @override
  String get teamTalkEncourageBlurb => '앞으로 나가 승리를 노립니다.';

  @override
  String get teamTalkDemandMoreLabel => '더 요구하기';

  @override
  String get teamTalkDemandMoreBlurb => '모든 것을 쏟아붓습니다. 총공격.';

  @override
  String get teamTalkPraiseLabel => '단단하게';

  @override
  String get teamTalkPraiseBlurb => '간격을 좁히고 지금의 결과를 지킵니다.';

  @override
  String get teamTalkBelieveLabel => '자신감';

  @override
  String get teamTalkBelieveBlurb => '스스로를 믿으세요. 공수 양면에서 상승.';

  @override
  String get teamTalkFocusLabel => '집중력 유지';

  @override
  String get teamTalkFocusBlurb => '완전한 집중. 경기를 걸어 잠급니다.';

  @override
  String get teamTalkUrgencyLabel => '절박함';

  @override
  String get teamTalkUrgencyBlurb => '지금 당장 따라잡습니다. 총력전이지만 빈틈이 생깁니다.';

  @override
  String get teamTalkReassureLabel => '부담 없이';

  @override
  String get teamTalkReassureBlurb => '긴장을 풀고 대형을 유지합니다.';

  @override
  String get commonRetry => '다시 시도';

  @override
  String get commonSomethingWentWrong => '문제가 발생했습니다';

  @override
  String get commonCrashBox => '이곳에서 문제가 발생했습니다.\n설정 → 진단에서 자세한 내용을 확인하세요.';

  @override
  String hubCouldNotAdvance(String error) {
    return '세계를 진행할 수 없습니다: $error';
  }

  @override
  String get settingsDiagnosticsTitle => '진단';

  @override
  String get settingsDiagnosticsBlurb => '이 기기에 기록된 오류입니다. 어디에도 전송되지 않습니다.';

  @override
  String get settingsContactTitle => '문의';

  @override
  String get settingsContactCopied => '주소가 복사되었습니다.';

  @override
  String get settingsCommunityTitle => '커뮤니티';

  @override
  String get settingsDiscordSubtitle => '커뮤니티에 참여하세요';

  @override
  String get settingsLinkCopied => '링크가 복사되었습니다.';

  @override
  String get diagnosticsEmpty => '기록된 오류가 없습니다. 바로 그게 목표죠.';

  @override
  String get diagnosticsCopy => '복사';

  @override
  String get diagnosticsCopied => '로그가 클립보드에 복사되었습니다.';

  @override
  String get diagnosticsClear => '지우기';

  @override
  String get navHub => '허브';

  @override
  String get navSquad => '스쿼드';

  @override
  String get navStandings => '순위';

  @override
  String get navCareers => '내 커리어';

  @override
  String get settingsTitle => '설정';

  @override
  String get settingsSoundHapticsTitle => '사운드 및 진동';

  @override
  String get settingsSoundHapticsBlurb => '골, 킥오프, 경기 종료 때 진동과 짧은 효과음.';

  @override
  String get settingsLanguageTitle => '언어';

  @override
  String get settingsLanguageBlurb => '앱 언어를 선택하거나 기기 설정을 따릅니다.';

  @override
  String get settingsLanguageSystem => '시스템';

  @override
  String get settingsTextSizeTitle => '글자 크기';

  @override
  String get settingsTextSizeBlurb => '읽기 어렵다면 글자를 키우세요.';

  @override
  String get settingsTextSizeNormal => '보통';

  @override
  String get settingsTextSizeLarge => '크게';

  @override
  String get settingsTextSizeLarger => '더 크게';

  @override
  String get matchPreviewAllMeetings => '모든 맞대결';

  @override
  String get recordsMeetings => '맞대결';

  @override
  String get recordsLegends => '레전드';

  @override
  String get recordsAllTimeXi => '역대 베스트 11';

  @override
  String get recordsHallOfFame => '명예의 전당';

  @override
  String get recordsAllTimeWorld => '역대 세계 기록';

  @override
  String get recordsAllTimeTopScorers => '역대 최다 득점';

  @override
  String get recordsMostCapped => '최다 출전';

  @override
  String get recordsMostWcStarts => '세계 선수권 최다 선발 출전';

  @override
  String get recordsMostTournaments => '최다 대회 참가';

  @override
  String get recordsRecordBook => '기록집';

  @override
  String get recordsHeadToHead => '상대 전적';

  @override
  String get recordsFiercestRival => '최대 라이벌';

  @override
  String get recordsMostCaps => '최다 출전';

  @override
  String get recordsTopScorers => '득점 순위';

  @override
  String get recordsMostAssists => '최다 도움';

  @override
  String get recordsYourRecord => '나의 전적';

  @override
  String get callUpHome => '홈';

  @override
  String get callUpAway => '원정';

  @override
  String get recordsHome => '홈';

  @override
  String get recordsAway => '원정';

  @override
  String get recordsActive => '현역';

  @override
  String get recordsStillActive => '현역 선수';

  @override
  String get recordsAvg => '평균';

  @override
  String get recordsSelect => '선택';

  @override
  String get recordsVs => 'vs';

  @override
  String get recordsDraws => '무승부';

  @override
  String get recordsGoalsLabel => '골';

  @override
  String get recordsBestFinish => '최고 성적';

  @override
  String get recordsNoFinalsYet => '아직 본선 진출 없음';

  @override
  String get recordsLongestUnbeaten => '최장 무패';

  @override
  String get recordsBiggestWin => '최다 점수 차 승리';

  @override
  String get recordsSeeAllMeetings => '모든 맞대결 보기';

  @override
  String get recordsSaveNotFound => '저장 파일을 찾을 수 없습니다.';

  @override
  String get recordsNoMatches => '결과가 없습니다.';

  @override
  String get recordsSearchPlayerOrNation => '선수 또는 국가 검색';

  @override
  String get recordsSearchNation => '국가 검색';

  @override
  String get recordsPickTwoDifferent => '서로 다른 두 국가를 선택하세요.';

  @override
  String get recordsPlayToBuildRecord => '경기를 치르면 상대별 전적이 이곳에 쌓입니다.';

  @override
  String get recordsTapOpponent => '상대를 누르면 자세한 내역을 볼 수 있습니다.';

  @override
  String get recordsEdgeUpperHand => '우리가 우위';

  @override
  String get recordsEdgeTheirNumber => '상대가 천적';

  @override
  String get recordsEdgeEven => '상대 전적 팽팽';

  @override
  String get recordsAllTimeWorldSubtitle => '전 세계 득점자 및 최다 출전, 모든 국가';

  @override
  String get recordsHeadToHeadSubtitle => '두 국가의 역대 전적 비교';

  @override
  String get recordsLegendsSubtitle => '역대 베스트 11 및 명예의 전당';

  @override
  String get recordsUnitGoals => '골';

  @override
  String get recordsUnitCaps => '경기';

  @override
  String get recordsUnitStarts => '선발';

  @override
  String get recordsUnitCups => '대회';

  @override
  String get recordsUnitAssists => '도움';

  @override
  String recordsCapsCount(int count) {
    return '$count경기 출전';
  }

  @override
  String recordsGoalsCount(int count) {
    return '$count골';
  }

  @override
  String recordsAssistsCount(int count) {
    return '$count도움';
  }

  @override
  String recordsMotmCount(int count) {
    return 'MOM $count회';
  }

  @override
  String recordsMatchesCount(int count) {
    return '$count경기';
  }

  @override
  String recordsMeetingsCount(int count) {
    return '$count회 맞대결';
  }

  @override
  String recordsCodeWins(String code) {
    return '$code 승리';
  }

  @override
  String recordsMeetingsWdl(int meetings, int wins, int draws, int losses) {
    return '$meetings회 맞대결 · $wins승 $draws무 $losses패';
  }

  @override
  String recordsWdl(int wins, int draws, int losses) {
    return '$wins승 $draws무 $losses패';
  }

  @override
  String recordsRivalLine(int meetings, String record, String edge) {
    return '$meetings회 맞대결 · $record · $edge';
  }

  @override
  String recordsNeverMet(String a, String b) {
    return '이 저장 파일에서 $a, $b 간 맞대결 기록이 없습니다.';
  }

  @override
  String tacticsSentOffNote(String names) {
    return '퇴장: $names. 교체할 수 없어 한 명 적은 상태로 경기합니다.';
  }

  @override
  String tacticsNeedFitPlayers(int required, int have) {
    return '출전 가능 선수 $required명 필요 (현재 $have명)';
  }

  @override
  String tacticsMissesOfCamp(int missed, int total) {
    return '결장 $missed/$total';
  }

  @override
  String get tacticsOutForWholeCamp => '이번 소집 기간 전체 결장';

  @override
  String get rankingCentreOnMe => '내 국가로 이동';

  @override
  String get recordsAfterExtraTime => '연장';

  @override
  String recordsOnPenalties(int a, int b) {
    return '승부차기 $a–$b';
  }

  @override
  String recordsVersus(String a, String b) {
    return '$a vs $b';
  }

  @override
  String recordsPlayedScore(int played, int gf, int ga) {
    return '$played경기 · $gf–$ga';
  }

  @override
  String recordsBiggestWinValue(int gf, int ga, String opp) {
    return '$gf–$ga vs $opp';
  }

  @override
  String recordsCouldNotLoad(String error) {
    return '불러올 수 없습니다.\n$error';
  }

  @override
  String recordsCouldNotLoadLegends(String error) {
    return '레전드를 불러올 수 없습니다.\n$error';
  }

  @override
  String recordsCouldNotLoadRecords(String error) {
    return '기록을 불러올 수 없습니다.\n$error';
  }

  @override
  String recordsCouldNotLoadNations(String error) {
    return '국가 목록을 불러올 수 없습니다.\n$error';
  }

  @override
  String recordsCouldNotLoadYourRecord(String error) {
    return '나의 전적을 불러올 수 없습니다.\n$error';
  }

  @override
  String recordsCouldNotLoadRecord(String error) {
    return '전적을 불러올 수 없습니다.\n$error';
  }

  @override
  String recordsNoLegends(String nation) {
    return '아직 레전드가 없습니다. 몇 차례 대회 주기를 치르면 $nation의 위대한 선수들이 이곳에 등장합니다.';
  }

  @override
  String recordsGreatestSide(String nation) {
    return '$nation 역사상 최강의 라인업.';
  }

  @override
  String get recordsNoWorldHistory =>
      '세계에 아직 역사가 없습니다. 몇 차례 대회 주기를 치르면 역대 최고의 선수들이 이곳에 나타납니다.';

  @override
  String recordsPlayToWriteHistory(String nation) {
    return '경기를 치르며 $nation의 역사를 써 내려가세요.';
  }

  @override
  String get tacticsLineGk => 'GK';

  @override
  String get tacticsLineDef => 'DF';

  @override
  String get tacticsLineMid => 'MF';

  @override
  String get tacticsLineFwd => 'FW';

  @override
  String get tacticsGoalkeepers => '골키퍼';

  @override
  String get tacticsDefenders => '수비수';

  @override
  String get tacticsMidfielders => '미드필더';

  @override
  String get tacticsForwards => '공격수';

  @override
  String get tacticsCallUpsTitle => '대표팀 소집';

  @override
  String tacticsPickAtLeastPlayers(int min) {
    return '최소 $min명을 선택하세요.';
  }

  @override
  String tacticsCouldNotLoadSquad(String error) {
    return '스쿼드를 불러올 수 없습니다.\n$error';
  }

  @override
  String get tacticsNoSquad => '스쿼드가 없습니다.';

  @override
  String tacticsSquadCount(int count, int max) {
    return '스쿼드 · $count/$max';
  }

  @override
  String tacticsMinMax(int min, int max) {
    return '최소 $min · 최대 $max';
  }

  @override
  String get tacticsBestQuality => '최고 전력';

  @override
  String get tacticsPreviousSquad => '이전 스쿼드';

  @override
  String get tacticsSquadLockedBack => '뒤로 (스쿼드 확정)';

  @override
  String get tacticsConfirmSquad => '스쿼드 확정';

  @override
  String tacticsSquadFullMax(int max) {
    return '스쿼드 가득 참 (최대 $max)';
  }

  @override
  String get tacticsSquadLocked => '스쿼드 확정됨';

  @override
  String get tacticsNominationOpen => '명단 제출 기간. 스쿼드를 선택하세요';

  @override
  String get tacticsSquadFixedBlurb =>
      '아래 경기에서는 이 스쿼드로 고정됩니다. 다음 명단 제출 기간 전에 다시 선택하세요.';

  @override
  String get tacticsSquadWillPlayBlurb => '이 스쿼드가 아래 경기에 나섭니다.';

  @override
  String get tacticsUnknown => '알 수 없음';

  @override
  String tacticsAgeValue(int age, String value) {
    return '$age세 · $value';
  }

  @override
  String get tacticsFatigueExhausted => '탈진';

  @override
  String get tacticsFatigueTired => '지침';

  @override
  String get tacticsFatigueMatchLegs => '경기 피로';

  @override
  String tacticsTooManySubs(int max) {
    return '교체 횟수 초과 (최대 $max회).';
  }

  @override
  String tacticsMinuteTitle(int minute) {
    return '전술 · $minute\'';
  }

  @override
  String get tacticsApply => '적용';

  @override
  String get tacticsTabLineupSubs => '라인업 및 교체';

  @override
  String get tacticsTabTactics => '전술';

  @override
  String get squadLineKeepers => '골키퍼';

  @override
  String get squadLineDefenders => '수비';

  @override
  String get squadLineMidfielders => '미드필드';

  @override
  String get squadLineForwards => '공격';

  @override
  String get squadStatXiRating => '선발 평점';

  @override
  String get squadStatAvgAge => '평균 나이';

  @override
  String get squadStatSize => '스쿼드';

  @override
  String get squadStatUnavailable => '결장';

  @override
  String get squadDepthTitle => '라인별 선수층';

  @override
  String squadAgeShort(int age) {
    return '$age세';
  }

  @override
  String get tacticsTabOtherPositions => '다른 포지션';

  @override
  String get tacticsOutOfPositionNote => '이 자리는 비주력 포지션';

  @override
  String get tacticsNobodyElse => '더 시도해 볼 선수가 없습니다.';

  @override
  String get tacticsPickSomebodyFirst =>
      '나갈 선수를 고르면 나머지 벤치 선수와 이 자리에서의 능력치가 여기에 표시됩니다.';

  @override
  String get tacticsTabSuitable => '적합';

  @override
  String get tacticsTabOnPitch => '경기장';

  @override
  String tacticsSectionSuitable(int count) {
    return '적합 · $count';
  }

  @override
  String get tacticsNobodySuits => '이 자리에 맞는 벤치 선수가 없어 전체 벤치를 보여 줍니다.';

  @override
  String tacticsSectionOnPitch(int count, int max) {
    return '경기장 · $count/$max';
  }

  @override
  String tacticsSectionAvailable(int count) {
    return '교체 가능 · $count';
  }

  @override
  String get tacticsRowStarted => '선발';

  @override
  String tacticsRowCameOn(int minute) {
    return '$minute\' 투입';
  }

  @override
  String get tacticsRowSubstitute => '교체 투입';

  @override
  String get tacticsEnergyLabel => '체력';

  @override
  String tacticsPickReplacementFor(String name) {
    return '$name 대신 들어갈 선수를 누르거나, 다시 눌러 취소하세요.';
  }

  @override
  String get tacticsSlotLostToRedCard =>
      '퇴장으로 이 자리를 잃었습니다. 동료를 이곳으로 끌어와 빈자리를 옮기세요.';

  @override
  String get tacticsSentOffShort => '퇴장';

  @override
  String get tacticsFullBackLeft => '왼쪽 풀백';

  @override
  String get tacticsFullBackRight => '오른쪽 풀백';

  @override
  String get tacticsFullBackUp => '공격 가담';

  @override
  String get tacticsFullBackDown => '수비 유지';

  @override
  String get tacticsFullBackOff => '지시 없음';

  @override
  String tacticsFullBackUpHint(String side) {
    return '$side: 공격 가담. 공격이 조금 늘고 위험도 조금 늘어납니다.';
  }

  @override
  String tacticsFullBackDownHint(String side) {
    return '$side: 수비 유지. 조금 더 안전하지만 공격은 조금 줄어듭니다.';
  }

  @override
  String tacticsFullBackOffHint(String side) {
    return '$side: 지시 없음. 팀 계획대로 플레이합니다.';
  }

  @override
  String tacticsFullBackSemantics(String side, String state) {
    return '$side 화살표: $state';
  }

  @override
  String tacticsSubsUsed(int used, int max) {
    return '교체 · $used/$max';
  }

  @override
  String get tacticsDragSubOn => '경기장의 선수를 눌러 빼거나, 교체 선수를 길게 눌러 그 위로 끌어다 놓으세요.';

  @override
  String get tacticsNoSubs => '교체 가능한 선수가 없습니다.';

  @override
  String get tacticsChooseShape => '대형 선택';

  @override
  String get tacticsFormation => '포메이션';

  @override
  String get tacticsInstructions => '지시';

  @override
  String get tacticsDrilling => '숙련도';

  @override
  String get tacticsDrillingUnplayed => '미사용';

  @override
  String get tacticsDrillingNew => '신규';

  @override
  String get tacticsDrillingSettling => '적응 중';

  @override
  String get tacticsDrillingDrilled => '완숙';

  @override
  String get tacticsInstrMentality => '성향';

  @override
  String get tacticsInstrDefensive => '수비적';

  @override
  String get tacticsInstrAttacking => '공격적';

  @override
  String get tacticsInstrPressing => '압박';

  @override
  String get tacticsInstrLowBlock => '내려앉기';

  @override
  String get tacticsInstrHighPress => '전방 압박';

  @override
  String get tacticsInstrTempo => '템포';

  @override
  String get tacticsInstrPatient => '느긋하게';

  @override
  String get tacticsInstrFast => '빠르게';

  @override
  String get tacticsInstrWidth => '폭';

  @override
  String get tacticsInstrNarrow => '좁게';

  @override
  String get tacticsInstrWide => '넓게';

  @override
  String get tacticsInstrDefLine => '수비 라인';

  @override
  String get tacticsInstrDefensiveLine => '수비 라인';

  @override
  String get tacticsInstrDeep => '낮게';

  @override
  String get tacticsInstrHigh => '높게';

  @override
  String get tacticsInstrDirectness => '직선성';

  @override
  String get tacticsInstrPossession => '점유';

  @override
  String get tacticsInstrDirect => '직선적';

  @override
  String get tacticsPickGoalkeeper => '골키퍼 선택';

  @override
  String get tacticsPickLeftBack => '왼쪽 풀백 선택';

  @override
  String get tacticsPickCentreBack => '센터백 선택';

  @override
  String get tacticsPickRightBack => '오른쪽 풀백 선택';

  @override
  String get tacticsPickDefensiveMid => '수비형 미드필더 선택';

  @override
  String get tacticsPickCentralMid => '중앙 미드필더 선택';

  @override
  String get tacticsPickAttackingMid => '공격형 미드필더 선택';

  @override
  String get tacticsPickLeftMid => '왼쪽 미드필더 선택';

  @override
  String get tacticsPickRightMid => '오른쪽 미드필더 선택';

  @override
  String get tacticsPickLeftWing => '왼쪽 윙어 선택';

  @override
  String get tacticsPickRightWing => '오른쪽 윙어 선택';

  @override
  String get tacticsPickStriker => '스트라이커 선택';

  @override
  String tacticsRoleOutOfPosition(String role) {
    return '$role · 비주력 포지션';
  }

  @override
  String tacticsAgeOnly(int age) {
    return '$age세';
  }

  @override
  String tacticsRoleAge(String role, int age) {
    return '$role · $age세';
  }

  @override
  String get tacticsOn => '출전';

  @override
  String get tacticsSquad => '스쿼드';

  @override
  String get tacticsTabLineup => '라인업';

  @override
  String get tacticsTabInstructions => '지시';

  @override
  String get tacticsTabRoles => '역할';

  @override
  String get tacticsTabSetPieces => '세트피스';

  @override
  String get tacticsTabRolesSetPieces => '역할 및 세트피스';

  @override
  String get tacticsRolesSetPiecesBlurb =>
      '선발 선수마다 역할을 정하세요. 페널티킥(⚽) 또는 프리킥(▲) 배지를 눌러 키커를 지정합니다.';

  @override
  String get tacticsTooltipCallUps => '소집';

  @override
  String get tacticsTooltipPresets => '전술 프리셋';

  @override
  String get tacticsTooltipInstructions => '지시';

  @override
  String get tacticsNoTacticSet => '설정된 전술이 없습니다.';

  @override
  String tacticsReplaceStarters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '선발 $count명 교체 필요',
    );
    return '$_temp0';
  }

  @override
  String tacticsPlayerOut(String name, String reason) {
    return '$name: $reason';
  }

  @override
  String get tacticsOut => '결장';

  @override
  String get tacticsTapSpotReplace => '경기장에서 해당 자리를 눌러 대체 선수를 고르세요.';

  @override
  String get tacticsTapOrDrag => '선수를 눌러 교체하거나, 길게 눌러 끌어서 위치를 옮기세요.';

  @override
  String get tacticsPlayerRoles => '선수 역할';

  @override
  String get tacticsRolesBlurb =>
      '선수에게 임무를 주세요. 골잡이, 플레이메이커, 타깃맨 등. 누가 득점하고 누가 기회를 만들지 결정합니다.';

  @override
  String get tacticsSetPieceTakers => '세트피스 키커';

  @override
  String get tacticsSetPieceBlurb =>
      '페널티킥과 데드볼을 맡을 선수를 정하거나, 가장 적합한 선수에게 맡기세요.';

  @override
  String get tacticsTakerAuto => '자동';

  @override
  String get tacticsTakerQuickPick => '최적 키커 사용';

  @override
  String get tacticsPenalties => '페널티킥';

  @override
  String get tacticsCornersFreeKicks => '코너킥 및 프리킥';

  @override
  String get tacticsSkillFin => '결정력';

  @override
  String get tacticsSkillPas => '패스';

  @override
  String tacticsRolePlayer(String name) {
    return '역할 · $name';
  }

  @override
  String get tacticsPenaltyTaker => '페널티 키커';

  @override
  String get tacticsCornerFreeKickTaker => '코너킥 및 프리킥 키커';

  @override
  String get tacticsAutomatic => '자동';

  @override
  String get tacticsLetBestSuited => '가장 적합한 선수가 찹니다.';

  @override
  String get tacticsInXi => '선발';

  @override
  String get tacticsTeamInstructions => '팀 지시';

  @override
  String get tacticsTeamInstructionsBlurb =>
      '팀의 경기 방식을 정하세요. 각 다이얼이 팀 전체에 영향을 줍니다.';

  @override
  String tacticsSavedPreset(String name) {
    return '“$name” 저장됨';
  }

  @override
  String tacticsAppliedPreset(String name) {
    return '“$name” 적용됨';
  }

  @override
  String get tacticsTacticPresets => '전술 프리셋';

  @override
  String get tacticsPresetsBlurb =>
      '이 대형을 재사용 가능한 스타일로 저장하거나, 저장해 둔 스타일을 적용하세요.';

  @override
  String get tacticsSaveCurrentTactic => '현재 전술 저장';

  @override
  String tacticsCouldNotLoadPresets(String error) {
    return '프리셋을 불러올 수 없습니다.\n$error';
  }

  @override
  String get tacticsNoPresetsYet =>
      '아직 프리셋이 없습니다. “현재 전술 저장”을 눌러 이 설정을 스타일로 저장하세요.';

  @override
  String get tacticsNameThisTactic => '전술 이름 정하기';

  @override
  String get tacticsNameHint => '예: 전방 압박 4-3-3';

  @override
  String get tacticsCancel => '취소';

  @override
  String get tacticsSave => '저장';

  @override
  String get tacticsTapToAssign => '눌러서 지정';

  @override
  String get tacticsHoldDragSub => '교체 선수를 길게 눌러 선수 위로 끌어다 놓으면 투입됩니다.';

  @override
  String get hubContinue => '계속';

  @override
  String get hubBrackets => '대진표';

  @override
  String hubCouldNotLoad(String error) {
    return '불러올 수 없습니다.\n$error';
  }

  @override
  String hubCouldNotLoadFinances(String error) {
    return '재정 정보를 불러올 수 없습니다.\n$error';
  }

  @override
  String hubCouldNotLoadSave(String error) {
    return '저장 파일을 불러올 수 없습니다.\n$error';
  }

  @override
  String get hubSaveNotFound => '저장 파일을 찾을 수 없습니다.';

  @override
  String get hubUnknown => '알 수 없음';

  @override
  String hubWorldChampionsYear(int year) {
    return '$year 세계 챔피언';
  }

  @override
  String get hubCycleComplete => '대회 주기가 끝났습니다.';

  @override
  String get hubYourJob => '현재 직책';

  @override
  String get hubStayProject => '남아서 프로젝트 이어가기';

  @override
  String get hubChooseNextJob => '다음 직장을 선택하세요';

  @override
  String get hubOffersOnTable => '받은 제안';

  @override
  String hubOfferSubtitle(String tier, int position) {
    return '$tier · 세계 $position위';
  }

  @override
  String hubContinueWith(String nation) {
    return '$nation 대표팀과 계속하기';
  }

  @override
  String get hubYourNation => '우리 대표팀';

  @override
  String get hubTakeTheJob => '제안 수락';

  @override
  String get hubFederationFinances => '협회 재정';

  @override
  String get hubBudgetIntro => '다음 대회 주기의 첫 업무는 협회 예산을 정하고 각 부서에 배분하는 것입니다.';

  @override
  String get hubStarting => '시작하는 중…';

  @override
  String get hubBeginNextCycle => '다음 대회 주기 시작';

  @override
  String get hubContinueCareer => '커리어 계속하기';

  @override
  String get hubBackToSaves => '저장 파일 목록으로';

  @override
  String get hubOpeningBalance => '기초 잔액';

  @override
  String get hubCentralFunding => '중앙 지원금';

  @override
  String get hubPrizeMoney => '상금';

  @override
  String get hubCommercialReturn => '상업 수익';

  @override
  String get hubAvailableToInvest => '투자 가능 금액';

  @override
  String hubReputation(String label, int rep) {
    return '명성: $label ($rep)';
  }

  @override
  String get hubNationalHero => '국민 영웅';

  @override
  String get hubFinal => '결승';

  @override
  String get hubStageRoundOf32 => '32강';

  @override
  String get hubStageThirdPlace => '3위 결정전';

  @override
  String get hubEventAdvanceWorld => '세계 진행';

  @override
  String hubEventStartCycle(int year) {
    return '$year 대회 주기 시작';
  }

  @override
  String hubEventWorldChampions(String nation) {
    return '세계 챔피언: $nation';
  }

  @override
  String get hubEventSetBudget => '협회 예산 설정';

  @override
  String get hubEventSetBudgetSub => '시즌 시작 전에 이번 주기의 자금을 배분하세요';

  @override
  String get hubEventNaturalization => '귀화 제안 검토';

  @override
  String get hubEventNaturalizationSub => '외국 선수가 우리 대표팀으로 국적을 바꾸고 싶어 합니다';

  @override
  String get hubEventCampaignVerdict => '캠페인 결과 확정: 평가 보기';

  @override
  String get hubEventCampaignComplete => '캠페인 완료';

  @override
  String get hubEventIntercontinentalPlayoff => '대륙 간 플레이오프';

  @override
  String get hubEventWatchWcDraw => '세계 선수권 조 추첨 보기';

  @override
  String get hubEventWorldCupHere => '세계 선수권 개막';

  @override
  String get hubEventWatchFinalsDraw => '본선 조 추첨 보기';

  @override
  String get hubEventFinalsHere => '본선 개막';

  @override
  String get hubEventPlayWcRound => '세계 선수권 다음 라운드 진행';

  @override
  String hubEventPlayCupMatch(String cup) {
    return '$cup 다음 경기 진행';
  }

  @override
  String get hubEventPlayNationsCupMatch => '네이션스컵 다음 경기 진행';

  @override
  String get hubEventWatchNationsCupDraw => '네이션스컵 조 추첨 보기';

  @override
  String get hubEventWatchHostSelection => '개최국 선정 보기';

  @override
  String get hubEventWatchQualifyingDraw => '예선 조 추첨 보기';

  @override
  String get hubEventWatchWcHostSelection => '세계 선수권 개최국 선정 보기';

  @override
  String get hubEventWatchWcQualifyingDraw => '세계 선수권 예선 조 추첨 보기';

  @override
  String get hubEventArrangeFriendlies => '친선 경기 잡기';

  @override
  String hubEventFriendliesSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '아직 비어 있는 친선 경기 일정이 $count개 있습니다',
      one: '아직 비어 있는 친선 경기 일정이 있습니다',
    );
    return '$_temp0';
  }

  @override
  String get hubEventReshapeXi => '선발 11인 재구성';

  @override
  String hubEventReshapeOutSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '선발 $count명이 결장합니다(징계 또는 부상). 대체 선수를 고르세요',
      one: '선발 1명이 결장합니다(징계 또는 부상). 대체 선수를 고르세요',
    );
    return '$_temp0';
  }

  @override
  String hubEventReshapeShortSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '선발 명단이 부족합니다. 빈자리들을 채우세요',
      one: '선발 명단이 부족합니다. 빈자리를 채우세요',
    );
    return '$_temp0';
  }

  @override
  String hubEventPlayOpponent(String opponent) {
    return '$opponent전 치르기';
  }

  @override
  String get hubEventContinentalFinalsFallback => '대륙 선수권 본선';

  @override
  String get hubCallUpFriendlies => '친선 경기 스쿼드 발표';

  @override
  String get hubCallUpRequalify => '예선 스쿼드 재발표';

  @override
  String get hubCallUpWorldCup => '세계 선수권 스쿼드 발표';

  @override
  String get hubCallUpFinals => '본선 스쿼드 발표';

  @override
  String get hubCallUpNationsCup => '네이션스컵 스쿼드 발표';

  @override
  String get hubCallUpQualifying => '예선 스쿼드 발표';

  @override
  String get hubCallUpGeneric => '스쿼드 발표';

  @override
  String get hubHost => '개최국';

  @override
  String get hubGoldenBoot => '골든 부트';

  @override
  String hubGoldenBootValue(String name, int goals) {
    return '$name · $goals골';
  }

  @override
  String get hubPens => '(승부차기)';

  @override
  String get hubNationalHub => '대표팀 허브';

  @override
  String get hubMessages => '메시지';

  @override
  String get hubWorldChampions => '세계 챔피언';

  @override
  String get hubViewBracket => '대진표 보기 ›';

  @override
  String get hubBoardDelighted => '매우 만족';

  @override
  String get hubBoardPleased => '만족';

  @override
  String get hubBoardExpectingMore => '기대 이하';

  @override
  String get hubBoardConcerned => '우려';

  @override
  String get hubBoardJobAtRisk => '경질 위기';

  @override
  String get hubBoard => '협회 이사회';

  @override
  String hubBoardObjective(String label) {
    return '이사회 목표: $label';
  }

  @override
  String hubObjectiveMet(String result) {
    return '달성 · $result';
  }

  @override
  String hubObjectiveMissed(String result) {
    return '실패 · $result';
  }

  @override
  String get hubNoMoreFixtures => '이번 주기에 남은 경기가 없습니다.';

  @override
  String get hubVs => 'VS';

  @override
  String hubWorldRank(int rank) {
    return '$rank위';
  }

  @override
  String get hubWorldRankLabel => '세계 랭킹';

  @override
  String get hubSquadStatus => '스쿼드 현황';

  @override
  String hubPlayers(int count) {
    return '$count명';
  }

  @override
  String get hubAvgRating => '평균 평점';

  @override
  String get hubMorale => '사기';

  @override
  String get hubManageTeam => '팀 관리';

  @override
  String get hubGroupsToBeDrawn => '조 추첨 전입니다. 추첨을 보고 조 편성을 확인하세요.';

  @override
  String hubGroupName(String name) {
    return '$name조';
  }

  @override
  String get hubTblTeam => '팀';

  @override
  String get hubTblP => '경기';

  @override
  String get hubTblGd => '득실';

  @override
  String get hubTblPts => '승점';

  @override
  String get homeSettings => '설정';

  @override
  String get homeLeadTheNation => '조국을 이끌어라';

  @override
  String get homeYourNation => '우리 대표팀';

  @override
  String get homeNewGame => '새 게임';

  @override
  String get homeAllSaves => '모든 저장 파일';

  @override
  String get homeLoadGame => '불러오기';

  @override
  String get homeContinue => '이어하기';

  @override
  String homeRoadToWorldCup(String date, int year) {
    return '$date · $year 세계 선수권을 향해';
  }

  @override
  String get careerManageSaves => '저장 파일 관리';

  @override
  String get careerNewGameTitle => '새 게임';

  @override
  String careerCouldNotLoadNation(String error) {
    return '국가를 불러올 수 없습니다.\n$error';
  }

  @override
  String get careerNationNotFound => '국가를 찾을 수 없습니다.';

  @override
  String careerWorldRankNum(int rank) {
    return '세계 랭킹 $rank위';
  }

  @override
  String get careerManagerName => '감독 이름';

  @override
  String get careerManagerNameHint => '예: 알렉스 퍼거슨';

  @override
  String get careerBeginsBlurb =>
      '커리어는 2026년 9월, 2030 세계 선수권을 향한 여정과 함께 시작됩니다.';

  @override
  String get careerFreeCycleNote =>
      '4년 대회 주기 한 번은 무료입니다: 예선, 대륙 선수권, 세계 선수권까지 저장 파일 두 개로 즐길 수 있습니다. 이후 한 번 결제하면 끝없이 이어집니다.';

  @override
  String get careerStartCareer => '커리어 시작';

  @override
  String get careersTitle => '커리어';

  @override
  String get careerManagerCareer => '감독 커리어';

  @override
  String get careerManagerCareerSubtitle => '지휘한 모든 대회 주기와 통산 전적';

  @override
  String get careerSummaryTitle => '커리어 요약';

  @override
  String get careerSummarySubtitle => '트로피 진열장과 감독 기록';

  @override
  String get careerAchievements => '업적';

  @override
  String get careerAchievementsSubtitle => '이정표, 우승, 이사회 만족도';

  @override
  String get careerChallenges => '도전 과제';

  @override
  String get careerChallengesSubtitle => '커리어 내내 이어지는 혹독한 시험';

  @override
  String get careerTeamRecords => '팀 기록';

  @override
  String get careerTeamRecordsSubtitle => '역대 최다 득점과 최다 출전';

  @override
  String get careerMyMatches => '내 경기';

  @override
  String get careerMyMatchesSubtitle => '모든 결과와 예정된 경기';

  @override
  String get careerTitle => '커리어';

  @override
  String careerCouldNotLoadCareer(String error) {
    return '커리어를 불러올 수 없습니다.\n$error';
  }

  @override
  String get careerNoCareer => '커리어가 없습니다.';

  @override
  String get careerTrophyCabinet => '트로피 진열장';

  @override
  String get careerTournamentHistory => '대회 이력';

  @override
  String get careerNoTournamentsYet => '아직 끝난 대회가 없습니다.';

  @override
  String get careerTeamFallback => '팀';

  @override
  String careerWorldNum(int rank) {
    return '세계 $rank위';
  }

  @override
  String careerPointsNum(int points) {
    return '$points점';
  }

  @override
  String careerSeasonNum(int season) {
    return '$season 시즌';
  }

  @override
  String get careerStatPlayedShort => '경기';

  @override
  String get careerStatsHeading => '숫자로 보는 기록';

  @override
  String get careerStatsWinRate => '승률';

  @override
  String get careerStatsGoalsFor => '득점';

  @override
  String get careerStatsGoalsAgainst => '실점';

  @override
  String get careerStatsGoalDiff => '득실차';

  @override
  String get careerStatsCleanSheets => '무실점';

  @override
  String get careerStatsBiggestWin => '최다 점수 차 승리';

  @override
  String get careerStatsWinStreak => '연승';

  @override
  String get careerStatsUnbeaten => '무패 행진';

  @override
  String get careerStatsShootouts => '승부차기';

  @override
  String get careerStatsHatTricks => '해트트릭';

  @override
  String get careerStatsMotms => '경기 최우수 선수';

  @override
  String get careerStatsBestRating => '최고 평점';

  @override
  String get careerStatWonShort => '승';

  @override
  String get careerStatDrawnShort => '무';

  @override
  String get careerStatLostShort => '패';

  @override
  String get careerStatGoalsForShort => '득점';

  @override
  String get careerStatGoalsAgainstShort => '실점';

  @override
  String get careerStatGoalDiffShort => '득실';

  @override
  String get careerNoSilverware => '아직 트로피가 없습니다. 하나 차지하러 가세요.';

  @override
  String get careerMedalGold => '금';

  @override
  String get careerMedalSilver => '은';

  @override
  String get careerMedalBronze => '동';

  @override
  String careerWinnersName(String name) {
    return '우승: $name';
  }

  @override
  String get careerSavesTitle => '저장 파일';

  @override
  String careerCouldNotLoadSaves(String error) {
    return '저장 파일을 불러올 수 없습니다.\n$error';
  }

  @override
  String careerSlotsCount(int used, int limit) {
    return '슬롯  $used/$limit';
  }

  @override
  String get careerThisSave => '현재 저장 파일';

  @override
  String get careerSlotsFull => '슬롯 가득 참';

  @override
  String careerSlotsUsed(int used) {
    return '슬롯  $used';
  }

  @override
  String get careerSlotsUnlockMore => '저장 슬롯 추가 잠금 해제';

  @override
  String get careerSlotsKeepNote =>
      '기존 저장 파일은 모두 계속 플레이할 수 있습니다. 새 저장 파일만 잠금 해제가 필요합니다.';

  @override
  String get careerNewGame => '새 게임';

  @override
  String get careerDeleteSaveTitle => '저장 파일을 삭제할까요?';

  @override
  String careerDeleteSaveBody(String label) {
    return '$label 커리어가 영구적으로 삭제됩니다.';
  }

  @override
  String get careerCancel => '취소';

  @override
  String get careerDelete => '삭제';

  @override
  String get careerNoSavesYet => '아직 저장 파일이 없습니다.\n새 게임을 시작해 대표팀을 이끄세요.';

  @override
  String get careerUnknownNation => '알 수 없음';

  @override
  String careerPlayedMinutes(int minutes) {
    return '$minutes분';
  }

  @override
  String careerPlayedHours(int hours, int minutes) {
    return '$hours시간 $minutes분';
  }

  @override
  String careerLastPlayed(String when) {
    return '마지막 플레이: $when';
  }

  @override
  String get careerJustNow => '방금';

  @override
  String get careerYesterday => '어제';

  @override
  String careerMinutesAgo(int n) {
    return '$n분 전';
  }

  @override
  String careerHoursAgo(int n) {
    return '$n시간 전';
  }

  @override
  String careerDaysAgo(int n) {
    return '$n일 전';
  }

  @override
  String careerRoadToWorldCup(int year) {
    return '$year 세계 선수권을 향해';
  }

  @override
  String get careerManagerCareerTitle => '감독 커리어';

  @override
  String careerCouldNotLoad(String error) {
    return '불러올 수 없습니다.\n$error';
  }

  @override
  String get careerCycleByCycle => '대회 주기별 기록';

  @override
  String careerCyclesNationsLed(int cycles, int nations) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles개 대회 주기',
    );
    String _temp1 = intl.Intl.pluralLogic(
      nations,
      locale: localeName,
      other: '$nations개국 지휘',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get careerStatTitles => '우승';

  @override
  String get careerStatPlayed => '경기';

  @override
  String get careerStatWon => '승';

  @override
  String get careerStatDrawn => '무';

  @override
  String get careerStatLost => '패';

  @override
  String careerGoalsWinRate(
    int goalsFor,
    int goalsAgainst,
    String gd,
    int winRate,
  ) {
    return '득실 $goalsFor–$goalsAgainst  ($gd)  ·  승률 $winRate%';
  }

  @override
  String get careerRecordResults => '기록적인 결과';

  @override
  String get careerBestWin => '최고의 승리';

  @override
  String get careerWorstDefeat => '최악의 패배';

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
    return '$won승 $drawn무 $lost패  ·  득점 $goalsFor 실점 $goalsAgainst ($gd)';
  }

  @override
  String get careerWorldCupLabel => '세계 선수권';

  @override
  String get careerContinentalLabel => '대륙 선수권';

  @override
  String get messagesTitle => '메시지';

  @override
  String get messagesNoMessagesYet => '아직 메시지가 없습니다.';

  @override
  String messagesCouldNotLoad(String error) {
    return '메시지를 불러올 수 없습니다.\n$error';
  }

  @override
  String get messagesDone => '완료';

  @override
  String get messagesNext => '다음';

  @override
  String get rankingWorldRanking => '세계 랭킹';

  @override
  String rankingCouldNotLoad(String error) {
    return '랭킹을 불러올 수 없습니다.\n$error';
  }

  @override
  String get rankingNoRanking => '랭킹이 없습니다.';

  @override
  String get rankingAll => '전체';

  @override
  String get rankingYourTeam => '우리 팀';

  @override
  String get rankingYourRankingOverTime => '우리 팀 랭킹 추이';

  @override
  String rankingNowRank(int rank) {
    return '현재 $rank위';
  }

  @override
  String rankingBestWorst(int best, int worst) {
    return '최고 $best위 · 최저 $worst위';
  }

  @override
  String get friendliesTitle => '친선 경기';

  @override
  String friendliesLoadError(String error) {
    return '친선 경기를 불러올 수 없습니다.\n$error';
  }

  @override
  String get friendliesContinue => '계속';

  @override
  String friendliesArrangeIntro(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '비어 있는 일정 $count개',
    );
    return '다음 공식 경기 전 $_temp0에 평가전을 잡으세요. 상대를 누르거나 비워 두세요.';
  }

  @override
  String get friendliesFree => '비어 있음';

  @override
  String matchGoalsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count골',
      one: '1골',
    );
    return '$_temp0';
  }

  @override
  String get matchGoalsTitle => '골';

  @override
  String get matchGoalsNone => '득점 없음';

  @override
  String get matchGoalPenalty => 'PK';

  @override
  String get matchGoalSetPiece => '세트';

  @override
  String matchGoalAssist(String name) {
    return '도움 $name';
  }

  @override
  String get friendliesHome => '홈';

  @override
  String get friendliesAway => '원정';

  @override
  String get friendliesNoneThisWindow => '이번 일정은 친선 경기 없음';

  @override
  String friendliesConfirmCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count개',
    );
    return '친선 경기 $_temp0 확정';
  }

  @override
  String get friendliesMonthJan => '1월';

  @override
  String get friendliesMonthFeb => '2월';

  @override
  String get friendliesMonthMar => '3월';

  @override
  String get friendliesMonthApr => '4월';

  @override
  String get friendliesMonthMay => '5월';

  @override
  String get friendliesMonthJun => '6월';

  @override
  String get friendliesMonthJul => '7월';

  @override
  String get friendliesMonthAug => '8월';

  @override
  String get friendliesMonthSep => '9월';

  @override
  String get friendliesMonthOct => '10월';

  @override
  String get friendliesMonthNov => '11월';

  @override
  String get friendliesMonthDec => '12월';

  @override
  String get resultsMyMatches => '내 경기';

  @override
  String resultsCouldNotLoad(String error) {
    return '결과를 불러올 수 없습니다.\n$error';
  }

  @override
  String get resultsNoFixtures => '경기 일정이 없습니다.';

  @override
  String get resultsVs => 'vs';

  @override
  String get resultsStageQualifier => '예선';

  @override
  String get resultsStageFriendly => '친선 경기';

  @override
  String get resultsStageGroupStage => '조별 리그';

  @override
  String get resultsStageSemiFinal => '4강';

  @override
  String get resultsStageFinal => '결승';

  @override
  String get resultsStageContinentalClash => '대륙 대항전';

  @override
  String get resultsStageFinalsGroup => '본선 조별 리그';

  @override
  String get resultsStageRoundOf32 => '32강';

  @override
  String get resultsStageRoundOf16 => '16강';

  @override
  String get resultsStageQuarterFinal => '8강';

  @override
  String get resultsStageThirdPlace => '3위 결정전';

  @override
  String get matchSetupWarnCaptain => '주장이 지정되지 않았습니다. 눌러서 완장을 맡기세요';

  @override
  String matchSetupWarnCaptainInjured(String name) {
    return '주장 $name 선수가 부상으로 이번 경기에 나설 수 없습니다. 눌러서 완장을 넘기세요';
  }

  @override
  String matchSetupWarnCaptainSuspended(String name) {
    return '주장 $name 선수가 이번 경기 출전 정지입니다. 눌러서 완장을 넘기세요';
  }

  @override
  String matchSetupWarnCaptainDropped(String name) {
    return '주장 $name 선수가 스쿼드에 없습니다. 눌러서 완장을 넘기세요';
  }

  @override
  String get matchSetupWarnSetPieces => '세트피스 키커가 지정되지 않았습니다. 눌러서 키커를 고르세요';

  @override
  String get matchSetupWarnBoth => '주장과 세트피스 키커가 없습니다. 눌러서 지정하세요';

  @override
  String matchStageMatchday(int matchday) {
    return '$matchday라운드';
  }

  @override
  String get squadCaptain => '주장';

  @override
  String deptEffectYouth(int points) {
    return '유소년 유망주의 종합 능력치가 약 $points 높아집니다';
  }

  @override
  String deptEffectCommercial(String amount) {
    return '대회 주기 종료 시 $amount 회수';
  }

  @override
  String deptEffectMedical(int percent) {
    return '부상 $percent% 감소';
  }

  @override
  String deptEffectNaturalisation(int percent) {
    return '외국 선수의 귀화 요청 확률 $percent%';
  }

  @override
  String deptEffectBoard(int points) {
    return '경질 위기까지 이사회 인내심 +$points';
  }

  @override
  String get deptEffectNone => '예산이 없으면 효과 없음';

  @override
  String get statsBestRated => '평점';

  @override
  String get statsMyCareer => '커리어';

  @override
  String get statsBestAverageRating => '최고 평균 평점';

  @override
  String get statsMyCareerRecord => '나의 기록';

  @override
  String get statsNoRatingsRecorded => '아직 기록된 평점이 없습니다.';

  @override
  String get statsGroupRecord => '전적';

  @override
  String get statsGroupRuns => '연속 기록';

  @override
  String get statsGroupExtremes => '극단 기록';

  @override
  String get statsGroupSplits => '홈 및 원정';

  @override
  String get statsGroupSquad => '우리 선수';

  @override
  String get statsPlayed => '경기 수';

  @override
  String get statsWinDrawLoss => '승–무–패';

  @override
  String get statsWinRate => '승률';

  @override
  String get statsGoals => '득점:실점';

  @override
  String get statsCleanSheets => '무실점 경기';

  @override
  String get statsFailedToScore => '무득점 경기';

  @override
  String get statsLongestWinStreak => '최다 연승';

  @override
  String get statsLongestUnbeaten => '최장 무패';

  @override
  String get statsLongestCleanSheets => '최장 연속 무실점';

  @override
  String get statsLongestWinless => '최장 무승';

  @override
  String get statsCurrentRun => '현재 무패 행진';

  @override
  String get statsBiggestWin => '최다 점수 차 승리';

  @override
  String get statsHeaviestDefeat => '최다 점수 차 패배';

  @override
  String get statsMostGoalsInAGame => '한 경기 최다 골';

  @override
  String get statsShootouts => '승부차기 승–패';

  @override
  String get statsComebackWins => '역전승';

  @override
  String get statsHome => '홈';

  @override
  String get statsAway => '원정';

  @override
  String get statsNeutral => '중립';

  @override
  String get statsCompetitive => '공식 경기';

  @override
  String get statsFriendlies => '친선 경기';

  @override
  String get statsHatTricks => '해트트릭';

  @override
  String get statsBraces => '멀티골';

  @override
  String get statsMotms => '경기 최우수 선수 수상';

  @override
  String get statsAssists => '도움';

  @override
  String get statsCards => '카드';

  @override
  String get statsBestRating => '개인 최고 평점';

  @override
  String statsAppsShort(int apps) {
    return '$apps경기';
  }

  @override
  String statsMotmShort(int motms) {
    return 'MOM $motms회';
  }

  @override
  String get captainArmband => 'C';

  @override
  String get captainCurrent => '주장. 눌러서 완장 해제';

  @override
  String get captainFitBorn => '타고난 리더';

  @override
  String get captainFitNatural => '천생 주장감';

  @override
  String get captainFitCapable => '주장 가능';

  @override
  String get captainFitUnproven => '아직 리더감 아님';

  @override
  String get captainNone => '주장 미지정';

  @override
  String captainMoraleBoost(int morale) {
    return '스쿼드 사기 +$morale';
  }

  @override
  String get resultsCategoryWorldCupQualifying => '세계 선수권 예선';

  @override
  String get resultsCategoryFriendlies => '친선 경기';

  @override
  String get resultsCategoryContinentalClash => '대륙 대항전';

  @override
  String get resultsCategoryNationsCup => '네이션스컵';

  @override
  String get resultsCategoryContinentalCup => '대륙컵';

  @override
  String get resultsCategoryWorldCupQualifyingShort => '세계 선수권 예선';

  @override
  String get resultsCategoryContinentalQualifyingShort => '대륙컵 예선';

  @override
  String get resultsCategoryContinentalQualifying => '대륙컵 예선';

  @override
  String get resultsCategoryWorldCupFinals => '세계 선수권 본선';

  @override
  String get resultsRoundResults => '라운드 결과';

  @override
  String get resultsFriendlyInternationals => '국가대표 친선 경기';

  @override
  String get resultsKnockout => '토너먼트';

  @override
  String resultsEarlierMatches(int count) {
    return '이전 경기 ($count)';
  }

  @override
  String resultsMatchday(int matchday) {
    return '$matchday라운드';
  }

  @override
  String get resultsContinue => '계속';

  @override
  String resultsGroup(String name) {
    return '$name조';
  }

  @override
  String get achievementsScreenTitle => '업적';

  @override
  String get achievementsChallengesTooltip => '도전 과제';

  @override
  String get achievementsChallengesHeading => '도전 과제';

  @override
  String get achievementsBrutalTests => '커리어 내내 이어지는 혹독한 시험';

  @override
  String achievementsCouldNotLoad(String error) {
    return '불러올 수 없습니다.\n$error';
  }

  @override
  String achievementsUnlockedCount(int earned, int total) {
    return '$earned / $total 달성';
  }

  @override
  String achievementsConqueredCount(int done, int total) {
    return '$done / $total 정복';
  }

  @override
  String get achievementsBoardSatisfaction => '이사회 만족도';

  @override
  String achievementsUnlockedBanner(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '업적 $count개 달성',
    );
    return '$_temp0';
  }

  @override
  String get achCatWins => '승리';

  @override
  String get achCatMatches => '경기';

  @override
  String get achCatQualifications => '본선 진출';

  @override
  String get achCatTitles => '우승';

  @override
  String get achCatMisc => '기타';

  @override
  String get achCatMega => '메가';

  @override
  String get achCatGoals => '골';

  @override
  String get achCatStreaks => '연속 기록';

  @override
  String get achTierBronze => '브론즈';

  @override
  String get achTierSilver => '실버';

  @override
  String get achTierGold => '골드';

  @override
  String get achTierPlatinum => '플래티넘';

  @override
  String achGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count골',
    );
    return '$_temp0';
  }

  @override
  String achGoalsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count골을 넣으세요.',
      one: '1골을 넣으세요.',
    );
    return '$_temp0';
  }

  @override
  String achCleanSheets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '무실점 $count회',
    );
    return '$_temp0';
  }

  @override
  String achCleanSheetsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '무실점 경기를 $count회 기록하세요.',
      one: '무실점 경기를 1회 기록하세요.',
    );
    return '$_temp0';
  }

  @override
  String get achStreakWin5 => '승리의 습관';

  @override
  String get achStreakWin5Desc => '5연승을 달성하세요.';

  @override
  String get achStreakWin10 => '파죽지세';

  @override
  String get achStreakWin10Desc => '10연승을 달성하세요.';

  @override
  String get achStreakWin20 => '무적 행진';

  @override
  String get achStreakWin20Desc => '20연승을 달성하세요.';

  @override
  String get achUnbeaten15 => '쉽게 지지 않는 팀';

  @override
  String get achUnbeaten15Desc => '15경기 연속 무패를 기록하세요.';

  @override
  String get achUnbeaten30 => '철옹성';

  @override
  String get achUnbeaten30Desc => '30경기 연속 무패를 기록하세요.';

  @override
  String get achHattrick => '해트트릭 영웅';

  @override
  String get achHattrickDesc => '선수가 해트트릭을 기록하게 하세요.';

  @override
  String get achMotm10 => '돋보이는 존재';

  @override
  String get achMotm10Desc => '경기 최우수 선수상 10회를 받으세요.';

  @override
  String get achMotm50 => '에이스';

  @override
  String get achMotm50Desc => '경기 최우수 선수상 50회를 받으세요.';

  @override
  String get achPerfect => '퍼펙트 텐';

  @override
  String get achPerfectDesc => '선수가 평점 9.5 이상을 받게 하세요.';

  @override
  String get achShootout => '강철 심장';

  @override
  String get achShootoutDesc => '승부차기에서 5번 승리하세요.';

  @override
  String get achMassacre => '대학살';

  @override
  String get achMassacreDesc => '7골 차 이상으로 승리하세요.';

  @override
  String get achAnnihilation => '초토화';

  @override
  String get achAnnihilationDesc => '10골 차 이상으로 승리하세요.';

  @override
  String get chTierBronze => '브론즈';

  @override
  String get chTierSilver => '실버';

  @override
  String get chTierGold => '골드';

  @override
  String get chTierLegendary => '레전더리';

  @override
  String get chFirstSteps => '벤치에 앉다';

  @override
  String get chFirstStepsDesc => '5년 동안 감독을 맡으세요.';

  @override
  String get chUnbeaten10 => '파죽지세';

  @override
  String get chUnbeaten10Desc => '공식 경기 10경기 연속 무패를 기록하세요.';

  @override
  String get chTwoNations => '새로운 도전';

  @override
  String get chTwoNationsDesc => '서로 다른 2개국을 지휘하세요.';

  @override
  String get chCont1 => '대륙 챔피언';

  @override
  String get chCont1Desc => '대륙 선수권에서 우승하세요.';

  @override
  String get chNc1 => '네이션스컵 우승';

  @override
  String get chNc1Desc => '네이션스컵에서 우승하세요.';

  @override
  String get chWc1 => '세계 챔피언';

  @override
  String get chWc1Desc => '세계 선수권에서 우승하세요.';

  @override
  String get chYears25 => '터줏대감';

  @override
  String get chYears25Desc => '25년 동안 감독을 맡으세요.';

  @override
  String get chWc3 => '우승 청부사';

  @override
  String get chWc3Desc => '세계 선수권에서 3회 우승하세요.';

  @override
  String get chWc5 => '왕조';

  @override
  String get chWc5Desc => '세계 선수권에서 5회 우승하세요.';

  @override
  String get chWc10 => '불멸';

  @override
  String get chWc10Desc => '세계 선수권에서 10회 우승하세요.';

  @override
  String get chWc2Teams => '어디든 간다';

  @override
  String get chWc2TeamsDesc => '서로 다른 2개국으로 세계 선수권에서 우승하세요.';

  @override
  String get chWc3Teams => '세계 여행자';

  @override
  String get chWc3TeamsDesc => '서로 다른 3개국으로 세계 선수권에서 우승하세요.';

  @override
  String get chWcStreak3 => '3연패';

  @override
  String get chWcStreak3Desc => '세계 선수권 3회 연속 우승을 달성하세요.';

  @override
  String get chWcAllconf => '세계 정복자';

  @override
  String get chWcAllconfDesc => '모든 대륙 연맹(6개)의 국가로 세계 선수권에서 우승하세요.';

  @override
  String get chCont5 => '대륙의 왕';

  @override
  String get chCont5Desc => '대륙 선수권에서 5회 우승하세요.';

  @override
  String get chContAll => '6대륙 슬램';

  @override
  String get chContAllDesc => '모든 대륙 연맹의 대륙 선수권(6개)에서 우승하세요.';

  @override
  String get chTreble => '싹쓸이';

  @override
  String get chTrebleDesc => '한 커리어에서 세계 선수권, 대륙 선수권, 네이션스컵을 모두 우승하세요.';

  @override
  String get chNations10 => '유목민';

  @override
  String get chNations10Desc => '서로 다른 10개국을 지휘하세요.';

  @override
  String get chYears100 => '한 세기';

  @override
  String get chYears100Desc => '100년 동안 감독을 맡으세요.';

  @override
  String get chYears500 => '반천년';

  @override
  String get chYears500Desc => '500년 동안 감독을 맡으세요.';

  @override
  String get chYears1000 => '영원';

  @override
  String get chYears1000Desc => '1000년 동안 감독을 맡으세요.';

  @override
  String get chGrandmaster => '그랜드마스터';

  @override
  String get chGrandmasterDesc => '세계 선수권 3회와 대륙 선수권 5회 우승을 모두 달성하세요.';

  @override
  String get chUndefeated => '철옹성';

  @override
  String get chUndefeatedDesc => '한 경기도 지지 않고 세계 선수권에서 우승하세요.';

  @override
  String get chPerfectQual => '완벽한 통과';

  @override
  String get chPerfectQualDesc => '세계 선수권 예선 전 경기에서 승리하세요.';

  @override
  String get chMinnow => '약체의 기적';

  @override
  String get chMinnowDesc => '세계 랭킹 32위 밖의 국가로 세계 선수권에서 우승하세요.';

  @override
  String get chGrandTour => '홈 앤드 어웨이';

  @override
  String get chGrandTourDesc => '개최국으로 한 번, 원정에서 한 번 세계 선수권에서 우승하세요.';

  @override
  String get chUnbeaten25 => '통곡의 벽';

  @override
  String get chUnbeaten25Desc => '공식 경기 25경기 연속 무패를 기록하세요.';

  @override
  String get chGoals10k => '골 머신';

  @override
  String get chGoals10kDesc => '커리어 통산 10,000골을 기록하세요.';

  @override
  String get chCleanSheets500 => '요새';

  @override
  String get chCleanSheets500Desc => '커리어 통산 무실점 500회를 기록하세요.';

  @override
  String get chHatTricks25 => '해트트릭 습관';

  @override
  String get chHatTricks25Desc => '선수들이 해트트릭 25회를 기록하게 하세요.';

  @override
  String get chWinStreak25 => '멈추지 않는 질주';

  @override
  String get chWinStreak25Desc => '25연승을 달성하세요.';

  @override
  String get chCont10 => '대륙의 왕조';

  @override
  String get chCont10Desc => '대륙 선수권에서 10회 우승하세요.';

  @override
  String get chPcWc => '연속 챔피언';

  @override
  String chPcWcDesc(int count) {
    return '이 저장 파일에서 세계 선수권 $count회 우승을 달성하세요.';
  }

  @override
  String get chPcMajors => '트로피 수집가';

  @override
  String chPcMajorsDesc(int count) {
    return '주요 트로피(세계 선수권, 대륙 선수권, 네이션스컵) $count개를 차지하세요.';
  }

  @override
  String get chPcUnbeaten => '철벽';

  @override
  String chPcUnbeatenDesc(int count) {
    return '공식 경기 $count경기 연속 무패를 기록하세요.';
  }

  @override
  String get chPcNations => '떠돌이 감독';

  @override
  String chPcNationsDesc(int count) {
    return '서로 다른 $count개국을 지휘하세요.';
  }

  @override
  String get chPcYears => '기나긴 여정';

  @override
  String chPcYearsDesc(int count) {
    return '$count년 동안 감독을 맡으세요.';
  }

  @override
  String achWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count승',
      one: '1승',
    );
    return '$_temp0';
  }

  @override
  String achWinsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count경기에서 승리하세요.',
      one: '1경기에서 승리하세요.',
    );
    return '$_temp0';
  }

  @override
  String achMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count경기',
    );
    return '$_temp0';
  }

  @override
  String achMatchesDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count경기를 치르세요.',
      one: '1경기를 치르세요.',
    );
    return '$_temp0';
  }

  @override
  String get achQualWc => '세계 선수권 본선 진출';

  @override
  String get achQualWcDesc => '세계 선수권 출전권을 획득하세요.';

  @override
  String get achQualCont => '대륙 선수권 본선 진출';

  @override
  String get achQualContDesc => '대륙 선수권 출전권을 획득하세요.';

  @override
  String get achTitleWc => '세계 챔피언';

  @override
  String get achTitleWcDesc => '세계 선수권에서 우승하세요.';

  @override
  String get achTitleEuro => '유럽 챔피언';

  @override
  String get achTitleEuroDesc => '유럽 선수권에서 우승하세요.';

  @override
  String get achTitleCopa => '남미 챔피언';

  @override
  String get achTitleCopaDesc => '남미컵에서 우승하세요.';

  @override
  String get achTitleAfcon => '아프리카 챔피언';

  @override
  String get achTitleAfconDesc => '아프리카 선수권에서 우승하세요.';

  @override
  String get achTitleAsia => '아시아 챔피언';

  @override
  String get achTitleAsiaDesc => '아시아 선수권에서 우승하세요.';

  @override
  String get achTitleConcacaf => '북중미 챔피언';

  @override
  String get achTitleConcacafDesc => '북중미컵에서 우승하세요.';

  @override
  String get achTitleOfc => '오세아니아 챔피언';

  @override
  String get achTitleOfcDesc => '오세아니아컵에서 우승하세요.';

  @override
  String get achTitleNations => '네이션스컵 우승';

  @override
  String get achTitleNationsDesc => '네이션스컵에서 우승하세요.';

  @override
  String get achTitleClash => '대륙 대항전 우승';

  @override
  String get achTitleClashDesc => '대륙 대항전에서 우승하세요.';

  @override
  String get achMarksman => '세계 선수권 골잡이';

  @override
  String get achMarksmanDesc => '스쿼드 선수가 세계 선수권 본선에서 6골 이상 넣게 하세요.';

  @override
  String get achSweep => '싹쓸이';

  @override
  String get achSweepDesc => '한 커리어에서 세계 선수권과 대륙 선수권 우승을 모두 달성하세요.';

  @override
  String get achAllstar => '대회 올스타';

  @override
  String get achAllstarDesc => '선수가 세계 선수권 대회 베스트 11에 선정되게 하세요.';

  @override
  String get achGoldenboot => '골든 부트';

  @override
  String get achGoldenbootDesc => '우리 선수가 대회 득점왕에 오르게 하세요.';

  @override
  String get achDemolition => '완파';

  @override
  String get achDemolitionDesc => '5골 차 이상으로 승리하세요.';

  @override
  String get achievementsNice => '좋아요!';

  @override
  String get achievementsHardestTests => '커리어 전체와 여러 국가에 걸친, 감독으로서 가장 어려운 시험.';

  @override
  String get achievementsThisSave => '이 저장 파일';

  @override
  String get achievementsBrutalBadge => '극악';

  @override
  String get paywallGoPro => '무제한으로 전환';

  @override
  String get paywallOneTimeUnlock => '1회 결제로 잠금 해제. 구독 없음.';

  @override
  String get paywallBenefitCarryOn =>
      '이 저장 파일은 멈춘 그 자리에서 이어집니다. 모든 출전 기록, 기록, 라이벌 관계가 그대로 남습니다.';

  @override
  String get paywallBenefitNoAds =>
      '광고, 소액 결제, 구독 모두 없습니다. 한 번 결제하면 앞으로의 모든 업데이트도 당신의 것입니다.';

  @override
  String get paywallBenefitSaves =>
      '원하는 만큼 저장 파일을 만드세요. 우승 후보와 약체를 동시에 운영하며 같은 게임이 얼마나 다르게 펼쳐지는지 확인하세요.';

  @override
  String get paywallBenefitEndless =>
      '앞으로의 모든 대회 주기. 오늘 열일곱 살 유망주를 뽑고, 2034년에 당신의 안목이 옳았는지 확인하세요.';

  @override
  String get paywallUnlocked => '무제한이 잠금 해제되었습니다. 즐기세요!';

  @override
  String get paywallContactingStore => '스토어에 연결하는 중…';

  @override
  String paywallUnlockProPriced(String price) {
    return '무제한 잠금 해제 · $price';
  }

  @override
  String get paywallRestorePurchases => '구매 복원';

  @override
  String get paywallStoreUnavailable => '스토어를 사용할 수 없음';

  @override
  String get paywallStoreUnavailableNote =>
      '가격을 불러오지 못했습니다. 연결 상태를 확인하고 다시 시도하세요.';

  @override
  String get paywallTryAgain => '다시 시도';

  @override
  String get gateTitle => '첫 번째 대회 주기가 끝났습니다';

  @override
  String get gateLead => '4년은 대회 주기 한 번입니다. 당신이 옳았는지 확인하기에는 충분하지 않습니다.';

  @override
  String get gatePriceLead => '한 번 결제로 영원히';

  @override
  String get gateBuy => '구매하고 계속하기';

  @override
  String get gateExit => '나가기';

  @override
  String get gateSaveTitle => '이 저장 파일은 Pro가 필요합니다';

  @override
  String get gateSaveLead =>
      '무료 주기가 지난 저장 파일과 Pro 캠페인은 Pro로 계속할 수 있습니다. 잃는 것은 없습니다. 저장 파일은 떠날 때 그대로 남아 있습니다.';

  @override
  String get careerSaveLockedNote => '이 저장 파일을 계속하려면 Pro가 필요합니다';

  @override
  String get federationNaturalisation => '귀화';

  @override
  String federationNaturalisedTitle(String name) {
    return '$name 귀화 완료';
  }

  @override
  String federationNaturalisedBody(String name, String nation) {
    return '$name 선수가 국적 변경을 마치고 $nation 대표팀 자격을 얻었습니다. 스쿼드 선택에서 소집하세요.';
  }

  @override
  String federationCouldNotLoadOffer(String error) {
    return '제안을 불러올 수 없습니다.\n$error';
  }

  @override
  String get federationContinue => '계속';

  @override
  String get federationOfferToSwitchAllegiance => '국적 변경 제안';

  @override
  String federationPlayerMeta(String position, int age, String nation) {
    return '$position · $age세 · $nation 출신';
  }

  @override
  String federationNaturalisationBlurb(
    String name,
    String playerNation,
    String sourceNation,
  ) {
    return '$name 선수는 $playerNation에 연고가 있으며 귀화할 의사가 있습니다. 수락하면 선발할 수 있고, 거절하면 $sourceNation 소속으로 남습니다.';
  }

  @override
  String get federationDecline => '거절';

  @override
  String get federationNaturalise => '귀화 수락';

  @override
  String get federationBudgetLater => '나중에 결정';

  @override
  String get federationSetYourBudget => '예산 설정';

  @override
  String federationCouldNotLoadFinances(String error) {
    return '재정 정보를 불러올 수 없습니다.\n$error';
  }

  @override
  String get federationSaveNotFound => '저장 파일을 찾을 수 없습니다.';

  @override
  String get federationBudgetHeading => '협회 예산';

  @override
  String federationDistributeBudget(String amount) {
    return '총 $amount의 예산을 각 부서에 배분해 대회 주기를 시작하세요. 현명하게 쓰세요.';
  }

  @override
  String federationOverBudget(String amount) {
    return '협회 보유액보다 $amount 많습니다. 일부를 줄이세요';
  }

  @override
  String get federationAllocateFullBudget => '예산 전액을 배분해야 대회 주기를 시작할 수 있습니다.';

  @override
  String get federationConfirming => '확정하는 중…';

  @override
  String get federationConfirmBudget => '예산 확정';

  @override
  String get federationFinances => '재정';

  @override
  String get federationInvestmentUpdated => '투자 계획이 업데이트되었습니다.';

  @override
  String get federationDevelopment => '협회 시설';

  @override
  String get federationProjectedAtSeasonEnd => '시즌 종료 시 예상';

  @override
  String get federationCentralFunding => '중앙 지원금';

  @override
  String get federationPrizeMoneySoFar => '현재까지 상금';

  @override
  String get federationCommercialReturn => '상업 수익';

  @override
  String get federationThisSeasonLocked => '이번 시즌 (확정)';

  @override
  String get federationInvestForNextSeason => '다음 시즌 투자';

  @override
  String get federationNextSeasonImpact => '다음 시즌 효과';

  @override
  String get federationSaving => '저장하는 중…';

  @override
  String get federationConfirmInvestment => '투자 확정';

  @override
  String get federationBalance => '협회 잔액';

  @override
  String get federationCommittedToStaff => '스태프 급여 예정분';

  @override
  String get federationFreeToSpend => '사용 가능 금액';

  @override
  String get federationWagesNote =>
      '급여는 대회 주기 말에 잔액에서 빠져나가므로 이만큼은 이미 쓸 곳이 정해져 있습니다.';

  @override
  String get federationInvestAtCeremony => '다음 시즌 투자는 대회 주기 종료 행사에서 정합니다.';

  @override
  String federationLevelBadge(int level) {
    return 'L$level';
  }

  @override
  String get federationAcademyProspects => '유소년 유망주';

  @override
  String federationPlusOverall(int value) {
    return '종합 +$value';
  }

  @override
  String get federationInjuryRisk => '부상 위험';

  @override
  String get federationNaturalisationChance => '귀화 확률';

  @override
  String get federationBoardPatience => '이사회 인내심';

  @override
  String get federationUnallocated => '미배분';

  @override
  String get nationsVitrineTitle => '국가 진열장';

  @override
  String nationsCouldNotLoad(String error) {
    return '국가를 불러올 수 없습니다.\n$error';
  }

  @override
  String get nationsNoNation => '국가가 없습니다.';

  @override
  String get nationsHonours => '우승 경력';

  @override
  String get nationsRankingHistory => '세계 랭킹 변천';

  @override
  String get nationsTopScorers => '역대 최다 득점';

  @override
  String get nationsTitles => '우승';

  @override
  String get nationsYourTeam => '우리 팀';

  @override
  String get nationsWorld => '세계';

  @override
  String get nationsWorldCup => '세계 선수권';

  @override
  String get nationsContinental => '대륙 선수권';

  @override
  String nationsAppearances(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count회 출전',
      one: '1회 출전',
    );
    return '$_temp0';
  }

  @override
  String get nationsNotEnoughHistory =>
      '아직 기록이 부족합니다. 대회 주기를 한두 번 치른 뒤 다시 확인하세요.';

  @override
  String nationsBestRank(int rank) {
    return '최고: $rank위';
  }

  @override
  String nationsNowRank(int rank) {
    return '현재: $rank위';
  }

  @override
  String get nationsNoGoals => '아직 기록된 골이 없습니다.';

  @override
  String get nationsGoalsAbbrev => '골';

  @override
  String get nationsHosts => '개최';

  @override
  String get nationsSelectTitle => '대표팀 선택';

  @override
  String nationsCouldNotLoadNations(String error) {
    return '국가 목록을 불러올 수 없습니다.\n$error';
  }

  @override
  String get nationsNoMatch => '일치하는 국가가 없습니다.';

  @override
  String get nationsSelectHeading => '대표팀 선택';

  @override
  String get nationsSearchHint => '국가 검색…';

  @override
  String get nationsRank => '랭킹 ';

  @override
  String get nationsPremium => '프리미엄';

  @override
  String get nationsSelect => '선택';

  @override
  String get statsTeamRecords => '팀 기록';

  @override
  String get statsRecordBook => '기록집';

  @override
  String statsCouldNotLoadStats(String error) {
    return '통계를 불러올 수 없습니다.\n$error';
  }

  @override
  String get statsNoData => '데이터가 없습니다.';

  @override
  String get statsTopScorers => '득점 순위';

  @override
  String get statsMostGamesPlayed => '최다 출전';

  @override
  String get statsTeam => '팀';

  @override
  String get statsTopScorersShort => '득점';

  @override
  String get statsMostGames => '최다 출전';

  @override
  String get statsNoGoalsRecorded => '아직 기록된 골이 없습니다.';

  @override
  String get statsUnknown => '알 수 없음';

  @override
  String get playerTitle => '선수';

  @override
  String playerLoadError(String error) {
    return '선수를 불러올 수 없습니다.\n$error';
  }

  @override
  String get playerNotFound => '선수를 찾을 수 없습니다.';

  @override
  String get playerClub => '소속 클럽';

  @override
  String get playerClubRole => '클럽 내 입지';

  @override
  String get playerPosition => '포지션';

  @override
  String get playerPotential => '잠재력';

  @override
  String get playerAge => '나이';

  @override
  String get playerValue => '몸값';

  @override
  String get clubFirstChoice => '매주 출전';

  @override
  String get clubRotation => '로테이션';

  @override
  String get clubFringe => '출전 드묾';

  @override
  String get clubFrozenOut => '출전 없음';

  @override
  String clubAtClub(String club, String standing) {
    return '$club: $standing';
  }

  @override
  String yWinUpset0(String opponent, String score) {
    return '축구 30년을 봤지만 이건 예상 못 했다. $opponent 상대 $score 승리.';
  }

  @override
  String yWinUpset1(String opponent, String score) {
    return '$opponent전, 아무도 기대 안 했지. $score. 정말 아무도.';
  }

  @override
  String yWinUpset2(String opponent, String score) {
    return '$opponent 상대 $score. 가서 이웃들 다 깨워라.';
  }

  @override
  String yWinUpset3(String opponent, String score) {
    return '손주들한테 들려줄 그런 밤이다. $opponent전 $score.';
  }

  @override
  String yWinUpset4(String opponent, String score) {
    return '$opponent 상대 $score. 어떻게 됐든, 이겼다.';
  }

  @override
  String yWinUpset5(String opponent, String score) {
    return '서류상으로는 시작 전에 끝난 경기였다. $opponent전 $score, 결과는 달랐다.';
  }

  @override
  String yWinUpset6(String opponent, String score) {
    return '$opponent에 $score 승리. 1년 뒤엔 아무도 이 스코어를 안 믿을 거다.';
  }

  @override
  String yWinUpset7(String opponent, String score) {
    return '$opponent전 $score. 즐겨라, 그리고 다음 일정표를 봐라.';
  }

  @override
  String yWinUpset8(String opponent, String score) {
    return '$opponent 상대 $score. 90분 중 80분은 운이 따랐다.';
  }

  @override
  String yWinUpset9(String opponent, String score) {
    return '$opponent전 하룻밤으로 1년이 지워지진 않는다. $score.';
  }

  @override
  String yWinUpset10(String opponent, String score) {
    return '$opponent에 $score 승리. 이제 반등했다는 소리 듣겠지. 아니다.';
  }

  @override
  String yWinUpset11(String opponent, String score) {
    return '$opponent전 $score. 훌륭하다. 중요한 경기 때 다시 물어봐라.';
  }

  @override
  String yWinRoutine0(String opponent, String score) {
    return '$opponent에 $score 승리. 딱 그래야 하는 대로였고, 그것도 즐거움이다.';
  }

  @override
  String yWinRoutine1(String opponent, String score) {
    return '$opponent 상대 $score. 냉정했다. 칭찬이다.';
  }

  @override
  String yWinRoutine2(String opponent, String score) {
    return '$opponent전 $score. 소란도, 위기도, 불만도 없다.';
  }

  @override
  String yWinRoutine3(String opponent, String score) {
    return '$opponent 상대 깔끔한 $score. 좋은 팀은 조용한 날에도 이렇다.';
  }

  @override
  String yWinRoutine4(String opponent, String score) {
    return '$opponent 상대 $score. 할 일은 했고, 배운 건 없다.';
  }

  @override
  String yWinRoutine5(String opponent, String score) {
    return '$opponent에 $score 승리. 이겨야 했고, 이겼다.';
  }

  @override
  String yWinRoutine6(String opponent, String score) {
    return '$opponent 상대 프로다운 $score. 다음.';
  }

  @override
  String yWinRoutine7(String opponent, String score) {
    return '$opponent전 $score 정리. 기록해 두고 넘어가자.';
  }

  @override
  String yWinRoutine8(String opponent, String score) {
    return '$opponent 상대 $score인데 박수를 치라고? 저런 팀 이긴 걸로?';
  }

  @override
  String yWinRoutine9(String opponent, String score) {
    return '$opponent전 $score 승리, 다들 수고했다. 뭐, 그렇다고 치자.';
  }

  @override
  String yWinRoutine10(String opponent, String score) {
    return '$opponent전 $score. 저런 팀을 이기는 건 기본이지 업적이 아니다.';
  }

  @override
  String yWinRoutine11(String opponent, String score) {
    return '$opponent 상대 $score 승리, 그런데 힘겨워 보였다.';
  }

  @override
  String yWinTight0(String opponent, String score) {
    return '$opponent 상대 $score. 1분 1초가 다 땀의 결과다.';
  }

  @override
  String yWinTight1(String opponent, String score) {
    return '근성이 필요한 경기였다. $opponent전 $score.';
  }

  @override
  String yWinTight2(String opponent, String score) {
    return '$opponent에 $score, 어렵게 이겼다. 그래야 오래 간다.';
  }

  @override
  String yWinTight3(String opponent, String score) {
    return '$opponent 상대 $score. 이런 경기를 이기는 팀이 6월까지 살아남는다.';
  }

  @override
  String yWinTight4(String opponent, String score) {
    return '조마조마하고 볼품없었지만 승리다. $opponent전 $score.';
  }

  @override
  String yWinTight5(String opponent, String score) {
    return '$opponent에 $score 승리. 승점 3점 챙기고 다시는 돌려보지 말자.';
  }

  @override
  String yWinTight6(String opponent, String score) {
    return '$score. $opponent 상대로 한 뼘 한 뼘이 전쟁이었다.';
  }

  @override
  String yWinTight7(String opponent, String score) {
    return '$opponent전 $score. 예쁘진 않다. 그래도 똑같이 3점이다.';
  }

  @override
  String yWinTight8(String opponent, String score) {
    return '$opponent 상대 $score. 실제보다 열 배는 어렵게 만들었다.';
  }

  @override
  String yWinTight9(String opponent, String score) {
    return '$opponent 상대로 버티기나 하고 있으면 안 되지. $score.';
  }

  @override
  String yWinTight10(String opponent, String score) {
    return '$opponent전 $score. 이기긴 했는데 우리에 대해 좋은 건 하나도 못 배웠다.';
  }

  @override
  String yWinTight11(String opponent, String score) {
    return '$opponent 상대 $score, 스코어가 우리를 너무 좋게 포장했다.';
  }

  @override
  String yDrew0(String opponent, String score) {
    return '$opponent 상대 승점 1점, $score. 받아들이고 넘어가자.';
  }

  @override
  String yDrew1(String opponent, String score) {
    return '$opponent전 $score. 이보다 나쁜 오후도 많다.';
  }

  @override
  String yDrew2(String opponent, String score) {
    return '$opponent전 $score 무승부. 모든 게 이야깃거리일 필요는 없다.';
  }

  @override
  String yDrew3(String opponent, String score) {
    return '$opponent전 $score. 1점은 1점이고 순위표는 과정을 묻지 않는다.';
  }

  @override
  String yDrew4(String opponent, String score) {
    return '$opponent전 $score. 2점을 잃었나, 1점을 얻었나. 기분대로 골라라.';
  }

  @override
  String yDrew5(String opponent, String score) {
    return '$opponent전 무승부, $score. 기쁜 사람도, 화난 사람도 없다.';
  }

  @override
  String yDrew6(String opponent, String score) {
    return '$opponent전 $score. 올해 가장 기억에 안 남을 90분.';
  }

  @override
  String yDrew7(String opponent, String score) {
    return '$opponent전 $score, 사이좋게 나눠 가졌다. 계속 가자.';
  }

  @override
  String yDrew8(String opponent, String score) {
    return '$opponent 상대 $score. 이런 무승부로 캠페인은 조용히 죽어 간다.';
  }

  @override
  String yDrew9(String opponent, String score) {
    return '$opponent 상대로 승점 2점을 내다 버렸다. $score. 달리 할 말이 없다.';
  }

  @override
  String yDrew10(String opponent, String score) {
    return '$opponent전 $score. 90분이 있었는데 뭘 해야 할지 몰랐다.';
  }

  @override
  String yDrew11(String opponent, String score) {
    return '$opponent전 $score, 아무도 기억 못 하겠지만 모두가 대가를 치를 경기.';
  }

  @override
  String yLost0(String opponent, String score) {
    return '$opponent에게 $score 패배. 그럴 수도 있다.';
  }

  @override
  String yLost1(String opponent, String score) {
    return '$opponent전 $score. 누구를 탓할 일은 아니다. 다음 경기로.';
  }

  @override
  String yLost2(String opponent, String score) {
    return '$opponent에게 $score 패배, 모든 걸 쏟았다. 그래도 부족한 날이 있다.';
  }

  @override
  String yLost3(String opponent, String score) {
    return '$opponent에게 $score. 고개 들어라. 이 팀은 아직 보여줄 게 많다.';
  }

  @override
  String yLost4(String opponent, String score) {
    return '$opponent전 $score. 우리가 한 수 아래였고 반론의 여지는 없다.';
  }

  @override
  String yLost5(String opponent, String score) {
    return '$opponent에게 $score 패배. 재정비하자.';
  }

  @override
  String yLost6(String opponent, String score) {
    return '$opponent에게 $score. 망신은 아니지만 충분하지도 않다.';
  }

  @override
  String yLost7(String opponent, String score) {
    return '$opponent에게 $score 패배. 여기서 뭔가 배우지 못하면 헛된 경기다.';
  }

  @override
  String yLost8(String opponent, String score) {
    return '$opponent에게 $score, 제대로 된 펀치 한 번 못 날렸다.';
  }

  @override
  String yLost9(String opponent, String score) {
    return '$opponent에게 패배, $score. 같은 문제, 같은 달, 곧 같은 변명.';
  }

  @override
  String yLost10(String opponent, String score) {
    return '$opponent전 $score. 언제까지 불운 탓을 할 건가?';
  }

  @override
  String yLost11(String opponent, String score) {
    return '$opponent에게 $score 패배. 누군가는 책임져야 할 결과다.';
  }

  @override
  String yLostBadly0(String opponent, String score) {
    return '$opponent에게 $score. 나쁜 밤 하나일 뿐. 이 경기 말고 캠페인 전체로 평가하자.';
  }

  @override
  String yLostBadly1(String opponent, String score) {
    return '$opponent전 $score, 그 누구보다 선수들이 제일 원치 않았을 결과다.';
  }

  @override
  String yLostBadly2(String opponent, String score) {
    return '$opponent전 $score. 끔찍하다. 이건 우리 팀의 진짜 모습이 아니다.';
  }

  @override
  String yLostBadly3(String opponent, String score) {
    return '$opponent전, 잊고 싶은 $score. 다음엔 맞설 거다.';
  }

  @override
  String yLostBadly4(String opponent, String score) {
    return '$score. 상대는 $opponent. 말하는 게 직업인데 할 말이 없다.';
  }

  @override
  String yLostBadly5(String opponent, String score) {
    return '$opponent전 $score. 누군가 책임져야 한다.';
  }

  @override
  String yLostBadly6(String opponent, String score) {
    return '$opponent전 $score, 기록에서도 기억에서도 지워 버리고 싶다.';
  }

  @override
  String yLostBadly7(String opponent, String score) {
    return '$opponent에게 $score 패배. 이런 스코어는 포장할 방법이 없다.';
  }

  @override
  String yLostBadly8(String opponent, String score) {
    return '$opponent전은 패배가 아니라 항복이었다. $score.';
  }

  @override
  String yLostBadly9(String opponent, String score) {
    return '$score. 상대는 $opponent. 사람들이 돈 내고 저걸 봤다.';
  }

  @override
  String yLostBadly10(String opponent, String score) {
    return '$opponent전 $score. 이걸로 아무것도 안 바뀐다면, 앞으로도 안 바뀐다.';
  }

  @override
  String yLostBadly11(String opponent, String score) {
    return '이 팀이 굴욕당하는 건 전에도 봤지만, $opponent에게 $score 패배라니, 새로운 바닥이다.';
  }

  @override
  String yWinUpset12(String opponent, String score) {
    return '$opponent 상대 $score 승리. 날짜 적어 둬라, 그때 어디 있었냐고 다들 물을 거다.';
  }

  @override
  String yWinUpset13(String opponent, String score) {
    return '라커룸 밖에선 아무도 안 믿었다. $opponent 상대 $score. 자랑스럽다는 말로는 부족하다.';
  }

  @override
  String yWinUpset14(String opponent, String score) {
    return '$opponent 상대 $score! 전원이 남은 힘을 다 쏟아부었다.';
  }

  @override
  String yWinUpset15(String opponent, String score) {
    return '거인 사냥. $opponent, $score. 이래서 우리가 매번 경기장에 온다.';
  }

  @override
  String yWinUpset16(String opponent, String score) {
    return '$opponent 상대 $score. 예상은 방금 창밖으로 날아갔다.';
  }

  @override
  String yWinUpset17(String opponent, String score) {
    return '압도적 우승 후보: $opponent. 최종 스코어: 우리 쪽 $score.';
  }

  @override
  String yWinUpset18(String opponent, String score) {
    return '올해 최대 이변 중 하나: $opponent 상대 $score.';
  }

  @override
  String yWinUpset19(String opponent, String score) {
    return '$opponent $score. 아무도 예상 못 했고, 아무도 제대로 설명 못 한다.';
  }

  @override
  String yWinUpset20(String opponent, String score) {
    return '$opponent 상대 $score. 좋다. 이제 다들 올해 나머지가 얼마나 형편없었는지 잊겠지.';
  }

  @override
  String yWinUpset21(String opponent, String score) {
    return '$opponent 상대 $score, 그리고 벌써 만원 버스다. 난 텅 비었을 때부터 타고 있었다.';
  }

  @override
  String yWinUpset22(String opponent, String score) {
    return '$opponent $score. 훌륭하다. 그래도 어떻게든 날려 버릴 방법을 찾겠지.';
  }

  @override
  String yWinUpset23(String opponent, String score) {
    return '$opponent전 대단한 밤, $score. 제비 한 마리가 왔다고 봄이 오는 건 아니다.';
  }

  @override
  String yLostBadly12(String opponent, String score) {
    return '$opponent 상대 $score. 아끼니까 아픈 거다. 그래도 응원하자.';
  }

  @override
  String yLostBadly13(String opponent, String score) {
    return '$opponent전 잊고 싶은 밤, $score. 가장 아픈 건 선수들이다.';
  }

  @override
  String yLostBadly14(String opponent, String score) {
    return '$opponent $score. 고개 들어라. 팀은 이걸 어떻게 받아치느냐로 평가받는다.';
  }

  @override
  String yLostBadly15(String opponent, String score) {
    return '$opponent 상대 $score. 나쁘다, 맞다. 세상의 끝, 아니다.';
  }

  @override
  String yLostBadly16(String opponent, String score) {
    return '$opponent 상대 $score. 몇 년은 회자될 결과다, 나쁜 의미로.';
  }

  @override
  String yLostBadly17(String opponent, String score) {
    return '$opponent 승리, $score. 이걸 보고도 다음에 놀라는 사람은 없어야 한다.';
  }

  @override
  String yLostBadly18(String opponent, String score) {
    return '오랜만에 겪는 최악의 밤 중 하나: $opponent 상대 $score.';
  }

  @override
  String yLostBadly19(String opponent, String score) {
    return '$opponent $score. 질문이 쏟아질 거다, 그래야 하고.';
  }

  @override
  String yLostBadly20(String opponent, String score) {
    return '$opponent 상대 $score. 창피하다는 말로는 턱도 없다.';
  }

  @override
  String yLostBadly21(String opponent, String score) {
    return '$opponent 상대 $score 패배. 마지막에 나가는 사람이 불 꺼라.';
  }

  @override
  String yLostBadly22(String opponent, String score) {
    return '$opponent $score. 이제 놀랍지도 않다, 그게 무섭다.';
  }

  @override
  String yLostBadly23(String opponent, String score) {
    return '$score. $opponent. 윗선의 누군가는 오늘 밤 이력서를 고쳐 써야겠다.';
  }

  @override
  String yWinRout0(String opponent, String score) {
    return '$opponent 상대 $score! 이런 축구면 온 나라가 웃는다.';
  }

  @override
  String yWinRout1(String opponent, String score) {
    return '$opponent전 $score 대승. 대단한 경기력이다.';
  }

  @override
  String yWinRout2(String opponent, String score) {
    return '$score. $opponent전. 오늘 밤은 모든 게 다 됐다.';
  }

  @override
  String yWinRout3(String opponent, String score) {
    return '$opponent전 $score 완파. 하이라이트 저장해 둬라, 나중에 또 보고 싶을 거다.';
  }

  @override
  String yWinRout4(String opponent, String score) {
    return '$opponent $score. 자기 축구를 즐기는 팀이다.';
  }

  @override
  String yWinRout5(String opponent, String score) {
    return '$opponent 상대 $score, 더 넣을 수도 있었다. 환상적이다.';
  }

  @override
  String yWinRout6(String opponent, String score) {
    return '$opponent 상대 $score. 두 번 보게 되는 스코어다.';
  }

  @override
  String yWinRout7(String opponent, String score) {
    return '$opponent 상대 $score 승리. 30분 만에 승부가 끝났다.';
  }

  @override
  String yWinRout8(String opponent, String score) {
    return '최종 스코어: $opponent 상대 $score. 오랜만의 압도적인 대승이다.';
  }

  @override
  String yWinRout9(String opponent, String score) {
    return '$opponent $score. 한 팀은 축구하러 왔고, 다른 팀은 버스에서 내리지도 않았다.';
  }

  @override
  String yWinRout10(String opponent, String score) {
    return '$score. $opponent 쪽은 아무것도 답을 못 찾았다.';
  }

  @override
  String yWinRout11(String opponent, String score) {
    return '대승: $opponent 상대 $score.';
  }

  @override
  String yWinRout12(String opponent, String score) {
    return '$opponent 상대 $score. 좋긴 한데, 기준이 될 상대는 아니다.';
  }

  @override
  String yWinRout13(String opponent, String score) {
    return '$opponent 상대 $score. 강팀 상대로 이러면 그때 깨워 줘라.';
  }

  @override
  String yWinRout14(String opponent, String score) {
    return '$opponent $score. 재밌긴 한데, 이렇게 빛나고 아무것도 못 딴 팀을 많이 봤다.';
  }

  @override
  String yWinRout15(String opponent, String score) {
    return '$score, 그리고 다들 다시 천재가 됐다. 상대: $opponent.';
  }

  @override
  String yWinRout16(String opponent, String score) {
    return '$opponent 상대 $score. 들뜨지 마라, 증명된 건 거의 없다.';
  }

  @override
  String yWinRout17(String opponent, String score) {
    return '$opponent $score. 즐겨라, 그리고 지난번 들떴을 때 어떻게 끝났는지 떠올려라.';
  }

  @override
  String yWinShootout0(String opponent) {
    return '$opponent전 승부차기 끝에 진출! 전원 강철 멘탈이다.';
  }

  @override
  String yWinShootout1(String opponent) {
    return '$opponent전 승부차기, 우리는 흔들리지 않았다. 옆 사람 안아 줘라.';
  }

  @override
  String yWinShootout2(String opponent) {
    return '$opponent전 승부차기 승리. 심장이 못 버티겠다.';
  }

  @override
  String yWinShootout3(String opponent) {
    return '$opponent전 승부차기 승. 다음 라운드로.';
  }

  @override
  String yWinShootout4(String opponent) {
    return '$opponent전은 페널티 스폿에서 갈렸고, 우리가 더 많이 넣었다.';
  }

  @override
  String yWinShootout5(String opponent) {
    return '$opponent전 승부차기 승리. 가장 힘든 길이었지만 진출.';
  }

  @override
  String yWinShootout6(String opponent) {
    return '$opponent전 승부차기 끝에 진출. 복권 당첨, 경기 내용은 잊자.';
  }

  @override
  String yWinShootout7(String opponent) {
    return '그런 경기 하고 $opponent전 승부차기 승? 운이다, 다들 안다.';
  }

  @override
  String yWinShootout8(String opponent) {
    return '$opponent전 승부차기 끝에 진출. 거기까지 갈 일이 아니었다.';
  }

  @override
  String yKnockoutWin0(String opponent, String score) {
    return '진출. $opponent 상대 $score, 꿈은 계속된다.';
  }

  @override
  String yKnockoutWin1(String opponent, String score) {
    return '토너먼트 승리: $opponent 상대 $score. 이제 온 나라가 믿어도 된다.';
  }

  @override
  String yKnockoutWin2(String opponent, String score) {
    return '$opponent 상대 $score, 다음 라운드로. 대단한 밤이다.';
  }

  @override
  String yKnockoutWin3(String opponent, String score) {
    return '$opponent 귀국길, $score. 앞으로.';
  }

  @override
  String yKnockoutWin4(String opponent, String score) {
    return '토너먼트: $opponent 상대 $score. 다음 라운드 확정.';
  }

  @override
  String yKnockoutWin5(String opponent, String score) {
    return '진출: $opponent 상대 $score.';
  }

  @override
  String yKnockoutWin6(String opponent, String score) {
    return '$opponent 탈락, $score. 다음 라운드가 기다린다.';
  }

  @override
  String yKnockoutWin7(String opponent, String score) {
    return '$opponent 상대 $score 승리. 토너먼트에선 아무도 과정을 묻지 않는다.';
  }

  @override
  String yKnockoutWin8(String opponent, String score) {
    return '$opponent전 진출, $score. 다음 상대는 이렇게 친절하지 않을 거다.';
  }

  @override
  String yKnockoutWin9(String opponent, String score) {
    return '$opponent 상대 $score, 진출엔 충분하다. 다음엔 훨씬 더 필요하다.';
  }

  @override
  String yKnockoutWin10(String opponent, String score) {
    return '$opponent 탈락, $score. 이겼다기보다 살아남았다.';
  }

  @override
  String yKnockoutWin11(String opponent, String score) {
    return '$opponent 상대 $score 후 다음 라운드. 어떻게 됐는지는 묻지 마라.';
  }

  @override
  String yUpsetGap0(String opponent, String gap) {
    return '랭킹 차이 $gap계단, 그래도 $opponent전 승리. 훌륭하다.';
  }

  @override
  String yUpsetGap1(String opponent, String gap) {
    return '$opponent: 우리보다 $gap계단 위. 그래도 이겼다. 축구는 아름답다.';
  }

  @override
  String yUpsetGap2(String opponent, String gap) {
    return '랭킹 차이: $gap. 결과: $opponent전 승리. 믿음을 멈추지 마라.';
  }

  @override
  String yUpsetGap3(String opponent, String gap) {
    return '킥오프 전 랭킹 차이: $gap. 그래도 $opponent전 승리.';
  }

  @override
  String yUpsetGap4(String opponent, String gap) {
    return '세계 랭킹에서 $opponent 대표팀은 $gap계단 위였다. 오늘 밤은 아니었다.';
  }

  @override
  String yUpsetGap5(String opponent, String gap) {
    return '이변 지수: 양 팀 랭킹 차이 $gap. $opponent전 승리는 우리 것.';
  }

  @override
  String yUpsetGap6(String opponent, String gap) {
    return '$opponent 대표팀과의 랭킹 차이는 $gap계단이었다. 하룻밤에 그 격차가 메워지진 않는다.';
  }

  @override
  String yUpsetGap7(String opponent, String gap) {
    return '$opponent: $gap계단 위, 그리고 패배. 랭킹은 거의 눈치채지 못할 거다.';
  }

  @override
  String yUpsetGap8(String gap) {
    return '랭킹 차이: $gap. 다음에 약팀한테 지면 이 숫자를 기억해라.';
  }

  @override
  String yEatWords0(String opponent) {
    return '이 팀은 끝났다고 썼다. 틀렸다. 틀려서 이렇게 기쁜 적은 없었다. $opponent전 승리.';
  }

  @override
  String yEatWords1(String opponent) {
    return '겸손 한 접시 부탁한다. 곱빼기로. $opponent전 승리는 대단했다.';
  }

  @override
  String yEatWords2(String opponent) {
    return '남은 게 없다고 했다. 넘쳐났다. $opponent전, 다들 잘했다.';
  }

  @override
  String yEatWords3(String opponent) {
    return '기록을 위해 말하자면, $opponent전 승리는 예상 못 했다. 인정할 건 인정한다.';
  }

  @override
  String yEatWords4(String opponent) {
    return '좋다. 밑천이 드러날 거라고 했다. $opponent 대표팀은 드러내지 못했다.';
  }

  @override
  String yEatWords5(String opponent) {
    return '오늘 밤 이 팀에 대해 했던 말을 주워 담는다. $opponent전 승리는 그럴 자격이 있다.';
  }

  @override
  String yEatWords6(String opponent) {
    return '그래, 끝났다고 했다. $opponent전 1승으로 내가 틀린 게 증명되진 않는다.';
  }

  @override
  String yEatWords7(String opponent) {
    return '$opponent전 끝나고 말을 주워 담으란다. 그러지, 천천히. 영수증은 챙겨 둔다.';
  }

  @override
  String yEatWords8(String opponent) {
    return '$opponent전 승리는 인상적이었다. 이 팀에 대한 의심은 그대로다.';
  }

  @override
  String yAwayFansWin0(String nation, String score) {
    return '$nation 대표팀에 박수를. $score, 처음부터 끝까지 이길 만했다.';
  }

  @override
  String yAwayFansWin1(String nation, String score) {
    return '말하기 괴롭지만 오늘 밤은 $nation 대표팀이 더 나았다. $score. 축하한다.';
  }

  @override
  String yAwayFansWin2(String nation, String score) {
    return '$score. $nation 대표팀에 경의를, 더 간절했다.';
  }

  @override
  String yAwayFansWin3(String nation, String score) {
    return '$nation 상대 $score 패배. 뭐라 해야 할지도 모르겠다.';
  }

  @override
  String yAwayFansWin4(String nation, String score) {
    return '$nation $score. 우리 선수들은 부끄러운 줄 알아야 한다.';
  }

  @override
  String yAwayFansWin5(String nation, String score) {
    return '$nation 상대 $score. 누가 이게 어떻게 된 건지 설명 좀 해 봐라.';
  }

  @override
  String yAwayFansWin6(String nation, String score) {
    return '$nation 상대 $score 패배라니. 평생 못 잊는다.';
  }

  @override
  String yAwayFansWin7(String nation, String score) {
    return '$nation 상대 $score. 운이다. 순전히 운이다.';
  }

  @override
  String yAwayFansWin8(String nation, String score) {
    return '이 $score 때문에 $nation 팬들은 몇 년은 꼴불견일 거다. 고맙다, 아주.';
  }

  @override
  String yNeutralWin0(String nation, String opponent, String score) {
    return '$nation $score $opponent. 축구에 최고의 일이다. 이래서 우리가 축구를 사랑한다.';
  }

  @override
  String yNeutralWin1(String nation, String opponent, String score) {
    return '$nation 대표팀의 엄청난 결과: $opponent 상대 $score. 축구의 묘미다.';
  }

  @override
  String yNeutralWin2(String nation, String opponent, String score) {
    return '오늘 밤 중립 팬들은 모두 $nation 대표팀 편이다. $opponent 상대 $score!';
  }

  @override
  String yNeutralWin3(String nation, String opponent, String score) {
    return '이번 라운드 결과: $nation $score $opponent.';
  }

  @override
  String yNeutralWin4(String nation, String opponent, String score) {
    return '$nation $score $opponent. 아무도 예상하지 못했다.';
  }

  @override
  String yNeutralWin5(String nation, String opponent, String score) {
    return '큰 결과: $nation $score $opponent. 랭킹이 움직인다.';
  }

  @override
  String yNeutralWin6(String nation, String opponent, String score) {
    return '$nation $score $opponent. 재밌네, 한 번 더 할 수 있는지 보자.';
  }

  @override
  String yNeutralWin7(String nation, String opponent, String score) {
    return '$nation $score $opponent. $nation 대표팀이 이긴 건가, $opponent 대표팀이 진 건가?';
  }

  @override
  String yNeutralWin8(String nation, String opponent, String score) {
    return '대이변: $nation $score $opponent. 과잉 반응이 쏟아질 테니 각오해라.';
  }

  @override
  String yScorerHero0(String name, String opponent) {
    return '$opponent전의 $name. 아이들 이름을 그의 이름으로 짓겠다.';
  }

  @override
  String yScorerHero1(String name, String opponent) {
    return '$name 선수 동상을 세우자. 오늘 밤 $opponent전에서 그가 전부였다.';
  }

  @override
  String yScorerHero2(String name, String opponent) {
    return '$name, 최고다. $opponent전의 이 밤을 기억해라.';
  }

  @override
  String yScorerHero3(String name, String opponent) {
    return '$opponent전을 결정지은 건 $name. 경기 최우수 선수, 이견 없음.';
  }

  @override
  String yScorerHero4(String name, String opponent) {
    return '$opponent전, 오늘 밤의 주인공: $name.';
  }

  @override
  String yScorerHero5(String name, String opponent) {
    return '$opponent전, 필요할 때 $name 선수가 나타났다.';
  }

  @override
  String yScorerHero6(String name, String opponent) {
    return '$opponent전 $name 선수는 압도적이었다. 이제 매주 부탁한다.';
  }

  @override
  String yScorerHero7(String name, String opponent) {
    return '$opponent전, $name 선수가 팀을 구했다. 다른 선수들은 별 도움이 안 됐다.';
  }

  @override
  String yScorerHero8(String name, String opponent) {
    return '$name 선수가 없었다면 $opponent전은 완전히 다른 밤이었다.';
  }

  @override
  String yLostShock0(String opponent, String score) {
    return '$opponent 상대 $score. 사고다. 누구에게나 한 번은 있다.';
  }

  @override
  String yLostShock1(String opponent, String score) {
    return '$opponent 상대 $score 패배. 털고 일어나자, 여정은 끝나지 않았다.';
  }

  @override
  String yLostShock2(String opponent, String score) {
    return '$opponent $score. 아프지만, 결과 하나로 이 팀이 정의되진 않는다.';
  }

  @override
  String yLostShock3(String opponent, String score) {
    return '$opponent 상대 $score. 일진이 나쁜 날. 다음으로.';
  }

  @override
  String yLostShock4(String opponent, String score) {
    return '$opponent전 패배, $score. 아무도 예상 못 했다.';
  }

  @override
  String yLostShock5(String opponent, String score) {
    return '$opponent $score. 도무지 말이 안 되는 밤 중 하나.';
  }

  @override
  String yLostShock6(String opponent, String score) {
    return '$opponent 상대 $score. 오래 기억될 패배다.';
  }

  @override
  String yLostShock7(String opponent, String score) {
    return '$opponent전 패배, $score. 어떻게 봐도 대이변이다.';
  }

  @override
  String yLostShock8(String opponent, String score) {
    return '$opponent 상대 $score. 그 상대한테! 용납 못 한다.';
  }

  @override
  String yLostShock9(String opponent, String score) {
    return '$opponent 상대 $score 패배. 변명 말고 설명을 원한다.';
  }

  @override
  String yLostShock10(String opponent, String score) {
    return '$opponent $score. 국가적 망신이다, 과장이 아니라.';
  }

  @override
  String yLostShock11(String opponent, String score) {
    return '$opponent 상대 $score. 윗선은 어떻게 아직 자리를 지키고 있나?';
  }

  @override
  String yLostRout0(String opponent, String score) {
    return '$opponent 상대 $score. 상대는 최정상급 팀이다. 배우자.';
  }

  @override
  String yLostRout1(String opponent, String score) {
    return '$opponent 대표팀에 완전히 밀렸다, $score. 최강팀에 지는 건 부끄러운 일이 아니다.';
  }

  @override
  String yLostRout2(String opponent, String score) {
    return '$opponent $score. 교훈이다, 교훈은 사람을 성장시킨다.';
  }

  @override
  String yLostRout3(String opponent, String score) {
    return '$opponent 상대 $score. 아프지만 저쪽이 한 수 위다.';
  }

  @override
  String yLostRout4(String opponent, String score) {
    return '$opponent 승리, $score. 격차는 진짜고, 이제 모두가 봤다.';
  }

  @override
  String yLostRout5(String opponent, String score) {
    return '$opponent 상대 $score. 그냥 완패다.';
  }

  @override
  String yLostRout6(String opponent, String score) {
    return '$opponent $score. 더 나은 팀이 이겼고, 스코어가 말해 준다.';
  }

  @override
  String yLostRout7(String opponent, String score) {
    return '$opponent 상대 $score 패배. 망신은 아니지만, 경기라고 할 수도 없었다.';
  }

  @override
  String yLostRout8(String opponent, String score) {
    return '$opponent 상대 $score. 강팀이든 아니든, 이렇게 지면 안 된다.';
  }

  @override
  String yLostRout9(String opponent, String score) {
    return '$opponent $score. 싸워 보려고는 했나?';
  }

  @override
  String yLostRout10(String opponent, String score) {
    return '$score. $opponent전. 도살장에 끌려간 어린 양들.';
  }

  @override
  String yLostRout11(String opponent, String score) {
    return '$opponent 상대 $score 패배, 그런데 아무도 신경 쓰는 것 같지 않았다.';
  }

  @override
  String yLostShootout0(String opponent) {
    return '$opponent전 승부차기 끝에 탈락. 모든 걸 쏟았다. 자랑스럽다.';
  }

  @override
  String yLostShootout1(String opponent) {
    return '$opponent전 승부차기. 가장 잔인한 탈락 방식이다. 고개 들어라.';
  }

  @override
  String yLostShootout2(String opponent) {
    return '$opponent전 승부차기 패배. 아무도 이런 결말을 받을 자격은 없다.';
  }

  @override
  String yLostShootout3(String opponent) {
    return '$opponent전 승부차기 끝에 탈락. 페널티 스폿이 결정했다.';
  }

  @override
  String yLostShootout4(String opponent) {
    return '$opponent 대표팀, 승부차기 끝에 진출. 우리 대회는 여기서 끝.';
  }

  @override
  String yLostShootout5(String opponent) {
    return '$opponent전 승부차기 패배. 또 승부차기다.';
  }

  @override
  String yLostShootout6(String opponent) {
    return '$opponent전 승부차기 끝에 탈락. 연습은 하긴 하나?';
  }

  @override
  String yLostShootout7(String opponent) {
    return '$opponent전 승부차기 패배. 훨씬 전에 끝냈어야 했다.';
  }

  @override
  String yLostShootout8(String opponent) {
    return '$opponent전 승부차기, 그리고 졌다. 당연하지.';
  }

  @override
  String yKnockoutLoss0(String opponent, String score) {
    return '탈락. $opponent 상대 $score. 자랑스러운 여정이 여기서 끝난다.';
  }

  @override
  String yKnockoutLoss1(String opponent, String score) {
    return '$opponent전 탈락, $score. 추억을 고맙다.';
  }

  @override
  String yKnockoutLoss2(String opponent, String score) {
    return '$opponent 상대 $score. 여정은 끝났지만, 대단한 여정이었다.';
  }

  @override
  String yKnockoutLoss3(String opponent, String score) {
    return '탈락: $opponent 상대 $score. 고개 들어라.';
  }

  @override
  String yKnockoutLoss4(String opponent, String score) {
    return '종료: $opponent 상대 $score.';
  }

  @override
  String yKnockoutLoss5(String opponent, String score) {
    return '탈락: $opponent 상대 $score.';
  }

  @override
  String yKnockoutLoss6(String opponent, String score) {
    return '$opponent 진출, $score. 우리 대회는 끝났다.';
  }

  @override
  String yKnockoutLoss7(String opponent, String score) {
    return '$opponent전 탈락, $score. 이제 부검이 시작된다.';
  }

  @override
  String yKnockoutLoss8(String opponent, String score) {
    return '탈락. $opponent 상대 $score. 대회는 달라도 결말은 같다.';
  }

  @override
  String yKnockoutLoss9(String opponent, String score) {
    return '$opponent 상대 $score, 그리고 귀국. 아무도 놀라지 않았다.';
  }

  @override
  String yKnockoutLoss10(String opponent, String score) {
    return '$opponent전 탈락, $score. 아침까지 변명이 나올 거다.';
  }

  @override
  String yKnockoutLoss11(String opponent, String score) {
    return '$opponent $score. 탈락, 다른 결말이 날 것 같은 순간은 한 번도 없었다.';
  }

  @override
  String yAwayFansGloat0(String nation, String score) {
    return '$nation 상대 $score. 존중한다, 더 강해져서 돌아올 거다.';
  }

  @override
  String yAwayFansGloat1(String nation, String score) {
    return '우리에겐 좋은 승리, $score. $nation 대표팀엔 나쁜 날, 팬들이 안됐다.';
  }

  @override
  String yAwayFansGloat2(String nation, String score) {
    return '$score. $nation 대표팀에겐 최악의 밤이었고, 우린 기회를 잡았다. 축구가 그렇다.';
  }

  @override
  String yAwayFansGloat3(String nation, String score) {
    return '$nation 상대 $score! 누가 예상했나? 저쪽은 아니겠지.';
  }

  @override
  String yAwayFansGloat4(String nation, String score) {
    return '$nation 상대 $score 승리. 누가 저쪽 팬들 상태 좀 봐 줘라.';
  }

  @override
  String yAwayFansGloat5(String nation, String score) {
    return '$nation $score. 이건 앨범에 넣는다.';
  }

  @override
  String yAwayFansGloat6(String nation, String score) {
    return '$nation 상대 $score. 그러고도 자기들이 강팀인 줄 안다.';
  }

  @override
  String yAwayFansGloat7(String nation, String score) {
    return '우리한테 $score 스코어로 지는 걸 상상해 봐라. $nation 대표팀에 물어봐, 이제 안다.';
  }

  @override
  String yAwayFansGloat8(String nation, String score) {
    return '$nation, $score. 조심히 돌아가라.';
  }

  @override
  String yNeutralLoss0(String nation, String opponent, String score) {
    return '$nation $score $opponent. $opponent 대표팀엔 최고의 밤, $nation 대표팀엔 힘든 밤.';
  }

  @override
  String yNeutralLoss1(String nation, String opponent, String score) {
    return '$opponent 상대 $score, $nation 팬들에게 힘을. 다시 일어설 거다.';
  }

  @override
  String yNeutralLoss2(String nation, String opponent, String score) {
    return '$nation $score $opponent. 어떤 강팀에게나 이런 밤은 있다.';
  }

  @override
  String yNeutralLoss3(String nation, String opponent, String score) {
    return '이번 라운드의 충격: $nation $score $opponent.';
  }

  @override
  String yNeutralLoss4(String nation, String opponent, String score) {
    return '$nation $score $opponent. 아무도 예상 못 했다.';
  }

  @override
  String yNeutralLoss5(String nation, String opponent, String score) {
    return '오늘의 결과: $nation $score $opponent. 이제 $nation 대표팀에 질문이 쏟아진다.';
  }

  @override
  String yNeutralLoss6(String nation, String opponent, String score) {
    return '$nation $score $opponent. 지켜봤다면 알 거다, 우연이 아니다.';
  }

  @override
  String yNeutralLoss7(String nation, String opponent, String score) {
    return '$nation $score $opponent. 저쪽 누군가는 해명할 게 많을 거다.';
  }

  @override
  String yNeutralLoss8(String nation, String opponent, String score) {
    return '$nation $score $opponent. 이름값에 못 미치는 경기력.';
  }

  @override
  String yDownGap0(String opponent, String gap) {
    return '$opponent: 우리보다 $gap계단 아래. 그럴 수 있다. 다음으로.';
  }

  @override
  String yDownGap1(String gap) {
    return '랭킹 차이: 우리가 $gap계단 위. 축구는 랭킹을 읽지 않는다.';
  }

  @override
  String yDownGap2(String opponent, String gap) {
    return '서류상 $opponent 대표팀과 $gap계단 차이. 오늘 밤 그라운드에선 아니었다.';
  }

  @override
  String yDownGap3(String opponent, String gap) {
    return '킥오프 전 랭킹 차이: 우리가 $gap계단 위. 그래도 $opponent전 패배.';
  }

  @override
  String yDownGap4(String opponent, String gap) {
    return '세계 랭킹에서 $opponent 대표팀은 $gap계단 아래였다. 결과: 패배.';
  }

  @override
  String yDownGap5(String opponent, String gap) {
    return '이변 지수: 랭킹 차이 $gap, 반대 방향으로. $opponent전.';
  }

  @override
  String yDownGap6(String opponent, String gap) {
    return '랭킹에서 $opponent 대표팀보다 $gap계단 위. 패배. 설명해 봐라.';
  }

  @override
  String yDownGap7(String gap) {
    return '$gap계단 아래 팀에 졌다. 이 숫자를 곱씹어라.';
  }

  @override
  String yDownGap8(String opponent, String gap) {
    return '랭킹 차이: $gap. $opponent전 패배. 누군가는 날짜를 세기 시작해야 한다.';
  }

  @override
  String yDrewHeroic0(String opponent, String score) {
    return '$opponent 상대 $score! 승리 같은 무승부다.';
  }

  @override
  String yDrewHeroic1(String opponent, String score) {
    return '$opponent 상대 $score. 한 명 한 명이 자랑스럽다.';
  }

  @override
  String yDrewHeroic2(String opponent, String score) {
    return '$opponent $score. 저쪽이 우승 후보였고, 우린 대등하게 맞섰다.';
  }

  @override
  String yDrewHeroic3(String opponent, String score) {
    return '$opponent 상대 $score. 피와 땀으로 따낸 승점.';
  }

  @override
  String yDrewHeroic4(String opponent, String score) {
    return '$opponent 상대 $score. 아주 값진 승점.';
  }

  @override
  String yDrewHeroic5(String opponent, String score) {
    return '$opponent 상대 $score 무승부. 뭔가를 기대한 사람은 적었다.';
  }

  @override
  String yDrewHeroic6(String opponent, String score) {
    return '$opponent 대표팀을 멈춰 세웠다, $score. 발판이 될 결과다.';
  }

  @override
  String yDrewHeroic7(String opponent, String score) {
    return '$opponent 상대 $score. 아무도 예상 못 한 승점.';
  }

  @override
  String yDrewHeroic8(String opponent, String score) {
    return '$opponent 상대 $score. 좋은 승점이지만, 무승부로는 아무것도 못 딴다.';
  }

  @override
  String yDrewHeroic9(String opponent, String score) {
    return '$opponent 상대 $score. 좋다. 제대로 된 슈팅은 하나도 없었지만.';
  }

  @override
  String yDrewHeroic10(String opponent, String score) {
    return '$opponent $score. 승점 1에 다들 우승이라도 한 것처럼 군다.';
  }

  @override
  String yDrewHeroic11(String opponent, String score) {
    return '$opponent 상대 $score. 버스 세우고 운이 따랐다.';
  }

  @override
  String yDrewShame0(String opponent, String score) {
    return '$opponent 상대 $score. 답답하지만, 아직 무패다.';
  }

  @override
  String yDrewShame1(String opponent, String score) {
    return '$opponent 상대 $score에 그쳤다. 일진이 나쁜 날. 그럴 수 있다.';
  }

  @override
  String yDrewShame2(String opponent, String score) {
    return '$opponent $score. 부족하다, 선수들도 안다.';
  }

  @override
  String yDrewShame3(String opponent, String score) {
    return '$opponent 상대 $score. 승점 2를 잃었다, 그게 다다.';
  }

  @override
  String yDrewShame4(String opponent, String score) {
    return '$opponent 상대 $score. 승점 2를 버렸다.';
  }

  @override
  String yDrewShame5(String opponent, String score) {
    return '$opponent 상대 $score에 그쳤다. 어떻게 포장해도 나쁜 결과다.';
  }

  @override
  String yDrewShame6(String opponent, String score) {
    return '$opponent $score. 패배 같은 무승부다.';
  }

  @override
  String yDrewShame7(String opponent, String score) {
    return '$opponent 상대 $score. 이런 경기는 여유 있게 이겨야 한다.';
  }

  @override
  String yDrewShame8(String opponent, String score) {
    return '$opponent 상대 $score. 창피하다.';
  }

  @override
  String yDrewShame9(String opponent, String score) {
    return '$opponent전 무승부에 그쳤다, $score. 책임은 누구에게 있나?';
  }

  @override
  String yDrewShame10(String opponent, String score) {
    return '$opponent $score. 여기를 못 이기면 어디를 이기나?';
  }

  @override
  String yDrewShame11(String opponent, String score) {
    return '$opponent 상대 $score. 저쪽 팬들이 우리와의 무승부를 자축하고 있다. 생각해 봐라.';
  }

  @override
  String yTrophy0(String opponent) {
    return '챔피언이다. $opponent. 소리 내서 말해 봐.';
  }

  @override
  String yTrophy1(String opponent) {
    return '우리가 우승했다. $opponent. 제정신이 아니다.';
  }

  @override
  String yTrophy2(String opponent) {
    return '$opponent, 트로피가 집으로 온다.';
  }

  @override
  String yTrophy3(String opponent) {
    return '한 명 한 명이 다 레전드다. $opponent.';
  }

  @override
  String yRunnerUp0(String opponent) {
    return '너무 아깝다. $opponent, 아무도 원치 않는 메달.';
  }

  @override
  String yRunnerUp1(String opponent) {
    return '$opponent 준우승. 몇 년은 쓰라릴 거다.';
  }

  @override
  String yRunnerUp2(String opponent) {
    return '$opponent: 모든 것까지 단 한 경기.';
  }

  @override
  String yRunnerUp3(String opponent) {
    return '2위. $opponent에서. 누가 술 좀 줘.';
  }

  @override
  String yEliminated0(String opponent) {
    return '$opponent에서 탈락. 한동안 아플 거다.';
  }

  @override
  String yEliminated1(String opponent) {
    return '우리의 여정은 $opponent에서 끝난다.';
  }

  @override
  String yEliminated2(String opponent) {
    return '$opponent에서 탈락. 이제 책임 추궁의 시간.';
  }

  @override
  String yEliminated3(String opponent) {
    return '$opponent에서 탈락했다. 누가 설명 좀 해 봐.';
  }

  @override
  String yQualified0(String opponent) {
    return '우리가 $opponent에 간다.';
  }

  @override
  String yQualified1(String opponent) {
    return '$opponent 본선 진출. 휴가 미리 내 둬라.';
  }

  @override
  String yQualified2(String opponent) {
    return '$opponent, 우리가 간다. 의심한 적 없다(사실 엄청 의심했다).';
  }

  @override
  String yQualified3(String opponent) {
    return '$opponent 진출. 어려운 고비는 넘겼다.';
  }

  @override
  String yGroupDrawn0(String opponent) {
    return '$opponent 조 추첨 완료. 더 나쁠 수도 있었다. 훨씬 더.';
  }

  @override
  String yGroupDrawn1(String opponent) {
    return '그러니까 이게 $opponent 조 추첨 결과라. 흥미롭군.';
  }

  @override
  String yGroupDrawn2(String opponent) {
    return '$opponent 조 편성이 나왔는데 벌써 우리 조가 마음에 안 든다.';
  }

  @override
  String yGroupDrawn3(String opponent) {
    return '$opponent 조 추첨 끝. 호들갑 시작.';
  }

  @override
  String yHostNamed0(String opponent) {
    return '$opponent에서 개최한다. 돈 모으기 시작해라.';
  }

  @override
  String yHostNamed1(String opponent) {
    return '$opponent에서 열린다. 뻔하지만, 뭐 괜찮다.';
  }

  @override
  String yHostNamed2(String opponent) {
    return '개최권은 $opponent에게. 축하한다, 뭐 그렇다고 치자.';
  }

  @override
  String yHostNamed3(String opponent) {
    return '개최국 확정: $opponent.';
  }

  @override
  String yTournamentSoon0(String opponent) {
    return '$opponent 곧 개막, 가만히 앉아 있을 수가 없다.';
  }

  @override
  String yTournamentSoon1(String opponent) {
    return '$opponent까지 얼마 안 남았다.';
  }

  @override
  String yTournamentSoon2(String opponent) {
    return '$opponent 코앞이다. 명단 발표 좀 해 줘.';
  }

  @override
  String yTournamentSoon3(String opponent) {
    return '$opponent 카운트다운, 공식적으로 못 견디겠다.';
  }

  @override
  String get navY => 'Y';

  @override
  String get yTitle => 'Y';

  @override
  String get yEmpty => '아직 할 말이 없습니다. 경기를 치르세요.';

  @override
  String get yEarlierHeading => '이번 주기 초반';

  @override
  String get yTraitLoyalist => '무슨 일이 있어도 팀을 지지한다. 쉽게 돌아서지 않고, 쉽게 용서한다.';

  @override
  String get yTraitCynic => '늘 최악을 가정하고, 자기 말이 맞으면 기뻐한다.';

  @override
  String get yTraitNostalgic => '예전엔 다 나았다. 은퇴한 선수들과 비교한다.';

  @override
  String get yTraitStatshead => '숫자만 올린다. 감정이 거의 없다.';

  @override
  String get yTraitHypeman => '좋은 결과 두 번이면 황금 세대다.';

  @override
  String get yTraitContrarian => '다들 뭐라 하든, 무조건 반대.';

  @override
  String get yTraitDoomer => '잘못될 거다. 언제나 잘못될 거다.';

  @override
  String get yProfilePosts => '게시물';

  @override
  String get yProfileEmpty => '이 계정은 아직 게시물이 없습니다.';

  @override
  String hubEventGrievance(String player) {
    return '$player 선수의 면담 요청';
  }

  @override
  String get hubEventGrievanceSub => '자신의 입지를 알고 싶어 합니다';

  @override
  String hubEventManagerSkills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '사용할 스킬 포인트 $count점',
      one: '사용할 스킬 포인트 1점',
    );
    return '$_temp0';
  }

  @override
  String get hubEventManagerSkillsSub => '감독의 장점이 팀을 더 강하게 만듭니다';

  @override
  String get grievanceTitle => '감독실 면담';

  @override
  String grievanceGameTime(String player) {
    return '$player 선수는 스쿼드에 들었지만 공 한 번 차 보지 못했습니다. 이유를 알고 싶어 합니다.';
  }

  @override
  String grievanceSquadPlace(String player) {
    return '$player 선수는 스쿼드에서 빠진 것을 납득하지 못합니다. 어느 쪽이든 분명한 답을 원합니다.';
  }

  @override
  String grievanceRole(String player) {
    return '$player 선수는 계속 비주력 포지션에 기용되는 데 지쳤습니다.';
  }

  @override
  String get grievanceReassure => '자네는 내 계획에 있네';

  @override
  String get grievanceHonest => '다른 선수들에게 밀렸고, 이유는 이렇네';

  @override
  String get grievanceDismiss => '선발은 내가 정하네';

  @override
  String yScorerStar0(String name, String goals) {
    return '$name, 혼자 $goals골. 따라올 사람이 없다.';
  }

  @override
  String yScorerStar1(String name, String goals) {
    return '$name $goals골. 이 팀을 혼자 짊어지고 있다.';
  }

  @override
  String yScorerStar2(String name, String goals) {
    return '$name: 오늘 $goals골. 대단한 선수다.';
  }

  @override
  String yScorerStar3(String name, String goals) {
    return '$name, $goals골을 꽂아 넣었다. 박수 받을 만하다.';
  }

  @override
  String yScorerStar4(String name, String goals) {
    return '$name $goals골, 나머지는 그냥 승객이었다.';
  }

  @override
  String yScorerStar5(String name, String goals) {
    return '또 $name. $goals골. 이 선수 없는 팀을 상상해 봐라.';
  }

  @override
  String yScorerStar6(String name, String goals) {
    return '$name의 $goals골. 한 명이 이렇게까지 해야 하나.';
  }

  @override
  String yScorerStar7(String name, String goals) {
    return '$name 빼면 $goals골이 줄고 완전히 다른 오후가 됐을 거다.';
  }

  @override
  String yWinStreak0(String count) {
    return '$count연승. 라커룸에서 무슨 말을 하든 통하고 있다.';
  }

  @override
  String yWinStreak1(String count) {
    return '벌써 $count연승. 이런 흐름은 우연히 오지 않는다.';
  }

  @override
  String yWinStreak2(String count) {
    return '$count연승 진행 중. 관중석에서도 자신감이 보인다.';
  }

  @override
  String yWinStreak3(String count) {
    return '$count경기 무패. 감독 해 본 사람한테 물어봐라, 그게 어려운 거다.';
  }

  @override
  String yWinStreak4(String count) {
    return '$count연승. 일정이 쉬울 때 즐겨 둬라.';
  }

  @override
  String yWinStreak5(String count) {
    return '$count연승인데, 제대로 된 상대는 하나도 없었다.';
  }

  @override
  String yWinStreak6(String count) {
    return '$count연승. 진짜 시험대에 오르면 다시 물어봐라.';
  }

  @override
  String yWinStreak7(String count) {
    return '$count연승. 어느 팀이든 이런 시기는 한 번쯤 있다.';
  }

  @override
  String yLossStreak0(String count) {
    return '벌써 $count경기 무승. 언젠가는 변명도 바닥난다.';
  }

  @override
  String yLossStreak1(String count) {
    return '$count경기 연속으로 날렸다. 더 이상 일시적인 부진이 아니다.';
  }

  @override
  String yLossStreak2(String count) {
    return '$count연패. 누군가 책임져야 한다.';
  }

  @override
  String yLossStreak3(String count) {
    return '$count경기 무승. 경기하는 모습에서 다 보인다.';
  }

  @override
  String yLossStreak4(String count) {
    return '$count경기 무승, 매주 같은 실수.';
  }

  @override
  String yLossStreak5(String count) {
    return '$count경기 연속. 뭘 시도하든 안 통하고 있다.';
  }

  @override
  String yLossStreak6(String count) {
    return '$count경기 연속. 이건 일시적 하락이 아니라 방향이다.';
  }

  @override
  String yLossStreak7(String count) {
    return '$count경기 무승인데, 윗선에서는 한마디도 없다.';
  }

  @override
  String yRivalry0(String opponent, String score) {
    return '$opponent전 $score. 내용은 뭐라 해도 좋다. 이 경기는 두 배로 친다.';
  }

  @override
  String yRivalry1(String opponent, String score) {
    return '하필 $opponent 상대로. $score. 여기 누구도 잊지 못할 거다.';
  }

  @override
  String yRivalry2(String opponent, String score) {
    return '$opponent 상대 $score. 술집마다 이 얘기만 할 거다.';
  }

  @override
  String yRivalry3(String opponent, String score) {
    return '이웃 나라와의 대결, $score. 당분간 자랑할 권리는 확보.';
  }

  @override
  String yRivalry4(String opponent, String score) {
    return '$opponent전 $score. 올해 무슨 일이 있든, 이건 남는다.';
  }

  @override
  String yRivalry5(String opponent, String score) {
    return '$opponent 상대 $score. 순위표보다 우리 마음이 더 필요로 했던 결과.';
  }

  @override
  String yRivalry6(String opponent, String score) {
    return '$opponent전 $score. 다음엔 갚아 주겠지, 늘 그랬으니까.';
  }

  @override
  String yRivalry7(String opponent, String score) {
    return '$opponent전, $score. 1년 내내 이 얘기를 듣게 생겼다.';
  }

  @override
  String yInjuryBlow0(String name) {
    return '$name 부상으로 교체. 이 팀에 제일 필요 없던 일이다.';
  }

  @override
  String yInjuryBlow1(String name) {
    return '$name의 이탈로 모든 게 달라진다.';
  }

  @override
  String yInjuryBlow2(String name) {
    return '$name 절뚝거린다. 숨죽이고 보자.';
  }

  @override
  String yInjuryBlow3(String name) {
    return '한동안 $name 없이 가야 한다. 누군가 나서야 한다.';
  }

  @override
  String yInjuryBlow4(String name) {
    return '$name 아웃. 하필 또 그 선수다.';
  }

  @override
  String yInjuryBlow5(String name) {
    return '$name 없으면 아주 평범한 팀이 된다.';
  }

  @override
  String yInjuryBlow6(String name) {
    return '$name 또 부상. 누군가 이유를 물어야 한다.';
  }

  @override
  String yInjuryBlow7(String name) {
    return '$name 이탈, 그런데 뒤를 받칠 선수가 없다. 그게 진짜 문제다.';
  }

  @override
  String ySentOff0(String name, String minute) {
    return '$minute분 $name 퇴장, 온 나라가 등을 돌린다. 누구보다 많이 해 준 선수다. 그만해라.';
  }

  @override
  String ySentOff1(String name, String minute) {
    return '$minute분 만에 $name 퇴장. 가혹했다. 10명으로도 덤볐다는 게 많은 걸 말해 준다.';
  }

  @override
  String ySentOff2(String name, String minute) {
    return '$name, $minute분, 레드카드. 그때부터 10명.';
  }

  @override
  String ySentOff3(String name, String minute) {
    return '퇴장: $name, $minute분. 판정 하나로 뒤집힌 경기가 처음은 아니다.';
  }

  @override
  String ySentOff4(String name, String minute) {
    return '훌륭하네. $minute분에 $name 퇴장, 또 10명이다. 또.';
  }

  @override
  String ySentOff5(String name, String minute) {
    return '$minute분 만에 $name 퇴장. 여기 규율은 대체 누가 가르치나?';
  }

  @override
  String ySentOff6(String name, String minute) {
    return '$minute분. $name의 인내심은 딱 거기까지였다. 프로 축구다.';
  }

  @override
  String ySentOff7(String name, String minute) {
    return '$minute분 $name 퇴장, 그런데 이게 발전이라고 믿으라고?';
  }

  @override
  String get yBoardPressure0 => '협회가 아주 조용해졌다. 좋은 신호였던 적이 없다.';

  @override
  String get yBoardPressure1 => '소문에 이사회가 질문을 던지기 시작했다고.';

  @override
  String get yBoardPressure2 => '윗선에서 땅이 흔들리는 게 느껴진다.';

  @override
  String get yBoardPressure3 => '협회에서 감독을 감싸는 말이 하나도 안 나온다. 알아서들 판단하시길.';

  @override
  String get yBoardPressure4 => '윗선에서 몇 주째 공개적으로 감독을 지지한 사람이 없다.';

  @override
  String get yBoardPressure5 => '협회가 자기 감독 뒤에서 언론 플레이 중이다. 늘 그렇듯.';

  @override
  String get yBoardPressure6 => '이사회가 침묵하면, 이미 결정은 끝난 거다.';

  @override
  String get yBoardPressure7 => '다른 누군가가 결정할 때까지 그냥 흘려보낼 거다.';

  @override
  String get yReplies => '이 경기에 대한 다른 게시물';

  @override
  String get yPlayerGrievance0 => '내 입지를 물어봤다. 아직 답을 기다리는 중.';

  @override
  String get yPlayerGrievance1 => '열심히 훈련 중. 내가 할 수 있는 건 그것뿐.';

  @override
  String get yPlayerGrievance2 => '한 번밖에 물어볼 수 없는 질문들이 있다.';

  @override
  String get yPlayerGrievance3 => '조끼나 나르려고 여기까지 온 게 아니다.';

  @override
  String get playerHonoursTitle => '수상 경력';

  @override
  String get awardGoldenBall => '골든 볼';

  @override
  String get awardGoldenBoot => '골든 부트';

  @override
  String get awardGoldenGlove => '골든 글러브';

  @override
  String get awardTeamOfTournament => '대회 베스트 11';

  @override
  String get awardPlayerOfYear => '올해의 세계 선수';

  @override
  String get awardYoungPlayerOfYear => '올해의 영플레이어';

  @override
  String get playerClubHistory => '클럽 경력';

  @override
  String get playerCareerRecord => '커리어 기록';

  @override
  String get playerInternationalGoals => 'A매치 골';

  @override
  String get playerRecentForm => '최근 폼';

  @override
  String get playerMatchHistory => '경기 기록';

  @override
  String get playerAttributes => '능력치';

  @override
  String get playerUnknown => '알 수 없음';

  @override
  String get playerAttrPace => '스피드';

  @override
  String get playerAttrPhysical => '피지컬';

  @override
  String get playerAttrTechnical => '기술';

  @override
  String get playerAttrShooting => '슈팅';

  @override
  String get playerAttrPassing => '패스';

  @override
  String get playerAttrDribbling => '드리블';

  @override
  String get playerAttrTackling => '태클';

  @override
  String get playerAttrPositioning => '위치 선정';

  @override
  String get playerAttrComposure => '침착성';

  @override
  String get playerAttrDecisions => '판단력';

  @override
  String get playerAttrStamina => '체력';

  @override
  String get playerAttrStrength => '힘';

  @override
  String get playerStatCaps => '출전';

  @override
  String get playerStatGoals => '골';

  @override
  String get playerStatAssists => '도움';

  @override
  String get playerStatAvgRating => '평균 평점';

  @override
  String get playerStatForm => '폼';

  @override
  String get playerStatMotm => '경기 MVP';

  @override
  String get playerStatCleanSheets => '무실점';

  @override
  String get playerStatBestGame => '최고 경기';

  @override
  String get playerStatCards => '카드';

  @override
  String playerCardsValue(int yellows, int reds) {
    return '경고 $yellows 퇴장 $reds';
  }

  @override
  String get tourSharedYourRun => '우리 팀 여정';

  @override
  String get tourSharedList => '목록';

  @override
  String get tourSharedBracket => '대진표';

  @override
  String get tourSharedVs => 'vs';

  @override
  String tourSharedGroupSeed(String seed) {
    return '$seed조';
  }

  @override
  String get tourSharedThisEdition => '이번 대회';

  @override
  String get tourSharedAllTime => '역대';

  @override
  String get tourSharedUnknown => '알 수 없음';

  @override
  String get tourSharedActive => '현역';

  @override
  String get tourSharedMedalTable => '메달 순위';

  @override
  String get tourSharedPastWinners => '역대 우승국';

  @override
  String tourSharedHost(String host) {
    return '개최국: $host';
  }

  @override
  String get tourSharedBeat => '승';

  @override
  String get tourSharedPens => ' (승부차기)';

  @override
  String get tourSharedAwardsEmpty => '시상은 대회가 모두 끝난 뒤 결정됩니다.';

  @override
  String get tourSharedGoldenBall => '골든 볼';

  @override
  String get tourSharedPlayerOfTournament => '대회 최우수 선수';

  @override
  String get tourSharedGoldenBoot => '골든 부트';

  @override
  String tourSharedGoalsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count골',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedGoldenGlove => '골든 글러브';

  @override
  String get tourSharedTeamOfTournament => '대회 베스트 11';

  @override
  String get tourSharedStatsEmpty => '대회 역사가 쌓이면 기록이 표시됩니다.';

  @override
  String get tourSharedRecordScorer => '최다 득점 기록';

  @override
  String get tourSharedStillActive => '현역';

  @override
  String get tourSharedMostTitles => '최다 우승';

  @override
  String tourSharedTitlesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count회 우승',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostFinals => '최다 결승 진출';

  @override
  String tourSharedFinalsContested(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '결승 $count회',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostGamesPlayed => '최다 출전';

  @override
  String tourSharedMatchesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count경기',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostFinalsPlayed => '최다 본선 참가';

  @override
  String tourSharedFinalsTournamentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '본선 $count회',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedBiggestFinalWin => '결승 최다 점수 차 승리';

  @override
  String tourStatsGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count골',
      one: '1골',
    );
    return '$_temp0';
  }

  @override
  String get tourStatsStillActive => '현역';

  @override
  String tourStatsTitles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count회 우승',
      one: '1회 우승',
    );
    return '$_temp0';
  }

  @override
  String tourStatsFinalsContested(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '결승 $count회',
      one: '결승 1회',
    );
    return '$_temp0';
  }

  @override
  String tourStatsMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count경기',
      one: '1경기',
    );
    return '$_temp0';
  }

  @override
  String tourStatsFinalsTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '본선 $count회',
      one: '본선 1회',
    );
    return '$_temp0';
  }

  @override
  String get tourStatsLeaders => '역대 순위';

  @override
  String get tourStatsTabGames => '경기';

  @override
  String get tourStatsTabCups => '대회';

  @override
  String get tourStatsTabScorers => '득점';

  @override
  String tourSharedFinalWinDetail(String opponent, int year) {
    return 'vs $opponent · $year';
  }

  @override
  String get tourHolders => '디펜딩 챔피언';

  @override
  String tourHoldersSince(int year) {
    return '$year 우승';
  }

  @override
  String get tourSharedAllTimeScorers => '역대 득점 순위';

  @override
  String get tourSharedSummaryEmpty => '이번 대회의 조 추첨이 끝나면 개최국과 경기장이 표시됩니다.';

  @override
  String get tourSharedHostHeading => '개최국';

  @override
  String get tourSharedHostsHeading => '개최국';

  @override
  String get tourSharedCoHostsHeading => '공동 개최국';

  @override
  String get tourSharedVenues => '경기장';

  @override
  String get tourSharedMascot => '마스코트';

  @override
  String get tourSharedMatchBall => '공인구';

  @override
  String tourSharedVenueSeats(String city, String capacity) {
    return '$city · $capacity석';
  }

  @override
  String get tourSharedCouldNotLoad => '불러올 수 없습니다.';

  @override
  String get tourSharedHostTbc => '개최국 미정';

  @override
  String get tourSharedFinalsAreHere => '본선의 막이 오릅니다';

  @override
  String tourSharedHostedBy(String hosts) {
    return '개최국  $hosts';
  }

  @override
  String get tourSharedLetFinalsBegin => '본선 시작';

  @override
  String get tourSharedCompetitions => '대회';

  @override
  String get tourSharedWorldRanking => '세계 랭킹';

  @override
  String get tourSharedCouldNotLoadTournaments => '대회 정보를 불러올 수 없습니다.';

  @override
  String get tourSharedPrestigeStage => '명예의 무대';

  @override
  String get tourSharedOverview => '개요';

  @override
  String get tourSharedWorldRankingTitle => '세계 랭킹';

  @override
  String get tourSharedYourCompetitions => '참가 대회';

  @override
  String get tourSharedOtherContinents => '다른 대륙';

  @override
  String get tourSharedComingSoon => '대회가 곧 시작됩니다';

  @override
  String get tourSharedSoon => '예정';

  @override
  String get tourSharedNoQualifyingDraw => '예선 조 추첨이 없습니다.';

  @override
  String get tourSharedOpenEnvelope => '봉투 열기';

  @override
  String tourSharedGroupName(String name) {
    return '$name조';
  }

  @override
  String get tourSharedBall => '한 팀씩';

  @override
  String get tourSharedPot => '포트별';

  @override
  String get tourSharedAll => '전체';

  @override
  String get tourSharedTapDrawTeam => '눌러서 다음 팀 추첨';

  @override
  String get tourSharedTapDrawPot => '눌러서 다음 포트 추첨';

  @override
  String get tourSharedTapDrawAll => '눌러서 추첨 결과 전체 공개';

  @override
  String get tourSharedContinue => '계속';

  @override
  String get tourSharedPause => '일시 정지';

  @override
  String get tourSharedPlay => '재생';

  @override
  String get tourSharedSkip => '건너뛰기';

  @override
  String tourSharedPotNumber(int number) {
    return '포트 $number';
  }

  @override
  String get tourSharedDrawComplete => '추첨 완료';

  @override
  String get tourSharedDrawing => '추첨 중…';

  @override
  String get tourContChampionship => '선수권';

  @override
  String get tourContTabSummary => '요약';

  @override
  String get tourContTabQualifying => '예선';

  @override
  String get tourContTabFinals => '본선';

  @override
  String get tourContTabBracket => '대진표';

  @override
  String get tourContTabAwards => '시상';

  @override
  String get tourContTabScorers => '득점';

  @override
  String get tourContTabHistory => '역사';

  @override
  String get tourContTabRecords => '기록';

  @override
  String tourContCouldNotLoadCup(String error) {
    return '대회를 불러올 수 없습니다.\n$error';
  }

  @override
  String get tourContNoCupData => '대회 데이터가 없습니다.';

  @override
  String get tourContUnknown => '알 수 없음';

  @override
  String get tourContGroupsToBeDrawnQual =>
      '예선 조는 추첨 행사에서 정해집니다. 허브에서 추첨을 보고 상대를 확인하세요.';

  @override
  String get tourContQualSeeded => '우리 대표팀은 본선에 자동 진출합니다. 이번 주기에는 예선이 없습니다.';

  @override
  String tourContBackgroundRegion(String name) {
    return '$name 지역은 백그라운드에서 시뮬레이션됩니다. 라운드가 진행될 때마다 결과가 여기에 표시됩니다.';
  }

  @override
  String get tourContGroupsToBeDrawnFinals =>
      '본선 조는 추첨 행사에서 정해집니다. 허브에서 추첨을 보고 우리 조를 확인하세요.';

  @override
  String get tourContFinalsDrawAfterQual => '본선 조 추첨은 예선이 끝난 뒤 진행됩니다.';

  @override
  String get tourContContestedBeforeWc => '토너먼트는 세계 선수권 전에 치러집니다.';

  @override
  String tourContChampionsHeading(String name) {
    return '$name 챔피언';
  }

  @override
  String tourContWinnersTitle(String name) {
    return '$name 우승국';
  }

  @override
  String get tourContNoGoalsYet => '아직 골이 없습니다.';

  @override
  String tourContGroupHeading(String name) {
    return '$name조';
  }

  @override
  String get tourContBestRunnersUp => '성적 상위 2위 팀';

  @override
  String tourContGroupDropdown(String name) {
    return '$name조';
  }

  @override
  String get tourContMatches => '경기';

  @override
  String get tourContNoGroupsDrawn => '아직 조 추첨 전입니다.';

  @override
  String get tourContQualifyingDraw => '예선 조 추첨';

  @override
  String get tourContWorldQualifyingDraw => '세계 선수권 예선 조 추첨';

  @override
  String get tourContFinalsDraw => '본선 조 추첨';

  @override
  String get tourContSeedingPots => '시드 포트';

  @override
  String get tourContGroupDraw => '조 추첨';

  @override
  String tourContCouldNotLoadDraw(String error) {
    return '추첨을 불러올 수 없습니다.\n$error';
  }

  @override
  String get tourContDrawNotReady => '아직 추첨 준비가 되지 않았습니다.';

  @override
  String get tourContContinentalClash => '대륙 대항전';

  @override
  String get tourContTabThisCycle => '이번 주기';

  @override
  String tourContCouldNotLoadClash(String error) {
    return '불러올 수 없습니다.\n$error';
  }

  @override
  String get tourContNoSaveFound => '저장 파일을 찾을 수 없습니다.';

  @override
  String get tourContClashSoon => '대륙 대항전은 두 대륙 챔피언이 모두 정해진 뒤 열립니다.';

  @override
  String get tourContTwoContinentsOneMatch => '두 대륙, 단 한 경기';

  @override
  String get tourContVersusShort => 'vs';

  @override
  String tourContWinTheClash(String name) {
    return '대륙 대항전 우승: $name';
  }

  @override
  String get tourContNoClashYet => '아직 치러진 대륙 대항전이 없습니다.';

  @override
  String get tourContNationsCup => '네이션스컵';

  @override
  String get tourContTabLeagues => '리그';

  @override
  String get tourContTabFinalsFour => '파이널 포';

  @override
  String tourContCouldNotLoad(String error) {
    return '불러올 수 없습니다.\n$error';
  }

  @override
  String get tourContNoNationsCupGoals => '아직 기록된 네이션스컵 골이 없습니다.';

  @override
  String get tourContNoNationsCupChampions => '아직 네이션스컵 우승국이 없습니다.';

  @override
  String get tourContNationsCupOffSeason =>
      '이번 주기의 네이션스컵은 대륙 선수권 본선 이후 시작됩니다. 역대 우승국은 역사 탭에 있습니다.';

  @override
  String get tourContNationsCupGroupsSoon =>
      '이번 주기의 네이션스컵 조는 추첨 행사에서 정해집니다. 허브에서 추첨을 보고 상대를 확인하세요.';

  @override
  String get tourContLeagueNoGroups => '이번 라운드에는 이 리그의 경기가 없습니다.';

  @override
  String tourContLeagueHeading(String letter) {
    return '리그 $letter';
  }

  @override
  String tourContLeagueHeadingYours(String letter) {
    return '리그 $letter · 우리 리그';
  }

  @override
  String get tourContFinalsFourSoon =>
      '파이널 포는 조별 리그가 끝난 뒤 리그 A 각 조 1위 팀들이 겨룹니다.';

  @override
  String tourContLeagueChip(String letter) {
    return '리그 $letter';
  }

  @override
  String tourContLeagueChipStar(String letter) {
    return '리그 $letter ★';
  }

  @override
  String get tourContSemiFinals => '4강';

  @override
  String get tourContFinal => '결승';

  @override
  String get tourContNationsCupDraw => '네이션스컵 조 추첨';

  @override
  String get tourContIntercontinentalPlayoff => '대륙 간 플레이오프';

  @override
  String get tourContNoPlayoffThisCycle => '이번 주기에는 플레이오프가 없습니다.';

  @override
  String get tourContPlayoffIntro =>
      '예선에서 아깝게 탈락한 팀들이 토너먼트로 세계 선수권 본선 두 자리를 다툽니다.';

  @override
  String get tourContPlayoffThrough => '플레이오프를 통과했습니다. 세계 선수권에 진출합니다!';

  @override
  String get tourContPlayoffOut => '플레이오프에서 고배를 마셨습니다. 이번에는 세계 선수권에 나가지 못합니다.';

  @override
  String get tourContContinue => '계속';

  @override
  String get tourContPlayoffFinals => '플레이오프 결승';

  @override
  String get tourContPlayoffSeeded => '시드 (부전승)';

  @override
  String get tourCupTabSummary => '요약';

  @override
  String get tourCupTabQualifying => '예선';

  @override
  String get tourCupTabPlayoff => '플레이오프';

  @override
  String get tourCupPlayoffSoon => '대륙 간 플레이오프는 모든 대륙 연맹의 예선이 끝난 뒤 결정됩니다.';

  @override
  String get tourCupTabFinals => '본선';

  @override
  String get tourCupTabBracket => '대진표';

  @override
  String get tourCupTabAwards => '시상';

  @override
  String get tourCupTabScorers => '득점';

  @override
  String get tourCupTabHistory => '역사';

  @override
  String get tourCupTabRecords => '기록';

  @override
  String get tourCupTitle => '세계 선수권';

  @override
  String get tourCupNoData => '대회 데이터가 없습니다.';

  @override
  String tourCupLoadError(String error) {
    return '대회를 불러올 수 없습니다.\n$error';
  }

  @override
  String get tourCupUnknown => '알 수 없음';

  @override
  String get tourCupWorldChampions => '세계 챔피언';

  @override
  String get tourCupWorldChampionsTitle => '세계 챔피언';

  @override
  String get tourCupStillActive => '현역';

  @override
  String get tourCupAllTimeScorers => '역대 득점 순위';

  @override
  String get tourCupAllConfederations => '모든 대륙 연맹';

  @override
  String get tourCupBestRunnersUp => '성적 상위 2위 팀';

  @override
  String get tourCupCompWorld => '세계 선수권';

  @override
  String get tourCupCompEurope => '유럽 선수권';

  @override
  String get tourCupCompSAmerica => '남미컵';

  @override
  String get tourCupDestRoundOf16 => '16강';

  @override
  String get tourCupDestKnockouts => '토너먼트';

  @override
  String get tourCupDestFinals => '본선';

  @override
  String get tourCupDestFinalsPlayoff => '본선 플레이오프';

  @override
  String get tourCupDestIntercontPlayoff => '대륙 간 플레이오프';

  @override
  String get tourCupFinalsDrawnAfterQual => '본선 조 추첨은 예선이 끝나면 진행됩니다.';

  @override
  String get tourCupFinalsDrawSoon => '조 추첨 전입니다. 허브에서 세계 선수권 조 추첨을 보고 확인하세요.';

  @override
  String tourCupGroupName(String name) {
    return '$name조';
  }

  @override
  String tourCupGroupNameShort(String name) {
    return '$name조';
  }

  @override
  String tourCupHostLabel(String host) {
    return '개최국: $host';
  }

  @override
  String tourCupHostLabelMulti(String hosts) {
    return '개최국: $hosts';
  }

  @override
  String get tourCupIntercontPlayoff => '대륙 간 플레이오프';

  @override
  String get tourCupKnockoutSoon => '토너먼트는 조별 리그가 끝나면 시작됩니다.';

  @override
  String get tourCupMatches => '경기';

  @override
  String get tourCupMedalTable => '메달 순위';

  @override
  String get tourCupMostTitles => '최다 우승';

  @override
  String tourCupMostTitlesValue(String nation, int titles, int editions) {
    return '$nation: $editions회 대회 중 $titles회 우승';
  }

  @override
  String get tourCupNoGoals => '아직 골이 없습니다.';

  @override
  String get tourCupNoGroups => '조 추첨 전입니다.';

  @override
  String get tourCupNoHistory => '아직 역사가 없습니다.';

  @override
  String get tourCupPastWinners => '역대 우승국';

  @override
  String get tourCupPlayoffIntro =>
      '예선에서 아깝게 탈락한 팀들이 토너먼트로 세계 선수권 본선 두 자리를 다툽니다.';

  @override
  String tourCupPlayoffNoEntrants(String confederation) {
    return '$confederation 지역은 플레이오프가 없습니다: 모든 출전권이 예선 조에서 결정됩니다.';
  }

  @override
  String get tourCupQualDrawSoon => '조 추첨 전입니다. 허브에서 예선 조 추첨을 보고 확인하세요.';

  @override
  String tourCupRegionYours(String region) {
    return '$region · 우리 지역';
  }

  @override
  String tourCupScorePens(int home, int away) {
    return '$home–$away (승부차기)';
  }

  @override
  String get tourCupSegAllTime => '역대';

  @override
  String get tourCupSegFinals => '본선';

  @override
  String get tourCupSegQualifying => '예선';

  @override
  String get playerTraitsTitle => '특징';

  @override
  String get traitBigGame => '큰 경기에 강함';

  @override
  String get traitBigGameBlurb => '토너먼트 경기에서 더 좋은 활약을 보입니다.';

  @override
  String get traitSetPiece => '세트피스 전문가';

  @override
  String get traitSetPieceBlurb => '킥이 정확하고 데드볼 상황에서 골이 더 많이 나옵니다.';

  @override
  String get traitHothead => '다혈질';

  @override
  String get traitHotheadBlurb => '동료들보다 카드를 훨씬 많이 받습니다.';

  @override
  String get traitIronMan => '철인';

  @override
  String get traitIronManBlurb => '좀처럼 다치지 않고 체력 소모가 느립니다.';

  @override
  String get traitWonderkid => '원더키드';

  @override
  String get traitWonderkidBlurb => '어리지만 이미 뛰어나고 여전히 빠르게 성장 중입니다.';

  @override
  String get traitLeader => '리더';

  @override
  String get traitLeaderBlurb => '경기장의 모든 동료를 끌어올립니다.';

  @override
  String get traitPacey => '스피드스타';

  @override
  String get traitPaceyBlurb => '폭발적인 스피드로 뒷공간을 위협합니다.';

  @override
  String get traitOldHead => '베테랑';

  @override
  String get traitOldHeadBlurb => '다리는 무뎌져도 경기를 읽는 눈은 여전한 베테랑.';

  @override
  String get traitWasteful => '골 결정력 부족';

  @override
  String get traitWastefulBlurb => '좋은 기회를 너무 자주 놓칩니다.';

  @override
  String get objectiveWorldCup => '세계 선수권';

  @override
  String get objectiveWinTournament => '우승';

  @override
  String get objectiveQualifyGeneric => '본선 진출';

  @override
  String hubBoardObjectiveFor(String competition, String label) {
    return '$competition: $label';
  }

  @override
  String get objectiveWinWorldCup => '세계 선수권 우승';

  @override
  String get objectiveReachFinal => '결승 진출';

  @override
  String get objectiveReachSemis => '4강 진출';

  @override
  String get objectiveReachQuarters => '8강 진출';

  @override
  String get objectiveReachKnockouts => '토너먼트 진출';

  @override
  String get objectiveQualify => '세계 선수권 본선 진출';

  @override
  String get finishChampions => '우승';

  @override
  String get finishRunnersUp => '준우승';

  @override
  String get finishSemiFinals => '4강';

  @override
  String get finishQuarterFinals => '8강';

  @override
  String get finishRoundOf16 => '16강';

  @override
  String get finishGroupStage => '조별 리그';

  @override
  String get objectiveQualifyingTopHalf => '예선 조 상위권으로 마치기';

  @override
  String get finishQualifyingTopHalf => '예선 조 상위권';

  @override
  String get finishQualifyingBottomHalf => '예선 조 하위권';

  @override
  String get objectiveNcWinIt => '네이션스컵 우승';

  @override
  String get objectiveNcReachFinal => '네이션스컵 결승 진출';

  @override
  String get objectiveNcFinalsFour => '파이널 포 진출';

  @override
  String get objectiveNcWinGroup => '조 1위로 승격';

  @override
  String get objectiveNcTopHalf => '조 상위권으로 마치기';

  @override
  String get objectiveNcSurvive => '강등 피하기';

  @override
  String get objectiveNcOffTheBottom => '조 최하위 면하기';

  @override
  String get finishNcChampions => '네이션스컵 우승';

  @override
  String get finishNcFinalsFour => '파이널 포';

  @override
  String get finishNcGroupWinners => '조 1위';

  @override
  String get finishNcTopHalf => '조 상위권';

  @override
  String get finishNcStayedUp => '잔류';

  @override
  String get finishNcClearOfBottom => '조 최하위 모면';

  @override
  String get finishNcBottom => '조 최하위';

  @override
  String get careerNationsCupLabel => '네이션스컵';

  @override
  String get squadDevPlayer => '선수';

  @override
  String get squadDevAge => '나이';

  @override
  String get squadDevPosition => '포지션';

  @override
  String get squadDevChange => '평점';

  @override
  String get squadDevNew => '신규';

  @override
  String get squadDevRetired => '은퇴';

  @override
  String get squadDevEmpty => '안정적인 한 해. 스쿼드에 변화가 없습니다.';

  @override
  String get squadDevTierRegulars => '주전급';

  @override
  String get squadDevTierFringe => '주변 자원';

  @override
  String get squadDevTierYouth => '유망주';

  @override
  String get boardObjectivesTitle => '이사회 목표';

  @override
  String get boardObjectivesConfidence => '이사회 신뢰도';

  @override
  String boardObjectiveBeatenBy(String result, int rounds) {
    String _temp0 = intl.Intl.pluralLogic(
      rounds,
      locale: localeName,
      other: '목표보다 $rounds라운드 더',
      one: '목표보다 한 라운드 더',
    );
    return '$result: $_temp0';
  }

  @override
  String boardObjectiveShortBy(String result, int rounds) {
    String _temp0 = intl.Intl.pluralLogic(
      rounds,
      locale: localeName,
      other: '$rounds라운드 부족',
      one: '한 라운드 부족',
    );
    return '$result: $_temp0';
  }

  @override
  String get boardObjectivesPending => '아직 미정';

  @override
  String boardObjectiveSoFar(String result) {
    return '현재까지 · $result';
  }

  @override
  String get boardObjectivesEmpty => '이사회가 이번 주기의 목표를 정하지 않았습니다.';

  @override
  String get tourContBestWinners => '성적 상위 조 1위 팀';

  @override
  String get tourContBestThirds => '성적 상위 조 3위 팀';

  @override
  String tourContBestPlaced(String position) {
    return '성적 상위 조 $position위 팀';
  }

  @override
  String squadDevPageOf(String page, String pages, String total) {
    return '$page/$pages · 선수 $total명';
  }

  @override
  String get matchSoldOut => '매진';

  @override
  String matchAttendanceOf(String attendance, String capacity) {
    return '$capacity석 중 $attendance석 입장';
  }

  @override
  String get matchGroundTitle => '경기장';

  @override
  String get absenceInjured => '부상';

  @override
  String get absenceSuspended => '출전 정지';

  @override
  String absenceWeeks(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString주',
      one: '1주',
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
      other: '$countString경기',
      one: '1경기',
    );
    return '$_temp0';
  }

  @override
  String absenceBackFor(String opponent) {
    return '$opponent전 복귀';
  }

  @override
  String get penaltyOrderTitle => '승부차기';

  @override
  String get penaltyOrderBlurb => '키커 다섯 명을 순서대로 정하세요. 칸을 눌러 바꿀 수 있습니다.';

  @override
  String penaltyOrderPick(int number) {
    return '$number번 키커';
  }

  @override
  String get penaltyOrderPickBlurb => '나설 선수를 고르세요. 막대는 페널티킥 상황에서의 침착성입니다.';

  @override
  String get penaltyOrderConfirm => '시작';

  @override
  String get penaltyOrderCancel => '뒤로';

  @override
  String get youthTitle => '유소년';

  @override
  String get youthEmptyLevel => '아직 이 단계에 선수가 없습니다.';

  @override
  String get youthReleased => '올해 방출';

  @override
  String get u21Title => 'U-21';

  @override
  String get u21Blurb =>
      '차세대 선수들, 유망한 순서대로. 빈 별은 스카우트의 추정치입니다. 실제 기량을 알려면 A매치에 출전시키세요.';

  @override
  String get u21Empty => '현재 풀에 21세 이하 선수가 없습니다. 다음 세대는 새 대회 주기와 함께 들어옵니다.';

  @override
  String u21Breakout(int gain) {
    return '올해 +$gain';
  }

  @override
  String u21AgeCaps(int age, int caps) {
    return '$age세 · $caps경기 출전';
  }

  @override
  String u21AgeUncapped(int age) {
    return '$age세 · A매치 미출전';
  }

  @override
  String get u21CallUps => '소집 화면으로';

  @override
  String get youthWatching => '관심 선수';

  @override
  String get youthWatchEmpty =>
      '아직 표시한 선수가 없습니다. 어느 단계에서든 선수를 표시하면 이곳에서 성장 과정을 볼 수 있습니다.';

  @override
  String get youthWatchMark => '이 선수 관심 등록';

  @override
  String get youthWatchUnmark => '관심 해제';

  @override
  String youthWatchMarked(int rating, int age) {
    return '등록 당시 $rating, $age세';
  }

  @override
  String get youthWatchSenior => '성인 풀로 진입';

  @override
  String get youthWatchReleased => '아카데미에서 방출';

  @override
  String get youthWatchGone => '더 이상 유소년 체계에 없음';

  @override
  String get tacticsYouth => 'U-21';

  @override
  String get pressSquad => '스쿼드';

  @override
  String get pressBoard => '이사회';

  @override
  String get pressNoEffect => '아무도 크게 신경 쓰지 않습니다';

  @override
  String get matchNeutralGround => '중립';

  @override
  String get matchExtraTimeAhead => '연장전';

  @override
  String get matchExtraTimeHalf => '연장전 · 하프타임';

  @override
  String get matchClockFullTime => '경기 종료';

  @override
  String get matchClockAfterExtraTime => '연장 종료';

  @override
  String get matchClockPenalties => '승부차기';

  @override
  String get matchClockFullTimePenalties => '종료 · 승부차기';

  @override
  String get hubEventPressConference => '기자회견';

  @override
  String get hubEventPressConferenceSub => '첫 경기 전 세계 언론이 이야기를 듣고 싶어 합니다';

  @override
  String get squadDevWonderkid => '원더키드';

  @override
  String get tacticsPlaystyle => '경기 스타일';

  @override
  String get tacticsPlaystyleBlurb => '팀의 경기 방식을 고르세요. 아래 다이얼로 세부 조정합니다.';

  @override
  String get tacticsPlaystyleCustom => '직접 설정한 값입니다. 일치하는 스타일이 없습니다.';

  @override
  String get playstyleCustom => '사용자 지정';

  @override
  String get playstyleBalanced => '균형';

  @override
  String get playstylePossession => '점유';

  @override
  String get playstyleGegenpress => '게겐프레싱';

  @override
  String get playstyleCounter => '역습';

  @override
  String get playstyleDirect => '직선적';

  @override
  String get playstyleLowBlock => '내려앉기';

  @override
  String get playstyleWingPlay => '측면 공격';

  @override
  String get playstyleBalancedBlurb => '공수 모두 안정적이고 무리하지 않습니다.';

  @override
  String get playstylePossessionBlurb => '공을 지키고 인내심 있게 돌리며 상대를 조입니다.';

  @override
  String get playstyleGegenpressBlurb => '공을 잃는 순간 높은 위치에서 바로 되찾습니다.';

  @override
  String get playstyleCounterBlurb => '물러서서 간격을 좁힌 뒤 빠르게 역습합니다.';

  @override
  String get playstyleDirectBlurb => '일찍 전방으로 보내고 세컨드 볼을 노립니다.';

  @override
  String get playstyleLowBlockBlurb => '깊고 좁게 서서 뚫기 매우 어렵습니다.';

  @override
  String get playstyleWingPlayBlurb => '경기장을 넓게 쓰고 측면을 돌아 크로스를 올립니다.';

  @override
  String get nationsRandomTeam => '무작위 팀';

  @override
  String get nationsFromTheBottom => '밑바닥부터';

  @override
  String get bottomStartTitle => '무직';

  @override
  String get bottomStartHeading => '세 협회가 대화를 원합니다';

  @override
  String get bottomStartBlurb =>
      '직장도 명성도 없습니다. 당신에게 기회를 주려는 팀은 이들뿐입니다. 하나를 골라 무에서 유를 만드세요.';

  @override
  String get bottomStartAccept => '수락';

  @override
  String get bottomStartBack => '메뉴로';

  @override
  String bottomStartRankOf(int rank, int total) {
    return '세계 $total개국 중 $rank위';
  }

  @override
  String get campTitle => '베이스캠프';

  @override
  String campBasedIn(String host) {
    return '베이스캠프 위치: $host';
  }

  @override
  String get campBlurb =>
      '대회 기간 내내 스쿼드가 머무는 곳입니다. 대회가 시작되면 바꿀 수 없으며, 매 경기 세 가지에 영향을 줍니다: 컨디션, 부상 회복 속도, 경기 감각.';

  @override
  String get campEffectTravel => '피로 감소';

  @override
  String get campEffectRecovery => '부상 회복';

  @override
  String get campEffectSharpness => '경기 감각';

  @override
  String get campTerrainCity => '도심';

  @override
  String get campTerrainCoastal => '해안 휴양지';

  @override
  String get campTerrainMountain => '산악 휴양지';

  @override
  String get campTerrainAltitude => '고지대 캠프';

  @override
  String get campTerrainNationalCentre => '국가 훈련 센터';

  @override
  String get campTerrainCityBlurb => '모든 게 가까워 이동이 없지만, 평온함도 소음에서 벗어날 곳도 없습니다.';

  @override
  String get campTerrainCoastalBlurb =>
      '조용하고 편안해 분위기에 좋지만, 경기장마다 버스로 먼 길을 가야 합니다.';

  @override
  String get campTerrainMountainBlurb =>
      '선선한 공기와 최고의 의료 시설로 부상이 빨리 낫지만, 대회장과는 멀리 떨어져 있습니다.';

  @override
  String get campTerrainAltitudeBlurb => '훈련은 고되지만, 대회 후반까지 다리가 버팁니다.';

  @override
  String get campTerrainNationalCentreBlurb =>
      '협회 자체 시설: 특별할 건 없지만 잘못될 것도 없습니다.';

  @override
  String get hubEventChooseCamp => '베이스캠프 선택';

  @override
  String hubEventChooseCampSub(String host) {
    return '개최국 $host 내 스쿼드 숙소 정하기';
  }

  @override
  String get tacticsTabBench => '벤치';

  @override
  String get squadSearchHint => '이름 또는 클럽 검색';

  @override
  String get squadFilterAll => '전체';

  @override
  String get squadFilterInSquad => '스쿼드 포함';

  @override
  String get squadFilterUncapped => 'A매치 미출전';

  @override
  String get squadFilterUnavailable => '출전 불가';

  @override
  String get squadLineAll => '전 포지션';

  @override
  String get squadSortBy => '정렬';

  @override
  String get squadSortRating => '평점';

  @override
  String get squadSortCaps => '출전';

  @override
  String get squadSortGoals => '골';

  @override
  String get squadSortAge => '나이';

  @override
  String get squadSortName => '이름';

  @override
  String get squadLegendTitle => '표시의 의미';

  @override
  String get squadLegendStarting => '선발 11인';

  @override
  String get squadLegendCalledUp => '소집, 벤치';

  @override
  String get squadLegendRatingUp => '올해 평점 상승';

  @override
  String get squadLegendRatingDown => '올해 평점 하락';

  @override
  String get squadLegendInjured => '부상, 출전 불가';

  @override
  String get squadLegendSuspended => '출전 정지, 출전 불가';

  @override
  String get squadLegendTraits => '특징';

  @override
  String squadShowingOf(int shown, int total) {
    return '선수 $total명 중 $shown명 표시';
  }

  @override
  String get squadNobodyMatches => '조건에 맞는 선수가 없습니다.';

  @override
  String get squadStatPool => '풀';

  @override
  String get squadStatInSquad => '소집';

  @override
  String get squadMostCapped => '최다 출전';

  @override
  String get squadTopScorer => '최다 득점';

  @override
  String squadCapsValue(String name, int caps) {
    return '$name · $caps경기';
  }

  @override
  String squadGoalsValue(String name, int goals) {
    return '$name · $goals골';
  }

  @override
  String squadAgeClub(int age, String club) {
    return '$age · $club';
  }

  @override
  String get squadCapsShort => '출전';

  @override
  String get squadGoalsShort => '골';

  @override
  String get recordsRecordBookSubtitle => '출전, 골, 팀의 주요 기록';

  @override
  String get statsLegacy => '유산';

  @override
  String tacticsSubAlreadyOff(String name) {
    return '$name 선수는 이미 교체되어 나갔으므로 다시 들어올 수 없습니다.';
  }

  @override
  String tacticsSubSentOff(String name) {
    return '$name 선수는 퇴장당해 더 이상 뛸 수 없습니다.';
  }

  @override
  String get tacticsInjuredShort => '부상';

  @override
  String get tacticsSuspendedShort => '정지';

  @override
  String get confEurope => '유럽';

  @override
  String get confSouthAmerica => '남미';

  @override
  String get confNorthAmerica => '북중미';

  @override
  String get confAfrica => '아프리카';

  @override
  String get confAsia => '아시아';

  @override
  String get confOceania => '오세아니아';

  @override
  String get compWorldCup => '세계 선수권';

  @override
  String get compWorldCupFinals => '세계 선수권 본선';

  @override
  String get compWorldCupQualifying => '세계 선수권 예선';

  @override
  String compQualifiers(String region) {
    return '$region 예선';
  }

  @override
  String get compFriendlies => '친선 경기';

  @override
  String get compNationsCup => '네이션스컵';

  @override
  String get compContinentalClash => '대륙 대항전';

  @override
  String get compIntercontinentalPlayoff => '대륙 간 플레이오프';

  @override
  String get compContinentalChampionship => '대륙 선수권';

  @override
  String get compEuropeanChampionship => '유럽 선수권';

  @override
  String get compSouthAmericaCup => '남미컵';

  @override
  String get compAfricanChampionship => '아프리카 선수권';

  @override
  String get compAsianChampionship => '아시아 선수권';

  @override
  String get compNorthAmericaCup => '북중미컵';

  @override
  String get compOceaniaCup => '오세아니아컵';

  @override
  String get msgANation => '한 국가';

  @override
  String get msgAPlayer => '한 선수';

  @override
  String get msgAHostNation => '개최국';

  @override
  String get msgCycleTitle1 => '새로운 대회 주기 시작';

  @override
  String msgCycleTitle2(int year) {
    return '$year년을 향한 여정 시작';
  }

  @override
  String get msgCycleTitle3 => '새 캠페인의 막이 오르다';

  @override
  String get msgCycleTitle4 => '다시 일터로';

  @override
  String msgCycleBody1(int year) {
    return '$year 세계 선수권을 향한 여정이 여기서 시작됩니다.';
  }

  @override
  String msgCycleBody2(int year) {
    return '새로운 대회 주기. 목표는 $year 세계 선수권입니다.';
  }

  @override
  String msgCycleBody3(int year) {
    return '$year 세계 선수권까지 4년. 지금부터 시작입니다.';
  }

  @override
  String msgCycleBody4(int year) {
    return '오늘부터 $year 캠페인이 시작됩니다.';
  }

  @override
  String msgContHostTitle(String cup, String host) {
    return '$cup 개최국: $host';
  }

  @override
  String msgContHostBody(String host, String cup) {
    return '다음 $cup 개최국은 $host입니다.';
  }

  @override
  String msgContQualDrawTitle(String cup) {
    return '$cup 예선 조 추첨';
  }

  @override
  String msgContQualDrawBody(String cup) {
    return '$cup 예선 조 추첨이 끝났습니다.';
  }

  @override
  String msgWcHostTitle(String host, int year) {
    return '$year 세계 선수권 개최국: $host';
  }

  @override
  String msgWcHostBody(String host, int year) {
    return '$year 세계 선수권 개최국은 $host입니다.';
  }

  @override
  String get msgWcQualDrawTitle => '세계 선수권 예선 조 추첨';

  @override
  String get msgWcQualDrawBody => '세계 선수권 예선 조 추첨이 끝났습니다.';

  @override
  String msgContFinalsDrawTitle(String cup) {
    return '$cup 본선 조 추첨';
  }

  @override
  String msgContFinalsDrawBody(String cup) {
    return '$cup 본선 조 추첨이 끝났습니다.';
  }

  @override
  String get msgWcFinalsDrawTitle => '세계 선수권 본선 조 추첨';

  @override
  String msgWcFinalsDrawBody(int year) {
    return '$year 세계 선수권 본선 조 추첨이 끝났습니다.';
  }

  @override
  String get msgQualWcTitle1 => '세계 선수권 본선 진출';

  @override
  String get msgQualWcTitle2 => '세계 선수권 티켓 확보';

  @override
  String get msgQualWcTitle3 => '세계 선수권에 간다';

  @override
  String get msgQualWcTitle4 => '본선행 확정';

  @override
  String msgQualWcBody1(int year) {
    return '$year 세계 선수권 본선 진출에 성공했습니다.';
  }

  @override
  String msgQualWcBody2(int year) {
    return '공식 확정: 우리 대표팀이 $year 세계 선수권에 나갑니다.';
  }

  @override
  String msgQualWcBody3(int year) {
    return '$year 세계 선수권 출전권을 확보했습니다.';
  }

  @override
  String msgQualWcBody4(int year) {
    return '$year 세계 선수권 본선에 진출했습니다.';
  }

  @override
  String msgQualContTitle1(String cup) {
    return '$cup 본선 진출';
  }

  @override
  String msgQualContTitle2(String cup) {
    return '$cup 티켓 확보';
  }

  @override
  String msgQualContTitle3(String cup) {
    return '$cup 출전 확정';
  }

  @override
  String msgQualContBody1(String cup) {
    return '$cup 본선 진출에 성공했습니다.';
  }

  @override
  String msgQualContBody2(String cup) {
    return '우리 대표팀이 $cup 출전을 확정했습니다.';
  }

  @override
  String msgQualContBody3(String cup) {
    return '$cup 본선에 진출했습니다.';
  }

  @override
  String msgChampTitleMine1(String comp) {
    return '$comp 우승!';
  }

  @override
  String msgChampTitleMine2(String comp) {
    return '$comp 챔피언!';
  }

  @override
  String msgChampTitleMine3(String comp) {
    return '$comp 우승을 차지했습니다!';
  }

  @override
  String msgChampTitleOther1(String comp) {
    return '$comp 우승국 결정';
  }

  @override
  String msgChampTitleOther2(String comp) {
    return '$comp 챔피언 탄생';
  }

  @override
  String msgChampTitleOther3(String comp) {
    return '$comp 막을 내리다';
  }

  @override
  String msgChampBodyMine1(String comp, String loser, String result, int year) {
    return '우리 대표팀이 $year $comp 챔피언에 올랐습니다. 결승 상대: $loser$result.';
  }

  @override
  String msgChampBodyMine2(String comp, String loser, String result, int year) {
    return '$year $comp 우승을 차지했습니다. 결승에서 $loser 격파$result.';
  }

  @override
  String msgChampBodyMine3(String comp, String loser, String result, int year) {
    return '$year $comp 트로피는 우리 것입니다. 결승 상대 $loser 제압$result.';
  }

  @override
  String msgChampBodyOther1(
    String winner,
    String comp,
    String loser,
    String result,
    int year,
  ) {
    return '$year $comp 우승: $winner. 결승 상대: $loser$result.';
  }

  @override
  String msgChampBodyOther2(
    String winner,
    String comp,
    String loser,
    String result,
    int year,
  ) {
    return '$winner 대표팀이 $year $comp 챔피언에 올랐습니다. 결승에서 $loser 격파$result.';
  }

  @override
  String msgFinalScoreSuffix(int home, int away) {
    return ' (결승 $home–$away)';
  }

  @override
  String msgFinalPensSuffix(int home, int away) {
    return ' (결승 $home–$away, 승부차기 승)';
  }

  @override
  String get msgWpotyTitle => '올해의 세계 선수';

  @override
  String msgWpotyBodyMine(String name, String nation, int year) {
    return '$name($nation) 선수가 $year 올해의 세계 선수로 선정되었습니다. 우리 선수입니다.';
  }

  @override
  String msgWpotyBodyOther(String name, String nation, int year) {
    return '$name($nation) 선수가 $year 올해의 세계 선수로 선정되었습니다.';
  }

  @override
  String get msgYpotTitle => '대회 영플레이어';

  @override
  String msgYpotBodyMine(String name, String nation, int age, int year) {
    return '$age세의 $name($nation) 선수가 $year 대회 영플레이어로 선정되었습니다. 우리 선수입니다.';
  }

  @override
  String msgYpotBodyOther(String name, String nation, int age, int year) {
    return '$age세의 $name($nation) 선수가 $year 대회 영플레이어로 선정되었습니다.';
  }

  @override
  String msgRankHold1(int rank) {
    return '$rank위를 유지했습니다.';
  }

  @override
  String msgRankHold2(int rank) {
    return '변동 없이 $rank위.';
  }

  @override
  String msgRankHold3(int rank) {
    return '$rank위로 제자리.';
  }

  @override
  String msgRankUp1(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move계단',
    );
    return '총 $_temp0 올라 $rank위.';
  }

  @override
  String msgRankUp2(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move계단',
    );
    return '$_temp0 상승해 $rank위가 되었습니다.';
  }

  @override
  String msgRankUp3(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move계단',
    );
    return '$_temp0 상승, 현재 $rank위.';
  }

  @override
  String msgRankDown1(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move계단',
    );
    return '총 $_temp0 내려가 $rank위.';
  }

  @override
  String msgRankDown2(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move계단',
    );
    return '$_temp0 하락해 $rank위로 떨어졌습니다.';
  }

  @override
  String msgRankDown3(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move계단',
    );
    return '$_temp0 하락, 현재 $rank위.';
  }

  @override
  String get msgRankLeadYou => '우리가 세계 1위입니다.';

  @override
  String msgRankLeadOther(String nation) {
    return '세계 1위: $nation.';
  }

  @override
  String msgRankTitle(int rank) {
    return '세계 랭킹 · $rank위';
  }

  @override
  String msgRankBody(String lead, String movement) {
    return '세계 랭킹이 업데이트되었습니다. $lead $movement';
  }

  @override
  String msgRankJumpTitleUp(int rank) {
    return '$rank위로 상승';
  }

  @override
  String msgRankJumpTitleDown(int rank) {
    return '$rank위로 하락';
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
      other: '$move계단',
    );
    return '$tournament 결과로 세계 랭킹이 바뀌었습니다. $nation: 대회 전 $from위, 대회 후 $to위. $_temp0 상승.';
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
      other: '$move계단',
    );
    return '$tournament 결과로 세계 랭킹이 바뀌었습니다. $nation: 대회 전 $from위, 대회 후 $to위. $_temp0 하락.';
  }

  @override
  String get rankingSinceWcDraw => '세계 선수권 조 추첨 이후';

  @override
  String get rankingSinceCycleStart => '캠페인 시작 이후';

  @override
  String rankingMovedFromTo(int from, int now) {
    return '$from위에서 $now위로';
  }

  @override
  String msgCapsTitle(String name, int count) {
    return '$name, A매치 $count경기 달성';
  }

  @override
  String msgCapsBody(String name, int count) {
    return '$name 선수가 우리 대표팀에서 $count경기에 출전했습니다.';
  }

  @override
  String msgGoalsTitle(String name, int count) {
    return '$name, A매치 $count골 달성';
  }

  @override
  String msgGoalsBody(String name, int count) {
    return '$name 선수가 우리 대표팀에서 A매치 $count골을 기록했습니다.';
  }

  @override
  String msgDevTitle(int year) {
    return '스쿼드 성장 보고서 · $year';
  }

  @override
  String msgThroughTitle(int year) {
    return '아카데미 출신 · $year';
  }

  @override
  String get msgThroughNote =>
      '새로 들어온 선수들이 아닙니다. 열한 살에 들어와 이제 성인 풀까지 성장한 선수들입니다.';

  @override
  String msgNewFacesTitle(int year) {
    return '새 얼굴 · $year';
  }

  @override
  String get msgIntakeNoteAcademy =>
      '아카데미 투자가 효과를 보고 있습니다: 이번 신입생들은 원래보다 더 강하게 들어왔습니다.';

  @override
  String get msgIntakeNoteStanding =>
      '온 나라가 이 팀을 지켜보고 있습니다: 대표팀이 세계 랭킹을 오르자 뛰어난 소년들이 축구를 택했고, 이번 신입생들은 그만큼 더 강합니다.';

  @override
  String get msgIntakeNoteBoth =>
      '아카데미 투자와 대표팀의 랭킹 상승이 모두 효과를 보고 있습니다: 이번 신입생들은 원래보다 더 강하게 들어왔습니다.';

  @override
  String msgIntakeTitle(int year) {
    return '아카데미 신입생 · $year';
  }

  @override
  String msgRetireCaptainTitle(String name) {
    return '주장 $name 은퇴';
  }

  @override
  String msgRetireTitle(String name) {
    return '$name, 대표팀 은퇴';
  }

  @override
  String msgRetireBody(String name, int age) {
    return '$name 선수가 $age세에 국가대표 은퇴를 선언했습니다.';
  }

  @override
  String msgRetireBodyWith(String name, String tally, int age) {
    return '$name 선수가 $age세에 국가대표 은퇴를 선언했습니다. 통산 기록: $tally.';
  }

  @override
  String msgTallyCaps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count경기',
    );
    return '$_temp0';
  }

  @override
  String msgTallyGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count골',
    );
    return '$_temp0';
  }

  @override
  String get msgArmbandVacant => ' 주장 자리가 비었습니다. 소집 화면에서 새 주장을 정하세요.';

  @override
  String msgHofTitle(String name) {
    return '$name, 명예의 전당 헌액';
  }

  @override
  String msgHofBody(String name, int caps, int goals) {
    return '$name 선수가 우리 대표팀 명예의 전당에 헌액되었습니다($caps경기, $goals골). 레전드에서 확인하세요.';
  }

  @override
  String hubBanTitle(String name) {
    return '$name 출전 정지';
  }

  @override
  String hubBanBody(String name, String how, int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: '다음 $matches경기',
    );
    return '$name 선수는 $how $_temp0 출전 정지 징계를 받았습니다. 선발할 수 없습니다.';
  }

  @override
  String get hubBanHowSecondYellow => '경고 누적으로 퇴장당해';

  @override
  String get hubBanHowViolent => '폭력 행위로 다이렉트 퇴장당해';

  @override
  String get hubBanHowRed => '퇴장당해';

  @override
  String hubInjuryTitle(String name) {
    return '$name 부상';
  }

  @override
  String hubInjuryBody(String name, int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: '$matches경기',
    );
    return '$name 선수가 부상을 당해 $_temp0 결장합니다.';
  }

  @override
  String get hubRunnerUpTitle1 => '준우승';

  @override
  String get hubRunnerUpTitle2 => '손에 잡힐 듯했지만';

  @override
  String get hubRunnerUpTitle3 => '은메달';

  @override
  String hubRunnerUpBody1(String cup, String opponent) {
    return '$cup 결승에 올랐지만 $opponent에게 패했습니다. 정말 아까웠습니다. 이번에는 은메달입니다.';
  }

  @override
  String hubRunnerUpBody2(String cup, String opponent) {
    return '$cup 결승에서 $opponent에게 패했습니다. 가슴 아프게도 준우승입니다.';
  }

  @override
  String hubRunnerUpBody3(String cup, String opponent) {
    return '$cup 결승, $opponent 상대로 우승을 놓쳤습니다. 자랑스러운 여정이었지만 트로피는 없습니다.';
  }

  @override
  String get hubKnockedOutTitle1 => '탈락';

  @override
  String get hubKnockedOutTitle2 => '여정의 끝';

  @override
  String get hubKnockedOutTitle3 => '여기까지';

  @override
  String hubKnockedOutBody1(String cup, String opponent, String stage) {
    return '$cup $stage에서 $opponent에게 패해 탈락했습니다.';
  }

  @override
  String hubKnockedOutBody2(String cup, String opponent, String stage) {
    return '$stage에서 만난 $opponent에게 막혀 $cup 여정이 끝났습니다.';
  }

  @override
  String hubKnockedOutBody3(String cup, String opponent, String stage) {
    return '$cup 여정이 $stage에서 끝났습니다. 상대는 $opponent.';
  }

  @override
  String get hubGroupExitTitle1 => '조별 리그 탈락';

  @override
  String get hubGroupExitTitle2 => '조별 리그에서 탈락';

  @override
  String get hubGroupExitTitle3 => '이른 퇴장';

  @override
  String hubGroupExitBody1(String cup) {
    return '$cup 여정이 조별 리그에서 끝났습니다. 토너먼트 진출에는 역부족이었습니다.';
  }

  @override
  String hubGroupExitBody2(String cup) {
    return '조별 리그를 통과하지 못했습니다. $cup 여정은 여기까지입니다.';
  }

  @override
  String hubGroupExitBody3(String cup) {
    return '이번에는 토너먼트 진출이 없습니다. $cup 여정은 조별 리그에서 끝났습니다.';
  }

  @override
  String boardObjectiveMetTitle(String comp) {
    return '목표 달성: $comp';
  }

  @override
  String boardObjectiveMissedTitle(String comp) {
    return '목표 실패: $comp';
  }

  @override
  String boardObjectiveMetBody(String comp, String demand, String finish) {
    return '$comp 이사회 목표: $demand. 최종 성적: $finish. 이사회가 요구한 것을 해냈습니다.';
  }

  @override
  String boardObjectiveMissedBody(String comp, String demand, String finish) {
    return '$comp 이사회 목표: $demand. 최종 성적: $finish. 기대에 미치지 못했습니다.';
  }

  @override
  String get newsWcMissTitle => '세계 선수권의 꿈이 끝나다';

  @override
  String newsWcMissBody(int year) {
    return '$year 세계 선수권 진출에 실패했습니다. 예선에서 힘이 모자랐습니다. 다시 4년을 기다려야 합니다.';
  }

  @override
  String get newsRecordScorerTitle => '역대 최다 득점자';

  @override
  String newsRecordScorerBody(String name, int goals) {
    return '$name 선수가 $goals골로 역대 최다 득점자가 되었습니다.';
  }

  @override
  String get newsRecordCapsTitle => '역대 최다 출전 선수';

  @override
  String newsRecordCapsBody(String name, int caps) {
    return '$name 선수가 $caps경기 출전으로 역대 최다 출전 선수가 되었습니다.';
  }

  @override
  String get newsARecordBreaker => '새로운 기록 보유자';

  @override
  String newsTransferTitle(String name, String club) {
    return '$name, $club 이적';
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
    return '$name($position, $rating) 선수가 $fromClub에서 $destination 유니폼을 입습니다. 이적료: $fee.';
  }

  @override
  String newsTransferAbroad(String club, String country) {
    return '$country의 $club';
  }

  @override
  String get newsTransferFree => '자유 이적';

  @override
  String newsNatzStarTitle(String name, String nation) {
    return '$name, $nation 대표팀으로 국적 변경 의사!';
  }

  @override
  String newsNatzTitle(String name, String nation) {
    return '$name, $nation 대표팀에서 뛰고 싶어 해';
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
    return '현재 $fromNation 소속인 $age세 $position $name(능력치 $rating) 선수가 $nation에 가족 연고가 있어 국적 변경에 열려 있습니다. 귀화 제안을 열어 수락하거나 거절하세요.';
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
    return '현재 $fromNation 소속인 $age세 $position $name(능력치 $rating) 선수는 스타급 선수로, $nation에 가족 연고가 있어 국적 변경에 열려 있습니다. 귀화 제안을 열어 수락하거나 거절하세요.';
  }

  @override
  String get newsTheirNation => '원래 대표팀';

  @override
  String get newsYourNation => '우리 대표팀';

  @override
  String get tourStatusChampions => '우승';

  @override
  String get tourStatusFinals => '본선';

  @override
  String get tourStatusQualifying => '예선';

  @override
  String get tourStatusUpcoming => '예정';

  @override
  String get tourStatusInProgress => '진행 중';

  @override
  String get tourStatusComingSoon => '곧 시작';

  @override
  String get tourStatusDecided => '종료';

  @override
  String tourStatusLeague(String letter) {
    return '리그 $letter';
  }

  @override
  String get tourDrawWcQualifying => '세계 선수권 예선 조 추첨';

  @override
  String tourDrawContQualifying(String cup) {
    return '$cup 예선 조 추첨';
  }

  @override
  String get tourDrawWcHost => '세계 선수권 개최국';

  @override
  String tourDrawContHost(String cup) {
    return '$cup 개최국';
  }

  @override
  String get tourDrawHostsReveal => '그리고 개최국은…';

  @override
  String get tourDrawHostReveal => '그리고 개최국은…';

  @override
  String get tourDrawHostCandidates => '유치 후보:';

  @override
  String get tourKickoffContinentalCup => '대륙컵';

  @override
  String tourHostCompetitionYear(String competition, int year) {
    return '$year $competition';
  }

  @override
  String newsContMissTitle(String cup) {
    return '$cup 진출 실패';
  }

  @override
  String newsContMissBody(String cup) {
    return '$cup 본선 진출에 실패했습니다. 이번 캠페인은 힘이 모자랐습니다.';
  }

  @override
  String get potyLabelBest => '올해의 선수';

  @override
  String get potyLabelYoung => '올해의 영플레이어';

  @override
  String potyTallyAssists(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count도움',
    );
    return '$_temp0';
  }

  @override
  String potyOverallValue(int value) {
    return '능력치 $value';
  }

  @override
  String potyRatingValue(String value) {
    return '평점 $value';
  }

  @override
  String newsPotyTitle(int year) {
    return '$year 올해의 세계 선수';
  }

  @override
  String newsPotyBody(String name) {
    return '$name 선수가 올해 세계 최고의 선수로 뽑혔습니다.';
  }

  @override
  String newsPotyYoungSuffix(String name) {
    return ' 영플레이어상은 $name 선수가 차지했습니다.';
  }

  @override
  String newsWatchTitle(int year) {
    return '관심 유망주 보고서, $year';
  }

  @override
  String newsWatchJump(String name, int rating, int gain) {
    String _temp0 = intl.Intl.pluralLogic(
      gain,
      locale: localeName,
      other: '$gain점',
    );
    return '$name 선수가 $rating까지 성장했습니다. 지난해보다 $_temp0 상승.';
  }

  @override
  String newsWatchBand(String name, String band) {
    return '$name 선수가 $band 단계로 올라갑니다.';
  }

  @override
  String newsWatchDebutTitle(String name) {
    return '$name, A매치 데뷔';
  }

  @override
  String newsWatchDebutBody(String name, int age, int rating) {
    return '$name 선수가 $age세에 첫 A매치에 출전했습니다(능력치 $rating). 관심 유망주 중 한 명입니다.';
  }

  @override
  String get matchStatsAtFullTime =>
      '점유율, 선수 평점, 경기 최우수 선수는 경기 종료 휘슬과 함께 확정됩니다.';

  @override
  String get matchPlayerRatings => '선수 평점';

  @override
  String get matchSubstitutions => '교체';

  @override
  String get matchSubstitutes => '교체 선수';

  @override
  String get matchPlayerOfTheMatch => '경기 최우수 선수';

  @override
  String get matchGoalShout => '골!';

  @override
  String matchShootoutScore(int home, int away) {
    return '승부차기 $home–$away';
  }

  @override
  String matchShootoutKickScored(String name) {
    return '$name: 성공';
  }

  @override
  String matchShootoutKickMissed(String name) {
    return '$name: 실축';
  }

  @override
  String get matchFeedKickOff => '킥오프!';

  @override
  String get matchFeedNoEvents => '아직 이벤트가 없습니다.';

  @override
  String get tourVenues => '경기장';

  @override
  String tourPot(int number) {
    return '포트 $number';
  }

  @override
  String get tourHostSelection => '개최국 선정';

  @override
  String get tourCandidates => '유치 후보';

  @override
  String get tourJointBid => '공동 유치';

  @override
  String get tourGoldenGlove => '골든 글러브';

  @override
  String get tourTeamOfTournament => '대회 베스트 11';

  @override
  String get tourYourRun => '우리 팀 여정';

  @override
  String get tourMedalTable => '메달 순위';

  @override
  String tourHostLine(String nation) {
    return '개최국: $nation';
  }

  @override
  String tourHostLineMulti(String hosts) {
    return '개최국: $hosts';
  }

  @override
  String tourGroupNamed(String name) {
    return '$name조';
  }

  @override
  String get tourFinalsDrawBlurb => '세계 랭킹으로 시드를 배정합니다. 추첨 전에 우리 대표팀을 찾아보세요.';

  @override
  String get tourWorldRanking => '세계 랭킹';

  @override
  String get tourYourCompetitions => '참가 대회';

  @override
  String get tourOtherContinents => '다른 대륙';

  @override
  String get tourZoneGlobal => '세계';

  @override
  String get tourZoneEurope => '유럽';

  @override
  String get tourZoneSouthAmerica => '남미';

  @override
  String get tourZoneNorthAmerica => '북중미';

  @override
  String get tourZoneAfrica => '아프리카';

  @override
  String get tourZoneAsia => '아시아';

  @override
  String get tourZoneOceania => '오세아니아';

  @override
  String get tourZoneIntercontinental => '대륙 간';

  @override
  String tourZoneLeague(String league) {
    return '리그 $league';
  }

  @override
  String tourHostedBy(String hosts) {
    return '개최국  $hosts';
  }

  @override
  String tourThirdsAdvance(int count, String destination) {
    return '상위 $count팀 $destination 진출';
  }

  @override
  String newsWalkoutTitle(String name) {
    return '$name, 대표팀을 떠나다';
  }

  @override
  String newsWalkoutBody(String name, int age, int caps) {
    return '$name 선수가 $age세, $caps경기 출전을 끝으로 국가대표 은퇴를 선언했습니다. 자신의 입지를 알려 달라고 했지만 답을 듣지 못했고, 더는 기다리지 않기로 했습니다.';
  }

  @override
  String get pressHeadlineWent1 => '기자회견장을 장악한 감독';

  @override
  String get pressHeadlineWent2 => '언쟁을 기대했지만 리더를 만났다';

  @override
  String get pressHeadlineWent3 => '솔직한 답변, 제대로 먹혔다';

  @override
  String get pressHeadlineMixed1 => '말은 많았지만 정리된 건 없다';

  @override
  String get pressHeadlineMixed2 => '모두를 위한 말, 그러나 누구에게도 와닿지 않았다';

  @override
  String get pressHeadlineMixed3 => '질문만 남긴 기자회견';

  @override
  String get pressHeadlineBadly1 => '카메라 앞에서 혹독했던 오후';

  @override
  String get pressHeadlineBadly2 => '분위기가 돌아섰고, 티가 났다';

  @override
  String get pressHeadlineBadly3 => '아침 신문에서 더 나빠 보일 답변들';

  @override
  String get pressHeadlineFlat1 => '말한 것도, 얻은 것도 없다';

  @override
  String get pressHeadlineFlat2 => '10분, 뉴스는 없었다';

  @override
  String get pressHeadlineFlat3 => '스포츠면에 빈 페이지';

  @override
  String get pressConferenceTitle => '기자회견';

  @override
  String pressQuestionOf(int index, int total) {
    return '질문 $index/$total';
  }

  @override
  String get pressTomorrowsHeadline => '내일 스포츠면';

  @override
  String get pressLeaveRoom => '회견장 나가기';

  @override
  String get pressRoomVerdictSquad => '라커룸';

  @override
  String get pressRoomVerdictBoard => '이사회';

  @override
  String get yReactionElation0 => '할 말 없음. 1도 없음. 완벽.';

  @override
  String get yReactionElation1 => '나 지금 제정신 아님 (좋은 의미로).';

  @override
  String get yReactionElation2 => '액자에 넣는다. 벽난로 위에 건다.';

  @override
  String get yReactionElation3 => '우리가 돌아왔다';

  @override
  String get yReactionElation4 => '의심하던 사람들 보라고 캡처해 둔다. 전부.';

  @override
  String get yReactionElation5 => '앞으로 10년은 이 얘기로 잘난 척할 거다.';

  @override
  String get yReactionElation6 => '그래. 이 맛에 축구 본다.';

  @override
  String get yReactionElation7 => '이런 날이 다른 날들을 보상해 준다.';

  @override
  String get yReactionElation8 => '드디어. 진짜, 드디어.';

  @override
  String get yReactionElation9 => '좋아. 다음 주에도 해내면 믿어 줄게.';

  @override
  String get yReactionElation10 => '오늘 밤은 즐겨라. 어차피 이 팀이 망칠 방법을 찾을 테니까.';

  @override
  String get yReactionElation11 => '좋은 밤 하루로 위대한 팀이 되진 않는다.';

  @override
  String get yReactionRelief0 => '예쁘진 않지만 매번 이러면 좋겠다.';

  @override
  String get yReactionRelief1 => '어떻게든. 어떻게든!';

  @override
  String get yReactionRelief2 => '못생긴 승리. 승점 3. 넘어가자.';

  @override
  String get yReactionRelief3 => '승점만 따라온다면 못생긴 경기 하루 종일 환영.';

  @override
  String get yReactionRelief4 => '수명 10년 줄었다';

  @override
  String get yReactionRelief5 => '아무도 말하지 마. 부정 탄다.';

  @override
  String get yReactionRelief6 => '심박수: 위험 수준.';

  @override
  String get yReactionRelief7 => '살아남았다. 그 말이 딱이다. 살아남았다.';

  @override
  String get yReactionRelief8 => '이런 경기에서 안도할 필요가 없어야 하는데.';

  @override
  String get yReactionRelief9 => '안도했다. 그리고 안도한 게 좀 창피하다.';

  @override
  String get yReactionRelief10 => '이 정도에 환호하는 거라면 우린 큰일 났다.';

  @override
  String get yReactionRelief11 => '간신히 통과하는 것도 습관이다. 나쁜 습관.';

  @override
  String get yReactionFury0 => '부족하다. 한참 부족하다.';

  @override
  String get yReactionFury1 => '누가 저거 천천히 설명 좀 해 봐.';

  @override
  String get yReactionFury2 => '보기 힘든 경기였다. 이것도 순화한 표현이다.';

  @override
  String get yReactionFury3 => '실망이다. 진심으로 실망이다.';

  @override
  String get yReactionFury4 => '이게 무슨 꼴이냐.';

  @override
  String get yReactionFury5 => '이름 대라.';

  @override
  String get yReactionFury6 => '앱 삭제한다. 목요일에 다시 깐다.';

  @override
  String get yReactionFury7 => '저기서 이기고 싶어 보이는 선수가 하나도 없었다.';

  @override
  String get yReactionFury8 => '4년마다 똑같다. 4년마다!';

  @override
  String get yReactionFury9 => '저건 경기력이 아니라 모욕이다.';

  @override
  String get yReactionFury10 => '사람들이 주말이랑 돈을 저기에 쓴다. 생각 좀 해 봐라.';

  @override
  String get yReactionFury11 => '몇 년간 이 팀을 감쌌다. 오늘은 아니다. 저걸 보고는.';

  @override
  String get yReactionDespair0 => '하.';

  @override
  String get yReactionDespair1 => '오늘은 농담 없다. 아무것도.';

  @override
  String get yReactionDespair2 => '산책 간다. 아주 긴 산책.';

  @override
  String get yReactionDespair3 => '이걸 표현할 말이 더는 없다.';

  @override
  String get yReactionDespair4 => '4년 뒤에 깨워 줘.';

  @override
  String get yReactionDespair5 => '이게 최악의 평행세계다';

  @override
  String get yReactionDespair6 => '이젠 화도 안 난다. 그게 더 걱정이다.';

  @override
  String get yReactionDespair7 => '이건 오래도록 쓰라릴 거다.';

  @override
  String get yReactionDespair8 => '이게 뭔지 이제 모르겠다. 하지만 축구팀은 아니다.';

  @override
  String get yReactionDespair9 => '전보다 더 멀어졌는데, 아무도 그 말을 안 한다.';

  @override
  String get yReactionDespair10 => '한 세대를 통째로 날렸는데, 같은 사람들이 다음을 결정한다.';

  @override
  String get yReactionDespair11 => '과정이라는 말 좀 그만해라. 아무 데도 안 가고 있다.';

  @override
  String get yReactionSmugness0 => '조용히 말하지만: 내가 말했지.';

  @override
  String get yReactionSmugness1 => '이거 북마크해 둬라';

  @override
  String get yReactionSmugness2 => '의심하던 사람들이 아주 조용해졌네.';

  @override
  String get yReactionSmugness3 => '누가 세는 건 아니고. 내가 센다.';

  @override
  String get yReactionSmugness4 => '1월에 말했다. 타임라인 확인해 봐.';

  @override
  String get yReactionSmugness5 => '여기 몇몇은 우리 몇몇한테 사과해야 한다.';

  @override
  String get yReactionSmugness6 => '\'내가 먼저 말한 것\' 폴더에 저장.';

  @override
  String get yReactionSmugness7 => '자랑 안 한다. 조금만 한다.';

  @override
  String get yReactionSmugness8 => '그 많던 전문가들 다 어디 갔나? 진짜 궁금해서.';

  @override
  String get yReactionSmugness9 => '한 명도 빠짐없이 내 앞에서 다시 말해 봐라.';

  @override
  String get yReactionSmugness10 => '캡처, 인쇄, 액자, 비웃던 사람들한테 발송.';

  @override
  String get yReactionSmugness11 => '평생 이 얘기 꺼낼 거다. 너희가 자초한 거다.';

  @override
  String get yReactionShrug0 => '일어났다. 다음.';

  @override
  String get yReactionShrug1 => '그래. 뭐. 계속 가자.';

  @override
  String get yReactionShrug2 => '\'축구\' 폴더에 저장.';

  @override
  String get yReactionShrug3 => '정말 덧붙일 말이 없다.';

  @override
  String get yReactionShrug4 => '생각 없음, 머릿속 텅 빔';

  @override
  String get yReactionShrug5 => '다음 경기 때 깨워 줘.';

  @override
  String get yReactionShrug6 => '돌려받을 수 없는 90분.';

  @override
  String get yReactionShrug7 => '이것도 저것도 아니다, 정말.';

  @override
  String get yReactionShrug8 => '무슨 일이 있었는지 하나도 기억 안 난다.';

  @override
  String get yReactionShrug9 => '또 그런 경기. 그런 경기가 참 많다.';

  @override
  String get yReactionShrug10 => '끝까지 다 봤는데 아무 느낌이 없다.';

  @override
  String get yReactionShrug11 => '다시는 아무도 이 얘기 안 꺼내면 좋겠다.';

  @override
  String get tourThirdsUneven =>
      '조별 팀 수가 달라, 큰 조에서는 최하위 팀과의 경기 결과를 제외하고 모든 팀을 같은 경기 수로 평가합니다.';

  @override
  String get careerExportSave => '이 저장 파일 백업';

  @override
  String get careerBackupAll => '모든 저장 파일 백업';

  @override
  String get careerBackupAllFailed => '백업 파일을 만들 수 없습니다.';

  @override
  String get backupTitle => '백업';

  @override
  String get backupBlurb =>
      '모든 저장 파일은 이 휴대폰의 파일 하나에 들어 있으며, 아래 자동 백업을 켜지 않으면 따로 백업되지 않습니다. 휴대폰을 잃어버리거나 앱을 삭제해도 커리어를 잃지 않도록 클라우드에 사본을 보관하세요.';

  @override
  String get backupBlurbNoAuto =>
      '모든 저장 파일은 이 휴대폰의 파일 하나에 들어 있으며, 따로 자동 백업되지 않습니다. 휴대폰을 잃어버리거나 앱을 삭제해도 커리어를 잃지 않도록 클라우드에 사본을 보관하세요.';

  @override
  String get backupExport => '클라우드에 백업';

  @override
  String get backupExportSubject => 'FNM 저장 파일';

  @override
  String get backupRestore => '파일에서 복원';

  @override
  String get backupRestoreWarnTitle => '모든 저장 파일을 바꿀까요?';

  @override
  String get backupRestoreWarnBody =>
      '복원하면 이 휴대폰의 모든 저장 파일이 파일 속 저장 파일로 바뀝니다. 앱이 다시 시작됩니다.';

  @override
  String get backupRestoreConfirm => '바꾸기';

  @override
  String get backupCancel => '취소';

  @override
  String get backupExported => '백업 준비 완료. 보관할 곳을 선택하세요.';

  @override
  String get backupFailed => '백업 파일을 만들 수 없습니다.';

  @override
  String get backupRejectedUnreadable => '그 파일을 열 수 없습니다.';

  @override
  String get backupRejectedNotFnm => 'FNM 저장 파일이 아닙니다.';

  @override
  String get backupRejectedNewer => '더 새로운 버전의 앱에서 만든 저장 파일입니다. 먼저 업데이트하세요.';

  @override
  String get backupRejectedTooOld => '이 버전에서 복원하기에는 너무 오래된 저장 파일입니다.';

  @override
  String get careerShare => '이 커리어 공유';

  @override
  String get careerImport => '커리어 가져오기';

  @override
  String get careerShareSubject => 'FNM 커리어';

  @override
  String get careerImported => '커리어를 가져왔습니다.';

  @override
  String get careerImportFailedUnreadable => 'FNM 커리어 파일이 아닙니다.';

  @override
  String get careerImportFailedNewer => '더 새로운 버전의 앱에서 내보낸 커리어입니다. 먼저 업데이트하세요.';

  @override
  String get careerImportFailedSlotsFull =>
      '저장 슬롯이 모두 사용 중입니다. 저장 파일을 삭제해 공간을 만들거나 무제한 저장을 잠금 해제하세요.';

  @override
  String get careerImportFailedNeedsPremium =>
      '무료 첫 대회 주기를 넘긴 커리어입니다. 가져오려면 정식 버전을 잠금 해제하세요.';

  @override
  String get careerImportFailedCampaignRun =>
      '해당 캠페인은 이미 진행 중입니다. 먼저 이어서 하거나 포기하세요.';

  @override
  String get careerShareFailed => '커리어를 내보낼 수 없습니다.';

  @override
  String get managerRename => '이름 변경';

  @override
  String get managerRenameSave => '저장';

  @override
  String get managerTitle => '감독';

  @override
  String get managerSkills => '나의 능력';

  @override
  String managerPointsAvailable(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '사용할 포인트 $count점',
      zero: '사용할 포인트 없음',
    );
    return '$_temp0';
  }

  @override
  String get managerPointsHow => '대회 주기를 마칠 때마다 2점, 트로피를 딸 때마다 1점을 얻습니다.';

  @override
  String get managerSkillsScale =>
      '모든 능력은 5에서 시작해 20에서 멈춥니다. 사용한 포인트는 되돌릴 수 없습니다.';

  @override
  String get managerSkillManManagement => '선수 관리';

  @override
  String get managerSkillManManagementBlurb =>
      '1점마다 언론과 선수들에게 하는 말이 라커룸에 3% 더 강하게 전달됩니다.';

  @override
  String get managerSkillTactical => '전술';

  @override
  String get managerSkillTacticalBlurb =>
      '1점마다 새 포메이션이 3% 더 빨리 자리 잡아, 대형 변경의 부담이 줄어듭니다.';

  @override
  String get managerSkillYouth => '유소년 육성';

  @override
  String get managerSkillYouthBlurb => '1점마다 투자와 별도로 아카데미 출신 선수의 재능이 1% 늘어납니다.';

  @override
  String get managerSkillNegotiation => '협상';

  @override
  String get managerSkillNegotiationBlurb =>
      '1점마다 대회 주기마다 협회에서 받는 자금이 2% 늘어납니다.';

  @override
  String get managerStaff => '나의 스태프';

  @override
  String managerStaffWages(String amount) {
    return '급여: 대회 주기당 $amount';
  }

  @override
  String get managerRoleAssistant => '수석 코치';

  @override
  String get managerRoleAssistantBlurb => '훈련을 담당합니다: 부상 감소, 더 나은 유망주 배출.';

  @override
  String get managerRoleScout => '수석 스카우트';

  @override
  String get managerRoleScoutBlurb => '유망주와 다음 상대를 분석합니다: 더 정확한 별점, 경기 당일의 우위.';

  @override
  String get managerRoleFitness => '피지컬 코치';

  @override
  String get managerRoleFitnessBlurb => '선수들이 경기장에 남아 있게 합니다.';

  @override
  String staffEffectInjury(int percent) {
    return '부상 $percent% 감소';
  }

  @override
  String staffEffectYouth(int points) {
    return '유망주 종합 +$points';
  }

  @override
  String staffHiringInjury(int min, int max) {
    return '고용 시: 부상 $min%~$max% 감소';
  }

  @override
  String staffHiringYouth(int minPoints, int maxPoints) {
    return '유망주 종합 +$minPoints~+$maxPoints';
  }

  @override
  String staffEffectScoutRead(int percent) {
    return '유망주 $percent% 정확히 파악';
  }

  @override
  String staffEffectScoutCaps(int caps) {
    String _temp0 = intl.Intl.pluralLogic(
      caps,
      locale: localeName,
      other: '$caps경기 출전 후 잠재력 파악',
      one: '1경기 출전 후 잠재력 파악',
    );
    return '$_temp0';
  }

  @override
  String staffEffectScoutDossier(int points) {
    return '상대 분석 보고서로 평점 +$points';
  }

  @override
  String staffHiringScoutRead(int min, int max) {
    return '고용 시: $min%~$max% 정확히 파악';
  }

  @override
  String staffHiringScoutCaps(int minCaps, int maxCaps) {
    return '잠재력 파악 $minCaps~$maxCaps경기 단축';
  }

  @override
  String staffHiringScoutDossier(int minPoints, int maxPoints) {
    return '매 경기 평점 +$minPoints~+$maxPoints';
  }

  @override
  String get staffEffectNone => '아직 스쿼드에 효과 없음';

  @override
  String get staffVacant => '공석';

  @override
  String get staffLeaveVacant => '공석으로 두기';

  @override
  String get managerTierNone => '없음';

  @override
  String get managerTierBasic => '기본';

  @override
  String get managerTierGood => '우수';

  @override
  String get managerTierElite => '최정상';

  @override
  String get managerFree => '무료';

  @override
  String get managerTraining => '소집 기간 사이';

  @override
  String get managerTrainingBlurb => '경기가 없을 때 스쿼드가 집중하는 훈련입니다.';

  @override
  String get managerFocusBalanced => '균형';

  @override
  String get managerFocusBalancedBlurb => '골고루 조금씩.';

  @override
  String get managerFocusFitness => '체력';

  @override
  String get managerFocusFitnessBlurb => '부상 감소.';

  @override
  String get managerFocusCohesion => '조직력';

  @override
  String get managerFocusCohesionBlurb => '대형이 더 빨리 자리 잡습니다.';

  @override
  String get managerFocusYouth => '유소년';

  @override
  String get managerFocusYouthBlurb => '풀의 가장 어린 선수들과 보내는 시간.';

  @override
  String get tourOfferTitle => '처음이신가요?';

  @override
  String get tourOfferBody =>
      '규모가 큰 게임입니다. 중요한 화면을 빠르게 둘러볼까요? 1분이면 되고, 설정에서 언제든 다시 볼 수 있습니다.';

  @override
  String get tourOfferYes => '둘러보기';

  @override
  String get tourOfferNo => '괜찮습니다';

  @override
  String get tourBack => '뒤로';

  @override
  String get tourNext => '다음';

  @override
  String get tourDone => '완료';

  @override
  String get tourSkip => '건너뛰기';

  @override
  String get tourHubTitle => '이것이 게임의 전부입니다';

  @override
  String get tourHubBody =>
      '버튼 하나가 대회 주기에 따라 바뀝니다: 지켜볼 추첨, 발표할 스쿼드, 치를 경기. 그 위에는 이사회의 신뢰도와 이사회가 정한 목표가 있습니다.';

  @override
  String get tourBudgetTitle => '협회의 자금';

  @override
  String get tourBudgetBody =>
      '4년 대회 주기마다 한 번, 자금을 각 부서에 나눕니다. 스태프 급여가 먼저 나가므로 최정상 스카우트 고용은 아카데미와 함께가 아니라 아카데미를 희생하는 결정입니다.';

  @override
  String get tourTacticsTitle => '팀의 경기 방식';

  @override
  String get tourTacticsBody =>
      '대형, 경기 스타일, 주장, 세트피스 키커. 마지막 두 가지를 정하지 않으면 게임이 몰래 정하는 대신 킥오프 전에 경고합니다.';

  @override
  String get tourSquadTitle => '선발 가능한 모든 선수';

  @override
  String get tourSquadBody =>
      '스쿼드만이 아닌 전체 풀: 누가 폼이 좋은지, 누가 부상을 안고 있는지, 누가 출전 정지인지, 누가 막 아카데미를 거쳐 올라왔는지.';

  @override
  String get tourCallUpsTitle => '스쿼드 발표';

  @override
  String get tourCallUpsBody =>
      'A매치 기간마다 스쿼드 하나를 발표하고, 실제 감독처럼 그 기간의 모든 경기를 그 스쿼드로 치릅니다. 기간 중 부상자가 생기면 대체 선수가 자동으로 합류합니다.';

  @override
  String get tourRecordsTitle => '나의 커리어';

  @override
  String get tourRecordsBody => '지금까지의 모든 것: 경기, 팀 기록, 트로피, 지휘했던 모든 국가.';

  @override
  String get tourCupsTitle => '나머지 세계';

  @override
  String get tourCupsBody =>
      '지금 진행 중인 모든 대회: 우리가 참가하지 않은 대회까지 조, 순위, 토너먼트를 볼 수 있습니다. 본선에 나가든 못 나가든 세계는 계속 돌아갑니다.';

  @override
  String get settingsTourTitle => '튜토리얼 다시 보기';

  @override
  String get settingsTourBlurb => '주요 화면을 처음부터 다시 둘러봅니다.';

  @override
  String get tourBoardTitle => '당신의 상관';

  @override
  String get tourBoardBody =>
      '당신에 대한 이사회의 신뢰도와 이번 대회 주기의 목표입니다. 목표를 놓치면 여기서 위기를 먼저 감지할 수 있습니다.';

  @override
  String get tourStaffTitle => '당신 곁의 사람들';

  @override
  String get tourStaffBody =>
      '수석 코치, 스카우트, 피지컬 코치를 직접 고용합니다. 급여가 부서 예산보다 먼저 나가므로 뛰어난 스카우트는 아카데미를 희생하는 결정입니다.';

  @override
  String get tourPlaystyleTitle => '당신의 축구';

  @override
  String get tourPlaystyleBody =>
      '대형은 전술의 절반일 뿐입니다. 나머지 절반이 여기 있습니다: 얼마나 높이 압박할지, 얼마나 직선적일지, 얼마나 위험을 감수할지.';

  @override
  String get settingsTourNoSave => '먼저 커리어를 시작하세요. 둘러보기는 당신의 화면을 직접 보여 줍니다.';

  @override
  String tacticsOutOfPositionAge(int age) {
    return '비주력 포지션 · $age세';
  }

  @override
  String get federationNextCycleLocked =>
      '다음 대회 주기의 예산은 그 주기가 시작될 때 한 번에 정합니다. 그때까지는 현재 자금이 이렇게 쓰입니다.';

  @override
  String get federationBudgetAlreadySet => '이번 주기 예산 확정됨';

  @override
  String yFinalLooms0(String opponent) {
    return '결승 상대는 $opponent. 일주일 내내 이 얘기만 할 거다.';
  }

  @override
  String yFinalLooms1(String opponent) {
    return '확정: 우리와 트로피 사이에 $opponent. 이걸 위해 4년을 기다렸다.';
  }

  @override
  String yFinalLooms2(String opponent) {
    return '좋아. $opponent. 끝날 때까지 아무도 못 잔다.';
  }

  @override
  String yFinalLooms3(String opponent) {
    return '다음은 $opponent, 나머지는 다 미뤄도 된다. 살아 있길 잘했다.';
  }

  @override
  String get matchSetupLeaveToCoach => '키커는 코치에게 맡기기';

  @override
  String friendliesLikeYourGroup(String rivals) {
    return '아래 표시: 이번 주기 조별 리그 상대인 $rivals처럼 경기하는 팀들.';
  }

  @override
  String newsTransferWindowTitle(int year) {
    return '이적 시장 · $year';
  }

  @override
  String careerLastAgo(String when) {
    return '마지막: $when 전';
  }

  @override
  String get settingsFreeScopeTitle => '4년 대회 주기 1회 무료';

  @override
  String get settingsFreeScopeBlurb =>
      '완전한 대회 주기 한 번(예선, 대륙 선수권, 세계 선수권)을 저장 파일 두 개로, 전 세계 모든 국가와 함께 제한 없이 즐길 수 있습니다. 끝없는 대회 주기와 무제한 저장은 단 한 번의 결제로, 앞으로의 모든 업데이트도 포함됩니다.';

  @override
  String get settingsUnlockedTitle => '잠금 해제됨';

  @override
  String get settingsUnlockedBlurb => '끝없는 대회 주기, 무제한 저장, 앞으로의 모든 업데이트. 감사합니다.';

  @override
  String get settingsFromDeveloperTitle => '개발자의 말';

  @override
  String get settingsFromDeveloperBlurb =>
      'Football Nations Manager는 한 사람이 만들며 오랫동안 지원될 예정입니다. 광고나 소액 결제는 절대 없을 것입니다. 게임이 즐거우셨다면 정식 버전 구매를 고려해 주세요. 그것이 업데이트를 이어가는 힘입니다.';

  @override
  String get settingsFromDeveloperThanksBlurb =>
      'Football Nations Manager는 한 사람이 만들며 오랫동안 지원될 예정입니다. 광고나 소액 결제는 절대 없을 것입니다. 정식 버전을 구매해 주셔서 감사합니다. 그것이 업데이트를 이어가는 힘입니다.';

  @override
  String friendliesLikeYourCampaign(String rivals) {
    return '아래 표시: 아직 맞붙어야 할 $rivals처럼 경기하는 팀들.';
  }

  @override
  String get friendliesCloseToYou =>
      '아래 표시: 세계 랭킹에서 우리와 가장 가까운 팀들. 조 추첨이 끝나면 우리 조에 맞춰 표시됩니다.';

  @override
  String transfersMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '이적 $count건',
      one: '이적 1건',
    );
    return '$_temp0';
  }

  @override
  String hubRoundPage(int page, int pages) {
    return '$page / $pages';
  }

  @override
  String get transfersNewer => '최신';

  @override
  String get transfersOlder => '더 보기';

  @override
  String get transfersPagePrevious => '이전';

  @override
  String get transfersPageNext => '다음';

  @override
  String transfersPageOf(int page, int pages) {
    return '$pages페이지 중 $page페이지';
  }

  @override
  String get transfersMovedTo => '이적';

  @override
  String get transfersUnknownClub => '알 수 없는 클럽';

  @override
  String yAgainstThemAgain0(String opponent, String count) {
    return '$opponent전만 벌써 $count번째. 누군가 점수를 세고 있다면, 그건 저쪽이다.';
  }

  @override
  String yAgainstThemAgain1(String opponent, String count) {
    return '또 $opponent. $count번 붙었는데 아직도 공략법을 모른다.';
  }

  @override
  String yAgainstThemAgain2(String opponent, String count) {
    return '$opponent전 $count번째. 이제 우연이 아니다.';
  }

  @override
  String yAgainstThemAgain3(String opponent, String count) {
    return '$opponent 상대로 $count번 붙었는데 그중 어느 경기에서도 배운 게 없다.';
  }

  @override
  String yAgainstThemAgain4(String opponent, String count) {
    return '$opponent, $count번째. 우리가 뭘 할지 저쪽은 다 안다.';
  }

  @override
  String yAgainstThemAgain5(String opponent, String count) {
    return '$count번을 붙어도 $opponent에게는 여전히 우리를 이기는 뭔가가 있다.';
  }

  @override
  String ySameOldStory0(String count) {
    return '최근에만 벌써 $count번째. 이쯤 되면 이게 우리 실력 아닌가?';
  }

  @override
  String ySameOldStory1(String count) {
    return '이런 오후가 벌써 $count번. 운이 아니라 패턴이다.';
  }

  @override
  String ySameOldStory2(String count) {
    return '최근 똑같은 경기를 $count번 봤다. 같은 각본, 같은 결말.';
  }

  @override
  String ySameOldStory3(String count) {
    return '똑같은 90분의 $count번째 버전. 아무도 고치지 않는다.';
  }

  @override
  String ySameOldStory4(String count) {
    return '$count번. 아직도 패턴이 안 보인다면 안 보려는 거다.';
  }

  @override
  String ySameOldStory5(String count) {
    return '같은 이야기가 $count번째. 결과보다 변명이 먼저 바닥났다.';
  }

  @override
  String get yToldYouSo0 => '다들 축하하느라 바쁠 때 이렇게 될 거라고 말했다.';

  @override
  String get yToldYouSo1 => '좋은 2주 보내니까 또 황금 세대라더라. 그리고 지금 이 꼴이다.';

  @override
  String get yToldYouSo2 => '지난달 나한테 즐기라던 사람들, 다 조용해졌네.';

  @override
  String get yToldYouSo3 => '이게 기쁘진 않다. 아주 조금 기쁘다. 약간.';

  @override
  String get yToldYouSo4 => '그들 말만큼 좋았던 적은 한 번도 없었고, 이게 증거다.';

  @override
  String get yToldYouSo5 => '매번 그렇다. 이번엔 다르다더니, 매번 아니다.';

  @override
  String get tacticsSubOffAlready => '교체됨';

  @override
  String get tacticsSubInjured => '부상';

  @override
  String get tacticsSubSentOffMark => '퇴장';

  @override
  String get tacticsSubNoneLeft => '교체 소진';

  @override
  String get tacticsUndoLastChange => '마지막 변경 취소';

  @override
  String get matchStrengthTitle => '팀 전력에 영향을 주는 요소';

  @override
  String get strengthFactorFamiliarity => '대형 숙련도';

  @override
  String get strengthFactorFatigue => '피로';

  @override
  String get strengthFactorClubForm => '클럽 폼';

  @override
  String get strengthFactorMorale => '라커룸';

  @override
  String get strengthFactorCaptain => '주장';

  @override
  String get strengthFactorStaff => '스태프';

  @override
  String get strengthFactorDossier => '스카우트 보고서';

  @override
  String yDebut0(String name) {
    return '$name 첫 A매치 출전. 이름 기억해 둬라.';
  }

  @override
  String yDebut1(String name) {
    return '$name 데뷔. 보이지? 뭔가 있다.';
  }

  @override
  String yDebut2(String name) {
    return '$name, 첫 출전. 이 기회를 어떻게 쓰는지 보자.';
  }

  @override
  String yDebut3(String name) {
    return '$name 데뷔. 스쿼드 어딘가엔 새 다리가 필요했다.';
  }

  @override
  String yDebut4(String name) {
    return '$name에게 A매치 기회. 요즘 이런 기회 참 많이 준다.';
  }

  @override
  String yDebut5(String name) {
    return '$name 데뷔. 봄이 오면 잊힐 또 한 명.';
  }

  @override
  String yDrought0(String name, String count) {
    return '$name, $count경기째 무득점이지만 그 외엔 다 해내고 있다.';
  }

  @override
  String yDrought1(String name, String count) {
    return '$name, $count경기 무득점. 골은 몰아서 오는 법이다.';
  }

  @override
  String yDrought2(String name, String count) {
    return '$name: $count경기, 무득점.';
  }

  @override
  String yDrought3(String name, String count) {
    return '$name, $count경기째 골이 없다. 지켜볼 만하다.';
  }

  @override
  String yDrought4(String name, String count) {
    return '$count경기. 무득점. $name, 빈 골대도 못 맞힐 판.';
  }

  @override
  String yDrought5(String name, String count) {
    return '$name, $count경기째 골이 없다. 제발 아무나 다른 선수 써라.';
  }

  @override
  String yRivalryLooms0(String opponent, String count) {
    return '다음은 $opponent. $count번 붙었어도 여전히 모든 걸 건 경기다.';
  }

  @override
  String yRivalryLooms1(String opponent, String count) {
    return '$opponent전 벌써 $count번째. 덤벼라.';
  }

  @override
  String yRivalryLooms2(String opponent, String count) {
    return '다음은 $opponent. 통산 $count번째.';
  }

  @override
  String yRivalryLooms3(String opponent, String count) {
    return '이번 주 $opponent전, 통산 $count번째 맞대결.';
  }

  @override
  String yRivalryLooms4(String opponent, String count) {
    return '또 $opponent. $count번이나 붙고도 배운 게 없다.';
  }

  @override
  String yRivalryLooms5(String opponent, String count) {
    return '$opponent전 $count경기, 그런데도 아직 저쪽이 이긴다. 훌륭하다.';
  }

  @override
  String get positionGoalkeeper => '골키퍼';

  @override
  String get positionLeftBack => '왼쪽 풀백';

  @override
  String get positionCentreBack => '센터백';

  @override
  String get positionRightBack => '오른쪽 풀백';

  @override
  String get positionDefensiveMid => '수비형 미드필더';

  @override
  String get positionCentralMid => '중앙 미드필더';

  @override
  String get positionAttackingMid => '공격형 미드필더';

  @override
  String get positionLeftMid => '왼쪽 미드필더';

  @override
  String get positionRightMid => '오른쪽 미드필더';

  @override
  String get positionLeftWing => '왼쪽 윙어';

  @override
  String get positionRightWing => '오른쪽 윙어';

  @override
  String get positionStriker => '스트라이커';

  @override
  String get roleNone => '역할 없음';

  @override
  String get roleTargetMan => '타깃맨';

  @override
  String get rolePoacher => '골잡이';

  @override
  String get rolePlaymaker => '플레이메이커';

  @override
  String get roleBallWinner => '볼 위너';

  @override
  String get roleInvertedWinger => '인버티드 윙어';

  @override
  String get roleBallPlayingDefender => '빌드업 수비수';

  @override
  String get roleNoneBlurb => '자기 스타일대로 뜁니다.';

  @override
  String get roleTargetManBlurb => '헤더를 따내고 연결합니다. 도움과 세트피스.';

  @override
  String get rolePoacherBlurb => '박스 안에 머뭅니다. 골이 훨씬 늘어납니다.';

  @override
  String get rolePlaymakerBlurb => '기회를 만듭니다. 도움이 훨씬 늘어납니다.';

  @override
  String get roleBallWinnerBlurb => '마무리보다 상대 공격 차단에 집중합니다.';

  @override
  String get roleInvertedWingerBlurb => '안으로 파고들어 슈팅합니다. 골 증가.';

  @override
  String get roleBallPlayingDefenderBlurb => '후방에서 공격을 시작합니다.';

  @override
  String get federationDeptYouth => '유소년 아카데미';

  @override
  String get federationDeptCommercial => '마케팅 / 홍보';

  @override
  String get federationDeptMedical => '의료 및 스포츠 과학';

  @override
  String get federationDeptNaturalisation => '귀화 사무국';

  @override
  String get federationDeptBoardRelations => '이사회 관계';

  @override
  String get federationDeptYouthBlurb => '다음 대회 주기에 더 뛰어난 아카데미 유망주가 데뷔합니다.';

  @override
  String get federationDeptCommercialBlurb => '후원으로 대회 주기 말에 추가 수입이 생깁니다.';

  @override
  String get federationDeptMedicalBlurb => '부상 감소. 스쿼드가 주기 내내 건강을 유지합니다.';

  @override
  String get federationDeptNaturalisationBlurb =>
      '더 많은 외국 선수가 우리 대표팀으로 귀화를 제안합니다.';

  @override
  String get federationDeptBoardRelationsBlurb => '이사회가 결과를 더 너그럽게 평가합니다.';

  @override
  String get federationBuildingAcademy => '아카데미';

  @override
  String get federationBuildingCommercial => '마케팅 본부';

  @override
  String get federationBuildingMedical => '메디컬 센터';

  @override
  String get federationBuildingScouting => '스카우트 사무소';

  @override
  String get federationBuildingBoardroom => '이사회실';

  @override
  String get moraleBuoyant => '의기양양';

  @override
  String get moralePositive => '긍정적';

  @override
  String get moraleSettled => '안정';

  @override
  String get moraleUneasy => '불안';

  @override
  String get moraleRockBottom => '바닥';

  @override
  String get matchTabTimeline => '타임라인';

  @override
  String get matchTabStats => '기록';

  @override
  String get matchTabLineups => '라인업';

  @override
  String get matchPenalty => '페널티킥';

  @override
  String get matchStateLevel => '동점입니다';

  @override
  String matchStateLead(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count골 앞서 있습니다',
      one: '1골 앞서 있습니다',
    );
    return '$_temp0';
  }

  @override
  String matchStateTrail(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count골 뒤지고 있습니다',
      one: '1골 뒤지고 있습니다',
    );
    return '$_temp0';
  }

  @override
  String matchPossessionShare(int possession) {
    return '점유율 $possession%';
  }

  @override
  String get boardVerdictSackedTitle => '이사회가 당신을 경질했습니다';

  @override
  String boardVerdictSackedBody(int rating) {
    return '참담한 대회 주기였습니다(평가 $rating%). 당신의 시대는 여기서 끝납니다. 이제 약체 국가들만 당신에게 기회를 줄 것입니다.';
  }

  @override
  String get boardVerdictDelightedTitle => '이사회가 매우 만족합니다';

  @override
  String boardVerdictDelightedBody(int rating, String best) {
    return '훌륭한 대회 주기였습니다(평가 $rating%, 최고 성과: $best). 더 큰 국가들이 관심을 보이고 있으며, 남아서 팀을 키울 수도 있습니다.';
  }

  @override
  String get boardVerdictSolidTitle => '안정적인 대회 주기';

  @override
  String boardVerdictSolidBody(int rating) {
    return '이사회는 만족합니다(평가 $rating%). 비슷한 수준의 몇몇 국가가 당신을 원하지만, 떠날 압박은 없습니다.';
  }

  @override
  String get boardVerdictExpectedMoreTitle => '이사회는 더 많은 것을 기대했습니다';

  @override
  String boardVerdictExpectedMoreBody(int rating) {
    return '실망스러운 대회 주기였습니다(평가 $rating%). 자리는 지켰지만, 들어오는 제안은 한 단계 낮은 곳뿐입니다.';
  }

  @override
  String get boardVerdictPressureTitle => '심각한 압박을 받고 있습니다';

  @override
  String boardVerdictPressureBody(int rating) {
    return '부진한 대회 주기였습니다(평가 $rating%). 살아남았지만, 새 출발을 원한다면 약한 국가들만 관심을 보입니다.';
  }

  @override
  String get boardVerdictHeroTitle => '온 나라가 당신 편입니다';

  @override
  String boardVerdictHeroNote(String nation, int cycles) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles번의 대회 주기',
    );
    return ' $nation 국민들은 $_temp0 동안 함께한 국민 영웅인 당신을 사랑합니다. 원하는 만큼 자리는 안전합니다.';
  }

  @override
  String get boardVerdictTheNation => '온 나라';

  @override
  String get boardVerdictBestQuiet => '조용한 주기';

  @override
  String get boardVerdictBestCycle => '이번 주기';

  @override
  String boardVerdictBestWorld(String placement) {
    return '세계 선수권 $placement';
  }

  @override
  String get finishThirdPlace => '3위';

  @override
  String get finishFourthPlace => '4위';

  @override
  String get finishDidNotQualify => '본선 진출 실패';

  @override
  String get careerRepIconic => '전설적';

  @override
  String get careerRepRenowned => '명장';

  @override
  String get careerRepEstablished => '자리 잡음';

  @override
  String get careerRepRising => '떠오르는 감독';

  @override
  String get careerRepUnproven => '검증 안 됨';

  @override
  String get hubOfferStepUp => '상위 팀';

  @override
  String get hubOfferLateral => '수평 이동';

  @override
  String get hubOfferRebuild => '재건';

  @override
  String careerNationsCupWon(String league) {
    return '리그 $league · 우승';
  }

  @override
  String careerNationsCupRunnerUp(String league) {
    return '리그 $league · 준우승';
  }

  @override
  String careerNationsCupSemi(String league) {
    return '리그 $league · 4강';
  }

  @override
  String careerNationsCupPlaced(String league, int position) {
    return '리그 $league · $position위';
  }

  @override
  String tourRunInto(String round) {
    return '$round 진출';
  }

  @override
  String get tourRunIntoThirdPlace => '3위 결정전 진출';

  @override
  String tourRunThrough(String round) {
    return '$round 통과';
  }

  @override
  String tourRunOut(String round) {
    return '$round 탈락';
  }

  @override
  String get tourRunInGroup => '조별 리그 진행 중';

  @override
  String get tourRunGroupOut => '조별 리그 탈락';

  @override
  String resultsCycleTitle(int year, String nation) {
    return '$year 대회 주기 · $nation';
  }

  @override
  String resultsCycleRecord(int played, int won, int drawn, int lost) {
    return '$played경기  ·  $won승 $drawn무 $lost패';
  }

  @override
  String resultsCycleFinish(String finish) {
    return '세계 선수권: $finish';
  }

  @override
  String get resultsCycleUnderway => '진행 중';

  @override
  String yTurnedItRound0(String opponent) {
    return '전반 끝나고 $opponent에 두 골 뒤졌는데 전부 되찾았다. 이게 팀이다.';
  }

  @override
  String yTurnedItRound1(String opponent) {
    return '$opponent 상대로 두 골 뒤졌지만 끝나고 보니 상관없었다. 이런 팀 많지 않다.';
  }

  @override
  String yTurnedItRound2(String opponent) {
    return '하프타임: $opponent에 두 골 차 열세. 경기 종료: 아니었다. 후반은 완전히 다른 경기였다.';
  }

  @override
  String yTurnedItRound3(String opponent) {
    return '$opponent 상대로 두 골 차를 뒤집었다. 하프타임에 무슨 말을 했든, 매주 해라.';
  }

  @override
  String yTurnedItRound4(String opponent) {
    return '그래, $opponent 상대로 따라잡았다. 이제 누가 전반 45분 좀 설명해 봐라.';
  }

  @override
  String yTurnedItRound5(String opponent) {
    return '$opponent에 두 골 뒤졌다 따라잡았는데 기뻐하라고? 전반부터 고쳐라.';
  }

  @override
  String yThrewItAway0(String opponent) {
    return '전반 끝나고 $opponent에 두 골 앞섰는데 놓쳤다. 더 좋은 팀들도 겪는 일이다.';
  }

  @override
  String yThrewItAway1(String opponent) {
    return '$opponent 상대로 두 골 앞섰다가 놓쳤다. 대회 주기는 길고, 시간은 충분하다.';
  }

  @override
  String yThrewItAway2(String opponent) {
    return '하프타임: $opponent에 두 골 차 리드. 경기 종료: 전혀 다른 결과.';
  }

  @override
  String yThrewItAway3(String opponent) {
    return '$opponent 상대 두 골 리드, 45분 만에 증발.';
  }

  @override
  String yThrewItAway4(String opponent) {
    return '두 골 앞서다 놓쳤다. 상대는 $opponent. 누군가 책임져야 한다.';
  }

  @override
  String yThrewItAway5(String opponent) {
    return '$opponent 상대로 두 골 앞서 놓고 이 꼴이다. 매번 그렇다.';
  }

  @override
  String get cycleBackupDone =>
      '이 휴대폰의 FNM 폴더에 커리어를 백업했습니다. 앱을 삭제하면 함께 지워지니, 다른 곳에 사본을 두려면 저장 파일 화면에서 \'이 저장 파일 백업\'을 사용하세요.';

  @override
  String get cycleBackupFailed => '이번에는 커리어를 백업하지 못했습니다.';

  @override
  String pressMomentBigWinWarm1(String opponent) {
    return '$opponent전, 잊지 못할 밤이었습니다. 이 선수들이 얼마나 자랑스럽습니까?';
  }

  @override
  String pressMomentBigWinWarm2(String opponent) {
    return '$opponent 대표팀은 전혀 상대가 되지 않았습니다. 늘 믿어 온 팀의 모습입니까?';
  }

  @override
  String pressMomentBigWinNeutral1(String opponent) {
    return '$opponent 상대로 큰 승리를 거뒀습니다. 오늘 밤 승부를 가른 건 무엇입니까?';
  }

  @override
  String pressMomentBigWinNeutral2(String opponent) {
    return '$opponent 상대로 여유 있게 이겼습니다. 어디서 승부가 났다고 보십니까?';
  }

  @override
  String pressMomentBigWinHostile1(String opponent) {
    return '$opponent 상대로 좋은 승리였습니다. 하지만 하룻밤일 뿐인데, 이게 계속될 거라고 왜 믿어야 합니까?';
  }

  @override
  String pressMomentBigWinHostile2(String opponent) {
    return '$opponent전, 훌륭한 결과였습니다. 감독님의 계획이었습니까, 아니면 선수들이 스스로 해낸 겁니까?';
  }

  @override
  String pressMomentBigLossWarm1(String opponent) {
    return '$opponent전, 힘든 밤이었습니다. 이런 경기 뒤에 선수들에게 무슨 말을 하십니까?';
  }

  @override
  String pressMomentBigLossWarm2(String opponent) {
    return '$opponent전 결과는 아무도 예상 못 했습니다. 그냥 운이 나쁜 밤이었습니까?';
  }

  @override
  String pressMomentBigLossNeutral1(String opponent) {
    return '$opponent전은 뼈아픈 밤이었습니다. 무엇이 잘못됐습니까?';
  }

  @override
  String pressMomentBigLossNeutral2(String opponent) {
    return '$opponent에게 완전히 무너졌습니다. 이 스쿼드로 충분합니까?';
  }

  @override
  String pressMomentBigLossHostile1(String opponent) {
    return '$opponent 상대로 모든 면에서 밀렸습니다. 어떻게 이 지경까지 됐습니까?';
  }

  @override
  String pressMomentBigLossHostile2(String opponent) {
    return '$opponent에게 마음대로 골을 내줬습니다. 오늘 밤 계획은 어디 있었습니까?';
  }

  @override
  String pressMomentCrisisWarm1(String opponent) {
    return '이번엔 $opponent전에서 또 놓쳤습니다. 이 흐름을 어떻게 바꾸시겠습니까?';
  }

  @override
  String pressMomentCrisisWarm2(String opponent) {
    return '결과가 말라붙었고, $opponent전으로 더 나빠졌습니다. 아직 이 선수들을 믿습니까?';
  }

  @override
  String pressMomentCrisisNeutral1(String opponent) {
    return '$opponent전에서도 승리가 없었고, 이사회가 지켜보고 있습니다. 자리는 안전합니까?';
  }

  @override
  String pressMomentCrisisNeutral2(String opponent) {
    return '$opponent전 이후 부진이 길어지고 있습니다. 미래가 걱정되십니까?';
  }

  @override
  String pressMomentCrisisHostile1(String opponent) {
    return '이제 $opponent에게까지 졌습니다. 전임 감독은 이런 흐름에서 경질됐습니다. 감독님은 왜 살아남아야 합니까?';
  }

  @override
  String pressMomentCrisisHostile2(String opponent) {
    return '$opponent전 같은 밤이 또 지나고, 라디오 청취자 전화마다 경질을 외칩니다. 이사회가 요청하면 물러나시겠습니까?';
  }

  @override
  String pressMomentJobVerdictWarm1(String opponent) {
    return '자리를 걸었는데, $opponent전 이후 뜻대로 되지 않았습니다. 어떻게 견디고 계십니까?';
  }

  @override
  String pressMomentJobVerdictWarm2(String opponent) {
    return '세 경기가 끝났고, 마지막은 $opponent전이었습니다. 직접 정한 시험이었는데, 결과를 어떻게 보십니까?';
  }

  @override
  String pressMomentJobVerdictNeutral1(String opponent) {
    return '다음 세 경기로 평가해 달라고 하셨죠. $opponent전까지 끝났습니다. 아직 감독직은 감독님 것입니까?';
  }

  @override
  String pressMomentJobVerdictNeutral2(String opponent) {
    return '세 경기, 마지막은 $opponent전, 약속한 결과는 아니었습니다. 이사회와 거취를 논의했습니까?';
  }

  @override
  String pressMomentJobVerdictHostile1(String opponent) {
    return '직접 정한 시험에서 $opponent전으로 낙제했습니다. 사임하시겠습니까?';
  }

  @override
  String pressMomentJobVerdictHostile2(String opponent) {
    return '우리 말이 아니라 감독님 말이었습니다: 다음 세 경기로 평가해 달라. $opponent전이 끝났는데, 왜 아직 그 자리에 계십니까?';
  }

  @override
  String get pressBeatWhoToBlameWarm1 => '선수들에게 더 많은 걸 원하신다고요. 특정 선수가 있습니까?';

  @override
  String get pressBeatWhoToBlameWarm2 => '기준을 높게 세우셨습니다. 누가 먼저 나서야 합니까?';

  @override
  String get pressBeatWhoToBlameNeutral1 =>
      '일부 선수는 스스로를 돌아봐야 한다고 하셨습니다. 누구를 말씀하시는 겁니까?';

  @override
  String get pressBeatWhoToBlameNeutral2 => '충분하지 않다고 하셨는데, 누구 얘기입니까?';

  @override
  String get pressBeatWhoToBlameHostile1 =>
      '계속 애매하게 말씀하십니다. 이름을 대시겠습니까, 아니면 결국 감독님 책임입니까?';

  @override
  String get pressBeatWhoToBlameHostile2 => '매주 다른 사람 탓입니다. 이번엔 누구 탓입니까?';

  @override
  String get pressBeatIfYouDontWarm1 => '용감한 말씀입니다. 다음 경기가 뜻대로 안 되면요?';

  @override
  String get pressBeatIfYouDontWarm2 =>
      '온 나라가 그 말을 기억할 겁니다. 실현되지 않으면 어떻게 하시겠습니까?';

  @override
  String get pressBeatIfYouDontNeutral1 => '이기지 못하면요? 그다음은요?';

  @override
  String get pressBeatIfYouDontNeutral2 => '이제 말씀하셨습니다. 틀리면 어떻게 됩니까?';

  @override
  String get pressBeatIfYouDontHostile1 =>
      '이 방에서 약속은 전에도 들었습니다. 이번 약속도 깨지면 팬들에게 무엇을 빚지는 겁니까?';

  @override
  String get pressBeatIfYouDontHostile2 => '그리고 실패하면, 이번엔 어떤 변명을 하실 겁니까?';

  @override
  String get pressBeatFollowUpWarm1 => '괜찮으시다면 하나만 더. 이 팀이 아직 보완해야 할 점은 무엇입니까?';

  @override
  String get pressBeatFollowUpWarm2 => '흥분이 가라앉으면, 오늘 밤에서 무엇을 다음 경기로 가져가시겠습니까?';

  @override
  String get pressBeatFollowUpNeutral1 =>
      '조금 더 깊이 들어가 보죠. 다음 경기 전에 무엇이 나아져야 합니까?';

  @override
  String get pressBeatFollowUpNeutral2 => '스코어를 떠나서, 이 스쿼드는 원하는 수준에 와 있습니까?';

  @override
  String get pressBeatFollowUpHostile1 =>
      '말은 많았지만 내용은 없었습니다. 이제부터 실제로 무엇이 바뀝니까?';

  @override
  String get pressBeatFollowUpHostile2 => '팬들은 솔직한 답을 원합니다. 이 팀, 충분합니까, 아닙니까?';

  @override
  String pressBeatStandoutWarm1(String player) {
    return '오늘 밤 $player 선수가 탁월했습니다. 어디까지 갈 수 있을까요?';
  }

  @override
  String pressBeatStandoutWarm2(String player) {
    return '오늘 밤 모든 헤드라인이 $player 선수 얘기입니다. 예상하셨습니까?';
  }

  @override
  String pressBeatStandoutNeutral1(String player) {
    return '$player 선수가 돋보였습니다. 오늘 밤 그에게 무엇을 주문하셨습니까?';
  }

  @override
  String pressBeatStandoutNeutral2(String player) {
    return '오늘 밤 승부를 가른 건 $player 선수였습니까?';
  }

  @override
  String pressBeatStandoutHostile1(String player) {
    return '$player 선수가 없었다면 다른 이야기였을 겁니다. 이게 팀입니까, 선수 한 명입니까?';
  }

  @override
  String pressBeatStandoutHostile2(String player) {
    return '$player 선수가 훌륭했습니다. 감독님 덕입니까, 선수 덕입니까?';
  }

  @override
  String pressBeatStrugglerWarm1(String player) {
    return '$player 선수가 힘든 밤을 보냈습니다. 부상이 있습니까?';
  }

  @override
  String pressBeatStrugglerWarm2(String player) {
    return '$player 선수에게는 잘 안 풀린 밤이었습니다. 따로 다독여 주실 겁니까?';
  }

  @override
  String pressBeatStrugglerNeutral1(String player) {
    return '$player 선수가 오늘 고전했습니다. 자리를 지킬 수 있습니까?';
  }

  @override
  String pressBeatStrugglerNeutral2(String player) {
    return '$player 선수가 속도를 따라가지 못하는 것 같았습니다. 그의 경기를 어떻게 보셨습니까?';
  }

  @override
  String pressBeatStrugglerHostile1(String player) {
    return '$player 선수는 또 존재감이 없었습니다. 왜 계속 기용하십니까?';
  }

  @override
  String pressBeatStrugglerHostile2(String player) {
    return '$player 선수가 제 컨디션이 아니라는 건 모두가 봤습니다. 벤치만 빼고요?';
  }

  @override
  String get pressThrowbackWinNextKeptWarm =>
      '다음 경기를 이기겠다고 하셨고, 이겼습니다. 예언이 맞으니 기분이 좋으십니까?';

  @override
  String get pressThrowbackWinNextKeptNeutral =>
      '다음 경기 승리를 약속했고 지켰습니다. 자신감입니까, 허세였습니까?';

  @override
  String get pressThrowbackWinNextKeptHostile =>
      '다음 경기를 이기겠다고 했고, 이겼습니다. 운입니까, 아니면 이제 귀 기울여야 합니까?';

  @override
  String get pressThrowbackWinNextBrokenWarm =>
      '그 경기를 이기겠다고 하셨는데 그러지 못했습니다. 무엇이 잘못됐습니까?';

  @override
  String get pressThrowbackWinNextBrokenNeutral =>
      '다음 경기를 이기겠다고 했지만 못 이겼습니다. 다음 약속은 왜 믿어야 합니까?';

  @override
  String get pressThrowbackWinNextBrokenHostile =>
      '다음 경기를 이기겠다고 했지만 못 이겼습니다. 이 방에서 감독님 말에 아직 무게가 있습니까?';

  @override
  String get pressThrowbackJobKeptWarm =>
      '세 경기로 평가해 달라고 하셨고, 통과했습니다. 증명했다고 보십니까?';

  @override
  String get pressThrowbackJobKeptNeutral =>
      '다음 세 경기로 평가해 달라고 하셨죠. 그렇게 했고 결과가 나왔습니다. 그 시험에서 무엇을 배우셨습니까?';

  @override
  String get pressThrowbackJobKeptHostile =>
      '스스로 세 경기를 주고 통과했습니다. 애초에 그렇게 어려운 시험이었습니까?';

  @override
  String get pressThrowbackJobBrokenWarm =>
      '세 경기로 평가해 달라고 하셨지만 뜻대로 되지 않았습니다. 무엇을 배우셨습니까?';

  @override
  String get pressThrowbackJobBrokenNeutral =>
      '다음 세 경기로 평가해 달라고 하셨죠. 세 경기는 끝났고, 믿어 줄 여유도 사라졌습니다. 이제 어떻게 하시겠습니까?';

  @override
  String get pressThrowbackJobBrokenHostile =>
      '직접 시험을 정하고 낙제했습니다. 이제 누가 감독님 말을 믿겠습니까?';

  @override
  String pressThrowbackBackKeptWarm(String player) {
    return '다들 외면할 때 $player 선수를 믿으셨고, 그가 해냈습니다. 감독님 공도 있다고 보십니까?';
  }

  @override
  String pressThrowbackBackKeptNeutral(String player) {
    return '$player 선수를 믿으셨고, 그가 해냈습니다. 믿음이었습니까, 확신이었습니까?';
  }

  @override
  String pressThrowbackBackKeptHostile(String player) {
    return '$player 선수를 믿으셨고, 이번만큼은 통했습니다. 다음에도 그렇게 확신하시겠습니까?';
  }

  @override
  String pressThrowbackBackBrokenWarm(String player) {
    return '$player 선수 편에 섰지만 잘 풀리지 않았습니다. 아직 그를 믿으십니까?';
  }

  @override
  String pressThrowbackBackBrokenNeutral(String player) {
    return '$player 선수를 믿으셨지만 보답받지 못했습니다. 실수였습니까?';
  }

  @override
  String pressThrowbackBackBrokenHostile(String player) {
    return '판단력입니까, 의리입니까. $player 선수 건에서는 어느 쪽이 실패한 겁니까?';
  }

  @override
  String pressThrowbackBlameKeptWarm(String player) {
    return '$player 선수를 엄하게 비판하셨고, 이후 경기들이 감독님 말이 옳았음을 보여 줬습니다. 만족스러우십니까?';
  }

  @override
  String pressThrowbackBlameKeptNeutral(String player) {
    return '$player 선수를 공개적으로 지적하셨지만 그는 응답하지 못했습니다. 그에게 돌아올 길이 있습니까?';
  }

  @override
  String pressThrowbackBlameKeptHostile(String player) {
    return '$player 선수를 공개적으로 내몰았고 그는 회복하지 못했습니다. 감독님이 그를 무너뜨린 겁니까?';
  }

  @override
  String pressThrowbackBlameBrokenWarm(String player) {
    return '$player 선수를 지적하셨고, 그는 경기장에서 답했습니다. 처음부터 그게 의도였습니까?';
  }

  @override
  String pressThrowbackBlameBrokenNeutral(String player) {
    return '$player 선수를 탓하셨지만, 그 뒤로 그는 팀 최고의 선수 중 하나였습니다. 사과해야 하지 않습니까?';
  }

  @override
  String pressThrowbackBlameBrokenHostile(String player) {
    return '$player 선수를 희생양으로 삼았는데, 그 뒤로 그가 팀 최고의 선수였습니다. 사과하시겠습니까?';
  }

  @override
  String get pressReplyCreditPlayers1 =>
      '선수들은 모든 걸 쏟아부었습니다. 단 한 명도 바꾸고 싶지 않습니다.';

  @override
  String get pressReplyCreditPlayers2 =>
      '이 팀보다 열심히 하는 팀은 없습니다. 언제든 선수들을 감싸겠습니다.';

  @override
  String get pressReplyCreditPlayers3 => '이 자리에서 제 선수들을 탓하는 말은 한마디도 하지 않겠습니다.';

  @override
  String get pressReplyCreditPlayers4 => '공은 제가 아니라 선수들에게 있습니다. 그들에 대해 써 주십시오.';

  @override
  String get pressReplyTakeResponsibility1 =>
      '이번 경기는 제 책임입니다. 제가 선발을 정하고 전술을 짰습니다.';

  @override
  String get pressReplyTakeResponsibility2 =>
      '선수들이 아니라 저를 평가하십시오. 제 팀이고 제 책임입니다.';

  @override
  String get pressReplyTakeResponsibility3 => '탓할 사람이 필요하다면, 제가 바로 여기 앉아 있습니다.';

  @override
  String get pressReplyTakeResponsibility4 => '책임은 제게 있습니다. 선수들은 빼 주십시오.';

  @override
  String get pressReplyDemandMore1 => '더 많은 걸 원합니다. 몇몇은 제 말이 무슨 뜻인지 정확히 압니다.';

  @override
  String get pressReplyDemandMore2 =>
      '이 수준에서 노력만으로는 부족합니다. 더 원한다고 선수들에게 말했습니다.';

  @override
  String get pressReplyDemandMore3 => '내일부터 모든 선수에게 더 많은 걸 기대합니다.';

  @override
  String get pressReplyDemandMore4 => '몇몇은 스스로를 돌아봐야 합니다. 저는 만족하지 않습니다.';

  @override
  String get pressReplyPromiseWinNext1 => '다음 경기는 이깁니다. 적어 두셔도 됩니다.';

  @override
  String get pressReplyPromiseWinNext2 => '제 말 기억하십시오: 다음 경기는 이깁니다.';

  @override
  String get pressReplyPromiseWinNext3 =>
      '다음 경기, 이깁니다. 나중에 따지실 수 있게 여기서 말해 두겠습니다.';

  @override
  String get pressReplyPromiseWinNext4 => '이 팀을 확신합니다. 다음 경기는 이깁니다.';

  @override
  String get pressReplyJobOnTheLine1 => '다음 세 경기로 저를 평가하십시오. 그게 공정합니다.';

  @override
  String get pressReplyJobOnTheLine2 => '세 경기만 주십시오. 그때까지 바로잡지 못하면 그걸로 평가하십시오.';

  @override
  String get pressReplyJobOnTheLine3 =>
      '다음 세 경기가 제가 적임자인지 보여 줄 겁니다. 그 말 기억해 두십시오.';

  @override
  String get pressReplyJobOnTheLine4 => '세 경기입니다. 그 뒤엔 저에 대해 마음대로 쓰십시오.';

  @override
  String get pressReplyDeflect1 => '한 경기 한 경기 치를 뿐입니다. 더 드릴 말씀은 없습니다.';

  @override
  String get pressReplyDeflect2 => '오늘 여러분께 헤드라인거리를 드릴 생각은 없습니다.';

  @override
  String get pressReplyDeflect3 => '다음 경기. 그것만 생각하고 있습니다.';

  @override
  String get pressReplyDeflect4 => '제 생각은 라커룸 안에 남겨 두겠습니다.';

  @override
  String get pressReplyTakeCredit1 => '믿었기 때문에 말했고, 제가 옳았습니다.';

  @override
  String get pressReplyTakeCredit2 => '제대로 읽었습니다. 그게 제가 여기 있는 이유입니다.';

  @override
  String get pressReplyTakeCredit3 => '판단력이라고 해 두죠. 무슨 말을 하는지 알고 있었습니다.';

  @override
  String get pressReplyTakeCredit4 => '제가 결정했고 통했습니다. 그건 인정받겠습니다.';

  @override
  String get pressReplyStandByIt1 => '믿는 대로 말했습니다. 그 말은 변함없습니다.';

  @override
  String get pressReplyStandByIt2 => '한마디도 철회하지 않겠습니다.';

  @override
  String get pressReplyStandByIt3 => '그때와 같은 대답입니다. 진심이었고, 지금도 그렇습니다.';

  @override
  String get pressReplyStandByIt4 => '내일 또 물어도 똑같이 말하겠습니다.';

  @override
  String get pressReplyAdmitMistake1 => '제가 틀렸습니다. 인정합니다.';

  @override
  String get pressReplyAdmitMistake2 => '맞습니다, 제가 잘못 판단했습니다. 교훈으로 삼겠습니다.';

  @override
  String get pressReplyAdmitMistake3 => '제가 틀렸고, 그렇게 말할 수 있습니다.';

  @override
  String get pressReplyAdmitMistake4 => '그 결정은 통하지 않았고, 제 결정이었습니다.';

  @override
  String pressReplyBackPlayer1(String player) {
    return '$player 선수를 전적으로 신뢰합니다. 곧 살아날 겁니다.';
  }

  @override
  String pressReplyBackPlayer2(String player) {
    return '$player 선수를 믿습니다. 왜 그런지 직접 보여 줄 겁니다.';
  }

  @override
  String pressReplyBackPlayer3(String player) {
    return '$player 선수를 탓하는 말은 제게서 나오지 않습니다. 해낼 겁니다.';
  }

  @override
  String pressReplyBackPlayer4(String player) {
    return '$player 선수는 여전히 제 계획에 있습니다. 앞으로를 지켜보십시오.';
  }

  @override
  String pressReplyBlamePlayer1(String player) {
    return '$player 선수는 오늘 밤 기대를 저버렸고, 본인도 알고 있습니다.';
  }

  @override
  String pressReplyBlamePlayer2(String player) {
    return '$player 선수에게 훨씬 더 많은 걸 기대했습니다. 본인이 답해야 합니다.';
  }

  @override
  String pressReplyBlamePlayer3(String player) {
    return '$player 선수는 수준에 미치지 못했습니다. 공개적으로 말하겠습니다.';
  }

  @override
  String pressReplyBlamePlayer4(String player) {
    return '$player 선수의 플레이는 충분하지 않았고, 제가 직접 말할 겁니다.';
  }

  @override
  String get pressOnRecordWinNext => '공식 발언: 다음 경기에서 승리한다.';

  @override
  String get pressOnRecordJob => '공식 발언: 다음 세 경기로 평가받는다.';

  @override
  String pressOnRecordBack(String player) {
    return '공식 발언: $player 선수 신뢰.';
  }

  @override
  String pressOnRecordBlame(String player) {
    return '공식 발언: $player 선수가 기대를 저버렸다.';
  }

  @override
  String yStatementKept0(String nation) {
    return '말하고, 해냈다. $nation에 말에 책임지는 감독이 있다.';
  }

  @override
  String yStatementKept1(String nation) {
    return '대놓고 말하더니 진짜 해냈다. $nation에 필요했던 사람이다.';
  }

  @override
  String yStatementKept2(String nation) {
    return '$nation: 그가 예언했고, 이뤄졌다. 인정.';
  }

  @override
  String yStatementKept3(String nation) {
    return '공개적으로 말했고 지켰다. 한 점 인정. $nation, 다음으로.';
  }

  @override
  String yStatementKept4(String nation) {
    return '한 번은 맞혔다. $nation, 익숙해지지 마라.';
  }

  @override
  String yStatementKept5(String nation) {
    return '고장 난 시계도 하루 두 번은 맞는다. $nation, 이번엔 운이 좋았다.';
  }

  @override
  String yStatementBroken0(String nation) {
    return '말했지만 안 됐다. 그래도 그를 지지한다. $nation, 다시 가자.';
  }

  @override
  String yStatementBroken1(String nation) {
    return '$nation: 약속만큼은 못 했지만, 자기를 믿는 감독이 더 낫다.';
  }

  @override
  String yStatementBroken2(String nation) {
    return '$nation: 공개적으로 말했는데 안 됐다. 사람들은 기억할 거다.';
  }

  @override
  String yStatementBroken3(String nation) {
    return '큰소리만 치고 뒷받침은 없었다. $nation: 다음엔 말을 줄여라.';
  }

  @override
  String yStatementBroken4(String nation) {
    return '저기 서서 우리한테 말했다. 그리고 이 꼴이다. $nation에는 말보다 나은 게 필요하다.';
  }

  @override
  String yStatementBroken5(String nation) {
    return '이제 그의 말은 아무 가치가 없다. 적어 둬라, $nation.';
  }

  @override
  String get ncZoneNorth => '북부 지역';

  @override
  String get ncZoneWest => '서부 지역';

  @override
  String get ncZoneEast => '동부 지역';

  @override
  String get ncZoneCentralSouthern => '중남부 지역';

  @override
  String careerNationsCupZoneWon(String zone) {
    return '$zone · 우승';
  }

  @override
  String careerNationsCupZoneRunnerUp(String zone) {
    return '$zone · 준우승';
  }

  @override
  String careerNationsCupZoneSemi(String zone) {
    return '$zone · 4강';
  }

  @override
  String careerNationsCupZoneRoundOf16(String zone) {
    return '$zone · 16강';
  }

  @override
  String careerNationsCupZoneQuarter(String zone) {
    return '$zone · 8강';
  }

  @override
  String careerNationsCupZonePlaced(String zone, int position) {
    return '$zone · $position위';
  }

  @override
  String get objectiveNcFinalsEight => '8강 진출';

  @override
  String get objectiveNcZoneWinGroup => '조 1위';

  @override
  String get finishNcFinalsEight => '8강';

  @override
  String get finishNcBottomHalf => '조 하위권';

  @override
  String get tourContTabZones => '지역';

  @override
  String get tourContTabFinalsEight => '토너먼트';

  @override
  String get tourContFinalsEightSoon =>
      '토너먼트는 11월 16강으로 시작합니다: 14개 조 1위 팀과 성적 상위 2위 팀 2개.';

  @override
  String get tourContQuarterFinals => '8강';

  @override
  String get tourContZoneAdvancement =>
      '모든 조 1위 팀과 성적 상위 2위 팀 2개가 16강에 진출합니다. 강등은 없습니다.';

  @override
  String tourContZoneHeadingYours(String zone) {
    return '$zone ★';
  }

  @override
  String get compNorthAmericaNationsCup => '북중미 네이션스컵';

  @override
  String get compAfricanNationsCup => '네이션스컵';

  @override
  String get objectiveNcWinItNorthAmerica => '북중미 네이션스컵 우승';

  @override
  String get objectiveNcWinItAfrica => '네이션스컵 우승';

  @override
  String get objectiveNcReachFinalNorthAmerica => '북중미 네이션스컵 결승 진출';

  @override
  String get objectiveNcReachFinalAfrica => '네이션스컵 결승 진출';

  @override
  String get finishNcChampionsNorthAmerica => '북중미 네이션스컵 우승';

  @override
  String get finishNcChampionsAfrica => '네이션스컵 우승';

  @override
  String pressAimQualWarm1(String competition) {
    return '$competition 예선이 시작됩니다. 온 나라가 이 팀을 믿고 있습니다. 목표는 무엇입니까?';
  }

  @override
  String pressAimQualWarm2(String competition) {
    return '새로운 $competition 예선, 분위기가 좋습니다. 이 팀은 어디까지 갈 수 있습니까?';
  }

  @override
  String pressAimQualNeutral1(String competition) {
    return '$competition 예선이 시작됩니다. 이번 캠페인의 목표는 무엇입니까?';
  }

  @override
  String pressAimQualNeutral2(String competition) {
    return '$competition 예선이 다가왔습니다. 이 팀이 어디쯤에서 마칠 거라고 보십니까?';
  }

  @override
  String pressAimQualHostile1(String competition) {
    return '$competition 예선이 시작되는데, 본선에 못 갈 거라고 보는 사람이 많습니다. 그들에게 뭐라고 하시겠습니까?';
  }

  @override
  String pressAimQualHostile2(String competition) {
    return '또 한 번의 $competition 예선입니다. 이번엔 다를 거라고 왜 믿어야 합니까?';
  }

  @override
  String pressAimFinalsWarm1(String competition) {
    return '$competition 개막입니다. 온 나라가 응원하고 있습니다. 어디까지 갈 수 있습니까?';
  }

  @override
  String pressAimFinalsWarm2(String competition) {
    return '$competition 무대에 섰고, 팬들은 꿈을 꾸고 있습니다. 목표는 무엇입니까?';
  }

  @override
  String pressAimFinalsNeutral1(String competition) {
    return '이번 주 $competition 개막입니다. 무엇을 성공으로 보시겠습니까?';
  }

  @override
  String pressAimFinalsNeutral2(String competition) {
    return '$competition 첫 경기가 다가왔습니다. 목표를 말씀해 주십시오.';
  }

  @override
  String pressAimFinalsHostile1(String competition) {
    return '$competition 개막인데, 아무도 큰 기대를 하지 않습니다. 진짜 바라는 건 무엇입니까?';
  }

  @override
  String pressAimFinalsHostile2(String competition) {
    return '$competition 무대에 섰지만 의심은 사라지지 않았습니다. 목표는 무엇입니까?';
  }

  @override
  String pressBeatRivalWarm1(String rival) {
    return '$rival 대표팀이 같은 조입니다. 걱정되십니까?';
  }

  @override
  String pressBeatRivalWarm2(String rival) {
    return '추첨 결과 $rival 대표팀과 만나게 됐습니다. 그 경기를 어떻게 보십니까?';
  }

  @override
  String pressBeatRivalNeutral1(String rival) {
    return '$rival 대표팀이 조에서 가장 강해 보입니다. 그들이 우승 후보입니까?';
  }

  @override
  String pressBeatRivalNeutral2(String rival) {
    return '$rival 대표팀을 어떻게 보십니까?';
  }

  @override
  String pressBeatRivalHostile1(String rival) {
    return '$rival 대표팀이 같은 조입니다. 솔직히, 상대가 되겠습니까?';
  }

  @override
  String pressBeatRivalHostile2(String rival) {
    return '대부분 $rival 대표팀의 승리를 예상합니다. 그들이 틀렸습니까?';
  }

  @override
  String pressBeatKeyPlayerWarm1(String player) {
    return '$player 선수의 폼이 좋습니다. 지금이 그의 시간입니까?';
  }

  @override
  String pressBeatKeyPlayerWarm2(String player) {
    return '모든 헤드라인에 $player 선수가 있습니다. 그가 이 팀을 이끌 수 있습니까?';
  }

  @override
  String pressBeatKeyPlayerNeutral1(String player) {
    return '이번 캠페인은 $player 선수에게 얼마나 달려 있습니까?';
  }

  @override
  String pressBeatKeyPlayerNeutral2(String player) {
    return '$player 선수는 이 팀을 이끌 준비가 됐습니까?';
  }

  @override
  String pressBeatKeyPlayerHostile1(String player) {
    return '$player 선수가 최상의 컨디션이 아니라면, 이 팀에 남는 게 있습니까?';
  }

  @override
  String pressBeatKeyPlayerHostile2(String player) {
    return '$player 선수가 짊어진 짐이 큽니다. 너무 크지 않습니까?';
  }

  @override
  String get pressReplyAimHigher1 => '우리는 누구의 예상보다 더 멀리 갈 겁니다.';

  @override
  String get pressReplyAimHigher2 => '협회가 요구한 것보다 더 원합니다. 공개적으로 말하겠습니다.';

  @override
  String get pressReplyMatchBrief1 => '목표를 알고 있고, 반드시 달성하겠습니다.';

  @override
  String get pressReplyMatchBrief2 => '협회가 목표를 정했습니다. 해내겠습니다.';

  @override
  String get pressReplyPlayDown1 => '한 경기씩 치러 나가겠습니다.';

  @override
  String get pressReplyPlayDown2 => '큰 약속은 하지 않겠습니다. 어디까지 가는지 보겠습니다.';

  @override
  String get pressReplyPromiseQualify1 => '본선에 진출합니다. 적어 두셔도 됩니다.';

  @override
  String get pressReplyPromiseQualify2 => '이 팀은 본선 무대에 설 겁니다.';

  @override
  String get pressReplyFearNobody1 => '우리는 누구도 두렵지 않습니다.';

  @override
  String get pressReplyFearNobody2 => '그들도 우리와 싸워야 합니다.';

  @override
  String get pressReplyRespectRival1 => '그들이 우승 후보이고, 존중합니다.';

  @override
  String get pressReplyRespectRival2 => '아주 좋은 팀입니다. 최선을 다해야 합니다.';

  @override
  String get pressReplyTeamFirst1 => '한 선수가 아니라 팀 전체의 문제입니다.';

  @override
  String get pressReplyTeamFirst2 => '혼자서 이길 수 있는 사람은 없습니다.';

  @override
  String pressOnRecordTarget(String aim) {
    return '공식 발언: $aim.';
  }

  @override
  String get pressOnRecordPlayDown => '공식 발언: 약속 없음.';

  @override
  String get pressThrowbackTargetKeptWarm =>
      '캠페인 전에 목표를 정했고 달성했습니다. 지금까지 가장 자랑스러운 순간입니까?';

  @override
  String get pressThrowbackTargetKeptNeutral =>
      '무엇을 이루겠다고 말했고, 이뤘습니다. 한 번이라도 의심한 적이 있습니까?';

  @override
  String get pressThrowbackTargetKeptHostile =>
      '스스로 정한 목표를 달성했습니다. 운이었습니까, 정말 계획대로였습니까?';

  @override
  String get pressThrowbackTargetBrokenWarm =>
      '목표를 정했지만 미치지 못했습니다. 무엇이 잘못됐습니까?';

  @override
  String get pressThrowbackTargetBrokenNeutral =>
      '이 팀이 해낸 것보다 더 많은 걸 약속하셨습니다. 그 말을 후회하십니까?';

  @override
  String get pressThrowbackTargetBrokenHostile =>
      '캠페인 전에 큰소리를 쳤지만 미치지 못했습니다. 이제 왜 믿어야 합니까?';

  @override
  String hubEventPressPreviewSub(String competition) {
    return '언론이 $competition 목표를 듣고 싶어 합니다';
  }

  @override
  String deptLevelCost(int level, String amount) {
    return '레벨 $level · $amount';
  }

  @override
  String get formOnFire => '절정';

  @override
  String get formGood => '상승세';

  @override
  String get formSteady => '보통';

  @override
  String get formPoor => '하락세';

  @override
  String get formCold => '최악';

  @override
  String get playerFormTitle => '폼과 컨디션';

  @override
  String playerFormAverage(String rating) {
    return '최근 경기 평균 평점 $rating';
  }

  @override
  String get playerFormNoGames => '판단할 최근 경기가 부족합니다';

  @override
  String playerFormNextMatch(String delta) {
    return '다음 경기 평점 $delta';
  }

  @override
  String get playerFormNoEffect => '다음 경기 평점 변화 없음';

  @override
  String get sideGroupHome => '홈';

  @override
  String get sideGroupTeam => '팀';

  @override
  String get sideGroupCompetitions => '대회';

  @override
  String get sideGroupFederation => '협회';

  @override
  String get sideGroupHistory => '역사';

  @override
  String get sideInbox => '받은 메시지';

  @override
  String get sideSquad => '스쿼드';

  @override
  String get sideTactics => '전술';

  @override
  String get sideMainMenu => '메인 메뉴';

  @override
  String get sideCallUps => '소집';

  @override
  String get sideTournaments => '대회';

  @override
  String get sideRanking => '랭킹';

  @override
  String get sideResults => '결과';

  @override
  String get sideFinances => '재정';

  @override
  String get sideBoard => '이사회';

  @override
  String get sideManager => '감독 및 스태프';

  @override
  String get sideRecords => '기록';

  @override
  String get sideLegends => '레전드';

  @override
  String get sideHeadToHead => '상대 전적';

  @override
  String get sideAchievements => '업적';

  @override
  String get sideCareer => '커리어';

  @override
  String get topBarNext => '다음';

  @override
  String get topBarDrawPending => '추첨 예정';

  @override
  String get paneFullProfile => '전체 프로필';

  @override
  String get panePickPlayer => '선수를 고르면 여기에 카드가 표시됩니다';

  @override
  String get inboxPickMessage => '메시지를 고르면 여기에서 읽을 수 있습니다';

  @override
  String get inboxFilterAll => '전체';

  @override
  String get panelViewAll => '모두 보기';

  @override
  String get gridViewOverview => '개요';

  @override
  String get gridColCondition => '컨디션';

  @override
  String get gridColStatus => '상태';

  @override
  String get gridColRank => '순위';

  @override
  String get gridColMove => '변동';

  @override
  String get gridColNation => '국가';

  @override
  String get gridColRegion => '지역';

  @override
  String get gridColPoints => '포인트';

  @override
  String get panePickNation => '국가를 고르면 여기에 기록이 표시됩니다';

  @override
  String get resultsCyclesTitle => '대회 주기';

  @override
  String get tourDrawStart => '추첨 시작';

  @override
  String get tourDrawViewGroups => '조 편성 보기';

  @override
  String get gridColCeiling => '잠재력';

  @override
  String get gridColYearGain => '상승';

  @override
  String get gridColMarkedAt => '등록 시';

  @override
  String get budgetSetupTitle => '예산 설정';

  @override
  String get budgetEffectsTitle => '이 예산의 효과';

  @override
  String get naturalisationTitle => '귀화';

  @override
  String get yTrending => '트렌드';

  @override
  String get yVoices => '주요 계정';

  @override
  String get yConversation => '대화';

  @override
  String get allTimeRecordsTitle => '역대 세계 기록';

  @override
  String get h2hMeetingsTitle => '모든 맞대결';

  @override
  String get h2hPickOpponent => '상대를 고르면 여기에 모든 맞대결이 표시됩니다';

  @override
  String get savesTitle => '저장 파일';

  @override
  String get gridColPlayer => '선수';

  @override
  String get gridColPos => '포지션';

  @override
  String get gridColActive => '현역';

  @override
  String get gridColMotm => 'MOM';

  @override
  String get gridColAvg => '평균';

  @override
  String get gridColOpponent => '상대';

  @override
  String get gridColStarts => '선발';

  @override
  String get gridColTournaments => '대회';

  @override
  String get gridColDate => '날짜';

  @override
  String get gridColLastPlayed => '마지막 플레이';

  @override
  String get gridColManager => '감독';

  @override
  String nationsShownCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count개국',
      one: '1개국',
    );
    return '$_temp0';
  }

  @override
  String get nationsSortedByRank => '세계 랭킹순';

  @override
  String get nationsStrength => '전력';

  @override
  String nationsStrengthOf(int tier) {
    return '5단계 중 $tier';
  }

  @override
  String get nationsSquadOverall => '스쿼드 종합';

  @override
  String get nationsOpeningBudget => '초기 예산';

  @override
  String get nationsStarPlayer => '스타 선수';

  @override
  String nationsStarTile(String position, int rating) {
    return '스타 $position $rating';
  }

  @override
  String nationsStarAge(int age) {
    return '$age세';
  }

  @override
  String get nationsBoardExpects => '이사회의 기대';

  @override
  String nationsManage(String nation) {
    return '$nation 감독 맡기';
  }

  @override
  String get nationsManagerNext => '다음 단계에서 감독 이름을 정합니다';

  @override
  String get playerPageTitle => '선수';

  @override
  String get nationPageTitle => '국가';

  @override
  String get friendliesYourGames => '우리 친선 경기';

  @override
  String hubEventInjuryCover(String player) {
    return '부상당한 $player 선수 대체';
  }

  @override
  String hubEventInjuryCoverSub(int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: '$matches경기 결장',
      one: '다음 경기 결장',
    );
    return '$_temp0. 대체 선수를 소집하거나 그대로 진행하세요.';
  }

  @override
  String get injuryCoverTitle => '대체 선수';

  @override
  String injuryCoverBanner(String player, String position) {
    return '$player($position) 선수가 부상당했습니다. 스쿼드 밖에서 포지션에 관계없이 누구든 소집하거나, 그대로 두고 진행하세요.';
  }

  @override
  String injuryCoverConfirm(String player) {
    return '$player 소집';
  }

  @override
  String injuryCoverKeep(String player) {
    return '$player 유지하고 진행';
  }

  @override
  String get injuryCoverPick => '대체 선수 선택';

  @override
  String get injuryCoverNone => '스쿼드 밖에 합류 가능한 선수가 없습니다.';

  @override
  String get nationNowRanking => '세계 랭킹';

  @override
  String get nationNowForm => '최근 폼';

  @override
  String get nationNowNoForm => '아직 치른 경기 없음';

  @override
  String get nationNowNext => '다음 경기';

  @override
  String get nationNowNoNext => '예정된 경기 없음';

  @override
  String get nationNowSquad => '스쿼드';

  @override
  String get nationNowAgainstYou => '우리와의 전적';

  @override
  String nationNowRecord(int w, int d, int l) {
    return '$w승 $d무 $l패';
  }

  @override
  String get nationNowLastMeeting => '최근 맞대결';

  @override
  String nationNowOverall(int value) {
    return '종합 $value';
  }

  @override
  String get hubUpcoming => '예정 경기';

  @override
  String get hubFullSchedule => '전체 일정';

  @override
  String get scheduleTitle => '일정';

  @override
  String get scheduleToday => '오늘';

  @override
  String get scheduleKnockoutPending => '토너먼트 (진출 시)';

  @override
  String get scheduleNextRoundPending => '다음 라운드';

  @override
  String scheduleFromDate(String date) {
    return '$date부터';
  }

  @override
  String get scheduleHomeShort => 'H';

  @override
  String get scheduleAwayShort => 'A';

  @override
  String get tacticsNoPresetsInMatch => '저장된 전술이 없습니다. 경기 전에 전술 화면에서 저장하세요.';

  @override
  String get homeCampaigns => '캠페인';

  @override
  String get homeContinueCampaign => '캠페인 이어하기';

  @override
  String homeCampaignCycle(String date, int cycle, int total) {
    return '$date · 대회 주기 $cycle/$total';
  }

  @override
  String get campaignsTitle => '캠페인';

  @override
  String get campaignTransplantTitle => '이식';

  @override
  String get campaignTransplantTwist => '이탈리아 최고의 선수 여덟 명이 산마리노로 국적을 바꾼다';

  @override
  String get campaignTransplantGoal => '유럽 선수권 본선 진출';

  @override
  String get campaignGrudgeTitle => '앙숙';

  @override
  String get campaignGrudgeTwist => '조지아와 알바니아, 같은 조에 편성';

  @override
  String get campaignGrudgeGoal => '예선에서 알바니아보다 높은 순위';

  @override
  String get campaignTransplantIntro =>
      '산마리노는 제대로 된 예선을 치러 본 적이 없습니다. 그런데 이탈리아 최고의 선수 여덟 명이 여권을 받아 합류합니다. 대회 주기 한 번 안에 이 진기한 조합을 진짜 팀으로 만드세요.';

  @override
  String get campaignGrudgeIntro =>
      '조지아와 알바니아가 같은 예선 조에 편성됐고, 어느 쪽도 패배를 용서하지 않을 겁니다. 알바니아보다 높은 순위로 마친 뒤 얼마나 더 멀리 갈 수 있는지 확인하세요.';

  @override
  String get campaignStars1Transplant => '본선 진출';

  @override
  String get campaignStars2Transplant => '토너먼트 진출';

  @override
  String get campaignStars3Transplant => '유럽 선수권 우승';

  @override
  String get campaignStars1Grudge => '알바니아보다 위';

  @override
  String get campaignStars2Grudge => '그리고 본선 진출';

  @override
  String get campaignStars3Grudge => '그리고 두 번 모두 승리';

  @override
  String get campaignFree => '무료';

  @override
  String get campaignStart => '시작';

  @override
  String get campaignPartOfUnlimited => '무제한 전용';

  @override
  String get campaignResume => '이어하기';

  @override
  String get campaignAbandon => '포기';

  @override
  String get campaignAbandonConfirm => '이번 도전을 포기할까요? 진행 상황은 사라지지만 스탬프는 남습니다.';

  @override
  String get campaignMoveToSaves => '저장 파일로 옮기기';

  @override
  String get campaignCannotContinue =>
      '이 캠페인의 세계는 실제 세계와 너무 달라 커리어로 이어갈 수 없습니다.';

  @override
  String get campaignMoveSlotsFull => '저장 슬롯이 가득 찼습니다. 먼저 하나를 비우세요.';

  @override
  String get campaignStampConquered => '정복';

  @override
  String get campaignStampFailed => '실패';

  @override
  String get campaignDifficultyHard => '어려움';

  @override
  String get campaignDifficultyMedium => '보통';

  @override
  String get campaignGoalLabel => '목표';

  @override
  String get campaignStarsLabel => '별';

  @override
  String get campaignRunInProgress => '이 캠페인은 이미 진행 중입니다.';

  @override
  String get campaignVerdictWon => '정복';

  @override
  String get campaignVerdictLost => '이번에는 아닙니다';

  @override
  String get campaignVerdictContinue => '계속';

  @override
  String campaignProgressQualifying(String position) {
    return '예선: $position';
  }

  @override
  String campaignProgressRival(String rival, String position) {
    return '$rival: $position';
  }

  @override
  String campaignProgressFinals(String stage) {
    return '본선: $stage';
  }

  @override
  String get campaignRunInNumbers => '숫자로 보는 도전';

  @override
  String campaignRunMeetings(int won, int played) {
    return '맞대결 승리: $played경기 중 $won승';
  }

  @override
  String campaignPlace(String which, int n) {
    String _temp0 = intl.Intl.selectLogic(
      which,
      {
        'first': '1위',
        'second': '2위',
        'third': '3위',
        'other': '$n위',
      },
    );
    return '$_temp0';
  }

  @override
  String get campaignGuineasTitle => '최고의 기니';

  @override
  String get campaignGuineasTwist => '아프리카의 기니 중 가장 작은 나라 적도 기니, 두 번의 대회 주기';

  @override
  String get campaignGuineasGoal => '기니와 기니비사우 격파';

  @override
  String get campaignGuineasIntro =>
      '아프리카에는 기니라는 이름을 가진 나라가 셋 있고, 적도 기니는 그중 가장 작은 나라입니다. 두 번의 대회 주기 동안 기니와 기니비사우를 각각 한 번 이상 꺾은 뒤, 아프리카 선수권에서 얼마나 멀리 갈 수 있는지 확인하세요. 네 번째 기니인 파푸아뉴기니와의 친선 경기도 이미 잡혀 있습니다.';

  @override
  String get campaignStars1Guineas => '기니와 기니비사우 격파';

  @override
  String get campaignStars2Guineas => '그리고 아프리카 선수권 본선 진출';

  @override
  String get campaignStars3Guineas => '그리고 아프리카 선수권 8강 진출';

  @override
  String get campaignYoungFinnsTitle => '젊은 핀란드';

  @override
  String get campaignYoungFinnsTwist => '핀란드의 10대 황금 세대, 세 번의 대회 주기';

  @override
  String get campaignYoungFinnsGoal => '세계 선수권 본선 진출';

  @override
  String get campaignYoungFinnsIntro =>
      '핀란드의 베테랑들이 물러나고 황금 세대가 그 자리를 채웠습니다: 선발할 수 있는 모든 선수가 18세 이하입니다. 지금은 미숙하지만, 노르웨이의 젊은 세대처럼 세계 최고의 팀이 될 재능을 갖췄습니다. 세 번의 대회 주기 안에 세계 선수권 본선에 진출한 뒤, 유럽 선수권과 세계 선수권 우승에 도전하세요.';

  @override
  String get campaignStars1YoungFinns => '세계 선수권 본선 진출';

  @override
  String get campaignStars2YoungFinns => '유럽 선수권 우승';

  @override
  String get campaignStars3YoungFinns => '세계 선수권 우승';

  @override
  String get campaignGreenlandTitle => '그린란드의 한 세기';

  @override
  String get campaignGreenlandTwist => '그린란드가 유럽에서 산마리노의 자리를 대신한다, 100년 동안';

  @override
  String get campaignGreenlandGoal => '유럽 선수권 본선 진출';

  @override
  String get campaignGreenlandIntro =>
      '그린란드는 공식 A매치를 치러 본 적이 없습니다. 이 세계에서 그린란드는 유럽에서 산마리노의 자리를 대신하며, 세계 랭킹 맨 밑바닥에서 시작합니다: 아마추어 선수, 인조 잔디, 눈 사이에 끼인 짧은 시즌. 100년, 25번의 대회 주기 안에 유럽 선수권, 이어서 세계 선수권 본선에 오르고, 감히 꿈꾼다면 그중 하나를 우승하세요.';

  @override
  String get campaignStars1Greenland => '유럽 선수권 본선 진출';

  @override
  String get campaignStars2Greenland => '세계 선수권 본선 진출';

  @override
  String get campaignStars3Greenland => '유럽 선수권 또는 세계 선수권 우승';

  @override
  String get campaignPro => 'Pro';

  @override
  String campaignProgressCup(String cup, String year, String status) {
    return '$year $cup: $status';
  }

  @override
  String get campaignCupNotQualified => '본선 진출 실패';

  @override
  String get campaignCupOpen => '미정';

  @override
  String newsYouthTitle1(String name, String level) {
    return '$level 대표팀에서 빛난 $name';
  }

  @override
  String newsYouthTitle2(String name, String level) {
    return '아카데미 보고서: 눈길을 끈 $name';
  }

  @override
  String newsYouthTitle3(String name, String level) {
    return '$level 최고의 선수: $name';
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
      other: '$count골을',
    );
    return '$name 선수가 최근 A매치 기간 $level 대표팀 소속으로 $opponent전에서 $_temp0 기록했습니다.';
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
      other: '$count골',
    );
    return '이번 기간 $level 대표팀의 $opponent전에서 $name 선수가 $_temp0.';
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
      other: '$count골을',
    );
    return '$level 대표팀이 $opponent전을 치렀고, $name 선수가 $_temp0 기록했습니다.';
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
      other: '$count골을',
    );
    return '$name 선수가 $level 대표팀의 $opponent전에서 $_temp0 도우며 처음부터 끝까지 경기를 지배했습니다.';
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
      other: '도움 $count개',
    );
    return '이번 기간 $level 대표팀의 $opponent전, $name 선수가 경기를 조율했습니다: $_temp0, 그리고 코칭스태프가 아직도 이야기하는 활약.';
  }

  @override
  String newsYouthCleanSheet1(String name, String level, String opponent) {
    return '$level 대표팀이 $opponent전에서 무실점을 기록했고, $name 선수가 빛났습니다.';
  }

  @override
  String newsYouthCleanSheet2(String name, String level, String opponent) {
    return '$level 대표팀의 $opponent전 무실점, 그 공의 대부분은 $name 선수에게 있습니다.';
  }

  @override
  String newsYouthDisplay1(
    String name,
    String level,
    String opponent,
    int mark,
  ) {
    return '$name 선수가 $level 대표팀의 $opponent전에서 인상적인 활약을 펼쳤고, 코칭스태프는 10점 만점에 $mark점을 줬습니다.';
  }

  @override
  String newsYouthDisplay2(
    String name,
    String level,
    String opponent,
    int mark,
  ) {
    return '이번 기간 $level 대표팀의 $opponent전, 코치진이 꼽은 선수는 $name: 10점 만점에 $mark점, 팀 내 최고 점수.';
  }

  @override
  String get newsYouthDevReady1 => '지금의 폼이라면 이미 성인 대표팀에 고려될 만합니다.';

  @override
  String get newsYouthDevReady2 =>
      '코칭스태프는 그가 지금 성인 무대에 설 준비가 됐다고 봅니다. 결정은 감독님 몫입니다.';

  @override
  String get newsYouthDevClose1 => '순조롭게 성장하고 있으며 성인 대표팀 진입이 가까워졌습니다.';

  @override
  String get newsYouthDevClose2 => '성인 대표팀까지 멀지 않았고, 한 시즌만 더 잘하면 될 수 있습니다.';

  @override
  String get newsYouthDevGrowing1 => '잘 성장하고 있지만 성인 대표팀까지는 아직 한두 걸음 남았습니다.';

  @override
  String get newsYouthDevGrowing2 =>
      '성인 국가대표가 되려면 할 일이 남았지만, 모든 것이 올바른 방향을 가리키고 있습니다.';

  @override
  String get newsYouthDevRaw1 => '아직 미숙하고 성인 대표팀 경쟁까지는 몇 년이 남았지만, 재능은 분명합니다.';

  @override
  String get newsYouthDevRaw2 => '아직 초기 단계이며, 아카데미 스태프는 헤드라인보다 인내를 당부합니다.';

  @override
  String get newsYouthStrengthGkPhysical => '긴 리치와 박스 장악력이 그를 돋보이게 합니다.';

  @override
  String get newsYouthStrengthGkTechnical =>
      '캐칭과 배급 능력은 아카데미가 수년 만에 본 최고 수준입니다.';

  @override
  String get newsYouthStrengthGkStamina => '집중력이 떨어지지 않아 90분에도 1분처럼 날카롭습니다.';

  @override
  String get newsYouthStrengthDefPhysical => '스피드와 공중볼 능력이 그의 핵심입니다.';

  @override
  String get newsYouthStrengthDefTechnical =>
      '나이에 비해 경기를 읽는 눈이 뛰어나고 공을 다룰 때 침착합니다.';

  @override
  String get newsYouthStrengthDefStamina =>
      '한순간도 집중을 놓지 않고, 마지막 순간까지 전력으로 복귀합니다.';

  @override
  String get newsYouthStrengthMidPhysical => '강한 힘으로 공을 되찾고 그대로 전진합니다.';

  @override
  String get newsYouthStrengthMidTechnical => '시야와 다양한 패스가 그의 핵심입니다.';

  @override
  String get newsYouthStrengthMidStamina => '활동량이 놀랍습니다: 경기장 구석구석을 누빕니다.';

  @override
  String get newsYouthStrengthFwdPhysical =>
      '뒷공간 침투 속도와 공중볼 경합 능력으로 어떤 수비도 괴롭힙니다.';

  @override
  String get newsYouthStrengthFwdTechnical => '결정력과 박스 안 움직임이 그의 핵심입니다.';

  @override
  String get newsYouthStrengthFwdStamina =>
      '경기 내내 전방에서 압박하며 수비수에게 한순간도 여유를 주지 않습니다.';

  @override
  String pressMomentBigWinWarm3(String opponent) {
    return '$opponent전 승리는 팬들이 한동안 노래할 겁니다. 경기 종료 휘슬 때 선수들에게 무슨 말을 하셨습니까?';
  }

  @override
  String pressMomentBigWinNeutral3(String opponent) {
    return '$opponent 상대로 존재감을 보여 준 경기였습니다. 그중 얼마나 훈련장에서 나온 겁니까?';
  }

  @override
  String pressMomentBigWinHostile3(String opponent) {
    return '$opponent전 결과는 인정합니다. 하지만 이런 밤은 전에도 있었습니다. 이번엔 뭐가 다릅니까?';
  }

  @override
  String pressMomentBigLossWarm3(String opponent) {
    return '누구에게나 나쁜 밤은 있고, $opponent전이 그랬습니다. 얼마나 빨리 털어 낼 수 있습니까?';
  }

  @override
  String pressMomentBigLossNeutral3(String opponent) {
    return '$opponent에 모든 면에서 밀렸습니다. 어디서부터 고치시겠습니까?';
  }

  @override
  String pressMomentBigLossHostile3(String opponent) {
    return '$opponent전 종료 전에 팬들이 자리를 떴습니다. 그들을 탓할 수 있습니까?';
  }

  @override
  String pressMomentCrisisWarm3(String opponent) {
    return '힘든 시기였고, $opponent전도 나아지게 하지 못했습니다. 무엇이 감독님을 버티게 합니까?';
  }

  @override
  String pressMomentCrisisNeutral3(String opponent) {
    return '이번엔 $opponent전에서도 승리가 없었습니다. 이사회가 움직이기 전까지 얼마나 더 이어질 수 있습니까?';
  }

  @override
  String pressMomentCrisisHostile3(String opponent) {
    return '$opponent에게까지. 계획에 남은 게 있습니까, 아니면 다른 사람에게 자리를 내줄 때입니까?';
  }

  @override
  String get pressReplyCreditPlayers5 => '무엇을 쓰시든 선수들에 대해 써 주십시오. 그럴 자격이 있습니다.';

  @override
  String get pressReplyCreditPlayers6 =>
      '서로를 위해 벽이라도 뚫고 달릴 선수들입니다. 그건 결코 작은 게 아닙니다.';

  @override
  String get pressReplyTakeResponsibility5 =>
      '결정은 제가 하니 비판도 제가 받습니다. 그게 이 일입니다.';

  @override
  String get pressReplyTakeResponsibility6 =>
      '감독부터 보십시오. 제가 잘못한 부분이 있고, 바로잡겠습니다.';

  @override
  String get pressReplyDemandMore5 =>
      '여기서는 좋은 것만으로 부족합니다. 선수들에게 면전에서 그렇게 말했습니다.';

  @override
  String get pressReplyDemandMore6 => '그 라커룸의 누구도 자리를 보장받지 못합니다. 이제 다들 압니다.';

  @override
  String get pressReplyDeflect5 => '세 가지 방식으로 물으셔도 대답은 같습니다.';

  @override
  String get pressReplyDeflect6 => '제 생각은 선수들에게만 전하겠습니다. 이해해 주십시오.';

  @override
  String yWinRoutine12(String opponent, String score) {
    return '$opponent 상대 $score. 차분하고, 통제된, 성숙한 축구. 보기 좋다.';
  }

  @override
  String yWinRoutine13(String opponent, String score) {
    return '$opponent에 $score, 땀 한 방울 안 흘리고 이겼다. 이 팀 지루하게 이기는 법을 배우고 있고, 지루함이 트로피를 딴다.';
  }

  @override
  String yWinRoutine14(String opponent, String score) {
    return '$opponent전 $score. 승점 3, 드라마 없음, 다시 일하러.';
  }

  @override
  String yWinRoutine15(String opponent, String score) {
    return '$opponent 상대 평범한 $score. 아무도 기억 못 하겠지만 그럴 필요도 없다.';
  }

  @override
  String yWinRoutine16(String opponent, String score) {
    return '$opponent 상대 $score인데 왜인지 걱정만 남는다.';
  }

  @override
  String yWinRoutine17(String opponent, String score) {
    return '$opponent에 $score 승리. 제대로 된 팀 상대였으면 저 경기력은 벌받았다.';
  }

  @override
  String yWinTight12(String opponent, String score) {
    return '$opponent 상대 $score. 버티고, 견디고, 이겼다. 이게 팀이다.';
  }

  @override
  String yWinTight13(String opponent, String score) {
    return '$opponent에 $score, 오직 근성으로 이겼다. 지기를 거부하는 팀이라면 환영이다.';
  }

  @override
  String yWinTight14(String opponent, String score) {
    return '$opponent전 $score. 끝까지 갔지만 승점은 우리 거다.';
  }

  @override
  String yWinTight15(String opponent, String score) {
    return '$opponent 상대 아슬아슬한 $score. 큰 차이는 없었다, 그게 축구다.';
  }

  @override
  String yWinTight16(String opponent, String score) {
    return '$opponent 상대 $score. 공 한 번만 반대로 튀었어도 완전히 다른 얘기를 하고 있을 거다.';
  }

  @override
  String yWinTight17(String opponent, String score) {
    return '$opponent 상대 $score, 간신히 버텼다. 저걸 경기력이라고 부르면 안 된다.';
  }

  @override
  String yDrew12(String opponent, String score) {
    return '$opponent전 $score. 패배는 아니고, 그것만으로 충분한 날도 있다.';
  }

  @override
  String yDrew13(String opponent, String score) {
    return '$opponent 상대로 어렵게 얻은 승점 1점, $score. 투지는 마음에 들었다.';
  }

  @override
  String yDrew14(String opponent, String score) {
    return '$opponent전 $score. 옛 해설자들 말처럼, 사이좋게 나눴다.';
  }

  @override
  String yDrew15(String opponent, String score) {
    return '$opponent전 $score. 어느 쪽도 그 이상을 받을 만큼 하지 못했다.';
  }

  @override
  String yDrew16(String opponent, String score) {
    return '$opponent전 $score. 집에 오는 버스에선 패배처럼 느껴지는 무승부.';
  }

  @override
  String yDrew17(String opponent, String score) {
    return '$opponent전 $score 무승부. 발전을 말하면서 계속 이런다.';
  }

  @override
  String yLost12(String opponent, String score) {
    return '$opponent에게 $score. 아프지만, 이 팀을 믿을 만한 모습은 충분히 봤다.';
  }

  @override
  String yLost13(String opponent, String score) {
    return '$opponent에게 $score 패배, 상대가 잘했다. 인정하고 다시 가자.';
  }

  @override
  String yLost14(String opponent, String score) {
    return '$opponent전 $score. 패배 하나, 교훈 몇 개, 다음 경기는 곧.';
  }

  @override
  String yLost15(String opponent, String score) {
    return '$opponent에게 $score 패배. 반박하기 어렵다.';
  }

  @override
  String yLost16(String opponent, String score) {
    return '$opponent에게 $score. 지난번과 같은 실수를, 같은 자신감으로.';
  }

  @override
  String yLost17(String opponent, String score) {
    return '$opponent에게 $score 패배. 이걸 책임지는 사람이 없다면, 우린 뭘 하고 있는 건가?';
  }

  @override
  String get yReactionShrug12 => '난 괜찮다. 매일 밤 불꽃놀이일 필요는 없다.';

  @override
  String get yReactionShrug13 => '승점은 승점이다. 오늘 밤은 푹 잔다.';

  @override
  String get yReactionShrug14 => '봤다. 할 말 없다.';

  @override
  String get yReactionShrug15 => '괜찮음과 괜찮음 사이 어딘가.';

  @override
  String get yReactionShrug16 => '저거 보려고 중계 결제했다. 다신 안 한다 (또 할 거다).';

  @override
  String get yReactionShrug17 => '축구 모양을 한 90분짜리 공허.';

  @override
  String get yReactionRelief12 => '이제 숨 쉰다. 끝까지 버텨 준 선수들이 자랑스럽다.';

  @override
  String get yReactionRelief13 => '이런 승리가 팀을 만든다. 못생긴 게 아름답다.';

  @override
  String get yReactionRelief14 => '손톱은 다 사라졌지만 승점은 남았다.';

  @override
  String get yReactionRelief15 => '종료 휘슬이 이렇게 반가웠던 적이 없다.';

  @override
  String get yReactionRelief16 => '이겨서 기쁜데, 이긴 방식이 걱정된다.';

  @override
  String get yReactionRelief17 => '계속 운 좋게 넘어간다. 언젠가는 안 통한다.';

  @override
  String get yReactionFury12 => '이 팀을 사랑한다. 그래서 더 아프다.';

  @override
  String get yReactionFury13 => '나쁜 밤. 다음엔 갚아야 한다, 본인들도 안다.';

  @override
  String get yReactionFury14 => '70분에 껐다. 60분에 껐어야 했다.';

  @override
  String get yReactionFury15 => '투지도, 아이디어도, 변명의 여지도 없다.';

  @override
  String get yReactionFury16 => '매번 같은 문제, 아무도 아무것도 안 고친다.';

  @override
  String get yReactionFury17 => '협회 누군가 저걸 다시 보고 설명해야 한다.';

  @override
  String get backupShareHint =>
      '모든 저장 파일을 하나의 백업 파일로 만듭니다. Google Drive, iCloud Drive 또는 파일 앱을 선택해 보관하세요.';

  @override
  String backupLastAt(String date) {
    return '마지막 백업: $date';
  }

  @override
  String get backupNever => '아직 백업 없음';

  @override
  String get backupRemindersTitle => '백업 알림';

  @override
  String get backupRemindersBlurb => '마지막 백업이 오래되면 받은 메시지로 알려 드립니다.';

  @override
  String get backupAutoICloudTitle => 'iCloud 자동 백업';

  @override
  String get backupAutoDriveTitle => 'Google Drive 자동 백업';

  @override
  String get backupAutoBlurb =>
      '경기 후, 대회 주기 종료 시, 앱을 나갈 때 백업합니다. 최근 두 개를 보관합니다.';

  @override
  String get backupStatusUploading => '백업하는 중.';

  @override
  String get backupStatusUploaded => '백업 완료.';

  @override
  String get backupStatusICloudSignedOut =>
      'iCloud가 꺼져 있습니다. 설정 앱에서 iCloud에 로그인하고 iCloud Drive를 켜세요.';

  @override
  String get backupStatusDriveSignedOut =>
      '로그인되지 않았습니다. 스위치를 켜서 Google로 로그인하세요.';

  @override
  String get backupStatusNotConfigured => '이 버전의 앱에서는 아직 사용할 수 없습니다.';

  @override
  String get backupStatusUnavailable => '지금은 클라우드에 연결할 수 없습니다. 나중에 다시 시도합니다.';

  @override
  String get backupStatusFailed => '마지막 자동 백업이 완료되지 않았습니다. 나중에 다시 시도합니다.';

  @override
  String backupDriveSignedInAs(String email) {
    return '로그인 계정: $email';
  }

  @override
  String get backupDriveSignOut => '로그아웃';

  @override
  String get backupDriveSignInFailed => 'Google 로그인에 실패했습니다. 나중에 다시 시도하세요.';

  @override
  String get backupRestoreICloud => 'iCloud에서 복원';

  @override
  String get backupRestoreDrive => 'Google Drive에서 복원';

  @override
  String get backupCrossPlatformHelp =>
      'iPhone과 Android 사이를 옮기시나요? 한 휴대폰에서 파일로 백업한 뒤, 다른 휴대폰에서 그 파일로 복원하세요.';

  @override
  String get backupCloudListBlurb => '이 계정에 있는 기기별 백업입니다. 눌러서 복원하세요.';

  @override
  String get backupCloudListEmpty =>
      '아직 백업이 없습니다. 새 백업이 다른 기기에 나타나기까지 몇 분 걸릴 수 있습니다.';

  @override
  String get backupCloudListFailed => '백업을 읽을 수 없습니다. 연결 상태를 확인하고 다시 시도하세요.';

  @override
  String get backupCloudThisDevice => '이 기기';

  @override
  String backupCloudMore(int count) {
    return '추가 저장 파일: $count';
  }

  @override
  String get backupCloudNewer => '더 새로운 버전의 앱에서 만들었습니다. 먼저 업데이트하세요.';

  @override
  String get backupCloudDownloading => '백업을 가져오는 중.';

  @override
  String get backupRestoreSafetyNote => '먼저 이 휴대폰의 저장 파일 사본을 이 휴대폰에 보관합니다.';

  @override
  String get backupRejectedSafety => '현재 저장 파일의 사본을 만들 수 없어 아무것도 바꾸지 않았습니다.';

  @override
  String get newsBackupReminderTitle => '백업할 시간입니다';

  @override
  String get newsBackupReminderBody =>
      '저장 파일은 이 휴대폰에만 있습니다. 설정에서 \'클라우드에 백업\'을 누르거나 자동 백업을 켜세요. 이 알림은 설정에서 끌 수도 있습니다.';

  @override
  String get backupSafetyTitle => '복원 전 사본';

  @override
  String get backupSafetyBlurb => '잘못 복원한 경우를 대비해 이 휴대폰에 보관합니다. 최근 세 개를 보관합니다.';

  @override
  String get backupSafetyRestore => '복원';

  @override
  String get backupSafetyShare => '공유';

  @override
  String get backupCloudNoDetails => '세부 정보를 아직 불러오는 중입니다.';

  @override
  String get tacticsLibraryTitle => '전술 라이브러리';

  @override
  String get tacticsLibraryBlurb =>
      '라이브러리의 전술은 새 저장 파일을 포함해 어느 저장 파일에서든 불러올 수 있습니다. 역할과 세트피스 키커는 선수가 아니라 포지션 기준으로 저장됩니다.';

  @override
  String get tacticsSaveToLibrary => '라이브러리에 저장';

  @override
  String get tacticsLoadFromLibrary => '라이브러리에서 불러오기';

  @override
  String get tacticsLibraryEmpty =>
      '라이브러리가 비어 있습니다. 여기에 전술을 저장하면 어느 저장 파일에서든 불러올 수 있습니다.';

  @override
  String tacticsLibrarySaved(String name) {
    return '“$name” 라이브러리에 저장됨';
  }

  @override
  String tacticsLibraryLoaded(String name) {
    return '“$name” 불러옴';
  }

  @override
  String tacticsLibraryNotFitted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '역할 또는 세트피스 키커 $count개가 이 스쿼드에 맞지 않았습니다.',
      one: '역할 또는 세트피스 키커 1개가 이 스쿼드에 맞지 않았습니다.',
    );
    return '$_temp0';
  }

  @override
  String get tacticsLibraryRename => '이름 변경';

  @override
  String get tacticsLibraryRenameTitle => '전술 이름 변경';

  @override
  String get tacticsLibraryDelete => '삭제';

  @override
  String tacticsLibraryDeleteTitle(String name) {
    return '“$name” 전술을 삭제할까요?';
  }

  @override
  String get tacticsLibraryDeleteBody => '모든 저장 파일의 라이브러리에서 사라집니다.';

  @override
  String get tacticsLibraryNameTaken => '라이브러리에 같은 이름의 전술이 이미 있습니다.';

  @override
  String tacticsLibraryCouldNotLoad(String error) {
    return '라이브러리를 불러올 수 없습니다.\n$error';
  }

  @override
  String hostBidHeading(String competition, int year) {
    return '대회 유치 신청: $competition $year';
  }

  @override
  String get hostBidScreenTitle => '대회 유치';

  @override
  String get hostBidBlurb =>
      '개최국은 후보국 가운데 추첨으로 정해집니다. 유치 신청을 하면 당첨 가능성이 높아집니다. 경기장이 기본 확률을 주고 자금이 여기에 더해지며, 100만이 늘 때마다 효과는 조금씩 줄어듭니다. 자금은 유치 성공 여부와 관계없이 사용됩니다.';

  @override
  String hostBidPrize(String amount) {
    return '유치에 성공하면 개최국으로 자동 출전하고, 다음 예산에 쓸 $amount의 일회성 지원금을 받습니다.';
  }

  @override
  String get hostBidChance => '개최 확률';

  @override
  String get hostBidBaseLabel => '경기장과 위상';

  @override
  String get hostBidInvestLabel => '투자';

  @override
  String hostBidCeiling(String nation, String percent) {
    return '$nation의 최대 확률: $percent';
  }

  @override
  String get hostBidInvestment => '투자 금액';

  @override
  String hostBidFreeFunds(String amount) {
    return '가용 자금: $amount';
  }

  @override
  String get hostBidSubmit => '유치 신청';

  @override
  String get hostBidDecline => '이번에는 보류';

  @override
  String get hostBidUnavailable => '이 유치 신청은 이미 마감되었습니다.';

  @override
  String hostBidWonTitle(String competition, int year) {
    return '유치 성공: $competition $year';
  }

  @override
  String hostBidWonBody(String amount) {
    return '우리가 대회를 개최하며 개최국으로 자동 출전합니다. $amount의 일회성 지원금이 협회 자금에 들어왔고, 허브에서 바로 이번 주기 부서에 배분할 수 있습니다.';
  }

  @override
  String hostBidLostTitle(String competition, int year) {
    return '유치 실패: $competition $year';
  }

  @override
  String hostBidLostBody(String hosts) {
    return '개최권은 $hosts에 돌아갔습니다. 이번에는 아쉽게 실패했고 투입한 자금도 돌려받을 수 없지만, 협회는 존재감을 보여 주었습니다.';
  }

  @override
  String get hostBidGrantEvent => '개최 지원금 배분';

  @override
  String hostBidGrantBanner(String amount) {
    return '개최 지원금 $amount: 지금 이번 주기 부서에 추가하세요. 이미 정한 배분은 그대로 유지되고, 남는 금액은 은행에 보관됩니다.';
  }

  @override
  String get stadiumsTitle => '국가 경기장';

  @override
  String get stadiumsEntrySub => '경기장 개보수 또는 신축';

  @override
  String get stadiumsBlurb =>
      '경기장 레벨은 규모입니다: 레벨 1은 15,000석 미만, 레벨 2는 15,000석부터, 레벨 3은 25,000석부터, 레벨 4는 40,000석부터, 레벨 5는 60,000석부터입니다. 모든 경기장은 주기가 시작될 때마다 작은 수입을 내며, 관중이 채울 수 있는 한 좌석이 많을수록 더 많이 냅니다. 확장은 즉시 좌석을 늘리고 다음 주기부터 평판도 조금 올려 줍니다. 축소는 유지비를 줄이지만 환급은 없습니다. 어떤 대회의 유치를 신청할 수 있는지는 경기장에 달려 있습니다.';

  @override
  String stadiumsIncome(String amount) {
    return '경기장 수입: 주기당 $amount';
  }

  @override
  String stadiumsReputation(int points) {
    return '경기장 명성 효과: +$points';
  }

  @override
  String get stadiumsClosed => '공사는 주기 시작 시, 예산을 정하기 전에 발주합니다.';

  @override
  String stadiumsCapacity(String seats) {
    return '수용 인원: $seats';
  }

  @override
  String stadiumsLevel(int level, int max) {
    return '레벨 $level/$max';
  }

  @override
  String stadiumsUpgrade(String cost) {
    return '개보수: $cost';
  }

  @override
  String get stadiumsTopLevel => '최고 레벨';

  @override
  String stadiumsOpens(int year) {
    return '건설 중, $year년 개장';
  }

  @override
  String get stadiumsBuildTitle => '새 경기장 건설';

  @override
  String get stadiumsBuildBody =>
      '비용이 꽤 큽니다. 선택한 도시에 새 경기장을 지으며, 다음 주기 시작부터 사용할 수 있습니다.';

  @override
  String get stadiumsBuildCity => '도시';

  @override
  String stadiumsBuildButton(String cost) {
    return '건설: $cost';
  }

  @override
  String get stadiumsBuilding => '이미 경기장 하나를 건설 중입니다.';

  @override
  String get stadiumsNoCity => '모든 도시에 이미 새 경기장이 있습니다.';

  @override
  String stadiumsConfirmUpgrade(String stadium, int level, String cost) {
    return '$stadium의 레벨을 $level까지 올릴까요? 비용: $cost';
  }

  @override
  String stadiumsConfirmBuild(String city, String cost) {
    return '$city에 새 경기장을 지을까요? 비용: $cost';
  }

  @override
  String get stadiumsConfirm => '확인';

  @override
  String get stadiumsCancel => '취소';

  @override
  String get stadiumsRefused => '발주가 처리되지 않았습니다. 비용은 청구되지 않았습니다.';

  @override
  String get stadiumsNameLabel => '경기장 이름';

  @override
  String get stadiumsNameHint => '비워 두면 제안된 이름이 그대로 쓰입니다.';

  @override
  String get stadiumsRename => '경기장 이름 변경';

  @override
  String get hostBidSectionTitle => '대회 유치 신청';

  @override
  String get hostBidOpenSub => '선택 사항. 새 주기가 시작되기 전에 결정하세요.';

  @override
  String get hostBidDecidedAtRollover => '개최국은 새 주기가 시작될 때 발표됩니다.';

  @override
  String get hostBidLodged => '유치 신청 완료. 개최국은 새 주기가 시작될 때 발표됩니다.';

  @override
  String get hostBidDeclinedNote => '이번에는 유치를 신청하지 않기로 했습니다.';

  @override
  String get hostBidOpensLater => '자격 충족. 이번 주기가 끝날 때 유치를 신청할 수 있습니다.';

  @override
  String get hostBidNoFunds => '유치 신청에 쓸 가용 자금이 부족합니다.';

  @override
  String hostBidNeedStadiums(int count, String seats) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$seats석 이상 경기장이 $count곳 더 필요합니다.',
      one: '$seats석 이상 경기장이 1곳 더 필요합니다.',
    );
    return '$_temp0';
  }

  @override
  String hostBidBarredConf(String confederation) {
    return '지난 세계 선수권 개최 대륙: $confederation';
  }

  @override
  String get hostBidRecentHost => '최근 3개 대회 중 하나를 개최했습니다.';

  @override
  String hostBidRequirement(
    int grounds,
    String minSeats,
    int bigGrounds,
    String bigSeats,
  ) {
    return '조건: $minSeats석 이상 경기장 $grounds곳, 그중 $bigGrounds곳은 $bigSeats석 이상.';
  }

  @override
  String hostBidWonBodyBudget(String amount) {
    return '우리가 대회를 개최하며 개최국으로서 자동 출전합니다. 일회성 지원금 $amount 전액이 이미 협회 자금에 들어와 이번 주기 예산에 쓸 수 있습니다.';
  }

  @override
  String get hubStadiumIncome => '경기장 수입';

  @override
  String get stadiumsDownsize => '축소';

  @override
  String stadiumsConfirmDownsize(String stadium, String seats, int level) {
    return '$stadium 경기장을 $seats석(레벨 $level)으로 축소할까요? 환급은 없지만 유지비가 줄어듭니다.';
  }

  @override
  String get stadiumsResizedThisCycle => '이번 주기 개보수 완료';

  @override
  String stadiumsGroundIncome(String amount) {
    return '주기당 $amount 수입';
  }

  @override
  String hostBidLapsedTitle(String competition, int year) {
    return '유치 신청 철회: $competition $year';
  }

  @override
  String hostBidLapsedBodyNation(String nation) {
    return '유치 신청 국가: $nation. 새 주기는 다른 곳에서 시작하므로 신청이 철회되었고 비용은 청구되지 않았습니다.';
  }

  @override
  String get hostBidLapsedBodyFunds =>
      '주기가 끝날 때 협회 자금이 신청 금액에 미치지 못했습니다. 신청이 철회되었고 비용은 청구되지 않았습니다.';

  @override
  String get stadiumsViewMap => '지도';

  @override
  String get stadiumsViewList => '목록';

  @override
  String get stadiumsMapPickCity => '새 경기장을 지을 도시를 탭하세요.';

  @override
  String get stadiumsMapFit => '전체 국가 보기';

  @override
  String get campaignLegacyTitle => '유산의 완성';

  @override
  String get campaignLegacyTwist => '현 유럽 챔피언 스페인, 한 주기 동안';

  @override
  String get campaignLegacyGoal => '유럽 타이틀 방어';

  @override
  String get campaignLegacyIntro =>
      '스페인은 현 유럽 챔피언이지만, 의심하는 이들은 황금기가 한때의 운이었다고 말합니다. 한 주기 안에 그렇지 않음을 증명하세요. 대륙의 왕관을 지킨 뒤 세계 정상에 도전하세요. 네이션스컵까지 더하면 유산이 완성됩니다.';

  @override
  String get campaignStars1Legacy => '유럽 선수권 우승';

  @override
  String get campaignStars2Legacy => '그리고 세계 선수권';

  @override
  String get campaignStars3Legacy => '그리고 네이션스컵';

  @override
  String get campaignSectionOneCycle => '한 주기';

  @override
  String get campaignSectionShort => '몇 주기';

  @override
  String get campaignSectionLong => '장기전';

  @override
  String get campaignFilterAll => '전체';

  @override
  String get campaignFilterNew => '미플레이';

  @override
  String get campaignFilterInProgress => '진행 중';

  @override
  String get campaignFilterDone => '완료';

  @override
  String get campaignFilterEmpty => '아직 캠페인이 없습니다.';

  @override
  String campaignStarsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '별 $count개',
      zero: '별 없음',
    );
    return '$_temp0';
  }

  @override
  String campaignCycles(int cycles) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles개 대회 주기',
    );
    return '$_temp0';
  }

  @override
  String get msgIntlRetireNoteHigh => ' 우승컵과 함께 정상에서 떠납니다.';

  @override
  String get msgIntlRetireNoteMissed => ' 본선 진출 실패가 결정타였습니다.';

  @override
  String get msgIntlRetireNoteSurprise => ' 아무도 예상하지 못했습니다.';

  @override
  String get msgIntlRetireNoteRecord => ' 대표팀 최다 기록 보유자로 떠납니다.';

  @override
  String msgIntlRetireNewsTitle(String nation, String name) {
    return '$nation: $name 선수, 국가대표 은퇴';
  }

  @override
  String msgIntlRetireNewsBody(String name, String nation, int age) {
    return '$name 선수($nation)가 $age세에 국가대표 은퇴를 발표했습니다.';
  }

  @override
  String msgIntlComebackTitle(String name) {
    return '$name 선수, 국가대표 복귀';
  }

  @override
  String msgIntlComebackBody(String name, int age) {
    return '$name 선수가 $age세에 다시 소집 가능한 상태가 되었습니다.';
  }

  @override
  String get msgIntlComebackNoteCrisis => ' 부상자가 속출하는 대표팀의 부름에 응했습니다.';

  @override
  String get msgIntlComebackNoteManager => ' 새 감독의 설득에 마음을 바꿨습니다.';

  @override
  String msgIntlComebackNewsTitle(String nation, String name) {
    return '$nation: $name 선수, 국가대표 복귀';
  }

  @override
  String msgIntlComebackNewsBody(String name, String nation, int age) {
    return '$name 선수($nation)가 $age세에 다시 소집 가능한 상태가 되었습니다.';
  }

  @override
  String playerIntlRetired(int year) {
    return '국가대표 은퇴, $year년';
  }

  @override
  String playerIntlComeback(int year) {
    return '국가대표 복귀, $year년';
  }

  @override
  String yLegendRetires0(String name) {
    return '고마워요, $name 선수. 유니폼을 입는 선수는 많아도 팀을 짊어진 선수는 드물죠.';
  }

  @override
  String yLegendRetires1(String name) {
    return '$name 선수, 국가대표 경력 마감. 한 시대의 끝.';
  }

  @override
  String yLegendRetires2(String name) {
    return '$name 선수 은퇴. 솔직히 한 대회 늦었다.';
  }

  @override
  String yLegendRetires3(String name) {
    return '$name 선수도 끝이네. 이제 젊은 선수들에게 기회를.';
  }

  @override
  String matchAltitudeOpponentsTire(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return '고도 ${altitudeString}m: 상대가 더 빨리 지칩니다';
  }

  @override
  String matchAltitudeYouTire(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return '고도 ${altitudeString}m: 우리 선수들이 더 빨리 지칩니다';
  }

  @override
  String matchAltitudeBothTire(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return '고도 ${altitudeString}m: 두 팀 모두 더 빨리 지칩니다';
  }

  @override
  String matchAltitudeUsedTo(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return '고도 ${altitudeString}m: 두 팀 모두 익숙합니다';
  }

  @override
  String matchHeatExpected(int temp) {
    final intl.NumberFormat tempNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String tempString = tempNumberFormat.format(temp);

    return '더위: $tempString°C 예상, 체력이 더 일찍 떨어집니다';
  }

  @override
  String get matchConditionsAdvice => '교체를 일찍 계획하세요: 이곳에선 지치지 않은 다리가 더 중요합니다';

  @override
  String get fanMoodFurious => '격분';

  @override
  String get fanMoodRestless => '불만';

  @override
  String get fanMoodCalm => '차분';

  @override
  String get fanMoodUpbeat => '기대감';

  @override
  String get fanMoodEuphoric => '열광';

  @override
  String matchHomeFans(String mood) {
    return '홈 팬: $mood';
  }

  @override
  String federationFans(String mood) {
    return '팬 분위기: $mood';
  }

  @override
  String federationFansIncome(String change) {
    return '다음 사이클 경기장 수입: $change';
  }

  @override
  String yFansProtest0(String nation, String manager) {
    return '홈이든 원정이든 대표팀을 따라다닌 지 20년. 뭔가 바뀌기 전까지 시즌권은 갱신 안 한다.';
  }

  @override
  String yFansProtest1(String nation, String manager) {
    return '유니폼을 위해 계속 노래할 거다. 하지만 오늘 밤 북쪽 스탠드의 걸개는 우리 모두의 생각을 그대로 적었다.';
  }

  @override
  String yFansProtest2(String nation, String manager) {
    return '경기장 절반이 비었고, 온 절반은 후반 내내 #${manager}Out 구호를 외쳤다.';
  }

  @override
  String yFansProtest3(String nation, String manager) {
    return '서포터 단체들이 다음 홈 경기 보이콧을 이야기하고 있다. 탓하기 어렵다.';
  }

  @override
  String yFansProtest4(String nation, String manager) {
    return '#${manager}Out. 이제 화도 안 난다. 그냥 끝이다.';
  }

  @override
  String yFansProtest5(String nation, String manager) {
    return '오늘 밤 사진: 줄지어 빈 좌석, 그리고 #${manager}Out 문구가 적힌 침대 시트 한 장. 이게 경기 리포트다.';
  }

  @override
  String yFansSellOut0(String nation) {
    return '또 매진. 몇 년 만에 최고의 대표팀이고, 온 나라가 안다.';
  }

  @override
  String yFansSellOut1(String nation) {
    return '다음 홈 경기 표가 11분 만에 매진됐다. 이 팀이 우리 주말을 돌려줬다.';
  }

  @override
  String yFansSellOut2(String nation) {
    return '다음 홈 경기는 빈자리가 하나도 없다. 협회는 웃으며 입장 수입을 세겠지.';
  }

  @override
  String yFansSellOut3(String nation) {
    return '또 매진. 전술에 대해 뭐라 하든, 사람들은 그 경기장에 있고 싶어 한다.';
  }

  @override
  String yFansSellOut4(String nation) {
    return '매진, 그래. 1년 반 전에 이 팀에 야유하던 바로 그 사람들이다.';
  }

  @override
  String yFansSellOut5(String nation) {
    return '갑자기 매진, 갑자기 다들 전문가. 아무도 못 이기던 시절엔 다들 어디 있었나?';
  }

  @override
  String get campaignsIntro =>
      '캠페인은 특별히 설계된 도전입니다. 정해진 대표팀, 고유한 반전이 있는 세계, 그리고 정해진 주기 안에 이뤄야 할 목표가 있습니다. 각 도전은 저장된 커리어와 별도로 진행되며, 멀리 갈수록 더 많은 별을 얻고 최대 세 개까지 받을 수 있습니다.';

  @override
  String hubEventScandal(String player) {
    return '소집 중 스캔들: $player';
  }

  @override
  String get hubEventScandalSub => '귀국시킬까요, 남길까요?';

  @override
  String get scandalTitle => '스캔들';

  @override
  String scandalStoryParty(String player) {
    return '$player 선수가 새벽까지 이어진 파티에 있었고, 대표팀이 소집된 날 아침 모든 신문에 사진이 실렸습니다.';
  }

  @override
  String scandalStoryCurfew(String player) {
    return '$player 선수가 팀 통금을 어기고 새벽에 호텔로 돌아오다 적발됐습니다.';
  }

  @override
  String scandalStoryNightclub(String player) {
    return '소집 전날 밤 나이트클럽에 있는 $player 선수의 사진이 찍혔고, 사진이 곳곳에 퍼졌습니다.';
  }

  @override
  String scandalStoryCasino(String player) {
    return '$player 선수가 소집 전날 밤을 카지노 테이블에서 보냈고, 한 타블로이드가 사진을 확보했습니다.';
  }

  @override
  String get scandalSendHome => '귀국시키기';

  @override
  String scandalSendHomeCover(String player) {
    return '귀국, 대체 소집: $player';
  }

  @override
  String scandalKeep(String player) {
    return '잔류: $player';
  }

  @override
  String get scandalKeepNote => '잔류 시: 주기 끝까지 사기 약 -4, 이사회 약 -3.';

  @override
  String get scandalSendHomeNote =>
      '귀국 시: 사기와 이사회에 영향이 없으며, 대체 선수를 소집할 수 있습니다.';

  @override
  String get scandalFinalsNote =>
      '귀국 시: 사기와 이사회에 영향이 없지만, 본선 대회에서는 대체 선수를 소집할 수 없습니다.';

  @override
  String get scandalPickCover => '대체 선수 소집 (선택)';

  @override
  String newsScandalTitle(String player) {
    return '소집 중 스캔들: $player';
  }

  @override
  String yScandalParty0(String player, String tag) {
    return '젊으니까 그럴 수 있지. 소집 전날 밤 파티에 간 $player 선수, 그래도 그라운드에서 보고 싶다. #$tag';
  }

  @override
  String yScandalParty1(String player, String tag) {
    return '$player 선수, 대표팀 소집 몇 시간 전 밤샘 파티에서 포착. 협회에 보고됨. #$tag';
  }

  @override
  String yScandalParty2(String player, String tag) {
    return '소집 전에 밤샘 파티라니. $player 선수, 무슨 생각이었나? 믿을 수가 없다. #$tag';
  }

  @override
  String yScandalCurfew0(String player, String tag) {
    return '통금 넘겨서 들어왔다고? 그럴 수도 있지. $player 선수는 그라운드에서 만회하면 된다. #$tag';
  }

  @override
  String yScandalCurfew1(String player, String tag) {
    return '$player 선수, 훈련 몇 시간 전 통금 이후 팀 호텔로 돌아오다 적발. #$tag';
  }

  @override
  String yScandalCurfew2(String player, String tag) {
    return '통금은 어려운 게 아니다. $player 선수는 하룻밤도 못 버텼다. #$tag';
  }

  @override
  String yScandalNightclub0(String player, String tag) {
    return '$player 선수가 클럽에 갔다고? 선수도 사생활이 있다. 뛰게 해라. #$tag';
  }

  @override
  String yScandalNightclub1(String player, String tag) {
    return '대표팀 소집 전날 밤 나이트클럽에 있는 $player 선수의 사진 공개. #$tag';
  }

  @override
  String yScandalNightclub2(String player, String tag) {
    return '소집 전날 밤 클럽 사진. $player 선수가 유니폼에 먹칠을 했다. #$tag';
  }

  @override
  String yScandalCasino0(String player, String tag) {
    return '카지노에서 하룻밤 보낸 게 범죄는 아니다. $player 선수는 괜찮을 거다. #$tag';
  }

  @override
  String yScandalCasino1(String player, String tag) {
    return '$player 선수, 대표팀 소집 전날 밤 카지노 테이블에서 목격. #$tag';
  }

  @override
  String yScandalCasino2(String player, String tag) {
    return '소집 전에 밤새 카지노. $player 선수가 건 건 돈만이 아니다. #$tag';
  }

  @override
  String yScandalSentHome0(String player) {
    return '옳은 결정. 팀보다 큰 선수는 없다. $player 선수도 마찬가지.';
  }

  @override
  String yScandalSentHome1(String player) {
    return '$player 선수 귀국 조치가 유일한 답이었다. 감독에게 존경을.';
  }

  @override
  String yScandalSentHome2(String player) {
    return '규율은 규율이다. $player 선수는 규칙을 알고 있었다.';
  }

  @override
  String yScandalSentHome3(String player) {
    return '팀에 보내는 분명한 메시지: $player 선수는 귀국 비행기에 올랐다.';
  }

  @override
  String yScandalSentHome4(String player) {
    return '$player 선수에게 너무 가혹하다. 하룻밤 외출로 소집이 끝난다고?';
  }

  @override
  String yScandalSentHome5(String player) {
    return '$player 선수를 돌려보내면 우리가 약해진다. 그 대가는 그라운드에서 치를 거다.';
  }

  @override
  String yScandalKept0(String player) {
    return '$player 선수 잔류는 도박이다. 그라운드에서 갚아야 한다.';
  }

  @override
  String yScandalKept1(String player) {
    return '좋다, $player 선수 잔류. 그럼 모두에게 좋은 경기로 빚을 갚아야지.';
  }

  @override
  String yScandalKept2(String player) {
    return '그러니까 $player 선수에겐 규칙이 적용되지 않는다는 거군. 잘 알겠다.';
  }

  @override
  String yScandalKept3(String player) {
    return '이제 통금은 선택 사항인가 보다. $player 선수에게 물어봐라.';
  }

  @override
  String yScandalKept4(String player) {
    return '그 일 뒤에도 $player 선수 잔류? 이 대표팀은 여름 캠프냐.';
  }

  @override
  String yScandalKept5(String player) {
    return '밤새 파티하고 바로 선발. 훌륭한 메시지네요, 감독님. $player 선수는 아주 신났겠다.';
  }

  @override
  String get yStreamerBreaks0 => '형 걸렸다 😭😭 소집 전날 밤에?? 나 울어 💀💀💀';

  @override
  String get yStreamerBreaks1 => '아니아니 채팅 이거 봐 🤯🤯 형 진짜 소집 전에 그랬어 😭🔥';

  @override
  String get yStreamerBreaks2 => '누가 내보냈어?? 누가 내보냈냐고 😭😭💀 이거 완전 영화다 🔥🔥';

  @override
  String get yStreamerSentHome0 => '귀국?? 귀국이래!!! 😭😭😭 감독 장난 아니다 💀🔥';

  @override
  String get yStreamerSentHome1 => '형 생방송으로 짐 싸는 중 🤯🤯 잘 가 형 😭👋';

  @override
  String get yStreamerSentHome2 => '말도 안 돼애애 진짜 돌려보냈어 💀💀 채팅 나 떨려 🔥🔥🔥';

  @override
  String get yStreamerKept0 => '남는다고??? 남는대애애 🤯🤯 형은 건드릴 수 없는 존재 😭🔥';

  @override
  String get yStreamerKept1 => '밤새 파티하고 아직도 명단에 있어 💀💀 나도 그 계약 줘 😭😭';

  @override
  String get yStreamerKept2 => '감독이 괜찮대 😭😭 형 뭐야 🤯🤯🤯';

  @override
  String get yCameoUjfaloci => '나는 아무것도 내지 않았고, 그 금액도 맞지 않는다';

  @override
  String get yCameoHavir0 => '작은 물고기들이 헤엄쳐 가 버렸다.';

  @override
  String get yCameoHavir1 => '그물은 던졌는데 물고기는 딴 데 있었다.';

  @override
  String get yCameoHavir2 => '내가 9월에 굴라시 먹으면서 이미 말했지.';

  @override
  String get yCameoHavir3 => '제때 고기를 못 잡은 사람은 이제 와서 울지 마라.';

  @override
  String get yCameoHavir4 => '물 밖에 나온 메기처럼 뛰었다.';

  @override
  String get yCameoHavir5 => '바람이 불고 연못이 언다. 원래 그런 거다.';

  @override
  String get yCameoHavir6 => '어떤 날은 낡은 장화만 건져 올린다.';

  @override
  String get yCameoHavir7 => '우리 때는 적어도 맥주라도 한잔하러 갔지. 이젠 그것도 없다.';

  @override
  String get yCameoLzimberskyHome0 =>
      '하룻밤 때문에 젊은 선수를 돌려보낸다고? 그게 스캔들이지, 파티가 아니다!';

  @override
  String get yCameoLzimberskyHome1 => '젊은 선수들도 좀 즐길 권리가 있다! 위선적인 언론이 또 이겼다.';

  @override
  String get yCameoLzimberskyHome2 => '이건 마녀사냥이다. 젊은이가 하룻밤 나갔다고 매달아 버린다.';

  @override
  String get yCameoLzimberskyHome3 => '파티에 한 번도 안 가 본 기자만 돌을 던져라. 부끄러운 줄 알아라!';

  @override
  String get yCameoLzimberskyHome4 => '감독이 타블로이드에 겁먹었다. 나라면 마지막 숨까지 그 선수를 지켰다!';

  @override
  String get yCameoLzimberskyKept0 =>
      '드디어 배짱 있는 감독이 나왔다! 선수를 남겼으니 언론은 울든지 말든지.';

  @override
  String get yCameoLzimberskyKept1 => '젊은 선수들도 좀 즐길 권리가 있지 않나? 브라보, 감독님!';

  @override
  String get yCameoLzimberskyKept2 => '위선적인 언론은 소리치고 감독은 버틴다. 이렇게 하는 거다!';

  @override
  String get yCameoLzimberskyKept3 =>
      '하룻밤 외출했다고 언론이 돌을 던지려 한다. 감독이야말로 진짜 사나이다!';

  @override
  String get yCameoLzimberskyKept4 =>
      '내 말은, 선수들 좀 살게 해 줘라! 열심히 일하는 사람은 놀 자격도 있다. 엄지 척.';

  @override
  String get yTraitStreamer => '모든 걸 방송한다. 최대 볼륨, 전부 대문자로.';

  @override
  String hubEventAwardsCeremony(int year) {
    return '$year 올해의 선수';
  }

  @override
  String get hubEventAwardsCeremonySub => '투표 집계 완료';

  @override
  String get potyCeremonyWatch => '시상식 보기';

  @override
  String get potyCeremonySkipToList => '톱 5로 바로 가기';

  @override
  String get potyCeremonySkip => '건너뛰기';

  @override
  String get potyCeremonyIntro => '투표 집계가 끝났습니다. 올해 세계 최고의 선수 다섯 명입니다.';

  @override
  String potyCeremonyPlace(int place) {
    return '$place위';
  }

  @override
  String get potyCeremonyWinnerIs => '그리고 올해의 선수는...';

  @override
  String get potyTop5Heading => '세계 톱 5';

  @override
  String get potyYoungTop3Heading => '올해의 영플레이어: 톱 3';

  @override
  String get potySeeTop5 => '톱 5 보기';

  @override
  String get potyYourPlayer => '내 선수';

  @override
  String potyTallyCleanSheets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '무실점 $count경기',
    );
    return '$_temp0';
  }

  @override
  String get campaignFullBrief => '전체 브리핑';

  @override
  String campaignStarsSoFar(int earned, int total) {
    return '지금까지 획득한 별: $earned/$total';
  }

  @override
  String get campaignStarEarned => '획득함';

  @override
  String get campaignStarNotYet => '아직 획득하지 못함';

  @override
  String get stadiumsEntrySubClosed =>
      '경기장을 확인하세요. 공사는 다음 주기가 시작될 때 다시 주문할 수 있습니다.';

  @override
  String get boardObjectiveNoBrief => '목표 없음';

  @override
  String get boardObjectiveNoBriefBody =>
      '이사회는 이번 본선 진출을 기대하지 않습니다. 대신 경기 결과로 평가합니다.';

  @override
  String get boardObjectiveAwaitingDraw => '추첨 후 목표 설정';

  @override
  String get boardObjectiveAwaitingDrawBody => '조 추첨이 끝나면 이사회가 이 목표를 정합니다.';
}
