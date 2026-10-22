// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Croatian (`hr`).
class AppLocalizationsHr extends AppLocalizations {
  AppLocalizationsHr([String locale = 'hr']) : super(locale);

  @override
  String get matchPreviewTitle => 'NAJAVA UTAKMICE';

  @override
  String get matchKickOff => 'Početni udarac';

  @override
  String get matchTactics => 'Taktika';

  @override
  String get matchYourXi => 'TVOJIH 11';

  @override
  String get matchHeadToHead => 'MEĐUSOBNI ODNOS';

  @override
  String matchCouldNotLoad(String error) {
    return 'Utakmica se nije mogla učitati.\n$error';
  }

  @override
  String get matchNoUpcoming => 'Nema nadolazeće utakmice.';

  @override
  String get matchUnknownNation => 'Nepoznato';

  @override
  String get matchH2hFirstMeeting => 'Prvi susret ikad';

  @override
  String get matchH2hYouLead => 'Ti vodiš u međusobnim susretima';

  @override
  String matchH2hOppEdge(String opponent) {
    return 'Prednost: $opponent';
  }

  @override
  String get matchH2hEven => 'Izjednačeno';

  @override
  String matchH2hMet(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count susreta',
      few: '$count susreta',
      one: '$count susret',
    );
    return '$_temp0';
  }

  @override
  String get matchH2hWon => 'Pobjede';

  @override
  String get matchH2hDrawn => 'Neriješeno';

  @override
  String get matchH2hLost => 'Porazi';

  @override
  String get matchDossierTitle => 'Skautsko izvješće';

  @override
  String get matchDossierForm => 'FORMA';

  @override
  String get matchDossierNoGames => 'Nema nedavnih utakmica';

  @override
  String get matchDossierKeyMen => 'KLJUČNI IGRAČI';

  @override
  String matchCouldNotContinue(String error) {
    return 'Nastavak nije uspio: $error';
  }

  @override
  String get matchSkipToFullTime => 'Preskoči do kraja utakmice';

  @override
  String get matchStatShots => 'Udarci';

  @override
  String get matchStatGoals => 'Golovi';

  @override
  String get matchStatYellowCards => 'Žuti';

  @override
  String get matchStatRedCards => 'Crveni';

  @override
  String get matchMomentum => 'INICIJATIVA';

  @override
  String get matchSwingAtk => 'NAP';

  @override
  String get matchSwingDef => 'OBR';

  @override
  String ceremonyWorldCupYear(int year) {
    return 'SVJETSKO PRVENSTVO $year';
  }

  @override
  String get ceremonyFinalsAreHere => 'ZAVRŠNICA JE OVDJE';

  @override
  String ceremonyHostedBy(String hosts) {
    return 'DOMAĆIN  $hosts';
  }

  @override
  String get ceremonyHostTbc => 'DOMAĆIN JOŠ NIJE POTVRĐEN';

  @override
  String get matchHalfTime => 'POLUVRIJEME';

  @override
  String get matchContinue => 'Nastavi';

  @override
  String get matchContinuing => 'Nastavljam…';

  @override
  String matchTacticsWithSubs(int used, int max) {
    return 'Taktika · $used/$max izmj.';
  }

  @override
  String matchTiredCount(int count) {
    return 'UMORNI ×$count';
  }

  @override
  String get matchTacticsLabel => 'TAKTIKA';

  @override
  String get teamOverallOverTime => 'UKUPNA OCJENA KROZ VRIJEME';

  @override
  String get teamOverall => 'Ukupna ocjena';

  @override
  String get teamTalkHeading => 'GOVOR U GARDEROBI';

  @override
  String get teamTalkPrompt => 'Odredi ton za drugo poluvrijeme.';

  @override
  String get teamTalkCalmLabel => 'Mirne glave';

  @override
  String get teamTalkCalmBlurb => 'Smiri momčad. Mali poticaj u svim linijama.';

  @override
  String get teamTalkEncourageLabel => 'Ohrabri';

  @override
  String get teamTalkEncourageBlurb => 'Idite naprijed i igrajte na pobjedu.';

  @override
  String get teamTalkDemandMoreLabel => 'Traži više';

  @override
  String get teamTalkDemandMoreBlurb => 'Dajte sve od sebe. Napadajte žestoko.';

  @override
  String get teamTalkPraiseLabel => 'Zbijeni redovi';

  @override
  String get teamTalkPraiseBlurb => 'Ostanite kompaktni i čuvajte što imate.';

  @override
  String get teamTalkBelieveLabel => 'Vjeruj';

  @override
  String get teamTalkBelieveBlurb =>
      'Vjerujte u sebe. Poticaj na oba kraja terena.';

  @override
  String get teamTalkFocusLabel => 'Ostani budan';

  @override
  String get teamTalkFocusBlurb =>
      'Potpuna koncentracija. Zaključajte utakmicu.';

  @override
  String get teamTalkUrgencyLabel => 'Osjećaj hitnosti';

  @override
  String get teamTalkUrgencyBlurb =>
      'Pritisnite odmah. Sve ili ništa, a otvara prostor.';

  @override
  String get teamTalkReassureLabel => 'Bez pritiska';

  @override
  String get teamTalkReassureBlurb => 'Smirite živce i držite oblik.';

  @override
  String get commonRetry => 'Pokušaj ponovno';

  @override
  String get commonSomethingWentWrong => 'Nešto je pošlo po zlu';

  @override
  String get commonCrashBox =>
      'Ovdje je nešto pošlo po zlu.\nPojedinosti su u Postavke → Dijagnostika.';

  @override
  String hubCouldNotAdvance(String error) {
    return 'Svijet se nije mogao pomaknuti dalje: $error';
  }

  @override
  String get settingsDiagnosticsTitle => 'Dijagnostika';

  @override
  String get settingsDiagnosticsBlurb =>
      'Pogreške zabilježene na ovom uređaju. Ništa se nikamo ne šalje.';

  @override
  String get settingsContactTitle => 'Kontakt';

  @override
  String get settingsContactCopied => 'Adresa kopirana.';

  @override
  String get settingsCommunityTitle => 'Zajednica';

  @override
  String get settingsDiscordSubtitle => 'Pridruži se zajednici';

  @override
  String get settingsLinkCopied => 'Poveznica kopirana.';

  @override
  String get diagnosticsEmpty =>
      'Nema zabilježenih pogrešaka. Tako i treba biti.';

  @override
  String get diagnosticsCopy => 'Kopiraj';

  @override
  String get diagnosticsCopied => 'Zapisnik kopiran u međuspremnik.';

  @override
  String get diagnosticsClear => 'Očisti';

  @override
  String get navHub => 'Početna';

  @override
  String get navSquad => 'Sastav';

  @override
  String get navStandings => 'Poredak';

  @override
  String get navCareers => 'Moja karijera';

  @override
  String get settingsTitle => 'POSTAVKE';

  @override
  String get settingsSoundHapticsTitle => 'Zvuk i vibracija';

  @override
  String get settingsSoundHapticsBlurb =>
      'Vibracija i kratki ton kod golova, početnog udarca i kraja utakmice.';

  @override
  String get settingsLanguageTitle => 'Jezik';

  @override
  String get settingsLanguageBlurb =>
      'Odaberi jezik aplikacije ili prati uređaj.';

  @override
  String get settingsLanguageSystem => 'Sustav';

  @override
  String get matchPreviewAllMeetings => 'Svi susreti';

  @override
  String get recordsMeetings => 'SUSRETI';

  @override
  String get recordsLegends => 'LEGENDE';

  @override
  String get recordsAllTimeXi => 'NAJBOLJIH 11 SVIH VREMENA';

  @override
  String get recordsHallOfFame => 'KUĆA SLAVNIH';

  @override
  String get recordsAllTimeWorld => 'SVJETSKA POVIJEST';

  @override
  String get recordsAllTimeTopScorers => 'NAJBOLJI STRIJELCI SVIH VREMENA';

  @override
  String get recordsMostCapped => 'NAJVIŠE NASTUPA';

  @override
  String get recordsMostWcStarts => 'NAJVIŠE STARTOVA NA SP';

  @override
  String get recordsMostTournaments => 'NAJVIŠE ODIGRANIH TURNIRA';

  @override
  String get recordsRecordBook => 'KNJIGA REKORDA';

  @override
  String get recordsHeadToHead => 'MEĐUSOBNI ODNOS';

  @override
  String get recordsFiercestRival => 'NAJJAČI RIVAL';

  @override
  String get recordsMostCaps => 'NAJVIŠE NASTUPA';

  @override
  String get recordsTopScorers => 'NAJBOLJI STRIJELCI';

  @override
  String get recordsMostAssists => 'NAJVIŠE ASISTENCIJA';

  @override
  String get recordsYourRecord => 'TVOJ UČINAK';

  @override
  String get callUpHome => 'DOMA';

  @override
  String get callUpAway => 'U GOSTIMA';

  @override
  String get recordsHome => 'DOMA';

  @override
  String get recordsAway => 'U GOSTIMA';

  @override
  String get recordsActive => 'AKTIVAN';

  @override
  String get recordsStillActive => 'Još igra';

  @override
  String get recordsAvg => 'prosj.';

  @override
  String get recordsSelect => 'Odaberi';

  @override
  String get recordsVs => 'vs';

  @override
  String get recordsDraws => 'Neriješeno';

  @override
  String get recordsGoalsLabel => 'Golovi';

  @override
  String get recordsBestFinish => 'Najbolji plasman';

  @override
  String get recordsNoFinalsYet => 'Još nema nastupa u završnici';

  @override
  String get recordsLongestUnbeaten => 'Najdulji niz bez poraza';

  @override
  String get recordsBiggestWin => 'Najveća pobjeda';

  @override
  String get recordsSeeAllMeetings => 'Prikaži sve susrete';

  @override
  String get recordsSaveNotFound => 'Spremljena igra nije pronađena.';

  @override
  String get recordsNoMatches => 'Nema rezultata.';

  @override
  String get recordsSearchPlayerOrNation => 'Traži igrača ili zemlju';

  @override
  String get recordsSearchNation => 'Traži zemlju';

  @override
  String get recordsPickTwoDifferent => 'Odaberi dvije različite zemlje.';

  @override
  String get recordsPlayToBuildRecord =>
      'Odigraj nekoliko utakmica i ovdje će se graditi tvoj učinak protiv svakog protivnika.';

  @override
  String get recordsTapOpponent => 'Dodirni protivnika za potpuni pregled.';

  @override
  String get recordsEdgeUpperHand => 'Imaš prednost';

  @override
  String get recordsEdgeTheirNumber => 'Oni te imaju na piku';

  @override
  String get recordsEdgeEven => 'Izjednačeno';

  @override
  String get recordsAllTimeWorldSubtitle =>
      'Svjetski strijelci i rekorderi po nastupima, svaka zemlja';

  @override
  String get recordsHeadToHeadSubtitle =>
      'Usporedi povijesni učinak bilo koje dvije zemlje';

  @override
  String get recordsLegendsSubtitle =>
      'Najboljih 11 svih vremena i kuća slavnih';

  @override
  String get recordsUnitGoals => 'golova';

  @override
  String get recordsUnitCaps => 'nastupa';

  @override
  String get recordsUnitStarts => 'startova';

  @override
  String get recordsUnitCups => 'turnira';

  @override
  String get recordsUnitAssists => 'asistencija';

  @override
  String recordsCapsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nastupa',
      few: '$count nastupa',
      one: '$count nastup',
    );
    return '$_temp0';
  }

  @override
  String recordsGoalsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count golova',
      few: '$count gola',
      one: '$count gol',
    );
    return '$_temp0';
  }

  @override
  String recordsAssistsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count asistencija',
      few: '$count asistencije',
      one: '$count asistencija',
    );
    return '$_temp0';
  }

  @override
  String recordsMotmCount(int count) {
    return '$count × igrač utakmice';
  }

  @override
  String recordsMatchesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count utakmica',
      few: '$count utakmice',
      one: '$count utakmica',
    );
    return '$_temp0';
  }

  @override
  String recordsMeetingsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count susreta',
      few: '$count susreta',
      one: '$count susret',
    );
    return '$_temp0';
  }

  @override
  String recordsCodeWins(String code) {
    return 'Pobjede: $code';
  }

  @override
  String recordsMeetingsWdl(int meetings, int wins, int draws, int losses) {
    String _temp0 = intl.Intl.pluralLogic(
      meetings,
      locale: localeName,
      other: '$meetings susreta',
      few: '$meetings susreta',
      one: '$meetings susret',
    );
    return '$_temp0 · ${wins}P ${draws}N ${losses}I';
  }

  @override
  String recordsWdl(int wins, int draws, int losses) {
    return '${wins}P ${draws}N ${losses}I';
  }

  @override
  String recordsRivalLine(int meetings, String record, String edge) {
    String _temp0 = intl.Intl.pluralLogic(
      meetings,
      locale: localeName,
      other: '$meetings susreta',
      few: '$meetings susreta',
      one: '$meetings susret',
    );
    return '$_temp0 · $record · $edge';
  }

  @override
  String recordsNeverMet(String a, String b) {
    return '$a i $b se u ovoj igri još nikad nisu susreli.';
  }

  @override
  String tacticsSentOffNote(String names) {
    return 'Isključeni: $names. Nema zamjene, pa igraš s igračem manje.';
  }

  @override
  String tacticsNeedFitPlayers(int required, int have) {
    return 'Potrebno $required raspoloživih ($have spremnih)';
  }

  @override
  String tacticsMissesOfCamp(int missed, int total) {
    return 'Propušta $missed/$total';
  }

  @override
  String get tacticsOutForWholeCamp => 'Odsutan cijelo ovo okupljanje';

  @override
  String get rankingCentreOnMe => 'Centriraj na moju zemlju';

  @override
  String get recordsAfterExtraTime => 'nakon prod.';

  @override
  String recordsOnPenalties(int a, int b) {
    return '$a–$b na pen.';
  }

  @override
  String recordsVersus(String a, String b) {
    return '$a vs $b';
  }

  @override
  String recordsPlayedScore(int played, int gf, int ga) {
    return '$played odigrano · $gf–$ga';
  }

  @override
  String recordsBiggestWinValue(int gf, int ga, String opp) {
    return '$gf–$ga vs $opp';
  }

  @override
  String recordsCouldNotLoad(String error) {
    return 'Učitavanje nije uspjelo.\n$error';
  }

  @override
  String recordsCouldNotLoadLegends(String error) {
    return 'Legende se nisu mogle učitati.\n$error';
  }

  @override
  String recordsCouldNotLoadRecords(String error) {
    return 'Rekordi se nisu mogli učitati.\n$error';
  }

  @override
  String recordsCouldNotLoadNations(String error) {
    return 'Zemlje se nisu mogle učitati.\n$error';
  }

  @override
  String recordsCouldNotLoadYourRecord(String error) {
    return 'Tvoj učinak se nije mogao učitati.\n$error';
  }

  @override
  String recordsCouldNotLoadRecord(String error) {
    return 'Rekord se nije mogao učitati.\n$error';
  }

  @override
  String recordsNoLegends(String nation) {
    return 'Još nema legendi. Odigraj nekoliko kampanja i ovdje će se pojaviti velikani reprezentacije: $nation.';
  }

  @override
  String recordsGreatestSide(String nation) {
    return 'Najbolja momčad koju je reprezentacija $nation ikad mogla postaviti.';
  }

  @override
  String get recordsNoWorldHistory =>
      'Svijet još nema povijest. Odigraj nekoliko kampanja i ovdje će se pojaviti velikani svih vremena.';

  @override
  String recordsPlayToWriteHistory(String nation) {
    return 'Odigraj nekoliko utakmica i počni pisati povijest: $nation.';
  }

  @override
  String get tacticsLineGk => 'VR';

  @override
  String get tacticsLineDef => 'BR';

  @override
  String get tacticsLineMid => 'VE';

  @override
  String get tacticsLineFwd => 'NA';

  @override
  String get tacticsGoalkeepers => 'VRATARI';

  @override
  String get tacticsDefenders => 'BRANIČI';

  @override
  String get tacticsMidfielders => 'VEZNI IGRAČI';

  @override
  String get tacticsForwards => 'NAPADAČI';

  @override
  String get tacticsCallUpsTitle => 'POZIVI';

  @override
  String tacticsPickAtLeastPlayers(int min) {
    return 'Odaberi najmanje $min igrača.';
  }

  @override
  String tacticsCouldNotLoadSquad(String error) {
    return 'Sastav se nije mogao učitati.\n$error';
  }

  @override
  String get tacticsNoSquad => 'Nema sastava.';

  @override
  String tacticsSquadCount(int count, int max) {
    return 'SASTAV · $count/$max';
  }

  @override
  String tacticsMinMax(int min, int max) {
    return 'Min $min · Maks $max';
  }

  @override
  String get tacticsBestQuality => 'Najbolja kvaliteta';

  @override
  String get tacticsPreviousSquad => 'Prethodni sastav';

  @override
  String get tacticsSquadLockedBack => 'Natrag (sastav zaključan)';

  @override
  String get tacticsConfirmSquad => 'Potvrdi sastav';

  @override
  String tacticsSquadFullMax(int max) {
    return 'Sastav je pun (maks $max)';
  }

  @override
  String get tacticsSquadLocked => 'SASTAV ZAKLJUČAN';

  @override
  String get tacticsNominationOpen => 'PRIJAVA JE OTVORENA. ODABERI SASTAV';

  @override
  String get tacticsSquadFixedBlurb =>
      'Ovaj je sastav utvrđen za utakmice ispod. Ponovno ga odaberi prije sljedećeg roka za prijavu.';

  @override
  String get tacticsSquadWillPlayBlurb =>
      'Ovaj će sastav igrati utakmice ispod.';

  @override
  String get tacticsUnknown => 'Nepoznato';

  @override
  String tacticsAgeValue(int age, String value) {
    return 'Dob $age · $value';
  }

  @override
  String get tacticsFatigueExhausted => 'Iscrpljen';

  @override
  String get tacticsFatigueTired => 'Umoran';

  @override
  String get tacticsFatigueMatchLegs => 'Utakmica u nogama';

  @override
  String tacticsTooManySubs(int max) {
    return 'Previše izmjena (maks $max).';
  }

  @override
  String tacticsMinuteTitle(int minute) {
    return 'TAKTIKA · $minute\'';
  }

  @override
  String get tacticsApply => 'PRIMIJENI';

  @override
  String get tacticsTabLineupSubs => 'POSTAVA I IZMJENE';

  @override
  String get tacticsTabTactics => 'TAKTIKA';

  @override
  String get squadLineKeepers => 'VRATARI';

  @override
  String get squadLineDefenders => 'OBRANA';

  @override
  String get squadLineMidfielders => 'VEZNI RED';

  @override
  String get squadLineForwards => 'NAPAD';

  @override
  String get squadStatXiRating => 'Ocjena 11';

  @override
  String get squadStatAvgAge => 'Prosj. dob';

  @override
  String get squadStatSize => 'Sastav';

  @override
  String get squadStatUnavailable => 'Odsutni';

  @override
  String get squadDepthTitle => 'DUBINA PO LINIJAMA';

  @override
  String squadAgeShort(int age) {
    return '$age g.';
  }

  @override
  String get tacticsTabOtherPositions => 'DRUGA MJESTA';

  @override
  String get tacticsOutOfPositionNote => 'Izvan pozicije';

  @override
  String get tacticsNobodyElse => 'Nema koga drugog isprobati.';

  @override
  String get tacticsPickSomebodyFirst =>
      'Odaberi tko izlazi, a ostatak klupe pojavit će se ovdje, s ocjenom koju bi imali na ovom mjestu.';

  @override
  String get tacticsTabSuitable => 'PRIKLADNI';

  @override
  String get tacticsTabOnPitch => 'NA TERENU';

  @override
  String tacticsSectionSuitable(int count) {
    return 'PRIKLADNI · $count';
  }

  @override
  String get tacticsNobodySuits =>
      'Nitko s klupe prirodno ne odgovara ovom mjestu, pa su ovdje svi.';

  @override
  String tacticsSectionOnPitch(int count, int max) {
    return 'NA TERENU · $count/$max';
  }

  @override
  String tacticsSectionAvailable(int count) {
    return 'RASPOLOŽIVI · $count';
  }

  @override
  String get tacticsRowStarted => 'Počeo';

  @override
  String tacticsRowCameOn(int minute) {
    return 'Ušao u $minute\'';
  }

  @override
  String get tacticsRowSubstitute => 'Ušao';

  @override
  String get tacticsEnergyLabel => 'ENERGIJA';

  @override
  String tacticsPickReplacementFor(String name) {
    return 'Dodirni zamjenu za: $name, ili ga dodirni ponovno za odustajanje.';
  }

  @override
  String get tacticsSlotLostToRedCard =>
      'Crveni karton oduzeo ti je ovo mjesto. Povuci suigrača ovdje da premjestiš prazninu.';

  @override
  String get tacticsSentOffShort => 'ISKLJUČEN';

  @override
  String tacticsSubsUsed(int used, int max) {
    return 'IZMJENE · $used/$max';
  }

  @override
  String get tacticsDragSubOn =>
      'Dodirni igrača na terenu da ga izvadiš ili drži i povuci zamjenu na njega.';

  @override
  String get tacticsNoSubs => 'Nema raspoloživih zamjena.';

  @override
  String get tacticsChooseShape => 'ODABERI FORMACIJU';

  @override
  String get tacticsFormation => 'FORMACIJA';

  @override
  String get tacticsInstructions => 'UPUTE';

  @override
  String get tacticsDrilling => 'UVJEŽBANOST';

  @override
  String get tacticsDrillingUnplayed => 'NEIGRANO';

  @override
  String get tacticsDrillingNew => 'NOVO';

  @override
  String get tacticsDrillingSettling => 'SLAŽE SE';

  @override
  String get tacticsDrillingDrilled => 'UIGRANO';

  @override
  String get tacticsInstrMentality => 'Mentalitet';

  @override
  String get tacticsInstrDefensive => 'Defanzivno';

  @override
  String get tacticsInstrAttacking => 'Napadački';

  @override
  String get tacticsInstrPressing => 'Presing';

  @override
  String get tacticsInstrLowBlock => 'Niski blok';

  @override
  String get tacticsInstrHighPress => 'Visoki presing';

  @override
  String get tacticsInstrTempo => 'Tempo';

  @override
  String get tacticsInstrPatient => 'Strpljivo';

  @override
  String get tacticsInstrFast => 'Brzo';

  @override
  String get tacticsInstrWidth => 'Širina';

  @override
  String get tacticsInstrNarrow => 'Usko';

  @override
  String get tacticsInstrWide => 'Široko';

  @override
  String get tacticsInstrDefLine => 'Obr. linija';

  @override
  String get tacticsInstrDefensiveLine => 'Obrambena linija';

  @override
  String get tacticsInstrDeep => 'Duboko';

  @override
  String get tacticsInstrHigh => 'Visoko';

  @override
  String get tacticsInstrDirectness => 'Direktnost';

  @override
  String get tacticsInstrPossession => 'Posjed lopte';

  @override
  String get tacticsInstrDirect => 'Direktno';

  @override
  String get tacticsPickGoalkeeper => 'ODABERI VRATARA';

  @override
  String get tacticsPickLeftBack => 'ODABERI LIJEVOG BEKA';

  @override
  String get tacticsPickCentreBack => 'ODABERI SREDIŠNJEG BRANIČA';

  @override
  String get tacticsPickRightBack => 'ODABERI DESNOG BEKA';

  @override
  String get tacticsPickDefensiveMid => 'ODABERI DEFANZIVNOG VEZNOG';

  @override
  String get tacticsPickCentralMid => 'ODABERI SREDIŠNJEG VEZNOG';

  @override
  String get tacticsPickAttackingMid => 'ODABERI OFANZIVNOG VEZNOG';

  @override
  String get tacticsPickLeftMid => 'ODABERI LIJEVOG VEZNOG';

  @override
  String get tacticsPickRightMid => 'ODABERI DESNOG VEZNOG';

  @override
  String get tacticsPickLeftWing => 'ODABERI LIJEVO KRILO';

  @override
  String get tacticsPickRightWing => 'ODABERI DESNO KRILO';

  @override
  String get tacticsPickStriker => 'ODABERI NAPADAČA';

  @override
  String tacticsRoleOutOfPosition(String role) {
    return '$role · izvan pozicije';
  }

  @override
  String tacticsAgeOnly(int age) {
    return 'Dob $age';
  }

  @override
  String tacticsRoleAge(String role, int age) {
    return '$role · Dob $age';
  }

  @override
  String get tacticsOn => 'NA TERENU';

  @override
  String get tacticsSquad => 'SASTAV';

  @override
  String get tacticsTabLineup => 'POSTAVA';

  @override
  String get tacticsTabInstructions => 'UPUTE';

  @override
  String get tacticsTabRoles => 'ULOGE';

  @override
  String get tacticsTabSetPieces => 'STAJALICE';

  @override
  String get tacticsTabRolesSetPieces => 'ULOGE I STAJALICE';

  @override
  String get tacticsRolesSetPiecesBlurb =>
      'Daj svakom igraču iz početne postave ulogu. Dodirni oznaku za jedanaesterac (⚽) ili slobodni udarac (▲) da odrediš izvođača.';

  @override
  String get tacticsTooltipCallUps => 'Pozivi';

  @override
  String get tacticsTooltipPresets => 'Predlošci taktike';

  @override
  String get tacticsTooltipInstructions => 'Upute';

  @override
  String get tacticsNoTacticSet => 'Taktika nije postavljena.';

  @override
  String tacticsReplaceStarters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ZAMIJENI $count IGRAČA IZ POČETNE POSTAVE',
      few: 'ZAMIJENI $count IGRAČA IZ POČETNE POSTAVE',
      one: 'ZAMIJENI $count IGRAČA IZ POČETNE POSTAVE',
    );
    return '$_temp0';
  }

  @override
  String tacticsPlayerOut(String name, String reason) {
    return '$name: $reason';
  }

  @override
  String get tacticsOut => 'Odsutan';

  @override
  String get tacticsTapSpotReplace =>
      'Dodirni njegovo mjesto na terenu za odabir zamjene.';

  @override
  String get tacticsTapOrDrag =>
      'Dodirni igrača da ga zamijeniš ili ga drži i povuci da ga premjestiš.';

  @override
  String get tacticsPlayerRoles => 'ULOGE IGRAČA';

  @override
  String get tacticsRolesBlurb =>
      'Daj igraču zadatak: lovac na golove, razigravač, igrač za duge lopte. Određuje tko zabija, a tko stvara.';

  @override
  String get tacticsSetPieceTakers => 'IZVOĐAČI STAJALICA';

  @override
  String get tacticsSetPieceBlurb =>
      'Tko izvodi jedanaesterce i mrtve lopte, ili prepusti to najprikladnijem igraču.';

  @override
  String get tacticsTakerAuto => 'Automatski';

  @override
  String get tacticsTakerQuickPick => 'Najbolji izvođači';

  @override
  String get tacticsPenalties => 'Jedanaesterci';

  @override
  String get tacticsCornersFreeKicks => 'Korneri i slobodni udarci';

  @override
  String get tacticsSkillFin => 'ZAV';

  @override
  String get tacticsSkillPas => 'DOD';

  @override
  String tacticsRolePlayer(String name) {
    return 'ULOGA · $name';
  }

  @override
  String get tacticsPenaltyTaker => 'IZVOĐAČ JEDANAESTERACA';

  @override
  String get tacticsCornerFreeKickTaker =>
      'IZVOĐAČ KORNERA I SLOBODNIH UDARACA';

  @override
  String get tacticsAutomatic => 'Automatski';

  @override
  String get tacticsLetBestSuited => 'Neka izvodi najprikladniji igrač.';

  @override
  String get tacticsInXi => 'U POSTAVI';

  @override
  String get tacticsTeamInstructions => 'UPUTE MOMČADI';

  @override
  String get tacticsTeamInstructionsBlurb =>
      'Odredi kako igra tvoja momčad. Svaki regulator pomiče cijelu ekipu.';

  @override
  String tacticsSavedPreset(String name) {
    return 'Spremljeno: „$name“';
  }

  @override
  String tacticsAppliedPreset(String name) {
    return 'Primijenjeno: „$name“';
  }

  @override
  String get tacticsTacticPresets => 'PREDLOŠCI TAKTIKE';

  @override
  String get tacticsPresetsBlurb =>
      'Spremi ovu formaciju kao stil za višekratnu uporabu ili primijeni ranije spremljenu.';

  @override
  String get tacticsSaveCurrentTactic => 'Spremi trenutnu taktiku';

  @override
  String tacticsCouldNotLoadPresets(String error) {
    return 'Predlošci se nisu mogli učitati.\n$error';
  }

  @override
  String get tacticsNoPresetsYet =>
      'Još nema predložaka. Dodirni „Spremi trenutnu taktiku“ da spremiš ovu postavu kao stil za višekratnu uporabu.';

  @override
  String get tacticsNameThisTactic => 'Imenuj ovu taktiku';

  @override
  String get tacticsNameHint => 'npr. Visoki presing 4-3-3';

  @override
  String get tacticsCancel => 'Odustani';

  @override
  String get tacticsSave => 'Spremi';

  @override
  String get tacticsTapToAssign => 'Dodirni za dodjelu';

  @override
  String get tacticsHoldDragSub =>
      'Drži zamjenu pa je povuci na igrača da ga zamijeniš.';

  @override
  String get hubContinue => 'Nastavi';

  @override
  String get hubBrackets => 'Kostur';

  @override
  String hubCouldNotLoad(String error) {
    return 'Učitavanje nije uspjelo.\n$error';
  }

  @override
  String hubCouldNotLoadFinances(String error) {
    return 'Financije se nisu mogle učitati.\n$error';
  }

  @override
  String hubCouldNotLoadSave(String error) {
    return 'Spremljena igra se nije mogla učitati.\n$error';
  }

  @override
  String get hubSaveNotFound => 'Spremljena igra nije pronađena.';

  @override
  String get hubUnknown => 'Nepoznato';

  @override
  String hubWorldChampionsYear(int year) {
    return 'SVJETSKI PRVACI $year';
  }

  @override
  String get hubCycleComplete => 'Ciklus je završen.';

  @override
  String get hubYourJob => 'TVOJ POSAO';

  @override
  String get hubStayProject => 'Ostani i nastavi svoj projekt';

  @override
  String get hubChooseNextJob => 'ODABERI SLJEDEĆI POSAO';

  @override
  String get hubOffersOnTable => 'PONUDE NA STOLU';

  @override
  String hubOfferSubtitle(String tier, int position) {
    return '$tier · svijet #$position';
  }

  @override
  String hubContinueWith(String nation) {
    return 'Nastavi: $nation';
  }

  @override
  String get hubYourNation => 'tvoja zemlja';

  @override
  String get hubTakeTheJob => 'Prihvati posao';

  @override
  String get hubFederationFinances => 'FINANCIJE SAVEZA';

  @override
  String get hubBudgetIntro =>
      'Tvoj prvi zadatak u sljedećem ciklusu je odrediti proračun saveza i rasporediti ga po odjelima.';

  @override
  String get hubStarting => 'Pokrećem…';

  @override
  String get hubBeginNextCycle => 'Započni sljedeći ciklus';

  @override
  String get hubContinueCareer => 'Nastavi karijeru';

  @override
  String get hubBackToSaves => 'Natrag na spremljene igre';

  @override
  String get hubOpeningBalance => 'Početno stanje';

  @override
  String get hubCentralFunding => 'Središnje financiranje';

  @override
  String get hubPrizeMoney => 'Novčane nagrade';

  @override
  String get hubCommercialReturn => 'Komercijalni prihodi';

  @override
  String get hubAvailableToInvest => 'Raspoloživo za ulaganje';

  @override
  String hubReputation(String label, int rep) {
    return 'Ugled: $label ($rep)';
  }

  @override
  String get hubNationalHero => 'Nacionalni junak';

  @override
  String get hubFinal => 'Finale';

  @override
  String get hubStageRoundOf32 => 'Šesnaestina finala';

  @override
  String get hubStageThirdPlace => 'Utakmica za treće mjesto';

  @override
  String get hubEventAdvanceWorld => 'Pomakni svijet dalje';

  @override
  String hubEventStartCycle(int year) {
    return 'Započni ciklus $year';
  }

  @override
  String hubEventWorldChampions(String nation) {
    return 'Svjetski prvaci: $nation';
  }

  @override
  String get hubEventSetBudget => 'Odredi proračun saveza';

  @override
  String get hubEventSetBudgetSub =>
      'Rasporedi sredstva ciklusa prije početka sezone';

  @override
  String get hubEventNaturalization => 'Pregledaj ponudu za naturalizaciju';

  @override
  String get hubEventNaturalizationSub =>
      'Strani igrač želi prijeći pod tvoju zastavu';

  @override
  String get hubEventCampaignVerdict => 'Kampanja završena: pogledaj presudu';

  @override
  String get hubEventCampaignComplete => 'Kampanja završena';

  @override
  String get hubEventIntercontinentalPlayoff => 'Interkontinentalni play-off';

  @override
  String get hubEventWatchWcDraw => 'Gledaj ždrijeb Svjetskog prvenstva';

  @override
  String get hubEventWorldCupHere => 'Svjetsko prvenstvo je tu';

  @override
  String get hubEventWatchFinalsDraw => 'Gledaj ždrijeb završnice';

  @override
  String get hubEventFinalsHere => 'Završnica je tu';

  @override
  String get hubEventPlayWcRound => 'Odigraj sljedeće kolo Svjetskog prvenstva';

  @override
  String hubEventPlayCupMatch(String cup) {
    return 'Odigraj sljedeću utakmicu: $cup';
  }

  @override
  String get hubEventPlayNationsCupMatch =>
      'Odigraj sljedeću utakmicu natjecanja Nations Cup';

  @override
  String get hubEventWatchNationsCupDraw =>
      'Gledaj ždrijeb natjecanja Nations Cup';

  @override
  String get hubEventWatchHostSelection => 'Gledaj izbor domaćina';

  @override
  String get hubEventWatchQualifyingDraw => 'Gledaj ždrijeb kvalifikacija';

  @override
  String get hubEventWatchWcHostSelection =>
      'Gledaj izbor domaćina Svjetskog prvenstva';

  @override
  String get hubEventWatchWcQualifyingDraw =>
      'Gledaj ždrijeb kvalifikacija za Svjetsko prvenstvo';

  @override
  String get hubEventArrangeFriendlies => 'Dogovori prijateljske utakmice';

  @override
  String hubEventFriendliesSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Još nisi popunio $count otvorenih termina za prijateljske utakmice',
      few: 'Još nisi popunio $count otvorena termina za prijateljske utakmice',
      one: 'Još nisi popunio $count otvoreni termin za prijateljske utakmice',
    );
    return '$_temp0';
  }

  @override
  String get hubEventReshapeXi => 'Preoblikuj početnih 11';

  @override
  String hubEventReshapeOutSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count igrača iz tvojih 11 ne može igrati (kažnjeni ili ozlijeđeni). Odaberi zamjene',
      few:
          '$count igrača iz tvojih 11 ne mogu igrati (kažnjeni ili ozlijeđeni). Odaberi zamjene',
      one:
          '$count igrač iz tvojih 11 ne može igrati (kažnjen ili ozlijeđen). Odaberi zamjenu',
    );
    return '$_temp0';
  }

  @override
  String hubEventReshapeShortSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tvojih početnih 11 nije potpuno. Popuni slobodna mjesta',
      few: 'Tvojih početnih 11 nije potpuno. Popuni slobodna mjesta',
      one: 'Tvojih početnih 11 nije potpuno. Popuni slobodno mjesto',
    );
    return '$_temp0';
  }

  @override
  String hubEventPlayOpponent(String opponent) {
    return 'Odigraj utakmicu: $opponent';
  }

  @override
  String get hubEventContinentalFinalsFallback => 'kontinentalna završnica';

  @override
  String get hubCallUpFriendlies => 'Objavi sastav za prijateljske utakmice';

  @override
  String get hubCallUpRequalify => 'Ponovno objavi sastav za kvalifikacije';

  @override
  String get hubCallUpWorldCup => 'Objavi sastav za Svjetsko prvenstvo';

  @override
  String get hubCallUpFinals => 'Objavi sastav za završnicu';

  @override
  String get hubCallUpNationsCup => 'Objavi sastav za Nations Cup';

  @override
  String get hubCallUpQualifying => 'Objavi sastav za kvalifikacije';

  @override
  String get hubCallUpGeneric => 'Objavi sastav';

  @override
  String get hubHost => 'Domaćin';

  @override
  String get hubGoldenBoot => 'Zlatna kopačka';

  @override
  String hubGoldenBootValue(String name, int goals) {
    String _temp0 = intl.Intl.pluralLogic(
      goals,
      locale: localeName,
      other: '$goals golova',
      few: '$goals gola',
      one: '$goals gol',
    );
    return '$name · $_temp0';
  }

  @override
  String get hubPens => '(pen.)';

  @override
  String get hubNationalHub => 'SJEDIŠTE SAVEZA';

  @override
  String get hubMessages => 'Poruke';

  @override
  String get hubWorldChampions => 'SVJETSKI PRVACI';

  @override
  String get hubViewBracket => 'Prikaži kostur ›';

  @override
  String get hubBoardDelighted => 'Oduševljen';

  @override
  String get hubBoardPleased => 'Zadovoljan';

  @override
  String get hubBoardExpectingMore => 'Očekuje više';

  @override
  String get hubBoardConcerned => 'Zabrinut';

  @override
  String get hubBoardJobAtRisk => 'Posao u opasnosti';

  @override
  String get hubBoard => 'ODBOR';

  @override
  String hubBoardObjective(String label) {
    return 'Cilj odbora: $label';
  }

  @override
  String hubObjectiveMet(String result) {
    return 'ISPUNJENO · $result';
  }

  @override
  String hubObjectiveMissed(String result) {
    return 'PROPUŠTENO · $result';
  }

  @override
  String get hubNoMoreFixtures => 'Nema više utakmica u ovom ciklusu.';

  @override
  String get hubVs => 'VS';

  @override
  String hubWorldRank(int rank) {
    return '#$rank';
  }

  @override
  String get hubWorldRankLabel => 'Svjetska ljestvica';

  @override
  String get hubSquadStatus => 'STANJE SASTAVA';

  @override
  String hubPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count igrača',
      few: '$count igrača',
      one: '$count igrač',
    );
    return '$_temp0';
  }

  @override
  String get hubAvgRating => 'Prosj. ocjena';

  @override
  String get hubMorale => 'Moral';

  @override
  String get hubManageTeam => 'Uredi momčad';

  @override
  String get hubGroupsToBeDrawn =>
      'Skupine tek treba izvući. Gledaj ždrijeb da ih otkriješ.';

  @override
  String hubGroupName(String name) {
    return 'SKUPINA $name';
  }

  @override
  String get hubTblTeam => 'MOMČAD';

  @override
  String get hubTblP => 'U';

  @override
  String get hubTblGd => 'GR';

  @override
  String get hubTblPts => 'B';

  @override
  String get homeSettings => 'Postavke';

  @override
  String get homeLeadTheNation => 'VODI REPREZENTACIJU';

  @override
  String get homeYourNation => 'tvoja zemlja';

  @override
  String get homeNewGame => 'Nova igra';

  @override
  String get homeAllSaves => 'Sve spremljene igre';

  @override
  String get homeLoadGame => 'Učitaj igru';

  @override
  String get homeContinue => 'NASTAVI';

  @override
  String homeRoadToWorldCup(String date, int year) {
    return '$date · Put do Svjetskog prvenstva $year';
  }

  @override
  String get careerManageSaves => 'Upravljaj spremljenim igrama';

  @override
  String get careerNewGameTitle => 'NOVA IGRA';

  @override
  String careerCouldNotLoadNation(String error) {
    return 'Zemlja se nije mogla učitati.\n$error';
  }

  @override
  String get careerNationNotFound => 'Zemlja nije pronađena.';

  @override
  String careerWorldRankNum(int rank) {
    return 'SVJETSKA LJESTVICA #$rank';
  }

  @override
  String get careerManagerName => 'Ime izbornika';

  @override
  String get careerManagerNameHint => 'npr. Zlatko Dalić';

  @override
  String get careerBeginsBlurb =>
      'Tvoja karijera počinje u rujnu 2026., na putu prema Svjetskom prvenstvu 2030.';

  @override
  String get careerFreeCycleNote =>
      'Besplatno za jedan cijeli četverogodišnji ciklus: kvalifikacije, kontinentalno prvenstvo i Svjetsko prvenstvo, na dva spremljena mjesta. Nakon toga jedna uplata otključava beskonačne cikluse.';

  @override
  String get careerStartCareer => 'Započni karijeru';

  @override
  String get careersTitle => 'KARIJERE';

  @override
  String get careerManagerCareer => 'Izbornička karijera';

  @override
  String get careerManagerCareerSubtitle =>
      'Svaki ciklus koji si vodio i tvoj ukupni učinak';

  @override
  String get careerSummaryTitle => 'Sažetak karijere';

  @override
  String get careerSummarySubtitle =>
      'Tvoja vitrina s trofejima i izborički učinak';

  @override
  String get careerAchievements => 'Postignuća';

  @override
  String get careerAchievementsSubtitle =>
      'Prekretnice, naslovi i zadovoljstvo odbora';

  @override
  String get careerChallenges => 'Izazovi';

  @override
  String get careerChallengesSubtitle => 'Brutalni izazovi za cijelu karijeru';

  @override
  String get careerTeamRecords => 'Rekordi momčadi';

  @override
  String get careerTeamRecordsSubtitle =>
      'Najbolji strijelci i broj nastupa svih vremena';

  @override
  String get careerMyMatches => 'Moje utakmice';

  @override
  String get careerMyMatchesSubtitle => 'Svaki rezultat i nadolazeća utakmica';

  @override
  String get careerTitle => 'KARIJERA';

  @override
  String careerCouldNotLoadCareer(String error) {
    return 'Karijera se nije mogla učitati.\n$error';
  }

  @override
  String get careerNoCareer => 'Nema karijere.';

  @override
  String get careerTrophyCabinet => 'VITRINA S TROFEJIMA';

  @override
  String get careerTournamentHistory => 'POVIJEST TURNIRA';

  @override
  String get careerNoTournamentsYet => 'Još nije završen nijedan turnir.';

  @override
  String get careerTeamFallback => 'Momčad';

  @override
  String careerWorldNum(int rank) {
    return 'SVIJET #$rank';
  }

  @override
  String careerPointsNum(int points) {
    return '$points BOD.';
  }

  @override
  String careerSeasonNum(int season) {
    return 'SEZONA $season';
  }

  @override
  String get careerStatPlayedShort => 'U';

  @override
  String get careerStatsHeading => 'U BROJKAMA';

  @override
  String get careerStatsWinRate => 'Postotak pobjeda';

  @override
  String get careerStatsGoalsFor => 'Dani golovi';

  @override
  String get careerStatsGoalsAgainst => 'Primljeni golovi';

  @override
  String get careerStatsGoalDiff => 'Gol-razlika';

  @override
  String get careerStatsCleanSheets => 'Mreža netaknuta';

  @override
  String get careerStatsBiggestWin => 'Najveća pobjeda';

  @override
  String get careerStatsWinStreak => 'Niz pobjeda';

  @override
  String get careerStatsUnbeaten => 'Niz bez poraza';

  @override
  String get careerStatsShootouts => 'Raspucavanja';

  @override
  String get careerStatsHatTricks => 'Hat-tricki';

  @override
  String get careerStatsMotms => 'Igrač utakmice';

  @override
  String get careerStatsBestRating => 'Najbolja ocjena';

  @override
  String get careerStatWonShort => 'P';

  @override
  String get careerStatDrawnShort => 'N';

  @override
  String get careerStatLostShort => 'I';

  @override
  String get careerStatGoalsForShort => 'DG';

  @override
  String get careerStatGoalsAgainstShort => 'PG';

  @override
  String get careerStatGoalDiffShort => 'GR';

  @override
  String get careerNoSilverware => 'Još nema trofeja. Idi osvojiti jedan.';

  @override
  String get careerMedalGold => 'ZLATO';

  @override
  String get careerMedalSilver => 'SREBRO';

  @override
  String get careerMedalBronze => 'BRONCA';

  @override
  String careerWinnersName(String name) {
    return 'Pobjednik: $name';
  }

  @override
  String get careerSavesTitle => 'SPREMLJENE IGRE';

  @override
  String careerCouldNotLoadSaves(String error) {
    return 'Spremljene igre nisu se mogle učitati.\n$error';
  }

  @override
  String careerSlotsCount(int used, int limit) {
    return 'MJESTA  $used/$limit';
  }

  @override
  String get careerThisSave => 'ova igra';

  @override
  String get careerSlotsFull => 'Sva mjesta su zauzeta';

  @override
  String careerSlotsUsed(int used) {
    return 'MJESTA  $used';
  }

  @override
  String get careerSlotsUnlockMore => 'Otključaj više mjesta';

  @override
  String get careerSlotsKeepNote =>
      'Svaka spremljena igra koju već imaš ostaje igriva. Otključavanje treba samo za novu.';

  @override
  String get careerNewGame => 'Nova igra';

  @override
  String get careerDeleteSaveTitle => 'Izbrisati spremljenu igru?';

  @override
  String careerDeleteSaveBody(String label) {
    return 'Ovo trajno briše tvoju karijeru: $label.';
  }

  @override
  String get careerCancel => 'Odustani';

  @override
  String get careerDelete => 'Izbriši';

  @override
  String get careerNoSavesYet =>
      'Još nema spremljenih igara.\nZapočni novu igru i vodi reprezentaciju.';

  @override
  String get careerUnknownNation => 'Nepoznato';

  @override
  String careerPlayedMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String careerPlayedHours(int hours, int minutes) {
    return '$hours h $minutes min';
  }

  @override
  String careerLastPlayed(String when) {
    return 'Zadnje igrano: $when';
  }

  @override
  String get careerJustNow => 'upravo sad';

  @override
  String get careerYesterday => 'jučer';

  @override
  String careerMinutesAgo(int n) {
    return 'prije $n min';
  }

  @override
  String careerHoursAgo(int n) {
    return 'prije $n h';
  }

  @override
  String careerDaysAgo(int n) {
    return 'prije $n d';
  }

  @override
  String careerRoadToWorldCup(int year) {
    return 'Put do Svjetskog prvenstva $year';
  }

  @override
  String get careerManagerCareerTitle => 'IZBORNIČKA KARIJERA';

  @override
  String careerCouldNotLoad(String error) {
    return 'Učitavanje nije uspjelo.\n$error';
  }

  @override
  String get careerCycleByCycle => 'CIKLUS PO CIKLUS';

  @override
  String careerCyclesNationsLed(int cycles, int nations) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles ciklusa',
      few: '$cycles ciklusa',
      one: '$cycles ciklus',
    );
    String _temp1 = intl.Intl.pluralLogic(
      nations,
      locale: localeName,
      other: '$nations vođenih zemalja',
      few: '$nations vođene zemlje',
      one: '$nations vođena zemlja',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get careerStatTitles => 'Naslovi';

  @override
  String get careerStatPlayed => 'Odigrano';

  @override
  String get careerStatWon => 'Pobjede';

  @override
  String get careerStatDrawn => 'Neriješeno';

  @override
  String get careerStatLost => 'Porazi';

  @override
  String careerGoalsWinRate(
    int goalsFor,
    int goalsAgainst,
    String gd,
    int winRate,
  ) {
    return 'Golovi $goalsFor–$goalsAgainst  ($gd)  ·  Postotak pobjeda $winRate%';
  }

  @override
  String get careerRecordResults => 'REKORDNI REZULTATI';

  @override
  String get careerBestWin => 'Najbolja pobjeda';

  @override
  String get careerWorstDefeat => 'Najgori poraz';

  @override
  String careerVsOpponentDate(String opponent, String date) {
    return 'protiv $opponent · $date';
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
    return '${won}P ${drawn}N ${lost}I  ·  DG $goalsFor PG $goalsAgainst ($gd)';
  }

  @override
  String get careerWorldCupLabel => 'Svjetsko prvenstvo';

  @override
  String get careerContinentalLabel => 'Kontinentalno';

  @override
  String get messagesTitle => 'PORUKE';

  @override
  String get messagesNoMessagesYet => 'Još nema poruka.';

  @override
  String messagesCouldNotLoad(String error) {
    return 'Poruke se nisu mogle učitati.\n$error';
  }

  @override
  String get messagesDone => 'Gotovo';

  @override
  String get messagesNext => 'Dalje';

  @override
  String get rankingWorldRanking => 'SVJETSKA LJESTVICA';

  @override
  String rankingCouldNotLoad(String error) {
    return 'Ljestvica se nije mogla učitati.\n$error';
  }

  @override
  String get rankingNoRanking => 'Nema ljestvice.';

  @override
  String get rankingAll => 'SVE';

  @override
  String get rankingYourTeam => 'TVOJA MOMČAD';

  @override
  String get rankingYourRankingOverTime => 'TVOJ PLASMAN KROZ VRIJEME';

  @override
  String rankingNowRank(int rank) {
    return 'sad #$rank';
  }

  @override
  String rankingBestWorst(int best, int worst) {
    return 'najbolje #$best · najgore #$worst';
  }

  @override
  String get friendliesTitle => 'PRIJATELJSKE';

  @override
  String friendliesLoadError(String error) {
    return 'Prijateljske utakmice nisu se mogle učitati.\n$error';
  }

  @override
  String get friendliesContinue => 'Nastavi';

  @override
  String friendliesArrangeIntro(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count slobodnih termina',
      few: '$count slobodna termina',
      one: '$count slobodan termin',
    );
    return 'Dogovori pripremne utakmice za $_temp0 prije sljedeće službene utakmice. Dodirni protivnika ili ostavi termin slobodnim.';
  }

  @override
  String get friendliesFree => 'Slobodno';

  @override
  String matchGoalsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count GOLOVA',
      few: '$count GOLA',
      one: '$count GOL',
    );
    return '$_temp0';
  }

  @override
  String get matchGoalsTitle => 'GOLOVI';

  @override
  String get matchGoalsNone => 'Bez golova';

  @override
  String get matchGoalPenalty => '11M';

  @override
  String get matchGoalSetPiece => 'STAJ';

  @override
  String matchGoalAssist(String name) {
    return 'asistencija $name';
  }

  @override
  String get friendliesHome => 'DOMA';

  @override
  String get friendliesAway => 'U GOSTIMA';

  @override
  String get friendliesNoneThisWindow => 'Nema prijateljskih u ovom terminu';

  @override
  String friendliesConfirmCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count prijateljskih',
      few: '$count prijateljske',
      one: '$count prijateljsku',
    );
    return 'Potvrdi $_temp0';
  }

  @override
  String get friendliesMonthJan => 'sij';

  @override
  String get friendliesMonthFeb => 'velj';

  @override
  String get friendliesMonthMar => 'ožu';

  @override
  String get friendliesMonthApr => 'tra';

  @override
  String get friendliesMonthMay => 'svi';

  @override
  String get friendliesMonthJun => 'lip';

  @override
  String get friendliesMonthJul => 'srp';

  @override
  String get friendliesMonthAug => 'kol';

  @override
  String get friendliesMonthSep => 'ruj';

  @override
  String get friendliesMonthOct => 'lis';

  @override
  String get friendliesMonthNov => 'stu';

  @override
  String get friendliesMonthDec => 'pro';

  @override
  String get resultsMyMatches => 'MOJE UTAKMICE';

  @override
  String resultsCouldNotLoad(String error) {
    return 'Rezultati se nisu mogli učitati.\n$error';
  }

  @override
  String get resultsNoFixtures => 'Nema utakmica.';

  @override
  String get resultsVs => 'protiv';

  @override
  String get resultsStageQualifier => 'KVALIFIKACIJE';

  @override
  String get resultsStageFriendly => 'PRIJATELJSKA';

  @override
  String get resultsStageGroupStage => 'SKUPINE';

  @override
  String get resultsStageSemiFinal => 'POLUFINALE';

  @override
  String get resultsStageFinal => 'FINALE';

  @override
  String get resultsStageContinentalClash => 'CONTINENTAL CLASH';

  @override
  String get resultsStageFinalsGroup => 'SKUPINA FINALA';

  @override
  String get resultsStageRoundOf32 => '1/16 FINALA';

  @override
  String get resultsStageRoundOf16 => 'OSMINA FINALA';

  @override
  String get resultsStageQuarterFinal => 'ČETVRTFINALE';

  @override
  String get resultsStageThirdPlace => 'ZA TREĆE MJESTO';

  @override
  String get matchSetupWarnCaptain =>
      'Kapetan nije određen. Dodirni i daj nekome kapetansku traku';

  @override
  String matchSetupWarnCaptainInjured(String name) {
    return 'Igrač $name je ozlijeđen i ne može predvoditi momčad. Dodirni i predaj traku dalje';
  }

  @override
  String matchSetupWarnCaptainSuspended(String name) {
    return 'Igrač $name je kažnjen za ovu utakmicu. Dodirni i predaj traku dalje';
  }

  @override
  String matchSetupWarnCaptainDropped(String name) {
    return 'Igrač $name ima traku, ali nije u tvom sastavu. Dodirni i predaj je dalje';
  }

  @override
  String get matchSetupWarnSetPieces =>
      'Izvođači stajalica nisu određeni. Dodirni i odaberi tko će ih izvoditi';

  @override
  String get matchSetupWarnBoth =>
      'Nema kapetana ni izvođača stajalica. Dodirni i odredi ih';

  @override
  String matchStageMatchday(int matchday) {
    return '$matchday. KOLO';
  }

  @override
  String get squadCaptain => 'Kapetan';

  @override
  String deptEffectYouth(int points) {
    return 'Talenti iz akademije stižu s oko $points boljom ukupnom ocjenom';
  }

  @override
  String deptEffectCommercial(String amount) {
    return '$amount natrag na kraju ciklusa';
  }

  @override
  String deptEffectMedical(int percent) {
    return '$percent% manje ozljeda';
  }

  @override
  String deptEffectNaturalisation(int percent) {
    return '$percent% šanse da strani igrač zatraži prelazak';
  }

  @override
  String deptEffectBoard(int points) {
    return '+$points strpljenja odbora prije nego ti prijeti otkaz';
  }

  @override
  String get deptEffectNone => 'Bez učinka dok nije financirano';

  @override
  String get statsBestRated => 'Ocjene';

  @override
  String get statsMyCareer => 'Karijera';

  @override
  String get statsBestAverageRating => 'NAJBOLJA PROSJEČNA OCJENA';

  @override
  String get statsMyCareerRecord => 'TVOJ UČINAK';

  @override
  String get statsNoRatingsRecorded => 'Još nema zabilježenih ocjena.';

  @override
  String get statsGroupRecord => 'Učinak';

  @override
  String get statsGroupRuns => 'Nizovi';

  @override
  String get statsGroupExtremes => 'Krajnosti';

  @override
  String get statsGroupSplits => 'Doma i u gostima';

  @override
  String get statsGroupSquad => 'Tvoji igrači';

  @override
  String get statsPlayed => 'Odigrane utakmice';

  @override
  String get statsWinDrawLoss => 'Pobjede–neriješeno–porazi';

  @override
  String get statsWinRate => 'Postotak pobjeda';

  @override
  String get statsGoals => 'Golovi dani:primljeni';

  @override
  String get statsCleanSheets => 'Mreža netaknuta';

  @override
  String get statsFailedToScore => 'Bez postignutog gola';

  @override
  String get statsLongestWinStreak => 'Najduži niz pobjeda';

  @override
  String get statsLongestUnbeaten => 'Najduži niz bez poraza';

  @override
  String get statsLongestCleanSheets => 'Najduži niz netaknute mreže';

  @override
  String get statsLongestWinless => 'Najduži niz bez pobjede';

  @override
  String get statsCurrentRun => 'Trenutni niz bez poraza';

  @override
  String get statsBiggestWin => 'Najveća pobjeda';

  @override
  String get statsHeaviestDefeat => 'Najteži poraz';

  @override
  String get statsMostGoalsInAGame => 'Najviše golova u utakmici';

  @override
  String get statsShootouts => 'Raspucavanja: pobjede–porazi';

  @override
  String get statsComebackWins => 'Pobjede nakon zaostatka';

  @override
  String get statsHome => 'Doma';

  @override
  String get statsAway => 'U gostima';

  @override
  String get statsNeutral => 'Neutralno';

  @override
  String get statsCompetitive => 'Službene';

  @override
  String get statsFriendlies => 'Prijateljske';

  @override
  String get statsHatTricks => 'Hat-tricki';

  @override
  String get statsBraces => 'Dublete';

  @override
  String get statsMotms => 'Nagrade za igrača utakmice';

  @override
  String get statsAssists => 'Asistencije';

  @override
  String get statsCards => 'Kartoni';

  @override
  String get statsBestRating => 'Najbolja pojedinačna ocjena';

  @override
  String statsAppsShort(int apps) {
    return '$apps nast.';
  }

  @override
  String statsMotmShort(int motms) {
    return '$motms MOTM';
  }

  @override
  String get captainArmband => 'K';

  @override
  String get captainCurrent => 'Kapetan. Dodirni za skidanje trake';

  @override
  String get captainFitBorn => 'Rođeni vođa';

  @override
  String get captainFitNatural => 'Prirodni kapetan';

  @override
  String get captainFitCapable => 'Mogao bi nositi traku';

  @override
  String get captainFitUnproven => 'Još nije vođa';

  @override
  String get captainNone => 'Kapetan nije određen';

  @override
  String captainMoraleBoost(int morale) {
    return '+$morale morala momčadi';
  }

  @override
  String get resultsCategoryWorldCupQualifying =>
      'Kvalifikacije za Svjetsko prvenstvo';

  @override
  String get resultsCategoryFriendlies => 'Prijateljske utakmice';

  @override
  String get resultsCategoryContinentalClash => 'Continental Clash';

  @override
  String get resultsCategoryNationsCup => 'Nations Cup';

  @override
  String get resultsCategoryContinentalCup => 'Kontinentalni kup';

  @override
  String get resultsCategoryWorldCupQualifyingShort => 'SP kval.';

  @override
  String get resultsCategoryContinentalQualifyingShort => 'Kont. kup kval.';

  @override
  String get resultsCategoryContinentalQualifying =>
      'Kvalifikacije za kontinentalni kup';

  @override
  String get resultsCategoryWorldCupFinals => 'Završnica Svjetskog prvenstva';

  @override
  String get resultsRoundResults => 'REZULTATI KOLA';

  @override
  String get resultsFriendlyInternationals =>
      'PRIJATELJSKE UTAKMICE REPREZENTACIJA';

  @override
  String get resultsKnockout => 'Nokaut-faza';

  @override
  String resultsEarlierMatches(int count) {
    return 'Ranije utakmice ($count)';
  }

  @override
  String resultsMatchday(int matchday) {
    return 'KOLO $matchday';
  }

  @override
  String get resultsContinue => 'Nastavi';

  @override
  String resultsGroup(String name) {
    return 'SKUPINA $name';
  }

  @override
  String get achievementsScreenTitle => 'POSTIGNUĆA';

  @override
  String get achievementsChallengesTooltip => 'Izazovi';

  @override
  String get achievementsChallengesHeading => 'IZAZOVI';

  @override
  String get achievementsBrutalTests => 'Brutalni izazovi za cijelu karijeru';

  @override
  String achievementsCouldNotLoad(String error) {
    return 'Učitavanje nije uspjelo.\n$error';
  }

  @override
  String achievementsUnlockedCount(int earned, int total) {
    return '$earned / $total otključano';
  }

  @override
  String achievementsConqueredCount(int done, int total) {
    return '$done / $total svladano';
  }

  @override
  String get achievementsBoardSatisfaction => 'ZADOVOLJSTVO ODBORA';

  @override
  String achievementsUnlockedBanner(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count POSTIGNUĆA OTKLJUČANO',
      few: '$count POSTIGNUĆA OTKLJUČANA',
      one: '$count POSTIGNUĆE OTKLJUČANO',
    );
    return '$_temp0';
  }

  @override
  String get achCatWins => 'Pobjede';

  @override
  String get achCatMatches => 'Utakmice';

  @override
  String get achCatQualifications => 'Kvalifikacije';

  @override
  String get achCatTitles => 'Naslovi';

  @override
  String get achCatMisc => 'Razno';

  @override
  String get achCatMega => 'Mega';

  @override
  String get achCatGoals => 'Golovi';

  @override
  String get achCatStreaks => 'Nizovi';

  @override
  String get achTierBronze => 'Bronca';

  @override
  String get achTierSilver => 'Srebro';

  @override
  String get achTierGold => 'Zlato';

  @override
  String get achTierPlatinum => 'Platina';

  @override
  String achGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count golova',
      few: '$count gola',
      one: '$count gol',
    );
    return '$_temp0';
  }

  @override
  String achGoalsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Postigni $count golova.',
      few: 'Postigni $count gola.',
      one: 'Postigni $count gol.',
    );
    return '$_temp0';
  }

  @override
  String achCleanSheets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count netaknutih mreža',
      few: '$count netaknute mreže',
      one: '$count netaknuta mreža',
    );
    return '$_temp0';
  }

  @override
  String achCleanSheetsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sačuvaj $count netaknutih mreža.',
      few: 'Sačuvaj $count netaknute mreže.',
      one: 'Sačuvaj $count netaknutu mrežu.',
    );
    return '$_temp0';
  }

  @override
  String get achStreakWin5 => 'Navika pobjeđivanja';

  @override
  String get achStreakWin5Desc => 'Pobijedi u pet utakmica zaredom.';

  @override
  String get achStreakWin10 => 'U naletu';

  @override
  String get achStreakWin10Desc => 'Pobijedi u deset utakmica zaredom.';

  @override
  String get achStreakWin20 => 'Parni valjak';

  @override
  String get achStreakWin20Desc => 'Pobijedi u dvadeset utakmica zaredom.';

  @override
  String get achUnbeaten15 => 'Teško ga je svladati';

  @override
  String get achUnbeaten15Desc => 'Odigraj petnaest utakmica bez poraza.';

  @override
  String get achUnbeaten30 => 'Nedodirljivi';

  @override
  String get achUnbeaten30Desc => 'Odigraj trideset utakmica bez poraza.';

  @override
  String get achHattrick => 'Junak hat-tricka';

  @override
  String get achHattrickDesc => 'Neka igrač postigne hat-trick.';

  @override
  String get achMotm10 => 'Istaknuti';

  @override
  String get achMotm10Desc => 'Skupi 10 nagrada za igrača utakmice.';

  @override
  String get achMotm50 => 'Talisman';

  @override
  String get achMotm50Desc => 'Skupi 50 nagrada za igrača utakmice.';

  @override
  String get achPerfect => 'Savršena desetka';

  @override
  String get achPerfectDesc => 'Neka igrač zaradi ocjenu 9,5 ili višu.';

  @override
  String get achShootout => 'Led u venama';

  @override
  String get achShootoutDesc => 'Pobijedi u pet raspucavanja jedanaesteraca.';

  @override
  String get achMassacre => 'Masakr';

  @override
  String get achMassacreDesc => 'Pobijedi s razlikom od 7 ili više golova.';

  @override
  String get achAnnihilation => 'Uništenje';

  @override
  String get achAnnihilationDesc =>
      'Pobijedi s razlikom od 10 ili više golova.';

  @override
  String get chTierBronze => 'Bronca';

  @override
  String get chTierSilver => 'Srebro';

  @override
  String get chTierGold => 'Zlato';

  @override
  String get chTierLegendary => 'Legendarno';

  @override
  String get chFirstSteps => 'Na klupi';

  @override
  String get chFirstStepsDesc => 'Vodi momčad 5 godina.';

  @override
  String get chUnbeaten10 => 'U naletu';

  @override
  String get chUnbeaten10Desc => 'Odigraj 10 službenih utakmica bez poraza.';

  @override
  String get chTwoNations => 'Novi izazov';

  @override
  String get chTwoNationsDesc => 'Vodi 2 različite reprezentacije.';

  @override
  String get chCont1 => 'Kontinentalni prvak';

  @override
  String get chCont1Desc => 'Osvoji kontinentalno prvenstvo.';

  @override
  String get chNc1 => 'Pobjednik natjecanja Nations Cup';

  @override
  String get chNc1Desc => 'Osvoji Nations Cup.';

  @override
  String get chWc1 => 'Svjetski prvak';

  @override
  String get chWc1Desc => 'Osvoji Svjetsko prvenstvo.';

  @override
  String get chYears25 => 'Establišment';

  @override
  String get chYears25Desc => 'Vodi momčad 25 godina.';

  @override
  String get chWc3 => 'Serijski pobjednik';

  @override
  String get chWc3Desc => 'Osvoji 3 Svjetska prvenstva.';

  @override
  String get chWc5 => 'Dinastija';

  @override
  String get chWc5Desc => 'Osvoji 5 Svjetskih prvenstava.';

  @override
  String get chWc10 => 'Besmrtnik';

  @override
  String get chWc10Desc => 'Osvoji 10 Svjetskih prvenstava.';

  @override
  String get chWc2Teams => 'Kovčeg spreman';

  @override
  String get chWc2TeamsDesc =>
      'Osvoji Svjetsko prvenstvo s 2 različite reprezentacije.';

  @override
  String get chWc3Teams => 'Svjetski putnik';

  @override
  String get chWc3TeamsDesc =>
      'Osvoji Svjetsko prvenstvo s 3 različite reprezentacije.';

  @override
  String get chWcStreak3 => 'Tri zaredom';

  @override
  String get chWcStreak3Desc => 'Osvoji 3 Svjetska prvenstva zaredom.';

  @override
  String get chWcAllconf => 'Osvajač svijeta';

  @override
  String get chWcAllconfDesc =>
      'Osvoji Svjetsko prvenstvo s reprezentacijom iz svake konfederacije (6).';

  @override
  String get chCont5 => 'Kontinentalni kralj';

  @override
  String get chCont5Desc => 'Osvoji 5 kontinentalnih prvenstava.';

  @override
  String get chContAll => 'Slam šest kontinenata';

  @override
  String get chContAllDesc =>
      'Osvoji kontinentalno prvenstvo svake konfederacije (6).';

  @override
  String get chTreble => 'Čisto pometanje';

  @override
  String get chTrebleDesc =>
      'Osvoji Svjetsko prvenstvo, kontinentalni naslov i Nations Cup u jednoj karijeri.';

  @override
  String get chNations10 => 'Nomad';

  @override
  String get chNations10Desc => 'Vodi 10 različitih reprezentacija.';

  @override
  String get chYears100 => 'Stoljeće';

  @override
  String get chYears100Desc => 'Vodi momčad 100 godina.';

  @override
  String get chYears500 => 'Pola tisućljeća';

  @override
  String get chYears500Desc => 'Vodi momčad 500 godina.';

  @override
  String get chYears1000 => 'Vječni';

  @override
  String get chYears1000Desc => 'Vodi momčad 1000 godina.';

  @override
  String get chGrandmaster => 'Velemajstor';

  @override
  String get chGrandmasterDesc =>
      'Osvoji 3 Svjetska prvenstva I 5 kontinentalnih prvenstava.';

  @override
  String get chUndefeated => 'Nedodirljivi';

  @override
  String get chUndefeatedDesc =>
      'Osvoji Svjetsko prvenstvo bez ijednog poraza.';

  @override
  String get chPerfectQual => 'Besprijekoran prolaz';

  @override
  String get chPerfectQualDesc =>
      'Pobijedi u svakoj utakmici kvalifikacija za Svjetsko prvenstvo.';

  @override
  String get chMinnow => 'Čudo malih';

  @override
  String get chMinnowDesc =>
      'Osvoji Svjetsko prvenstvo s reprezentacijom izvan prvih 32 na svjetskoj ljestvici.';

  @override
  String get chGrandTour => 'Doma i u gostima';

  @override
  String get chGrandTourDesc =>
      'Osvoji Svjetsko prvenstvo kao domaćin i jedno izvan domaće zemlje.';

  @override
  String get chUnbeaten25 => 'Zid';

  @override
  String get chUnbeaten25Desc => 'Odigraj 25 službenih utakmica bez poraza.';

  @override
  String get chGoals10k => 'Stroj za golove';

  @override
  String get chGoals10kDesc => 'Postigni 10.000 golova u karijeri.';

  @override
  String get chCleanSheets500 => 'Tvrđava';

  @override
  String get chCleanSheets500Desc => 'Sačuvaj 500 netaknutih mreža u karijeri.';

  @override
  String get chHatTricks25 => 'Navika hat-tricka';

  @override
  String get chHatTricks25Desc => 'Neka tvoji igrači postignu 25 hat-trickova.';

  @override
  String get chWinStreak25 => 'Nemilosrdni';

  @override
  String get chWinStreak25Desc => 'Pobijedi u 25 utakmica zaredom.';

  @override
  String get chCont10 => 'Kontinentalna dinastija';

  @override
  String get chCont10Desc => 'Osvoji 10 kontinentalnih prvenstava.';

  @override
  String get chPcWc => 'Serijski prvak';

  @override
  String chPcWcDesc(int count) {
    return 'Osvoji Svjetsko prvenstvo $count puta u ovoj igri.';
  }

  @override
  String get chPcMajors => 'Skupljač trofeja';

  @override
  String chPcMajorsDesc(int count) {
    return 'Osvoji velike trofeje: $count (Svjetsko prvenstvo, kontinentalno prvenstvo ili Nations Cup).';
  }

  @override
  String get chPcUnbeaten => 'Željezni zid';

  @override
  String chPcUnbeatenDesc(int count) {
    return 'Ostani bez poraza u službenim utakmicama: $count zaredom.';
  }

  @override
  String get chPcNations => 'Putnik';

  @override
  String chPcNationsDesc(int count) {
    return 'Vodi različite reprezentacije: $count.';
  }

  @override
  String get chPcYears => 'Dugi put';

  @override
  String chPcYearsDesc(int count) {
    return 'Vodi momčad $count god.';
  }

  @override
  String achWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pobjeda',
      few: '$count pobjede',
      one: '$count pobjeda',
    );
    return '$_temp0';
  }

  @override
  String achWinsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Pobijedi u $count utakmica.',
      few: 'Pobijedi u $count utakmice.',
      one: 'Pobijedi u $count utakmici.',
    );
    return '$_temp0';
  }

  @override
  String achMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count utakmica',
      few: '$count utakmice',
      one: '$count utakmica',
    );
    return '$_temp0';
  }

  @override
  String achMatchesDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Odigraj $count utakmica.',
      few: 'Odigraj $count utakmice.',
      one: 'Odigraj $count utakmicu.',
    );
    return '$_temp0';
  }

  @override
  String get achQualWc => 'Kvalifikant za Svjetsko prvenstvo';

  @override
  String get achQualWcDesc => 'Kvalificiraj se za Svjetsko prvenstvo.';

  @override
  String get achQualCont => 'Kontinentalni kvalifikant';

  @override
  String get achQualContDesc =>
      'Kvalificiraj se za svoje kontinentalno prvenstvo.';

  @override
  String get achTitleWc => 'Svjetski prvaci';

  @override
  String get achTitleWcDesc => 'Osvoji Svjetsko prvenstvo.';

  @override
  String get achTitleEuro => 'Europski prvaci';

  @override
  String get achTitleEuroDesc => 'Osvoji Europsko prvenstvo.';

  @override
  String get achTitleCopa => 'Prvaci Južne Amerike';

  @override
  String get achTitleCopaDesc => 'Osvoji Kup Južne Amerike.';

  @override
  String get achTitleAfcon => 'Afrički prvaci';

  @override
  String get achTitleAfconDesc => 'Osvoji Afričko prvenstvo.';

  @override
  String get achTitleAsia => 'Azijski prvaci';

  @override
  String get achTitleAsiaDesc => 'Osvoji Azijsko prvenstvo.';

  @override
  String get achTitleConcacaf => 'Prvaci Sjeverne Amerike';

  @override
  String get achTitleConcacafDesc => 'Osvoji Kup Sjeverne Amerike.';

  @override
  String get achTitleOfc => 'Prvaci Oceanije';

  @override
  String get achTitleOfcDesc => 'Osvoji Kup Oceanije.';

  @override
  String get achTitleNations => 'Pobjednici natjecanja Nations Cup';

  @override
  String get achTitleNationsDesc => 'Osvoji Nations Cup.';

  @override
  String get achTitleClash => 'Pobjednici natjecanja Continental Clash';

  @override
  String get achTitleClashDesc => 'Osvoji Continental Clash.';

  @override
  String get achMarksman => 'Strijelac Svjetskog prvenstva';

  @override
  String get achMarksmanDesc =>
      'Neka igrač iz tvog sastava postigne 6 ili više golova u završnici Svjetskog prvenstva.';

  @override
  String get achSweep => 'Čisto pometanje';

  @override
  String get achSweepDesc =>
      'Drži naslove Svjetskog prvenstva i kontinentalnog prvaka u jednoj karijeri.';

  @override
  String get achAllstar => 'Zvijezda turnira';

  @override
  String get achAllstarDesc =>
      'Neka igrač uđe u Momčad turnira Svjetskog prvenstva.';

  @override
  String get achGoldenboot => 'Zlatna kopačka';

  @override
  String get achGoldenbootDesc =>
      'Neka tvoja reprezentacija završi kao najbolji strijelac prvenstva.';

  @override
  String get achDemolition => 'Rušenje';

  @override
  String get achDemolitionDesc => 'Pobijedi s razlikom od 5 ili više golova.';

  @override
  String get achievementsNice => 'Super!';

  @override
  String get achievementsHardestTests =>
      'Najteži ispiti izbornika, kroz cijelu karijeru i mnoge reprezentacije.';

  @override
  String get achievementsThisSave => 'OVA IGRA';

  @override
  String get achievementsBrutalBadge => 'BRUTALNO';

  @override
  String get paywallGoPro => 'POSTANI UNLIMITED';

  @override
  String get paywallOneTimeUnlock =>
      'Jednokratno otključavanje. Bez pretplate.';

  @override
  String get paywallBenefitCarryOn =>
      'Ova igra nastavlja točno gdje je stala, sa svakim nastupom, rekordom i rivalstvom na broju.';

  @override
  String get paywallBenefitNoAds =>
      'Bez reklama, bez mikrotransakcija, bez pretplate. Jedna uplata, a svako buduće ažuriranje je tvoje.';

  @override
  String get paywallBenefitSaves =>
      'Koliko god spremljenih igara želiš. Vodi favorita i outsidera istodobno i otkrij koliko se ista igra različito doživljava.';

  @override
  String get paywallBenefitEndless =>
      'Svaki ciklus od sada. Odaberi sedamnaestogodišnjaka danas i 2034. saznaj jesi li bio u pravu.';

  @override
  String get paywallUnlocked => 'Unlimited je otključan. Uživaj!';

  @override
  String get paywallContactingStore => 'Spajanje na trgovinu…';

  @override
  String paywallUnlockProPriced(String price) {
    return 'Otključaj Unlimited · $price';
  }

  @override
  String get paywallRestorePurchases => 'Vrati kupnje';

  @override
  String get paywallStoreUnavailable => 'Trgovina nedostupna';

  @override
  String get paywallStoreUnavailableNote =>
      'Cijena se nije mogla učitati. Provjeri vezu i pokušaj ponovno.';

  @override
  String get paywallTryAgain => 'Pokušaj ponovno';

  @override
  String get gateTitle => 'TVOJ PRVI CIKLUS JE GOTOV';

  @override
  String get gateLead =>
      'Četiri godine su jedan ciklus. To nije dovoljno da saznaš jesi li bio u pravu.';

  @override
  String get gatePriceLead => 'Jedna uplata, zauvijek';

  @override
  String get gateBuy => 'KUPI I NASTAVI';

  @override
  String get gateExit => 'IZLAZ';

  @override
  String get federationNaturalisation => 'NATURALIZACIJA';

  @override
  String federationNaturalisedTitle(String name) {
    return 'Naturaliziran: $name';
  }

  @override
  String federationNaturalisedBody(String name, String nation) {
    return 'Igrač $name je završio prelazak i sada može igrati za reprezentaciju: $nation. Pozovi ga iz izbora sastava.';
  }

  @override
  String federationCouldNotLoadOffer(String error) {
    return 'Ponuda se nije mogla učitati.\n$error';
  }

  @override
  String get federationContinue => 'Nastavi';

  @override
  String get federationOfferToSwitchAllegiance =>
      'PONUDA ZA PROMJENU REPREZENTACIJE';

  @override
  String federationPlayerMeta(String position, int age, String nation) {
    return '$position · $age god. · iz zemlje: $nation';
  }

  @override
  String federationNaturalisationBlurb(
    String name,
    String playerNation,
    String sourceNation,
  ) {
    return 'Igrač $name, povezan sa zemljom $playerNation, spreman je na naturalizaciju. Prihvati i možeš ga birati; odbij i ostaje u reprezentaciji: $sourceNation.';
  }

  @override
  String get federationDecline => 'Odbij';

  @override
  String get federationNaturalise => 'Naturaliziraj';

  @override
  String get federationBudgetLater => 'Odluči kasnije';

  @override
  String get federationSetYourBudget => 'ODREDI PRORAČUN';

  @override
  String federationCouldNotLoadFinances(String error) {
    return 'Financije se nisu mogle učitati.\n$error';
  }

  @override
  String get federationSaveNotFound => 'Spremljena igra nije pronađena.';

  @override
  String get federationBudgetHeading => 'PRORAČUN SAVEZA';

  @override
  String federationDistributeBudget(String amount) {
    return 'Rasporedi $amount po odjelima da otvoriš ciklus. Potroši pametno.';
  }

  @override
  String federationOverBudget(String amount) {
    return '$amount više nego što savez ima. Vrati nešto natrag';
  }

  @override
  String get federationAllocateFullBudget =>
      'Rasporedi cijeli proračun da započneš ciklus.';

  @override
  String get federationConfirming => 'Potvrđujem…';

  @override
  String get federationConfirmBudget => 'Potvrdi proračun';

  @override
  String get federationFinances => 'FINANCIJE';

  @override
  String get federationInvestmentUpdated => 'Ulaganje ažurirano.';

  @override
  String get federationDevelopment => 'RAZVOJ SAVEZA';

  @override
  String get federationProjectedAtSeasonEnd => 'PROCJENA NA KRAJU SEZONE';

  @override
  String get federationCentralFunding => 'Središnje financiranje';

  @override
  String get federationPrizeMoneySoFar => 'Dosadašnja nagrada';

  @override
  String get federationCommercialReturn => 'Komercijalni prihod';

  @override
  String get federationThisSeasonLocked => 'OVA SEZONA (ZAKLJUČANO)';

  @override
  String get federationInvestForNextSeason => 'ULOŽI ZA SLJEDEĆU SEZONU';

  @override
  String get federationNextSeasonImpact => 'UČINAK SLJEDEĆE SEZONE';

  @override
  String get federationSaving => 'Spremam…';

  @override
  String get federationConfirmInvestment => 'Potvrdi ulaganje';

  @override
  String get federationBalance => 'STANJE SAVEZA';

  @override
  String get federationCommittedToStaff => 'Obveze prema stožeru';

  @override
  String get federationFreeToSpend => 'Slobodno za potrošnju';

  @override
  String get federationWagesNote =>
      'Plaće se skidaju sa stanja na kraju ciklusa, pa je toliko već rezervirano.';

  @override
  String get federationInvestAtCeremony =>
      'Uloži za sljedeću sezonu na svečanosti na kraju ciklusa.';

  @override
  String federationLevelBadge(int level) {
    return 'R$level';
  }

  @override
  String get federationAcademyProspects => 'Talenti iz akademije';

  @override
  String federationPlusOverall(int value) {
    return '+$value ukupne ocjene';
  }

  @override
  String get federationInjuryRisk => 'Rizik od ozljeda';

  @override
  String get federationNaturalisationChance => 'Šansa za naturalizaciju';

  @override
  String get federationBoardPatience => 'Strpljenje odbora';

  @override
  String get federationUnallocated => 'NERASPOREĐENO';

  @override
  String get nationsVitrineTitle => 'VITRINA REPREZENTACIJE';

  @override
  String nationsCouldNotLoad(String error) {
    return 'Zemlju nije moguće učitati.\n$error';
  }

  @override
  String get nationsNoNation => 'Nema zemlje.';

  @override
  String get nationsHonours => 'ODLIČJA';

  @override
  String get nationsRankingHistory => 'POVIJEST SVJETSKE LJESTVICE';

  @override
  String get nationsTopScorers => 'NAJBOLJI STRIJELCI SVIH VREMENA';

  @override
  String get nationsTitles => 'NASLOVI';

  @override
  String get nationsYourTeam => 'TVOJA REPREZENTACIJA';

  @override
  String get nationsWorld => 'SVIJET';

  @override
  String get nationsWorldCup => 'Svjetsko prvenstvo';

  @override
  String get nationsContinental => 'Kontinentalno';

  @override
  String nationsAppearances(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nastupa',
      few: '$count nastupa',
      one: '$count nastup',
    );
    return '$_temp0';
  }

  @override
  String get nationsNotEnoughHistory =>
      'Povijesti još nema dovoljno. Vrati se nakon ciklusa ili dva.';

  @override
  String nationsBestRank(int rank) {
    return 'Najbolje: #$rank';
  }

  @override
  String nationsNowRank(int rank) {
    return 'Sada: #$rank';
  }

  @override
  String get nationsNoGoals => 'Još nema zabilježenih golova.';

  @override
  String get nationsGoalsAbbrev => 'gol.';

  @override
  String get nationsHosts => 'DOMAĆIN';

  @override
  String get nationsSelectTitle => 'ODABERI REPREZENTACIJU';

  @override
  String nationsCouldNotLoadNations(String error) {
    return 'Zemlje nije moguće učitati.\n$error';
  }

  @override
  String get nationsNoMatch => 'Nijedna zemlja ne odgovara.';

  @override
  String get nationsNationalLevel => 'RAZINA REPREZENTACIJE';

  @override
  String get nationsSelectHeading => 'Odaberi reprezentaciju';

  @override
  String get nationsSearchHint => 'Traži državu…';

  @override
  String get nationsRank => 'RANG ';

  @override
  String get nationsPremium => 'PREMIUM';

  @override
  String get nationsSelect => 'ODABERI';

  @override
  String get statsTeamRecords => 'REKORDI REPREZENTACIJE';

  @override
  String get statsRecordBook => 'Knjiga rekorda';

  @override
  String statsCouldNotLoadStats(String error) {
    return 'Statistiku nije moguće učitati.\n$error';
  }

  @override
  String get statsNoData => 'Nema podataka.';

  @override
  String get statsTopScorers => 'NAJBOLJI STRIJELCI';

  @override
  String get statsMostGamesPlayed => 'NAJVIŠE ODIGRANIH UTAKMICA';

  @override
  String get statsTeam => 'Momčad';

  @override
  String get statsTopScorersShort => 'Strijelci';

  @override
  String get statsMostGames => 'Najviše utakmica';

  @override
  String get statsNoGoalsRecorded => 'Još nema zabilježenih golova.';

  @override
  String get statsUnknown => 'Nepoznato';

  @override
  String get playerTitle => 'IGRAČ';

  @override
  String playerLoadError(String error) {
    return 'Igrača nije moguće učitati.\n$error';
  }

  @override
  String get playerNotFound => 'Igrač nije pronađen.';

  @override
  String get playerClub => 'KLUB';

  @override
  String get playerClubRole => 'U svom klubu';

  @override
  String get playerPosition => 'Pozicija';

  @override
  String get playerPotential => 'Potencijal';

  @override
  String get playerAge => 'Dob';

  @override
  String get playerValue => 'Vrijednost';

  @override
  String get clubFirstChoice => 'Igra svaki tjedan';

  @override
  String get clubRotation => 'Čas igra, čas ne';

  @override
  String get clubFringe => 'Jedva igra';

  @override
  String get clubFrozenOut => 'Ne igra';

  @override
  String clubAtClub(String club, String standing) {
    return '$club: $standing';
  }

  @override
  String yWinUpset0(String opponent, String score) {
    return 'Gledam nogomet trideset godina i ovo nisam vidio dolaziti. $opponent $score.';
  }

  @override
  String yWinUpset1(String opponent, String score) {
    return 'Nitko im nije davao šanse. $opponent $score. Baš nitko.';
  }

  @override
  String yWinUpset2(String opponent, String score) {
    return '$opponent $score. Idite probuditi susjede.';
  }

  @override
  String yWinUpset3(String opponent, String score) {
    return 'Ovakve se noći pričaju unucima. $opponent $score.';
  }

  @override
  String yWinUpset4(String opponent, String score) {
    return '$opponent $score. Kako god se to dogodilo, dogodilo se.';
  }

  @override
  String yWinUpset5(String opponent, String score) {
    return 'Na papiru je bilo gotovo prije početka. $opponent $score kaže drukčije.';
  }

  @override
  String yWinUpset6(String opponent, String score) {
    return '$opponent $score. Za godinu dana nitko neće vjerovati u taj rezultat.';
  }

  @override
  String yWinUpset7(String opponent, String score) {
    return '$opponent $score. Uživaj, pa pogledaj raspored utakmica.';
  }

  @override
  String yWinUpset8(String opponent, String score) {
    return '$opponent $score, a mi smo osamdeset od devedeset minuta jahali na sreći.';
  }

  @override
  String yWinUpset9(String opponent, String score) {
    return '$opponent $score. Jedna večer ne briše godinu.';
  }

  @override
  String yWinUpset10(String opponent, String score) {
    return '$opponent $score, a sad će nam reći da smo skrenuli na pravi put. Nismo.';
  }

  @override
  String yWinUpset11(String opponent, String score) {
    return '$opponent $score. Divno. Pitaj me opet kad bude bitno.';
  }

  @override
  String yWinRoutine0(String opponent, String score) {
    return '$opponent $score. Točno kako treba, a u tome ima užitka.';
  }

  @override
  String yWinRoutine1(String opponent, String score) {
    return '$opponent $score. Nemilosrdno, a nemilosrdno je kompliment.';
  }

  @override
  String yWinRoutine2(String opponent, String score) {
    return '$opponent $score. Bez drame, bez straha, bez zamjerki.';
  }

  @override
  String yWinRoutine3(String opponent, String score) {
    return 'Uredan rezultat: $opponent $score. Tako izgleda dobra momčad u mirnom danu.';
  }

  @override
  String yWinRoutine4(String opponent, String score) {
    return '$opponent $score. Posao gotov, ništa naučeno.';
  }

  @override
  String yWinRoutine5(String opponent, String score) {
    return '$opponent $score. Trebali smo pobijediti i jesmo.';
  }

  @override
  String yWinRoutine6(String opponent, String score) {
    return 'Profesionalno: $opponent $score. Sljedeći.';
  }

  @override
  String yWinRoutine7(String opponent, String score) {
    return '$opponent $score. Spremi to u ladicu i idemo dalje.';
  }

  @override
  String yWinRoutine8(String opponent, String score) {
    return '$opponent $score i sad bismo trebali pljeskati. Zato što smo ih pobijedili.';
  }

  @override
  String yWinRoutine9(String opponent, String score) {
    return 'Svaka čast svima, valjda. $opponent $score.';
  }

  @override
  String yWinRoutine10(String opponent, String score) {
    return '$opponent $score. Pobjeda nad ovakvima je minimum, a ne postignuće.';
  }

  @override
  String yWinRoutine11(String opponent, String score) {
    return '$opponent $score. Pobijedili smo, ali se vidjelo da se mučimo.';
  }

  @override
  String yWinTight0(String opponent, String score) {
    return '$opponent $score i svaka minuta zarađena.';
  }

  @override
  String yWinTight1(String opponent, String score) {
    return 'Trebao je karakter. $opponent $score.';
  }

  @override
  String yWinTight2(String opponent, String score) {
    return '$opponent $score, na teži način, a to je onaj način koji traje.';
  }

  @override
  String yWinTight3(String opponent, String score) {
    return '$opponent $score. Ekipe koje dobivaju ovakve utakmice ostaju do lipnja.';
  }

  @override
  String yWinTight4(String opponent, String score) {
    return 'Nervozno, ružno, ali pobjeda. $opponent $score.';
  }

  @override
  String yWinTight5(String opponent, String score) {
    return '$opponent $score. Uzmi tri boda i nikad više ne gledaj snimku.';
  }

  @override
  String yWinTight6(String opponent, String score) {
    return '$opponent $score. Svaki centimetar morali smo izboriti.';
  }

  @override
  String yWinTight7(String opponent, String score) {
    return '$opponent $score. Nije lijepo. Vrijedi isto.';
  }

  @override
  String yWinTight8(String opponent, String score) {
    return '$opponent $score, a mi smo si to otežali deset puta više nego što je trebalo.';
  }

  @override
  String yWinTight9(String opponent, String score) {
    return 'Ne bismo se smjeli mučiti ovako. $opponent $score.';
  }

  @override
  String yWinTight10(String opponent, String score) {
    return '$opponent $score. Pobijedili smo, a o sebi nismo naučili ništa dobro.';
  }

  @override
  String yWinTight11(String opponent, String score) {
    return '$opponent $score, rezultat koji nam je laskao.';
  }

  @override
  String yDrew0(String opponent, String score) {
    return 'Bod. $opponent $score. Uzmi ga i idemo dalje.';
  }

  @override
  String yDrew1(String opponent, String score) {
    return '$opponent $score. Bilo je i goreg poslijepodneva.';
  }

  @override
  String yDrew2(String opponent, String score) {
    return '$opponent $score. Ne mora svaka utakmica biti priča.';
  }

  @override
  String yDrew3(String opponent, String score) {
    return '$opponent $score. Bod je bod, a tablica ne pita kako.';
  }

  @override
  String yDrew4(String opponent, String score) {
    return '$opponent $score. Dva boda izgubljena ili jedan dobiven. Biraj raspoloženje.';
  }

  @override
  String yDrew5(String opponent, String score) {
    return 'Neriješeno. $opponent $score. Nitko nije sretan, nitko nije bijesan.';
  }

  @override
  String yDrew6(String opponent, String score) {
    return '$opponent $score. Najzaboravnijih devedeset minuta godine.';
  }

  @override
  String yDrew7(String opponent, String score) {
    return '$opponent $score. Podijeljen plijen. Idemo dalje.';
  }

  @override
  String yDrew8(String opponent, String score) {
    return '$opponent $score. Ovakvim remijima kampanje tiho umiru.';
  }

  @override
  String yDrew9(String opponent, String score) {
    return 'Dva boda bačena. $opponent $score. Drukčije se to ne može nazvati.';
  }

  @override
  String yDrew10(String opponent, String score) {
    return '$opponent $score. Imali smo devedeset minuta i nikakvu zamisao što s njima.';
  }

  @override
  String yDrew11(String opponent, String score) {
    return '$opponent $score, rezultat koji nitko neće pamtiti, a svi će ga platiti.';
  }

  @override
  String yLost0(String opponent, String score) {
    return 'Poraz. $opponent $score. Događa se.';
  }

  @override
  String yLost1(String opponent, String score) {
    return '$opponent $score. Nema za što nekoga vješati. Idemo na sljedeću.';
  }

  @override
  String yLost2(String opponent, String score) {
    return '$opponent $score. Dali smo sve. Neke dane to nije dovoljno.';
  }

  @override
  String yLost3(String opponent, String score) {
    return '$opponent $score. Glavu gore. U ovoj momčadi ima još puno.';
  }

  @override
  String yLost4(String opponent, String score) {
    return '$opponent $score. Bili smo drugi najbolji i tu nema rasprave.';
  }

  @override
  String yLost5(String opponent, String score) {
    return '$opponent $score. Pregrupirati se.';
  }

  @override
  String yLost6(String opponent, String score) {
    return '$opponent $score. Nije sramota, ali nije dovoljno dobro.';
  }

  @override
  String yLost7(String opponent, String score) {
    return '$opponent $score. Nauči nešto iz toga ili je sve bilo uzalud.';
  }

  @override
  String yLost8(String opponent, String score) {
    return '$opponent $score, a nismo im ni dlaku skinuli.';
  }

  @override
  String yLost9(String opponent, String score) {
    return '$opponent $score. Isti problemi, isti mjesec, iste isprike na putu.';
  }

  @override
  String yLost10(String opponent, String score) {
    return '$opponent $score. Kada će ovo prestati biti loša sreća?';
  }

  @override
  String yLost11(String opponent, String score) {
    return '$opponent $score. Ovakav rezultat mora nekoga koštati.';
  }

  @override
  String yLostBadly0(String opponent, String score) {
    return '$opponent $score. Jedna loša noć. Sudi momčadi po kampanji, ne po ovome.';
  }

  @override
  String yLostBadly1(String opponent, String score) {
    return 'Nitko nije želio taj rezultat, $opponent $score, manje od samih igrača.';
  }

  @override
  String yLostBadly2(String opponent, String score) {
    return '$opponent $score. Ružno i nije ono što ova momčad jest.';
  }

  @override
  String yLostBadly3(String opponent, String score) {
    return '$opponent $score, rezultat za zaborav. Idući put će se oporaviti.';
  }

  @override
  String yLostBadly4(String opponent, String score) {
    return '$opponent $score. Nemam riječi, a plaćen sam da ih imam.';
  }

  @override
  String yLostBadly5(String opponent, String score) {
    return '$opponent $score. Netko za to mora odgovarati.';
  }

  @override
  String yLostBadly6(String opponent, String score) {
    return 'Želim da se $opponent $score izbriše iz zapisnika i iz sjećanja.';
  }

  @override
  String yLostBadly7(String opponent, String score) {
    return '$opponent $score. Ovakav rezultat nema smisla uljepšavati.';
  }

  @override
  String yLostBadly8(String opponent, String score) {
    return 'To nije bio poraz, to je bila predaja. $opponent $score.';
  }

  @override
  String yLostBadly9(String opponent, String score) {
    return '$opponent $score. Ljudi su platili novac da gledaju to.';
  }

  @override
  String yLostBadly10(String opponent, String score) {
    return '$opponent $score. Ako se ovo ništa ne promijeni, neće ni ništa drugo.';
  }

  @override
  String yLostBadly11(String opponent, String score) {
    return 'Vidio sam ovu momčad i poniženu, ali $opponent $score novo je dno.';
  }

  @override
  String yTrophy0(String opponent) {
    return 'PRVACI. $opponent. Reci to naglas.';
  }

  @override
  String yTrophy1(String opponent) {
    return 'Osvojili smo. $opponent. Nisam dobro.';
  }

  @override
  String yTrophy2(String opponent) {
    return '$opponent, a trofej ide kući.';
  }

  @override
  String yTrophy3(String opponent) {
    return 'Svaki od njih legenda. $opponent.';
  }

  @override
  String yRunnerUp0(String opponent) {
    return 'Tako blizu. $opponent i medalja koju nitko ne želi.';
  }

  @override
  String yRunnerUp1(String opponent) {
    return '$opponent: drugo mjesto. Boljet će godinama.';
  }

  @override
  String yRunnerUp2(String opponent) {
    return '$opponent: jedna utakmica do svega.';
  }

  @override
  String yRunnerUp3(String opponent) {
    return '$opponent: drugi. Neka netko doda bocu.';
  }

  @override
  String yEliminated0(String opponent) {
    return '$opponent: ispali smo. Ovo će neko vrijeme boljeti.';
  }

  @override
  String yEliminated1(String opponent) {
    return '$opponent je mjesto gdje za nas sve završava.';
  }

  @override
  String yEliminated2(String opponent) {
    return '$opponent: ispadanje. Sad slijedi istraga.';
  }

  @override
  String yEliminated3(String opponent) {
    return '$opponent: ispali smo. Neka mi netko objasni to.';
  }

  @override
  String yQualified0(String opponent) {
    return 'IDEMO NA TURNIR: $opponent.';
  }

  @override
  String yQualified1(String opponent) {
    return 'Kvalificirani: $opponent. Rezerviraj slobodne dane na poslu.';
  }

  @override
  String yQualified2(String opponent) {
    return '$opponent, stižemo. Nikad nije bilo sumnje (sumnje je bilo apsolutno svugdje).';
  }

  @override
  String yQualified3(String opponent) {
    return '$opponent: prolaz. Najteži dio je gotov.';
  }

  @override
  String yGroupDrawn0(String opponent) {
    return 'Skupina izvučena za turnir $opponent. Moglo je biti gore. Moglo je biti puno gore.';
  }

  @override
  String yGroupDrawn1(String opponent) {
    return 'Dakle, to je ždrijeb za $opponent. Zanimljivo.';
  }

  @override
  String yGroupDrawn2(String opponent) {
    return 'Skupine za $opponent su izašle i naša mi se već ne sviđa.';
  }

  @override
  String yGroupDrawn3(String opponent) {
    return 'Ždrijeb za $opponent gotov. Neka počne pretjerivanje.';
  }

  @override
  String yHostNamed0(String opponent) {
    return 'Domaćin: $opponent. Počni štedjeti.';
  }

  @override
  String yHostNamed1(String opponent) {
    return 'Ide u zemlju: $opponent. Predvidljivo, ali u redu.';
  }

  @override
  String yHostNamed2(String opponent) {
    return 'Turnir dobiva $opponent. Čestitke njima, valjda.';
  }

  @override
  String yHostNamed3(String opponent) {
    return 'Domaćini potvrđeni: $opponent.';
  }

  @override
  String yTournamentSoon0(String opponent) {
    return 'Uskoro počinje $opponent i ne mogu mirno sjediti.';
  }

  @override
  String yTournamentSoon1(String opponent) {
    return 'Još malo do natjecanja $opponent.';
  }

  @override
  String yTournamentSoon2(String opponent) {
    return '$opponent je skoro tu. Popis igrača, molim.';
  }

  @override
  String yTournamentSoon3(String opponent) {
    return 'Odbrojavanje do natjecanja $opponent službeno je nepodnošljivo.';
  }

  @override
  String get navY => 'Y';

  @override
  String get yTitle => 'Y';

  @override
  String get yEmpty => 'Još nema što reći. Odigraj utakmicu.';

  @override
  String get yEarlierHeading => 'Ranije u ovom ciklusu';

  @override
  String get yTraitLoyalist =>
      'Podržava momčad što god se dogodilo. Sporo se okreće, brzo oprašta.';

  @override
  String get yTraitCynic =>
      'Pretpostavlja najgore i oduševljen je kad se pokaže u pravu.';

  @override
  String get yTraitNostalgic =>
      'Sve je prije bilo bolje. Mjeri te prema ljudima koji su se umirovili.';

  @override
  String get yTraitStatshead =>
      'Objavljuje brojke i ništa drugo. Jedva da ima raspoloženje.';

  @override
  String get yTraitHypeman => 'Dva dobra rezultata i već je zlatna generacija.';

  @override
  String get yTraitContrarian => 'Što god soba misli, on misli suprotno.';

  @override
  String get yTraitDoomer => 'Krenut će po zlu. Uvijek će krenuti po zlu.';

  @override
  String get yProfilePosts => 'OBJAVE';

  @override
  String get yProfileEmpty => 'Još ništa s ovog računa.';

  @override
  String hubEventGrievance(String player) {
    return '$player želi razgovor';
  }

  @override
  String get hubEventGrievanceSub => 'Želi znati gdje stoji';

  @override
  String hubEventManagerSkills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bodova vještine za potrošiti',
      few: '$count boda vještine za potrošiti',
      one: '$count bod vještine za potrošiti',
    );
    return '$_temp0';
  }

  @override
  String get hubEventManagerSkillsSub =>
      'Ono u čemu si dobar čini tvoju momčad boljom';

  @override
  String get grievanceTitle => 'Razgovor u tvom uredu';

  @override
  String grievanceGameTime(String player) {
    return '$player je u sastavu, a nije takao loptu. Želi znati zašto.';
  }

  @override
  String grievanceSquadPlace(String player) {
    return '$player nije u sastavu i ne razumije zašto. Želi da mu se kaže, ovako ili onako.';
  }

  @override
  String grievanceRole(String player) {
    return '$player stalno igra izvan svoje pozicije i dosta mu je.';
  }

  @override
  String get grievanceReassure => 'Računam na tebe';

  @override
  String get grievanceHonest => 'Iza drugih si, evo zašto';

  @override
  String get grievanceDismiss => 'Ja biram sastav';

  @override
  String yScorerStar0(String name, String goals) {
    return '$name je dao $goals. Nitko drugi nije ni blizu.';
  }

  @override
  String yScorerStar1(String name, String goals) {
    return '$goals za $name. On nosi ovu momčad.';
  }

  @override
  String yScorerStar2(String name, String goals) {
    return '$name: $goals u jednom danu. Igrač, nema što.';
  }

  @override
  String yScorerStar3(String name, String goals) {
    return '$goals im je zabio $name. Naklon.';
  }

  @override
  String yScorerStar4(String name, String goals) {
    return '$goals za $name, a ostali su bili putnici.';
  }

  @override
  String yScorerStar5(String name, String goals) {
    return 'Opet $name. $goals. Zamisli ovu momčad bez njega.';
  }

  @override
  String yScorerStar6(String name, String goals) {
    return '$goals od $name. Jedan čovjek ne bi smio nositi toliko.';
  }

  @override
  String yScorerStar7(String name, String goals) {
    return 'Makni $name iz toga i ostaje $goals manje i sasvim drukčije poslijepodne.';
  }

  @override
  String yWinStreak0(String count) {
    return '$count zaredom. Što god se govori u toj svlačionici, upalilo je.';
  }

  @override
  String yWinStreak1(String count) {
    return 'To je $count zaredom. Momčadi ne posrnu u ovakve nizove.';
  }

  @override
  String yWinStreak2(String count) {
    return '$count zaredom i nastavlja se. Samopouzdanje se vidi s tribina.';
  }

  @override
  String yWinStreak3(String count) {
    return 'Bez poraza u $count. Pitaj bilo koga tko je vodio momčad: to je najteži dio.';
  }

  @override
  String yWinStreak4(String count) {
    return '$count zaredom. Uživaj dok je raspored blag.';
  }

  @override
  String yWinStreak5(String count) {
    return '$count zaredom, a nismo pobijedili nikoga bitnog.';
  }

  @override
  String yWinStreak6(String count) {
    return 'Niz od $count. Pitaj me opet kad ga netko provjeri.';
  }

  @override
  String yWinStreak7(String count) {
    return '$count u nizu. Svaka momčad jednom ima ovo u sebi.';
  }

  @override
  String yLossStreak0(String count) {
    return '$count bez pobjede. U nekom trenutku isprike ponestane.';
  }

  @override
  String yLossStreak1(String count) {
    return 'Propalo je $count zaredom. Ovo više nije kiks.';
  }

  @override
  String yLossStreak2(String count) {
    return '$count poraza zaredom. Netko mora odgovarati.';
  }

  @override
  String yLossStreak3(String count) {
    return 'Bez pobjede u $count. Vidi se po tome kako igraju.';
  }

  @override
  String yLossStreak4(String count) {
    return '$count bez pobjede i iste greške svaki tjedan.';
  }

  @override
  String yLossStreak5(String count) {
    return '$count zaredom. Što god se pokušava, ne radi.';
  }

  @override
  String yLossStreak6(String count) {
    return '$count zaredom. Ovo je smjer, a ne pad.';
  }

  @override
  String yLossStreak7(String count) {
    return 'Bez pobjede u $count, a gore nitko nije ni riječ rekao.';
  }

  @override
  String yRivalry0(String opponent, String score) {
    return '$opponent $score. Govori što hoćeš o nogometu. Ova vrijedi dvostruko.';
  }

  @override
  String yRivalry1(String opponent, String score) {
    return 'Baš protiv njih. $opponent $score. Nitko ovdje to neće zaboraviti.';
  }

  @override
  String yRivalry2(String opponent, String score) {
    return '$opponent $score. O ovoj će se pričati u kafićima.';
  }

  @override
  String yRivalry3(String opponent, String score) {
    return 'Susjedi, $score. Pravo na hvalisanje riješeno na neko vrijeme.';
  }

  @override
  String yRivalry4(String opponent, String score) {
    return '$opponent $score. Što god se još dogodi ove godine, ovo imamo.';
  }

  @override
  String yRivalry5(String opponent, String score) {
    return '$opponent $score. Nekima od nas to je trebalo više nego tablici.';
  }

  @override
  String yRivalry6(String opponent, String score) {
    return '$opponent $score. A oni će to vratiti idući put, uvijek vrate.';
  }

  @override
  String yRivalry7(String opponent, String score) {
    return '$opponent $score. Cijelu ćemo godinu slušati o ovoj utakmici.';
  }

  @override
  String yInjuryBlow0(String name) {
    return '$name ozlijeđen izlazi. To je zadnje što je ovoj momčadi trebalo.';
  }

  @override
  String yInjuryBlow1(String name) {
    return 'Gubitak igrača $name mijenja oblik svega.';
  }

  @override
  String yInjuryBlow2(String name) {
    return '$name šepa. Zadrži dah.';
  }

  @override
  String yInjuryBlow3(String name) {
    return 'Dakle, neko vrijeme bez igrača $name. Netko mora stati na njegovo mjesto.';
  }

  @override
  String yInjuryBlow4(String name) {
    return '$name ispada. Naravno da je baš $name.';
  }

  @override
  String yInjuryBlow5(String name) {
    return 'Bez igrača $name ovo postaje posve obična momčad.';
  }

  @override
  String yInjuryBlow6(String name) {
    return '$name opet ozlijeđen. Netko bi se trebao pitati zašto.';
  }

  @override
  String yInjuryBlow7(String name) {
    return 'Izgubili smo igrača $name, a iza njega nema nikoga. To je pravi problem.';
  }

  @override
  String ySentOff0(String name, String minute) {
    return 'Crveni za $name u $minute. minuti i cijela zemlja okreće se protiv njega. Dao nam je više od većine. Pustite ga.';
  }

  @override
  String ySentOff1(String name, String minute) {
    return '$name isključen u $minute. minuti. Tvrdo. S desetoricom smo se ipak borili, a to nešto govori.';
  }

  @override
  String ySentOff2(String name, String minute) {
    return '$name, $minute. minuta, crveni karton. Od tamo u desetoricu.';
  }

  @override
  String ySentOff3(String name, String minute) {
    return 'Isključenje: $name u $minute. minuti. Nije prva utakmica koju je odlučila jedna odluka.';
  }

  @override
  String ySentOff4(String name, String minute) {
    return 'Sjajno. $name odlazi u $minute. minuti i opet smo u desetoricu.';
  }

  @override
  String ySentOff5(String name, String minute) {
    return '$name isključen u $minute. minuti. Tko ovdje točno trenira disciplinu?';
  }

  @override
  String ySentOff6(String name, String minute) {
    return '$minute minuta. Toliko je $name uspio zadržati živce. Profesionalni nogomet.';
  }

  @override
  String ySentOff7(String name, String minute) {
    return 'Crveni za $name u $minute. minuti, a ja bih trebao povjerovati da je ovo napredak.';
  }

  @override
  String get yBoardPressure0 =>
      'Odbor je jako utihnuo. To nikad nije dobar znak.';

  @override
  String get yBoardPressure1 =>
      'Priča se da su u upravi počeli postavljati pitanja.';

  @override
  String get yBoardPressure2 => 'Osjeća se kako se tlo pomiče na katu iznad.';

  @override
  String get yBoardPressure3 =>
      'Nitko u savezu ne govori ništa potporno. Izvuci svoje zaključke.';

  @override
  String get yBoardPressure4 => 'Tjednima ga nitko gore nije javno podržao.';

  @override
  String get yBoardPressure5 =>
      'Savez šapće protiv vlastitog izbornika. Kao i uvijek.';

  @override
  String get yBoardPressure6 => 'Kad uprava utihne, već su odlučili.';

  @override
  String get yBoardPressure7 =>
      'Pustit će da se ovo otegne dok odluka ne postane tuđa.';

  @override
  String get yReplies => 'JOŠ O OVOJ UTAKMICI';

  @override
  String get yPlayerGrievance0 => 'Pitao sam gdje stojim. Još čekam odgovor.';

  @override
  String get yPlayerGrievance1 => 'Naporno treniram. Ne mogu ništa drugo.';

  @override
  String get yPlayerGrievance2 => 'Neka pitanja možeš postaviti samo jednom.';

  @override
  String get yPlayerGrievance3 => 'Nisam došao dovde da nosim prsluke.';

  @override
  String get playerHonoursTitle => 'ODLIČJA';

  @override
  String get awardGoldenBall => 'Zlatna lopta';

  @override
  String get awardGoldenBoot => 'Zlatna kopačka';

  @override
  String get awardGoldenGlove => 'Zlatne rukavice';

  @override
  String get awardTeamOfTournament => 'Momčad turnira';

  @override
  String get awardPlayerOfYear => 'Svjetski igrač godine';

  @override
  String get awardYoungPlayerOfYear => 'Mladi igrač godine';

  @override
  String get playerClubHistory => 'POVIJEST KLUBOVA';

  @override
  String get playerCareerRecord => 'KARIJERNI REKORD';

  @override
  String get playerInternationalGoals => 'Golovi za reprezentaciju';

  @override
  String get playerRecentForm => 'NEDAVNA FORMA';

  @override
  String get playerMatchHistory => 'POVIJEST UTAKMICA';

  @override
  String get playerAttributes => 'ATRIBUTI';

  @override
  String get playerUnknown => 'Nepoznato';

  @override
  String get playerAttrPace => 'Brzina';

  @override
  String get playerAttrPhysical => 'Fizika';

  @override
  String get playerAttrTechnical => 'Tehnika';

  @override
  String get playerAttrShooting => 'Šut';

  @override
  String get playerAttrPassing => 'Dodavanje';

  @override
  String get playerAttrDribbling => 'Driblanje';

  @override
  String get playerAttrTackling => 'Startanje';

  @override
  String get playerAttrPositioning => 'Postavljanje';

  @override
  String get playerAttrComposure => 'Smirenost';

  @override
  String get playerAttrDecisions => 'Odlučivanje';

  @override
  String get playerAttrStamina => 'Izdržljivost';

  @override
  String get playerAttrStrength => 'Snaga';

  @override
  String get playerStatCaps => 'Nastupi';

  @override
  String get playerStatGoals => 'Golovi';

  @override
  String get playerStatAssists => 'Asistencije';

  @override
  String get playerStatAvgRating => 'Prosj. ocjena';

  @override
  String get playerStatForm => 'Forma';

  @override
  String get playerStatMotm => 'Igrač utakmice';

  @override
  String get playerStatCleanSheets => 'Bez primljenog';

  @override
  String get playerStatBestGame => 'Najbolja utakmica';

  @override
  String get playerStatCards => 'Kartoni';

  @override
  String playerCardsValue(int yellows, int reds) {
    return '$yellowsŽ ${reds}C';
  }

  @override
  String get tourSharedYourRun => 'TVOJ PUT';

  @override
  String get tourSharedList => 'Popis';

  @override
  String get tourSharedBracket => 'Kostur';

  @override
  String get tourSharedVs => 'vs';

  @override
  String tourSharedGroupSeed(String seed) {
    return 'Skupina $seed';
  }

  @override
  String get tourSharedThisEdition => 'Ovo izdanje';

  @override
  String get tourSharedAllTime => 'Svih vremena';

  @override
  String get tourSharedUnknown => 'Nepoznato';

  @override
  String get tourSharedActive => 'AKTIVAN';

  @override
  String get tourSharedMedalTable => 'TABLICA MEDALJA';

  @override
  String get tourSharedPastWinners => 'PRETHODNI POBJEDNICI';

  @override
  String tourSharedHost(String host) {
    return 'Domaćin: $host';
  }

  @override
  String get tourSharedBeat => 'svladali';

  @override
  String get tourSharedPens => ' (pen.)';

  @override
  String get tourSharedAwardsEmpty =>
      'Nagrade se dodjeljuju kad se turnir odigra do kraja.';

  @override
  String get tourSharedGoldenBall => 'ZLATNA LOPTA';

  @override
  String get tourSharedPlayerOfTournament => 'Igrač turnira';

  @override
  String get tourSharedGoldenBoot => 'ZLATNA KOPAČKA';

  @override
  String tourSharedGoalsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count golova',
      few: '$count gola',
      one: '$count gol',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedGoldenGlove => 'ZLATNE RUKAVICE';

  @override
  String get tourSharedTeamOfTournament => 'MOMČAD TURNIRA';

  @override
  String get tourSharedStatsEmpty =>
      'Rekordi se pojavljuju kad natjecanje dobije nešto povijesti.';

  @override
  String get tourSharedRecordScorer => 'REKORDER PO GOLOVIMA';

  @override
  String get tourSharedStillActive => 'još aktivan';

  @override
  String get tourSharedMostTitles => 'NAJVIŠE NASLOVA';

  @override
  String tourSharedTitlesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count naslova',
      few: '$count naslova',
      one: '$count naslov',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostFinals => 'NAJVIŠE FINALA';

  @override
  String tourSharedFinalsContested(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count odigranih finala',
      few: '$count odigrana finala',
      one: '$count odigrano finale',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostGamesPlayed => 'NAJVIŠE ODIGRANIH UTAKMICA';

  @override
  String tourSharedMatchesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count utakmica',
      few: '$count utakmice',
      one: '$count utakmica',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostFinalsPlayed => 'NAJVIŠE ODIGRANIH FINALNIH TURNIRA';

  @override
  String tourSharedFinalsTournamentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count finalnih turnira',
      few: '$count finalna turnira',
      one: '$count finalni turnir',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedBiggestFinalWin => 'NAJVEĆA POBJEDA U FINALU';

  @override
  String tourStatsGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count golova',
      few: '$count gola',
      one: '$count gol',
    );
    return '$_temp0';
  }

  @override
  String get tourStatsStillActive => 'još aktivan';

  @override
  String tourStatsTitles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count naslova',
      few: '$count naslova',
      one: '$count naslov',
    );
    return '$_temp0';
  }

  @override
  String tourStatsFinalsContested(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count odigranih finala',
      few: '$count odigrana finala',
      one: '$count odigrano finale',
    );
    return '$_temp0';
  }

  @override
  String tourStatsMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count utakmica',
      few: '$count utakmice',
      one: '$count utakmica',
    );
    return '$_temp0';
  }

  @override
  String tourStatsFinalsTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count finalnih turnira',
      few: '$count finalna turnira',
      one: '$count finalni turnir',
    );
    return '$_temp0';
  }

  @override
  String get tourStatsLeaders => 'VODEĆI SVIH VREMENA';

  @override
  String get tourStatsTabGames => 'Utakmice';

  @override
  String get tourStatsTabCups => 'Turniri';

  @override
  String get tourStatsTabScorers => 'Strijelci';

  @override
  String tourSharedFinalWinDetail(String opponent, int year) {
    return 'vs $opponent · $year';
  }

  @override
  String get tourHolders => 'BRANITELJI';

  @override
  String tourHoldersSince(int year) {
    return 'osvojeno $year';
  }

  @override
  String get tourSharedAllTimeScorers => 'STRIJELCI SVIH VREMENA';

  @override
  String get tourSharedSummaryEmpty =>
      'Domaćin i stadioni pojavljuju se nakon ždrijeba ovog izdanja.';

  @override
  String get tourSharedHostHeading => 'DOMAĆIN';

  @override
  String get tourSharedHostsHeading => 'DOMAĆINI';

  @override
  String get tourSharedCoHostsHeading => 'SUDOMAĆINI';

  @override
  String get tourSharedVenues => 'STADIONI';

  @override
  String get tourSharedMascot => 'MASKOTA';

  @override
  String get tourSharedMatchBall => 'SLUŽBENA LOPTA';

  @override
  String tourSharedVenueSeats(String city, String capacity) {
    return '$city · $capacity mjesta';
  }

  @override
  String get tourSharedCouldNotLoad => 'Nije moguće učitati.';

  @override
  String get tourSharedHostTbc => 'DOMAĆIN ĆE BITI POTVRĐEN';

  @override
  String get tourSharedFinalsAreHere => 'ZAVRŠNICA JE TU';

  @override
  String tourSharedHostedBy(String hosts) {
    return 'DOMAĆIN  $hosts';
  }

  @override
  String get tourSharedLetFinalsBegin => 'Neka počne završnica';

  @override
  String get tourSharedCompetitions => 'NATJECANJA';

  @override
  String get tourSharedWorldRanking => 'Svjetska ljestvica';

  @override
  String get tourSharedCouldNotLoadTournaments =>
      'Turnire nije moguće učitati.';

  @override
  String get tourSharedPrestigeStage => 'PRESTIŽNA POZORNICA';

  @override
  String get tourSharedOverview => 'Pregled';

  @override
  String get tourSharedWorldRankingTitle => 'Svjetska ljestvica';

  @override
  String get tourSharedYourCompetitions => 'TVOJA NATJECANJA';

  @override
  String get tourSharedOtherContinents => 'OSTALI KONTINENTI';

  @override
  String get tourSharedComingSoon => 'Turnir uskoro';

  @override
  String get tourSharedSoon => 'USKORO';

  @override
  String get tourSharedNoQualifyingDraw => 'Nema ždrijeba kvalifikacija.';

  @override
  String get tourSharedOpenEnvelope => 'Otvori omotnicu';

  @override
  String tourSharedGroupName(String name) {
    return 'SKUPINA $name';
  }

  @override
  String get tourSharedBall => 'Kuglica';

  @override
  String get tourSharedPot => 'Šešir';

  @override
  String get tourSharedAll => 'Sve';

  @override
  String get tourSharedTapDrawTeam => 'Dodirni za izvlačenje sljedeće ekipe';

  @override
  String get tourSharedTapDrawPot => 'Dodirni za izvlačenje sljedećeg šešira';

  @override
  String get tourSharedTapDrawAll => 'Dodirni za otkrivanje cijelog ždrijeba';

  @override
  String get tourSharedContinue => 'Nastavi';

  @override
  String get tourSharedPause => 'Pauza';

  @override
  String get tourSharedPlay => 'Pokreni';

  @override
  String get tourSharedSkip => 'Preskoči';

  @override
  String tourSharedPotNumber(int number) {
    return 'ŠEŠIR $number';
  }

  @override
  String get tourSharedDrawComplete => 'ŽDRIJEB ZAVRŠEN';

  @override
  String get tourSharedDrawing => 'IZVLAČENJE…';

  @override
  String get tourContChampionship => 'PRVENSTVO';

  @override
  String get tourContTabSummary => 'SAŽETAK';

  @override
  String get tourContTabQualifying => 'KVALIFIKACIJE';

  @override
  String get tourContTabFinals => 'ZAVRŠNICA';

  @override
  String get tourContTabBracket => 'KOSTUR';

  @override
  String get tourContTabAwards => 'NAGRADE';

  @override
  String get tourContTabScorers => 'STRIJELCI';

  @override
  String get tourContTabHistory => 'POVIJEST';

  @override
  String get tourContTabRecords => 'REKORDI';

  @override
  String tourContCouldNotLoadCup(String error) {
    return 'Kup nije moguće učitati.\n$error';
  }

  @override
  String get tourContNoCupData => 'Nema podataka o kupu.';

  @override
  String get tourContUnknown => 'Nepoznato';

  @override
  String get tourContGroupsToBeDrawnQual =>
      'Skupine kvalifikacija izvlače se na svečanosti. Gledaj s početne da vidiš s kim igraš.';

  @override
  String get tourContQualSeeded =>
      'Tvoja je reprezentacija postavljena izravno u završnicu. U ovom ciklusu nema kvalifikacija.';

  @override
  String tourContBackgroundRegion(String name) {
    return '$name se simulira u pozadini. Rezultati se ovdje pojavljuju kako se igra svako kolo.';
  }

  @override
  String get tourContGroupsToBeDrawnFinals =>
      'Skupine završnice izvlače se na svečanosti. Gledaj s početne da vidiš svoju skupinu.';

  @override
  String get tourContFinalsDrawAfterQual =>
      'Ždrijeb završnice održava se kad kvalifikacije završe.';

  @override
  String get tourContContestedBeforeWc =>
      'Nokaut-faze igraju se prije Svjetskog prvenstva.';

  @override
  String tourContChampionsHeading(String name) {
    return 'PRVACI: $name';
  }

  @override
  String tourContWinnersTitle(String name) {
    return 'Pobjednici: $name';
  }

  @override
  String get tourContNoGoalsYet => 'Još nema postignutih golova.';

  @override
  String tourContGroupHeading(String name) {
    return 'SKUPINA $name';
  }

  @override
  String get tourContBestRunnersUp => 'NAJBOLJI DRUGOPLASIRANI';

  @override
  String tourContGroupDropdown(String name) {
    return 'Skupina $name';
  }

  @override
  String get tourContMatches => 'UTAKMICE';

  @override
  String get tourContNoGroupsDrawn => 'Skupine još nisu izvučene.';

  @override
  String get tourContQualifyingDraw => 'ŽDRIJEB KVALIFIKACIJA';

  @override
  String get tourContWorldQualifyingDraw => 'SVJETSKI ŽDRIJEB KVALIFIKACIJA';

  @override
  String get tourContFinalsDraw => 'ŽDRIJEB ZAVRŠNICE';

  @override
  String get tourContSeedingPots => 'ŠEŠIRI NOSITELJA';

  @override
  String get tourContGroupDraw => 'ŽDRIJEB SKUPINA';

  @override
  String tourContCouldNotLoadDraw(String error) {
    return 'Ždrijeb nije moguće učitati.\n$error';
  }

  @override
  String get tourContDrawNotReady => 'Ždrijeb još nije spreman.';

  @override
  String get tourContContinentalClash => 'CONTINENTAL CLASH';

  @override
  String get tourContTabThisCycle => 'OVAJ CIKLUS';

  @override
  String tourContCouldNotLoadClash(String error) {
    return 'Nije moguće učitati.\n$error';
  }

  @override
  String get tourContNoSaveFound => 'Spremljena igra nije pronađena.';

  @override
  String get tourContClashSoon =>
      'Continental Clash igra se kad se znaju oba kontinentalna prvaka.';

  @override
  String get tourContTwoContinentsOneMatch => 'DVA KONTINENTA, JEDNA UTAKMICA';

  @override
  String get tourContVersusShort => 'vs';

  @override
  String tourContWinTheClash(String name) {
    return '$name osvaja Clash';
  }

  @override
  String get tourContNoClashYet => 'Continental Clash još nije odigran.';

  @override
  String get tourContNationsCup => 'NATIONS CUP';

  @override
  String get tourContTabLeagues => 'LIGE';

  @override
  String get tourContTabFinalsFour => 'FINAL FOUR';

  @override
  String tourContCouldNotLoad(String error) {
    return 'Učitavanje nije uspjelo.\n$error';
  }

  @override
  String get tourContNoNationsCupGoals =>
      'Još nema zabilježenih golova u natjecanju Nations Cup.';

  @override
  String get tourContNoNationsCupChampions =>
      'Još nema prvaka natjecanja Nations Cup.';

  @override
  String get tourContNationsCupOffSeason =>
      'Nations Cup ovog ciklusa počinje nakon kontinentalnih završnica. Prošle pobjednike potraži u Povijesti.';

  @override
  String get tourContNationsCupGroupsSoon =>
      'Skupine natjecanja Nations Cup ovog ciklusa izvlače se na ceremoniji. Gledaj s početne da vidiš koga čekaš.';

  @override
  String get tourContLeagueNoGroups => 'U ovoj ligi nema utakmica u ovom kolu.';

  @override
  String tourContLeagueHeading(String letter) {
    return 'LIGA $letter';
  }

  @override
  String tourContLeagueHeadingYours(String letter) {
    return 'LIGA $letter · TVOJA LIGA';
  }

  @override
  String get tourContFinalsFourSoon =>
      'Final Four igraju pobjednici skupina Lige A kad završi natjecanje po skupinama.';

  @override
  String tourContLeagueChip(String letter) {
    return 'Liga $letter';
  }

  @override
  String tourContLeagueChipStar(String letter) {
    return 'Liga $letter ★';
  }

  @override
  String get tourContSemiFinals => 'POLUFINALE';

  @override
  String get tourContFinal => 'FINALE';

  @override
  String get tourContNationsCupDraw => 'ŽDRIJEB: NATIONS CUP';

  @override
  String get tourContIntercontinentalPlayoff => 'INTERKONTINENTALNI PLAY-OFF';

  @override
  String get tourContNoPlayoffThisCycle => 'Ovaj ciklus nema play-offa.';

  @override
  String get tourContPlayoffIntro =>
      'Dva mjesta na Svjetskom prvenstvu odlučuju se nokaut-turnirom najboljih neuspješnih kvalifikanata.';

  @override
  String get tourContPlayoffThrough =>
      'Prošao si play-off. Ideš na Svjetsko prvenstvo!';

  @override
  String get tourContPlayoffOut =>
      'Nisi uspio u play-offu. Ovaj put nema Svjetskog prvenstva.';

  @override
  String get tourContContinue => 'Nastavi';

  @override
  String get tourContPlayoffFinals => 'FINALE PLAY-OFFA';

  @override
  String get tourContPlayoffSeeded => 'Nositelj (slobodan prolaz)';

  @override
  String get tourCupTabSummary => 'SAŽETAK';

  @override
  String get tourCupTabQualifying => 'KVALIFIKACIJE';

  @override
  String get tourCupTabPlayoff => 'PLAY-OFF';

  @override
  String get tourCupPlayoffSoon =>
      'Interkontinentalni play-off odlučuje se kad završe kvalifikacije svih konfederacija.';

  @override
  String get tourCupTabFinals => 'ZAVRŠNICA';

  @override
  String get tourCupTabBracket => 'KOSTUR';

  @override
  String get tourCupTabAwards => 'NAGRADE';

  @override
  String get tourCupTabScorers => 'STRIJELCI';

  @override
  String get tourCupTabHistory => 'POVIJEST';

  @override
  String get tourCupTabRecords => 'REKORDI';

  @override
  String get tourCupTitle => 'SVJETSKO PRVENSTVO';

  @override
  String get tourCupNoData => 'Nema podataka o natjecanju.';

  @override
  String tourCupLoadError(String error) {
    return 'Učitavanje natjecanja nije uspjelo.\n$error';
  }

  @override
  String get tourCupUnknown => 'Nepoznato';

  @override
  String get tourCupWorldChampions => 'SVJETSKI PRVACI';

  @override
  String get tourCupWorldChampionsTitle => 'Svjetski prvaci';

  @override
  String get tourCupStillActive => 'Još aktivan';

  @override
  String get tourCupAllTimeScorers => 'STRIJELCI SVIH VREMENA';

  @override
  String get tourCupAllConfederations => 'Sve konfederacije';

  @override
  String get tourCupBestRunnersUp => 'Najbolji drugoplasirani';

  @override
  String get tourCupCompWorld => 'Svjetsko prvenstvo';

  @override
  String get tourCupCompEurope => 'Europsko prvenstvo';

  @override
  String get tourCupCompSAmerica => 'Kup Južne Amerike';

  @override
  String get tourCupDestRoundOf16 => 'osminu finala';

  @override
  String get tourCupDestKnockouts => 'nokaut-fazu';

  @override
  String get tourCupDestFinals => 'završnicu';

  @override
  String get tourCupDestFinalsPlayoff => 'play-off za završnicu';

  @override
  String get tourCupDestIntercontPlayoff => 'interkontinentalni play-off';

  @override
  String get tourCupFinalsDrawnAfterQual =>
      'Završnica se izvlači kad završe kvalifikacije.';

  @override
  String get tourCupFinalsDrawSoon =>
      'Skupine tek treba izvući. Gledaj ždrijeb Svjetskog prvenstva s početne da ih otkriješ.';

  @override
  String tourCupGroupName(String name) {
    return 'Skupina $name';
  }

  @override
  String tourCupGroupNameShort(String name) {
    return 'Skupina $name';
  }

  @override
  String tourCupHostLabel(String host) {
    return 'Domaćin: $host';
  }

  @override
  String tourCupHostLabelMulti(String hosts) {
    return 'Domaćini: $hosts';
  }

  @override
  String get tourCupIntercontPlayoff => 'Interkontinentalni play-off';

  @override
  String get tourCupKnockoutSoon =>
      'Kostur počinje kad završi natjecanje po skupinama.';

  @override
  String get tourCupMatches => 'UTAKMICE';

  @override
  String get tourCupMedalTable => 'TABLICA MEDALJA';

  @override
  String get tourCupMostTitles => 'NAJVIŠE NASLOVA';

  @override
  String tourCupMostTitlesValue(String nation, int titles, int editions) {
    String _temp0 = intl.Intl.pluralLogic(
      titles,
      locale: localeName,
      other: '$titles naslova',
      few: '$titles naslova',
      one: '$titles naslov',
    );
    String _temp1 = intl.Intl.pluralLogic(
      editions,
      locale: localeName,
      other: '$editions izdanja',
      few: '$editions izdanja',
      one: '$editions izdanju',
    );
    return '$nation: $_temp0 u $_temp1';
  }

  @override
  String get tourCupNoGoals => 'Još nema golova.';

  @override
  String get tourCupNoGroups => 'Skupine nisu izvučene.';

  @override
  String get tourCupNoHistory => 'Još nema povijesti.';

  @override
  String get tourCupPastWinners => 'PRETHODNI POBJEDNICI';

  @override
  String get tourCupPlayoffIntro =>
      'Dva mjesta na Svjetskom prvenstvu odlučuju se nokaut-turnirom najboljih neuspješnih kvalifikanata.';

  @override
  String get tourCupQualDrawSoon =>
      'Skupine tek treba izvući. Gledaj ždrijeb kvalifikacija s početne da ih otkriješ.';

  @override
  String tourCupRegionYours(String region) {
    return '$region · tvoja';
  }

  @override
  String tourCupScorePens(int home, int away) {
    return '$home–$away (pen.)';
  }

  @override
  String get tourCupSegAllTime => 'Svih vremena';

  @override
  String get tourCupSegFinals => 'Završnica';

  @override
  String get tourCupSegQualifying => 'Kvalifikacije';

  @override
  String get playerTraitsTitle => 'POZNAT PO';

  @override
  String get traitBigGame => 'Igrač za velike utakmice';

  @override
  String get traitBigGameBlurb => 'Diže razinu u nokaut-dvobojima.';

  @override
  String get traitSetPiece => 'Specijalist za stajalice';

  @override
  String get traitSetPieceBlurb =>
      'Bolje izvodi i postiže više golova iz stajalica.';

  @override
  String get traitHothead => 'Vruće glave';

  @override
  String get traitHotheadBlurb => 'Skuplja znatno više kartona od suigrača.';

  @override
  String get traitIronMan => 'Željezni';

  @override
  String get traitIronManBlurb => 'Rijetko se ozlijedi i sporije se umara.';

  @override
  String get traitWonderkid => 'Wonderkid';

  @override
  String get traitWonderkidBlurb => 'Mlad, već dobar i još brzo napreduje.';

  @override
  String get traitLeader => 'Vođa';

  @override
  String get traitLeaderBlurb => 'Podiže svakog suigrača na terenu.';

  @override
  String get traitPacey => 'Brzonog';

  @override
  String get traitPaceyBlurb =>
      'Svjetlosna brzina, stalna prijetnja iza leđa obrane.';

  @override
  String get traitOldHead => 'Iskusni lisac';

  @override
  String get traitOldHeadBlurb => 'Veteran čije čitanje igre nadživi noge.';

  @override
  String get traitWasteful => 'Rastrošan';

  @override
  String get traitWastefulBlurb => 'Previše dobrih prilika šalje pokraj gola.';

  @override
  String get objectiveWorldCup => 'Svjetsko prvenstvo';

  @override
  String get objectiveWinTournament => 'Osvoji naslov';

  @override
  String get objectiveQualifyGeneric => 'Kvalificiraj se';

  @override
  String hubBoardObjectiveFor(String competition, String label) {
    return '$competition: $label';
  }

  @override
  String get objectiveWinWorldCup => 'Osvoji Svjetsko prvenstvo';

  @override
  String get objectiveReachFinal => 'Stigni do finala';

  @override
  String get objectiveReachSemis => 'Stigni do polufinala';

  @override
  String get objectiveReachQuarters => 'Stigni do četvrtfinala';

  @override
  String get objectiveReachKnockouts => 'Stigni do nokaut-faze';

  @override
  String get objectiveQualify => 'Kvalificiraj se za Svjetsko prvenstvo';

  @override
  String get finishChampions => 'Prvaci';

  @override
  String get finishRunnersUp => 'Drugoplasirani';

  @override
  String get finishSemiFinals => 'Polufinale';

  @override
  String get finishQuarterFinals => 'Četvrtfinale';

  @override
  String get finishRoundOf16 => 'Osmina finala';

  @override
  String get finishGroupStage => 'Natjecanje po skupinama';

  @override
  String get objectiveQualifyingTopHalf =>
      'Završi u gornjoj polovici kvalifikacija';

  @override
  String get finishQualifyingTopHalf =>
      'Gornja polovica kvalifikacijske skupine';

  @override
  String get finishQualifyingBottomHalf =>
      'Donja polovica kvalifikacijske skupine';

  @override
  String get objectiveNcWinIt => 'Osvoji Nations Cup';

  @override
  String get objectiveNcReachFinal => 'Stigni do finala natjecanja Nations Cup';

  @override
  String get objectiveNcFinalsFour => 'Stigni do Final Four';

  @override
  String get objectiveNcWinGroup => 'Osvoji skupinu i napreduj';

  @override
  String get objectiveNcTopHalf => 'Završi u gornjoj polovici skupine';

  @override
  String get objectiveNcSurvive => 'Izbjegni ispadanje';

  @override
  String get finishNcChampions => 'Pobjednici natjecanja Nations Cup';

  @override
  String get finishNcFinalsFour => 'Final Four';

  @override
  String get finishNcGroupWinners => 'Pobjednici skupine';

  @override
  String get finishNcTopHalf => 'Gornja polovica skupine';

  @override
  String get finishNcStayedUp => 'Izbjegnuto ispadanje';

  @override
  String get finishNcBottom => 'Posljednji u skupini';

  @override
  String get careerNationsCupLabel => 'Nations Cup';

  @override
  String get squadDevPlayer => 'IGRAČ';

  @override
  String get squadDevAge => 'DOB';

  @override
  String get squadDevPosition => 'POZ';

  @override
  String get squadDevChange => 'OCJENA';

  @override
  String get squadDevNew => 'NOVO';

  @override
  String get squadDevRetired => 'UMIROVLJEN';

  @override
  String get squadDevEmpty => 'Mirna godina. Bez promjena u sastavu.';

  @override
  String get squadDevTierRegulars => 'REDOVITI';

  @override
  String get squadDevTierFringe => 'NA MARGINI';

  @override
  String get squadDevTierYouth => 'MLADI';

  @override
  String get boardObjectivesTitle => 'Ciljevi odbora';

  @override
  String get boardObjectivesConfidence => 'Povjerenje odbora';

  @override
  String boardObjectiveBeatenBy(String result, int rounds) {
    String _temp0 = intl.Intl.pluralLogic(
      rounds,
      locale: localeName,
      other: '$rounds krugova bolje od traženog',
      few: '$rounds kruga bolje od traženog',
      one: '$rounds krug bolje od traženog',
    );
    return '$result: $_temp0';
  }

  @override
  String boardObjectiveShortBy(String result, int rounds) {
    String _temp0 = intl.Intl.pluralLogic(
      rounds,
      locale: localeName,
      other: '$rounds krugova manje od traženog',
      few: '$rounds kruga manje od traženog',
      one: '$rounds krug manje od traženog',
    );
    return '$result: $_temp0';
  }

  @override
  String get boardObjectivesPending => 'JOŠ NIJE ODLUČENO';

  @override
  String boardObjectiveSoFar(String result) {
    return 'DO SADA · $result';
  }

  @override
  String get boardObjectivesEmpty => 'Odbor nije postavio cilj za ovaj ciklus.';

  @override
  String get tourContBestWinners => 'NAJBOLJI POBJEDNICI SKUPINA';

  @override
  String get tourContBestThirds => 'NAJBOLJE TREĆEPLASIRANE';

  @override
  String tourContBestPlaced(String position) {
    return 'NAJBOLJI $position. PLASIRANI';
  }

  @override
  String squadDevPageOf(String page, String pages, String total) {
    return '$page/$pages · $total igrača';
  }

  @override
  String get matchSoldOut => 'RASPRODANO';

  @override
  String matchAttendanceOf(String attendance, String capacity) {
    return 'Popunjeno $attendance od $capacity mjesta';
  }

  @override
  String get matchGroundTitle => 'STADION';

  @override
  String get absenceInjured => 'Ozlijeđen';

  @override
  String get absenceSuspended => 'Kažnjen';

  @override
  String absenceWeeks(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString tjedana',
      few: '$countString tjedna',
      one: '$countString tjedan',
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
      other: '$countString utakmica',
      few: '$countString utakmice',
      one: '$countString utakmica',
    );
    return '$_temp0';
  }

  @override
  String absenceBackFor(String opponent) {
    return 'Vraća se za: $opponent';
  }

  @override
  String get penaltyOrderTitle => 'Jedanaesterci';

  @override
  String get penaltyOrderBlurb =>
      'Odredi pet izvođača, redom. Dodirni mjesto za promjenu.';

  @override
  String penaltyOrderPick(int number) {
    return 'Udarac $number';
  }

  @override
  String get penaltyOrderPickBlurb =>
      'Odaberi tko izlazi na loptu. Traka pokazuje njegovu smirenost s bijele točke.';

  @override
  String get penaltyOrderConfirm => 'Izvedi';

  @override
  String get penaltyOrderCancel => 'Natrag';

  @override
  String get youthTitle => 'Mladi';

  @override
  String get youthEmptyLevel => 'Na ovoj razini još nema nikoga.';

  @override
  String get youthReleased => 'Otpušteni ove godine';

  @override
  String get u21Title => 'U-21';

  @override
  String get u21Blurb =>
      'Sljedeća generacija, najbolji talent prvi. Prazne zvjezdice su procjena skauta. Daj igraču nastup da saznaš što zaista ima.';

  @override
  String get u21Empty =>
      'Trenutno nema nikoga mlađeg od 21 u fondu igrača. Sljedeći naraštaj stiže s novim ciklusom.';

  @override
  String u21Breakout(int gain) {
    return '+$gain OVE GODINE';
  }

  @override
  String u21AgeCaps(int age, int caps) {
    String _temp0 = intl.Intl.pluralLogic(
      caps,
      locale: localeName,
      other: '$caps nastupa',
      few: '$caps nastupa',
      one: '$caps nastup',
    );
    return 'Dob $age · $_temp0';
  }

  @override
  String u21AgeUncapped(int age) {
    return 'Dob $age · bez nastupa';
  }

  @override
  String get u21CallUps => 'Na pozive';

  @override
  String get youthWatching => 'Praćeni';

  @override
  String get youthWatchEmpty =>
      'Još nitko nije označen. Označi dječaka na bilo kojoj razini i pojavit će se ovdje, zajedno s onim što je postao.';

  @override
  String get youthWatchMark => 'Prati ovog dječaka';

  @override
  String get youthWatchUnmark => 'Prestani ga pratiti';

  @override
  String youthWatchMarked(int rating, int age) {
    return 'Označen s ocjenom $rating, dob $age';
  }

  @override
  String get youthWatchSenior => 'Prešao u seniorski fond';

  @override
  String get youthWatchReleased => 'Otpustila ga akademija';

  @override
  String get youthWatchGone => 'Više nije u piramidi';

  @override
  String get tacticsYouth => 'U-21';

  @override
  String get pressSquad => 'Svlačionica';

  @override
  String get pressBoard => 'Odbor';

  @override
  String get pressNoEffect => 'Nitko tome ne pridaje važnost';

  @override
  String get matchNeutralGround => 'NEUTRALNO';

  @override
  String get matchExtraTimeAhead => 'PRODUŽECI';

  @override
  String get matchExtraTimeHalf => 'PRODUŽECI · POLUVRIJEME';

  @override
  String get matchClockFullTime => 'KRAJ UTAKMICE';

  @override
  String get matchClockAfterExtraTime => 'NAKON PRODUŽETAKA';

  @override
  String get matchClockPenalties => 'JEDANAESTERCI';

  @override
  String get matchClockFullTimePenalties => 'KRAJ · JEDANAESTERCI';

  @override
  String get hubEventPressConference => 'Suoči se s medijima';

  @override
  String get hubEventPressConferenceSub =>
      'Svjetski mediji žele riječ prije tvoje prve utakmice';

  @override
  String get squadDevWonderkid => 'WONDERKID';

  @override
  String get tacticsPlaystyle => 'Stil igre';

  @override
  String get tacticsPlaystyleBlurb =>
      'Odaberi kako momčad igra; kotačići ispod fino ga podešavaju.';

  @override
  String get tacticsPlaystyleCustom =>
      'Tvoje postavke. Nijedan imenovani stil ne odgovara ovim kotačićima.';

  @override
  String get playstyleCustom => 'Prilagođeno';

  @override
  String get playstyleBalanced => 'Uravnoteženo';

  @override
  String get playstylePossession => 'Posjed';

  @override
  String get playstyleGegenpress => 'Gegenpress';

  @override
  String get playstyleCounter => 'Kontranapad';

  @override
  String get playstyleDirect => 'Izravno';

  @override
  String get playstyleLowBlock => 'Niski blok';

  @override
  String get playstyleWingPlay => 'Igra preko krila';

  @override
  String get playstyleBalancedBlurb =>
      'Čvrsto u obje polovice, ništa pretjerano.';

  @override
  String get playstylePossessionBlurb =>
      'Čuvaj loptu, strpljivo je vodi, steži teren.';

  @override
  String get playstyleGegenpressBlurb =>
      'Vrati loptu čim je izgubiš, visoko na terenu.';

  @override
  String get playstyleCounterBlurb =>
      'Povuci se, ostani zbijen, pa udari brzinom.';

  @override
  String get playstyleDirectBlurb => 'Rano naprijed i igraj na drugu loptu.';

  @override
  String get playstyleLowBlockBlurb => 'Duboko, usko i vrlo teško za razbiti.';

  @override
  String get playstyleWingPlayBlurb =>
      'Razvuci teren, obiđi po bokovima i centriraj.';

  @override
  String get nationsRandomTeam => 'Nasumična reprezentacija';

  @override
  String get nationsFromTheBottom => 'Od dna';

  @override
  String get bottomStartTitle => 'Bez posla';

  @override
  String get bottomStartHeading => 'Tri saveza žele razgovarati';

  @override
  String get bottomStartBlurb =>
      'Nemaš posao ni ugled. Ovo su jedine reprezentacije spremne riskirati s tobom. Odaberi jednu i izgradi nešto iz ničega.';

  @override
  String get bottomStartAccept => 'Prihvati';

  @override
  String get bottomStartBack => 'Natrag na meni';

  @override
  String bottomStartRankOf(int rank, int total) {
    return '$rank. od $total u svijetu';
  }

  @override
  String get campTitle => 'Bazni kamp';

  @override
  String campBasedIn(String host) {
    return 'Smještaj: $host';
  }

  @override
  String get campBlurb =>
      'Mjesto gdje momčad živi cijeli turnir. Ne može se promijeniti kad igra počne, a utječe na tri stvari u svakoj utakmici: koliko svježi stižu, koliko brzo zacjeljuje udarac i koliko su oštri.';

  @override
  String get campEffectTravel => 'Svježi dolazak';

  @override
  String get campEffectRecovery => 'Brži oporavak';

  @override
  String get campEffectSharpness => 'Oštrina za utakmice';

  @override
  String get campTerrainCity => 'Centar grada';

  @override
  String get campTerrainCoastal => 'Obalno odmaralište';

  @override
  String get campTerrainMountain => 'Planinsko utočište';

  @override
  String get campTerrainAltitude => 'Kamp na visini';

  @override
  String get campTerrainNationalCentre => 'Nacionalni centar';

  @override
  String get campTerrainCityBlurb =>
      'Sve je pri ruci i nigdje se ne putuje, ali nema mira ni bijega od buke.';

  @override
  String get campTerrainCoastalBlurb =>
      'Mirno, ugodno i dobro za raspoloženje; do svakog stadiona dug put autobusom.';

  @override
  String get campTerrainMountainBlurb =>
      'Svjež zrak i vrhunska medicinska podrška koja brzo liječi udarce, daleko od turnira.';

  @override
  String get campTerrainAltitudeBlurb =>
      'Naporno za trening, ali noge izdrže duboko u turnir.';

  @override
  String get campTerrainNationalCentreBlurb =>
      'Vlastiti objekti saveza: ništa spektakularno, ali ništa što bi moglo zakazati.';

  @override
  String get hubEventChooseCamp => 'Odaberi bazni kamp';

  @override
  String hubEventChooseCampSub(String host) {
    return 'Gdje će momčad biti smještena: $host';
  }

  @override
  String get tacticsTabBench => 'Klupa';

  @override
  String get squadSearchHint => 'Traži po imenu ili klubu';

  @override
  String get squadFilterAll => 'Svi';

  @override
  String get squadFilterInSquad => 'U sastavu';

  @override
  String get squadFilterUncapped => 'Bez nastupa';

  @override
  String get squadFilterUnavailable => 'Nedostupni';

  @override
  String get squadLineAll => 'Sve linije';

  @override
  String get squadSortBy => 'Sortiraj';

  @override
  String get squadSortRating => 'Ocjena';

  @override
  String get squadSortCaps => 'Nastupi';

  @override
  String get squadSortGoals => 'Golovi';

  @override
  String get squadSortAge => 'Dob';

  @override
  String get squadSortName => 'Ime';

  @override
  String get squadLegendTitle => 'Što znače oznake';

  @override
  String get squadLegendStarting => 'U tvojoj početnoj jedanaestorci';

  @override
  String get squadLegendCalledUp => 'Pozvan, na klupi';

  @override
  String get squadLegendRatingUp => 'Ocjena raste ove godine';

  @override
  String get squadLegendRatingDown => 'Ocjena pada ove godine';

  @override
  String get squadLegendInjured => 'Ozlijeđen, nedostupan';

  @override
  String get squadLegendSuspended => 'Kažnjen, nedostupan';

  @override
  String get squadLegendTraits => 'POZNAT PO';

  @override
  String squadShowingOf(int shown, int total) {
    return 'Prikazano $shown od $total igrača';
  }

  @override
  String get squadNobodyMatches => 'Nitko u fondu ne odgovara tim filterima.';

  @override
  String get squadStatPool => 'Fond';

  @override
  String get squadStatInSquad => 'Pozvani';

  @override
  String get squadMostCapped => 'Najviše nastupa';

  @override
  String get squadTopScorer => 'Najbolji strijelac';

  @override
  String squadCapsValue(String name, int caps) {
    String _temp0 = intl.Intl.pluralLogic(
      caps,
      locale: localeName,
      other: '$caps nastupa',
      few: '$caps nastupa',
      one: '$caps nastup',
    );
    return '$name · $_temp0';
  }

  @override
  String squadGoalsValue(String name, int goals) {
    String _temp0 = intl.Intl.pluralLogic(
      goals,
      locale: localeName,
      other: '$goals golova',
      few: '$goals gola',
      one: '$goals gol',
    );
    return '$name · $_temp0';
  }

  @override
  String squadAgeClub(int age, String club) {
    return '$age · $club';
  }

  @override
  String get squadCapsShort => 'Nast.';

  @override
  String get squadGoalsShort => 'Gol';

  @override
  String get recordsRecordBookSubtitle =>
      'Nastupi, golovi i glavni rekordi momčadi';

  @override
  String get statsLegacy => 'NASLJEĐE';

  @override
  String tacticsSubAlreadyOff(String name) {
    return '$name je već zamijenjen i ne može se vratiti na teren.';
  }

  @override
  String tacticsSubSentOff(String name) {
    return '$name je isključen i ne sudjeluje dalje.';
  }

  @override
  String get tacticsInjuredShort => 'OZLIJEĐEN';

  @override
  String get tacticsSuspendedShort => 'KAŽNJEN';

  @override
  String get confEurope => 'Europa';

  @override
  String get confSouthAmerica => 'Južna Amerika';

  @override
  String get confNorthAmerica => 'Sjeverna Amerika';

  @override
  String get confAfrica => 'Afrika';

  @override
  String get confAsia => 'Azija';

  @override
  String get confOceania => 'Oceanija';

  @override
  String get compWorldCup => 'Svjetsko prvenstvo';

  @override
  String get compWorldCupFinals => 'Završnica Svjetskog prvenstva';

  @override
  String get compWorldCupQualifying => 'Kvalifikacije za Svjetsko prvenstvo';

  @override
  String compQualifiers(String region) {
    return 'Kvalifikacije: $region';
  }

  @override
  String get compFriendlies => 'Prijateljske utakmice';

  @override
  String get compNationsCup => 'Nations Cup';

  @override
  String get compContinentalClash => 'Continental Clash';

  @override
  String get compIntercontinentalPlayoff => 'Interkontinentalni play-off';

  @override
  String get compContinentalChampionship => 'Kontinentalno prvenstvo';

  @override
  String get compEuropeanChampionship => 'Europsko prvenstvo';

  @override
  String get compSouthAmericaCup => 'Kup Južne Amerike';

  @override
  String get compAfricanChampionship => 'Afričko prvenstvo';

  @override
  String get compAsianChampionship => 'Azijsko prvenstvo';

  @override
  String get compNorthAmericaCup => 'Kup Sjeverne Amerike';

  @override
  String get compOceaniaCup => 'Kup Oceanije';

  @override
  String get msgANation => 'Neka reprezentacija';

  @override
  String get msgAPlayer => 'Neki igrač';

  @override
  String get msgAHostNation => 'zemlja domaćin';

  @override
  String get msgCycleTitle1 => 'Počinje novi ciklus';

  @override
  String msgCycleTitle2(int year) {
    return 'Otvara se put prema $year';
  }

  @override
  String get msgCycleTitle3 => 'Svanula je nova kampanja';

  @override
  String get msgCycleTitle4 => 'Natrag na posao';

  @override
  String msgCycleBody1(int year) {
    return 'Ovdje počinje put prema Svjetskom prvenstvu $year.';
  }

  @override
  String msgCycleBody2(int year) {
    return 'Novi ciklus. Cilj je Svjetsko prvenstvo $year.';
  }

  @override
  String msgCycleBody3(int year) {
    return 'Četiri godine do Svjetskog prvenstva $year. Posao počinje odmah.';
  }

  @override
  String msgCycleBody4(int year) {
    return 'Kampanja $year. počinje danas.';
  }

  @override
  String msgContHostTitle(String cup, String host) {
    return '$cup: domaćin je $host';
  }

  @override
  String msgContHostBody(String host, String cup) {
    return '$cup: sljedeći domaćin je $host.';
  }

  @override
  String msgContQualDrawTitle(String cup) {
    return 'Ždrijeb kvalifikacija: $cup';
  }

  @override
  String msgContQualDrawBody(String cup) {
    return 'Izvučene su kvalifikacijske skupine: $cup.';
  }

  @override
  String msgWcHostTitle(String host, int year) {
    return 'Svjetsko prvenstvo $year., domaćin: $host';
  }

  @override
  String msgWcHostBody(String host, int year) {
    return '$host će biti domaćin Svjetskog prvenstva $year.';
  }

  @override
  String get msgWcQualDrawTitle =>
      'Ždrijeb kvalifikacija za Svjetsko prvenstvo';

  @override
  String get msgWcQualDrawBody =>
      'Izvučene su kvalifikacijske skupine za Svjetsko prvenstvo.';

  @override
  String msgContFinalsDrawTitle(String cup) {
    return 'Ždrijeb završnice: $cup';
  }

  @override
  String msgContFinalsDrawBody(String cup) {
    return 'Izvučene su skupine završnice: $cup.';
  }

  @override
  String get msgWcFinalsDrawTitle => 'Ždrijeb završnice Svjetskog prvenstva';

  @override
  String msgWcFinalsDrawBody(int year) {
    return 'Održan je ždrijeb završnice Svjetskog prvenstva $year.';
  }

  @override
  String get msgQualWcTitle1 => 'Prolaz na Svjetsko prvenstvo';

  @override
  String get msgQualWcTitle2 => 'Svjetsko prvenstvo osigurano';

  @override
  String get msgQualWcTitle3 => 'Idemo na Svjetsko prvenstvo';

  @override
  String get msgQualWcTitle4 => 'Karta u džepu';

  @override
  String msgQualWcBody1(int year) {
    return 'Kvalificirao si se za završnicu Svjetskog prvenstva $year.';
  }

  @override
  String msgQualWcBody2(int year) {
    return 'Službeno je: tvoja reprezentacija igra na Svjetskom prvenstvu $year.';
  }

  @override
  String msgQualWcBody3(int year) {
    return 'Mjesto na Svjetskom prvenstvu $year. je osigurano.';
  }

  @override
  String msgQualWcBody4(int year) {
    return 'Prošao si na završnicu Svjetskog prvenstva $year.';
  }

  @override
  String msgQualContTitle1(String cup) {
    return 'Prolaz: $cup';
  }

  @override
  String msgQualContTitle2(String cup) {
    return '$cup: osigurano';
  }

  @override
  String msgQualContTitle3(String cup) {
    return 'Kvalifikacija: $cup';
  }

  @override
  String msgQualContBody1(String cup) {
    return 'Kvalificirao si se za završnicu: $cup.';
  }

  @override
  String msgQualContBody2(String cup) {
    return 'Tvoja reprezentacija je osigurala mjesto na natjecanju: $cup.';
  }

  @override
  String msgQualContBody3(String cup) {
    return 'Prošao si dalje: $cup.';
  }

  @override
  String msgChampTitleMine1(String comp) {
    return '$comp: PRVACI!';
  }

  @override
  String msgChampTitleMine2(String comp) {
    return 'Prvaci: $comp!';
  }

  @override
  String msgChampTitleMine3(String comp) {
    return 'Naslov je tvoj: $comp!';
  }

  @override
  String msgChampTitleOther1(String comp) {
    return '$comp: odlučeno';
  }

  @override
  String msgChampTitleOther2(String comp) {
    return '$comp: okrunjeni prvaci';
  }

  @override
  String msgChampTitleOther3(String comp) {
    return 'Završen turnir: $comp';
  }

  @override
  String msgChampBodyMine1(String comp, String loser, String result, int year) {
    return 'Tvoja reprezentacija je prvak ($comp $year.). Poraženi finalist: $loser$result.';
  }

  @override
  String msgChampBodyMine2(String comp, String loser, String result, int year) {
    return '$comp $year.: naslov je tvoj. Poražen: $loser$result.';
  }

  @override
  String msgChampBodyMine3(String comp, String loser, String result, int year) {
    return '$comp $year. pripada tebi. Svladan: $loser$result.';
  }

  @override
  String msgChampBodyOther1(
    String winner,
    String comp,
    String loser,
    String result,
    int year,
  ) {
    return '$comp $year.: osvaja $winner. Poraženi finalist: $loser$result.';
  }

  @override
  String msgChampBodyOther2(
    String winner,
    String comp,
    String loser,
    String result,
    int year,
  ) {
    return 'Prvak ($comp $year.): $winner. Poražen: $loser$result.';
  }

  @override
  String msgFinalScoreSuffix(int home, int away) {
    return ' $home–$away u finalu';
  }

  @override
  String msgFinalPensSuffix(int home, int away) {
    return ' nakon jedanaesteraca (u finalu $home–$away)';
  }

  @override
  String get msgWpotyTitle => 'Svjetski igrač godine';

  @override
  String msgWpotyBodyMine(String name, String nation, int year) {
    return '$name ($nation) proglašen je svjetskim igračem godine $year., a tvoj je igrač.';
  }

  @override
  String msgWpotyBodyOther(String name, String nation, int year) {
    return '$name ($nation) proglašen je svjetskim igračem godine $year.';
  }

  @override
  String get msgYpotTitle => 'Mladi igrač turnira';

  @override
  String msgYpotBodyMine(String name, String nation, int age, int year) {
    return '$name ($nation, dob: $age) proglašen je mladim igračem turnira $year., a tvoj je igrač.';
  }

  @override
  String msgYpotBodyOther(String name, String nation, int age, int year) {
    return '$name ($nation, dob: $age) proglašen je mladim igračem turnira $year.';
  }

  @override
  String msgRankHold1(int rank) {
    return 'Držiš poziciju #$rank.';
  }

  @override
  String msgRankHold2(int rank) {
    return 'Bez promjene, i dalje #$rank.';
  }

  @override
  String msgRankHold3(int rank) {
    return 'Stabilno na #$rank.';
  }

  @override
  String msgRankUp1(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move mjesta',
      few: '$move mjesta',
      one: '$move mjesto',
    );
    return 'Ukupno naprijed za $_temp0, na #$rank.';
  }

  @override
  String msgRankUp2(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move mjesta',
      few: '$move mjesta',
      one: '$move mjesto',
    );
    return 'Uspon za $_temp0 diže te na #$rank.';
  }

  @override
  String msgRankUp3(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move mjesta',
      few: '$move mjesta',
      one: '$move mjesto',
    );
    return 'Naprijed za $_temp0, sada #$rank.';
  }

  @override
  String msgRankDown1(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move mjesta',
      few: '$move mjesta',
      one: '$move mjesto',
    );
    return 'Ukupno nazad za $_temp0, na #$rank.';
  }

  @override
  String msgRankDown2(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move mjesta',
      few: '$move mjesta',
      one: '$move mjesto',
    );
    return 'Pad za $_temp0 spušta te na #$rank.';
  }

  @override
  String msgRankDown3(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move mjesta',
      few: '$move mjesta',
      one: '$move mjesto',
    );
    return 'Nazad za $_temp0, sada #$rank.';
  }

  @override
  String get msgRankLeadYou => 'Ti si na vrhu svijeta.';

  @override
  String msgRankLeadOther(String nation) {
    return 'Na vrhu svijeta: $nation.';
  }

  @override
  String msgRankTitle(int rank) {
    return 'Svjetska ljestvica · #$rank';
  }

  @override
  String msgRankBody(String lead, String movement) {
    return 'Svjetska ljestvica je ažurirana. $lead $movement';
  }

  @override
  String msgRankJumpTitleUp(int rank) {
    return 'Uspon na #$rank';
  }

  @override
  String msgRankJumpTitleDown(int rank) {
    return 'Pad na #$rank';
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
      other: '$move mjesta',
      few: '$move mjesta',
      one: '$move mjesto',
    );
    return 'Svjetska ljestvica se pomaknula nakon turnira: $tournament. $nation: ušla na #$from, izašla na #$to, uspon za $_temp0.';
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
      other: '$move mjesta',
      few: '$move mjesta',
      one: '$move mjesto',
    );
    return 'Svjetska ljestvica se pomaknula nakon turnira: $tournament. $nation: ušla na #$from, izašla na #$to, pad za $_temp0.';
  }

  @override
  String get rankingSinceWcDraw => 'Od ždrijeba za Svjetsko prvenstvo';

  @override
  String get rankingSinceCycleStart => 'Od početka kampanje';

  @override
  String rankingMovedFromTo(int from, int now) {
    return '#$from na #$now';
  }

  @override
  String msgCapsTitle(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nastupa',
      few: '$count nastupa',
      one: '$count nastup',
    );
    return '$name: $_temp0 za reprezentaciju';
  }

  @override
  String msgCapsBody(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nastupa',
      few: '$count nastupa',
      one: '$count nastup',
    );
    return '$name je do sada upisao $_temp0 za tvoju reprezentaciju.';
  }

  @override
  String msgGoalsTitle(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count golova',
      few: '$count gola',
      one: '$count gol',
    );
    return '$name: $_temp0 za reprezentaciju';
  }

  @override
  String msgGoalsBody(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count golova',
      few: '$count gola',
      one: '$count gol',
    );
    return '$name je postigao $_temp0 za tvoju reprezentaciju.';
  }

  @override
  String msgDevTitle(int year) {
    return 'Razvoj sastava · $year.';
  }

  @override
  String msgThroughTitle(int year) {
    return 'Stigli iz akademije · $year.';
  }

  @override
  String get msgThroughNote =>
      'Ovo nije novi naraštaj. To su dječaci koji su došli s jedanaest godina i sada su odrasli u seniorski fond igrača.';

  @override
  String msgNewFacesTitle(int year) {
    return 'Nova lica · $year.';
  }

  @override
  String get msgIntakeNoteAcademy =>
      'Ulaganje u akademiju se vidi: ovaj naraštaj stigao je jači nego što bi inače bio.';

  @override
  String get msgIntakeNoteStanding =>
      'Zemlja prati ovu momčad: dok se reprezentacija penje na svjetskoj ljestvici, najbolji dječaci biraju nogomet, pa je ovaj naraštaj stigao jači.';

  @override
  String get msgIntakeNoteBoth =>
      'Novac za akademiju i uspon reprezentacije na svjetskoj ljestvici su vidljivi: ovaj naraštaj stigao je jači nego što bi inače bio.';

  @override
  String msgIntakeTitle(int year) {
    return 'Naraštaj akademije · $year.';
  }

  @override
  String msgRetireCaptainTitle(String name) {
    return 'Tvoj kapetan $name se povlači';
  }

  @override
  String msgRetireTitle(String name) {
    return '$name se povlači iz reprezentacije';
  }

  @override
  String msgRetireBody(String name, int age) {
    return '$name je završio reprezentativnu karijeru u $age. godini.';
  }

  @override
  String msgRetireBodyWith(String name, String tally, int age) {
    return '$name je završio reprezentativnu karijeru u $age. godini. Ukupno: $tally.';
  }

  @override
  String msgTallyCaps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nastupa',
      few: '$count nastupa',
      one: '$count nastup',
    );
    return '$_temp0';
  }

  @override
  String msgTallyGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count golova',
      few: '$count gola',
      one: '$count gol',
    );
    return '$_temp0';
  }

  @override
  String get msgArmbandVacant =>
      ' Kapetanska traka je slobodna. Imenuj novog kapetana na zaslonu poziva.';

  @override
  String msgHofTitle(String name) {
    return '$name uvršten u Kuću slavnih';
  }

  @override
  String msgHofBody(String name, int caps, int goals) {
    return '$name ulazi u Kuću slavnih tvoje reprezentacije (nastupi: $caps, golovi: $goals). Pogledaj ga u Legendama.';
  }

  @override
  String hubBanTitle(String name) {
    return '$name kažnjen';
  }

  @override
  String hubBanBody(String name, String how, int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: 'sljedećih $matches utakmica',
      few: 'sljedeće $matches utakmice',
      one: 'sljedeća $matches utakmica',
    );
    return '$name $how. Zabrana nastupa: $_temp0. Nije dostupan za odabir.';
  }

  @override
  String get hubBanHowSecondYellow => 'je isključen zbog drugog žutog kartona';

  @override
  String get hubBanHowViolent =>
      'je dobio izravni crveni karton zbog nasilnog ponašanja';

  @override
  String get hubBanHowRed => 'je isključen';

  @override
  String hubInjuryTitle(String name) {
    return '$name ozlijeđen';
  }

  @override
  String hubInjuryBody(String name, int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: '$matches utakmica',
      few: '$matches utakmice',
      one: '$matches utakmicu',
    );
    return '$name je ozlijeđen i izostaje $_temp0.';
  }

  @override
  String get hubRunnerUpTitle1 => 'Drugoplasirani';

  @override
  String get hubRunnerUpTitle2 => 'Tako blizu, a tako daleko';

  @override
  String get hubRunnerUpTitle3 => 'Srebrna medalja';

  @override
  String hubRunnerUpBody1(String cup, String opponent) {
    return '$cup: finale izgubljeno. Pobjednik: $opponent. Tako blizu. Ovaj put srebro.';
  }

  @override
  String hubRunnerUpBody2(String cup, String opponent) {
    return 'Poraz u finalu, $cup. Pobjednik: $opponent. Drugo mjesto, bolno blizu.';
  }

  @override
  String hubRunnerUpBody3(String cup, String opponent) {
    return 'Finale ($cup) je izmaklo. Pobjednik: $opponent. Imaš se čime ponositi, ali pehar nije tvoj.';
  }

  @override
  String get hubKnockedOutTitle1 => 'Ispadanje';

  @override
  String get hubKnockedOutTitle2 => 'Kraj puta';

  @override
  String get hubKnockedOutTitle3 => 'Putovanje je gotovo';

  @override
  String hubKnockedOutBody1(String cup, String opponent, String stage) {
    return 'Ispao si iz natjecanja: $cup. Faza: $stage, protivnik: $opponent.';
  }

  @override
  String hubKnockedOutBody2(String cup, String opponent, String stage) {
    return '$opponent je prekinuo tvoj put. $cup, faza: $stage.';
  }

  @override
  String hubKnockedOutBody3(String cup, String opponent, String stage) {
    return '$cup za tebe završava. Faza: $stage, protivnik: $opponent.';
  }

  @override
  String get hubGroupExitTitle1 => 'Ispadanje u skupini';

  @override
  String get hubGroupExitTitle2 => 'Kraj u skupini';

  @override
  String get hubGroupExitTitle3 => 'Prerano pod tuš';

  @override
  String hubGroupExitBody1(String cup) {
    return '$cup: kraj u skupini. Nije bilo dovoljno za nokaut-fazu.';
  }

  @override
  String hubGroupExitBody2(String cup) {
    return 'Nisi izašao iz skupine. $cup ovdje završava.';
  }

  @override
  String hubGroupExitBody3(String cup) {
    return 'Ovaj put bez mjesta u nokaut-fazi. $cup je gotov u skupini.';
  }

  @override
  String boardObjectiveMetTitle(String comp) {
    return 'Cilj ispunjen: $comp';
  }

  @override
  String boardObjectiveMissedTitle(String comp) {
    return 'Cilj promašen: $comp';
  }

  @override
  String boardObjectiveMetBody(String comp, String demand, String finish) {
    return 'Cilj odbora ($comp): $demand. Tvoj ishod: $finish. Dobili su što su tražili.';
  }

  @override
  String boardObjectiveMissedBody(String comp, String demand, String finish) {
    return 'Cilj odbora ($comp): $demand. Tvoj ishod: $finish. To je ispod očekivanog.';
  }

  @override
  String get newsWcMissTitle => 'Kraj sna o Svjetskom prvenstvu';

  @override
  String newsWcMissBody(int year) {
    return 'Nisi se plasirao na Svjetsko prvenstvo $year. Kvalifikacijska kampanja nije bila dovoljna. Još četiri godine.';
  }

  @override
  String get newsRecordScorerTitle => 'Najbolji strijelac svih vremena';

  @override
  String newsRecordScorerBody(String name, int goals) {
    return '$name je sada najbolji strijelac svih vremena u igri. Golova: $goals.';
  }

  @override
  String get newsRecordCapsTitle => 'Rekorder po nastupima';

  @override
  String newsRecordCapsBody(String name, int caps) {
    return '$name je novi rekorder igre po nastupima za reprezentaciju. Nastupa: $caps.';
  }

  @override
  String get newsARecordBreaker => 'Novi rekorder';

  @override
  String newsTransferTitle(String name, String club) {
    return 'Novi klub za $name: $club';
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
    return '$name ($position, $rating) mijenja klub. Iz kluba: $fromClub. U klub: $destination. Naknada: $fee.';
  }

  @override
  String newsTransferAbroad(String club, String country) {
    return '$club ($country)';
  }

  @override
  String get newsTransferFree => 'Bez odštete';

  @override
  String newsNatzStarTitle(String name, String nation) {
    return '⭐ $name bi prešao u reprezentaciju: $nation!';
  }

  @override
  String newsNatzTitle(String name, String nation) {
    return '$name želi igrati za reprezentaciju: $nation';
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
    return '$name, $age-godišnji $position ocjene $rating, trenutačno igra za reprezentaciju: $fromNation. Ima obiteljske veze s reprezentacijom: $nation i spreman je promijeniti dres. Otvori ponudu za naturalizaciju da je prihvatiš ili odbiješ.';
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
    return '$name, $age-godišnji $position ocjene $rating, trenutačno igra za reprezentaciju: $fromNation. Veliko je ime koje ima obiteljske veze s reprezentacijom: $nation i spreman je promijeniti dres. Otvori ponudu za naturalizaciju da je prihvatiš ili odbiješ.';
  }

  @override
  String get newsTheirNation => 'njihova zemlja';

  @override
  String get newsYourNation => 'tvoja zemlja';

  @override
  String get tourStatusChampions => 'PRVACI';

  @override
  String get tourStatusFinals => 'ZAVRŠNICA';

  @override
  String get tourStatusQualifying => 'KVALIFIKACIJE';

  @override
  String get tourStatusUpcoming => 'PREDSTOJI';

  @override
  String get tourStatusInProgress => 'U TIJEKU';

  @override
  String get tourStatusComingSoon => 'USKORO';

  @override
  String get tourStatusDecided => 'ZAVRŠENO';

  @override
  String tourStatusLeague(String letter) {
    return 'LIGA $letter';
  }

  @override
  String get tourDrawWcQualifying => 'ŽRIJEB SP KVALIFIKACIJA';

  @override
  String tourDrawContQualifying(String cup) {
    return 'ŽRIJEB KVALIFIKACIJA: $cup';
  }

  @override
  String get tourDrawWcHost => 'DOMAĆIN SVJETSKOG PRVENSTVA';

  @override
  String tourDrawContHost(String cup) {
    return 'DOMAĆIN: $cup';
  }

  @override
  String get tourDrawHostsReveal => 'A domaćini će biti…';

  @override
  String get tourDrawHostReveal => 'A domaćin će biti…';

  @override
  String get tourDrawHostCandidates => 'Kandidati u utrci:';

  @override
  String get tourKickoffContinentalCup => 'KONTINENTALNI KUP';

  @override
  String tourHostCompetitionYear(String competition, int year) {
    return '$competition $year';
  }

  @override
  String newsContMissTitle(String cup) {
    return '$cup: bez plasmana';
  }

  @override
  String newsContMissBody(String cup) {
    return 'Nisi izborio plasman na natjecanje: $cup. Kampanja je ovaj put bila prekratka.';
  }

  @override
  String get potyLabelBest => 'Igrač godine';

  @override
  String get potyLabelYoung => 'Mladi igrač godine';

  @override
  String potyTallyAssists(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count asistencija',
      few: '$count asistencije',
      one: '$count asistencija',
    );
    return '$_temp0';
  }

  @override
  String potyOverallValue(int value) {
    return 'Ocjena $value';
  }

  @override
  String potyRatingValue(String value) {
    return 'Prosjek $value';
  }

  @override
  String newsPotyTitle(int year) {
    return 'Svjetski igrač godine $year';
  }

  @override
  String newsPotyBody(String name) {
    return '$name je ove godine najbolji igrač na svijetu.';
  }

  @override
  String newsPotyYoungSuffix(String name) {
    return ' $name osvaja nagradu za mladog igrača.';
  }

  @override
  String newsWatchTitle(int year) {
    return 'Dječaci koje pratiš, $year';
  }

  @override
  String newsWatchJump(String name, int rating, int gain) {
    String _temp0 = intl.Intl.pluralLogic(
      gain,
      locale: localeName,
      other: 'za $gain bodova',
      few: 'za $gain boda',
      one: 'za $gain bod',
    );
    return '$name je napredovao na $rating, $_temp0 više nego lani.';
  }

  @override
  String newsWatchBand(String name, String band) {
    return '$name prelazi u dobnu skupinu: $band.';
  }

  @override
  String newsWatchDebutTitle(String name) {
    return '$name debitira';
  }

  @override
  String newsWatchDebutBody(String name, int age, int rating) {
    return '$name je upisao prvi nastup za reprezentaciju u $age. godini, s ocjenom $rating. Jedan od dječaka koje pratiš.';
  }

  @override
  String get matchStatsAtFullTime =>
      'Posjed lopte, ocjene igrača i igrač utakmice poznati su tek nakon konačnog zvižduka.';

  @override
  String get matchPlayerRatings => 'OCJENE IGRAČA';

  @override
  String get matchSubstitutions => 'IZMJENE';

  @override
  String get matchSubstitutes => 'KLUPA';

  @override
  String get matchPlayerOfTheMatch => 'IGRAČ UTAKMICE';

  @override
  String get matchGoalShout => 'GOL!';

  @override
  String matchShootoutScore(int home, int away) {
    return 'JEDANAESTERCI $home–$away';
  }

  @override
  String matchShootoutKickScored(String name) {
    return '$name: POGODAK';
  }

  @override
  String matchShootoutKickMissed(String name) {
    return '$name: PROMAŠAJ';
  }

  @override
  String get matchFeedKickOff => 'Početni udarac!';

  @override
  String get matchFeedNoEvents => 'Još nema događaja.';

  @override
  String get tourVenues => 'STADIONI';

  @override
  String tourPot(int number) {
    return 'ŠEŠIR $number';
  }

  @override
  String get tourHostSelection => 'ODABIR DOMAĆINA';

  @override
  String get tourCandidates => 'KANDIDATI';

  @override
  String get tourJointBid => 'ZAJEDNIČKA KANDIDATURA';

  @override
  String get tourGoldenGlove => 'ZLATNE RUKAVICE';

  @override
  String get tourTeamOfTournament => 'MOMČAD TURNIRA';

  @override
  String get tourYourRun => 'TVOJ PUT';

  @override
  String get tourMedalTable => 'TABLICA MEDALJA';

  @override
  String tourHostLine(String nation) {
    return 'Domaćin: $nation';
  }

  @override
  String tourHostLineMulti(String hosts) {
    return 'Domaćini: $hosts';
  }

  @override
  String tourGroupNamed(String name) {
    return 'Skupina $name';
  }

  @override
  String get tourFinalsDrawBlurb =>
      'Nositelji prema svjetskoj ljestvici. Pronađi svoju zemlju prije ždrijeba.';

  @override
  String get tourWorldRanking => 'Svjetska ljestvica';

  @override
  String get tourYourCompetitions => 'TVOJA NATJECANJA';

  @override
  String get tourOtherContinents => 'OSTALI KONTINENTI';

  @override
  String get tourZoneGlobal => 'SVIJET';

  @override
  String get tourZoneEurope => 'EUROPA';

  @override
  String get tourZoneSouthAmerica => 'J. AMERIKA';

  @override
  String get tourZoneNorthAmerica => 'S. AMERIKA';

  @override
  String get tourZoneAfrica => 'AFRIKA';

  @override
  String get tourZoneAsia => 'AZIJA';

  @override
  String get tourZoneOceania => 'OCEANIJA';

  @override
  String get tourZoneIntercontinental => 'INTERKONTINENTALNO';

  @override
  String tourZoneLeague(String league) {
    return 'LIGA $league';
  }

  @override
  String tourHostedBy(String hosts) {
    return 'DOMAĆIN  $hosts';
  }

  @override
  String tourThirdsAdvance(int count, String destination) {
    return 'Prvih $count ide dalje u $destination';
  }

  @override
  String newsWalkoutTitle(String name) {
    return '$name odlazi';
  }

  @override
  String newsWalkoutBody(String name, int age, int caps) {
    return '$name se povukao iz međunarodnog nogometa u $age. godini (nastupa za reprezentaciju: $caps). Tražio je da mu se kaže na čemu je, a nitko mu nije rekao, i više ne želi čekati.';
  }

  @override
  String get pressHeadlineWent1 => 'Izbornik koji drži dvoranu pod kontrolom';

  @override
  String get pressHeadlineWent2 => 'Došli su po svađu, dobili su vođu';

  @override
  String get pressHeadlineWent3 => 'Jasni odgovori, i pogodili su';

  @override
  String get pressHeadlineMixed1 => 'Puno rečeno, malo riješeno';

  @override
  String get pressHeadlineMixed2 => 'Ponešto za sve, a ništa za nikoga';

  @override
  String get pressHeadlineMixed3 =>
      'Konferencija koja je ostavila pitanja otvorenima';

  @override
  String get pressHeadlineBadly1 => 'Teško popodne pred kamerama';

  @override
  String get pressHeadlineBadly2 => 'Dvorana se okrenula, i to se vidjelo';

  @override
  String get pressHeadlineBadly3 =>
      'Odgovori koji će ujutro izgledati još gore';

  @override
  String get pressHeadlineFlat1 => 'Ništa rečeno, ništa dobiveno';

  @override
  String get pressHeadlineFlat2 => 'Deset minuta, nema vijesti';

  @override
  String get pressHeadlineFlat3 => 'Prazna stranica za zadnju stranicu';

  @override
  String get pressConferenceTitle => 'PRESS KONFERENCIJA';

  @override
  String pressQuestionOf(int index, int total) {
    return 'Pitanje $index od $total';
  }

  @override
  String get pressTomorrowsHeadline => 'SUTRAŠNJA ZADNJA STRANICA';

  @override
  String get pressLeaveRoom => 'NAPUSTI DVORANU';

  @override
  String get pressRoomVerdictSquad => 'Svlačionica';

  @override
  String get pressRoomVerdictBoard => 'Odbor';

  @override
  String get yReactionElation0 => 'nema zamjerki. nijedne. savršeno.';

  @override
  String get yReactionElation1 => 'nije mi dobro (u najboljem smislu).';

  @override
  String get yReactionElation2 => 'stavljam u okvir. iznad kamina.';

  @override
  String get yReactionElation3 => 'vratili smo se';

  @override
  String get yReactionElation4 =>
      'Screenshotam ovo za sumnjičavce. Sve do jednog.';

  @override
  String get yReactionElation5 =>
      'Bit ću nepodnošljiv zbog ovoga idućih deset godina.';

  @override
  String get yReactionElation6 => 'Eto. Zato gledamo.';

  @override
  String get yReactionElation7 => 'Ovakvi dani plate sve one druge.';

  @override
  String get yReactionElation8 => 'Bilo je vrijeme. Stvarno, bilo je vrijeme.';

  @override
  String get yReactionElation9 =>
      'Super. Sad to ponovite i sljedeći tjedan pa ću vjerovati.';

  @override
  String get yReactionElation10 =>
      'Uživajte večeras, jer će ovi već naći način da to pokvare.';

  @override
  String get yReactionElation11 =>
      'Jedna dobra večer nikoga ne čini velikom momčadi.';

  @override
  String get yReactionRelief0 => 'Nije lijepo, ali uzimam to svaki put.';

  @override
  String get yReactionRelief1 => 'Nekako. Nekako!';

  @override
  String get yReactionRelief2 => 'Ružno. Tri boda. Idemo dalje.';

  @override
  String get yReactionRelief3 =>
      'Uzet ću ružno svaki dan ako dolazi s bodovima.';

  @override
  String get yReactionRelief4 => 'ovo mi je skinulo deset godina života';

  @override
  String get yReactionRelief5 => 'Nitko ni riječ. Nitko da ne ureče.';

  @override
  String get yReactionRelief6 => 'Puls: neprihvatljiv.';

  @override
  String get yReactionRelief7 => 'Preživjeli. To je prava riječ. Preživjeli.';

  @override
  String get yReactionRelief8 =>
      'Nakon ovakvih utakmica ne bi nam trebalo olakšanje.';

  @override
  String get yReactionRelief9 =>
      'Laknulo mi je, a malo me i sram što mi je laknulo.';

  @override
  String get yReactionRelief10 =>
      'Ako je to standard koji slavimo, u nevolji smo.';

  @override
  String get yReactionRelief11 => 'Provlačenje je navika, a nije dobra.';

  @override
  String get yReactionFury0 => 'Nedovoljno dobro. Ni izbliza.';

  @override
  String get yReactionFury1 => 'Neka mi netko to objasni polako.';

  @override
  String get yReactionFury2 => 'Teško se to gledalo, a ja sam još pristojan.';

  @override
  String get yReactionFury3 => 'Razočaran. Stvarno razočaran.';

  @override
  String get yReactionFury4 => 'Užasno stanje.';

  @override
  String get yReactionFury5 => 'Tražim imena.';

  @override
  String get yReactionFury6 =>
      'Brišem aplikaciju. U četvrtak je opet instaliram.';

  @override
  String get yReactionFury7 => 'Nitko tamo nije izgledao kao da to želi.';

  @override
  String get yReactionFury8 => 'Svake četiri godine isto. SVAKE četiri godine.';

  @override
  String get yReactionFury9 => 'To nije izvedba, to je uvreda.';

  @override
  String get yReactionFury10 =>
      'Ljudi za to žrtvuju vikende i novac. Razmislite o tome.';

  @override
  String get yReactionFury11 =>
      'Godinama sam branio ovu momčad. Večeras ne. Ne nakon ovoga.';

  @override
  String get yReactionDespair0 => 'pa.';

  @override
  String get yReactionDespair1 => 'Danas bez šala. Ništa.';

  @override
  String get yReactionDespair2 => 'Idem u šetnju. Dugu.';

  @override
  String get yReactionDespair3 => 'Ponestalo mi je načina da ovo kažem.';

  @override
  String get yReactionDespair4 => 'Probudite me za četiri godine.';

  @override
  String get yReactionDespair5 => 'ovo je najmračnija vremenska linija';

  @override
  String get yReactionDespair6 =>
      'Čak se više ni ne ljutim. To je zabrinjavajuće.';

  @override
  String get yReactionDespair7 => 'Ovo će boljeti dugo.';

  @override
  String get yReactionDespair8 =>
      'Više ne znam što je ovo, ali nije nogometna momčad.';

  @override
  String get yReactionDespair9 => 'Dalje smo nego prije, a nitko to neće reći.';

  @override
  String get yReactionDespair10 =>
      'Propala je cijela generacija, a isti ljudi odlučuju što slijedi.';

  @override
  String get yReactionDespair11 =>
      'Prestanite mi govoriti da je to proces. Ne vodi nikamo.';

  @override
  String get yReactionSmugness0 => 'Tiho, ali: rekao sam vam.';

  @override
  String get yReactionSmugness1 => 'stavite ovo u favorite';

  @override
  String get yReactionSmugness2 => 'Sumnjičavci su jako utihnuli.';

  @override
  String get yReactionSmugness3 => 'Ne da netko broji. Ja brojim.';

  @override
  String get yReactionSmugness4 =>
      'Rekao sam u siječnju. Provjerite vremensku crtu.';

  @override
  String get yReactionSmugness5 => 'Neki od vas duguju nekima od nas ispriku.';

  @override
  String get yReactionSmugness6 =>
      'Spremam ovo pod stvari koje sam prvi spomenuo.';

  @override
  String get yReactionSmugness7 => 'Bez likovanja. Malo likovanja.';

  @override
  String get yReactionSmugness8 =>
      'Gdje su sad svi stručnjaci? Pošteno pitanje.';

  @override
  String get yReactionSmugness9 =>
      'Želim da mi svatko od vas to ponovi u lice.';

  @override
  String get yReactionSmugness10 =>
      'Snimka zaslona, isprintana, uokvirena, poslana onima koji su se smijali.';

  @override
  String get yReactionSmugness11 =>
      'Spominjat ću ovo do kraja života i zaslužili ste to.';

  @override
  String get yReactionShrug0 => 'dogodilo se. sljedeće.';

  @override
  String get yReactionShrug1 => 'Dobro. Svejedno. Dalje.';

  @override
  String get yReactionShrug2 => 'Spremam ovo pod \'nogomet\'.';

  @override
  String get yReactionShrug3 => 'Stvarno nemam što dodati.';

  @override
  String get yReactionShrug4 => 'bez misli, prazna glava';

  @override
  String get yReactionShrug5 => 'Probudite me za sljedeću.';

  @override
  String get yReactionShrug6 => 'Devedeset minuta koje mi nitko neće vratiti.';

  @override
  String get yReactionShrug7 => 'Ni tamo ni ovamo, zapravo.';

  @override
  String get yReactionShrug8 =>
      'Ne mogu vam reći ni jednu stvar koja se dogodila.';

  @override
  String get yReactionShrug9 => 'Još jedna od takvih. Ima ih puno.';

  @override
  String get yReactionShrug10 => 'Gledao sam sve i nisam osjetio baš ništa.';

  @override
  String get yReactionShrug11 =>
      'Ako se ovoga više nitko ne sjeti, meni je pravo.';

  @override
  String get tourThirdsUneven =>
      'Skupine su nejednake pa se rezultati protiv posljednje momčadi svake veće skupine odbacuju i svaka se momčad ocjenjuje na istim utakmicama.';

  @override
  String get careerExportSave => 'Sigurnosna kopija ove igre';

  @override
  String get careerBackupAll => 'KOPIJA SVIH IGARA';

  @override
  String get careerBackupAllFailed => 'Nije moguće zapisati sigurnosnu kopiju.';

  @override
  String get backupTitle => 'SPREMLJENE IGRE';

  @override
  String get backupBlurb =>
      'Sve spremljene igre nalaze se u jednoj datoteci na ovom telefonu i ništa ih samo od sebe ne kopira. Izvezi kopiju i čuvaj je izvan telefona, u Datotekama ili na iCloud Driveu, da te izgubljeni telefon ili izbrisana aplikacija ne koštaju karijere.';

  @override
  String get backupExport => 'IZVEZI KOPIJU';

  @override
  String get backupExportSubject => 'FNM spremljene igre';

  @override
  String get backupRestore => 'VRATI IZ DATOTEKE';

  @override
  String get backupRestoreWarnTitle => 'Zamijeniti sve spremljene igre?';

  @override
  String get backupRestoreWarnBody =>
      'Vraćanje zamjenjuje sve spremljene igre na ovom telefonu onima iz datoteke. Aplikacija će se ponovno pokrenuti.';

  @override
  String get backupRestoreConfirm => 'ZAMIJENI';

  @override
  String get backupCancel => 'ODUSTANI';

  @override
  String get backupExported => 'Kopija je spremna. Odaberi gdje ćeš je čuvati.';

  @override
  String get backupFailed => 'Nije moguće zapisati sigurnosnu kopiju.';

  @override
  String get backupRejectedUnreadable => 'Ta se datoteka nije mogla otvoriti.';

  @override
  String get backupRejectedNotFnm => 'To nije FNM spremljena igra.';

  @override
  String get backupRejectedNewer =>
      'Ta je igra napravljena novijom verzijom aplikacije. Prvo je ažuriraj.';

  @override
  String get backupRejectedTooOld =>
      'Ta je spremljena igra prestara da bi je ova verzija mogla vratiti.';

  @override
  String get careerShare => 'Podijeli ovu karijeru';

  @override
  String get careerImport => 'UVEZI KARIJERU';

  @override
  String get careerShareSubject => 'FNM karijera';

  @override
  String get careerImported => 'Karijera uvezena.';

  @override
  String get careerImportFailedUnreadable => 'Ta datoteka nije FNM karijera.';

  @override
  String get careerImportFailedNewer =>
      'Ta je karijera izvezena novijom verzijom aplikacije. Prvo je ažuriraj.';

  @override
  String get careerImportFailedSlotsFull =>
      'Sva tvoja mjesta za spremanje su zauzeta. Izbriši jednu igru da napraviš mjesta ili otključaj neograničen broj spremljenih igara.';

  @override
  String get careerImportFailedNeedsPremium =>
      'Ta karijera je izvan besplatnog prvog ciklusa. Otključaj cijelu igru da je uvezeš.';

  @override
  String get careerImportFailedCampaignRun =>
      'Za tu kampanju već je u tijeku jedna karijera. Prvo je nastavi ili napusti.';

  @override
  String get careerShareFailed => 'Nije moguće izvesti tu karijeru.';

  @override
  String get managerRename => 'Promijeni ime';

  @override
  String get managerRenameSave => 'Spremi';

  @override
  String get managerTitle => 'IZBORNIK';

  @override
  String get managerSkills => 'TVOJE VJEŠTINE';

  @override
  String managerPointsAvailable(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bodova za potrošiti',
      few: '$count boda za potrošiti',
      one: '$count bod za potrošiti',
      zero: 'Nema bodova za potrošiti',
    );
    return '$_temp0';
  }

  @override
  String get managerPointsHow =>
      'Dva boda za svaki završeni ciklus, jedan za svaki osvojeni trofej.';

  @override
  String get managerSkillsScale =>
      'Svaka vještina kreće od 5 i staje na 20. Potrošen bod je trajan.';

  @override
  String get managerSkillManManagement => 'Rad s ljudima';

  @override
  String get managerSkillManManagementBlurb =>
      'Svaki bod čini da tvoje riječi medijima i igračima 3% jače odjeknu u svlačionici.';

  @override
  String get managerSkillTactical => 'Taktika';

  @override
  String get managerSkillTacticalBlurb =>
      'Svaki bod 3% brže uigrava novu formaciju, pa promjena formacije košta manje utakmica.';

  @override
  String get managerSkillYouth => 'Razvoj mladih';

  @override
  String get managerSkillYouthBlurb =>
      'Svaki bod dodaje 1% talentima iz tvoje akademije, povrh onoga što u nju ulažeš.';

  @override
  String get managerSkillNegotiation => 'Pregovaranje';

  @override
  String get managerSkillNegotiationBlurb =>
      'Svaki bod donosi 2% više novca iz saveza, svaki ciklus.';

  @override
  String get managerStaff => 'TVOJ STOŽER';

  @override
  String managerStaffWages(String amount) {
    return 'Plaće: $amount po ciklusu';
  }

  @override
  String get managerRoleAssistant => 'Pomoćnik izbornika';

  @override
  String get managerRoleAssistantBlurb =>
      'Vodi treninge: manje ozljeda i bolji mladi igrači.';

  @override
  String get managerRoleScout => 'Glavni skaut';

  @override
  String get managerRoleScoutBlurb =>
      'Prati tvoje talente i sljedećeg protivnika: točnije zvjezdice i prednost na dan utakmice.';

  @override
  String get managerRoleFitness => 'Kondicijski trener';

  @override
  String get managerRoleFitnessBlurb => 'Drži ih na terenu.';

  @override
  String staffEffectInjury(int percent) {
    return '$percent% manje ozljeda';
  }

  @override
  String staffEffectYouth(int points) {
    return 'Mladi igrači +$points ukupne ocjene';
  }

  @override
  String staffHiringInjury(int min, int max) {
    return 'Zapošljavanje: $min% do $max% manje ozljeda';
  }

  @override
  String staffHiringYouth(int minPoints, int maxPoints) {
    return 'i mladi igrači +$minPoints do +$maxPoints ukupne ocjene';
  }

  @override
  String staffEffectScoutRead(int percent) {
    return 'Točno procijeni $percent% talenata';
  }

  @override
  String staffEffectScoutCaps(int caps) {
    String _temp0 = intl.Intl.pluralLogic(
      caps,
      locale: localeName,
      other: 'Potencijal poznat nakon $caps nastupa',
      one: 'Potencijal poznat nakon 1 nastupa',
    );
    return '$_temp0';
  }

  @override
  String staffEffectScoutDossier(int points) {
    return '+$points ocjene od dosjea protivnika';
  }

  @override
  String staffHiringScoutRead(int min, int max) {
    return 'Zapošljavanje: $min% do $max% točnih procjena';
  }

  @override
  String staffHiringScoutCaps(int minCaps, int maxCaps) {
    return 'i potencijal poznat $minCaps do $maxCaps nastupa prije';
  }

  @override
  String staffHiringScoutDossier(int minPoints, int maxPoints) {
    return 'i +$minPoints do +$maxPoints ocjene u svakoj utakmici';
  }

  @override
  String get staffEffectNone => 'Još bez učinka na tvoj sastav';

  @override
  String get staffVacant => 'Nitko na toj funkciji';

  @override
  String get staffLeaveVacant => 'Ostavi mjesto prazno';

  @override
  String get managerTierNone => 'Nema';

  @override
  String get managerTierBasic => 'Osnovna';

  @override
  String get managerTierGood => 'Dobra';

  @override
  String get managerTierElite => 'Elitna';

  @override
  String get managerFree => 'besplatno';

  @override
  String get managerTraining => 'IZMEĐU TERMINA';

  @override
  String get managerTrainingBlurb => 'Na čemu sastav radi kad nema utakmice.';

  @override
  String get managerFocusBalanced => 'Uravnoteženo';

  @override
  String get managerFocusBalancedBlurb => 'Svega po malo.';

  @override
  String get managerFocusFitness => 'Kondicija';

  @override
  String get managerFocusFitnessBlurb => 'Manje ozljeda.';

  @override
  String get managerFocusCohesion => 'Povezanost';

  @override
  String get managerFocusCohesionBlurb => 'Formacija se brže uigrava.';

  @override
  String get managerFocusYouth => 'Mladi';

  @override
  String get managerFocusYouthBlurb => 'Sati s najmlađima u fondu igrača.';

  @override
  String get tourOfferTitle => 'Prvi put ovdje?';

  @override
  String get tourOfferBody =>
      'Ovo je velika igra. Želiš li kratki obilazak ključnih ekrana? Traje minutu, a možeš ga ponovno pokrenuti bilo kada iz Postavki.';

  @override
  String get tourOfferYes => 'Pokaži mi';

  @override
  String get tourOfferNo => 'Ne, hvala';

  @override
  String get tourBack => 'Natrag';

  @override
  String get tourNext => 'Dalje';

  @override
  String get tourDone => 'Gotovo';

  @override
  String get tourSkip => 'Preskoči';

  @override
  String get tourHubTitle => 'Ovo je cijela igra';

  @override
  String get tourHubBody =>
      'Jedan gumb koji se mijenja kako ciklus teče: ždrijeb za gledanje, sastav za objaviti, utakmica za igranje. Iznad njega su povjerenje odbora u tebe i ciljevi koje su ti postavili.';

  @override
  String get tourBudgetTitle => 'Novac saveza';

  @override
  String get tourBudgetBody =>
      'Jednom u svakom četverogodišnjem ciklusu dijeliš riznicu među odjele. Prvo se iz nje plaća stožer, pa je zapošljavanje elitnog skauta odluka protiv akademije, a ne uz nju.';

  @override
  String get tourTacticsTitle => 'Kako momčad igra';

  @override
  String get tourTacticsBody =>
      'Tvoja formacija, tvoj stil igre, tvoj kapetan i tko izvodi stajalice. Ostaviš li zadnja dva neodređenima, igra će te upozoriti prije početnog udarca, a ne tiho birati umjesto tebe.';

  @override
  String get tourSquadTitle => 'Svi koje možeš odabrati';

  @override
  String get tourSquadBody =>
      'Cijeli fond igrača, ne samo sastav: tko je u formi, tko nosi ozljedu, tko je kažnjen i tko je upravo stigao iz akademije.';

  @override
  String get tourCallUpsTitle => 'Objava sastava';

  @override
  String get tourCallUpsBody =>
      'Za svaki međunarodni termin objavljuješ jedan sastav i on igra svaku utakmicu tog termina, baš kao pravi izbornik. Ozljeda unutar termina automatski dovodi zamjenu.';

  @override
  String get tourRecordsTitle => 'Tvoja karijera';

  @override
  String get tourRecordsBody =>
      'Sve što si napravio: utakmice, momčadski rekordi, trofeji i svaka reprezentacija koju si vodio.';

  @override
  String get tourCupsTitle => 'Ostatak svijeta';

  @override
  String get tourCupsBody =>
      'Sva natjecanja koja se trenutačno igraju: skupine, poredak i nokaut-faze, uključujući ona u kojima ne igraš. Svijet igra dalje bez obzira jesi li se plasirao.';

  @override
  String get settingsTourTitle => 'Ponovi upute';

  @override
  String get settingsTourBlurb =>
      'Ponovno prođi kroz ključne ekrane od početka.';

  @override
  String get tourBoardTitle => 'Kome odgovaraš';

  @override
  String get tourBoardBody =>
      'Povjerenje odbora u tebe i ciljevi koje su ti postavili za ovaj ciklus. Ako promašiš zadatak, ovdje ćeš vidjeti da dolazi.';

  @override
  String get tourStaffTitle => 'Ljudi oko tebe';

  @override
  String get tourStaffBody =>
      'Pomoćnik, skaut i kondicijski trener, zaposleni po imenu. Njihove plaće idu iz ovog proračuna prije odjela, pa je sjajan skaut odluka protiv akademije.';

  @override
  String get tourPlaystyleTitle => 'Tvoj stil igre';

  @override
  String get tourPlaystyleBody =>
      'Formacija je tek pola taktike. Ovo je druga polovica: koliko visoko presaš, koliko si direktan, koliko riskiraš.';

  @override
  String get settingsTourNoSave =>
      'Prvo započni karijeru. Obilazak vodi kroz tvoje ekrane.';

  @override
  String tacticsOutOfPositionAge(int age) {
    return 'Izvan pozicije · $age god.';
  }

  @override
  String get federationNextCycleLocked =>
      'Proračun sljedećeg ciklusa određuje se na početku tog ciklusa, odjednom. Do tada ovo je ono što tvoj novac radi.';

  @override
  String get federationBudgetAlreadySet => 'Već određeno za ovaj ciklus';

  @override
  String yFinalLooms0(String opponent) {
    return 'Protivnik u velikom finalu: $opponent. Cijeli tjedan nitko neće pričati ni o čemu drugom.';
  }

  @override
  String yFinalLooms1(String opponent) {
    return 'Potvrđeno: $opponent je jedino što stoji između nas i toga. Četiri godine za ovo.';
  }

  @override
  String yFinalLooms2(String opponent) {
    return 'Dobro. $opponent. Nitko ne spava dok ovo ne završi.';
  }

  @override
  String yFinalLooms3(String opponent) {
    return 'Sljedeći je $opponent, a sve ostalo može pričekati. Kakav tjedan.';
  }

  @override
  String get matchSetupLeaveToCoach => 'Prepusti izvođače treneru';

  @override
  String friendliesLikeYourGroup(String rivals) {
    return 'Označeno ispod: momčadi koje igraju kao $rivals, protivnici koje ovog ciklusa sretneš u skupinama.';
  }

  @override
  String newsTransferWindowTitle(int year) {
    return 'Prijelazni rok · $year';
  }

  @override
  String careerLastAgo(String when) {
    return 'Zadnji put: prije $when';
  }

  @override
  String get settingsFreeScopeTitle => 'Jedan besplatni četverogodišnji ciklus';

  @override
  String get settingsFreeScopeBlurb =>
      'Cijeli ciklus (kvalifikacije, tvoje kontinentalno prvenstvo i Svjetsko prvenstvo) na dvije spremljene igre, sve zemlje svijeta, bez ograničenja. Neograničeni ciklusi i spremljene igre dolaze uz jednu uplatu, samo jednom, koja pokriva i sva buduća ažuriranja.';

  @override
  String get settingsUnlockedTitle => 'Otključano';

  @override
  String get settingsUnlockedBlurb =>
      'Neograničeni ciklusi, neograničene spremljene igre i sva buduća ažuriranja. Hvala ti.';

  @override
  String get settingsFromDeveloperTitle => 'Od autora igre';

  @override
  String get settingsFromDeveloperBlurb =>
      'Football Nations Manager radi jedna osoba i dugoročno će se podržavati. Nikada neće biti reklama ni mikrotransakcija. Ako uživaš u igri, razmisli o kupnji pune verzije. Time se održavaju ažuriranja.';

  @override
  String get settingsFromDeveloperThanksBlurb =>
      'Football Nations Manager radi jedna osoba i dugoročno će se podržavati. Nikada neće biti reklama ni mikrotransakcija. Hvala ti na kupnji pune verzije. Time se održavaju ažuriranja.';

  @override
  String friendliesLikeYourCampaign(String rivals) {
    return 'Označeno ispod: momčadi koje igraju kao $rivals, protivnici koje te tek čekaju.';
  }

  @override
  String get friendliesCloseToYou =>
      'Označeno ispod: momčadi najbliže tebi na svjetskoj ljestvici. Nakon ždrijeba oznake prate tvoju skupinu.';

  @override
  String transfersMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transfera',
      few: '$count transfera',
      one: '$count transfer',
    );
    return '$_temp0';
  }

  @override
  String hubRoundPage(int page, int pages) {
    return '$page / $pages';
  }

  @override
  String get transfersNewer => 'Novije';

  @override
  String get transfersOlder => 'Više';

  @override
  String get transfersPagePrevious => 'Prethodna';

  @override
  String get transfersPageNext => 'Sljedeća';

  @override
  String transfersPageOf(int page, int pages) {
    return 'Stranica $page od $pages';
  }

  @override
  String get transfersMovedTo => 'Prešao u';

  @override
  String get transfersUnknownClub => 'Nepoznat klub';

  @override
  String yAgainstThemAgain0(String opponent, String count) {
    return 'Protiv: $opponent, već $count. put. Netko vodi bodove, i to su oni.';
  }

  @override
  String yAgainstThemAgain1(String opponent, String count) {
    return 'Opet $opponent. $count susreta, a još ih nismo odgonetnuli.';
  }

  @override
  String yAgainstThemAgain2(String opponent, String count) {
    return 'Susret broj $count: $opponent. Ovo više nije slučajnost.';
  }

  @override
  String yAgainstThemAgain3(String opponent, String count) {
    return '$opponent: $count utakmica i nijedna nas ništa nije naučila.';
  }

  @override
  String yAgainstThemAgain4(String opponent, String count) {
    return '$opponent, $count puta. Znaju točno što ćemo napraviti.';
  }

  @override
  String yAgainstThemAgain5(String opponent, String count) {
    return 'Što god $opponent ima na nas, nakon $count susreta još uvijek to ima.';
  }

  @override
  String ySameOldStory0(String count) {
    return '$count puta nam se ovo nedavno dogodilo. Kad ćemo priznati da smo to mi?';
  }

  @override
  String ySameOldStory1(String count) {
    return 'Već $count ovakvih poslijepodneva. To je obrazac, a ne niz nesreće.';
  }

  @override
  String ySameOldStory2(String count) {
    return 'Ovu istu utakmicu vidjeli smo $count puta u zadnje vrijeme. Isti scenarij, isti kraj.';
  }

  @override
  String ySameOldStory3(String count) {
    return '$count verzija istih devedeset minuta. Nitko to ne popravlja.';
  }

  @override
  String ySameOldStory4(String count) {
    return '$count puta. Ako do sada ne vidiš obrazac, ne gledaš.';
  }

  @override
  String ySameOldStory5(String count) {
    return 'Ista priča, $count puta zaredom. Isprike su ponestale prije nego rezultati.';
  }

  @override
  String get yToldYouSo0 => 'Rekao sam da ovo dolazi dok su svi slavili.';

  @override
  String get yToldYouSo1 =>
      'Dva dobra tjedna i opet smo zlatna generacija. I evo nas.';

  @override
  String get yToldYouSo2 =>
      'Oni što su mi prošli mjesec govorili da uživam sad su utihnuli.';

  @override
  String get yToldYouSo3 => 'Ne uživam u ovome. Jako malo. Ipak malo.';

  @override
  String get yToldYouSo4 =>
      'Nikad nije bilo tako dobro kako su vam govorili, a ovo je dokaz.';

  @override
  String get yToldYouSo5 =>
      'Svaki put. Kažu nam da je drukčije i svaki put nije.';

  @override
  String get tacticsSubOffAlready => 'Već izašao';

  @override
  String get tacticsSubInjured => 'Ozlijeđen';

  @override
  String get tacticsSubSentOffMark => 'Isključen';

  @override
  String get tacticsSubNoneLeft => 'Nema više izmjena';

  @override
  String get tacticsUndoLastChange => 'Poništi zadnju izmjenu';

  @override
  String get matchStrengthTitle => 'ŠTO POMIČE MOMČAD';

  @override
  String get strengthFactorFamiliarity => 'Uigrana formacija';

  @override
  String get strengthFactorFatigue => 'Umorne noge';

  @override
  String get strengthFactorClubForm => 'Forma u klubu';

  @override
  String get strengthFactorMorale => 'Svlačionica';

  @override
  String get strengthFactorCaptain => 'Kapetan';

  @override
  String get strengthFactorStaff => 'Stožer';

  @override
  String get strengthFactorDossier => 'Skautski dosje';

  @override
  String yDebut0(String name) {
    return '$name upisuje prvi nastup za reprezentaciju. Zapamtite ime.';
  }

  @override
  String yDebut1(String name) {
    return 'Debi za $name. Vidi se to na njemu, zar ne?';
  }

  @override
  String yDebut2(String name) {
    return '$name, prvi nastup. Da vidimo što će s njim.';
  }

  @override
  String yDebut3(String name) {
    return 'Debi za $name. Sastavu su negdje trebale svježe noge.';
  }

  @override
  String yDebut4(String name) {
    return '$name dobio nastup. U zadnje vrijeme dijelimo ih puno.';
  }

  @override
  String yDebut5(String name) {
    return 'Debi za $name. Još jedan kojeg ćemo do proljeća zaboraviti.';
  }

  @override
  String yDrought0(String name, String count) {
    return '$name $count utakmica nije zabio, a sve ostalo na terenu radi.';
  }

  @override
  String yDrought1(String name, String count) {
    return '$count utakmica bez gola za $name. Dolaze u nizu, uvijek je tako.';
  }

  @override
  String yDrought2(String name, String count) {
    return '$name: $count utakmica, nula golova.';
  }

  @override
  String yDrought3(String name, String count) {
    return '$count utakmica bez gola za $name. Vrijedi ga pratiti.';
  }

  @override
  String yDrought4(String name, String count) {
    return '$count utakmica. Nijedan gol. $name ne bi pogodio ni vrata staje.';
  }

  @override
  String yDrought5(String name, String count) {
    return '$name nije zabio u $count utakmica. Igrajte bilo koga drugog.';
  }

  @override
  String yRivalryLooms0(String opponent, String count) {
    return 'Sljedeći je $opponent. $count susreta i još uvijek znači sve.';
  }

  @override
  String yRivalryLooms1(String opponent, String count) {
    return 'Već $count. put protiv: $opponent. Neka dođu.';
  }

  @override
  String yRivalryLooms2(String opponent, String count) {
    return 'Sljedeći je $opponent. Odigrano: $count.';
  }

  @override
  String yRivalryLooms3(String opponent, String count) {
    return 'Ovaj tjedan susret broj $count: $opponent.';
  }

  @override
  String yRivalryLooms4(String opponent, String count) {
    return 'Opet $opponent. $count ovakvih i ništa nismo naučili.';
  }

  @override
  String yRivalryLooms5(String opponent, String count) {
    return '$count utakmica protiv: $opponent i još nas pobjeđuju. Sjajno.';
  }

  @override
  String get positionGoalkeeper => 'Vratar';

  @override
  String get positionLeftBack => 'Lijevi bek';

  @override
  String get positionCentreBack => 'Središnji branič';

  @override
  String get positionRightBack => 'Desni bek';

  @override
  String get positionDefensiveMid => 'Defenzivni vezni';

  @override
  String get positionCentralMid => 'Središnji vezni';

  @override
  String get positionAttackingMid => 'Ofenzivni vezni';

  @override
  String get positionLeftMid => 'Lijevi vezni';

  @override
  String get positionRightMid => 'Desni vezni';

  @override
  String get positionLeftWing => 'Lijevo krilo';

  @override
  String get positionRightWing => 'Desno krilo';

  @override
  String get positionStriker => 'Napadač';

  @override
  String get roleNone => 'Bez uloge';

  @override
  String get roleTargetMan => 'Ciljni napadač';

  @override
  String get rolePoacher => 'Lovac na golove';

  @override
  String get rolePlaymaker => 'Kreator igre';

  @override
  String get roleBallWinner => 'Osvajač lopte';

  @override
  String get roleInvertedWinger => 'Obrnuto krilo';

  @override
  String get roleBallPlayingDefender => 'Branič koji gradi igru';

  @override
  String get roleNoneBlurb => 'Igra svoju prirodnu igru.';

  @override
  String get roleTargetManBlurb =>
      'Dobiva skokove, spušta loptu. Asistencije i stajalice.';

  @override
  String get rolePoacherBlurb => 'Vreba u šesnaestercu. Puno više golova.';

  @override
  String get rolePlaymakerBlurb => 'Stvara prilike. Daleko više asistencija.';

  @override
  String get roleBallWinnerBlurb => 'Razbija igru, a ne završava je.';

  @override
  String get roleInvertedWingerBlurb => 'Ulazi unutra da šutira. Više golova.';

  @override
  String get roleBallPlayingDefenderBlurb => 'Gradi napade iz obrane.';

  @override
  String get federationDeptYouth => 'Akademija mladih';

  @override
  String get federationDeptCommercial => 'Komercijala / PR';

  @override
  String get federationDeptMedical => 'Medicina i sportska znanost';

  @override
  String get federationDeptNaturalisation => 'Ured za naturalizaciju';

  @override
  String get federationDeptBoardRelations => 'Odnosi s odborom';

  @override
  String get federationDeptYouthBlurb =>
      'Bolji talenti iz akademije debitiraju za tvoju reprezentaciju sljedećeg ciklusa.';

  @override
  String get federationDeptCommercialBlurb =>
      'Sponzorstvo donosi dodatan prihod na kraju ciklusa.';

  @override
  String get federationDeptMedicalBlurb =>
      'Manje ozljeda. Sastav ostaje dostupan cijeli ciklus.';

  @override
  String get federationDeptNaturalisationBlurb =>
      'Više stranih igrača nudi prelazak u tvoju reprezentaciju.';

  @override
  String get federationDeptBoardRelationsBlurb =>
      'Odbor strpljivije ocjenjuje tvoje rezultate.';

  @override
  String get federationBuildingAcademy => 'Akademija';

  @override
  String get federationBuildingCommercial => 'Komercijalno sjedište';

  @override
  String get federationBuildingMedical => 'Medicinski centar';

  @override
  String get federationBuildingScouting => 'Skautski ured';

  @override
  String get federationBuildingBoardroom => 'Dvorana odbora';

  @override
  String get moraleBuoyant => 'Vedar';

  @override
  String get moralePositive => 'Pozitivan';

  @override
  String get moraleSettled => 'Stabilan';

  @override
  String get moraleUneasy => 'Nemiran';

  @override
  String get moraleRockBottom => 'Na dnu';

  @override
  String get matchTabTimeline => 'TIJEK';

  @override
  String get matchTabStats => 'STATISTIKA';

  @override
  String get matchTabLineups => 'POSTAVE';

  @override
  String get matchPenalty => 'JEDANAESTERAC';

  @override
  String get matchStateLevel => 'Rezultat je izjednačen';

  @override
  String matchStateLead(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vodiš za $count golova',
      few: 'Vodiš za $count gola',
      one: 'Vodiš za $count gol',
    );
    return '$_temp0';
  }

  @override
  String matchStateTrail(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Zaostaješ za $count golova',
      few: 'Zaostaješ za $count gola',
      one: 'Zaostaješ za $count gol',
    );
    return '$_temp0';
  }

  @override
  String matchPossessionShare(int possession) {
    return '$possession% posjeda lopte';
  }

  @override
  String get boardVerdictSackedTitle => 'Odbor te smijenio';

  @override
  String boardVerdictSackedBody(int rating) {
    return 'Loš ciklus (ocjena $rating%). Tvoja vladavina ovdje završava. Sada će te angažirati samo slabije reprezentacije.';
  }

  @override
  String get boardVerdictDelightedTitle => 'Odbor je oduševljen';

  @override
  String boardVerdictDelightedBody(int rating, String best) {
    return 'Izvanredan ciklus (ocjena $rating%). Najbolji učinak: $best. Veće reprezentacije su zainteresirane, ili možeš ostati i graditi.';
  }

  @override
  String get boardVerdictSolidTitle => 'Solidan ciklus';

  @override
  String boardVerdictSolidBody(int rating) {
    return 'Odbor je zadovoljan (ocjena $rating%). Nekoliko reprezentacija sličnog ranga primilo bi te, ali nema pritiska da odeš.';
  }

  @override
  String get boardVerdictExpectedMoreTitle => 'Odbor je očekivao više';

  @override
  String boardVerdictExpectedMoreBody(int rating) {
    return 'Razočaravajući ciklus (ocjena $rating%). Zadržavaš posao, ali sve ponude su korak unazad.';
  }

  @override
  String get boardVerdictPressureTitle => 'Pod stvarnim si pritiskom';

  @override
  String boardVerdictPressureBody(int rating) {
    return 'Slab ciklus (ocjena $rating%). Preživljavaš, ali ako poželiš novi početak, zanimaju se samo slabije zemlje.';
  }

  @override
  String get boardVerdictHeroTitle => 'Zemlja stoji uz tebe';

  @override
  String boardVerdictHeroNote(String nation, int cycles) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles ciklusa',
      few: '$cycles ciklusa',
      one: '$cycles ciklus',
    );
    return ' $nation te obožava, nacionalni si heroj nakon $_temp0; posao ti je siguran koliko god želiš.';
  }

  @override
  String get boardVerdictTheNation => 'Zemlja';

  @override
  String get boardVerdictBestQuiet => 'miran ciklus';

  @override
  String get boardVerdictBestCycle => 'ciklus u cjelini';

  @override
  String boardVerdictBestWorld(String placement) {
    return 'Svjetsko prvenstvo: $placement';
  }

  @override
  String get finishThirdPlace => 'Treće mjesto';

  @override
  String get finishFourthPlace => 'Četvrto mjesto';

  @override
  String get finishDidNotQualify => 'Nije se kvalificirao';

  @override
  String get careerRepIconic => 'Ikona';

  @override
  String get careerRepRenowned => 'Ugledan';

  @override
  String get careerRepEstablished => 'Etabliran';

  @override
  String get careerRepRising => 'U usponu';

  @override
  String get careerRepUnproven => 'Neafirmiran';

  @override
  String get hubOfferStepUp => 'Korak naprijed';

  @override
  String get hubOfferLateral => 'Isti rang';

  @override
  String get hubOfferRebuild => 'Obnova';

  @override
  String careerNationsCupWon(String league) {
    return 'Liga $league · Prvaci';
  }

  @override
  String careerNationsCupRunnerUp(String league) {
    return 'Liga $league · Drugoplasirani';
  }

  @override
  String careerNationsCupSemi(String league) {
    return 'Liga $league · Polufinalist';
  }

  @override
  String careerNationsCupPlaced(String league, int position) {
    return 'Liga $league · #$position';
  }

  @override
  String tourRunInto(String round) {
    return 'Sljedeće: $round';
  }

  @override
  String get tourRunIntoThirdPlace => 'Sljedeće: utakmica za treće mjesto';

  @override
  String tourRunThrough(String round) {
    return 'Prošao dalje: $round';
  }

  @override
  String tourRunOut(String round) {
    return 'Ispao: $round';
  }

  @override
  String get tourRunInGroup => 'Natjecanje po skupinama traje';

  @override
  String get tourRunGroupOut => 'Ispao u natjecanju po skupinama';

  @override
  String resultsCycleTitle(int year, String nation) {
    return 'Ciklus $year · $nation';
  }

  @override
  String resultsCycleRecord(int played, int won, int drawn, int lost) {
    return '$played odigrano  ·  ${won}P ${drawn}N ${lost}I';
  }

  @override
  String resultsCycleFinish(String finish) {
    return 'Svjetsko prvenstvo: $finish';
  }

  @override
  String get resultsCycleUnderway => 'Još traje';

  @override
  String yTurnedItRound0(String opponent) {
    return 'Poluvrijeme: dva gola zaostatka (protivnik: $opponent), a sve su vratili do posljednjeg. To je momčad.';
  }

  @override
  String yTurnedItRound1(String opponent) {
    return 'Dva gola zaostatka, protivnik $opponent, a na kraju više nije bilo važno. Malo tko to može.';
  }

  @override
  String yTurnedItRound2(String opponent) {
    return 'Poluvrijeme: dva gola minusa. Kraj utakmice: više ne. Protivnik: $opponent. Drugo poluvrijeme bila je posve druga utakmica.';
  }

  @override
  String yTurnedItRound3(String opponent) {
    return 'Preokret iz zaostatka od dva gola, protivnik $opponent. Što god da je rečeno u svlačionici, recite to svaki tjedan.';
  }

  @override
  String yTurnedItRound4(String opponent) {
    return 'Dobro, vratili smo se (protivnik: $opponent). A sad neka mi netko objasni onih prvih četrdeset pet minuta.';
  }

  @override
  String yTurnedItRound5(String opponent) {
    return 'Dva gola minusa, protivnik $opponent, a mi bismo trebali biti oduševljeni. Popravite prvo poluvrijeme.';
  }

  @override
  String yThrewItAway0(String opponent) {
    return 'Na poluvremenu dva gola prednosti (protivnik: $opponent) pa je sve otišlo. To se događa i boljima.';
  }

  @override
  String yThrewItAway1(String opponent) {
    return 'Dva gola prednosti, protivnik $opponent, i sve je propalo. Pred nama je dug ciklus, ima vremena.';
  }

  @override
  String yThrewItAway2(String opponent) {
    return 'Poluvrijeme: dva gola plusa. Kraj utakmice: ništa slično. Protivnik: $opponent.';
  }

  @override
  String yThrewItAway3(String opponent) {
    return 'Prednost od dva gola, protivnik $opponent, nestala u svega četrdeset pet minuta.';
  }

  @override
  String yThrewItAway4(String opponent) {
    return 'Dva gola ispred i sve smo izgubili. Protivnik: $opponent. Netko će za to odgovarati.';
  }

  @override
  String yThrewItAway5(String opponent) {
    return 'Dva gola prednosti, protivnik $opponent, a mi smo ovo uspjeli. Svaki put.';
  }

  @override
  String get cycleBackupDone =>
      'Karijera je spremljena u FNM mapu na ovom telefonu. Deinstalacijom aplikacije briše se i ona: ako želiš kopiju na drugom mjestu, na zaslonu spremljenih igara upotrijebi „Sigurnosna kopija ove igre“.';

  @override
  String get cycleBackupFailed =>
      'Ovaj put nije bilo moguće spremiti sigurnosnu kopiju karijere.';

  @override
  String pressMomentBigWinWarm1(String opponent) {
    return 'Noć za pamćenje (protivnik: $opponent). Koliko ste ponosni na ovu momčad?';
  }

  @override
  String pressMomentBigWinWarm2(String opponent) {
    return 'Protivnik $opponent nije vam mogao parirati. Je li ovo momčad u koju ste oduvijek vjerovali?';
  }

  @override
  String pressMomentBigWinNeutral1(String opponent) {
    return 'Velika pobjeda, protivnik $opponent. Što je večeras napravilo razliku?';
  }

  @override
  String pressMomentBigWinNeutral2(String opponent) {
    return 'Protivnik $opponent svladan, i to bez problema. Gdje ste dobili utakmicu?';
  }

  @override
  String pressMomentBigWinHostile1(String opponent) {
    return 'Dobra pobjeda, protivnik $opponent. Jedna dobra večer: zašto bi itko vjerovao da će potrajati?';
  }

  @override
  String pressMomentBigWinHostile2(String opponent) {
    return 'Fin rezultat, protivnik $opponent. Je li to bio Vaš plan ili su igrači sami smislili što treba?';
  }

  @override
  String pressMomentBigLossWarm1(String opponent) {
    return 'Teška večer, protivnik $opponent. Što poručujete igračima nakon ovakve utakmice?';
  }

  @override
  String pressMomentBigLossWarm2(String opponent) {
    return 'Nitko to nije očekivao, protivnik $opponent. Je li to bila jednostavno jedna od onih večeri?';
  }

  @override
  String pressMomentBigLossNeutral1(String opponent) {
    return 'Ovo je bila poražavajuća večer, protivnik $opponent. Što je pošlo po zlu?';
  }

  @override
  String pressMomentBigLossNeutral2(String opponent) {
    return '$opponent vas je rastavio na dijelove. Je li ovaj sastav dovoljno dobar?';
  }

  @override
  String pressMomentBigLossHostile1(String opponent) {
    return 'Protiv protivnika $opponent zaostajali ste u svemu. Kako ste dopustili da dođe do ovoga?';
  }

  @override
  String pressMomentBigLossHostile2(String opponent) {
    return '$opponent je zabijao kako je htio. Gdje je večeras bio plan?';
  }

  @override
  String pressMomentCrisisWarm1(String opponent) {
    return 'Opet nam je izmaklo, ovaj put protivnik: $opponent. Kako preokrenuti ovaj niz?';
  }

  @override
  String pressMomentCrisisWarm2(String opponent) {
    return 'Rezultata nema, a $opponent je sve pogoršao. Vjerujete li još u ovu momčad?';
  }

  @override
  String pressMomentCrisisNeutral1(String opponent) {
    return 'Opet bez pobjede, ovaj put protiv $opponent, a odbor prati. Je li Vaš posao siguran?';
  }

  @override
  String pressMomentCrisisNeutral2(String opponent) {
    return 'Nakon utakmice s protivnikom $opponent niz postaje dug. Brine li Vas vlastita budućnost?';
  }

  @override
  String pressMomentCrisisHostile1(String opponent) {
    return 'I protivnik $opponent povrh svega. Vaš prethodnik dobio je otkaz na ovakvom nizu. Zašto biste Vi preživjeli?';
  }

  @override
  String pressMomentCrisisHostile2(String opponent) {
    return 'Nakon još jedne ovakve večeri (protivnik: $opponent) svaka radijska emisija traži Vaš odlazak. Biste li odstupili kad bi odbor to zatražio?';
  }

  @override
  String pressMomentJobVerdictWarm1(String opponent) {
    return 'Stavili ste posao na kocku, a nakon utakmice s protivnikom $opponent nije ispalo po Vašem. Kako se držite?';
  }

  @override
  String pressMomentJobVerdictWarm2(String opponent) {
    return 'Tri utakmice su gotove, posljednja protiv $opponent. Test ste postavili sami. Što mislite o presudi?';
  }

  @override
  String pressMomentJobVerdictNeutral1(String opponent) {
    return 'Rekli ste nam da Vam sudimo po sljedeće tri. Nakon utakmice s protivnikom $opponent jesmo. Je li posao još Vaš?';
  }

  @override
  String pressMomentJobVerdictNeutral2(String opponent) {
    return 'Tri utakmice, posljednja protiv $opponent, a ne ono što ste obećali. Jeste li s odborom razgovarali o svojoj budućnosti?';
  }

  @override
  String pressMomentJobVerdictHostile1(String opponent) {
    return 'Test ste postavili sami i pali ste na njemu (protivnik: $opponent). Hoćete li dati ostavku?';
  }

  @override
  String pressMomentJobVerdictHostile2(String opponent) {
    return 'Vaše riječi, ne naše: sudite mi po sljedeće tri. Nakon utakmice s protivnikom $opponent, zašto još sjedite ovdje?';
  }

  @override
  String get pressBeatWhoToBlameWarm1 => 'Želite više od njih. Netko posebno?';

  @override
  String get pressBeatWhoToBlameWarm2 =>
      'Visoko ste podigli letvicu. Tko prvi mora zakoračiti naprijed?';

  @override
  String get pressBeatWhoToBlameNeutral1 =>
      'Kažete da neki od njih moraju pogledati sami sebe. Koga mislite?';

  @override
  String get pressBeatWhoToBlameNeutral2 =>
      'Kažete da nije dovoljno dobro. O kome govorite?';

  @override
  String get pressBeatWhoToBlameHostile1 =>
      'Ostajete neodređeni. Hoćete li imenovati imena ili sve pada na Vas?';

  @override
  String get pressBeatWhoToBlameHostile2 =>
      'Svaki tjedan kriv je netko drugi. Tko je ovaj put?';

  @override
  String get pressBeatIfYouDontWarm1 =>
      'Hrabre riječi. A ako sljedeća ne ispadne po Vašem?';

  @override
  String get pressBeatIfYouDontWarm2 =>
      'Zemlja će Vas držati za riječ. Što ako ne uspije?';

  @override
  String get pressBeatIfYouDontNeutral1 => 'A ako je ne dobijete? Što onda?';

  @override
  String get pressBeatIfYouDontNeutral2 =>
      'Sad ste to rekli. Što se događa ako griješite?';

  @override
  String get pressBeatIfYouDontHostile1 =>
      'U ovoj prostoriji već smo čuli obećanja. Što dugujete navijačima ako i ovo propadne?';

  @override
  String get pressBeatIfYouDontHostile2 =>
      'A kad se to ne dogodi, što će biti isprika?';

  @override
  String get pressBeatFollowUpWarm1 =>
      'Još jedno, ako imate snage. Na čemu ova momčad još mora raditi?';

  @override
  String get pressBeatFollowUpWarm2 =>
      'Kad se slegne prašina, što iz večerašnjeg dana nosite u sljedeću utakmicu?';

  @override
  String get pressBeatFollowUpNeutral1 =>
      'Idemo malo dublje. Što se mora popraviti prije sljedeće utakmice?';

  @override
  String get pressBeatFollowUpNeutral2 =>
      'Ako pogledamo dalje od rezultata: je li ovaj sastav tamo gdje ga želite?';

  @override
  String get pressBeatFollowUpHostile1 =>
      'Puno riječi, malo rečeno. Što se zapravo mijenja od sada?';

  @override
  String get pressBeatFollowUpHostile2 =>
      'Navijači žele izravan odgovor. Je li ova momčad dovoljno dobra, da ili ne?';

  @override
  String pressBeatStandoutWarm1(String player) {
    return '$player je večeras bio izvanredan. Dokle može stići?';
  }

  @override
  String pressBeatStandoutWarm2(String player) {
    return '$player je večeras u svim naslovima. Jeste li to očekivali?';
  }

  @override
  String pressBeatStandoutNeutral1(String player) {
    return '$player se istaknuo. Što ste tražili od njega večeras?';
  }

  @override
  String pressBeatStandoutNeutral2(String player) {
    return 'Je li $player večeras napravio razliku?';
  }

  @override
  String pressBeatStandoutHostile1(String player) {
    return 'Bez igrača $player priča je drukčija. Je li ovo momčad ili jedan igrač?';
  }

  @override
  String pressBeatStandoutHostile2(String player) {
    return '$player je bio sjajan. Vaša zasluga ili njegova?';
  }

  @override
  String pressBeatStrugglerWarm1(String player) {
    return '$player je imao tešku večer. Nosi li neku ozljedu?';
  }

  @override
  String pressBeatStrugglerWarm2(String player) {
    return '$player nije imao svoju večer. Hoćete li ga ohrabriti?';
  }

  @override
  String pressBeatStrugglerNeutral1(String player) {
    return '$player je večeras tavorio. Zadržava li mjesto u sastavu?';
  }

  @override
  String pressBeatStrugglerNeutral2(String player) {
    return '$player je djelovao sporo. Što mislite o njegovoj utakmici?';
  }

  @override
  String pressBeatStrugglerHostile1(String player) {
    return '$player je opet bio putnik. Zašto ga stalno postavljate?';
  }

  @override
  String pressBeatStrugglerHostile2(String player) {
    return 'Svi su vidjeli da $player nije bio u formi. Svi osim klupe?';
  }

  @override
  String get pressThrowbackWinNextKeptWarm =>
      'Rekli ste da ćete dobiti sljedeću i jeste. Je li dobro biti u pravu?';

  @override
  String get pressThrowbackWinNextKeptNeutral =>
      'Obećali ste pobjedu u sljedećoj utakmici i ispunili ste. Samouvjerenost ili hvalisanje?';

  @override
  String get pressThrowbackWinNextKeptHostile =>
      'Rekli ste da ćete dobiti sljedeću i jeste. Sreća ili bismo Vas trebali početi slušati?';

  @override
  String get pressThrowbackWinNextBrokenWarm =>
      'Rekli ste da ćete dobiti onu utakmicu. Nije se dogodilo. Što je pošlo po zlu?';

  @override
  String get pressThrowbackWinNextBrokenNeutral =>
      'Rekli ste da ćete dobiti sljedeću. Niste. Zašto bismo vjerovali sljedećem obećanju?';

  @override
  String get pressThrowbackWinNextBrokenHostile =>
      'Rekli ste da ćete dobiti sljedeću. Niste. Znače li Vaše riječi išta u ovoj prostoriji?';

  @override
  String get pressThrowbackJobKeptWarm =>
      'Tražili ste da Vam se sudi po tri utakmice i prošli ste. Opravdani?';

  @override
  String get pressThrowbackJobKeptNeutral =>
      'Sudite mi po sljedeće tri, rekli ste. Sudili smo, a rezultati su stigli. Što Vas je naučio taj test?';

  @override
  String get pressThrowbackJobKeptHostile =>
      'Dali ste si tri utakmice i prebrodili ih. Je li test ikad bio tako težak?';

  @override
  String get pressThrowbackJobBrokenWarm =>
      'Tražili ste da Vam se sudi po tri utakmice. Nisu ispale po Vašem. Što ste naučili?';

  @override
  String get pressThrowbackJobBrokenNeutral =>
      'Rekli ste, sudite mi po sljedeće tri. Tri su prošle, a s njima i povjerenje. Što sad?';

  @override
  String get pressThrowbackJobBrokenHostile =>
      'Postavili ste test i pali na njemu. Zašto bi Vam itko sad vjerovao na riječ?';

  @override
  String pressThrowbackBackKeptWarm(String player) {
    return 'Podržali ste igrača $player kad drugi nisu. Opravdao je to. Je li dio zasluge Vaš?';
  }

  @override
  String pressThrowbackBackKeptNeutral(String player) {
    return 'Podržali ste igrača $player. Opravdao je. Vjera ili znanje?';
  }

  @override
  String pressThrowbackBackKeptHostile(String player) {
    return 'Podržali ste igrača $player i za promjenu se isplatilo. Hoćete li sljedeći put biti toliko sigurni?';
  }

  @override
  String pressThrowbackBackBrokenWarm(String player) {
    return 'Stali ste uz igrača $player, a nije ispalo dobro. Vjerujete li još u njega?';
  }

  @override
  String pressThrowbackBackBrokenNeutral(String player) {
    return 'Podržali ste igrača $player. Nije to vratio. Je li to bila greška?';
  }

  @override
  String pressThrowbackBackBrokenHostile(String player) {
    return 'Vaša prosudba ili Vaša odanost: što je podbacilo kod igrača $player?';
  }

  @override
  String pressThrowbackBlameKeptWarm(String player) {
    return 'Bili ste strogi prema igraču $player, a utakmice od tada daju Vam za pravo. Ima li u tome zadovoljstva?';
  }

  @override
  String pressThrowbackBlameKeptNeutral(String player) {
    return 'Javno ste prozvali igrača $player i nije odgovorio. Ima li za njega puta natrag?';
  }

  @override
  String pressThrowbackBlameKeptHostile(String player) {
    return 'Ostavili ste igrača $player na cjedilu i nije se oporavio. Jeste li ga slomili?';
  }

  @override
  String pressThrowbackBlameBrokenWarm(String player) {
    return 'Prozvali ste igrača $player, a on Vam je odgovorio na terenu. Je li to bio plan od početka?';
  }

  @override
  String pressThrowbackBlameBrokenNeutral(String player) {
    return 'Okrivili ste igrača $player, a on je od tada jedan od Vaših najboljih. Dugujete li mu ispriku?';
  }

  @override
  String pressThrowbackBlameBrokenHostile(String player) {
    return 'Bacili ste igrača $player pod autobus, a on Vam je od tada najbolji. Hoćete li se ispričati?';
  }

  @override
  String get pressReplyCreditPlayers1 =>
      'Ovi igrači dali su mi sve. Ne bih mijenjao nijednog.';

  @override
  String get pressReplyCreditPlayers2 =>
      'Nitko ne radi više od ove skupine. Branit ću ih cijeli dan.';

  @override
  String get pressReplyCreditPlayers3 =>
      'S ove stolice nećete čuti ni riječ protiv mojih igrača.';

  @override
  String get pressReplyCreditPlayers4 =>
      'Zasluga je igrača, ne moja. Pišite o njima.';

  @override
  String get pressReplyTakeResponsibility1 =>
      'Ovo je na meni. Ja sam odabrao sastav i ja sam ih postavio.';

  @override
  String get pressReplyTakeResponsibility2 =>
      'Sudite meni, ne njima. To je moja momčad i moja odgovornost.';

  @override
  String get pressReplyTakeResponsibility3 =>
      'Ako tražite krivca, evo me, sjedim ovdje.';

  @override
  String get pressReplyTakeResponsibility4 =>
      'Odgovornost je moja. Ostavite igrače po strani.';

  @override
  String get pressReplyDemandMore1 =>
      'Želim više. Neki od njih točno znaju što mislim.';

  @override
  String get pressReplyDemandMore2 =>
      'Na ovoj razini trud nije dovoljan. Želim više i rekao sam im to.';

  @override
  String get pressReplyDemandMore3 =>
      'Od svakog od njih očekujem više, počevši od sutra.';

  @override
  String get pressReplyDemandMore4 =>
      'Neki od njih moraju pogledati sami sebe. Nisam zadovoljan.';

  @override
  String get pressReplyPromiseWinNext1 =>
      'Dobit ćemo sljedeću. Možete zapisati.';

  @override
  String get pressReplyPromiseWinNext2 =>
      'Zapamtite moje riječi: dobivamo sljedeću utakmicu.';

  @override
  String get pressReplyPromiseWinNext3 =>
      'Sljedeća utakmica, pobjeđujemo. Kažem to ovdje da me možete držati za riječ.';

  @override
  String get pressReplyPromiseWinNext4 =>
      'Siguran sam u ovu momčad. Dobivamo sljedeću utakmicu.';

  @override
  String get pressReplyJobOnTheLine1 =>
      'Sudite mi po sljedeće tri utakmice. To je pošteno.';

  @override
  String get pressReplyJobOnTheLine2 =>
      'Dajte mi tri utakmice. Ako do tada ne bude kako treba, sudite mi.';

  @override
  String get pressReplyJobOnTheLine3 =>
      'Sljedeće tri pokazat će jesam li pravi čovjek. Držite me za to.';

  @override
  String get pressReplyJobOnTheLine4 =>
      'Tri utakmice. Poslije toga pišite o meni što god želite.';

  @override
  String get pressReplyDeflect1 =>
      'Idemo utakmicu po utakmicu. Nemam što dodati.';

  @override
  String get pressReplyDeflect2 => 'Danas vam neću praviti naslove.';

  @override
  String get pressReplyDeflect3 => 'Sljedeća utakmica. Samo o tome razmišljam.';

  @override
  String get pressReplyDeflect4 => 'Što mislim ostaje u svlačionici.';

  @override
  String get pressReplyTakeCredit1 =>
      'Rekao sam to jer sam vjerovao u to, i bio sam u pravu.';

  @override
  String get pressReplyTakeCredit2 => 'Dobro sam to pročitao. Zato sam ovdje.';

  @override
  String get pressReplyTakeCredit3 =>
      'Zovite to prosudbom. Znao sam što govorim.';

  @override
  String get pressReplyTakeCredit4 =>
      'Donio sam odluku i uspjela je. To ću prihvatiti.';

  @override
  String get pressReplyStandByIt1 =>
      'Rekao sam što sam vjerovao. Stojim iza toga.';

  @override
  String get pressReplyStandByIt2 => 'Ne povlačim ni riječ.';

  @override
  String get pressReplyStandByIt3 =>
      'Isti odgovor kao tada. Mislio sam to, i još uvijek mislim.';

  @override
  String get pressReplyStandByIt4 => 'Rekao bih to i sutra.';

  @override
  String get pressReplyAdmitMistake1 =>
      'Tu sam pogriješio. Preuzimam to na sebe.';

  @override
  String get pressReplyAdmitMistake2 =>
      'Pošteno, krivo sam procijenio. Naučit ću iz toga.';

  @override
  String get pressReplyAdmitMistake3 => 'Bio sam u krivu i to mogu reći.';

  @override
  String get pressReplyAdmitMistake4 =>
      'Ta odluka nije uspjela, a bila je moja.';

  @override
  String pressReplyBackPlayer1(String player) {
    return '$player ima moju punu podršku. Doći će do izražaja.';
  }

  @override
  String pressReplyBackPlayer2(String player) {
    return 'Vjerujem u igrača $player i pokazat će vam zašto.';
  }

  @override
  String pressReplyBackPlayer3(String player) {
    return 'Od mene nećete čuti ni riječ protiv igrača $player. Ispunit će očekivanja.';
  }

  @override
  String pressReplyBackPlayer4(String player) {
    return '$player ostaje u mojim planovima. Pratite što će napraviti sljedeće.';
  }

  @override
  String pressReplyBlamePlayer1(String player) {
    return '$player nas je večeras iznevjerio i on to zna.';
  }

  @override
  String pressReplyBlamePlayer2(String player) {
    return 'Od igrača $player očekivao sam puno više. On mora odgovoriti na to.';
  }

  @override
  String pressReplyBlamePlayer3(String player) {
    return '$player nije bio na razini. To ću reći javno.';
  }

  @override
  String pressReplyBlamePlayer4(String player) {
    return 'To od igrača $player nije bilo dovoljno dobro i čut će to od mene.';
  }

  @override
  String get pressOnRecordWinNext =>
      'Za zapisnik: pobijedit ćete u sljedećoj utakmici.';

  @override
  String get pressOnRecordJob => 'Za zapisnik: sudi Vam se po sljedeće tri.';

  @override
  String pressOnRecordBack(String player) {
    return 'Za zapisnik: podržavate igrača $player.';
  }

  @override
  String pressOnRecordBlame(String player) {
    return 'Za zapisnik: $player Vas je iznevjerio.';
  }

  @override
  String yStatementKept0(String nation) {
    return 'Rekao je to i dogodilo se. $nation ima izbornika koji misli što kaže.';
  }

  @override
  String yStatementKept1(String nation) {
    return 'Rekao je naglas pa je to i napravio. To je čovjek kakav je trebao $nation.';
  }

  @override
  String yStatementKept2(String nation) {
    return '$nation: rekao je i obistinilo se. Dobro, priznajem.';
  }

  @override
  String yStatementKept3(String nation) {
    return 'Stavio je to u zapisnik i izdržalo je. Bod za njega. $nation ide dalje.';
  }

  @override
  String yStatementKept4(String nation) {
    return 'Jednom je pogodio. $nation, nemoj se naviknuti.';
  }

  @override
  String yStatementKept5(String nation) {
    return 'I pokvaren sat dvaput dnevno pokazuje točno. $nation je ovaj put imao sreće.';
  }

  @override
  String yStatementBroken0(String nation) {
    return 'Rekao je to i nije uspjelo. Još sam uz njega. $nation ide opet.';
  }

  @override
  String yStatementBroken1(String nation) {
    return '$nation: obećao je više nego što smo dobili, ali radije imam izbornika koji vjeruje u sebe.';
  }

  @override
  String yStatementBroken2(String nation) {
    return '$nation: rekao je to za zapisnik i nije se dogodilo. Ljudi će pamtiti.';
  }

  @override
  String yStatementBroken3(String nation) {
    return 'Velike riječi, ništa iza njih. $nation: sljedeći put manje govori.';
  }

  @override
  String yStatementBroken4(String nation) {
    return 'Stao je pred nas i rekao. Pa ovo. $nation zaslužuje bolje od priče.';
  }

  @override
  String yStatementBroken5(String nation) {
    return 'Njegova riječ sad ne vrijedi ništa. Zapiši, $nation.';
  }

  @override
  String get ncZoneNorth => 'Sjeverna zona';

  @override
  String get ncZoneWest => 'Zapadna zona';

  @override
  String get ncZoneEast => 'Istočna zona';

  @override
  String get ncZoneCentralSouthern => 'Središnja i južna zona';

  @override
  String careerNationsCupZoneWon(String zone) {
    return '$zone · Prvaci';
  }

  @override
  String careerNationsCupZoneRunnerUp(String zone) {
    return '$zone · Drugoplasirani';
  }

  @override
  String careerNationsCupZoneSemi(String zone) {
    return '$zone · Polufinalist';
  }

  @override
  String careerNationsCupZoneRoundOf16(String zone) {
    return '$zone · Osmina finala';
  }

  @override
  String careerNationsCupZoneQuarter(String zone) {
    return '$zone · Četvrtfinalist';
  }

  @override
  String careerNationsCupZonePlaced(String zone, int position) {
    return '$zone · #$position';
  }

  @override
  String get objectiveNcFinalsEight => 'Stigni do četvrtfinala';

  @override
  String get objectiveNcZoneWinGroup => 'Pobijedi u svojoj skupini';

  @override
  String get finishNcFinalsEight => 'Četvrtfinale';

  @override
  String get finishNcBottomHalf => 'Donja polovica skupine';

  @override
  String get tourContTabZones => 'ZONE';

  @override
  String get tourContTabFinalsEight => 'NOKAUT-FAZA';

  @override
  String get tourContFinalsEightSoon =>
      'Nokaut-faza počinje u studenom osminom finala: svih 14 pobjednika skupina i 2 najbolja drugoplasirana.';

  @override
  String get tourContQuarterFinals => 'ČETVRTFINALE';

  @override
  String get tourContZoneAdvancement =>
      'Svaki pobjednik skupine ide u osminu finala, a pridružuju im se 2 najbolja drugoplasirana. Nitko ne ispada.';

  @override
  String tourContZoneHeadingYours(String zone) {
    return '$zone ★';
  }

  @override
  String get compNorthAmericaNationsCup => 'Nations Cup Sjeverne Amerike';

  @override
  String get compAfricanNationsCup => 'Nations Cup';

  @override
  String get objectiveNcWinItNorthAmerica =>
      'Osvoji Nations Cup Sjeverne Amerike';

  @override
  String get objectiveNcWinItAfrica => 'Osvoji Nations Cup';

  @override
  String get objectiveNcReachFinalNorthAmerica =>
      'Stigni do finala natjecanja Nations Cup Sjeverne Amerike';

  @override
  String get objectiveNcReachFinalAfrica =>
      'Stigni do finala natjecanja Nations Cup';

  @override
  String get finishNcChampionsNorthAmerica =>
      'Pobjednici natjecanja Nations Cup Sjeverne Amerike';

  @override
  String get finishNcChampionsAfrica => 'Pobjednici natjecanja Nations Cup';

  @override
  String pressAimQualWarm1(String competition) {
    return 'Počinju kvalifikacije ($competition), a zemlja vjeruje u ovu momčad. Što ciljate?';
  }

  @override
  String pressAimQualWarm2(String competition) {
    return 'Nova kvalifikacijska kampanja ($competition), a raspoloženje je odlično. Dokle ova momčad može stići?';
  }

  @override
  String pressAimQualNeutral1(String competition) {
    return 'Počinju kvalifikacije ($competition). Koji je cilj za ovu kampanju?';
  }

  @override
  String pressAimQualNeutral2(String competition) {
    return 'Kvalifikacije su tu ($competition). Gdje vidite ovu momčad na kraju?';
  }

  @override
  String pressAimQualHostile1(String competition) {
    return 'Počinju kvalifikacije ($competition), a mnogi sumnjaju da ćete stići do cilja. Što im poručujete?';
  }

  @override
  String pressAimQualHostile2(String competition) {
    return 'Još jedna kvalifikacijska kampanja ($competition). Zašto bi itko vjerovao da će ova biti drukčija?';
  }

  @override
  String pressAimFinalsWarm1(String competition) {
    return 'Počinje natjecanje ($competition), a cijela zemlja je uz Vas. Dokle možete stići?';
  }

  @override
  String pressAimFinalsWarm2(String competition) {
    return 'Stigli ste na natjecanje ($competition), a navijači sanjaju. Koji je cilj?';
  }

  @override
  String pressAimFinalsNeutral1(String competition) {
    return 'Ovog tjedna počinje natjecanje ($competition). Što bi bio uspjeh?';
  }

  @override
  String pressAimFinalsNeutral2(String competition) {
    return 'Prva utakmica na natjecanju ($competition) je blizu. Postavite nam cilj.';
  }

  @override
  String pressAimFinalsHostile1(String competition) {
    return 'Počinje natjecanje ($competition), a nitko ne očekuje mnogo. Čemu se zapravo nadate?';
  }

  @override
  String pressAimFinalsHostile2(String competition) {
    return 'Na natjecanju ste ($competition), ali sumnje nisu nestale. Koji je Vaš cilj?';
  }

  @override
  String pressBeatRivalWarm1(String rival) {
    return 'U Vašoj skupini je reprezentacija: $rival. Brine li Vas?';
  }

  @override
  String pressBeatRivalWarm2(String rival) {
    return 'Ždrijeb Vam je donio reprezentaciju: $rival. Kako vidite tu utakmicu?';
  }

  @override
  String pressBeatRivalNeutral1(String rival) {
    return 'Najjača u Vašoj skupini djeluje reprezentacija: $rival. Jesu li favoriti?';
  }

  @override
  String pressBeatRivalNeutral2(String rival) {
    return 'Što mislite o reprezentaciji: $rival?';
  }

  @override
  String pressBeatRivalHostile1(String rival) {
    return 'U Vašoj skupini je reprezentacija: $rival. Iskreno, možete li izaći na kraj s njima?';
  }

  @override
  String pressBeatRivalHostile2(String rival) {
    return 'Većina očekuje da će Vas pobijediti reprezentacija: $rival. Griješe li?';
  }

  @override
  String pressBeatKeyPlayerWarm1(String player) {
    return '$player je u sjajnoj formi. Je li ovo njegov trenutak?';
  }

  @override
  String pressBeatKeyPlayerWarm2(String player) {
    return '$player je u svim naslovima. Može li nositi ovu momčad?';
  }

  @override
  String pressBeatKeyPlayerNeutral1(String player) {
    return 'Koliko ova kampanja ovisi o igraču $player?';
  }

  @override
  String pressBeatKeyPlayerNeutral2(String player) {
    return 'Je li $player spreman voditi ovu momčad?';
  }

  @override
  String pressBeatKeyPlayerHostile1(String player) {
    return 'Ako $player nije u najboljem izdanju, ima li ova momčad ičega?';
  }

  @override
  String pressBeatKeyPlayerHostile2(String player) {
    return '$player nosi puno na plećima. Previše?';
  }

  @override
  String get pressReplyAimHigher1 => 'Idemo dalje nego što itko očekuje.';

  @override
  String get pressReplyAimHigher2 =>
      'Želim više nego što je savez tražio i reći ću to naglas.';

  @override
  String get pressReplyMatchBrief1 => 'Znamo cilj i ostvarit ćemo ga.';

  @override
  String get pressReplyMatchBrief2 =>
      'Savez je postavio cilj. Ispunit ćemo ga.';

  @override
  String get pressReplyPlayDown1 => 'Idemo utakmicu po utakmicu.';

  @override
  String get pressReplyPlayDown2 =>
      'Nema velikih obećanja. Vidjet ćemo gdje smo.';

  @override
  String get pressReplyPromiseQualify1 =>
      'Kvalificirat ćemo se. Možete zapisati.';

  @override
  String get pressReplyPromiseQualify2 => 'Ova momčad bit će na završnici.';

  @override
  String get pressReplyFearNobody1 => 'Ne bojimo se nikoga.';

  @override
  String get pressReplyFearNobody2 => 'Moraju igrati i protiv nas.';

  @override
  String get pressReplyRespectRival1 => 'Oni su favoriti i poštujemo ih.';

  @override
  String get pressReplyRespectRival2 =>
      'Vrlo dobra momčad. Trebat će nam sve najbolje.';

  @override
  String get pressReplyTeamFirst1 =>
      'Riječ je o cijeloj momčadi, a ne o jednom igraču.';

  @override
  String get pressReplyTeamFirst2 => 'Nitko ovo ne dobiva sam.';

  @override
  String pressOnRecordTarget(String aim) {
    return 'Za zapisnik: $aim.';
  }

  @override
  String get pressOnRecordPlayDown => 'Za zapisnik: bez obećanja.';

  @override
  String get pressThrowbackTargetKeptWarm =>
      'Postavili ste cilj prije kampanje i ostvarili ga. Je li to dosad Vaš najponosniji trenutak?';

  @override
  String get pressThrowbackTargetKeptNeutral =>
      'Rekli ste što ćete postići i jeste. Je li ikad bilo upitno?';

  @override
  String get pressThrowbackTargetKeptHostile =>
      'Ostvarili ste cilj koji ste postavili. Sreća ili je to doista bio plan?';

  @override
  String get pressThrowbackTargetBrokenWarm =>
      'Postavili ste cilj i niste ga dosegli. Što je pošlo po zlu?';

  @override
  String get pressThrowbackTargetBrokenNeutral =>
      'Obećali ste više nego što je ova momčad pružila. Žalite li što ste to rekli?';

  @override
  String get pressThrowbackTargetBrokenHostile =>
      'Pred kampanju ste velike stvari obećavali, a podbacili ste. Zašto bismo Vam sad vjerovali?';

  @override
  String hubEventPressPreviewSub(String competition) {
    return 'Mediji žele čuti tvoje ciljeve za natjecanje: $competition';
  }

  @override
  String deptLevelCost(int level, String amount) {
    return 'Razina $level · $amount';
  }

  @override
  String get formOnFire => 'U vatri';

  @override
  String get formGood => 'U formi';

  @override
  String get formSteady => 'Stabilna';

  @override
  String get formPoor => 'Izvan forme';

  @override
  String get formCold => 'Ledena';

  @override
  String get playerFormTitle => 'FORMA I KONDICIJA';

  @override
  String playerFormAverage(String rating) {
    return 'Prosjek ocjene u nedavnim utakmicama: $rating';
  }

  @override
  String get playerFormNoGames => 'Premalo nedavnih utakmica za procjenu';

  @override
  String playerFormNextMatch(String delta) {
    return 'Ocjena u sljedećoj utakmici: $delta';
  }

  @override
  String get playerFormNoEffect => 'Ocjena se u sljedećoj utakmici ne mijenja';

  @override
  String get sideGroupHome => 'Početna';

  @override
  String get sideGroupTeam => 'Momčad';

  @override
  String get sideGroupCompetitions => 'Natjecanja';

  @override
  String get sideGroupFederation => 'Savez';

  @override
  String get sideGroupHistory => 'Povijest';

  @override
  String get sideInbox => 'Poruke';

  @override
  String get sideSquad => 'Sastav';

  @override
  String get sideTactics => 'Taktika';

  @override
  String get sideMainMenu => 'Glavni meni';

  @override
  String get sideCallUps => 'Pozivi';

  @override
  String get sideTournaments => 'Turniri';

  @override
  String get sideRanking => 'Ljestvica';

  @override
  String get sideResults => 'Rezultati';

  @override
  String get sideFinances => 'Financije';

  @override
  String get sideBoard => 'Odbor';

  @override
  String get sideManager => 'Izbornik i stožer';

  @override
  String get sideRecords => 'Rekordi';

  @override
  String get sideLegends => 'Legende';

  @override
  String get sideHeadToHead => 'Međusobni susreti';

  @override
  String get sideAchievements => 'Postignuća';

  @override
  String get sideCareer => 'Karijera';

  @override
  String get topBarNext => 'Sljedeće';

  @override
  String get topBarDrawPending => 'Slijedi ždrijeb';

  @override
  String get paneFullProfile => 'Cijeli profil';

  @override
  String get panePickPlayer => 'Odaberi igrača da ovdje vidiš njegovu karticu';

  @override
  String get inboxPickMessage => 'Odaberi poruku da je ovdje pročitaš';

  @override
  String get inboxFilterAll => 'Sve';

  @override
  String get panelViewAll => 'Prikaži sve';

  @override
  String get gridViewOverview => 'Pregled';

  @override
  String get gridColCondition => 'Kondicija';

  @override
  String get gridColStatus => 'Status';

  @override
  String get gridColRank => 'Mjesto';

  @override
  String get gridColMove => 'Pomak';

  @override
  String get gridColNation => 'Zemlja';

  @override
  String get gridColRegion => 'Regija';

  @override
  String get gridColPoints => 'Bodovi';

  @override
  String get panePickNation => 'Odaberi zemlju da ovdje vidiš njezin dosje';

  @override
  String get resultsCyclesTitle => 'Ciklusi';

  @override
  String get tourDrawStart => 'Započni ždrijeb';

  @override
  String get tourDrawViewGroups => 'Prikaži skupine';

  @override
  String get gridColCeiling => 'Strop';

  @override
  String get gridColYearGain => 'Napredak';

  @override
  String get gridColMarkedAt => 'Kad označen';

  @override
  String get budgetSetupTitle => 'Postavi proračun';

  @override
  String get budgetEffectsTitle => 'Što ovaj proračun donosi';

  @override
  String get naturalisationTitle => 'Naturalizacija';

  @override
  String get yTrending => 'U trendu';

  @override
  String get yVoices => 'Glasovi';

  @override
  String get yConversation => 'Rasprava';

  @override
  String get allTimeRecordsTitle => 'Svjetski rekordi svih vremena';

  @override
  String get h2hMeetingsTitle => 'Svi susreti';

  @override
  String get h2hPickOpponent => 'Odaberi protivnika da ovdje vidiš sve susrete';

  @override
  String get savesTitle => 'Spremljene igre';

  @override
  String get gridColPlayer => 'Igrač';

  @override
  String get gridColPos => 'Poz';

  @override
  String get gridColActive => 'Aktivan';

  @override
  String get gridColMotm => 'MOTM';

  @override
  String get gridColAvg => 'Prosj.';

  @override
  String get gridColOpponent => 'Protivnik';

  @override
  String get gridColStarts => 'Starti';

  @override
  String get gridColTournaments => 'Turniri';

  @override
  String get gridColDate => 'Datum';

  @override
  String get gridColLastPlayed => 'Zadnje igrano';

  @override
  String get gridColManager => 'Izbornik';

  @override
  String nationsShownCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count zemalja',
      few: '$count zemlje',
      one: '$count zemlja',
    );
    return '$_temp0';
  }

  @override
  String get nationsSortedByRank => 'Poredano po svjetskoj ljestvici';

  @override
  String get nationsStrength => 'Snaga';

  @override
  String nationsStrengthOf(int tier) {
    return '$tier od 5';
  }

  @override
  String get nationsSquadOverall => 'Ukupna ocjena sastava';

  @override
  String get nationsOpeningBudget => 'Početni proračun';

  @override
  String get nationsStarPlayer => 'Zvijezda momčadi';

  @override
  String nationsStarTile(String position, int rating) {
    return 'Zvijezda $position $rating';
  }

  @override
  String nationsStarAge(int age) {
    return 'Dob $age';
  }

  @override
  String get nationsBoardExpects => 'Odbor očekuje';

  @override
  String nationsManage(String nation) {
    return 'Vodi: $nation';
  }

  @override
  String get nationsManagerNext => 'Sljedeće upisuješ ime izbornika';

  @override
  String get playerPageTitle => 'Igrač';

  @override
  String get nationPageTitle => 'Zemlja';

  @override
  String get friendliesYourGames => 'Tvoje prijateljske';

  @override
  String hubEventInjuryCover(String player) {
    return 'Zamijeni ozlijeđenog igrača $player';
  }

  @override
  String hubEventInjuryCoverSub(int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: 'Odsutan $matches utakmica',
      few: 'Odsutan $matches utakmice',
      one: 'Odsutan $matches utakmicu',
    );
    return '$_temp0. Pozovi nekoga ili igraj dalje bez njega.';
  }

  @override
  String get injuryCoverTitle => 'ZAMJENA';

  @override
  String injuryCoverBanner(String player) {
    return '$player je ozlijeđen. Pozovi bilo koga izvan sastava, na bilo koju poziciju, ili ga zadrži i igraj dalje.';
  }

  @override
  String injuryCoverConfirm(String player) {
    return 'Pozovi igrača: $player';
  }

  @override
  String injuryCoverKeep(String player) {
    return 'Zadrži igrača $player i igraj dalje';
  }

  @override
  String get injuryCoverPick => 'Odaberi zamjenu';

  @override
  String get injuryCoverNone =>
      'Nitko izvan sastava nije spreman pridružiti se.';

  @override
  String get nationNowRanking => 'Svjetska ljestvica';

  @override
  String get nationNowForm => 'Forma';

  @override
  String get nationNowNoForm => 'Još nema odigranih utakmica';

  @override
  String get nationNowNext => 'Sljedeća utakmica';

  @override
  String get nationNowNoNext => 'Ništa nije zakazano';

  @override
  String get nationNowSquad => 'Sastav';

  @override
  String get nationNowAgainstYou => 'Protiv tebe';

  @override
  String nationNowRecord(int w, int d, int l) {
    return '${w}P ${d}N ${l}I';
  }

  @override
  String get nationNowLastMeeting => 'Zadnji susret';

  @override
  String nationNowOverall(int value) {
    return 'Ukupno $value';
  }

  @override
  String get hubUpcoming => 'NADOLAZI';

  @override
  String get hubFullSchedule => 'Cijeli raspored';

  @override
  String get scheduleTitle => 'Raspored';

  @override
  String get scheduleToday => 'Danas';

  @override
  String get scheduleKnockoutPending => 'Nokaut-faza, ako prođeš dalje';

  @override
  String get scheduleNextRoundPending => 'Sljedeće kolo';

  @override
  String scheduleFromDate(String date) {
    return 'Od $date';
  }

  @override
  String get scheduleHomeShort => 'D';

  @override
  String get scheduleAwayShort => 'G';

  @override
  String get tacticsNoPresetsInMatch =>
      'Još nema spremljenih taktika. Spremi jednu na zaslonu Taktika prije utakmice.';

  @override
  String get homeCampaigns => 'Kampanje';

  @override
  String get homeContinueCampaign => 'NASTAVI KAMPANJU';

  @override
  String homeCampaignCycle(String date, int cycle, int total) {
    return '$date · Ciklus $cycle od $total';
  }

  @override
  String get campaignsTitle => 'Kampanje';

  @override
  String get campaignTransplantTitle => 'Presađivanje';

  @override
  String get campaignTransplantTwist =>
      'Osam najboljih talijanskih igrača mijenja reprezentaciju i prelazi u San Marino';

  @override
  String get campaignTransplantGoal => 'Kvalificiraj se za Europsko prvenstvo';

  @override
  String get campaignGrudgeTitle => 'Stari račun';

  @override
  String get campaignGrudgeTwist => 'Gruzija i Albanija, izvučene zajedno';

  @override
  String get campaignGrudgeGoal => 'Završi iznad Albanije u kvalifikacijama';

  @override
  String get campaignTransplantIntro =>
      'San Marino nikad nije imao kvalifikacijsku kampanju vrijednu tog imena. Onda osam najboljih Talijana uzme putovnicu i uđe. Imaš jedan ciklus da od zanimljivosti napraviš momčad.';

  @override
  String get campaignGrudgeIntro =>
      'Gruzija i Albanija izvučene su u istu kvalifikacijsku skupinu i nijedna neće oprostiti poraz. Završi iznad Albanije, pa vidi dokle možeš stići.';

  @override
  String get campaignStars1Transplant => 'Kvalificiraj se';

  @override
  String get campaignStars2Transplant => 'Stigni do nokaut-faze';

  @override
  String get campaignStars3Transplant => 'Osvoji Europsko prvenstvo';

  @override
  String get campaignStars1Grudge => 'Iznad Albanije';

  @override
  String get campaignStars2Grudge => 'I kvalificiraj se';

  @override
  String get campaignStars3Grudge => 'I pobijedi ih dvaput';

  @override
  String get campaignFree => 'Besplatno';

  @override
  String get campaignStart => 'Start';

  @override
  String get campaignPartOfUnlimited => 'Dio paketa Unlimited';

  @override
  String get campaignResume => 'Nastavi';

  @override
  String get campaignAbandon => 'Odustani';

  @override
  String get campaignAbandonConfirm =>
      'Odustati od ovog pokušaja? Napredak se gubi; tvoj pečat ostaje.';

  @override
  String get campaignMoveToSaves => 'Premjesti u spremljene';

  @override
  String get campaignCannotContinue =>
      'Svijet ove kampanje previše se razlikuje od stvarnog da bi se nastavio kao karijera.';

  @override
  String get campaignMoveSlotsFull =>
      'Mjesta za spremanje su popunjena. Prvo oslobodi jedno.';

  @override
  String get campaignStampConquered => 'Osvojeno';

  @override
  String get campaignStampFailed => 'Neuspjelo';

  @override
  String get campaignDifficultyHard => 'Teško';

  @override
  String get campaignDifficultyMedium => 'Srednje';

  @override
  String get campaignGoalLabel => 'Cilj';

  @override
  String get campaignStarsLabel => 'Zvjezdice';

  @override
  String get campaignRunInProgress => 'Ova kampanja već ima pokušaj u tijeku.';

  @override
  String get campaignVerdictWon => 'Osvojeno';

  @override
  String get campaignVerdictLost => 'Ne ovaj put';

  @override
  String get campaignVerdictContinue => 'Nastavi';

  @override
  String campaignProgressQualifying(String position) {
    return 'Kvalifikacije: $position';
  }

  @override
  String campaignProgressRival(String rival, String position) {
    return '$rival: $position';
  }

  @override
  String campaignProgressFinals(String stage) {
    return 'Završnica: $stage';
  }

  @override
  String get campaignRunInNumbers => 'Pokušaj u brojkama';

  @override
  String campaignRunMeetings(int won, int played) {
    return 'Dobiveni susreti: $won od $played';
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
  String get campaignGuineasTitle => 'Najbolja Gvineja';

  @override
  String get campaignGuineasTwist =>
      'Ekvatorska Gvineja, najniže rangirana od afričkih Gvineja, kroz dva ciklusa';

  @override
  String get campaignGuineasGoal => 'Pobijedi Gvineju i Gvineju Bisau';

  @override
  String get campaignGuineasIntro =>
      'Tri afričke zemlje nose ime Gvineja, a Ekvatorska Gvineja rangirana je najniže od njih. Imaš dva ciklusa da barem jednom pobijediš Gvineju i Gvineju Bisau, pa vidi dokle možeš stići na Afričkom prvenstvu. Papua Nova Gvineja, četvrta Gvineja, već je dogovorena za prijateljsku utakmicu.';

  @override
  String get campaignStars1Guineas => 'Pobijedi Gvineju i Gvineju Bisau';

  @override
  String get campaignStars2Guineas => 'I kvalificiraj se za Afričko prvenstvo';

  @override
  String get campaignStars3Guineas =>
      'I stigni do četvrtfinala Afričkog prvenstva';

  @override
  String get campaignYoungFinnsTitle => 'Mladi Finci';

  @override
  String get campaignYoungFinnsTwist =>
      'Zlatna generacija finskih tinejdžera, kroz tri ciklusa';

  @override
  String get campaignYoungFinnsGoal => 'Kvalificiraj se na Svjetsko prvenstvo';

  @override
  String get campaignYoungFinnsIntro =>
      'Finski seniori ustupili su mjesto, a zlatna generacija preuzela je njihovo: svaki igrač kojeg možeš izabrati ima 18 godina ili manje. Danas su još nedotjerani, ali imaju talent da postanu jedna od najboljih reprezentacija na svijetu, baš kao što je to uspjela mlada norveška generacija. Imaš tri ciklusa da ih odvedeš na Svjetsko prvenstvo, a zatim osvojiš Europsko prvenstvo i Svjetsko prvenstvo.';

  @override
  String get campaignStars1YoungFinns =>
      'Kvalificiraj se na Svjetsko prvenstvo';

  @override
  String get campaignStars2YoungFinns => 'Osvoji Europsko prvenstvo';

  @override
  String get campaignStars3YoungFinns => 'Osvoji Svjetsko prvenstvo';

  @override
  String get campaignPro => 'Pro';

  @override
  String campaignProgressCup(String cup, String year, String status) {
    return '$cup $year: $status';
  }

  @override
  String get campaignCupNotQualified => 'Nije se kvalificirao';

  @override
  String get campaignCupOpen => 'Tek treba biti odlučeno';
}
