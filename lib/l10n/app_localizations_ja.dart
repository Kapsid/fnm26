// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get matchPreviewTitle => 'マッチプレビュー';

  @override
  String get matchKickOff => 'キックオフ';

  @override
  String get matchTactics => '戦術';

  @override
  String get matchYourXi => '先発イレブン';

  @override
  String get matchHeadToHead => '対戦成績';

  @override
  String matchCouldNotLoad(String error) {
    return '試合を読み込めませんでした。\n$error';
  }

  @override
  String get matchNoUpcoming => '予定されている試合はありません。';

  @override
  String get matchUnknownNation => '不明';

  @override
  String get matchH2hFirstMeeting => '史上初の対戦';

  @override
  String get matchH2hYouLead => '対戦成績で優位';

  @override
  String matchH2hOppEdge(String opponent) {
    return '$opponentが優位';
  }

  @override
  String get matchH2hEven => '互角';

  @override
  String matchH2hMet(int count) {
    return '対戦$count回';
  }

  @override
  String get matchH2hWon => '勝';

  @override
  String get matchH2hDrawn => '分';

  @override
  String get matchH2hLost => '敗';

  @override
  String get matchDossierTitle => 'スカウティングレポート';

  @override
  String get matchDossierForm => '調子';

  @override
  String get matchDossierNoGames => '最近の試合なし';

  @override
  String get matchDossierKeyMen => 'キーマン';

  @override
  String get matchDossierHowTheyPlay => '戦い方';

  @override
  String matchScoutFormation1(String formation) {
    return '普段は$formationで臨みます。';
  }

  @override
  String matchScoutFormation2(String formation) {
    return '基本の布陣は$formationです。';
  }

  @override
  String matchScoutFormation3(String formation) {
    return '$formationで組むことが多いチームです。';
  }

  @override
  String get matchScoutStrengthPressing => '高い位置からプレスをかけ、ボールを奪いに来ます。';

  @override
  String get matchScoutStrengthDirect => 'ダイレクトなサッカーで、早めにボールを前線へ送ります。';

  @override
  String get matchScoutStrengthPossession => 'ボール保持が巧みで、じっくりと組み立てます。';

  @override
  String get matchScoutStrengthCounter => '引いて構え、素早いカウンターを狙います。';

  @override
  String get matchScoutStrengthDeepDefence => '深い位置で守り、崩すのは容易ではありません。';

  @override
  String get matchScoutStrengthWide => 'ピッチを広く使い、サイドから攻めてきます。';

  @override
  String get matchScoutStrengthAttacking => '自分たちから主導権を握りに来るチームです。';

  @override
  String get matchScoutStrengthQuickForwards => 'FW陣は俊足で、裏への抜け出しを得意とします。';

  @override
  String get matchScoutStrengthPassingMidfield => '中盤のパスワークが優れています。';

  @override
  String get matchScoutStrengthHardRunning => '中盤には90分走り続けるスタミナがあります。';

  @override
  String get matchScoutStrengthSetPieces => 'セットプレーが脅威です。';

  @override
  String get matchScoutStrengthQuickDefence => '最終ラインが速く、裏を取るのは困難です。';

  @override
  String get matchScoutStrengthNone => '特に際立った武器は見当たりません。';

  @override
  String get matchScoutWeakSpaceBehind => '高いラインの裏には、ロングボールを通すスペースがあります。';

  @override
  String get matchScoutWeakPressedBuildUp => 'ハイプレスで遅いビルドアップを乱せます。';

  @override
  String get matchScoutWeakDeepBlock => '辛抱強く。あのような低いブロックも崩せます。';

  @override
  String get matchScoutWeakLongBall => 'ラインを下げれば、相手のロングボールは行き場を失います。';

  @override
  String get matchScoutWeakSlowDefence => 'DF陣はスピードに欠けるので、裏へ走り込ませましょう。';

  @override
  String get matchScoutWeakAerial => 'セットプレーの守備に不安があります。';

  @override
  String get matchScoutWeakPoorPassing => '中盤はプレッシャーを受けるとパスで逃げられません。';

  @override
  String get matchScoutWeakTiringMidfield => '中盤にはプレスを続けるだけの運動量がありません。';

  @override
  String get matchScoutWeakBluntAttack => 'FW陣はスピードに欠けます。';

  @override
  String get matchScoutApproachTakeTheGame => 'こちらに対しては、主導権を握りに来るでしょう。';

  @override
  String get matchScoutApproachEven => 'こちらに対しては、拮抗した接戦が予想されます。';

  @override
  String get matchScoutApproachSitDeep => 'こちらに対しては、慎重に構えてカウンターを狙うでしょう。';

  @override
  String get matchScoutLeaningAttacking => '遠目には攻撃的なチームに見えます。';

  @override
  String get matchScoutLeaningCautious => '遠目には慎重なチームに見えます。';

  @override
  String get matchScoutLeaningUnclear => '遠目では、どんな戦い方をするのか判断できません。';

  @override
  String get matchScoutHireHint => 'チーフスカウトを雇えば、相手の戦い方がわかります。';

  @override
  String matchCouldNotContinue(String error) {
    return '続行できませんでした: $error';
  }

  @override
  String get matchSkipToFullTime => '試合終了までスキップ';

  @override
  String get matchStatShots => 'シュート';

  @override
  String get matchStatGoals => 'ゴール';

  @override
  String get matchStatYellowCards => '警告';

  @override
  String get matchStatRedCards => '退場';

  @override
  String get matchMomentum => '流れ';

  @override
  String get matchSwingAtk => '攻';

  @override
  String get matchSwingDef => '守';

  @override
  String ceremonyWorldCupYear(int year) {
    return '世界選手権 $year';
  }

  @override
  String get ceremonyFinalsAreHere => '本大会、開幕';

  @override
  String ceremonyHostedBy(String hosts) {
    return '開催国  $hosts';
  }

  @override
  String get ceremonyHostTbc => '開催国未定';

  @override
  String get matchHalfTime => 'ハーフタイム';

  @override
  String get matchContinue => '続ける';

  @override
  String get matchContinuing => '処理中…';

  @override
  String matchTacticsWithSubs(int used, int max) {
    return '戦術 · 交代 $used/$max';
  }

  @override
  String matchTiredCount(int count) {
    return '疲労 ×$count';
  }

  @override
  String get matchTacticsLabel => '戦術';

  @override
  String get teamOverallOverTime => '総合力の推移';

  @override
  String get teamOverall => '総合力';

  @override
  String get teamTalkHeading => 'チームトーク';

  @override
  String get teamTalkPrompt => '後半に向けて指示を出しましょう。';

  @override
  String get teamTalkCalmLabel => '落ち着け';

  @override
  String get teamTalkCalmBlurb => 'チームを落ち着かせる。全体を少し底上げ。';

  @override
  String get teamTalkEncourageLabel => '励ます';

  @override
  String get teamTalkEncourageBlurb => '前に出て、勝ちに行く。';

  @override
  String get teamTalkDemandMoreLabel => 'もっと求める';

  @override
  String get teamTalkDemandMoreBlurb => 'すべてを懸けて猛攻を仕掛ける。';

  @override
  String get teamTalkPraiseLabel => '締めていけ';

  @override
  String get teamTalkPraiseBlurb => 'コンパクトに保ち、リードを守る。';

  @override
  String get teamTalkBelieveLabel => '自信を持て';

  @override
  String get teamTalkBelieveBlurb => '自分たちを信じろ。攻守両面を底上げ。';

  @override
  String get teamTalkFocusLabel => '集中を切らすな';

  @override
  String get teamTalkFocusBlurb => '全神経を集中。試合を確実に締める。';

  @override
  String get teamTalkUrgencyLabel => '危機感を持て';

  @override
  String get teamTalkUrgencyBlurb => '今すぐ追いかけろ。総攻撃だが隙も生まれる。';

  @override
  String get teamTalkReassureLabel => '気楽にいけ';

  @override
  String get teamTalkReassureBlurb => '緊張をほぐし、形を崩さない。';

  @override
  String get commonRetry => '再試行';

  @override
  String get commonSomethingWentWrong => '問題が発生しました';

  @override
  String get commonCrashBox => 'ここで問題が発生しました。\n詳細は 設定 → 診断 で確認できます。';

  @override
  String hubCouldNotAdvance(String error) {
    return 'ワールドを進められませんでした: $error';
  }

  @override
  String get settingsDiagnosticsTitle => '診断';

  @override
  String get settingsDiagnosticsBlurb => 'この端末で記録されたエラーです。外部には一切送信されません。';

  @override
  String get settingsContactTitle => 'お問い合わせ';

  @override
  String get settingsContactCopied => 'アドレスをコピーしました。';

  @override
  String get settingsCommunityTitle => 'コミュニティ';

  @override
  String get settingsDiscordSubtitle => 'コミュニティに参加';

  @override
  String get settingsLinkCopied => 'リンクをコピーしました。';

  @override
  String get diagnosticsEmpty => 'エラーの記録はありません。それが理想です。';

  @override
  String get diagnosticsCopy => 'コピー';

  @override
  String get diagnosticsCopied => 'ログをクリップボードにコピーしました。';

  @override
  String get diagnosticsClear => '消去';

  @override
  String get navHub => 'ホーム';

  @override
  String get navSquad => 'チーム';

  @override
  String get navStandings => '順位表';

  @override
  String get navCareers => 'キャリア';

  @override
  String get settingsTitle => '設定';

  @override
  String get settingsSoundHapticsTitle => 'サウンドと振動';

  @override
  String get settingsSoundHapticsBlurb => 'ゴール、キックオフ、試合終了時に振動と短い効果音。';

  @override
  String get settingsLanguageTitle => '言語';

  @override
  String get settingsLanguageBlurb => 'アプリの言語を選ぶか、端末の設定に従います。';

  @override
  String get settingsLanguageSystem => '端末の設定';

  @override
  String get settingsTextSizeTitle => '文字サイズ';

  @override
  String get settingsTextSizeBlurb => '読みにくい場合は文字を大きくしてください。';

  @override
  String get settingsTextSizeNormal => '標準';

  @override
  String get settingsTextSizeLarge => '大';

  @override
  String get settingsTextSizeLarger => '特大';

  @override
  String get matchPreviewAllMeetings => '全対戦を見る';

  @override
  String get recordsMeetings => '対戦履歴';

  @override
  String get recordsLegends => 'レジェンド';

  @override
  String get recordsAllTimeXi => '歴代ベストイレブン';

  @override
  String get recordsHallOfFame => '殿堂';

  @override
  String get recordsAllTimeWorld => '世界歴代記録';

  @override
  String get recordsAllTimeTopScorers => '歴代得点ランキング';

  @override
  String get recordsMostCapped => '最多キャップ';

  @override
  String get recordsMostWcStarts => '世界選手権 最多先発';

  @override
  String get recordsMostTournaments => '最多大会出場';

  @override
  String get recordsRecordBook => '記録集';

  @override
  String get recordsHeadToHead => '対戦成績';

  @override
  String get recordsFiercestRival => '最大のライバル';

  @override
  String get recordsMostCaps => '最多キャップ';

  @override
  String get recordsTopScorers => '得点ランキング';

  @override
  String get recordsMostAssists => '最多アシスト';

  @override
  String get recordsYourRecord => 'あなたの成績';

  @override
  String get callUpHome => 'ホーム';

  @override
  String get callUpAway => 'アウェー';

  @override
  String get recordsHome => 'ホーム';

  @override
  String get recordsAway => 'アウェー';

  @override
  String get recordsActive => '現役';

  @override
  String get recordsStillActive => '現役選手';

  @override
  String get recordsAvg => '平均';

  @override
  String get recordsSelect => '選択';

  @override
  String get recordsVs => 'vs';

  @override
  String get recordsDraws => '引き分け';

  @override
  String get recordsGoalsLabel => 'ゴール';

  @override
  String get recordsBestFinish => '最高成績';

  @override
  String get recordsNoFinalsYet => '本大会出場なし';

  @override
  String get recordsLongestUnbeaten => '最長無敗';

  @override
  String get recordsBiggestWin => '最大差勝利';

  @override
  String get recordsSeeAllMeetings => '全対戦を見る';

  @override
  String get recordsSaveNotFound => 'セーブデータが見つかりません。';

  @override
  String get recordsNoMatches => '該当なし。';

  @override
  String get recordsSearchPlayerOrNation => '選手名・国名で検索';

  @override
  String get recordsSearchNation => '国名で検索';

  @override
  String get recordsPickTwoDifferent => '異なる2か国を選んでください。';

  @override
  String get recordsPlayToBuildRecord => '試合をこなすと、各対戦国との成績がここに記録されます。';

  @override
  String get recordsTapOpponent => '対戦国をタップすると詳細を表示します。';

  @override
  String get recordsEdgeUpperHand => 'あなたが優位';

  @override
  String get recordsEdgeTheirNumber => '相手が苦手';

  @override
  String get recordsEdgeEven => '互角';

  @override
  String get recordsAllTimeWorldSubtitle => '全世界の得点者と最多キャップ、全代表';

  @override
  String get recordsHeadToHeadSubtitle => '任意の2か国の通算成績を比較';

  @override
  String get recordsLegendsSubtitle => '歴代ベストイレブンと殿堂';

  @override
  String get recordsUnitGoals => 'ゴール';

  @override
  String get recordsUnitCaps => 'キャップ';

  @override
  String get recordsUnitStarts => '先発';

  @override
  String get recordsUnitCups => '大会';

  @override
  String get recordsUnitAssists => 'アシスト';

  @override
  String recordsCapsCount(int count) {
    return '$countキャップ';
  }

  @override
  String recordsGoalsCount(int count) {
    return '$countゴール';
  }

  @override
  String recordsAssistsCount(int count) {
    return '$countアシスト';
  }

  @override
  String recordsMotmCount(int count) {
    return 'MOTM $count回';
  }

  @override
  String recordsMatchesCount(int count) {
    return '$count試合';
  }

  @override
  String recordsMeetingsCount(int count) {
    return '対戦$count回';
  }

  @override
  String recordsCodeWins(String code) {
    return '$codeの勝利';
  }

  @override
  String recordsMeetingsWdl(int meetings, int wins, int draws, int losses) {
    return '対戦$meetings回 · $wins勝$draws分$losses敗';
  }

  @override
  String recordsWdl(int wins, int draws, int losses) {
    return '$wins勝$draws分$losses敗';
  }

  @override
  String recordsRivalLine(int meetings, String record, String edge) {
    return '対戦$meetings回 · $record · $edge';
  }

  @override
  String recordsNeverMet(String a, String b) {
    return 'このセーブでは$aと$bは対戦したことがありません。';
  }

  @override
  String tacticsSentOffNote(String names) {
    return '$namesが退場。交代はできないため、1人少ない状態で戦います。';
  }

  @override
  String tacticsNeedFitPlayers(int required, int have) {
    return '出場可能な選手が$required人必要です（現在$have人）';
  }

  @override
  String tacticsMissesOfCamp(int missed, int total) {
    return '欠場 $missed/$total';
  }

  @override
  String get tacticsOutForWholeCamp => '今回の招集期間は全試合欠場';

  @override
  String get rankingCentreOnMe => '自国を表示';

  @override
  String get recordsAfterExtraTime => '延長';

  @override
  String recordsOnPenalties(int a, int b) {
    return 'PK $a–$b';
  }

  @override
  String recordsVersus(String a, String b) {
    return '$a vs $b';
  }

  @override
  String recordsPlayedScore(int played, int gf, int ga) {
    return '$played試合 · $gf–$ga';
  }

  @override
  String recordsBiggestWinValue(int gf, int ga, String opp) {
    return '$gf–$ga 対$opp';
  }

  @override
  String recordsCouldNotLoad(String error) {
    return '読み込めませんでした。\n$error';
  }

  @override
  String recordsCouldNotLoadLegends(String error) {
    return 'レジェンドを読み込めませんでした。\n$error';
  }

  @override
  String recordsCouldNotLoadRecords(String error) {
    return '記録を読み込めませんでした。\n$error';
  }

  @override
  String recordsCouldNotLoadNations(String error) {
    return '国一覧を読み込めませんでした。\n$error';
  }

  @override
  String recordsCouldNotLoadYourRecord(String error) {
    return 'あなたの成績を読み込めませんでした。\n$error';
  }

  @override
  String recordsCouldNotLoadRecord(String error) {
    return '成績を読み込めませんでした。\n$error';
  }

  @override
  String recordsNoLegends(String nation) {
    return 'レジェンドはまだいません。大会を重ねれば、$nationの名選手たちがここに現れます。';
  }

  @override
  String recordsGreatestSide(String nation) {
    return '$nation史上最強の布陣。';
  }

  @override
  String get recordsNoWorldHistory => '世界にはまだ歴史がありません。大会を重ねれば、歴代の名選手がここに現れます。';

  @override
  String recordsPlayToWriteHistory(String nation) {
    return '試合をこなして、$nationの歴史を刻み始めましょう。';
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
  String get tacticsGoalkeepers => 'ゴールキーパー';

  @override
  String get tacticsDefenders => 'ディフェンダー';

  @override
  String get tacticsMidfielders => 'ミッドフィルダー';

  @override
  String get tacticsForwards => 'フォワード';

  @override
  String get tacticsCallUpsTitle => '招集';

  @override
  String tacticsPickAtLeastPlayers(int min) {
    return '最低$min人を選んでください。';
  }

  @override
  String tacticsCouldNotLoadSquad(String error) {
    return 'メンバーを読み込めませんでした。\n$error';
  }

  @override
  String get tacticsNoSquad => 'メンバーがいません。';

  @override
  String tacticsSquadCount(int count, int max) {
    return 'メンバー · $count/$max';
  }

  @override
  String tacticsMinMax(int min, int max) {
    return '最少$min · 最大$max';
  }

  @override
  String get tacticsBestQuality => 'ベストメンバー';

  @override
  String get tacticsPreviousSquad => '前回のメンバー';

  @override
  String get tacticsSquadLockedBack => '戻る（メンバー確定済み）';

  @override
  String get tacticsConfirmSquad => 'メンバー確定';

  @override
  String tacticsSquadFullMax(int max) {
    return 'メンバーが上限です（最大$max人）';
  }

  @override
  String get tacticsSquadLocked => 'メンバー確定済み';

  @override
  String get tacticsNominationOpen => '招集期間中。メンバーを選んでください';

  @override
  String get tacticsSquadFixedBlurb => 'このメンバーで以下の試合を戦います。次の招集期間までに選び直してください。';

  @override
  String get tacticsSquadWillPlayBlurb => 'このメンバーで以下の試合を戦います。';

  @override
  String get tacticsUnknown => '不明';

  @override
  String tacticsAgeValue(int age, String value) {
    return '$age歳 · $value';
  }

  @override
  String get tacticsFatigueExhausted => '疲労困憊';

  @override
  String get tacticsFatigueTired => '疲労';

  @override
  String get tacticsFatigueMatchLegs => '試合疲れ';

  @override
  String tacticsTooManySubs(int max) {
    return '交代枠を超えています（最大$max人）。';
  }

  @override
  String tacticsMinuteTitle(int minute) {
    return '戦術 · $minute\'';
  }

  @override
  String get tacticsApply => '適用';

  @override
  String get tacticsTabLineupSubs => '布陣と交代';

  @override
  String get tacticsTabTactics => '戦術';

  @override
  String get squadLineKeepers => 'GK';

  @override
  String get squadLineDefenders => '守備';

  @override
  String get squadLineMidfielders => '中盤';

  @override
  String get squadLineForwards => '攻撃';

  @override
  String get squadStatXiRating => '先発評価';

  @override
  String get squadStatAvgAge => '平均年齢';

  @override
  String get squadStatSize => '人数';

  @override
  String get squadStatUnavailable => '離脱';

  @override
  String get squadDepthTitle => 'ポジション別の層';

  @override
  String squadAgeShort(int age) {
    return '$age歳';
  }

  @override
  String get tacticsTabOtherPositions => '他のポジション';

  @override
  String get tacticsOutOfPositionNote => '本来のポジションではない';

  @override
  String get tacticsNobodyElse => 'ここで試せる選手は他にいません。';

  @override
  String get tacticsPickSomebodyFirst =>
      '下げる選手を選ぶと、残りの控え選手がこのポジションでの評価とともに表示されます。';

  @override
  String get tacticsTabSuitable => '適任';

  @override
  String get tacticsTabOnPitch => '出場中';

  @override
  String tacticsSectionSuitable(int count) {
    return '適任 · $count';
  }

  @override
  String get tacticsNobodySuits => 'このポジションに適した控えがいないため、全員を表示しています。';

  @override
  String tacticsSectionOnPitch(int count, int max) {
    return '出場中 · $count/$max';
  }

  @override
  String tacticsSectionAvailable(int count) {
    return '交代可能 · $count';
  }

  @override
  String get tacticsRowStarted => '先発';

  @override
  String tacticsRowCameOn(int minute) {
    return '$minute\'に出場';
  }

  @override
  String get tacticsRowSubstitute => '途中出場';

  @override
  String get tacticsEnergyLabel => '体力';

  @override
  String tacticsPickReplacementFor(String name) {
    return '$nameの交代選手をタップしてください。もう一度タップすると取り消します。';
  }

  @override
  String get tacticsSlotLostToRedCard =>
      '退場でこのポジションは空いています。チームメイトをここにドラッグして穴を移動できます。';

  @override
  String get tacticsSentOffShort => '退場';

  @override
  String get tacticsFullBackLeft => '左サイドバック';

  @override
  String get tacticsFullBackRight => '右サイドバック';

  @override
  String get tacticsFullBackUp => '攻撃参加';

  @override
  String get tacticsFullBackDown => '守備に残る';

  @override
  String get tacticsFullBackOff => '指示なし';

  @override
  String tacticsFullBackUpHint(String side) {
    return '$side：攻撃参加。攻撃が少し増え、リスクも少し増えます。';
  }

  @override
  String tacticsFullBackDownHint(String side) {
    return '$side：守備に残る。少し安全になり、攻撃は少し減ります。';
  }

  @override
  String tacticsFullBackOffHint(String side) {
    return '$side：指示なし。チームの方針どおりにプレーします。';
  }

  @override
  String tacticsFullBackSemantics(String side, String state) {
    return '$sideの矢印：$state';
  }

  @override
  String tacticsSubsUsed(int used, int max) {
    return '交代 · $used/$max';
  }

  @override
  String get tacticsDragSubOn => 'ピッチ上の選手をタップして下げるか、控えを長押しして選手の上にドラッグします。';

  @override
  String get tacticsNoSubs => '交代できる選手がいません。';

  @override
  String get tacticsChooseShape => 'フォーメーションを選択';

  @override
  String get tacticsFormation => 'フォーメーション';

  @override
  String get tacticsInstructions => '指示';

  @override
  String get tacticsDrilling => '浸透度';

  @override
  String get tacticsDrillingUnplayed => '未使用';

  @override
  String get tacticsDrillingNew => '導入';

  @override
  String get tacticsDrillingSettling => '定着中';

  @override
  String get tacticsDrillingDrilled => '熟成';

  @override
  String get tacticsInstrMentality => 'メンタリティ';

  @override
  String get tacticsInstrDefensive => '守備的';

  @override
  String get tacticsInstrAttacking => '攻撃的';

  @override
  String get tacticsInstrPressing => 'プレス';

  @override
  String get tacticsInstrLowBlock => '低いブロック';

  @override
  String get tacticsInstrHighPress => 'ハイプレス';

  @override
  String get tacticsInstrTempo => 'テンポ';

  @override
  String get tacticsInstrPatient => 'じっくり';

  @override
  String get tacticsInstrFast => '速い';

  @override
  String get tacticsInstrWidth => '幅';

  @override
  String get tacticsInstrNarrow => '狭い';

  @override
  String get tacticsInstrWide => '広い';

  @override
  String get tacticsInstrDefLine => 'DFライン';

  @override
  String get tacticsInstrDefensiveLine => 'ディフェンスライン';

  @override
  String get tacticsInstrDeep => '低い';

  @override
  String get tacticsInstrHigh => '高い';

  @override
  String get tacticsInstrDirectness => '攻撃の速さ';

  @override
  String get tacticsInstrPossession => 'ポゼッション';

  @override
  String get tacticsInstrDirect => 'ダイレクト';

  @override
  String get tacticsPickGoalkeeper => 'GKを選択';

  @override
  String get tacticsPickLeftBack => '左SBを選択';

  @override
  String get tacticsPickCentreBack => 'CBを選択';

  @override
  String get tacticsPickRightBack => '右SBを選択';

  @override
  String get tacticsPickDefensiveMid => '守備的MFを選択';

  @override
  String get tacticsPickCentralMid => 'セントラルMFを選択';

  @override
  String get tacticsPickAttackingMid => '攻撃的MFを選択';

  @override
  String get tacticsPickLeftMid => '左MFを選択';

  @override
  String get tacticsPickRightMid => '右MFを選択';

  @override
  String get tacticsPickLeftWing => '左ウイングを選択';

  @override
  String get tacticsPickRightWing => '右ウイングを選択';

  @override
  String get tacticsPickStriker => 'ストライカーを選択';

  @override
  String tacticsRoleOutOfPosition(String role) {
    return '$role · 本職外';
  }

  @override
  String tacticsAgeOnly(int age) {
    return '$age歳';
  }

  @override
  String tacticsRoleAge(String role, int age) {
    return '$role · $age歳';
  }

  @override
  String get tacticsOn => '出場中';

  @override
  String get tacticsSquad => 'チーム';

  @override
  String get tacticsTabLineup => '布陣';

  @override
  String get tacticsTabInstructions => '指示';

  @override
  String get tacticsTabRoles => '役割';

  @override
  String get tacticsTabSetPieces => 'セットプレー';

  @override
  String get tacticsTabRolesSetPieces => '役割とセットプレー';

  @override
  String get tacticsRolesSetPiecesBlurb =>
      '先発選手それぞれに役割を与えます。PK（⚽）またはFK（▲）のバッジをタップしてキッカーを決めます。';

  @override
  String get tacticsTooltipCallUps => '招集';

  @override
  String get tacticsTooltipPresets => '戦術プリセット';

  @override
  String get tacticsTooltipInstructions => '指示';

  @override
  String get tacticsNoTacticSet => '戦術が設定されていません。';

  @override
  String tacticsReplaceStarters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '先発$count人を入れ替え',
    );
    return '$_temp0';
  }

  @override
  String tacticsPlayerOut(String name, String reason) {
    return '$name: $reason';
  }

  @override
  String get tacticsOut => '離脱';

  @override
  String get tacticsTapSpotReplace => 'ピッチ上のその位置をタップして代わりの選手を選んでください。';

  @override
  String get tacticsTapOrDrag => '選手をタップして入れ替えるか、長押ししてドラッグで移動します。';

  @override
  String get tacticsPlayerRoles => '選手の役割';

  @override
  String get tacticsRolesBlurb =>
      '選手に仕事を与えましょう。ポーチャー、司令塔、ターゲットマン。誰が決めて誰が作るかが変わります。';

  @override
  String get tacticsSetPieceTakers => 'セットプレーのキッカー';

  @override
  String get tacticsSetPieceBlurb => 'PKやFKを誰が蹴るか。最適な選手に任せることもできます。';

  @override
  String get tacticsTakerAuto => '自動';

  @override
  String get tacticsTakerQuickPick => '最適なキッカーを使う';

  @override
  String get tacticsPenalties => 'PK';

  @override
  String get tacticsCornersFreeKicks => 'CKとFK';

  @override
  String get tacticsSkillFin => '決定力';

  @override
  String get tacticsSkillPas => 'パス';

  @override
  String tacticsRolePlayer(String name) {
    return '役割 · $name';
  }

  @override
  String get tacticsPenaltyTaker => 'PKキッカー';

  @override
  String get tacticsCornerFreeKickTaker => 'CK・FKキッカー';

  @override
  String get tacticsAutomatic => '自動';

  @override
  String get tacticsLetBestSuited => '最も適した選手に任せます。';

  @override
  String get tacticsInXi => '先発';

  @override
  String get tacticsTeamInstructions => 'チーム指示';

  @override
  String get tacticsTeamInstructionsBlurb => 'チームの戦い方を設定します。各ダイヤルがチーム全体に影響します。';

  @override
  String tacticsSavedPreset(String name) {
    return '「$name」を保存しました';
  }

  @override
  String tacticsAppliedPreset(String name) {
    return '「$name」を適用しました';
  }

  @override
  String get tacticsTacticPresets => '戦術プリセット';

  @override
  String get tacticsPresetsBlurb => 'この布陣を再利用できるスタイルとして保存するか、保存済みのものを適用します。';

  @override
  String get tacticsSaveCurrentTactic => '現在の戦術を保存';

  @override
  String tacticsCouldNotLoadPresets(String error) {
    return 'プリセットを読み込めませんでした。\n$error';
  }

  @override
  String get tacticsNoPresetsYet =>
      'プリセットはまだありません。「現在の戦術を保存」をタップして、この設定をスタイルとして保存しましょう。';

  @override
  String get tacticsNameThisTactic => '戦術に名前を付ける';

  @override
  String get tacticsNameHint => '例: ハイプレス 4-3-3';

  @override
  String get tacticsCancel => 'キャンセル';

  @override
  String get tacticsSave => '保存';

  @override
  String get tacticsTapToAssign => 'タップして設定';

  @override
  String get tacticsHoldDragSub => '控えを長押しし、選手の上にドラッグして投入します。';

  @override
  String get hubContinue => '続ける';

  @override
  String get hubBrackets => 'トーナメント表';

  @override
  String hubCouldNotLoad(String error) {
    return '読み込めませんでした。\n$error';
  }

  @override
  String hubCouldNotLoadFinances(String error) {
    return '財務情報を読み込めませんでした。\n$error';
  }

  @override
  String hubCouldNotLoadSave(String error) {
    return 'セーブデータを読み込めませんでした。\n$error';
  }

  @override
  String get hubSaveNotFound => 'セーブデータが見つかりません。';

  @override
  String get hubUnknown => '不明';

  @override
  String hubWorldChampionsYear(int year) {
    return '$year年 世界王者';
  }

  @override
  String get hubCycleComplete => 'サイクルが終了しました。';

  @override
  String get hubYourJob => 'あなたの職';

  @override
  String get hubStayProject => '留任してプロジェクトを続ける';

  @override
  String get hubChooseNextJob => '次の職を選ぶ';

  @override
  String get hubOffersOnTable => '届いているオファー';

  @override
  String hubOfferSubtitle(String tier, int position) {
    return '$tier · 世界$position位';
  }

  @override
  String hubContinueWith(String nation) {
    return '$nationで続ける';
  }

  @override
  String get hubYourNation => 'あなたの国';

  @override
  String get hubTakeTheJob => '就任する';

  @override
  String get hubFederationFinances => '協会の財政';

  @override
  String get hubBudgetIntro => '次のサイクル最初の仕事は、協会予算を決めて各部門に配分することです。';

  @override
  String get hubStarting => '開始中…';

  @override
  String get hubBeginNextCycle => '次のサイクルを開始';

  @override
  String get hubContinueCareer => 'キャリアを続ける';

  @override
  String get hubBackToSaves => 'セーブ一覧に戻る';

  @override
  String get hubOpeningBalance => '期首残高';

  @override
  String get hubCentralFunding => '中央分配金';

  @override
  String get hubPrizeMoney => '賞金';

  @override
  String get hubCommercialReturn => '商業収入';

  @override
  String get hubAvailableToInvest => '投資可能額';

  @override
  String hubReputation(String label, int rep) {
    return '評価: $label（$rep）';
  }

  @override
  String get hubNationalHero => '国民的英雄';

  @override
  String get hubFinal => '決勝';

  @override
  String get hubStageRoundOf32 => 'ラウンド32';

  @override
  String get hubStageThirdPlace => '3位決定戦';

  @override
  String get hubEventAdvanceWorld => 'ワールドを進める';

  @override
  String hubEventStartCycle(int year) {
    return '$year年サイクルを開始';
  }

  @override
  String hubEventWorldChampions(String nation) {
    return '$nationが世界王者';
  }

  @override
  String get hubEventSetBudget => '協会予算を設定';

  @override
  String get hubEventSetBudgetSub => 'シーズン開幕前に今サイクルの資金を配分しましょう';

  @override
  String get hubEventNaturalization => '帰化の申し出を検討';

  @override
  String get hubEventNaturalizationSub => '外国籍の選手があなたの国への代表変更を希望しています';

  @override
  String get hubEventCampaignVerdict => 'キャンペーン決着: 結果を見る';

  @override
  String get hubEventCampaignComplete => 'キャンペーン完了';

  @override
  String get hubEventIntercontinentalPlayoff => '大陸間プレーオフ';

  @override
  String get hubEventWatchWcDraw => '世界選手権の抽選を見る';

  @override
  String get hubEventWorldCupHere => '世界選手権、開幕';

  @override
  String get hubEventWatchFinalsDraw => '本大会の抽選を見る';

  @override
  String get hubEventFinalsHere => '本大会、開幕';

  @override
  String get hubEventPlayWcRound => '世界選手権の次のラウンドへ';

  @override
  String hubEventPlayCupMatch(String cup) {
    return '$cupの次の試合へ';
  }

  @override
  String get hubEventPlayNationsCupMatch => 'ネーションズカップの次の試合へ';

  @override
  String get hubEventWatchNationsCupDraw => 'ネーションズカップの抽選を見る';

  @override
  String get hubEventWatchHostSelection => '開催国決定を見る';

  @override
  String get hubEventWatchQualifyingDraw => '予選の抽選を見る';

  @override
  String get hubEventWatchWcHostSelection => '世界選手権の開催国決定を見る';

  @override
  String get hubEventWatchWcQualifyingDraw => '世界選手権予選の抽選を見る';

  @override
  String get hubEventArrangeFriendlies => '親善試合を組む';

  @override
  String hubEventFriendliesSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '親善試合の空き枠が$countつ残っています',
      one: '親善試合の空き枠がまだ埋まっていません',
    );
    return '$_temp0';
  }

  @override
  String get hubEventReshapeXi => '先発メンバーを組み直す';

  @override
  String hubEventReshapeOutSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '先発の$count人が出場停止または負傷で離脱中です。代わりを選んでください',
      one: '先発の1人が出場停止または負傷で離脱中です。代わりを選んでください',
    );
    return '$_temp0';
  }

  @override
  String hubEventReshapeShortSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '先発メンバーが足りません。空いた枠を埋めてください',
      one: '先発メンバーが足りません。空いた枠を埋めてください',
    );
    return '$_temp0';
  }

  @override
  String hubEventPlayOpponent(String opponent) {
    return '対$opponent戦へ';
  }

  @override
  String get hubEventContinentalFinalsFallback => '大陸選手権本大会';

  @override
  String get hubCallUpFriendlies => '親善試合のメンバーを選ぶ';

  @override
  String get hubCallUpRequalify => '予選メンバーを選び直す';

  @override
  String get hubCallUpWorldCup => '世界選手権のメンバーを選ぶ';

  @override
  String get hubCallUpFinals => '本大会のメンバーを選ぶ';

  @override
  String get hubCallUpNationsCup => 'ネーションズカップのメンバーを選ぶ';

  @override
  String get hubCallUpQualifying => '予選のメンバーを選ぶ';

  @override
  String get hubCallUpGeneric => 'メンバーを選ぶ';

  @override
  String get hubHost => '開催国';

  @override
  String get hubGoldenBoot => '得点王';

  @override
  String hubGoldenBootValue(String name, int goals) {
    return '$name · $goalsゴール';
  }

  @override
  String get hubPens => '（PK）';

  @override
  String get hubNationalHub => '代表ハブ';

  @override
  String get hubMessages => 'メッセージ';

  @override
  String get hubWorldChampions => '世界王者';

  @override
  String get hubViewBracket => 'トーナメント表 ›';

  @override
  String get hubBoardDelighted => '大満足';

  @override
  String get hubBoardPleased => '満足';

  @override
  String get hubBoardExpectingMore => '期待以下';

  @override
  String get hubBoardConcerned => '懸念';

  @override
  String get hubBoardJobAtRisk => '解任の危機';

  @override
  String get hubBoard => '協会';

  @override
  String hubBoardObjective(String label) {
    return '協会の目標: $label';
  }

  @override
  String hubObjectiveMet(String result) {
    return '達成 · $result';
  }

  @override
  String hubObjectiveMissed(String result) {
    return '未達 · $result';
  }

  @override
  String get hubNoMoreFixtures => '今サイクルの試合はもうありません。';

  @override
  String get hubVs => 'VS';

  @override
  String hubWorldRank(int rank) {
    return '$rank位';
  }

  @override
  String get hubWorldRankLabel => '世界ランキング';

  @override
  String get hubSquadStatus => 'チーム状況';

  @override
  String hubPlayers(int count) {
    return '$count人';
  }

  @override
  String get hubAvgRating => '平均評価';

  @override
  String get hubMorale => '士気';

  @override
  String get hubManageTeam => 'チーム管理';

  @override
  String get hubGroupsToBeDrawn => '組み合わせは未定です。抽選を見て確認しましょう。';

  @override
  String hubGroupName(String name) {
    return 'グループ$name';
  }

  @override
  String get hubTblTeam => 'チーム';

  @override
  String get hubTblP => '試';

  @override
  String get hubTblGd => '得失';

  @override
  String get hubTblPts => '勝点';

  @override
  String get homeSettings => '設定';

  @override
  String get homeLeadTheNation => '国を率いよ';

  @override
  String get homeYourNation => 'あなたの国';

  @override
  String get homeNewGame => 'ニューゲーム';

  @override
  String get homeAllSaves => 'セーブ一覧';

  @override
  String get homeLoadGame => 'ロード';

  @override
  String get homeContinue => '続きから';

  @override
  String homeRoadToWorldCup(String date, int year) {
    return '$date · $year年世界選手権への道';
  }

  @override
  String get careerManageSaves => 'セーブ管理';

  @override
  String get careerNewGameTitle => 'ニューゲーム';

  @override
  String careerCouldNotLoadNation(String error) {
    return '国を読み込めませんでした。\n$error';
  }

  @override
  String get careerNationNotFound => '国が見つかりません。';

  @override
  String careerWorldRankNum(int rank) {
    return '世界ランク $rank位';
  }

  @override
  String get careerManagerName => '監督名';

  @override
  String get careerManagerNameHint => '例: 山田 太郎';

  @override
  String get careerBeginsBlurb => 'キャリアは2026年9月、2030年世界選手権への道から始まります。';

  @override
  String get careerFreeCycleNote =>
      '4年間の1サイクル（予選、大陸選手権、世界選手権）を2つのセーブで無料プレイできます。その後は1回の購入で無制限にサイクルを続けられます。';

  @override
  String get careerStartCareer => 'キャリア開始';

  @override
  String get careersTitle => 'キャリア';

  @override
  String get careerManagerCareer => '監督キャリア';

  @override
  String get careerManagerCareerSubtitle => '指揮したすべてのサイクルと通算成績';

  @override
  String get careerSummaryTitle => 'キャリア概要';

  @override
  String get careerSummarySubtitle => 'トロフィーと監督成績';

  @override
  String get careerAchievements => '実績';

  @override
  String get careerAchievementsSubtitle => '節目、タイトル、協会の満足度';

  @override
  String get careerChallenges => 'チャレンジ';

  @override
  String get careerChallengesSubtitle => 'キャリアを通じた過酷な試練に挑戦';

  @override
  String get careerTeamRecords => 'チーム記録';

  @override
  String get careerTeamRecordsSubtitle => '歴代得点王と出場記録';

  @override
  String get careerMyMatches => '試合一覧';

  @override
  String get careerMyMatchesSubtitle => '全結果と今後の日程';

  @override
  String get careerTitle => 'キャリア';

  @override
  String careerCouldNotLoadCareer(String error) {
    return 'キャリアを読み込めませんでした。\n$error';
  }

  @override
  String get careerNoCareer => 'キャリアがありません。';

  @override
  String get careerTrophyCabinet => 'トロフィー';

  @override
  String get careerTournamentHistory => '大会履歴';

  @override
  String get careerNoTournamentsYet => '終了した大会はまだありません。';

  @override
  String get careerTeamFallback => 'チーム';

  @override
  String careerWorldNum(int rank) {
    return '世界$rank位';
  }

  @override
  String careerPointsNum(int points) {
    return '${points}pt';
  }

  @override
  String careerSeasonNum(int season) {
    return 'シーズン$season';
  }

  @override
  String get careerStatPlayedShort => '試';

  @override
  String get careerStatsHeading => '数字で見る';

  @override
  String get careerStatsWinRate => '勝率';

  @override
  String get careerStatsGoalsFor => '総得点';

  @override
  String get careerStatsGoalsAgainst => '総失点';

  @override
  String get careerStatsGoalDiff => '得失点差';

  @override
  String get careerStatsCleanSheets => '完封';

  @override
  String get careerStatsBiggestWin => '最大得点差勝利';

  @override
  String get careerStatsWinStreak => '連勝';

  @override
  String get careerStatsUnbeaten => '無敗';

  @override
  String get careerStatsShootouts => 'PK戦';

  @override
  String get careerStatsHatTricks => 'ハットトリック';

  @override
  String get careerStatsMotms => 'MOTM';

  @override
  String get careerStatsBestRating => '最高評価';

  @override
  String get careerStatWonShort => '勝';

  @override
  String get careerStatDrawnShort => '分';

  @override
  String get careerStatLostShort => '敗';

  @override
  String get careerStatGoalsForShort => '得';

  @override
  String get careerStatGoalsAgainstShort => '失';

  @override
  String get careerStatGoalDiffShort => '差';

  @override
  String get careerNoSilverware => 'タイトルはまだありません。勝ち取りましょう。';

  @override
  String get careerMedalGold => '金';

  @override
  String get careerMedalSilver => '銀';

  @override
  String get careerMedalBronze => '銅';

  @override
  String careerWinnersName(String name) {
    return '優勝: $name';
  }

  @override
  String get careerSavesTitle => 'セーブ';

  @override
  String careerCouldNotLoadSaves(String error) {
    return 'セーブを読み込めませんでした。\n$error';
  }

  @override
  String careerSlotsCount(int used, int limit) {
    return 'スロット  $used/$limit';
  }

  @override
  String get careerThisSave => 'このセーブ';

  @override
  String get careerSlotsFull => 'スロットが一杯';

  @override
  String careerSlotsUsed(int used) {
    return 'スロット  $used';
  }

  @override
  String get careerSlotsUnlockMore => 'セーブ枠を追加';

  @override
  String get careerSlotsKeepNote => '既存のセーブはすべて引き続きプレイできます。新規作成にのみ解除が必要です。';

  @override
  String get careerNewGame => 'ニューゲーム';

  @override
  String get careerDeleteSaveTitle => 'セーブを削除しますか？';

  @override
  String careerDeleteSaveBody(String label) {
    return '$labelのキャリアは完全に削除されます。';
  }

  @override
  String get careerCancel => 'キャンセル';

  @override
  String get careerDelete => '削除';

  @override
  String get careerNoSavesYet => 'セーブはまだありません。\nニューゲームで国を率いましょう。';

  @override
  String get careerUnknownNation => '不明';

  @override
  String careerPlayedMinutes(int minutes) {
    return '$minutes分';
  }

  @override
  String careerPlayedHours(int hours, int minutes) {
    return '$hours時間$minutes分';
  }

  @override
  String careerLastPlayed(String when) {
    return '最終プレイ $when';
  }

  @override
  String get careerJustNow => 'たった今';

  @override
  String get careerYesterday => '昨日';

  @override
  String careerMinutesAgo(int n) {
    return '$n分前';
  }

  @override
  String careerHoursAgo(int n) {
    return '$n時間前';
  }

  @override
  String careerDaysAgo(int n) {
    return '$n日前';
  }

  @override
  String careerRoadToWorldCup(int year) {
    return '$year年世界選手権への道';
  }

  @override
  String get careerManagerCareerTitle => '監督キャリア';

  @override
  String careerCouldNotLoad(String error) {
    return '読み込めませんでした。\n$error';
  }

  @override
  String get careerCycleByCycle => 'サイクル別';

  @override
  String careerCyclesNationsLed(int cycles, int nations) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cyclesサイクル',
    );
    String _temp1 = intl.Intl.pluralLogic(
      nations,
      locale: localeName,
      other: '$nationsか国を指揮',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get careerStatTitles => 'タイトル';

  @override
  String get careerStatPlayed => '試合';

  @override
  String get careerStatWon => '勝';

  @override
  String get careerStatDrawn => '分';

  @override
  String get careerStatLost => '敗';

  @override
  String careerGoalsWinRate(
    int goalsFor,
    int goalsAgainst,
    String gd,
    int winRate,
  ) {
    return '得点 $goalsFor–$goalsAgainst  （$gd）  ·  勝率 $winRate%';
  }

  @override
  String get careerRecordResults => '記録的な結果';

  @override
  String get careerBestWin => '最大勝利';

  @override
  String get careerWorstDefeat => '最大敗戦';

  @override
  String careerVsOpponentDate(String opponent, String date) {
    return '対$opponent · $date';
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
    return '$won勝$drawn分$lost敗  ·  得点$goalsFor 失点$goalsAgainst（$gd）';
  }

  @override
  String get careerWorldCupLabel => '世界選手権';

  @override
  String get careerContinentalLabel => '大陸選手権';

  @override
  String get messagesTitle => 'メッセージ';

  @override
  String get messagesNoMessagesYet => 'メッセージはまだありません。';

  @override
  String messagesCouldNotLoad(String error) {
    return 'メッセージを読み込めませんでした。\n$error';
  }

  @override
  String get messagesDone => '完了';

  @override
  String get messagesNext => '次へ';

  @override
  String get rankingWorldRanking => '世界ランキング';

  @override
  String rankingCouldNotLoad(String error) {
    return 'ランキングを読み込めませんでした。\n$error';
  }

  @override
  String get rankingNoRanking => 'ランキングがありません。';

  @override
  String get rankingAll => '全て';

  @override
  String get rankingYourTeam => '自国';

  @override
  String get rankingYourRankingOverTime => 'ランキングの推移';

  @override
  String rankingNowRank(int rank) {
    return '現在$rank位';
  }

  @override
  String rankingBestWorst(int best, int worst) {
    return '最高$best位 · 最低$worst位';
  }

  @override
  String get friendliesTitle => '親善試合';

  @override
  String friendliesLoadError(String error) {
    return '親善試合を読み込めませんでした。\n$error';
  }

  @override
  String get friendliesContinue => '続ける';

  @override
  String friendliesArrangeIntro(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countつの枠',
    );
    return '次の公式戦までに空いている$_temp0で調整試合を組みましょう。対戦相手をタップするか、空けたままにします。';
  }

  @override
  String get friendliesFree => '空き';

  @override
  String matchGoalsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countゴール',
      one: '1ゴール',
    );
    return '$_temp0';
  }

  @override
  String get matchGoalsTitle => 'ゴール';

  @override
  String get matchGoalsNone => '得点なし';

  @override
  String get matchGoalPenalty => 'PK';

  @override
  String get matchGoalSetPiece => 'SP';

  @override
  String matchGoalAssist(String name) {
    return 'アシスト $name';
  }

  @override
  String get friendliesHome => 'ホーム';

  @override
  String get friendliesAway => 'アウェー';

  @override
  String get friendliesNoneThisWindow => '今回は親善試合なし';

  @override
  String friendliesConfirmCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '親善試合$count試合を確定',
      one: '親善試合1試合を確定',
    );
    return '$_temp0';
  }

  @override
  String get friendliesMonthJan => '1月';

  @override
  String get friendliesMonthFeb => '2月';

  @override
  String get friendliesMonthMar => '3月';

  @override
  String get friendliesMonthApr => '4月';

  @override
  String get friendliesMonthMay => '5月';

  @override
  String get friendliesMonthJun => '6月';

  @override
  String get friendliesMonthJul => '7月';

  @override
  String get friendliesMonthAug => '8月';

  @override
  String get friendliesMonthSep => '9月';

  @override
  String get friendliesMonthOct => '10月';

  @override
  String get friendliesMonthNov => '11月';

  @override
  String get friendliesMonthDec => '12月';

  @override
  String get resultsMyMatches => '試合一覧';

  @override
  String resultsCouldNotLoad(String error) {
    return '結果を読み込めませんでした。\n$error';
  }

  @override
  String get resultsNoFixtures => '試合がありません。';

  @override
  String get resultsVs => 'vs';

  @override
  String get resultsStageQualifier => '予選';

  @override
  String get resultsStageFriendly => '親善試合';

  @override
  String get resultsStageGroupStage => 'グループステージ';

  @override
  String get resultsStageSemiFinal => '準決勝';

  @override
  String get resultsStageFinal => '決勝';

  @override
  String get resultsStageContinentalClash => 'コンチネンタル・クラッシュ';

  @override
  String get resultsStageFinalsGroup => '本大会グループ';

  @override
  String get resultsStageRoundOf32 => 'ラウンド32';

  @override
  String get resultsStageRoundOf16 => 'ラウンド16';

  @override
  String get resultsStageQuarterFinal => '準々決勝';

  @override
  String get resultsStageThirdPlace => '3位決定戦';

  @override
  String get matchSetupWarnCaptain => 'キャプテンが未指名です。タップして腕章を託しましょう';

  @override
  String matchSetupWarnCaptainInjured(String name) {
    return '$nameは負傷中で、この試合はチームを率いられません。タップして腕章を託し直しましょう';
  }

  @override
  String matchSetupWarnCaptainSuspended(String name) {
    return '$nameはこの試合出場停止です。タップして腕章を託し直しましょう';
  }

  @override
  String matchSetupWarnCaptainDropped(String name) {
    return '$nameが腕章を持っていますが、招集メンバー外です。タップして託し直しましょう';
  }

  @override
  String get matchSetupWarnSetPieces => 'セットプレーのキッカーが未指名です。タップして選びましょう';

  @override
  String get matchSetupWarnBoth => 'キャプテンもキッカーも未指名です。タップして設定しましょう';

  @override
  String matchStageMatchday(int matchday) {
    return '第$matchday節';
  }

  @override
  String get squadCaptain => 'キャプテン';

  @override
  String deptEffectYouth(int points) {
    return 'アカデミーの有望株の総合力が約$points向上';
  }

  @override
  String deptEffectCommercial(String amount) {
    return 'サイクル終了時に$amountを回収';
  }

  @override
  String deptEffectMedical(int percent) {
    return '負傷が$percent%減少';
  }

  @override
  String deptEffectNaturalisation(int percent) {
    return '外国籍選手が代表変更を申し出る確率$percent%';
  }

  @override
  String deptEffectBoard(int points) {
    return '解任の危機まで協会の忍耐 +$points';
  }

  @override
  String get deptEffectNone => '予算なしでは効果なし';

  @override
  String get statsBestRated => '評価';

  @override
  String get statsMyCareer => 'キャリア';

  @override
  String get statsBestAverageRating => '最高平均評価';

  @override
  String get statsMyCareerRecord => 'あなたの成績';

  @override
  String get statsNoRatingsRecorded => '試合評価の記録はまだありません。';

  @override
  String get statsGroupRecord => '成績';

  @override
  String get statsGroupRuns => '連続記録';

  @override
  String get statsGroupExtremes => '最高と最低';

  @override
  String get statsGroupSplits => 'ホームとアウェー';

  @override
  String get statsGroupSquad => '選手';

  @override
  String get statsPlayed => '試合数';

  @override
  String get statsWinDrawLoss => '勝–分–敗';

  @override
  String get statsWinRate => '勝率';

  @override
  String get statsGoals => '得点:失点';

  @override
  String get statsCleanSheets => '完封';

  @override
  String get statsFailedToScore => '無得点';

  @override
  String get statsLongestWinStreak => '最長連勝';

  @override
  String get statsLongestUnbeaten => '最長無敗';

  @override
  String get statsLongestCleanSheets => '最長連続完封';

  @override
  String get statsLongestWinless => '最長未勝利';

  @override
  String get statsCurrentRun => '現在の無敗記録';

  @override
  String get statsBiggestWin => '最大勝利';

  @override
  String get statsHeaviestDefeat => '最大敗戦';

  @override
  String get statsMostGoalsInAGame => '1試合最多得点';

  @override
  String get statsShootouts => 'PK戦 勝–敗';

  @override
  String get statsComebackWins => '逆転勝利';

  @override
  String get statsHome => 'ホーム';

  @override
  String get statsAway => 'アウェー';

  @override
  String get statsNeutral => '中立地';

  @override
  String get statsCompetitive => '公式戦';

  @override
  String get statsFriendlies => '親善試合';

  @override
  String get statsHatTricks => 'ハットトリック';

  @override
  String get statsBraces => '1試合2得点';

  @override
  String get statsMotms => 'MOTM受賞';

  @override
  String get statsAssists => 'アシスト';

  @override
  String get statsCards => 'カード';

  @override
  String get statsBestRating => '個人最高評価';

  @override
  String statsAppsShort(int apps) {
    return '$apps試合';
  }

  @override
  String statsMotmShort(int motms) {
    return 'MOTM $motms回';
  }

  @override
  String get captainArmband => 'C';

  @override
  String get captainCurrent => 'キャプテン。タップで腕章を外します';

  @override
  String get captainFitBorn => '生まれながらのリーダー';

  @override
  String get captainFitNatural => 'キャプテンの器';

  @override
  String get captainFitCapable => '務まる';

  @override
  String get captainFitUnproven => 'まだリーダーではない';

  @override
  String get captainNone => 'キャプテン未指名';

  @override
  String captainMoraleBoost(int morale) {
    return 'チームの士気 +$morale';
  }

  @override
  String get resultsCategoryWorldCupQualifying => '世界選手権予選';

  @override
  String get resultsCategoryFriendlies => '親善試合';

  @override
  String get resultsCategoryContinentalClash => 'コンチネンタル・クラッシュ';

  @override
  String get resultsCategoryNationsCup => 'ネーションズカップ';

  @override
  String get resultsCategoryContinentalCup => '大陸選手権';

  @override
  String get resultsCategoryWorldCupQualifyingShort => '世界選手権予選';

  @override
  String get resultsCategoryContinentalQualifyingShort => '大陸選手権予選';

  @override
  String get resultsCategoryContinentalQualifying => '大陸選手権予選';

  @override
  String get resultsCategoryWorldCupFinals => '世界選手権本大会';

  @override
  String get resultsRoundResults => 'ラウンド結果';

  @override
  String get resultsFriendlyInternationals => '国際親善試合';

  @override
  String get resultsKnockout => 'ノックアウト';

  @override
  String resultsEarlierMatches(int count) {
    return '過去の試合（$count）';
  }

  @override
  String resultsMatchday(int matchday) {
    return '第$matchday節';
  }

  @override
  String get resultsContinue => '続ける';

  @override
  String resultsGroup(String name) {
    return 'グループ$name';
  }

  @override
  String get achievementsScreenTitle => '実績';

  @override
  String get achievementsChallengesTooltip => 'チャレンジ';

  @override
  String get achievementsChallengesHeading => 'チャレンジ';

  @override
  String get achievementsBrutalTests => 'キャリアを通じた過酷な試練';

  @override
  String achievementsCouldNotLoad(String error) {
    return '読み込めませんでした。\n$error';
  }

  @override
  String achievementsUnlockedCount(int earned, int total) {
    return '$earned / $total 解除';
  }

  @override
  String achievementsConqueredCount(int done, int total) {
    return '$done / $total 達成';
  }

  @override
  String get achievementsBoardSatisfaction => '協会の満足度';

  @override
  String achievementsUnlockedBanner(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '実績を$count個解除',
    );
    return '$_temp0';
  }

  @override
  String get achCatWins => '勝利';

  @override
  String get achCatMatches => '試合';

  @override
  String get achCatQualifications => '予選突破';

  @override
  String get achCatTitles => 'タイトル';

  @override
  String get achCatMisc => 'その他';

  @override
  String get achCatMega => 'メガ';

  @override
  String get achCatGoals => 'ゴール';

  @override
  String get achCatStreaks => '連続記録';

  @override
  String get achTierBronze => 'ブロンズ';

  @override
  String get achTierSilver => 'シルバー';

  @override
  String get achTierGold => 'ゴールド';

  @override
  String get achTierPlatinum => 'プラチナ';

  @override
  String achGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countゴール',
    );
    return '$_temp0';
  }

  @override
  String achGoalsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countゴールを決める。',
      one: '1ゴールを決める。',
    );
    return '$_temp0';
  }

  @override
  String achCleanSheets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '完封$count回',
    );
    return '$_temp0';
  }

  @override
  String achCleanSheetsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count試合を完封する。',
      one: '1試合を完封する。',
    );
    return '$_temp0';
  }

  @override
  String get achStreakWin5 => '勝ち癖';

  @override
  String get achStreakWin5Desc => '5連勝する。';

  @override
  String get achStreakWin10 => '破竹の勢い';

  @override
  String get achStreakWin10Desc => '10連勝する。';

  @override
  String get achStreakWin20 => '無敵艦隊';

  @override
  String get achStreakWin20Desc => '20連勝する。';

  @override
  String get achUnbeaten15 => '負けないチーム';

  @override
  String get achUnbeaten15Desc => '15試合無敗を達成する。';

  @override
  String get achUnbeaten30 => 'アンタッチャブル';

  @override
  String get achUnbeaten30Desc => '30試合無敗を達成する。';

  @override
  String get achHattrick => 'ハットトリックの英雄';

  @override
  String get achHattrickDesc => '選手がハットトリックを達成する。';

  @override
  String get achMotm10 => '傑出';

  @override
  String get achMotm10Desc => 'MOTMを10回獲得する。';

  @override
  String get achMotm50 => '絶対的エース';

  @override
  String get achMotm50Desc => 'MOTMを50回獲得する。';

  @override
  String get achPerfect => 'パーフェクト';

  @override
  String get achPerfectDesc => '選手が試合評価9.5以上を記録する。';

  @override
  String get achShootout => '鋼の心臓';

  @override
  String get achShootoutDesc => 'PK戦で5回勝利する。';

  @override
  String get achMassacre => '大虐殺';

  @override
  String get achMassacreDesc => '7点差以上で勝利する。';

  @override
  String get achAnnihilation => '殲滅';

  @override
  String get achAnnihilationDesc => '10点差以上で勝利する。';

  @override
  String get chTierBronze => 'ブロンズ';

  @override
  String get chTierSilver => 'シルバー';

  @override
  String get chTierGold => 'ゴールド';

  @override
  String get chTierLegendary => 'レジェンド';

  @override
  String get chFirstSteps => 'ベンチの主';

  @override
  String get chFirstStepsDesc => '5年間指揮を執る。';

  @override
  String get chUnbeaten10 => '破竹の勢い';

  @override
  String get chUnbeaten10Desc => '公式戦10試合無敗を達成する。';

  @override
  String get chTwoNations => '新たな挑戦';

  @override
  String get chTwoNationsDesc => '2つの異なる国を指揮する。';

  @override
  String get chCont1 => '大陸王者';

  @override
  String get chCont1Desc => '大陸選手権で優勝する。';

  @override
  String get chNc1 => 'ネーションズカップ王者';

  @override
  String get chNc1Desc => 'ネーションズカップで優勝する。';

  @override
  String get chWc1 => '世界王者';

  @override
  String get chWc1Desc => '世界選手権で優勝する。';

  @override
  String get chYears25 => '重鎮';

  @override
  String get chYears25Desc => '25年間指揮を執る。';

  @override
  String get chWc3 => '常勝監督';

  @override
  String get chWc3Desc => '世界選手権で3回優勝する。';

  @override
  String get chWc5 => '王朝';

  @override
  String get chWc5Desc => '世界選手権で5回優勝する。';

  @override
  String get chWc10 => '不滅';

  @override
  String get chWc10Desc => '世界選手権で10回優勝する。';

  @override
  String get chWc2Teams => 'どこでも勝てる';

  @override
  String get chWc2TeamsDesc => '2つの異なる国で世界選手権を制する。';

  @override
  String get chWc3Teams => '世界を渡る男';

  @override
  String get chWc3TeamsDesc => '3つの異なる国で世界選手権を制する。';

  @override
  String get chWcStreak3 => '3連覇';

  @override
  String get chWcStreak3Desc => '世界選手権で3連覇する。';

  @override
  String get chWcAllconf => '世界の征服者';

  @override
  String get chWcAllconfDesc => '全6連盟それぞれの国で世界選手権を制する。';

  @override
  String get chCont5 => '大陸の王';

  @override
  String get chCont5Desc => '大陸選手権で5回優勝する。';

  @override
  String get chContAll => '6大陸制覇';

  @override
  String get chContAllDesc => '全6連盟の大陸選手権を制する。';

  @override
  String get chTreble => '完全制覇';

  @override
  String get chTrebleDesc => '1つのキャリアで世界選手権、大陸選手権、ネーションズカップを制する。';

  @override
  String get chNations10 => '放浪者';

  @override
  String get chNations10Desc => '10の異なる国を指揮する。';

  @override
  String get chYears100 => '1世紀';

  @override
  String get chYears100Desc => '100年間指揮を執る。';

  @override
  String get chYears500 => '半千年紀';

  @override
  String get chYears500Desc => '500年間指揮を執る。';

  @override
  String get chYears1000 => '永遠';

  @override
  String get chYears1000Desc => '1000年間指揮を執る。';

  @override
  String get chGrandmaster => 'グランドマスター';

  @override
  String get chGrandmasterDesc => '世界選手権で3回、かつ大陸選手権で5回優勝する。';

  @override
  String get chUndefeated => 'アンタッチャブル';

  @override
  String get chUndefeatedDesc => '1敗もせずに世界選手権を制する。';

  @override
  String get chPerfectQual => '完璧な道のり';

  @override
  String get chPerfectQualDesc => '世界選手権予選を全勝で終える。';

  @override
  String get chMinnow => '小国の奇跡';

  @override
  String get chMinnowDesc => '世界ランク33位以下の国で世界選手権を制する。';

  @override
  String get chGrandTour => 'ホームでもアウェーでも';

  @override
  String get chGrandTourDesc => '開催国として世界選手権を制し、国外開催でも制する。';

  @override
  String get chUnbeaten25 => '鉄壁';

  @override
  String get chUnbeaten25Desc => '公式戦25試合無敗を達成する。';

  @override
  String get chGoals10k => 'ゴールマシーン';

  @override
  String get chGoals10kDesc => '通算10,000ゴールを記録する。';

  @override
  String get chCleanSheets500 => '要塞';

  @override
  String get chCleanSheets500Desc => '通算500回の完封を達成する。';

  @override
  String get chHatTricks25 => 'ハットトリックの常連';

  @override
  String get chHatTricks25Desc => '選手が通算25回のハットトリックを達成する。';

  @override
  String get chWinStreak25 => '止まらない';

  @override
  String get chWinStreak25Desc => '25連勝する。';

  @override
  String get chCont10 => '大陸の王朝';

  @override
  String get chCont10Desc => '大陸選手権で10回優勝する。';

  @override
  String get chPcWc => '連続王者';

  @override
  String chPcWcDesc(int count) {
    return 'このセーブで世界選手権を$count回制する。';
  }

  @override
  String get chPcMajors => 'トロフィーコレクター';

  @override
  String chPcMajorsDesc(int count) {
    return '主要タイトル（世界選手権、大陸選手権、ネーションズカップ）を$count回獲得する。';
  }

  @override
  String get chPcUnbeaten => '鉄の壁';

  @override
  String chPcUnbeatenDesc(int count) {
    return '公式戦$count試合無敗を達成する。';
  }

  @override
  String get chPcNations => '渡り鳥';

  @override
  String chPcNationsDesc(int count) {
    return '$countの異なる国を指揮する。';
  }

  @override
  String get chPcYears => '長い道のり';

  @override
  String chPcYearsDesc(int count) {
    return '$count年間指揮を執る。';
  }

  @override
  String achWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count勝',
      one: '1勝',
    );
    return '$_temp0';
  }

  @override
  String achWinsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count試合に勝利する。',
      one: '1試合に勝利する。',
    );
    return '$_temp0';
  }

  @override
  String achMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count試合',
    );
    return '$_temp0';
  }

  @override
  String achMatchesDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count試合を戦う。',
      one: '1試合を戦う。',
    );
    return '$_temp0';
  }

  @override
  String get achQualWc => '世界選手権出場';

  @override
  String get achQualWcDesc => '世界選手権の出場権を獲得する。';

  @override
  String get achQualCont => '大陸選手権出場';

  @override
  String get achQualContDesc => '大陸選手権の出場権を獲得する。';

  @override
  String get achTitleWc => '世界王者';

  @override
  String get achTitleWcDesc => '世界選手権で優勝する。';

  @override
  String get achTitleEuro => '欧州王者';

  @override
  String get achTitleEuroDesc => '欧州選手権で優勝する。';

  @override
  String get achTitleCopa => '南米王者';

  @override
  String get achTitleCopaDesc => '南米カップで優勝する。';

  @override
  String get achTitleAfcon => 'アフリカ王者';

  @override
  String get achTitleAfconDesc => 'アフリカ選手権で優勝する。';

  @override
  String get achTitleAsia => 'アジア王者';

  @override
  String get achTitleAsiaDesc => 'アジア選手権で優勝する。';

  @override
  String get achTitleConcacaf => '北米王者';

  @override
  String get achTitleConcacafDesc => '北米カップで優勝する。';

  @override
  String get achTitleOfc => 'オセアニア王者';

  @override
  String get achTitleOfcDesc => 'オセアニアカップで優勝する。';

  @override
  String get achTitleNations => 'ネーションズカップ王者';

  @override
  String get achTitleNationsDesc => 'ネーションズカップで優勝する。';

  @override
  String get achTitleClash => 'コンチネンタル・クラッシュ王者';

  @override
  String get achTitleClashDesc => 'コンチネンタル・クラッシュで優勝する。';

  @override
  String get achMarksman => '世界選手権のストライカー';

  @override
  String get achMarksmanDesc => 'メンバーの選手が世界選手権本大会で6ゴール以上を決める。';

  @override
  String get achSweep => '完全制覇';

  @override
  String get achSweepDesc => '1つのキャリアで世界選手権と大陸選手権の両タイトルを手にする。';

  @override
  String get achAllstar => '大会ベストイレブン';

  @override
  String get achAllstarDesc => '選手が世界選手権の大会ベストイレブンに選ばれる。';

  @override
  String get achGoldenboot => '得点王';

  @override
  String get achGoldenbootDesc => '自国の選手が大会得点王になる。';

  @override
  String get achDemolition => '粉砕';

  @override
  String get achDemolitionDesc => '5点差以上で勝利する。';

  @override
  String get achievementsNice => 'やった！';

  @override
  String get achievementsHardestTests => 'キャリア全体と多くの国にまたがる、監督にとって最も過酷な試練。';

  @override
  String get achievementsThisSave => 'このセーブ';

  @override
  String get achievementsBrutalBadge => '過酷';

  @override
  String get paywallGoPro => '無制限版へ';

  @override
  String get paywallOneTimeUnlock => '1回限りの購入。サブスクリプションなし。';

  @override
  String get paywallBenefitCarryOn =>
      'このセーブは中断したところからそのまま続きます。キャップも記録もライバル関係もすべてそのままです。';

  @override
  String get paywallBenefitNoAds =>
      '広告なし、課金アイテムなし、サブスクリプションなし。1回の支払いで今後のアップデートもすべて手に入ります。';

  @override
  String get paywallBenefitSaves =>
      'セーブ数は無制限。強豪国と小国を同時に率いて、同じゲームがどれほど違って見えるか確かめましょう。';

  @override
  String get paywallBenefitEndless =>
      'ここから先のすべてのサイクル。今日17歳の選手を選び、2034年に自分の目が正しかったか確かめましょう。';

  @override
  String get paywallUnlocked => '無制限版を解除しました。お楽しみください！';

  @override
  String get paywallContactingStore => 'ストアに接続中…';

  @override
  String paywallUnlockProPriced(String price) {
    return '無制限版を解除 · $price';
  }

  @override
  String get paywallRestorePurchases => '購入を復元';

  @override
  String get paywallStoreUnavailable => 'ストアを利用できません';

  @override
  String get paywallStoreUnavailableNote =>
      '価格を読み込めませんでした。接続を確認して、もう一度お試しください。';

  @override
  String get paywallTryAgain => '再試行';

  @override
  String get gateTitle => '最初のサイクルが終わりました';

  @override
  String get gateLead => '4年で1サイクル。自分が正しかったのかを知るには短すぎます。';

  @override
  String get gatePriceLead => '1回の支払いで永久に';

  @override
  String get gateBuy => '購入して続ける';

  @override
  String get gateExit => '終了';

  @override
  String get gateSaveTitle => 'このセーブにはProが必要です';

  @override
  String get gateSaveLead =>
      '無料サイクルを過ぎたセーブとProキャンペーンは、Proで続けられます。データは失われません。このセーブは中断したときのまま残っています。';

  @override
  String get careerSaveLockedNote => 'このセーブを続けるにはProが必要です';

  @override
  String get federationNaturalisation => '帰化';

  @override
  String federationNaturalisedTitle(String name) {
    return '$nameが帰化';
  }

  @override
  String federationNaturalisedBody(String name, String nation) {
    return '$nameは代表変更の手続きを終え、$nation代表としてプレーできるようになりました。メンバー選考から招集しましょう。';
  }

  @override
  String federationCouldNotLoadOffer(String error) {
    return '申し出を読み込めませんでした。\n$error';
  }

  @override
  String get federationContinue => '続ける';

  @override
  String get federationOfferToSwitchAllegiance => '代表変更の申し出';

  @override
  String federationPlayerMeta(String position, int age, String nation) {
    return '$position · $age歳 · 出身: $nation';
  }

  @override
  String federationNaturalisationBlurb(
    String name,
    String playerNation,
    String sourceNation,
  ) {
    return '$nameは$playerNationとのつながりがあり、帰化を望んでいます。受け入れれば招集可能に、断れば$sourceNationに残ります。';
  }

  @override
  String get federationDecline => '断る';

  @override
  String get federationNaturalise => '帰化させる';

  @override
  String get federationBudgetLater => '後で決める';

  @override
  String get federationSetYourBudget => '予算の設定';

  @override
  String federationCouldNotLoadFinances(String error) {
    return '財務情報を読み込めませんでした。\n$error';
  }

  @override
  String get federationSaveNotFound => 'セーブデータが見つかりません。';

  @override
  String get federationBudgetHeading => '協会予算';

  @override
  String federationDistributeBudget(String amount) {
    return 'サイクル開始にあたり、$amountを各部門に配分してください。賢く使いましょう。';
  }

  @override
  String federationOverBudget(String amount) {
    return '協会の資金を$amount超えています。配分を減らしてください';
  }

  @override
  String get federationAllocateFullBudget => 'サイクルを始めるには予算をすべて配分してください。';

  @override
  String get federationConfirming => '確定中…';

  @override
  String get federationConfirmBudget => '予算を確定';

  @override
  String get federationFinances => '財務';

  @override
  String get federationInvestmentUpdated => '投資を更新しました。';

  @override
  String get federationDevelopment => '協会の発展';

  @override
  String get federationProjectedAtSeasonEnd => 'シーズン終了時の見込み';

  @override
  String get federationCentralFunding => '中央分配金';

  @override
  String get federationPrizeMoneySoFar => 'これまでの賞金';

  @override
  String get federationCommercialReturn => '商業収入';

  @override
  String get federationThisSeasonLocked => '今シーズン（確定済み）';

  @override
  String get federationInvestForNextSeason => '来シーズンへの投資';

  @override
  String get federationNextSeasonImpact => '来シーズンへの影響';

  @override
  String get federationSaving => '保存中…';

  @override
  String get federationConfirmInvestment => '投資を確定';

  @override
  String get federationBalance => '協会の残高';

  @override
  String get federationCommittedToStaff => 'スタッフ給与に充当済み';

  @override
  String get federationFreeToSpend => '使用可能額';

  @override
  String get federationWagesNote => '給与はサイクル終了時に残高から差し引かれるため、この額は使えません。';

  @override
  String get federationInvestAtCeremony => '来シーズンへの投資はサイクル終了時のセレモニーで行います。';

  @override
  String federationLevelBadge(int level) {
    return 'Lv$level';
  }

  @override
  String get federationAcademyProspects => 'アカデミーの有望株';

  @override
  String federationPlusOverall(int value) {
    return '総合力 +$value';
  }

  @override
  String get federationInjuryRisk => '負傷リスク';

  @override
  String get federationNaturalisationChance => '帰化の確率';

  @override
  String get federationBoardPatience => '協会の忍耐';

  @override
  String get federationUnallocated => '未配分';

  @override
  String get nationsVitrineTitle => '代表の栄光';

  @override
  String nationsCouldNotLoad(String error) {
    return '国を読み込めませんでした。\n$error';
  }

  @override
  String get nationsNoNation => '国がありません。';

  @override
  String get nationsHonours => '栄誉';

  @override
  String get nationsRankingHistory => '世界ランキングの推移';

  @override
  String get nationsTopScorers => '歴代得点ランキング';

  @override
  String get nationsTitles => 'タイトル';

  @override
  String get nationsYourTeam => '自国';

  @override
  String get nationsWorld => '世界';

  @override
  String get nationsWorldCup => '世界選手権';

  @override
  String get nationsContinental => '大陸選手権';

  @override
  String nationsAppearances(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '出場$count回',
      one: '出場1回',
    );
    return '$_temp0';
  }

  @override
  String get nationsNotEnoughHistory => 'まだ十分な履歴がありません。1〜2サイクル後に確認してください。';

  @override
  String nationsBestRank(int rank) {
    return '最高: $rank位';
  }

  @override
  String nationsNowRank(int rank) {
    return '現在: $rank位';
  }

  @override
  String get nationsNoGoals => 'ゴールの記録はまだありません。';

  @override
  String get nationsGoalsAbbrev => '点';

  @override
  String get nationsHosts => '開催国';

  @override
  String get nationsSelectTitle => '代表チームを選択';

  @override
  String nationsCouldNotLoadNations(String error) {
    return '国一覧を読み込めませんでした。\n$error';
  }

  @override
  String get nationsNoMatch => '該当する国はありません。';

  @override
  String get nationsSelectHeading => '代表チームを選択';

  @override
  String get nationsSearchHint => '国名で検索…';

  @override
  String get nationsRank => 'ランク ';

  @override
  String get nationsPremium => 'プレミアム';

  @override
  String get nationsSelect => '選択';

  @override
  String get statsTeamRecords => 'チーム記録';

  @override
  String get statsRecordBook => '記録集';

  @override
  String statsCouldNotLoadStats(String error) {
    return '統計を読み込めませんでした。\n$error';
  }

  @override
  String get statsNoData => 'データがありません。';

  @override
  String get statsTopScorers => '得点ランキング';

  @override
  String get statsMostGamesPlayed => '最多出場';

  @override
  String get statsTeam => 'チーム';

  @override
  String get statsTopScorersShort => '得点';

  @override
  String get statsMostGames => '出場数';

  @override
  String get statsNoGoalsRecorded => 'ゴールの記録はまだありません。';

  @override
  String get statsUnknown => '不明';

  @override
  String get playerTitle => '選手';

  @override
  String playerLoadError(String error) {
    return '選手を読み込めませんでした。\n$error';
  }

  @override
  String get playerNotFound => '選手が見つかりません。';

  @override
  String get playerClub => '所属クラブ';

  @override
  String get playerClubRole => 'クラブでの立場';

  @override
  String get playerPosition => 'ポジション';

  @override
  String get playerPotential => '潜在能力';

  @override
  String get playerAge => '年齢';

  @override
  String get playerValue => '市場価値';

  @override
  String get clubFirstChoice => '毎週出場';

  @override
  String get clubRotation => '出たり出なかったり';

  @override
  String get clubFringe => 'ほぼ出番なし';

  @override
  String get clubFrozenOut => '出場機会なし';

  @override
  String clubAtClub(String club, String standing) {
    return '$club: $standing';
  }

  @override
  String yWinUpset0(String opponent, String score) {
    return '30年サッカーを見てきたけど、これは予想できなかった。$opponentに$scoreで勝利。';
  }

  @override
  String yWinUpset1(String opponent, String score) {
    return '$opponent相手に勝てるなんて誰も思ってなかった。$score。本当に誰も。';
  }

  @override
  String yWinUpset2(String opponent, String score) {
    return '$opponentに$score。近所中を叩き起こしてこい。';
  }

  @override
  String yWinUpset3(String opponent, String score) {
    return '孫に語り継ぐような夜だ。$opponentに$score。';
  }

  @override
  String yWinUpset4(String opponent, String score) {
    return '$opponentに$score。どうやったのかはともかく、勝ったものは勝った。';
  }

  @override
  String yWinUpset5(String opponent, String score) {
    return '下馬評では始まる前から終わってた。$opponentに$score、現実は違った。';
  }

  @override
  String yWinUpset6(String opponent, String score) {
    return '$opponentに$scoreで勝利。1年後には誰もこのスコアを信じないだろう。';
  }

  @override
  String yWinUpset7(String opponent, String score) {
    return '$opponentに$score。今は喜べ。そのあと日程表を見ろ。';
  }

  @override
  String yWinUpset8(String opponent, String score) {
    return '$opponentに$score。90分のうち80分は運に助けられた。';
  }

  @override
  String yWinUpset9(String opponent, String score) {
    return '$opponentに一晩勝ったところで、この1年は帳消しにならない。$score。';
  }

  @override
  String yWinUpset10(String opponent, String score) {
    return '$opponentに$scoreで勝って、どうせ「復活の兆し」とか言われるんだろう。違うから。';
  }

  @override
  String yWinUpset11(String opponent, String score) {
    return '$opponentに$score。素晴らしい。大事な試合でもう一度聞いてくれ。';
  }

  @override
  String yWinRoutine0(String opponent, String score) {
    return '$opponentに$scoreで勝利。順当そのもの。それがまた気持ちいい。';
  }

  @override
  String yWinRoutine1(String opponent, String score) {
    return '$opponentに$score。容赦なし。もちろん褒め言葉だ。';
  }

  @override
  String yWinRoutine2(String opponent, String score) {
    return '$opponentに$score。危なげなし、不安なし、文句なし。';
  }

  @override
  String yWinRoutine3(String opponent, String score) {
    return '$opponentに手堅く$score。いいチームは静かな日でもこういう勝ち方をする。';
  }

  @override
  String yWinRoutine4(String opponent, String score) {
    return '$opponentに$score。仕事は済んだ。収穫はゼロ。';
  }

  @override
  String yWinRoutine5(String opponent, String score) {
    return '$opponentに$scoreで勝利。勝つべき試合に勝った。';
  }

  @override
  String yWinRoutine6(String opponent, String score) {
    return '$opponentにプロらしく$score。次。';
  }

  @override
  String yWinRoutine7(String opponent, String score) {
    return '$opponentを$scoreで片付けた。記録して次へ。';
  }

  @override
  String yWinRoutine8(String opponent, String score) {
    return '$opponentに$scoreで、拍手しろってか。あの相手に勝っただけで。';
  }

  @override
  String yWinRoutine9(String opponent, String score) {
    return '$opponentに$scoreで勝った関係者の皆さん、まあ、お疲れさま。';
  }

  @override
  String yWinRoutine10(String opponent, String score) {
    return '$opponentに$score。ああいう相手に勝つのは最低ライン。偉業じゃない。';
  }

  @override
  String yWinRoutine11(String opponent, String score) {
    return '$opponentに$scoreで勝ったけど、見ていてしんどかった。';
  }

  @override
  String yWinTight0(String opponent, String score) {
    return '$opponentに$score。1分1秒すべてで勝ち取った勝利。';
  }

  @override
  String yWinTight1(String opponent, String score) {
    return '根性で勝った。$opponentに$score。';
  }

  @override
  String yWinTight2(String opponent, String score) {
    return '$opponentに$score、苦しみながらの勝利。こういう勝ち方こそ後に残る。';
  }

  @override
  String yWinTight3(String opponent, String score) {
    return '$opponentに$score。こういう試合を勝てるチームが、6月まで生き残る。';
  }

  @override
  String yWinTight4(String opponent, String score) {
    return 'ハラハラして、泥臭くて、でも勝ち。$opponentに$score。';
  }

  @override
  String yWinTight5(String opponent, String score) {
    return '$opponentに$scoreで勝利。勝点3をもらって、二度と見返さない。';
  }

  @override
  String yWinTight6(String opponent, String score) {
    return '$score。$opponentには一歩ごとに汗をかかされた。';
  }

  @override
  String yWinTight7(String opponent, String score) {
    return '$opponentに$score。美しくはない。でも勝ちは勝ち。';
  }

  @override
  String yWinTight8(String opponent, String score) {
    return '$opponentに$score。わざわざ10倍難しくしてくれた。';
  }

  @override
  String yWinTight9(String opponent, String score) {
    return '$opponent相手に必死で逃げ切るようじゃだめだ。$score。';
  }

  @override
  String yWinTight10(String opponent, String score) {
    return '$opponentに$score。勝ちはしたが、自分たちについていいことは何もわからなかった。';
  }

  @override
  String yWinTight11(String opponent, String score) {
    return '$opponentに$score。スコアほどの内容じゃなかった。';
  }

  @override
  String yDrew0(String opponent, String score) {
    return '$opponentと$scoreで勝点1。受け入れて前を向こう。';
  }

  @override
  String yDrew1(String opponent, String score) {
    return '$opponentと$score。もっとひどい午後はいくらでもある。';
  }

  @override
  String yDrew2(String opponent, String score) {
    return '$opponentを$scoreに抑えた。何でもかんでも物語にする必要はない。';
  }

  @override
  String yDrew3(String opponent, String score) {
    return '$opponentと$score。勝点1は勝点1。順位表は中身を問わない。';
  }

  @override
  String yDrew4(String opponent, String score) {
    return '$opponentと$score。勝点2を落としたか、1を拾ったか。気分次第で。';
  }

  @override
  String yDrew5(String opponent, String score) {
    return '$opponentと$scoreの引き分け。誰も喜ばず、誰も激怒せず。';
  }

  @override
  String yDrew6(String opponent, String score) {
    return '$opponentと$score。今年いちばん記憶に残らない90分。';
  }

  @override
  String yDrew7(String opponent, String score) {
    return '$opponentと$scoreで痛み分け。さあ次。';
  }

  @override
  String yDrew8(String opponent, String score) {
    return '$opponentと$score。こういう引き分けで、予選は静かに終わっていく。';
  }

  @override
  String yDrew9(String opponent, String score) {
    return '$opponent相手に勝点2を捨てた。$score。他に言いようがない。';
  }

  @override
  String yDrew10(String opponent, String score) {
    return '$opponentと$score。90分あったのに、何をすればいいかわかってなかった。';
  }

  @override
  String yDrew11(String opponent, String score) {
    return '$opponentと$score。誰も覚えていないのに、全員がツケを払うことになる。';
  }

  @override
  String yLost0(String opponent, String score) {
    return '$opponentに$scoreで敗戦。こういうこともある。';
  }

  @override
  String yLost1(String opponent, String score) {
    return '$opponentに$score。誰かを吊し上げるほどじゃない。次へ。';
  }

  @override
  String yLost2(String opponent, String score) {
    return '$opponentに$scoreで負けたが、全力は尽くした。それでも足りない日はある。';
  }

  @override
  String yLost3(String opponent, String score) {
    return '$opponentに$score。顔を上げろ。このチームにはまだ余力がある。';
  }

  @override
  String yLost4(String opponent, String score) {
    return '$opponentに$score。完全に力負け、反論の余地なし。';
  }

  @override
  String yLost5(String opponent, String score) {
    return '$opponentに$scoreで敗戦。立て直せ。';
  }

  @override
  String yLost6(String opponent, String score) {
    return '$opponentに$score。恥ではないが、物足りない。';
  }

  @override
  String yLost7(String opponent, String score) {
    return '$opponentに$scoreで敗戦。何か学ばなければ無駄な試合だ。';
  }

  @override
  String yLost8(String opponent, String score) {
    return '$opponentに$score。一発も有効打を入れられなかった。';
  }

  @override
  String yLost9(String opponent, String score) {
    return '$opponentに$scoreで負けた。同じ問題、同じ月、また同じ言い訳が来る。';
  }

  @override
  String yLost10(String opponent, String score) {
    return '$opponentに$score。いつまで「運が悪かった」で済ませるつもりだ？';
  }

  @override
  String yLost11(String opponent, String score) {
    return '$opponentに$scoreで敗戦。誰かが責任を取るべき結果だ。';
  }

  @override
  String yLostBadly0(String opponent, String score) {
    return '$opponentに$score。ひどい夜が一つあっただけ。評価は予選全体でしよう。';
  }

  @override
  String yLostBadly1(String opponent, String score) {
    return '$opponentに$score。誰よりもこれを望んでいなかったのは選手たちだ。';
  }

  @override
  String yLostBadly2(String opponent, String score) {
    return '$opponentに$score。醜い。でもこれが本当のこのチームじゃない。';
  }

  @override
  String yLostBadly3(String opponent, String score) {
    return '$opponentに$score、忘れたい試合。次はきっとやり返してくれる。';
  }

  @override
  String yLostBadly4(String opponent, String score) {
    return '$score。$opponentに。言葉が出ない。言葉で金をもらってる身なのに。';
  }

  @override
  String yLostBadly5(String opponent, String score) {
    return '$opponentに$score。誰かが責任を取らなきゃならない。';
  }

  @override
  String yLostBadly6(String opponent, String score) {
    return '$opponentに$score。記録からも記憶からも消してほしい。';
  }

  @override
  String yLostBadly7(String opponent, String score) {
    return '$opponentに$scoreで惨敗。このスコアはどう言い繕っても無理。';
  }

  @override
  String yLostBadly8(String opponent, String score) {
    return '$opponentへの敗戦じゃない。白旗だ。$score。';
  }

  @override
  String yLostBadly9(String opponent, String score) {
    return '$score。$opponentに。金を払ってこれを見に来た人がいるんだぞ。';
  }

  @override
  String yLostBadly10(String opponent, String score) {
    return '$opponentに$score。これで何も変わらないなら、もう何も変わらない。';
  }

  @override
  String yLostBadly11(String opponent, String score) {
    return 'このチームの屈辱は前にも見たが、$opponentに$scoreは史上最低だ。';
  }

  @override
  String yWinUpset12(String opponent, String score) {
    return '$opponentに$scoreで勝利。日付をメモしておけ、どこにいたか聞かれるぞ。';
  }

  @override
  String yWinUpset13(String opponent, String score) {
    return 'ロッカールームの外では誰も信じてなかった。$opponentに$score。誇らしいなんて言葉じゃ足りない。';
  }

  @override
  String yWinUpset14(String opponent, String score) {
    return '$opponentに$score！全員が最後の一滴まで走り切った。';
  }

  @override
  String yWinUpset15(String opponent, String score) {
    return 'ジャイアントキリング。$opponent、$score。これがあるから通い続けるんだ。';
  }

  @override
  String yWinUpset16(String opponent, String score) {
    return '$opponentに$score。下馬評が窓から飛んでいった。';
  }

  @override
  String yWinUpset17(String opponent, String score) {
    return '大本命は$opponent。最終スコア、$scoreでこっちの勝ち。';
  }

  @override
  String yWinUpset18(String opponent, String score) {
    return '今年最大級の番狂わせ。$opponentに$score。';
  }

  @override
  String yWinUpset19(String opponent, String score) {
    return '$opponent $score。誰も予想してなかったし、誰もうまく説明できない。';
  }

  @override
  String yWinUpset20(String opponent, String score) {
    return '$opponentに$score。最高だ。これで今年の残りがどれだけひどかったか、みんな忘れるんだろう。';
  }

  @override
  String yWinUpset21(String opponent, String score) {
    return '$opponentに$scoreで、もう便乗組で満員だ。こっちは空席だらけの頃から乗ってる。';
  }

  @override
  String yWinUpset22(String opponent, String score) {
    return '$opponent $score。見事だ。それでもどうせ無駄にする方法を見つけるんだろうな。';
  }

  @override
  String yWinUpset23(String opponent, String score) {
    return '$opponent相手に大きな夜、$score。燕一羽で夏にはならない。';
  }

  @override
  String yLostBadly12(String opponent, String score) {
    return '$opponentに$score。大事だから痛いんだ。それでも応援しよう。';
  }

  @override
  String yLostBadly13(String opponent, String score) {
    return '$opponent相手に忘れたい夜、$score。一番悔しいのは選手たちだ。';
  }

  @override
  String yLostBadly14(String opponent, String score) {
    return '$opponent $score。顔を上げろ。チームの真価はここからどう応えるかだ。';
  }

  @override
  String yLostBadly15(String opponent, String score) {
    return '$opponentに$score。ひどい、確かに。世界の終わり、ではない。';
  }

  @override
  String yLostBadly16(String opponent, String score) {
    return '$opponentに$score。何年も語られる結果になる、悪い意味で。';
  }

  @override
  String yLostBadly17(String opponent, String score) {
    return '$opponentの勝ち、$score。これを見たら、次に驚くやつはいないはずだ。';
  }

  @override
  String yLostBadly18(String opponent, String score) {
    return 'ここ何年かで最悪の夜のひとつ。$opponentに$score。';
  }

  @override
  String yLostBadly19(String opponent, String score) {
    return '$opponent $score。疑問の声は上がるし、上がるべきだ。';
  }

  @override
  String yLostBadly20(String opponent, String score) {
    return '$opponentに$score。恥ずかしいなんてもんじゃない。';
  }

  @override
  String yLostBadly21(String opponent, String score) {
    return '$opponentに$scoreで完敗。最後に出るやつは電気を消してくれ。';
  }

  @override
  String yLostBadly22(String opponent, String score) {
    return '$opponent $score。もう驚かない自分が怖い。';
  }

  @override
  String yLostBadly23(String opponent, String score) {
    return '$score。$opponent。上の誰かは今夜、履歴書を書き直したほうがいい。';
  }

  @override
  String yWinRout0(String opponent, String score) {
    return '$opponentに$score！こんなサッカーなら国中が笑顔になる。';
  }

  @override
  String yWinRout1(String opponent, String score) {
    return '$opponentを$scoreで粉砕。なんてパフォーマンスだ。';
  }

  @override
  String yWinRout2(String opponent, String score) {
    return '$score。$opponent相手に。今夜は何もかもうまくいった。';
  }

  @override
  String yWinRout3(String opponent, String score) {
    return '$opponentを$scoreで解体。ハイライトは保存しとけ、あとで見返したくなる。';
  }

  @override
  String yWinRout4(String opponent, String score) {
    return '$opponent $score。自分たちのサッカーを楽しんでいるチームだ。';
  }

  @override
  String yWinRout5(String opponent, String score) {
    return '$opponentに$score、もっと取れてもおかしくなかった。最高。';
  }

  @override
  String yWinRout6(String opponent, String score) {
    return '$opponentに$score。二度見するスコアだ。';
  }

  @override
  String yWinRout7(String opponent, String score) {
    return '$opponentに$scoreで勝利。最初の30分で勝負は決まった。';
  }

  @override
  String yWinRout8(String opponent, String score) {
    return '最終スコア、$opponentに$score。久しぶりの文句なしの大勝だ。';
  }

  @override
  String yWinRout9(String opponent, String score) {
    return '$opponent $score。片方はサッカーをしに来て、もう片方はバスから降りもしなかった。';
  }

  @override
  String yWinRout10(String opponent, String score) {
    return '$score。$opponentは何ひとつ答えを持っていなかった。';
  }

  @override
  String yWinRout11(String opponent, String score) {
    return '大勝。$opponentに$score。';
  }

  @override
  String yWinRout12(String opponent, String score) {
    return '$opponentに$score。いいけど、物差しになる相手じゃない。';
  }

  @override
  String yWinRout13(String opponent, String score) {
    return '$opponentに$score。強い相手にこれをやったら起こしてくれ。';
  }

  @override
  String yWinRout14(String opponent, String score) {
    return '$opponent $score。楽しいけど、こうやって輝いて何も勝ち取れなかったチームを何度も見てきた。';
  }

  @override
  String yWinRout15(String opponent, String score) {
    return '$scoreで、またみんな天才扱いだ。相手は$opponentだったけどな。';
  }

  @override
  String yWinRout16(String opponent, String score) {
    return '$opponentに$score。浮かれるな、これで証明されることはほとんどない。';
  }

  @override
  String yWinRout17(String opponent, String score) {
    return '$opponent $score。楽しめ。そして前回浮かれたときどうなったか思い出せ。';
  }

  @override
  String yWinShootout0(String opponent) {
    return '$opponentにPK戦で勝ち抜け！全員、鋼の心臓だ。';
  }

  @override
  String yWinShootout1(String opponent) {
    return '$opponentとのPK戦、みんな落ち着いてた。知らない人とハグしよう。';
  }

  @override
  String yWinShootout2(String opponent) {
    return '$opponentとのPK戦に勝利。心臓がもたない。';
  }

  @override
  String yWinShootout3(String opponent) {
    return '$opponentにPK戦で勝利。次のラウンドへ。';
  }

  @override
  String yWinShootout4(String opponent) {
    return '$opponent戦はPKスポットで決着、こっちの方が多く決めた。';
  }

  @override
  String yWinShootout5(String opponent) {
    return '$opponentとのPK戦を制した。一番苦しい道だけど、勝ち抜け。';
  }

  @override
  String yWinShootout6(String opponent) {
    return '$opponentにPK戦で勝ち抜け。くじには当たった、内容は忘れよう。';
  }

  @override
  String yWinShootout7(String opponent) {
    return 'あの内容で$opponentにPK勝ち？運だよ、みんな分かってる。';
  }

  @override
  String yWinShootout8(String opponent) {
    return '$opponentにPK戦で勝ち抜け。そこまでもつれる必要はなかった。';
  }

  @override
  String yKnockoutWin0(String opponent, String score) {
    return '勝ち抜け。$opponentに$score、夢はまだ続く。';
  }

  @override
  String yKnockoutWin1(String opponent, String score) {
    return 'ノックアウトで勝利：$opponentに$score。国中が信じ始めていい。';
  }

  @override
  String yKnockoutWin2(String opponent, String score) {
    return '$opponentに$scoreで次のラウンドへ。なんて夜だ。';
  }

  @override
  String yKnockoutWin3(String opponent, String score) {
    return '$opponentは帰国、$score。前へ。';
  }

  @override
  String yKnockoutWin4(String opponent, String score) {
    return 'ノックアウト：$opponentに$score。次のラウンド進出決定。';
  }

  @override
  String yKnockoutWin5(String opponent, String score) {
    return '勝ち抜け：$opponentに$score。';
  }

  @override
  String yKnockoutWin6(String opponent, String score) {
    return '$opponent敗退、$score。次のラウンドが待っている。';
  }

  @override
  String yKnockoutWin7(String opponent, String score) {
    return '$opponentに$scoreで勝利。ノックアウトでは内容なんて誰も聞かない。';
  }

  @override
  String yKnockoutWin8(String opponent, String score) {
    return '$opponentを下して勝ち抜け、$score。次の相手はここまで優しくない。';
  }

  @override
  String yKnockoutWin9(String opponent, String score) {
    return '$opponentに$scoreで勝ち抜けには十分。次はもっとずっと必要になる。';
  }

  @override
  String yKnockoutWin10(String opponent, String score) {
    return '$opponent敗退、$score。勝ったというより生き延びた。';
  }

  @override
  String yKnockoutWin11(String opponent, String score) {
    return '$opponentに$scoreで次のラウンドへ。どうやってかは聞くな。';
  }

  @override
  String yUpsetGap0(String opponent, String gap) {
    return 'ランキングで$gap位の差、それでも$opponentに勝った。見事だ。';
  }

  @override
  String yUpsetGap1(String opponent, String gap) {
    return '$opponent：こっちより$gap位上。それでも勝った。サッカーは素晴らしい。';
  }

  @override
  String yUpsetGap2(String opponent, String gap) {
    return 'ランキング差：$gap。結果：$opponentに勝利。信じることをやめるな。';
  }

  @override
  String yUpsetGap3(String opponent, String gap) {
    return 'キックオフ前のランキング差：$gap。それでも$opponentに勝利。';
  }

  @override
  String yUpsetGap4(String opponent, String gap) {
    return '世界ランキングで$opponentは$gap位上だった。今夜は違った。';
  }

  @override
  String yUpsetGap5(String opponent, String gap) {
    return '番狂わせ指数：両チームのランキング差$gap。$opponent相手に勝利。';
  }

  @override
  String yUpsetGap6(String opponent, String gap) {
    return '$opponentとの間にはランキングで$gap位の差があった。一晩でその差は埋まらない。';
  }

  @override
  String yUpsetGap7(String opponent, String gap) {
    return '$opponent：$gap位上、それで負けた。ランキングはほとんど気づかないだろう。';
  }

  @override
  String yUpsetGap8(String gap) {
    return 'ランキング差：$gap。次に格下に負けたとき、この数字を思い出せ。';
  }

  @override
  String yEatWords0(String opponent) {
    return 'このチームは終わったと書いた。間違っていた。間違えてこれほど嬉しかったことはない。$opponentに勝利。';
  }

  @override
  String yEatWords1(String opponent) {
    return '謙虚さを一皿、大盛りで頼む。$opponentへの勝利は見事だった。';
  }

  @override
  String yEatWords2(String opponent) {
    return 'もう何も残っていないと言った。たっぷり残っていた。$opponent戦、全員見事だった。';
  }

  @override
  String yEatWords3(String opponent) {
    return '記録のために言っておく。$opponentへのこの勝利は読めなかった。認めるべきは認める。';
  }

  @override
  String yEatWords4(String opponent) {
    return '分かったよ。化けの皮が剥がれると言った。$opponentには剥がせなかった。';
  }

  @override
  String yEatWords5(String opponent) {
    return '今夜はこのチームについての発言を撤回する。$opponentへの勝利にはその価値がある。';
  }

  @override
  String yEatWords6(String opponent) {
    return 'ああ、終わったと言ったさ。$opponentへの一勝で、まだ俺が間違っていたことにはならない。';
  }

  @override
  String yEatWords7(String opponent) {
    return '$opponent戦のあと発言を撤回しろと言われている。するよ、ゆっくりとな。レシートは取っておく。';
  }

  @override
  String yEatWords8(String opponent) {
    return '$opponentへの勝利は見事だった。このチームへの疑念は消えていないが。';
  }

  @override
  String yAwayFansWin0(String nation, String score) {
    return '$nationはあっぱれ。$score、文句なしに妥当な結果だ。';
  }

  @override
  String yAwayFansWin1(String nation, String score) {
    return '言うのはつらいが、今夜は$nationの方が上だった。$score。おめでとう。';
  }

  @override
  String yAwayFansWin2(String nation, String score) {
    return '$score。$nationに脱帽、向こうの方が勝ちたがっていた。';
  }

  @override
  String yAwayFansWin3(String nation, String score) {
    return '$nationに$scoreで負けた。何て言えばいいか分からない。';
  }

  @override
  String yAwayFansWin4(String nation, String score) {
    return '$nation $score。うちの連中は恥を知るべきだ。';
  }

  @override
  String yAwayFansWin5(String nation, String score) {
    return '$nationに$score。誰かどうしてこうなったか説明してくれ。';
  }

  @override
  String yAwayFansWin6(String nation, String score) {
    return '$nationに$scoreで負けるなんて。一生忘れられない。';
  }

  @override
  String yAwayFansWin7(String nation, String score) {
    return '$nationに$score。運だ。ただの運だ。';
  }

  @override
  String yAwayFansWin8(String nation, String score) {
    return 'この$scoreのせいで、$nationのファンは何年もうっとうしくなる。ありがとうよ。';
  }

  @override
  String yNeutralWin0(String nation, String opponent, String score) {
    return '$nation $score $opponent。サッカーにとって最高だ。だからこのスポーツが好きなんだ。';
  }

  @override
  String yNeutralWin1(String nation, String opponent, String score) {
    return '$nationにとってなんて結果だ。$opponentに$score。サッカーの醍醐味。';
  }

  @override
  String yNeutralWin2(String nation, String opponent, String score) {
    return '今夜、中立のファンはみんな$nationの味方だ。$opponentに$score！';
  }

  @override
  String yNeutralWin3(String nation, String opponent, String score) {
    return '今節の結果：$nation $score $opponent。';
  }

  @override
  String yNeutralWin4(String nation, String opponent, String score) {
    return '$nation $score $opponent。誰の予想にもなかった。';
  }

  @override
  String yNeutralWin5(String nation, String opponent, String score) {
    return '大きな結果：$nation $score $opponent。ランキングが動く。';
  }

  @override
  String yNeutralWin6(String nation, String opponent, String score) {
    return '$nation $score $opponent。面白いけど、もう一度できるか見ものだ。';
  }

  @override
  String yNeutralWin7(String nation, String opponent, String score) {
    return '$nation $score $opponent。$nationが勝ったのか、$opponentが負けたのか。';
  }

  @override
  String yNeutralWin8(String nation, String opponent, String score) {
    return '番狂わせ：$nation $score $opponent。過剰反応の嵐に備えよ。';
  }

  @override
  String yScorerHero0(String name, String opponent) {
    return '$opponent戦の$name。子どもに彼の名前をつける人が出てくる。';
  }

  @override
  String yScorerHero1(String name, String opponent) {
    return '$nameの銅像を建てよう。今夜の$opponent戦、彼がすべてだった。';
  }

  @override
  String yScorerHero2(String name, String opponent) {
    return '$name、最高だ。$opponent戦のこの夜を忘れるな。';
  }

  @override
  String yScorerHero3(String name, String opponent) {
    return '$opponent戦を決めたのは$name。マン・オブ・ザ・マッチ、議論の余地なし。';
  }

  @override
  String yScorerHero4(String name, String opponent) {
    return '$opponent戦は$nameの夜だった。';
  }

  @override
  String yScorerHero5(String name, String opponent) {
    return 'ここぞという場面で$nameが現れた。$opponent戦で。';
  }

  @override
  String yScorerHero6(String name, String opponent) {
    return '$opponent戦の$nameは圧巻だった。これを毎週頼む。';
  }

  @override
  String yScorerHero7(String name, String opponent) {
    return '$opponent戦、$nameがチームを救った。ほかはあまり助けにならなかった。';
  }

  @override
  String yScorerHero8(String name, String opponent) {
    return '$nameがいなければ、$opponent戦はまるで違う夜になっていた。';
  }

  @override
  String yLostShock0(String opponent, String score) {
    return '$opponentに$score。事故だ。誰にでも一度はある。';
  }

  @override
  String yLostShock1(String opponent, String score) {
    return '$opponentに$scoreで敗戦。切り替えよう、戦いはまだ終わってない。';
  }

  @override
  String yLostShock2(String opponent, String score) {
    return '$opponent $score。痛いが、一つの結果でこのチームは決まらない。';
  }

  @override
  String yLostShock3(String opponent, String score) {
    return '$opponentに$score。仕事でついてない日。次へ。';
  }

  @override
  String yLostShock4(String opponent, String score) {
    return '$opponentに敗戦、$score。誰も予想してなかった。';
  }

  @override
  String yLostShock5(String opponent, String score) {
    return '$opponent $score。意味が分からない夜のひとつ。';
  }

  @override
  String yLostShock6(String opponent, String score) {
    return '$opponentに$score。語り継がれる敗戦だ。';
  }

  @override
  String yLostShock7(String opponent, String score) {
    return '$opponentに敗れた、$score。どう見ても大番狂わせだ。';
  }

  @override
  String yLostShock8(String opponent, String score) {
    return '$opponentに$score。$opponentにだぞ！ありえない。';
  }

  @override
  String yLostShock9(String opponent, String score) {
    return '$opponentに$scoreで敗戦。言い訳じゃなく説明がほしい。';
  }

  @override
  String yLostShock10(String opponent, String score) {
    return '$opponent $score。国の恥だ、比喩じゃなく。';
  }

  @override
  String yLostShock11(String opponent, String score) {
    return '$opponentに$score。上の人たちはどうしてまだその椅子に座っていられるんだ？';
  }

  @override
  String yLostRout0(String opponent, String score) {
    return '$opponentに$score。相手はトップチームだ。学ぼう。';
  }

  @override
  String yLostRout1(String opponent, String score) {
    return '$opponentに力の差を見せつけられた、$score。最強相手に負けるのは恥じゃない。';
  }

  @override
  String yLostRout2(String opponent, String score) {
    return '$opponent $score。教訓だ。教訓が人を成長させる。';
  }

  @override
  String yLostRout3(String opponent, String score) {
    return '$opponentに$score。痛いが、向こうは一段上だ。';
  }

  @override
  String yLostRout4(String opponent, String score) {
    return '$opponentの勝ち、$score。差は本物で、今やみんなが見た。';
  }

  @override
  String yLostRout5(String opponent, String score) {
    return '$opponentに$score。ただの完敗だ。';
  }

  @override
  String yLostRout6(String opponent, String score) {
    return '$opponent $score。強い方が勝った、スコアがそう言っている。';
  }

  @override
  String yLostRout7(String opponent, String score) {
    return '$opponentに$scoreで敗戦。恥ではないが、試合にもなっていなかった。';
  }

  @override
  String yLostRout8(String opponent, String score) {
    return '$opponentに$score。相手が上だろうと、こんな負け方はダメだ。';
  }

  @override
  String yLostRout9(String opponent, String score) {
    return '$opponent $score。そもそも戦おうとしたのか？';
  }

  @override
  String yLostRout10(String opponent, String score) {
    return '$score。$opponent相手に。屠所の羊だ。';
  }

  @override
  String yLostRout11(String opponent, String score) {
    return '$opponentに$scoreで負けて、誰も気にしてる様子がなかった。';
  }

  @override
  String yLostShootout0(String opponent) {
    return '$opponentにPK戦で敗退。全部出し切った。誇りに思う。';
  }

  @override
  String yLostShootout1(String opponent) {
    return '$opponentとのPK戦。最も残酷な負け方だ。顔を上げろ。';
  }

  @override
  String yLostShootout2(String opponent) {
    return '$opponentとのPK戦に敗れた。誰もこんな目に遭うべきじゃない。';
  }

  @override
  String yLostShootout3(String opponent) {
    return '$opponentにPK戦で敗退。PKスポットが決めた。';
  }

  @override
  String yLostShootout4(String opponent) {
    return '$opponentがPK戦で勝ち抜け。こっちの大会はここで終わり。';
  }

  @override
  String yLostShootout5(String opponent) {
    return '$opponentとのPK戦に敗れた。またPKだ。';
  }

  @override
  String yLostShootout6(String opponent) {
    return '$opponentにPK戦で敗退。そもそも練習してるのか？';
  }

  @override
  String yLostShootout7(String opponent) {
    return '$opponentにPK戦で敗れた。もっと早く決着をつけるべきだった。';
  }

  @override
  String yLostShootout8(String opponent) {
    return '$opponentとのPK戦、そして負けた。そりゃそうだ。';
  }

  @override
  String yKnockoutLoss0(String opponent, String score) {
    return '敗退。$opponentに$score。誇れる旅がここで終わる。';
  }

  @override
  String yKnockoutLoss1(String opponent, String score) {
    return '$opponentに敗退、$score。思い出をありがとう。';
  }

  @override
  String yKnockoutLoss2(String opponent, String score) {
    return '$opponentに$score。旅は終わった、でもなんて旅だった。';
  }

  @override
  String yKnockoutLoss3(String opponent, String score) {
    return '敗退：$opponentに$score。胸を張れ。';
  }

  @override
  String yKnockoutLoss4(String opponent, String score) {
    return '終戦：$opponentに$score。';
  }

  @override
  String yKnockoutLoss5(String opponent, String score) {
    return '敗退：$opponentに$score。';
  }

  @override
  String yKnockoutLoss6(String opponent, String score) {
    return '$opponentが勝ち抜け、$score。こっちの大会は終わった。';
  }

  @override
  String yKnockoutLoss7(String opponent, String score) {
    return '$opponentに敗退、$score。検証が今から始まる。';
  }

  @override
  String yKnockoutLoss8(String opponent, String score) {
    return '敗退。$opponentに$score。大会が変わっても、結末は同じ。';
  }

  @override
  String yKnockoutLoss9(String opponent, String score) {
    return '$opponentに$scoreで帰国。誰も驚いていない。';
  }

  @override
  String yKnockoutLoss10(String opponent, String score) {
    return '$opponentに敗退、$score。朝までに言い訳が出てくるぞ。';
  }

  @override
  String yKnockoutLoss11(String opponent, String score) {
    return '$opponent $score。敗退。ほかの結末になりそうな瞬間は一度もなかった。';
  }

  @override
  String yAwayFansGloat0(String nation, String score) {
    return '$nationに$score。敬意を。彼らは強くなって戻ってくる。';
  }

  @override
  String yAwayFansGloat1(String nation, String score) {
    return 'こっちにはいい勝利、$score。$nationには悪い日だ。ファンには同情する。';
  }

  @override
  String yAwayFansGloat2(String nation, String score) {
    return '$score。$nationにとってひどい夜で、こっちはそれを逃さなかった。それがサッカーだ。';
  }

  @override
  String yAwayFansGloat3(String nation, String score) {
    return '$nationに$score！誰が予想した？少なくとも向こうはしてない。';
  }

  @override
  String yAwayFansGloat4(String nation, String score) {
    return '$nationに$scoreで勝利。誰か向こうのファンの様子を見てきてくれ。';
  }

  @override
  String yAwayFansGloat5(String nation, String score) {
    return '$nation $score。これはアルバム行きだ。';
  }

  @override
  String yAwayFansGloat6(String nation, String score) {
    return '$nationに$score。それで自分たちを強豪だと思ってるんだから。';
  }

  @override
  String yAwayFansGloat7(String nation, String score) {
    return 'うちに$scoreで負けるなんて想像してみろ。$nationに聞け、今なら分かる。';
  }

  @override
  String yAwayFansGloat8(String nation, String score) {
    return '$nation、$score。気をつけて帰れよ。';
  }

  @override
  String yNeutralLoss0(String nation, String opponent, String score) {
    return '$nation $score $opponent。$opponentにとっては最高の夜、$nationにはつらい夜。';
  }

  @override
  String yNeutralLoss1(String nation, String opponent, String score) {
    return '$opponentに$scoreの$nation、ファンにはエールを。きっと立ち直る。';
  }

  @override
  String yNeutralLoss2(String nation, String opponent, String score) {
    return '$nation $score $opponent。どんな強豪にもこういう夜はある。';
  }

  @override
  String yNeutralLoss3(String nation, String opponent, String score) {
    return '今節の衝撃：$nation $score $opponent。';
  }

  @override
  String yNeutralLoss4(String nation, String opponent, String score) {
    return '$nation $score $opponent。誰も予想してなかった。';
  }

  @override
  String yNeutralLoss5(String nation, String opponent, String score) {
    return '今日の結果：$nation $score $opponent。$nationには疑問が突きつけられる。';
  }

  @override
  String yNeutralLoss6(String nation, String opponent, String score) {
    return '$nation $score $opponent。見ていた人なら分かる、偶然じゃない。';
  }

  @override
  String yNeutralLoss7(String nation, String opponent, String score) {
    return '$nation $score $opponent。あそこの誰かは説明することが山ほどある。';
  }

  @override
  String yNeutralLoss8(String nation, String opponent, String score) {
    return '$nation $score $opponent。看板は大きいが、内容は小さい。';
  }

  @override
  String yDownGap0(String opponent, String gap) {
    return '$opponent：こっちより$gap位下。そういうこともある。次へ。';
  }

  @override
  String yDownGap1(String gap) {
    return 'ランキング差：こっちが$gap位上。サッカーはランキングを読まない。';
  }

  @override
  String yDownGap2(String opponent, String gap) {
    return '紙の上では$opponentと$gap位の差。今夜のピッチではなかった。';
  }

  @override
  String yDownGap3(String opponent, String gap) {
    return 'キックオフ前のランキング差：こっちが$gap位上。それでも$opponentに負けた。';
  }

  @override
  String yDownGap4(String opponent, String gap) {
    return '世界ランキングで$opponentは$gap位下だった。結果：敗戦。';
  }

  @override
  String yDownGap5(String opponent, String gap) {
    return '番狂わせ指数：ランキング差$gap、逆方向に。$opponent戦。';
  }

  @override
  String yDownGap6(String opponent, String gap) {
    return 'ランキングで$opponentより$gap位上。負けた。説明してくれ。';
  }

  @override
  String yDownGap7(String gap) {
    return '$gap位下のチームに負けた。この数字をよく噛みしめろ。';
  }

  @override
  String yDownGap8(String opponent, String gap) {
    return 'ランキング差：$gap。$opponentに敗戦。誰か日数を数え始めたほうがいい。';
  }

  @override
  String yDrewHeroic0(String opponent, String score) {
    return '$opponentと$score！勝ちに等しい引き分けだ。';
  }

  @override
  String yDrewHeroic1(String opponent, String score) {
    return '$opponentと$score。一人ひとりを誇りに思う。';
  }

  @override
  String yDrewHeroic2(String opponent, String score) {
    return '$opponent $score。向こうが本命で、こっちは互角に渡り合った。';
  }

  @override
  String yDrewHeroic3(String opponent, String score) {
    return '$opponentと$score。血と汗でもぎ取った勝点だ。';
  }

  @override
  String yDrewHeroic4(String opponent, String score) {
    return '$opponentと$score。とても価値ある勝点。';
  }

  @override
  String yDrewHeroic5(String opponent, String score) {
    return '$opponentと$scoreで引き分け。何かを期待していた人は少なかった。';
  }

  @override
  String yDrewHeroic6(String opponent, String score) {
    return '$opponentを止めた、$score。ここから積み上げられる結果だ。';
  }

  @override
  String yDrewHeroic7(String opponent, String score) {
    return '$opponentと$score。誰も予想しなかった勝点。';
  }

  @override
  String yDrewHeroic8(String opponent, String score) {
    return '$opponentと$score。いい勝点だけど、引き分けじゃ何も勝ち取れない。';
  }

  @override
  String yDrewHeroic9(String opponent, String score) {
    return '$opponentと$score。いいね。まともなシュートは一本もなかったけど。';
  }

  @override
  String yDrewHeroic10(String opponent, String score) {
    return '$opponent $score。勝点1で、みんな優勝したみたいに振る舞ってる。';
  }

  @override
  String yDrewHeroic11(String opponent, String score) {
    return '$opponentと$score。バスを止めて、運がよかった。';
  }

  @override
  String yDrewShame0(String opponent, String score) {
    return '$opponentと$score。もどかしいけど、まだ無敗だ。';
  }

  @override
  String yDrewShame1(String opponent, String score) {
    return '$opponentと$score止まり。ついてない日。そういうこともある。';
  }

  @override
  String yDrewShame2(String opponent, String score) {
    return '$opponent $score。物足りないし、選手も分かってる。';
  }

  @override
  String yDrewShame3(String opponent, String score) {
    return '$opponentと$score。勝点2を落とした、それだけ。';
  }

  @override
  String yDrewShame4(String opponent, String score) {
    return '$opponentと$score。勝点2を捨てた。';
  }

  @override
  String yDrewShame5(String opponent, String score) {
    return '$opponentと$score止まり。どう取り繕ってもひどい結果だ。';
  }

  @override
  String yDrewShame6(String opponent, String score) {
    return '$opponent $score。負けに等しい引き分けだ。';
  }

  @override
  String yDrewShame7(String opponent, String score) {
    return '$opponentと$score。こういう試合は楽に勝たないと。';
  }

  @override
  String yDrewShame8(String opponent, String score) {
    return '$opponentと$score。恥ずかしい。';
  }

  @override
  String yDrewShame9(String opponent, String score) {
    return '$opponentと引き分けただけ、$score。責任は誰にある？';
  }

  @override
  String yDrewShame10(String opponent, String score) {
    return '$opponent $score。ここに勝てなくて、どこに勝つんだ？';
  }

  @override
  String yDrewShame11(String opponent, String score) {
    return '$opponentと$score。向こうのファンはうちとの引き分けを祝ってる。考えてみろ。';
  }

  @override
  String yTrophy0(String opponent) {
    return '優勝だ。$opponent。声に出して言ってみろ。';
  }

  @override
  String yTrophy1(String opponent) {
    return '勝った。$opponent。もう無理、泣く。';
  }

  @override
  String yTrophy2(String opponent) {
    return '$opponent、トロフィーが帰ってくる。';
  }

  @override
  String yTrophy3(String opponent) {
    return '一人残らず全員がレジェンド。$opponent。';
  }

  @override
  String yRunnerUp0(String opponent) {
    return 'あと少しだった。$opponent、誰も欲しくないメダル。';
  }

  @override
  String yRunnerUp1(String opponent) {
    return '$opponentで準優勝。何年も痛むだろうな。';
  }

  @override
  String yRunnerUp2(String opponent) {
    return '$opponent: すべてまであと1試合だった。';
  }

  @override
  String yRunnerUp3(String opponent) {
    return '2位。$opponentで。誰か酒を回してくれ。';
  }

  @override
  String yEliminated0(String opponent) {
    return '$opponentで敗退。しばらく引きずりそうだ。';
  }

  @override
  String yEliminated1(String opponent) {
    return '僕らの$opponentはここで終わり。';
  }

  @override
  String yEliminated2(String opponent) {
    return '$opponentで敗退。さあ、検証の時間だ。';
  }

  @override
  String yEliminated3(String opponent) {
    return '$opponentで敗退。誰か説明してくれ。';
  }

  @override
  String yQualified0(String opponent) {
    return '$opponentに行くぞ！';
  }

  @override
  String yQualified1(String opponent) {
    return '$opponent出場決定。休みを取っておけ。';
  }

  @override
  String yQualified2(String opponent) {
    return '$opponent、今行くぞ。一度も疑わなかった（めちゃくちゃ疑ってた）。';
  }

  @override
  String yQualified3(String opponent) {
    return '$opponent出場決定。難関は越えた。';
  }

  @override
  String yGroupDrawn0(String opponent) {
    return '$opponentの組み合わせ決定。悪くない。もっとひどい可能性もあった。';
  }

  @override
  String yGroupDrawn1(String opponent) {
    return 'なるほど、これが$opponentの組み合わせか。面白い。';
  }

  @override
  String yGroupDrawn2(String opponent) {
    return '$opponentのグループが出たけど、うちの組はもう嫌な予感しかしない。';
  }

  @override
  String yGroupDrawn3(String opponent) {
    return '$opponentの抽選完了。さあ、過剰反応の始まりだ。';
  }

  @override
  String yHostNamed0(String opponent) {
    return '$opponentで開催決定。貯金を始めろ。';
  }

  @override
  String yHostNamed1(String opponent) {
    return '$opponentに決まった。予想通りだけど、まあいい。';
  }

  @override
  String yHostNamed2(String opponent) {
    return '$opponentが大会を勝ち取った。まあ、おめでとう。';
  }

  @override
  String yHostNamed3(String opponent) {
    return '開催国決定: $opponent。';
  }

  @override
  String yTournamentSoon0(String opponent) {
    return 'もうすぐ$opponentが始まる。じっとしていられない。';
  }

  @override
  String yTournamentSoon1(String opponent) {
    return '$opponentまであとわずか。';
  }

  @override
  String yTournamentSoon2(String opponent) {
    return '$opponentはもう目の前。メンバー発表、早く。';
  }

  @override
  String yTournamentSoon3(String opponent) {
    return '$opponentまでのカウントダウン、正式に耐えられない。';
  }

  @override
  String get navY => 'Y';

  @override
  String get yTitle => 'Y';

  @override
  String get yEmpty => 'まだ何もありません。試合をしましょう。';

  @override
  String get yEarlierHeading => '今サイクルの過去の投稿';

  @override
  String get yTraitLoyalist => '何があってもチームを応援。なかなか心変わりせず、すぐ許す。';

  @override
  String get yTraitCynic => '常に最悪を想定し、当たると大喜び。';

  @override
  String get yTraitNostalgic => '昔はすべてが良かった。引退した名選手と比べてくる。';

  @override
  String get yTraitStatshead => '数字だけを投稿。感情はほぼない。';

  @override
  String get yTraitHypeman => '2試合いい結果が出れば黄金世代。';

  @override
  String get yTraitContrarian => '周りが何と思おうと、その逆。';

  @override
  String get yTraitDoomer => 'どうせうまくいかない。いつだってうまくいかない。';

  @override
  String get yProfilePosts => '投稿';

  @override
  String get yProfileEmpty => 'このアカウントの投稿はまだありません。';

  @override
  String hubEventGrievance(String player) {
    return '$playerが話をしたがっています';
  }

  @override
  String get hubEventGrievanceSub => '自分の立場を知りたがっています';

  @override
  String hubEventManagerSkills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '使えるスキルポイントが$countあります',
      one: '使えるスキルポイントが1あります',
    );
    return '$_temp0';
  }

  @override
  String get hubEventManagerSkillsSub => 'あなたの得意分野がチームを強くします';

  @override
  String get grievanceTitle => '監督室での面談';

  @override
  String grievanceGameTime(String player) {
    return '$playerはメンバーに入っているのに出番がありません。理由を知りたがっています。';
  }

  @override
  String grievanceSquadPlace(String player) {
    return '$playerはメンバーから外れていることに納得していません。はっきり言ってほしいそうです。';
  }

  @override
  String grievanceRole(String player) {
    return '$playerは本職外のポジションで起用され続けることにうんざりしています。';
  }

  @override
  String get grievanceReassure => '君は構想に入っている';

  @override
  String get grievanceHonest => '君は序列が下だ。理由はこうだ';

  @override
  String get grievanceDismiss => 'チームを決めるのは私だ';

  @override
  String yScorerStar0(String name, String goals) {
    return '$nameが$goals点。他の誰も及ばない。';
  }

  @override
  String yScorerStar1(String name, String goals) {
    return '$nameが$goals点。このチームは彼が背負ってる。';
  }

  @override
  String yScorerStar2(String name, String goals) {
    return '$name: この日$goals点。大した選手だ。';
  }

  @override
  String yScorerStar3(String name, String goals) {
    return '$nameが$goals点を叩き込んだ。拍手を。';
  }

  @override
  String yScorerStar4(String name, String goals) {
    return '$nameが$goals点、残りはただの乗客。';
  }

  @override
  String yScorerStar5(String name, String goals) {
    return 'また$nameだ。$goals点。彼がいなかったらと思うと。';
  }

  @override
  String yScorerStar6(String name, String goals) {
    return '$nameが$goals点。一人にこれだけ背負わせるべきじゃない。';
  }

  @override
  String yScorerStar7(String name, String goals) {
    return '$nameがいなければ$goals点少なくて、まったく違う午後になってた。';
  }

  @override
  String yWinStreak0(String count) {
    return 'これで$count連勝。ロッカールームで何を話しているにせよ、効いている。';
  }

  @override
  String yWinStreak1(String count) {
    return '$count連勝だ。偶然でこんな連勝はできない。';
  }

  @override
  String yWinStreak2(String count) {
    return '$count連勝、まだ続く。スタンドからでも自信が見える。';
  }

  @override
  String yWinStreak3(String count) {
    return '$count試合負けなし。監督経験者なら誰でも言う、それが一番難しい。';
  }

  @override
  String yWinStreak4(String count) {
    return '$count連勝。日程が優しいうちに楽しんでおけ。';
  }

  @override
  String yWinStreak5(String count) {
    return '$count連勝、でも大した相手には一つも勝ってない。';
  }

  @override
  String yWinStreak6(String count) {
    return '$count連勝。本当の試練が来たらまた聞いてくれ。';
  }

  @override
  String yWinStreak7(String count) {
    return '$count連勝。どのチームにも一度はこういう時期がある。';
  }

  @override
  String yLossStreak0(String count) {
    return 'これで$count試合勝ちなし。いずれ言い訳も尽きる。';
  }

  @override
  String yLossStreak1(String count) {
    return '$count試合連続でダメ。もう一時的な不調じゃない。';
  }

  @override
  String yLossStreak2(String count) {
    return '$count連敗。誰かが責任を取るべきだ。';
  }

  @override
  String yLossStreak3(String count) {
    return '$count試合勝ちなし。プレーを見ればわかる。';
  }

  @override
  String yLossStreak4(String count) {
    return '$count試合勝ちなし、毎週同じミス。';
  }

  @override
  String yLossStreak5(String count) {
    return '$count試合連続。何を試してるにせよ、うまくいってない。';
  }

  @override
  String yLossStreak6(String count) {
    return '$count試合連続。これは落ち込みじゃない、方向性だ。';
  }

  @override
  String yLossStreak7(String count) {
    return '$count試合勝ちなし、なのに上層部は一言もない。';
  }

  @override
  String yRivalry0(String opponent, String score) {
    return '$opponentと$score。内容はどうでもいい。この試合は2倍の価値がある。';
  }

  @override
  String yRivalry1(String opponent, String score) {
    return 'よりによって$opponent相手に。$score。ここの誰も忘れない。';
  }

  @override
  String yRivalry2(String opponent, String score) {
    return '$opponentと$score。酒場で語り継がれるのはこの試合だ。';
  }

  @override
  String yRivalry3(String opponent, String score) {
    return '隣国との一戦、$score。しばらく自慢の種は決まった。';
  }

  @override
  String yRivalry4(String opponent, String score) {
    return '$opponentと$score。今年他に何があっても、これがある。';
  }

  @override
  String yRivalry5(String opponent, String score) {
    return '$opponentと$score。順位表より、俺たちの方がこれを必要としてた。';
  }

  @override
  String yRivalry6(String opponent, String score) {
    return '$opponentと$score。そして次はやり返される、いつもそうだ。';
  }

  @override
  String yRivalry7(String opponent, String score) {
    return '$opponentと$score。この試合のことを1年中言われ続ける。';
  }

  @override
  String yInjuryBlow0(String name) {
    return '$nameが負傷交代。今のチームに一番必要なかったことだ。';
  }

  @override
  String yInjuryBlow1(String name) {
    return '$nameを失うと、何もかもの形が変わる。';
  }

  @override
  String yInjuryBlow2(String name) {
    return '$nameが足を引きずってる。息を止めろ。';
  }

  @override
  String yInjuryBlow3(String name) {
    return 'しばらく$nameなしか。誰かが名乗り出ないと。';
  }

  @override
  String yInjuryBlow4(String name) {
    return '$nameが離脱。そりゃ$nameだよな。';
  }

  @override
  String yInjuryBlow5(String name) {
    return '$nameがいなければ、ごく平凡なチームになる。';
  }

  @override
  String yInjuryBlow6(String name) {
    return '$nameがまた負傷。誰か理由を問いただすべきだ。';
  }

  @override
  String yInjuryBlow7(String name) {
    return '$nameを失って、控えは誰もいない。それが本当の問題だ。';
  }

  @override
  String ySentOff0(String name, String minute) {
    return '$minute分に$nameが退場、国中が彼を叩いてる。誰よりも尽くしてきた選手だ。そっとしておけ。';
  }

  @override
  String ySentOff1(String name, String minute) {
    return '$minute分で$nameが退場。厳しい判定だ。10人でも攻めに行った、それが全てを物語ってる。';
  }

  @override
  String ySentOff2(String name, String minute) {
    return '$name、$minute分、レッドカード。そこから10人。';
  }

  @override
  String ySentOff3(String name, String minute) {
    return '退場: $minute分に$name。一つの判定で試合が動いたのは初めてじゃない。';
  }

  @override
  String ySentOff4(String name, String minute) {
    return '最高だね。$minute分に$nameが退場、また10人。';
  }

  @override
  String ySentOff5(String name, String minute) {
    return '$minute分で$nameが退場。規律の指導はいったい誰がやってるんだ？';
  }

  @override
  String ySentOff6(String name, String minute) {
    return '$minute分。$nameが冷静でいられたのはそれだけ。これがプロのサッカーか。';
  }

  @override
  String ySentOff7(String name, String minute) {
    return '$minute分に$nameが退場。これで進歩してるって信じろと？';
  }

  @override
  String get yBoardPressure0 => '協会がすっかり静かになった。いい兆候だったためしがない。';

  @override
  String get yBoardPressure1 => '噂では、役員室で疑問の声が上がり始めたらしい。';

  @override
  String get yBoardPressure2 => '上の方で地面が動いているのがわかる。';

  @override
  String get yBoardPressure3 => '協会の誰一人として擁護の言葉を口にしない。察してくれ。';

  @override
  String get yBoardPressure4 => '上層部はもう何週間も公の場で監督を支持していない。';

  @override
  String get yBoardPressure5 => '協会が自分たちの監督に不利な情報を流してる。いつものことだ。';

  @override
  String get yBoardPressure6 => '協会が黙り込んだ時には、もう決めているものだ。';

  @override
  String get yBoardPressure7 => '誰か別の人が決断するまで、このままずるずる行くんだろう。';

  @override
  String get yReplies => 'この試合に関するその他の投稿';

  @override
  String get yPlayerGrievance0 => '自分の立場を聞いた。まだ答えを待っている。';

  @override
  String get yPlayerGrievance1 => '練習に励むだけ。他にできることはあまりない。';

  @override
  String get yPlayerGrievance2 => '一度しか聞けない質問もある。';

  @override
  String get yPlayerGrievance3 => 'ビブスを運ぶためにここまで来たんじゃない。';

  @override
  String get playerHonoursTitle => '受賞歴';

  @override
  String get awardGoldenBall => 'ゴールデンボール';

  @override
  String get awardGoldenBoot => 'ゴールデンブーツ';

  @override
  String get awardGoldenGlove => 'ゴールデングローブ';

  @override
  String get awardTeamOfTournament => '大会ベストイレブン';

  @override
  String get awardPlayerOfYear => '世界年間最優秀選手';

  @override
  String get awardYoungPlayerOfYear => '年間最優秀若手選手';

  @override
  String get playerClubHistory => 'クラブ経歴';

  @override
  String get playerCareerRecord => '通算成績';

  @override
  String get playerInternationalGoals => '代表通算ゴール';

  @override
  String get playerRecentForm => '最近の調子';

  @override
  String get playerMatchHistory => '試合履歴';

  @override
  String get playerAttributes => '能力';

  @override
  String get playerUnknown => '不明';

  @override
  String get playerAttrPace => 'スピード';

  @override
  String get playerAttrPhysical => 'フィジカル';

  @override
  String get playerAttrTechnical => 'テクニック';

  @override
  String get playerAttrShooting => 'シュート';

  @override
  String get playerAttrPassing => 'パス';

  @override
  String get playerAttrDribbling => 'ドリブル';

  @override
  String get playerAttrTackling => 'タックル';

  @override
  String get playerAttrPositioning => 'ポジショニング';

  @override
  String get playerAttrComposure => '冷静さ';

  @override
  String get playerAttrDecisions => '判断力';

  @override
  String get playerAttrStamina => 'スタミナ';

  @override
  String get playerAttrStrength => 'パワー';

  @override
  String get playerStatCaps => 'キャップ';

  @override
  String get playerStatGoals => 'ゴール';

  @override
  String get playerStatAssists => 'アシスト';

  @override
  String get playerStatAvgRating => '平均評価';

  @override
  String get playerStatForm => '調子';

  @override
  String get playerStatMotm => 'MOTM';

  @override
  String get playerStatCleanSheets => '完封';

  @override
  String get playerStatBestGame => '最高試合';

  @override
  String get playerStatCards => 'カード';

  @override
  String playerCardsValue(int yellows, int reds) {
    return '警告$yellows 退場$reds';
  }

  @override
  String get tourSharedYourRun => 'あなたの歩み';

  @override
  String get tourSharedList => 'リスト';

  @override
  String get tourSharedBracket => 'トーナメント表';

  @override
  String get tourSharedVs => 'vs';

  @override
  String tourSharedGroupSeed(String seed) {
    return 'グループ$seed';
  }

  @override
  String get tourSharedThisEdition => '今大会';

  @override
  String get tourSharedAllTime => '歴代';

  @override
  String get tourSharedUnknown => '不明';

  @override
  String get tourSharedActive => '現役';

  @override
  String get tourSharedMedalTable => 'メダル獲得数';

  @override
  String get tourSharedPastWinners => '歴代優勝国';

  @override
  String tourSharedHost(String host) {
    return '開催国: $host';
  }

  @override
  String get tourSharedBeat => 'に勝利';

  @override
  String get tourSharedPens => ' （PK）';

  @override
  String get tourSharedAwardsEmpty => '各賞は大会終了後に決まります。';

  @override
  String get tourSharedGoldenBall => 'ゴールデンボール';

  @override
  String get tourSharedPlayerOfTournament => '大会最優秀選手';

  @override
  String get tourSharedGoldenBoot => 'ゴールデンブーツ';

  @override
  String tourSharedGoalsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countゴール',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedGoldenGlove => 'ゴールデングローブ';

  @override
  String get tourSharedTeamOfTournament => '大会ベストイレブン';

  @override
  String get tourSharedStatsEmpty => '大会の歴史が積み重なると記録が表示されます。';

  @override
  String get tourSharedRecordScorer => '歴代最多得点';

  @override
  String get tourSharedStillActive => '現役';

  @override
  String get tourSharedMostTitles => '最多優勝';

  @override
  String tourSharedTitlesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '優勝$count回',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostFinals => '最多決勝進出';

  @override
  String tourSharedFinalsContested(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '決勝進出$count回',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostGamesPlayed => '最多出場';

  @override
  String tourSharedMatchesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count試合',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostFinalsPlayed => '最多本大会出場';

  @override
  String tourSharedFinalsTournamentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '本大会$count回',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedBiggestFinalWin => '決勝最大差勝利';

  @override
  String tourStatsGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countゴール',
      one: '1ゴール',
    );
    return '$_temp0';
  }

  @override
  String get tourStatsStillActive => '現役';

  @override
  String tourStatsTitles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '優勝$count回',
      one: '優勝1回',
    );
    return '$_temp0';
  }

  @override
  String tourStatsFinalsContested(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '決勝進出$count回',
      one: '決勝進出1回',
    );
    return '$_temp0';
  }

  @override
  String tourStatsMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count試合',
      one: '1試合',
    );
    return '$_temp0';
  }

  @override
  String tourStatsFinalsTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '決勝進出大会$count回',
      one: '決勝進出大会1回',
    );
    return '$_temp0';
  }

  @override
  String get tourStatsLeaders => '歴代トップ';

  @override
  String get tourStatsTabGames => '試合';

  @override
  String get tourStatsTabCups => '大会';

  @override
  String get tourStatsTabScorers => '得点';

  @override
  String tourSharedFinalWinDetail(String opponent, int year) {
    return '対$opponent · $year';
  }

  @override
  String get tourHolders => '前回王者';

  @override
  String tourHoldersSince(int year) {
    return '$year年優勝';
  }

  @override
  String get tourSharedAllTimeScorers => '歴代得点ランキング';

  @override
  String get tourSharedSummaryEmpty => '開催国とスタジアムは、今大会の抽選後に表示されます。';

  @override
  String get tourSharedHostHeading => '開催国';

  @override
  String get tourSharedHostsHeading => '開催国';

  @override
  String get tourSharedCoHostsHeading => '共同開催国';

  @override
  String get tourSharedVenues => '会場';

  @override
  String get tourSharedMascot => 'マスコット';

  @override
  String get tourSharedMatchBall => '公式球';

  @override
  String tourSharedVenueSeats(String city, String capacity) {
    return '$city · $capacity席';
  }

  @override
  String get tourSharedCouldNotLoad => '読み込めませんでした。';

  @override
  String get tourSharedHostTbc => '開催国未定';

  @override
  String get tourSharedFinalsAreHere => '本大会、開幕';

  @override
  String tourSharedHostedBy(String hosts) {
    return '開催国  $hosts';
  }

  @override
  String get tourSharedLetFinalsBegin => '本大会を始めよう';

  @override
  String get tourSharedCompetitions => '大会';

  @override
  String get tourSharedWorldRanking => '世界ランキング';

  @override
  String get tourSharedCouldNotLoadTournaments => '大会を読み込めませんでした。';

  @override
  String get tourSharedPrestigeStage => '栄光の舞台';

  @override
  String get tourSharedOverview => '概要';

  @override
  String get tourSharedWorldRankingTitle => '世界ランキング';

  @override
  String get tourSharedYourCompetitions => '参加大会';

  @override
  String get tourSharedOtherContinents => '他の大陸';

  @override
  String get tourSharedComingSoon => '大会は近日開始';

  @override
  String get tourSharedSoon => '近日';

  @override
  String get tourSharedNoQualifyingDraw => '予選の抽選はありません。';

  @override
  String get tourSharedOpenEnvelope => '封筒を開ける';

  @override
  String tourSharedGroupName(String name) {
    return 'グループ$name';
  }

  @override
  String get tourSharedBall => '1チーム';

  @override
  String get tourSharedPot => 'ポット';

  @override
  String get tourSharedAll => '全て';

  @override
  String get tourSharedTapDrawTeam => 'タップして次のチームを抽選';

  @override
  String get tourSharedTapDrawPot => 'タップして次のポットを抽選';

  @override
  String get tourSharedTapDrawAll => 'タップして全抽選結果を表示';

  @override
  String get tourSharedContinue => '続ける';

  @override
  String get tourSharedPause => '一時停止';

  @override
  String get tourSharedPlay => '再生';

  @override
  String get tourSharedSkip => 'スキップ';

  @override
  String tourSharedPotNumber(int number) {
    return 'ポット$number';
  }

  @override
  String get tourSharedDrawComplete => '抽選完了';

  @override
  String get tourSharedDrawing => '抽選中…';

  @override
  String get tourContChampionship => '大陸選手権';

  @override
  String get tourContTabSummary => '概要';

  @override
  String get tourContTabQualifying => '予選';

  @override
  String get tourContTabFinals => '本大会';

  @override
  String get tourContTabBracket => 'トーナメント';

  @override
  String get tourContTabAwards => '表彰';

  @override
  String get tourContTabScorers => '得点者';

  @override
  String get tourContTabHistory => '歴史';

  @override
  String get tourContTabRecords => '記録';

  @override
  String tourContCouldNotLoadCup(String error) {
    return '大会を読み込めませんでした。\n$error';
  }

  @override
  String get tourContNoCupData => '大会データがありません。';

  @override
  String get tourContUnknown => '不明';

  @override
  String get tourContGroupsToBeDrawnQual =>
      '予選グループはセレモニーで抽選されます。ハブから観て対戦相手を確認しましょう。';

  @override
  String get tourContQualSeeded => 'あなたの国は本大会にシードされています。今サイクルの予選はありません。';

  @override
  String tourContBackgroundRegion(String name) {
    return '$nameはバックグラウンドでシミュレートされます。各ラウンドの結果はここに表示されます。';
  }

  @override
  String get tourContGroupsToBeDrawnFinals =>
      '本大会のグループはセレモニーで抽選されます。ハブから観て所属グループを確認しましょう。';

  @override
  String get tourContFinalsDrawAfterQual => '本大会の抽選は予選終了後に行われます。';

  @override
  String get tourContContestedBeforeWc => 'ノックアウトラウンドは世界選手権の前に行われます。';

  @override
  String tourContChampionsHeading(String name) {
    return '$name 王者';
  }

  @override
  String tourContWinnersTitle(String name) {
    return '$name 歴代優勝国';
  }

  @override
  String get tourContNoGoalsYet => 'まだゴールはありません。';

  @override
  String tourContGroupHeading(String name) {
    return 'グループ$name';
  }

  @override
  String get tourContBestRunnersUp => '2位チーム成績上位';

  @override
  String tourContGroupDropdown(String name) {
    return 'グループ$name';
  }

  @override
  String get tourContMatches => '試合';

  @override
  String get tourContNoGroupsDrawn => 'グループはまだ抽選されていません。';

  @override
  String get tourContQualifyingDraw => '予選抽選';

  @override
  String get tourContWorldQualifyingDraw => '世界予選抽選';

  @override
  String get tourContFinalsDraw => '本大会抽選';

  @override
  String get tourContSeedingPots => 'ポット分け';

  @override
  String get tourContGroupDraw => 'グループ抽選';

  @override
  String tourContCouldNotLoadDraw(String error) {
    return '抽選を読み込めませんでした。\n$error';
  }

  @override
  String get tourContDrawNotReady => '抽選の準備がまだできていません。';

  @override
  String get tourContContinentalClash => 'コンチネンタル・クラッシュ';

  @override
  String get tourContTabThisCycle => '今サイクル';

  @override
  String tourContCouldNotLoadClash(String error) {
    return '読み込めませんでした。\n$error';
  }

  @override
  String get tourContNoSaveFound => 'セーブデータが見つかりません。';

  @override
  String get tourContClashSoon => 'コンチネンタル・クラッシュは両大陸の王者が決まり次第行われます。';

  @override
  String get tourContTwoContinentsOneMatch => '2つの大陸、1つの試合';

  @override
  String get tourContVersusShort => 'vs';

  @override
  String tourContWinTheClash(String name) {
    return '$nameがクラッシュを制覇';
  }

  @override
  String get tourContNoClashYet => 'コンチネンタル・クラッシュはまだ行われていません。';

  @override
  String get tourContNationsCup => 'ネーションズカップ';

  @override
  String get tourContTabLeagues => 'リーグ';

  @override
  String get tourContTabFinalsFour => 'ファイナル4';

  @override
  String tourContCouldNotLoad(String error) {
    return '読み込めませんでした。\n$error';
  }

  @override
  String get tourContNoNationsCupGoals => 'ネーションズカップのゴール記録はまだありません。';

  @override
  String get tourContNoNationsCupChampions => 'ネーションズカップの王者はまだいません。';

  @override
  String get tourContNationsCupOffSeason =>
      '今サイクルのネーションズカップは大陸選手権本大会の後に始まります。歴代優勝国は「歴史」で確認できます。';

  @override
  String get tourContNationsCupGroupsSoon =>
      '今サイクルのネーションズカップのグループはセレモニーで抽選されます。ハブから観て対戦相手を確認しましょう。';

  @override
  String get tourContLeagueNoGroups => 'このラウンドはこのリーグの試合はありません。';

  @override
  String tourContLeagueHeading(String letter) {
    return 'リーグ$letter';
  }

  @override
  String tourContLeagueHeadingYours(String letter) {
    return 'リーグ$letter · あなたのリーグ';
  }

  @override
  String get tourContFinalsFourSoon =>
      'ファイナル4は、グループステージ終了後にリーグAの各グループ首位で争われます。';

  @override
  String tourContLeagueChip(String letter) {
    return 'リーグ$letter';
  }

  @override
  String tourContLeagueChipStar(String letter) {
    return 'リーグ$letter ★';
  }

  @override
  String get tourContSemiFinals => '準決勝';

  @override
  String get tourContFinal => '決勝';

  @override
  String get tourContNationsCupDraw => 'ネーションズカップ抽選';

  @override
  String get tourContIntercontinentalPlayoff => '大陸間プレーオフ';

  @override
  String get tourContNoPlayoffThisCycle => '今サイクルはプレーオフがありません。';

  @override
  String get tourContPlayoffIntro => '予選で惜しくも敗れた上位国によるノックアウトで、世界選手権の2枠を争います。';

  @override
  String get tourContPlayoffThrough => 'プレーオフを勝ち抜きました。世界選手権出場です！';

  @override
  String get tourContPlayoffOut => 'プレーオフで敗れました。今回は世界選手権に出場できません。';

  @override
  String get tourContContinue => '続ける';

  @override
  String get tourContPlayoffFinals => 'プレーオフ決勝';

  @override
  String get tourContPlayoffSeeded => 'シード（不戦）';

  @override
  String get tourCupTabSummary => '概要';

  @override
  String get tourCupTabQualifying => '予選';

  @override
  String get tourCupTabPlayoff => 'プレーオフ';

  @override
  String get tourCupPlayoffSoon => '大陸間プレーオフは全連盟の予選終了後に決まります。';

  @override
  String get tourCupTabFinals => '本大会';

  @override
  String get tourCupTabBracket => 'トーナメント';

  @override
  String get tourCupTabAwards => '表彰';

  @override
  String get tourCupTabScorers => '得点者';

  @override
  String get tourCupTabHistory => '歴史';

  @override
  String get tourCupTabRecords => '記録';

  @override
  String get tourCupTitle => '世界選手権';

  @override
  String get tourCupNoData => '大会データがありません。';

  @override
  String tourCupLoadError(String error) {
    return '大会を読み込めませんでした。\n$error';
  }

  @override
  String get tourCupUnknown => '不明';

  @override
  String get tourCupWorldChampions => '世界王者';

  @override
  String get tourCupWorldChampionsTitle => '世界王者';

  @override
  String get tourCupStillActive => '現役';

  @override
  String get tourCupAllTimeScorers => '歴代得点ランキング';

  @override
  String get tourCupAllConfederations => '全連盟';

  @override
  String get tourCupBestRunnersUp => '2位チーム成績上位';

  @override
  String get tourCupCompWorld => '世界選手権';

  @override
  String get tourCupCompEurope => '欧州選手権';

  @override
  String get tourCupCompSAmerica => '南米カップ';

  @override
  String get tourCupDestRoundOf16 => 'ラウンド16';

  @override
  String get tourCupDestKnockouts => '決勝トーナメント';

  @override
  String get tourCupDestFinals => '本大会';

  @override
  String get tourCupDestFinalsPlayoff => '本大会プレーオフ';

  @override
  String get tourCupDestIntercontPlayoff => '大陸間プレーオフ';

  @override
  String get tourCupFinalsDrawnAfterQual => '本大会の抽選は予選終了後に行われます。';

  @override
  String get tourCupFinalsDrawSoon => '組み合わせは未定です。ハブから世界選手権の抽選を見て確認しましょう。';

  @override
  String tourCupGroupName(String name) {
    return 'グループ$name';
  }

  @override
  String tourCupGroupNameShort(String name) {
    return 'グループ$name';
  }

  @override
  String tourCupHostLabel(String host) {
    return '開催国: $host';
  }

  @override
  String tourCupHostLabelMulti(String hosts) {
    return '開催国: $hosts';
  }

  @override
  String get tourCupIntercontPlayoff => '大陸間プレーオフ';

  @override
  String get tourCupKnockoutSoon => 'トーナメントはグループステージ終了後に始まります。';

  @override
  String get tourCupMatches => '試合';

  @override
  String get tourCupMedalTable => 'メダル獲得数';

  @override
  String get tourCupMostTitles => '最多優勝';

  @override
  String tourCupMostTitlesValue(String nation, int titles, int editions) {
    return '$nation: $editions大会で優勝$titles回';
  }

  @override
  String get tourCupNoGoals => 'まだゴールはありません。';

  @override
  String get tourCupNoGroups => 'グループは未抽選です。';

  @override
  String get tourCupNoHistory => 'まだ歴史がありません。';

  @override
  String get tourCupPastWinners => '歴代優勝国';

  @override
  String get tourCupPlayoffIntro => '予選で惜しくも敗れた上位国によるノックアウトで、世界選手権の2枠を争います。';

  @override
  String tourCupPlayoffNoEntrants(String confederation) {
    return '$confederationにはプレーオフがありません。出場枠はすべて予選グループで決まります。';
  }

  @override
  String get tourCupQualDrawSoon => '組み合わせは未定です。ハブから予選の抽選を見て確認しましょう。';

  @override
  String tourCupRegionYours(String region) {
    return '$region · 自国';
  }

  @override
  String tourCupScorePens(int home, int away) {
    return '$home–$away（PK）';
  }

  @override
  String get tourCupSegAllTime => '歴代';

  @override
  String get tourCupSegFinals => '本大会';

  @override
  String get tourCupSegQualifying => '予選';

  @override
  String get playerTraitsTitle => '特徴';

  @override
  String get traitBigGame => '大舞台に強い';

  @override
  String get traitBigGameBlurb => 'ノックアウトの試合で力を発揮する。';

  @override
  String get traitSetPiece => 'セットプレーの名手';

  @override
  String get traitSetPieceBlurb => 'キックの質が高く、セットプレーからの得点が増える。';

  @override
  String get traitHothead => '短気';

  @override
  String get traitHotheadBlurb => 'チームメイトよりはるかに多くカードをもらう。';

  @override
  String get traitIronMan => '鉄人';

  @override
  String get traitIronManBlurb => 'めったに負傷せず、疲れにくい。';

  @override
  String get traitWonderkid => '神童';

  @override
  String get traitWonderkidBlurb => '若くして実力があり、なお急成長中。';

  @override
  String get traitLeader => 'リーダー';

  @override
  String get traitLeaderBlurb => 'ピッチ上のチームメイト全員を鼓舞する。';

  @override
  String get traitPacey => '俊足';

  @override
  String get traitPaceyBlurb => '圧倒的なスピードで裏を脅かす。';

  @override
  String get traitOldHead => '老練';

  @override
  String get traitOldHeadBlurb => '脚が衰えても試合を読む力は衰えないベテラン。';

  @override
  String get traitWasteful => '決定力不足';

  @override
  String get traitWastefulBlurb => '決定機を外しすぎる。';

  @override
  String get objectiveWorldCup => '世界選手権';

  @override
  String get objectiveWinTournament => '優勝';

  @override
  String get objectiveQualifyGeneric => '出場権獲得';

  @override
  String hubBoardObjectiveFor(String competition, String label) {
    return '$competition: $label';
  }

  @override
  String get objectiveWinWorldCup => '世界選手権優勝';

  @override
  String get objectiveReachFinal => '決勝進出';

  @override
  String get objectiveReachSemis => '準決勝進出';

  @override
  String get objectiveReachQuarters => '準々決勝進出';

  @override
  String get objectiveReachKnockouts => '決勝トーナメント進出';

  @override
  String get objectiveQualify => '世界選手権出場';

  @override
  String get finishChampions => '優勝';

  @override
  String get finishRunnersUp => '準優勝';

  @override
  String get finishSemiFinals => 'ベスト4';

  @override
  String get finishQuarterFinals => 'ベスト8';

  @override
  String get finishRoundOf16 => 'ベスト16';

  @override
  String get finishGroupStage => 'グループステージ';

  @override
  String get objectiveQualifyingTopHalf => '予選グループで上位半分に入る';

  @override
  String get finishQualifyingTopHalf => '予選グループ上位半分';

  @override
  String get finishQualifyingBottomHalf => '予選グループ下位半分';

  @override
  String get objectiveNcWinIt => 'ネーションズカップ優勝';

  @override
  String get objectiveNcReachFinal => 'ネーションズカップ決勝進出';

  @override
  String get objectiveNcFinalsFour => 'ファイナル4進出';

  @override
  String get objectiveNcWinGroup => 'グループ首位で昇格';

  @override
  String get objectiveNcTopHalf => 'グループ上位半分に入る';

  @override
  String get objectiveNcSurvive => '降格回避';

  @override
  String get objectiveNcOffTheBottom => 'グループ最下位を回避';

  @override
  String get finishNcChampions => 'ネーションズカップ優勝';

  @override
  String get finishNcFinalsFour => 'ファイナル4';

  @override
  String get finishNcGroupWinners => 'グループ首位';

  @override
  String get finishNcTopHalf => 'グループ上位半分';

  @override
  String get finishNcStayedUp => '残留';

  @override
  String get finishNcClearOfBottom => 'グループ最下位は回避';

  @override
  String get finishNcBottom => 'グループ最下位';

  @override
  String get careerNationsCupLabel => 'ネーションズカップ';

  @override
  String get squadDevPlayer => '選手';

  @override
  String get squadDevAge => '年齢';

  @override
  String get squadDevPosition => '位置';

  @override
  String get squadDevChange => '評価';

  @override
  String get squadDevNew => '新顔';

  @override
  String get squadDevRetired => '引退';

  @override
  String get squadDevEmpty => '安定した1年。チームに変化はありません。';

  @override
  String get squadDevTierRegulars => '常連';

  @override
  String get squadDevTierFringe => '当落線上';

  @override
  String get squadDevTierYouth => '若手';

  @override
  String get boardObjectivesTitle => '協会の目標';

  @override
  String get boardObjectivesConfidence => '協会の信頼度';

  @override
  String boardObjectiveBeatenBy(String result, int rounds) {
    String _temp0 = intl.Intl.pluralLogic(
      rounds,
      locale: localeName,
      other: '目標を$roundsラウンド上回る',
      one: '目標を1ラウンド上回る',
    );
    return '$result: $_temp0';
  }

  @override
  String boardObjectiveShortBy(String result, int rounds) {
    String _temp0 = intl.Intl.pluralLogic(
      rounds,
      locale: localeName,
      other: '$roundsラウンド届かず',
      one: '1ラウンド届かず',
    );
    return '$result: $_temp0';
  }

  @override
  String get boardObjectivesPending => '未確定';

  @override
  String boardObjectiveSoFar(String result) {
    return '現時点 · $result';
  }

  @override
  String get boardObjectivesEmpty => '協会は今サイクルの目標を設定していません。';

  @override
  String get tourContBestWinners => '各組1位の成績上位';

  @override
  String get tourContBestThirds => '各組3位の成績上位';

  @override
  String tourContBestPlaced(String position) {
    return '各組$position位の成績上位';
  }

  @override
  String squadDevPageOf(String page, String pages, String total) {
    return '$page/$pages · $total人';
  }

  @override
  String get matchSoldOut => '満員';

  @override
  String matchAttendanceOf(String attendance, String capacity) {
    return '$capacity席中$attendance席が埋まりました';
  }

  @override
  String get matchGroundTitle => '会場';

  @override
  String get absenceInjured => '負傷';

  @override
  String get absenceSuspended => '出場停止';

  @override
  String absenceWeeks(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString週間',
      one: '1週間',
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
      other: '$countString試合',
      one: '1試合',
    );
    return '$_temp0';
  }

  @override
  String absenceBackFor(String opponent) {
    return '対$opponent戦で復帰';
  }

  @override
  String get penaltyOrderTitle => 'PK戦';

  @override
  String get penaltyOrderBlurb => '5人のキッカーを順番に指名します。枠をタップして変更します。';

  @override
  String penaltyOrderPick(int number) {
    return '$number人目';
  }

  @override
  String get penaltyOrderPickBlurb => '蹴る選手を選びます。バーはPKでの冷静さを示します。';

  @override
  String get penaltyOrderConfirm => '開始';

  @override
  String get penaltyOrderCancel => '戻る';

  @override
  String get youthTitle => 'ユース';

  @override
  String get youthEmptyLevel => 'このレベルにはまだ誰もいません。';

  @override
  String get youthReleased => '今年の放出選手';

  @override
  String get u21Title => 'U-21';

  @override
  String get u21Blurb => '次世代の有望株、評価の高い順。白抜きの星はスカウトの推定です。招集すれば本当の実力がわかります。';

  @override
  String get u21Empty => '現在、候補にU-21の選手はいません。次の新世代は新サイクルとともにやって来ます。';

  @override
  String u21Breakout(int gain) {
    return '今年 +$gain';
  }

  @override
  String u21AgeCaps(int age, int caps) {
    return '$age歳 · $capsキャップ';
  }

  @override
  String u21AgeUncapped(int age) {
    return '$age歳 · 代表未出場';
  }

  @override
  String get u21CallUps => '招集へ';

  @override
  String get youthWatching => '注目';

  @override
  String get youthWatchEmpty =>
      'まだ誰も登録していません。どのレベルでも少年を登録すると、その後の成長とともにここに表示されます。';

  @override
  String get youthWatchMark => 'この選手を追う';

  @override
  String get youthWatchUnmark => '追うのをやめる';

  @override
  String youthWatchMarked(int rating, int age) {
    return '登録時 評価$rating、$age歳';
  }

  @override
  String get youthWatchSenior => 'A代表候補に昇格';

  @override
  String get youthWatchReleased => 'アカデミーから放出';

  @override
  String get youthWatchGone => '育成組織から外れた';

  @override
  String get tacticsYouth => 'U-21';

  @override
  String get pressSquad => 'チーム';

  @override
  String get pressBoard => '協会';

  @override
  String get pressNoEffect => '誰も深読みしない';

  @override
  String get matchNeutralGround => '中立地';

  @override
  String get matchExtraTimeAhead => '延長戦';

  @override
  String get matchExtraTimeHalf => '延長戦 · ハーフタイム';

  @override
  String get matchClockFullTime => '試合終了';

  @override
  String get matchClockAfterExtraTime => '延長戦終了';

  @override
  String get matchClockPenalties => 'PK戦';

  @override
  String get matchClockFullTimePenalties => '試合終了 · PK戦';

  @override
  String get hubEventPressConference => '記者会見に臨む';

  @override
  String get hubEventPressConferenceSub => '初戦を前に、世界中のメディアが話を聞きたがっています';

  @override
  String get squadDevWonderkid => '神童';

  @override
  String get tacticsPlaystyle => 'プレースタイル';

  @override
  String get tacticsPlaystyleBlurb => 'チームの戦い方を選び、下のダイヤルで微調整します。';

  @override
  String get tacticsPlaystyleCustom => '独自の設定です。どの既定スタイルにも当てはまりません。';

  @override
  String get playstyleCustom => 'カスタム';

  @override
  String get playstyleBalanced => 'バランス';

  @override
  String get playstylePossession => 'ポゼッション';

  @override
  String get playstyleGegenpress => 'ゲーゲンプレス';

  @override
  String get playstyleCounter => 'カウンター';

  @override
  String get playstyleDirect => 'ダイレクト';

  @override
  String get playstyleLowBlock => '低いブロック';

  @override
  String get playstyleWingPlay => 'サイド攻撃';

  @override
  String get playstyleBalancedBlurb => '攻守ともに堅実で、やりすぎない。';

  @override
  String get playstylePossessionBlurb => 'ボールを保持し、じっくり回して相手を押し込む。';

  @override
  String get playstyleGegenpressBlurb => '失った瞬間に高い位置で奪い返す。';

  @override
  String get playstyleCounterBlurb => '引いてコンパクトに守り、一気に速攻。';

  @override
  String get playstyleDirectBlurb => '早めに前線へ送り、セカンドボールを狙う。';

  @override
  String get playstyleLowBlockBlurb => '深く、狭く、崩すのが非常に難しい。';

  @override
  String get playstyleWingPlayBlurb => 'ピッチを広く使い、外から回り込んでクロス。';

  @override
  String get nationsRandomTeam => 'ランダム';

  @override
  String get nationsFromTheBottom => 'どん底から';

  @override
  String get bottomStartTitle => '無職';

  @override
  String get bottomStartHeading => '3つの協会が話をしたがっています';

  @override
  String get bottomStartBlurb =>
      'あなたには職も評判もありません。賭けてくれるのはこの国々だけです。一つを選び、ゼロから築き上げましょう。';

  @override
  String get bottomStartAccept => '引き受ける';

  @override
  String get bottomStartBack => 'メニューに戻る';

  @override
  String bottomStartRankOf(int rank, int total) {
    return '世界$totalか国中$rank位';
  }

  @override
  String get campTitle => 'ベースキャンプ';

  @override
  String campBasedIn(String host) {
    return '拠点: $host';
  }

  @override
  String get campBlurb =>
      '大会期間中、チームが過ごす場所です。大会開始後は変更できず、毎試合3つの点に影響します。到着時の疲労、負傷の回復速度、そして試合勘です。';

  @override
  String get campEffectTravel => '移動の負担';

  @override
  String get campEffectRecovery => '負傷回復';

  @override
  String get campEffectSharpness => '試合勘';

  @override
  String get campTerrainCity => '都市中心部';

  @override
  String get campTerrainCoastal => '海辺のリゾート';

  @override
  String get campTerrainMountain => '山間の隠れ家';

  @override
  String get campTerrainAltitude => '高地キャンプ';

  @override
  String get campTerrainNationalCentre => 'ナショナルセンター';

  @override
  String get campTerrainCityBlurb => '何でもすぐそばにあり移動も不要。ただし静けさはなく、喧騒から逃れられない。';

  @override
  String get campTerrainCoastalBlurb => '穏やかで快適、雰囲気も良い。ただし各会場へは長いバス移動。';

  @override
  String get campTerrainMountainBlurb => '涼しい空気と一流の医療体制で負傷の回復が早い。ただし大会会場からは遠い。';

  @override
  String get campTerrainAltitudeBlurb => '練習は過酷だが、大会終盤まで脚がもつ。';

  @override
  String get campTerrainNationalCentreBlurb => '協会自前の施設。派手さはないが、問題も起きない。';

  @override
  String get hubEventChooseCamp => 'ベースキャンプを選ぶ';

  @override
  String hubEventChooseCampSub(String host) {
    return '$hostでのチームの拠点';
  }

  @override
  String get tacticsTabBench => '控え';

  @override
  String get squadSearchHint => '名前・クラブで検索';

  @override
  String get squadFilterAll => '全員';

  @override
  String get squadFilterInSquad => '招集中';

  @override
  String get squadFilterUncapped => '代表未出場';

  @override
  String get squadFilterUnavailable => '出場不可';

  @override
  String get squadLineAll => '全ライン';

  @override
  String get squadSortBy => '並べ替え';

  @override
  String get squadSortRating => '評価';

  @override
  String get squadSortCaps => 'キャップ';

  @override
  String get squadSortGoals => 'ゴール';

  @override
  String get squadSortAge => '年齢';

  @override
  String get squadSortName => '名前';

  @override
  String get squadLegendTitle => 'マークの意味';

  @override
  String get squadLegendStarting => '先発イレブン';

  @override
  String get squadLegendCalledUp => '招集済み、控え';

  @override
  String get squadLegendRatingUp => '今年評価が上昇';

  @override
  String get squadLegendRatingDown => '今年評価が下降';

  @override
  String get squadLegendInjured => '負傷、出場不可';

  @override
  String get squadLegendSuspended => '出場停止、出場不可';

  @override
  String get squadLegendTraits => '特徴';

  @override
  String squadShowingOf(int shown, int total) {
    return '$total人中$shown人を表示';
  }

  @override
  String get squadNobodyMatches => '条件に合う選手はいません。';

  @override
  String get squadStatPool => '候補';

  @override
  String get squadStatInSquad => '招集';

  @override
  String get squadMostCapped => '最多キャップ';

  @override
  String get squadTopScorer => '最多得点';

  @override
  String squadCapsValue(String name, int caps) {
    return '$name · $capsキャップ';
  }

  @override
  String squadGoalsValue(String name, int goals) {
    return '$name · $goalsゴール';
  }

  @override
  String squadAgeClub(int age, String club) {
    return '$age · $club';
  }

  @override
  String get squadCapsShort => '出場';

  @override
  String get squadGoalsShort => '得点';

  @override
  String get recordsRecordBookSubtitle => 'キャップ、ゴール、チームの主要記録';

  @override
  String get statsLegacy => 'レガシー';

  @override
  String tacticsSubAlreadyOff(String name) {
    return '$nameはすでに交代しており、再出場できません。';
  }

  @override
  String tacticsSubSentOff(String name) {
    return '$nameは退場しており、これ以上出場できません。';
  }

  @override
  String get tacticsInjuredShort => '負傷';

  @override
  String get tacticsSuspendedShort => '停止';

  @override
  String get confEurope => 'ヨーロッパ';

  @override
  String get confSouthAmerica => '南米';

  @override
  String get confNorthAmerica => '北中米';

  @override
  String get confAfrica => 'アフリカ';

  @override
  String get confAsia => 'アジア';

  @override
  String get confOceania => 'オセアニア';

  @override
  String get compWorldCup => '世界選手権';

  @override
  String get compWorldCupFinals => '世界選手権本大会';

  @override
  String get compWorldCupQualifying => '世界選手権予選';

  @override
  String compQualifiers(String region) {
    return '$region予選';
  }

  @override
  String get compFriendlies => '親善試合';

  @override
  String get compNationsCup => 'ネーションズカップ';

  @override
  String get compContinentalClash => 'コンチネンタル・クラッシュ';

  @override
  String get compIntercontinentalPlayoff => '大陸間プレーオフ';

  @override
  String get compContinentalChampionship => '大陸選手権';

  @override
  String get compEuropeanChampionship => '欧州選手権';

  @override
  String get compSouthAmericaCup => '南米カップ';

  @override
  String get compAfricanChampionship => 'アフリカ選手権';

  @override
  String get compAsianChampionship => 'アジア選手権';

  @override
  String get compNorthAmericaCup => '北米カップ';

  @override
  String get compOceaniaCup => 'オセアニアカップ';

  @override
  String get msgANation => 'ある国';

  @override
  String get msgAPlayer => 'ある選手';

  @override
  String get msgAHostNation => '開催国';

  @override
  String get msgCycleTitle1 => '新たなサイクルが始まる';

  @override
  String msgCycleTitle2(int year) {
    return '$year年への道が開く';
  }

  @override
  String get msgCycleTitle3 => '新たな戦いの幕開け';

  @override
  String get msgCycleTitle4 => '仕事に戻ろう';

  @override
  String msgCycleBody1(int year) {
    return '$year年世界選手権への道がここから始まります。';
  }

  @override
  String msgCycleBody2(int year) {
    return '新たなサイクル。目標は$year年世界選手権です。';
  }

  @override
  String msgCycleBody3(int year) {
    return '$year年世界選手権まで4年。準備は今から始まります。';
  }

  @override
  String msgCycleBody4(int year) {
    return '$year年に向けた戦いが今日から始まります。';
  }

  @override
  String msgContHostTitle(String cup, String host) {
    return '$cup開催国: $host';
  }

  @override
  String msgContHostBody(String host, String cup) {
    return '次回の$cupは$hostで開催されます。';
  }

  @override
  String msgContQualDrawTitle(String cup) {
    return '$cup予選抽選';
  }

  @override
  String msgContQualDrawBody(String cup) {
    return '$cupの予選グループが決まりました。';
  }

  @override
  String msgWcHostTitle(String host, int year) {
    return '$year年世界選手権開催国: $host';
  }

  @override
  String msgWcHostBody(String host, int year) {
    return '$year年世界選手権は$hostで開催されます。';
  }

  @override
  String get msgWcQualDrawTitle => '世界選手権予選抽選';

  @override
  String get msgWcQualDrawBody => '世界選手権の予選グループが決まりました。';

  @override
  String msgContFinalsDrawTitle(String cup) {
    return '$cup本大会抽選';
  }

  @override
  String msgContFinalsDrawBody(String cup) {
    return '$cup本大会のグループが決まりました。';
  }

  @override
  String get msgWcFinalsDrawTitle => '世界選手権本大会抽選';

  @override
  String msgWcFinalsDrawBody(int year) {
    return '$year年世界選手権本大会の抽選が行われました。';
  }

  @override
  String get msgQualWcTitle1 => '世界選手権出場決定';

  @override
  String get msgQualWcTitle2 => '世界選手権の切符を獲得';

  @override
  String get msgQualWcTitle3 => '世界選手権へ行くぞ';

  @override
  String get msgQualWcTitle4 => '切符をつかんだ';

  @override
  String msgQualWcBody1(int year) {
    return '$year年世界選手権本大会への出場権を獲得しました。';
  }

  @override
  String msgQualWcBody2(int year) {
    return '正式決定です。あなたの国は$year年世界選手権に出場します。';
  }

  @override
  String msgQualWcBody3(int year) {
    return '$year年世界選手権の出場枠を確保しました。';
  }

  @override
  String msgQualWcBody4(int year) {
    return '$year年世界選手権本大会への出場が決まりました。';
  }

  @override
  String msgQualContTitle1(String cup) {
    return '$cup出場決定';
  }

  @override
  String msgQualContTitle2(String cup) {
    return '$cupの切符を獲得';
  }

  @override
  String msgQualContTitle3(String cup) {
    return '$cup出場権獲得';
  }

  @override
  String msgQualContBody1(String cup) {
    return '$cup本大会への出場権を獲得しました。';
  }

  @override
  String msgQualContBody2(String cup) {
    return 'あなたの国は$cupへの出場を決めました。';
  }

  @override
  String msgQualContBody3(String cup) {
    return '$cupへの出場が決まりました。';
  }

  @override
  String msgChampTitleMine1(String comp) {
    return '$comp優勝！';
  }

  @override
  String msgChampTitleMine2(String comp) {
    return '$comp王者！';
  }

  @override
  String msgChampTitleMine3(String comp) {
    return '$compを制覇しました！';
  }

  @override
  String msgChampTitleOther1(String comp) {
    return '$comp決着';
  }

  @override
  String msgChampTitleOther2(String comp) {
    return '$comp王者決定';
  }

  @override
  String msgChampTitleOther3(String comp) {
    return '$compの優勝国が決まる';
  }

  @override
  String msgChampBodyMine1(String comp, String loser, String result, int year) {
    return 'あなたの国が$year年$compの王者になりました。$loserを破っての優勝です$result。';
  }

  @override
  String msgChampBodyMine2(String comp, String loser, String result, int year) {
    return '$year年$compを制覇しました。$loserを退けての優勝です$result。';
  }

  @override
  String msgChampBodyMine3(String comp, String loser, String result, int year) {
    return '$year年$compはあなたのものです。$loserに勝利$result。';
  }

  @override
  String msgChampBodyOther1(
    String winner,
    String comp,
    String loser,
    String result,
    int year,
  ) {
    return '$winnerが$year年$compで優勝しました。$loserを破っての優勝です$result。';
  }

  @override
  String msgChampBodyOther2(
    String winner,
    String comp,
    String loser,
    String result,
    int year,
  ) {
    return '$winnerが$year年$compの王者に。$loserを下しました$result。';
  }

  @override
  String msgFinalScoreSuffix(int home, int away) {
    return ' （決勝 $home–$away）';
  }

  @override
  String msgFinalPensSuffix(int home, int away) {
    return ' （決勝 $home–$away、PK戦の末）';
  }

  @override
  String get msgWpotyTitle => '世界年間最優秀選手';

  @override
  String msgWpotyBodyMine(String name, String nation, int year) {
    return '$name（$nation）が$year年の世界年間最優秀選手に選ばれました。あなたのチームの選手です。';
  }

  @override
  String msgWpotyBodyOther(String name, String nation, int year) {
    return '$name（$nation）が$year年の世界年間最優秀選手に選ばれました。';
  }

  @override
  String get msgYpotTitle => '大会最優秀若手選手';

  @override
  String msgYpotBodyMine(String name, String nation, int age, int year) {
    return '$age歳の$name（$nation）が$year年の大会最優秀若手選手に選ばれました。あなたのチームの選手です。';
  }

  @override
  String msgYpotBodyOther(String name, String nation, int age, int year) {
    return '$age歳の$name（$nation）が$year年の大会最優秀若手選手に選ばれました。';
  }

  @override
  String msgRankHold1(int rank) {
    return '$rank位をキープ。';
  }

  @override
  String msgRankHold2(int rank) {
    return '変動なし、$rank位のまま。';
  }

  @override
  String msgRankHold3(int rank) {
    return '$rank位で安定。';
  }

  @override
  String msgRankUp1(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$moveランク',
    );
    return '合計$_temp0上昇し、$rank位に。';
  }

  @override
  String msgRankUp2(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$moveランク',
    );
    return '$_temp0上昇して$rank位に浮上。';
  }

  @override
  String msgRankUp3(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$moveランク',
    );
    return '$_temp0上昇、現在$rank位。';
  }

  @override
  String msgRankDown1(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$moveランク',
    );
    return '合計$_temp0下降し、$rank位に。';
  }

  @override
  String msgRankDown2(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$moveランク',
    );
    return '$_temp0下降して$rank位に後退。';
  }

  @override
  String msgRankDown3(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$moveランク',
    );
    return '$_temp0下降、現在$rank位。';
  }

  @override
  String get msgRankLeadYou => 'あなたの国が世界1位です。';

  @override
  String msgRankLeadOther(String nation) {
    return '世界1位は$nation。';
  }

  @override
  String msgRankTitle(int rank) {
    return '世界ランキング · $rank位';
  }

  @override
  String msgRankBody(String lead, String movement) {
    return '世界ランキングが更新されました。$lead $movement';
  }

  @override
  String msgRankJumpTitleUp(int rank) {
    return '$rank位に浮上';
  }

  @override
  String msgRankJumpTitleDown(int rank) {
    return '$rank位に後退';
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
      other: '$moveランク',
    );
    return '$tournamentで世界ランキングが動きました。$nationは大会前の$from位から$to位へ、$_temp0上昇しました。';
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
      other: '$moveランク',
    );
    return '$tournamentで世界ランキングが動きました。$nationは大会前の$from位から$to位へ、$_temp0下降しました。';
  }

  @override
  String get rankingSinceWcDraw => '世界選手権の抽選以降';

  @override
  String get rankingSinceCycleStart => 'キャンペーン開始以降';

  @override
  String rankingMovedFromTo(int from, int now) {
    return '$from位から$now位';
  }

  @override
  String msgCapsTitle(String name, int count) {
    return '$nameが$countキャップに到達';
  }

  @override
  String msgCapsBody(String name, int count) {
    return '$nameは代表通算$count試合に出場しました。';
  }

  @override
  String msgGoalsTitle(String name, int count) {
    return '$nameが$countゴールに到達';
  }

  @override
  String msgGoalsBody(String name, int count) {
    return '$nameは代表通算$countゴールを記録しました。';
  }

  @override
  String msgDevTitle(int year) {
    return 'チームの成長 · $year';
  }

  @override
  String msgThroughTitle(int year) {
    return 'アカデミーからの昇格 · $year';
  }

  @override
  String get msgThroughNote => '新入生ではありません。11歳で入団し、A代表候補にまで成長した若者たちです。';

  @override
  String msgNewFacesTitle(int year) {
    return '新顔 · $year';
  }

  @override
  String get msgIntakeNoteAcademy =>
      'アカデミーへの投資が実を結んでいます。今年の新入生は本来より高いレベルでやって来ました。';

  @override
  String get msgIntakeNoteStanding =>
      '国中がこのチームに注目しています。世界ランキングを駆け上がる代表に憧れ、優秀な少年たちがサッカーを選び、今年の新入生はその分レベルが上がりました。';

  @override
  String get msgIntakeNoteBoth =>
      'アカデミーへの投資と代表の世界ランキング上昇がともに表れています。今年の新入生は本来より高いレベルでやって来ました。';

  @override
  String msgIntakeTitle(int year) {
    return 'アカデミー新入生 · $year';
  }

  @override
  String msgRetireCaptainTitle(String name) {
    return 'キャプテン$nameが引退';
  }

  @override
  String msgRetireTitle(String name) {
    return '$nameが代表引退';
  }

  @override
  String msgRetireBody(String name, int age) {
    return '$nameが$age歳で代表から引退しました。';
  }

  @override
  String msgRetireBodyWith(String name, String tally, int age) {
    return '$nameが$age歳で代表から引退しました。通算成績は$tallyです。';
  }

  @override
  String msgTallyCaps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countキャップ',
    );
    return '$_temp0';
  }

  @override
  String msgTallyGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countゴール',
    );
    return '$_temp0';
  }

  @override
  String get msgArmbandVacant => ' キャプテンが空位です。招集画面から新しいキャプテンを指名してください。';

  @override
  String msgHofTitle(String name) {
    return '$nameが殿堂入り';
  }

  @override
  String msgHofBody(String name, int caps, int goals) {
    return '$nameが代表の殿堂入りを果たしました（$capsキャップ、$goalsゴール）。「レジェンド」で確認できます。';
  }

  @override
  String hubBanTitle(String name) {
    return '$nameが出場停止';
  }

  @override
  String hubBanBody(String name, String how, int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: '次の$matches試合',
      one: '次の試合',
    );
    return '$nameは$howため、$_temp0は出場停止です。メンバーに選ぶことはできません。';
  }

  @override
  String get hubBanHowSecondYellow => '2枚目の警告で退場となった';

  @override
  String get hubBanHowViolent => '暴力行為で一発退場となった';

  @override
  String get hubBanHowRed => '退場となった';

  @override
  String hubInjuryTitle(String name) {
    return '$nameが負傷';
  }

  @override
  String hubInjuryBody(String name, int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: '$matches試合',
    );
    return '$nameは負傷し、$_temp0欠場します。';
  }

  @override
  String get hubRunnerUpTitle1 => '準優勝';

  @override
  String get hubRunnerUpTitle2 => 'あと一歩届かず';

  @override
  String get hubRunnerUpTitle3 => '銀メダル';

  @override
  String hubRunnerUpBody1(String cup, String opponent) {
    return '$cup決勝に進出しましたが、$opponentに敗れました。あと少しでした。今回は銀メダルです。';
  }

  @override
  String hubRunnerUpBody2(String cup, String opponent) {
    return '$cup決勝で$opponentに敗戦。悔しい準優勝です。';
  }

  @override
  String hubRunnerUpBody3(String cup, String opponent) {
    return '$cup決勝は$opponentの手に。誇れることは多いですが、トロフィーには届きませんでした。';
  }

  @override
  String get hubKnockedOutTitle1 => '敗退';

  @override
  String get hubKnockedOutTitle2 => '道の終わり';

  @override
  String get hubKnockedOutTitle3 => '旅の終わり';

  @override
  String hubKnockedOutBody1(String cup, String opponent, String stage) {
    return '$stageで$opponentに敗れ、$cup敗退となりました。';
  }

  @override
  String hubKnockedOutBody2(String cup, String opponent, String stage) {
    return '$opponentによって、$cupは$stageで幕を閉じました。';
  }

  @override
  String hubKnockedOutBody3(String cup, String opponent, String stage) {
    return '$cupは$stageで終了。$opponentに敗れました。';
  }

  @override
  String get hubGroupExitTitle1 => 'グループステージ敗退';

  @override
  String get hubGroupExitTitle2 => 'グループステージで敗退';

  @override
  String get hubGroupExitTitle3 => '早すぎる帰国';

  @override
  String hubGroupExitBody1(String cup) {
    return '$cupはグループステージで終わりました。決勝トーナメントには届きませんでした。';
  }

  @override
  String hubGroupExitBody2(String cup) {
    return 'グループを突破できませんでした。$cupはここで終わりです。';
  }

  @override
  String hubGroupExitBody3(String cup) {
    return '今回は決勝トーナメント進出ならず。$cupはグループステージで終了です。';
  }

  @override
  String boardObjectiveMetTitle(String comp) {
    return '目標達成: $comp';
  }

  @override
  String boardObjectiveMissedTitle(String comp) {
    return '目標未達: $comp';
  }

  @override
  String boardObjectiveMetBody(String comp, String demand, String finish) {
    return '$compでの協会の目標: $demand。結果: $finish。協会の要求を満たしました。';
  }

  @override
  String boardObjectiveMissedBody(String comp, String demand, String finish) {
    return '$compでの協会の目標: $demand。結果: $finish。期待には届きませんでした。';
  }

  @override
  String get newsWcMissTitle => '世界選手権の夢、潰える';

  @override
  String newsWcMissBody(int year) {
    return '$year年世界選手権への出場はなりませんでした。予選で力が及びませんでした。また4年後です。';
  }

  @override
  String get newsRecordScorerTitle => '歴代最多得点者';

  @override
  String newsRecordScorerBody(String name, int goals) {
    return '$nameが$goalsゴールで歴代最多得点者になりました。';
  }

  @override
  String get newsRecordCapsTitle => '歴代最多キャップ';

  @override
  String newsRecordCapsBody(String name, int caps) {
    return '$nameが$caps試合出場で歴代最多キャップ保持者になりました。';
  }

  @override
  String get newsARecordBreaker => '新たな記録保持者';

  @override
  String newsTransferTitle(String name, String club) {
    return '$nameが$clubに加入';
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
    return '$name（$position、評価$rating）が$fromClubを離れ、$feeで$destinationと契約しました。';
  }

  @override
  String newsTransferAbroad(String club, String country) {
    return '$club（$country）';
  }

  @override
  String get newsTransferFree => '移籍金なし';

  @override
  String newsNatzStarTitle(String name, String nation) {
    return '$nameが$nation代表への変更を希望！';
  }

  @override
  String newsNatzTitle(String name, String nation) {
    return '$nameが$nation代表でのプレーを希望';
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
    return '現在$fromNationに所属する$age歳の$position、$name（評価$rating）は$nationに家族のルーツがあり、代表変更に前向きです。帰化の申し出を開いて受け入れるか断るかを決めてください。';
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
    return '現在$fromNationに所属する$age歳の$position、$name（評価$rating）はスター選手で、$nationに家族のルーツがあり、代表変更に前向きです。帰化の申し出を開いて受け入れるか断るかを決めてください。';
  }

  @override
  String get newsTheirNation => '元の国';

  @override
  String get newsYourNation => 'あなたの国';

  @override
  String get tourStatusChampions => '優勝';

  @override
  String get tourStatusFinals => '本大会';

  @override
  String get tourStatusQualifying => '予選';

  @override
  String get tourStatusUpcoming => '開催予定';

  @override
  String get tourStatusInProgress => '開催中';

  @override
  String get tourStatusComingSoon => '近日開始';

  @override
  String get tourStatusDecided => '決着';

  @override
  String tourStatusLeague(String letter) {
    return 'リーグ$letter';
  }

  @override
  String get tourDrawWcQualifying => '世界予選抽選';

  @override
  String tourDrawContQualifying(String cup) {
    return '$cup予選抽選';
  }

  @override
  String get tourDrawWcHost => '世界選手権開催国';

  @override
  String tourDrawContHost(String cup) {
    return '$cup開催国';
  }

  @override
  String get tourDrawHostsReveal => '開催国は…';

  @override
  String get tourDrawHostReveal => '開催国は…';

  @override
  String get tourDrawHostCandidates => '立候補国:';

  @override
  String get tourKickoffContinentalCup => '大陸選手権';

  @override
  String tourHostCompetitionYear(String competition, int year) {
    return '$competition $year';
  }

  @override
  String newsContMissTitle(String cup) {
    return '$cup出場ならず';
  }

  @override
  String newsContMissBody(String cup) {
    return '$cupの出場権を逃しました。今回は力が及びませんでした。';
  }

  @override
  String get potyLabelBest => '年間最優秀選手';

  @override
  String get potyLabelYoung => '年間最優秀若手選手';

  @override
  String potyTallyAssists(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countアシスト',
    );
    return '$_temp0';
  }

  @override
  String potyOverallValue(int value) {
    return '総合力 $value';
  }

  @override
  String potyRatingValue(String value) {
    return '平均評価 $value';
  }

  @override
  String newsPotyTitle(int year) {
    return '世界年間最優秀選手 $year';
  }

  @override
  String newsPotyBody(String name) {
    return '$nameが今年の世界最高の選手です。';
  }

  @override
  String newsPotyYoungSuffix(String name) {
    return ' 若手部門は$nameが受賞しました。';
  }

  @override
  String newsWatchTitle(int year) {
    return '注目の若手たち、$year';
  }

  @override
  String newsWatchJump(String name, int rating, int gain) {
    String _temp0 = intl.Intl.pluralLogic(
      gain,
      locale: localeName,
      other: '$gainポイント',
    );
    return '$nameは評価$ratingまで急成長し、昨年から$_temp0上昇しました。';
  }

  @override
  String newsWatchBand(String name, String band) {
    return '$nameが$bandに昇格しました。';
  }

  @override
  String newsWatchDebutTitle(String name) {
    return '$nameが代表デビュー';
  }

  @override
  String newsWatchDebutBody(String name, int age, int rating) {
    return '$nameが$age歳、評価$ratingで初キャップを獲得しました。あなたが注目している若手の一人です。';
  }

  @override
  String get matchStatsAtFullTime => 'ボール支配率、選手評価、MOTMは試合終了時に確定します。';

  @override
  String get matchPlayerRatings => '選手評価';

  @override
  String get matchSubstitutions => '選手交代';

  @override
  String get matchSubstitutes => '控え選手';

  @override
  String get matchPlayerOfTheMatch => 'マン・オブ・ザ・マッチ';

  @override
  String get matchGoalShout => 'ゴール！';

  @override
  String matchShootoutScore(int home, int away) {
    return 'PK戦 $home–$away';
  }

  @override
  String matchShootoutKickScored(String name) {
    return '$name: 成功';
  }

  @override
  String matchShootoutKickMissed(String name) {
    return '$name: 失敗';
  }

  @override
  String get matchFeedKickOff => 'キックオフ！';

  @override
  String get matchFeedNoEvents => 'まだ出来事はありません。';

  @override
  String get tourVenues => '会場';

  @override
  String tourPot(int number) {
    return 'ポット$number';
  }

  @override
  String get tourHostSelection => '開催国決定';

  @override
  String get tourCandidates => '立候補国';

  @override
  String get tourJointBid => '共同開催案';

  @override
  String get tourGoldenGlove => 'ゴールデングローブ';

  @override
  String get tourTeamOfTournament => '大会ベストイレブン';

  @override
  String get tourYourRun => 'あなたの歩み';

  @override
  String get tourMedalTable => 'メダル獲得数';

  @override
  String tourHostLine(String nation) {
    return '開催国: $nation';
  }

  @override
  String tourHostLineMulti(String hosts) {
    return '開催国: $hosts';
  }

  @override
  String tourGroupNamed(String name) {
    return 'グループ$name';
  }

  @override
  String get tourFinalsDrawBlurb => '世界ランキングでシード分け。抽選前に自国を見つけておきましょう。';

  @override
  String get tourWorldRanking => '世界ランキング';

  @override
  String get tourYourCompetitions => '参加大会';

  @override
  String get tourOtherContinents => '他の大陸';

  @override
  String get tourZoneGlobal => '世界';

  @override
  String get tourZoneEurope => '欧州';

  @override
  String get tourZoneSouthAmerica => '南米';

  @override
  String get tourZoneNorthAmerica => '北中米';

  @override
  String get tourZoneAfrica => 'アフリカ';

  @override
  String get tourZoneAsia => 'アジア';

  @override
  String get tourZoneOceania => 'オセアニア';

  @override
  String get tourZoneIntercontinental => '大陸間';

  @override
  String tourZoneLeague(String league) {
    return 'リーグ$league';
  }

  @override
  String tourHostedBy(String hosts) {
    return '開催国  $hosts';
  }

  @override
  String tourThirdsAdvance(int count, String destination) {
    return '上位$countチームが$destinationへ進出';
  }

  @override
  String newsWalkoutTitle(String name) {
    return '$nameが代表を去る';
  }

  @override
  String newsWalkoutBody(String name, int age, int caps) {
    return '$nameが$age歳、$capsキャップで代表から引退しました。自分の立場を教えてほしいと求めたものの答えはなく、もう待つつもりはないとのことです。';
  }

  @override
  String get pressHeadlineWent1 => '会見場を支配した監督';

  @override
  String get pressHeadlineWent2 => '記者は火種を求め、リーダーを見た';

  @override
  String get pressHeadlineWent3 => '率直な回答、確かな手応え';

  @override
  String get pressHeadlineMixed1 => '多くを語り、何も決まらず';

  @override
  String get pressHeadlineMixed2 => '八方美人、誰の心にも響かず';

  @override
  String get pressHeadlineMixed3 => '疑問を残した会見';

  @override
  String get pressHeadlineBadly1 => 'カメラの前で散々な午後';

  @override
  String get pressHeadlineBadly2 => '会見場の空気が一変、それが表に出た';

  @override
  String get pressHeadlineBadly3 => '翌朝の紙面でさらに悪く映る回答';

  @override
  String get pressHeadlineFlat1 => '何も語らず、何も得ず';

  @override
  String get pressHeadlineFlat2 => '10分間、ニュースなし';

  @override
  String get pressHeadlineFlat3 => 'スポーツ面に空白';

  @override
  String get pressConferenceTitle => '記者会見';

  @override
  String pressQuestionOf(int index, int total) {
    return '質問 $index/$total';
  }

  @override
  String get pressTomorrowsHeadline => '明日のスポーツ面';

  @override
  String get pressLeaveRoom => '会見を終える';

  @override
  String get pressRoomVerdictSquad => 'ロッカールーム';

  @override
  String get pressRoomVerdictBoard => '協会';

  @override
  String get yReactionElation0 => '言うことなし。完璧。';

  @override
  String get yReactionElation1 => '具合が悪い（いい意味で）。';

  @override
  String get yReactionElation2 => '額に入れて暖炉の上に飾る。';

  @override
  String get yReactionElation3 => '完全復活だ';

  @override
  String get yReactionElation4 => '疑ってた連中のためにスクショしとく。全員分。';

  @override
  String get yReactionElation5 => 'これから10年、この話でうざい奴になるから。';

  @override
  String get yReactionElation6 => 'そう。これがあるから見るんだ。';

  @override
  String get yReactionElation7 => 'こういう日があるから他の日も耐えられる。';

  @override
  String get yReactionElation8 => 'やっとだよ。本当に、やっと。';

  @override
  String get yReactionElation9 => 'いいね。来週もやってくれたら信じる。';

  @override
  String get yReactionElation10 => '今夜は楽しめ。どうせこの連中が台無しにする。';

  @override
  String get yReactionElation11 => 'いい夜が一つあっても、強豪になるわけじゃない。';

  @override
  String get yReactionRelief0 => '美しくはないけど、毎回これでいい。';

  @override
  String get yReactionRelief1 => 'なんとか。なんとか！';

  @override
  String get yReactionRelief2 => '泥臭い。勝点3。次。';

  @override
  String get yReactionRelief3 => '勝点がついてくるなら、泥臭くても一日中歓迎。';

  @override
  String get yReactionRelief4 => '寿命が10年縮んだ';

  @override
  String get yReactionRelief5 => '誰も喋るな。フラグを立てるな。';

  @override
  String get yReactionRelief6 => '心拍数: 許容範囲外。';

  @override
  String get yReactionRelief7 => '生き延びた。その一言に尽きる。生き延びた。';

  @override
  String get yReactionRelief8 => 'ああいう試合でホッとしてる場合じゃない。';

  @override
  String get yReactionRelief9 => 'ホッとした。そしてホッとしてる自分がちょっと恥ずかしい。';

  @override
  String get yReactionRelief10 => 'あれで喜んでるようじゃ、先が思いやられる。';

  @override
  String get yReactionRelief11 => 'ギリギリ勝ち抜くのが癖になってる。いい癖じゃない。';

  @override
  String get yReactionFury0 => '物足りない。全然。';

  @override
  String get yReactionFury1 => '誰かゆっくり説明してくれ。';

  @override
  String get yReactionFury2 => '見るに堪えない。これでも控えめに言ってる。';

  @override
  String get yReactionFury3 => 'がっかりだ。心底がっかり。';

  @override
  String get yReactionFury4 => 'ひどいありさまだ。';

  @override
  String get yReactionFury5 => '名前を出せ。';

  @override
  String get yReactionFury6 => 'アプリ削除。木曜に入れ直す。';

  @override
  String get yReactionFury7 => '勝ちたそうな選手は一人もいなかった。';

  @override
  String get yReactionFury8 => '4年ごとに同じ。毎回4年ごとに。';

  @override
  String get yReactionFury9 => 'あれはプレーじゃない、侮辱だ。';

  @override
  String get yReactionFury10 => '週末も金もつぎ込んで見に来る人がいるんだ。考えてくれ。';

  @override
  String get yReactionFury11 => '何年もこのチームを擁護してきた。今夜は無理。あれの後では。';

  @override
  String get yReactionDespair0 => 'はあ。';

  @override
  String get yReactionDespair1 => '今日は冗談なし。何も。';

  @override
  String get yReactionDespair2 => '散歩してくる。長いやつ。';

  @override
  String get yReactionDespair3 => 'もう言い方が思いつかない。';

  @override
  String get yReactionDespair4 => '4年後に起こして。';

  @override
  String get yReactionDespair5 => '最悪の世界線だ';

  @override
  String get yReactionDespair6 => 'もう怒りすら湧かない。それが一番まずい。';

  @override
  String get yReactionDespair7 => 'これは長いこと痛むな。';

  @override
  String get yReactionDespair8 => 'これが何なのかもうわからない。でもサッカーチームじゃない。';

  @override
  String get yReactionDespair9 => '前より遠ざかってるのに、誰もそれを言わない。';

  @override
  String get yReactionDespair10 => '一世代を丸ごと無駄にして、次も同じ人たちが決める。';

  @override
  String get yReactionDespair11 => '「プロセス」とか言うのはやめてくれ。どこにも向かってない。';

  @override
  String get yReactionSmugness0 => '控えめに言うけど、言ったでしょ。';

  @override
  String get yReactionSmugness1 => 'これ保存しといて';

  @override
  String get yReactionSmugness2 => '疑ってた連中がすっかり静かだね。';

  @override
  String get yReactionSmugness3 => '誰も数えてないだろうけど。私は数えてる。';

  @override
  String get yReactionSmugness4 => '1月に言ってたよ。タイムライン見て。';

  @override
  String get yReactionSmugness5 => '一部の人は一部の人に謝るべきだね。';

  @override
  String get yReactionSmugness6 => '「自分が最初に言ってたこと」フォルダに保存。';

  @override
  String get yReactionSmugness7 => 'ドヤらない。ちょっとだけドヤる。';

  @override
  String get yReactionSmugness8 => '専門家の皆さんは今どこに？素朴な疑問。';

  @override
  String get yReactionSmugness9 => '一人残らず、同じことを言い返してほしい。';

  @override
  String get yReactionSmugness10 => 'スクショして、印刷して、額に入れて、笑った人たちに送る。';

  @override
  String get yReactionSmugness11 => '一生この話を蒸し返すけど、あなたたちの自業自得だから。';

  @override
  String get yReactionShrug0 => '起きたことは起きた。次。';

  @override
  String get yReactionShrug1 => 'はいはい。どうでも。次へ。';

  @override
  String get yReactionShrug2 => '「サッカー」フォルダに保存。';

  @override
  String get yReactionShrug3 => '本当に付け加えることなし。';

  @override
  String get yReactionShrug4 => '何も考えてない、頭からっぽ';

  @override
  String get yReactionShrug5 => '次の試合で起こして。';

  @override
  String get yReactionShrug6 => '90分返してほしい。';

  @override
  String get yReactionShrug7 => '可もなく不可もなく、かな。';

  @override
  String get yReactionShrug8 => '何が起きたか一つも言えない。';

  @override
  String get yReactionShrug9 => 'またこういう試合。こういう試合、多いよね。';

  @override
  String get yReactionShrug10 => '全部見たけど、何も感じなかった。';

  @override
  String get yReactionShrug11 => '誰もこの話を二度としないなら、それで結構。';

  @override
  String get tourThirdsUneven =>
      'グループの規模が異なるため、大きいグループでは最下位チームとの結果を除外し、全チームを同じ試合数で比較します。';

  @override
  String get careerExportSave => 'このセーブをバックアップ';

  @override
  String get careerBackupAll => '全セーブをバックアップ';

  @override
  String get careerBackupAllFailed => 'バックアップを書き出せませんでした。';

  @override
  String get backupTitle => 'バックアップ';

  @override
  String get backupBlurb =>
      'すべてのセーブはこの端末内の1つのファイルに保存されており、下の自動バックアップをオンにしない限り、どこにもバックアップされません。端末の紛失やアプリの削除でキャリアを失わないよう、クラウドにコピーを保管しましょう。';

  @override
  String get backupBlurbNoAuto =>
      'すべてのセーブはこの端末内の1つのファイルに保存されており、自動ではどこにもバックアップされません。端末の紛失やアプリの削除でキャリアを失わないよう、クラウドにコピーを保管しましょう。';

  @override
  String get backupExport => 'クラウドにバックアップ';

  @override
  String get backupExportSubject => 'FNMセーブデータ';

  @override
  String get backupRestore => 'ファイルから復元';

  @override
  String get backupRestoreWarnTitle => '全セーブを置き換えますか？';

  @override
  String get backupRestoreWarnBody =>
      '復元すると、この端末のすべてのセーブがファイル内のものに置き換わります。アプリは再起動します。';

  @override
  String get backupRestoreConfirm => '置き換える';

  @override
  String get backupCancel => 'キャンセル';

  @override
  String get backupExported => 'バックアップの準備ができました。保存先を選んでください。';

  @override
  String get backupFailed => 'バックアップを書き出せませんでした。';

  @override
  String get backupRejectedUnreadable => 'そのファイルを開けませんでした。';

  @override
  String get backupRejectedNotFnm => 'FNMのセーブデータではありません。';

  @override
  String get backupRejectedNewer =>
      'このセーブは新しいバージョンのアプリで作成されています。先にアップデートしてください。';

  @override
  String get backupRejectedTooOld => 'このセーブは古すぎて、このバージョンでは復元できません。';

  @override
  String get careerShare => 'このキャリアを共有';

  @override
  String get careerImport => 'キャリアを読み込む';

  @override
  String get careerShareSubject => 'FNMのキャリア';

  @override
  String get careerImported => 'キャリアを読み込みました。';

  @override
  String get careerImportFailedUnreadable => 'そのファイルはFNMのキャリアではありません。';

  @override
  String get careerImportFailedNewer =>
      'このキャリアは新しいバージョンのアプリで書き出されています。先にアップデートしてください。';

  @override
  String get careerImportFailedSlotsFull =>
      'セーブスロットがすべて使用中です。セーブを削除して空きを作るか、セーブ数無制限を解除してください。';

  @override
  String get careerImportFailedNeedsPremium =>
      'このキャリアは無料の最初のサイクルを過ぎています。読み込むにはフル版を解除してください。';

  @override
  String get careerImportFailedCampaignRun =>
      'そのキャンペーンはすでに進行中です。先に再開するか破棄してください。';

  @override
  String get careerShareFailed => 'キャリアを書き出せませんでした。';

  @override
  String get managerRename => '名前を変更';

  @override
  String get managerRenameSave => '保存';

  @override
  String get managerTitle => '監督';

  @override
  String get managerSkills => 'あなたのスキル';

  @override
  String managerPointsAvailable(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '使えるポイント: $count',
      zero: '使えるポイントはありません',
    );
    return '$_temp0';
  }

  @override
  String get managerPointsHow => 'サイクルを1つ終えるごとに2ポイント、タイトル1つごとに1ポイント獲得します。';

  @override
  String get managerSkillsScale => '各スキルは5から始まり、上限は20です。使ったポイントは戻せません。';

  @override
  String get managerSkillManManagement => '人心掌握';

  @override
  String get managerSkillManManagementBlurb =>
      '1ポイントごとに、記者や選手へのあなたの言葉がロッカールームに3%強く響きます。';

  @override
  String get managerSkillTactical => '戦術';

  @override
  String get managerSkillTacticalBlurb =>
      '1ポイントごとに新しいフォーメーションの浸透が3%速くなり、布陣変更のロスが減ります。';

  @override
  String get managerSkillYouth => '育成';

  @override
  String get managerSkillYouthBlurb => '1ポイントごとに、投資額に加えてアカデミー出身選手の才能が1%上がります。';

  @override
  String get managerSkillNegotiation => '交渉';

  @override
  String get managerSkillNegotiationBlurb =>
      '1ポイントごとに、毎サイクル協会から引き出せる資金が2%増えます。';

  @override
  String get managerStaff => 'スタッフ';

  @override
  String managerStaffWages(String amount) {
    return '給与: 1サイクルあたり$amount';
  }

  @override
  String get managerRoleAssistant => 'アシスタントマネージャー';

  @override
  String get managerRoleAssistantBlurb => '練習を取り仕切る。負傷が減り、より良い若手が育つ。';

  @override
  String get managerRoleScout => 'チーフスカウト';

  @override
  String get managerRoleScoutBlurb => '有望株と次の対戦相手を分析。より正確な星評価と、試合当日のアドバンテージ。';

  @override
  String get managerRoleFitness => 'フィジカルコーチ';

  @override
  String get managerRoleFitnessBlurb => '選手をピッチに立たせ続ける。';

  @override
  String staffEffectInjury(int percent) {
    return '負傷が$percent%減少';
  }

  @override
  String staffEffectYouth(int points) {
    return '若手の総合力 +$points';
  }

  @override
  String staffHiringInjury(int min, int max) {
    return '雇用すると: 負傷が$min%〜$max%減少';
  }

  @override
  String staffHiringYouth(int minPoints, int maxPoints) {
    return '若手の総合力 +$minPoints〜+$maxPoints';
  }

  @override
  String staffEffectScoutRead(int percent) {
    return '有望株の$percent%を正確に評価';
  }

  @override
  String staffEffectScoutCaps(int caps) {
    String _temp0 = intl.Intl.pluralLogic(
      caps,
      locale: localeName,
      other: '$capsキャップで潜在能力が判明',
      one: '1キャップで潜在能力が判明',
    );
    return '$_temp0';
  }

  @override
  String staffEffectScoutDossier(int points) {
    return '対戦相手の分析で評価 +$points';
  }

  @override
  String staffHiringScoutRead(int min, int max) {
    return '雇用すると: $min%〜$max%を正確に評価';
  }

  @override
  String staffHiringScoutCaps(int minCaps, int maxCaps) {
    return '潜在能力の判明が$minCaps〜$maxCapsキャップ早まる';
  }

  @override
  String staffHiringScoutDossier(int minPoints, int maxPoints) {
    return '毎試合の評価 +$minPoints〜+$maxPoints';
  }

  @override
  String get staffEffectNone => 'まだチームへの効果はありません';

  @override
  String get staffVacant => '空席';

  @override
  String get staffLeaveVacant => '空席のままにする';

  @override
  String get managerTierNone => 'なし';

  @override
  String get managerTierBasic => 'ベーシック';

  @override
  String get managerTierGood => '優秀';

  @override
  String get managerTierElite => 'エリート';

  @override
  String get managerFree => '無料';

  @override
  String get managerTraining => '代表活動の合間';

  @override
  String get managerTrainingBlurb => '試合がない期間にチームが取り組む内容。';

  @override
  String get managerFocusBalanced => 'バランス';

  @override
  String get managerFocusBalancedBlurb => 'まんべんなく少しずつ。';

  @override
  String get managerFocusFitness => 'フィットネス';

  @override
  String get managerFocusFitnessBlurb => '負傷が減る。';

  @override
  String get managerFocusCohesion => '連携';

  @override
  String get managerFocusCohesionBlurb => '布陣の浸透が速くなる。';

  @override
  String get managerFocusYouth => '若手';

  @override
  String get managerFocusYouthBlurb => '候補の最年少選手たちと過ごす時間。';

  @override
  String get tourOfferTitle => '初めてですか？';

  @override
  String get tourOfferBody =>
      'これは奥の深いゲームです。重要な画面を手短に案内しましょうか？1分ほどで終わり、設定からいつでもやり直せます。';

  @override
  String get tourOfferYes => '案内してほしい';

  @override
  String get tourOfferNo => '結構です';

  @override
  String get tourBack => '戻る';

  @override
  String get tourNext => '次へ';

  @override
  String get tourDone => '完了';

  @override
  String get tourSkip => 'スキップ';

  @override
  String get tourHubTitle => 'ゲームのすべてはここに';

  @override
  String get tourHubBody =>
      'ボタンは1つ。サイクルの進行に合わせて変わります。抽選を見る、メンバーを選ぶ、試合をする。その上には協会からの信頼度と、協会が設定した目標が表示されます。';

  @override
  String get tourBudgetTitle => '協会の資金';

  @override
  String get tourBudgetBody =>
      '4年に一度のサイクルごとに、資金を各部門に配分します。スタッフの給与が最初に差し引かれるため、エリートスカウトを雇うことはアカデミーとの両立ではなく、二者択一の決断になります。';

  @override
  String get tourTacticsTitle => 'チームの戦い方';

  @override
  String get tourTacticsBody =>
      '布陣、戦い方、キャプテン、セットプレーのキッカー。後の2つを未設定のままにすると、勝手に選ばれるのではなく、キックオフ前に警告が出ます。';

  @override
  String get tourSquadTitle => '選べる全選手';

  @override
  String get tourSquadBody =>
      '招集メンバーだけでなく候補全体。誰が好調か、誰が負傷を抱えているか、誰が出場停止か、誰がアカデミーから上がってきたばかりか。';

  @override
  String get tourCallUpsTitle => 'メンバー選考';

  @override
  String get tourCallUpsBody =>
      '国際試合期間ごとに1つのメンバーを選び、その期間の全試合を戦います。本物の代表監督と同じです。期間中に負傷者が出れば、代わりの選手が招集されます。';

  @override
  String get tourRecordsTitle => 'あなたのキャリア';

  @override
  String get tourRecordsBody => 'あなたが成し遂げたすべて。試合、チーム記録、トロフィー、そして指揮したすべての国。';

  @override
  String get tourCupsTitle => '世界の動き';

  @override
  String get tourCupsBody =>
      '現在進行中のすべての大会。グループ、順位表、ノックアウト、自国が出ていない大会も含みます。出場できてもできなくても、世界は回り続けます。';

  @override
  String get settingsTourTitle => 'チュートリアルを再生';

  @override
  String get settingsTourBlurb => '主要な画面を最初からもう一度案内します。';

  @override
  String get tourBoardTitle => 'あなたの上司';

  @override
  String get tourBoardBody => '協会からの信頼度と、今サイクルの目標。目標を外しそうなとき、その兆しはここに表れます。';

  @override
  String get tourStaffTitle => 'あなたを支える人々';

  @override
  String get tourStaffBody =>
      'アシスタント、スカウト、フィジカルコーチを名指しで雇います。給与は各部門より先にこの予算から差し引かれるため、優秀なスカウトはアカデミーとの二者択一になります。';

  @override
  String get tourPlaystyleTitle => 'あなたの戦い方';

  @override
  String get tourPlaystyleBody =>
      '布陣は戦術の半分にすぎません。残りの半分がこれです。どこまで高くプレスをかけるか、どれだけダイレクトに攻めるか、どれだけリスクを取るか。';

  @override
  String get settingsTourNoSave => 'まずキャリアを始めてください。案内ではあなた自身の画面を巡ります。';

  @override
  String tacticsOutOfPositionAge(int age) {
    return '本職外 · $age歳';
  }

  @override
  String get federationNextCycleLocked =>
      '次のサイクルの予算は、そのサイクルの開始時に一括で決まります。それまでは、これが資金の使われ方です。';

  @override
  String get federationBudgetAlreadySet => '今サイクルは設定済み';

  @override
  String yFinalLooms0(String opponent) {
    return '大一番の相手は$opponent。今週は誰もがこの話しかしないだろう。';
  }

  @override
  String yFinalLooms1(String opponent) {
    return '決まった。頂点との間に立つのは$opponent。この4年はこのためにあった。';
  }

  @override
  String yFinalLooms2(String opponent) {
    return 'よし。$opponent。これが終わるまで誰も眠れない。';
  }

  @override
  String yFinalLooms3(String opponent) {
    return '次は$opponent、他のことは全部後回し。生きててよかった1週間だ。';
  }

  @override
  String get matchSetupLeaveToCoach => 'キッカーはコーチに任せる';

  @override
  String friendliesLikeYourGroup(String rivals) {
    return '印付き: 今サイクルのグループで当たる$rivalsと似たスタイルのチーム。';
  }

  @override
  String newsTransferWindowTitle(int year) {
    return '移籍市場 · $year';
  }

  @override
  String careerLastAgo(String when) {
    return '最終 $when前';
  }

  @override
  String get settingsFreeScopeTitle => '4年間の1サイクルを無料で';

  @override
  String get settingsFreeScopeBlurb =>
      '1サイクルを丸ごと（予選、大陸選手権、世界選手権）2つのセーブで。世界中のすべての国が選べ、制限は一切ありません。無制限のサイクルとセーブ数無制限は1回限りの支払いで、今後のアップデートもすべて含まれます。';

  @override
  String get settingsUnlockedTitle => '解除済み';

  @override
  String get settingsUnlockedBlurb =>
      '無制限のサイクル、セーブ数無制限、今後のすべてのアップデート。ありがとうございます。';

  @override
  String get settingsFromDeveloperTitle => '開発者より';

  @override
  String get settingsFromDeveloperBlurb =>
      'Football Nations Managerは一人で開発しており、長期にわたってサポートしていきます。広告や課金アイテムを入れることは決してありません。ゲームを楽しんでいただけたら、ぜひフル版のご購入をご検討ください。それがアップデートを続ける力になります。';

  @override
  String get settingsFromDeveloperThanksBlurb =>
      'Football Nations Managerは一人で開発しており、長期にわたってサポートしていきます。広告や課金アイテムを入れることは決してありません。フル版をご購入いただき、ありがとうございます。それがアップデートを続ける力になります。';

  @override
  String friendliesLikeYourCampaign(String rivals) {
    return '印付き: これから対戦する$rivalsと似たスタイルのチーム。';
  }

  @override
  String get friendliesCloseToYou =>
      '印付き: 世界ランキングが近いチーム。抽選後は、所属グループに合わせて印が変わります。';

  @override
  String transfersMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count件の移籍',
      one: '1件の移籍',
    );
    return '$_temp0';
  }

  @override
  String hubRoundPage(int page, int pages) {
    return '$page / $pages';
  }

  @override
  String get transfersNewer => '新しい順';

  @override
  String get transfersOlder => 'さらに表示';

  @override
  String get transfersPagePrevious => '前へ';

  @override
  String get transfersPageNext => '次へ';

  @override
  String transfersPageOf(int page, int pages) {
    return '$pagesページ中$pageページ';
  }

  @override
  String get transfersMovedTo => '移籍先';

  @override
  String get transfersUnknownClub => '不明なクラブ';

  @override
  String yAgainstThemAgain0(String opponent, String count) {
    return 'これで$opponentとは$count回目。誰かがスコアをつけていて、それは向こうだ。';
  }

  @override
  String yAgainstThemAgain1(String opponent, String count) {
    return 'また$opponent。$count回も対戦して、いまだに攻略できていない。';
  }

  @override
  String yAgainstThemAgain2(String opponent, String count) {
    return '$opponentと$count回目。もう偶然じゃない。';
  }

  @override
  String yAgainstThemAgain3(String opponent, String count) {
    return '$opponentとは$count回も戦って、一度も何も学んでいない。';
  }

  @override
  String yAgainstThemAgain4(String opponent, String count) {
    return '$opponentと$count回。こっちのやることは全部読まれてる。';
  }

  @override
  String yAgainstThemAgain5(String opponent, String count) {
    return '$count回対戦しても、$opponentが持ってる何かをまだ崩せない。';
  }

  @override
  String ySameOldStory0(String count) {
    return '最近これで$count回目。いつになったら、これが自分たちの実力だと認める？';
  }

  @override
  String ySameOldStory1(String count) {
    return 'こんな午後がもう$count回。運じゃない、パターンだ。';
  }

  @override
  String ySameOldStory2(String count) {
    return '最近まったく同じ試合を$count回見た。同じ台本、同じ結末。';
  }

  @override
  String ySameOldStory3(String count) {
    return '同じ90分がもう$countバージョン。誰も直そうとしない。';
  }

  @override
  String ySameOldStory4(String count) {
    return '$count回。今になってもパターンが見えないなら、見ようとしていないだけだ。';
  }

  @override
  String ySameOldStory5(String count) {
    return '同じ話が$count回。結果より先に言い訳が尽きた。';
  }

  @override
  String get yToldYouSo0 => 'みんなが浮かれてる間に、こうなるって言ってたんだ。';

  @override
  String get yToldYouSo1 => '2週間調子が良かっただけでまた黄金世代扱い。で、この有様。';

  @override
  String get yToldYouSo2 => '先月「楽しめよ」と言ってきた人たちがすっかり静かだ。';

  @override
  String get yToldYouSo3 => 'これっぽっちも嬉しくない。ほんの少ししか。いや、ちょっとは。';

  @override
  String get yToldYouSo4 => '言われてたほど良かったことなんて一度もない。これがその証拠。';

  @override
  String get yToldYouSo5 => '毎回だ。今度は違うと言われて、毎回違わない。';

  @override
  String get tacticsSubOffAlready => '交代済み';

  @override
  String get tacticsSubInjured => '負傷';

  @override
  String get tacticsSubSentOffMark => '退場';

  @override
  String get tacticsSubNoneLeft => '交代枠なし';

  @override
  String get tacticsUndoLastChange => '直前の変更を取り消す';

  @override
  String get matchStrengthTitle => 'チームを左右する要素';

  @override
  String get strengthFactorFamiliarity => '布陣の浸透';

  @override
  String get strengthFactorFatigue => '疲労';

  @override
  String get strengthFactorClubForm => 'クラブでの調子';

  @override
  String get strengthFactorMorale => 'ロッカールーム';

  @override
  String get strengthFactorCaptain => 'キャプテン';

  @override
  String get strengthFactorStaff => 'スタッフ';

  @override
  String get strengthFactorDossier => 'スカウトの分析';

  @override
  String yDebut0(String name) {
    return '$nameが初キャップ。この名前を覚えておけ。';
  }

  @override
  String yDebut1(String name) {
    return '$nameがデビュー。何か持ってるのがわかるだろ？';
  }

  @override
  String yDebut2(String name) {
    return '$name、初キャップ。どうするか見てみよう。';
  }

  @override
  String yDebut3(String name) {
    return '$nameがデビュー。チームにはどこかで新しい血が必要だった。';
  }

  @override
  String yDebut4(String name) {
    return '$nameにキャップ。最近キャップを配りすぎじゃないか。';
  }

  @override
  String yDebut5(String name) {
    return '$nameがデビュー。また春には忘れられてる一人だろう。';
  }

  @override
  String yDrought0(String name, String count) {
    return '$nameは$count試合ノーゴールだが、ピッチ上ではそれ以外のすべてをこなしている。';
  }

  @override
  String yDrought1(String name, String count) {
    return '$nameは$count試合ゴールなし。ゴールはまとめて来るもの、昔からそうだ。';
  }

  @override
  String yDrought2(String name, String count) {
    return '$name: $count試合、ゴールなし。';
  }

  @override
  String yDrought3(String name, String count) {
    return '$nameが$count試合ノーゴール。注意して見ておきたい。';
  }

  @override
  String yDrought4(String name, String count) {
    return '$count試合。ゴールなし。$nameは目の前の壁にも当てられない。';
  }

  @override
  String yDrought5(String name, String count) {
    return '$nameは$count試合決めていない。他の誰でもいいから使ってくれ。';
  }

  @override
  String yRivalryLooms0(String opponent, String count) {
    return '次は$opponent。$count回目の対戦でも、すべてを懸ける意味がある。';
  }

  @override
  String yRivalryLooms1(String opponent, String count) {
    return 'これで$opponentとは$count回目。かかってこい。';
  }

  @override
  String yRivalryLooms2(String opponent, String count) {
    return '次は$opponent。対戦$count回。';
  }

  @override
  String yRivalryLooms3(String opponent, String count) {
    return '今週、$opponentと$count回目の対戦。';
  }

  @override
  String yRivalryLooms4(String opponent, String count) {
    return 'また$opponent。$count回やって何も学んでいない。';
  }

  @override
  String yRivalryLooms5(String opponent, String count) {
    return '$opponentと$count試合、それでもまだ負ける。素晴らしい。';
  }

  @override
  String get positionGoalkeeper => 'ゴールキーパー';

  @override
  String get positionLeftBack => '左サイドバック';

  @override
  String get positionCentreBack => 'センターバック';

  @override
  String get positionRightBack => '右サイドバック';

  @override
  String get positionDefensiveMid => '守備的MF';

  @override
  String get positionCentralMid => 'セントラルMF';

  @override
  String get positionAttackingMid => '攻撃的MF';

  @override
  String get positionLeftMid => '左MF';

  @override
  String get positionRightMid => '右MF';

  @override
  String get positionLeftWing => '左ウイング';

  @override
  String get positionRightWing => '右ウイング';

  @override
  String get positionStriker => 'ストライカー';

  @override
  String get roleNone => '役割なし';

  @override
  String get roleTargetMan => 'ターゲットマン';

  @override
  String get rolePoacher => 'ポーチャー';

  @override
  String get rolePlaymaker => '司令塔';

  @override
  String get roleBallWinner => 'ボールハンター';

  @override
  String get roleInvertedWinger => 'インバーテッドウイング';

  @override
  String get roleBallPlayingDefender => 'ビルドアップDF';

  @override
  String get roleNoneBlurb => '本来のプレーをする。';

  @override
  String get roleTargetManBlurb => '空中戦で競り勝ち、落とす。アシストとセットプレー。';

  @override
  String get rolePoacherBlurb => 'ゴール前に潜む。ゴールが大幅に増える。';

  @override
  String get rolePlaymakerBlurb => 'チャンスを作る。アシストが大幅に増える。';

  @override
  String get roleBallWinnerBlurb => '攻撃を仕上げるより、相手の攻撃を潰す。';

  @override
  String get roleInvertedWingerBlurb => '中に切り込んでシュート。ゴールが増える。';

  @override
  String get roleBallPlayingDefenderBlurb => '最終ラインから攻撃を組み立てる。';

  @override
  String get federationDeptYouth => 'ユースアカデミー';

  @override
  String get federationDeptCommercial => '営業・広報';

  @override
  String get federationDeptMedical => '医療・スポーツ科学';

  @override
  String get federationDeptNaturalisation => '帰化担当';

  @override
  String get federationDeptBoardRelations => '協会対応';

  @override
  String get federationDeptYouthBlurb => '次のサイクルでより優秀なアカデミー出身選手が代表デビューする。';

  @override
  String get federationDeptCommercialBlurb => 'スポンサー契約により、サイクル終了時に追加収入が入る。';

  @override
  String get federationDeptMedicalBlurb => '負傷が減り、サイクルを通じてチームが万全に保たれる。';

  @override
  String get federationDeptNaturalisationBlurb => '代表変更を申し出る外国籍選手が増える。';

  @override
  String get federationDeptBoardRelationsBlurb => '協会があなたの成績をより寛容に評価する。';

  @override
  String get federationBuildingAcademy => 'アカデミー';

  @override
  String get federationBuildingCommercial => '営業本部';

  @override
  String get federationBuildingMedical => 'メディカルセンター';

  @override
  String get federationBuildingScouting => 'スカウト室';

  @override
  String get federationBuildingBoardroom => '役員室';

  @override
  String get moraleBuoyant => '絶好調';

  @override
  String get moralePositive => '良好';

  @override
  String get moraleSettled => '安定';

  @override
  String get moraleUneasy => '不安';

  @override
  String get moraleRockBottom => '最悪';

  @override
  String get matchTabTimeline => '経過';

  @override
  String get matchTabStats => 'スタッツ';

  @override
  String get matchTabLineups => 'メンバー';

  @override
  String get matchPenalty => 'PK';

  @override
  String get matchStateLevel => '同点です';

  @override
  String matchStateLead(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count点リードしています',
      one: '1点リードしています',
    );
    return '$_temp0';
  }

  @override
  String matchStateTrail(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count点ビハインドです',
      one: '1点ビハインドです',
    );
    return '$_temp0';
  }

  @override
  String matchPossessionShare(int possession) {
    return 'ボール支配率$possession%';
  }

  @override
  String get boardVerdictSackedTitle => '協会はあなたを解任しました';

  @override
  String boardVerdictSackedBody(int rating) {
    return '惨憺たるサイクルでした（評価$rating%）。あなたの時代はここで終わります。今後あなたを雇うのは格下の国だけでしょう。';
  }

  @override
  String get boardVerdictDelightedTitle => '協会は大満足です';

  @override
  String boardVerdictDelightedBody(int rating, String best) {
    return '$bestを経た、傑出したサイクルでした（評価$rating%）。より大きな国が関心を示していますが、留まってチームを築くこともできます。';
  }

  @override
  String get boardVerdictSolidTitle => '堅実なサイクル';

  @override
  String boardVerdictSolidBody(int rating) {
    return '協会は満足しています（評価$rating%）。同程度の国がいくつか声をかけていますが、移る必要はありません。';
  }

  @override
  String get boardVerdictExpectedMoreTitle => '協会はもっと期待していました';

  @override
  String boardVerdictExpectedMoreBody(int rating) {
    return '期待外れのサイクルでした（評価$rating%）。職は守られましたが、届くオファーは格下ばかりです。';
  }

  @override
  String get boardVerdictPressureTitle => '厳しい立場に立たされています';

  @override
  String boardVerdictPressureBody(int rating) {
    return '不振のサイクルでした（評価$rating%）。続投は決まりましたが、新天地を求めるなら関心を示すのは弱小国だけです。';
  }

  @override
  String get boardVerdictHeroTitle => '国はあなたを支持しています';

  @override
  String boardVerdictHeroNote(String nation, int cycles) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cyclesサイクル',
    );
    return ' $nationの人々は$_temp0を経たあなたを国民的英雄として愛しています。望む限り、あなたの職は安泰です。';
  }

  @override
  String get boardVerdictTheNation => '国民';

  @override
  String get boardVerdictBestQuiet => '静かなサイクル';

  @override
  String get boardVerdictBestCycle => 'このサイクル';

  @override
  String boardVerdictBestWorld(String placement) {
    return '世界選手権での$placement';
  }

  @override
  String get finishThirdPlace => '3位';

  @override
  String get finishFourthPlace => '4位';

  @override
  String get finishDidNotQualify => '予選敗退';

  @override
  String get careerRepIconic => '伝説的';

  @override
  String get careerRepRenowned => '名声あり';

  @override
  String get careerRepEstablished => '実績あり';

  @override
  String get careerRepRising => '新進気鋭';

  @override
  String get careerRepUnproven => '未知数';

  @override
  String get hubOfferStepUp => 'ステップアップ';

  @override
  String get hubOfferLateral => '同格への移籍';

  @override
  String get hubOfferRebuild => '再建';

  @override
  String careerNationsCupWon(String league) {
    return 'リーグ$league · 優勝';
  }

  @override
  String careerNationsCupRunnerUp(String league) {
    return 'リーグ$league · 準優勝';
  }

  @override
  String careerNationsCupSemi(String league) {
    return 'リーグ$league · ベスト4';
  }

  @override
  String careerNationsCupPlaced(String league, int position) {
    return 'リーグ$league · $position位';
  }

  @override
  String tourRunInto(String round) {
    return '$roundへ';
  }

  @override
  String get tourRunIntoThirdPlace => '3位決定戦へ';

  @override
  String tourRunThrough(String round) {
    return '$roundを突破';
  }

  @override
  String tourRunOut(String round) {
    return '$roundで敗退';
  }

  @override
  String get tourRunInGroup => 'グループステージ戦い中';

  @override
  String get tourRunGroupOut => 'グループステージ敗退';

  @override
  String resultsCycleTitle(int year, String nation) {
    return '$year年サイクル · $nation';
  }

  @override
  String resultsCycleRecord(int played, int won, int drawn, int lost) {
    return '$played試合  ·  $won勝$drawn分$lost敗';
  }

  @override
  String resultsCycleFinish(String finish) {
    return '世界選手権: $finish';
  }

  @override
  String get resultsCycleUnderway => '進行中';

  @override
  String yTurnedItRound0(String opponent) {
    return 'ハーフタイムで$opponentに2点ビハインド、それを全部取り返した。これがチームだ。';
  }

  @override
  String yTurnedItRound1(String opponent) {
    return '$opponentに2点差をつけられて、終わってみれば関係なかった。そうできるチームは多くない。';
  }

  @override
  String yTurnedItRound2(String opponent) {
    return '前半終了: $opponentに2点ビハインド。試合終了: そうじゃない。後半は別の試合だった。';
  }

  @override
  String yTurnedItRound3(String opponent) {
    return '$opponent相手に2点差から追いついた。ハーフタイムに何を言ったにせよ、毎週言ってくれ。';
  }

  @override
  String yTurnedItRound4(String opponent) {
    return 'まあ、$opponent相手に取り返したよ。じゃあ誰か前半45分を説明してくれ。';
  }

  @override
  String yTurnedItRound5(String opponent) {
    return '$opponentに2点ビハインドから追いついて大喜びしろって？前半をどうにかしろ。';
  }

  @override
  String yThrewItAway0(String opponent) {
    return 'ハーフタイムで$opponentに2点リード、それが消えた。もっと強いチームにも起きること。';
  }

  @override
  String yThrewItAway1(String opponent) {
    return '$opponentに2点リードして、逃げられた。サイクルは長い、時間はたっぷりある。';
  }

  @override
  String yThrewItAway2(String opponent) {
    return '前半終了: $opponentに2点リード。試合終了: 見る影もなし。';
  }

  @override
  String yThrewItAway3(String opponent) {
    return '$opponent相手の2点リードが、45分のうちに消えた。';
  }

  @override
  String yThrewItAway4(String opponent) {
    return '2点リードして失った。$opponent相手に。誰かが責任を取れ。';
  }

  @override
  String yThrewItAway5(String opponent) {
    return '$opponentに2点リードして、これだ。毎回、毎回。';
  }

  @override
  String get cycleBackupDone =>
      'キャリアをこの端末のFNMフォルダにバックアップしました。アプリを削除すると消えます。別の場所にコピーを残すには、セーブ画面の「このセーブをバックアップ」を使ってください。';

  @override
  String get cycleBackupFailed => '今回はキャリアをバックアップできませんでした。';

  @override
  String pressMomentBigWinWarm1(String opponent) {
    return '$opponent戦は忘れられない夜になりました。このチームをどれほど誇りに思いますか？';
  }

  @override
  String pressMomentBigWinWarm2(String opponent) {
    return '$opponentは太刀打ちできませんでした。これがずっと信じてきたチームの姿ですか？';
  }

  @override
  String pressMomentBigWinNeutral1(String opponent) {
    return '$opponentに大勝しました。今夜の勝因は何でしたか？';
  }

  @override
  String pressMomentBigWinNeutral2(String opponent) {
    return '$opponentに快勝です。どこで勝負を決めましたか？';
  }

  @override
  String pressMomentBigWinHostile1(String opponent) {
    return '$opponentに良い勝利でした。一晩良かっただけで、なぜ続くと信じられるのでしょう？';
  }

  @override
  String pressMomentBigWinHostile2(String opponent) {
    return '$opponent相手に見事な結果でした。あれはあなたのプランですか、それとも選手たちが自分で解決したのですか？';
  }

  @override
  String pressMomentBigLossWarm1(String opponent) {
    return '$opponent戦は辛い夜になりました。ああいう試合の後、選手たちに何と声をかけますか？';
  }

  @override
  String pressMomentBigLossWarm2(String opponent) {
    return '$opponent戦の結果は誰も予想していませんでした。ただの悪い夜だったのでしょうか？';
  }

  @override
  String pressMomentBigLossNeutral1(String opponent) {
    return '$opponent戦は痛い教訓となる夜でした。何がうまくいかなかったのですか？';
  }

  @override
  String pressMomentBigLossNeutral2(String opponent) {
    return '$opponentに完膚なきまでにやられました。このチームは十分な力を持っていますか？';
  }

  @override
  String pressMomentBigLossHostile1(String opponent) {
    return '$opponent相手にすべてで後手に回りました。なぜここまでひどくなるのを許したのですか？';
  }

  @override
  String pressMomentBigLossHostile2(String opponent) {
    return '$opponentに好きなように点を取られました。今夜のプランはどこにあったのですか？';
  }

  @override
  String pressMomentCrisisWarm1(String opponent) {
    return 'またも勝利を逃しました。今度は$opponent戦です。この流れをどう変えますか？';
  }

  @override
  String pressMomentCrisisWarm2(String opponent) {
    return '結果が出なくなり、$opponent戦でさらに悪化しました。今もこのチームを信じていますか？';
  }

  @override
  String pressMomentCrisisNeutral1(String opponent) {
    return '$opponent戦でもまた勝てず、協会も注視しています。あなたの職は安泰ですか？';
  }

  @override
  String pressMomentCrisisNeutral2(String opponent) {
    return '$opponent戦を経て、不振が長引いています。自身の去就に不安はありますか？';
  }

  @override
  String pressMomentCrisisHostile1(String opponent) {
    return '今度は$opponentにも。前任者はこういう流れで解任されました。なぜあなたは生き残れるのですか？';
  }

  @override
  String pressMomentCrisisHostile2(String opponent) {
    return '$opponent戦のような夜がまた続き、どのラジオ番組も解任を求めています。協会に求められたら辞任しますか？';
  }

  @override
  String pressMomentJobVerdictWarm1(String opponent) {
    return '職を懸けると宣言しましたが、$opponent戦を終えて思うようにはいきませんでした。大丈夫ですか？';
  }

  @override
  String pressMomentJobVerdictWarm2(String opponent) {
    return '3試合が終わりました。最後は$opponent戦でした。自ら課した試練です。この結果をどう受け止めますか？';
  }

  @override
  String pressMomentJobVerdictNeutral1(String opponent) {
    return '次の3試合で判断してくれとおっしゃいました。$opponent戦を終え、判断しました。あなたの職はまだありますか？';
  }

  @override
  String pressMomentJobVerdictNeutral2(String opponent) {
    return '3試合、最後は$opponent戦で、約束通りにはいきませんでした。去就について協会と話しましたか？';
  }

  @override
  String pressMomentJobVerdictHostile1(String opponent) {
    return '自ら課した試練に$opponent戦で失敗しました。辞任するつもりですか？';
  }

  @override
  String pressMomentJobVerdictHostile2(String opponent) {
    return '「次の3試合で判断してくれ」はあなたの言葉です。$opponent戦を終えて、なぜまだその席に座っているのですか？';
  }

  @override
  String get pressBeatWhoToBlameWarm1 => '選手たちにもっと求めるとのことですが、特に誰かいますか？';

  @override
  String get pressBeatWhoToBlameWarm2 => '高い目標を掲げました。まず誰が奮起すべきですか？';

  @override
  String get pressBeatWhoToBlameNeutral1 => '自分を見つめ直すべき選手がいるとのことですが、誰のことですか？';

  @override
  String get pressBeatWhoToBlameNeutral2 => '物足りないとおっしゃいました。誰のことを言っているのですか？';

  @override
  String get pressBeatWhoToBlameHostile1 =>
      '曖昧なままですね。名前を挙げますか、それとも結局あなたの責任ですか？';

  @override
  String get pressBeatWhoToBlameHostile2 => '毎週誰か他の人のせいですね。今回は誰のせいですか？';

  @override
  String get pressBeatIfYouDontWarm1 => '勇ましい言葉です。では、次の試合がうまくいかなかったら？';

  @override
  String get pressBeatIfYouDontWarm2 => '国民はその言葉を忘れないでしょう。もし実現しなかったら？';

  @override
  String get pressBeatIfYouDontNeutral1 => 'では、勝てなかったら？その時はどうしますか？';

  @override
  String get pressBeatIfYouDontNeutral2 => 'もう口にしてしまいました。外れたらどうなりますか？';

  @override
  String get pressBeatIfYouDontHostile1 =>
      'この部屋では以前にも約束を聞きました。今回も破られたら、サポーターに何を償いますか？';

  @override
  String get pressBeatIfYouDontHostile2 => 'それが実現しなかった時、言い訳は何になりますか？';

  @override
  String get pressBeatFollowUpWarm1 => 'もう一つだけ、よろしければ。このチームにはまだ何が足りませんか？';

  @override
  String get pressBeatFollowUpWarm2 => '落ち着いたところで、今夜から次の試合へ何を持ち帰りますか？';

  @override
  String get pressBeatFollowUpNeutral1 => 'もう少し掘り下げましょう。次の試合までに何を改善すべきですか？';

  @override
  String get pressBeatFollowUpNeutral2 => 'スコアを抜きにして、このチームは望む状態にありますか？';

  @override
  String get pressBeatFollowUpHostile1 =>
      '言葉は多いですが、中身はあまりありません。ここから実際に何が変わるのですか？';

  @override
  String get pressBeatFollowUpHostile2 =>
      'サポーターは率直な答えを求めています。このチームは十分な力がありますか、はいかいいえで。';

  @override
  String pressBeatStandoutWarm1(String player) {
    return '今夜の$playerは傑出していました。彼はどこまで行けますか？';
  }

  @override
  String pressBeatStandoutWarm2(String player) {
    return '今夜はどの見出しも$playerです。予想していましたか？';
  }

  @override
  String pressBeatStandoutNeutral1(String player) {
    return '$playerが際立っていました。今夜、彼に何を求めましたか？';
  }

  @override
  String pressBeatStandoutNeutral2(String player) {
    return '今夜の違いを生んだのは$playerでしたか？';
  }

  @override
  String pressBeatStandoutHostile1(String player) {
    return '$playerがいなければ話は違いました。これはチームですか、それとも一人の選手ですか？';
  }

  @override
  String pressBeatStandoutHostile2(String player) {
    return '$playerは見事でした。あなたの手柄ですか、それとも彼の？';
  }

  @override
  String pressBeatStrugglerWarm1(String player) {
    return '$playerは苦しい夜でした。どこか痛めているのですか？';
  }

  @override
  String pressBeatStrugglerWarm2(String player) {
    return '$playerは本来の出来ではありませんでした。声をかけてあげますか？';
  }

  @override
  String pressBeatStrugglerNeutral1(String player) {
    return '$playerは今夜苦戦しました。彼はポジションを守れますか？';
  }

  @override
  String pressBeatStrugglerNeutral2(String player) {
    return '$playerは試合のペースについていけていないように見えました。彼のプレーをどう見ましたか？';
  }

  @override
  String pressBeatStrugglerHostile1(String player) {
    return '$playerはまたお荷物でした。なぜ彼を起用し続けるのですか？';
  }

  @override
  String pressBeatStrugglerHostile2(String player) {
    return '$playerの不調は誰の目にも明らかでした。ベンチ以外の全員には、ですか？';
  }

  @override
  String get pressThrowbackWinNextKeptWarm =>
      '次は勝つと言って、勝ちました。自分が正しかったのは気分がいいですか？';

  @override
  String get pressThrowbackWinNextKeptNeutral =>
      '次の試合での勝利を約束し、実現しました。自信ですか、それとも虚勢ですか？';

  @override
  String get pressThrowbackWinNextKeptHostile =>
      '次は勝つと言って、勝ちました。運ですか、それとも耳を傾けるべきなのでしょうか？';

  @override
  String get pressThrowbackWinNextBrokenWarm =>
      'あの試合は勝つとおっしゃいましたが、そうはなりませんでした。何がいけなかったのですか？';

  @override
  String get pressThrowbackWinNextBrokenNeutral =>
      '次は勝つと言いましたが、勝てませんでした。次の約束をなぜ信じるべきなのでしょう？';

  @override
  String get pressThrowbackWinNextBrokenHostile =>
      '次は勝つと言いましたが、勝てませんでした。あなたの言葉はこの部屋でまだ意味を持ちますか？';

  @override
  String get pressThrowbackJobKeptWarm =>
      '3試合で判断してほしいと言い、見事に合格しました。正しさが証明されましたか？';

  @override
  String get pressThrowbackJobKeptNeutral =>
      '次の3試合で判断してくれとおっしゃいました。判断した結果、成績が出ました。あの試練から何を学びましたか？';

  @override
  String get pressThrowbackJobKeptHostile =>
      '自分に3試合を課して乗り切りました。そもそもそれほど難しい試練でしたか？';

  @override
  String get pressThrowbackJobBrokenWarm =>
      '3試合で判断してほしいと言いましたが、思うようにはいきませんでした。何を学びましたか？';

  @override
  String get pressThrowbackJobBrokenNeutral =>
      '次の3試合で判断してくれとおっしゃいました。3試合が過ぎ、猶予もなくなりました。これからどうしますか？';

  @override
  String get pressThrowbackJobBrokenHostile =>
      '自ら試練を課して失敗しました。なぜ今さらあなたの言葉を信じるべきなのですか？';

  @override
  String pressThrowbackBackKeptWarm(String player) {
    return '他の人が支持しない中、あなたは$playerを支持し、彼は結果を出しました。あなたの功績でもありますか？';
  }

  @override
  String pressThrowbackBackKeptNeutral(String player) {
    return 'あなたは$playerを支持し、彼は結果を出しました。信頼ですか、それとも確信ですか？';
  }

  @override
  String pressThrowbackBackKeptHostile(String player) {
    return '$playerを支持し、珍しく報われました。次も同じくらい確信を持てますか？';
  }

  @override
  String pressThrowbackBackBrokenWarm(String player) {
    return '$playerを支え続けましたが、うまくいっていません。今も彼を信じていますか？';
  }

  @override
  String pressThrowbackBackBrokenNeutral(String player) {
    return '$playerを支持しましたが、彼は応えていません。それは間違いでしたか？';
  }

  @override
  String pressThrowbackBackBrokenHostile(String player) {
    return '判断力か忠誠心か。$playerの件で失敗したのはどちらですか？';
  }

  @override
  String pressThrowbackBlameKeptWarm(String player) {
    return '$playerに厳しく当たり、その後の試合はあなたの正しさを証明しました。満足感はありますか？';
  }

  @override
  String pressThrowbackBlameKeptNeutral(String player) {
    return '$playerを名指しで批判しましたが、彼は応えていません。彼に復活の道はありますか？';
  }

  @override
  String pressThrowbackBlameKeptHostile(String player) {
    return '$playerを見捨て、彼は立ち直れていません。あなたが彼を潰したのですか？';
  }

  @override
  String pressThrowbackBlameBrokenWarm(String player) {
    return '$playerを名指しで批判し、彼はピッチで答えを出しました。最初からそれが狙いでしたか？';
  }

  @override
  String pressThrowbackBlameBrokenNeutral(String player) {
    return '$playerを責めましたが、それ以来彼はチーム屈指の存在です。彼に謝罪すべきでは？';
  }

  @override
  String pressThrowbackBlameBrokenHostile(String player) {
    return '$playerを矢面に立たせましたが、それ以来彼がチームのベストプレーヤーです。謝罪しますか？';
  }

  @override
  String get pressReplyCreditPlayers1 =>
      '選手たちはすべてを出し尽くしてくれました。誰一人として替えるつもりはありません。';

  @override
  String get pressReplyCreditPlayers2 => 'このチームほど努力する集団はいません。いつでも彼らを擁護します。';

  @override
  String get pressReplyCreditPlayers3 => 'この席から選手たちを悪く言うことは一言もありません。';

  @override
  String get pressReplyCreditPlayers4 => '称賛されるべきは私ではなく選手たちです。彼らのことを書いてください。';

  @override
  String get pressReplyTakeResponsibility1 => 'あれは私の責任です。メンバーを選び、戦い方を決めたのは私です。';

  @override
  String get pressReplyTakeResponsibility2 => '評価すべきは選手ではなく私です。私のチームで、私の責任です。';

  @override
  String get pressReplyTakeResponsibility3 => '誰かを責めたいなら、私がここに座っています。';

  @override
  String get pressReplyTakeResponsibility4 => '責任は私にあります。選手たちは関係ありません。';

  @override
  String get pressReplyDemandMore1 => 'もっと求めます。何人かは私の言う意味をよくわかっているはずです。';

  @override
  String get pressReplyDemandMore2 =>
      'このレベルでは頑張るだけでは足りません。もっと求めますし、本人たちにもそう伝えました。';

  @override
  String get pressReplyDemandMore3 => '明日から、全員にもっと期待します。';

  @override
  String get pressReplyDemandMore4 => '自分を見つめ直すべき選手がいます。私は満足していません。';

  @override
  String get pressReplyPromiseWinNext1 => '次の試合は勝ちます。書いてもらって構いません。';

  @override
  String get pressReplyPromiseWinNext2 => '覚えておいてください。次の試合は勝ちます。';

  @override
  String get pressReplyPromiseWinNext3 => '次の試合は勝ちます。ここで言っておくので、責任を問ってください。';

  @override
  String get pressReplyPromiseWinNext4 => 'このチームに確信があります。次の試合は勝ちます。';

  @override
  String get pressReplyJobOnTheLine1 => '次の3試合で判断してください。それが公平です。';

  @override
  String get pressReplyJobOnTheLine2 => '3試合ください。それまでに立て直せなければ、それで判断してください。';

  @override
  String get pressReplyJobOnTheLine3 =>
      '次の3試合で、私がふさわしい人間かどうかがわかります。その言葉に責任を持ちます。';

  @override
  String get pressReplyJobOnTheLine4 => '3試合です。その後は私について好きに書いてください。';

  @override
  String get pressReplyDeflect1 => '一戦一戦です。付け加えることはありません。';

  @override
  String get pressReplyDeflect2 => '今日は見出しになるようなことは言いません。';

  @override
  String get pressReplyDeflect3 => '次の試合。考えているのはそれだけです。';

  @override
  String get pressReplyDeflect4 => '私の考えはロッカールームの中に留めておきます。';

  @override
  String get pressReplyTakeCredit1 => '信じていたから言ったのです。そして私は正しかった。';

  @override
  String get pressReplyTakeCredit2 => '正しく読めていました。それが私の仕事です。';

  @override
  String get pressReplyTakeCredit3 => '判断力と呼んでください。自分が何を言っているかはわかっていました。';

  @override
  String get pressReplyTakeCredit4 => '私が決断し、うまくいきました。それは素直に受け取ります。';

  @override
  String get pressReplyStandByIt1 => '信じていることを言いました。その言葉に変わりはありません。';

  @override
  String get pressReplyStandByIt2 => '一言たりとも撤回しません。';

  @override
  String get pressReplyStandByIt3 => 'あの時と同じ答えです。本気でしたし、今もそうです。';

  @override
  String get pressReplyStandByIt4 => '明日でもまた同じことを言います。';

  @override
  String get pressReplyAdmitMistake1 => 'あれは私の間違いでした。認めます。';

  @override
  String get pressReplyAdmitMistake2 => 'おっしゃる通り、判断を誤りました。教訓にします。';

  @override
  String get pressReplyAdmitMistake3 => '私が間違っていました。それははっきり言えます。';

  @override
  String get pressReplyAdmitMistake4 => 'あの判断はうまくいきませんでした。そして決めたのは私です。';

  @override
  String pressReplyBackPlayer1(String player) {
    return '$playerを全面的に支持しています。彼はやってくれます。';
  }

  @override
  String pressReplyBackPlayer2(String player) {
    return '$playerを信じています。その理由を彼が示してくれるでしょう。';
  }

  @override
  String pressReplyBackPlayer3(String player) {
    return '私から$playerを悪く言うことは一言もありません。彼は結果を出します。';
  }

  @override
  String pressReplyBackPlayer4(String player) {
    return '$playerは私の構想に入っています。次の彼に注目してください。';
  }

  @override
  String pressReplyBlamePlayer1(String player) {
    return '今夜は$playerに失望させられました。本人もわかっているはずです。';
  }

  @override
  String pressReplyBlamePlayer2(String player) {
    return '$playerにはもっと期待していました。彼はそれに応えなければなりません。';
  }

  @override
  String pressReplyBlamePlayer3(String player) {
    return '$playerはレベルに達していませんでした。公の場でそう言います。';
  }

  @override
  String pressReplyBlamePlayer4(String player) {
    return '$playerのあのプレーは物足りません。私から直接伝えます。';
  }

  @override
  String get pressOnRecordWinNext => '発言記録: 次の試合は勝つ。';

  @override
  String get pressOnRecordJob => '発言記録: 次の3試合で判断してほしい。';

  @override
  String pressOnRecordBack(String player) {
    return '発言記録: $playerを支持。';
  }

  @override
  String pressOnRecordBlame(String player) {
    return '発言記録: $playerに失望させられた。';
  }

  @override
  String yStatementKept0(String nation) {
    return '言った通りになった。$nationには有言実行の監督がいる。';
  }

  @override
  String yStatementKept1(String nation) {
    return '口に出して、それをやってのけた。$nationに必要だったのはこういう男だ。';
  }

  @override
  String yStatementKept2(String nation) {
    return '$nation: 彼の言った通りになった。認めよう。';
  }

  @override
  String yStatementKept3(String nation) {
    return '公言して、それを守った。彼の勝ちだ。$nationは前へ進む。';
  }

  @override
  String yStatementKept4(String nation) {
    return '一つ当てたね。$nationの皆さん、慣れないように。';
  }

  @override
  String yStatementKept5(String nation) {
    return '止まった時計でも1日2回は合う。$nationは今回ついてただけ。';
  }

  @override
  String yStatementBroken0(String nation) {
    return '言ったけど実現しなかった。それでも支持する。$nationはまた挑む。';
  }

  @override
  String yStatementBroken1(String nation) {
    return '$nation: 約束ほどの結果は出なかったが、自分を信じる監督の方がいい。';
  }

  @override
  String yStatementBroken2(String nation) {
    return '$nation: 公言して、実現しなかった。みんな覚えてるぞ。';
  }

  @override
  String yStatementBroken3(String nation) {
    return '大口を叩いて中身なし。$nationよ、次はもっと黙ってろ。';
  }

  @override
  String yStatementBroken4(String nation) {
    return 'あそこに立って言い切った。で、これだ。$nationは口先以上のものに値する。';
  }

  @override
  String yStatementBroken5(String nation) {
    return '彼の言葉にはもう何の価値もない。覚えておけ、$nation。';
  }

  @override
  String get ncZoneNorth => '北部ゾーン';

  @override
  String get ncZoneWest => '西部ゾーン';

  @override
  String get ncZoneEast => '東部ゾーン';

  @override
  String get ncZoneCentralSouthern => '中部・南部ゾーン';

  @override
  String careerNationsCupZoneWon(String zone) {
    return '$zone · 優勝';
  }

  @override
  String careerNationsCupZoneRunnerUp(String zone) {
    return '$zone · 準優勝';
  }

  @override
  String careerNationsCupZoneSemi(String zone) {
    return '$zone · ベスト4';
  }

  @override
  String careerNationsCupZoneRoundOf16(String zone) {
    return '$zone · ベスト16';
  }

  @override
  String careerNationsCupZoneQuarter(String zone) {
    return '$zone · ベスト8';
  }

  @override
  String careerNationsCupZonePlaced(String zone, int position) {
    return '$zone · $position位';
  }

  @override
  String get objectiveNcFinalsEight => '準々決勝進出';

  @override
  String get objectiveNcZoneWinGroup => 'グループ首位';

  @override
  String get finishNcFinalsEight => 'ベスト8';

  @override
  String get finishNcBottomHalf => 'グループ下位半分';

  @override
  String get tourContTabZones => 'ゾーン';

  @override
  String get tourContTabFinalsEight => '決勝T';

  @override
  String get tourContFinalsEightSoon =>
      '決勝トーナメントは11月のラウンド16から始まります。14のグループ首位と、2位の成績上位2チームが出場します。';

  @override
  String get tourContQuarterFinals => '準々決勝';

  @override
  String get tourContZoneAdvancement =>
      '各グループ首位と、2位の成績上位2チームがラウンド16に進出します。降格はありません。';

  @override
  String tourContZoneHeadingYours(String zone) {
    return '$zone ★';
  }

  @override
  String get compNorthAmericaNationsCup => '北米ネーションズカップ';

  @override
  String get compAfricanNationsCup => 'ネーションズカップ';

  @override
  String get objectiveNcWinItNorthAmerica => '北米ネーションズカップ優勝';

  @override
  String get objectiveNcWinItAfrica => 'ネーションズカップ優勝';

  @override
  String get objectiveNcReachFinalNorthAmerica => '北米ネーションズカップ決勝進出';

  @override
  String get objectiveNcReachFinalAfrica => 'ネーションズカップ決勝進出';

  @override
  String get finishNcChampionsNorthAmerica => '北米ネーションズカップ優勝';

  @override
  String get finishNcChampionsAfrica => 'ネーションズカップ優勝';

  @override
  String pressAimQualWarm1(String competition) {
    return '$competition予選が始まります。国中がこのチームを信じています。目標は何ですか？';
  }

  @override
  String pressAimQualWarm2(String competition) {
    return '新たな$competition予選が始まり、士気は高いです。このチームはどこまで行けますか？';
  }

  @override
  String pressAimQualNeutral1(String competition) {
    return '$competition予選が始まります。今回の目標は何ですか？';
  }

  @override
  String pressAimQualNeutral2(String competition) {
    return '$competition予選がやって来ました。このチームはどのあたりで終えると見ていますか？';
  }

  @override
  String pressAimQualHostile1(String competition) {
    return '$competition予選が始まりますが、突破を疑う人は多いです。その人たちに何と言いますか？';
  }

  @override
  String pressAimQualHostile2(String competition) {
    return 'また$competition予選です。今回は違うと、なぜ信じるべきなのでしょう？';
  }

  @override
  String pressAimFinalsWarm1(String competition) {
    return '$competitionが始まり、国中があなたたちを応援しています。どこまで行けますか？';
  }

  @override
  String pressAimFinalsWarm2(String competition) {
    return '$competitionの舞台に立ち、ファンは夢を見ています。目標は何ですか？';
  }

  @override
  String pressAimFinalsNeutral1(String competition) {
    return '今週$competitionが開幕します。何をもって成功としますか？';
  }

  @override
  String pressAimFinalsNeutral2(String competition) {
    return '$competitionの初戦が迫っています。目標を聞かせてください。';
  }

  @override
  String pressAimFinalsHostile1(String competition) {
    return '$competitionが始まりますが、期待する人は多くありません。本当は何を望んでいますか？';
  }

  @override
  String pressAimFinalsHostile2(String competition) {
    return '$competitionに出場しますが、疑念は消えていません。目標は何ですか？';
  }

  @override
  String pressBeatRivalWarm1(String rival) {
    return 'グループには$rivalがいます。不安はありますか？';
  }

  @override
  String pressBeatRivalWarm2(String rival) {
    return '抽選で$rivalと同組になりました。あの試合をどう見ていますか？';
  }

  @override
  String pressBeatRivalNeutral1(String rival) {
    return 'グループ最強は$rivalと見られています。彼らが本命ですか？';
  }

  @override
  String pressBeatRivalNeutral2(String rival) {
    return '$rivalをどう見ていますか？';
  }

  @override
  String pressBeatRivalHostile1(String rival) {
    return 'グループには$rivalがいます。正直なところ、互角に戦えますか？';
  }

  @override
  String pressBeatRivalHostile2(String rival) {
    return '大半の人は$rivalが勝つと見ています。彼らは間違っていますか？';
  }

  @override
  String pressBeatKeyPlayerWarm1(String player) {
    return '$playerが好調です。今こそ彼の時ですか？';
  }

  @override
  String pressBeatKeyPlayerWarm2(String player) {
    return 'どの見出しも$playerです。彼はこのチームを背負えますか？';
  }

  @override
  String pressBeatKeyPlayerNeutral1(String player) {
    return '今回の戦いは$playerにどれだけ懸かっていますか？';
  }

  @override
  String pressBeatKeyPlayerNeutral2(String player) {
    return '$playerはこのチームを率いる準備ができていますか？';
  }

  @override
  String pressBeatKeyPlayerHostile1(String player) {
    return '$playerが本調子でなければ、このチームに何か残りますか？';
  }

  @override
  String pressBeatKeyPlayerHostile2(String player) {
    return '$playerは多くを背負っています。背負いすぎでは？';
  }

  @override
  String get pressReplyAimHigher1 => '誰の予想よりも先まで行きます。';

  @override
  String get pressReplyAimHigher2 => '協会が求める以上のものを目指します。はっきりそう言います。';

  @override
  String get pressReplyMatchBrief1 => '目標はわかっていますし、必ず達成します。';

  @override
  String get pressReplyMatchBrief2 => '協会が目標を定めました。私たちはそれを果たします。';

  @override
  String get pressReplyPlayDown1 => '一戦一戦戦っていきましょう。';

  @override
  String get pressReplyPlayDown2 => '大きな約束はしません。どこまで行けるか見てみましょう。';

  @override
  String get pressReplyPromiseQualify1 => '予選は突破します。書いてもらって構いません。';

  @override
  String get pressReplyPromiseQualify2 => 'このチームは本大会に出ます。';

  @override
  String get pressReplyFearNobody1 => '恐れる相手はいません。';

  @override
  String get pressReplyFearNobody2 => '向こうも私たちと戦わなければなりません。';

  @override
  String get pressReplyRespectRival1 => '彼らが本命ですし、敬意を払っています。';

  @override
  String get pressReplyRespectRival2 => '非常に良いチームです。ベストを尽くす必要があります。';

  @override
  String get pressReplyTeamFirst1 => '大事なのはチーム全体で、一人の選手ではありません。';

  @override
  String get pressReplyTeamFirst2 => '一人で勝てる者はいません。';

  @override
  String pressOnRecordTarget(String aim) {
    return '発言記録: $aim。';
  }

  @override
  String get pressOnRecordPlayDown => '発言記録: 約束はしない。';

  @override
  String get pressThrowbackTargetKeptWarm =>
      '大会前に目標を掲げ、達成しました。これまでで一番誇らしい瞬間ですか？';

  @override
  String get pressThrowbackTargetKeptNeutral =>
      '何を成し遂げるか宣言し、その通りにしました。疑う余地はありましたか？';

  @override
  String get pressThrowbackTargetKeptHostile =>
      '自分で掲げた目標を達成しました。運ですか、それとも本当に計画通りでしたか？';

  @override
  String get pressThrowbackTargetBrokenWarm =>
      '目標を掲げましたが、届きませんでした。何がいけなかったのですか？';

  @override
  String get pressThrowbackTargetBrokenNeutral =>
      'チームが出した結果以上のことを約束しました。言ったことを後悔していますか？';

  @override
  String get pressThrowbackTargetBrokenHostile =>
      '大会前に大きなことを言い、届きませんでした。なぜ今あなたを信じるべきなのですか？';

  @override
  String hubEventPressPreviewSub(String competition) {
    return '記者たちが$competitionへの抱負を聞きたがっています';
  }

  @override
  String deptLevelCost(int level, String amount) {
    return 'レベル$level · $amount';
  }

  @override
  String get formOnFire => '絶好調';

  @override
  String get formGood => '好調';

  @override
  String get formSteady => '普通';

  @override
  String get formPoor => '不調';

  @override
  String get formCold => '絶不調';

  @override
  String get playerFormTitle => '調子とコンディション';

  @override
  String playerFormAverage(String rating) {
    return '最近の試合で平均$rating';
  }

  @override
  String get playerFormNoGames => '判断できるほど最近の試合がありません';

  @override
  String playerFormNextMatch(String delta) {
    return '次の試合の評価 $delta';
  }

  @override
  String get playerFormNoEffect => '次の試合の評価に変化なし';

  @override
  String get sideGroupHome => 'ホーム';

  @override
  String get sideGroupTeam => 'チーム';

  @override
  String get sideGroupCompetitions => '大会';

  @override
  String get sideGroupFederation => '協会';

  @override
  String get sideGroupHistory => '歴史';

  @override
  String get sideInbox => '受信箱';

  @override
  String get sideSquad => '選手一覧';

  @override
  String get sideTactics => '戦術';

  @override
  String get sideMainMenu => 'メインメニュー';

  @override
  String get sideCallUps => '招集';

  @override
  String get sideTournaments => '大会';

  @override
  String get sideRanking => 'ランキング';

  @override
  String get sideResults => '結果';

  @override
  String get sideFinances => '財務';

  @override
  String get sideBoard => '協会';

  @override
  String get sideManager => '監督とスタッフ';

  @override
  String get sideRecords => '記録';

  @override
  String get sideLegends => 'レジェンド';

  @override
  String get sideHeadToHead => '対戦成績';

  @override
  String get sideAchievements => '実績';

  @override
  String get sideCareer => 'キャリア';

  @override
  String get topBarNext => '次戦';

  @override
  String get topBarDrawPending => '抽選待ち';

  @override
  String get paneFullProfile => '詳細プロフィール';

  @override
  String get panePickPlayer => '選手を選ぶとここにカードが表示されます';

  @override
  String get inboxPickMessage => 'メッセージを選ぶとここで読めます';

  @override
  String get inboxFilterAll => '全て';

  @override
  String get panelViewAll => 'すべて表示';

  @override
  String get gridViewOverview => '概要';

  @override
  String get gridColCondition => 'コンディション';

  @override
  String get gridColStatus => '状態';

  @override
  String get gridColRank => '順位';

  @override
  String get gridColMove => '変動';

  @override
  String get gridColNation => '国';

  @override
  String get gridColRegion => '地域';

  @override
  String get gridColPoints => 'ポイント';

  @override
  String get panePickNation => '国を選ぶとここに成績が表示されます';

  @override
  String get resultsCyclesTitle => 'サイクル';

  @override
  String get tourDrawStart => '抽選開始';

  @override
  String get tourDrawViewGroups => 'グループを見る';

  @override
  String get gridColCeiling => '上限';

  @override
  String get gridColYearGain => '伸び';

  @override
  String get gridColMarkedAt => '登録時';

  @override
  String get budgetSetupTitle => '予算の設定';

  @override
  String get budgetEffectsTitle => 'この予算で得られるもの';

  @override
  String get naturalisationTitle => '帰化';

  @override
  String get yTrending => 'トレンド';

  @override
  String get yVoices => 'よく投稿する人';

  @override
  String get yConversation => 'スレッド';

  @override
  String get allTimeRecordsTitle => '世界歴代記録';

  @override
  String get h2hMeetingsTitle => '全対戦';

  @override
  String get h2hPickOpponent => '対戦相手を選ぶとここに全対戦が表示されます';

  @override
  String get savesTitle => 'セーブ';

  @override
  String get gridColPlayer => '選手';

  @override
  String get gridColPos => '位置';

  @override
  String get gridColActive => '現役';

  @override
  String get gridColMotm => 'MOTM';

  @override
  String get gridColAvg => '平均';

  @override
  String get gridColOpponent => '対戦相手';

  @override
  String get gridColStarts => '先発';

  @override
  String get gridColTournaments => '大会';

  @override
  String get gridColDate => '日付';

  @override
  String get gridColLastPlayed => '最終プレイ';

  @override
  String get gridColManager => '監督';

  @override
  String nationsShownCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countか国',
      one: '1か国',
    );
    return '$_temp0';
  }

  @override
  String get nationsSortedByRank => '世界ランク順';

  @override
  String get nationsStrength => '実力';

  @override
  String nationsStrengthOf(int tier) {
    return '$tier / 5';
  }

  @override
  String get nationsSquadOverall => 'チーム総合力';

  @override
  String get nationsOpeningBudget => '初期予算';

  @override
  String get nationsStarPlayer => 'スター選手';

  @override
  String nationsStarTile(String position, int rating) {
    return 'スター $position $rating';
  }

  @override
  String nationsStarAge(int age) {
    return '$age歳';
  }

  @override
  String get nationsBoardExpects => '協会の期待';

  @override
  String nationsManage(String nation) {
    return '$nationを率いる';
  }

  @override
  String get nationsManagerNext => '次に監督名を決めます';

  @override
  String get playerPageTitle => '選手';

  @override
  String get nationPageTitle => '国';

  @override
  String get friendliesYourGames => '親善試合の予定';

  @override
  String hubEventInjuryCover(String player) {
    return '負傷した$playerの代わりを招集';
  }

  @override
  String hubEventInjuryCoverSub(int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: '$matches試合欠場',
      one: '次の試合を欠場',
    );
    return '$_temp0。誰かを招集するか、彼抜きで戦います。';
  }

  @override
  String get injuryCoverTitle => '追加招集';

  @override
  String injuryCoverBanner(String player, String position) {
    return '$player（$position）が負傷しました。メンバー外から誰でも、どのポジションでも招集できます。彼を残してそのまま戦うこともできます。';
  }

  @override
  String injuryCoverConfirm(String player) {
    return '$playerを招集';
  }

  @override
  String injuryCoverKeep(String player) {
    return '$playerを残して続行';
  }

  @override
  String get injuryCoverPick => '代わりの選手を選択';

  @override
  String get injuryCoverNone => 'メンバー外に合流できる健康な選手はいません。';

  @override
  String get nationNowRanking => '世界ランキング';

  @override
  String get nationNowForm => '調子';

  @override
  String get nationNowNoForm => 'まだ試合をしていません';

  @override
  String get nationNowNext => '次の試合';

  @override
  String get nationNowNoNext => '予定なし';

  @override
  String get nationNowSquad => 'チーム';

  @override
  String get nationNowAgainstYou => '対あなた';

  @override
  String nationNowRecord(int w, int d, int l) {
    return '$w勝$d分$l敗';
  }

  @override
  String get nationNowLastMeeting => '前回の対戦';

  @override
  String nationNowOverall(int value) {
    return '総合力 $value';
  }

  @override
  String get hubUpcoming => '今後の試合';

  @override
  String get hubFullSchedule => '全日程';

  @override
  String get scheduleTitle => '日程';

  @override
  String get scheduleToday => '今日';

  @override
  String get scheduleKnockoutPending => '決勝トーナメント（勝ち上がれば）';

  @override
  String get scheduleNextRoundPending => '次のラウンド';

  @override
  String scheduleFromDate(String date) {
    return '$dateから';
  }

  @override
  String get scheduleHomeShort => 'H';

  @override
  String get scheduleAwayShort => 'A';

  @override
  String get tacticsNoPresetsInMatch => '保存された戦術はまだありません。試合前に戦術画面で保存してください。';

  @override
  String get homeCampaigns => 'キャンペーン';

  @override
  String get homeContinueCampaign => 'キャンペーンを続ける';

  @override
  String homeCampaignCycle(String date, int cycle, int total) {
    return '$date · サイクル $cycle/$total';
  }

  @override
  String get campaignsTitle => 'キャンペーン';

  @override
  String get campaignTransplantTitle => '移植';

  @override
  String get campaignTransplantTwist => 'イタリアの精鋭8人がサンマリノに代表変更';

  @override
  String get campaignTransplantGoal => '欧州選手権出場';

  @override
  String get campaignGrudgeTitle => '因縁';

  @override
  String get campaignGrudgeTwist => 'ジョージアとアルバニアが同組に';

  @override
  String get campaignGrudgeGoal => '予選でアルバニアより上位に';

  @override
  String get campaignTransplantIntro =>
      'サンマリノはまともな予選を戦ったことがありません。そこへイタリアの精鋭8人がパスポートを手にやって来ます。1サイクルで、珍しい存在を本物のチームに変えましょう。';

  @override
  String get campaignGrudgeIntro =>
      'ジョージアとアルバニアが同じ予選グループに入りました。どちらも敗北を許しません。アルバニアより上で終え、どこまで行けるか試しましょう。';

  @override
  String get campaignStars1Transplant => '出場権獲得';

  @override
  String get campaignStars2Transplant => '決勝トーナメント進出';

  @override
  String get campaignStars3Transplant => '欧州選手権優勝';

  @override
  String get campaignStars1Grudge => 'アルバニアより上位';

  @override
  String get campaignStars2Grudge => 'さらに出場権獲得';

  @override
  String get campaignStars3Grudge => 'さらに2回勝利';

  @override
  String get campaignFree => '無料';

  @override
  String get campaignStart => '開始';

  @override
  String get campaignPartOfUnlimited => '無制限版に含む';

  @override
  String get campaignResume => '再開';

  @override
  String get campaignAbandon => '破棄';

  @override
  String get campaignAbandonConfirm => 'この挑戦を破棄しますか？進行状況は失われますが、スタンプは残ります。';

  @override
  String get campaignMoveToSaves => 'セーブに移動';

  @override
  String get campaignCannotContinue =>
      'このキャンペーンの世界は現実と違いすぎるため、キャリアとして続けることはできません。';

  @override
  String get campaignMoveSlotsFull => 'セーブスロットが一杯です。先に空きを作ってください。';

  @override
  String get campaignStampConquered => '制覇';

  @override
  String get campaignStampFailed => '失敗';

  @override
  String get campaignDifficultyHard => '難しい';

  @override
  String get campaignDifficultyMedium => '普通';

  @override
  String get campaignGoalLabel => '目標';

  @override
  String get campaignStarsLabel => '星';

  @override
  String get campaignRunInProgress => 'このキャンペーンはすでに進行中です。';

  @override
  String get campaignVerdictWon => '制覇';

  @override
  String get campaignVerdictLost => '今回は届かず';

  @override
  String get campaignVerdictContinue => '続ける';

  @override
  String campaignProgressQualifying(String position) {
    return '予選: $position';
  }

  @override
  String campaignProgressRival(String rival, String position) {
    return '$rival: $position';
  }

  @override
  String campaignProgressFinals(String stage) {
    return '本大会: $stage';
  }

  @override
  String get campaignRunInNumbers => '数字で見る挑戦';

  @override
  String campaignRunMeetings(int won, int played) {
    return '対戦成績: $played戦$won勝';
  }

  @override
  String campaignPlace(String which, int n) {
    String _temp0 = intl.Intl.selectLogic(
      which,
      {
        'first': '1位',
        'second': '2位',
        'third': '3位',
        'other': '$n位',
      },
    );
    return '$_temp0';
  }

  @override
  String get campaignGuineasTitle => 'ギニアの頂点';

  @override
  String get campaignGuineasTwist => 'アフリカのギニア3国で最も小さい赤道ギニアを2サイクル指揮';

  @override
  String get campaignGuineasGoal => 'ギニアとギニアビサウに勝つ';

  @override
  String get campaignGuineasIntro =>
      'アフリカにはギニアの名を持つ国が3つあり、赤道ギニアはその中で最も小さな国です。2サイクルのうちにギニアとギニアビサウにそれぞれ最低1回勝ち、アフリカ選手権でどこまで行けるか試しましょう。4つ目のギニア、パプアニューギニアとの親善試合もすでに組まれています。';

  @override
  String get campaignStars1Guineas => 'ギニアとギニアビサウに勝つ';

  @override
  String get campaignStars2Guineas => 'さらにアフリカ選手権出場';

  @override
  String get campaignStars3Guineas => 'さらにアフリカ選手権ベスト8';

  @override
  String get campaignYoungFinnsTitle => '若きフィンランド';

  @override
  String get campaignYoungFinnsTwist => 'フィンランドの10代の黄金世代を3サイクル指揮';

  @override
  String get campaignYoungFinnsGoal => '世界選手権出場';

  @override
  String get campaignYoungFinnsIntro =>
      'フィンランドのベテランたちが身を引き、黄金世代がその座を継ぎました。選べる選手は全員18歳以下です。今はまだ荒削りですが、ノルウェーの若い世代がそうだったように、世界屈指のチームになる才能を秘めています。3サイクルで世界選手権に導き、さらに欧州選手権と世界選手権を制しましょう。';

  @override
  String get campaignStars1YoungFinns => '世界選手権出場';

  @override
  String get campaignStars2YoungFinns => '欧州選手権優勝';

  @override
  String get campaignStars3YoungFinns => '世界選手権優勝';

  @override
  String get campaignGreenlandTitle => 'グリーンランドの100年';

  @override
  String get campaignGreenlandTwist => 'グリーンランドがサンマリノに代わり欧州へ、100年間';

  @override
  String get campaignGreenlandGoal => '欧州選手権出場';

  @override
  String get campaignGreenlandIntro =>
      'グリーンランドは公式の国際試合を一度も戦ったことがありません。この世界ではサンマリノに代わって欧州に加わり、世界ランキング最下位からのスタートです。アマチュア選手、人工芝、雪の合間に詰め込まれたシーズン。100年、25サイクルのうちに欧州選手権へ、そして世界選手権へ。夢を見る勇気があるなら、そのどちらかを制しましょう。';

  @override
  String get campaignStars1Greenland => '欧州選手権出場';

  @override
  String get campaignStars2Greenland => '世界選手権出場';

  @override
  String get campaignStars3Greenland => '欧州選手権または世界選手権優勝';

  @override
  String get campaignPro => 'Pro';

  @override
  String campaignProgressCup(String cup, String year, String status) {
    return '$cup $year: $status';
  }

  @override
  String get campaignCupNotQualified => '出場ならず';

  @override
  String get campaignCupOpen => '未定';

  @override
  String newsYouthTitle1(String name, String level) {
    return '$nameが$level代表で輝く';
  }

  @override
  String newsYouthTitle2(String name, String level) {
    return 'アカデミー通信: $nameが注目を集める';
  }

  @override
  String newsYouthTitle3(String name, String level) {
    return '$levelの逸材: $name';
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
      other: '$countゴール',
    );
    return '直近の国際試合期間、$nameは$level代表の$opponent戦で$_temp0を決めました。';
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
      other: '$countゴール',
    );
    return '今回の期間、$level代表の$opponent戦で$nameが$_temp0。';
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
      other: '$countゴール',
    );
    return '$level代表は$opponentと対戦し、$nameが$_temp0を記録しました。';
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
      other: '$countゴール',
    );
    return '$nameは$level代表の$opponent戦で$_temp0をお膳立てし、試合を最初から最後まで支配しました。';
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
      other: '$countアシスト',
    );
    return '今回の期間、$level代表は$opponentと対戦し、$nameが攻撃のタクトを振りました。$_temp0、スタッフが今も語り草にするプレーぶりです。';
  }

  @override
  String newsYouthCleanSheet1(String name, String level, String opponent) {
    return '$level代表が$opponentを完封した試合で、$nameは傑出したプレーを見せました。';
  }

  @override
  String newsYouthCleanSheet2(String name, String level, String opponent) {
    return '$level代表が$opponentを完封。その大部分は$nameのおかげでした。';
  }

  @override
  String newsYouthDisplay1(
    String name,
    String level,
    String opponent,
    int mark,
  ) {
    return '$nameは$level代表の$opponent戦で印象的なプレーを見せ、スタッフは10点満点中$mark点をつけました。';
  }

  @override
  String newsYouthDisplay2(
    String name,
    String level,
    String opponent,
    int mark,
  ) {
    return '今回の期間、$level代表は$opponentと対戦し、コーチ陣は$nameを高く評価しました。10点満点中$mark点、チーム最高点です。';
  }

  @override
  String get newsYouthDevReady1 => 'この調子なら、すでにA代表候補に入るだけの実力があります。';

  @override
  String get newsYouthDevReady2 => 'スタッフは、彼がもうA代表でやれると考えています。判断はあなた次第です。';

  @override
  String get newsYouthDevClose1 => '順調に成長しており、A代表入りも間近です。';

  @override
  String get newsYouthDevClose2 => 'A代表まであと一歩。もう1シーズン良ければ届くかもしれません。';

  @override
  String get newsYouthDevGrowing1 => '順調に伸びていますが、A代表まではまだ1〜2段階あります。';

  @override
  String get newsYouthDevGrowing2 => 'A代表選手になるにはまだ課題がありますが、すべてが正しい方向に向かっています。';

  @override
  String get newsYouthDevRaw1 => 'まだ荒削りでA代表争いには数年かかりますが、才能は誰の目にも明らかです。';

  @override
  String get newsYouthDevRaw2 => 'まだ始まったばかりで、アカデミーのスタッフは騒ぎ立てるより辛抱を求めています。';

  @override
  String get newsYouthStrengthGkPhysical => 'リーチの長さとエリアの支配力が彼の際立った強みです。';

  @override
  String get newsYouthStrengthGkTechnical => 'キャッチングとフィードはアカデミーで数年ぶりの逸材です。';

  @override
  String get newsYouthStrengthGkStamina =>
      '集中力が途切れることがなく、90分目も1分目と同じく鋭い反応を見せます。';

  @override
  String get newsYouthStrengthDefPhysical => 'スピードと空中戦の強さが彼のプレーの鍵です。';

  @override
  String get newsYouthStrengthDefTechnical =>
      '年齢以上に試合を読む力があり、ボールを持っても落ち着いています。';

  @override
  String get newsYouthStrengthDefStamina => '集中を切らすことがなく、最後の1分まで全力で戻ってきます。';

  @override
  String get newsYouthStrengthMidPhysical => '力強くボールを奪い返し、そのまま前へ運びます。';

  @override
  String get newsYouthStrengthMidTechnical => '視野の広さと多彩なパスが彼のプレーの鍵です。';

  @override
  String get newsYouthStrengthMidStamina => '驚異的な運動量で、ピッチの隅々までカバーします。';

  @override
  String get newsYouthStrengthFwdPhysical => '裏へのスピードと空中戦の強さで、どんな守備陣も手を焼きます。';

  @override
  String get newsYouthStrengthFwdTechnical => '決定力とエリア内での動きが彼のプレーの鍵です。';

  @override
  String get newsYouthStrengthFwdStamina => '試合中ずっと前線からプレスをかけ、DFに一瞬も休む暇を与えません。';

  @override
  String pressMomentBigWinWarm3(String opponent) {
    return '$opponent戦の勝利は、ファンがしばらく歌い続けるでしょう。試合終了の笛で選手たちに何と言いましたか？';
  }

  @override
  String pressMomentBigWinNeutral3(String opponent) {
    return '$opponent相手に強烈なメッセージを示しました。そのうちどれだけが練習の成果ですか？';
  }

  @override
  String pressMomentBigWinHostile3(String opponent) {
    return '$opponent戦の結果は評価しますが、こういう夜は前にもありました。今回は何が違うのですか？';
  }

  @override
  String pressMomentBigLossWarm3(String opponent) {
    return '誰にでも悪い夜はあります。$opponent戦がそれでした。どれだけ早く切り替えられますか？';
  }

  @override
  String pressMomentBigLossNeutral3(String opponent) {
    return '$opponentはすべての面で上回っていました。どこから立て直しますか？';
  }

  @override
  String pressMomentBigLossHostile3(String opponent) {
    return '$opponent戦では、終了前にサポーターが帰り始めていました。彼らを責められますか？';
  }

  @override
  String pressMomentCrisisWarm3(String opponent) {
    return '苦しい流れが続き、$opponent戦でも楽にはなりませんでした。何があなたを支えていますか？';
  }

  @override
  String pressMomentCrisisNeutral3(String opponent) {
    return 'またも勝利なし、今度は$opponent戦です。協会が動くまで、あとどれくらい続けられますか？';
  }

  @override
  String pressMomentCrisisHostile3(String opponent) {
    return '$opponentにもです。あなたのプランにまだ何か残っていますか、それとも誰かに道を譲る時ですか？';
  }

  @override
  String get pressReplyCreditPlayers5 => '何を書くにしても、選手たちのことを書いてください。彼らはそれに値します。';

  @override
  String get pressReplyCreditPlayers6 =>
      '互いのために壁でも突き破る集団がいます。それは決して小さなことではありません。';

  @override
  String get pressReplyTakeResponsibility5 =>
      '決断するのは私ですから、批判は私に向けられるべきです。それが仕事です。';

  @override
  String get pressReplyTakeResponsibility6 => 'まず監督を見てください。私が間違えたので、私が正します。';

  @override
  String get pressReplyDemandMore5 => 'ここでは「良い」では足りません。本人たちに面と向かってそう伝えました。';

  @override
  String get pressReplyDemandMore6 =>
      'あのロッカールームにポジションを保証された者はいません。今はもう全員がわかっています。';

  @override
  String get pressReplyDeflect5 => '聞き方を3通り変えても、答えは同じです。';

  @override
  String get pressReplyDeflect6 => '考えは選手たちのために取っておきます。ご理解ください。';

  @override
  String yWinRoutine12(String opponent, String score) {
    return '$opponentに$score。落ち着いて、コントロールされた、大人のサッカー。最高だね。';
  }

  @override
  String yWinRoutine13(String opponent, String score) {
    return '$opponentに$score、汗ひとつかかずに勝利。このチームは退屈な勝ち方が上手くなってきた。退屈はタイトルを獲る。';
  }

  @override
  String yWinRoutine14(String opponent, String score) {
    return '$opponentに$score。勝点3、ドラマなし、仕事に戻ろう。';
  }

  @override
  String yWinRoutine15(String opponent, String score) {
    return '$opponentに順当な$score。誰も覚えていないし、覚える必要もない。';
  }

  @override
  String yWinRoutine16(String opponent, String score) {
    return '$opponentに$score、なのになぜか不安が残った。';
  }

  @override
  String yWinRoutine17(String opponent, String score) {
    return '$opponentに$scoreで勝利。まともな相手なら、あの内容は罰せられてた。';
  }

  @override
  String yWinTight12(String opponent, String score) {
    return '$opponentに$score。踏ん張って、耐えて、勝った。これがチームだ。';
  }

  @override
  String yWinTight13(String opponent, String score) {
    return '$opponentに$score、気持ちだけで勝った。負けを拒むチームは歓迎だ。';
  }

  @override
  String yWinTight14(String opponent, String score) {
    return '$opponentに$score。最後までもつれたけど、勝点はうちのもの。';
  }

  @override
  String yWinTight15(String opponent, String score) {
    return '$opponentに僅差の$score。紙一重、それがサッカー。';
  }

  @override
  String yWinTight16(String opponent, String score) {
    return '$opponentに$score。ボールが一度逆に跳ねてたら、まったく違う話になってた。';
  }

  @override
  String yWinTight17(String opponent, String score) {
    return '$opponent相手に$scoreで逃げ切り。あれを「いい内容」と呼ぶべきじゃない。';
  }

  @override
  String yDrew12(String opponent, String score) {
    return '$opponentと$score。負けではない。そういう日もある。';
  }

  @override
  String yDrew13(String opponent, String score) {
    return '$opponentと$score、苦労してもぎ取った勝点1。戦う姿勢は良かった。';
  }

  @override
  String yDrew14(String opponent, String score) {
    return '$opponentと$score。昔の実況風に言えば、互角の痛み分け。';
  }

  @override
  String yDrew15(String opponent, String score) {
    return '$opponentと$score。どちらもそれ以上に値する内容じゃなかった。';
  }

  @override
  String yDrew16(String opponent, String score) {
    return '$opponentと$score。帰りのバスで負けた気分になるタイプの引き分け。';
  }

  @override
  String yDrew17(String opponent, String score) {
    return '$opponentと$scoreで引き分け。進歩、進歩と言い続けて、これを繰り返してる。';
  }

  @override
  String yLost12(String opponent, String score) {
    return '$opponentに$score。痛いけど、このチームを信じられるだけのものは見えた。';
  }

  @override
  String yLost13(String opponent, String score) {
    return '$opponentに$scoreで敗戦、相手は良かった。認めて、また挑もう。';
  }

  @override
  String yLost14(String opponent, String score) {
    return '$opponentに$score。敗戦、いくつかの教訓、そして次の試合はすぐ来る。';
  }

  @override
  String yLost15(String opponent, String score) {
    return '$opponentに$scoreで敗戦。文句のつけようがない。';
  }

  @override
  String yLost16(String opponent, String score) {
    return '$opponentに$score。前回と同じミスを、同じ自信満々で繰り返した。';
  }

  @override
  String yLost17(String opponent, String score) {
    return '$opponentに$scoreで敗戦。これで誰も責任を問われないなら、何をやってるんだ？';
  }

  @override
  String get yReactionShrug12 => '別にいい。毎晩花火が上がる必要はない。';

  @override
  String get yReactionShrug13 => '勝点は勝点。今夜はよく眠れる。';

  @override
  String get yReactionShrug14 => '見た。特に感想なし。';

  @override
  String get yReactionShrug15 => 'まあまあと、まあまあの間くらい。';

  @override
  String get yReactionShrug16 => 'このために配信料を払った。二度と払わない（また払う）。';

  @override
  String get yReactionShrug17 => 'サッカーの形をした90分の虚無。';

  @override
  String get yReactionRelief12 => 'やっと息ができる。耐え抜いた彼らを誇りに思う。';

  @override
  String get yReactionRelief13 => 'こういう勝利がチームを作る。泥臭さこそ美しい。';

  @override
  String get yReactionRelief14 => '爪はなくなったけど、勝点はなくならなかった。';

  @override
  String get yReactionRelief15 => '試合終了の笛がこんなに心地よく響いたことはない。';

  @override
  String get yReactionRelief16 => '勝ってよかった。勝ち方は心配。';

  @override
  String get yReactionRelief17 => '毎回なんとか逃げ切ってる。いつか逃げ切れない日が来る。';

  @override
  String get yReactionFury12 => 'このチームが大好きだ。だからこそ、あれは痛い。';

  @override
  String get yReactionFury13 => 'ひどい夜だった。次は借りを返してもらう、本人たちもわかってるはず。';

  @override
  String get yReactionFury14 => '70分で消した。60分にすべきだった。';

  @override
  String get yReactionFury15 => '闘志なし、アイデアなし、言い訳無用。';

  @override
  String get yReactionFury16 => '毎回同じ問題、そして誰も何も直さない。';

  @override
  String get yReactionFury17 => '協会の誰かがあれを見返して説明すべきだ。';

  @override
  String get backupShareHint =>
      'すべてのセーブを1つのバックアップファイルにまとめます。保存先にGoogleドライブ、iCloud Drive、ファイルを選んでください。';

  @override
  String backupLastAt(String date) {
    return '最終バックアップ: $date';
  }

  @override
  String get backupNever => 'バックアップはまだありません';

  @override
  String get backupRemindersTitle => 'バックアップのリマインダー';

  @override
  String get backupRemindersBlurb => '最後のバックアップが古くなったら受信箱にお知らせします。';

  @override
  String get backupAutoICloudTitle => 'iCloud自動バックアップ';

  @override
  String get backupAutoDriveTitle => 'Googleドライブ自動バックアップ';

  @override
  String get backupAutoBlurb => '試合後、サイクル終了時、アプリを閉じた時にバックアップします。最新の2つを保持します。';

  @override
  String get backupStatusUploading => 'バックアップ中です。';

  @override
  String get backupStatusUploaded => 'バックアップしました。';

  @override
  String get backupStatusICloudSignedOut =>
      'iCloudがオフです。設定アプリでiCloudにサインインし、iCloud Driveをオンにしてください。';

  @override
  String get backupStatusDriveSignedOut =>
      'サインインしていません。スイッチをオンにしてGoogleでサインインしてください。';

  @override
  String get backupStatusNotConfigured => 'このバージョンのアプリではまだ利用できません。';

  @override
  String get backupStatusUnavailable => '現在クラウドに接続できません。後で再試行します。';

  @override
  String get backupStatusFailed => '前回の自動バックアップは完了しませんでした。後で再試行します。';

  @override
  String backupDriveSignedInAs(String email) {
    return '$emailでサインイン中';
  }

  @override
  String get backupDriveSignOut => 'サインアウト';

  @override
  String get backupDriveSignInFailed => 'Googleのサインインに失敗しました。後でもう一度お試しください。';

  @override
  String get backupRestoreICloud => 'iCloudから復元';

  @override
  String get backupRestoreDrive => 'Googleドライブから復元';

  @override
  String get backupCrossPlatformHelp =>
      'iPhoneとAndroidの間で移行しますか？一方の端末でファイルにバックアップし、もう一方でそのファイルから復元してください。';

  @override
  String get backupCloudListBlurb => 'このアカウントの端末からのバックアップです。タップして復元します。';

  @override
  String get backupCloudListEmpty =>
      'バックアップが見つかりません。新しいバックアップが別の端末に届くまで数分かかることがあります。';

  @override
  String get backupCloudListFailed => 'バックアップを読み込めませんでした。接続を確認して、もう一度お試しください。';

  @override
  String get backupCloudThisDevice => 'この端末';

  @override
  String backupCloudMore(int count) {
    return 'その他のセーブ: $count';
  }

  @override
  String get backupCloudNewer => '新しいバージョンのアプリで作成されています。先にアップデートしてください。';

  @override
  String get backupCloudDownloading => 'バックアップを取得中です。';

  @override
  String get backupRestoreSafetyNote => 'この端末のセーブは、先にコピーがこの端末に保存されます。';

  @override
  String get backupRejectedSafety => '現在のセーブのコピーを保存できなかったため、何も置き換えていません。';

  @override
  String get newsBackupReminderTitle => 'バックアップの時間です';

  @override
  String get newsBackupReminderBody =>
      'セーブはこの端末にしかありません。設定を開いて「クラウドにバックアップ」をタップするか、そこで自動バックアップをオンにしてください。このリマインダーも設定でオフにできます。';

  @override
  String get backupSafetyTitle => '復元前のコピー';

  @override
  String get backupSafetyBlurb => '誤った復元に備えてこの端末に保存されています。最新の3つを保持します。';

  @override
  String get backupSafetyRestore => '復元';

  @override
  String get backupSafetyShare => '共有';

  @override
  String get backupCloudNoDetails => '詳細はまだ取得中です。';

  @override
  String get tacticsLibraryTitle => '戦術ライブラリ';

  @override
  String get tacticsLibraryBlurb =>
      'ライブラリの戦術は、新しいセーブも含めどのセーブでも読み込めます。役割とセットプレーのキッカーは選手ではなくポジション単位で保存されます。';

  @override
  String get tacticsSaveToLibrary => 'ライブラリに保存';

  @override
  String get tacticsLoadFromLibrary => 'ライブラリから読み込む';

  @override
  String get tacticsLibraryEmpty => 'ライブラリは空です。ここに戦術を保存すれば、どのセーブでも読み込めます。';

  @override
  String tacticsLibrarySaved(String name) {
    return '「$name」をライブラリに保存しました';
  }

  @override
  String tacticsLibraryLoaded(String name) {
    return '「$name」を読み込みました';
  }

  @override
  String tacticsLibraryNotFitted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '役割またはキッカーのうち$countつがこのチームに合いませんでした。',
      one: '役割またはキッカーのうち1つがこのチームに合いませんでした。',
    );
    return '$_temp0';
  }

  @override
  String get tacticsLibraryRename => '名前を変更';

  @override
  String get tacticsLibraryRenameTitle => '戦術の名前を変更';

  @override
  String get tacticsLibraryDelete => '削除';

  @override
  String tacticsLibraryDeleteTitle(String name) {
    return '「$name」を削除しますか？';
  }

  @override
  String get tacticsLibraryDeleteBody => 'すべてのセーブのライブラリから削除されます。';

  @override
  String get tacticsLibraryNameTaken => 'ライブラリに同じ名前の戦術がすでにあります。';

  @override
  String tacticsLibraryCouldNotLoad(String error) {
    return 'ライブラリを読み込めませんでした。\n$error';
  }

  @override
  String hostBidHeading(String competition, int year) {
    return '開催招致: $competition $year';
  }

  @override
  String get hostBidScreenTitle => '開催招致';

  @override
  String get hostBidBlurb =>
      '開催国は候補国の中から抽選で決まります。招致に乗り出せば、あなたの国がより有力になります。スタジアムが基本の確率を生み、資金がそれを上乗せしますが、100万を追加するごとに効果は少しずつ薄れます。資金は当選してもしなくても使われます。';

  @override
  String hostBidPrize(String amount) {
    return '当選すれば開催国として自動出場となり、次の予算に向けて$amountの一時交付金を受け取ります。';
  }

  @override
  String get hostBidChance => '開催の可能性';

  @override
  String get hostBidBaseLabel => 'スタジアムと実績';

  @override
  String get hostBidInvestLabel => '投資';

  @override
  String hostBidCeiling(String nation, String percent) {
    return '$nationの上限: $percent';
  }

  @override
  String get hostBidInvestment => '投資額';

  @override
  String hostBidFreeFunds(String amount) {
    return '使用可能な資金: $amount';
  }

  @override
  String get hostBidSubmit => '招致を申請';

  @override
  String get hostBidDecline => '今回は見送る';

  @override
  String get hostBidUnavailable => 'この招致はすでに締め切られました。';

  @override
  String hostBidWonTitle(String competition, int year) {
    return '招致成功: $competition $year';
  }

  @override
  String hostBidWonBody(String amount) {
    return '我々が大会を開催し、開催国として自動出場します。$amountの一時交付金が協会の資金に入りました。ハブから今サイクルの各部門へすぐに配分できます。';
  }

  @override
  String hostBidLostTitle(String competition, int year) {
    return '招致失敗: $competition $year';
  }

  @override
  String hostBidLostBody(String hosts) {
    return '開催権は$hostsが獲得しました。今回は届かず、投じた資金も戻りませんが、協会は存在感を示しました。';
  }

  @override
  String get hostBidGrantEvent => '開催交付金を配分';

  @override
  String hostBidGrantBanner(String amount) {
    return '開催交付金: $amountを今すぐ今サイクルの各部門に追加できます。設定済みの配分はそのままで、余った分は貯蓄に残ります。';
  }

  @override
  String get stadiumsTitle => '国内スタジアム';

  @override
  String get stadiumsEntrySub => 'スタジアムの改修や新設';

  @override
  String get stadiumsBlurb =>
      'スタジアムのレベルは規模で決まります: レベル1は15,000席未満、レベル2は15,000席以上、レベル3は25,000席以上、レベル4は40,000席以上、レベル5は60,000席以上。どのスタジアムも各サイクルの初めに少額の収入を生み、観客が埋められる限り席が多いほど増えます。拡張はすぐに席を増やし、次のサイクルから少し評価も上がります。縮小は維持費を減らしますが、払い戻しはありません。どの大会に招致できるかはスタジアム次第です。';

  @override
  String stadiumsIncome(String amount) {
    return 'スタジアム収入: 1サイクルあたり$amount';
  }

  @override
  String stadiumsReputation(int points) {
    return 'スタジアムによる評価: +$points';
  }

  @override
  String get stadiumsClosed => '工事の発注はサイクル開始時、予算を決める前に行います。';

  @override
  String stadiumsCapacity(String seats) {
    return '収容人数: $seats';
  }

  @override
  String stadiumsLevel(int level, int max) {
    return 'レベル$level/$max';
  }

  @override
  String stadiumsUpgrade(String cost) {
    return '改修: $cost';
  }

  @override
  String get stadiumsTopLevel => '最高レベル';

  @override
  String stadiumsOpens(int year) {
    return '建設中、$year年開場';
  }

  @override
  String get stadiumsBuildTitle => '新スタジアムを建設';

  @override
  String get stadiumsBuildBody =>
      '費用はかなり高額です。選んだ都市に新スタジアムを建て、次のサイクル開始から使用できます。';

  @override
  String get stadiumsBuildCity => '都市';

  @override
  String stadiumsBuildButton(String cost) {
    return '建設: $cost';
  }

  @override
  String get stadiumsBuilding => 'すでにスタジアムを建設中です。';

  @override
  String get stadiumsNoCity => 'すべての都市に新スタジアムがあります。';

  @override
  String stadiumsConfirmUpgrade(String stadium, int level, String cost) {
    return '$stadiumを$costでレベル$levelに改修しますか？';
  }

  @override
  String stadiumsConfirmBuild(String city, String cost) {
    return '$cityに$costで新スタジアムを建設しますか？';
  }

  @override
  String get stadiumsConfirm => '確定';

  @override
  String get stadiumsCancel => 'キャンセル';

  @override
  String get stadiumsRefused => '発注は受け付けられませんでした。費用はかかっていません。';

  @override
  String get stadiumsNameLabel => 'スタジアム名';

  @override
  String get stadiumsNameHint => '空欄のままにすると、提案された名前になります。';

  @override
  String get stadiumsRename => 'スタジアム名を変更';

  @override
  String get hostBidSectionTitle => '開催招致';

  @override
  String get hostBidOpenSub => '任意。新しいサイクルが始まる前に判断してください。';

  @override
  String get hostBidDecidedAtRollover => '開催国は新しいサイクルの開始時に発表されます。';

  @override
  String get hostBidLodged => '招致を申請しました。開催国は新しいサイクルの開始時に発表されます。';

  @override
  String get hostBidDeclinedNote => '今回は招致を見送りました。';

  @override
  String get hostBidOpensLater => '条件を満たしています。このサイクルの終わりに招致できます。';

  @override
  String get hostBidNoFunds => '招致に使える資金が足りません。';

  @override
  String hostBidNeedStadiums(int count, String seats) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$seats席以上のスタジアムがあと$countつ必要です。',
      one: '$seats席以上のスタジアムがあと1つ必要です。',
    );
    return '$_temp0';
  }

  @override
  String hostBidBarredConf(String confederation) {
    return '前回の世界選手権は$confederationで開催されました。';
  }

  @override
  String get hostBidRecentHost => '直近3大会のいずれかを開催しています。';

  @override
  String hostBidRequirement(
    int grounds,
    String minSeats,
    int bigGrounds,
    String bigSeats,
  ) {
    return '条件: $minSeats席以上のスタジアム$groundsつ、うち$bigGroundsつは$bigSeats席以上。';
  }

  @override
  String hostBidWonBodyBudget(String amount) {
    return '大会を開催し、開催国として自動的に出場します。一時金$amountはすでに協会の資金に入っており、今サイクルの予算に使えます。';
  }

  @override
  String get hubStadiumIncome => 'スタジアム収入';

  @override
  String get stadiumsDownsize => '縮小';

  @override
  String stadiumsConfirmDownsize(String stadium, String seats, int level) {
    return '$stadiumを$seats席(レベル$level)に縮小しますか？払い戻しはありませんが、維持費が下がります。';
  }

  @override
  String get stadiumsResizedThisCycle => '今サイクル改修済み';

  @override
  String stadiumsGroundIncome(String amount) {
    return '1サイクルあたり$amountの収入';
  }

  @override
  String hostBidLapsedTitle(String competition, int year) {
    return '招致取り下げ: $competition $year';
  }

  @override
  String hostBidLapsedBodyNation(String nation) {
    return '招致は$nationとして申請しましたが、新しいサイクルは別のチームで始まります。招致は取り下げられ、費用はかかっていません。';
  }

  @override
  String get hostBidLapsedBodyFunds =>
      'サイクル終了時、協会の資金が申請額に届きませんでした。招致は取り下げられ、費用はかかっていません。';

  @override
  String get stadiumsViewMap => '地図';

  @override
  String get stadiumsViewList => 'リスト';

  @override
  String get stadiumsMapPickCity => '新しいスタジアムを建てる都市をタップしてください。';

  @override
  String get stadiumsMapFit => '国全体を表示';

  @override
  String get campaignLegacyTitle => 'レガシーの完成';

  @override
  String get campaignLegacyTwist => '欧州王者スペインを1サイクル率いる';

  @override
  String get campaignLegacyGoal => '欧州王座を守る';

  @override
  String get campaignLegacyIntro =>
      'スペインは現欧州王者ですが、黄金期はまぐれだったと疑う声もあります。それが違うと証明するチャンスは1サイクル。まず大陸の王座を守り、次は世界の頂点を狙ってください。ネーションズカップも制すれば、レガシーは完成です。';

  @override
  String get campaignStars1Legacy => '欧州選手権優勝';

  @override
  String get campaignStars2Legacy => 'さらに世界選手権';

  @override
  String get campaignStars3Legacy => 'さらにネーションズカップ';

  @override
  String get campaignSectionOneCycle => '1サイクル';

  @override
  String get campaignSectionShort => '数サイクル';

  @override
  String get campaignSectionLong => '長期戦';

  @override
  String get campaignFilterAll => 'すべて';

  @override
  String get campaignFilterNew => '未プレイ';

  @override
  String get campaignFilterInProgress => '進行中';

  @override
  String get campaignFilterDone => '完了';

  @override
  String get campaignFilterEmpty => 'ここにはまだキャンペーンがありません。';

  @override
  String campaignStarsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '星$countつ',
      zero: '星なし',
    );
    return '$_temp0';
  }

  @override
  String campaignCycles(int cycles) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cyclesサイクル',
    );
    return '$_temp0';
  }

  @override
  String get msgIntlRetireNoteHigh => ' 王者として、頂点で去ります。';

  @override
  String get msgIntlRetireNoteMissed => ' 本大会出場を逃したことが決定打になりました。';

  @override
  String get msgIntlRetireNoteSurprise => ' 誰も予想していませんでした。';

  @override
  String get msgIntlRetireNoteRecord => ' 代表の記録保持者として去ります。';

  @override
  String msgIntlRetireNewsTitle(String nation, String name) {
    return '$nation：$nameが代表引退';
  }

  @override
  String msgIntlRetireNewsBody(String name, String nation, int age) {
    return '$name（$nation）が$age歳で代表引退を発表しました。';
  }

  @override
  String msgIntlComebackTitle(String name) {
    return '$nameが代表復帰';
  }

  @override
  String msgIntlComebackBody(String name, int age) {
    return '$nameが$age歳で再び招集可能になりました。';
  }

  @override
  String get msgIntlComebackNoteCrisis => ' 負傷者が相次ぐチームの求めに応じました。';

  @override
  String get msgIntlComebackNoteManager => ' 新監督の説得で翻意しました。';

  @override
  String msgIntlComebackNewsTitle(String nation, String name) {
    return '$nation：$nameが代表復帰';
  }

  @override
  String msgIntlComebackNewsBody(String name, String nation, int age) {
    return '$name（$nation）が$age歳で再び招集可能になりました。';
  }

  @override
  String playerIntlRetired(int year) {
    return '代表引退（$year年）';
  }

  @override
  String playerIntlComeback(int year) {
    return '代表復帰（$year年）';
  }

  @override
  String yLegendRetires0(String name) {
    return 'ありがとう、$name。ユニフォームを着る選手は多いけど、彼はチームを背負った。';
  }

  @override
  String yLegendRetires1(String name) {
    return '$nameが代表キャリアに幕。ひとつの時代の終わり。';
  }

  @override
  String yLegendRetires2(String name) {
    return '$nameが引退。正直、一大会遅かった。';
  }

  @override
  String yLegendRetires3(String name) {
    return '$nameも終わりか。そろそろ若手にチャンスを。';
  }

  @override
  String matchAltitudeOpponentsTire(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return '標高${altitudeString}m：相手は早く消耗します';
  }

  @override
  String matchAltitudeYouTire(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return '標高${altitudeString}m：あなたの選手は早く消耗します';
  }

  @override
  String matchAltitudeBothTire(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return '標高${altitudeString}m：両チームとも早く消耗します';
  }

  @override
  String matchAltitudeUsedTo(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return '標高${altitudeString}m：両チームとも慣れています';
  }

  @override
  String matchHeatExpected(int temp) {
    final intl.NumberFormat tempNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String tempString = tempNumberFormat.format(temp);

    return '暑さ：$tempString°Cの予想、早めに足が止まります';
  }

  @override
  String get matchConditionsAdvice => '交代は早めに計画を：ここでは疲れていない選手が物を言います';

  @override
  String get fanMoodFurious => '激怒';

  @override
  String get fanMoodRestless => '不満';

  @override
  String get fanMoodCalm => '平静';

  @override
  String get fanMoodUpbeat => '上向き';

  @override
  String get fanMoodEuphoric => '熱狂';

  @override
  String matchHomeFans(String mood) {
    return 'ホームのサポーター: $mood';
  }

  @override
  String federationFans(String mood) {
    return 'サポーター: $mood';
  }

  @override
  String federationFansIncome(String change) {
    return '次のサイクルのスタジアム収入: $change';
  }

  @override
  String yFansProtest0(String nation, String manager) {
    return 'ホームもアウェイも代表を追いかけて20年。何かが変わるまで、シーズンチケットは更新しない。';
  }

  @override
  String yFansProtest1(String nation, String manager) {
    return 'ユニフォームのために歌い続ける。でも今夜、北スタンドの横断幕はみんなが思っていることを書いていた。';
  }

  @override
  String yFansProtest2(String nation, String manager) {
    return 'スタンドの半分は空席、来た半分は後半ずっと #${manager}Out を叫んでいた。';
  }

  @override
  String yFansProtest3(String nation, String manager) {
    return 'サポーター団体が次のホーム戦のボイコットを話し合っている。責める気にはなれない。';
  }

  @override
  String yFansProtest4(String nation, String manager) {
    return '#${manager}Out。もう怒ってもいない。ただ、終わりだ。';
  }

  @override
  String yFansProtest5(String nation, String manager) {
    return '今夜の写真: ずらりと並ぶ空席と、#${manager}Out と書かれたシーツが1枚。これが試合リポートだ。';
  }

  @override
  String yFansSellOut0(String nation) {
    return 'またも完売。ここ数年で最高の代表チームだと、国中が知っている。';
  }

  @override
  String yFansSellOut1(String nation) {
    return '次のホーム戦のチケットは11分で売り切れた。このチームが週末を取り戻してくれた。';
  }

  @override
  String yFansSellOut2(String nation) {
    return '次のホーム戦は空席ゼロ。協会は笑顔で入場料収入を数えるだろう。';
  }

  @override
  String yFansSellOut3(String nation) {
    return 'また完売。戦術について何と言おうと、みんなあのスタジアムに行きたいんだ。';
  }

  @override
  String yFansSellOut4(String nation) {
    return '完売ね、はいはい。1年半前、このチームにブーイングしていたのと同じ人たちだ。';
  }

  @override
  String yFansSellOut5(String nation) {
    return '急に完売、急にみんな評論家。誰にも勝てなかった頃、どこにいたんだ？';
  }

  @override
  String get campaignsIntro =>
      'キャンペーンは特別に作られた挑戦です。決められた代表チーム、独自のひねりがある世界、そして決められたサイクル数で達成すべき目標があります。各挑戦はキャリアのセーブとは別に進み、先へ進むほど星が増え、最大で3つ獲得できます。';

  @override
  String hubEventScandal(String player) {
    return '合宿でスキャンダル: $player';
  }

  @override
  String get hubEventScandalSub => '帰国させますか、残しますか?';

  @override
  String get scandalTitle => 'スキャンダル';

  @override
  String scandalStoryParty(String player) {
    return '$playerが明け方まで続くパーティーに参加し、代表が集合した朝、その写真が全紙に載りました。';
  }

  @override
  String scandalStoryCurfew(String player) {
    return '$playerがチームの門限を破り、明け方にホテルへ戻るところを見つかりました。';
  }

  @override
  String scandalStoryNightclub(String player) {
    return '$playerが合宿前夜にナイトクラブで撮影され、写真があちこちに出回っています。';
  }

  @override
  String scandalStoryCasino(String player) {
    return '$playerが合宿前夜をカジノのテーブルで過ごし、タブロイド紙が写真を押さえています。';
  }

  @override
  String get scandalSendHome => '帰国させる';

  @override
  String scandalSendHomeCover(String player) {
    return '帰国させ、$playerを招集';
  }

  @override
  String scandalKeep(String player) {
    return '$playerを残す';
  }

  @override
  String get scandalKeepNote => '残す場合: サイクル終了まで士気 約-4、協会 約-3。';

  @override
  String get scandalSendHomeNote => '帰国させる場合: 士気にも協会にも影響はなく、代わりの選手を招集できます。';

  @override
  String get scandalFinalsNote =>
      '帰国させる場合: 士気にも協会にも影響はありませんが、本大会では代わりを招集できません。';

  @override
  String get scandalPickCover => '代わりの選手を招集(任意)';

  @override
  String newsScandalTitle(String player) {
    return '合宿でスキャンダル: $player';
  }

  @override
  String yScandalParty0(String player, String tag) {
    return '若いんだから。合宿前夜にパーティーに行った$player、それでもピッチで見たい。#$tag';
  }

  @override
  String yScandalParty1(String player, String tag) {
    return '$player、代表集合の数時間前に夜通しのパーティーで撮影される。協会には報告済み。#$tag';
  }

  @override
  String yScandalParty2(String player, String tag) {
    return '合宿前に夜通しのパーティー。$player、何を考えてたんだ?信じられない。#$tag';
  }

  @override
  String yScandalCurfew0(String player, String tag) {
    return '門限破りか、まあ、よくあること。$playerはピッチで取り返せばいい。#$tag';
  }

  @override
  String yScandalCurfew1(String player, String tag) {
    return '$player、練習の数時間前、門限後にチームホテルへ戻るところを目撃される。#$tag';
  }

  @override
  String yScandalCurfew2(String player, String tag) {
    return '門限なんて難しくない。$playerは一晩も我慢できなかった。#$tag';
  }

  @override
  String yScandalNightclub0(String player, String tag) {
    return '$playerがクラブにいたって?選手にも生活はある。プレーさせてやれ。#$tag';
  }

  @override
  String yScandalNightclub1(String player, String tag) {
    return '代表合宿の前夜、ナイトクラブにいる$playerの写真が公開。#$tag';
  }

  @override
  String yScandalNightclub2(String player, String tag) {
    return '合宿前夜のクラブ写真。$playerはユニフォームに泥を塗った。#$tag';
  }

  @override
  String yScandalCasino0(String player, String tag) {
    return 'カジノで一晩過ごすのは犯罪じゃない。$playerなら大丈夫。#$tag';
  }

  @override
  String yScandalCasino1(String player, String tag) {
    return '$player、代表集合前夜にカジノのテーブルで目撃される。#$tag';
  }

  @override
  String yScandalCasino2(String player, String tag) {
    return '合宿前に一晩中カジノ。$playerが賭けたのはお金だけじゃない。#$tag';
  }

  @override
  String yScandalSentHome0(String player) {
    return '正しい判断。チームより大きい選手はいない。$playerも例外じゃない。';
  }

  @override
  String yScandalSentHome1(String player) {
    return '$playerを帰国させるのが唯一の答えだった。監督に敬意を。';
  }

  @override
  String yScandalSentHome2(String player) {
    return '規律は規律。$playerはルールを知っていた。';
  }

  @override
  String yScandalSentHome3(String player) {
    return 'チームへの明確なメッセージ。$playerはもう帰りの飛行機の中。';
  }

  @override
  String yScandalSentHome4(String player) {
    return '$playerには厳しすぎる。一晩出かけただけで合宿終了?';
  }

  @override
  String yScandalSentHome5(String player) {
    return '$playerを帰したらチームが弱くなる。ツケはピッチで払うことになる。';
  }

  @override
  String yScandalKept0(String player) {
    return '$playerを残すのは賭けだ。ピッチで返してもらわないと。';
  }

  @override
  String yScandalKept1(String player) {
    return 'わかった、$playerは残留。なら全員に最高のプレーで借りを返すべきだ。';
  }

  @override
  String yScandalKept2(String player) {
    return 'つまり$playerにはルールが適用されないと。よくわかった。';
  }

  @override
  String yScandalKept3(String player) {
    return '門限はもう自由参加らしい。$playerに聞いてみな。';
  }

  @override
  String yScandalKept4(String player) {
    return 'あれの後で$playerを残す?この代表はサマーキャンプか。';
  }

  @override
  String yScandalKept5(String player) {
    return '一晩中パーティーして、そのまま先発。素晴らしいメッセージだね、監督。$playerもさぞ喜んでるだろう。';
  }

  @override
  String get yStreamerBreaks0 => '兄弟バレたーー😭😭 合宿の前夜に??? 泣いてる💀💀💀';

  @override
  String get yStreamerBreaks1 => 'いやいやチャット見てこれ🤯🤯 兄弟マジで合宿前にやったんだけど😭🔥';

  @override
  String get yStreamerBreaks2 => '誰が外に出したの??誰が出したの😭😭💀 これは映画だろ🔥🔥';

  @override
  String get yStreamerSentHome0 => '帰国??帰国だーー!!!😭😭😭 監督ガチすぎ💀🔥';

  @override
  String get yStreamerSentHome1 => '兄弟が生配信で荷造りしてる🤯🤯 さよなら兄弟😭👋';

  @override
  String get yStreamerSentHome2 => 'ありえなーーい 本当に帰されたー💀💀 チャット震えが止まらない🔥🔥🔥';

  @override
  String get yStreamerKept0 => '残るの???残るのーー🤯🤯 兄弟アンタッチャブルすぎ😭🔥';

  @override
  String get yStreamerKept1 => '一晩中パーティーしてまだメンバー入り💀💀 その契約オレにもくれ😭😭';

  @override
  String get yStreamerKept2 => '監督が問題ないって😭😭 兄弟なんで🤯🤯🤯';

  @override
  String get yCameoUjfaloci => '何も払っていないし、その金額も合っていない';

  @override
  String get yCameoHavir0 => '小魚たちは泳いで行ってしまった。';

  @override
  String get yCameoHavir1 => '網は投げた。魚は別の場所にいた。';

  @override
  String get yCameoHavir2 => '9月にグヤーシュを食べながら言ったはずだ。';

  @override
  String get yCameoHavir3 => '時機に釣らなかった者は、今さら泣くな。';

  @override
  String get yCameoHavir4 => '陸に上がったナマズのような試合だった。';

  @override
  String get yCameoHavir5 => '風が吹き、池が凍る。そういうものだ。';

  @override
  String get yCameoHavir6 => '古い長靴しか釣れない日もある。';

  @override
  String get yCameoHavir7 => 'わしらの頃は、せめてビールを飲みに行ったものだ。今はそれすらない。';

  @override
  String get yCameoLzimberskyHome0 => '一晩のことで若者を帰国させる?スキャンダルはそっちだ、パーティーじゃない!';

  @override
  String get yCameoLzimberskyHome1 => '若い連中だって少しは楽しむ権利がある!偽善的なメディアがまた勝った。';

  @override
  String get yCameoLzimberskyHome2 => 'これは魔女狩りだ。若者が一晩出かけただけで吊るし上げる。';

  @override
  String get yCameoLzimberskyHome3 => 'パーティーに行ったことのない記者だけが石を投げよ。恥を知れ!';

  @override
  String get yCameoLzimberskyHome4 => '監督はタブロイドに怯えたんだ。私なら最後の一息まであの若者を守った!';

  @override
  String get yCameoLzimberskyKept0 => 'ついに骨のある監督が現れた!若者を残した。メディアは泣いていろ。';

  @override
  String get yCameoLzimberskyKept1 => '若い連中だって少しは楽しむ権利があるだろう?ブラボー、監督!';

  @override
  String get yCameoLzimberskyKept2 => '偽善的なメディアがわめき、監督は一歩も引かない。これが正しいやり方だ!';

  @override
  String get yCameoLzimberskyKept3 => '一晩出かけただけで、マスコミは石打ちにしたがる。監督こそ本物の男だ!';

  @override
  String get yCameoLzimberskyKept4 => '言わせてもらう、若者を自由にさせろ!よく働く者はよく遊ぶものだ。グッジョブ。';

  @override
  String get yTraitStreamer => '何でも配信する。音量は最大、文字は全部大文字。';

  @override
  String hubEventAwardsCeremony(int year) {
    return '年間最優秀選手 $year';
  }

  @override
  String get hubEventAwardsCeremonySub => '投票の集計が完了';

  @override
  String get potyCeremonyWatch => '授賞式を見る';

  @override
  String get potyCeremonySkipToList => 'トップ5へ進む';

  @override
  String get potyCeremonySkip => 'スキップ';

  @override
  String get potyCeremonyIntro => '投票の集計が完了しました。今年の世界のベスト5はこの選手たちです。';

  @override
  String potyCeremonyPlace(int place) {
    return '$place位';
  }

  @override
  String get potyCeremonyWinnerIs => 'そして年間最優秀選手は...';

  @override
  String get potyTop5Heading => '世界のトップ5';

  @override
  String get potyYoungTop3Heading => '年間最優秀若手選手: トップ3';

  @override
  String get potySeeTop5 => 'トップ5を見る';

  @override
  String get potyYourPlayer => 'あなたの選手';

  @override
  String potyTallyCleanSheets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '完封$count試合',
    );
    return '$_temp0';
  }

  @override
  String get campaignFullBrief => 'ブリーフ全文';

  @override
  String campaignStarsSoFar(int earned, int total) {
    return 'これまでに獲得した星: $earned/$total';
  }

  @override
  String get campaignStarEarned => '獲得済み';

  @override
  String get campaignStarNotYet => '未獲得';

  @override
  String get stadiumsEntrySubClosed => 'スタジアムを確認できます。工事の発注は次のサイクルの開始時に再開します。';

  @override
  String get boardObjectiveNoBrief => '目標なし';

  @override
  String get boardObjectiveNoBriefBody =>
      '協会はこの本大会への出場を期待していません。代わりに試合結果で評価されます。';

  @override
  String get boardObjectiveAwaitingDraw => '抽選後に目標設定';

  @override
  String get boardObjectiveAwaitingDrawBody => 'グループ抽選の後、協会がこの目標を設定します。';
}
