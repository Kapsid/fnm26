// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get matchPreviewTitle => 'MAÇ ÖNİZLEMESİ';

  @override
  String get matchKickOff => 'Başlat';

  @override
  String get matchTactics => 'Taktik';

  @override
  String get matchYourXi => 'İLK 11\'İN';

  @override
  String get matchHeadToHead => 'KARŞILIKLI GEÇMİŞ';

  @override
  String matchCouldNotLoad(String error) {
    return 'Maç yüklenemedi.\n$error';
  }

  @override
  String get matchNoUpcoming => 'Yaklaşan maç yok.';

  @override
  String get matchUnknownNation => 'Bilinmiyor';

  @override
  String get matchH2hFirstMeeting => 'İlk karşılaşma';

  @override
  String get matchH2hYouLead => 'Karşılıklı geçmişte öndesin';

  @override
  String matchH2hOppEdge(String opponent) {
    return 'Üstünlük: $opponent';
  }

  @override
  String get matchH2hEven => 'Denk geçmiş';

  @override
  String matchH2hMet(int count) {
    return '$count maç';
  }

  @override
  String get matchH2hWon => 'Galibiyet';

  @override
  String get matchH2hDrawn => 'Beraberlik';

  @override
  String get matchH2hLost => 'Mağlubiyet';

  @override
  String get matchDossierTitle => 'Gözlemci raporu';

  @override
  String get matchDossierForm => 'FORM';

  @override
  String get matchDossierNoGames => 'Yakın zamanda maç yok';

  @override
  String get matchDossierKeyMen => 'KİLİT OYUNCULAR';

  @override
  String get matchDossierHowTheyPlay => 'OYUN TARZI';

  @override
  String matchScoutFormation1(String formation) {
    return 'Genellikle $formation dizilişiyle sahaya çıkıyorlar.';
  }

  @override
  String matchScoutFormation2(String formation) {
    return 'Alışılmış dizilişleri $formation.';
  }

  @override
  String matchScoutFormation3(String formation) {
    return 'Çoğunlukla $formation ile oynamayı tercih ediyorlar.';
  }

  @override
  String get matchScoutStrengthPressing =>
      'Önde baskı yapıp topun peşine düşüyorlar.';

  @override
  String get matchScoutStrengthDirect =>
      'Direkt oynuyor, topu erkenden ileri taşıyorlar.';

  @override
  String get matchScoutStrengthPossession =>
      'Topu iyi saklıyor ve sabırla oyun kuruyorlar.';

  @override
  String get matchScoutStrengthCounter =>
      'Geride bekleyip hızlı kontra ataklara çıkıyorlar.';

  @override
  String get matchScoutStrengthDeepDefence =>
      'Derinde savunuyorlar ve onları açmak zor.';

  @override
  String get matchScoutStrengthWide =>
      'Sahayı genişletip kanatlardan hücum ediyorlar.';

  @override
  String get matchScoutStrengthAttacking =>
      'Oyunun kontrolünü alıp rakibin üstüne gitmeyi seviyorlar.';

  @override
  String get matchScoutStrengthQuickForwards =>
      'Forvetleri hızlı ve savunma arkasına koşmayı seviyorlar.';

  @override
  String get matchScoutStrengthPassingMidfield =>
      'Orta sahaları pasta çok iyi.';

  @override
  String get matchScoutStrengthHardRunning =>
      'Orta sahaları maç boyu koşacak güçte.';

  @override
  String get matchScoutStrengthSetPieces => 'Duran toplarda tehlikeliler.';

  @override
  String get matchScoutStrengthQuickDefence =>
      'Savunma hatları hızlı, arkalarına sarkmak zor.';

  @override
  String get matchScoutStrengthNone => 'Oyunlarında öne çıkan bir şey yok.';

  @override
  String get matchScoutWeakSpaceBehind =>
      'Önde kurdukları savunma hattı, arkaya atılacak uzun toplara alan bırakıyor.';

  @override
  String get matchScoutWeakPressedBuildUp =>
      'Önde baskı, yavaş oyun kurulumlarını bozabilir.';

  @override
  String get matchScoutWeakDeepBlock =>
      'Sabırlı ol: onlarınki gibi derin bir blok açılabilir.';

  @override
  String get matchScoutWeakLongBall =>
      'Savunma hattını geri çek, uzun toplarının gidecek yeri kalmasın.';

  @override
  String get matchScoutWeakSlowDefence =>
      'Defans oyuncuları yavaş, arkalarına koşu yapacak oyuncular gönder.';

  @override
  String get matchScoutWeakAerial =>
      'Duran top savunmasında tedirgin görünüyorlar.';

  @override
  String get matchScoutWeakPoorPassing =>
      'Orta sahaları baskı altında pasla çıkmakta zorlanıyor.';

  @override
  String get matchScoutWeakTiringMidfield =>
      'Orta sahalarının baskıyı sürdürecek gücü yok.';

  @override
  String get matchScoutWeakBluntAttack => 'Forvetleri yavaş.';

  @override
  String get matchScoutApproachTakeTheGame =>
      'Sana karşı oyunun kontrolünü almalarını bekle.';

  @override
  String get matchScoutApproachEven =>
      'Sana karşı dengeli ve çekişmeli bir maç bekle.';

  @override
  String get matchScoutApproachSitDeep =>
      'Sana karşı temkinli oynayıp kontra fırsatı kollamalarını bekle.';

  @override
  String get matchScoutLeaningAttacking =>
      'Uzaktan bakınca hücumcu bir takıma benziyorlar.';

  @override
  String get matchScoutLeaningCautious =>
      'Uzaktan bakınca temkinli bir takıma benziyorlar.';

  @override
  String get matchScoutLeaningUnclear =>
      'Uzaktan bakınca nasıl oynamayı sevdiklerini söylemek zor.';

  @override
  String get matchScoutHireHint =>
      'Nasıl oynadıklarını öğrenmek için bir başgözlemci tut.';

  @override
  String matchCouldNotContinue(String error) {
    return 'Devam edilemedi: $error';
  }

  @override
  String get matchSkipToFullTime => 'Maç sonuna atla';

  @override
  String get matchStatShots => 'Şutlar';

  @override
  String get matchStatGoals => 'Goller';

  @override
  String get matchStatYellowCards => 'Sarı kart';

  @override
  String get matchStatRedCards => 'Kırmızı kart';

  @override
  String get matchMomentum => 'İVME';

  @override
  String get matchSwingAtk => 'HÜC';

  @override
  String get matchSwingDef => 'SAV';

  @override
  String ceremonyWorldCupYear(int year) {
    return 'DÜNYA ŞAMPİYONASI $year';
  }

  @override
  String get ceremonyFinalsAreHere => 'FİNAL TURNUVASI BAŞLIYOR';

  @override
  String ceremonyHostedBy(String hosts) {
    return 'EV SAHİBİ:  $hosts';
  }

  @override
  String get ceremonyHostTbc => 'EV SAHİBİ BELLİ DEĞİL';

  @override
  String get matchHalfTime => 'DEVRE ARASI';

  @override
  String get matchContinue => 'Devam';

  @override
  String get matchContinuing => 'Devam ediliyor…';

  @override
  String matchTacticsWithSubs(int used, int max) {
    return 'Taktik · $used/$max değişiklik';
  }

  @override
  String matchTiredCount(int count) {
    return 'YORGUN ×$count';
  }

  @override
  String get matchTacticsLabel => 'TAKTİK';

  @override
  String get teamOverallOverTime => 'YILLARA GÖRE GENEL GÜÇ';

  @override
  String get teamOverall => 'Genel';

  @override
  String get teamTalkHeading => 'TAKIM KONUŞMASI';

  @override
  String get teamTalkPrompt => 'İkinci yarının havasını belirle.';

  @override
  String get teamTalkCalmLabel => 'Sakin kalın';

  @override
  String get teamTalkCalmBlurb =>
      'Takımı toparla. Küçük bir genel moral artışı.';

  @override
  String get teamTalkEncourageLabel => 'Cesaretlendir';

  @override
  String get teamTalkEncourageBlurb => 'İleri çık, oyunu kur.';

  @override
  String get teamTalkDemandMoreLabel => 'Daha fazlasını iste';

  @override
  String get teamTalkDemandMoreBlurb => 'Her şeyini ortaya koy. Sert hücum et.';

  @override
  String get teamTalkPraiseLabel => 'Sıkı kalın';

  @override
  String get teamTalkPraiseBlurb => 'Kompakt dur, elindekini koru.';

  @override
  String get teamTalkBelieveLabel => 'İnan';

  @override
  String get teamTalkBelieveBlurb =>
      'Kendinize güvenin. Sahanın iki ucunda da bir ivme.';

  @override
  String get teamTalkFocusLabel => 'Dikkatli kalın';

  @override
  String get teamTalkFocusBlurb => 'Tam konsantrasyon. Oyunu kilitle.';

  @override
  String get teamTalkUrgencyLabel => 'Aciliyet hissi';

  @override
  String get teamTalkUrgencyBlurb =>
      'Hemen üstüne git. Tam gaz, ama arkada boşluk bırakır.';

  @override
  String get teamTalkReassureLabel => 'Baskı yok';

  @override
  String get teamTalkReassureBlurb => 'Sinirleri yatıştır, dizilişi koru.';

  @override
  String get commonRetry => 'Tekrar dene';

  @override
  String get commonSomethingWentWrong => 'Bir şeyler ters gitti';

  @override
  String get commonCrashBox =>
      'Burada bir şeyler ters gitti.\nAyarlar → Tanılama\'da ayrıntılar var.';

  @override
  String hubCouldNotAdvance(String error) {
    return 'Dünya ilerletilemedi: $error';
  }

  @override
  String get settingsDiagnosticsTitle => 'Tanılama';

  @override
  String get settingsDiagnosticsBlurb =>
      'Bu cihazda kaydedilen hatalar. Hiçbir yere gönderilmez.';

  @override
  String get settingsContactTitle => 'İletişim';

  @override
  String get settingsContactCopied => 'Adres kopyalandı.';

  @override
  String get settingsCommunityTitle => 'Topluluk';

  @override
  String get settingsDiscordSubtitle => 'Topluluğa katıl';

  @override
  String get settingsLinkCopied => 'Bağlantı kopyalandı.';

  @override
  String get diagnosticsEmpty => 'Kayıtlı hata yok. Amaç da bu zaten.';

  @override
  String get diagnosticsCopy => 'Kopyala';

  @override
  String get diagnosticsCopied => 'Kayıt panoya kopyalandı.';

  @override
  String get diagnosticsClear => 'Temizle';

  @override
  String get navHub => 'Merkez';

  @override
  String get navSquad => 'Kadro';

  @override
  String get navStandings => 'Puan durumu';

  @override
  String get navCareers => 'Kariyerim';

  @override
  String get settingsTitle => 'AYARLAR';

  @override
  String get settingsSoundHapticsTitle => 'Ses ve titreşim';

  @override
  String get settingsSoundHapticsBlurb =>
      'Gollerde, başlama vuruşunda ve maç sonunda titreşim ve kısa bir ses.';

  @override
  String get settingsLanguageTitle => 'Dil';

  @override
  String get settingsLanguageBlurb =>
      'Uygulama dilini seç ya da cihazını takip et.';

  @override
  String get settingsLanguageSystem => 'Sistem';

  @override
  String get settingsTextSizeTitle => 'Metin boyutu';

  @override
  String get settingsTextSizeBlurb => 'Okumakta zorlanıyorsanız metni büyütün.';

  @override
  String get settingsTextSizeNormal => 'Normal';

  @override
  String get settingsTextSizeLarge => 'Büyük';

  @override
  String get settingsTextSizeLarger => 'Daha büyük';

  @override
  String get matchPreviewAllMeetings => 'Tüm karşılaşmalar';

  @override
  String get recordsMeetings => 'KARŞILAŞMALAR';

  @override
  String get recordsLegends => 'EFSANELER';

  @override
  String get recordsAllTimeXi => 'TÜM ZAMANLARIN İLK 11\'İ';

  @override
  String get recordsHallOfFame => 'ŞÖHRETLER SALONU';

  @override
  String get recordsAllTimeWorld => 'TÜM ZAMANLAR DÜNYA';

  @override
  String get recordsAllTimeTopScorers => 'TÜM ZAMANLARIN GOL KRALLARI';

  @override
  String get recordsMostCapped => 'EN ÇOK MİLLİ MAÇ';

  @override
  String get recordsMostWcStarts => 'EN ÇOK DÜNYA ŞAMPİYONASI MAÇI';

  @override
  String get recordsMostTournaments => 'EN ÇOK TURNUVAYA KATILAN';

  @override
  String get recordsRecordBook => 'REKORLAR KİTABI';

  @override
  String get recordsHeadToHead => 'KARŞILIKLI GEÇMİŞ';

  @override
  String get recordsFiercestRival => 'EN SERT RAKİP';

  @override
  String get recordsMostCaps => 'EN ÇOK MİLLİ MAÇ';

  @override
  String get recordsTopScorers => 'GOL KRALLARI';

  @override
  String get recordsMostAssists => 'EN ÇOK ASİST';

  @override
  String get recordsYourRecord => 'REKORUN';

  @override
  String get callUpHome => 'İÇ SAHA';

  @override
  String get callUpAway => 'DEPLASMAN';

  @override
  String get recordsHome => 'EV SAHİBİ';

  @override
  String get recordsAway => 'DEPLASMAN';

  @override
  String get recordsActive => 'AKTİF';

  @override
  String get recordsStillActive => 'Hâlâ oynuyor';

  @override
  String get recordsAvg => 'ort.';

  @override
  String get recordsSelect => 'Seç';

  @override
  String get recordsVs => 'vs';

  @override
  String get recordsDraws => 'Beraberlik';

  @override
  String get recordsGoalsLabel => 'Goller';

  @override
  String get recordsBestFinish => 'En iyi derece';

  @override
  String get recordsNoFinalsYet => 'Henüz final turnuvası yok';

  @override
  String get recordsLongestUnbeaten => 'En uzun yenilgisizlik';

  @override
  String get recordsBiggestWin => 'En büyük galibiyet';

  @override
  String get recordsSeeAllMeetings => 'Tüm karşılaşmaları gör';

  @override
  String get recordsSaveNotFound => 'Kayıt bulunamadı.';

  @override
  String get recordsNoMatches => 'Eşleşme yok.';

  @override
  String get recordsSearchPlayerOrNation => 'Oyuncu ya da ülke ara';

  @override
  String get recordsSearchNation => 'Ülke ara';

  @override
  String get recordsPickTwoDifferent => 'İki farklı ülke seç.';

  @override
  String get recordsPlayToBuildRecord =>
      'Biraz maç oyna; her rakibe karşı rekorun burada oluşacak.';

  @override
  String get recordsTapOpponent => 'Tüm ayrıntılar için bir rakibe dokun.';

  @override
  String get recordsEdgeUpperHand => 'Üstünlük sende';

  @override
  String get recordsEdgeTheirNumber => 'Seni çözmüşler';

  @override
  String get recordsEdgeEven => 'Denk geçmiş';

  @override
  String get recordsAllTimeWorldSubtitle =>
      'Tüm ülkelerin gol krallığı ve milli maç rekorları';

  @override
  String get recordsHeadToHeadSubtitle =>
      'İki ülkenin tüm zamanlardaki rekorunu karşılaştır';

  @override
  String get recordsLegendsSubtitle =>
      'Tüm zamanların ilk 11\'i ve şöhretler salonu';

  @override
  String get recordsUnitGoals => 'gol';

  @override
  String get recordsUnitCaps => 'milli maç';

  @override
  String get recordsUnitStarts => 'ilk 11';

  @override
  String get recordsUnitCups => 'turnuva';

  @override
  String get recordsUnitAssists => 'asist';

  @override
  String recordsCapsCount(int count) {
    return '$count milli maç';
  }

  @override
  String recordsGoalsCount(int count) {
    return '$count gol';
  }

  @override
  String recordsAssistsCount(int count) {
    return '$count asist';
  }

  @override
  String recordsMotmCount(int count) {
    return '$count MA';
  }

  @override
  String recordsMatchesCount(int count) {
    return '$count maç';
  }

  @override
  String recordsMeetingsCount(int count) {
    return '$count karşılaşma';
  }

  @override
  String recordsCodeWins(String code) {
    return '$code galibiyetleri';
  }

  @override
  String recordsMeetingsWdl(int meetings, int wins, int draws, int losses) {
    return '$meetings maç · ${wins}G ${draws}B ${losses}M';
  }

  @override
  String recordsWdl(int wins, int draws, int losses) {
    return '${wins}G ${draws}B ${losses}M';
  }

  @override
  String recordsRivalLine(int meetings, String record, String edge) {
    return '$meetings maç · $record · $edge';
  }

  @override
  String recordsNeverMet(String a, String b) {
    return '$a ile $b bu kayıtta hiç karşılaşmadı.';
  }

  @override
  String tacticsSentOffNote(String names) {
    return '$names oyundan atıldı. Yerine oyuncu giremez, bir eksik oynuyorsun.';
  }

  @override
  String tacticsNeedFitPlayers(int required, int have) {
    return '$required sağlam oyuncu gerek ($have sağlam)';
  }

  @override
  String tacticsMissesOfCamp(int missed, int total) {
    return 'Kaçırır: $missed/$total';
  }

  @override
  String get tacticsOutForWholeCamp => 'Bu davetin tamamında yok';

  @override
  String get rankingCentreOnMe => 'Ülkeme git';

  @override
  String get recordsAfterExtraTime => 'uzatma';

  @override
  String recordsOnPenalties(int a, int b) {
    return '$a–$b pen.';
  }

  @override
  String recordsVersus(String a, String b) {
    return '$a vs $b';
  }

  @override
  String recordsPlayedScore(int played, int gf, int ga) {
    return '$played maç · $gf–$ga';
  }

  @override
  String recordsBiggestWinValue(int gf, int ga, String opp) {
    return '$gf–$ga vs $opp';
  }

  @override
  String recordsCouldNotLoad(String error) {
    return 'Yüklenemedi.\n$error';
  }

  @override
  String recordsCouldNotLoadLegends(String error) {
    return 'Efsaneler yüklenemedi.\n$error';
  }

  @override
  String recordsCouldNotLoadRecords(String error) {
    return 'Rekorlar yüklenemedi.\n$error';
  }

  @override
  String recordsCouldNotLoadNations(String error) {
    return 'Ülkeler yüklenemedi.\n$error';
  }

  @override
  String recordsCouldNotLoadYourRecord(String error) {
    return 'Rekorun yüklenemedi.\n$error';
  }

  @override
  String recordsCouldNotLoadRecord(String error) {
    return 'Rekor yüklenemedi.\n$error';
  }

  @override
  String recordsNoLegends(String nation) {
    return 'Henüz efsane yok. Birkaç kampanya oyna, $nation için büyük isimler burada ortaya çıkacak.';
  }

  @override
  String recordsGreatestSide(String nation) {
    return '$nation için kurulabilecek en güçlü takım.';
  }

  @override
  String get recordsNoWorldHistory =>
      'Dünyanın henüz bir geçmişi yok. Birkaç kampanya oyna, tüm zamanların büyükleri burada görünecek.';

  @override
  String recordsPlayToWriteHistory(String nation) {
    return '$nation tarihini yazmaya başlamak için birkaç maç oyna.';
  }

  @override
  String get tacticsLineGk => 'KL';

  @override
  String get tacticsLineDef => 'DEF';

  @override
  String get tacticsLineMid => 'OS';

  @override
  String get tacticsLineFwd => 'FRV';

  @override
  String get tacticsGoalkeepers => 'KALECİLER';

  @override
  String get tacticsDefenders => 'DEFANSLAR';

  @override
  String get tacticsMidfielders => 'ORTA SAHALAR';

  @override
  String get tacticsForwards => 'FORVETLER';

  @override
  String get tacticsCallUpsTitle => 'MİLLİ TAKIM DAVETİ';

  @override
  String tacticsPickAtLeastPlayers(int min) {
    return 'En az $min oyuncu seç.';
  }

  @override
  String tacticsCouldNotLoadSquad(String error) {
    return 'Kadro yüklenemedi.\n$error';
  }

  @override
  String get tacticsNoSquad => 'Kadro yok.';

  @override
  String tacticsSquadCount(int count, int max) {
    return 'KADRO · $count/$max';
  }

  @override
  String tacticsMinMax(int min, int max) {
    return 'En az $min · En çok $max';
  }

  @override
  String get tacticsBestQuality => 'En iyi kalite';

  @override
  String get tacticsPreviousSquad => 'Önceki kadro';

  @override
  String get tacticsSquadLockedBack => 'Geri (kadro kilitli)';

  @override
  String get tacticsConfirmSquad => 'Kadroyu onayla';

  @override
  String tacticsSquadFullMax(int max) {
    return 'Kadro dolu (en çok $max)';
  }

  @override
  String get tacticsSquadLocked => 'KADRO KİLİTLİ';

  @override
  String get tacticsNominationOpen => 'KADRO BİLDİRİMİ AÇIK. KADRONU SEÇ';

  @override
  String get tacticsSquadFixedBlurb =>
      'Bu kadro aşağıdaki maçlar için sabit. Sonraki bildirim penceresinden önce yeniden seç.';

  @override
  String get tacticsSquadWillPlayBlurb =>
      'Bu kadro aşağıdaki maçları oynayacak.';

  @override
  String get tacticsUnknown => 'Bilinmiyor';

  @override
  String tacticsAgeValue(int age, String value) {
    return 'Yaş $age · $value';
  }

  @override
  String get tacticsFatigueExhausted => 'Bitkin';

  @override
  String get tacticsFatigueTired => 'Yorgun';

  @override
  String get tacticsFatigueMatchLegs => 'Maç yorgunluğu';

  @override
  String tacticsTooManySubs(int max) {
    return 'Çok fazla oyuncu değişikliği (en çok $max).';
  }

  @override
  String tacticsMinuteTitle(int minute) {
    return 'TAKTİK · $minute\'';
  }

  @override
  String get tacticsApply => 'UYGULA';

  @override
  String get tacticsTabLineupSubs => 'DİZİLİŞ VE YEDEKLER';

  @override
  String get tacticsTabTactics => 'TAKTİK';

  @override
  String get squadLineKeepers => 'KALECİLER';

  @override
  String get squadLineDefenders => 'SAVUNMA';

  @override
  String get squadLineMidfielders => 'ORTA SAHA';

  @override
  String get squadLineForwards => 'HÜCUM';

  @override
  String get squadStatXiRating => 'İlk 11 gücü';

  @override
  String get squadStatAvgAge => 'Ort. yaş';

  @override
  String get squadStatSize => 'Kadro';

  @override
  String get squadStatUnavailable => 'Yok';

  @override
  String get squadDepthTitle => 'HATLARA GÖRE DERİNLİK';

  @override
  String squadAgeShort(int age) {
    return '$age y';
  }

  @override
  String get tacticsTabOtherPositions => 'DİĞER MEVKİLER';

  @override
  String get tacticsOutOfPositionNote => 'Burada mevkii dışında';

  @override
  String get tacticsNobodyElse => 'Denenecek kimse kalmadı.';

  @override
  String get tacticsPickSomebodyFirst =>
      'Kimin çıkacağını seç; yedeklerin kalanı burada, bu mevkide alacakları puanla görünür.';

  @override
  String get tacticsTabSuitable => 'UYGUN';

  @override
  String get tacticsTabOnPitch => 'SAHADA';

  @override
  String tacticsSectionSuitable(int count) {
    return 'UYGUN · $count';
  }

  @override
  String get tacticsNobodySuits =>
      'Yedeklerde bu mevkie doğal olarak uyan kimse yok, o yüzden herkes burada.';

  @override
  String tacticsSectionOnPitch(int count, int max) {
    return 'SAHADA · $count/$max';
  }

  @override
  String tacticsSectionAvailable(int count) {
    return 'MÜSAİT · $count';
  }

  @override
  String get tacticsRowStarted => 'İlk 11';

  @override
  String tacticsRowCameOn(int minute) {
    return 'Girdi: $minute\'';
  }

  @override
  String get tacticsRowSubstitute => 'Sonradan girdi';

  @override
  String get tacticsEnergyLabel => 'ENERJİ';

  @override
  String tacticsPickReplacementFor(String name) {
    return '$name yerine bir oyuncu seç, vazgeçmek için ona tekrar dokun.';
  }

  @override
  String get tacticsSlotLostToRedCard =>
      'Kırmızı kart bu mevkiyi senden aldı. Boşluğu kaydırmak için bir takım arkadaşını buraya sürükle.';

  @override
  String get tacticsSentOffShort => 'ATILDI';

  @override
  String get tacticsFullBackLeft => 'Sol bek';

  @override
  String get tacticsFullBackRight => 'Sağ bek';

  @override
  String get tacticsFullBackUp => 'Hücuma çık';

  @override
  String get tacticsFullBackDown => 'Geride kal';

  @override
  String get tacticsFullBackOff => 'Talimat yok';

  @override
  String tacticsFullBackUpHint(String side) {
    return '$side: hücuma çık. Biraz daha fazla hücum, biraz daha fazla risk.';
  }

  @override
  String tacticsFullBackDownHint(String side) {
    return '$side: geride kal. Biraz daha güvenli, biraz daha az hücum.';
  }

  @override
  String tacticsFullBackOffHint(String side) {
    return '$side: talimat yok, takım planına göre oynar.';
  }

  @override
  String tacticsFullBackSemantics(String side, String state) {
    return '$side, ok: $state';
  }

  @override
  String tacticsSubsUsed(int used, int max) {
    return 'DEĞİŞİKLİK · $used/$max';
  }

  @override
  String get tacticsDragSubOn =>
      'Çıkarmak için sahadaki bir oyuncuya dokun ya da basılı tutup bir yedeği üstüne sürükle.';

  @override
  String get tacticsNoSubs => 'Yedek oyuncu yok.';

  @override
  String get tacticsChooseShape => 'DİZİLİŞ SEÇ';

  @override
  String get tacticsFormation => 'DİZİLİŞ';

  @override
  String get tacticsInstructions => 'TALİMATLAR';

  @override
  String get tacticsDrilling => 'ÇALIŞILMIŞLIK';

  @override
  String get tacticsDrillingUnplayed => 'OYNANMADI';

  @override
  String get tacticsDrillingNew => 'YENİ';

  @override
  String get tacticsDrillingSettling => 'OTURUYOR';

  @override
  String get tacticsDrillingDrilled => 'OTURDU';

  @override
  String get tacticsInstrMentality => 'Mentalite';

  @override
  String get tacticsInstrDefensive => 'Defansif';

  @override
  String get tacticsInstrAttacking => 'Hücumcu';

  @override
  String get tacticsInstrPressing => 'Pres';

  @override
  String get tacticsInstrLowBlock => 'Düşük blok';

  @override
  String get tacticsInstrHighPress => 'Yüksek pres';

  @override
  String get tacticsInstrTempo => 'Tempo';

  @override
  String get tacticsInstrPatient => 'Sabırlı';

  @override
  String get tacticsInstrFast => 'Hızlı';

  @override
  String get tacticsInstrWidth => 'Genişlik';

  @override
  String get tacticsInstrNarrow => 'Dar';

  @override
  String get tacticsInstrWide => 'Geniş';

  @override
  String get tacticsInstrDefLine => 'Defans hattı';

  @override
  String get tacticsInstrDefensiveLine => 'Defans hattı';

  @override
  String get tacticsInstrDeep => 'Derin';

  @override
  String get tacticsInstrHigh => 'Yüksek';

  @override
  String get tacticsInstrDirectness => 'Dikeylik';

  @override
  String get tacticsInstrPossession => 'Top kontrolü';

  @override
  String get tacticsInstrDirect => 'Direkt';

  @override
  String get tacticsPickGoalkeeper => 'KALECİ SEÇ';

  @override
  String get tacticsPickLeftBack => 'SOL BEK SEÇ';

  @override
  String get tacticsPickCentreBack => 'STOPER SEÇ';

  @override
  String get tacticsPickRightBack => 'SAĞ BEK SEÇ';

  @override
  String get tacticsPickDefensiveMid => 'DEFANSİF ORTA SAHA SEÇ';

  @override
  String get tacticsPickCentralMid => 'MERKEZ ORTA SAHA SEÇ';

  @override
  String get tacticsPickAttackingMid => 'OFANSİF ORTA SAHA SEÇ';

  @override
  String get tacticsPickLeftMid => 'SOL ORTA SAHA SEÇ';

  @override
  String get tacticsPickRightMid => 'SAĞ ORTA SAHA SEÇ';

  @override
  String get tacticsPickLeftWing => 'SOL KANAT SEÇ';

  @override
  String get tacticsPickRightWing => 'SAĞ KANAT SEÇ';

  @override
  String get tacticsPickStriker => 'FORVET SEÇ';

  @override
  String tacticsRoleOutOfPosition(String role) {
    return '$role · mevkii dışında';
  }

  @override
  String tacticsAgeOnly(int age) {
    return 'Yaş $age';
  }

  @override
  String tacticsRoleAge(String role, int age) {
    return '$role · Yaş $age';
  }

  @override
  String get tacticsOn => 'SAHADA';

  @override
  String get tacticsSquad => 'KADRO';

  @override
  String get tacticsTabLineup => 'DİZİLİŞ';

  @override
  String get tacticsTabInstructions => 'TALİMATLAR';

  @override
  String get tacticsTabRoles => 'ROLLER';

  @override
  String get tacticsTabSetPieces => 'DURAN TOPLAR';

  @override
  String get tacticsTabRolesSetPieces => 'ROLLER VE DURAN TOPLAR';

  @override
  String get tacticsRolesSetPiecesBlurb =>
      'Her ilk 11 oyuncusuna bir rol ver. Atıcını belirlemek için penaltı (⚽) ya da serbest vuruş (▲) rozetine dokun.';

  @override
  String get tacticsTooltipCallUps => 'Milli takım daveti';

  @override
  String get tacticsTooltipPresets => 'Taktik ön ayarları';

  @override
  String get tacticsTooltipInstructions => 'Talimatlar';

  @override
  String get tacticsNoTacticSet => 'Taktik belirlenmedi.';

  @override
  String tacticsReplaceStarters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count İLK 11 OYUNCUSUNU DEĞİŞTİR',
      one: '$count İLK 11 OYUNCUSUNU DEĞİŞTİR',
    );
    return '$_temp0';
  }

  @override
  String tacticsPlayerOut(String name, String reason) {
    return '$name: $reason';
  }

  @override
  String get tacticsOut => 'Yok';

  @override
  String get tacticsTapSpotReplace =>
      'Yerine birini seçmek için sahadaki mevkisine dokun.';

  @override
  String get tacticsTapOrDrag =>
      'Bir oyuncuyu değiştirmek için dokun ya da taşımak için basılı tutup sürükle.';

  @override
  String get tacticsPlayerRoles => 'OYUNCU ROLLERİ';

  @override
  String get tacticsRolesBlurb =>
      'Oyuncuya bir görev ver: bir fırsatçı, bir oyun kurucu, bir pivot forvet. Kimin gol attığını ve kimin gol yarattığını belirler.';

  @override
  String get tacticsSetPieceTakers => 'DURAN TOP KULLANICILARI';

  @override
  String get tacticsSetPieceBlurb =>
      'Penaltıları ve duran topları kim kullanacak, ya da en uygun oyuncuya bırak.';

  @override
  String get tacticsTakerAuto => 'Otomatik';

  @override
  String get tacticsTakerQuickPick => 'En iyi atıcıları kullan';

  @override
  String get tacticsPenalties => 'Penaltılar';

  @override
  String get tacticsCornersFreeKicks => 'Kornerler ve serbest vuruşlar';

  @override
  String get tacticsSkillFin => 'BTR';

  @override
  String get tacticsSkillPas => 'PAS';

  @override
  String tacticsRolePlayer(String name) {
    return 'ROL · $name';
  }

  @override
  String get tacticsPenaltyTaker => 'PENALTI ATICISI';

  @override
  String get tacticsCornerFreeKickTaker => 'KORNER VE SERBEST VURUŞ ATICISI';

  @override
  String get tacticsAutomatic => 'Otomatik';

  @override
  String get tacticsLetBestSuited => 'En uygun oyuncu kullansın.';

  @override
  String get tacticsInXi => 'İLK 11\'DE';

  @override
  String get tacticsTeamInstructions => 'TAKIM TALİMATLARI';

  @override
  String get tacticsTeamInstructionsBlurb =>
      'Takımının nasıl oynayacağını belirle. Her kadran tüm takımı biraz yönlendirir.';

  @override
  String tacticsSavedPreset(String name) {
    return 'Kaydedildi: “$name”';
  }

  @override
  String tacticsAppliedPreset(String name) {
    return 'Uygulandı: “$name”';
  }

  @override
  String get tacticsTacticPresets => 'TAKTİK ÖN AYARLARI';

  @override
  String get tacticsPresetsBlurb =>
      'Bu dizilişi tekrar kullanılabilir bir tarz olarak kaydet ya da daha önce kaydettiğini uygula.';

  @override
  String get tacticsSaveCurrentTactic => 'Mevcut taktiği kaydet';

  @override
  String tacticsCouldNotLoadPresets(String error) {
    return 'Ön ayarlar yüklenemedi.\n$error';
  }

  @override
  String get tacticsNoPresetsYet =>
      'Henüz ön ayar yok. Bu düzeni tekrar kullanılabilir bir tarz olarak saklamak için “Mevcut taktiği kaydet”e dokun.';

  @override
  String get tacticsNameThisTactic => 'Taktiğe ad ver';

  @override
  String get tacticsNameHint => 'örn. Yüksek pres 4-3-3';

  @override
  String get tacticsCancel => 'İptal';

  @override
  String get tacticsSave => 'Kaydet';

  @override
  String get tacticsTapToAssign => 'Atamak için dokun';

  @override
  String get tacticsHoldDragSub =>
      'Bir yedeğe basılı tut, sonra oyuna sokmak için bir oyuncunun üstüne sürükle.';

  @override
  String get hubContinue => 'Devam';

  @override
  String get hubBrackets => 'Tablolar';

  @override
  String hubCouldNotLoad(String error) {
    return 'Yüklenemedi.\n$error';
  }

  @override
  String hubCouldNotLoadFinances(String error) {
    return 'Mali durum yüklenemedi.\n$error';
  }

  @override
  String hubCouldNotLoadSave(String error) {
    return 'Kayıt yüklenemedi.\n$error';
  }

  @override
  String get hubSaveNotFound => 'Kayıt bulunamadı.';

  @override
  String get hubUnknown => 'Bilinmiyor';

  @override
  String hubWorldChampionsYear(int year) {
    return '$year DÜNYA ŞAMPİYONLARI';
  }

  @override
  String get hubCycleComplete => 'Dönem tamamlandı.';

  @override
  String get hubYourJob => 'GÖREVİN';

  @override
  String get hubStayProject => 'Kal ve projene devam et';

  @override
  String get hubChooseNextJob => 'SIRADAKİ GÖREVİNİ SEÇ';

  @override
  String get hubOffersOnTable => 'MASADAKİ TEKLİFLER';

  @override
  String hubOfferSubtitle(String tier, int position) {
    return '$tier · dünya #$position';
  }

  @override
  String hubContinueWith(String nation) {
    return 'Devam et: $nation';
  }

  @override
  String get hubYourNation => 'ülken';

  @override
  String get hubTakeTheJob => 'Görevi kabul et';

  @override
  String get hubFederationFinances => 'FEDERASYON MALİYESİ';

  @override
  String get hubBudgetIntro =>
      'Gelecek dönemdeki ilk işin federasyon bütçesini belirleyip departmanlara dağıtmak.';

  @override
  String get hubStarting => 'Başlıyor…';

  @override
  String get hubBeginNextCycle => 'Sonraki dönemi başlat';

  @override
  String get hubContinueCareer => 'Kariyerine devam et';

  @override
  String get hubBackToSaves => 'Kayıtlarına dön';

  @override
  String get hubOpeningBalance => 'Açılış bakiyesi';

  @override
  String get hubCentralFunding => 'Merkezi fon';

  @override
  String get hubPrizeMoney => 'Ödül parası';

  @override
  String get hubCommercialReturn => 'Ticari gelir';

  @override
  String get hubAvailableToInvest => 'Yatırıma ayrılabilir';

  @override
  String hubReputation(String label, int rep) {
    return 'İtibar: $label ($rep)';
  }

  @override
  String get hubNationalHero => 'Ulusal kahraman';

  @override
  String get hubFinal => 'Final';

  @override
  String get hubStageRoundOf32 => 'Son 32 turu';

  @override
  String get hubStageThirdPlace => 'Üçüncülük maçı';

  @override
  String get hubEventAdvanceWorld => 'Dünyayı ilerlet';

  @override
  String hubEventStartCycle(int year) {
    return '$year dönemini başlat';
  }

  @override
  String hubEventWorldChampions(String nation) {
    return 'Dünya Şampiyonu: $nation';
  }

  @override
  String get hubEventSetBudget => 'Federasyon bütçeni belirle';

  @override
  String get hubEventSetBudgetSub =>
      'Sezon başlamadan bu dönemin kasasını dağıt';

  @override
  String get hubEventNaturalization => 'Vatandaşlık teklifini incele';

  @override
  String get hubEventNaturalizationSub =>
      'Yabancı bir oyuncu sana geçmek istiyor';

  @override
  String get hubEventCampaignVerdict => 'Kampanya sona erdi: kararı gör';

  @override
  String get hubEventCampaignComplete => 'Kampanya tamamlandı';

  @override
  String get hubEventIntercontinentalPlayoff => 'Kıtalar arası play-off';

  @override
  String get hubEventWatchWcDraw => 'Dünya Şampiyonası kurasını izle';

  @override
  String get hubEventWorldCupHere => 'Dünya Şampiyonası başlıyor';

  @override
  String get hubEventWatchFinalsDraw => 'Final turnuvası kurasını izle';

  @override
  String get hubEventFinalsHere => 'Final turnuvası başlıyor';

  @override
  String get hubEventPlayWcRound =>
      'Dünya Şampiyonası\'nın sıradaki turunu oyna';

  @override
  String hubEventPlayCupMatch(String cup) {
    return 'Sıradaki $cup maçını oyna';
  }

  @override
  String get hubEventPlayNationsCupMatch =>
      'Sıradaki Uluslar Kupası maçını oyna';

  @override
  String get hubEventWatchNationsCupDraw => 'Uluslar Kupası kurasını izle';

  @override
  String get hubEventWatchHostSelection => 'Ev sahibi seçimini izle';

  @override
  String get hubEventWatchQualifyingDraw => 'Eleme kurasını izle';

  @override
  String get hubEventWatchWcHostSelection =>
      'Dünya Şampiyonası ev sahibi seçimini izle';

  @override
  String get hubEventWatchWcQualifyingDraw =>
      'Dünya Şampiyonası eleme kurasını izle';

  @override
  String get hubEventArrangeFriendlies => 'Hazırlık maçları ayarla';

  @override
  String hubEventFriendliesSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count açık hazırlık maçı penceresini henüz doldurmadın',
      one: 'Açık hazırlık maçı penceresini henüz doldurmadın',
    );
    return '$_temp0';
  }

  @override
  String get hubEventReshapeXi => 'İlk 11\'ini yeniden kur';

  @override
  String hubEventReshapeOutSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'İlk 11\'inden $count oyuncu yok (cezalı ya da sakat). Yerlerine birilerini seç',
      one: 'İlk 11\'inden 1 oyuncu yok (cezalı ya da sakat). Yerine birini seç',
    );
    return '$_temp0';
  }

  @override
  String hubEventReshapeShortSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'İlk 11\'in eksik. Boş yerleri doldur',
      one: 'İlk 11\'in eksik. Boş yeri doldur',
    );
    return '$_temp0';
  }

  @override
  String hubEventPlayOpponent(String opponent) {
    return 'Oyna: $opponent';
  }

  @override
  String get hubEventContinentalFinalsFallback => 'kıta finalleri';

  @override
  String get hubCallUpFriendlies => 'Hazırlık maçları için kadronu açıkla';

  @override
  String get hubCallUpRequalify => 'Eleme kadronu yeniden açıkla';

  @override
  String get hubCallUpWorldCup => 'Dünya Şampiyonası kadronu açıkla';

  @override
  String get hubCallUpFinals => 'Final turnuvası için kadronu açıkla';

  @override
  String get hubCallUpNationsCup => 'Uluslar Kupası kadronu açıkla';

  @override
  String get hubCallUpQualifying => 'Eleme kadronu açıkla';

  @override
  String get hubCallUpGeneric => 'Kadronu açıkla';

  @override
  String get hubHost => 'Ev sahibi';

  @override
  String get hubGoldenBoot => 'Altın Ayakkabı';

  @override
  String hubGoldenBootValue(String name, int goals) {
    return '$name · $goals gol';
  }

  @override
  String get hubPens => '(pen.)';

  @override
  String get hubNationalHub => 'ULUSAL MERKEZ';

  @override
  String get hubMessages => 'Mesajlar';

  @override
  String get hubWorldChampions => 'DÜNYA ŞAMPİYONLARI';

  @override
  String get hubViewBracket => 'Tabloyu gör ›';

  @override
  String get hubBoardDelighted => 'Çok memnun';

  @override
  String get hubBoardPleased => 'Memnun';

  @override
  String get hubBoardExpectingMore => 'Daha fazlasını bekliyor';

  @override
  String get hubBoardConcerned => 'Endişeli';

  @override
  String get hubBoardJobAtRisk => 'Görev risk altında';

  @override
  String get hubBoard => 'YÖNETİM KURULU';

  @override
  String hubBoardObjective(String label) {
    return 'Yönetim hedefi: $label';
  }

  @override
  String hubObjectiveMet(String result) {
    return 'BAŞARILDI · $result';
  }

  @override
  String hubObjectiveMissed(String result) {
    return 'KAÇIRILDI · $result';
  }

  @override
  String get hubNoMoreFixtures => 'Bu dönemde başka maç yok.';

  @override
  String get hubVs => 'VS';

  @override
  String hubWorldRank(int rank) {
    return '#$rank';
  }

  @override
  String get hubWorldRankLabel => 'Dünya sıralaması';

  @override
  String get hubSquadStatus => 'KADRO DURUMU';

  @override
  String hubPlayers(int count) {
    return '$count oyuncu';
  }

  @override
  String get hubAvgRating => 'Ort. puan';

  @override
  String get hubMorale => 'Moral';

  @override
  String get hubManageTeam => 'Takımı yönet';

  @override
  String get hubGroupsToBeDrawn =>
      'Gruplar henüz çekilmedi. Görmek için kurayı izle.';

  @override
  String hubGroupName(String name) {
    return 'GRUP $name';
  }

  @override
  String get hubTblTeam => 'TAKIM';

  @override
  String get hubTblP => 'O';

  @override
  String get hubTblGd => 'AV';

  @override
  String get hubTblPts => 'P';

  @override
  String get homeSettings => 'Ayarlar';

  @override
  String get homeLeadTheNation => 'ÜLKENİ YÖNET';

  @override
  String get homeYourNation => 'ülken';

  @override
  String get homeNewGame => 'Yeni oyun';

  @override
  String get homeAllSaves => 'Tüm kayıtlar';

  @override
  String get homeLoadGame => 'Oyunu yükle';

  @override
  String get homeContinue => 'DEVAM';

  @override
  String homeRoadToWorldCup(String date, int year) {
    return '$date · $year Dünya Şampiyonası yolunda';
  }

  @override
  String get careerManageSaves => 'Kayıtları yönet';

  @override
  String get careerNewGameTitle => 'YENİ OYUN';

  @override
  String careerCouldNotLoadNation(String error) {
    return 'Ülke yüklenemedi.\n$error';
  }

  @override
  String get careerNationNotFound => 'Ülke bulunamadı.';

  @override
  String careerWorldRankNum(int rank) {
    return 'DÜNYA SIRALAMASI #$rank';
  }

  @override
  String get careerManagerName => 'Teknik direktör adı';

  @override
  String get careerManagerNameHint => 'örn. Fatih Terim';

  @override
  String get careerBeginsBlurb =>
      'Kariyerin Eylül 2026\'da, 2030 Dünya Şampiyonası yolunda başlıyor.';

  @override
  String get careerFreeCycleNote =>
      'Dört yıllık tam bir dönem ücretsiz: elemeler, kıta şampiyonan ve Dünya Şampiyonası, iki kayıtla. Sonrasında tek bir ödeme sınırsız dönemlerin kilidini açar.';

  @override
  String get careerStartCareer => 'Kariyere Başla';

  @override
  String get careersTitle => 'KARİYERLER';

  @override
  String get careerManagerCareer => 'Teknik direktör kariyeri';

  @override
  String get careerManagerCareerSubtitle =>
      'Yönettiğin her dönem ve genel rekorun';

  @override
  String get careerSummaryTitle => 'Kariyer özeti';

  @override
  String get careerSummarySubtitle => 'Kupa dolabın ve teknik direktör rekorun';

  @override
  String get careerAchievements => 'Başarımlar';

  @override
  String get careerAchievementsSubtitle =>
      'Kilometre taşları, şampiyonluklar ve yönetim memnuniyeti';

  @override
  String get careerChallenges => 'Zorluklar';

  @override
  String get careerChallengesSubtitle => 'Kariyer boyu süren acımasız sınavlar';

  @override
  String get careerTeamRecords => 'Takım rekorları';

  @override
  String get careerTeamRecordsSubtitle =>
      'Tüm zamanların en golcüleri ve en çok maç oynayanlar';

  @override
  String get careerMyMatches => 'Maçlarım';

  @override
  String get careerMyMatchesSubtitle => 'Her sonuç ve gelecek maç';

  @override
  String get careerTitle => 'KARİYER';

  @override
  String careerCouldNotLoadCareer(String error) {
    return 'Kariyer yüklenemedi.\n$error';
  }

  @override
  String get careerNoCareer => 'Kariyer yok.';

  @override
  String get careerTrophyCabinet => 'KUPA DOLABI';

  @override
  String get careerTournamentHistory => 'TURNUVA GEÇMİŞİ';

  @override
  String get careerNoTournamentsYet => 'Henüz tamamlanan turnuva yok.';

  @override
  String get careerTeamFallback => 'Takım';

  @override
  String careerWorldNum(int rank) {
    return 'DÜNYA #$rank';
  }

  @override
  String careerPointsNum(int points) {
    return '$points PUAN';
  }

  @override
  String careerSeasonNum(int season) {
    return 'SEZON $season';
  }

  @override
  String get careerStatPlayedShort => 'O';

  @override
  String get careerStatsHeading => 'RAKAMLARLA';

  @override
  String get careerStatsWinRate => 'Galibiyet oranı';

  @override
  String get careerStatsGoalsFor => 'Atılan gol';

  @override
  String get careerStatsGoalsAgainst => 'Yenilen gol';

  @override
  String get careerStatsGoalDiff => 'Averaj';

  @override
  String get careerStatsCleanSheets => 'Gol yemeden maç';

  @override
  String get careerStatsBiggestWin => 'En büyük galibiyet';

  @override
  String get careerStatsWinStreak => 'Galibiyet serisi';

  @override
  String get careerStatsUnbeaten => 'Yenilgisiz seri';

  @override
  String get careerStatsShootouts => 'Penaltı atışları';

  @override
  String get careerStatsHatTricks => 'Hat-trick';

  @override
  String get careerStatsMotms => 'Maçın adamı';

  @override
  String get careerStatsBestRating => 'En iyi puan';

  @override
  String get careerStatWonShort => 'G';

  @override
  String get careerStatDrawnShort => 'B';

  @override
  String get careerStatLostShort => 'M';

  @override
  String get careerStatGoalsForShort => 'AG';

  @override
  String get careerStatGoalsAgainstShort => 'YG';

  @override
  String get careerStatGoalDiffShort => 'AV';

  @override
  String get careerNoSilverware => 'Henüz kupan yok. Git bir tane kazan.';

  @override
  String get careerMedalGold => 'ALTIN';

  @override
  String get careerMedalSilver => 'GÜMÜŞ';

  @override
  String get careerMedalBronze => 'BRONZ';

  @override
  String careerWinnersName(String name) {
    return 'Kazanan: $name';
  }

  @override
  String get careerSavesTitle => 'KAYITLAR';

  @override
  String careerCouldNotLoadSaves(String error) {
    return 'Kayıtlar yüklenemedi.\n$error';
  }

  @override
  String careerSlotsCount(int used, int limit) {
    return 'YUVALAR  $used/$limit';
  }

  @override
  String get careerThisSave => 'bu kayıt';

  @override
  String get careerSlotsFull => 'Yuvalar dolu';

  @override
  String careerSlotsUsed(int used) {
    return 'YUVALAR  $used';
  }

  @override
  String get careerSlotsUnlockMore => 'Daha fazla kayıt aç';

  @override
  String get careerSlotsKeepNote =>
      'Mevcut tüm kayıtların oynanabilir kalır. Sadece yeni bir kayıt için kilidi açman gerekir.';

  @override
  String get careerNewGame => 'Yeni Oyun';

  @override
  String get careerDeleteSaveTitle => 'Kayıt silinsin mi?';

  @override
  String careerDeleteSaveBody(String label) {
    return 'Bu işlem $label kariyerini kalıcı olarak siler.';
  }

  @override
  String get careerCancel => 'Vazgeç';

  @override
  String get careerDelete => 'Sil';

  @override
  String get careerNoSavesYet =>
      'Henüz kayıt yok.\nBir ülkeyi yönetmek için yeni oyun başlat.';

  @override
  String get careerUnknownNation => 'Bilinmiyor';

  @override
  String careerPlayedMinutes(int minutes) {
    return '${minutes}dk';
  }

  @override
  String careerPlayedHours(int hours, int minutes) {
    return '${hours}sa ${minutes}dk';
  }

  @override
  String careerLastPlayed(String when) {
    return 'Son oynanma: $when';
  }

  @override
  String get careerJustNow => 'az önce';

  @override
  String get careerYesterday => 'dün';

  @override
  String careerMinutesAgo(int n) {
    return '$n dk önce';
  }

  @override
  String careerHoursAgo(int n) {
    return '$n sa önce';
  }

  @override
  String careerDaysAgo(int n) {
    return '$n gün önce';
  }

  @override
  String careerRoadToWorldCup(int year) {
    return '$year Dünya Şampiyonası yolunda';
  }

  @override
  String get careerManagerCareerTitle => 'TEKNİK DİREKTÖR KARİYERİ';

  @override
  String careerCouldNotLoad(String error) {
    return 'Yüklenemedi.\n$error';
  }

  @override
  String get careerCycleByCycle => 'DÖNEM DÖNEM';

  @override
  String careerCyclesNationsLed(int cycles, int nations) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles dönem',
      one: '1 dönem',
    );
    String _temp1 = intl.Intl.pluralLogic(
      nations,
      locale: localeName,
      other: '$nations ülke yönetildi',
      one: '1 ülke yönetildi',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get careerStatTitles => 'Şampiyonluk';

  @override
  String get careerStatPlayed => 'Oynanan';

  @override
  String get careerStatWon => 'Galibiyet';

  @override
  String get careerStatDrawn => 'Beraberlik';

  @override
  String get careerStatLost => 'Mağlubiyet';

  @override
  String careerGoalsWinRate(
    int goalsFor,
    int goalsAgainst,
    String gd,
    int winRate,
  ) {
    return 'Goller $goalsFor–$goalsAgainst  ($gd)  ·  Galibiyet oranı %$winRate';
  }

  @override
  String get careerRecordResults => 'REKOR SONUÇLAR';

  @override
  String get careerBestWin => 'En iyi galibiyet';

  @override
  String get careerWorstDefeat => 'En ağır yenilgi';

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
    return '${won}G ${drawn}B ${lost}M  ·  AG $goalsFor YG $goalsAgainst ($gd)';
  }

  @override
  String get careerWorldCupLabel => 'Dünya Şampiyonası';

  @override
  String get careerContinentalLabel => 'Kıta';

  @override
  String get messagesTitle => 'MESAJLAR';

  @override
  String get messagesNoMessagesYet => 'Henüz mesaj yok.';

  @override
  String messagesCouldNotLoad(String error) {
    return 'Mesajlar yüklenemedi.\n$error';
  }

  @override
  String get messagesDone => 'Tamam';

  @override
  String get messagesNext => 'İleri';

  @override
  String get rankingWorldRanking => 'DÜNYA SIRALAMASI';

  @override
  String rankingCouldNotLoad(String error) {
    return 'Sıralama yüklenemedi.\n$error';
  }

  @override
  String get rankingNoRanking => 'Sıralama yok.';

  @override
  String get rankingAll => 'TÜMÜ';

  @override
  String get rankingYourTeam => 'TAKIMIN';

  @override
  String get rankingYourRankingOverTime => 'ZAMAN İÇİNDE SIRALAMAN';

  @override
  String rankingNowRank(int rank) {
    return 'şimdi #$rank';
  }

  @override
  String rankingBestWorst(int best, int worst) {
    return 'en iyi #$best · en kötü #$worst';
  }

  @override
  String get friendliesTitle => 'HAZIRLIK MAÇLARI';

  @override
  String friendliesLoadError(String error) {
    return 'Hazırlık maçları yüklenemedi.\n$error';
  }

  @override
  String get friendliesContinue => 'Devam';

  @override
  String friendliesArrangeIntro(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count boş aralık',
      one: '1 boş aralık',
    );
    return 'Bir sonraki resmi maçından önce $_temp0 için hazırlık maçı ayarla. Bir rakibe dokun ya da boş bırak.';
  }

  @override
  String get friendliesFree => 'Boş';

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
  String get matchGoalsTitle => 'GOLLER';

  @override
  String get matchGoalsNone => 'Gol yok';

  @override
  String get matchGoalPenalty => 'PEN';

  @override
  String get matchGoalSetPiece => 'DT';

  @override
  String matchGoalAssist(String name) {
    return 'asist $name';
  }

  @override
  String get friendliesHome => 'İÇ SAHA';

  @override
  String get friendliesAway => 'DEP.';

  @override
  String get friendliesNoneThisWindow => 'Bu aralıkta hazırlık maçı yok';

  @override
  String friendliesConfirmCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hazırlık maçını onayla',
      one: '1 hazırlık maçını onayla',
    );
    return '$_temp0';
  }

  @override
  String get friendliesMonthJan => 'Oca';

  @override
  String get friendliesMonthFeb => 'Şub';

  @override
  String get friendliesMonthMar => 'Mar';

  @override
  String get friendliesMonthApr => 'Nis';

  @override
  String get friendliesMonthMay => 'May';

  @override
  String get friendliesMonthJun => 'Haz';

  @override
  String get friendliesMonthJul => 'Tem';

  @override
  String get friendliesMonthAug => 'Ağu';

  @override
  String get friendliesMonthSep => 'Eyl';

  @override
  String get friendliesMonthOct => 'Eki';

  @override
  String get friendliesMonthNov => 'Kas';

  @override
  String get friendliesMonthDec => 'Ara';

  @override
  String get resultsMyMatches => 'MAÇLARIM';

  @override
  String resultsCouldNotLoad(String error) {
    return 'Sonuçlar yüklenemedi.\n$error';
  }

  @override
  String get resultsNoFixtures => 'Fikstür yok.';

  @override
  String get resultsVs => 'vs';

  @override
  String get resultsStageQualifier => 'ELEME';

  @override
  String get resultsStageFriendly => 'HAZIRLIK';

  @override
  String get resultsStageGroupStage => 'GRUP AŞAMASI';

  @override
  String get resultsStageSemiFinal => 'YARI FİNAL';

  @override
  String get resultsStageFinal => 'FİNAL';

  @override
  String get resultsStageContinentalClash => 'KITALAR ARASI ÇARPIŞMA';

  @override
  String get resultsStageFinalsGroup => 'FİNAL GRUBU';

  @override
  String get resultsStageRoundOf32 => 'SON 32 TURU';

  @override
  String get resultsStageRoundOf16 => 'SON 16 TURU';

  @override
  String get resultsStageQuarterFinal => 'ÇEYREK FİNAL';

  @override
  String get resultsStageThirdPlace => 'ÜÇÜNCÜLÜK MAÇI';

  @override
  String get matchSetupWarnCaptain =>
      'Kaptan belirlenmedi. Birine pazubendini vermek için dokun';

  @override
  String matchSetupWarnCaptainInjured(String name) {
    return '$name sakat, takımı sahaya çıkaramaz. Pazubendini devretmek için dokun';
  }

  @override
  String matchSetupWarnCaptainSuspended(String name) {
    return '$name bu maçta cezalı. Pazubendini devretmek için dokun';
  }

  @override
  String matchSetupWarnCaptainDropped(String name) {
    return '$name kaptan ama kadronda yok. Pazubendini devretmek için dokun';
  }

  @override
  String get matchSetupWarnSetPieces =>
      'Duran top atıcıları belirlenmedi. Kimin kullanacağını seçmek için dokun';

  @override
  String get matchSetupWarnBoth =>
      'Kaptan ve duran top atıcıları belirlenmedi. Ayarlamak için dokun';

  @override
  String matchStageMatchday(int matchday) {
    return 'HF $matchday';
  }

  @override
  String get squadCaptain => 'Kaptan';

  @override
  String deptEffectYouth(int points) {
    return 'Akademi yetenekleri yaklaşık $points genel güç daha iyi geliyor';
  }

  @override
  String deptEffectCommercial(String amount) {
    return 'Dönem sonunda $amount geri döner';
  }

  @override
  String deptEffectMedical(int percent) {
    return '%$percent daha az sakatlık';
  }

  @override
  String deptEffectNaturalisation(int percent) {
    return 'Yabancı bir oyuncunun geçiş talep etme şansı %$percent';
  }

  @override
  String deptEffectBoard(int points) {
    return '+$points yönetim sabrı, görevin tehlikeye girmeden önce';
  }

  @override
  String get deptEffectNone => 'Bütçe verilmezse etkisi yok';

  @override
  String get statsBestRated => 'Puanlar';

  @override
  String get statsMyCareer => 'Kariyer';

  @override
  String get statsBestAverageRating => 'EN İYİ PUAN ORTALAMASI';

  @override
  String get statsMyCareerRecord => 'REKORUN';

  @override
  String get statsNoRatingsRecorded => 'Henüz kayıtlı maç puanı yok.';

  @override
  String get statsGroupRecord => 'Rekor';

  @override
  String get statsGroupRuns => 'Seriler';

  @override
  String get statsGroupExtremes => 'Uç noktalar';

  @override
  String get statsGroupSplits => 'İç saha ve deplasman';

  @override
  String get statsGroupSquad => 'Oyuncuların';

  @override
  String get statsPlayed => 'Oynanan maç';

  @override
  String get statsWinDrawLoss => 'Galibiyet–beraberlik–mağlubiyet';

  @override
  String get statsWinRate => 'Galibiyet oranı';

  @override
  String get statsGoals => 'Atılan:yenilen gol';

  @override
  String get statsCleanSheets => 'Gol yemeden maç';

  @override
  String get statsFailedToScore => 'Gol atamadığı maç';

  @override
  String get statsLongestWinStreak => 'En uzun galibiyet serisi';

  @override
  String get statsLongestUnbeaten => 'En uzun yenilgisiz seri';

  @override
  String get statsLongestCleanSheets => 'Gol yemeden en uzun seri';

  @override
  String get statsLongestWinless => 'Kazanamadan en uzun seri';

  @override
  String get statsCurrentRun => 'Güncel yenilgisiz seri';

  @override
  String get statsBiggestWin => 'En büyük galibiyet';

  @override
  String get statsHeaviestDefeat => 'En ağır yenilgi';

  @override
  String get statsMostGoalsInAGame => 'Bir maçta en çok gol';

  @override
  String get statsShootouts => 'Penaltı atışları kazanılan–kaybedilen';

  @override
  String get statsComebackWins => 'Geriden gelinen galibiyet';

  @override
  String get statsHome => 'İç saha';

  @override
  String get statsAway => 'Deplasman';

  @override
  String get statsNeutral => 'Tarafsız saha';

  @override
  String get statsCompetitive => 'Resmi maçlar';

  @override
  String get statsFriendlies => 'Hazırlık maçları';

  @override
  String get statsHatTricks => 'Hat-trick';

  @override
  String get statsBraces => 'Duble';

  @override
  String get statsMotms => 'Maçın adamı ödülleri';

  @override
  String get statsAssists => 'Asist';

  @override
  String get statsCards => 'Kartlar';

  @override
  String get statsBestRating => 'En iyi bireysel puan';

  @override
  String statsAppsShort(int apps) {
    return '$apps maç';
  }

  @override
  String statsMotmShort(int motms) {
    return '$motms MA';
  }

  @override
  String get captainArmband => 'K';

  @override
  String get captainCurrent => 'Kaptan. Pazubendini almak için dokun';

  @override
  String get captainFitBorn => 'Doğuştan lider';

  @override
  String get captainFitNatural => 'Doğal bir kaptan';

  @override
  String get captainFitCapable => 'Takabilir';

  @override
  String get captainFitUnproven => 'Henüz lider değil';

  @override
  String get captainNone => 'Kaptan belirlenmedi';

  @override
  String captainMoraleBoost(int morale) {
    return '+$morale kadro morali';
  }

  @override
  String get resultsCategoryWorldCupQualifying => 'Dünya Şampiyonası Elemeleri';

  @override
  String get resultsCategoryFriendlies => 'Hazırlık Maçları';

  @override
  String get resultsCategoryContinentalClash => 'Kıtalar Arası Çarpışma';

  @override
  String get resultsCategoryNationsCup => 'Uluslar Kupası';

  @override
  String get resultsCategoryContinentalCup => 'Kıta Kupası';

  @override
  String get resultsCategoryWorldCupQualifyingShort => 'Dünya Şamp. El.';

  @override
  String get resultsCategoryContinentalQualifyingShort => 'Kıta Kupası El.';

  @override
  String get resultsCategoryContinentalQualifying => 'Kıta Kupası Elemeleri';

  @override
  String get resultsCategoryWorldCupFinals => 'Dünya Şampiyonası Finalleri';

  @override
  String get resultsRoundResults => 'TUR SONUÇLARI';

  @override
  String get resultsFriendlyInternationals => 'HAZIRLIK MİLLİ MAÇLARI';

  @override
  String get resultsKnockout => 'Eleme turu';

  @override
  String resultsEarlierMatches(int count) {
    return 'Önceki maçlar ($count)';
  }

  @override
  String resultsMatchday(int matchday) {
    return '$matchday. HAFTA';
  }

  @override
  String get resultsContinue => 'Devam';

  @override
  String resultsGroup(String name) {
    return '$name GRUBU';
  }

  @override
  String get achievementsScreenTitle => 'BAŞARIMLAR';

  @override
  String get achievementsChallengesTooltip => 'Zorluklar';

  @override
  String get achievementsChallengesHeading => 'ZORLUKLAR';

  @override
  String get achievementsBrutalTests => 'Kariyer boyu süren acımasız sınavlar';

  @override
  String achievementsCouldNotLoad(String error) {
    return 'Yüklenemedi.\n$error';
  }

  @override
  String achievementsUnlockedCount(int earned, int total) {
    return '$earned / $total açıldı';
  }

  @override
  String achievementsConqueredCount(int done, int total) {
    return '$done / $total fethedildi';
  }

  @override
  String get achievementsBoardSatisfaction => 'YÖNETİM MEMNUNİYETİ';

  @override
  String achievementsUnlockedBanner(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count BAŞARIM AÇILDI',
      one: 'BAŞARIM AÇILDI',
    );
    return '$_temp0';
  }

  @override
  String get achCatWins => 'Galibiyetler';

  @override
  String get achCatMatches => 'Maçlar';

  @override
  String get achCatQualifications => 'Elemeler';

  @override
  String get achCatTitles => 'Şampiyonluklar';

  @override
  String get achCatMisc => 'Çeşitli';

  @override
  String get achCatMega => 'Mega';

  @override
  String get achCatGoals => 'Goller';

  @override
  String get achCatStreaks => 'Seriler';

  @override
  String get achTierBronze => 'Bronz';

  @override
  String get achTierSilver => 'Gümüş';

  @override
  String get achTierGold => 'Altın';

  @override
  String get achTierPlatinum => 'Platin';

  @override
  String achGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Gol',
      one: '$count Gol',
    );
    return '$_temp0';
  }

  @override
  String achGoalsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gol at.',
      one: '1 gol at.',
    );
    return '$_temp0';
  }

  @override
  String achCleanSheets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Gol Yemeden Maç',
      one: '$count Gol Yemeden Maç',
    );
    return '$_temp0';
  }

  @override
  String achCleanSheetsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count maçta kalen gol yemesin.',
      one: '1 maçta kalen gol yemesin.',
    );
    return '$_temp0';
  }

  @override
  String get achStreakWin5 => 'Kazanma Alışkanlığı';

  @override
  String get achStreakWin5Desc => 'Üst üste beş maç kazan.';

  @override
  String get achStreakWin10 => 'Yükselişte';

  @override
  String get achStreakWin10Desc => 'Üst üste on maç kazan.';

  @override
  String get achStreakWin20 => 'Silindir';

  @override
  String get achStreakWin20Desc => 'Üst üste yirmi maç kazan.';

  @override
  String get achUnbeaten15 => 'Yenilmesi Zor';

  @override
  String get achUnbeaten15Desc => 'On beş maç yenilmeden git.';

  @override
  String get achUnbeaten30 => 'Dokunulmaz';

  @override
  String get achUnbeaten30Desc => 'Otuz maç yenilmeden git.';

  @override
  String get achHattrick => 'Hat-trick Kahramanı';

  @override
  String get achHattrickDesc => 'Bir oyuncun hat-trick yapsın.';

  @override
  String get achMotm10 => 'Öne Çıkan';

  @override
  String get achMotm10Desc => '10 maçın adamı ödülü topla.';

  @override
  String get achMotm50 => 'Talisman';

  @override
  String get achMotm50Desc => '50 maçın adamı ödülü topla.';

  @override
  String get achPerfect => 'Mükemmel On';

  @override
  String get achPerfectDesc => 'Bir oyuncun maçta 9,5 ve üzeri puan alsın.';

  @override
  String get achShootout => 'Buz Gibi Sinirler';

  @override
  String get achShootoutDesc => 'Beş penaltı atışı kazan.';

  @override
  String get achMassacre => 'Katliam';

  @override
  String get achMassacreDesc => 'Bir maçı 7 veya daha fazla farkla kazan.';

  @override
  String get achAnnihilation => 'Yok Oluş';

  @override
  String get achAnnihilationDesc => 'Bir maçı 10 veya daha fazla farkla kazan.';

  @override
  String get chTierBronze => 'Bronz';

  @override
  String get chTierSilver => 'Gümüş';

  @override
  String get chTierGold => 'Altın';

  @override
  String get chTierLegendary => 'Efsanevi';

  @override
  String get chFirstSteps => 'Kulübede';

  @override
  String get chFirstStepsDesc => '5 yıl boyunca görev yap.';

  @override
  String get chUnbeaten10 => 'Yükselişte';

  @override
  String get chUnbeaten10Desc => '10 resmi maç yenilmeden git.';

  @override
  String get chTwoNations => 'Yeni Meydan Okuma';

  @override
  String get chTwoNationsDesc => '2 farklı ülkeyi yönet.';

  @override
  String get chCont1 => 'Kıta Şampiyonu';

  @override
  String get chCont1Desc => 'Bir kıta şampiyonası kazan.';

  @override
  String get chNc1 => 'Uluslar Kupası Kazananı';

  @override
  String get chNc1Desc => 'Uluslar Kupası\'nı kazan.';

  @override
  String get chWc1 => 'Dünya Şampiyonu';

  @override
  String get chWc1Desc => 'Dünya Şampiyonası\'nı kazan.';

  @override
  String get chYears25 => 'Kurumsal Güç';

  @override
  String get chYears25Desc => '25 yıl boyunca görev yap.';

  @override
  String get chWc3 => 'Seri Kazanan';

  @override
  String get chWc3Desc => '3 Dünya Şampiyonası kazan.';

  @override
  String get chWc5 => 'Hanedan';

  @override
  String get chWc5Desc => '5 Dünya Şampiyonası kazan.';

  @override
  String get chWc10 => 'Ölümsüz';

  @override
  String get chWc10Desc => '10 Dünya Şampiyonası kazan.';

  @override
  String get chWc2Teams => 'Çantam Hazır, Yollardayım';

  @override
  String get chWc2TeamsDesc => '2 farklı ülkeyle Dünya Şampiyonası kazan.';

  @override
  String get chWc3Teams => 'Dünya Gezgini';

  @override
  String get chWc3TeamsDesc => '3 farklı ülkeyle Dünya Şampiyonası kazan.';

  @override
  String get chWcStreak3 => 'Üçleme';

  @override
  String get chWcStreak3Desc => 'Üst üste 3 Dünya Şampiyonası kazan.';

  @override
  String get chWcAllconf => 'Dünya Fatihi';

  @override
  String get chWcAllconfDesc =>
      'Her konfederasyondan bir ülkeyle Dünya Şampiyonası kazan (6).';

  @override
  String get chCont5 => 'Kıta Kralı';

  @override
  String get chCont5Desc => '5 kıta şampiyonası kazan.';

  @override
  String get chContAll => 'Altı Kıta Slamı';

  @override
  String get chContAllDesc =>
      'Her konfederasyonun kıta şampiyonasını kazan (6).';

  @override
  String get chTreble => 'Tam Set';

  @override
  String get chTrebleDesc =>
      'Tek bir kariyerde Dünya Şampiyonası\'nı, bir kıta şampiyonluğunu ve Uluslar Kupası\'nı kazan.';

  @override
  String get chNations10 => 'Göçebe';

  @override
  String get chNations10Desc => '10 farklı ülkeyi yönet.';

  @override
  String get chYears100 => 'Yüzyıl';

  @override
  String get chYears100Desc => '100 yıl boyunca görev yap.';

  @override
  String get chYears500 => 'Yarım Bin Yıl';

  @override
  String get chYears500Desc => '500 yıl boyunca görev yap.';

  @override
  String get chYears1000 => 'Ebedi';

  @override
  String get chYears1000Desc => '1000 yıl boyunca görev yap.';

  @override
  String get chGrandmaster => 'Büyük Usta';

  @override
  String get chGrandmasterDesc =>
      '3 Dünya Şampiyonası VE 5 kıta şampiyonası kazan.';

  @override
  String get chUndefeated => 'Dokunulmaz';

  @override
  String get chUndefeatedDesc =>
      'Tek bir maç kaybetmeden Dünya Şampiyonası kazan.';

  @override
  String get chPerfectQual => 'Kusursuz Geçiş';

  @override
  String get chPerfectQualDesc =>
      'Dünya Şampiyonası eleme kampanyasındaki her maçı kazan.';

  @override
  String get chMinnow => 'Küçük Balığın Mucizesi';

  @override
  String get chMinnowDesc =>
      'Dünya sıralamasında ilk 32 dışındaki bir ülkeyle Dünya Şampiyonası kazan.';

  @override
  String get chGrandTour => 'İç Saha ve Deplasman';

  @override
  String get chGrandTourDesc =>
      'Bir Dünya Şampiyonası\'nı ev sahibi olarak, bir tanesini de evinden uzakta kazan.';

  @override
  String get chUnbeaten25 => 'Duvar';

  @override
  String get chUnbeaten25Desc => '25 resmi maç yenilmeden git.';

  @override
  String get chGoals10k => 'Gol Makinesi';

  @override
  String get chGoals10kDesc => 'Kariyerinde 10.000 gol at.';

  @override
  String get chCleanSheets500 => 'Kale';

  @override
  String get chCleanSheets500Desc => 'Kariyerinde 500 kez kalesini gole kapat.';

  @override
  String get chHatTricks25 => 'Hat-trick Alışkanlığı';

  @override
  String get chHatTricks25Desc => 'Oyuncuların 25 hat-trick yapsın.';

  @override
  String get chWinStreak25 => 'Amansız';

  @override
  String get chWinStreak25Desc => 'Üst üste 25 maç kazan.';

  @override
  String get chCont10 => 'Kıta Hanedanı';

  @override
  String get chCont10Desc => '10 kıta şampiyonası kazan.';

  @override
  String get chPcWc => 'Seri Şampiyon';

  @override
  String chPcWcDesc(int count) {
    return 'Bu kayıtta $count Dünya Şampiyonası kazan.';
  }

  @override
  String get chPcMajors => 'Kupa Koleksiyoncusu';

  @override
  String chPcMajorsDesc(int count) {
    return '$count büyük kupa kazan (Dünya Şampiyonası, kıta şampiyonası veya Uluslar Kupası).';
  }

  @override
  String get chPcUnbeaten => 'Demir Duvar';

  @override
  String chPcUnbeatenDesc(int count) {
    return '$count resmi maç yenilmeden git.';
  }

  @override
  String get chPcNations => 'Gezgin Usta';

  @override
  String chPcNationsDesc(int count) {
    return '$count farklı ülkeyi yönet.';
  }

  @override
  String get chPcYears => 'Uzun Soluklu';

  @override
  String chPcYearsDesc(int count) {
    return '$count yıl boyunca görev yap.';
  }

  @override
  String achWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Galibiyet',
      one: '1 Galibiyet',
    );
    return '$_temp0';
  }

  @override
  String achWinsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count maç kazan.',
      one: '1 maç kazan.',
    );
    return '$_temp0';
  }

  @override
  String achMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Maç',
      one: '$count Maç',
    );
    return '$_temp0';
  }

  @override
  String achMatchesDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count maç oyna.',
      one: '1 maç oyna.',
    );
    return '$_temp0';
  }

  @override
  String get achQualWc => 'Dünya Şampiyonası Elemecisi';

  @override
  String get achQualWcDesc => 'Dünya Şampiyonası\'na katılma hakkı kazan.';

  @override
  String get achQualCont => 'Kıta Elemecisi';

  @override
  String get achQualContDesc => 'Kıta şampiyonana katılma hakkı kazan.';

  @override
  String get achTitleWc => 'Dünya Şampiyonları';

  @override
  String get achTitleWcDesc => 'Dünya Şampiyonası\'nı kazan.';

  @override
  String get achTitleEuro => 'Avrupa Şampiyonları';

  @override
  String get achTitleEuroDesc => 'Avrupa Şampiyonası\'nı kazan.';

  @override
  String get achTitleCopa => 'Güney Amerika Şampiyonları';

  @override
  String get achTitleCopaDesc => 'Güney Amerika Kupası\'nı kazan.';

  @override
  String get achTitleAfcon => 'Afrika Şampiyonları';

  @override
  String get achTitleAfconDesc => 'Afrika Şampiyonası\'nı kazan.';

  @override
  String get achTitleAsia => 'Asya Şampiyonları';

  @override
  String get achTitleAsiaDesc => 'Asya Şampiyonası\'nı kazan.';

  @override
  String get achTitleConcacaf => 'Kuzey Amerika Şampiyonları';

  @override
  String get achTitleConcacafDesc => 'Kuzey Amerika Kupası\'nı kazan.';

  @override
  String get achTitleOfc => 'Okyanusya Şampiyonları';

  @override
  String get achTitleOfcDesc => 'Okyanusya Kupası\'nı kazan.';

  @override
  String get achTitleNations => 'Uluslar Kupası Kazananları';

  @override
  String get achTitleNationsDesc => 'Uluslar Kupası\'nı kazan.';

  @override
  String get achTitleClash => 'Kıtalar Arası Çarpışma Kazananları';

  @override
  String get achTitleClashDesc => 'Kıtalar Arası Çarpışma\'yı kazan.';

  @override
  String get achMarksman => 'Dünya Şampiyonası Nişancısı';

  @override
  String get achMarksmanDesc =>
      'Kadrondaki bir oyuncu Dünya Şampiyonası final turnuvasında 6+ gol atsın.';

  @override
  String get achSweep => 'Tam Set';

  @override
  String get achSweepDesc =>
      'Tek bir kariyerde Dünya Şampiyonası\'nı ve kıta şampiyonluğunu birlikte elinde tut.';

  @override
  String get achAllstar => 'Turnuva Yıldızı';

  @override
  String get achAllstarDesc =>
      'Bir oyuncun Dünya Şampiyonası Turnuva Takımı\'na seçilsin.';

  @override
  String get achGoldenboot => 'Altın Ayakkabı';

  @override
  String get achGoldenbootDesc =>
      'Ülken bir şampiyonanın gol kralı olarak bitirsin.';

  @override
  String get achDemolition => 'Yıkım';

  @override
  String get achDemolitionDesc => 'Bir maçı 5 veya daha fazla farkla kazan.';

  @override
  String get achievementsNice => 'Harika!';

  @override
  String get achievementsHardestTests =>
      'Bir teknik direktörün en zor sınavları, koca bir kariyer ve onlarca ülke boyunca.';

  @override
  String get achievementsThisSave => 'BU KAYIT';

  @override
  String get achievementsBrutalBadge => 'ACIMASIZ';

  @override
  String get paywallGoPro => 'UNLIMITED\'A GEÇ';

  @override
  String get paywallOneTimeUnlock => 'Tek seferlik kilit açma. Abonelik yok.';

  @override
  String get paywallBenefitCarryOn =>
      'Bu kayıt tam kaldığı yerden devam eder; her milli maç, rekor ve rekabet yerinde durur.';

  @override
  String get paywallBenefitNoAds =>
      'Reklam yok, mikro ödeme yok, abonelik yok. Tek ödeme, sonraki her güncelleme senin.';

  @override
  String get paywallBenefitSaves =>
      'İstediğin kadar kayıt. Aynı anda bir favoriyi ve bir küçük takımı yönet, aynı oyunun ne kadar farklı okunduğunu gör.';

  @override
  String get paywallBenefitEndless =>
      'Bundan sonraki her dönem. Bugün on yedi yaşında bir oyuncu seç, 2034\'te doğru görüp görmediğini öğren.';

  @override
  String get paywallUnlocked => 'Unlimited açıldı. İyi oyunlar!';

  @override
  String get paywallContactingStore => 'Mağazaya bağlanılıyor…';

  @override
  String paywallUnlockProPriced(String price) {
    return 'Unlimited\'ın kilidini aç · $price';
  }

  @override
  String get paywallRestorePurchases => 'Satın alımları geri yükle';

  @override
  String get paywallStoreUnavailable => 'Mağaza kullanılamıyor';

  @override
  String get paywallStoreUnavailableNote =>
      'Fiyat yüklenemedi. Bağlantını kontrol et ve tekrar dene.';

  @override
  String get paywallTryAgain => 'Tekrar dene';

  @override
  String get gateTitle => 'İLK DÖNEMİN BİTTİ';

  @override
  String get gateLead =>
      'Dört yıl bir dönemdir. Haklı olup olmadığını anlamak için yeterli değil.';

  @override
  String get gatePriceLead => 'Tek ödeme, sonsuza kadar';

  @override
  String get gateBuy => 'SATIN AL VE DEVAM ET';

  @override
  String get gateExit => 'ÇIKIŞ';

  @override
  String get gateSaveTitle => 'BU KAYIT PRO GEREKTİRİYOR';

  @override
  String get gateSaveLead =>
      'Ücretsiz dönemi geçen kayıtlar ve Pro senaryoları Pro ile devam eder. Hiçbir şey kaybolmaz: bu kayıt seni bıraktığın gibi bekliyor.';

  @override
  String get careerSaveLockedNote => 'Bu kayda devam etmek için Pro gerekli';

  @override
  String get federationNaturalisation => 'VATANDAŞLIĞA GEÇİRME';

  @override
  String federationNaturalisedTitle(String name) {
    return '$name vatandaşlığa geçirildi';
  }

  @override
  String federationNaturalisedBody(String name, String nation) {
    return '$name geçişi tamamladı. Artık seçilebileceği milli takım: $nation. Kadro seçiminden onu kadroya çağırabilirsin.';
  }

  @override
  String federationCouldNotLoadOffer(String error) {
    return 'Teklif yüklenemedi.\n$error';
  }

  @override
  String get federationContinue => 'Devam';

  @override
  String get federationOfferToSwitchAllegiance => 'BAĞLILIK DEĞİŞTİRME TEKLİFİ';

  @override
  String federationPlayerMeta(String position, int age, String nation) {
    return '$position · $age yaş · Ülkesi: $nation';
  }

  @override
  String federationNaturalisationBlurb(
    String name,
    String playerNation,
    String sourceNation,
  ) {
    return '$name için bağlantılı ülke: $playerNation. Vatandaşlığa geçmeye istekli. Kabul edersen seçilebilir; reddedersen eski ülkesinde kalır: $sourceNation.';
  }

  @override
  String get federationDecline => 'Reddet';

  @override
  String get federationNaturalise => 'Vatandaşlığa geçir';

  @override
  String get federationBudgetLater => 'Sonra karar ver';

  @override
  String get federationSetYourBudget => 'BÜTÇENİ BELİRLE';

  @override
  String federationCouldNotLoadFinances(String error) {
    return 'Finans bilgileri yüklenemedi.\n$error';
  }

  @override
  String get federationSaveNotFound => 'Kayıt bulunamadı.';

  @override
  String get federationBudgetHeading => 'FEDERASYON BÜTÇESİ';

  @override
  String federationDistributeBudget(String amount) {
    return 'Dönemi başlatmak için $amount tutarını bölümlere dağıt. Akıllıca harca.';
  }

  @override
  String federationOverBudget(String amount) {
    return '$amount, federasyonun elindekinden fazla. Biraz geri al';
  }

  @override
  String get federationAllocateFullBudget =>
      'Dönemi başlatmak için tüm bütçeyi dağıt.';

  @override
  String get federationConfirming => 'Onaylanıyor…';

  @override
  String get federationConfirmBudget => 'Bütçeyi onayla';

  @override
  String get federationFinances => 'FİNANS';

  @override
  String get federationInvestmentUpdated => 'Yatırım güncellendi.';

  @override
  String get federationDevelopment => 'FEDERASYON GELİŞİMİ';

  @override
  String get federationProjectedAtSeasonEnd => 'SEZON SONU TAHMİNİ';

  @override
  String get federationCentralFunding => 'Merkezi destek';

  @override
  String get federationPrizeMoneySoFar => 'Şimdiye kadarki ödül parası';

  @override
  String get federationCommercialReturn => 'Ticari getiri';

  @override
  String get federationThisSeasonLocked => 'BU SEZON (KİLİTLİ)';

  @override
  String get federationInvestForNextSeason => 'GELECEK SEZON İÇİN YATIRIM';

  @override
  String get federationNextSeasonImpact => 'GELECEK SEZON ETKİSİ';

  @override
  String get federationSaving => 'Kaydediliyor…';

  @override
  String get federationConfirmInvestment => 'Yatırımı onayla';

  @override
  String get federationBalance => 'FEDERASYON BAKİYESİ';

  @override
  String get federationCommittedToStaff => 'Teknik ekibe ayrılan';

  @override
  String get federationFreeToSpend => 'Harcanabilir';

  @override
  String get federationWagesNote =>
      'Maaşlar dönem sonunda bakiyeden düşer, yani bu kadarı ayrılmış durumda.';

  @override
  String get federationInvestAtCeremony =>
      'Gelecek sezon için yatırımı dönem sonu töreninde yap.';

  @override
  String federationLevelBadge(int level) {
    return 'S$level';
  }

  @override
  String get federationAcademyProspects => 'Akademi yetenekleri';

  @override
  String federationPlusOverall(int value) {
    return '+$value genel';
  }

  @override
  String get federationInjuryRisk => 'Sakatlık riski';

  @override
  String get federationNaturalisationChance => 'Vatandaşlığa geçirme şansı';

  @override
  String get federationBoardPatience => 'Yönetim sabrı';

  @override
  String get federationUnallocated => 'DAĞITILMAMIŞ';

  @override
  String get nationsVitrineTitle => 'ULUSAL VİTRİN';

  @override
  String nationsCouldNotLoad(String error) {
    return 'Ülke yüklenemedi.\n$error';
  }

  @override
  String get nationsNoNation => 'Ülke yok.';

  @override
  String get nationsHonours => 'BAŞARILAR';

  @override
  String get nationsRankingHistory => 'DÜNYA SIRALAMASI GEÇMİŞİ';

  @override
  String get nationsTopScorers => 'TÜM ZAMANLARIN GOL KRALLARI';

  @override
  String get nationsTitles => 'ŞAMPİYONLUKLAR';

  @override
  String get nationsYourTeam => 'TAKIMIN';

  @override
  String get nationsWorld => 'DÜNYA';

  @override
  String get nationsWorldCup => 'Dünya Şampiyonası';

  @override
  String get nationsContinental => 'Kıta';

  @override
  String nationsAppearances(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count katılım',
      one: '1 katılım',
    );
    return '$_temp0';
  }

  @override
  String get nationsNotEnoughHistory =>
      'Henüz yeterli geçmiş yok. Bir iki dönem sonra tekrar bak.';

  @override
  String nationsBestRank(int rank) {
    return 'En iyi: #$rank';
  }

  @override
  String nationsNowRank(int rank) {
    return 'Şimdi: #$rank';
  }

  @override
  String get nationsNoGoals => 'Henüz kayıtlı gol yok.';

  @override
  String get nationsGoalsAbbrev => 'gol';

  @override
  String get nationsHosts => 'EV SAHİBİ';

  @override
  String get nationsSelectTitle => 'MİLLİ TAKIMI SEÇ';

  @override
  String nationsCouldNotLoadNations(String error) {
    return 'Ülkeler yüklenemedi.\n$error';
  }

  @override
  String get nationsNoMatch => 'Eşleşen ülke yok.';

  @override
  String get nationsSelectHeading => 'Milli Takımı Seç';

  @override
  String get nationsSearchHint => 'Ülke ara…';

  @override
  String get nationsRank => 'SIRA ';

  @override
  String get nationsPremium => 'PREMIUM';

  @override
  String get nationsSelect => 'SEÇ';

  @override
  String get statsTeamRecords => 'TAKIM REKORLARI';

  @override
  String get statsRecordBook => 'Rekor defteri';

  @override
  String statsCouldNotLoadStats(String error) {
    return 'İstatistikler yüklenemedi.\n$error';
  }

  @override
  String get statsNoData => 'Veri yok.';

  @override
  String get statsTopScorers => 'GOL KRALLARI';

  @override
  String get statsMostGamesPlayed => 'EN ÇOK MAÇA ÇIKANLAR';

  @override
  String get statsTeam => 'Takım';

  @override
  String get statsTopScorersShort => 'Golcüler';

  @override
  String get statsMostGames => 'En çok maç';

  @override
  String get statsNoGoalsRecorded => 'Henüz kayıtlı gol yok.';

  @override
  String get statsUnknown => 'Bilinmiyor';

  @override
  String get playerTitle => 'OYUNCU';

  @override
  String playerLoadError(String error) {
    return 'Oyuncu yüklenemedi.\n$error';
  }

  @override
  String get playerNotFound => 'Oyuncu bulunamadı.';

  @override
  String get playerClub => 'KULÜP';

  @override
  String get playerClubRole => 'Kulübünde';

  @override
  String get playerPosition => 'Pozisyon';

  @override
  String get playerPotential => 'Potansiyel';

  @override
  String get playerAge => 'Yaş';

  @override
  String get playerValue => 'Değer';

  @override
  String get clubFirstChoice => 'Her hafta oynuyor';

  @override
  String get clubRotation => 'Girip çıkıyor';

  @override
  String get clubFringe => 'Neredeyse hiç oynamıyor';

  @override
  String get clubFrozenOut => 'Oynamıyor';

  @override
  String clubAtClub(String club, String standing) {
    return '$club: $standing';
  }

  @override
  String yWinUpset0(String opponent, String score) {
    return 'Otuz yıldır futbol izliyorum ve bunu görmedim. $opponent karşısında $score.';
  }

  @override
  String yWinUpset1(String opponent, String score) {
    return '$opponent karşısında kimse onlara şans tanımıyordu. $score. Hem de hiç kimse.';
  }

  @override
  String yWinUpset2(String opponent, String score) {
    return '$opponent karşısında $score. Gidin komşuları uyandırın.';
  }

  @override
  String yWinUpset3(String opponent, String score) {
    return 'İnsanların torunlarına anlatacağı türden bir gece. $opponent $score.';
  }

  @override
  String yWinUpset4(String opponent, String score) {
    return '$opponent karşısında $score. Nasıl olduysa, oldu.';
  }

  @override
  String yWinUpset5(String opponent, String score) {
    return 'Kağıt üstünde iş başlamadan bitmişti. $opponent $score başka bir şey söylüyor.';
  }

  @override
  String yWinUpset6(String opponent, String score) {
    return '$opponent yenildi, $score. Bir yıl sonra kimse bu skora inanmayacak.';
  }

  @override
  String yWinUpset7(String opponent, String score) {
    return '$opponent $score. Tadını çıkar, sonra fikstüre bak.';
  }

  @override
  String yWinUpset8(String opponent, String score) {
    return '$opponent karşısında $score, doksan dakikanın seksenini şansımıza güvenerek geçirdik.';
  }

  @override
  String yWinUpset9(String opponent, String score) {
    return '$opponent karşısındaki tek gece bir yılı silmez. $score.';
  }

  @override
  String yWinUpset10(String opponent, String score) {
    return '$opponent karşısında $score kazandık, şimdi bize dönüm noktasına geldiğimiz söylenecek. Gelmedik.';
  }

  @override
  String yWinUpset11(String opponent, String score) {
    return '$opponent $score. Harika. Asıl önemli olduğunda tekrar sor.';
  }

  @override
  String yWinRoutine0(String opponent, String score) {
    return '$opponent yenildi, $score. Olması gerektiği gibi ve bunda bir keyif var.';
  }

  @override
  String yWinRoutine1(String opponent, String score) {
    return '$opponent karşısında $score. Acımasız, acımasız olmak da bir iltifat.';
  }

  @override
  String yWinRoutine2(String opponent, String score) {
    return '$opponent $score. Telaş yok, korku yok, şikayet yok.';
  }

  @override
  String yWinRoutine3(String opponent, String score) {
    return '$opponent karşısında derli toplu bir $score. İyi bir takım sakin bir günde böyle görünür.';
  }

  @override
  String yWinRoutine4(String opponent, String score) {
    return '$opponent karşısında $score. İş bitti, öğrenilen bir şey yok.';
  }

  @override
  String yWinRoutine5(String opponent, String score) {
    return '$opponent yenildi, $score. Yenmemiz gerekiyordu ve yendik.';
  }

  @override
  String yWinRoutine6(String opponent, String score) {
    return '$opponent karşısında profesyonel bir $score. Sıradaki.';
  }

  @override
  String yWinRoutine7(String opponent, String score) {
    return '$opponent $score geçildi. Dosyala ve devam et.';
  }

  @override
  String yWinRoutine8(String opponent, String score) {
    return '$opponent karşısında $score ve bizden alkış bekleniyor. Onları yendiğimiz için.';
  }

  @override
  String yWinRoutine9(String opponent, String score) {
    return '$opponent karşısındaki $score için emeği geçen herkese tebrikler, sanırım.';
  }

  @override
  String yWinRoutine10(String opponent, String score) {
    return '$opponent $score. Böyle takımları yenmek başarı değil, en alt sınır.';
  }

  @override
  String yWinRoutine11(String opponent, String score) {
    return '$opponent yenildi, $score, ama zorlanarak kazandık.';
  }

  @override
  String yWinTight0(String opponent, String score) {
    return '$opponent karşısında $score ve her dakikası hak edildi.';
  }

  @override
  String yWinTight1(String opponent, String score) {
    return 'Bu karakter işi. $opponent $score.';
  }

  @override
  String yWinTight2(String opponent, String score) {
    return '$opponent yenildi, $score, zor yoldan, kalıcı olan da bu yol.';
  }

  @override
  String yWinTight3(String opponent, String score) {
    return '$opponent karşısında $score. Böyle maçları kazananlar haziranda hâlâ ayakta olan takımlardır.';
  }

  @override
  String yWinTight4(String opponent, String score) {
    return 'Gergin, çirkin ve bir galibiyet. $opponent $score.';
  }

  @override
  String yWinTight5(String opponent, String score) {
    return '$opponent yenildi, $score. Üç puanı al ve maçı bir daha izleme.';
  }

  @override
  String yWinTight6(String opponent, String score) {
    return '$score. $opponent bize her santimi için emek harcattı.';
  }

  @override
  String yWinTight7(String opponent, String score) {
    return '$opponent $score. Güzel değildi. Sayılması aynı.';
  }

  @override
  String yWinTight8(String opponent, String score) {
    return '$opponent karşısında $score ve olduğundan on kat zor hale getirdik.';
  }

  @override
  String yWinTight9(String opponent, String score) {
    return '$opponent karşısında bu kadar sıkışmamamız gerekirdi. $score.';
  }

  @override
  String yWinTight10(String opponent, String score) {
    return '$opponent $score. Kazandık ama kendimiz hakkında iyi bir şey öğrenmedik.';
  }

  @override
  String yWinTight11(String opponent, String score) {
    return '$opponent karşısında bizi pohpohlayan bir $score.';
  }

  @override
  String yDrew0(String opponent, String score) {
    return '$opponent karşısında bir puan, $score. Al ve devam et.';
  }

  @override
  String yDrew1(String opponent, String score) {
    return '$opponent ile $score. Bundan daha kötü öğleden sonralar var.';
  }

  @override
  String yDrew2(String opponent, String score) {
    return '$opponent $score durduruldu. Her şeyin bir hikaye olması gerekmez.';
  }

  @override
  String yDrew3(String opponent, String score) {
    return '$opponent $score. Bir puan bir puandır ve puan tablosu nasıl geldiğini sormaz.';
  }

  @override
  String yDrew4(String opponent, String score) {
    return '$opponent ile $score. İki puan gitti ya da bir puan geldi. Ruh halini seç.';
  }

  @override
  String yDrew5(String opponent, String score) {
    return '$opponent ile beraberlik, $score. Kimse mutlu değil, kimse öfkeli değil.';
  }

  @override
  String yDrew6(String opponent, String score) {
    return '$opponent $score. Yılın en unutulabilir doksan dakikası.';
  }

  @override
  String yDrew7(String opponent, String score) {
    return '$opponent ile puanlar paylaşıldı, $score. Yola devam.';
  }

  @override
  String yDrew8(String opponent, String score) {
    return '$opponent karşısında $score. Kampanyalar böyle beraberliklerle sessizce ölür.';
  }

  @override
  String yDrew9(String opponent, String score) {
    return '$opponent karşısında iki puan çöpe gitti. $score. Başka bir adı yok.';
  }

  @override
  String yDrew10(String opponent, String score) {
    return '$opponent $score. Doksan dakikamız vardı ve ne yapacağımızı bilmiyorduk.';
  }

  @override
  String yDrew11(String opponent, String score) {
    return '$opponent ile $score, kimsenin hatırlamayacağı ve herkesin bedelini ödeyeceği bir sonuç.';
  }

  @override
  String yLost0(String opponent, String score) {
    return '$opponent karşısında $score yenildik. Olur böyle şeyler.';
  }

  @override
  String yLost1(String opponent, String score) {
    return '$opponent $score. Kimseyi asacak bir şey yok. Sıradaki maça.';
  }

  @override
  String yLost2(String opponent, String score) {
    return '$opponent karşısında $score kaybettik, her şeyi verdik. Bazı günler yetmiyor.';
  }

  @override
  String yLost3(String opponent, String score) {
    return '$opponent karşısında $score. Başlar dik. Bu takımın daha çok şeyi var.';
  }

  @override
  String yLost4(String opponent, String score) {
    return '$opponent $score. İkinci en iyi bizdik ve tartışılacak bir şey yok.';
  }

  @override
  String yLost5(String opponent, String score) {
    return '$opponent karşısında $score kaybettik. Toparlan.';
  }

  @override
  String yLost6(String opponent, String score) {
    return '$opponent karşısında $score. Rezalet değil, ama yeterli de değil.';
  }

  @override
  String yLost7(String opponent, String score) {
    return '$opponent karşısında $score yenildik. Bundan bir şey öğren, yoksa boşa gitti.';
  }

  @override
  String yLost8(String opponent, String score) {
    return '$opponent karşısında $score ve onlara parmağımızı bile sürmedik.';
  }

  @override
  String yLost9(String opponent, String score) {
    return '$opponent karşısında kayıp, $score. Aynı sorunlar, aynı ay, aynı bahaneler geliyor.';
  }

  @override
  String yLost10(String opponent, String score) {
    return '$opponent $score. Bunun kötü şans olmaktan çıkması için ne zaman?';
  }

  @override
  String yLost11(String opponent, String score) {
    return '$opponent karşısında $score yenildik. Bu, birine bir şeye mal olması gereken bir sonuç.';
  }

  @override
  String yLostBadly0(String opponent, String score) {
    return '$opponent karşısında $score. Kötü bir gece. Takımı bu maça göre değil, kampanyaya göre yargılayın.';
  }

  @override
  String yLostBadly1(String opponent, String score) {
    return '$opponent karşısında $score kaybetmeyi kimse oyuncular kadar istemedi.';
  }

  @override
  String yLostBadly2(String opponent, String score) {
    return '$opponent $score. Çirkin ve bu takımın gerçek yüzü değil.';
  }

  @override
  String yLostBadly3(String opponent, String score) {
    return '$opponent karşısında unutulacak bir $score. Bir sonraki sefer karşılık verecekler.';
  }

  @override
  String yLostBadly4(String opponent, String score) {
    return '$score. $opponent karşısında. Söyleyecek sözüm yok ve söz söylemem için para alıyorum.';
  }

  @override
  String yLostBadly5(String opponent, String score) {
    return '$opponent $score. Birinin bunun hesabını vermesi gerek.';
  }

  @override
  String yLostBadly6(String opponent, String score) {
    return '$opponent karşısındaki $score sonucunun kayıtlardan ve hafızadan silinmesini istiyorum.';
  }

  @override
  String yLostBadly7(String opponent, String score) {
    return '$opponent karşısında $score yenildik. Böyle bir skoru süslemenin yolu yok.';
  }

  @override
  String yLostBadly8(String opponent, String score) {
    return 'Bu $opponent karşısında bir yenilgi değil, teslimiyetti. $score.';
  }

  @override
  String yLostBadly9(String opponent, String score) {
    return '$score. $opponent karşısında. İnsanlar bunu izlemek için para verdi.';
  }

  @override
  String yLostBadly10(String opponent, String score) {
    return '$opponent $score. Bu bir şeyi değiştirmezse hiçbir şey değiştirmez.';
  }

  @override
  String yLostBadly11(String opponent, String score) {
    return 'Bu takımın daha önce rezil olduğunu gördüm, ama $opponent karşısında $score yeni bir dip.';
  }

  @override
  String yWinUpset12(String opponent, String score) {
    return '$opponent karşısında $score galibiyet. Tarihi bir kenara yazın, nerede olduğunuzu soracaklar.';
  }

  @override
  String yWinUpset13(String opponent, String score) {
    return 'Soyunma odası dışında kimse inanmıyordu. $opponent karşısında $score. Gurur kelimesi az kalır.';
  }

  @override
  String yWinUpset14(String opponent, String score) {
    return '$opponent karşısında $score! Hepsi son nefeslerine kadar koştu.';
  }

  @override
  String yWinUpset15(String opponent, String score) {
    return 'Dev avcısı. $opponent, $score. İşte bu yüzden her seferinde geliyoruz.';
  }

  @override
  String yWinUpset16(String opponent, String score) {
    return '$opponent karşısında $score. Maç öncesi tahminler az önce pencereden uçtu.';
  }

  @override
  String yWinUpset17(String opponent, String score) {
    return 'Açık favori: $opponent. Maç sonucu: bizim lehimize $score.';
  }

  @override
  String yWinUpset18(String opponent, String score) {
    return 'Yılın sürprizlerinden biri: $opponent karşısında $score.';
  }

  @override
  String yWinUpset19(String opponent, String score) {
    return '$opponent $score. Kimse tahmin etmedi, kimse de tam açıklayamıyor.';
  }

  @override
  String yWinUpset20(String opponent, String score) {
    return '$opponent karşısında $score. Güzel. Şimdi herkes yılın geri kalanının ne kadar kötü geçtiğini unutacak.';
  }

  @override
  String yWinUpset21(String opponent, String score) {
    return '$opponent karşısında $score ve vagon şimdiden dolu. Ben boşken de buradaydım.';
  }

  @override
  String yWinUpset22(String opponent, String score) {
    return '$opponent $score. Harika, ama yine de bunu çarçur etmenin bir yolunu bulurlar.';
  }

  @override
  String yWinUpset23(String opponent, String score) {
    return '$opponent karşısında büyük gece, $score. Bir çiçekle bahar gelmez.';
  }

  @override
  String yLostBadly12(String opponent, String score) {
    return '$opponent karşısında $score. Acıtıyor çünkü önemsiyoruz. Yine de arkalarındayız.';
  }

  @override
  String yLostBadly13(String opponent, String score) {
    return '$opponent karşısında unutulacak bir gece, $score. En çok oyuncuların canı yanıyor.';
  }

  @override
  String yLostBadly14(String opponent, String score) {
    return '$opponent $score. Başınızı dik tutun. Bir takım buna verdiği cevapla ölçülür.';
  }

  @override
  String yLostBadly15(String opponent, String score) {
    return '$opponent karşısında $score. Kötü, evet. Dünyanın sonu, hayır.';
  }

  @override
  String yLostBadly16(String opponent, String score) {
    return '$opponent karşısında $score. Yıllarca konuşulacak bir sonuç, hem de yanlış sebeplerle.';
  }

  @override
  String yLostBadly17(String opponent, String score) {
    return '$opponent kazandı, $score. Bundan sonra kimse bir dahakine şaşırmasın.';
  }

  @override
  String yLostBadly18(String opponent, String score) {
    return 'Uzun zamandır yaşanan en kötü gecelerden biri: $opponent karşısında $score.';
  }

  @override
  String yLostBadly19(String opponent, String score) {
    return '$opponent $score. Sorular sorulacak, sorulmalı da.';
  }

  @override
  String yLostBadly20(String opponent, String score) {
    return '$opponent karşısında $score. Rezalet kelimesi bile hafif kalır.';
  }

  @override
  String yLostBadly21(String opponent, String score) {
    return '$opponent karşısında $score yenilgi. Son çıkan ışıkları kapatsın.';
  }

  @override
  String yLostBadly22(String opponent, String score) {
    return '$opponent $score. Artık şaşırmıyorum ve bu beni korkutuyor.';
  }

  @override
  String yLostBadly23(String opponent, String score) {
    return '$score. $opponent. Yukarıdaki birinin bu gece özgeçmişini güncellemesi lazım.';
  }

  @override
  String yWinRout0(String opponent, String score) {
    return '$opponent karşısında $score! Böyle futbol bütün ülkeyi gülümsetir.';
  }

  @override
  String yWinRout1(String opponent, String score) {
    return '$opponent karşısında farklı galibiyet, $score. Ne performans.';
  }

  @override
  String yWinRout2(String opponent, String score) {
    return '$score. $opponent karşısında. Bu gece her şey tuttu.';
  }

  @override
  String yWinRout3(String opponent, String score) {
    return '$opponent karşısında yıkım: $score. Özetleri saklayın, isteyeceksiniz.';
  }

  @override
  String yWinRout4(String opponent, String score) {
    return '$opponent $score. Bu, futbolundan keyif alan bir takım.';
  }

  @override
  String yWinRout5(String opponent, String score) {
    return '$opponent karşısında $score, daha fazlası da olabilirdi. Muhteşem.';
  }

  @override
  String yWinRout6(String opponent, String score) {
    return '$opponent karşısında $score. İnsanların iki kez bakacağı bir skor.';
  }

  @override
  String yWinRout7(String opponent, String score) {
    return '$opponent karşısında $score galibiyet. İlk yarım saatten sonra maç kalmadı.';
  }

  @override
  String yWinRout8(String opponent, String score) {
    return 'Maç sonucu: $opponent karşısında $score. Uzun zamandır açık ara en farklı galibiyet.';
  }

  @override
  String yWinRout9(String opponent, String score) {
    return '$opponent $score. Bir takım oynamaya geldi, öteki otobüsten bile inmedi.';
  }

  @override
  String yWinRout10(String opponent, String score) {
    return '$score. $opponent hiçbir şeye cevap veremedi.';
  }

  @override
  String yWinRout11(String opponent, String score) {
    return 'Tam bir fark: $opponent karşısında $score.';
  }

  @override
  String yWinRout12(String opponent, String score) {
    return '$opponent karşısında $score. Güzel, ama ölçüt pek onlar sayılmaz.';
  }

  @override
  String yWinRout13(String opponent, String score) {
    return '$opponent karşısında $score. Bunu iyi bir takıma yaptığımızda beni uyandırın.';
  }

  @override
  String yWinRout14(String opponent, String score) {
    return '$opponent $score. Eğlenceli, ama böyle parlayıp hiçbir şey kazanamayan takımlar gördüm.';
  }

  @override
  String yWinRout15(String opponent, String score) {
    return '$score ve herkes yine dahi. Rakip $opponent idi.';
  }

  @override
  String yWinRout16(String opponent, String score) {
    return '$opponent karşısında $score. Havaya girmeyin, pek bir şey kanıtlamıyor.';
  }

  @override
  String yWinRout17(String opponent, String score) {
    return '$opponent $score. Tadını çıkarın, sonra en son heyecanlandığımızda ne olduğunu hatırlayın.';
  }

  @override
  String yWinShootout0(String opponent) {
    return '$opponent karşısında penaltılarla tur! Çelik gibi sinirler, hepsinde.';
  }

  @override
  String yWinShootout1(String opponent) {
    return '$opponent ile penaltılar ve sinirlerimize hâkim olduk. Bir yabancıya sarılın.';
  }

  @override
  String yWinShootout2(String opponent) {
    return '$opponent karşısında penaltı atışları kazanıldı. Kalbim kaldırmıyor.';
  }

  @override
  String yWinShootout3(String opponent) {
    return '$opponent karşısında penaltılarla galibiyet. Bir sonraki tura.';
  }

  @override
  String yWinShootout4(String opponent) {
    return '$opponent karşısında iş penaltılara kaldı ve biz daha çok attık.';
  }

  @override
  String yWinShootout5(String opponent) {
    return '$opponent karşısında penaltılar kazanıldı. En zor yoldan, ama tur bizim.';
  }

  @override
  String yWinShootout6(String opponent) {
    return '$opponent karşısında penaltılarla tur. Piyango çıktı, oyun unutulsun.';
  }

  @override
  String yWinShootout7(String opponent) {
    return 'O oyunun ardından $opponent karşısında penaltılarla kazanmak mı? Şans, herkes biliyor.';
  }

  @override
  String yWinShootout8(String opponent) {
    return '$opponent karşısında penaltılarla tur. Oraya hiç kalmamalıydı.';
  }

  @override
  String yKnockoutWin0(String opponent, String score) {
    return 'TUR ATLADIK. $opponent karşısında $score ve hayal yaşıyor.';
  }

  @override
  String yKnockoutWin1(String opponent, String score) {
    return 'ELEME GALİBİYETİ: $opponent karşısında $score. Ülke inanmaya başlayabilir.';
  }

  @override
  String yKnockoutWin2(String opponent, String score) {
    return '$opponent karşısında $score ve bir sonraki turdayız. Ne gece.';
  }

  @override
  String yKnockoutWin3(String opponent, String score) {
    return '$opponent evine dönüyor, $score. Yola devam.';
  }

  @override
  String yKnockoutWin4(String opponent, String score) {
    return 'ELEME TURU: $opponent karşısında $score. Bir sonraki tur kesinleşti.';
  }

  @override
  String yKnockoutWin5(String opponent, String score) {
    return 'Tur: $opponent karşısında $score.';
  }

  @override
  String yKnockoutWin6(String opponent, String score) {
    return '$opponent elendi, $score. Bir sonraki tur bekliyor.';
  }

  @override
  String yKnockoutWin7(String opponent, String score) {
    return '$opponent karşısında $score galibiyet. Elemede kimse nasıl olduğunu sormaz.';
  }

  @override
  String yKnockoutWin8(String opponent, String score) {
    return '$opponent karşısında tur, $score. Bir sonraki rakip bu kadar nazik olmayacak.';
  }

  @override
  String yKnockoutWin9(String opponent, String score) {
    return '$opponent karşısında $score tur için yetti. Bir dahakine çok daha fazlası gerekecek.';
  }

  @override
  String yKnockoutWin10(String opponent, String score) {
    return '$opponent elendi, $score. Kazanmaktan çok hayatta kaldık.';
  }

  @override
  String yKnockoutWin11(String opponent, String score) {
    return '$opponent karşısında $score sonrası bir sonraki turdayız. Nasıl olduğunu sormayın.';
  }

  @override
  String yUpsetGap0(String opponent, String gap) {
    return 'Sıralamada aramızda $gap basamak vardı ve yine de $opponent karşısında kazandık. Muhteşem.';
  }

  @override
  String yUpsetGap1(String opponent, String gap) {
    return '$opponent bizden $gap basamak yukarıdaydı. Yenildiler. Futbol harika.';
  }

  @override
  String yUpsetGap2(String opponent, String gap) {
    return 'Sıralama farkı: $gap basamak. Sonuç: $opponent karşısında galibiyet. İnanmayı asla bırakmayın.';
  }

  @override
  String yUpsetGap3(String opponent, String gap) {
    return 'Başlama vuruşu öncesi sıralama farkı: $gap basamak. $opponent yine de yenildi.';
  }

  @override
  String yUpsetGap4(String opponent, String gap) {
    return 'Dünya sıralamasında $opponent bizden $gap basamak yukarıdaydı. Bu gece değil.';
  }

  @override
  String yUpsetGap5(String opponent, String gap) {
    return 'Sürpriz endeksi: iki takım arasında $gap sıralama basamağı. $opponent karşısında galibiyet bizim.';
  }

  @override
  String yUpsetGap6(String opponent, String gap) {
    return 'Sıralamada $opponent ile aramızda $gap basamak vardı. Bir gece bu farkı kapatmaz.';
  }

  @override
  String yUpsetGap7(String opponent, String gap) {
    return '$opponent: $gap basamak yukarıda ve yenildi. Sıralama bunu fark etmeyecek bile.';
  }

  @override
  String yUpsetGap8(String gap) {
    return 'Sıralama farkı: $gap basamak. Bir dahaki sefere küçük bir takıma yenildiğimizde bu sayıyı hatırlayın.';
  }

  @override
  String yEatWords0(String opponent) {
    return 'Bu takımı gözden çıkarmıştım. Yanılmışım ve yanıldığıma hiç bu kadar sevinmemiştim. $opponent yenildi.';
  }

  @override
  String yEatWords1(String opponent) {
    return 'Bir porsiyon tevazu lütfen. Büyük olsun. $opponent karşısındaki galibiyet muhteşemdi.';
  }

  @override
  String yEatWords2(String opponent) {
    return 'Ellerinde bir şey kalmadı demiştim. Çok şey varmış. $opponent karşısında hepsi iyi oynadı.';
  }

  @override
  String yEatWords3(String opponent) {
    return 'Kayıtlara geçsin, $opponent karşısındaki bu galibiyeti beklemiyordum. Hakkını vermek lazım.';
  }

  @override
  String yEatWords4(String opponent) {
    return 'Peki. Er geç açık verecekler demiştim. $opponent karşısında açık vermediler.';
  }

  @override
  String yEatWords5(String opponent) {
    return 'Bu gece bu takım hakkında söylediklerimi yutacağım. $opponent galibiyeti bunu hak ediyor.';
  }

  @override
  String yEatWords6(String opponent) {
    return 'Evet, bitti demiştim. $opponent karşısında bir galibiyet beni henüz haksız çıkarmaz.';
  }

  @override
  String yEatWords7(String opponent) {
    return '$opponent maçından sonra sözlerimi geri almam isteniyor. Alacağım, yavaşça, fişi de saklıyorum.';
  }

  @override
  String yEatWords8(String opponent) {
    return '$opponent galibiyeti etkileyiciydi. Bu takımla ilgili şüphelerim hiçbir yere gitmedi.';
  }

  @override
  String yAwayFansWin0(String nation, String score) {
    return '$nation için helal olsun. $score, sonuna kadar hak ettiler.';
  }

  @override
  String yAwayFansWin1(String nation, String score) {
    return 'Söylemesi acı ama bu gece daha iyi olan taraf $nation idi. $score. Tebrikler.';
  }

  @override
  String yAwayFansWin2(String nation, String score) {
    return '$score. $nation önünde şapka çıkarıyorum, daha çok istediler.';
  }

  @override
  String yAwayFansWin3(String nation, String score) {
    return '$nation karşısında $score yenilgi. Ne diyeceğimi bile bilmiyorum.';
  }

  @override
  String yAwayFansWin4(String nation, String score) {
    return '$nation $score. Bizimkiler utanmalı.';
  }

  @override
  String yAwayFansWin5(String nation, String score) {
    return '$nation karşısında $score. Biri bana bunun nasıl olduğunu açıklasın.';
  }

  @override
  String yAwayFansWin6(String nation, String score) {
    return '$nation karşısında $score kaybetmek. Bunu asla atlatamayacağım.';
  }

  @override
  String yAwayFansWin7(String nation, String score) {
    return '$nation karşısında $score. Şans. Tamamen şans.';
  }

  @override
  String yAwayFansWin8(String nation, String score) {
    return 'Bu $score sonrası $nation taraftarı yıllarca çekilmez olacak. Hiçbir şey için teşekkürler.';
  }

  @override
  String yNeutralWin0(String nation, String opponent, String score) {
    return '$nation $score $opponent. Futbol için harika. İşte bu yüzden seviyoruz.';
  }

  @override
  String yNeutralWin1(String nation, String opponent, String score) {
    return '$nation için ne sonuç: $opponent karşısında $score. Futbol en güzel hâlinde.';
  }

  @override
  String yNeutralWin2(String nation, String opponent, String score) {
    return 'Bu gece bütün tarafsızlar $nation için tezahürat yapıyor. $opponent karşısında $score!';
  }

  @override
  String yNeutralWin3(String nation, String opponent, String score) {
    return 'Haftanın sonucu: $nation $score $opponent.';
  }

  @override
  String yNeutralWin4(String nation, String opponent, String score) {
    return '$nation $score $opponent. Bunu kimse kuponuna yazmamıştı.';
  }

  @override
  String yNeutralWin5(String nation, String opponent, String score) {
    return 'Büyük sonuç: $nation $score $opponent. Sıralama değişecek.';
  }

  @override
  String yNeutralWin6(String nation, String opponent, String score) {
    return '$nation $score $opponent. Eğlenceli, bakalım bir daha yapabilecekler mi.';
  }

  @override
  String yNeutralWin7(String nation, String opponent, String score) {
    return '$nation $score $opponent. $nation mi kazandı, $opponent mu kaybetti?';
  }

  @override
  String yNeutralWin8(String nation, String opponent, String score) {
    return 'Sürpriz sonuç: $nation $score $opponent. Bolca abartılı tepki bekleyin.';
  }

  @override
  String yScorerHero0(String name, String opponent) {
    return '$opponent karşısında $name. Çocuklara onun adını verecekler.';
  }

  @override
  String yScorerHero1(String name, String opponent) {
    return '$name için bir heykel. Bu gece $opponent karşısında her şeydi.';
  }

  @override
  String yScorerHero2(String name, String opponent) {
    return '$name, sen bir harikasın. $opponent karşısındaki bu geceyi unutmayın.';
  }

  @override
  String yScorerHero3(String name, String opponent) {
    return '$name $opponent karşısında maçı çözdü. Maçın oyuncusu, tartışmasız.';
  }

  @override
  String yScorerHero4(String name, String opponent) {
    return '$opponent karşısında gece $name adlı oyuncuya aitti.';
  }

  @override
  String yScorerHero5(String name, String opponent) {
    return '$name, $opponent karşısında gerektiğinde sahnedeydi.';
  }

  @override
  String yScorerHero6(String name, String opponent) {
    return '$name, $opponent karşısında harikaydı. Şimdi bunu her hafta yapsın.';
  }

  @override
  String yScorerHero7(String name, String opponent) {
    return '$name, $opponent karşısında takımı kurtardı. Diğerleri pek yardım etmedi.';
  }

  @override
  String yScorerHero8(String name, String opponent) {
    return '$name olmasa $opponent karşısında bambaşka bir gece olurdu.';
  }

  @override
  String yLostShock0(String opponent, String score) {
    return '$opponent karşısında $score. Kaza. Herkesin başına bir kez gelir.';
  }

  @override
  String yLostShock1(String opponent, String score) {
    return '$opponent karşısında $score yenilgi. Silkelenin, kampanya bitmedi.';
  }

  @override
  String yLostShock2(String opponent, String score) {
    return '$opponent $score. Acı, ama tek bir sonuç bu takımı tanımlamaz.';
  }

  @override
  String yLostShock3(String opponent, String score) {
    return '$opponent karşısında $score. İşte kötü bir gün. Devam.';
  }

  @override
  String yLostShock4(String opponent, String score) {
    return '$opponent karşısında yenilgi, $score. Kimse bunu beklemiyordu.';
  }

  @override
  String yLostShock5(String opponent, String score) {
    return '$opponent $score. Hiçbir anlamı olmayan gecelerden biri.';
  }

  @override
  String yLostShock6(String opponent, String score) {
    return '$opponent karşısında $score. Akıllarda kalacak bir yenilgi.';
  }

  @override
  String yLostShock7(String opponent, String score) {
    return '$opponent karşısında yenildik, $score. Nereden bakarsanız bakın büyük sürpriz.';
  }

  @override
  String yLostShock8(String opponent, String score) {
    return '$opponent karşısında $score. $opponent karşısında! Kabul edilemez.';
  }

  @override
  String yLostShock9(String opponent, String score) {
    return '$opponent karşısında $score yenilgi. Açıklama istiyorum, bahane değil.';
  }

  @override
  String yLostShock10(String opponent, String score) {
    return '$opponent $score. Ulusal bir rezalet, ve bu bir söz sanatı değil.';
  }

  @override
  String yLostShock11(String opponent, String score) {
    return '$opponent karşısında $score. Yukarıdakiler nasıl hâlâ koltuklarında?';
  }

  @override
  String yLostRout0(String opponent, String score) {
    return '$opponent karşısında $score. Onlar üst düzey bir takım. Ders alalım.';
  }

  @override
  String yLostRout1(String opponent, String score) {
    return '$opponent bize üstünlük kurdu, $score. En iyilere yenilmek ayıp değil.';
  }

  @override
  String yLostRout2(String opponent, String score) {
    return '$opponent $score. Bir ders, ve insan derslerle büyür.';
  }

  @override
  String yLostRout3(String opponent, String score) {
    return '$opponent karşısında $score. Acı, ama onlar bir seviye yukarıda.';
  }

  @override
  String yLostRout4(String opponent, String score) {
    return '$opponent kazandı, $score. Fark gerçek ve artık herkes gördü.';
  }

  @override
  String yLostRout5(String opponent, String score) {
    return '$opponent karşısında $score. Düpedüz dayak.';
  }

  @override
  String yLostRout6(String opponent, String score) {
    return '$opponent $score. Daha iyi takım, skor da bunu söylüyor.';
  }

  @override
  String yLostRout7(String opponent, String score) {
    return '$opponent karşısında $score yenilgi. Rezalet değil, ama maç da değil.';
  }

  @override
  String yLostRout8(String opponent, String score) {
    return '$opponent karşısında $score. Rakip daha iyi ya da değil, kimse böyle kaybetmemeli.';
  }

  @override
  String yLostRout9(String opponent, String score) {
    return '$opponent $score. Mücadele etmeyi denedik mi bari?';
  }

  @override
  String yLostRout10(String opponent, String score) {
    return '$score. $opponent karşısında. Kuzular mezbahaya.';
  }

  @override
  String yLostRout11(String opponent, String score) {
    return '$opponent karşısında $score yenilgi ve kimse umursamış görünmüyordu.';
  }

  @override
  String yLostShootout0(String opponent) {
    return '$opponent karşısında penaltılarla elendik. Her şeyini verdiler. Onlarla gurur duyuyorum.';
  }

  @override
  String yLostShootout1(String opponent) {
    return '$opponent ile penaltılar. Elenmenin en acımasız yolu. Başınızı dik tutun.';
  }

  @override
  String yLostShootout2(String opponent) {
    return '$opponent karşısında penaltı atışları kaybedildi. Bunu kimse hak etmedi.';
  }

  @override
  String yLostShootout3(String opponent) {
    return '$opponent karşısında penaltılarla elendik. Penaltılar karar verdi.';
  }

  @override
  String yLostShootout4(String opponent) {
    return '$opponent penaltılarla tur atladı. Turnuvamız burada bitiyor.';
  }

  @override
  String yLostShootout5(String opponent) {
    return '$opponent karşısında penaltılar kaybedildi. Yine penaltılar.';
  }

  @override
  String yLostShootout6(String opponent) {
    return '$opponent karşısında penaltılarla elendik. Hiç penaltı çalışıyor muyuz?';
  }

  @override
  String yLostShootout7(String opponent) {
    return '$opponent karşısında penaltılarla yenildik. Maçı çok önce bitirmeliydik.';
  }

  @override
  String yLostShootout8(String opponent) {
    return '$opponent ile penaltılar ve kaybettik. Elbette kaybettik.';
  }

  @override
  String yKnockoutLoss0(String opponent, String score) {
    return 'ELENDİK. $opponent karşısında $score. Gurur duyulacak bir yolculuk burada bitiyor.';
  }

  @override
  String yKnockoutLoss1(String opponent, String score) {
    return '$opponent bizi eledi, $score. Anılar için teşekkürler.';
  }

  @override
  String yKnockoutLoss2(String opponent, String score) {
    return '$opponent karşısında $score. Yolculuk bitti, ama ne yolculuktu.';
  }

  @override
  String yKnockoutLoss3(String opponent, String score) {
    return 'ELENDİK: $opponent karşısında $score. Başlar dik.';
  }

  @override
  String yKnockoutLoss4(String opponent, String score) {
    return 'VEDA: $opponent karşısında $score.';
  }

  @override
  String yKnockoutLoss5(String opponent, String score) {
    return 'Elendik: $opponent karşısında $score.';
  }

  @override
  String yKnockoutLoss6(String opponent, String score) {
    return '$opponent tur atladı, $score. Turnuvamız bitti.';
  }

  @override
  String yKnockoutLoss7(String opponent, String score) {
    return '$opponent bizi eledi, $score. Otopsi şimdi başlıyor.';
  }

  @override
  String yKnockoutLoss8(String opponent, String score) {
    return 'ELENDİK. $opponent karşısında $score. Başka bir turnuva, aynı son.';
  }

  @override
  String yKnockoutLoss9(String opponent, String score) {
    return '$opponent karşısında $score ve eve dönüyoruz. Kimse şaşırmadı.';
  }

  @override
  String yKnockoutLoss10(String opponent, String score) {
    return '$opponent bizi eledi, $score. Sabaha kadar bahaneler gelir.';
  }

  @override
  String yKnockoutLoss11(String opponent, String score) {
    return '$opponent $score. Elendik ve hiçbir an başka türlü bitecekmiş gibi görünmedi.';
  }

  @override
  String yAwayFansGloat0(String nation, String score) {
    return '$nation karşısında $score. Saygı duyuyoruz, daha güçlü dönecekler.';
  }

  @override
  String yAwayFansGloat1(String nation, String score) {
    return 'Bizim için iyi galibiyet, $score. $nation için kötü gün, taraftarları için üzgünüm.';
  }

  @override
  String yAwayFansGloat2(String nation, String score) {
    return '$score. $nation kötü bir gece geçirdi, biz de fırsatı kullandık. Futbol bu.';
  }

  @override
  String yAwayFansGloat3(String nation, String score) {
    return '$nation karşısında $score! Bunu kim bekliyordu? Onlar değil.';
  }

  @override
  String yAwayFansGloat4(String nation, String score) {
    return '$nation karşısında $score galibiyet. Biri taraftarlarına bir baksın.';
  }

  @override
  String yAwayFansGloat5(String nation, String score) {
    return '$nation $score. Bu fotoğraf albümüne giriyor.';
  }

  @override
  String yAwayFansGloat6(String nation, String score) {
    return '$nation karşısında $score. Bir de kendilerini büyük takım sanıyorlar.';
  }

  @override
  String yAwayFansGloat7(String nation, String score) {
    return 'Bize $score kaybettiğini düşün. $nation taraftarına sor, artık biliyorlar.';
  }

  @override
  String yAwayFansGloat8(String nation, String score) {
    return '$nation, $score. İyi uçuşlar.';
  }

  @override
  String yNeutralLoss0(String nation, String opponent, String score) {
    return '$nation $score $opponent. $opponent için büyük gece, $nation için zor gece.';
  }

  @override
  String yNeutralLoss1(String nation, String opponent, String score) {
    return '$opponent karşısındaki $score sonrası $nation taraftarına geçmiş olsun. Toparlanırlar.';
  }

  @override
  String yNeutralLoss2(String nation, String opponent, String score) {
    return '$nation $score $opponent. Her büyük takımın böyle bir gecesi olur.';
  }

  @override
  String yNeutralLoss3(String nation, String opponent, String score) {
    return 'Haftanın şoku: $nation $score $opponent.';
  }

  @override
  String yNeutralLoss4(String nation, String opponent, String score) {
    return '$nation $score $opponent. Bunu kimse beklemiyordu.';
  }

  @override
  String yNeutralLoss5(String nation, String opponent, String score) {
    return 'Günün sonucu: $nation $score $opponent. Şimdi $nation tarafında sorular var.';
  }

  @override
  String yNeutralLoss6(String nation, String opponent, String score) {
    return '$nation $score $opponent. Takip edenler için tesadüf değil.';
  }

  @override
  String yNeutralLoss7(String nation, String opponent, String score) {
    return '$nation $score $opponent. Orada birinin açıklayacak çok şeyi var.';
  }

  @override
  String yNeutralLoss8(String nation, String opponent, String score) {
    return '$nation $score $opponent. Büyük isim, küçük performans.';
  }

  @override
  String yDownGap0(String opponent, String gap) {
    return '$opponent bizden $gap basamak aşağıdaydı. Olur böyle. Devam.';
  }

  @override
  String yDownGap1(String gap) {
    return 'Sıralama farkı: lehimize $gap basamak. Futbol sıralama okumaz.';
  }

  @override
  String yDownGap2(String opponent, String gap) {
    return 'Kâğıt üzerinde $opponent ile aramızda $gap basamak. Bu gece sahada değil.';
  }

  @override
  String yDownGap3(String opponent, String gap) {
    return 'Başlama vuruşu öncesi sıralama farkı: lehimize $gap basamak. Yine de $opponent karşısında yenildik.';
  }

  @override
  String yDownGap4(String opponent, String gap) {
    return 'Dünya sıralamasında $opponent bizden $gap basamak aşağıdaydı. Sonuç: yenilgi.';
  }

  @override
  String yDownGap5(String opponent, String gap) {
    return 'Sürpriz endeksi: $gap sıralama basamağı, ters yönde, rakip $opponent.';
  }

  @override
  String yDownGap6(String opponent, String gap) {
    return 'Sıralamada $opponent takımının $gap basamak üstündeyiz. Yenilgi. Açıklayın bunu.';
  }

  @override
  String yDownGap7(String gap) {
    return 'Bizden $gap basamak aşağıdaki bir takıma yenildik. Bu sayı iyice otursun.';
  }

  @override
  String yDownGap8(String opponent, String gap) {
    return 'Sıralama farkı: $gap basamak. $opponent karşısında yenilgi. Biri günleri saymaya başlamalı.';
  }

  @override
  String yDrewHeroic0(String opponent, String score) {
    return '$opponent karşısında $score! Galibiyet tadında bir beraberlik.';
  }

  @override
  String yDrewHeroic1(String opponent, String score) {
    return '$opponent karşısında $score. Her biriyle gurur duyuyorum.';
  }

  @override
  String yDrewHeroic2(String opponent, String score) {
    return '$opponent $score. Favori onlardı ve onlara yetiştik.';
  }

  @override
  String yDrewHeroic3(String opponent, String score) {
    return '$opponent ile $score. Kan ve terle kazanılmış bir puan.';
  }

  @override
  String yDrewHeroic4(String opponent, String score) {
    return '$opponent karşısında $score. Çok değerli bir puan.';
  }

  @override
  String yDrewHeroic5(String opponent, String score) {
    return '$opponent ile $score beraberlik. Pek az kişi bir şey bekliyordu.';
  }

  @override
  String yDrewHeroic6(String opponent, String score) {
    return '$opponent durduruldu, $score. Üzerine inşa edilecek bir sonuç.';
  }

  @override
  String yDrewHeroic7(String opponent, String score) {
    return '$opponent karşısında $score. Kimsenin bize vermediği bir puan.';
  }

  @override
  String yDrewHeroic8(String opponent, String score) {
    return '$opponent ile $score. İyi puan, ama beraberliklerle bir şey kazanılmaz.';
  }

  @override
  String yDrewHeroic9(String opponent, String score) {
    return '$opponent karşısında $score. Güzel. Doğru dürüst bir şutumuz bile yoktu.';
  }

  @override
  String yDrewHeroic10(String opponent, String score) {
    return '$opponent $score. Bir puan ve herkes kupayı kazanmışız gibi davranıyor.';
  }

  @override
  String yDrewHeroic11(String opponent, String score) {
    return '$opponent karşısında $score. Otobüsü çektik ve şanslıydık.';
  }

  @override
  String yDrewShame0(String opponent, String score) {
    return '$opponent ile $score. Sinir bozucu, ama hâlâ yenilgisiziz.';
  }

  @override
  String yDrewShame1(String opponent, String score) {
    return '$opponent ile sadece $score. Kötü bir gün. Olur.';
  }

  @override
  String yDrewShame2(String opponent, String score) {
    return '$opponent $score. Yeterli değil, oyuncular da biliyor.';
  }

  @override
  String yDrewShame3(String opponent, String score) {
    return '$opponent karşısında $score. İki puan kaybı, o kadar.';
  }

  @override
  String yDrewShame4(String opponent, String score) {
    return '$opponent ile $score. İki puan çöpe gitti.';
  }

  @override
  String yDrewShame5(String opponent, String score) {
    return '$opponent ile sadece $score. Nasıl paketlerseniz paketleyin, kötü sonuç.';
  }

  @override
  String yDrewShame6(String opponent, String score) {
    return '$opponent $score. Yenilgi tadında bir beraberlik.';
  }

  @override
  String yDrewShame7(String opponent, String score) {
    return '$opponent karşısında $score. Bu maçları rahat kazanmalıyız.';
  }

  @override
  String yDrewShame8(String opponent, String score) {
    return '$opponent ile $score. Utanç verici.';
  }

  @override
  String yDrewShame9(String opponent, String score) {
    return '$opponent ile sadece beraberlik, $score. Bunun sorumlusu kim?';
  }

  @override
  String yDrewShame10(String opponent, String score) {
    return '$opponent $score. Onları yenemiyorsak kimi yeneceğiz?';
  }

  @override
  String yDrewShame11(String opponent, String score) {
    return '$opponent ile $score. Taraftarları bize karşı beraberliği kutluyor. Bunu bir düşünün.';
  }

  @override
  String yTrophy0(String opponent) {
    return 'ŞAMPİYONLAR. $opponent. Yüksek sesle söyle.';
  }

  @override
  String yTrophy1(String opponent) {
    return 'Kazandık. $opponent. İyi değilim.';
  }

  @override
  String yTrophy2(String opponent) {
    return '$opponent bitti ve kupa eve geliyor.';
  }

  @override
  String yTrophy3(String opponent) {
    return 'Hepsi birer efsane. $opponent.';
  }

  @override
  String yRunnerUp0(String opponent) {
    return 'Çok yakındık. $opponent ve kimsenin istemediği bir madalya.';
  }

  @override
  String yRunnerUp1(String opponent) {
    return '$opponent ikinciliği. Yıllarca yakacak.';
  }

  @override
  String yRunnerUp2(String opponent) {
    return '$opponent: her şeye bir maç kala.';
  }

  @override
  String yRunnerUp3(String opponent) {
    return 'İkinci. $opponent. Biri şişeyi uzatsın.';
  }

  @override
  String yEliminated0(String opponent) {
    return '$opponent macerası bitti. Bu bir süre acıtacak.';
  }

  @override
  String yEliminated1(String opponent) {
    return '$opponent yolculuğumuz burada sona eriyor.';
  }

  @override
  String yEliminated2(String opponent) {
    return '$opponent turnuvasında elendik. Şimdi soruşturma zamanı.';
  }

  @override
  String yEliminated3(String opponent) {
    return '$opponent yolunda elendik. Biri bunu bana açıklasın.';
  }

  @override
  String yQualified0(String opponent) {
    return '$opponent İÇİN YOLA ÇIKIYORUZ.';
  }

  @override
  String yQualified1(String opponent) {
    return '$opponent için katılma hakkı kazandık. İzninizi alın.';
  }

  @override
  String yQualified2(String opponent) {
    return '$opponent, geliyoruz. Hiç şüphe yoktu (aslında tamamen şüpheliydi).';
  }

  @override
  String yQualified3(String opponent) {
    return '$opponent yolunda tamam. Zor kısım bitti.';
  }

  @override
  String yGroupDrawn0(String opponent) {
    return '$opponent kurası çekildi. Daha kötü olabilirdi. Çok daha kötü.';
  }

  @override
  String yGroupDrawn1(String opponent) {
    return 'Demek $opponent kurası bu. İlginç.';
  }

  @override
  String yGroupDrawn2(String opponent) {
    return '$opponent grupları belli oldu ve bizimkini şimdiden sevmedim.';
  }

  @override
  String yGroupDrawn3(String opponent) {
    return '$opponent kurası tamam. Abartı başlasın.';
  }

  @override
  String yHostNamed0(String opponent) {
    return 'Ev sahibi: $opponent. Birikim yapmaya başla.';
  }

  @override
  String yHostNamed1(String opponent) {
    return 'Ev sahibi $opponent oldu. Tahmin edilebilir, ama olsun.';
  }

  @override
  String yHostNamed2(String opponent) {
    return 'Turnuva $opponent ülkesine verildi. Onlara tebrikler, sanırım.';
  }

  @override
  String yHostNamed3(String opponent) {
    return 'Ev sahibi onaylandı: $opponent.';
  }

  @override
  String yTournamentSoon0(String opponent) {
    return '$opponent yakında başlıyor ve yerimde duramıyorum.';
  }

  @override
  String yTournamentSoon1(String opponent) {
    return '$opponent için çok az kaldı.';
  }

  @override
  String yTournamentSoon2(String opponent) {
    return '$opponent neredeyse geldi. Kadro açıklaması lütfen.';
  }

  @override
  String yTournamentSoon3(String opponent) {
    return '$opponent geri sayımı resmen dayanılmaz.';
  }

  @override
  String get navY => 'Y';

  @override
  String get yTitle => 'Y';

  @override
  String get yEmpty => 'Henüz söylenecek bir şey yok. Bir maç oyna.';

  @override
  String get yEarlierHeading => 'Bu dönemin başı';

  @override
  String get yTraitLoyalist =>
      'Ne olursa olsun takımın yanında. Geç döner, çabuk affeder.';

  @override
  String get yTraitCynic =>
      'Hep en kötüsünü bekler ve haklı çıkınca keyiflenir.';

  @override
  String get yTraitNostalgic =>
      'Her şey eskiden daha iyiydi. Seni futbolu bırakmış adamlarla kıyaslar.';

  @override
  String get yTraitStatshead =>
      'Sadece rakamları paylaşır. Ruh hali neredeyse yok.';

  @override
  String get yTraitHypeman => 'İki iyi sonuç ve altın nesil geldi.';

  @override
  String get yTraitContrarian => 'Ortam ne düşünürse, tam tersini.';

  @override
  String get yTraitDoomer => 'Kötü gidecek. Hep kötü gidecek.';

  @override
  String get yProfilePosts => 'GÖNDERİLER';

  @override
  String get yProfileEmpty => 'Bu hesaptan henüz bir şey yok.';

  @override
  String hubEventGrievance(String player) {
    return '$player seninle konuşmak istiyor';
  }

  @override
  String get hubEventGrievanceSub => 'Kendi durumunu öğrenmek istiyor';

  @override
  String hubEventManagerSkills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Harcanacak $count beceri puanı',
      one: 'Harcanacak 1 beceri puanı',
    );
    return '$_temp0';
  }

  @override
  String get hubEventManagerSkillsSub =>
      'İyi olduğun şeyler takımını da iyileştirir';

  @override
  String get grievanceTitle => 'Odanda bir konuşma';

  @override
  String grievanceGameTime(String player) {
    return '$player kadroda ama topa dokunmadı. Nedenini bilmek istiyor.';
  }

  @override
  String grievanceSquadPlace(String player) {
    return '$player kadroda değil ve bunu anlayamıyor. Evet ya da hayır, ona söylemen gerek.';
  }

  @override
  String grievanceRole(String player) {
    return '$player sürekli yerinde oynatılmıyor ve buna artık dayanamıyor.';
  }

  @override
  String get grievanceReassure => 'Planlarımdasın';

  @override
  String get grievanceHonest => 'Başkalarının gerisindesin, nedeni şu';

  @override
  String get grievanceDismiss => 'Takımı ben seçerim';

  @override
  String yScorerStar0(String name, String goals) {
    return '$name bunların $goals tanesini attı. Yakınında kimse yok.';
  }

  @override
  String yScorerStar1(String name, String goals) {
    return '$name için $goals gol. Bu takımı sırtlıyor.';
  }

  @override
  String yScorerStar2(String name, String goals) {
    return '$name: bugün $goals gol. Ne oyuncu.';
  }

  @override
  String yScorerStar3(String name, String goals) {
    return '$name onlara $goals gol bıraktı. Alkışları hak etti.';
  }

  @override
  String yScorerStar4(String name, String goals) {
    return '$name için $goals gol, diğerleri yolcuydu.';
  }

  @override
  String yScorerStar5(String name, String goals) {
    return 'Yine $name. $goals. Bu takımı onsuz bir düşün.';
  }

  @override
  String yScorerStar6(String name, String goals) {
    return '$name $goals gol attı. Bir adam bu kadar yükü taşımamalı.';
  }

  @override
  String yScorerStar7(String name, String goals) {
    return 'Bu maçtan $name çıkarsa $goals gol eksik ve bambaşka bir öğleden sonra olur.';
  }

  @override
  String yWinStreak0(String count) {
    return 'Üst üste $count. Soyunma odasında ne söyleniyorsa, tutuyor.';
  }

  @override
  String yWinStreak1(String count) {
    return 'Üst üste $count oldu. Takımlar böyle serilere tesadüfen girmez.';
  }

  @override
  String yWinStreak2(String count) {
    return 'Üst üste $count ve devam ediyor. Özgüven tribünden görülüyor.';
  }

  @override
  String yWinStreak3(String count) {
    return '$count maçtır yenilgi yok. Teknik direktörlük yapan herkese sor: zor olan bu.';
  }

  @override
  String yWinStreak4(String count) {
    return 'Üst üste $count. Fikstür yüze güldüğü sürece tadını çıkar.';
  }

  @override
  String yWinStreak5(String count) {
    return 'Üst üste $count ve kayda değer kimseyi yenmedik.';
  }

  @override
  String yWinStreak6(String count) {
    return '$count maçlık seri. Sınandığında tekrar sor.';
  }

  @override
  String yWinStreak7(String count) {
    return 'Üst üste $count. Her takımın içinde bir kez böyle bir seri vardır.';
  }

  @override
  String yLossStreak0(String count) {
    return '$count maçtır galibiyet yok. Bir noktada bahaneler biter.';
  }

  @override
  String yLossStreak1(String count) {
    return 'Üst üste $count maç gitti. Bu artık bir aksama değil.';
  }

  @override
  String yLossStreak2(String count) {
    return 'Üst üste $count yenilgi. Birinin bunun hesabını vermesi gerek.';
  }

  @override
  String yLossStreak3(String count) {
    return '$count maçtır galibiyet yok. Oyunlarından belli oluyor.';
  }

  @override
  String yLossStreak4(String count) {
    return '$count maçtır galibiyet yok ve her hafta aynı hatalar.';
  }

  @override
  String yLossStreak5(String count) {
    return 'Üst üste $count. Ne deneniyorsa, işe yaramıyor.';
  }

  @override
  String yLossStreak6(String count) {
    return 'Üst üste $count. Bu bir düşüş değil, bir yön.';
  }

  @override
  String yLossStreak7(String count) {
    return '$count maçtır galibiyet yok ve yukarıdaki kimse tek kelime etmedi.';
  }

  @override
  String yRivalry0(String opponent, String score) {
    return '$opponent $score. Futbol için ne istersen söyle. Bu maç çift sayılır.';
  }

  @override
  String yRivalry1(String opponent, String score) {
    return 'Hem de $opponent karşısında. $score. Burada kimse unutmayacak.';
  }

  @override
  String yRivalry2(String opponent, String score) {
    return '$opponent karşısında $score. Kahvehanelerde konuşulacak maç bu.';
  }

  @override
  String yRivalry3(String opponent, String score) {
    return 'Komşular, $score. Caka satma hakkı bir süre için çözüldü.';
  }

  @override
  String yRivalry4(String opponent, String score) {
    return '$opponent $score. Bu yıl başka ne olursa olsun, bu var.';
  }

  @override
  String yRivalry5(String opponent, String score) {
    return '$opponent karşısında $score. Bazılarımızın buna puan tablosundan daha çok ihtiyacı vardı.';
  }

  @override
  String yRivalry6(String opponent, String score) {
    return '$opponent $score. Gelecek sefer geri alacaklar, hep alırlar.';
  }

  @override
  String yRivalry7(String opponent, String score) {
    return '$opponent karşısında $score. Bütün bir yıl boyunca bunu hatırlatacaklar.';
  }

  @override
  String yInjuryBlow0(String name) {
    return '$name sakatlanıp çıktı. Bu takımın en son ihtiyacı buydu.';
  }

  @override
  String yInjuryBlow1(String name) {
    return '$name kaybı her şeyin şeklini değiştirir.';
  }

  @override
  String yInjuryBlow2(String name) {
    return '$name topallıyor. Nefesini tut.';
  }

  @override
  String yInjuryBlow3(String name) {
    return 'Demek bir süre $name yok. Birinin sorumluluk alması gerek.';
  }

  @override
  String yInjuryBlow4(String name) {
    return '$name dışarıda. Tabii ki $name.';
  }

  @override
  String yInjuryBlow5(String name) {
    return '$name olmadan bu çok sıradan bir takım olur.';
  }

  @override
  String yInjuryBlow6(String name) {
    return '$name yine sakatlandı. Birinin nedenini sorması gerek.';
  }

  @override
  String yInjuryBlow7(String name) {
    return '$name kayıp ve arkasında kimse yok. Asıl sorun bu.';
  }

  @override
  String ySentOff0(String name, String minute) {
    return '$name için $minute. dakikada kırmızı ve bütün ülke ona dönüyor. Bize çoğundan fazlasını verdi. Bırakın.';
  }

  @override
  String ySentOff1(String name, String minute) {
    return '$name $minute. dakikada oyundan atıldı. Sert. On kişi kaldık ve yine de denedik, bu bir şey söylüyor.';
  }

  @override
  String ySentOff2(String name, String minute) {
    return '$name, $minute. dakika, kırmızı kart. Buradan sonrası on kişi.';
  }

  @override
  String ySentOff3(String name, String minute) {
    return 'Oyundan atılma: $name, $minute. dakikada. Tek bir kararla dönen ilk maç değil.';
  }

  @override
  String ySentOff4(String name, String minute) {
    return 'Harika. $name $minute. dakikada gidiyor ve on kişi kaldık. Yine.';
  }

  @override
  String ySentOff5(String name, String minute) {
    return '$name $minute. dakikada oyundan atıldı. Burada disiplini tam olarak kim çalıştırıyor?';
  }

  @override
  String ySentOff6(String name, String minute) {
    return '$minute dakika. $name aklını bu kadar tutabildi. Profesyonel futbol.';
  }

  @override
  String ySentOff7(String name, String minute) {
    return '$name için $minute. dakikada kırmızı ve bunun ilerleme olduğuna inanmam bekleniyor.';
  }

  @override
  String get yBoardPressure0 =>
      'Yönetim çok sessizleşti. Bu hiçbir zaman iyi işaret değildir.';

  @override
  String get yBoardPressure1 =>
      'Duyduğuma göre yönetim kurulu soru sormaya başlamış.';

  @override
  String get yBoardPressure2 => 'Yukarıda zeminin kaydığını hissedebilirsin.';

  @override
  String get yBoardPressure3 =>
      'Federasyonda kimse destekleyici bir şey söylemiyor. Sonucu kendin çıkar.';

  @override
  String get yBoardPressure4 =>
      'Haftalardır yukarıdan kimse onu herkesin önünde savunmadı.';

  @override
  String get yBoardPressure5 =>
      'Federasyon kendi teknik direktörüne karşı mesaj veriyor. Her zamanki gibi.';

  @override
  String get yBoardPressure6 => 'Bir yönetim sustuysa, çoktan karar vermiştir.';

  @override
  String get yBoardPressure7 =>
      'Karar başkasının olana kadar bunun akışına bırakacaklar.';

  @override
  String get yReplies => 'BU MAÇLA İLGİLİ DİĞERLERİ';

  @override
  String get yPlayerGrievance0 => 'Durumumu sordum. Hâlâ cevap bekliyorum.';

  @override
  String get yPlayerGrievance1 =>
      'Sıkı çalışıyorum. Yapabileceğim başka bir şey yok.';

  @override
  String get yPlayerGrievance2 => 'Bazı soruları sadece bir kez sorabilirsin.';

  @override
  String get yPlayerGrievance3 =>
      'Yeleklere bakmak için buraya kadar gelmedim.';

  @override
  String get playerHonoursTitle => 'BAŞARILAR';

  @override
  String get awardGoldenBall => 'Altın Top';

  @override
  String get awardGoldenBoot => 'Altın Ayakkabı';

  @override
  String get awardGoldenGlove => 'Altın Eldiven';

  @override
  String get awardTeamOfTournament => 'Turnuvanın En İyi 11\'i';

  @override
  String get awardPlayerOfYear => 'Yılın Dünya Oyuncusu';

  @override
  String get awardYoungPlayerOfYear => 'Yılın Genç Oyuncusu';

  @override
  String get playerClubHistory => 'KULÜP GEÇMİŞİ';

  @override
  String get playerCareerRecord => 'KARİYER REKORU';

  @override
  String get playerInternationalGoals => 'Milli takım golleri';

  @override
  String get playerRecentForm => 'SON FORM';

  @override
  String get playerMatchHistory => 'MAÇ GEÇMİŞİ';

  @override
  String get playerAttributes => 'ÖZELLİKLER';

  @override
  String get playerUnknown => 'Bilinmiyor';

  @override
  String get playerAttrPace => 'Hız';

  @override
  String get playerAttrPhysical => 'Fiziksel';

  @override
  String get playerAttrTechnical => 'Teknik';

  @override
  String get playerAttrShooting => 'Şut';

  @override
  String get playerAttrPassing => 'Pas';

  @override
  String get playerAttrDribbling => 'Dribling';

  @override
  String get playerAttrTackling => 'Top kapma';

  @override
  String get playerAttrPositioning => 'Pozisyon alma';

  @override
  String get playerAttrComposure => 'Soğukkanlılık';

  @override
  String get playerAttrDecisions => 'Karar verme';

  @override
  String get playerAttrStamina => 'Dayanıklılık';

  @override
  String get playerAttrStrength => 'Güç';

  @override
  String get playerStatCaps => 'Milli maç';

  @override
  String get playerStatGoals => 'Gol';

  @override
  String get playerStatAssists => 'Asist';

  @override
  String get playerStatAvgRating => 'Ort. puan';

  @override
  String get playerStatForm => 'Form';

  @override
  String get playerStatMotm => 'Maçın adamı';

  @override
  String get playerStatCleanSheets => 'Gol yemeden maç';

  @override
  String get playerStatBestGame => 'En iyi maç';

  @override
  String get playerStatCards => 'Kartlar';

  @override
  String playerCardsValue(int yellows, int reds) {
    return '${yellows}S ${reds}K';
  }

  @override
  String get tourSharedYourRun => 'SENİN YOLCULUĞUN';

  @override
  String get tourSharedList => 'Liste';

  @override
  String get tourSharedBracket => 'Tablo';

  @override
  String get tourSharedVs => 'vs';

  @override
  String tourSharedGroupSeed(String seed) {
    return 'Grup $seed';
  }

  @override
  String get tourSharedThisEdition => 'Bu organizasyon';

  @override
  String get tourSharedAllTime => 'Tüm zamanlar';

  @override
  String get tourSharedUnknown => 'Bilinmiyor';

  @override
  String get tourSharedActive => 'AKTİF';

  @override
  String get tourSharedMedalTable => 'MADALYA TABLOSU';

  @override
  String get tourSharedPastWinners => 'GEÇMİŞ ŞAMPİYONLAR';

  @override
  String tourSharedHost(String host) {
    return 'Ev sahibi: $host';
  }

  @override
  String get tourSharedBeat => 'yendi';

  @override
  String get tourSharedPens => ' (pen.)';

  @override
  String get tourSharedAwardsEmpty =>
      'Ödüller turnuva tamamlanınca belli olur.';

  @override
  String get tourSharedGoldenBall => 'ALTIN TOP';

  @override
  String get tourSharedPlayerOfTournament => 'Turnuvanın Oyuncusu';

  @override
  String get tourSharedGoldenBoot => 'ALTIN AYAKKABI';

  @override
  String tourSharedGoalsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gol',
      one: '1 gol',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedGoldenGlove => 'ALTIN ELDİVEN';

  @override
  String get tourSharedTeamOfTournament => 'TURNUVANIN EN İYİ 11\'İ';

  @override
  String get tourSharedStatsEmpty =>
      'Rekorlar, organizasyonun biraz geçmişi olunca görünür.';

  @override
  String get tourSharedRecordScorer => 'REKORTMEN GOLCÜ';

  @override
  String get tourSharedStillActive => 'hâlâ aktif';

  @override
  String get tourSharedMostTitles => 'EN ÇOK ŞAMPİYONLUK';

  @override
  String tourSharedTitlesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count şampiyonluk',
      one: '1 şampiyonluk',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostFinals => 'EN ÇOK FİNAL';

  @override
  String tourSharedFinalsContested(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count final oynandı',
      one: '1 final oynandı',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostGamesPlayed => 'EN ÇOK MAÇA ÇIKANLAR';

  @override
  String tourSharedMatchesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count maç',
      one: '1 maç',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostFinalsPlayed => 'EN ÇOK FİNAL OYNAYANLAR';

  @override
  String tourSharedFinalsTournamentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count final turnuvası',
      one: '1 final turnuvası',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedBiggestFinalWin => 'EN BÜYÜK FİNAL GALİBİYETİ';

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
  String get tourStatsStillActive => 'hâlâ aktif';

  @override
  String tourStatsTitles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count şampiyonluk',
      one: '1 şampiyonluk',
    );
    return '$_temp0';
  }

  @override
  String tourStatsFinalsContested(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count final oynandı',
      one: '1 final oynandı',
    );
    return '$_temp0';
  }

  @override
  String tourStatsMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count maç',
      one: '1 maç',
    );
    return '$_temp0';
  }

  @override
  String tourStatsFinalsTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count final turnuvası',
      one: '1 final turnuvası',
    );
    return '$_temp0';
  }

  @override
  String get tourStatsLeaders => 'TÜM ZAMANLARIN LİDERLERİ';

  @override
  String get tourStatsTabGames => 'Maçlar';

  @override
  String get tourStatsTabCups => 'Kupalar';

  @override
  String get tourStatsTabScorers => 'Golcüler';

  @override
  String tourSharedFinalWinDetail(String opponent, int year) {
    return 'vs $opponent · $year';
  }

  @override
  String get tourHolders => 'KUPA SAHİBİ';

  @override
  String tourHoldersSince(int year) {
    return '$year şampiyonu';
  }

  @override
  String get tourSharedAllTimeScorers => 'TÜM ZAMANLARIN GOLCÜLERİ';

  @override
  String get tourSharedSummaryEmpty =>
      'Ev sahibi ve stadyumlar, bu organizasyonun kurası çekilince görünür.';

  @override
  String get tourSharedHostHeading => 'EV SAHİBİ';

  @override
  String get tourSharedHostsHeading => 'EV SAHİPLERİ';

  @override
  String get tourSharedCoHostsHeading => 'ORTAK EV SAHİPLERİ';

  @override
  String get tourSharedVenues => 'STADYUMLAR';

  @override
  String get tourSharedMascot => 'MASKOT';

  @override
  String get tourSharedMatchBall => 'MAÇ TOPU';

  @override
  String tourSharedVenueSeats(String city, String capacity) {
    return '$city · $capacity koltuk';
  }

  @override
  String get tourSharedCouldNotLoad => 'Yüklenemedi.';

  @override
  String get tourSharedHostTbc => 'EV SAHİBİ HENÜZ BELLİ DEĞİL';

  @override
  String get tourSharedFinalsAreHere => 'FİNAL TURNUVASI BAŞLIYOR';

  @override
  String tourSharedHostedBy(String hosts) {
    return 'EV SAHİBİ:  $hosts';
  }

  @override
  String get tourSharedLetFinalsBegin => 'Final turnuvası başlasın';

  @override
  String get tourSharedCompetitions => 'ORGANİZASYONLAR';

  @override
  String get tourSharedWorldRanking => 'Dünya sıralaması';

  @override
  String get tourSharedCouldNotLoadTournaments => 'Turnuvalar yüklenemedi.';

  @override
  String get tourSharedPrestigeStage => 'PRESTİJ SAHNESİ';

  @override
  String get tourSharedOverview => 'Genel bakış';

  @override
  String get tourSharedWorldRankingTitle => 'Dünya Sıralaması';

  @override
  String get tourSharedYourCompetitions => 'ORGANİZASYONLARIN';

  @override
  String get tourSharedOtherContinents => 'DİĞER KITALAR';

  @override
  String get tourSharedComingSoon => 'Turnuva yakında';

  @override
  String get tourSharedSoon => 'YAKINDA';

  @override
  String get tourSharedNoQualifyingDraw => 'Eleme kurası yok.';

  @override
  String get tourSharedOpenEnvelope => 'Zarfı aç';

  @override
  String tourSharedGroupName(String name) {
    return '$name GRUBU';
  }

  @override
  String get tourSharedBall => 'Top';

  @override
  String get tourSharedPot => 'Torba';

  @override
  String get tourSharedAll => 'Hepsi';

  @override
  String get tourSharedTapDrawTeam => 'Sıradaki takımı çekmek için dokun';

  @override
  String get tourSharedTapDrawPot => 'Sıradaki torbayı çekmek için dokun';

  @override
  String get tourSharedTapDrawAll => 'Tüm kurayı görmek için dokun';

  @override
  String get tourSharedContinue => 'Devam';

  @override
  String get tourSharedPause => 'Duraklat';

  @override
  String get tourSharedPlay => 'Oynat';

  @override
  String get tourSharedSkip => 'Geç';

  @override
  String tourSharedPotNumber(int number) {
    return '$number. TORBA';
  }

  @override
  String get tourSharedDrawComplete => 'KURA TAMAMLANDI';

  @override
  String get tourSharedDrawing => 'KURA ÇEKİLİYOR…';

  @override
  String get tourContChampionship => 'ŞAMPİYONA';

  @override
  String get tourContTabSummary => 'ÖZET';

  @override
  String get tourContTabQualifying => 'ELEMELER';

  @override
  String get tourContTabFinals => 'FİNALLER';

  @override
  String get tourContTabBracket => 'TABLO';

  @override
  String get tourContTabAwards => 'ÖDÜLLER';

  @override
  String get tourContTabScorers => 'GOLCÜLER';

  @override
  String get tourContTabHistory => 'GEÇMİŞ';

  @override
  String get tourContTabRecords => 'REKORLAR';

  @override
  String tourContCouldNotLoadCup(String error) {
    return 'Kupa yüklenemedi.\n$error';
  }

  @override
  String get tourContNoCupData => 'Kupa verisi yok.';

  @override
  String get tourContUnknown => 'Bilinmiyor';

  @override
  String get tourContGroupsToBeDrawnQual =>
      'Eleme grupları törende çekilir. Kiminle karşılaşacağını görmek için merkezden izle.';

  @override
  String get tourContQualSeeded =>
      'Ülken doğrudan final turnuvasına ayrıldı. Bu dönem eleme yok.';

  @override
  String tourContBackgroundRegion(String name) {
    return '$name arka planda simüle edilir. Sonuçlar her tur oynandıkça burada görünür.';
  }

  @override
  String get tourContGroupsToBeDrawnFinals =>
      'Final grupları törende çekilir. Grubunu görmek için merkezden izle.';

  @override
  String get tourContFinalsDrawAfterQual =>
      'Final kurası, elemeler tamamlandıktan sonra yapılır.';

  @override
  String get tourContContestedBeforeWc =>
      'Eleme turları Dünya Şampiyonası\'ndan önce oynanır.';

  @override
  String tourContChampionsHeading(String name) {
    return '$name ŞAMPİYONLARI';
  }

  @override
  String tourContWinnersTitle(String name) {
    return '$name kazananları';
  }

  @override
  String get tourContNoGoalsYet => 'Henüz gol atılmadı.';

  @override
  String tourContGroupHeading(String name) {
    return '$name GRUBU';
  }

  @override
  String get tourContBestRunnersUp => 'EN İYİ İKİNCİLER';

  @override
  String tourContGroupDropdown(String name) {
    return '$name Grubu';
  }

  @override
  String get tourContMatches => 'MAÇLAR';

  @override
  String get tourContNoGroupsDrawn => 'Henüz grup çekilmedi.';

  @override
  String get tourContQualifyingDraw => 'ELEME KURASI';

  @override
  String get tourContWorldQualifyingDraw => 'DÜNYA ELEME KURASI';

  @override
  String get tourContFinalsDraw => 'FİNAL KURASI';

  @override
  String get tourContSeedingPots => 'AYRILMIŞ TORBALAR';

  @override
  String get tourContGroupDraw => 'GRUP KURASI';

  @override
  String tourContCouldNotLoadDraw(String error) {
    return 'Kura yüklenemedi.\n$error';
  }

  @override
  String get tourContDrawNotReady => 'Kura henüz hazır değil.';

  @override
  String get tourContContinentalClash => 'KITALAR ARASI ÇARPIŞMA';

  @override
  String get tourContTabThisCycle => 'BU DÖNEM';

  @override
  String tourContCouldNotLoadClash(String error) {
    return 'Yüklenemedi.\n$error';
  }

  @override
  String get tourContNoSaveFound => 'Kayıt bulunamadı.';

  @override
  String get tourContClashSoon =>
      'Kıtalar Arası Çarpışma, iki kıta şampiyonu da belli olunca oynanır.';

  @override
  String get tourContTwoContinentsOneMatch => 'İKİ KITA, TEK MAÇ';

  @override
  String get tourContVersusShort => 'vs';

  @override
  String tourContWinTheClash(String name) {
    return 'Çarpışmayı $name kazandı';
  }

  @override
  String get tourContNoClashYet => 'Henüz Kıtalar Arası Çarpışma oynanmadı.';

  @override
  String get tourContNationsCup => 'ULUSLAR KUPASI';

  @override
  String get tourContTabLeagues => 'LİGLER';

  @override
  String get tourContTabFinalsFour => 'FİNAL DÖRTLÜSÜ';

  @override
  String tourContCouldNotLoad(String error) {
    return 'Yüklenemedi.\n$error';
  }

  @override
  String get tourContNoNationsCupGoals =>
      'Uluslar Kupası\'nda henüz gol kaydedilmedi.';

  @override
  String get tourContNoNationsCupChampions =>
      'Henüz Uluslar Kupası şampiyonu yok.';

  @override
  String get tourContNationsCupOffSeason =>
      'Bu dönemin Uluslar Kupası kıta finallerinden sonra başlar. Geçmiş kazananlar Geçmiş bölümünde.';

  @override
  String get tourContNationsCupGroupsSoon =>
      'Bu dönemin Uluslar Kupası grupları törende çekilir. Rakiplerini görmek için merkezden izle.';

  @override
  String get tourContLeagueNoGroups => 'Bu turda bu ligde maç yok.';

  @override
  String tourContLeagueHeading(String letter) {
    return '$letter LİGİ';
  }

  @override
  String tourContLeagueHeadingYours(String letter) {
    return '$letter LİGİ · SENİN LİGİN';
  }

  @override
  String get tourContFinalsFourSoon =>
      'Final Dörtlüsü, grup aşaması bittiğinde A Ligi grup birincileri arasında oynanır.';

  @override
  String tourContLeagueChip(String letter) {
    return '$letter Ligi';
  }

  @override
  String tourContLeagueChipStar(String letter) {
    return '$letter Ligi ★';
  }

  @override
  String get tourContSemiFinals => 'YARI FİNALLER';

  @override
  String get tourContFinal => 'FİNAL';

  @override
  String get tourContNationsCupDraw => 'ULUSLAR KUPASI KURASI';

  @override
  String get tourContIntercontinentalPlayoff => 'KITALAR ARASI PLAY-OFF';

  @override
  String get tourContNoPlayoffThisCycle => 'Bu dönem play-off yok.';

  @override
  String get tourContPlayoffIntro =>
      'İki Dünya Şampiyonası bileti, elemeyi en iyi tamamlayan ekipler arasındaki eleme turlarında belli olur.';

  @override
  String get tourContPlayoffThrough =>
      'Play-off\'u geçtin. Dünya Şampiyonası\'ndasın!';

  @override
  String get tourContPlayoffOut =>
      'Play-off\'ta yetmedi. Bu kez Dünya Şampiyonası yok.';

  @override
  String get tourContContinue => 'Devam';

  @override
  String get tourContPlayoffFinals => 'PLAY-OFF FİNALLERİ';

  @override
  String get tourContPlayoffSeeded => 'Ayrılmış (bay)';

  @override
  String get tourCupTabSummary => 'ÖZET';

  @override
  String get tourCupTabQualifying => 'ELEMELER';

  @override
  String get tourCupTabPlayoff => 'PLAY-OFF';

  @override
  String get tourCupPlayoffSoon =>
      'Kıtalar arası play-off, tüm konfederasyonların elemeleri bitince belli olur.';

  @override
  String get tourCupTabFinals => 'FİNALLER';

  @override
  String get tourCupTabBracket => 'TABLO';

  @override
  String get tourCupTabAwards => 'ÖDÜLLER';

  @override
  String get tourCupTabScorers => 'GOLCÜLER';

  @override
  String get tourCupTabHistory => 'GEÇMİŞ';

  @override
  String get tourCupTabRecords => 'REKORLAR';

  @override
  String get tourCupTitle => 'DÜNYA ŞAMPİYONASI';

  @override
  String get tourCupNoData => 'Turnuva verisi yok.';

  @override
  String tourCupLoadError(String error) {
    return 'Turnuva yüklenemedi.\n$error';
  }

  @override
  String get tourCupUnknown => 'Bilinmiyor';

  @override
  String get tourCupWorldChampions => 'DÜNYA ŞAMPİYONLARI';

  @override
  String get tourCupWorldChampionsTitle => 'Dünya Şampiyonları';

  @override
  String get tourCupStillActive => 'Hâlâ aktif';

  @override
  String get tourCupAllTimeScorers => 'TÜM ZAMANLARIN GOLCÜLERİ';

  @override
  String get tourCupAllConfederations => 'Tüm konfederasyonlar';

  @override
  String get tourCupBestRunnersUp => 'En iyi ikinciler';

  @override
  String get tourCupCompWorld => 'Dünya Şampiyonası';

  @override
  String get tourCupCompEurope => 'Avrupa Şampiyonası';

  @override
  String get tourCupCompSAmerica => 'Güney Amerika Kupası';

  @override
  String get tourCupDestRoundOf16 => 'son 16 turuna';

  @override
  String get tourCupDestKnockouts => 'eleme turlarına';

  @override
  String get tourCupDestFinals => 'final turnuvasına';

  @override
  String get tourCupDestFinalsPlayoff => 'final turnuvası play-off\'una';

  @override
  String get tourCupDestIntercontPlayoff => 'kıtalar arası play-off\'a';

  @override
  String get tourCupFinalsDrawnAfterQual =>
      'Final turnuvasının kurası elemeler bitince çekilir.';

  @override
  String get tourCupFinalsDrawSoon =>
      'Gruplar henüz çekilmedi. Açıklamak için Dünya Şampiyonası kurasını merkezden izle.';

  @override
  String tourCupGroupName(String name) {
    return '$name Grubu';
  }

  @override
  String tourCupGroupNameShort(String name) {
    return '$name Grubu';
  }

  @override
  String tourCupHostLabel(String host) {
    return 'Ev sahibi: $host';
  }

  @override
  String tourCupHostLabelMulti(String hosts) {
    return 'Ev sahipleri: $hosts';
  }

  @override
  String get tourCupIntercontPlayoff => 'Kıtalar arası play-off';

  @override
  String get tourCupKnockoutSoon => 'Tablo, grup aşaması bitince başlar.';

  @override
  String get tourCupMatches => 'MAÇLAR';

  @override
  String get tourCupMedalTable => 'MADALYA TABLOSU';

  @override
  String get tourCupMostTitles => 'EN ÇOK ŞAMPİYONLUK';

  @override
  String tourCupMostTitlesValue(String nation, int titles, int editions) {
    return '$nation: $editions turnuvada $titles şampiyonluk';
  }

  @override
  String get tourCupNoGoals => 'Henüz gol yok.';

  @override
  String get tourCupNoGroups => 'Çekilmiş grup yok.';

  @override
  String get tourCupNoHistory => 'Henüz geçmiş yok.';

  @override
  String get tourCupPastWinners => 'GEÇMİŞ KAZANANLAR';

  @override
  String get tourCupPlayoffIntro =>
      'İki Dünya Şampiyonası bileti, elemeyi en iyi tamamlayan ekipler arasındaki eleme turlarında belli olur.';

  @override
  String tourCupPlayoffNoEntrants(String confederation) {
    return '$confederation: play-off yok. Tüm kontenjanlar eleme gruplarında belirlenir.';
  }

  @override
  String get tourCupQualDrawSoon =>
      'Gruplar henüz çekilmedi. Açıklamak için eleme kurasını merkezden izle.';

  @override
  String tourCupRegionYours(String region) {
    return '$region · senin';
  }

  @override
  String tourCupScorePens(int home, int away) {
    return '$home–$away (pen.)';
  }

  @override
  String get tourCupSegAllTime => 'Tüm zamanlar';

  @override
  String get tourCupSegFinals => 'Finaller';

  @override
  String get tourCupSegQualifying => 'Elemeler';

  @override
  String get playerTraitsTitle => 'ŞÖHRETİ';

  @override
  String get traitBigGame => 'Büyük maç oyuncusu';

  @override
  String get traitBigGameBlurb =>
      'Eleme turlarındaki maçlarda seviyesini yükseltir.';

  @override
  String get traitSetPiece => 'Duran top uzmanı';

  @override
  String get traitSetPieceBlurb =>
      'Daha iyi orta açar, duran toplardan daha çok gol atar.';

  @override
  String get traitHothead => 'Asabi';

  @override
  String get traitHotheadBlurb =>
      'Takım arkadaşlarından çok daha fazla kart görür.';

  @override
  String get traitIronMan => 'Demir adam';

  @override
  String get traitIronManBlurb => 'Nadiren sakatlanır, daha geç yorulur.';

  @override
  String get traitWonderkid => 'Parlak yetenek';

  @override
  String get traitWonderkidBlurb =>
      'Genç, şimdiden iyi ve hızla gelişmeye devam ediyor.';

  @override
  String get traitLeader => 'Lider';

  @override
  String get traitLeaderBlurb => 'Sahadaki her takım arkadaşını yukarı çeker.';

  @override
  String get traitPacey => 'Hızlı';

  @override
  String get traitPaceyBlurb =>
      'Çok hızlı, savunmanın arkasında sürekli tehdit.';

  @override
  String get traitOldHead => 'Tecrübeli';

  @override
  String get traitOldHeadBlurb =>
      'Oyun okuması bacaklarından daha uzun yaşayan bir veteran.';

  @override
  String get traitWasteful => 'Pozisyon harcar';

  @override
  String get traitWastefulBlurb => 'Çok sayıda net pozisyonu auta atar.';

  @override
  String get objectiveWorldCup => 'Dünya Şampiyonası';

  @override
  String get objectiveWinTournament => 'Şampiyon ol';

  @override
  String get objectiveQualifyGeneric => 'Katılma hakkı kazan';

  @override
  String hubBoardObjectiveFor(String competition, String label) {
    return '$competition: $label';
  }

  @override
  String get objectiveWinWorldCup => 'Dünya Şampiyonası\'nı kazan';

  @override
  String get objectiveReachFinal => 'Finale çık';

  @override
  String get objectiveReachSemis => 'Yarı finale çık';

  @override
  String get objectiveReachQuarters => 'Çeyrek finale çık';

  @override
  String get objectiveReachKnockouts => 'Eleme turlarına çık';

  @override
  String get objectiveQualify => 'Dünya Şampiyonası\'na katılma hakkı kazan';

  @override
  String get finishChampions => 'Şampiyon';

  @override
  String get finishRunnersUp => 'İkinci';

  @override
  String get finishSemiFinals => 'Yarı final';

  @override
  String get finishQuarterFinals => 'Çeyrek final';

  @override
  String get finishRoundOf16 => 'Son 16 turu';

  @override
  String get finishGroupStage => 'Grup aşaması';

  @override
  String get objectiveQualifyingTopHalf => 'Eleme grubunda ilk yarıda bitir';

  @override
  String get finishQualifyingTopHalf => 'Eleme grubunun ilk yarısı';

  @override
  String get finishQualifyingBottomHalf => 'Eleme grubunun alt yarısı';

  @override
  String get objectiveNcWinIt => 'Uluslar Kupası\'nı kazan';

  @override
  String get objectiveNcReachFinal => 'Uluslar Kupası finaline çık';

  @override
  String get objectiveNcFinalsFour => 'Final Dörtlüsü\'ne kal';

  @override
  String get objectiveNcWinGroup => 'Grubunu kazan ve yüksel';

  @override
  String get objectiveNcTopHalf => 'Grubunda ilk yarıda bitir';

  @override
  String get objectiveNcSurvive => 'Küme düşmekten kaçın';

  @override
  String get objectiveNcOffTheBottom => 'Grubu son sırada bitirme';

  @override
  String get finishNcChampions => 'Uluslar Kupası şampiyonu';

  @override
  String get finishNcFinalsFour => 'Final Dörtlüsü';

  @override
  String get finishNcGroupWinners => 'Grup birincisi';

  @override
  String get finishNcTopHalf => 'Grubun ilk yarısı';

  @override
  String get finishNcStayedUp => 'Ligde kaldı';

  @override
  String get finishNcClearOfBottom => 'Grubun sonunda değil';

  @override
  String get finishNcBottom => 'Grubun sonu';

  @override
  String get careerNationsCupLabel => 'Uluslar Kupası';

  @override
  String get squadDevPlayer => 'OYUNCU';

  @override
  String get squadDevAge => 'YAŞ';

  @override
  String get squadDevPosition => 'MEV';

  @override
  String get squadDevChange => 'GÜÇ';

  @override
  String get squadDevNew => 'YENİ';

  @override
  String get squadDevRetired => 'BIRAKTI';

  @override
  String get squadDevEmpty => 'Sakin bir yıl. Kadroda değişiklik yok.';

  @override
  String get squadDevTierRegulars => 'DÜZENLİLER';

  @override
  String get squadDevTierFringe => 'YEDEKLER';

  @override
  String get squadDevTierYouth => 'GENÇLER';

  @override
  String get boardObjectivesTitle => 'Yönetim hedefleri';

  @override
  String get boardObjectivesConfidence => 'Yönetimin güveni';

  @override
  String boardObjectiveBeatenBy(String result, int rounds) {
    String _temp0 = intl.Intl.pluralLogic(
      rounds,
      locale: localeName,
      other: 'beklenenden $rounds tur iyi',
      one: 'beklenenden bir tur iyi',
    );
    return '$result: $_temp0';
  }

  @override
  String boardObjectiveShortBy(String result, int rounds) {
    String _temp0 = intl.Intl.pluralLogic(
      rounds,
      locale: localeName,
      other: '$rounds tur eksik',
      one: 'bir tur eksik',
    );
    return '$result: $_temp0';
  }

  @override
  String get boardObjectivesPending => 'HENÜZ BELLİ DEĞİL';

  @override
  String boardObjectiveSoFar(String result) {
    return 'ŞİMDİLİK · $result';
  }

  @override
  String get boardObjectivesEmpty => 'Yönetim bu dönem için hedef belirlemedi.';

  @override
  String get tourContBestWinners => 'EN İYİ GRUP BİRİNCİLERİ';

  @override
  String get tourContBestThirds => 'EN İYİ ÜÇÜNCÜLER';

  @override
  String tourContBestPlaced(String position) {
    return 'EN İYİ $position. SIRADAKİLER';
  }

  @override
  String squadDevPageOf(String page, String pages, String total) {
    return '$page/$pages · $total oyuncu';
  }

  @override
  String get matchSoldOut => 'BİLETLER TÜKENDİ';

  @override
  String matchAttendanceOf(String attendance, String capacity) {
    return 'Doluluk: $attendance / $capacity koltuk';
  }

  @override
  String get matchGroundTitle => 'STAT';

  @override
  String get absenceInjured => 'Sakat';

  @override
  String get absenceSuspended => 'Cezalı';

  @override
  String absenceWeeks(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString hafta',
      one: '1 hafta',
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
      other: '$countString maç',
      one: '1 maç',
    );
    return '$_temp0';
  }

  @override
  String absenceBackFor(String opponent) {
    return 'Dönüş: $opponent maçı';
  }

  @override
  String get penaltyOrderTitle => 'Penaltılar';

  @override
  String get penaltyOrderBlurb =>
      'Beş atıcını sırayla seç. Değiştirmek için bir yuvaya dokun.';

  @override
  String penaltyOrderPick(int number) {
    return '$number. vuruş';
  }

  @override
  String get penaltyOrderPickBlurb =>
      'Kimin atacağını seç. Çubuk, penaltı noktasındaki soğukkanlılığını gösterir.';

  @override
  String get penaltyOrderConfirm => 'Başlat';

  @override
  String get penaltyOrderCancel => 'Geri';

  @override
  String get youthTitle => 'Gençler';

  @override
  String get youthEmptyLevel => 'Bu kademede henüz kimse yok.';

  @override
  String get youthReleased => 'Bu yıl gönderilenler';

  @override
  String get u21Title => '21 Yaş Altı';

  @override
  String get u21Blurb =>
      'Yeni nesil, en parlak yetenek en başta. Boş yıldızlar gözlemcinin tahminidir. Gerçek gücünü görmek için oyuncuyu milli takıma çağır.';

  @override
  String get u21Empty =>
      'Havuzda şu an 21 yaş altı kimse yok. Yeni grup, yeni dönemle gelir.';

  @override
  String u21Breakout(int gain) {
    return 'BU YIL +$gain';
  }

  @override
  String u21AgeCaps(int age, int caps) {
    return 'Yaş $age · $caps milli maç';
  }

  @override
  String u21AgeUncapped(int age) {
    return 'Yaş $age · milli maçı yok';
  }

  @override
  String get u21CallUps => 'Kadro çağrılarına git';

  @override
  String get youthWatching => 'Takipte';

  @override
  String get youthWatchEmpty =>
      'Henüz kimse işaretlenmedi. Herhangi bir kademeden bir genci işaretle, ne olduğuyla birlikte burada görünsün.';

  @override
  String get youthWatchMark => 'Bu genci takip et';

  @override
  String get youthWatchUnmark => 'Takibi bırak';

  @override
  String youthWatchMarked(int rating, int age) {
    return 'İşaretlendiğinde: $rating, $age yaşında';
  }

  @override
  String get youthWatchSenior => 'A takım havuzuna geçti';

  @override
  String get youthWatchReleased => 'Akademi tarafından gönderildi';

  @override
  String get youthWatchGone => 'Artık yapının içinde değil';

  @override
  String get tacticsYouth => '21 Yaş Altı';

  @override
  String get pressSquad => 'Kadro';

  @override
  String get pressBoard => 'Yönetim';

  @override
  String get pressNoEffect => 'Kimse üzerinde pek durmuyor';

  @override
  String get matchNeutralGround => 'TARAFSIZ';

  @override
  String get matchExtraTimeAhead => 'UZATMALAR';

  @override
  String get matchExtraTimeHalf => 'UZATMALAR · ARA';

  @override
  String get matchClockFullTime => 'MAÇ SONU';

  @override
  String get matchClockAfterExtraTime => 'UZATMALARDAN SONRA';

  @override
  String get matchClockPenalties => 'PENALTILAR';

  @override
  String get matchClockFullTimePenalties => 'SON · PENALTILAR';

  @override
  String get hubEventPressConference => 'Basının karşısına çık';

  @override
  String get hubEventPressConferenceSub =>
      'Dünya basını ilk maçtan önce seninle konuşmak istiyor';

  @override
  String get squadDevWonderkid => 'PARLAK YETENEK';

  @override
  String get tacticsPlaystyle => 'Oyun tarzı';

  @override
  String get tacticsPlaystyleBlurb =>
      'Takımın nasıl oynayacağını seç; aşağıdaki ayarlar ince ayar yapar.';

  @override
  String get tacticsPlaystyleCustom =>
      'Kendi ayarların. Hiçbir hazır tarz bu ayarlara uymuyor.';

  @override
  String get playstyleCustom => 'Özel';

  @override
  String get playstyleBalanced => 'Dengeli';

  @override
  String get playstylePossession => 'Top hakimiyeti';

  @override
  String get playstyleGegenpress => 'Gegenpress';

  @override
  String get playstyleCounter => 'Kontra atak';

  @override
  String get playstyleDirect => 'Direkt oyun';

  @override
  String get playstyleLowBlock => 'Alçak blok';

  @override
  String get playstyleWingPlay => 'Kanat oyunu';

  @override
  String get playstyleBalancedBlurb =>
      'İki yarı sahada da sağlam, hiçbir şey abartılmadan.';

  @override
  String get playstylePossessionBlurb =>
      'Topu koru, sabırla çevir, sahayı daralt.';

  @override
  String get playstyleGegenpressBlurb =>
      'Top kaybedilir kaybedilmez, sahanın yukarısında geri kazan.';

  @override
  String get playstyleCounterBlurb =>
      'Geride bekle, kompakt kal, sonra hızla çık.';

  @override
  String get playstyleDirectBlurb => 'Erken ileri at ve ikinci top için oyna.';

  @override
  String get playstyleLowBlockBlurb => 'Derin, dar ve geçilmesi çok zor.';

  @override
  String get playstyleWingPlayBlurb =>
      'Sahayı genişlet, kanatlardan git ve orta aç.';

  @override
  String get nationsRandomTeam => 'Rastgele takım';

  @override
  String get nationsFromTheBottom => 'En dipten';

  @override
  String get bottomStartTitle => 'İşsiz';

  @override
  String get bottomStartHeading => 'Üç federasyon seninle konuşmak istiyor';

  @override
  String get bottomStartBlurb =>
      'İşin de itibarın da yok. Bunlar sana şans vermeye razı olan tek takımlar. Birini seç ve sıfırdan bir şey inşa et.';

  @override
  String get bottomStartAccept => 'Kabul et';

  @override
  String get bottomStartBack => 'Menüye dön';

  @override
  String bottomStartRankOf(int rank, int total) {
    return 'Dünyada $rank. / $total';
  }

  @override
  String get campTitle => 'Kamp merkezi';

  @override
  String campBasedIn(String host) {
    return 'Üs: $host';
  }

  @override
  String get campBlurb =>
      'Kadronun tüm turnuva boyunca yaşadığı yer. Oyun başladıktan sonra değiştirilemez ve her maçta üç şeye etki eder: ne kadar dinç geldikleri, bir sakatlığın ne kadar hızlı iyileştiği ve ne kadar keskin oldukları.';

  @override
  String get campEffectTravel => 'Dinç gelir';

  @override
  String get campEffectRecovery => 'Sakatlıklar iyileşir';

  @override
  String get campEffectSharpness => 'Maç keskinliği';

  @override
  String get campTerrainCity => 'Şehir merkezi';

  @override
  String get campTerrainCoastal => 'Sahil tesisi';

  @override
  String get campTerrainMountain => 'Dağ inzivası';

  @override
  String get campTerrainAltitude => 'Yüksek irtifa kampı';

  @override
  String get campTerrainNationalCentre => 'Milli merkez';

  @override
  String get campTerrainCityBlurb =>
      'Her şey kapının önünde, yolculuk yok, ama huzur da yok, gürültüden kaçış da.';

  @override
  String get campTerrainCoastalBlurb =>
      'Sakin, rahat ve moral için iyi; her statta uzun bir otobüs yolculuğu.';

  @override
  String get campTerrainMountainBlurb =>
      'Serin hava ve sakatlıkları çabuk toparlayan birinci sınıf bir sağlık ekibi, turnuvadan uzakta.';

  @override
  String get campTerrainAltitudeBlurb =>
      'Antrenman yapması zor, ama turnuvanın ilerleyen günlerinde dayanan bacaklar.';

  @override
  String get campTerrainNationalCentreBlurb =>
      'Federasyonun kendi tesisleri: gösterişli bir şey yok, ters gidecek bir şey de yok.';

  @override
  String get hubEventChooseCamp => 'Kamp merkezini seç';

  @override
  String hubEventChooseCampSub(String host) {
    return 'Kadronun kalacağı yer. Ev sahibi: $host';
  }

  @override
  String get tacticsTabBench => 'Yedekler';

  @override
  String get squadSearchHint => 'İsim veya kulüple ara';

  @override
  String get squadFilterAll => 'Herkes';

  @override
  String get squadFilterInSquad => 'Kadroda';

  @override
  String get squadFilterUncapped => 'Milli maçı yok';

  @override
  String get squadFilterUnavailable => 'Oynayamaz';

  @override
  String get squadLineAll => 'Tüm hatlar';

  @override
  String get squadSortBy => 'Sırala';

  @override
  String get squadSortRating => 'Güç';

  @override
  String get squadSortCaps => 'Milli maç';

  @override
  String get squadSortGoals => 'Gol';

  @override
  String get squadSortAge => 'Yaş';

  @override
  String get squadSortName => 'İsim';

  @override
  String get squadLegendTitle => 'İşaretler ne anlama geliyor';

  @override
  String get squadLegendStarting => 'İlk 11\'inde';

  @override
  String get squadLegendCalledUp => 'Kadroya çağrıldı, yedekte';

  @override
  String get squadLegendRatingUp => 'Bu yıl gücü artıyor';

  @override
  String get squadLegendRatingDown => 'Bu yıl gücü düşüyor';

  @override
  String get squadLegendInjured => 'Sakat, oynayamaz';

  @override
  String get squadLegendSuspended => 'Cezalı, oynayamaz';

  @override
  String get squadLegendTraits => 'ŞÖHRETİ';

  @override
  String squadShowingOf(int shown, int total) {
    return '$total oyuncudan $shown tanesi gösteriliyor';
  }

  @override
  String get squadNobodyMatches => 'Havuzda bu filtrelere uyan kimse yok.';

  @override
  String get squadStatPool => 'Havuz';

  @override
  String get squadStatInSquad => 'Çağrıldı';

  @override
  String get squadMostCapped => 'En çok milli maç';

  @override
  String get squadTopScorer => 'Gol kralı';

  @override
  String squadCapsValue(String name, int caps) {
    return '$name · $caps milli maç';
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
  String get squadCapsShort => 'MM';

  @override
  String get squadGoalsShort => 'Gol';

  @override
  String get recordsRecordBookSubtitle =>
      'Milli maçlar, goller ve takımın öne çıkan rekorları';

  @override
  String get statsLegacy => 'MİRAS';

  @override
  String tacticsSubAlreadyOff(String name) {
    return '$name oyundan çıktı ve geri giremez.';
  }

  @override
  String tacticsSubSentOff(String name) {
    return '$name oyundan atıldı ve artık oynayamaz.';
  }

  @override
  String get tacticsInjuredShort => 'SAKAT';

  @override
  String get tacticsSuspendedShort => 'CEZALI';

  @override
  String get confEurope => 'Avrupa';

  @override
  String get confSouthAmerica => 'Güney Amerika';

  @override
  String get confNorthAmerica => 'Kuzey Amerika';

  @override
  String get confAfrica => 'Afrika';

  @override
  String get confAsia => 'Asya';

  @override
  String get confOceania => 'Okyanusya';

  @override
  String get compWorldCup => 'Dünya Şampiyonası';

  @override
  String get compWorldCupFinals => 'Dünya Şampiyonası Finalleri';

  @override
  String get compWorldCupQualifying => 'Dünya Şampiyonası Elemeleri';

  @override
  String compQualifiers(String region) {
    return '$region Elemeleri';
  }

  @override
  String get compFriendlies => 'Hazırlık Maçları';

  @override
  String get compNationsCup => 'Uluslar Kupası';

  @override
  String get compContinentalClash => 'Kıtalar Arası Çarpışma';

  @override
  String get compIntercontinentalPlayoff => 'Kıtalar Arası Play-off';

  @override
  String get compContinentalChampionship => 'Kıta Şampiyonası';

  @override
  String get compEuropeanChampionship => 'Avrupa Şampiyonası';

  @override
  String get compSouthAmericaCup => 'Güney Amerika Kupası';

  @override
  String get compAfricanChampionship => 'Afrika Şampiyonası';

  @override
  String get compAsianChampionship => 'Asya Şampiyonası';

  @override
  String get compNorthAmericaCup => 'Kuzey Amerika Kupası';

  @override
  String get compOceaniaCup => 'Okyanusya Kupası';

  @override
  String get msgANation => 'Bir ülke';

  @override
  String get msgAPlayer => 'Bir oyuncu';

  @override
  String get msgAHostNation => 'bir ev sahibi ülke';

  @override
  String get msgCycleTitle1 => 'Yeni bir dönem başlıyor';

  @override
  String msgCycleTitle2(int year) {
    return '$year yolu açılıyor';
  }

  @override
  String get msgCycleTitle3 => 'Yeni bir kampanya doğuyor';

  @override
  String get msgCycleTitle4 => 'İşbaşı';

  @override
  String msgCycleBody1(int year) {
    return '$year Dünya Şampiyonası yolu burada başlıyor.';
  }

  @override
  String msgCycleBody2(int year) {
    return 'Yeni bir dönem. Hedef: $year Dünya Şampiyonası.';
  }

  @override
  String msgCycleBody3(int year) {
    return '$year Dünya Şampiyonası\'na dört yıl var. İş başlıyor.';
  }

  @override
  String msgCycleBody4(int year) {
    return '$year kampanyası bugün başlıyor.';
  }

  @override
  String msgContHostTitle(String cup, String host) {
    return '$cup ev sahibi: $host';
  }

  @override
  String msgContHostBody(String host, String cup) {
    return 'Sonraki $cup organizasyonuna $host ev sahipliği yapacak.';
  }

  @override
  String msgContQualDrawTitle(String cup) {
    return '$cup eleme kurası';
  }

  @override
  String msgContQualDrawBody(String cup) {
    return '$cup eleme grupları belli oldu.';
  }

  @override
  String msgWcHostTitle(String host, int year) {
    return '$year Dünya Şampiyonası ev sahibi: $host';
  }

  @override
  String msgWcHostBody(String host, int year) {
    return '$year Dünya Şampiyonası\'na $host ev sahipliği yapacak.';
  }

  @override
  String get msgWcQualDrawTitle => 'Dünya Şampiyonası eleme kurası';

  @override
  String get msgWcQualDrawBody =>
      'Dünya Şampiyonası eleme grupları belli oldu.';

  @override
  String msgContFinalsDrawTitle(String cup) {
    return '$cup final kurası';
  }

  @override
  String msgContFinalsDrawBody(String cup) {
    return '$cup final grupları belli oldu.';
  }

  @override
  String get msgWcFinalsDrawTitle => 'Dünya Şampiyonası final kurası';

  @override
  String msgWcFinalsDrawBody(int year) {
    return '$year Dünya Şampiyonası final kurası çekildi.';
  }

  @override
  String get msgQualWcTitle1 => 'Dünya Şampiyonası yolunda';

  @override
  String get msgQualWcTitle2 => 'Dünya Şampiyonası bileti alındı';

  @override
  String get msgQualWcTitle3 => 'Dünya Şampiyonası\'na gidiyoruz';

  @override
  String get msgQualWcTitle4 => 'Bilet cepte';

  @override
  String msgQualWcBody1(int year) {
    return '$year Dünya Şampiyonası finallerine katılma hakkı kazandın.';
  }

  @override
  String msgQualWcBody2(int year) {
    return 'Resmen belli oldu: ülken $year Dünya Şampiyonası\'nda.';
  }

  @override
  String msgQualWcBody3(int year) {
    return '$year Dünya Şampiyonası\'nda bir yer garantilendi.';
  }

  @override
  String msgQualWcBody4(int year) {
    return '$year Dünya Şampiyonası finallerine yükseldin.';
  }

  @override
  String msgQualContTitle1(String cup) {
    return '$cup yolunda';
  }

  @override
  String msgQualContTitle2(String cup) {
    return '$cup bileti alındı';
  }

  @override
  String msgQualContTitle3(String cup) {
    return '$cup için hak kazanıldı';
  }

  @override
  String msgQualContBody1(String cup) {
    return '$cup final turnuvasına katılma hakkı kazandın.';
  }

  @override
  String msgQualContBody2(String cup) {
    return 'Ülken $cup için yerini garantiledi.';
  }

  @override
  String msgQualContBody3(String cup) {
    return '$cup için bileti kaptın.';
  }

  @override
  String msgChampTitleMine1(String comp) {
    return '$comp ŞAMPİYONU!';
  }

  @override
  String msgChampTitleMine2(String comp) {
    return '$comp şampiyonları!';
  }

  @override
  String msgChampTitleMine3(String comp) {
    return '$comp şampiyonusun!';
  }

  @override
  String msgChampTitleOther1(String comp) {
    return '$comp sona erdi';
  }

  @override
  String msgChampTitleOther2(String comp) {
    return '$comp şampiyonu belli oldu';
  }

  @override
  String msgChampTitleOther3(String comp) {
    return '$comp kazananı belli';
  }

  @override
  String msgChampBodyMine1(String comp, String loser, String result, int year) {
    return 'Ülken $year $comp şampiyonu oldu. Finalde yenilen rakip: $loser$result.';
  }

  @override
  String msgChampBodyMine2(String comp, String loser, String result, int year) {
    return '$year $comp şampiyonluğu senin. Finalde elenen rakip: $loser$result.';
  }

  @override
  String msgChampBodyMine3(String comp, String loser, String result, int year) {
    return '$year $comp kupası senin. Yenilen rakip: $loser$result.';
  }

  @override
  String msgChampBodyOther1(
    String winner,
    String comp,
    String loser,
    String result,
    int year,
  ) {
    return '$year $comp şampiyonu: $winner. Finalde yenilen rakip: $loser$result.';
  }

  @override
  String msgChampBodyOther2(
    String winner,
    String comp,
    String loser,
    String result,
    int year,
  ) {
    return '$year $comp şampiyonu $winner oldu. Finalde elenen rakip: $loser$result.';
  }

  @override
  String msgFinalScoreSuffix(int home, int away) {
    return ' (final: $home–$away)';
  }

  @override
  String msgFinalPensSuffix(int home, int away) {
    return ' (penaltılarla, final $home–$away bitti)';
  }

  @override
  String get msgWpotyTitle => 'Yılın Dünya Oyuncusu';

  @override
  String msgWpotyBodyMine(String name, String nation, int year) {
    return '$year Yılın Dünya Oyuncusu: $name ($nation), senin oyuncularından biri.';
  }

  @override
  String msgWpotyBodyOther(String name, String nation, int year) {
    return '$year Yılın Dünya Oyuncusu: $name ($nation).';
  }

  @override
  String get msgYpotTitle => 'Turnuvanın Genç Oyuncusu';

  @override
  String msgYpotBodyMine(String name, String nation, int age, int year) {
    return '$year Turnuvanın Genç Oyuncusu: $name ($nation), $age yaşında, senin oyuncularından biri.';
  }

  @override
  String msgYpotBodyOther(String name, String nation, int age, int year) {
    return '$year Turnuvanın Genç Oyuncusu: $name ($nation), $age yaşında.';
  }

  @override
  String msgRankHold1(int rank) {
    return '#$rank sırada duruyorsun.';
  }

  @override
  String msgRankHold2(int rank) {
    return 'Değişiklik yok, hâlâ #$rank.';
  }

  @override
  String msgRankHold3(int rank) {
    return '#$rank sırada sabitsin.';
  }

  @override
  String msgRankUp1(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move basamak',
      one: '1 basamak',
    );
    return 'Toplamda $_temp0 yükselip #$rank sıraya çıktın.';
  }

  @override
  String msgRankUp2(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move basamaklık',
      one: '1 basamaklık',
    );
    return '$_temp0 yükseliş seni #$rank sıraya taşıdı.';
  }

  @override
  String msgRankUp3(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move basamak',
      one: '1 basamak',
    );
    return '$_temp0 yukarı, şimdi #$rank.';
  }

  @override
  String msgRankDown1(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move basamak',
      one: '1 basamak',
    );
    return 'Toplamda $_temp0 düşüp #$rank sıraya indin.';
  }

  @override
  String msgRankDown2(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move basamaklık',
      one: '1 basamaklık',
    );
    return '$_temp0 düşüş seni #$rank sıraya indirdi.';
  }

  @override
  String msgRankDown3(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move basamak',
      one: '1 basamak',
    );
    return '$_temp0 aşağı, şimdi #$rank.';
  }

  @override
  String get msgRankLeadYou => 'Dünyanın zirvesindesin.';

  @override
  String msgRankLeadOther(String nation) {
    return '$nation dünyanın zirvesinde.';
  }

  @override
  String msgRankTitle(int rank) {
    return 'Dünya sıralaması · #$rank';
  }

  @override
  String msgRankBody(String lead, String movement) {
    return 'Dünya sıralaması güncellendi. $lead $movement';
  }

  @override
  String msgRankJumpTitleUp(int rank) {
    return '#$rank sıraya yükseliş';
  }

  @override
  String msgRankJumpTitleDown(int rank) {
    return '#$rank sıraya düşüş';
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
      other: '$move basamak',
      one: '1 basamak',
    );
    return '$tournament dünya sıralamasını değiştirdi. $nation: #$from sıradan #$to sıraya, $_temp0 yükseliş.';
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
      other: '$move basamak',
      one: '1 basamak',
    );
    return '$tournament dünya sıralamasını değiştirdi. $nation: #$from sıradan #$to sıraya, $_temp0 düşüş.';
  }

  @override
  String get rankingSinceWcDraw => 'Dünya Şampiyonası kurasından beri';

  @override
  String get rankingSinceCycleStart => 'Kampanya başladığından beri';

  @override
  String rankingMovedFromTo(int from, int now) {
    return '#$from → #$now';
  }

  @override
  String msgCapsTitle(String name, int count) {
    return '$name $count milli maça ulaştı';
  }

  @override
  String msgCapsBody(String name, int count) {
    return '$name milli takımında şimdiye kadar $count maça çıktı.';
  }

  @override
  String msgGoalsTitle(String name, int count) {
    return '$name $count gole ulaştı';
  }

  @override
  String msgGoalsBody(String name, int count) {
    return '$name milli takımında şimdiye kadar $count gol attı.';
  }

  @override
  String msgDevTitle(int year) {
    return 'Kadro gelişimi · $year';
  }

  @override
  String msgThroughTitle(int year) {
    return 'Akademiden gelenler · $year';
  }

  @override
  String get msgThroughNote =>
      'Bunlar yeni bir grup değil. On bir yaşında gelip şimdi A takım havuzuna yükselen gençler.';

  @override
  String msgNewFacesTitle(int year) {
    return 'Yeni yüzler · $year';
  }

  @override
  String get msgIntakeNoteAcademy =>
      'Akademi yatırımının etkisi görülüyor: bu grup olabileceğinden daha güçlü geldi.';

  @override
  String get msgIntakeNoteStanding =>
      'Ülke bu takımı izliyor: takım dünya sıralamasında yükseldikçe en iyi gençler futbolu seçiyor ve bu grup bu yüzden daha güçlü geldi.';

  @override
  String get msgIntakeNoteBoth =>
      'Akademi parası da takımın dünya sıralamasındaki yükselişi de etkisini gösteriyor: bu grup olabileceğinden daha güçlü geldi.';

  @override
  String msgIntakeTitle(int year) {
    return 'Akademi grubu · $year';
  }

  @override
  String msgRetireCaptainTitle(String name) {
    return 'Kaptanın $name futbolu bırakıyor';
  }

  @override
  String msgRetireTitle(String name) {
    return '$name milli takımı bırakıyor';
  }

  @override
  String msgRetireBody(String name, int age) {
    return '$name $age yaşında milli futbolu bıraktı.';
  }

  @override
  String msgRetireBodyWith(String name, String tally, int age) {
    return '$name $age yaşında milli futbolu bıraktı, $tally ile veda etti.';
  }

  @override
  String msgTallyCaps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count milli maç',
      one: '1 milli maç',
    );
    return '$_temp0';
  }

  @override
  String msgTallyGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gol',
      one: '1 gol',
    );
    return '$_temp0';
  }

  @override
  String get msgArmbandVacant =>
      ' Kaptanlık pazubendi boşta. Kadro ekranından yeni bir kaptan seç.';

  @override
  String msgHofTitle(String name) {
    return 'Şöhretler Salonu\'na yeni üye: $name';
  }

  @override
  String msgHofBody(String name, int caps, int goals) {
    return '$name, ülkenin Şöhretler Salonu\'na katıldı ($caps milli maç, $goals gol). Efsaneler bölümünden bak.';
  }

  @override
  String hubBanTitle(String name) {
    return '$name cezalı';
  }

  @override
  String hubBanBody(String name, String how, int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: 'sonraki $matches maçta',
      one: 'bir sonraki maçta',
    );
    return '$name $how ve $_temp0 cezalı. Kadroya seçilemez.';
  }

  @override
  String get hubBanHowSecondYellow => 'ikinci sarı karttan oyundan atıldı';

  @override
  String get hubBanHowViolent =>
      'şiddet içeren hareket nedeniyle direkt kırmızı kart gördü';

  @override
  String get hubBanHowRed => 'oyundan atıldı';

  @override
  String hubInjuryTitle(String name) {
    return '$name sakatlandı';
  }

  @override
  String hubInjuryBody(String name, int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: '$matches maç',
      one: '1 maç',
    );
    return '$name sakatlandı ve $_temp0 forma giyemeyecek.';
  }

  @override
  String get hubRunnerUpTitle1 => 'İkinci';

  @override
  String get hubRunnerUpTitle2 => 'Çok yakın, ama yetmedi';

  @override
  String get hubRunnerUpTitle3 => 'Gümüş madalya';

  @override
  String hubRunnerUpBody1(String cup, String opponent) {
    return '$cup finaline çıktın ama $opponent karşısında kaybettin. Çok yakındı. Bu kez gümüş.';
  }

  @override
  String hubRunnerUpBody2(String cup, String opponent) {
    return '$cup finalinde $opponent karşısında yenildin. İkinci oldun, acı verecek kadar yakındı.';
  }

  @override
  String hubRunnerUpBody3(String cup, String opponent) {
    return '$cup finali $opponent karşısında elinden kaydı. Gurur duyulacak çok şey var, ama kupa yok.';
  }

  @override
  String get hubKnockedOutTitle1 => 'Elendin';

  @override
  String get hubKnockedOutTitle2 => 'Yolun sonu';

  @override
  String get hubKnockedOutTitle3 => 'Yolculuk bitti';

  @override
  String hubKnockedOutBody1(String cup, String opponent, String stage) {
    return '$cup macerası bitti, $opponent karşısında elendin. Aşama: $stage.';
  }

  @override
  String hubKnockedOutBody2(String cup, String opponent, String stage) {
    return '$opponent, $cup yolculuğunu bitirdi. Aşama: $stage.';
  }

  @override
  String hubKnockedOutBody3(String cup, String opponent, String stage) {
    return '$cup yolculuğun sona erdi. Aşama: $stage, rakip: $opponent.';
  }

  @override
  String get hubGroupExitTitle1 => 'Grup aşamasında veda';

  @override
  String get hubGroupExitTitle2 => 'Grup aşamasında elendin';

  @override
  String get hubGroupExitTitle3 => 'Erken duş';

  @override
  String hubGroupExitBody1(String cup) {
    return '$cup macerası grup aşamasında bitti. Eleme turlarına çıkmaya yetmedi.';
  }

  @override
  String hubGroupExitBody2(String cup) {
    return 'Gruptan çıkamadın. $cup yolculuğun burada bitiyor.';
  }

  @override
  String hubGroupExitBody3(String cup) {
    return 'Eleme turlarına kalamadın. $cup yolculuğun grup aşamasında bitti.';
  }

  @override
  String boardObjectiveMetTitle(String comp) {
    return 'Hedef tamam: $comp';
  }

  @override
  String boardObjectiveMissedTitle(String comp) {
    return 'Hedef kaçtı: $comp';
  }

  @override
  String boardObjectiveMetBody(String comp, String demand, String finish) {
    return 'Yönetimin $comp hedefi: $demand. Sonucun: $finish. İstediklerini aldılar.';
  }

  @override
  String boardObjectiveMissedBody(String comp, String demand, String finish) {
    return 'Yönetimin $comp hedefi: $demand. Sonucun: $finish. Beklenenin altında kaldı.';
  }

  @override
  String get newsWcMissTitle => 'Dünya Şampiyonası hayali bitti';

  @override
  String newsWcMissBody(int year) {
    return '$year Dünya Şampiyonası\'na katılamadın. Eleme kampanyası yetmedi. Dört yıl daha var.';
  }

  @override
  String get newsRecordScorerTitle => 'Tüm zamanların gol kralı';

  @override
  String newsRecordScorerBody(String name, int goals) {
    return '$name, $goals golle oyunun tüm zamanların en golcü oyuncusu oldu.';
  }

  @override
  String get newsRecordCapsTitle => 'En çok milli maç oynayan oyuncu';

  @override
  String newsRecordCapsBody(String name, int caps) {
    return '$name, $caps maçla oyunun en çok milli maça çıkan oyuncusu oldu.';
  }

  @override
  String get newsARecordBreaker => 'Yeni bir rekortmen';

  @override
  String newsTransferTitle(String name, String club) {
    return '$name $club kulübüne gidiyor';
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
    return '$name ($position, $rating) $fromClub kulübünden ayrılıp $fee bedelle $destination ile anlaştı.';
  }

  @override
  String newsTransferAbroad(String club, String country) {
    return '$club ($country)';
  }

  @override
  String get newsTransferFree => 'Bedelsiz';

  @override
  String newsNatzStarTitle(String name, String nation) {
    return '$name milli takımını değiştirmek istiyor: $nation!';
  }

  @override
  String newsNatzTitle(String name, String nation) {
    return '$name şu ülke adına oynamak istiyor: $nation';
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
    return '$fromNation adına oynayan $age yaşındaki $position $name (genel $rating), şu ülkeyle aile bağları olan ve geçişe açık biri: $nation. Kabul etmek ya da reddetmek için vatandaşlığa geçirme teklifini aç.';
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
    return '$fromNation adına oynayan $age yaşındaki $position $name (genel $rating) büyük bir isim. Şu ülkeyle aile bağları var ve geçişe açık: $nation. Kabul etmek ya da reddetmek için vatandaşlığa geçirme teklifini aç.';
  }

  @override
  String get newsTheirNation => 'kendi ülkesi';

  @override
  String get newsYourNation => 'senin ülken';

  @override
  String get tourStatusChampions => 'ŞAMPİYONLAR';

  @override
  String get tourStatusFinals => 'FİNALLER';

  @override
  String get tourStatusQualifying => 'ELEMELER';

  @override
  String get tourStatusUpcoming => 'YAKINDA';

  @override
  String get tourStatusInProgress => 'DEVAM EDİYOR';

  @override
  String get tourStatusComingSoon => 'ÇOK YAKINDA';

  @override
  String get tourStatusDecided => 'SONUÇLANDI';

  @override
  String tourStatusLeague(String letter) {
    return '$letter LİGİ';
  }

  @override
  String get tourDrawWcQualifying => 'DÜNYA ELEME KURASI';

  @override
  String tourDrawContQualifying(String cup) {
    return '$cup ELEME KURASI';
  }

  @override
  String get tourDrawWcHost => 'DÜNYA ŞAMPİYONASI EV SAHİBİ';

  @override
  String tourDrawContHost(String cup) {
    return '$cup EV SAHİBİ';
  }

  @override
  String get tourDrawHostsReveal => 'Ve ev sahipleri…';

  @override
  String get tourDrawHostReveal => 'Ve ev sahibi…';

  @override
  String get tourDrawHostCandidates => 'Yarıştaki adaylar:';

  @override
  String get tourKickoffContinentalCup => 'KITA KUPASI';

  @override
  String tourHostCompetitionYear(String competition, int year) {
    return '$competition $year';
  }

  @override
  String newsContMissTitle(String cup) {
    return '$cup kaçtı';
  }

  @override
  String newsContMissBody(String cup) {
    return '$cup için katılma hakkı kazanamadın. Bu kez kampanya yetmedi.';
  }

  @override
  String get potyLabelBest => 'Yılın Oyuncusu';

  @override
  String get potyLabelYoung => 'Yılın Genç Oyuncusu';

  @override
  String potyTallyAssists(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count asist',
      one: '1 asist',
    );
    return '$_temp0';
  }

  @override
  String potyOverallValue(int value) {
    return 'Güç $value';
  }

  @override
  String potyRatingValue(String value) {
    return 'Not ortalaması $value';
  }

  @override
  String newsPotyTitle(int year) {
    return 'Dünyanın Yılın Oyuncusu $year';
  }

  @override
  String newsPotyBody(String name) {
    return '$name bu yıl dünyanın en iyi oyuncusu.';
  }

  @override
  String newsPotyYoungSuffix(String name) {
    return ' Genç oyuncu ödülünü $name aldı.';
  }

  @override
  String newsWatchTitle(int year) {
    return 'Takip ettiğin gençler, $year';
  }

  @override
  String newsWatchJump(String name, int rating, int gain) {
    String _temp0 = intl.Intl.pluralLogic(
      gain,
      locale: localeName,
      other: '$gain puan',
      one: 'bir puan',
    );
    return '$name $rating seviyesine fırladı, geçen yıla göre $_temp0 yukarıda.';
  }

  @override
  String newsWatchBand(String name, String band) {
    return '$name şu yaş grubuna yükseldi: $band.';
  }

  @override
  String newsWatchDebutTitle(String name) {
    return '$name A milli takımda ilk maçına çıkıyor';
  }

  @override
  String newsWatchDebutBody(String name, int age, int rating) {
    return '$name $age yaşında, $rating genel güçle ilk milli maçına çıktı. Takip ettiğin gençlerden biri.';
  }

  @override
  String get matchStatsAtFullTime =>
      'Topa sahip olma, oyuncu notları ve maçın adamı son düdükle belli olur.';

  @override
  String get matchPlayerRatings => 'OYUNCU NOTLARI';

  @override
  String get matchSubstitutions => 'OYUNCU DEĞİŞİKLİKLERİ';

  @override
  String get matchSubstitutes => 'YEDEKLER';

  @override
  String get matchPlayerOfTheMatch => 'MAÇIN ADAMI';

  @override
  String get matchGoalShout => 'GOL!';

  @override
  String matchShootoutScore(int home, int away) {
    return 'PENALTI ATIŞLARI $home–$away';
  }

  @override
  String matchShootoutKickScored(String name) {
    return '$name: GOL';
  }

  @override
  String matchShootoutKickMissed(String name) {
    return '$name: KAÇTI';
  }

  @override
  String get matchFeedKickOff => 'Başlama vuruşu!';

  @override
  String get matchFeedNoEvents => 'Henüz olay yok.';

  @override
  String get tourVenues => 'STATLAR';

  @override
  String tourPot(int number) {
    return 'TORBA $number';
  }

  @override
  String get tourHostSelection => 'EV SAHİBİ SEÇİMİ';

  @override
  String get tourCandidates => 'ADAYLAR';

  @override
  String get tourJointBid => 'ORTAK BAŞVURU';

  @override
  String get tourGoldenGlove => 'ALTIN ELDİVEN';

  @override
  String get tourTeamOfTournament => 'TURNUVANIN TAKIMI';

  @override
  String get tourYourRun => 'SENİN YOLUN';

  @override
  String get tourMedalTable => 'MADALYA TABLOSU';

  @override
  String tourHostLine(String nation) {
    return 'Ev sahibi: $nation';
  }

  @override
  String tourHostLineMulti(String hosts) {
    return 'Ev sahipleri: $hosts';
  }

  @override
  String tourGroupNamed(String name) {
    return '$name Grubu';
  }

  @override
  String get tourFinalsDrawBlurb =>
      'Dünya sıralamasına göre ayrılmış. Kuradan önce ülkeni bul.';

  @override
  String get tourWorldRanking => 'Dünya Sıralaması';

  @override
  String get tourYourCompetitions => 'SENİN ORGANİZASYONLARIN';

  @override
  String get tourOtherContinents => 'DİĞER KITALAR';

  @override
  String get tourZoneGlobal => 'DÜNYA';

  @override
  String get tourZoneEurope => 'AVRUPA';

  @override
  String get tourZoneSouthAmerica => 'G. AMERİKA';

  @override
  String get tourZoneNorthAmerica => 'K. AMERİKA';

  @override
  String get tourZoneAfrica => 'AFRİKA';

  @override
  String get tourZoneAsia => 'ASYA';

  @override
  String get tourZoneOceania => 'OKYANUSYA';

  @override
  String get tourZoneIntercontinental => 'KITALAR ARASI';

  @override
  String tourZoneLeague(String league) {
    return '$league LİGİ';
  }

  @override
  String tourHostedBy(String hosts) {
    return 'EV SAHİBİ  $hosts';
  }

  @override
  String tourThirdsAdvance(int count, String destination) {
    return 'İlk $count takım $destination yükselir';
  }

  @override
  String newsWalkoutTitle(String name) {
    return '$name kapıyı çarpıp gitti';
  }

  @override
  String newsWalkoutBody(String name, int age, int caps) {
    return '$name $age yaşında, $caps milli maçın ardından milli takımı bıraktı. Durumunun ne olduğunu söylemelerini istedi ama söylenmedi, daha fazla beklemeyecek.';
  }

  @override
  String get pressHeadlineWent1 => 'Salonun hâkimi teknik direktör';

  @override
  String get pressHeadlineWent2 => 'Kavga aramaya geldiler, lider buldular';

  @override
  String get pressHeadlineWent3 => 'Net cevaplar, tam isabet';

  @override
  String get pressHeadlineMixed1 => 'Çok konuşuldu, az şey çözüldü';

  @override
  String get pressHeadlineMixed2 => 'Herkese bir şey, kimseye hiçbir şey';

  @override
  String get pressHeadlineMixed3 => 'Sorular havada kalan bir toplantı';

  @override
  String get pressHeadlineBadly1 => 'Kameralar önünde zorlu bir öğleden sonra';

  @override
  String get pressHeadlineBadly2 => 'Salon döndü, belli de oldu';

  @override
  String get pressHeadlineBadly3 => 'Yarın sabah daha kötü okunacak cevaplar';

  @override
  String get pressHeadlineFlat1 => 'Söylenen yok, kazanılan yok';

  @override
  String get pressHeadlineFlat2 => 'On dakika, sıfır haber';

  @override
  String get pressHeadlineFlat3 => 'Son sayfaya boş bir sayfa';

  @override
  String get pressConferenceTitle => 'BASIN TOPLANTISI';

  @override
  String pressQuestionOf(int index, int total) {
    return 'Soru $index / $total';
  }

  @override
  String get pressTomorrowsHeadline => 'YARININ SON SAYFASI';

  @override
  String get pressLeaveRoom => 'SALONDAN AYRIL';

  @override
  String get pressRoomVerdictSquad => 'Soyunma odası';

  @override
  String get pressRoomVerdictBoard => 'Yönetim';

  @override
  String get yReactionElation0 => 'not yok. hiç. mükemmel.';

  @override
  String get yReactionElation1 => 'Hastayım (iyi anlamda).';

  @override
  String get yReactionElation2 =>
      'çerçeveletiyorum. şöminenin üstüne asıyorum.';

  @override
  String get yReactionElation3 => 'geri döndük';

  @override
  String get yReactionElation4 =>
      'Bunu şüphecilere göndermek için ekran görüntüsü alıyorum. Hepsine.';

  @override
  String get yReactionElation5 => 'Bu yüzden on yıl boyunca çekilmez olacağım.';

  @override
  String get yReactionElation6 => 'İşte. Bu yüzden izliyoruz.';

  @override
  String get yReactionElation7 => 'Böyle günler diğerlerinin bedelini ödüyor.';

  @override
  String get yReactionElation8 => 'Hadi be. Gerçekten, hadi be.';

  @override
  String get yReactionElation9 =>
      'Güzel. Şimdi haftaya da yap, o zaman inanırım.';

  @override
  String get yReactionElation10 =>
      'Bu geceyi yaşayın, çünkü bu takım bir şekilde bozmanın yolunu bulur.';

  @override
  String get yReactionElation11 =>
      'Tek bir güzel gece kimseyi büyük takım yapmaz.';

  @override
  String get yReactionRelief0 => 'Güzel değildi ama her seferinde kabulüm.';

  @override
  String get yReactionRelief1 => 'Bir şekilde. Bir şekilde!';

  @override
  String get yReactionRelief2 => 'Çirkindi. Üç puan. Devam.';

  @override
  String get yReactionRelief3 => 'Puan getiriyorsa gün boyu çirkin oynasınlar.';

  @override
  String get yReactionRelief4 => 'ömrümden on yıl gitti';

  @override
  String get yReactionRelief5 => 'Kimse konuşmasın. Kimse nazar değdirmesin.';

  @override
  String get yReactionRelief6 => 'Kalp atışı: kabul edilemez.';

  @override
  String get yReactionRelief7 => 'Hayatta kaldık. Kelime bu. Hayatta kaldık.';

  @override
  String get yReactionRelief8 =>
      'Böyle maçlardan sonra rahatlamak zorunda kalmamalıyız.';

  @override
  String get yReactionRelief9 =>
      'Rahatladım ve rahatladığım için biraz utandım.';

  @override
  String get yReactionRelief10 =>
      'Alkışladığımız standart buysa başımız dertte.';

  @override
  String get yReactionRelief11 =>
      'Zor kurtulmak huy oldu ve iyi bir huy değil.';

  @override
  String get yReactionFury0 => 'Yetmez. Alakası yok.';

  @override
  String get yReactionFury1 => 'Biri bunu bana yavaş yavaş anlatsın.';

  @override
  String get yReactionFury2 => 'İzlemesi çok zordu ve nazik davranıyorum.';

  @override
  String get yReactionFury3 => 'Hayal kırıklığı. Gerçekten hayal kırıklığı.';

  @override
  String get yReactionFury4 => 'Bu ne rezalet.';

  @override
  String get yReactionFury5 => 'İsim istiyorum.';

  @override
  String get yReactionFury6 =>
      'Uygulamayı siliyorum. Perşembe tekrar yüklerim.';

  @override
  String get yReactionFury7 => 'Sahada kimse istekli görünmüyordu.';

  @override
  String get yReactionFury8 => 'Dört yılda bir aynı şey. HER dört yılda bir.';

  @override
  String get yReactionFury9 => 'Bu performans değil, hakaret.';

  @override
  String get yReactionFury10 =>
      'İnsanlar hafta sonunu ve parasını bunun için veriyor. Bir düşünün.';

  @override
  String get yReactionFury11 =>
      'Yıllardır bu takımı savundum. Bu gece değil. Bundan sonra değil.';

  @override
  String get yReactionDespair0 => 'eh.';

  @override
  String get yReactionDespair1 => 'Bugün espri yok. Hiç.';

  @override
  String get yReactionDespair2 => 'Yürüyüşe çıkıyorum. Uzun bir yürüyüşe.';

  @override
  String get yReactionDespair3 => 'Bunu söyleyecek söz kalmadı.';

  @override
  String get yReactionDespair4 => 'Dört yıl sonra uyandırın.';

  @override
  String get yReactionDespair5 => 'bu en karanlık zaman çizgisi';

  @override
  String get yReactionDespair6 =>
      'Artık kızgın bile değilim. Asıl endişe verici olan bu.';

  @override
  String get yReactionDespair7 => 'Bu çok uzun süre yakacak.';

  @override
  String get yReactionDespair8 =>
      'Bunun ne olduğunu artık bilmiyorum ama futbol takımı değil.';

  @override
  String get yReactionDespair9 =>
      'Eskisinden daha uzaktayız ve kimse söylemiyor.';

  @override
  String get yReactionDespair10 =>
      'Koca bir nesil heba oldu ve sıradaki kararı yine aynı insanlar veriyor.';

  @override
  String get yReactionDespair11 =>
      'Bunun bir süreç olduğunu söylemeyi bırakın. Hiçbir yere gitmiyor.';

  @override
  String get yReactionSmugness0 => 'Sessizce ama: demiştim.';

  @override
  String get yReactionSmugness1 => 'bunu yer imine ekleyin';

  @override
  String get yReactionSmugness2 => 'Şüpheciler çok sessizleşti.';

  @override
  String get yReactionSmugness3 => 'Sayan yok ama. Ben sayıyorum.';

  @override
  String get yReactionSmugness4 => 'Ocakta söylemiştim. Akışa bakın.';

  @override
  String get yReactionSmugness5 => 'Bazılarınız bazılarımızdan özür borçlu.';

  @override
  String get yReactionSmugness6 =>
      'Bunu önce söylediklerim arasına kaydediyorum.';

  @override
  String get yReactionSmugness7 => 'Caka yok. Azıcık caka var.';

  @override
  String get yReactionSmugness8 =>
      'Şimdi bütün uzmanlar nerede? Gerçekten soruyorum.';

  @override
  String get yReactionSmugness9 =>
      'Her birinizin bunu bana geri söylemesini istiyorum.';

  @override
  String get yReactionSmugness10 =>
      'Ekran görüntüsü, çıktı, çerçeve, bize gülenlere gönderildi.';

  @override
  String get yReactionSmugness11 =>
      'Bunu ömrüm boyunca anlatacağım ve bunu hak ettiniz.';

  @override
  String get yReactionShrug0 => 'oldu. sıradaki.';

  @override
  String get yReactionShrug1 => 'Tamam. Neyse. Devam.';

  @override
  String get yReactionShrug2 => 'Bunu \'futbol\' dosyasına koyuyorum.';

  @override
  String get yReactionShrug3 => 'Gerçekten eklenecek bir şey yok.';

  @override
  String get yReactionShrug4 => 'düşünce yok, kafa boş';

  @override
  String get yReactionShrug5 => 'Sonraki için uyandırın.';

  @override
  String get yReactionShrug6 => 'Geri alamayacağım doksan dakika.';

  @override
  String get yReactionShrug7 => 'Ne bir şey ne de başka bir şey, açıkçası.';

  @override
  String get yReactionShrug8 => 'Olan tek bir şeyi bile söyleyemem.';

  @override
  String get yReactionShrug9 => 'Bir tane daha. Bunlardan çok var.';

  @override
  String get yReactionShrug10 => 'Hepsini izledim ve hiçbir şey hissetmedim.';

  @override
  String get yReactionShrug11 => 'Kimse bunu bir daha anmazsa bana uyar.';

  @override
  String get tourThirdsUneven =>
      'Gruplar eşit değil, bu yüzden her büyük grubun son sırasındaki takıma karşı alınan sonuçlar düşülür ve her takım aynı maçlar üzerinden değerlendirilir.';

  @override
  String get careerExportSave => 'Bu kaydı yedekle';

  @override
  String get careerBackupAll => 'TÜM KAYITLARI YEDEKLE';

  @override
  String get careerBackupAllFailed => 'Yedek yazılamadı.';

  @override
  String get backupTitle => 'YEDEKLER';

  @override
  String get backupBlurb =>
      'Tüm kayıtlar bu telefonda tek bir dosyada durur ve aşağıdan otomatik yedeği açmadıkça hiçbir şey onları kendiliğinden yedeklemez. Kaybolan bir telefon ya da silinen uygulama sana bir kariyere mal olmasın diye bulutta bir kopya tut.';

  @override
  String get backupBlurbNoAuto =>
      'Tüm kayıtlar bu telefonda tek bir dosyada durur ve hiçbir şey onları kendiliğinden yedeklemez. Kaybolan bir telefon ya da silinen uygulama sana bir kariyere mal olmasın diye bulutta bir kopya tut.';

  @override
  String get backupExport => 'BULUTA YEDEKLE';

  @override
  String get backupExportSubject => 'FNM kayıtları';

  @override
  String get backupRestore => 'DOSYADAN GERİ YÜKLE';

  @override
  String get backupRestoreWarnTitle => 'Tüm kayıtlar değiştirilsin mi?';

  @override
  String get backupRestoreWarnBody =>
      'Geri yükleme, bu telefondaki tüm kayıtları dosyadakilerle değiştirir. Uygulama yeniden başlayacak.';

  @override
  String get backupRestoreConfirm => 'DEĞİŞTİR';

  @override
  String get backupCancel => 'VAZGEÇ';

  @override
  String get backupExported => 'Yedek hazır. Nerede saklayacağını seç.';

  @override
  String get backupFailed => 'Yedek yazılamadı.';

  @override
  String get backupRejectedUnreadable => 'Bu dosya açılamadı.';

  @override
  String get backupRejectedNotFnm => 'Bu bir FNM kaydı değil.';

  @override
  String get backupRejectedNewer =>
      'Bu kayıt uygulamanın daha yeni bir sürümüyle oluşturulmuş. Önce güncelle.';

  @override
  String get backupRejectedTooOld =>
      'Bu kayıt bu sürümle geri yüklenemeyecek kadar eski.';

  @override
  String get careerShare => 'Bu kariyeri paylaş';

  @override
  String get careerImport => 'KARİYER İÇE AKTAR';

  @override
  String get careerShareSubject => 'Bir FNM kariyeri';

  @override
  String get careerImported => 'Kariyer içe aktarıldı.';

  @override
  String get careerImportFailedUnreadable => 'Bu dosya bir FNM kariyeri değil.';

  @override
  String get careerImportFailedNewer =>
      'Bu kariyer uygulamanın daha yeni bir sürümüyle dışa aktarılmış. Önce güncelle.';

  @override
  String get careerImportFailedSlotsFull =>
      'Tüm kayıt yuvaların dolu. Yer açmak için bir kaydı sil ya da sınırsız kayıt kilidini aç.';

  @override
  String get careerImportFailedNeedsPremium =>
      'Bu kariyer ücretsiz ilk dönemi geçmiş. İçe aktarmak için tam oyunun kilidini aç.';

  @override
  String get careerImportFailedCampaignRun =>
      'Bu kampanyada zaten devam eden bir yolculuk var. Önce devam et ya da bırak.';

  @override
  String get careerShareFailed => 'Bu kariyer dışa aktarılamadı.';

  @override
  String get managerRename => 'Adı değiştir';

  @override
  String get managerRenameSave => 'Kaydet';

  @override
  String get managerTitle => 'TEKNİK DİREKTÖR';

  @override
  String get managerSkills => 'BECERİLERİN';

  @override
  String managerPointsAvailable(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Harcanacak $count puan',
      one: 'Harcanacak 1 puan',
      zero: 'Harcanacak puan yok',
    );
    return '$_temp0';
  }

  @override
  String get managerPointsHow =>
      'Tamamladığın her dönem için iki puan, kazandığın her kupa için bir puan.';

  @override
  String get managerSkillsScale =>
      'Her beceri 5\'ten başlar, 20\'de durur. Harcanan puan kalıcıdır.';

  @override
  String get managerSkillManManagement => 'İnsan Yönetimi';

  @override
  String get managerSkillManManagementBlurb =>
      'Her puan, basına ve oyuncularına söylediklerinin soyunma odasında %3 daha güçlü karşılık bulmasını sağlar.';

  @override
  String get managerSkillTactical => 'Taktik';

  @override
  String get managerSkillTacticalBlurb =>
      'Her puan yeni bir dizilişin %3 daha hızlı oturmasını sağlar, böylece diziliş değiştirmek sana daha az maça mal olur.';

  @override
  String get managerSkillYouth => 'Genç Yetenek Gelişimi';

  @override
  String get managerSkillYouthBlurb =>
      'Her puan, akademinden çıkan yeteneğe %1 ekler; bu, akademiye ayırdığın bütçenin üstüne gelir.';

  @override
  String get managerSkillNegotiation => 'Pazarlık';

  @override
  String get managerSkillNegotiationBlurb =>
      'Her puan, federasyondan her dönem %2 daha fazla para demektir.';

  @override
  String get managerStaff => 'TEKNİK EKİBİN';

  @override
  String managerStaffWages(String amount) {
    return 'Maaşlar: dönem başına $amount';
  }

  @override
  String get managerRoleAssistant => 'Yardımcı Antrenör';

  @override
  String get managerRoleAssistantBlurb =>
      'Antrenmanı yönetir: daha az sakatlık ve daha iyi gelen gençler.';

  @override
  String get managerRoleScout => 'Başgözlemci';

  @override
  String get managerRoleScoutBlurb =>
      'Yeteneklerini ve sıradaki rakibini okur: daha doğru yıldız notları ve maç günü için bir avantaj.';

  @override
  String get managerRoleFitness => 'Atletik Performans Antrenörü';

  @override
  String get managerRoleFitnessBlurb => 'Onları sahada tutar.';

  @override
  String staffEffectInjury(int percent) {
    return '%$percent daha az sakatlık';
  }

  @override
  String staffEffectYouth(int points) {
    return 'Gençler +$points genel';
  }

  @override
  String staffHiringInjury(int min, int max) {
    return 'Birini işe almak: %$min ile %$max arası daha az sakatlık';
  }

  @override
  String staffHiringYouth(int minPoints, int maxPoints) {
    return 've gençler +$minPoints ile +$maxPoints arası genel';
  }

  @override
  String staffEffectScoutRead(int percent) {
    return 'Yeteneklerin %$percent\'ini tam okuyor';
  }

  @override
  String staffEffectScoutCaps(int caps) {
    String _temp0 = intl.Intl.pluralLogic(
      caps,
      locale: localeName,
      other: 'Potansiyel $caps milli maçtan sonra biliniyor',
      one: 'Potansiyel 1 milli maçtan sonra biliniyor',
    );
    return '$_temp0';
  }

  @override
  String staffEffectScoutDossier(int points) {
    return 'Rakip dosyalarından +$points güç';
  }

  @override
  String staffHiringScoutRead(int min, int max) {
    return 'Birini işe almak: okumaların %$min ile %$max arası tam';
  }

  @override
  String staffHiringScoutCaps(int minCaps, int maxCaps) {
    return 've potansiyel $minCaps ile $maxCaps milli maç daha erken biliniyor';
  }

  @override
  String staffHiringScoutDossier(int minPoints, int maxPoints) {
    return 've her maçta +$minPoints ile +$maxPoints arası güç';
  }

  @override
  String get staffEffectNone => 'Kadronda henüz etkisi yok';

  @override
  String get staffVacant => 'Görevde kimse yok';

  @override
  String get staffLeaveVacant => 'Görevi boş bırak';

  @override
  String get managerTierNone => 'Yok';

  @override
  String get managerTierBasic => 'Temel';

  @override
  String get managerTierGood => 'İyi';

  @override
  String get managerTierElite => 'Elit';

  @override
  String get managerFree => 'ücretsiz';

  @override
  String get managerTraining => 'ARA DÖNEMLER';

  @override
  String get managerTrainingBlurb =>
      'Oynanacak maç olmadığında kadronun üzerinde çalıştığı konu.';

  @override
  String get managerFocusBalanced => 'Dengeli';

  @override
  String get managerFocusBalancedBlurb => 'Her şeyden biraz.';

  @override
  String get managerFocusFitness => 'Kondisyon';

  @override
  String get managerFocusFitnessBlurb => 'Daha az sakatlık.';

  @override
  String get managerFocusCohesion => 'Uyum';

  @override
  String get managerFocusCohesionBlurb => 'Diziliş daha hızlı oturur.';

  @override
  String get managerFocusYouth => 'Gençler';

  @override
  String get managerFocusYouthBlurb => 'Havuzdaki en gençlerle ekstra saatler.';

  @override
  String get tourOfferTitle => 'Burada ilk kez misin?';

  @override
  String get tourOfferBody =>
      'Bu büyük bir oyun. Önemli ekranlarda hızlı bir tur ister misin? Bir dakika sürer ve istediğin zaman Ayarlar\'dan yeniden başlatabilirsin.';

  @override
  String get tourOfferYes => 'Bana göster';

  @override
  String get tourOfferNo => 'Hayır, teşekkürler';

  @override
  String get tourBack => 'Geri';

  @override
  String get tourNext => 'İleri';

  @override
  String get tourDone => 'Bitti';

  @override
  String get tourSkip => 'Atla';

  @override
  String get tourHubTitle => 'Bütün oyun burada';

  @override
  String get tourHubBody =>
      'Tek bir düğme var ve dönem ilerledikçe değişiyor: izlenecek bir kura, açıklanacak bir kadro, oynanacak bir maç. Üstünde yönetimin sana güveni ve belirledikleri hedefler duruyor.';

  @override
  String get tourBudgetTitle => 'Federasyonun parası';

  @override
  String get tourBudgetBody =>
      'Dört yıllık her dönemde bir kez kasayı departmanlar arasında bölüştürürsün. Teknik ekibinin maaşları önce buradan ödenir. Yani elit bir gözlemci tutmak, akademiyle birlikte değil, akademiye karşı verdiğin bir karardır.';

  @override
  String get tourTacticsTitle => 'Takım nasıl oynuyor';

  @override
  String get tourTacticsBody =>
      'Dizilişin, oyun tarzın, kaptanın ve duran topları kimin kullanacağı. Son ikisini boş bırakırsan oyun, sessizce senin yerine seçmek yerine başlama vuruşundan önce seni uyarır.';

  @override
  String get tourSquadTitle => 'Seçebileceğin herkes';

  @override
  String get tourSquadBody =>
      'Sadece kadro değil, tüm havuz: kim formda, kimde sakatlık var, kim cezalı ve akademiden yeni kim çıktı.';

  @override
  String get tourCallUpsTitle => 'Kadro açıklamak';

  @override
  String get tourCallUpsBody =>
      'Her milli takım arasında tek bir kadro açıklarsın ve o kadro, gerçek bir teknik direktörde olduğu gibi, o arasının her maçını oynar. Arada biri sakatlanırsa senin yerine bir yedek çağrılır.';

  @override
  String get tourRecordsTitle => 'Kariyerin';

  @override
  String get tourRecordsBody =>
      'Yaptığın her şey: maçlar, takım rekorları, kupalar ve çalıştırdığın her ülke.';

  @override
  String get tourCupsTitle => 'Dünyanın geri kalanı';

  @override
  String get tourCupsBody =>
      'Şu an oynanan her organizasyon: gruplar, puan durumları ve eleme turları, senin olmadıkların da dahil. Sen katılma hakkı kazandın ya da kazanmadın, dünya oynamaya devam ediyor.';

  @override
  String get settingsTourTitle => 'Eğitimi yeniden oynat';

  @override
  String get settingsTourBlurb => 'Önemli ekranları baştan yeniden gez.';

  @override
  String get tourBoardTitle => 'Kime hesap veriyorsun';

  @override
  String get tourBoardBody =>
      'Yönetimin sana güveni ve bu dönem için belirledikleri hedefler. Beklentiyi kaçırırsan bunu ilk burada görürsün.';

  @override
  String get tourStaffTitle => 'Etrafındaki insanlar';

  @override
  String get tourStaffBody =>
      'Bir yardımcı, bir gözlemci ve bir atletik performans antrenörü, isim isim tutulur. Maaşları departmanlardan önce bu bütçeden çıkar, yani harika bir gözlemci akademiye karşı verilmiş bir karardır.';

  @override
  String get tourPlaystyleTitle => 'Oynama tarzın';

  @override
  String get tourPlaystyleBody =>
      'Diziliş taktiğin sadece yarısı. Diğer yarısı burada: ne kadar yüksek pres yaptığın, ne kadar direkt oynadığın, ne kadar risk aldığın.';

  @override
  String get settingsTourNoSave =>
      'Önce bir kariyer başlat. Tur senin kendi ekranlarını gezer.';

  @override
  String tacticsOutOfPositionAge(int age) {
    return 'Yerinde değil · Yaş $age';
  }

  @override
  String get federationNextCycleLocked =>
      'Bir sonraki dönemin bütçesi o dönemin başında tek seferde belirlenir. O zamana kadar paran şunları yapıyor.';

  @override
  String get federationBudgetAlreadySet => 'Bu dönem için zaten belirlendi';

  @override
  String yFinalLooms0(String opponent) {
    return 'Büyük final için rakip: $opponent. Bütün hafta herkes bunu konuşacak.';
  }

  @override
  String yFinalLooms1(String opponent) {
    return 'Kesinleşti: önümüzde $opponent var. Bunun için dört yıl bekledik.';
  }

  @override
  String yFinalLooms2(String opponent) {
    return 'Tamam. $opponent. Bu iş bitene kadar kimse uyumuyor.';
  }

  @override
  String yFinalLooms3(String opponent) {
    return 'Sırada $opponent var, gerisi bekleyebilir. Ne güzel bir hafta.';
  }

  @override
  String get matchSetupLeaveToCoach => 'Atıcıları antrenöre bırak';

  @override
  String friendliesLikeYourGroup(String rivals) {
    return 'Aşağıda işaretli: $rivals gibi oynayan takımlar, yani bu dönem gruplarında karşılaşacakların.';
  }

  @override
  String newsTransferWindowTitle(int year) {
    return 'Transfer dönemi · $year';
  }

  @override
  String careerLastAgo(String when) {
    return 'Son: $when önce';
  }

  @override
  String get settingsFreeScopeTitle => 'Bir ücretsiz dört yıllık dönem';

  @override
  String get settingsFreeScopeBlurb =>
      'Tam bir dönem (elemeler, kıta şampiyonan ve Dünya Şampiyonası) iki kayıtta, dünyadaki her ülke, hiçbir şey kısıtlanmadan. Sınırsız dönemler ve sınırsız kayıtlar tek seferlik bir ödemeyle gelir ve gelecekteki her güncellemeyi kapsar.';

  @override
  String get settingsUnlockedTitle => 'Kilidi açıldı';

  @override
  String get settingsUnlockedBlurb =>
      'Sınırsız dönemler, sınırsız kayıtlar ve gelecekteki her güncelleme. Teşekkürler.';

  @override
  String get settingsFromDeveloperTitle => 'Geliştiriciden';

  @override
  String get settingsFromDeveloperBlurb =>
      'Football Nations Manager tek bir kişi tarafından yapıldı ve uzun vadede desteklenecek. Hiçbir zaman reklam ya da mikro ödeme olmayacak. Oyunu beğeniyorsan lütfen tam sürümü almayı düşün. Güncellemelerin gelmesini sağlayan bu.';

  @override
  String get settingsFromDeveloperThanksBlurb =>
      'Football Nations Manager tek bir kişi tarafından yapıldı ve uzun vadede desteklenecek. Hiçbir zaman reklam ya da mikro ödeme olmayacak. Tam sürümü aldığın için teşekkürler. Güncellemelerin gelmesini sağlayan bu.';

  @override
  String friendliesLikeYourCampaign(String rivals) {
    return 'Aşağıda işaretli: $rivals gibi oynayan takımlar, yani hâlâ karşılaşman gerekenler.';
  }

  @override
  String get friendliesCloseToYou =>
      'Aşağıda işaretli: dünya sıralamasında sana en yakın takımlar. Kura çekildikten sonra işaretler grubunu izler.';

  @override
  String transfersMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hareket',
      one: '1 hareket',
    );
    return '$_temp0';
  }

  @override
  String hubRoundPage(int page, int pages) {
    return '$page / $pages';
  }

  @override
  String get transfersNewer => 'Yeni';

  @override
  String get transfersOlder => 'Daha fazla';

  @override
  String get transfersPagePrevious => 'Önceki';

  @override
  String get transfersPageNext => 'Sonraki';

  @override
  String transfersPageOf(int page, int pages) {
    return 'Sayfa $page / $pages';
  }

  @override
  String get transfersMovedTo => 'Şuraya geçti';

  @override
  String get transfersUnknownClub => 'Bilinmeyen kulüp';

  @override
  String yAgainstThemAgain0(String opponent, String count) {
    return '$opponent karşısında bu $count. maç oldu. Biri skoru tutuyor ve o biz değiliz.';
  }

  @override
  String yAgainstThemAgain1(String opponent, String count) {
    return 'Yine $opponent. $count karşılaşma oldu, hâlâ çözemedik.';
  }

  @override
  String yAgainstThemAgain2(String opponent, String count) {
    return '$opponent karşısında $count. maç. Bu artık tesadüf değil.';
  }

  @override
  String yAgainstThemAgain3(String opponent, String count) {
    return '$opponent ile $count kez oynadık ve hiçbirinden bir şey öğrenmedik.';
  }

  @override
  String yAgainstThemAgain4(String opponent, String count) {
    return '$opponent, $count kez. Ne yapacağımızı tam olarak biliyorlar.';
  }

  @override
  String yAgainstThemAgain5(String opponent, String count) {
    return '$opponent bizde ne bulduysa, $count karşılaşma sonra hâlâ elinde.';
  }

  @override
  String ySameOldStory0(String count) {
    return 'Son zamanlarda bu $count kez oldu. Hangi noktada bu bizim kendimiz olur?';
  }

  @override
  String ySameOldStory1(String count) {
    return 'Şimdi $count tane böyle öğleden sonra. Bu bir şans serisi değil, bir örüntü.';
  }

  @override
  String ySameOldStory2(String count) {
    return 'Bu maçı son zamanlarda tam $count kez gördük. Aynı senaryo, aynı son.';
  }

  @override
  String ySameOldStory3(String count) {
    return 'Aynı doksan dakikanın $count versiyonu oldu. Kimse düzeltmiyor.';
  }

  @override
  String ySameOldStory4(String count) {
    return '$count kez. Örüntüyü hâlâ göremiyorsan bakmıyorsun.';
  }

  @override
  String ySameOldStory5(String count) {
    return 'Aynı hikaye, $count kez üst üste. Sonuçlar bitmeden bahaneler bitti.';
  }

  @override
  String get yToldYouSo0 =>
      'Herkes kutlamayla meşgulken bunun geleceğini söylemiştim.';

  @override
  String get yToldYouSo1 =>
      'İki güzel hafta ve yine altın nesil olduk. Bak şimdi geldiğimiz yere.';

  @override
  String get yToldYouSo2 => 'Geçen ay keyfini çıkar diyenler sustu.';

  @override
  String get yToldYouSo3 =>
      'Bundan zevk almıyorum. Çok az zevk alıyorum. Biraz.';

  @override
  String get yToldYouSo4 =>
      'Size anlatıldığı kadar iyi hiç olmadı, bu da kanıtı.';

  @override
  String get yToldYouSo5 =>
      'Her seferinde. Bu sefer farklı deniyor ve her seferinde değil.';

  @override
  String get tacticsSubOffAlready => 'Zaten çıktı';

  @override
  String get tacticsSubInjured => 'Sakat';

  @override
  String get tacticsSubSentOffMark => 'Oyundan atıldı';

  @override
  String get tacticsSubNoneLeft => 'Değişiklik hakkı kalmadı';

  @override
  String get tacticsUndoLastChange => 'Son değişikliği geri al';

  @override
  String get matchStrengthTitle => 'TAKIMI NE HAREKETE GEÇİRİYOR';

  @override
  String get strengthFactorFamiliarity => 'Oturmuş diziliş';

  @override
  String get strengthFactorFatigue => 'Yorgun bacaklar';

  @override
  String get strengthFactorClubForm => 'Kulüp formu';

  @override
  String get strengthFactorMorale => 'Soyunma odası';

  @override
  String get strengthFactorCaptain => 'Kaptan';

  @override
  String get strengthFactorStaff => 'Teknik ekip';

  @override
  String get strengthFactorDossier => 'Gözlemcinin dosyası';

  @override
  String yDebut0(String name) {
    return '$name ilk milli maçına çıkıyor. Bu ismi aklınızda tutun.';
  }

  @override
  String yDebut1(String name) {
    return '$name için ilk maç. Üzerinde görülüyor, değil mi?';
  }

  @override
  String yDebut2(String name) {
    return '$name, ilk milli maç. Bakalım ne yapacak.';
  }

  @override
  String yDebut3(String name) {
    return '$name ilk kez sahada. Kadronun bir yerde taze bacağa ihtiyacı vardı.';
  }

  @override
  String yDebut4(String name) {
    return '$name milli forma giydi. Son zamanlarda çok dağıttık bunu.';
  }

  @override
  String yDebut5(String name) {
    return '$name için ilk maç. Baharda unutmuş olacağımız bir isim daha.';
  }

  @override
  String yDrought0(String name, String count) {
    return '$name $count maçtır gol atamadı ve sahada diğer her şeyi yapıyor.';
  }

  @override
  String yDrought1(String name, String count) {
    return '$name $count maçtır gol yok. Üçlü gelirler, hep öyleydi.';
  }

  @override
  String yDrought2(String name, String count) {
    return '$name: $count maç, gol yok.';
  }

  @override
  String yDrought3(String name, String count) {
    return '$name $count maçtır golsüz. Göz kulak olmaya değer.';
  }

  @override
  String yDrought4(String name, String count) {
    return '$count maç. Gol yok. $name denize düşse bir tane bile bulamaz.';
  }

  @override
  String yDrought5(String name, String count) {
    return '$name $count maçtır gol atmadı. Gerçekten başka birini oynatın.';
  }

  @override
  String yRivalryLooms0(String opponent, String count) {
    return 'Sırada $opponent var. $count karşılaşma oldu ve hâlâ her şey demek.';
  }

  @override
  String yRivalryLooms1(String opponent, String count) {
    return '$opponent karşısında $count. maç. Gelsin.';
  }

  @override
  String yRivalryLooms2(String opponent, String count) {
    return 'Sırada $opponent. Oynanan: $count.';
  }

  @override
  String yRivalryLooms3(String opponent, String count) {
    return 'Bu hafta $opponent ile $count. karşılaşma.';
  }

  @override
  String yRivalryLooms4(String opponent, String count) {
    return 'Yine $opponent. $count tane oldu ve hiçbir şey öğrenmedik.';
  }

  @override
  String yRivalryLooms5(String opponent, String count) {
    return '$opponent ile $count maç ve hâlâ bizi yeniyorlar. Harika.';
  }

  @override
  String get positionGoalkeeper => 'Kaleci';

  @override
  String get positionLeftBack => 'Sol Bek';

  @override
  String get positionCentreBack => 'Stoper';

  @override
  String get positionRightBack => 'Sağ Bek';

  @override
  String get positionDefensiveMid => 'Defansif Orta Saha';

  @override
  String get positionCentralMid => 'Merkez Orta Saha';

  @override
  String get positionAttackingMid => 'Ofansif Orta Saha';

  @override
  String get positionLeftMid => 'Sol Orta Saha';

  @override
  String get positionRightMid => 'Sağ Orta Saha';

  @override
  String get positionLeftWing => 'Sol Kanat';

  @override
  String get positionRightWing => 'Sağ Kanat';

  @override
  String get positionStriker => 'Forvet';

  @override
  String get roleNone => 'Rol yok';

  @override
  String get roleTargetMan => 'Hedef adam';

  @override
  String get rolePoacher => 'Fırsatçı golcü';

  @override
  String get rolePlaymaker => 'Oyun kurucu';

  @override
  String get roleBallWinner => 'Top kapıcı';

  @override
  String get roleInvertedWinger => 'İçe kat eden kanat';

  @override
  String get roleBallPlayingDefender => 'Oyun kuran defans';

  @override
  String get roleNoneBlurb => 'Doğal oyununu oynar.';

  @override
  String get roleTargetManBlurb =>
      'Kafa toplarını kazanır, topu açar. Asist ve duran toplar.';

  @override
  String get rolePoacherBlurb =>
      'Ceza sahasında pusuda bekler. Çok daha fazla gol.';

  @override
  String get rolePlaymakerBlurb => 'Pozisyon yaratır. Çok daha fazla asist.';

  @override
  String get roleBallWinnerBlurb => 'Oyunu bitirmek yerine bozar.';

  @override
  String get roleInvertedWingerBlurb =>
      'İçeri kat edip şut atar. Daha fazla gol.';

  @override
  String get roleBallPlayingDefenderBlurb => 'Hücumları geriden başlatır.';

  @override
  String get federationDeptYouth => 'Gençlik Akademisi';

  @override
  String get federationDeptCommercial => 'Ticari / Halkla İlişkiler';

  @override
  String get federationDeptMedical => 'Sağlık ve Spor Bilimi';

  @override
  String get federationDeptNaturalisation => 'Vatandaşlık Ofisi';

  @override
  String get federationDeptBoardRelations => 'Yönetim İlişkileri';

  @override
  String get federationDeptYouthBlurb =>
      'Daha iyi akademi yetenekleri gelecek dönem ülken için ilk maçına çıkar.';

  @override
  String get federationDeptCommercialBlurb =>
      'Sponsorluk dönem sonunda ekstra gelir getirir.';

  @override
  String get federationDeptMedicalBlurb =>
      'Daha az sakatlık. Kadron bütün dönem hazır kalır.';

  @override
  String get federationDeptNaturalisationBlurb =>
      'Daha fazla yabancı oyuncu ülkene geçmeyi teklif eder.';

  @override
  String get federationDeptBoardRelationsBlurb =>
      'Yönetim sonuçlarını daha sabırla değerlendirir.';

  @override
  String get federationBuildingAcademy => 'Akademi';

  @override
  String get federationBuildingCommercial => 'Ticari Merkez';

  @override
  String get federationBuildingMedical => 'Sağlık Merkezi';

  @override
  String get federationBuildingScouting => 'Gözlem Ofisi';

  @override
  String get federationBuildingBoardroom => 'Yönetim Salonu';

  @override
  String get moraleBuoyant => 'Coşkulu';

  @override
  String get moralePositive => 'Olumlu';

  @override
  String get moraleSettled => 'Oturmuş';

  @override
  String get moraleUneasy => 'Huzursuz';

  @override
  String get moraleRockBottom => 'Dipte';

  @override
  String get matchTabTimeline => 'AKIŞ';

  @override
  String get matchTabStats => 'İSTATİSTİK';

  @override
  String get matchTabLineups => 'KADROLAR';

  @override
  String get matchPenalty => 'PENALTI';

  @override
  String get matchStateLevel => 'Skor eşit';

  @override
  String matchStateLead(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gol önde gidiyorsun',
      one: 'Bir gol önde gidiyorsun',
    );
    return '$_temp0';
  }

  @override
  String matchStateTrail(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gol geridesin',
      one: 'Bir gol geridesin',
    );
    return '$_temp0';
  }

  @override
  String matchPossessionShare(int possession) {
    return '%$possession topa sahip olma';
  }

  @override
  String get boardVerdictSackedTitle => 'Yönetim kurulu seni görevden aldı';

  @override
  String boardVerdictSackedBody(int rating) {
    return 'Berbat bir dönem (değerlendirme %$rating). Görev süren burada sona eriyor. Artık seni ancak daha küçük ülkeler deneyecek.';
  }

  @override
  String get boardVerdictDelightedTitle => 'Yönetim kurulu çok memnun';

  @override
  String boardVerdictDelightedBody(int rating, String best) {
    return 'Olağanüstü bir dönem (değerlendirme %$rating). Dönemin öne çıkanı: $best. Daha büyük ülkeler ilgileniyor, istersen kalıp inşa etmeye devam edebilirsin.';
  }

  @override
  String get boardVerdictSolidTitle => 'Sağlam bir dönem';

  @override
  String boardVerdictSolidBody(int rating) {
    return 'Yönetim kurulu memnun (değerlendirme %$rating). Benzer seviyedeki birkaç ülke seni alırdı ama ayrılmak için bir baskı yok.';
  }

  @override
  String get boardVerdictExpectedMoreTitle =>
      'Yönetim kurulu daha fazlasını bekliyordu';

  @override
  String boardVerdictExpectedMoreBody(int rating) {
    return 'Hayal kırıklığı yaratan bir dönem (değerlendirme %$rating). İşin duruyor ama gelecek teklifler bir basamak aşağı olur.';
  }

  @override
  String get boardVerdictPressureTitle => 'Ciddi baskı altındasın';

  @override
  String boardVerdictPressureBody(int rating) {
    return 'Kötü bir dönem (değerlendirme %$rating). Görevde kalıyorsun ama yeni bir başlangıç istersen yalnızca daha zayıf ülkeler ilgilenir.';
  }

  @override
  String get boardVerdictHeroTitle => 'Ülke seni destekliyor';

  @override
  String boardVerdictHeroNote(String nation, int cycles) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles dönemin',
      one: '1 dönemin',
    );
    return ' $nation sana hayran, $_temp0 ardından ulusal bir kahramansın; istediğin sürece işin güvende.';
  }

  @override
  String get boardVerdictTheNation => 'Ülke';

  @override
  String get boardVerdictBestQuiet => 'sakin bir dönem';

  @override
  String get boardVerdictBestCycle => 'dönemin tamamı';

  @override
  String boardVerdictBestWorld(String placement) {
    return 'Dünya Şampiyonası, $placement';
  }

  @override
  String get finishThirdPlace => 'Üçüncülük';

  @override
  String get finishFourthPlace => 'Dördüncülük';

  @override
  String get finishDidNotQualify => 'Katılma hakkı kazanamadı';

  @override
  String get careerRepIconic => 'Efsanevi';

  @override
  String get careerRepRenowned => 'Ünlü';

  @override
  String get careerRepEstablished => 'Köklü';

  @override
  String get careerRepRising => 'Yükselen';

  @override
  String get careerRepUnproven => 'Denenmemiş';

  @override
  String get hubOfferStepUp => 'Bir üst basamak';

  @override
  String get hubOfferLateral => 'Yatay geçiş';

  @override
  String get hubOfferRebuild => 'Yeniden inşa';

  @override
  String careerNationsCupWon(String league) {
    return '$league Ligi · Şampiyon';
  }

  @override
  String careerNationsCupRunnerUp(String league) {
    return '$league Ligi · İkinci';
  }

  @override
  String careerNationsCupSemi(String league) {
    return '$league Ligi · Yarı finalist';
  }

  @override
  String careerNationsCupPlaced(String league, int position) {
    return '$league Ligi · #$position';
  }

  @override
  String tourRunInto(String round) {
    return 'Sıradaki tur: $round';
  }

  @override
  String get tourRunIntoThirdPlace => 'Sırada üçüncülük maçı var';

  @override
  String tourRunThrough(String round) {
    return 'Turu geçti: $round';
  }

  @override
  String tourRunOut(String round) {
    return 'Elendiği tur: $round';
  }

  @override
  String get tourRunInGroup => 'Grup aşamasında mücadele ediyor';

  @override
  String get tourRunGroupOut => 'Grup aşamasında elendi';

  @override
  String resultsCycleTitle(int year, String nation) {
    return '$year dönemi · $nation';
  }

  @override
  String resultsCycleRecord(int played, int won, int drawn, int lost) {
    return '$played maç  ·  ${won}G ${drawn}B ${lost}M';
  }

  @override
  String resultsCycleFinish(String finish) {
    return 'Dünya Şampiyonası: $finish';
  }

  @override
  String get resultsCycleUnderway => 'Hâlâ oynanıyor';

  @override
  String yTurnedItRound0(String opponent) {
    return 'Devre arasında $opponent karşısında iki geride, hepsini geri aldılar. İşte takım dediğin bu.';
  }

  @override
  String yTurnedItRound1(String opponent) {
    return '$opponent karşısında iki geriydik, sonunda önemi kalmadı. Çok takım bunu yapamaz.';
  }

  @override
  String yTurnedItRound2(String opponent) {
    return 'Devre arası: $opponent karşısında iki gol geride. Maç sonu: değil. İkinci yarı bambaşka bir maçtı.';
  }

  @override
  String yTurnedItRound3(String opponent) {
    return '$opponent karşısında iki gol geriden gelindi. Devre arasında ne söylendiyse, her hafta söyleyin.';
  }

  @override
  String yTurnedItRound4(String opponent) {
    return 'Tamam, $opponent karşısında geri aldık. Şimdi biri ilk kırk beş dakikayı açıklasın.';
  }

  @override
  String yTurnedItRound5(String opponent) {
    return '$opponent karşısında iki geride kaldık ve sevinmemiz mi bekleniyor? İlk yarıyı düzeltin.';
  }

  @override
  String yThrewItAway0(String opponent) {
    return 'Devre arasında $opponent karşısında iki öndeydik, elimizden kaçtı. Daha iyi takımların da başına gelir.';
  }

  @override
  String yThrewItAway1(String opponent) {
    return '$opponent karşısında iki gol öndeydik, kaçtı gitti. Önümüzde uzun bir dönem var, vakit bol.';
  }

  @override
  String yThrewItAway2(String opponent) {
    return 'Devre arası: $opponent karşısında iki gol önde. Maç sonu: alakası yok.';
  }

  @override
  String yThrewItAway3(String opponent) {
    return '$opponent karşısında iki gollük fark, kırk beş dakika içinde buharlaştı.';
  }

  @override
  String yThrewItAway4(String opponent) {
    return 'İki öndeydik, kaybettik. Hem de $opponent karşısında. Birileri bunun hesabını versin.';
  }

  @override
  String yThrewItAway5(String opponent) {
    return '$opponent karşısında iki gol öndeyiz ve yine bunu başardık. Her seferinde.';
  }

  @override
  String get cycleBackupDone =>
      'Kariyer bu telefondaki FNM klasörüne yedeklendi. Uygulamayı silersen yedek de gider: başka bir yerde kopya tutmak için kayıtlar ekranındaki Bu kaydı yedekle seçeneğini kullan.';

  @override
  String get cycleBackupFailed => 'Kariyer bu sefer yedeklenemedi.';

  @override
  String pressMomentBigWinWarm1(String opponent) {
    return '$opponent karşısında unutulmaz bir gece. Bu grupla ne kadar gurur duyuyorsunuz?';
  }

  @override
  String pressMomentBigWinWarm2(String opponent) {
    return '$opponent size ayak uyduramadı. Hep inandığınız takım bu muydu?';
  }

  @override
  String pressMomentBigWinNeutral1(String opponent) {
    return '$opponent karşısında büyük bir galibiyet. Bu gece farkı ne yarattı?';
  }

  @override
  String pressMomentBigWinNeutral2(String opponent) {
    return '$opponent yenildi, üstelik rahat. Maçı nerede kazandınız?';
  }

  @override
  String pressMomentBigWinHostile1(String opponent) {
    return '$opponent karşısında güzel bir galibiyet. Tek bir iyi gece: bunun süreceğine kim neden inansın?';
  }

  @override
  String pressMomentBigWinHostile2(String opponent) {
    return '$opponent karşısında güzel bir sonuç. Plan sizin miydi, yoksa oyuncular kendi başlarına mı çözdü?';
  }

  @override
  String pressMomentBigLossWarm1(String opponent) {
    return '$opponent karşısında zor bir gece. Böyle bir maçtan sonra oyunculara ne diyorsunuz?';
  }

  @override
  String pressMomentBigLossWarm2(String opponent) {
    return '$opponent karşısında bunu kimse beklemiyordu. Sadece öyle bir geceydi herhalde?';
  }

  @override
  String pressMomentBigLossNeutral1(String opponent) {
    return '$opponent karşısında ders gibi bir geceydi. Neyin yanlış gitti?';
  }

  @override
  String pressMomentBigLossNeutral2(String opponent) {
    return '$opponent sizi paramparça etti. Bu kadro yeterince iyi mi?';
  }

  @override
  String pressMomentBigLossHostile1(String opponent) {
    return '$opponent karşısında her şeyde geriydiniz. İşi bu kadar kötüye nasıl vardırdınız?';
  }

  @override
  String pressMomentBigLossHostile2(String opponent) {
    return '$opponent canının istediği kadar gol attı. Bu gece plan neredeydi?';
  }

  @override
  String pressMomentCrisisWarm1(String opponent) {
    return 'Bir maç daha elden gitti, bu kez $opponent karşısında. Bu gidişi nasıl çevireceksiniz?';
  }

  @override
  String pressMomentCrisisWarm2(String opponent) {
    return 'Sonuçlar kurudu, $opponent da işi daha da kötüleştirdi. Bu gruba hâlâ inanıyor musunuz?';
  }

  @override
  String pressMomentCrisisNeutral1(String opponent) {
    return 'Yine galibiyet yok, bu kez $opponent karşısında, üstelik yönetim izliyor. İşiniz güvende mi?';
  }

  @override
  String pressMomentCrisisNeutral2(String opponent) {
    return '$opponent maçından sonra seri uzuyor. Geleceğiniz için endişeli misiniz?';
  }

  @override
  String pressMomentCrisisHostile1(String opponent) {
    return 'Şimdi bir de $opponent. Sizden önceki hoca böyle bir seride gönderildi. Siz neden kurtulasınız?';
  }

  @override
  String pressMomentCrisisHostile2(String opponent) {
    return '$opponent gibi bir gecenin ardından canlı yayınların hepsi gitmenizi istiyor. Yönetim isterse istifa eder misiniz?';
  }

  @override
  String pressMomentJobVerdictWarm1(String opponent) {
    return 'İşinizi ortaya koydunuz ve $opponent maçından sonra istediğiniz gibi gitmedi. Nasıl dayanıyorsunuz?';
  }

  @override
  String pressMomentJobVerdictWarm2(String opponent) {
    return 'Üç maç bitti, sonuncusu $opponent karşısındaydı. Sınavı kendiniz koydunuz. Bu karara ne diyorsunuz?';
  }

  @override
  String pressMomentJobVerdictNeutral1(String opponent) {
    return 'Bizden sizi önümüzdeki üç maçla yargılamamızı istediniz. $opponent maçından sonra yargıladık. İşiniz hâlâ sizin mi?';
  }

  @override
  String pressMomentJobVerdictNeutral2(String opponent) {
    return 'Üç maç, sonuncusu $opponent karşısında, ve sözünüzü verdiğiniz gibi değil. Geleceğiniz hakkında yönetimle konuştunuz mu?';
  }

  @override
  String pressMomentJobVerdictHostile1(String opponent) {
    return 'Sınavı kendiniz koydunuz ve $opponent karşısında kaldınız. İstifa edecek misiniz?';
  }

  @override
  String pressMomentJobVerdictHostile2(String opponent) {
    return 'Sözler sizin, bizim değil: beni önümüzdeki üç maçla yargılayın. $opponent maçından sonra neden hâlâ orada oturuyorsunuz?';
  }

  @override
  String get pressBeatWhoToBlameWarm1 =>
      'Onlardan daha fazlasını istiyorsunuz. Özellikle biri var mı?';

  @override
  String get pressBeatWhoToBlameWarm2 =>
      'Çıtayı yüksek koydunuz. Önce kim ayağa kalkmalı?';

  @override
  String get pressBeatWhoToBlameNeutral1 =>
      'Bazılarının kendine bakması gerektiğini söylüyorsunuz. Kimi kastediyorsunuz?';

  @override
  String get pressBeatWhoToBlameNeutral2 =>
      'Yeterince iyi değil diyorsunuz. Kimden söz ediyorsunuz?';

  @override
  String get pressBeatWhoToBlameHostile1 =>
      'Muğlak konuşuyorsunuz. İsim verecek misiniz, yoksa iş size mi dönüyor?';

  @override
  String get pressBeatWhoToBlameHostile2 =>
      'Her hafta suç başkasında. Bu sefer kimde?';

  @override
  String get pressBeatIfYouDontWarm1 =>
      'Cesur sözler. Peki bir sonraki maç istediğiniz gibi gitmezse?';

  @override
  String get pressBeatIfYouDontWarm2 =>
      'Ülke sizi bu sözünüzle tutacak. Ya tutmazsa?';

  @override
  String get pressBeatIfYouDontNeutral1 =>
      'Ya kazanamazsanız? O zaman ne olacak?';

  @override
  String get pressBeatIfYouDontNeutral2 =>
      'Şimdi söylediniz. Yanılırsanız ne olacak?';

  @override
  String get pressBeatIfYouDontHostile1 =>
      'Bu salonda daha önce de sözler duyduk. Bu da tutmazsa taraftara ne borçlusunuz?';

  @override
  String get pressBeatIfYouDontHostile2 => 'Olmayınca bahane ne olacak?';

  @override
  String get pressBeatFollowUpWarm1 =>
      'Bir tane daha, gücünüz varsa. Bu grubun hâlâ neyi geliştirmesi gerek?';

  @override
  String get pressBeatFollowUpWarm2 =>
      'Toz duman dinince, bu geceden bir sonraki maça ne taşıyorsunuz?';

  @override
  String get pressBeatFollowUpNeutral1 =>
      'Biraz daha derine inelim. Bir sonraki maçtan önce neyin düzelmesi gerek?';

  @override
  String get pressBeatFollowUpNeutral2 =>
      'Skorun ötesinde: bu kadro olmasını istediğiniz yerde mi?';

  @override
  String get pressBeatFollowUpHostile1 =>
      'Çok söz, az anlam. Bundan sonra gerçekte ne değişiyor?';

  @override
  String get pressBeatFollowUpHostile2 =>
      'Taraftar net bir cevap istiyor. Bu takım yeterince iyi mi, evet mi hayır mı?';

  @override
  String pressBeatStandoutWarm1(String player) {
    return '$player bu gece harikaydı. Nereye kadar gidebilir?';
  }

  @override
  String pressBeatStandoutWarm2(String player) {
    return '$player bu gece her manşette. Bunu bekliyor muydunuz?';
  }

  @override
  String pressBeatStandoutNeutral1(String player) {
    return '$player öne çıktı. Ondan bu gece ne istemiştiniz?';
  }

  @override
  String pressBeatStandoutNeutral2(String player) {
    return 'Bu gece farkı yaratan $player mıydı?';
  }

  @override
  String pressBeatStandoutHostile1(String player) {
    return '$player olmasa bambaşka bir hikaye olurdu. Bu bir takım mı, yoksa tek bir oyuncu mu?';
  }

  @override
  String pressBeatStandoutHostile2(String player) {
    return '$player muhteşemdi. Sizin eseriniz mi, onun mu?';
  }

  @override
  String pressBeatStrugglerWarm1(String player) {
    return '$player için zor bir geceydi. Bir sakatlığı mı var?';
  }

  @override
  String pressBeatStrugglerWarm2(String player) {
    return '$player gecesinde değildi. Yanında olacak mısınız?';
  }

  @override
  String pressBeatStrugglerNeutral1(String player) {
    return '$player bu gece zorlandı. Yerini koruyor mu?';
  }

  @override
  String pressBeatStrugglerNeutral2(String player) {
    return '$player tempoya yetişemedi. Oyununu nasıl gördünüz?';
  }

  @override
  String pressBeatStrugglerHostile1(String player) {
    return '$player yine yolcu gibiydi. Onu neden oynatmaya devam ediyorsunuz?';
  }

  @override
  String pressBeatStrugglerHostile2(String player) {
    return '$player formunda değildi, herkes gördü. Yedek kulübesi hariç herkes mi?';
  }

  @override
  String get pressThrowbackWinNextKeptWarm =>
      'Bir sonrakini kazanacağız demiştiniz ve kazandınız. Haklı çıkmak nasıl hissettiriyor?';

  @override
  String get pressThrowbackWinNextKeptNeutral =>
      'Bir sonraki maçta galibiyet sözü verdiniz ve tuttunuz. Özgüven mi, caka mı?';

  @override
  String get pressThrowbackWinNextKeptHostile =>
      'Bir sonrakini kazanacağız demiştiniz ve kazandınız. Şans mı, yoksa artık sizi dinlemeye mi başlayalım?';

  @override
  String get pressThrowbackWinNextBrokenWarm =>
      'O maçı kazanacağınızı söylemiştiniz. Olmadı. Neyin yanlış gitti?';

  @override
  String get pressThrowbackWinNextBrokenNeutral =>
      'Bir sonrakini kazanacağız demiştiniz. Kazanamadınız. Sonraki sözünüze neden inanalım?';

  @override
  String get pressThrowbackWinNextBrokenHostile =>
      'Bir sonrakini kazanacağız demiştiniz. Kazanamadınız. Sözlerinizin bu salonda hâlâ bir anlamı var mı?';

  @override
  String get pressThrowbackJobKeptWarm =>
      'Üç maçla yargılanmak istediniz ve geçtiniz. Haklı çıktınız mı?';

  @override
  String get pressThrowbackJobKeptNeutral =>
      'Beni önümüzdeki üç maçla yargılayın demiştiniz. Yargıladık, sonuçlar geldi. Bu sınav size ne öğretti?';

  @override
  String get pressThrowbackJobKeptHostile =>
      'Kendinize üç maç verdiniz ve atlattınız. Sınav hiç o kadar zor muydu?';

  @override
  String get pressThrowbackJobBrokenWarm =>
      'Üç maçla yargılanmak istediniz. Maçlar istediğiniz gibi gitmedi. Ne öğrendiniz?';

  @override
  String get pressThrowbackJobBrokenNeutral =>
      'Beni önümüzdeki üç maçla yargılayın demiştiniz. Üç maç bitti, şüphe payı da bitti. Şimdi ne olacak?';

  @override
  String get pressThrowbackJobBrokenHostile =>
      'Sınavı siz koydunuz ve kaldınız. Artık kim sözünüze güvensin?';

  @override
  String pressThrowbackBackKeptWarm(String player) {
    return 'Başkaları yapmazken $player oyuncusunun arkasında durdunuz. O da karşılığını verdi. Payınız var mı bunda?';
  }

  @override
  String pressThrowbackBackKeptNeutral(String player) {
    return '$player oyuncusunun arkasında durdunuz. Karşılığını verdi. İnanç mı, bilgi mi?';
  }

  @override
  String pressThrowbackBackKeptHostile(String player) {
    return '$player oyuncusunun arkasında durdunuz ve bu kez işe yaradı. Bir dahaki sefer de bu kadar emin olacak mısınız?';
  }

  @override
  String pressThrowbackBackBrokenWarm(String player) {
    return '$player oyuncusunun arkasında durdunuz ve iş yürümedi. Ona hâlâ inanıyor musunuz?';
  }

  @override
  String pressThrowbackBackBrokenNeutral(String player) {
    return '$player oyuncusunun arkasında durdunuz. O karşılığını vermedi. Hata mıydı?';
  }

  @override
  String pressThrowbackBackBrokenHostile(String player) {
    return 'Muhakemeniz mi, sadakatiniz mi: $player konusunda hangisi sizi yanılttı?';
  }

  @override
  String pressThrowbackBlameKeptWarm(String player) {
    return '$player konusunda sert davrandınız ve o günden beri maçlar sizi haklı çıkardı. Bunda bir tatmin var mı?';
  }

  @override
  String pressThrowbackBlameKeptNeutral(String player) {
    return '$player konusunda onu açıkça eleştirdiniz ve cevap vermedi. Onun için bir dönüş yolu var mı?';
  }

  @override
  String pressThrowbackBlameKeptHostile(String player) {
    return '$player konusunda onu ortada bıraktınız ve toparlanamadı. Onu siz mi bitirdiniz?';
  }

  @override
  String pressThrowbackBlameBrokenWarm(String player) {
    return '$player konusunda onu eleştirdiniz, o da size sahada cevap verdi. Baştan beri plan bu muydu?';
  }

  @override
  String pressThrowbackBlameBrokenNeutral(String player) {
    return '$player konusunda onu suçladınız, o günden beri en iyilerinizden biri. Ona bir özür borçlu musunuz?';
  }

  @override
  String pressThrowbackBlameBrokenHostile(String player) {
    return '$player konusunda onu harcadınız ve o günden beri en iyi oyuncunuz. Özür dileyecek misiniz?';
  }

  @override
  String get pressReplyCreditPlayers1 =>
      'Bu oyuncular bana her şeylerini verdi. Hiçbirini başkasıyla değiştirmem.';

  @override
  String get pressReplyCreditPlayers2 =>
      'Bu gruptan çok çalışan yok. Hepsini gün boyu savunurum.';

  @override
  String get pressReplyCreditPlayers3 =>
      'Bu koltuktan oyuncularım aleyhine tek kelime duymayacaksınız.';

  @override
  String get pressReplyCreditPlayers4 =>
      'Övgüyü oyuncular hak ediyor, ben değil. Onlar hakkında yazın.';

  @override
  String get pressReplyTakeResponsibility1 =>
      'Bu benim hatam. Kadroyu ben seçtim, takımı ben kurdum.';

  @override
  String get pressReplyTakeResponsibility2 =>
      'Beni yargılayın, onları değil. Bu benim takımım, sorumluluk bende.';

  @override
  String get pressReplyTakeResponsibility3 =>
      'Suçlayacak biri arıyorsanız, tam karşınızda oturuyorum.';

  @override
  String get pressReplyTakeResponsibility4 =>
      'Sorumluluk benim. Oyuncuları işin dışında tutun.';

  @override
  String get pressReplyDemandMore1 =>
      'Daha fazlasını istiyorum. Bazıları tam olarak neyi kastettiğimi biliyor.';

  @override
  String get pressReplyDemandMore2 =>
      'Bu seviyede çaba yetmez. Daha fazlasını istiyorum ve onlara da söyledim.';

  @override
  String get pressReplyDemandMore3 =>
      'Her birinden daha fazlasını bekliyorum, yarından başlayarak.';

  @override
  String get pressReplyDemandMore4 =>
      'Bazılarının kendine bakması gerek. Memnun değilim.';

  @override
  String get pressReplyPromiseWinNext1 =>
      'Bir sonrakini kazanacağız. Not edebilirsiniz.';

  @override
  String get pressReplyPromiseWinNext2 =>
      'Sözümü not edin: bir sonraki maçı kazanıyoruz.';

  @override
  String get pressReplyPromiseWinNext3 =>
      'Bir sonraki maç, kazanıyoruz. Bunu burada söylüyorum ki beni sözümle tutabilesiniz.';

  @override
  String get pressReplyPromiseWinNext4 =>
      'Bu takımdan eminim. Bir sonraki maçı kazanıyoruz.';

  @override
  String get pressReplyJobOnTheLine1 =>
      'Beni önümüzdeki üç maçla yargılayın. Bu adil.';

  @override
  String get pressReplyJobOnTheLine2 =>
      'Bana üç maç verin. O zamana kadar düzelmezse beni buna göre yargılayın.';

  @override
  String get pressReplyJobOnTheLine3 =>
      'Önümüzdeki üç maç doğru adam olup olmadığımı gösterecek. Beni sözümle tutun.';

  @override
  String get pressReplyJobOnTheLine4 =>
      'Üç maç. Sonra hakkımda ne isterseniz yazın.';

  @override
  String get pressReplyDeflect1 =>
      'Maç maç gidiyoruz. Eklenecek başka bir şey yok.';

  @override
  String get pressReplyDeflect2 => 'Bugün sizin için manşet olmayacağım.';

  @override
  String get pressReplyDeflect3 => 'Bir sonraki maç. Tek düşündüğüm bu.';

  @override
  String get pressReplyDeflect4 => 'Ne düşündüğüm soyunma odasında kalır.';

  @override
  String get pressReplyTakeCredit1 =>
      'İnandığım için söyledim ve haklı çıktım.';

  @override
  String get pressReplyTakeCredit2 => 'Doğru okudum. Burada olma sebebim bu.';

  @override
  String get pressReplyTakeCredit3 =>
      'Buna isabet deyin. Ne söylediğimi biliyordum.';

  @override
  String get pressReplyTakeCredit4 =>
      'Kararı ben verdim ve tuttu. Bunu üstlenirim.';

  @override
  String get pressReplyStandByIt1 => 'İnandığımı söyledim. Arkasındayım.';

  @override
  String get pressReplyStandByIt2 => 'Tek kelimesini geri almıyorum.';

  @override
  String get pressReplyStandByIt3 =>
      'O zamanki cevabımla aynı. Ciddiydim, hâlâ da öyleyim.';

  @override
  String get pressReplyStandByIt4 => 'Yarın yine söylerdim.';

  @override
  String get pressReplyAdmitMistake1 =>
      'Bunda yanıldım. Sorumluluğunu alıyorum.';

  @override
  String get pressReplyAdmitMistake2 =>
      'Haklısınız, yanlış değerlendirdim. Bundan ders çıkaracağım.';

  @override
  String get pressReplyAdmitMistake3 => 'Yanıldım ve bunu söyleyebilirim.';

  @override
  String get pressReplyAdmitMistake4 => 'O karar işe yaramadı ve benimdi.';

  @override
  String pressReplyBackPlayer1(String player) {
    return '$player benim tam desteğimi alıyor. Formuna dönecek.';
  }

  @override
  String pressReplyBackPlayer2(String player) {
    return '$player oyuncusuna inanıyorum ve nedenini size gösterecek.';
  }

  @override
  String pressReplyBackPlayer3(String player) {
    return '$player aleyhine benden tek kelime duymayacaksınız. Üretecek.';
  }

  @override
  String pressReplyBackPlayer4(String player) {
    return '$player planlarımın içinde kalıyor. Bundan sonra ne yaptığına bakın.';
  }

  @override
  String pressReplyBlamePlayer1(String player) {
    return '$player bu gece bizi yüzüstü bıraktı ve bunu biliyor.';
  }

  @override
  String pressReplyBlamePlayer2(String player) {
    return '$player oyuncusundan çok daha fazlasını bekliyordum. Buna cevap vermek zorunda.';
  }

  @override
  String pressReplyBlamePlayer3(String player) {
    return '$player seviyede değildi. Bunu açıkça söylüyorum.';
  }

  @override
  String pressReplyBlamePlayer4(String player) {
    return '$player için bu yeterince iyi değildi ve bunu benden duyacak.';
  }

  @override
  String get pressOnRecordWinNext =>
      'Kayıtlara geçti: bir sonraki maçı kazanacaksın.';

  @override
  String get pressOnRecordJob =>
      'Kayıtlara geçti: önümüzdeki üç maçla yargılanacaksın.';

  @override
  String pressOnRecordBack(String player) {
    return 'Kayıtlara geçti: $player oyuncusunun arkasındasın.';
  }

  @override
  String pressOnRecordBlame(String player) {
    return 'Kayıtlara geçti: $player seni yüzüstü bıraktı.';
  }

  @override
  String yStatementKept0(String nation) {
    return 'Söyledi ve oldu. $nation sözünün arkasında duran bir teknik direktöre sahip.';
  }

  @override
  String yStatementKept1(String nation) {
    return 'Yüksek sesle söyledi, sonra gidip yaptı. $nation tam da bu adama muhtaçtı.';
  }

  @override
  String yStatementKept2(String nation) {
    return '$nation: dedi, doğru çıktı. Hakkını verelim.';
  }

  @override
  String yStatementKept3(String nation) {
    return 'Kayda geçirdi ve tuttu. Bir puan onda. $nation yoluna devam ediyor.';
  }

  @override
  String yStatementKept4(String nation) {
    return 'Bir tanesini doğru bildi. $nation, alışma bence.';
  }

  @override
  String yStatementKept5(String nation) {
    return 'Bozuk saat bile günde iki kez doğruyu gösterir. $nation bu sefer şanslıymış.';
  }

  @override
  String yStatementBroken0(String nation) {
    return 'Söyledi ve tutmadı. Hâlâ onunlayım. $nation yeniden deniyor.';
  }

  @override
  String yStatementBroken1(String nation) {
    return '$nation: aldığımızdan fazlasını vaat etti ama kendine güvenen bir hoca tercih ederim.';
  }

  @override
  String yStatementBroken2(String nation) {
    return '$nation: kayıtlara geçirdi ve olmadı. İnsanlar hatırlayacak.';
  }

  @override
  String yStatementBroken3(String nation) {
    return 'Büyük laflar, arkasında hiçbir şey yok. $nation: bir dahaki sefere daha az konuş.';
  }

  @override
  String yStatementBroken4(String nation) {
    return 'Karşımıza geçip söyledi. Sonra bu. $nation lafa değil, daha iyisini hak ediyor.';
  }

  @override
  String yStatementBroken5(String nation) {
    return 'Sözünün artık hiçbir değeri yok. Not edin, $nation.';
  }

  @override
  String get ncZoneNorth => 'Kuzey Bölgesi';

  @override
  String get ncZoneWest => 'Batı Bölgesi';

  @override
  String get ncZoneEast => 'Doğu Bölgesi';

  @override
  String get ncZoneCentralSouthern => 'Orta ve Güney Bölgesi';

  @override
  String careerNationsCupZoneWon(String zone) {
    return '$zone · Şampiyon';
  }

  @override
  String careerNationsCupZoneRunnerUp(String zone) {
    return '$zone · İkinci';
  }

  @override
  String careerNationsCupZoneSemi(String zone) {
    return '$zone · Yarı finalist';
  }

  @override
  String careerNationsCupZoneRoundOf16(String zone) {
    return '$zone · Son 16 turu';
  }

  @override
  String careerNationsCupZoneQuarter(String zone) {
    return '$zone · Çeyrek finalist';
  }

  @override
  String careerNationsCupZonePlaced(String zone, int position) {
    return '$zone · #$position';
  }

  @override
  String get objectiveNcFinalsEight => 'Çeyrek finale çık';

  @override
  String get objectiveNcZoneWinGroup => 'Grubunu birinci bitir';

  @override
  String get finishNcFinalsEight => 'Çeyrek final';

  @override
  String get finishNcBottomHalf => 'Grubun alt yarısı';

  @override
  String get tourContTabZones => 'BÖLGELER';

  @override
  String get tourContTabFinalsEight => 'ELEME TURLARI';

  @override
  String get tourContFinalsEightSoon =>
      'Eleme turları Kasım\'da son 16 turuyla başlıyor: 14 grup birincisinin tamamı ve en iyi 2 ikinci.';

  @override
  String get tourContQuarterFinals => 'ÇEYREK FİNALLER';

  @override
  String get tourContZoneAdvancement =>
      'Her grup birincisi son 16 turuna çıkar, en iyi 2 ikinci de onlara katılır. Küme düşen yok.';

  @override
  String tourContZoneHeadingYours(String zone) {
    return '$zone ★';
  }

  @override
  String get compNorthAmericaNationsCup => 'Kuzey Amerika Uluslar Kupası';

  @override
  String get compAfricanNationsCup => 'Uluslar Kupası';

  @override
  String get objectiveNcWinItNorthAmerica =>
      'Kuzey Amerika Uluslar Kupası\'nı kazan';

  @override
  String get objectiveNcWinItAfrica => 'Uluslar Kupası\'nı kazan';

  @override
  String get objectiveNcReachFinalNorthAmerica =>
      'Kuzey Amerika Uluslar Kupası finaline çık';

  @override
  String get objectiveNcReachFinalAfrica => 'Uluslar Kupası finaline çık';

  @override
  String get finishNcChampionsNorthAmerica =>
      'Kuzey Amerika Uluslar Kupası şampiyonu';

  @override
  String get finishNcChampionsAfrica => 'Uluslar Kupası şampiyonu';

  @override
  String pressAimQualWarm1(String competition) {
    return '$competition elemeleri başlıyor ve ülke bu takıma inanıyor. Hedefiniz ne?';
  }

  @override
  String pressAimQualWarm2(String competition) {
    return 'Yeni bir $competition eleme kampanyası ve moraller yüksek. Bu takım nereye kadar gidebilir?';
  }

  @override
  String pressAimQualNeutral1(String competition) {
    return '$competition elemeleri başlıyor. Bu kampanyanın hedefi ne?';
  }

  @override
  String pressAimQualNeutral2(String competition) {
    return '$competition eleme maçları geldi çattı. Bu takımı nerede bitirirken görüyorsunuz?';
  }

  @override
  String pressAimQualHostile1(String competition) {
    return '$competition elemeleri başlıyor ve çok kişi oraya varacağınızdan şüpheli. Onlara ne diyorsunuz?';
  }

  @override
  String pressAimQualHostile2(String competition) {
    return 'Bir $competition eleme kampanyası daha. Bu seferin farklı olacağına kim neden inansın?';
  }

  @override
  String pressAimFinalsWarm1(String competition) {
    return '$competition başladı ve tüm ülke arkanızda. Nereye kadar gidebilirsiniz?';
  }

  @override
  String pressAimFinalsWarm2(String competition) {
    return '$competition turnuvasındasınız ve taraftarlar hayal kuruyor. Hedef ne?';
  }

  @override
  String pressAimFinalsNeutral1(String competition) {
    return '$competition bu hafta başlıyor. Neyi başarı sayarsınız?';
  }

  @override
  String pressAimFinalsNeutral2(String competition) {
    return '$competition turnuvasındaki ilk maçınız yakın. Bize bir hedef koyun.';
  }

  @override
  String pressAimFinalsHostile1(String competition) {
    return '$competition geldi ve kimse fazla bir şey beklemiyor. Gerçekte ne umuyorsunuz?';
  }

  @override
  String pressAimFinalsHostile2(String competition) {
    return '$competition turnuvasındasınız ama şüpheler gitmedi. Hedefiniz ne?';
  }

  @override
  String pressBeatRivalWarm1(String rival) {
    return '$rival sizin grubunuzda. Sizi endişelendiriyor mu?';
  }

  @override
  String pressBeatRivalWarm2(String rival) {
    return 'Kura $rival takımını önünüze çıkardı. O maçı nasıl görüyorsunuz?';
  }

  @override
  String pressBeatRivalNeutral1(String rival) {
    return 'Grubunuzdaki en güçlü takım $rival gibi görünüyor. Favori onlar mı?';
  }

  @override
  String pressBeatRivalNeutral2(String rival) {
    return '$rival hakkında ne düşünüyorsunuz?';
  }

  @override
  String pressBeatRivalHostile1(String rival) {
    return '$rival sizin grubunuzda. Dürüst olun, onlara dayanabilir misiniz?';
  }

  @override
  String pressBeatRivalHostile2(String rival) {
    return 'Çoğu kişi $rival takımının sizi yeneceğini düşünüyor. Yanılıyorlar mı?';
  }

  @override
  String pressBeatKeyPlayerWarm1(String player) {
    return '$player harika formda. Bu onun zamanı mı?';
  }

  @override
  String pressBeatKeyPlayerWarm2(String player) {
    return '$player her manşette. Bu takımı sırtlayabilir mi?';
  }

  @override
  String pressBeatKeyPlayerNeutral1(String player) {
    return 'Bu kampanya $player oyuncusuna ne kadar bağlı?';
  }

  @override
  String pressBeatKeyPlayerNeutral2(String player) {
    return '$player bu takımı yönetmeye hazır mı?';
  }

  @override
  String pressBeatKeyPlayerHostile1(String player) {
    return '$player en iyi halinde değilse, bu takımın elinde bir şey kalıyor mu?';
  }

  @override
  String pressBeatKeyPlayerHostile2(String player) {
    return '$player omuzlarında çok yük taşıyor. Fazla mı?';
  }

  @override
  String get pressReplyAimHigher1 =>
      'Kimsenin beklediğinden daha ileri gidiyoruz.';

  @override
  String get pressReplyAimHigher2 =>
      'Federasyonun istediğinden fazlasını istiyorum ve bunu yüksek sesle söylüyorum.';

  @override
  String get pressReplyMatchBrief1 => 'Hedefi biliyoruz ve ona ulaşacağız.';

  @override
  String get pressReplyMatchBrief2 =>
      'Federasyon bir hedef koydu. Onu yerine getireceğiz.';

  @override
  String get pressReplyPlayDown1 => 'Maç maç gidelim.';

  @override
  String get pressReplyPlayDown2 =>
      'Büyük sözler yok. Nerede olduğumuzu göreceğiz.';

  @override
  String get pressReplyPromiseQualify1 =>
      'Katılma hakkı kazanacağız. Not edebilirsiniz.';

  @override
  String get pressReplyPromiseQualify2 => 'Bu takım final turnuvasında olacak.';

  @override
  String get pressReplyFearNobody1 => 'Kimseden korkmuyoruz.';

  @override
  String get pressReplyFearNobody2 => 'Onların da bizimle oynaması gerekiyor.';

  @override
  String get pressReplyRespectRival1 =>
      'Favori onlar ve onlara saygı duyuyoruz.';

  @override
  String get pressReplyRespectRival2 =>
      'Çok iyi bir takım. En iyi halimize ihtiyacımız olacak.';

  @override
  String get pressReplyTeamFirst1 => 'Mesele tüm takım, tek bir oyuncu değil.';

  @override
  String get pressReplyTeamFirst2 => 'Bunu kimse tek başına kazanamaz.';

  @override
  String pressOnRecordTarget(String aim) {
    return 'Kayıtlara geçti: $aim.';
  }

  @override
  String get pressOnRecordPlayDown => 'Kayıtlara geçti: söz yok.';

  @override
  String get pressThrowbackTargetKeptWarm =>
      'Kampanyadan önce bir hedef koydunuz ve tutturdunuz. Şimdiye dek en gurur duyduğunuz an bu mu?';

  @override
  String get pressThrowbackTargetKeptNeutral =>
      'Ne başaracağınızı söylediniz ve başardınız. Hiç şüphe oldu mu?';

  @override
  String get pressThrowbackTargetKeptHostile =>
      'Koyduğunuz hedefi tutturdunuz. Şans mı, yoksa gerçekten plan bu muydu?';

  @override
  String get pressThrowbackTargetBrokenWarm =>
      'Bir hedef koydunuz ve altında kaldınız. Neyin yanlış gitti?';

  @override
  String get pressThrowbackTargetBrokenNeutral =>
      'Bu takımın verdiğinden fazlasını vaat ettiniz. Bunu söylediğinize pişman mısınız?';

  @override
  String get pressThrowbackTargetBrokenHostile =>
      'Kampanyadan önce büyük konuştunuz ve altında kaldınız. Şimdi size neden inanalım?';

  @override
  String hubEventPressPreviewSub(String competition) {
    return 'Basın $competition için hedeflerini duymak istiyor';
  }

  @override
  String deptLevelCost(int level, String amount) {
    return 'Seviye $level · $amount';
  }

  @override
  String get formOnFire => 'Ateş gibi';

  @override
  String get formGood => 'Formda';

  @override
  String get formSteady => 'İstikrarlı';

  @override
  String get formPoor => 'Formsuz';

  @override
  String get formCold => 'Buz gibi';

  @override
  String get playerFormTitle => 'FORM VE KONDİSYON';

  @override
  String playerFormAverage(String rating) {
    return 'Son maçlarında ortalama $rating';
  }

  @override
  String get playerFormNoGames =>
      'Değerlendirmek için yeterli yakın tarihli maç yok';

  @override
  String playerFormNextMatch(String delta) {
    return 'Bir sonraki maçta gücüne etkisi: $delta';
  }

  @override
  String get playerFormNoEffect => 'Bir sonraki maçta gücü değişmiyor';

  @override
  String get sideGroupHome => 'Ana Sayfa';

  @override
  String get sideGroupTeam => 'Takım';

  @override
  String get sideGroupCompetitions => 'Turnuvalar';

  @override
  String get sideGroupFederation => 'Federasyon';

  @override
  String get sideGroupHistory => 'Geçmiş';

  @override
  String get sideInbox => 'Gelen kutusu';

  @override
  String get sideSquad => 'Kadro';

  @override
  String get sideTactics => 'Taktik';

  @override
  String get sideMainMenu => 'Ana menü';

  @override
  String get sideCallUps => 'Kadro daveti';

  @override
  String get sideTournaments => 'Turnuvalar';

  @override
  String get sideRanking => 'Sıralama';

  @override
  String get sideResults => 'Sonuçlar';

  @override
  String get sideFinances => 'Finans';

  @override
  String get sideBoard => 'Yönetim';

  @override
  String get sideManager => 'TD ve ekip';

  @override
  String get sideRecords => 'Rekorlar';

  @override
  String get sideLegends => 'Efsaneler';

  @override
  String get sideHeadToHead => 'Karşılıklı geçmiş';

  @override
  String get sideAchievements => 'Başarımlar';

  @override
  String get sideCareer => 'Kariyer';

  @override
  String get topBarNext => 'Sıradaki';

  @override
  String get topBarDrawPending => 'Kura bekleniyor';

  @override
  String get paneFullProfile => 'Tam profil';

  @override
  String get panePickPlayer => 'Kartını burada görmek için bir oyuncu seç';

  @override
  String get inboxPickMessage => 'Okumak için bir mesaj seç';

  @override
  String get inboxFilterAll => 'Tümü';

  @override
  String get panelViewAll => 'Tümünü gör';

  @override
  String get gridViewOverview => 'Genel bakış';

  @override
  String get gridColCondition => 'Kondisyon';

  @override
  String get gridColStatus => 'Durum';

  @override
  String get gridColRank => 'Sıra';

  @override
  String get gridColMove => 'Değişim';

  @override
  String get gridColNation => 'Ülke';

  @override
  String get gridColRegion => 'Bölge';

  @override
  String get gridColPoints => 'Puan';

  @override
  String get panePickNation => 'Rekorunu burada görmek için bir ülke seç';

  @override
  String get resultsCyclesTitle => 'Dönemler';

  @override
  String get tourDrawStart => 'Kurayı başlat';

  @override
  String get tourDrawViewGroups => 'Grupları gör';

  @override
  String get gridColCeiling => 'Tavan';

  @override
  String get gridColYearGain => 'Artış';

  @override
  String get gridColMarkedAt => 'İşaretlendiğinde';

  @override
  String get budgetSetupTitle => 'Bütçeni belirle';

  @override
  String get budgetEffectsTitle => 'Bu bütçe neler sağlar';

  @override
  String get naturalisationTitle => 'Vatandaşlığa geçirme';

  @override
  String get yTrending => 'Gündemde';

  @override
  String get yVoices => 'Sesler';

  @override
  String get yConversation => 'Konuşma';

  @override
  String get allTimeRecordsTitle => 'Tüm zamanların dünya rekorları';

  @override
  String get h2hMeetingsTitle => 'Tüm karşılaşmalar';

  @override
  String get h2hPickOpponent =>
      'Tüm karşılaşmaları burada görmek için bir rakip seç';

  @override
  String get savesTitle => 'Kayıtlar';

  @override
  String get gridColPlayer => 'Oyuncu';

  @override
  String get gridColPos => 'Mev';

  @override
  String get gridColActive => 'Aktif';

  @override
  String get gridColMotm => 'MA';

  @override
  String get gridColAvg => 'Ort';

  @override
  String get gridColOpponent => 'Rakip';

  @override
  String get gridColStarts => 'İlk 11';

  @override
  String get gridColTournaments => 'Turnuvalar';

  @override
  String get gridColDate => 'Tarih';

  @override
  String get gridColLastPlayed => 'Son oynanan';

  @override
  String get gridColManager => 'Teknik direktör';

  @override
  String nationsShownCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ülke',
      one: '1 ülke',
    );
    return '$_temp0';
  }

  @override
  String get nationsSortedByRank => 'Dünya sıralamasına göre';

  @override
  String get nationsStrength => 'Güç';

  @override
  String nationsStrengthOf(int tier) {
    return '$tier / 5';
  }

  @override
  String get nationsSquadOverall => 'Kadro gücü';

  @override
  String get nationsOpeningBudget => 'Başlangıç bütçesi';

  @override
  String get nationsStarPlayer => 'Yıldız oyuncu';

  @override
  String nationsStarTile(String position, int rating) {
    return 'Yıldız $position $rating';
  }

  @override
  String nationsStarAge(int age) {
    return 'Yaş $age';
  }

  @override
  String get nationsBoardExpects => 'Yönetim beklentisi';

  @override
  String nationsManage(String nation) {
    return '$nation takımını yönet';
  }

  @override
  String get nationsManagerNext => 'Teknik direktörünü sonra seçeceksin';

  @override
  String get playerPageTitle => 'Oyuncu';

  @override
  String get nationPageTitle => 'Ülke';

  @override
  String get friendliesYourGames => 'Hazırlık maçların';

  @override
  String hubEventInjuryCover(String player) {
    return 'Sakat $player yerine yedek çağır';
  }

  @override
  String hubEventInjuryCoverSub(int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: '$matches maç yok',
      one: 'Bir sonraki maçta yok',
    );
    return '$_temp0. Birini çağır ya da onsuz devam et.';
  }

  @override
  String get injuryCoverTitle => 'YEDEK';

  @override
  String injuryCoverBanner(String player, String position) {
    return '$player ($position) sakat. Kadro dışından istediğin pozisyonda birini çağırabilir ya da oyuncuyu tutup devam edebilirsin.';
  }

  @override
  String injuryCoverConfirm(String player) {
    return '$player oyuncusunu çağır';
  }

  @override
  String injuryCoverKeep(String player) {
    return '$player oyuncusunu tut ve devam et';
  }

  @override
  String get injuryCoverPick => 'Bir yedek seç';

  @override
  String get injuryCoverNone => 'Kadro dışında katılabilecek formda kimse yok.';

  @override
  String get nationNowRanking => 'Dünya sıralaması';

  @override
  String get nationNowForm => 'Form';

  @override
  String get nationNowNoForm => 'Henüz maç oynanmadı';

  @override
  String get nationNowNext => 'Sıradaki maç';

  @override
  String get nationNowNoNext => 'Planlanmış maç yok';

  @override
  String get nationNowSquad => 'Kadro';

  @override
  String get nationNowAgainstYou => 'Sana karşı';

  @override
  String nationNowRecord(int w, int d, int l) {
    return '${w}G ${d}B ${l}M';
  }

  @override
  String get nationNowLastMeeting => 'Son karşılaşma';

  @override
  String nationNowOverall(int value) {
    return 'Genel $value';
  }

  @override
  String get hubUpcoming => 'YAKLAŞAN MAÇLAR';

  @override
  String get hubFullSchedule => 'Tüm program';

  @override
  String get scheduleTitle => 'Program';

  @override
  String get scheduleToday => 'Bugün';

  @override
  String get scheduleKnockoutPending => 'Eleme turları, geçersen';

  @override
  String get scheduleNextRoundPending => 'Sonraki tur';

  @override
  String scheduleFromDate(String date) {
    return '$date tarihinden itibaren';
  }

  @override
  String get scheduleHomeShort => 'E';

  @override
  String get scheduleAwayShort => 'D';

  @override
  String get tacticsNoPresetsInMatch =>
      'Henüz kayıtlı taktik yok. Maçtan önce Taktik ekranından bir tane kaydet.';

  @override
  String get homeCampaigns => 'Kampanyalar';

  @override
  String get homeContinueCampaign => 'KAMPANYAYA DEVAM ET';

  @override
  String homeCampaignCycle(String date, int cycle, int total) {
    return '$date · Döngü $cycle / $total';
  }

  @override
  String get campaignsTitle => 'Kampanyalar';

  @override
  String get campaignTransplantTitle => 'Nakil';

  @override
  String get campaignTransplantTwist =>
      'İtalya\'nın en iyi sekiz oyuncusu San Marino\'ya geçiyor';

  @override
  String get campaignTransplantGoal =>
      'Avrupa Şampiyonası\'na katılma hakkı kazan';

  @override
  String get campaignGrudgeTitle => 'Kin';

  @override
  String get campaignGrudgeTwist => 'Gürcistan ve Arnavutluk aynı gruba düştü';

  @override
  String get campaignGrudgeGoal => 'Elemelerde Arnavutluk\'un önünde bitir';

  @override
  String get campaignTransplantIntro =>
      'San Marino\'nun hiç adı anılmaya değer bir eleme kampanyası olmadı. Sonra İtalya\'nın en iyi sekiz oyuncusu pasaportu alıp içeri giriyor. Bir meraklığı takıma dönüştürmek için tek bir dönemin var.';

  @override
  String get campaignGrudgeIntro =>
      'Gürcistan ve Arnavutluk aynı eleme grubuna düştü ve ikisi de yenilgiyi affetmez. Arnavutluk\'un önünde bitir, sonra bunu ne kadar taşıyabileceğini gör.';

  @override
  String get campaignStars1Transplant => 'Katılma hakkı kazan';

  @override
  String get campaignStars2Transplant => 'Eleme turlarına ulaş';

  @override
  String get campaignStars3Transplant => 'Avrupa Şampiyonası’nı kazan';

  @override
  String get campaignStars1Grudge => 'Arnavutluk\'un önünde';

  @override
  String get campaignStars2Grudge => 'Ve katılma hakkı kazan';

  @override
  String get campaignStars3Grudge => 'Ve onları iki kez yen';

  @override
  String get campaignFree => 'Ücretsiz';

  @override
  String get campaignStart => 'Başlat';

  @override
  String get campaignPartOfUnlimited => 'Unlimited içinde';

  @override
  String get campaignResume => 'Devam et';

  @override
  String get campaignAbandon => 'Bırak';

  @override
  String get campaignAbandonConfirm =>
      'Bu denemeyi bırakmak istiyor musun? İlerleme kaybolur; damgan kalır.';

  @override
  String get campaignMoveToSaves => 'Kayıtlara taşı';

  @override
  String get campaignCannotContinue =>
      'Bu kampanyanın dünyası, kariyer olarak sürdürülemeyecek kadar gerçeğinden uzak.';

  @override
  String get campaignMoveSlotsFull =>
      'Kayıt yuvaların dolu. Önce birini boşalt.';

  @override
  String get campaignStampConquered => 'Fethedildi';

  @override
  String get campaignStampFailed => 'Başarısız';

  @override
  String get campaignDifficultyHard => 'Zor';

  @override
  String get campaignDifficultyMedium => 'Orta';

  @override
  String get campaignGoalLabel => 'Hedef';

  @override
  String get campaignStarsLabel => 'Yıldızlar';

  @override
  String get campaignRunInProgress =>
      'Bu kampanyanın zaten devam eden bir denemesi var.';

  @override
  String get campaignVerdictWon => 'Fethedildi';

  @override
  String get campaignVerdictLost => 'Bu sefer olmadı';

  @override
  String get campaignVerdictContinue => 'Devam';

  @override
  String campaignProgressQualifying(String position) {
    return 'Eleme: $position';
  }

  @override
  String campaignProgressRival(String rival, String position) {
    return '$rival: $position';
  }

  @override
  String campaignProgressFinals(String stage) {
    return 'Final turnuvası: $stage';
  }

  @override
  String get campaignRunInNumbers => 'Deneme rakamlarla';

  @override
  String campaignRunMeetings(int won, int played) {
    return 'Kazanılan karşılaşma: $played içinden $won';
  }

  @override
  String campaignPlace(String which, int n) {
    String _temp0 = intl.Intl.selectLogic(
      which,
      {
        'first': '1.',
        'second': '2.',
        'third': '3.',
        'other': '$n.',
      },
    );
    return '$_temp0';
  }

  @override
  String get campaignGuineasTitle => 'En İyi Gine';

  @override
  String get campaignGuineasTwist =>
      'Afrika\'nın en küçük Ginesi Ekvator Ginesi, iki dönem boyunca';

  @override
  String get campaignGuineasGoal => 'Gine ve Gine-Bissau\'yu yen';

  @override
  String get campaignGuineasIntro =>
      'Afrika\'da üç ülke Gine adını taşıyor ve Ekvator Ginesi aralarında en küçüğü. Gine ve Gine-Bissau\'yu en az birer kez yenmek için iki dönemin var; sonra Afrika Şampiyonası\'nda ne kadar ileri gidebileceğini gör. Dördüncü Gine olan Papua Yeni Gine ile bir hazırlık maçı şimdiden ayarlandı.';

  @override
  String get campaignStars1Guineas => 'Gine ve Gine-Bissau\'yu yen';

  @override
  String get campaignStars2Guineas =>
      'Ve bir Afrika Şampiyonası\'na katılma hakkı kazan';

  @override
  String get campaignStars3Guineas =>
      'Ve bir Afrika Şampiyonası\'nda çeyrek finale çık';

  @override
  String get campaignYoungFinnsTitle => 'Genç Finler';

  @override
  String get campaignYoungFinnsTwist =>
      'Finlandiya\'nın gençlerden oluşan altın kuşağı, üç dönem boyunca';

  @override
  String get campaignYoungFinnsGoal =>
      'Bir Dünya Şampiyonası\'na katılma hakkı kazan';

  @override
  String get campaignYoungFinnsIntro =>
      'Finlandiya\'nın deneyimli oyuncuları kenara çekildi ve yerlerini altın bir kuşak aldı: kadroya çağırabileceğin her oyuncu 18 yaşında ya da daha genç. Bugün henüz ham olsalar da tıpkı Norveç\'in genç kuşağı gibi dünyanın en iyi takımlarından biri olacak yeteneğe sahipler. Onları bir Dünya Şampiyonası\'na taşımak, ardından Avrupa Şampiyonası\'nı ve Dünya Şampiyonası\'nı kazanmak için üç dönemin var.';

  @override
  String get campaignStars1YoungFinns =>
      'Bir Dünya Şampiyonası\'na katılma hakkı kazan';

  @override
  String get campaignStars2YoungFinns => 'Avrupa Şampiyonası\'nı kazan';

  @override
  String get campaignStars3YoungFinns => 'Dünya Şampiyonası\'nı kazan';

  @override
  String get campaignGreenlandTitle => 'Bir Grönland Yüzyılı';

  @override
  String get campaignGreenlandTwist =>
      'Grönland yüz yıl boyunca Avrupa\'da San Marino\'nun yerini alıyor';

  @override
  String get campaignGreenlandGoal =>
      'Bir Avrupa Şampiyonası\'na katılma hakkı kazan';

  @override
  String get campaignGreenlandIntro =>
      'Grönland hiç resmi bir milli maç oynamadı. Bu dünyada Avrupa\'da San Marino\'nun yerini aldı ve dünya sıralamasının en dibinden başlıyor: amatör oyuncular, suni çim sahalar ve karların arasına sıkışmış bir sezon. Bir Avrupa Şampiyonası\'na, ardından bir Dünya Şampiyonası\'na ulaşmak ve hayal kurmaya cesaretin varsa bunlardan birini kazanmak için yüz yılın, yani yirmi beş dönemin var.';

  @override
  String get campaignStars1Greenland =>
      'Bir Avrupa Şampiyonası\'na katılma hakkı kazan';

  @override
  String get campaignStars2Greenland =>
      'Bir Dünya Şampiyonası\'na katılma hakkı kazan';

  @override
  String get campaignStars3Greenland =>
      'Avrupa Şampiyonası\'nı ya da Dünya Şampiyonası\'nı kazan';

  @override
  String get campaignPro => 'Pro';

  @override
  String campaignProgressCup(String cup, String year, String status) {
    return '$cup $year: $status';
  }

  @override
  String get campaignCupNotQualified => 'Katılamadı';

  @override
  String get campaignCupOpen => 'Henüz belli değil';

  @override
  String newsYouthTitle1(String name, String level) {
    return '$name, $level takımında parlıyor';
  }

  @override
  String newsYouthTitle2(String name, String level) {
    return 'Altyapı raporu: $name göz dolduruyor';
  }

  @override
  String newsYouthTitle3(String name, String level) {
    return '$level takımının yıldızı: $name';
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
      other: '$count kez',
      one: 'bir kez',
    );
    return '$name, son milli arada $opponent karşısında $level takımı için $_temp0 fileleri havalandırdı.';
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
      one: 'bir gol',
    );
    return '$level takımı bu arada $opponent karşısına çıktı ve $name $_temp0 attı.';
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
      other: '$count golle',
      one: 'bir golle',
    );
    return '$level takımı $opponent ile karşılaştı ve $name sahadan $_temp0 ayrıldı.';
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
      one: 'bir gol',
    );
    return '$name, $opponent karşısında $level takımı için $_temp0 hazırladı ve oyunu baştan sona yönetti.';
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
      other: '$count asist',
      one: 'bir asist',
    );
    return '$level takımı bu arada $opponent ile oynadı ve ipleri $name elinde tuttu: $_temp0 ve teknik ekibin hâlâ konuştuğu bir performans.';
  }

  @override
  String newsYouthCleanSheet1(String name, String level, String opponent) {
    return '$level takımı $opponent karşısında gol yemezken $name harikaydı.';
  }

  @override
  String newsYouthCleanSheet2(String name, String level, String opponent) {
    return '$level takımı $opponent karşısında kalesini gole kapattı ve bunun büyük payı $name oyuncusunun.';
  }

  @override
  String newsYouthDisplay1(
    String name,
    String level,
    String opponent,
    int mark,
  ) {
    return '$name, $opponent karşısında $level takımında etkiledi ve teknik ekip performansına ondan $mark verdi.';
  }

  @override
  String newsYouthDisplay2(
    String name,
    String level,
    String opponent,
    int mark,
  ) {
    return '$level takımı bu arada $opponent ile oynadı ve antrenörler tek bir ismi öne çıkardı, $name: ondan $mark, takımın en yüksek notu.';
  }

  @override
  String get newsYouthDevReady1 =>
      'Bu formuyla A milli takım için düşünülecek kadar iyi durumda.';

  @override
  String get newsYouthDevReady2 =>
      'Teknik ekip onun şimdiden A takım futboluna hazır olduğuna inanıyor. Karar senin.';

  @override
  String get newsYouthDevClose1 =>
      'İyi gelişiyor ve A milli takıma girmeye çok yakın.';

  @override
  String get newsYouthDevClose2 =>
      'A milli takıma fazla bir şey kalmadı, iyi bir sezon daha yetebilir.';

  @override
  String get newsYouthDevGrowing1 =>
      'Güzel gelişiyor, ancak A milli takım hâlâ bir iki adım uzakta.';

  @override
  String get newsYouthDevGrowing2 =>
      'A milli oyuncu olmadan önce yapılacak iş var ama her şey doğru yönü gösteriyor.';

  @override
  String get newsYouthDevRaw1 =>
      'Henüz ham ve A milli takımdan birkaç yıl uzakta, ama yetenek apaçık ortada.';

  @override
  String get newsYouthDevRaw2 =>
      'Daha çok erken ve altyapı hocaları manşet değil sabır istiyor.';

  @override
  String get newsYouthStrengthGkPhysical =>
      'Uzanışı ve ceza sahasındaki hâkimiyeti onu farklı kılıyor.';

  @override
  String get newsYouthStrengthGkTechnical =>
      'Top tutuşu ve oyun kurulumu, altyapının yıllardır gördüğü en iyisi.';

  @override
  String get newsYouthStrengthGkStamina =>
      'Konsantrasyonu hiç düşmüyor, doksanıncı dakikada da ilk dakikadaki kadar dikkatli.';

  @override
  String get newsYouthStrengthDefPhysical =>
      'Hızı ve hava hakimiyeti oyununun anahtarı.';

  @override
  String get newsYouthStrengthDefTechnical =>
      'Oyunu yaşının çok ötesinde okuyor ve topla sakin.';

  @override
  String get newsYouthStrengthDefStamina =>
      'Asla kopmuyor, son dakikada bile geriye depar atıyor.';

  @override
  String get newsYouthStrengthMidPhysical =>
      'Topu gerçek bir güçle kazanıyor ve hemen ileri taşıyor.';

  @override
  String get newsYouthStrengthMidTechnical =>
      'Oyun görüşü ve pas çeşitliliği oyununun anahtarı.';

  @override
  String get newsYouthStrengthMidStamina =>
      'Motoru inanılmaz: sahanın her karışını koşuyor.';

  @override
  String get newsYouthStrengthFwdPhysical =>
      'Arkaya koşulardaki hızı ve havadaki gücüyle her savunmanın başına dert.';

  @override
  String get newsYouthStrengthFwdTechnical =>
      'Bitiriciliği ve ceza sahası içindeki hareketliliği oyununun anahtarı.';

  @override
  String get newsYouthStrengthFwdStamina =>
      'Maç boyunca önde baskı yapıyor ve savunmacılara bir an bile rahat vermiyor.';

  @override
  String pressMomentBigWinWarm3(String opponent) {
    return 'Taraftarlar $opponent karşısındaki bu maçın şarkısını uzun süre söyleyecek. Son düdükte oyunculara ne dediniz?';
  }

  @override
  String pressMomentBigWinNeutral3(String opponent) {
    return '$opponent karşısında net bir mesajdı. Bunun ne kadarı antrenman sahasından geldi?';
  }

  @override
  String pressMomentBigWinHostile3(String opponent) {
    return '$opponent karşısındaki sonuç için tebrikler, ama böyle geceleri daha önce de gördük. Bu sefer farklı olan ne?';
  }

  @override
  String pressMomentBigLossWarm3(String opponent) {
    return 'Herkesin kötü bir gecesi olur ve $opponent karşısındaki de öyleydi. Bunu ne kadar çabuk geride bırakabilirsiniz?';
  }

  @override
  String pressMomentBigLossNeutral3(String opponent) {
    return '$opponent her bölgede daha iyiydi. Düzeltmeye nereden başlayacaksınız?';
  }

  @override
  String pressMomentBigLossHostile3(String opponent) {
    return 'Taraftarlar $opponent maçı bitmeden tribünleri terk ediyordu. Onları suçlayabilir misiniz?';
  }

  @override
  String pressMomentCrisisWarm3(String opponent) {
    return 'Zor bir dönem ve $opponent maçı işleri hiç kolaylaştırmadı. Sizi ayakta tutan ne?';
  }

  @override
  String pressMomentCrisisNeutral3(String opponent) {
    return 'Yine galibiyetsiz bir maç, bu kez $opponent karşısında. Yönetim harekete geçmeden bu daha ne kadar sürebilir?';
  }

  @override
  String pressMomentCrisisHostile3(String opponent) {
    return 'Şimdi de $opponent. Planınızda geriye bir şey kaldı mı, yoksa yerinizi başkasına bırakma zamanı mı?';
  }

  @override
  String get pressReplyCreditPlayers5 =>
      'Ne yazarsanız yazın, oyuncular hakkında yazın. Bunu hak ettiler.';

  @override
  String get pressReplyCreditPlayers6 =>
      'Birbiri için ateşe atlayacak bir grubum var. Bu az şey değil.';

  @override
  String get pressReplyTakeResponsibility5 =>
      'Kararları ben veriyorum, eleştiri de bana gelir. İşin doğası bu.';

  @override
  String get pressReplyTakeResponsibility6 =>
      'Önce teknik direktöre bakın. Bazı şeyleri yanlış yaptım ve düzelteceğim.';

  @override
  String get pressReplyDemandMore5 =>
      'Burada iyi yeterli değil. Bunu yüzlerine söyledim.';

  @override
  String get pressReplyDemandMore6 =>
      'O soyunma odasında kimsenin forması garanti değil. Artık bunu biliyorlar.';

  @override
  String get pressReplyDeflect5 =>
      'Soruyu üç farklı şekilde sorabilirsiniz. Cevap aynı olacak.';

  @override
  String get pressReplyDeflect6 =>
      'Düşüncelerimi oyunculara saklıyorum. Anlayışla karşılarsınız.';

  @override
  String yWinRoutine12(String opponent, String score) {
    return '$opponent karşısında $score. Sakin, kontrollü, olgun futbol. Böyle görmek güzel.';
  }

  @override
  String yWinRoutine13(String opponent, String score) {
    return '$opponent karşısında $score, hem de hiç terlemeden. Bu takım sıkıcı olmakta ustalaşıyor ve sıkıcılık kupa kazandırır.';
  }

  @override
  String yWinRoutine14(String opponent, String score) {
    return '$opponent $score. Üç puan, sıfır drama, işe dönüyoruz.';
  }

  @override
  String yWinRoutine15(String opponent, String score) {
    return '$opponent karşısında rutin bir $score. Kimse hatırlamayacak, hatırlaması da gerekmiyor.';
  }

  @override
  String yWinRoutine16(String opponent, String score) {
    return '$opponent karşısında $score ve yine de içim rahat değil.';
  }

  @override
  String yWinRoutine17(String opponent, String score) {
    return '$opponent karşısında $score. Gerçek bir rakibe karşı bu performansın cezası kesilir.';
  }

  @override
  String yWinTight12(String opponent, String score) {
    return '$opponent karşısında $score. Dişimizi sıktık, acı çektik, kazandık. Takım dediğin bu.';
  }

  @override
  String yWinTight13(String opponent, String score) {
    return '$opponent karşısında sadece sinirlerle gelen $score. Kaybetmeyi reddeden bir takımı her zaman alırım.';
  }

  @override
  String yWinTight14(String opponent, String score) {
    return '$opponent $score. Son saniyeye kadar gitti ama puanlar bizim.';
  }

  @override
  String yWinTight15(String opponent, String score) {
    return '$opponent karşısında kıl payı $score. Fark azdı, futbol bu.';
  }

  @override
  String yWinTight16(String opponent, String score) {
    return '$opponent karşısında $score. Şanslı bir sekme öbür tarafa gitse bambaşka bir şey konuşuyor olurduk.';
  }

  @override
  String yWinTight17(String opponent, String score) {
    return '$opponent karşısında zar zor tuttuk, $score. Kimse buna performans demesin.';
  }

  @override
  String yDrew12(String opponent, String score) {
    return '$opponent ile $score. Yenilgi değil ve bazı günler iş tam olarak bu.';
  }

  @override
  String yDrew13(String opponent, String score) {
    return '$opponent karşısında zor kazanılmış bir puan, $score. Mücadeleyi beğendim.';
  }

  @override
  String yDrew14(String opponent, String score) {
    return '$opponent $score. Eski spikerlerin dediği gibi, puanlar paylaşıldı.';
  }

  @override
  String yDrew15(String opponent, String score) {
    return '$opponent ile $score. İki taraf da fazlasını hak edecek kadar bir şey yapmadı.';
  }

  @override
  String yDrew16(String opponent, String score) {
    return '$opponent ile $score. Dönüş otobüsünde yenilgi gibi hissettiren cinsten bir beraberlik.';
  }

  @override
  String yDrew17(String opponent, String score) {
    return '$opponent ile $score berabere. Sürekli gelişimden bahsediyoruz ve sürekli bunu yapıyoruz.';
  }

  @override
  String yLost12(String opponent, String score) {
    return '$opponent karşısında $score. Acıtıyor ama bu takıma inanmak için yeterince şey gördüm.';
  }

  @override
  String yLost13(String opponent, String score) {
    return '$opponent karşısında $score yenildik ve iyiydiler. Kabul edip yola devam.';
  }

  @override
  String yLost14(String opponent, String score) {
    return '$opponent $score. Bir yenilgi, birkaç ders ve yakında bir sonraki maç.';
  }

  @override
  String yLost15(String opponent, String score) {
    return '$opponent karşısında $score kaybettik. Tartışacak pek bir şey yok.';
  }

  @override
  String yLost16(String opponent, String score) {
    return '$opponent karşısında $score. Geçen seferki hataların aynısı, aynı özgüvenle.';
  }

  @override
  String yLost17(String opponent, String score) {
    return '$opponent karşısında $score yenildik. Bunun hesabını kimse vermeyecekse ne yapıyoruz biz?';
  }

  @override
  String get yReactionShrug12 => 'Bana uyar. Her gece havai fişek gerekmez.';

  @override
  String get yReactionShrug13 => 'Puan puandır. Bu gece rahat uyurum.';

  @override
  String get yReactionShrug14 => 'İzledim. Not yok.';

  @override
  String get yReactionShrug15 =>
      'İdare eder ile idare eder arasında bir yerde.';

  @override
  String get yReactionShrug16 =>
      'Bunun için yayına para verdim. Bir daha asla (geri geleceğim).';

  @override
  String get yReactionShrug17 => 'Doksan dakikalık futbol kılıklı bir hiçlik.';

  @override
  String get yReactionRelief12 =>
      'Yeniden nefes alıyorum. Dayandıkları için gurur duyuyorum.';

  @override
  String get yReactionRelief13 =>
      'Takımı kuran galibiyetler bunlar. Çirkin olan güzeldir.';

  @override
  String get yReactionRelief14 => 'Tırnaklarım bitti ama puanlar duruyor.';

  @override
  String get yReactionRelief15 =>
      'Bir bitiş düdüğü hiç bu kadar güzel gelmemişti.';

  @override
  String get yReactionRelief16 =>
      'Kazandığımıza sevindim, nasıl kazandığımıza endişelendim.';

  @override
  String get yReactionRelief17 =>
      'Hep paçayı kurtarıyoruz. Bir gün kurtaramayacağız.';

  @override
  String get yReactionFury12 =>
      'Bu takımı seviyorum, tam da bu yüzden acıtıyor.';

  @override
  String get yReactionFury13 =>
      'Kötü gece. Gelecek maçta bize bir borçları var ve bunu biliyorlar.';

  @override
  String get yReactionFury14 =>
      'Yetmişinci dakikada kapattım. Altmışta kapatmalıydım.';

  @override
  String get yReactionFury15 => 'Mücadele yok, fikir yok, bahane yok.';

  @override
  String get yReactionFury16 =>
      'Her seferinde aynı sorunlar ve kimse hiçbir şeyi düzeltmiyor.';

  @override
  String get yReactionFury17 =>
      'Federasyonda biri bunu tekrar izleyip bize açıklamalı.';

  @override
  String get backupShareHint =>
      'Tüm kayıtlardan tek bir yedek dosyası oluşturur. Saklamak için Google Drive, iCloud Drive ya da Dosyalar\'ı seç.';

  @override
  String backupLastAt(String date) {
    return 'Son yedek: $date';
  }

  @override
  String get backupNever => 'Henüz yedek yok';

  @override
  String get backupRemindersTitle => 'Yedek hatırlatmaları';

  @override
  String get backupRemindersBlurb =>
      'Son yedeğin eskimeye başladığında gelen kutuna bir not düşer.';

  @override
  String get backupAutoICloudTitle => 'Otomatik iCloud yedeği';

  @override
  String get backupAutoDriveTitle => 'Otomatik Google Drive yedeği';

  @override
  String get backupAutoBlurb =>
      'Maçlardan sonra, döngü sonunda ve uygulamadan çıktığında yedekler. Son ikisini saklar.';

  @override
  String get backupStatusUploading => 'Yedekleniyor.';

  @override
  String get backupStatusUploaded => 'Yedeklendi.';

  @override
  String get backupStatusICloudSignedOut =>
      'iCloud kapalı. Ayarlar uygulamasında iCloud\'a giriş yap ve iCloud Drive\'ı aç.';

  @override
  String get backupStatusDriveSignedOut =>
      'Giriş yapılmadı. Google ile giriş yapmak için düğmeyi aç.';

  @override
  String get backupStatusNotConfigured => 'Uygulamanın bu sürümünde henüz yok.';

  @override
  String get backupStatusUnavailable =>
      'Buluta şu an ulaşılamıyor. Daha sonra yeniden denenecek.';

  @override
  String get backupStatusFailed =>
      'Son otomatik yedek tamamlanamadı. Daha sonra yeniden denenecek.';

  @override
  String backupDriveSignedInAs(String email) {
    return '$email olarak giriş yapıldı';
  }

  @override
  String get backupDriveSignOut => 'ÇIKIŞ YAP';

  @override
  String get backupDriveSignInFailed =>
      'Google ile giriş yapılamadı. Daha sonra yeniden dene.';

  @override
  String get backupRestoreICloud => 'ICLOUD\'DAN GERİ YÜKLE';

  @override
  String get backupRestoreDrive => 'GOOGLE DRIVE\'DAN GERİ YÜKLE';

  @override
  String get backupCrossPlatformHelp =>
      'iPhone ile Android arasında mı geçiyorsun? Bir telefonda dosyaya yedekle, diğerinde o dosyadan geri yükle.';

  @override
  String get backupCloudListBlurb =>
      'Bu hesaptaki cihazlarının yedekleri. Geri yüklemek için birine dokun.';

  @override
  String get backupCloudListEmpty =>
      'Henüz yedek bulunamadı. Yeni bir yedeğin başka bir cihaza ulaşması birkaç dakika sürebilir.';

  @override
  String get backupCloudListFailed =>
      'Yedekler okunamadı. Bağlantını kontrol edip yeniden dene.';

  @override
  String get backupCloudThisDevice => 'Bu cihaz';

  @override
  String backupCloudMore(int count) {
    return 'Diğer kayıtlar: $count';
  }

  @override
  String get backupCloudNewer =>
      'Uygulamanın daha yeni bir sürümüyle yapılmış. Önce güncelle.';

  @override
  String get backupCloudDownloading => 'Yedek indiriliyor.';

  @override
  String get backupRestoreSafetyNote =>
      'Önce bu telefondaki kayıtların bir kopyası bu telefonda saklanır.';

  @override
  String get backupRejectedSafety =>
      'Mevcut kayıtların kopyası saklanamadı, bu yüzden hiçbir şey değiştirilmedi.';

  @override
  String get newsBackupReminderTitle => 'Yedekleme zamanı';

  @override
  String get newsBackupReminderBody =>
      'Kayıtların yalnızca bu telefonda. Ayarlar\'ı açıp Buluta yedekle\'ye dokun ya da oradan otomatik yedeği aç. Bu hatırlatmalar da Ayarlar\'dan kapatılabilir.';

  @override
  String get backupSafetyTitle => 'Geri yüklemeden önceki kopyalar';

  @override
  String get backupSafetyBlurb =>
      'Bir geri yükleme yanlış çıkarsa diye bu telefonda saklanır. En yeni üçü tutulur.';

  @override
  String get backupSafetyRestore => 'GERİ YÜKLE';

  @override
  String get backupSafetyShare => 'PAYLAŞ';

  @override
  String get backupCloudNoDetails => 'Ayrıntılar hâlâ yolda.';

  @override
  String get tacticsLibraryTitle => 'TAKTİK KÜTÜPHANESİ';

  @override
  String get tacticsLibraryBlurb =>
      'Kütüphanendeki taktikleri yeni olanlar dahil her kayıtta yükleyebilirsin. Roller ve duran top kullanıcıları oyuncuya göre değil, mevkiye göre saklanır.';

  @override
  String get tacticsSaveToLibrary => 'Kütüphaneye kaydet';

  @override
  String get tacticsLoadFromLibrary => 'Kütüphaneden yükle';

  @override
  String get tacticsLibraryEmpty =>
      'Kütüphanen boş. Buraya bir taktik kaydedersen onu her kayıtta yükleyebilirsin.';

  @override
  String tacticsLibrarySaved(String name) {
    return '“$name” kütüphaneye kaydedildi';
  }

  @override
  String tacticsLibraryLoaded(String name) {
    return 'Yüklendi: “$name”';
  }

  @override
  String tacticsLibraryNotFitted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rol veya duran top kullanıcısı bu kadroya uymadı.',
      one: '1 rol veya duran top kullanıcısı bu kadroya uymadı.',
    );
    return '$_temp0';
  }

  @override
  String get tacticsLibraryRename => 'Yeniden adlandır';

  @override
  String get tacticsLibraryRenameTitle => 'Taktiği yeniden adlandır';

  @override
  String get tacticsLibraryDelete => 'Sil';

  @override
  String tacticsLibraryDeleteTitle(String name) {
    return '“$name” silinsin mi?';
  }

  @override
  String get tacticsLibraryDeleteBody =>
      'Tüm kayıtlarındaki kütüphaneden kaldırılacak.';

  @override
  String get tacticsLibraryNameTaken =>
      'Kütüphanende bu adda bir taktik zaten var.';

  @override
  String tacticsLibraryCouldNotLoad(String error) {
    return 'Kütüphane yüklenemedi.\n$error';
  }

  @override
  String hostBidHeading(String competition, int year) {
    return 'Ev sahipliği adaylığı: $competition $year';
  }

  @override
  String get hostBidScreenTitle => 'Adaylık';

  @override
  String get hostBidBlurb =>
      'Ev sahibi, adaylar arasından kurayla belirlenir. Adaylık, isminize daha fazla ağırlık kazandırır: stadyumlarınız size bir başlangıç şansı verir, para bu şansı artırır ama her ek milyon biraz daha az etki eder. Kazansanız da kazanmasanız da para harcanmış olur.';

  @override
  String hostBidPrize(String amount) {
    return 'Kazanırsanız ev sahibi olursunuz, doğrudan katılım hakkı kazanırsınız ve bir sonraki bütçe için $amount tutarında tek seferlik bir destek alırsınız.';
  }

  @override
  String get hostBidChance => 'Ev sahipliği şansı';

  @override
  String get hostBidBaseLabel => 'Stadyumlar ve konum';

  @override
  String get hostBidInvestLabel => 'Yatırım';

  @override
  String hostBidCeiling(String nation, String percent) {
    return '$nation için tavan: $percent';
  }

  @override
  String get hostBidInvestment => 'Yatırımınız';

  @override
  String hostBidFreeFunds(String amount) {
    return 'Serbest bütçe: $amount';
  }

  @override
  String get hostBidSubmit => 'Adaylığı sun';

  @override
  String get hostBidDecline => 'Bu sefer değil';

  @override
  String get hostBidUnavailable => 'Bu adaylık artık açık değil.';

  @override
  String hostBidWonTitle(String competition, int year) {
    return 'Adaylık kazanıldı: $competition $year';
  }

  @override
  String hostBidWonBody(String amount) {
    return 'Turnuvaya ev sahipliği yapacağız ve ev sahibi olarak doğrudan katılıyoruz. $amount tutarındaki tek seferlik destek federasyonun kasasında ve onu ana ekrandan doğrudan bu döngünün birimlerine dağıtabilirsiniz.';
  }

  @override
  String hostBidLostTitle(String competition, int year) {
    return 'Adaylık kaybedildi: $competition $year';
  }

  @override
  String hostBidLostBody(String hosts) {
    return 'Ev sahipliğini kazanan: $hosts. Adaylığımız bu sefer yetmedi ve harcanan para geri gelmeyecek, ama federasyon kendini iyi anlattı.';
  }

  @override
  String get hostBidGrantEvent => 'Ev sahipliği desteğini dağıt';

  @override
  String hostBidGrantBanner(String amount) {
    return 'Ev sahipliği desteği: $amount tutarını bu döngünün birimlerine hemen ekleyebilirsiniz. Daha önce dağıtılan yerinde kalır, artan kasada kalır.';
  }

  @override
  String get stadiumsTitle => 'Ulusal stadyumlar';

  @override
  String get stadiumsEntrySub => 'Bir stadyumu geliştir ya da yenisini yap';

  @override
  String get stadiumsBlurb =>
      'Bir stadyumun seviyesi büyüklüğüdür: seviye 1 15.000 kişinin altı, seviye 2 15.000\'den, seviye 3 25.000\'den, seviye 4 40.000\'den, seviye 5 60.000\'den itibaren. Her stadyum her dönemin başında küçük bir gelir getirir; taraftarlarınız doldurabildiği sürece koltuk arttıkça gelir de artar. Geliştirme koltukları hemen ekler, bir sonraki dönemden itibaren biraz itibar da kazandırır; küçültme bakım giderini azaltır ama para iade edilmez. Hangi turnuvalara aday olabileceğinizi stadyumlarınız belirler.';

  @override
  String stadiumsIncome(String amount) {
    return 'Stadyum geliri: dönem başına $amount';
  }

  @override
  String stadiumsReputation(int points) {
    return 'Stadyumlardan itibar: +$points';
  }

  @override
  String get stadiumsClosed =>
      'İnşaat işleri dönemin başında, bütçe belirlenmeden önce verilir.';

  @override
  String stadiumsCapacity(String seats) {
    return 'Kapasite: $seats';
  }

  @override
  String stadiumsLevel(int level, int max) {
    return 'Seviye $level/$max';
  }

  @override
  String stadiumsUpgrade(String cost) {
    return 'Geliştir: $cost';
  }

  @override
  String get stadiumsTopLevel => 'En üst seviye';

  @override
  String stadiumsOpens(int year) {
    return 'İnşaat hâlinde, $year yılında açılacak';
  }

  @override
  String get stadiumsBuildTitle => 'Yeni stadyum yap';

  @override
  String get stadiumsBuildBody =>
      'Oldukça pahalı: seçtiğin şehirde yeni bir stadyum, bir sonraki dönemin başından itibaren açık.';

  @override
  String get stadiumsBuildCity => 'Şehir';

  @override
  String stadiumsBuildButton(String cost) {
    return 'Yap: $cost';
  }

  @override
  String get stadiumsBuilding => 'Zaten bir stadyum yapılıyor.';

  @override
  String get stadiumsNoCity => 'Her şehrin zaten yeni bir stadyumu var.';

  @override
  String stadiumsConfirmUpgrade(String stadium, int level, String cost) {
    return '$stadium, $cost karşılığında $level. seviyeye geliştirilsin mi?';
  }

  @override
  String stadiumsConfirmBuild(String city, String cost) {
    return 'Yeni stadyum $cost karşılığında yapılsın mı? Şehir: $city';
  }

  @override
  String get stadiumsConfirm => 'Onayla';

  @override
  String get stadiumsCancel => 'Vazgeç';

  @override
  String get stadiumsRefused => 'Sipariş gerçekleşmedi. Hiçbir ücret alınmadı.';

  @override
  String get stadiumsNameLabel => 'Stadyum adı';

  @override
  String get stadiumsNameHint => 'Önerilen adı korumak için boş bırakın.';

  @override
  String get stadiumsRename => 'Stadyumu yeniden adlandır';

  @override
  String get hostBidSectionTitle => 'Ev sahipliği adaylıkları';

  @override
  String get hostBidOpenSub =>
      'İsteğe bağlı. Yeni dönem başlamadan karar verin.';

  @override
  String get hostBidDecidedAtRollover =>
      'Ev sahibi yeni dönem başlarken açıklanır.';

  @override
  String get hostBidLodged =>
      'Adaylık sunuldu. Ev sahibi yeni dönem başlarken açıklanır.';

  @override
  String get hostBidDeclinedNote => 'Bu kez aday olmamayı seçtiniz.';

  @override
  String get hostBidOpensLater =>
      'Şartları karşılıyorsunuz. Bu dönemin sonunda aday olabilirsiniz.';

  @override
  String get hostBidNoFunds => 'Adaylık için yeterli serbest bütçe yok.';

  @override
  String hostBidNeedStadiums(int count, String seats) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$seats+ kapasiteli $count stadyum daha gerekiyor.',
      one: '$seats+ kapasiteli 1 stadyum daha gerekiyor.',
    );
    return '$_temp0';
  }

  @override
  String hostBidBarredConf(String confederation) {
    return 'Son Dünya Şampiyonası\'na $confederation ev sahipliği yaptı.';
  }

  @override
  String get hostBidRecentHost =>
      'Son üç turnuvadan birine ev sahipliği yaptınız.';

  @override
  String hostBidRequirement(
    int grounds,
    String minSeats,
    int bigGrounds,
    String bigSeats,
  ) {
    return 'Şart: $minSeats+ kapasiteli $grounds stadyum, bunların $bigGrounds tanesi $bigSeats+.';
  }

  @override
  String hostBidWonBodyBudget(String amount) {
    return 'Turnuvaya ev sahipliği yapacağız ve ev sahibi olarak otomatik katılıyoruz. $amount tutarındaki tek seferlik destek federasyonun bütçesinde, bu dönemin dağıtımına hazır.';
  }

  @override
  String get hubStadiumIncome => 'Stadyum geliri';

  @override
  String get stadiumsDownsize => 'Küçült';

  @override
  String stadiumsConfirmDownsize(String stadium, String seats, int level) {
    return '$stadium $seats kişiye küçültülsün mü (seviye $level)? Para iadesi yok ama bakım gideri düşer.';
  }

  @override
  String get stadiumsResizedThisCycle => 'Bu dönem yeniden düzenlendi';

  @override
  String stadiumsGroundIncome(String amount) {
    return 'Dönem başına $amount kazandırır';
  }

  @override
  String hostBidLapsedTitle(String competition, int year) {
    return 'Adaylık geri çekildi: $competition $year';
  }

  @override
  String hostBidLapsedBodyNation(String nation) {
    return 'Adaylık $nation için yapılmıştı, ancak yeni döneme başka bir yerde başlıyorsunuz. Geri çekildi, hiçbir ücret alınmadı.';
  }

  @override
  String get hostBidLapsedBodyFunds =>
      'Dönem kapanırken federasyonun bütçesi taahhüdü artık karşılamıyordu. Adaylık geri çekildi, hiçbir ücret alınmadı.';

  @override
  String get stadiumsViewMap => 'Harita';

  @override
  String get stadiumsViewList => 'Liste';

  @override
  String get stadiumsMapPickCity => 'Yeni stadyum yapmak için bir şehre dokun.';

  @override
  String get stadiumsMapFit => 'Tüm ülkeyi göster';

  @override
  String get campaignLegacyTitle => 'Mirası Tamamla';

  @override
  String get campaignLegacyTwist =>
      'Son Avrupa şampiyonu İspanya, bir dönem boyunca';

  @override
  String get campaignLegacyGoal => 'Avrupa şampiyonluğunu koru';

  @override
  String get campaignLegacyIntro =>
      'İspanya son Avrupa şampiyonu ve şüpheciler bu altın dönemin tesadüf olduğunu söylüyor. Aksini kanıtlamak için bir dönemin var: kıta tacını koru, ardından dünyaya uzan. Uluslar Kupası\'nı da ekle, miras tamamlansın.';

  @override
  String get campaignStars1Legacy => 'Avrupa Şampiyonası\'nı kazan';

  @override
  String get campaignStars2Legacy => 'Ve Dünya Şampiyonası\'nı';

  @override
  String get campaignStars3Legacy => 'Ve Uluslar Kupası\'nı';

  @override
  String get campaignSectionOneCycle => 'Tek dönem';

  @override
  String get campaignSectionShort => 'Birkaç dönem';

  @override
  String get campaignSectionLong => 'Uzun soluklu';

  @override
  String get campaignFilterAll => 'Tümü';

  @override
  String get campaignFilterNew => 'Oynanmadı';

  @override
  String get campaignFilterInProgress => 'Devam ediyor';

  @override
  String get campaignFilterDone => 'Tamamlandı';

  @override
  String get campaignFilterEmpty => 'Burada henüz kampanya yok.';

  @override
  String campaignStarsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count yıldız',
      one: '1 yıldız',
      zero: 'Yıldız yok',
    );
    return '$_temp0';
  }

  @override
  String campaignCycles(int cycles) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles dönem',
      one: '1 dönem',
    );
    return '$_temp0';
  }

  @override
  String get msgIntlRetireNoteHigh => ' Zirvede, şampiyon olarak bırakıyor.';

  @override
  String get msgIntlRetireNoteMissed =>
      ' Finallere gidememek bardağı taşıran son damla oldu.';

  @override
  String get msgIntlRetireNoteSurprise => ' Kimse bunu beklemiyordu.';

  @override
  String get msgIntlRetireNoteRecord =>
      ' Milli takımın rekortmeni olarak veda ediyor.';

  @override
  String msgIntlRetireNewsTitle(String nation, String name) {
    return '$nation: $name milli takımı bıraktı';
  }

  @override
  String msgIntlRetireNewsBody(String name, String nation, int age) {
    return '$name ($nation) $age yaşında milli takımı bıraktığını açıkladı.';
  }

  @override
  String msgIntlComebackTitle(String name) {
    return '$name milli takıma geri dönüyor';
  }

  @override
  String msgIntlComebackBody(String name, int age) {
    return '$name $age yaşında yeniden milli takıma çağrılabilir durumda.';
  }

  @override
  String get msgIntlComebackNoteCrisis =>
      ' Kadro sakatlıklarla boğuşurken çağrıya kulak verdi.';

  @override
  String get msgIntlComebackNoteManager =>
      ' Yeni teknik direktör onu ikna etti.';

  @override
  String msgIntlComebackNewsTitle(String nation, String name) {
    return '$nation: $name milli takıma geri dönüyor';
  }

  @override
  String msgIntlComebackNewsBody(String name, String nation, int age) {
    return '$name ($nation) $age yaşında yeniden milli takıma çağrılabilir durumda.';
  }

  @override
  String playerIntlRetired(int year) {
    return 'Milli takımı bıraktı, $year';
  }

  @override
  String playerIntlComeback(int year) {
    return 'Milli takıma döndü, $year';
  }

  @override
  String yLegendRetires0(String name) {
    return 'Teşekkürler $name. Kimi formayı giyer, o formayı taşıdı.';
  }

  @override
  String yLegendRetires1(String name) {
    return '$name milli kariyerini noktaladı. Bir devir kapandı.';
  }

  @override
  String yLegendRetires2(String name) {
    return '$name bırakıyor. Dürüst olalım, bir turnuva geç kaldı.';
  }

  @override
  String yLegendRetires3(String name) {
    return 'Demek $name bitti. Artık gençlere şans verelim.';
  }

  @override
  String matchAltitudeOpponentsTire(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'Rakım $altitudeString m: rakip daha çabuk yorulacak';
  }

  @override
  String matchAltitudeYouTire(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'Rakım $altitudeString m: oyuncuların daha çabuk yorulacak';
  }

  @override
  String matchAltitudeBothTire(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'Rakım $altitudeString m: iki takım da daha çabuk yorulacak';
  }

  @override
  String matchAltitudeUsedTo(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'Rakım $altitudeString m: iki takım da buna alışkın';
  }

  @override
  String matchHeatExpected(int temp) {
    final intl.NumberFormat tempNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String tempString = tempNumberFormat.format(temp);

    return 'Sıcak: $tempString°C bekleniyor, bacaklar daha erken gidecek';
  }

  @override
  String get matchConditionsAdvice =>
      'Değişiklikleri erken planla: burada taze bacaklar daha değerli';

  @override
  String get fanMoodFurious => 'öfkeli';

  @override
  String get fanMoodRestless => 'huzursuz';

  @override
  String get fanMoodCalm => 'sakin';

  @override
  String get fanMoodUpbeat => 'umutlu';

  @override
  String get fanMoodEuphoric => 'coşkulu';

  @override
  String matchHomeFans(String mood) {
    return 'Ev sahibi taraftar: $mood';
  }

  @override
  String federationFans(String mood) {
    return 'Taraftar: $mood';
  }

  @override
  String federationFansIncome(String change) {
    return 'Gelecek döngüde stadyum geliri: $change';
  }

  @override
  String yFansProtest0(String nation, String manager) {
    return 'Yirmi yıldır milli takımı içeride dışarıda takip ediyorum. Bir şey değişmeden kombinemi yenilemem.';
  }

  @override
  String yFansProtest1(String nation, String manager) {
    return 'Forma için şarkı söylemeye devam edeceğiz. Ama kuzey tribünündeki pankart bu akşam hepimizin düşündüğünü söyledi.';
  }

  @override
  String yFansProtest2(String nation, String manager) {
    return 'Stadın yarısı boş, gelen yarısı da ikinci yarı boyunca #${manager}Out diye bağırdı.';
  }

  @override
  String yFansProtest3(String nation, String manager) {
    return 'Taraftar grupları bir sonraki iç saha maçını boykot etmeyi konuşuyor. Haksız da sayılmazlar.';
  }

  @override
  String yFansProtest4(String nation, String manager) {
    return '#${manager}Out. Artık kızgın bile değilim. Bitti.';
  }

  @override
  String yFansProtest5(String nation, String manager) {
    return 'Bu akşamdan bir fotoğraf: sıra sıra boş koltuklar ve üzerinde #${manager}Out yazan bir çarşaf. Maç raporu bu.';
  }

  @override
  String yFansSellOut0(String nation) {
    return 'Yine kapalı gişe. Yılların en iyi milli takımı ve bütün ülke bunu biliyor.';
  }

  @override
  String yFansSellOut1(String nation) {
    return 'Bir sonraki iç saha maçının biletleri on bir dakikada tükendi. Bu takım bize hafta sonlarımızı geri verdi.';
  }

  @override
  String yFansSellOut2(String nation) {
    return 'Bir sonraki iç saha maçı için tek boş koltuk yok. Federasyon hasılatı gülümseyerek sayacak.';
  }

  @override
  String yFansSellOut3(String nation) {
    return 'Bir kapalı gişe daha. Taktik hakkında ne derseniz deyin, insanlar o tribünde olmak istiyor.';
  }

  @override
  String yFansSellOut4(String nation) {
    return 'Kapalı gişe, peki. Aynı insanlar bir buçuk yıl önce bu takımı ıslıklıyordu.';
  }

  @override
  String yFansSellOut5(String nation) {
    return 'Birden kapalı gişe, birden herkes uzman. Kimseyi yenemezken neredeydiniz?';
  }

  @override
  String get campaignsIntro =>
      'Kampanyalar özel olarak hazırlanmış görevlerdir: belirli bir milli takım, kendine özgü bir sürprizi olan bir dünya ve belirli sayıda dönemde ulaşılması gereken bir hedef. Her deneme kariyer kayıtlarından ayrı tutulur; ne kadar ileri gidersen o kadar çok yıldız kazanırsın, en fazla üç.';

  @override
  String hubEventScandal(String player) {
    return 'Kampta skandal: $player';
  }

  @override
  String get hubEventScandalSub => 'Eve mi gönderilsin, kadroda mı kalsın?';

  @override
  String get scandalTitle => 'KAMP SKANDALI';

  @override
  String scandalStoryParty(String player) {
    return '$player sabaha kadar süren bir partideydi ve takımın toplandığı sabah fotoğraflar bütün gazetelerdeydi.';
  }

  @override
  String scandalStoryCurfew(String player) {
    return '$player sokağa çıkma saatini ihlal etti ve sabaha karşı otele dönerken yakalandı.';
  }

  @override
  String scandalStoryNightclub(String player) {
    return '$player kampın arifesinde bir gece kulübünde görüntülendi ve fotoğraflar her yerde.';
  }

  @override
  String scandalStoryCasino(String player) {
    return '$player kamptan önceki geceyi bir kumarhane masasında geçirdi ve bir magazin gazetesi fotoğrafları yayımladı.';
  }

  @override
  String get scandalSendHome => 'Eve gönder';

  @override
  String scandalSendHomeCover(String player) {
    return 'Eve gönder, kadroya çağır: $player';
  }

  @override
  String scandalKeep(String player) {
    return 'Kadroda tut: $player';
  }

  @override
  String get scandalKeepNote =>
      'Kadroda kalırsa: dönem sonuna kadar moral yaklaşık -4, yönetim yaklaşık -3.';

  @override
  String get scandalSendHomeNote =>
      'Eve gönderirsen: moral ve yönetim etkilenmez, yerine bir oyuncu çağırabilirsin.';

  @override
  String get scandalFinalsNote =>
      'Eve gönderirsen: moral ve yönetim etkilenmez, ama final turnuvasında yerine kimse çağrılamaz.';

  @override
  String get scandalPickCover => 'Yerine oyuncu çağır (isteğe bağlı)';

  @override
  String newsScandalTitle(String player) {
    return 'Kampta skandal: $player';
  }

  @override
  String yScandalParty0(String player, String tag) {
    return 'Gençlik işte. $player kamptan önceki gece partideymiş, ben yine de onu sahada görmek istiyorum. #$tag';
  }

  @override
  String yScandalParty1(String player, String tag) {
    return '$player, takım toplanmadan saatler önce sabaha kadar süren bir partide görüntülendi. Federasyon bilgilendirildi. #$tag';
  }

  @override
  String yScandalParty2(String player, String tag) {
    return 'Kamptan önce sabaha kadar parti. $player, ne düşünüyordun? İnanılmaz. #$tag';
  }

  @override
  String yScandalCurfew0(String player, String tag) {
    return 'Saatinden sonra dönmüş, olur böyle şeyler. $player sadece sahada telafi etsin. #$tag';
  }

  @override
  String yScandalCurfew1(String player, String tag) {
    return '$player, antrenmandan saatler önce takım oteline geç saatte dönerken yakalandı. #$tag';
  }

  @override
  String yScandalCurfew2(String player, String tag) {
    return 'Gece saati kuralı zor bir şey değil. $player bir gece bile dayanamadı. #$tag';
  }

  @override
  String yScandalNightclub0(String player, String tag) {
    return 'Eee, $player kulübe gitmiş. Futbolcuların da hayatı var. Bırakın oynasın. #$tag';
  }

  @override
  String yScandalNightclub1(String player, String tag) {
    return 'Fotoğraflar, milli takım kampının arifesinde $player isimli oyuncuyu bir gece kulübünde gösteriyor. #$tag';
  }

  @override
  String yScandalNightclub2(String player, String tag) {
    return 'Kamp arifesinde gece kulübü fotoğrafları. $player formayı utandırdı. #$tag';
  }

  @override
  String yScandalCasino0(String player, String tag) {
    return 'Kumarhanede bir gece suç değil. $player toparlar. #$tag';
  }

  @override
  String yScandalCasino1(String player, String tag) {
    return '$player, takım toplanmadan önceki gece bir kumarhane masasında görüldü. #$tag';
  }

  @override
  String yScandalCasino2(String player, String tag) {
    return 'Kamptan önce bütün gece kumarhanede. $player paradan fazlasını kumara bastı. #$tag';
  }

  @override
  String yScandalSentHome0(String player) {
    return 'Doğru karar. Kimse takımdan büyük değil, $player dahil.';
  }

  @override
  String yScandalSentHome1(String player) {
    return 'Tek cevap buydu: $player eve. Teknik direktöre saygı.';
  }

  @override
  String yScandalSentHome2(String player) {
    return 'Disiplin disiplindir. $player kuralları biliyordu.';
  }

  @override
  String yScandalSentHome3(String player) {
    return 'Kadroya net bir mesaj: $player eve dönüş uçağında.';
  }

  @override
  String yScandalSentHome4(String player) {
    return '$player için ağır bir karar. Bir gece dışarı çıktı diye kamp bitti mi?';
  }

  @override
  String yScandalSentHome5(String player) {
    return 'Eve gönderilen $player bizi zayıflatır. Bunun bedelini sahada ödeyeceğiz.';
  }

  @override
  String yScandalKept0(String player) {
    return 'Kadroda tutulan $player bir kumar. Sahada karşılığını versin.';
  }

  @override
  String yScandalKept1(String player) {
    return 'Peki, $player kalıyor. O zaman herkese iyi bir performans borçlu.';
  }

  @override
  String yScandalKept2(String player) {
    return 'Demek kurallar $player için geçerli değil. İyi bilmek lazım.';
  }

  @override
  String yScandalKept3(String player) {
    return 'Gece saati artık isteğe bağlıymış galiba. Sorun bakalım: $player.';
  }

  @override
  String yScandalKept4(String player) {
    return 'Bunca şeyden sonra $player kadroda mı? Bu takım tatil kampı olmuş.';
  }

  @override
  String yScandalKept5(String player) {
    return 'Bütün gece parti, sonra doğruca ilk 11\'e. Harika mesaj hocam. $player çok mutlu olmuştur.';
  }

  @override
  String get yStreamerBreaks0 =>
      'KARDEŞ YAKALANDI 😭😭 KAMPTAN ÖNCEKİ GECE Mİ?? AĞLIYORUM 💀💀💀';

  @override
  String get yStreamerBreaks1 =>
      'YOOOK CHAT ŞUNA BAKIN 🤯🤯 KARDEŞ GERÇEKTEN KAMPTAN ÖNCE BUNU YAPMIŞ 😭🔥';

  @override
  String get yStreamerBreaks2 =>
      'ONU KİM DIŞARI SALDI?? KİM SALDI 😭😭💀 BU RESMEN SİNEMA 🔥🔥';

  @override
  String get yStreamerSentHome0 =>
      'EVE Mİ?? EVEEE!!! 😭😭😭 HOCA HİÇ ŞAKA YAPMIYOR 💀🔥';

  @override
  String get yStreamerSentHome1 =>
      'KARDEŞ CANLI YAYINDA BAVULUNU TOPLUYOR 🤯🤯 GÜLE GÜLE KARDEŞ 😭👋';

  @override
  String get yStreamerSentHome2 =>
      'OLAMAZZZ ONU EVE GÖNDERMİŞLER 💀💀 CHAT TİTRİYORUM 🔥🔥🔥';

  @override
  String get yStreamerKept0 =>
      'KALIYOR MU??? KALIYOOOR 🤯🤯 KARDEŞE KİMSE DOKUNAMIYOR 😭🔥';

  @override
  String get yStreamerKept1 =>
      'BÜTÜN GECE PARTİ VE HÂLÂ KADRODA 💀💀 O SÖZLEŞMEDEN BEN DE İSTİYORUM 😭😭';

  @override
  String get yStreamerKept2 => 'HOCA SORUN YOK DEDİ 😭😭 KARDEŞ NE 🤯🤯🤯';

  @override
  String get yCameoUjfaloci => 'Hiçbir şey ödemedim, o tutar da tutmuyor zaten';

  @override
  String get yCameoHavir0 => 'Küçük balıklar yüzüp gitti.';

  @override
  String get yCameoHavir1 => 'Ağları attık, balıklar başka yerdeydi.';

  @override
  String get yCameoHavir2 => 'Ben bunu daha eylülde, gulaş yerken söylemiştim.';

  @override
  String get yCameoHavir3 => 'Zamanında balık tutmayan şimdi ağlamasın.';

  @override
  String get yCameoHavir4 => 'Karada kalmış yayın balığı gibi oynadık.';

  @override
  String get yCameoHavir5 => 'Rüzgâr eser, gölet donar. Hayat böyle.';

  @override
  String get yCameoHavir6 =>
      'Bazı günler oltaya sadece eski bir çizme takılır.';

  @override
  String get yCameoHavir7 =>
      'Bizim zamanımızda hiç değilse bir bira içmeye giderdik. Şimdi o bile yok.';

  @override
  String get yCameoLzimberskyHome0 =>
      'Bir gece yüzünden çocuğu eve göndermek mi? Asıl skandal bu, parti değil!';

  @override
  String get yCameoLzimberskyHome1 =>
      'Çocukların biraz eğlenmeye hakkı yok mu! İkiyüzlü medya yine kazandı.';

  @override
  String get yCameoLzimberskyHome2 =>
      'Bu bir cadı avı. Genç adam bir gece çıkıyor, siz onu asıyorsunuz.';

  @override
  String get yCameoLzimberskyHome3 =>
      'Hiç partiye gitmemiş gazeteci ilk taşı atsın. Ayıp!';

  @override
  String get yCameoLzimberskyHome4 =>
      'Teknik direktör magazin basınından korktu. Ben olsam çocuğu son nefesime kadar savunurdum!';

  @override
  String get yCameoLzimberskyKept0 =>
      'Sonunda omurgası olan bir teknik direktör! Çocuğu tuttu, medya ağlasın.';

  @override
  String get yCameoLzimberskyKept1 =>
      'Çocukların biraz eğlenmeye hakkı var, değil mi? Bravo hocam!';

  @override
  String get yCameoLzimberskyKept2 =>
      'İkiyüzlü medya bağırıyor, teknik direktör geri adım atmıyor. İşte böyle yapılır!';

  @override
  String get yCameoLzimberskyKept3 =>
      'Bir gece dışarı çıktı diye basın onu taşlamak istiyor. Teknik direktör tam bir adam!';

  @override
  String get yCameoLzimberskyKept4 =>
      'Diyorum ki: bırakın çocuklar yaşasın! Çok çalışan eğlenmeyi de hak eder. Başparmak yukarı.';

  @override
  String get yTraitStreamer =>
      'Her şeyi canlı yayınlar, sonuna kadar sesli, büyük harflerle.';

  @override
  String hubEventAwardsCeremony(int year) {
    return 'Yılın Oyuncusu $year';
  }

  @override
  String get hubEventAwardsCeremonySub => 'Oylar sayıldı';

  @override
  String get potyCeremonyWatch => 'Töreni izle';

  @override
  String get potyCeremonySkipToList => 'İlk beşe geç';

  @override
  String get potyCeremonySkip => 'Geç';

  @override
  String get potyCeremonyIntro =>
      'Oylar sayıldı. İşte bu yılın dünyadaki en iyi beş oyuncusu.';

  @override
  String potyCeremonyPlace(int place) {
    return '$place. sıra';
  }

  @override
  String get potyCeremonyWinnerIs => 'Ve Yılın Oyuncusu...';

  @override
  String get potyTop5Heading => 'Dünyanın ilk beşi';

  @override
  String get potyYoungTop3Heading => 'Yılın Genç Oyuncusu: ilk üç';

  @override
  String get potySeeTop5 => 'İlk beşi gör';

  @override
  String get potyYourPlayer => 'Senin oyuncun';

  @override
  String potyTallyCleanSheets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gol yemeden maç',
      one: '1 gol yemeden maç',
    );
    return '$_temp0';
  }

  @override
  String get campaignFullBrief => 'Tam brifing';

  @override
  String campaignStarsSoFar(int earned, int total) {
    return 'Şu ana kadar kazanılan yıldız: $earned/$total';
  }

  @override
  String get campaignStarEarned => 'Şu ana kadar kazanıldı';

  @override
  String get campaignStarNotYet => 'Henüz kazanılmadı';

  @override
  String get stadiumsEntrySubClosed =>
      'Stadyumlarına göz at. İnşaat işleri bir sonraki döngünün başında yeniden açılır.';

  @override
  String get boardObjectiveNoBrief => 'Hedef belirlenmedi';

  @override
  String get boardObjectiveNoBriefBody =>
      'Yönetim bu finallere çıkmanı beklemiyor. Bunun yerine seni sonuçlarına göre değerlendirecek.';

  @override
  String get boardObjectiveAwaitingDraw => 'Hedef kuradan sonra';

  @override
  String get boardObjectiveAwaitingDrawBody =>
      'Yönetim bu hedefi gruplar çekildikten sonra belirleyecek.';
}
