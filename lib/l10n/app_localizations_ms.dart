// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malay (`ms`).
class AppLocalizationsMs extends AppLocalizations {
  AppLocalizationsMs([String locale = 'ms']) : super(locale);

  @override
  String get matchPreviewTitle => 'PRATONTON PERLAWANAN';

  @override
  String get matchKickOff => 'Sepak mula';

  @override
  String get matchTactics => 'Taktik';

  @override
  String get matchYourXi => 'KESEBELASAN ANDA';

  @override
  String get matchHeadToHead => 'PERTEMUAN BERSEMUKA';

  @override
  String matchCouldNotLoad(String error) {
    return 'Perlawanan tidak dapat dimuatkan.\n$error';
  }

  @override
  String get matchNoUpcoming => 'Tiada perlawanan akan datang.';

  @override
  String get matchUnknownNation => 'Tidak diketahui';

  @override
  String get matchH2hFirstMeeting => 'Pertemuan pertama';

  @override
  String get matchH2hYouLead => 'Anda mendahului rekod pertemuan';

  @override
  String matchH2hOppEdge(String opponent) {
    return '$opponent lebih unggul';
  }

  @override
  String get matchH2hEven => 'Sama kuat';

  @override
  String matchH2hMet(int count) {
    return '$count pertemuan';
  }

  @override
  String get matchH2hWon => 'Menang';

  @override
  String get matchH2hDrawn => 'Seri';

  @override
  String get matchH2hLost => 'Kalah';

  @override
  String get matchDossierTitle => 'Laporan risikan';

  @override
  String get matchDossierForm => 'PRESTASI';

  @override
  String get matchDossierNoGames => 'Tiada perlawanan terkini';

  @override
  String get matchDossierKeyMen => 'PEMAIN UTAMA';

  @override
  String get matchDossierHowTheyPlay => 'CARA MEREKA BERMAIN';

  @override
  String matchScoutFormation1(String formation) {
    return 'Mereka biasanya bermain dengan formasi $formation.';
  }

  @override
  String matchScoutFormation2(String formation) {
    return 'Susunan biasa mereka ialah $formation.';
  }

  @override
  String matchScoutFormation3(String formation) {
    return 'Mereka cenderung menggunakan formasi $formation.';
  }

  @override
  String get matchScoutStrengthPressing =>
      'Mereka mengasak tinggi dan memburu bola.';

  @override
  String get matchScoutStrengthDirect =>
      'Mereka bermain secara terus dan cepat menghantar bola ke hadapan.';

  @override
  String get matchScoutStrengthPossession =>
      'Mereka menguasai bola dengan baik dan membina serangan dengan sabar.';

  @override
  String get matchScoutStrengthCounter =>
      'Mereka menunggu di belakang dan pantas melancarkan serangan balas.';

  @override
  String get matchScoutStrengthDeepDefence =>
      'Mereka bertahan jauh di belakang dan sukar ditembusi.';

  @override
  String get matchScoutStrengthWide =>
      'Mereka melebarkan permainan dan menyerang melalui sayap.';

  @override
  String get matchScoutStrengthAttacking =>
      'Mereka gemar mengambil inisiatif menyerang lawan.';

  @override
  String get matchScoutStrengthQuickForwards =>
      'Penyerang mereka pantas dan gemar berlari ke belakang pertahanan.';

  @override
  String get matchScoutStrengthPassingMidfield =>
      'Bahagian tengah mereka menghantar bola dengan baik.';

  @override
  String get matchScoutStrengthHardRunning =>
      'Pemain tengah mereka mampu berlari sepanjang perlawanan.';

  @override
  String get matchScoutStrengthSetPieces =>
      'Mereka berbahaya melalui bola mati.';

  @override
  String get matchScoutStrengthQuickDefence =>
      'Barisan pertahanan mereka pantas dan sukar dibolosi dari belakang.';

  @override
  String get matchScoutStrengthNone =>
      'Tiada apa-apa yang benar-benar menonjol dalam permainan mereka.';

  @override
  String get matchScoutWeakSpaceBehind =>
      'Garisan tinggi mereka meninggalkan ruang di belakang untuk bola lambung.';

  @override
  String get matchScoutWeakPressedBuildUp =>
      'Asakan tinggi boleh mengganggu binaan serangan mereka yang perlahan.';

  @override
  String get matchScoutWeakDeepBlock =>
      'Bersabar: benteng dalam seperti mereka boleh dipecahkan.';

  @override
  String get matchScoutWeakLongBall =>
      'Turunkan garisan anda dan bola panjang mereka tidak akan ke mana-mana.';

  @override
  String get matchScoutWeakSlowDefence =>
      'Pertahanan mereka kurang pantas, jadi hantar pelari ke belakang mereka.';

  @override
  String get matchScoutWeakAerial =>
      'Mereka kelihatan goyah ketika mempertahankan bola mati.';

  @override
  String get matchScoutWeakPoorPassing =>
      'Bahagian tengah mereka sukar melepaskan diri daripada tekanan melalui hantaran.';

  @override
  String get matchScoutWeakTiringMidfield =>
      'Pemain tengah mereka tidak cukup stamina untuk mengekalkan asakan.';

  @override
  String get matchScoutWeakBluntAttack => 'Penyerang mereka kurang pantas.';

  @override
  String get matchScoutApproachTakeTheGame =>
      'Menentang anda, mereka dijangka mengambil inisiatif.';

  @override
  String get matchScoutApproachEven =>
      'Menentang anda, jangkakan perlawanan yang sengit dan seimbang.';

  @override
  String get matchScoutApproachSitDeep =>
      'Menentang anda, mereka dijangka berhati-hati dan menunggu peluang serangan balas.';

  @override
  String get matchScoutLeaningAttacking =>
      'Dari jauh, mereka kelihatan seperti pasukan yang menyerang.';

  @override
  String get matchScoutLeaningCautious =>
      'Dari jauh, mereka kelihatan seperti pasukan yang berhati-hati.';

  @override
  String get matchScoutLeaningUnclear =>
      'Dari jauh, sukar untuk mengatakan bagaimana mereka gemar bermain.';

  @override
  String get matchScoutHireHint =>
      'Lantik Ketua Pencari Bakat untuk mengetahui cara mereka bermain.';

  @override
  String matchCouldNotContinue(String error) {
    return 'Tidak dapat diteruskan: $error';
  }

  @override
  String get matchSkipToFullTime => 'Langkau ke tamat perlawanan';

  @override
  String get matchStatShots => 'Rembatan';

  @override
  String get matchStatGoals => 'Gol';

  @override
  String get matchStatYellowCards => 'Kuning';

  @override
  String get matchStatRedCards => 'Merah';

  @override
  String get matchMomentum => 'MOMENTUM';

  @override
  String get matchSwingAtk => 'SRG';

  @override
  String get matchSwingDef => 'PTH';

  @override
  String ceremonyWorldCupYear(int year) {
    return 'KEJOHANAN DUNIA $year';
  }

  @override
  String get ceremonyFinalsAreHere => 'PUSINGAN AKHIR TELAH TIBA';

  @override
  String ceremonyHostedBy(String hosts) {
    return 'TUAN RUMAH  $hosts';
  }

  @override
  String get ceremonyHostTbc => 'TUAN RUMAH BELUM DISAHKAN';

  @override
  String get matchHalfTime => 'SEPARUH MASA';

  @override
  String get matchContinue => 'Teruskan';

  @override
  String get matchContinuing => 'Meneruskan…';

  @override
  String matchTacticsWithSubs(int used, int max) {
    return 'Taktik · $used/$max gantian';
  }

  @override
  String matchTiredCount(int count) {
    return 'LETIH ×$count';
  }

  @override
  String get matchTacticsLabel => 'TAKTIK';

  @override
  String get teamOverallOverTime => 'KESELURUHAN MENGIKUT TAHUN';

  @override
  String get teamOverall => 'Keseluruhan';

  @override
  String get teamTalkHeading => 'CERAMAH PASUKAN';

  @override
  String get teamTalkPrompt => 'Tetapkan nada untuk separuh masa kedua.';

  @override
  String get teamTalkCalmLabel => 'Bertenang';

  @override
  String get teamTalkCalmBlurb =>
      'Tenangkan pasukan. Sedikit peningkatan menyeluruh.';

  @override
  String get teamTalkEncourageLabel => 'Beri semangat';

  @override
  String get teamTalkEncourageBlurb => 'Mara ke hadapan dan cuba menang.';

  @override
  String get teamTalkDemandMoreLabel => 'Tuntut lebih';

  @override
  String get teamTalkDemandMoreBlurb =>
      'Kerahkan segalanya. Serang habis-habisan.';

  @override
  String get teamTalkPraiseLabel => 'Kekal rapat';

  @override
  String get teamTalkPraiseBlurb => 'Kekal padat dan pertahankan apa yang ada.';

  @override
  String get teamTalkBelieveLabel => 'Percaya';

  @override
  String get teamTalkBelieveBlurb =>
      'Yakin pada diri sendiri. Peningkatan di kedua-dua hujung padang.';

  @override
  String get teamTalkFocusLabel => 'Kekal fokus';

  @override
  String get teamTalkFocusBlurb => 'Tumpuan penuh. Kunci perlawanan ini.';

  @override
  String get teamTalkUrgencyLabel => 'Rasa terdesak';

  @override
  String get teamTalkUrgencyBlurb =>
      'Kejar sekarang. Habis-habisan, tetapi meninggalkan ruang.';

  @override
  String get teamTalkReassureLabel => 'Tiada tekanan';

  @override
  String get teamTalkReassureBlurb =>
      'Redakan gementar dan kekalkan bentuk pasukan.';

  @override
  String get commonRetry => 'Cuba lagi';

  @override
  String get commonSomethingWentWrong => 'Ada sesuatu yang tidak kena';

  @override
  String get commonCrashBox =>
      'Ada sesuatu yang tidak kena di sini.\nTetapan → Diagnostik mempunyai butirannya.';

  @override
  String hubCouldNotAdvance(String error) {
    return 'Dunia tidak dapat diteruskan: $error';
  }

  @override
  String get settingsDiagnosticsTitle => 'Diagnostik';

  @override
  String get settingsDiagnosticsBlurb =>
      'Ralat yang direkodkan pada peranti ini. Tiada apa-apa yang dihantar.';

  @override
  String get settingsContactTitle => 'Hubungi';

  @override
  String get settingsContactCopied => 'Alamat disalin.';

  @override
  String get settingsCommunityTitle => 'Komuniti';

  @override
  String get settingsDiscordSubtitle => 'Sertai komuniti';

  @override
  String get settingsLinkCopied => 'Pautan disalin.';

  @override
  String get diagnosticsEmpty => 'Tiada ralat direkodkan. Itulah tujuannya.';

  @override
  String get diagnosticsCopy => 'Salin';

  @override
  String get diagnosticsCopied => 'Log disalin ke papan klip.';

  @override
  String get diagnosticsClear => 'Kosongkan';

  @override
  String get navHub => 'Hab';

  @override
  String get navSquad => 'Skuad';

  @override
  String get navStandings => 'Kedudukan';

  @override
  String get navCareers => 'Kerjaya Saya';

  @override
  String get settingsTitle => 'TETAPAN';

  @override
  String get settingsSoundHapticsTitle => 'Bunyi & haptik';

  @override
  String get settingsSoundHapticsBlurb =>
      'Getaran dan bunyi ringkas ketika gol, sepak mula dan tamat perlawanan.';

  @override
  String get settingsLanguageTitle => 'Bahasa';

  @override
  String get settingsLanguageBlurb =>
      'Pilih bahasa aplikasi, atau ikut peranti anda.';

  @override
  String get settingsLanguageSystem => 'Sistem';

  @override
  String get settingsTextSizeTitle => 'Saiz teks';

  @override
  String get settingsTextSizeBlurb => 'Besarkan teks jika sukar dibaca.';

  @override
  String get settingsTextSizeNormal => 'Biasa';

  @override
  String get settingsTextSizeLarge => 'Besar';

  @override
  String get settingsTextSizeLarger => 'Lebih besar';

  @override
  String get matchPreviewAllMeetings => 'Semua pertemuan';

  @override
  String get recordsMeetings => 'PERTEMUAN';

  @override
  String get recordsLegends => 'LEGENDA';

  @override
  String get recordsAllTimeXi => 'KESEBELASAN TERHEBAT';

  @override
  String get recordsHallOfFame => 'DEWAN KEMASYHURAN';

  @override
  String get recordsAllTimeWorld => 'DUNIA SEPANJANG ZAMAN';

  @override
  String get recordsAllTimeTopScorers => 'PENJARING TERBANYAK SEPANJANG ZAMAN';

  @override
  String get recordsMostCapped => 'PENAMPILAN TERBANYAK';

  @override
  String get recordsMostWcStarts => 'PEMAIN UTAMA KEJOHANAN DUNIA';

  @override
  String get recordsMostTournaments => 'PALING BANYAK KEJOHANAN DISERTAI';

  @override
  String get recordsRecordBook => 'BUKU REKOD';

  @override
  String get recordsHeadToHead => 'PERTEMUAN BERSEMUKA';

  @override
  String get recordsFiercestRival => 'SETERU PALING SENGIT';

  @override
  String get recordsMostCaps => 'PENAMPILAN TERBANYAK';

  @override
  String get recordsTopScorers => 'PENJARING TERBANYAK';

  @override
  String get recordsMostAssists => 'BANTUAN TERBANYAK';

  @override
  String get recordsYourRecord => 'REKOD ANDA';

  @override
  String get callUpHome => 'LAMAN SENDIRI';

  @override
  String get callUpAway => 'TANDANG';

  @override
  String get recordsHome => 'LAMAN SENDIRI';

  @override
  String get recordsAway => 'TANDANG';

  @override
  String get recordsActive => 'AKTIF';

  @override
  String get recordsStillActive => 'Masih aktif';

  @override
  String get recordsAvg => 'purata';

  @override
  String get recordsSelect => 'Pilih';

  @override
  String get recordsVs => 'lwn';

  @override
  String get recordsDraws => 'Seri';

  @override
  String get recordsGoalsLabel => 'Gol';

  @override
  String get recordsBestFinish => 'Pencapaian terbaik';

  @override
  String get recordsNoFinalsYet => 'Belum pernah ke pusingan akhir';

  @override
  String get recordsLongestUnbeaten => 'Rentetan tanpa kalah terpanjang';

  @override
  String get recordsBiggestWin => 'Kemenangan terbesar';

  @override
  String get recordsSeeAllMeetings => 'Lihat semua pertemuan';

  @override
  String get recordsSaveNotFound => 'Simpanan tidak dijumpai.';

  @override
  String get recordsNoMatches => 'Tiada padanan.';

  @override
  String get recordsSearchPlayerOrNation => 'Cari pemain atau negara';

  @override
  String get recordsSearchNation => 'Cari negara';

  @override
  String get recordsPickTwoDifferent => 'Pilih dua negara yang berbeza.';

  @override
  String get recordsPlayToBuildRecord =>
      'Main beberapa perlawanan dan rekod anda menentang setiap lawan akan terbina di sini.';

  @override
  String get recordsTapOpponent => 'Ketik lawan untuk butiran penuh.';

  @override
  String get recordsEdgeUpperHand => 'Anda lebih unggul';

  @override
  String get recordsEdgeTheirNumber => 'Mereka sering menewaskan anda';

  @override
  String get recordsEdgeEven => 'Sama kuat';

  @override
  String get recordsAllTimeWorldSubtitle =>
      'Penjaring & penampilan terbanyak dunia, semua negara';

  @override
  String get recordsHeadToHeadSubtitle =>
      'Bandingkan rekod sepanjang zaman mana-mana dua negara';

  @override
  String get recordsLegendsSubtitle =>
      'Kesebelasan terhebat & dewan kemasyhuran';

  @override
  String get recordsUnitGoals => 'gol';

  @override
  String get recordsUnitCaps => 'penampilan';

  @override
  String get recordsUnitStarts => 'kali bermula';

  @override
  String get recordsUnitCups => 'kejohanan';

  @override
  String get recordsUnitAssists => 'bantuan';

  @override
  String recordsCapsCount(int count) {
    return '$count penampilan';
  }

  @override
  String recordsGoalsCount(int count) {
    return '$count gol';
  }

  @override
  String recordsAssistsCount(int count) {
    return '$count bantuan';
  }

  @override
  String recordsMotmCount(int count) {
    return '$count PTP';
  }

  @override
  String recordsMatchesCount(int count) {
    return '$count perlawanan';
  }

  @override
  String recordsMeetingsCount(int count) {
    return '$count pertemuan';
  }

  @override
  String recordsCodeWins(String code) {
    return '$code menang';
  }

  @override
  String recordsMeetingsWdl(int meetings, int wins, int draws, int losses) {
    return '$meetings pertemuan · ${wins}M ${draws}S ${losses}K';
  }

  @override
  String recordsWdl(int wins, int draws, int losses) {
    return '${wins}M ${draws}S ${losses}K';
  }

  @override
  String recordsRivalLine(int meetings, String record, String edge) {
    return '$meetings pertemuan · $record · $edge';
  }

  @override
  String recordsNeverMet(String a, String b) {
    return '$a dan $b belum pernah bertemu dalam simpanan ini.';
  }

  @override
  String tacticsSentOffNote(String names) {
    return '$names dilayangkan kad merah. Tiada pengganti, jadi anda bermain dengan kekurangan pemain.';
  }

  @override
  String tacticsNeedFitPlayers(int required, int have) {
    return 'Perlu $required pemain tersedia ($have cergas)';
  }

  @override
  String tacticsMissesOfCamp(int missed, int total) {
    return 'Terlepas $missed/$total';
  }

  @override
  String get tacticsOutForWholeCamp =>
      'Tidak dapat bermain sepanjang panggilan ini';

  @override
  String get rankingCentreOnMe => 'Fokus pada negara saya';

  @override
  String get recordsAfterExtraTime => 'm.t.';

  @override
  String recordsOnPenalties(int a, int b) {
    return '$a–$b penalti';
  }

  @override
  String recordsVersus(String a, String b) {
    return '$a lwn $b';
  }

  @override
  String recordsPlayedScore(int played, int gf, int ga) {
    return '$played perlawanan · $gf–$ga';
  }

  @override
  String recordsBiggestWinValue(int gf, int ga, String opp) {
    return '$gf–$ga lwn $opp';
  }

  @override
  String recordsCouldNotLoad(String error) {
    return 'Tidak dapat dimuatkan.\n$error';
  }

  @override
  String recordsCouldNotLoadLegends(String error) {
    return 'Legenda tidak dapat dimuatkan.\n$error';
  }

  @override
  String recordsCouldNotLoadRecords(String error) {
    return 'Rekod tidak dapat dimuatkan.\n$error';
  }

  @override
  String recordsCouldNotLoadNations(String error) {
    return 'Senarai negara tidak dapat dimuatkan.\n$error';
  }

  @override
  String recordsCouldNotLoadYourRecord(String error) {
    return 'Rekod anda tidak dapat dimuatkan.\n$error';
  }

  @override
  String recordsCouldNotLoadRecord(String error) {
    return 'Rekod tidak dapat dimuatkan.\n$error';
  }

  @override
  String recordsNoLegends(String nation) {
    return 'Belum ada legenda. Main beberapa kempen dan pemain hebat $nation akan muncul di sini.';
  }

  @override
  String recordsGreatestSide(String nation) {
    return 'Pasukan terhebat yang pernah boleh diturunkan oleh $nation.';
  }

  @override
  String get recordsNoWorldHistory =>
      'Dunia belum mempunyai sejarah. Main beberapa kempen dan pemain hebat sepanjang zaman akan muncul di sini.';

  @override
  String recordsPlayToWriteHistory(String nation) {
    return 'Main beberapa perlawanan untuk mula menulis sejarah $nation.';
  }

  @override
  String get tacticsLineGk => 'PG';

  @override
  String get tacticsLineDef => 'PTH';

  @override
  String get tacticsLineMid => 'TGH';

  @override
  String get tacticsLineFwd => 'SRG';

  @override
  String get tacticsGoalkeepers => 'PENJAGA GOL';

  @override
  String get tacticsDefenders => 'PEMAIN PERTAHANAN';

  @override
  String get tacticsMidfielders => 'PEMAIN TENGAH';

  @override
  String get tacticsForwards => 'PENYERANG';

  @override
  String get tacticsCallUpsTitle => 'PANGGILAN SKUAD';

  @override
  String tacticsPickAtLeastPlayers(int min) {
    return 'Pilih sekurang-kurangnya $min pemain.';
  }

  @override
  String tacticsCouldNotLoadSquad(String error) {
    return 'Skuad tidak dapat dimuatkan.\n$error';
  }

  @override
  String get tacticsNoSquad => 'Tiada skuad.';

  @override
  String tacticsSquadCount(int count, int max) {
    return 'SKUAD · $count/$max';
  }

  @override
  String tacticsMinMax(int min, int max) {
    return 'Min $min · Maks $max';
  }

  @override
  String get tacticsBestQuality => 'Kualiti terbaik';

  @override
  String get tacticsPreviousSquad => 'Skuad terdahulu';

  @override
  String get tacticsSquadLockedBack => 'Kembali (skuad dikunci)';

  @override
  String get tacticsConfirmSquad => 'Sahkan skuad';

  @override
  String tacticsSquadFullMax(int max) {
    return 'Skuad penuh (maks $max)';
  }

  @override
  String get tacticsSquadLocked => 'SKUAD DIKUNCI';

  @override
  String get tacticsNominationOpen => 'PENCALONAN DIBUKA. PILIH SKUAD ANDA';

  @override
  String get tacticsSquadFixedBlurb =>
      'Skuad ini tetap untuk perlawanan di bawah. Pilih semula sebelum tempoh pencalonan seterusnya.';

  @override
  String get tacticsSquadWillPlayBlurb =>
      'Skuad ini akan bermain dalam perlawanan di bawah.';

  @override
  String get tacticsUnknown => 'Tidak diketahui';

  @override
  String tacticsAgeValue(int age, String value) {
    return 'Umur $age · $value';
  }

  @override
  String get tacticsFatigueExhausted => 'Keletihan';

  @override
  String get tacticsFatigueTired => 'Letih';

  @override
  String get tacticsFatigueMatchLegs => 'Penat perlawanan';

  @override
  String tacticsTooManySubs(int max) {
    return 'Terlalu banyak gantian (maks $max).';
  }

  @override
  String tacticsMinuteTitle(int minute) {
    return 'TAKTIK · $minute\'';
  }

  @override
  String get tacticsApply => 'GUNAKAN';

  @override
  String get tacticsTabLineupSubs => 'BARISAN & GANTIAN';

  @override
  String get tacticsTabTactics => 'TAKTIK';

  @override
  String get squadLineKeepers => 'PENJAGA GOL';

  @override
  String get squadLineDefenders => 'PERTAHANAN';

  @override
  String get squadLineMidfielders => 'TENGAH';

  @override
  String get squadLineForwards => 'SERANGAN';

  @override
  String get squadStatXiRating => 'Penarafan XI';

  @override
  String get squadStatAvgAge => 'Purata umur';

  @override
  String get squadStatSize => 'Skuad';

  @override
  String get squadStatUnavailable => 'Tiada';

  @override
  String get squadDepthTitle => 'KEDALAMAN MENGIKUT BARISAN';

  @override
  String squadAgeShort(int age) {
    return '${age}t';
  }

  @override
  String get tacticsTabOtherPositions => 'POSISI LAIN';

  @override
  String get tacticsOutOfPositionNote => 'Bukan posisi asal di sini';

  @override
  String get tacticsNobodyElse => 'Tiada pemain lain untuk dicuba di sini.';

  @override
  String get tacticsPickSomebodyFirst =>
      'Pilih siapa yang keluar dan pemain simpanan lain akan muncul di sini, bersama penarafan mereka di posisi ini.';

  @override
  String get tacticsTabSuitable => 'SESUAI';

  @override
  String get tacticsTabOnPitch => 'DI PADANG';

  @override
  String tacticsSectionSuitable(int count) {
    return 'SESUAI · $count';
  }

  @override
  String get tacticsNobodySuits =>
      'Tiada pemain simpanan yang sesuai secara semula jadi untuk posisi ini, jadi ini semua pemain.';

  @override
  String tacticsSectionOnPitch(int count, int max) {
    return 'DI PADANG · $count/$max';
  }

  @override
  String tacticsSectionAvailable(int count) {
    return 'TERSEDIA · $count';
  }

  @override
  String get tacticsRowStarted => 'Bermula';

  @override
  String tacticsRowCameOn(int minute) {
    return 'Masuk minit $minute\'';
  }

  @override
  String get tacticsRowSubstitute => 'Masuk';

  @override
  String get tacticsEnergyLabel => 'TENAGA';

  @override
  String tacticsPickReplacementFor(String name) {
    return 'Ketik pengganti untuk $name, atau ketik dia sekali lagi untuk batal.';
  }

  @override
  String get tacticsSlotLostToRedCard =>
      'Kad merah menyebabkan anda kehilangan posisi ini. Seret rakan sepasukan ke sini untuk mengalihkan kekosongan.';

  @override
  String get tacticsSentOffShort => 'KAD MERAH';

  @override
  String get tacticsFullBackLeft => 'Bek kiri';

  @override
  String get tacticsFullBackRight => 'Bek kanan';

  @override
  String get tacticsFullBackUp => 'Bantu serangan';

  @override
  String get tacticsFullBackDown => 'Kekal di belakang';

  @override
  String get tacticsFullBackOff => 'Tiada arahan';

  @override
  String tacticsFullBackUpHint(String side) {
    return '$side: bantu serangan. Serangan bertambah sedikit, risiko juga bertambah sedikit.';
  }

  @override
  String tacticsFullBackDownHint(String side) {
    return '$side: kekal di belakang. Lebih selamat sedikit, serangan berkurang sedikit.';
  }

  @override
  String tacticsFullBackOffHint(String side) {
    return '$side: tiada arahan, bermain mengikut rancangan pasukan.';
  }

  @override
  String tacticsFullBackSemantics(String side, String state) {
    return '$side, anak panah: $state';
  }

  @override
  String tacticsSubsUsed(int used, int max) {
    return 'GANTIAN · $used/$max';
  }

  @override
  String get tacticsDragSubOn =>
      'Ketik pemain di padang untuk mengeluarkannya, atau tekan lama dan seret pemain gantian ke atasnya.';

  @override
  String get tacticsNoSubs => 'Tiada pemain gantian tersedia.';

  @override
  String get tacticsChooseShape => 'PILIH FORMASI';

  @override
  String get tacticsFormation => 'FORMASI';

  @override
  String get tacticsInstructions => 'ARAHAN';

  @override
  String get tacticsDrilling => 'LATIHAN';

  @override
  String get tacticsDrillingUnplayed => 'BELUM DIMAINKAN';

  @override
  String get tacticsDrillingNew => 'BAHARU';

  @override
  String get tacticsDrillingSettling => 'MENYESUAIKAN';

  @override
  String get tacticsDrillingDrilled => 'MAHIR';

  @override
  String get tacticsInstrMentality => 'Mentaliti';

  @override
  String get tacticsInstrDefensive => 'Bertahan';

  @override
  String get tacticsInstrAttacking => 'Menyerang';

  @override
  String get tacticsInstrPressing => 'Asakan';

  @override
  String get tacticsInstrLowBlock => 'Benteng rendah';

  @override
  String get tacticsInstrHighPress => 'Asakan tinggi';

  @override
  String get tacticsInstrTempo => 'Tempo';

  @override
  String get tacticsInstrPatient => 'Sabar';

  @override
  String get tacticsInstrFast => 'Pantas';

  @override
  String get tacticsInstrWidth => 'Kelebaran';

  @override
  String get tacticsInstrNarrow => 'Sempit';

  @override
  String get tacticsInstrWide => 'Lebar';

  @override
  String get tacticsInstrDefLine => 'Gar. pertahanan';

  @override
  String get tacticsInstrDefensiveLine => 'Garisan pertahanan';

  @override
  String get tacticsInstrDeep => 'Dalam';

  @override
  String get tacticsInstrHigh => 'Tinggi';

  @override
  String get tacticsInstrDirectness => 'Permainan terus';

  @override
  String get tacticsInstrPossession => 'Penguasaan';

  @override
  String get tacticsInstrDirect => 'Terus';

  @override
  String get tacticsPickGoalkeeper => 'PILIH PENJAGA GOL';

  @override
  String get tacticsPickLeftBack => 'PILIH BEK KIRI';

  @override
  String get tacticsPickCentreBack => 'PILIH BEK TENGAH';

  @override
  String get tacticsPickRightBack => 'PILIH BEK KANAN';

  @override
  String get tacticsPickDefensiveMid => 'PILIH PEMAIN TENGAH BERTAHAN';

  @override
  String get tacticsPickCentralMid => 'PILIH PEMAIN TENGAH';

  @override
  String get tacticsPickAttackingMid => 'PILIH PEMAIN TENGAH MENYERANG';

  @override
  String get tacticsPickLeftMid => 'PILIH PEMAIN TENGAH KIRI';

  @override
  String get tacticsPickRightMid => 'PILIH PEMAIN TENGAH KANAN';

  @override
  String get tacticsPickLeftWing => 'PILIH PEMAIN SAYAP KIRI';

  @override
  String get tacticsPickRightWing => 'PILIH PEMAIN SAYAP KANAN';

  @override
  String get tacticsPickStriker => 'PILIH PENYERANG';

  @override
  String tacticsRoleOutOfPosition(String role) {
    return '$role · bukan posisi asal';
  }

  @override
  String tacticsAgeOnly(int age) {
    return 'Umur $age';
  }

  @override
  String tacticsRoleAge(String role, int age) {
    return '$role · Umur $age';
  }

  @override
  String get tacticsOn => 'MAIN';

  @override
  String get tacticsSquad => 'SKUAD';

  @override
  String get tacticsTabLineup => 'BARISAN';

  @override
  String get tacticsTabInstructions => 'ARAHAN';

  @override
  String get tacticsTabRoles => 'PERANAN';

  @override
  String get tacticsTabSetPieces => 'BOLA MATI';

  @override
  String get tacticsTabRolesSetPieces => 'PERANAN & BOLA MATI';

  @override
  String get tacticsRolesSetPiecesBlurb =>
      'Beri setiap pemain utama satu peranan. Ketik lencana penalti (⚽) atau sepakan percuma (▲) untuk menetapkan penyepak anda.';

  @override
  String get tacticsTooltipCallUps => 'Panggilan skuad';

  @override
  String get tacticsTooltipPresets => 'Taktik tersimpan';

  @override
  String get tacticsTooltipInstructions => 'Arahan';

  @override
  String get tacticsNoTacticSet => 'Tiada taktik ditetapkan.';

  @override
  String tacticsReplaceStarters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'GANTI $count PEMAIN UTAMA',
    );
    return '$_temp0';
  }

  @override
  String tacticsPlayerOut(String name, String reason) {
    return '$name: $reason';
  }

  @override
  String get tacticsOut => 'Tidak tersedia';

  @override
  String get tacticsTapSpotReplace =>
      'Ketik posisinya di padang untuk memilih pengganti.';

  @override
  String get tacticsTapOrDrag =>
      'Ketik pemain untuk menukarnya, atau tekan lama dan seret untuk mengalihkannya.';

  @override
  String get tacticsPlayerRoles => 'PERANAN PEMAIN';

  @override
  String get tacticsRolesBlurb =>
      'Beri pemain tugas: pemburu gol, pengatur permainan, penyerang sasaran. Menentukan siapa menjaring dan siapa mencipta peluang.';

  @override
  String get tacticsSetPieceTakers => 'PENYEPAK BOLA MATI';

  @override
  String get tacticsSetPieceBlurb =>
      'Siapa mengambil penalti dan bola mati, atau biarkan pemain paling sesuai.';

  @override
  String get tacticsTakerAuto => 'Automatik';

  @override
  String get tacticsTakerQuickPick => 'Guna penyepak terbaik';

  @override
  String get tacticsPenalties => 'Penalti';

  @override
  String get tacticsCornersFreeKicks => 'Sepakan sudut & percuma';

  @override
  String get tacticsSkillFin => 'PNY';

  @override
  String get tacticsSkillPas => 'HNT';

  @override
  String tacticsRolePlayer(String name) {
    return 'PERANAN · $name';
  }

  @override
  String get tacticsPenaltyTaker => 'PENYEPAK PENALTI';

  @override
  String get tacticsCornerFreeKickTaker => 'PENYEPAK SUDUT & PERCUMA';

  @override
  String get tacticsAutomatic => 'Automatik';

  @override
  String get tacticsLetBestSuited =>
      'Biarkan pemain paling sesuai mengambilnya.';

  @override
  String get tacticsInXi => 'DALAM XI';

  @override
  String get tacticsTeamInstructions => 'ARAHAN PASUKAN';

  @override
  String get tacticsTeamInstructionsBlurb =>
      'Tetapkan cara pasukan anda bermain. Setiap dail mempengaruhi seluruh pasukan.';

  @override
  String tacticsSavedPreset(String name) {
    return '“$name” disimpan';
  }

  @override
  String tacticsAppliedPreset(String name) {
    return '“$name” digunakan';
  }

  @override
  String get tacticsTacticPresets => 'TAKTIK TERSIMPAN';

  @override
  String get tacticsPresetsBlurb =>
      'Simpan formasi ini sebagai gaya yang boleh diguna semula, atau gunakan yang telah anda simpan.';

  @override
  String get tacticsSaveCurrentTactic => 'Simpan taktik semasa';

  @override
  String tacticsCouldNotLoadPresets(String error) {
    return 'Taktik tersimpan tidak dapat dimuatkan.\n$error';
  }

  @override
  String get tacticsNoPresetsYet =>
      'Belum ada taktik tersimpan. Ketik “Simpan taktik semasa” untuk menyimpan susunan ini sebagai gaya yang boleh diguna semula.';

  @override
  String get tacticsNameThisTactic => 'Namakan taktik ini';

  @override
  String get tacticsNameHint => 'cth. Asakan tinggi 4-3-3';

  @override
  String get tacticsCancel => 'Batal';

  @override
  String get tacticsSave => 'Simpan';

  @override
  String get tacticsTapToAssign => 'Ketik untuk menetapkan';

  @override
  String get tacticsHoldDragSub =>
      'Tekan lama pemain gantian, kemudian seret ke atas pemain untuk memasukkannya.';

  @override
  String get hubContinue => 'Teruskan';

  @override
  String get hubBrackets => 'Carta';

  @override
  String hubCouldNotLoad(String error) {
    return 'Tidak dapat dimuatkan.\n$error';
  }

  @override
  String hubCouldNotLoadFinances(String error) {
    return 'Kewangan tidak dapat dimuatkan.\n$error';
  }

  @override
  String hubCouldNotLoadSave(String error) {
    return 'Simpanan tidak dapat dimuatkan.\n$error';
  }

  @override
  String get hubSaveNotFound => 'Simpanan tidak dijumpai.';

  @override
  String get hubUnknown => 'Tidak diketahui';

  @override
  String hubWorldChampionsYear(int year) {
    return 'JUARA DUNIA $year';
  }

  @override
  String get hubCycleComplete => 'Kitaran telah tamat.';

  @override
  String get hubYourJob => 'JAWATAN ANDA';

  @override
  String get hubStayProject => 'Kekal dan teruskan projek anda';

  @override
  String get hubChooseNextJob => 'PILIH JAWATAN SETERUSNYA';

  @override
  String get hubOffersOnTable => 'TAWARAN YANG ADA';

  @override
  String hubOfferSubtitle(String tier, int position) {
    return '$tier · dunia #$position';
  }

  @override
  String hubContinueWith(String nation) {
    return 'Teruskan bersama $nation';
  }

  @override
  String get hubYourNation => 'negara anda';

  @override
  String get hubTakeTheJob => 'Terima jawatan';

  @override
  String get hubFederationFinances => 'KEWANGAN PERSATUAN';

  @override
  String get hubBudgetIntro =>
      'Tugas pertama anda pada kitaran seterusnya ialah menetapkan bajet persatuan dan membahagikannya kepada jabatan-jabatan.';

  @override
  String get hubStarting => 'Memulakan…';

  @override
  String get hubBeginNextCycle => 'Mulakan kitaran seterusnya';

  @override
  String get hubContinueCareer => 'Teruskan kerjaya anda';

  @override
  String get hubBackToSaves => 'Kembali ke simpanan anda';

  @override
  String get hubOpeningBalance => 'Baki pembukaan';

  @override
  String get hubCentralFunding => 'Dana pusat';

  @override
  String get hubPrizeMoney => 'Wang hadiah';

  @override
  String get hubCommercialReturn => 'Pulangan komersial';

  @override
  String get hubAvailableToInvest => 'Tersedia untuk dilabur';

  @override
  String hubReputation(String label, int rep) {
    return 'Reputasi: $label ($rep)';
  }

  @override
  String get hubNationalHero => 'Wira negara';

  @override
  String get hubFinal => 'Final';

  @override
  String get hubStageRoundOf32 => 'Pusingan 32 terakhir';

  @override
  String get hubStageThirdPlace => 'Perebutan tempat ketiga';

  @override
  String get hubEventAdvanceWorld => 'Majukan dunia';

  @override
  String hubEventStartCycle(int year) {
    return 'Mulakan kitaran $year';
  }

  @override
  String hubEventWorldChampions(String nation) {
    return '$nation Juara Dunia';
  }

  @override
  String get hubEventSetBudget => 'Tetapkan bajet persatuan';

  @override
  String get hubEventSetBudgetSub =>
      'Agihkan dana kitaran ini sebelum musim bermula';

  @override
  String get hubEventNaturalization => 'Semak tawaran naturalisasi';

  @override
  String get hubEventNaturalizationSub =>
      'Seorang pemain asing mahu bertukar kesetiaan kepada anda';

  @override
  String get hubEventCampaignVerdict => 'Kempen selesai: lihat keputusan';

  @override
  String get hubEventCampaignComplete => 'Kempen tamat';

  @override
  String get hubEventIntercontinentalPlayoff => 'Play-off antara benua';

  @override
  String get hubEventWatchWcDraw => 'Tonton cabutan undian Kejohanan Dunia';

  @override
  String get hubEventWorldCupHere => 'Kejohanan Dunia telah tiba';

  @override
  String get hubEventWatchFinalsDraw => 'Tonton cabutan undian pusingan akhir';

  @override
  String get hubEventFinalsHere => 'Pusingan akhir telah tiba';

  @override
  String get hubEventPlayWcRound => 'Main pusingan Kejohanan Dunia seterusnya';

  @override
  String hubEventPlayCupMatch(String cup) {
    return 'Main perlawanan $cup seterusnya';
  }

  @override
  String get hubEventPlayNationsCupMatch =>
      'Main perlawanan Piala Negara-Negara seterusnya';

  @override
  String get hubEventWatchNationsCupDraw =>
      'Tonton cabutan undian Piala Negara-Negara';

  @override
  String get hubEventWatchHostSelection => 'Tonton pemilihan tuan rumah';

  @override
  String get hubEventWatchQualifyingDraw => 'Tonton cabutan undian kelayakan';

  @override
  String get hubEventWatchWcHostSelection =>
      'Tonton pemilihan tuan rumah Kejohanan Dunia';

  @override
  String get hubEventWatchWcQualifyingDraw =>
      'Tonton cabutan undian kelayakan Kejohanan Dunia';

  @override
  String get hubEventArrangeFriendlies => 'Atur perlawanan persahabatan';

  @override
  String hubEventFriendliesSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Anda belum mengisi $count slot perlawanan persahabatan yang terbuka',
      one: 'Anda belum mengisi slot perlawanan persahabatan yang terbuka',
    );
    return '$_temp0';
  }

  @override
  String get hubEventReshapeXi => 'Susun semula kesebelasan utama';

  @override
  String hubEventReshapeOutSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count pemain kesebelasan anda tidak tersedia (digantung atau cedera). Pilih pengganti mereka',
      one:
          '1 pemain kesebelasan anda tidak tersedia (digantung atau cedera). Pilih penggantinya',
    );
    return '$_temp0';
  }

  @override
  String hubEventReshapeShortSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Kesebelasan utama anda tidak lengkap. Isi slot-slot yang kosong',
      one: 'Kesebelasan utama anda tidak lengkap. Isi slot yang kosong',
    );
    return '$_temp0';
  }

  @override
  String hubEventPlayOpponent(String opponent) {
    return 'Main menentang $opponent';
  }

  @override
  String get hubEventContinentalFinalsFallback => 'pusingan akhir benua';

  @override
  String get hubCallUpFriendlies =>
      'Namakan skuad untuk perlawanan persahabatan';

  @override
  String get hubCallUpRequalify => 'Namakan semula skuad kelayakan';

  @override
  String get hubCallUpWorldCup => 'Namakan skuad Kejohanan Dunia';

  @override
  String get hubCallUpFinals => 'Namakan skuad untuk pusingan akhir';

  @override
  String get hubCallUpNationsCup => 'Namakan skuad Piala Negara-Negara';

  @override
  String get hubCallUpQualifying => 'Namakan skuad kelayakan';

  @override
  String get hubCallUpGeneric => 'Namakan skuad anda';

  @override
  String get hubHost => 'Tuan rumah';

  @override
  String get hubGoldenBoot => 'Kasut Emas';

  @override
  String hubGoldenBootValue(String name, int goals) {
    return '$name · $goals gol';
  }

  @override
  String get hubPens => '(pen)';

  @override
  String get hubNationalHub => 'HAB NASIONAL';

  @override
  String get hubMessages => 'Mesej';

  @override
  String get hubWorldChampions => 'JUARA DUNIA';

  @override
  String get hubViewBracket => 'Lihat carta ›';

  @override
  String get hubBoardDelighted => 'Sangat gembira';

  @override
  String get hubBoardPleased => 'Berpuas hati';

  @override
  String get hubBoardExpectingMore => 'Mengharapkan lebih';

  @override
  String get hubBoardConcerned => 'Bimbang';

  @override
  String get hubBoardJobAtRisk => 'Jawatan terancam';

  @override
  String get hubBoard => 'LEMBAGA';

  @override
  String hubBoardObjective(String label) {
    return 'Objektif lembaga: $label';
  }

  @override
  String hubObjectiveMet(String result) {
    return 'TERCAPAI · $result';
  }

  @override
  String hubObjectiveMissed(String result) {
    return 'GAGAL · $result';
  }

  @override
  String get hubNoMoreFixtures => 'Tiada lagi perlawanan pada kitaran ini.';

  @override
  String get hubVs => 'LWN';

  @override
  String hubWorldRank(int rank) {
    return '#$rank';
  }

  @override
  String get hubWorldRankLabel => 'Ranking dunia';

  @override
  String get hubSquadStatus => 'STATUS SKUAD';

  @override
  String hubPlayers(int count) {
    return '$count pemain';
  }

  @override
  String get hubAvgRating => 'Purata penarafan';

  @override
  String get hubMorale => 'Moral';

  @override
  String get hubManageTeam => 'Urus Pasukan';

  @override
  String get hubGroupsToBeDrawn =>
      'Kumpulan belum dicabut. Tonton cabutan undian untuk mendedahkannya.';

  @override
  String hubGroupName(String name) {
    return 'KUMPULAN $name';
  }

  @override
  String get hubTblTeam => 'PASUKAN';

  @override
  String get hubTblP => 'M';

  @override
  String get hubTblGd => 'BG';

  @override
  String get hubTblPts => 'MATA';

  @override
  String get homeSettings => 'Tetapan';

  @override
  String get homeLeadTheNation => 'PIMPIN NEGARA';

  @override
  String get homeYourNation => 'negara anda';

  @override
  String get homeNewGame => 'Permainan Baharu';

  @override
  String get homeAllSaves => 'Semua simpanan';

  @override
  String get homeLoadGame => 'Muat permainan';

  @override
  String get homeContinue => 'TERUSKAN';

  @override
  String homeRoadToWorldCup(String date, int year) {
    return '$date · Menuju Kejohanan Dunia $year';
  }

  @override
  String get careerManageSaves => 'Urus simpanan';

  @override
  String get careerNewGameTitle => 'PERMAINAN BAHARU';

  @override
  String careerCouldNotLoadNation(String error) {
    return 'Negara tidak dapat dimuatkan.\n$error';
  }

  @override
  String get careerNationNotFound => 'Negara tidak dijumpai.';

  @override
  String careerWorldRankNum(int rank) {
    return 'RANKING DUNIA #$rank';
  }

  @override
  String get careerManagerName => 'Nama jurulatih';

  @override
  String get careerManagerNameHint => 'cth. Alex Ferguson';

  @override
  String get careerBeginsBlurb =>
      'Kerjaya anda bermula pada September 2026, dalam perjalanan menuju Kejohanan Dunia 2030.';

  @override
  String get careerFreeCycleNote =>
      'Percuma untuk satu kitaran penuh empat tahun: kelayakan, kejohanan benua anda dan Kejohanan Dunia, pada dua simpanan. Selepas itu, satu bayaran membuka kitaran tanpa had.';

  @override
  String get careerStartCareer => 'Mulakan Kerjaya';

  @override
  String get careersTitle => 'KERJAYA';

  @override
  String get careerManagerCareer => 'Kerjaya jurulatih';

  @override
  String get careerManagerCareerSubtitle =>
      'Setiap kitaran yang anda kendalikan dan rekod keseluruhan anda';

  @override
  String get careerSummaryTitle => 'Ringkasan kerjaya';

  @override
  String get careerSummarySubtitle => 'Kabinet trofi dan rekod jurulatih anda';

  @override
  String get careerAchievements => 'Pencapaian';

  @override
  String get careerAchievementsSubtitle =>
      'Pencapaian penting, kejuaraan dan kepuasan lembaga';

  @override
  String get careerChallenges => 'Cabaran';

  @override
  String get careerChallengesSubtitle =>
      'Ujian kerjaya yang sangat sukar untuk disahut';

  @override
  String get careerTeamRecords => 'Rekod pasukan';

  @override
  String get careerTeamRecordsSubtitle =>
      'Penjaring dan penampilan terbanyak sepanjang zaman';

  @override
  String get careerMyMatches => 'Perlawanan saya';

  @override
  String get careerMyMatchesSubtitle =>
      'Setiap keputusan dan perlawanan akan datang';

  @override
  String get careerTitle => 'KERJAYA';

  @override
  String careerCouldNotLoadCareer(String error) {
    return 'Kerjaya tidak dapat dimuatkan.\n$error';
  }

  @override
  String get careerNoCareer => 'Tiada kerjaya.';

  @override
  String get careerTrophyCabinet => 'KABINET TROFI';

  @override
  String get careerTournamentHistory => 'SEJARAH KEJOHANAN';

  @override
  String get careerNoTournamentsYet => 'Belum ada kejohanan yang selesai.';

  @override
  String get careerTeamFallback => 'Pasukan';

  @override
  String careerWorldNum(int rank) {
    return 'DUNIA #$rank';
  }

  @override
  String careerPointsNum(int points) {
    return '$points MATA';
  }

  @override
  String careerSeasonNum(int season) {
    return 'MUSIM $season';
  }

  @override
  String get careerStatPlayedShort => 'M';

  @override
  String get careerStatsHeading => 'DALAM ANGKA';

  @override
  String get careerStatsWinRate => 'Kadar menang';

  @override
  String get careerStatsGoalsFor => 'Gol dijaring';

  @override
  String get careerStatsGoalsAgainst => 'Gol dibolosi';

  @override
  String get careerStatsGoalDiff => 'Beza gol';

  @override
  String get careerStatsCleanSheets => 'Tanpa bolos';

  @override
  String get careerStatsBiggestWin => 'Kemenangan terbesar';

  @override
  String get careerStatsWinStreak => 'Rentetan menang';

  @override
  String get careerStatsUnbeaten => 'Rentetan tanpa kalah';

  @override
  String get careerStatsShootouts => 'Penentuan penalti';

  @override
  String get careerStatsHatTricks => 'Hatrik';

  @override
  String get careerStatsMotms => 'Pemain terbaik perlawanan';

  @override
  String get careerStatsBestRating => 'Penarafan terbaik';

  @override
  String get careerStatWonShort => 'M';

  @override
  String get careerStatDrawnShort => 'S';

  @override
  String get careerStatLostShort => 'K';

  @override
  String get careerStatGoalsForShort => 'GJ';

  @override
  String get careerStatGoalsAgainstShort => 'GB';

  @override
  String get careerStatGoalDiffShort => 'BG';

  @override
  String get careerNoSilverware => 'Belum ada trofi. Pergi menangi satu.';

  @override
  String get careerMedalGold => 'EMAS';

  @override
  String get careerMedalSilver => 'PERAK';

  @override
  String get careerMedalBronze => 'GANGSA';

  @override
  String careerWinnersName(String name) {
    return 'Juara: $name';
  }

  @override
  String get careerSavesTitle => 'SIMPANAN';

  @override
  String careerCouldNotLoadSaves(String error) {
    return 'Simpanan tidak dapat dimuatkan.\n$error';
  }

  @override
  String careerSlotsCount(int used, int limit) {
    return 'SLOT  $used/$limit';
  }

  @override
  String get careerThisSave => 'simpanan ini';

  @override
  String get careerSlotsFull => 'Slot penuh';

  @override
  String careerSlotsUsed(int used) {
    return 'SLOT  $used';
  }

  @override
  String get careerSlotsUnlockMore => 'Buka lebih banyak simpanan';

  @override
  String get careerSlotsKeepNote =>
      'Setiap simpanan yang anda sudah ada kekal boleh dimainkan. Hanya simpanan baharu yang memerlukan pembukaan.';

  @override
  String get careerNewGame => 'Permainan Baharu';

  @override
  String get careerDeleteSaveTitle => 'Padam simpanan?';

  @override
  String careerDeleteSaveBody(String label) {
    return 'Ini akan memadam kerjaya $label anda secara kekal.';
  }

  @override
  String get careerCancel => 'Batal';

  @override
  String get careerDelete => 'Padam';

  @override
  String get careerNoSavesYet =>
      'Belum ada simpanan.\nMulakan permainan baharu untuk memimpin sebuah negara.';

  @override
  String get careerUnknownNation => 'Tidak diketahui';

  @override
  String careerPlayedMinutes(int minutes) {
    return '${minutes}m';
  }

  @override
  String careerPlayedHours(int hours, int minutes) {
    return '${hours}j ${minutes}m';
  }

  @override
  String careerLastPlayed(String when) {
    return 'Kali terakhir dimainkan $when';
  }

  @override
  String get careerJustNow => 'sebentar tadi';

  @override
  String get careerYesterday => 'semalam';

  @override
  String careerMinutesAgo(int n) {
    return '${n}m lalu';
  }

  @override
  String careerHoursAgo(int n) {
    return '${n}j lalu';
  }

  @override
  String careerDaysAgo(int n) {
    return '${n}h lalu';
  }

  @override
  String careerRoadToWorldCup(int year) {
    return 'Menuju Kejohanan Dunia $year';
  }

  @override
  String get careerManagerCareerTitle => 'KERJAYA JURULATIH';

  @override
  String careerCouldNotLoad(String error) {
    return 'Tidak dapat dimuatkan.\n$error';
  }

  @override
  String get careerCycleByCycle => 'SETIAP KITARAN';

  @override
  String careerCyclesNationsLed(int cycles, int nations) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles kitaran',
    );
    String _temp1 = intl.Intl.pluralLogic(
      nations,
      locale: localeName,
      other: '$nations negara dipimpin',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get careerStatTitles => 'Kejuaraan';

  @override
  String get careerStatPlayed => 'Main';

  @override
  String get careerStatWon => 'Menang';

  @override
  String get careerStatDrawn => 'Seri';

  @override
  String get careerStatLost => 'Kalah';

  @override
  String careerGoalsWinRate(
    int goalsFor,
    int goalsAgainst,
    String gd,
    int winRate,
  ) {
    return 'Gol $goalsFor–$goalsAgainst  ($gd)  ·  Kadar menang $winRate%';
  }

  @override
  String get careerRecordResults => 'KEPUTUSAN REKOD';

  @override
  String get careerBestWin => 'Kemenangan terbaik';

  @override
  String get careerWorstDefeat => 'Kekalahan terburuk';

  @override
  String careerVsOpponentDate(String opponent, String date) {
    return 'lwn $opponent · $date';
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
    return '${won}M ${drawn}S ${lost}K  ·  GJ $goalsFor GB $goalsAgainst ($gd)';
  }

  @override
  String get careerWorldCupLabel => 'Kejohanan Dunia';

  @override
  String get careerContinentalLabel => 'Benua';

  @override
  String get messagesTitle => 'MESEJ';

  @override
  String get messagesNoMessagesYet => 'Belum ada mesej.';

  @override
  String messagesCouldNotLoad(String error) {
    return 'Mesej tidak dapat dimuatkan.\n$error';
  }

  @override
  String get messagesDone => 'Selesai';

  @override
  String get messagesNext => 'Seterusnya';

  @override
  String get rankingWorldRanking => 'RANKING DUNIA';

  @override
  String rankingCouldNotLoad(String error) {
    return 'Ranking tidak dapat dimuatkan.\n$error';
  }

  @override
  String get rankingNoRanking => 'Tiada ranking.';

  @override
  String get rankingAll => 'SEMUA';

  @override
  String get rankingYourTeam => 'PASUKAN ANDA';

  @override
  String get rankingYourRankingOverTime => 'RANKING ANDA DARI MASA KE MASA';

  @override
  String rankingNowRank(int rank) {
    return 'kini #$rank';
  }

  @override
  String rankingBestWorst(int best, int worst) {
    return 'terbaik #$best · terburuk #$worst';
  }

  @override
  String get friendliesTitle => 'PERLAWANAN PERSAHABATAN';

  @override
  String friendliesLoadError(String error) {
    return 'Perlawanan persahabatan tidak dapat dimuatkan.\n$error';
  }

  @override
  String get friendliesContinue => 'Teruskan';

  @override
  String friendliesArrangeIntro(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count slot terbuka',
    );
    return 'Atur perlawanan pemanas badan untuk $_temp0 sebelum perlawanan kompetitif seterusnya. Ketik lawan, atau biarkan kosong.';
  }

  @override
  String get friendliesFree => 'Kosong';

  @override
  String matchGoalsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count GOL',
      one: '1 GOL',
    );
    return '$_temp0';
  }

  @override
  String get matchGoalsTitle => 'GOL';

  @override
  String get matchGoalsNone => 'Tiada gol';

  @override
  String get matchGoalPenalty => 'PEN';

  @override
  String get matchGoalSetPiece => 'BM';

  @override
  String matchGoalAssist(String name) {
    return 'bantuan $name';
  }

  @override
  String get friendliesHome => 'LAMAN SENDIRI';

  @override
  String get friendliesAway => 'TANDANG';

  @override
  String get friendliesNoneThisWindow =>
      'Tiada perlawanan persahabatan kali ini';

  @override
  String friendliesConfirmCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count perlawanan persahabatan',
    );
    return 'Sahkan $_temp0';
  }

  @override
  String get friendliesMonthJan => 'Jan';

  @override
  String get friendliesMonthFeb => 'Feb';

  @override
  String get friendliesMonthMar => 'Mac';

  @override
  String get friendliesMonthApr => 'Apr';

  @override
  String get friendliesMonthMay => 'Mei';

  @override
  String get friendliesMonthJun => 'Jun';

  @override
  String get friendliesMonthJul => 'Jul';

  @override
  String get friendliesMonthAug => 'Ogo';

  @override
  String get friendliesMonthSep => 'Sep';

  @override
  String get friendliesMonthOct => 'Okt';

  @override
  String get friendliesMonthNov => 'Nov';

  @override
  String get friendliesMonthDec => 'Dis';

  @override
  String get resultsMyMatches => 'PERLAWANAN SAYA';

  @override
  String resultsCouldNotLoad(String error) {
    return 'Keputusan tidak dapat dimuatkan.\n$error';
  }

  @override
  String get resultsNoFixtures => 'Tiada perlawanan.';

  @override
  String get resultsVs => 'lwn';

  @override
  String get resultsStageQualifier => 'KELAYAKAN';

  @override
  String get resultsStageFriendly => 'PERSAHABATAN';

  @override
  String get resultsStageGroupStage => 'PERINGKAT KUMPULAN';

  @override
  String get resultsStageSemiFinal => 'SEPARUH AKHIR';

  @override
  String get resultsStageFinal => 'FINAL';

  @override
  String get resultsStageContinentalClash => 'PERTEMBUNGAN BENUA';

  @override
  String get resultsStageFinalsGroup => 'KUMPULAN PUSINGAN AKHIR';

  @override
  String get resultsStageRoundOf32 => 'PUSINGAN 32 TERAKHIR';

  @override
  String get resultsStageRoundOf16 => 'PUSINGAN 16 TERAKHIR';

  @override
  String get resultsStageQuarterFinal => 'SUKU AKHIR';

  @override
  String get resultsStageThirdPlace => 'TEMPAT KETIGA';

  @override
  String get matchSetupWarnCaptain =>
      'Tiada kapten dinamakan. Ketik untuk memberikan lilitan kapten';

  @override
  String matchSetupWarnCaptainInjured(String name) {
    return '$name cedera dan tidak dapat mengetuai pasukan kali ini. Ketik untuk menyerahkan lilitan kapten';
  }

  @override
  String matchSetupWarnCaptainSuspended(String name) {
    return '$name digantung untuk perlawanan ini. Ketik untuk menyerahkan lilitan kapten';
  }

  @override
  String matchSetupWarnCaptainDropped(String name) {
    return '$name memegang lilitan kapten tetapi tiada dalam skuad anda. Ketik untuk menyerahkannya';
  }

  @override
  String get matchSetupWarnSetPieces =>
      'Tiada penyepak bola mati dinamakan. Ketik untuk memilih siapa yang mengambilnya';

  @override
  String get matchSetupWarnBoth =>
      'Tiada kapten dan tiada penyepak bola mati. Ketik untuk menetapkannya';

  @override
  String matchStageMatchday(int matchday) {
    return 'HP $matchday';
  }

  @override
  String get squadCaptain => 'Kapten';

  @override
  String deptEffectYouth(int points) {
    return 'Prospek akademi tiba kira-kira $points keseluruhan lebih baik';
  }

  @override
  String deptEffectCommercial(String amount) {
    return '$amount dipulangkan pada penghujung kitaran';
  }

  @override
  String deptEffectMedical(int percent) {
    return '$percent% kurang kecederaan';
  }

  @override
  String deptEffectNaturalisation(int percent) {
    return '$percent% peluang pemain asing meminta untuk bertukar';
  }

  @override
  String deptEffectBoard(int points) {
    return '+$points kesabaran lembaga sebelum jawatan anda terancam';
  }

  @override
  String get deptEffectNone => 'Tiada kesan tanpa dana';

  @override
  String get statsBestRated => 'Penarafan';

  @override
  String get statsMyCareer => 'Kerjaya';

  @override
  String get statsBestAverageRating => 'PURATA PENARAFAN TERBAIK';

  @override
  String get statsMyCareerRecord => 'REKOD ANDA';

  @override
  String get statsNoRatingsRecorded =>
      'Belum ada penarafan perlawanan direkodkan.';

  @override
  String get statsGroupRecord => 'Rekod';

  @override
  String get statsGroupRuns => 'Rentetan';

  @override
  String get statsGroupExtremes => 'Ekstrem';

  @override
  String get statsGroupSplits => 'Laman sendiri & tandang';

  @override
  String get statsGroupSquad => 'Pemain anda';

  @override
  String get statsPlayed => 'Perlawanan dimainkan';

  @override
  String get statsWinDrawLoss => 'Menang–seri–kalah';

  @override
  String get statsWinRate => 'Kadar menang';

  @override
  String get statsGoals => 'Gol dijaring:dibolosi';

  @override
  String get statsCleanSheets => 'Tanpa bolos';

  @override
  String get statsFailedToScore => 'Gagal menjaring';

  @override
  String get statsLongestWinStreak => 'Rentetan menang terpanjang';

  @override
  String get statsLongestUnbeaten => 'Rentetan tanpa kalah terpanjang';

  @override
  String get statsLongestCleanSheets => 'Rentetan tanpa bolos terpanjang';

  @override
  String get statsLongestWinless => 'Rentetan tanpa menang terpanjang';

  @override
  String get statsCurrentRun => 'Rentetan tanpa kalah semasa';

  @override
  String get statsBiggestWin => 'Kemenangan terbesar';

  @override
  String get statsHeaviestDefeat => 'Kekalahan terteruk';

  @override
  String get statsMostGoalsInAGame => 'Gol terbanyak dalam satu perlawanan';

  @override
  String get statsShootouts => 'Penentuan penalti menang–kalah';

  @override
  String get statsComebackWins => 'Menang dari belakang';

  @override
  String get statsHome => 'Laman sendiri';

  @override
  String get statsAway => 'Tandang';

  @override
  String get statsNeutral => 'Neutral';

  @override
  String get statsCompetitive => 'Kompetitif';

  @override
  String get statsFriendlies => 'Persahabatan';

  @override
  String get statsHatTricks => 'Hatrik';

  @override
  String get statsBraces => 'Dua gol';

  @override
  String get statsMotms => 'Anugerah pemain terbaik perlawanan';

  @override
  String get statsAssists => 'Bantuan';

  @override
  String get statsCards => 'Kad';

  @override
  String get statsBestRating => 'Penarafan individu terbaik';

  @override
  String statsAppsShort(int apps) {
    return '$apps penampilan';
  }

  @override
  String statsMotmShort(int motms) {
    return '$motms PTP';
  }

  @override
  String get captainArmband => 'K';

  @override
  String get captainCurrent =>
      'Kapten. Ketik untuk menanggalkan lilitan kapten';

  @override
  String get captainFitBorn => 'Pemimpin semula jadi';

  @override
  String get captainFitNatural => 'Kapten yang sesuai';

  @override
  String get captainFitCapable => 'Boleh memakainya';

  @override
  String get captainFitUnproven => 'Belum bersedia memimpin';

  @override
  String get captainNone => 'Tiada kapten dinamakan';

  @override
  String captainMoraleBoost(int morale) {
    return '+$morale moral skuad';
  }

  @override
  String get resultsCategoryWorldCupQualifying => 'Kelayakan Kejohanan Dunia';

  @override
  String get resultsCategoryFriendlies => 'Perlawanan Persahabatan';

  @override
  String get resultsCategoryContinentalClash => 'Pertembungan Benua';

  @override
  String get resultsCategoryNationsCup => 'Piala Negara-Negara';

  @override
  String get resultsCategoryContinentalCup => 'Piala Benua';

  @override
  String get resultsCategoryWorldCupQualifyingShort => 'Kel. K. Dunia';

  @override
  String get resultsCategoryContinentalQualifyingShort => 'Kel. Piala Benua';

  @override
  String get resultsCategoryContinentalQualifying => 'Kelayakan Piala Benua';

  @override
  String get resultsCategoryWorldCupFinals => 'Pusingan Akhir Kejohanan Dunia';

  @override
  String get resultsRoundResults => 'KEPUTUSAN PUSINGAN';

  @override
  String get resultsFriendlyInternationals =>
      'PERLAWANAN PERSAHABATAN ANTARABANGSA';

  @override
  String get resultsKnockout => 'Kalah mati';

  @override
  String resultsEarlierMatches(int count) {
    return 'Perlawanan terdahulu ($count)';
  }

  @override
  String resultsMatchday(int matchday) {
    return 'HARI PERLAWANAN $matchday';
  }

  @override
  String get resultsContinue => 'Teruskan';

  @override
  String resultsGroup(String name) {
    return 'KUMPULAN $name';
  }

  @override
  String get achievementsScreenTitle => 'PENCAPAIAN';

  @override
  String get achievementsChallengesTooltip => 'Cabaran';

  @override
  String get achievementsChallengesHeading => 'CABARAN';

  @override
  String get achievementsBrutalTests => 'Ujian kerjaya yang sangat sukar';

  @override
  String achievementsCouldNotLoad(String error) {
    return 'Tidak dapat dimuatkan.\n$error';
  }

  @override
  String achievementsUnlockedCount(int earned, int total) {
    return '$earned / $total dibuka';
  }

  @override
  String achievementsConqueredCount(int done, int total) {
    return '$done / $total ditakluki';
  }

  @override
  String get achievementsBoardSatisfaction => 'KEPUASAN LEMBAGA';

  @override
  String achievementsUnlockedBanner(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count PENCAPAIAN DIBUKA',
    );
    return '$_temp0';
  }

  @override
  String get achCatWins => 'Kemenangan';

  @override
  String get achCatMatches => 'Perlawanan';

  @override
  String get achCatQualifications => 'Kelayakan';

  @override
  String get achCatTitles => 'Kejuaraan';

  @override
  String get achCatMisc => 'Pelbagai';

  @override
  String get achCatMega => 'Mega';

  @override
  String get achCatGoals => 'Gol';

  @override
  String get achCatStreaks => 'Rentetan';

  @override
  String get achTierBronze => 'Gangsa';

  @override
  String get achTierSilver => 'Perak';

  @override
  String get achTierGold => 'Emas';

  @override
  String get achTierPlatinum => 'Platinum';

  @override
  String achGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Gol',
    );
    return '$_temp0';
  }

  @override
  String achGoalsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Jaringkan $count gol.',
      one: 'Jaringkan 1 gol.',
    );
    return '$_temp0';
  }

  @override
  String achCleanSheets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Tanpa Bolos',
    );
    return '$_temp0';
  }

  @override
  String achCleanSheetsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Catat $count perlawanan tanpa bolos.',
      one: 'Catat 1 perlawanan tanpa bolos.',
    );
    return '$_temp0';
  }

  @override
  String get achStreakWin5 => 'Tabiat Menang';

  @override
  String get achStreakWin5Desc => 'Menang lima perlawanan berturut-turut.';

  @override
  String get achStreakWin10 => 'Terus Melonjak';

  @override
  String get achStreakWin10Desc => 'Menang sepuluh perlawanan berturut-turut.';

  @override
  String get achStreakWin20 => 'Jentera Perkasa';

  @override
  String get achStreakWin20Desc =>
      'Menang dua puluh perlawanan berturut-turut.';

  @override
  String get achUnbeaten15 => 'Sukar Ditewaskan';

  @override
  String get achUnbeaten15Desc => 'Tanpa kalah dalam lima belas perlawanan.';

  @override
  String get achUnbeaten30 => 'Tidak Tersentuh';

  @override
  String get achUnbeaten30Desc => 'Tanpa kalah dalam tiga puluh perlawanan.';

  @override
  String get achHattrick => 'Wira Hatrik';

  @override
  String get achHattrickDesc => 'Pastikan seorang pemain menjaringkan hatrik.';

  @override
  String get achMotm10 => 'Menonjol';

  @override
  String get achMotm10Desc => 'Kumpul 10 anugerah pemain terbaik perlawanan.';

  @override
  String get achMotm50 => 'Tangkal';

  @override
  String get achMotm50Desc => 'Kumpul 50 anugerah pemain terbaik perlawanan.';

  @override
  String get achPerfect => 'Sempurna';

  @override
  String get achPerfectDesc =>
      'Pastikan seorang pemain meraih penarafan perlawanan 9.5+.';

  @override
  String get achShootout => 'Berdarah Dingin';

  @override
  String get achShootoutDesc => 'Menang lima penentuan penalti.';

  @override
  String get achMassacre => 'Pembantaian';

  @override
  String get achMassacreDesc =>
      'Menang perlawanan dengan kelebihan 7 gol atau lebih.';

  @override
  String get achAnnihilation => 'Pemusnahan';

  @override
  String get achAnnihilationDesc =>
      'Menang perlawanan dengan kelebihan 10 gol atau lebih.';

  @override
  String get chTierBronze => 'Gangsa';

  @override
  String get chTierSilver => 'Perak';

  @override
  String get chTierGold => 'Emas';

  @override
  String get chTierLegendary => 'Legenda';

  @override
  String get chFirstSteps => 'Di Bangku Jurulatih';

  @override
  String get chFirstStepsDesc => 'Kendalikan pasukan selama 5 tahun.';

  @override
  String get chUnbeaten10 => 'Terus Melonjak';

  @override
  String get chUnbeaten10Desc => 'Tanpa kalah dalam 10 perlawanan kompetitif.';

  @override
  String get chTwoNations => 'Cabaran Baharu';

  @override
  String get chTwoNationsDesc => 'Kendalikan 2 negara berbeza.';

  @override
  String get chCont1 => 'Juara Benua';

  @override
  String get chCont1Desc => 'Menangi kejohanan benua.';

  @override
  String get chNc1 => 'Juara Piala Negara-Negara';

  @override
  String get chNc1Desc => 'Menangi Piala Negara-Negara.';

  @override
  String get chWc1 => 'Juara Dunia';

  @override
  String get chWc1Desc => 'Menangi Kejohanan Dunia.';

  @override
  String get chYears25 => 'Tokoh Mapan';

  @override
  String get chYears25Desc => 'Kendalikan pasukan selama 25 tahun.';

  @override
  String get chWc3 => 'Pemenang Bersiri';

  @override
  String get chWc3Desc => 'Menangi 3 Kejohanan Dunia.';

  @override
  String get chWc5 => 'Dinasti';

  @override
  String get chWc5Desc => 'Menangi 5 Kejohanan Dunia.';

  @override
  String get chWc10 => 'Abadi';

  @override
  String get chWc10Desc => 'Menangi 10 Kejohanan Dunia.';

  @override
  String get chWc2Teams => 'Ke Mana Sahaja';

  @override
  String get chWc2TeamsDesc =>
      'Menangi Kejohanan Dunia bersama 2 negara berbeza.';

  @override
  String get chWc3Teams => 'Pengembara Dunia';

  @override
  String get chWc3TeamsDesc =>
      'Menangi Kejohanan Dunia bersama 3 negara berbeza.';

  @override
  String get chWcStreak3 => 'Hatrik Kejuaraan';

  @override
  String get chWcStreak3Desc => 'Menangi 3 Kejohanan Dunia berturut-turut.';

  @override
  String get chWcAllconf => 'Penakluk Dunia';

  @override
  String get chWcAllconfDesc =>
      'Menangi Kejohanan Dunia bersama negara dari setiap konfederasi (6).';

  @override
  String get chCont5 => 'Raja Benua';

  @override
  String get chCont5Desc => 'Menangi 5 kejohanan benua.';

  @override
  String get chContAll => 'Enam Benua';

  @override
  String get chContAllDesc => 'Menangi kejohanan benua setiap konfederasi (6).';

  @override
  String get chTreble => 'Sapu Bersih';

  @override
  String get chTrebleDesc =>
      'Menangi Kejohanan Dunia, kejuaraan benua dan Piala Negara-Negara dalam satu kerjaya.';

  @override
  String get chNations10 => 'Perantau';

  @override
  String get chNations10Desc => 'Kendalikan 10 negara berbeza.';

  @override
  String get chYears100 => 'Satu Abad';

  @override
  String get chYears100Desc => 'Kendalikan pasukan selama 100 tahun.';

  @override
  String get chYears500 => 'Setengah Alaf';

  @override
  String get chYears500Desc => 'Kendalikan pasukan selama 500 tahun.';

  @override
  String get chYears1000 => 'Kekal Abadi';

  @override
  String get chYears1000Desc => 'Kendalikan pasukan selama 1000 tahun.';

  @override
  String get chGrandmaster => 'Maha Guru';

  @override
  String get chGrandmasterDesc =>
      'Menangi 3 Kejohanan Dunia DAN 5 kejohanan benua.';

  @override
  String get chUndefeated => 'Tidak Tersentuh';

  @override
  String get chUndefeatedDesc =>
      'Menangi Kejohanan Dunia tanpa tewas walau satu perlawanan.';

  @override
  String get chPerfectQual => 'Laluan Sempurna';

  @override
  String get chPerfectQualDesc =>
      'Menangi setiap perlawanan dalam satu kempen kelayakan Kejohanan Dunia.';

  @override
  String get chMinnow => 'Keajaiban Pasukan Kerdil';

  @override
  String get chMinnowDesc =>
      'Menangi Kejohanan Dunia bersama negara di luar 32 teratas ranking dunia.';

  @override
  String get chGrandTour => 'Laman Sendiri & Tandang';

  @override
  String get chGrandTourDesc =>
      'Menangi Kejohanan Dunia sebagai tuan rumah dan menangi satu lagi di luar negara.';

  @override
  String get chUnbeaten25 => 'Tembok Kebal';

  @override
  String get chUnbeaten25Desc => 'Tanpa kalah dalam 25 perlawanan kompetitif.';

  @override
  String get chGoals10k => 'Mesin Gol';

  @override
  String get chGoals10kDesc => 'Jaringkan 10,000 gol sepanjang kerjaya.';

  @override
  String get chCleanSheets500 => 'Kubu Kuat';

  @override
  String get chCleanSheets500Desc =>
      'Catat 500 perlawanan tanpa bolos sepanjang kerjaya.';

  @override
  String get chHatTricks25 => 'Tabiat Hatrik';

  @override
  String get chHatTricks25Desc =>
      'Pastikan pemain anda menjaringkan 25 hatrik.';

  @override
  String get chWinStreak25 => 'Tanpa Henti';

  @override
  String get chWinStreak25Desc => 'Menang 25 perlawanan berturut-turut.';

  @override
  String get chCont10 => 'Dinasti Benua';

  @override
  String get chCont10Desc => 'Menangi 10 kejohanan benua.';

  @override
  String get chPcWc => 'Juara Bersiri';

  @override
  String chPcWcDesc(int count) {
    return 'Menangi $count Kejohanan Dunia dalam simpanan ini.';
  }

  @override
  String get chPcMajors => 'Pengumpul Trofi';

  @override
  String chPcMajorsDesc(int count) {
    return 'Menangi $count trofi utama (Kejohanan Dunia, benua atau Piala Negara-Negara).';
  }

  @override
  String get chPcUnbeaten => 'Tembok Besi';

  @override
  String chPcUnbeatenDesc(int count) {
    return 'Tanpa kalah dalam $count perlawanan kompetitif.';
  }

  @override
  String get chPcNations => 'Jurulatih Kembara';

  @override
  String chPcNationsDesc(int count) {
    return 'Kendalikan $count negara berbeza.';
  }

  @override
  String get chPcYears => 'Perjalanan Panjang';

  @override
  String chPcYearsDesc(int count) {
    return 'Kendalikan pasukan selama $count tahun.';
  }

  @override
  String achWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Kemenangan',
      one: '1 Kemenangan',
    );
    return '$_temp0';
  }

  @override
  String achWinsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Menang $count perlawanan.',
      one: 'Menang 1 perlawanan.',
    );
    return '$_temp0';
  }

  @override
  String achMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Perlawanan',
    );
    return '$_temp0';
  }

  @override
  String achMatchesDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Main $count perlawanan.',
      one: 'Main 1 perlawanan.',
    );
    return '$_temp0';
  }

  @override
  String get achQualWc => 'Layak ke Kejohanan Dunia';

  @override
  String get achQualWcDesc => 'Layak ke Kejohanan Dunia.';

  @override
  String get achQualCont => 'Layak ke Kejohanan Benua';

  @override
  String get achQualContDesc => 'Layak ke kejohanan benua anda.';

  @override
  String get achTitleWc => 'Juara Dunia';

  @override
  String get achTitleWcDesc => 'Menangi Kejohanan Dunia.';

  @override
  String get achTitleEuro => 'Juara Eropah';

  @override
  String get achTitleEuroDesc => 'Menangi Kejohanan Eropah.';

  @override
  String get achTitleCopa => 'Juara Amerika Selatan';

  @override
  String get achTitleCopaDesc => 'Menangi Piala Amerika Selatan.';

  @override
  String get achTitleAfcon => 'Juara Afrika';

  @override
  String get achTitleAfconDesc => 'Menangi Kejohanan Afrika.';

  @override
  String get achTitleAsia => 'Juara Asia';

  @override
  String get achTitleAsiaDesc => 'Menangi Kejohanan Asia.';

  @override
  String get achTitleConcacaf => 'Juara Amerika Utara';

  @override
  String get achTitleConcacafDesc => 'Menangi Piala Amerika Utara.';

  @override
  String get achTitleOfc => 'Juara Oceania';

  @override
  String get achTitleOfcDesc => 'Menangi Piala Oceania.';

  @override
  String get achTitleNations => 'Juara Piala Negara-Negara';

  @override
  String get achTitleNationsDesc => 'Menangi Piala Negara-Negara.';

  @override
  String get achTitleClash => 'Juara Pertembungan Benua';

  @override
  String get achTitleClashDesc => 'Menangi Pertembungan Benua.';

  @override
  String get achMarksman => 'Penembak Tepat Kejohanan Dunia';

  @override
  String get achMarksmanDesc =>
      'Pastikan pemain skuad menjaringkan 6+ gol di pusingan akhir Kejohanan Dunia.';

  @override
  String get achSweep => 'Sapu Bersih';

  @override
  String get achSweepDesc =>
      'Menjuarai Kejohanan Dunia dan kejuaraan benua anda dalam satu kerjaya.';

  @override
  String get achAllstar => 'Bintang Kejohanan';

  @override
  String get achAllstarDesc =>
      'Pastikan seorang pemain dinamakan dalam Pasukan Terbaik Kejohanan Dunia.';

  @override
  String get achGoldenboot => 'Kasut Emas';

  @override
  String get achGoldenbootDesc =>
      'Pastikan negara anda menjadi penjaring terbanyak kejohanan.';

  @override
  String get achDemolition => 'Penghancuran';

  @override
  String get achDemolitionDesc =>
      'Menang perlawanan dengan kelebihan 5 gol atau lebih.';

  @override
  String get achievementsNice => 'Hebat!';

  @override
  String get achievementsHardestTests =>
      'Ujian paling sukar untuk seorang jurulatih, merentasi seluruh kerjaya dan banyak negara.';

  @override
  String get achievementsThisSave => 'SIMPANAN INI';

  @override
  String get achievementsBrutalBadge => 'KEJAM';

  @override
  String get paywallGoPro => 'JADI TANPA HAD';

  @override
  String get paywallOneTimeUnlock =>
      'Pembukaan sekali sahaja. Tiada langganan.';

  @override
  String get paywallBenefitCarryOn =>
      'Simpanan ini bersambung tepat di tempat ia terhenti, dengan setiap penampilan, rekod dan persaingan kekal utuh.';

  @override
  String get paywallBenefitNoAds =>
      'Tiada iklan, tiada transaksi mikro, tiada langganan. Satu bayaran, dan setiap kemas kini akan datang milik anda.';

  @override
  String get paywallBenefitSaves =>
      'Seberapa banyak simpanan yang anda mahu. Kendalikan pasukan pilihan dan pasukan kerdil serentak, dan lihat betapa berbezanya permainan yang sama.';

  @override
  String get paywallBenefitEndless =>
      'Setiap kitaran mulai sekarang. Pilih pemain berusia tujuh belas tahun hari ini dan ketahui pada 2034 sama ada anda tepat menilainya.';

  @override
  String get paywallUnlocked => 'Tanpa Had telah dibuka. Selamat bermain!';

  @override
  String get paywallContactingStore => 'Menghubungi kedai…';

  @override
  String paywallUnlockProPriced(String price) {
    return 'Buka Tanpa Had · $price';
  }

  @override
  String get paywallRestorePurchases => 'Pulihkan pembelian';

  @override
  String get paywallStoreUnavailable => 'Kedai tidak tersedia';

  @override
  String get paywallStoreUnavailableNote =>
      'Harga tidak dapat dimuatkan. Semak sambungan anda dan cuba lagi.';

  @override
  String get paywallTryAgain => 'Cuba lagi';

  @override
  String get gateTitle => 'KITARAN PERTAMA ANDA TELAH TAMAT';

  @override
  String get gateLead =>
      'Empat tahun ialah satu kitaran. Itu tidak cukup lama untuk mengetahui sama ada anda betul.';

  @override
  String get gatePriceLead => 'Satu bayaran, selama-lamanya';

  @override
  String get gateBuy => 'BELI DAN TERUSKAN';

  @override
  String get gateExit => 'KELUAR';

  @override
  String get gateSaveTitle => 'SIMPANAN INI MEMERLUKAN PRO';

  @override
  String get gateSaveLead =>
      'Simpanan yang melepasi kitaran percuma, dan kempen Pro, diteruskan dengan Pro. Tiada apa yang hilang: simpanan ini menunggu tepat seperti yang anda tinggalkan.';

  @override
  String get careerSaveLockedNote =>
      'Pro diperlukan untuk meneruskan simpanan ini';

  @override
  String get federationNaturalisation => 'NATURALISASI';

  @override
  String federationNaturalisedTitle(String name) {
    return '$name dinaturalisasikan';
  }

  @override
  String federationNaturalisedBody(String name, String nation) {
    return '$name telah melengkapkan pertukaran dan kini layak mewakili $nation. Panggil dia melalui pemilihan skuad anda.';
  }

  @override
  String federationCouldNotLoadOffer(String error) {
    return 'Tawaran tidak dapat dimuatkan.\n$error';
  }

  @override
  String get federationContinue => 'Teruskan';

  @override
  String get federationOfferToSwitchAllegiance =>
      'TAWARAN UNTUK BERTUKAR KESETIAAN';

  @override
  String federationPlayerMeta(String position, int age, String nation) {
    return '$position · umur $age · dari $nation';
  }

  @override
  String federationNaturalisationBlurb(
    String name,
    String playerNation,
    String sourceNation,
  ) {
    return '$name mempunyai hubungan dengan $playerNation dan sanggup dinaturalisasikan. Terima dan dia boleh dipilih; tolak dan dia kekal bersama $sourceNation.';
  }

  @override
  String get federationDecline => 'Tolak';

  @override
  String get federationNaturalise => 'Naturalisasikan';

  @override
  String get federationBudgetLater => 'Putuskan kemudian';

  @override
  String get federationSetYourBudget => 'TETAPKAN BAJET ANDA';

  @override
  String federationCouldNotLoadFinances(String error) {
    return 'Kewangan tidak dapat dimuatkan.\n$error';
  }

  @override
  String get federationSaveNotFound => 'Simpanan tidak dijumpai.';

  @override
  String get federationBudgetHeading => 'BAJET PERSATUAN';

  @override
  String federationDistributeBudget(String amount) {
    return 'Agihkan $amount kepada jabatan-jabatan untuk memulakan kitaran. Belanjakan dengan bijak.';
  }

  @override
  String federationOverBudget(String amount) {
    return '$amount melebihi apa yang persatuan ada. Kurangkan sedikit';
  }

  @override
  String get federationAllocateFullBudget =>
      'Agihkan keseluruhan bajet untuk memulakan kitaran.';

  @override
  String get federationConfirming => 'Mengesahkan…';

  @override
  String get federationConfirmBudget => 'Sahkan bajet';

  @override
  String get federationFinances => 'KEWANGAN';

  @override
  String get federationInvestmentUpdated => 'Pelaburan dikemas kini.';

  @override
  String get federationDevelopment => 'PEMBANGUNAN PERSATUAN';

  @override
  String get federationProjectedAtSeasonEnd => 'UNJURAN PADA AKHIR MUSIM';

  @override
  String get federationCentralFunding => 'Dana pusat';

  @override
  String get federationPrizeMoneySoFar => 'Wang hadiah setakat ini';

  @override
  String get federationCommercialReturn => 'Pulangan komersial';

  @override
  String get federationThisSeasonLocked => 'MUSIM INI (DIKUNCI)';

  @override
  String get federationInvestForNextSeason => 'LABUR UNTUK MUSIM DEPAN';

  @override
  String get federationNextSeasonImpact => 'KESAN MUSIM DEPAN';

  @override
  String get federationSaving => 'Menyimpan…';

  @override
  String get federationConfirmInvestment => 'Sahkan pelaburan';

  @override
  String get federationBalance => 'BAKI PERSATUAN';

  @override
  String get federationCommittedToStaff => 'Diperuntukkan untuk kakitangan';

  @override
  String get federationFreeToSpend => 'Bebas dibelanjakan';

  @override
  String get federationWagesNote =>
      'Gaji ditolak daripada baki pada akhir kitaran, jadi jumlah ini sudah diperuntukkan.';

  @override
  String get federationInvestAtCeremony =>
      'Labur untuk musim depan pada majlis akhir kitaran.';

  @override
  String federationLevelBadge(int level) {
    return 'T$level';
  }

  @override
  String get federationAcademyProspects => 'Prospek akademi';

  @override
  String federationPlusOverall(int value) {
    return '+$value keseluruhan';
  }

  @override
  String get federationInjuryRisk => 'Risiko kecederaan';

  @override
  String get federationNaturalisationChance => 'Peluang naturalisasi';

  @override
  String get federationBoardPatience => 'Kesabaran lembaga';

  @override
  String get federationUnallocated => 'BELUM DIAGIHKAN';

  @override
  String get nationsVitrineTitle => 'GALERI NEGARA';

  @override
  String nationsCouldNotLoad(String error) {
    return 'Negara tidak dapat dimuatkan.\n$error';
  }

  @override
  String get nationsNoNation => 'Tiada negara.';

  @override
  String get nationsHonours => 'PENGHORMATAN';

  @override
  String get nationsRankingHistory => 'SEJARAH RANKING DUNIA';

  @override
  String get nationsTopScorers => 'PENJARING TERBANYAK SEPANJANG ZAMAN';

  @override
  String get nationsTitles => 'KEJUARAAN';

  @override
  String get nationsYourTeam => 'PASUKAN ANDA';

  @override
  String get nationsWorld => 'DUNIA';

  @override
  String get nationsWorldCup => 'Kejohanan Dunia';

  @override
  String get nationsContinental => 'Benua';

  @override
  String nationsAppearances(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count penampilan',
      one: '1 penampilan',
    );
    return '$_temp0';
  }

  @override
  String get nationsNotEnoughHistory =>
      'Sejarah belum mencukupi. Semak semula selepas satu atau dua kitaran.';

  @override
  String nationsBestRank(int rank) {
    return 'Terbaik: #$rank';
  }

  @override
  String nationsNowRank(int rank) {
    return 'Kini: #$rank';
  }

  @override
  String get nationsNoGoals => 'Belum ada gol direkodkan.';

  @override
  String get nationsGoalsAbbrev => 'gol';

  @override
  String get nationsHosts => 'TUAN RUMAH';

  @override
  String get nationsSelectTitle => 'PILIH PASUKAN KEBANGSAAN';

  @override
  String nationsCouldNotLoadNations(String error) {
    return 'Senarai negara tidak dapat dimuatkan.\n$error';
  }

  @override
  String get nationsNoMatch => 'Tiada negara yang sepadan.';

  @override
  String get nationsSelectHeading => 'Pilih Pasukan Kebangsaan';

  @override
  String get nationsSearchHint => 'Cari negara…';

  @override
  String get nationsRank => 'RANKING ';

  @override
  String get nationsPremium => 'PREMIUM';

  @override
  String get nationsSelect => 'PILIH';

  @override
  String get statsTeamRecords => 'REKOD PASUKAN';

  @override
  String get statsRecordBook => 'Buku rekod';

  @override
  String statsCouldNotLoadStats(String error) {
    return 'Statistik tidak dapat dimuatkan.\n$error';
  }

  @override
  String get statsNoData => 'Tiada data.';

  @override
  String get statsTopScorers => 'PENJARING TERBANYAK';

  @override
  String get statsMostGamesPlayed => 'PALING BANYAK PERLAWANAN';

  @override
  String get statsTeam => 'Pasukan';

  @override
  String get statsTopScorersShort => 'Penjaring';

  @override
  String get statsMostGames => 'Perlawanan';

  @override
  String get statsNoGoalsRecorded => 'Belum ada gol direkodkan.';

  @override
  String get statsUnknown => 'Tidak diketahui';

  @override
  String get playerTitle => 'PEMAIN';

  @override
  String playerLoadError(String error) {
    return 'Pemain tidak dapat dimuatkan.\n$error';
  }

  @override
  String get playerNotFound => 'Pemain tidak dijumpai.';

  @override
  String get playerClub => 'KELAB';

  @override
  String get playerClubRole => 'Di kelabnya';

  @override
  String get playerPosition => 'Posisi';

  @override
  String get playerPotential => 'Potensi';

  @override
  String get playerAge => 'Umur';

  @override
  String get playerValue => 'Nilai';

  @override
  String get clubFirstChoice => 'Bermain setiap minggu';

  @override
  String get clubRotation => 'Keluar masuk';

  @override
  String get clubFringe => 'Jarang bermain';

  @override
  String get clubFrozenOut => 'Tidak bermain';

  @override
  String clubAtClub(String club, String standing) {
    return '$club: $standing';
  }

  @override
  String yWinUpset0(String opponent, String score) {
    return 'Saya sudah menonton bola sepak selama tiga puluh tahun dan saya tidak menjangkakannya. $opponent tumpas $score.';
  }

  @override
  String yWinUpset1(String opponent, String score) {
    return 'Tiada siapa memberi mereka peluang menentang $opponent. $score. Langsung tiada siapa.';
  }

  @override
  String yWinUpset2(String opponent, String score) {
    return '$score menentang $opponent. Pergi kejutkan jiran-jiran.';
  }

  @override
  String yWinUpset3(String opponent, String score) {
    return 'Inilah jenis malam yang akan diceritakan kepada cucu-cicit. $opponent $score.';
  }

  @override
  String yWinUpset4(String opponent, String score) {
    return '$score menentang $opponent. Walau bagaimana ia berlaku, ia sudah berlaku.';
  }

  @override
  String yWinUpset5(String opponent, String score) {
    return 'Di atas kertas, perlawanan ini sudah selesai sebelum bermula. $opponent $score membuktikan sebaliknya.';
  }

  @override
  String yWinUpset6(String opponent, String score) {
    return 'Tewaskan $opponent $score. Setahun lagi tiada siapa akan percaya keputusan itu.';
  }

  @override
  String yWinUpset7(String opponent, String score) {
    return '$opponent $score. Nikmatilah, kemudian lihat jadual perlawanan.';
  }

  @override
  String yWinUpset8(String opponent, String score) {
    return '$score menentang $opponent, dan kita bergantung pada nasib selama lapan puluh daripada sembilan puluh minit.';
  }

  @override
  String yWinUpset9(String opponent, String score) {
    return 'Satu malam menentang $opponent tidak memadam setahun. $score.';
  }

  @override
  String yWinUpset10(String opponent, String score) {
    return 'Tewaskan $opponent $score dan sekarang kita akan diberitahu kita sudah berubah. Belum lagi.';
  }

  @override
  String yWinUpset11(String opponent, String score) {
    return '$opponent $score. Hebat. Tanya saya lagi bila ia benar-benar penting.';
  }

  @override
  String yWinRoutine0(String opponent, String score) {
    return 'Tewaskan $opponent $score. Tepat seperti sepatutnya, dan ada kepuasan dalam hal itu.';
  }

  @override
  String yWinRoutine1(String opponent, String score) {
    return '$score ke atas $opponent. Kejam, dan kejam itu satu pujian.';
  }

  @override
  String yWinRoutine2(String opponent, String score) {
    return '$opponent $score. Tiada kecoh, tiada cemas, tiada rungutan.';
  }

  @override
  String yWinRoutine3(String opponent, String score) {
    return '$score yang kemas menentang $opponent. Beginilah rupa pasukan yang bagus pada hari yang tenang.';
  }

  @override
  String yWinRoutine4(String opponent, String score) {
    return '$score menentang $opponent. Tugas selesai, tiada apa yang dipelajari.';
  }

  @override
  String yWinRoutine5(String opponent, String score) {
    return 'Tewaskan $opponent $score. Kita sepatutnya menang, dan kita menang.';
  }

  @override
  String yWinRoutine6(String opponent, String score) {
    return '$score yang profesional ke atas $opponent. Seterusnya.';
  }

  @override
  String yWinRoutine7(String opponent, String score) {
    return '$opponent ditundukkan $score. Simpan dan teruskan.';
  }

  @override
  String yWinRoutine8(String opponent, String score) {
    return '$score menentang $opponent dan kita disuruh bertepuk tangan. Kerana menewaskan mereka.';
  }

  @override
  String yWinRoutine9(String opponent, String score) {
    return 'Syabas kepada semua yang terlibat dalam $score ke atas $opponent, barangkali.';
  }

  @override
  String yWinRoutine10(String opponent, String score) {
    return '$opponent $score. Menewaskan pasukan seperti itu ialah standard minimum, bukan pencapaian.';
  }

  @override
  String yWinRoutine11(String opponent, String score) {
    return 'Kita tewaskan $opponent $score dan nampak bersusah payah melakukannya.';
  }

  @override
  String yWinTight0(String opponent, String score) {
    return '$score menentang $opponent dan setiap minitnya diperoleh dengan susah payah.';
  }

  @override
  String yWinTight1(String opponent, String score) {
    return 'Itu memerlukan semangat juang. $opponent $score.';
  }

  @override
  String yWinTight2(String opponent, String score) {
    return 'Tewaskan $opponent $score dengan cara yang sukar, iaitu cara yang kekal lama.';
  }

  @override
  String yWinTight3(String opponent, String score) {
    return '$score menentang $opponent. Pasukan yang memenangi perlawanan begini ialah pasukan yang masih bertahan pada bulan Jun.';
  }

  @override
  String yWinTight4(String opponent, String score) {
    return 'Mendebarkan, hodoh, dan menang. $opponent $score.';
  }

  @override
  String yWinTight5(String opponent, String score) {
    return 'Tewaskan $opponent $score. Ambil tiga mata dan jangan tonton semula.';
  }

  @override
  String yWinTight6(String opponent, String score) {
    return '$score. $opponent memaksa kita berusaha untuk setiap inci.';
  }

  @override
  String yWinTight7(String opponent, String score) {
    return '$opponent $score. Tidak cantik. Nilainya tetap sama.';
  }

  @override
  String yWinTight8(String opponent, String score) {
    return '$score menentang $opponent dan kita menjadikannya sepuluh kali lebih sukar daripada sepatutnya.';
  }

  @override
  String yWinTight9(String opponent, String score) {
    return 'Kita tidak sepatutnya bertahan bermati-matian menentang $opponent. $score.';
  }

  @override
  String yWinTight10(String opponent, String score) {
    return '$opponent $score. Menang, tetapi tiada perkara baik yang kita pelajari tentang diri sendiri.';
  }

  @override
  String yWinTight11(String opponent, String score) {
    return '$score yang terlalu memihak kepada kita menentang $opponent.';
  }

  @override
  String yDrew0(String opponent, String score) {
    return 'Satu mata menentang $opponent, $score. Terima dan teruskan.';
  }

  @override
  String yDrew1(String opponent, String score) {
    return '$score dengan $opponent. Ada petang yang lebih teruk daripada ini.';
  }

  @override
  String yDrew2(String opponent, String score) {
    return 'Mengikat $opponent $score. Tidak semuanya perlu menjadi cerita.';
  }

  @override
  String yDrew3(String opponent, String score) {
    return '$opponent $score. Satu mata tetap satu mata dan kedudukan liga tidak bertanya bagaimana.';
  }

  @override
  String yDrew4(String opponent, String score) {
    return '$score dengan $opponent. Dua mata hilang atau satu mata diraih. Pilih mood anda.';
  }

  @override
  String yDrew5(String opponent, String score) {
    return 'Seri menentang $opponent, $score. Tiada siapa gembira, tiada siapa berang.';
  }

  @override
  String yDrew6(String opponent, String score) {
    return '$opponent $score. Sembilan puluh minit paling mudah dilupakan tahun ini.';
  }

  @override
  String yDrew7(String opponent, String score) {
    return 'Berkongsi mata dengan $opponent, $score. Kita teruskan.';
  }

  @override
  String yDrew8(String opponent, String score) {
    return '$score menentang $opponent. Keputusan seri begini membunuh kempen secara senyap.';
  }

  @override
  String yDrew9(String opponent, String score) {
    return 'Dua mata dibuang menentang $opponent. $score. Tiada nama lain untuknya.';
  }

  @override
  String yDrew10(String opponent, String score) {
    return '$opponent $score. Kita ada sembilan puluh minit dan tidak tahu apa nak buat dengannya.';
  }

  @override
  String yDrew11(String opponent, String score) {
    return '$score dengan $opponent yang tiada siapa akan ingat dan semua orang akan menanggungnya.';
  }

  @override
  String yLost0(String opponent, String score) {
    return 'Tewas $score kepada $opponent. Ia berlaku.';
  }

  @override
  String yLost1(String opponent, String score) {
    return '$opponent $score. Tiada siapa perlu dipersalahkan. Teruskan ke perlawanan seterusnya.';
  }

  @override
  String yLost2(String opponent, String score) {
    return 'Tewas $score kepada $opponent walaupun memberikan segalanya. Ada hari ia tidak mencukupi.';
  }

  @override
  String yLost3(String opponent, String score) {
    return '$score kepada $opponent. Angkat kepala. Pasukan ini masih ada banyak lagi.';
  }

  @override
  String yLost4(String opponent, String score) {
    return '$opponent $score. Kita kalah kelas dan tiada pertikaian.';
  }

  @override
  String yLost5(String opponent, String score) {
    return 'Tewas $score kepada $opponent. Bangkit semula.';
  }

  @override
  String yLost6(String opponent, String score) {
    return '$score kepada $opponent. Bukan memalukan, tetapi tidak cukup bagus.';
  }

  @override
  String yLost7(String opponent, String score) {
    return 'Tewas $score kepada $opponent. Belajar sesuatu daripadanya atau ia sia-sia.';
  }

  @override
  String yLost8(String opponent, String score) {
    return '$score kepada $opponent dan kita langsung tidak mengancam mereka.';
  }

  @override
  String yLost9(String opponent, String score) {
    return 'Tewas kepada $opponent, $score. Masalah sama, bulan sama, alasan sama akan menyusul.';
  }

  @override
  String yLost10(String opponent, String score) {
    return '$opponent $score. Bilakah ini tidak lagi boleh dipanggil nasib malang?';
  }

  @override
  String yLost11(String opponent, String score) {
    return 'Tewas $score kepada $opponent. Keputusan seperti itu sepatutnya ada harga yang perlu dibayar seseorang.';
  }

  @override
  String yLostBadly0(String opponent, String score) {
    return '$score kepada $opponent. Satu malam buruk. Nilai pasukan ini berdasarkan kempen, bukan ini.';
  }

  @override
  String yLostBadly1(String opponent, String score) {
    return 'Tiada siapa lebih tidak mahu $score menentang $opponent itu daripada para pemain sendiri.';
  }

  @override
  String yLostBadly2(String opponent, String score) {
    return '$opponent $score. Hodoh, dan bukan diri sebenar pasukan ini.';
  }

  @override
  String yLostBadly3(String opponent, String score) {
    return '$score yang perlu dilupakan menentang $opponent. Mereka akan bangkit lain kali.';
  }

  @override
  String yLostBadly4(String opponent, String score) {
    return '$score. Kepada $opponent. Saya kehilangan kata-kata dan saya dibayar untuk berkata-kata.';
  }

  @override
  String yLostBadly5(String opponent, String score) {
    return '$opponent $score. Seseorang perlu bertanggungjawab atas itu.';
  }

  @override
  String yLostBadly6(String opponent, String score) {
    return 'Saya mahu $score menentang $opponent dipadam daripada rekod dan ingatan.';
  }

  @override
  String yLostBadly7(String opponent, String score) {
    return 'Tewas $score kepada $opponent. Tiada cara untuk memutar belit keputusan seperti itu.';
  }

  @override
  String yLostBadly8(String opponent, String score) {
    return 'Itu bukan kekalahan kepada $opponent, itu penyerahan kalah. $score.';
  }

  @override
  String yLostBadly9(String opponent, String score) {
    return '$score. Menentang $opponent. Orang membayar untuk menonton itu.';
  }

  @override
  String yLostBadly10(String opponent, String score) {
    return '$opponent $score. Jika itu tidak mengubah apa-apa, tiada apa yang akan berubah.';
  }

  @override
  String yLostBadly11(String opponent, String score) {
    return 'Saya pernah melihat pasukan ini dimalukan, tetapi $score oleh $opponent ialah tahap terendah baharu.';
  }

  @override
  String yWinUpset12(String opponent, String score) {
    return '$opponent ditewaskan $score. Catat tarikhnya, orang akan tanya di mana anda ketika itu.';
  }

  @override
  String yWinUpset13(String opponent, String score) {
    return 'Di luar bilik persalinan tiada siapa percaya. $score menentang $opponent. Bangga pun tidak cukup.';
  }

  @override
  String yWinUpset14(String opponent, String score) {
    return '$score menentang $opponent! Semua berlari sehingga tiada tenaga lagi.';
  }

  @override
  String yWinUpset15(String opponent, String score) {
    return 'Penumbang gergasi. $opponent, $score. Inilah sebabnya kita sentiasa datang.';
  }

  @override
  String yWinUpset16(String opponent, String score) {
    return '$score menentang $opponent. Semua ramalan baru sahaja terbang keluar tingkap.';
  }

  @override
  String yWinUpset17(String opponent, String score) {
    return 'Pilihan utama: $opponent. Keputusan akhir: $score untuk kita.';
  }

  @override
  String yWinUpset18(String opponent, String score) {
    return 'Antara kejutan tahun ini: $score menentang $opponent.';
  }

  @override
  String yWinUpset19(String opponent, String score) {
    return '$opponent $score. Tiada siapa meramalkannya dan tiada siapa dapat menjelaskannya.';
  }

  @override
  String yWinUpset20(String opponent, String score) {
    return '$score menentang $opponent. Indah. Sekarang semua orang akan lupa betapa teruknya baki tahun ini.';
  }

  @override
  String yWinUpset21(String opponent, String score) {
    return '$score menentang $opponent dan gerabak sudah penuh. Saya sudah ada di sini ketika ia kosong.';
  }

  @override
  String yWinUpset22(String opponent, String score) {
    return '$opponent $score. Hebat, dan mereka tetap akan cari cara untuk mensia-siakannya.';
  }

  @override
  String yWinUpset23(String opponent, String score) {
    return 'Malam besar menentang $opponent, $score. Seekor layang-layang tidak membawa musim panas.';
  }

  @override
  String yLostBadly12(String opponent, String score) {
    return '$score kepada $opponent. Sakit kerana kita ambil peduli. Tetap sokong mereka.';
  }

  @override
  String yLostBadly13(String opponent, String score) {
    return 'Malam untuk dilupakan menentang $opponent, $score. Pemain yang paling terluka.';
  }

  @override
  String yLostBadly14(String opponent, String score) {
    return '$opponent $score. Angkat kepala. Skuad dinilai melalui cara mereka menjawab ini.';
  }

  @override
  String yLostBadly15(String opponent, String score) {
    return '$score menentang $opponent. Teruk, ya. Kiamat, bukan.';
  }

  @override
  String yLostBadly16(String opponent, String score) {
    return '$score kepada $opponent. Keputusan yang akan disebut bertahun-tahun, atas sebab yang salah.';
  }

  @override
  String yLostBadly17(String opponent, String score) {
    return '$opponent menang $score. Selepas ini, jangan ada yang terkejut lain kali.';
  }

  @override
  String yLostBadly18(String opponent, String score) {
    return 'Antara malam paling teruk dalam tempoh lama: $score menentang $opponent.';
  }

  @override
  String yLostBadly19(String opponent, String score) {
    return '$opponent $score. Akan ada soalan, dan memang patut ada.';
  }

  @override
  String yLostBadly20(String opponent, String score) {
    return '$score kepada $opponent. Memalukan pun masih terlalu lembut.';
  }

  @override
  String yLostBadly21(String opponent, String score) {
    return 'Tewas $score kepada $opponent. Orang terakhir keluar, tolong tutup lampu.';
  }

  @override
  String yLostBadly22(String opponent, String score) {
    return '$opponent $score. Saya sudah tidak terkejut, dan itu yang menakutkan.';
  }

  @override
  String yLostBadly23(String opponent, String score) {
    return '$score. $opponent. Seseorang di atas patut kemas kini resumenya malam ini.';
  }

  @override
  String yWinRout0(String opponent, String score) {
    return '$score menentang $opponent! Bola sepak begini buat seluruh negara tersenyum.';
  }

  @override
  String yWinRout1(String opponent, String score) {
    return '$opponent dibelasah $score. Persembahan yang hebat.';
  }

  @override
  String yWinRout2(String opponent, String score) {
    return '$score. Menentang $opponent. Malam ini semuanya menjadi.';
  }

  @override
  String yWinRout3(String opponent, String score) {
    return 'Kemusnahan $score ke atas $opponent. Simpan sorotan, nanti anda mahu tonton lagi.';
  }

  @override
  String yWinRout4(String opponent, String score) {
    return '$opponent $score. Itulah skuad yang menikmati bola sepaknya.';
  }

  @override
  String yWinRout5(String opponent, String score) {
    return '$score menentang $opponent, dan boleh jadi lebih. Cemerlang.';
  }

  @override
  String yWinRout6(String opponent, String score) {
    return '$score menentang $opponent. Keputusan yang buat orang pandang dua kali.';
  }

  @override
  String yWinRout7(String opponent, String score) {
    return '$opponent ditewaskan $score. Tiada perlawanan lagi selepas setengah jam pertama.';
  }

  @override
  String yWinRout8(String opponent, String score) {
    return 'Keputusan akhir: $score menentang $opponent. Jelas kemenangan terbesar dalam tempoh lama.';
  }

  @override
  String yWinRout9(String opponent, String score) {
    return '$opponent $score. Satu pasukan datang untuk bermain, satu lagi tidak turun dari bas pun.';
  }

  @override
  String yWinRout10(String opponent, String score) {
    return '$score. $opponent tiada jawapan untuk apa-apa.';
  }

  @override
  String yWinRout11(String opponent, String score) {
    return 'Belasah: $score menentang $opponent.';
  }

  @override
  String yWinRout12(String opponent, String score) {
    return '$score menentang $opponent. Bagus, tetapi mereka bukan penanda aras.';
  }

  @override
  String yWinRout13(String opponent, String score) {
    return '$score menentang $opponent. Kejutkan saya bila kita buat begini kepada pasukan hebat.';
  }

  @override
  String yWinRout14(String opponent, String score) {
    return '$opponent $score. Seronok, tetapi saya pernah lihat pasukan sehebat ini dan tidak menang apa-apa.';
  }

  @override
  String yWinRout15(String opponent, String score) {
    return '$score, dan semua orang jadi genius lagi. Lawannya $opponent.';
  }

  @override
  String yWinRout16(String opponent, String score) {
    return '$score menentang $opponent. Jangan terbawa-bawa, ia membuktikan sangat sedikit.';
  }

  @override
  String yWinRout17(String opponent, String score) {
    return '$opponent $score. Nikmatilah, kemudian ingat bagaimana kesudahannya kali terakhir kita teruja.';
  }

  @override
  String yWinShootout0(String opponent) {
    return 'Mara menerusi penalti menentang $opponent! Saraf besi, semuanya.';
  }

  @override
  String yWinShootout1(String opponent) {
    return 'Penentuan penalti menentang $opponent, dan kita kekal tenang. Peluk orang yang tidak dikenali.';
  }

  @override
  String yWinShootout2(String opponent) {
    return 'Menang penentuan penalti menentang $opponent. Jantung saya tidak tahan.';
  }

  @override
  String yWinShootout3(String opponent) {
    return '$opponent ditewaskan menerusi penalti. Mara ke pusingan seterusnya.';
  }

  @override
  String yWinShootout4(String opponent) {
    return 'Menentang $opponent segalanya ditentukan di titik penalti, dan kita jaringkan lebih banyak.';
  }

  @override
  String yWinShootout5(String opponent) {
    return 'Menang penalti menentang $opponent. Jalan paling sukar, tetapi mara.';
  }

  @override
  String yWinShootout6(String opponent) {
    return 'Mara menerusi penalti menentang $opponent. Menang loteri, lupakan persembahan.';
  }

  @override
  String yWinShootout7(String opponent) {
    return 'Tewaskan $opponent menerusi penalti selepas main begitu? Tuah, dan semua orang tahu.';
  }

  @override
  String yWinShootout8(String opponent) {
    return 'Mara menentang $opponent menerusi penalti. Tidak sepatutnya sampai ke tahap itu.';
  }

  @override
  String yKnockoutWin0(String opponent, String score) {
    return 'MARA. $score menentang $opponent, dan impian masih hidup.';
  }

  @override
  String yKnockoutWin1(String opponent, String score) {
    return 'MENANG KALAH MATI: $opponent ditewaskan $score. Negara boleh mula percaya.';
  }

  @override
  String yKnockoutWin2(String opponent, String score) {
    return '$score menentang $opponent dan mara ke pusingan seterusnya. Malam yang hebat.';
  }

  @override
  String yKnockoutWin3(String opponent, String score) {
    return '$opponent pulang, $score. Terus mara.';
  }

  @override
  String yKnockoutWin4(String opponent, String score) {
    return 'KALAH MATI: $score menentang $opponent. Pusingan seterusnya disahkan.';
  }

  @override
  String yKnockoutWin5(String opponent, String score) {
    return 'Mara: $score menentang $opponent.';
  }

  @override
  String yKnockoutWin6(String opponent, String score) {
    return '$opponent tersingkir, $score. Pusingan seterusnya menanti.';
  }

  @override
  String yKnockoutWin7(String opponent, String score) {
    return 'Menang $score menentang $opponent. Dalam kalah mati tiada siapa tanya bagaimana.';
  }

  @override
  String yKnockoutWin8(String opponent, String score) {
    return 'Mara menentang $opponent, $score. Lawan seterusnya tidak akan sebaik itu.';
  }

  @override
  String yKnockoutWin9(String opponent, String score) {
    return '$score menentang $opponent cukup untuk mara. Lain kali perlukan jauh lebih banyak.';
  }

  @override
  String yKnockoutWin10(String opponent, String score) {
    return '$opponent tersingkir, $score. Lebih kepada bertahan daripada menang.';
  }

  @override
  String yKnockoutWin11(String opponent, String score) {
    return 'Ke pusingan seterusnya selepas $score menentang $opponent. Jangan tanya bagaimana.';
  }

  @override
  String yUpsetGap0(String opponent, String gap) {
    return 'Jurang $gap anak tangga dalam ranking, dan kita tetap tewaskan $opponent. Hebat.';
  }

  @override
  String yUpsetGap1(String opponent, String gap) {
    return '$opponent: $gap anak tangga di atas kita. Ditewaskan. Bola sepak memang indah.';
  }

  @override
  String yUpsetGap2(String opponent, String gap) {
    return 'Jurang ranking: $gap. Keputusan: menang menentang $opponent. Jangan berhenti percaya.';
  }

  @override
  String yUpsetGap3(String opponent, String gap) {
    return 'Jurang ranking sebelum sepak mula: $gap. $opponent tetap ditewaskan.';
  }

  @override
  String yUpsetGap4(String opponent, String gap) {
    return 'Dalam ranking dunia, $opponent berada $gap anak tangga di atas kita. Bukan malam ini.';
  }

  @override
  String yUpsetGap5(String opponent, String gap) {
    return 'Indeks kejutan: jurang $gap anak tangga ranking. Kemenangan milik kita menentang $opponent.';
  }

  @override
  String yUpsetGap6(String opponent, String gap) {
    return 'Jurang $gap anak tangga ranking memisahkan kita daripada $opponent. Satu malam tidak menutup jurang itu.';
  }

  @override
  String yUpsetGap7(String opponent, String gap) {
    return '$opponent: $gap anak tangga di atas, dan tewas. Ranking hampir tidak perasan.';
  }

  @override
  String yUpsetGap8(String gap) {
    return 'Jurang ranking: $gap. Ingat nombor ini apabila kita kalah kepada pasukan kecil lain kali.';
  }

  @override
  String yEatWords0(String opponent) {
    return 'Saya sudah tolak skuad ini. Saya silap, dan tidak pernah segembira ini kerana silap. $opponent ditewaskan.';
  }

  @override
  String yEatWords1(String opponent) {
    return 'Satu pinggan rendah diri, tolong. Yang besar. Kemenangan ke atas $opponent sangat hebat.';
  }

  @override
  String yEatWords2(String opponent) {
    return 'Saya kata mereka sudah tiada apa-apa. Rupanya banyak. Syabas semua menentang $opponent.';
  }

  @override
  String yEatWords3(String opponent) {
    return 'Untuk rekod, saya tidak nampak kemenangan ke atas $opponent itu datang. Beri kredit sewajarnya.';
  }

  @override
  String yEatWords4(String opponent) {
    return 'Baiklah. Saya kata mereka akan terdedah. $opponent tidak berjaya mendedahkan mereka.';
  }

  @override
  String yEatWords5(String opponent) {
    return 'Malam ini saya telan kata-kata saya tentang skuad ini. Kemenangan ke atas $opponent layak untuk itu.';
  }

  @override
  String yEatWords6(String opponent) {
    return 'Ya, saya kata mereka sudah habis. Satu kemenangan ke atas $opponent belum buktikan saya salah.';
  }

  @override
  String yEatWords7(String opponent) {
    return 'Saya disuruh telan kata-kata selepas $opponent. Saya akan buat, perlahan-lahan, dan simpan resitnya.';
  }

  @override
  String yEatWords8(String opponent) {
    return 'Kemenangan ke atas $opponent mengagumkan. Keraguan saya tentang skuad ini masih ada.';
  }

  @override
  String yAwayFansWin0(String nation, String score) {
    return 'Tabik kepada $nation. $score, dan memang layak dari awal hingga akhir.';
  }

  @override
  String yAwayFansWin1(String nation, String score) {
    return 'Pedih untuk mengaku, tetapi malam ini $nation lebih baik. $score. Tahniah.';
  }

  @override
  String yAwayFansWin2(String nation, String score) {
    return '$score. Angkat topi kepada $nation, mereka lebih mahukannya.';
  }

  @override
  String yAwayFansWin3(String nation, String score) {
    return 'Tewas $score kepada $nation. Saya pun tidak tahu nak kata apa.';
  }

  @override
  String yAwayFansWin4(String nation, String score) {
    return '$nation $score. Pemain kita patut malu.';
  }

  @override
  String yAwayFansWin5(String nation, String score) {
    return '$score menentang $nation. Tolong terangkan kepada saya bagaimana itu boleh berlaku.';
  }

  @override
  String yAwayFansWin6(String nation, String score) {
    return 'Tewas $score kepada $nation. Saya tidak akan dapat lupakan ini.';
  }

  @override
  String yAwayFansWin7(String nation, String score) {
    return '$score menentang $nation. Tuah. Tuah semata-mata.';
  }

  @override
  String yAwayFansWin8(String nation, String score) {
    return 'Selepas $score itu, penyokong $nation akan menjengkelkan bertahun-tahun. Terima kasih untuk apa-apa pun tidak.';
  }

  @override
  String yNeutralWin0(String nation, String opponent, String score) {
    return '$nation $score $opponent. Hebat untuk bola sepak. Inilah sebabnya kita sayang sukan ini.';
  }

  @override
  String yNeutralWin1(String nation, String opponent, String score) {
    return 'Keputusan luar biasa untuk $nation: $score menentang $opponent. Bola sepak terbaik.';
  }

  @override
  String yNeutralWin2(String nation, String opponent, String score) {
    return 'Semua penonton neutral menyokong $nation malam ini. $score menentang $opponent!';
  }

  @override
  String yNeutralWin3(String nation, String opponent, String score) {
    return 'Keputusan pusingan ini: $nation $score $opponent.';
  }

  @override
  String yNeutralWin4(String nation, String opponent, String score) {
    return '$nation $score $opponent. Tiada siapa meneka itu.';
  }

  @override
  String yNeutralWin5(String nation, String opponent, String score) {
    return 'Keputusan besar: $nation $score $opponent. Ranking akan bergerak.';
  }

  @override
  String yNeutralWin6(String nation, String opponent, String score) {
    return '$nation $score $opponent. Seronok, mari lihat jika mereka boleh ulanginya.';
  }

  @override
  String yNeutralWin7(String nation, String opponent, String score) {
    return '$nation $score $opponent. $nation yang menang, atau $opponent yang kalah?';
  }

  @override
  String yNeutralWin8(String nation, String opponent, String score) {
    return 'Kejutan: $nation $score $opponent. Bersedia untuk banyak reaksi melampau.';
  }

  @override
  String yScorerHero0(String name, String opponent) {
    return '$name menentang $opponent. Orang akan namakan anak sempena namanya.';
  }

  @override
  String yScorerHero1(String name, String opponent) {
    return 'Patung untuk $name. Malam ini menentang $opponent dialah segala-galanya.';
  }

  @override
  String yScorerHero2(String name, String opponent) {
    return '$name, hebat sungguh. Ingat malam ini menentang $opponent.';
  }

  @override
  String yScorerHero3(String name, String opponent) {
    return '$name tentukan perlawanan menentang $opponent. Pemain terbaik, tanpa pertikaian.';
  }

  @override
  String yScorerHero4(String name, String opponent) {
    return 'Menentang $opponent, malam ini milik $name.';
  }

  @override
  String yScorerHero5(String name, String opponent) {
    return '$name muncul ketika diperlukan menentang $opponent.';
  }

  @override
  String yScorerHero6(String name, String opponent) {
    return '$name cemerlang menentang $opponent. Sekarang buat setiap minggu.';
  }

  @override
  String yScorerHero7(String name, String opponent) {
    return '$name selamatkan skuad menentang $opponent. Yang lain tidak banyak membantu.';
  }

  @override
  String yScorerHero8(String name, String opponent) {
    return 'Tanpa $name, malam menentang $opponent pasti sangat berbeza.';
  }

  @override
  String yLostShock0(String opponent, String score) {
    return '$score kepada $opponent. Kemalangan. Berlaku kepada semua sekali.';
  }

  @override
  String yLostShock1(String opponent, String score) {
    return 'Tewas $score kepada $opponent. Bangkit, kempen belum selesai.';
  }

  @override
  String yLostShock2(String opponent, String score) {
    return '$opponent $score. Menyakitkan, tetapi satu keputusan tidak menentukan skuad ini.';
  }

  @override
  String yLostShock3(String opponent, String score) {
    return '$score menentang $opponent. Hari buruk di pejabat. Teruskan.';
  }

  @override
  String yLostShock4(String opponent, String score) {
    return 'Tewas kepada $opponent, $score. Tiada siapa menjangkanya.';
  }

  @override
  String yLostShock5(String opponent, String score) {
    return '$opponent $score. Salah satu malam yang tidak masuk akal.';
  }

  @override
  String yLostShock6(String opponent, String score) {
    return '$score kepada $opponent. Kekalahan yang akan diingati.';
  }

  @override
  String yLostShock7(String opponent, String score) {
    return 'Ditewaskan $opponent, $score. Kejutan dari sudut mana pun.';
  }

  @override
  String yLostShock8(String opponent, String score) {
    return '$score kepada $opponent. Kepada $opponent! Tidak boleh diterima.';
  }

  @override
  String yLostShock9(String opponent, String score) {
    return 'Tewas $score kepada $opponent. Saya mahu penjelasan, bukan alasan.';
  }

  @override
  String yLostShock10(String opponent, String score) {
    return '$opponent $score. Aib negara, dan itu bukan kiasan.';
  }

  @override
  String yLostShock11(String opponent, String score) {
    return '$score menentang $opponent. Bagaimana orang di atas masih duduk di kerusi mereka?';
  }

  @override
  String yLostRout0(String opponent, String score) {
    return '$score kepada $opponent. Mereka pasukan terbaik. Belajar daripadanya.';
  }

  @override
  String yLostRout1(String opponent, String score) {
    return 'Kalah kelas kepada $opponent, $score. Tidak memalukan tewas kepada yang terbaik.';
  }

  @override
  String yLostRout2(String opponent, String score) {
    return '$opponent $score. Satu pengajaran, dan pengajaran membuat kita berkembang.';
  }

  @override
  String yLostRout3(String opponent, String score) {
    return '$score menentang $opponent. Menyakitkan, tetapi mereka setingkat lebih tinggi.';
  }

  @override
  String yLostRout4(String opponent, String score) {
    return '$opponent menang $score. Jurangnya nyata, dan kini semua orang sudah lihat.';
  }

  @override
  String yLostRout5(String opponent, String score) {
    return '$score kepada $opponent. Dibelasah, semudah itu.';
  }

  @override
  String yLostRout6(String opponent, String score) {
    return '$opponent $score. Pasukan yang lebih baik, dan keputusan menyatakannya.';
  }

  @override
  String yLostRout7(String opponent, String score) {
    return 'Tewas $score kepada $opponent. Bukan aib, tetapi bukan perlawanan juga.';
  }

  @override
  String yLostRout8(String opponent, String score) {
    return '$score kepada $opponent. Lawan lebih baik atau tidak, tiada siapa patut kalah begitu.';
  }

  @override
  String yLostRout9(String opponent, String score) {
    return '$opponent $score. Adakah kita cuba bersaing pun?';
  }

  @override
  String yLostRout10(String opponent, String score) {
    return '$score. Menentang $opponent. Bagai kambing ke tempat sembelihan.';
  }

  @override
  String yLostRout11(String opponent, String score) {
    return 'Tewas $score kepada $opponent, dan tiada siapa nampak peduli.';
  }

  @override
  String yLostShootout0(String opponent) {
    return 'Tersingkir menerusi penalti menentang $opponent. Mereka beri segalanya. Bangga dengan mereka.';
  }

  @override
  String yLostShootout1(String opponent) {
    return 'Penentuan penalti menentang $opponent. Cara paling kejam untuk tersingkir. Angkat kepala.';
  }

  @override
  String yLostShootout2(String opponent) {
    return 'Kalah penentuan penalti menentang $opponent. Tiada siapa layak menerimanya.';
  }

  @override
  String yLostShootout3(String opponent) {
    return 'Tersingkir menerusi penalti menentang $opponent. Titik penalti yang menentukan.';
  }

  @override
  String yLostShootout4(String opponent) {
    return '$opponent mara menerusi penalti. Kejohanan kita berakhir di situ.';
  }

  @override
  String yLostShootout5(String opponent) {
    return 'Kalah penalti menentang $opponent. Penalti lagi.';
  }

  @override
  String yLostShootout6(String opponent) {
    return 'Tersingkir menerusi penalti menentang $opponent. Kita pernah berlatih tak?';
  }

  @override
  String yLostShootout7(String opponent) {
    return 'Tewas kepada $opponent menerusi penalti. Sepatutnya selesai jauh lebih awal.';
  }

  @override
  String yLostShootout8(String opponent) {
    return 'Penentuan penalti menentang $opponent, dan kita kalah. Sudah tentu.';
  }

  @override
  String yKnockoutLoss0(String opponent, String score) {
    return 'TERSINGKIR. $score kepada $opponent. Perjalanan yang membanggakan berakhir di sini.';
  }

  @override
  String yKnockoutLoss1(String opponent, String score) {
    return 'Disingkirkan $opponent, $score. Terima kasih untuk kenangan.';
  }

  @override
  String yKnockoutLoss2(String opponent, String score) {
    return '$score menentang $opponent. Perjalanan sudah tamat, tetapi perjalanan yang hebat.';
  }

  @override
  String yKnockoutLoss3(String opponent, String score) {
    return 'TERSINGKIR: $score kepada $opponent. Angkat kepala.';
  }

  @override
  String yKnockoutLoss4(String opponent, String score) {
    return 'TAMAT: $score menentang $opponent.';
  }

  @override
  String yKnockoutLoss5(String opponent, String score) {
    return 'Tersingkir: $score menentang $opponent.';
  }

  @override
  String yKnockoutLoss6(String opponent, String score) {
    return '$opponent mara, $score. Kejohanan kita sudah tamat.';
  }

  @override
  String yKnockoutLoss7(String opponent, String score) {
    return 'Disingkirkan $opponent, $score. Bedah siasat bermula sekarang.';
  }

  @override
  String yKnockoutLoss8(String opponent, String score) {
    return 'TERSINGKIR. $score kepada $opponent. Kejohanan lain, kesudahan sama.';
  }

  @override
  String yKnockoutLoss9(String opponent, String score) {
    return '$score kepada $opponent, dan pulang. Tiada siapa terkejut.';
  }

  @override
  String yKnockoutLoss10(String opponent, String score) {
    return 'Disingkirkan $opponent, $score. Tunggu alasan sebelum pagi.';
  }

  @override
  String yKnockoutLoss11(String opponent, String score) {
    return '$opponent $score. Tersingkir, dan tidak pernah nampak akan berakhir lain.';
  }

  @override
  String yAwayFansGloat0(String nation, String score) {
    return '$score menentang $nation. Hormat, mereka akan kembali lebih kuat.';
  }

  @override
  String yAwayFansGloat1(String nation, String score) {
    return 'Kemenangan baik untuk kita, $score. Hari buruk untuk $nation, kasihan penyokong mereka.';
  }

  @override
  String yAwayFansGloat2(String nation, String score) {
    return '$score. Malam buruk untuk $nation, dan kita rebut peluang. Itulah bola sepak.';
  }

  @override
  String yAwayFansGloat3(String nation, String score) {
    return '$score menentang $nation! Siapa sangka? Bukan mereka.';
  }

  @override
  String yAwayFansGloat4(String nation, String score) {
    return 'Menang $score menentang $nation. Tolong tengok keadaan penyokong mereka.';
  }

  @override
  String yAwayFansGloat5(String nation, String score) {
    return '$nation $score. Yang ini masuk album gambar.';
  }

  @override
  String yAwayFansGloat6(String nation, String score) {
    return '$score menentang $nation. Dan mereka fikir mereka pasukan besar.';
  }

  @override
  String yAwayFansGloat7(String nation, String score) {
    return 'Bayangkan tewas $score kepada kita. Tanya $nation, sekarang mereka tahu.';
  }

  @override
  String yAwayFansGloat8(String nation, String score) {
    return '$nation, $score. Selamat terbang pulang.';
  }

  @override
  String yNeutralLoss0(String nation, String opponent, String score) {
    return '$nation $score $opponent. Malam besar untuk $opponent, malam berat untuk $nation.';
  }

  @override
  String yNeutralLoss1(String nation, String opponent, String score) {
    return 'Kekuatan untuk penyokong $nation selepas $score menentang $opponent. Mereka akan bangkit.';
  }

  @override
  String yNeutralLoss2(String nation, String opponent, String score) {
    return '$nation $score $opponent. Setiap pasukan besar pernah melalui malam begini.';
  }

  @override
  String yNeutralLoss3(String nation, String opponent, String score) {
    return 'Kejutan pusingan ini: $nation $score $opponent.';
  }

  @override
  String yNeutralLoss4(String nation, String opponent, String score) {
    return '$nation $score $opponent. Tiada siapa menjangkanya.';
  }

  @override
  String yNeutralLoss5(String nation, String opponent, String score) {
    return 'Keputusan hari ini: $nation $score $opponent. Kini $nation perlu menjawab soalan.';
  }

  @override
  String yNeutralLoss6(String nation, String opponent, String score) {
    return '$nation $score $opponent. Bukan kebetulan, jika anda mengikutinya.';
  }

  @override
  String yNeutralLoss7(String nation, String opponent, String score) {
    return '$nation $score $opponent. Seseorang di sana banyak perkara perlu dijelaskan.';
  }

  @override
  String yNeutralLoss8(String nation, String opponent, String score) {
    return '$nation $score $opponent. Nama besar, persembahan kecil.';
  }

  @override
  String yDownGap0(String opponent, String gap) {
    return '$opponent berada $gap anak tangga di bawah kita. Boleh berlaku. Teruskan.';
  }

  @override
  String yDownGap1(String gap) {
    return 'Jurang ranking: $gap memihak kepada kita. Bola sepak tidak membaca ranking.';
  }

  @override
  String yDownGap2(String opponent, String gap) {
    return 'Di atas kertas, jurang $gap anak tangga antara kita dan $opponent. Bukan di padang malam ini.';
  }

  @override
  String yDownGap3(String opponent, String gap) {
    return 'Jurang ranking sebelum sepak mula: $gap memihak kepada kita. Tetap tewas kepada $opponent.';
  }

  @override
  String yDownGap4(String opponent, String gap) {
    return 'Dalam ranking dunia, $opponent berada $gap anak tangga di bawah kita. Keputusan: kalah.';
  }

  @override
  String yDownGap5(String opponent, String gap) {
    return 'Indeks kejutan: $gap anak tangga ranking, ke arah yang salah, menentang $opponent.';
  }

  @override
  String yDownGap6(String opponent, String gap) {
    return '$gap anak tangga di atas $opponent dalam ranking. Kalah. Terangkan itu.';
  }

  @override
  String yDownGap7(String gap) {
    return 'Tewas kepada pasukan $gap anak tangga di bawah kita. Biar nombor itu meresap.';
  }

  @override
  String yDownGap8(String opponent, String gap) {
    return 'Jurang ranking: $gap. Tewas kepada $opponent. Seseorang patut mula mengira hari.';
  }

  @override
  String yDrewHeroic0(String opponent, String score) {
    return '$score menentang $opponent! Seri yang terasa seperti menang.';
  }

  @override
  String yDrewHeroic1(String opponent, String score) {
    return '$score menentang $opponent. Bangga dengan setiap seorang.';
  }

  @override
  String yDrewHeroic2(String opponent, String score) {
    return '$opponent $score. Mereka pilihan utama dan kita setanding.';
  }

  @override
  String yDrewHeroic3(String opponent, String score) {
    return '$score dengan $opponent. Satu mata diraih dengan darah dan peluh.';
  }

  @override
  String yDrewHeroic4(String opponent, String score) {
    return '$score menentang $opponent. Satu mata yang sangat bernilai.';
  }

  @override
  String yDrewHeroic5(String opponent, String score) {
    return 'Seri $score dengan $opponent. Sedikit sahaja yang menjangka apa-apa.';
  }

  @override
  String yDrewHeroic6(String opponent, String score) {
    return '$opponent disekat, $score. Keputusan untuk dijadikan asas.';
  }

  @override
  String yDrewHeroic7(String opponent, String score) {
    return '$score menentang $opponent. Satu mata yang tiada siapa berikan kepada kita.';
  }

  @override
  String yDrewHeroic8(String opponent, String score) {
    return '$score dengan $opponent. Mata yang baik, tetapi seri tidak menjulang trofi.';
  }

  @override
  String yDrewHeroic9(String opponent, String score) {
    return '$score menentang $opponent. Bagus. Kita pun tiada satu rembatan yang elok.';
  }

  @override
  String yDrewHeroic10(String opponent, String score) {
    return '$opponent $score. Satu mata, dan semua orang berlagak seperti kita juara.';
  }

  @override
  String yDrewHeroic11(String opponent, String score) {
    return '$score menentang $opponent. Letak bas depan gol dan bernasib baik.';
  }

  @override
  String yDrewShame0(String opponent, String score) {
    return '$score dengan $opponent. Mengecewakan, tetapi masih belum tewas.';
  }

  @override
  String yDrewShame1(String opponent, String score) {
    return 'Hanya $score dengan $opponent. Hari yang buruk. Boleh berlaku.';
  }

  @override
  String yDrewShame2(String opponent, String score) {
    return '$opponent $score. Tidak cukup baik, dan pemain tahu.';
  }

  @override
  String yDrewShame3(String opponent, String score) {
    return '$score menentang $opponent. Dua mata hilang, tidak lebih.';
  }

  @override
  String yDrewShame4(String opponent, String score) {
    return '$score dengan $opponent. Dua mata dibuang.';
  }

  @override
  String yDrewShame5(String opponent, String score) {
    return 'Hanya $score dengan $opponent. Keputusan buruk, macam mana pun dibungkus.';
  }

  @override
  String yDrewShame6(String opponent, String score) {
    return '$opponent $score. Seri yang terasa seperti kalah.';
  }

  @override
  String yDrewShame7(String opponent, String score) {
    return '$score menentang $opponent. Perlawanan begini patut dimenangi dengan selesa.';
  }

  @override
  String yDrewShame8(String opponent, String score) {
    return '$score dengan $opponent. Memalukan.';
  }

  @override
  String yDrewShame9(String opponent, String score) {
    return 'Hanya seri dengan $opponent, $score. Siapa yang bertanggungjawab?';
  }

  @override
  String yDrewShame10(String opponent, String score) {
    return '$opponent $score. Kalau mereka pun tak boleh dikalahkan, siapa lagi?';
  }

  @override
  String yDrewShame11(String opponent, String score) {
    return '$score dengan $opponent. Penyokong mereka meraikan seri menentang kita. Fikirkan itu.';
  }

  @override
  String yTrophy0(String opponent) {
    return 'JUARA. $opponent. Sebut dengan kuat.';
  }

  @override
  String yTrophy1(String opponent) {
    return 'Kita menang. $opponent. Saya tidak keruan.';
  }

  @override
  String yTrophy2(String opponent) {
    return '$opponent, dan trofi akan dibawa pulang.';
  }

  @override
  String yTrophy3(String opponent) {
    return 'Setiap seorang daripada mereka legenda. $opponent.';
  }

  @override
  String yRunnerUp0(String opponent) {
    return 'Begitu hampir. $opponent dan pingat yang tiada siapa mahu.';
  }

  @override
  String yRunnerUp1(String opponent) {
    return 'Naib juara di $opponent. Pedihnya akan terasa bertahun-tahun.';
  }

  @override
  String yRunnerUp2(String opponent) {
    return '$opponent: satu perlawanan daripada segalanya.';
  }

  @override
  String yRunnerUp3(String opponent) {
    return 'Kedua. Di $opponent. Tolong hulurkan botol itu.';
  }

  @override
  String yEliminated0(String opponent) {
    return 'Tersingkir di $opponent. Yang itu akan pedih untuk seketika.';
  }

  @override
  String yEliminated1(String opponent) {
    return '$opponent ialah penamat perjalanan kita.';
  }

  @override
  String yEliminated2(String opponent) {
    return 'Tersingkir di $opponent. Kini masa untuk siasatan.';
  }

  @override
  String yEliminated3(String opponent) {
    return 'Tersingkir di $opponent. Seseorang tolong terangkan kepada saya.';
  }

  @override
  String yQualified0(String opponent) {
    return 'KITA KE $opponent.';
  }

  @override
  String yQualified1(String opponent) {
    return 'Layak ke $opponent. Mohon cuti sekarang.';
  }

  @override
  String yQualified2(String opponent) {
    return '$opponent, kami datang. Tidak pernah diragui (sebenarnya sangat diragui).';
  }

  @override
  String yQualified3(String opponent) {
    return 'Mara ke $opponent. Bahagian paling sukar sudah selesai.';
  }

  @override
  String yGroupDrawn0(String opponent) {
    return 'Kumpulan untuk $opponent sudah dicabut. Boleh jadi lebih teruk. Jauh lebih teruk.';
  }

  @override
  String yGroupDrawn1(String opponent) {
    return 'Jadi itulah cabutan undian $opponent. Menarik.';
  }

  @override
  String yGroupDrawn2(String opponent) {
    return 'Kumpulan $opponent sudah keluar dan saya sudah tidak suka kumpulan kita.';
  }

  @override
  String yGroupDrawn3(String opponent) {
    return 'Cabutan undian $opponent selesai. Biar reaksi melampau bermula.';
  }

  @override
  String yHostNamed0(String opponent) {
    return '$opponent akan menjadi tuan rumah. Mula menabung.';
  }

  @override
  String yHostNamed1(String opponent) {
    return 'Ia diberikan kepada $opponent. Boleh dijangka, tetapi tidak mengapa.';
  }

  @override
  String yHostNamed2(String opponent) {
    return '$opponent mendapat kejohanan itu. Tahniah kepada mereka, barangkali.';
  }

  @override
  String yHostNamed3(String opponent) {
    return 'Tuan rumah disahkan: $opponent.';
  }

  @override
  String yTournamentSoon0(String opponent) {
    return '$opponent bermula tidak lama lagi dan saya tidak boleh duduk diam.';
  }

  @override
  String yTournamentSoon1(String opponent) {
    return 'Tidak lama lagi menjelang $opponent.';
  }

  @override
  String yTournamentSoon2(String opponent) {
    return '$opponent hampir tiba. Umumkan skuad, tolonglah.';
  }

  @override
  String yTournamentSoon3(String opponent) {
    return 'Kiraan detik menuju $opponent secara rasminya tidak tertahan.';
  }

  @override
  String get navY => 'Y';

  @override
  String get yTitle => 'Y';

  @override
  String get yEmpty =>
      'Belum ada apa-apa untuk dikatakan. Mainkan satu perlawanan.';

  @override
  String get yEarlierHeading => 'Awal kitaran ini';

  @override
  String get yTraitLoyalist =>
      'Menyokong pasukan walau apa pun berlaku. Lambat berpaling, cepat memaafkan.';

  @override
  String get yTraitCynic =>
      'Sentiasa menjangkakan yang terburuk dan gembira apabila terbukti betul.';

  @override
  String get yTraitNostalgic =>
      'Semuanya lebih baik dahulu. Membandingkan anda dengan pemain yang sudah bersara.';

  @override
  String get yTraitStatshead => 'Hanya menyiarkan angka. Hampir tiada emosi.';

  @override
  String get yTraitHypeman =>
      'Dua keputusan baik dan terus jadi generasi emas.';

  @override
  String get yTraitContrarian =>
      'Apa sahaja pendapat orang ramai, dia sebaliknya.';

  @override
  String get yTraitDoomer => 'Ia akan gagal. Ia sentiasa akan gagal.';

  @override
  String get yProfilePosts => 'SIARAN';

  @override
  String get yProfileEmpty => 'Belum ada apa-apa daripada akaun ini.';

  @override
  String hubEventGrievance(String player) {
    return '$player mahu berbincang';
  }

  @override
  String get hubEventGrievanceSub => 'Dia mahu tahu kedudukannya';

  @override
  String hubEventManagerSkills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mata kemahiran untuk digunakan',
      one: '1 mata kemahiran untuk digunakan',
    );
    return '$_temp0';
  }

  @override
  String get hubEventManagerSkillsSub =>
      'Kepakaran anda menjadikan pasukan anda lebih baik';

  @override
  String get grievanceTitle => 'Perbincangan di pejabat anda';

  @override
  String grievanceGameTime(String player) {
    return '$player berada dalam skuad tetapi belum menyepak bola langsung. Dia mahu tahu sebabnya.';
  }

  @override
  String grievanceSquadPlace(String player) {
    return '$player tidak tersenarai dalam skuad dan tidak faham kenapa. Dia mahu penjelasan, apa pun jawapannya.';
  }

  @override
  String grievanceRole(String player) {
    return '$player terus dimainkan di luar posisi asalnya dan sudah muak.';
  }

  @override
  String get grievanceReassure => 'Kamu ada dalam perancangan saya';

  @override
  String get grievanceHonest =>
      'Kamu di belakang pemain lain, dan ini sebabnya';

  @override
  String get grievanceDismiss => 'Saya yang memilih pasukan';

  @override
  String yScorerStar0(String name, String goals) {
    return '$name menjaringkan $goals daripadanya. Tiada orang lain yang hampir.';
  }

  @override
  String yScorerStar1(String name, String goals) {
    return '$goals untuk $name. Dia memikul pasukan ini.';
  }

  @override
  String yScorerStar2(String name, String goals) {
    return '$name: $goals hari ini. Pemain yang luar biasa.';
  }

  @override
  String yScorerStar3(String name, String goals) {
    return '$name menyumbat $goals gol. Tabik hormat.';
  }

  @override
  String yScorerStar4(String name, String goals) {
    return '$goals untuk $name, dan yang lain sekadar penumpang.';
  }

  @override
  String yScorerStar5(String name, String goals) {
    return '$name lagi. $goals. Bayangkan pasukan ini tanpa dia.';
  }

  @override
  String yScorerStar6(String name, String goals) {
    return '$goals daripada $name. Seorang pemain tidak sepatutnya perlu buat sebanyak ini.';
  }

  @override
  String yScorerStar7(String name, String goals) {
    return 'Tanpa $name, kurang $goals gol dan petang yang sangat berbeza.';
  }

  @override
  String yWinStreak0(String count) {
    return '$count berturut-turut. Apa pun yang dikatakan dalam bilik persalinan itu, ia berkesan.';
  }

  @override
  String yWinStreak1(String count) {
    return 'Itu $count berturut-turut. Pasukan tidak tersadung ke dalam rentetan seperti ini.';
  }

  @override
  String yWinStreak2(String count) {
    return '$count berturut-turut dan terus bertambah. Keyakinan jelas kelihatan dari tempat duduk penonton.';
  }

  @override
  String yWinStreak3(String count) {
    return 'Tanpa kalah dalam $count. Tanya sesiapa yang pernah menjadi jurulatih: itulah bahagian paling sukar.';
  }

  @override
  String yWinStreak4(String count) {
    return '$count berturut-turut. Nikmatilah selagi jadual masih bermurah hati.';
  }

  @override
  String yWinStreak5(String count) {
    return '$count berturut-turut, dan kita belum menewaskan sesiapa yang penting.';
  }

  @override
  String yWinStreak6(String count) {
    return 'Rentetan $count. Tanya saya lagi bila ia diuji.';
  }

  @override
  String yWinStreak7(String count) {
    return '$count berturut-turut. Setiap pasukan ada satu rentetan begini sekali sekala.';
  }

  @override
  String yLossStreak0(String count) {
    return '$count tanpa kemenangan sekarang. Pada satu tahap alasan akan habis.';
  }

  @override
  String yLossStreak1(String count) {
    return 'Itu $count berturut-turut hilang. Ini bukan lagi kebetulan.';
  }

  @override
  String yLossStreak2(String count) {
    return '$count kekalahan berturut-turut. Seseorang perlu bertanggungjawab.';
  }

  @override
  String yLossStreak3(String count) {
    return 'Tiada kemenangan dalam $count. Anda boleh nampak pada cara mereka bermain.';
  }

  @override
  String yLossStreak4(String count) {
    return '$count tanpa kemenangan dan kesilapan yang sama setiap minggu.';
  }

  @override
  String yLossStreak5(String count) {
    return '$count berturut-turut. Apa pun yang dicuba, ia tidak berkesan.';
  }

  @override
  String yLossStreak6(String count) {
    return '$count berturut-turut. Ini satu hala tuju, bukan sekadar kemerosotan.';
  }

  @override
  String yLossStreak7(String count) {
    return 'Tiada kemenangan dalam $count, dan tiada siapa di atas berkata sepatah pun.';
  }

  @override
  String yRivalry0(String opponent, String score) {
    return '$opponent $score. Kata apa sahaja tentang permainannya. Yang ini dikira dua kali ganda.';
  }

  @override
  String yRivalry1(String opponent, String score) {
    return 'Menentang $opponent, daripada semua pasukan. $score. Tiada siapa di sini akan melupakannya.';
  }

  @override
  String yRivalry2(String opponent, String score) {
    return '$score menentang $opponent. Itulah yang akan dibualkan di kedai mamak.';
  }

  @override
  String yRivalry3(String opponent, String score) {
    return 'Jiran kita, $score. Hak untuk berbangga sudah ditentukan buat seketika.';
  }

  @override
  String yRivalry4(String opponent, String score) {
    return '$opponent $score. Apa pun yang berlaku tahun ini, kita ada yang itu.';
  }

  @override
  String yRivalry5(String opponent, String score) {
    return '$score menentang $opponent. Sebahagian daripada kita lebih memerlukannya berbanding kedudukan liga.';
  }

  @override
  String yRivalry6(String opponent, String score) {
    return '$opponent $score. Dan mereka akan membalasnya lain kali, mereka sentiasa begitu.';
  }

  @override
  String yRivalry7(String opponent, String score) {
    return 'Menentang $opponent, $score. Setahun penuh diingatkan tentang yang satu ini.';
  }

  @override
  String yInjuryBlow0(String name) {
    return '$name keluar kerana cedera. Itu perkara terakhir yang diperlukan pasukan ini.';
  }

  @override
  String yInjuryBlow1(String name) {
    return 'Kehilangan $name mengubah segala-galanya.';
  }

  @override
  String yInjuryBlow2(String name) {
    return '$name terhincut-hincut. Tahan nafas.';
  }

  @override
  String yInjuryBlow3(String name) {
    return 'Tiada $name untuk seketika, jadi. Seseorang perlu tampil.';
  }

  @override
  String yInjuryBlow4(String name) {
    return '$name cedera. Sudah tentu $name.';
  }

  @override
  String yInjuryBlow5(String name) {
    return 'Tanpa $name ini menjadi pasukan yang sangat biasa.';
  }

  @override
  String yInjuryBlow6(String name) {
    return '$name cedera lagi. Seseorang patut bertanya kenapa.';
  }

  @override
  String yInjuryBlow7(String name) {
    return 'Kehilangan $name, dan tiada pengganti di belakangnya. Itulah masalah sebenar.';
  }

  @override
  String ySentOff0(String name, String minute) {
    return 'Kad merah untuk $name pada minit ke-$minute dan seluruh negara menyerangnya. Dia sudah memberi lebih daripada kebanyakan pemain. Sudahlah.';
  }

  @override
  String ySentOff1(String name, String minute) {
    return '$name dibuang padang selepas $minute minit. Keras. Sepuluh pemain dan kita masih mencuba, itu sudah menunjukkan sesuatu.';
  }

  @override
  String ySentOff2(String name, String minute) {
    return '$name, minit $minute, kad merah. Sepuluh pemain dari situ.';
  }

  @override
  String ySentOff3(String name, String minute) {
    return 'Dibuang padang: $name pada minit $minute. Bukan perlawanan pertama yang berubah kerana satu keputusan.';
  }

  @override
  String ySentOff4(String name, String minute) {
    return 'Hebat. $name keluar pada minit ke-$minute dan kita tinggal sepuluh. Lagi.';
  }

  @override
  String ySentOff5(String name, String minute) {
    return '$name dibuang padang selepas $minute minit. Siapa sebenarnya yang melatih disiplin di sini?';
  }

  @override
  String ySentOff6(String name, String minute) {
    return '$minute minit. Selama itu sahaja $name mampu mengawal diri. Bola sepak profesional.';
  }

  @override
  String ySentOff7(String name, String minute) {
    return 'Kad merah untuk $name pada minit ke-$minute, dan saya disuruh percaya ini satu kemajuan.';
  }

  @override
  String get yBoardPressure0 =>
      'Lembaga sudah sangat senyap. Itu tidak pernah petanda baik.';

  @override
  String get yBoardPressure1 =>
      'Khabarnya bilik lembaga sudah mula bertanya soalan.';

  @override
  String get yBoardPressure2 =>
      'Anda boleh rasa tanah mula bergoyang di tingkat atas.';

  @override
  String get yBoardPressure3 =>
      'Tiada siapa di persatuan berkata apa-apa yang menyokong. Buat kesimpulan sendiri.';

  @override
  String get yBoardPressure4 =>
      'Sudah berminggu-minggu tiada siapa di atas menyokongnya secara terbuka.';

  @override
  String get yBoardPressure5 =>
      'Persatuan membocorkan cerita menentang jurulatihnya sendiri. Macam biasa.';

  @override
  String get yBoardPressure6 =>
      'Apabila lembaga diam, mereka sudah pun membuat keputusan.';

  @override
  String get yBoardPressure7 =>
      'Mereka akan biarkan ini berlarutan sehingga ia menjadi keputusan orang lain.';

  @override
  String get yReplies => 'JUGA TENTANG PERLAWANAN INI';

  @override
  String get yPlayerGrievance0 =>
      'Sudah bertanya tentang kedudukan saya. Masih menunggu jawapan.';

  @override
  String get yPlayerGrievance1 =>
      'Berlatih bersungguh-sungguh. Tiada banyak lagi yang boleh saya buat.';

  @override
  String get yPlayerGrievance2 => 'Ada soalan yang hanya boleh ditanya sekali.';

  @override
  String get yPlayerGrievance3 =>
      'Saya tidak datang sejauh ini untuk sekadar membawa bib.';

  @override
  String get playerHonoursTitle => 'PENGHORMATAN';

  @override
  String get awardGoldenBall => 'Bola Emas';

  @override
  String get awardGoldenBoot => 'Kasut Emas';

  @override
  String get awardGoldenGlove => 'Sarung Tangan Emas';

  @override
  String get awardTeamOfTournament => 'Pasukan Terbaik Kejohanan';

  @override
  String get awardPlayerOfYear => 'Pemain Terbaik Dunia';

  @override
  String get awardYoungPlayerOfYear => 'Pemain Muda Terbaik';

  @override
  String get playerClubHistory => 'SEJARAH KELAB';

  @override
  String get playerCareerRecord => 'REKOD KERJAYA';

  @override
  String get playerInternationalGoals => 'Gol antarabangsa';

  @override
  String get playerRecentForm => 'PRESTASI TERKINI';

  @override
  String get playerMatchHistory => 'SEJARAH PERLAWANAN';

  @override
  String get playerAttributes => 'ATRIBUT';

  @override
  String get playerUnknown => 'Tidak diketahui';

  @override
  String get playerAttrPace => 'Kepantasan';

  @override
  String get playerAttrPhysical => 'Fizikal';

  @override
  String get playerAttrTechnical => 'Teknikal';

  @override
  String get playerAttrShooting => 'Rembatan';

  @override
  String get playerAttrPassing => 'Hantaran';

  @override
  String get playerAttrDribbling => 'Gelecek';

  @override
  String get playerAttrTackling => 'Terjahan';

  @override
  String get playerAttrPositioning => 'Kedudukan';

  @override
  String get playerAttrComposure => 'Ketenangan';

  @override
  String get playerAttrDecisions => 'Keputusan';

  @override
  String get playerAttrStamina => 'Stamina';

  @override
  String get playerAttrStrength => 'Kekuatan';

  @override
  String get playerStatCaps => 'Penampilan';

  @override
  String get playerStatGoals => 'Gol';

  @override
  String get playerStatAssists => 'Bantuan';

  @override
  String get playerStatAvgRating => 'Purata penarafan';

  @override
  String get playerStatForm => 'Prestasi';

  @override
  String get playerStatMotm => 'Pemain Terbaik';

  @override
  String get playerStatCleanSheets => 'Tanpa bolos';

  @override
  String get playerStatBestGame => 'Perlawanan terbaik';

  @override
  String get playerStatCards => 'Kad';

  @override
  String playerCardsValue(int yellows, int reds) {
    return '${yellows}K ${reds}M';
  }

  @override
  String get tourSharedYourRun => 'PERJALANAN ANDA';

  @override
  String get tourSharedList => 'Senarai';

  @override
  String get tourSharedBracket => 'Carta';

  @override
  String get tourSharedVs => 'lwn';

  @override
  String tourSharedGroupSeed(String seed) {
    return 'Kumpulan $seed';
  }

  @override
  String get tourSharedThisEdition => 'Edisi ini';

  @override
  String get tourSharedAllTime => 'Sepanjang zaman';

  @override
  String get tourSharedUnknown => 'Tidak diketahui';

  @override
  String get tourSharedActive => 'AKTIF';

  @override
  String get tourSharedMedalTable => 'JADUAL PINGAT';

  @override
  String get tourSharedPastWinners => 'JUARA TERDAHULU';

  @override
  String tourSharedHost(String host) {
    return 'Tuan rumah: $host';
  }

  @override
  String get tourSharedBeat => 'menewaskan';

  @override
  String get tourSharedPens => ' (pen)';

  @override
  String get tourSharedAwardsEmpty =>
      'Anugerah ditentukan setelah kejohanan selesai dimainkan.';

  @override
  String get tourSharedGoldenBall => 'BOLA EMAS';

  @override
  String get tourSharedPlayerOfTournament => 'Pemain Terbaik Kejohanan';

  @override
  String get tourSharedGoldenBoot => 'KASUT EMAS';

  @override
  String tourSharedGoalsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gol',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedGoldenGlove => 'SARUNG TANGAN EMAS';

  @override
  String get tourSharedTeamOfTournament => 'PASUKAN TERBAIK KEJOHANAN';

  @override
  String get tourSharedStatsEmpty =>
      'Rekod akan muncul setelah pertandingan ini mempunyai sejarah.';

  @override
  String get tourSharedRecordScorer => 'PENJARING REKOD';

  @override
  String get tourSharedStillActive => 'masih aktif';

  @override
  String get tourSharedMostTitles => 'KEJUARAAN TERBANYAK';

  @override
  String tourSharedTitlesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kejuaraan',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostFinals => 'FINAL TERBANYAK';

  @override
  String tourSharedFinalsContested(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count final disertai',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostGamesPlayed => 'PALING BANYAK PERLAWANAN';

  @override
  String tourSharedMatchesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count perlawanan',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostFinalsPlayed => 'PALING BANYAK PUSINGAN AKHIR';

  @override
  String tourSharedFinalsTournamentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pusingan akhir',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedBiggestFinalWin => 'KEMENANGAN TERBESAR DI FINAL';

  @override
  String tourStatsGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gol',
      one: '1 gol',
    );
    return '$_temp0';
  }

  @override
  String get tourStatsStillActive => 'masih aktif';

  @override
  String tourStatsTitles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kejuaraan',
      one: '1 kejuaraan',
    );
    return '$_temp0';
  }

  @override
  String tourStatsFinalsContested(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count final disertai',
      one: '1 final disertai',
    );
    return '$_temp0';
  }

  @override
  String tourStatsMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count perlawanan',
      one: '1 perlawanan',
    );
    return '$_temp0';
  }

  @override
  String tourStatsFinalsTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kejohanan ke final',
      one: '1 kejohanan ke final',
    );
    return '$_temp0';
  }

  @override
  String get tourStatsLeaders => 'PENDAHULU SEPANJANG ZAMAN';

  @override
  String get tourStatsTabGames => 'Perlawanan';

  @override
  String get tourStatsTabCups => 'Edisi';

  @override
  String get tourStatsTabScorers => 'Penjaring';

  @override
  String tourSharedFinalWinDetail(String opponent, int year) {
    return 'lwn $opponent · $year';
  }

  @override
  String get tourHolders => 'PENYANDANG';

  @override
  String tourHoldersSince(int year) {
    return 'juara $year';
  }

  @override
  String get tourSharedAllTimeScorers => 'PENJARING SEPANJANG ZAMAN';

  @override
  String get tourSharedSummaryEmpty =>
      'Tuan rumah dan stadiumnya akan muncul setelah cabutan undian edisi ini dibuat.';

  @override
  String get tourSharedHostHeading => 'TUAN RUMAH';

  @override
  String get tourSharedHostsHeading => 'TUAN RUMAH';

  @override
  String get tourSharedCoHostsHeading => 'TUAN RUMAH BERSAMA';

  @override
  String get tourSharedVenues => 'STADIUM';

  @override
  String get tourSharedMascot => 'MASKOT';

  @override
  String get tourSharedMatchBall => 'BOLA RASMI';

  @override
  String tourSharedVenueSeats(String city, String capacity) {
    return '$city · $capacity tempat duduk';
  }

  @override
  String get tourSharedCouldNotLoad => 'Tidak dapat dimuatkan.';

  @override
  String get tourSharedHostTbc => 'TUAN RUMAH BELUM DISAHKAN';

  @override
  String get tourSharedFinalsAreHere => 'PUSINGAN AKHIR TELAH TIBA';

  @override
  String tourSharedHostedBy(String hosts) {
    return 'TUAN RUMAH  $hosts';
  }

  @override
  String get tourSharedLetFinalsBegin => 'Mulakan pusingan akhir';

  @override
  String get tourSharedCompetitions => 'PERTANDINGAN';

  @override
  String get tourSharedWorldRanking => 'Ranking dunia';

  @override
  String get tourSharedCouldNotLoadTournaments =>
      'Kejohanan tidak dapat dimuatkan.';

  @override
  String get tourSharedPrestigeStage => 'PENTAS BERPRESTIJ';

  @override
  String get tourSharedOverview => 'Gambaran Keseluruhan';

  @override
  String get tourSharedWorldRankingTitle => 'Ranking Dunia';

  @override
  String get tourSharedYourCompetitions => 'PERTANDINGAN ANDA';

  @override
  String get tourSharedOtherContinents => 'BENUA LAIN';

  @override
  String get tourSharedComingSoon => 'Kejohanan akan datang';

  @override
  String get tourSharedSoon => 'AKAN DATANG';

  @override
  String get tourSharedNoQualifyingDraw => 'Tiada cabutan undian kelayakan.';

  @override
  String get tourSharedOpenEnvelope => 'Buka sampul';

  @override
  String tourSharedGroupName(String name) {
    return 'KUMPULAN $name';
  }

  @override
  String get tourSharedBall => 'Bola';

  @override
  String get tourSharedPot => 'Pot';

  @override
  String get tourSharedAll => 'Semua';

  @override
  String get tourSharedTapDrawTeam => 'Ketik untuk mencabut pasukan seterusnya';

  @override
  String get tourSharedTapDrawPot => 'Ketik untuk mencabut pot seterusnya';

  @override
  String get tourSharedTapDrawAll =>
      'Ketik untuk mendedahkan keseluruhan cabutan';

  @override
  String get tourSharedContinue => 'Teruskan';

  @override
  String get tourSharedPause => 'Jeda';

  @override
  String get tourSharedPlay => 'Main';

  @override
  String get tourSharedSkip => 'Langkau';

  @override
  String tourSharedPotNumber(int number) {
    return 'POT $number';
  }

  @override
  String get tourSharedDrawComplete => 'CABUTAN SELESAI';

  @override
  String get tourSharedDrawing => 'MENCABUT…';

  @override
  String get tourContChampionship => 'KEJOHANAN';

  @override
  String get tourContTabSummary => 'RINGKASAN';

  @override
  String get tourContTabQualifying => 'KELAYAKAN';

  @override
  String get tourContTabFinals => 'PUSINGAN AKHIR';

  @override
  String get tourContTabBracket => 'CARTA';

  @override
  String get tourContTabAwards => 'ANUGERAH';

  @override
  String get tourContTabScorers => 'PENJARING';

  @override
  String get tourContTabHistory => 'SEJARAH';

  @override
  String get tourContTabRecords => 'REKOD';

  @override
  String tourContCouldNotLoadCup(String error) {
    return 'Piala tidak dapat dimuatkan.\n$error';
  }

  @override
  String get tourContNoCupData => 'Tiada data piala.';

  @override
  String get tourContUnknown => 'Tidak diketahui';

  @override
  String get tourContGroupsToBeDrawnQual =>
      'Kumpulan kelayakan dicabut semasa majlis. Tonton dari hab untuk melihat lawan anda.';

  @override
  String get tourContQualSeeded =>
      'Negara anda terus layak ke pusingan akhir. Tiada kelayakan pada kitaran ini.';

  @override
  String tourContBackgroundRegion(String name) {
    return '$name disimulasikan di latar belakang. Keputusan muncul di sini setiap kali satu pusingan dimainkan.';
  }

  @override
  String get tourContGroupsToBeDrawnFinals =>
      'Kumpulan pusingan akhir dicabut semasa majlis. Tonton dari hab untuk melihat kumpulan anda.';

  @override
  String get tourContFinalsDrawAfterQual =>
      'Cabutan undian pusingan akhir diadakan setelah kelayakan selesai.';

  @override
  String get tourContContestedBeforeWc =>
      'Pusingan kalah mati dimainkan sebelum Kejohanan Dunia.';

  @override
  String tourContChampionsHeading(String name) {
    return 'JUARA $name';
  }

  @override
  String tourContWinnersTitle(String name) {
    return 'Juara $name';
  }

  @override
  String get tourContNoGoalsYet => 'Belum ada gol dijaringkan.';

  @override
  String tourContGroupHeading(String name) {
    return 'KUMPULAN $name';
  }

  @override
  String get tourContBestRunnersUp => 'NAIB JUARA TERBAIK';

  @override
  String tourContGroupDropdown(String name) {
    return 'Kumpulan $name';
  }

  @override
  String get tourContMatches => 'PERLAWANAN';

  @override
  String get tourContNoGroupsDrawn => 'Belum ada kumpulan dicabut.';

  @override
  String get tourContQualifyingDraw => 'CABUTAN KELAYAKAN';

  @override
  String get tourContWorldQualifyingDraw => 'CABUTAN KELAYAKAN DUNIA';

  @override
  String get tourContFinalsDraw => 'CABUTAN PUSINGAN AKHIR';

  @override
  String get tourContSeedingPots => 'POT PILIHAN';

  @override
  String get tourContGroupDraw => 'CABUTAN KUMPULAN';

  @override
  String tourContCouldNotLoadDraw(String error) {
    return 'Cabutan undian tidak dapat dimuatkan.\n$error';
  }

  @override
  String get tourContDrawNotReady => 'Cabutan undian belum sedia.';

  @override
  String get tourContContinentalClash => 'PERTEMBUNGAN BENUA';

  @override
  String get tourContTabThisCycle => 'KITARAN INI';

  @override
  String tourContCouldNotLoadClash(String error) {
    return 'Tidak dapat dimuatkan.\n$error';
  }

  @override
  String get tourContNoSaveFound => 'Simpanan tidak dijumpai.';

  @override
  String get tourContClashSoon =>
      'Pertembungan Benua dimainkan setelah kedua-dua juara benua diketahui.';

  @override
  String get tourContTwoContinentsOneMatch => 'DUA BENUA, SATU PERLAWANAN';

  @override
  String get tourContVersusShort => 'lwn';

  @override
  String tourContWinTheClash(String name) {
    return '$name memenangi Pertembungan';
  }

  @override
  String get tourContNoClashYet => 'Belum ada Pertembungan Benua dimainkan.';

  @override
  String get tourContNationsCup => 'PIALA NEGARA-NEGARA';

  @override
  String get tourContTabLeagues => 'LIGA';

  @override
  String get tourContTabFinalsFour => 'FINAL EMPAT';

  @override
  String tourContCouldNotLoad(String error) {
    return 'Tidak dapat dimuatkan.\n$error';
  }

  @override
  String get tourContNoNationsCupGoals =>
      'Belum ada gol Piala Negara-Negara direkodkan.';

  @override
  String get tourContNoNationsCupChampions =>
      'Belum ada juara Piala Negara-Negara dinobatkan.';

  @override
  String get tourContNationsCupOffSeason =>
      'Piala Negara-Negara kitaran ini bermula selepas pusingan akhir benua. Juara terdahulu ada di bawah Sejarah.';

  @override
  String get tourContNationsCupGroupsSoon =>
      'Kumpulan Piala Negara-Negara kitaran ini dicabut semasa majlis. Tonton dari hab untuk melihat lawan anda.';

  @override
  String get tourContLeagueNoGroups =>
      'Tiada perlawanan dalam liga ini pada pusingan ini.';

  @override
  String tourContLeagueHeading(String letter) {
    return 'LIGA $letter';
  }

  @override
  String tourContLeagueHeadingYours(String letter) {
    return 'LIGA $letter · LIGA ANDA';
  }

  @override
  String get tourContFinalsFourSoon =>
      'Final Empat disertai oleh juara kumpulan Liga A setelah peringkat kumpulan selesai.';

  @override
  String tourContLeagueChip(String letter) {
    return 'Liga $letter';
  }

  @override
  String tourContLeagueChipStar(String letter) {
    return 'Liga $letter ★';
  }

  @override
  String get tourContSemiFinals => 'SEPARUH AKHIR';

  @override
  String get tourContFinal => 'FINAL';

  @override
  String get tourContNationsCupDraw => 'CABUTAN PIALA NEGARA-NEGARA';

  @override
  String get tourContIntercontinentalPlayoff => 'PLAY-OFF ANTARA BENUA';

  @override
  String get tourContNoPlayoffThisCycle => 'Tiada play-off pada kitaran ini.';

  @override
  String get tourContPlayoffIntro =>
      'Dua tempat Kejohanan Dunia ditentukan melalui kalah mati antara pasukan terbaik yang hampir layak.';

  @override
  String get tourContPlayoffThrough =>
      'Anda berjaya melepasi play-off. Anda ke Kejohanan Dunia!';

  @override
  String get tourContPlayoffOut =>
      'Anda gagal dalam play-off. Tiada Kejohanan Dunia kali ini.';

  @override
  String get tourContContinue => 'Teruskan';

  @override
  String get tourContPlayoffFinals => 'FINAL PLAY-OFF';

  @override
  String get tourContPlayoffSeeded => 'Pilihan (bye)';

  @override
  String get tourCupTabSummary => 'RINGKASAN';

  @override
  String get tourCupTabQualifying => 'KELAYAKAN';

  @override
  String get tourCupTabPlayoff => 'PLAY-OFF';

  @override
  String get tourCupPlayoffSoon =>
      'Play-off antara benua ditentukan setelah kelayakan setiap konfederasi selesai.';

  @override
  String get tourCupTabFinals => 'PUSINGAN AKHIR';

  @override
  String get tourCupTabBracket => 'CARTA';

  @override
  String get tourCupTabAwards => 'ANUGERAH';

  @override
  String get tourCupTabScorers => 'PENJARING';

  @override
  String get tourCupTabHistory => 'SEJARAH';

  @override
  String get tourCupTabRecords => 'REKOD';

  @override
  String get tourCupTitle => 'KEJOHANAN DUNIA';

  @override
  String get tourCupNoData => 'Tiada data piala.';

  @override
  String tourCupLoadError(String error) {
    return 'Piala tidak dapat dimuatkan.\n$error';
  }

  @override
  String get tourCupUnknown => 'Tidak diketahui';

  @override
  String get tourCupWorldChampions => 'JUARA DUNIA';

  @override
  String get tourCupWorldChampionsTitle => 'Juara Dunia';

  @override
  String get tourCupStillActive => 'Masih aktif';

  @override
  String get tourCupAllTimeScorers => 'PENJARING SEPANJANG ZAMAN';

  @override
  String get tourCupAllConfederations => 'Semua konfederasi';

  @override
  String get tourCupBestRunnersUp => 'Naib juara terbaik';

  @override
  String get tourCupCompWorld => 'Kejohanan Dunia';

  @override
  String get tourCupCompEurope => 'Kejohanan Eropah';

  @override
  String get tourCupCompSAmerica => 'Piala Amerika Selatan';

  @override
  String get tourCupDestRoundOf16 => 'pusingan 16 terakhir';

  @override
  String get tourCupDestKnockouts => 'peringkat kalah mati';

  @override
  String get tourCupDestFinals => 'pusingan akhir';

  @override
  String get tourCupDestFinalsPlayoff => 'play-off pusingan akhir';

  @override
  String get tourCupDestIntercontPlayoff => 'play-off antara benua';

  @override
  String get tourCupFinalsDrawnAfterQual =>
      'Cabutan undian pusingan akhir dibuat setelah kelayakan tamat.';

  @override
  String get tourCupFinalsDrawSoon =>
      'Kumpulan belum dicabut. Tonton cabutan undian Kejohanan Dunia dari hab untuk mendedahkannya.';

  @override
  String tourCupGroupName(String name) {
    return 'Kumpulan $name';
  }

  @override
  String tourCupGroupNameShort(String name) {
    return 'Kumpulan $name';
  }

  @override
  String tourCupHostLabel(String host) {
    return 'Tuan rumah: $host';
  }

  @override
  String tourCupHostLabelMulti(String hosts) {
    return 'Tuan rumah: $hosts';
  }

  @override
  String get tourCupIntercontPlayoff => 'Play-off antara benua';

  @override
  String get tourCupKnockoutSoon =>
      'Carta kalah mati bermula setelah peringkat kumpulan tamat.';

  @override
  String get tourCupMatches => 'PERLAWANAN';

  @override
  String get tourCupMedalTable => 'JADUAL PINGAT';

  @override
  String get tourCupMostTitles => 'KEJUARAAN TERBANYAK';

  @override
  String tourCupMostTitlesValue(String nation, int titles, int editions) {
    return '$nation: $titles kejuaraan daripada $editions edisi';
  }

  @override
  String get tourCupNoGoals => 'Belum ada gol.';

  @override
  String get tourCupNoGroups => 'Tiada kumpulan dicabut.';

  @override
  String get tourCupNoHistory => 'Belum ada sejarah.';

  @override
  String get tourCupPastWinners => 'JUARA TERDAHULU';

  @override
  String get tourCupPlayoffIntro =>
      'Dua tempat Kejohanan Dunia ditentukan melalui kalah mati antara pasukan terbaik yang hampir layak.';

  @override
  String tourCupPlayoffNoEntrants(String confederation) {
    return '$confederation tiada play-off: semua tempatnya ditentukan dalam kumpulan kelayakan.';
  }

  @override
  String get tourCupQualDrawSoon =>
      'Kumpulan belum dicabut. Tonton cabutan undian kelayakan dari hab untuk mendedahkannya.';

  @override
  String tourCupRegionYours(String region) {
    return '$region · anda';
  }

  @override
  String tourCupScorePens(int home, int away) {
    return '$home–$away (pen)';
  }

  @override
  String get tourCupSegAllTime => 'Sepanjang zaman';

  @override
  String get tourCupSegFinals => 'Pusingan akhir';

  @override
  String get tourCupSegQualifying => 'Kelayakan';

  @override
  String get playerTraitsTitle => 'DIKENALI KERANA';

  @override
  String get traitBigGame => 'Pemain perlawanan besar';

  @override
  String get traitBigGameBlurb =>
      'Meningkatkan permainannya dalam perlawanan kalah mati.';

  @override
  String get traitSetPiece => 'Pakar bola mati';

  @override
  String get traitSetPieceBlurb =>
      'Hantaran lebih baik, dan lebih banyak gol daripada bola mati.';

  @override
  String get traitHothead => 'Panas baran';

  @override
  String get traitHotheadBlurb =>
      'Menerima jauh lebih banyak kad daripada rakan sepasukannya.';

  @override
  String get traitIronMan => 'Manusia besi';

  @override
  String get traitIronManBlurb => 'Jarang cedera dan lebih lambat letih.';

  @override
  String get traitWonderkid => 'Bakat luar biasa';

  @override
  String get traitWonderkidBlurb =>
      'Muda, sudah bagus, dan masih berkembang pesat.';

  @override
  String get traitLeader => 'Pemimpin';

  @override
  String get traitLeaderBlurb =>
      'Menaikkan semangat setiap rakan sepasukan di padang.';

  @override
  String get traitPacey => 'Pantas';

  @override
  String get traitPaceyBlurb =>
      'Kepantasan luar biasa, ancaman di belakang pertahanan.';

  @override
  String get traitOldHead => 'Veteran bijak';

  @override
  String get traitOldHeadBlurb =>
      'Pemain veteran yang membaca permainan lebih baik daripada kakinya mampu berlari.';

  @override
  String get traitWasteful => 'Membazir peluang';

  @override
  String get traitWastefulBlurb => 'Terlalu banyak peluang baik dilepaskan.';

  @override
  String get objectiveWorldCup => 'Kejohanan Dunia';

  @override
  String get objectiveWinTournament => 'Menjuarainya';

  @override
  String get objectiveQualifyGeneric => 'Layak';

  @override
  String hubBoardObjectiveFor(String competition, String label) {
    return '$competition: $label';
  }

  @override
  String get objectiveWinWorldCup => 'Menangi Kejohanan Dunia';

  @override
  String get objectiveReachFinal => 'Mara ke final';

  @override
  String get objectiveReachSemis => 'Mara ke separuh akhir';

  @override
  String get objectiveReachQuarters => 'Mara ke suku akhir';

  @override
  String get objectiveReachKnockouts => 'Mara ke peringkat kalah mati';

  @override
  String get objectiveQualify => 'Layak ke Kejohanan Dunia';

  @override
  String get finishChampions => 'Juara';

  @override
  String get finishRunnersUp => 'Naib juara';

  @override
  String get finishSemiFinals => 'Separuh akhir';

  @override
  String get finishQuarterFinals => 'Suku akhir';

  @override
  String get finishRoundOf16 => 'Pusingan 16 terakhir';

  @override
  String get finishGroupStage => 'Peringkat kumpulan';

  @override
  String get objectiveQualifyingTopHalf =>
      'Tamat di separuh atas kumpulan kelayakan';

  @override
  String get finishQualifyingTopHalf => 'Separuh atas kumpulan kelayakan';

  @override
  String get finishQualifyingBottomHalf => 'Separuh bawah kumpulan kelayakan';

  @override
  String get objectiveNcWinIt => 'Menangi Piala Negara-Negara';

  @override
  String get objectiveNcReachFinal => 'Mara ke final Piala Negara-Negara';

  @override
  String get objectiveNcFinalsFour => 'Mara ke Final Empat';

  @override
  String get objectiveNcWinGroup => 'Juarai kumpulan dan naik liga';

  @override
  String get objectiveNcTopHalf => 'Tamat di separuh atas kumpulan';

  @override
  String get objectiveNcSurvive => 'Elak tersingkir liga';

  @override
  String get objectiveNcOffTheBottom =>
      'Elak tamat di tangga tercorot kumpulan';

  @override
  String get finishNcChampions => 'Juara Piala Negara-Negara';

  @override
  String get finishNcFinalsFour => 'Final Empat';

  @override
  String get finishNcGroupWinners => 'Juara kumpulan';

  @override
  String get finishNcTopHalf => 'Separuh atas kumpulan';

  @override
  String get finishNcStayedUp => 'Kekal dalam liga';

  @override
  String get finishNcClearOfBottom => 'Mengelak tangga tercorot kumpulan';

  @override
  String get finishNcBottom => 'Tercorot dalam kumpulan';

  @override
  String get careerNationsCupLabel => 'Piala Negara-Negara';

  @override
  String get squadDevPlayer => 'PEMAIN';

  @override
  String get squadDevAge => 'UMUR';

  @override
  String get squadDevPosition => 'POS';

  @override
  String get squadDevChange => 'PENARAFAN';

  @override
  String get squadDevNew => 'BAHARU';

  @override
  String get squadDevRetired => 'BERSARA';

  @override
  String get squadDevEmpty => 'Tahun yang stabil. Tiada perubahan dalam skuad.';

  @override
  String get squadDevTierRegulars => 'PEMAIN TETAP';

  @override
  String get squadDevTierFringe => 'PINGGIRAN';

  @override
  String get squadDevTierYouth => 'BELIA';

  @override
  String get boardObjectivesTitle => 'Objektif lembaga';

  @override
  String get boardObjectivesConfidence => 'Keyakinan lembaga';

  @override
  String boardObjectiveBeatenBy(String result, int rounds) {
    String _temp0 = intl.Intl.pluralLogic(
      rounds,
      locale: localeName,
      other: '$rounds pusingan lebih baik daripada sasaran',
      one: 'satu pusingan lebih baik daripada sasaran',
    );
    return '$result: $_temp0';
  }

  @override
  String boardObjectiveShortBy(String result, int rounds) {
    String _temp0 = intl.Intl.pluralLogic(
      rounds,
      locale: localeName,
      other: 'kurang $rounds pusingan',
      one: 'kurang satu pusingan',
    );
    return '$result: $_temp0';
  }

  @override
  String get boardObjectivesPending => 'BELUM DITENTUKAN';

  @override
  String boardObjectiveSoFar(String result) {
    return 'SETAKAT INI · $result';
  }

  @override
  String get boardObjectivesEmpty =>
      'Lembaga belum menetapkan objektif untuk kitaran ini.';

  @override
  String get tourContBestWinners => 'JUARA KUMPULAN TERBAIK';

  @override
  String get tourContBestThirds => 'TEMPAT KETIGA TERBAIK';

  @override
  String tourContBestPlaced(String position) {
    return 'TEMPAT KE-$position TERBAIK';
  }

  @override
  String squadDevPageOf(String page, String pages, String total) {
    return '$page/$pages · $total pemain';
  }

  @override
  String get matchSoldOut => 'HABIS DIJUAL';

  @override
  String matchAttendanceOf(String attendance, String capacity) {
    return '$attendance daripada $capacity tempat duduk dipenuhi';
  }

  @override
  String get matchGroundTitle => 'STADIUM';

  @override
  String get absenceInjured => 'Cedera';

  @override
  String get absenceSuspended => 'Digantung';

  @override
  String absenceWeeks(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString minggu',
      one: '1 minggu',
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
      other: '$countString perlawanan',
      one: '1 perlawanan',
    );
    return '$_temp0';
  }

  @override
  String absenceBackFor(String opponent) {
    return 'Kembali untuk $opponent';
  }

  @override
  String get penaltyOrderTitle => 'Penalti';

  @override
  String get penaltyOrderBlurb =>
      'Namakan lima penyepak anda, mengikut urutan. Ketik slot untuk menukarnya.';

  @override
  String penaltyOrderPick(int number) {
    return 'Sepakan $number';
  }

  @override
  String get penaltyOrderPickBlurb =>
      'Pilih siapa yang tampil. Bar menunjukkan ketenangan mereka di titik penalti.';

  @override
  String get penaltyOrderConfirm => 'Mulakan';

  @override
  String get penaltyOrderCancel => 'Kembali';

  @override
  String get youthTitle => 'Belia';

  @override
  String get youthEmptyLevel => 'Belum ada sesiapa di peringkat ini.';

  @override
  String get youthReleased => 'Dilepaskan tahun ini';

  @override
  String get u21Title => 'B-21';

  @override
  String get u21Blurb =>
      'Generasi seterusnya, prospek terbaik dahulu. Bintang berongga ialah anggaran pencari bakat. Panggil pemain ke pasukan untuk mengetahui kemampuan sebenarnya.';

  @override
  String get u21Empty =>
      'Tiada pemain bawah 21 tahun dalam senarai sekarang. Pengambilan seterusnya tiba bersama kitaran baharu.';

  @override
  String u21Breakout(int gain) {
    return '+$gain TAHUN INI';
  }

  @override
  String u21AgeCaps(int age, int caps) {
    return 'Umur $age · $caps penampilan';
  }

  @override
  String u21AgeUncapped(int age) {
    return 'Umur $age · belum beraksi';
  }

  @override
  String get u21CallUps => 'Ke panggilan skuad';

  @override
  String get youthWatching => 'Dipantau';

  @override
  String get youthWatchEmpty =>
      'Belum ada yang ditanda. Tanda seorang pemain muda di mana-mana peringkat dan dia akan muncul di sini, bersama perkembangannya sejak itu.';

  @override
  String get youthWatchMark => 'Pantau pemain ini';

  @override
  String get youthWatchUnmark => 'Berhenti memantau';

  @override
  String youthWatchMarked(int rating, int age) {
    return 'Ditanda pada $rating, umur $age';
  }

  @override
  String get youthWatchSenior => 'Naik ke senarai senior';

  @override
  String get youthWatchReleased => 'Dilepaskan oleh akademi';

  @override
  String get youthWatchGone => 'Tiada lagi dalam piramid';

  @override
  String get tacticsYouth => 'B-21';

  @override
  String get pressSquad => 'Skuad';

  @override
  String get pressBoard => 'Lembaga';

  @override
  String get pressNoEffect => 'Tiada siapa mengambil berat';

  @override
  String get matchNeutralGround => 'NEUTRAL';

  @override
  String get matchExtraTimeAhead => 'MASA TAMBAHAN';

  @override
  String get matchExtraTimeHalf => 'MASA TAMBAHAN · SEPARUH MASA';

  @override
  String get matchClockFullTime => 'TAMAT';

  @override
  String get matchClockAfterExtraTime => 'SELEPAS MASA TAMBAHAN';

  @override
  String get matchClockPenalties => 'PENALTI';

  @override
  String get matchClockFullTimePenalties => 'TAMAT · PENALTI';

  @override
  String get hubEventPressConference => 'Hadapi media';

  @override
  String get hubEventPressConferenceSub =>
      'Media dunia mahu bercakap sebelum perlawanan pertama anda';

  @override
  String get squadDevWonderkid => 'BAKAT LUAR BIASA';

  @override
  String get tacticsPlaystyle => 'Gaya permainan';

  @override
  String get tacticsPlaystyleBlurb =>
      'Pilih cara pasukan bermain; dail di bawah memperhalusinya.';

  @override
  String get tacticsPlaystyleCustom =>
      'Tetapan anda sendiri. Tiada gaya bernama yang sepadan dengan dail ini.';

  @override
  String get playstyleCustom => 'Tersuai';

  @override
  String get playstyleBalanced => 'Seimbang';

  @override
  String get playstylePossession => 'Penguasaan bola';

  @override
  String get playstyleGegenpress => 'Gegenpress';

  @override
  String get playstyleCounter => 'Serangan balas';

  @override
  String get playstyleDirect => 'Terus';

  @override
  String get playstyleLowBlock => 'Benteng rendah';

  @override
  String get playstyleWingPlay => 'Permainan sayap';

  @override
  String get playstyleBalancedBlurb =>
      'Mantap di kedua-dua bahagian, tanpa berlebihan.';

  @override
  String get playstylePossessionBlurb =>
      'Kuasai bola, gerakkan dengan sabar, sempitkan ruang lawan.';

  @override
  String get playstyleGegenpressBlurb =>
      'Rampas semula bola sebaik sahaja hilang, jauh di kawasan lawan.';

  @override
  String get playstyleCounterBlurb =>
      'Tunggu di belakang, kekal padat, kemudian serang balas dengan pantas.';

  @override
  String get playstyleDirectBlurb =>
      'Hantar ke hadapan awal dan rebut bola kedua.';

  @override
  String get playstyleLowBlockBlurb =>
      'Dalam, sempit dan sangat sukar ditembusi.';

  @override
  String get playstyleWingPlayBlurb =>
      'Lebarkan padang, tembusi bahagian luar dan buat lintangan.';

  @override
  String get nationsRandomTeam => 'Pasukan rawak';

  @override
  String get nationsFromTheBottom => 'Dari bawah';

  @override
  String get bottomStartTitle => 'Tiada pekerjaan';

  @override
  String get bottomStartHeading => 'Tiga persatuan mahu berbincang';

  @override
  String get bottomStartBlurb =>
      'Anda tiada pekerjaan dan tiada reputasi. Hanya pasukan-pasukan ini sanggup mengambil risiko dengan anda. Terima satu dan bina sesuatu daripada kosong.';

  @override
  String get bottomStartAccept => 'Terima';

  @override
  String get bottomStartBack => 'Kembali ke menu';

  @override
  String bottomStartRankOf(int rank, int total) {
    return '$rank daripada $total di dunia';
  }

  @override
  String get campTitle => 'Kem pangkalan';

  @override
  String campBasedIn(String host) {
    return 'Berpangkalan di $host';
  }

  @override
  String get campBlurb =>
      'Tempat skuad tinggal sepanjang kejohanan. Ia tidak boleh ditukar setelah perlawanan bermula, dan ia mempengaruhi tiga perkara setiap perlawanan: sesegar mana mereka tiba, secepat mana kecederaan sembuh, dan setajam mana mereka.';

  @override
  String get campEffectTravel => 'Tiba segar';

  @override
  String get campEffectRecovery => 'Kecederaan sembuh';

  @override
  String get campEffectSharpness => 'Ketajaman perlawanan';

  @override
  String get campTerrainCity => 'Pusat bandar';

  @override
  String get campTerrainCoastal => 'Resort pantai';

  @override
  String get campTerrainMountain => 'Peranginan gunung';

  @override
  String get campTerrainAltitude => 'Kem tanah tinggi';

  @override
  String get campTerrainNationalCentre => 'Pusat kebangsaan';

  @override
  String get campTerrainCityBlurb =>
      'Semuanya dekat dan tiada perjalanan jauh, tetapi tiada ketenangan dan tiada lari daripada kebisingan.';

  @override
  String get campTerrainCoastalBlurb =>
      'Tenang, selesa dan baik untuk mood; perjalanan bas yang jauh ke setiap stadium.';

  @override
  String get campTerrainMountainBlurb =>
      'Udara sejuk dan kemudahan perubatan kelas pertama yang memulihkan kecederaan dengan cepat, jauh dari kejohanan.';

  @override
  String get campTerrainAltitudeBlurb =>
      'Sukar untuk berlatih, tetapi kaki yang bertahan hingga ke penghujung kejohanan.';

  @override
  String get campTerrainNationalCentreBlurb =>
      'Kemudahan persatuan sendiri: tiada yang hebat, tiada yang boleh tidak kena.';

  @override
  String get hubEventChooseCamp => 'Pilih kem pangkalan';

  @override
  String hubEventChooseCampSub(String host) {
    return 'Tempat skuad akan berpangkalan di $host';
  }

  @override
  String get tacticsTabBench => 'Simpanan';

  @override
  String get squadSearchHint => 'Cari mengikut nama atau kelab';

  @override
  String get squadFilterAll => 'Semua';

  @override
  String get squadFilterInSquad => 'Dalam skuad';

  @override
  String get squadFilterUncapped => 'Belum beraksi';

  @override
  String get squadFilterUnavailable => 'Tidak tersedia';

  @override
  String get squadLineAll => 'Semua barisan';

  @override
  String get squadSortBy => 'Isih';

  @override
  String get squadSortRating => 'Penarafan';

  @override
  String get squadSortCaps => 'Penampilan';

  @override
  String get squadSortGoals => 'Gol';

  @override
  String get squadSortAge => 'Umur';

  @override
  String get squadSortName => 'Nama';

  @override
  String get squadLegendTitle => 'Maksud tanda-tanda';

  @override
  String get squadLegendStarting => 'Dalam kesebelasan utama anda';

  @override
  String get squadLegendCalledUp => 'Dipanggil, di bangku simpanan';

  @override
  String get squadLegendRatingUp => 'Penarafan meningkat tahun ini';

  @override
  String get squadLegendRatingDown => 'Penarafan menurun tahun ini';

  @override
  String get squadLegendInjured => 'Cedera, tidak tersedia';

  @override
  String get squadLegendSuspended => 'Digantung, tidak tersedia';

  @override
  String get squadLegendTraits => 'DIKENALI KERANA';

  @override
  String squadShowingOf(int shown, int total) {
    return 'Menunjukkan $shown daripada $total pemain';
  }

  @override
  String get squadNobodyMatches =>
      'Tiada pemain dalam senarai yang sepadan dengan penapis itu.';

  @override
  String get squadStatPool => 'Senarai';

  @override
  String get squadStatInSquad => 'Dipanggil';

  @override
  String get squadMostCapped => 'Penampilan terbanyak';

  @override
  String get squadTopScorer => 'Penjaring terbanyak';

  @override
  String squadCapsValue(String name, int caps) {
    return '$name · $caps penampilan';
  }

  @override
  String squadGoalsValue(String name, int goals) {
    return '$name · $goals gol';
  }

  @override
  String squadAgeClub(int age, String club) {
    return '$age · $club';
  }

  @override
  String get squadCapsShort => 'Pnp';

  @override
  String get squadGoalsShort => 'Gol';

  @override
  String get recordsRecordBookSubtitle =>
      'Penampilan, gol dan rekod utama pasukan';

  @override
  String get statsLegacy => 'LEGASI';

  @override
  String tacticsSubAlreadyOff(String name) {
    return '$name sudah dikeluarkan dan tidak boleh masuk semula.';
  }

  @override
  String tacticsSubSentOff(String name) {
    return '$name telah dibuang padang dan tidak boleh bermain lagi.';
  }

  @override
  String get tacticsInjuredShort => 'CEDERA';

  @override
  String get tacticsSuspendedShort => 'DIGANTUNG';

  @override
  String get confEurope => 'Eropah';

  @override
  String get confSouthAmerica => 'Amerika Selatan';

  @override
  String get confNorthAmerica => 'Amerika Utara';

  @override
  String get confAfrica => 'Afrika';

  @override
  String get confAsia => 'Asia';

  @override
  String get confOceania => 'Oceania';

  @override
  String get compWorldCup => 'Kejohanan Dunia';

  @override
  String get compWorldCupFinals => 'Pusingan Akhir Kejohanan Dunia';

  @override
  String get compWorldCupQualifying => 'Kelayakan Kejohanan Dunia';

  @override
  String compQualifiers(String region) {
    return 'Kelayakan $region';
  }

  @override
  String get compFriendlies => 'Perlawanan Persahabatan';

  @override
  String get compNationsCup => 'Piala Negara-Negara';

  @override
  String get compContinentalClash => 'Pertembungan Benua';

  @override
  String get compIntercontinentalPlayoff => 'Play-off Antara Benua';

  @override
  String get compContinentalChampionship => 'Kejohanan Benua';

  @override
  String get compEuropeanChampionship => 'Kejohanan Eropah';

  @override
  String get compSouthAmericaCup => 'Piala Amerika Selatan';

  @override
  String get compAfricanChampionship => 'Kejohanan Afrika';

  @override
  String get compAsianChampionship => 'Kejohanan Asia';

  @override
  String get compNorthAmericaCup => 'Piala Amerika Utara';

  @override
  String get compOceaniaCup => 'Piala Oceania';

  @override
  String get msgANation => 'Sebuah negara';

  @override
  String get msgAPlayer => 'Seorang pemain';

  @override
  String get msgAHostNation => 'negara tuan rumah';

  @override
  String get msgCycleTitle1 => 'Kitaran baharu bermula';

  @override
  String msgCycleTitle2(int year) {
    return 'Jalan menuju $year dibuka';
  }

  @override
  String get msgCycleTitle3 => 'Kempen baharu bermula';

  @override
  String get msgCycleTitle4 => 'Kembali bekerja';

  @override
  String msgCycleBody1(int year) {
    return 'Perjalanan menuju Kejohanan Dunia $year bermula di sini.';
  }

  @override
  String msgCycleBody2(int year) {
    return 'Kitaran baharu. Kejohanan Dunia $year menjadi sasaran.';
  }

  @override
  String msgCycleBody3(int year) {
    return 'Empat tahun menuju Kejohanan Dunia $year. Kerja bermula sekarang.';
  }

  @override
  String msgCycleBody4(int year) {
    return 'Kempen $year bermula hari ini.';
  }

  @override
  String msgContHostTitle(String cup, String host) {
    return 'Tuan rumah $cup: $host';
  }

  @override
  String msgContHostBody(String host, String cup) {
    return '$host akan menjadi tuan rumah $cup akan datang.';
  }

  @override
  String msgContQualDrawTitle(String cup) {
    return 'Cabutan undian kelayakan $cup';
  }

  @override
  String msgContQualDrawBody(String cup) {
    return 'Kumpulan kelayakan $cup telah dicabut.';
  }

  @override
  String msgWcHostTitle(String host, int year) {
    return 'Tuan rumah Kejohanan Dunia $year: $host';
  }

  @override
  String msgWcHostBody(String host, int year) {
    return '$host akan menjadi tuan rumah Kejohanan Dunia $year.';
  }

  @override
  String get msgWcQualDrawTitle => 'Cabutan undian kelayakan Kejohanan Dunia';

  @override
  String get msgWcQualDrawBody =>
      'Kumpulan kelayakan Kejohanan Dunia telah dicabut.';

  @override
  String msgContFinalsDrawTitle(String cup) {
    return 'Cabutan undian pusingan akhir $cup';
  }

  @override
  String msgContFinalsDrawBody(String cup) {
    return 'Kumpulan pusingan akhir $cup telah dicabut.';
  }

  @override
  String get msgWcFinalsDrawTitle =>
      'Cabutan undian pusingan akhir Kejohanan Dunia';

  @override
  String msgWcFinalsDrawBody(int year) {
    return 'Cabutan undian pusingan akhir Kejohanan Dunia $year telah dibuat.';
  }

  @override
  String get msgQualWcTitle1 => 'Layak ke Kejohanan Dunia';

  @override
  String get msgQualWcTitle2 => 'Tiket Kejohanan Dunia diraih';

  @override
  String get msgQualWcTitle3 => 'Kita ke Kejohanan Dunia';

  @override
  String get msgQualWcTitle4 => 'Tiket sudah di tangan';

  @override
  String msgQualWcBody1(int year) {
    return 'Anda telah layak ke pusingan akhir Kejohanan Dunia $year.';
  }

  @override
  String msgQualWcBody2(int year) {
    return 'Rasmi: negara anda akan beraksi di Kejohanan Dunia $year.';
  }

  @override
  String msgQualWcBody3(int year) {
    return 'Tempat di Kejohanan Dunia $year telah dipastikan.';
  }

  @override
  String msgQualWcBody4(int year) {
    return 'Anda mara ke pusingan akhir Kejohanan Dunia $year.';
  }

  @override
  String msgQualContTitle1(String cup) {
    return 'Layak ke $cup';
  }

  @override
  String msgQualContTitle2(String cup) {
    return 'Tiket $cup diraih';
  }

  @override
  String msgQualContTitle3(String cup) {
    return 'Layak ke $cup';
  }

  @override
  String msgQualContBody1(String cup) {
    return 'Anda telah layak ke pusingan akhir $cup.';
  }

  @override
  String msgQualContBody2(String cup) {
    return 'Negara anda telah memastikan tempat di $cup.';
  }

  @override
  String msgQualContBody3(String cup) {
    return 'Anda mara ke $cup.';
  }

  @override
  String msgChampTitleMine1(String comp) {
    return 'JUARA $comp!';
  }

  @override
  String msgChampTitleMine2(String comp) {
    return 'Juara $comp!';
  }

  @override
  String msgChampTitleMine3(String comp) {
    return 'Anda menjuarai $comp!';
  }

  @override
  String msgChampTitleOther1(String comp) {
    return '$comp sudah ditentukan';
  }

  @override
  String msgChampTitleOther2(String comp) {
    return 'Juara $comp dinobatkan';
  }

  @override
  String msgChampTitleOther3(String comp) {
    return '$comp sudah dimenangi';
  }

  @override
  String msgChampBodyMine1(String comp, String loser, String result, int year) {
    return 'Negara anda juara $comp $year, menewaskan $loser$result.';
  }

  @override
  String msgChampBodyMine2(String comp, String loser, String result, int year) {
    return 'Anda menjuarai $comp $year, menundukkan $loser$result.';
  }

  @override
  String msgChampBodyMine3(String comp, String loser, String result, int year) {
    return '$comp $year milik anda. $loser ditewaskan$result.';
  }

  @override
  String msgChampBodyOther1(
    String winner,
    String comp,
    String loser,
    String result,
    int year,
  ) {
    return '$winner menjuarai $comp $year, menewaskan $loser$result.';
  }

  @override
  String msgChampBodyOther2(
    String winner,
    String comp,
    String loser,
    String result,
    int year,
  ) {
    return '$winner juara $comp $year, menumpaskan $loser$result.';
  }

  @override
  String msgFinalScoreSuffix(int home, int away) {
    return ' $home–$away di final';
  }

  @override
  String msgFinalPensSuffix(int home, int away) {
    return ' melalui penalti, selepas final $home–$away';
  }

  @override
  String get msgWpotyTitle => 'Pemain Terbaik Dunia';

  @override
  String msgWpotyBodyMine(String name, String nation, int year) {
    return '$name ($nation) dinobatkan Pemain Terbaik Dunia $year, salah seorang pemain anda.';
  }

  @override
  String msgWpotyBodyOther(String name, String nation, int year) {
    return '$name ($nation) dinobatkan Pemain Terbaik Dunia $year.';
  }

  @override
  String get msgYpotTitle => 'Pemain Muda Terbaik Kejohanan';

  @override
  String msgYpotBodyMine(String name, String nation, int age, int year) {
    return '$name ($nation), berusia $age, dinobatkan Pemain Muda Terbaik Kejohanan $year, salah seorang pemain anda.';
  }

  @override
  String msgYpotBodyOther(String name, String nation, int age, int year) {
    return '$name ($nation), berusia $age, dinobatkan Pemain Muda Terbaik Kejohanan $year.';
  }

  @override
  String msgRankHold1(int rank) {
    return 'Anda kekal di #$rank.';
  }

  @override
  String msgRankHold2(int rank) {
    return 'Tiada perubahan, masih #$rank.';
  }

  @override
  String msgRankHold3(int rank) {
    return 'Stabil di #$rank.';
  }

  @override
  String msgRankUp1(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move anak tangga',
    );
    return 'Naik $_temp0 keseluruhannya, ke #$rank.';
  }

  @override
  String msgRankUp2(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move anak tangga',
    );
    return 'Lonjakan $_temp0 membawa anda ke #$rank.';
  }

  @override
  String msgRankUp3(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move anak tangga',
    );
    return 'Naik $_temp0, kini #$rank.';
  }

  @override
  String msgRankDown1(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move anak tangga',
    );
    return 'Turun $_temp0 keseluruhannya, ke #$rank.';
  }

  @override
  String msgRankDown2(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move anak tangga',
    );
    return 'Kemerosotan $_temp0 menjatuhkan anda ke #$rank.';
  }

  @override
  String msgRankDown3(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move anak tangga',
    );
    return 'Turun $_temp0, kini #$rank.';
  }

  @override
  String get msgRankLeadYou => 'Anda di puncak dunia.';

  @override
  String msgRankLeadOther(String nation) {
    return '$nation di puncak dunia.';
  }

  @override
  String msgRankTitle(int rank) {
    return 'Ranking dunia · #$rank';
  }

  @override
  String msgRankBody(String lead, String movement) {
    return 'Ranking dunia telah dikemas kini. $lead $movement';
  }

  @override
  String msgRankJumpTitleUp(int rank) {
    return 'Naik ke #$rank';
  }

  @override
  String msgRankJumpTitleDown(int rank) {
    return 'Jatuh ke #$rank';
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
      other: '$move anak tangga',
    );
    return '$tournament telah menggerakkan ranking dunia. $nation masuk di #$from dan keluar di #$to, naik $_temp0.';
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
      other: '$move anak tangga',
    );
    return '$tournament telah menggerakkan ranking dunia. $nation masuk di #$from dan keluar di #$to, turun $_temp0.';
  }

  @override
  String get rankingSinceWcDraw => 'Sejak cabutan undian Kejohanan Dunia';

  @override
  String get rankingSinceCycleStart => 'Sejak kempen bermula';

  @override
  String rankingMovedFromTo(int from, int now) {
    return '#$from ke #$now';
  }

  @override
  String msgCapsTitle(String name, int count) {
    return '$name mencapai $count penampilan';
  }

  @override
  String msgCapsBody(String name, int count) {
    return '$name kini telah beraksi sebanyak $count kali untuk negara anda.';
  }

  @override
  String msgGoalsTitle(String name, int count) {
    return '$name mencapai $count gol';
  }

  @override
  String msgGoalsBody(String name, int count) {
    return '$name telah menjaringkan $count gol antarabangsa untuk negara anda.';
  }

  @override
  String msgDevTitle(int year) {
    return 'Perkembangan skuad · $year';
  }

  @override
  String msgThroughTitle(int year) {
    return 'Lepasan akademi · $year';
  }

  @override
  String get msgThroughNote =>
      'Ini bukan pengambilan baharu. Mereka ialah budak-budak yang masuk pada usia sebelas tahun dan kini telah meningkat ke senarai senior.';

  @override
  String msgNewFacesTitle(int year) {
    return 'Wajah baharu · $year';
  }

  @override
  String get msgIntakeNoteAcademy =>
      'Pelaburan akademi menampakkan hasil: pengambilan ini tiba lebih kuat daripada sepatutnya.';

  @override
  String get msgIntakeNoteStanding =>
      'Negara sedang memerhati pasukan ini: dengan pasukan mendaki ranking dunia, budak-budak terbaik memilih bola sepak, dan pengambilan ini tiba lebih kuat kerananya.';

  @override
  String get msgIntakeNoteBoth =>
      'Wang akademi dan kebangkitan pasukan dalam ranking dunia kedua-duanya menampakkan hasil: pengambilan ini tiba lebih kuat daripada sepatutnya.';

  @override
  String msgIntakeTitle(int year) {
    return 'Pengambilan akademi · $year';
  }

  @override
  String msgRetireCaptainTitle(String name) {
    return 'Kapten anda $name bersara';
  }

  @override
  String msgRetireTitle(String name) {
    return '$name bersara daripada bola sepak antarabangsa';
  }

  @override
  String msgRetireBody(String name, int age) {
    return '$name telah bersara daripada bola sepak antarabangsa pada usia $age.';
  }

  @override
  String msgRetireBodyWith(String name, String tally, int age) {
    return '$name telah bersara daripada bola sepak antarabangsa pada usia $age, mengucapkan selamat tinggal dengan $tally.';
  }

  @override
  String msgTallyCaps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count penampilan',
    );
    return '$_temp0';
  }

  @override
  String msgTallyGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gol',
    );
    return '$_temp0';
  }

  @override
  String get msgArmbandVacant =>
      ' Lilitan kapten kini kosong. Namakan kapten baharu dari skrin panggilan skuad.';

  @override
  String msgHofTitle(String name) {
    return '$name dimasukkan ke Dewan Kemasyhuran';
  }

  @override
  String msgHofBody(String name, int caps, int goals) {
    return '$name menyertai Dewan Kemasyhuran negara anda ($caps penampilan, $goals gol). Lihat di Legenda.';
  }

  @override
  String hubBanTitle(String name) {
    return '$name digantung';
  }

  @override
  String hubBanBody(String name, String how, int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: '$matches perlawanan seterusnya',
    );
    return '$name $how dan digantung untuk $_temp0. Dia tidak boleh dipilih.';
  }

  @override
  String get hubBanHowSecondYellow => 'dibuang padang kerana kad kuning kedua';

  @override
  String get hubBanHowViolent =>
      'menerima kad merah terus kerana kelakuan ganas';

  @override
  String get hubBanHowRed => 'dibuang padang';

  @override
  String hubInjuryTitle(String name) {
    return '$name cedera';
  }

  @override
  String hubInjuryBody(String name, int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: '$matches perlawanan',
    );
    return '$name mengalami kecederaan dan tidak dapat bermain untuk $_temp0.';
  }

  @override
  String get hubRunnerUpTitle1 => 'Naib juara';

  @override
  String get hubRunnerUpTitle2 => 'Begitu dekat, namun begitu jauh';

  @override
  String get hubRunnerUpTitle3 => 'Pingat perak';

  @override
  String hubRunnerUpBody1(String cup, String opponent) {
    return 'Anda mara ke final $cup tetapi tewas kepada $opponent. Begitu hampir. Perak kali ini.';
  }

  @override
  String hubRunnerUpBody2(String cup, String opponent) {
    return 'Ditewaskan oleh $opponent di final $cup. Naib juara, begitu hampir sekali.';
  }

  @override
  String hubRunnerUpBody3(String cup, String opponent) {
    return 'Final $cup terlepas ke tangan $opponent. Banyak yang boleh dibanggakan, tetapi bukan trofi.';
  }

  @override
  String get hubKnockedOutTitle1 => 'Tersingkir';

  @override
  String get hubKnockedOutTitle2 => 'Penghujung jalan';

  @override
  String get hubKnockedOutTitle3 => 'Perjalanan tamat';

  @override
  String hubKnockedOutBody1(String cup, String opponent, String stage) {
    return 'Anda tersingkir dari $cup, ditewaskan oleh $opponent di $stage.';
  }

  @override
  String hubKnockedOutBody2(String cup, String opponent, String stage) {
    return '$opponent menamatkan perjalanan $cup anda di $stage.';
  }

  @override
  String hubKnockedOutBody3(String cup, String opponent, String stage) {
    return 'Perjalanan $cup anda berakhir di $stage, ditewaskan oleh $opponent.';
  }

  @override
  String get hubGroupExitTitle1 => 'Tersingkir di peringkat kumpulan';

  @override
  String get hubGroupExitTitle2 => 'Terkandas di peringkat kumpulan';

  @override
  String get hubGroupExitTitle3 => 'Pulang awal';

  @override
  String hubGroupExitBody1(String cup) {
    return 'Perjalanan $cup anda tamat di peringkat kumpulan. Tidak cukup untuk mara ke kalah mati.';
  }

  @override
  String hubGroupExitBody2(String cup) {
    return 'Anda gagal keluar dari kumpulan. Perjalanan $cup anda berakhir di sini.';
  }

  @override
  String hubGroupExitBody3(String cup) {
    return 'Tiada tempat kalah mati kali ini. Perjalanan $cup anda tamat di peringkat kumpulan.';
  }

  @override
  String boardObjectiveMetTitle(String comp) {
    return 'Objektif tercapai: $comp';
  }

  @override
  String boardObjectiveMissedTitle(String comp) {
    return 'Objektif gagal: $comp';
  }

  @override
  String boardObjectiveMetBody(String comp, String demand, String finish) {
    return 'Sasaran lembaga di $comp: $demand. Pencapaian anda: $finish. Mereka mendapat apa yang diminta.';
  }

  @override
  String boardObjectiveMissedBody(String comp, String demand, String finish) {
    return 'Sasaran lembaga di $comp: $demand. Pencapaian anda: $finish. Itu di bawah jangkaan.';
  }

  @override
  String get newsWcMissTitle => 'Impian Kejohanan Dunia berakhir';

  @override
  String newsWcMissBody(int year) {
    return 'Anda tidak layak ke Kejohanan Dunia $year. Kempen kelayakan tidak mencukupi. Empat tahun lagi.';
  }

  @override
  String get newsRecordScorerTitle => 'Penjaring terbanyak sepanjang zaman';

  @override
  String newsRecordScorerBody(String name, int goals) {
    return '$name kini penjaring terbanyak sepanjang zaman dengan $goals gol.';
  }

  @override
  String get newsRecordCapsTitle => 'Pemain dengan penampilan terbanyak';

  @override
  String newsRecordCapsBody(String name, int caps) {
    return '$name kini pemain dengan penampilan terbanyak, iaitu $caps penampilan.';
  }

  @override
  String get newsARecordBreaker => 'Pemecah rekod baharu';

  @override
  String newsTransferTitle(String name, String club) {
    return '$name menyertai $club';
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
    return '$name ($position, $rating) telah meninggalkan $fromClub untuk menyertai $destination dengan bayaran $fee.';
  }

  @override
  String newsTransferAbroad(String club, String country) {
    return '$club di $country';
  }

  @override
  String get newsTransferFree => 'Percuma';

  @override
  String newsNatzStarTitle(String name, String nation) {
    return '$name sanggup bertukar ke $nation!';
  }

  @override
  String newsNatzTitle(String name, String nation) {
    return '$name mahu bermain untuk $nation';
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
    return '$name, $position berusia $age tahun dengan penarafan $rating yang kini bersama $fromNation, mempunyai hubungan keluarga dengan $nation dan terbuka untuk bertukar. Buka tawaran Naturalisasi untuk menerima atau menolak.';
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
    return '$name, $position berusia $age tahun dengan penarafan $rating yang kini bersama $fromNation, ialah nama besar yang mempunyai hubungan keluarga dengan $nation dan terbuka untuk bertukar. Buka tawaran Naturalisasi untuk menerima atau menolak.';
  }

  @override
  String get newsTheirNation => 'negara mereka';

  @override
  String get newsYourNation => 'negara anda';

  @override
  String get tourStatusChampions => 'JUARA';

  @override
  String get tourStatusFinals => 'PUSINGAN AKHIR';

  @override
  String get tourStatusQualifying => 'KELAYAKAN';

  @override
  String get tourStatusUpcoming => 'AKAN DATANG';

  @override
  String get tourStatusInProgress => 'SEDANG BERLANGSUNG';

  @override
  String get tourStatusComingSoon => 'AKAN DATANG';

  @override
  String get tourStatusDecided => 'SELESAI';

  @override
  String tourStatusLeague(String letter) {
    return 'LIGA $letter';
  }

  @override
  String get tourDrawWcQualifying => 'CABUTAN KELAYAKAN DUNIA';

  @override
  String tourDrawContQualifying(String cup) {
    return 'CABUTAN KELAYAKAN $cup';
  }

  @override
  String get tourDrawWcHost => 'TUAN RUMAH KEJOHANAN DUNIA';

  @override
  String tourDrawContHost(String cup) {
    return 'TUAN RUMAH $cup';
  }

  @override
  String get tourDrawHostsReveal => 'Dan tuan rumahnya ialah…';

  @override
  String get tourDrawHostReveal => 'Dan tuan rumahnya ialah…';

  @override
  String get tourDrawHostCandidates => 'Calon-calon yang bersaing:';

  @override
  String get tourKickoffContinentalCup => 'PIALA BENUA';

  @override
  String tourHostCompetitionYear(String competition, int year) {
    return '$competition $year';
  }

  @override
  String newsContMissTitle(String cup) {
    return 'Gagal ke $cup';
  }

  @override
  String newsContMissBody(String cup) {
    return 'Anda tidak layak ke $cup. Kempen kali ini tidak mencukupi.';
  }

  @override
  String get potyLabelBest => 'Pemain Terbaik Tahunan';

  @override
  String get potyLabelYoung => 'Pemain Muda Terbaik Tahunan';

  @override
  String potyTallyAssists(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bantuan',
    );
    return '$_temp0';
  }

  @override
  String potyOverallValue(int value) {
    return 'Penarafan $value';
  }

  @override
  String potyRatingValue(String value) {
    return 'Markah $value';
  }

  @override
  String newsPotyTitle(int year) {
    return 'Pemain Terbaik Dunia $year';
  }

  @override
  String newsPotyBody(String name) {
    return '$name ialah pemain terbaik dunia tahun ini.';
  }

  @override
  String newsPotyYoungSuffix(String name) {
    return ' $name memenangi anugerah pemain muda.';
  }

  @override
  String newsWatchTitle(int year) {
    return 'Pemain muda yang anda pantau, $year';
  }

  @override
  String newsWatchJump(String name, int rating, int gain) {
    String _temp0 = intl.Intl.pluralLogic(
      gain,
      locale: localeName,
      other: '$gain mata',
    );
    return '$name telah meningkat ke $rating, naik $_temp0 berbanding tahun lalu.';
  }

  @override
  String newsWatchBand(String name, String band) {
    return '$name naik ke kategori $band.';
  }

  @override
  String newsWatchDebutTitle(String name) {
    return '$name membuat penampilan sulung';
  }

  @override
  String newsWatchDebutBody(String name, int age, int rating) {
    return '$name meraih penampilan pertamanya pada usia $age, dengan penarafan $rating. Salah seorang pemain muda yang anda pantau.';
  }

  @override
  String get matchStatsAtFullTime =>
      'Penguasaan bola, penarafan pemain dan pemain terbaik perlawanan ditentukan pada wisel penamat.';

  @override
  String get matchPlayerRatings => 'PENARAFAN PEMAIN';

  @override
  String get matchSubstitutions => 'PERTUKARAN PEMAIN';

  @override
  String get matchSubstitutes => 'PEMAIN SIMPANAN';

  @override
  String get matchPlayerOfTheMatch => 'PEMAIN TERBAIK PERLAWANAN';

  @override
  String get matchGoalShout => 'GOL!';

  @override
  String matchShootoutScore(int home, int away) {
    return 'PENALTI $home–$away';
  }

  @override
  String matchShootoutKickScored(String name) {
    return '$name: MASUK';
  }

  @override
  String matchShootoutKickMissed(String name) {
    return '$name: GAGAL';
  }

  @override
  String get matchFeedKickOff => 'Sepak mula!';

  @override
  String get matchFeedNoEvents => 'Belum ada kejadian.';

  @override
  String get tourVenues => 'STADIUM';

  @override
  String tourPot(int number) {
    return 'POT $number';
  }

  @override
  String get tourHostSelection => 'PEMILIHAN TUAN RUMAH';

  @override
  String get tourCandidates => 'CALON';

  @override
  String get tourJointBid => 'BIDAAN BERSAMA';

  @override
  String get tourGoldenGlove => 'SARUNG TANGAN EMAS';

  @override
  String get tourTeamOfTournament => 'PASUKAN TERBAIK KEJOHANAN';

  @override
  String get tourYourRun => 'PERJALANAN ANDA';

  @override
  String get tourMedalTable => 'JADUAL PINGAT';

  @override
  String tourHostLine(String nation) {
    return 'Tuan rumah: $nation';
  }

  @override
  String tourHostLineMulti(String hosts) {
    return 'Tuan rumah: $hosts';
  }

  @override
  String tourGroupNamed(String name) {
    return 'Kumpulan $name';
  }

  @override
  String get tourFinalsDrawBlurb =>
      'Pilihan berdasarkan ranking dunia. Cari negara anda sebelum cabutan.';

  @override
  String get tourWorldRanking => 'Ranking Dunia';

  @override
  String get tourYourCompetitions => 'PERTANDINGAN ANDA';

  @override
  String get tourOtherContinents => 'BENUA LAIN';

  @override
  String get tourZoneGlobal => 'GLOBAL';

  @override
  String get tourZoneEurope => 'EROPAH';

  @override
  String get tourZoneSouthAmerica => 'AM. SELATAN';

  @override
  String get tourZoneNorthAmerica => 'AM. UTARA';

  @override
  String get tourZoneAfrica => 'AFRIKA';

  @override
  String get tourZoneAsia => 'ASIA';

  @override
  String get tourZoneOceania => 'OCEANIA';

  @override
  String get tourZoneIntercontinental => 'ANTARA BENUA';

  @override
  String tourZoneLeague(String league) {
    return 'LIGA $league';
  }

  @override
  String tourHostedBy(String hosts) {
    return 'TUAN RUMAH  $hosts';
  }

  @override
  String tourThirdsAdvance(int count, String destination) {
    return '$count teratas mara ke $destination';
  }

  @override
  String newsWalkoutTitle(String name) {
    return '$name meninggalkan pasukan';
  }

  @override
  String newsWalkoutBody(String name, int age, int caps) {
    return '$name telah bersara daripada bola sepak antarabangsa pada usia $age, dengan $caps penampilan. Dia meminta penjelasan tentang kedudukannya dan tidak mendapatnya, dan dia tidak mahu menunggu lagi.';
  }

  @override
  String get pressHeadlineWent1 => 'Jurulatih yang menguasai bilik';

  @override
  String get pressHeadlineWent2 =>
      'Mereka datang mencari gaduh dan menemui seorang pemimpin';

  @override
  String get pressHeadlineWent3 => 'Jawapan terus terang, dan ia mengena';

  @override
  String get pressHeadlineMixed1 =>
      'Banyak yang diperkatakan, sedikit yang selesai';

  @override
  String get pressHeadlineMixed2 =>
      'Sesuatu untuk semua, dan tiada apa untuk sesiapa';

  @override
  String get pressHeadlineMixed3 =>
      'Sidang media yang membiarkan persoalan terbuka';

  @override
  String get pressHeadlineBadly1 => 'Petang yang perit di hadapan kamera';

  @override
  String get pressHeadlineBadly2 =>
      'Suasana bilik berubah, dan ia jelas kelihatan';

  @override
  String get pressHeadlineBadly3 =>
      'Jawapan yang akan kedengaran lebih buruk esok pagi';

  @override
  String get pressHeadlineFlat1 => 'Tiada apa dikatakan, tiada apa diperoleh';

  @override
  String get pressHeadlineFlat2 => 'Sepuluh minit, tiada berita';

  @override
  String get pressHeadlineFlat3 => 'Halaman kosong untuk muka belakang';

  @override
  String get pressConferenceTitle => 'SIDANG MEDIA';

  @override
  String pressQuestionOf(int index, int total) {
    return 'Soalan $index daripada $total';
  }

  @override
  String get pressTomorrowsHeadline => 'MUKA BELAKANG ESOK';

  @override
  String get pressLeaveRoom => 'TINGGALKAN BILIK';

  @override
  String get pressRoomVerdictSquad => 'Bilik persalinan';

  @override
  String get pressRoomVerdictBoard => 'Lembaga';

  @override
  String get yReactionElation0 => 'tiada komen. langsung. sempurna.';

  @override
  String get yReactionElation1 => 'Saya tak keruan (gembira).';

  @override
  String get yReactionElation2 => 'nak bingkaikan ini. letak atas pendiang.';

  @override
  String get yReactionElation3 => 'kita dah kembali';

  @override
  String get yReactionElation4 =>
      'Tangkap layar ini untuk mereka yang ragu. Semuanya.';

  @override
  String get yReactionElation5 =>
      'Saya akan berlagak tentang ini selama sedekad.';

  @override
  String get yReactionElation6 => 'Ya. Sebab inilah kita menonton.';

  @override
  String get yReactionElation7 => 'Hari begini membayar semua hari yang lain.';

  @override
  String get yReactionElation8 => 'Akhirnya. Betul-betul, akhirnya.';

  @override
  String get yReactionElation9 =>
      'Bagus. Sekarang buat lagi minggu depan dan baru saya percaya.';

  @override
  String get yReactionElation10 =>
      'Nikmati malam ini, sebab mereka ini akan cari cara untuk merosakkannya.';

  @override
  String get yReactionElation11 =>
      'Satu malam yang baik tidak menjadikan sesiapa pasukan hebat.';

  @override
  String get yReactionRelief0 =>
      'Tidak cantik, tetapi saya terima setiap kali.';

  @override
  String get yReactionRelief1 => 'Entah macam mana. Entah macam mana!';

  @override
  String get yReactionRelief2 => 'Hodoh. Tiga mata. Teruskan.';

  @override
  String get yReactionRelief3 =>
      'Saya terima main hodoh sepanjang hari kalau datang dengan mata.';

  @override
  String get yReactionRelief4 => 'itu memendekkan umur saya sepuluh tahun';

  @override
  String get yReactionRelief5 => 'Jangan cakap apa-apa. Jangan sampai badi.';

  @override
  String get yReactionRelief6 => 'Kadar degupan jantung: tidak boleh diterima.';

  @override
  String get yReactionRelief7 => 'Selamat. Itulah perkataannya. Selamat.';

  @override
  String get yReactionRelief8 =>
      'Kita tidak sepatutnya rasa lega dalam perlawanan begitu.';

  @override
  String get yReactionRelief9 => 'Lega, dan sedikit malu kerana rasa lega.';

  @override
  String get yReactionRelief10 =>
      'Kalau itu standard yang kita sorakkan, kita dalam masalah.';

  @override
  String get yReactionRelief11 =>
      'Lepas tipis-tipis sudah jadi tabiat, dan bukan tabiat yang baik.';

  @override
  String get yReactionFury0 => 'Tidak cukup bagus. Langsung tidak.';

  @override
  String get yReactionFury1 =>
      'Seseorang terangkan kepada saya perlahan-lahan.';

  @override
  String get yReactionFury2 => 'Itu sukar ditonton dan saya masih bersopan.';

  @override
  String get yReactionFury3 => 'Kecewa. Betul-betul kecewa.';

  @override
  String get yReactionFury4 => 'Teruk sungguh keadaan ini.';

  @override
  String get yReactionFury5 => 'Saya mahu nama.';

  @override
  String get yReactionFury6 => 'Padam aplikasi. Pasang semula hari Khamis.';

  @override
  String get yReactionFury7 =>
      'Tiada seorang pun di padang nampak seperti mahukannya.';

  @override
  String get yReactionFury8 =>
      'Setiap empat tahun, sama sahaja. SETIAP empat tahun.';

  @override
  String get yReactionFury9 => 'Itu bukan persembahan, itu penghinaan.';

  @override
  String get yReactionFury10 =>
      'Orang korbankan hujung minggu dan duit untuk itu. Fikirkanlah.';

  @override
  String get yReactionFury11 =>
      'Saya sudah mempertahankan pasukan ini bertahun-tahun. Bukan malam ini. Bukan selepas itu.';

  @override
  String get yReactionDespair0 => 'yalah.';

  @override
  String get yReactionDespair1 => 'Tiada lawak hari ini. Langsung.';

  @override
  String get yReactionDespair2 => 'Nak keluar berjalan. Jauh-jauh.';

  @override
  String get yReactionDespair3 =>
      'Saya sudah kehabisan cara untuk mengatakannya.';

  @override
  String get yReactionDespair4 => 'Kejutkan saya empat tahun lagi.';

  @override
  String get yReactionDespair5 => 'ini garis masa paling gelap';

  @override
  String get yReactionDespair6 =>
      'Sudah tidak marah lagi. Itulah yang merisaukan.';

  @override
  String get yReactionDespair7 => 'Yang itu akan pedih untuk masa yang lama.';

  @override
  String get yReactionDespair8 =>
      'Saya tidak tahu ini apa lagi, tetapi ini bukan pasukan bola sepak.';

  @override
  String get yReactionDespair9 =>
      'Kita lebih jauh daripada dulu, dan tiada siapa mahu mengakuinya.';

  @override
  String get yReactionDespair10 =>
      'Satu generasi dibazirkan dan orang yang sama menentukan apa seterusnya.';

  @override
  String get yReactionDespair11 =>
      'Berhenti beritahu saya ini satu proses. Ia tidak ke mana-mana.';

  @override
  String get yReactionSmugness0 => 'Perlahan sahaja, tapi: dah cakap dah.';

  @override
  String get yReactionSmugness1 => 'simpan yang ini';

  @override
  String get yReactionSmugness2 => 'Mereka yang ragu sudah sangat senyap.';

  @override
  String get yReactionSmugness3 => 'Bukan ada orang mengira pun. Saya mengira.';

  @override
  String get yReactionSmugness4 =>
      'Sudah cakap pada bulan Januari. Semak garis masa.';

  @override
  String get yReactionSmugness5 =>
      'Ada antara kamu yang perlu minta maaf kepada kami.';

  @override
  String get yReactionSmugness6 =>
      'Simpan bawah fail perkara yang saya sebut dulu.';

  @override
  String get yReactionSmugness7 => 'Tak nak berlagak. Sikit sahaja.';

  @override
  String get yReactionSmugness8 => 'Mana semua pakar sekarang? Soalan ikhlas.';

  @override
  String get yReactionSmugness9 =>
      'Saya mahu setiap seorang daripada kamu ulang semula kepada saya.';

  @override
  String get yReactionSmugness10 =>
      'Tangkap layar, cetak, bingkai, hantar kepada mereka yang ketawa.';

  @override
  String get yReactionSmugness11 =>
      'Saya akan ungkit ini seumur hidup dan kamu memang layak.';

  @override
  String get yReactionShrug0 => 'dah berlaku. seterusnya.';

  @override
  String get yReactionShrug1 => 'Okey. Apa-apalah. Teruskan.';

  @override
  String get yReactionShrug2 => 'Simpan yang ini bawah \'bola sepak\'.';

  @override
  String get yReactionShrug3 => 'Betul-betul tiada apa nak ditambah.';

  @override
  String get yReactionShrug4 => 'tiada fikiran, kepala kosong';

  @override
  String get yReactionShrug5 => 'Kejutkan saya untuk perlawanan seterusnya.';

  @override
  String get yReactionShrug6 => 'Sembilan puluh minit yang tidak akan kembali.';

  @override
  String get yReactionShrug7 => 'Biasa-biasa sahaja, sebenarnya.';

  @override
  String get yReactionShrug8 =>
      'Tidak dapat beritahu satu pun perkara yang berlaku.';

  @override
  String get yReactionShrug9 => 'Satu lagi yang begitu. Banyak yang begitu.';

  @override
  String get yReactionShrug10 =>
      'Saya tonton semuanya dan tidak rasa apa-apa langsung.';

  @override
  String get yReactionShrug11 =>
      'Kalau tiada siapa sebut tentang ini lagi, saya tidak kisah.';

  @override
  String get tourThirdsUneven =>
      'Kumpulan tidak sama saiz, jadi keputusan menentang pasukan tercorot setiap kumpulan besar digugurkan dan setiap pasukan dinilai berdasarkan bilangan perlawanan yang sama.';

  @override
  String get careerExportSave => 'Sandarkan simpanan ini';

  @override
  String get careerBackupAll => 'SANDARKAN SEMUA SIMPANAN';

  @override
  String get careerBackupAllFailed => 'Sandaran tidak dapat ditulis.';

  @override
  String get backupTitle => 'SANDARAN';

  @override
  String get backupBlurb =>
      'Setiap simpanan berada dalam satu fail di telefon ini, dan tiada apa yang menyandarkannya secara automatik melainkan anda menghidupkan sandaran automatik di bawah. Simpan salinan di awan supaya telefon hilang atau aplikasi terpadam tidak menyebabkan anda kehilangan kerjaya.';

  @override
  String get backupBlurbNoAuto =>
      'Setiap simpanan berada dalam satu fail di telefon ini, dan tiada apa yang menyandarkannya secara automatik. Simpan salinan di awan supaya telefon hilang atau aplikasi terpadam tidak menyebabkan anda kehilangan kerjaya.';

  @override
  String get backupExport => 'SANDARKAN KE AWAN';

  @override
  String get backupExportSubject => 'Simpanan FNM';

  @override
  String get backupRestore => 'PULIHKAN DARIPADA FAIL';

  @override
  String get backupRestoreWarnTitle => 'Gantikan semua simpanan?';

  @override
  String get backupRestoreWarnBody =>
      'Pemulihan menggantikan semua simpanan di telefon ini dengan yang ada dalam fail. Aplikasi akan dimulakan semula.';

  @override
  String get backupRestoreConfirm => 'GANTIKAN';

  @override
  String get backupCancel => 'BATAL';

  @override
  String get backupExported =>
      'Sandaran sedia. Pilih tempat untuk menyimpannya.';

  @override
  String get backupFailed => 'Sandaran tidak dapat ditulis.';

  @override
  String get backupRejectedUnreadable => 'Fail itu tidak dapat dibuka.';

  @override
  String get backupRejectedNotFnm => 'Itu bukan simpanan FNM.';

  @override
  String get backupRejectedNewer =>
      'Simpanan itu dibuat oleh versi aplikasi yang lebih baharu. Kemas kini dahulu.';

  @override
  String get backupRejectedTooOld =>
      'Simpanan itu terlalu lama untuk dipulihkan oleh versi ini.';

  @override
  String get careerShare => 'Kongsi kerjaya ini';

  @override
  String get careerImport => 'IMPORT KERJAYA';

  @override
  String get careerShareSubject => 'Kerjaya FNM';

  @override
  String get careerImported => 'Kerjaya diimport.';

  @override
  String get careerImportFailedUnreadable => 'Fail itu bukan kerjaya FNM.';

  @override
  String get careerImportFailedNewer =>
      'Kerjaya itu dieksport oleh versi aplikasi yang lebih baharu. Kemas kini dahulu.';

  @override
  String get careerImportFailedSlotsFull =>
      'Semua slot simpanan anda sedang digunakan. Padam satu simpanan untuk memberi ruang, atau buka simpanan tanpa had.';

  @override
  String get careerImportFailedNeedsPremium =>
      'Kerjaya itu sudah melepasi kitaran pertama percuma. Buka permainan penuh untuk mengimportnya.';

  @override
  String get careerImportFailedCampaignRun =>
      'Kempen itu sudah ada percubaan yang sedang berjalan. Sambung atau tinggalkannya dahulu.';

  @override
  String get careerShareFailed => 'Kerjaya itu tidak dapat dieksport.';

  @override
  String get managerRename => 'Tukar nama';

  @override
  String get managerRenameSave => 'Simpan';

  @override
  String get managerTitle => 'JURULATIH';

  @override
  String get managerSkills => 'KEMAHIRAN ANDA';

  @override
  String managerPointsAvailable(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mata untuk digunakan',
      zero: 'Tiada mata untuk digunakan',
    );
    return '$_temp0';
  }

  @override
  String get managerPointsHow =>
      'Dua mata untuk setiap kitaran yang anda tamatkan, satu untuk setiap trofi yang anda menangi.';

  @override
  String get managerSkillsScale =>
      'Setiap kemahiran bermula pada 5 dan berhenti pada 20. Mata yang digunakan adalah kekal.';

  @override
  String get managerSkillManManagement => 'Pengurusan Pemain';

  @override
  String get managerSkillManManagementBlurb =>
      'Setiap mata menjadikan kata-kata anda kepada media dan pemain 3% lebih berkesan di bilik persalinan.';

  @override
  String get managerSkillTactical => 'Taktikal';

  @override
  String get managerSkillTacticalBlurb =>
      'Setiap mata menyerapkan formasi baharu 3% lebih cepat, jadi menukar formasi menelan lebih sedikit perlawanan.';

  @override
  String get managerSkillYouth => 'Pembangunan Belia';

  @override
  String get managerSkillYouthBlurb =>
      'Setiap mata menambah 1% kepada bakat yang keluar dari akademi anda, di samping dana yang anda berikan.';

  @override
  String get managerSkillNegotiation => 'Rundingan';

  @override
  String get managerSkillNegotiationBlurb =>
      'Setiap mata bermakna 2% lebih wang daripada persatuan, setiap kitaran.';

  @override
  String get managerStaff => 'KAKITANGAN ANDA';

  @override
  String managerStaffWages(String amount) {
    return 'Gaji: $amount setiap kitaran';
  }

  @override
  String get managerRoleAssistant => 'Penolong Jurulatih';

  @override
  String get managerRoleAssistantBlurb =>
      'Mengendalikan latihan: kurang kecederaan, dan pemain muda yang lebih baik.';

  @override
  String get managerRoleScout => 'Ketua Pencari Bakat';

  @override
  String get managerRoleScoutBlurb =>
      'Menilai prospek anda dan lawan seterusnya: penarafan bintang lebih tepat, dan kelebihan pada hari perlawanan.';

  @override
  String get managerRoleFitness => 'Jurulatih Kecergasan';

  @override
  String get managerRoleFitnessBlurb => 'Memastikan mereka kekal di padang.';

  @override
  String staffEffectInjury(int percent) {
    return '$percent% kurang kecederaan';
  }

  @override
  String staffEffectYouth(int points) {
    return 'Pemain muda +$points keseluruhan';
  }

  @override
  String staffHiringInjury(int min, int max) {
    return 'Melantik seorang: $min% hingga $max% kurang kecederaan';
  }

  @override
  String staffHiringYouth(int minPoints, int maxPoints) {
    return 'dan pemain muda +$minPoints hingga +$maxPoints keseluruhan';
  }

  @override
  String staffEffectScoutRead(int percent) {
    return 'Menilai $percent% prospek dengan tepat';
  }

  @override
  String staffEffectScoutCaps(int caps) {
    String _temp0 = intl.Intl.pluralLogic(
      caps,
      locale: localeName,
      other: 'Potensi diketahui selepas $caps penampilan',
      one: 'Potensi diketahui selepas 1 penampilan',
    );
    return '$_temp0';
  }

  @override
  String staffEffectScoutDossier(int points) {
    return '+$points penarafan daripada dosier lawan';
  }

  @override
  String staffHiringScoutRead(int min, int max) {
    return 'Melantik seorang: $min% hingga $max% penilaian tepat';
  }

  @override
  String staffHiringScoutCaps(int minCaps, int maxCaps) {
    return 'dan potensi diketahui $minCaps hingga $maxCaps penampilan lebih awal';
  }

  @override
  String staffHiringScoutDossier(int minPoints, int maxPoints) {
    return 'dan +$minPoints hingga +$maxPoints penarafan setiap perlawanan';
  }

  @override
  String get staffEffectNone => 'Belum ada kesan pada skuad anda';

  @override
  String get staffVacant => 'Jawatan kosong';

  @override
  String get staffLeaveVacant => 'Biarkan jawatan kosong';

  @override
  String get managerTierNone => 'Tiada';

  @override
  String get managerTierBasic => 'Asas';

  @override
  String get managerTierGood => 'Baik';

  @override
  String get managerTierElite => 'Elit';

  @override
  String get managerFree => 'percuma';

  @override
  String get managerTraining => 'ANTARA JENDELA';

  @override
  String get managerTrainingBlurb =>
      'Apa yang skuad latih apabila tiada perlawanan.';

  @override
  String get managerFocusBalanced => 'Seimbang';

  @override
  String get managerFocusBalancedBlurb => 'Sedikit semua perkara.';

  @override
  String get managerFocusFitness => 'Kecergasan';

  @override
  String get managerFocusFitnessBlurb => 'Kurang kecederaan.';

  @override
  String get managerFocusCohesion => 'Kesepaduan';

  @override
  String get managerFocusCohesionBlurb => 'Formasi diserap lebih cepat.';

  @override
  String get managerFocusYouth => 'Belia';

  @override
  String get managerFocusYouthBlurb =>
      'Masa bersama pemain termuda dalam senarai.';

  @override
  String get tourOfferTitle => 'Kali pertama di sini?';

  @override
  String get tourOfferBody =>
      'Ini permainan yang besar. Mahu lawatan ringkas ke skrin-skrin penting? Ia mengambil masa seminit, dan anda boleh memulakannya semula bila-bila masa dari Tetapan.';

  @override
  String get tourOfferYes => 'Tunjukkan saya';

  @override
  String get tourOfferNo => 'Tidak, terima kasih';

  @override
  String get tourBack => 'Kembali';

  @override
  String get tourNext => 'Seterusnya';

  @override
  String get tourDone => 'Selesai';

  @override
  String get tourSkip => 'Langkau';

  @override
  String get tourHubTitle => 'Inilah keseluruhan permainan';

  @override
  String get tourHubBody =>
      'Satu butang, dan ia berubah mengikut perjalanan kitaran: cabutan undian untuk ditonton, skuad untuk dinamakan, perlawanan untuk dimainkan. Di atasnya terdapat keyakinan lembaga terhadap anda dan objektif yang mereka tetapkan.';

  @override
  String get tourBudgetTitle => 'Wang persatuan';

  @override
  String get tourBudgetBody =>
      'Sekali setiap kitaran empat tahun, anda membahagikan dana antara jabatan. Kakitangan anda dibayar daripadanya dahulu, jadi melantik pencari bakat elit ialah keputusan yang anda buat dengan mengorbankan akademi, bukan di sampingnya.';

  @override
  String get tourTacticsTitle => 'Cara pasukan bermain';

  @override
  String get tourTacticsBody =>
      'Formasi anda, gaya permainan anda, kapten anda dan siapa mengambil bola mati. Biarkan dua yang terakhir tidak ditetapkan dan permainan akan memberi amaran sebelum sepak mula, bukannya memilih untuk anda secara senyap.';

  @override
  String get tourSquadTitle => 'Semua yang boleh anda pilih';

  @override
  String get tourSquadBody =>
      'Seluruh senarai, bukan sekadar skuad: siapa dalam prestasi baik, siapa mengalami kecederaan, siapa digantung, dan siapa yang baru keluar dari akademi.';

  @override
  String get tourCallUpsTitle => 'Menamakan skuad';

  @override
  String get tourCallUpsBody =>
      'Anda menamakan satu skuad bagi setiap jendela antarabangsa dan ia memainkan setiap perlawanan dalam jendela itu, tepat seperti jurulatih sebenar. Kecederaan dalam jendela itu akan membawa masuk pengganti untuk anda.';

  @override
  String get tourRecordsTitle => 'Kerjaya anda';

  @override
  String get tourRecordsBody =>
      'Semua yang telah anda lakukan: perlawanan, rekod pasukan, trofi, dan setiap negara yang pernah anda kendalikan.';

  @override
  String get tourCupsTitle => 'Seluruh dunia';

  @override
  String get tourCupsBody =>
      'Setiap pertandingan yang sedang berlangsung: kumpulan, kedudukan dan kalah mati, termasuk yang anda tidak sertai. Dunia terus bermain sama ada anda layak atau tidak.';

  @override
  String get settingsTourTitle => 'Main semula tutorial';

  @override
  String get settingsTourBlurb => 'Lalui semula skrin-skrin utama dari awal.';

  @override
  String get tourBoardTitle => 'Kepada siapa anda bertanggungjawab';

  @override
  String get tourBoardBody =>
      'Keyakinan lembaga terhadap anda, dan objektif yang mereka tetapkan untuk kitaran ini. Jika anda gagal memenuhi sasaran, di sinilah anda akan nampak tandanya.';

  @override
  String get tourStaffTitle => 'Orang di sekeliling anda';

  @override
  String get tourStaffBody =>
      'Penolong jurulatih, pencari bakat dan jurulatih kecergasan, dilantik mengikut nama. Gaji mereka diambil daripada bajet ini sebelum jabatan, jadi pencari bakat hebat ialah keputusan yang mengorbankan akademi.';

  @override
  String get tourPlaystyleTitle => 'Gaya permainan anda';

  @override
  String get tourPlaystyleBody =>
      'Formasi hanyalah separuh taktik. Inilah separuh lagi: setinggi mana anda mengasak, seterus mana anda bermain, sebanyak mana risiko yang anda ambil.';

  @override
  String get settingsTourNoSave =>
      'Mulakan kerjaya dahulu. Lawatan ini melalui skrin-skrin anda sendiri.';

  @override
  String tacticsOutOfPositionAge(int age) {
    return 'Bukan posisi asal · Umur $age';
  }

  @override
  String get federationNextCycleLocked =>
      'Bajet kitaran seterusnya ditetapkan pada permulaan kitaran itu, sekali gus. Sehingga itu, inilah kegunaan wang anda.';

  @override
  String get federationBudgetAlreadySet => 'Sudah ditetapkan untuk kitaran ini';

  @override
  String yFinalLooms0(String opponent) {
    return '$opponent untuk perlawanan besar ini. Sepanjang minggu, hanya ini yang akan dibualkan orang.';
  }

  @override
  String yFinalLooms1(String opponent) {
    return 'Disahkan: $opponent satu-satunya penghalang. Empat tahun untuk ini.';
  }

  @override
  String yFinalLooms2(String opponent) {
    return 'Baiklah. $opponent. Tiada siapa tidur sehingga ini selesai.';
  }

  @override
  String yFinalLooms3(String opponent) {
    return '$opponent seterusnya, dan yang lain boleh tunggu. Minggu yang luar biasa.';
  }

  @override
  String get matchSetupLeaveToCoach =>
      'Serahkan pemilihan penyepak kepada jurulatih';

  @override
  String friendliesLikeYourGroup(String rivals) {
    return 'Ditanda di bawah: pasukan yang bermain seperti $rivals, pasukan yang anda temui dalam kumpulan anda pada kitaran ini.';
  }

  @override
  String newsTransferWindowTitle(int year) {
    return 'Jendela perpindahan · $year';
  }

  @override
  String careerLastAgo(String when) {
    return 'Terakhir $when lalu';
  }

  @override
  String get settingsFreeScopeTitle => 'Satu kitaran empat tahun percuma';

  @override
  String get settingsFreeScopeBlurb =>
      'Satu kitaran lengkap (kelayakan, kejohanan benua anda dan Kejohanan Dunia) pada dua simpanan, setiap negara di dunia, tiada yang disekat. Kitaran tanpa had dan simpanan tanpa had ialah satu bayaran, sekali sahaja, dan ia merangkumi setiap kemas kini akan datang.';

  @override
  String get settingsUnlockedTitle => 'Dibuka';

  @override
  String get settingsUnlockedBlurb =>
      'Kitaran tanpa had, simpanan tanpa had dan setiap kemas kini akan datang. Terima kasih.';

  @override
  String get settingsFromDeveloperTitle => 'Daripada pembangun';

  @override
  String get settingsFromDeveloperBlurb =>
      'Football Nations Manager dibuat oleh seorang individu dan akan disokong untuk jangka panjang. Tidak akan ada iklan atau transaksi mikro. Jika anda menikmati permainan ini, sila pertimbangkan untuk membeli versi penuh. Itulah yang memastikan kemas kini terus datang.';

  @override
  String get settingsFromDeveloperThanksBlurb =>
      'Football Nations Manager dibuat oleh seorang individu dan akan disokong untuk jangka panjang. Tidak akan ada iklan atau transaksi mikro. Terima kasih kerana membeli versi penuh. Itulah yang memastikan kemas kini terus datang.';

  @override
  String friendliesLikeYourCampaign(String rivals) {
    return 'Ditanda di bawah: pasukan yang bermain seperti $rivals, yang masih perlu anda hadapi.';
  }

  @override
  String get friendliesCloseToYou =>
      'Ditanda di bawah: pasukan paling hampir dengan anda dalam ranking dunia. Setelah cabutan dibuat, tanda akan mengikut kumpulan anda.';

  @override
  String transfersMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count perpindahan',
      one: '1 perpindahan',
    );
    return '$_temp0';
  }

  @override
  String hubRoundPage(int page, int pages) {
    return '$page / $pages';
  }

  @override
  String get transfersNewer => 'Lebih baharu';

  @override
  String get transfersOlder => 'Lagi';

  @override
  String get transfersPagePrevious => 'Sebelumnya';

  @override
  String get transfersPageNext => 'Seterusnya';

  @override
  String transfersPageOf(int page, int pages) {
    return 'Halaman $page daripada $pages';
  }

  @override
  String get transfersMovedTo => 'Berpindah ke';

  @override
  String get transfersUnknownClub => 'Kelab tidak diketahui';

  @override
  String yAgainstThemAgain0(String opponent, String count) {
    return 'Itu $count kali menentang $opponent sekarang. Ada yang mengira, dan itu mereka.';
  }

  @override
  String yAgainstThemAgain1(String opponent, String count) {
    return '$opponent lagi. $count pertemuan, dan kita masih belum dapat membaca mereka.';
  }

  @override
  String yAgainstThemAgain2(String opponent, String count) {
    return 'Kali ke-$count menentang $opponent. Ini bukan lagi kebetulan.';
  }

  @override
  String yAgainstThemAgain3(String opponent, String count) {
    return 'Kita sudah bertemu $opponent $count kali dan tidak belajar apa-apa daripada satu pun.';
  }

  @override
  String yAgainstThemAgain4(String opponent, String count) {
    return '$opponent, $count kali. Mereka tahu betul apa yang kita akan buat.';
  }

  @override
  String yAgainstThemAgain5(String opponent, String count) {
    return 'Apa pun kelebihan $opponent ke atas kita, selepas $count pertemuan, mereka masih memilikinya.';
  }

  @override
  String ySameOldStory0(String count) {
    return 'Itu $count kali perkara ini berlaku kebelakangan ini. Bila agaknya ini menjadi diri kita yang sebenar?';
  }

  @override
  String ySameOldStory1(String count) {
    return '$count petang seperti ini sekarang. Ini satu corak, bukan nasib.';
  }

  @override
  String ySameOldStory2(String count) {
    return 'Kita sudah melihat perlawanan yang sama ini $count kali kebelakangan ini. Skrip sama, pengakhiran sama.';
  }

  @override
  String ySameOldStory3(String count) {
    return '$count versi sembilan puluh minit yang sama sekarang. Tiada siapa membetulkannya.';
  }

  @override
  String ySameOldStory4(String count) {
    return '$count kali. Kalau anda masih tidak nampak coraknya, anda tidak melihat.';
  }

  @override
  String ySameOldStory5(String count) {
    return 'Cerita sama, $count kali. Alasan sudah habis sebelum keputusan buruk berhenti.';
  }

  @override
  String get yToldYouSo0 =>
      'Saya sudah kata ini akan berlaku semasa semua orang sibuk meraikan.';

  @override
  String get yToldYouSo1 =>
      'Dua minggu yang baik dan kita generasi emas lagi. Dan beginilah jadinya.';

  @override
  String get yToldYouSo2 =>
      'Mereka yang menyuruh saya menikmatinya bulan lalu sudah senyap.';

  @override
  String get yToldYouSo3 =>
      'Saya tidak gembira dengan ini. Sangat sedikit. Ada sikit.';

  @override
  String get yToldYouSo4 =>
      'Ia tidak pernah sebagus yang mereka katakan, dan inilah buktinya.';

  @override
  String get yToldYouSo5 =>
      'Setiap kali. Kita diberitahu kali ini berbeza, dan setiap kali ia tidak.';

  @override
  String get tacticsSubOffAlready => 'Sudah keluar';

  @override
  String get tacticsSubInjured => 'Cedera';

  @override
  String get tacticsSubSentOffMark => 'Kad merah';

  @override
  String get tacticsSubNoneLeft => 'Tiada gantian lagi';

  @override
  String get tacticsUndoLastChange => 'Buat asal perubahan terakhir';

  @override
  String get matchStrengthTitle => 'APA YANG MEMPENGARUHI PASUKAN';

  @override
  String get strengthFactorFamiliarity => 'Formasi mahir';

  @override
  String get strengthFactorFatigue => 'Kaki letih';

  @override
  String get strengthFactorClubForm => 'Prestasi kelab';

  @override
  String get strengthFactorMorale => 'Bilik persalinan';

  @override
  String get strengthFactorCaptain => 'Kapten';

  @override
  String get strengthFactorStaff => 'Kakitangan';

  @override
  String get strengthFactorDossier => 'Dosier pencari bakat';

  @override
  String yDebut0(String name) {
    return '$name meraih penampilan pertamanya. Ingat nama ini.';
  }

  @override
  String yDebut1(String name) {
    return 'Penampilan sulung untuk $name. Anda boleh nampak bakatnya, bukan?';
  }

  @override
  String yDebut2(String name) {
    return '$name, penampilan pertama. Mari lihat apa yang dia lakukan.';
  }

  @override
  String yDebut3(String name) {
    return 'Penampilan sulung untuk $name. Skuad memerlukan kaki segar di mana-mana.';
  }

  @override
  String yDebut4(String name) {
    return '$name diberi penampilan. Kita sudah beri banyak sangat kebelakangan ini.';
  }

  @override
  String yDebut5(String name) {
    return 'Penampilan sulung untuk $name. Seorang lagi yang kita akan lupa menjelang musim bunga.';
  }

  @override
  String yDrought0(String name, String count) {
    return '$name sudah $count perlawanan tanpa gol dan melakukan segala yang lain di padang.';
  }

  @override
  String yDrought1(String name, String count) {
    return '$count perlawanan tanpa gol untuk $name. Nanti datanglah bertubi-tubi, selalu begitu.';
  }

  @override
  String yDrought2(String name, String count) {
    return '$name: $count perlawanan, tiada gol.';
  }

  @override
  String yDrought3(String name, String count) {
    return '$count tanpa gol untuk $name. Patut diperhatikan.';
  }

  @override
  String yDrought4(String name, String count) {
    return '$count perlawanan. Tiada gol. $name tidak boleh kena pintu bangsal pun.';
  }

  @override
  String yDrought5(String name, String count) {
    return '$name tidak menjaring dalam $count. Main sesiapa sahaja yang lain.';
  }

  @override
  String yRivalryLooms0(String opponent, String count) {
    return '$opponent seterusnya. $count pertemuan dan ia masih segala-galanya.';
  }

  @override
  String yRivalryLooms1(String opponent, String count) {
    return '$count kali menentang $opponent sekarang. Mari!';
  }

  @override
  String yRivalryLooms2(String opponent, String count) {
    return '$opponent seterusnya. Sudah $count kali bertemu.';
  }

  @override
  String yRivalryLooms3(String opponent, String count) {
    return 'Pertemuan ke-$count dengan $opponent minggu ini.';
  }

  @override
  String yRivalryLooms4(String opponent, String count) {
    return '$opponent lagi. $count pertemuan dan kita tidak belajar apa-apa.';
  }

  @override
  String yRivalryLooms5(String opponent, String count) {
    return '$count perlawanan menentang $opponent dan mereka masih menewaskan kita. Hebat.';
  }

  @override
  String get positionGoalkeeper => 'Penjaga Gol';

  @override
  String get positionLeftBack => 'Bek Kiri';

  @override
  String get positionCentreBack => 'Bek Tengah';

  @override
  String get positionRightBack => 'Bek Kanan';

  @override
  String get positionDefensiveMid => 'Pemain Tengah Bertahan';

  @override
  String get positionCentralMid => 'Pemain Tengah';

  @override
  String get positionAttackingMid => 'Pemain Tengah Menyerang';

  @override
  String get positionLeftMid => 'Pemain Tengah Kiri';

  @override
  String get positionRightMid => 'Pemain Tengah Kanan';

  @override
  String get positionLeftWing => 'Sayap Kiri';

  @override
  String get positionRightWing => 'Sayap Kanan';

  @override
  String get positionStriker => 'Penyerang';

  @override
  String get roleNone => 'Tiada peranan';

  @override
  String get roleTargetMan => 'Penyerang sasaran';

  @override
  String get rolePoacher => 'Pemburu gol';

  @override
  String get rolePlaymaker => 'Pengatur permainan';

  @override
  String get roleBallWinner => 'Perampas bola';

  @override
  String get roleInvertedWinger => 'Sayap songsang';

  @override
  String get roleBallPlayingDefender => 'Pertahanan pembina serangan';

  @override
  String get roleNoneBlurb => 'Bermain mengikut gaya semula jadinya.';

  @override
  String get roleTargetManBlurb =>
      'Menang tandukan, menyalurkan bola. Bantuan dan bola mati.';

  @override
  String get rolePoacherBlurb => 'Menunggu di kotak penalti. Lebih banyak gol.';

  @override
  String get rolePlaymakerBlurb => 'Mencipta peluang. Lebih banyak bantuan.';

  @override
  String get roleBallWinnerBlurb =>
      'Mematahkan serangan, bukan menyudahkannya.';

  @override
  String get roleInvertedWingerBlurb =>
      'Memotong ke dalam untuk merembat. Lebih banyak gol.';

  @override
  String get roleBallPlayingDefenderBlurb =>
      'Memulakan serangan dari belakang.';

  @override
  String get federationDeptYouth => 'Akademi Belia';

  @override
  String get federationDeptCommercial => 'Komersial / PR';

  @override
  String get federationDeptMedical => 'Perubatan & Sains Sukan';

  @override
  String get federationDeptNaturalisation => 'Pejabat Naturalisasi';

  @override
  String get federationDeptBoardRelations => 'Hubungan Lembaga';

  @override
  String get federationDeptYouthBlurb =>
      'Prospek akademi yang lebih baik beraksi untuk negara anda pada kitaran seterusnya.';

  @override
  String get federationDeptCommercialBlurb =>
      'Penajaan membawa pendapatan tambahan pada akhir kitaran.';

  @override
  String get federationDeptMedicalBlurb =>
      'Kurang kecederaan. Skuad anda kekal tersedia sepanjang kitaran.';

  @override
  String get federationDeptNaturalisationBlurb =>
      'Lebih ramai pemain asing menawarkan diri untuk bertukar ke negara anda.';

  @override
  String get federationDeptBoardRelationsBlurb =>
      'Lembaga menilai keputusan anda dengan lebih sabar.';

  @override
  String get federationBuildingAcademy => 'Akademi';

  @override
  String get federationBuildingCommercial => 'Ibu Pejabat Komersial';

  @override
  String get federationBuildingMedical => 'Pusat Perubatan';

  @override
  String get federationBuildingScouting => 'Pejabat Pencarian Bakat';

  @override
  String get federationBuildingBoardroom => 'Bilik Lembaga';

  @override
  String get moraleBuoyant => 'Bersemangat';

  @override
  String get moralePositive => 'Positif';

  @override
  String get moraleSettled => 'Stabil';

  @override
  String get moraleUneasy => 'Resah';

  @override
  String get moraleRockBottom => 'Paling rendah';

  @override
  String get matchTabTimeline => 'GARIS MASA';

  @override
  String get matchTabStats => 'STATISTIK';

  @override
  String get matchTabLineups => 'BARISAN';

  @override
  String get matchPenalty => 'PENALTI';

  @override
  String get matchStateLevel => 'Kedudukan masih sama';

  @override
  String matchStateLead(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Anda mendahului dengan $count gol',
      one: 'Anda mendahului dengan satu gol',
    );
    return '$_temp0';
  }

  @override
  String matchStateTrail(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Anda ketinggalan $count gol',
      one: 'Anda ketinggalan satu gol',
    );
    return '$_temp0';
  }

  @override
  String matchPossessionShare(int possession) {
    return '$possession% penguasaan bola';
  }

  @override
  String get boardVerdictSackedTitle => 'Lembaga telah memecat anda';

  @override
  String boardVerdictSackedBody(int rating) {
    return 'Kitaran yang teruk (penilaian $rating%). Era anda berakhir di sini. Hanya negara yang lebih lemah sanggup mengambil risiko dengan anda sekarang.';
  }

  @override
  String get boardVerdictDelightedTitle => 'Lembaga sangat gembira';

  @override
  String boardVerdictDelightedBody(int rating, String best) {
    return 'Kitaran yang cemerlang (penilaian $rating%) selepas $best. Negara yang lebih besar berminat, atau anda boleh kekal dan membina.';
  }

  @override
  String get boardVerdictSolidTitle => 'Kitaran yang mantap';

  @override
  String boardVerdictSolidBody(int rating) {
    return 'Lembaga berpuas hati (penilaian $rating%). Beberapa negara yang setaraf sanggup mengambil anda, tetapi tiada tekanan untuk berpindah.';
  }

  @override
  String get boardVerdictExpectedMoreTitle => 'Lembaga mengharapkan lebih';

  @override
  String boardVerdictExpectedMoreBody(int rating) {
    return 'Kitaran yang mengecewakan (penilaian $rating%). Anda mengekalkan jawatan, tetapi sebarang tawaran adalah langkah ke belakang.';
  }

  @override
  String get boardVerdictPressureTitle => 'Anda di bawah tekanan sebenar';

  @override
  String boardVerdictPressureBody(int rating) {
    return 'Kitaran yang lemah (penilaian $rating%). Anda terselamat, tetapi hanya negara yang lebih lemah berminat jika anda mahukan permulaan baharu.';
  }

  @override
  String get boardVerdictHeroTitle => 'Negara berdiri di belakang anda';

  @override
  String boardVerdictHeroNote(String nation, int cycles) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles kitaran',
    );
    return ' $nation memuja anda, wira negara selepas $_temp0; jawatan anda selamat selama mana anda mahu.';
  }

  @override
  String get boardVerdictTheNation => 'Negara';

  @override
  String get boardVerdictBestQuiet => 'kitaran yang tenang';

  @override
  String get boardVerdictBestCycle => 'kitaran ini';

  @override
  String boardVerdictBestWorld(String placement) {
    return 'Kejohanan Dunia: $placement';
  }

  @override
  String get finishThirdPlace => 'Tempat ketiga';

  @override
  String get finishFourthPlace => 'Tempat keempat';

  @override
  String get finishDidNotQualify => 'Tidak layak';

  @override
  String get careerRepIconic => 'Ikonik';

  @override
  String get careerRepRenowned => 'Terkenal';

  @override
  String get careerRepEstablished => 'Mapan';

  @override
  String get careerRepRising => 'Sedang meningkat';

  @override
  String get careerRepUnproven => 'Belum terbukti';

  @override
  String get hubOfferStepUp => 'Naik setingkat';

  @override
  String get hubOfferLateral => 'Setaraf';

  @override
  String get hubOfferRebuild => 'Bina semula';

  @override
  String careerNationsCupWon(String league) {
    return 'Liga $league · Juara';
  }

  @override
  String careerNationsCupRunnerUp(String league) {
    return 'Liga $league · Naib juara';
  }

  @override
  String careerNationsCupSemi(String league) {
    return 'Liga $league · Separuh akhir';
  }

  @override
  String careerNationsCupPlaced(String league, int position) {
    return 'Liga $league · #$position';
  }

  @override
  String tourRunInto(String round) {
    return 'Mara ke $round';
  }

  @override
  String get tourRunIntoThirdPlace => 'Mara ke perebutan tempat ketiga';

  @override
  String tourRunThrough(String round) {
    return 'Melepasi $round';
  }

  @override
  String tourRunOut(String round) {
    return 'Tersingkir di $round';
  }

  @override
  String get tourRunInGroup => 'Bersaing di peringkat kumpulan';

  @override
  String get tourRunGroupOut => 'Tersingkir di peringkat kumpulan';

  @override
  String resultsCycleTitle(int year, String nation) {
    return 'Kitaran $year · $nation';
  }

  @override
  String resultsCycleRecord(int played, int won, int drawn, int lost) {
    return '$played perlawanan  ·  ${won}M ${drawn}S ${lost}K';
  }

  @override
  String resultsCycleFinish(String finish) {
    return 'Kejohanan Dunia: $finish';
  }

  @override
  String get resultsCycleUnderway => 'Masih berlangsung';

  @override
  String yTurnedItRound0(String opponent) {
    return 'Ketinggalan dua gol kepada $opponent pada separuh masa dan mereka mendapat semuanya kembali. Itulah pasukan.';
  }

  @override
  String yTurnedItRound1(String opponent) {
    return 'Ketinggalan dua gol menentang $opponent dan akhirnya ia tidak bermakna. Tidak banyak pasukan mampu begitu.';
  }

  @override
  String yTurnedItRound2(String opponent) {
    return 'Separuh masa: ketinggalan dua gol kepada $opponent. Tamat: tidak lagi. Separuh masa kedua perlawanan yang berbeza.';
  }

  @override
  String yTurnedItRound3(String opponent) {
    return 'Bangkit daripada ketinggalan dua gol menentang $opponent. Apa pun yang dikatakan pada rehat, katakannya setiap minggu.';
  }

  @override
  String yTurnedItRound4(String opponent) {
    return 'Baiklah, kita bangkit menentang $opponent. Sekarang seseorang terangkan empat puluh lima minit pertama.';
  }

  @override
  String yTurnedItRound5(String opponent) {
    return 'Ketinggalan dua gol kepada $opponent dan kita disuruh gembira. Betulkan separuh masa pertama.';
  }

  @override
  String yThrewItAway0(String opponent) {
    return 'Mendahului dua gol ke atas $opponent pada rehat dan ia terlepas. Ia berlaku kepada pasukan yang lebih baik juga.';
  }

  @override
  String yThrewItAway1(String opponent) {
    return 'Mendahului dua gol ke atas $opponent dan ia terlepas. Kitaran masih panjang, banyak masa lagi.';
  }

  @override
  String yThrewItAway2(String opponent) {
    return 'Separuh masa: mendahului dua gol ke atas $opponent. Tamat: jauh berbeza.';
  }

  @override
  String yThrewItAway3(String opponent) {
    return 'Kelebihan dua gol menentang $opponent, lenyap dalam empat puluh lima minit.';
  }

  @override
  String yThrewItAway4(String opponent) {
    return 'Mendahului dua gol dan kita kalah. Kepada $opponent. Seseorang perlu bertanggungjawab.';
  }

  @override
  String yThrewItAway5(String opponent) {
    return 'Mendahului dua gol menentang $opponent dan beginilah jadinya. Setiap kali.';
  }

  @override
  String get cycleBackupDone =>
      'Kerjaya disandarkan ke folder FNM di telefon ini. Menyahpasang aplikasi akan memadamnya: untuk menyimpan salinan di tempat lain, gunakan Sandarkan simpanan ini di skrin simpanan.';

  @override
  String get cycleBackupFailed => 'Kerjaya tidak dapat disandarkan kali ini.';

  @override
  String pressMomentBigWinWarm1(String opponent) {
    return 'Malam yang tidak dapat dilupakan menentang $opponent. Sejauh mana anda berbangga dengan kumpulan ini?';
  }

  @override
  String pressMomentBigWinWarm2(String opponent) {
    return '$opponent tidak mampu menandingi anda. Adakah inilah pasukan yang anda selalu percaya anda miliki?';
  }

  @override
  String pressMomentBigWinNeutral1(String opponent) {
    return 'Kemenangan besar ke atas $opponent. Apa yang membezakan malam ini?';
  }

  @override
  String pressMomentBigWinNeutral2(String opponent) {
    return '$opponent ditewaskan, dan dengan selesa. Di mana anda memenanginya?';
  }

  @override
  String pressMomentBigWinHostile1(String opponent) {
    return 'Kemenangan yang baik ke atas $opponent. Satu malam yang baik: kenapa orang perlu percaya ia akan berterusan?';
  }

  @override
  String pressMomentBigWinHostile2(String opponent) {
    return 'Keputusan yang baik menentang $opponent. Adakah itu rancangan anda, atau pemain yang memikirkannya sendiri?';
  }

  @override
  String pressMomentBigLossWarm1(String opponent) {
    return 'Malam yang sukar menentang $opponent. Apa yang anda katakan kepada pemain selepas perlawanan begitu?';
  }

  @override
  String pressMomentBigLossWarm2(String opponent) {
    return 'Tiada siapa menjangkakannya menentang $opponent. Adakah ia sekadar malam yang malang?';
  }

  @override
  String pressMomentBigLossNeutral1(String opponent) {
    return 'Itu malam yang memalukan menentang $opponent. Apa yang tidak kena?';
  }

  @override
  String pressMomentBigLossNeutral2(String opponent) {
    return '$opponent memporak-perandakan anda. Adakah skuad ini cukup bagus?';
  }

  @override
  String pressMomentBigLossHostile1(String opponent) {
    return 'Anda kalah dalam segala-galanya menentang $opponent. Bagaimana anda biarkan ia menjadi seteruk itu?';
  }

  @override
  String pressMomentBigLossHostile2(String opponent) {
    return '$opponent menjaring sesuka hati. Di mana rancangan anda malam ini?';
  }

  @override
  String pressMomentCrisisWarm1(String opponent) {
    return 'Satu lagi terlepas, kali ini menentang $opponent. Bagaimana anda mengubah rentetan ini?';
  }

  @override
  String pressMomentCrisisWarm2(String opponent) {
    return 'Keputusan sudah kering, dan $opponent memburukkannya. Adakah anda masih percaya pada kumpulan ini?';
  }

  @override
  String pressMomentCrisisNeutral1(String opponent) {
    return 'Tiada kemenangan lagi, kini menentang $opponent, dan lembaga sedang memerhati. Adakah jawatan anda selamat?';
  }

  @override
  String pressMomentCrisisNeutral2(String opponent) {
    return 'Selepas $opponent, rentetan ini semakin panjang. Adakah anda bimbang tentang masa depan anda?';
  }

  @override
  String pressMomentCrisisHostile1(String opponent) {
    return '$opponent pula sekarang. Pendahulu anda dipecat ketika rentetan seperti ini. Kenapa anda patut terselamat?';
  }

  @override
  String pressMomentCrisisHostile2(String opponent) {
    return 'Selepas satu lagi malam seperti menentang $opponent, setiap rancangan radio mahu anda keluar. Adakah anda akan meletak jawatan jika lembaga meminta?';
  }

  @override
  String pressMomentJobVerdictWarm1(String opponent) {
    return 'Anda mempertaruhkan jawatan anda, dan selepas $opponent ia tidak memihak kepada anda. Bagaimana keadaan anda?';
  }

  @override
  String pressMomentJobVerdictWarm2(String opponent) {
    return 'Tiga perlawanan sudah selesai, yang terakhir menentang $opponent. Anda sendiri yang menetapkan ujian itu. Apa pendapat anda tentang keputusannya?';
  }

  @override
  String pressMomentJobVerdictNeutral1(String opponent) {
    return 'Anda menyuruh kami menilai anda berdasarkan tiga perlawanan seterusnya. Selepas $opponent, kami sudah menilai. Adakah jawatan itu masih milik anda?';
  }

  @override
  String pressMomentJobVerdictNeutral2(String opponent) {
    return 'Tiga perlawanan, yang terakhir menentang $opponent, dan bukan seperti yang anda janjikan. Sudahkah anda berbincang dengan lembaga tentang masa depan anda?';
  }

  @override
  String pressMomentJobVerdictHostile1(String opponent) {
    return 'Anda menetapkan ujian itu sendiri dan gagal menentang $opponent. Adakah anda akan meletak jawatan?';
  }

  @override
  String pressMomentJobVerdictHostile2(String opponent) {
    return 'Kata-kata anda, bukan kami: nilai saya berdasarkan tiga perlawanan seterusnya. Selepas $opponent, kenapa anda masih duduk di situ?';
  }

  @override
  String get pressBeatWhoToBlameWarm1 =>
      'Anda mahukan lebih daripada mereka. Ada sesiapa yang khusus?';

  @override
  String get pressBeatWhoToBlameWarm2 =>
      'Anda telah meletakkan sasaran tinggi. Siapa yang perlu tampil dahulu?';

  @override
  String get pressBeatWhoToBlameNeutral1 =>
      'Anda kata sebahagian daripada mereka perlu bermuhasabah. Siapa yang anda maksudkan?';

  @override
  String get pressBeatWhoToBlameNeutral2 =>
      'Tidak cukup bagus, kata anda. Siapa yang anda maksudkan?';

  @override
  String get pressBeatWhoToBlameHostile1 =>
      'Anda bercakap secara kabur. Adakah anda akan menyebut nama, atau ia kembali kepada anda?';

  @override
  String get pressBeatWhoToBlameHostile2 =>
      'Setiap minggu ia salah orang lain. Salah siapa kali ini?';

  @override
  String get pressBeatIfYouDontWarm1 =>
      'Kata-kata yang berani. Dan jika perlawanan seterusnya tidak memihak kepada anda?';

  @override
  String get pressBeatIfYouDontWarm2 =>
      'Negara akan memegang kata-kata itu. Bagaimana jika ia tidak menjadi?';

  @override
  String get pressBeatIfYouDontNeutral1 =>
      'Dan jika anda tidak menang? Kemudian apa?';

  @override
  String get pressBeatIfYouDontNeutral2 =>
      'Anda sudah mengatakannya. Apa yang berlaku jika anda salah?';

  @override
  String get pressBeatIfYouDontHostile1 =>
      'Kami pernah mendengar janji di bilik ini sebelum ini. Apa yang anda berhutang kepada penyokong jika yang ini juga dimungkiri?';

  @override
  String get pressBeatIfYouDontHostile2 =>
      'Dan apabila ia tidak berlaku, apa alasannya nanti?';

  @override
  String get pressBeatFollowUpWarm1 =>
      'Satu lagi, jika anda masih larat. Apa yang kumpulan ini masih perlu perbaiki?';

  @override
  String get pressBeatFollowUpWarm2 =>
      'Apabila keadaan reda, apa yang anda bawa dari malam ini ke perlawanan seterusnya?';

  @override
  String get pressBeatFollowUpNeutral1 =>
      'Mari kita selami sedikit. Apa yang perlu diperbaiki sebelum perlawanan seterusnya?';

  @override
  String get pressBeatFollowUpNeutral2 =>
      'Mengetepikan keputusan: adakah skuad ini di tahap yang anda mahu?';

  @override
  String get pressBeatFollowUpHostile1 =>
      'Banyak kata-kata, sedikit isi. Apa yang sebenarnya berubah selepas ini?';

  @override
  String get pressBeatFollowUpHostile2 =>
      'Penyokong mahukan jawapan yang jelas. Adakah pasukan ini cukup bagus, ya atau tidak?';

  @override
  String pressBeatStandoutWarm1(String player) {
    return '$player cemerlang malam ini. Sejauh mana dia boleh pergi?';
  }

  @override
  String pressBeatStandoutWarm2(String player) {
    return '$player menghiasi setiap tajuk berita malam ini. Adakah anda menjangkakannya?';
  }

  @override
  String pressBeatStandoutNeutral1(String player) {
    return '$player menonjol. Apa yang anda minta daripadanya malam ini?';
  }

  @override
  String pressBeatStandoutNeutral2(String player) {
    return 'Adakah $player pembeza malam ini?';
  }

  @override
  String pressBeatStandoutHostile1(String player) {
    return 'Tanpa $player ceritanya lain. Adakah ini satu pasukan, atau seorang pemain?';
  }

  @override
  String pressBeatStandoutHostile2(String player) {
    return '$player hebat. Hasil kerja anda, atau dia?';
  }

  @override
  String pressBeatStrugglerWarm1(String player) {
    return '$player mengalami malam yang sukar. Adakah dia mengalami kecederaan?';
  }

  @override
  String pressBeatStrugglerWarm2(String player) {
    return '$player tidak berada pada hari terbaiknya. Adakah anda akan memberinya sokongan?';
  }

  @override
  String pressBeatStrugglerNeutral1(String player) {
    return '$player bergelut malam ini. Adakah dia mengekalkan tempatnya?';
  }

  @override
  String pressBeatStrugglerNeutral2(String player) {
    return '$player kelihatan ketinggalan rentak. Apa pendapat anda tentang permainannya?';
  }

  @override
  String pressBeatStrugglerHostile1(String player) {
    return '$player sekadar penumpang lagi. Kenapa anda terus memilihnya?';
  }

  @override
  String pressBeatStrugglerHostile2(String player) {
    return 'Semua orang nampak $player tidak bermain dengan baik. Semua kecuali bangku jurulatih?';
  }

  @override
  String get pressThrowbackWinNextKeptWarm =>
      'Anda kata anda akan menang perlawanan seterusnya, dan anda menang. Seronok rasanya apabila betul?';

  @override
  String get pressThrowbackWinNextKeptNeutral =>
      'Anda menjanjikan kemenangan dalam perlawanan seterusnya dan menunaikannya. Keyakinan, atau berlagak?';

  @override
  String get pressThrowbackWinNextKeptHostile =>
      'Anda kata anda akan menang perlawanan seterusnya, dan anda menang. Nasib, atau kami patut mula mendengar?';

  @override
  String get pressThrowbackWinNextBrokenWarm =>
      'Anda memberitahu kami anda akan memenangi perlawanan itu. Ia tidak berlaku. Apa yang tidak kena?';

  @override
  String get pressThrowbackWinNextBrokenNeutral =>
      'Anda kata anda akan menang perlawanan seterusnya. Anda tidak menang. Kenapa kami patut percaya janji seterusnya?';

  @override
  String get pressThrowbackWinNextBrokenHostile =>
      'Anda kata anda akan menang perlawanan seterusnya. Anda tidak menang. Adakah kata-kata anda masih bermakna di bilik ini?';

  @override
  String get pressThrowbackJobKeptWarm =>
      'Anda meminta dinilai berdasarkan tiga perlawanan, dan anda lulus. Terbukti betul?';

  @override
  String get pressThrowbackJobKeptNeutral =>
      'Nilai saya berdasarkan tiga perlawanan seterusnya, kata anda. Kami menilai, dan keputusannya datang. Apa yang ujian itu ajarkan kepada anda?';

  @override
  String get pressThrowbackJobKeptHostile =>
      'Anda memberi diri sendiri tiga perlawanan dan melepasinya. Adakah ujian itu benar-benar sukar?';

  @override
  String get pressThrowbackJobBrokenWarm =>
      'Anda meminta dinilai berdasarkan tiga perlawanan. Ia tidak memihak kepada anda. Apa yang anda pelajari?';

  @override
  String get pressThrowbackJobBrokenNeutral =>
      'Anda kata nilai saya berdasarkan tiga perlawanan seterusnya. Tiga perlawanan sudah berlalu, begitu juga kelonggaran yang diberi. Apa sekarang?';

  @override
  String get pressThrowbackJobBrokenHostile =>
      'Anda menetapkan ujian dan gagal. Kenapa sesiapa patut percaya kata-kata anda sekarang?';

  @override
  String pressThrowbackBackKeptWarm(String player) {
    return 'Anda menyokong $player ketika orang lain tidak. Dia membuktikannya. Sebahagian pujian milik anda?';
  }

  @override
  String pressThrowbackBackKeptNeutral(String player) {
    return 'Anda menyokong $player. Dia membuktikannya. Kepercayaan, atau pengetahuan?';
  }

  @override
  String pressThrowbackBackKeptHostile(String player) {
    return 'Anda menyokong $player, dan buat kali ini ia berbaloi. Adakah anda akan seyakin itu lain kali?';
  }

  @override
  String pressThrowbackBackBrokenWarm(String player) {
    return 'Anda berdiri di belakang $player, dan ia tidak menjadi. Adakah anda masih percaya padanya?';
  }

  @override
  String pressThrowbackBackBrokenNeutral(String player) {
    return 'Anda menyokong $player. Dia tidak membalasnya. Adakah itu satu kesilapan?';
  }

  @override
  String pressThrowbackBackBrokenHostile(String player) {
    return 'Penilaian anda atau kesetiaan anda: yang mana gagal dengan $player?';
  }

  @override
  String pressThrowbackBlameKeptWarm(String player) {
    return 'Anda keras terhadap $player, dan perlawanan sejak itu membuktikan anda betul. Ada rasa puas?';
  }

  @override
  String pressThrowbackBlameKeptNeutral(String player) {
    return 'Anda menegur $player secara terbuka, dan dia belum menjawabnya. Adakah masih ada jalan kembali untuknya?';
  }

  @override
  String pressThrowbackBlameKeptHostile(String player) {
    return 'Anda membiarkan $player terkontang-kanting dan dia belum pulih. Adakah anda telah mematahkan semangatnya?';
  }

  @override
  String pressThrowbackBlameBrokenWarm(String player) {
    return 'Anda menegur $player, dan dia menjawabnya di padang. Adakah itu memang niat anda dari awal?';
  }

  @override
  String pressThrowbackBlameBrokenNeutral(String player) {
    return 'Anda menyalahkan $player, dan sejak itu dia antara pemain terbaik anda. Adakah anda berhutang maaf kepadanya?';
  }

  @override
  String pressThrowbackBlameBrokenHostile(String player) {
    return 'Anda mengorbankan $player, dan sejak itu dia pemain terbaik anda. Adakah anda akan meminta maaf?';
  }

  @override
  String get pressReplyCreditPlayers1 =>
      'Pemain-pemain ini memberikan segalanya. Saya tidak akan menukar seorang pun daripada mereka.';

  @override
  String get pressReplyCreditPlayers2 =>
      'Tiada siapa bekerja lebih keras daripada kumpulan ini. Saya akan mempertahankan mereka sepanjang hari.';

  @override
  String get pressReplyCreditPlayers3 =>
      'Anda tidak akan dengar sepatah kata pun menentang pemain saya dari kerusi ini.';

  @override
  String get pressReplyCreditPlayers4 =>
      'Pujian untuk pemain, bukan saya. Tulislah tentang mereka.';

  @override
  String get pressReplyTakeResponsibility1 =>
      'Yang itu salah saya. Saya memilih pasukan dan saya menyusun mereka.';

  @override
  String get pressReplyTakeResponsibility2 =>
      'Nilai saya, bukan mereka. Ini pasukan saya dan tanggungjawab saya.';

  @override
  String get pressReplyTakeResponsibility3 =>
      'Kalau anda mahu menyalahkan seseorang, saya duduk di sini.';

  @override
  String get pressReplyTakeResponsibility4 =>
      'Tanggungjawab itu milik saya. Jangan libatkan pemain.';

  @override
  String get pressReplyDemandMore1 =>
      'Saya mahukan lebih. Sebahagian daripada mereka tahu betul apa maksud saya.';

  @override
  String get pressReplyDemandMore2 =>
      'Usaha sahaja tidak cukup di tahap ini. Saya mahukan lebih, dan saya sudah beritahu mereka.';

  @override
  String get pressReplyDemandMore3 =>
      'Saya mengharapkan lebih daripada setiap seorang, bermula esok.';

  @override
  String get pressReplyDemandMore4 =>
      'Sebahagian daripada mereka perlu bermuhasabah. Saya tidak berpuas hati.';

  @override
  String get pressReplyPromiseWinNext1 =>
      'Kami akan menang perlawanan seterusnya. Anda boleh catat itu.';

  @override
  String get pressReplyPromiseWinNext2 =>
      'Ingat kata-kata saya: kami menang perlawanan seterusnya.';

  @override
  String get pressReplyPromiseWinNext3 =>
      'Perlawanan seterusnya, kami menang. Saya katakan di sini supaya anda boleh menuntutnya.';

  @override
  String get pressReplyPromiseWinNext4 =>
      'Saya yakin dengan pasukan ini. Kami menang perlawanan seterusnya.';

  @override
  String get pressReplyJobOnTheLine1 =>
      'Nilai saya berdasarkan tiga perlawanan seterusnya. Itu adil.';

  @override
  String get pressReplyJobOnTheLine2 =>
      'Beri saya tiga perlawanan. Kalau belum betul ketika itu, nilailah saya.';

  @override
  String get pressReplyJobOnTheLine3 =>
      'Tiga perlawanan seterusnya akan menunjukkan sama ada saya orang yang tepat. Pegang kata-kata saya.';

  @override
  String get pressReplyJobOnTheLine4 =>
      'Tiga perlawanan. Selepas itu tulislah apa sahaja tentang saya.';

  @override
  String get pressReplyDeflect1 =>
      'Kami ambil satu perlawanan pada satu masa. Tiada apa lagi untuk ditambah.';

  @override
  String get pressReplyDeflect2 =>
      'Saya tidak akan memberikan tajuk berita kepada anda hari ini.';

  @override
  String get pressReplyDeflect3 =>
      'Perlawanan seterusnya. Itu sahaja yang saya fikirkan.';

  @override
  String get pressReplyDeflect4 =>
      'Apa yang saya fikir kekal di bilik persalinan.';

  @override
  String get pressReplyTakeCredit1 =>
      'Saya mengatakannya kerana saya percaya, dan saya betul.';

  @override
  String get pressReplyTakeCredit2 =>
      'Saya membacanya dengan tepat. Itulah tugas saya di sini.';

  @override
  String get pressReplyTakeCredit3 =>
      'Panggillah ia pertimbangan. Saya tahu apa yang saya katakan.';

  @override
  String get pressReplyTakeCredit4 =>
      'Saya membuat keputusan dan ia menjadi. Saya terima pujian itu.';

  @override
  String get pressReplyStandByIt1 =>
      'Saya katakan apa yang saya percaya. Saya berpegang padanya.';

  @override
  String get pressReplyStandByIt2 => 'Saya tidak menarik balik sepatah pun.';

  @override
  String get pressReplyStandByIt3 =>
      'Jawapan sama seperti dahulu. Saya maksudkannya, dan masih begitu.';

  @override
  String get pressReplyStandByIt4 => 'Saya akan mengatakannya lagi esok.';

  @override
  String get pressReplyAdmitMistake1 => 'Saya silap kali itu. Saya akui.';

  @override
  String get pressReplyAdmitMistake2 =>
      'Baiklah, saya tersalah nilai. Saya akan belajar daripadanya.';

  @override
  String get pressReplyAdmitMistake3 =>
      'Saya salah, dan saya boleh mengakuinya.';

  @override
  String get pressReplyAdmitMistake4 =>
      'Keputusan itu tidak menjadi, dan ia keputusan saya.';

  @override
  String pressReplyBackPlayer1(String player) {
    return '$player mendapat sokongan penuh saya. Dia akan bangkit.';
  }

  @override
  String pressReplyBackPlayer2(String player) {
    return 'Saya percaya pada $player, dan dia akan tunjukkan kenapa.';
  }

  @override
  String pressReplyBackPlayer3(String player) {
    return 'Anda tidak akan dengar sepatah kata menentang $player daripada saya. Dia akan membuktikannya.';
  }

  @override
  String pressReplyBackPlayer4(String player) {
    return '$player kekal dalam perancangan saya. Lihat apa yang dia lakukan seterusnya.';
  }

  @override
  String pressReplyBlamePlayer1(String player) {
    return '$player mengecewakan kami malam ini, dan dia tahu.';
  }

  @override
  String pressReplyBlamePlayer2(String player) {
    return 'Saya mengharapkan jauh lebih banyak daripada $player. Dia perlu menjawabnya.';
  }

  @override
  String pressReplyBlamePlayer3(String player) {
    return '$player tidak berada di tahapnya. Saya katakan secara terbuka.';
  }

  @override
  String pressReplyBlamePlayer4(String player) {
    return 'Itu tidak cukup bagus daripada $player, dan dia akan mendengarnya daripada saya.';
  }

  @override
  String get pressOnRecordWinNext =>
      'Direkodkan: anda akan menang perlawanan seterusnya.';

  @override
  String get pressOnRecordJob =>
      'Direkodkan: nilai anda berdasarkan tiga perlawanan seterusnya.';

  @override
  String pressOnRecordBack(String player) {
    return 'Direkodkan: menyokong $player.';
  }

  @override
  String pressOnRecordBlame(String player) {
    return 'Direkodkan: $player mengecewakan anda.';
  }

  @override
  String yStatementKept0(String nation) {
    return 'Dia berkata, dan ia berlaku. $nation ada jurulatih yang mengotakan kata-katanya.';
  }

  @override
  String yStatementKept1(String nation) {
    return 'Berkata dengan lantang, kemudian melakukannya. Itulah orang yang diperlukan $nation.';
  }

  @override
  String yStatementKept2(String nation) {
    return '$nation: dia meramalkannya, dan ia menjadi kenyataan. Adil.';
  }

  @override
  String yStatementKept3(String nation) {
    return 'Dia merekodkannya dan ia terbukti. Satu mata untuknya. $nation teruskan.';
  }

  @override
  String yStatementKept4(String nation) {
    return 'Dia betul sekali. $nation, jangan jadikan kebiasaan.';
  }

  @override
  String yStatementKept5(String nation) {
    return 'Jam rosak pun betul dua kali sehari. $nation bernasib baik kali ini.';
  }

  @override
  String yStatementBroken0(String nation) {
    return 'Dia berkata dan ia tidak menjadi. Masih bersamanya. $nation cuba lagi.';
  }

  @override
  String yStatementBroken1(String nation) {
    return '$nation: dia menjanjikan lebih daripada yang kita dapat, tetapi saya lebih suka jurulatih yang yakin pada diri sendiri.';
  }

  @override
  String yStatementBroken2(String nation) {
    return '$nation: dia merekodkannya dan ia tidak berlaku. Orang akan ingat.';
  }

  @override
  String yStatementBroken3(String nation) {
    return 'Cakap besar, tiada isi. $nation: lain kali, kurangkan bercakap.';
  }

  @override
  String yStatementBroken4(String nation) {
    return 'Dia berdiri di situ dan memberitahu kita. Kemudian ini. $nation layak mendapat lebih daripada cakap kosong.';
  }

  @override
  String yStatementBroken5(String nation) {
    return 'Kata-katanya tiada nilai lagi. Catatlah, $nation.';
  }

  @override
  String get ncZoneNorth => 'Zon Utara';

  @override
  String get ncZoneWest => 'Zon Barat';

  @override
  String get ncZoneEast => 'Zon Timur';

  @override
  String get ncZoneCentralSouthern => 'Zon Tengah dan Selatan';

  @override
  String careerNationsCupZoneWon(String zone) {
    return '$zone · Juara';
  }

  @override
  String careerNationsCupZoneRunnerUp(String zone) {
    return '$zone · Naib juara';
  }

  @override
  String careerNationsCupZoneSemi(String zone) {
    return '$zone · Separuh akhir';
  }

  @override
  String careerNationsCupZoneRoundOf16(String zone) {
    return '$zone · 16 terakhir';
  }

  @override
  String careerNationsCupZoneQuarter(String zone) {
    return '$zone · Suku akhir';
  }

  @override
  String careerNationsCupZonePlaced(String zone, int position) {
    return '$zone · #$position';
  }

  @override
  String get objectiveNcFinalsEight => 'Mara ke suku akhir';

  @override
  String get objectiveNcZoneWinGroup => 'Juarai kumpulan anda';

  @override
  String get finishNcFinalsEight => 'Suku akhir';

  @override
  String get finishNcBottomHalf => 'Separuh bawah kumpulan';

  @override
  String get tourContTabZones => 'ZON';

  @override
  String get tourContTabFinalsEight => 'KALAH MATI';

  @override
  String get tourContFinalsEightSoon =>
      'Peringkat kalah mati bermula pada November dengan pusingan 16 terakhir: kesemua 14 juara kumpulan dan 2 naib juara terbaik.';

  @override
  String get tourContQuarterFinals => 'SUKU AKHIR';

  @override
  String get tourContZoneAdvancement =>
      'Setiap juara kumpulan mara ke pusingan 16 terakhir, disertai 2 naib juara terbaik. Tiada pasukan tersingkir liga.';

  @override
  String tourContZoneHeadingYours(String zone) {
    return '$zone ★';
  }

  @override
  String get compNorthAmericaNationsCup => 'Piala Negara-Negara Amerika Utara';

  @override
  String get compAfricanNationsCup => 'Piala Negara-Negara';

  @override
  String get objectiveNcWinItNorthAmerica =>
      'Menangi Piala Negara-Negara Amerika Utara';

  @override
  String get objectiveNcWinItAfrica => 'Menangi Piala Negara-Negara';

  @override
  String get objectiveNcReachFinalNorthAmerica =>
      'Mara ke final Piala Negara-Negara Amerika Utara';

  @override
  String get objectiveNcReachFinalAfrica => 'Mara ke final Piala Negara-Negara';

  @override
  String get finishNcChampionsNorthAmerica =>
      'Juara Piala Negara-Negara Amerika Utara';

  @override
  String get finishNcChampionsAfrica => 'Juara Piala Negara-Negara';

  @override
  String pressAimQualWarm1(String competition) {
    return 'Kelayakan $competition bermula sekarang, dan negara percaya pada pasukan ini. Apa sasaran anda?';
  }

  @override
  String pressAimQualWarm2(String competition) {
    return 'Kempen kelayakan $competition baharu, dan semangat tinggi. Sejauh mana pasukan ini boleh pergi?';
  }

  @override
  String pressAimQualNeutral1(String competition) {
    return 'Kelayakan $competition bermula. Apa sasaran untuk kempen ini?';
  }

  @override
  String pressAimQualNeutral2(String competition) {
    return 'Kelayakan $competition sudah tiba. Di mana anda melihat pasukan ini menamatkan saingan?';
  }

  @override
  String pressAimQualHostile1(String competition) {
    return 'Kelayakan $competition bermula, dan ramai meragui anda akan sampai ke sana. Apa kata anda kepada mereka?';
  }

  @override
  String pressAimQualHostile2(String competition) {
    return 'Satu lagi kempen kelayakan $competition. Kenapa orang perlu percaya kali ini akan berbeza?';
  }

  @override
  String pressAimFinalsWarm1(String competition) {
    return '$competition sudah tiba dan seluruh negara di belakang anda. Sejauh mana anda boleh pergi?';
  }

  @override
  String pressAimFinalsWarm2(String competition) {
    return 'Anda berada di $competition dan penyokong sedang bermimpi. Apa sasarannya?';
  }

  @override
  String pressAimFinalsNeutral1(String competition) {
    return '$competition bermula minggu ini. Apa yang dikira sebagai kejayaan?';
  }

  @override
  String pressAimFinalsNeutral2(String competition) {
    return 'Perlawanan pertama anda di $competition semakin hampir. Beri kami satu sasaran.';
  }

  @override
  String pressAimFinalsHostile1(String competition) {
    return '$competition sudah tiba dan tiada siapa menjangkakan banyak. Apa yang anda benar-benar harapkan?';
  }

  @override
  String pressAimFinalsHostile2(String competition) {
    return 'Anda berada di $competition, tetapi keraguan belum hilang. Apa sasaran anda?';
  }

  @override
  String pressBeatRivalWarm1(String rival) {
    return '$rival berada dalam kumpulan anda. Adakah mereka membimbangkan anda?';
  }

  @override
  String pressBeatRivalWarm2(String rival) {
    return 'Cabutan undian meletakkan $rival di laluan anda. Bagaimana anda melihat perlawanan itu?';
  }

  @override
  String pressBeatRivalNeutral1(String rival) {
    return '$rival kelihatan pasukan terkuat dalam kumpulan anda. Adakah mereka pilihan utama?';
  }

  @override
  String pressBeatRivalNeutral2(String rival) {
    return 'Apa pendapat anda tentang $rival?';
  }

  @override
  String pressBeatRivalHostile1(String rival) {
    return '$rival berada dalam kumpulan anda. Jujurlah, mampukah anda menandingi mereka?';
  }

  @override
  String pressBeatRivalHostile2(String rival) {
    return 'Kebanyakan orang menjangkakan $rival menewaskan anda. Adakah mereka salah?';
  }

  @override
  String pressBeatKeyPlayerWarm1(String player) {
    return '$player dalam prestasi cemerlang. Adakah ini masanya?';
  }

  @override
  String pressBeatKeyPlayerWarm2(String player) {
    return '$player menghiasi setiap tajuk berita. Mampukah dia memikul pasukan ini?';
  }

  @override
  String pressBeatKeyPlayerNeutral1(String player) {
    return 'Sejauh mana kempen ini bergantung pada $player?';
  }

  @override
  String pressBeatKeyPlayerNeutral2(String player) {
    return 'Adakah $player bersedia memimpin pasukan ini?';
  }

  @override
  String pressBeatKeyPlayerHostile1(String player) {
    return 'Jika $player tidak berada di tahap terbaiknya, adakah pasukan ini ada apa-apa?';
  }

  @override
  String pressBeatKeyPlayerHostile2(String player) {
    return '$player memikul beban yang berat. Terlalu berat?';
  }

  @override
  String get pressReplyAimHigher1 =>
      'Kami akan pergi lebih jauh daripada jangkaan sesiapa.';

  @override
  String get pressReplyAimHigher2 =>
      'Saya mahukan lebih daripada apa yang diminta persatuan, dan saya akan mengatakannya dengan lantang.';

  @override
  String get pressReplyMatchBrief1 =>
      'Kami tahu sasarannya dan kami akan mencapainya.';

  @override
  String get pressReplyMatchBrief2 =>
      'Persatuan menetapkan sasaran. Kami akan menunaikannya.';

  @override
  String get pressReplyPlayDown1 =>
      'Mari kita ambil satu perlawanan pada satu masa.';

  @override
  String get pressReplyPlayDown2 =>
      'Tiada janji besar. Kita lihat di mana kami nanti.';

  @override
  String get pressReplyPromiseQualify1 =>
      'Kami akan layak. Anda boleh catat itu.';

  @override
  String get pressReplyPromiseQualify2 =>
      'Pasukan ini akan berada di pusingan akhir.';

  @override
  String get pressReplyFearNobody1 => 'Kami tidak takut sesiapa.';

  @override
  String get pressReplyFearNobody2 =>
      'Mereka juga perlu bermain menentang kami.';

  @override
  String get pressReplyRespectRival1 =>
      'Mereka pilihan utama, dan kami menghormati mereka.';

  @override
  String get pressReplyRespectRival2 =>
      'Pasukan yang sangat bagus. Kami perlu bermain sebaik mungkin.';

  @override
  String get pressReplyTeamFirst1 =>
      'Ini tentang seluruh pasukan, bukan seorang pemain.';

  @override
  String get pressReplyTeamFirst2 => 'Tiada siapa boleh menang seorang diri.';

  @override
  String pressOnRecordTarget(String aim) {
    return 'Direkodkan: $aim.';
  }

  @override
  String get pressOnRecordPlayDown => 'Direkodkan: tiada janji.';

  @override
  String get pressThrowbackTargetKeptWarm =>
      'Anda menetapkan sasaran sebelum kempen dan anda mencapainya. Adakah itu detik paling membanggakan anda setakat ini?';

  @override
  String get pressThrowbackTargetKeptNeutral =>
      'Anda kata apa yang akan anda capai, dan anda mencapainya. Pernahkah ia diragui?';

  @override
  String get pressThrowbackTargetKeptHostile =>
      'Anda mencapai sasaran yang anda tetapkan. Nasib, atau memang itu rancangannya?';

  @override
  String get pressThrowbackTargetBrokenWarm =>
      'Anda menetapkan sasaran dan gagal mencapainya. Apa yang tidak kena?';

  @override
  String get pressThrowbackTargetBrokenNeutral =>
      'Anda menjanjikan lebih daripada yang pasukan ini berikan. Adakah anda menyesal mengatakannya?';

  @override
  String get pressThrowbackTargetBrokenHostile =>
      'Anda bercakap besar sebelum kempen dan gagal. Kenapa kami patut percaya anda sekarang?';

  @override
  String hubEventPressPreviewSub(String competition) {
    return 'Media mahu mendengar sasaran anda untuk $competition';
  }

  @override
  String deptLevelCost(int level, String amount) {
    return 'Tahap $level · $amount';
  }

  @override
  String get formOnFire => 'Membara';

  @override
  String get formGood => 'Prestasi baik';

  @override
  String get formSteady => 'Stabil';

  @override
  String get formPoor => 'Prestasi merosot';

  @override
  String get formCold => 'Sangat dingin';

  @override
  String get playerFormTitle => 'PRESTASI DAN KECERGASAN';

  @override
  String playerFormAverage(String rating) {
    return 'Purata $rating dalam perlawanan terkini';
  }

  @override
  String get playerFormNoGames =>
      'Tidak cukup perlawanan terkini untuk dinilai';

  @override
  String playerFormNextMatch(String delta) {
    return '$delta pada penarafannya perlawanan seterusnya';
  }

  @override
  String get playerFormNoEffect =>
      'Tiada perubahan pada penarafannya perlawanan seterusnya';

  @override
  String get sideGroupHome => 'Utama';

  @override
  String get sideGroupTeam => 'Pasukan';

  @override
  String get sideGroupCompetitions => 'Pertandingan';

  @override
  String get sideGroupFederation => 'Persatuan';

  @override
  String get sideGroupHistory => 'Sejarah';

  @override
  String get sideInbox => 'Peti masuk';

  @override
  String get sideSquad => 'Skuad';

  @override
  String get sideTactics => 'Taktik';

  @override
  String get sideMainMenu => 'Menu utama';

  @override
  String get sideCallUps => 'Panggilan skuad';

  @override
  String get sideTournaments => 'Kejohanan';

  @override
  String get sideRanking => 'Ranking';

  @override
  String get sideResults => 'Keputusan';

  @override
  String get sideFinances => 'Kewangan';

  @override
  String get sideBoard => 'Lembaga';

  @override
  String get sideManager => 'Jurulatih & kakitangan';

  @override
  String get sideRecords => 'Rekod';

  @override
  String get sideLegends => 'Legenda';

  @override
  String get sideHeadToHead => 'Bersemuka';

  @override
  String get sideAchievements => 'Pencapaian';

  @override
  String get sideCareer => 'Kerjaya';

  @override
  String get topBarNext => 'Seterusnya';

  @override
  String get topBarDrawPending => 'Cabutan belum dibuat';

  @override
  String get paneFullProfile => 'Profil penuh';

  @override
  String get panePickPlayer => 'Pilih pemain untuk melihat kadnya di sini';

  @override
  String get inboxPickMessage => 'Pilih mesej untuk membacanya di sini';

  @override
  String get inboxFilterAll => 'Semua';

  @override
  String get panelViewAll => 'Lihat semua';

  @override
  String get gridViewOverview => 'Gambaran';

  @override
  String get gridColCondition => 'Keadaan';

  @override
  String get gridColStatus => 'Status';

  @override
  String get gridColRank => 'Ranking';

  @override
  String get gridColMove => 'Gerakan';

  @override
  String get gridColNation => 'Negara';

  @override
  String get gridColRegion => 'Rantau';

  @override
  String get gridColPoints => 'Mata';

  @override
  String get panePickNation => 'Pilih negara untuk melihat rekodnya di sini';

  @override
  String get resultsCyclesTitle => 'Kitaran';

  @override
  String get tourDrawStart => 'Mulakan cabutan';

  @override
  String get tourDrawViewGroups => 'Lihat kumpulan';

  @override
  String get gridColCeiling => 'Siling';

  @override
  String get gridColYearGain => 'Kenaikan';

  @override
  String get gridColMarkedAt => 'Semasa ditanda';

  @override
  String get budgetSetupTitle => 'Tetapkan bajet anda';

  @override
  String get budgetEffectsTitle => 'Apa yang dibeli bajet ini';

  @override
  String get naturalisationTitle => 'Naturalisasi';

  @override
  String get yTrending => 'Sohor kini';

  @override
  String get yVoices => 'Suara';

  @override
  String get yConversation => 'Perbualan';

  @override
  String get allTimeRecordsTitle => 'Rekod dunia sepanjang zaman';

  @override
  String get h2hMeetingsTitle => 'Setiap pertemuan';

  @override
  String get h2hPickOpponent =>
      'Pilih lawan untuk melihat setiap pertemuan di sini';

  @override
  String get savesTitle => 'Simpanan';

  @override
  String get gridColPlayer => 'Pemain';

  @override
  String get gridColPos => 'Pos';

  @override
  String get gridColActive => 'Aktif';

  @override
  String get gridColMotm => 'PTP';

  @override
  String get gridColAvg => 'Purata';

  @override
  String get gridColOpponent => 'Lawan';

  @override
  String get gridColStarts => 'Bermula';

  @override
  String get gridColTournaments => 'Kejohanan';

  @override
  String get gridColDate => 'Tarikh';

  @override
  String get gridColLastPlayed => 'Terakhir dimainkan';

  @override
  String get gridColManager => 'Jurulatih';

  @override
  String nationsShownCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count negara',
      one: '1 negara',
    );
    return '$_temp0';
  }

  @override
  String get nationsSortedByRank => 'Disusun mengikut ranking dunia';

  @override
  String get nationsStrength => 'Kekuatan';

  @override
  String nationsStrengthOf(int tier) {
    return '$tier daripada 5';
  }

  @override
  String get nationsSquadOverall => 'Keseluruhan skuad';

  @override
  String get nationsOpeningBudget => 'Bajet permulaan';

  @override
  String get nationsStarPlayer => 'Pemain bintang';

  @override
  String nationsStarTile(String position, int rating) {
    return 'Bintang $position $rating';
  }

  @override
  String nationsStarAge(int age) {
    return 'Umur $age';
  }

  @override
  String get nationsBoardExpects => 'Lembaga mengharapkan';

  @override
  String nationsManage(String nation) {
    return 'Kendalikan $nation';
  }

  @override
  String get nationsManagerNext => 'Anda namakan jurulatih anda seterusnya';

  @override
  String get playerPageTitle => 'Pemain';

  @override
  String get nationPageTitle => 'Negara';

  @override
  String get friendliesYourGames => 'Perlawanan persahabatan anda';

  @override
  String hubEventInjuryCover(String player) {
    return 'Gantikan $player yang cedera';
  }

  @override
  String hubEventInjuryCoverSub(int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: 'Tidak dapat bermain $matches perlawanan',
      one: 'Tidak dapat bermain perlawanan seterusnya',
    );
    return '$_temp0. Panggil pengganti, atau teruskan tanpanya.';
  }

  @override
  String get injuryCoverTitle => 'PENGGANTI';

  @override
  String injuryCoverBanner(String player, String position) {
    return '$player ($position) cedera. Panggil sesiapa dari luar skuad, di mana-mana posisi, atau kekalkan dia dan teruskan.';
  }

  @override
  String injuryCoverConfirm(String player) {
    return 'Panggil $player';
  }

  @override
  String injuryCoverKeep(String player) {
    return 'Kekalkan $player dan teruskan';
  }

  @override
  String get injuryCoverPick => 'Pilih pengganti';

  @override
  String get injuryCoverNone =>
      'Tiada pemain di luar skuad yang cergas untuk menyertai.';

  @override
  String get nationNowRanking => 'Ranking dunia';

  @override
  String get nationNowForm => 'Prestasi';

  @override
  String get nationNowNoForm => 'Belum ada perlawanan dimainkan';

  @override
  String get nationNowNext => 'Perlawanan seterusnya';

  @override
  String get nationNowNoNext => 'Tiada jadual';

  @override
  String get nationNowSquad => 'Skuad';

  @override
  String get nationNowAgainstYou => 'Menentang anda';

  @override
  String nationNowRecord(int w, int d, int l) {
    return '${w}M ${d}S ${l}K';
  }

  @override
  String get nationNowLastMeeting => 'Pertemuan terakhir';

  @override
  String nationNowOverall(int value) {
    return 'Keseluruhan $value';
  }

  @override
  String get hubUpcoming => 'AKAN DATANG';

  @override
  String get hubFullSchedule => 'Jadual penuh';

  @override
  String get scheduleTitle => 'Jadual';

  @override
  String get scheduleToday => 'Hari ini';

  @override
  String get scheduleKnockoutPending => 'Peringkat kalah mati, jika anda mara';

  @override
  String get scheduleNextRoundPending => 'Pusingan seterusnya';

  @override
  String scheduleFromDate(String date) {
    return 'Dari $date';
  }

  @override
  String get scheduleHomeShort => 'L';

  @override
  String get scheduleAwayShort => 'T';

  @override
  String get tacticsNoPresetsInMatch =>
      'Belum ada taktik tersimpan. Simpan satu dari skrin Taktik sebelum perlawanan.';

  @override
  String get homeCampaigns => 'Kempen';

  @override
  String get homeContinueCampaign => 'TERUSKAN KEMPEN';

  @override
  String homeCampaignCycle(String date, int cycle, int total) {
    return '$date · Kitaran $cycle daripada $total';
  }

  @override
  String get campaignsTitle => 'Kempen';

  @override
  String get campaignTransplantTitle => 'Pemindahan';

  @override
  String get campaignTransplantTwist =>
      'Lapan pemain terbaik Itali bertukar kesetiaan kepada San Marino';

  @override
  String get campaignTransplantGoal => 'Layak ke Kejohanan Eropah';

  @override
  String get campaignGrudgeTitle => 'Dendam';

  @override
  String get campaignGrudgeTwist =>
      'Georgia dan Albania, dalam kumpulan yang sama';

  @override
  String get campaignGrudgeGoal => 'Tamat di atas Albania dalam kelayakan';

  @override
  String get campaignTransplantIntro =>
      'San Marino tidak pernah mempunyai kempen kelayakan yang layak disebut. Kemudian lapan pemain terbaik Itali mengambil pasport dan masuk. Anda ada satu kitaran untuk menjadikan sesuatu yang aneh sebuah pasukan.';

  @override
  String get campaignGrudgeIntro =>
      'Georgia dan Albania diundi dalam kumpulan kelayakan yang sama, dan kedua-duanya tidak akan memaafkan kekalahan. Tamat di atas Albania, kemudian lihat sejauh mana anda boleh pergi.';

  @override
  String get campaignStars1Transplant => 'Layak';

  @override
  String get campaignStars2Transplant => 'Mara ke kalah mati';

  @override
  String get campaignStars3Transplant => 'Menangi Kejohanan Eropah';

  @override
  String get campaignStars1Grudge => 'Di atas Albania';

  @override
  String get campaignStars2Grudge => 'Dan layak';

  @override
  String get campaignStars3Grudge => 'Dan tewaskan mereka dua kali';

  @override
  String get campaignFree => 'Percuma';

  @override
  String get campaignStart => 'Mula';

  @override
  String get campaignPartOfUnlimited => 'Sebahagian Tanpa Had';

  @override
  String get campaignResume => 'Sambung';

  @override
  String get campaignAbandon => 'Tinggalkan';

  @override
  String get campaignAbandonConfirm =>
      'Tinggalkan percubaan ini? Kemajuannya akan hilang; cop anda kekal.';

  @override
  String get campaignMoveToSaves => 'Pindah ke simpanan';

  @override
  String get campaignCannotContinue =>
      'Dunia kempen ini terlalu jauh daripada dunia sebenar untuk diteruskan sebagai kerjaya.';

  @override
  String get campaignMoveSlotsFull =>
      'Slot simpanan anda penuh. Kosongkan satu dahulu.';

  @override
  String get campaignStampConquered => 'Ditakluki';

  @override
  String get campaignStampFailed => 'Gagal';

  @override
  String get campaignDifficultyHard => 'Sukar';

  @override
  String get campaignDifficultyMedium => 'Sederhana';

  @override
  String get campaignGoalLabel => 'Matlamat';

  @override
  String get campaignStarsLabel => 'Bintang';

  @override
  String get campaignRunInProgress =>
      'Kempen ini sudah ada percubaan yang sedang berjalan.';

  @override
  String get campaignVerdictWon => 'Ditakluki';

  @override
  String get campaignVerdictLost => 'Bukan kali ini';

  @override
  String get campaignVerdictContinue => 'Teruskan';

  @override
  String campaignProgressQualifying(String position) {
    return 'Kelayakan: $position';
  }

  @override
  String campaignProgressRival(String rival, String position) {
    return '$rival: $position';
  }

  @override
  String campaignProgressFinals(String stage) {
    return 'Pusingan akhir: $stage';
  }

  @override
  String get campaignRunInNumbers => 'Percubaan dalam angka';

  @override
  String campaignRunMeetings(int won, int played) {
    return 'Pertemuan dimenangi: $won daripada $played';
  }

  @override
  String campaignPlace(String which, int n) {
    String _temp0 = intl.Intl.selectLogic(
      which,
      {
        'first': 'ke-1',
        'second': 'ke-2',
        'third': 'ke-3',
        'other': 'ke-$n',
      },
    );
    return '$_temp0';
  }

  @override
  String get campaignGuineasTitle => 'Guinea Terbaik';

  @override
  String get campaignGuineasTwist =>
      'Guinea Khatulistiwa, Guinea Afrika yang terkecil, selama dua kitaran';

  @override
  String get campaignGuineasGoal => 'Tewaskan Guinea dan Guinea-Bissau';

  @override
  String get campaignGuineasIntro =>
      'Tiga negara Afrika membawa nama Guinea, dan Guinea Khatulistiwa ialah yang paling kecil antara mereka. Anda ada dua kitaran untuk menewaskan Guinea dan Guinea-Bissau sekurang-kurangnya sekali setiap satu, kemudian lihat sejauh mana anda boleh pergi dalam Kejohanan Afrika. Papua New Guinea, Guinea keempat, sudah dijadualkan untuk perlawanan persahabatan.';

  @override
  String get campaignStars1Guineas => 'Tewaskan Guinea dan Guinea-Bissau';

  @override
  String get campaignStars2Guineas => 'Dan layak ke Kejohanan Afrika';

  @override
  String get campaignStars3Guineas => 'Dan mara ke suku akhir Kejohanan Afrika';

  @override
  String get campaignYoungFinnsTitle => 'Anak Muda Finland';

  @override
  String get campaignYoungFinnsTwist =>
      'Generasi emas remaja Finland, selama tiga kitaran';

  @override
  String get campaignYoungFinnsGoal => 'Layak ke Kejohanan Dunia';

  @override
  String get campaignYoungFinnsIntro =>
      'Pemain senior Finland telah berundur dan generasi emas telah mengambil tempat mereka: setiap pemain yang boleh anda pilih berumur 18 tahun atau lebih muda. Mentah hari ini, mereka mempunyai bakat untuk menjadi antara pasukan terbaik dunia, sama seperti generasi muda Norway. Anda ada tiga kitaran untuk membawa mereka ke Kejohanan Dunia, kemudian menjuarai Kejohanan Eropah dan Kejohanan Dunia.';

  @override
  String get campaignStars1YoungFinns => 'Layak ke Kejohanan Dunia';

  @override
  String get campaignStars2YoungFinns => 'Menangi Kejohanan Eropah';

  @override
  String get campaignStars3YoungFinns => 'Menangi Kejohanan Dunia';

  @override
  String get campaignGreenlandTitle => 'Seabad Greenland';

  @override
  String get campaignGreenlandTwist =>
      'Greenland mengambil tempat San Marino di Eropah, selama seratus tahun';

  @override
  String get campaignGreenlandGoal => 'Layak ke Kejohanan Eropah';

  @override
  String get campaignGreenlandIntro =>
      'Greenland tidak pernah bermain perlawanan antarabangsa kompetitif. Dalam dunia ini mereka telah mengambil tempat San Marino di Eropah, dan mereka bermula di dasar ranking dunia: pemain amatur, padang tiruan dan musim yang terhimpit di antara salji. Anda ada seratus tahun, dua puluh lima kitaran, untuk mara ke Kejohanan Eropah, kemudian Kejohanan Dunia dan, jika anda berani bermimpi, menjuarai salah satunya.';

  @override
  String get campaignStars1Greenland => 'Layak ke Kejohanan Eropah';

  @override
  String get campaignStars2Greenland => 'Layak ke Kejohanan Dunia';

  @override
  String get campaignStars3Greenland =>
      'Menangi Kejohanan Eropah atau Kejohanan Dunia';

  @override
  String get campaignPro => 'Pro';

  @override
  String campaignProgressCup(String cup, String year, String status) {
    return '$cup $year: $status';
  }

  @override
  String get campaignCupNotQualified => 'Tidak layak';

  @override
  String get campaignCupOpen => 'Belum ditentukan';

  @override
  String newsYouthTitle1(String name, String level) {
    return '$name bersinar untuk pasukan $level';
  }

  @override
  String newsYouthTitle2(String name, String level) {
    return 'Laporan akademi: $name menarik perhatian';
  }

  @override
  String newsYouthTitle3(String name, String level) {
    return 'Bintang $level: $name';
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
      other: '$count kali',
    );
    return '$name menjaringkan gol $_temp0 untuk pasukan $level menentang $opponent dalam jendela antarabangsa terkini.';
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
      other: '$count gol',
    );
    return '$_temp0 untuk $name ketika pasukan $level menentang $opponent dalam jendela ini.';
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
      other: '$count gol',
    );
    return 'Pasukan $level menentang $opponent, dan $name pulang dengan $_temp0 atas namanya.';
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
      other: '$count gol',
    );
    return '$name mencipta $_temp0 untuk pasukan $level menentang $opponent dan mengawal permainan dari mula hingga akhir.';
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
      other: '$count bantuan',
    );
    return 'Pasukan $level bertemu $opponent dalam jendela ini, dan $name menjadi dalang: $_temp0 dan persembahan yang masih dibualkan oleh jurulatih.';
  }

  @override
  String newsYouthCleanSheet1(String name, String level, String opponent) {
    return '$name cemerlang ketika pasukan $level tidak bolos menentang $opponent.';
  }

  @override
  String newsYouthCleanSheet2(String name, String level, String opponent) {
    return 'Tanpa bolos untuk pasukan $level menentang $opponent, dan $name sebab utamanya.';
  }

  @override
  String newsYouthDisplay1(
    String name,
    String level,
    String opponent,
    int mark,
  ) {
    return '$name mengagumkan untuk pasukan $level menentang $opponent, dan jurulatih memberi persembahannya markah $mark daripada sepuluh.';
  }

  @override
  String newsYouthDisplay2(
    String name,
    String level,
    String opponent,
    int mark,
  ) {
    return 'Pasukan $level menentang $opponent dalam jendela ini, dan jurulatih memilih $name: $mark daripada sepuluh, markah terbaik dalam pasukan.';
  }

  @override
  String get newsYouthDevReady1 =>
      'Dengan prestasi ini, dia sudah cukup bagus untuk dipertimbangkan ke skuad senior.';

  @override
  String get newsYouthDevReady2 =>
      'Jurulatih percaya dia sudah bersedia untuk bola sepak senior sekarang. Keputusan di tangan anda.';

  @override
  String get newsYouthDevClose1 =>
      'Dia berkembang dengan baik dan hampir menembusi skuad senior.';

  @override
  String get newsYouthDevClose2 =>
      'Dia tidak jauh daripada skuad senior, dan satu lagi musim yang baik mungkin mencukupi.';

  @override
  String get newsYouthDevGrowing1 =>
      'Dia berkembang dengan baik, walaupun skuad senior masih selangkah dua lagi.';

  @override
  String get newsYouthDevGrowing2 =>
      'Masih ada kerja sebelum dia menjadi pemain antarabangsa senior, tetapi semuanya menuju ke arah yang betul.';

  @override
  String get newsYouthDevRaw1 =>
      'Dia masih mentah dan beberapa tahun lagi daripada saingan senior, tetapi bakatnya jelas kelihatan.';

  @override
  String get newsYouthDevRaw2 =>
      'Masih awal, dan jurulatih akademi meminta kesabaran, bukan tajuk berita.';

  @override
  String get newsYouthStrengthGkPhysical =>
      'Jangkauan dan penguasaannya di kotak penalti yang membezakannya.';

  @override
  String get newsYouthStrengthGkTechnical =>
      'Tangkapan dan agihan bolanya yang terbaik pernah dilihat akademi sejak bertahun-tahun.';

  @override
  String get newsYouthStrengthGkStamina =>
      'Tumpuannya tidak pernah menurun, dan dia setajam minit kesembilan puluh seperti minit pertama.';

  @override
  String get newsYouthStrengthDefPhysical =>
      'Kepantasan dan kebolehan udaranya menjadi tunjang permainannya.';

  @override
  String get newsYouthStrengthDefTechnical =>
      'Dia membaca permainan jauh melebihi usianya dan tenang ketika menguasai bola.';

  @override
  String get newsYouthStrengthDefStamina =>
      'Dia tidak pernah leka, dan masih berlari pecut ke belakang pada minit terakhir.';

  @override
  String get newsYouthStrengthMidPhysical =>
      'Dia merampas bola dengan kekuatan sebenar dan membawanya ke hadapan.';

  @override
  String get newsYouthStrengthMidTechnical =>
      'Visi dan jangkauan hantarannya menjadi tunjang permainannya.';

  @override
  String get newsYouthStrengthMidStamina =>
      'Staminanya luar biasa: dia meliputi setiap inci padang.';

  @override
  String get newsYouthStrengthFwdPhysical =>
      'Kepantasannya di belakang pertahanan dan kekuatan di udara menyukarkan mana-mana pertahanan.';

  @override
  String get newsYouthStrengthFwdTechnical =>
      'Penyudah dan pergerakannya di kotak penalti menjadi tunjang permainannya.';

  @override
  String get newsYouthStrengthFwdStamina =>
      'Dia mengasak dari hadapan sepanjang perlawanan dan tidak pernah memberi pertahanan lawan peluang bernafas.';

  @override
  String pressMomentBigWinWarm3(String opponent) {
    return 'Penyokong akan menyanyikan tentang perlawanan menentang $opponent itu untuk seketika. Apa yang anda katakan kepada pemain pada wisel penamat?';
  }

  @override
  String pressMomentBigWinNeutral3(String opponent) {
    return 'Itu satu kenyataan menentang $opponent. Berapa banyak yang datang dari padang latihan?';
  }

  @override
  String pressMomentBigWinHostile3(String opponent) {
    return 'Tahniah atas keputusan menentang $opponent, tetapi kami pernah melihat malam seperti ini sebelum ini. Apa yang berbeza kali ini?';
  }

  @override
  String pressMomentBigLossWarm3(String opponent) {
    return 'Semua orang ada malam yang buruk, dan itulah satu menentang $opponent. Secepat mana anda boleh melupakannya?';
  }

  @override
  String pressMomentBigLossNeutral3(String opponent) {
    return '$opponent lebih baik dalam setiap aspek. Dari mana anda mula membaikinya?';
  }

  @override
  String pressMomentBigLossHostile3(String opponent) {
    return 'Penyokong sudah beredar sebelum tamat menentang $opponent. Bolehkah anda menyalahkan mereka?';
  }

  @override
  String pressMomentCrisisWarm3(String opponent) {
    return 'Ini rentetan yang sukar, dan $opponent tidak memudahkannya. Apa yang membuatkan anda terus bertahan?';
  }

  @override
  String pressMomentCrisisNeutral3(String opponent) {
    return 'Satu lagi perlawanan tanpa kemenangan, kali ini menentang $opponent. Berapa lama lagi sebelum lembaga bertindak?';
  }

  @override
  String pressMomentCrisisHostile3(String opponent) {
    return '$opponent juga. Adakah masih ada apa-apa dalam rancangan anda, atau sudah tiba masanya memberi laluan kepada orang lain?';
  }

  @override
  String get pressReplyCreditPlayers5 =>
      'Apa sahaja yang anda tulis, tulislah tentang pemain. Mereka layak mendapatnya.';

  @override
  String get pressReplyCreditPlayers6 =>
      'Saya ada kumpulan yang sanggup berkorban untuk satu sama lain. Itu bukan perkara kecil.';

  @override
  String get pressReplyTakeResponsibility5 =>
      'Saya membuat keputusan, jadi kritikan datang kepada saya. Itulah tugasnya.';

  @override
  String get pressReplyTakeResponsibility6 =>
      'Lihat jurulatih dahulu. Saya membuat kesilapan dan saya akan membetulkannya.';

  @override
  String get pressReplyDemandMore5 =>
      'Bagus tidak cukup bagus di sini. Saya sudah beritahu mereka secara berdepan.';

  @override
  String get pressReplyDemandMore6 =>
      'Tiada siapa di bilik persalinan itu dijamin tempat. Mereka tahu sekarang.';

  @override
  String get pressReplyDeflect5 =>
      'Anda boleh bertanya dengan tiga cara berbeza. Jawapannya tetap sama.';

  @override
  String get pressReplyDeflect6 =>
      'Saya simpan pendapat saya untuk pemain. Anda faham.';

  @override
  String yWinRoutine12(String opponent, String score) {
    return '$score menentang $opponent. Bola sepak yang tenang, terkawal dan matang. Seronok melihatnya.';
  }

  @override
  String yWinRoutine13(String opponent, String score) {
    return 'Tewaskan $opponent $score tanpa berpeluh. Pasukan ini semakin pandai bermain membosankan, dan membosankan memenangi trofi.';
  }

  @override
  String yWinRoutine14(String opponent, String score) {
    return '$opponent $score. Tiga mata, tiada drama, kembali bekerja.';
  }

  @override
  String yWinRoutine15(String opponent, String score) {
    return '$score yang rutin menentang $opponent. Tiada siapa akan ingat dan tiada siapa perlu ingat.';
  }

  @override
  String yWinRoutine16(String opponent, String score) {
    return '$score menentang $opponent dan entah kenapa saya masih risau.';
  }

  @override
  String yWinRoutine17(String opponent, String score) {
    return 'Tewaskan $opponent $score. Menentang pasukan sebenar, persembahan itu akan dihukum.';
  }

  @override
  String yWinTight12(String opponent, String score) {
    return '$score menentang $opponent. Bertahan, menderita, menang. Itulah pasukan.';
  }

  @override
  String yWinTight13(String opponent, String score) {
    return 'Tewaskan $opponent $score dengan semangat semata-mata. Saya mahukan pasukan yang enggan kalah.';
  }

  @override
  String yWinTight14(String opponent, String score) {
    return '$opponent $score. Sehingga saat akhir, tetapi mata milik kita.';
  }

  @override
  String yWinTight15(String opponent, String score) {
    return '$score yang tipis ke atas $opponent. Tidak banyak bezanya, dan itulah bola sepak.';
  }

  @override
  String yWinTight16(String opponent, String score) {
    return '$score menentang $opponent. Satu lantunan bertuah ke arah lain dan kita sedang bercakap tentang perkara yang sangat berbeza.';
  }

  @override
  String yWinTight17(String opponent, String score) {
    return 'Bertahan menentang $opponent, $score. Tiada siapa patut memanggil itu satu persembahan.';
  }

  @override
  String yDrew12(String opponent, String score) {
    return '$score dengan $opponent. Bukan kekalahan, dan ada hari itulah tugasnya.';
  }

  @override
  String yDrew13(String opponent, String score) {
    return 'Satu mata yang diperoleh dengan susah payah menentang $opponent, $score. Saya suka semangat juang kita.';
  }

  @override
  String yDrew14(String opponent, String score) {
    return '$opponent $score. Sama kuat, seperti kata pengulas lama.';
  }

  @override
  String yDrew15(String opponent, String score) {
    return '$score dengan $opponent. Kedua-dua pasukan tidak cukup berusaha untuk layak mendapat lebih.';
  }

  @override
  String yDrew16(String opponent, String score) {
    return '$score dengan $opponent. Jenis seri yang terasa seperti kekalahan dalam bas pulang.';
  }

  @override
  String yDrew17(String opponent, String score) {
    return 'Seri $score dengan $opponent. Kita terus bercakap tentang kemajuan dan terus buat begini.';
  }

  @override
  String yLost12(String opponent, String score) {
    return '$score kepada $opponent. Ia menyakitkan, tetapi saya nampak cukup untuk percaya pada pasukan ini.';
  }

  @override
  String yLost13(String opponent, String score) {
    return 'Tewas $score kepada $opponent, dan mereka memang bagus. Hormati dan cuba lagi.';
  }

  @override
  String yLost14(String opponent, String score) {
    return '$opponent $score. Satu kekalahan, beberapa pengajaran, dan perlawanan seterusnya tidak lama lagi.';
  }

  @override
  String yLost15(String opponent, String score) {
    return 'Tewas $score kepada $opponent. Sukar untuk dipertikaikan.';
  }

  @override
  String yLost16(String opponent, String score) {
    return '$score kepada $opponent. Kesilapan yang sama seperti kali lepas, dilakukan dengan keyakinan yang sama.';
  }

  @override
  String yLost17(String opponent, String score) {
    return 'Tewas $score kepada $opponent. Kalau tiada siapa bertanggungjawab atas itu, apa yang kita buat?';
  }

  @override
  String get yReactionShrug12 =>
      'Okey bagi saya. Bukan setiap malam perlukan bunga api.';

  @override
  String get yReactionShrug13 => 'Mata tetap mata. Tidur lena malam ini.';

  @override
  String get yReactionShrug14 => 'Sudah tengok. Tiada komen.';

  @override
  String get yReactionShrug15 => 'Antara okey dan okey.';

  @override
  String get yReactionShrug16 =>
      'Bayar penstriman untuk itu. Tak akan lagi (saya akan kembali).';

  @override
  String get yReactionShrug17 =>
      'Sembilan puluh minit kekosongan berbentuk bola sepak.';

  @override
  String get yReactionRelief12 =>
      'Boleh bernafas semula. Bangga mereka bertahan.';

  @override
  String get yReactionRelief13 =>
      'Itulah kemenangan yang membina pasukan. Hodoh itu indah.';

  @override
  String get yReactionRelief14 => 'Kuku saya habis tapi mata tidak.';

  @override
  String get yReactionRelief15 =>
      'Wisel penamat tidak pernah kedengaran sebaik ini.';

  @override
  String get yReactionRelief16 =>
      'Gembira kita menang, risau dengan cara kita menang.';

  @override
  String get yReactionRelief17 => 'Kita asyik terlepas. Satu hari nanti tidak.';

  @override
  String get yReactionFury12 =>
      'Saya sayang pasukan ini, dan sebab itulah ia menyakitkan.';

  @override
  String get yReactionFury13 =>
      'Malam yang buruk. Mereka berhutang dengan kita lain kali, dan mereka tahu.';

  @override
  String get yReactionFury14 =>
      'Tutup TV selepas tujuh puluh minit. Patutnya enam puluh.';

  @override
  String get yReactionFury15 => 'Tiada semangat, tiada idea, tiada alasan.';

  @override
  String get yReactionFury16 =>
      'Masalah sama setiap kali, dan tiada siapa membetulkan apa-apa.';

  @override
  String get yReactionFury17 =>
      'Seseorang di persatuan perlu tonton semula dan terangkannya.';

  @override
  String get backupShareHint =>
      'Membuat satu fail sandaran untuk semua simpanan. Pilih Google Drive, iCloud Drive atau Fail untuk menyimpannya.';

  @override
  String backupLastAt(String date) {
    return 'Sandaran terakhir: $date';
  }

  @override
  String get backupNever => 'Belum ada sandaran';

  @override
  String get backupRemindersTitle => 'Peringatan sandaran';

  @override
  String get backupRemindersBlurb =>
      'Nota dalam peti masuk anda apabila sandaran terakhir semakin lama.';

  @override
  String get backupAutoICloudTitle => 'Sandaran iCloud automatik';

  @override
  String get backupAutoDriveTitle => 'Sandaran Google Drive automatik';

  @override
  String get backupAutoBlurb =>
      'Menyandarkan selepas perlawanan, pada akhir kitaran dan apabila anda meninggalkan aplikasi. Menyimpan dua yang terkini.';

  @override
  String get backupStatusUploading => 'Sedang menyandarkan.';

  @override
  String get backupStatusUploaded => 'Disandarkan.';

  @override
  String get backupStatusICloudSignedOut =>
      'iCloud dimatikan. Log masuk ke iCloud dan hidupkan iCloud Drive dalam aplikasi Tetapan.';

  @override
  String get backupStatusDriveSignedOut =>
      'Belum log masuk. Hidupkan suis untuk log masuk dengan Google.';

  @override
  String get backupStatusNotConfigured =>
      'Belum tersedia dalam versi aplikasi ini.';

  @override
  String get backupStatusUnavailable =>
      'Awan tidak dapat dicapai sekarang. Ia akan cuba lagi kemudian.';

  @override
  String get backupStatusFailed =>
      'Sandaran automatik terakhir tidak berjaya. Ia akan cuba lagi kemudian.';

  @override
  String backupDriveSignedInAs(String email) {
    return 'Log masuk sebagai $email';
  }

  @override
  String get backupDriveSignOut => 'LOG KELUAR';

  @override
  String get backupDriveSignInFailed =>
      'Log masuk Google tidak berjaya. Cuba lagi kemudian.';

  @override
  String get backupRestoreICloud => 'PULIHKAN DARIPADA ICLOUD';

  @override
  String get backupRestoreDrive => 'PULIHKAN DARIPADA GOOGLE DRIVE';

  @override
  String get backupCrossPlatformHelp =>
      'Berpindah antara iPhone dan Android? Sandarkan ke fail pada satu telefon, kemudian pulihkan daripada fail itu pada telefon yang lain.';

  @override
  String get backupCloudListBlurb =>
      'Sandaran daripada peranti anda pada akaun ini. Ketik satu untuk memulihkannya.';

  @override
  String get backupCloudListEmpty =>
      'Belum ada sandaran dijumpai. Sandaran baharu mungkin mengambil masa beberapa minit untuk sampai ke peranti lain.';

  @override
  String get backupCloudListFailed =>
      'Sandaran tidak dapat dibaca. Semak sambungan anda dan cuba lagi.';

  @override
  String get backupCloudThisDevice => 'Peranti ini';

  @override
  String backupCloudMore(int count) {
    return 'Simpanan lain: $count';
  }

  @override
  String get backupCloudNewer =>
      'Dibuat oleh versi aplikasi yang lebih baharu. Kemas kini dahulu.';

  @override
  String get backupCloudDownloading => 'Mengambil sandaran.';

  @override
  String get backupRestoreSafetyNote =>
      'Salinan simpanan di telefon ini disimpan di telefon ini terlebih dahulu.';

  @override
  String get backupRejectedSafety =>
      'Salinan simpanan semasa tidak dapat disimpan, jadi tiada apa yang digantikan.';

  @override
  String get newsBackupReminderTitle => 'Masa untuk sandaran';

  @override
  String get newsBackupReminderBody =>
      'Simpanan anda hanya ada di telefon ini. Buka Tetapan dan ketik Sandarkan ke awan, atau hidupkan sandaran automatik di sana. Peringatan ini juga boleh dimatikan dalam Tetapan.';

  @override
  String get backupSafetyTitle => 'Salinan sebelum pemulihan';

  @override
  String get backupSafetyBlurb =>
      'Disimpan di telefon ini sekiranya pemulihan itu salah. Tiga yang terbaharu disimpan.';

  @override
  String get backupSafetyRestore => 'PULIHKAN';

  @override
  String get backupSafetyShare => 'KONGSI';

  @override
  String get backupCloudNoDetails => 'Butiran masih dalam perjalanan.';

  @override
  String get tacticsLibraryTitle => 'PERPUSTAKAAN TAKTIK';

  @override
  String get tacticsLibraryBlurb =>
      'Taktik dalam perpustakaan anda boleh dimuatkan dalam mana-mana simpanan, termasuk yang baharu. Peranan dan penyepak bola mati disimpan mengikut posisi, bukan mengikut pemain.';

  @override
  String get tacticsSaveToLibrary => 'Simpan ke perpustakaan';

  @override
  String get tacticsLoadFromLibrary => 'Muat dari perpustakaan';

  @override
  String get tacticsLibraryEmpty =>
      'Perpustakaan anda kosong. Simpan taktik di sini dan anda boleh memuatkannya dalam mana-mana simpanan.';

  @override
  String tacticsLibrarySaved(String name) {
    return '“$name” disimpan ke perpustakaan anda';
  }

  @override
  String tacticsLibraryLoaded(String name) {
    return '“$name” dimuatkan';
  }

  @override
  String tacticsLibraryNotFitted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count peranan atau penyepak bola mati tidak sesuai dengan skuad ini.',
      one: '1 peranan atau penyepak bola mati tidak sesuai dengan skuad ini.',
    );
    return '$_temp0';
  }

  @override
  String get tacticsLibraryRename => 'Namakan semula';

  @override
  String get tacticsLibraryRenameTitle => 'Namakan semula taktik';

  @override
  String get tacticsLibraryDelete => 'Padam';

  @override
  String tacticsLibraryDeleteTitle(String name) {
    return 'Padam “$name”?';
  }

  @override
  String get tacticsLibraryDeleteBody =>
      'Ia akan hilang daripada perpustakaan dalam semua simpanan anda.';

  @override
  String get tacticsLibraryNameTaken =>
      'Perpustakaan anda sudah mempunyai taktik dengan nama itu.';

  @override
  String tacticsLibraryCouldNotLoad(String error) {
    return 'Perpustakaan tidak dapat dimuatkan.\n$error';
  }

  @override
  String hostBidHeading(String competition, int year) {
    return 'Bidaan tuan rumah: $competition $year';
  }

  @override
  String get hostBidScreenTitle => 'Bidaan tuan rumah';

  @override
  String get hostBidBlurb =>
      'Tuan rumah dipilih melalui cabutan undi dalam kalangan calon. Bidaan memberi lebih sokongan kepada nama anda: stadium anda memberi peluang permulaan, dan wang menambahnya, dengan setiap juta tambahan memberi kesan sedikit kurang. Wang itu dibelanjakan sama ada anda menang atau tidak.';

  @override
  String hostBidPrize(String amount) {
    return 'Jika menang, anda menjadi tuan rumah, layak secara automatik dan menerima geran sekali sahaja sebanyak $amount untuk bajet seterusnya.';
  }

  @override
  String get hostBidChance => 'Peluang menjadi tuan rumah';

  @override
  String get hostBidBaseLabel => 'Stadium dan kedudukan';

  @override
  String get hostBidInvestLabel => 'Pelaburan';

  @override
  String hostBidCeiling(String nation, String percent) {
    return 'Had maksimum $nation: $percent';
  }

  @override
  String get hostBidInvestment => 'Pelaburan anda';

  @override
  String hostBidFreeFunds(String amount) {
    return 'Dana bebas: $amount';
  }

  @override
  String get hostBidSubmit => 'Hantar bidaan';

  @override
  String get hostBidDecline => 'Bukan kali ini';

  @override
  String get hostBidUnavailable => 'Bidaan ini sudah ditutup.';

  @override
  String hostBidWonTitle(String competition, int year) {
    return 'Bidaan berjaya: $competition $year';
  }

  @override
  String hostBidWonBody(String amount) {
    return 'Kita akan menjadi tuan rumah kejohanan dan layak secara automatik sebagai tuan rumah. Geran sekali sahaja sebanyak $amount kini ada dalam dana persatuan, dan anda boleh mengagihkannya kepada jabatan-jabatan kitaran ini terus dari hab.';
  }

  @override
  String hostBidLostTitle(String competition, int year) {
    return 'Bidaan gagal: $competition $year';
  }

  @override
  String hostBidLostBody(String hosts) {
    return '$hosts memenangi hak menjadi tuan rumah. Bidaan kita tidak mencukupi kali ini, dan wang yang dibelanjakan sudah hilang, tetapi persatuan telah membentangkan hujahnya.';
  }

  @override
  String get hostBidGrantEvent => 'Agihkan geran tuan rumah';

  @override
  String hostBidGrantBanner(String amount) {
    return 'Geran tuan rumah: $amount untuk ditambah kepada jabatan-jabatan kitaran ini sekarang. Apa yang sudah ditetapkan kekal, dan bakinya disimpan dalam bank.';
  }

  @override
  String get stadiumsTitle => 'Stadium nasional';

  @override
  String get stadiumsEntrySub => 'Naik taraf stadium atau bina yang baharu';

  @override
  String get stadiumsBlurb =>
      'Tahap stadium ialah saiznya: tahap 1 bawah 15,000 tempat duduk, tahap 2 dari 15,000, tahap 3 dari 25,000, tahap 4 dari 40,000, tahap 5 dari 60,000. Setiap stadium menjana pendapatan kecil pada awal setiap kitaran, lebih banyak tempat duduk lebih banyak pendapatan, selagi penyokong dapat memenuhinya. Naik taraf menambah tempat duduk serta-merta dan sedikit reputasi mulai kitaran seterusnya; mengecilkan stadium mengurangkan kos penyelenggaraan tetapi tiada bayaran balik. Stadium anda menentukan kejohanan mana yang boleh anda bida.';

  @override
  String stadiumsIncome(String amount) {
    return 'Pendapatan stadium: $amount setiap kitaran';
  }

  @override
  String stadiumsReputation(int points) {
    return 'Reputasi daripada stadium: +$points';
  }

  @override
  String get stadiumsClosed =>
      'Kerja-kerja ditempah pada awal kitaran, sebelum bajet ditetapkan.';

  @override
  String stadiumsCapacity(String seats) {
    return 'Kapasiti: $seats';
  }

  @override
  String stadiumsLevel(int level, int max) {
    return 'Tahap $level/$max';
  }

  @override
  String stadiumsUpgrade(String cost) {
    return 'Naik taraf: $cost';
  }

  @override
  String get stadiumsTopLevel => 'Tahap tertinggi';

  @override
  String stadiumsOpens(int year) {
    return 'Dalam pembinaan, dibuka pada $year';
  }

  @override
  String get stadiumsBuildTitle => 'Bina stadium baharu';

  @override
  String get stadiumsBuildBody =>
      'Agak mahal: stadium baharu di bandar pilihan anda, dibuka mulai awal kitaran seterusnya.';

  @override
  String get stadiumsBuildCity => 'Bandar';

  @override
  String stadiumsBuildButton(String cost) {
    return 'Bina: $cost';
  }

  @override
  String get stadiumsBuilding => 'Sebuah stadium sedang dibina.';

  @override
  String get stadiumsNoCity => 'Setiap bandar sudah mempunyai stadium baharu.';

  @override
  String stadiumsConfirmUpgrade(String stadium, int level, String cost) {
    return 'Naik taraf $stadium ke tahap $level dengan kos $cost?';
  }

  @override
  String stadiumsConfirmBuild(String city, String cost) {
    return 'Bina stadium baharu di $city dengan kos $cost?';
  }

  @override
  String get stadiumsConfirm => 'Sahkan';

  @override
  String get stadiumsCancel => 'Batal';

  @override
  String get stadiumsRefused => 'Tempahan tidak berjaya. Tiada caj dikenakan.';

  @override
  String get stadiumsNameLabel => 'Nama stadium';

  @override
  String get stadiumsNameHint =>
      'Biarkan kosong untuk mengekalkan nama yang dicadangkan.';

  @override
  String get stadiumsRename => 'Tukar nama stadium';

  @override
  String get hostBidSectionTitle => 'Bidaan tuan rumah';

  @override
  String get hostBidOpenSub =>
      'Pilihan. Putuskan sebelum kitaran baharu bermula.';

  @override
  String get hostBidDecidedAtRollover =>
      'Tuan rumah diumumkan apabila kitaran baharu bermula.';

  @override
  String get hostBidLodged =>
      'Bidaan dihantar. Tuan rumah diumumkan apabila kitaran baharu bermula.';

  @override
  String get hostBidDeclinedNote =>
      'Kali ini anda memilih untuk tidak membida.';

  @override
  String get hostBidOpensLater =>
      'Layak. Anda boleh membida pada akhir kitaran ini.';

  @override
  String get hostBidNoFunds => 'Dana bebas tidak mencukupi untuk membida.';

  @override
  String hostBidNeedStadiums(int count, String seats) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Anda perlukan $count lagi stadium berkapasiti $seats+ tempat duduk.',
      one: 'Anda perlukan 1 lagi stadium berkapasiti $seats+ tempat duduk.',
    );
    return '$_temp0';
  }

  @override
  String hostBidBarredConf(String confederation) {
    return '$confederation menjadi tuan rumah Kejohanan Dunia yang lalu.';
  }

  @override
  String get hostBidRecentHost =>
      'Anda menjadi tuan rumah salah satu daripada tiga edisi terakhir.';

  @override
  String hostBidRequirement(
    int grounds,
    String minSeats,
    int bigGrounds,
    String bigSeats,
  ) {
    return 'Syarat: $grounds stadium berkapasiti $minSeats+ tempat duduk, $bigGrounds daripadanya $bigSeats+.';
  }

  @override
  String hostBidWonBodyBudget(String amount) {
    return 'Kita akan menjadi tuan rumah kejohanan dan layak secara automatik sebagai tuan rumah. Geran sekali bayar sebanyak $amount sudah masuk ke dana persekutuan, sedia untuk bajet kitaran ini.';
  }

  @override
  String get hubStadiumIncome => 'Pendapatan stadium';

  @override
  String get stadiumsDownsize => 'Kecilkan';

  @override
  String stadiumsConfirmDownsize(String stadium, String seats, int level) {
    return 'Kecilkan $stadium kepada $seats tempat duduk (tahap $level)? Tiada bayaran balik, tetapi kos penyelenggaraan turun.';
  }

  @override
  String get stadiumsResizedThisCycle => 'Diubah suai kitaran ini';

  @override
  String stadiumsGroundIncome(String amount) {
    return 'Menjana $amount setiap kitaran';
  }

  @override
  String hostBidLapsedTitle(String competition, int year) {
    return 'Bidaan ditarik balik: $competition $year';
  }

  @override
  String hostBidLapsedBodyNation(String nation) {
    return 'Bidaan dibuat untuk $nation, tetapi anda memulakan kitaran baharu di tempat lain. Ia ditarik balik dan tiada caj dikenakan.';
  }

  @override
  String get hostBidLapsedBodyFunds =>
      'Apabila kitaran ditutup, dana persekutuan tidak lagi mencukupi untuk bidaan itu. Bidaan ditarik balik dan tiada caj dikenakan.';

  @override
  String get stadiumsViewMap => 'Peta';

  @override
  String get stadiumsViewList => 'Senarai';

  @override
  String get stadiumsMapPickCity =>
      'Ketik sebuah bandar untuk membina stadium baharu di sana.';

  @override
  String get stadiumsMapFit => 'Tunjukkan seluruh negara';

  @override
  String get campaignLegacyTitle => 'Lengkapkan Legasi';

  @override
  String get campaignLegacyTwist =>
      'Sepanyol, juara Eropah semasa, untuk satu kitaran';

  @override
  String get campaignLegacyGoal => 'Pertahankan gelaran Eropah';

  @override
  String get campaignLegacyIntro =>
      'Sepanyol ialah juara Eropah semasa, dan mereka yang ragu-ragu menganggap zaman kegemilangan itu hanya nasib. Anda ada satu kitaran untuk membuktikan sebaliknya: pertahankan mahkota benua, kemudian buru dunia. Tambah Piala Negara-Negara dan legasi itu lengkap.';

  @override
  String get campaignStars1Legacy => 'Menangi Kejohanan Eropah';

  @override
  String get campaignStars2Legacy => 'Dan Kejohanan Dunia';

  @override
  String get campaignStars3Legacy => 'Dan Piala Negara-Negara';

  @override
  String get campaignSectionOneCycle => 'Satu kitaran';

  @override
  String get campaignSectionShort => 'Beberapa kitaran';

  @override
  String get campaignSectionLong => 'Jangka panjang';

  @override
  String get campaignFilterAll => 'Semua';

  @override
  String get campaignFilterNew => 'Belum dimainkan';

  @override
  String get campaignFilterInProgress => 'Sedang berjalan';

  @override
  String get campaignFilterDone => 'Selesai';

  @override
  String get campaignFilterEmpty => 'Belum ada kempen di sini.';

  @override
  String campaignStarsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bintang',
      zero: 'Tiada bintang',
    );
    return '$_temp0';
  }

  @override
  String campaignCycles(int cycles) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles kitaran',
    );
    return '$_temp0';
  }

  @override
  String get msgIntlRetireNoteHigh => ' Dia bersara di puncak, sebagai juara.';

  @override
  String get msgIntlRetireNoteMissed =>
      ' Gagal ke pusingan akhir menjadi penyebab terakhir.';

  @override
  String get msgIntlRetireNoteSurprise => ' Tiada siapa yang menjangkanya.';

  @override
  String get msgIntlRetireNoteRecord =>
      ' Dia pergi sebagai pemegang rekod skuad kebangsaan.';

  @override
  String msgIntlRetireNewsTitle(String nation, String name) {
    return '$nation: $name bersara daripada bola sepak antarabangsa';
  }

  @override
  String msgIntlRetireNewsBody(String name, String nation, int age) {
    return '$name ($nation) mengumumkan persaraan daripada bola sepak antarabangsa pada usia $age.';
  }

  @override
  String msgIntlComebackTitle(String name) {
    return '$name kembali daripada persaraan antarabangsa';
  }

  @override
  String msgIntlComebackBody(String name, int age) {
    return '$name kembali tersedia untuk dipanggil pada usia $age.';
  }

  @override
  String get msgIntlComebackNoteCrisis =>
      ' Dengan skuad dilanda kecederaan, dia menyahut panggilan.';

  @override
  String get msgIntlComebackNoteManager =>
      ' Jurulatih baharu berjaya memujuknya.';

  @override
  String msgIntlComebackNewsTitle(String nation, String name) {
    return '$nation: $name kembali daripada persaraan antarabangsa';
  }

  @override
  String msgIntlComebackNewsBody(String name, String nation, int age) {
    return '$name ($nation) kembali tersedia untuk dipanggil pada usia $age.';
  }

  @override
  String playerIntlRetired(int year) {
    return 'Bersara daripada skuad kebangsaan, $year';
  }

  @override
  String playerIntlComeback(int year) {
    return 'Kembali ke skuad kebangsaan, $year';
  }

  @override
  String yLegendRetires0(String name) {
    return 'Terima kasih, $name. Ada yang sekadar memakai jersi, dia memikul pasukan.';
  }

  @override
  String yLegendRetires1(String name) {
    return '$name menamatkan karier antarabangsanya. Berakhirnya satu era.';
  }

  @override
  String yLegendRetires2(String name) {
    return '$name bersara. Jujurnya, lewat satu kejohanan.';
  }

  @override
  String yLegendRetires3(String name) {
    return 'Jadi $name sudah selesai. Masa untuk beri peluang kepada pemain muda.';
  }

  @override
  String matchAltitudeOpponentsTire(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'Ketinggian $altitudeString m: pihak lawan akan cepat letih';
  }

  @override
  String matchAltitudeYouTire(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'Ketinggian $altitudeString m: pemain anda akan cepat letih';
  }

  @override
  String matchAltitudeBothTire(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'Ketinggian $altitudeString m: kedua-dua pasukan akan cepat letih';
  }

  @override
  String matchAltitudeUsedTo(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'Ketinggian $altitudeString m: kedua-dua pasukan sudah biasa';
  }

  @override
  String matchHeatExpected(int temp) {
    final intl.NumberFormat tempNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String tempString = tempNumberFormat.format(temp);

    return 'Panas: dijangka $tempString°C, tenaga akan habis lebih awal';
  }

  @override
  String get matchConditionsAdvice =>
      'Rancang pertukaran awal: kaki yang segar lebih bernilai di sini';

  @override
  String get fanMoodFurious => 'berang';

  @override
  String get fanMoodRestless => 'gelisah';

  @override
  String get fanMoodCalm => 'tenang';

  @override
  String get fanMoodUpbeat => 'bersemangat';

  @override
  String get fanMoodEuphoric => 'gembira ria';

  @override
  String matchHomeFans(String mood) {
    return 'Penyokong tuan rumah: $mood';
  }

  @override
  String federationFans(String mood) {
    return 'Penyokong: $mood';
  }

  @override
  String federationFansIncome(String change) {
    return 'Pendapatan stadium kitaran seterusnya: $change';
  }

  @override
  String yFansProtest0(String nation, String manager) {
    return 'Dua puluh tahun mengikut skuad kebangsaan di laman sendiri dan di tempat lawan. Saya tidak akan memperbaharui tiket musim selagi tiada perubahan.';
  }

  @override
  String yFansProtest1(String nation, String manager) {
    return 'Kami akan terus menyanyi untuk jersi ini. Tetapi kain rentang di bahagian utara stadium malam ini menyatakan apa yang kami semua fikirkan.';
  }

  @override
  String yFansProtest2(String nation, String manager) {
    return 'Separuh stadium kosong, dan separuh lagi menghabiskan separuh masa kedua dengan melaungkan #${manager}Out.';
  }

  @override
  String yFansProtest3(String nation, String manager) {
    return 'Kumpulan penyokong bercakap tentang memboikot perlawanan di laman sendiri yang seterusnya. Sukar untuk menyalahkan mereka.';
  }

  @override
  String yFansProtest4(String nation, String manager) {
    return '#${manager}Out. Sudah tidak marah lagi. Cukuplah.';
  }

  @override
  String yFansProtest5(String nation, String manager) {
    return 'Gambar malam ini: barisan kerusi kosong dan sehelai cadar tertulis #${manager}Out. Itulah laporan perlawanannya.';
  }

  @override
  String yFansSellOut0(String nation) {
    return 'Tiket habis dijual lagi. Skuad kebangsaan terbaik dalam beberapa tahun, dan seluruh negara tahu.';
  }

  @override
  String yFansSellOut1(String nation) {
    return 'Tiket perlawanan di laman sendiri yang seterusnya habis dalam sebelas minit. Pasukan ini mengembalikan hujung minggu kami.';
  }

  @override
  String yFansSellOut2(String nation) {
    return 'Tiada sebuah kerusi kosong untuk perlawanan di laman sendiri yang seterusnya. Persatuan akan mengira kutipan tiket sambil tersenyum.';
  }

  @override
  String yFansSellOut3(String nation) {
    return 'Habis dijual lagi. Cakaplah apa saja tentang taktiknya, orang ramai mahu berada di stadium itu.';
  }

  @override
  String yFansSellOut4(String nation) {
    return 'Habis dijual, baiklah. Orang yang sama mengejek pasukan ini setahun setengah yang lalu.';
  }

  @override
  String yFansSellOut5(String nation) {
    return 'Tiba-tiba habis dijual, tiba-tiba semua pakar. Ke mana kamu semua ketika kita tidak mampu menewaskan sesiapa?';
  }

  @override
  String get campaignsIntro =>
      'Kempen ialah cabaran yang direka khas: pasukan kebangsaan yang ditetapkan, dunia dengan kelainannya sendiri dan matlamat yang perlu dicapai dalam bilangan kitaran yang tetap. Setiap percubaan diasingkan daripada kerjaya yang disimpan, dan semakin jauh anda pergi, semakin banyak bintang yang anda peroleh, sehingga tiga.';

  @override
  String hubEventScandal(String player) {
    return 'Skandal di kem latihan: $player';
  }

  @override
  String get hubEventScandalSub => 'Hantar pulang atau kekalkan?';

  @override
  String get scandalTitle => 'SKANDAL';

  @override
  String scandalStoryParty(String player) {
    return '$player berada di parti yang berlarutan hingga subuh, dan gambarnya terpampang di semua akhbar pada pagi skuad berkumpul.';
  }

  @override
  String scandalStoryCurfew(String player) {
    return '$player melanggar perintah berkurung pasukan dan ditangkap pulang ke hotel awal pagi.';
  }

  @override
  String scandalStoryNightclub(String player) {
    return '$player dirakam di kelab malam pada malam sebelum kem latihan, dan gambarnya tersebar di mana-mana.';
  }

  @override
  String scandalStoryCasino(String player) {
    return '$player menghabiskan malam sebelum kem latihan di meja kasino, dan sebuah tabloid memiliki gambarnya.';
  }

  @override
  String get scandalSendHome => 'Hantar dia pulang';

  @override
  String scandalSendHomeCover(String player) {
    return 'Hantar pulang, panggil $player';
  }

  @override
  String scandalKeep(String player) {
    return 'Kekalkan $player';
  }

  @override
  String get scandalKeepNote =>
      'Jika dikekalkan: moral kira-kira -4 dan lembaga kira-kira -3 hingga akhir kitaran.';

  @override
  String get scandalSendHomeNote =>
      'Jika dihantar pulang: tiada kesan pada moral atau lembaga, dan anda boleh memanggil pengganti.';

  @override
  String get scandalFinalsNote =>
      'Jika dihantar pulang: tiada kesan pada moral atau lembaga, tetapi di kejohanan akhir tiada sesiapa boleh menggantikannya.';

  @override
  String get scandalPickCover => 'Panggil pengganti (pilihan)';

  @override
  String newsScandalTitle(String player) {
    return 'Skandal di kem latihan: $player';
  }

  @override
  String yScandalParty0(String player, String tag) {
    return 'Biasalah orang muda. $player berparti malam sebelum kem, tetapi saya tetap mahu dia di padang. #$tag';
  }

  @override
  String yScandalParty1(String player, String tag) {
    return '$player dirakam di parti semalaman beberapa jam sebelum skuad berkumpul. Persatuan sudah dimaklumkan. #$tag';
  }

  @override
  String yScandalParty2(String player, String tag) {
    return 'Parti semalaman sebelum kem. $player, apa yang awak fikirkan? Tak masuk akal. #$tag';
  }

  @override
  String yScandalCurfew0(String player, String tag) {
    return 'Pulang lewat perintah berkurung, tak apa, ia berlaku. $player cuma perlu menebusnya di padang. #$tag';
  }

  @override
  String yScandalCurfew1(String player, String tag) {
    return '$player ditangkap pulang ke hotel pasukan selepas perintah berkurung, beberapa jam sebelum latihan. #$tag';
  }

  @override
  String yScandalCurfew2(String player, String tag) {
    return 'Perintah berkurung tidak rumit. $player tak tahan walaupun satu malam. #$tag';
  }

  @override
  String yScandalNightclub0(String player, String tag) {
    return 'Jadi $player ke kelab. Pemain bola pun ada kehidupan. Biar dia bermain. #$tag';
  }

  @override
  String yScandalNightclub1(String player, String tag) {
    return 'Gambar menunjukkan $player di kelab malam pada malam sebelum kem skuad kebangsaan. #$tag';
  }

  @override
  String yScandalNightclub2(String player, String tag) {
    return 'Gambar kelab pada malam sebelum kem. $player memalukan jersi negara. #$tag';
  }

  @override
  String yScandalCasino0(String player, String tag) {
    return 'Semalam di kasino bukan jenayah. $player akan okey. #$tag';
  }

  @override
  String yScandalCasino1(String player, String tag) {
    return '$player dilihat di meja kasino pada malam sebelum skuad berkumpul. #$tag';
  }

  @override
  String yScandalCasino2(String player, String tag) {
    return 'Semalaman di kasino sebelum kem. $player mempertaruhkan lebih daripada wang. #$tag';
  }

  @override
  String yScandalSentHome0(String player) {
    return 'Keputusan tepat. Tiada siapa lebih besar daripada pasukan, termasuk $player.';
  }

  @override
  String yScandalSentHome1(String player) {
    return 'Menghantar $player pulang ialah satu-satunya jawapan. Hormat kepada jurulatih.';
  }

  @override
  String yScandalSentHome2(String player) {
    return 'Disiplin tetap disiplin. $player tahu peraturannya.';
  }

  @override
  String yScandalSentHome3(String player) {
    return 'Mesej jelas kepada skuad: $player sudah dalam pesawat pulang.';
  }

  @override
  String yScandalSentHome4(String player) {
    return 'Keras terhadap $player. Keluar satu malam dan kemnya tamat?';
  }

  @override
  String yScandalSentHome5(String player) {
    return 'Menghantar $player pulang melemahkan kita. Kita akan membayarnya di padang.';
  }

  @override
  String yScandalKept0(String player) {
    return 'Mengekalkan $player satu pertaruhan. Dia patut membalasnya di padang.';
  }

  @override
  String yScandalKept1(String player) {
    return 'Baiklah, $player kekal. Jadi dia berhutang persembahan hebat kepada semua.';
  }

  @override
  String yScandalKept2(String player) {
    return 'Jadi peraturan tidak terpakai untuk $player. Bagus untuk tahu.';
  }

  @override
  String yScandalKept3(String player) {
    return 'Perintah berkurung kini pilihan, nampaknya. Tanya saja $player.';
  }

  @override
  String yScandalKept4(String player) {
    return 'Kekalkan $player selepas itu? Skuad ini dah jadi kem percutian.';
  }

  @override
  String yScandalKept5(String player) {
    return 'Parti semalaman, kemudian terus ke kesebelasan utama. Mesej yang hebat, jurulatih. $player tentu gembira.';
  }

  @override
  String get yStreamerBreaks0 =>
      'BRO KANTOI 😭😭 MALAM SEBELUM KEM?? AKU MENANGIS 💀💀💀';

  @override
  String get yStreamerBreaks1 =>
      'TAKKK CHAT TENGOK NI 🤯🤯 BRO BETUL-BETUL BUAT SEBELUM KEM 😭🔥';

  @override
  String get yStreamerBreaks2 =>
      'SIAPA LEPASKAN DIA?? SIAPA LEPASKAN 😭😭💀 INI MEMANG WAYANG 🔥🔥';

  @override
  String get yStreamerSentHome0 =>
      'PULANG?? DIHANTAR PULANG!!! 😭😭😭 JURULATIH TAK MAIN-MAIN 💀🔥';

  @override
  String get yStreamerSentHome1 =>
      'BRO KEMAS BEG SECARA LANGSUNG 🤯🤯 SELAMAT TINGGAL BRO 😭👋';

  @override
  String get yStreamerSentHome2 =>
      'TAK MUNGKINNN DIA DIHANTAR PULANG 💀💀 CHAT AKU MENGGIGIL 🔥🔥🔥';

  @override
  String get yStreamerKept0 =>
      'DIA KEKAL??? DIA KEKALLL 🤯🤯 BRO TAK BOLEH DISENTUH 😭🔥';

  @override
  String get yStreamerKept1 =>
      'PARTI SEMALAMAN DAN MASIH DALAM SKUAD 💀💀 AKU NAK KONTRAK TU 😭😭';

  @override
  String get yStreamerKept2 => 'JURULATIH KATA OKEY 😭😭 BRO APA NI 🤯🤯🤯';

  @override
  String get yCameoUjfaloci =>
      'Saya tidak membayar apa-apa, dan jumlah itu juga tidak sepadan';

  @override
  String get yCameoHavir0 => 'Ikan-ikan kecil sudah berenang pergi.';

  @override
  String get yCameoHavir1 => 'Kami tebarkan jala, ikannya di tempat lain.';

  @override
  String get yCameoHavir2 =>
      'Saya dah kata sejak September lagi, sambil makan gulai.';

  @override
  String get yCameoHavir3 =>
      'Siapa tak memancing tepat pada masanya, jangan menangis sekarang.';

  @override
  String get yCameoHavir4 => 'Kami bermain macam ikan keli di darat.';

  @override
  String get yCameoHavir5 => 'Angin bertiup, kolam membeku. Begitulah hidup.';

  @override
  String get yCameoHavir6 => 'Ada hari yang ditarik naik cuma but lama.';

  @override
  String get yCameoHavir7 =>
      'Zaman saya, sekurang-kurangnya kami pergi minum bir. Sekarang itu pun tiada.';

  @override
  String get yCameoLzimberskyHome0 =>
      'Hantar budak pulang kerana satu malam? Itulah skandalnya, bukan parti!';

  @override
  String get yCameoLzimberskyHome1 =>
      'Budak-budak pun berhak berseronok! Media hipokrit menang lagi.';

  @override
  String get yCameoLzimberskyHome2 =>
      'Ini pemburuan ahli sihir. Anak muda keluar satu malam dan kamu gantung dia.';

  @override
  String get yCameoLzimberskyHome3 =>
      'Wartawan yang tak pernah ke parti, silakan baling batu pertama. Memalukan!';

  @override
  String get yCameoLzimberskyHome4 =>
      'Jurulatih takut tabloid. Saya akan bela budak itu hingga nafas terakhir!';

  @override
  String get yCameoLzimberskyKept0 =>
      'Akhirnya jurulatih yang bertulang belakang! Dia kekalkan budak itu, biar media menangis.';

  @override
  String get yCameoLzimberskyKept1 =>
      'Budak-budak pun berhak berseronok, kan? Bravo, jurulatih!';

  @override
  String get yCameoLzimberskyKept2 =>
      'Media hipokrit menjerit, jurulatih tetap teguh. Begitulah caranya!';

  @override
  String get yCameoLzimberskyKept3 =>
      'Satu malam keluar dan akhbar mahu merejamnya. Jurulatih itu lelaki sejati!';

  @override
  String get yCameoLzimberskyKept4 =>
      'Saya kata: biarkan budak-budak hidup! Siapa kerja keras, berhak berseronok. Ibu jari ke atas.';

  @override
  String get yTraitStreamer =>
      'Menstrim segalanya, dengan suara paling kuat, dalam huruf besar.';

  @override
  String hubEventAwardsCeremony(int year) {
    return 'Pemain Terbaik Tahunan $year';
  }

  @override
  String get hubEventAwardsCeremonySub => 'Undian telah dikira';

  @override
  String get potyCeremonyWatch => 'Tonton majlis';

  @override
  String get potyCeremonySkipToList => 'Terus ke lima teratas';

  @override
  String get potyCeremonySkip => 'Langkau';

  @override
  String get potyCeremonyIntro =>
      'Undian telah dikira. Inilah lima pemain terbaik dunia tahun ini.';

  @override
  String potyCeremonyPlace(int place) {
    return 'Tempat ke-$place';
  }

  @override
  String get potyCeremonyWinnerIs => 'Dan Pemain Terbaik Tahunan ialah...';

  @override
  String get potyTop5Heading => 'Lima teratas dunia';

  @override
  String get potyYoungTop3Heading =>
      'Pemain Muda Terbaik Tahunan: tiga teratas';

  @override
  String get potySeeTop5 => 'Lihat lima teratas';

  @override
  String get potyYourPlayer => 'Pemain anda';

  @override
  String potyTallyCleanSheets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count perlawanan tanpa bolos',
    );
    return '$_temp0';
  }

  @override
  String get campaignFullBrief => 'Taklimat penuh';

  @override
  String campaignStarsSoFar(int earned, int total) {
    return 'Bintang diraih setakat ini: $earned daripada $total';
  }

  @override
  String get campaignStarEarned => 'Sudah diraih';

  @override
  String get campaignStarNotYet => 'Belum diraih';

  @override
  String get stadiumsEntrySubClosed =>
      'Lihat stadium anda. Kerja dibuka semula pada awal kitaran seterusnya.';

  @override
  String get boardObjectiveNoBrief => 'Tiada objektif ditetapkan';

  @override
  String get boardObjectiveNoBriefBody =>
      'Lembaga tidak menjangka anda layak ke pusingan akhir ini. Anda akan dinilai berdasarkan keputusan.';

  @override
  String get boardObjectiveAwaitingDraw => 'Objektif selepas cabutan';

  @override
  String get boardObjectiveAwaitingDrawBody =>
      'Lembaga akan menetapkan objektif ini selepas cabutan kumpulan.';
}
