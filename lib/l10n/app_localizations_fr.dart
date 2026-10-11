// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get matchPreviewTitle => 'AVANT-MATCH';

  @override
  String get matchKickOff => 'Coup d’envoi';

  @override
  String get matchTactics => 'Tactique';

  @override
  String get matchYourXi => 'VOTRE ONZE';

  @override
  String get matchHeadToHead => 'FACE-À-FACE';

  @override
  String matchCouldNotLoad(String error) {
    return 'Impossible de charger le match.\n$error';
  }

  @override
  String get matchNoUpcoming => 'Aucun match à venir.';

  @override
  String get matchUnknownNation => 'Inconnu';

  @override
  String get matchH2hFirstMeeting => 'Toute première confrontation';

  @override
  String get matchH2hYouLead => 'Vous menez dans les confrontations';

  @override
  String matchH2hOppEdge(String opponent) {
    return 'Avantage $opponent';
  }

  @override
  String get matchH2hEven => 'Égalité parfaite';

  @override
  String matchH2hMet(int count) {
    return '$count confrontations';
  }

  @override
  String get matchH2hWon => 'Victoires';

  @override
  String get matchH2hDrawn => 'Nuls';

  @override
  String get matchH2hLost => 'Défaites';

  @override
  String get matchDossierTitle => 'Rapport de scouting';

  @override
  String get matchDossierForm => 'FORME';

  @override
  String get matchDossierNoGames => 'Aucun match récent';

  @override
  String get matchDossierKeyMen => 'HOMMES CLÉS';

  @override
  String matchCouldNotContinue(String error) {
    return 'Impossible de continuer : $error';
  }

  @override
  String get matchSkipToFullTime => 'Aller au coup de sifflet final';

  @override
  String get matchStatShots => 'Tirs';

  @override
  String get matchStatGoals => 'Buts';

  @override
  String get matchStatYellowCards => 'Jaunes';

  @override
  String get matchStatRedCards => 'Rouges';

  @override
  String get matchMomentum => 'DYNAMIQUE';

  @override
  String get matchSwingAtk => 'ATT';

  @override
  String get matchSwingDef => 'DÉF';

  @override
  String ceremonyWorldCupYear(int year) {
    return 'CHAMPIONNAT DU MONDE $year';
  }

  @override
  String get ceremonyFinalsAreHere => 'LA PHASE FINALE EST LÀ';

  @override
  String ceremonyHostedBy(String hosts) {
    return 'ORGANISÉ PAR  $hosts';
  }

  @override
  String get ceremonyHostTbc => 'PAYS HÔTE À CONFIRMER';

  @override
  String get matchHalfTime => 'MI-TEMPS';

  @override
  String get matchContinue => 'Continuer';

  @override
  String get matchContinuing => 'Reprise…';

  @override
  String matchTacticsWithSubs(int used, int max) {
    return 'Tactique · $used/$max changements';
  }

  @override
  String matchTiredCount(int count) {
    return 'FATIGUÉS ×$count';
  }

  @override
  String get matchTacticsLabel => 'TACTIQUE';

  @override
  String get teamOverallOverTime => 'NIVEAU GLOBAL DANS LE TEMPS';

  @override
  String get teamOverall => 'Global';

  @override
  String get teamTalkHeading => 'CAUSERIE';

  @override
  String get teamTalkPrompt => 'Donnez le ton pour la seconde période.';

  @override
  String get teamTalkCalmLabel => 'Têtes froides';

  @override
  String get teamTalkCalmBlurb => 'Stabiliser l’équipe. Un léger gain partout.';

  @override
  String get teamTalkEncourageLabel => 'Encourager';

  @override
  String get teamTalkEncourageBlurb => 'Allez de l’avant et jouez la gagne.';

  @override
  String get teamTalkDemandMoreLabel => 'Exiger plus';

  @override
  String get teamTalkDemandMoreBlurb => 'Tout donner. Attaquer à fond.';

  @override
  String get teamTalkPraiseLabel => 'Rester serrés';

  @override
  String get teamTalkPraiseBlurb =>
      'Restez compacts et protégez votre avantage.';

  @override
  String get teamTalkBelieveLabel => 'Y croire';

  @override
  String get teamTalkBelieveBlurb =>
      'Ayez confiance. Un gain aux deux bouts du terrain.';

  @override
  String get teamTalkFocusLabel => 'Rester concentrés';

  @override
  String get teamTalkFocusBlurb =>
      'Concentration totale. Verrouillez le match.';

  @override
  String get teamTalkUrgencyLabel => 'Urgence';

  @override
  String get teamTalkUrgencyBlurb =>
      'Il faut forcer maintenant. Tout pour l’attaque, quitte à laisser des espaces.';

  @override
  String get teamTalkReassureLabel => 'Sans pression';

  @override
  String get teamTalkReassureBlurb =>
      'Calmez les nerfs et gardez votre organisation.';

  @override
  String get commonRetry => 'Réessayer';

  @override
  String get commonSomethingWentWrong => 'Une erreur est survenue';

  @override
  String get commonCrashBox =>
      'Une erreur est survenue ici.\nParamètres → Diagnostic contient les détails.';

  @override
  String hubCouldNotAdvance(String error) {
    return 'Impossible de faire avancer le monde : $error';
  }

  @override
  String get settingsDiagnosticsTitle => 'Diagnostic';

  @override
  String get settingsDiagnosticsBlurb =>
      'Erreurs enregistrées sur cet appareil. Rien n’est envoyé nulle part.';

  @override
  String get settingsContactTitle => 'Contact';

  @override
  String get settingsContactCopied => 'Adresse copiée.';

  @override
  String get diagnosticsEmpty => 'Aucune erreur enregistrée. C’est le but.';

  @override
  String get diagnosticsCopy => 'Copier';

  @override
  String get diagnosticsCopied => 'Journal copié dans le presse-papiers.';

  @override
  String get diagnosticsClear => 'Effacer';

  @override
  String get navHub => 'Accueil';

  @override
  String get navSquad => 'Effectif';

  @override
  String get navStandings => 'Classements';

  @override
  String get navCareers => 'Ma carrière';

  @override
  String get settingsTitle => 'PARAMÈTRES';

  @override
  String get settingsSoundHapticsTitle => 'Son et vibrations';

  @override
  String get settingsSoundHapticsBlurb =>
      'Vibration et court signal sonore sur les buts, le coup d’envoi et la fin du match.';

  @override
  String get settingsLanguageTitle => 'Langue';

  @override
  String get settingsLanguageBlurb =>
      'Choisissez la langue de l’app, ou suivez celle de l’appareil.';

  @override
  String get settingsLanguageSystem => 'Système';

  @override
  String get matchPreviewAllMeetings => 'Toutes les confrontations';

  @override
  String get recordsMeetings => 'CONFRONTATIONS';

  @override
  String get recordsLegends => 'LÉGENDES';

  @override
  String get recordsAllTimeXi => 'ONZE DE LÉGENDE';

  @override
  String get recordsHallOfFame => 'PANTHÉON';

  @override
  String get recordsAllTimeWorld => 'RECORDS MONDIAUX';

  @override
  String get recordsAllTimeTopScorers => 'MEILLEURS BUTEURS DE L’HISTOIRE';

  @override
  String get recordsMostCapped => 'LES PLUS CAPÉS';

  @override
  String get recordsMostWcStarts => 'PLUS DE MATCHS EN PHASE FINALE';

  @override
  String get recordsMostTournaments => 'PLUS DE TOURNOIS DISPUTÉS';

  @override
  String get recordsRecordBook => 'LIVRE DES RECORDS';

  @override
  String get recordsHeadToHead => 'FACE-À-FACE';

  @override
  String get recordsFiercestRival => 'RIVAL LE PLUS CORIACE';

  @override
  String get recordsMostCaps => 'PLUS DE SÉLECTIONS';

  @override
  String get recordsTopScorers => 'MEILLEURS BUTEURS';

  @override
  String get recordsMostAssists => 'PLUS DE PASSES DÉCISIVES';

  @override
  String get recordsYourRecord => 'VOTRE BILAN';

  @override
  String get callUpHome => 'DOMICILE';

  @override
  String get callUpAway => 'EXTÉRIEUR';

  @override
  String get recordsHome => 'DOMICILE';

  @override
  String get recordsAway => 'EXTÉRIEUR';

  @override
  String get recordsActive => 'EN ACTIVITÉ';

  @override
  String get recordsStillActive => 'Toujours en activité';

  @override
  String get recordsAvg => 'moy.';

  @override
  String get recordsSelect => 'Choisir';

  @override
  String get recordsVs => 'vs';

  @override
  String get recordsDraws => 'Nuls';

  @override
  String get recordsGoalsLabel => 'Buts';

  @override
  String get recordsBestFinish => 'Meilleur résultat';

  @override
  String get recordsNoFinalsYet => 'Aucune phase finale pour l’instant';

  @override
  String get recordsLongestUnbeaten => 'Plus longue série sans défaite';

  @override
  String get recordsBiggestWin => 'Plus large victoire';

  @override
  String get recordsSeeAllMeetings => 'Voir toutes les confrontations';

  @override
  String get recordsSaveNotFound => 'Sauvegarde introuvable.';

  @override
  String get recordsNoMatches => 'Aucun match.';

  @override
  String get recordsSearchPlayerOrNation => 'Chercher un joueur ou une nation';

  @override
  String get recordsSearchNation => 'Chercher une nation';

  @override
  String get recordsPickTwoDifferent => 'Choisissez deux nations différentes.';

  @override
  String get recordsPlayToBuildRecord =>
      'Jouez quelques matchs et votre bilan face à chaque adversaire s’affichera ici.';

  @override
  String get recordsTapOpponent =>
      'Touchez un adversaire pour le détail complet.';

  @override
  String get recordsEdgeUpperHand => 'Vous avez l’ascendant';

  @override
  String get recordsEdgeTheirNumber => 'Ils sont votre bête noire';

  @override
  String get recordsEdgeEven => 'Égalité parfaite';

  @override
  String get recordsAllTimeWorldSubtitle =>
      'Buteurs et joueurs les plus capés, toutes nations';

  @override
  String get recordsHeadToHeadSubtitle =>
      'Comparez le bilan historique de deux nations';

  @override
  String get recordsLegendsSubtitle => 'Onze de légende et panthéon';

  @override
  String get recordsUnitGoals => 'buts';

  @override
  String get recordsUnitCaps => 'sél.';

  @override
  String get recordsUnitStarts => 'titul.';

  @override
  String get recordsUnitCups => 'tournois';

  @override
  String get recordsUnitAssists => 'passes déc.';

  @override
  String recordsCapsCount(int count) {
    return '$count sél.';
  }

  @override
  String recordsGoalsCount(int count) {
    return '$count buts';
  }

  @override
  String recordsAssistsCount(int count) {
    return '$count passes déc.';
  }

  @override
  String recordsMotmCount(int count) {
    return '$count fois homme du match';
  }

  @override
  String recordsMatchesCount(int count) {
    return '$count matchs';
  }

  @override
  String recordsMeetingsCount(int count) {
    return '$count confrontations';
  }

  @override
  String recordsCodeWins(String code) {
    return 'Victoires $code';
  }

  @override
  String recordsMeetingsWdl(int meetings, int wins, int draws, int losses) {
    return '$meetings confrontations · ${wins}V ${draws}N ${losses}D';
  }

  @override
  String recordsWdl(int wins, int draws, int losses) {
    return '${wins}V ${draws}N ${losses}D';
  }

  @override
  String recordsRivalLine(int meetings, String record, String edge) {
    return '$meetings confrontations · $record · $edge';
  }

  @override
  String recordsNeverMet(String a, String b) {
    return '$a et $b ne se sont jamais affrontés dans cette partie.';
  }

  @override
  String tacticsSentOffNote(String names) {
    return 'Expulsion : $names. Pas de remplaçant possible, vous jouez à dix.';
  }

  @override
  String tacticsNeedFitPlayers(int required, int have) {
    return 'Il en faut $required disponibles ($have aptes)';
  }

  @override
  String tacticsMissesOfCamp(int missed, int total) {
    return 'Absent $missed/$total';
  }

  @override
  String get tacticsOutForWholeCamp => 'Forfait pour tout le rassemblement';

  @override
  String get rankingCentreOnMe => 'Centrer sur ma sélection';

  @override
  String get recordsAfterExtraTime => 'a.p.';

  @override
  String recordsOnPenalties(int a, int b) {
    return '$a-$b t.a.b.';
  }

  @override
  String recordsVersus(String a, String b) {
    return '$a vs $b';
  }

  @override
  String recordsPlayedScore(int played, int gf, int ga) {
    return '$played joués · $gf-$ga';
  }

  @override
  String recordsBiggestWinValue(int gf, int ga, String opp) {
    return '$gf-$ga contre $opp';
  }

  @override
  String recordsCouldNotLoad(String error) {
    return 'Chargement impossible.\n$error';
  }

  @override
  String recordsCouldNotLoadLegends(String error) {
    return 'Impossible de charger les légendes.\n$error';
  }

  @override
  String recordsCouldNotLoadRecords(String error) {
    return 'Impossible de charger les records.\n$error';
  }

  @override
  String recordsCouldNotLoadNations(String error) {
    return 'Impossible de charger les nations.\n$error';
  }

  @override
  String recordsCouldNotLoadYourRecord(String error) {
    return 'Impossible de charger votre bilan.\n$error';
  }

  @override
  String recordsCouldNotLoadRecord(String error) {
    return 'Impossible de charger le bilan.\n$error';
  }

  @override
  String recordsNoLegends(String nation) {
    return 'Pas encore de légendes. Disputez quelques campagnes et les grands noms de la sélection $nation apparaîtront ici.';
  }

  @override
  String recordsGreatestSide(String nation) {
    return 'La meilleure équipe que la sélection $nation puisse aligner.';
  }

  @override
  String get recordsNoWorldHistory =>
      'Le monde n’a pas encore d’histoire. Disputez quelques campagnes et les légendes apparaîtront ici.';

  @override
  String recordsPlayToWriteHistory(String nation) {
    return 'Sélection $nation : jouez quelques matchs pour commencer à écrire son histoire.';
  }

  @override
  String get tacticsLineGk => 'G';

  @override
  String get tacticsLineDef => 'DÉF';

  @override
  String get tacticsLineMid => 'MIL';

  @override
  String get tacticsLineFwd => 'ATT';

  @override
  String get tacticsGoalkeepers => 'GARDIENS';

  @override
  String get tacticsDefenders => 'DÉFENSEURS';

  @override
  String get tacticsMidfielders => 'MILIEUX';

  @override
  String get tacticsForwards => 'ATTAQUANTS';

  @override
  String get tacticsCallUpsTitle => 'CONVOCATIONS';

  @override
  String tacticsPickAtLeastPlayers(int min) {
    return 'Choisissez au moins $min joueurs.';
  }

  @override
  String tacticsCouldNotLoadSquad(String error) {
    return 'Impossible de charger l’effectif.\n$error';
  }

  @override
  String get tacticsNoSquad => 'Aucun effectif.';

  @override
  String tacticsSquadCount(int count, int max) {
    return 'EFFECTIF · $count/$max';
  }

  @override
  String tacticsMinMax(int min, int max) {
    return 'Min $min · Max $max';
  }

  @override
  String get tacticsBestQuality => 'Meilleur niveau';

  @override
  String get tacticsPreviousSquad => 'Liste précédente';

  @override
  String get tacticsSquadLockedBack => 'Retour (liste verrouillée)';

  @override
  String get tacticsConfirmSquad => 'Valider la liste';

  @override
  String tacticsSquadFullMax(int max) {
    return 'Liste complète (max $max)';
  }

  @override
  String get tacticsSquadLocked => 'LISTE VERROUILLÉE';

  @override
  String get tacticsNominationOpen =>
      'CONVOCATIONS OUVERTES. CHOISISSEZ VOTRE LISTE';

  @override
  String get tacticsSquadFixedBlurb =>
      'Cette liste est figée pour les matchs ci-dessous. Refaites vos choix avant la prochaine fenêtre de convocations.';

  @override
  String get tacticsSquadWillPlayBlurb =>
      'Cette liste disputera les matchs ci-dessous.';

  @override
  String get tacticsUnknown => 'Inconnu';

  @override
  String tacticsAgeValue(int age, String value) {
    return '$age ans · $value';
  }

  @override
  String get tacticsFatigueExhausted => 'Épuisé';

  @override
  String get tacticsFatigueTired => 'Fatigué';

  @override
  String get tacticsFatigueMatchLegs => 'En jambes';

  @override
  String tacticsTooManySubs(int max) {
    return 'Trop de changements (max $max).';
  }

  @override
  String tacticsMinuteTitle(int minute) {
    return 'TACTIQUE · $minute\'';
  }

  @override
  String get tacticsApply => 'APPLIQUER';

  @override
  String get tacticsTabLineupSubs => 'COMPO ET CHANGEMENTS';

  @override
  String get tacticsTabTactics => 'TACTIQUE';

  @override
  String get squadLineKeepers => 'GARDIENS';

  @override
  String get squadLineDefenders => 'DÉFENSE';

  @override
  String get squadLineMidfielders => 'MILIEU';

  @override
  String get squadLineForwards => 'ATTAQUE';

  @override
  String get squadStatXiRating => 'Note du onze';

  @override
  String get squadStatAvgAge => 'Âge moyen';

  @override
  String get squadStatSize => 'Effectif';

  @override
  String get squadStatUnavailable => 'Absents';

  @override
  String get squadDepthTitle => 'PROFONDEUR PAR LIGNE';

  @override
  String squadAgeShort(int age) {
    return '$age ans';
  }

  @override
  String get tacticsTabOtherPositions => 'AUTRES POSTES';

  @override
  String get tacticsOutOfPositionNote => 'Hors de son poste ici';

  @override
  String get tacticsNobodyElse => 'Personne d’autre à essayer ici.';

  @override
  String get tacticsPickSomebodyFirst =>
      'Choisissez qui sort et le reste du banc apparaîtra ici, avec son niveau à ce poste.';

  @override
  String get tacticsTabSuitable => 'ADAPTÉS';

  @override
  String get tacticsTabOnPitch => 'SUR LE TERRAIN';

  @override
  String tacticsSectionSuitable(int count) {
    return 'ADAPTÉS · $count';
  }

  @override
  String get tacticsNobodySuits =>
      'Personne sur le banc n’est naturellement fait pour ce poste, voici donc tout le monde.';

  @override
  String tacticsSectionOnPitch(int count, int max) {
    return 'SUR LE TERRAIN · $count/$max';
  }

  @override
  String tacticsSectionAvailable(int count) {
    return 'DISPONIBLES · $count';
  }

  @override
  String get tacticsRowStarted => 'Titulaire';

  @override
  String tacticsRowCameOn(int minute) {
    return 'Entré à la $minute\'';
  }

  @override
  String get tacticsRowSubstitute => 'Entré en jeu';

  @override
  String get tacticsEnergyLabel => 'ÉNERGIE';

  @override
  String tacticsPickReplacementFor(String name) {
    return 'Touchez un remplaçant pour $name, ou touchez-le à nouveau pour annuler.';
  }

  @override
  String get tacticsSlotLostToRedCard =>
      'Un carton rouge vous a coûté ce poste. Il ne peut pas être pourvu.';

  @override
  String get tacticsSentOffShort => 'EXPULSÉ';

  @override
  String tacticsSubsUsed(int used, int max) {
    return 'CHANGEMENTS · $used/$max';
  }

  @override
  String get tacticsDragSubOn =>
      'Touchez un joueur sur le terrain pour le sortir, ou maintenez et glissez un remplaçant sur lui.';

  @override
  String get tacticsNoSubs => 'Aucun remplaçant disponible.';

  @override
  String get tacticsChooseShape => 'CHOISIR UN SYSTÈME';

  @override
  String get tacticsFormation => 'SYSTÈME';

  @override
  String get tacticsInstructions => 'CONSIGNES';

  @override
  String get tacticsDrilling => 'AUTOMATISMES';

  @override
  String get tacticsDrillingUnplayed => 'JAMAIS JOUÉ';

  @override
  String get tacticsDrillingNew => 'NOUVEAU';

  @override
  String get tacticsDrillingSettling => 'EN RODAGE';

  @override
  String get tacticsDrillingDrilled => 'RODÉ';

  @override
  String get matchInstructionsLocked =>
      'Fixées avant le coup d’envoi. Vous pouvez changer de système et faire des changements, mais pas réécrire votre approche en plein match.';

  @override
  String get tacticsInstrMentality => 'Mentalité';

  @override
  String get tacticsInstrDefensive => 'Défensive';

  @override
  String get tacticsInstrAttacking => 'Offensive';

  @override
  String get tacticsInstrPressing => 'Pressing';

  @override
  String get tacticsInstrLowBlock => 'Bloc bas';

  @override
  String get tacticsInstrHighPress => 'Pressing haut';

  @override
  String get tacticsInstrTempo => 'Tempo';

  @override
  String get tacticsInstrPatient => 'Patient';

  @override
  String get tacticsInstrFast => 'Rapide';

  @override
  String get tacticsInstrWidth => 'Largeur';

  @override
  String get tacticsInstrNarrow => 'Resserré';

  @override
  String get tacticsInstrWide => 'Large';

  @override
  String get tacticsInstrDefLine => 'Ligne déf.';

  @override
  String get tacticsInstrDefensiveLine => 'Ligne défensive';

  @override
  String get tacticsInstrDeep => 'Basse';

  @override
  String get tacticsInstrHigh => 'Haute';

  @override
  String get tacticsInstrDirectness => 'Style de jeu';

  @override
  String get tacticsInstrPossession => 'Possession';

  @override
  String get tacticsInstrDirect => 'Direct';

  @override
  String get tacticsPickGoalkeeper => 'CHOISIR LE GARDIEN';

  @override
  String get tacticsPickLeftBack => 'CHOISIR L’ARRIÈRE GAUCHE';

  @override
  String get tacticsPickCentreBack => 'CHOISIR LE DÉFENSEUR CENTRAL';

  @override
  String get tacticsPickRightBack => 'CHOISIR L’ARRIÈRE DROIT';

  @override
  String get tacticsPickDefensiveMid => 'CHOISIR LE MILIEU DÉFENSIF';

  @override
  String get tacticsPickCentralMid => 'CHOISIR LE MILIEU CENTRAL';

  @override
  String get tacticsPickAttackingMid => 'CHOISIR LE MILIEU OFFENSIF';

  @override
  String get tacticsPickLeftMid => 'CHOISIR LE MILIEU GAUCHE';

  @override
  String get tacticsPickRightMid => 'CHOISIR LE MILIEU DROIT';

  @override
  String get tacticsPickLeftWing => 'CHOISIR L’AILIER GAUCHE';

  @override
  String get tacticsPickRightWing => 'CHOISIR L’AILIER DROIT';

  @override
  String get tacticsPickStriker => 'CHOISIR L’AVANT-CENTRE';

  @override
  String tacticsRoleOutOfPosition(String role) {
    return '$role · hors de son poste';
  }

  @override
  String tacticsAgeOnly(int age) {
    return '$age ans';
  }

  @override
  String tacticsRoleAge(String role, int age) {
    return '$role · $age ans';
  }

  @override
  String get tacticsOn => 'ENTRÉ';

  @override
  String get tacticsSquad => 'EFFECTIF';

  @override
  String get tacticsTabLineup => 'COMPO';

  @override
  String get tacticsTabInstructions => 'CONSIGNES';

  @override
  String get tacticsTabRoles => 'RÔLES';

  @override
  String get tacticsTabSetPieces => 'COUPS DE PIED ARRÊTÉS';

  @override
  String get tacticsTabRolesSetPieces => 'RÔLES ET CPA';

  @override
  String get tacticsRolesSetPiecesBlurb =>
      'Donnez un rôle à chaque titulaire. Touchez le badge penalty (⚽) ou coup franc (▲) pour désigner votre tireur.';

  @override
  String get tacticsTooltipCallUps => 'Convocations';

  @override
  String get tacticsTooltipPresets => 'Tactiques enregistrées';

  @override
  String get tacticsTooltipInstructions => 'Consignes';

  @override
  String get tacticsNoTacticSet => 'Aucune tactique définie.';

  @override
  String tacticsReplaceStarters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'REMPLACER $count TITULAIRES',
      one: 'REMPLACER $count TITULAIRE',
    );
    return '$_temp0';
  }

  @override
  String tacticsPlayerOut(String name, String reason) {
    return '$name : $reason';
  }

  @override
  String get tacticsOut => 'Absent';

  @override
  String get tacticsTapSpotReplace =>
      'Touchez son poste sur le terrain pour choisir un remplaçant.';

  @override
  String get tacticsTapOrDrag =>
      'Touchez un joueur pour le remplacer, ou maintenez et glissez-le pour le déplacer.';

  @override
  String get tacticsPlayerRoles => 'RÔLES DES JOUEURS';

  @override
  String get tacticsRolesBlurb =>
      'Confiez une mission à un joueur : renard des surfaces, meneur de jeu, pivot. Cela détermine qui marque et qui crée.';

  @override
  String get tacticsSetPieceTakers => 'TIREURS DE CPA';

  @override
  String get tacticsSetPieceBlurb =>
      'Qui tire les penalties et les coups de pied arrêtés, ou laissez faire le joueur le plus adapté.';

  @override
  String get tacticsTakerAuto => 'Automatique';

  @override
  String get tacticsTakerQuickPick => 'Meilleurs tireurs';

  @override
  String get tacticsPenalties => 'Penalties';

  @override
  String get tacticsCornersFreeKicks => 'Corners et coups francs';

  @override
  String get tacticsSkillFin => 'FIN';

  @override
  String get tacticsSkillPas => 'PAS';

  @override
  String tacticsRolePlayer(String name) {
    return 'RÔLE · $name';
  }

  @override
  String get tacticsPenaltyTaker => 'TIREUR DE PENALTY';

  @override
  String get tacticsCornerFreeKickTaker => 'TIREUR DE CORNERS ET COUPS FRANCS';

  @override
  String get tacticsAutomatic => 'Automatique';

  @override
  String get tacticsLetBestSuited =>
      'Laissez le joueur le plus adapté s’en charger.';

  @override
  String get tacticsInXi => 'DANS LE ONZE';

  @override
  String get tacticsTeamInstructions => 'CONSIGNES COLLECTIVES';

  @override
  String get tacticsTeamInstructionsBlurb =>
      'Définissez la manière de jouer. Chaque réglage influence toute l’équipe.';

  @override
  String tacticsSavedPreset(String name) {
    return '« $name » enregistrée';
  }

  @override
  String tacticsAppliedPreset(String name) {
    return '« $name » appliquée';
  }

  @override
  String get tacticsTacticPresets => 'TACTIQUES ENREGISTRÉES';

  @override
  String get tacticsPresetsBlurb =>
      'Enregistrez ce système comme style réutilisable, ou appliquez-en un déjà enregistré.';

  @override
  String get tacticsSaveCurrentTactic => 'Enregistrer la tactique';

  @override
  String tacticsCouldNotLoadPresets(String error) {
    return 'Impossible de charger les tactiques.\n$error';
  }

  @override
  String get tacticsNoPresetsYet =>
      'Aucune tactique enregistrée. Touchez « Enregistrer la tactique » pour conserver ce réglage comme style réutilisable.';

  @override
  String get tacticsNameThisTactic => 'Nommer cette tactique';

  @override
  String get tacticsNameHint => 'ex. Pressing haut 4-3-3';

  @override
  String get tacticsCancel => 'Annuler';

  @override
  String get tacticsSave => 'Enregistrer';

  @override
  String get tacticsTapToAssign => 'Touchez pour attribuer';

  @override
  String get tacticsHoldDragSub =>
      'Maintenez un remplaçant, puis glissez-le sur un joueur pour le faire entrer.';

  @override
  String get hubContinue => 'Continuer';

  @override
  String get hubBrackets => 'Tableaux';

  @override
  String hubCouldNotLoad(String error) {
    return 'Chargement impossible.\n$error';
  }

  @override
  String hubCouldNotLoadFinances(String error) {
    return 'Impossible de charger les finances.\n$error';
  }

  @override
  String hubCouldNotLoadSave(String error) {
    return 'Impossible de charger la sauvegarde.\n$error';
  }

  @override
  String get hubSaveNotFound => 'Sauvegarde introuvable.';

  @override
  String get hubUnknown => 'Inconnu';

  @override
  String hubWorldChampionsYear(int year) {
    return 'CHAMPIONS DU MONDE $year';
  }

  @override
  String get hubCycleComplete => 'Le cycle est terminé.';

  @override
  String get hubYourJob => 'VOTRE POSTE';

  @override
  String get hubStayProject => 'Rester et poursuivre votre projet';

  @override
  String get hubChooseNextJob => 'CHOISISSEZ VOTRE PROCHAIN POSTE';

  @override
  String get hubOffersOnTable => 'OFFRES SUR LA TABLE';

  @override
  String hubOfferSubtitle(String tier, int position) {
    return '$tier · ${position}e mondial';
  }

  @override
  String hubContinueWith(String nation) {
    return 'Continuer avec : $nation';
  }

  @override
  String get hubYourNation => 'votre sélection';

  @override
  String get hubTakeTheJob => 'Accepter le poste';

  @override
  String get hubFederationFinances => 'FINANCES DE LA FÉDÉRATION';

  @override
  String get hubBudgetIntro =>
      'Votre première tâche du prochain cycle : fixer le budget de la fédération et le répartir entre les départements.';

  @override
  String get hubStarting => 'Lancement…';

  @override
  String get hubBeginNextCycle => 'Commencer le cycle suivant';

  @override
  String get hubContinueCareer => 'Poursuivre votre carrière';

  @override
  String get hubBackToSaves => 'Retour aux sauvegardes';

  @override
  String get hubOpeningBalance => 'Solde initial';

  @override
  String get hubCentralFunding => 'Dotation centrale';

  @override
  String get hubPrizeMoney => 'Primes de résultats';

  @override
  String get hubCommercialReturn => 'Revenus commerciaux';

  @override
  String get hubAvailableToInvest => 'Disponible à investir';

  @override
  String hubReputation(String label, int rep) {
    return 'Réputation : $label ($rep)';
  }

  @override
  String get hubNationalHero => 'Héros national';

  @override
  String get hubFinal => 'Finale';

  @override
  String get hubStageRoundOf32 => 'Seizièmes de finale';

  @override
  String get hubStageThirdPlace => 'Match pour la 3e place';

  @override
  String get hubEventAdvanceWorld => 'Faire avancer le monde';

  @override
  String hubEventStartCycle(int year) {
    return 'Lancer le cycle $year';
  }

  @override
  String hubEventWorldChampions(String nation) {
    return '$nation remporte le Championnat du monde';
  }

  @override
  String get hubEventSetBudget => 'Fixez le budget de la fédération';

  @override
  String get hubEventSetBudgetSub =>
      'Répartissez le trésor de ce cycle avant le début de la saison';

  @override
  String get hubEventNaturalization => 'Examiner une offre de naturalisation';

  @override
  String get hubEventNaturalizationSub =>
      'Un joueur étranger veut changer de sélection pour vous rejoindre';

  @override
  String get hubEventIntercontinentalPlayoff => 'Le barrage intercontinental';

  @override
  String get hubEventWatchWcDraw => 'Suivre le tirage du Championnat du monde';

  @override
  String get hubEventWorldCupHere => 'Le Championnat du monde commence';

  @override
  String get hubEventWatchFinalsDraw => 'Suivre le tirage de la phase finale';

  @override
  String get hubEventFinalsHere => 'La phase finale commence';

  @override
  String get hubEventPlayWcRound =>
      'Jouer le prochain tour du Championnat du monde';

  @override
  String hubEventPlayCupMatch(String cup) {
    return 'Jouer le prochain match : $cup';
  }

  @override
  String get hubEventPlayNationsCupMatch =>
      'Jouer le prochain match de Coupe des Nations';

  @override
  String get hubEventWatchNationsCupDraw =>
      'Suivre le tirage de la Coupe des Nations';

  @override
  String get hubEventWatchHostSelection => 'Suivre la désignation du pays hôte';

  @override
  String get hubEventWatchQualifyingDraw =>
      'Suivre le tirage des qualifications';

  @override
  String get hubEventWatchWcHostSelection =>
      'Suivre la désignation du pays hôte du Championnat du monde';

  @override
  String get hubEventWatchWcQualifyingDraw =>
      'Suivre le tirage des qualifications du Championnat du monde';

  @override
  String get hubEventArrangeFriendlies => 'Organiser des matchs amicaux';

  @override
  String hubEventFriendliesSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Vos $count fenêtres de matchs amicaux ne sont pas encore remplies',
      one: 'Votre fenêtre de matchs amicaux n’est pas encore remplie',
    );
    return '$_temp0';
  }

  @override
  String get hubEventReshapeXi => 'Remaniez votre onze de départ';

  @override
  String hubEventReshapeOutSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count titulaires sont indisponibles (suspendus ou blessés). Choisissez leurs remplaçants',
      one:
          '1 titulaire est indisponible (suspendu ou blessé). Choisissez son remplaçant',
    );
    return '$_temp0';
  }

  @override
  String hubEventReshapeShortSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Votre onze de départ est incomplet. Pourvoyez les postes vacants',
      one: 'Votre onze de départ est incomplet. Pourvoyez le poste vacant',
    );
    return '$_temp0';
  }

  @override
  String hubEventPlayOpponent(String opponent) {
    return 'Affronter : $opponent';
  }

  @override
  String get hubEventContinentalFinalsFallback =>
      'la phase finale continentale';

  @override
  String get hubCallUpFriendlies => 'Convoquez votre liste pour les amicaux';

  @override
  String get hubCallUpRequalify =>
      'Reconvoquez votre liste pour les qualifications';

  @override
  String get hubCallUpWorldCup =>
      'Convoquez votre liste pour le Championnat du monde';

  @override
  String get hubCallUpFinals => 'Convoquez votre liste pour la phase finale';

  @override
  String get hubCallUpNationsCup =>
      'Convoquez votre liste pour la Coupe des Nations';

  @override
  String get hubCallUpQualifying =>
      'Convoquez votre liste pour les qualifications';

  @override
  String get hubCallUpGeneric => 'Convoquez votre liste';

  @override
  String get hubHost => 'Hôte';

  @override
  String get hubGoldenBoot => 'Soulier d’or';

  @override
  String hubGoldenBootValue(String name, int goals) {
    return '$name · $goals buts';
  }

  @override
  String get hubPens => '(t.a.b.)';

  @override
  String get hubNationalHub => 'QG DE LA SÉLECTION';

  @override
  String get hubMessages => 'Messages';

  @override
  String get hubWorldChampions => 'CHAMPIONS DU MONDE';

  @override
  String get hubViewBracket => 'Voir le tableau ›';

  @override
  String get hubBoardDelighted => 'Ravie';

  @override
  String get hubBoardPleased => 'Satisfaite';

  @override
  String get hubBoardExpectingMore => 'En attend plus';

  @override
  String get hubBoardConcerned => 'Inquiète';

  @override
  String get hubBoardJobAtRisk => 'Poste menacé';

  @override
  String get hubBoard => 'DIRECTION';

  @override
  String hubBoardObjective(String label) {
    return 'Objectif de la direction : $label';
  }

  @override
  String hubObjectiveMet(String result) {
    return 'ATTEINT · $result';
  }

  @override
  String hubObjectiveMissed(String result) {
    return 'MANQUÉ · $result';
  }

  @override
  String get hubNoMoreFixtures => 'Plus aucun match ce cycle.';

  @override
  String get hubNextMatch => 'PROCHAIN MATCH';

  @override
  String get hubVs => 'VS';

  @override
  String hubWorldRank(int rank) {
    return '#$rank';
  }

  @override
  String get hubWorldRankLabel => 'Classement mondial';

  @override
  String get hubSquadStatus => 'ÉTAT DE L’EFFECTIF';

  @override
  String hubPlayers(int count) {
    return '$count joueurs';
  }

  @override
  String get hubAvgRating => 'Note moyenne';

  @override
  String get hubMorale => 'Moral';

  @override
  String get hubManageTeam => 'Gérer l’équipe';

  @override
  String get hubGroupsToBeDrawn =>
      'Groupes pas encore tirés. Suivez le tirage pour les découvrir.';

  @override
  String hubGroupName(String name) {
    return 'GROUPE $name';
  }

  @override
  String get hubTblTeam => 'ÉQUIPE';

  @override
  String get hubTblP => 'J';

  @override
  String get hubTblGd => 'DIFF';

  @override
  String get hubTblPts => 'PTS';

  @override
  String get homeSettings => 'Paramètres';

  @override
  String get homeLeadTheNation => 'MENEZ LA NATION';

  @override
  String get homeYourNation => 'votre sélection';

  @override
  String get homeNewGame => 'Nouvelle partie';

  @override
  String get homeAllSaves => 'Toutes les sauvegardes';

  @override
  String get homeLoadGame => 'Charger une partie';

  @override
  String get homeContinue => 'CONTINUER';

  @override
  String homeRoadToWorldCup(String date, int year) {
    return '$date · En route vers le Championnat du monde $year';
  }

  @override
  String get careerManageSaves => 'Gérer les sauvegardes';

  @override
  String get careerNewGameTitle => 'NOUVELLE PARTIE';

  @override
  String careerCouldNotLoadNation(String error) {
    return 'Impossible de charger la nation.\n$error';
  }

  @override
  String get careerNationNotFound => 'Nation introuvable.';

  @override
  String careerWorldRankNum(int rank) {
    return '${rank}E MONDIAL';
  }

  @override
  String get careerManagerName => 'Nom du sélectionneur';

  @override
  String get careerManagerNameHint => 'ex. Alex Ferguson';

  @override
  String get careerBeginsBlurb =>
      'Votre carrière commence en septembre 2026, sur la route du Championnat du monde 2030.';

  @override
  String get careerFreeCycleNote =>
      'Gratuit pendant un cycle complet de quatre ans : qualifications, votre championnat continental et le Championnat du monde, sur deux sauvegardes. Ensuite, un seul paiement débloque les cycles infinis.';

  @override
  String get careerStartCareer => 'Commencer la carrière';

  @override
  String get careersTitle => 'CARRIÈRES';

  @override
  String get careerManagerCareer => 'Carrière de sélectionneur';

  @override
  String get careerManagerCareerSubtitle =>
      'Chaque cycle dirigé et votre bilan global';

  @override
  String get careerSummaryTitle => 'Résumé de carrière';

  @override
  String get careerSummarySubtitle => 'Votre armoire à trophées et votre bilan';

  @override
  String get careerAchievements => 'Succès';

  @override
  String get careerAchievementsSubtitle =>
      'Étapes, titres et satisfaction de la direction';

  @override
  String get careerChallenges => 'Défis';

  @override
  String get careerChallengesSubtitle =>
      'De redoutables épreuves sur toute une carrière';

  @override
  String get careerTeamRecords => 'Records de l’équipe';

  @override
  String get careerTeamRecordsSubtitle =>
      'Meilleurs buteurs et sélections de l’histoire';

  @override
  String get careerMyMatches => 'Mes matchs';

  @override
  String get careerMyMatchesSubtitle => 'Tous les résultats et matchs à venir';

  @override
  String get careerTitle => 'CARRIÈRE';

  @override
  String careerCouldNotLoadCareer(String error) {
    return 'Impossible de charger la carrière.\n$error';
  }

  @override
  String get careerNoCareer => 'Aucune carrière.';

  @override
  String get careerTrophyCabinet => 'ARMOIRE À TROPHÉES';

  @override
  String get careerTournamentHistory => 'HISTORIQUE DES TOURNOIS';

  @override
  String get careerNoTournamentsYet => 'Aucun tournoi terminé pour l’instant.';

  @override
  String get careerTeamFallback => 'Équipe';

  @override
  String careerWorldNum(int rank) {
    return '${rank}E MONDIAL';
  }

  @override
  String careerPointsNum(int points) {
    return '$points PTS';
  }

  @override
  String careerSeasonNum(int season) {
    return 'SAISON $season';
  }

  @override
  String get careerStatPlayedShort => 'J';

  @override
  String get careerStatsHeading => 'EN CHIFFRES';

  @override
  String get careerStatsWinRate => '% de victoires';

  @override
  String get careerStatsGoalsFor => 'Buts marqués';

  @override
  String get careerStatsGoalsAgainst => 'Buts encaissés';

  @override
  String get careerStatsGoalDiff => 'Différence';

  @override
  String get careerStatsCleanSheets => 'Clean sheets';

  @override
  String get careerStatsBiggestWin => 'Plus large victoire';

  @override
  String get careerStatsWinStreak => 'Série de victoires';

  @override
  String get careerStatsUnbeaten => 'Série sans défaite';

  @override
  String get careerStatsShootouts => 'Séances de tirs au but';

  @override
  String get careerStatsHatTricks => 'Triplés';

  @override
  String get careerStatsMotms => 'Homme du match';

  @override
  String get careerStatsBestRating => 'Meilleure note';

  @override
  String get careerStatWonShort => 'V';

  @override
  String get careerStatDrawnShort => 'N';

  @override
  String get careerStatLostShort => 'D';

  @override
  String get careerStatGoalsForShort => 'BP';

  @override
  String get careerStatGoalsAgainstShort => 'BC';

  @override
  String get careerStatGoalDiffShort => 'DIFF';

  @override
  String get careerNoSilverware =>
      'Aucun trophée pour l’instant. Allez en gagner un.';

  @override
  String get careerMedalGold => 'OR';

  @override
  String get careerMedalSilver => 'ARGENT';

  @override
  String get careerMedalBronze => 'BRONZE';

  @override
  String careerWinnersName(String name) {
    return 'Vainqueur : $name';
  }

  @override
  String get careerSavesTitle => 'SAUVEGARDES';

  @override
  String careerCouldNotLoadSaves(String error) {
    return 'Impossible de charger les sauvegardes.\n$error';
  }

  @override
  String careerSlotsCount(int used, int limit) {
    return 'EMPLACEMENTS  $used/$limit';
  }

  @override
  String get careerThisSave => 'cette sauvegarde';

  @override
  String get careerSlotsFull => 'Emplacements pleins';

  @override
  String careerSlotsUsed(int used) {
    return 'EMPLACEMENTS  $used';
  }

  @override
  String get careerSlotsUnlockMore => 'Débloquer plus de sauvegardes';

  @override
  String get careerSlotsKeepNote =>
      'Toutes vos sauvegardes existantes restent jouables. Seule une nouvelle nécessite le déblocage.';

  @override
  String get careerNewGame => 'Nouvelle partie';

  @override
  String get careerDeleteSaveTitle => 'Supprimer la sauvegarde ?';

  @override
  String careerDeleteSaveBody(String label) {
    return 'Cela supprime définitivement votre carrière $label.';
  }

  @override
  String get careerCancel => 'Annuler';

  @override
  String get careerDelete => 'Supprimer';

  @override
  String get careerNoSavesYet =>
      'Aucune sauvegarde.\nLancez une nouvelle partie pour diriger une nation.';

  @override
  String get careerUnknownNation => 'Inconnu';

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
    return 'Dernière partie : $when';
  }

  @override
  String get careerJustNow => 'à l’instant';

  @override
  String get careerYesterday => 'hier';

  @override
  String careerMinutesAgo(int n) {
    return 'il y a $n min';
  }

  @override
  String careerHoursAgo(int n) {
    return 'il y a $n h';
  }

  @override
  String careerDaysAgo(int n) {
    return 'il y a $n j';
  }

  @override
  String careerRoadToWorldCup(int year) {
    return 'En route vers le Championnat du monde $year';
  }

  @override
  String get careerManagerCareerTitle => 'CARRIÈRE DE SÉLECTIONNEUR';

  @override
  String careerCouldNotLoad(String error) {
    return 'Chargement impossible.\n$error';
  }

  @override
  String get careerCycleByCycle => 'CYCLE PAR CYCLE';

  @override
  String careerCyclesNationsLed(int cycles, int nations) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles cycles',
      one: '$cycles cycle',
    );
    String _temp1 = intl.Intl.pluralLogic(
      nations,
      locale: localeName,
      other: '$nations nations dirigées',
      one: '$nations nation dirigée',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get careerStatTitles => 'Titres';

  @override
  String get careerStatPlayed => 'Joués';

  @override
  String get careerStatWon => 'Victoires';

  @override
  String get careerStatDrawn => 'Nuls';

  @override
  String get careerStatLost => 'Défaites';

  @override
  String careerGoalsWinRate(
    int goalsFor,
    int goalsAgainst,
    String gd,
    int winRate,
  ) {
    return 'Buts $goalsFor-$goalsAgainst  ($gd)  ·  Victoires $winRate %';
  }

  @override
  String get careerRecordResults => 'RÉSULTATS RECORDS';

  @override
  String get careerBestWin => 'Plus belle victoire';

  @override
  String get careerWorstDefeat => 'Pire défaite';

  @override
  String careerVsOpponentDate(String opponent, String date) {
    return 'contre $opponent · $date';
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
    return '${won}V ${drawn}N ${lost}D  ·  BP $goalsFor BC $goalsAgainst ($gd)';
  }

  @override
  String get careerWorldCupLabel => 'Championnat du monde';

  @override
  String get careerContinentalLabel => 'Continental';

  @override
  String get messagesTitle => 'MESSAGES';

  @override
  String get messagesNoMessagesYet => 'Aucun message pour l’instant.';

  @override
  String messagesCouldNotLoad(String error) {
    return 'Impossible de charger les messages.\n$error';
  }

  @override
  String get messagesDone => 'Terminé';

  @override
  String get messagesNext => 'Suivant';

  @override
  String get rankingWorldRanking => 'CLASSEMENT MONDIAL';

  @override
  String rankingCouldNotLoad(String error) {
    return 'Impossible de charger le classement.\n$error';
  }

  @override
  String get rankingNoRanking => 'Aucun classement.';

  @override
  String get rankingAll => 'TOUS';

  @override
  String get rankingYourTeam => 'VOTRE ÉQUIPE';

  @override
  String get rankingYourRankingOverTime => 'VOTRE CLASSEMENT DANS LE TEMPS';

  @override
  String rankingNowRank(int rank) {
    return 'actuel #$rank';
  }

  @override
  String rankingBestWorst(int best, int worst) {
    return 'meilleur #$best · pire #$worst';
  }

  @override
  String get friendliesTitle => 'MATCHS AMICAUX';

  @override
  String friendliesLoadError(String error) {
    return 'Impossible de charger les matchs amicaux.\n$error';
  }

  @override
  String get friendliesContinue => 'Continuer';

  @override
  String friendliesArrangeIntro(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'pour les $count fenêtres libres',
      one: 'pour la fenêtre libre',
    );
    return 'Organisez des matchs de préparation $_temp0 avant votre prochain match officiel. Touchez un adversaire, ou laissez libre.';
  }

  @override
  String get friendliesFree => 'Libre';

  @override
  String matchGoalsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count BUTS',
      one: '1 BUT',
    );
    return '$_temp0';
  }

  @override
  String get matchGoalsTitle => 'BUTS';

  @override
  String get matchGoalsNone => 'Aucun but';

  @override
  String get matchGoalPenalty => 'PEN';

  @override
  String get matchGoalSetPiece => 'CPA';

  @override
  String matchGoalAssist(String name) {
    return 'passe déc. $name';
  }

  @override
  String get friendliesHome => 'DOMICILE';

  @override
  String get friendliesAway => 'EXTÉRIEUR';

  @override
  String get friendliesNoneThisWindow => 'Pas d’amical sur cette fenêtre';

  @override
  String friendliesConfirmCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count matchs amicaux',
      one: '$count match amical',
    );
    return 'Valider $_temp0';
  }

  @override
  String get friendliesMonthJan => 'janv.';

  @override
  String get friendliesMonthFeb => 'févr.';

  @override
  String get friendliesMonthMar => 'mars';

  @override
  String get friendliesMonthApr => 'avr.';

  @override
  String get friendliesMonthMay => 'mai';

  @override
  String get friendliesMonthJun => 'juin';

  @override
  String get friendliesMonthJul => 'juil.';

  @override
  String get friendliesMonthAug => 'août';

  @override
  String get friendliesMonthSep => 'sept.';

  @override
  String get friendliesMonthOct => 'oct.';

  @override
  String get friendliesMonthNov => 'nov.';

  @override
  String get friendliesMonthDec => 'déc.';

  @override
  String get resultsMyMatches => 'MES MATCHS';

  @override
  String resultsCouldNotLoad(String error) {
    return 'Impossible de charger les résultats.\n$error';
  }

  @override
  String get resultsNoFixtures => 'Aucun match.';

  @override
  String get resultsVs => 'vs';

  @override
  String get resultsStageQualifier => 'QUALIFICATIONS';

  @override
  String get resultsStageFriendly => 'AMICAL';

  @override
  String get resultsStageGroupStage => 'PHASE DE GROUPES';

  @override
  String get resultsStageSemiFinal => 'DEMI-FINALE';

  @override
  String get resultsStageFinal => 'FINALE';

  @override
  String get resultsStageContinentalClash => 'CHOC DES CONTINENTS';

  @override
  String get resultsStageFinalsGroup => 'GROUPE DE LA PHASE FINALE';

  @override
  String get resultsStageRoundOf32 => 'SEIZIÈMES DE FINALE';

  @override
  String get resultsStageRoundOf16 => 'HUITIÈMES DE FINALE';

  @override
  String get resultsStageQuarterFinal => 'QUART DE FINALE';

  @override
  String get resultsStageThirdPlace => '3E PLACE';

  @override
  String get matchSetupWarnCaptain =>
      'Aucun capitaine désigné. Touchez pour confier le brassard';

  @override
  String matchSetupWarnCaptainInjured(String name) {
    return '$name est blessé et ne peut pas porter le brassard. Touchez pour le confier à un autre';
  }

  @override
  String matchSetupWarnCaptainSuspended(String name) {
    return '$name est suspendu pour ce match. Touchez pour confier le brassard à un autre';
  }

  @override
  String matchSetupWarnCaptainDropped(String name) {
    return '$name porte le brassard mais n’est pas dans votre liste. Touchez pour le confier à un autre';
  }

  @override
  String get matchSetupWarnSetPieces =>
      'Aucun tireur de CPA désigné. Touchez pour choisir';

  @override
  String get matchSetupWarnBoth =>
      'Ni capitaine ni tireurs de CPA. Touchez pour les désigner';

  @override
  String matchStageMatchday(int matchday) {
    return 'J$matchday';
  }

  @override
  String get squadCaptain => 'Capitaine';

  @override
  String deptEffectYouth(int points) {
    return 'Les jeunes du centre arrivent avec environ $points points de niveau en plus';
  }

  @override
  String deptEffectCommercial(String amount) {
    return '$amount récupérés en fin de cycle';
  }

  @override
  String deptEffectMedical(int percent) {
    return '$percent % de blessures en moins';
  }

  @override
  String deptEffectNaturalisation(int percent) {
    return '$percent % de chances qu’un joueur étranger demande à changer de sélection';
  }

  @override
  String deptEffectBoard(int points) {
    return '+$points de patience de la direction avant que votre poste soit menacé';
  }

  @override
  String get deptEffectNone => 'Aucun effet sans financement';

  @override
  String get statsBestRated => 'Notes';

  @override
  String get statsMyCareer => 'Carrière';

  @override
  String get statsBestAverageRating => 'MEILLEURE NOTE MOYENNE';

  @override
  String get statsMyCareerRecord => 'VOTRE BILAN';

  @override
  String get statsNoRatingsRecorded => 'Aucune note de match enregistrée.';

  @override
  String get statsGroupRecord => 'Bilan';

  @override
  String get statsGroupRuns => 'Séries';

  @override
  String get statsGroupExtremes => 'Extrêmes';

  @override
  String get statsGroupSplits => 'Domicile et extérieur';

  @override
  String get statsGroupSquad => 'Vos joueurs';

  @override
  String get statsPlayed => 'Matchs joués';

  @override
  String get statsWinDrawLoss => 'Victoires-nuls-défaites';

  @override
  String get statsWinRate => '% de victoires';

  @override
  String get statsGoals => 'Buts pour:contre';

  @override
  String get statsCleanSheets => 'Clean sheets';

  @override
  String get statsFailedToScore => 'Matchs sans marquer';

  @override
  String get statsLongestWinStreak => 'Plus longue série de victoires';

  @override
  String get statsLongestUnbeaten => 'Plus longue série sans défaite';

  @override
  String get statsLongestCleanSheets => 'Plus longue série sans encaisser';

  @override
  String get statsLongestWinless => 'Plus longue série sans victoire';

  @override
  String get statsCurrentRun => 'Série en cours sans défaite';

  @override
  String get statsBiggestWin => 'Plus large victoire';

  @override
  String get statsHeaviestDefeat => 'Plus lourde défaite';

  @override
  String get statsMostGoalsInAGame => 'Plus de buts en un match';

  @override
  String get statsShootouts => 'Tirs au but gagnés-perdus';

  @override
  String get statsComebackWins => 'Victoires après avoir été mené';

  @override
  String get statsHome => 'Domicile';

  @override
  String get statsAway => 'Extérieur';

  @override
  String get statsNeutral => 'Terrain neutre';

  @override
  String get statsCompetitive => 'Officiels';

  @override
  String get statsFriendlies => 'Amicaux';

  @override
  String get statsHatTricks => 'Triplés';

  @override
  String get statsBraces => 'Doublés';

  @override
  String get statsMotms => 'Titres d’homme du match';

  @override
  String get statsAssists => 'Passes décisives';

  @override
  String get statsCards => 'Cartons';

  @override
  String get statsBestRating => 'Meilleure note individuelle';

  @override
  String statsAppsShort(int apps) {
    return '$apps matchs';
  }

  @override
  String statsMotmShort(int motms) {
    return '$motms HDM';
  }

  @override
  String get captainArmband => 'C';

  @override
  String get captainCurrent => 'Capitaine. Touchez pour retirer le brassard';

  @override
  String get captainFitBorn => 'Un leader né';

  @override
  String get captainFitNatural => 'Un capitaine naturel';

  @override
  String get captainFitCapable => 'Pourrait le porter';

  @override
  String get captainFitUnproven => 'Pas encore un leader';

  @override
  String get captainNone => 'Aucun capitaine désigné';

  @override
  String captainMoraleBoost(int morale) {
    return '+$morale de moral pour le groupe';
  }

  @override
  String get resultsCategoryWorldCupQualifying =>
      'Qualifications du Championnat du monde';

  @override
  String get resultsCategoryFriendlies => 'Amicaux';

  @override
  String get resultsCategoryContinentalClash => 'Choc des continents';

  @override
  String get resultsCategoryNationsCup => 'Coupe des Nations';

  @override
  String get resultsCategoryContinentalCup => 'Coupe continentale';

  @override
  String get resultsCategoryWorldCupQualifyingShort => 'Qualif. Ch. du monde';

  @override
  String get resultsCategoryContinentalQualifyingShort =>
      'Qualif. continentales';

  @override
  String get resultsCategoryContinentalQualifying =>
      'Qualifications de la coupe continentale';

  @override
  String get resultsCategoryWorldCupFinals =>
      'Phase finale du Championnat du monde';

  @override
  String get resultsRoundResults => 'RÉSULTATS DE LA JOURNÉE';

  @override
  String get resultsFriendlyInternationals => 'MATCHS AMICAUX INTERNATIONAUX';

  @override
  String get resultsKnockout => 'Phase à élimination directe';

  @override
  String resultsEarlierMatches(int count) {
    return 'Matchs précédents ($count)';
  }

  @override
  String resultsMatchday(int matchday) {
    return 'JOURNÉE $matchday';
  }

  @override
  String get resultsContinue => 'Continuer';

  @override
  String resultsGroup(String name) {
    return 'GROUPE $name';
  }

  @override
  String get achievementsScreenTitle => 'SUCCÈS';

  @override
  String get achievementsChallengesTooltip => 'Défis';

  @override
  String get achievementsChallengesHeading => 'DÉFIS';

  @override
  String get achievementsBrutalTests =>
      'De redoutables épreuves sur toute une carrière';

  @override
  String achievementsCouldNotLoad(String error) {
    return 'Chargement impossible.\n$error';
  }

  @override
  String achievementsUnlockedCount(int earned, int total) {
    return '$earned / $total débloqués';
  }

  @override
  String achievementsConqueredCount(int done, int total) {
    return '$done / $total relevés';
  }

  @override
  String get achievementsBoardSatisfaction => 'SATISFACTION DE LA DIRECTION';

  @override
  String achievementsUnlockedBanner(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count SUCCÈS DÉBLOQUÉS',
      one: 'SUCCÈS DÉBLOQUÉ',
    );
    return '$_temp0';
  }

  @override
  String get achCatWins => 'Victoires';

  @override
  String get achCatMatches => 'Matchs';

  @override
  String get achCatQualifications => 'Qualifications';

  @override
  String get achCatTitles => 'Titres';

  @override
  String get achCatMisc => 'Divers';

  @override
  String get achCatMega => 'Méga';

  @override
  String get achCatGoals => 'Buts';

  @override
  String get achCatStreaks => 'Séries';

  @override
  String get achTierBronze => 'Bronze';

  @override
  String get achTierSilver => 'Argent';

  @override
  String get achTierGold => 'Or';

  @override
  String get achTierPlatinum => 'Platine';

  @override
  String achGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count buts',
      one: '$count but',
    );
    return '$_temp0';
  }

  @override
  String achGoalsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Marquez $count buts.',
      one: 'Marquez 1 but.',
    );
    return '$_temp0';
  }

  @override
  String achCleanSheets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count clean sheets',
      one: '$count clean sheet',
    );
    return '$_temp0';
  }

  @override
  String achCleanSheetsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Gardez votre cage inviolée $count fois.',
      one: 'Gardez votre cage inviolée 1 fois.',
    );
    return '$_temp0';
  }

  @override
  String get achStreakWin5 => 'L’habitude de gagner';

  @override
  String get achStreakWin5Desc => 'Gagnez cinq matchs d’affilée.';

  @override
  String get achStreakWin10 => 'Sur une lancée';

  @override
  String get achStreakWin10Desc => 'Gagnez dix matchs d’affilée.';

  @override
  String get achStreakWin20 => 'Rouleau compresseur';

  @override
  String get achStreakWin20Desc => 'Gagnez vingt matchs d’affilée.';

  @override
  String get achUnbeaten15 => 'Difficile à battre';

  @override
  String get achUnbeaten15Desc => 'Restez invaincu quinze matchs.';

  @override
  String get achUnbeaten30 => 'Intouchable';

  @override
  String get achUnbeaten30Desc => 'Restez invaincu trente matchs.';

  @override
  String get achHattrick => 'Héros du triplé';

  @override
  String get achHattrickDesc => 'Un de vos joueurs réussit un triplé.';

  @override
  String get achMotm10 => 'Homme fort';

  @override
  String get achMotm10Desc => 'Remportez 10 titres d’homme du match.';

  @override
  String get achMotm50 => 'Talisman';

  @override
  String get achMotm50Desc => 'Remportez 50 titres d’homme du match.';

  @override
  String get achPerfect => 'Dix sur dix';

  @override
  String get achPerfectDesc =>
      'Un de vos joueurs obtient une note de 9,5 ou plus.';

  @override
  String get achShootout => 'Sang-froid';

  @override
  String get achShootoutDesc => 'Remportez cinq séances de tirs au but.';

  @override
  String get achMassacre => 'Massacre';

  @override
  String get achMassacreDesc => 'Gagnez un match par 7 buts d’écart ou plus.';

  @override
  String get achAnnihilation => 'Anéantissement';

  @override
  String get achAnnihilationDesc =>
      'Gagnez un match par 10 buts d’écart ou plus.';

  @override
  String get chTierBronze => 'Bronze';

  @override
  String get chTierSilver => 'Argent';

  @override
  String get chTierGold => 'Or';

  @override
  String get chTierLegendary => 'Légendaire';

  @override
  String get chFirstSteps => 'Sur le banc';

  @override
  String get chFirstStepsDesc => 'Entraînez pendant 5 ans.';

  @override
  String get chUnbeaten10 => 'Sur une lancée';

  @override
  String get chUnbeaten10Desc => 'Restez invaincu 10 matchs officiels.';

  @override
  String get chTwoNations => 'Nouveau défi';

  @override
  String get chTwoNationsDesc => 'Dirigez 2 nations différentes.';

  @override
  String get chCont1 => 'Champion continental';

  @override
  String get chCont1Desc => 'Remportez un championnat continental.';

  @override
  String get chNc1 => 'Vainqueur de la Coupe des Nations';

  @override
  String get chNc1Desc => 'Remportez la Coupe des Nations.';

  @override
  String get chWc1 => 'Champion du monde';

  @override
  String get chWc1Desc => 'Remportez le Championnat du monde.';

  @override
  String get chYears25 => 'Institution';

  @override
  String get chYears25Desc => 'Entraînez pendant 25 ans.';

  @override
  String get chWc3 => 'Gagneur en série';

  @override
  String get chWc3Desc => 'Remportez 3 Championnats du monde.';

  @override
  String get chWc5 => 'Dynastie';

  @override
  String get chWc5Desc => 'Remportez 5 Championnats du monde.';

  @override
  String get chWc10 => 'Immortel';

  @override
  String get chWc10Desc => 'Remportez 10 Championnats du monde.';

  @override
  String get chWc2Teams => 'Valise à la main';

  @override
  String get chWc2TeamsDesc =>
      'Remportez le Championnat du monde avec 2 nations différentes.';

  @override
  String get chWc3Teams => 'Globe-trotter';

  @override
  String get chWc3TeamsDesc =>
      'Remportez le Championnat du monde avec 3 nations différentes.';

  @override
  String get chWcStreak3 => 'Triplé historique';

  @override
  String get chWcStreak3Desc => 'Remportez 3 Championnats du monde d’affilée.';

  @override
  String get chWcAllconf => 'Conquérant du monde';

  @override
  String get chWcAllconfDesc =>
      'Remportez le Championnat du monde avec une nation de chaque confédération (6).';

  @override
  String get chCont5 => 'Roi du continent';

  @override
  String get chCont5Desc => 'Remportez 5 championnats continentaux.';

  @override
  String get chContAll => 'Grand Chelem des six continents';

  @override
  String get chContAllDesc =>
      'Remportez le championnat continental de chaque confédération (6).';

  @override
  String get chTreble => 'Razzia';

  @override
  String get chTrebleDesc =>
      'Remportez le Championnat du monde, un titre continental et la Coupe des Nations dans une même carrière.';

  @override
  String get chNations10 => 'Nomade';

  @override
  String get chNations10Desc => 'Dirigez 10 nations différentes.';

  @override
  String get chYears100 => 'Centenaire';

  @override
  String get chYears100Desc => 'Entraînez pendant 100 ans.';

  @override
  String get chYears500 => 'Demi-millénaire';

  @override
  String get chYears500Desc => 'Entraînez pendant 500 ans.';

  @override
  String get chYears1000 => 'Éternel';

  @override
  String get chYears1000Desc => 'Entraînez pendant 1000 ans.';

  @override
  String get chGrandmaster => 'Grand maître';

  @override
  String get chGrandmasterDesc =>
      'Remportez 3 Championnats du monde ET 5 championnats continentaux.';

  @override
  String get chUndefeated => 'Intouchable';

  @override
  String get chUndefeatedDesc =>
      'Remportez un Championnat du monde sans perdre un seul match.';

  @override
  String get chPerfectQual => 'Parcours parfait';

  @override
  String get chPerfectQualDesc =>
      'Gagnez tous les matchs d’une campagne de qualification au Championnat du monde.';

  @override
  String get chMinnow => 'Le miracle du petit poucet';

  @override
  String get chMinnowDesc =>
      'Remportez le Championnat du monde avec une nation classée hors du top 32 mondial.';

  @override
  String get chGrandTour => 'Domicile et extérieur';

  @override
  String get chGrandTourDesc =>
      'Remportez un Championnat du monde en tant que pays hôte et un autre loin de chez vous.';

  @override
  String get chUnbeaten25 => 'Le mur';

  @override
  String get chUnbeaten25Desc => 'Restez invaincu 25 matchs officiels.';

  @override
  String get chGoals10k => 'Machine à buts';

  @override
  String get chGoals10kDesc => 'Marquez 10 000 buts en carrière.';

  @override
  String get chCleanSheets500 => 'Forteresse';

  @override
  String get chCleanSheets500Desc =>
      'Gardez votre cage inviolée 500 fois en carrière.';

  @override
  String get chHatTricks25 => 'Collectionneur de triplés';

  @override
  String get chHatTricks25Desc => 'Vos joueurs réussissent 25 triplés.';

  @override
  String get chWinStreak25 => 'Implacable';

  @override
  String get chWinStreak25Desc => 'Gagnez 25 matchs d’affilée.';

  @override
  String get chCont10 => 'Dynastie continentale';

  @override
  String get chCont10Desc => 'Remportez 10 championnats continentaux.';

  @override
  String get chPcWc => 'Champion en série';

  @override
  String chPcWcDesc(int count) {
    return 'Remportez $count Championnats du monde dans cette partie.';
  }

  @override
  String get chPcMajors => 'Collectionneur de trophées';

  @override
  String chPcMajorsDesc(int count) {
    return 'Remportez $count trophées majeurs (Championnat du monde, titre continental ou Coupe des Nations).';
  }

  @override
  String get chPcUnbeaten => 'Mur de fer';

  @override
  String chPcUnbeatenDesc(int count) {
    return 'Restez invaincu $count matchs officiels.';
  }

  @override
  String get chPcNations => 'Bourlingueur';

  @override
  String chPcNationsDesc(int count) {
    return 'Dirigez $count nations différentes.';
  }

  @override
  String get chPcYears => 'Sur la durée';

  @override
  String chPcYearsDesc(int count) {
    return 'Entraînez pendant $count ans.';
  }

  @override
  String achWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count victoires',
      one: '1 victoire',
    );
    return '$_temp0';
  }

  @override
  String achWinsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Gagnez $count matchs.',
      one: 'Gagnez 1 match.',
    );
    return '$_temp0';
  }

  @override
  String achMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count matchs',
      one: '$count match',
    );
    return '$_temp0';
  }

  @override
  String achMatchesDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Jouez $count matchs.',
      one: 'Jouez 1 match.',
    );
    return '$_temp0';
  }

  @override
  String get achQualWc => 'Qualifié pour le Championnat du monde';

  @override
  String get achQualWcDesc =>
      'Atteignez la phase finale du Championnat du monde.';

  @override
  String get achQualCont => 'Qualifié pour le championnat continental';

  @override
  String get achQualContDesc =>
      'Atteignez la phase finale de votre championnat continental.';

  @override
  String get achTitleWc => 'Champions du monde';

  @override
  String get achTitleWcDesc => 'Remportez le Championnat du monde.';

  @override
  String get achTitleEuro => 'Champions d’Europe';

  @override
  String get achTitleEuroDesc => 'Remportez le Championnat d’Europe.';

  @override
  String get achTitleCopa => 'Champions d’Amérique du Sud';

  @override
  String get achTitleCopaDesc => 'Remportez la Coupe d’Amérique du Sud.';

  @override
  String get achTitleAfcon => 'Champions d’Afrique';

  @override
  String get achTitleAfconDesc => 'Remportez le Championnat d’Afrique.';

  @override
  String get achTitleAsia => 'Champions d’Asie';

  @override
  String get achTitleAsiaDesc => 'Remportez le Championnat d’Asie.';

  @override
  String get achTitleConcacaf => 'Champions d’Amérique du Nord';

  @override
  String get achTitleConcacafDesc => 'Remportez la Coupe d’Amérique du Nord.';

  @override
  String get achTitleOfc => 'Champions d’Océanie';

  @override
  String get achTitleOfcDesc => 'Remportez la Coupe d’Océanie.';

  @override
  String get achTitleNations => 'Vainqueurs de la Coupe des Nations';

  @override
  String get achTitleNationsDesc => 'Remportez la Coupe des Nations.';

  @override
  String get achTitleClash => 'Vainqueurs du Choc des continents';

  @override
  String get achTitleClashDesc => 'Remportez le Choc des continents.';

  @override
  String get achMarksman => 'Buteur du Championnat du monde';

  @override
  String get achMarksmanDesc =>
      'Un joueur de votre liste marque 6 buts ou plus en phase finale du Championnat du monde.';

  @override
  String get achSweep => 'Razzia';

  @override
  String get achSweepDesc =>
      'Détenez le Championnat du monde et votre titre continental dans une même carrière.';

  @override
  String get achAllstar => 'Équipe type du tournoi';

  @override
  String get achAllstarDesc =>
      'Un de vos joueurs figure dans l’équipe type d’un Championnat du monde.';

  @override
  String get achGoldenboot => 'Soulier d’or';

  @override
  String get achGoldenbootDesc =>
      'Votre nation compte le meilleur buteur d’un championnat.';

  @override
  String get achDemolition => 'Démolition';

  @override
  String get achDemolitionDesc => 'Gagnez un match par 5 buts d’écart ou plus.';

  @override
  String get achievementsNice => 'Bravo !';

  @override
  String get achievementsHardestTests =>
      'Les épreuves les plus dures pour un sélectionneur, sur toute une carrière et de nombreuses nations.';

  @override
  String get achievementsThisSave => 'CETTE PARTIE';

  @override
  String get achievementsBrutalBadge => 'REDOUTABLE';

  @override
  String get paywallGoPro => 'PASSEZ EN ILLIMITÉ';

  @override
  String get paywallOneTimeUnlock => 'Déblocage unique. Sans abonnement.';

  @override
  String get paywallBenefitCarryOn =>
      'Cette partie reprend exactement là où elle s’est arrêtée, avec chaque sélection, record et rivalité intacts.';

  @override
  String get paywallBenefitNoAds =>
      'Pas de pub, pas de microtransactions, pas d’abonnement. Un seul paiement, et toutes les futures mises à jour sont à vous.';

  @override
  String get paywallBenefitSaves =>
      'Autant de sauvegardes que vous voulez. Menez un favori et un petit poucet en même temps, et voyez à quel point le même jeu se lit différemment.';

  @override
  String get paywallBenefitEndless =>
      'Tous les cycles à venir. Repérez un joueur de dix-sept ans aujourd’hui et découvrez en 2034 si vous aviez vu juste.';

  @override
  String get paywallUnlocked => 'Illimité débloqué. Bon jeu !';

  @override
  String get paywallContactingStore => 'Connexion à la boutique…';

  @override
  String paywallUnlockProPriced(String price) {
    return 'Débloquer Illimité · $price';
  }

  @override
  String get paywallRestorePurchases => 'Restaurer les achats';

  @override
  String get paywallStoreUnavailable => 'Boutique indisponible';

  @override
  String get paywallStoreUnavailableNote =>
      'Le prix n’a pas pu être chargé. Vérifiez votre connexion et réessayez.';

  @override
  String get paywallTryAgain => 'Réessayer';

  @override
  String get gateTitle => 'VOTRE PREMIER CYCLE EST TERMINÉ';

  @override
  String get gateLead =>
      'Quatre ans, c’est un cycle. Ce n’est pas assez pour savoir si vous aviez raison.';

  @override
  String get gatePriceLead => 'Un seul paiement, pour toujours';

  @override
  String get gateBuy => 'ACHETER ET CONTINUER';

  @override
  String get gateExit => 'QUITTER';

  @override
  String get federationNaturalisation => 'NATURALISATION';

  @override
  String federationNaturalisedTitle(String name) {
    return '$name naturalisé';
  }

  @override
  String federationNaturalisedBody(String name, String nation) {
    return '$name a finalisé son changement et peut désormais jouer pour la sélection $nation. Convoquez-le depuis votre liste.';
  }

  @override
  String federationCouldNotLoadOffer(String error) {
    return 'Impossible de charger l’offre.\n$error';
  }

  @override
  String get federationContinue => 'Continuer';

  @override
  String get federationOfferToSwitchAllegiance =>
      'UNE OFFRE DE CHANGEMENT DE SÉLECTION';

  @override
  String federationPlayerMeta(String position, int age, String nation) {
    return '$position · $age ans · origine : $nation';
  }

  @override
  String federationNaturalisationBlurb(
    String name,
    String playerNation,
    String sourceNation,
  ) {
    return '$name a des liens avec $playerNation et accepte d’être naturalisé. Acceptez et il sera sélectionnable, refusez et il reste lié à $sourceNation.';
  }

  @override
  String get federationDecline => 'Refuser';

  @override
  String get federationNaturalise => 'Naturaliser';

  @override
  String get federationBudgetLater => 'Décider plus tard';

  @override
  String get federationSetYourBudget => 'FIXEZ VOTRE BUDGET';

  @override
  String federationCouldNotLoadFinances(String error) {
    return 'Impossible de charger les finances.\n$error';
  }

  @override
  String get federationSaveNotFound => 'Sauvegarde introuvable.';

  @override
  String get federationBudgetHeading => 'BUDGET DE LA FÉDÉRATION';

  @override
  String federationDistributeBudget(String amount) {
    return 'Répartissez $amount entre les départements pour ouvrir le cycle. Dépensez avec sagesse.';
  }

  @override
  String federationOverBudget(String amount) {
    return '$amount de plus que ce dont dispose la fédération. Retirez-en un peu';
  }

  @override
  String get federationAllocateFullBudget =>
      'Allouez tout le budget pour commencer le cycle.';

  @override
  String get federationConfirming => 'Validation…';

  @override
  String get federationConfirmBudget => 'Valider le budget';

  @override
  String get federationFinances => 'FINANCES';

  @override
  String get federationInvestmentUpdated => 'Investissement mis à jour.';

  @override
  String get federationDevelopment => 'DÉVELOPPEMENT DE LA FÉDÉRATION';

  @override
  String get federationProjectedAtSeasonEnd => 'PRÉVISION EN FIN DE SAISON';

  @override
  String get federationCentralFunding => 'Dotation centrale';

  @override
  String get federationPrizeMoneySoFar => 'Primes perçues à ce jour';

  @override
  String get federationCommercialReturn => 'Revenus commerciaux';

  @override
  String get federationThisSeasonLocked => 'CETTE SAISON (VERROUILLÉ)';

  @override
  String get federationInvestForNextSeason =>
      'INVESTIR POUR LA SAISON PROCHAINE';

  @override
  String get federationNextSeasonImpact => 'IMPACT SUR LA SAISON PROCHAINE';

  @override
  String get federationSaving => 'Enregistrement…';

  @override
  String get federationConfirmInvestment => 'Valider l’investissement';

  @override
  String get federationBalance => 'SOLDE DE LA FÉDÉRATION';

  @override
  String get federationCommittedToStaff => 'Engagé pour le staff';

  @override
  String get federationFreeToSpend => 'Disponible';

  @override
  String get federationWagesNote =>
      'Les salaires sont prélevés sur le solde en fin de cycle, cette somme est donc déjà réservée.';

  @override
  String get federationInvestAtCeremony =>
      'Investissez pour la saison prochaine lors de la cérémonie de fin de cycle.';

  @override
  String federationLevelBadge(int level) {
    return 'N$level';
  }

  @override
  String get federationAcademyProspects => 'Jeunes du centre';

  @override
  String federationPlusOverall(int value) {
    return '+$value de niveau';
  }

  @override
  String get federationInjuryRisk => 'Risque de blessure';

  @override
  String get federationNaturalisationChance => 'Chance de naturalisation';

  @override
  String get federationBoardPatience => 'Patience de la direction';

  @override
  String get federationUnallocated => 'NON ALLOUÉ';

  @override
  String get nationsVitrineTitle => 'VITRINE NATIONALE';

  @override
  String nationsCouldNotLoad(String error) {
    return 'Impossible de charger la nation.\n$error';
  }

  @override
  String get nationsNoNation => 'Aucune nation.';

  @override
  String get nationsHonours => 'PALMARÈS';

  @override
  String get nationsRankingHistory => 'HISTORIQUE DU CLASSEMENT MONDIAL';

  @override
  String get nationsTopScorers => 'MEILLEURS BUTEURS DE L’HISTOIRE';

  @override
  String get nationsTitles => 'TITRES';

  @override
  String get nationsYourTeam => 'VOTRE ÉQUIPE';

  @override
  String get nationsWorld => 'MONDE';

  @override
  String get nationsWorldCup => 'Championnat du monde';

  @override
  String get nationsContinental => 'Continental';

  @override
  String nationsAppearances(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count participations',
      one: '1 participation',
    );
    return '$_temp0';
  }

  @override
  String get nationsNotEnoughHistory =>
      'Pas encore assez d’historique. Revenez dans un cycle ou deux.';

  @override
  String nationsBestRank(int rank) {
    return 'Meilleur : #$rank';
  }

  @override
  String nationsNowRank(int rank) {
    return 'Actuel : #$rank';
  }

  @override
  String get nationsNoGoals => 'Aucun but enregistré pour l’instant.';

  @override
  String get nationsGoalsAbbrev => 'buts';

  @override
  String get nationsHosts => 'HÔTES';

  @override
  String get nationsSelectTitle => 'CHOISIR UNE SÉLECTION';

  @override
  String nationsCouldNotLoadNations(String error) {
    return 'Impossible de charger les nations.\n$error';
  }

  @override
  String get nationsNoMatch => 'Aucune nation ne correspond.';

  @override
  String get nationsNationalLevel => 'NIVEAU NATIONAL';

  @override
  String get nationsSelectHeading => 'Choisir une sélection';

  @override
  String get nationsSearchHint => 'Chercher un pays…';

  @override
  String get nationsRank => 'RANG ';

  @override
  String get nationsPremium => 'PREMIUM';

  @override
  String get nationsSelect => 'CHOISIR';

  @override
  String get statsTeamRecords => 'RECORDS DE L’ÉQUIPE';

  @override
  String get statsRecordBook => 'Livre des records';

  @override
  String statsCouldNotLoadStats(String error) {
    return 'Impossible de charger les statistiques.\n$error';
  }

  @override
  String get statsNoData => 'Aucune donnée.';

  @override
  String get statsTopScorers => 'MEILLEURS BUTEURS';

  @override
  String get statsMostGamesPlayed => 'PLUS DE MATCHS JOUÉS';

  @override
  String get statsTeam => 'Équipe';

  @override
  String get statsTopScorersShort => 'Buteurs';

  @override
  String get statsMostGames => 'Plus de matchs';

  @override
  String get statsNoGoalsRecorded => 'Aucun but enregistré pour l’instant.';

  @override
  String get statsUnknown => 'Inconnu';

  @override
  String get playerTitle => 'JOUEUR';

  @override
  String playerLoadError(String error) {
    return 'Impossible de charger le joueur.\n$error';
  }

  @override
  String get playerNotFound => 'Joueur introuvable.';

  @override
  String get playerClub => 'CLUB';

  @override
  String get playerClubRole => 'En club';

  @override
  String get playerPosition => 'Poste';

  @override
  String get playerPotential => 'Potentiel';

  @override
  String get playerAge => 'Âge';

  @override
  String get playerValue => 'Valeur';

  @override
  String get clubFirstChoice => 'Joue chaque semaine';

  @override
  String get clubRotation => 'Dans la rotation';

  @override
  String get clubFringe => 'Joue très peu';

  @override
  String get clubFrozenOut => 'Ne joue pas';

  @override
  String clubAtClub(String club, String standing) {
    return '$club : $standing';
  }

  @override
  String yWinUpset0(String opponent, String score) {
    return 'Trente ans que je regarde du foot et je ne l’ai pas vue venir. $opponent battu $score.';
  }

  @override
  String yWinUpset1(String opponent, String score) {
    return 'Personne ne nous donnait la moindre chance face à $opponent. $score. Absolument personne.';
  }

  @override
  String yWinUpset2(String opponent, String score) {
    return '$score face à $opponent. Allez réveiller les voisins.';
  }

  @override
  String yWinUpset3(String opponent, String score) {
    return 'Le genre de soirée qu’on raconte à ses petits-enfants. $opponent $score.';
  }

  @override
  String yWinUpset4(String opponent, String score) {
    return '$score face à $opponent. Je ne sais pas comment, mais c’est fait.';
  }

  @override
  String yWinUpset5(String opponent, String score) {
    return 'Sur le papier, c’était plié d’avance. $opponent $score dit le contraire.';
  }

  @override
  String yWinUpset6(String opponent, String score) {
    return 'Victoire $score sur $opponent. Dans un an, personne ne croira ce score.';
  }

  @override
  String yWinUpset7(String opponent, String score) {
    return '$opponent $score. Savourez, puis regardez le calendrier.';
  }

  @override
  String yWinUpset8(String opponent, String score) {
    return '$score face à $opponent, et on a eu de la chance pendant quatre-vingts des quatre-vingt-dix minutes.';
  }

  @override
  String yWinUpset9(String opponent, String score) {
    return 'Une soirée face à $opponent n’efface pas une année. $score.';
  }

  @override
  String yWinUpset10(String opponent, String score) {
    return 'Victoire $score sur $opponent et on va nous dire qu’on a passé un cap. Ce n’est pas le cas.';
  }

  @override
  String yWinUpset11(String opponent, String score) {
    return '$opponent $score. Magnifique. Reparlons-en quand ça comptera.';
  }

  @override
  String yWinRoutine0(String opponent, String score) {
    return 'Victoire $score sur $opponent. Exactement comme prévu, et c’est un plaisir aussi.';
  }

  @override
  String yWinRoutine1(String opponent, String score) {
    return '$score contre $opponent. Implacable, et c’est un compliment.';
  }

  @override
  String yWinRoutine2(String opponent, String score) {
    return '$opponent $score. Sans histoire, sans frayeur, rien à redire.';
  }

  @override
  String yWinRoutine3(String opponent, String score) {
    return 'Un $score propre face à $opponent. Voilà à quoi ressemble une bonne équipe un jour tranquille.';
  }

  @override
  String yWinRoutine4(String opponent, String score) {
    return '$score face à $opponent. Travail fait, rien appris.';
  }

  @override
  String yWinRoutine5(String opponent, String score) {
    return 'Victoire $score sur $opponent. On devait gagner, on a gagné.';
  }

  @override
  String yWinRoutine6(String opponent, String score) {
    return 'Un $score sérieux face à $opponent. Au suivant.';
  }

  @override
  String yWinRoutine7(String opponent, String score) {
    return '$opponent expédié $score. On classe et on passe à autre chose.';
  }

  @override
  String yWinRoutine8(String opponent, String score) {
    return '$score face à $opponent et il faudrait applaudir. Pour les avoir battus.';
  }

  @override
  String yWinRoutine9(String opponent, String score) {
    return 'Bravo à tous pour le $score face à $opponent, j’imagine.';
  }

  @override
  String yWinRoutine10(String opponent, String score) {
    return '$opponent $score. Battre ce genre d’équipe, c’est le minimum, pas un exploit.';
  }

  @override
  String yWinRoutine11(String opponent, String score) {
    return 'Victoire $score sur $opponent, et on a eu l’air laborieux.';
  }

  @override
  String yWinTight0(String opponent, String score) {
    return '$score face à $opponent, et chaque minute a été méritée.';
  }

  @override
  String yWinTight1(String opponent, String score) {
    return 'Il a fallu du caractère. $opponent $score.';
  }

  @override
  String yWinTight2(String opponent, String score) {
    return 'Victoire $score sur $opponent à l’arrache, et c’est ce genre de victoire qui compte.';
  }

  @override
  String yWinTight3(String opponent, String score) {
    return '$score face à $opponent. Les équipes qui gagnent ces matchs-là sont encore debout en juin.';
  }

  @override
  String yWinTight4(String opponent, String score) {
    return 'Nerveux, moche, et une victoire. $opponent $score.';
  }

  @override
  String yWinTight5(String opponent, String score) {
    return 'Victoire $score sur $opponent. On prend les trois points et on ne revoit jamais ce match.';
  }

  @override
  String yWinTight6(String opponent, String score) {
    return '$score. $opponent nous a fait bosser pour chaque centimètre.';
  }

  @override
  String yWinTight7(String opponent, String score) {
    return '$opponent $score. Pas joli. Ça compte pareil.';
  }

  @override
  String yWinTight8(String opponent, String score) {
    return '$score face à $opponent, et on s’est compliqué la vie dix fois plus que nécessaire.';
  }

  @override
  String yWinTight9(String opponent, String score) {
    return 'On ne devrait pas trembler face à $opponent. $score.';
  }

  @override
  String yWinTight10(String opponent, String score) {
    return '$opponent $score. Gagné, et rien appris de bon sur nous-mêmes.';
  }

  @override
  String yWinTight11(String opponent, String score) {
    return 'Un $score flatteur face à $opponent.';
  }

  @override
  String yDrew0(String opponent, String score) {
    return 'Un point face à $opponent, $score. On prend et on avance.';
  }

  @override
  String yDrew1(String opponent, String score) {
    return '$score face à $opponent. Il y a pire comme après-midi.';
  }

  @override
  String yDrew2(String opponent, String score) {
    return '$score face à $opponent. Tout n’a pas besoin d’être une histoire.';
  }

  @override
  String yDrew3(String opponent, String score) {
    return '$opponent $score. Un point est un point, et le classement ne demande pas comment.';
  }

  @override
  String yDrew4(String opponent, String score) {
    return '$score face à $opponent. Deux points perdus ou un de gagné. Choisissez votre humeur.';
  }

  @override
  String yDrew5(String opponent, String score) {
    return 'Un nul face à $opponent, $score. Personne n’est content, personne n’est furieux.';
  }

  @override
  String yDrew6(String opponent, String score) {
    return '$opponent $score. Les quatre-vingt-dix minutes les plus oubliables de l’année.';
  }

  @override
  String yDrew7(String opponent, String score) {
    return 'Partage des points avec $opponent, $score. On continue.';
  }

  @override
  String yDrew8(String opponent, String score) {
    return '$score face à $opponent. C’est avec ce genre de nuls que les campagnes meurent en silence.';
  }

  @override
  String yDrew9(String opponent, String score) {
    return 'Deux points jetés face à $opponent. $score. Il n’y a pas d’autre mot.';
  }

  @override
  String yDrew10(String opponent, String score) {
    return '$opponent $score. Quatre-vingt-dix minutes et aucune idée de quoi en faire.';
  }

  @override
  String yDrew11(String opponent, String score) {
    return 'Un $score face à $opponent dont personne ne se souviendra et que tout le monde paiera.';
  }

  @override
  String yLost0(String opponent, String score) {
    return 'Battus $score par $opponent. Ça arrive.';
  }

  @override
  String yLost1(String opponent, String score) {
    return '$opponent $score. Pas de quoi pendre qui que ce soit. Au suivant.';
  }

  @override
  String yLost2(String opponent, String score) {
    return 'Défaite $score face à $opponent, en ayant tout donné. Certains jours, ça ne suffit pas.';
  }

  @override
  String yLost3(String opponent, String score) {
    return '$score face à $opponent. Têtes hautes. Cette équipe a encore de la ressource.';
  }

  @override
  String yLost4(String opponent, String score) {
    return '$opponent $score. On a été dominés, rien à redire.';
  }

  @override
  String yLost5(String opponent, String score) {
    return 'Défaite $score face à $opponent. On se remobilise.';
  }

  @override
  String yLost6(String opponent, String score) {
    return '$score face à $opponent. Pas une honte, pas assez bien non plus.';
  }

  @override
  String yLost7(String opponent, String score) {
    return 'Battus $score par $opponent. Il faut en tirer une leçon, sinon c’était pour rien.';
  }

  @override
  String yLost8(String opponent, String score) {
    return '$score face à $opponent, et on ne les a même pas inquiétés.';
  }

  @override
  String yLost9(String opponent, String score) {
    return 'Défaite face à $opponent, $score. Mêmes problèmes, même mois, les mêmes excuses arrivent.';
  }

  @override
  String yLost10(String opponent, String score) {
    return '$opponent $score. À partir de quand ça cesse d’être de la malchance ?';
  }

  @override
  String yLost11(String opponent, String score) {
    return 'Battus $score par $opponent. Un résultat comme ça devrait coûter quelque chose à quelqu’un.';
  }

  @override
  String yLostBadly0(String opponent, String score) {
    return '$score face à $opponent. Une mauvaise soirée. Jugez l’équipe sur la campagne, pas sur ça.';
  }

  @override
  String yLostBadly1(String opponent, String score) {
    return 'Personne ne voulait moins de ce $score face à $opponent que les joueurs eux-mêmes.';
  }

  @override
  String yLostBadly2(String opponent, String score) {
    return '$opponent $score. Moche, et ce n’est pas le vrai visage de cette équipe.';
  }

  @override
  String yLostBadly3(String opponent, String score) {
    return 'Un $score à oublier face à $opponent. Ils répondront présent la prochaine fois.';
  }

  @override
  String yLostBadly4(String opponent, String score) {
    return '$score. Face à $opponent. Je n’ai pas de mots, et on me paie pour en avoir.';
  }

  @override
  String yLostBadly5(String opponent, String score) {
    return '$opponent $score. Quelqu’un va devoir rendre des comptes.';
  }

  @override
  String yLostBadly6(String opponent, String score) {
    return 'Je veux que le $score face à $opponent soit rayé des archives et des mémoires.';
  }

  @override
  String yLostBadly7(String opponent, String score) {
    return 'Battus $score par $opponent. Impossible d’enjoliver un score pareil.';
  }

  @override
  String yLostBadly8(String opponent, String score) {
    return 'Ce n’était pas une défaite face à $opponent, c’était une capitulation. $score.';
  }

  @override
  String yLostBadly9(String opponent, String score) {
    return '$score. Face à $opponent. Des gens ont payé pour voir ça.';
  }

  @override
  String yLostBadly10(String opponent, String score) {
    return '$opponent $score. Si ça ne change rien, rien ne changera jamais.';
  }

  @override
  String yLostBadly11(String opponent, String score) {
    return 'J’ai déjà vu cette équipe humiliée, mais $score face à $opponent, c’est un nouveau plancher.';
  }

  @override
  String yTrophy0(String opponent) {
    return 'CHAMPIONS. $opponent. Dites-le à voix haute.';
  }

  @override
  String yTrophy1(String opponent) {
    return 'On l’a gagné. $opponent. Je ne m’en remets pas.';
  }

  @override
  String yTrophy2(String opponent) {
    return '$opponent, et le trophée rentre à la maison.';
  }

  @override
  String yTrophy3(String opponent) {
    return 'Chacun d’entre eux est une légende. $opponent.';
  }

  @override
  String yRunnerUp0(String opponent) {
    return 'Si près. $opponent, et une médaille dont personne ne veut.';
  }

  @override
  String yRunnerUp1(String opponent) {
    return 'Finalistes malheureux : $opponent. Ça va piquer pendant des années.';
  }

  @override
  String yRunnerUp2(String opponent) {
    return '$opponent : à un match de tout.';
  }

  @override
  String yRunnerUp3(String opponent) {
    return 'Deuxièmes. $opponent. Passez-moi la bouteille.';
  }

  @override
  String yEliminated0(String opponent) {
    return 'Éliminés : $opponent. Celle-là va faire mal un moment.';
  }

  @override
  String yEliminated1(String opponent) {
    return '$opponent : c’est là que ça s’arrête pour nous.';
  }

  @override
  String yEliminated2(String opponent) {
    return 'Éliminés : $opponent. Place au procès.';
  }

  @override
  String yEliminated3(String opponent) {
    return 'Sortis : $opponent. Que quelqu’un m’explique.';
  }

  @override
  String yQualified0(String opponent) {
    return 'ON Y VA : $opponent !';
  }

  @override
  String yQualified1(String opponent) {
    return 'Qualifiés : $opponent. Posez vos congés.';
  }

  @override
  String yQualified2(String opponent) {
    return '$opponent, nous voilà. Jamais de doute (il y avait énormément de doute).';
  }

  @override
  String yQualified3(String opponent) {
    return 'Qualifiés : $opponent. Le plus dur est fait.';
  }

  @override
  String yGroupDrawn0(String opponent) {
    return 'Groupes tirés : $opponent. Ça aurait pu être pire. Beaucoup pire.';
  }

  @override
  String yGroupDrawn1(String opponent) {
    return 'Donc voilà le tirage : $opponent. Intéressant.';
  }

  @override
  String yGroupDrawn2(String opponent) {
    return 'Les groupes sont tombés : $opponent. Je n’aime déjà pas le nôtre.';
  }

  @override
  String yGroupDrawn3(String opponent) {
    return 'Tirage effectué : $opponent. Que les réactions excessives commencent.';
  }

  @override
  String yHostNamed0(String opponent) {
    return '$opponent organisera. Commencez à économiser.';
  }

  @override
  String yHostNamed1(String opponent) {
    return 'Ce sera $opponent. Prévisible, mais d’accord.';
  }

  @override
  String yHostNamed2(String opponent) {
    return '$opponent obtient le tournoi. Félicitations, j’imagine.';
  }

  @override
  String yHostNamed3(String opponent) {
    return 'Pays hôte confirmé : $opponent.';
  }

  @override
  String yTournamentSoon0(String opponent) {
    return '$opponent commence bientôt et je ne tiens plus en place.';
  }

  @override
  String yTournamentSoon1(String opponent) {
    return 'Plus très longtemps avant : $opponent.';
  }

  @override
  String yTournamentSoon2(String opponent) {
    return '$opponent arrive. La liste, s’il vous plaît.';
  }

  @override
  String yTournamentSoon3(String opponent) {
    return 'Le compte à rebours avant $opponent est officiellement insupportable.';
  }

  @override
  String get navY => 'Y';

  @override
  String get yTitle => 'Y';

  @override
  String get yEmpty => 'Rien à dire pour l’instant. Jouez un match.';

  @override
  String get yEarlierHeading => 'Plus tôt dans ce cycle';

  @override
  String get yTraitLoyalist =>
      'Soutient l’équipe quoi qu’il arrive. Lent à se retourner, prompt à pardonner.';

  @override
  String get yTraitCynic => 'Imagine toujours le pire et adore avoir raison.';

  @override
  String get yTraitNostalgic =>
      'Tout était mieux avant. Vous compare à des joueurs retraités depuis longtemps.';

  @override
  String get yTraitStatshead =>
      'Poste les chiffres et rien d’autre. N’a presque pas d’humeur.';

  @override
  String get yTraitHypeman =>
      'Deux bons résultats et c’est une génération dorée.';

  @override
  String get yTraitContrarian =>
      'Quoi que pense la foule, il pense le contraire.';

  @override
  String get yTraitDoomer => 'Ça va mal finir. Ça finit toujours mal.';

  @override
  String get yProfilePosts => 'POSTS';

  @override
  String get yProfileEmpty => 'Rien de ce compte pour l’instant.';

  @override
  String hubEventGrievance(String player) {
    return '$player veut vous parler';
  }

  @override
  String get hubEventGrievanceSub => 'Il veut savoir où il en est';

  @override
  String hubEventManagerSkills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count points de compétence à dépenser',
      one: '1 point de compétence à dépenser',
    );
    return '$_temp0';
  }

  @override
  String get hubEventManagerSkillsSub =>
      'Vos points forts rendent votre équipe meilleure';

  @override
  String get grievanceTitle => 'Un mot dans votre bureau';

  @override
  String grievanceGameTime(String player) {
    return '$player est dans le groupe mais n’a pas touché un ballon. Il veut savoir pourquoi.';
  }

  @override
  String grievanceSquadPlace(String player) {
    return '$player n’est pas dans la liste et ne comprend pas. Il veut une réponse claire, dans un sens ou dans l’autre.';
  }

  @override
  String grievanceRole(String player) {
    return '$player est sans cesse aligné hors de son poste et en a assez.';
  }

  @override
  String get grievanceReassure => 'Tu fais partie de mes plans';

  @override
  String get grievanceHonest => 'D’autres sont devant toi, et voici pourquoi';

  @override
  String get grievanceDismiss => 'C’est moi qui fais l’équipe';

  @override
  String yScorerStar0(String name, String goals) {
    return '$name en a mis $goals. Personne n’approche.';
  }

  @override
  String yScorerStar1(String name, String goals) {
    return '$goals pour $name. Il porte cette équipe.';
  }

  @override
  String yScorerStar2(String name, String goals) {
    return '$name : $goals aujourd’hui. Quel joueur.';
  }

  @override
  String yScorerStar3(String name, String goals) {
    return '$goals buts pour $name. Chapeau bas.';
  }

  @override
  String yScorerStar4(String name, String goals) {
    return '$goals pour $name, et les autres étaient des passagers.';
  }

  @override
  String yScorerStar5(String name, String goals) {
    return 'Encore $name. $goals. Imaginez cette équipe sans lui.';
  }

  @override
  String yScorerStar6(String name, String goals) {
    return '$goals de $name. Un seul homme ne devrait pas avoir à en faire autant.';
  }

  @override
  String yScorerStar7(String name, String goals) {
    return 'Sans $name, c’est $goals buts de moins et un tout autre après-midi.';
  }

  @override
  String yWinStreak0(String count) {
    return '$count d’affilée. Quoi qu’il se dise dans ce vestiaire, ça passe.';
  }

  @override
  String yWinStreak1(String count) {
    return 'Ça fait $count de suite. On ne tombe pas par hasard sur une série pareille.';
  }

  @override
  String yWinStreak2(String count) {
    return '$count d’affilée et ça continue. La confiance se voit depuis les tribunes.';
  }

  @override
  String yWinStreak3(String count) {
    return 'Invaincus depuis $count matchs. Demandez à n’importe quel entraîneur : c’est le plus dur.';
  }

  @override
  String yWinStreak4(String count) {
    return '$count d’affilée. Profitez-en tant que le calendrier est clément.';
  }

  @override
  String yWinStreak5(String count) {
    return '$count de suite, et on n’a battu personne qui compte.';
  }

  @override
  String yWinStreak6(String count) {
    return 'Une série de $count. Reparlons-en quand elle sera mise à l’épreuve.';
  }

  @override
  String yWinStreak7(String count) {
    return '$count à la suite. Chaque équipe a une série comme ça en elle, une fois.';
  }

  @override
  String yLossStreak0(String count) {
    return '$count matchs sans victoire. À un moment, les excuses s’épuisent.';
  }

  @override
  String yLossStreak1(String count) {
    return 'Ça fait $count de suite. Ce n’est plus un accident de parcours.';
  }

  @override
  String yLossStreak2(String count) {
    return '$count défaites d’affilée. Quelqu’un doit rendre des comptes.';
  }

  @override
  String yLossStreak3(String count) {
    return 'Aucune victoire en $count matchs. Ça se voit dans leur jeu.';
  }

  @override
  String yLossStreak4(String count) {
    return '$count matchs sans victoire et les mêmes erreurs chaque semaine.';
  }

  @override
  String yLossStreak5(String count) {
    return '$count d’affilée. Quoi qu’on essaie, ça ne marche pas.';
  }

  @override
  String yLossStreak6(String count) {
    return '$count de suite. C’est une tendance, pas un creux.';
  }

  @override
  String yLossStreak7(String count) {
    return 'Aucune victoire en $count matchs, et personne là-haut n’a dit un mot.';
  }

  @override
  String yRivalry0(String opponent, String score) {
    return '$opponent $score. Pensez ce que vous voulez du jeu. Celui-là compte double.';
  }

  @override
  String yRivalry1(String opponent, String score) {
    return 'Face à $opponent, entre tous. $score. Personne ici ne l’oubliera.';
  }

  @override
  String yRivalry2(String opponent, String score) {
    return '$score face à $opponent. C’est de celui-là qu’on parlera au café.';
  }

  @override
  String yRivalry3(String opponent, String score) {
    return 'Le derby, $score. La suprématie locale est réglée pour un moment.';
  }

  @override
  String yRivalry4(String opponent, String score) {
    return '$opponent $score. Quoi qu’il arrive cette année, on aura eu ça.';
  }

  @override
  String yRivalry5(String opponent, String score) {
    return '$score face à $opponent. Certains d’entre nous en avaient plus besoin que le classement.';
  }

  @override
  String yRivalry6(String opponent, String score) {
    return '$opponent $score. Et ils prendront leur revanche la prochaine fois, comme toujours.';
  }

  @override
  String yRivalry7(String opponent, String score) {
    return 'Face à $opponent, $score. Une année entière à se le faire rappeler.';
  }

  @override
  String yInjuryBlow0(String name) {
    return '$name sort blessé. C’est bien la dernière chose dont cette équipe avait besoin.';
  }

  @override
  String yInjuryBlow1(String name) {
    return 'Perdre $name, ça change tout.';
  }

  @override
  String yInjuryBlow2(String name) {
    return '$name boite. Retenez votre souffle.';
  }

  @override
  String yInjuryBlow3(String name) {
    return 'Pas de $name pendant un moment, donc. Quelqu’un doit se montrer.';
  }

  @override
  String yInjuryBlow4(String name) {
    return '$name forfait. Évidemment que c’est $name.';
  }

  @override
  String yInjuryBlow5(String name) {
    return 'Sans $name, cette équipe devient très ordinaire.';
  }

  @override
  String yInjuryBlow6(String name) {
    return '$name encore blessé. Quelqu’un devrait se demander pourquoi.';
  }

  @override
  String yInjuryBlow7(String name) {
    return '$name perdu, et personne derrière lui. Voilà le vrai problème.';
  }

  @override
  String ySentOff0(String name, String minute) {
    return 'Rouge pour $name à la ${minute}e minute et tout le pays lui tombe dessus. Il nous a donné plus que la plupart. Laissez-le tranquille.';
  }

  @override
  String ySentOff1(String name, String minute) {
    return '$name expulsé après $minute minutes. Sévère. À dix, on a quand même tenté, et ça en dit long.';
  }

  @override
  String ySentOff2(String name, String minute) {
    return '$name, ${minute}e minute, carton rouge. À dix à partir de là.';
  }

  @override
  String ySentOff3(String name, String minute) {
    return 'Expulsion : $name à la ${minute}e. Pas le premier match à basculer sur une décision.';
  }

  @override
  String ySentOff4(String name, String minute) {
    return 'Génial. $name sort à la ${minute}e et on se retrouve à dix. Encore.';
  }

  @override
  String ySentOff5(String name, String minute) {
    return '$name expulsé après $minute minutes. Qui s’occupe de la discipline ici, au juste ?';
  }

  @override
  String ySentOff6(String name, String minute) {
    return '$minute minutes. C’est le temps que $name a gardé la tête froide. Le football professionnel.';
  }

  @override
  String ySentOff7(String name, String minute) {
    return 'Un rouge pour $name à la ${minute}e, et on voudrait me faire croire que c’est un progrès.';
  }

  @override
  String get yBoardPressure0 =>
      'La direction est devenue très silencieuse. Jamais bon signe.';

  @override
  String get yBoardPressure1 =>
      'Il paraît que la direction commence à poser des questions.';

  @override
  String get yBoardPressure2 => 'On sent que ça bouge là-haut.';

  @override
  String get yBoardPressure3 =>
      'Personne à la fédération ne dit quoi que ce soit de positif. Tirez-en vos conclusions.';

  @override
  String get yBoardPressure4 =>
      'Personne là-haut ne l’a soutenu publiquement depuis des semaines.';

  @override
  String get yBoardPressure5 =>
      'La fédération fait fuiter contre son propre sélectionneur. Comme toujours.';

  @override
  String get yBoardPressure6 =>
      'Quand une direction se tait, c’est qu’elle a déjà décidé.';

  @override
  String get yBoardPressure7 =>
      'Ils vont laisser filer jusqu’à ce que la décision revienne à quelqu’un d’autre.';

  @override
  String get yReplies => 'AUSSI SUR CE MATCH';

  @override
  String get yPlayerGrievance0 =>
      'J’ai demandé où j’en suis. J’attends toujours la réponse.';

  @override
  String get yPlayerGrievance1 =>
      'Je bosse dur à l’entraînement. Pas grand-chose d’autre à faire.';

  @override
  String get yPlayerGrievance2 =>
      'Certaines questions, on ne les pose qu’une fois.';

  @override
  String get yPlayerGrievance3 =>
      'Je ne suis pas venu jusqu’ici pour porter les chasubles.';

  @override
  String get playerHonoursTitle => 'PALMARÈS';

  @override
  String get awardGoldenBall => 'Ballon d’or';

  @override
  String get awardGoldenBoot => 'Soulier d’or';

  @override
  String get awardGoldenGlove => 'Gant d’or';

  @override
  String get awardTeamOfTournament => 'Équipe type du tournoi';

  @override
  String get awardPlayerOfYear => 'Joueur mondial de l’année';

  @override
  String get awardYoungPlayerOfYear => 'Meilleur jeune de l’année';

  @override
  String get playerClubHistory => 'PARCOURS EN CLUB';

  @override
  String get playerCareerRecord => 'BILAN DE CARRIÈRE';

  @override
  String get playerInternationalGoals => 'Buts internationaux';

  @override
  String get playerRecentForm => 'FORME RÉCENTE';

  @override
  String get playerMatchHistory => 'HISTORIQUE DES MATCHS';

  @override
  String get playerAttributes => 'ATTRIBUTS';

  @override
  String get playerUnknown => 'Inconnu';

  @override
  String get playerAttrPace => 'Vitesse';

  @override
  String get playerAttrPhysical => 'Physique';

  @override
  String get playerAttrTechnical => 'Technique';

  @override
  String get playerAttrShooting => 'Tir';

  @override
  String get playerAttrPassing => 'Passe';

  @override
  String get playerAttrDribbling => 'Dribble';

  @override
  String get playerAttrTackling => 'Tacle';

  @override
  String get playerAttrPositioning => 'Placement';

  @override
  String get playerAttrComposure => 'Sang-froid';

  @override
  String get playerAttrDecisions => 'Décisions';

  @override
  String get playerAttrStamina => 'Endurance';

  @override
  String get playerAttrStrength => 'Force';

  @override
  String get playerStatCaps => 'Sélections';

  @override
  String get playerStatGoals => 'Buts';

  @override
  String get playerStatAssists => 'Passes déc.';

  @override
  String get playerStatAvgRating => 'Note moyenne';

  @override
  String get playerStatForm => 'Forme';

  @override
  String get playerStatMotm => 'Homme du match';

  @override
  String get playerStatCleanSheets => 'Clean sheets';

  @override
  String get playerStatBestGame => 'Meilleur match';

  @override
  String get playerStatCards => 'Cartons';

  @override
  String playerCardsValue(int yellows, int reds) {
    return '${yellows}J ${reds}R';
  }

  @override
  String get tourSharedYourRun => 'VOTRE PARCOURS';

  @override
  String get tourSharedList => 'Liste';

  @override
  String get tourSharedBracket => 'Tableau';

  @override
  String get tourSharedVs => 'vs';

  @override
  String tourSharedGroupSeed(String seed) {
    return 'Groupe $seed';
  }

  @override
  String get tourSharedThisEdition => 'Cette édition';

  @override
  String get tourSharedAllTime => 'Historique';

  @override
  String get tourSharedUnknown => 'Inconnu';

  @override
  String get tourSharedActive => 'EN ACTIVITÉ';

  @override
  String get tourSharedMedalTable => 'TABLEAU DES MÉDAILLES';

  @override
  String get tourSharedPastWinners => 'PALMARÈS';

  @override
  String tourSharedHost(String host) {
    return 'Hôte : $host';
  }

  @override
  String get tourSharedBeat => 'bat';

  @override
  String get tourSharedPens => ' (t.a.b.)';

  @override
  String get tourSharedAwardsEmpty =>
      'Les récompenses sont attribuées une fois le tournoi terminé.';

  @override
  String get tourSharedGoldenBall => 'BALLON D’OR';

  @override
  String get tourSharedPlayerOfTournament => 'Joueur du tournoi';

  @override
  String get tourSharedGoldenBoot => 'SOULIER D’OR';

  @override
  String tourSharedGoalsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count buts',
      one: '$count but',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedGoldenGlove => 'GANT D’OR';

  @override
  String get tourSharedTeamOfTournament => 'ÉQUIPE TYPE DU TOURNOI';

  @override
  String get tourSharedStatsEmpty =>
      'Les records apparaîtront quand la compétition aura un peu d’histoire.';

  @override
  String get tourSharedRecordScorer => 'MEILLEUR BUTEUR DE L’HISTOIRE';

  @override
  String get tourSharedStillActive => 'toujours en activité';

  @override
  String get tourSharedMostTitles => 'PLUS DE TITRES';

  @override
  String tourSharedTitlesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count titres',
      one: '$count titre',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostFinals => 'PLUS DE FINALES';

  @override
  String tourSharedFinalsContested(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count finales disputées',
      one: '$count finale disputée',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostGamesPlayed => 'PLUS DE MATCHS JOUÉS';

  @override
  String tourSharedMatchesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count matchs',
      one: '$count match',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostFinalsPlayed => 'PLUS DE PHASES FINALES DISPUTÉES';

  @override
  String tourSharedFinalsTournamentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count phases finales',
      one: '$count phase finale',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedBiggestFinalWin => 'PLUS LARGE VICTOIRE EN FINALE';

  @override
  String tourStatsGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count buts',
      one: '1 but',
    );
    return '$_temp0';
  }

  @override
  String get tourStatsStillActive => 'toujours en activité';

  @override
  String tourStatsTitles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count titres',
      one: '1 titre',
    );
    return '$_temp0';
  }

  @override
  String tourStatsFinalsContested(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count finales disputées',
      one: '1 finale disputée',
    );
    return '$_temp0';
  }

  @override
  String tourStatsMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count matchs',
      one: '1 match',
    );
    return '$_temp0';
  }

  @override
  String tourStatsFinalsTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count phases finales',
      one: '1 phase finale',
    );
    return '$_temp0';
  }

  @override
  String get tourStatsLeaders => 'LEADERS DE L’HISTOIRE';

  @override
  String get tourStatsTabGames => 'Matchs';

  @override
  String get tourStatsTabCups => 'Tournois';

  @override
  String get tourStatsTabScorers => 'Buteurs';

  @override
  String tourSharedFinalWinDetail(String opponent, int year) {
    return 'contre $opponent · $year';
  }

  @override
  String get tourHolders => 'TENANTS DU TITRE';

  @override
  String tourHoldersSince(int year) {
    return 'vainqueur en $year';
  }

  @override
  String get tourSharedAllTimeScorers => 'MEILLEURS BUTEURS DE L’HISTOIRE';

  @override
  String get tourSharedSummaryEmpty =>
      'Le pays hôte et ses stades apparaîtront une fois le tirage de cette édition effectué.';

  @override
  String get tourSharedHostHeading => 'HÔTE';

  @override
  String get tourSharedHostsHeading => 'HÔTES';

  @override
  String get tourSharedCoHostsHeading => 'CO-ORGANISATEURS';

  @override
  String get tourSharedVenues => 'STADES';

  @override
  String get tourSharedMascot => 'MASCOTTE';

  @override
  String get tourSharedMatchBall => 'BALLON OFFICIEL';

  @override
  String tourSharedVenueSeats(String city, String capacity) {
    return '$city · $capacity places';
  }

  @override
  String get tourSharedCouldNotLoad => 'Chargement impossible.';

  @override
  String get tourSharedHostTbc => 'PAYS HÔTE À CONFIRMER';

  @override
  String get tourSharedFinalsAreHere => 'LA PHASE FINALE EST LÀ';

  @override
  String tourSharedHostedBy(String hosts) {
    return 'ORGANISÉ PAR  $hosts';
  }

  @override
  String get tourSharedLetFinalsBegin => 'Que la phase finale commence';

  @override
  String get tourSharedCompetitions => 'COMPÉTITIONS';

  @override
  String get tourSharedWorldRanking => 'Classement mondial';

  @override
  String get tourSharedCouldNotLoadTournaments =>
      'Impossible de charger les tournois.';

  @override
  String get tourSharedPrestigeStage => 'SCÈNE DE PRESTIGE';

  @override
  String get tourSharedOverview => 'Aperçu';

  @override
  String get tourSharedWorldRankingTitle => 'Classement mondial';

  @override
  String get tourSharedYourCompetitions => 'VOS COMPÉTITIONS';

  @override
  String get tourSharedOtherContinents => 'AUTRES CONTINENTS';

  @override
  String get tourSharedComingSoon => 'Tournoi à venir';

  @override
  String get tourSharedSoon => 'BIENTÔT';

  @override
  String get tourSharedNoQualifyingDraw => 'Pas de tirage des qualifications.';

  @override
  String get tourSharedOpenEnvelope => 'Ouvrir l’enveloppe';

  @override
  String tourSharedGroupName(String name) {
    return 'GROUPE $name';
  }

  @override
  String get tourSharedBall => 'Boule';

  @override
  String get tourSharedPot => 'Chapeau';

  @override
  String get tourSharedAll => 'Tout';

  @override
  String get tourSharedTapDrawTeam => 'Touchez pour tirer l’équipe suivante';

  @override
  String get tourSharedTapDrawPot => 'Touchez pour tirer le chapeau suivant';

  @override
  String get tourSharedTapDrawAll => 'Touchez pour révéler tout le tirage';

  @override
  String get tourSharedContinue => 'Continuer';

  @override
  String get tourSharedPause => 'Pause';

  @override
  String get tourSharedPlay => 'Lecture';

  @override
  String get tourSharedSkip => 'Passer';

  @override
  String tourSharedPotNumber(int number) {
    return 'CHAPEAU $number';
  }

  @override
  String get tourSharedDrawComplete => 'TIRAGE TERMINÉ';

  @override
  String get tourSharedDrawing => 'TIRAGE EN COURS…';

  @override
  String get tourContChampionship => 'CHAMPIONNAT';

  @override
  String get tourContTabSummary => 'RÉSUMÉ';

  @override
  String get tourContTabQualifying => 'QUALIFS';

  @override
  String get tourContTabFinals => 'PHASE FINALE';

  @override
  String get tourContTabBracket => 'TABLEAU';

  @override
  String get tourContTabAwards => 'TROPHÉES';

  @override
  String get tourContTabScorers => 'BUTEURS';

  @override
  String get tourContTabHistory => 'HISTORIQUE';

  @override
  String get tourContTabRecords => 'RECORDS';

  @override
  String tourContCouldNotLoadCup(String error) {
    return 'Impossible de charger la compétition.\n$error';
  }

  @override
  String get tourContNoCupData => 'Aucune donnée sur la compétition.';

  @override
  String get tourContUnknown => 'Inconnu';

  @override
  String get tourContGroupsToBeDrawnQual =>
      'Les groupes de qualification sont tirés lors de la cérémonie. Suivez-la depuis l’accueil pour découvrir vos adversaires.';

  @override
  String get tourContQualSeeded =>
      'Votre sélection est directement qualifiée pour la phase finale. Pas de qualifications ce cycle.';

  @override
  String tourContBackgroundRegion(String name) {
    return '$name est simulé en arrière-plan. Les résultats s’affichent ici à chaque journée.';
  }

  @override
  String get tourContGroupsToBeDrawnFinals =>
      'Les groupes de la phase finale sont tirés lors de la cérémonie. Suivez-la depuis l’accueil pour découvrir votre groupe.';

  @override
  String get tourContFinalsDrawAfterQual =>
      'Le tirage de la phase finale a lieu une fois les qualifications terminées.';

  @override
  String get tourContContestedBeforeWc =>
      'La phase à élimination directe se joue avant le Championnat du monde.';

  @override
  String tourContChampionsHeading(String name) {
    return '$name : CHAMPIONS';
  }

  @override
  String tourContWinnersTitle(String name) {
    return '$name : vainqueurs';
  }

  @override
  String get tourContNoGoalsYet => 'Aucun but marqué pour l’instant.';

  @override
  String tourContGroupHeading(String name) {
    return 'GROUPE $name';
  }

  @override
  String get tourContBestRunnersUp => 'MEILLEURS DEUXIÈMES';

  @override
  String tourContGroupDropdown(String name) {
    return 'Groupe $name';
  }

  @override
  String get tourContMatches => 'MATCHS';

  @override
  String get tourContNoGroupsDrawn => 'Aucun groupe tiré pour l’instant.';

  @override
  String get tourContQualifyingDraw => 'TIRAGE DES QUALIFICATIONS';

  @override
  String get tourContWorldQualifyingDraw =>
      'TIRAGE DES QUALIFICATIONS MONDIALES';

  @override
  String get tourContFinalsDraw => 'TIRAGE DE LA PHASE FINALE';

  @override
  String get tourContSeedingPots => 'CHAPEAUX';

  @override
  String get tourContGroupDraw => 'TIRAGE DES GROUPES';

  @override
  String tourContCouldNotLoadDraw(String error) {
    return 'Impossible de charger le tirage.\n$error';
  }

  @override
  String get tourContDrawNotReady => 'Le tirage n’est pas encore prêt.';

  @override
  String get tourContContinentalClash => 'CHOC DES CONTINENTS';

  @override
  String get tourContTabThisCycle => 'CE CYCLE';

  @override
  String tourContCouldNotLoadClash(String error) {
    return 'Chargement impossible.\n$error';
  }

  @override
  String get tourContNoSaveFound => 'Sauvegarde introuvable.';

  @override
  String get tourContClashSoon =>
      'Le Choc des continents se joue une fois les deux champions continentaux connus.';

  @override
  String get tourContTwoContinentsOneMatch => 'DEUX CONTINENTS, UN MATCH';

  @override
  String get tourContVersusShort => 'vs';

  @override
  String tourContWinTheClash(String name) {
    return '$name remporte le Choc';
  }

  @override
  String get tourContNoClashYet =>
      'Aucun Choc des continents disputé pour l’instant.';

  @override
  String get tourContNationsCup => 'COUPE DES NATIONS';

  @override
  String get tourContTabLeagues => 'LIGUES';

  @override
  String get tourContTabFinalsFour => 'FINAL FOUR';

  @override
  String tourContCouldNotLoad(String error) {
    return 'Chargement impossible.\n$error';
  }

  @override
  String get tourContNoNationsCupGoals =>
      'Aucun but en Coupe des Nations pour l’instant.';

  @override
  String get tourContNoNationsCupChampions =>
      'Aucun vainqueur de la Coupe des Nations pour l’instant.';

  @override
  String get tourContNationsCupOffSeason =>
      'La Coupe des Nations de ce cycle commence après les phases finales continentales. Les anciens vainqueurs sont dans Historique.';

  @override
  String get tourContNationsCupGroupsSoon =>
      'Les groupes de la Coupe des Nations de ce cycle sont tirés lors de la cérémonie. Suivez-la depuis l’accueil pour découvrir vos adversaires.';

  @override
  String get tourContLeagueNoGroups =>
      'Aucun match dans cette ligue lors de cette journée.';

  @override
  String tourContLeagueHeading(String letter) {
    return 'LIGUE $letter';
  }

  @override
  String tourContLeagueHeadingYours(String letter) {
    return 'LIGUE $letter · VOTRE LIGUE';
  }

  @override
  String get tourContFinalsFourSoon =>
      'Le Final Four réunit les vainqueurs de groupe de la Ligue A une fois la phase de groupes terminée.';

  @override
  String tourContLeagueChip(String letter) {
    return 'Ligue $letter';
  }

  @override
  String tourContLeagueChipStar(String letter) {
    return 'Ligue $letter ★';
  }

  @override
  String get tourContSemiFinals => 'DEMI-FINALES';

  @override
  String get tourContFinal => 'FINALE';

  @override
  String get tourContNationsCupDraw => 'TIRAGE DE LA COUPE DES NATIONS';

  @override
  String get tourContIntercontinentalPlayoff => 'BARRAGE INTERCONTINENTAL';

  @override
  String get tourContNoPlayoffThisCycle => 'Pas de barrage ce cycle.';

  @override
  String get tourContPlayoffIntro =>
      'Deux places au Championnat du monde attribuées via un tournoi à élimination directe entre les meilleurs non-qualifiés.';

  @override
  String get tourContPlayoffThrough =>
      'Vous avez passé le barrage. Vous êtes au Championnat du monde !';

  @override
  String get tourContPlayoffOut =>
      'Vous avez échoué en barrage. Pas de Championnat du monde cette fois.';

  @override
  String get tourContContinue => 'Continuer';

  @override
  String get tourContPlayoffFinals => 'FINALES DE BARRAGE';

  @override
  String get tourContPlayoffSeeded => 'Tête de série (exempt)';

  @override
  String get tourCupTabSummary => 'RÉSUMÉ';

  @override
  String get tourCupTabQualifying => 'QUALIFS';

  @override
  String get tourCupTabPlayoff => 'BARRAGE';

  @override
  String get tourCupPlayoffSoon =>
      'Le barrage intercontinental se décide une fois les qualifications de toutes les confédérations terminées.';

  @override
  String get tourCupTabFinals => 'PHASE FINALE';

  @override
  String get tourCupTabBracket => 'TABLEAU';

  @override
  String get tourCupTabAwards => 'TROPHÉES';

  @override
  String get tourCupTabScorers => 'BUTEURS';

  @override
  String get tourCupTabHistory => 'HISTORIQUE';

  @override
  String get tourCupTabRecords => 'RECORDS';

  @override
  String get tourCupTitle => 'CHAMPIONNAT DU MONDE';

  @override
  String get tourCupNoData => 'Aucune donnée sur la compétition.';

  @override
  String tourCupLoadError(String error) {
    return 'Impossible de charger la compétition.\n$error';
  }

  @override
  String get tourCupUnknown => 'Inconnu';

  @override
  String get tourCupWorldChampions => 'CHAMPIONS DU MONDE';

  @override
  String get tourCupWorldChampionsTitle => 'Champions du monde';

  @override
  String get tourCupStillActive => 'Toujours en activité';

  @override
  String get tourCupAllTimeScorers => 'MEILLEURS BUTEURS DE L’HISTOIRE';

  @override
  String get tourCupAllConfederations => 'Toutes les confédérations';

  @override
  String get tourCupBestRunnersUp => 'Meilleurs deuxièmes';

  @override
  String get tourCupCompWorld => 'Championnat du monde';

  @override
  String get tourCupCompEurope => 'Championnat d’Europe';

  @override
  String get tourCupCompSAmerica => 'Coupe d’Amérique du Sud';

  @override
  String get tourCupDestRoundOf16 => 'les huitièmes de finale';

  @override
  String get tourCupDestKnockouts => 'la phase à élimination directe';

  @override
  String get tourCupDestFinals => 'la phase finale';

  @override
  String get tourCupDestFinalsPlayoff => 'le barrage de la phase finale';

  @override
  String get tourCupDestIntercontPlayoff => 'le barrage intercontinental';

  @override
  String get tourCupFinalsDrawnAfterQual =>
      'Le tirage de la phase finale a lieu après les qualifications.';

  @override
  String get tourCupFinalsDrawSoon =>
      'Groupes pas encore tirés. Suivez le tirage du Championnat du monde depuis l’accueil pour les découvrir.';

  @override
  String tourCupGroupName(String name) {
    return 'Groupe $name';
  }

  @override
  String tourCupGroupNameShort(String name) {
    return 'Groupe $name';
  }

  @override
  String tourCupHostLabel(String host) {
    return 'Organisé par : $host';
  }

  @override
  String tourCupHostLabelMulti(String hosts) {
    return 'Organisé par : $hosts';
  }

  @override
  String get tourCupIntercontPlayoff => 'Barrage intercontinental';

  @override
  String get tourCupKnockoutSoon =>
      'Le tableau commence à la fin de la phase de groupes.';

  @override
  String get tourCupMatches => 'MATCHS';

  @override
  String get tourCupMedalTable => 'TABLEAU DES MÉDAILLES';

  @override
  String get tourCupMostTitles => 'PLUS DE TITRES';

  @override
  String tourCupMostTitlesValue(String nation, int titles, int editions) {
    return '$nation : $titles titres en $editions éditions';
  }

  @override
  String get tourCupNoGoals => 'Aucun but pour l’instant.';

  @override
  String get tourCupNoGroups => 'Aucun groupe tiré.';

  @override
  String get tourCupNoHistory => 'Pas encore d’historique.';

  @override
  String get tourCupPastWinners => 'PALMARÈS';

  @override
  String get tourCupPlayoffIntro =>
      'Deux places au Championnat du monde attribuées via un tournoi à élimination directe entre les meilleurs non-qualifiés.';

  @override
  String get tourCupQualDrawSoon =>
      'Groupes pas encore tirés. Suivez le tirage des qualifications depuis l’accueil pour les découvrir.';

  @override
  String tourCupRegionYours(String region) {
    return '$region · la vôtre';
  }

  @override
  String tourCupScorePens(int home, int away) {
    return '$home-$away (t.a.b.)';
  }

  @override
  String get tourCupSegAllTime => 'Historique';

  @override
  String get tourCupSegFinals => 'Phase finale';

  @override
  String get tourCupSegQualifying => 'Qualifications';

  @override
  String get playerTraitsTitle => 'RÉPUTÉ POUR';

  @override
  String get traitBigGame => 'Joueur des grands matchs';

  @override
  String get traitBigGameBlurb =>
      'Élève son niveau dans les matchs à élimination directe.';

  @override
  String get traitSetPiece => 'Spécialiste des CPA';

  @override
  String get traitSetPieceBlurb =>
      'Meilleurs centres et plus de buts sur coups de pied arrêtés.';

  @override
  String get traitHothead => 'Tête brûlée';

  @override
  String get traitHotheadBlurb =>
      'Prend bien plus de cartons que ses coéquipiers.';

  @override
  String get traitIronMan => 'Homme de fer';

  @override
  String get traitIronManBlurb => 'Rarement blessé et se fatigue moins vite.';

  @override
  String get traitWonderkid => 'Crack';

  @override
  String get traitWonderkidBlurb =>
      'Jeune, déjà bon, et progresse encore vite.';

  @override
  String get traitLeader => 'Leader';

  @override
  String get traitLeaderBlurb =>
      'Tire vers le haut tous ses coéquipiers sur le terrain.';

  @override
  String get traitPacey => 'Rapide';

  @override
  String get traitPaceyBlurb =>
      'Vitesse fulgurante, une menace dans le dos de la défense.';

  @override
  String get traitOldHead => 'Vieux briscard';

  @override
  String get traitOldHeadBlurb =>
      'Un vétéran dont la lecture du jeu survit à ses jambes.';

  @override
  String get traitWasteful => 'Maladroit';

  @override
  String get traitWastefulBlurb => 'Gâche trop de belles occasions.';

  @override
  String get objectiveWorldCup => 'Championnat du monde';

  @override
  String get objectiveWinTournament => 'Le gagner';

  @override
  String get objectiveQualifyGeneric => 'Se qualifier';

  @override
  String hubBoardObjectiveFor(String competition, String label) {
    return '$competition : $label';
  }

  @override
  String get objectiveWinWorldCup => 'Remporter le Championnat du monde';

  @override
  String get objectiveReachFinal => 'Atteindre la finale';

  @override
  String get objectiveReachSemis => 'Atteindre les demi-finales';

  @override
  String get objectiveReachQuarters => 'Atteindre les quarts de finale';

  @override
  String get objectiveReachKnockouts =>
      'Atteindre la phase à élimination directe';

  @override
  String get objectiveQualify => 'Se qualifier pour le Championnat du monde';

  @override
  String get finishChampions => 'Champions';

  @override
  String get finishRunnersUp => 'Finalistes';

  @override
  String get finishSemiFinals => 'Demi-finales';

  @override
  String get finishQuarterFinals => 'Quarts de finale';

  @override
  String get finishRoundOf16 => 'Huitièmes de finale';

  @override
  String get finishGroupStage => 'Phase de groupes';

  @override
  String get objectiveQualifyingTopHalf =>
      'Finir dans la première moitié des qualifications';

  @override
  String get finishQualifyingTopHalf =>
      'Première moitié du groupe de qualification';

  @override
  String get finishQualifyingBottomHalf =>
      'Seconde moitié du groupe de qualification';

  @override
  String get objectiveNcWinIt => 'Remporter la Coupe des Nations';

  @override
  String get objectiveNcReachFinal =>
      'Atteindre la finale de la Coupe des Nations';

  @override
  String get objectiveNcFinalsFour => 'Atteindre le Final Four';

  @override
  String get objectiveNcWinGroup => 'Gagner votre groupe et monter';

  @override
  String get objectiveNcTopHalf => 'Finir dans la première moitié du groupe';

  @override
  String get objectiveNcSurvive => 'Éviter la relégation';

  @override
  String get finishNcChampions => 'Vainqueurs de la Coupe des Nations';

  @override
  String get finishNcFinalsFour => 'Final Four';

  @override
  String get finishNcGroupWinners => 'Premiers du groupe';

  @override
  String get finishNcTopHalf => 'Première moitié du groupe';

  @override
  String get finishNcStayedUp => 'Maintien assuré';

  @override
  String get finishNcBottom => 'Dernier du groupe';

  @override
  String get careerNationsCupLabel => 'Coupe des Nations';

  @override
  String get squadDevPlayer => 'JOUEUR';

  @override
  String get squadDevAge => 'ÂGE';

  @override
  String get squadDevPosition => 'POSTE';

  @override
  String get squadDevChange => 'NOTE';

  @override
  String get squadDevNew => 'NOUVEAU';

  @override
  String get squadDevRetired => 'RETRAITÉ';

  @override
  String get squadDevEmpty =>
      'Une année stable. Aucun changement dans l’effectif.';

  @override
  String get squadDevTierRegulars => 'CADRES';

  @override
  String get squadDevTierFringe => 'REMPLAÇANTS';

  @override
  String get squadDevTierYouth => 'JEUNES';

  @override
  String get boardObjectivesTitle => 'Objectifs de la direction';

  @override
  String get boardObjectivesConfidence => 'Confiance de la direction';

  @override
  String boardObjectiveBeatenBy(String result, int rounds) {
    String _temp0 = intl.Intl.pluralLogic(
      rounds,
      locale: localeName,
      other: '$rounds tours de mieux que demandé',
      one: 'un tour de mieux que demandé',
    );
    return '$result : $_temp0';
  }

  @override
  String boardObjectiveShortBy(String result, int rounds) {
    String _temp0 = intl.Intl.pluralLogic(
      rounds,
      locale: localeName,
      other: 'à $rounds tours de l’objectif',
      one: 'à un tour de l’objectif',
    );
    return '$result : $_temp0';
  }

  @override
  String get boardObjectivesPending => 'ENCORE À DÉCIDER';

  @override
  String boardObjectiveSoFar(String result) {
    return 'POUR L’INSTANT · $result';
  }

  @override
  String get boardObjectivesEmpty =>
      'La direction n’a pas fixé d’objectif pour ce cycle.';

  @override
  String get tourContBestWinners => 'MEILLEURS PREMIERS DE GROUPE';

  @override
  String get tourContBestThirds => 'MEILLEURS TROISIÈMES';

  @override
  String tourContBestPlaced(String position) {
    return 'MEILLEURS ${position}ES';
  }

  @override
  String squadDevPageOf(String page, String pages, String total) {
    return '$page/$pages · $total joueurs';
  }

  @override
  String get matchSoldOut => 'COMPLET';

  @override
  String matchAttendanceOf(String attendance, String capacity) {
    return '$attendance places occupées sur $capacity';
  }

  @override
  String get matchGroundTitle => 'STADE';

  @override
  String get absenceInjured => 'Blessé';

  @override
  String get absenceSuspended => 'Suspendu';

  @override
  String absenceWeeks(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString semaines',
      one: '1 semaine',
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
      other: '$countString matchs',
      one: '1 match',
    );
    return '$_temp0';
  }

  @override
  String absenceBackFor(String opponent) {
    return 'De retour contre $opponent';
  }

  @override
  String get penaltyOrderTitle => 'Tirs au but';

  @override
  String get penaltyOrderBlurb =>
      'Désignez vos cinq tireurs, dans l’ordre. Touchez une case pour la modifier.';

  @override
  String penaltyOrderPick(int number) {
    return 'Tir $number';
  }

  @override
  String get penaltyOrderPickBlurb =>
      'Choisissez qui s’avance. La barre indique son sang-froid sur penalty.';

  @override
  String get penaltyOrderConfirm => 'C’est parti';

  @override
  String get penaltyOrderCancel => 'Retour';

  @override
  String get youthTitle => 'Jeunes';

  @override
  String get youthEmptyLevel => 'Personne à ce niveau pour l’instant.';

  @override
  String get youthReleased => 'Libérés cette année';

  @override
  String get u21Title => 'Espoirs';

  @override
  String get u21Blurb =>
      'La prochaine génération, meilleur espoir en tête. Les étoiles vides sont une estimation du recruteur. Sélectionnez un joueur pour découvrir ce qu’il vaut vraiment.';

  @override
  String get u21Empty =>
      'Personne de moins de 21 ans dans le vivier en ce moment. La prochaine promotion arrive avec le nouveau cycle.';

  @override
  String u21Breakout(int gain) {
    return '+$gain CETTE ANNÉE';
  }

  @override
  String u21AgeCaps(int age, int caps) {
    return '$age ans · $caps sél.';
  }

  @override
  String u21AgeUncapped(int age) {
    return '$age ans · jamais sélectionné';
  }

  @override
  String get u21CallUps => 'Aller aux convocations';

  @override
  String get youthWatching => 'Suivis';

  @override
  String get youthWatchEmpty =>
      'Personne de suivi pour l’instant. Suivez un jeune à n’importe quel niveau et il apparaîtra ici, avec ce qu’il est devenu depuis.';

  @override
  String get youthWatchMark => 'Suivre ce jeune';

  @override
  String get youthWatchUnmark => 'Ne plus le suivre';

  @override
  String youthWatchMarked(int rating, int age) {
    return 'Suivi à $rating, à $age ans';
  }

  @override
  String get youthWatchSenior => 'Passé chez les seniors';

  @override
  String get youthWatchReleased => 'Libéré par le centre de formation';

  @override
  String get youthWatchGone => 'Ne fait plus partie de la filière';

  @override
  String get tacticsYouth => 'Espoirs';

  @override
  String get pressSquad => 'Groupe';

  @override
  String get pressBoard => 'Direction';

  @override
  String get pressNoEffect => 'Personne n’y prête vraiment attention';

  @override
  String get matchNeutralGround => 'NEUTRE';

  @override
  String get matchExtraTimeAhead => 'PROLONGATION';

  @override
  String get matchExtraTimeHalf => 'PROLONGATION · MI-TEMPS';

  @override
  String get matchClockFullTime => 'FIN DU MATCH';

  @override
  String get matchClockAfterExtraTime => 'APRÈS PROLONGATION';

  @override
  String get matchClockPenalties => 'TIRS AU BUT';

  @override
  String get matchClockFullTimePenalties => 'FIN DU MATCH · TIRS AU BUT';

  @override
  String get hubEventPressConference => 'Face à la presse';

  @override
  String get hubEventPressConferenceSub =>
      'Les médias du monde entier veulent vous parler avant votre premier match';

  @override
  String get squadDevWonderkid => 'CRACK';

  @override
  String get tacticsPlaystyle => 'Style de jeu';

  @override
  String get tacticsPlaystyleBlurb =>
      'Choisissez comment l’équipe joue, les réglages ci-dessous l’affinent.';

  @override
  String get tacticsPlaystyleCustom =>
      'Vos propres réglages. Aucun style prédéfini ne correspond.';

  @override
  String get playstyleCustom => 'Personnalisé';

  @override
  String get playstyleBalanced => 'Équilibré';

  @override
  String get playstylePossession => 'Possession';

  @override
  String get playstyleGegenpress => 'Gegenpressing';

  @override
  String get playstyleCounter => 'Contre-attaque';

  @override
  String get playstyleDirect => 'Direct';

  @override
  String get playstyleLowBlock => 'Bloc bas';

  @override
  String get playstyleWingPlay => 'Jeu sur les ailes';

  @override
  String get playstyleBalancedBlurb =>
      'Solide dans les deux moitiés, sans excès.';

  @override
  String get playstylePossessionBlurb =>
      'Garder le ballon, le faire circuler patiemment, étouffer l’adversaire.';

  @override
  String get playstyleGegenpressBlurb =>
      'Le récupérer dès qu’il est perdu, haut sur le terrain.';

  @override
  String get playstyleCounterBlurb =>
      'Attendre, rester compact, puis partir vite en contre.';

  @override
  String get playstyleDirectBlurb =>
      'Jouer vers l’avant tôt et viser le second ballon.';

  @override
  String get playstyleLowBlockBlurb =>
      'Bas, resserré et très difficile à percer.';

  @override
  String get playstyleWingPlayBlurb =>
      'Étirer le terrain, déborder et centrer.';

  @override
  String get nationsRandomTeam => 'Équipe au hasard';

  @override
  String get nationsFromTheBottom => 'Partir d’en bas';

  @override
  String get bottomStartTitle => 'Sans emploi';

  @override
  String get bottomStartHeading => 'Trois fédérations veulent discuter';

  @override
  String get bottomStartBlurb =>
      'Vous n’avez ni poste ni réputation. Ce sont les seules sélections prêtes à tenter le coup avec vous. Choisissez-en une et bâtissez à partir de rien.';

  @override
  String get bottomStartAccept => 'Accepter';

  @override
  String get bottomStartBack => 'Retour au menu';

  @override
  String bottomStartRankOf(int rank, int total) {
    return '${rank}e mondial sur $total';
  }

  @override
  String get campTitle => 'Camp de base';

  @override
  String campBasedIn(String host) {
    return 'Basé : $host';
  }

  @override
  String get campBlurb =>
      'Là où le groupe vit pendant tout le tournoi. Impossible d’en changer une fois la compétition lancée, et il joue sur trois choses à chaque match : la fraîcheur à l’arrivée, la vitesse de récupération des pépins et le niveau de forme.';

  @override
  String get campEffectTravel => 'Fraîcheur';

  @override
  String get campEffectRecovery => 'Récupération';

  @override
  String get campEffectSharpness => 'Rythme de match';

  @override
  String get campTerrainCity => 'Centre-ville';

  @override
  String get campTerrainCoastal => 'Station balnéaire';

  @override
  String get campTerrainMountain => 'Retraite en montagne';

  @override
  String get campTerrainAltitude => 'Camp en altitude';

  @override
  String get campTerrainNationalCentre => 'Centre national';

  @override
  String get campTerrainCityBlurb =>
      'Tout à portée de main et aucun trajet, mais pas de calme et aucun moyen d’échapper au bruit.';

  @override
  String get campTerrainCoastalBlurb =>
      'Calme, confortable et bon pour le moral, mais un long trajet en car vers chaque stade.';

  @override
  String get campTerrainMountainBlurb =>
      'Air frais et service médical de premier ordre qui soigne vite les pépins, loin du tournoi.';

  @override
  String get campTerrainAltitudeBlurb =>
      'Dur pour s’entraîner, mais des jambes qui tiennent loin dans le tournoi.';

  @override
  String get campTerrainNationalCentreBlurb =>
      'Les installations de la fédération : rien de spectaculaire, rien qui puisse mal tourner.';

  @override
  String get hubEventChooseCamp => 'Choisir le camp de base';

  @override
  String hubEventChooseCampSub(String host) {
    return 'Où le groupe sera basé. Pays hôte : $host';
  }

  @override
  String get tacticsTabBench => 'Banc';

  @override
  String get squadSearchHint => 'Chercher par nom ou club';

  @override
  String get squadFilterAll => 'Tous';

  @override
  String get squadFilterInSquad => 'Dans la liste';

  @override
  String get squadFilterUncapped => 'Jamais sélectionnés';

  @override
  String get squadFilterUnavailable => 'Indisponibles';

  @override
  String get squadLineAll => 'Toutes les lignes';

  @override
  String get squadSortBy => 'Trier';

  @override
  String get squadSortRating => 'Note';

  @override
  String get squadSortCaps => 'Sélections';

  @override
  String get squadSortGoals => 'Buts';

  @override
  String get squadSortAge => 'Âge';

  @override
  String get squadSortName => 'Nom';

  @override
  String get squadLegendTitle => 'Signification des symboles';

  @override
  String get squadLegendStarting => 'Dans votre onze de départ';

  @override
  String get squadLegendCalledUp => 'Convoqué, sur le banc';

  @override
  String get squadLegendRatingUp => 'Note en hausse cette année';

  @override
  String get squadLegendRatingDown => 'Note en baisse cette année';

  @override
  String get squadLegendInjured => 'Blessé, indisponible';

  @override
  String get squadLegendSuspended => 'Suspendu, indisponible';

  @override
  String get squadLegendTraits => 'RÉPUTÉ POUR';

  @override
  String squadShowingOf(int shown, int total) {
    return '$shown joueurs affichés sur $total';
  }

  @override
  String get squadNobodyMatches =>
      'Personne dans le vivier ne correspond à ces filtres.';

  @override
  String get squadStatPool => 'Vivier';

  @override
  String get squadStatInSquad => 'Convoqués';

  @override
  String get squadMostCapped => 'Le plus capé';

  @override
  String get squadTopScorer => 'Meilleur buteur';

  @override
  String squadCapsValue(String name, int caps) {
    return '$name · $caps sél.';
  }

  @override
  String squadGoalsValue(String name, int goals) {
    return '$name · $goals buts';
  }

  @override
  String squadAgeClub(int age, String club) {
    return '$age · $club';
  }

  @override
  String get squadCapsShort => 'Sél.';

  @override
  String get squadGoalsShort => 'Buts';

  @override
  String get recordsRecordBookSubtitle =>
      'Sélections, buts et grands records de l’équipe';

  @override
  String get statsLegacy => 'HÉRITAGE';

  @override
  String tacticsSubAlreadyOff(String name) {
    return '$name est déjà sorti et ne peut pas revenir.';
  }

  @override
  String tacticsSubSentOff(String name) {
    return '$name a été expulsé et ne participe plus au match.';
  }

  @override
  String get tacticsInjuredShort => 'BLESSÉ';

  @override
  String get tacticsSuspendedShort => 'SUSPENDU';

  @override
  String get confEurope => 'Europe';

  @override
  String get confSouthAmerica => 'Amérique du Sud';

  @override
  String get confNorthAmerica => 'Amérique du Nord';

  @override
  String get confAfrica => 'Afrique';

  @override
  String get confAsia => 'Asie';

  @override
  String get confOceania => 'Océanie';

  @override
  String get compWorldCup => 'Championnat du monde';

  @override
  String get compWorldCupFinals => 'Phase finale du Championnat du monde';

  @override
  String get compWorldCupQualifying => 'Qualifications du Championnat du monde';

  @override
  String compQualifiers(String region) {
    return 'Qualifications $region';
  }

  @override
  String get compFriendlies => 'Amicaux';

  @override
  String get compNationsCup => 'Coupe des Nations';

  @override
  String get compContinentalClash => 'Choc des continents';

  @override
  String get compIntercontinentalPlayoff => 'Barrage intercontinental';

  @override
  String get compContinentalChampionship => 'Championnat continental';

  @override
  String get compEuropeanChampionship => 'Championnat d’Europe';

  @override
  String get compSouthAmericaCup => 'Coupe d’Amérique du Sud';

  @override
  String get compAfricanChampionship => 'Championnat d’Afrique';

  @override
  String get compAsianChampionship => 'Championnat d’Asie';

  @override
  String get compNorthAmericaCup => 'Coupe d’Amérique du Nord';

  @override
  String get compOceaniaCup => 'Coupe d’Océanie';

  @override
  String get msgANation => 'Une nation';

  @override
  String get msgAPlayer => 'Un joueur';

  @override
  String get msgAHostNation => 'un pays hôte';

  @override
  String get msgCycleTitle1 => 'Un nouveau cycle commence';

  @override
  String msgCycleTitle2(int year) {
    return 'La route vers $year s’ouvre';
  }

  @override
  String get msgCycleTitle3 => 'Une nouvelle campagne commence';

  @override
  String get msgCycleTitle4 => 'Au travail';

  @override
  String msgCycleBody1(int year) {
    return 'La route vers le Championnat du monde $year commence ici.';
  }

  @override
  String msgCycleBody2(int year) {
    return 'Un nouveau cycle. L’objectif : le Championnat du monde $year.';
  }

  @override
  String msgCycleBody3(int year) {
    return 'Quatre ans avant le Championnat du monde $year. Le travail commence maintenant.';
  }

  @override
  String msgCycleBody4(int year) {
    return 'La campagne $year commence aujourd’hui.';
  }

  @override
  String msgContHostTitle(String cup, String host) {
    return '$cup, pays hôte : $host';
  }

  @override
  String msgContHostBody(String host, String cup) {
    return 'Prochaine édition, $cup : organisée par $host.';
  }

  @override
  String msgContQualDrawTitle(String cup) {
    return '$cup : tirage des qualifications';
  }

  @override
  String msgContQualDrawBody(String cup) {
    return '$cup : les groupes de qualification ont été tirés.';
  }

  @override
  String msgWcHostTitle(String host, int year) {
    return 'Championnat du monde $year, pays hôte : $host';
  }

  @override
  String msgWcHostBody(String host, int year) {
    return 'Le Championnat du monde $year sera organisé par $host.';
  }

  @override
  String get msgWcQualDrawTitle =>
      'Tirage des qualifications du Championnat du monde';

  @override
  String get msgWcQualDrawBody =>
      'Les groupes de qualification du Championnat du monde ont été tirés.';

  @override
  String msgContFinalsDrawTitle(String cup) {
    return '$cup : tirage de la phase finale';
  }

  @override
  String msgContFinalsDrawBody(String cup) {
    return '$cup : les groupes de la phase finale ont été tirés.';
  }

  @override
  String get msgWcFinalsDrawTitle =>
      'Tirage de la phase finale du Championnat du monde';

  @override
  String msgWcFinalsDrawBody(int year) {
    return 'Le tirage de la phase finale du Championnat du monde $year a été effectué.';
  }

  @override
  String get msgQualWcTitle1 => 'Qualifiés pour le Championnat du monde';

  @override
  String get msgQualWcTitle2 => 'Championnat du monde en poche';

  @override
  String get msgQualWcTitle3 => 'On va au Championnat du monde';

  @override
  String get msgQualWcTitle4 => 'Billet composté';

  @override
  String msgQualWcBody1(int year) {
    return 'Vous êtes qualifiés pour la phase finale du Championnat du monde $year.';
  }

  @override
  String msgQualWcBody2(int year) {
    return 'C’est officiel : votre sélection sera au Championnat du monde $year.';
  }

  @override
  String msgQualWcBody3(int year) {
    return 'Une place au Championnat du monde $year est assurée.';
  }

  @override
  String msgQualWcBody4(int year) {
    return 'Vous êtes qualifiés pour la phase finale du Championnat du monde $year.';
  }

  @override
  String msgQualContTitle1(String cup) {
    return 'Qualifiés : $cup';
  }

  @override
  String msgQualContTitle2(String cup) {
    return '$cup : en poche';
  }

  @override
  String msgQualContTitle3(String cup) {
    return 'Qualifiés pour : $cup';
  }

  @override
  String msgQualContBody1(String cup) {
    return '$cup : vous êtes qualifiés pour la phase finale.';
  }

  @override
  String msgQualContBody2(String cup) {
    return '$cup : votre sélection a validé son billet.';
  }

  @override
  String msgQualContBody3(String cup) {
    return 'Vous êtes qualifiés : $cup.';
  }

  @override
  String msgChampTitleMine1(String comp) {
    return '$comp : CHAMPIONS !';
  }

  @override
  String msgChampTitleMine2(String comp) {
    return 'Vainqueurs : $comp !';
  }

  @override
  String msgChampTitleMine3(String comp) {
    return 'Vous avez gagné : $comp !';
  }

  @override
  String msgChampTitleOther1(String comp) {
    return '$comp : c’est joué';
  }

  @override
  String msgChampTitleOther2(String comp) {
    return '$comp : le champion est sacré';
  }

  @override
  String msgChampTitleOther3(String comp) {
    return '$comp : le titre est attribué';
  }

  @override
  String msgChampBodyMine1(String comp, String loser, String result, int year) {
    return '$comp $year : votre sélection est championne, victoire contre $loser$result.';
  }

  @override
  String msgChampBodyMine2(String comp, String loser, String result, int year) {
    return '$comp $year : vous l’avez remporté en écartant $loser$result.';
  }

  @override
  String msgChampBodyMine3(String comp, String loser, String result, int year) {
    return '$comp $year : le titre est à vous. $loser battu$result.';
  }

  @override
  String msgChampBodyOther1(
    String winner,
    String comp,
    String loser,
    String result,
    int year,
  ) {
    return '$comp $year : victoire de $winner contre $loser$result.';
  }

  @override
  String msgChampBodyOther2(
    String winner,
    String comp,
    String loser,
    String result,
    int year,
  ) {
    return '$comp $year : $winner est champion après avoir battu $loser$result.';
  }

  @override
  String msgFinalScoreSuffix(int home, int away) {
    return ' $home-$away en finale';
  }

  @override
  String msgFinalPensSuffix(int home, int away) {
    return ' aux tirs au but, après une finale à $home-$away';
  }

  @override
  String get msgWpotyTitle => 'Joueur mondial de l’année';

  @override
  String msgWpotyBodyMine(String name, String nation, int year) {
    return '$name ($nation) est élu joueur mondial de l’année $year. C’est l’un des vôtres.';
  }

  @override
  String msgWpotyBodyOther(String name, String nation, int year) {
    return '$name ($nation) est élu joueur mondial de l’année $year.';
  }

  @override
  String get msgYpotTitle => 'Meilleur jeune du tournoi';

  @override
  String msgYpotBodyMine(String name, String nation, int age, int year) {
    return '$name ($nation), $age ans, est élu meilleur jeune du tournoi $year. C’est l’un des vôtres.';
  }

  @override
  String msgYpotBodyOther(String name, String nation, int age, int year) {
    return '$name ($nation), $age ans, est élu meilleur jeune du tournoi $year.';
  }

  @override
  String msgRankHold1(int rank) {
    return 'Vous restez #$rank.';
  }

  @override
  String msgRankHold2(int rank) {
    return 'Pas de changement, toujours #$rank.';
  }

  @override
  String msgRankHold3(int rank) {
    return 'Stable à la #${rank}e place.';
  }

  @override
  String msgRankUp1(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move places gagnées',
      one: '$move place gagnée',
    );
    return '$_temp0 au total, désormais #$rank.';
  }

  @override
  String msgRankUp2(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move places',
      one: '$move place',
    );
    return 'Une remontée de $_temp0 vous hisse à la #${rank}e place.';
  }

  @override
  String msgRankUp3(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move places gagnées',
      one: '$move place gagnée',
    );
    return '$_temp0, désormais #$rank.';
  }

  @override
  String msgRankDown1(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move places perdues',
      one: '$move place perdue',
    );
    return '$_temp0 au total, désormais #$rank.';
  }

  @override
  String msgRankDown2(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move places',
      one: '$move place',
    );
    return 'Une chute de $_temp0 vous fait reculer à la #${rank}e place.';
  }

  @override
  String msgRankDown3(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move places perdues',
      one: '$move place perdue',
    );
    return '$_temp0, désormais #$rank.';
  }

  @override
  String get msgRankLeadYou => 'Vous êtes numéro un mondial.';

  @override
  String msgRankLeadOther(String nation) {
    return '$nation est numéro un mondial.';
  }

  @override
  String msgRankTitle(int rank) {
    return 'Classement mondial · #$rank';
  }

  @override
  String msgRankBody(String lead, String movement) {
    return 'Le classement mondial a été mis à jour. $lead $movement';
  }

  @override
  String msgRankJumpTitleUp(int rank) {
    return 'Remontée à la #${rank}e place';
  }

  @override
  String msgRankJumpTitleDown(int rank) {
    return 'Chute à la #${rank}e place';
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
      other: '$move places',
      one: '$move place',
    );
    return '$tournament a fait bouger le classement mondial. $nation est passé de #$from à #$to, une remontée de $_temp0.';
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
      other: '$move places',
      one: '$move place',
    );
    return '$tournament a fait bouger le classement mondial. $nation est passé de #$from à #$to, une chute de $_temp0.';
  }

  @override
  String get rankingSinceWcDraw => 'Depuis le tirage du Championnat du monde';

  @override
  String get rankingSinceCycleStart => 'Depuis le début de la campagne';

  @override
  String rankingMovedFromTo(int from, int now) {
    return '#$from à #$now';
  }

  @override
  String msgCapsTitle(String name, int count) {
    return '$name atteint les $count sélections';
  }

  @override
  String msgCapsBody(String name, int count) {
    return '$name compte désormais $count sélections avec votre équipe nationale.';
  }

  @override
  String msgGoalsTitle(String name, int count) {
    return '$name atteint les $count buts';
  }

  @override
  String msgGoalsBody(String name, int count) {
    return '$name a marqué $count buts internationaux pour votre sélection.';
  }

  @override
  String msgDevTitle(int year) {
    return 'Évolution de l’effectif · $year';
  }

  @override
  String msgThroughTitle(int year) {
    return 'Issus du centre de formation · $year';
  }

  @override
  String get msgThroughNote =>
      'Ce n’est pas une nouvelle promotion. Ce sont les jeunes arrivés à onze ans, qui ont désormais rejoint le vivier senior.';

  @override
  String msgNewFacesTitle(int year) {
    return 'Nouveaux visages · $year';
  }

  @override
  String get msgIntakeNoteAcademy =>
      'L’investissement dans la formation porte ses fruits : cette promotion est arrivée plus forte qu’elle ne l’aurait été.';

  @override
  String get msgIntakeNoteStanding =>
      'Le pays suit cette équipe : avec la sélection qui grimpe au classement mondial, les meilleurs jeunes choisissent le football, et cette promotion en sort plus forte.';

  @override
  String get msgIntakeNoteBoth =>
      'L’argent investi dans la formation et la progression au classement mondial se font sentir : cette promotion est arrivée plus forte qu’elle ne l’aurait été.';

  @override
  String msgIntakeTitle(int year) {
    return 'Promotion du centre de formation · $year';
  }

  @override
  String msgRetireCaptainTitle(String name) {
    return 'Votre capitaine $name prend sa retraite';
  }

  @override
  String msgRetireTitle(String name) {
    return '$name prend sa retraite internationale';
  }

  @override
  String msgRetireBody(String name, int age) {
    return '$name a pris sa retraite internationale à $age ans.';
  }

  @override
  String msgRetireBodyWith(String name, String tally, int age) {
    return '$name a pris sa retraite internationale à $age ans, avec $tally au compteur.';
  }

  @override
  String msgTallyCaps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sélections',
      one: '$count sélection',
    );
    return '$_temp0';
  }

  @override
  String msgTallyGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count buts',
      one: '$count but',
    );
    return '$_temp0';
  }

  @override
  String get msgArmbandVacant =>
      ' Le brassard est libre. Désignez un nouveau capitaine depuis l’écran des convocations.';

  @override
  String msgHofTitle(String name) {
    return '$name entre au panthéon';
  }

  @override
  String msgHofBody(String name, int caps, int goals) {
    return '$name rejoint le panthéon de votre sélection ($caps sélections, $goals buts). Retrouvez-le dans Légendes.';
  }

  @override
  String hubBanTitle(String name) {
    return '$name suspendu';
  }

  @override
  String hubBanBody(String name, String how, int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: 'les $matches prochains matchs',
      one: 'votre prochain match',
    );
    return '$name $how et est suspendu pour $_temp0. Il ne pourra pas être sélectionné.';
  }

  @override
  String get hubBanHowSecondYellow =>
      'a été expulsé pour un second avertissement';

  @override
  String get hubBanHowViolent => 'a reçu un rouge direct pour brutalité';

  @override
  String get hubBanHowRed => 'a été expulsé';

  @override
  String hubInjuryTitle(String name) {
    return '$name blessé';
  }

  @override
  String hubInjuryBody(String name, int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: '$matches matchs',
      one: '$matches match',
    );
    return '$name s’est blessé et sera absent pour $_temp0.';
  }

  @override
  String get hubRunnerUpTitle1 => 'Finalistes';

  @override
  String get hubRunnerUpTitle2 => 'Si près du but';

  @override
  String get hubRunnerUpTitle3 => 'Médailles d’argent';

  @override
  String hubRunnerUpBody1(String cup, String opponent) {
    return '$cup : vous avez atteint la finale mais perdu contre $opponent. Si près. L’argent cette fois.';
  }

  @override
  String hubRunnerUpBody2(String cup, String opponent) {
    return '$cup : battus en finale par $opponent. Finalistes, cruellement près du titre.';
  }

  @override
  String hubRunnerUpBody3(String cup, String opponent) {
    return '$cup : la finale vous a échappé face à $opponent. Beaucoup de fierté, mais pas le trophée.';
  }

  @override
  String get hubKnockedOutTitle1 => 'Éliminés';

  @override
  String get hubKnockedOutTitle2 => 'Fin de l’aventure';

  @override
  String get hubKnockedOutTitle3 => 'Le voyage s’arrête là';

  @override
  String hubKnockedOutBody1(String cup, String opponent, String stage) {
    return '$cup : vous êtes éliminés, battus par $opponent ($stage).';
  }

  @override
  String hubKnockedOutBody2(String cup, String opponent, String stage) {
    return '$cup : $opponent met fin à votre parcours ($stage).';
  }

  @override
  String hubKnockedOutBody3(String cup, String opponent, String stage) {
    return '$cup : votre parcours s’arrête ($stage), battus par $opponent.';
  }

  @override
  String get hubGroupExitTitle1 => 'Éliminés en phase de groupes';

  @override
  String get hubGroupExitTitle2 => 'Sortis dès les poules';

  @override
  String get hubGroupExitTitle3 => 'Retour prématuré';

  @override
  String hubGroupExitBody1(String cup) {
    return '$cup : c’est fini dès la phase de groupes. Pas assez pour atteindre la phase à élimination directe.';
  }

  @override
  String hubGroupExitBody2(String cup) {
    return 'Vous n’êtes pas sortis du groupe. $cup : c’est terminé.';
  }

  @override
  String hubGroupExitBody3(String cup) {
    return 'Pas de qualification pour la phase à élimination directe cette fois. $cup : terminé dès la phase de groupes.';
  }

  @override
  String boardObjectiveMetTitle(String comp) {
    return 'Objectif atteint : $comp';
  }

  @override
  String boardObjectiveMissedTitle(String comp) {
    return 'Objectif manqué : $comp';
  }

  @override
  String boardObjectiveMetBody(String comp, String demand, String finish) {
    return 'L’objectif de la direction ($comp) : $demand. Votre résultat : $finish. Elle a obtenu ce qu’elle voulait.';
  }

  @override
  String boardObjectiveMissedBody(String comp, String demand, String finish) {
    return 'L’objectif de la direction ($comp) : $demand. Votre résultat : $finish. C’est en deçà des attentes.';
  }

  @override
  String get newsWcMissTitle => 'Fin du rêve de Championnat du monde';

  @override
  String newsWcMissBody(int year) {
    return 'Vous ne serez pas au Championnat du monde $year. La campagne de qualification n’a pas suffi. Encore quatre ans.';
  }

  @override
  String get newsRecordScorerTitle => 'Meilleur buteur de l’histoire';

  @override
  String newsRecordScorerBody(String name, int goals) {
    return '$name est désormais le meilleur buteur de l’histoire avec $goals buts.';
  }

  @override
  String get newsRecordCapsTitle => 'Joueur le plus capé';

  @override
  String newsRecordCapsBody(String name, int caps) {
    return '$name est désormais le joueur le plus capé de l’histoire avec $caps sélections.';
  }

  @override
  String get newsARecordBreaker => 'Un nouveau recordman';

  @override
  String newsTransferTitle(String name, String club) {
    return '$name rejoint $club';
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
    return '$name ($position, $rating) a quitté $fromClub pour s’engager avec $destination contre $fee.';
  }

  @override
  String newsTransferAbroad(String club, String country) {
    return '$club ($country)';
  }

  @override
  String get newsTransferFree => 'Libre';

  @override
  String newsNatzStarTitle(String name, String nation) {
    return '⭐ $name prêt à rejoindre la sélection $nation !';
  }

  @override
  String newsNatzTitle(String name, String nation) {
    return '$name veut jouer pour la sélection $nation';
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
    return '$name, $position de $age ans noté $rating, actuellement lié à $fromNation, a des attaches familiales avec $nation et est prêt à changer. Ouvrez l’offre de naturalisation pour accepter ou refuser.';
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
    return '$name, $position de $age ans noté $rating, actuellement lié à $fromNation, est une star qui a des attaches familiales avec $nation et est prêt à changer. Ouvrez l’offre de naturalisation pour accepter ou refuser.';
  }

  @override
  String get newsTheirNation => 'sa sélection';

  @override
  String get newsYourNation => 'votre sélection';

  @override
  String get tourStatusChampions => 'CHAMPIONS';

  @override
  String get tourStatusFinals => 'PHASE FINALE';

  @override
  String get tourStatusQualifying => 'QUALIFS';

  @override
  String get tourStatusUpcoming => 'À VENIR';

  @override
  String get tourStatusInProgress => 'EN COURS';

  @override
  String get tourStatusComingSoon => 'BIENTÔT';

  @override
  String get tourStatusDecided => 'TERMINÉ';

  @override
  String tourStatusLeague(String letter) {
    return 'LIGUE $letter';
  }

  @override
  String get tourDrawWcQualifying => 'TIRAGE DES QUALIFICATIONS';

  @override
  String tourDrawContQualifying(String cup) {
    return '$cup : TIRAGE DES QUALIFICATIONS';
  }

  @override
  String get tourDrawWcHost => 'PAYS HÔTE DU CHAMPIONNAT DU MONDE';

  @override
  String tourDrawContHost(String cup) {
    return '$cup : PAYS HÔTE';
  }

  @override
  String get tourDrawHostsReveal => 'Et les pays hôtes seront…';

  @override
  String get tourDrawHostReveal => 'Et le pays hôte sera…';

  @override
  String get tourDrawHostCandidates => 'Les candidats en lice :';

  @override
  String get tourKickoffContinentalCup => 'COUPE CONTINENTALE';

  @override
  String tourHostCompetitionYear(String competition, int year) {
    return '$competition $year';
  }

  @override
  String newsContMissTitle(String cup) {
    return '$cup : raté';
  }

  @override
  String newsContMissBody(String cup) {
    return '$cup : vous n’êtes pas qualifiés. La campagne n’a pas suffi cette fois.';
  }

  @override
  String get potyLabelBest => 'Joueur de l’année';

  @override
  String get potyLabelYoung => 'Meilleur jeune de l’année';

  @override
  String potyTallyAssists(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count passes déc.',
      one: '$count passe déc.',
    );
    return '$_temp0';
  }

  @override
  String potyOverallValue(int value) {
    return 'Niveau $value';
  }

  @override
  String potyRatingValue(String value) {
    return 'Note $value';
  }

  @override
  String newsPotyTitle(int year) {
    return 'Joueur mondial de l’année $year';
  }

  @override
  String newsPotyBody(String name) {
    return '$name est le meilleur joueur du monde cette année.';
  }

  @override
  String newsPotyYoungSuffix(String name) {
    return ' $name remporte le prix du meilleur jeune.';
  }

  @override
  String newsWatchTitle(int year) {
    return 'Les jeunes que vous suivez, $year';
  }

  @override
  String newsWatchJump(String name, int rating, int gain) {
    String _temp0 = intl.Intl.pluralLogic(
      gain,
      locale: localeName,
      other: '$gain points',
      one: '$gain point',
    );
    return '$name a progressé jusqu’à $rating, $_temp0 de plus que l’an dernier.';
  }

  @override
  String newsWatchBand(String name, String band) {
    return '$name monte d’une catégorie : $band.';
  }

  @override
  String newsWatchDebutTitle(String name) {
    return '$name fait ses débuts';
  }

  @override
  String newsWatchDebutBody(String name, int age, int rating) {
    return '$name a honoré sa première sélection à $age ans, noté $rating. L’un des jeunes que vous suivez.';
  }

  @override
  String get matchStatsAtFullTime =>
      'La possession, les notes des joueurs et l’homme du match sont établis au coup de sifflet final.';

  @override
  String get matchPlayerRatings => 'NOTES DES JOUEURS';

  @override
  String get matchSubstitutions => 'CHANGEMENTS';

  @override
  String get matchSubstitutes => 'REMPLAÇANTS';

  @override
  String get matchPlayerOfTheMatch => 'HOMME DU MATCH';

  @override
  String get matchGoalShout => 'BUT !';

  @override
  String matchShootoutScore(int home, int away) {
    return 'TIRS AU BUT $home-$away';
  }

  @override
  String get tourVenues => 'STADES';

  @override
  String tourPot(int number) {
    return 'CHAPEAU $number';
  }

  @override
  String get tourHostSelection => 'DÉSIGNATION DU PAYS HÔTE';

  @override
  String get tourCandidates => 'CANDIDATS';

  @override
  String get tourJointBid => 'CANDIDATURE COMMUNE';

  @override
  String get tourGoldenGlove => 'GANT D’OR';

  @override
  String get tourTeamOfTournament => 'ÉQUIPE TYPE DU TOURNOI';

  @override
  String get tourYourRun => 'VOTRE PARCOURS';

  @override
  String get tourMedalTable => 'TABLEAU DES MÉDAILLES';

  @override
  String tourHostLine(String nation) {
    return 'Hôte : $nation';
  }

  @override
  String tourHostLineMulti(String hosts) {
    return 'Hôtes : $hosts';
  }

  @override
  String tourGroupNamed(String name) {
    return 'Groupe $name';
  }

  @override
  String get tourFinalsDrawBlurb =>
      'Têtes de série selon le classement mondial. Repérez votre sélection avant le tirage.';

  @override
  String get tourWorldRanking => 'Classement mondial';

  @override
  String get tourYourCompetitions => 'VOS COMPÉTITIONS';

  @override
  String get tourOtherContinents => 'AUTRES CONTINENTS';

  @override
  String get tourZoneGlobal => 'MONDE';

  @override
  String get tourZoneEurope => 'EUROPE';

  @override
  String get tourZoneSouthAmerica => 'AM. DU SUD';

  @override
  String get tourZoneNorthAmerica => 'AM. DU NORD';

  @override
  String get tourZoneAfrica => 'AFRIQUE';

  @override
  String get tourZoneAsia => 'ASIE';

  @override
  String get tourZoneOceania => 'OCÉANIE';

  @override
  String get tourZoneIntercontinental => 'INTERCONTINENTAL';

  @override
  String tourZoneLeague(String league) {
    return 'LIGUE $league';
  }

  @override
  String tourHostedBy(String hosts) {
    return 'ORGANISÉ PAR  $hosts';
  }

  @override
  String tourThirdsAdvance(int count, String destination) {
    return 'Les $count meilleurs se qualifient pour $destination';
  }

  @override
  String newsWalkoutTitle(String name) {
    return '$name claque la porte';
  }

  @override
  String newsWalkoutBody(String name, int age, int caps) {
    return '$name a pris sa retraite internationale à $age ans, avec $caps sélections. Il avait demandé à savoir où il en était, sans réponse, et il n’attendra pas plus longtemps.';
  }

  @override
  String get pressHeadlineWent1 => 'Un sélectionneur maître de la salle';

  @override
  String get pressHeadlineWent2 =>
      'Ils voulaient la polémique, ils ont trouvé un leader';

  @override
  String get pressHeadlineWent3 => 'Des réponses franches, et elles ont porté';

  @override
  String get pressHeadlineMixed1 => 'Beaucoup de mots, peu de réponses';

  @override
  String get pressHeadlineMixed2 => 'Un peu pour chacun, rien pour personne';

  @override
  String get pressHeadlineMixed3 =>
      'Une conférence qui a laissé les questions en suspens';

  @override
  String get pressHeadlineBadly1 =>
      'Un après-midi éprouvant devant les caméras';

  @override
  String get pressHeadlineBadly2 => 'La salle s’est retournée, et ça s’est vu';

  @override
  String get pressHeadlineBadly3 =>
      'Des réponses qui se liront encore plus mal demain matin';

  @override
  String get pressHeadlineFlat1 => 'Rien de dit, rien de gagné';

  @override
  String get pressHeadlineFlat2 => 'Dix minutes, aucune info';

  @override
  String get pressHeadlineFlat3 => 'Une page blanche pour la une';

  @override
  String get pressConferenceTitle => 'CONFÉRENCE DE PRESSE';

  @override
  String pressQuestionOf(int index, int total) {
    return 'Question $index sur $total';
  }

  @override
  String get pressTomorrowsHeadline => 'LA UNE DE DEMAIN';

  @override
  String get pressLeaveRoom => 'QUITTER LA SALLE';

  @override
  String get pressRoomVerdictSquad => 'Vestiaire';

  @override
  String get pressRoomVerdictBoard => 'Direction';

  @override
  String get yReactionElation0 => 'rien à redire. rien. parfait.';

  @override
  String get yReactionElation1 => 'je ne me sens pas bien (en bien).';

  @override
  String get yReactionElation2 => 'je l’encadre. au-dessus de la cheminée.';

  @override
  String get yReactionElation3 => 'on est de retour';

  @override
  String get yReactionElation4 => 'Capture d’écran pour les sceptiques. Tous.';

  @override
  String get yReactionElation5 =>
      'Je vais être insupportable avec ça pendant dix ans.';

  @override
  String get yReactionElation6 => 'Voilà. C’est pour ça qu’on regarde.';

  @override
  String get yReactionElation7 =>
      'Des jours comme ça font oublier tous les autres.';

  @override
  String get yReactionElation8 =>
      'Il était temps. Sincèrement, il était temps.';

  @override
  String get yReactionElation9 =>
      'Super. Refaites-le la semaine prochaine et j’y croirai.';

  @override
  String get yReactionElation10 =>
      'Profitez de ce soir, parce que cette équipe trouvera un moyen de tout gâcher.';

  @override
  String get yReactionElation11 =>
      'Une bonne soirée ne fait pas une grande équipe.';

  @override
  String get yReactionRelief0 => 'Pas joli, mais je signe à chaque fois.';

  @override
  String get yReactionRelief1 => 'Je ne sais pas comment. Mais ça passe !';

  @override
  String get yReactionRelief2 => 'Moche. Trois points. On avance.';

  @override
  String get yReactionRelief3 =>
      'Je prends du moche tous les jours si ça rapporte des points.';

  @override
  String get yReactionRelief4 => 'j’ai pris dix ans d’un coup';

  @override
  String get yReactionRelief5 =>
      'Que personne ne parle. Que personne ne porte la poisse.';

  @override
  String get yReactionRelief6 => 'Rythme cardiaque : inacceptable.';

  @override
  String get yReactionRelief7 => 'Survécu. C’est le mot. Survécu.';

  @override
  String get yReactionRelief8 =>
      'On ne devrait pas avoir besoin d’être soulagés après ce genre de match.';

  @override
  String get yReactionRelief9 => 'Soulagé, et un peu gêné de l’être.';

  @override
  String get yReactionRelief10 =>
      'Si c’est ça qu’on applaudit, on a un problème.';

  @override
  String get yReactionRelief11 =>
      'Passer de justesse devient une habitude, et pas une bonne.';

  @override
  String get yReactionFury0 => 'Pas au niveau. Pas du tout.';

  @override
  String get yReactionFury1 => 'Que quelqu’un m’explique ça lentement.';

  @override
  String get yReactionFury2 => 'C’était pénible à regarder, et je reste poli.';

  @override
  String get yReactionFury3 => 'Déçu. Sincèrement déçu.';

  @override
  String get yReactionFury4 => 'Non mais regardez-moi ça.';

  @override
  String get yReactionFury5 => 'Je veux des noms.';

  @override
  String get yReactionFury6 => 'Je supprime l’appli. Je la réinstalle jeudi.';

  @override
  String get yReactionFury7 =>
      'Personne sur le terrain n’avait l’air d’en avoir envie.';

  @override
  String get yReactionFury8 =>
      'Tous les quatre ans, la même chose. TOUS les quatre ans.';

  @override
  String get yReactionFury9 =>
      'Ce n’est pas une prestation, c’est une insulte.';

  @override
  String get yReactionFury10 =>
      'Des gens sacrifient leurs week-ends et leur argent pour ça. Réfléchissez-y.';

  @override
  String get yReactionFury11 =>
      'Je défends cette équipe depuis des années. Pas ce soir. Pas après ça.';

  @override
  String get yReactionDespair0 => 'bon.';

  @override
  String get yReactionDespair1 => 'Pas de blagues aujourd’hui. Rien.';

  @override
  String get yReactionDespair2 => 'Je vais marcher. Longtemps.';

  @override
  String get yReactionDespair3 => 'Je n’ai plus de façons de le dire.';

  @override
  String get yReactionDespair4 => 'Réveillez-moi dans quatre ans.';

  @override
  String get yReactionDespair5 => 'c’est la pire version de la réalité';

  @override
  String get yReactionDespair6 =>
      'Même plus en colère. C’est ça qui est inquiétant.';

  @override
  String get yReactionDespair7 => 'Celle-là va faire mal longtemps.';

  @override
  String get yReactionDespair8 =>
      'Je ne sais plus ce que c’est, mais ce n’est pas une équipe de football.';

  @override
  String get yReactionDespair9 =>
      'On est plus loin qu’avant, et personne ne veut le dire.';

  @override
  String get yReactionDespair10 =>
      'Une génération entière gâchée, et ce sont les mêmes qui décident de la suite.';

  @override
  String get yReactionDespair11 =>
      'Arrêtez de me parler de processus. Ça ne mène nulle part.';

  @override
  String get yReactionSmugness0 => 'Discrètement, mais : je vous l’avais dit.';

  @override
  String get yReactionSmugness1 => 'gardez celui-là en favori';

  @override
  String get yReactionSmugness2 =>
      'Les sceptiques sont devenus très silencieux.';

  @override
  String get yReactionSmugness3 =>
      'Non pas que quelqu’un compte. Moi, je compte.';

  @override
  String get yReactionSmugness4 => 'Je l’ai dit en janvier. Vérifiez le fil.';

  @override
  String get yReactionSmugness5 =>
      'Certains d’entre vous doivent des excuses à certains d’entre nous.';

  @override
  String get yReactionSmugness6 =>
      'À classer dans : je l’avais dit en premier.';

  @override
  String get yReactionSmugness7 => 'Pas de fanfaronnade. Juste un peu.';

  @override
  String get yReactionSmugness8 =>
      'Où sont passés tous les experts ? Vraie question.';

  @override
  String get yReactionSmugness9 =>
      'J’aimerais que chacun d’entre vous me le répète.';

  @override
  String get yReactionSmugness10 =>
      'Capture d’écran, imprimée, encadrée, envoyée à ceux qui ont ri.';

  @override
  String get yReactionSmugness11 =>
      'Je vais en reparler toute ma vie, et vous l’avez bien mérité.';

  @override
  String get yReactionShrug0 => 'c’est arrivé. suivant.';

  @override
  String get yReactionShrug1 => 'Bon. Peu importe. On continue.';

  @override
  String get yReactionShrug2 => 'À classer dans « football ».';

  @override
  String get yReactionShrug3 => 'Vraiment rien à ajouter.';

  @override
  String get yReactionShrug4 => 'aucune pensée, tête vide';

  @override
  String get yReactionShrug5 => 'Réveillez-moi pour le prochain.';

  @override
  String get yReactionShrug6 =>
      'Quatre-vingt-dix minutes que je ne récupérerai jamais.';

  @override
  String get yReactionShrug7 => 'Ni chaud ni froid, vraiment.';

  @override
  String get yReactionShrug8 =>
      'Impossible de vous dire une seule chose qui s’est passée.';

  @override
  String get yReactionShrug9 => 'Encore un de ceux-là. Il y en a beaucoup.';

  @override
  String get yReactionShrug10 => 'J’ai tout regardé et je n’ai rien ressenti.';

  @override
  String get yReactionShrug11 => 'Si personne n’en reparle, ça me va.';

  @override
  String get tourThirdsUneven =>
      'Les groupes sont inégaux : les résultats contre la dernière équipe de chaque grand groupe sont retirés, afin que chaque équipe soit jugée sur le même nombre de matchs.';

  @override
  String get careerExportSave => 'Sauvegarder cette partie';

  @override
  String get careerBackupAll => 'SAUVEGARDER TOUTES LES PARTIES';

  @override
  String get careerBackupAllFailed => 'Impossible d’écrire la sauvegarde.';

  @override
  String get backupTitle => 'SAUVEGARDES';

  @override
  String get backupBlurb =>
      'Toutes les parties sont dans un seul fichier sur ce téléphone, et rien ne le sauvegarde automatiquement. Exportez une copie et gardez-la ailleurs, dans Fichiers ou iCloud Drive, pour qu’un téléphone perdu ou une app supprimée ne vous coûte pas une carrière.';

  @override
  String get backupExport => 'EXPORTER UNE SAUVEGARDE';

  @override
  String get backupExportSubject => 'Sauvegardes FNM';

  @override
  String get backupRestore => 'RESTAURER DEPUIS UN FICHIER';

  @override
  String get backupRestoreWarnTitle => 'Remplacer toutes les parties ?';

  @override
  String get backupRestoreWarnBody =>
      'La restauration remplace toutes les parties de ce téléphone par celles du fichier. L’app va redémarrer.';

  @override
  String get backupRestoreConfirm => 'REMPLACER';

  @override
  String get backupCancel => 'ANNULER';

  @override
  String get backupExported => 'Sauvegarde prête. Choisissez où la conserver.';

  @override
  String get backupFailed => 'Impossible d’écrire la sauvegarde.';

  @override
  String get backupRejectedUnreadable => 'Ce fichier n’a pas pu être ouvert.';

  @override
  String get backupRejectedNotFnm => 'Ce n’est pas une sauvegarde FNM.';

  @override
  String get backupRejectedNewer =>
      'Cette sauvegarde provient d’une version plus récente de l’app. Mettez-la à jour d’abord.';

  @override
  String get backupRejectedTooOld =>
      'Cette sauvegarde est trop ancienne pour être restaurée par cette version.';

  @override
  String get careerShare => 'Partager cette carrière';

  @override
  String get careerImport => 'IMPORTER UNE CARRIÈRE';

  @override
  String get careerShareSubject => 'Une carrière FNM';

  @override
  String get careerImported => 'Carrière importée.';

  @override
  String get careerImportFailedUnreadable =>
      'Ce fichier n’est pas une carrière FNM.';

  @override
  String get careerImportFailedNewer =>
      'Cette carrière a été exportée par une version plus récente de l’app. Mettez-la à jour d’abord.';

  @override
  String get careerShareFailed => 'Impossible d’exporter cette carrière.';

  @override
  String get managerRename => 'Changer de nom';

  @override
  String get managerRenameSave => 'Enregistrer';

  @override
  String get managerTitle => 'SÉLECTIONNEUR';

  @override
  String get managerSkills => 'VOS COMPÉTENCES';

  @override
  String managerPointsAvailable(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count points à dépenser',
      one: '$count point à dépenser',
      zero: 'Aucun point à dépenser',
    );
    return '$_temp0';
  }

  @override
  String get managerPointsHow =>
      'Deux points par cycle terminé, un par trophée remporté.';

  @override
  String get managerSkillsScale =>
      'Chaque compétence commence à 5 et plafonne à 20. Un point dépensé l’est définitivement.';

  @override
  String get managerSkillManManagement => 'Gestion humaine';

  @override
  String get managerSkillManManagementBlurb =>
      'Chaque point rend vos paroles face à la presse et aux joueurs 3 % plus percutantes dans le vestiaire.';

  @override
  String get managerSkillTactical => 'Tactique';

  @override
  String get managerSkillTacticalBlurb =>
      'Chaque point fait assimiler un nouveau système 3 % plus vite : changer de dispositif coûte moins de matchs.';

  @override
  String get managerSkillYouth => 'Formation des jeunes';

  @override
  String get managerSkillYouthBlurb =>
      'Chaque point ajoute 1 % au talent qui sort de votre centre de formation, en plus de son financement.';

  @override
  String get managerSkillNegotiation => 'Négociation';

  @override
  String get managerSkillNegotiationBlurb =>
      'Chaque point rapporte 2 % d’argent en plus de la fédération, à chaque cycle.';

  @override
  String get managerStaff => 'VOTRE STAFF';

  @override
  String managerStaffWages(String amount) {
    return 'Salaires : $amount par cycle';
  }

  @override
  String get managerRoleAssistant => 'Entraîneur adjoint';

  @override
  String get managerRoleAssistantBlurb =>
      'Dirige l’entraînement : moins de blessures et de meilleurs jeunes qui percent.';

  @override
  String get managerRoleScout => 'Chef recruteur';

  @override
  String get managerRoleScoutBlurb =>
      'Évalue vos espoirs et votre prochain adversaire : des étoiles plus fiables et un avantage le jour du match.';

  @override
  String get managerRoleFitness => 'Préparateur physique';

  @override
  String get managerRoleFitnessBlurb => 'Les garde sur le terrain.';

  @override
  String staffEffectInjury(int percent) {
    return '$percent % de blessures en moins';
  }

  @override
  String staffEffectYouth(int points) {
    return 'Jeunes +$points de niveau';
  }

  @override
  String staffHiringInjury(int min, int max) {
    return 'En recruter un : $min % à $max % de blessures en moins';
  }

  @override
  String staffHiringYouth(int minPoints, int maxPoints) {
    return 'et jeunes +$minPoints à +$maxPoints de niveau';
  }

  @override
  String staffEffectScoutRead(int percent) {
    return 'Évalue $percent % des espoirs avec exactitude';
  }

  @override
  String staffEffectScoutCaps(int caps) {
    String _temp0 = intl.Intl.pluralLogic(
      caps,
      locale: localeName,
      other: 'Potentiel connu après $caps sélections',
      one: 'Potentiel connu après 1 sélection',
    );
    return '$_temp0';
  }

  @override
  String staffEffectScoutDossier(int points) {
    return '+$points de note grâce aux dossiers adverses';
  }

  @override
  String staffHiringScoutRead(int min, int max) {
    return 'En recruter un : $min % à $max % d’évaluations exactes';
  }

  @override
  String staffHiringScoutCaps(int minCaps, int maxCaps) {
    return 'et potentiel connu $minCaps à $maxCaps sélections plus tôt';
  }

  @override
  String staffHiringScoutDossier(int minPoints, int maxPoints) {
    return 'et +$minPoints à +$maxPoints de note à chaque match';
  }

  @override
  String get staffEffectNone => 'Aucun effet sur votre effectif pour l’instant';

  @override
  String get staffVacant => 'Poste vacant';

  @override
  String get staffLeaveVacant => 'Laisser le poste vacant';

  @override
  String get managerTierNone => 'Aucun';

  @override
  String get managerTierBasic => 'Basique';

  @override
  String get managerTierGood => 'Bon';

  @override
  String get managerTierElite => 'Élite';

  @override
  String get managerFree => 'gratuit';

  @override
  String get managerTraining => 'ENTRE LES FENÊTRES';

  @override
  String get managerTrainingBlurb =>
      'Ce que le groupe travaille quand il n’y a pas de match.';

  @override
  String get managerFocusBalanced => 'Équilibré';

  @override
  String get managerFocusBalancedBlurb => 'Un peu de tout.';

  @override
  String get managerFocusFitness => 'Physique';

  @override
  String get managerFocusFitnessBlurb => 'Moins de pépins.';

  @override
  String get managerFocusCohesion => 'Cohésion';

  @override
  String get managerFocusCohesionBlurb => 'Le système s’installe plus vite.';

  @override
  String get managerFocusYouth => 'Jeunes';

  @override
  String get managerFocusYouthBlurb =>
      'Des heures avec les plus jeunes du vivier.';

  @override
  String get tourOfferTitle => 'Première visite ?';

  @override
  String get tourOfferBody =>
      'C’est un gros jeu. Envie d’un rapide tour des écrans importants ? Ça prend une minute, et vous pouvez le relancer à tout moment depuis les Paramètres.';

  @override
  String get tourOfferYes => 'Faites-moi visiter';

  @override
  String get tourOfferNo => 'Non merci';

  @override
  String get tourBack => 'Retour';

  @override
  String get tourNext => 'Suivant';

  @override
  String get tourDone => 'Terminé';

  @override
  String get tourSkip => 'Passer';

  @override
  String get tourHubTitle => 'Tout le jeu est ici';

  @override
  String get tourHubBody =>
      'Un seul bouton, qui change au fil du cycle : un tirage à suivre, une liste à convoquer, un match à jouer. Au-dessus figurent la confiance de la direction et les objectifs qu’elle a fixés.';

  @override
  String get tourBudgetTitle => 'L’argent de la fédération';

  @override
  String get tourBudgetBody =>
      'Une fois par cycle de quatre ans, vous répartissez le trésor entre les départements. Votre staff est payé en premier, donc recruter un recruteur d’élite se décide au détriment du centre de formation, pas en plus.';

  @override
  String get tourTacticsTitle => 'Comment l’équipe joue';

  @override
  String get tourTacticsBody =>
      'Votre système, votre façon de jouer, votre capitaine et vos tireurs de CPA. Laissez les deux derniers vides et le jeu vous préviendra avant le coup d’envoi au lieu de choisir discrètement à votre place.';

  @override
  String get tourSquadTitle => 'Tous les joueurs sélectionnables';

  @override
  String get tourSquadBody =>
      'Tout le vivier, pas seulement la liste : qui est en forme, qui traîne un pépin, qui est suspendu, et qui vient de sortir du centre de formation.';

  @override
  String get tourCallUpsTitle => 'Convoquer une liste';

  @override
  String get tourCallUpsBody =>
      'Vous convoquez une liste par fenêtre internationale, et elle dispute tous les matchs de cette fenêtre, exactement comme un vrai sélectionneur. Une blessure pendant la fenêtre entraîne un remplacement automatique.';

  @override
  String get tourRecordsTitle => 'Votre carrière';

  @override
  String get tourRecordsBody =>
      'Tout ce que vous avez accompli : les matchs, les records de l’équipe, les trophées et chaque nation que vous avez dirigée.';

  @override
  String get tourCupsTitle => 'Le reste du monde';

  @override
  String get tourCupsBody =>
      'Toutes les compétitions en cours : groupes, classements et phases finales, y compris celles où vous n’êtes pas. Le monde continue de jouer, que vous soyez qualifié ou non.';

  @override
  String get settingsTourTitle => 'Revoir le tutoriel';

  @override
  String get settingsTourBlurb =>
      'Reparcourez les écrans clés depuis le début.';

  @override
  String get tourBoardTitle => 'À qui vous rendez des comptes';

  @override
  String get tourBoardBody =>
      'La confiance de la direction et les objectifs fixés pour ce cycle. Si vous manquez la cible, c’est ici que vous le verrez venir.';

  @override
  String get tourStaffTitle => 'Votre entourage';

  @override
  String get tourStaffBody =>
      'Un adjoint, un recruteur et un préparateur physique, recrutés nommément. Leurs salaires sont prélevés sur ce budget avant les départements, donc un grand recruteur se paie au détriment du centre de formation.';

  @override
  String get tourPlaystyleTitle => 'Votre façon de jouer';

  @override
  String get tourPlaystyleBody =>
      'Le système n’est que la moitié d’une tactique. Voici l’autre moitié : à quelle hauteur vous pressez, à quel point vous jouez direct, combien vous prenez de risques.';

  @override
  String get settingsTourNoSave =>
      'Commencez d’abord une carrière. La visite passe par vos propres écrans.';

  @override
  String tacticsOutOfPositionAge(int age) {
    return 'Hors de son poste · $age ans';
  }

  @override
  String get federationNextCycleLocked =>
      'Le budget du prochain cycle se fixe au début de ce cycle, en une fois. D’ici là, voici ce que fait votre argent.';

  @override
  String get federationBudgetAlreadySet => 'Déjà fixé pour ce cycle';

  @override
  String yFinalLooms0(String opponent) {
    return 'Ce sera $opponent pour le grand match. Toute la semaine, on ne parlera que de ça.';
  }

  @override
  String yFinalLooms1(String opponent) {
    return 'C’est confirmé : $opponent est le dernier obstacle. Quatre ans pour ça.';
  }

  @override
  String yFinalLooms2(String opponent) {
    return 'Bon. $opponent. Personne ne dort avant la fin.';
  }

  @override
  String yFinalLooms3(String opponent) {
    return '$opponent ensuite, et tout le reste peut attendre. Quelle semaine.';
  }

  @override
  String get matchSetupLeaveToCoach =>
      'Laisser l’entraîneur choisir les tireurs';

  @override
  String friendliesLikeYourGroup(String rivals) {
    return 'Signalées ci-dessous : les équipes qui jouent comme vos adversaires de groupe de ce cycle ($rivals).';
  }

  @override
  String newsTransferWindowTitle(int year) {
    return 'Mercato · $year';
  }

  @override
  String careerLastAgo(String when) {
    return 'Dernière partie il y a $when';
  }

  @override
  String get settingsFreeScopeTitle => 'Un cycle de quatre ans gratuit';

  @override
  String get settingsFreeScopeBlurb =>
      'Un cycle complet (qualifications, votre championnat continental et le Championnat du monde) sur deux sauvegardes, avec toutes les nations du monde, sans restriction. Les cycles infinis et les sauvegardes illimitées s’obtiennent en un seul paiement, qui couvre toutes les futures mises à jour.';

  @override
  String get settingsUnlockedTitle => 'Débloqué';

  @override
  String get settingsUnlockedBlurb =>
      'Cycles infinis, sauvegardes illimitées et toutes les futures mises à jour. Merci.';

  @override
  String get settingsFromDeveloperTitle => 'Le mot du développeur';

  @override
  String get settingsFromDeveloperBlurb =>
      'Football Nations Manager est conçu par une seule personne et sera suivi sur le long terme. Il n’y aura jamais de publicités ni de microtransactions. Si le jeu vous plaît, pensez à acheter la version complète. C’est ce qui permet aux mises à jour de continuer.';

  @override
  String get settingsFromDeveloperThanksBlurb =>
      'Football Nations Manager est conçu par une seule personne et sera suivi sur le long terme. Il n’y aura jamais de publicités ni de microtransactions. Merci d’avoir acheté la version complète. C’est ce qui permet aux mises à jour de continuer.';

  @override
  String friendliesLikeYourCampaign(String rivals) {
    return 'Signalées ci-dessous : les équipes qui jouent comme vos futurs adversaires ($rivals).';
  }

  @override
  String get friendliesCloseToYou =>
      'Signalées ci-dessous : les équipes les plus proches de vous au classement mondial. Une fois le tirage fait, les repères suivent votre groupe.';

  @override
  String transfersMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transferts',
      one: '1 transfert',
    );
    return '$_temp0';
  }

  @override
  String hubRoundPage(int page, int pages) {
    return '$page / $pages';
  }

  @override
  String get transfersNewer => 'Plus récents';

  @override
  String get transfersOlder => 'Plus';

  @override
  String get transfersPagePrevious => 'Précédent';

  @override
  String get transfersPageNext => 'Suivant';

  @override
  String transfersPageOf(int page, int pages) {
    return 'Page $page sur $pages';
  }

  @override
  String get transfersMovedTo => 'Parti à';

  @override
  String get transfersUnknownClub => 'Club inconnu';

  @override
  String yAgainstThemAgain0(String opponent, String count) {
    return 'Ça fait $count fois face à $opponent. Quelqu’un tient les comptes, et c’est eux.';
  }

  @override
  String yAgainstThemAgain1(String opponent, String count) {
    return 'Encore $opponent. $count confrontations, et on ne les a toujours pas compris.';
  }

  @override
  String yAgainstThemAgain2(String opponent, String count) {
    return '${count}e fois face à $opponent. Ce n’est plus une coïncidence.';
  }

  @override
  String yAgainstThemAgain3(String opponent, String count) {
    return 'On a joué $count fois face à $opponent et on n’en a rien appris.';
  }

  @override
  String yAgainstThemAgain4(String opponent, String count) {
    return '$opponent, $count fois. Ils savent exactement ce qu’on va faire.';
  }

  @override
  String yAgainstThemAgain5(String opponent, String count) {
    return 'Quoi que $opponent ait contre nous, après $count confrontations, ça marche toujours.';
  }

  @override
  String ySameOldStory0(String count) {
    return 'C’est la ${count}e fois que ça arrive ces derniers temps. À partir de quand c’est simplement ce qu’on est ?';
  }

  @override
  String ySameOldStory1(String count) {
    return '$count après-midi comme celui-ci maintenant. C’est une tendance, pas de la malchance.';
  }

  @override
  String ySameOldStory2(String count) {
    return 'On a vu exactement ce match $count fois récemment. Même scénario, même fin.';
  }

  @override
  String ySameOldStory3(String count) {
    return 'La ${count}e version des mêmes quatre-vingt-dix minutes. Personne ne corrige rien.';
  }

  @override
  String ySameOldStory4(String count) {
    return '$count fois. Si vous ne voyez pas la tendance maintenant, c’est que vous ne regardez pas.';
  }

  @override
  String ySameOldStory5(String count) {
    return 'Même histoire, $count fois. Les excuses se sont épuisées avant les mauvais résultats.';
  }

  @override
  String get yToldYouSo0 =>
      'J’avais dit que ça arriverait pendant que tout le monde faisait la fête.';

  @override
  String get yToldYouSo1 =>
      'Deux bonnes semaines et on était de nouveau une génération dorée. Et nous voilà.';

  @override
  String get yToldYouSo2 =>
      'Ceux qui me disaient de profiter le mois dernier sont devenus bien silencieux.';

  @override
  String get yToldYouSo3 =>
      'Ça ne me fait aucun plaisir. Très peu de plaisir. Un peu.';

  @override
  String get yToldYouSo4 =>
      'Ça n’a jamais été aussi bien qu’on vous l’a dit, et en voici la preuve.';

  @override
  String get yToldYouSo5 =>
      'À chaque fois. On nous dit que c’est différent, et à chaque fois ça ne l’est pas.';

  @override
  String get tacticsSubOffAlready => 'Déjà sorti';

  @override
  String get tacticsSubInjured => 'Blessé';

  @override
  String get tacticsSubSentOffMark => 'Expulsé';

  @override
  String get tacticsSubNoneLeft => 'Plus de changements';

  @override
  String get tacticsUndoLastChange => 'Annuler le dernier changement';

  @override
  String get matchStrengthTitle => 'CE QUI INFLUE SUR L’ÉQUIPE';

  @override
  String get strengthFactorFamiliarity => 'Système rodé';

  @override
  String get strengthFactorFatigue => 'Jambes lourdes';

  @override
  String get strengthFactorClubForm => 'Forme en club';

  @override
  String get strengthFactorMorale => 'Vestiaire';

  @override
  String get strengthFactorCaptain => 'Capitaine';

  @override
  String get strengthFactorStaff => 'Staff';

  @override
  String get strengthFactorDossier => 'Dossier du recruteur';

  @override
  String yDebut0(String name) {
    return '$name honore sa première sélection. Retenez bien ce nom.';
  }

  @override
  String yDebut1(String name) {
    return 'Première pour $name. Ça se voit chez lui, non ?';
  }

  @override
  String yDebut2(String name) {
    return '$name, première sélection. Voyons ce qu’il en fait.';
  }

  @override
  String yDebut3(String name) {
    return 'Première pour $name. Il fallait du sang neuf quelque part.';
  }

  @override
  String yDebut4(String name) {
    return '$name reçoit une sélection. On en distribue beaucoup ces temps-ci.';
  }

  @override
  String yDebut5(String name) {
    return 'Première pour $name. Encore un qu’on aura oublié au printemps.';
  }

  @override
  String yDrought0(String name, String count) {
    return '$name reste sur $count matchs sans marquer et fait tout le reste sur le terrain.';
  }

  @override
  String yDrought1(String name, String count) {
    return '$count matchs sans but pour $name. Ça finira par revenir, comme toujours.';
  }

  @override
  String yDrought2(String name, String count) {
    return '$name : $count matchs, zéro but.';
  }

  @override
  String yDrought3(String name, String count) {
    return '$count matchs sans but pour $name. À surveiller.';
  }

  @override
  String yDrought4(String name, String count) {
    return '$count matchs. Zéro but. $name ne mettrait pas le ballon dans une cage vide.';
  }

  @override
  String yDrought5(String name, String count) {
    return '$name n’a pas marqué depuis $count matchs. Faites jouer littéralement n’importe qui d’autre.';
  }

  @override
  String yRivalryLooms0(String opponent, String count) {
    return '$opponent ensuite. $count confrontations et ça compte toujours autant.';
  }

  @override
  String yRivalryLooms1(String opponent, String count) {
    return '$count fois face à $opponent. Qu’ils viennent.';
  }

  @override
  String yRivalryLooms2(String opponent, String count) {
    return '$opponent ensuite. $count matchs joués.';
  }

  @override
  String yRivalryLooms3(String opponent, String count) {
    return '${count}e confrontation avec $opponent cette semaine.';
  }

  @override
  String yRivalryLooms4(String opponent, String count) {
    return 'Encore $opponent. $count matchs de ce genre et on n’a rien appris.';
  }

  @override
  String yRivalryLooms5(String opponent, String count) {
    return '$count matchs face à $opponent et ils nous battent encore. Merveilleux.';
  }

  @override
  String get positionGoalkeeper => 'Gardien';

  @override
  String get positionLeftBack => 'Arrière gauche';

  @override
  String get positionCentreBack => 'Défenseur central';

  @override
  String get positionRightBack => 'Arrière droit';

  @override
  String get positionDefensiveMid => 'Milieu défensif';

  @override
  String get positionCentralMid => 'Milieu central';

  @override
  String get positionAttackingMid => 'Milieu offensif';

  @override
  String get positionLeftMid => 'Milieu gauche';

  @override
  String get positionRightMid => 'Milieu droit';

  @override
  String get positionLeftWing => 'Ailier gauche';

  @override
  String get positionRightWing => 'Ailier droit';

  @override
  String get positionStriker => 'Avant-centre';

  @override
  String get roleNone => 'Aucun rôle';

  @override
  String get roleTargetMan => 'Pivot';

  @override
  String get rolePoacher => 'Renard des surfaces';

  @override
  String get rolePlaymaker => 'Meneur de jeu';

  @override
  String get roleBallWinner => 'Récupérateur';

  @override
  String get roleInvertedWinger => 'Ailier inversé';

  @override
  String get roleBallPlayingDefender => 'Défenseur relanceur';

  @override
  String get roleNoneBlurb => 'Joue son jeu naturel.';

  @override
  String get roleTargetManBlurb =>
      'Gagne les duels aériens, remise. Passes décisives et CPA.';

  @override
  String get rolePoacherBlurb => 'Rôde dans la surface. Beaucoup plus de buts.';

  @override
  String get rolePlaymakerBlurb =>
      'Crée des occasions. Bien plus de passes décisives.';

  @override
  String get roleBallWinnerBlurb => 'Casse le jeu plutôt que de conclure.';

  @override
  String get roleInvertedWingerBlurb =>
      'Repique dans l’axe pour frapper. Plus de buts.';

  @override
  String get roleBallPlayingDefenderBlurb =>
      'Lance les actions depuis l’arrière.';

  @override
  String get federationDeptYouth => 'Centre de formation';

  @override
  String get federationDeptCommercial => 'Commercial / RP';

  @override
  String get federationDeptMedical => 'Médical et sciences du sport';

  @override
  String get federationDeptNaturalisation => 'Bureau des naturalisations';

  @override
  String get federationDeptBoardRelations => 'Relations avec la direction';

  @override
  String get federationDeptYouthBlurb =>
      'De meilleurs jeunes débutent pour votre sélection au prochain cycle.';

  @override
  String get federationDeptCommercialBlurb =>
      'Le sponsoring rapporte des revenus supplémentaires en fin de cycle.';

  @override
  String get federationDeptMedicalBlurb =>
      'Moins de blessures. Votre effectif reste disponible tout le cycle.';

  @override
  String get federationDeptNaturalisationBlurb =>
      'Davantage de joueurs étrangers proposent de rejoindre votre sélection.';

  @override
  String get federationDeptBoardRelationsBlurb =>
      'La direction juge vos résultats avec plus de patience.';

  @override
  String get federationBuildingAcademy => 'Centre de formation';

  @override
  String get federationBuildingCommercial => 'Siège commercial';

  @override
  String get federationBuildingMedical => 'Centre médical';

  @override
  String get federationBuildingScouting => 'Cellule de recrutement';

  @override
  String get federationBuildingBoardroom => 'Salle du conseil';

  @override
  String get moraleBuoyant => 'Euphorique';

  @override
  String get moralePositive => 'Positif';

  @override
  String get moraleSettled => 'Serein';

  @override
  String get moraleUneasy => 'Tendu';

  @override
  String get moraleRockBottom => 'Au plus bas';

  @override
  String get matchTabTimeline => 'DÉROULÉ';

  @override
  String get matchTabStats => 'STATS';

  @override
  String get matchTabLineups => 'COMPOS';

  @override
  String get matchPenalty => 'PENALTY';

  @override
  String get matchStateLevel => 'Égalité parfaite';

  @override
  String matchStateLead(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vous menez de $count buts',
      one: 'Vous menez d’un but',
    );
    return '$_temp0';
  }

  @override
  String matchStateTrail(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vous êtes mené de $count buts',
      one: 'Vous êtes mené d’un but',
    );
    return '$_temp0';
  }

  @override
  String matchPossessionShare(int possession) {
    return '$possession % de possession';
  }

  @override
  String get boardVerdictSackedTitle => 'La direction vous a limogé';

  @override
  String boardVerdictSackedBody(int rating) {
    return 'Un cycle désastreux (note $rating %). Votre règne s’arrête ici. Seules des nations plus modestes tenteront encore le coup avec vous.';
  }

  @override
  String get boardVerdictDelightedTitle => 'La direction est ravie';

  @override
  String boardVerdictDelightedBody(int rating, String best) {
    return 'Un cycle exceptionnel (note $rating %), avec comme sommet $best. De plus grandes nations s’intéressent à vous, ou vous pouvez rester et construire.';
  }

  @override
  String get boardVerdictSolidTitle => 'Un cycle solide';

  @override
  String boardVerdictSolidBody(int rating) {
    return 'La direction est satisfaite (note $rating %). Quelques nations de même rang vous accueilleraient, mais rien ne presse.';
  }

  @override
  String get boardVerdictExpectedMoreTitle => 'La direction attendait plus';

  @override
  String boardVerdictExpectedMoreBody(int rating) {
    return 'Un cycle décevant (note $rating %). Vous gardez votre poste, mais toute offre serait un pas en arrière.';
  }

  @override
  String get boardVerdictPressureTitle => 'Vous êtes vraiment sous pression';

  @override
  String boardVerdictPressureBody(int rating) {
    return 'Un cycle médiocre (note $rating %). Vous survivez, mais seules des nations plus faibles s’intéressent à vous si vous voulez repartir de zéro.';
  }

  @override
  String get boardVerdictHeroTitle => 'La nation est derrière vous';

  @override
  String boardVerdictHeroNote(String nation, int cycles) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles cycles',
      one: '$cycles cycle',
    );
    return ' $nation vous adore : vous êtes un héros national après $_temp0, et votre poste est assuré aussi longtemps que vous le voudrez.';
  }

  @override
  String get boardVerdictTheNation => 'La nation';

  @override
  String get boardVerdictBestQuiet => 'un cycle tranquille';

  @override
  String get boardVerdictBestCycle => 'le cycle';

  @override
  String boardVerdictBestWorld(String placement) {
    return 'le Championnat du monde : $placement';
  }

  @override
  String get finishThirdPlace => 'Troisième place';

  @override
  String get finishFourthPlace => 'Quatrième place';

  @override
  String get finishDidNotQualify => 'Non qualifié';

  @override
  String get careerRepIconic => 'Iconique';

  @override
  String get careerRepRenowned => 'Réputé';

  @override
  String get careerRepEstablished => 'Reconnu';

  @override
  String get careerRepRising => 'En devenir';

  @override
  String get careerRepUnproven => 'Inexpérimenté';

  @override
  String get hubOfferStepUp => 'Promotion';

  @override
  String get hubOfferLateral => 'Même niveau';

  @override
  String get hubOfferRebuild => 'Reconstruction';

  @override
  String careerNationsCupWon(String league) {
    return 'Ligue $league · Vainqueurs';
  }

  @override
  String careerNationsCupRunnerUp(String league) {
    return 'Ligue $league · Finalistes';
  }

  @override
  String careerNationsCupSemi(String league) {
    return 'Ligue $league · Demi-finalistes';
  }

  @override
  String careerNationsCupPlaced(String league, int position) {
    return 'Ligue $league · #$position';
  }

  @override
  String tourRunInto(String round) {
    return 'Qualifiés : $round';
  }

  @override
  String get tourRunIntoThirdPlace => 'En match pour la 3e place';

  @override
  String tourRunThrough(String round) {
    return 'Sortis vainqueurs : $round';
  }

  @override
  String tourRunOut(String round) {
    return 'Éliminés : $round';
  }

  @override
  String get tourRunInGroup => 'En phase de groupes';

  @override
  String get tourRunGroupOut => 'Éliminés en phase de groupes';

  @override
  String resultsCycleTitle(int year, String nation) {
    return 'Cycle $year · $nation';
  }

  @override
  String resultsCycleRecord(int played, int won, int drawn, int lost) {
    return '$played joués  ·  ${won}V ${drawn}N ${lost}D';
  }

  @override
  String resultsCycleFinish(String finish) {
    return 'Championnat du monde : $finish';
  }

  @override
  String get resultsCycleUnderway => 'En cours';

  @override
  String yTurnedItRound0(String opponent) {
    return 'Menés de deux buts par $opponent à la pause, et ils ont tout récupéré. Ça, c’est une équipe.';
  }

  @override
  String yTurnedItRound1(String opponent) {
    return 'Deux buts de retard face à $opponent et à la fin, ça ne comptait plus. Peu d’équipes en sont capables.';
  }

  @override
  String yTurnedItRound2(String opponent) {
    return 'Mi-temps : menés de deux buts par $opponent. Fin du match : plus du tout. La seconde période était un autre match.';
  }

  @override
  String yTurnedItRound3(String opponent) {
    return 'Revenus de 0-2 face à $opponent. Quoi qu’il ait été dit à la pause, dites-le chaque semaine.';
  }

  @override
  String yTurnedItRound4(String opponent) {
    return 'D’accord, on est revenus face à $opponent. Maintenant, que quelqu’un m’explique la première période.';
  }

  @override
  String yTurnedItRound5(String opponent) {
    return 'Menés de deux buts par $opponent et on devrait être ravis. Réglez la première période.';
  }

  @override
  String yThrewItAway0(String opponent) {
    return 'Deux buts d’avance sur $opponent à la pause et ça nous a échappé. Ça arrive à de meilleures équipes.';
  }

  @override
  String yThrewItAway1(String opponent) {
    return 'Deux buts d’avance sur $opponent et ça s’est envolé. Le cycle est long, on a le temps.';
  }

  @override
  String yThrewItAway2(String opponent) {
    return 'Mi-temps : deux buts d’avance sur $opponent. Fin du match : plus rien de tout ça.';
  }

  @override
  String yThrewItAway3(String opponent) {
    return 'Deux buts d’avance face à $opponent, envolés en quarante-cinq minutes.';
  }

  @override
  String yThrewItAway4(String opponent) {
    return 'Deux buts d’avance et on a tout perdu. Face à $opponent. Quelqu’un doit rendre des comptes.';
  }

  @override
  String yThrewItAway5(String opponent) {
    return 'Deux buts d’avance face à $opponent et on a réussi à faire ça. À chaque fois.';
  }

  @override
  String get cycleBackupDone =>
      'Carrière sauvegardée dans le dossier FNM de ce téléphone. Désinstaller l’app la supprime : pour garder une copie ailleurs, utilisez Sauvegarder cette partie sur l’écran des sauvegardes.';

  @override
  String get cycleBackupFailed =>
      'Impossible de sauvegarder la carrière cette fois.';

  @override
  String pressMomentBigWinWarm1(String opponent) {
    return 'Une soirée mémorable face à $opponent. À quel point êtes-vous fier de ce groupe ?';
  }

  @override
  String pressMomentBigWinWarm2(String opponent) {
    return '$opponent n’a pas pu suivre. Est-ce l’équipe que vous avez toujours cru avoir ?';
  }

  @override
  String pressMomentBigWinNeutral1(String opponent) {
    return 'Une large victoire face à $opponent. Qu’est-ce qui a fait la différence ce soir ?';
  }

  @override
  String pressMomentBigWinNeutral2(String opponent) {
    return '$opponent battu, et facilement. Où avez-vous gagné ce match ?';
  }

  @override
  String pressMomentBigWinHostile1(String opponent) {
    return 'Belle victoire face à $opponent. Une bonne soirée : pourquoi croire que ça va durer ?';
  }

  @override
  String pressMomentBigWinHostile2(String opponent) {
    return 'Beau résultat face à $opponent. C’était votre plan, ou les joueurs ont-ils trouvé la solution eux-mêmes ?';
  }

  @override
  String pressMomentBigLossWarm1(String opponent) {
    return 'Une soirée difficile face à $opponent. Que dites-vous aux joueurs après un match pareil ?';
  }

  @override
  String pressMomentBigLossWarm2(String opponent) {
    return 'Personne ne s’y attendait face à $opponent. Simplement un soir sans ?';
  }

  @override
  String pressMomentBigLossNeutral1(String opponent) {
    return 'Une soirée qui fait mal face à $opponent. Qu’est-ce qui n’a pas marché ?';
  }

  @override
  String pressMomentBigLossNeutral2(String opponent) {
    return '$opponent vous a démontés. Ce groupe est-il assez bon ?';
  }

  @override
  String pressMomentBigLossHostile1(String opponent) {
    return 'Vous avez été dominés partout face à $opponent. Comment avez-vous laissé les choses aller aussi loin ?';
  }

  @override
  String pressMomentBigLossHostile2(String opponent) {
    return '$opponent a marqué comme il voulait. Où était le plan ce soir ?';
  }

  @override
  String pressMomentCrisisWarm1(String opponent) {
    return 'Encore un match qui vous échappe, cette fois face à $opponent. Comment inverser la tendance ?';
  }

  @override
  String pressMomentCrisisWarm2(String opponent) {
    return 'Les résultats se sont taris, et $opponent a aggravé les choses. Croyez-vous toujours en ce groupe ?';
  }

  @override
  String pressMomentCrisisNeutral1(String opponent) {
    return 'Toujours pas de victoire, cette fois face à $opponent, et la direction observe. Votre poste est-il menacé ?';
  }

  @override
  String pressMomentCrisisNeutral2(String opponent) {
    return 'Après $opponent, la série s’allonge. Êtes-vous inquiet pour votre avenir ?';
  }

  @override
  String pressMomentCrisisHostile1(String opponent) {
    return '$opponent aussi, maintenant. Votre prédécesseur a été limogé après une série comme celle-ci. Pourquoi y survivriez-vous ?';
  }

  @override
  String pressMomentCrisisHostile2(String opponent) {
    return 'Après une nouvelle soirée comme face à $opponent, toutes les radios réclament votre départ. Démissionneriez-vous si la direction vous le demandait ?';
  }

  @override
  String pressMomentJobVerdictWarm1(String opponent) {
    return 'Vous avez mis votre poste en jeu, et après $opponent, ça n’a pas tourné en votre faveur. Comment tenez-vous le coup ?';
  }

  @override
  String pressMomentJobVerdictWarm2(String opponent) {
    return 'Les trois matchs sont joués, le dernier face à $opponent. Vous avez fixé le test vous-même. Que pensez-vous du verdict ?';
  }

  @override
  String pressMomentJobVerdictNeutral1(String opponent) {
    return 'Vous nous avez dit de vous juger sur les trois prochains. Après $opponent, c’est fait. Votre poste est-il toujours le vôtre ?';
  }

  @override
  String pressMomentJobVerdictNeutral2(String opponent) {
    return 'Trois matchs, le dernier face à $opponent, et pas ce que vous aviez promis. Avez-vous parlé de votre avenir avec la direction ?';
  }

  @override
  String pressMomentJobVerdictHostile1(String opponent) {
    return 'Vous avez fixé le test vous-même et l’avez raté face à $opponent. Allez-vous démissionner ?';
  }

  @override
  String pressMomentJobVerdictHostile2(String opponent) {
    return 'Vos mots, pas les nôtres : jugez-moi sur les trois prochains. Après $opponent, pourquoi êtes-vous encore assis là ?';
  }

  @override
  String get pressBeatWhoToBlameWarm1 =>
      'Vous attendez plus d’eux. Quelqu’un en particulier ?';

  @override
  String get pressBeatWhoToBlameWarm2 =>
      'Vous avez placé la barre haut. Qui doit se montrer en premier ?';

  @override
  String get pressBeatWhoToBlameNeutral1 =>
      'Vous dites que certains doivent se remettre en question. À qui pensez-vous ?';

  @override
  String get pressBeatWhoToBlameNeutral2 =>
      'Pas assez bien, dites-vous. De qui parlez-vous ?';

  @override
  String get pressBeatWhoToBlameHostile1 =>
      'Vous restez vague. Allez-vous donner des noms, ou est-ce que ça vous retombe dessus ?';

  @override
  String get pressBeatWhoToBlameHostile2 =>
      'Chaque semaine, c’est la faute de quelqu’un d’autre. De qui cette fois ?';

  @override
  String get pressBeatIfYouDontWarm1 =>
      'Des mots courageux. Et si le prochain match ne tourne pas en votre faveur ?';

  @override
  String get pressBeatIfYouDontWarm2 =>
      'Le pays vous prendra au mot. Et si ça ne marche pas ?';

  @override
  String get pressBeatIfYouDontNeutral1 =>
      'Et si vous ne le gagnez pas ? Que se passera-t-il ?';

  @override
  String get pressBeatIfYouDontNeutral2 =>
      'Vous l’avez dit, maintenant. Et si vous vous trompez ?';

  @override
  String get pressBeatIfYouDontHostile1 =>
      'On a déjà entendu des promesses dans cette salle. Que devrez-vous aux supporters si celle-ci tombe aussi à l’eau ?';

  @override
  String get pressBeatIfYouDontHostile2 =>
      'Et quand ça n’arrivera pas, quelle sera l’excuse ?';

  @override
  String get pressBeatFollowUpWarm1 =>
      'Une dernière, si vous le voulez bien. Sur quoi ce groupe doit-il encore travailler ?';

  @override
  String get pressBeatFollowUpWarm2 =>
      'Une fois la poussière retombée, que retenez-vous de ce soir pour le prochain match ?';

  @override
  String get pressBeatFollowUpNeutral1 =>
      'Allons un peu plus loin. Qu’est-ce qui doit s’améliorer avant le prochain match ?';

  @override
  String get pressBeatFollowUpNeutral2 =>
      'Au-delà du score : ce groupe est-il là où vous le voulez ?';

  @override
  String get pressBeatFollowUpHostile1 =>
      'Beaucoup de mots, peu de contenu. Qu’est-ce qui change concrètement à partir de maintenant ?';

  @override
  String get pressBeatFollowUpHostile2 =>
      'Les supporters veulent une réponse franche. Cette équipe est-elle assez bonne, oui ou non ?';

  @override
  String pressBeatStandoutWarm1(String player) {
    return '$player a été exceptionnel ce soir. Jusqu’où peut-il aller ?';
  }

  @override
  String pressBeatStandoutWarm2(String player) {
    return '$player fait toutes les unes ce soir. L’aviez-vous vu venir ?';
  }

  @override
  String pressBeatStandoutNeutral1(String player) {
    return '$player s’est distingué. Que lui avez-vous demandé ce soir ?';
  }

  @override
  String pressBeatStandoutNeutral2(String player) {
    return '$player a-t-il fait la différence ce soir ?';
  }

  @override
  String pressBeatStandoutHostile1(String player) {
    return 'Sans $player, c’est une tout autre histoire. Est-ce une équipe, ou un seul joueur ?';
  }

  @override
  String pressBeatStandoutHostile2(String player) {
    return '$player a été brillant. Votre mérite, ou le sien ?';
  }

  @override
  String pressBeatStrugglerWarm1(String player) {
    return '$player a vécu une soirée difficile. Traîne-t-il un pépin ?';
  }

  @override
  String pressBeatStrugglerWarm2(String player) {
    return '$player est passé à côté. Allez-vous le réconforter ?';
  }

  @override
  String pressBeatStrugglerNeutral1(String player) {
    return '$player a eu du mal ce soir. Garde-t-il sa place ?';
  }

  @override
  String pressBeatStrugglerNeutral2(String player) {
    return '$player a semblé en retrait. Qu’avez-vous pensé de son match ?';
  }

  @override
  String pressBeatStrugglerHostile1(String player) {
    return '$player a encore été un passager. Pourquoi continuez-vous à le sélectionner ?';
  }

  @override
  String pressBeatStrugglerHostile2(String player) {
    return 'Tout le monde a vu que $player n’y était pas. Tout le monde sauf le banc ?';
  }

  @override
  String get pressThrowbackWinNextKeptWarm =>
      'Vous aviez dit que vous gagneriez le match suivant, et c’est fait. Ça fait du bien d’avoir raison ?';

  @override
  String get pressThrowbackWinNextKeptNeutral =>
      'Vous aviez promis une victoire au match suivant et vous l’avez obtenue. Confiance ou bravade ?';

  @override
  String get pressThrowbackWinNextKeptHostile =>
      'Vous aviez dit que vous gagneriez le match suivant, et c’est fait. De la chance, ou faut-il commencer à vous écouter ?';

  @override
  String get pressThrowbackWinNextBrokenWarm =>
      'Vous nous aviez dit que vous gagneriez ce match. Ça n’a pas été le cas. Qu’est-ce qui n’a pas marché ?';

  @override
  String get pressThrowbackWinNextBrokenNeutral =>
      'Vous aviez dit que vous gagneriez le match suivant. Ce n’est pas arrivé. Pourquoi croire la prochaine promesse ?';

  @override
  String get pressThrowbackWinNextBrokenHostile =>
      'Vous aviez dit que vous gagneriez le match suivant. Ce n’est pas arrivé. Vos paroles ont-elles encore un sens dans cette salle ?';

  @override
  String get pressThrowbackJobKeptWarm =>
      'Vous avez demandé à être jugé sur trois matchs, et vous avez réussi. Une revanche ?';

  @override
  String get pressThrowbackJobKeptNeutral =>
      'Jugez-moi sur les trois prochains, aviez-vous dit. C’est ce qu’on a fait, et les résultats sont venus. Que vous a appris ce test ?';

  @override
  String get pressThrowbackJobKeptHostile =>
      'Vous vous êtes donné trois matchs et vous les avez passés. Le test était-il vraiment si difficile ?';

  @override
  String get pressThrowbackJobBrokenWarm =>
      'Vous avez demandé à être jugé sur trois matchs. Ils n’ont pas tourné en votre faveur. Qu’en avez-vous appris ?';

  @override
  String get pressThrowbackJobBrokenNeutral =>
      'Jugez-moi sur les trois prochains, aviez-vous dit. Les trois sont passés, et le bénéfice du doute avec. Et maintenant ?';

  @override
  String get pressThrowbackJobBrokenHostile =>
      'Vous avez fixé le test et vous l’avez raté. Pourquoi vous croire encore ?';

  @override
  String pressThrowbackBackKeptWarm(String player) {
    return 'Vous avez soutenu $player quand d’autres ne l’auraient pas fait. Il a répondu présent. Une part du mérite vous revient ?';
  }

  @override
  String pressThrowbackBackKeptNeutral(String player) {
    return 'Vous avez soutenu $player. Il a répondu présent. Foi ou certitude ?';
  }

  @override
  String pressThrowbackBackKeptHostile(String player) {
    return 'Vous avez soutenu $player, et pour une fois ça a payé. Serez-vous aussi sûr de vous la prochaine fois ?';
  }

  @override
  String pressThrowbackBackBrokenWarm(String player) {
    return 'Vous avez soutenu $player, et ça n’a pas fonctionné. Croyez-vous encore en lui ?';
  }

  @override
  String pressThrowbackBackBrokenNeutral(String player) {
    return 'Vous avez soutenu $player. Il ne vous l’a pas rendu. Était-ce une erreur ?';
  }

  @override
  String pressThrowbackBackBrokenHostile(String player) {
    return 'Votre jugement ou votre loyauté : lequel vous a fait défaut avec $player ?';
  }

  @override
  String pressThrowbackBlameKeptWarm(String player) {
    return 'Vous avez été dur avec $player, et les matchs suivants vous ont donné raison. Une satisfaction ?';
  }

  @override
  String pressThrowbackBlameKeptNeutral(String player) {
    return 'Vous avez critiqué $player, et il n’a pas répondu. Y a-t-il un retour possible pour lui ?';
  }

  @override
  String pressThrowbackBlameKeptHostile(String player) {
    return 'Vous avez lâché $player en public et il ne s’en est pas remis. L’avez-vous brisé ?';
  }

  @override
  String pressThrowbackBlameBrokenWarm(String player) {
    return 'Vous avez critiqué $player, et il vous a répondu sur le terrain. C’était l’idée depuis le début ?';
  }

  @override
  String pressThrowbackBlameBrokenNeutral(String player) {
    return 'Vous avez blâmé $player, et depuis il est l’un de vos meilleurs joueurs. Lui devez-vous des excuses ?';
  }

  @override
  String pressThrowbackBlameBrokenHostile(String player) {
    return 'Vous avez jeté $player en pâture, et il est votre meilleur joueur depuis. Allez-vous vous excuser ?';
  }

  @override
  String get pressReplyCreditPlayers1 =>
      'Ces joueurs m’ont tout donné. Je n’en échangerais pas un seul.';

  @override
  String get pressReplyCreditPlayers2 =>
      'Personne ne travaille plus dur que ce groupe. Je les défendrai toujours.';

  @override
  String get pressReplyCreditPlayers3 =>
      'Vous n’entendrez pas un mot contre mes joueurs de ma part.';

  @override
  String get pressReplyCreditPlayers4 =>
      'Le mérite revient aux joueurs, pas à moi. Écrivez sur eux.';

  @override
  String get pressReplyTakeResponsibility1 =>
      'Celle-là, elle est pour moi. J’ai choisi l’équipe et je l’ai organisée.';

  @override
  String get pressReplyTakeResponsibility2 =>
      'Jugez-moi, pas eux. C’est mon équipe et ma responsabilité.';

  @override
  String get pressReplyTakeResponsibility3 =>
      'Si vous cherchez un coupable, je suis assis juste là.';

  @override
  String get pressReplyTakeResponsibility4 =>
      'La responsabilité est la mienne. Laissez les joueurs en dehors de ça.';

  @override
  String get pressReplyDemandMore1 =>
      'J’en veux plus. Certains savent exactement de quoi je parle.';

  @override
  String get pressReplyDemandMore2 =>
      'L’effort ne suffit pas à ce niveau. J’en veux plus, et je le leur ai dit.';

  @override
  String get pressReplyDemandMore3 =>
      'J’attends plus de chacun d’entre eux, dès demain.';

  @override
  String get pressReplyDemandMore4 =>
      'Certains doivent se remettre en question. Je ne suis pas satisfait.';

  @override
  String get pressReplyPromiseWinNext1 =>
      'Nous gagnerons le prochain match. Vous pouvez l’écrire.';

  @override
  String get pressReplyPromiseWinNext2 =>
      'Retenez bien ce que je dis : nous gagnons le prochain match.';

  @override
  String get pressReplyPromiseWinNext3 =>
      'Prochain match, on gagne. Je le dis ici pour que vous puissiez me le rappeler.';

  @override
  String get pressReplyPromiseWinNext4 =>
      'Je crois en cette équipe. Nous gagnerons le prochain match.';

  @override
  String get pressReplyJobOnTheLine1 =>
      'Jugez-moi sur les trois prochains matchs. C’est juste.';

  @override
  String get pressReplyJobOnTheLine2 =>
      'Donnez-moi trois matchs. Si ce n’est pas réglé d’ici là, jugez-moi là-dessus.';

  @override
  String get pressReplyJobOnTheLine3 =>
      'Les trois prochains montreront si je suis l’homme de la situation. Tenez-moi à ça.';

  @override
  String get pressReplyJobOnTheLine4 =>
      'Trois matchs. Ensuite, écrivez ce que vous voulez sur moi.';

  @override
  String get pressReplyDeflect1 =>
      'Nous prenons les matchs les uns après les autres. Rien à ajouter.';

  @override
  String get pressReplyDeflect2 =>
      'Je ne vais pas vous offrir de gros titres aujourd’hui.';

  @override
  String get pressReplyDeflect3 =>
      'Le prochain match. C’est tout ce qui m’occupe.';

  @override
  String get pressReplyDeflect4 => 'Ce que je pense reste dans le vestiaire.';

  @override
  String get pressReplyTakeCredit1 =>
      'Je l’ai dit parce que j’y croyais, et j’avais raison.';

  @override
  String get pressReplyTakeCredit2 =>
      'J’ai bien lu la situation. C’est mon travail.';

  @override
  String get pressReplyTakeCredit3 =>
      'Appelez ça du flair. Je savais ce que je disais.';

  @override
  String get pressReplyTakeCredit4 =>
      'J’ai fait un choix et il a payé. Je le prends.';

  @override
  String get pressReplyStandByIt1 =>
      'J’ai dit ce que je pensais. Je le maintiens.';

  @override
  String get pressReplyStandByIt2 => 'Je ne retire pas un mot.';

  @override
  String get pressReplyStandByIt3 =>
      'Même réponse qu’à l’époque. Je le pensais, et je le pense toujours.';

  @override
  String get pressReplyStandByIt4 => 'Je le redirais demain.';

  @override
  String get pressReplyAdmitMistake1 =>
      'Je me suis trompé sur ce coup-là. Je l’assume.';

  @override
  String get pressReplyAdmitMistake2 =>
      'D’accord, j’ai mal jugé. J’en tirerai les leçons.';

  @override
  String get pressReplyAdmitMistake3 => 'J’avais tort, et je peux le dire.';

  @override
  String get pressReplyAdmitMistake4 =>
      'Ce choix n’a pas marché, et c’était le mien.';

  @override
  String pressReplyBackPlayer1(String player) {
    return '$player a tout mon soutien. Il va revenir à son meilleur niveau.';
  }

  @override
  String pressReplyBackPlayer2(String player) {
    return 'Je crois en $player, et il va vous montrer pourquoi.';
  }

  @override
  String pressReplyBackPlayer3(String player) {
    return 'Vous n’entendrez pas un mot contre $player de ma part. Il répondra présent.';
  }

  @override
  String pressReplyBackPlayer4(String player) {
    return '$player fait toujours partie de mes plans. Regardez ce qu’il va faire.';
  }

  @override
  String pressReplyBlamePlayer1(String player) {
    return '$player nous a laissés tomber ce soir, et il le sait.';
  }

  @override
  String pressReplyBlamePlayer2(String player) {
    return 'J’attendais beaucoup plus de $player. Il doit répondre à ça.';
  }

  @override
  String pressReplyBlamePlayer3(String player) {
    return '$player n’était pas au niveau. Je le dis publiquement.';
  }

  @override
  String pressReplyBlamePlayer4(String player) {
    return 'Ce n’était pas suffisant de la part de $player, et il va l’entendre de ma bouche.';
  }

  @override
  String get pressOnRecordWinNext =>
      'C’est enregistré : vous gagnerez le prochain match.';

  @override
  String get pressOnRecordJob =>
      'C’est enregistré : on vous juge sur les trois prochains.';

  @override
  String pressOnRecordBack(String player) {
    return 'C’est enregistré : soutien à $player.';
  }

  @override
  String pressOnRecordBlame(String player) {
    return 'C’est enregistré : $player vous a déçu.';
  }

  @override
  String yStatementKept0(String nation) {
    return 'Il l’a dit, et c’est arrivé. $nation a un sélectionneur qui tient parole.';
  }

  @override
  String yStatementKept1(String nation) {
    return 'Il l’a dit tout haut, puis il l’a fait. Le sélectionneur qu’il fallait. $nation.';
  }

  @override
  String yStatementKept2(String nation) {
    return '$nation : il l’avait annoncé, et c’est arrivé. Rien à dire.';
  }

  @override
  String yStatementKept3(String nation) {
    return 'Il s’est engagé publiquement et ça a tenu. Un point pour lui. $nation avance.';
  }

  @override
  String yStatementKept4(String nation) {
    return 'Il a vu juste une fois. $nation, ne vous y habituez pas.';
  }

  @override
  String yStatementKept5(String nation) {
    return 'Même une horloge arrêtée a raison deux fois par jour. $nation a eu de la chance cette fois.';
  }

  @override
  String yStatementBroken0(String nation) {
    return 'Il l’a dit et ça n’a pas marché. Toujours derrière lui. $nation remet ça.';
  }

  @override
  String yStatementBroken1(String nation) {
    return '$nation : il a promis plus que ce qu’on a eu, mais je préfère un sélectionneur qui croit en lui.';
  }

  @override
  String yStatementBroken2(String nation) {
    return '$nation : il l’a dit publiquement et ce n’est pas arrivé. Les gens s’en souviendront.';
  }

  @override
  String yStatementBroken3(String nation) {
    return 'De grands mots, rien derrière. $nation : la prochaine fois, parlez moins.';
  }

  @override
  String yStatementBroken4(String nation) {
    return 'Il était là, il nous l’a dit. Et puis ça. $nation mérite mieux que des paroles.';
  }

  @override
  String yStatementBroken5(String nation) {
    return 'Sa parole ne vaut plus rien. Notez-le bien. $nation.';
  }

  @override
  String get ncZoneNorth => 'Zone Nord';

  @override
  String get ncZoneWest => 'Zone Ouest';

  @override
  String get ncZoneEast => 'Zone Est';

  @override
  String get ncZoneCentralSouthern => 'Zone Centre et Sud';

  @override
  String careerNationsCupZoneWon(String zone) {
    return '$zone · Vainqueurs';
  }

  @override
  String careerNationsCupZoneRunnerUp(String zone) {
    return '$zone · Finalistes';
  }

  @override
  String careerNationsCupZoneSemi(String zone) {
    return '$zone · Demi-finalistes';
  }

  @override
  String careerNationsCupZoneRoundOf16(String zone) {
    return '$zone · Huitièmes de finale';
  }

  @override
  String careerNationsCupZoneQuarter(String zone) {
    return '$zone · Quart-de-finalistes';
  }

  @override
  String careerNationsCupZonePlaced(String zone, int position) {
    return '$zone · #$position';
  }

  @override
  String get objectiveNcFinalsEight => 'Atteindre les quarts de finale';

  @override
  String get objectiveNcZoneWinGroup => 'Gagner votre groupe';

  @override
  String get finishNcFinalsEight => 'Quarts de finale';

  @override
  String get finishNcBottomHalf => 'Seconde moitié du groupe';

  @override
  String get tourContTabZones => 'ZONES';

  @override
  String get tourContTabFinalsEight => 'PHASE FINALE';

  @override
  String get tourContFinalsEightSoon =>
      'La phase finale commence en novembre par des huitièmes de finale : les 14 vainqueurs de groupe et les 2 meilleurs deuxièmes.';

  @override
  String get tourContQuarterFinals => 'QUARTS DE FINALE';

  @override
  String get tourContZoneAdvancement =>
      'Chaque vainqueur de groupe va en huitièmes de finale, rejoint par les 2 meilleurs deuxièmes. Personne n’est relégué.';

  @override
  String tourContZoneHeadingYours(String zone) {
    return '$zone ★';
  }

  @override
  String get compNorthAmericaNationsCup =>
      'Coupe des Nations d’Amérique du Nord';

  @override
  String get compAfricanNationsCup => 'Coupe des Nations';

  @override
  String get objectiveNcWinItNorthAmerica =>
      'Remporter la Coupe des Nations d’Amérique du Nord';

  @override
  String get objectiveNcWinItAfrica => 'Remporter la Coupe des Nations';

  @override
  String get objectiveNcReachFinalNorthAmerica =>
      'Atteindre la finale de la Coupe des Nations d’Amérique du Nord';

  @override
  String get objectiveNcReachFinalAfrica =>
      'Atteindre la finale de la Coupe des Nations';

  @override
  String get finishNcChampionsNorthAmerica =>
      'Vainqueurs de la Coupe des Nations d’Amérique du Nord';

  @override
  String get finishNcChampionsAfrica => 'Vainqueurs de la Coupe des Nations';

  @override
  String pressAimQualWarm1(String competition) {
    return 'Qualifications : $competition. Tout le pays croit en cette équipe. Quel est votre objectif ?';
  }

  @override
  String pressAimQualWarm2(String competition) {
    return 'Nouvelle campagne de qualification, $competition, et le moral est au beau fixe. Jusqu’où cette équipe peut-elle aller ?';
  }

  @override
  String pressAimQualNeutral1(String competition) {
    return 'Les qualifications commencent, $competition. Quel est l’objectif de cette campagne ?';
  }

  @override
  String pressAimQualNeutral2(String competition) {
    return 'Les qualifications sont là, $competition. Où voyez-vous cette équipe à l’arrivée ?';
  }

  @override
  String pressAimQualHostile1(String competition) {
    return 'Les qualifications commencent, $competition, et beaucoup doutent que vous y arriviez. Que leur répondez-vous ?';
  }

  @override
  String pressAimQualHostile2(String competition) {
    return 'Encore une campagne de qualification, $competition. Pourquoi croire que celle-ci sera différente ?';
  }

  @override
  String pressAimFinalsWarm1(String competition) {
    return 'C’est parti : $competition. Tout le pays est derrière vous. Jusqu’où pouvez-vous aller ?';
  }

  @override
  String pressAimFinalsWarm2(String competition) {
    return 'Vous y êtes : $competition. Les supporters rêvent. Quel est l’objectif ?';
  }

  @override
  String pressAimFinalsNeutral1(String competition) {
    return 'Cette semaine commence : $competition. Qu’est-ce qui serait un succès ?';
  }

  @override
  String pressAimFinalsNeutral2(String competition) {
    return 'Votre premier match approche, $competition. Donnez-nous un objectif.';
  }

  @override
  String pressAimFinalsHostile1(String competition) {
    return 'C’est parti : $competition, et personne n’attend grand-chose. Qu’espérez-vous vraiment ?';
  }

  @override
  String pressAimFinalsHostile2(String competition) {
    return 'Vous y êtes : $competition, mais les doutes n’ont pas disparu. Quel est votre objectif ?';
  }

  @override
  String pressBeatRivalWarm1(String rival) {
    return 'Dans votre groupe : $rival. Est-ce que cela vous inquiète ?';
  }

  @override
  String pressBeatRivalWarm2(String rival) {
    return 'Le tirage vous oppose à : $rival. Comment voyez-vous ce match ?';
  }

  @override
  String pressBeatRivalNeutral1(String rival) {
    return '$rival semble la plus forte équipe de votre groupe. Favori ?';
  }

  @override
  String pressBeatRivalNeutral2(String rival) {
    return 'Que pensez-vous de cette équipe : $rival ?';
  }

  @override
  String pressBeatRivalHostile1(String rival) {
    return 'Dans votre groupe : $rival. Soyez honnête, pouvez-vous rivaliser ?';
  }

  @override
  String pressBeatRivalHostile2(String rival) {
    return 'La plupart s’attendent à une défaite contre $rival. Ont-ils tort ?';
  }

  @override
  String pressBeatKeyPlayerWarm1(String player) {
    return '$player est en grande forme. Est-ce son moment ?';
  }

  @override
  String pressBeatKeyPlayerWarm2(String player) {
    return '$player fait tous les gros titres. Peut-il porter cette équipe ?';
  }

  @override
  String pressBeatKeyPlayerNeutral1(String player) {
    return 'À quel point cette campagne dépend-elle de $player ?';
  }

  @override
  String pressBeatKeyPlayerNeutral2(String player) {
    return '$player est-il prêt à mener cette équipe ?';
  }

  @override
  String pressBeatKeyPlayerHostile1(String player) {
    return 'Si $player n’est pas à son meilleur niveau, cette équipe a-t-elle autre chose ?';
  }

  @override
  String pressBeatKeyPlayerHostile2(String player) {
    return '$player a beaucoup sur les épaules. Trop ?';
  }

  @override
  String get pressReplyAimHigher1 =>
      'Nous irons plus loin que tout le monde ne le pense.';

  @override
  String get pressReplyAimHigher2 =>
      'Je veux plus que ce que la fédération demande, et je le dis haut et fort.';

  @override
  String get pressReplyMatchBrief1 =>
      'Nous connaissons l’objectif et nous l’atteindrons.';

  @override
  String get pressReplyMatchBrief2 =>
      'La fédération a fixé un objectif. Nous le remplirons.';

  @override
  String get pressReplyPlayDown1 =>
      'Nous prendrons les matchs les uns après les autres.';

  @override
  String get pressReplyPlayDown2 =>
      'Pas de grandes promesses. Nous verrons où nous en sommes.';

  @override
  String get pressReplyPromiseQualify1 =>
      'Nous allons nous qualifier. Vous pouvez l’écrire.';

  @override
  String get pressReplyPromiseQualify2 =>
      'Cette équipe sera à la phase finale.';

  @override
  String get pressReplyFearNobody1 => 'Nous ne craignons personne.';

  @override
  String get pressReplyFearNobody2 => 'Ils doivent aussi jouer contre nous.';

  @override
  String get pressReplyRespectRival1 =>
      'Ils sont favoris, et nous les respectons.';

  @override
  String get pressReplyRespectRival2 =>
      'Une très bonne équipe. Il faudra être au meilleur niveau.';

  @override
  String get pressReplyTeamFirst1 =>
      'C’est toute l’équipe qui compte, pas un seul joueur.';

  @override
  String get pressReplyTeamFirst2 => 'Personne ne gagne seul.';

  @override
  String pressOnRecordTarget(String aim) {
    return 'C’est enregistré : $aim.';
  }

  @override
  String get pressOnRecordPlayDown => 'C’est enregistré : aucune promesse.';

  @override
  String get pressThrowbackTargetKeptWarm =>
      'Vous aviez fixé un objectif avant la campagne et vous l’avez atteint. Votre plus grande fierté ?';

  @override
  String get pressThrowbackTargetKeptNeutral =>
      'Vous aviez dit ce que vous accompliriez, et vous l’avez fait. Avez-vous douté ?';

  @override
  String get pressThrowbackTargetKeptHostile =>
      'Vous avez atteint votre objectif. De la chance, ou c’était vraiment le plan ?';

  @override
  String get pressThrowbackTargetBrokenWarm =>
      'Vous aviez fixé un objectif et vous l’avez manqué. Qu’est-ce qui n’a pas marché ?';

  @override
  String get pressThrowbackTargetBrokenNeutral =>
      'Vous aviez promis plus que ce que l’équipe a donné. Le regrettez-vous ?';

  @override
  String get pressThrowbackTargetBrokenHostile =>
      'Vous aviez parlé fort avant la campagne et vous avez échoué. Pourquoi vous croire maintenant ?';

  @override
  String hubEventPressPreviewSub(String competition) {
    return 'La presse veut connaître vos objectifs : $competition';
  }

  @override
  String deptLevelCost(int level, String amount) {
    return 'Niveau $level · $amount';
  }

  @override
  String get formOnFire => 'En feu';

  @override
  String get formGood => 'En forme';

  @override
  String get formSteady => 'Régulier';

  @override
  String get formPoor => 'Hors de forme';

  @override
  String get formCold => 'Au fond du trou';

  @override
  String get playerFormTitle => 'FORME ET CONDITION';

  @override
  String playerFormAverage(String rating) {
    return 'Moyenne de $rating sur ses derniers matchs';
  }

  @override
  String get playerFormNoGames => 'Pas assez de matchs récents pour juger';

  @override
  String playerFormNextMatch(String delta) {
    return '$delta sur sa note au prochain match';
  }

  @override
  String get playerFormNoEffect => 'Aucun changement de note au prochain match';

  @override
  String get sideGroupHome => 'Accueil';

  @override
  String get sideGroupTeam => 'Équipe';

  @override
  String get sideGroupCompetitions => 'Compétitions';

  @override
  String get sideGroupFederation => 'Fédération';

  @override
  String get sideGroupHistory => 'Histoire';

  @override
  String get sideInbox => 'Boîte de réception';

  @override
  String get sideSquad => 'Effectif';

  @override
  String get sideTactics => 'Tactique';

  @override
  String get sideMainMenu => 'Menu principal';

  @override
  String get sideCallUps => 'Convocations';

  @override
  String get sideTournaments => 'Tournois';

  @override
  String get sideRanking => 'Classement';

  @override
  String get sideResults => 'Résultats';

  @override
  String get sideFinances => 'Finances';

  @override
  String get sideBoard => 'Direction';

  @override
  String get sideManager => 'Entraîneur et staff';

  @override
  String get sideRecords => 'Records';

  @override
  String get sideLegends => 'Légendes';

  @override
  String get sideHeadToHead => 'Face-à-face';

  @override
  String get sideAchievements => 'Succès';

  @override
  String get sideCareer => 'Carrière';

  @override
  String get topBarNext => 'Prochain';

  @override
  String get topBarDrawPending => 'Tirage à venir';

  @override
  String get paneFullProfile => 'Profil complet';

  @override
  String get panePickPlayer => 'Choisissez un joueur pour voir sa fiche ici';

  @override
  String get inboxPickMessage => 'Choisissez un message pour le lire ici';

  @override
  String get inboxFilterAll => 'Tous';

  @override
  String get panelViewAll => 'Tout voir';

  @override
  String get gridViewOverview => 'Vue d’ensemble';

  @override
  String get gridColCondition => 'Condition';

  @override
  String get gridColStatus => 'Statut';

  @override
  String get gridColRank => 'Rang';

  @override
  String get gridColMove => 'Évolution';

  @override
  String get gridColNation => 'Nation';

  @override
  String get gridColRegion => 'Région';

  @override
  String get gridColPoints => 'Points';

  @override
  String get panePickNation =>
      'Choisissez une nation pour voir son palmarès ici';

  @override
  String get resultsCyclesTitle => 'Cycles';

  @override
  String get tourDrawStart => 'Lancer le tirage';

  @override
  String get tourDrawViewGroups => 'Voir les groupes';

  @override
  String get gridColCeiling => 'Plafond';

  @override
  String get gridColYearGain => 'Progrès';

  @override
  String get gridColMarkedAt => 'Au repérage';

  @override
  String get budgetSetupTitle => 'Fixez votre budget';

  @override
  String get budgetEffectsTitle => 'Ce que ce budget apporte';

  @override
  String get naturalisationTitle => 'Naturalisation';

  @override
  String get yTrending => 'Tendances';

  @override
  String get yVoices => 'Voix';

  @override
  String get yConversation => 'Conversation';

  @override
  String get allTimeRecordsTitle => 'Records mondiaux de tous les temps';

  @override
  String get h2hMeetingsTitle => 'Toutes les confrontations';

  @override
  String get h2hPickOpponent =>
      'Choisissez un adversaire pour voir ici toutes les confrontations';

  @override
  String get savesTitle => 'Sauvegardes';

  @override
  String get gridColPlayer => 'Joueur';

  @override
  String get gridColPos => 'Poste';

  @override
  String get gridColActive => 'En activité';

  @override
  String get gridColMotm => 'HdM';

  @override
  String get gridColAvg => 'Moy.';

  @override
  String get gridColOpponent => 'Adversaire';

  @override
  String get gridColStarts => 'Titularisations';

  @override
  String get gridColTournaments => 'Tournois';

  @override
  String get gridColDate => 'Date';

  @override
  String get gridColLastPlayed => 'Dernière partie';

  @override
  String get gridColManager => 'Sélectionneur';

  @override
  String nationsShownCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sélections',
      one: '$count sélection',
    );
    return '$_temp0';
  }

  @override
  String get nationsSortedByRank => 'Classées par rang mondial';

  @override
  String get nationsStrength => 'Force';

  @override
  String nationsStrengthOf(int tier) {
    return '$tier sur 5';
  }

  @override
  String get nationsSquadOverall => 'Note de l\'effectif';

  @override
  String get nationsOpeningBudget => 'Budget de départ';

  @override
  String get nationsStarPlayer => 'Joueur vedette';

  @override
  String nationsStarTile(String position, int rating) {
    return 'Vedette $position $rating';
  }

  @override
  String nationsStarAge(int age) {
    return '$age ans';
  }

  @override
  String get nationsBoardExpects => 'La direction attend';

  @override
  String nationsManage(String nation) {
    return 'Prendre les rênes ($nation)';
  }

  @override
  String get nationsManagerNext => 'Vous nommerez votre sélectionneur ensuite';

  @override
  String get playerPageTitle => 'Joueur';

  @override
  String get nationPageTitle => 'Sélection';

  @override
  String get friendliesYourGames => 'Vos matchs amicaux';
}
