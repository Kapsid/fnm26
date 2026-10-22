// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get matchPreviewTitle => 'PRATINJAU LAGA';

  @override
  String get matchKickOff => 'Kick off';

  @override
  String get matchTactics => 'Taktik';

  @override
  String get matchYourXi => 'SUSUNAN ANDA';

  @override
  String get matchHeadToHead => 'REKOR PERTEMUAN';

  @override
  String matchCouldNotLoad(String error) {
    return 'Gagal memuat laga.\n$error';
  }

  @override
  String get matchNoUpcoming => 'Tidak ada laga mendatang.';

  @override
  String get matchUnknownNation => 'Tidak diketahui';

  @override
  String get matchH2hFirstMeeting => 'Pertemuan pertama';

  @override
  String get matchH2hYouLead => 'Anda unggul dalam rekor pertemuan';

  @override
  String matchH2hOppEdge(String opponent) {
    return '$opponent lebih unggul';
  }

  @override
  String get matchH2hEven => 'Imbang';

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
  String get matchDossierTitle => 'Laporan scouting';

  @override
  String get matchDossierForm => 'PERFORMA';

  @override
  String get matchDossierNoGames => 'Belum ada laga terbaru';

  @override
  String get matchDossierKeyMen => 'PEMAIN KUNCI';

  @override
  String matchCouldNotContinue(String error) {
    return 'Gagal melanjutkan: $error';
  }

  @override
  String get matchSkipToFullTime => 'Lewati ke peluit akhir';

  @override
  String get matchStatShots => 'Tembakan';

  @override
  String get matchStatGoals => 'Gol';

  @override
  String get matchStatYellowCards => 'Kuning';

  @override
  String get matchStatRedCards => 'Merah';

  @override
  String get matchMomentum => 'MOMENTUM';

  @override
  String get matchSwingAtk => 'SER';

  @override
  String get matchSwingDef => 'BEL';

  @override
  String ceremonyWorldCupYear(int year) {
    return 'KEJUARAAN DUNIA $year';
  }

  @override
  String get ceremonyFinalsAreHere => 'PUTARAN FINAL TELAH TIBA';

  @override
  String ceremonyHostedBy(String hosts) {
    return 'TUAN RUMAH  $hosts';
  }

  @override
  String get ceremonyHostTbc => 'TUAN RUMAH BELUM DITENTUKAN';

  @override
  String get matchHalfTime => 'TURUN MINUM';

  @override
  String get matchContinue => 'Lanjutkan';

  @override
  String get matchContinuing => 'Melanjutkan…';

  @override
  String matchTacticsWithSubs(int used, int max) {
    return 'Taktik · $used/$max pergantian';
  }

  @override
  String matchTiredCount(int count) {
    return 'LELAH ×$count';
  }

  @override
  String get matchTacticsLabel => 'TAKTIK';

  @override
  String get teamOverallOverTime => 'RATING KESELURUHAN SEPANJANG WAKTU';

  @override
  String get teamOverall => 'Rating keseluruhan';

  @override
  String get teamTalkHeading => 'ARAHAN PELATIH';

  @override
  String get teamTalkPrompt => 'Tentukan nada untuk babak kedua.';

  @override
  String get teamTalkCalmLabel => 'Tetap tenang';

  @override
  String get teamTalkCalmBlurb =>
      'Tenangkan tim. Sedikit dorongan di semua lini.';

  @override
  String get teamTalkEncourageLabel => 'Beri semangat';

  @override
  String get teamTalkEncourageBlurb => 'Maju ke depan dan kuasai laga.';

  @override
  String get teamTalkDemandMoreLabel => 'Tuntut lebih';

  @override
  String get teamTalkDemandMoreBlurb =>
      'Kerahkan segalanya. Serang habis-habisan.';

  @override
  String get teamTalkPraiseLabel => 'Jaga rapat';

  @override
  String get teamTalkPraiseBlurb => 'Tetap rapat dan pertahankan keunggulan.';

  @override
  String get teamTalkBelieveLabel => 'Percaya diri';

  @override
  String get teamTalkBelieveBlurb =>
      'Percayai diri sendiri. Dorongan di kedua ujung lapangan.';

  @override
  String get teamTalkFocusLabel => 'Tetap fokus';

  @override
  String get teamTalkFocusBlurb => 'Konsentrasi penuh. Kunci laga ini.';

  @override
  String get teamTalkUrgencyLabel => 'Rasa mendesak';

  @override
  String get teamTalkUrgencyBlurb =>
      'Kejar sekarang juga. Habis-habisan, tapi celah terbuka.';

  @override
  String get teamTalkReassureLabel => 'Tanpa tekanan';

  @override
  String get teamTalkReassureBlurb => 'Redakan ketegangan dan jaga bentuk tim.';

  @override
  String get commonRetry => 'Coba lagi';

  @override
  String get commonSomethingWentWrong => 'Terjadi kesalahan';

  @override
  String get commonCrashBox =>
      'Terjadi kesalahan di sini.\nPengaturan → Diagnostik berisi detailnya.';

  @override
  String hubCouldNotAdvance(String error) {
    return 'Gagal memajukan dunia: $error';
  }

  @override
  String get settingsDiagnosticsTitle => 'Diagnostik';

  @override
  String get settingsDiagnosticsBlurb =>
      'Kesalahan yang tercatat di perangkat ini. Tidak ada yang dikirim ke mana pun.';

  @override
  String get settingsContactTitle => 'Kontak';

  @override
  String get settingsContactCopied => 'Alamat disalin.';

  @override
  String get settingsCommunityTitle => 'Komunitas';

  @override
  String get settingsDiscordSubtitle => 'Gabung dengan komunitas';

  @override
  String get settingsLinkCopied => 'Tautan disalin.';

  @override
  String get diagnosticsEmpty =>
      'Tidak ada kesalahan tercatat. Memang itu tujuannya.';

  @override
  String get diagnosticsCopy => 'Salin';

  @override
  String get diagnosticsCopied => 'Log disalin ke papan klip.';

  @override
  String get diagnosticsClear => 'Hapus';

  @override
  String get navHub => 'Beranda';

  @override
  String get navSquad => 'Skuad';

  @override
  String get navStandings => 'Klasemen';

  @override
  String get navCareers => 'Karier Saya';

  @override
  String get settingsTitle => 'PENGATURAN';

  @override
  String get settingsSoundHapticsTitle => 'Suara & getaran';

  @override
  String get settingsSoundHapticsBlurb =>
      'Getaran dan nada singkat saat gol, kick off, dan peluit akhir.';

  @override
  String get settingsLanguageTitle => 'Bahasa';

  @override
  String get settingsLanguageBlurb =>
      'Pilih bahasa aplikasi, atau ikuti perangkat Anda.';

  @override
  String get settingsLanguageSystem => 'Sistem';

  @override
  String get matchPreviewAllMeetings => 'Semua pertemuan';

  @override
  String get recordsMeetings => 'PERTEMUAN';

  @override
  String get recordsLegends => 'LEGENDA';

  @override
  String get recordsAllTimeXi => 'SUSUNAN TERBAIK SEPANJANG MASA';

  @override
  String get recordsHallOfFame => 'HALL OF FAME';

  @override
  String get recordsAllTimeWorld => 'DUNIA SEPANJANG MASA';

  @override
  String get recordsAllTimeTopScorers =>
      'PENCETAK GOL TERBANYAK SEPANJANG MASA';

  @override
  String get recordsMostCapped => 'PENAMPILAN TERBANYAK';

  @override
  String get recordsMostWcStarts => 'INTI TERBANYAK KEJUARAAN DUNIA';

  @override
  String get recordsMostTournaments => 'TURNAMEN TERBANYAK DIIKUTI';

  @override
  String get recordsRecordBook => 'BUKU REKOR';

  @override
  String get recordsHeadToHead => 'REKOR PERTEMUAN';

  @override
  String get recordsFiercestRival => 'RIVAL TERSENGIT';

  @override
  String get recordsMostCaps => 'CAPS TERBANYAK';

  @override
  String get recordsTopScorers => 'PENCETAK GOL TERBANYAK';

  @override
  String get recordsMostAssists => 'ASSIST TERBANYAK';

  @override
  String get recordsYourRecord => 'REKOR ANDA';

  @override
  String get callUpHome => 'KANDANG';

  @override
  String get callUpAway => 'TANDANG';

  @override
  String get recordsHome => 'KANDANG';

  @override
  String get recordsAway => 'TANDANG';

  @override
  String get recordsActive => 'AKTIF';

  @override
  String get recordsStillActive => 'Masih aktif';

  @override
  String get recordsAvg => 'rata-rata';

  @override
  String get recordsSelect => 'Pilih';

  @override
  String get recordsVs => 'vs';

  @override
  String get recordsDraws => 'Seri';

  @override
  String get recordsGoalsLabel => 'Gol';

  @override
  String get recordsBestFinish => 'Hasil terbaik';

  @override
  String get recordsNoFinalsYet => 'Belum pernah tampil di putaran final';

  @override
  String get recordsLongestUnbeaten => 'Tak terkalahkan terlama';

  @override
  String get recordsBiggestWin => 'Kemenangan terbesar';

  @override
  String get recordsSeeAllMeetings => 'Lihat semua pertemuan';

  @override
  String get recordsSaveNotFound => 'Simpanan tidak ditemukan.';

  @override
  String get recordsNoMatches => 'Tidak ada hasil.';

  @override
  String get recordsSearchPlayerOrNation => 'Cari pemain atau negara';

  @override
  String get recordsSearchNation => 'Cari negara';

  @override
  String get recordsPickTwoDifferent => 'Pilih dua negara yang berbeda.';

  @override
  String get recordsPlayToBuildRecord =>
      'Mainkan beberapa laga dan rekor Anda melawan tiap lawan akan terbentuk di sini.';

  @override
  String get recordsTapOpponent => 'Ketuk lawan untuk rincian lengkap.';

  @override
  String get recordsEdgeUpperHand => 'Anda di atas angin';

  @override
  String get recordsEdgeTheirNumber => 'Mereka menguasai Anda';

  @override
  String get recordsEdgeEven => 'Imbang';

  @override
  String get recordsAllTimeWorldSubtitle =>
      'Pencetak gol dan caps terbanyak global, semua negara';

  @override
  String get recordsHeadToHeadSubtitle =>
      'Bandingkan rekor dua negara sepanjang masa';

  @override
  String get recordsLegendsSubtitle =>
      'Susunan terbaik sepanjang masa & hall of fame';

  @override
  String get recordsUnitGoals => 'gol';

  @override
  String get recordsUnitCaps => 'caps';

  @override
  String get recordsUnitStarts => 'starter';

  @override
  String get recordsUnitCups => 'turnamen';

  @override
  String get recordsUnitAssists => 'assist';

  @override
  String recordsCapsCount(int count) {
    return '$count caps';
  }

  @override
  String recordsGoalsCount(int count) {
    return '$count gol';
  }

  @override
  String recordsAssistsCount(int count) {
    return '$count assist';
  }

  @override
  String recordsMotmCount(int count) {
    return '$count MOTM';
  }

  @override
  String recordsMatchesCount(int count) {
    return '$count laga';
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
    return '$a dan $b belum pernah bertemu di simpanan ini.';
  }

  @override
  String tacticsSentOffNote(String names) {
    return '$names diusir wasit. Tanpa pengganti, jadi Anda bermain dengan sepuluh orang.';
  }

  @override
  String tacticsNeedFitPlayers(int required, int have) {
    return 'Butuh $required pemain tersedia ($have bugar)';
  }

  @override
  String tacticsMissesOfCamp(int missed, int total) {
    return 'Absen $missed/$total';
  }

  @override
  String get tacticsOutForWholeCamp => 'Absen sepanjang pemanggilan ini';

  @override
  String get rankingCentreOnMe => 'Pusatkan ke negara saya';

  @override
  String get recordsAfterExtraTime => 'p.w.';

  @override
  String recordsOnPenalties(int a, int b) {
    return '$a–$b adu penalti';
  }

  @override
  String recordsVersus(String a, String b) {
    return '$a vs $b';
  }

  @override
  String recordsPlayedScore(int played, int gf, int ga) {
    return '$played laga · $gf–$ga';
  }

  @override
  String recordsBiggestWinValue(int gf, int ga, String opp) {
    return '$gf–$ga lawan $opp';
  }

  @override
  String recordsCouldNotLoad(String error) {
    return 'Gagal memuat.\n$error';
  }

  @override
  String recordsCouldNotLoadLegends(String error) {
    return 'Gagal memuat legenda.\n$error';
  }

  @override
  String recordsCouldNotLoadRecords(String error) {
    return 'Gagal memuat rekor.\n$error';
  }

  @override
  String recordsCouldNotLoadNations(String error) {
    return 'Gagal memuat negara.\n$error';
  }

  @override
  String recordsCouldNotLoadYourRecord(String error) {
    return 'Gagal memuat rekor Anda.\n$error';
  }

  @override
  String recordsCouldNotLoadRecord(String error) {
    return 'Gagal memuat rekor.\n$error';
  }

  @override
  String recordsNoLegends(String nation) {
    return 'Belum ada legenda. Mainkan beberapa kampanye dan para bintang $nation akan muncul di sini.';
  }

  @override
  String recordsGreatestSide(String nation) {
    return 'Tim terhebat yang bisa diturunkan $nation.';
  }

  @override
  String get recordsNoWorldHistory =>
      'Dunia belum punya sejarah. Mainkan beberapa kampanye dan para bintang sepanjang masa akan muncul di sini.';

  @override
  String recordsPlayToWriteHistory(String nation) {
    return 'Mainkan beberapa laga untuk mulai menulis sejarah $nation.';
  }

  @override
  String get tacticsLineGk => 'KIP';

  @override
  String get tacticsLineDef => 'BEK';

  @override
  String get tacticsLineMid => 'GEL';

  @override
  String get tacticsLineFwd => 'PEN';

  @override
  String get tacticsGoalkeepers => 'KIPER';

  @override
  String get tacticsDefenders => 'BEK';

  @override
  String get tacticsMidfielders => 'GELANDANG';

  @override
  String get tacticsForwards => 'PENYERANG';

  @override
  String get tacticsCallUpsTitle => 'PEMANGGILAN';

  @override
  String tacticsPickAtLeastPlayers(int min) {
    return 'Pilih minimal $min pemain.';
  }

  @override
  String tacticsCouldNotLoadSquad(String error) {
    return 'Gagal memuat skuad.\n$error';
  }

  @override
  String get tacticsNoSquad => 'Tidak ada skuad.';

  @override
  String tacticsSquadCount(int count, int max) {
    return 'SKUAD · $count/$max';
  }

  @override
  String tacticsMinMax(int min, int max) {
    return 'Min $min · Maks $max';
  }

  @override
  String get tacticsBestQuality => 'Kualitas terbaik';

  @override
  String get tacticsPreviousSquad => 'Skuad sebelumnya';

  @override
  String get tacticsSquadLockedBack => 'Kembali (skuad terkunci)';

  @override
  String get tacticsConfirmSquad => 'Konfirmasi skuad';

  @override
  String tacticsSquadFullMax(int max) {
    return 'Skuad penuh (maks $max)';
  }

  @override
  String get tacticsSquadLocked => 'SKUAD TERKUNCI';

  @override
  String get tacticsNominationOpen => 'NOMINASI DIBUKA. PILIH SKUAD ANDA';

  @override
  String get tacticsSquadFixedBlurb =>
      'Skuad ini tetap untuk laga di bawah. Pilih ulang sebelum jendela nominasi berikutnya.';

  @override
  String get tacticsSquadWillPlayBlurb =>
      'Skuad ini akan memainkan laga di bawah.';

  @override
  String get tacticsUnknown => 'Tidak diketahui';

  @override
  String tacticsAgeValue(int age, String value) {
    return 'Usia $age · $value';
  }

  @override
  String get tacticsFatigueExhausted => 'Kehabisan tenaga';

  @override
  String get tacticsFatigueTired => 'Lelah';

  @override
  String get tacticsFatigueMatchLegs => 'Kaki laga';

  @override
  String tacticsTooManySubs(int max) {
    return 'Terlalu banyak pergantian (maks $max).';
  }

  @override
  String tacticsMinuteTitle(int minute) {
    return 'TAKTIK · $minute\'';
  }

  @override
  String get tacticsApply => 'TERAPKAN';

  @override
  String get tacticsTabLineupSubs => 'SUSUNAN & CADANGAN';

  @override
  String get tacticsTabTactics => 'TAKTIK';

  @override
  String get squadLineKeepers => 'KIPER';

  @override
  String get squadLineDefenders => 'PERTAHANAN';

  @override
  String get squadLineMidfielders => 'TENGAH';

  @override
  String get squadLineForwards => 'SERANGAN';

  @override
  String get squadStatXiRating => 'Rating XI';

  @override
  String get squadStatAvgAge => 'Usia rata-rata';

  @override
  String get squadStatSize => 'Skuad';

  @override
  String get squadStatUnavailable => 'Absen';

  @override
  String get squadDepthTitle => 'KEDALAMAN PER LINI';

  @override
  String squadAgeShort(int age) {
    return '$age th';
  }

  @override
  String get tacticsTabOtherPositions => 'POSISI LAIN';

  @override
  String get tacticsOutOfPositionNote => 'Di luar posisi';

  @override
  String get tacticsNobodyElse => 'Tidak ada lagi yang bisa dicoba di sini.';

  @override
  String get tacticsPickSomebodyFirst =>
      'Pilih siapa yang keluar dan sisa bangku cadangan muncul di sini, lengkap dengan rating mereka di posisi ini.';

  @override
  String get tacticsTabSuitable => 'COCOK';

  @override
  String get tacticsTabOnPitch => 'DI LAPANGAN';

  @override
  String tacticsSectionSuitable(int count) {
    return 'COCOK · $count';
  }

  @override
  String get tacticsNobodySuits =>
      'Tidak ada pemain cadangan yang cocok secara alami untuk posisi ini, jadi ini semuanya.';

  @override
  String tacticsSectionOnPitch(int count, int max) {
    return 'DI LAPANGAN · $count/$max';
  }

  @override
  String tacticsSectionAvailable(int count) {
    return 'TERSEDIA · $count';
  }

  @override
  String get tacticsRowStarted => 'Starter';

  @override
  String tacticsRowCameOn(int minute) {
    return 'Masuk menit $minute\'';
  }

  @override
  String get tacticsRowSubstitute => 'Masuk';

  @override
  String get tacticsEnergyLabel => 'ENERGI';

  @override
  String tacticsPickReplacementFor(String name) {
    return 'Ketuk pengganti untuk $name, atau ketuk lagi untuk membatalkan.';
  }

  @override
  String get tacticsSlotLostToRedCard =>
      'Kartu merah membuat Anda kehilangan posisi ini. Seret rekan setim ke sini untuk menutup celah.';

  @override
  String get tacticsSentOffShort => 'DIUSIR';

  @override
  String tacticsSubsUsed(int used, int max) {
    return 'GANTI · $used/$max';
  }

  @override
  String get tacticsDragSubOn =>
      'Ketuk pemain di lapangan untuk menariknya keluar, atau tahan dan seret pemain cadangan ke atasnya.';

  @override
  String get tacticsNoSubs => 'Tidak ada pemain cadangan.';

  @override
  String get tacticsChooseShape => 'PILIH FORMASI';

  @override
  String get tacticsFormation => 'FORMASI';

  @override
  String get tacticsInstructions => 'INSTRUKSI';

  @override
  String get tacticsDrilling => 'LATIHAN';

  @override
  String get tacticsDrillingUnplayed => 'BELUM DIMAINKAN';

  @override
  String get tacticsDrillingNew => 'BARU';

  @override
  String get tacticsDrillingSettling => 'MULAI MENYATU';

  @override
  String get tacticsDrillingDrilled => 'MATANG';

  @override
  String get tacticsInstrMentality => 'Mentalitas';

  @override
  String get tacticsInstrDefensive => 'Bertahan';

  @override
  String get tacticsInstrAttacking => 'Menyerang';

  @override
  String get tacticsInstrPressing => 'Pressing';

  @override
  String get tacticsInstrLowBlock => 'Blok rendah';

  @override
  String get tacticsInstrHighPress => 'Pressing tinggi';

  @override
  String get tacticsInstrTempo => 'Tempo';

  @override
  String get tacticsInstrPatient => 'Sabar';

  @override
  String get tacticsInstrFast => 'Cepat';

  @override
  String get tacticsInstrWidth => 'Lebar';

  @override
  String get tacticsInstrNarrow => 'Sempit';

  @override
  String get tacticsInstrWide => 'Lebar';

  @override
  String get tacticsInstrDefLine => 'Garis bek';

  @override
  String get tacticsInstrDefensiveLine => 'Garis pertahanan';

  @override
  String get tacticsInstrDeep => 'Dalam';

  @override
  String get tacticsInstrHigh => 'Tinggi';

  @override
  String get tacticsInstrDirectness => 'Kelangsungan';

  @override
  String get tacticsInstrPossession => 'Penguasaan bola';

  @override
  String get tacticsInstrDirect => 'Langsung';

  @override
  String get tacticsPickGoalkeeper => 'PILIH KIPER';

  @override
  String get tacticsPickLeftBack => 'PILIH BEK KIRI';

  @override
  String get tacticsPickCentreBack => 'PILIH BEK TENGAH';

  @override
  String get tacticsPickRightBack => 'PILIH BEK KANAN';

  @override
  String get tacticsPickDefensiveMid => 'PILIH GELANDANG BERTAHAN';

  @override
  String get tacticsPickCentralMid => 'PILIH GELANDANG TENGAH';

  @override
  String get tacticsPickAttackingMid => 'PILIH GELANDANG SERANG';

  @override
  String get tacticsPickLeftMid => 'PILIH GELANDANG KIRI';

  @override
  String get tacticsPickRightMid => 'PILIH GELANDANG KANAN';

  @override
  String get tacticsPickLeftWing => 'PILIH SAYAP KIRI';

  @override
  String get tacticsPickRightWing => 'PILIH SAYAP KANAN';

  @override
  String get tacticsPickStriker => 'PILIH PENYERANG TENGAH';

  @override
  String tacticsRoleOutOfPosition(String role) {
    return '$role · di luar posisi';
  }

  @override
  String tacticsAgeOnly(int age) {
    return 'Usia $age';
  }

  @override
  String tacticsRoleAge(String role, int age) {
    return '$role · Usia $age';
  }

  @override
  String get tacticsOn => 'MAIN';

  @override
  String get tacticsSquad => 'SKUAD';

  @override
  String get tacticsTabLineup => 'SUSUNAN';

  @override
  String get tacticsTabInstructions => 'INSTRUKSI';

  @override
  String get tacticsTabRoles => 'PERAN';

  @override
  String get tacticsTabSetPieces => 'BOLA MATI';

  @override
  String get tacticsTabRolesSetPieces => 'PERAN & BOLA MATI';

  @override
  String get tacticsRolesSetPiecesBlurb =>
      'Beri tiap pemain inti sebuah peran. Ketuk lencana penalti (⚽) atau tendangan bebas (▲) untuk menunjuk eksekutor.';

  @override
  String get tacticsTooltipCallUps => 'Pemanggilan';

  @override
  String get tacticsTooltipPresets => 'Preset taktik';

  @override
  String get tacticsTooltipInstructions => 'Instruksi';

  @override
  String get tacticsNoTacticSet => 'Belum ada taktik.';

  @override
  String tacticsReplaceStarters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'GANTI $count PEMAIN INTI',
    );
    return '$_temp0';
  }

  @override
  String tacticsPlayerOut(String name, String reason) {
    return '$name: $reason';
  }

  @override
  String get tacticsOut => 'Absen';

  @override
  String get tacticsTapSpotReplace =>
      'Ketuk posisinya di lapangan untuk memilih pengganti.';

  @override
  String get tacticsTapOrDrag =>
      'Ketuk pemain untuk menggantinya, atau tahan dan seret untuk memindahkannya.';

  @override
  String get tacticsPlayerRoles => 'PERAN PEMAIN';

  @override
  String get tacticsRolesBlurb =>
      'Beri pemain sebuah tugas: poacher, pengatur serangan, target man. Menentukan siapa yang mencetak gol dan siapa yang menciptakan peluang.';

  @override
  String get tacticsSetPieceTakers => 'EKSEKUTOR BOLA MATI';

  @override
  String get tacticsSetPieceBlurb =>
      'Siapa yang mengambil penalti dan bola mati, atau serahkan pada pemain yang paling cocok.';

  @override
  String get tacticsTakerAuto => 'Otomatis';

  @override
  String get tacticsTakerQuickPick => 'Pakai eksekutor terbaik';

  @override
  String get tacticsPenalties => 'Penalti';

  @override
  String get tacticsCornersFreeKicks => 'Tendangan sudut & tendangan bebas';

  @override
  String get tacticsSkillFin => 'FIN';

  @override
  String get tacticsSkillPas => 'PAS';

  @override
  String tacticsRolePlayer(String name) {
    return 'PERAN · $name';
  }

  @override
  String get tacticsPenaltyTaker => 'EKSEKUTOR PENALTI';

  @override
  String get tacticsCornerFreeKickTaker => 'EKSEKUTOR SUDUT & TENDANGAN BEBAS';

  @override
  String get tacticsAutomatic => 'Otomatis';

  @override
  String get tacticsLetBestSuited => 'Serahkan pada pemain yang paling cocok.';

  @override
  String get tacticsInXi => 'DI XI';

  @override
  String get tacticsTeamInstructions => 'INSTRUKSI TIM';

  @override
  String get tacticsTeamInstructionsBlurb =>
      'Atur cara tim Anda bermain. Setiap kenop memengaruhi seluruh tim.';

  @override
  String tacticsSavedPreset(String name) {
    return 'Tersimpan “$name”';
  }

  @override
  String tacticsAppliedPreset(String name) {
    return 'Diterapkan “$name”';
  }

  @override
  String get tacticsTacticPresets => 'PRESET TAKTIK';

  @override
  String get tacticsPresetsBlurb =>
      'Simpan formasi ini sebagai gaya yang bisa dipakai ulang, atau terapkan yang pernah Anda simpan.';

  @override
  String get tacticsSaveCurrentTactic => 'Simpan taktik saat ini';

  @override
  String tacticsCouldNotLoadPresets(String error) {
    return 'Gagal memuat preset.\n$error';
  }

  @override
  String get tacticsNoPresetsYet =>
      'Belum ada preset. Ketuk “Simpan taktik saat ini” untuk menyimpan susunan ini sebagai gaya yang bisa dipakai ulang.';

  @override
  String get tacticsNameThisTactic => 'Beri nama taktik ini';

  @override
  String get tacticsNameHint => 'mis. Pressing tinggi 4-3-3';

  @override
  String get tacticsCancel => 'Batal';

  @override
  String get tacticsSave => 'Simpan';

  @override
  String get tacticsTapToAssign => 'Ketuk untuk menunjuk';

  @override
  String get tacticsHoldDragSub =>
      'Tahan pemain cadangan, lalu seret ke pemain untuk memasukkannya.';

  @override
  String get hubContinue => 'Lanjutkan';

  @override
  String get hubBrackets => 'Bagan';

  @override
  String hubCouldNotLoad(String error) {
    return 'Gagal memuat.\n$error';
  }

  @override
  String hubCouldNotLoadFinances(String error) {
    return 'Gagal memuat keuangan.\n$error';
  }

  @override
  String hubCouldNotLoadSave(String error) {
    return 'Gagal memuat simpanan.\n$error';
  }

  @override
  String get hubSaveNotFound => 'Simpanan tidak ditemukan.';

  @override
  String get hubUnknown => 'Tidak diketahui';

  @override
  String hubWorldChampionsYear(int year) {
    return 'JUARA DUNIA $year';
  }

  @override
  String get hubCycleComplete => 'Siklus telah selesai.';

  @override
  String get hubYourJob => 'JABATAN ANDA';

  @override
  String get hubStayProject => 'Bertahan dan lanjutkan proyek Anda';

  @override
  String get hubChooseNextJob => 'PILIH JABATAN BERIKUTNYA';

  @override
  String get hubOffersOnTable => 'TAWARAN YANG ADA';

  @override
  String hubOfferSubtitle(String tier, int position) {
    return '$tier · peringkat dunia #$position';
  }

  @override
  String hubContinueWith(String nation) {
    return 'Lanjutkan bersama $nation';
  }

  @override
  String get hubYourNation => 'negara Anda';

  @override
  String get hubTakeTheJob => 'Ambil jabatan';

  @override
  String get hubFederationFinances => 'KEUANGAN FEDERASI';

  @override
  String get hubBudgetIntro =>
      'Tugas pertama Anda di siklus berikutnya adalah menetapkan anggaran federasi dan membaginya ke tiap departemen.';

  @override
  String get hubStarting => 'Memulai…';

  @override
  String get hubBeginNextCycle => 'Mulai siklus berikutnya';

  @override
  String get hubContinueCareer => 'Lanjutkan karier Anda';

  @override
  String get hubBackToSaves => 'Kembali ke simpanan Anda';

  @override
  String get hubOpeningBalance => 'Saldo awal';

  @override
  String get hubCentralFunding => 'Dana pusat';

  @override
  String get hubPrizeMoney => 'Hadiah uang';

  @override
  String get hubCommercialReturn => 'Pendapatan komersial';

  @override
  String get hubAvailableToInvest => 'Tersedia untuk diinvestasikan';

  @override
  String hubReputation(String label, int rep) {
    return 'Reputasi: $label ($rep)';
  }

  @override
  String get hubNationalHero => 'Pahlawan nasional';

  @override
  String get hubFinal => 'Final';

  @override
  String get hubStageRoundOf32 => 'Babak 32 besar';

  @override
  String get hubStageThirdPlace => 'Perebutan tempat ketiga';

  @override
  String get hubEventAdvanceWorld => 'Majukan dunia';

  @override
  String hubEventStartCycle(int year) {
    return 'Mulai siklus $year';
  }

  @override
  String hubEventWorldChampions(String nation) {
    return '$nation adalah Juara Dunia';
  }

  @override
  String get hubEventSetBudget => 'Tetapkan anggaran federasi Anda';

  @override
  String get hubEventSetBudgetSub =>
      'Bagikan dana siklus ini sebelum musim dimulai';

  @override
  String get hubEventNaturalization => 'Tinjau tawaran naturalisasi';

  @override
  String get hubEventNaturalizationSub =>
      'Seorang pemain asing ingin membela negara Anda';

  @override
  String get hubEventCampaignVerdict => 'Kampanye selesai: lihat putusannya';

  @override
  String get hubEventCampaignComplete => 'Kampanye selesai';

  @override
  String get hubEventIntercontinentalPlayoff => 'Play-off antarbenua';

  @override
  String get hubEventWatchWcDraw => 'Tonton undian Kejuaraan Dunia';

  @override
  String get hubEventWorldCupHere => 'Kejuaraan Dunia telah tiba';

  @override
  String get hubEventWatchFinalsDraw => 'Tonton undian putaran final';

  @override
  String get hubEventFinalsHere => 'Putaran final telah tiba';

  @override
  String get hubEventPlayWcRound => 'Mainkan babak Kejuaraan Dunia berikutnya';

  @override
  String hubEventPlayCupMatch(String cup) {
    return 'Mainkan laga $cup berikutnya';
  }

  @override
  String get hubEventPlayNationsCupMatch =>
      'Mainkan laga Piala Bangsa-Bangsa berikutnya';

  @override
  String get hubEventWatchNationsCupDraw => 'Tonton undian Piala Bangsa-Bangsa';

  @override
  String get hubEventWatchHostSelection => 'Tonton pemilihan tuan rumah';

  @override
  String get hubEventWatchQualifyingDraw => 'Tonton undian kualifikasi';

  @override
  String get hubEventWatchWcHostSelection =>
      'Tonton pemilihan tuan rumah Kejuaraan Dunia';

  @override
  String get hubEventWatchWcQualifyingDraw =>
      'Tonton undian kualifikasi Kejuaraan Dunia';

  @override
  String get hubEventArrangeFriendlies => 'Atur laga uji coba';

  @override
  String hubEventFriendliesSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Anda belum mengisi $count jendela uji coba yang terbuka',
      one: 'Anda belum mengisi jendela uji coba yang terbuka',
    );
    return '$_temp0';
  }

  @override
  String get hubEventReshapeXi => 'Bentuk ulang susunan pemain inti';

  @override
  String hubEventReshapeOutSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count pemain inti Anda absen (skorsing atau cedera). Pilih penggantinya',
      one:
          '1 pemain inti Anda absen (skorsing atau cedera). Pilih penggantinya',
    );
    return '$_temp0';
  }

  @override
  String hubEventReshapeShortSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Susunan pemain inti Anda kurang. Isi posisi yang kosong',
      one: 'Susunan pemain inti Anda kurang. Isi posisi yang kosong',
    );
    return '$_temp0';
  }

  @override
  String hubEventPlayOpponent(String opponent) {
    return 'Hadapi $opponent';
  }

  @override
  String get hubEventContinentalFinalsFallback => 'putaran final benua';

  @override
  String get hubCallUpFriendlies => 'Tunjuk skuad untuk laga uji coba';

  @override
  String get hubCallUpRequalify => 'Tunjuk ulang skuad kualifikasi';

  @override
  String get hubCallUpWorldCup => 'Tunjuk skuad Kejuaraan Dunia';

  @override
  String get hubCallUpFinals => 'Tunjuk skuad untuk putaran final';

  @override
  String get hubCallUpNationsCup => 'Tunjuk skuad Piala Bangsa-Bangsa';

  @override
  String get hubCallUpQualifying => 'Tunjuk skuad kualifikasi';

  @override
  String get hubCallUpGeneric => 'Tunjuk skuad';

  @override
  String get hubHost => 'Tuan rumah';

  @override
  String get hubGoldenBoot => 'Sepatu Emas';

  @override
  String hubGoldenBootValue(String name, int goals) {
    return '$name · $goals gol';
  }

  @override
  String get hubPens => '(adu penalti)';

  @override
  String get hubNationalHub => 'BERANDA NASIONAL';

  @override
  String get hubMessages => 'Pesan';

  @override
  String get hubWorldChampions => 'JUARA DUNIA';

  @override
  String get hubViewBracket => 'Lihat bagan ›';

  @override
  String get hubBoardDelighted => 'Sangat senang';

  @override
  String get hubBoardPleased => 'Puas';

  @override
  String get hubBoardExpectingMore => 'Mengharapkan lebih';

  @override
  String get hubBoardConcerned => 'Khawatir';

  @override
  String get hubBoardJobAtRisk => 'Jabatan terancam';

  @override
  String get hubBoard => 'DEWAN';

  @override
  String hubBoardObjective(String label) {
    return 'Target dewan: $label';
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
  String get hubNoMoreFixtures => 'Tidak ada jadwal laga lagi di siklus ini.';

  @override
  String get hubVs => 'VS';

  @override
  String hubWorldRank(int rank) {
    return '#$rank';
  }

  @override
  String get hubWorldRankLabel => 'Peringkat dunia';

  @override
  String get hubSquadStatus => 'STATUS SKUAD';

  @override
  String hubPlayers(int count) {
    return '$count pemain';
  }

  @override
  String get hubAvgRating => 'Rating rata-rata';

  @override
  String get hubMorale => 'Moral';

  @override
  String get hubManageTeam => 'Kelola Tim';

  @override
  String get hubGroupsToBeDrawn =>
      'Grup belum diundi. Tonton undian untuk melihatnya.';

  @override
  String hubGroupName(String name) {
    return 'GRUP $name';
  }

  @override
  String get hubTblTeam => 'TIM';

  @override
  String get hubTblP => 'M';

  @override
  String get hubTblGd => 'SG';

  @override
  String get hubTblPts => 'POIN';

  @override
  String get homeSettings => 'Pengaturan';

  @override
  String get homeLeadTheNation => 'PIMPIN NEGARA';

  @override
  String get homeYourNation => 'negara Anda';

  @override
  String get homeNewGame => 'Game Baru';

  @override
  String get homeAllSaves => 'Semua simpanan';

  @override
  String get homeLoadGame => 'Muat game';

  @override
  String get homeContinue => 'LANJUTKAN';

  @override
  String homeRoadToWorldCup(String date, int year) {
    return '$date · Jalan menuju Kejuaraan Dunia $year';
  }

  @override
  String get careerManageSaves => 'Kelola simpanan';

  @override
  String get careerNewGameTitle => 'GAME BARU';

  @override
  String careerCouldNotLoadNation(String error) {
    return 'Gagal memuat negara.\n$error';
  }

  @override
  String get careerNationNotFound => 'Negara tidak ditemukan.';

  @override
  String careerWorldRankNum(int rank) {
    return 'PERINGKAT DUNIA #$rank';
  }

  @override
  String get careerManagerName => 'Nama pelatih';

  @override
  String get careerManagerNameHint => 'mis. Shin Tae-yong';

  @override
  String get careerBeginsBlurb =>
      'Karier Anda dimulai pada September 2026, menuju Kejuaraan Dunia 2030.';

  @override
  String get careerFreeCycleNote =>
      'Gratis untuk satu siklus penuh empat tahun: kualifikasi, kejuaraan benua Anda, dan Kejuaraan Dunia, dengan dua slot simpanan. Setelah itu, satu kali pembayaran membuka siklus tanpa batas.';

  @override
  String get careerStartCareer => 'Mulai Karier';

  @override
  String get careersTitle => 'KARIER';

  @override
  String get careerManagerCareer => 'Karier pelatih';

  @override
  String get careerManagerCareerSubtitle =>
      'Setiap siklus yang Anda tangani dan rekor keseluruhan';

  @override
  String get careerSummaryTitle => 'Ringkasan karier';

  @override
  String get careerSummarySubtitle => 'Lemari trofi dan rekor pelatih Anda';

  @override
  String get careerAchievements => 'Pencapaian';

  @override
  String get careerAchievementsSubtitle => 'Tonggak, gelar, dan kepuasan dewan';

  @override
  String get careerChallenges => 'Tantangan';

  @override
  String get careerChallengesSubtitle =>
      'Ujian brutal sepanjang karier untuk ditaklukkan';

  @override
  String get careerTeamRecords => 'Rekor tim';

  @override
  String get careerTeamRecordsSubtitle =>
      'Pencetak gol dan penampilan terbanyak sepanjang masa';

  @override
  String get careerMyMatches => 'Laga saya';

  @override
  String get careerMyMatchesSubtitle =>
      'Setiap hasil dan jadwal laga mendatang';

  @override
  String get careerTitle => 'KARIER';

  @override
  String careerCouldNotLoadCareer(String error) {
    return 'Gagal memuat karier.\n$error';
  }

  @override
  String get careerNoCareer => 'Belum ada karier.';

  @override
  String get careerTrophyCabinet => 'LEMARI TROFI';

  @override
  String get careerTournamentHistory => 'SEJARAH TURNAMEN';

  @override
  String get careerNoTournamentsYet => 'Belum ada turnamen yang selesai.';

  @override
  String get careerTeamFallback => 'Tim';

  @override
  String careerWorldNum(int rank) {
    return 'DUNIA #$rank';
  }

  @override
  String careerPointsNum(int points) {
    return '$points POIN';
  }

  @override
  String careerSeasonNum(int season) {
    return 'MUSIM $season';
  }

  @override
  String get careerStatPlayedShort => 'Main';

  @override
  String get careerStatsHeading => 'DALAM ANGKA';

  @override
  String get careerStatsWinRate => 'Persentase menang';

  @override
  String get careerStatsGoalsFor => 'Gol dicetak';

  @override
  String get careerStatsGoalsAgainst => 'Gol kebobolan';

  @override
  String get careerStatsGoalDiff => 'Selisih gol';

  @override
  String get careerStatsCleanSheets => 'Clean sheet';

  @override
  String get careerStatsBiggestWin => 'Kemenangan terbesar';

  @override
  String get careerStatsWinStreak => 'Rentetan menang';

  @override
  String get careerStatsUnbeaten => 'Rentetan tak terkalahkan';

  @override
  String get careerStatsShootouts => 'Adu penalti';

  @override
  String get careerStatsHatTricks => 'Hat-trick';

  @override
  String get careerStatsMotms => 'Pemain terbaik laga';

  @override
  String get careerStatsBestRating => 'Rating terbaik';

  @override
  String get careerStatWonShort => 'M';

  @override
  String get careerStatDrawnShort => 'S';

  @override
  String get careerStatLostShort => 'K';

  @override
  String get careerStatGoalsForShort => 'GM';

  @override
  String get careerStatGoalsAgainstShort => 'GK';

  @override
  String get careerStatGoalDiffShort => 'SG';

  @override
  String get careerNoSilverware => 'Belum ada trofi. Raihlah satu.';

  @override
  String get careerMedalGold => 'EMAS';

  @override
  String get careerMedalSilver => 'PERAK';

  @override
  String get careerMedalBronze => 'PERUNGGU';

  @override
  String careerWinnersName(String name) {
    return 'Juara: $name';
  }

  @override
  String get careerSavesTitle => 'SIMPANAN';

  @override
  String careerCouldNotLoadSaves(String error) {
    return 'Gagal memuat simpanan.\n$error';
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
      'Setiap simpanan yang sudah Anda miliki tetap bisa dimainkan. Hanya simpanan baru yang perlu dibuka.';

  @override
  String get careerNewGame => 'Game Baru';

  @override
  String get careerDeleteSaveTitle => 'Hapus simpanan?';

  @override
  String careerDeleteSaveBody(String label) {
    return 'Ini akan menghapus permanen karier $label Anda.';
  }

  @override
  String get careerCancel => 'Batal';

  @override
  String get careerDelete => 'Hapus';

  @override
  String get careerNoSavesYet =>
      'Belum ada simpanan.\nMulai game baru untuk memimpin sebuah negara.';

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
    return 'Terakhir dimainkan $when';
  }

  @override
  String get careerJustNow => 'baru saja';

  @override
  String get careerYesterday => 'kemarin';

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
    return 'Menuju Kejuaraan Dunia $year';
  }

  @override
  String get careerManagerCareerTitle => 'KARIER PELATIH';

  @override
  String careerCouldNotLoad(String error) {
    return 'Gagal memuat.\n$error';
  }

  @override
  String get careerCycleByCycle => 'SIKLUS DEMI SIKLUS';

  @override
  String careerCyclesNationsLed(int cycles, int nations) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles siklus',
    );
    String _temp1 = intl.Intl.pluralLogic(
      nations,
      locale: localeName,
      other: '$nations negara ditangani',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get careerStatTitles => 'Gelar';

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
    return 'Gol $goalsFor–$goalsAgainst  ($gd)  ·  Persentase menang $winRate%';
  }

  @override
  String get careerRecordResults => 'HASIL REKOR';

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
    return '${won}M ${drawn}S ${lost}K  ·  GM $goalsFor GK $goalsAgainst ($gd)';
  }

  @override
  String get careerWorldCupLabel => 'Kejuaraan Dunia';

  @override
  String get careerContinentalLabel => 'Benua';

  @override
  String get messagesTitle => 'PESAN';

  @override
  String get messagesNoMessagesYet => 'Belum ada pesan.';

  @override
  String messagesCouldNotLoad(String error) {
    return 'Gagal memuat pesan.\n$error';
  }

  @override
  String get messagesDone => 'Selesai';

  @override
  String get messagesNext => 'Berikutnya';

  @override
  String get rankingWorldRanking => 'PERINGKAT DUNIA';

  @override
  String rankingCouldNotLoad(String error) {
    return 'Gagal memuat peringkat.\n$error';
  }

  @override
  String get rankingNoRanking => 'Belum ada peringkat.';

  @override
  String get rankingAll => 'SEMUA';

  @override
  String get rankingYourTeam => 'TIM ANDA';

  @override
  String get rankingYourRankingOverTime => 'PERINGKAT ANDA DARI WAKTU KE WAKTU';

  @override
  String rankingNowRank(int rank) {
    return 'kini #$rank';
  }

  @override
  String rankingBestWorst(int best, int worst) {
    return 'terbaik #$best · terburuk #$worst';
  }

  @override
  String get friendliesTitle => 'LAGA UJI COBA';

  @override
  String friendliesLoadError(String error) {
    return 'Gagal memuat laga uji coba.\n$error';
  }

  @override
  String get friendliesContinue => 'Lanjutkan';

  @override
  String friendliesArrangeIntro(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jadwal kosong',
    );
    return 'Atur pemanasan untuk $_temp0 sebelum laga kompetitif berikutnya. Ketuk lawan, atau biarkan kosong.';
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
  String get matchGoalsNone => 'Tanpa gol';

  @override
  String get matchGoalPenalty => 'PEN';

  @override
  String get matchGoalSetPiece => 'BM';

  @override
  String matchGoalAssist(String name) {
    return 'assist $name';
  }

  @override
  String get friendliesHome => 'KANDANG';

  @override
  String get friendliesAway => 'TANDANG';

  @override
  String get friendliesNoneThisWindow => 'Tanpa uji coba di jadwal ini';

  @override
  String friendliesConfirmCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count laga uji coba',
    );
    return 'Konfirmasi $_temp0';
  }

  @override
  String get friendliesMonthJan => 'Jan';

  @override
  String get friendliesMonthFeb => 'Feb';

  @override
  String get friendliesMonthMar => 'Mar';

  @override
  String get friendliesMonthApr => 'Apr';

  @override
  String get friendliesMonthMay => 'Mei';

  @override
  String get friendliesMonthJun => 'Jun';

  @override
  String get friendliesMonthJul => 'Jul';

  @override
  String get friendliesMonthAug => 'Agu';

  @override
  String get friendliesMonthSep => 'Sep';

  @override
  String get friendliesMonthOct => 'Okt';

  @override
  String get friendliesMonthNov => 'Nov';

  @override
  String get friendliesMonthDec => 'Des';

  @override
  String get resultsMyMatches => 'LAGA SAYA';

  @override
  String resultsCouldNotLoad(String error) {
    return 'Gagal memuat hasil.\n$error';
  }

  @override
  String get resultsNoFixtures => 'Tidak ada jadwal laga.';

  @override
  String get resultsVs => 'lwn';

  @override
  String get resultsStageQualifier => 'KUALIFIKASI';

  @override
  String get resultsStageFriendly => 'UJI COBA';

  @override
  String get resultsStageGroupStage => 'FASE GRUP';

  @override
  String get resultsStageSemiFinal => 'SEMIFINAL';

  @override
  String get resultsStageFinal => 'FINAL';

  @override
  String get resultsStageContinentalClash => 'DUEL BENUA';

  @override
  String get resultsStageFinalsGroup => 'GRUP FINAL';

  @override
  String get resultsStageRoundOf32 => 'BABAK 32 BESAR';

  @override
  String get resultsStageRoundOf16 => 'BABAK 16 BESAR';

  @override
  String get resultsStageQuarterFinal => 'PEREMPAT FINAL';

  @override
  String get resultsStageThirdPlace => 'TEMPAT KETIGA';

  @override
  String get matchSetupWarnCaptain =>
      'Belum ada kapten. Ketuk untuk memberikan ban kapten';

  @override
  String matchSetupWarnCaptainInjured(String name) {
    return '$name cedera dan tidak bisa memimpin tim kali ini. Ketuk untuk mengalihkan ban kapten';
  }

  @override
  String matchSetupWarnCaptainSuspended(String name) {
    return '$name terkena skorsing untuk laga ini. Ketuk untuk mengalihkan ban kapten';
  }

  @override
  String matchSetupWarnCaptainDropped(String name) {
    return '$name memegang ban kapten tetapi tidak ada di skuad Anda. Ketuk untuk mengalihkannya';
  }

  @override
  String get matchSetupWarnSetPieces =>
      'Belum ada eksekutor bola mati. Ketuk untuk memilih siapa yang maju';

  @override
  String get matchSetupWarnBoth =>
      'Belum ada kapten dan eksekutor bola mati. Ketuk untuk menentukan';

  @override
  String matchStageMatchday(int matchday) {
    return 'PEKAN $matchday';
  }

  @override
  String get squadCaptain => 'Kapten';

  @override
  String deptEffectYouth(int points) {
    return 'Pemain akademi datang dengan rating keseluruhan sekitar $points lebih baik';
  }

  @override
  String deptEffectCommercial(String amount) {
    return '$amount kembali di akhir siklus';
  }

  @override
  String deptEffectMedical(int percent) {
    return '$percent% lebih sedikit cedera';
  }

  @override
  String deptEffectNaturalisation(int percent) {
    return 'Peluang $percent% pemain asing meminta pindah kewarganegaraan';
  }

  @override
  String deptEffectBoard(int points) {
    return '+$points kesabaran dewan sebelum jabatan Anda terancam';
  }

  @override
  String get deptEffectNone => 'Tanpa efek selama tidak didanai';

  @override
  String get statsBestRated => 'Rating';

  @override
  String get statsMyCareer => 'Karier';

  @override
  String get statsBestAverageRating => 'RATA-RATA RATING TERBAIK';

  @override
  String get statsMyCareerRecord => 'REKOR ANDA';

  @override
  String get statsNoRatingsRecorded => 'Belum ada rating laga yang tercatat.';

  @override
  String get statsGroupRecord => 'Rekor';

  @override
  String get statsGroupRuns => 'Rentetan';

  @override
  String get statsGroupExtremes => 'Ekstrem';

  @override
  String get statsGroupSplits => 'Kandang & tandang';

  @override
  String get statsGroupSquad => 'Pemain Anda';

  @override
  String get statsPlayed => 'Laga dimainkan';

  @override
  String get statsWinDrawLoss => 'Menang–seri–kalah';

  @override
  String get statsWinRate => 'Persentase menang';

  @override
  String get statsGoals => 'Gol memasukkan:kemasukan';

  @override
  String get statsCleanSheets => 'Clean sheet';

  @override
  String get statsFailedToScore => 'Gagal mencetak gol';

  @override
  String get statsLongestWinStreak => 'Rentetan menang terpanjang';

  @override
  String get statsLongestUnbeaten => 'Rentetan tak terkalahkan terpanjang';

  @override
  String get statsLongestCleanSheets => 'Rentetan clean sheet terpanjang';

  @override
  String get statsLongestWinless => 'Rentetan tanpa kemenangan terpanjang';

  @override
  String get statsCurrentRun => 'Rentetan tak terkalahkan saat ini';

  @override
  String get statsBiggestWin => 'Kemenangan terbesar';

  @override
  String get statsHeaviestDefeat => 'Kekalahan terberat';

  @override
  String get statsMostGoalsInAGame => 'Gol terbanyak dalam satu laga';

  @override
  String get statsShootouts => 'Adu penalti menang–kalah';

  @override
  String get statsComebackWins => 'Menang dari ketertinggalan';

  @override
  String get statsHome => 'Kandang';

  @override
  String get statsAway => 'Tandang';

  @override
  String get statsNeutral => 'Netral';

  @override
  String get statsCompetitive => 'Kompetitif';

  @override
  String get statsFriendlies => 'Laga uji coba';

  @override
  String get statsHatTricks => 'Hat-trick';

  @override
  String get statsBraces => 'Brace';

  @override
  String get statsMotms => 'Penghargaan pemain terbaik laga';

  @override
  String get statsAssists => 'Assist';

  @override
  String get statsCards => 'Kartu';

  @override
  String get statsBestRating => 'Rating individu terbaik';

  @override
  String statsAppsShort(int apps) {
    return '$apps laga';
  }

  @override
  String statsMotmShort(int motms) {
    return '$motms MOTM';
  }

  @override
  String get captainArmband => 'K';

  @override
  String get captainCurrent => 'Kapten. Ketuk untuk melepas ban kapten';

  @override
  String get captainFitBorn => 'Pemimpin sejati';

  @override
  String get captainFitNatural => 'Kapten alami';

  @override
  String get captainFitCapable => 'Layak memakainya';

  @override
  String get captainFitUnproven => 'Belum jadi pemimpin';

  @override
  String get captainNone => 'Belum ada kapten';

  @override
  String captainMoraleBoost(int morale) {
    return '+$morale moral skuad';
  }

  @override
  String get resultsCategoryWorldCupQualifying => 'Kualifikasi Kejuaraan Dunia';

  @override
  String get resultsCategoryFriendlies => 'Laga uji coba';

  @override
  String get resultsCategoryContinentalClash => 'Duel Benua';

  @override
  String get resultsCategoryNationsCup => 'Piala Bangsa-Bangsa';

  @override
  String get resultsCategoryContinentalCup => 'Kejuaraan Benua';

  @override
  String get resultsCategoryWorldCupQualifyingShort => 'Kual. Dunia';

  @override
  String get resultsCategoryContinentalQualifyingShort => 'Kual. Benua';

  @override
  String get resultsCategoryContinentalQualifying =>
      'Kualifikasi Kejuaraan Benua';

  @override
  String get resultsCategoryWorldCupFinals => 'Putaran Final Kejuaraan Dunia';

  @override
  String get resultsRoundResults => 'HASIL PUTARAN';

  @override
  String get resultsFriendlyInternationals => 'LAGA UJI COBA INTERNASIONAL';

  @override
  String get resultsKnockout => 'Sistem gugur';

  @override
  String resultsEarlierMatches(int count) {
    return 'Laga sebelumnya ($count)';
  }

  @override
  String resultsMatchday(int matchday) {
    return 'PEKAN $matchday';
  }

  @override
  String get resultsContinue => 'Lanjutkan';

  @override
  String resultsGroup(String name) {
    return 'GRUP $name';
  }

  @override
  String get achievementsScreenTitle => 'PENCAPAIAN';

  @override
  String get achievementsChallengesTooltip => 'Tantangan';

  @override
  String get achievementsChallengesHeading => 'TANTANGAN';

  @override
  String get achievementsBrutalTests => 'Ujian brutal sepanjang karier';

  @override
  String achievementsCouldNotLoad(String error) {
    return 'Gagal memuat.\n$error';
  }

  @override
  String achievementsUnlockedCount(int earned, int total) {
    return '$earned / $total terbuka';
  }

  @override
  String achievementsConqueredCount(int done, int total) {
    return '$done / $total ditaklukkan';
  }

  @override
  String get achievementsBoardSatisfaction => 'KEPUASAN DEWAN';

  @override
  String achievementsUnlockedBanner(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count PENCAPAIAN TERBUKA',
      one: 'PENCAPAIAN TERBUKA',
    );
    return '$_temp0';
  }

  @override
  String get achCatWins => 'Kemenangan';

  @override
  String get achCatMatches => 'Laga';

  @override
  String get achCatQualifications => 'Kualifikasi';

  @override
  String get achCatTitles => 'Gelar';

  @override
  String get achCatMisc => 'Lainnya';

  @override
  String get achCatMega => 'Mega';

  @override
  String get achCatGoals => 'Gol';

  @override
  String get achCatStreaks => 'Rentetan';

  @override
  String get achTierBronze => 'Perunggu';

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
      other: 'Cetak $count gol.',
      one: 'Cetak 1 gol.',
    );
    return '$_temp0';
  }

  @override
  String achCleanSheets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Clean Sheet',
    );
    return '$_temp0';
  }

  @override
  String achCleanSheetsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Jaga $count clean sheet.',
      one: 'Jaga 1 clean sheet.',
    );
    return '$_temp0';
  }

  @override
  String get achStreakWin5 => 'Kebiasaan Menang';

  @override
  String get achStreakWin5Desc => 'Menangi lima laga berturut-turut.';

  @override
  String get achStreakWin10 => 'Sedang Menggila';

  @override
  String get achStreakWin10Desc => 'Menangi sepuluh laga berturut-turut.';

  @override
  String get achStreakWin20 => 'Mesin Penggilas';

  @override
  String get achStreakWin20Desc => 'Menangi dua puluh laga berturut-turut.';

  @override
  String get achUnbeaten15 => 'Sulit Dikalahkan';

  @override
  String get achUnbeaten15Desc => 'Jalani lima belas laga tanpa kalah.';

  @override
  String get achUnbeaten30 => 'Tak Tersentuh';

  @override
  String get achUnbeaten30Desc => 'Jalani tiga puluh laga tanpa kalah.';

  @override
  String get achHattrick => 'Pahlawan Hat-trick';

  @override
  String get achHattrickDesc => 'Buat seorang pemain mencetak hat-trick.';

  @override
  String get achMotm10 => 'Menonjol';

  @override
  String get achMotm10Desc => 'Kumpulkan 10 penghargaan pemain terbaik laga.';

  @override
  String get achMotm50 => 'Jimat Tim';

  @override
  String get achMotm50Desc => 'Kumpulkan 50 penghargaan pemain terbaik laga.';

  @override
  String get achPerfect => 'Sempurna Sepuluh';

  @override
  String get achPerfectDesc => 'Buat seorang pemain meraih rating laga 9,5+.';

  @override
  String get achShootout => 'Darah Dingin';

  @override
  String get achShootoutDesc => 'Menangi lima adu penalti.';

  @override
  String get achMassacre => 'Pembantaian';

  @override
  String get achMassacreDesc => 'Menangi laga dengan selisih 7 gol atau lebih.';

  @override
  String get achAnnihilation => 'Pemusnahan';

  @override
  String get achAnnihilationDesc =>
      'Menangi laga dengan selisih 10 gol atau lebih.';

  @override
  String get chTierBronze => 'Perunggu';

  @override
  String get chTierSilver => 'Perak';

  @override
  String get chTierGold => 'Emas';

  @override
  String get chTierLegendary => 'Legendaris';

  @override
  String get chFirstSteps => 'Di Bangku Pelatih';

  @override
  String get chFirstStepsDesc => 'Melatih selama 5 tahun.';

  @override
  String get chUnbeaten10 => 'Sedang Menggila';

  @override
  String get chUnbeaten10Desc => 'Jalani 10 laga kompetitif tanpa kalah.';

  @override
  String get chTwoNations => 'Tantangan Baru';

  @override
  String get chTwoNationsDesc => 'Tangani 2 negara berbeda.';

  @override
  String get chCont1 => 'Juara Benua';

  @override
  String get chCont1Desc => 'Juarai sebuah kejuaraan benua.';

  @override
  String get chNc1 => 'Juara Piala Bangsa-Bangsa';

  @override
  String get chNc1Desc => 'Juarai Piala Bangsa-Bangsa.';

  @override
  String get chWc1 => 'Juara Dunia';

  @override
  String get chWc1Desc => 'Juarai Kejuaraan Dunia.';

  @override
  String get chYears25 => 'Mapan';

  @override
  String get chYears25Desc => 'Melatih selama 25 tahun.';

  @override
  String get chWc3 => 'Juara Berantai';

  @override
  String get chWc3Desc => 'Juarai 3 Kejuaraan Dunia.';

  @override
  String get chWc5 => 'Dinasti';

  @override
  String get chWc5Desc => 'Juarai 5 Kejuaraan Dunia.';

  @override
  String get chWc10 => 'Abadi';

  @override
  String get chWc10Desc => 'Juarai 10 Kejuaraan Dunia.';

  @override
  String get chWc2Teams => 'Sepatu Siap, Siap Berkelana';

  @override
  String get chWc2TeamsDesc =>
      'Juarai Kejuaraan Dunia bersama 2 negara berbeda.';

  @override
  String get chWc3Teams => 'Penjelajah Dunia';

  @override
  String get chWc3TeamsDesc =>
      'Juarai Kejuaraan Dunia bersama 3 negara berbeda.';

  @override
  String get chWcStreak3 => 'Tiga Kali Beruntun';

  @override
  String get chWcStreak3Desc => 'Juarai 3 Kejuaraan Dunia berturut-turut.';

  @override
  String get chWcAllconf => 'Penakluk Dunia';

  @override
  String get chWcAllconfDesc =>
      'Juarai Kejuaraan Dunia bersama negara dari setiap konfederasi (6).';

  @override
  String get chCont5 => 'Raja Benua';

  @override
  String get chCont5Desc => 'Juarai 5 kejuaraan benua.';

  @override
  String get chContAll => 'Grand Slam Enam Benua';

  @override
  String get chContAllDesc =>
      'Juarai kejuaraan benua dari setiap konfederasi (6).';

  @override
  String get chTreble => 'Sapu Bersih';

  @override
  String get chTrebleDesc =>
      'Juarai Kejuaraan Dunia, gelar benua, dan Piala Bangsa-Bangsa dalam satu karier.';

  @override
  String get chNations10 => 'Nomaden';

  @override
  String get chNations10Desc => 'Tangani 10 negara berbeda.';

  @override
  String get chYears100 => 'Seabad';

  @override
  String get chYears100Desc => 'Melatih selama 100 tahun.';

  @override
  String get chYears500 => 'Setengah Milenium';

  @override
  String get chYears500Desc => 'Melatih selama 500 tahun.';

  @override
  String get chYears1000 => 'Kekal';

  @override
  String get chYears1000Desc => 'Melatih selama 1000 tahun.';

  @override
  String get chGrandmaster => 'Grandmaster';

  @override
  String get chGrandmasterDesc =>
      'Juarai 3 Kejuaraan Dunia DAN 5 kejuaraan benua.';

  @override
  String get chUndefeated => 'Tak Tersentuh';

  @override
  String get chUndefeatedDesc =>
      'Juarai Kejuaraan Dunia tanpa kalah sekali pun.';

  @override
  String get chPerfectQual => 'Lolos Sempurna';

  @override
  String get chPerfectQualDesc =>
      'Menangi setiap laga dalam satu kampanye kualifikasi Kejuaraan Dunia.';

  @override
  String get chMinnow => 'Keajaiban Tim Kecil';

  @override
  String get chMinnowDesc =>
      'Juarai Kejuaraan Dunia bersama negara di luar 32 besar peringkat dunia.';

  @override
  String get chGrandTour => 'Kandang & Tandang';

  @override
  String get chGrandTourDesc =>
      'Juarai Kejuaraan Dunia sebagai tuan rumah dan juarai satu lagi di luar negeri.';

  @override
  String get chUnbeaten25 => 'Sang Tembok';

  @override
  String get chUnbeaten25Desc => 'Jalani 25 laga kompetitif tanpa kalah.';

  @override
  String get chGoals10k => 'Mesin Gol';

  @override
  String get chGoals10kDesc => 'Cetak 10.000 gol sepanjang karier.';

  @override
  String get chCleanSheets500 => 'Benteng';

  @override
  String get chCleanSheets500Desc => 'Jaga 500 clean sheet sepanjang karier.';

  @override
  String get chHatTricks25 => 'Kebiasaan Hat-trick';

  @override
  String get chHatTricks25Desc => 'Buat pemain Anda mencetak 25 hat-trick.';

  @override
  String get chWinStreak25 => 'Tanpa Henti';

  @override
  String get chWinStreak25Desc => 'Menangi 25 laga berturut-turut.';

  @override
  String get chCont10 => 'Dinasti Benua';

  @override
  String get chCont10Desc => 'Juarai 10 kejuaraan benua.';

  @override
  String get chPcWc => 'Juara Berantai';

  @override
  String chPcWcDesc(int count) {
    return 'Juarai $count Kejuaraan Dunia di simpanan ini.';
  }

  @override
  String get chPcMajors => 'Kolektor Trofi';

  @override
  String chPcMajorsDesc(int count) {
    return 'Raih $count trofi besar (Kejuaraan Dunia, kejuaraan benua, atau Piala Bangsa-Bangsa).';
  }

  @override
  String get chPcUnbeaten => 'Tembok Baja';

  @override
  String chPcUnbeatenDesc(int count) {
    return 'Jalani $count laga kompetitif tanpa kalah.';
  }

  @override
  String get chPcNations => 'Pelatih Kelana';

  @override
  String chPcNationsDesc(int count) {
    return 'Tangani $count negara berbeda.';
  }

  @override
  String get chPcYears => 'Perjalanan Panjang';

  @override
  String chPcYearsDesc(int count) {
    return 'Melatih selama $count tahun.';
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
      other: 'Menangi $count laga.',
      one: 'Menangi 1 laga.',
    );
    return '$_temp0';
  }

  @override
  String achMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Laga',
    );
    return '$_temp0';
  }

  @override
  String achMatchesDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mainkan $count laga.',
      one: 'Mainkan 1 laga.',
    );
    return '$_temp0';
  }

  @override
  String get achQualWc => 'Lolos Kejuaraan Dunia';

  @override
  String get achQualWcDesc => 'Lolos ke Kejuaraan Dunia.';

  @override
  String get achQualCont => 'Lolos Kejuaraan Benua';

  @override
  String get achQualContDesc => 'Lolos ke kejuaraan benua Anda.';

  @override
  String get achTitleWc => 'Juara Dunia';

  @override
  String get achTitleWcDesc => 'Juarai Kejuaraan Dunia.';

  @override
  String get achTitleEuro => 'Juara Eropa';

  @override
  String get achTitleEuroDesc => 'Juarai Kejuaraan Eropa.';

  @override
  String get achTitleCopa => 'Juara Amerika Selatan';

  @override
  String get achTitleCopaDesc => 'Juarai Kejuaraan Amerika Selatan.';

  @override
  String get achTitleAfcon => 'Juara Afrika';

  @override
  String get achTitleAfconDesc => 'Juarai Kejuaraan Afrika.';

  @override
  String get achTitleAsia => 'Juara Asia';

  @override
  String get achTitleAsiaDesc => 'Juarai Kejuaraan Asia.';

  @override
  String get achTitleConcacaf => 'Juara Amerika Utara';

  @override
  String get achTitleConcacafDesc => 'Juarai Kejuaraan Amerika Utara.';

  @override
  String get achTitleOfc => 'Juara Oseania';

  @override
  String get achTitleOfcDesc => 'Juarai Piala Oseania.';

  @override
  String get achTitleNations => 'Juara Piala Bangsa-Bangsa';

  @override
  String get achTitleNationsDesc => 'Juarai Piala Bangsa-Bangsa.';

  @override
  String get achTitleClash => 'Juara Duel Benua';

  @override
  String get achTitleClashDesc => 'Juarai Duel Benua.';

  @override
  String get achMarksman => 'Penembak Jitu Kejuaraan Dunia';

  @override
  String get achMarksmanDesc =>
      'Buat pemain skuad mencetak 6+ gol di putaran final Kejuaraan Dunia.';

  @override
  String get achSweep => 'Sapu Bersih';

  @override
  String get achSweepDesc =>
      'Pegang gelar Kejuaraan Dunia dan gelar benua Anda dalam satu karier.';

  @override
  String get achAllstar => 'All-Star Turnamen';

  @override
  String get achAllstarDesc =>
      'Buat seorang pemain masuk Tim Terbaik Turnamen Kejuaraan Dunia.';

  @override
  String get achGoldenboot => 'Sepatu Emas';

  @override
  String get achGoldenbootDesc =>
      'Buat negara Anda menutup kejuaraan sebagai pencetak gol terbanyak.';

  @override
  String get achDemolition => 'Penghancuran';

  @override
  String get achDemolitionDesc =>
      'Menangi laga dengan selisih 5 gol atau lebih.';

  @override
  String get achievementsNice => 'Mantap!';

  @override
  String get achievementsHardestTests =>
      'Ujian terberat bagi seorang pelatih, sepanjang karier dan bersama banyak negara.';

  @override
  String get achievementsThisSave => 'SIMPANAN INI';

  @override
  String get achievementsBrutalBadge => 'BRUTAL';

  @override
  String get paywallGoPro => 'BUKA TANPA BATAS';

  @override
  String get paywallOneTimeUnlock => 'Sekali buka. Tanpa langganan.';

  @override
  String get paywallBenefitCarryOn =>
      'Simpanan ini berlanjut tepat di titik terakhir, dengan semua caps, rekor, dan rivalitas utuh.';

  @override
  String get paywallBenefitNoAds =>
      'Tanpa iklan, tanpa mikrotransaksi, tanpa langganan. Satu kali bayar, dan setiap pembaruan ke depan menjadi milik Anda.';

  @override
  String get paywallBenefitSaves =>
      'Simpanan sebanyak yang Anda mau. Pimpin tim unggulan dan tim kecil sekaligus, lalu rasakan betapa berbedanya game yang sama.';

  @override
  String get paywallBenefitEndless =>
      'Setiap siklus mulai dari sini. Pilih pemain tujuh belas tahun hari ini dan buktikan di 2034 apakah penilaian Anda benar.';

  @override
  String get paywallUnlocked => 'Unlimited sudah terbuka. Selamat menikmati!';

  @override
  String get paywallContactingStore => 'Menghubungi toko…';

  @override
  String paywallUnlockProPriced(String price) {
    return 'Buka Unlimited · $price';
  }

  @override
  String get paywallRestorePurchases => 'Pulihkan pembelian';

  @override
  String get paywallStoreUnavailable => 'Toko tidak tersedia';

  @override
  String get paywallStoreUnavailableNote =>
      'Harga tidak dapat dimuat. Periksa koneksi Anda dan coba lagi.';

  @override
  String get paywallTryAgain => 'Coba lagi';

  @override
  String get gateTitle => 'SIKLUS PERTAMA ANDA SUDAH USAI';

  @override
  String get gateLead =>
      'Empat tahun adalah satu siklus. Itu belum cukup lama untuk tahu apakah Anda benar.';

  @override
  String get gatePriceLead => 'Sekali bayar, selamanya';

  @override
  String get gateBuy => 'BELI DAN LANJUTKAN';

  @override
  String get gateExit => 'KELUAR';

  @override
  String get federationNaturalisation => 'NATURALISASI';

  @override
  String federationNaturalisedTitle(String name) {
    return '$name dinaturalisasi';
  }

  @override
  String federationNaturalisedBody(String name, String nation) {
    return '$name telah menyelesaikan perpindahan dan kini memenuhi syarat membela $nation. Panggil dia dari pemilihan skuad Anda.';
  }

  @override
  String federationCouldNotLoadOffer(String error) {
    return 'Gagal memuat tawaran.\n$error';
  }

  @override
  String get federationContinue => 'Lanjutkan';

  @override
  String get federationOfferToSwitchAllegiance =>
      'TAWARAN PINDAH KEWARGANEGARAAN';

  @override
  String federationPlayerMeta(String position, int age, String nation) {
    return '$position · usia $age · dari $nation';
  }

  @override
  String federationNaturalisationBlurb(
    String name,
    String playerNation,
    String sourceNation,
  ) {
    return '$name punya ikatan dengan $playerNation dan bersedia dinaturalisasi. Terima, dan dia bisa dipilih; tolak, dan dia tetap bersama $sourceNation.';
  }

  @override
  String get federationDecline => 'Tolak';

  @override
  String get federationNaturalise => 'Naturalisasi';

  @override
  String get federationBudgetLater => 'Putuskan nanti';

  @override
  String get federationSetYourBudget => 'TENTUKAN ANGGARAN ANDA';

  @override
  String federationCouldNotLoadFinances(String error) {
    return 'Gagal memuat keuangan.\n$error';
  }

  @override
  String get federationSaveNotFound => 'Simpanan tidak ditemukan.';

  @override
  String get federationBudgetHeading => 'ANGGARAN FEDERASI';

  @override
  String federationDistributeBudget(String amount) {
    return 'Bagikan $amount ke seluruh departemen untuk membuka siklus. Gunakan dengan bijak.';
  }

  @override
  String federationOverBudget(String amount) {
    return '$amount lebih banyak dari dana federasi. Kurangi sebagian';
  }

  @override
  String get federationAllocateFullBudget =>
      'Alokasikan seluruh anggaran untuk memulai siklus.';

  @override
  String get federationConfirming => 'Mengonfirmasi…';

  @override
  String get federationConfirmBudget => 'Konfirmasi anggaran';

  @override
  String get federationFinances => 'KEUANGAN';

  @override
  String get federationInvestmentUpdated => 'Investasi diperbarui.';

  @override
  String get federationDevelopment => 'PENGEMBANGAN FEDERASI';

  @override
  String get federationProjectedAtSeasonEnd => 'PROYEKSI AKHIR MUSIM';

  @override
  String get federationCentralFunding => 'Dana pusat';

  @override
  String get federationPrizeMoneySoFar => 'Hadiah uang sejauh ini';

  @override
  String get federationCommercialReturn => 'Pendapatan komersial';

  @override
  String get federationThisSeasonLocked => 'MUSIM INI (TERKUNCI)';

  @override
  String get federationInvestForNextSeason => 'INVESTASI MUSIM DEPAN';

  @override
  String get federationNextSeasonImpact => 'DAMPAK MUSIM DEPAN';

  @override
  String get federationSaving => 'Menyimpan…';

  @override
  String get federationConfirmInvestment => 'Konfirmasi investasi';

  @override
  String get federationBalance => 'SALDO FEDERASI';

  @override
  String get federationCommittedToStaff => 'Dialokasikan untuk staf';

  @override
  String get federationFreeToSpend => 'Bebas dibelanjakan';

  @override
  String get federationWagesNote =>
      'Gaji dipotong dari saldo di akhir siklus, jadi sebesar ini sudah terpakai.';

  @override
  String get federationInvestAtCeremony =>
      'Investasikan untuk musim depan saat upacara akhir siklus.';

  @override
  String federationLevelBadge(int level) {
    return 'T$level';
  }

  @override
  String get federationAcademyProspects => 'Pemain muda akademi';

  @override
  String federationPlusOverall(int value) {
    return '+$value overall';
  }

  @override
  String get federationInjuryRisk => 'Risiko cedera';

  @override
  String get federationNaturalisationChance => 'Peluang naturalisasi';

  @override
  String get federationBoardPatience => 'Kesabaran dewan';

  @override
  String get federationUnallocated => 'BELUM DIALOKASIKAN';

  @override
  String get nationsVitrineTitle => 'ETALASE NEGARA';

  @override
  String nationsCouldNotLoad(String error) {
    return 'Gagal memuat negara.\n$error';
  }

  @override
  String get nationsNoNation => 'Tidak ada negara.';

  @override
  String get nationsHonours => 'PRESTASI';

  @override
  String get nationsRankingHistory => 'SEJARAH PERINGKAT DUNIA';

  @override
  String get nationsTopScorers => 'PENCETAK GOL TERBANYAK SEPANJANG MASA';

  @override
  String get nationsTitles => 'GELAR';

  @override
  String get nationsYourTeam => 'TIM ANDA';

  @override
  String get nationsWorld => 'DUNIA';

  @override
  String get nationsWorldCup => 'Kejuaraan Dunia';

  @override
  String get nationsContinental => 'Benua';

  @override
  String nationsAppearances(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count penampilan',
    );
    return '$_temp0';
  }

  @override
  String get nationsNotEnoughHistory =>
      'Sejarah belum cukup. Cek lagi setelah satu atau dua siklus.';

  @override
  String nationsBestRank(int rank) {
    return 'Terbaik: #$rank';
  }

  @override
  String nationsNowRank(int rank) {
    return 'Kini: #$rank';
  }

  @override
  String get nationsNoGoals => 'Belum ada gol tercatat.';

  @override
  String get nationsGoalsAbbrev => 'gol';

  @override
  String get nationsHosts => 'TUAN RUMAH';

  @override
  String get nationsSelectTitle => 'PILIH TIM NASIONAL';

  @override
  String nationsCouldNotLoadNations(String error) {
    return 'Gagal memuat negara.\n$error';
  }

  @override
  String get nationsNoMatch => 'Tidak ada negara yang cocok.';

  @override
  String get nationsNationalLevel => 'TINGKAT NEGARA';

  @override
  String get nationsSelectHeading => 'Pilih Tim Nasional';

  @override
  String get nationsSearchHint => 'Cari negara…';

  @override
  String get nationsRank => 'PERINGKAT ';

  @override
  String get nationsPremium => 'PREMIUM';

  @override
  String get nationsSelect => 'PILIH';

  @override
  String get statsTeamRecords => 'REKOR TIM';

  @override
  String get statsRecordBook => 'Buku rekor';

  @override
  String statsCouldNotLoadStats(String error) {
    return 'Gagal memuat statistik.\n$error';
  }

  @override
  String get statsNoData => 'Tidak ada data.';

  @override
  String get statsTopScorers => 'PENCETAK GOL TERBANYAK';

  @override
  String get statsMostGamesPlayed => 'PENAMPILAN TERBANYAK';

  @override
  String get statsTeam => 'Tim';

  @override
  String get statsTopScorersShort => 'Pencetak gol';

  @override
  String get statsMostGames => 'Laga terbanyak';

  @override
  String get statsNoGoalsRecorded => 'Belum ada gol tercatat.';

  @override
  String get statsUnknown => 'Tidak diketahui';

  @override
  String get playerTitle => 'PEMAIN';

  @override
  String playerLoadError(String error) {
    return 'Gagal memuat pemain.\n$error';
  }

  @override
  String get playerNotFound => 'Pemain tidak ditemukan.';

  @override
  String get playerClub => 'KLUB';

  @override
  String get playerClubRole => 'Di klubnya';

  @override
  String get playerPosition => 'Posisi';

  @override
  String get playerPotential => 'Potensi';

  @override
  String get playerAge => 'Usia';

  @override
  String get playerValue => 'Nilai';

  @override
  String get clubFirstChoice => 'Main tiap pekan';

  @override
  String get clubRotation => 'Keluar masuk';

  @override
  String get clubFringe => 'Jarang main';

  @override
  String get clubFrozenOut => 'Tidak main';

  @override
  String clubAtClub(String club, String standing) {
    return '$club: $standing';
  }

  @override
  String yWinUpset0(String opponent, String score) {
    return 'Saya sudah menonton sepak bola selama tiga puluh tahun dan tidak menyangka ini. $opponent dikalahkan $score.';
  }

  @override
  String yWinUpset1(String opponent, String score) {
    return 'Tak ada yang memberi mereka harapan melawan $opponent. $score. Sungguh tak ada satu pun.';
  }

  @override
  String yWinUpset2(String opponent, String score) {
    return '$score melawan $opponent. Bangunkan para tetangga.';
  }

  @override
  String yWinUpset3(String opponent, String score) {
    return 'Ini malam yang akan diceritakan kepada cucu. $opponent $score.';
  }

  @override
  String yWinUpset4(String opponent, String score) {
    return '$score melawan $opponent. Entah bagaimana caranya, terjadi juga.';
  }

  @override
  String yWinUpset5(String opponent, String score) {
    return 'Di atas kertas ini sudah selesai sebelum mulai. $opponent $score berkata lain.';
  }

  @override
  String yWinUpset6(String opponent, String score) {
    return 'Menang atas $opponent $score. Setahun lagi tak ada yang percaya skor itu.';
  }

  @override
  String yWinUpset7(String opponent, String score) {
    return '$opponent $score. Nikmati dulu, lalu lihat jadwal laga.';
  }

  @override
  String yWinUpset8(String opponent, String score) {
    return '$score melawan $opponent, dan kita beruntung selama delapan puluh dari sembilan puluh menit.';
  }

  @override
  String yWinUpset9(String opponent, String score) {
    return 'Satu malam melawan $opponent tidak menghapus setahun. $score.';
  }

  @override
  String yWinUpset10(String opponent, String score) {
    return 'Menang atas $opponent $score dan sebentar lagi kita dibilang sudah bangkit. Belum.';
  }

  @override
  String yWinUpset11(String opponent, String score) {
    return '$opponent $score. Bagus sekali. Tanya saya lagi saat laga yang penting.';
  }

  @override
  String yWinRoutine0(String opponent, String score) {
    return 'Menang atas $opponent $score. Persis seperti seharusnya, dan ada kepuasan di situ.';
  }

  @override
  String yWinRoutine1(String opponent, String score) {
    return '$score atas $opponent. Tanpa ampun, dan tanpa ampun itu pujian.';
  }

  @override
  String yWinRoutine2(String opponent, String score) {
    return '$opponent $score. Tanpa drama, tanpa panik, tanpa keluhan.';
  }

  @override
  String yWinRoutine3(String opponent, String score) {
    return '$score yang rapi atas $opponent. Beginilah tim bagus di hari yang tenang.';
  }

  @override
  String yWinRoutine4(String opponent, String score) {
    return '$score melawan $opponent. Tugas selesai, tak ada pelajaran.';
  }

  @override
  String yWinRoutine5(String opponent, String score) {
    return 'Menang atas $opponent $score. Kita memang harus menang, dan kita menang.';
  }

  @override
  String yWinRoutine6(String opponent, String score) {
    return '$score yang profesional atas $opponent. Berikutnya.';
  }

  @override
  String yWinRoutine7(String opponent, String score) {
    return '$opponent ditumbangkan $score. Catat, lalu lanjut.';
  }

  @override
  String yWinRoutine8(String opponent, String score) {
    return '$score melawan $opponent dan kita disuruh bertepuk tangan. Karena mengalahkan mereka.';
  }

  @override
  String yWinRoutine9(String opponent, String score) {
    return 'Selamat untuk semua yang terlibat dalam $score atas $opponent, kurasa.';
  }

  @override
  String yWinRoutine10(String opponent, String score) {
    return '$opponent $score. Mengalahkan tim seperti itu adalah standar minimum, bukan prestasi.';
  }

  @override
  String yWinRoutine11(String opponent, String score) {
    return 'Kita menang atas $opponent $score dan terlihat kaku saat melakukannya.';
  }

  @override
  String yWinTight0(String opponent, String score) {
    return '$score melawan $opponent dan setiap menitnya diperjuangkan.';
  }

  @override
  String yWinTight1(String opponent, String score) {
    return 'Ini butuh karakter. $opponent $score.';
  }

  @override
  String yWinTight2(String opponent, String score) {
    return 'Menang atas $opponent $score dengan cara sulit, cara yang bertahan lama.';
  }

  @override
  String yWinTight3(String opponent, String score) {
    return '$score melawan $opponent. Tim yang menang seperti ini yang masih bertahan di bulan Juni.';
  }

  @override
  String yWinTight4(String opponent, String score) {
    return 'Tegang, jelek, tapi menang. $opponent $score.';
  }

  @override
  String yWinTight5(String opponent, String score) {
    return 'Menang atas $opponent $score. Ambil tiga poinnya dan jangan tonton ulang.';
  }

  @override
  String yWinTight6(String opponent, String score) {
    return '$score. $opponent membuat kita berjuang untuk setiap jengkal.';
  }

  @override
  String yWinTight7(String opponent, String score) {
    return '$opponent $score. Tidak indah. Nilainya sama.';
  }

  @override
  String yWinTight8(String opponent, String score) {
    return '$score melawan $opponent dan kita mempersulit diri sepuluh kali lipat.';
  }

  @override
  String yWinTight9(String opponent, String score) {
    return 'Kita tak seharusnya sampai bertahan mati-matian melawan $opponent. $score.';
  }

  @override
  String yWinTight10(String opponent, String score) {
    return '$opponent $score. Menang, tapi tak ada hal baik yang kita pelajari soal diri sendiri.';
  }

  @override
  String yWinTight11(String opponent, String score) {
    return '$score yang terlalu memuji kita melawan $opponent.';
  }

  @override
  String yDrew0(String opponent, String score) {
    return 'Satu poin melawan $opponent, $score. Terima saja dan lanjut.';
  }

  @override
  String yDrew1(String opponent, String score) {
    return '$score dengan $opponent. Ada sore yang lebih buruk dari ini.';
  }

  @override
  String yDrew2(String opponent, String score) {
    return 'Menahan $opponent $score. Tidak semua harus jadi cerita.';
  }

  @override
  String yDrew3(String opponent, String score) {
    return '$opponent $score. Satu poin tetap satu poin dan klasemen tidak bertanya caranya.';
  }

  @override
  String yDrew4(String opponent, String score) {
    return '$score dengan $opponent. Dua poin hilang atau satu poin didapat. Pilih suasana hatimu.';
  }

  @override
  String yDrew5(String opponent, String score) {
    return 'Seri melawan $opponent, $score. Tak ada yang senang, tak ada yang marah.';
  }

  @override
  String yDrew6(String opponent, String score) {
    return '$opponent $score. Sembilan puluh menit paling mudah dilupakan tahun ini.';
  }

  @override
  String yDrew7(String opponent, String score) {
    return 'Berbagi poin dengan $opponent, $score. Lanjut.';
  }

  @override
  String yDrew8(String opponent, String score) {
    return '$score melawan $opponent. Hasil imbang seperti ini cara kampanye mati diam-diam.';
  }

  @override
  String yDrew9(String opponent, String score) {
    return 'Dua poin terbuang melawan $opponent. $score. Tak ada sebutan lain.';
  }

  @override
  String yDrew10(String opponent, String score) {
    return '$opponent $score. Kita punya sembilan puluh menit dan tak tahu mau diapakan.';
  }

  @override
  String yDrew11(String opponent, String score) {
    return '$score dengan $opponent yang tak akan diingat siapa pun tapi akan dibayar semua orang.';
  }

  @override
  String yLost0(String opponent, String score) {
    return 'Kalah $score dari $opponent. Namanya juga sepak bola.';
  }

  @override
  String yLost1(String opponent, String score) {
    return '$opponent $score. Tak ada yang pantas disalahkan. Lanjut ke laga berikutnya.';
  }

  @override
  String yLost2(String opponent, String score) {
    return 'Kalah $score dari $opponent dan sudah berjuang habis-habisan. Kadang itu tidak cukup.';
  }

  @override
  String yLost3(String opponent, String score) {
    return '$score dari $opponent. Angkat kepala. Tim ini masih punya banyak tenaga.';
  }

  @override
  String yLost4(String opponent, String score) {
    return '$opponent $score. Kita kalah kelas dan tak ada yang bisa dibantah.';
  }

  @override
  String yLost5(String opponent, String score) {
    return 'Kalah $score dari $opponent. Konsolidasi.';
  }

  @override
  String yLost6(String opponent, String score) {
    return '$score dari $opponent. Bukan aib, tapi tidak cukup baik.';
  }

  @override
  String yLost7(String opponent, String score) {
    return 'Kalah $score dari $opponent. Pelajari sesuatu darinya atau sia-sia.';
  }

  @override
  String yLost8(String opponent, String score) {
    return '$score dari $opponent dan kita sama sekali tak menyentuh mereka.';
  }

  @override
  String yLost9(String opponent, String score) {
    return 'Kalah dari $opponent, $score. Masalah sama, bulan sama, alasan yang sama segera datang.';
  }

  @override
  String yLost10(String opponent, String score) {
    return '$opponent $score. Kapan ini berhenti disebut sial?';
  }

  @override
  String yLost11(String opponent, String score) {
    return 'Kalah $score dari $opponent. Hasil seperti ini harus ada yang menanggung akibatnya.';
  }

  @override
  String yLostBadly0(String opponent, String score) {
    return '$score dari $opponent. Satu malam buruk. Nilai tim ini dari seluruh kampanye, bukan dari ini.';
  }

  @override
  String yLostBadly1(String opponent, String score) {
    return 'Tak ada yang lebih tidak menginginkan $score melawan $opponent itu daripada para pemainnya sendiri.';
  }

  @override
  String yLostBadly2(String opponent, String score) {
    return '$opponent $score. Jelek, dan bukan seperti inilah tim ini.';
  }

  @override
  String yLostBadly3(String opponent, String score) {
    return '$score yang harus dilupakan melawan $opponent. Mereka akan bangkit lain kali.';
  }

  @override
  String yLostBadly4(String opponent, String score) {
    return '$score. Dari $opponent. Saya kehabisan kata dan saya dibayar untuk punya kata.';
  }

  @override
  String yLostBadly5(String opponent, String score) {
    return '$opponent $score. Harus ada yang bertanggung jawab.';
  }

  @override
  String yLostBadly6(String opponent, String score) {
    return 'Saya mau $score melawan $opponent dihapus dari catatan dan dari ingatan.';
  }

  @override
  String yLostBadly7(String opponent, String score) {
    return 'Kalah $score dari $opponent. Skor seperti itu tak bisa dipoles.';
  }

  @override
  String yLostBadly8(String opponent, String score) {
    return 'Itu bukan kekalahan dari $opponent, itu penyerahan diri. $score.';
  }

  @override
  String yLostBadly9(String opponent, String score) {
    return '$score. Melawan $opponent. Orang membayar untuk menonton itu.';
  }

  @override
  String yLostBadly10(String opponent, String score) {
    return '$opponent $score. Kalau ini tak mengubah apa pun, tak ada yang akan.';
  }

  @override
  String yLostBadly11(String opponent, String score) {
    return 'Saya pernah melihat tim ini dipermalukan, tapi $score dari $opponent adalah dasar baru.';
  }

  @override
  String yTrophy0(String opponent) {
    return 'JUARA. $opponent. Ucapkan keras-keras.';
  }

  @override
  String yTrophy1(String opponent) {
    return 'Kita menang. $opponent. Saya tidak baik-baik saja.';
  }

  @override
  String yTrophy2(String opponent) {
    return '$opponent, dan trofinya pulang ke rumah.';
  }

  @override
  String yTrophy3(String opponent) {
    return 'Mereka semua legenda. $opponent.';
  }

  @override
  String yRunnerUp0(String opponent) {
    return 'Sedikit lagi. $opponent dan medali yang tak diinginkan siapa pun.';
  }

  @override
  String yRunnerUp1(String opponent) {
    return 'Runner-up di $opponent. Rasa sakitnya akan bertahun-tahun.';
  }

  @override
  String yRunnerUp2(String opponent) {
    return '$opponent: satu laga dari segalanya.';
  }

  @override
  String yRunnerUp3(String opponent) {
    return 'Kedua. Di $opponent. Tolong ambilkan botolnya.';
  }

  @override
  String yEliminated0(String opponent) {
    return 'Tersingkir di $opponent. Yang ini akan sakit untuk beberapa waktu.';
  }

  @override
  String yEliminated1(String opponent) {
    return '$opponent adalah akhir perjalanan kita.';
  }

  @override
  String yEliminated2(String opponent) {
    return 'Tersingkir di $opponent. Sekarang waktunya pengusutan.';
  }

  @override
  String yEliminated3(String opponent) {
    return 'Gugur di $opponent. Tolong jelaskan itu kepada saya.';
  }

  @override
  String yQualified0(String opponent) {
    return 'KITA MENUJU $opponent.';
  }

  @override
  String yQualified1(String opponent) {
    return 'Lolos ke $opponent. Ajukan cuti dari kerja.';
  }

  @override
  String yQualified2(String opponent) {
    return '$opponent, kami datang. Tak pernah diragukan (padahal sepenuhnya diragukan).';
  }

  @override
  String yQualified3(String opponent) {
    return 'Lolos ke $opponent. Bagian tersulit sudah selesai.';
  }

  @override
  String yGroupDrawn0(String opponent) {
    return 'Grup untuk $opponent sudah diundi. Bisa lebih buruk. Bisa jauh lebih buruk.';
  }

  @override
  String yGroupDrawn1(String opponent) {
    return 'Jadi itu undian $opponent. Menarik.';
  }

  @override
  String yGroupDrawn2(String opponent) {
    return 'Grup $opponent sudah keluar dan saya sudah tidak suka grup kita.';
  }

  @override
  String yGroupDrawn3(String opponent) {
    return 'Undian $opponent selesai. Biarkan reaksi berlebihan dimulai.';
  }

  @override
  String yHostNamed0(String opponent) {
    return '$opponent yang akan jadi tuan rumah. Mulai menabung.';
  }

  @override
  String yHostNamed1(String opponent) {
    return 'Turnamen ini ke $opponent. Bisa ditebak, tapi tak masalah.';
  }

  @override
  String yHostNamed2(String opponent) {
    return '$opponent mendapat turnamennya. Selamat untuk mereka, kurasa.';
  }

  @override
  String yHostNamed3(String opponent) {
    return 'Tuan rumah ditetapkan: $opponent.';
  }

  @override
  String yTournamentSoon0(String opponent) {
    return '$opponent segera dimulai dan saya tak bisa duduk diam.';
  }

  @override
  String yTournamentSoon1(String opponent) {
    return 'Tak lama lagi menuju $opponent.';
  }

  @override
  String yTournamentSoon2(String opponent) {
    return '$opponent hampir tiba. Umumkan skuadnya, tolong.';
  }

  @override
  String yTournamentSoon3(String opponent) {
    return 'Hitung mundur menuju $opponent resmi tak tertahankan.';
  }

  @override
  String get navY => 'Y';

  @override
  String get yTitle => 'Y';

  @override
  String get yEmpty => 'Belum ada yang dibicarakan. Mainkan laga.';

  @override
  String get yEarlierHeading => 'Awal siklus ini';

  @override
  String get yTraitLoyalist =>
      'Mendukung tim apa pun yang terjadi. Lambat berbalik, cepat memaafkan.';

  @override
  String get yTraitCynic =>
      'Selalu mengira yang terburuk dan senang kalau terbukti benar.';

  @override
  String get yTraitNostalgic =>
      'Dulu semuanya lebih baik. Membandingkan Anda dengan para pemain yang sudah pensiun.';

  @override
  String get yTraitStatshead =>
      'Hanya mengunggah angka. Hampir tak punya suasana hati.';

  @override
  String get yTraitHypeman => 'Dua hasil bagus langsung jadi generasi emas.';

  @override
  String get yTraitContrarian =>
      'Apa pun pendapat ramai, ia berpendapat sebaliknya.';

  @override
  String get yTraitDoomer => 'Pasti akan berantakan. Selalu akan berantakan.';

  @override
  String get yProfilePosts => 'UNGGAHAN';

  @override
  String get yProfileEmpty => 'Belum ada apa pun dari akun ini.';

  @override
  String hubEventGrievance(String player) {
    return '$player ingin bicara';
  }

  @override
  String get hubEventGrievanceSub => 'Ia ingin tahu posisinya';

  @override
  String hubEventManagerSkills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count poin keahlian untuk dipakai',
    );
    return '$_temp0';
  }

  @override
  String get hubEventManagerSkillsSub => 'Keahlian Anda membuat tim lebih baik';

  @override
  String get grievanceTitle => 'Bicara di ruangan Anda';

  @override
  String grievanceGameTime(String player) {
    return '$player masuk skuad tapi belum menyentuh bola. Ia ingin tahu kenapa.';
  }

  @override
  String grievanceSquadPlace(String player) {
    return '$player tidak masuk skuad dan tak bisa memahaminya. Ia minta kejelasan, apa pun jawabannya.';
  }

  @override
  String grievanceRole(String player) {
    return '$player terus dimainkan di luar posisinya dan sudah muak.';
  }

  @override
  String get grievanceReassure => 'Kamu ada dalam rencanaku';

  @override
  String get grievanceHonest => 'Kamu di bawah pemain lain, dan ini alasannya';

  @override
  String get grievanceDismiss => 'Aku yang memilih tim';

  @override
  String yScorerStar0(String name, String goals) {
    return '$name mencetak $goals gol. Tak ada yang mendekati.';
  }

  @override
  String yScorerStar1(String name, String goals) {
    return '$goals gol dari $name. Ia menggendong tim ini.';
  }

  @override
  String yScorerStar2(String name, String goals) {
    return '$name: $goals gol hari ini. Pemain luar biasa.';
  }

  @override
  String yScorerStar3(String name, String goals) {
    return '$name menjebol gawang mereka $goals kali. Beri hormat.';
  }

  @override
  String yScorerStar4(String name, String goals) {
    return '$goals gol dari $name, dan yang lain hanya penumpang.';
  }

  @override
  String yScorerStar5(String name, String goals) {
    return '$name lagi. $goals. Bayangkan tim ini tanpa dia.';
  }

  @override
  String yScorerStar6(String name, String goals) {
    return '$goals dari $name. Satu orang tak seharusnya menanggung sebanyak ini.';
  }

  @override
  String yScorerStar7(String name, String goals) {
    return 'Tanpa $name, itu berkurang $goals gol dan sore yang sangat berbeda.';
  }

  @override
  String yWinStreak0(String count) {
    return '$count kemenangan beruntun. Apa pun yang dikatakan di ruang ganti itu, kena sasaran.';
  }

  @override
  String yWinStreak1(String count) {
    return 'Sudah $count kali berturut-turut. Tim tak tersandung ke rentetan seperti ini.';
  }

  @override
  String yWinStreak2(String count) {
    return '$count beruntun dan terus berlanjut. Kepercayaan dirinya terlihat dari tribun.';
  }

  @override
  String yWinStreak3(String count) {
    return 'Tak terkalahkan dalam $count laga. Tanya siapa pun yang pernah melatih: itu bagian tersulit.';
  }

  @override
  String yWinStreak4(String count) {
    return '$count beruntun. Nikmati selagi jadwalnya ramah.';
  }

  @override
  String yWinStreak5(String count) {
    return '$count beruntun, dan kita belum mengalahkan siapa pun yang penting.';
  }

  @override
  String yWinStreak6(String count) {
    return 'Rentetan $count. Tanya saya lagi saat diuji.';
  }

  @override
  String yWinStreak7(String count) {
    return '$count berturut-turut. Setiap tim punya satu rentetan seperti ini sekali seumur hidup.';
  }

  @override
  String yLossStreak0(String count) {
    return '$count laga tanpa kemenangan. Pada suatu titik alasan akan habis.';
  }

  @override
  String yLossStreak1(String count) {
    return 'Sudah $count beruntun lewat. Ini bukan lagi kebetulan.';
  }

  @override
  String yLossStreak2(String count) {
    return '$count kekalahan beruntun. Harus ada yang bertanggung jawab.';
  }

  @override
  String yLossStreak3(String count) {
    return 'Tanpa kemenangan dalam $count laga. Terlihat dari cara mereka bermain.';
  }

  @override
  String yLossStreak4(String count) {
    return '$count laga tanpa menang dan kesalahan yang sama tiap pekan.';
  }

  @override
  String yLossStreak5(String count) {
    return '$count beruntun. Apa pun yang dicoba, tidak berhasil.';
  }

  @override
  String yLossStreak6(String count) {
    return '$count beruntun. Ini arah, bukan penurunan sesaat.';
  }

  @override
  String yLossStreak7(String count) {
    return 'Tanpa kemenangan dalam $count laga, dan tak ada yang di atas bersuara.';
  }

  @override
  String yRivalry0(String opponent, String score) {
    return '$opponent $score. Bilang apa saja soal permainannya. Yang ini bernilai dua kali lipat.';
  }

  @override
  String yRivalry1(String opponent, String score) {
    return 'Melawan $opponent, dari semua lawan. $score. Tak ada yang akan lupa di sini.';
  }

  @override
  String yRivalry2(String opponent, String score) {
    return '$score melawan $opponent. Inilah yang akan dibicarakan di warung kopi.';
  }

  @override
  String yRivalry3(String opponent, String score) {
    return 'Tetangga, $score. Hak pamer beres untuk sementara.';
  }

  @override
  String yRivalry4(String opponent, String score) {
    return '$opponent $score. Apa pun yang terjadi tahun ini, ada yang satu ini.';
  }

  @override
  String yRivalry5(String opponent, String score) {
    return '$score melawan $opponent. Sebagian dari kita lebih butuh ini daripada klasemen.';
  }

  @override
  String yRivalry6(String opponent, String score) {
    return '$opponent $score. Dan mereka akan membalas lain kali, mereka selalu begitu.';
  }

  @override
  String yRivalry7(String opponent, String score) {
    return 'Melawan $opponent, $score. Setahun penuh diingatkan soal yang satu ini.';
  }

  @override
  String yInjuryBlow0(String name) {
    return '$name keluar cedera. Itu hal terakhir yang dibutuhkan tim ini.';
  }

  @override
  String yInjuryBlow1(String name) {
    return 'Kehilangan $name mengubah bentuk segalanya.';
  }

  @override
  String yInjuryBlow2(String name) {
    return '$name pincang. Tahan napas.';
  }

  @override
  String yInjuryBlow3(String name) {
    return 'Tak ada $name untuk sementara, kalau begitu. Harus ada yang melangkah maju.';
  }

  @override
  String yInjuryBlow4(String name) {
    return '$name absen. Tentu saja harus $name.';
  }

  @override
  String yInjuryBlow5(String name) {
    return 'Tanpa $name ini jadi tim yang sangat biasa.';
  }

  @override
  String yInjuryBlow6(String name) {
    return '$name cedera lagi. Seseorang harus bertanya kenapa.';
  }

  @override
  String yInjuryBlow7(String name) {
    return 'Kehilangan $name, dan tak ada pengganti di belakangnya. Itu masalah sebenarnya.';
  }

  @override
  String ySentOff0(String name, String minute) {
    return 'Merah untuk $name di menit $minute dan seluruh negeri berbalik menyerangnya. Ia sudah memberi kita lebih dari kebanyakan. Biarkan saja.';
  }

  @override
  String ySentOff1(String name, String minute) {
    return '$name keluar setelah $minute menit. Kejam. Sepuluh pemain dan kita masih melawan, itu bilang sesuatu.';
  }

  @override
  String ySentOff2(String name, String minute) {
    return '$name, $minute menit, kartu merah. Sepuluh pemain sejak itu.';
  }

  @override
  String ySentOff3(String name, String minute) {
    return 'Pengusiran: $name di menit $minute. Bukan laga pertama yang berubah karena satu keputusan.';
  }

  @override
  String ySentOff4(String name, String minute) {
    return 'Hebat. $name keluar di menit $minute dan kita tinggal sepuluh. Lagi.';
  }

  @override
  String ySentOff5(String name, String minute) {
    return '$name diusir setelah $minute menit. Siapa sebenarnya yang melatih disiplin di sini?';
  }

  @override
  String ySentOff6(String name, String minute) {
    return '$minute menit. Segitulah lama $name bisa menahan diri. Sepak bola profesional.';
  }

  @override
  String ySentOff7(String name, String minute) {
    return 'Merah untuk $name di menit $minute, dan saya disuruh percaya ini kemajuan.';
  }

  @override
  String get yBoardPressure0 =>
      'Dewan jadi sangat diam. Itu tak pernah pertanda baik.';

  @override
  String get yBoardPressure1 =>
      'Kabarnya ruang rapat mulai mengajukan pertanyaan.';

  @override
  String get yBoardPressure2 => 'Terasa tanah bergeser di lantai atas.';

  @override
  String get yBoardPressure3 =>
      'Tak ada yang di federasi berkata mendukung. Tarik kesimpulan sendiri.';

  @override
  String get yBoardPressure4 =>
      'Tak ada yang di atas membelanya di depan umum selama berminggu-minggu.';

  @override
  String get yBoardPressure5 =>
      'Federasi menjelek-jelekkan pelatihnya sendiri. Seperti biasa.';

  @override
  String get yBoardPressure6 => 'Saat dewan diam, mereka sudah memutuskan.';

  @override
  String get yBoardPressure7 =>
      'Mereka akan membiarkan ini mengambang sampai jadi keputusan orang lain.';

  @override
  String get yReplies => 'JUGA TENTANG LAGA INI';

  @override
  String get yPlayerGrievance0 =>
      'Sudah bertanya di mana posisiku. Masih menunggu jawaban.';

  @override
  String get yPlayerGrievance1 =>
      'Latihan keras. Tak banyak lagi yang bisa kulakukan.';

  @override
  String get yPlayerGrievance2 =>
      'Ada pertanyaan yang hanya bisa diajukan sekali.';

  @override
  String get yPlayerGrievance3 =>
      'Aku tidak sampai sejauh ini untuk membawa rompi latihan.';

  @override
  String get playerHonoursTitle => 'PRESTASI';

  @override
  String get awardGoldenBall => 'Bola Emas';

  @override
  String get awardGoldenBoot => 'Sepatu Emas';

  @override
  String get awardGoldenGlove => 'Sarung Tangan Emas';

  @override
  String get awardTeamOfTournament => 'Tim Terbaik Turnamen';

  @override
  String get awardPlayerOfYear => 'Pemain Terbaik Dunia Tahun Ini';

  @override
  String get awardYoungPlayerOfYear => 'Pemain Muda Terbaik Tahun Ini';

  @override
  String get playerClubHistory => 'RIWAYAT KLUB';

  @override
  String get playerCareerRecord => 'REKOR KARIER';

  @override
  String get playerInternationalGoals => 'Gol internasional';

  @override
  String get playerRecentForm => 'PERFORMA TERBARU';

  @override
  String get playerMatchHistory => 'RIWAYAT LAGA';

  @override
  String get playerAttributes => 'ATRIBUT';

  @override
  String get playerUnknown => 'Tidak diketahui';

  @override
  String get playerAttrPace => 'Kecepatan';

  @override
  String get playerAttrPhysical => 'Fisik';

  @override
  String get playerAttrTechnical => 'Teknik';

  @override
  String get playerAttrShooting => 'Tembakan';

  @override
  String get playerAttrPassing => 'Umpan';

  @override
  String get playerAttrDribbling => 'Dribel';

  @override
  String get playerAttrTackling => 'Tekel';

  @override
  String get playerAttrPositioning => 'Penempatan posisi';

  @override
  String get playerAttrComposure => 'Ketenangan';

  @override
  String get playerAttrDecisions => 'Pengambilan keputusan';

  @override
  String get playerAttrStamina => 'Stamina';

  @override
  String get playerAttrStrength => 'Kekuatan';

  @override
  String get playerStatCaps => 'Caps';

  @override
  String get playerStatGoals => 'Gol';

  @override
  String get playerStatAssists => 'Assist';

  @override
  String get playerStatAvgRating => 'Rating rata-rata';

  @override
  String get playerStatForm => 'Performa';

  @override
  String get playerStatMotm => 'Pemain Terbaik Laga';

  @override
  String get playerStatCleanSheets => 'Clean sheet';

  @override
  String get playerStatBestGame => 'Laga terbaik';

  @override
  String get playerStatCards => 'Kartu';

  @override
  String playerCardsValue(int yellows, int reds) {
    return '${yellows}K ${reds}M';
  }

  @override
  String get tourSharedYourRun => 'PERJALANAN ANDA';

  @override
  String get tourSharedList => 'Daftar';

  @override
  String get tourSharedBracket => 'Bagan';

  @override
  String get tourSharedVs => 'vs';

  @override
  String tourSharedGroupSeed(String seed) {
    return 'Grup $seed';
  }

  @override
  String get tourSharedThisEdition => 'Edisi ini';

  @override
  String get tourSharedAllTime => 'Sepanjang masa';

  @override
  String get tourSharedUnknown => 'Tidak diketahui';

  @override
  String get tourSharedActive => 'AKTIF';

  @override
  String get tourSharedMedalTable => 'KLASEMEN MEDALI';

  @override
  String get tourSharedPastWinners => 'JUARA TERDAHULU';

  @override
  String tourSharedHost(String host) {
    return 'Tuan rumah: $host';
  }

  @override
  String get tourSharedBeat => 'menang atas';

  @override
  String get tourSharedPens => ' (adu penalti)';

  @override
  String get tourSharedAwardsEmpty =>
      'Penghargaan ditentukan setelah turnamen selesai dimainkan.';

  @override
  String get tourSharedGoldenBall => 'BOLA EMAS';

  @override
  String get tourSharedPlayerOfTournament => 'Pemain Terbaik Turnamen';

  @override
  String get tourSharedGoldenBoot => 'SEPATU EMAS';

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
  String get tourSharedTeamOfTournament => 'TIM TERBAIK TURNAMEN';

  @override
  String get tourSharedStatsEmpty =>
      'Rekor muncul setelah kompetisi punya sejarah.';

  @override
  String get tourSharedRecordScorer => 'PENCETAK GOL REKOR';

  @override
  String get tourSharedStillActive => 'masih aktif';

  @override
  String get tourSharedMostTitles => 'GELAR TERBANYAK';

  @override
  String tourSharedTitlesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gelar',
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
      other: '$count final dijalani',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostGamesPlayed => 'PENAMPILAN TERBANYAK';

  @override
  String tourSharedMatchesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count laga',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostFinalsPlayed => 'PUTARAN FINAL TERBANYAK DIIKUTI';

  @override
  String tourSharedFinalsTournamentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count putaran final',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedBiggestFinalWin => 'KEMENANGAN FINAL TERBESAR';

  @override
  String tourStatsGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gol',
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
      other: '$count gelar',
    );
    return '$_temp0';
  }

  @override
  String tourStatsFinalsContested(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count final dijalani',
    );
    return '$_temp0';
  }

  @override
  String tourStatsMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count laga',
    );
    return '$_temp0';
  }

  @override
  String tourStatsFinalsTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count putaran final',
    );
    return '$_temp0';
  }

  @override
  String get tourStatsLeaders => 'PEMIMPIN SEPANJANG MASA';

  @override
  String get tourStatsTabGames => 'Laga';

  @override
  String get tourStatsTabCups => 'Piala';

  @override
  String get tourStatsTabScorers => 'Pencetak gol';

  @override
  String tourSharedFinalWinDetail(String opponent, int year) {
    return 'vs $opponent · $year';
  }

  @override
  String get tourHolders => 'JUARA BERTAHAN';

  @override
  String tourHoldersSince(int year) {
    return 'juara tahun $year';
  }

  @override
  String get tourSharedAllTimeScorers => 'PENCETAK GOL SEPANJANG MASA';

  @override
  String get tourSharedSummaryEmpty =>
      'Tuan rumah dan stadionnya muncul setelah edisi ini diundi.';

  @override
  String get tourSharedHostHeading => 'TUAN RUMAH';

  @override
  String get tourSharedHostsHeading => 'TUAN RUMAH';

  @override
  String get tourSharedCoHostsHeading => 'TUAN RUMAH BERSAMA';

  @override
  String get tourSharedVenues => 'STADION';

  @override
  String get tourSharedMascot => 'MASKOT';

  @override
  String get tourSharedMatchBall => 'BOLA LAGA';

  @override
  String tourSharedVenueSeats(String city, String capacity) {
    return '$city · $capacity kursi';
  }

  @override
  String get tourSharedCouldNotLoad => 'Gagal memuat.';

  @override
  String get tourSharedHostTbc => 'TUAN RUMAH BELUM DITETAPKAN';

  @override
  String get tourSharedFinalsAreHere => 'PUTARAN FINAL TIBA';

  @override
  String tourSharedHostedBy(String hosts) {
    return 'TUAN RUMAH  $hosts';
  }

  @override
  String get tourSharedLetFinalsBegin => 'Mulai putaran final';

  @override
  String get tourSharedCompetitions => 'KOMPETISI';

  @override
  String get tourSharedWorldRanking => 'Peringkat dunia';

  @override
  String get tourSharedCouldNotLoadTournaments => 'Gagal memuat turnamen.';

  @override
  String get tourSharedPrestigeStage => 'PANGGUNG PRESTISE';

  @override
  String get tourSharedOverview => 'Ikhtisar';

  @override
  String get tourSharedWorldRankingTitle => 'Peringkat Dunia';

  @override
  String get tourSharedYourCompetitions => 'KOMPETISI ANDA';

  @override
  String get tourSharedOtherContinents => 'BENUA LAIN';

  @override
  String get tourSharedComingSoon => 'Turnamen segera hadir';

  @override
  String get tourSharedSoon => 'SEGERA';

  @override
  String get tourSharedNoQualifyingDraw => 'Belum ada undian kualifikasi.';

  @override
  String get tourSharedOpenEnvelope => 'Buka amplopnya';

  @override
  String tourSharedGroupName(String name) {
    return 'GRUP $name';
  }

  @override
  String get tourSharedBall => 'Bola';

  @override
  String get tourSharedPot => 'Pot';

  @override
  String get tourSharedAll => 'Semua';

  @override
  String get tourSharedTapDrawTeam => 'Ketuk untuk mengundi tim berikutnya';

  @override
  String get tourSharedTapDrawPot => 'Ketuk untuk mengundi pot berikutnya';

  @override
  String get tourSharedTapDrawAll => 'Ketuk untuk membuka seluruh undian';

  @override
  String get tourSharedContinue => 'Lanjutkan';

  @override
  String get tourSharedPause => 'Jeda';

  @override
  String get tourSharedPlay => 'Putar';

  @override
  String get tourSharedSkip => 'Lewati';

  @override
  String tourSharedPotNumber(int number) {
    return 'POT $number';
  }

  @override
  String get tourSharedDrawComplete => 'UNDIAN SELESAI';

  @override
  String get tourSharedDrawing => 'MENGUNDI…';

  @override
  String get tourContChampionship => 'KEJUARAAN';

  @override
  String get tourContTabSummary => 'RINGKASAN';

  @override
  String get tourContTabQualifying => 'KUALIFIKASI';

  @override
  String get tourContTabFinals => 'FINAL';

  @override
  String get tourContTabBracket => 'BAGAN';

  @override
  String get tourContTabAwards => 'PENGHARGAAN';

  @override
  String get tourContTabScorers => 'PENCETAK GOL';

  @override
  String get tourContTabHistory => 'SEJARAH';

  @override
  String get tourContTabRecords => 'REKOR';

  @override
  String tourContCouldNotLoadCup(String error) {
    return 'Gagal memuat piala.\n$error';
  }

  @override
  String get tourContNoCupData => 'Tidak ada data piala.';

  @override
  String get tourContUnknown => 'Tidak diketahui';

  @override
  String get tourContGroupsToBeDrawnQual =>
      'Grup kualifikasi diundi saat upacara. Tonton dari beranda untuk tahu siapa lawan Anda.';

  @override
  String get tourContQualSeeded =>
      'Negara Anda langsung diunggulkan ke putaran final. Tidak ada kualifikasi siklus ini.';

  @override
  String tourContBackgroundRegion(String name) {
    return '$name disimulasikan di latar belakang. Hasil muncul di sini seiring setiap babak dimainkan.';
  }

  @override
  String get tourContGroupsToBeDrawnFinals =>
      'Grup putaran final diundi saat upacara. Tonton dari beranda untuk tahu grup Anda.';

  @override
  String get tourContFinalsDrawAfterQual =>
      'Undian putaran final digelar setelah kualifikasi selesai.';

  @override
  String get tourContContestedBeforeWc =>
      'Babak gugur dimainkan sebelum Kejuaraan Dunia.';

  @override
  String tourContChampionsHeading(String name) {
    return 'JUARA $name';
  }

  @override
  String tourContWinnersTitle(String name) {
    return 'Juara $name';
  }

  @override
  String get tourContNoGoalsYet => 'Belum ada gol tercipta.';

  @override
  String tourContGroupHeading(String name) {
    return 'GRUP $name';
  }

  @override
  String get tourContBestRunnersUp => 'RUNNER-UP TERBAIK';

  @override
  String tourContGroupDropdown(String name) {
    return 'Grup $name';
  }

  @override
  String get tourContMatches => 'LAGA';

  @override
  String get tourContNoGroupsDrawn => 'Belum ada grup yang diundi.';

  @override
  String get tourContQualifyingDraw => 'UNDIAN KUALIFIKASI';

  @override
  String get tourContWorldQualifyingDraw => 'UNDIAN KUALIFIKASI DUNIA';

  @override
  String get tourContFinalsDraw => 'UNDIAN PUTARAN FINAL';

  @override
  String get tourContSeedingPots => 'POT UNGGULAN';

  @override
  String get tourContGroupDraw => 'UNDIAN GRUP';

  @override
  String tourContCouldNotLoadDraw(String error) {
    return 'Gagal memuat undian.\n$error';
  }

  @override
  String get tourContDrawNotReady => 'Undian belum siap.';

  @override
  String get tourContContinentalClash => 'DUEL BENUA';

  @override
  String get tourContTabThisCycle => 'SIKLUS INI';

  @override
  String tourContCouldNotLoadClash(String error) {
    return 'Gagal memuat.\n$error';
  }

  @override
  String get tourContNoSaveFound => 'Simpanan tidak ditemukan.';

  @override
  String get tourContClashSoon =>
      'Duel Benua dimainkan setelah kedua juara benua diketahui.';

  @override
  String get tourContTwoContinentsOneMatch => 'DUA BENUA, SATU LAGA';

  @override
  String get tourContVersusShort => 'vs';

  @override
  String tourContWinTheClash(String name) {
    return '$name menangi Duel Benua';
  }

  @override
  String get tourContNoClashYet => 'Belum ada Duel Benua yang dimainkan.';

  @override
  String get tourContNationsCup => 'PIALA BANGSA-BANGSA';

  @override
  String get tourContTabLeagues => 'LIGA';

  @override
  String get tourContTabFinalsFour => 'EMPAT BESAR FINAL';

  @override
  String tourContCouldNotLoad(String error) {
    return 'Gagal memuat.\n$error';
  }

  @override
  String get tourContNoNationsCupGoals =>
      'Belum ada gol Piala Bangsa-Bangsa tercatat.';

  @override
  String get tourContNoNationsCupChampions =>
      'Belum ada juara Piala Bangsa-Bangsa.';

  @override
  String get tourContNationsCupOffSeason =>
      'Piala Bangsa-Bangsa siklus ini dimulai setelah putaran final benua. Juara terdahulu ada di Sejarah.';

  @override
  String get tourContNationsCupGroupsSoon =>
      'Grup Piala Bangsa-Bangsa siklus ini diundi dalam upacara undian. Tonton dari beranda untuk tahu siapa lawan Anda.';

  @override
  String get tourContLeagueNoGroups =>
      'Tidak ada laga di liga ini pada putaran ini.';

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
      'Empat Besar Final diperebutkan para juara grup Liga A setelah fase grup selesai.';

  @override
  String tourContLeagueChip(String letter) {
    return 'Liga $letter';
  }

  @override
  String tourContLeagueChipStar(String letter) {
    return 'Liga $letter ★';
  }

  @override
  String get tourContSemiFinals => 'SEMIFINAL';

  @override
  String get tourContFinal => 'FINAL';

  @override
  String get tourContNationsCupDraw => 'UNDIAN PIALA BANGSA-BANGSA';

  @override
  String get tourContIntercontinentalPlayoff => 'PLAY-OFF ANTARBENUA';

  @override
  String get tourContNoPlayoffThisCycle => 'Tidak ada play-off siklus ini.';

  @override
  String get tourContPlayoffIntro =>
      'Dua tempat di Kejuaraan Dunia diperebutkan lewat babak gugur para tim terbaik yang gagal lolos langsung.';

  @override
  String get tourContPlayoffThrough =>
      'Anda lolos lewat play-off. Anda tampil di Kejuaraan Dunia!';

  @override
  String get tourContPlayoffOut =>
      'Anda gagal di play-off. Tidak ada Kejuaraan Dunia kali ini.';

  @override
  String get tourContContinue => 'Lanjutkan';

  @override
  String get tourContPlayoffFinals => 'FINAL PLAY-OFF';

  @override
  String get tourContPlayoffSeeded => 'Unggulan (bye)';

  @override
  String get tourCupTabSummary => 'RINGKASAN';

  @override
  String get tourCupTabQualifying => 'KUALIFIKASI';

  @override
  String get tourCupTabPlayoff => 'PLAY-OFF';

  @override
  String get tourCupPlayoffSoon =>
      'Play-off antarbenua ditentukan setelah kualifikasi semua konfederasi selesai.';

  @override
  String get tourCupTabFinals => 'PUTARAN FINAL';

  @override
  String get tourCupTabBracket => 'BAGAN';

  @override
  String get tourCupTabAwards => 'PENGHARGAAN';

  @override
  String get tourCupTabScorers => 'PENCETAK GOL';

  @override
  String get tourCupTabHistory => 'SEJARAH';

  @override
  String get tourCupTabRecords => 'REKOR';

  @override
  String get tourCupTitle => 'KEJUARAAN DUNIA';

  @override
  String get tourCupNoData => 'Tidak ada data turnamen.';

  @override
  String tourCupLoadError(String error) {
    return 'Gagal memuat turnamen.\n$error';
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
  String get tourCupAllTimeScorers => 'PENCETAK GOL SEPANJANG MASA';

  @override
  String get tourCupAllConfederations => 'Semua konfederasi';

  @override
  String get tourCupBestRunnersUp => 'Runner-up terbaik';

  @override
  String get tourCupCompWorld => 'Kejuaraan Dunia';

  @override
  String get tourCupCompEurope => 'Kejuaraan Eropa';

  @override
  String get tourCupCompSAmerica => 'Piala Amerika Selatan';

  @override
  String get tourCupDestRoundOf16 => 'babak 16 besar';

  @override
  String get tourCupDestKnockouts => 'babak gugur';

  @override
  String get tourCupDestFinals => 'putaran final';

  @override
  String get tourCupDestFinalsPlayoff => 'play-off putaran final';

  @override
  String get tourCupDestIntercontPlayoff => 'play-off antarbenua';

  @override
  String get tourCupFinalsDrawnAfterQual =>
      'Putaran final diundi setelah kualifikasi berakhir.';

  @override
  String get tourCupFinalsDrawSoon =>
      'Grup akan diundi. Tonton undian Kejuaraan Dunia dari beranda untuk melihatnya.';

  @override
  String tourCupGroupName(String name) {
    return 'Grup $name';
  }

  @override
  String tourCupGroupNameShort(String name) {
    return 'Grup $name';
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
  String get tourCupIntercontPlayoff => 'Play-off antarbenua';

  @override
  String get tourCupKnockoutSoon => 'Bagan dimulai setelah fase grup berakhir.';

  @override
  String get tourCupMatches => 'LAGA';

  @override
  String get tourCupMedalTable => 'KLASEMEN MEDALI';

  @override
  String get tourCupMostTitles => 'GELAR TERBANYAK';

  @override
  String tourCupMostTitlesValue(String nation, int titles, int editions) {
    return '$nation: $titles gelar dari $editions edisi';
  }

  @override
  String get tourCupNoGoals => 'Belum ada gol.';

  @override
  String get tourCupNoGroups => 'Belum ada grup yang diundi.';

  @override
  String get tourCupNoHistory => 'Belum ada sejarah.';

  @override
  String get tourCupPastWinners => 'JUARA TERDAHULU';

  @override
  String get tourCupPlayoffIntro =>
      'Dua tempat di Kejuaraan Dunia diperebutkan lewat babak gugur para tim terbaik yang gagal lolos langsung.';

  @override
  String get tourCupQualDrawSoon =>
      'Grup akan diundi. Tonton undian kualifikasi dari beranda untuk melihatnya.';

  @override
  String tourCupRegionYours(String region) {
    return '$region · wilayah Anda';
  }

  @override
  String tourCupScorePens(int home, int away) {
    return '$home–$away (pen.)';
  }

  @override
  String get tourCupSegAllTime => 'Sepanjang masa';

  @override
  String get tourCupSegFinals => 'Putaran final';

  @override
  String get tourCupSegQualifying => 'Kualifikasi';

  @override
  String get playerTraitsTitle => 'DIKENAL KARENA';

  @override
  String get traitBigGame => 'Pemain laga besar';

  @override
  String get traitBigGameBlurb => 'Tampil lebih baik di laga gugur.';

  @override
  String get traitSetPiece => 'Spesialis bola mati';

  @override
  String get traitSetPieceBlurb =>
      'Umpan lebih baik dan lebih banyak gol dari bola mati.';

  @override
  String get traitHothead => 'Berdarah panas';

  @override
  String get traitHotheadBlurb =>
      'Jauh lebih sering menerima kartu daripada rekan setimnya.';

  @override
  String get traitIronMan => 'Si baja';

  @override
  String get traitIronManBlurb => 'Jarang cedera dan lebih lambat lelah.';

  @override
  String get traitWonderkid => 'Wonderkid';

  @override
  String get traitWonderkidBlurb =>
      'Muda, sudah bagus, dan masih berkembang pesat.';

  @override
  String get traitLeader => 'Pemimpin';

  @override
  String get traitLeaderBlurb =>
      'Mengangkat semangat setiap rekan di lapangan.';

  @override
  String get traitPacey => 'Kencang';

  @override
  String get traitPaceyBlurb =>
      'Kecepatan luar biasa, ancaman di belakang garis pertahanan.';

  @override
  String get traitOldHead => 'Veteran bijak';

  @override
  String get traitOldHeadBlurb =>
      'Veteran yang kecerdasan membaca permainannya melampaui daya tahan kakinya.';

  @override
  String get traitWasteful => 'Boros peluang';

  @override
  String get traitWastefulBlurb => 'Terlalu sering membuang peluang bagus.';

  @override
  String get objectiveWorldCup => 'Kejuaraan Dunia';

  @override
  String get objectiveWinTournament => 'Juara';

  @override
  String get objectiveQualifyGeneric => 'Lolos';

  @override
  String hubBoardObjectiveFor(String competition, String label) {
    return '$competition: $label';
  }

  @override
  String get objectiveWinWorldCup => 'Juarai Kejuaraan Dunia';

  @override
  String get objectiveReachFinal => 'Capai final';

  @override
  String get objectiveReachSemis => 'Capai semifinal';

  @override
  String get objectiveReachQuarters => 'Capai perempat final';

  @override
  String get objectiveReachKnockouts => 'Capai babak gugur';

  @override
  String get objectiveQualify => 'Lolos ke Kejuaraan Dunia';

  @override
  String get finishChampions => 'Juara';

  @override
  String get finishRunnersUp => 'Runner-up';

  @override
  String get finishSemiFinals => 'Semifinal';

  @override
  String get finishQuarterFinals => 'Perempat final';

  @override
  String get finishRoundOf16 => 'Babak 16 besar';

  @override
  String get finishGroupStage => 'Fase grup';

  @override
  String get objectiveQualifyingTopHalf => 'Finis di paruh atas kualifikasi';

  @override
  String get finishQualifyingTopHalf => 'Paruh atas grup kualifikasi';

  @override
  String get finishQualifyingBottomHalf => 'Paruh bawah grup kualifikasi';

  @override
  String get objectiveNcWinIt => 'Juarai Piala Bangsa-Bangsa';

  @override
  String get objectiveNcReachFinal => 'Capai final Piala Bangsa-Bangsa';

  @override
  String get objectiveNcFinalsFour => 'Capai Empat Besar Final';

  @override
  String get objectiveNcWinGroup => 'Juarai grup dan naik kasta';

  @override
  String get objectiveNcTopHalf => 'Finis di paruh atas grup';

  @override
  String get objectiveNcSurvive => 'Hindari degradasi';

  @override
  String get finishNcChampions => 'Juara Piala Bangsa-Bangsa';

  @override
  String get finishNcFinalsFour => 'Empat Besar Final';

  @override
  String get finishNcGroupWinners => 'Juara grup';

  @override
  String get finishNcTopHalf => 'Paruh atas grup';

  @override
  String get finishNcStayedUp => 'Bertahan';

  @override
  String get finishNcBottom => 'Dasar grup';

  @override
  String get careerNationsCupLabel => 'Piala Bangsa-Bangsa';

  @override
  String get squadDevPlayer => 'PEMAIN';

  @override
  String get squadDevAge => 'USIA';

  @override
  String get squadDevPosition => 'POS';

  @override
  String get squadDevChange => 'RATING';

  @override
  String get squadDevNew => 'BARU';

  @override
  String get squadDevRetired => 'PENSIUN';

  @override
  String get squadDevEmpty =>
      'Setahun yang tenang. Tidak ada perubahan di skuad.';

  @override
  String get squadDevTierRegulars => 'LANGGANAN';

  @override
  String get squadDevTierFringe => 'PINGGIRAN';

  @override
  String get squadDevTierYouth => 'MUDA';

  @override
  String get boardObjectivesTitle => 'Target dewan';

  @override
  String get boardObjectivesConfidence => 'Kepercayaan dewan';

  @override
  String boardObjectiveBeatenBy(String result, int rounds) {
    String _temp0 = intl.Intl.pluralLogic(
      rounds,
      locale: localeName,
      other: '$rounds babak lebih baik dari target',
    );
    return '$result: $_temp0';
  }

  @override
  String boardObjectiveShortBy(String result, int rounds) {
    String _temp0 = intl.Intl.pluralLogic(
      rounds,
      locale: localeName,
      other: 'kurang $rounds babak',
    );
    return '$result: $_temp0';
  }

  @override
  String get boardObjectivesPending => 'BELUM DITENTUKAN';

  @override
  String boardObjectiveSoFar(String result) {
    return 'SEJAUH INI · $result';
  }

  @override
  String get boardObjectivesEmpty =>
      'Dewan belum menetapkan target untuk siklus ini.';

  @override
  String get tourContBestWinners => 'JUARA GRUP TERBAIK';

  @override
  String get tourContBestThirds => 'PERINGKAT KETIGA TERBAIK';

  @override
  String tourContBestPlaced(String position) {
    return 'PERINGKAT KE-$position TERBAIK';
  }

  @override
  String squadDevPageOf(String page, String pages, String total) {
    return '$page/$pages · $total pemain';
  }

  @override
  String get matchSoldOut => 'TIKET HABIS';

  @override
  String matchAttendanceOf(String attendance, String capacity) {
    return '$attendance dari $capacity kursi terisi';
  }

  @override
  String get matchGroundTitle => 'STADION';

  @override
  String get absenceInjured => 'Cedera';

  @override
  String get absenceSuspended => 'Skorsing';

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
      other: '$countString laga',
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
      'Tentukan lima eksekutor, berurutan. Ketuk slot untuk mengubahnya.';

  @override
  String penaltyOrderPick(int number) {
    return 'Tendangan $number';
  }

  @override
  String get penaltyOrderPickBlurb =>
      'Pilih siapa yang maju. Bar menunjukkan ketenangannya dari titik putih.';

  @override
  String get penaltyOrderConfirm => 'Mulai';

  @override
  String get penaltyOrderCancel => 'Kembali';

  @override
  String get youthTitle => 'Muda';

  @override
  String get youthEmptyLevel => 'Belum ada pemain di tingkat ini.';

  @override
  String get youthReleased => 'Dilepas tahun ini';

  @override
  String get u21Title => 'U-21';

  @override
  String get u21Blurb =>
      'Generasi berikutnya, prospek terbaik di atas. Bintang kosong adalah perkiraan pemandu bakat. Panggil pemain ke timnas untuk tahu kualitas aslinya.';

  @override
  String get u21Empty =>
      'Tidak ada pemain di bawah 21 tahun di kolam pemain saat ini. Angkatan baru datang bersama siklus baru.';

  @override
  String u21Breakout(int gain) {
    return '+$gain TAHUN INI';
  }

  @override
  String u21AgeCaps(int age, int caps) {
    return 'Usia $age · $caps caps';
  }

  @override
  String u21AgeUncapped(int age) {
    return 'Usia $age · belum bermain';
  }

  @override
  String get u21CallUps => 'Ke pemanggilan pemain';

  @override
  String get youthWatching => 'Dipantau';

  @override
  String get youthWatchEmpty =>
      'Belum ada yang ditandai. Tandai pemain muda di tingkat mana pun dan ia muncul di sini, lengkap dengan perkembangannya.';

  @override
  String get youthWatchMark => 'Pantau pemain ini';

  @override
  String get youthWatchUnmark => 'Berhenti memantau';

  @override
  String youthWatchMarked(int rating, int age) {
    return 'Ditandai di rating $rating, usia $age';
  }

  @override
  String get youthWatchSenior => 'Naik ke kolam senior';

  @override
  String get youthWatchReleased => 'Dilepas akademi';

  @override
  String get youthWatchGone => 'Tak lagi di jenjang usia muda';

  @override
  String get tacticsYouth => 'U-21';

  @override
  String get pressSquad => 'Skuad';

  @override
  String get pressBoard => 'Dewan';

  @override
  String get pressNoEffect => 'Tak ada yang terlalu memikirkannya';

  @override
  String get matchNeutralGround => 'NETRAL';

  @override
  String get matchExtraTimeAhead => 'PERPANJANGAN WAKTU';

  @override
  String get matchExtraTimeHalf => 'PERPANJANGAN WAKTU · TURUN MINUM';

  @override
  String get matchClockFullTime => 'PELUIT AKHIR';

  @override
  String get matchClockAfterExtraTime => 'SETELAH PERPANJANGAN';

  @override
  String get matchClockPenalties => 'ADU PENALTI';

  @override
  String get matchClockFullTimePenalties => 'AKHIR · ADU PENALTI';

  @override
  String get hubEventPressConference => 'Hadapi pers';

  @override
  String get hubEventPressConferenceSub =>
      'Media dunia ingin bicara sebelum laga pertama Anda';

  @override
  String get squadDevWonderkid => 'WONDERKID';

  @override
  String get tacticsPlaystyle => 'Gaya bermain';

  @override
  String get tacticsPlaystyleBlurb =>
      'Pilih cara tim bermain; pengaturan di bawah menyempurnakannya.';

  @override
  String get tacticsPlaystyleCustom =>
      'Pengaturan Anda sendiri. Tidak ada gaya bernama yang cocok dengan pengaturan ini.';

  @override
  String get playstyleCustom => 'Kustom';

  @override
  String get playstyleBalanced => 'Seimbang';

  @override
  String get playstylePossession => 'Penguasaan bola';

  @override
  String get playstyleGegenpress => 'Gegenpress';

  @override
  String get playstyleCounter => 'Serangan balik';

  @override
  String get playstyleDirect => 'Langsung';

  @override
  String get playstyleLowBlock => 'Blok rendah';

  @override
  String get playstyleWingPlay => 'Main sayap';

  @override
  String get playstyleBalancedBlurb =>
      'Kokoh di kedua babak, tanpa berlebihan.';

  @override
  String get playstylePossessionBlurb =>
      'Kuasai bola, alirkan dengan sabar, persempit lapangan.';

  @override
  String get playstyleGegenpressBlurb =>
      'Rebut bola kembali begitu hilang, tinggi di area lawan.';

  @override
  String get playstyleCounterBlurb =>
      'Bertahan dalam, tetap rapat, lalu serang balik dengan cepat.';

  @override
  String get playstyleDirectBlurb =>
      'Bola cepat ke depan dan berebut bola kedua.';

  @override
  String get playstyleLowBlockBlurb =>
      'Dalam, sempit, dan sangat sulit ditembus.';

  @override
  String get playstyleWingPlayBlurb =>
      'Lebarkan lapangan, lewat sisi luar, lalu umpan silang.';

  @override
  String get nationsRandomTeam => 'Tim acak';

  @override
  String get nationsFromTheBottom => 'Dari bawah';

  @override
  String get bottomStartTitle => 'Menganggur';

  @override
  String get bottomStartHeading => 'Tiga federasi ingin bicara';

  @override
  String get bottomStartBlurb =>
      'Anda tidak punya pekerjaan dan reputasi. Hanya tim-tim ini yang mau memberi Anda kesempatan. Ambil satu dan bangun sesuatu dari nol.';

  @override
  String get bottomStartAccept => 'Ambil';

  @override
  String get bottomStartBack => 'Kembali ke menu';

  @override
  String bottomStartRankOf(int rank, int total) {
    return '$rank dari $total di dunia';
  }

  @override
  String get campTitle => 'Basecamp';

  @override
  String campBasedIn(String host) {
    return 'Berbasis di $host';
  }

  @override
  String get campBlurb =>
      'Tempat skuad tinggal selama turnamen. Tidak bisa diubah setelah turnamen dimulai, dan memengaruhi tiga hal di setiap laga: seberapa bugar mereka tiba, secepat apa cedera pulih, dan seberapa tajam mereka.';

  @override
  String get campEffectTravel => 'Tiba bugar';

  @override
  String get campEffectRecovery => 'Cedera pulih';

  @override
  String get campEffectSharpness => 'Ketajaman laga';

  @override
  String get campTerrainCity => 'Pusat kota';

  @override
  String get campTerrainCoastal => 'Resor pantai';

  @override
  String get campTerrainMountain => 'Peristirahatan gunung';

  @override
  String get campTerrainAltitude => 'Kamp dataran tinggi';

  @override
  String get campTerrainNationalCentre => 'Pusat nasional';

  @override
  String get campTerrainCityBlurb =>
      'Semua ada di depan pintu dan tak perlu perjalanan jauh, tapi tak ada ketenangan dan tak bisa lepas dari keramaian.';

  @override
  String get campTerrainCoastalBlurb =>
      'Tenang, nyaman, dan baik untuk suasana hati; perjalanan bus panjang ke setiap stadion.';

  @override
  String get campTerrainMountainBlurb =>
      'Udara sejuk dan fasilitas medis kelas satu yang memulihkan cedera ringan dengan cepat, jauh dari tempat turnamen.';

  @override
  String get campTerrainAltitudeBlurb =>
      'Latihan yang berat, dan kaki yang kuat bertahan hingga akhir turnamen.';

  @override
  String get campTerrainNationalCentreBlurb =>
      'Fasilitas milik federasi sendiri: tidak spektakuler, tapi tak ada yang bisa salah.';

  @override
  String get hubEventChooseCamp => 'Pilih basecamp';

  @override
  String hubEventChooseCampSub(String host) {
    return 'Tempat skuad akan berbasis di $host';
  }

  @override
  String get tacticsTabBench => 'Cadangan';

  @override
  String get squadSearchHint => 'Cari berdasarkan nama atau klub';

  @override
  String get squadFilterAll => 'Semua';

  @override
  String get squadFilterInSquad => 'Di skuad';

  @override
  String get squadFilterUncapped => 'Belum bermain';

  @override
  String get squadFilterUnavailable => 'Tidak tersedia';

  @override
  String get squadLineAll => 'Semua lini';

  @override
  String get squadSortBy => 'Urutkan';

  @override
  String get squadSortRating => 'Rating';

  @override
  String get squadSortCaps => 'Caps';

  @override
  String get squadSortGoals => 'Gol';

  @override
  String get squadSortAge => 'Usia';

  @override
  String get squadSortName => 'Nama';

  @override
  String get squadLegendTitle => 'Arti tanda';

  @override
  String get squadLegendStarting => 'Di susunan pemain inti Anda';

  @override
  String get squadLegendCalledUp => 'Dipanggil, di bangku cadangan';

  @override
  String get squadLegendRatingUp => 'Rating naik tahun ini';

  @override
  String get squadLegendRatingDown => 'Rating turun tahun ini';

  @override
  String get squadLegendInjured => 'Cedera, tidak tersedia';

  @override
  String get squadLegendSuspended => 'Skorsing, tidak tersedia';

  @override
  String get squadLegendTraits => 'DIKENAL KARENA';

  @override
  String squadShowingOf(int shown, int total) {
    return 'Menampilkan $shown dari $total pemain';
  }

  @override
  String get squadNobodyMatches =>
      'Tak ada pemain yang cocok dengan filter itu.';

  @override
  String get squadStatPool => 'Kolam';

  @override
  String get squadStatInSquad => 'Dipanggil';

  @override
  String get squadMostCapped => 'Caps terbanyak';

  @override
  String get squadTopScorer => 'Top skor';

  @override
  String squadCapsValue(String name, int caps) {
    return '$name · $caps caps';
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
  String get squadCapsShort => 'Caps';

  @override
  String get squadGoalsShort => 'Gol';

  @override
  String get recordsRecordBookSubtitle => 'Caps, gol, dan rekor utama tim';

  @override
  String get statsLegacy => 'WARISAN';

  @override
  String tacticsSubAlreadyOff(String name) {
    return '$name sudah ditarik keluar dan tidak bisa masuk lagi.';
  }

  @override
  String tacticsSubSentOff(String name) {
    return '$name telah diusir wasit dan tidak ikut bermain lagi.';
  }

  @override
  String get tacticsInjuredShort => 'CEDERA';

  @override
  String get tacticsSuspendedShort => 'SKORSING';

  @override
  String get confEurope => 'Eropa';

  @override
  String get confSouthAmerica => 'Amerika Selatan';

  @override
  String get confNorthAmerica => 'Amerika Utara';

  @override
  String get confAfrica => 'Afrika';

  @override
  String get confAsia => 'Asia';

  @override
  String get confOceania => 'Oseania';

  @override
  String get compWorldCup => 'Kejuaraan Dunia';

  @override
  String get compWorldCupFinals => 'Putaran Final Kejuaraan Dunia';

  @override
  String get compWorldCupQualifying => 'Kualifikasi Kejuaraan Dunia';

  @override
  String compQualifiers(String region) {
    return 'Kualifikasi $region';
  }

  @override
  String get compFriendlies => 'Laga uji coba';

  @override
  String get compNationsCup => 'Piala Bangsa-Bangsa';

  @override
  String get compContinentalClash => 'Duel Benua';

  @override
  String get compIntercontinentalPlayoff => 'Play-off Antarbenua';

  @override
  String get compContinentalChampionship => 'Kejuaraan Benua';

  @override
  String get compEuropeanChampionship => 'Kejuaraan Eropa';

  @override
  String get compSouthAmericaCup => 'Piala Amerika Selatan';

  @override
  String get compAfricanChampionship => 'Kejuaraan Afrika';

  @override
  String get compAsianChampionship => 'Kejuaraan Asia';

  @override
  String get compNorthAmericaCup => 'Piala Amerika Utara';

  @override
  String get compOceaniaCup => 'Piala Oseania';

  @override
  String get msgANation => 'Sebuah negara';

  @override
  String get msgAPlayer => 'Seorang pemain';

  @override
  String get msgAHostNation => 'negara tuan rumah';

  @override
  String get msgCycleTitle1 => 'Siklus baru dimulai';

  @override
  String msgCycleTitle2(int year) {
    return 'Jalan menuju $year terbuka';
  }

  @override
  String get msgCycleTitle3 => 'Kampanye baru menyingsing';

  @override
  String get msgCycleTitle4 => 'Kembali bekerja';

  @override
  String msgCycleBody1(int year) {
    return 'Jalan menuju Kejuaraan Dunia $year dimulai dari sini.';
  }

  @override
  String msgCycleBody2(int year) {
    return 'Siklus baru. Kejuaraan Dunia $year adalah targetnya.';
  }

  @override
  String msgCycleBody3(int year) {
    return 'Empat tahun menuju Kejuaraan Dunia $year. Kerja dimulai sekarang.';
  }

  @override
  String msgCycleBody4(int year) {
    return 'Kampanye $year dimulai hari ini.';
  }

  @override
  String msgContHostTitle(String cup, String host) {
    return 'Tuan rumah $cup: $host';
  }

  @override
  String msgContHostBody(String host, String cup) {
    return '$host akan menjadi tuan rumah $cup berikutnya.';
  }

  @override
  String msgContQualDrawTitle(String cup) {
    return 'Undian kualifikasi $cup';
  }

  @override
  String msgContQualDrawBody(String cup) {
    return 'Grup kualifikasi $cup telah diundi.';
  }

  @override
  String msgWcHostTitle(String host, int year) {
    return 'Tuan rumah Kejuaraan Dunia $year: $host';
  }

  @override
  String msgWcHostBody(String host, int year) {
    return '$host akan menjadi tuan rumah Kejuaraan Dunia $year.';
  }

  @override
  String get msgWcQualDrawTitle => 'Undian kualifikasi Kejuaraan Dunia';

  @override
  String get msgWcQualDrawBody =>
      'Grup kualifikasi Kejuaraan Dunia telah diundi.';

  @override
  String msgContFinalsDrawTitle(String cup) {
    return 'Undian putaran final $cup';
  }

  @override
  String msgContFinalsDrawBody(String cup) {
    return 'Grup putaran final $cup telah diundi.';
  }

  @override
  String get msgWcFinalsDrawTitle => 'Undian putaran final Kejuaraan Dunia';

  @override
  String msgWcFinalsDrawBody(int year) {
    return 'Undian putaran final Kejuaraan Dunia $year telah digelar.';
  }

  @override
  String get msgQualWcTitle1 => 'Lolos ke Kejuaraan Dunia';

  @override
  String get msgQualWcTitle2 => 'Tiket Kejuaraan Dunia di tangan';

  @override
  String get msgQualWcTitle3 => 'Kita berangkat ke Kejuaraan Dunia';

  @override
  String get msgQualWcTitle4 => 'Tiket terkunci';

  @override
  String msgQualWcBody1(int year) {
    return 'Anda lolos ke putaran final Kejuaraan Dunia $year.';
  }

  @override
  String msgQualWcBody2(int year) {
    return 'Resmi: negara Anda tampil di Kejuaraan Dunia $year.';
  }

  @override
  String msgQualWcBody3(int year) {
    return 'Tempat di Kejuaraan Dunia $year sudah dipastikan.';
  }

  @override
  String msgQualWcBody4(int year) {
    return 'Anda lolos ke putaran final Kejuaraan Dunia $year.';
  }

  @override
  String msgQualContTitle1(String cup) {
    return 'Lolos ke $cup';
  }

  @override
  String msgQualContTitle2(String cup) {
    return 'Tiket $cup di tangan';
  }

  @override
  String msgQualContTitle3(String cup) {
    return 'Lolos ke $cup';
  }

  @override
  String msgQualContBody1(String cup) {
    return 'Anda lolos ke putaran final $cup.';
  }

  @override
  String msgQualContBody2(String cup) {
    return 'Negara Anda memastikan tempat di $cup.';
  }

  @override
  String msgQualContBody3(String cup) {
    return 'Anda lolos ke $cup.';
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
    return 'Anda juarai $comp!';
  }

  @override
  String msgChampTitleOther1(String comp) {
    return '$comp sudah ada juaranya';
  }

  @override
  String msgChampTitleOther2(String comp) {
    return 'Juara $comp dinobatkan';
  }

  @override
  String msgChampTitleOther3(String comp) {
    return '$comp telah dimenangi';
  }

  @override
  String msgChampBodyMine1(String comp, String loser, String result, int year) {
    return 'Negara Anda adalah juara $comp $year, setelah mengalahkan $loser$result.';
  }

  @override
  String msgChampBodyMine2(String comp, String loser, String result, int year) {
    return 'Anda menjuarai $comp $year, menyingkirkan $loser$result.';
  }

  @override
  String msgChampBodyMine3(String comp, String loser, String result, int year) {
    return '$comp $year milik Anda. $loser dikalahkan$result.';
  }

  @override
  String msgChampBodyOther1(
    String winner,
    String comp,
    String loser,
    String result,
    int year,
  ) {
    return '$winner menjuarai $comp $year, mengalahkan $loser$result.';
  }

  @override
  String msgChampBodyOther2(
    String winner,
    String comp,
    String loser,
    String result,
    int year,
  ) {
    return '$winner adalah juara $comp $year, setelah menundukkan $loser$result.';
  }

  @override
  String msgFinalScoreSuffix(int home, int away) {
    return ' $home–$away di final';
  }

  @override
  String msgFinalPensSuffix(int home, int away) {
    return ' lewat adu penalti, setelah final berakhir $home–$away';
  }

  @override
  String get msgWpotyTitle => 'Pemain Terbaik Dunia';

  @override
  String msgWpotyBodyMine(String name, String nation, int year) {
    return '$name ($nation) dinobatkan sebagai Pemain Terbaik Dunia $year, salah satu pemain Anda.';
  }

  @override
  String msgWpotyBodyOther(String name, String nation, int year) {
    return '$name ($nation) dinobatkan sebagai Pemain Terbaik Dunia $year.';
  }

  @override
  String get msgYpotTitle => 'Pemain Muda Terbaik Turnamen';

  @override
  String msgYpotBodyMine(String name, String nation, int age, int year) {
    return '$name ($nation), usia $age, dinobatkan sebagai Pemain Muda Terbaik Turnamen $year, salah satu pemain Anda.';
  }

  @override
  String msgYpotBodyOther(String name, String nation, int age, int year) {
    return '$name ($nation), usia $age, dinobatkan sebagai Pemain Muda Terbaik Turnamen $year.';
  }

  @override
  String msgRankHold1(int rank) {
    return 'Anda bertahan di #$rank.';
  }

  @override
  String msgRankHold2(int rank) {
    return 'Tak ada perubahan, tetap #$rank.';
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
      other: '$move peringkat',
    );
    return 'Naik $_temp0 secara total, ke #$rank.';
  }

  @override
  String msgRankUp2(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move peringkat',
    );
    return 'Kenaikan $_temp0 membawa Anda ke #$rank.';
  }

  @override
  String msgRankUp3(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move peringkat',
    );
    return 'Naik $_temp0, kini #$rank.';
  }

  @override
  String msgRankDown1(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move peringkat',
    );
    return 'Turun $_temp0 secara total, ke #$rank.';
  }

  @override
  String msgRankDown2(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move peringkat',
    );
    return 'Penurunan $_temp0 menjatuhkan Anda ke #$rank.';
  }

  @override
  String msgRankDown3(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move peringkat',
    );
    return 'Turun $_temp0, kini #$rank.';
  }

  @override
  String get msgRankLeadYou => 'Anda memuncaki dunia.';

  @override
  String msgRankLeadOther(String nation) {
    return '$nation memuncaki dunia.';
  }

  @override
  String msgRankTitle(int rank) {
    return 'Peringkat dunia · #$rank';
  }

  @override
  String msgRankBody(String lead, String movement) {
    return 'Peringkat dunia telah diperbarui. $lead $movement';
  }

  @override
  String msgRankJumpTitleUp(int rank) {
    return 'Naik ke #$rank';
  }

  @override
  String msgRankJumpTitleDown(int rank) {
    return 'Turun ke #$rank';
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
      other: '$move peringkat',
    );
    return '$tournament menggeser peringkat dunia. $nation masuk di #$from dan keluar di #$to, naik $_temp0.';
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
      other: '$move peringkat',
    );
    return '$tournament menggeser peringkat dunia. $nation masuk di #$from dan keluar di #$to, turun $_temp0.';
  }

  @override
  String get rankingSinceWcDraw => 'Sejak undian Kejuaraan Dunia';

  @override
  String get rankingSinceCycleStart => 'Sejak kampanye dimulai';

  @override
  String rankingMovedFromTo(int from, int now) {
    return '#$from ke #$now';
  }

  @override
  String msgCapsTitle(String name, int count) {
    return '$name capai $count caps';
  }

  @override
  String msgCapsBody(String name, int count) {
    return '$name kini telah tampil $count kali untuk negara Anda.';
  }

  @override
  String msgGoalsTitle(String name, int count) {
    return '$name capai $count gol';
  }

  @override
  String msgGoalsBody(String name, int count) {
    return '$name telah mencetak $count gol internasional untuk negara Anda.';
  }

  @override
  String msgDevTitle(int year) {
    return 'Perkembangan skuad · $year';
  }

  @override
  String msgThroughTitle(int year) {
    return 'Naik dari akademi · $year';
  }

  @override
  String get msgThroughNote =>
      'Ini bukan angkatan baru. Mereka adalah pemain yang masuk di usia sebelas tahun dan kini tumbuh menjadi bagian kolam senior.';

  @override
  String msgNewFacesTitle(int year) {
    return 'Wajah baru · $year';
  }

  @override
  String get msgIntakeNoteAcademy =>
      'Investasi akademi terlihat hasilnya: angkatan ini datang lebih kuat dari seharusnya.';

  @override
  String get msgIntakeNoteStanding =>
      'Negara ini menyoroti tim Anda: dengan tim yang naik di peringkat dunia, anak-anak terbaik memilih sepak bola, dan angkatan ini datang lebih kuat karenanya.';

  @override
  String get msgIntakeNoteBoth =>
      'Dana akademi dan kenaikan tim di peringkat dunia sama-sama terlihat hasilnya: angkatan ini datang lebih kuat dari seharusnya.';

  @override
  String msgIntakeTitle(int year) {
    return 'Angkatan akademi · $year';
  }

  @override
  String msgRetireCaptainTitle(String name) {
    return 'Kapten Anda, $name, pensiun';
  }

  @override
  String msgRetireTitle(String name) {
    return '$name pensiun dari timnas';
  }

  @override
  String msgRetireBody(String name, int age) {
    return '$name telah pensiun dari sepak bola internasional di usia $age.';
  }

  @override
  String msgRetireBodyWith(String name, String tally, int age) {
    return '$name telah pensiun dari sepak bola internasional di usia $age, dengan catatan $tally.';
  }

  @override
  String msgTallyCaps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count caps',
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
      ' Ban kapten kosong. Tunjuk kapten baru dari layar pemanggilan pemain.';

  @override
  String msgHofTitle(String name) {
    return '$name masuk Hall of Fame';
  }

  @override
  String msgHofBody(String name, int caps, int goals) {
    return '$name bergabung dengan Hall of Fame negara Anda ($caps caps, $goals gol). Lihat di Legenda.';
  }

  @override
  String hubBanTitle(String name) {
    return '$name terkena skorsing';
  }

  @override
  String hubBanBody(String name, String how, int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: '$matches laga berikutnya',
      one: 'laga berikutnya',
    );
    return '$name $how dan terkena skorsing untuk $_temp0. Ia tidak bisa dipilih.';
  }

  @override
  String get hubBanHowSecondYellow => 'diusir wasit karena kartu kuning kedua';

  @override
  String get hubBanHowViolent => 'langsung dikartu merah karena tindakan kasar';

  @override
  String get hubBanHowRed => 'diusir wasit';

  @override
  String hubInjuryTitle(String name) {
    return '$name cedera';
  }

  @override
  String hubInjuryBody(String name, int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: '$matches laga',
    );
    return '$name mengalami cedera dan absen $_temp0.';
  }

  @override
  String get hubRunnerUpTitle1 => 'Runner-up';

  @override
  String get hubRunnerUpTitle2 => 'Begitu dekat, namun gagal';

  @override
  String get hubRunnerUpTitle3 => 'Medali perak';

  @override
  String hubRunnerUpBody1(String cup, String opponent) {
    return 'Anda mencapai final $cup tetapi kalah dari $opponent. Sangat dekat. Perak kali ini.';
  }

  @override
  String hubRunnerUpBody2(String cup, String opponent) {
    return 'Dikalahkan $opponent di final $cup. Runner-up, sangat tipis.';
  }

  @override
  String hubRunnerUpBody3(String cup, String opponent) {
    return 'Final $cup lepas melawan $opponent. Banyak yang patut dibanggakan, tapi bukan trofinya.';
  }

  @override
  String get hubKnockedOutTitle1 => 'Tersingkir';

  @override
  String get hubKnockedOutTitle2 => 'Akhir perjalanan';

  @override
  String get hubKnockedOutTitle3 => 'Perjalanan usai';

  @override
  String hubKnockedOutBody1(String cup, String opponent, String stage) {
    return 'Anda tersingkir dari $cup, dikalahkan $opponent di $stage.';
  }

  @override
  String hubKnockedOutBody2(String cup, String opponent, String stage) {
    return '$opponent mengakhiri $cup Anda di $stage.';
  }

  @override
  String hubKnockedOutBody3(String cup, String opponent, String stage) {
    return '$cup Anda berakhir di $stage, dikalahkan $opponent.';
  }

  @override
  String get hubGroupExitTitle1 => 'Gugur di fase grup';

  @override
  String get hubGroupExitTitle2 => 'Tersingkir di fase grup';

  @override
  String get hubGroupExitTitle3 => 'Pulang cepat';

  @override
  String hubGroupExitBody1(String cup) {
    return '$cup Anda berakhir di fase grup. Belum cukup untuk lolos ke babak gugur.';
  }

  @override
  String hubGroupExitBody2(String cup) {
    return 'Anda gagal lolos dari grup. $cup Anda berakhir di sini.';
  }

  @override
  String hubGroupExitBody3(String cup) {
    return 'Tidak ada tempat di babak gugur kali ini. $cup berakhir bagi Anda di fase grup.';
  }

  @override
  String boardObjectiveMetTitle(String comp) {
    return 'Target tercapai: $comp';
  }

  @override
  String boardObjectiveMissedTitle(String comp) {
    return 'Target gagal: $comp';
  }

  @override
  String boardObjectiveMetBody(String comp, String demand, String finish) {
    return 'Target dewan federasi di $comp: $demand. Hasil Anda: $finish. Mereka mendapatkan apa yang diminta.';
  }

  @override
  String boardObjectiveMissedBody(String comp, String demand, String finish) {
    return 'Target dewan federasi di $comp: $demand. Hasil Anda: $finish. Itu di bawah yang diharapkan.';
  }

  @override
  String get newsWcMissTitle => 'Mimpi Kejuaraan Dunia sirna';

  @override
  String newsWcMissBody(int year) {
    return 'Anda gagal tampil di Kejuaraan Dunia $year. Kampanye kualifikasi berakhir mengecewakan. Empat tahun lagi.';
  }

  @override
  String get newsRecordScorerTitle => 'Pencetak gol terbanyak sepanjang masa';

  @override
  String newsRecordScorerBody(String name, int goals) {
    return '$name kini menjadi pencetak gol terbanyak sepanjang masa di game ini dengan $goals gol.';
  }

  @override
  String get newsRecordCapsTitle => 'Pemain dengan caps terbanyak';

  @override
  String newsRecordCapsBody(String name, int caps) {
    return '$name kini menjadi pemain dengan caps terbanyak di game ini, dengan $caps penampilan.';
  }

  @override
  String get newsARecordBreaker => 'Pemecah rekor baru';

  @override
  String newsTransferTitle(String name, String club) {
    return '$name bergabung dengan $club';
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
    return '$name ($position, $rating) meninggalkan $fromClub dan resmi bergabung dengan $destination seharga $fee.';
  }

  @override
  String newsTransferAbroad(String club, String country) {
    return '$club di $country';
  }

  @override
  String get newsTransferFree => 'Gratis';

  @override
  String newsNatzStarTitle(String name, String nation) {
    return '⭐ $name siap pindah ke $nation!';
  }

  @override
  String newsNatzTitle(String name, String nation) {
    return '$name ingin membela $nation';
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
    return '$name, $position berusia $age tahun dengan rating $rating yang kini membela $fromNation, punya ikatan keluarga dengan $nation dan terbuka untuk pindah. Buka tawaran naturalisasi untuk menerima atau menolak.';
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
    return '$name, $position berusia $age tahun dengan rating $rating yang kini membela $fromNation, adalah nama besar dengan ikatan keluarga ke $nation dan terbuka untuk pindah. Buka tawaran naturalisasi untuk menerima atau menolak.';
  }

  @override
  String get newsTheirNation => 'negara mereka';

  @override
  String get newsYourNation => 'negara Anda';

  @override
  String get tourStatusChampions => 'JUARA';

  @override
  String get tourStatusFinals => 'FINAL';

  @override
  String get tourStatusQualifying => 'KUALIFIKASI';

  @override
  String get tourStatusUpcoming => 'AKAN DATANG';

  @override
  String get tourStatusInProgress => 'BERLANGSUNG';

  @override
  String get tourStatusComingSoon => 'SEGERA HADIR';

  @override
  String get tourStatusDecided => 'SELESAI';

  @override
  String tourStatusLeague(String letter) {
    return 'LIGA $letter';
  }

  @override
  String get tourDrawWcQualifying => 'UNDIAN KUALIFIKASI DUNIA';

  @override
  String tourDrawContQualifying(String cup) {
    return 'UNDIAN KUALIFIKASI $cup';
  }

  @override
  String get tourDrawWcHost => 'TUAN RUMAH KEJUARAAN DUNIA';

  @override
  String tourDrawContHost(String cup) {
    return 'TUAN RUMAH $cup';
  }

  @override
  String get tourDrawHostsReveal => 'Dan tuan rumahnya adalah…';

  @override
  String get tourDrawHostReveal => 'Dan tuan rumahnya adalah…';

  @override
  String get tourDrawHostCandidates => 'Kandidat yang bersaing:';

  @override
  String get tourKickoffContinentalCup => 'KEJUARAAN BENUA';

  @override
  String tourHostCompetitionYear(String competition, int year) {
    return '$competition $year';
  }

  @override
  String newsContMissTitle(String cup) {
    return '$cup terlewat';
  }

  @override
  String newsContMissBody(String cup) {
    return 'Anda gagal lolos ke $cup. Kampanye kali ini berakhir mengecewakan.';
  }

  @override
  String get potyLabelBest => 'Pemain Terbaik Tahun Ini';

  @override
  String get potyLabelYoung => 'Pemain Muda Terbaik Tahun Ini';

  @override
  String potyTallyAssists(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count assist',
    );
    return '$_temp0';
  }

  @override
  String potyOverallValue(int value) {
    return 'Rating $value';
  }

  @override
  String potyRatingValue(String value) {
    return 'Nilai $value';
  }

  @override
  String newsPotyTitle(int year) {
    return 'Pemain Terbaik Dunia $year';
  }

  @override
  String newsPotyBody(String name) {
    return '$name adalah pemain terbaik dunia tahun ini.';
  }

  @override
  String newsPotyYoungSuffix(String name) {
    return ' $name meraih penghargaan pemain muda.';
  }

  @override
  String newsWatchTitle(int year) {
    return 'Para pemain muda pantauan Anda, $year';
  }

  @override
  String newsWatchJump(String name, int rating, int gain) {
    String _temp0 = intl.Intl.pluralLogic(
      gain,
      locale: localeName,
      other: '$gain poin',
    );
    return '$name melesat ke rating $rating, naik $_temp0 dari tahun lalu.';
  }

  @override
  String newsWatchBand(String name, String band) {
    return '$name naik ke kelompok $band.';
  }

  @override
  String newsWatchDebutTitle(String name) {
    return '$name melakukan debut';
  }

  @override
  String newsWatchDebutBody(String name, int age, int rating) {
    return '$name meraih caps pertamanya di usia $age, dengan rating $rating. Salah satu pemain muda pantauan Anda.';
  }

  @override
  String get matchStatsAtFullTime =>
      'Penguasaan bola, rating pemain, dan pemain terbaik laga baru ditentukan saat peluit akhir.';

  @override
  String get matchPlayerRatings => 'RATING PEMAIN';

  @override
  String get matchSubstitutions => 'PERGANTIAN PEMAIN';

  @override
  String get matchSubstitutes => 'PEMAIN CADANGAN';

  @override
  String get matchPlayerOfTheMatch => 'PEMAIN TERBAIK LAGA';

  @override
  String get matchGoalShout => 'GOL!';

  @override
  String matchShootoutScore(int home, int away) {
    return 'ADU PENALTI $home–$away';
  }

  @override
  String matchShootoutKickScored(String name) {
    return '$name: GOL';
  }

  @override
  String matchShootoutKickMissed(String name) {
    return '$name: GAGAL';
  }

  @override
  String get matchFeedKickOff => 'Kick off!';

  @override
  String get matchFeedNoEvents => 'Belum ada kejadian.';

  @override
  String get tourVenues => 'STADION';

  @override
  String tourPot(int number) {
    return 'POT $number';
  }

  @override
  String get tourHostSelection => 'PEMILIHAN TUAN RUMAH';

  @override
  String get tourCandidates => 'KANDIDAT';

  @override
  String get tourJointBid => 'PENCALONAN BERSAMA';

  @override
  String get tourGoldenGlove => 'SARUNG TANGAN EMAS';

  @override
  String get tourTeamOfTournament => 'TIM TERBAIK TURNAMEN';

  @override
  String get tourYourRun => 'PERJALANAN ANDA';

  @override
  String get tourMedalTable => 'KLASEMEN MEDALI';

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
    return 'Grup $name';
  }

  @override
  String get tourFinalsDrawBlurb =>
      'Diunggulkan menurut peringkat dunia. Temukan negara Anda sebelum undian.';

  @override
  String get tourWorldRanking => 'Peringkat Dunia';

  @override
  String get tourYourCompetitions => 'KOMPETISI ANDA';

  @override
  String get tourOtherContinents => 'BENUA LAIN';

  @override
  String get tourZoneGlobal => 'DUNIA';

  @override
  String get tourZoneEurope => 'EROPA';

  @override
  String get tourZoneSouthAmerica => 'AM. SELATAN';

  @override
  String get tourZoneNorthAmerica => 'AM. UTARA';

  @override
  String get tourZoneAfrica => 'AFRIKA';

  @override
  String get tourZoneAsia => 'ASIA';

  @override
  String get tourZoneOceania => 'OSEANIA';

  @override
  String get tourZoneIntercontinental => 'ANTARBENUA';

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
    return '$count teratas lolos ke $destination';
  }

  @override
  String newsWalkoutTitle(String name) {
    return '$name mundur';
  }

  @override
  String newsWalkoutBody(String name, int age, int caps) {
    return '$name pensiun dari sepak bola internasional di usia $age, dengan $caps caps. Dia meminta kejelasan posisinya dan tidak mendapatkannya, dan dia tidak mau menunggu lebih lama lagi.';
  }

  @override
  String get pressHeadlineWent1 => 'Pelatih yang menguasai ruangan';

  @override
  String get pressHeadlineWent2 =>
      'Mereka datang untuk berdebat, tapi pulang bertemu seorang pemimpin';

  @override
  String get pressHeadlineWent3 => 'Jawaban lugas, dan tepat sasaran';

  @override
  String get pressHeadlineMixed1 => 'Banyak bicara, sedikit yang tuntas';

  @override
  String get pressHeadlineMixed2 =>
      'Ada untuk semua orang, tapi tak ada artinya bagi siapa pun';

  @override
  String get pressHeadlineMixed3 =>
      'Konferensi yang meninggalkan pertanyaan terbuka';

  @override
  String get pressHeadlineBadly1 => 'Sore yang berat di depan kamera';

  @override
  String get pressHeadlineBadly2 => 'Ruangan berbalik, dan terasa jelas';

  @override
  String get pressHeadlineBadly3 =>
      'Jawaban yang akan terdengar lebih buruk esok pagi';

  @override
  String get pressHeadlineFlat1 =>
      'Tak ada yang dikatakan, tak ada yang didapat';

  @override
  String get pressHeadlineFlat2 => 'Sepuluh menit, tanpa berita';

  @override
  String get pressHeadlineFlat3 => 'Halaman kosong untuk halaman belakang';

  @override
  String get pressConferenceTitle => 'KONFERENSI PERS';

  @override
  String pressQuestionOf(int index, int total) {
    return 'Pertanyaan $index dari $total';
  }

  @override
  String get pressTomorrowsHeadline => 'HALAMAN BELAKANG ESOK HARI';

  @override
  String get pressLeaveRoom => 'TINGGALKAN RUANGAN';

  @override
  String get pressRoomVerdictSquad => 'Ruang ganti';

  @override
  String get pressRoomVerdictBoard => 'Dewan';

  @override
  String get yReactionElation0 => 'tanpa catatan. nol. sempurna.';

  @override
  String get yReactionElation1 => 'Aku tak waras (dalam arti baik).';

  @override
  String get yReactionElation2 => 'dibingkai. dipajang di atas perapian.';

  @override
  String get yReactionElation3 => 'kita kembali';

  @override
  String get yReactionElation4 => 'Screenshot buat para peragu. Semuanya.';

  @override
  String get yReactionElation5 =>
      'Aku bakal menyebalkan soal ini selama sepuluh tahun.';

  @override
  String get yReactionElation6 => 'Nah. Inilah alasan kita menonton.';

  @override
  String get yReactionElation7 =>
      'Hari seperti ini membayar hari-hari yang lain.';

  @override
  String get yReactionElation8 => 'Akhirnya. Sungguh, akhirnya.';

  @override
  String get yReactionElation9 =>
      'Bagus. Sekarang ulangi lagi minggu depan, baru aku percaya.';

  @override
  String get yReactionElation10 =>
      'Nikmati malam ini, karena tim ini pasti menemukan cara merusaknya.';

  @override
  String get yReactionElation11 =>
      'Satu malam bagus tak menjadikan siapa pun tim hebat.';

  @override
  String get yReactionRelief0 => 'Tidak cantik, tapi selalu kuterima.';

  @override
  String get yReactionRelief1 => 'Entah bagaimana. Entah bagaimana!';

  @override
  String get yReactionRelief2 => 'Jelek. Tiga poin. Lanjut.';

  @override
  String get yReactionRelief3 => 'Jelek pun kuterima asal dapat poin.';

  @override
  String get yReactionRelief4 => 'umurku berkurang sepuluh tahun';

  @override
  String get yReactionRelief5 =>
      'Jangan ada yang bicara. Jangan ada yang menjinxkan.';

  @override
  String get yReactionRelief6 => 'Detak jantung: tidak bisa diterima.';

  @override
  String get yReactionRelief7 => 'Lolos.';

  @override
  String get yReactionRelief8 =>
      'Kita tak seharusnya butuh kelegaan dari laga seperti itu.';

  @override
  String get yReactionRelief9 => 'Lega, dan agak malu karena merasa lega.';

  @override
  String get yReactionRelief10 =>
      'Kalau itu standar yang kita sorakkan, kita dalam masalah.';

  @override
  String get yReactionRelief11 =>
      'Lolos tipis sudah jadi kebiasaan, dan bukan kebiasaan yang baik.';

  @override
  String get yReactionFury0 => 'Tidak cukup baik. Sama sekali tidak.';

  @override
  String get yReactionFury1 => 'Tolong jelaskan itu pelan-pelan.';

  @override
  String get yReactionFury2 =>
      'Itu tontonan yang berat, dan aku sudah bicara sopan.';

  @override
  String get yReactionFury3 => 'Kecewa. Sungguh kecewa.';

  @override
  String get yReactionFury4 => 'Keadaan yang memalukan.';

  @override
  String get yReactionFury5 => 'Aku mau nama-nama.';

  @override
  String get yReactionFury6 => 'Hapus aplikasi. Pasang lagi hari Kamis.';

  @override
  String get yReactionFury7 =>
      'Tak ada yang tampak menginginkannya di lapangan.';

  @override
  String get yReactionFury8 =>
      'Empat tahun sekali, begini lagi. SETIAP empat tahun.';

  @override
  String get yReactionFury9 => 'Itu bukan penampilan, itu penghinaan.';

  @override
  String get yReactionFury10 =>
      'Orang mengorbankan akhir pekan dan uang untuk itu. Pikirkan.';

  @override
  String get yReactionFury11 =>
      'Bertahun-tahun aku membela tim ini. Tidak malam ini. Tidak setelah itu.';

  @override
  String get yReactionDespair0 => 'ya sudahlah.';

  @override
  String get yReactionDespair1 => 'Hari ini tak ada candaan. Tak ada.';

  @override
  String get yReactionDespair2 => 'Jalan-jalan dulu. Yang lama.';

  @override
  String get yReactionDespair3 => 'Aku kehabisan cara untuk mengatakannya.';

  @override
  String get yReactionDespair4 => 'Bangunkan aku empat tahun lagi.';

  @override
  String get yReactionDespair5 => 'ini garis waktu terkelam';

  @override
  String get yReactionDespair6 =>
      'Marah pun sudah tidak. Itu yang mengkhawatirkan.';

  @override
  String get yReactionDespair7 =>
      'Yang itu akan terasa perih untuk waktu yang lama.';

  @override
  String get yReactionDespair8 =>
      'Aku tak tahu lagi ini apa, tapi ini bukan tim sepak bola.';

  @override
  String get yReactionDespair9 =>
      'Kita makin jauh dari sebelumnya, dan tak ada yang mau mengatakannya.';

  @override
  String get yReactionDespair10 =>
      'Satu generasi terbuang dan orang yang sama yang menentukan langkah berikutnya.';

  @override
  String get yReactionDespair11 =>
      'Berhenti bilang ini proses. Ini tak menuju ke mana-mana.';

  @override
  String get yReactionSmugness0 => 'Pelan-pelan saja, tapi: sudah kubilang.';

  @override
  String get yReactionSmugness1 => 'simpan yang satu ini';

  @override
  String get yReactionSmugness2 => 'Para peragu mendadak sangat sepi.';

  @override
  String get yReactionSmugness3 =>
      'Bukan berarti ada yang menghitung. Aku menghitung.';

  @override
  String get yReactionSmugness4 =>
      'Sudah kubilang bulan Januari. Cek linimasa.';

  @override
  String get yReactionSmugness5 =>
      'Sebagian dari kalian berutang permintaan maaf pada sebagian dari kami.';

  @override
  String get yReactionSmugness6 =>
      'Kumasukkan ke daftar hal yang kusebut lebih dulu.';

  @override
  String get yReactionSmugness7 => 'Tanpa menyombong. Sedikit menyombong.';

  @override
  String get yReactionSmugness8 =>
      'Di mana para pakar sekarang? Pertanyaan serius.';

  @override
  String get yReactionSmugness9 =>
      'Aku mau kalian semua mengucapkannya balik padaku.';

  @override
  String get yReactionSmugness10 =>
      'Screenshot, dicetak, dibingkai, dikirim ke orang-orang yang menertawakan.';

  @override
  String get yReactionSmugness11 =>
      'Ini akan kuungkit seumur hidupku dan kalian pantas mendengarnya.';

  @override
  String get yReactionShrug0 => 'sudah terjadi. lanjut.';

  @override
  String get yReactionShrug1 => 'Ya sudah. Terserah. Maju terus.';

  @override
  String get yReactionShrug2 => 'Kumasukkan ke folder \'sepak bola\'.';

  @override
  String get yReactionShrug3 => 'Sungguh tak ada yang bisa ditambahkan.';

  @override
  String get yReactionShrug4 => 'tak ada pikiran, kepala kosong';

  @override
  String get yReactionShrug5 => 'Bangunkan aku untuk laga berikutnya.';

  @override
  String get yReactionShrug6 => 'Sembilan puluh menit yang tak akan kembali.';

  @override
  String get yReactionShrug7 => 'Biasa saja, sebenarnya.';

  @override
  String get yReactionShrug8 => 'Tak bisa bilang satu pun hal yang terjadi.';

  @override
  String get yReactionShrug9 =>
      'Satu lagi laga seperti itu. Banyak sekali yang begini.';

  @override
  String get yReactionShrug10 => 'Kutonton semuanya dan tak merasakan apa-apa.';

  @override
  String get yReactionShrug11 =>
      'Kalau tak ada yang menyebut ini lagi, aku tak keberatan.';

  @override
  String get tourThirdsUneven =>
      'Grup tidak sama besar, jadi hasil melawan tim juru kunci di grup yang lebih besar dibuang agar setiap tim dinilai dari jumlah laga yang sama.';

  @override
  String get careerExportSave => 'Cadangkan simpanan ini';

  @override
  String get careerBackupAll => 'CADANGKAN SEMUA SIMPANAN';

  @override
  String get careerBackupAllFailed => 'Gagal menulis cadangan.';

  @override
  String get backupTitle => 'SIMPANAN';

  @override
  String get backupBlurb =>
      'Semua simpanan berada dalam satu berkas di ponsel ini, dan tidak ada yang mencadangkannya otomatis. Ekspor salinan dan simpan di luar ponsel, di Files atau iCloud Drive, agar ponsel hilang atau aplikasi terhapus tidak merenggut karier Anda.';

  @override
  String get backupExport => 'EKSPOR CADANGAN';

  @override
  String get backupExportSubject => 'Simpanan FNM';

  @override
  String get backupRestore => 'PULIHKAN DARI BERKAS';

  @override
  String get backupRestoreWarnTitle => 'Ganti semua simpanan?';

  @override
  String get backupRestoreWarnBody =>
      'Pemulihan mengganti semua simpanan di ponsel ini dengan yang ada di berkas. Aplikasi akan dimulai ulang.';

  @override
  String get backupRestoreConfirm => 'GANTI';

  @override
  String get backupCancel => 'BATAL';

  @override
  String get backupExported => 'Cadangan siap. Pilih tempat menyimpannya.';

  @override
  String get backupFailed => 'Gagal menulis cadangan.';

  @override
  String get backupRejectedUnreadable => 'Berkas itu tidak dapat dibuka.';

  @override
  String get backupRejectedNotFnm => 'Itu bukan simpanan FNM.';

  @override
  String get backupRejectedNewer =>
      'Simpanan itu dibuat oleh aplikasi versi lebih baru. Perbarui dulu.';

  @override
  String get backupRejectedTooOld =>
      'Simpanan itu terlalu lama untuk dipulihkan oleh versi ini.';

  @override
  String get careerShare => 'Bagikan karier ini';

  @override
  String get careerImport => 'IMPOR KARIER';

  @override
  String get careerShareSubject => 'Karier FNM';

  @override
  String get careerImported => 'Karier diimpor.';

  @override
  String get careerImportFailedUnreadable => 'Berkas itu bukan karier FNM.';

  @override
  String get careerImportFailedNewer =>
      'Karier itu diekspor oleh aplikasi versi lebih baru. Perbarui dulu.';

  @override
  String get careerImportFailedSlotsFull =>
      'Semua slot simpanan Anda terpakai. Hapus satu simpanan untuk memberi ruang, atau buka akses simpanan tanpa batas.';

  @override
  String get careerImportFailedNeedsPremium =>
      'Karier itu sudah melewati siklus pertama yang gratis. Buka akses game penuh untuk memasukkannya.';

  @override
  String get careerImportFailedCampaignRun =>
      'Kampanye itu sudah punya perjalanan yang sedang berjalan. Lanjutkan atau tinggalkan dulu.';

  @override
  String get careerShareFailed => 'Gagal mengekspor karier itu.';

  @override
  String get managerRename => 'Ubah nama';

  @override
  String get managerRenameSave => 'Simpan';

  @override
  String get managerTitle => 'PELATIH';

  @override
  String get managerSkills => 'KEAHLIAN ANDA';

  @override
  String managerPointsAvailable(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count poin untuk dibelanjakan',
      zero: 'Tidak ada poin untuk dibelanjakan',
    );
    return '$_temp0';
  }

  @override
  String get managerPointsHow =>
      'Dua poin untuk setiap siklus yang Anda selesaikan, satu poin untuk setiap trofi yang Anda menangkan.';

  @override
  String get managerSkillsScale =>
      'Setiap keahlian dimulai dari 5 dan berhenti di 20. Poin yang dipakai bersifat permanen.';

  @override
  String get managerSkillManManagement => 'Manajemen Pemain';

  @override
  String get managerSkillManManagementBlurb =>
      'Setiap poin membuat ucapan Anda kepada pers dan pemain 3% lebih berpengaruh di ruang ganti.';

  @override
  String get managerSkillTactical => 'Taktik';

  @override
  String get managerSkillTacticalBlurb =>
      'Setiap poin membuat formasi baru menyatu 3% lebih cepat, sehingga mengganti pola memakan lebih sedikit laga.';

  @override
  String get managerSkillYouth => 'Pembinaan Pemain Muda';

  @override
  String get managerSkillYouthBlurb =>
      'Setiap poin menambah 1% bakat yang keluar dari akademi Anda, di luar dana yang Anda berikan.';

  @override
  String get managerSkillNegotiation => 'Negosiasi';

  @override
  String get managerSkillNegotiationBlurb =>
      'Setiap poin berarti 2% lebih banyak dana dari federasi, setiap siklus.';

  @override
  String get managerStaff => 'STAF ANDA';

  @override
  String managerStaffWages(String amount) {
    return 'Gaji: $amount per siklus';
  }

  @override
  String get managerRoleAssistant => 'Asisten Pelatih';

  @override
  String get managerRoleAssistantBlurb =>
      'Memimpin latihan: cedera lebih sedikit, dan pemain muda yang lebih baik.';

  @override
  String get managerRoleScout => 'Kepala Pemandu Bakat';

  @override
  String get managerRoleScoutBlurb =>
      'Membaca calon pemain dan lawan berikutnya: rating bintang lebih akurat, dan keunggulan di hari laga.';

  @override
  String get managerRoleFitness => 'Pelatih Kebugaran';

  @override
  String get managerRoleFitnessBlurb => 'Menjaga mereka tetap di lapangan.';

  @override
  String staffEffectInjury(int percent) {
    return '$percent% lebih sedikit cedera';
  }

  @override
  String staffEffectYouth(int points) {
    return 'Pemain muda +$points rating keseluruhan';
  }

  @override
  String staffHiringInjury(int min, int max) {
    return 'Jika merekrut: $min% sampai $max% lebih sedikit cedera';
  }

  @override
  String staffHiringYouth(int minPoints, int maxPoints) {
    return 'dan pemain muda +$minPoints sampai +$maxPoints rating keseluruhan';
  }

  @override
  String staffEffectScoutRead(int percent) {
    return 'Membaca $percent% calon pemain dengan tepat';
  }

  @override
  String staffEffectScoutCaps(int caps) {
    String _temp0 = intl.Intl.pluralLogic(
      caps,
      locale: localeName,
      other: 'Potensi diketahui setelah $caps caps',
    );
    return '$_temp0';
  }

  @override
  String staffEffectScoutDossier(int points) {
    return '+$points rating dari dosir lawan';
  }

  @override
  String staffHiringScoutRead(int min, int max) {
    return 'Jika merekrut: $min% sampai $max% bacaan tepat';
  }

  @override
  String staffHiringScoutCaps(int minCaps, int maxCaps) {
    return 'dan potensi diketahui $minCaps sampai $maxCaps caps lebih awal';
  }

  @override
  String staffHiringScoutDossier(int minPoints, int maxPoints) {
    return 'dan +$minPoints sampai +$maxPoints rating setiap laga';
  }

  @override
  String get staffEffectNone => 'Belum berpengaruh pada skuad Anda';

  @override
  String get staffVacant => 'Belum ada orangnya';

  @override
  String get staffLeaveVacant => 'Biarkan posisi kosong';

  @override
  String get managerTierNone => 'Tidak ada';

  @override
  String get managerTierBasic => 'Dasar';

  @override
  String get managerTierGood => 'Baik';

  @override
  String get managerTierElite => 'Elite';

  @override
  String get managerFree => 'gratis';

  @override
  String get managerTraining => 'ANTAR PEKAN LAGA';

  @override
  String get managerTrainingBlurb =>
      'Apa yang dilatih skuad saat tidak ada laga.';

  @override
  String get managerFocusBalanced => 'Seimbang';

  @override
  String get managerFocusBalancedBlurb => 'Sedikit dari segalanya.';

  @override
  String get managerFocusFitness => 'Kebugaran';

  @override
  String get managerFocusFitnessBlurb => 'Lebih sedikit benturan.';

  @override
  String get managerFocusCohesion => 'Kekompakan';

  @override
  String get managerFocusCohesionBlurb => 'Pola menyatu lebih cepat.';

  @override
  String get managerFocusYouth => 'Pemain muda';

  @override
  String get managerFocusYouthBlurb =>
      'Waktu lebih banyak untuk yang termuda di kolam pemain.';

  @override
  String get tourOfferTitle => 'Pertama kali di sini?';

  @override
  String get tourOfferBody =>
      'Ini game yang besar. Mau tur singkat ke layar yang penting? Hanya semenit, dan Anda bisa mengulanginya kapan saja dari Pengaturan.';

  @override
  String get tourOfferYes => 'Tunjukkan';

  @override
  String get tourOfferNo => 'Tidak, terima kasih';

  @override
  String get tourBack => 'Kembali';

  @override
  String get tourNext => 'Lanjut';

  @override
  String get tourDone => 'Selesai';

  @override
  String get tourSkip => 'Lewati';

  @override
  String get tourHubTitle => 'Inilah seluruh game';

  @override
  String get tourHubBody =>
      'Satu tombol, dan berubah mengikuti jalannya siklus: undian untuk ditonton, skuad untuk ditunjuk, laga untuk dimainkan. Di atasnya ada kepercayaan dewan kepada Anda dan target yang mereka tetapkan.';

  @override
  String get tourBudgetTitle => 'Uang federasi';

  @override
  String get tourBudgetBody =>
      'Setiap siklus empat tahun, Anda membagi dana besar itu ke departemen. Staf Anda dibayar lebih dulu dari sana, jadi merekrut pemandu bakat elite berarti mengorbankan akademi, bukan sekadar menambahnya.';

  @override
  String get tourTacticsTitle => 'Cara tim bermain';

  @override
  String get tourTacticsBody =>
      'Formasi, gaya bermain, kapten, dan siapa yang mengeksekusi bola mati. Biarkan dua yang terakhir kosong dan game akan memperingatkan Anda sebelum kick off, bukan diam-diam memilihkan untuk Anda.';

  @override
  String get tourSquadTitle => 'Semua yang bisa Anda pilih';

  @override
  String get tourSquadBody =>
      'Seluruh kolam pemain, bukan hanya skuad: siapa yang sedang bagus, siapa yang cedera, siapa yang terkena skorsing, dan siapa yang baru naik dari akademi.';

  @override
  String get tourCallUpsTitle => 'Menunjuk skuad';

  @override
  String get tourCallUpsBody =>
      'Anda menunjuk satu skuad per periode internasional dan skuad itu memainkan setiap laga dalam periode tersebut, persis seperti pelatih sungguhan. Jika ada cedera di dalam periode itu, pengganti akan dipanggil untuk Anda.';

  @override
  String get tourRecordsTitle => 'Karier Anda';

  @override
  String get tourRecordsBody =>
      'Semua yang pernah Anda capai: laga, rekor tim, trofi, dan setiap negara yang pernah Anda latih.';

  @override
  String get tourCupsTitle => 'Dunia di luar sana';

  @override
  String get tourCupsBody =>
      'Setiap kompetisi yang sedang berjalan: grup, klasemen, dan babak gugur, termasuk yang tidak Anda ikuti. Dunia terus bermain, apakah Anda lolos atau tidak.';

  @override
  String get settingsTourTitle => 'Ulangi tutorial';

  @override
  String get settingsTourBlurb => 'Telusuri lagi layar-layar utama dari awal.';

  @override
  String get tourBoardTitle => 'Kepada siapa Anda bertanggung jawab';

  @override
  String get tourBoardBody =>
      'Kepercayaan dewan kepada Anda, dan target yang mereka tetapkan untuk siklus ini. Gagal memenuhi target dan di sinilah Anda akan melihatnya datang.';

  @override
  String get tourStaffTitle => 'Orang-orang di sekitar Anda';

  @override
  String get tourStaffBody =>
      'Seorang asisten, pemandu bakat, dan pelatih kebugaran, direkrut satu per satu. Gaji mereka diambil dari anggaran ini sebelum departemen, jadi pemandu bakat hebat berarti mengorbankan akademi.';

  @override
  String get tourPlaystyleTitle => 'Cara Anda bermain';

  @override
  String get tourPlaystyleBody =>
      'Formasi hanyalah separuh taktik. Ini separuh lainnya: seberapa tinggi Anda menekan, seberapa langsung permainan Anda, seberapa besar risikonya.';

  @override
  String get settingsTourNoSave =>
      'Mulai karier dulu. Tur ini mengunjungi layar milik Anda sendiri.';

  @override
  String tacticsOutOfPositionAge(int age) {
    return 'Di luar posisi · Usia $age';
  }

  @override
  String get federationNextCycleLocked =>
      'Anggaran siklus berikutnya ditetapkan di awal siklus itu, sekaligus. Sampai saat itu, inilah yang dilakukan uang Anda.';

  @override
  String get federationBudgetAlreadySet => 'Sudah ditetapkan untuk siklus ini';

  @override
  String yFinalLooms0(String opponent) {
    return 'Lawannya $opponent untuk laga besar. Seminggu penuh, hanya ini yang akan dibicarakan semua orang.';
  }

  @override
  String yFinalLooms1(String opponent) {
    return 'Pasti: $opponent menghadang kita. Empat tahun untuk ini.';
  }

  @override
  String yFinalLooms2(String opponent) {
    return 'Oke. $opponent. Tak ada yang tidur sampai ini selesai.';
  }

  @override
  String yFinalLooms3(String opponent) {
    return '$opponent berikutnya, dan yang lain bisa menunggu. Minggu yang luar biasa.';
  }

  @override
  String get matchSetupLeaveToCoach => 'Serahkan eksekutor kepada asisten';

  @override
  String friendliesLikeYourGroup(String rivals) {
    return 'Ditandai di bawah: tim yang bermain seperti $rivals, lawan yang Anda hadapi di grup siklus ini.';
  }

  @override
  String newsTransferWindowTitle(int year) {
    return 'Bursa transfer · $year';
  }

  @override
  String careerLastAgo(String when) {
    return 'Terakhir $when lalu';
  }

  @override
  String get settingsFreeScopeTitle => 'Satu siklus empat tahun gratis';

  @override
  String get settingsFreeScopeBlurb =>
      'Satu siklus lengkap (kualifikasi, kejuaraan benua Anda, dan Kejuaraan Dunia) dengan dua simpanan, setiap negara di dunia, tanpa ada yang ditahan. Siklus tanpa akhir dan simpanan tanpa batas cukup dengan sekali bayar, dan berlaku untuk semua pembaruan mendatang.';

  @override
  String get settingsUnlockedTitle => 'Terbuka';

  @override
  String get settingsUnlockedBlurb =>
      'Siklus tanpa akhir, simpanan tanpa batas, dan semua pembaruan mendatang. Terima kasih.';

  @override
  String get settingsFromDeveloperTitle => 'Dari pengembang';

  @override
  String get settingsFromDeveloperBlurb =>
      'Football Nations Manager dibuat oleh satu orang dan akan didukung dalam jangka panjang. Tidak akan pernah ada iklan atau transaksi mikro. Jika Anda menikmati game ini, pertimbangkan untuk membeli versi penuh. Itulah yang menjaga pembaruan terus datang.';

  @override
  String get settingsFromDeveloperThanksBlurb =>
      'Football Nations Manager dibuat oleh satu orang dan akan didukung dalam jangka panjang. Tidak akan pernah ada iklan atau transaksi mikro. Terima kasih telah membeli versi penuh. Itulah yang menjaga pembaruan terus datang.';

  @override
  String friendliesLikeYourCampaign(String rivals) {
    return 'Ditandai di bawah: tim yang bermain seperti $rivals, lawan yang masih harus Anda hadapi.';
  }

  @override
  String get friendliesCloseToYou =>
      'Ditandai di bawah: tim terdekat dengan Anda di peringkat dunia. Setelah undian, tanda mengikuti grup Anda.';

  @override
  String transfersMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count perpindahan',
    );
    return '$_temp0';
  }

  @override
  String hubRoundPage(int page, int pages) {
    return '$page / $pages';
  }

  @override
  String get transfersNewer => 'Terbaru';

  @override
  String get transfersOlder => 'Lainnya';

  @override
  String get transfersPagePrevious => 'Sebelumnya';

  @override
  String get transfersPageNext => 'Berikutnya';

  @override
  String transfersPageOf(int page, int pages) {
    return 'Halaman $page dari $pages';
  }

  @override
  String get transfersMovedTo => 'Pindah ke';

  @override
  String get transfersUnknownClub => 'Klub tidak diketahui';

  @override
  String yAgainstThemAgain0(String opponent, String count) {
    return 'Sudah $count kali melawan $opponent. Ada yang mencatat skor, dan itu mereka.';
  }

  @override
  String yAgainstThemAgain1(String opponent, String count) {
    return '$opponent lagi. $count pertemuan, dan kita masih belum bisa membacanya.';
  }

  @override
  String yAgainstThemAgain2(String opponent, String count) {
    return 'Yang ke-$count melawan $opponent. Ini bukan kebetulan lagi.';
  }

  @override
  String yAgainstThemAgain3(String opponent, String count) {
    return 'Kita sudah main melawan $opponent $count kali dan tak belajar apa pun dari semuanya.';
  }

  @override
  String yAgainstThemAgain4(String opponent, String count) {
    return '$opponent, $count kali. Mereka tahu persis apa yang akan kita lakukan.';
  }

  @override
  String yAgainstThemAgain5(String opponent, String count) {
    return 'Apa pun yang dimiliki $opponent atas kita, setelah $count pertemuan, mereka masih memilikinya.';
  }

  @override
  String ySameOldStory0(String count) {
    return 'Sudah $count kali ini terjadi belakangan. Kapan ini disebut jati diri kita?';
  }

  @override
  String ySameOldStory1(String count) {
    return '$count sore seperti ini sekarang. Ini pola, bukan kebetulan.';
  }

  @override
  String ySameOldStory2(String count) {
    return 'Kita melihat laga yang persis sama $count kali belakangan ini. Naskah sama, akhir sama.';
  }

  @override
  String ySameOldStory3(String count) {
    return '$count versi dari sembilan puluh menit yang sama. Tak ada yang membenahi.';
  }

  @override
  String ySameOldStory4(String count) {
    return '$count kali. Kalau belum melihat polanya, berarti tidak mau melihat.';
  }

  @override
  String ySameOldStory5(String count) {
    return 'Cerita sama, $count kali. Alasan habis sebelum hasilnya membaik.';
  }

  @override
  String get yToldYouSo0 =>
      'Sudah kubilang ini akan datang saat semua orang sibuk merayakan.';

  @override
  String get yToldYouSo1 =>
      'Dua minggu bagus dan kita jadi generasi emas lagi. Dan lihat sekarang.';

  @override
  String get yToldYouSo2 =>
      'Orang-orang yang menyuruhku menikmati bulan lalu kini diam.';

  @override
  String get yToldYouSo3 => 'Aku tak senang soal ini. Sedikit senang. Agak.';

  @override
  String get yToldYouSo4 =>
      'Tak pernah sebagus yang dikatakan mereka, dan ini buktinya.';

  @override
  String get yToldYouSo5 =>
      'Setiap kali. Katanya kali ini beda, dan setiap kali tidak.';

  @override
  String get tacticsSubOffAlready => 'Sudah ditarik';

  @override
  String get tacticsSubInjured => 'Cedera';

  @override
  String get tacticsSubSentOffMark => 'Diusir wasit';

  @override
  String get tacticsSubNoneLeft => 'Jatah ganti habis';

  @override
  String get tacticsUndoLastChange => 'Batalkan perubahan terakhir';

  @override
  String get matchStrengthTitle => 'YANG MENGGERAKKAN TIM';

  @override
  String get strengthFactorFamiliarity => 'Pola terlatih';

  @override
  String get strengthFactorFatigue => 'Kaki lelah';

  @override
  String get strengthFactorClubForm => 'Performa klub';

  @override
  String get strengthFactorMorale => 'Ruang ganti';

  @override
  String get strengthFactorCaptain => 'Kapten';

  @override
  String get strengthFactorStaff => 'Ruang staf';

  @override
  String get strengthFactorDossier => 'Dosir pemandu bakat';

  @override
  String yDebut0(String name) {
    return '$name meraih caps pertama. Ingat namanya.';
  }

  @override
  String yDebut1(String name) {
    return 'Debut untuk $name. Terlihat dari dirinya, kan?';
  }

  @override
  String yDebut2(String name) {
    return '$name, caps pertama. Mari lihat apa yang dia lakukan.';
  }

  @override
  String yDebut3(String name) {
    return 'Debut untuk $name. Skuad memang butuh kaki segar di suatu tempat.';
  }

  @override
  String yDebut4(String name) {
    return '$name diberi caps. Kita sudah banyak membagikannya belakangan ini.';
  }

  @override
  String yDebut5(String name) {
    return 'Debut untuk $name. Satu lagi yang akan kita lupakan saat musim semi.';
  }

  @override
  String yDrought0(String name, String count) {
    return '$name sudah $count tanpa mencetak gol dan mengerjakan semua hal lain di lapangan.';
  }

  @override
  String yDrought1(String name, String count) {
    return '$count laga tanpa gol untuk $name. Selalu datang bertiga, dari dulu.';
  }

  @override
  String yDrought2(String name, String count) {
    return '$name: $count laga, tanpa gol.';
  }

  @override
  String yDrought3(String name, String count) {
    return '$count tanpa gol untuk $name. Layak diawasi.';
  }

  @override
  String yDrought4(String name, String count) {
    return '$count laga. Tanpa gol. $name menembak gajah pun meleset.';
  }

  @override
  String yDrought5(String name, String count) {
    return '$name belum mencetak gol dalam $count. Mainkan siapa pun selain dia.';
  }

  @override
  String yRivalryLooms0(String opponent, String count) {
    return '$opponent berikutnya. $count pertemuan dan tetap berarti segalanya.';
  }

  @override
  String yRivalryLooms1(String opponent, String count) {
    return '$count kali melawan $opponent sekarang. Ayo maju.';
  }

  @override
  String yRivalryLooms2(String opponent, String count) {
    return '$opponent berikutnya. Sudah main $count kali.';
  }

  @override
  String yRivalryLooms3(String opponent, String count) {
    return 'Pertemuan ke-$count dengan $opponent minggu ini.';
  }

  @override
  String yRivalryLooms4(String opponent, String count) {
    return '$opponent lagi. $count kali begini dan kita tak belajar apa pun.';
  }

  @override
  String yRivalryLooms5(String opponent, String count) {
    return '$count laga melawan $opponent dan mereka masih mengalahkan kita. Luar biasa.';
  }

  @override
  String get positionGoalkeeper => 'Kiper';

  @override
  String get positionLeftBack => 'Bek Kiri';

  @override
  String get positionCentreBack => 'Bek Tengah';

  @override
  String get positionRightBack => 'Bek Kanan';

  @override
  String get positionDefensiveMid => 'Gelandang Bertahan';

  @override
  String get positionCentralMid => 'Gelandang Tengah';

  @override
  String get positionAttackingMid => 'Gelandang Serang';

  @override
  String get positionLeftMid => 'Gelandang Kiri';

  @override
  String get positionRightMid => 'Gelandang Kanan';

  @override
  String get positionLeftWing => 'Sayap Kiri';

  @override
  String get positionRightWing => 'Sayap Kanan';

  @override
  String get positionStriker => 'Penyerang';

  @override
  String get roleNone => 'Tanpa peran';

  @override
  String get roleTargetMan => 'Target man';

  @override
  String get rolePoacher => 'Poacher';

  @override
  String get rolePlaymaker => 'Playmaker';

  @override
  String get roleBallWinner => 'Perebut bola';

  @override
  String get roleInvertedWinger => 'Sayap terbalik';

  @override
  String get roleBallPlayingDefender => 'Bek pengumpan';

  @override
  String get roleNoneBlurb => 'Bermain dengan gaya alaminya.';

  @override
  String get roleTargetManBlurb =>
      'Menang duel udara, membagi bola. Assist dan bola mati.';

  @override
  String get rolePoacherBlurb =>
      'Mengintai di kotak penalti. Jauh lebih banyak gol.';

  @override
  String get rolePlaymakerBlurb =>
      'Menciptakan peluang. Jauh lebih banyak assist.';

  @override
  String get roleBallWinnerBlurb => 'Memutus serangan, bukan menuntaskannya.';

  @override
  String get roleInvertedWingerBlurb =>
      'Memotong ke dalam untuk menembak. Lebih banyak gol.';

  @override
  String get roleBallPlayingDefenderBlurb => 'Memulai serangan dari belakang.';

  @override
  String get federationDeptYouth => 'Akademi Muda';

  @override
  String get federationDeptCommercial => 'Komersial / Humas';

  @override
  String get federationDeptMedical => 'Medis & Ilmu Olahraga';

  @override
  String get federationDeptNaturalisation => 'Kantor Naturalisasi';

  @override
  String get federationDeptBoardRelations => 'Hubungan dengan Dewan';

  @override
  String get federationDeptYouthBlurb =>
      'Lulusan akademi yang lebih baik berdebut untuk negara Anda di siklus berikutnya.';

  @override
  String get federationDeptCommercialBlurb =>
      'Sponsor membawa pemasukan tambahan di akhir siklus.';

  @override
  String get federationDeptMedicalBlurb =>
      'Cedera lebih sedikit. Skuad Anda tetap tersedia sepanjang siklus.';

  @override
  String get federationDeptNaturalisationBlurb =>
      'Lebih banyak pemain asing menawarkan diri pindah ke negara Anda.';

  @override
  String get federationDeptBoardRelationsBlurb =>
      'Dewan menilai hasil Anda dengan lebih sabar.';

  @override
  String get federationBuildingAcademy => 'Akademi';

  @override
  String get federationBuildingCommercial => 'Kantor Pusat Komersial';

  @override
  String get federationBuildingMedical => 'Pusat Medis';

  @override
  String get federationBuildingScouting => 'Kantor Pemandu Bakat';

  @override
  String get federationBuildingBoardroom => 'Ruang Rapat';

  @override
  String get moraleBuoyant => 'Membara';

  @override
  String get moralePositive => 'Positif';

  @override
  String get moraleSettled => 'Stabil';

  @override
  String get moraleUneasy => 'Gelisah';

  @override
  String get moraleRockBottom => 'Terpuruk';

  @override
  String get matchTabTimeline => 'LINIMASA';

  @override
  String get matchTabStats => 'STATISTIK';

  @override
  String get matchTabLineups => 'SUSUNAN';

  @override
  String get matchPenalty => 'PENALTI';

  @override
  String get matchStateLevel => 'Skor masih imbang';

  @override
  String matchStateLead(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Anda unggul $count gol',
    );
    return '$_temp0';
  }

  @override
  String matchStateTrail(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Anda tertinggal $count gol',
    );
    return '$_temp0';
  }

  @override
  String matchPossessionShare(int possession) {
    return '$possession% penguasaan bola';
  }

  @override
  String get boardVerdictSackedTitle => 'Dewan federasi memecat Anda';

  @override
  String boardVerdictSackedBody(int rating) {
    return 'Siklus yang buruk sekali (rating $rating%). Masa jabatan Anda berakhir di sini. Hanya negara-negara kecil yang mau mengambil risiko dengan Anda sekarang.';
  }

  @override
  String get boardVerdictDelightedTitle => 'Dewan federasi sangat puas';

  @override
  String boardVerdictDelightedBody(int rating, String best) {
    return 'Siklus yang luar biasa (rating $rating%) setelah $best. Negara-negara besar tertarik, atau Anda bisa bertahan dan terus membangun.';
  }

  @override
  String get boardVerdictSolidTitle => 'Siklus yang solid';

  @override
  String boardVerdictSolidBody(int rating) {
    return 'Dewan federasi puas (rating $rating%). Beberapa negara selevel mau merekrut Anda, tetapi tidak ada tekanan untuk pindah.';
  }

  @override
  String get boardVerdictExpectedMoreTitle => 'Dewan federasi berharap lebih';

  @override
  String boardVerdictExpectedMoreBody(int rating) {
    return 'Siklus yang mengecewakan (rating $rating%). Anda tetap menjabat, tetapi tawaran apa pun berarti turun kelas.';
  }

  @override
  String get boardVerdictPressureTitle => 'Anda berada di bawah tekanan berat';

  @override
  String boardVerdictPressureBody(int rating) {
    return 'Siklus yang buruk (rating $rating%). Anda selamat, tetapi hanya negara yang lebih lemah yang tertarik jika Anda ingin memulai lembaran baru.';
  }

  @override
  String get boardVerdictHeroTitle => 'Bangsa ini mendukung Anda';

  @override
  String boardVerdictHeroNote(String nation, int cycles) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles siklus',
    );
    return ' $nation memuja Anda, pahlawan nasional setelah $_temp0; jabatan Anda aman selama Anda menginginkannya.';
  }

  @override
  String get boardVerdictTheNation => 'Bangsa ini';

  @override
  String get boardVerdictBestQuiet => 'siklus yang sepi';

  @override
  String get boardVerdictBestCycle => 'siklus ini';

  @override
  String boardVerdictBestWorld(String placement) {
    return 'Kejuaraan Dunia: $placement';
  }

  @override
  String get finishThirdPlace => 'Peringkat ketiga';

  @override
  String get finishFourthPlace => 'Peringkat keempat';

  @override
  String get finishDidNotQualify => 'Tidak lolos';

  @override
  String get careerRepIconic => 'Ikonik';

  @override
  String get careerRepRenowned => 'Termasyhur';

  @override
  String get careerRepEstablished => 'Mapan';

  @override
  String get careerRepRising => 'Naik daun';

  @override
  String get careerRepUnproven => 'Belum teruji';

  @override
  String get hubOfferStepUp => 'Naik kelas';

  @override
  String get hubOfferLateral => 'Pindah selevel';

  @override
  String get hubOfferRebuild => 'Membangun ulang';

  @override
  String careerNationsCupWon(String league) {
    return 'Liga $league · Juara';
  }

  @override
  String careerNationsCupRunnerUp(String league) {
    return 'Liga $league · Runner-up';
  }

  @override
  String careerNationsCupSemi(String league) {
    return 'Liga $league · Semifinalis';
  }

  @override
  String careerNationsCupPlaced(String league, int position) {
    return 'Liga $league · #$position';
  }

  @override
  String tourRunInto(String round) {
    return 'Menuju $round';
  }

  @override
  String get tourRunIntoThirdPlace => 'Menuju perebutan tempat ketiga';

  @override
  String tourRunThrough(String round) {
    return 'Lolos dari $round';
  }

  @override
  String tourRunOut(String round) {
    return 'Tersingkir di $round';
  }

  @override
  String get tourRunInGroup => 'Berjuang di fase grup';

  @override
  String get tourRunGroupOut => 'Tersingkir di fase grup';

  @override
  String resultsCycleTitle(int year, String nation) {
    return 'Siklus $year · $nation';
  }

  @override
  String resultsCycleRecord(int played, int won, int drawn, int lost) {
    return '$played laga  ·  ${won}M ${drawn}S ${lost}K';
  }

  @override
  String resultsCycleFinish(String finish) {
    return 'Kejuaraan Dunia: $finish';
  }

  @override
  String get resultsCycleUnderway => 'Masih berjalan';

  @override
  String yTurnedItRound0(String opponent) {
    return 'Tertinggal dua gol dari $opponent saat turun minum dan mereka membalas semuanya. Itu baru tim.';
  }

  @override
  String yTurnedItRound1(String opponent) {
    return 'Tertinggal dua gol melawan $opponent dan di akhir laga itu tak berarti apa-apa. Tidak banyak tim yang bisa begitu.';
  }

  @override
  String yTurnedItRound2(String opponent) {
    return 'Turun minum: tertinggal dua gol dari $opponent. Peluit akhir: tidak lagi. Babak kedua seperti laga yang berbeda.';
  }

  @override
  String yTurnedItRound3(String opponent) {
    return 'Bangkit dari ketertinggalan dua gol melawan $opponent. Apa pun yang dikatakan saat turun minum, ucapkan setiap pekan.';
  }

  @override
  String yTurnedItRound4(String opponent) {
    return 'Oke, kita bisa membalasnya melawan $opponent. Sekarang ada yang mau menjelaskan 45 menit pertama?';
  }

  @override
  String yTurnedItRound5(String opponent) {
    return 'Tertinggal dua gol dari $opponent dan kita disuruh senang. Perbaiki babak pertama.';
  }

  @override
  String yThrewItAway0(String opponent) {
    return 'Unggul dua gol atas $opponent saat turun minum dan semuanya lepas. Tim yang lebih baik pun pernah begini.';
  }

  @override
  String yThrewItAway1(String opponent) {
    return 'Unggul dua gol dari $opponent dan lepas begitu saja. Siklusnya panjang, masih banyak waktu.';
  }

  @override
  String yThrewItAway2(String opponent) {
    return 'Turun minum: unggul dua gol dari $opponent. Peluit akhir: sama sekali tidak seperti itu.';
  }

  @override
  String yThrewItAway3(String opponent) {
    return 'Unggul dua gol atas $opponent, hilang dalam 45 menit.';
  }

  @override
  String yThrewItAway4(String opponent) {
    return 'Unggul dua gol lalu kalah. Dari $opponent. Harus ada yang bertanggung jawab.';
  }

  @override
  String yThrewItAway5(String opponent) {
    return 'Unggul dua gol atas $opponent dan kita malah begini. Setiap kali.';
  }

  @override
  String get cycleBackupDone =>
      'Karier dicadangkan ke folder FNM di ponsel ini. Menghapus aplikasi akan menghapusnya juga: untuk menyimpan salinan di tempat lain, gunakan Cadangkan simpanan ini di layar simpanan.';

  @override
  String get cycleBackupFailed => 'Karier tidak dapat dicadangkan kali ini.';

  @override
  String pressMomentBigWinWarm1(String opponent) {
    return 'Malam yang tak terlupakan melawan $opponent. Seberapa bangga Anda pada skuad ini?';
  }

  @override
  String pressMomentBigWinWarm2(String opponent) {
    return '$opponent tak sanggup mengimbangi Anda. Inikah tim yang selalu Anda yakini ada?';
  }

  @override
  String pressMomentBigWinNeutral1(String opponent) {
    return 'Kemenangan besar atas $opponent. Apa yang membuat perbedaan malam ini?';
  }

  @override
  String pressMomentBigWinNeutral2(String opponent) {
    return '$opponent dikalahkan, dan dengan nyaman. Di mana Anda memenangkannya?';
  }

  @override
  String pressMomentBigWinHostile1(String opponent) {
    return 'Kemenangan bagus atas $opponent. Baru satu malam yang bagus: kenapa orang harus percaya ini akan bertahan?';
  }

  @override
  String pressMomentBigWinHostile2(String opponent) {
    return 'Hasil yang bagus melawan $opponent. Itu rencana Anda, atau para pemain menyelesaikannya sendiri?';
  }

  @override
  String pressMomentBigLossWarm1(String opponent) {
    return 'Malam yang berat melawan $opponent. Apa yang Anda katakan kepada para pemain setelah laga seperti itu?';
  }

  @override
  String pressMomentBigLossWarm2(String opponent) {
    return 'Tak ada yang menduga ini melawan $opponent. Apakah ini hanya malam yang kebetulan buruk?';
  }

  @override
  String pressMomentBigLossNeutral1(String opponent) {
    return 'Itu malam yang memalukan melawan $opponent. Apa yang salah?';
  }

  @override
  String pressMomentBigLossNeutral2(String opponent) {
    return '$opponent membongkar habis tim Anda. Apakah skuad ini cukup bagus?';
  }

  @override
  String pressMomentBigLossHostile1(String opponent) {
    return 'Anda kalah dalam segala hal melawan $opponent. Bagaimana Anda membiarkannya separah itu?';
  }

  @override
  String pressMomentBigLossHostile2(String opponent) {
    return '$opponent mencetak gol sesuka hati. Di mana rencana Anda malam ini?';
  }

  @override
  String pressMomentCrisisWarm1(String opponent) {
    return 'Satu laga lagi lepas, kali ini melawan $opponent. Bagaimana Anda membalikkan tren ini?';
  }

  @override
  String pressMomentCrisisWarm2(String opponent) {
    return 'Kemenangan tak kunjung datang, dan $opponent memperburuknya. Apakah Anda masih percaya pada skuad ini?';
  }

  @override
  String pressMomentCrisisNeutral1(String opponent) {
    return 'Lagi-lagi tanpa kemenangan, kini melawan $opponent, dan dewan federasi mengawasi. Apakah jabatan Anda aman?';
  }

  @override
  String pressMomentCrisisNeutral2(String opponent) {
    return 'Setelah $opponent, rentetan ini makin panjang. Apakah Anda khawatir dengan masa depan Anda?';
  }

  @override
  String pressMomentCrisisHostile1(String opponent) {
    return 'Sekarang $opponent juga. Pendahulu Anda dipecat dengan rentetan seperti ini. Kenapa Anda harus selamat?';
  }

  @override
  String pressMomentCrisisHostile2(String opponent) {
    return 'Setelah malam seperti lawan $opponent, semua siaran telepon menginginkan Anda pergi. Apakah Anda mau mundur jika dewan federasi memintanya?';
  }

  @override
  String pressMomentJobVerdictWarm1(String opponent) {
    return 'Anda mempertaruhkan jabatan, dan setelah $opponent hasilnya tak berpihak pada Anda. Bagaimana kondisi Anda?';
  }

  @override
  String pressMomentJobVerdictWarm2(String opponent) {
    return 'Tiga laga sudah selesai, yang terakhir melawan $opponent. Anda sendiri yang menetapkan ujiannya. Bagaimana Anda menilai putusannya?';
  }

  @override
  String pressMomentJobVerdictNeutral1(String opponent) {
    return 'Anda minta dinilai dari tiga laga berikutnya. Setelah $opponent, kami sudah menilai. Apakah jabatan itu masih milik Anda?';
  }

  @override
  String pressMomentJobVerdictNeutral2(String opponent) {
    return 'Tiga laga, yang terakhir melawan $opponent, dan tidak seperti yang Anda janjikan. Sudahkah Anda bicara dengan dewan federasi soal masa depan Anda?';
  }

  @override
  String pressMomentJobVerdictHostile1(String opponent) {
    return 'Anda sendiri yang menetapkan ujian itu dan gagal melawan $opponent. Apakah Anda akan mengundurkan diri?';
  }

  @override
  String pressMomentJobVerdictHostile2(String opponent) {
    return 'Kata-kata Anda sendiri, bukan kami: nilai saya dari tiga laga berikutnya. Setelah $opponent, kenapa Anda masih duduk di situ?';
  }

  @override
  String get pressBeatWhoToBlameWarm1 =>
      'Anda menginginkan lebih dari mereka. Ada yang secara khusus?';

  @override
  String get pressBeatWhoToBlameWarm2 =>
      'Anda sudah menetapkan standar tinggi. Siapa yang harus melangkah maju lebih dulu?';

  @override
  String get pressBeatWhoToBlameNeutral1 =>
      'Anda bilang sebagian dari mereka harus berkaca. Siapa yang Anda maksud?';

  @override
  String get pressBeatWhoToBlameNeutral2 =>
      'Belum cukup baik, kata Anda. Siapa yang Anda bicarakan?';

  @override
  String get pressBeatWhoToBlameHostile1 =>
      'Anda terus berkelit. Maukah Anda menyebut nama, atau ini kembali ke Anda?';

  @override
  String get pressBeatWhoToBlameHostile2 =>
      'Setiap pekan selalu salah orang lain. Salah siapa kali ini?';

  @override
  String get pressBeatIfYouDontWarm1 =>
      'Kata-kata yang berani. Bagaimana kalau laga berikutnya tidak berpihak pada Anda?';

  @override
  String get pressBeatIfYouDontWarm2 =>
      'Seluruh negeri akan menagih janji itu. Bagaimana kalau tidak terwujud?';

  @override
  String get pressBeatIfYouDontNeutral1 =>
      'Dan kalau Anda tidak menang? Lalu apa?';

  @override
  String get pressBeatIfYouDontNeutral2 =>
      'Anda sudah mengatakannya. Apa yang terjadi kalau Anda salah?';

  @override
  String get pressBeatIfYouDontHostile1 =>
      'Kami sudah sering mendengar janji di ruangan ini. Apa utang Anda kepada suporter kalau janji ini juga ingkar?';

  @override
  String get pressBeatIfYouDontHostile2 =>
      'Dan saat itu tak terjadi, apa alasannya nanti?';

  @override
  String get pressBeatFollowUpWarm1 =>
      'Satu lagi, kalau Anda masih sanggup. Apa yang masih perlu dibenahi skuad ini?';

  @override
  String get pressBeatFollowUpWarm2 =>
      'Setelah semuanya reda, apa yang Anda bawa dari malam ini ke laga berikutnya?';

  @override
  String get pressBeatFollowUpNeutral1 =>
      'Mari lebih dalam lagi. Apa yang harus membaik sebelum laga berikutnya?';

  @override
  String get pressBeatFollowUpNeutral2 =>
      'Di luar skor akhir: apakah skuad ini sudah seperti yang Anda inginkan?';

  @override
  String get pressBeatFollowUpHostile1 =>
      'Banyak kata, sedikit isi. Apa yang sebenarnya berubah mulai sekarang?';

  @override
  String get pressBeatFollowUpHostile2 =>
      'Suporter menginginkan jawaban lugas. Apakah tim ini cukup bagus, ya atau tidak?';

  @override
  String pressBeatStandoutWarm1(String player) {
    return '$player tampil luar biasa malam ini. Sejauh mana dia bisa melangkah?';
  }

  @override
  String pressBeatStandoutWarm2(String player) {
    return '$player jadi sorotan semua berita malam ini. Apakah Anda sudah menduganya?';
  }

  @override
  String pressBeatStandoutNeutral1(String player) {
    return '$player menonjol. Apa yang Anda minta darinya malam ini?';
  }

  @override
  String pressBeatStandoutNeutral2(String player) {
    return 'Apakah $player pembeda malam ini?';
  }

  @override
  String pressBeatStandoutHostile1(String player) {
    return 'Tanpa $player ceritanya lain. Ini sebuah tim, atau satu pemain?';
  }

  @override
  String pressBeatStandoutHostile2(String player) {
    return '$player brilian. Berkat Anda, atau dia sendiri?';
  }

  @override
  String pressBeatStrugglerWarm1(String player) {
    return '$player mengalami malam yang berat. Apakah dia membawa cedera ringan?';
  }

  @override
  String pressBeatStrugglerWarm2(String player) {
    return '$player tidak sedang di malamnya. Apakah Anda akan merangkulnya?';
  }

  @override
  String pressBeatStrugglerNeutral1(String player) {
    return '$player kesulitan malam ini. Apakah dia tetap mempertahankan posisinya?';
  }

  @override
  String pressBeatStrugglerNeutral2(String player) {
    return '$player tampak tertinggal dari ritme. Bagaimana penilaian Anda atas permainannya?';
  }

  @override
  String pressBeatStrugglerHostile1(String player) {
    return '$player jadi penumpang lagi. Kenapa Anda terus memainkannya?';
  }

  @override
  String pressBeatStrugglerHostile2(String player) {
    return 'Semua orang bisa melihat $player tidak dalam performa. Semua kecuali bangku cadangan?';
  }

  @override
  String get pressThrowbackWinNextKeptWarm =>
      'Anda bilang akan memenangi laga berikutnya, dan Anda menang. Senang rasanya terbukti benar?';

  @override
  String get pressThrowbackWinNextKeptNeutral =>
      'Anda menjanjikan kemenangan di laga berikutnya dan menepatinya. Percaya diri, atau bualan?';

  @override
  String get pressThrowbackWinNextKeptHostile =>
      'Anda bilang akan menang di laga berikutnya, dan Anda menang. Keberuntungan, atau kami harus mulai mendengarkan?';

  @override
  String get pressThrowbackWinNextBrokenWarm =>
      'Anda bilang akan memenangi laga itu. Ternyata tidak. Apa yang salah?';

  @override
  String get pressThrowbackWinNextBrokenNeutral =>
      'Anda bilang akan menang di laga berikutnya. Ternyata tidak. Kenapa kami harus percaya janji berikutnya?';

  @override
  String get pressThrowbackWinNextBrokenHostile =>
      'Anda bilang akan menang di laga berikutnya. Ternyata tidak. Apakah kata-kata Anda masih berarti di ruangan ini?';

  @override
  String get pressThrowbackJobKeptWarm =>
      'Anda minta dinilai dari tiga laga, dan Anda lulus. Terbukti benar?';

  @override
  String get pressThrowbackJobKeptNeutral =>
      'Nilai saya dari tiga laga berikutnya, kata Anda. Kami sudah menilai, dan hasilnya datang. Apa yang diajarkan ujian itu kepada Anda?';

  @override
  String get pressThrowbackJobKeptHostile =>
      'Anda memberi diri sendiri tiga laga dan melewatinya. Apakah ujian itu pernah sesulit itu?';

  @override
  String get pressThrowbackJobBrokenWarm =>
      'Anda minta dinilai dari tiga laga. Hasilnya tak berpihak pada Anda. Apa yang sudah Anda pelajari?';

  @override
  String get pressThrowbackJobBrokenNeutral =>
      'Anda bilang nilai saya dari tiga laga berikutnya. Tiga laga itu sudah lewat, begitu pula kelonggaran untuk Anda. Lalu bagaimana?';

  @override
  String get pressThrowbackJobBrokenHostile =>
      'Anda menetapkan ujian itu dan gagal. Kenapa ada yang harus memercayai kata-kata Anda sekarang?';

  @override
  String pressThrowbackBackKeptWarm(String player) {
    return 'Anda membela $player ketika orang lain tidak. Dia membuktikannya. Ada andil Anda di situ?';
  }

  @override
  String pressThrowbackBackKeptNeutral(String player) {
    return 'Anda membela $player. Dia membayarnya lunas. Keyakinan, atau pengetahuan?';
  }

  @override
  String pressThrowbackBackKeptHostile(String player) {
    return 'Anda membela $player, dan kali ini berbuah hasil. Apakah Anda akan seyakin itu lagi lain kali?';
  }

  @override
  String pressThrowbackBackBrokenWarm(String player) {
    return 'Anda berdiri di sisi $player, dan hasilnya tidak seperti harapan. Apakah Anda masih percaya padanya?';
  }

  @override
  String pressThrowbackBackBrokenNeutral(String player) {
    return 'Anda membela $player. Dia belum membalasnya. Apakah itu kesalahan?';
  }

  @override
  String pressThrowbackBackBrokenHostile(String player) {
    return 'Penilaian atau loyalitas Anda: mana yang gagal pada $player?';
  }

  @override
  String pressThrowbackBlameKeptWarm(String player) {
    return 'Anda keras terhadap $player, dan laga-laga setelahnya membuktikan Anda benar. Ada kepuasan di situ?';
  }

  @override
  String pressThrowbackBlameKeptNeutral(String player) {
    return 'Anda menegur $player di depan umum, dan dia belum menjawab. Adakah jalan kembali untuknya?';
  }

  @override
  String pressThrowbackBlameKeptHostile(String player) {
    return 'Anda membiarkan $player sendirian dan dia belum pulih. Apakah Anda yang menghancurkannya?';
  }

  @override
  String pressThrowbackBlameBrokenWarm(String player) {
    return 'Anda menegur $player, dan dia menjawab Anda di lapangan. Apakah itu memang tujuan Anda sejak awal?';
  }

  @override
  String pressThrowbackBlameBrokenNeutral(String player) {
    return 'Anda menyalahkan $player, dan sejak itu dia menjadi salah satu yang terbaik. Apakah Anda berutang maaf padanya?';
  }

  @override
  String pressThrowbackBlameBrokenHostile(String player) {
    return 'Anda mengorbankan $player, dan dia jadi pemain terbaik Anda sejak itu. Apakah Anda akan meminta maaf?';
  }

  @override
  String get pressReplyCreditPlayers1 =>
      'Para pemain ini memberikan segalanya untuk saya. Saya tak akan menukar satu pun dari mereka.';

  @override
  String get pressReplyCreditPlayers2 =>
      'Tak ada yang bekerja lebih keras dari skuad ini. Saya akan membela mereka sepanjang hari.';

  @override
  String get pressReplyCreditPlayers3 =>
      'Anda tak akan mendengar sepatah kata pun yang menjelekkan pemain saya dari kursi ini.';

  @override
  String get pressReplyCreditPlayers4 =>
      'Para pemain layak mendapat pujian, bukan saya. Tulislah tentang mereka.';

  @override
  String get pressReplyTakeResponsibility1 =>
      'Itu tanggung jawab saya. Saya yang memilih susunan pemain dan menyiapkan mereka.';

  @override
  String get pressReplyTakeResponsibility2 =>
      'Nilai saya, bukan mereka. Ini tim saya dan tanggung jawab saya.';

  @override
  String get pressReplyTakeResponsibility3 =>
      'Kalau Anda mencari orang untuk disalahkan, saya duduk di sini.';

  @override
  String get pressReplyTakeResponsibility4 =>
      'Tanggung jawab ada pada saya. Jangan libatkan para pemain.';

  @override
  String get pressReplyDemandMore1 =>
      'Saya menginginkan lebih. Sebagian dari mereka tahu persis maksud saya.';

  @override
  String get pressReplyDemandMore2 =>
      'Usaha saja tidak cukup di level ini. Saya ingin lebih, dan sudah saya katakan kepada mereka.';

  @override
  String get pressReplyDemandMore3 =>
      'Saya mengharapkan lebih dari setiap orang, mulai besok.';

  @override
  String get pressReplyDemandMore4 =>
      'Sebagian dari mereka harus berkaca. Saya tidak puas.';

  @override
  String get pressReplyPromiseWinNext1 =>
      'Kami akan memenangi laga berikutnya. Silakan catat.';

  @override
  String get pressReplyPromiseWinNext2 =>
      'Ingat kata-kata saya: kami menang di laga berikutnya.';

  @override
  String get pressReplyPromiseWinNext3 =>
      'Laga berikutnya, kami menang. Saya katakan di sini agar Anda bisa menagihnya.';

  @override
  String get pressReplyPromiseWinNext4 =>
      'Saya yakin pada tim ini. Kami menang di laga berikutnya.';

  @override
  String get pressReplyJobOnTheLine1 =>
      'Nilai saya dari tiga laga berikutnya. Itu adil.';

  @override
  String get pressReplyJobOnTheLine2 =>
      'Beri saya tiga laga. Kalau belum beres saat itu, nilai saya.';

  @override
  String get pressReplyJobOnTheLine3 =>
      'Tiga laga berikutnya akan menunjukkan apakah saya orang yang tepat. Tagih saya.';

  @override
  String get pressReplyJobOnTheLine4 =>
      'Tiga laga. Setelah itu tulislah apa pun tentang saya.';

  @override
  String get pressReplyDeflect1 =>
      'Kami jalani satu laga demi satu laga. Tak ada yang perlu ditambahkan.';

  @override
  String get pressReplyDeflect2 =>
      'Hari ini saya tidak akan membuat berita untuk Anda.';

  @override
  String get pressReplyDeflect3 =>
      'Laga berikutnya. Hanya itu yang saya pikirkan.';

  @override
  String get pressReplyDeflect4 =>
      'Apa yang saya pikirkan tetap di ruang ganti.';

  @override
  String get pressReplyTakeCredit1 =>
      'Saya mengatakannya karena saya yakin, dan saya benar.';

  @override
  String get pressReplyTakeCredit2 =>
      'Saya membacanya dengan benar. Itulah gunanya saya di sini.';

  @override
  String get pressReplyTakeCredit3 =>
      'Sebut saja penilaian. Saya tahu apa yang saya katakan.';

  @override
  String get pressReplyTakeCredit4 =>
      'Saya mengambil keputusan dan berhasil. Saya terima itu.';

  @override
  String get pressReplyStandByIt1 =>
      'Saya mengatakan apa yang saya yakini. Saya tetap pada ucapan itu.';

  @override
  String get pressReplyStandByIt2 => 'Saya tidak menarik satu kata pun.';

  @override
  String get pressReplyStandByIt3 =>
      'Jawaban saya sama seperti dulu. Saya bersungguh-sungguh, dan masih begitu.';

  @override
  String get pressReplyStandByIt4 => 'Saya akan mengatakannya lagi besok.';

  @override
  String get pressReplyAdmitMistake1 => 'Saya salah soal itu. Saya akui.';

  @override
  String get pressReplyAdmitMistake2 =>
      'Wajar, saya salah menilai. Saya akan belajar darinya.';

  @override
  String get pressReplyAdmitMistake3 =>
      'Saya salah, dan saya bisa mengatakannya.';

  @override
  String get pressReplyAdmitMistake4 =>
      'Keputusan itu tidak berhasil, dan itu keputusan saya.';

  @override
  String pressReplyBackPlayer1(String player) {
    return '$player mendapat dukungan penuh dari saya. Dia akan bangkit.';
  }

  @override
  String pressReplyBackPlayer2(String player) {
    return 'Saya percaya pada $player, dan dia akan menunjukkan alasannya.';
  }

  @override
  String pressReplyBackPlayer3(String player) {
    return 'Anda tak akan mendengar sepatah kata pun yang menjelekkan $player dari saya. Dia akan membuktikannya.';
  }

  @override
  String pressReplyBackPlayer4(String player) {
    return '$player tetap ada dalam rencana saya. Lihat saja apa yang dia lakukan selanjutnya.';
  }

  @override
  String pressReplyBlamePlayer1(String player) {
    return '$player mengecewakan kami malam ini, dan dia tahu itu.';
  }

  @override
  String pressReplyBlamePlayer2(String player) {
    return 'Saya mengharapkan jauh lebih banyak dari $player. Dia harus menjawabnya.';
  }

  @override
  String pressReplyBlamePlayer3(String player) {
    return '$player tidak berada di levelnya. Saya akan mengatakannya secara terbuka.';
  }

  @override
  String pressReplyBlamePlayer4(String player) {
    return 'Itu belum cukup baik dari $player, dan dia akan mendengarnya langsung dari saya.';
  }

  @override
  String get pressOnRecordWinNext =>
      'Tercatat: Anda akan memenangi laga berikutnya.';

  @override
  String get pressOnRecordJob =>
      'Tercatat: Anda dinilai dari tiga laga berikutnya.';

  @override
  String pressOnRecordBack(String player) {
    return 'Tercatat: membela $player.';
  }

  @override
  String pressOnRecordBlame(String player) {
    return 'Tercatat: $player mengecewakan Anda.';
  }

  @override
  String yStatementKept0(String nation) {
    return 'Dia mengatakannya, dan terjadi. $nation punya pelatih yang menepati ucapannya.';
  }

  @override
  String yStatementKept1(String nation) {
    return 'Berkata lantang, lalu membuktikannya. Inilah orang yang dibutuhkan $nation.';
  }

  @override
  String yStatementKept2(String nation) {
    return '$nation: dia menebaknya, dan terjadi. Boleh juga.';
  }

  @override
  String yStatementKept3(String nation) {
    return 'Dia mencatatnya di depan umum dan terbukti. Satu angka untuknya. $nation melangkah maju.';
  }

  @override
  String yStatementKept4(String nation) {
    return 'Satu kali dia benar. $nation, jangan terlalu terbiasa.';
  }

  @override
  String yStatementKept5(String nation) {
    return 'Jam rusak pun benar dua kali sehari. $nation sedang beruntung kali ini.';
  }

  @override
  String yStatementBroken0(String nation) {
    return 'Dia mengatakannya dan tidak berhasil. Saya tetap bersamanya. $nation maju lagi.';
  }

  @override
  String yStatementBroken1(String nation) {
    return '$nation: dia menjanjikan lebih dari yang kita dapat, tapi saya lebih suka pelatih yang percaya pada dirinya.';
  }

  @override
  String yStatementBroken2(String nation) {
    return '$nation: dia mengatakannya secara terbuka dan tidak terjadi. Orang akan ingat.';
  }

  @override
  String yStatementBroken3(String nation) {
    return 'Kata-kata besar, tanpa isi. $nation: lain kali, bicaralah lebih sedikit.';
  }

  @override
  String yStatementBroken4(String nation) {
    return 'Dia berdiri di sana dan memberi tahu kita. Lalu ini. $nation pantas mendapat lebih dari sekadar omongan.';
  }

  @override
  String yStatementBroken5(String nation) {
    return 'Ucapannya tak ada harganya sekarang. Catat, $nation.';
  }

  @override
  String get ncZoneNorth => 'Zona Utara';

  @override
  String get ncZoneWest => 'Zona Barat';

  @override
  String get ncZoneEast => 'Zona Timur';

  @override
  String get ncZoneCentralSouthern => 'Zona Tengah dan Selatan';

  @override
  String careerNationsCupZoneWon(String zone) {
    return '$zone · Juara';
  }

  @override
  String careerNationsCupZoneRunnerUp(String zone) {
    return '$zone · Runner-up';
  }

  @override
  String careerNationsCupZoneSemi(String zone) {
    return '$zone · Semifinalis';
  }

  @override
  String careerNationsCupZoneRoundOf16(String zone) {
    return '$zone · Babak 16 besar';
  }

  @override
  String careerNationsCupZoneQuarter(String zone) {
    return '$zone · Perempat finalis';
  }

  @override
  String careerNationsCupZonePlaced(String zone, int position) {
    return '$zone · #$position';
  }

  @override
  String get objectiveNcFinalsEight => 'Capai perempat final';

  @override
  String get objectiveNcZoneWinGroup => 'Juarai grup Anda';

  @override
  String get finishNcFinalsEight => 'Perempat final';

  @override
  String get finishNcBottomHalf => 'Paruh bawah grup';

  @override
  String get tourContTabZones => 'ZONA';

  @override
  String get tourContTabFinalsEight => 'BABAK GUGUR';

  @override
  String get tourContFinalsEightSoon =>
      'Babak gugur dimulai November dengan babak 16 besar: seluruh 14 juara grup dan 2 runner-up terbaik.';

  @override
  String get tourContQuarterFinals => 'PEREMPAT FINAL';

  @override
  String get tourContZoneAdvancement =>
      'Setiap juara grup lolos ke babak 16 besar, ditemani 2 runner-up terbaik. Tidak ada yang terdegradasi.';

  @override
  String tourContZoneHeadingYours(String zone) {
    return '$zone ★';
  }

  @override
  String get compNorthAmericaNationsCup => 'Piala Bangsa-Bangsa Amerika Utara';

  @override
  String get compAfricanNationsCup => 'Piala Bangsa-Bangsa';

  @override
  String get objectiveNcWinItNorthAmerica =>
      'Juarai Piala Bangsa-Bangsa Amerika Utara';

  @override
  String get objectiveNcWinItAfrica => 'Juarai Piala Bangsa-Bangsa';

  @override
  String get objectiveNcReachFinalNorthAmerica =>
      'Capai final Piala Bangsa-Bangsa Amerika Utara';

  @override
  String get objectiveNcReachFinalAfrica => 'Capai final Piala Bangsa-Bangsa';

  @override
  String get finishNcChampionsNorthAmerica =>
      'Juara Piala Bangsa-Bangsa Amerika Utara';

  @override
  String get finishNcChampionsAfrica => 'Juara Piala Bangsa-Bangsa';

  @override
  String pressAimQualWarm1(String competition) {
    return 'Kualifikasi $competition dimulai sekarang, dan seluruh negeri percaya pada tim ini. Apa yang Anda targetkan?';
  }

  @override
  String pressAimQualWarm2(String competition) {
    return 'Kampanye kualifikasi $competition yang baru, dan semangat sedang tinggi. Sejauh mana tim ini bisa melangkah?';
  }

  @override
  String pressAimQualNeutral1(String competition) {
    return 'Kualifikasi $competition dimulai. Apa target untuk kampanye ini?';
  }

  @override
  String pressAimQualNeutral2(String competition) {
    return 'Babak kualifikasi $competition sudah tiba. Di mana Anda melihat tim ini finis?';
  }

  @override
  String pressAimQualHostile1(String competition) {
    return 'Kualifikasi $competition dimulai, dan banyak orang meragukan Anda akan sampai ke sana. Apa jawaban Anda kepada mereka?';
  }

  @override
  String pressAimQualHostile2(String competition) {
    return 'Satu lagi kampanye kualifikasi $competition. Kenapa ada yang harus percaya yang ini akan berbeda?';
  }

  @override
  String pressAimFinalsWarm1(String competition) {
    return '$competition sudah di depan mata dan seluruh negeri mendukung Anda. Sejauh mana Anda bisa melangkah?';
  }

  @override
  String pressAimFinalsWarm2(String competition) {
    return 'Anda berada di $competition dan para suporter bermimpi. Apa targetnya?';
  }

  @override
  String pressAimFinalsNeutral1(String competition) {
    return '$competition dimulai pekan ini. Apa yang dianggap sukses?';
  }

  @override
  String pressAimFinalsNeutral2(String competition) {
    return 'Laga pertama Anda di $competition sudah dekat. Berikan kami target.';
  }

  @override
  String pressAimFinalsHostile1(String competition) {
    return '$competition sudah tiba dan tak ada yang berharap banyak. Apa yang sebenarnya Anda harapkan?';
  }

  @override
  String pressAimFinalsHostile2(String competition) {
    return 'Anda berada di $competition, tetapi keraguan belum hilang. Apa target Anda?';
  }

  @override
  String pressBeatRivalWarm1(String rival) {
    return '$rival ada di grup Anda. Apakah mereka mengkhawatirkan Anda?';
  }

  @override
  String pressBeatRivalWarm2(String rival) {
    return 'Undian menempatkan $rival di jalan Anda. Bagaimana Anda melihat laga itu?';
  }

  @override
  String pressBeatRivalNeutral1(String rival) {
    return '$rival tampak sebagai tim terkuat di grup Anda. Apakah mereka favorit?';
  }

  @override
  String pressBeatRivalNeutral2(String rival) {
    return 'Bagaimana pendapat Anda tentang $rival?';
  }

  @override
  String pressBeatRivalHostile1(String rival) {
    return '$rival ada di grup Anda. Jujur saja, bisakah Anda mengimbangi mereka?';
  }

  @override
  String pressBeatRivalHostile2(String rival) {
    return 'Kebanyakan orang mengharapkan $rival mengalahkan Anda. Apakah mereka salah?';
  }

  @override
  String pressBeatKeyPlayerWarm1(String player) {
    return '$player sedang dalam performa bagus. Inikah momennya?';
  }

  @override
  String pressBeatKeyPlayerWarm2(String player) {
    return '$player ada di setiap berita. Bisakah dia memikul tim ini?';
  }

  @override
  String pressBeatKeyPlayerNeutral1(String player) {
    return 'Seberapa besar kampanye ini bergantung pada $player?';
  }

  @override
  String pressBeatKeyPlayerNeutral2(String player) {
    return 'Apakah $player siap memimpin tim ini?';
  }

  @override
  String pressBeatKeyPlayerHostile1(String player) {
    return 'Kalau $player tidak dalam performa terbaiknya, apakah tim ini punya sesuatu?';
  }

  @override
  String pressBeatKeyPlayerHostile2(String player) {
    return '$player memikul beban yang besar. Terlalu besar?';
  }

  @override
  String get pressReplyAimHigher1 =>
      'Kami akan melangkah lebih jauh dari yang diperkirakan siapa pun.';

  @override
  String get pressReplyAimHigher2 =>
      'Saya ingin lebih dari yang diminta federasi, dan saya akan mengatakannya terang-terangan.';

  @override
  String get pressReplyMatchBrief1 =>
      'Kami tahu targetnya dan kami akan mencapainya.';

  @override
  String get pressReplyMatchBrief2 =>
      'Federasi menetapkan target. Kami akan memenuhinya.';

  @override
  String get pressReplyPlayDown1 =>
      'Mari kita jalani satu laga demi satu laga.';

  @override
  String get pressReplyPlayDown2 =>
      'Tidak ada janji besar. Kita lihat saja nanti.';

  @override
  String get pressReplyPromiseQualify1 => 'Kami akan lolos. Silakan catat.';

  @override
  String get pressReplyPromiseQualify2 => 'Tim ini akan ada di putaran final.';

  @override
  String get pressReplyFearNobody1 => 'Kami tidak takut siapa pun.';

  @override
  String get pressReplyFearNobody2 => 'Mereka juga harus bermain melawan kami.';

  @override
  String get pressReplyRespectRival1 =>
      'Mereka favorit, dan kami menghormati mereka.';

  @override
  String get pressReplyRespectRival2 =>
      'Tim yang sangat bagus. Kami butuh yang terbaik dari kami.';

  @override
  String get pressReplyTeamFirst1 =>
      'Ini tentang seluruh tim, bukan satu pemain.';

  @override
  String get pressReplyTeamFirst2 => 'Tak ada yang menang sendirian.';

  @override
  String pressOnRecordTarget(String aim) {
    return 'Tercatat: $aim.';
  }

  @override
  String get pressOnRecordPlayDown => 'Tercatat: tanpa janji.';

  @override
  String get pressThrowbackTargetKeptWarm =>
      'Anda menetapkan target sebelum kampanye dan mencapainya. Inikah momen terbanggakan Anda sejauh ini?';

  @override
  String get pressThrowbackTargetKeptNeutral =>
      'Anda mengatakan apa yang akan dicapai, dan Anda mencapainya. Apakah itu pernah diragukan?';

  @override
  String get pressThrowbackTargetKeptHostile =>
      'Anda mencapai target yang Anda tetapkan. Beruntung, atau memang itu rencananya?';

  @override
  String get pressThrowbackTargetBrokenWarm =>
      'Anda menetapkan target dan gagal mencapainya. Apa yang salah?';

  @override
  String get pressThrowbackTargetBrokenNeutral =>
      'Anda menjanjikan lebih dari yang diberikan tim ini. Apakah Anda menyesal mengatakannya?';

  @override
  String get pressThrowbackTargetBrokenHostile =>
      'Anda berbicara besar sebelum kampanye dan gagal. Kenapa kami harus percaya Anda sekarang?';

  @override
  String hubEventPressPreviewSub(String competition) {
    return 'Pers ingin mendengar target Anda untuk $competition';
  }

  @override
  String deptLevelCost(int level, String amount) {
    return 'Tingkat $level · $amount';
  }

  @override
  String get formOnFire => 'Membara';

  @override
  String get formGood => 'Dalam performa';

  @override
  String get formSteady => 'Stabil';

  @override
  String get formPoor => 'Performa buruk';

  @override
  String get formCold => 'Beku';

  @override
  String get playerFormTitle => 'PERFORMA DAN KEBUGARAN';

  @override
  String playerFormAverage(String rating) {
    return 'Rata-rata $rating dalam laga-laga terakhirnya';
  }

  @override
  String get playerFormNoGames => 'Belum cukup laga terakhir untuk dinilai';

  @override
  String playerFormNextMatch(String delta) {
    return '$delta pada rating-nya di laga berikutnya';
  }

  @override
  String get playerFormNoEffect =>
      'Tidak ada perubahan pada rating-nya di laga berikutnya';

  @override
  String get sideGroupHome => 'Beranda';

  @override
  String get sideGroupTeam => 'Tim';

  @override
  String get sideGroupCompetitions => 'Kompetisi';

  @override
  String get sideGroupFederation => 'Federasi';

  @override
  String get sideGroupHistory => 'Sejarah';

  @override
  String get sideInbox => 'Kotak masuk';

  @override
  String get sideSquad => 'Skuad';

  @override
  String get sideTactics => 'Taktik';

  @override
  String get sideMainMenu => 'Menu utama';

  @override
  String get sideCallUps => 'Pemanggilan';

  @override
  String get sideTournaments => 'Turnamen';

  @override
  String get sideRanking => 'Peringkat';

  @override
  String get sideResults => 'Hasil';

  @override
  String get sideFinances => 'Keuangan';

  @override
  String get sideBoard => 'Dewan';

  @override
  String get sideManager => 'Pelatih & staf';

  @override
  String get sideRecords => 'Rekor';

  @override
  String get sideLegends => 'Legenda';

  @override
  String get sideHeadToHead => 'Rekor pertemuan';

  @override
  String get sideAchievements => 'Pencapaian';

  @override
  String get sideCareer => 'Karier';

  @override
  String get topBarNext => 'Berikutnya';

  @override
  String get topBarDrawPending => 'Undian menyusul';

  @override
  String get paneFullProfile => 'Profil lengkap';

  @override
  String get panePickPlayer => 'Pilih pemain untuk melihat kartunya di sini';

  @override
  String get inboxPickMessage => 'Pilih pesan untuk membacanya di sini';

  @override
  String get inboxFilterAll => 'Semua';

  @override
  String get panelViewAll => 'Lihat semua';

  @override
  String get gridViewOverview => 'Ikhtisar';

  @override
  String get gridColCondition => 'Kondisi';

  @override
  String get gridColStatus => 'Status';

  @override
  String get gridColRank => 'Peringkat';

  @override
  String get gridColMove => 'Naik/turun';

  @override
  String get gridColNation => 'Negara';

  @override
  String get gridColRegion => 'Wilayah';

  @override
  String get gridColPoints => 'Poin';

  @override
  String get panePickNation => 'Pilih negara untuk melihat rekornya di sini';

  @override
  String get resultsCyclesTitle => 'Siklus';

  @override
  String get tourDrawStart => 'Mulai undian';

  @override
  String get tourDrawViewGroups => 'Lihat grup';

  @override
  String get gridColCeiling => 'Batas atas';

  @override
  String get gridColYearGain => 'Kenaikan';

  @override
  String get gridColMarkedAt => 'Saat ditandai';

  @override
  String get budgetSetupTitle => 'Atur anggaran Anda';

  @override
  String get budgetEffectsTitle => 'Apa yang dibeli anggaran ini';

  @override
  String get naturalisationTitle => 'Naturalisasi';

  @override
  String get yTrending => 'Sedang tren';

  @override
  String get yVoices => 'Suara';

  @override
  String get yConversation => 'Percakapan';

  @override
  String get allTimeRecordsTitle => 'Rekor dunia sepanjang masa';

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
  String get gridColMotm => 'MOTM';

  @override
  String get gridColAvg => 'Rata2';

  @override
  String get gridColOpponent => 'Lawan';

  @override
  String get gridColStarts => 'Starter';

  @override
  String get gridColTournaments => 'Turnamen';

  @override
  String get gridColDate => 'Tanggal';

  @override
  String get gridColLastPlayed => 'Terakhir dimainkan';

  @override
  String get gridColManager => 'Pelatih';

  @override
  String nationsShownCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count negara',
    );
    return '$_temp0';
  }

  @override
  String get nationsSortedByRank => 'Diurutkan menurut peringkat dunia';

  @override
  String get nationsStrength => 'Kekuatan';

  @override
  String nationsStrengthOf(int tier) {
    return '$tier dari 5';
  }

  @override
  String get nationsSquadOverall => 'Rating skuad';

  @override
  String get nationsOpeningBudget => 'Anggaran awal';

  @override
  String get nationsStarPlayer => 'Pemain bintang';

  @override
  String nationsStarTile(String position, int rating) {
    return 'Bintang $position $rating';
  }

  @override
  String nationsStarAge(int age) {
    return 'Usia $age';
  }

  @override
  String get nationsBoardExpects => 'Dewan berharap';

  @override
  String nationsManage(String nation) {
    return 'Latih $nation';
  }

  @override
  String get nationsManagerNext => 'Anda menamai pelatih berikutnya';

  @override
  String get playerPageTitle => 'Pemain';

  @override
  String get nationPageTitle => 'Negara';

  @override
  String get friendliesYourGames => 'Laga uji coba Anda';

  @override
  String hubEventInjuryCover(String player) {
    return 'Gantikan $player yang cedera';
  }

  @override
  String hubEventInjuryCoverSub(int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: 'Absen di $matches laga',
      one: 'Absen di laga berikutnya',
    );
    return '$_temp0. Panggil pemain lain, atau lanjut tanpa pengganti.';
  }

  @override
  String get injuryCoverTitle => 'PENGGANTI';

  @override
  String injuryCoverBanner(String player) {
    return '$player cedera. Panggil siapa pun dari luar skuad, di posisi mana pun, atau pertahankan dia dan lanjutkan.';
  }

  @override
  String injuryCoverConfirm(String player) {
    return 'Panggil $player';
  }

  @override
  String injuryCoverKeep(String player) {
    return 'Pertahankan $player dan lanjutkan';
  }

  @override
  String get injuryCoverPick => 'Pilih pengganti';

  @override
  String get injuryCoverNone =>
      'Tidak ada pemain di luar skuad yang bugar untuk bergabung.';

  @override
  String get nationNowRanking => 'Peringkat dunia';

  @override
  String get nationNowForm => 'Performa';

  @override
  String get nationNowNoForm => 'Belum ada laga dimainkan';

  @override
  String get nationNowNext => 'Laga berikutnya';

  @override
  String get nationNowNoNext => 'Tidak ada jadwal';

  @override
  String get nationNowSquad => 'Skuad';

  @override
  String get nationNowAgainstYou => 'Melawan Anda';

  @override
  String nationNowRecord(int w, int d, int l) {
    return '${w}M ${d}S ${l}K';
  }

  @override
  String get nationNowLastMeeting => 'Pertemuan terakhir';

  @override
  String nationNowOverall(int value) {
    return 'Rating $value';
  }

  @override
  String get hubUpcoming => 'AKAN DATANG';

  @override
  String get hubFullSchedule => 'Jadwal lengkap';

  @override
  String get scheduleTitle => 'Jadwal';

  @override
  String get scheduleToday => 'Hari ini';

  @override
  String get scheduleKnockoutPending => 'Babak gugur, jika Anda lolos';

  @override
  String get scheduleNextRoundPending => 'Babak berikutnya';

  @override
  String scheduleFromDate(String date) {
    return 'Mulai $date';
  }

  @override
  String get scheduleHomeShort => 'K';

  @override
  String get scheduleAwayShort => 'T';

  @override
  String get tacticsNoPresetsInMatch =>
      'Belum ada taktik tersimpan. Simpan satu dari layar Taktik sebelum laga.';

  @override
  String get homeCampaigns => 'Kampanye';

  @override
  String get homeContinueCampaign => 'LANJUTKAN KAMPANYE';

  @override
  String homeCampaignCycle(String date, int cycle, int total) {
    return '$date · Siklus $cycle dari $total';
  }

  @override
  String get campaignsTitle => 'Kampanye';

  @override
  String get campaignTransplantTitle => 'Si Cangkokan';

  @override
  String get campaignTransplantTwist =>
      'Delapan pemain terbaik Italia berpindah kewarganegaraan ke San Marino';

  @override
  String get campaignTransplantGoal => 'Lolos ke Kejuaraan Eropa';

  @override
  String get campaignGrudgeTitle => 'Dendam';

  @override
  String get campaignGrudgeTwist => 'Georgia dan Albania, diundi bersama';

  @override
  String get campaignGrudgeGoal => 'Finis di atas Albania dalam kualifikasi';

  @override
  String get campaignTransplantIntro =>
      'San Marino belum pernah punya kampanye kualifikasi yang layak disebut. Lalu delapan pemain terbaik Italia mengambil paspornya dan masuk begitu saja. Anda punya satu siklus untuk mengubah sebuah keanehan menjadi sebuah tim.';

  @override
  String get campaignGrudgeIntro =>
      'Georgia dan Albania diundi ke grup kualifikasi yang sama, dan tak satu pun akan memaafkan kekalahan. Finis di atas Albania, lalu lihat sejauh mana Anda bisa membawanya.';

  @override
  String get campaignStars1Transplant => 'Lolos';

  @override
  String get campaignStars2Transplant => 'Capai babak gugur';

  @override
  String get campaignStars3Transplant => 'Juara Kejuaraan Eropa';

  @override
  String get campaignStars1Grudge => 'Di atas Albania';

  @override
  String get campaignStars2Grudge => 'Dan lolos';

  @override
  String get campaignStars3Grudge => 'Dan kalahkan mereka dua kali';

  @override
  String get campaignFree => 'Gratis';

  @override
  String get campaignStart => 'Mulai';

  @override
  String get campaignPartOfUnlimited => 'Bagian dari Unlimited';

  @override
  String get campaignResume => 'Lanjutkan';

  @override
  String get campaignAbandon => 'Tinggalkan';

  @override
  String get campaignAbandonConfirm =>
      'Tinggalkan percobaan ini? Kemajuannya hilang; stempel Anda tetap ada.';

  @override
  String get campaignMoveToSaves => 'Pindah ke simpanan';

  @override
  String get campaignCannotContinue =>
      'Dunia kampanye ini terlalu jauh dari dunia nyata untuk dilanjutkan sebagai karier.';

  @override
  String get campaignMoveSlotsFull =>
      'Slot simpanan Anda penuh. Kosongkan satu dulu.';

  @override
  String get campaignStampConquered => 'Ditaklukkan';

  @override
  String get campaignStampFailed => 'Gagal';

  @override
  String get campaignDifficultyHard => 'Sulit';

  @override
  String get campaignDifficultyMedium => 'Sedang';

  @override
  String get campaignGoalLabel => 'Tujuan';

  @override
  String get campaignStarsLabel => 'Bintang';

  @override
  String get campaignRunInProgress =>
      'Kampanye ini sudah punya percobaan yang sedang berjalan.';

  @override
  String get campaignVerdictWon => 'Ditaklukkan';

  @override
  String get campaignVerdictLost => 'Belum kali ini';

  @override
  String get campaignVerdictContinue => 'Lanjutkan';

  @override
  String campaignProgressQualifying(String position) {
    return 'Kualifikasi: $position';
  }

  @override
  String campaignProgressRival(String rival, String position) {
    return '$rival: $position';
  }

  @override
  String campaignProgressFinals(String stage) {
    return 'Putaran final: $stage';
  }

  @override
  String get campaignRunInNumbers => 'Perjalanan dalam angka';

  @override
  String campaignRunMeetings(int won, int played) {
    return 'Pertemuan dimenangi: $won dari $played';
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
      'Guinea Khatulistiwa, Guinea Afrika dengan peringkat terendah, selama dua siklus';

  @override
  String get campaignGuineasGoal => 'Kalahkan Guinea dan Guinea-Bissau';

  @override
  String get campaignGuineasIntro =>
      'Tiga negara Afrika menyandang nama Guinea, dan Guinea Khatulistiwa berada di peringkat terendah di antara mereka. Anda punya dua siklus untuk mengalahkan Guinea dan Guinea-Bissau masing-masing setidaknya sekali, lalu lihat sejauh mana Anda melaju di Kejuaraan Afrika. Papua Nugini, Guinea keempat, sudah dijadwalkan untuk laga persahabatan.';

  @override
  String get campaignStars1Guineas => 'Kalahkan Guinea dan Guinea-Bissau';

  @override
  String get campaignStars2Guineas => 'Dan lolos ke sebuah Kejuaraan Afrika';

  @override
  String get campaignStars3Guineas =>
      'Dan capai perempat final sebuah Kejuaraan Afrika';

  @override
  String get campaignYoungFinnsTitle => 'Finlandia Muda';

  @override
  String get campaignYoungFinnsTwist =>
      'Generasi emas remaja Finlandia, selama tiga siklus';

  @override
  String get campaignYoungFinnsGoal => 'Lolos ke sebuah Kejuaraan Dunia';

  @override
  String get campaignYoungFinnsIntro =>
      'Para pemain senior Finlandia telah mundur dan sebuah generasi emas menggantikan mereka: setiap pemain yang bisa Anda panggil berusia 18 tahun atau lebih muda. Hari ini mereka masih mentah, tetapi mereka punya bakat untuk menjadi salah satu tim terbaik di dunia, seperti yang dilakukan generasi muda Norwegia. Anda punya tiga siklus untuk membawa mereka ke Kejuaraan Dunia, lalu menjuarai Kejuaraan Eropa dan Kejuaraan Dunia.';

  @override
  String get campaignStars1YoungFinns => 'Lolos ke sebuah Kejuaraan Dunia';

  @override
  String get campaignStars2YoungFinns => 'Juara Kejuaraan Eropa';

  @override
  String get campaignStars3YoungFinns => 'Juara Kejuaraan Dunia';

  @override
  String get campaignPro => 'Pro';

  @override
  String campaignProgressCup(String cup, String year, String status) {
    return '$cup $year: $status';
  }

  @override
  String get campaignCupNotQualified => 'Tidak lolos';

  @override
  String get campaignCupOpen => 'Belum ditentukan';
}
