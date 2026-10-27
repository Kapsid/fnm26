// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Modern Greek (`el`).
class AppLocalizationsEl extends AppLocalizations {
  AppLocalizationsEl([String locale = 'el']) : super(locale);

  @override
  String get matchPreviewTitle => 'ΠΡΟΕΠΙΣΚΟΠΗΣΗ ΑΓΩΝΑ';

  @override
  String get matchKickOff => 'Σέντρα';

  @override
  String get matchTactics => 'Τακτική';

  @override
  String get matchYourXi => 'Η ΕΝΔΕΚΑΔΑ ΣΟΥ';

  @override
  String get matchHeadToHead => 'ΜΕΤΑΞΥ ΤΟΥΣ';

  @override
  String matchCouldNotLoad(String error) {
    return 'Δεν φορτώθηκε ο αγώνας.\n$error';
  }

  @override
  String get matchNoUpcoming => 'Δεν υπάρχει επόμενος αγώνας.';

  @override
  String get matchUnknownNation => 'Άγνωστη';

  @override
  String get matchH2hFirstMeeting => 'Πρώτη αναμέτρηση στην ιστορία';

  @override
  String get matchH2hYouLead => 'Προηγείσαι στο ιστορικό';

  @override
  String matchH2hOppEdge(String opponent) {
    return 'Προβάδισμα: $opponent';
  }

  @override
  String get matchH2hEven => 'Ισορροπία';

  @override
  String matchH2hMet(int count) {
    return '$count αναμετρήσεις';
  }

  @override
  String get matchH2hWon => 'Νίκες';

  @override
  String get matchH2hDrawn => 'Ισοπαλίες';

  @override
  String get matchH2hLost => 'Ήττες';

  @override
  String get matchDossierTitle => 'Φάκελος αντιπάλου';

  @override
  String get matchDossierForm => 'ΦΟΡΜΑ';

  @override
  String get matchDossierNoGames => 'Χωρίς πρόσφατους αγώνες';

  @override
  String get matchDossierKeyMen => 'ΚΛΕΙΔΙΑ';

  @override
  String get matchDossierHowTheyPlay => 'ΠΩΣ ΠΑΙΖΟΥΝ';

  @override
  String matchScoutFormation1(String formation) {
    return 'Συνήθως παρατάσσονται με $formation.';
  }

  @override
  String matchScoutFormation2(String formation) {
    return 'Το συνηθισμένο τους σύστημα είναι το $formation.';
  }

  @override
  String matchScoutFormation3(String formation) {
    return 'Τις περισσότερες φορές στήνονται με $formation.';
  }

  @override
  String get matchScoutStrengthPressing =>
      'Πιέζουν ψηλά και κυνηγούν την μπάλα.';

  @override
  String get matchScoutStrengthDirect =>
      'Παίζουν κάθετα και στέλνουν γρήγορα την μπάλα μπροστά.';

  @override
  String get matchScoutStrengthPossession =>
      'Κρατούν καλά την μπάλα και χτίζουν υπομονετικά.';

  @override
  String get matchScoutStrengthCounter =>
      'Περιμένουν πίσω και βγαίνουν γρήγορα στην αντεπίθεση.';

  @override
  String get matchScoutStrengthDeepDefence =>
      'Αμύνονται χαμηλά και δύσκολα σπάνε.';

  @override
  String get matchScoutStrengthWide =>
      'Ανοίγουν το γήπεδο και επιτίθενται από τα άκρα.';

  @override
  String get matchScoutStrengthAttacking =>
      'Τους αρέσει να παίρνουν την πρωτοβουλία και να πηγαίνουν πάνω στον αντίπαλο.';

  @override
  String get matchScoutStrengthQuickForwards =>
      'Οι επιθετικοί τους είναι γρήγοροι και λατρεύουν τις κινήσεις στην πλάτη της άμυνας.';

  @override
  String get matchScoutStrengthPassingMidfield =>
      'Η μεσαία τους γραμμή κυκλοφορεί καλά την μπάλα.';

  @override
  String get matchScoutStrengthHardRunning =>
      'Η μεσαία τους γραμμή έχει πόδια να τρέχει όλο το ματς.';

  @override
  String get matchScoutStrengthSetPieces =>
      'Είναι επικίνδυνοι στις στατικές φάσεις.';

  @override
  String get matchScoutStrengthQuickDefence =>
      'Η άμυνά τους είναι γρήγορη και δύσκολα βρίσκεις χώρο στην πλάτη της.';

  @override
  String get matchScoutStrengthNone =>
      'Τίποτα δεν ξεχωρίζει ιδιαίτερα στο παιχνίδι τους.';

  @override
  String get matchScoutWeakSpaceBehind =>
      'Η ψηλή τους γραμμή αφήνει χώρο στην πλάτη για μια μακριά μπαλιά.';

  @override
  String get matchScoutWeakPressedBuildUp =>
      'Ένα ψηλό πρέσινγκ μπορεί να διαταράξει την αργή τους ανάπτυξη.';

  @override
  String get matchScoutWeakDeepBlock =>
      'Υπομονή: ένα χαμηλό μπλοκ σαν το δικό τους μπορεί να ξεκλειδωθεί.';

  @override
  String get matchScoutWeakLongBall =>
      'Κατέβασε τη γραμμή σου και οι μακριές τους μπαλιές δεν θα έχουν πού να πάνε.';

  @override
  String get matchScoutWeakSlowDefence =>
      'Οι αμυντικοί τους δεν έχουν ταχύτητα, οπότε στείλε παίκτες στην πλάτη τους.';

  @override
  String get matchScoutWeakAerial =>
      'Δείχνουν ανασφαλείς όταν αμύνονται στις στατικές φάσεις.';

  @override
  String get matchScoutWeakPoorPassing =>
      'Η μεσαία τους γραμμή δυσκολεύεται να βγει από την πίεση με πάσες.';

  @override
  String get matchScoutWeakTiringMidfield =>
      'Η μεσαία τους γραμμή δεν έχει τα πόδια για να κρατήσει το πρέσινγκ.';

  @override
  String get matchScoutWeakBluntAttack =>
      'Οι επιθετικοί τους δεν έχουν ταχύτητα.';

  @override
  String get matchScoutApproachTakeTheGame =>
      'Απέναντί σου, περίμενε να πάρουν την πρωτοβουλία.';

  @override
  String get matchScoutApproachEven =>
      'Απέναντί σου, περίμενε ένα κλειστό και ισορροπημένο ματς.';

  @override
  String get matchScoutApproachSitDeep =>
      'Απέναντί σου, περίμενε να είναι προσεκτικοί και να ψάχνουν την αντεπίθεση.';

  @override
  String get matchScoutLeaningAttacking =>
      'Από μακριά μοιάζουν με επιθετική ομάδα.';

  @override
  String get matchScoutLeaningCautious =>
      'Από μακριά μοιάζουν με προσεκτική ομάδα.';

  @override
  String get matchScoutLeaningUnclear =>
      'Από μακριά είναι δύσκολο να πεις πώς τους αρέσει να παίζουν.';

  @override
  String get matchScoutHireHint =>
      'Πρόσλαβε έναν επικεφαλής σκάουτ για να μάθεις πώς παίζουν.';

  @override
  String matchCouldNotContinue(String error) {
    return 'Δεν ήταν δυνατή η συνέχεια: $error';
  }

  @override
  String get matchSkipToFullTime => 'Μετάβαση στο τέλος του αγώνα';

  @override
  String get matchStatShots => 'Σουτ';

  @override
  String get matchStatGoals => 'Γκολ';

  @override
  String get matchStatYellowCards => 'Κίτρινες';

  @override
  String get matchStatRedCards => 'Κόκκινες';

  @override
  String get matchMomentum => 'ΜΟΜΕΝΤΟΥΜ';

  @override
  String get matchSwingAtk => 'ΕΠΘ';

  @override
  String get matchSwingDef => 'ΑΜΥ';

  @override
  String ceremonyWorldCupYear(int year) {
    return 'ΠΑΓΚΟΣΜΙΟ ΠΡΩΤΑΘΛΗΜΑ $year';
  }

  @override
  String get ceremonyFinalsAreHere => 'Η ΤΕΛΙΚΗ ΦΑΣΗ ΞΕΚΙΝΑ';

  @override
  String ceremonyHostedBy(String hosts) {
    return 'ΔΙΟΡΓΑΝΩΣΗ  $hosts';
  }

  @override
  String get ceremonyHostTbc => 'ΟΙΚΟΔΕΣΠΟΤΗΣ ΠΡΟΣ ΚΑΘΟΡΙΣΜΟ';

  @override
  String get matchHalfTime => 'ΗΜΙΧΡΟΝΟ';

  @override
  String get matchContinue => 'Συνέχεια';

  @override
  String get matchContinuing => 'Συνέχεια…';

  @override
  String matchTacticsWithSubs(int used, int max) {
    return 'Τακτική · $used/$max αλλαγές';
  }

  @override
  String matchTiredCount(int count) {
    return 'ΚΟΥΡΑΣΜΕΝΟΙ ×$count';
  }

  @override
  String get matchTacticsLabel => 'ΤΑΚΤΙΚΗ';

  @override
  String get teamOverallOverTime => 'ΓΕΝΙΚΟ ΕΠΙΠΕΔΟ ΜΕ ΤΟ ΠΕΡΑΣΜΑ ΤΟΥ ΧΡΟΝΟΥ';

  @override
  String get teamOverall => 'Γενικό επίπεδο';

  @override
  String get teamTalkHeading => 'ΟΜΙΛΙΑ ΣΤΗΝ ΟΜΑΔΑ';

  @override
  String get teamTalkPrompt => 'Δώσε τον τόνο για το δεύτερο ημίχρονο.';

  @override
  String get teamTalkCalmLabel => 'Ψυχραιμία';

  @override
  String get teamTalkCalmBlurb =>
      'Σταθεροποίησε την ομάδα. Μικρή άνοδος παντού.';

  @override
  String get teamTalkEncourageLabel => 'Ενθάρρυνση';

  @override
  String get teamTalkEncourageBlurb =>
      'Πιέστε μπροστά και πάρτε το παιχνίδι πάνω σας.';

  @override
  String get teamTalkDemandMoreLabel => 'Ζήτα περισσότερα';

  @override
  String get teamTalkDemandMoreBlurb => 'Δώστε τα πάντα. Επίθεση με ένταση.';

  @override
  String get teamTalkPraiseLabel => 'Κράτα το σφιχτά';

  @override
  String get teamTalkPraiseBlurb =>
      'Μείνετε συμπαγείς και προστατέψτε ό,τι έχετε.';

  @override
  String get teamTalkBelieveLabel => 'Πίστη';

  @override
  String get teamTalkBelieveBlurb =>
      'Πιστέψτε στον εαυτό σας. Τόνωση σε όλο το γήπεδο.';

  @override
  String get teamTalkFocusLabel => 'Μείνε σε εγρήγορση';

  @override
  String get teamTalkFocusBlurb => 'Απόλυτη συγκέντρωση. Κλείστε το παιχνίδι.';

  @override
  String get teamTalkUrgencyLabel => 'Αίσθηση του επείγοντος';

  @override
  String get teamTalkUrgencyBlurb =>
      'Κυνηγήστε το τώρα με όλες σας τις δυνάμεις. Αφήνει όμως κενά.';

  @override
  String get teamTalkReassureLabel => 'Χωρίς πίεση';

  @override
  String get teamTalkReassureBlurb =>
      'Ηρεμήστε τα νεύρα και κρατήστε το σχήμα σας.';

  @override
  String get commonRetry => 'Δοκίμασε ξανά';

  @override
  String get commonSomethingWentWrong => 'Κάτι πήγε στραβά';

  @override
  String get commonCrashBox =>
      'Κάτι πήγε στραβά εδώ.\nΡυθμίσεις → Διαγνωστικά για λεπτομέρειες.';

  @override
  String hubCouldNotAdvance(String error) {
    return 'Δεν ήταν δυνατή η προώθηση του κόσμου: $error';
  }

  @override
  String get settingsDiagnosticsTitle => 'Διαγνωστικά';

  @override
  String get settingsDiagnosticsBlurb =>
      'Σφάλματα που καταγράφηκαν σε αυτή τη συσκευή. Τίποτα δεν στέλνεται πουθενά.';

  @override
  String get settingsContactTitle => 'Επικοινωνία';

  @override
  String get settingsContactCopied => 'Η διεύθυνση αντιγράφηκε.';

  @override
  String get settingsCommunityTitle => 'Κοινότητα';

  @override
  String get settingsDiscordSubtitle => 'Μπες στην κοινότητα';

  @override
  String get settingsLinkCopied => 'Ο σύνδεσμος αντιγράφηκε.';

  @override
  String get diagnosticsEmpty =>
      'Δεν υπάρχουν καταγεγραμμένα σφάλματα. Αυτή είναι η ιδέα.';

  @override
  String get diagnosticsCopy => 'Αντιγραφή';

  @override
  String get diagnosticsCopied =>
      'Το αρχείο καταγραφής αντιγράφηκε στο πρόχειρο.';

  @override
  String get diagnosticsClear => 'Εκκαθάριση';

  @override
  String get navHub => 'Κεντρική';

  @override
  String get navSquad => 'Αποστολή';

  @override
  String get navStandings => 'Βαθμολογίες';

  @override
  String get navCareers => 'Η καριέρα μου';

  @override
  String get settingsTitle => 'ΡΥΘΜΙΣΕΙΣ';

  @override
  String get settingsSoundHapticsTitle => 'Ήχος και δόνηση';

  @override
  String get settingsSoundHapticsBlurb =>
      'Δόνηση και σύντομος ήχος σε γκολ, σέντρα και τέλος αγώνα.';

  @override
  String get settingsLanguageTitle => 'Γλώσσα';

  @override
  String get settingsLanguageBlurb =>
      'Διάλεξε τη γλώσσα της εφαρμογής ή ακολούθησε τη συσκευή σου.';

  @override
  String get settingsLanguageSystem => 'Σύστημα';

  @override
  String get settingsTextSizeTitle => 'Μέγεθος κειμένου';

  @override
  String get settingsTextSizeBlurb =>
      'Μεγαλώστε το κείμενο αν διαβάζεται δύσκολα.';

  @override
  String get settingsTextSizeNormal => 'Κανονικό';

  @override
  String get settingsTextSizeLarge => 'Μεγάλο';

  @override
  String get settingsTextSizeLarger => 'Μεγαλύτερο';

  @override
  String get matchPreviewAllMeetings => 'Όλες οι αναμετρήσεις';

  @override
  String get recordsMeetings => 'ΑΝΑΜΕΤΡΗΣΕΙΣ';

  @override
  String get recordsLegends => 'ΘΡΥΛΟΙ';

  @override
  String get recordsAllTimeXi => 'ΕΝΔΕΚΑΔΑ ΟΛΩΝ ΤΩΝ ΕΠΟΧΩΝ';

  @override
  String get recordsHallOfFame => 'ΠΑΝΘΕΟΝ';

  @override
  String get recordsAllTimeWorld => 'ΠΑΓΚΟΣΜΙΑ ΙΣΤΟΡΙΑ';

  @override
  String get recordsAllTimeTopScorers => 'ΚΟΡΥΦΑΙΟΙ ΣΚΟΡΕΡ ΟΛΩΝ ΤΩΝ ΕΠΟΧΩΝ';

  @override
  String get recordsMostCapped => 'ΠΕΡΙΣΣΟΤΕΡΕΣ ΣΥΜΜΕΤΟΧΕΣ';

  @override
  String get recordsMostWcStarts => 'ΠΙΟ ΠΟΛΛΑ ΒΑΣΙΚΑ ΣΤΟ ΠΑΓΚΟΣΜΙΟ';

  @override
  String get recordsMostTournaments => 'ΠΕΡΙΣΣΟΤΕΡΕΣ ΣΥΜΜΕΤΟΧΕΣ ΣΕ ΤΟΥΡΝΟΥΑ';

  @override
  String get recordsRecordBook => 'ΒΙΒΛΙΟ ΡΕΚΟΡ';

  @override
  String get recordsHeadToHead => 'ΜΕΤΑΞΥ ΤΟΥΣ';

  @override
  String get recordsFiercestRival => 'Ο ΜΕΓΑΛΥΤΕΡΟΣ ΑΝΤΙΠΑΛΟΣ';

  @override
  String get recordsMostCaps => 'ΠΕΡΙΣΣΟΤΕΡΕΣ ΣΥΜΜΕΤΟΧΕΣ';

  @override
  String get recordsTopScorers => 'ΚΟΡΥΦΑΙΟΙ ΣΚΟΡΕΡ';

  @override
  String get recordsMostAssists => 'ΠΕΡΙΣΣΟΤΕΡΑ ΑΣΙΣΤ';

  @override
  String get recordsYourRecord => 'ΤΟ ΡΕΚΟΡ ΣΟΥ';

  @override
  String get callUpHome => 'ΕΝΤΟΣ';

  @override
  String get callUpAway => 'ΕΚΤΟΣ';

  @override
  String get recordsHome => 'ΕΝΤΟΣ';

  @override
  String get recordsAway => 'ΕΚΤΟΣ';

  @override
  String get recordsActive => 'ΕΝΕΡΓΟΣ';

  @override
  String get recordsStillActive => 'Ακόμη ενεργός';

  @override
  String get recordsAvg => 'μέσ.';

  @override
  String get recordsSelect => 'Επιλογή';

  @override
  String get recordsVs => 'vs';

  @override
  String get recordsDraws => 'Ισοπαλίες';

  @override
  String get recordsGoalsLabel => 'Γκολ';

  @override
  String get recordsBestFinish => 'Καλύτερη θέση';

  @override
  String get recordsNoFinalsYet => 'Καμία συμμετοχή σε τελική φάση ακόμη';

  @override
  String get recordsLongestUnbeaten => 'Μεγαλύτερη αήττητη σειρά';

  @override
  String get recordsBiggestWin => 'Μεγαλύτερη νίκη';

  @override
  String get recordsSeeAllMeetings => 'Δες όλες τις αναμετρήσεις';

  @override
  String get recordsSaveNotFound => 'Δεν βρέθηκε η αποθήκευση.';

  @override
  String get recordsNoMatches => 'Κανένας αγώνας.';

  @override
  String get recordsSearchPlayerOrNation => 'Αναζήτηση παίκτη ή εθνικής';

  @override
  String get recordsSearchNation => 'Αναζήτηση εθνικής';

  @override
  String get recordsPickTwoDifferent => 'Διάλεξε δύο διαφορετικές εθνικές.';

  @override
  String get recordsPlayToBuildRecord =>
      'Παίξε μερικούς αγώνες και το ρεκόρ σου απέναντι σε κάθε αντίπαλο θα χτιστεί εδώ.';

  @override
  String get recordsTapOpponent => 'Πάτα έναν αντίπαλο για την πλήρη ανάλυση.';

  @override
  String get recordsEdgeUpperHand => 'Έχεις το πάνω χέρι';

  @override
  String get recordsEdgeTheirNumber => 'Σε έχουν στο χέρι';

  @override
  String get recordsEdgeEven => 'Ισορροπία';

  @override
  String get recordsAllTimeWorldSubtitle =>
      'Σκόρερ και διεθνείς όλων των εθνικών ανά τον κόσμο';

  @override
  String get recordsHeadToHeadSubtitle =>
      'Σύγκρινε το ιστορικό δύο οποιωνδήποτε εθνικών';

  @override
  String get recordsLegendsSubtitle => 'Ενδεκάδα όλων των εποχών και πάνθεον';

  @override
  String get recordsUnitGoals => 'γκολ';

  @override
  String get recordsUnitCaps => 'συμμετοχές';

  @override
  String get recordsUnitStarts => 'βασικός';

  @override
  String get recordsUnitCups => 'τουρνουά';

  @override
  String get recordsUnitAssists => 'ασίστ';

  @override
  String recordsCapsCount(int count) {
    return '$count συμμετοχές';
  }

  @override
  String recordsGoalsCount(int count) {
    return '$count γκολ';
  }

  @override
  String recordsAssistsCount(int count) {
    return '$count ασίστ';
  }

  @override
  String recordsMotmCount(int count) {
    return '$count MVP';
  }

  @override
  String recordsMatchesCount(int count) {
    return '$count αγώνες';
  }

  @override
  String recordsMeetingsCount(int count) {
    return '$count αναμετρήσεις';
  }

  @override
  String recordsCodeWins(String code) {
    return 'Νίκες $code';
  }

  @override
  String recordsMeetingsWdl(int meetings, int wins, int draws, int losses) {
    return '$meetings αναμετρήσεις · $winsΝ $drawsΙ $lossesΗ';
  }

  @override
  String recordsWdl(int wins, int draws, int losses) {
    return '$winsΝ $drawsΙ $lossesΗ';
  }

  @override
  String recordsRivalLine(int meetings, String record, String edge) {
    return '$meetings αναμετρήσεις · $record · $edge';
  }

  @override
  String recordsNeverMet(String a, String b) {
    return '$a και $b δεν έχουν συναντηθεί ποτέ σε αυτή την αποθήκευση.';
  }

  @override
  String tacticsSentOffNote(String names) {
    return 'Αποβολή: $names. Χωρίς αντικατάσταση, οπότε παίζεις με παίκτη λιγότερο.';
  }

  @override
  String tacticsNeedFitPlayers(int required, int have) {
    return 'Χρειάζονται $required διαθέσιμοι ($have υγιείς)';
  }

  @override
  String tacticsMissesOfCamp(int missed, int total) {
    return 'Χάνει $missed/$total';
  }

  @override
  String get tacticsOutForWholeCamp => 'Εκτός για όλη την κλήση';

  @override
  String get rankingCentreOnMe => 'Εστίαση στη δική μου εθνική';

  @override
  String get recordsAfterExtraTime => 'παρ.';

  @override
  String recordsOnPenalties(int a, int b) {
    return '$a–$b στα πέναλτι';
  }

  @override
  String recordsVersus(String a, String b) {
    return '$a vs $b';
  }

  @override
  String recordsPlayedScore(int played, int gf, int ga) {
    return '$played αγώνες · $gf–$ga';
  }

  @override
  String recordsBiggestWinValue(int gf, int ga, String opp) {
    return '$gf–$ga vs $opp';
  }

  @override
  String recordsCouldNotLoad(String error) {
    return 'Δεν φορτώθηκε.\n$error';
  }

  @override
  String recordsCouldNotLoadLegends(String error) {
    return 'Δεν φορτώθηκαν οι θρύλοι.\n$error';
  }

  @override
  String recordsCouldNotLoadRecords(String error) {
    return 'Δεν φορτώθηκαν τα ρεκόρ.\n$error';
  }

  @override
  String recordsCouldNotLoadNations(String error) {
    return 'Δεν φορτώθηκαν οι εθνικές.\n$error';
  }

  @override
  String recordsCouldNotLoadYourRecord(String error) {
    return 'Δεν φορτώθηκε το ρεκόρ σου.\n$error';
  }

  @override
  String recordsCouldNotLoadRecord(String error) {
    return 'Δεν φορτώθηκε το ρεκόρ.\n$error';
  }

  @override
  String recordsNoLegends(String nation) {
    return 'Δεν υπάρχουν θρύλοι ακόμη. Παίξε μερικές εκστρατείες και οι μεγάλοι παίκτες της ομάδας «$nation» θα εμφανιστούν εδώ.';
  }

  @override
  String recordsGreatestSide(String nation) {
    return 'Η κορυφαία ενδεκάδα που θα μπορούσε ποτέ να παρατάξει η ομάδα «$nation».';
  }

  @override
  String get recordsNoWorldHistory =>
      'Ο κόσμος δεν έχει ακόμη ιστορία. Παίξε μερικές εκστρατείες και οι μεγάλοι όλων των εποχών θα εμφανιστούν εδώ.';

  @override
  String recordsPlayToWriteHistory(String nation) {
    return 'Παίξε μερικούς αγώνες για να αρχίσεις να γράφεις την ιστορία της ομάδας «$nation».';
  }

  @override
  String get tacticsLineGk => 'ΤΕΡ';

  @override
  String get tacticsLineDef => 'ΑΜΥ';

  @override
  String get tacticsLineMid => 'ΜΕΣ';

  @override
  String get tacticsLineFwd => 'ΕΠΙ';

  @override
  String get tacticsGoalkeepers => 'ΤΕΡΜΑΤΟΦΥΛΑΚΕΣ';

  @override
  String get tacticsDefenders => 'ΑΜΥΝΤΙΚΟΙ';

  @override
  String get tacticsMidfielders => 'ΜΕΣΟΙ';

  @override
  String get tacticsForwards => 'ΕΠΙΘΕΤΙΚΟΙ';

  @override
  String get tacticsCallUpsTitle => 'ΚΛΗΣΕΙΣ';

  @override
  String tacticsPickAtLeastPlayers(int min) {
    return 'Διάλεξε τουλάχιστον $min παίκτες.';
  }

  @override
  String tacticsCouldNotLoadSquad(String error) {
    return 'Δεν φορτώθηκε η αποστολή.\n$error';
  }

  @override
  String get tacticsNoSquad => 'Καμία αποστολή.';

  @override
  String tacticsSquadCount(int count, int max) {
    return 'ΑΠΟΣΤΟΛΗ · $count/$max';
  }

  @override
  String tacticsMinMax(int min, int max) {
    return 'Ελάχ. $min · Μέγ. $max';
  }

  @override
  String get tacticsBestQuality => 'Καλύτερη ποιότητα';

  @override
  String get tacticsPreviousSquad => 'Προηγούμενη αποστολή';

  @override
  String get tacticsSquadLockedBack => 'Πίσω (η αποστολή κλείδωσε)';

  @override
  String get tacticsConfirmSquad => 'Επιβεβαίωση αποστολής';

  @override
  String tacticsSquadFullMax(int max) {
    return 'Η αποστολή είναι πλήρης (μέγ. $max)';
  }

  @override
  String get tacticsSquadLocked => 'ΚΛΕΙΔΩΜΕΝΗ ΑΠΟΣΤΟΛΗ';

  @override
  String get tacticsNominationOpen => 'ΑΝΟΙΧΤΕΣ ΟΙ ΚΛΗΣΕΙΣ. ΔΙΑΛΕΞΕ ΑΠΟΣΤΟΛΗ';

  @override
  String get tacticsSquadFixedBlurb =>
      'Αυτή η αποστολή είναι οριστική για τους παρακάτω αγώνες. Επίλεξε ξανά πριν από το επόμενο παράθυρο κλήσεων.';

  @override
  String get tacticsSquadWillPlayBlurb =>
      'Αυτή η αποστολή θα παίξει τους παρακάτω αγώνες.';

  @override
  String get tacticsUnknown => 'Άγνωστη';

  @override
  String tacticsAgeValue(int age, String value) {
    return 'Ηλικία $age · $value';
  }

  @override
  String get tacticsFatigueExhausted => 'Εξαντλημένος';

  @override
  String get tacticsFatigueTired => 'Κουρασμένος';

  @override
  String get tacticsFatigueMatchLegs => 'Κόπωση αγώνων';

  @override
  String tacticsTooManySubs(int max) {
    return 'Πάρα πολλές αλλαγές (μέγ. $max).';
  }

  @override
  String tacticsMinuteTitle(int minute) {
    return 'ΤΑΚΤΙΚΗ · $minute\'';
  }

  @override
  String get tacticsApply => 'ΕΦΑΡΜΟΓΗ';

  @override
  String get tacticsTabLineupSubs => 'ΕΝΔΕΚΑΔΑ ΚΑΙ ΑΛΛΑΓΕΣ';

  @override
  String get tacticsTabTactics => 'ΤΑΚΤΙΚΗ';

  @override
  String get squadLineKeepers => 'ΤΕΡΜΑΤΟΦΥΛΑΚΕΣ';

  @override
  String get squadLineDefenders => 'ΑΜΥΝΑ';

  @override
  String get squadLineMidfielders => 'ΜΕΣΗ';

  @override
  String get squadLineForwards => 'ΕΠΙΘΕΣΗ';

  @override
  String get squadStatXiRating => 'Βαθμ. ενδεκάδας';

  @override
  String get squadStatAvgAge => 'Μέση ηλικία';

  @override
  String get squadStatSize => 'Αποστολή';

  @override
  String get squadStatUnavailable => 'Εκτός';

  @override
  String get squadDepthTitle => 'ΒΑΘΟΣ ΑΝΑ ΓΡΑΜΜΗ';

  @override
  String squadAgeShort(int age) {
    return '$age ετ.';
  }

  @override
  String get tacticsTabOtherPositions => 'ΑΛΛΕΣ ΘΕΣΕΙΣ';

  @override
  String get tacticsOutOfPositionNote => 'Εκτός θέσης εδώ';

  @override
  String get tacticsNobodyElse => 'Δεν υπάρχει άλλος να δοκιμάσεις εδώ.';

  @override
  String get tacticsPickSomebodyFirst =>
      'Διάλεξε ποιος βγαίνει και ο υπόλοιπος πάγκος εμφανίζεται εδώ, μαζί με τη βαθμολογία που θα είχαν σε αυτή τη θέση.';

  @override
  String get tacticsTabSuitable => 'ΚΑΤΑΛΛΗΛΟΙ';

  @override
  String get tacticsTabOnPitch => 'ΣΤΟ ΓΗΠΕΔΟ';

  @override
  String tacticsSectionSuitable(int count) {
    return 'ΚΑΤΑΛΛΗΛΟΙ · $count';
  }

  @override
  String get tacticsNobodySuits =>
      'Κανείς στον πάγκο δεν ταιριάζει φυσικά σε αυτή τη θέση, οπότε εμφανίζονται όλοι.';

  @override
  String tacticsSectionOnPitch(int count, int max) {
    return 'ΣΤΟ ΓΗΠΕΔΟ · $count/$max';
  }

  @override
  String tacticsSectionAvailable(int count) {
    return 'ΔΙΑΘΕΣΙΜΟΙ · $count';
  }

  @override
  String get tacticsRowStarted => 'Βασικός';

  @override
  String tacticsRowCameOn(int minute) {
    return 'Μπήκε στο $minute\'';
  }

  @override
  String get tacticsRowSubstitute => 'Αλλαγή';

  @override
  String get tacticsEnergyLabel => 'ΕΝΕΡΓΕΙΑ';

  @override
  String tacticsPickReplacementFor(String name) {
    return 'Πάτα έναν αντικαταστάτη για τον $name, ή πάτα ξανά τον ίδιο για ακύρωση.';
  }

  @override
  String get tacticsSlotLostToRedCard =>
      'Μια κόκκινη κάρτα σου στέρησε αυτή τη θέση. Σύρε έναν συμπαίκτη εδώ για να μετακινήσεις το κενό.';

  @override
  String get tacticsSentOffShort => 'ΑΠΟΒΛΗΘΗΚΕ';

  @override
  String get tacticsFullBackLeft => 'Αριστερός μπακ';

  @override
  String get tacticsFullBackRight => 'Δεξιός μπακ';

  @override
  String get tacticsFullBackUp => 'Ανεβαίνει';

  @override
  String get tacticsFullBackDown => 'Μένει πίσω';

  @override
  String get tacticsFullBackOff => 'Χωρίς οδηγία';

  @override
  String tacticsFullBackUpHint(String side) {
    return '$side: ανεβαίνει. Λίγο περισσότερη επίθεση, λίγο περισσότερο ρίσκο.';
  }

  @override
  String tacticsFullBackDownHint(String side) {
    return '$side: μένει πίσω. Λίγο πιο ασφαλές, λίγο λιγότερη επίθεση.';
  }

  @override
  String tacticsFullBackOffHint(String side) {
    return '$side: χωρίς οδηγία, ακολουθεί το πλάνο της ομάδας.';
  }

  @override
  String tacticsFullBackSemantics(String side, String state) {
    return '$side, βέλος: $state';
  }

  @override
  String tacticsSubsUsed(int used, int max) {
    return 'ΑΛΛΑΓΕΣ · $used/$max';
  }

  @override
  String get tacticsDragSubOn =>
      'Πάτα έναν παίκτη στο γήπεδο για να βγει, ή κράτα και σύρε έναν αναπληρωματικό πάνω του.';

  @override
  String get tacticsNoSubs => 'Δεν υπάρχουν διαθέσιμοι αναπληρωματικοί.';

  @override
  String get tacticsChooseShape => 'ΔΙΑΛΕΞΕ ΣΥΣΤΗΜΑ';

  @override
  String get tacticsFormation => 'ΣΥΣΤΗΜΑ';

  @override
  String get tacticsInstructions => 'ΟΔΗΓΙΕΣ';

  @override
  String get tacticsDrilling => 'ΠΡΟΕΤΟΙΜΑΣΙΑ';

  @override
  String get tacticsDrillingUnplayed => 'ΑΔΟΚΙΜΑΣΤΟ';

  @override
  String get tacticsDrillingNew => 'ΝΕΟ';

  @override
  String get tacticsDrillingSettling => 'ΜΠΑΙΝΕΙ ΣΤΟ ΡΥΘΜΟ';

  @override
  String get tacticsDrillingDrilled => 'ΑΠΟΜΑΘΗΜΕΝΟ';

  @override
  String get tacticsInstrMentality => 'Νοοτροπία';

  @override
  String get tacticsInstrDefensive => 'Αμυντική';

  @override
  String get tacticsInstrAttacking => 'Επιθετική';

  @override
  String get tacticsInstrPressing => 'Πρέσινγκ';

  @override
  String get tacticsInstrLowBlock => 'Χαμηλό μπλοκ';

  @override
  String get tacticsInstrHighPress => 'Υψηλό πρέσινγκ';

  @override
  String get tacticsInstrTempo => 'Τέμπο';

  @override
  String get tacticsInstrPatient => 'Υπομονετικό';

  @override
  String get tacticsInstrFast => 'Γρήγορο';

  @override
  String get tacticsInstrWidth => 'Πλάτος';

  @override
  String get tacticsInstrNarrow => 'Στενό';

  @override
  String get tacticsInstrWide => 'Ανοιχτό';

  @override
  String get tacticsInstrDefLine => 'Αμυντ. γραμμή';

  @override
  String get tacticsInstrDefensiveLine => 'Αμυντική γραμμή';

  @override
  String get tacticsInstrDeep => 'Χαμηλά';

  @override
  String get tacticsInstrHigh => 'Ψηλά';

  @override
  String get tacticsInstrDirectness => 'Αμεσότητα';

  @override
  String get tacticsInstrPossession => 'Κατοχή';

  @override
  String get tacticsInstrDirect => 'Άμεσο';

  @override
  String get tacticsPickGoalkeeper => 'ΔΙΑΛΕΞΕ ΤΕΡΜΑΤΟΦΥΛΑΚΑ';

  @override
  String get tacticsPickLeftBack => 'ΔΙΑΛΕΞΕ ΑΡΙΣΤΕΡΟ ΜΠΕΚ';

  @override
  String get tacticsPickCentreBack => 'ΔΙΑΛΕΞΕ ΚΕΝΤΡΙΚΟ ΜΠΕΚ';

  @override
  String get tacticsPickRightBack => 'ΔΙΑΛΕΞΕ ΔΕΞΙ ΜΠΕΚ';

  @override
  String get tacticsPickDefensiveMid => 'ΔΙΑΛΕΞΕ ΑΜΥΝΤΙΚΟ ΜΕΣΟ';

  @override
  String get tacticsPickCentralMid => 'ΔΙΑΛΕΞΕ ΚΕΝΤΡΙΚΟ ΜΕΣΟ';

  @override
  String get tacticsPickAttackingMid => 'ΔΙΑΛΕΞΕ ΕΠΙΘΕΤΙΚΟ ΜΕΣΟ';

  @override
  String get tacticsPickLeftMid => 'ΔΙΑΛΕΞΕ ΑΡΙΣΤΕΡΟ ΜΕΣΟ';

  @override
  String get tacticsPickRightMid => 'ΔΙΑΛΕΞΕ ΔΕΞΙ ΜΕΣΟ';

  @override
  String get tacticsPickLeftWing => 'ΔΙΑΛΕΞΕ ΑΡΙΣΤΕΡΟ ΕΞΩ';

  @override
  String get tacticsPickRightWing => 'ΔΙΑΛΕΞΕ ΔΕΞΙ ΕΞΩ';

  @override
  String get tacticsPickStriker => 'ΔΙΑΛΕΞΕ ΣΤΡΑΤΗΓΟ';

  @override
  String tacticsRoleOutOfPosition(String role) {
    return '$role · εκτός θέσης';
  }

  @override
  String tacticsAgeOnly(int age) {
    return 'Ηλικία $age';
  }

  @override
  String tacticsRoleAge(String role, int age) {
    return '$role · Ηλικία $age';
  }

  @override
  String get tacticsOn => 'ΜΕΣΑ';

  @override
  String get tacticsSquad => 'ΑΠΟΣΤΟΛΗ';

  @override
  String get tacticsTabLineup => 'ΕΝΔΕΚΑΔΑ';

  @override
  String get tacticsTabInstructions => 'ΟΔΗΓΙΕΣ';

  @override
  String get tacticsTabRoles => 'ΡΟΛΟΙ';

  @override
  String get tacticsTabSetPieces => 'ΣΤΑΤΙΚΕΣ ΦΑΣΕΙΣ';

  @override
  String get tacticsTabRolesSetPieces => 'ΡΟΛΟΙ ΚΑΙ ΣΤΑΤΙΚΕΣ ΦΑΣΕΙΣ';

  @override
  String get tacticsRolesSetPiecesBlurb =>
      'Δώσε ρόλο σε κάθε βασικό. Πάτα το σήμα πέναλτι (⚽) ή φάουλ (▲) για να ορίσεις εκτελεστή.';

  @override
  String get tacticsTooltipCallUps => 'Κλήσεις';

  @override
  String get tacticsTooltipPresets => 'Προεπιλογές τακτικής';

  @override
  String get tacticsTooltipInstructions => 'Οδηγίες';

  @override
  String get tacticsNoTacticSet => 'Δεν έχει οριστεί τακτική.';

  @override
  String tacticsReplaceStarters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ΑΝΤΙΚΑΤΑΣΤΗΣΕ $count ΒΑΣΙΚΟΥΣ',
      one: 'ΑΝΤΙΚΑΤΑΣΤΗΣΕ $count ΒΑΣΙΚΟ',
    );
    return '$_temp0';
  }

  @override
  String tacticsPlayerOut(String name, String reason) {
    return '$name: $reason';
  }

  @override
  String get tacticsOut => 'Εκτός';

  @override
  String get tacticsTapSpotReplace =>
      'Πάτα τη θέση τους στο γήπεδο για να διαλέξεις αντικαταστάτη.';

  @override
  String get tacticsTapOrDrag =>
      'Πάτα έναν παίκτη για να τον αλλάξεις, ή κράτα και σύρε για να τον μετακινήσεις.';

  @override
  String get tacticsPlayerRoles => 'ΡΟΛΟΙ ΠΑΙΚΤΩΝ';

  @override
  String get tacticsRolesBlurb =>
      'Δώσε σε έναν παίκτη δουλειά: φονιάς της περιοχής, δημιουργός, σέντερ φορ. Καθορίζει ποιος σκοράρει και ποιος δημιουργεί.';

  @override
  String get tacticsSetPieceTakers => 'ΕΚΤΕΛΕΣΤΕΣ ΣΤΑΤΙΚΩΝ ΦΑΣΕΩΝ';

  @override
  String get tacticsSetPieceBlurb =>
      'Ποιος εκτελεί πέναλτι και στατικές φάσεις, ή άφησέ το στον καταλληλότερο παίκτη.';

  @override
  String get tacticsTakerAuto => 'Αυτόματα';

  @override
  String get tacticsTakerQuickPick => 'Οι καλύτεροι εκτελεστές';

  @override
  String get tacticsPenalties => 'Πέναλτι';

  @override
  String get tacticsCornersFreeKicks => 'Κόρνερ και φάουλ';

  @override
  String get tacticsSkillFin => 'ΤΕΛ';

  @override
  String get tacticsSkillPas => 'ΠΑΣ';

  @override
  String tacticsRolePlayer(String name) {
    return 'ΡΟΛΟΣ · $name';
  }

  @override
  String get tacticsPenaltyTaker => 'ΕΚΤΕΛΕΣΤΗΣ ΠΕΝΑΛΤΙ';

  @override
  String get tacticsCornerFreeKickTaker => 'ΕΚΤΕΛΕΣΤΗΣ ΚΟΡΝΕΡ ΚΑΙ ΦΑΟΥΛ';

  @override
  String get tacticsAutomatic => 'Αυτόματα';

  @override
  String get tacticsLetBestSuited => 'Άφησέ το στον καταλληλότερο παίκτη.';

  @override
  String get tacticsInXi => 'ΣΤΗΝ ΕΝΔΕΚΑΔΑ';

  @override
  String get tacticsTeamInstructions => 'ΟΔΗΓΙΕΣ ΟΜΑΔΑΣ';

  @override
  String get tacticsTeamInstructionsBlurb =>
      'Όρισε πώς παίζει η ομάδα σου. Κάθε ρύθμιση επηρεάζει ολόκληρη την ομάδα.';

  @override
  String tacticsSavedPreset(String name) {
    return 'Αποθηκεύτηκε: «$name»';
  }

  @override
  String tacticsAppliedPreset(String name) {
    return 'Εφαρμόστηκε: «$name»';
  }

  @override
  String get tacticsTacticPresets => 'ΠΡΟΕΠΙΛΟΓΕΣ ΤΑΚΤΙΚΗΣ';

  @override
  String get tacticsPresetsBlurb =>
      'Αποθήκευσε αυτό το σύστημα ως επαναχρησιμοποιήσιμο στυλ, ή εφάρμοσε ένα που έχεις αποθηκεύσει.';

  @override
  String get tacticsSaveCurrentTactic => 'Αποθήκευση τρέχουσας τακτικής';

  @override
  String tacticsCouldNotLoadPresets(String error) {
    return 'Δεν φορτώθηκαν οι προεπιλογές.\n$error';
  }

  @override
  String get tacticsNoPresetsYet =>
      'Καμία προεπιλογή ακόμη. Πάτα «Αποθήκευση τρέχουσας τακτικής» για να κρατήσεις αυτή τη ρύθμιση ως επαναχρησιμοποιήσιμο στυλ.';

  @override
  String get tacticsNameThisTactic => 'Όνομα τακτικής';

  @override
  String get tacticsNameHint => 'π.χ. Υψηλό πρέσινγκ 4-3-3';

  @override
  String get tacticsCancel => 'Άκυρο';

  @override
  String get tacticsSave => 'Αποθήκευση';

  @override
  String get tacticsTapToAssign => 'Πάτα για ανάθεση';

  @override
  String get tacticsHoldDragSub =>
      'Κράτα έναν αναπληρωματικό και σύρε τον πάνω σε έναν παίκτη για να μπει.';

  @override
  String get hubContinue => 'Συνέχεια';

  @override
  String get hubBrackets => 'Πίνακας';

  @override
  String hubCouldNotLoad(String error) {
    return 'Δεν φορτώθηκε.\n$error';
  }

  @override
  String hubCouldNotLoadFinances(String error) {
    return 'Δεν φορτώθηκαν τα οικονομικά.\n$error';
  }

  @override
  String hubCouldNotLoadSave(String error) {
    return 'Δεν φορτώθηκε η αποθήκευση.\n$error';
  }

  @override
  String get hubSaveNotFound => 'Δεν βρέθηκε η αποθήκευση.';

  @override
  String get hubUnknown => 'Άγνωστο';

  @override
  String hubWorldChampionsYear(int year) {
    return 'ΠΑΓΚΟΣΜΙΟΙ ΠΡΩΤΑΘΛΗΤΕΣ $year';
  }

  @override
  String get hubCycleComplete => 'Ο κύκλος ολοκληρώθηκε.';

  @override
  String get hubYourJob => 'Η ΔΟΥΛΕΙΑ ΣΟΥ';

  @override
  String get hubStayProject => 'Μείνε και συνέχισε το έργο σου';

  @override
  String get hubChooseNextJob => 'ΔΙΑΛΕΞΕ ΤΗΝ ΕΠΟΜΕΝΗ ΔΟΥΛΕΙΑ';

  @override
  String get hubOffersOnTable => 'ΠΡΟΣΦΟΡΕΣ ΣΤΟ ΤΡΑΠΕΖΙ';

  @override
  String hubOfferSubtitle(String tier, int position) {
    return '$tier · #$position στον κόσμο';
  }

  @override
  String hubContinueWith(String nation) {
    return 'Συνέχεια: $nation';
  }

  @override
  String get hubYourNation => 'η εθνική σου';

  @override
  String get hubTakeTheJob => 'Δέξου τη δουλειά';

  @override
  String get hubFederationFinances => 'ΟΙΚΟΝΟΜΙΚΑ ΟΜΟΣΠΟΝΔΙΑΣ';

  @override
  String get hubBudgetIntro =>
      'Η πρώτη σου δουλειά τον επόμενο κύκλο είναι να ορίσεις τον προϋπολογισμό της ομοσπονδίας και να τον μοιράσεις στα τμήματα.';

  @override
  String get hubStarting => 'Έναρξη…';

  @override
  String get hubBeginNextCycle => 'Έναρξη επόμενου κύκλου';

  @override
  String get hubContinueCareer => 'Συνέχισε την καριέρα σου';

  @override
  String get hubBackToSaves => 'Πίσω στις αποθηκεύσεις σου';

  @override
  String get hubOpeningBalance => 'Αρχικό υπόλοιπο';

  @override
  String get hubCentralFunding => 'Κεντρική χρηματοδότηση';

  @override
  String get hubPrizeMoney => 'Χρηματικά έπαθλα';

  @override
  String get hubCommercialReturn => 'Εμπορικά έσοδα';

  @override
  String get hubAvailableToInvest => 'Διαθέσιμα για επένδυση';

  @override
  String hubReputation(String label, int rep) {
    return 'Φήμη: $label ($rep)';
  }

  @override
  String get hubNationalHero => 'Εθνικός ήρωας';

  @override
  String get hubFinal => 'Τελικός';

  @override
  String get hubStageRoundOf32 => 'Φάση των 32';

  @override
  String get hubStageThirdPlace => 'Μπαράζ τρίτης θέσης';

  @override
  String get hubEventAdvanceWorld => 'Προώθηση του κόσμου';

  @override
  String hubEventStartCycle(int year) {
    return 'Έναρξη κύκλου $year';
  }

  @override
  String hubEventWorldChampions(String nation) {
    return 'Παγκόσμιοι Πρωταθλητές: $nation';
  }

  @override
  String get hubEventSetBudget => 'Όρισε τον προϋπολογισμό της ομοσπονδίας';

  @override
  String get hubEventSetBudgetSub =>
      'Μοίρασε τα κεφάλαια του κύκλου πριν ξεκινήσει η σεζόν';

  @override
  String get hubEventNaturalization => 'Εξέταση πρότασης πολιτογράφησης';

  @override
  String get hubEventNaturalizationSub =>
      'Ένας ξένος παίκτης θέλει να αλλάξει εθνική ομάδα και να έρθει σε σένα';

  @override
  String get hubEventCampaignVerdict => 'Η εκστρατεία έκλεισε: δες την κρίση';

  @override
  String get hubEventCampaignComplete => 'Η εκστρατεία ολοκληρώθηκε';

  @override
  String get hubEventIntercontinentalPlayoff => 'Το διηπειρωτικό μπαράζ';

  @override
  String get hubEventWatchWcDraw =>
      'Δες την κλήρωση του Παγκόσμιου Πρωταθλήματος';

  @override
  String get hubEventWorldCupHere => 'Το Παγκόσμιο Πρωτάθλημα ξεκινά';

  @override
  String get hubEventWatchFinalsDraw => 'Δες την κλήρωση της τελικής φάσης';

  @override
  String get hubEventFinalsHere => 'Η τελική φάση ξεκινά';

  @override
  String get hubEventPlayWcRound =>
      'Παίξε τον επόμενο γύρο του Παγκόσμιου Πρωταθλήματος';

  @override
  String hubEventPlayCupMatch(String cup) {
    return 'Επόμενος αγώνας: $cup';
  }

  @override
  String get hubEventPlayNationsCupMatch =>
      'Παίξε τον επόμενο αγώνα του Κυπέλλου Εθνών';

  @override
  String get hubEventWatchNationsCupDraw =>
      'Δες την κλήρωση του Κυπέλλου Εθνών';

  @override
  String get hubEventWatchHostSelection => 'Δες την επιλογή οικοδεσπότη';

  @override
  String get hubEventWatchQualifyingDraw => 'Δες την κλήρωση των προκριματικών';

  @override
  String get hubEventWatchWcHostSelection =>
      'Δες την επιλογή οικοδεσπότη του Παγκόσμιου Πρωταθλήματος';

  @override
  String get hubEventWatchWcQualifyingDraw =>
      'Δες την κλήρωση των προκριματικών του Παγκόσμιου Πρωταθλήματος';

  @override
  String get hubEventArrangeFriendlies => 'Κανόνισε φιλικά';

  @override
  String hubEventFriendliesSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Δεν έχεις συμπληρώσει ακόμη τα $count ανοιχτά παράθυρα φιλικών',
      one: 'Δεν έχεις συμπληρώσει ακόμη το ανοιχτό παράθυρο φιλικών',
    );
    return '$_temp0';
  }

  @override
  String get hubEventReshapeXi => 'Ανασχημάτισε την ενδεκάδα σου';

  @override
  String hubEventReshapeOutSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count από την ενδεκάδα σου λείπουν (τιμωρία ή τραυματισμός). Διάλεξε αντικαταστάτες',
      one:
          '1 από την ενδεκάδα σου λείπει (τιμωρία ή τραυματισμός). Διάλεξε αντικαταστάτη',
    );
    return '$_temp0';
  }

  @override
  String hubEventReshapeShortSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Η ενδεκάδα σου είναι ελλιπής. Συμπλήρωσε τις θέσεις που μένουν ανοιχτές',
      one: 'Η ενδεκάδα σου είναι ελλιπής. Συμπλήρωσε τη θέση που μένει ανοιχτή',
    );
    return '$_temp0';
  }

  @override
  String hubEventPlayOpponent(String opponent) {
    return 'Αγώνας: $opponent';
  }

  @override
  String get hubEventContinentalFinalsFallback =>
      'η τελική φάση του ηπειρωτικού πρωταθλήματος';

  @override
  String get hubCallUpFriendlies => 'Όρισε την αποστολή για τα φιλικά';

  @override
  String get hubCallUpRequalify => 'Όρισε ξανά την αποστολή των προκριματικών';

  @override
  String get hubCallUpWorldCup =>
      'Όρισε την αποστολή για το Παγκόσμιο Πρωτάθλημα';

  @override
  String get hubCallUpFinals => 'Όρισε την αποστολή για την τελική φάση';

  @override
  String get hubCallUpNationsCup => 'Όρισε την αποστολή για το Κύπελλο Εθνών';

  @override
  String get hubCallUpQualifying => 'Όρισε την αποστολή των προκριματικών';

  @override
  String get hubCallUpGeneric => 'Όρισε την αποστολή';

  @override
  String get hubHost => 'Οικοδεσπότης';

  @override
  String get hubGoldenBoot => 'Χρυσή Μπότα';

  @override
  String hubGoldenBootValue(String name, int goals) {
    return '$name · $goals γκολ';
  }

  @override
  String get hubPens => '(πέν.)';

  @override
  String get hubNationalHub => 'ΚΕΝΤΡΙΚΗ ΟΘΟΝΗ';

  @override
  String get hubMessages => 'Μηνύματα';

  @override
  String get hubWorldChampions => 'ΠΑΓΚΟΣΜΙΟΙ ΠΡΩΤΑΘΛΗΤΕΣ';

  @override
  String get hubViewBracket => 'Δες τον πίνακα ›';

  @override
  String get hubBoardDelighted => 'Ενθουσιασμένη';

  @override
  String get hubBoardPleased => 'Ικανοποιημένη';

  @override
  String get hubBoardExpectingMore => 'Περιμένει περισσότερα';

  @override
  String get hubBoardConcerned => 'Ανήσυχη';

  @override
  String get hubBoardJobAtRisk => 'Η θέση σου κινδυνεύει';

  @override
  String get hubBoard => 'ΔΙΟΙΚΗΣΗ';

  @override
  String hubBoardObjective(String label) {
    return 'Στόχος της διοίκησης: $label';
  }

  @override
  String hubObjectiveMet(String result) {
    return 'ΕΠΙΤΕΥΧΘΗΚΕ · $result';
  }

  @override
  String hubObjectiveMissed(String result) {
    return 'ΑΠΟΤΥΧΙΑ · $result';
  }

  @override
  String get hubNoMoreFixtures => 'Δεν υπάρχουν άλλοι αγώνες αυτόν τον κύκλο.';

  @override
  String get hubVs => 'VS';

  @override
  String hubWorldRank(int rank) {
    return '#$rank';
  }

  @override
  String get hubWorldRankLabel => 'Παγκόσμια κατάταξη';

  @override
  String get hubSquadStatus => 'ΚΑΤΑΣΤΑΣΗ ΑΠΟΣΤΟΛΗΣ';

  @override
  String hubPlayers(int count) {
    return '$count παίκτες';
  }

  @override
  String get hubAvgRating => 'Μέση βαθμολογία';

  @override
  String get hubMorale => 'Ηθικό';

  @override
  String get hubManageTeam => 'Διαχείριση ομάδας';

  @override
  String get hubGroupsToBeDrawn =>
      'Οι όμιλοι δεν έχουν κληρωθεί. Δες την κλήρωση για να τους μάθεις.';

  @override
  String hubGroupName(String name) {
    return 'ΟΜΙΛΟΣ $name';
  }

  @override
  String get hubTblTeam => 'ΟΜΑΔΑ';

  @override
  String get hubTblP => 'Α';

  @override
  String get hubTblGd => 'ΔΤ';

  @override
  String get hubTblPts => 'ΒΑΘ';

  @override
  String get homeSettings => 'Ρυθμίσεις';

  @override
  String get homeLeadTheNation => 'ΟΔΗΓΗΣΕ ΤΗΝ ΕΘΝΙΚΗ';

  @override
  String get homeYourNation => 'η εθνική σου';

  @override
  String get homeNewGame => 'Νέο παιχνίδι';

  @override
  String get homeAllSaves => 'Όλες οι αποθηκεύσεις';

  @override
  String get homeLoadGame => 'Φόρτωση παιχνιδιού';

  @override
  String get homeContinue => 'ΣΥΝΕΧΕΙΑ';

  @override
  String homeRoadToWorldCup(String date, int year) {
    return '$date · Δρόμος προς το Παγκόσμιο Πρωτάθλημα $year';
  }

  @override
  String get careerManageSaves => 'Διαχείριση αποθηκεύσεων';

  @override
  String get careerNewGameTitle => 'ΝΕΟ ΠΑΙΧΝΙΔΙ';

  @override
  String careerCouldNotLoadNation(String error) {
    return 'Δεν φορτώθηκε η εθνική.\n$error';
  }

  @override
  String get careerNationNotFound => 'Η εθνική δεν βρέθηκε.';

  @override
  String careerWorldRankNum(int rank) {
    return 'ΠΑΓΚΟΣΜΙΑ ΚΑΤΑΤΑΞΗ #$rank';
  }

  @override
  String get careerManagerName => 'Όνομα προπονητή';

  @override
  String get careerManagerNameHint => 'π.χ. Ότο Ρεχάγκελ';

  @override
  String get careerBeginsBlurb =>
      'Η καριέρα σου ξεκινά τον Σεπτέμβριο του 2026, στον δρόμο για το Παγκόσμιο Πρωτάθλημα του 2030.';

  @override
  String get careerFreeCycleNote =>
      'Δωρεάν για έναν ολόκληρο τετραετή κύκλο: προκριματικά, το ηπειρωτικό σου πρωτάθλημα και το Παγκόσμιο Πρωτάθλημα, με δύο αποθηκεύσεις. Μετά, μία πληρωμή ξεκλειδώνει ατέλειωτους κύκλους.';

  @override
  String get careerStartCareer => 'Έναρξη καριέρας';

  @override
  String get careersTitle => 'ΚΑΡΙΕΡΕΣ';

  @override
  String get careerManagerCareer => 'Καριέρα προπονητή';

  @override
  String get careerManagerCareerSubtitle =>
      'Κάθε κύκλος που έχεις προπονήσει και ο συνολικός σου απολογισμός';

  @override
  String get careerSummaryTitle => 'Σύνοψη καριέρας';

  @override
  String get careerSummarySubtitle =>
      'Η βιτρίνα τροπαίων και ο απολογισμός σου';

  @override
  String get careerAchievements => 'Επιτεύγματα';

  @override
  String get careerAchievementsSubtitle =>
      'Ορόσημα, τίτλοι και ικανοποίηση της διοίκησης';

  @override
  String get careerChallenges => 'Προκλήσεις';

  @override
  String get careerChallengesSubtitle =>
      'Σκληρές δοκιμασίες μιας ολόκληρης καριέρας';

  @override
  String get careerTeamRecords => 'Ρεκόρ ομάδας';

  @override
  String get careerTeamRecordsSubtitle =>
      'Πρώτοι σκόρερ και συμμετοχές όλων των εποχών';

  @override
  String get careerMyMatches => 'Οι αγώνες μου';

  @override
  String get careerMyMatchesSubtitle =>
      'Κάθε αποτέλεσμα και επερχόμενος αγώνας';

  @override
  String get careerTitle => 'ΚΑΡΙΕΡΑ';

  @override
  String careerCouldNotLoadCareer(String error) {
    return 'Δεν φορτώθηκε η καριέρα.\n$error';
  }

  @override
  String get careerNoCareer => 'Καμία καριέρα.';

  @override
  String get careerTrophyCabinet => 'ΒΙΤΡΙΝΑ ΤΡΟΠΑΙΩΝ';

  @override
  String get careerTournamentHistory => 'ΙΣΤΟΡΙΚΟ ΤΟΥΡΝΟΥΑ';

  @override
  String get careerNoTournamentsYet =>
      'Δεν έχει ολοκληρωθεί κανένα τουρνουά ακόμα.';

  @override
  String get careerTeamFallback => 'Ομάδα';

  @override
  String careerWorldNum(int rank) {
    return 'ΠΑΓΚΟΣΜΙΑ #$rank';
  }

  @override
  String careerPointsNum(int points) {
    return '$points ΒΘ';
  }

  @override
  String careerSeasonNum(int season) {
    return 'ΣΕΖΟΝ $season';
  }

  @override
  String get careerStatPlayedShort => 'Α';

  @override
  String get careerStatsHeading => 'ΣΕ ΑΡΙΘΜΟΥΣ';

  @override
  String get careerStatsWinRate => 'Ποσοστό νικών';

  @override
  String get careerStatsGoalsFor => 'Γκολ υπέρ';

  @override
  String get careerStatsGoalsAgainst => 'Γκολ κατά';

  @override
  String get careerStatsGoalDiff => 'Διαφ. τερμάτων';

  @override
  String get careerStatsCleanSheets => 'Μηδέν παθητικό';

  @override
  String get careerStatsBiggestWin => 'Μεγαλύτερη νίκη';

  @override
  String get careerStatsWinStreak => 'Σερί νικών';

  @override
  String get careerStatsUnbeaten => 'Αήττητο σερί';

  @override
  String get careerStatsShootouts => 'Πέναλτι';

  @override
  String get careerStatsHatTricks => 'Χατ-τρικ';

  @override
  String get careerStatsMotms => 'Κορυφαίος του αγώνα';

  @override
  String get careerStatsBestRating => 'Καλύτερη βαθμολογία';

  @override
  String get careerStatWonShort => 'Ν';

  @override
  String get careerStatDrawnShort => 'Ι';

  @override
  String get careerStatLostShort => 'Η';

  @override
  String get careerStatGoalsForShort => 'ΓΥ';

  @override
  String get careerStatGoalsAgainstShort => 'ΓΚ';

  @override
  String get careerStatGoalDiffShort => 'ΔΤ';

  @override
  String get careerNoSilverware =>
      'Κανένα τρόπαιο ακόμα. Πήγαινε να κερδίσεις ένα.';

  @override
  String get careerMedalGold => 'ΧΡΥΣΟ';

  @override
  String get careerMedalSilver => 'ΑΣΗΜΙ';

  @override
  String get careerMedalBronze => 'ΜΠΡΟΝΖΟ';

  @override
  String careerWinnersName(String name) {
    return 'Νικητές: $name';
  }

  @override
  String get careerSavesTitle => 'ΑΠΟΘΗΚΕΥΣΕΙΣ';

  @override
  String careerCouldNotLoadSaves(String error) {
    return 'Δεν φορτώθηκαν οι αποθηκεύσεις.\n$error';
  }

  @override
  String careerSlotsCount(int used, int limit) {
    return 'ΘΕΣΕΙΣ  $used/$limit';
  }

  @override
  String get careerThisSave => 'αυτή η αποθήκευση';

  @override
  String get careerSlotsFull => 'Οι θέσεις γέμισαν';

  @override
  String careerSlotsUsed(int used) {
    return 'ΘΕΣΕΙΣ  $used';
  }

  @override
  String get careerSlotsUnlockMore => 'Ξεκλείδωμα περισσότερων αποθηκεύσεων';

  @override
  String get careerSlotsKeepNote =>
      'Κάθε αποθήκευση που έχεις ήδη παραμένει παιζόμενη. Μόνο μια νέα χρειάζεται το ξεκλείδωμα.';

  @override
  String get careerNewGame => 'Νέο παιχνίδι';

  @override
  String get careerDeleteSaveTitle => 'Διαγραφή αποθήκευσης;';

  @override
  String careerDeleteSaveBody(String label) {
    return 'Η καριέρα «$label» θα διαγραφεί οριστικά.';
  }

  @override
  String get careerCancel => 'Άκυρο';

  @override
  String get careerDelete => 'Διαγραφή';

  @override
  String get careerNoSavesYet =>
      'Καμία αποθήκευση ακόμα.\nΞεκίνα νέο παιχνίδι για να οδηγήσεις μια εθνική.';

  @override
  String get careerUnknownNation => 'Άγνωστη';

  @override
  String careerPlayedMinutes(int minutes) {
    return '$minutesλ';
  }

  @override
  String careerPlayedHours(int hours, int minutes) {
    return '$hoursω $minutesλ';
  }

  @override
  String careerLastPlayed(String when) {
    return 'Τελευταίο παιχνίδι: $when';
  }

  @override
  String get careerJustNow => 'μόλις τώρα';

  @override
  String get careerYesterday => 'χθες';

  @override
  String careerMinutesAgo(int n) {
    return 'πριν $nλ';
  }

  @override
  String careerHoursAgo(int n) {
    return 'πριν $nω';
  }

  @override
  String careerDaysAgo(int n) {
    return 'πριν $nμ';
  }

  @override
  String careerRoadToWorldCup(int year) {
    return 'Δρόμος προς το Παγκόσμιο Πρωτάθλημα $year';
  }

  @override
  String get careerManagerCareerTitle => 'ΚΑΡΙΕΡΑ ΠΡΟΠΟΝΗΤΗ';

  @override
  String careerCouldNotLoad(String error) {
    return 'Δεν φορτώθηκε.\n$error';
  }

  @override
  String get careerCycleByCycle => 'ΚΥΚΛΟΣ ΜΕ ΚΥΚΛΟ';

  @override
  String careerCyclesNationsLed(int cycles, int nations) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles κύκλοι',
      one: '1 κύκλος',
    );
    String _temp1 = intl.Intl.pluralLogic(
      nations,
      locale: localeName,
      other: '$nations εθνικές ομάδες',
      one: '1 εθνική ομάδα',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get careerStatTitles => 'Τίτλοι';

  @override
  String get careerStatPlayed => 'Αγώνες';

  @override
  String get careerStatWon => 'Νίκες';

  @override
  String get careerStatDrawn => 'Ισοπαλίες';

  @override
  String get careerStatLost => 'Ήττες';

  @override
  String careerGoalsWinRate(
    int goalsFor,
    int goalsAgainst,
    String gd,
    int winRate,
  ) {
    return 'Γκολ $goalsFor–$goalsAgainst  ($gd)  ·  Ποσοστό νικών $winRate%';
  }

  @override
  String get careerRecordResults => 'ΡΕΚΟΡ ΑΠΟΤΕΛΕΣΜΑΤΑ';

  @override
  String get careerBestWin => 'Καλύτερη νίκη';

  @override
  String get careerWorstDefeat => 'Χειρότερη ήττα';

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
    return '$wonΝ $drawnΙ $lostΗ  ·  ΓΥ $goalsFor ΓΚ $goalsAgainst ($gd)';
  }

  @override
  String get careerWorldCupLabel => 'Παγκόσμιο Πρωτάθλημα';

  @override
  String get careerContinentalLabel => 'Ηπειρωτικό';

  @override
  String get messagesTitle => 'ΜΗΝΥΜΑΤΑ';

  @override
  String get messagesNoMessagesYet => 'Δεν υπάρχουν μηνύματα ακόμα.';

  @override
  String messagesCouldNotLoad(String error) {
    return 'Δεν φορτώθηκαν τα μηνύματα.\n$error';
  }

  @override
  String get messagesDone => 'Τέλος';

  @override
  String get messagesNext => 'Επόμενο';

  @override
  String get rankingWorldRanking => 'ΠΑΓΚΟΣΜΙΑ ΚΑΤΑΤΑΞΗ';

  @override
  String rankingCouldNotLoad(String error) {
    return 'Δεν φορτώθηκε η κατάταξη.\n$error';
  }

  @override
  String get rankingNoRanking => 'Καμία κατάταξη.';

  @override
  String get rankingAll => 'ΟΛΑ';

  @override
  String get rankingYourTeam => 'Η ΟΜΑΔΑ ΣΟΥ';

  @override
  String get rankingYourRankingOverTime => 'Η ΚΑΤΑΤΑΞΗ ΣΟΥ ΜΕ ΤΟ ΧΡΟΝΟ';

  @override
  String rankingNowRank(int rank) {
    return 'τώρα #$rank';
  }

  @override
  String rankingBestWorst(int best, int worst) {
    return 'καλύτερη #$best · χειρότερη #$worst';
  }

  @override
  String get friendliesTitle => 'ΦΙΛΙΚΑ';

  @override
  String friendliesLoadError(String error) {
    return 'Δεν φορτώθηκαν τα φιλικά.\n$error';
  }

  @override
  String get friendliesContinue => 'Συνέχεια';

  @override
  String friendliesArrangeIntro(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'τα $count ανοιχτά παράθυρα',
      one: 'το 1 ανοιχτό παράθυρο',
    );
    return 'Κανόνισε προπονητικά φιλικά για $_temp0 πριν από τον επόμενο επίσημο αγώνα. Πάτα έναν αντίπαλο ή άφησέ το ελεύθερο.';
  }

  @override
  String get friendliesFree => 'Ελεύθερο';

  @override
  String matchGoalsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ΓΚΟΛ',
      one: '1 ΓΚΟΛ',
    );
    return '$_temp0';
  }

  @override
  String get matchGoalsTitle => 'ΓΚΟΛ';

  @override
  String get matchGoalsNone => 'Κανένα γκολ';

  @override
  String get matchGoalPenalty => 'ΠΕΝ';

  @override
  String get matchGoalSetPiece => 'ΣΤΦ';

  @override
  String matchGoalAssist(String name) {
    return 'ασίστ $name';
  }

  @override
  String get friendliesHome => 'ΕΝΤΟΣ';

  @override
  String get friendliesAway => 'ΕΚΤΟΣ';

  @override
  String get friendliesNoneThisWindow => 'Κανένα φιλικό αυτό το παράθυρο';

  @override
  String friendliesConfirmCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count φιλικά',
      one: '1 φιλικό',
    );
    return 'Επιβεβαίωση: $_temp0';
  }

  @override
  String get friendliesMonthJan => 'Ιαν';

  @override
  String get friendliesMonthFeb => 'Φεβ';

  @override
  String get friendliesMonthMar => 'Μαρ';

  @override
  String get friendliesMonthApr => 'Απρ';

  @override
  String get friendliesMonthMay => 'Μαΐ';

  @override
  String get friendliesMonthJun => 'Ιουν';

  @override
  String get friendliesMonthJul => 'Ιουλ';

  @override
  String get friendliesMonthAug => 'Αυγ';

  @override
  String get friendliesMonthSep => 'Σεπ';

  @override
  String get friendliesMonthOct => 'Οκτ';

  @override
  String get friendliesMonthNov => 'Νοε';

  @override
  String get friendliesMonthDec => 'Δεκ';

  @override
  String get resultsMyMatches => 'ΟΙ ΑΓΩΝΕΣ ΜΟΥ';

  @override
  String resultsCouldNotLoad(String error) {
    return 'Δεν φορτώθηκαν τα αποτελέσματα.\n$error';
  }

  @override
  String get resultsNoFixtures => 'Κανένας αγώνας.';

  @override
  String get resultsVs => 'vs';

  @override
  String get resultsStageQualifier => 'ΠΡΟΚΡΙΜΑΤΙΚΟ';

  @override
  String get resultsStageFriendly => 'ΦΙΛΙΚΟ';

  @override
  String get resultsStageGroupStage => 'ΦΑΣΗ ΟΜΙΛΩΝ';

  @override
  String get resultsStageSemiFinal => 'ΗΜΙΤΕΛΙΚΟΣ';

  @override
  String get resultsStageFinal => 'ΤΕΛΙΚΟΣ';

  @override
  String get resultsStageContinentalClash => 'ΗΠΕΙΡΩΤΙΚΗ ΑΝΑΜΕΤΡΗΣΗ';

  @override
  String get resultsStageFinalsGroup => 'ΟΜΙΛΟΣ ΤΕΛΙΚΗΣ ΦΑΣΗΣ';

  @override
  String get resultsStageRoundOf32 => 'ΦΑΣΗ ΤΩΝ 32';

  @override
  String get resultsStageRoundOf16 => 'ΦΑΣΗ ΤΩΝ 16';

  @override
  String get resultsStageQuarterFinal => 'ΠΡΟΗΜΙΤΕΛΙΚΟΣ';

  @override
  String get resultsStageThirdPlace => 'ΤΡΙΤΗ ΘΕΣΗ';

  @override
  String get matchSetupWarnCaptain =>
      'Δεν ορίστηκε αρχηγός. Πάτα για να δώσεις σε κάποιον το περιβραχιόνιο';

  @override
  String matchSetupWarnCaptainInjured(String name) {
    return '$name: τραυματίας, δεν μπορεί να οδηγήσει την ομάδα. Πάτα για να δώσεις το περιβραχιόνιο σε άλλον';
  }

  @override
  String matchSetupWarnCaptainSuspended(String name) {
    return '$name: τιμωρημένος σε αυτόν τον αγώνα. Πάτα για να δώσεις το περιβραχιόνιο σε άλλον';
  }

  @override
  String matchSetupWarnCaptainDropped(String name) {
    return '$name: έχει το περιβραχιόνιο αλλά δεν είναι στην αποστολή σου. Πάτα για να το δώσεις σε άλλον';
  }

  @override
  String get matchSetupWarnSetPieces =>
      'Δεν ορίστηκαν εκτελεστές στατικών φάσεων. Πάτα για να διαλέξεις ποιοι αναλαμβάνουν';

  @override
  String get matchSetupWarnBoth =>
      'Ούτε αρχηγός ούτε εκτελεστές στατικών φάσεων. Πάτα για να τους ορίσεις';

  @override
  String matchStageMatchday(int matchday) {
    return 'ΑΓ $matchday';
  }

  @override
  String get squadCaptain => 'Αρχηγός';

  @override
  String deptEffectYouth(int points) {
    return 'Τα ταλέντα της ακαδημίας έρχονται με περίπου +$points στο γενικό επίπεδο';
  }

  @override
  String deptEffectCommercial(String amount) {
    return '$amount επιστρέφουν στο τέλος του κύκλου';
  }

  @override
  String deptEffectMedical(int percent) {
    return '$percent% λιγότεροι τραυματισμοί';
  }

  @override
  String deptEffectNaturalisation(int percent) {
    return '$percent% πιθανότητα να ζητήσει αλλαγή εθνικότητας ένας ξένος παίκτης';
  }

  @override
  String deptEffectBoard(int points) {
    return '+$points υπομονή της διοίκησης πριν κινδυνεύσει η θέση σου';
  }

  @override
  String get deptEffectNone => 'Καμία επίδραση χωρίς χρηματοδότηση';

  @override
  String get statsBestRated => 'Βαθμολογίες';

  @override
  String get statsMyCareer => 'Καριέρα';

  @override
  String get statsBestAverageRating => 'ΚΑΛΥΤΕΡΗ ΜΕΣΗ ΒΑΘΜΟΛΟΓΙΑ';

  @override
  String get statsMyCareerRecord => 'ΤΟ ΙΣΤΟΡΙΚΟ ΣΟΥ';

  @override
  String get statsNoRatingsRecorded =>
      'Δεν έχουν καταγραφεί βαθμολογίες αγώνων ακόμα.';

  @override
  String get statsGroupRecord => 'Απολογισμός';

  @override
  String get statsGroupRuns => 'Σερί';

  @override
  String get statsGroupExtremes => 'Άκρα';

  @override
  String get statsGroupSplits => 'Εντός & εκτός';

  @override
  String get statsGroupSquad => 'Οι παίκτες σου';

  @override
  String get statsPlayed => 'Αγώνες';

  @override
  String get statsWinDrawLoss => 'Νίκες–ισοπαλίες–ήττες';

  @override
  String get statsWinRate => 'Ποσοστό νικών';

  @override
  String get statsGoals => 'Γκολ υπέρ:κατά';

  @override
  String get statsCleanSheets => 'Μηδέν παθητικό';

  @override
  String get statsFailedToScore => 'Αγώνες χωρίς γκολ';

  @override
  String get statsLongestWinStreak => 'Μεγαλύτερο σερί νικών';

  @override
  String get statsLongestUnbeaten => 'Μεγαλύτερο αήττητο σερί';

  @override
  String get statsLongestCleanSheets => 'Μεγαλύτερο σερί με μηδέν παθητικό';

  @override
  String get statsLongestWinless => 'Μεγαλύτερο σερί χωρίς νίκη';

  @override
  String get statsCurrentRun => 'Τρέχον αήττητο σερί';

  @override
  String get statsBiggestWin => 'Μεγαλύτερη νίκη';

  @override
  String get statsHeaviestDefeat => 'Βαρύτερη ήττα';

  @override
  String get statsMostGoalsInAGame => 'Περισσότερα γκολ σε αγώνα';

  @override
  String get statsShootouts => 'Πέναλτι: νίκες–ήττες';

  @override
  String get statsComebackWins => 'Νίκες με ανατροπή';

  @override
  String get statsHome => 'Εντός';

  @override
  String get statsAway => 'Εκτός';

  @override
  String get statsNeutral => 'Ουδέτερο';

  @override
  String get statsCompetitive => 'Επίσημοι';

  @override
  String get statsFriendlies => 'Φιλικά';

  @override
  String get statsHatTricks => 'Χατ-τρικ';

  @override
  String get statsBraces => 'Ντουμπλέτες';

  @override
  String get statsMotms => 'Βραβεία παίκτη αγώνα';

  @override
  String get statsAssists => 'Ασίστ';

  @override
  String get statsCards => 'Κάρτες';

  @override
  String get statsBestRating => 'Καλύτερη ατομική βαθμολογία';

  @override
  String statsAppsShort(int apps) {
    return '$apps συμμ.';
  }

  @override
  String statsMotmShort(int motms) {
    return '$motms MVP';
  }

  @override
  String get captainArmband => 'Α';

  @override
  String get captainCurrent =>
      'Αρχηγός. Πάτα για να αφαιρέσεις το περιβραχιόνιο';

  @override
  String get captainFitBorn => 'Γεννημένος ηγέτης';

  @override
  String get captainFitNatural => 'Φυσικός αρχηγός';

  @override
  String get captainFitCapable => 'Μπορεί να το φορέσει';

  @override
  String get captainFitUnproven => 'Δεν είναι ακόμα ηγέτης';

  @override
  String get captainNone => 'Δεν ορίστηκε αρχηγός';

  @override
  String captainMoraleBoost(int morale) {
    return '+$morale ηθικό της ομάδας';
  }

  @override
  String get resultsCategoryWorldCupQualifying =>
      'Προκριματικά Παγκοσμίου Πρωταθλήματος';

  @override
  String get resultsCategoryFriendlies => 'Φιλικά';

  @override
  String get resultsCategoryContinentalClash => 'Ηπειρωτική Αναμέτρηση';

  @override
  String get resultsCategoryNationsCup => 'Κύπελλο Εθνών';

  @override
  String get resultsCategoryContinentalCup => 'Ηπειρωτικό Κύπελλο';

  @override
  String get resultsCategoryWorldCupQualifyingShort => 'Προκρ. Παγκοσμίου';

  @override
  String get resultsCategoryContinentalQualifyingShort => 'Προκρ. Ηπειρωτικού';

  @override
  String get resultsCategoryContinentalQualifying =>
      'Προκριματικά Ηπειρωτικού Κυπέλλου';

  @override
  String get resultsCategoryWorldCupFinals =>
      'Τελική Φάση Παγκοσμίου Πρωταθλήματος';

  @override
  String get resultsRoundResults => 'ΑΠΟΤΕΛΕΣΜΑΤΑ ΓΥΡΟΥ';

  @override
  String get resultsFriendlyInternationals => 'ΔΙΕΘΝΗ ΦΙΛΙΚΑ';

  @override
  String get resultsKnockout => 'Νοκ άουτ';

  @override
  String resultsEarlierMatches(int count) {
    return 'Προηγούμενοι αγώνες ($count)';
  }

  @override
  String resultsMatchday(int matchday) {
    return 'ΑΓΩΝΙΣΤΙΚΗ $matchday';
  }

  @override
  String get resultsContinue => 'Συνέχεια';

  @override
  String resultsGroup(String name) {
    return 'ΟΜΙΛΟΣ $name';
  }

  @override
  String get achievementsScreenTitle => 'ΕΠΙΤΕΥΓΜΑΤΑ';

  @override
  String get achievementsChallengesTooltip => 'Προκλήσεις';

  @override
  String get achievementsChallengesHeading => 'ΠΡΟΚΛΗΣΕΙΣ';

  @override
  String get achievementsBrutalTests =>
      'Σκληρές δοκιμασίες μιας ολόκληρης καριέρας';

  @override
  String achievementsCouldNotLoad(String error) {
    return 'Δεν φορτώθηκε.\n$error';
  }

  @override
  String achievementsUnlockedCount(int earned, int total) {
    return '$earned / $total ξεκλειδωμένα';
  }

  @override
  String achievementsConqueredCount(int done, int total) {
    return '$done / $total κατακτημένες';
  }

  @override
  String get achievementsBoardSatisfaction => 'ΙΚΑΝΟΠΟΙΗΣΗ ΔΙΟΙΚΗΣΗΣ';

  @override
  String achievementsUnlockedBanner(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ΞΕΚΛΕΙΔΩΘΗΚΑΝ $count ΕΠΙΤΕΥΓΜΑΤΑ',
      one: 'ΞΕΚΛΕΙΔΩΘΗΚΕ ΕΠΙΤΕΥΓΜΑ',
    );
    return '$_temp0';
  }

  @override
  String get achCatWins => 'Νίκες';

  @override
  String get achCatMatches => 'Αγώνες';

  @override
  String get achCatQualifications => 'Προκρίσεις';

  @override
  String get achCatTitles => 'Τίτλοι';

  @override
  String get achCatMisc => 'Διάφορα';

  @override
  String get achCatMega => 'Μέγα';

  @override
  String get achCatGoals => 'Γκολ';

  @override
  String get achCatStreaks => 'Σερί';

  @override
  String get achTierBronze => 'Χάλκινο';

  @override
  String get achTierSilver => 'Ασημένιο';

  @override
  String get achTierGold => 'Χρυσό';

  @override
  String get achTierPlatinum => 'Πλατινένιο';

  @override
  String achGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Γκολ',
    );
    return '$_temp0';
  }

  @override
  String achGoalsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Σκόραρε $count γκολ.',
      one: 'Σκόραρε 1 γκολ.',
    );
    return '$_temp0';
  }

  @override
  String achCleanSheets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Ανέπαφες εστίες',
    );
    return '$_temp0';
  }

  @override
  String achCleanSheetsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Κράτα $count ανέπαφες εστίες.',
      one: 'Κράτα 1 ανέπαφη εστία.',
    );
    return '$_temp0';
  }

  @override
  String get achStreakWin5 => 'Συνήθεια νίκης';

  @override
  String get achStreakWin5Desc => 'Κέρδισε πέντε αγώνες στη σειρά.';

  @override
  String get achStreakWin10 => 'Σε φόρμα';

  @override
  String get achStreakWin10Desc => 'Κέρδισε δέκα αγώνες στη σειρά.';

  @override
  String get achStreakWin20 => 'Οδοστρωτήρας';

  @override
  String get achStreakWin20Desc => 'Κέρδισε είκοσι αγώνες στη σειρά.';

  @override
  String get achUnbeaten15 => 'Δύσκολος να νικηθεί';

  @override
  String get achUnbeaten15Desc => 'Μείνε αήττητος για δεκαπέντε αγώνες.';

  @override
  String get achUnbeaten30 => 'Άπιαστος';

  @override
  String get achUnbeaten30Desc => 'Μείνε αήττητος για τριάντα αγώνες.';

  @override
  String get achHattrick => 'Ήρωας του χατ-τρικ';

  @override
  String get achHattrickDesc => 'Κάνε έναν παίκτη να σκοράρει χατ-τρικ.';

  @override
  String get achMotm10 => 'Ξεχωριστός';

  @override
  String get achMotm10Desc => 'Μάζεψε 10 βραβεία παίκτη αγώνα.';

  @override
  String get achMotm50 => 'Φυλαχτό';

  @override
  String get achMotm50Desc => 'Μάζεψε 50 βραβεία παίκτη αγώνα.';

  @override
  String get achPerfect => 'Τέλειο δέκα';

  @override
  String get achPerfectDesc =>
      'Κάνε έναν παίκτη να πάρει βαθμολογία 9,5+ σε αγώνα.';

  @override
  String get achShootout => 'Παγωμένο αίμα';

  @override
  String get achShootoutDesc => 'Κέρδισε πέντε διαδικασίες πέναλτι.';

  @override
  String get achMassacre => 'Μακελειό';

  @override
  String get achMassacreDesc =>
      'Κέρδισε έναν αγώνα με 7 γκολ διαφορά ή περισσότερα.';

  @override
  String get achAnnihilation => 'Εξόντωση';

  @override
  String get achAnnihilationDesc =>
      'Κέρδισε έναν αγώνα με 10 γκολ διαφορά ή περισσότερα.';

  @override
  String get chTierBronze => 'Χάλκινο';

  @override
  String get chTierSilver => 'Ασημένιο';

  @override
  String get chTierGold => 'Χρυσό';

  @override
  String get chTierLegendary => 'Θρυλικό';

  @override
  String get chFirstSteps => 'Στον πάγκο';

  @override
  String get chFirstStepsDesc => 'Προπόνησε για 5 χρόνια.';

  @override
  String get chUnbeaten10 => 'Σε φόρμα';

  @override
  String get chUnbeaten10Desc => 'Μείνε αήττητος για 10 επίσημους αγώνες.';

  @override
  String get chTwoNations => 'Νέα πρόκληση';

  @override
  String get chTwoNationsDesc => 'Προπόνησε 2 διαφορετικές εθνικές.';

  @override
  String get chCont1 => 'Ηπειρωτικός πρωταθλητής';

  @override
  String get chCont1Desc => 'Κέρδισε ένα ηπειρωτικό πρωτάθλημα.';

  @override
  String get chNc1 => 'Νικητής Κυπέλλου Εθνών';

  @override
  String get chNc1Desc => 'Κέρδισε το Κύπελλο Εθνών.';

  @override
  String get chWc1 => 'Παγκόσμιος πρωταθλητής';

  @override
  String get chWc1Desc => 'Κέρδισε το Παγκόσμιο Πρωτάθλημα.';

  @override
  String get chYears25 => 'Θεσμός';

  @override
  String get chYears25Desc => 'Προπόνησε για 25 χρόνια.';

  @override
  String get chWc3 => 'Αδιάκοπος νικητής';

  @override
  String get chWc3Desc => 'Κέρδισε 3 Παγκόσμια Πρωταθλήματα.';

  @override
  String get chWc5 => 'Δυναστεία';

  @override
  String get chWc5Desc => 'Κέρδισε 5 Παγκόσμια Πρωταθλήματα.';

  @override
  String get chWc10 => 'Αθάνατος';

  @override
  String get chWc10Desc => 'Κέρδισε 10 Παγκόσμια Πρωταθλήματα.';

  @override
  String get chWc2Teams => 'Ταξιδιώτης προπονητής';

  @override
  String get chWc2TeamsDesc =>
      'Κέρδισε το Παγκόσμιο Πρωτάθλημα με 2 διαφορετικές εθνικές.';

  @override
  String get chWc3Teams => 'Παγκόσμιος περιηγητής';

  @override
  String get chWc3TeamsDesc =>
      'Κέρδισε το Παγκόσμιο Πρωτάθλημα με 3 διαφορετικές εθνικές.';

  @override
  String get chWcStreak3 => 'Τρία στη σειρά';

  @override
  String get chWcStreak3Desc => 'Κέρδισε 3 Παγκόσμια Πρωταθλήματα στη σειρά.';

  @override
  String get chWcAllconf => 'Κατακτητής του κόσμου';

  @override
  String get chWcAllconfDesc =>
      'Κέρδισε το Παγκόσμιο Πρωτάθλημα με εθνική από κάθε συνομοσπονδία (6).';

  @override
  String get chCont5 => 'Βασιλιάς της ηπείρου';

  @override
  String get chCont5Desc => 'Κέρδισε 5 ηπειρωτικά πρωταθλήματα.';

  @override
  String get chContAll => 'Γκραν Σλαμ έξι ηπείρων';

  @override
  String get chContAllDesc =>
      'Κέρδισε το ηπειρωτικό πρωτάθλημα κάθε συνομοσπονδίας (6).';

  @override
  String get chTreble => 'Σάρωση';

  @override
  String get chTrebleDesc =>
      'Κέρδισε το Παγκόσμιο Πρωτάθλημα, έναν ηπειρωτικό τίτλο και το Κύπελλο Εθνών στην ίδια καριέρα.';

  @override
  String get chNations10 => 'Νομάδας';

  @override
  String get chNations10Desc => 'Προπόνησε 10 διαφορετικές εθνικές.';

  @override
  String get chYears100 => 'Εκατονταετία';

  @override
  String get chYears100Desc => 'Προπόνησε για 100 χρόνια.';

  @override
  String get chYears500 => 'Μισή χιλιετία';

  @override
  String get chYears500Desc => 'Προπόνησε για 500 χρόνια.';

  @override
  String get chYears1000 => 'Αιώνιος';

  @override
  String get chYears1000Desc => 'Προπόνησε για 1000 χρόνια.';

  @override
  String get chGrandmaster => 'Μεγάλος Μάστορας';

  @override
  String get chGrandmasterDesc =>
      'Κέρδισε 3 Παγκόσμια Πρωταθλήματα ΚΑΙ 5 ηπειρωτικά πρωταθλήματα.';

  @override
  String get chUndefeated => 'Άπιαστος';

  @override
  String get chUndefeatedDesc =>
      'Κέρδισε Παγκόσμιο Πρωτάθλημα χωρίς να χάσεις ούτε έναν αγώνα.';

  @override
  String get chPerfectQual => 'Άψογη πορεία';

  @override
  String get chPerfectQualDesc =>
      'Κέρδισε κάθε αγώνα μιας προκριματικής εκστρατείας του Παγκοσμίου Πρωταθλήματος.';

  @override
  String get chMinnow => 'Θαύμα των μικρών';

  @override
  String get chMinnowDesc =>
      'Κέρδισε το Παγκόσμιο Πρωτάθλημα με εθνική εκτός των 32 πρώτων της παγκόσμιας κατάταξης.';

  @override
  String get chGrandTour => 'Εντός κι εκτός';

  @override
  String get chGrandTourDesc =>
      'Κέρδισε Παγκόσμιο Πρωτάθλημα ως οικοδεσπότης και ένα εκτός έδρας.';

  @override
  String get chUnbeaten25 => 'Το Τείχος';

  @override
  String get chUnbeaten25Desc => 'Μείνε αήττητος για 25 επίσημους αγώνες.';

  @override
  String get chGoals10k => 'Γκολ-μηχανή';

  @override
  String get chGoals10kDesc => 'Σκόραρε 10.000 γκολ στην καριέρα σου.';

  @override
  String get chCleanSheets500 => 'Φρούριο';

  @override
  String get chCleanSheets500Desc =>
      'Κράτα 500 ανέπαφες εστίες στην καριέρα σου.';

  @override
  String get chHatTricks25 => 'Συνήθεια χατ-τρικ';

  @override
  String get chHatTricks25Desc =>
      'Κάνε τους παίκτες σου να σκοράρουν 25 χατ-τρικ.';

  @override
  String get chWinStreak25 => 'Ασταμάτητος';

  @override
  String get chWinStreak25Desc => 'Κέρδισε 25 αγώνες στη σειρά.';

  @override
  String get chCont10 => 'Ηπειρωτική δυναστεία';

  @override
  String get chCont10Desc => 'Κέρδισε 10 ηπειρωτικά πρωταθλήματα.';

  @override
  String get chPcWc => 'Πολλαπλός πρωταθλητής';

  @override
  String chPcWcDesc(int count) {
    return 'Κέρδισε $count Παγκόσμια Πρωταθλήματα σε αυτή την αποθήκευση.';
  }

  @override
  String get chPcMajors => 'Συλλέκτης τροπαίων';

  @override
  String chPcMajorsDesc(int count) {
    return 'Κέρδισε $count μεγάλα τρόπαια (Παγκόσμιο Πρωτάθλημα, ηπειρωτικό ή Κύπελλο Εθνών).';
  }

  @override
  String get chPcUnbeaten => 'Σιδερένιο τείχος';

  @override
  String chPcUnbeatenDesc(int count) {
    return 'Μείνε αήττητος για $count επίσημους αγώνες.';
  }

  @override
  String get chPcNations => 'Περιπλανώμενος';

  @override
  String chPcNationsDesc(int count) {
    return 'Προπόνησε $count διαφορετικές εθνικές.';
  }

  @override
  String get chPcYears => 'Μακρύς δρόμος';

  @override
  String chPcYearsDesc(int count) {
    return 'Προπόνησε για $count χρόνια.';
  }

  @override
  String achWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Νίκες',
      one: '1 Νίκη',
    );
    return '$_temp0';
  }

  @override
  String achWinsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Κέρδισε $count αγώνες.',
      one: 'Κέρδισε 1 αγώνα.',
    );
    return '$_temp0';
  }

  @override
  String achMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Αγώνες',
    );
    return '$_temp0';
  }

  @override
  String achMatchesDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Παίξε $count αγώνες.',
      one: 'Παίξε 1 αγώνα.',
    );
    return '$_temp0';
  }

  @override
  String get achQualWc => 'Πρόκριση στο Παγκόσμιο';

  @override
  String get achQualWcDesc => 'Πρόκριση στο Παγκόσμιο Πρωτάθλημα.';

  @override
  String get achQualCont => 'Πρόκριση στο ηπειρωτικό';

  @override
  String get achQualContDesc => 'Πρόκριση στο ηπειρωτικό σου πρωτάθλημα.';

  @override
  String get achTitleWc => 'Παγκόσμιοι Πρωταθλητές';

  @override
  String get achTitleWcDesc => 'Κέρδισε το Παγκόσμιο Πρωτάθλημα.';

  @override
  String get achTitleEuro => 'Ευρωπαίοι Πρωταθλητές';

  @override
  String get achTitleEuroDesc => 'Κέρδισε το Ευρωπαϊκό Πρωτάθλημα.';

  @override
  String get achTitleCopa => 'Πρωταθλητές Νότιας Αμερικής';

  @override
  String get achTitleCopaDesc => 'Κέρδισε το Κύπελλο Νότιας Αμερικής.';

  @override
  String get achTitleAfcon => 'Πρωταθλητές Αφρικής';

  @override
  String get achTitleAfconDesc => 'Κέρδισε το Πρωτάθλημα Αφρικής.';

  @override
  String get achTitleAsia => 'Πρωταθλητές Ασίας';

  @override
  String get achTitleAsiaDesc => 'Κέρδισε το Πρωτάθλημα Ασίας.';

  @override
  String get achTitleConcacaf => 'Πρωταθλητές Βόρειας Αμερικής';

  @override
  String get achTitleConcacafDesc => 'Κέρδισε το Κύπελλο Βόρειας Αμερικής.';

  @override
  String get achTitleOfc => 'Πρωταθλητές Ωκεανίας';

  @override
  String get achTitleOfcDesc => 'Κέρδισε το Κύπελλο Ωκεανίας.';

  @override
  String get achTitleNations => 'Νικητές Κυπέλλου Εθνών';

  @override
  String get achTitleNationsDesc => 'Κέρδισε το Κύπελλο Εθνών.';

  @override
  String get achTitleClash => 'Νικητές Ηπειρωτικής Αναμέτρησης';

  @override
  String get achTitleClashDesc => 'Κέρδισε την Ηπειρωτική Αναμέτρηση.';

  @override
  String get achMarksman => 'Σκόρερ του Παγκοσμίου';

  @override
  String get achMarksmanDesc =>
      'Κάνε έναν παίκτη της αποστολής να σκοράρει 6+ γκολ στην τελική φάση του Παγκοσμίου Πρωταθλήματος.';

  @override
  String get achSweep => 'Σάρωση';

  @override
  String get achSweepDesc =>
      'Κατάκτησε το Παγκόσμιο Πρωτάθλημα και τον ηπειρωτικό τίτλο στην ίδια καριέρα.';

  @override
  String get achAllstar => 'Ομάδα του Τουρνουά';

  @override
  String get achAllstarDesc =>
      'Κάνε έναν παίκτη να ονομαστεί στην Ομάδα του Τουρνουά ενός Παγκοσμίου Πρωταθλήματος.';

  @override
  String get achGoldenboot => 'Χρυσή Μπότα';

  @override
  String get achGoldenbootDesc =>
      'Κάνε την εθνική σου να βγάλει πρώτο σκόρερ ενός πρωταθλήματος.';

  @override
  String get achDemolition => 'Κατεδάφιση';

  @override
  String get achDemolitionDesc =>
      'Κέρδισε έναν αγώνα με 5 γκολ διαφορά ή περισσότερα.';

  @override
  String get achievementsNice => 'Ωραία!';

  @override
  String get achievementsHardestTests =>
      'Οι πιο δύσκολες δοκιμασίες ενός προπονητή, σε μια ολόκληρη καριέρα και με πολλές εθνικές.';

  @override
  String get achievementsThisSave => 'ΑΥΤΗ Η ΑΠΟΘΗΚΕΥΣΗ';

  @override
  String get achievementsBrutalBadge => 'ΣΚΛΗΡΗ';

  @override
  String get paywallGoPro => 'ΠΕΡΝΑ ΣΤΟ ΑΠΕΡΙΟΡΙΣΤΟ';

  @override
  String get paywallOneTimeUnlock => 'Εφάπαξ ξεκλείδωμα. Χωρίς συνδρομή.';

  @override
  String get paywallBenefitCarryOn =>
      'Αυτή η αποθήκευση συνεχίζεται ακριβώς από εκεί που σταμάτησε, με κάθε συμμετοχή, ρεκόρ και αντιπαλότητα άθικτα.';

  @override
  String get paywallBenefitNoAds =>
      'Χωρίς διαφημίσεις, χωρίς μικροσυναλλαγές, χωρίς συνδρομή. Μία πληρωμή και κάθε μελλοντική ενημέρωση είναι δική σου.';

  @override
  String get paywallBenefitSaves =>
      'Όσες αποθηκεύσεις θες. Τρέξε έναν φαβορί και έναν αουτσάιντερ ταυτόχρονα και δες πόσο διαφορετικά διαβάζεται το ίδιο παιχνίδι.';

  @override
  String get paywallBenefitEndless =>
      'Κάθε κύκλος από εδώ και πέρα. Διάλεξε σήμερα έναν δεκαεπτάχρονο και μάθε το 2034 αν είχες δίκιο.';

  @override
  String get paywallUnlocked =>
      'Το Απεριόριστο έχει ξεκλειδωθεί. Καλή διασκέδαση!';

  @override
  String get paywallContactingStore => 'Επικοινωνία με το κατάστημα…';

  @override
  String paywallUnlockProPriced(String price) {
    return 'Ξεκλείδωμα Απεριόριστου · $price';
  }

  @override
  String get paywallRestorePurchases => 'Επαναφορά αγορών';

  @override
  String get paywallStoreUnavailable => 'Το κατάστημα δεν είναι διαθέσιμο';

  @override
  String get paywallStoreUnavailableNote =>
      'Δεν φορτώθηκε η τιμή. Έλεγξε τη σύνδεσή σου και δοκίμασε ξανά.';

  @override
  String get paywallTryAgain => 'Δοκίμασε ξανά';

  @override
  String get gateTitle => 'Ο ΠΡΩΤΟΣ ΣΟΥ ΚΥΚΛΟΣ ΤΕΛΕΙΩΣΕ';

  @override
  String get gateLead =>
      'Τέσσερα χρόνια είναι ένας κύκλος. Δεν φτάνουν για να μάθεις αν είχες δίκιο.';

  @override
  String get gatePriceLead => 'Μία πληρωμή, για πάντα';

  @override
  String get gateBuy => 'ΑΓΟΡΑ ΚΑΙ ΣΥΝΕΧΕΙΑ';

  @override
  String get gateExit => 'ΕΞΟΔΟΣ';

  @override
  String get gateSaveTitle => 'ΑΥΤΗ Η ΑΠΟΘΗΚΕΥΣΗ ΘΕΛΕΙ PRO';

  @override
  String get gateSaveLead =>
      'Οι αποθηκεύσεις μετά τον δωρεάν κύκλο και οι εκστρατείες Pro συνεχίζουν με Pro. Τίποτα δεν χάνεται: η αποθήκευση σε περιμένει όπως ακριβώς την άφησες.';

  @override
  String get careerSaveLockedNote =>
      'Χρειάζεσαι Pro για να συνεχίσεις αυτή την αποθήκευση';

  @override
  String get federationNaturalisation => 'ΠΟΛΙΤΟΓΡΑΦΗΣΗ';

  @override
  String federationNaturalisedTitle(String name) {
    return 'Πολιτογραφήθηκε: $name';
  }

  @override
  String federationNaturalisedBody(String name, String nation) {
    return 'Ο παίκτης $name ολοκλήρωσε την αλλαγή και μπορεί πλέον να επιλεγεί (εθνική: $nation). Κάλεσέ τον από την επιλογή αποστολής.';
  }

  @override
  String federationCouldNotLoadOffer(String error) {
    return 'Δεν φορτώθηκε η προσφορά.\n$error';
  }

  @override
  String get federationContinue => 'Συνέχεια';

  @override
  String get federationOfferToSwitchAllegiance =>
      'ΠΡΟΣΦΟΡΑ ΑΛΛΑΓΗΣ ΕΘΝΙΚΟΤΗΤΑΣ';

  @override
  String federationPlayerMeta(String position, int age, String nation) {
    return '$position · ηλικία $age · από: $nation';
  }

  @override
  String federationNaturalisationBlurb(
    String name,
    String playerNation,
    String sourceNation,
  ) {
    return 'Ο παίκτης $name είναι διατεθειμένος να πολιτογραφηθεί (δεσμός με: $playerNation). Αν δεχτείς, μπορεί να επιλεγεί· αν αρνηθείς, μένει στην εθνική: $sourceNation.';
  }

  @override
  String get federationDecline => 'Απόρριψη';

  @override
  String get federationNaturalise => 'Πολιτογράφηση';

  @override
  String get federationBudgetLater => 'Αποφάσισε αργότερα';

  @override
  String get federationSetYourBudget => 'ΟΡΙΣΕ ΤΟΝ ΠΡΟΫΠΟΛΟΓΙΣΜΟ';

  @override
  String federationCouldNotLoadFinances(String error) {
    return 'Δεν φορτώθηκαν τα οικονομικά.\n$error';
  }

  @override
  String get federationSaveNotFound => 'Η αποθήκευση δεν βρέθηκε.';

  @override
  String get federationBudgetHeading => 'ΠΡΟΫΠΟΛΟΓΙΣΜΟΣ ΟΜΟΣΠΟΝΔΙΑΣ';

  @override
  String federationDistributeBudget(String amount) {
    return 'Μοίρασε $amount στα τμήματα για να ανοίξει ο κύκλος. Ξόδεψέ τα με σύνεση.';
  }

  @override
  String federationOverBudget(String amount) {
    return '$amount περισσότερα από όσα έχει η ομοσπονδία. Πάρε πίσω λίγα';
  }

  @override
  String get federationAllocateFullBudget =>
      'Μοίρασε ολόκληρο τον προϋπολογισμό για να ξεκινήσει ο κύκλος.';

  @override
  String get federationConfirming => 'Επιβεβαίωση…';

  @override
  String get federationConfirmBudget => 'Επιβεβαίωση προϋπολογισμού';

  @override
  String get federationFinances => 'ΟΙΚΟΝΟΜΙΚΑ';

  @override
  String get federationInvestmentUpdated => 'Η επένδυση ενημερώθηκε.';

  @override
  String get federationDevelopment => 'ΑΝΑΠΤΥΞΗ ΟΜΟΣΠΟΝΔΙΑΣ';

  @override
  String get federationProjectedAtSeasonEnd =>
      'ΠΡΟΒΛΕΨΗ ΓΙΑ ΤΟ ΤΕΛΟΣ ΤΗΣ ΣΕΖΟΝ';

  @override
  String get federationCentralFunding => 'Κεντρική χρηματοδότηση';

  @override
  String get federationPrizeMoneySoFar => 'Έπαθλα μέχρι τώρα';

  @override
  String get federationCommercialReturn => 'Εμπορικά έσοδα';

  @override
  String get federationThisSeasonLocked => 'ΑΥΤΗ Η ΣΕΖΟΝ (ΚΛΕΙΔΩΜΕΝΗ)';

  @override
  String get federationInvestForNextSeason => 'ΕΠΕΝΔΥΣΗ ΓΙΑ ΤΗΝ ΕΠΟΜΕΝΗ ΣΕΖΟΝ';

  @override
  String get federationNextSeasonImpact => 'ΕΠΙΠΤΩΣΗ ΣΤΗΝ ΕΠΟΜΕΝΗ ΣΕΖΟΝ';

  @override
  String get federationSaving => 'Αποθήκευση…';

  @override
  String get federationConfirmInvestment => 'Επιβεβαίωση επένδυσης';

  @override
  String get federationBalance => 'ΥΠΟΛΟΙΠΟ ΟΜΟΣΠΟΝΔΙΑΣ';

  @override
  String get federationCommittedToStaff => 'Δεσμευμένα για το επιτελείο';

  @override
  String get federationFreeToSpend => 'Διαθέσιμα προς χρήση';

  @override
  String get federationWagesNote =>
      'Οι μισθοί αφαιρούνται από το υπόλοιπο στο τέλος του κύκλου, οπότε αυτό το ποσό είναι ήδη δεσμευμένο.';

  @override
  String get federationInvestAtCeremony =>
      'Επένδυσε για την επόμενη σεζόν στην τελετή του τέλους του κύκλου.';

  @override
  String federationLevelBadge(int level) {
    return 'Ε$level';
  }

  @override
  String get federationAcademyProspects => 'Ταλέντα ακαδημίας';

  @override
  String federationPlusOverall(int value) {
    return '+$value γενικό επίπεδο';
  }

  @override
  String get federationInjuryRisk => 'Κίνδυνος τραυματισμού';

  @override
  String get federationNaturalisationChance => 'Πιθανότητα πολιτογράφησης';

  @override
  String get federationBoardPatience => 'Υπομονή της διοίκησης';

  @override
  String get federationUnallocated => 'ΑΔΙΑΝΕΜΗΤΑ';

  @override
  String get nationsVitrineTitle => 'ΕΘΝΙΚΗ ΒΙΤΡΙΝΑ';

  @override
  String nationsCouldNotLoad(String error) {
    return 'Δεν φορτώθηκε η χώρα.\n$error';
  }

  @override
  String get nationsNoNation => 'Καμία χώρα.';

  @override
  String get nationsHonours => 'ΤΙΤΛΟΙ';

  @override
  String get nationsRankingHistory => 'ΙΣΤΟΡΙΚΟ ΠΑΓΚΟΣΜΙΑΣ ΚΑΤΑΤΑΞΗΣ';

  @override
  String get nationsTopScorers => 'ΚΟΡΥΦΑΙΟΙ ΣΚΟΡΕΡ ΟΛΩΝ ΤΩΝ ΕΠΟΧΩΝ';

  @override
  String get nationsTitles => 'ΤΙΤΛΟΙ';

  @override
  String get nationsYourTeam => 'Η ΟΜΑΔΑ ΣΟΥ';

  @override
  String get nationsWorld => 'ΚΟΣΜΟΣ';

  @override
  String get nationsWorldCup => 'Παγκόσμιο Πρωτάθλημα';

  @override
  String get nationsContinental => 'Ηπειρωτικό';

  @override
  String nationsAppearances(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count συμμετοχές',
      one: '1 συμμετοχή',
    );
    return '$_temp0';
  }

  @override
  String get nationsNotEnoughHistory =>
      'Δεν υπάρχει αρκετό ιστορικό ακόμα. Έλα ξανά μετά από έναν-δύο κύκλους.';

  @override
  String nationsBestRank(int rank) {
    return 'Καλύτερη: #$rank';
  }

  @override
  String nationsNowRank(int rank) {
    return 'Τώρα: #$rank';
  }

  @override
  String get nationsNoGoals => 'Δεν έχουν καταγραφεί γκολ ακόμα.';

  @override
  String get nationsGoalsAbbrev => 'γκολ';

  @override
  String get nationsHosts => 'ΟΙΚΟΔΕΣΠΟΤΗΣ';

  @override
  String get nationsSelectTitle => 'ΕΠΙΛΟΓΗ ΕΘΝΙΚΗΣ ΟΜΑΔΑΣ';

  @override
  String nationsCouldNotLoadNations(String error) {
    return 'Δεν φορτώθηκαν οι χώρες.\n$error';
  }

  @override
  String get nationsNoMatch => 'Καμία χώρα δεν ταιριάζει.';

  @override
  String get nationsSelectHeading => 'Επιλογή εθνικής ομάδας';

  @override
  String get nationsSearchHint => 'Αναζήτηση χώρας…';

  @override
  String get nationsRank => 'ΘΕΣΗ ';

  @override
  String get nationsPremium => 'PREMIUM';

  @override
  String get nationsSelect => 'ΕΠΙΛΟΓΗ';

  @override
  String get statsTeamRecords => 'ΡΕΚΟΡ ΟΜΑΔΑΣ';

  @override
  String get statsRecordBook => 'Βιβλίο ρεκόρ';

  @override
  String statsCouldNotLoadStats(String error) {
    return 'Δεν φορτώθηκαν τα στατιστικά.\n$error';
  }

  @override
  String get statsNoData => 'Δεν υπάρχουν δεδομένα.';

  @override
  String get statsTopScorers => 'ΚΟΡΥΦΑΙΟΙ ΣΚΟΡΕΡ';

  @override
  String get statsMostGamesPlayed => 'ΠΕΡΙΣΣΟΤΕΡΟΙ ΑΓΩΝΕΣ';

  @override
  String get statsTeam => 'Ομάδα';

  @override
  String get statsTopScorersShort => 'Σκόρερ';

  @override
  String get statsMostGames => 'Αγώνες';

  @override
  String get statsNoGoalsRecorded => 'Δεν έχουν καταγραφεί γκολ ακόμα.';

  @override
  String get statsUnknown => 'Άγνωστος';

  @override
  String get playerTitle => 'ΠΑΙΚΤΗΣ';

  @override
  String playerLoadError(String error) {
    return 'Δεν φορτώθηκε ο παίκτης.\n$error';
  }

  @override
  String get playerNotFound => 'Ο παίκτης δεν βρέθηκε.';

  @override
  String get playerClub => 'ΣΥΛΛΟΓΟΣ';

  @override
  String get playerClubRole => 'Στον σύλλογό του';

  @override
  String get playerPosition => 'Θέση';

  @override
  String get playerPotential => 'Δυναμικό';

  @override
  String get playerAge => 'Ηλικία';

  @override
  String get playerValue => 'Αξία';

  @override
  String get clubFirstChoice => 'Παίζει κάθε εβδομάδα';

  @override
  String get clubRotation => 'Μπαίνει και βγαίνει';

  @override
  String get clubFringe => 'Σπάνια παίζει';

  @override
  String get clubFrozenOut => 'Δεν παίζει';

  @override
  String clubAtClub(String club, String standing) {
    return '$club: $standing';
  }

  @override
  String yWinUpset0(String opponent, String score) {
    return 'Βλέπω ποδόσφαιρο εδώ και τριάντα χρόνια και δεν το περίμενα. $opponent, $score, νικημένοι.';
  }

  @override
  String yWinUpset1(String opponent, String score) {
    return 'Κανείς δεν τους έδινε ελπίδα. $opponent, $score. Κυριολεκτικά κανείς.';
  }

  @override
  String yWinUpset2(String opponent, String score) {
    return '$opponent, $score. Πάμε να ξυπνήσουμε τη γειτονιά.';
  }

  @override
  String yWinUpset3(String opponent, String score) {
    return 'Τέτοια βράδια τα διηγείσαι στα εγγόνια σου. $opponent $score.';
  }

  @override
  String yWinUpset4(String opponent, String score) {
    return '$opponent, $score. Όπως κι αν έγινε, έγινε.';
  }

  @override
  String yWinUpset5(String opponent, String score) {
    return 'Στα χαρτιά, ο αγώνας είχε τελειώσει πριν αρχίσει. Το $opponent $score λέει άλλα.';
  }

  @override
  String yWinUpset6(String opponent, String score) {
    return 'Νίκη επί του αντιπάλου: $opponent, $score. Σε έναν χρόνο κανείς δεν θα πιστεύει αυτό το σκορ.';
  }

  @override
  String yWinUpset7(String opponent, String score) {
    return '$opponent $score. Απόλαυσέ το και μετά κοίτα το πρόγραμμα.';
  }

  @override
  String yWinUpset8(String opponent, String score) {
    return '$opponent, $score, και τα καταφέραμε με τύχη για τα ογδόντα από τα ενενήντα λεπτά.';
  }

  @override
  String yWinUpset9(String opponent, String score) {
    return 'Ένα βράδυ απέναντι στον αντίπαλο ($opponent) δεν σβήνει μια χρονιά. $score.';
  }

  @override
  String yWinUpset10(String opponent, String score) {
    return '$opponent $score και τώρα θα μας πουν ότι γυρίσαμε σελίδα. Δεν γυρίσαμε.';
  }

  @override
  String yWinUpset11(String opponent, String score) {
    return '$opponent $score. Υπέροχο. Ρώτα με ξανά όταν θα μετράει.';
  }

  @override
  String yWinRoutine0(String opponent, String score) {
    return '$opponent $score. Ακριβώς όπως έπρεπε, και υπάρχει χαρά σε αυτό.';
  }

  @override
  String yWinRoutine1(String opponent, String score) {
    return '$opponent, $score. Αμείλικτοι, και το αμείλικτοι είναι κομπλιμέντο.';
  }

  @override
  String yWinRoutine2(String opponent, String score) {
    return '$opponent $score. Χωρίς φασαρία, χωρίς αγωνία, χωρίς παράπονα.';
  }

  @override
  String yWinRoutine3(String opponent, String score) {
    return 'Ένα καθαρό $score, αντίπαλος $opponent. Έτσι μοιάζει μια καλή ομάδα σε μια ήσυχη μέρα.';
  }

  @override
  String yWinRoutine4(String opponent, String score) {
    return '$opponent, $score. Δουλειά τελειωμένη, τίποτα καινούργιο.';
  }

  @override
  String yWinRoutine5(String opponent, String score) {
    return '$opponent $score. Έπρεπε να κερδίσουμε και κερδίσαμε.';
  }

  @override
  String yWinRoutine6(String opponent, String score) {
    return 'Ένα επαγγελματικό $score, αντίπαλος $opponent. Επόμενο.';
  }

  @override
  String yWinRoutine7(String opponent, String score) {
    return '$opponent $score. Αρχειοθέτησέ το και προχώρα.';
  }

  @override
  String yWinRoutine8(String opponent, String score) {
    return '$opponent, $score, και πρέπει να χειροκροτήσουμε. Επειδή κερδίσαμε.';
  }

  @override
  String yWinRoutine9(String opponent, String score) {
    return 'Μπράβο σε όλους για το $score με αντίπαλο $opponent, υποθέτω.';
  }

  @override
  String yWinRoutine10(String opponent, String score) {
    return '$opponent $score. Το να κερδίζεις τέτοιες ομάδες είναι το ελάχιστο, όχι κατόρθωμα.';
  }

  @override
  String yWinRoutine11(String opponent, String score) {
    return '$opponent $score. Κερδίσαμε, αλλά φάνηκε ότι δυσκολευτήκαμε.';
  }

  @override
  String yWinTight0(String opponent, String score) {
    return '$opponent, $score, και κάθε λεπτό κερδισμένο με το σπαθί του.';
  }

  @override
  String yWinTight1(String opponent, String score) {
    return 'Χρειάστηκε χαρακτήρας. $opponent $score.';
  }

  @override
  String yWinTight2(String opponent, String score) {
    return '$opponent $score, με τον δύσκολο τρόπο, που είναι ο τρόπος που αντέχει.';
  }

  @override
  String yWinTight3(String opponent, String score) {
    return '$opponent, $score. Οι ομάδες που κερδίζουν έτσι είναι αυτές που στέκονται όρθιες τον Ιούνιο.';
  }

  @override
  String yWinTight4(String opponent, String score) {
    return 'Αγχωτικό, άσχημο, και νίκη. $opponent $score.';
  }

  @override
  String yWinTight5(String opponent, String score) {
    return '$opponent $score. Πάρε τους τρεις βαθμούς και μην το ξαναδείς ποτέ.';
  }

  @override
  String yWinTight6(String opponent, String score) {
    return '$score. Το $opponent μάς έκανε να παλέψουμε για κάθε σπιθαμή.';
  }

  @override
  String yWinTight7(String opponent, String score) {
    return '$opponent $score. Όχι όμορφο. Μετράει το ίδιο.';
  }

  @override
  String yWinTight8(String opponent, String score) {
    return '$opponent, $score, και το κάναμε δέκα φορές πιο δύσκολο απ\' όσο ήταν.';
  }

  @override
  String yWinTight9(String opponent, String score) {
    return 'Δεν έπρεπε να κρατιόμαστε από τα νύχια. $opponent, $score.';
  }

  @override
  String yWinTight10(String opponent, String score) {
    return '$opponent $score. Το κερδίσαμε, αλλά δεν μάθαμε τίποτα καλό για τον εαυτό μας.';
  }

  @override
  String yWinTight11(String opponent, String score) {
    return '$opponent: ένα $score που μας κολάκευσε.';
  }

  @override
  String yDrew0(String opponent, String score) {
    return 'Ένας βαθμός, $opponent, $score. Πάρ\' τον και προχώρα.';
  }

  @override
  String yDrew1(String opponent, String score) {
    return '$opponent, $score. Έχει και χειρότερα απογεύματα.';
  }

  @override
  String yDrew2(String opponent, String score) {
    return '$opponent, $score. Δεν χρειάζεται να είναι ιστορία το κάθε τι.';
  }

  @override
  String yDrew3(String opponent, String score) {
    return '$opponent $score. Ένας βαθμός είναι ένας βαθμός και η βαθμολογία δεν ρωτά πώς.';
  }

  @override
  String yDrew4(String opponent, String score) {
    return '$opponent, $score. Δύο βαθμοί χαμένοι ή ένας κερδισμένος. Διάλεξε διάθεση.';
  }

  @override
  String yDrew5(String opponent, String score) {
    return '$opponent, ισοπαλία $score. Κανείς δεν χαίρεται, κανείς δεν είναι έξαλλος.';
  }

  @override
  String yDrew6(String opponent, String score) {
    return '$opponent $score. Τα πιο ξεχασμένα ενενήντα λεπτά της χρονιάς.';
  }

  @override
  String yDrew7(String opponent, String score) {
    return '$opponent, $score. Μοιράστηκαν οι βαθμοί. Πάμε παρακάτω.';
  }

  @override
  String yDrew8(String opponent, String score) {
    return '$opponent, $score. Έτσι πεθαίνουν αθόρυβα οι εκστρατείες: με τέτοιες ισοπαλίες.';
  }

  @override
  String yDrew9(String opponent, String score) {
    return '$opponent, $score. Δύο βαθμοί πεταμένοι. Δεν υπάρχει άλλη λέξη.';
  }

  @override
  String yDrew10(String opponent, String score) {
    return '$opponent $score. Είχαμε ενενήντα λεπτά και καμία ιδέα τι να τα κάνουμε.';
  }

  @override
  String yDrew11(String opponent, String score) {
    return '$opponent, $score: ένα αποτέλεσμα που κανείς δεν θα θυμάται και όλοι θα πληρώσουν.';
  }

  @override
  String yLost0(String opponent, String score) {
    return '$opponent, ήττα $score. Συμβαίνουν αυτά.';
  }

  @override
  String yLost1(String opponent, String score) {
    return '$opponent $score. Δεν υπάρχει λόγος να κρεμάσουμε κανέναν. Στον επόμενο.';
  }

  @override
  String yLost2(String opponent, String score) {
    return '$opponent, ήττα $score, και δώσαμε τα πάντα. Κάποιες μέρες δεν φτάνει.';
  }

  @override
  String yLost3(String opponent, String score) {
    return '$opponent, $score. Κεφάλι ψηλά. Αυτή η ομάδα έχει πολλά ακόμα.';
  }

  @override
  String yLost4(String opponent, String score) {
    return '$opponent $score. Ήμασταν δεύτεροι και δεν υπάρχει αντίλογος.';
  }

  @override
  String yLost5(String opponent, String score) {
    return '$opponent, ήττα $score. Ανασυγκρότηση.';
  }

  @override
  String yLost6(String opponent, String score) {
    return '$opponent, $score. Όχι ρεζίλι, αλλά όχι αρκετά καλό.';
  }

  @override
  String yLost7(String opponent, String score) {
    return '$opponent, ήττα $score. Μάθε κάτι από αυτό, αλλιώς πήγε χαμένο.';
  }

  @override
  String yLost8(String opponent, String score) {
    return '$opponent, $score, και δεν τους αγγίξαμε.';
  }

  @override
  String yLost9(String opponent, String score) {
    return '$opponent, ήττα $score. Τα ίδια προβλήματα, ο ίδιος μήνας, οι ίδιες δικαιολογίες καθ\' οδόν.';
  }

  @override
  String yLost10(String opponent, String score) {
    return '$opponent $score. Πότε σταματά αυτό να είναι κακοτυχία;';
  }

  @override
  String yLost11(String opponent, String score) {
    return '$opponent, ήττα $score. Αποτέλεσμα που πρέπει να κοστίσει σε κάποιον.';
  }

  @override
  String yLostBadly0(String opponent, String score) {
    return '$opponent, $score. Μία κακή βραδιά. Κρίνε την ομάδα από την εκστρατεία, όχι από αυτό.';
  }

  @override
  String yLostBadly1(String opponent, String score) {
    return '$opponent, $score. Κανείς δεν ήθελε να μη γίνει αυτό λιγότερο από τους παίκτες.';
  }

  @override
  String yLostBadly2(String opponent, String score) {
    return '$opponent $score. Άσχημο, και δεν είναι αυτό που είναι αυτή η ομάδα.';
  }

  @override
  String yLostBadly3(String opponent, String score) {
    return '$opponent: ένα $score για να ξεχαστεί. Την επόμενη φορά θα απαντήσουν.';
  }

  @override
  String yLostBadly4(String opponent, String score) {
    return '$score. $opponent. Δεν έχω λόγια και πληρώνομαι για να έχω λόγια.';
  }

  @override
  String yLostBadly5(String opponent, String score) {
    return '$opponent $score. Κάποιος πρέπει να λογοδοτήσει.';
  }

  @override
  String yLostBadly6(String opponent, String score) {
    return '$opponent: θέλω το $score να σβηστεί από τα αρχεία και από τη μνήμη.';
  }

  @override
  String yLostBadly7(String opponent, String score) {
    return '$opponent, ήττα $score. Τέτοιο σκορ δεν στρογγυλεύεται με λόγια.';
  }

  @override
  String yLostBadly8(String opponent, String score) {
    return '$opponent: αυτό δεν ήταν ήττα, ήταν παράδοση. $score.';
  }

  @override
  String yLostBadly9(String opponent, String score) {
    return '$score. $opponent. Κόσμος πλήρωσε εισιτήριο για να το δει.';
  }

  @override
  String yLostBadly10(String opponent, String score) {
    return '$opponent $score. Αν αυτό δεν αλλάξει κάτι, τίποτα δεν θα αλλάξει.';
  }

  @override
  String yLostBadly11(String opponent, String score) {
    return 'Έχω ξαναδεί αυτή την ομάδα ταπεινωμένη, αλλά το $score με αντίπαλο $opponent είναι νέο πάτωμα.';
  }

  @override
  String yWinUpset12(String opponent, String score) {
    return '$opponent, νίκη $score. Σημειώστε την ημερομηνία, θα σας ρωτάνε πού ήσασταν.';
  }

  @override
  String yWinUpset13(String opponent, String score) {
    return 'Έξω από τα αποδυτήρια δεν το πίστευε κανείς. $opponent, $score. Η λέξη περηφάνια δεν φτάνει.';
  }

  @override
  String yWinUpset14(String opponent, String score) {
    return '$opponent, $score! Έτρεξαν όλοι μέχρι να μη μείνει τίποτα.';
  }

  @override
  String yWinUpset15(String opponent, String score) {
    return 'Γιγαντοφόνοι. $opponent, $score. Γι\' αυτό ερχόμαστε πάντα.';
  }

  @override
  String yWinUpset16(String opponent, String score) {
    return '$opponent, $score. Τα προγνωστικά μόλις πέταξαν από το παράθυρο.';
  }

  @override
  String yWinUpset17(String opponent, String score) {
    return 'Μεγάλο φαβορί: $opponent. Τελικό σκορ: $score για εμάς.';
  }

  @override
  String yWinUpset18(String opponent, String score) {
    return 'Μία από τις εκπλήξεις της χρονιάς: $opponent, $score.';
  }

  @override
  String yWinUpset19(String opponent, String score) {
    return '$opponent $score. Κανείς δεν το πρόβλεψε και κανείς δεν μπορεί να το εξηγήσει.';
  }

  @override
  String yWinUpset20(String opponent, String score) {
    return '$opponent, $score. Υπέροχο. Τώρα όλοι θα ξεχάσουν πόσο κακή ήταν η υπόλοιπη χρονιά.';
  }

  @override
  String yWinUpset21(String opponent, String score) {
    return '$opponent, $score, και το τρένο γέμισε ήδη. Εγώ ήμουν μέσα όταν ήταν άδειο.';
  }

  @override
  String yWinUpset22(String opponent, String score) {
    return '$opponent $score. Εξαιρετικό, και πάλι θα βρουν τρόπο να το πετάξουν.';
  }

  @override
  String yWinUpset23(String opponent, String score) {
    return 'Μεγάλη βραδιά. $opponent, $score. Ένα χελιδόνι δεν φέρνει την άνοιξη.';
  }

  @override
  String yLostBadly12(String opponent, String score) {
    return '$opponent, ήττα $score. Πονάει γιατί νοιαζόμαστε. Στηρίξτε τους ούτως ή άλλως.';
  }

  @override
  String yLostBadly13(String opponent, String score) {
    return 'Βραδιά για να ξεχαστεί. $opponent, $score. Οι παίκτες πονάνε περισσότερο απ\' όλους.';
  }

  @override
  String yLostBadly14(String opponent, String score) {
    return '$opponent $score. Ψηλά το κεφάλι. Μια ομάδα κρίνεται από το πώς απαντά σε αυτό.';
  }

  @override
  String yLostBadly15(String opponent, String score) {
    return '$opponent, $score. Κακό, ναι. Το τέλος του κόσμου, όχι.';
  }

  @override
  String yLostBadly16(String opponent, String score) {
    return '$opponent, ήττα $score. Αποτέλεσμα που θα συζητιέται για χρόνια, για λάθος λόγους.';
  }

  @override
  String yLostBadly17(String opponent, String score) {
    return 'Νίκη για $opponent, $score. Μετά από αυτό, κανείς να μην εκπλαγεί την επόμενη φορά.';
  }

  @override
  String yLostBadly18(String opponent, String score) {
    return 'Μία από τις χειρότερες βραδιές εδώ και καιρό: $opponent, $score.';
  }

  @override
  String yLostBadly19(String opponent, String score) {
    return '$opponent $score. Θα γίνουν ερωτήσεις, και σωστά.';
  }

  @override
  String yLostBadly20(String opponent, String score) {
    return '$opponent, ήττα $score. Το ντροπιαστικό είναι πολύ λίγο.';
  }

  @override
  String yLostBadly21(String opponent, String score) {
    return '$opponent, ήττα $score. Ο τελευταίος να σβήσει το φως.';
  }

  @override
  String yLostBadly22(String opponent, String score) {
    return '$opponent $score. Δεν εκπλήσσομαι πια, και αυτό με τρομάζει.';
  }

  @override
  String yLostBadly23(String opponent, String score) {
    return '$score. $opponent. Κάποιος εκεί ψηλά καλά θα κάνει να ενημερώσει το βιογραφικό του απόψε.';
  }

  @override
  String yWinRout0(String opponent, String score) {
    return '$opponent, $score! Τέτοιο ποδόσφαιρο κάνει όλη τη χώρα να χαμογελά.';
  }

  @override
  String yWinRout1(String opponent, String score) {
    return 'Περίπατος. $opponent, $score. Τι εμφάνιση.';
  }

  @override
  String yWinRout2(String opponent, String score) {
    return '$score. $opponent. Απόψε βγήκαν όλα.';
  }

  @override
  String yWinRout3(String opponent, String score) {
    return 'Κατεδάφιση $score. Αντίπαλος: $opponent. Κρατήστε τα στιγμιότυπα, θα τα θέλετε.';
  }

  @override
  String yWinRout4(String opponent, String score) {
    return '$opponent $score. Αυτή είναι μια ομάδα που χαίρεται το ποδόσφαιρό της.';
  }

  @override
  String yWinRout5(String opponent, String score) {
    return '$opponent, $score, και μπορούσαν να είναι περισσότερα. Μεγαλείο.';
  }

  @override
  String yWinRout6(String opponent, String score) {
    return '$opponent, $score. Σκορ που σε κάνει να κοιτάξεις δεύτερη φορά.';
  }

  @override
  String yWinRout7(String opponent, String score) {
    return '$opponent, νίκη $score. Μετά το πρώτο μισάωρο δεν υπήρχε αγώνας.';
  }

  @override
  String yWinRout8(String opponent, String score) {
    return 'Τελικό σκορ: $opponent, $score. Με διαφορά η μεγαλύτερη νίκη εδώ και καιρό.';
  }

  @override
  String yWinRout9(String opponent, String score) {
    return '$opponent $score. Η μία ομάδα ήρθε να παίξει, η άλλη δεν κατέβηκε καν από το πούλμαν.';
  }

  @override
  String yWinRout10(String opponent, String score) {
    return '$score. Καμία απάντηση από $opponent, σε τίποτα.';
  }

  @override
  String yWinRout11(String opponent, String score) {
    return 'Σκορπιστό: $opponent, $score.';
  }

  @override
  String yWinRout12(String opponent, String score) {
    return '$opponent, $score. Ωραίο, αλλά δεν είναι ακριβώς μέτρο σύγκρισης.';
  }

  @override
  String yWinRout13(String opponent, String score) {
    return '$opponent, $score. Ξυπνήστε με όταν το κάνουμε σε κάποιον καλό.';
  }

  @override
  String yWinRout14(String opponent, String score) {
    return '$opponent $score. Διασκεδαστικό, αλλά έχω δει ομάδες να λάμπουν έτσι και να μην κερδίζουν τίποτα.';
  }

  @override
  String yWinRout15(String opponent, String score) {
    return '$score, και όλοι είναι ξανά ιδιοφυΐες. Αντίπαλος ήταν: $opponent.';
  }

  @override
  String yWinRout16(String opponent, String score) {
    return '$opponent, $score. Μην παρασύρεστε, αποδεικνύει πολύ λίγα.';
  }

  @override
  String yWinRout17(String opponent, String score) {
    return '$opponent $score. Χαρείτε το, και μετά θυμηθείτε πώς τελείωσε την τελευταία φορά που ενθουσιαστήκαμε.';
  }

  @override
  String yWinShootout0(String opponent) {
    return 'Πρόκριση στα πέναλτι. Αντίπαλος: $opponent! Ατσάλινα νεύρα, όλοι τους.';
  }

  @override
  String yWinShootout1(String opponent) {
    return 'Πέναλτι. Αντίπαλος: $opponent. Κρατήσαμε την ψυχραιμία μας. Αγκαλιάστε έναν άγνωστο.';
  }

  @override
  String yWinShootout2(String opponent) {
    return 'Η διαδικασία των πέναλτι κερδήθηκε. Αντίπαλος: $opponent. Η καρδιά μου δεν αντέχει.';
  }

  @override
  String yWinShootout3(String opponent) {
    return 'Νίκη στα πέναλτι. Αντίπαλος: $opponent. Στον επόμενο γύρο.';
  }

  @override
  String yWinShootout4(String opponent) {
    return 'Αντίπαλος: $opponent. Όλα κρίθηκαν από την άσπρη βούλα, και βάλαμε περισσότερα.';
  }

  @override
  String yWinShootout5(String opponent) {
    return 'Πέναλτι κερδισμένα. Αντίπαλος: $opponent. Με τον πιο δύσκολο δρόμο, αλλά προκριθήκαμε.';
  }

  @override
  String yWinShootout6(String opponent) {
    return 'Πρόκριση στα πέναλτι. Αντίπαλος: $opponent. Κερδίσαμε το λαχείο, η εμφάνιση ας ξεχαστεί.';
  }

  @override
  String yWinShootout7(String opponent) {
    return 'Νίκη στα πέναλτι μετά από τέτοια εμφάνιση; Αντίπαλος: $opponent. Τύχη, και το ξέρουν όλοι.';
  }

  @override
  String yWinShootout8(String opponent) {
    return 'Πρόκριση στα πέναλτι. Αντίπαλος: $opponent. Δεν έπρεπε ποτέ να φτάσουμε εκεί.';
  }

  @override
  String yKnockoutWin0(String opponent, String score) {
    return 'ΠΡΟΚΡΙΣΗ. $opponent, $score, και το όνειρο ζει.';
  }

  @override
  String yKnockoutWin1(String opponent, String score) {
    return 'ΝΙΚΗ ΣΤΑ ΝΟΚ ΑΟΥΤ: $opponent, $score. Η χώρα μπορεί να αρχίσει να πιστεύει.';
  }

  @override
  String yKnockoutWin2(String opponent, String score) {
    return '$opponent, $score, και στον επόμενο γύρο. Τι βραδιά.';
  }

  @override
  String yKnockoutWin3(String opponent, String score) {
    return 'Σπίτι του: $opponent, $score. Συνεχίζουμε.';
  }

  @override
  String yKnockoutWin4(String opponent, String score) {
    return 'ΝΟΚ ΑΟΥΤ: $opponent, $score. Ο επόμενος γύρος επιβεβαιώθηκε.';
  }

  @override
  String yKnockoutWin5(String opponent, String score) {
    return 'Πρόκριση: $opponent, $score.';
  }

  @override
  String yKnockoutWin6(String opponent, String score) {
    return 'Εκτός: $opponent, $score. Ο επόμενος γύρος περιμένει.';
  }

  @override
  String yKnockoutWin7(String opponent, String score) {
    return 'Νίκη $score. Αντίπαλος: $opponent. Στα νοκ άουτ κανείς δεν ρωτά πώς.';
  }

  @override
  String yKnockoutWin8(String opponent, String score) {
    return 'Πρόκριση. $opponent, $score. Ο επόμενος αντίπαλος δεν θα είναι τόσο ευγενικός.';
  }

  @override
  String yKnockoutWin9(String opponent, String score) {
    return '$opponent, $score, φτάνει για την πρόκριση. Την επόμενη φορά θα χρειαστούν πολλά περισσότερα.';
  }

  @override
  String yKnockoutWin10(String opponent, String score) {
    return 'Εκτός: $opponent, $score. Περισσότερο επιβιώσαμε παρά κερδίσαμε.';
  }

  @override
  String yKnockoutWin11(String opponent, String score) {
    return 'Στον επόμενο γύρο μετά το $score. Αντίπαλος: $opponent. Μη ρωτάτε πώς.';
  }

  @override
  String yUpsetGap0(String opponent, String gap) {
    return 'Διαφορά $gap θέσεων στην κατάταξη, και νικήσαμε. Αντίπαλος: $opponent. Υπέροχο.';
  }

  @override
  String yUpsetGap1(String opponent, String gap) {
    return '$opponent: $gap θέσεις πάνω από εμάς. Κι όμως νίκη. Το ποδόσφαιρο είναι υπέροχο.';
  }

  @override
  String yUpsetGap2(String opponent, String gap) {
    return 'Διαφορά στην κατάταξη: $gap. Αποτέλεσμα: νίκη. Αντίπαλος: $opponent. Μη σταματάτε να πιστεύετε.';
  }

  @override
  String yUpsetGap3(String opponent, String gap) {
    return 'Διαφορά στην κατάταξη πριν τη σέντρα: $gap. Νίκη απέναντι στον αντίπαλο ($opponent) όπως και να \'χει.';
  }

  @override
  String yUpsetGap4(String opponent, String gap) {
    return 'Στην παγκόσμια κατάταξη, $gap θέσεις πάνω από εμάς: $opponent. Όχι απόψε.';
  }

  @override
  String yUpsetGap5(String opponent, String gap) {
    return 'Δείκτης έκπληξης: $gap θέσεις κατάταξης. Νίκη για εμάς. Αντίπαλος: $opponent.';
  }

  @override
  String yUpsetGap6(String opponent, String gap) {
    return '$gap θέσεις στην κατάταξη μας χώριζαν. Αντίπαλος: $opponent. Μία βραδιά δεν κλείνει το χάσμα.';
  }

  @override
  String yUpsetGap7(String opponent, String gap) {
    return '$opponent: $gap θέσεις πάνω, και ηττήθηκε. Η κατάταξη μόλις που θα το προσέξει.';
  }

  @override
  String yUpsetGap8(String gap) {
    return 'Διαφορά στην κατάταξη: $gap. Θυμηθείτε τον αριθμό την επόμενη φορά που θα χάσουμε από ουραγό.';
  }

  @override
  String yEatWords0(String opponent) {
    return 'Είχα ξεγράψει αυτή την ομάδα. Έκανα λάθος, και ποτέ δεν χάρηκα τόσο που έκανα λάθος. Αντίπαλος: $opponent.';
  }

  @override
  String yEatWords1(String opponent) {
    return 'Μια μερίδα ταπεινότητας, παρακαλώ. Μεγάλη. Η νίκη κόντρα στον αντίπαλο ($opponent) ήταν υπέροχη.';
  }

  @override
  String yEatWords2(String opponent) {
    return 'Είπα ότι δεν τους είχε μείνει τίποτα. Είχαν πολλά. Μπράβο σε όλους. Αντίπαλος: $opponent.';
  }

  @override
  String yEatWords3(String opponent) {
    return 'Για την ιστορία, αυτή τη νίκη δεν την είδα να έρχεται. Αντίπαλος: $opponent. Τα εύσημα σε όσους τα αξίζουν.';
  }

  @override
  String yEatWords4(String opponent) {
    return 'Εντάξει. Είπα ότι θα ξεσκεπαστούν. Δεν τους ξεσκέπασε ο αντίπαλος ($opponent).';
  }

  @override
  String yEatWords5(String opponent) {
    return 'Απόψε τρώω τα λόγια μου για αυτή την ομάδα. Η νίκη κόντρα στον αντίπαλο ($opponent) το αξίζει.';
  }

  @override
  String yEatWords6(String opponent) {
    return 'Ναι, είπα ότι τελείωσαν. Μία νίκη κόντρα στον αντίπαλο ($opponent) δεν με διαψεύδει ακόμα.';
  }

  @override
  String yEatWords7(String opponent) {
    return 'Μου λένε να φάω τα λόγια μου. Αντίπαλος: $opponent. Θα τα φάω, αργά, και κρατάω την απόδειξη.';
  }

  @override
  String yEatWords8(String opponent) {
    return 'Η νίκη κόντρα στον αντίπαλο ($opponent) ήταν εντυπωσιακή. Οι αμφιβολίες μου για αυτή την ομάδα δεν έφυγαν.';
  }

  @override
  String yAwayFansWin0(String nation, String score) {
    return 'Συγχαρητήρια: $nation. $score, και το άξιζαν από την αρχή ως το τέλος.';
  }

  @override
  String yAwayFansWin1(String nation, String score) {
    return 'Πονάει να το λέω, αλλά απόψε καλύτερη ομάδα ήταν: $nation. $score. Συγχαρητήρια.';
  }

  @override
  String yAwayFansWin2(String nation, String score) {
    return '$score. Βγάζω το καπέλο: $nation. Το ήθελαν περισσότερο.';
  }

  @override
  String yAwayFansWin3(String nation, String score) {
    return 'Ήττα $score. Αντίπαλος: $nation. Δεν ξέρω καν τι να πω.';
  }

  @override
  String yAwayFansWin4(String nation, String score) {
    return '$nation $score. Οι δικοί μας πρέπει να ντρέπονται.';
  }

  @override
  String yAwayFansWin5(String nation, String score) {
    return '$nation, $score. Κάποιος να μου εξηγήσει πώς έγινε αυτό.';
  }

  @override
  String yAwayFansWin6(String nation, String score) {
    return 'Να χάνεις $score. Αντίπαλος: $nation. Δεν θα το ξεπεράσω ποτέ.';
  }

  @override
  String yAwayFansWin7(String nation, String score) {
    return '$nation, $score. Τύχη. Καθαρή τύχη.';
  }

  @override
  String yAwayFansWin8(String nation, String score) {
    return 'Μετά από αυτό το $score, οι οπαδοί από $nation θα είναι ανυπόφοροι για χρόνια. Ευχαριστώ για τίποτα.';
  }

  @override
  String yNeutralWin0(String nation, String opponent, String score) {
    return '$nation $score $opponent. Υπέροχο για το ποδόσφαιρο. Γι\' αυτό το αγαπάμε.';
  }

  @override
  String yNeutralWin1(String nation, String opponent, String score) {
    return 'Τι αποτέλεσμα: $nation $score $opponent. Ποδόσφαιρο στα καλύτερά του.';
  }

  @override
  String yNeutralWin2(String nation, String opponent, String score) {
    return 'Όλοι οι ουδέτεροι είναι με το μέρος της ομάδας ($nation) απόψε. $nation $score $opponent!';
  }

  @override
  String yNeutralWin3(String nation, String opponent, String score) {
    return 'Αποτέλεσμα της αγωνιστικής: $nation $score $opponent.';
  }

  @override
  String yNeutralWin4(String nation, String opponent, String score) {
    return '$nation $score $opponent. Κανείς δεν το είχε στο δελτίο του.';
  }

  @override
  String yNeutralWin5(String nation, String opponent, String score) {
    return 'Μεγάλο αποτέλεσμα: $nation $score $opponent. Η κατάταξη θα κουνηθεί.';
  }

  @override
  String yNeutralWin6(String nation, String opponent, String score) {
    return '$nation $score $opponent. Διασκεδαστικό, ας δούμε αν μπορούν να το ξανακάνουν.';
  }

  @override
  String yNeutralWin7(String nation, String opponent, String score) {
    return '$nation $score $opponent. Το κέρδισε η μία πλευρά ή το έχασε η άλλη;';
  }

  @override
  String yNeutralWin8(String nation, String opponent, String score) {
    return 'Έκπληξη: $nation $score $opponent. Περιμένετε πολλές υπερβολικές αντιδράσεις.';
  }

  @override
  String yScorerHero0(String name, String opponent) {
    return '$name. Αντίπαλος: $opponent. Θα δίνουν το όνομά του στα παιδιά.';
  }

  @override
  String yScorerHero1(String name, String opponent) {
    return 'Ένα άγαλμα για τον $name. Απόψε, με αντίπαλο: $opponent, ήταν τα πάντα.';
  }

  @override
  String yScorerHero2(String name, String opponent) {
    return '$name, τι παίκτης. Θυμηθείτε αυτή τη βραδιά. Αντίπαλος: $opponent.';
  }

  @override
  String yScorerHero3(String name, String opponent) {
    return 'Ο $name το έκρινε. Αντίπαλος: $opponent. Παίκτης του αγώνα, χωρίς συζήτηση.';
  }

  @override
  String yScorerHero4(String name, String opponent) {
    return 'Αντίπαλος: $opponent. Η βραδιά ανήκε στον $name.';
  }

  @override
  String yScorerHero5(String name, String opponent) {
    return 'Ο $name εμφανίστηκε όταν χρειαζόταν. Αντίπαλος: $opponent.';
  }

  @override
  String yScorerHero6(String name, String opponent) {
    return 'Ο $name ήταν εξαιρετικός. Αντίπαλος: $opponent. Τώρα κάθε εβδομάδα.';
  }

  @override
  String yScorerHero7(String name, String opponent) {
    return 'Ο $name έσωσε την ομάδα. Αντίπαλος: $opponent. Οι υπόλοιποι βοήθησαν λίγο.';
  }

  @override
  String yScorerHero8(String name, String opponent) {
    return 'Χωρίς τον $name, θα ήταν εντελώς άλλη βραδιά. Αντίπαλος: $opponent.';
  }

  @override
  String yLostShock0(String opponent, String score) {
    return '$opponent, ήττα $score. Ατύχημα. Συμβαίνει σε όλους μία φορά.';
  }

  @override
  String yLostShock1(String opponent, String score) {
    return '$opponent, ήττα $score. Τινάξτε το από πάνω σας, η πορεία δεν τελείωσε.';
  }

  @override
  String yLostShock2(String opponent, String score) {
    return '$opponent $score. Πονάει, αλλά ένα αποτέλεσμα δεν ορίζει αυτή την ομάδα.';
  }

  @override
  String yLostShock3(String opponent, String score) {
    return '$opponent, $score. Κακή μέρα στο γραφείο. Συνεχίζουμε.';
  }

  @override
  String yLostShock4(String opponent, String score) {
    return 'Ήττα. $opponent, $score. Κανείς δεν το είδε να έρχεται.';
  }

  @override
  String yLostShock5(String opponent, String score) {
    return '$opponent $score. Μία από εκείνες τις βραδιές που δεν βγάζουν νόημα.';
  }

  @override
  String yLostShock6(String opponent, String score) {
    return '$opponent, ήττα $score. Ήττα που θα θυμόμαστε.';
  }

  @override
  String yLostShock7(String opponent, String score) {
    return 'Ηττηθήκαμε. $opponent, $score. Έκπληξη από όποια πλευρά κι αν το δεις.';
  }

  @override
  String yLostShock8(String opponent, String score) {
    return '$opponent, ήττα $score. Από τέτοιον αντίπαλο! Απαράδεκτο.';
  }

  @override
  String yLostShock9(String opponent, String score) {
    return '$opponent, ήττα $score. Θέλω εξηγήσεις, όχι δικαιολογίες.';
  }

  @override
  String yLostShock10(String opponent, String score) {
    return '$opponent $score. Εθνική ντροπή, και δεν είναι σχήμα λόγου.';
  }

  @override
  String yLostShock11(String opponent, String score) {
    return '$opponent, $score. Πώς είναι ακόμα κάποιος εκεί ψηλά στη θέση του;';
  }

  @override
  String yLostRout0(String opponent, String score) {
    return '$opponent, ήττα $score. Είναι κορυφαία ομάδα. Μαθαίνουμε.';
  }

  @override
  String yLostRout1(String opponent, String score) {
    return 'Μας ξεπέρασε κατά κράτος: $opponent, $score. Καμία ντροπή να χάνεις από τους καλύτερους.';
  }

  @override
  String yLostRout2(String opponent, String score) {
    return '$opponent $score. Ένα μάθημα, και με τα μαθήματα μεγαλώνεις.';
  }

  @override
  String yLostRout3(String opponent, String score) {
    return '$opponent, $score. Πονάει, αλλά είναι ένα σκαλί πιο πάνω.';
  }

  @override
  String yLostRout4(String opponent, String score) {
    return 'Νίκη για $opponent, $score. Η διαφορά είναι πραγματική, και τώρα την είδαν όλοι.';
  }

  @override
  String yLostRout5(String opponent, String score) {
    return '$opponent, ήττα $score. Σκέτο ξύλο.';
  }

  @override
  String yLostRout6(String opponent, String score) {
    return '$opponent $score. Η καλύτερη ομάδα, και το σκορ το λέει.';
  }

  @override
  String yLostRout7(String opponent, String score) {
    return '$opponent, ήττα $score. Όχι ντροπή, αλλά ούτε και αγώνας.';
  }

  @override
  String yLostRout8(String opponent, String score) {
    return '$opponent, ήττα $score. Καλύτερος αντίπαλος ή όχι, έτσι δεν χάνει κανείς.';
  }

  @override
  String yLostRout9(String opponent, String score) {
    return '$opponent $score. Προσπαθήσαμε καν να ανταγωνιστούμε;';
  }

  @override
  String yLostRout10(String opponent, String score) {
    return '$score. $opponent. Πρόβατα επί σφαγή.';
  }

  @override
  String yLostRout11(String opponent, String score) {
    return '$opponent, ήττα $score, και κανείς δεν έδειχνε να νοιάζεται.';
  }

  @override
  String yLostShootout0(String opponent) {
    return 'Αποκλεισμός στα πέναλτι. Αντίπαλος: $opponent. Τα έδωσαν όλα. Περήφανος για αυτούς.';
  }

  @override
  String yLostShootout1(String opponent) {
    return 'Πέναλτι. Αντίπαλος: $opponent. Ο πιο σκληρός τρόπος να αποκλειστείς. Ψηλά το κεφάλι.';
  }

  @override
  String yLostShootout2(String opponent) {
    return 'Χάσαμε στα πέναλτι. Αντίπαλος: $opponent. Κανείς δεν το άξιζε αυτό.';
  }

  @override
  String yLostShootout3(String opponent) {
    return 'Αποκλεισμός στα πέναλτι. Αντίπαλος: $opponent. Αποφάσισε η άσπρη βούλα.';
  }

  @override
  String yLostShootout4(String opponent) {
    return 'Πρόκριση στα πέναλτι για $opponent. Το τουρνουά μας τελειώνει εδώ.';
  }

  @override
  String yLostShootout5(String opponent) {
    return 'Χάσαμε στα πέναλτι. Αντίπαλος: $opponent. Ξανά πέναλτι.';
  }

  @override
  String yLostShootout6(String opponent) {
    return 'Αποκλεισμός στα πέναλτι. Αντίπαλος: $opponent. Τα προπονούμε ποτέ;';
  }

  @override
  String yLostShootout7(String opponent) {
    return 'Ήττα στα πέναλτι. Αντίπαλος: $opponent. Έπρεπε να το είχαμε τελειώσει πολύ νωρίτερα.';
  }

  @override
  String yLostShootout8(String opponent) {
    return 'Πέναλτι. Αντίπαλος: $opponent. Και τα χάσαμε. Φυσικά.';
  }

  @override
  String yKnockoutLoss0(String opponent, String score) {
    return 'ΑΠΟΚΛΕΙΣΜΟΣ. $opponent, $score. Μια πορεία για την οποία είμαστε περήφανοι τελειώνει εδώ.';
  }

  @override
  String yKnockoutLoss1(String opponent, String score) {
    return 'Αποκλεισμός. $opponent, $score. Ευχαριστούμε για τις αναμνήσεις.';
  }

  @override
  String yKnockoutLoss2(String opponent, String score) {
    return '$opponent, $score. Το ταξίδι τελείωσε, αλλά τι ταξίδι.';
  }

  @override
  String yKnockoutLoss3(String opponent, String score) {
    return 'ΕΚΤΟΣ: $opponent, $score. Ψηλά τα κεφάλια.';
  }

  @override
  String yKnockoutLoss4(String opponent, String score) {
    return 'ΤΕΛΟΣ: $opponent, $score.';
  }

  @override
  String yKnockoutLoss5(String opponent, String score) {
    return 'Εκτός: $opponent, $score.';
  }

  @override
  String yKnockoutLoss6(String opponent, String score) {
    return 'Προκρίνεται: $opponent, $score. Το τουρνουά μας τελείωσε.';
  }

  @override
  String yKnockoutLoss7(String opponent, String score) {
    return 'Αποκλεισμός. $opponent, $score. Η νεκροψία αρχίζει τώρα.';
  }

  @override
  String yKnockoutLoss8(String opponent, String score) {
    return 'ΑΠΟΚΛΕΙΣΜΟΣ. $opponent, $score. Άλλο τουρνουά, ίδιο τέλος.';
  }

  @override
  String yKnockoutLoss9(String opponent, String score) {
    return '$opponent, $score, και σπίτια μας. Κανείς δεν εκπλήσσεται.';
  }

  @override
  String yKnockoutLoss10(String opponent, String score) {
    return 'Αποκλεισμός. $opponent, $score. Περιμένετε δικαιολογίες μέχρι το πρωί.';
  }

  @override
  String yKnockoutLoss11(String opponent, String score) {
    return '$opponent $score. Εκτός, και ποτέ δεν φάνηκε ότι θα τελείωνε αλλιώς.';
  }

  @override
  String yAwayFansGloat0(String nation, String score) {
    return '$nation, $score. Σεβασμός, θα γυρίσουν πιο δυνατοί.';
  }

  @override
  String yAwayFansGloat1(String nation, String score) {
    return 'Καλή νίκη για εμάς, $score. Κακή μέρα για $nation, λυπάμαι τους οπαδούς τους.';
  }

  @override
  String yAwayFansGloat2(String nation, String score) {
    return '$score. Κακή βραδιά για $nation, κι εμείς αρπάξαμε την ευκαιρία. Έτσι είναι.';
  }

  @override
  String yAwayFansGloat3(String nation, String score) {
    return '$nation, $score! Ποιος το περίμενε; Αυτοί πάντως όχι.';
  }

  @override
  String yAwayFansGloat4(String nation, String score) {
    return 'Νίκη $score. Αντίπαλος: $nation. Ας πάει κάποιος να δει πώς είναι οι οπαδοί τους.';
  }

  @override
  String yAwayFansGloat5(String nation, String score) {
    return '$nation $score. Αυτό μπαίνει στο άλμπουμ.';
  }

  @override
  String yAwayFansGloat6(String nation, String score) {
    return '$nation, $score. Και νομίζουν ότι είναι μεγάλη ομάδα.';
  }

  @override
  String yAwayFansGloat7(String nation, String score) {
    return 'Φαντάσου να χάνεις $score από εμάς. Ρώτα: $nation. Τώρα ξέρουν.';
  }

  @override
  String yAwayFansGloat8(String nation, String score) {
    return '$nation, $score. Καλή πτήση επιστροφής.';
  }

  @override
  String yNeutralLoss0(String nation, String opponent, String score) {
    return '$nation $score $opponent. Μεγάλη βραδιά για τη μία πλευρά, δύσκολη για την άλλη.';
  }

  @override
  String yNeutralLoss1(String nation, String opponent, String score) {
    return 'Κουράγιο στους οπαδούς από $nation μετά το $score. Αντίπαλος: $opponent. Θα ξανασηκωθούν.';
  }

  @override
  String yNeutralLoss2(String nation, String opponent, String score) {
    return '$nation $score $opponent. Κάθε μεγάλη ομάδα έχει μια τέτοια βραδιά.';
  }

  @override
  String yNeutralLoss3(String nation, String opponent, String score) {
    return 'Η έκπληξη της αγωνιστικής: $nation $score $opponent.';
  }

  @override
  String yNeutralLoss4(String nation, String opponent, String score) {
    return '$nation $score $opponent. Κανείς δεν το είδε να έρχεται.';
  }

  @override
  String yNeutralLoss5(String nation, String opponent, String score) {
    return 'Αποτέλεσμα της ημέρας: $nation $score $opponent. Τώρα έρχονται οι ερωτήσεις.';
  }

  @override
  String yNeutralLoss6(String nation, String opponent, String score) {
    return '$nation $score $opponent. Όχι μεμονωμένο, αν το παρακολουθείτε.';
  }

  @override
  String yNeutralLoss7(String nation, String opponent, String score) {
    return '$nation $score $opponent. Κάποιος εκεί θα έχει πολλά να εξηγήσει.';
  }

  @override
  String yNeutralLoss8(String nation, String opponent, String score) {
    return '$nation $score $opponent. Μεγάλο όνομα, μικρή εμφάνιση.';
  }

  @override
  String yDownGap0(String opponent, String gap) {
    return '$opponent: $gap θέσεις κάτω από εμάς. Συμβαίνει. Συνεχίζουμε.';
  }

  @override
  String yDownGap1(String gap) {
    return 'Διαφορά στην κατάταξη: $gap υπέρ μας. Το ποδόσφαιρο δεν διαβάζει κατατάξεις.';
  }

  @override
  String yDownGap2(String opponent, String gap) {
    return 'Στα χαρτιά $gap θέσεις μας χώριζαν. Αντίπαλος: $opponent. Όχι στο γήπεδο απόψε.';
  }

  @override
  String yDownGap3(String opponent, String gap) {
    return 'Διαφορά στην κατάταξη πριν τη σέντρα: $gap υπέρ μας. Ήττα όπως και να \'χει. Αντίπαλος: $opponent.';
  }

  @override
  String yDownGap4(String opponent, String gap) {
    return 'Στην παγκόσμια κατάταξη, $gap θέσεις κάτω από εμάς: $opponent. Αποτέλεσμα: ήττα.';
  }

  @override
  String yDownGap5(String opponent, String gap) {
    return 'Δείκτης έκπληξης: $gap θέσεις κατάταξης, ανάποδα. Αντίπαλος: $opponent.';
  }

  @override
  String yDownGap6(String opponent, String gap) {
    return '$gap θέσεις πάνω από τον αντίπαλο ($opponent). Ήττα. Εξηγήστε το.';
  }

  @override
  String yDownGap7(String gap) {
    return 'Ήττα από ομάδα $gap θέσεις κάτω από εμάς. Αφήστε αυτόν τον αριθμό να κατακάτσει.';
  }

  @override
  String yDownGap8(String opponent, String gap) {
    return 'Διαφορά στην κατάταξη: $gap. Ήττα. Αντίπαλος: $opponent. Κάποιος πρέπει να μετράει μέρες.';
  }

  @override
  String yDrewHeroic0(String opponent, String score) {
    return '$opponent, $score! Ισοπαλία με γεύση νίκης.';
  }

  @override
  String yDrewHeroic1(String opponent, String score) {
    return '$opponent, $score. Περήφανος για κάθε έναν τους.';
  }

  @override
  String yDrewHeroic2(String opponent, String score) {
    return '$opponent $score. Ήταν το φαβορί και τους κοιτάξαμε στα μάτια.';
  }

  @override
  String yDrewHeroic3(String opponent, String score) {
    return '$opponent, $score. Βαθμός με αίμα και ιδρώτα.';
  }

  @override
  String yDrewHeroic4(String opponent, String score) {
    return '$opponent, $score. Πολύ καλός βαθμός.';
  }

  @override
  String yDrewHeroic5(String opponent, String score) {
    return 'Ισοπαλία $score. Αντίπαλος: $opponent. Λίγοι περίμεναν οτιδήποτε.';
  }

  @override
  String yDrewHeroic6(String opponent, String score) {
    return 'Φρενάραμε τον αντίπαλο ($opponent), $score. Αποτέλεσμα για να χτίσουμε.';
  }

  @override
  String yDrewHeroic7(String opponent, String score) {
    return '$opponent, $score. Βαθμός που δεν μας έδινε κανείς.';
  }

  @override
  String yDrewHeroic8(String opponent, String score) {
    return '$opponent, $score. Καλός βαθμός, αλλά με ισοπαλίες δεν κερδίζεις τίποτα.';
  }

  @override
  String yDrewHeroic9(String opponent, String score) {
    return '$opponent, $score. Ωραίο. Ούτε ένα σωστό σουτ δεν κάναμε.';
  }

  @override
  String yDrewHeroic10(String opponent, String score) {
    return '$opponent $score. Ένας βαθμός, και όλοι κάνουν σαν να πήραμε τον τίτλο.';
  }

  @override
  String yDrewHeroic11(String opponent, String score) {
    return '$opponent, $score. Παρκάραμε το πούλμαν και σταθήκαμε τυχεροί.';
  }

  @override
  String yDrewShame0(String opponent, String score) {
    return '$opponent, $score. Εκνευριστικό, αλλά ακόμα αήττητοι.';
  }

  @override
  String yDrewShame1(String opponent, String score) {
    return 'Μόνο $score. Αντίπαλος: $opponent. Κακή μέρα. Συμβαίνει.';
  }

  @override
  String yDrewShame2(String opponent, String score) {
    return '$opponent $score. Όχι αρκετά καλό, και οι παίκτες το ξέρουν.';
  }

  @override
  String yDrewShame3(String opponent, String score) {
    return '$opponent, $score. Δύο βαθμοί χαμένοι, τίποτα παραπάνω.';
  }

  @override
  String yDrewShame4(String opponent, String score) {
    return '$opponent, $score. Δύο βαθμοί πεταμένοι.';
  }

  @override
  String yDrewShame5(String opponent, String score) {
    return 'Μόνο $score. Αντίπαλος: $opponent. Κακό αποτέλεσμα, όπως και να το τυλίξεις.';
  }

  @override
  String yDrewShame6(String opponent, String score) {
    return '$opponent $score. Ισοπαλία με γεύση ήττας.';
  }

  @override
  String yDrewShame7(String opponent, String score) {
    return '$opponent, $score. Τέτοια ματς πρέπει να τα κερδίζουμε άνετα.';
  }

  @override
  String yDrewShame8(String opponent, String score) {
    return '$opponent, $score. Ντροπή.';
  }

  @override
  String yDrewShame9(String opponent, String score) {
    return 'Μόνο ισοπαλία. $opponent, $score. Ποιος ευθύνεται γι\' αυτό;';
  }

  @override
  String yDrewShame10(String opponent, String score) {
    return '$opponent $score. Αν δεν νικάμε αυτούς, ποιους θα νικήσουμε;';
  }

  @override
  String yDrewShame11(String opponent, String score) {
    return '$opponent, $score. Οι οπαδοί τους πανηγυρίζουν ισοπαλία με εμάς. Σκεφτείτε το.';
  }

  @override
  String yTrophy0(String opponent) {
    return 'ΠΡΩΤΑΘΛΗΤΕΣ. $opponent. Πες το φωναχτά.';
  }

  @override
  String yTrophy1(String opponent) {
    return 'Το κερδίσαμε. $opponent. Δεν είμαι καλά.';
  }

  @override
  String yTrophy2(String opponent) {
    return '$opponent: το τρόπαιο γυρίζει σπίτι.';
  }

  @override
  String yTrophy3(String opponent) {
    return 'Ο καθένας τους και θρύλος. $opponent.';
  }

  @override
  String yRunnerUp0(String opponent) {
    return 'Τόσο κοντά. $opponent και ένα μετάλλιο που δεν το θέλει κανείς.';
  }

  @override
  String yRunnerUp1(String opponent) {
    return 'Φιναλίστ, $opponent. Θα πονάει για χρόνια.';
  }

  @override
  String yRunnerUp2(String opponent) {
    return '$opponent: ένας αγώνας από το παν.';
  }

  @override
  String yRunnerUp3(String opponent) {
    return 'Δεύτεροι. $opponent. Περάστε κάποιος το μπουκάλι.';
  }

  @override
  String yEliminated0(String opponent) {
    return 'Αποκλεισμός, $opponent. Αυτό θα πονέσει για λίγο.';
  }

  @override
  String yEliminated1(String opponent) {
    return '$opponent: εδώ τελειώνει το ταξίδι μας.';
  }

  @override
  String yEliminated2(String opponent) {
    return 'Αποκλεισμός, $opponent. Τώρα η ανάκριση.';
  }

  @override
  String yEliminated3(String opponent) {
    return 'Νοκ άουτ, $opponent. Να μου το εξηγήσει κάποιος.';
  }

  @override
  String yQualified0(String opponent) {
    return '$opponent: ΜΠΑΙΝΟΥΜΕ!';
  }

  @override
  String yQualified1(String opponent) {
    return 'Προκρίθηκε η ομάδα, $opponent. Κλείστε άδεια από τη δουλειά.';
  }

  @override
  String yQualified2(String opponent) {
    return '$opponent: έρχεται η ώρα μας. Ποτέ σε αμφιβολία (ήταν εντελώς σε αμφιβολία).';
  }

  @override
  String yQualified3(String opponent) {
    return 'Πρόκριση, $opponent. Το δύσκολο κομμάτι τελείωσε.';
  }

  @override
  String yGroupDrawn0(String opponent) {
    return 'Κλήρωση ομίλων, $opponent. Θα μπορούσε να είναι χειρότερα. Πολύ χειρότερα.';
  }

  @override
  String yGroupDrawn1(String opponent) {
    return 'Κλήρωση, $opponent. Ενδιαφέρον.';
  }

  @override
  String yGroupDrawn2(String opponent) {
    return '$opponent: βγήκαν οι όμιλοι και ο δικός μας ήδη δεν μου αρέσει.';
  }

  @override
  String yGroupDrawn3(String opponent) {
    return 'Κλήρωση, $opponent. Ας αρχίσει η υπερβολή.';
  }

  @override
  String yHostNamed0(String opponent) {
    return 'Διοργανωτής: $opponent. Αρχίστε να κάνετε οικονομία.';
  }

  @override
  String yHostNamed1(String opponent) {
    return 'Διοργανωτής: $opponent. Αναμενόμενο, αλλά εντάξει.';
  }

  @override
  String yHostNamed2(String opponent) {
    return 'Διοργανωτής: $opponent. Συγχαρητήρια σε αυτούς, υποθέτω.';
  }

  @override
  String yHostNamed3(String opponent) {
    return 'Επιβεβαιώθηκε ο οικοδεσπότης: $opponent.';
  }

  @override
  String yTournamentSoon0(String opponent) {
    return '$opponent: ξεκινά σύντομα και δεν μπορώ να καθίσω ήσυχος.';
  }

  @override
  String yTournamentSoon1(String opponent) {
    return '$opponent: δεν λείπει πολύ.';
  }

  @override
  String yTournamentSoon2(String opponent) {
    return '$opponent: σχεδόν εδώ. Ανακοινώστε την αποστολή, παρακαλώ.';
  }

  @override
  String yTournamentSoon3(String opponent) {
    return '$opponent: η αντίστροφη μέτρηση είναι επισήμως ανυπόφορη.';
  }

  @override
  String get navY => 'Y';

  @override
  String get yTitle => 'Y';

  @override
  String get yEmpty => 'Τίποτα να πούμε ακόμα. Παίξε έναν αγώνα.';

  @override
  String get yEarlierHeading => 'Νωρίτερα αυτόν τον κύκλο';

  @override
  String get yTraitLoyalist =>
      'Στηρίζει την ομάδα ό,τι κι αν γίνει. Αργεί να γυρίσει την πλάτη, συγχωρεί γρήγορα.';

  @override
  String get yTraitCynic =>
      'Περιμένει πάντα το χειρότερο και χαίρεται όταν δικαιώνεται.';

  @override
  String get yTraitNostalgic =>
      'Όλα ήταν καλύτερα παλιά. Σε μετρά με άντρες που έχουν αποσυρθεί.';

  @override
  String get yTraitStatshead =>
      'Ανεβάζει αριθμούς και τίποτα άλλο. Δεν έχει σχεδόν διάθεση.';

  @override
  String get yTraitHypeman => 'Δύο καλά αποτελέσματα και είναι χρυσή γενιά.';

  @override
  String get yTraitContrarian => 'Ό,τι πιστεύει η παρέα, το αντίθετο.';

  @override
  String get yTraitDoomer => 'Θα στραβώσει. Πάντα θα στραβώνει.';

  @override
  String get yProfilePosts => 'ΑΝΑΡΤΗΣΕΙΣ';

  @override
  String get yProfileEmpty => 'Τίποτα από αυτόν τον λογαριασμό ακόμα.';

  @override
  String hubEventGrievance(String player) {
    return 'Ο $player θέλει κουβέντα';
  }

  @override
  String get hubEventGrievanceSub => 'Θέλει να μάθει πού βρίσκεται';

  @override
  String hubEventManagerSkills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count πόντοι δεξιοτήτων προς χρήση',
      one: '1 πόντος δεξιοτήτων προς χρήση',
    );
    return '$_temp0';
  }

  @override
  String get hubEventManagerSkillsSub =>
      'Ό,τι κάνεις καλά κάνει την ομάδα σου καλύτερη';

  @override
  String get grievanceTitle => 'Κουβέντα στο γραφείο σου';

  @override
  String grievanceGameTime(String player) {
    return 'Ο $player είναι στην αποστολή και δεν έχει αγγίξει μπάλα. Θέλει να μάθει γιατί.';
  }

  @override
  String grievanceSquadPlace(String player) {
    return 'Ο $player δεν είναι στην αποστολή και δεν μπορεί να το καταλάβει. Θέλει να του το πεις, έτσι ή αλλιώς.';
  }

  @override
  String grievanceRole(String player) {
    return 'Ο $player παίζει συνεχώς εκτός θέσης και έχει βαρεθεί.';
  }

  @override
  String get grievanceReassure => 'Είσαι στα σχέδιά μου';

  @override
  String get grievanceHonest => 'Υπάρχουν άλλοι μπροστά σου, και να γιατί';

  @override
  String get grievanceDismiss => 'Την ενδεκάδα την επιλέγω εγώ';

  @override
  String yScorerStar0(String name, String goals) {
    return 'Ο $name έβαλε $goals από αυτά. Κανείς άλλος δεν είναι κοντά.';
  }

  @override
  String yScorerStar1(String name, String goals) {
    return '$goals γκολ ο $name. Κουβαλά αυτή την ομάδα.';
  }

  @override
  String yScorerStar2(String name, String goals) {
    return '$name: $goals σήμερα. Τι παίκτης.';
  }

  @override
  String yScorerStar3(String name, String goals) {
    return '$goals τους έβαλε ο $name. Υπόκλιση.';
  }

  @override
  String yScorerStar4(String name, String goals) {
    return '$goals ο $name, και οι υπόλοιποι ήταν επιβάτες.';
  }

  @override
  String yScorerStar5(String name, String goals) {
    return 'Πάλι ο $name. $goals. Φαντάσου αυτή την ομάδα χωρίς αυτόν.';
  }

  @override
  String yScorerStar6(String name, String goals) {
    return '$goals ο $name. Ένας άνθρωπος δεν πρέπει να κάνει τόσα πολλά.';
  }

  @override
  String yScorerStar7(String name, String goals) {
    return 'Βγάλε τον $name από αυτό και είναι $goals λιγότερα και ένα πολύ διαφορετικό απόγευμα.';
  }

  @override
  String yWinStreak0(String count) {
    return '$count στη σειρά. Ό,τι κι αν λέγεται σε αυτά τα αποδυτήρια, περνάει.';
  }

  @override
  String yWinStreak1(String count) {
    return '$count συνεχόμενες. Οι ομάδες δεν σκοντάφτουν σε τέτοιες σειρές.';
  }

  @override
  String yWinStreak2(String count) {
    return '$count στη σειρά και συνεχίζουμε. Η αυτοπεποίθηση φαίνεται από τις κερκίδες.';
  }

  @override
  String yWinStreak3(String count) {
    return 'Αήττητοι σε $count. Ρώτα όποιον έχει προπονήσει: αυτό είναι το δύσκολο.';
  }

  @override
  String yWinStreak4(String count) {
    return '$count στη σειρά. Απόλαυσέ το όσο το πρόγραμμα είναι ευνοϊκό.';
  }

  @override
  String yWinStreak5(String count) {
    return '$count συνεχόμενες και δεν έχουμε νικήσει κανέναν υπολογίσιμο.';
  }

  @override
  String yWinStreak6(String count) {
    return 'Σειρά $count. Ρώτα με ξανά όταν δοκιμαστεί.';
  }

  @override
  String yWinStreak7(String count) {
    return '$count στο τρέξιμο. Κάθε ομάδα έχει μία τέτοια μέσα της κάποια στιγμή.';
  }

  @override
  String yLossStreak0(String count) {
    return '$count χωρίς νίκη πλέον. Κάποια στιγμή οι δικαιολογίες τελειώνουν.';
  }

  @override
  String yLossStreak1(String count) {
    return 'Πάνε $count στη σειρά. Δεν είναι πια τυχαίο.';
  }

  @override
  String yLossStreak2(String count) {
    return '$count συνεχόμενες ήττες. Κάποιος πρέπει να λογοδοτήσει.';
  }

  @override
  String yLossStreak3(String count) {
    return 'Καμία νίκη σε $count. Φαίνεται στον τρόπο που παίζουν.';
  }

  @override
  String yLossStreak4(String count) {
    return '$count χωρίς νίκη και τα ίδια λάθη κάθε εβδομάδα.';
  }

  @override
  String yLossStreak5(String count) {
    return '$count στη σειρά. Ό,τι κι αν δοκιμάζεται, δεν δουλεύει.';
  }

  @override
  String yLossStreak6(String count) {
    return '$count συνεχόμενες. Αυτό είναι κατεύθυνση, όχι κάμψη.';
  }

  @override
  String yLossStreak7(String count) {
    return 'Καμία νίκη σε $count, και κανείς στον επάνω όροφο δεν είπε λέξη.';
  }

  @override
  String yRivalry0(String opponent, String score) {
    return '$opponent $score. Πες ό,τι θες για το ποδόσφαιρο. Αυτό μετράει διπλά.';
  }

  @override
  String yRivalry1(String opponent, String score) {
    return '$opponent, από όλους. $score. Κανείς εδώ δεν θα το ξεχάσει.';
  }

  @override
  String yRivalry2(String opponent, String score) {
    return '$opponent, $score. Αυτό είναι που θα λένε στις παμπ.';
  }

  @override
  String yRivalry3(String opponent, String score) {
    return 'Γείτονες, $score. Το καμάρι κρίθηκε για λίγο.';
  }

  @override
  String yRivalry4(String opponent, String score) {
    return '$opponent $score. Ό,τι άλλο κι αν γίνει φέτος, υπάρχει και αυτό.';
  }

  @override
  String yRivalry5(String opponent, String score) {
    return '$opponent, $score. Κάποιοι το είχαμε ανάγκη περισσότερο από τη βαθμολογία.';
  }

  @override
  String yRivalry6(String opponent, String score) {
    return '$opponent $score. Και θα το πάρουν πίσω την επόμενη φορά, πάντα το παίρνουν.';
  }

  @override
  String yRivalry7(String opponent, String score) {
    return '$opponent, $score. Ένας ολόκληρος χρόνος υπενθυμίσεων γι\' αυτό.';
  }

  @override
  String yInjuryBlow0(String name) {
    return 'Ο $name βγήκε τραυματίας. Αυτό ήταν το τελευταίο που χρειαζόταν η ομάδα.';
  }

  @override
  String yInjuryBlow1(String name) {
    return 'Η απώλεια του $name αλλάζει το σχήμα των πάντων.';
  }

  @override
  String yInjuryBlow2(String name) {
    return 'Ο $name κουτσαίνει. Κρατήστε την ανάσα σας.';
  }

  @override
  String yInjuryBlow3(String name) {
    return 'Χωρίς τον $name για λίγο, λοιπόν. Κάποιος πρέπει να πάρει τα ηνία.';
  }

  @override
  String yInjuryBlow4(String name) {
    return 'Εκτός ο $name. Φυσικά ο $name.';
  }

  @override
  String yInjuryBlow5(String name) {
    return 'Χωρίς τον $name αυτή γίνεται μια πολύ συνηθισμένη ομάδα.';
  }

  @override
  String yInjuryBlow6(String name) {
    return 'Πάλι τραυματίας ο $name. Κάποιος πρέπει να ρωτά γιατί.';
  }

  @override
  String yInjuryBlow7(String name) {
    return 'Χάσαμε τον $name και δεν υπάρχει κανείς πίσω του. Αυτό είναι το πραγματικό πρόβλημα.';
  }

  @override
  String ySentOff0(String name, String minute) {
    return 'Κόκκινη στον $name στο $minute\' και όλη η χώρα στρέφεται εναντίον του. Μας έχει δώσει περισσότερα από τους περισσότερους. Αφήστε τον.';
  }

  @override
  String ySentOff1(String name, String minute) {
    return 'Αποβολή του $name στο $minute\'. Σκληρό. Δέκα παίκτες και πάλι παλέψαμε, που λέει πολλά.';
  }

  @override
  String ySentOff2(String name, String minute) {
    return '$name, $minute\', κόκκινη κάρτα. Δέκα παίκτες από εκεί και πέρα.';
  }

  @override
  String ySentOff3(String name, String minute) {
    return 'Αποβολή: $name στο $minute\'. Όχι ο πρώτος αγώνας που κρίνεται από μία απόφαση.';
  }

  @override
  String ySentOff4(String name, String minute) {
    return 'Υπέροχα. Ο $name αποβάλλεται στο $minute\' και μένουμε δέκα. Πάλι.';
  }

  @override
  String ySentOff5(String name, String minute) {
    return 'Ο $name αποβλήθηκε στο $minute\'. Ποιος ακριβώς προπονεί την πειθαρχία εδώ μέσα;';
  }

  @override
  String ySentOff6(String name, String minute) {
    return '$minute λεπτά. Τόσο κράτησε ο $name την ψυχραιμία του. Επαγγελματικό ποδόσφαιρο.';
  }

  @override
  String ySentOff7(String name, String minute) {
    return 'Κόκκινη στον $name στο $minute\', και υποτίθεται ότι πρέπει να πιστέψω ότι αυτό είναι πρόοδος.';
  }

  @override
  String get yBoardPressure0 =>
      'Η διοίκηση έχει σωπάσει εντελώς. Ποτέ καλό σημάδι.';

  @override
  String get yBoardPressure1 =>
      'Φήμες λένε ότι στο γραφείο της διοίκησης άρχισαν να γίνονται ερωτήσεις.';

  @override
  String get yBoardPressure2 =>
      'Νιώθεις το έδαφος να μετακινείται στον επάνω όροφο.';

  @override
  String get yBoardPressure3 =>
      'Κανείς στην ομοσπονδία δεν λέει κάτι υποστηρικτικό. Βγάλε τα δικά σου συμπεράσματα.';

  @override
  String get yBoardPressure4 =>
      'Κανείς στον επάνω όροφο δεν τον έχει στηρίξει δημόσια εδώ και εβδομάδες.';

  @override
  String get yBoardPressure5 =>
      'Η ομοσπονδία κάνει παρασκηνιακή ενημέρωση εναντίον του δικού της προπονητή. Όπως πάντα.';

  @override
  String get yBoardPressure6 =>
      'Όταν μια διοίκηση σωπαίνει, έχει ήδη αποφασίσει.';

  @override
  String get yBoardPressure7 =>
      'Θα το αφήσουν να παρασυρθεί μέχρι να είναι η απόφαση κάποιου άλλου.';

  @override
  String get yReplies => 'ΕΠΙΣΗΣ ΓΙΑ ΑΥΤΟΝ ΤΟΝ ΑΓΩΝΑ';

  @override
  String get yPlayerGrievance0 =>
      'Ρώτησα πού βρίσκομαι. Περιμένω ακόμα απάντηση.';

  @override
  String get yPlayerGrievance1 =>
      'Προπονούμαι σκληρά. Δεν μπορώ να κάνω και πολλά άλλα.';

  @override
  String get yPlayerGrievance2 => 'Κάποιες ερωτήσεις τις κάνεις μόνο μία φορά.';

  @override
  String get yPlayerGrievance3 =>
      'Δεν έφτασα ως εδώ για να κουβαλάω τα γιλέκα της προπόνησης.';

  @override
  String get playerHonoursTitle => 'ΤΙΤΛΟΙ';

  @override
  String get awardGoldenBall => 'Χρυσή Μπάλα';

  @override
  String get awardGoldenBoot => 'Χρυσή Μπότα';

  @override
  String get awardGoldenGlove => 'Χρυσό Γάντι';

  @override
  String get awardTeamOfTournament => 'Ομάδα του Τουρνουά';

  @override
  String get awardPlayerOfYear => 'Παίκτης της Χρονιάς στον Κόσμο';

  @override
  String get awardYoungPlayerOfYear => 'Νέος Παίκτης της Χρονιάς';

  @override
  String get playerClubHistory => 'ΙΣΤΟΡΙΚΟ ΣΥΛΛΟΓΩΝ';

  @override
  String get playerCareerRecord => 'ΣΤΑΤΙΣΤΙΚΑ ΚΑΡΙΕΡΑΣ';

  @override
  String get playerInternationalGoals => 'Γκολ με την εθνική';

  @override
  String get playerRecentForm => 'ΤΕΛΕΥΤΑΙΑ ΦΟΡΜΑ';

  @override
  String get playerMatchHistory => 'ΙΣΤΟΡΙΚΟ ΑΓΩΝΩΝ';

  @override
  String get playerAttributes => 'ΧΑΡΑΚΤΗΡΙΣΤΙΚΑ';

  @override
  String get playerUnknown => 'Άγνωστο';

  @override
  String get playerAttrPace => 'Ταχύτητα';

  @override
  String get playerAttrPhysical => 'Σωματικά';

  @override
  String get playerAttrTechnical => 'Τεχνικά';

  @override
  String get playerAttrShooting => 'Σουτ';

  @override
  String get playerAttrPassing => 'Πάσες';

  @override
  String get playerAttrDribbling => 'Ντρίμπλα';

  @override
  String get playerAttrTackling => 'Μαρκάρισμα';

  @override
  String get playerAttrPositioning => 'Τοποθέτηση';

  @override
  String get playerAttrComposure => 'Ψυχραιμία';

  @override
  String get playerAttrDecisions => 'Αποφάσεις';

  @override
  String get playerAttrStamina => 'Αντοχή';

  @override
  String get playerAttrStrength => 'Δύναμη';

  @override
  String get playerStatCaps => 'Συμμετοχές';

  @override
  String get playerStatGoals => 'Γκολ';

  @override
  String get playerStatAssists => 'Ασίστ';

  @override
  String get playerStatAvgRating => 'Μέση βαθμολογία';

  @override
  String get playerStatForm => 'Φόρμα';

  @override
  String get playerStatMotm => 'Κορυφαίος αγώνα';

  @override
  String get playerStatCleanSheets => 'Μηδέν παθητικό';

  @override
  String get playerStatBestGame => 'Καλύτερος αγώνας';

  @override
  String get playerStatCards => 'Κάρτες';

  @override
  String playerCardsValue(int yellows, int reds) {
    return '$yellows κίτρ. $reds κόκκ.';
  }

  @override
  String get tourSharedYourRun => 'Η ΕΚΣΤΡΑΤΕΙΑ ΣΟΥ';

  @override
  String get tourSharedList => 'Λίστα';

  @override
  String get tourSharedBracket => 'Πίνακας';

  @override
  String get tourSharedVs => 'vs';

  @override
  String tourSharedGroupSeed(String seed) {
    return 'Όμιλος $seed';
  }

  @override
  String get tourSharedThisEdition => 'Αυτή η διοργάνωση';

  @override
  String get tourSharedAllTime => 'Όλων των εποχών';

  @override
  String get tourSharedUnknown => 'Άγνωστος';

  @override
  String get tourSharedActive => 'ΕΝΕΡΓΟΣ';

  @override
  String get tourSharedMedalTable => 'ΠΙΝΑΚΑΣ ΜΕΤΑΛΛΙΩΝ';

  @override
  String get tourSharedPastWinners => 'ΠΡΟΗΓΟΥΜΕΝΟΙ ΝΙΚΗΤΕΣ';

  @override
  String tourSharedHost(String host) {
    return 'Οικοδεσπότης: $host';
  }

  @override
  String get tourSharedBeat => 'νίκησε';

  @override
  String get tourSharedPens => ' (πέναλτι)';

  @override
  String get tourSharedAwardsEmpty =>
      'Τα βραβεία αποφασίζονται όταν ολοκληρωθεί το τουρνουά.';

  @override
  String get tourSharedGoldenBall => 'ΧΡΥΣΗ ΜΠΑΛΑ';

  @override
  String get tourSharedPlayerOfTournament => 'Κορυφαίος παίκτης του τουρνουά';

  @override
  String get tourSharedGoldenBoot => 'ΧΡΥΣΗ ΜΠΟΤΑ';

  @override
  String tourSharedGoalsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count γκολ',
      one: '1 γκολ',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedGoldenGlove => 'ΧΡΥΣΟ ΓΑΝΤΙ';

  @override
  String get tourSharedTeamOfTournament => 'ΟΜΑΔΑ ΤΟΥ ΤΟΥΡΝΟΥΑ';

  @override
  String get tourSharedStatsEmpty =>
      'Τα ρεκόρ εμφανίζονται όταν η διοργάνωση αποκτήσει ιστορία.';

  @override
  String get tourSharedRecordScorer => 'ΡΕΚΟΡΜΕΝ ΣΚΟΡΕΡ';

  @override
  String get tourSharedStillActive => 'ακόμα ενεργός';

  @override
  String get tourSharedMostTitles => 'ΠΕΡΙΣΣΟΤΕΡΟΙ ΤΙΤΛΟΙ';

  @override
  String tourSharedTitlesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count τίτλοι',
      one: '1 τίτλος',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostFinals => 'ΠΕΡΙΣΣΟΤΕΡΟΙ ΤΕΛΙΚΟΙ';

  @override
  String tourSharedFinalsContested(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count τελικοί',
      one: '1 τελικός',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostGamesPlayed => 'ΠΕΡΙΣΣΟΤΕΡΟΙ ΑΓΩΝΕΣ';

  @override
  String tourSharedMatchesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count αγώνες',
      one: '1 αγώνας',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostFinalsPlayed => 'ΠΕΡΙΣΣΟΤΕΡΕΣ ΤΕΛΙΚΕΣ ΦΑΣΕΙΣ';

  @override
  String tourSharedFinalsTournamentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count τελικές φάσεις',
      one: '1 τελική φάση',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedBiggestFinalWin => 'ΜΕΓΑΛΥΤΕΡΗ ΝΙΚΗ ΣΕ ΤΕΛΙΚΟ';

  @override
  String tourStatsGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count γκολ',
      one: '1 γκολ',
    );
    return '$_temp0';
  }

  @override
  String get tourStatsStillActive => 'ακόμα ενεργός';

  @override
  String tourStatsTitles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count τίτλοι',
      one: '1 τίτλος',
    );
    return '$_temp0';
  }

  @override
  String tourStatsFinalsContested(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count τελικοί',
      one: '1 τελικός',
    );
    return '$_temp0';
  }

  @override
  String tourStatsMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count αγώνες',
      one: '1 αγώνας',
    );
    return '$_temp0';
  }

  @override
  String tourStatsFinalsTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count τελικές φάσεις',
      one: '1 τελική φάση',
    );
    return '$_temp0';
  }

  @override
  String get tourStatsLeaders => 'ΚΟΡΥΦΑΙΟΙ ΟΛΩΝ ΤΩΝ ΕΠΟΧΩΝ';

  @override
  String get tourStatsTabGames => 'Αγώνες';

  @override
  String get tourStatsTabCups => 'Διοργανώσεις';

  @override
  String get tourStatsTabScorers => 'Σκόρερ';

  @override
  String tourSharedFinalWinDetail(String opponent, int year) {
    return 'Αντίπαλος: $opponent · $year';
  }

  @override
  String get tourHolders => 'ΚΑΤΟΧΟΣ';

  @override
  String tourHoldersSince(int year) {
    return 'κατέκτησε το $year';
  }

  @override
  String get tourSharedAllTimeScorers => 'ΣΚΟΡΕΡ ΟΛΩΝ ΤΩΝ ΕΠΟΧΩΝ';

  @override
  String get tourSharedSummaryEmpty =>
      'Ο οικοδεσπότης και τα γήπεδα εμφανίζονται όταν κληρωθεί η διοργάνωση.';

  @override
  String get tourSharedHostHeading => 'ΟΙΚΟΔΕΣΠΟΤΗΣ';

  @override
  String get tourSharedHostsHeading => 'ΟΙΚΟΔΕΣΠΟΤΕΣ';

  @override
  String get tourSharedCoHostsHeading => 'ΣΥΝΔΙΟΡΓΑΝΩΤΕΣ';

  @override
  String get tourSharedVenues => 'ΓΗΠΕΔΑ';

  @override
  String get tourSharedMascot => 'ΜΑΣΚΟΤ';

  @override
  String get tourSharedMatchBall => 'ΜΠΑΛΑ ΑΓΩΝΑ';

  @override
  String tourSharedVenueSeats(String city, String capacity) {
    return '$city · $capacity θέσεις';
  }

  @override
  String get tourSharedCouldNotLoad => 'Δεν φορτώθηκε.';

  @override
  String get tourSharedHostTbc => 'ΟΙΚΟΔΕΣΠΟΤΗΣ ΠΡΟΣ ΕΠΙΒΕΒΑΙΩΣΗ';

  @override
  String get tourSharedFinalsAreHere => 'Η ΤΕΛΙΚΗ ΦΑΣΗ ΞΕΚΙΝΑ';

  @override
  String tourSharedHostedBy(String hosts) {
    return 'ΟΙΚΟΔΕΣΠΟΤΗΣ  $hosts';
  }

  @override
  String get tourSharedLetFinalsBegin => 'Ας ξεκινήσει η τελική φάση';

  @override
  String get tourSharedCompetitions => 'ΔΙΟΡΓΑΝΩΣΕΙΣ';

  @override
  String get tourSharedWorldRanking => 'Παγκόσμια κατάταξη';

  @override
  String get tourSharedCouldNotLoadTournaments =>
      'Δεν φορτώθηκαν οι διοργανώσεις.';

  @override
  String get tourSharedPrestigeStage => 'ΜΕΓΑΛΗ ΣΚΗΝΗ';

  @override
  String get tourSharedOverview => 'Επισκόπηση';

  @override
  String get tourSharedWorldRankingTitle => 'Παγκόσμια κατάταξη';

  @override
  String get tourSharedYourCompetitions => 'ΟΙ ΔΙΟΡΓΑΝΩΣΕΙΣ ΣΟΥ';

  @override
  String get tourSharedOtherContinents => 'ΑΛΛΕΣ ΗΠΕΙΡΟΙ';

  @override
  String get tourSharedComingSoon => 'Το τουρνουά έρχεται σύντομα';

  @override
  String get tourSharedSoon => 'ΣΥΝΤΟΜΑ';

  @override
  String get tourSharedNoQualifyingDraw => 'Δεν υπάρχει κλήρωση προκριματικών.';

  @override
  String get tourSharedOpenEnvelope => 'Άνοιξε τον φάκελο';

  @override
  String tourSharedGroupName(String name) {
    return 'ΟΜΙΛΟΣ $name';
  }

  @override
  String get tourSharedBall => 'Μπάλα';

  @override
  String get tourSharedPot => 'Καλάθι';

  @override
  String get tourSharedAll => 'Όλα';

  @override
  String get tourSharedTapDrawTeam => 'Πάτα για να κληρωθεί η επόμενη ομάδα';

  @override
  String get tourSharedTapDrawPot => 'Πάτα για να κληρωθεί το επόμενο καλάθι';

  @override
  String get tourSharedTapDrawAll => 'Πάτα για να δεις ολόκληρη την κλήρωση';

  @override
  String get tourSharedContinue => 'Συνέχεια';

  @override
  String get tourSharedPause => 'Παύση';

  @override
  String get tourSharedPlay => 'Αναπαραγωγή';

  @override
  String get tourSharedSkip => 'Παράλειψη';

  @override
  String tourSharedPotNumber(int number) {
    return 'ΚΑΛΑΘΙ $number';
  }

  @override
  String get tourSharedDrawComplete => 'Η ΚΛΗΡΩΣΗ ΟΛΟΚΛΗΡΩΘΗΚΕ';

  @override
  String get tourSharedDrawing => 'ΚΛΗΡΩΣΗ…';

  @override
  String get tourContChampionship => 'ΠΡΩΤΑΘΛΗΜΑ';

  @override
  String get tourContTabSummary => 'ΣΥΝΟΨΗ';

  @override
  String get tourContTabQualifying => 'ΠΡΟΚΡΙΜΑΤΙΚΑ';

  @override
  String get tourContTabFinals => 'ΤΕΛΙΚΗ ΦΑΣΗ';

  @override
  String get tourContTabBracket => 'ΠΙΝΑΚΑΣ';

  @override
  String get tourContTabAwards => 'ΒΡΑΒΕΙΑ';

  @override
  String get tourContTabScorers => 'ΣΚΟΡΕΡ';

  @override
  String get tourContTabHistory => 'ΙΣΤΟΡΙΚΟ';

  @override
  String get tourContTabRecords => 'ΡΕΚΟΡ';

  @override
  String tourContCouldNotLoadCup(String error) {
    return 'Δεν φορτώθηκε το κύπελλο.\n$error';
  }

  @override
  String get tourContNoCupData => 'Δεν υπάρχουν δεδομένα κυπέλλου.';

  @override
  String get tourContUnknown => 'Άγνωστο';

  @override
  String get tourContGroupsToBeDrawnQual =>
      'Οι όμιλοι των προκριματικών κληρώνονται στην τελετή. Παρακολούθησε από την κεντρική οθόνη για να δεις ποιους θα αντιμετωπίσεις.';

  @override
  String get tourContQualSeeded =>
      'Η χώρα σου μπαίνει απευθείας στην τελική φάση. Δεν υπάρχουν προκριματικά αυτόν τον κύκλο.';

  @override
  String tourContBackgroundRegion(String name) {
    return '$name: προσομοιώνεται στο παρασκήνιο. Τα αποτελέσματα εμφανίζονται εδώ καθώς παίζεται κάθε γύρος.';
  }

  @override
  String get tourContGroupsToBeDrawnFinals =>
      'Οι όμιλοι της τελικής φάσης κληρώνονται στην τελετή. Παρακολούθησε από την κεντρική οθόνη για να δεις τον όμιλό σου.';

  @override
  String get tourContFinalsDrawAfterQual =>
      'Η κλήρωση της τελικής φάσης γίνεται όταν ολοκληρωθούν τα προκριματικά.';

  @override
  String get tourContContestedBeforeWc =>
      'Οι φάσεις νοκ άουτ διεξάγονται πριν από το Παγκόσμιο Πρωτάθλημα.';

  @override
  String tourContChampionsHeading(String name) {
    return 'ΠΡΩΤΑΘΛΗΤΕΣ: $name';
  }

  @override
  String tourContWinnersTitle(String name) {
    return 'Νικητές: $name';
  }

  @override
  String get tourContNoGoalsYet => 'Δεν έχουν πέσει γκολ ακόμα.';

  @override
  String tourContGroupHeading(String name) {
    return 'ΟΜΙΛΟΣ $name';
  }

  @override
  String get tourContBestRunnersUp => 'ΚΑΛΥΤΕΡΟΙ ΔΕΥΤΕΡΟΙ';

  @override
  String tourContGroupDropdown(String name) {
    return 'Όμιλος $name';
  }

  @override
  String get tourContMatches => 'ΑΓΩΝΕΣ';

  @override
  String get tourContNoGroupsDrawn => 'Δεν έχουν κληρωθεί όμιλοι ακόμα.';

  @override
  String get tourContQualifyingDraw => 'ΚΛΗΡΩΣΗ ΠΡΟΚΡΙΜΑΤΙΚΩΝ';

  @override
  String get tourContWorldQualifyingDraw => 'ΠΑΓΚΟΣΜΙΑ ΚΛΗΡΩΣΗ ΠΡΟΚΡΙΜΑΤΙΚΩΝ';

  @override
  String get tourContFinalsDraw => 'ΚΛΗΡΩΣΗ ΤΕΛΙΚΗΣ ΦΑΣΗΣ';

  @override
  String get tourContSeedingPots => 'ΚΑΛΑΘΙΑ ΚΛΗΡΩΣΗΣ';

  @override
  String get tourContGroupDraw => 'ΚΛΗΡΩΣΗ ΟΜΙΛΩΝ';

  @override
  String tourContCouldNotLoadDraw(String error) {
    return 'Δεν φορτώθηκε η κλήρωση.\n$error';
  }

  @override
  String get tourContDrawNotReady => 'Η κλήρωση δεν είναι έτοιμη ακόμα.';

  @override
  String get tourContContinentalClash => 'ΗΠΕΙΡΩΤΙΚΗ ΑΝΑΜΕΤΡΗΣΗ';

  @override
  String get tourContTabThisCycle => 'ΑΥΤΟΣ Ο ΚΥΚΛΟΣ';

  @override
  String tourContCouldNotLoadClash(String error) {
    return 'Η φόρτωση απέτυχε.\n$error';
  }

  @override
  String get tourContNoSaveFound => 'Η αποθήκευση δεν βρέθηκε.';

  @override
  String get tourContClashSoon =>
      'Η Ηπειρωτική Αναμέτρηση διεξάγεται μόλις γίνουν γνωστοί και οι δύο ηπειρωτικοί πρωταθλητές.';

  @override
  String get tourContTwoContinentsOneMatch => 'ΔΥΟ ΗΠΕΙΡΟΙ, ΕΝΑΣ ΑΓΩΝΑΣ';

  @override
  String get tourContVersusShort => 'vs';

  @override
  String tourContWinTheClash(String name) {
    return '$name κερδίζει την Αναμέτρηση';
  }

  @override
  String get tourContNoClashYet =>
      'Δεν έχει διεξαχθεί ακόμα Ηπειρωτική Αναμέτρηση.';

  @override
  String get tourContNationsCup => 'ΚΥΠΕΛΛΟ ΕΘΝΩΝ';

  @override
  String get tourContTabLeagues => 'ΚΑΤΗΓΟΡΙΕΣ';

  @override
  String get tourContTabFinalsFour => 'ΤΕΛΙΚΗ ΤΕΤΡΑΔΑ';

  @override
  String tourContCouldNotLoad(String error) {
    return 'Η φόρτωση απέτυχε.\n$error';
  }

  @override
  String get tourContNoNationsCupGoals =>
      'Δεν έχουν καταγραφεί ακόμα γκολ στο Κύπελλο Εθνών.';

  @override
  String get tourContNoNationsCupChampions =>
      'Δεν έχει αναδειχθεί ακόμα πρωταθλητής στο Κύπελλο Εθνών.';

  @override
  String get tourContNationsCupOffSeason =>
      'Το Κύπελλο Εθνών αυτού του κύκλου ξεκινά μετά τους ηπειρωτικούς τελικούς. Οι προηγούμενοι νικητές είναι στο Ιστορικό.';

  @override
  String get tourContNationsCupGroupsSoon =>
      'Οι όμιλοι του Κυπέλλου Εθνών αυτού του κύκλου κληρώνονται στην τελετή. Παρακολούθησέ την από την κεντρική οθόνη για να δεις ποιους θα αντιμετωπίσεις.';

  @override
  String get tourContLeagueNoGroups =>
      'Δεν υπάρχουν αγώνες σε αυτή την κατηγορία αυτόν τον γύρο.';

  @override
  String tourContLeagueHeading(String letter) {
    return 'ΚΑΤΗΓΟΡΙΑ $letter';
  }

  @override
  String tourContLeagueHeadingYours(String letter) {
    return 'ΚΑΤΗΓΟΡΙΑ $letter · Η ΔΙΚΗ ΣΟΥ';
  }

  @override
  String get tourContFinalsFourSoon =>
      'Στην Τελική Τετράδα παίζουν οι νικητές των ομίλων της Κατηγορίας Α μόλις τελειώσει η φάση των ομίλων.';

  @override
  String tourContLeagueChip(String letter) {
    return 'Κατηγορία $letter';
  }

  @override
  String tourContLeagueChipStar(String letter) {
    return 'Κατηγορία $letter ★';
  }

  @override
  String get tourContSemiFinals => 'ΗΜΙΤΕΛΙΚΟΙ';

  @override
  String get tourContFinal => 'ΤΕΛΙΚΟΣ';

  @override
  String get tourContNationsCupDraw => 'ΚΛΗΡΩΣΗ ΚΥΠΕΛΛΟΥ ΕΘΝΩΝ';

  @override
  String get tourContIntercontinentalPlayoff => 'ΔΙΗΠΕΙΡΩΤΙΚΟ ΜΠΑΡΑΖ';

  @override
  String get tourContNoPlayoffThisCycle =>
      'Δεν υπάρχει μπαράζ αυτόν τον κύκλο.';

  @override
  String get tourContPlayoffIntro =>
      'Δύο θέσεις στο Παγκόσμιο Πρωτάθλημα κρίνονται σε νοκ άουτ μεταξύ των καλύτερων ομάδων που έμειναν εκτός στα προκριματικά.';

  @override
  String get tourContPlayoffThrough =>
      'Πέρασες το μπαράζ. Είσαι στο Παγκόσμιο Πρωτάθλημα!';

  @override
  String get tourContPlayoffOut =>
      'Έμεινες εκτός στο μπαράζ. Όχι Παγκόσμιο Πρωτάθλημα αυτή τη φορά.';

  @override
  String get tourContContinue => 'Συνέχεια';

  @override
  String get tourContPlayoffFinals => 'ΤΕΛΙΚΟΙ ΜΠΑΡΑΖ';

  @override
  String get tourContPlayoffSeeded => 'Κεφαλή (πάσο)';

  @override
  String get tourCupTabSummary => 'ΣΥΝΟΨΗ';

  @override
  String get tourCupTabQualifying => 'ΠΡΟΚΡΙΜΑΤΙΚΑ';

  @override
  String get tourCupTabPlayoff => 'ΜΠΑΡΑΖ';

  @override
  String get tourCupPlayoffSoon =>
      'Το διηπειρωτικό μπαράζ κρίνεται όταν ολοκληρωθούν τα προκριματικά κάθε συνομοσπονδίας.';

  @override
  String get tourCupTabFinals => 'ΤΕΛΙΚΗ ΦΑΣΗ';

  @override
  String get tourCupTabBracket => 'ΠΙΝΑΚΑΣ';

  @override
  String get tourCupTabAwards => 'ΒΡΑΒΕΙΑ';

  @override
  String get tourCupTabScorers => 'ΣΚΟΡΕΡ';

  @override
  String get tourCupTabHistory => 'ΙΣΤΟΡΙΚΟ';

  @override
  String get tourCupTabRecords => 'ΡΕΚΟΡ';

  @override
  String get tourCupTitle => 'ΠΑΓΚΟΣΜΙΟ ΠΡΩΤΑΘΛΗΜΑ';

  @override
  String get tourCupNoData => 'Δεν υπάρχουν στοιχεία διοργάνωσης.';

  @override
  String tourCupLoadError(String error) {
    return 'Η φόρτωση της διοργάνωσης απέτυχε.\n$error';
  }

  @override
  String get tourCupUnknown => 'Άγνωστο';

  @override
  String get tourCupWorldChampions => 'ΠΑΓΚΟΣΜΙΟΙ ΠΡΩΤΑΘΛΗΤΕΣ';

  @override
  String get tourCupWorldChampionsTitle => 'Παγκόσμιοι Πρωταθλητές';

  @override
  String get tourCupStillActive => 'Ακόμα ενεργός';

  @override
  String get tourCupAllTimeScorers => 'ΠΡΩΤΟΙ ΣΚΟΡΕΡ ΟΛΩΝ ΤΩΝ ΕΠΟΧΩΝ';

  @override
  String get tourCupAllConfederations => 'Όλες οι συνομοσπονδίες';

  @override
  String get tourCupBestRunnersUp => 'Καλύτεροι φιναλίστ';

  @override
  String get tourCupCompWorld => 'Παγκόσμιο Πρωτάθλημα';

  @override
  String get tourCupCompEurope => 'Ευρωπαϊκό Πρωτάθλημα';

  @override
  String get tourCupCompSAmerica => 'Πρωτάθλημα Νότιας Αμερικής';

  @override
  String get tourCupDestRoundOf16 => 'στη φάση των 16';

  @override
  String get tourCupDestKnockouts => 'στα νοκ άουτ';

  @override
  String get tourCupDestFinals => 'στην τελική φάση';

  @override
  String get tourCupDestFinalsPlayoff => 'στο μπαράζ της τελικής φάσης';

  @override
  String get tourCupDestIntercontPlayoff => 'στο διηπειρωτικό μπαράζ';

  @override
  String get tourCupFinalsDrawnAfterQual =>
      'Η κλήρωση της τελικής φάσης γίνεται μόλις τελειώσουν τα προκριματικά.';

  @override
  String get tourCupFinalsDrawSoon =>
      'Οι όμιλοι θα κληρωθούν. Παρακολούθησε την κλήρωση του Παγκοσμίου Πρωταθλήματος από την κεντρική οθόνη για να τους δεις.';

  @override
  String tourCupGroupName(String name) {
    return 'Όμιλος $name';
  }

  @override
  String tourCupGroupNameShort(String name) {
    return 'Όμιλος $name';
  }

  @override
  String tourCupHostLabel(String host) {
    return 'Διοργάνωση: $host';
  }

  @override
  String tourCupHostLabelMulti(String hosts) {
    return 'Διοργάνωση: $hosts';
  }

  @override
  String get tourCupIntercontPlayoff => 'Διηπειρωτικό μπαράζ';

  @override
  String get tourCupKnockoutSoon =>
      'Ο πίνακας ξεκινά μόλις τελειώσει η φάση των ομίλων.';

  @override
  String get tourCupMatches => 'ΑΓΩΝΕΣ';

  @override
  String get tourCupMedalTable => 'ΠΙΝΑΚΑΣ ΜΕΤΑΛΛΙΩΝ';

  @override
  String get tourCupMostTitles => 'ΠΕΡΙΣΣΟΤΕΡΟΙ ΤΙΤΛΟΙ';

  @override
  String tourCupMostTitlesValue(String nation, int titles, int editions) {
    return '$nation: $titles τίτλοι σε $editions διοργανώσεις';
  }

  @override
  String get tourCupNoGoals => 'Κανένα γκολ ακόμα.';

  @override
  String get tourCupNoGroups => 'Δεν έχουν κληρωθεί όμιλοι.';

  @override
  String get tourCupNoHistory => 'Κανένα ιστορικό ακόμα.';

  @override
  String get tourCupPastWinners => 'ΠΡΟΗΓΟΥΜΕΝΟΙ ΝΙΚΗΤΕΣ';

  @override
  String get tourCupPlayoffIntro =>
      'Δύο θέσεις στο Παγκόσμιο Πρωτάθλημα κρίνονται σε νοκ άουτ μεταξύ των καλύτερων ομάδων που έμειναν εκτός στα προκριματικά.';

  @override
  String tourCupPlayoffNoEntrants(String confederation) {
    return '$confederation: δεν υπάρχει μπαράζ. Όλες οι θέσεις κρίνονται στους προκριματικούς ομίλους.';
  }

  @override
  String get tourCupQualDrawSoon =>
      'Οι όμιλοι θα κληρωθούν. Παρακολούθησε την κλήρωση των προκριματικών από την κεντρική οθόνη για να τους δεις.';

  @override
  String tourCupRegionYours(String region) {
    return '$region · δική σου';
  }

  @override
  String tourCupScorePens(int home, int away) {
    return '$home–$away (πεν.)';
  }

  @override
  String get tourCupSegAllTime => 'Όλων των εποχών';

  @override
  String get tourCupSegFinals => 'Τελική φάση';

  @override
  String get tourCupSegQualifying => 'Προκριματικά';

  @override
  String get playerTraitsTitle => 'ΓΝΩΣΤΟΣ ΓΙΑ';

  @override
  String get traitBigGame => 'Παίκτης των μεγάλων αγώνων';

  @override
  String get traitBigGameBlurb => 'Ανεβάζει το επίπεδό του στα νοκ άουτ.';

  @override
  String get traitSetPiece => 'Ειδικός στις στατικές φάσεις';

  @override
  String get traitSetPieceBlurb =>
      'Καλύτερη εκτέλεση και περισσότερα γκολ από στατικές φάσεις.';

  @override
  String get traitHothead => 'Θερμοκέφαλος';

  @override
  String get traitHotheadBlurb =>
      'Παίρνει πολύ περισσότερες κάρτες από τους συμπαίκτες του.';

  @override
  String get traitIronMan => 'Σιδεράς';

  @override
  String get traitIronManBlurb =>
      'Σπάνια τραυματίζεται και κουράζεται πιο αργά.';

  @override
  String get traitWonderkid => 'Φαινόμενο';

  @override
  String get traitWonderkidBlurb =>
      'Νέος, ήδη καλός και συνεχίζει να βελτιώνεται γρήγορα.';

  @override
  String get traitLeader => 'Ηγέτης';

  @override
  String get traitLeaderBlurb => 'Ανεβάζει κάθε συμπαίκτη του στο γήπεδο.';

  @override
  String get traitPacey => 'Ταχύτατος';

  @override
  String get traitPaceyBlurb =>
      'Εκπληκτική ταχύτητα, απειλή πίσω από την άμυνα.';

  @override
  String get traitOldHead => 'Παλιός καπετάνιος';

  @override
  String get traitOldHeadBlurb =>
      'Βετεράνος που διαβάζει το παιχνίδι καλύτερα απ’ ό,τι τον κρατούν τα πόδια του.';

  @override
  String get traitWasteful => 'Σπάταλος';

  @override
  String get traitWastefulBlurb => 'Στέλνει εκτός πολλές καλές ευκαιρίες.';

  @override
  String get objectiveWorldCup => 'Παγκόσμιο Πρωτάθλημα';

  @override
  String get objectiveWinTournament => 'Κατάκτηση τίτλου';

  @override
  String get objectiveQualifyGeneric => 'Πρόκριση';

  @override
  String hubBoardObjectiveFor(String competition, String label) {
    return '$competition: $label';
  }

  @override
  String get objectiveWinWorldCup => 'Κατάκτηση του Παγκοσμίου Πρωταθλήματος';

  @override
  String get objectiveReachFinal => 'Πρόκριση στον τελικό';

  @override
  String get objectiveReachSemis => 'Πρόκριση στους ημιτελικούς';

  @override
  String get objectiveReachQuarters => 'Πρόκριση στους προημιτελικούς';

  @override
  String get objectiveReachKnockouts => 'Πρόκριση στα νοκ άουτ';

  @override
  String get objectiveQualify => 'Πρόκριση στο Παγκόσμιο Πρωτάθλημα';

  @override
  String get finishChampions => 'Πρωταθλητές';

  @override
  String get finishRunnersUp => 'Φιναλίστ';

  @override
  String get finishSemiFinals => 'Ημιτελικοί';

  @override
  String get finishQuarterFinals => 'Προημιτελικοί';

  @override
  String get finishRoundOf16 => 'Φάση των 16';

  @override
  String get finishGroupStage => 'Φάση των ομίλων';

  @override
  String get objectiveQualifyingTopHalf =>
      'Τερματισμός στο πάνω μισό των προκριματικών';

  @override
  String get finishQualifyingTopHalf => 'Πάνω μισό του ομίλου προκριματικών';

  @override
  String get finishQualifyingBottomHalf => 'Κάτω μισό του ομίλου προκριματικών';

  @override
  String get objectiveNcWinIt => 'Κατάκτηση του Κυπέλλου Εθνών';

  @override
  String get objectiveNcReachFinal => 'Πρόκριση στον τελικό του Κυπέλλου Εθνών';

  @override
  String get objectiveNcFinalsFour => 'Πρόκριση στην Τελική Τετράδα';

  @override
  String get objectiveNcWinGroup => 'Νίκη στον όμιλο και άνοδος';

  @override
  String get objectiveNcTopHalf => 'Τερματισμός στο πάνω μισό του ομίλου';

  @override
  String get objectiveNcSurvive => 'Αποφυγή υποβιβασμού';

  @override
  String get objectiveNcOffTheBottom =>
      'Να μην τερματίσετε τελευταίοι στον όμιλο';

  @override
  String get finishNcChampions => 'Νικητές Κυπέλλου Εθνών';

  @override
  String get finishNcFinalsFour => 'Τελική Τετράδα';

  @override
  String get finishNcGroupWinners => 'Νικητές ομίλου';

  @override
  String get finishNcTopHalf => 'Πάνω μισό του ομίλου';

  @override
  String get finishNcStayedUp => 'Παραμονή στην κατηγορία';

  @override
  String get finishNcClearOfBottom => 'Όχι τελευταίοι στον όμιλο';

  @override
  String get finishNcBottom => 'Τελευταίοι στον όμιλο';

  @override
  String get careerNationsCupLabel => 'Κύπελλο Εθνών';

  @override
  String get squadDevPlayer => 'ΠΑΙΚΤΗΣ';

  @override
  String get squadDevAge => 'ΗΛΙΚΙΑ';

  @override
  String get squadDevPosition => 'ΘΕΣΗ';

  @override
  String get squadDevChange => 'ΒΑΘΜ.';

  @override
  String get squadDevNew => 'ΝΕΟΣ';

  @override
  String get squadDevRetired => 'ΑΠΕΧΩΡΗΣΕ';

  @override
  String get squadDevEmpty => 'Μια ήρεμη χρονιά. Καμία αλλαγή στην αποστολή.';

  @override
  String get squadDevTierRegulars => 'ΒΑΣΙΚΟΙ';

  @override
  String get squadDevTierFringe => 'ΠΕΡΙΘΩΡΙΑΚΟΙ';

  @override
  String get squadDevTierYouth => 'ΝΕΟΙ';

  @override
  String get boardObjectivesTitle => 'Στόχοι της διοίκησης';

  @override
  String get boardObjectivesConfidence => 'Εμπιστοσύνη της διοίκησης';

  @override
  String boardObjectiveBeatenBy(String result, int rounds) {
    String _temp0 = intl.Intl.pluralLogic(
      rounds,
      locale: localeName,
      other: '$rounds γύροι καλύτερα απ’ ό,τι ζητήθηκε',
      one: 'ένας γύρος καλύτερα απ’ ό,τι ζητήθηκε',
    );
    return '$result: $_temp0';
  }

  @override
  String boardObjectiveShortBy(String result, int rounds) {
    String _temp0 = intl.Intl.pluralLogic(
      rounds,
      locale: localeName,
      other: '$rounds γύροι λιγότερο',
      one: 'ένας γύρος λιγότερο',
    );
    return '$result: $_temp0';
  }

  @override
  String get boardObjectivesPending => 'ΘΑ ΚΡΙΘΕΙ ΑΡΓΟΤΕΡΑ';

  @override
  String boardObjectiveSoFar(String result) {
    return 'ΜΕΧΡΙ ΤΩΡΑ · $result';
  }

  @override
  String get boardObjectivesEmpty =>
      'Η διοίκηση δεν έχει θέσει στόχο για αυτόν τον κύκλο.';

  @override
  String get tourContBestWinners => 'ΚΑΛΥΤΕΡΟΙ ΝΙΚΗΤΕΣ ΟΜΙΛΩΝ';

  @override
  String get tourContBestThirds => 'ΚΑΛΥΤΕΡΟΙ ΤΡΙΤΟΙ';

  @override
  String tourContBestPlaced(String position) {
    return 'ΚΑΛΥΤΕΡΟΙ ΣΤΗ ΘΕΣΗ $position';
  }

  @override
  String squadDevPageOf(String page, String pages, String total) {
    return '$page/$pages · $total παίκτες';
  }

  @override
  String get matchSoldOut => 'ΠΛΗΡΕΣ';

  @override
  String matchAttendanceOf(String attendance, String capacity) {
    return '$attendance από $capacity θέσεις κατειλημμένες';
  }

  @override
  String get matchGroundTitle => 'ΓΗΠΕΔΟ';

  @override
  String get absenceInjured => 'Τραυματίας';

  @override
  String get absenceSuspended => 'Τιμωρημένος';

  @override
  String absenceWeeks(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString εβδομάδες',
      one: '1 εβδομάδα',
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
      other: '$countString αγώνες',
      one: '1 αγώνας',
    );
    return '$_temp0';
  }

  @override
  String absenceBackFor(String opponent) {
    return 'Επιστρέφει για τον αγώνα με αντίπαλο: $opponent';
  }

  @override
  String get penaltyOrderTitle => 'Πέναλτι';

  @override
  String get penaltyOrderBlurb =>
      'Όρισε τους πέντε εκτελεστές, με τη σειρά. Πάτα μια θέση για να την αλλάξεις.';

  @override
  String penaltyOrderPick(int number) {
    return 'Εκτέλεση $number';
  }

  @override
  String get penaltyOrderPickBlurb =>
      'Διάλεξε ποιος θα βγει μπροστά. Η μπάρα δείχνει την ψυχραιμία του στην άσπρη βούλα.';

  @override
  String get penaltyOrderConfirm => 'Εκτέλεση';

  @override
  String get penaltyOrderCancel => 'Πίσω';

  @override
  String get youthTitle => 'Νέοι';

  @override
  String get youthEmptyLevel => 'Κανείς σε αυτό το επίπεδο ακόμα.';

  @override
  String get youthReleased => 'Αποχωρήσεις φέτος';

  @override
  String get u21Title => 'Κάτω των 21';

  @override
  String get u21Blurb =>
      'Η επόμενη γενιά, με πρώτο το καλύτερο ταλέντο. Τα κούφια αστέρια είναι εκτίμηση του σκάουτ. Δώσε του συμμετοχή για να μάθεις τι αξίζει πραγματικά.';

  @override
  String get u21Empty =>
      'Κανείς κάτω των 21 στη δεξαμενή αυτή τη στιγμή. Η επόμενη φουρνιά έρχεται με τον νέο κύκλο.';

  @override
  String u21Breakout(int gain) {
    return '+$gain ΦΕΤΟΣ';
  }

  @override
  String u21AgeCaps(int age, int caps) {
    return 'Ηλικία $age · $caps συμμετοχές';
  }

  @override
  String u21AgeUncapped(int age) {
    return 'Ηλικία $age · χωρίς συμμετοχή';
  }

  @override
  String get u21CallUps => 'Μετάβαση στις κλήσεις';

  @override
  String get youthWatching => 'Υπό παρακολούθηση';

  @override
  String get youthWatchEmpty =>
      'Κανείς δεν έχει σημειωθεί ακόμα. Σημείωσε έναν νεαρό σε οποιοδήποτε επίπεδο και θα εμφανιστεί εδώ, μαζί με το τι έγινε από τότε.';

  @override
  String get youthWatchMark => 'Παρακολούθηση του παίκτη';

  @override
  String get youthWatchUnmark => 'Διακοπή παρακολούθησης';

  @override
  String youthWatchMarked(int rating, int age) {
    return 'Σημειώθηκε με $rating, ηλικίας $age';
  }

  @override
  String get youthWatchSenior => 'Πέρασε στη δεξαμενή των ανδρών';

  @override
  String get youthWatchReleased => 'Αποχώρησε από την ακαδημία';

  @override
  String get youthWatchGone => 'Δεν είναι πια στην πυραμίδα';

  @override
  String get tacticsYouth => 'Κάτω των 21';

  @override
  String get pressSquad => 'Αποστολή';

  @override
  String get pressBoard => 'Διοίκηση';

  @override
  String get pressNoEffect => 'Κανείς δεν δίνει σημασία';

  @override
  String get matchNeutralGround => 'ΟΥΔΕΤΕΡΟ';

  @override
  String get matchExtraTimeAhead => 'ΠΑΡΑΤΑΣΗ';

  @override
  String get matchExtraTimeHalf => 'ΠΑΡΑΤΑΣΗ · ΗΜΙΧΡΟΝΟ';

  @override
  String get matchClockFullTime => 'ΤΕΛΟΣ ΑΓΩΝΑ';

  @override
  String get matchClockAfterExtraTime => 'ΜΕΤΑ ΤΗΝ ΠΑΡΑΤΑΣΗ';

  @override
  String get matchClockPenalties => 'ΠΕΝΑΛΤΙ';

  @override
  String get matchClockFullTimePenalties => 'ΤΕΛΟΣ · ΠΕΝΑΛΤΙ';

  @override
  String get hubEventPressConference => 'Συνέντευξη Τύπου';

  @override
  String get hubEventPressConferenceSub =>
      'Τα ΜΜΕ όλου του κόσμου θέλουν να σου μιλήσουν πριν από τον πρώτο αγώνα';

  @override
  String get squadDevWonderkid => 'ΦΑΙΝΟΜΕΝΟ';

  @override
  String get tacticsPlaystyle => 'Στυλ παιχνιδιού';

  @override
  String get tacticsPlaystyleBlurb =>
      'Διάλεξε πώς παίζει η ομάδα. Οι ρυθμίσεις από κάτω το προσαρμόζουν λεπτομερώς.';

  @override
  String get tacticsPlaystyleCustom =>
      'Δικές σου ρυθμίσεις. Κανένα στυλ δεν ταιριάζει με αυτές τις ρυθμίσεις.';

  @override
  String get playstyleCustom => 'Προσαρμοσμένο';

  @override
  String get playstyleBalanced => 'Ισορροπημένο';

  @override
  String get playstylePossession => 'Κατοχή';

  @override
  String get playstyleGegenpress => 'Γκεγκενπρες';

  @override
  String get playstyleCounter => 'Αντεπίθεση';

  @override
  String get playstyleDirect => 'Άμεσο';

  @override
  String get playstyleLowBlock => 'Χαμηλό μπλοκ';

  @override
  String get playstyleWingPlay => 'Παιχνίδι στα πλάγια';

  @override
  String get playstyleBalancedBlurb =>
      'Σταθερό και στα δύο ημίχρονα, χωρίς υπερβολές.';

  @override
  String get playstylePossessionBlurb =>
      'Κράτα την μπάλα, κινήστε την με υπομονή, στρίμωξε τον αντίπαλο.';

  @override
  String get playstyleGegenpressBlurb =>
      'Ανακτάς την μπάλα τη στιγμή που τη χάνεις, ψηλά στο γήπεδο.';

  @override
  String get playstyleCounterBlurb =>
      'Περιμένεις πίσω, μένεις συμπαγής και μετά βγαίνεις με ταχύτητα.';

  @override
  String get playstyleDirectBlurb =>
      'Μπάλα μπροστά από νωρίς και παιχνίδι για τη δεύτερη μπάλα.';

  @override
  String get playstyleLowBlockBlurb =>
      'Χαμηλά, στενά και πολύ δύσκολα να ξεπεραστείς.';

  @override
  String get playstyleWingPlayBlurb =>
      'Άνοιξε το γήπεδο, βγες απ’ έξω και κάνε σέντρες.';

  @override
  String get nationsRandomTeam => 'Τυχαία ομάδα';

  @override
  String get nationsFromTheBottom => 'Από το μηδέν';

  @override
  String get bottomStartTitle => 'Άνεργος';

  @override
  String get bottomStartHeading => 'Τρεις ομοσπονδίες θέλουν να σου μιλήσουν';

  @override
  String get bottomStartBlurb =>
      'Δεν έχεις δουλειά ούτε φήμη. Αυτές είναι οι μόνες ομάδες που δέχονται να ρισκάρουν μαζί σου. Διάλεξε μία και χτίσε κάτι από το τίποτα.';

  @override
  String get bottomStartAccept => 'Αποδοχή';

  @override
  String get bottomStartBack => 'Πίσω στο μενού';

  @override
  String bottomStartRankOf(int rank, int total) {
    return '$rank από $total στον κόσμο';
  }

  @override
  String get campTitle => 'Στρατόπεδο προετοιμασίας';

  @override
  String campBasedIn(String host) {
    return 'Έδρα: $host';
  }

  @override
  String get campBlurb =>
      'Εκεί που μένει η αποστολή σε όλη τη διάρκεια της διοργάνωσης. Δεν αλλάζει μόλις ξεκινήσει το παιχνίδι και επηρεάζει τρία πράγματα σε κάθε αγώνα: πόσο φρέσκοι φτάνουν, πόσο γρήγορα επουλώνεται ένας τραυματισμός και πόσο σε φόρμα είναι οι παίκτες.';

  @override
  String get campEffectTravel => 'Φρέσκοι στην άφιξη';

  @override
  String get campEffectRecovery => 'Γρήγορη ανάρρωση';

  @override
  String get campEffectSharpness => 'Αγωνιστική ετοιμότητα';

  @override
  String get campTerrainCity => 'Κέντρο πόλης';

  @override
  String get campTerrainCoastal => 'Παραθαλάσσιο θέρετρο';

  @override
  String get campTerrainMountain => 'Ορεινό καταφύγιο';

  @override
  String get campTerrainAltitude => 'Στρατόπεδο υψομέτρου';

  @override
  String get campTerrainNationalCentre => 'Εθνικό κέντρο';

  @override
  String get campTerrainCityBlurb =>
      'Όλα στο κατώφλι και τίποτα να διανύσεις, αλλά καθόλου ησυχία και καμία διαφυγή από τον θόρυβο.';

  @override
  String get campTerrainCoastalBlurb =>
      'Ήρεμο, άνετο και καλό για το κλίμα στην ομάδα, αλλά με μακρύ ταξίδι με πούλμαν προς κάθε γήπεδο.';

  @override
  String get campTerrainMountainBlurb =>
      'Δροσερός αέρας και κορυφαίο ιατρικό τμήμα που γιατρεύει γρήγορα τα χτυπήματα, μακριά όμως από τη διοργάνωση.';

  @override
  String get campTerrainAltitudeBlurb =>
      'Σκληρή προπόνηση και πόδια που αντέχουν βαθιά μέσα στη διοργάνωση.';

  @override
  String get campTerrainNationalCentreBlurb =>
      'Οι εγκαταστάσεις της ίδιας της ομοσπονδίας: τίποτα εντυπωσιακό, τίποτα που να πάει στραβά.';

  @override
  String get hubEventChooseCamp => 'Επιλογή στρατοπέδου';

  @override
  String hubEventChooseCampSub(String host) {
    return 'Πού θα μένει η αποστολή: $host';
  }

  @override
  String get tacticsTabBench => 'Πάγκος';

  @override
  String get squadSearchHint => 'Αναζήτηση με όνομα ή ομάδα';

  @override
  String get squadFilterAll => 'Όλοι';

  @override
  String get squadFilterInSquad => 'Στην αποστολή';

  @override
  String get squadFilterUncapped => 'Χωρίς συμμετοχή';

  @override
  String get squadFilterUnavailable => 'Μη διαθέσιμοι';

  @override
  String get squadLineAll => 'Όλες οι γραμμές';

  @override
  String get squadSortBy => 'Ταξινόμηση';

  @override
  String get squadSortRating => 'Βαθμολογία';

  @override
  String get squadSortCaps => 'Συμμετοχές';

  @override
  String get squadSortGoals => 'Γκολ';

  @override
  String get squadSortAge => 'Ηλικία';

  @override
  String get squadSortName => 'Όνομα';

  @override
  String get squadLegendTitle => 'Τι σημαίνουν τα σημάδια';

  @override
  String get squadLegendStarting => 'Στην ενδεκάδα σου';

  @override
  String get squadLegendCalledUp => 'Κληθείς, στον πάγκο';

  @override
  String get squadLegendRatingUp => 'Βαθμολογία σε άνοδο φέτος';

  @override
  String get squadLegendRatingDown => 'Βαθμολογία σε πτώση φέτος';

  @override
  String get squadLegendInjured => 'Τραυματίας, μη διαθέσιμος';

  @override
  String get squadLegendSuspended => 'Τιμωρημένος, μη διαθέσιμος';

  @override
  String get squadLegendTraits => 'ΓΝΩΣΤΟΣ ΓΙΑ';

  @override
  String squadShowingOf(int shown, int total) {
    return 'Εμφάνιση $shown από $total παίκτες';
  }

  @override
  String get squadNobodyMatches =>
      'Κανένας παίκτης της δεξαμενής δεν ταιριάζει με αυτά τα φίλτρα.';

  @override
  String get squadStatPool => 'Δεξαμενή';

  @override
  String get squadStatInSquad => 'Κληθέντες';

  @override
  String get squadMostCapped => 'Περισσότερες συμμετοχές';

  @override
  String get squadTopScorer => 'Πρώτος σκόρερ';

  @override
  String squadCapsValue(String name, int caps) {
    return '$name · $caps συμμετοχές';
  }

  @override
  String squadGoalsValue(String name, int goals) {
    return '$name · $goals γκολ';
  }

  @override
  String squadAgeClub(int age, String club) {
    return '$age · $club';
  }

  @override
  String get squadCapsShort => 'Συμ.';

  @override
  String get squadGoalsShort => 'Γκολ';

  @override
  String get recordsRecordBookSubtitle =>
      'Συμμετοχές, γκολ και τα βασικά ρεκόρ της ομάδας';

  @override
  String get statsLegacy => 'ΚΛΗΡΟΝΟΜΙΑ';

  @override
  String tacticsSubAlreadyOff(String name) {
    return 'Ο $name έχει ήδη αντικατασταθεί και δεν μπορεί να ξαναμπεί.';
  }

  @override
  String tacticsSubSentOff(String name) {
    return 'Ο $name αποβλήθηκε και δεν συμμετέχει πια στον αγώνα.';
  }

  @override
  String get tacticsInjuredShort => 'ΤΡΑΥΜΑΤΙΑΣ';

  @override
  String get tacticsSuspendedShort => 'ΤΙΜΩΡΗΜΕΝΟΣ';

  @override
  String get confEurope => 'Ευρώπη';

  @override
  String get confSouthAmerica => 'Νότια Αμερική';

  @override
  String get confNorthAmerica => 'Βόρεια Αμερική';

  @override
  String get confAfrica => 'Αφρική';

  @override
  String get confAsia => 'Ασία';

  @override
  String get confOceania => 'Ωκεανία';

  @override
  String get compWorldCup => 'Παγκόσμιο Πρωτάθλημα';

  @override
  String get compWorldCupFinals => 'Τελική Φάση Παγκοσμίου Πρωταθλήματος';

  @override
  String get compWorldCupQualifying => 'Προκριματικά Παγκοσμίου Πρωταθλήματος';

  @override
  String compQualifiers(String region) {
    return '$region: Προκριματικά';
  }

  @override
  String get compFriendlies => 'Φιλικά';

  @override
  String get compNationsCup => 'Κύπελλο Εθνών';

  @override
  String get compContinentalClash => 'Ηπειρωτική Αναμέτρηση';

  @override
  String get compIntercontinentalPlayoff => 'Διηπειρωτικό Μπαράζ';

  @override
  String get compContinentalChampionship => 'Ηπειρωτικό Πρωτάθλημα';

  @override
  String get compEuropeanChampionship => 'Ευρωπαϊκό Πρωτάθλημα';

  @override
  String get compSouthAmericaCup => 'Πρωτάθλημα Νότιας Αμερικής';

  @override
  String get compAfricanChampionship => 'Πρωτάθλημα Αφρικής';

  @override
  String get compAsianChampionship => 'Πρωτάθλημα Ασίας';

  @override
  String get compNorthAmericaCup => 'Πρωτάθλημα Βόρειας Αμερικής';

  @override
  String get compOceaniaCup => 'Κύπελλο Ωκεανίας';

  @override
  String get msgANation => 'Μια χώρα';

  @override
  String get msgAPlayer => 'Ένας παίκτης';

  @override
  String get msgAHostNation => 'μια διοργανώτρια χώρα';

  @override
  String get msgCycleTitle1 => 'Ξεκινά νέος κύκλος';

  @override
  String msgCycleTitle2(int year) {
    return 'Ο δρόμος για το $year ανοίγει';
  }

  @override
  String get msgCycleTitle3 => 'Μια νέα εκστρατεία ξημερώνει';

  @override
  String get msgCycleTitle4 => 'Πίσω στη δουλειά';

  @override
  String msgCycleBody1(int year) {
    return 'Ο δρόμος για το Παγκόσμιο Πρωτάθλημα $year ξεκινά εδώ.';
  }

  @override
  String msgCycleBody2(int year) {
    return 'Νέος κύκλος. Στόχος είναι το Παγκόσμιο Πρωτάθλημα $year.';
  }

  @override
  String msgCycleBody3(int year) {
    return 'Τέσσερα χρόνια μέχρι το Παγκόσμιο Πρωτάθλημα $year. Η δουλειά ξεκινά τώρα.';
  }

  @override
  String msgCycleBody4(int year) {
    return 'Η εκστρατεία του $year ξεκινά σήμερα.';
  }

  @override
  String msgContHostTitle(String cup, String host) {
    return '$cup, διοργάνωση: $host';
  }

  @override
  String msgContHostBody(String host, String cup) {
    return '$cup, επόμενη διοργάνωση: οικοδεσπότης είναι η χώρα $host.';
  }

  @override
  String msgContQualDrawTitle(String cup) {
    return '$cup: κλήρωση προκριματικών';
  }

  @override
  String msgContQualDrawBody(String cup) {
    return '$cup: οι όμιλοι των προκριματικών έχουν κληρωθεί.';
  }

  @override
  String msgWcHostTitle(String host, int year) {
    return 'Παγκόσμιο Πρωτάθλημα $year, διοργάνωση: $host';
  }

  @override
  String msgWcHostBody(String host, int year) {
    return 'Παγκόσμιο Πρωτάθλημα $year: οικοδεσπότης είναι η χώρα $host.';
  }

  @override
  String get msgWcQualDrawTitle =>
      'Κλήρωση προκριματικών Παγκοσμίου Πρωταθλήματος';

  @override
  String get msgWcQualDrawBody =>
      'Οι όμιλοι των προκριματικών του Παγκοσμίου Πρωταθλήματος έχουν κληρωθεί.';

  @override
  String msgContFinalsDrawTitle(String cup) {
    return '$cup: κλήρωση τελικής φάσης';
  }

  @override
  String msgContFinalsDrawBody(String cup) {
    return '$cup: οι όμιλοι της τελικής φάσης έχουν κληρωθεί.';
  }

  @override
  String get msgWcFinalsDrawTitle =>
      'Κλήρωση τελικής φάσης Παγκοσμίου Πρωταθλήματος';

  @override
  String msgWcFinalsDrawBody(int year) {
    return 'Έγινε η κλήρωση της τελικής φάσης του Παγκοσμίου Πρωταθλήματος $year.';
  }

  @override
  String get msgQualWcTitle1 => 'Στο Παγκόσμιο Πρωτάθλημα';

  @override
  String get msgQualWcTitle2 => 'Εισιτήριο για το Παγκόσμιο Πρωτάθλημα';

  @override
  String get msgQualWcTitle3 => 'Πάμε στο Παγκόσμιο Πρωτάθλημα';

  @override
  String get msgQualWcTitle4 => 'Εισιτήριο στο χέρι';

  @override
  String msgQualWcBody1(int year) {
    return 'Προκρίθηκες στην τελική φάση του Παγκοσμίου Πρωταθλήματος $year.';
  }

  @override
  String msgQualWcBody2(int year) {
    return 'Είναι επίσημο: η χώρα σου είναι στο Παγκόσμιο Πρωτάθλημα $year.';
  }

  @override
  String msgQualWcBody3(int year) {
    return 'Η θέση στο Παγκόσμιο Πρωτάθλημα $year είναι δική σου.';
  }

  @override
  String msgQualWcBody4(int year) {
    return 'Πέρασες στην τελική φάση του Παγκοσμίου Πρωταθλήματος $year.';
  }

  @override
  String msgQualContTitle1(String cup) {
    return 'Πρόκριση: $cup';
  }

  @override
  String msgQualContTitle2(String cup) {
    return 'Εισιτήριο: $cup';
  }

  @override
  String msgQualContTitle3(String cup) {
    return 'Πρόκριση στην τελική φάση: $cup';
  }

  @override
  String msgQualContBody1(String cup) {
    return '$cup: προκρίθηκες στην τελική φάση.';
  }

  @override
  String msgQualContBody2(String cup) {
    return '$cup: η χώρα σου κατοχύρωσε τη θέση της.';
  }

  @override
  String msgQualContBody3(String cup) {
    return '$cup: πέρασες στην τελική φάση.';
  }

  @override
  String msgChampTitleMine1(String comp) {
    return 'ΠΡΩΤΑΘΛΗΤΕΣ: $comp!';
  }

  @override
  String msgChampTitleMine2(String comp) {
    return 'Πρωταθλητές: $comp!';
  }

  @override
  String msgChampTitleMine3(String comp) {
    return 'Κέρδισες: $comp!';
  }

  @override
  String msgChampTitleOther1(String comp) {
    return '$comp: κρίθηκε';
  }

  @override
  String msgChampTitleOther2(String comp) {
    return '$comp: ανακηρύχθηκε πρωταθλητής';
  }

  @override
  String msgChampTitleOther3(String comp) {
    return '$comp: έχει νικητή';
  }

  @override
  String msgChampBodyMine1(String comp, String loser, String result, int year) {
    return '$comp $year: η χώρα σου είναι πρωταθλήτρια. $loser ηττήθηκε$result.';
  }

  @override
  String msgChampBodyMine2(String comp, String loser, String result, int year) {
    return 'Κέρδισες: $comp $year. $loser ηττήθηκε$result.';
  }

  @override
  String msgChampBodyMine3(String comp, String loser, String result, int year) {
    return '$comp $year: είναι δικό σου. $loser ηττήθηκε$result.';
  }

  @override
  String msgChampBodyOther1(
    String winner,
    String comp,
    String loser,
    String result,
    int year,
  ) {
    return '$comp $year: νικητής είναι $winner. $loser ηττήθηκε$result.';
  }

  @override
  String msgChampBodyOther2(
    String winner,
    String comp,
    String loser,
    String result,
    int year,
  ) {
    return '$comp $year: πρωταθλήτρια είναι $winner. $loser ηττήθηκε$result.';
  }

  @override
  String msgFinalScoreSuffix(int home, int away) {
    return ' με $home–$away στον τελικό';
  }

  @override
  String msgFinalPensSuffix(int home, int away) {
    return ' στα πέναλτι, μετά από τελικό $home–$away';
  }

  @override
  String get msgWpotyTitle => 'Παγκόσμιος Παίκτης της Χρονιάς';

  @override
  String msgWpotyBodyMine(String name, String nation, int year) {
    return 'Παγκόσμιος Παίκτης της Χρονιάς $year: $name ($nation), δικός σου παίκτης.';
  }

  @override
  String msgWpotyBodyOther(String name, String nation, int year) {
    return 'Παγκόσμιος Παίκτης της Χρονιάς $year: $name ($nation).';
  }

  @override
  String get msgYpotTitle => 'Νέος Παίκτης της Διοργάνωσης';

  @override
  String msgYpotBodyMine(String name, String nation, int age, int year) {
    return 'Νέος Παίκτης της Διοργάνωσης $year: $name ($nation), $age ετών, δικός σου παίκτης.';
  }

  @override
  String msgYpotBodyOther(String name, String nation, int age, int year) {
    return 'Νέος Παίκτης της Διοργάνωσης $year: $name ($nation), $age ετών.';
  }

  @override
  String msgRankHold1(int rank) {
    return 'Μένεις στο #$rank.';
  }

  @override
  String msgRankHold2(int rank) {
    return 'Καμία αλλαγή, ακόμα #$rank.';
  }

  @override
  String msgRankHold3(int rank) {
    return 'Σταθερός στο #$rank.';
  }

  @override
  String msgRankUp1(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move θέσεις',
      one: '1 θέση',
    );
    return 'Ανεβαίνεις $_temp0 συνολικά, στο #$rank.';
  }

  @override
  String msgRankUp2(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move θέσεων',
      one: '1 θέσης',
    );
    return 'Άνοδος $_temp0 σε φέρνει στο #$rank.';
  }

  @override
  String msgRankUp3(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move θέσεις',
      one: '1 θέση',
    );
    return 'Ανεβαίνεις $_temp0, τώρα #$rank.';
  }

  @override
  String msgRankDown1(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move θέσεις',
      one: '1 θέση',
    );
    return 'Πέφτεις $_temp0 συνολικά, στο #$rank.';
  }

  @override
  String msgRankDown2(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move θέσεων',
      one: '1 θέσης',
    );
    return 'Πτώση $_temp0 σε ρίχνει στο #$rank.';
  }

  @override
  String msgRankDown3(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move θέσεις',
      one: '1 θέση',
    );
    return 'Πέφτεις $_temp0, τώρα #$rank.';
  }

  @override
  String get msgRankLeadYou => 'Είσαι στην κορυφή του κόσμου.';

  @override
  String msgRankLeadOther(String nation) {
    return 'Στην κορυφή του κόσμου: $nation.';
  }

  @override
  String msgRankTitle(int rank) {
    return 'Παγκόσμια κατάταξη · #$rank';
  }

  @override
  String msgRankBody(String lead, String movement) {
    return 'Η παγκόσμια κατάταξη ενημερώθηκε. $lead $movement';
  }

  @override
  String msgRankJumpTitleUp(int rank) {
    return 'Άνοδος στο #$rank';
  }

  @override
  String msgRankJumpTitleDown(int rank) {
    return 'Πτώση στο #$rank';
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
      other: '$move θέσεων',
      one: '1 θέσης',
    );
    return '$tournament: η παγκόσμια κατάταξη άλλαξε. $nation: μπήκε στο #$from και βγήκε στο #$to, άνοδος $_temp0.';
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
      other: '$move θέσεων',
      one: '1 θέσης',
    );
    return '$tournament: η παγκόσμια κατάταξη άλλαξε. $nation: μπήκε στο #$from και βγήκε στο #$to, πτώση $_temp0.';
  }

  @override
  String get rankingSinceWcDraw =>
      'Από την κλήρωση του Παγκοσμίου Πρωταθλήματος';

  @override
  String get rankingSinceCycleStart => 'Από την αρχή της εκστρατείας';

  @override
  String rankingMovedFromTo(int from, int now) {
    return '#$from σε #$now';
  }

  @override
  String msgCapsTitle(String name, int count) {
    return '$name: $count συμμετοχές';
  }

  @override
  String msgCapsBody(String name, int count) {
    return '$name: $count συμμετοχές με την εθνική σου.';
  }

  @override
  String msgGoalsTitle(String name, int count) {
    return '$name: $count γκολ';
  }

  @override
  String msgGoalsBody(String name, int count) {
    return '$name: $count γκολ με την εθνική σου.';
  }

  @override
  String msgDevTitle(int year) {
    return 'Εξέλιξη αποστολής · $year';
  }

  @override
  String msgThroughTitle(int year) {
    return 'Από την ακαδημία · $year';
  }

  @override
  String get msgThroughNote =>
      'Δεν είναι νέα φουρνιά. Είναι τα παιδιά που μπήκαν στα έντεκα και τώρα έχουν μεγαλώσει και μπήκαν στη δεξαμενή των ανδρών.';

  @override
  String msgNewFacesTitle(int year) {
    return 'Νέα πρόσωπα · $year';
  }

  @override
  String get msgIntakeNoteAcademy =>
      'Η επένδυση στην ακαδημία φαίνεται: η φουρνιά αυτή ήρθε πιο δυνατή απ’ ό,τι θα ήταν αλλιώς.';

  @override
  String get msgIntakeNoteStanding =>
      'Η χώρα παρακολουθεί αυτή την ομάδα: καθώς η ομάδα ανεβαίνει στην παγκόσμια κατάταξη, τα καλύτερα παιδιά διαλέγουν το ποδόσφαιρο και η φουρνιά αυτή ήρθε πιο δυνατή γι’ αυτό.';

  @override
  String get msgIntakeNoteBoth =>
      'Τα χρήματα για την ακαδημία και η άνοδος της ομάδας στην παγκόσμια κατάταξη φαίνονται και τα δύο: η φουρνιά αυτή ήρθε πιο δυνατή απ’ ό,τι θα ήταν αλλιώς.';

  @override
  String msgIntakeTitle(int year) {
    return 'Φουρνιά ακαδημίας · $year';
  }

  @override
  String msgRetireCaptainTitle(String name) {
    return 'Αποχωρεί ο αρχηγός σου, $name';
  }

  @override
  String msgRetireTitle(String name) {
    return 'Ο $name αποσύρεται από την εθνική';
  }

  @override
  String msgRetireBody(String name, int age) {
    return 'Ο $name αποσύρθηκε από το διεθνές ποδόσφαιρο σε ηλικία $age ετών.';
  }

  @override
  String msgRetireBodyWith(String name, String tally, int age) {
    return 'Ο $name αποσύρθηκε από το διεθνές ποδόσφαιρο σε ηλικία $age ετών, αποχωρώντας με $tally.';
  }

  @override
  String msgTallyCaps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count συμμετοχές',
      one: '1 συμμετοχή',
    );
    return '$_temp0';
  }

  @override
  String msgTallyGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count γκολ',
      one: '1 γκολ',
    );
    return '$_temp0';
  }

  @override
  String get msgArmbandVacant =>
      ' Το περιβραχιόνιο είναι κενό. Όρισε νέο αρχηγό από την οθόνη των κλήσεων.';

  @override
  String msgHofTitle(String name) {
    return 'Ο $name μπαίνει στο Πάνθεον';
  }

  @override
  String msgHofBody(String name, int caps, int goals) {
    return 'Ο $name μπαίνει στο Πάνθεον της χώρας σου ($caps συμμετοχές, $goals γκολ). Δες τον στους Θρύλους.';
  }

  @override
  String hubBanTitle(String name) {
    return 'Τιμωρία: $name';
  }

  @override
  String hubBanBody(String name, String how, int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: 'τους επόμενους $matches αγώνες',
      one: 'τον επόμενο αγώνα σου',
    );
    return '$name $how και χάνει $_temp0. Δεν θα είναι διαθέσιμος για επιλογή.';
  }

  @override
  String get hubBanHowSecondYellow => 'αποβλήθηκε με δεύτερη κίτρινη';

  @override
  String get hubBanHowViolent =>
      'έδειξε απευθείας κόκκινη για βίαιη συμπεριφορά';

  @override
  String get hubBanHowRed => 'αποβλήθηκε';

  @override
  String hubInjuryTitle(String name) {
    return 'Τραυματισμός: $name';
  }

  @override
  String hubInjuryBody(String name, int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: '$matches αγώνες',
      one: '1 αγώνα',
    );
    return '$name: χτύπημα, θα λείψει $_temp0.';
  }

  @override
  String get hubRunnerUpTitle1 => 'Φιναλίστ';

  @override
  String get hubRunnerUpTitle2 => 'Τόσο κοντά, κι όμως τόσο μακριά';

  @override
  String get hubRunnerUpTitle3 => 'Ασημένια μετάλλια';

  @override
  String hubRunnerUpBody1(String cup, String opponent) {
    return '$cup: έφτασες στον τελικό αλλά έχασες. Αντίπαλος: $opponent. Τόσο κοντά. Ασήμι αυτή τη φορά.';
  }

  @override
  String hubRunnerUpBody2(String cup, String opponent) {
    return '$cup: ηττήθηκες στον τελικό. Νικητής: $opponent. Φιναλίστ, με πόνο ψυχής.';
  }

  @override
  String hubRunnerUpBody3(String cup, String opponent) {
    return '$cup: ο τελικός ξέφυγε. Αντίπαλος: $opponent. Πολλά για να είσαι περήφανος, αλλά όχι το τρόπαιο.';
  }

  @override
  String get hubKnockedOutTitle1 => 'Αποκλεισμός';

  @override
  String get hubKnockedOutTitle2 => 'Το τέλος του δρόμου';

  @override
  String get hubKnockedOutTitle3 => 'Το ταξίδι τελείωσε';

  @override
  String hubKnockedOutBody1(String cup, String opponent, String stage) {
    return '$cup: αποκλείστηκες. Φάση: $stage. Αντίπαλος που σε νίκησε: $opponent.';
  }

  @override
  String hubKnockedOutBody2(String cup, String opponent, String stage) {
    return '$cup: το ταξίδι τελειώνει. Φάση: $stage. Αντίπαλος: $opponent.';
  }

  @override
  String hubKnockedOutBody3(String cup, String opponent, String stage) {
    return '$cup: τέλος στη φάση: $stage. Ηττήθηκες από: $opponent.';
  }

  @override
  String get hubGroupExitTitle1 => 'Αποκλεισμός στους ομίλους';

  @override
  String get hubGroupExitTitle2 => 'Εκτός από τους ομίλους';

  @override
  String get hubGroupExitTitle3 => 'Νωρίς στα αποδυτήρια';

  @override
  String hubGroupExitBody1(String cup) {
    return '$cup: τέλος στη φάση των ομίλων. Δεν έφτανε για τα νοκ άουτ.';
  }

  @override
  String hubGroupExitBody2(String cup) {
    return '$cup: δεν βγήκες από τον όμιλο. Το ταξίδι σου τελειώνει εδώ.';
  }

  @override
  String hubGroupExitBody3(String cup) {
    return 'Χωρίς θέση στα νοκ άουτ αυτή τη φορά. $cup: η πορεία σου τελειώνει στη φάση των ομίλων.';
  }

  @override
  String boardObjectiveMetTitle(String comp) {
    return 'Στόχος επιτεύχθηκε: $comp';
  }

  @override
  String boardObjectiveMissedTitle(String comp) {
    return 'Στόχος που χάθηκε: $comp';
  }

  @override
  String boardObjectiveMetBody(String comp, String demand, String finish) {
    return 'Ο στόχος της διοίκησης για $comp: $demand. Τερμάτισες: $finish. Πήρε αυτό που ζήτησε.';
  }

  @override
  String boardObjectiveMissedBody(String comp, String demand, String finish) {
    return 'Ο στόχος της διοίκησης για $comp: $demand. Τερμάτισες: $finish. Αυτό υπολείπεται των προσδοκιών.';
  }

  @override
  String get newsWcMissTitle => 'Τέλος το όνειρο του Παγκοσμίου Πρωταθλήματος';

  @override
  String newsWcMissBody(int year) {
    return 'Έμεινες εκτός Παγκοσμίου Πρωταθλήματος $year. Η προκριματική εκστρατεία δεν ήταν αρκετή. Άλλα τέσσερα χρόνια αναμονής.';
  }

  @override
  String get newsRecordScorerTitle => 'Πρώτος σκόρερ όλων των εποχών';

  @override
  String newsRecordScorerBody(String name, int goals) {
    return '$name: ο νέος πρώτος σκόρερ όλων των εποχών του παιχνιδιού, με $goals γκολ.';
  }

  @override
  String get newsRecordCapsTitle => 'Ο παίκτης με τις περισσότερες συμμετοχές';

  @override
  String newsRecordCapsBody(String name, int caps) {
    return '$name: ο παίκτης με τις περισσότερες συμμετοχές στην ιστορία του παιχνιδιού, με $caps συμμετοχές.';
  }

  @override
  String get newsARecordBreaker => 'Ένας νέος ρεκορντμάν';

  @override
  String newsTransferTitle(String name, String club) {
    return 'Μεταγραφή: $name, $club';
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
    return '$name ($position, $rating) αποχώρησε από $fromClub και υπέγραψε σε $destination. Ποσό μεταγραφής: $fee.';
  }

  @override
  String newsTransferAbroad(String club, String country) {
    return '$club ($country)';
  }

  @override
  String get newsTransferFree => 'Δωρεάν';

  @override
  String newsNatzStarTitle(String name, String nation) {
    return '$name θα άλλαζε εθνική: $nation!';
  }

  @override
  String newsNatzTitle(String name, String nation) {
    return '$name θέλει να αγωνιστεί με άλλη εθνική: $nation';
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
    return '$name, $position $age ετών με βαθμολογία $rating, είναι ανοιχτός στο ενδεχόμενο να αλλάξει εθνική. Τρέχουσα εθνική: $fromNation. Οικογενειακοί δεσμοί: $nation. Άνοιξε την προσφορά πολιτογράφησης για να την αποδεχτείς ή να την απορρίψεις.';
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
    return '$name, $position $age ετών με βαθμολογία $rating, είναι μεγάλο όνομα και ανοιχτός στο ενδεχόμενο να αλλάξει εθνική. Τρέχουσα εθνική: $fromNation. Οικογενειακοί δεσμοί: $nation. Άνοιξε την προσφορά πολιτογράφησης για να την αποδεχτείς ή να την απορρίψεις.';
  }

  @override
  String get newsTheirNation => 'η χώρα τους';

  @override
  String get newsYourNation => 'η χώρα σου';

  @override
  String get tourStatusChampions => 'ΠΡΩΤΑΘΛΗΤΕΣ';

  @override
  String get tourStatusFinals => 'ΤΕΛΙΚΗ ΦΑΣΗ';

  @override
  String get tourStatusQualifying => 'ΠΡΟΚΡΙΜΑΤΙΚΑ';

  @override
  String get tourStatusUpcoming => 'ΕΠΕΡΧΟΜΕΝΟ';

  @override
  String get tourStatusInProgress => 'ΣΕ ΕΞΕΛΙΞΗ';

  @override
  String get tourStatusComingSoon => 'ΣΥΝΤΟΜΑ';

  @override
  String get tourStatusDecided => 'ΚΡΙΘΗΚΕ';

  @override
  String tourStatusLeague(String letter) {
    return 'ΚΑΤΗΓΟΡΙΑ $letter';
  }

  @override
  String get tourDrawWcQualifying => 'ΠΑΓΚΟΣΜΙΑ ΠΡΟΚΡΙΜΑΤΙΚΑ: ΚΛΗΡΩΣΗ';

  @override
  String tourDrawContQualifying(String cup) {
    return 'ΚΛΗΡΩΣΗ ΠΡΟΚΡΙΜΑΤΙΚΩΝ: $cup';
  }

  @override
  String get tourDrawWcHost => 'ΟΙΚΟΔΕΣΠΟΤΗΣ ΠΑΓΚΟΣΜΙΟΥ ΠΡΩΤΑΘΛΗΜΑΤΟΣ';

  @override
  String tourDrawContHost(String cup) {
    return 'ΟΙΚΟΔΕΣΠΟΤΗΣ: $cup';
  }

  @override
  String get tourDrawHostsReveal => 'Και οι οικοδεσπότες θα είναι…';

  @override
  String get tourDrawHostReveal => 'Και ο οικοδεσπότης θα είναι…';

  @override
  String get tourDrawHostCandidates =>
      'Οι υποψήφιοι που διεκδικούν τη διοργάνωση:';

  @override
  String get tourKickoffContinentalCup => 'ΗΠΕΙΡΩΤΙΚΟ ΚΥΠΕΛΛΟ';

  @override
  String tourHostCompetitionYear(String competition, int year) {
    return '$competition $year';
  }

  @override
  String newsContMissTitle(String cup) {
    return '$cup: χωρίς πρόκριση';
  }

  @override
  String newsContMissBody(String cup) {
    return '$cup: δεν προκρίθηκες. Η εκστρατεία δεν ήταν αρκετή αυτή τη φορά.';
  }

  @override
  String get potyLabelBest => 'Παίκτης της Χρονιάς';

  @override
  String get potyLabelYoung => 'Νέος Παίκτης της Χρονιάς';

  @override
  String potyTallyAssists(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ασίστ',
      one: '1 ασίστ',
    );
    return '$_temp0';
  }

  @override
  String potyOverallValue(int value) {
    return 'Επίπεδο $value';
  }

  @override
  String potyRatingValue(String value) {
    return 'Βαθμός $value';
  }

  @override
  String newsPotyTitle(int year) {
    return 'Παγκόσμιος Παίκτης της Χρονιάς $year';
  }

  @override
  String newsPotyBody(String name) {
    return '$name: ο κορυφαίος παίκτης του κόσμου φέτος.';
  }

  @override
  String newsPotyYoungSuffix(String name) {
    return ' $name παίρνει το βραβείο του νέου παίκτη.';
  }

  @override
  String newsWatchTitle(int year) {
    return 'Τα παιδιά που παρακολουθείς, $year';
  }

  @override
  String newsWatchJump(String name, int rating, int gain) {
    String _temp0 = intl.Intl.pluralLogic(
      gain,
      locale: localeName,
      other: '$gain βαθμούς',
      one: 'ένα βαθμό',
    );
    return '$name ανέβηκε στο $rating, $_temp0 πάνω από πέρσι.';
  }

  @override
  String newsWatchBand(String name, String band) {
    return '$name ανεβαίνει στους $band.';
  }

  @override
  String newsWatchDebutTitle(String name) {
    return '$name: το ντεμπούτο';
  }

  @override
  String newsWatchDebutBody(String name, int age, int rating) {
    return '$name πήρε την πρώτη του συμμετοχή στα $age, με βαθμολογία $rating. Ένα από τα παιδιά που παρακολουθείς.';
  }

  @override
  String get matchStatsAtFullTime =>
      'Η κατοχή, οι βαθμολογίες των παικτών και ο κορυφαίος του αγώνα κρίνονται με τη λήξη του αγώνα.';

  @override
  String get matchPlayerRatings => 'ΒΑΘΜΟΛΟΓΙΕΣ ΠΑΙΚΤΩΝ';

  @override
  String get matchSubstitutions => 'ΑΛΛΑΓΕΣ';

  @override
  String get matchSubstitutes => 'ΑΝΑΠΛΗΡΩΜΑΤΙΚΟΙ';

  @override
  String get matchPlayerOfTheMatch => 'ΚΟΡΥΦΑΙΟΣ ΤΟΥ ΑΓΩΝΑ';

  @override
  String get matchGoalShout => 'ΓΚΟΛ!';

  @override
  String matchShootoutScore(int home, int away) {
    return 'ΠΕΝΑΛΤΙ $home–$away';
  }

  @override
  String matchShootoutKickScored(String name) {
    return '$name: ΣΚΟΡΑΡΕ';
  }

  @override
  String matchShootoutKickMissed(String name) {
    return '$name: ΑΣΤΟΧΗΣΕ';
  }

  @override
  String get matchFeedKickOff => 'Σέντρα!';

  @override
  String get matchFeedNoEvents => 'Δεν έχει συμβεί κάτι ακόμα.';

  @override
  String get tourVenues => 'ΓΗΠΕΔΑ';

  @override
  String tourPot(int number) {
    return 'ΚΑΛΑΘΙ $number';
  }

  @override
  String get tourHostSelection => 'ΕΠΙΛΟΓΗ ΟΙΚΟΔΕΣΠΟΤΗ';

  @override
  String get tourCandidates => 'ΥΠΟΨΗΦΙΟΙ';

  @override
  String get tourJointBid => 'ΚΟΙΝΗ ΥΠΟΨΗΦΙΟΤΗΤΑ';

  @override
  String get tourGoldenGlove => 'ΧΡΥΣΟ ΓΑΝΤΙ';

  @override
  String get tourTeamOfTournament => 'ΙΔΑΝΙΚΗ ΕΝΔΕΚΑΔΑ ΤΗΣ ΔΙΟΡΓΑΝΩΣΗΣ';

  @override
  String get tourYourRun => 'Η ΠΟΡΕΙΑ ΣΟΥ';

  @override
  String get tourMedalTable => 'ΠΙΝΑΚΑΣ ΜΕΤΑΛΛΙΩΝ';

  @override
  String tourHostLine(String nation) {
    return 'Οικοδεσπότης: $nation';
  }

  @override
  String tourHostLineMulti(String hosts) {
    return 'Οικοδεσπότες: $hosts';
  }

  @override
  String tourGroupNamed(String name) {
    return 'Όμιλος $name';
  }

  @override
  String get tourFinalsDrawBlurb =>
      'Κεφαλές με βάση την παγκόσμια κατάταξη. Βρες την εθνική σου πριν από την κλήρωση.';

  @override
  String get tourWorldRanking => 'Παγκόσμια κατάταξη';

  @override
  String get tourYourCompetitions => 'ΟΙ ΔΙΟΡΓΑΝΩΣΕΙΣ ΣΟΥ';

  @override
  String get tourOtherContinents => 'ΑΛΛΕΣ ΗΠΕΙΡΟΙ';

  @override
  String get tourZoneGlobal => 'ΠΑΓΚΟΣΜΙΟ';

  @override
  String get tourZoneEurope => 'ΕΥΡΩΠΗ';

  @override
  String get tourZoneSouthAmerica => 'Ν. ΑΜΕΡΙΚΗ';

  @override
  String get tourZoneNorthAmerica => 'Β. ΑΜΕΡΙΚΗ';

  @override
  String get tourZoneAfrica => 'ΑΦΡΙΚΗ';

  @override
  String get tourZoneAsia => 'ΑΣΙΑ';

  @override
  String get tourZoneOceania => 'ΩΚΕΑΝΙΑ';

  @override
  String get tourZoneIntercontinental => 'ΔΙΗΠΕΙΡΩΤΙΚΟ';

  @override
  String tourZoneLeague(String league) {
    return 'ΚΑΤΗΓΟΡΙΑ $league';
  }

  @override
  String tourHostedBy(String hosts) {
    return 'ΔΙΟΡΓΑΝΩΣΗ  $hosts';
  }

  @override
  String tourThirdsAdvance(int count, String destination) {
    return 'Οι $count πρώτοι προκρίνονται $destination';
  }

  @override
  String newsWalkoutTitle(String name) {
    return '$name αποχωρεί';
  }

  @override
  String newsWalkoutBody(String name, int age, int caps) {
    return '$name αποσύρθηκε από την εθνική στα $age, με $caps συμμετοχές. Ζήτησε να μάθει τη θέση του και δεν πήρε απάντηση, και δεν περιμένει άλλο.';
  }

  @override
  String get pressHeadlineWent1 => 'Ένας προπονητής που ελέγχει την αίθουσα';

  @override
  String get pressHeadlineWent2 => 'Ήρθαν για καβγά και βρήκαν ηγέτη';

  @override
  String get pressHeadlineWent3 => 'Ευθείες απαντήσεις, που βρήκαν στόχο';

  @override
  String get pressHeadlineMixed1 => 'Πολλά λόγια, λίγα ξεκαθαρίσματα';

  @override
  String get pressHeadlineMixed2 => 'Κάτι για όλους και τίποτα για κανέναν';

  @override
  String get pressHeadlineMixed3 =>
      'Μια συνέντευξη που άφησε τα ερωτήματα ανοιχτά';

  @override
  String get pressHeadlineBadly1 => 'Ένα δύσκολο απόγευμα μπροστά στις κάμερες';

  @override
  String get pressHeadlineBadly2 => 'Η αίθουσα γύρισε, και φάνηκε';

  @override
  String get pressHeadlineBadly3 =>
      'Απαντήσεις που θα διαβαστούν χειρότερα το πρωί';

  @override
  String get pressHeadlineFlat1 => 'Τίποτα δεν ειπώθηκε, τίποτα δεν κερδήθηκε';

  @override
  String get pressHeadlineFlat2 => 'Δέκα λεπτά, καμία είδηση';

  @override
  String get pressHeadlineFlat3 => 'Λευκή σελίδα για το πρωτοσέλιδο';

  @override
  String get pressConferenceTitle => 'ΣΥΝΕΝΤΕΥΞΗ ΤΥΠΟΥ';

  @override
  String pressQuestionOf(int index, int total) {
    return 'Ερώτηση $index από $total';
  }

  @override
  String get pressTomorrowsHeadline => 'ΤΟ ΑΥΡΙΑΝΟ ΠΡΩΤΟΣΕΛΙΔΟ';

  @override
  String get pressLeaveRoom => 'ΦΥΓΕ ΑΠΟ ΤΗΝ ΑΙΘΟΥΣΑ';

  @override
  String get pressRoomVerdictSquad => 'Αποδυτήρια';

  @override
  String get pressRoomVerdictBoard => 'Διοίκηση';

  @override
  String get yReactionElation0 => 'καμία παρατήρηση. καμία. τέλειο.';

  @override
  String get yReactionElation1 => 'δεν αισθάνομαι καλά (με την καλή έννοια).';

  @override
  String get yReactionElation2 => 'το κάνω κάδρο. πάει πάνω από το τζάκι.';

  @override
  String get yReactionElation3 => 'επιστρέψαμε για τα καλά';

  @override
  String get yReactionElation4 =>
      'Παίρνω screenshot για τους δύσπιστους. Για όλους.';

  @override
  String get yReactionElation5 =>
      'Θα είμαι ανυπόφορος γι αυτό για δέκα χρόνια.';

  @override
  String get yReactionElation6 => 'Έτσι. Γι αυτό βλέπουμε μπάλα.';

  @override
  String get yReactionElation7 => 'Μέρες σαν κι αυτή πληρώνουν τις υπόλοιπες.';

  @override
  String get yReactionElation8 => 'Επιτέλους. Ειλικρινά, επιτέλους.';

  @override
  String get yReactionElation9 =>
      'Τέλεια. Κάντε το και την άλλη εβδομάδα και θα πιστέψω.';

  @override
  String get yReactionElation10 =>
      'Απολαύστε το απόψε, γιατί αυτοί θα βρουν τρόπο να το χαλάσουν.';

  @override
  String get yReactionElation11 =>
      'Ένα καλό βράδυ δεν κάνει κανέναν σπουδαία ομάδα.';

  @override
  String get yReactionRelief0 => 'Όχι όμορφο, αλλά το παίρνω κάθε φορά.';

  @override
  String get yReactionRelief1 => 'Κάπως. Κάπως!';

  @override
  String get yReactionRelief2 => 'Άσχημο. Τρεις βαθμοί. Πάμε παρακάτω.';

  @override
  String get yReactionRelief3 =>
      'Παίρνω το άσχημο όλη μέρα αν έρχεται με βαθμούς.';

  @override
  String get yReactionRelief4 => 'μου πήρε δέκα χρόνια από πάνω μου';

  @override
  String get yReactionRelief5 =>
      'Κανείς να μη μιλήσει. Κανείς να μη το γρουσουζέψει.';

  @override
  String get yReactionRelief6 => 'Καρδιακοί παλμοί: απαράδεκτοι.';

  @override
  String get yReactionRelief7 => 'Επιβιώσαμε. Αυτή είναι η λέξη. Επιβιώσαμε.';

  @override
  String get yReactionRelief8 =>
      'Δεν θα έπρεπε να χρειαζόμαστε ανακούφιση από τέτοια παιχνίδια.';

  @override
  String get yReactionRelief9 =>
      'Ανακουφισμένος, και λίγο ντροπιασμένος που ανακουφίστηκα.';

  @override
  String get yReactionRelief10 =>
      'Αν αυτό είναι το επίπεδο που πανηγυρίζουμε, έχουμε πρόβλημα.';

  @override
  String get yReactionRelief11 =>
      'Το να περνάς στο τσακ γίνεται συνήθεια, και δεν είναι καλή.';

  @override
  String get yReactionFury0 => 'Δεν είναι αρκετό. Ούτε κατά διάνοια.';

  @override
  String get yReactionFury1 => 'Να μου το εξηγήσει κάποιος αργά.';

  @override
  String get yReactionFury2 => 'Δύσκολο να το βλέπεις και είμαι ευγενικός.';

  @override
  String get yReactionFury3 => 'Απογοητευμένος. Ειλικρινά απογοητευμένος.';

  @override
  String get yReactionFury4 => 'Πλήρης διάλυση.';

  @override
  String get yReactionFury5 => 'Θέλω ονόματα.';

  @override
  String get yReactionFury6 => 'Σβήνω την εφαρμογή. Την ξαναβάζω την Πέμπτη.';

  @override
  String get yReactionFury7 => 'Κανείς εκεί έξω δεν έδειχνε ότι το θέλει.';

  @override
  String get yReactionFury8 =>
      'Κάθε τέσσερα χρόνια το ίδιο. ΚΑΘΕ τέσσερα χρόνια.';

  @override
  String get yReactionFury9 => 'Αυτό δεν είναι εμφάνιση, είναι προσβολή.';

  @override
  String get yReactionFury10 =>
      'Ο κόσμος θυσιάζει Σαββατοκύριακα και χρήματα για αυτό. Σκεφτείτε το.';

  @override
  String get yReactionFury11 =>
      'Υπερασπίζομαι αυτή την ομάδα χρόνια. Όχι απόψε. Όχι μετά από αυτό.';

  @override
  String get yReactionDespair0 => 'λοιπόν.';

  @override
  String get yReactionDespair1 => 'Σήμερα χωρίς αστεία. Τίποτα.';

  @override
  String get yReactionDespair2 => 'Πάω μια βόλτα. Μακριά.';

  @override
  String get yReactionDespair3 => 'Έχω ξεμείνει από τρόπους να το πω.';

  @override
  String get yReactionDespair4 => 'Ξυπνήστε με σε τέσσερα χρόνια.';

  @override
  String get yReactionDespair5 => 'αυτό είναι το πιο σκοτεινό σενάριο';

  @override
  String get yReactionDespair6 =>
      'Ούτε θυμωμένος πια. Αυτό είναι το ανησυχητικό.';

  @override
  String get yReactionDespair7 => 'Αυτό θα πονάει για πολύ καιρό.';

  @override
  String get yReactionDespair8 =>
      'Δεν ξέρω τι είναι πια αυτό, αλλά δεν είναι ποδοσφαιρική ομάδα.';

  @override
  String get yReactionDespair9 =>
      'Είμαστε πιο μακριά από πριν, και κανείς δεν θα το πει.';

  @override
  String get yReactionDespair10 =>
      'Μια ολόκληρη γενιά χαμένη και οι ίδιοι αποφασίζουν τι θα γίνει μετά.';

  @override
  String get yReactionDespair11 =>
      'Σταματήστε να μου λέτε ότι είναι διαδικασία. Δεν πηγαίνει πουθενά.';

  @override
  String get yReactionSmugness0 => 'Διακριτικά, αλλά: σας το είπα.';

  @override
  String get yReactionSmugness1 => 'κάντε bookmark σε αυτό';

  @override
  String get yReactionSmugness2 => 'Οι δύσπιστοι έχουν σωπάσει πολύ.';

  @override
  String get yReactionSmugness3 => 'Όχι ότι μετράει κανείς. Εγώ μετράω.';

  @override
  String get yReactionSmugness4 =>
      'Το είπα τον Ιανουάριο. Δείτε το χρονολόγιο.';

  @override
  String get yReactionSmugness5 =>
      'Κάποιοι από εσάς χρωστάτε μια συγγνώμη σε κάποιους από εμάς.';

  @override
  String get yReactionSmugness6 =>
      'Το αρχειοθετώ στα πράγματα που είπα πρώτος.';

  @override
  String get yReactionSmugness7 => 'Χωρίς καμάρωμα. Λίγο καμάρωμα.';

  @override
  String get yReactionSmugness8 =>
      'Πού είναι τώρα όλοι οι ειδικοί; Ειλικρινά ρωτάω.';

  @override
  String get yReactionSmugness9 => 'Θέλω ο καθένας σας να μου το πει πίσω.';

  @override
  String get yReactionSmugness10 =>
      'Screenshot, εκτυπωμένο, κορνιζαρισμένο, σταλμένο σε όσους γέλασαν.';

  @override
  String get yReactionSmugness11 =>
      'Θα το θυμίζω σε όλη μου τη ζωή και το έχετε κερδίσει.';

  @override
  String get yReactionShrug0 => 'έγινε. επόμενο.';

  @override
  String get yReactionShrug1 => 'Εντάξει. Ό,τι. Πάμε.';

  @override
  String get yReactionShrug2 => 'Το αρχειοθετώ στην κατηγορία «ποδόσφαιρο».';

  @override
  String get yReactionShrug3 => 'Πραγματικά δεν έχω τίποτα να προσθέσω.';

  @override
  String get yReactionShrug4 => 'καμία σκέψη, άδειο κεφάλι';

  @override
  String get yReactionShrug5 => 'Ξυπνήστε με για το επόμενο.';

  @override
  String get yReactionShrug6 => 'Ενενήντα λεπτά που δεν θα τα πάρω πίσω.';

  @override
  String get yReactionShrug7 => 'Ούτε εδώ ούτε εκεί, πραγματικά.';

  @override
  String get yReactionShrug8 =>
      'Δεν μπορώ να σας πω ούτε ένα πράγμα που έγινε.';

  @override
  String get yReactionShrug9 => 'Άλλο ένα από αυτά. Υπάρχουν πολλά από αυτά.';

  @override
  String get yReactionShrug10 => 'Τα είδα όλα και δεν ένιωσα απολύτως τίποτα.';

  @override
  String get yReactionShrug11 =>
      'Αν δεν το αναφέρει κανείς ξανά, εμένα μια χαρά μου κάνει.';

  @override
  String get tourThirdsUneven =>
      'Οι όμιλοι είναι άνισοι, οπότε αφαιρούνται τα αποτελέσματα με την τελευταία ομάδα του κάθε μεγάλου ομίλου και όλες οι ομάδες κρίνονται στα ίδια παιχνίδια.';

  @override
  String get careerExportSave => 'Αντίγραφο ασφαλείας αυτής της αποθήκευσης';

  @override
  String get careerBackupAll => 'ΑΝΤΙΓΡΑΦΟ ΟΛΩΝ ΤΩΝ ΑΠΟΘΗΚΕΥΣΕΩΝ';

  @override
  String get careerBackupAllFailed =>
      'Δεν ήταν δυνατή η εγγραφή του αντιγράφου.';

  @override
  String get backupTitle => 'ΑΝΤΙΓΡΑΦΑ ΑΣΦΑΛΕΙΑΣ';

  @override
  String get backupBlurb =>
      'Όλες οι αποθηκεύσεις βρίσκονται σε ένα αρχείο σε αυτό το κινητό και τίποτα δεν τις αντιγράφει μόνο του, εκτός αν ανοίξεις παρακάτω το αυτόματο αντίγραφο. Κράτα αντίγραφο στο cloud, ώστε ένα χαμένο κινητό ή μια διαγραμμένη εφαρμογή να μη σου κοστίσει μια καριέρα.';

  @override
  String get backupBlurbNoAuto =>
      'Όλες οι αποθηκεύσεις βρίσκονται σε ένα αρχείο σε αυτό το κινητό και τίποτα δεν τις αντιγράφει μόνο του. Κράτα αντίγραφο στο cloud, ώστε ένα χαμένο κινητό ή μια διαγραμμένη εφαρμογή να μη σου κοστίσει μια καριέρα.';

  @override
  String get backupExport => 'ΑΝΤΙΓΡΑΦΟ ΣΤΟ CLOUD';

  @override
  String get backupExportSubject => 'Αποθηκεύσεις FNM';

  @override
  String get backupRestore => 'ΕΠΑΝΑΦΟΡΑ ΑΠΟ ΑΡΧΕΙΟ';

  @override
  String get backupRestoreWarnTitle => 'Αντικατάσταση όλων των αποθηκεύσεων;';

  @override
  String get backupRestoreWarnBody =>
      'Η επαναφορά αντικαθιστά όλες τις αποθηκεύσεις σε αυτό το τηλέφωνο με αυτές του αρχείου. Η εφαρμογή θα επανεκκινήσει.';

  @override
  String get backupRestoreConfirm => 'ΑΝΤΙΚΑΤΑΣΤΑΣΗ';

  @override
  String get backupCancel => 'ΑΚΥΡΩΣΗ';

  @override
  String get backupExported =>
      'Το αντίγραφο είναι έτοιμο. Διάλεξε πού θα το φυλάξεις.';

  @override
  String get backupFailed => 'Δεν ήταν δυνατή η εγγραφή του αντιγράφου.';

  @override
  String get backupRejectedUnreadable =>
      'Δεν ήταν δυνατό να ανοιχτεί αυτό το αρχείο.';

  @override
  String get backupRejectedNotFnm => 'Αυτό δεν είναι αποθήκευση FNM.';

  @override
  String get backupRejectedNewer =>
      'Αυτή η αποθήκευση δημιουργήθηκε από νεότερη έκδοση της εφαρμογής. Ενημέρωσε πρώτα.';

  @override
  String get backupRejectedTooOld =>
      'Αυτή η αποθήκευση είναι πολύ παλιά για να επαναφερθεί από αυτή την έκδοση.';

  @override
  String get careerShare => 'Κοινοποίηση αυτής της καριέρας';

  @override
  String get careerImport => 'ΕΙΣΑΓΩΓΗ ΚΑΡΙΕΡΑΣ';

  @override
  String get careerShareSubject => 'Μια καριέρα FNM';

  @override
  String get careerImported => 'Η καριέρα εισήχθη.';

  @override
  String get careerImportFailedUnreadable =>
      'Αυτό το αρχείο δεν είναι καριέρα FNM.';

  @override
  String get careerImportFailedNewer =>
      'Αυτή η καριέρα εξήχθη από νεότερη έκδοση της εφαρμογής. Ενημέρωσε πρώτα.';

  @override
  String get careerImportFailedSlotsFull =>
      'Όλες οι θέσεις αποθήκευσης είναι πιασμένες. Διέγραψε μια αποθήκευση για να κάνεις χώρο ή ξεκλείδωσε απεριόριστες αποθηκεύσεις.';

  @override
  String get careerImportFailedNeedsPremium =>
      'Αυτή η καριέρα ξεπερνά τον δωρεάν πρώτο κύκλο. Ξεκλείδωσε το πλήρες παιχνίδι για να την εισαγάγεις.';

  @override
  String get careerImportFailedCampaignRun =>
      'Αυτή η εκστρατεία έχει ήδη μια πορεία σε εξέλιξη. Συνέχισέ την ή εγκατάλειψέ την πρώτα.';

  @override
  String get careerShareFailed =>
      'Δεν ήταν δυνατή η εξαγωγή αυτής της καριέρας.';

  @override
  String get managerRename => 'Αλλαγή ονόματος';

  @override
  String get managerRenameSave => 'Αποθήκευση';

  @override
  String get managerTitle => 'ΠΡΟΠΟΝΗΤΗΣ';

  @override
  String get managerSkills => 'ΟΙ ΔΕΞΙΟΤΗΤΕΣ ΣΟΥ';

  @override
  String managerPointsAvailable(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count πόντοι προς διάθεση',
      one: '1 πόντος προς διάθεση',
      zero: 'Κανένας πόντος προς διάθεση',
    );
    return '$_temp0';
  }

  @override
  String get managerPointsHow =>
      'Δύο πόντοι για κάθε κύκλο που ολοκληρώνεις, ένας για κάθε τρόπαιο που κερδίζεις.';

  @override
  String get managerSkillsScale =>
      'Κάθε δεξιότητα ξεκινά από το 5 και φτάνει έως το 20. Ένας πόντος που ξοδεύεται είναι μόνιμος.';

  @override
  String get managerSkillManManagement => 'Διαχείριση Ανθρώπων';

  @override
  String get managerSkillManManagementBlurb =>
      'Κάθε πόντος κάνει όσα λες στον Τύπο και στους παίκτες σου να έχουν 3% μεγαλύτερο αντίκτυπο στα αποδυτήρια.';

  @override
  String get managerSkillTactical => 'Τακτική';

  @override
  String get managerSkillTacticalBlurb =>
      'Κάθε πόντος κάνει ένα νέο σύστημα να περνά 3% πιο γρήγορα, οπότε η αλλαγή σχηματισμού σου κοστίζει λιγότερους αγώνες.';

  @override
  String get managerSkillYouth => 'Ανάπτυξη Νέων';

  @override
  String get managerSkillYouthBlurb =>
      'Κάθε πόντος προσθέτει 1% στο ταλέντο που βγαίνει από την ακαδημία σου, επιπλέον όσων την χρηματοδοτείς.';

  @override
  String get managerSkillNegotiation => 'Διαπραγμάτευση';

  @override
  String get managerSkillNegotiationBlurb =>
      'Κάθε πόντος είναι 2% περισσότερα χρήματα από την ομοσπονδία, σε κάθε κύκλο.';

  @override
  String get managerStaff => 'ΤΟ ΕΠΙΤΕΛΕΙΟ ΣΟΥ';

  @override
  String managerStaffWages(String amount) {
    return 'Μισθοί: $amount ανά κύκλο';
  }

  @override
  String get managerRoleAssistant => 'Βοηθός Προπονητή';

  @override
  String get managerRoleAssistantBlurb =>
      'Διευθύνει την προπόνηση: λιγότεροι τραυματισμοί και καλύτερα νιάτα που ανεβαίνουν.';

  @override
  String get managerRoleScout => 'Επικεφαλής Σκάουτ';

  @override
  String get managerRoleScoutBlurb =>
      'Διαβάζει τα ταλέντα σου και τον επόμενο αντίπαλο: πιο αληθινές βαθμολογίες αστεριών και πλεονέκτημα την ημέρα του αγώνα.';

  @override
  String get managerRoleFitness => 'Γυμναστής';

  @override
  String get managerRoleFitnessBlurb => 'Τους κρατά στο γήπεδο.';

  @override
  String staffEffectInjury(int percent) {
    return '$percent% λιγότεροι τραυματισμοί';
  }

  @override
  String staffEffectYouth(int points) {
    return 'Νέοι +$points στο γενικό επίπεδο';
  }

  @override
  String staffHiringInjury(int min, int max) {
    return 'Αν προσλάβεις έναν: $min% έως $max% λιγότεροι τραυματισμοί';
  }

  @override
  String staffHiringYouth(int minPoints, int maxPoints) {
    return 'και νέοι +$minPoints έως +$maxPoints στο γενικό επίπεδο';
  }

  @override
  String staffEffectScoutRead(int percent) {
    return 'Διαβάζει επακριβώς το $percent% των ταλέντων';
  }

  @override
  String staffEffectScoutCaps(int caps) {
    String _temp0 = intl.Intl.pluralLogic(
      caps,
      locale: localeName,
      other: 'Το δυναμικό γίνεται γνωστό μετά από $caps συμμετοχές',
      one: 'Το δυναμικό γίνεται γνωστό μετά από 1 συμμετοχή',
    );
    return '$_temp0';
  }

  @override
  String staffEffectScoutDossier(int points) {
    return '+$points στη βαθμολογία από τους φακέλους αντιπάλων';
  }

  @override
  String staffHiringScoutRead(int min, int max) {
    return 'Αν προσλάβεις έναν: $min% έως $max% ακριβείς αναγνώσεις';
  }

  @override
  String staffHiringScoutCaps(int minCaps, int maxCaps) {
    return 'και το δυναμικό γίνεται γνωστό $minCaps έως $maxCaps συμμετοχές νωρίτερα';
  }

  @override
  String staffHiringScoutDossier(int minPoints, int maxPoints) {
    return 'και +$minPoints έως +$maxPoints βαθμολογία σε κάθε αγώνα';
  }

  @override
  String get staffEffectNone => 'Καμία επίδραση στην αποστολή σου ακόμα';

  @override
  String get staffVacant => 'Κανείς στη θέση';

  @override
  String get staffLeaveVacant => 'Άφησε τη θέση κενή';

  @override
  String get managerTierNone => 'Κανένα';

  @override
  String get managerTierBasic => 'Βασικό';

  @override
  String get managerTierGood => 'Καλό';

  @override
  String get managerTierElite => 'Ελίτ';

  @override
  String get managerFree => 'δωρεάν';

  @override
  String get managerTraining => 'ΜΕΤΑΞΥ ΠΑΡΑΘΥΡΩΝ';

  @override
  String get managerTrainingBlurb =>
      'Αυτό που δουλεύει η αποστολή όταν δεν υπάρχει αγώνας.';

  @override
  String get managerFocusBalanced => 'Ισορροπημένη';

  @override
  String get managerFocusBalancedBlurb => 'Λίγο από όλα.';

  @override
  String get managerFocusFitness => 'Φυσική κατάσταση';

  @override
  String get managerFocusFitnessBlurb => 'Λιγότερα χτυπήματα.';

  @override
  String get managerFocusCohesion => 'Συνοχή';

  @override
  String get managerFocusCohesionBlurb => 'Το σύστημα περνά πιο γρήγορα.';

  @override
  String get managerFocusYouth => 'Νέοι';

  @override
  String get managerFocusYouthBlurb => 'Ώρες με τους νεότερους της δεξαμενής.';

  @override
  String get tourOfferTitle => 'Πρώτη φορά εδώ;';

  @override
  String get tourOfferBody =>
      'Αυτό είναι ένα μεγάλο παιχνίδι. Θες μια γρήγορη βόλτα στις οθόνες που μετράνε; Κρατά ένα λεπτό και μπορείς να την ξεκινήσεις ξανά όποτε θέλεις από τις Ρυθμίσεις.';

  @override
  String get tourOfferYes => 'Δείξε μου';

  @override
  String get tourOfferNo => 'Όχι, ευχαριστώ';

  @override
  String get tourBack => 'Πίσω';

  @override
  String get tourNext => 'Επόμενο';

  @override
  String get tourDone => 'Τέλος';

  @override
  String get tourSkip => 'Παράλειψη';

  @override
  String get tourHubTitle => 'Αυτό είναι όλο το παιχνίδι';

  @override
  String get tourHubBody =>
      'Ένα κουμπί, που αλλάζει όσο προχωρά ο κύκλος: μια κλήρωση να δεις, μια αποστολή να ανακοινώσεις, ένας αγώνας να παίξεις. Από πάνω βρίσκονται η εμπιστοσύνη της διοίκησης σε εσένα και οι στόχοι που έχει θέσει.';

  @override
  String get tourBudgetTitle => 'Τα χρήματα της ομοσπονδίας';

  @override
  String get tourBudgetBody =>
      'Μία φορά σε κάθε τετραετή κύκλο μοιράζεις το ταμείο στα τμήματα. Πρώτα πληρώνεται το επιτελείο σου, οπότε η πρόσληψη ενός κορυφαίου σκάουτ είναι απόφαση εις βάρος της ακαδημίας, όχι δίπλα της.';

  @override
  String get tourTacticsTitle => 'Πώς παίζει η ομάδα';

  @override
  String get tourTacticsBody =>
      'Το σύστημά σου, ο τρόπος παιχνιδιού σου, ο αρχηγός σου και ποιος εκτελεί τις στατικές φάσεις. Άφησε τα δύο τελευταία ασυμπλήρωτα και το παιχνίδι θα σε προειδοποιήσει πριν από τη σέντρα αντί να διαλέξει αθόρυβα για σένα.';

  @override
  String get tourSquadTitle => 'Όλοι όσοι μπορείς να επιλέξεις';

  @override
  String get tourSquadBody =>
      'Ολόκληρη η δεξαμενή, όχι μόνο η αποστολή: ποιος είναι σε φόρμα, ποιος έχει χτύπημα, ποιος είναι τιμωρημένος και ποιος μόλις βγήκε από την ακαδημία.';

  @override
  String get tourCallUpsTitle => 'Ανακοίνωση αποστολής';

  @override
  String get tourCallUpsBody =>
      'Ανακοινώνεις μία αποστολή ανά διεθνές παράθυρο και παίζει όλους τους αγώνες του παραθύρου, ακριβώς όπως ένας πραγματικός προπονητής. Ένας τραυματισμός μέσα στο παράθυρο φέρνει αντικαταστάτη για σένα.';

  @override
  String get tourRecordsTitle => 'Η καριέρα σου';

  @override
  String get tourRecordsBody =>
      'Όλα όσα έχεις κάνει: οι αγώνες, τα ρεκόρ της ομάδας, τα τρόπαια και κάθε εθνική που έχεις οδηγήσει.';

  @override
  String get tourCupsTitle => 'Ο υπόλοιπος κόσμος';

  @override
  String get tourCupsBody =>
      'Κάθε διοργάνωση που τρέχει αυτή τη στιγμή: όμιλοι, βαθμολογίες και νοκ άουτ, και εκείνες που δεν συμμετέχεις. Ο κόσμος συνεχίζει να παίζει είτε προκρίθηκες είτε όχι.';

  @override
  String get settingsTourTitle => 'Επανάληψη του οδηγού';

  @override
  String get settingsTourBlurb =>
      'Περπάτα ξανά τις βασικές οθόνες από την αρχή.';

  @override
  String get tourBoardTitle => 'Σε ποιον λογοδοτείς';

  @override
  String get tourBoardBody =>
      'Η εμπιστοσύνη της διοίκησης σε εσένα και οι στόχοι που έχει θέσει για αυτόν τον κύκλο. Αν χάσεις τον στόχο, εδώ θα το δεις να έρχεται.';

  @override
  String get tourStaffTitle => 'Οι άνθρωποι γύρω σου';

  @override
  String get tourStaffBody =>
      'Ένας βοηθός, ένας σκάουτ και ένας γυμναστής, που προσλαμβάνονται με όνομα. Οι μισθοί τους βγαίνουν από αυτόν τον προϋπολογισμό πριν από τα τμήματα, οπότε ένας εξαιρετικός σκάουτ είναι απόφαση εις βάρος της ακαδημίας.';

  @override
  String get tourPlaystyleTitle => 'Ο τρόπος παιχνιδιού σου';

  @override
  String get tourPlaystyleBody =>
      'Το σύστημα είναι μόνο το μισό της τακτικής. Αυτό είναι το άλλο μισό: πόσο ψηλά πιέζεις, πόσο άμεσα παίζεις, πόσο ρισκάρεις.';

  @override
  String get settingsTourNoSave =>
      'Ξεκίνα πρώτα μια καριέρα. Ο οδηγός περνά από τις δικές σου οθόνες.';

  @override
  String tacticsOutOfPositionAge(int age) {
    return 'Εκτός θέσης · Ηλικία $age';
  }

  @override
  String get federationNextCycleLocked =>
      'Ο προϋπολογισμός του επόμενου κύκλου καθορίζεται στην αρχή εκείνου του κύκλου, μονομιάς. Μέχρι τότε, αυτό κάνουν τα χρήματά σου.';

  @override
  String get federationBudgetAlreadySet =>
      'Έχει ήδη οριστεί για αυτόν τον κύκλο';

  @override
  String yFinalLooms0(String opponent) {
    return 'Τελικός με αντίπαλο: $opponent. Όλη την εβδομάδα μόνο για αυτό θα μιλάνε.';
  }

  @override
  String yFinalLooms1(String opponent) {
    return 'Επιβεβαιώθηκε, αντίπαλος στον δρόμο μας: $opponent. Τέσσερα χρόνια για αυτό.';
  }

  @override
  String yFinalLooms2(String opponent) {
    return 'Λοιπόν. Αντίπαλος: $opponent. Κανείς δεν κοιμάται μέχρι να τελειώσει.';
  }

  @override
  String yFinalLooms3(String opponent) {
    return 'Επόμενος αντίπαλος: $opponent, και όλα τα άλλα μπορούν να περιμένουν. Τι εβδομάδα να ζεις.';
  }

  @override
  String get matchSetupLeaveToCoach => 'Άφησε τους εκτελεστές στον προπονητή';

  @override
  String friendliesLikeYourGroup(String rivals) {
    return 'Με σήμανση παρακάτω: ομάδες που παίζουν όπως $rivals, τους αντιπάλους σου στους ομίλους αυτού του κύκλου.';
  }

  @override
  String newsTransferWindowTitle(int year) {
    return 'Μεταγραφική περίοδος · $year';
  }

  @override
  String careerLastAgo(String when) {
    return 'Πριν από $when';
  }

  @override
  String get settingsFreeScopeTitle => 'Ένας δωρεάν τετραετής κύκλος';

  @override
  String get settingsFreeScopeBlurb =>
      'Ένας πλήρης κύκλος (προκριματικά, το ηπειρωτικό σου πρωτάθλημα και το Παγκόσμιο Πρωτάθλημα) σε δύο αποθηκεύσεις, με κάθε χώρα του κόσμου, χωρίς περιορισμούς. Οι ατελείωτοι κύκλοι και οι απεριόριστες αποθηκεύσεις είναι μία μόνο πληρωμή, μία φορά, και καλύπτει κάθε μελλοντική ενημέρωση.';

  @override
  String get settingsUnlockedTitle => 'Ξεκλειδώθηκε';

  @override
  String get settingsUnlockedBlurb =>
      'Ατελείωτοι κύκλοι, απεριόριστες αποθηκεύσεις και κάθε μελλοντική ενημέρωση. Ευχαριστούμε.';

  @override
  String get settingsFromDeveloperTitle => 'Από τον δημιουργό';

  @override
  String get settingsFromDeveloperBlurb =>
      'Το Football Nations Manager φτιάχνεται από έναν άνθρωπο και θα υποστηρίζεται μακροπρόθεσμα. Δεν θα υπάρξουν ποτέ διαφημίσεις ή μικροσυναλλαγές. Αν σου αρέσει το παιχνίδι, σκέψου να αγοράσεις την πλήρη έκδοση. Είναι αυτό που κρατά τις ενημερώσεις να έρχονται.';

  @override
  String get settingsFromDeveloperThanksBlurb =>
      'Το Football Nations Manager φτιάχνεται από έναν άνθρωπο και θα υποστηρίζεται μακροπρόθεσμα. Δεν θα υπάρξουν ποτέ διαφημίσεις ή μικροσυναλλαγές. Ευχαριστούμε που αγόρασες την πλήρη έκδοση. Είναι αυτό που κρατά τις ενημερώσεις να έρχονται.';

  @override
  String friendliesLikeYourCampaign(String rivals) {
    return 'Με σήμανση παρακάτω: ομάδες που παίζουν όπως $rivals, τους αντιπάλους που σου μένουν ακόμα.';
  }

  @override
  String get friendliesCloseToYou =>
      'Με σήμανση παρακάτω: οι ομάδες που βρίσκονται πιο κοντά σου στην παγκόσμια κατάταξη. Μόλις γίνει η κλήρωση, οι σημάνσεις ακολουθούν τον όμιλό σου.';

  @override
  String transfersMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count μεταγραφές',
      one: '1 μεταγραφή',
    );
    return '$_temp0';
  }

  @override
  String hubRoundPage(int page, int pages) {
    return '$page / $pages';
  }

  @override
  String get transfersNewer => 'Νεότερες';

  @override
  String get transfersOlder => 'Περισσότερες';

  @override
  String get transfersPagePrevious => 'Προηγούμενη';

  @override
  String get transfersPageNext => 'Επόμενη';

  @override
  String transfersPageOf(int page, int pages) {
    return 'Σελίδα $page από $pages';
  }

  @override
  String get transfersMovedTo => 'Μετακόμισε σε';

  @override
  String get transfersUnknownClub => 'Άγνωστη ομάδα';

  @override
  String yAgainstThemAgain0(String opponent, String count) {
    return '$opponent ξανά, για $countη φορά. Κάποιος κρατά το σκορ, και δεν είμαστε εμείς.';
  }

  @override
  String yAgainstThemAgain1(String opponent, String count) {
    return '$opponent πάλι. $count αναμετρήσεις και ακόμα δεν τους έχουμε βρει.';
  }

  @override
  String yAgainstThemAgain2(String opponent, String count) {
    return 'Αναμέτρηση νούμερο $count, αντίπαλος: $opponent. Έχει πάψει να είναι σύμπτωση.';
  }

  @override
  String yAgainstThemAgain3(String opponent, String count) {
    return 'Αντίπαλος: $opponent, $count αναμετρήσεις, και δεν μάθαμε τίποτα από καμία.';
  }

  @override
  String yAgainstThemAgain4(String opponent, String count) {
    return '$opponent, $count φορές. Ξέρουν ακριβώς τι θα κάνουμε.';
  }

  @override
  String yAgainstThemAgain5(String opponent, String count) {
    return 'Ό,τι κι αν ξέρει για μας ο αντίπαλος ($opponent), μετά από $count αναμετρήσεις το ξέρει ακόμα.';
  }

  @override
  String ySameOldStory0(String count) {
    return '$count φορές έχει συμβεί αυτό τελευταία. Σε ποιο σημείο είναι απλώς αυτό που είμαστε;';
  }

  @override
  String ySameOldStory1(String count) {
    return '$count απογεύματα σαν κι αυτό πια. Είναι μοτίβο, όχι ζήτημα τύχης.';
  }

  @override
  String ySameOldStory2(String count) {
    return 'Έχουμε δει ακριβώς αυτό το παιχνίδι $count φορές τελευταία. Ίδιο σενάριο, ίδιο φινάλε.';
  }

  @override
  String ySameOldStory3(String count) {
    return '$count εκδοχές των ίδιων ενενήντα λεπτών πια. Κανείς δεν το διορθώνει.';
  }

  @override
  String ySameOldStory4(String count) {
    return '$count φορές. Αν δεν βλέπεις το μοτίβο μέχρι τώρα, δεν κοιτάς.';
  }

  @override
  String ySameOldStory5(String count) {
    return 'Ίδια ιστορία, $count φορές. Οι δικαιολογίες τελείωσαν πριν από τα αποτελέσματα.';
  }

  @override
  String get yToldYouSo0 =>
      'Είπα ότι θα έρθει, ενώ όλοι ήταν απασχολημένοι με τους πανηγυρισμούς.';

  @override
  String get yToldYouSo1 =>
      'Δύο καλές εβδομάδες και ξαναγίναμε χρυσή γενιά. Και να που είμαστε.';

  @override
  String get yToldYouSo2 =>
      'Όσοι μου έλεγαν να το απολαύσω τον περασμένο μήνα έχουν σωπάσει.';

  @override
  String get yToldYouSo3 =>
      'Δεν νιώθω ευχαρίστηση. Πολύ λίγη ευχαρίστηση. Λίγη.';

  @override
  String get yToldYouSo4 =>
      'Ποτέ δεν ήταν τόσο καλά όσο σας έλεγαν, και αυτό είναι η απόδειξη.';

  @override
  String get yToldYouSo5 =>
      'Κάθε φορά. Μας λένε ότι είναι διαφορετικά, και κάθε φορά δεν είναι.';

  @override
  String get tacticsSubOffAlready => 'Έχει ήδη βγει';

  @override
  String get tacticsSubInjured => 'Τραυματίας';

  @override
  String get tacticsSubSentOffMark => 'Αποβλήθηκε';

  @override
  String get tacticsSubNoneLeft => 'Δεν απομένουν αλλαγές';

  @override
  String get tacticsUndoLastChange => 'Αναίρεση τελευταίας αλλαγής';

  @override
  String get matchStrengthTitle => 'ΤΙ ΚΙΝΕΙ ΤΗΝ ΟΜΑΔΑ';

  @override
  String get strengthFactorFamiliarity => 'Εμπεδωμένο σύστημα';

  @override
  String get strengthFactorFatigue => 'Κουρασμένα πόδια';

  @override
  String get strengthFactorClubForm => 'Φόρμα συλλόγων';

  @override
  String get strengthFactorMorale => 'Αποδυτήρια';

  @override
  String get strengthFactorCaptain => 'Αρχηγός';

  @override
  String get strengthFactorStaff => 'Επιτελείο';

  @override
  String get strengthFactorDossier => 'Φάκελος σκάουτ';

  @override
  String yDebut0(String name) {
    return '$name: πρώτη συμμετοχή. Θυμηθείτε το όνομα.';
  }

  @override
  String yDebut1(String name) {
    return 'Ντεμπούτο για $name. Φαίνεται πάνω του, έτσι δεν είναι;';
  }

  @override
  String yDebut2(String name) {
    return '$name, πρώτη συμμετοχή. Να δούμε τι θα κάνει με αυτήν.';
  }

  @override
  String yDebut3(String name) {
    return 'Ντεμπούτο για $name. Η αποστολή χρειαζόταν φρέσκα πόδια κάπου.';
  }

  @override
  String yDebut4(String name) {
    return '$name: του δόθηκε συμμετοχή. Έχουμε μοιράσει πολλές τελευταία.';
  }

  @override
  String yDebut5(String name) {
    return 'Ντεμπούτο για $name. Άλλος ένας που θα έχουμε ξεχάσει ως την άνοιξη.';
  }

  @override
  String yDrought0(String name, String count) {
    return '$name: $count αγώνες χωρίς γκολ, και κάνει όλα τα υπόλοιπα στο γήπεδο.';
  }

  @override
  String yDrought1(String name, String count) {
    return '$count αγώνες χωρίς γκολ για $name. Τα γκολ έρχονται τρία τρία, πάντα έτσι ήταν.';
  }

  @override
  String yDrought2(String name, String count) {
    return '$name: $count αγώνες, κανένα γκολ.';
  }

  @override
  String yDrought3(String name, String count) {
    return '$count αγώνες χωρίς γκολ για $name. Αξίζει να τον προσέχουμε.';
  }

  @override
  String yDrought4(String name, String count) {
    return '$count αγώνες. Κανένα γκολ. $name: δεν θα έβαζε γκολ ούτε σε ανοιχτή εστία.';
  }

  @override
  String yDrought5(String name, String count) {
    return '$name: $count αγώνες χωρίς γκολ. Παίξτε κυριολεκτικά οποιονδήποτε άλλο.';
  }

  @override
  String yRivalryLooms0(String opponent, String count) {
    return 'Αντίπαλος: $opponent. $count αναμετρήσεις και ακόμα όλα μετράνε.';
  }

  @override
  String yRivalryLooms1(String opponent, String count) {
    return '$count φορές με αντίπαλο $opponent πια. Ας έρθει.';
  }

  @override
  String yRivalryLooms2(String opponent, String count) {
    return 'Επόμενος αντίπαλος: $opponent. Παίχτηκαν $count.';
  }

  @override
  String yRivalryLooms3(String opponent, String count) {
    return 'Αναμέτρηση νούμερο $count αυτή την εβδομάδα, αντίπαλος: $opponent.';
  }

  @override
  String yRivalryLooms4(String opponent, String count) {
    return '$opponent πάλι. $count από αυτά και δεν έχουμε μάθει τίποτα.';
  }

  @override
  String yRivalryLooms5(String opponent, String count) {
    return '$count αγώνες με αντίπαλο $opponent και ακόμα μας κερδίζουν. Υπέροχα.';
  }

  @override
  String get positionGoalkeeper => 'Τερματοφύλακας';

  @override
  String get positionLeftBack => 'Αριστερός Μπακ';

  @override
  String get positionCentreBack => 'Στόπερ';

  @override
  String get positionRightBack => 'Δεξιός Μπακ';

  @override
  String get positionDefensiveMid => 'Αμυντικός Χαφ';

  @override
  String get positionCentralMid => 'Κεντρικός Χαφ';

  @override
  String get positionAttackingMid => 'Επιθετικός Χαφ';

  @override
  String get positionLeftMid => 'Αριστερός Χαφ';

  @override
  String get positionRightMid => 'Δεξιός Χαφ';

  @override
  String get positionLeftWing => 'Αριστερό Εξτρέμ';

  @override
  String get positionRightWing => 'Δεξί Εξτρέμ';

  @override
  String get positionStriker => 'Σέντερ Φορ';

  @override
  String get roleNone => 'Χωρίς ρόλο';

  @override
  String get roleTargetMan => 'Σέντερ φορ στήριξης';

  @override
  String get rolePoacher => 'Φοξ της περιοχής';

  @override
  String get rolePlaymaker => 'Δημιουργός';

  @override
  String get roleBallWinner => 'Κόφτης';

  @override
  String get roleInvertedWinger => 'Εξτρέμ προς τα μέσα';

  @override
  String get roleBallPlayingDefender => 'Αμυντικός δημιουργός';

  @override
  String get roleNoneBlurb => 'Παίζει το φυσικό του παιχνίδι.';

  @override
  String get roleTargetManBlurb =>
      'Κερδίζει τις κεφαλιές, δίνει πάσα πίσω. Ασίστ και στατικές φάσεις.';

  @override
  String get rolePoacherBlurb =>
      'Παραμονεύει στην περιοχή. Πολύ περισσότερα γκολ.';

  @override
  String get rolePlaymakerBlurb =>
      'Δημιουργεί ευκαιρίες. Πολύ περισσότερες ασίστ.';

  @override
  String get roleBallWinnerBlurb => 'Κόβει το παιχνίδι αντί να το τελειώνει.';

  @override
  String get roleInvertedWingerBlurb =>
      'Μπαίνει προς τα μέσα για σουτ. Περισσότερα γκολ.';

  @override
  String get roleBallPlayingDefenderBlurb => 'Ξεκινά τις φάσεις από πίσω.';

  @override
  String get federationDeptYouth => 'Ακαδημία Νέων';

  @override
  String get federationDeptCommercial => 'Εμπορικό / PR';

  @override
  String get federationDeptMedical => 'Ιατρικό & Αθλητική Επιστήμη';

  @override
  String get federationDeptNaturalisation => 'Γραφείο Πολιτογράφησης';

  @override
  String get federationDeptBoardRelations => 'Σχέσεις με τη Διοίκηση';

  @override
  String get federationDeptYouthBlurb =>
      'Καλύτερα ταλέντα της ακαδημίας κάνουν ντεμπούτο στην εθνική σου τον επόμενο κύκλο.';

  @override
  String get federationDeptCommercialBlurb =>
      'Οι χορηγίες φέρνουν έξτρα έσοδα στο τέλος του κύκλου.';

  @override
  String get federationDeptMedicalBlurb =>
      'Λιγότεροι τραυματισμοί. Η αποστολή σου μένει διαθέσιμη όλο τον κύκλο.';

  @override
  String get federationDeptNaturalisationBlurb =>
      'Περισσότεροι ξένοι παίκτες προσφέρονται να αλλάξουν εθνική και να παίξουν για τη δική σου.';

  @override
  String get federationDeptBoardRelationsBlurb =>
      'Η διοίκηση κρίνει τα αποτελέσματά σου με περισσότερη υπομονή.';

  @override
  String get federationBuildingAcademy => 'Ακαδημία';

  @override
  String get federationBuildingCommercial => 'Εμπορικά Κεντρικά';

  @override
  String get federationBuildingMedical => 'Ιατρικό Κέντρο';

  @override
  String get federationBuildingScouting => 'Γραφείο Σκάουτινγκ';

  @override
  String get federationBuildingBoardroom => 'Αίθουσα Διοίκησης';

  @override
  String get moraleBuoyant => 'Ανεβασμένο';

  @override
  String get moralePositive => 'Θετικό';

  @override
  String get moraleSettled => 'Σταθερό';

  @override
  String get moraleUneasy => 'Ανήσυχο';

  @override
  String get moraleRockBottom => 'Στο ναδίρ';

  @override
  String get matchTabTimeline => 'ΧΡΟΝΟΛΟΓΙΟ';

  @override
  String get matchTabStats => 'ΣΤΑΤΙΣΤΙΚΑ';

  @override
  String get matchTabLineups => 'ΕΝΔΕΚΑΔΕΣ';

  @override
  String get matchPenalty => 'ΠΕΝΑΛΤΙ';

  @override
  String get matchStateLevel => 'Όλα ισόπαλα';

  @override
  String matchStateLead(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Προηγείσαι με $count γκολ',
      one: 'Προηγείσαι με ένα γκολ',
    );
    return '$_temp0';
  }

  @override
  String matchStateTrail(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Χάνεις με $count γκολ',
      one: 'Χάνεις με ένα γκολ',
    );
    return '$_temp0';
  }

  @override
  String matchPossessionShare(int possession) {
    return '$possession% κατοχή';
  }

  @override
  String get boardVerdictSackedTitle => 'Η διοίκηση σε απέλυσε';

  @override
  String boardVerdictSackedBody(int rating) {
    return 'Ένας άθλιος κύκλος (βαθμολογία $rating%). Η θητεία σου τελειώνει εδώ. Τώρα μόνο μικρότερες χώρες θα ρισκάρουν μαζί σου.';
  }

  @override
  String get boardVerdictDelightedTitle => 'Η διοίκηση είναι ενθουσιασμένη';

  @override
  String boardVerdictDelightedBody(int rating, String best) {
    return 'Ένας εξαιρετικός κύκλος (βαθμολογία $rating%). Κορυφαία πορεία: $best. Μεγαλύτερες χώρες ενδιαφέρονται, αλλιώς μπορείς να μείνεις και να χτίσεις.';
  }

  @override
  String get boardVerdictSolidTitle => 'Ένας σταθερός κύκλος';

  @override
  String boardVerdictSolidBody(int rating) {
    return 'Η διοίκηση είναι ικανοποιημένη (βαθμολογία $rating%). Μερικές χώρες παρόμοιου επιπέδου θα σε δέχονταν, αλλά δεν υπάρχει πίεση να φύγεις.';
  }

  @override
  String get boardVerdictExpectedMoreTitle => 'Η διοίκηση περίμενε περισσότερα';

  @override
  String boardVerdictExpectedMoreBody(int rating) {
    return 'Ένας απογοητευτικός κύκλος (βαθμολογία $rating%). Κρατάς τη θέση σου, αλλά κάθε πρόταση θα είναι βήμα πίσω.';
  }

  @override
  String get boardVerdictPressureTitle => 'Δέχεσαι πραγματική πίεση';

  @override
  String boardVerdictPressureBody(int rating) {
    return 'Ένας κακός κύκλος (βαθμολογία $rating%). Επιβιώνεις, αλλά αν θες νέο ξεκίνημα, ενδιαφέρονται μόνο πιο αδύναμες χώρες.';
  }

  @override
  String get boardVerdictHeroTitle => 'Η χώρα στέκεται δίπλα σου';

  @override
  String boardVerdictHeroNote(String nation, int cycles) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles κύκλους',
      one: '1 κύκλο',
    );
    return ' $nation: σε λατρεύουν, είσαι εθνικός ήρωας μετά από $_temp0. Η θέση σου είναι ασφαλής για όσο τη θέλεις.';
  }

  @override
  String get boardVerdictTheNation => 'Η χώρα';

  @override
  String get boardVerdictBestQuiet => 'ένας ήσυχος κύκλος';

  @override
  String get boardVerdictBestCycle => 'ολόκληρος ο κύκλος';

  @override
  String boardVerdictBestWorld(String placement) {
    return 'Παγκόσμιο Πρωτάθλημα, $placement';
  }

  @override
  String get finishThirdPlace => 'Τρίτη θέση';

  @override
  String get finishFourthPlace => 'Τέταρτη θέση';

  @override
  String get finishDidNotQualify => 'Δεν προκρίθηκε';

  @override
  String get careerRepIconic => 'Θρυλικός';

  @override
  String get careerRepRenowned => 'Διάσημος';

  @override
  String get careerRepEstablished => 'Καθιερωμένος';

  @override
  String get careerRepRising => 'Ανερχόμενος';

  @override
  String get careerRepUnproven => 'Αδοκίμαστος';

  @override
  String get hubOfferStepUp => 'Βήμα μπροστά';

  @override
  String get hubOfferLateral => 'Πλάγια μετακίνηση';

  @override
  String get hubOfferRebuild => 'Ανοικοδόμηση';

  @override
  String careerNationsCupWon(String league) {
    return 'Κατηγορία $league · Πρωταθλητές';
  }

  @override
  String careerNationsCupRunnerUp(String league) {
    return 'Κατηγορία $league · Φιναλίστ';
  }

  @override
  String careerNationsCupSemi(String league) {
    return 'Κατηγορία $league · Ημιτελικός';
  }

  @override
  String careerNationsCupPlaced(String league, int position) {
    return 'Κατηγορία $league · #$position';
  }

  @override
  String tourRunInto(String round) {
    return 'Επόμενη φάση: $round';
  }

  @override
  String get tourRunIntoThirdPlace => 'Στον αγώνα για την τρίτη θέση';

  @override
  String tourRunThrough(String round) {
    return 'Πρόκριση: $round';
  }

  @override
  String tourRunOut(String round) {
    return 'Αποκλεισμός: $round';
  }

  @override
  String get tourRunInGroup => 'Στη φάση των ομίλων';

  @override
  String get tourRunGroupOut => 'Αποκλεισμός στη φάση των ομίλων';

  @override
  String resultsCycleTitle(int year, String nation) {
    return 'Κύκλος $year · $nation';
  }

  @override
  String resultsCycleRecord(int played, int won, int drawn, int lost) {
    return '$played αγώνες  ·  $wonΝ $drawnΙ $lostΗ';
  }

  @override
  String resultsCycleFinish(String finish) {
    return 'Παγκόσμιο Πρωτάθλημα: $finish';
  }

  @override
  String get resultsCycleUnderway => 'Σε εξέλιξη';

  @override
  String yTurnedItRound0(String opponent) {
    return 'Αντίπαλος $opponent: δύο γκολ πίσω στο ημίχρονο και τα πήραν όλα πίσω. Αυτή είναι ομάδα.';
  }

  @override
  String yTurnedItRound1(String opponent) {
    return 'Δύο γκολ πίσω, αντίπαλος $opponent, και στο τέλος δεν είχε σημασία. Λίγες ομάδες το καταφέρνουν.';
  }

  @override
  String yTurnedItRound2(String opponent) {
    return 'Ημίχρονο: δύο γκολ πίσω, αντίπαλος $opponent. Τέλος αγώνα: όχι πια. Το δεύτερο ημίχρονο ήταν άλλος αγώνας.';
  }

  @override
  String yTurnedItRound3(String opponent) {
    return 'Γυρίσαμε το δύο μηδέν. Αντίπαλος: $opponent. Ό,τι ειπώθηκε στο ημίχρονο, ας ειπωθεί κάθε εβδομάδα.';
  }

  @override
  String yTurnedItRound4(String opponent) {
    return 'Εντάξει, τα πήραμε πίσω. Αντίπαλος: $opponent. Τώρα κάποιος να μας εξηγήσει τα πρώτα σαράντα πέντε λεπτά.';
  }

  @override
  String yTurnedItRound5(String opponent) {
    return 'Δύο γκολ πίσω, αντίπαλος $opponent, και πρέπει να χαιρόμαστε. Φτιάξτε το πρώτο ημίχρονο.';
  }

  @override
  String yThrewItAway0(String opponent) {
    return 'Δύο γκολ μπροστά στο ημίχρονο, αντίπαλος $opponent, και ξέφυγε. Συμβαίνει και σε καλύτερες ομάδες.';
  }

  @override
  String yThrewItAway1(String opponent) {
    return 'Δύο γκολ μπροστά, αντίπαλος $opponent, και χάθηκε. Μακρύς κύκλος μπροστά μας, έχουμε χρόνο.';
  }

  @override
  String yThrewItAway2(String opponent) {
    return 'Ημίχρονο: δύο γκολ μπροστά, αντίπαλος $opponent. Τέλος αγώνα: τίποτα τέτοιο.';
  }

  @override
  String yThrewItAway3(String opponent) {
    return 'Προβάδισμα δύο γκολ, αντίπαλος $opponent, και χάθηκε μέσα σε σαράντα πέντε λεπτά.';
  }

  @override
  String yThrewItAway4(String opponent) {
    return 'Δύο μπροστά και το χάσαμε. Αντίπαλος: $opponent. Κάποιος θα λογοδοτήσει.';
  }

  @override
  String yThrewItAway5(String opponent) {
    return 'Δύο γκολ μπροστά, αντίπαλος $opponent, και καταφέραμε αυτό. Κάθε φορά.';
  }

  @override
  String get cycleBackupDone =>
      'Η καριέρα αντιγράφηκε στον φάκελο FNM αυτού του τηλεφώνου. Αν απεγκαταστήσεις την εφαρμογή, διαγράφεται: για αντίγραφο αλλού, χρησιμοποίησε το Αντίγραφο ασφαλείας αυτής της αποθήκευσης στην οθόνη αποθηκεύσεων.';

  @override
  String get cycleBackupFailed =>
      'Αυτή τη φορά δεν έγινε αντίγραφο ασφαλείας της καριέρας.';

  @override
  String pressMomentBigWinWarm1(String opponent) {
    return 'Μια βραδιά αξέχαστη, αντίπαλος $opponent. Πόσο περήφανος είστε για αυτή την ομάδα;';
  }

  @override
  String pressMomentBigWinWarm2(String opponent) {
    return 'Αντίπαλος $opponent: δεν άντεξαν απέναντί σας. Είναι αυτή η ομάδα που πάντα πιστεύατε ότι είχατε;';
  }

  @override
  String pressMomentBigWinNeutral1(String opponent) {
    return 'Μεγάλη νίκη, αντίπαλος $opponent. Τι έκανε τη διαφορά απόψε;';
  }

  @override
  String pressMomentBigWinNeutral2(String opponent) {
    return 'Αντίπαλος $opponent: νίκη, και άνετη. Πού κερδήθηκε ο αγώνας;';
  }

  @override
  String pressMomentBigWinHostile1(String opponent) {
    return 'Καλή νίκη, αντίπαλος $opponent. Μία καλή βραδιά: γιατί να πιστέψει κανείς ότι θα κρατήσει;';
  }

  @override
  String pressMomentBigWinHostile2(String opponent) {
    return 'Ωραίο αποτέλεσμα, αντίπαλος $opponent. Ήταν δικό σας το σχέδιο ή το βρήκαν μόνοι τους οι παίκτες;';
  }

  @override
  String pressMomentBigLossWarm1(String opponent) {
    return 'Δύσκολη βραδιά, αντίπαλος $opponent. Τι λέτε στους παίκτες μετά από μια τέτοια;';
  }

  @override
  String pressMomentBigLossWarm2(String opponent) {
    return 'Αντίπαλος $opponent: κανείς δεν το περίμενε. Ήταν απλώς μία από εκείνες τις βραδιές;';
  }

  @override
  String pressMomentBigLossNeutral1(String opponent) {
    return 'Μια ταπεινωτική βραδιά, αντίπαλος $opponent. Τι πήγε στραβά;';
  }

  @override
  String pressMomentBigLossNeutral2(String opponent) {
    return 'Αντίπαλος $opponent: σας διέλυσαν. Είναι αρκετά καλή αυτή η αποστολή;';
  }

  @override
  String pressMomentBigLossHostile1(String opponent) {
    return 'Ήσασταν δεύτεροι σε όλα, αντίπαλος $opponent. Πώς αφήσατε να φτάσει τόσο χαμηλά;';
  }

  @override
  String pressMomentBigLossHostile2(String opponent) {
    return 'Αντίπαλος $opponent: σκόραραν κατά βούληση. Πού ήταν το σχέδιο απόψε;';
  }

  @override
  String pressMomentCrisisWarm1(String opponent) {
    return 'Άλλο ένα χάνεται, αυτή τη φορά με αντίπαλο $opponent. Πώς γυρίζετε αυτή τη σειρά;';
  }

  @override
  String pressMomentCrisisWarm2(String opponent) {
    return 'Τα αποτελέσματα στέρεψαν και ο αντίπαλος $opponent τα χειροτέρεψε. Πιστεύετε ακόμα σε αυτή την ομάδα;';
  }

  @override
  String pressMomentCrisisNeutral1(String opponent) {
    return 'Πάλι χωρίς νίκη, τώρα με αντίπαλο $opponent, και η διοίκηση παρακολουθεί. Είναι ασφαλής η θέση σας;';
  }

  @override
  String pressMomentCrisisNeutral2(String opponent) {
    return 'Μετά τον αντίπαλο $opponent, η σειρά μεγαλώνει. Ανησυχείτε για το μέλλον σας;';
  }

  @override
  String pressMomentCrisisHostile1(String opponent) {
    return 'Και τώρα ο αντίπαλος $opponent. Ο προκάτοχός σας απολύθηκε με μια τέτοια πορεία. Γιατί να επιβιώσετε εσείς;';
  }

  @override
  String pressMomentCrisisHostile2(String opponent) {
    return 'Μετά από άλλη μια βραδιά σαν αυτή με αντίπαλο $opponent, όλες οι εκπομπές ζητούν την παραίτησή σας. Θα παραιτηθείτε αν σας το ζητούσε η διοίκηση;';
  }

  @override
  String pressMomentJobVerdictWarm1(String opponent) {
    return 'Βάλατε τη θέση σας στη γραμμή, και μετά τον αντίπαλο $opponent δεν πήγε όπως θέλατε. Πώς το αντέχετε;';
  }

  @override
  String pressMomentJobVerdictWarm2(String opponent) {
    return 'Οι τρεις αγώνες τελείωσαν, ο τελευταίος με αντίπαλο $opponent. Το τεστ το βάλατε μόνος σας. Τι σκέφτεστε για την κρίση;';
  }

  @override
  String pressMomentJobVerdictNeutral1(String opponent) {
    return 'Μας είπατε να σας κρίνουμε στους επόμενους τρεις. Μετά τον αντίπαλο $opponent, σας κρίναμε. Είναι ακόμα δική σας η θέση;';
  }

  @override
  String pressMomentJobVerdictNeutral2(String opponent) {
    return 'Τρεις αγώνες, ο τελευταίος με αντίπαλο $opponent, και όχι αυτό που υποσχεθήκατε. Μιλήσατε με τη διοίκηση για το μέλλον σας;';
  }

  @override
  String pressMomentJobVerdictHostile1(String opponent) {
    return 'Βάλατε μόνος σας το τεστ και αποτύχατε, με αντίπαλο $opponent. Θα παραιτηθείτε;';
  }

  @override
  String pressMomentJobVerdictHostile2(String opponent) {
    return 'Δικά σας λόγια, όχι δικά μας: κρίνετέ με στους επόμενους τρεις. Μετά τον αντίπαλο $opponent, γιατί κάθεστε ακόμα εκεί;';
  }

  @override
  String get pressBeatWhoToBlameWarm1 =>
      'Θέλετε περισσότερα από αυτούς. Κάποιον συγκεκριμένα;';

  @override
  String get pressBeatWhoToBlameWarm2 =>
      'Βάλατε ψηλά τον πήχη. Ποιος πρέπει να σηκώσει πρώτος το βάρος;';

  @override
  String get pressBeatWhoToBlameNeutral1 =>
      'Λέτε ότι κάποιοι πρέπει να κοιταχτούν στον καθρέφτη. Ποιους εννοείτε;';

  @override
  String get pressBeatWhoToBlameNeutral2 =>
      'Δεν ήταν αρκετό, λέτε. Για ποιον μιλάτε;';

  @override
  String get pressBeatWhoToBlameHostile1 =>
      'Τα λέτε αόριστα. Θα πείτε ονόματα ή θα γυρίσει εναντίον σας;';

  @override
  String get pressBeatWhoToBlameHostile2 =>
      'Κάθε εβδομάδα φταίει κάποιος άλλος. Ποιος αυτή τη φορά;';

  @override
  String get pressBeatIfYouDontWarm1 =>
      'Τολμηρά λόγια. Κι αν ο επόμενος δεν πάει όπως θέλετε;';

  @override
  String get pressBeatIfYouDontWarm2 =>
      'Η χώρα θα σας κρατήσει σε αυτό. Κι αν δεν βγει;';

  @override
  String get pressBeatIfYouDontNeutral1 => 'Κι αν δεν τον κερδίσετε; Τότε τι;';

  @override
  String get pressBeatIfYouDontNeutral2 =>
      'Το είπατε πια. Τι γίνεται αν κάνετε λάθος;';

  @override
  String get pressBeatIfYouDontHostile1 =>
      'Έχουμε ακούσει υποσχέσεις σε αυτή την αίθουσα και πριν. Τι οφείλετε στους οπαδούς αν σπάσει κι αυτή;';

  @override
  String get pressBeatIfYouDontHostile2 =>
      'Κι όταν δεν γίνει, ποια θα είναι η δικαιολογία;';

  @override
  String get pressBeatFollowUpWarm1 =>
      'Μία ακόμα, αν αντέχετε. Τι χρειάζεται ακόμα να δουλέψει αυτή η ομάδα;';

  @override
  String get pressBeatFollowUpWarm2 =>
      'Όταν κατακάτσει η σκόνη, τι παίρνετε από απόψε για τον επόμενο αγώνα;';

  @override
  String get pressBeatFollowUpNeutral1 =>
      'Ας πάμε λίγο πιο βαθιά. Τι πρέπει να βελτιωθεί πριν από τον επόμενο αγώνα;';

  @override
  String get pressBeatFollowUpNeutral2 =>
      'Πέρα από το σκορ: είναι αυτή η αποστολή εκεί που θέλετε;';

  @override
  String get pressBeatFollowUpHostile1 =>
      'Πολλά λόγια, λίγα ειπωμένα. Τι αλλάζει πραγματικά από εδώ και πέρα;';

  @override
  String get pressBeatFollowUpHostile2 =>
      'Οι οπαδοί θέλουν μια ξεκάθαρη απάντηση. Είναι αυτή η ομάδα αρκετά καλή, ναι ή όχι;';

  @override
  String pressBeatStandoutWarm1(String player) {
    return '$player: εξαιρετικός απόψε. Πόσο μακριά μπορεί να φτάσει;';
  }

  @override
  String pressBeatStandoutWarm2(String player) {
    return '$player: σε όλους τους τίτλους απόψε. Το περιμένατε;';
  }

  @override
  String pressBeatStandoutNeutral1(String player) {
    return '$player: ξεχώρισε. Τι του ζητήσατε απόψε;';
  }

  @override
  String pressBeatStandoutNeutral2(String player) {
    return '$player: ήταν αυτός η διαφορά απόψε;';
  }

  @override
  String pressBeatStandoutHostile1(String player) {
    return '$player: χωρίς αυτόν είναι άλλη ιστορία. Είναι αυτή ομάδα ή ένας παίκτης;';
  }

  @override
  String pressBeatStandoutHostile2(String player) {
    return '$player: ήταν υπέροχος. Δικό σας έργο ή δικό του;';
  }

  @override
  String pressBeatStrugglerWarm1(String player) {
    return '$player: είχε δύσκολη βραδιά. Κουβαλάει κάποιο χτύπημα;';
  }

  @override
  String pressBeatStrugglerWarm2(String player) {
    return '$player: δεν ήταν η βραδιά του. Θα του σταθείτε δίπλα;';
  }

  @override
  String pressBeatStrugglerNeutral1(String player) {
    return '$player: δυσκολεύτηκε απόψε. Κρατάει τη θέση του;';
  }

  @override
  String pressBeatStrugglerNeutral2(String player) {
    return '$player: έμοιαζε να μην προλαβαίνει τον ρυθμό. Τι σκέφτεστε για τον αγώνα του;';
  }

  @override
  String pressBeatStrugglerHostile1(String player) {
    return '$player: ήταν πάλι επιβάτης. Γιατί συνεχίζετε να τον επιλέγετε;';
  }

  @override
  String pressBeatStrugglerHostile2(String player) {
    return '$player: όλοι είδαν ότι δεν ήταν στο παιχνίδι. Όλοι εκτός από τον πάγκο;';
  }

  @override
  String get pressThrowbackWinNextKeptWarm =>
      'Είπατε ότι θα κερδίσετε τον επόμενο, και τον κερδίσατε. Νιώθετε όμορφα που είχατε δίκιο;';

  @override
  String get pressThrowbackWinNextKeptNeutral =>
      'Υποσχεθήκατε νίκη στον επόμενο αγώνα και την φέρατε. Αυτοπεποίθηση ή έπαρση;';

  @override
  String get pressThrowbackWinNextKeptHostile =>
      'Είπατε ότι θα κερδίσετε τον επόμενο, και τον κερδίσατε. Τύχη, ή πρέπει να αρχίσουμε να σας ακούμε;';

  @override
  String get pressThrowbackWinNextBrokenWarm =>
      'Μας είπατε ότι θα κερδίσετε εκείνον τον αγώνα. Δεν έγινε. Τι πήγε στραβά;';

  @override
  String get pressThrowbackWinNextBrokenNeutral =>
      'Είπατε ότι θα κερδίσετε τον επόμενο. Δεν τον κερδίσατε. Γιατί να πιστέψουμε την επόμενη υπόσχεση;';

  @override
  String get pressThrowbackWinNextBrokenHostile =>
      'Είπατε ότι θα κερδίσετε τον επόμενο. Δεν τον κερδίσατε. Έχουν ακόμα νόημα τα λόγια σας σε αυτή την αίθουσα;';

  @override
  String get pressThrowbackJobKeptWarm =>
      'Ζητήσατε να κριθείτε σε τρεις αγώνες, και περάσατε. Δικαίωση;';

  @override
  String get pressThrowbackJobKeptNeutral =>
      'Κρίνετέ με στους επόμενους τρεις, είπατε. Σας κρίναμε και ήρθαν τα αποτελέσματα. Τι σας έμαθε αυτό το τεστ;';

  @override
  String get pressThrowbackJobKeptHostile =>
      'Δώσατε στον εαυτό σας τρεις αγώνες και τους περάσατε. Ήταν ποτέ τόσο δύσκολο το τεστ;';

  @override
  String get pressThrowbackJobBrokenWarm =>
      'Ζητήσατε να κριθείτε σε τρεις αγώνες. Δεν πήγαν όπως θέλατε. Τι μάθατε;';

  @override
  String get pressThrowbackJobBrokenNeutral =>
      'Είπατε κρίνετέ με στους επόμενους τρεις. Οι τρεις πέρασαν, και μαζί τους το ελαφρυντικό. Τώρα τι;';

  @override
  String get pressThrowbackJobBrokenHostile =>
      'Βάλατε το τεστ και αποτύχατε. Γιατί να πάρει κανείς τον λόγο σας στα σοβαρά τώρα;';

  @override
  String pressThrowbackBackKeptWarm(String player) {
    return '$player: τον στηρίξατε όταν άλλοι δεν το έκαναν. Απέδωσε. Σας ανήκει μέρος του μεριδίου;';
  }

  @override
  String pressThrowbackBackKeptNeutral(String player) {
    return '$player: τον στηρίξατε και απέδωσε. Πίστη ή γνώση;';
  }

  @override
  String pressThrowbackBackKeptHostile(String player) {
    return '$player: τον στηρίξατε και για μία φορά βγήκε σωστό. Θα είστε τόσο σίγουρος και την επόμενη;';
  }

  @override
  String pressThrowbackBackBrokenWarm(String player) {
    return '$player: σταθήκατε δίπλα του και δεν βγήκε. Πιστεύετε ακόμα σε αυτόν;';
  }

  @override
  String pressThrowbackBackBrokenNeutral(String player) {
    return '$player: τον στηρίξατε και δεν το ανταπέδωσε. Ήταν λάθος;';
  }

  @override
  String pressThrowbackBackBrokenHostile(String player) {
    return 'Η κρίση σας ή η πίστη σας: τι απέτυχε στην περίπτωση του $player;';
  }

  @override
  String pressThrowbackBlameKeptWarm(String player) {
    return '$player: ήσασταν αυστηρός μαζί του, και οι αγώνες που ακολούθησαν σας δικαίωσαν. Νιώθετε ικανοποίηση;';
  }

  @override
  String pressThrowbackBlameKeptNeutral(String player) {
    return '$player: τον στηλιτεύσατε και δεν απάντησε. Υπάρχει δρόμος επιστροφής για αυτόν;';
  }

  @override
  String pressThrowbackBlameKeptHostile(String player) {
    return '$player: τον αφήσατε εκτεθειμένο και δεν έχει συνέλθει. Τον διαλύσατε;';
  }

  @override
  String pressThrowbackBlameBrokenWarm(String player) {
    return '$player: τον στηλιτεύσατε και σας απάντησε στο γήπεδο. Αυτή ήταν η ιδέα από την αρχή;';
  }

  @override
  String pressThrowbackBlameBrokenNeutral(String player) {
    return '$player: τον κατηγορήσατε και από τότε είναι από τους καλύτερούς σας. Του οφείλετε συγγνώμη;';
  }

  @override
  String pressThrowbackBlameBrokenHostile(String player) {
    return '$player: τον πετάξατε στα λιοντάρια και είναι ο καλύτερός σας από τότε. Θα ζητήσετε συγγνώμη;';
  }

  @override
  String get pressReplyCreditPlayers1 =>
      'Αυτοί οι παίκτες μου έδωσαν τα πάντα. Δεν θα άλλαζα κανέναν τους.';

  @override
  String get pressReplyCreditPlayers2 =>
      'Κανείς δεν δουλεύει σκληρότερα από αυτή την ομάδα. Θα τους υπερασπίζομαι όλη μέρα.';

  @override
  String get pressReplyCreditPlayers3 =>
      'Από αυτή τη θέση δεν θα ακούσετε κακή κουβέντα για τους παίκτες μου.';

  @override
  String get pressReplyCreditPlayers4 =>
      'Οι παίκτες αξίζουν τα εύσημα, όχι εγώ. Γράψτε για αυτούς.';

  @override
  String get pressReplyTakeResponsibility1 =>
      'Αυτός ήταν δικός μου. Εγώ διάλεξα την ενδεκάδα και εγώ την έστησα.';

  @override
  String get pressReplyTakeResponsibility2 =>
      'Κρίνετε εμένα, όχι αυτούς. Είναι η ομάδα μου και η ευθύνη μου.';

  @override
  String get pressReplyTakeResponsibility3 =>
      'Αν θέλετε κάποιον να κατηγορήσετε, κάθομαι εδώ.';

  @override
  String get pressReplyTakeResponsibility4 =>
      'Η ευθύνη είναι δική μου. Αφήστε τους παίκτες έξω από αυτό.';

  @override
  String get pressReplyDemandMore1 =>
      'Θέλω περισσότερα. Κάποιοι ξέρουν ακριβώς τι εννοώ.';

  @override
  String get pressReplyDemandMore2 =>
      'Η προσπάθεια δεν αρκεί σε αυτό το επίπεδο. Θέλω περισσότερα και τους το έχω πει.';

  @override
  String get pressReplyDemandMore3 =>
      'Περιμένω περισσότερα από τον καθένα τους, από αύριο κιόλας.';

  @override
  String get pressReplyDemandMore4 =>
      'Κάποιοι πρέπει να κοιτάξουν τον εαυτό τους. Δεν είμαι ικανοποιημένος.';

  @override
  String get pressReplyPromiseWinNext1 =>
      'Θα κερδίσουμε τον επόμενο. Μπορείτε να το γράψετε.';

  @override
  String get pressReplyPromiseWinNext2 =>
      'Θυμηθείτε τα λόγια μου: κερδίζουμε τον επόμενο αγώνα.';

  @override
  String get pressReplyPromiseWinNext3 =>
      'Επόμενος αγώνας, κερδίζουμε. Το λέω εδώ για να με κρατήσετε σε αυτό.';

  @override
  String get pressReplyPromiseWinNext4 =>
      'Είμαι σίγουρος για αυτή την ομάδα. Κερδίζουμε τον επόμενο αγώνα.';

  @override
  String get pressReplyJobOnTheLine1 =>
      'Κρίνετέ με στους επόμενους τρεις αγώνες. Είναι δίκαιο.';

  @override
  String get pressReplyJobOnTheLine2 =>
      'Δώστε μου τρία παιχνίδια. Αν δεν έχει στρώσει μέχρι τότε, κρίνετέ με για αυτό.';

  @override
  String get pressReplyJobOnTheLine3 =>
      'Οι επόμενοι τρεις θα δείξουν αν είμαι ο σωστός άνθρωπος. Κρατήστε με σε αυτό.';

  @override
  String get pressReplyJobOnTheLine4 =>
      'Τρεις αγώνες. Μετά γράψτε ό,τι θέλετε για μένα.';

  @override
  String get pressReplyDeflect1 =>
      'Πάμε αγώνα τον αγώνα. Δεν έχω κάτι άλλο να προσθέσω.';

  @override
  String get pressReplyDeflect2 => 'Σήμερα δεν θα σας φτιάξω πρωτοσέλιδα.';

  @override
  String get pressReplyDeflect3 => 'Επόμενος αγώνας. Μόνο αυτό σκέφτομαι.';

  @override
  String get pressReplyDeflect4 => 'Ό,τι σκέφτομαι μένει στα αποδυτήρια.';

  @override
  String get pressReplyTakeCredit1 =>
      'Το είπα γιατί το πίστευα, και είχα δίκιο.';

  @override
  String get pressReplyTakeCredit2 => 'Το διάβασα σωστά. Γι\' αυτό είμαι εδώ.';

  @override
  String get pressReplyTakeCredit3 => 'Πείτε το κρίση. Ήξερα τι έλεγα.';

  @override
  String get pressReplyTakeCredit4 =>
      'Πήρα την απόφαση και βγήκε. Αυτό θα το κρατήσω.';

  @override
  String get pressReplyStandByIt1 => 'Είπα αυτό που πίστευα. Το υποστηρίζω.';

  @override
  String get pressReplyStandByIt2 => 'Δεν παίρνω πίσω ούτε λέξη.';

  @override
  String get pressReplyStandByIt3 =>
      'Ίδια απάντηση με τότε. Το εννοούσα και το εννοώ ακόμα.';

  @override
  String get pressReplyStandByIt4 => 'Θα το έλεγα ξανά και αύριο.';

  @override
  String get pressReplyAdmitMistake1 => 'Το έκανα λάθος. Το αναλαμβάνω.';

  @override
  String get pressReplyAdmitMistake2 =>
      'Δίκαιο, το υπολόγισα λάθος. Θα μάθω από αυτό.';

  @override
  String get pressReplyAdmitMistake3 => 'Έκανα λάθος, και μπορώ να το πω.';

  @override
  String get pressReplyAdmitMistake4 =>
      'Αυτή η επιλογή δεν δούλεψε, και ήταν δική μου.';

  @override
  String pressReplyBackPlayer1(String player) {
    return '$player: έχει την πλήρη στήριξή μου. Θα βρει τον ρυθμό του.';
  }

  @override
  String pressReplyBackPlayer2(String player) {
    return '$player: πιστεύω σε αυτόν και θα σας δείξει γιατί.';
  }

  @override
  String pressReplyBackPlayer3(String player) {
    return '$player: δεν θα ακούσετε από μένα κακή κουβέντα για αυτόν. Θα αποδώσει.';
  }

  @override
  String pressReplyBackPlayer4(String player) {
    return '$player μένει στα σχέδιά μου. Δείτε τι θα κάνει στη συνέχεια.';
  }

  @override
  String pressReplyBlamePlayer1(String player) {
    return '$player μας απογοήτευσε απόψε, και το ξέρει.';
  }

  @override
  String pressReplyBlamePlayer2(String player) {
    return '$player: περίμενα πολύ περισσότερα από αυτόν. Πρέπει να απαντήσει.';
  }

  @override
  String pressReplyBlamePlayer3(String player) {
    return '$player δεν ήταν στο επίπεδο. Θα το πω δημόσια.';
  }

  @override
  String pressReplyBlamePlayer4(String player) {
    return '$player: δεν ήταν αρκετό αυτό που έδωσε, και θα το ακούσει από μένα.';
  }

  @override
  String get pressOnRecordWinNext =>
      'Καταγράφηκε: θα κερδίσεις τον επόμενο αγώνα.';

  @override
  String get pressOnRecordJob =>
      'Καταγράφηκε: θα κριθείς στους επόμενους τρεις.';

  @override
  String pressOnRecordBack(String player) {
    return 'Καταγράφηκε: στήριξη, παίκτης $player.';
  }

  @override
  String pressOnRecordBlame(String player) {
    return 'Καταγράφηκε: $player σε απογοήτευσε.';
  }

  @override
  String yStatementKept0(String nation) {
    return '$nation: το είπε και έγινε. Έχετε προπονητή που εννοεί αυτά που λέει.';
  }

  @override
  String yStatementKept1(String nation) {
    return '$nation: το είπε φωναχτά και μετά το έκανε. Αυτός είναι ο άνθρωπος που χρειαζόσασταν.';
  }

  @override
  String yStatementKept2(String nation) {
    return '$nation: το προέβλεψε και βγήκε αληθινό. Δίκαιο.';
  }

  @override
  String yStatementKept3(String nation) {
    return 'Το έβαλε στα πρακτικά και στάθηκε. Ένα για αυτόν. $nation, προχωράμε.';
  }

  @override
  String yStatementKept4(String nation) {
    return 'Βρήκε ένα σωστό. $nation, μην το συνηθίσεις.';
  }

  @override
  String yStatementKept5(String nation) {
    return 'Ακόμα και ένα ξεπερασμένο ρολόι δείχνει σωστή ώρα δύο φορές τη μέρα. $nation, αυτή τη φορά είχατε τύχη.';
  }

  @override
  String yStatementBroken0(String nation) {
    return 'Το είπε και δεν βγήκε. Ακόμα μαζί του. $nation, ξαναπροσπαθούμε.';
  }

  @override
  String yStatementBroken1(String nation) {
    return '$nation: υποσχέθηκε περισσότερα από όσα πήραμε, αλλά προτιμώ προπονητή που στηρίζει τον εαυτό του.';
  }

  @override
  String yStatementBroken2(String nation) {
    return '$nation: το είπε επίσημα και δεν έγινε. Ο κόσμος θα θυμάται.';
  }

  @override
  String yStatementBroken3(String nation) {
    return 'Μεγάλα λόγια, τίποτα από πίσω. $nation: την επόμενη φορά, πες λιγότερα.';
  }

  @override
  String yStatementBroken4(String nation) {
    return 'Στάθηκε εκεί και μας το είπε. Μετά αυτό. $nation: αξίζεις κάτι καλύτερο από λόγια.';
  }

  @override
  String yStatementBroken5(String nation) {
    return 'Ο λόγος του δεν αξίζει τίποτα πια. Γράψτε το, $nation.';
  }

  @override
  String get ncZoneNorth => 'Βόρεια Ζώνη';

  @override
  String get ncZoneWest => 'Δυτική Ζώνη';

  @override
  String get ncZoneEast => 'Ανατολική Ζώνη';

  @override
  String get ncZoneCentralSouthern => 'Κεντρική και Νότια Ζώνη';

  @override
  String careerNationsCupZoneWon(String zone) {
    return '$zone · Πρωταθλητές';
  }

  @override
  String careerNationsCupZoneRunnerUp(String zone) {
    return '$zone · Φιναλίστ';
  }

  @override
  String careerNationsCupZoneSemi(String zone) {
    return '$zone · Ημιτελικός';
  }

  @override
  String careerNationsCupZoneRoundOf16(String zone) {
    return '$zone · Φάση των 16';
  }

  @override
  String careerNationsCupZoneQuarter(String zone) {
    return '$zone · Προημιτελικός';
  }

  @override
  String careerNationsCupZonePlaced(String zone, int position) {
    return '$zone · #$position';
  }

  @override
  String get objectiveNcFinalsEight => 'Πρόκριση στους προημιτελικούς';

  @override
  String get objectiveNcZoneWinGroup => 'Κέρδισε τον όμιλό σου';

  @override
  String get finishNcFinalsEight => 'Προημιτελικοί';

  @override
  String get finishNcBottomHalf => 'Κάτω μισό του ομίλου';

  @override
  String get tourContTabZones => 'ΖΩΝΕΣ';

  @override
  String get tourContTabFinalsEight => 'ΝΟΚ ΑΟΥΤ';

  @override
  String get tourContFinalsEightSoon =>
      'Οι αγώνες νοκ άουτ ξεκινούν τον Νοέμβριο με τη φάση των 16: και οι 14 νικητές των ομίλων και οι 2 καλύτεροι δεύτεροι.';

  @override
  String get tourContQuarterFinals => 'ΠΡΟΗΜΙΤΕΛΙΚΟΙ';

  @override
  String get tourContZoneAdvancement =>
      'Κάθε νικητής ομίλου περνά στη φάση των 16, μαζί με τους 2 καλύτερους δεύτερους. Κανείς δεν υποβιβάζεται.';

  @override
  String tourContZoneHeadingYours(String zone) {
    return '$zone ★';
  }

  @override
  String get compNorthAmericaNationsCup => 'Κύπελλο Εθνών Βόρειας Αμερικής';

  @override
  String get compAfricanNationsCup => 'Κύπελλο Εθνών';

  @override
  String get objectiveNcWinItNorthAmerica =>
      'Κέρδισε το Κύπελλο Εθνών Βόρειας Αμερικής';

  @override
  String get objectiveNcWinItAfrica => 'Κέρδισε το Κύπελλο Εθνών';

  @override
  String get objectiveNcReachFinalNorthAmerica =>
      'Πρόκριση στον τελικό του Κυπέλλου Εθνών Βόρειας Αμερικής';

  @override
  String get objectiveNcReachFinalAfrica =>
      'Πρόκριση στον τελικό του Κυπέλλου Εθνών';

  @override
  String get finishNcChampionsNorthAmerica =>
      'Νικητές του Κυπέλλου Εθνών Βόρειας Αμερικής';

  @override
  String get finishNcChampionsAfrica => 'Νικητές του Κυπέλλου Εθνών';

  @override
  String pressAimQualWarm1(String competition) {
    return 'Προκριματικά, $competition: ξεκινούν τώρα και η χώρα πιστεύει σε αυτή την ομάδα. Ποιος είναι ο στόχος σας;';
  }

  @override
  String pressAimQualWarm2(String competition) {
    return 'Νέα προκριματικά, $competition, και το ηθικό είναι ψηλά. Πόσο μακριά μπορεί να φτάσει αυτή η ομάδα;';
  }

  @override
  String pressAimQualNeutral1(String competition) {
    return 'Ξεκινούν τα προκριματικά, $competition. Ποιος είναι ο στόχος αυτής της εκστρατείας;';
  }

  @override
  String pressAimQualNeutral2(String competition) {
    return 'Τα προκριματικά, $competition, είναι εδώ. Πού βλέπετε να τερματίζει αυτή η ομάδα;';
  }

  @override
  String pressAimQualHostile1(String competition) {
    return 'Ξεκινούν τα προκριματικά, $competition, και πολλοί αμφιβάλλουν ότι θα φτάσετε. Τι τους λέτε;';
  }

  @override
  String pressAimQualHostile2(String competition) {
    return 'Άλλη μια εκστρατεία προκριματικών, $competition. Γιατί να πιστέψει κανείς ότι αυτή θα είναι διαφορετική;';
  }

  @override
  String pressAimFinalsWarm1(String competition) {
    return 'Διοργάνωση: $competition. Είναι εδώ και όλη η χώρα είναι πίσω σας. Πόσο μακριά μπορείτε να φτάσετε;';
  }

  @override
  String pressAimFinalsWarm2(String competition) {
    return 'Είστε στην τελική φάση, $competition, και οι οπαδοί ονειρεύονται. Ποιος είναι ο στόχος;';
  }

  @override
  String pressAimFinalsNeutral1(String competition) {
    return 'Η τελική φάση, $competition, ξεκινά αυτή την εβδομάδα. Τι θα θεωρούσατε επιτυχία;';
  }

  @override
  String pressAimFinalsNeutral2(String competition) {
    return 'Ο πρώτος σας αγώνας στην τελική φάση, $competition, πλησιάζει. Βάλτε μας έναν στόχο.';
  }

  @override
  String pressAimFinalsHostile1(String competition) {
    return 'Η τελική φάση, $competition, είναι εδώ και κανείς δεν περιμένει πολλά. Τι ελπίζετε πραγματικά;';
  }

  @override
  String pressAimFinalsHostile2(String competition) {
    return 'Είστε στην τελική φάση, $competition, αλλά οι αμφιβολίες δεν έφυγαν. Ποιος είναι ο στόχος σας;';
  }

  @override
  String pressBeatRivalWarm1(String rival) {
    return 'Αντίπαλος στον όμιλο: $rival. Σας ανησυχεί;';
  }

  @override
  String pressBeatRivalWarm2(String rival) {
    return 'Η κλήρωση έφερε στον δρόμο σας αντίπαλο: $rival. Πώς βλέπετε αυτό το παιχνίδι;';
  }

  @override
  String pressBeatRivalNeutral1(String rival) {
    return 'Η ισχυρότερη ομάδα του ομίλου φαίνεται να είναι η εξής: $rival. Είναι οι φαβορί;';
  }

  @override
  String pressBeatRivalNeutral2(String rival) {
    return 'Αντίπαλος: $rival. Τι γνώμη έχετε;';
  }

  @override
  String pressBeatRivalHostile1(String rival) {
    return 'Αντίπαλος στον όμιλο: $rival. Ειλικρινά, μπορείτε να τους αντέξετε;';
  }

  @override
  String pressBeatRivalHostile2(String rival) {
    return 'Οι περισσότεροι περιμένουν να σας νικήσει η ομάδα: $rival. Κάνουν λάθος;';
  }

  @override
  String pressBeatKeyPlayerWarm1(String player) {
    return '$player είναι σε εξαιρετική φόρμα. Είναι η στιγμή του;';
  }

  @override
  String pressBeatKeyPlayerWarm2(String player) {
    return '$player είναι σε όλους τους τίτλους. Μπορεί να σηκώσει αυτή την ομάδα;';
  }

  @override
  String pressBeatKeyPlayerNeutral1(String player) {
    return 'Πόσο εξαρτάται αυτή η εκστρατεία από τον παίκτη: $player;';
  }

  @override
  String pressBeatKeyPlayerNeutral2(String player) {
    return '$player: είναι έτοιμος να ηγηθεί αυτής της ομάδας;';
  }

  @override
  String pressBeatKeyPlayerHostile1(String player) {
    return 'Αν ο παίκτης $player δεν είναι στα καλύτερά του, έχει κάτι αυτή η ομάδα;';
  }

  @override
  String pressBeatKeyPlayerHostile2(String player) {
    return '$player κουβαλά πολλά στους ώμους του. Πάρα πολλά;';
  }

  @override
  String get pressReplyAimHigher1 =>
      'Θα πάμε πιο μακριά απ\' όσο περιμένει κανείς.';

  @override
  String get pressReplyAimHigher2 =>
      'Θέλω περισσότερα από όσα ζήτησε η ομοσπονδία, και θα το πω φωναχτά.';

  @override
  String get pressReplyMatchBrief1 => 'Ξέρουμε τον στόχο και θα τον πετύχουμε.';

  @override
  String get pressReplyMatchBrief2 =>
      'Η ομοσπονδία έβαλε έναν στόχο. Θα τον πετύχουμε.';

  @override
  String get pressReplyPlayDown1 => 'Ας πάμε αγώνα τον αγώνα.';

  @override
  String get pressReplyPlayDown2 =>
      'Χωρίς μεγάλες υποσχέσεις. Θα δούμε πού βρισκόμαστε.';

  @override
  String get pressReplyPromiseQualify1 =>
      'Θα προκριθούμε. Μπορείτε να το γράψετε.';

  @override
  String get pressReplyPromiseQualify2 =>
      'Αυτή η ομάδα θα είναι στην τελική φάση.';

  @override
  String get pressReplyFearNobody1 => 'Δεν φοβόμαστε κανέναν.';

  @override
  String get pressReplyFearNobody2 => 'Πρέπει να παίξουν και με εμάς.';

  @override
  String get pressReplyRespectRival1 => 'Είναι οι φαβορί και τους σεβόμαστε.';

  @override
  String get pressReplyRespectRival2 =>
      'Πολύ καλή ομάδα. Θα χρειαστούμε τον καλύτερο εαυτό μας.';

  @override
  String get pressReplyTeamFirst1 =>
      'Αφορά ολόκληρη την ομάδα, όχι έναν παίκτη.';

  @override
  String get pressReplyTeamFirst2 => 'Κανείς δεν κερδίζει μόνος του.';

  @override
  String pressOnRecordTarget(String aim) {
    return 'Καταγράφηκε: $aim.';
  }

  @override
  String get pressOnRecordPlayDown => 'Καταγράφηκε: χωρίς υποσχέσεις.';

  @override
  String get pressThrowbackTargetKeptWarm =>
      'Βάλατε στόχο πριν από την εκστρατεία και τον πετύχατε. Είναι η πιο περήφανη στιγμή σας μέχρι τώρα;';

  @override
  String get pressThrowbackTargetKeptNeutral =>
      'Είπατε τι θα πετύχετε και το πετύχατε. Αμφιβάλλατε ποτέ;';

  @override
  String get pressThrowbackTargetKeptHostile =>
      'Πετύχατε τον στόχο που βάλατε. Τύχη, ή ήταν πραγματικά το σχέδιο;';

  @override
  String get pressThrowbackTargetBrokenWarm =>
      'Βάλατε στόχο και μείνατε πίσω. Τι πήγε στραβά;';

  @override
  String get pressThrowbackTargetBrokenNeutral =>
      'Υποσχεθήκατε περισσότερα από όσα έδωσε αυτή η ομάδα. Μετανιώνετε που το είπατε;';

  @override
  String get pressThrowbackTargetBrokenHostile =>
      'Μιλήσατε μεγάλα πριν από την εκστρατεία και μείνατε πίσω. Γιατί να σας πιστέψουμε τώρα;';

  @override
  String hubEventPressPreviewSub(String competition) {
    return 'Ο Τύπος θέλει να ακούσει τους στόχους σου. Διοργάνωση: $competition';
  }

  @override
  String deptLevelCost(int level, String amount) {
    return 'Επίπεδο $level · $amount';
  }

  @override
  String get formOnFire => 'Φωτιά';

  @override
  String get formGood => 'Σε φόρμα';

  @override
  String get formSteady => 'Σταθερός';

  @override
  String get formPoor => 'Εκτός φόρμας';

  @override
  String get formCold => 'Παγωμένος';

  @override
  String get playerFormTitle => 'ΦΟΡΜΑ ΚΑΙ ΕΤΟΙΜΟΤΗΤΑ';

  @override
  String playerFormAverage(String rating) {
    return 'Μέσος όρος $rating στους πρόσφατους αγώνες του';
  }

  @override
  String get playerFormNoGames =>
      'Δεν υπάρχουν αρκετοί πρόσφατοι αγώνες για κρίση';

  @override
  String playerFormNextMatch(String delta) {
    return '$delta στη βαθμολογία του στον επόμενο αγώνα';
  }

  @override
  String get playerFormNoEffect =>
      'Καμία αλλαγή στη βαθμολογία του στον επόμενο αγώνα';

  @override
  String get sideGroupHome => 'Αρχική';

  @override
  String get sideGroupTeam => 'Ομάδα';

  @override
  String get sideGroupCompetitions => 'Διοργανώσεις';

  @override
  String get sideGroupFederation => 'Ομοσπονδία';

  @override
  String get sideGroupHistory => 'Ιστορικό';

  @override
  String get sideInbox => 'Εισερχόμενα';

  @override
  String get sideSquad => 'Αποστολή';

  @override
  String get sideTactics => 'Τακτική';

  @override
  String get sideMainMenu => 'Κύριο μενού';

  @override
  String get sideCallUps => 'Κλήσεις';

  @override
  String get sideTournaments => 'Τουρνουά';

  @override
  String get sideRanking => 'Κατάταξη';

  @override
  String get sideResults => 'Αποτελέσματα';

  @override
  String get sideFinances => 'Οικονομικά';

  @override
  String get sideBoard => 'Διοίκηση';

  @override
  String get sideManager => 'Προπονητής και επιτελείο';

  @override
  String get sideRecords => 'Ρεκόρ';

  @override
  String get sideLegends => 'Θρύλοι';

  @override
  String get sideHeadToHead => 'Μεταξύ τους';

  @override
  String get sideAchievements => 'Επιτεύγματα';

  @override
  String get sideCareer => 'Καριέρα';

  @override
  String get topBarNext => 'Επόμενος';

  @override
  String get topBarDrawPending => 'Αναμένεται κλήρωση';

  @override
  String get paneFullProfile => 'Πλήρες προφίλ';

  @override
  String get panePickPlayer =>
      'Διάλεξε έναν παίκτη για να δεις εδώ την κάρτα του';

  @override
  String get inboxPickMessage => 'Διάλεξε ένα μήνυμα για να το διαβάσεις εδώ';

  @override
  String get inboxFilterAll => 'Όλα';

  @override
  String get panelViewAll => 'Προβολή όλων';

  @override
  String get gridViewOverview => 'Επισκόπηση';

  @override
  String get gridColCondition => 'Φρεσκάδα';

  @override
  String get gridColStatus => 'Κατάσταση';

  @override
  String get gridColRank => 'Θέση';

  @override
  String get gridColMove => 'Κίνηση';

  @override
  String get gridColNation => 'Χώρα';

  @override
  String get gridColRegion => 'Περιοχή';

  @override
  String get gridColPoints => 'Βαθμοί';

  @override
  String get panePickNation =>
      'Διάλεξε μια χώρα για να δεις εδώ το ιστορικό της';

  @override
  String get resultsCyclesTitle => 'Κύκλοι';

  @override
  String get tourDrawStart => 'Έναρξη κλήρωσης';

  @override
  String get tourDrawViewGroups => 'Προβολή ομίλων';

  @override
  String get gridColCeiling => 'Ταβάνι';

  @override
  String get gridColYearGain => 'Κέρδος';

  @override
  String get gridColMarkedAt => 'Σημειώθηκε';

  @override
  String get budgetSetupTitle => 'Όρισε τον προϋπολογισμό σου';

  @override
  String get budgetEffectsTitle => 'Τι αγοράζει αυτός ο προϋπολογισμός';

  @override
  String get naturalisationTitle => 'Πολιτογράφηση';

  @override
  String get yTrending => 'Τάσεις';

  @override
  String get yVoices => 'Φωνές';

  @override
  String get yConversation => 'Συζήτηση';

  @override
  String get allTimeRecordsTitle => 'Παγκόσμια ρεκόρ όλων των εποχών';

  @override
  String get h2hMeetingsTitle => 'Κάθε αναμέτρηση';

  @override
  String get h2hPickOpponent =>
      'Διάλεξε έναν αντίπαλο για να δεις εδώ κάθε αναμέτρηση';

  @override
  String get savesTitle => 'Αποθηκεύσεις';

  @override
  String get gridColPlayer => 'Παίκτης';

  @override
  String get gridColPos => 'Θέση';

  @override
  String get gridColActive => 'Ενεργός';

  @override
  String get gridColMotm => 'MVP';

  @override
  String get gridColAvg => 'Μέσος';

  @override
  String get gridColOpponent => 'Αντίπαλος';

  @override
  String get gridColStarts => 'Βασικές';

  @override
  String get gridColTournaments => 'Τουρνουά';

  @override
  String get gridColDate => 'Ημερομηνία';

  @override
  String get gridColLastPlayed => 'Τελευταίο παιχνίδι';

  @override
  String get gridColManager => 'Προπονητής';

  @override
  String nationsShownCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count χώρες',
      one: '1 χώρα',
    );
    return '$_temp0';
  }

  @override
  String get nationsSortedByRank => 'Ταξινόμηση κατά παγκόσμια κατάταξη';

  @override
  String get nationsStrength => 'Δύναμη';

  @override
  String nationsStrengthOf(int tier) {
    return '$tier στα 5';
  }

  @override
  String get nationsSquadOverall => 'Γενικό επίπεδο αποστολής';

  @override
  String get nationsOpeningBudget => 'Αρχικός προϋπολογισμός';

  @override
  String get nationsStarPlayer => 'Ο αστέρας';

  @override
  String nationsStarTile(String position, int rating) {
    return 'Αστέρας $position $rating';
  }

  @override
  String nationsStarAge(int age) {
    return 'Ηλικία $age';
  }

  @override
  String get nationsBoardExpects => 'Η διοίκηση περιμένει';

  @override
  String nationsManage(String nation) {
    return 'Ανάλαβε: $nation';
  }

  @override
  String get nationsManagerNext => 'Το όνομά σου το δηλώνεις στη συνέχεια';

  @override
  String get playerPageTitle => 'Παίκτης';

  @override
  String get nationPageTitle => 'Χώρα';

  @override
  String get friendliesYourGames => 'Τα φιλικά σου';

  @override
  String hubEventInjuryCover(String player) {
    return 'Αντικατάσταση τραυματία: $player';
  }

  @override
  String hubEventInjuryCoverSub(int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: 'Εκτός για $matches αγώνες',
      one: 'Εκτός για τον επόμενο αγώνα',
    );
    return '$_temp0. Κάλεσε κάποιον ή παίξε χωρίς αυτόν.';
  }

  @override
  String get injuryCoverTitle => 'ΑΝΤΙΚΑΤΑΣΤΑΣΗ';

  @override
  String injuryCoverBanner(String player, String position) {
    return '$player ($position): τραυματίστηκε. Κάλεσε οποιονδήποτε εκτός αποστολής, σε οποιαδήποτε θέση, ή κράτα τον και παίξε χωρίς αλλαγή.';
  }

  @override
  String injuryCoverConfirm(String player) {
    return 'Κλήση: $player';
  }

  @override
  String injuryCoverKeep(String player) {
    return 'Κράτα και παίξε: $player';
  }

  @override
  String get injuryCoverPick => 'Διάλεξε αντικαταστάτη';

  @override
  String get injuryCoverNone =>
      'Κανείς εκτός αποστολής δεν είναι έτοιμος να έρθει.';

  @override
  String get nationNowRanking => 'Παγκόσμια κατάταξη';

  @override
  String get nationNowForm => 'Φόρμα';

  @override
  String get nationNowNoForm => 'Δεν έχει παίξει ακόμα αγώνες';

  @override
  String get nationNowNext => 'Επόμενος αγώνας';

  @override
  String get nationNowNoNext => 'Τίποτα προγραμματισμένο';

  @override
  String get nationNowSquad => 'Αποστολή';

  @override
  String get nationNowAgainstYou => 'Απέναντί σου';

  @override
  String nationNowRecord(int w, int d, int l) {
    return '$wΝ $dΙ $lΗ';
  }

  @override
  String get nationNowLastMeeting => 'Τελευταία αναμέτρηση';

  @override
  String nationNowOverall(int value) {
    return 'Επίπεδο $value';
  }

  @override
  String get hubUpcoming => 'ΕΠΟΜΕΝΑ';

  @override
  String get hubFullSchedule => 'Πλήρες πρόγραμμα';

  @override
  String get scheduleTitle => 'Πρόγραμμα';

  @override
  String get scheduleToday => 'Σήμερα';

  @override
  String get scheduleKnockoutPending => 'Νοκ άουτ φάση, αν προκριθείς';

  @override
  String get scheduleNextRoundPending => 'Επόμενος γύρος';

  @override
  String scheduleFromDate(String date) {
    return 'Από $date';
  }

  @override
  String get scheduleHomeShort => 'Ε';

  @override
  String get scheduleAwayShort => 'Ξ';

  @override
  String get tacticsNoPresetsInMatch =>
      'Δεν υπάρχουν αποθηκευμένες τακτικές. Αποθήκευσε μία από την οθόνη Τακτικής πριν από τον αγώνα.';

  @override
  String get homeCampaigns => 'Εκστρατείες';

  @override
  String get homeContinueCampaign => 'ΣΥΝΕΧΙΣΕ ΤΗΝ ΚΑΜΠΑΝΙΑ';

  @override
  String homeCampaignCycle(String date, int cycle, int total) {
    return '$date · Κύκλος $cycle από $total';
  }

  @override
  String get campaignsTitle => 'Εκστρατείες';

  @override
  String get campaignTransplantTitle => 'Η Μεταμόσχευση';

  @override
  String get campaignTransplantTwist =>
      'Οκτώ από τους κορυφαίους της Ιταλίας αλλάζουν εθνική στον Άγιο Μαρίνο';

  @override
  String get campaignTransplantGoal => 'Πρόκριση στο Ευρωπαϊκό Πρωτάθλημα';

  @override
  String get campaignGrudgeTitle => 'Κακία';

  @override
  String get campaignGrudgeTwist => 'Γεωργία και Αλβανία, στον ίδιο όμιλο';

  @override
  String get campaignGrudgeGoal =>
      'Τερμάτισε πάνω από την Αλβανία στα προκριματικά';

  @override
  String get campaignTransplantIntro =>
      'Ο Άγιος Μαρίνος δεν είχε ποτέ προκριματική εκστρατεία που να αξίζει το όνομα. Και τότε οκτώ από τους κορυφαίους της Ιταλίας παίρνουν το διαβατήριο και μπαίνουν μέσα. Έχεις έναν κύκλο για να κάνεις μια περιέργεια ομάδα.';

  @override
  String get campaignGrudgeIntro =>
      'Η Γεωργία και η Αλβανία κληρώθηκαν στον ίδιο όμιλο προκριματικών και καμία δεν θα συγχωρήσει ήττα. Τερμάτισε πάνω από την Αλβανία και δες πόσο μακριά μπορείς να το πας.';

  @override
  String get campaignStars1Transplant => 'Πρόκριση';

  @override
  String get campaignStars2Transplant => 'Πρόκριση στα νοκ άουτ';

  @override
  String get campaignStars3Transplant =>
      'Κατάκτηση του Ευρωπαϊκού Πρωταθλήματος';

  @override
  String get campaignStars1Grudge => 'Πάνω από την Αλβανία';

  @override
  String get campaignStars2Grudge => 'Και πρόκριση';

  @override
  String get campaignStars3Grudge => 'Και νίκη δύο φορές επί της Αλβανίας';

  @override
  String get campaignFree => 'Δωρεάν';

  @override
  String get campaignStart => 'Έναρξη';

  @override
  String get campaignPartOfUnlimited => 'Μέρος του Απεριόριστου';

  @override
  String get campaignResume => 'Συνέχεια';

  @override
  String get campaignAbandon => 'Εγκατάλειψη';

  @override
  String get campaignAbandonConfirm =>
      'Εγκατάλειψη αυτής της διαδρομής; Η πρόοδός της χάνεται, η σφραγίδα σου μένει.';

  @override
  String get campaignMoveToSaves => 'Μεταφορά στις αποθηκεύσεις';

  @override
  String get campaignCannotContinue =>
      'Ο κόσμος αυτής της καμπάνιας απέχει πολύ από τον πραγματικό για να συνεχίσει ως καριέρα.';

  @override
  String get campaignMoveSlotsFull =>
      'Οι θέσεις αποθήκευσης είναι γεμάτες. Ελευθέρωσε πρώτα μία.';

  @override
  String get campaignStampConquered => 'Κατακτήθηκε';

  @override
  String get campaignStampFailed => 'Αποτυχία';

  @override
  String get campaignDifficultyHard => 'Δύσκολη';

  @override
  String get campaignDifficultyMedium => 'Μέτρια';

  @override
  String get campaignGoalLabel => 'Στόχος';

  @override
  String get campaignStarsLabel => 'Αστέρια';

  @override
  String get campaignRunInProgress =>
      'Αυτή η εκστρατεία έχει ήδη διαδρομή σε εξέλιξη.';

  @override
  String get campaignVerdictWon => 'Κατακτήθηκε';

  @override
  String get campaignVerdictLost => 'Όχι αυτή τη φορά';

  @override
  String get campaignVerdictContinue => 'Συνέχεια';

  @override
  String campaignProgressQualifying(String position) {
    return 'Προκριματικά: $position';
  }

  @override
  String campaignProgressRival(String rival, String position) {
    return '$rival: $position';
  }

  @override
  String campaignProgressFinals(String stage) {
    return 'Τελική φάση: $stage';
  }

  @override
  String get campaignRunInNumbers => 'Η διαδρομή σε αριθμούς';

  @override
  String campaignRunMeetings(int won, int played) {
    return 'Νίκες στις αναμετρήσεις: $won από $played';
  }

  @override
  String campaignPlace(String which, int n) {
    String _temp0 = intl.Intl.selectLogic(
      which,
      {
        'first': '1η',
        'second': '2η',
        'third': '3η',
        'other': '$nη',
      },
    );
    return '$_temp0';
  }

  @override
  String get campaignGuineasTitle => 'Η καλύτερη Γουινέα';

  @override
  String get campaignGuineasTwist =>
      'Η Ισημερινή Γουινέα, η μικρότερη Γουινέα της Αφρικής, για δύο κύκλους';

  @override
  String get campaignGuineasGoal => 'Νίκησε τη Γουινέα και τη Γουινέα-Μπισάου';

  @override
  String get campaignGuineasIntro =>
      'Τρεις αφρικανικές χώρες φέρουν το όνομα Γουινέα, και η Ισημερινή Γουινέα είναι η μικρότερη από αυτές. Έχεις δύο κύκλους για να νικήσεις τουλάχιστον μία φορά τη Γουινέα και τη Γουινέα-Μπισάου, και μετά να δεις πόσο μακριά θα φτάσεις στο Πρωτάθλημα Αφρικής. Η Παπούα Νέα Γουινέα, η τέταρτη Γουινέα, είναι ήδη κλεισμένη για φιλικό.';

  @override
  String get campaignStars1Guineas =>
      'Νίκησε τη Γουινέα και τη Γουινέα-Μπισάου';

  @override
  String get campaignStars2Guineas => 'Και πρόκριση σε Πρωτάθλημα Αφρικής';

  @override
  String get campaignStars3Guineas => 'Και προημιτελικός σε Πρωτάθλημα Αφρικής';

  @override
  String get campaignYoungFinnsTitle => 'Νεαροί Φινλανδοί';

  @override
  String get campaignYoungFinnsTwist =>
      'Η χρυσή γενιά εφήβων της Φινλανδίας, για τρεις κύκλους';

  @override
  String get campaignYoungFinnsGoal => 'Πρόκριση σε Παγκόσμιο Πρωτάθλημα';

  @override
  String get campaignYoungFinnsIntro =>
      'Οι έμπειροι παίκτες της Φινλανδίας αποσύρθηκαν και τη θέση τους πήρε μια χρυσή γενιά: κάθε παίκτης που μπορείς να καλέσεις είναι 18 ετών ή μικρότερος. Σήμερα είναι ακόμη άγουροι, αλλά έχουν το ταλέντο να γίνουν μία από τις καλύτερες ομάδες του κόσμου, όπως έκανε η νέα γενιά της Νορβηγίας. Έχεις τρεις κύκλους για να τους οδηγήσεις σε Παγκόσμιο Πρωτάθλημα και μετά να κατακτήσεις το Ευρωπαϊκό και το Παγκόσμιο Πρωτάθλημα.';

  @override
  String get campaignStars1YoungFinns => 'Πρόκριση σε Παγκόσμιο Πρωτάθλημα';

  @override
  String get campaignStars2YoungFinns =>
      'Κατάκτηση του Ευρωπαϊκού Πρωταθλήματος';

  @override
  String get campaignStars3YoungFinns =>
      'Κατάκτηση του Παγκόσμιου Πρωταθλήματος';

  @override
  String get campaignGreenlandTitle => 'Ένας γροιλανδικός αιώνας';

  @override
  String get campaignGreenlandTwist =>
      'Η Γροιλανδία παίρνει τη θέση του Αγίου Μαρίνου στην Ευρώπη, για εκατό χρόνια';

  @override
  String get campaignGreenlandGoal => 'Πρόκριση σε Ευρωπαϊκό Πρωτάθλημα';

  @override
  String get campaignGreenlandIntro =>
      'Η Γροιλανδία δεν έχει παίξει ποτέ επίσημο διεθνή αγώνα. Σε αυτόν τον κόσμο έχει πάρει τη θέση του Αγίου Μαρίνου στην Ευρώπη και ξεκινά από τον πάτο της παγκόσμιας κατάταξης: ερασιτέχνες παίκτες, συνθετικοί χλοοτάπητες και μια σεζόν στριμωγμένη ανάμεσα στα χιόνια. Έχεις εκατό χρόνια, είκοσι πέντε κύκλους, για να φτάσεις σε ένα Ευρωπαϊκό Πρωτάθλημα, μετά σε ένα Παγκόσμιο Πρωτάθλημα και, αν τολμάς να ονειρευτείς, να κατακτήσεις ένα από τα δύο.';

  @override
  String get campaignStars1Greenland => 'Πρόκριση σε Ευρωπαϊκό Πρωτάθλημα';

  @override
  String get campaignStars2Greenland => 'Πρόκριση σε Παγκόσμιο Πρωτάθλημα';

  @override
  String get campaignStars3Greenland =>
      'Κατάκτηση του Ευρωπαϊκού ή του Παγκόσμιου Πρωταθλήματος';

  @override
  String get campaignPro => 'Pro';

  @override
  String campaignProgressCup(String cup, String year, String status) {
    return '$cup $year: $status';
  }

  @override
  String get campaignCupNotQualified => 'Χωρίς πρόκριση';

  @override
  String get campaignCupOpen => 'Εκκρεμεί';

  @override
  String newsYouthTitle1(String name, String level) {
    return '$name: λάμψη με την ομάδα $level';
  }

  @override
  String newsYouthTitle2(String name, String level) {
    return 'Αναφορά ακαδημίας: $name, ένα όνομα που ξεχωρίζει';
  }

  @override
  String newsYouthTitle3(String name, String level) {
    return 'Ο κορυφαίος της ομάδας $level: $name';
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
      other: '$count φορές',
      one: 'μία φορά',
    );
    return '$name σκόραρε $_temp0 με την ομάδα $level στο τελευταίο διεθνές παράθυρο, αντίπαλος $opponent.';
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
      other: '$count γκολ',
      one: 'Ένα γκολ',
    );
    return '$_temp0 για τον $name στο ματς της ομάδας $level σε αυτό το παράθυρο, αντίπαλος $opponent.';
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
      other: '$count γκολ',
      one: 'ένα γκολ',
    );
    return 'Η ομάδα $level έπαιξε με αντίπαλο $opponent, και $name έφυγε από το γήπεδο με $_temp0 στο όνομά του.';
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
      other: '$count ασίστ',
      one: 'μία ασίστ',
    );
    return '$name μοίρασε $_temp0 με την ομάδα $level (αντίπαλος $opponent) και κατηύθυνε το παιχνίδι από την αρχή ως το τέλος.';
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
      other: '$count ασίστ',
      one: 'μία ασίστ',
    );
    return 'Η ομάδα $level αγωνίστηκε σε αυτό το παράθυρο με αντίπαλο $opponent, και τα νήματα τα κινούσε $name: $_temp0 και μια εμφάνιση για την οποία το επιτελείο μιλά ακόμα.';
  }

  @override
  String newsYouthCleanSheet1(String name, String level, String opponent) {
    return '$name ήταν εξαιρετικός, καθώς η ομάδα $level κράτησε το μηδέν απέναντι σε αντίπαλο $opponent.';
  }

  @override
  String newsYouthCleanSheet2(String name, String level, String opponent) {
    return 'Ανέπαφη εστία για την ομάδα $level, αντίπαλος $opponent, και ο κύριος λόγος ήταν $name.';
  }

  @override
  String newsYouthDisplay1(
    String name,
    String level,
    String opponent,
    int mark,
  ) {
    return '$name εντυπωσίασε με την ομάδα $level (αντίπαλος $opponent) και το επιτελείο βαθμολόγησε την εμφάνισή του με $mark στα δέκα.';
  }

  @override
  String newsYouthDisplay2(
    String name,
    String level,
    String opponent,
    int mark,
  ) {
    return 'Η ομάδα $level έπαιξε σε αυτό το παράθυρο με αντίπαλο $opponent, και οι προπονητές ξεχώρισαν ένα όνομα, $name: $mark στα δέκα, ο υψηλότερος βαθμός της ομάδας.';
  }

  @override
  String get newsYouthDevReady1 =>
      'Με αυτή την απόδοση είναι ήδη αρκετά καλός για να τον εξετάσεις για την πρώτη ομάδα.';

  @override
  String get newsYouthDevReady2 =>
      'Το επιτελείο πιστεύει ότι είναι έτοιμος για το ποδόσφαιρο των ανδρών από τώρα. Η απόφαση είναι δική σου.';

  @override
  String get newsYouthDevClose1 =>
      'Εξελίσσεται καλά και είναι κοντά στο να μπει στην εθνική ανδρών.';

  @override
  String get newsYouthDevClose2 =>
      'Δεν απέχει πολύ από την εθνική ανδρών, και μία ακόμα καλή σεζόν μπορεί να αρκεί.';

  @override
  String get newsYouthDevGrowing1 =>
      'Εξελίσσεται ωραία, αν και η εθνική ανδρών απέχει ακόμα ένα δυο βήματα.';

  @override
  String get newsYouthDevGrowing2 =>
      'Υπάρχει δουλειά ακόμα μέχρι να γίνει διεθνής με την εθνική ανδρών, αλλά όλα δείχνουν προς τη σωστή κατεύθυνση.';

  @override
  String get newsYouthDevRaw1 =>
      'Είναι ακόμα ακατέργαστος και μερικά χρόνια μακριά από την εθνική ανδρών, αλλά το ταλέντο φαίνεται καθαρά.';

  @override
  String get newsYouthDevRaw2 =>
      'Είναι νωρίς ακόμα, και οι προπονητές της ακαδημίας ζητούν υπομονή, όχι πρωτοσέλιδα.';

  @override
  String get newsYouthStrengthGkPhysical =>
      'Το άνοιγμα και η κυριαρχία του στην περιοχή είναι αυτά που τον ξεχωρίζουν.';

  @override
  String get newsYouthStrengthGkTechnical =>
      'Οι επεμβάσεις και το παιχνίδι του με την μπάλα είναι τα καλύτερα που έχει δει η ακαδημία εδώ και χρόνια.';

  @override
  String get newsYouthStrengthGkStamina =>
      'Η συγκέντρωσή του δεν πέφτει ποτέ: στο ενενηκοστό λεπτό είναι το ίδιο οξύς όπως στο πρώτο.';

  @override
  String get newsYouthStrengthDefPhysical =>
      'Η ταχύτητα και το ψηλό παιχνίδι του είναι το κλειδί του παιχνιδιού του.';

  @override
  String get newsYouthStrengthDefTechnical =>
      'Διαβάζει το παιχνίδι πολύ πέρα από την ηλικία του και είναι ήρεμος με την μπάλα.';

  @override
  String get newsYouthStrengthDefStamina =>
      'Δεν χαλαρώνει ποτέ και στο τελευταίο λεπτό ακόμα τρέχει πίσω με όλη του τη δύναμη.';

  @override
  String get newsYouthStrengthMidPhysical =>
      'Κερδίζει την μπάλα με πραγματική δύναμη και την οδηγεί αμέσως μπροστά.';

  @override
  String get newsYouthStrengthMidTechnical =>
      'Η όραση και η γκάμα των πασών του είναι το κλειδί του παιχνιδιού του.';

  @override
  String get newsYouthStrengthMidStamina =>
      'Η αντοχή του είναι εντυπωσιακή: καλύπτει κάθε σπιθαμή του γηπέδου.';

  @override
  String get newsYouthStrengthFwdPhysical =>
      'Η ταχύτητα στην κόντρα και η δύναμη στον αέρα τον κάνουν πονοκέφαλο για κάθε άμυνα.';

  @override
  String get newsYouthStrengthFwdTechnical =>
      'Το τελείωμα και οι κινήσεις του μέσα στην περιοχή είναι το κλειδί του παιχνιδιού του.';

  @override
  String get newsYouthStrengthFwdStamina =>
      'Πιέζει ψηλά όλο το ματς και δεν αφήνει στους αμυντικούς ούτε στιγμή ησυχίας.';

  @override
  String pressMomentBigWinWarm3(String opponent) {
    return 'Οι φίλαθλοι θα τραγουδούν για αυτό το ματς για καιρό, αντίπαλος $opponent. Τι είπατε στους παίκτες στο τελικό σφύριγμα;';
  }

  @override
  String pressMomentBigWinNeutral3(String opponent) {
    return 'Ήταν δήλωση δύναμης, αντίπαλος $opponent. Πόσο από αυτό βγήκε από τις προπονήσεις;';
  }

  @override
  String pressMomentBigWinHostile3(String opponent) {
    return 'Συγχαρητήρια για το αποτέλεσμα, αντίπαλος $opponent, αλλά τέτοιες βραδιές έχουμε ξαναδεί. Τι είναι διαφορετικό αυτή τη φορά;';
  }

  @override
  String pressMomentBigLossWarm3(String opponent) {
    return 'Όλοι έχουν μια κακή βραδιά, και αυτή ήταν μία, αντίπαλος $opponent. Πόσο γρήγορα μπορείτε να την αφήσετε πίσω σας;';
  }

  @override
  String pressMomentBigLossNeutral3(String opponent) {
    return 'Αντίπαλος $opponent, καλύτερος σε κάθε γραμμή. Από πού ξεκινάτε τη διόρθωση;';
  }

  @override
  String pressMomentBigLossHostile3(String opponent) {
    return 'Οι φίλαθλοι έφευγαν πριν από το τέλος, αντίπαλος $opponent. Μπορείτε να τους κατηγορήσετε;';
  }

  @override
  String pressMomentCrisisWarm3(String opponent) {
    return 'Είναι δύσκολο σερί, και ο αγώνας με αντίπαλο $opponent δεν το έκανε ευκολότερο. Τι σας κρατά όρθιο;';
  }

  @override
  String pressMomentCrisisNeutral3(String opponent) {
    return 'Άλλο ένα ματς χωρίς νίκη, αυτή τη φορά με αντίπαλο $opponent. Πόσο ακόμα μπορεί να κρατήσει αυτό πριν δράσει η διοίκηση;';
  }

  @override
  String pressMomentCrisisHostile3(String opponent) {
    return 'Τώρα και αντίπαλος $opponent. Έχει μείνει κάτι στο πλάνο σας ή ήρθε η ώρα να κάνετε χώρο σε κάποιον άλλο;';
  }

  @override
  String get pressReplyCreditPlayers5 =>
      'Ό,τι κι αν γράψετε, γράψτε το για τους παίκτες. Το έχουν κερδίσει.';

  @override
  String get pressReplyCreditPlayers6 =>
      'Έχω μια ομάδα που θα έπεφτε στη φωτιά ο ένας για τον άλλον. Αυτό δεν είναι λίγο.';

  @override
  String get pressReplyTakeResponsibility5 =>
      'Εγώ παίρνω τις αποφάσεις, άρα η κριτική πέφτει σε μένα. Αυτή είναι η δουλειά.';

  @override
  String get pressReplyTakeResponsibility6 =>
      'Κοιτάξτε πρώτα τον προπονητή. Έκανα λάθη και θα τα διορθώσω.';

  @override
  String get pressReplyDemandMore5 =>
      'Το καλό δεν αρκεί εδώ. Τους το είπα κατάμουτρα.';

  @override
  String get pressReplyDemandMore6 =>
      'Κανείς σε αυτά τα αποδυτήρια δεν έχει εξασφαλισμένη θέση. Τώρα το ξέρουν.';

  @override
  String get pressReplyDeflect5 =>
      'Μπορείτε να το ρωτήσετε με τρεις διαφορετικούς τρόπους. Η απάντηση θα είναι η ίδια.';

  @override
  String get pressReplyDeflect6 =>
      'Τις σκέψεις μου τις κρατώ για τους παίκτες. Θα καταλάβετε.';

  @override
  String yWinRoutine12(String opponent, String score) {
    return '$opponent, $score. Ήρεμο, ελεγχόμενο, ώριμο ποδόσφαιρο. Χαρά να το βλέπεις.';
  }

  @override
  String yWinRoutine13(String opponent, String score) {
    return '$score χωρίς να ιδρώσουμε, αντίπαλος $opponent. Αυτή η ομάδα γίνεται καλή στο βαρετό, και το βαρετό κερδίζει τίτλους.';
  }

  @override
  String yWinRoutine14(String opponent, String score) {
    return '$opponent $score. Τρεις βαθμοί, μηδέν δράμα, πίσω στη δουλειά.';
  }

  @override
  String yWinRoutine15(String opponent, String score) {
    return 'Ένα ρουτινιάρικο $score, αντίπαλος $opponent. Κανείς δεν θα το θυμάται και δεν χρειάζεται.';
  }

  @override
  String yWinRoutine16(String opponent, String score) {
    return '$opponent, $score, και κάπως εξακολουθώ να ανησυχώ.';
  }

  @override
  String yWinRoutine17(String opponent, String score) {
    return '$score, αντίπαλος $opponent. Απέναντι σε κανονική ομάδα, τέτοια εμφάνιση τιμωρείται.';
  }

  @override
  String yWinTight12(String opponent, String score) {
    return '$opponent, $score. Σφίξαμε τα δόντια, υποφέραμε, νικήσαμε. Αυτό είναι ομάδα.';
  }

  @override
  String yWinTight13(String opponent, String score) {
    return '$score μόνο με νεύρα, αντίπαλος $opponent. Παίρνω μια ομάδα που αρνείται να χάσει.';
  }

  @override
  String yWinTight14(String opponent, String score) {
    return '$opponent $score. Κρίθηκε στο τέλος, αλλά οι βαθμοί είναι δικοί μας.';
  }

  @override
  String yWinTight15(String opponent, String score) {
    return 'Οριακό $score, αντίπαλος $opponent. Μικρή διαφορά, αυτό είναι το ποδόσφαιρο.';
  }

  @override
  String yWinTight16(String opponent, String score) {
    return '$opponent, $score. Μια τυχερή κόντρα προς την άλλη μεριά και θα κάναμε τελείως άλλη κουβέντα.';
  }

  @override
  String yWinTight17(String opponent, String score) {
    return 'Κρατηθήκαμε με το ζόρι, αντίπαλος $opponent, $score. Κανείς να μην το πει αυτό εμφάνιση.';
  }

  @override
  String yDrew12(String opponent, String score) {
    return '$opponent, $score. Δεν είναι ήττα, και κάποιες μέρες αυτή είναι η δουλειά.';
  }

  @override
  String yDrew13(String opponent, String score) {
    return 'Ένας βαθμός με κόπο, αντίπαλος $opponent, $score. Μου άρεσε η μαχητικότητα.';
  }

  @override
  String yDrew14(String opponent, String score) {
    return '$opponent $score. Μοιρασιά βαθμών, όπως έλεγαν οι παλιοί σχολιαστές.';
  }

  @override
  String yDrew15(String opponent, String score) {
    return '$opponent, $score. Καμία ομάδα δεν έκανε αρκετά για κάτι παραπάνω.';
  }

  @override
  String yDrew16(String opponent, String score) {
    return '$opponent, $score. Από αυτές τις ισοπαλίες που στο πούλμαν της επιστροφής μοιάζουν με ήττα.';
  }

  @override
  String yDrew17(String opponent, String score) {
    return 'Ισοπαλία $score, αντίπαλος $opponent. Μιλάμε συνέχεια για πρόοδο και κάνουμε συνέχεια αυτό.';
  }

  @override
  String yLost12(String opponent, String score) {
    return '$opponent, $score. Πονάει, αλλά είδα αρκετά για να πιστεύω σε αυτή την ομάδα.';
  }

  @override
  String yLost13(String opponent, String score) {
    return 'Ήττα $score, αντίπαλος $opponent, και ήταν καλοί. Το αναγνωρίζουμε και συνεχίζουμε.';
  }

  @override
  String yLost14(String opponent, String score) {
    return '$opponent $score. Μια ήττα, μερικά μαθήματα, και το επόμενο ματς σύντομα.';
  }

  @override
  String yLost15(String opponent, String score) {
    return 'Ήττα $score, αντίπαλος $opponent. Δύσκολα το αμφισβητείς.';
  }

  @override
  String yLost16(String opponent, String score) {
    return '$opponent, $score. Τα ίδια λάθη με την προηγούμενη φορά, με την ίδια αυτοπεποίθηση.';
  }

  @override
  String yLost17(String opponent, String score) {
    return 'Ήττα $score, αντίπαλος $opponent. Αν δεν λογοδοτήσει κανείς γι\' αυτό, τι κάνουμε εδώ;';
  }

  @override
  String get yReactionShrug12 =>
      'Εμένα μου κάνει. Δεν χρειάζεται κάθε βράδυ πυροτεχνήματα.';

  @override
  String get yReactionShrug13 => 'Οι βαθμοί είναι βαθμοί. Απόψε κοιμάμαι καλά.';

  @override
  String get yReactionShrug14 => 'Το είδα. Κανένα σχόλιο.';

  @override
  String get yReactionShrug15 => 'Κάπου ανάμεσα στο εντάξει και στο εντάξει.';

  @override
  String get yReactionShrug16 =>
      'Πλήρωσα συνδρομή για αυτό. Ποτέ ξανά (θα ξαναγυρίσω).';

  @override
  String get yReactionShrug17 =>
      'Ενενήντα λεπτά από τίποτα σε σχήμα ποδοσφαίρου.';

  @override
  String get yReactionRelief12 => 'Ανασαίνω ξανά. Περήφανος που άντεξαν.';

  @override
  String get yReactionRelief13 =>
      'Αυτές οι νίκες χτίζουν ομάδα. Το άσχημο είναι όμορφο.';

  @override
  String get yReactionRelief14 => 'Τα νύχια μου χάθηκαν, οι βαθμοί όχι.';

  @override
  String get yReactionRelief15 =>
      'Ποτέ ένα τελικό σφύριγμα δεν ακούστηκε τόσο ωραία.';

  @override
  String get yReactionRelief16 =>
      'Χαρούμενος που νικήσαμε, ανήσυχος για το πώς.';

  @override
  String get yReactionRelief17 =>
      'Συνεχίζουμε να τη γλιτώνουμε. Κάποια μέρα δεν θα τη γλιτώσουμε.';

  @override
  String get yReactionFury12 =>
      'Αγαπώ αυτή την ομάδα, και γι\' αυτό ακριβώς πονάει.';

  @override
  String get yReactionFury13 =>
      'Κακή βραδιά. Την επόμενη φορά μάς χρωστάνε, και το ξέρουν.';

  @override
  String get yReactionFury14 =>
      'Το έκλεισα στο εβδομηκοστό. Έπρεπε στο εξηκοστό.';

  @override
  String get yReactionFury15 => 'Ούτε μάχη, ούτε ιδέες, ούτε δικαιολογίες.';

  @override
  String get yReactionFury16 =>
      'Τα ίδια προβλήματα κάθε φορά, και κανείς δεν διορθώνει τίποτα.';

  @override
  String get yReactionFury17 =>
      'Κάποιος στην ομοσπονδία πρέπει να το ξαναδεί και να μας το εξηγήσει.';

  @override
  String get backupShareHint =>
      'Φτιάχνει ένα αρχείο αντιγράφου με όλες τις αποθηκεύσεις. Διάλεξε Google Drive, iCloud Drive ή Αρχεία για να το κρατήσεις.';

  @override
  String backupLastAt(String date) {
    return 'Τελευταίο αντίγραφο: $date';
  }

  @override
  String get backupNever => 'Κανένα αντίγραφο ακόμα';

  @override
  String get backupRemindersTitle => 'Υπενθυμίσεις αντιγράφου';

  @override
  String get backupRemindersBlurb =>
      'Ένα μήνυμα στα εισερχόμενα όταν το τελευταίο αντίγραφο αρχίζει να παλιώνει.';

  @override
  String get backupAutoICloudTitle => 'Αυτόματο αντίγραφο στο iCloud';

  @override
  String get backupAutoDriveTitle => 'Αυτόματο αντίγραφο στο Google Drive';

  @override
  String get backupAutoBlurb =>
      'Κρατά αντίγραφο μετά τους αγώνες, στο τέλος του κύκλου και όταν βγαίνεις από την εφαρμογή. Κρατά τα δύο πιο πρόσφατα.';

  @override
  String get backupStatusUploading => 'Δημιουργία αντιγράφου.';

  @override
  String get backupStatusUploaded => 'Το αντίγραφο έγινε.';

  @override
  String get backupStatusICloudSignedOut =>
      'Το iCloud είναι κλειστό. Συνδέσου στο iCloud και άνοιξε το iCloud Drive από την εφαρμογή Ρυθμίσεις.';

  @override
  String get backupStatusDriveSignedOut =>
      'Δεν έχεις συνδεθεί. Άνοιξε τον διακόπτη για να συνδεθείς με Google.';

  @override
  String get backupStatusNotConfigured =>
      'Δεν είναι ακόμα διαθέσιμο σε αυτή την έκδοση της εφαρμογής.';

  @override
  String get backupStatusUnavailable =>
      'Το cloud δεν είναι προσβάσιμο αυτή τη στιγμή. Θα ξαναδοκιμάσει αργότερα.';

  @override
  String get backupStatusFailed =>
      'Το τελευταίο αυτόματο αντίγραφο δεν ολοκληρώθηκε. Θα ξαναδοκιμάσει αργότερα.';

  @override
  String backupDriveSignedInAs(String email) {
    return 'Συνδεδεμένος ως $email';
  }

  @override
  String get backupDriveSignOut => 'ΑΠΟΣΥΝΔΕΣΗ';

  @override
  String get backupDriveSignInFailed =>
      'Η σύνδεση με Google δεν πέτυχε. Δοκίμασε ξανά αργότερα.';

  @override
  String get backupRestoreICloud => 'ΕΠΑΝΑΦΟΡΑ ΑΠΟ ICLOUD';

  @override
  String get backupRestoreDrive => 'ΕΠΑΝΑΦΟΡΑ ΑΠΟ GOOGLE DRIVE';

  @override
  String get backupCrossPlatformHelp =>
      'Αλλάζεις από iPhone σε Android ή αντίστροφα; Κράτα αντίγραφο σε αρχείο στο ένα κινητό και κάνε επαναφορά από αυτό το αρχείο στο άλλο.';

  @override
  String get backupCloudListBlurb =>
      'Αντίγραφα από τις συσκευές σου σε αυτόν τον λογαριασμό. Πάτα ένα για επαναφορά.';

  @override
  String get backupCloudListEmpty =>
      'Δεν βρέθηκαν αντίγραφα ακόμα. Ένα νέο αντίγραφο μπορεί να χρειαστεί λίγα λεπτά για να φτάσει σε άλλη συσκευή.';

  @override
  String get backupCloudListFailed =>
      'Δεν ήταν δυνατή η ανάγνωση των αντιγράφων. Έλεγξε τη σύνδεση και δοκίμασε ξανά.';

  @override
  String get backupCloudThisDevice => 'Αυτή η συσκευή';

  @override
  String backupCloudMore(int count) {
    return 'Ακόμα αποθηκεύσεις: $count';
  }

  @override
  String get backupCloudNewer =>
      'Φτιάχτηκε από νεότερη έκδοση της εφαρμογής. Κάνε πρώτα ενημέρωση.';

  @override
  String get backupCloudDownloading => 'Λήψη του αντιγράφου.';

  @override
  String get backupRestoreSafetyNote =>
      'Πρώτα κρατιέται σε αυτό το κινητό ένα αντίγραφο των αποθηκεύσεων που έχει τώρα.';

  @override
  String get backupRejectedSafety =>
      'Δεν ήταν δυνατό να κρατηθεί αντίγραφο των τωρινών αποθηκεύσεων, οπότε δεν αντικαταστάθηκε τίποτα.';

  @override
  String get newsBackupReminderTitle => 'Ώρα για αντίγραφο';

  @override
  String get newsBackupReminderBody =>
      'Οι αποθηκεύσεις σου υπάρχουν μόνο σε αυτό το κινητό. Άνοιξε τις Ρυθμίσεις και πάτα Αντίγραφο στο cloud, ή άνοιξε εκεί το αυτόματο αντίγραφο. Αυτές οι υπενθυμίσεις κλείνουν επίσης από τις Ρυθμίσεις.';

  @override
  String get backupSafetyTitle => 'Αντίγραφα από πριν από μια επαναφορά';

  @override
  String get backupSafetyBlurb =>
      'Κρατιούνται σε αυτό το κινητό σε περίπτωση που μια επαναφορά ήταν λάθος. Μένουν τα τρία πιο πρόσφατα.';

  @override
  String get backupSafetyRestore => 'ΕΠΑΝΑΦΟΡΑ';

  @override
  String get backupSafetyShare => 'ΚΟΙΝΟΠΟΙΗΣΗ';

  @override
  String get backupCloudNoDetails => 'Οι λεπτομέρειες είναι ακόμα καθ\' οδόν.';

  @override
  String get tacticsLibraryTitle => 'ΒΙΒΛΙΟΘΗΚΗ ΤΑΚΤΙΚΩΝ';

  @override
  String get tacticsLibraryBlurb =>
      'Οι τακτικές της βιβλιοθήκης σας φορτώνονται σε οποιαδήποτε αποθήκευση, ακόμη και σε νέα. Οι ρόλοι και οι εκτελεστές στατικών φάσεων κρατιούνται ανά θέση, όχι ανά παίκτη.';

  @override
  String get tacticsSaveToLibrary => 'Αποθήκευση στη βιβλιοθήκη';

  @override
  String get tacticsLoadFromLibrary => 'Φόρτωση από τη βιβλιοθήκη';

  @override
  String get tacticsLibraryEmpty =>
      'Η βιβλιοθήκη σας είναι άδεια. Αποθηκεύστε εδώ μια τακτική και θα μπορείτε να τη φορτώσετε σε κάθε αποθήκευση.';

  @override
  String tacticsLibrarySaved(String name) {
    return 'Η «$name» αποθηκεύτηκε στη βιβλιοθήκη';
  }

  @override
  String tacticsLibraryLoaded(String name) {
    return 'Φορτώθηκε: «$name»';
  }

  @override
  String tacticsLibraryNotFitted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count ρόλοι ή εκτελεστές στατικών φάσεων δεν ταίριαξαν σε αυτό το ρόστερ.',
      one:
          '1 ρόλος ή εκτελεστής στατικών φάσεων δεν ταίριαξε σε αυτό το ρόστερ.',
    );
    return '$_temp0';
  }

  @override
  String get tacticsLibraryRename => 'Μετονομασία';

  @override
  String get tacticsLibraryRenameTitle => 'Μετονομασία τακτικής';

  @override
  String get tacticsLibraryDelete => 'Διαγραφή';

  @override
  String tacticsLibraryDeleteTitle(String name) {
    return 'Διαγραφή της «$name»;';
  }

  @override
  String get tacticsLibraryDeleteBody =>
      'Θα φύγει από τη βιβλιοθήκη σε όλες τις αποθηκεύσεις σας.';

  @override
  String get tacticsLibraryNameTaken =>
      'Υπάρχει ήδη τακτική με αυτό το όνομα στη βιβλιοθήκη σας.';

  @override
  String tacticsLibraryCouldNotLoad(String error) {
    return 'Δεν ήταν δυνατή η φόρτωση της βιβλιοθήκης.\n$error';
  }

  @override
  String hostBidHeading(String competition, int year) {
    return 'Υποψηφιότητα διοργάνωσης: $competition $year';
  }

  @override
  String get hostBidScreenTitle => 'Υποψηφιότητα';

  @override
  String get hostBidBlurb =>
      'Ο διοργανωτής βγαίνει με κλήρωση ανάμεσα στους υποψηφίους. Μια υποψηφιότητα δίνει περισσότερο βάρος στο όνομά σας: τα γήπεδά σας δίνουν μια αρχική πιθανότητα και τα χρήματα την αυξάνουν, αν και κάθε επιπλέον εκατομμύριο μετράει λίγο λιγότερο. Τα χρήματα ξοδεύονται είτε κερδίσετε είτε όχι.';

  @override
  String hostBidPrize(String amount) {
    return 'Αν κερδίσετε, διοργανώνετε, προκρίνεστε αυτόματα και παίρνετε μια εφάπαξ ενίσχυση $amount για τον επόμενο προϋπολογισμό.';
  }

  @override
  String get hostBidChance => 'Πιθανότητα διοργάνωσης';

  @override
  String get hostBidBaseLabel => 'Γήπεδα και θέση';

  @override
  String get hostBidInvestLabel => 'Επένδυση';

  @override
  String hostBidCeiling(String nation, String percent) {
    return 'Ανώτατο όριο για $nation: $percent';
  }

  @override
  String get hostBidInvestment => 'Η επένδυσή σας';

  @override
  String hostBidFreeFunds(String amount) {
    return 'Ελεύθερα κεφάλαια: $amount';
  }

  @override
  String get hostBidSubmit => 'Υποβολή υποψηφιότητας';

  @override
  String get hostBidDecline => 'Όχι αυτή τη φορά';

  @override
  String get hostBidUnavailable => 'Αυτή η υποψηφιότητα δεν είναι πια ανοιχτή.';

  @override
  String hostBidWonTitle(String competition, int year) {
    return 'Η υποψηφιότητα κέρδισε: $competition $year';
  }

  @override
  String hostBidWonBody(String amount) {
    return 'Θα διοργανώσουμε το τουρνουά και ως διοργανωτές προκρινόμαστε αυτόματα. Μια εφάπαξ ενίσχυση $amount βρίσκεται ήδη στα ταμεία της ομοσπονδίας και μπορείτε να τη μοιράσετε στα τμήματα αυτού του κύκλου απευθείας από την κεντρική οθόνη.';
  }

  @override
  String hostBidLostTitle(String competition, int year) {
    return 'Η υποψηφιότητα απέτυχε: $competition $year';
  }

  @override
  String hostBidLostBody(String hosts) {
    return 'Τη διοργάνωση πήραν: $hosts. Η υποψηφιότητά μας δεν έφτασε αυτή τη φορά και τα χρήματα που δόθηκαν χάθηκαν, αλλά η ομοσπονδία έκανε την προσπάθειά της.';
  }

  @override
  String get hostBidGrantEvent => 'Κατανομή ενίσχυσης διοργάνωσης';

  @override
  String hostBidGrantBanner(String amount) {
    return 'Ενίσχυση διοργάνωσης: $amount για να προστεθούν τώρα στα τμήματα αυτού του κύκλου. Ό,τι έχει ήδη μοιραστεί μένει, και ό,τι περισσέψει μένει στο ταμείο.';
  }

  @override
  String get stadiumsTitle => 'Εθνικά γήπεδα';

  @override
  String get stadiumsEntrySub => 'Αναβάθμισε ένα γήπεδο ή χτίσε καινούργιο';

  @override
  String get stadiumsBlurb =>
      'Το επίπεδο ενός γηπέδου είναι το μέγεθός του: επίπεδο 1 κάτω από 15.000 θέσεις, επίπεδο 2 από 15.000, επίπεδο 3 από 25.000, επίπεδο 4 από 40.000, επίπεδο 5 από 60.000. Κάθε γήπεδο αποδίδει ένα μικρό έσοδο στην αρχή κάθε κύκλου, περισσότερο όσο περισσότερες οι θέσεις, εφόσον τις γεμίζουν οι φίλαθλοί σας. Μια αναβάθμιση προσθέτει θέσεις αμέσως και λίγη φήμη από τον επόμενο κύκλο· μια σμίκρυνση μειώνει τη συντήρηση, αλλά δεν επιστρέφει τίποτα. Τα γήπεδά σας κρίνουν για ποια τουρνουά μπορείτε να είστε υποψήφιοι.';

  @override
  String stadiumsIncome(String amount) {
    return 'Έσοδα γηπέδων: $amount ανά κύκλο';
  }

  @override
  String stadiumsReputation(int points) {
    return 'Φήμη από τα γήπεδα: +$points';
  }

  @override
  String get stadiumsClosed =>
      'Τα έργα παραγγέλνονται στην αρχή ενός κύκλου, πριν οριστεί ο προϋπολογισμός.';

  @override
  String stadiumsCapacity(String seats) {
    return 'Χωρητικότητα: $seats';
  }

  @override
  String stadiumsLevel(int level, int max) {
    return 'Επίπεδο $level/$max';
  }

  @override
  String stadiumsUpgrade(String cost) {
    return 'Αναβάθμιση: $cost';
  }

  @override
  String get stadiumsTopLevel => 'Ανώτατο επίπεδο';

  @override
  String stadiumsOpens(int year) {
    return 'Υπό κατασκευή, ανοίγει το $year';
  }

  @override
  String get stadiumsBuildTitle => 'Χτίσε νέο γήπεδο';

  @override
  String get stadiumsBuildBody =>
      'Αρκετά ακριβό: ένα νέο γήπεδο στην πόλη που θα διαλέξεις, ανοιχτό από την αρχή του επόμενου κύκλου.';

  @override
  String get stadiumsBuildCity => 'Πόλη';

  @override
  String stadiumsBuildButton(String cost) {
    return 'Κατασκευή: $cost';
  }

  @override
  String get stadiumsBuilding => 'Ήδη χτίζεται ένα γήπεδο.';

  @override
  String get stadiumsNoCity => 'Κάθε πόλη έχει ήδη νέο γήπεδο.';

  @override
  String stadiumsConfirmUpgrade(String stadium, int level, String cost) {
    return 'Αναβάθμιση του $stadium στο επίπεδο $level με $cost;';
  }

  @override
  String stadiumsConfirmBuild(String city, String cost) {
    return 'Κατασκευή νέου γηπέδου με $cost; Πόλη: $city';
  }

  @override
  String get stadiumsConfirm => 'Επιβεβαίωση';

  @override
  String get stadiumsCancel => 'Ακύρωση';

  @override
  String get stadiumsRefused =>
      'Η παραγγελία δεν ολοκληρώθηκε. Δεν χρεώθηκε τίποτα.';

  @override
  String get stadiumsNameLabel => 'Όνομα γηπέδου';

  @override
  String get stadiumsNameHint =>
      'Αφήστε το κενό για να μείνει το προτεινόμενο όνομα.';

  @override
  String get stadiumsRename => 'Μετονομασία γηπέδου';

  @override
  String get hostBidSectionTitle => 'Υποψηφιότητες διοργάνωσης';

  @override
  String get hostBidOpenSub =>
      'Προαιρετικό. Αποφασίστε πριν ξεκινήσει ο νέος κύκλος.';

  @override
  String get hostBidDecidedAtRollover =>
      'Ο διοργανωτής ανακοινώνεται με την έναρξη του νέου κύκλου.';

  @override
  String get hostBidLodged =>
      'Η υποψηφιότητα κατατέθηκε. Ο διοργανωτής ανακοινώνεται με την έναρξη του νέου κύκλου.';

  @override
  String get hostBidDeclinedNote =>
      'Αυτή τη φορά επιλέξατε να μην είστε υποψήφιοι.';

  @override
  String get hostBidOpensLater =>
      'Πληροίτε τις προϋποθέσεις. Μπορείτε να είστε υποψήφιοι στο τέλος αυτού του κύκλου.';

  @override
  String get hostBidNoFunds =>
      'Δεν υπάρχουν αρκετά ελεύθερα κεφάλαια για υποψηφιότητα.';

  @override
  String hostBidNeedStadiums(int count, String seats) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Χρειάζεστε ακόμη $count γήπεδα $seats+ θέσεων.',
      one: 'Χρειάζεστε ακόμη 1 γήπεδο $seats+ θέσεων.',
    );
    return '$_temp0';
  }

  @override
  String hostBidBarredConf(String confederation) {
    return 'Το τελευταίο Παγκόσμιο Πρωτάθλημα το διοργάνωσε: $confederation.';
  }

  @override
  String get hostBidRecentHost =>
      'Διοργανώσατε μία από τις τρεις τελευταίες διοργανώσεις.';

  @override
  String hostBidRequirement(
    int grounds,
    String minSeats,
    int bigGrounds,
    String bigSeats,
  ) {
    return 'Προϋπόθεση: $grounds γήπεδα $minSeats+ θέσεων, από τα οποία $bigGrounds με $bigSeats+.';
  }

  @override
  String hostBidWonBodyBudget(String amount) {
    return 'Θα διοργανώσουμε το τουρνουά και προκρινόμαστε αυτόματα ως διοργανωτές. Μια εφάπαξ ενίσχυση $amount είναι ήδη στα κεφάλαια της ομοσπονδίας, έτοιμη για τον προϋπολογισμό αυτού του κύκλου.';
  }

  @override
  String get hubStadiumIncome => 'Έσοδα γηπέδων';

  @override
  String get stadiumsDownsize => 'Σμίκρυνση';

  @override
  String stadiumsConfirmDownsize(String stadium, String seats, int level) {
    return 'Σμίκρυνση του $stadium στις $seats θέσεις (επίπεδο $level); Δεν επιστρέφεται τίποτα, αλλά πέφτει το κόστος συντήρησης.';
  }

  @override
  String get stadiumsResizedThisCycle => 'Ανακατασκευάστηκε σε αυτόν τον κύκλο';

  @override
  String stadiumsGroundIncome(String amount) {
    return 'Αποδίδει $amount ανά κύκλο';
  }

  @override
  String hostBidLapsedTitle(String competition, int year) {
    return 'Η υποψηφιότητα αποσύρθηκε: $competition $year';
  }

  @override
  String hostBidLapsedBodyNation(String nation) {
    return 'Η υποψηφιότητα είχε κατατεθεί για: $nation, αλλά ξεκινάτε τον νέο κύκλο αλλού. Αποσύρθηκε και δεν χρεώθηκε τίποτα.';
  }

  @override
  String get hostBidLapsedBodyFunds =>
      'Στο κλείσιμο του κύκλου τα κεφάλαια της ομοσπονδίας δεν κάλυπταν πια το ποσό. Η υποψηφιότητα αποσύρθηκε και δεν χρεώθηκε τίποτα.';

  @override
  String get stadiumsViewMap => 'Χάρτης';

  @override
  String get stadiumsViewList => 'Λίστα';

  @override
  String get stadiumsMapPickCity =>
      'Πάτησε μια πόλη για να χτίσεις εκεί νέο γήπεδο.';

  @override
  String get stadiumsMapFit => 'Εμφάνιση όλης της χώρας';

  @override
  String get campaignLegacyTitle => 'Ολοκλήρωσε την κληρονομιά';

  @override
  String get campaignLegacyTwist =>
      'Η Ισπανία, κάτοχος του Ευρωπαϊκού, για έναν κύκλο';

  @override
  String get campaignLegacyGoal => 'Υπεράσπισε τον ευρωπαϊκό τίτλο';

  @override
  String get campaignLegacyIntro =>
      'Η Ισπανία είναι η κάτοχος του Ευρωπαϊκού Πρωταθλήματος και οι αμφισβητίες λένε πως η χρυσή πορεία ήταν συγκυρία. Έχεις έναν κύκλο να αποδείξεις το αντίθετο: υπεράσπισε το στέμμα της ηπείρου και μετά κυνήγησε τον κόσμο. Πρόσθεσε το Κύπελλο Εθνών και η κληρονομιά ολοκληρώνεται.';

  @override
  String get campaignStars1Legacy => 'Κατάκτηση του Ευρωπαϊκού Πρωταθλήματος';

  @override
  String get campaignStars2Legacy => 'Και του Παγκόσμιου Πρωταθλήματος';

  @override
  String get campaignStars3Legacy => 'Και του Κυπέλλου Εθνών';

  @override
  String get campaignSectionOneCycle => 'Ένας κύκλος';

  @override
  String get campaignSectionShort => 'Λίγοι κύκλοι';

  @override
  String get campaignSectionLong => 'Μακρύς δρόμος';

  @override
  String get campaignFilterAll => 'Όλες';

  @override
  String get campaignFilterNew => 'Δεν παίχτηκαν';

  @override
  String get campaignFilterInProgress => 'Σε εξέλιξη';

  @override
  String get campaignFilterDone => 'Ολοκληρωμένες';

  @override
  String get campaignFilterEmpty => 'Δεν υπάρχουν ακόμη εκστρατείες εδώ.';

  @override
  String campaignStarsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count αστέρια',
      one: '1 αστέρι',
      zero: 'Κανένα αστέρι',
    );
    return '$_temp0';
  }

  @override
  String campaignCycles(int cycles) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles κύκλοι',
      one: '1 κύκλος',
    );
    return '$_temp0';
  }

  @override
  String get msgIntlRetireNoteHigh => ' Αποχωρεί στην κορυφή, ως πρωταθλητής.';

  @override
  String get msgIntlRetireNoteMissed =>
      ' Ο αποκλεισμός από τα τελικά ήταν η σταγόνα που ξεχείλισε το ποτήρι.';

  @override
  String get msgIntlRetireNoteSurprise => ' Κανείς δεν το περίμενε.';

  @override
  String get msgIntlRetireNoteRecord => ' Φεύγει ως ρέκορντμαν της εθνικής.';

  @override
  String msgIntlRetireNewsTitle(String nation, String name) {
    return '$nation: Αποσύρεται από την εθνική ο $name';
  }

  @override
  String msgIntlRetireNewsBody(String name, String nation, int age) {
    return 'Ο $name ($nation) ανακοίνωσε στα $age την αποχώρησή του από το διεθνές ποδόσφαιρο.';
  }

  @override
  String msgIntlComebackTitle(String name) {
    return 'Επιστρέφει στην εθνική ο $name';
  }

  @override
  String msgIntlComebackBody(String name, int age) {
    return 'Ο $name είναι ξανά διαθέσιμος για κλήση, στα $age.';
  }

  @override
  String get msgIntlComebackNoteCrisis =>
      ' Με την ομάδα αποδεκατισμένη από τραυματισμούς, απάντησε στο κάλεσμα.';

  @override
  String get msgIntlComebackNoteManager => ' Ο νέος ομοσπονδιακός τον έπεισε.';

  @override
  String msgIntlComebackNewsTitle(String nation, String name) {
    return '$nation: Επιστρέφει στην εθνική ο $name';
  }

  @override
  String msgIntlComebackNewsBody(String name, String nation, int age) {
    return 'Ο $name ($nation) είναι ξανά διαθέσιμος για κλήση, στα $age.';
  }

  @override
  String playerIntlRetired(int year) {
    return 'Αποσύρθηκε από την εθνική, $year';
  }

  @override
  String playerIntlComeback(int year) {
    return 'Επέστρεψε στην εθνική, $year';
  }

  @override
  String yLegendRetires0(String name) {
    return 'Ευχαριστούμε, $name. Άλλοι φορούν τη φανέλα, εσύ τη σήκωσες στους ώμους.';
  }

  @override
  String yLegendRetires1(String name) {
    return 'Ο $name κλείνει την καριέρα του στην εθνική. Τέλος εποχής.';
  }

  @override
  String yLegendRetires2(String name) {
    return 'Αποσύρεται ο $name. Ένα τουρνουά αργότερα απ\' ό,τι έπρεπε, για να είμαστε ειλικρινείς.';
  }

  @override
  String yLegendRetires3(String name) {
    return 'Τέλος λοιπόν ο $name. Ώρα να παίξουν οι νέοι.';
  }

  @override
  String matchAltitudeOpponentsTire(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'Υψόμετρο $altitudeString μ.: ο αντίπαλος θα κουραστεί πιο γρήγορα';
  }

  @override
  String matchAltitudeYouTire(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'Υψόμετρο $altitudeString μ.: οι παίκτες σας θα κουραστούν πιο γρήγορα';
  }

  @override
  String matchAltitudeBothTire(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'Υψόμετρο $altitudeString μ.: και οι δύο ομάδες θα κουραστούν πιο γρήγορα';
  }

  @override
  String matchAltitudeUsedTo(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'Υψόμετρο $altitudeString μ.: και οι δύο ομάδες είναι συνηθισμένες';
  }

  @override
  String matchHeatExpected(int temp) {
    final intl.NumberFormat tempNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String tempString = tempNumberFormat.format(temp);

    return 'Ζέστη: αναμένονται $tempString°C, οι δυνάμεις θα τελειώσουν νωρίτερα';
  }

  @override
  String get matchConditionsAdvice =>
      'Σχεδιάστε νωρίς τις αλλαγές: εδώ τα ξεκούραστα πόδια μετράνε περισσότερο';

  @override
  String get fanMoodFurious => 'έξαλλοι';

  @override
  String get fanMoodRestless => 'ανήσυχοι';

  @override
  String get fanMoodCalm => 'ήρεμοι';

  @override
  String get fanMoodUpbeat => 'αισιόδοξοι';

  @override
  String get fanMoodEuphoric => 'σε ευφορία';

  @override
  String matchHomeFans(String mood) {
    return 'Οπαδοί στην έδρα: $mood';
  }

  @override
  String federationFans(String mood) {
    return 'Οπαδοί: $mood';
  }

  @override
  String federationFansIncome(String change) {
    return 'Έσοδα γηπέδων τον επόμενο κύκλο: $change';
  }

  @override
  String yFansProtest0(String nation, String manager) {
    return 'Είκοσι χρόνια ακολουθώ την εθνική εντός κι εκτός. Δεν ανανεώνω το διαρκείας μου μέχρι να αλλάξει κάτι.';
  }

  @override
  String yFansProtest1(String nation, String manager) {
    return 'Θα συνεχίσουμε να τραγουδάμε για τη φανέλα. Αλλά το πανό στη βόρεια κερκίδα απόψε είπε αυτό που σκεφτόμαστε όλοι.';
  }

  @override
  String yFansProtest2(String nation, String manager) {
    return 'Μισό γήπεδο άδειο, και το άλλο μισό πέρασε το δεύτερο ημίχρονο φωνάζοντας #${manager}Out.';
  }

  @override
  String yFansProtest3(String nation, String manager) {
    return 'Οι σύνδεσμοι οπαδών μιλούν για μποϊκοτάζ στο επόμενο εντός έδρας παιχνίδι. Δύσκολα τους κατηγορείς.';
  }

  @override
  String yFansProtest4(String nation, String manager) {
    return '#${manager}Out. Ούτε θυμωμένος δεν είμαι πια. Απλώς τελείωσε.';
  }

  @override
  String yFansProtest5(String nation, String manager) {
    return 'Φωτογραφία από απόψε: σειρές άδεια καθίσματα και ένα σεντόνι που γράφει #${manager}Out. Αυτή είναι η ανταπόκριση.';
  }

  @override
  String yFansSellOut0(String nation) {
    return 'Ξανά sold out. Η καλύτερη εθνική εδώ και χρόνια, και όλη η χώρα το ξέρει.';
  }

  @override
  String yFansSellOut1(String nation) {
    return 'Τα εισιτήρια για το επόμενο εντός έδρας εξαντλήθηκαν σε έντεκα λεπτά. Αυτή η ομάδα μάς έδωσε πίσω τα Σαββατοκύριακα.';
  }

  @override
  String yFansSellOut2(String nation) {
    return 'Ούτε μία θέση ελεύθερη για το επόμενο εντός έδρας. Η ομοσπονδία θα μετράει τις εισπράξεις χαμογελώντας.';
  }

  @override
  String yFansSellOut3(String nation) {
    return 'Άλλο ένα sold out. Πείτε ό,τι θέλετε για την τακτική: ο κόσμος θέλει να είναι σε αυτό το γήπεδο.';
  }

  @override
  String yFansSellOut4(String nation) {
    return 'Sold out, εντάξει. Οι ίδιοι αποδοκίμαζαν αυτή την ομάδα πριν από ενάμιση χρόνο.';
  }

  @override
  String yFansSellOut5(String nation) {
    return 'Ξαφνικά sold out, ξαφνικά όλοι ειδικοί. Πού ήσασταν όταν δεν κερδίζαμε κανέναν;';
  }

  @override
  String get campaignsIntro =>
      'Οι εκστρατείες είναι χειροποίητες προκλήσεις: μια συγκεκριμένη εθνική ομάδα, ένας κόσμος με τη δική του ανατροπή και ένας στόχος σε σταθερό αριθμό κύκλων. Κάθε διαδρομή μένει χωριστά από τις αποθηκευμένες καριέρες σου, και όσο πιο μακριά φτάσεις, τόσο περισσότερα αστέρια κερδίζεις, έως τρία.';

  @override
  String hubEventScandal(String player) {
    return 'Σκάνδαλο στην προετοιμασία: $player';
  }

  @override
  String get hubEventScandalSub => 'Θα τον στείλεις σπίτι ή θα τον κρατήσεις;';

  @override
  String get scandalTitle => 'ΣΚΑΝΔΑΛΟ';

  @override
  String scandalStoryParty(String player) {
    return 'Ο $player ήταν σε πάρτι που κράτησε ως τα ξημερώματα, και οι φωτογραφίες ήταν σε όλες τις εφημερίδες το πρωί που μαζεύτηκε η ομάδα.';
  }

  @override
  String scandalStoryCurfew(String player) {
    return 'Ο $player παραβίασε την απαγόρευση εξόδου και πιάστηκε να επιστρέφει στο ξενοδοχείο τα ξημερώματα.';
  }

  @override
  String scandalStoryNightclub(String player) {
    return 'Ο $player φωτογραφήθηκε σε νυχτερινό κέντρο την παραμονή της προετοιμασίας, και οι φωτογραφίες είναι παντού.';
  }

  @override
  String scandalStoryCasino(String player) {
    return 'Ο $player πέρασε τη νύχτα πριν από την προετοιμασία σε τραπέζι καζίνου, και ένα ταμπλόιντ έχει τις φωτογραφίες.';
  }

  @override
  String get scandalSendHome => 'Στείλ\' τον σπίτι';

  @override
  String scandalSendHomeCover(String player) {
    return 'Σπίτι, κάλεσε τον $player';
  }

  @override
  String scandalKeep(String player) {
    return 'Κράτα τον $player';
  }

  @override
  String get scandalKeepNote =>
      'Αν μείνει: ηθικό περίπου -4 και διοίκηση περίπου -3 ως το τέλος του κύκλου.';

  @override
  String get scandalSendHomeNote =>
      'Αν τον στείλεις σπίτι: κανένα κόστος σε ηθικό ή διοίκηση, και μπορείς να καλέσεις αντικαταστάτη.';

  @override
  String get scandalFinalsNote =>
      'Αν τον στείλεις σπίτι: κανένα κόστος σε ηθικό ή διοίκηση, αλλά σε τελική φάση κανείς δεν μπορεί να τον αντικαταστήσει.';

  @override
  String get scandalPickCover => 'Κάλεσε αντικαταστάτη (προαιρετικό)';

  @override
  String newsScandalTitle(String player) {
    return 'Σκάνδαλο στην προετοιμασία: $player';
  }

  @override
  String yScandalParty0(String player, String tag) {
    return 'Παιδιά είναι. Ο $player σε πάρτι το βράδυ πριν την προετοιμασία, κι εγώ πάλι τον θέλω στο γήπεδο. #$tag';
  }

  @override
  String yScandalParty1(String player, String tag) {
    return 'Ο $player φωτογραφήθηκε σε ολονύχτιο πάρτι λίγες ώρες πριν μαζευτεί η ομάδα. Η ομοσπονδία ενημερώθηκε. #$tag';
  }

  @override
  String yScandalParty2(String player, String tag) {
    return 'Ολονύχτιο πάρτι πριν την προετοιμασία. $player, τι σκεφτόσουν; Απίστευτο. #$tag';
  }

  @override
  String yScandalCurfew0(String player, String tag) {
    return 'Γύρισε μετά την ώρα, εντάξει, συμβαίνει. Ο $player απλώς πρέπει να το διορθώσει στο γήπεδο. #$tag';
  }

  @override
  String yScandalCurfew1(String player, String tag) {
    return 'Ο $player πιάστηκε να επιστρέφει στο ξενοδοχείο της ομάδας μετά την απαγόρευση, λίγες ώρες πριν την προπόνηση. #$tag';
  }

  @override
  String yScandalCurfew2(String player, String tag) {
    return 'Η απαγόρευση εξόδου δεν είναι δύσκολη υπόθεση. Ο $player δεν άντεξε ούτε ένα βράδυ. #$tag';
  }

  @override
  String yScandalNightclub0(String player, String tag) {
    return 'Και τι έγινε που ο $player πήγε σε κλαμπ; Και οι ποδοσφαιριστές έχουν ζωή. Αφήστε τον να παίξει. #$tag';
  }

  @override
  String yScandalNightclub1(String player, String tag) {
    return 'Φωτογραφίες δείχνουν τον $player σε νυχτερινό κέντρο την παραμονή της προετοιμασίας της εθνικής. #$tag';
  }

  @override
  String yScandalNightclub2(String player, String tag) {
    return 'Φωτογραφίες από κλαμπ την παραμονή της προετοιμασίας. Ο $player ντρόπιασε τη φανέλα. #$tag';
  }

  @override
  String yScandalCasino0(String player, String tag) {
    return 'Μια νύχτα στο καζίνο δεν είναι έγκλημα. Ο $player θα είναι μια χαρά. #$tag';
  }

  @override
  String yScandalCasino1(String player, String tag) {
    return 'Ο $player εντοπίστηκε σε τραπέζι καζίνου τη νύχτα πριν μαζευτεί η ομάδα. #$tag';
  }

  @override
  String yScandalCasino2(String player, String tag) {
    return 'Όλη νύχτα στο καζίνο πριν την προετοιμασία. Ο $player έπαιξε κάτι περισσότερο από λεφτά. #$tag';
  }

  @override
  String yScandalSentHome0(String player) {
    return 'Σωστή απόφαση. Κανείς δεν είναι πάνω από την ομάδα, ούτε ο $player.';
  }

  @override
  String yScandalSentHome1(String player) {
    return 'Η επιστροφή του $player στο σπίτι ήταν η μόνη απάντηση. Σεβασμός στον προπονητή.';
  }

  @override
  String yScandalSentHome2(String player) {
    return 'Η πειθαρχία είναι πειθαρχία. Ο $player ήξερε τους κανόνες.';
  }

  @override
  String yScandalSentHome3(String player) {
    return 'Ξεκάθαρο μήνυμα στα αποδυτήρια: ο $player είναι στο αεροπλάνο για το σπίτι.';
  }

  @override
  String yScandalSentHome4(String player) {
    return 'Σκληρό για τον $player. Ένα βράδυ έξω και τελείωσε η προετοιμασία του;';
  }

  @override
  String yScandalSentHome5(String player) {
    return 'Χωρίς τον $player είμαστε πιο αδύναμοι. Θα το πληρώσουμε στο γήπεδο.';
  }

  @override
  String yScandalKept0(String player) {
    return 'Το να κρατήσεις τον $player είναι ρίσκο. Καλά θα κάνει να το ξεπληρώσει στο γήπεδο.';
  }

  @override
  String yScandalKept1(String player) {
    return 'Εντάξει, ο $player μένει. Τότε χρωστάει σε όλους μια μεγάλη εμφάνιση.';
  }

  @override
  String yScandalKept2(String player) {
    return 'Άρα οι κανόνες δεν ισχύουν για τον $player. Καλό να το ξέρουμε.';
  }

  @override
  String yScandalKept3(String player) {
    return 'Η απαγόρευση εξόδου είναι πια προαιρετική, απ\' ό,τι φαίνεται. Ρωτήστε τον $player.';
  }

  @override
  String yScandalKept4(String player) {
    return 'Κρατάς τον $player μετά από αυτό; Αυτή η ομάδα είναι κατασκήνωση.';
  }

  @override
  String yScandalKept5(String player) {
    return 'Πάρτι όλη νύχτα και μετά κατευθείαν στην αρχική ενδεκάδα. Υπέροχο μήνυμα, κόουτς. Ο $player θα πετάει από τη χαρά του.';
  }

  @override
  String get yStreamerBreaks0 =>
      'Ο ΑΔΕΡΦΟΣ ΤΗΝ ΠΑΤΗΣΕ 😭😭 ΤΗ ΝΥΧΤΑ ΠΡΙΝ ΤΗΝ ΠΡΟΕΤΟΙΜΑΣΙΑ;; ΚΛΑΙΩ 💀💀💀';

  @override
  String get yStreamerBreaks1 =>
      'ΟΧΙΙΙ ΤΣΑΤ ΔΕΙΤΕ ΑΥΤΟ 🤯🤯 Ο ΑΔΕΡΦΟΣ ΤΟ ΕΚΑΝΕ ΣΤΑ ΑΛΗΘΕΙΑ ΠΡΙΝ ΤΗΝ ΠΡΟΕΤΟΙΜΑΣΙΑ 😭🔥';

  @override
  String get yStreamerBreaks2 =>
      'ΠΟΙΟΣ ΤΟΝ ΑΦΗΣΕ ΝΑ ΒΓΕΙ;; ΠΟΙΟΣ ΤΟΝ ΑΦΗΣΕ 😭😭💀 ΑΥΤΟ ΕΙΝΑΙ ΣΙΝΕΜΑ 🔥🔥';

  @override
  String get yStreamerSentHome0 =>
      'ΣΠΙΤΙ;; ΣΠΙΤΙ!!! 😭😭😭 Ο ΚΟΟΥΤΣ ΔΕΝ ΑΣΤΕΙΕΥΕΤΑΙ 💀🔥';

  @override
  String get yStreamerSentHome1 =>
      'Ο ΑΔΕΡΦΟΣ ΜΑΖΕΥΕΙ ΒΑΛΙΤΣΕΣ ΖΩΝΤΑΝΑ 🤯🤯 ΑΝΤΙΟ ΑΔΕΡΦΕ 😭👋';

  @override
  String get yStreamerSentHome2 =>
      'ΑΠΟΚΛΕΙΕΤΑΙΙΙ ΤΟΝ ΕΣΤΕΙΛΑΝ ΣΠΙΤΙ 💀💀 ΤΣΑΤ ΤΡΕΜΩ 🔥🔥🔥';

  @override
  String get yStreamerKept0 =>
      'ΜΕΝΕΙ;;; ΜΕΝΕΕΕΙ 🤯🤯 Ο ΑΔΕΡΦΟΣ ΕΙΝΑΙ ΑΝΕΓΓΙΧΤΟΣ 😭🔥';

  @override
  String get yStreamerKept1 =>
      'ΠΑΡΤΙ ΟΛΗ ΝΥΧΤΑ ΚΑΙ ΑΚΟΜΑ ΣΤΗΝ ΑΠΟΣΤΟΛΗ 💀💀 ΘΕΛΩ ΑΥΤΟ ΤΟ ΣΥΜΒΟΛΑΙΟ 😭😭';

  @override
  String get yStreamerKept2 => 'Ο ΚΟΟΥΤΣ ΛΕΕΙ ΟΛΑ ΚΑΛΑ 😭😭 ΑΔΕΡΦΕ ΤΙ 🤯🤯🤯';

  @override
  String get yCameoUjfaloci =>
      'Δεν πλήρωσα τίποτα, και το ποσό δεν βγαίνει κιόλας';

  @override
  String get yCameoHavir0 => 'Τα ψαράκια κολύμπησαν μακριά.';

  @override
  String get yCameoHavir1 => 'Ρίξαμε τα δίχτυα, τα ψάρια ήταν αλλού.';

  @override
  String get yCameoHavir2 =>
      'Το είχα πει από τον Σεπτέμβριο, πάνω από ένα γκούλας.';

  @override
  String get yCameoHavir3 =>
      'Όποιος δεν ψάρεψε στην ώρα του, ας μην κλαίει τώρα.';

  @override
  String get yCameoHavir4 => 'Παίξαμε σαν γατόψαρο στη στεριά.';

  @override
  String get yCameoHavir5 => 'Φυσάει ο αέρας, παγώνει η λίμνη. Έτσι πάει.';

  @override
  String get yCameoHavir6 => 'Κάποιες μέρες βγάζεις μόνο μια παλιά μπότα.';

  @override
  String get yCameoHavir7 =>
      'Στην εποχή μου τουλάχιστον πηγαίναμε για μια μπίρα. Τώρα ούτε αυτό.';

  @override
  String get yCameoLzimberskyHome0 =>
      'Να στείλεις ένα παιδί σπίτι για ένα βράδυ; Αυτό είναι το σκάνδαλο, όχι το πάρτι!';

  @override
  String get yCameoLzimberskyHome1 =>
      'Τα παιδιά έχουν δικαίωμα να διασκεδάσουν! Τα υποκριτικά μέσα κέρδισαν ξανά.';

  @override
  String get yCameoLzimberskyHome2 =>
      'Αυτό είναι κυνήγι μαγισσών. Ένας νέος βγαίνει ένα βράδυ και τον κρεμάτε.';

  @override
  String get yCameoLzimberskyHome3 =>
      'Όποιος δημοσιογράφος δεν έχει πάει ποτέ σε πάρτι, ας ρίξει την πρώτη πέτρα. Ντροπή!';

  @override
  String get yCameoLzimberskyHome4 =>
      'Ο προπονητής φοβήθηκε τα ταμπλόιντ. Εγώ θα υπερασπιζόμουν το παιδί ως την τελευταία μου πνοή!';

  @override
  String get yCameoLzimberskyKept0 =>
      'Επιτέλους ένας προπονητής με σπονδυλική στήλη! Κράτησε το παιδί και τα μέσα ας κλαίνε.';

  @override
  String get yCameoLzimberskyKept1 =>
      'Τα παιδιά έχουν δικαίωμα να διασκεδάσουν, σωστά; Μπράβο, κόουτς!';

  @override
  String get yCameoLzimberskyKept2 =>
      'Τα υποκριτικά μέσα φωνάζουν, ο προπονητής κρατάει γραμμή. Έτσι γίνεται!';

  @override
  String get yCameoLzimberskyKept3 =>
      'Ένα βράδυ έξω και ο Τύπος θέλει να τον λιθοβολήσει. Ο προπονητής είναι άντρας!';

  @override
  String get yCameoLzimberskyKept4 =>
      'Λέω: αφήστε τα παιδιά να ζήσουν! Όποιος δουλεύει σκληρά, δικαιούται και να διασκεδάζει. Μπράβο.';

  @override
  String get yTraitStreamer => 'Μεταδίδει τα πάντα, στη διαπασών, με κεφαλαία.';

  @override
  String hubEventAwardsCeremony(int year) {
    return 'Παίκτης της Χρονιάς $year';
  }

  @override
  String get hubEventAwardsCeremonySub => 'Οι ψήφοι μετρήθηκαν';

  @override
  String get potyCeremonyWatch => 'Δες την τελετή';

  @override
  String get potyCeremonySkipToList => 'Κατευθείαν στην πρώτη πεντάδα';

  @override
  String get potyCeremonySkip => 'Παράλειψη';

  @override
  String get potyCeremonyIntro =>
      'Οι ψήφοι μετρήθηκαν. Αυτοί είναι οι πέντε καλύτεροι παίκτες του κόσμου φέτος.';

  @override
  String potyCeremonyPlace(int place) {
    return 'Θέση $place';
  }

  @override
  String get potyCeremonyWinnerIs => 'Και ο Παίκτης της Χρονιάς είναι...';

  @override
  String get potyTop5Heading => 'Η παγκόσμια πρώτη πεντάδα';

  @override
  String get potyYoungTop3Heading => 'Νέος Παίκτης της Χρονιάς: πρώτη τριάδα';

  @override
  String get potySeeTop5 => 'Δες την πρώτη πεντάδα';

  @override
  String get potyYourPlayer => 'Ο παίκτης σου';

  @override
  String potyTallyCleanSheets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count μηδέν παθητικά',
      one: '1 μηδέν παθητικό',
    );
    return '$_temp0';
  }

  @override
  String get campaignFullBrief => 'Πλήρης ενημέρωση';

  @override
  String campaignStarsSoFar(int earned, int total) {
    return 'Αστέρια ως τώρα: $earned από $total';
  }

  @override
  String get campaignStarEarned => 'Κερδισμένο ως τώρα';

  @override
  String get campaignStarNotYet => 'Δεν έχει κερδηθεί ακόμη';

  @override
  String get stadiumsEntrySubClosed =>
      'Δες τα γήπεδά σου. Τα έργα ανοίγουν ξανά στην αρχή του επόμενου κύκλου.';

  @override
  String get boardObjectiveNoBrief => 'Χωρίς στόχο';

  @override
  String get boardObjectiveNoBriefBody =>
      'Η διοίκηση δεν περιμένει να φτάσεις σε αυτά τα τελικά. Θα σε κρίνει με βάση τα αποτελέσματά σου.';

  @override
  String get boardObjectiveAwaitingDraw => 'Στόχος μετά την κλήρωση';

  @override
  String get boardObjectiveAwaitingDrawBody =>
      'Η διοίκηση θα θέσει αυτόν τον στόχο μόλις κληρωθούν οι όμιλοι.';
}
