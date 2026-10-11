// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get matchPreviewTitle => 'PREVIA DEL PARTIDO';

  @override
  String get matchKickOff => 'Saque inicial';

  @override
  String get matchTactics => 'Táctica';

  @override
  String get matchYourXi => 'TU ONCE';

  @override
  String get matchHeadToHead => 'CARA A CARA';

  @override
  String matchCouldNotLoad(String error) {
    return 'No se pudo cargar el partido.\n$error';
  }

  @override
  String get matchNoUpcoming => 'No hay próximo partido.';

  @override
  String get matchUnknownNation => 'Desconocida';

  @override
  String get matchH2hFirstMeeting => 'Primer enfrentamiento de la historia';

  @override
  String get matchH2hYouLead => 'Dominas el cara a cara';

  @override
  String matchH2hOppEdge(String opponent) {
    return '$opponent lleva ventaja';
  }

  @override
  String get matchH2hEven => 'Igualdad total';

  @override
  String matchH2hMet(int count) {
    return '$count duelos';
  }

  @override
  String get matchH2hWon => 'Ganados';

  @override
  String get matchH2hDrawn => 'Empatados';

  @override
  String get matchH2hLost => 'Perdidos';

  @override
  String get matchDossierTitle => 'Informe de ojeador';

  @override
  String get matchDossierForm => 'FORMA';

  @override
  String get matchDossierNoGames => 'Sin partidos recientes';

  @override
  String get matchDossierKeyMen => 'HOMBRES CLAVE';

  @override
  String matchCouldNotContinue(String error) {
    return 'No se pudo continuar: $error';
  }

  @override
  String get matchSkipToFullTime => 'Saltar al final';

  @override
  String get matchStatShots => 'Tiros';

  @override
  String get matchStatGoals => 'Goles';

  @override
  String get matchStatYellowCards => 'Amarillas';

  @override
  String get matchStatRedCards => 'Rojas';

  @override
  String get matchMomentum => 'INERCIA';

  @override
  String get matchSwingAtk => 'ATQ';

  @override
  String get matchSwingDef => 'DEF';

  @override
  String ceremonyWorldCupYear(int year) {
    return 'CAMPEONATO DEL MUNDO $year';
  }

  @override
  String get ceremonyFinalsAreHere => 'LLEGA LA FASE FINAL';

  @override
  String ceremonyHostedBy(String hosts) {
    return 'ORGANIZA  $hosts';
  }

  @override
  String get ceremonyHostTbc => 'ANFITRIÓN POR CONFIRMAR';

  @override
  String get matchHalfTime => 'DESCANSO';

  @override
  String get matchContinue => 'Continuar';

  @override
  String get matchContinuing => 'Continuando…';

  @override
  String matchTacticsWithSubs(int used, int max) {
    return 'Táctica · $used/$max cambios';
  }

  @override
  String matchTiredCount(int count) {
    return 'CANSADOS ×$count';
  }

  @override
  String get matchTacticsLabel => 'TÁCTICA';

  @override
  String get teamOverallOverTime => 'MEDIA A LO LARGO DEL TIEMPO';

  @override
  String get teamOverall => 'Media';

  @override
  String get teamTalkHeading => 'CHARLA';

  @override
  String get teamTalkPrompt => 'Marca el tono para la segunda parte.';

  @override
  String get teamTalkCalmLabel => 'Cabeza fría';

  @override
  String get teamTalkCalmBlurb =>
      'Serena al equipo. Una pequeña mejora general.';

  @override
  String get teamTalkEncourageLabel => 'Animar';

  @override
  String get teamTalkEncourageBlurb => 'Adelante, a por el partido.';

  @override
  String get teamTalkDemandMoreLabel => 'Exigir más';

  @override
  String get teamTalkDemandMoreBlurb => 'Todo al ataque. Ataca con fuerza.';

  @override
  String get teamTalkPraiseLabel => 'Mantener el orden';

  @override
  String get teamTalkPraiseBlurb => 'Juntos atrás y a proteger lo que tienes.';

  @override
  String get teamTalkBelieveLabel => 'Creer';

  @override
  String get teamTalkBelieveBlurb =>
      'Confiad en vosotros. Un impulso en ambas áreas.';

  @override
  String get teamTalkFocusLabel => 'Máxima atención';

  @override
  String get teamTalkFocusBlurb => 'Concentración total. Cierra el partido.';

  @override
  String get teamTalkUrgencyLabel => 'Urgencia';

  @override
  String get teamTalkUrgencyBlurb =>
      'A por ello ya. Todo o nada, y deja huecos.';

  @override
  String get teamTalkReassureLabel => 'Sin presión';

  @override
  String get teamTalkReassureBlurb => 'Calma los nervios y mantén el orden.';

  @override
  String get commonRetry => 'Reintentar';

  @override
  String get commonSomethingWentWrong => 'Algo ha fallado';

  @override
  String get commonCrashBox =>
      'Algo ha fallado aquí.\nEn Ajustes → Diagnóstico tienes los detalles.';

  @override
  String hubCouldNotAdvance(String error) {
    return 'No se pudo avanzar el mundo: $error';
  }

  @override
  String get settingsDiagnosticsTitle => 'Diagnóstico';

  @override
  String get settingsDiagnosticsBlurb =>
      'Errores registrados en este dispositivo. No se envía nada a ningún sitio.';

  @override
  String get settingsContactTitle => 'Contacto';

  @override
  String get settingsContactCopied => 'Dirección copiada.';

  @override
  String get diagnosticsEmpty => 'No hay errores registrados. Así debe ser.';

  @override
  String get diagnosticsCopy => 'Copiar';

  @override
  String get diagnosticsCopied => 'Registro copiado al portapapeles.';

  @override
  String get diagnosticsClear => 'Borrar';

  @override
  String get navHub => 'Inicio';

  @override
  String get navSquad => 'Equipo';

  @override
  String get navStandings => 'Clasificación';

  @override
  String get navCareers => 'Mi carrera';

  @override
  String get settingsTitle => 'AJUSTES';

  @override
  String get settingsSoundHapticsTitle => 'Sonido y vibración';

  @override
  String get settingsSoundHapticsBlurb =>
      'Vibración y un breve tono en goles, saque inicial y final del partido.';

  @override
  String get settingsLanguageTitle => 'Idioma';

  @override
  String get settingsLanguageBlurb =>
      'Elige el idioma de la app o usa el del dispositivo.';

  @override
  String get settingsLanguageSystem => 'Sistema';

  @override
  String get matchPreviewAllMeetings => 'Todos los duelos';

  @override
  String get recordsMeetings => 'DUELOS';

  @override
  String get recordsLegends => 'LEYENDAS';

  @override
  String get recordsAllTimeXi => 'ONCE HISTÓRICO';

  @override
  String get recordsHallOfFame => 'SALÓN DE LA FAMA';

  @override
  String get recordsAllTimeWorld => 'HISTÓRICO MUNDIAL';

  @override
  String get recordsAllTimeTopScorers => 'MÁXIMOS GOLEADORES HISTÓRICOS';

  @override
  String get recordsMostCapped => 'MÁS INTERNACIONALIDADES';

  @override
  String get recordsMostWcStarts => 'MÁS PARTIDOS EN MUNDIALES';

  @override
  String get recordsMostTournaments => 'MÁS TORNEOS DISPUTADOS';

  @override
  String get recordsRecordBook => 'LIBRO DE RÉCORDS';

  @override
  String get recordsHeadToHead => 'CARA A CARA';

  @override
  String get recordsFiercestRival => 'GRAN RIVAL';

  @override
  String get recordsMostCaps => 'MÁS INTERNACIONALIDADES';

  @override
  String get recordsTopScorers => 'MÁXIMOS GOLEADORES';

  @override
  String get recordsMostAssists => 'MÁS ASISTENCIAS';

  @override
  String get recordsYourRecord => 'TU HISTORIAL';

  @override
  String get callUpHome => 'LOCAL';

  @override
  String get callUpAway => 'FUERA';

  @override
  String get recordsHome => 'LOCAL';

  @override
  String get recordsAway => 'VISITANTE';

  @override
  String get recordsActive => 'EN ACTIVO';

  @override
  String get recordsStillActive => 'En activo';

  @override
  String get recordsAvg => 'media';

  @override
  String get recordsSelect => 'Elegir';

  @override
  String get recordsVs => 'vs';

  @override
  String get recordsDraws => 'Empates';

  @override
  String get recordsGoalsLabel => 'Goles';

  @override
  String get recordsBestFinish => 'Mejor puesto';

  @override
  String get recordsNoFinalsYet => 'Aún sin fases finales';

  @override
  String get recordsLongestUnbeaten => 'Racha invicta más larga';

  @override
  String get recordsBiggestWin => 'Mayor victoria';

  @override
  String get recordsSeeAllMeetings => 'Ver todos los duelos';

  @override
  String get recordsSaveNotFound => 'Partida no encontrada.';

  @override
  String get recordsNoMatches => 'Sin resultados.';

  @override
  String get recordsSearchPlayerOrNation => 'Buscar jugador o selección';

  @override
  String get recordsSearchNation => 'Buscar selección';

  @override
  String get recordsPickTwoDifferent => 'Elige dos selecciones distintas.';

  @override
  String get recordsPlayToBuildRecord =>
      'Juega algunos partidos y aquí se irá formando tu historial contra cada rival.';

  @override
  String get recordsTapOpponent =>
      'Toca un rival para ver el desglose completo.';

  @override
  String get recordsEdgeUpperHand => 'Llevas la ventaja';

  @override
  String get recordsEdgeTheirNumber => 'Te tienen tomada la medida';

  @override
  String get recordsEdgeEven => 'Igualdad total';

  @override
  String get recordsAllTimeWorldSubtitle =>
      'Goleadores y más internacionales del mundo, todas las selecciones';

  @override
  String get recordsHeadToHeadSubtitle =>
      'Compara el historial de dos selecciones cualesquiera';

  @override
  String get recordsLegendsSubtitle => 'Once histórico y salón de la fama';

  @override
  String get recordsUnitGoals => 'goles';

  @override
  String get recordsUnitCaps => 'partidos';

  @override
  String get recordsUnitStarts => 'titularidades';

  @override
  String get recordsUnitCups => 'torneos';

  @override
  String get recordsUnitAssists => 'asistencias';

  @override
  String recordsCapsCount(int count) {
    return '$count partidos';
  }

  @override
  String recordsGoalsCount(int count) {
    return '$count goles';
  }

  @override
  String recordsAssistsCount(int count) {
    return '$count asistencias';
  }

  @override
  String recordsMotmCount(int count) {
    return '$count MVP';
  }

  @override
  String recordsMatchesCount(int count) {
    return '$count partidos';
  }

  @override
  String recordsMeetingsCount(int count) {
    return '$count duelos';
  }

  @override
  String recordsCodeWins(String code) {
    return 'Victorias $code';
  }

  @override
  String recordsMeetingsWdl(int meetings, int wins, int draws, int losses) {
    return '$meetings duelos · ${wins}G ${draws}E ${losses}P';
  }

  @override
  String recordsWdl(int wins, int draws, int losses) {
    return '${wins}G ${draws}E ${losses}P';
  }

  @override
  String recordsRivalLine(int meetings, String record, String edge) {
    return '$meetings duelos · $record · $edge';
  }

  @override
  String recordsNeverMet(String a, String b) {
    return '$a y $b nunca se han enfrentado en esta partida.';
  }

  @override
  String tacticsSentOffNote(String names) {
    return '$names expulsado(s). Sin sustituto posible, así que juegas con uno menos.';
  }

  @override
  String tacticsNeedFitPlayers(int required, int have) {
    return 'Necesitas $required disponibles ($have en forma)';
  }

  @override
  String tacticsMissesOfCamp(int missed, int total) {
    return 'Se pierde $missed/$total';
  }

  @override
  String get tacticsOutForWholeCamp => 'Baja para toda la convocatoria';

  @override
  String get rankingCentreOnMe => 'Centrar en mi selección';

  @override
  String get recordsAfterExtraTime => 'pró.';

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
    return '$played jugados · $gf–$ga';
  }

  @override
  String recordsBiggestWinValue(int gf, int ga, String opp) {
    return '$gf–$ga ante $opp';
  }

  @override
  String recordsCouldNotLoad(String error) {
    return 'No se pudo cargar.\n$error';
  }

  @override
  String recordsCouldNotLoadLegends(String error) {
    return 'No se pudieron cargar las leyendas.\n$error';
  }

  @override
  String recordsCouldNotLoadRecords(String error) {
    return 'No se pudieron cargar los récords.\n$error';
  }

  @override
  String recordsCouldNotLoadNations(String error) {
    return 'No se pudieron cargar las selecciones.\n$error';
  }

  @override
  String recordsCouldNotLoadYourRecord(String error) {
    return 'No se pudo cargar tu historial.\n$error';
  }

  @override
  String recordsCouldNotLoadRecord(String error) {
    return 'No se pudo cargar el historial.\n$error';
  }

  @override
  String recordsNoLegends(String nation) {
    return 'Aún no hay leyendas. Juega algunas campañas y aquí aparecerán los grandes de $nation.';
  }

  @override
  String recordsGreatestSide(String nation) {
    return 'El mejor equipo que $nation podría alinear jamás.';
  }

  @override
  String get recordsNoWorldHistory =>
      'El mundo aún no tiene historia. Juega algunas campañas y aquí aparecerán los mejores de todos los tiempos.';

  @override
  String recordsPlayToWriteHistory(String nation) {
    return 'Juega algunos partidos para empezar a escribir la historia de $nation.';
  }

  @override
  String get tacticsLineGk => 'POR';

  @override
  String get tacticsLineDef => 'DEF';

  @override
  String get tacticsLineMid => 'MED';

  @override
  String get tacticsLineFwd => 'DEL';

  @override
  String get tacticsGoalkeepers => 'PORTEROS';

  @override
  String get tacticsDefenders => 'DEFENSAS';

  @override
  String get tacticsMidfielders => 'CENTROCAMPISTAS';

  @override
  String get tacticsForwards => 'DELANTEROS';

  @override
  String get tacticsCallUpsTitle => 'CONVOCATORIA';

  @override
  String tacticsPickAtLeastPlayers(int min) {
    return 'Elige al menos $min jugadores.';
  }

  @override
  String tacticsCouldNotLoadSquad(String error) {
    return 'No se pudo cargar la plantilla.\n$error';
  }

  @override
  String get tacticsNoSquad => 'Sin plantilla.';

  @override
  String tacticsSquadCount(int count, int max) {
    return 'PLANTILLA · $count/$max';
  }

  @override
  String tacticsMinMax(int min, int max) {
    return 'Mín. $min · Máx. $max';
  }

  @override
  String get tacticsBestQuality => 'Los mejores';

  @override
  String get tacticsPreviousSquad => 'Lista anterior';

  @override
  String get tacticsSquadLockedBack => 'Volver (lista cerrada)';

  @override
  String get tacticsConfirmSquad => 'Confirmar lista';

  @override
  String tacticsSquadFullMax(int max) {
    return 'Lista completa (máx. $max)';
  }

  @override
  String get tacticsSquadLocked => 'LISTA CERRADA';

  @override
  String get tacticsNominationOpen => 'CONVOCATORIA ABIERTA. ELIGE TU LISTA';

  @override
  String get tacticsSquadFixedBlurb =>
      'Esta lista es fija para los partidos de abajo. Vuelve a elegir antes de la próxima convocatoria.';

  @override
  String get tacticsSquadWillPlayBlurb =>
      'Esta lista jugará los partidos de abajo.';

  @override
  String get tacticsUnknown => 'Desconocida';

  @override
  String tacticsAgeValue(int age, String value) {
    return '$age años · $value';
  }

  @override
  String get tacticsFatigueExhausted => 'Agotado';

  @override
  String get tacticsFatigueTired => 'Cansado';

  @override
  String get tacticsFatigueMatchLegs => 'Piernas cargadas';

  @override
  String tacticsTooManySubs(int max) {
    return 'Demasiados cambios (máx. $max).';
  }

  @override
  String tacticsMinuteTitle(int minute) {
    return 'TÁCTICA · $minute\'';
  }

  @override
  String get tacticsApply => 'APLICAR';

  @override
  String get tacticsTabLineupSubs => 'ONCE Y CAMBIOS';

  @override
  String get tacticsTabTactics => 'TÁCTICA';

  @override
  String get squadLineKeepers => 'PORTEROS';

  @override
  String get squadLineDefenders => 'DEFENSA';

  @override
  String get squadLineMidfielders => 'MEDIOCAMPO';

  @override
  String get squadLineForwards => 'ATAQUE';

  @override
  String get squadStatXiRating => 'Media del XI';

  @override
  String get squadStatAvgAge => 'Edad media';

  @override
  String get squadStatSize => 'Plantilla';

  @override
  String get squadStatUnavailable => 'Bajas';

  @override
  String get squadDepthTitle => 'FONDO POR LÍNEAS';

  @override
  String squadAgeShort(int age) {
    return '${age}a';
  }

  @override
  String get tacticsTabOtherPositions => 'OTROS PUESTOS';

  @override
  String get tacticsOutOfPositionNote => 'Fuera de su posición aquí';

  @override
  String get tacticsNobodyElse => 'No hay nadie más para probar aquí.';

  @override
  String get tacticsPickSomebodyFirst =>
      'Elige quién sale y aquí aparecerá el resto del banquillo, con el nivel que daría en este puesto.';

  @override
  String get tacticsTabSuitable => 'ADECUADOS';

  @override
  String get tacticsTabOnPitch => 'EN EL CAMPO';

  @override
  String tacticsSectionSuitable(int count) {
    return 'ADECUADOS · $count';
  }

  @override
  String get tacticsNobodySuits =>
      'Nadie del banquillo encaja de forma natural en este puesto, así que aquí están todos.';

  @override
  String tacticsSectionOnPitch(int count, int max) {
    return 'EN EL CAMPO · $count/$max';
  }

  @override
  String tacticsSectionAvailable(int count) {
    return 'DISPONIBLES · $count';
  }

  @override
  String get tacticsRowStarted => 'Titular';

  @override
  String tacticsRowCameOn(int minute) {
    return 'Entró en el $minute\'';
  }

  @override
  String get tacticsRowSubstitute => 'Entró';

  @override
  String get tacticsEnergyLabel => 'ENERGÍA';

  @override
  String tacticsPickReplacementFor(String name) {
    return 'Toca un sustituto para $name, o tócalo de nuevo para cancelar.';
  }

  @override
  String get tacticsSlotLostToRedCard =>
      'Una roja te ha costado este puesto. No se puede cubrir.';

  @override
  String get tacticsSentOffShort => 'EXPULSADO';

  @override
  String tacticsSubsUsed(int used, int max) {
    return 'CAMBIOS · $used/$max';
  }

  @override
  String get tacticsDragSubOn =>
      'Toca a un jugador del campo para sustituirlo, o mantén pulsado y arrastra un suplente sobre él.';

  @override
  String get tacticsNoSubs => 'No hay suplentes disponibles.';

  @override
  String get tacticsChooseShape => 'ELIGE UN SISTEMA';

  @override
  String get tacticsFormation => 'FORMACIÓN';

  @override
  String get tacticsInstructions => 'INSTRUCCIONES';

  @override
  String get tacticsDrilling => 'ASIMILACIÓN';

  @override
  String get tacticsDrillingUnplayed => 'SIN USAR';

  @override
  String get tacticsDrillingNew => 'NUEVO';

  @override
  String get tacticsDrillingSettling => 'ASENTÁNDOSE';

  @override
  String get tacticsDrillingDrilled => 'DOMINADO';

  @override
  String get matchInstructionsLocked =>
      'Se fijan antes del saque inicial. Puedes cambiar el sistema y hacer cambios, pero no rehacer tu planteamiento a mitad de partido.';

  @override
  String get tacticsInstrMentality => 'Mentalidad';

  @override
  String get tacticsInstrDefensive => 'Defensiva';

  @override
  String get tacticsInstrAttacking => 'Ofensiva';

  @override
  String get tacticsInstrPressing => 'Presión';

  @override
  String get tacticsInstrLowBlock => 'Bloque bajo';

  @override
  String get tacticsInstrHighPress => 'Presión alta';

  @override
  String get tacticsInstrTempo => 'Ritmo';

  @override
  String get tacticsInstrPatient => 'Paciente';

  @override
  String get tacticsInstrFast => 'Rápido';

  @override
  String get tacticsInstrWidth => 'Amplitud';

  @override
  String get tacticsInstrNarrow => 'Estrecho';

  @override
  String get tacticsInstrWide => 'Abierto';

  @override
  String get tacticsInstrDefLine => 'Línea def.';

  @override
  String get tacticsInstrDefensiveLine => 'Línea defensiva';

  @override
  String get tacticsInstrDeep => 'Hundida';

  @override
  String get tacticsInstrHigh => 'Adelantada';

  @override
  String get tacticsInstrDirectness => 'Verticalidad';

  @override
  String get tacticsInstrPossession => 'Posesión';

  @override
  String get tacticsInstrDirect => 'Directo';

  @override
  String get tacticsPickGoalkeeper => 'ELIGE PORTERO';

  @override
  String get tacticsPickLeftBack => 'ELIGE LATERAL IZQUIERDO';

  @override
  String get tacticsPickCentreBack => 'ELIGE CENTRAL';

  @override
  String get tacticsPickRightBack => 'ELIGE LATERAL DERECHO';

  @override
  String get tacticsPickDefensiveMid => 'ELIGE MEDIOCENTRO DEFENSIVO';

  @override
  String get tacticsPickCentralMid => 'ELIGE MEDIOCENTRO';

  @override
  String get tacticsPickAttackingMid => 'ELIGE MEDIAPUNTA';

  @override
  String get tacticsPickLeftMid => 'ELIGE INTERIOR IZQUIERDO';

  @override
  String get tacticsPickRightMid => 'ELIGE INTERIOR DERECHO';

  @override
  String get tacticsPickLeftWing => 'ELIGE EXTREMO IZQUIERDO';

  @override
  String get tacticsPickRightWing => 'ELIGE EXTREMO DERECHO';

  @override
  String get tacticsPickStriker => 'ELIGE DELANTERO CENTRO';

  @override
  String tacticsRoleOutOfPosition(String role) {
    return '$role · fuera de posición';
  }

  @override
  String tacticsAgeOnly(int age) {
    return '$age años';
  }

  @override
  String tacticsRoleAge(String role, int age) {
    return '$role · $age años';
  }

  @override
  String get tacticsOn => 'EN JUEGO';

  @override
  String get tacticsSquad => 'PLANTILLA';

  @override
  String get tacticsTabLineup => 'ALINEACIÓN';

  @override
  String get tacticsTabInstructions => 'INSTRUCCIONES';

  @override
  String get tacticsTabRoles => 'ROLES';

  @override
  String get tacticsTabSetPieces => 'BALÓN PARADO';

  @override
  String get tacticsTabRolesSetPieces => 'ROLES Y BALÓN PARADO';

  @override
  String get tacticsRolesSetPiecesBlurb =>
      'Da un rol a cada titular. Toca la insignia de penalti (⚽) o de falta (▲) para elegir lanzador.';

  @override
  String get tacticsTooltipCallUps => 'Convocatoria';

  @override
  String get tacticsTooltipPresets => 'Tácticas guardadas';

  @override
  String get tacticsTooltipInstructions => 'Instrucciones';

  @override
  String get tacticsNoTacticSet => 'No hay táctica definida.';

  @override
  String tacticsReplaceStarters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'SUSTITUYE A $count TITULARES',
      one: 'SUSTITUYE A $count TITULAR',
    );
    return '$_temp0';
  }

  @override
  String tacticsPlayerOut(String name, String reason) {
    return '$name: $reason';
  }

  @override
  String get tacticsOut => 'Baja';

  @override
  String get tacticsTapSpotReplace =>
      'Toca su puesto en el campo para elegir un sustituto.';

  @override
  String get tacticsTapOrDrag =>
      'Toca a un jugador para cambiarlo, o mantén pulsado y arrástralo para moverlo.';

  @override
  String get tacticsPlayerRoles => 'ROLES DE LOS JUGADORES';

  @override
  String get tacticsRolesBlurb =>
      'Dale una función a cada jugador: cazagoles, organizador, delantero de referencia. Decide quién marca y quién crea.';

  @override
  String get tacticsSetPieceTakers => 'LANZADORES';

  @override
  String get tacticsSetPieceBlurb =>
      'Quién tira los penaltis y las jugadas a balón parado, o déjaselo al más indicado.';

  @override
  String get tacticsTakerAuto => 'Automático';

  @override
  String get tacticsTakerQuickPick => 'Usar los mejores';

  @override
  String get tacticsPenalties => 'Penaltis';

  @override
  String get tacticsCornersFreeKicks => 'Córners y faltas';

  @override
  String get tacticsSkillFin => 'REM';

  @override
  String get tacticsSkillPas => 'PAS';

  @override
  String tacticsRolePlayer(String name) {
    return 'ROL · $name';
  }

  @override
  String get tacticsPenaltyTaker => 'LANZADOR DE PENALTIS';

  @override
  String get tacticsCornerFreeKickTaker => 'LANZADOR DE CÓRNERS Y FALTAS';

  @override
  String get tacticsAutomatic => 'Automático';

  @override
  String get tacticsLetBestSuited => 'Que lo lance el más indicado.';

  @override
  String get tacticsInXi => 'EN EL XI';

  @override
  String get tacticsTeamInstructions => 'INSTRUCCIONES DE EQUIPO';

  @override
  String get tacticsTeamInstructionsBlurb =>
      'Define cómo juega tu equipo. Cada ajuste influye en todo el bloque.';

  @override
  String tacticsSavedPreset(String name) {
    return 'Guardada “$name”';
  }

  @override
  String tacticsAppliedPreset(String name) {
    return 'Aplicada “$name”';
  }

  @override
  String get tacticsTacticPresets => 'TÁCTICAS GUARDADAS';

  @override
  String get tacticsPresetsBlurb =>
      'Guarda este sistema como un estilo reutilizable, o aplica uno que guardaste antes.';

  @override
  String get tacticsSaveCurrentTactic => 'Guardar táctica actual';

  @override
  String tacticsCouldNotLoadPresets(String error) {
    return 'No se pudieron cargar las tácticas guardadas.\n$error';
  }

  @override
  String get tacticsNoPresetsYet =>
      'Aún no hay tácticas guardadas. Toca “Guardar táctica actual” para guardar esta configuración como un estilo reutilizable.';

  @override
  String get tacticsNameThisTactic => 'Pon nombre a esta táctica';

  @override
  String get tacticsNameHint => 'p. ej. Presión alta 4-3-3';

  @override
  String get tacticsCancel => 'Cancelar';

  @override
  String get tacticsSave => 'Guardar';

  @override
  String get tacticsTapToAssign => 'Toca para asignar';

  @override
  String get tacticsHoldDragSub =>
      'Mantén pulsado un suplente y arrástralo sobre un jugador para meterlo.';

  @override
  String get hubContinue => 'Continuar';

  @override
  String get hubBrackets => 'Cuadros';

  @override
  String hubCouldNotLoad(String error) {
    return 'No se pudo cargar.\n$error';
  }

  @override
  String hubCouldNotLoadFinances(String error) {
    return 'No se pudieron cargar las finanzas.\n$error';
  }

  @override
  String hubCouldNotLoadSave(String error) {
    return 'No se pudo cargar la partida.\n$error';
  }

  @override
  String get hubSaveNotFound => 'Partida no encontrada.';

  @override
  String get hubUnknown => 'Desconocido';

  @override
  String hubWorldChampionsYear(int year) {
    return 'CAMPEONES DEL MUNDO $year';
  }

  @override
  String get hubCycleComplete => 'El ciclo ha terminado.';

  @override
  String get hubYourJob => 'TU CARGO';

  @override
  String get hubStayProject => 'Quedarte y seguir con tu proyecto';

  @override
  String get hubChooseNextJob => 'ELIGE TU PRÓXIMO DESTINO';

  @override
  String get hubOffersOnTable => 'OFERTAS SOBRE LA MESA';

  @override
  String hubOfferSubtitle(String tier, int position) {
    return '$tier · n.º $position mundial';
  }

  @override
  String hubContinueWith(String nation) {
    return 'Seguir con $nation';
  }

  @override
  String get hubYourNation => 'tu selección';

  @override
  String get hubTakeTheJob => 'Aceptar el cargo';

  @override
  String get hubFederationFinances => 'FINANZAS DE LA FEDERACIÓN';

  @override
  String get hubBudgetIntro =>
      'Tu primera tarea del próximo ciclo es fijar el presupuesto de la federación y repartirlo entre los departamentos.';

  @override
  String get hubStarting => 'Empezando…';

  @override
  String get hubBeginNextCycle => 'Empezar el próximo ciclo';

  @override
  String get hubContinueCareer => 'Continuar tu carrera';

  @override
  String get hubBackToSaves => 'Volver a tus partidas';

  @override
  String get hubOpeningBalance => 'Saldo inicial';

  @override
  String get hubCentralFunding => 'Financiación central';

  @override
  String get hubPrizeMoney => 'Premios';

  @override
  String get hubCommercialReturn => 'Ingresos comerciales';

  @override
  String get hubAvailableToInvest => 'Disponible para invertir';

  @override
  String hubReputation(String label, int rep) {
    return 'Reputación: $label ($rep)';
  }

  @override
  String get hubNationalHero => 'Héroe nacional';

  @override
  String get hubFinal => 'Final';

  @override
  String get hubStageRoundOf32 => 'Dieciseisavos de final';

  @override
  String get hubStageThirdPlace => 'Partido por el tercer puesto';

  @override
  String get hubEventAdvanceWorld => 'Avanzar el mundo';

  @override
  String hubEventStartCycle(int year) {
    return 'Empezar el ciclo $year';
  }

  @override
  String hubEventWorldChampions(String nation) {
    return '$nation es campeona del mundo';
  }

  @override
  String get hubEventSetBudget => 'Fija el presupuesto de la federación';

  @override
  String get hubEventSetBudgetSub =>
      'Reparte los fondos de este ciclo antes de que empiece la temporada';

  @override
  String get hubEventNaturalization => 'Revisar oferta de nacionalización';

  @override
  String get hubEventNaturalizationSub =>
      'Un jugador extranjero quiere cambiar de selección para jugar contigo';

  @override
  String get hubEventIntercontinentalPlayoff => 'La repesca intercontinental';

  @override
  String get hubEventWatchWcDraw => 'Ver el sorteo del Campeonato del Mundo';

  @override
  String get hubEventWorldCupHere => 'Llega el Campeonato del Mundo';

  @override
  String get hubEventWatchFinalsDraw => 'Ver el sorteo de la fase final';

  @override
  String get hubEventFinalsHere => 'Llega la fase final';

  @override
  String get hubEventPlayWcRound =>
      'Jugar la siguiente ronda del Campeonato del Mundo';

  @override
  String hubEventPlayCupMatch(String cup) {
    return 'Jugar el siguiente partido de $cup';
  }

  @override
  String get hubEventPlayNationsCupMatch =>
      'Jugar el siguiente partido de la Copa de las Naciones';

  @override
  String get hubEventWatchNationsCupDraw =>
      'Ver el sorteo de la Copa de las Naciones';

  @override
  String get hubEventWatchHostSelection => 'Ver la elección de sede';

  @override
  String get hubEventWatchQualifyingDraw => 'Ver el sorteo de la clasificación';

  @override
  String get hubEventWatchWcHostSelection =>
      'Ver la elección de sede del Campeonato del Mundo';

  @override
  String get hubEventWatchWcQualifyingDraw =>
      'Ver el sorteo de la clasificación del Campeonato del Mundo';

  @override
  String get hubEventArrangeFriendlies => 'Organizar amistosos';

  @override
  String hubEventFriendliesSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Aún no has cubierto tus $count fechas libres para amistosos',
      one: 'Aún no has cubierto tu fecha libre para un amistoso',
    );
    return '$_temp0';
  }

  @override
  String get hubEventReshapeXi => 'Rehaz tu once titular';

  @override
  String hubEventReshapeOutSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count de tu once están de baja (sancionados o lesionados). Elige a sus sustitutos',
      one:
          '1 de tu once está de baja (sancionado o lesionado). Elige a su sustituto',
    );
    return '$_temp0';
  }

  @override
  String hubEventReshapeShortSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'A tu once titular le faltan jugadores. Cubre los huecos',
      one: 'A tu once titular le falta un jugador. Cubre el hueco',
    );
    return '$_temp0';
  }

  @override
  String hubEventPlayOpponent(String opponent) {
    return 'Jugar contra $opponent';
  }

  @override
  String get hubEventContinentalFinalsFallback => 'la fase final continental';

  @override
  String get hubCallUpFriendlies => 'Da la lista para los amistosos';

  @override
  String get hubCallUpRequalify => 'Renueva tu lista para la clasificación';

  @override
  String get hubCallUpWorldCup => 'Da tu lista para el Campeonato del Mundo';

  @override
  String get hubCallUpFinals => 'Da tu lista para la fase final';

  @override
  String get hubCallUpNationsCup => 'Da tu lista para la Copa de las Naciones';

  @override
  String get hubCallUpQualifying => 'Da tu lista para la clasificación';

  @override
  String get hubCallUpGeneric => 'Da tu lista';

  @override
  String get hubHost => 'Anfitrión';

  @override
  String get hubGoldenBoot => 'Bota de Oro';

  @override
  String hubGoldenBootValue(String name, int goals) {
    return '$name · $goals goles';
  }

  @override
  String get hubPens => '(pen.)';

  @override
  String get hubNationalHub => 'CENTRO NACIONAL';

  @override
  String get hubMessages => 'Mensajes';

  @override
  String get hubWorldChampions => 'CAMPEONES DEL MUNDO';

  @override
  String get hubViewBracket => 'Ver cuadro ›';

  @override
  String get hubBoardDelighted => 'Encantada';

  @override
  String get hubBoardPleased => 'Satisfecha';

  @override
  String get hubBoardExpectingMore => 'Espera más';

  @override
  String get hubBoardConcerned => 'Preocupada';

  @override
  String get hubBoardJobAtRisk => 'Cargo en peligro';

  @override
  String get hubBoard => 'DIRECTIVA';

  @override
  String hubBoardObjective(String label) {
    return 'Objetivo de la directiva: $label';
  }

  @override
  String hubObjectiveMet(String result) {
    return 'CUMPLIDO · $result';
  }

  @override
  String hubObjectiveMissed(String result) {
    return 'NO CUMPLIDO · $result';
  }

  @override
  String get hubNoMoreFixtures => 'No quedan partidos en este ciclo.';

  @override
  String get hubNextMatch => 'PRÓXIMO PARTIDO';

  @override
  String get hubVs => 'VS';

  @override
  String hubWorldRank(int rank) {
    return '#$rank';
  }

  @override
  String get hubWorldRankLabel => 'Ranking mundial';

  @override
  String get hubSquadStatus => 'ESTADO DE LA PLANTILLA';

  @override
  String hubPlayers(int count) {
    return '$count jugadores';
  }

  @override
  String get hubAvgRating => 'Media';

  @override
  String get hubMorale => 'Moral';

  @override
  String get hubManageTeam => 'Gestionar equipo';

  @override
  String get hubGroupsToBeDrawn =>
      'Grupos por sortear. Mira el sorteo para descubrirlos.';

  @override
  String hubGroupName(String name) {
    return 'GRUPO $name';
  }

  @override
  String get hubTblTeam => 'EQUIPO';

  @override
  String get hubTblP => 'PJ';

  @override
  String get hubTblGd => 'DG';

  @override
  String get hubTblPts => 'PTS';

  @override
  String get homeSettings => 'Ajustes';

  @override
  String get homeLeadTheNation => 'LIDERA A LA NACIÓN';

  @override
  String get homeYourNation => 'tu selección';

  @override
  String get homeNewGame => 'Nueva partida';

  @override
  String get homeAllSaves => 'Todas las partidas';

  @override
  String get homeLoadGame => 'Cargar partida';

  @override
  String get homeContinue => 'CONTINUAR';

  @override
  String homeRoadToWorldCup(String date, int year) {
    return '$date · Camino al Campeonato del Mundo $year';
  }

  @override
  String get careerManageSaves => 'Gestionar partidas';

  @override
  String get careerNewGameTitle => 'NUEVA PARTIDA';

  @override
  String careerCouldNotLoadNation(String error) {
    return 'No se pudo cargar la selección.\n$error';
  }

  @override
  String get careerNationNotFound => 'Selección no encontrada.';

  @override
  String careerWorldRankNum(int rank) {
    return 'RANKING MUNDIAL #$rank';
  }

  @override
  String get careerManagerName => 'Nombre del seleccionador';

  @override
  String get careerManagerNameHint => 'p. ej. Alex Ferguson';

  @override
  String get careerBeginsBlurb =>
      'Tu carrera empieza en septiembre de 2026, camino del Campeonato del Mundo 2030.';

  @override
  String get careerFreeCycleNote =>
      'Gratis durante un ciclo completo de cuatro años: la clasificación, tu campeonato continental y el Campeonato del Mundo, en dos partidas. Después, un único pago desbloquea los ciclos infinitos.';

  @override
  String get careerStartCareer => 'Empezar carrera';

  @override
  String get careersTitle => 'CARRERAS';

  @override
  String get careerManagerCareer => 'Carrera de seleccionador';

  @override
  String get careerManagerCareerSubtitle =>
      'Cada ciclo que has dirigido y tu balance global';

  @override
  String get careerSummaryTitle => 'Resumen de carrera';

  @override
  String get careerSummarySubtitle =>
      'Tus vitrinas y tu historial como seleccionador';

  @override
  String get careerAchievements => 'Logros';

  @override
  String get careerAchievementsSubtitle =>
      'Hitos, títulos y satisfacción de la directiva';

  @override
  String get careerChallenges => 'Desafíos';

  @override
  String get careerChallengesSubtitle =>
      'Pruebas brutales para toda una carrera';

  @override
  String get careerTeamRecords => 'Récords del equipo';

  @override
  String get careerTeamRecordsSubtitle =>
      'Máximos goleadores y más partidos de la historia';

  @override
  String get careerMyMatches => 'Mis partidos';

  @override
  String get careerMyMatchesSubtitle => 'Cada resultado y próximo partido';

  @override
  String get careerTitle => 'CARRERA';

  @override
  String careerCouldNotLoadCareer(String error) {
    return 'No se pudo cargar la carrera.\n$error';
  }

  @override
  String get careerNoCareer => 'Sin carrera.';

  @override
  String get careerTrophyCabinet => 'VITRINA DE TROFEOS';

  @override
  String get careerTournamentHistory => 'HISTORIAL DE TORNEOS';

  @override
  String get careerNoTournamentsYet => 'Aún no has completado ningún torneo.';

  @override
  String get careerTeamFallback => 'Equipo';

  @override
  String careerWorldNum(int rank) {
    return 'MUNDIAL #$rank';
  }

  @override
  String careerPointsNum(int points) {
    return '$points PTS';
  }

  @override
  String careerSeasonNum(int season) {
    return 'TEMPORADA $season';
  }

  @override
  String get careerStatPlayedShort => 'PJ';

  @override
  String get careerStatsHeading => 'EN CIFRAS';

  @override
  String get careerStatsWinRate => '% de victorias';

  @override
  String get careerStatsGoalsFor => 'Goles a favor';

  @override
  String get careerStatsGoalsAgainst => 'Goles en contra';

  @override
  String get careerStatsGoalDiff => 'Dif. goles';

  @override
  String get careerStatsCleanSheets => 'Porterías a cero';

  @override
  String get careerStatsBiggestWin => 'Mayor victoria';

  @override
  String get careerStatsWinStreak => 'Racha de victorias';

  @override
  String get careerStatsUnbeaten => 'Racha invicta';

  @override
  String get careerStatsShootouts => 'Tandas de penaltis';

  @override
  String get careerStatsHatTricks => 'Hat-tricks';

  @override
  String get careerStatsMotms => 'Jugador del partido';

  @override
  String get careerStatsBestRating => 'Mejor nota';

  @override
  String get careerStatWonShort => 'G';

  @override
  String get careerStatDrawnShort => 'E';

  @override
  String get careerStatLostShort => 'P';

  @override
  String get careerStatGoalsForShort => 'GF';

  @override
  String get careerStatGoalsAgainstShort => 'GC';

  @override
  String get careerStatGoalDiffShort => 'DG';

  @override
  String get careerNoSilverware => 'Aún sin títulos. Ve a por uno.';

  @override
  String get careerMedalGold => 'ORO';

  @override
  String get careerMedalSilver => 'PLATA';

  @override
  String get careerMedalBronze => 'BRONCE';

  @override
  String careerWinnersName(String name) {
    return 'Campeón: $name';
  }

  @override
  String get careerSavesTitle => 'PARTIDAS';

  @override
  String careerCouldNotLoadSaves(String error) {
    return 'No se pudieron cargar las partidas.\n$error';
  }

  @override
  String careerSlotsCount(int used, int limit) {
    return 'HUECOS  $used/$limit';
  }

  @override
  String get careerThisSave => 'esta partida';

  @override
  String get careerSlotsFull => 'Huecos llenos';

  @override
  String careerSlotsUsed(int used) {
    return 'HUECOS  $used';
  }

  @override
  String get careerSlotsUnlockMore => 'Desbloquear más partidas';

  @override
  String get careerSlotsKeepNote =>
      'Todas las partidas que ya tienes siguen siendo jugables. Solo una nueva necesita el desbloqueo.';

  @override
  String get careerNewGame => 'Nueva partida';

  @override
  String get careerDeleteSaveTitle => '¿Borrar partida?';

  @override
  String careerDeleteSaveBody(String label) {
    return 'Esto borra para siempre tu carrera con $label.';
  }

  @override
  String get careerCancel => 'Cancelar';

  @override
  String get careerDelete => 'Borrar';

  @override
  String get careerNoSavesYet =>
      'Aún no hay partidas.\nEmpieza una nueva para dirigir a una selección.';

  @override
  String get careerUnknownNation => 'Desconocida';

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
    return 'Última vez: $when';
  }

  @override
  String get careerJustNow => 'justo ahora';

  @override
  String get careerYesterday => 'ayer';

  @override
  String careerMinutesAgo(int n) {
    return 'hace $n min';
  }

  @override
  String careerHoursAgo(int n) {
    return 'hace $n h';
  }

  @override
  String careerDaysAgo(int n) {
    return 'hace $n d';
  }

  @override
  String careerRoadToWorldCup(int year) {
    return 'Camino al Campeonato del Mundo $year';
  }

  @override
  String get careerManagerCareerTitle => 'CARRERA DE SELECCIONADOR';

  @override
  String careerCouldNotLoad(String error) {
    return 'No se pudo cargar.\n$error';
  }

  @override
  String get careerCycleByCycle => 'CICLO A CICLO';

  @override
  String careerCyclesNationsLed(int cycles, int nations) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles ciclos',
      one: '1 ciclo',
    );
    String _temp1 = intl.Intl.pluralLogic(
      nations,
      locale: localeName,
      other: '$nations selecciones dirigidas',
      one: '1 selección dirigida',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get careerStatTitles => 'Títulos';

  @override
  String get careerStatPlayed => 'Jugados';

  @override
  String get careerStatWon => 'Ganados';

  @override
  String get careerStatDrawn => 'Empatados';

  @override
  String get careerStatLost => 'Perdidos';

  @override
  String careerGoalsWinRate(
    int goalsFor,
    int goalsAgainst,
    String gd,
    int winRate,
  ) {
    return 'Goles $goalsFor–$goalsAgainst  ($gd)  ·  Victorias $winRate%';
  }

  @override
  String get careerRecordResults => 'RESULTADOS RÉCORD';

  @override
  String get careerBestWin => 'Mejor victoria';

  @override
  String get careerWorstDefeat => 'Peor derrota';

  @override
  String careerVsOpponentDate(String opponent, String date) {
    return 'ante $opponent · $date';
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
    return '${won}G ${drawn}E ${lost}P  ·  GF $goalsFor GC $goalsAgainst ($gd)';
  }

  @override
  String get careerWorldCupLabel => 'Campeonato del Mundo';

  @override
  String get careerContinentalLabel => 'Continental';

  @override
  String get messagesTitle => 'MENSAJES';

  @override
  String get messagesNoMessagesYet => 'Aún no hay mensajes.';

  @override
  String messagesCouldNotLoad(String error) {
    return 'No se pudieron cargar los mensajes.\n$error';
  }

  @override
  String get messagesDone => 'Hecho';

  @override
  String get messagesNext => 'Siguiente';

  @override
  String get rankingWorldRanking => 'RANKING MUNDIAL';

  @override
  String rankingCouldNotLoad(String error) {
    return 'No se pudo cargar el ranking.\n$error';
  }

  @override
  String get rankingNoRanking => 'Sin ranking.';

  @override
  String get rankingAll => 'TODAS';

  @override
  String get rankingYourTeam => 'TU EQUIPO';

  @override
  String get rankingYourRankingOverTime => 'TU RANKING A LO LARGO DEL TIEMPO';

  @override
  String rankingNowRank(int rank) {
    return 'ahora #$rank';
  }

  @override
  String rankingBestWorst(int best, int worst) {
    return 'mejor #$best · peor #$worst';
  }

  @override
  String get friendliesTitle => 'AMISTOSOS';

  @override
  String friendliesLoadError(String error) {
    return 'No se pudieron cargar los amistosos.\n$error';
  }

  @override
  String get friendliesContinue => 'Continuar';

  @override
  String friendliesArrangeIntro(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'las $count fechas libres',
      one: 'la fecha libre',
    );
    return 'Organiza partidos de preparación para $_temp0 antes de tu próximo partido oficial. Toca un rival o déjala libre.';
  }

  @override
  String get friendliesFree => 'Libre';

  @override
  String matchGoalsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count GOLES',
      one: '1 GOL',
    );
    return '$_temp0';
  }

  @override
  String get matchGoalsTitle => 'GOLES';

  @override
  String get matchGoalsNone => 'Sin goles';

  @override
  String get matchGoalPenalty => 'PEN';

  @override
  String get matchGoalSetPiece => 'ABP';

  @override
  String matchGoalAssist(String name) {
    return 'asist. $name';
  }

  @override
  String get friendliesHome => 'LOCAL';

  @override
  String get friendliesAway => 'FUERA';

  @override
  String get friendliesNoneThisWindow => 'Sin amistosos en esta fecha';

  @override
  String friendliesConfirmCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count amistosos',
      one: '1 amistoso',
    );
    return 'Confirmar $_temp0';
  }

  @override
  String get friendliesMonthJan => 'ene';

  @override
  String get friendliesMonthFeb => 'feb';

  @override
  String get friendliesMonthMar => 'mar';

  @override
  String get friendliesMonthApr => 'abr';

  @override
  String get friendliesMonthMay => 'may';

  @override
  String get friendliesMonthJun => 'jun';

  @override
  String get friendliesMonthJul => 'jul';

  @override
  String get friendliesMonthAug => 'ago';

  @override
  String get friendliesMonthSep => 'sep';

  @override
  String get friendliesMonthOct => 'oct';

  @override
  String get friendliesMonthNov => 'nov';

  @override
  String get friendliesMonthDec => 'dic';

  @override
  String get resultsMyMatches => 'MIS PARTIDOS';

  @override
  String resultsCouldNotLoad(String error) {
    return 'No se pudieron cargar los resultados.\n$error';
  }

  @override
  String get resultsNoFixtures => 'No hay partidos.';

  @override
  String get resultsVs => 'vs';

  @override
  String get resultsStageQualifier => 'CLASIFICACIÓN';

  @override
  String get resultsStageFriendly => 'AMISTOSO';

  @override
  String get resultsStageGroupStage => 'FASE DE GRUPOS';

  @override
  String get resultsStageSemiFinal => 'SEMIFINAL';

  @override
  String get resultsStageFinal => 'FINAL';

  @override
  String get resultsStageContinentalClash => 'DUELO CONTINENTAL';

  @override
  String get resultsStageFinalsGroup => 'GRUPO DE LA FASE FINAL';

  @override
  String get resultsStageRoundOf32 => 'DIECISEISAVOS';

  @override
  String get resultsStageRoundOf16 => 'OCTAVOS DE FINAL';

  @override
  String get resultsStageQuarterFinal => 'CUARTOS DE FINAL';

  @override
  String get resultsStageThirdPlace => 'TERCER PUESTO';

  @override
  String get matchSetupWarnCaptain =>
      'No hay capitán. Toca para darle el brazalete a alguien';

  @override
  String matchSetupWarnCaptainInjured(String name) {
    return '$name está lesionado y no puede capitanear este partido. Toca para pasar el brazalete';
  }

  @override
  String matchSetupWarnCaptainSuspended(String name) {
    return '$name está sancionado para este partido. Toca para pasar el brazalete';
  }

  @override
  String matchSetupWarnCaptainDropped(String name) {
    return '$name lleva el brazalete pero no está en tu lista. Toca para pasarlo';
  }

  @override
  String get matchSetupWarnSetPieces =>
      'No hay lanzadores designados. Toca para elegir quién tira';

  @override
  String get matchSetupWarnBoth =>
      'Sin capitán ni lanzadores. Toca para designarlos';

  @override
  String matchStageMatchday(int matchday) {
    return 'J$matchday';
  }

  @override
  String get squadCaptain => 'Capitán';

  @override
  String deptEffectYouth(int points) {
    return 'Los canteranos llegan con unos $points puntos más de media';
  }

  @override
  String deptEffectCommercial(String amount) {
    return '$amount de retorno al cierre del ciclo';
  }

  @override
  String deptEffectMedical(int percent) {
    return '$percent% menos lesiones';
  }

  @override
  String deptEffectNaturalisation(int percent) {
    return '$percent% de opciones de que un extranjero pida cambiar de selección';
  }

  @override
  String deptEffectBoard(int points) {
    return '+$points de paciencia de la directiva antes de que peligre tu puesto';
  }

  @override
  String get deptEffectNone => 'Sin efecto mientras no tenga fondos';

  @override
  String get statsBestRated => 'Notas';

  @override
  String get statsMyCareer => 'Carrera';

  @override
  String get statsBestAverageRating => 'MEJOR NOTA MEDIA';

  @override
  String get statsMyCareerRecord => 'TU BALANCE';

  @override
  String get statsNoRatingsRecorded =>
      'Aún no hay notas de partido registradas.';

  @override
  String get statsGroupRecord => 'Balance';

  @override
  String get statsGroupRuns => 'Rachas';

  @override
  String get statsGroupExtremes => 'Extremos';

  @override
  String get statsGroupSplits => 'Local y visitante';

  @override
  String get statsGroupSquad => 'Tus jugadores';

  @override
  String get statsPlayed => 'Partidos jugados';

  @override
  String get statsWinDrawLoss => 'Ganados–empatados–perdidos';

  @override
  String get statsWinRate => '% de victorias';

  @override
  String get statsGoals => 'Goles a favor:en contra';

  @override
  String get statsCleanSheets => 'Porterías a cero';

  @override
  String get statsFailedToScore => 'Sin marcar';

  @override
  String get statsLongestWinStreak => 'Racha más larga de victorias';

  @override
  String get statsLongestUnbeaten => 'Racha más larga invicto';

  @override
  String get statsLongestCleanSheets => 'Racha más larga a cero';

  @override
  String get statsLongestWinless => 'Racha más larga sin ganar';

  @override
  String get statsCurrentRun => 'Racha invicta actual';

  @override
  String get statsBiggestWin => 'Mayor victoria';

  @override
  String get statsHeaviestDefeat => 'Peor derrota';

  @override
  String get statsMostGoalsInAGame => 'Más goles en un partido';

  @override
  String get statsShootouts => 'Tandas ganadas–perdidas';

  @override
  String get statsComebackWins => 'Remontadas';

  @override
  String get statsHome => 'Local';

  @override
  String get statsAway => 'Visitante';

  @override
  String get statsNeutral => 'Neutral';

  @override
  String get statsCompetitive => 'Oficiales';

  @override
  String get statsFriendlies => 'Amistosos';

  @override
  String get statsHatTricks => 'Tripletes';

  @override
  String get statsBraces => 'Dobletes';

  @override
  String get statsMotms => 'Premios al mejor jugador';

  @override
  String get statsAssists => 'Asistencias';

  @override
  String get statsCards => 'Tarjetas';

  @override
  String get statsBestRating => 'Mejor nota individual';

  @override
  String statsAppsShort(int apps) {
    return '$apps part.';
  }

  @override
  String statsMotmShort(int motms) {
    return '$motms MVP';
  }

  @override
  String get captainArmband => 'C';

  @override
  String get captainCurrent => 'Capitán. Toca para quitarle el brazalete';

  @override
  String get captainFitBorn => 'Un líder nato';

  @override
  String get captainFitNatural => 'Un capitán natural';

  @override
  String get captainFitCapable => 'Podría llevarlo';

  @override
  String get captainFitUnproven => 'Aún no es un líder';

  @override
  String get captainNone => 'Sin capitán designado';

  @override
  String captainMoraleBoost(int morale) {
    return '+$morale de moral del grupo';
  }

  @override
  String get resultsCategoryWorldCupQualifying =>
      'Clasificación del Campeonato del Mundo';

  @override
  String get resultsCategoryFriendlies => 'Amistosos';

  @override
  String get resultsCategoryContinentalClash => 'Duelo Continental';

  @override
  String get resultsCategoryNationsCup => 'Copa de las Naciones';

  @override
  String get resultsCategoryContinentalCup => 'Copa Continental';

  @override
  String get resultsCategoryWorldCupQualifyingShort => 'Clas. Mundial';

  @override
  String get resultsCategoryContinentalQualifyingShort => 'Clas. Copa Cont.';

  @override
  String get resultsCategoryContinentalQualifying =>
      'Clasificación de la Copa Continental';

  @override
  String get resultsCategoryWorldCupFinals =>
      'Fase final del Campeonato del Mundo';

  @override
  String get resultsRoundResults => 'RESULTADOS DE LA JORNADA';

  @override
  String get resultsFriendlyInternationals => 'AMISTOSOS INTERNACIONALES';

  @override
  String get resultsKnockout => 'Eliminatoria';

  @override
  String resultsEarlierMatches(int count) {
    return 'Partidos anteriores ($count)';
  }

  @override
  String resultsMatchday(int matchday) {
    return 'JORNADA $matchday';
  }

  @override
  String get resultsContinue => 'Continuar';

  @override
  String resultsGroup(String name) {
    return 'GRUPO $name';
  }

  @override
  String get achievementsScreenTitle => 'LOGROS';

  @override
  String get achievementsChallengesTooltip => 'Desafíos';

  @override
  String get achievementsChallengesHeading => 'DESAFÍOS';

  @override
  String get achievementsBrutalTests =>
      'Pruebas brutales para toda una carrera';

  @override
  String achievementsCouldNotLoad(String error) {
    return 'No se pudo cargar.\n$error';
  }

  @override
  String achievementsUnlockedCount(int earned, int total) {
    return '$earned / $total desbloqueados';
  }

  @override
  String achievementsConqueredCount(int done, int total) {
    return '$done / $total superados';
  }

  @override
  String get achievementsBoardSatisfaction => 'SATISFACCIÓN DE LA DIRECTIVA';

  @override
  String achievementsUnlockedBanner(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count LOGROS DESBLOQUEADOS',
      one: 'LOGRO DESBLOQUEADO',
    );
    return '$_temp0';
  }

  @override
  String get achCatWins => 'Victorias';

  @override
  String get achCatMatches => 'Partidos';

  @override
  String get achCatQualifications => 'Clasificaciones';

  @override
  String get achCatTitles => 'Títulos';

  @override
  String get achCatMisc => 'Varios';

  @override
  String get achCatMega => 'Mega';

  @override
  String get achCatGoals => 'Goles';

  @override
  String get achCatStreaks => 'Rachas';

  @override
  String get achTierBronze => 'Bronce';

  @override
  String get achTierSilver => 'Plata';

  @override
  String get achTierGold => 'Oro';

  @override
  String get achTierPlatinum => 'Platino';

  @override
  String achGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count goles',
    );
    return '$_temp0';
  }

  @override
  String achGoalsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Marca $count goles.',
      one: 'Marca 1 gol.',
    );
    return '$_temp0';
  }

  @override
  String achCleanSheets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count porterías a cero',
    );
    return '$_temp0';
  }

  @override
  String achCleanSheetsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Deja la portería a cero $count veces.',
      one: 'Deja la portería a cero 1 vez.',
    );
    return '$_temp0';
  }

  @override
  String get achStreakWin5 => 'Costumbre de ganar';

  @override
  String get achStreakWin5Desc => 'Gana cinco partidos seguidos.';

  @override
  String get achStreakWin10 => 'En racha';

  @override
  String get achStreakWin10Desc => 'Gana diez partidos seguidos.';

  @override
  String get achStreakWin20 => 'Apisonadora';

  @override
  String get achStreakWin20Desc => 'Gana veinte partidos seguidos.';

  @override
  String get achUnbeaten15 => 'Difícil de batir';

  @override
  String get achUnbeaten15Desc => 'Encadena quince partidos invicto.';

  @override
  String get achUnbeaten30 => 'Intocable';

  @override
  String get achUnbeaten30Desc => 'Encadena treinta partidos invicto.';

  @override
  String get achHattrick => 'Héroe del triplete';

  @override
  String get achHattrickDesc => 'Que un jugador marque un triplete.';

  @override
  String get achMotm10 => 'Destacado';

  @override
  String get achMotm10Desc =>
      'Consigue 10 premios al mejor jugador del partido.';

  @override
  String get achMotm50 => 'Talismán';

  @override
  String get achMotm50Desc =>
      'Consigue 50 premios al mejor jugador del partido.';

  @override
  String get achPerfect => 'Diez perfecto';

  @override
  String get achPerfectDesc => 'Que un jugador logre una nota de 9,5 o más.';

  @override
  String get achShootout => 'Sangre fría';

  @override
  String get achShootoutDesc => 'Gana cinco tandas de penaltis.';

  @override
  String get achMassacre => 'Masacre';

  @override
  String get achMassacreDesc => 'Gana un partido por 7 goles o más.';

  @override
  String get achAnnihilation => 'Aniquilación';

  @override
  String get achAnnihilationDesc => 'Gana un partido por 10 goles o más.';

  @override
  String get chTierBronze => 'Bronce';

  @override
  String get chTierSilver => 'Plata';

  @override
  String get chTierGold => 'Oro';

  @override
  String get chTierLegendary => 'Legendario';

  @override
  String get chFirstSteps => 'En el banquillo';

  @override
  String get chFirstStepsDesc => 'Dirige durante 5 años.';

  @override
  String get chUnbeaten10 => 'En racha';

  @override
  String get chUnbeaten10Desc => 'Encadena 10 partidos oficiales invicto.';

  @override
  String get chTwoNations => 'Nuevo reto';

  @override
  String get chTwoNationsDesc => 'Dirige a 2 selecciones distintas.';

  @override
  String get chCont1 => 'Campeón continental';

  @override
  String get chCont1Desc => 'Gana un campeonato continental.';

  @override
  String get chNc1 => 'Campeón de la Copa de las Naciones';

  @override
  String get chNc1Desc => 'Gana la Copa de las Naciones.';

  @override
  String get chWc1 => 'Campeón del Mundo';

  @override
  String get chWc1Desc => 'Gana el Campeonato del Mundo.';

  @override
  String get chYears25 => 'Institución';

  @override
  String get chYears25Desc => 'Dirige durante 25 años.';

  @override
  String get chWc3 => 'Ganador en serie';

  @override
  String get chWc3Desc => 'Gana 3 Campeonatos del Mundo.';

  @override
  String get chWc5 => 'Dinastía';

  @override
  String get chWc5Desc => 'Gana 5 Campeonatos del Mundo.';

  @override
  String get chWc10 => 'Inmortal';

  @override
  String get chWc10Desc => 'Gana 10 Campeonatos del Mundo.';

  @override
  String get chWc2Teams => 'Con las botas a cuestas';

  @override
  String get chWc2TeamsDesc =>
      'Gana el Campeonato del Mundo con 2 selecciones distintas.';

  @override
  String get chWc3Teams => 'Trotamundos';

  @override
  String get chWc3TeamsDesc =>
      'Gana el Campeonato del Mundo con 3 selecciones distintas.';

  @override
  String get chWcStreak3 => 'Triplete histórico';

  @override
  String get chWcStreak3Desc => 'Gana 3 Campeonatos del Mundo seguidos.';

  @override
  String get chWcAllconf => 'Conquistador del mundo';

  @override
  String get chWcAllconfDesc =>
      'Gana el Campeonato del Mundo con una selección de cada confederación (6).';

  @override
  String get chCont5 => 'Rey continental';

  @override
  String get chCont5Desc => 'Gana 5 campeonatos continentales.';

  @override
  String get chContAll => 'Pleno de seis continentes';

  @override
  String get chContAllDesc =>
      'Gana el campeonato continental de cada confederación (6).';

  @override
  String get chTreble => 'Pleno';

  @override
  String get chTrebleDesc =>
      'Gana el Campeonato del Mundo, un título continental y la Copa de las Naciones en una misma carrera.';

  @override
  String get chNations10 => 'Nómada';

  @override
  String get chNations10Desc => 'Dirige a 10 selecciones distintas.';

  @override
  String get chYears100 => 'Centenario';

  @override
  String get chYears100Desc => 'Dirige durante 100 años.';

  @override
  String get chYears500 => 'Medio milenio';

  @override
  String get chYears500Desc => 'Dirige durante 500 años.';

  @override
  String get chYears1000 => 'Eterno';

  @override
  String get chYears1000Desc => 'Dirige durante 1000 años.';

  @override
  String get chGrandmaster => 'Gran maestro';

  @override
  String get chGrandmasterDesc =>
      'Gana 3 Campeonatos del Mundo Y 5 campeonatos continentales.';

  @override
  String get chUndefeated => 'Intocable';

  @override
  String get chUndefeatedDesc =>
      'Gana un Campeonato del Mundo sin perder ni un partido.';

  @override
  String get chPerfectQual => 'Paso impecable';

  @override
  String get chPerfectQualDesc =>
      'Gana todos los partidos de una fase de clasificación del Campeonato del Mundo.';

  @override
  String get chMinnow => 'Milagro del modesto';

  @override
  String get chMinnowDesc =>
      'Gana el Campeonato del Mundo con una selección fuera del top 32 del ranking mundial.';

  @override
  String get chGrandTour => 'En casa y fuera';

  @override
  String get chGrandTourDesc =>
      'Gana un Campeonato del Mundo como anfitrión y otro lejos de casa.';

  @override
  String get chUnbeaten25 => 'El muro';

  @override
  String get chUnbeaten25Desc => 'Encadena 25 partidos oficiales invicto.';

  @override
  String get chGoals10k => 'Máquina de goles';

  @override
  String get chGoals10kDesc => 'Marca 10.000 goles en tu carrera.';

  @override
  String get chCleanSheets500 => 'Fortaleza';

  @override
  String get chCleanSheets500Desc =>
      'Deja la portería a cero 500 veces en tu carrera.';

  @override
  String get chHatTricks25 => 'Costumbre de tripletes';

  @override
  String get chHatTricks25Desc => 'Que tus jugadores marquen 25 tripletes.';

  @override
  String get chWinStreak25 => 'Implacable';

  @override
  String get chWinStreak25Desc => 'Gana 25 partidos seguidos.';

  @override
  String get chCont10 => 'Dinastía continental';

  @override
  String get chCont10Desc => 'Gana 10 campeonatos continentales.';

  @override
  String get chPcWc => 'Campeón en serie';

  @override
  String chPcWcDesc(int count) {
    return 'Gana $count Campeonatos del Mundo en esta partida.';
  }

  @override
  String get chPcMajors => 'Coleccionista de trofeos';

  @override
  String chPcMajorsDesc(int count) {
    return 'Gana $count grandes títulos (Campeonato del Mundo, continental o Copa de las Naciones).';
  }

  @override
  String get chPcUnbeaten => 'Muro de hierro';

  @override
  String chPcUnbeatenDesc(int count) {
    return 'Encadena $count partidos oficiales invicto.';
  }

  @override
  String get chPcNations => 'Trotamundos';

  @override
  String chPcNationsDesc(int count) {
    return 'Dirige a $count selecciones distintas.';
  }

  @override
  String get chPcYears => 'Largo recorrido';

  @override
  String chPcYearsDesc(int count) {
    return 'Dirige durante $count años.';
  }

  @override
  String achWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count victorias',
      one: '1 victoria',
    );
    return '$_temp0';
  }

  @override
  String achWinsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Gana $count partidos.',
      one: 'Gana 1 partido.',
    );
    return '$_temp0';
  }

  @override
  String achMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count partidos',
    );
    return '$_temp0';
  }

  @override
  String achMatchesDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Juega $count partidos.',
      one: 'Juega 1 partido.',
    );
    return '$_temp0';
  }

  @override
  String get achQualWc => 'Clasificado para el Mundial';

  @override
  String get achQualWcDesc => 'Llega a la fase final del Campeonato del Mundo.';

  @override
  String get achQualCont => 'Clasificado continental';

  @override
  String get achQualContDesc =>
      'Llega a la fase final de tu campeonato continental.';

  @override
  String get achTitleWc => 'Campeones del Mundo';

  @override
  String get achTitleWcDesc => 'Gana el Campeonato del Mundo.';

  @override
  String get achTitleEuro => 'Campeones de Europa';

  @override
  String get achTitleEuroDesc => 'Gana el Campeonato de Europa.';

  @override
  String get achTitleCopa => 'Campeones de Sudamérica';

  @override
  String get achTitleCopaDesc => 'Gana la Copa de Sudamérica.';

  @override
  String get achTitleAfcon => 'Campeones de África';

  @override
  String get achTitleAfconDesc => 'Gana el Campeonato de África.';

  @override
  String get achTitleAsia => 'Campeones de Asia';

  @override
  String get achTitleAsiaDesc => 'Gana el Campeonato de Asia.';

  @override
  String get achTitleConcacaf => 'Campeones de Norteamérica';

  @override
  String get achTitleConcacafDesc => 'Gana la Copa de Norteamérica.';

  @override
  String get achTitleOfc => 'Campeones de Oceanía';

  @override
  String get achTitleOfcDesc => 'Gana la Copa de Oceanía.';

  @override
  String get achTitleNations => 'Campeones de la Copa de las Naciones';

  @override
  String get achTitleNationsDesc => 'Gana la Copa de las Naciones.';

  @override
  String get achTitleClash => 'Campeones del Duelo Continental';

  @override
  String get achTitleClashDesc => 'Gana el Duelo Continental.';

  @override
  String get achMarksman => 'Goleador mundialista';

  @override
  String get achMarksmanDesc =>
      'Que un jugador de tu plantilla marque 6 o más goles en la fase final del Campeonato del Mundo.';

  @override
  String get achSweep => 'Pleno';

  @override
  String get achSweepDesc =>
      'Ostenta el Campeonato del Mundo y tu título continental en una misma carrera.';

  @override
  String get achAllstar => 'En el once ideal';

  @override
  String get achAllstarDesc =>
      'Que un jugador entre en el once ideal de un Campeonato del Mundo.';

  @override
  String get achGoldenboot => 'Bota de Oro';

  @override
  String get achGoldenbootDesc =>
      'Que tu selección tenga al máximo goleador de un campeonato.';

  @override
  String get achDemolition => 'Demolición';

  @override
  String get achDemolitionDesc => 'Gana un partido por 5 goles o más.';

  @override
  String get achievementsNice => '¡Genial!';

  @override
  String get achievementsHardestTests =>
      'Las pruebas más duras para un seleccionador, a lo largo de toda una carrera y muchas selecciones.';

  @override
  String get achievementsThisSave => 'ESTA PARTIDA';

  @override
  String get achievementsBrutalBadge => 'BRUTAL';

  @override
  String get paywallGoPro => 'PÁSATE A ILIMITADO';

  @override
  String get paywallOneTimeUnlock => 'Pago único. Sin suscripción.';

  @override
  String get paywallBenefitCarryOn =>
      'Esta partida continúa justo donde se quedó, con cada internacionalidad, récord y rivalidad intactos.';

  @override
  String get paywallBenefitNoAds =>
      'Sin anuncios, sin microtransacciones, sin suscripción. Un solo pago y todas las actualizaciones futuras son tuyas.';

  @override
  String get paywallBenefitSaves =>
      'Tantas partidas como quieras. Lleva a una favorita y a una modesta a la vez y descubre lo distinto que se lee el mismo juego.';

  @override
  String get paywallBenefitEndless =>
      'Todos los ciclos a partir de ahora. Apuesta hoy por un chaval de diecisiete años y descubre en 2034 si tenías razón.';

  @override
  String get paywallUnlocked => 'Ilimitado está desbloqueado. ¡Disfruta!';

  @override
  String get paywallContactingStore => 'Conectando con la tienda…';

  @override
  String paywallUnlockProPriced(String price) {
    return 'Desbloquear Ilimitado · $price';
  }

  @override
  String get paywallRestorePurchases => 'Restaurar compras';

  @override
  String get paywallStoreUnavailable => 'Tienda no disponible';

  @override
  String get paywallStoreUnavailableNote =>
      'No se pudo cargar el precio. Comprueba tu conexión y vuelve a intentarlo.';

  @override
  String get paywallTryAgain => 'Reintentar';

  @override
  String get gateTitle => 'TU PRIMER CICLO HA TERMINADO';

  @override
  String get gateLead =>
      'Cuatro años son un ciclo. No es tiempo suficiente para saber si tenías razón.';

  @override
  String get gatePriceLead => 'Un solo pago, para siempre';

  @override
  String get gateBuy => 'COMPRAR Y CONTINUAR';

  @override
  String get gateExit => 'SALIR';

  @override
  String get federationNaturalisation => 'NACIONALIZACIÓN';

  @override
  String federationNaturalisedTitle(String name) {
    return '$name, nacionalizado';
  }

  @override
  String federationNaturalisedBody(String name, String nation) {
    return '$name ha completado el cambio y ya puede jugar con $nation. Convócalo desde la convocatoria.';
  }

  @override
  String federationCouldNotLoadOffer(String error) {
    return 'No se pudo cargar la oferta.\n$error';
  }

  @override
  String get federationContinue => 'Continuar';

  @override
  String get federationOfferToSwitchAllegiance =>
      'UNA OFERTA PARA CAMBIAR DE SELECCIÓN';

  @override
  String federationPlayerMeta(String position, int age, String nation) {
    return '$position · $age años · de $nation';
  }

  @override
  String federationNaturalisationBlurb(
    String name,
    String playerNation,
    String sourceNation,
  ) {
    return '$name tiene vínculos con $playerNation y está dispuesto a nacionalizarse. Si aceptas, podrás convocarlo; si rechazas, seguirá con $sourceNation.';
  }

  @override
  String get federationDecline => 'Rechazar';

  @override
  String get federationNaturalise => 'Nacionalizar';

  @override
  String get federationBudgetLater => 'Decidir más tarde';

  @override
  String get federationSetYourBudget => 'FIJA TU PRESUPUESTO';

  @override
  String federationCouldNotLoadFinances(String error) {
    return 'No se pudieron cargar las finanzas.\n$error';
  }

  @override
  String get federationSaveNotFound => 'Partida no encontrada.';

  @override
  String get federationBudgetHeading => 'PRESUPUESTO DE LA FEDERACIÓN';

  @override
  String federationDistributeBudget(String amount) {
    return 'Reparte $amount entre los departamentos para abrir el ciclo. Gástalo con cabeza.';
  }

  @override
  String federationOverBudget(String amount) {
    return '$amount más de lo que tiene la federación. Recorta algo';
  }

  @override
  String get federationAllocateFullBudget =>
      'Asigna todo el presupuesto para empezar el ciclo.';

  @override
  String get federationConfirming => 'Confirmando…';

  @override
  String get federationConfirmBudget => 'Confirmar presupuesto';

  @override
  String get federationFinances => 'FINANZAS';

  @override
  String get federationInvestmentUpdated => 'Inversión actualizada.';

  @override
  String get federationDevelopment => 'DESARROLLO DE LA FEDERACIÓN';

  @override
  String get federationProjectedAtSeasonEnd => 'PREVISIÓN A FINAL DE TEMPORADA';

  @override
  String get federationCentralFunding => 'Financiación central';

  @override
  String get federationPrizeMoneySoFar => 'Premios hasta ahora';

  @override
  String get federationCommercialReturn => 'Retorno comercial';

  @override
  String get federationThisSeasonLocked => 'ESTA TEMPORADA (BLOQUEADA)';

  @override
  String get federationInvestForNextSeason =>
      'INVIERTE PARA LA PRÓXIMA TEMPORADA';

  @override
  String get federationNextSeasonImpact => 'IMPACTO LA PRÓXIMA TEMPORADA';

  @override
  String get federationSaving => 'Guardando…';

  @override
  String get federationConfirmInvestment => 'Confirmar inversión';

  @override
  String get federationBalance => 'SALDO DE LA FEDERACIÓN';

  @override
  String get federationCommittedToStaff => 'Comprometido con el cuerpo técnico';

  @override
  String get federationFreeToSpend => 'Disponible';

  @override
  String get federationWagesNote =>
      'Los sueldos se descuentan del saldo al final del ciclo, así que esta parte ya está comprometida.';

  @override
  String get federationInvestAtCeremony =>
      'Invierte para la próxima temporada en la ceremonia de fin de ciclo.';

  @override
  String federationLevelBadge(int level) {
    return 'N$level';
  }

  @override
  String get federationAcademyProspects => 'Promesas de la cantera';

  @override
  String federationPlusOverall(int value) {
    return '+$value de media';
  }

  @override
  String get federationInjuryRisk => 'Riesgo de lesión';

  @override
  String get federationNaturalisationChance => 'Opción de nacionalización';

  @override
  String get federationBoardPatience => 'Paciencia de la directiva';

  @override
  String get federationUnallocated => 'SIN ASIGNAR';

  @override
  String get nationsVitrineTitle => 'VITRINA NACIONAL';

  @override
  String nationsCouldNotLoad(String error) {
    return 'No se pudo cargar la selección.\n$error';
  }

  @override
  String get nationsNoNation => 'Sin selección.';

  @override
  String get nationsHonours => 'PALMARÉS';

  @override
  String get nationsRankingHistory => 'HISTORIAL EN EL RANKING MUNDIAL';

  @override
  String get nationsTopScorers => 'MÁXIMOS GOLEADORES HISTÓRICOS';

  @override
  String get nationsTitles => 'TÍTULOS';

  @override
  String get nationsYourTeam => 'TU EQUIPO';

  @override
  String get nationsWorld => 'MUNDO';

  @override
  String get nationsWorldCup => 'Campeonato del Mundo';

  @override
  String get nationsContinental => 'Continental';

  @override
  String nationsAppearances(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count participaciones',
      one: '1 participación',
    );
    return '$_temp0';
  }

  @override
  String get nationsNotEnoughHistory =>
      'Aún no hay suficiente historial. Vuelve dentro de un ciclo o dos.';

  @override
  String nationsBestRank(int rank) {
    return 'Mejor: #$rank';
  }

  @override
  String nationsNowRank(int rank) {
    return 'Ahora: #$rank';
  }

  @override
  String get nationsNoGoals => 'Aún no hay goles registrados.';

  @override
  String get nationsGoalsAbbrev => 'goles';

  @override
  String get nationsHosts => 'ANFITRIÓN';

  @override
  String get nationsSelectTitle => 'ELIGE SELECCIÓN';

  @override
  String nationsCouldNotLoadNations(String error) {
    return 'No se pudieron cargar las selecciones.\n$error';
  }

  @override
  String get nationsNoMatch => 'Ninguna selección coincide.';

  @override
  String get nationsNationalLevel => 'NIVEL NACIONAL';

  @override
  String get nationsSelectHeading => 'Elige selección';

  @override
  String get nationsSearchHint => 'Buscar país…';

  @override
  String get nationsRank => 'PUESTO ';

  @override
  String get nationsPremium => 'PREMIUM';

  @override
  String get nationsSelect => 'ELEGIR';

  @override
  String get statsTeamRecords => 'RÉCORDS DEL EQUIPO';

  @override
  String get statsRecordBook => 'Libro de récords';

  @override
  String statsCouldNotLoadStats(String error) {
    return 'No se pudieron cargar las estadísticas.\n$error';
  }

  @override
  String get statsNoData => 'Sin datos.';

  @override
  String get statsTopScorers => 'MÁXIMOS GOLEADORES';

  @override
  String get statsMostGamesPlayed => 'MÁS PARTIDOS JUGADOS';

  @override
  String get statsTeam => 'Equipo';

  @override
  String get statsTopScorersShort => 'Goleadores';

  @override
  String get statsMostGames => 'Más partidos';

  @override
  String get statsNoGoalsRecorded => 'Aún no hay goles registrados.';

  @override
  String get statsUnknown => 'Desconocido';

  @override
  String get playerTitle => 'JUGADOR';

  @override
  String playerLoadError(String error) {
    return 'No se pudo cargar el jugador.\n$error';
  }

  @override
  String get playerNotFound => 'Jugador no encontrado.';

  @override
  String get playerClub => 'CLUB';

  @override
  String get playerClubRole => 'En su club';

  @override
  String get playerPosition => 'Posición';

  @override
  String get playerPotential => 'Potencial';

  @override
  String get playerAge => 'Edad';

  @override
  String get playerValue => 'Valor';

  @override
  String get clubFirstChoice => 'Juega cada semana';

  @override
  String get clubRotation => 'Entra y sale';

  @override
  String get clubFringe => 'Apenas juega';

  @override
  String get clubFrozenOut => 'No juega';

  @override
  String clubAtClub(String club, String standing) {
    return '$club: $standing';
  }

  @override
  String yWinUpset0(String opponent, String score) {
    return 'Llevo treinta años viendo fútbol y esto no lo vi venir. $opponent, derrotado $score.';
  }

  @override
  String yWinUpset1(String opponent, String score) {
    return 'Nadie daba un duro por ellos contra $opponent. $score. Absolutamente nadie.';
  }

  @override
  String yWinUpset2(String opponent, String score) {
    return '$score contra $opponent. Id a despertar a los vecinos.';
  }

  @override
  String yWinUpset3(String opponent, String score) {
    return 'Es de esas noches que se cuentan a los nietos. $opponent $score.';
  }

  @override
  String yWinUpset4(String opponent, String score) {
    return '$score contra $opponent. Como haya pasado, ha pasado.';
  }

  @override
  String yWinUpset5(String opponent, String score) {
    return 'Sobre el papel esto estaba sentenciado antes de empezar. $opponent $score dice lo contrario.';
  }

  @override
  String yWinUpset6(String opponent, String score) {
    return 'Ganamos a $opponent $score. Dentro de un año nadie se creerá ese marcador.';
  }

  @override
  String yWinUpset7(String opponent, String score) {
    return '$opponent $score. Disfrutadlo y luego mirad el calendario.';
  }

  @override
  String yWinUpset8(String opponent, String score) {
    return '$score contra $opponent, y tiramos de suerte durante ochenta de los noventa minutos.';
  }

  @override
  String yWinUpset9(String opponent, String score) {
    return 'Una noche contra $opponent no borra un año entero. $score.';
  }

  @override
  String yWinUpset10(String opponent, String score) {
    return 'Ganamos a $opponent $score y ahora nos dirán que hemos pasado página. No es así.';
  }

  @override
  String yWinUpset11(String opponent, String score) {
    return '$opponent $score. Precioso. Pregúntame otra vez cuando importe.';
  }

  @override
  String yWinRoutine0(String opponent, String score) {
    return 'Ganamos a $opponent $score. Tal y como debe ser, y eso también tiene su gusto.';
  }

  @override
  String yWinRoutine1(String opponent, String score) {
    return '$score a $opponent. Implacables, y lo digo como un elogio.';
  }

  @override
  String yWinRoutine2(String opponent, String score) {
    return '$opponent $score. Sin líos, sin sustos, sin quejas.';
  }

  @override
  String yWinRoutine3(String opponent, String score) {
    return 'Un $score limpio contra $opponent. Así es un buen equipo en un día tranquilo.';
  }

  @override
  String yWinRoutine4(String opponent, String score) {
    return '$score contra $opponent. Trabajo hecho, nada aprendido.';
  }

  @override
  String yWinRoutine5(String opponent, String score) {
    return 'Ganamos a $opponent $score. Tocaba, y se hizo.';
  }

  @override
  String yWinRoutine6(String opponent, String score) {
    return 'Un $score profesional a $opponent. Siguiente.';
  }

  @override
  String yWinRoutine7(String opponent, String score) {
    return '$opponent, despachado $score. Al archivo y a otra cosa.';
  }

  @override
  String yWinRoutine8(String opponent, String score) {
    return '$score contra $opponent y se supone que hay que aplaudir. Por ganarles a ellos.';
  }

  @override
  String yWinRoutine9(String opponent, String score) {
    return 'Enhorabuena a todos los implicados en el $score a $opponent, supongo.';
  }

  @override
  String yWinRoutine10(String opponent, String score) {
    return '$opponent $score. Ganar a equipos así es el mínimo, no una hazaña.';
  }

  @override
  String yWinRoutine11(String opponent, String score) {
    return 'Ganamos a $opponent $score y se nos vio sufriendo para hacerlo.';
  }

  @override
  String yWinTight0(String opponent, String score) {
    return '$score contra $opponent y cada minuto bien ganado.';
  }

  @override
  String yWinTight1(String opponent, String score) {
    return 'Eso ha requerido carácter. $opponent $score.';
  }

  @override
  String yWinTight2(String opponent, String score) {
    return 'Ganamos a $opponent $score por la vía difícil, que es la que perdura.';
  }

  @override
  String yWinTight3(String opponent, String score) {
    return '$score contra $opponent. Los equipos que ganan estos partidos son los que siguen vivos en junio.';
  }

  @override
  String yWinTight4(String opponent, String score) {
    return 'Con nervios, feo y con victoria. $opponent $score.';
  }

  @override
  String yWinTight5(String opponent, String score) {
    return 'Ganamos a $opponent $score. Coge los tres puntos y no lo vuelvas a ver nunca.';
  }

  @override
  String yWinTight6(String opponent, String score) {
    return '$score. $opponent nos hizo sudar cada centímetro.';
  }

  @override
  String yWinTight7(String opponent, String score) {
    return '$opponent $score. No fue bonito. Cuenta igual.';
  }

  @override
  String yWinTight8(String opponent, String score) {
    return '$score contra $opponent y lo hicimos diez veces más difícil de lo que era.';
  }

  @override
  String yWinTight9(String opponent, String score) {
    return 'No deberíamos estar agarrándonos al partido contra $opponent. $score.';
  }

  @override
  String yWinTight10(String opponent, String score) {
    return '$opponent $score. Ganado, y no hemos aprendido nada bueno de nosotros mismos.';
  }

  @override
  String yWinTight11(String opponent, String score) {
    return 'Un $score contra $opponent que nos hizo un favor.';
  }

  @override
  String yDrew0(String opponent, String score) {
    return 'Un punto contra $opponent, $score. Se coge y a otra cosa.';
  }

  @override
  String yDrew1(String opponent, String score) {
    return '$score con $opponent. Hay tardes peores que esta.';
  }

  @override
  String yDrew2(String opponent, String score) {
    return 'Empate $score con $opponent. No todo tiene que ser una historia.';
  }

  @override
  String yDrew3(String opponent, String score) {
    return '$opponent $score. Un punto es un punto y la clasificación no pregunta cómo.';
  }

  @override
  String yDrew4(String opponent, String score) {
    return '$score con $opponent. Dos puntos perdidos o uno ganado. Elige tu humor.';
  }

  @override
  String yDrew5(String opponent, String score) {
    return 'Empate contra $opponent, $score. Nadie contento, nadie furioso.';
  }

  @override
  String yDrew6(String opponent, String score) {
    return '$opponent $score. Los noventa minutos más olvidables del año.';
  }

  @override
  String yDrew7(String opponent, String score) {
    return 'Reparto de puntos con $opponent, $score. Seguimos.';
  }

  @override
  String yDrew8(String opponent, String score) {
    return '$score contra $opponent. Así, con empates como este, mueren en silencio las campañas.';
  }

  @override
  String yDrew9(String opponent, String score) {
    return 'Dos puntos tirados contra $opponent. $score. No hay otra forma de llamarlo.';
  }

  @override
  String yDrew10(String opponent, String score) {
    return '$opponent $score. Tuvimos noventa minutos y ni idea de qué hacer con ellos.';
  }

  @override
  String yDrew11(String opponent, String score) {
    return 'Un $score con $opponent que nadie recordará y que todos pagaremos.';
  }

  @override
  String yLost0(String opponent, String score) {
    return 'Derrota $score ante $opponent. Son cosas que pasan.';
  }

  @override
  String yLost1(String opponent, String score) {
    return '$opponent $score. Nada por lo que crucificar a nadie. A por el siguiente.';
  }

  @override
  String yLost2(String opponent, String score) {
    return 'Perdimos $score con $opponent dándolo todo. Hay días que no basta.';
  }

  @override
  String yLost3(String opponent, String score) {
    return '$score ante $opponent. Cabeza alta. A este equipo le queda mucho.';
  }

  @override
  String yLost4(String opponent, String score) {
    return '$opponent $score. Fuimos inferiores y no hay discusión.';
  }

  @override
  String yLost5(String opponent, String score) {
    return 'Perdimos $score con $opponent. A reagruparse.';
  }

  @override
  String yLost6(String opponent, String score) {
    return '$score ante $opponent. No es una vergüenza, pero no basta.';
  }

  @override
  String yLost7(String opponent, String score) {
    return 'Derrota $score ante $opponent. O aprendemos algo o habrá sido en balde.';
  }

  @override
  String yLost8(String opponent, String score) {
    return '$score ante $opponent y no les hicimos ni cosquillas.';
  }

  @override
  String yLost9(String opponent, String score) {
    return 'Perdimos con $opponent, $score. Los mismos problemas, el mismo mes, las mismas excusas en camino.';
  }

  @override
  String yLost10(String opponent, String score) {
    return '$opponent $score. ¿En qué momento deja esto de ser mala suerte?';
  }

  @override
  String yLost11(String opponent, String score) {
    return 'Derrota $score ante $opponent. Un resultado así le debería costar algo a alguien.';
  }

  @override
  String yLostBadly0(String opponent, String score) {
    return '$score ante $opponent. Una mala noche. Juzgad al equipo por la campaña, no por esto.';
  }

  @override
  String yLostBadly1(String opponent, String score) {
    return 'Nadie quería ese $score contra $opponent menos que los jugadores.';
  }

  @override
  String yLostBadly2(String opponent, String score) {
    return '$opponent $score. Feo, y este equipo no es eso.';
  }

  @override
  String yLostBadly3(String opponent, String score) {
    return 'Un $score para olvidar contra $opponent. La próxima vez darán la cara.';
  }

  @override
  String yLostBadly4(String opponent, String score) {
    return '$score. Ante $opponent. Me quedo sin palabras y me pagan por tenerlas.';
  }

  @override
  String yLostBadly5(String opponent, String score) {
    return '$opponent $score. Alguien tiene que dar explicaciones.';
  }

  @override
  String yLostBadly6(String opponent, String score) {
    return 'Quiero que el $score contra $opponent se borre de los registros y de la memoria.';
  }

  @override
  String yLostBadly7(String opponent, String score) {
    return 'Derrota $score ante $opponent. Un marcador así no hay quien lo maquille.';
  }

  @override
  String yLostBadly8(String opponent, String score) {
    return 'Eso no fue una derrota ante $opponent, fue una rendición. $score.';
  }

  @override
  String yLostBadly9(String opponent, String score) {
    return '$score. Contra $opponent. Hubo gente que pagó por ver eso.';
  }

  @override
  String yLostBadly10(String opponent, String score) {
    return '$opponent $score. Si esto no cambia algo, nada lo hará.';
  }

  @override
  String yLostBadly11(String opponent, String score) {
    return 'He visto a este equipo humillado antes, pero el $score ante $opponent es un nuevo fondo.';
  }

  @override
  String yTrophy0(String opponent) {
    return 'CAMPEONES. $opponent. Decidlo en voz alta.';
  }

  @override
  String yTrophy1(String opponent) {
    return 'Lo hemos ganado. $opponent. No estoy bien.';
  }

  @override
  String yTrophy2(String opponent) {
    return '$opponent, y el trofeo viene para casa.';
  }

  @override
  String yTrophy3(String opponent) {
    return 'Todos y cada uno de ellos, leyendas. $opponent.';
  }

  @override
  String yRunnerUp0(String opponent) {
    return 'Tan cerca. $opponent y una medalla que nadie quiere.';
  }

  @override
  String yRunnerUp1(String opponent) {
    return 'Subcampeones en $opponent. Va a doler durante años.';
  }

  @override
  String yRunnerUp2(String opponent) {
    return '$opponent: a un partido de todo.';
  }

  @override
  String yRunnerUp3(String opponent) {
    return 'Segundos. En $opponent. Que alguien me pase la botella.';
  }

  @override
  String yEliminated0(String opponent) {
    return 'Fuera en $opponent. Esta va a doler un tiempo.';
  }

  @override
  String yEliminated1(String opponent) {
    return '$opponent es donde termina para nosotros.';
  }

  @override
  String yEliminated2(String opponent) {
    return 'Eliminados en $opponent. Ahora toca la autopsia.';
  }

  @override
  String yEliminated3(String opponent) {
    return 'Eliminados en $opponent. Que alguien me lo explique.';
  }

  @override
  String yQualified0(String opponent) {
    return '¡ESTAREMOS EN $opponent!';
  }

  @override
  String yQualified1(String opponent) {
    return 'Clasificados para $opponent. Pedid ya las vacaciones.';
  }

  @override
  String yQualified2(String opponent) {
    return '$opponent, allá vamos. Nunca hubo dudas (hubo todas las dudas).';
  }

  @override
  String yQualified3(String opponent) {
    return 'Clasificados para $opponent. Lo difícil ya está hecho.';
  }

  @override
  String yGroupDrawn0(String opponent) {
    return 'Sorteo de grupos de $opponent hecho. Podría ser peor. Mucho peor.';
  }

  @override
  String yGroupDrawn1(String opponent) {
    return 'Así que este es el sorteo de $opponent. Interesante.';
  }

  @override
  String yGroupDrawn2(String opponent) {
    return 'Ya están los grupos de $opponent y el nuestro ya no me gusta.';
  }

  @override
  String yGroupDrawn3(String opponent) {
    return 'Sorteo de $opponent hecho. Que empiecen las exageraciones.';
  }

  @override
  String yHostNamed0(String opponent) {
    return '$opponent será la sede. Empezad a ahorrar.';
  }

  @override
  String yHostNamed1(String opponent) {
    return 'Se lo lleva $opponent. Previsible, pero vale.';
  }

  @override
  String yHostNamed2(String opponent) {
    return '$opponent se queda con el torneo. Enhorabuena, supongo.';
  }

  @override
  String yHostNamed3(String opponent) {
    return 'Sede confirmada: $opponent.';
  }

  @override
  String yTournamentSoon0(String opponent) {
    return '$opponent empieza pronto y no puedo estarme quieto.';
  }

  @override
  String yTournamentSoon1(String opponent) {
    return 'Ya queda poco para $opponent.';
  }

  @override
  String yTournamentSoon2(String opponent) {
    return '$opponent ya está aquí. La convocatoria, por favor.';
  }

  @override
  String yTournamentSoon3(String opponent) {
    return 'La cuenta atrás para $opponent ya es oficialmente insoportable.';
  }

  @override
  String get navY => 'Y';

  @override
  String get yTitle => 'Y';

  @override
  String get yEmpty => 'Nada que decir todavía. Juega un partido.';

  @override
  String get yEarlierHeading => 'Antes en este ciclo';

  @override
  String get yTraitLoyalist =>
      'Apoya al equipo pase lo que pase. Lento para girarse, rápido para perdonar.';

  @override
  String get yTraitCynic => 'Espera lo peor y le encanta acertar.';

  @override
  String get yTraitNostalgic =>
      'Todo era mejor antes. Te compara con hombres ya retirados.';

  @override
  String get yTraitStatshead =>
      'Publica los números y nada más. Casi no tiene estados de ánimo.';

  @override
  String get yTraitHypeman =>
      'Dos buenos resultados y ya es una generación de oro.';

  @override
  String get yTraitContrarian => 'Piense lo que piense la gente, lo contrario.';

  @override
  String get yTraitDoomer => 'Va a salir mal. Siempre va a salir mal.';

  @override
  String get yProfilePosts => 'PUBLICACIONES';

  @override
  String get yProfileEmpty => 'Esta cuenta aún no ha publicado nada.';

  @override
  String hubEventGrievance(String player) {
    return '$player quiere hablar contigo';
  }

  @override
  String get hubEventGrievanceSub => 'Quiere saber cuál es su situación';

  @override
  String hubEventManagerSkills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count puntos de habilidad por gastar',
      one: '1 punto de habilidad por gastar',
    );
    return '$_temp0';
  }

  @override
  String get hubEventManagerSkillsSub =>
      'En lo que tú eres bueno, tu equipo mejora';

  @override
  String get grievanceTitle => 'Una charla en tu despacho';

  @override
  String grievanceGameTime(String player) {
    return '$player ha estado en la convocatoria y no ha tocado un balón. Quiere saber por qué.';
  }

  @override
  String grievanceSquadPlace(String player) {
    return '$player no está en la convocatoria y no lo entiende. Quiere una respuesta, en un sentido u otro.';
  }

  @override
  String grievanceRole(String player) {
    return '$player juega una y otra vez fuera de su posición y está harto.';
  }

  @override
  String get grievanceReassure => 'Cuento contigo';

  @override
  String get grievanceHonest => 'Hay otros por delante, y te explico por qué';

  @override
  String get grievanceDismiss => 'El equipo lo elijo yo';

  @override
  String yScorerStar0(String name, String goals) {
    return '$name marcó $goals. Nadie más se le acerca.';
  }

  @override
  String yScorerStar1(String name, String goals) {
    return '$goals de $name. Está llevando a este equipo a cuestas.';
  }

  @override
  String yScorerStar2(String name, String goals) {
    return '$name: $goals en el día. Vaya jugador.';
  }

  @override
  String yScorerStar3(String name, String goals) {
    return 'Les metió $goals, el bueno de $name. Que salga a saludar.';
  }

  @override
  String yScorerStar4(String name, String goals) {
    return '$goals de $name, y el resto iban de pasajeros.';
  }

  @override
  String yScorerStar5(String name, String goals) {
    return '$name otra vez. $goals. Imagina este equipo sin él.';
  }

  @override
  String yScorerStar6(String name, String goals) {
    return '$goals de $name. Un solo hombre no debería tener que hacer tanto.';
  }

  @override
  String yScorerStar7(String name, String goals) {
    return 'Quita a $name de ahí y son $goals menos y una tarde muy distinta.';
  }

  @override
  String yWinStreak0(String count) {
    return '$count seguidas. Lo que sea que se diga en ese vestuario, está calando.';
  }

  @override
  String yWinStreak1(String count) {
    return 'Ya van $count seguidas. Los equipos no tropiezan con rachas así por casualidad.';
  }

  @override
  String yWinStreak2(String count) {
    return '$count seguidas y subiendo. La confianza se ve desde la grada.';
  }

  @override
  String yWinStreak3(String count) {
    return 'Sin perder en $count. Pregunta a cualquiera que haya entrenado: eso es lo difícil.';
  }

  @override
  String yWinStreak4(String count) {
    return '$count seguidas. Disfrutadlo mientras el calendario sea amable.';
  }

  @override
  String yWinStreak5(String count) {
    return '$count seguidas, y no hemos ganado a nadie que importe.';
  }

  @override
  String yWinStreak6(String count) {
    return 'Una racha de $count. Pregúntame otra vez cuando la pongan a prueba.';
  }

  @override
  String yWinStreak7(String count) {
    return '$count del tirón. Todo equipo tiene una de estas alguna vez.';
  }

  @override
  String yLossStreak0(String count) {
    return '$count sin ganar ya. En algún momento se acaban las excusas.';
  }

  @override
  String yLossStreak1(String count) {
    return 'Ya van $count seguidos tirados. Esto ya no es un bache.';
  }

  @override
  String yLossStreak2(String count) {
    return '$count derrotas seguidas. Alguien tiene que dar explicaciones.';
  }

  @override
  String yLossStreak3(String count) {
    return 'Sin ganar en $count. Se nota en cómo juegan.';
  }

  @override
  String yLossStreak4(String count) {
    return '$count sin ganar y los mismos errores cada semana.';
  }

  @override
  String yLossStreak5(String count) {
    return '$count seguidos. Lo que sea que se esté probando, no funciona.';
  }

  @override
  String yLossStreak6(String count) {
    return '$count seguidos. Esto es una tendencia, no un bajón.';
  }

  @override
  String yLossStreak7(String count) {
    return 'Sin ganar en $count, y en los despachos nadie ha dicho ni una palabra.';
  }

  @override
  String yRivalry0(String opponent, String score) {
    return '$opponent $score. Di lo que quieras del fútbol. Este vale doble.';
  }

  @override
  String yRivalry1(String opponent, String score) {
    return 'Contra $opponent, precisamente. $score. Aquí nadie lo olvidará.';
  }

  @override
  String yRivalry2(String opponent, String score) {
    return '$score contra $opponent. De este se hablará en los bares.';
  }

  @override
  String yRivalry3(String opponent, String score) {
    return 'Vecinos, $score. El derecho a presumir, zanjado por un tiempo.';
  }

  @override
  String yRivalry4(String opponent, String score) {
    return '$opponent $score. Pase lo que pase este año, eso queda.';
  }

  @override
  String yRivalry5(String opponent, String score) {
    return '$score contra $opponent. Algunos lo necesitábamos más que la clasificación.';
  }

  @override
  String yRivalry6(String opponent, String score) {
    return '$opponent $score. Y la próxima vez se la cobrarán, siempre lo hacen.';
  }

  @override
  String yRivalry7(String opponent, String score) {
    return 'Contra $opponent, $score. Un año entero de recordatorios de este.';
  }

  @override
  String yInjuryBlow0(String name) {
    return '$name se retira lesionado. Lo último que necesitaba este equipo.';
  }

  @override
  String yInjuryBlow1(String name) {
    return 'Perder a $name lo cambia todo.';
  }

  @override
  String yInjuryBlow2(String name) {
    return '$name cojeando. Contened la respiración.';
  }

  @override
  String yInjuryBlow3(String name) {
    return 'Sin $name durante un tiempo, entonces. Alguien tiene que dar un paso al frente.';
  }

  @override
  String yInjuryBlow4(String name) {
    return '$name, baja. Cómo no, tenía que ser $name.';
  }

  @override
  String yInjuryBlow5(String name) {
    return 'Sin $name esto se convierte en un equipo muy normalito.';
  }

  @override
  String yInjuryBlow6(String name) {
    return '$name lesionado otra vez. Alguien debería preguntarse por qué.';
  }

  @override
  String yInjuryBlow7(String name) {
    return 'Perdemos a $name y no hay nadie detrás. Ese es el problema de verdad.';
  }

  @override
  String ySentOff0(String name, String minute) {
    return 'Roja para $name en el minuto $minute y todo el país se le echa encima. Nos ha dado más que la mayoría. Dejadlo.';
  }

  @override
  String ySentOff1(String name, String minute) {
    return '$name expulsado en el minuto $minute. Duro. Con diez seguimos intentándolo, y eso dice algo.';
  }

  @override
  String ySentOff2(String name, String minute) {
    return '$name, minuto $minute, tarjeta roja. Con diez desde ahí.';
  }

  @override
  String ySentOff3(String name, String minute) {
    return 'Expulsión: $name en el $minute. No es el primer partido que gira por una decisión.';
  }

  @override
  String ySentOff4(String name, String minute) {
    return 'Genial. $name se va a la calle en el minuto $minute y nos quedamos con diez. Otra vez.';
  }

  @override
  String ySentOff5(String name, String minute) {
    return '$name expulsado en el minuto $minute. ¿Quién se encarga de la disciplina aquí exactamente?';
  }

  @override
  String ySentOff6(String name, String minute) {
    return '$minute minutos. Eso es lo que aguantó $name con la cabeza fría. Fútbol profesional.';
  }

  @override
  String ySentOff7(String name, String minute) {
    return 'Roja para $name en el minuto $minute, y se supone que tengo que creer que esto es progresar.';
  }

  @override
  String get yBoardPressure0 =>
      'La directiva se ha quedado muy callada. Nunca es buena señal.';

  @override
  String get yBoardPressure1 =>
      'Dicen que en los despachos ya han empezado a hacer preguntas.';

  @override
  String get yBoardPressure2 => 'Se nota cómo se mueve el suelo arriba.';

  @override
  String get yBoardPressure3 =>
      'Nadie en la federación dice nada en su apoyo. Sacad vuestras conclusiones.';

  @override
  String get yBoardPressure4 =>
      'Hace semanas que nadie de arriba lo respalda en público.';

  @override
  String get yBoardPressure5 =>
      'La federación filtrando contra su propio seleccionador. Como siempre.';

  @override
  String get yBoardPressure6 =>
      'Cuando una directiva se calla, ya ha decidido.';

  @override
  String get yBoardPressure7 =>
      'Dejarán que esto se arrastre hasta que la decisión le toque a otro.';

  @override
  String get yReplies => 'TAMBIÉN SOBRE ESTE PARTIDO';

  @override
  String get yPlayerGrievance0 =>
      'Pregunté cuál es mi situación. Sigo esperando respuesta.';

  @override
  String get yPlayerGrievance1 => 'Entrenando duro. Poco más puedo hacer.';

  @override
  String get yPlayerGrievance2 =>
      'Hay preguntas que solo se pueden hacer una vez.';

  @override
  String get yPlayerGrievance3 =>
      'No he llegado hasta aquí para cargar con los petos.';

  @override
  String get playerHonoursTitle => 'PALMARÉS';

  @override
  String get awardGoldenBall => 'Balón de Oro';

  @override
  String get awardGoldenBoot => 'Bota de Oro';

  @override
  String get awardGoldenGlove => 'Guante de Oro';

  @override
  String get awardTeamOfTournament => 'Once ideal del torneo';

  @override
  String get awardPlayerOfYear => 'Mejor jugador mundial del año';

  @override
  String get awardYoungPlayerOfYear => 'Mejor jugador joven del año';

  @override
  String get playerClubHistory => 'TRAYECTORIA EN CLUBES';

  @override
  String get playerCareerRecord => 'TRAYECTORIA';

  @override
  String get playerInternationalGoals => 'Goles internacionales';

  @override
  String get playerRecentForm => 'FORMA RECIENTE';

  @override
  String get playerMatchHistory => 'HISTORIAL DE PARTIDOS';

  @override
  String get playerAttributes => 'ATRIBUTOS';

  @override
  String get playerUnknown => 'Desconocido';

  @override
  String get playerAttrPace => 'Velocidad';

  @override
  String get playerAttrPhysical => 'Físico';

  @override
  String get playerAttrTechnical => 'Técnica';

  @override
  String get playerAttrShooting => 'Disparo';

  @override
  String get playerAttrPassing => 'Pase';

  @override
  String get playerAttrDribbling => 'Regate';

  @override
  String get playerAttrTackling => 'Entradas';

  @override
  String get playerAttrPositioning => 'Colocación';

  @override
  String get playerAttrComposure => 'Serenidad';

  @override
  String get playerAttrDecisions => 'Decisiones';

  @override
  String get playerAttrStamina => 'Resistencia';

  @override
  String get playerAttrStrength => 'Fuerza';

  @override
  String get playerStatCaps => 'Partidos';

  @override
  String get playerStatGoals => 'Goles';

  @override
  String get playerStatAssists => 'Asistencias';

  @override
  String get playerStatAvgRating => 'Nota media';

  @override
  String get playerStatForm => 'Forma';

  @override
  String get playerStatMotm => 'MVP';

  @override
  String get playerStatCleanSheets => 'Porterías a cero';

  @override
  String get playerStatBestGame => 'Mejor partido';

  @override
  String get playerStatCards => 'Tarjetas';

  @override
  String playerCardsValue(int yellows, int reds) {
    return '${yellows}A ${reds}R';
  }

  @override
  String get tourSharedYourRun => 'TU CAMINO';

  @override
  String get tourSharedList => 'Lista';

  @override
  String get tourSharedBracket => 'Cuadro';

  @override
  String get tourSharedVs => 'vs';

  @override
  String tourSharedGroupSeed(String seed) {
    return 'Grupo $seed';
  }

  @override
  String get tourSharedThisEdition => 'Esta edición';

  @override
  String get tourSharedAllTime => 'Histórico';

  @override
  String get tourSharedUnknown => 'Desconocido';

  @override
  String get tourSharedActive => 'EN ACTIVO';

  @override
  String get tourSharedMedalTable => 'MEDALLERO';

  @override
  String get tourSharedPastWinners => 'CAMPEONES ANTERIORES';

  @override
  String tourSharedHost(String host) {
    return 'Sede: $host';
  }

  @override
  String get tourSharedBeat => 'venció a';

  @override
  String get tourSharedPens => ' (pen.)';

  @override
  String get tourSharedAwardsEmpty =>
      'Los premios se deciden cuando termina el torneo.';

  @override
  String get tourSharedGoldenBall => 'BALÓN DE ORO';

  @override
  String get tourSharedPlayerOfTournament => 'Mejor jugador del torneo';

  @override
  String get tourSharedGoldenBoot => 'BOTA DE ORO';

  @override
  String tourSharedGoalsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count goles',
      one: '1 gol',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedGoldenGlove => 'GUANTE DE ORO';

  @override
  String get tourSharedTeamOfTournament => 'EQUIPO DEL TORNEO';

  @override
  String get tourSharedStatsEmpty =>
      'Los récords aparecen cuando la competición tenga algo de historia.';

  @override
  String get tourSharedRecordScorer => 'MÁXIMO GOLEADOR';

  @override
  String get tourSharedStillActive => 'en activo';

  @override
  String get tourSharedMostTitles => 'MÁS TÍTULOS';

  @override
  String tourSharedTitlesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count títulos',
      one: '1 título',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostFinals => 'MÁS FINALES';

  @override
  String tourSharedFinalsContested(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count finales disputadas',
      one: '1 final disputada',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostGamesPlayed => 'MÁS PARTIDOS JUGADOS';

  @override
  String tourSharedMatchesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count partidos',
      one: '1 partido',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostFinalsPlayed => 'MÁS FASES FINALES';

  @override
  String tourSharedFinalsTournamentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fases finales',
      one: '1 fase final',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedBiggestFinalWin => 'MAYOR GOLEADA EN UNA FINAL';

  @override
  String tourStatsGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count goles',
      one: '1 gol',
    );
    return '$_temp0';
  }

  @override
  String get tourStatsStillActive => 'en activo';

  @override
  String tourStatsTitles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count títulos',
      one: '1 título',
    );
    return '$_temp0';
  }

  @override
  String tourStatsFinalsContested(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count finales disputadas',
      one: '1 final disputada',
    );
    return '$_temp0';
  }

  @override
  String tourStatsMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count partidos',
      one: '1 partido',
    );
    return '$_temp0';
  }

  @override
  String tourStatsFinalsTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fases finales',
      one: '1 fase final',
    );
    return '$_temp0';
  }

  @override
  String get tourStatsLeaders => 'LÍDERES HISTÓRICOS';

  @override
  String get tourStatsTabGames => 'Partidos';

  @override
  String get tourStatsTabCups => 'Ediciones';

  @override
  String get tourStatsTabScorers => 'Goleadores';

  @override
  String tourSharedFinalWinDetail(String opponent, int year) {
    return 'vs $opponent · $year';
  }

  @override
  String get tourHolders => 'CAMPEÓN VIGENTE';

  @override
  String tourHoldersSince(int year) {
    return 'campeón en $year';
  }

  @override
  String get tourSharedAllTimeScorers => 'GOLEADORES HISTÓRICOS';

  @override
  String get tourSharedSummaryEmpty =>
      'El anfitrión y sus estadios aparecen cuando se sortee esta edición.';

  @override
  String get tourSharedHostHeading => 'ANFITRIÓN';

  @override
  String get tourSharedHostsHeading => 'ANFITRIONES';

  @override
  String get tourSharedCoHostsHeading => 'COANFITRIONES';

  @override
  String get tourSharedVenues => 'SEDES';

  @override
  String get tourSharedMascot => 'MASCOTA';

  @override
  String get tourSharedMatchBall => 'BALÓN OFICIAL';

  @override
  String tourSharedVenueSeats(String city, String capacity) {
    return '$city · $capacity asientos';
  }

  @override
  String get tourSharedCouldNotLoad => 'No se pudo cargar.';

  @override
  String get tourSharedHostTbc => 'ANFITRIÓN POR CONFIRMAR';

  @override
  String get tourSharedFinalsAreHere => 'LLEGA LA FASE FINAL';

  @override
  String tourSharedHostedBy(String hosts) {
    return 'ORGANIZA  $hosts';
  }

  @override
  String get tourSharedLetFinalsBegin => 'Que empiece la fase final';

  @override
  String get tourSharedCompetitions => 'COMPETICIONES';

  @override
  String get tourSharedWorldRanking => 'Ranking mundial';

  @override
  String get tourSharedCouldNotLoadTournaments =>
      'No se pudieron cargar los torneos.';

  @override
  String get tourSharedPrestigeStage => 'ESCENARIO DE PRESTIGIO';

  @override
  String get tourSharedOverview => 'Resumen';

  @override
  String get tourSharedWorldRankingTitle => 'Ranking mundial';

  @override
  String get tourSharedYourCompetitions => 'TUS COMPETICIONES';

  @override
  String get tourSharedOtherContinents => 'OTROS CONTINENTES';

  @override
  String get tourSharedComingSoon => 'Torneo disponible pronto';

  @override
  String get tourSharedSoon => 'PRONTO';

  @override
  String get tourSharedNoQualifyingDraw => 'No hay sorteo de clasificación.';

  @override
  String get tourSharedOpenEnvelope => 'Abre el sobre';

  @override
  String tourSharedGroupName(String name) {
    return 'GRUPO $name';
  }

  @override
  String get tourSharedBall => 'Bola';

  @override
  String get tourSharedPot => 'Bombo';

  @override
  String get tourSharedAll => 'Todo';

  @override
  String get tourSharedTapDrawTeam => 'Toca para sacar el siguiente equipo';

  @override
  String get tourSharedTapDrawPot => 'Toca para sacar el siguiente bombo';

  @override
  String get tourSharedTapDrawAll => 'Toca para ver el sorteo completo';

  @override
  String get tourSharedContinue => 'Continuar';

  @override
  String get tourSharedPause => 'Pausa';

  @override
  String get tourSharedPlay => 'Reanudar';

  @override
  String get tourSharedSkip => 'Saltar';

  @override
  String tourSharedPotNumber(int number) {
    return 'BOMBO $number';
  }

  @override
  String get tourSharedDrawComplete => 'SORTEO COMPLETADO';

  @override
  String get tourSharedDrawing => 'SORTEANDO…';

  @override
  String get tourContChampionship => 'CAMPEONATO';

  @override
  String get tourContTabSummary => 'RESUMEN';

  @override
  String get tourContTabQualifying => 'CLASIFICACIÓN';

  @override
  String get tourContTabFinals => 'FASE FINAL';

  @override
  String get tourContTabBracket => 'CUADRO';

  @override
  String get tourContTabAwards => 'PREMIOS';

  @override
  String get tourContTabScorers => 'GOLEADORES';

  @override
  String get tourContTabHistory => 'HISTORIA';

  @override
  String get tourContTabRecords => 'RÉCORDS';

  @override
  String tourContCouldNotLoadCup(String error) {
    return 'No se pudo cargar la copa.\n$error';
  }

  @override
  String get tourContNoCupData => 'No hay datos de la copa.';

  @override
  String get tourContUnknown => 'Desconocido';

  @override
  String get tourContGroupsToBeDrawnQual =>
      'Los grupos de clasificación se sortean en la ceremonia. Síguela desde Inicio para ver tus rivales.';

  @override
  String get tourContQualSeeded =>
      'Tu selección está clasificada directamente para la fase final. Este ciclo no juega la clasificación.';

  @override
  String tourContBackgroundRegion(String name) {
    return '$name se simula en segundo plano. Los resultados aparecen aquí a medida que se juega cada jornada.';
  }

  @override
  String get tourContGroupsToBeDrawnFinals =>
      'Los grupos de la fase final se sortean en la ceremonia. Síguela desde Inicio para ver tu grupo.';

  @override
  String get tourContFinalsDrawAfterQual =>
      'El sorteo de la fase final se celebra cuando termine la clasificación.';

  @override
  String get tourContContestedBeforeWc =>
      'Las eliminatorias se disputan antes del Campeonato del Mundo.';

  @override
  String tourContChampionsHeading(String name) {
    return 'CAMPEONES: $name';
  }

  @override
  String tourContWinnersTitle(String name) {
    return 'Campeones de $name';
  }

  @override
  String get tourContNoGoalsYet => 'Todavía no se ha marcado ningún gol.';

  @override
  String tourContGroupHeading(String name) {
    return 'GRUPO $name';
  }

  @override
  String get tourContBestRunnersUp => 'MEJORES SEGUNDOS';

  @override
  String tourContGroupDropdown(String name) {
    return 'Grupo $name';
  }

  @override
  String get tourContMatches => 'PARTIDOS';

  @override
  String get tourContNoGroupsDrawn => 'Todavía no se han sorteado los grupos.';

  @override
  String get tourContQualifyingDraw => 'SORTEO DE CLASIFICACIÓN';

  @override
  String get tourContWorldQualifyingDraw =>
      'SORTEO DE LA CLASIFICACIÓN MUNDIAL';

  @override
  String get tourContFinalsDraw => 'SORTEO DE LA FASE FINAL';

  @override
  String get tourContSeedingPots => 'BOMBOS';

  @override
  String get tourContGroupDraw => 'SORTEO DE GRUPOS';

  @override
  String tourContCouldNotLoadDraw(String error) {
    return 'No se pudo cargar el sorteo.\n$error';
  }

  @override
  String get tourContDrawNotReady => 'El sorteo todavía no está listo.';

  @override
  String get tourContContinentalClash => 'DUELO CONTINENTAL';

  @override
  String get tourContTabThisCycle => 'ESTE CICLO';

  @override
  String tourContCouldNotLoadClash(String error) {
    return 'No se pudo cargar.\n$error';
  }

  @override
  String get tourContNoSaveFound => 'No se encontró la partida.';

  @override
  String get tourContClashSoon =>
      'El Duelo Continental se juega cuando se conocen los dos campeones continentales.';

  @override
  String get tourContTwoContinentsOneMatch => 'DOS CONTINENTES, UN PARTIDO';

  @override
  String get tourContVersusShort => 'vs';

  @override
  String tourContWinTheClash(String name) {
    return '$name gana el Duelo';
  }

  @override
  String get tourContNoClashYet =>
      'Todavía no se ha jugado ningún Duelo Continental.';

  @override
  String get tourContNationsCup => 'COPA DE LAS NACIONES';

  @override
  String get tourContTabLeagues => 'LIGAS';

  @override
  String get tourContTabFinalsFour => 'FINAL A CUATRO';

  @override
  String tourContCouldNotLoad(String error) {
    return 'No se pudo cargar.\n$error';
  }

  @override
  String get tourContNoNationsCupGoals =>
      'Todavía no hay goles en la Copa de las Naciones.';

  @override
  String get tourContNoNationsCupChampions =>
      'La Copa de las Naciones todavía no tiene campeón.';

  @override
  String get tourContNationsCupOffSeason =>
      'La Copa de las Naciones de este ciclo empieza después de la fase final continental. Los campeones anteriores están en Historia.';

  @override
  String get tourContNationsCupGroupsSoon =>
      'Los grupos de la Copa de las Naciones de este ciclo se sortean en la ceremonia. Síguela desde Inicio para ver tus rivales.';

  @override
  String get tourContLeagueNoGroups =>
      'No hay partidos en esta liga en esta jornada.';

  @override
  String tourContLeagueHeading(String letter) {
    return 'LIGA $letter';
  }

  @override
  String tourContLeagueHeadingYours(String letter) {
    return 'LIGA $letter · TU LIGA';
  }

  @override
  String get tourContFinalsFourSoon =>
      'La Final a Cuatro la disputan los ganadores de grupo de la Liga A cuando termina la fase de grupos.';

  @override
  String tourContLeagueChip(String letter) {
    return 'Liga $letter';
  }

  @override
  String tourContLeagueChipStar(String letter) {
    return 'Liga $letter ★';
  }

  @override
  String get tourContSemiFinals => 'SEMIFINALES';

  @override
  String get tourContFinal => 'FINAL';

  @override
  String get tourContNationsCupDraw => 'SORTEO DE LA COPA DE LAS NACIONES';

  @override
  String get tourContIntercontinentalPlayoff => 'REPESCA INTERCONTINENTAL';

  @override
  String get tourContNoPlayoffThisCycle => 'No hay repesca en este ciclo.';

  @override
  String get tourContPlayoffIntro =>
      'Dos plazas para el Campeonato del Mundo en juego en una eliminatoria entre los mejores que se quedaron fuera.';

  @override
  String get tourContPlayoffThrough =>
      'Has superado la repesca. ¡Estás en el Campeonato del Mundo!';

  @override
  String get tourContPlayoffOut =>
      'Te has quedado corto en la repesca. Esta vez no hay Campeonato del Mundo.';

  @override
  String get tourContContinue => 'Continuar';

  @override
  String get tourContPlayoffFinals => 'FINALES DE LA REPESCA';

  @override
  String get tourContPlayoffSeeded => 'Cabeza de serie (exento)';

  @override
  String get tourCupTabSummary => 'RESUMEN';

  @override
  String get tourCupTabQualifying => 'CLASIFICACIÓN';

  @override
  String get tourCupTabPlayoff => 'REPESCA';

  @override
  String get tourCupPlayoffSoon =>
      'La repesca intercontinental se decide cuando termina la clasificación de todas las confederaciones.';

  @override
  String get tourCupTabFinals => 'FASE FINAL';

  @override
  String get tourCupTabBracket => 'CUADRO';

  @override
  String get tourCupTabAwards => 'PREMIOS';

  @override
  String get tourCupTabScorers => 'GOLEADORES';

  @override
  String get tourCupTabHistory => 'HISTORIA';

  @override
  String get tourCupTabRecords => 'RÉCORDS';

  @override
  String get tourCupTitle => 'CAMPEONATO DEL MUNDO';

  @override
  String get tourCupNoData => 'No hay datos de la copa.';

  @override
  String tourCupLoadError(String error) {
    return 'No se pudo cargar la copa.\n$error';
  }

  @override
  String get tourCupUnknown => 'Desconocido';

  @override
  String get tourCupWorldChampions => 'CAMPEONES DEL MUNDO';

  @override
  String get tourCupWorldChampionsTitle => 'Campeones del mundo';

  @override
  String get tourCupStillActive => 'En activo';

  @override
  String get tourCupAllTimeScorers => 'GOLEADORES HISTÓRICOS';

  @override
  String get tourCupAllConfederations => 'Todas las confederaciones';

  @override
  String get tourCupBestRunnersUp => 'Mejores segundos';

  @override
  String get tourCupCompWorld => 'Campeonato del Mundo';

  @override
  String get tourCupCompEurope => 'Campeonato de Europa';

  @override
  String get tourCupCompSAmerica => 'Copa de Sudamérica';

  @override
  String get tourCupDestRoundOf16 => 'los octavos de final';

  @override
  String get tourCupDestKnockouts => 'las eliminatorias';

  @override
  String get tourCupDestFinals => 'la fase final';

  @override
  String get tourCupDestFinalsPlayoff => 'la repesca de la fase final';

  @override
  String get tourCupDestIntercontPlayoff => 'la repesca intercontinental';

  @override
  String get tourCupFinalsDrawnAfterQual =>
      'La fase final se sortea cuando termine la clasificación.';

  @override
  String get tourCupFinalsDrawSoon =>
      'Grupos por sortear. Sigue el sorteo del Campeonato del Mundo desde Inicio para descubrirlos.';

  @override
  String tourCupGroupName(String name) {
    return 'Grupo $name';
  }

  @override
  String tourCupGroupNameShort(String name) {
    return 'Grupo $name';
  }

  @override
  String tourCupHostLabel(String host) {
    return 'Organiza $host';
  }

  @override
  String tourCupHostLabelMulti(String hosts) {
    return 'Organizan $hosts';
  }

  @override
  String get tourCupIntercontPlayoff => 'Repesca intercontinental';

  @override
  String get tourCupKnockoutSoon =>
      'El cuadro empieza cuando termine la fase de grupos.';

  @override
  String get tourCupMatches => 'PARTIDOS';

  @override
  String get tourCupMedalTable => 'MEDALLERO';

  @override
  String get tourCupMostTitles => 'MÁS TÍTULOS';

  @override
  String tourCupMostTitlesValue(String nation, int titles, int editions) {
    return '$nation: $titles títulos en $editions ediciones';
  }

  @override
  String get tourCupNoGoals => 'Todavía no hay goles.';

  @override
  String get tourCupNoGroups => 'No hay grupos sorteados.';

  @override
  String get tourCupNoHistory => 'Todavía no hay historia.';

  @override
  String get tourCupPastWinners => 'CAMPEONES ANTERIORES';

  @override
  String get tourCupPlayoffIntro =>
      'Dos plazas para el Campeonato del Mundo en juego en una eliminatoria entre los mejores que se quedaron fuera.';

  @override
  String get tourCupQualDrawSoon =>
      'Grupos por sortear. Sigue el sorteo de clasificación desde Inicio para descubrirlos.';

  @override
  String tourCupRegionYours(String region) {
    return '$region · la tuya';
  }

  @override
  String tourCupScorePens(int home, int away) {
    return '$home–$away (pen.)';
  }

  @override
  String get tourCupSegAllTime => 'Histórico';

  @override
  String get tourCupSegFinals => 'Fase final';

  @override
  String get tourCupSegQualifying => 'Clasificación';

  @override
  String get playerTraitsTitle => 'CONOCIDO POR';

  @override
  String get traitBigGame => 'Jugador de grandes citas';

  @override
  String get traitBigGameBlurb => 'Sube su nivel en las eliminatorias.';

  @override
  String get traitSetPiece => 'Especialista a balón parado';

  @override
  String get traitSetPieceBlurb =>
      'Mejores centros y más goles a balón parado.';

  @override
  String get traitHothead => 'Temperamental';

  @override
  String get traitHotheadBlurb => 'Ve muchas más tarjetas que sus compañeros.';

  @override
  String get traitIronMan => 'Hombre de hierro';

  @override
  String get traitIronManBlurb =>
      'Rara vez se lesiona y se cansa más despacio.';

  @override
  String get traitWonderkid => 'Niño prodigio';

  @override
  String get traitWonderkidBlurb =>
      'Joven, ya es bueno y sigue mejorando rápido.';

  @override
  String get traitLeader => 'Líder';

  @override
  String get traitLeaderBlurb =>
      'Eleva el nivel de todos sus compañeros en el campo.';

  @override
  String get traitPacey => 'Veloz';

  @override
  String get traitPaceyBlurb =>
      'Velocidad endiablada, un peligro a la espalda de la defensa.';

  @override
  String get traitOldHead => 'Veterano';

  @override
  String get traitOldHeadBlurb =>
      'Un veterano cuya lectura del juego dura más que sus piernas.';

  @override
  String get traitWasteful => 'Desacertado';

  @override
  String get traitWastefulBlurb => 'Manda fuera demasiadas ocasiones claras.';

  @override
  String get objectiveWorldCup => 'Campeonato del Mundo';

  @override
  String get objectiveWinTournament => 'Ganarlo';

  @override
  String get objectiveQualifyGeneric => 'Clasificarse';

  @override
  String hubBoardObjectiveFor(String competition, String label) {
    return '$competition: $label';
  }

  @override
  String get objectiveWinWorldCup => 'Ganar el Campeonato del Mundo';

  @override
  String get objectiveReachFinal => 'Llegar a la final';

  @override
  String get objectiveReachSemis => 'Llegar a semifinales';

  @override
  String get objectiveReachQuarters => 'Llegar a cuartos de final';

  @override
  String get objectiveReachKnockouts => 'Llegar a las eliminatorias';

  @override
  String get objectiveQualify => 'Clasificarse para el Campeonato del Mundo';

  @override
  String get finishChampions => 'Campeones';

  @override
  String get finishRunnersUp => 'Subcampeones';

  @override
  String get finishSemiFinals => 'Semifinales';

  @override
  String get finishQuarterFinals => 'Cuartos de final';

  @override
  String get finishRoundOf16 => 'Octavos de final';

  @override
  String get finishGroupStage => 'Fase de grupos';

  @override
  String get objectiveQualifyingTopHalf =>
      'Acabar en la mitad alta de la clasificación';

  @override
  String get finishQualifyingTopHalf => 'Mitad alta del grupo de clasificación';

  @override
  String get finishQualifyingBottomHalf =>
      'Mitad baja del grupo de clasificación';

  @override
  String get objectiveNcWinIt => 'Ganar la Copa de las Naciones';

  @override
  String get objectiveNcReachFinal =>
      'Llegar a la final de la Copa de las Naciones';

  @override
  String get objectiveNcFinalsFour => 'Llegar a la Final a Cuatro';

  @override
  String get objectiveNcWinGroup => 'Ganar el grupo y ascender';

  @override
  String get objectiveNcTopHalf => 'Acabar en la mitad alta del grupo';

  @override
  String get objectiveNcSurvive => 'Evitar el descenso';

  @override
  String get finishNcChampions => 'Campeones de la Copa de las Naciones';

  @override
  String get finishNcFinalsFour => 'Final a Cuatro';

  @override
  String get finishNcGroupWinners => 'Primeros de grupo';

  @override
  String get finishNcTopHalf => 'Mitad alta del grupo';

  @override
  String get finishNcStayedUp => 'Permanencia';

  @override
  String get finishNcBottom => 'Últimos del grupo';

  @override
  String get careerNationsCupLabel => 'Copa de las Naciones';

  @override
  String get squadDevPlayer => 'JUGADOR';

  @override
  String get squadDevAge => 'EDAD';

  @override
  String get squadDevPosition => 'POS';

  @override
  String get squadDevChange => 'VALORACIÓN';

  @override
  String get squadDevNew => 'NUEVO';

  @override
  String get squadDevRetired => 'RETIRADO';

  @override
  String get squadDevEmpty =>
      'Un año tranquilo. Ningún cambio en la plantilla.';

  @override
  String get squadDevTierRegulars => 'HABITUALES';

  @override
  String get squadDevTierFringe => 'SEGUNDA LÍNEA';

  @override
  String get squadDevTierYouth => 'JÓVENES';

  @override
  String get boardObjectivesTitle => 'Objetivos de la directiva';

  @override
  String get boardObjectivesConfidence => 'Confianza de la directiva';

  @override
  String boardObjectiveBeatenBy(String result, int rounds) {
    String _temp0 = intl.Intl.pluralLogic(
      rounds,
      locale: localeName,
      other: '$rounds rondas más de lo pedido',
      one: 'una ronda más de lo pedido',
    );
    return '$result: $_temp0';
  }

  @override
  String boardObjectiveShortBy(String result, int rounds) {
    String _temp0 = intl.Intl.pluralLogic(
      rounds,
      locale: localeName,
      other: 'a $rounds rondas',
      one: 'a una ronda',
    );
    return '$result: $_temp0';
  }

  @override
  String get boardObjectivesPending => 'POR DECIDIR';

  @override
  String boardObjectiveSoFar(String result) {
    return 'POR AHORA · $result';
  }

  @override
  String get boardObjectivesEmpty =>
      'La directiva no ha fijado ningún objetivo para este ciclo.';

  @override
  String get tourContBestWinners => 'MEJORES PRIMEROS';

  @override
  String get tourContBestThirds => 'MEJORES TERCEROS';

  @override
  String tourContBestPlaced(String position) {
    return 'MEJORES $position.º CLASIFICADOS';
  }

  @override
  String squadDevPageOf(String page, String pages, String total) {
    return '$page/$pages · $total jugadores';
  }

  @override
  String get matchSoldOut => 'NO HAY BILLETES';

  @override
  String matchAttendanceOf(String attendance, String capacity) {
    return '$attendance de $capacity asientos ocupados';
  }

  @override
  String get matchGroundTitle => 'ESTADIO';

  @override
  String get absenceInjured => 'Lesionado';

  @override
  String get absenceSuspended => 'Sancionado';

  @override
  String absenceWeeks(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString semanas',
      one: '1 semana',
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
      other: '$countString partidos',
      one: '1 partido',
    );
    return '$_temp0';
  }

  @override
  String absenceBackFor(String opponent) {
    return 'Vuelve contra $opponent';
  }

  @override
  String get penaltyOrderTitle => 'Penaltis';

  @override
  String get penaltyOrderBlurb =>
      'Elige a tus cinco lanzadores, en orden. Toca una posición para cambiarla.';

  @override
  String penaltyOrderPick(int number) {
    return 'Penalti $number';
  }

  @override
  String get penaltyOrderPickBlurb =>
      'Elige quién lanza. La barra indica su sangre fría desde el punto de penalti.';

  @override
  String get penaltyOrderConfirm => 'A lanzar';

  @override
  String get penaltyOrderCancel => 'Atrás';

  @override
  String get youthTitle => 'Cantera';

  @override
  String get youthEmptyLevel => 'Todavía no hay nadie en este nivel.';

  @override
  String get youthReleased => 'Descartados este año';

  @override
  String get u21Title => 'Sub-21';

  @override
  String get u21Blurb =>
      'La próxima generación, el mejor prospecto primero. Las estrellas huecas son una estimación del ojeador. Haz debutar a un jugador para saber lo que vale de verdad.';

  @override
  String get u21Empty =>
      'Ahora mismo no hay nadie menor de 21 años. La próxima hornada llega con el nuevo ciclo.';

  @override
  String u21Breakout(int gain) {
    return '+$gain ESTE AÑO';
  }

  @override
  String u21AgeCaps(int age, int caps) {
    return '$age años · $caps internacionalidades';
  }

  @override
  String u21AgeUncapped(int age) {
    return '$age años · sin debutar';
  }

  @override
  String get u21CallUps => 'Ir a la convocatoria';

  @override
  String get youthWatching => 'Seguidos';

  @override
  String get youthWatchEmpty =>
      'Todavía no sigues a nadie. Marca a un chaval de cualquier nivel y aparecerá aquí, con lo que ha llegado a ser desde entonces.';

  @override
  String get youthWatchMark => 'Seguir a este chaval';

  @override
  String get youthWatchUnmark => 'Dejar de seguirlo';

  @override
  String youthWatchMarked(int rating, int age) {
    return 'Marcado con $rating, a los $age años';
  }

  @override
  String get youthWatchSenior => 'Ya en el grupo absoluto';

  @override
  String get youthWatchReleased => 'Descartado por la cantera';

  @override
  String get youthWatchGone => 'Ya no está en la cantera';

  @override
  String get tacticsYouth => 'Sub-21';

  @override
  String get pressSquad => 'Vestuario';

  @override
  String get pressBoard => 'Directiva';

  @override
  String get pressNoEffect => 'Nadie le da mucha importancia';

  @override
  String get matchNeutralGround => 'NEUTRAL';

  @override
  String get matchExtraTimeAhead => 'PRÓRROGA';

  @override
  String get matchExtraTimeHalf => 'PRÓRROGA · DESCANSO';

  @override
  String get matchClockFullTime => 'FINAL';

  @override
  String get matchClockAfterExtraTime => 'TRAS LA PRÓRROGA';

  @override
  String get matchClockPenalties => 'PENALTIS';

  @override
  String get matchClockFullTimePenalties => 'FINAL · PENALTIS';

  @override
  String get hubEventPressConference => 'Atiende a la prensa';

  @override
  String get hubEventPressConferenceSub =>
      'Los medios de todo el mundo quieren hablar contigo antes de tu primer partido';

  @override
  String get squadDevWonderkid => 'PRODIGIO';

  @override
  String get tacticsPlaystyle => 'Estilo de juego';

  @override
  String get tacticsPlaystyleBlurb =>
      'Elige cómo juega el equipo; los ajustes de abajo lo afinan.';

  @override
  String get tacticsPlaystyleCustom =>
      'Ajustes propios. Ningún estilo definido coincide con estos valores.';

  @override
  String get playstyleCustom => 'Personalizado';

  @override
  String get playstyleBalanced => 'Equilibrado';

  @override
  String get playstylePossession => 'Posesión';

  @override
  String get playstyleGegenpress => 'Gegenpress';

  @override
  String get playstyleCounter => 'Contraataque';

  @override
  String get playstyleDirect => 'Directo';

  @override
  String get playstyleLowBlock => 'Bloque bajo';

  @override
  String get playstyleWingPlay => 'Juego por bandas';

  @override
  String get playstyleBalancedBlurb =>
      'Sólido en las dos mitades, sin excesos.';

  @override
  String get playstylePossessionBlurb =>
      'Tener el balón, moverlo con paciencia, encerrar al rival.';

  @override
  String get playstyleGegenpressBlurb =>
      'Recuperarlo en cuanto se pierde, arriba en el campo.';

  @override
  String get playstyleCounterBlurb =>
      'Esperar atrás, mantenerse compactos y salir a toda velocidad.';

  @override
  String get playstyleDirectBlurb =>
      'Balón arriba pronto y a por la segunda jugada.';

  @override
  String get playstyleLowBlockBlurb =>
      'Atrás, cerrado y muy difícil de superar.';

  @override
  String get playstyleWingPlayBlurb =>
      'Abrir el campo, desbordar por fuera y centrar.';

  @override
  String get nationsRandomTeam => 'Equipo aleatorio';

  @override
  String get nationsFromTheBottom => 'Desde abajo';

  @override
  String get bottomStartTitle => 'Sin trabajo';

  @override
  String get bottomStartHeading => 'Tres federaciones quieren hablar contigo';

  @override
  String get bottomStartBlurb =>
      'No tienes trabajo ni reputación. Son las únicas selecciones dispuestas a darte una oportunidad. Elige una y construye algo desde cero.';

  @override
  String get bottomStartAccept => 'Aceptar';

  @override
  String get bottomStartBack => 'Volver al menú';

  @override
  String bottomStartRankOf(int rank, int total) {
    return '$rank.º de $total en el mundo';
  }

  @override
  String get campTitle => 'Campo base';

  @override
  String campBasedIn(String host) {
    return 'Concentración en $host';
  }

  @override
  String get campBlurb =>
      'Donde vive la plantilla durante todo el torneo. No se puede cambiar una vez empezado, e influye en tres cosas en cada partido: lo frescos que llegan, lo rápido que se curan los golpes y lo afinados que están.';

  @override
  String get campEffectTravel => 'Llegar frescos';

  @override
  String get campEffectRecovery => 'Recuperación';

  @override
  String get campEffectSharpness => 'Ritmo de partido';

  @override
  String get campTerrainCity => 'Centro urbano';

  @override
  String get campTerrainCoastal => 'Complejo costero';

  @override
  String get campTerrainMountain => 'Refugio de montaña';

  @override
  String get campTerrainAltitude => 'Campo en altitud';

  @override
  String get campTerrainNationalCentre => 'Centro nacional';

  @override
  String get campTerrainCityBlurb =>
      'Todo a mano y sin desplazamientos, pero sin tranquilidad y sin escapar del ruido.';

  @override
  String get campTerrainCoastalBlurb =>
      'Tranquilo, cómodo y bueno para el ánimo; un largo viaje en autobús a cada estadio.';

  @override
  String get campTerrainMountainBlurb =>
      'Aire fresco y unos servicios médicos de primera que recuperan rápido los golpes, muy lejos del torneo.';

  @override
  String get campTerrainAltitudeBlurb =>
      'Entrenar ahí es duro, pero las piernas aguantan hasta el final del torneo.';

  @override
  String get campTerrainNationalCentreBlurb =>
      'Las instalaciones de la propia federación: nada espectacular, nada que pueda fallar.';

  @override
  String get hubEventChooseCamp => 'Elige el campo base';

  @override
  String hubEventChooseCampSub(String host) {
    return 'Dónde se alojará la plantilla en $host';
  }

  @override
  String get tacticsTabBench => 'Banquillo';

  @override
  String get squadSearchHint => 'Buscar por nombre o club';

  @override
  String get squadFilterAll => 'Todos';

  @override
  String get squadFilterInSquad => 'Convocados';

  @override
  String get squadFilterUncapped => 'Sin debutar';

  @override
  String get squadFilterUnavailable => 'No disponibles';

  @override
  String get squadLineAll => 'Todas las líneas';

  @override
  String get squadSortBy => 'Ordenar';

  @override
  String get squadSortRating => 'Valoración';

  @override
  String get squadSortCaps => 'Partidos';

  @override
  String get squadSortGoals => 'Goles';

  @override
  String get squadSortAge => 'Edad';

  @override
  String get squadSortName => 'Nombre';

  @override
  String get squadLegendTitle => 'Qué significan los símbolos';

  @override
  String get squadLegendStarting => 'En tu once inicial';

  @override
  String get squadLegendCalledUp => 'Convocado, en el banquillo';

  @override
  String get squadLegendRatingUp => 'Valoración en alza este año';

  @override
  String get squadLegendRatingDown => 'Valoración a la baja este año';

  @override
  String get squadLegendInjured => 'Lesionado, no disponible';

  @override
  String get squadLegendSuspended => 'Sancionado, no disponible';

  @override
  String get squadLegendTraits => 'CONOCIDO POR';

  @override
  String squadShowingOf(int shown, int total) {
    return 'Mostrando $shown de $total jugadores';
  }

  @override
  String get squadNobodyMatches => 'Ningún jugador coincide con esos filtros.';

  @override
  String get squadStatPool => 'Disponibles';

  @override
  String get squadStatInSquad => 'Convocados';

  @override
  String get squadMostCapped => 'Más internacional';

  @override
  String get squadTopScorer => 'Máximo goleador';

  @override
  String squadCapsValue(String name, int caps) {
    return '$name · $caps partidos';
  }

  @override
  String squadGoalsValue(String name, int goals) {
    return '$name · $goals goles';
  }

  @override
  String squadAgeClub(int age, String club) {
    return '$age · $club';
  }

  @override
  String get squadCapsShort => 'PJ';

  @override
  String get squadGoalsShort => 'Gls';

  @override
  String get recordsRecordBookSubtitle =>
      'Partidos, goles y los grandes récords del equipo';

  @override
  String get statsLegacy => 'LEGADO';

  @override
  String tacticsSubAlreadyOff(String name) {
    return '$name ya ha sido sustituido y no puede volver a entrar.';
  }

  @override
  String tacticsSubSentOff(String name) {
    return '$name ha sido expulsado y no puede volver a participar.';
  }

  @override
  String get tacticsInjuredShort => 'LESIONADO';

  @override
  String get tacticsSuspendedShort => 'SANCIONADO';

  @override
  String get confEurope => 'Europa';

  @override
  String get confSouthAmerica => 'Sudamérica';

  @override
  String get confNorthAmerica => 'Norteamérica';

  @override
  String get confAfrica => 'África';

  @override
  String get confAsia => 'Asia';

  @override
  String get confOceania => 'Oceanía';

  @override
  String get compWorldCup => 'Campeonato del Mundo';

  @override
  String get compWorldCupFinals => 'Fase final del Campeonato del Mundo';

  @override
  String get compWorldCupQualifying =>
      'Clasificación para el Campeonato del Mundo';

  @override
  String compQualifiers(String region) {
    return 'Clasificación de $region';
  }

  @override
  String get compFriendlies => 'Amistosos';

  @override
  String get compNationsCup => 'Copa de las Naciones';

  @override
  String get compContinentalClash => 'Duelo Continental';

  @override
  String get compIntercontinentalPlayoff => 'Repesca Intercontinental';

  @override
  String get compContinentalChampionship => 'Campeonato Continental';

  @override
  String get compEuropeanChampionship => 'Campeonato de Europa';

  @override
  String get compSouthAmericaCup => 'Copa de Sudamérica';

  @override
  String get compAfricanChampionship => 'Campeonato de África';

  @override
  String get compAsianChampionship => 'Campeonato de Asia';

  @override
  String get compNorthAmericaCup => 'Copa de Norteamérica';

  @override
  String get compOceaniaCup => 'Copa de Oceanía';

  @override
  String get msgANation => 'Una selección';

  @override
  String get msgAPlayer => 'Un jugador';

  @override
  String get msgAHostNation => 'un país anfitrión';

  @override
  String get msgCycleTitle1 => 'Empieza un nuevo ciclo';

  @override
  String msgCycleTitle2(int year) {
    return 'Arranca el camino hacia $year';
  }

  @override
  String get msgCycleTitle3 => 'Amanece una nueva campaña';

  @override
  String get msgCycleTitle4 => 'De vuelta al trabajo';

  @override
  String msgCycleBody1(int year) {
    return 'El camino hacia el Campeonato del Mundo de $year empieza aquí.';
  }

  @override
  String msgCycleBody2(int year) {
    return 'Un nuevo ciclo. El objetivo es el Campeonato del Mundo de $year.';
  }

  @override
  String msgCycleBody3(int year) {
    return 'Cuatro años hasta el Campeonato del Mundo de $year. El trabajo empieza ya.';
  }

  @override
  String msgCycleBody4(int year) {
    return 'La campaña de $year empieza hoy.';
  }

  @override
  String msgContHostTitle(String cup, String host) {
    return 'Sede de $cup: $host';
  }

  @override
  String msgContHostBody(String host, String cup) {
    return '$host organizará la próxima edición de $cup.';
  }

  @override
  String msgContQualDrawTitle(String cup) {
    return 'Sorteo de clasificación de $cup';
  }

  @override
  String msgContQualDrawBody(String cup) {
    return 'Ya se han sorteado los grupos de clasificación de $cup.';
  }

  @override
  String msgWcHostTitle(String host, int year) {
    return 'Sede del Campeonato del Mundo de $year: $host';
  }

  @override
  String msgWcHostBody(String host, int year) {
    return '$host organizará el Campeonato del Mundo de $year.';
  }

  @override
  String get msgWcQualDrawTitle =>
      'Sorteo de clasificación del Campeonato del Mundo';

  @override
  String get msgWcQualDrawBody =>
      'Ya se han sorteado los grupos de clasificación del Campeonato del Mundo.';

  @override
  String msgContFinalsDrawTitle(String cup) {
    return 'Sorteo de la fase final de $cup';
  }

  @override
  String msgContFinalsDrawBody(String cup) {
    return 'Ya se han sorteado los grupos de la fase final de $cup.';
  }

  @override
  String get msgWcFinalsDrawTitle =>
      'Sorteo de la fase final del Campeonato del Mundo';

  @override
  String msgWcFinalsDrawBody(int year) {
    return 'Ya se ha celebrado el sorteo de la fase final del Campeonato del Mundo de $year.';
  }

  @override
  String get msgQualWcTitle1 => 'Clasificados para el Campeonato del Mundo';

  @override
  String get msgQualWcTitle2 => 'Billete para el Mundial';

  @override
  String get msgQualWcTitle3 => '¡Nos vamos al Campeonato del Mundo!';

  @override
  String get msgQualWcTitle4 => 'Billete sellado';

  @override
  String msgQualWcBody1(int year) {
    return 'Te has clasificado para la fase final del Campeonato del Mundo de $year.';
  }

  @override
  String msgQualWcBody2(int year) {
    return 'Es oficial: tu selección estará en el Campeonato del Mundo de $year.';
  }

  @override
  String msgQualWcBody3(int year) {
    return 'Plaza asegurada para el Campeonato del Mundo de $year.';
  }

  @override
  String msgQualWcBody4(int year) {
    return 'Estás en la fase final del Campeonato del Mundo de $year.';
  }

  @override
  String msgQualContTitle1(String cup) {
    return 'Clasificados: $cup';
  }

  @override
  String msgQualContTitle2(String cup) {
    return 'Billete para $cup';
  }

  @override
  String msgQualContTitle3(String cup) {
    return 'Clasificados para $cup';
  }

  @override
  String msgQualContBody1(String cup) {
    return 'Te has clasificado para la fase final de $cup.';
  }

  @override
  String msgQualContBody2(String cup) {
    return 'Tu selección ha sellado su plaza en $cup.';
  }

  @override
  String msgQualContBody3(String cup) {
    return 'Estás clasificado para $cup.';
  }

  @override
  String msgChampTitleMine1(String comp) {
    return '¡CAMPEONES: $comp!';
  }

  @override
  String msgChampTitleMine2(String comp) {
    return '¡Campeones de $comp!';
  }

  @override
  String msgChampTitleMine3(String comp) {
    return '¡Has ganado $comp!';
  }

  @override
  String msgChampTitleOther1(String comp) {
    return '$comp: ya hay campeón';
  }

  @override
  String msgChampTitleOther2(String comp) {
    return '$comp: campeón coronado';
  }

  @override
  String msgChampTitleOther3(String comp) {
    return '$comp ya tiene dueño';
  }

  @override
  String msgChampBodyMine1(String comp, String loser, String result, int year) {
    return 'Tu selección es campeona de $comp $year tras ganar a $loser$result.';
  }

  @override
  String msgChampBodyMine2(String comp, String loser, String result, int year) {
    return 'Has ganado $comp $year tras superar a $loser$result.';
  }

  @override
  String msgChampBodyMine3(String comp, String loser, String result, int year) {
    return '$comp $year es tuyo. $loser, derrotado$result.';
  }

  @override
  String msgChampBodyOther1(
    String winner,
    String comp,
    String loser,
    String result,
    int year,
  ) {
    return '$winner ha ganado $comp $year tras vencer a $loser$result.';
  }

  @override
  String msgChampBodyOther2(
    String winner,
    String comp,
    String loser,
    String result,
    int year,
  ) {
    return '$winner es campeón de $comp $year tras derrotar a $loser$result.';
  }

  @override
  String msgFinalScoreSuffix(int home, int away) {
    return ' por $home–$away en la final';
  }

  @override
  String msgFinalPensSuffix(int home, int away) {
    return ' en los penaltis, tras un $home–$away en la final';
  }

  @override
  String get msgWpotyTitle => 'Mejor Jugador del Mundo';

  @override
  String msgWpotyBodyMine(String name, String nation, int year) {
    return '$name ($nation) es elegido Mejor Jugador del Mundo de $year, y es uno de los tuyos.';
  }

  @override
  String msgWpotyBodyOther(String name, String nation, int year) {
    return '$name ($nation) es elegido Mejor Jugador del Mundo de $year.';
  }

  @override
  String get msgYpotTitle => 'Mejor Jugador Joven del Torneo';

  @override
  String msgYpotBodyMine(String name, String nation, int age, int year) {
    return '$name ($nation), de $age años, es elegido Mejor Jugador Joven del Torneo de $year, y es uno de los tuyos.';
  }

  @override
  String msgYpotBodyOther(String name, String nation, int age, int year) {
    return '$name ($nation), de $age años, es elegido Mejor Jugador Joven del Torneo de $year.';
  }

  @override
  String msgRankHold1(int rank) {
    return 'Te mantienes en el n.º $rank.';
  }

  @override
  String msgRankHold2(int rank) {
    return 'Sin cambios, sigues en el n.º $rank.';
  }

  @override
  String msgRankHold3(int rank) {
    return 'Estable en el n.º $rank.';
  }

  @override
  String msgRankUp1(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move puestos',
      one: '1 puesto',
    );
    return 'Subes $_temp0 en total, hasta el n.º $rank.';
  }

  @override
  String msgRankUp2(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move puestos',
      one: '1 puesto',
    );
    return 'Una subida de $_temp0 te lleva al n.º $rank.';
  }

  @override
  String msgRankUp3(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move puestos',
      one: '1 puesto',
    );
    return 'Subes $_temp0, ahora n.º $rank.';
  }

  @override
  String msgRankDown1(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move puestos',
      one: '1 puesto',
    );
    return 'Bajas $_temp0 en total, hasta el n.º $rank.';
  }

  @override
  String msgRankDown2(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move puestos',
      one: '1 puesto',
    );
    return 'Una caída de $_temp0 te deja en el n.º $rank.';
  }

  @override
  String msgRankDown3(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move puestos',
      one: '1 puesto',
    );
    return 'Bajas $_temp0, ahora n.º $rank.';
  }

  @override
  String get msgRankLeadYou => 'Eres el número uno del mundo.';

  @override
  String msgRankLeadOther(String nation) {
    return '$nation es el número uno del mundo.';
  }

  @override
  String msgRankTitle(int rank) {
    return 'Ranking mundial · n.º $rank';
  }

  @override
  String msgRankBody(String lead, String movement) {
    return 'Se ha actualizado el ranking mundial. $lead $movement';
  }

  @override
  String msgRankJumpTitleUp(int rank) {
    return 'Subida al n.º $rank';
  }

  @override
  String msgRankJumpTitleDown(int rank) {
    return 'Caída al n.º $rank';
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
      other: '$move puestos',
      one: '1 puesto',
    );
    return '$tournament ha movido el ranking mundial. $nation entró como n.º $from y salió como n.º $to, una subida de $_temp0.';
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
      other: '$move puestos',
      one: '1 puesto',
    );
    return '$tournament ha movido el ranking mundial. $nation entró como n.º $from y salió como n.º $to, una caída de $_temp0.';
  }

  @override
  String get rankingSinceWcDraw => 'Desde el sorteo del Campeonato del Mundo';

  @override
  String get rankingSinceCycleStart => 'Desde el inicio de la campaña';

  @override
  String rankingMovedFromTo(int from, int now) {
    return 'Del n.º $from al n.º $now';
  }

  @override
  String msgCapsTitle(String name, int count) {
    return '$name llega a $count partidos';
  }

  @override
  String msgCapsBody(String name, int count) {
    return '$name ya ha disputado $count partidos con tu selección.';
  }

  @override
  String msgGoalsTitle(String name, int count) {
    return '$name llega a $count goles';
  }

  @override
  String msgGoalsBody(String name, int count) {
    return '$name ya ha marcado $count goles internacionales con tu selección.';
  }

  @override
  String msgDevTitle(int year) {
    return 'Evolución de la plantilla · $year';
  }

  @override
  String msgThroughTitle(int year) {
    return 'Salidos de la cantera · $year';
  }

  @override
  String get msgThroughNote =>
      'No son una nueva hornada. Son los chavales que llegaron con once años y ya han pasado al grupo absoluto.';

  @override
  String msgNewFacesTitle(int year) {
    return 'Caras nuevas · $year';
  }

  @override
  String get msgIntakeNoteAcademy =>
      'La inversión en la cantera se nota: esta hornada llega más fuerte de lo que habría llegado.';

  @override
  String get msgIntakeNoteStanding =>
      'El país está pendiente de este equipo: con la selección escalando en el ranking mundial, los mejores chavales eligen el fútbol, y esta hornada llega más fuerte gracias a ello.';

  @override
  String get msgIntakeNoteBoth =>
      'Se notan tanto el dinero invertido en la cantera como el ascenso del equipo en el ranking mundial: esta hornada llega más fuerte de lo que habría llegado.';

  @override
  String msgIntakeTitle(int year) {
    return 'Nueva hornada de la cantera · $year';
  }

  @override
  String msgRetireCaptainTitle(String name) {
    return 'Tu capitán $name se retira';
  }

  @override
  String msgRetireTitle(String name) {
    return '$name deja la selección';
  }

  @override
  String msgRetireBody(String name, int age) {
    return '$name se ha retirado del fútbol internacional a los $age años.';
  }

  @override
  String msgRetireBodyWith(String name, String tally, int age) {
    return '$name se ha retirado del fútbol internacional a los $age años, despidiéndose con $tally.';
  }

  @override
  String msgTallyCaps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count partidos',
      one: '1 partido',
    );
    return '$_temp0';
  }

  @override
  String msgTallyGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count goles',
      one: '1 gol',
    );
    return '$_temp0';
  }

  @override
  String get msgArmbandVacant =>
      ' El brazalete queda vacante. Nombra un nuevo capitán desde la pantalla de convocatoria.';

  @override
  String msgHofTitle(String name) {
    return '$name entra en el Salón de la Fama';
  }

  @override
  String msgHofBody(String name, int caps, int goals) {
    return '$name entra en el Salón de la Fama de tu selección ($caps partidos, $goals goles). Consúltalo en Leyendas.';
  }

  @override
  String hubBanTitle(String name) {
    return '$name, sancionado';
  }

  @override
  String hubBanBody(String name, String how, int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: 'los próximos $matches partidos',
      one: 'tu próximo partido',
    );
    return '$name $how y está sancionado para $_temp0. No estará disponible para la convocatoria.';
  }

  @override
  String get hubBanHowSecondYellow => 'fue expulsado por doble amarilla';

  @override
  String get hubBanHowViolent => 'vio la roja directa por conducta violenta';

  @override
  String get hubBanHowRed => 'fue expulsado';

  @override
  String hubInjuryTitle(String name) {
    return '$name, lesionado';
  }

  @override
  String hubInjuryBody(String name, int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: '$matches partidos',
      one: '1 partido',
    );
    return '$name ha sufrido un golpe y estará de baja $_temp0.';
  }

  @override
  String get hubRunnerUpTitle1 => 'Subcampeones';

  @override
  String get hubRunnerUpTitle2 => 'Tan cerca y tan lejos';

  @override
  String get hubRunnerUpTitle3 => 'Medalla de plata';

  @override
  String hubRunnerUpBody1(String cup, String opponent) {
    return 'Llegaste a la final de $cup pero perdiste contra $opponent. Muy cerca. Esta vez, plata.';
  }

  @override
  String hubRunnerUpBody2(String cup, String opponent) {
    return 'Derrota ante $opponent en la final de $cup. Subcampeones, y por muy poco.';
  }

  @override
  String hubRunnerUpBody3(String cup, String opponent) {
    return 'La final de $cup se escapó ante $opponent. Hay mucho de lo que estar orgulloso, pero no del trofeo.';
  }

  @override
  String get hubKnockedOutTitle1 => 'Eliminados';

  @override
  String get hubKnockedOutTitle2 => 'Fin del camino';

  @override
  String get hubKnockedOutTitle3 => 'Se acabó el viaje';

  @override
  String hubKnockedOutBody1(String cup, String opponent, String stage) {
    return '$cup: estás eliminado, derrotado por $opponent ($stage).';
  }

  @override
  String hubKnockedOutBody2(String cup, String opponent, String stage) {
    return '$opponent pone fin a tu $cup ($stage).';
  }

  @override
  String hubKnockedOutBody3(String cup, String opponent, String stage) {
    return '$cup: tu torneo termina ($stage), derrotado por $opponent.';
  }

  @override
  String get hubGroupExitTitle1 => 'Eliminados en la fase de grupos';

  @override
  String get hubGroupExitTitle2 => 'Fuera en la fase de grupos';

  @override
  String get hubGroupExitTitle3 => 'A la ducha antes de tiempo';

  @override
  String hubGroupExitBody1(String cup) {
    return '$cup: tu torneo termina en la fase de grupos. No bastó para llegar a las eliminatorias.';
  }

  @override
  String hubGroupExitBody2(String cup) {
    return 'No pudiste salir del grupo. $cup se acaba aquí para ti.';
  }

  @override
  String hubGroupExitBody3(String cup) {
    return 'Esta vez no hay plaza en las eliminatorias. $cup: fuera en la fase de grupos.';
  }

  @override
  String boardObjectiveMetTitle(String comp) {
    return 'Objetivo cumplido: $comp';
  }

  @override
  String boardObjectiveMissedTitle(String comp) {
    return 'Objetivo fallido: $comp';
  }

  @override
  String boardObjectiveMetBody(String comp, String demand, String finish) {
    return 'Objetivo de la directiva en $comp: $demand. Tu resultado: $finish. Tienen lo que pidieron.';
  }

  @override
  String boardObjectiveMissedBody(String comp, String demand, String finish) {
    return 'Objetivo de la directiva en $comp: $demand. Tu resultado: $finish. Se queda corto respecto a lo esperado.';
  }

  @override
  String get newsWcMissTitle => 'Adiós al sueño del Campeonato del Mundo';

  @override
  String newsWcMissBody(int year) {
    return 'No estarás en el Campeonato del Mundo de $year. La fase de clasificación se quedó corta. Otros cuatro años.';
  }

  @override
  String get newsRecordScorerTitle => 'Máximo goleador de la historia';

  @override
  String newsRecordScorerBody(String name, int goals) {
    return '$name es ya el máximo goleador de la historia con $goals goles.';
  }

  @override
  String get newsRecordCapsTitle => 'Jugador con más partidos';

  @override
  String newsRecordCapsBody(String name, int caps) {
    return '$name es ya el jugador con más partidos internacionales de la historia, con $caps.';
  }

  @override
  String get newsARecordBreaker => 'Un nuevo plusmarquista';

  @override
  String newsTransferTitle(String name, String club) {
    return '$name ficha por $club';
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
    return '$name ($position, $rating) deja $fromClub y ficha por $destination a cambio de $fee.';
  }

  @override
  String newsTransferAbroad(String club, String country) {
    return '$club ($country)';
  }

  @override
  String get newsTransferFree => 'Gratis';

  @override
  String newsNatzStarTitle(String name, String nation) {
    return '⭐ ¡$name jugaría para $nation!';
  }

  @override
  String newsNatzTitle(String name, String nation) {
    return '$name quiere jugar para $nation';
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
    return '$name, $position de $age años con valoración $rating, actualmente con $fromNation, tiene raíces familiares en $nation y está dispuesto a cambiar. Abre la oferta de nacionalización para aceptar o rechazar.';
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
    return '$name, $position de $age años con valoración $rating, actualmente con $fromNation, es una estrella con raíces familiares en $nation y está dispuesto a cambiar. Abre la oferta de nacionalización para aceptar o rechazar.';
  }

  @override
  String get newsTheirNation => 'su selección';

  @override
  String get newsYourNation => 'tu selección';

  @override
  String get tourStatusChampions => 'CAMPEONES';

  @override
  String get tourStatusFinals => 'FASE FINAL';

  @override
  String get tourStatusQualifying => 'CLASIFICACIÓN';

  @override
  String get tourStatusUpcoming => 'PRÓXIMAMENTE';

  @override
  String get tourStatusInProgress => 'EN JUEGO';

  @override
  String get tourStatusComingSoon => 'MUY PRONTO';

  @override
  String get tourStatusDecided => 'DECIDIDO';

  @override
  String tourStatusLeague(String letter) {
    return 'LIGA $letter';
  }

  @override
  String get tourDrawWcQualifying => 'SORTEO DE CLASIFICACIÓN MUNDIAL';

  @override
  String tourDrawContQualifying(String cup) {
    return 'SORTEO DE CLASIFICACIÓN: $cup';
  }

  @override
  String get tourDrawWcHost => 'SEDE DEL CAMPEONATO DEL MUNDO';

  @override
  String tourDrawContHost(String cup) {
    return 'SEDE: $cup';
  }

  @override
  String get tourDrawHostsReveal => 'Y los anfitriones serán…';

  @override
  String get tourDrawHostReveal => 'Y el anfitrión será…';

  @override
  String get tourDrawHostCandidates => 'Las candidaturas en liza:';

  @override
  String get tourKickoffContinentalCup => 'COPA CONTINENTAL';

  @override
  String tourHostCompetitionYear(String competition, int year) {
    return '$competition $year';
  }

  @override
  String newsContMissTitle(String cup) {
    return 'Sin billete para $cup';
  }

  @override
  String newsContMissBody(String cup) {
    return 'No te has clasificado para $cup. Esta vez la campaña se quedó corta.';
  }

  @override
  String get potyLabelBest => 'Jugador del Año';

  @override
  String get potyLabelYoung => 'Jugador Joven del Año';

  @override
  String potyTallyAssists(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count asistencias',
      one: '1 asistencia',
    );
    return '$_temp0';
  }

  @override
  String potyOverallValue(int value) {
    return 'Valoración $value';
  }

  @override
  String potyRatingValue(String value) {
    return 'Nota media $value';
  }

  @override
  String newsPotyTitle(int year) {
    return 'Mejor Jugador del Mundo $year';
  }

  @override
  String newsPotyBody(String name) {
    return '$name es el mejor jugador del mundo este año.';
  }

  @override
  String newsPotyYoungSuffix(String name) {
    return ' $name se lleva el premio al mejor jugador joven.';
  }

  @override
  String newsWatchTitle(int year) {
    return 'Los chavales que sigues, $year';
  }

  @override
  String newsWatchJump(String name, int rating, int gain) {
    String _temp0 = intl.Intl.pluralLogic(
      gain,
      locale: localeName,
      other: '$gain puntos',
      one: 'un punto',
    );
    return '$name ha dado el salto hasta $rating, $_temp0 más que el año pasado.';
  }

  @override
  String newsWatchBand(String name, String band) {
    return '$name sube de categoría: $band.';
  }

  @override
  String newsWatchDebutTitle(String name) {
    return '$name debuta';
  }

  @override
  String newsWatchDebutBody(String name, int age, int rating) {
    return '$name ha debutado con la absoluta a los $age años, con valoración $rating. Es uno de los chavales que sigues.';
  }

  @override
  String get matchStatsAtFullTime =>
      'La posesión, las notas de los jugadores y el mejor del partido se deciden al pitido final.';

  @override
  String get matchPlayerRatings => 'NOTAS DE LOS JUGADORES';

  @override
  String get matchSubstitutions => 'CAMBIOS';

  @override
  String get matchSubstitutes => 'SUPLENTES';

  @override
  String get matchPlayerOfTheMatch => 'MEJOR JUGADOR DEL PARTIDO';

  @override
  String get matchGoalShout => '¡GOL!';

  @override
  String matchShootoutScore(int home, int away) {
    return 'PENALTIS $home–$away';
  }

  @override
  String get tourVenues => 'SEDES';

  @override
  String tourPot(int number) {
    return 'BOMBO $number';
  }

  @override
  String get tourHostSelection => 'ELECCIÓN DE SEDE';

  @override
  String get tourCandidates => 'CANDIDATOS';

  @override
  String get tourJointBid => 'CANDIDATURA CONJUNTA';

  @override
  String get tourGoldenGlove => 'GUANTE DE ORO';

  @override
  String get tourTeamOfTournament => 'EQUIPO DEL TORNEO';

  @override
  String get tourYourRun => 'TU CAMINO';

  @override
  String get tourMedalTable => 'MEDALLERO';

  @override
  String tourHostLine(String nation) {
    return 'Sede: $nation';
  }

  @override
  String tourHostLineMulti(String hosts) {
    return 'Sedes: $hosts';
  }

  @override
  String tourGroupNamed(String name) {
    return 'Grupo $name';
  }

  @override
  String get tourFinalsDrawBlurb =>
      'Cabezas de serie según el ranking mundial. Localiza a tu selección antes del sorteo.';

  @override
  String get tourWorldRanking => 'Ranking mundial';

  @override
  String get tourYourCompetitions => 'TUS COMPETICIONES';

  @override
  String get tourOtherContinents => 'OTROS CONTINENTES';

  @override
  String get tourZoneGlobal => 'MUNDIAL';

  @override
  String get tourZoneEurope => 'EUROPA';

  @override
  String get tourZoneSouthAmerica => 'SUDAMÉRICA';

  @override
  String get tourZoneNorthAmerica => 'NORTEAMÉR.';

  @override
  String get tourZoneAfrica => 'ÁFRICA';

  @override
  String get tourZoneAsia => 'ASIA';

  @override
  String get tourZoneOceania => 'OCEANÍA';

  @override
  String get tourZoneIntercontinental => 'INTERCONTINENTAL';

  @override
  String tourZoneLeague(String league) {
    return 'LIGA $league';
  }

  @override
  String tourHostedBy(String hosts) {
    return 'ORGANIZA  $hosts';
  }

  @override
  String tourThirdsAdvance(int count, String destination) {
    return 'Los $count mejores pasan a $destination';
  }

  @override
  String newsWalkoutTitle(String name) {
    return '$name se marcha';
  }

  @override
  String newsWalkoutBody(String name, int age, int caps) {
    return '$name se ha retirado de la selección a los $age años, con $caps internacionalidades. Pidió saber cuál era su situación, no se la dijeron y ya no piensa esperar más.';
  }

  @override
  String get pressHeadlineWent1 => 'Un seleccionador que domina la sala';

  @override
  String get pressHeadlineWent2 =>
      'Vinieron a buscar pelea y encontraron a un líder';

  @override
  String get pressHeadlineWent3 => 'Respuestas claras, y calaron';

  @override
  String get pressHeadlineMixed1 => 'Mucho que decir, poco resuelto';

  @override
  String get pressHeadlineMixed2 => 'Algo para todos y nada para nadie';

  @override
  String get pressHeadlineMixed3 =>
      'Una rueda de prensa que dejó las preguntas abiertas';

  @override
  String get pressHeadlineBadly1 => 'Una tarde dura ante las cámaras';

  @override
  String get pressHeadlineBadly2 => 'La sala se giró en contra, y se notó';

  @override
  String get pressHeadlineBadly3 => 'Respuestas que mañana sonarán peor';

  @override
  String get pressHeadlineFlat1 => 'Nada dicho, nada ganado';

  @override
  String get pressHeadlineFlat2 => 'Diez minutos, ninguna noticia';

  @override
  String get pressHeadlineFlat3 => 'Una página en blanco para la contraportada';

  @override
  String get pressConferenceTitle => 'RUEDA DE PRENSA';

  @override
  String pressQuestionOf(int index, int total) {
    return 'Pregunta $index de $total';
  }

  @override
  String get pressTomorrowsHeadline => 'LA PORTADA DE MAÑANA';

  @override
  String get pressLeaveRoom => 'SALIR DE LA SALA';

  @override
  String get pressRoomVerdictSquad => 'Vestuario';

  @override
  String get pressRoomVerdictBoard => 'Directiva';

  @override
  String get yReactionElation0 => 'sin comentarios. ninguno. perfecto.';

  @override
  String get yReactionElation1 => 'Estoy fatal (para bien).';

  @override
  String get yReactionElation2 => 'esto lo enmarco. encima de la chimenea.';

  @override
  String get yReactionElation3 => 'hemos vuelto, señores';

  @override
  String get yReactionElation4 => 'Captura para los que dudaban. Para todos.';

  @override
  String get yReactionElation5 =>
      'Voy a ser insoportable con esto durante diez años.';

  @override
  String get yReactionElation6 => 'Eso. Por esto vemos fútbol.';

  @override
  String get yReactionElation7 => 'Días así compensan todos los demás.';

  @override
  String get yReactionElation8 => 'Ya era hora. De verdad, ya era hora.';

  @override
  String get yReactionElation9 =>
      'Genial. Ahora repetidlo la semana que viene y me lo creeré.';

  @override
  String get yReactionElation10 =>
      'Disfrutad esta noche, que estos encontrarán la forma de estropearlo.';

  @override
  String get yReactionElation11 =>
      'Una buena noche no convierte a nadie en un gran equipo.';

  @override
  String get yReactionRelief0 => 'Feo, pero lo firmo siempre.';

  @override
  String get yReactionRelief1 => 'No sé cómo. ¡No sé cómo!';

  @override
  String get yReactionRelief2 => 'Feo. Tres puntos. A otra cosa.';

  @override
  String get yReactionRelief3 =>
      'Me quedo con lo feo todo el día si trae puntos.';

  @override
  String get yReactionRelief4 => 'me ha quitado diez años de vida';

  @override
  String get yReactionRelief5 => 'Que nadie hable. Que nadie lo gafe.';

  @override
  String get yReactionRelief6 => 'Pulsaciones: inaceptables.';

  @override
  String get yReactionRelief7 =>
      'Sobrevivimos. Esa es la palabra. Sobrevivimos.';

  @override
  String get yReactionRelief8 =>
      'No deberíamos necesitar alivio en partidos así.';

  @override
  String get yReactionRelief9 =>
      'Aliviado, y un poco avergonzado de estar aliviado.';

  @override
  String get yReactionRelief10 => 'Si esto es lo que celebramos, vamos mal.';

  @override
  String get yReactionRelief11 =>
      'Pasar por los pelos se ha vuelto costumbre, y no es buena.';

  @override
  String get yReactionFury0 => 'No es suficiente. Ni de lejos.';

  @override
  String get yReactionFury1 => 'Que alguien me lo explique despacito.';

  @override
  String get yReactionFury2 => 'Eso ha costado verlo, y estoy siendo educado.';

  @override
  String get yReactionFury3 => 'Decepcionado. Decepcionado de verdad.';

  @override
  String get yReactionFury4 => 'Qué vergüenza todo.';

  @override
  String get yReactionFury5 => 'Quiero nombres.';

  @override
  String get yReactionFury6 => 'Borro la app. La reinstalo el jueves.';

  @override
  String get yReactionFury7 => 'Ninguno ahí fuera parecía tener ganas.';

  @override
  String get yReactionFury8 => 'Cada cuatro años, lo mismo. CADA cuatro años.';

  @override
  String get yReactionFury9 => 'Eso no es una actuación, es un insulto.';

  @override
  String get yReactionFury10 =>
      'La gente gasta fines de semana y dinero en esto. Pensadlo.';

  @override
  String get yReactionFury11 =>
      'Llevo años defendiendo a este equipo. Hoy no. Después de esto, no.';

  @override
  String get yReactionDespair0 => 'en fin.';

  @override
  String get yReactionDespair1 => 'Hoy no hay bromas. Nada.';

  @override
  String get yReactionDespair2 => 'Me voy a dar un paseo. Largo.';

  @override
  String get yReactionDespair3 => 'Ya no sé de qué otra forma decirlo.';

  @override
  String get yReactionDespair4 => 'Despertadme dentro de cuatro años.';

  @override
  String get yReactionDespair5 => 'esta es la peor línea temporal posible';

  @override
  String get yReactionDespair6 => 'Ya ni me enfado. Eso es lo preocupante.';

  @override
  String get yReactionDespair7 => 'Esta va a escocer mucho tiempo.';

  @override
  String get yReactionDespair8 =>
      'No sé qué es esto ya, pero un equipo de fútbol no es.';

  @override
  String get yReactionDespair9 =>
      'Estamos más lejos que antes, y nadie lo va a decir.';

  @override
  String get yReactionDespair10 =>
      'Una generación entera desperdiciada y los mismos de siempre deciden qué viene ahora.';

  @override
  String get yReactionDespair11 =>
      'Dejad de decirme que es un proceso. No va a ninguna parte.';

  @override
  String get yReactionSmugness0 => 'Sin hacer ruido, pero: os lo dije.';

  @override
  String get yReactionSmugness1 => 'guardad este tuit';

  @override
  String get yReactionSmugness2 => 'Los que dudaban están muy calladitos.';

  @override
  String get yReactionSmugness3 =>
      'No es que nadie lleve la cuenta. Yo la llevo.';

  @override
  String get yReactionSmugness4 => 'Lo dije en enero. Mirad mi perfil.';

  @override
  String get yReactionSmugness5 =>
      'Algunos de vosotros nos debéis una disculpa a algunos de nosotros.';

  @override
  String get yReactionSmugness6 => 'Archivado en: cosas que dije yo primero.';

  @override
  String get yReactionSmugness7 => 'Sin regodearse. Bueno, un poquito.';

  @override
  String get yReactionSmugness8 =>
      '¿Dónde están ahora los expertos? Pregunta sincera.';

  @override
  String get yReactionSmugness9 =>
      'Quiero que todos y cada uno de vosotros me lo repitáis.';

  @override
  String get yReactionSmugness10 =>
      'Captura, impresa, enmarcada y enviada a los que se rieron.';

  @override
  String get yReactionSmugness11 =>
      'Os lo voy a recordar el resto de mi vida y os lo habéis ganado.';

  @override
  String get yReactionShrug0 => 'pasó. siguiente.';

  @override
  String get yReactionShrug1 => 'Vale. Lo que sea. Adelante.';

  @override
  String get yReactionShrug2 => 'Archivado en «fútbol».';

  @override
  String get yReactionShrug3 => 'Nada que añadir, de verdad.';

  @override
  String get yReactionShrug4 => 'cero pensamientos, cabeza vacía';

  @override
  String get yReactionShrug5 => 'Despertadme para el siguiente.';

  @override
  String get yReactionShrug6 => 'Noventa minutos que no voy a recuperar.';

  @override
  String get yReactionShrug7 => 'Ni fu ni fa, la verdad.';

  @override
  String get yReactionShrug8 =>
      'No sabría decirte ni una sola cosa que pasara.';

  @override
  String get yReactionShrug9 => 'Otro de esos. Hay muchos de esos.';

  @override
  String get yReactionShrug10 => 'Lo vi entero y no sentí absolutamente nada.';

  @override
  String get yReactionShrug11 =>
      'Si nadie vuelve a mencionarlo, por mí perfecto.';

  @override
  String get tourThirdsUneven =>
      'Los grupos son desiguales, así que se descartan los resultados contra el último de cada grupo grande y todos los equipos se juzgan sobre los mismos partidos.';

  @override
  String get careerExportSave => 'Copia de seguridad de esta partida';

  @override
  String get careerBackupAll => 'COPIA DE TODAS LAS PARTIDAS';

  @override
  String get careerBackupAllFailed => 'No se pudo crear la copia de seguridad.';

  @override
  String get backupTitle => 'PARTIDAS';

  @override
  String get backupBlurb =>
      'Todas las partidas están en un único archivo en este teléfono y nada hace una copia por sí solo. Exporta una copia y guárdala fuera del teléfono, en Archivos o iCloud Drive, para que perder el móvil o borrar la app no te cueste una carrera.';

  @override
  String get backupExport => 'EXPORTAR COPIA';

  @override
  String get backupExportSubject => 'Partidas de FNM';

  @override
  String get backupRestore => 'RESTAURAR DESDE ARCHIVO';

  @override
  String get backupRestoreWarnTitle => '¿Reemplazar todas las partidas?';

  @override
  String get backupRestoreWarnBody =>
      'Restaurar reemplaza todas las partidas de este teléfono por las del archivo. La app se reiniciará.';

  @override
  String get backupRestoreConfirm => 'REEMPLAZAR';

  @override
  String get backupCancel => 'CANCELAR';

  @override
  String get backupExported => 'Copia lista. Elige dónde guardarla.';

  @override
  String get backupFailed => 'No se pudo crear la copia de seguridad.';

  @override
  String get backupRejectedUnreadable => 'No se pudo abrir ese archivo.';

  @override
  String get backupRejectedNotFnm => 'Eso no es una partida de FNM.';

  @override
  String get backupRejectedNewer =>
      'Esa partida se creó con una versión más reciente de la app. Actualiza primero.';

  @override
  String get backupRejectedTooOld =>
      'Esa partida es demasiado antigua para restaurarla con esta versión.';

  @override
  String get careerShare => 'Compartir esta carrera';

  @override
  String get careerImport => 'IMPORTAR CARRERA';

  @override
  String get careerShareSubject => 'Una carrera de FNM';

  @override
  String get careerImported => 'Carrera importada.';

  @override
  String get careerImportFailedUnreadable =>
      'Ese archivo no es una carrera de FNM.';

  @override
  String get careerImportFailedNewer =>
      'Esa carrera se exportó con una versión más reciente de la app. Actualiza primero.';

  @override
  String get careerShareFailed => 'No se pudo exportar esa carrera.';

  @override
  String get managerRename => 'Cambiar nombre';

  @override
  String get managerRenameSave => 'Guardar';

  @override
  String get managerTitle => 'SELECCIONADOR';

  @override
  String get managerSkills => 'TUS HABILIDADES';

  @override
  String managerPointsAvailable(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count puntos por gastar',
      one: '1 punto por gastar',
      zero: 'No hay puntos por gastar',
    );
    return '$_temp0';
  }

  @override
  String get managerPointsHow =>
      'Dos puntos por cada ciclo que completes, uno por cada título que ganes.';

  @override
  String get managerSkillsScale =>
      'Cada habilidad empieza en 5 y llega hasta 20. Un punto gastado es permanente.';

  @override
  String get managerSkillManManagement => 'Gestión de grupo';

  @override
  String get managerSkillManManagementBlurb =>
      'Cada punto hace que lo que dices a la prensa y a tus jugadores cale un 3% más en el vestuario.';

  @override
  String get managerSkillTactical => 'Táctica';

  @override
  String get managerSkillTacticalBlurb =>
      'Cada punto asienta una nueva formación un 3% más rápido, así que cambiar de dibujo te cuesta menos partidos.';

  @override
  String get managerSkillYouth => 'Formación de jóvenes';

  @override
  String get managerSkillYouthBlurb =>
      'Cada punto añade un 1% al talento que sale de tu cantera, además de lo que inviertas en ella.';

  @override
  String get managerSkillNegotiation => 'Negociación';

  @override
  String get managerSkillNegotiationBlurb =>
      'Cada punto es un 2% más de dinero de la federación, en cada ciclo.';

  @override
  String get managerStaff => 'TU CUERPO TÉCNICO';

  @override
  String managerStaffWages(String amount) {
    return 'Sueldos: $amount por ciclo';
  }

  @override
  String get managerRoleAssistant => 'Segundo entrenador';

  @override
  String get managerRoleAssistantBlurb =>
      'Dirige los entrenamientos: menos lesiones y mejores jóvenes saliendo de la cantera.';

  @override
  String get managerRoleScout => 'Ojeador jefe';

  @override
  String get managerRoleScoutBlurb =>
      'Analiza a tus promesas y a tu próximo rival: valoraciones con estrellas más fiables y ventaja el día del partido.';

  @override
  String get managerRoleFitness => 'Preparador físico';

  @override
  String get managerRoleFitnessBlurb => 'Los mantiene en el campo.';

  @override
  String staffEffectInjury(int percent) {
    return '$percent% menos lesiones';
  }

  @override
  String staffEffectYouth(int points) {
    return 'Jóvenes +$points de media';
  }

  @override
  String staffHiringInjury(int min, int max) {
    return 'Si contratas uno: del $min% al $max% menos lesiones';
  }

  @override
  String staffHiringYouth(int minPoints, int maxPoints) {
    return 'y jóvenes de +$minPoints a +$maxPoints de media';
  }

  @override
  String staffEffectScoutRead(int percent) {
    return 'Acierta con el $percent% de las promesas';
  }

  @override
  String staffEffectScoutCaps(int caps) {
    String _temp0 = intl.Intl.pluralLogic(
      caps,
      locale: localeName,
      other: 'Potencial conocido tras $caps partidos internacionales',
      one: 'Potencial conocido tras 1 partido internacional',
    );
    return '$_temp0';
  }

  @override
  String staffEffectScoutDossier(int points) {
    return '+$points de valoración por los informes del rival';
  }

  @override
  String staffHiringScoutRead(int min, int max) {
    return 'Si contratas uno: del $min% al $max% de aciertos';
  }

  @override
  String staffHiringScoutCaps(int minCaps, int maxCaps) {
    return 'y potencial conocido de $minCaps a $maxCaps partidos antes';
  }

  @override
  String staffHiringScoutDossier(int minPoints, int maxPoints) {
    return 'y de +$minPoints a +$maxPoints de valoración en cada partido';
  }

  @override
  String get staffEffectNone => 'Aún sin efecto en tu plantilla';

  @override
  String get staffVacant => 'Puesto vacante';

  @override
  String get staffLeaveVacant => 'Dejar el puesto vacante';

  @override
  String get managerTierNone => 'Ninguno';

  @override
  String get managerTierBasic => 'Básico';

  @override
  String get managerTierGood => 'Bueno';

  @override
  String get managerTierElite => 'Élite';

  @override
  String get managerFree => 'gratis';

  @override
  String get managerTraining => 'ENTRE VENTANAS';

  @override
  String get managerTrainingBlurb =>
      'En qué trabaja la plantilla cuando no hay partido.';

  @override
  String get managerFocusBalanced => 'Equilibrado';

  @override
  String get managerFocusBalancedBlurb => 'Un poco de todo.';

  @override
  String get managerFocusFitness => 'Físico';

  @override
  String get managerFocusFitnessBlurb => 'Menos golpes.';

  @override
  String get managerFocusCohesion => 'Cohesión';

  @override
  String get managerFocusCohesionBlurb => 'El dibujo se asienta antes.';

  @override
  String get managerFocusYouth => 'Jóvenes';

  @override
  String get managerFocusYouthBlurb => 'Horas con los más jóvenes del grupo.';

  @override
  String get tourOfferTitle => '¿Primera vez por aquí?';

  @override
  String get tourOfferBody =>
      'Este juego es grande. ¿Quieres un recorrido rápido por las pantallas importantes? Dura un minuto y puedes repetirlo cuando quieras desde Ajustes.';

  @override
  String get tourOfferYes => 'Enséñamelo';

  @override
  String get tourOfferNo => 'No, gracias';

  @override
  String get tourBack => 'Atrás';

  @override
  String get tourNext => 'Siguiente';

  @override
  String get tourDone => 'Hecho';

  @override
  String get tourSkip => 'Saltar';

  @override
  String get tourHubTitle => 'Este es todo el juego';

  @override
  String get tourHubBody =>
      'Un botón que cambia según avanza el ciclo: un sorteo que ver, una convocatoria que dar, un partido que jugar. Encima están la confianza de la directiva en ti y los objetivos que te han marcado.';

  @override
  String get tourBudgetTitle => 'El dinero de la federación';

  @override
  String get tourBudgetBody =>
      'Una vez en cada ciclo de cuatro años repartes el presupuesto entre los departamentos. Tu cuerpo técnico se paga primero, así que fichar a un ojeador de élite es una decisión que tomas a costa de la cantera, no además de ella.';

  @override
  String get tourTacticsTitle => 'Cómo juega el equipo';

  @override
  String get tourTacticsBody =>
      'Tu dibujo, tu estilo de juego, tu capitán y quién lanza las jugadas a balón parado. Si dejas sin elegir las dos últimas cosas, el juego te avisará antes del pitido inicial en lugar de elegir por ti en silencio.';

  @override
  String get tourSquadTitle => 'Todos los que puedes elegir';

  @override
  String get tourSquadBody =>
      'Todo el grupo de jugadores, no solo la convocatoria: quién está en forma, quién arrastra un golpe, quién está sancionado y quién acaba de salir de la cantera.';

  @override
  String get tourCallUpsTitle => 'Dar una convocatoria';

  @override
  String get tourCallUpsBody =>
      'Das una convocatoria por cada ventana internacional y juega todos los partidos de esa ventana, igual que un seleccionador de verdad. Si hay una lesión dentro de la ventana, se llama a un sustituto por ti.';

  @override
  String get tourRecordsTitle => 'Tu carrera';

  @override
  String get tourRecordsBody =>
      'Todo lo que has hecho: los partidos, los récords del equipo, los títulos y cada selección que has dirigido.';

  @override
  String get tourCupsTitle => 'El resto del mundo';

  @override
  String get tourCupsBody =>
      'Todas las competiciones en marcha ahora mismo: grupos, clasificaciones y eliminatorias, incluidas las que no juegas. El mundo sigue jugando te hayas clasificado o no.';

  @override
  String get settingsTourTitle => 'Repetir el tutorial';

  @override
  String get settingsTourBlurb =>
      'Recorre de nuevo las pantallas clave desde el principio.';

  @override
  String get tourBoardTitle => 'Ante quién respondes';

  @override
  String get tourBoardBody =>
      'La confianza de la directiva en ti y los objetivos que te han marcado para este ciclo. Si no cumples lo pedido, aquí lo verás venir.';

  @override
  String get tourStaffTitle => 'La gente que te rodea';

  @override
  String get tourStaffBody =>
      'Un segundo entrenador, un ojeador y un preparador físico, contratados por su nombre. Sus sueldos salen de este presupuesto antes que los de los departamentos, así que un gran ojeador es una decisión a costa de la cantera.';

  @override
  String get tourPlaystyleTitle => 'Tu estilo de juego';

  @override
  String get tourPlaystyleBody =>
      'El dibujo es solo media táctica. Esta es la otra mitad: lo arriba que presionas, lo directo que eres, cuánto arriesgas.';

  @override
  String get settingsTourNoSave =>
      'Empieza antes una carrera. El recorrido visita tus propias pantallas.';

  @override
  String tacticsOutOfPositionAge(int age) {
    return 'Fuera de posición · $age años';
  }

  @override
  String get federationNextCycleLocked =>
      'El presupuesto del próximo ciclo se fija al comienzo de ese ciclo, de una vez. Hasta entonces, esto es lo que está haciendo tu dinero.';

  @override
  String get federationBudgetAlreadySet => 'Ya fijado para este ciclo';

  @override
  String yFinalLooms0(String opponent) {
    return '$opponent en la gran cita. Toda la semana no se va a hablar de otra cosa.';
  }

  @override
  String yFinalLooms1(String opponent) {
    return 'Confirmado: $opponent es lo único que nos separa. Cuatro años para esto.';
  }

  @override
  String yFinalLooms2(String opponent) {
    return 'Vale. $opponent. Aquí no duerme nadie hasta que acabe.';
  }

  @override
  String yFinalLooms3(String opponent) {
    return 'Ahora $opponent y todo lo demás puede esperar. Qué semana para estar vivo.';
  }

  @override
  String get matchSetupLeaveToCoach =>
      'Que el cuerpo técnico elija los lanzadores';

  @override
  String friendliesLikeYourGroup(String rivals) {
    return 'Marcados abajo: equipos que juegan como $rivals, los rivales de tus grupos en este ciclo.';
  }

  @override
  String newsTransferWindowTitle(int year) {
    return 'Mercado de fichajes · $year';
  }

  @override
  String careerLastAgo(String when) {
    return 'Hace $when';
  }

  @override
  String get settingsFreeScopeTitle => 'Un ciclo de cuatro años gratis';

  @override
  String get settingsFreeScopeBlurb =>
      'Un ciclo completo (clasificación, tu campeonato continental y el Campeonato del Mundo) en dos partidas, con todas las selecciones del mundo y sin nada bloqueado. Los ciclos infinitos y las partidas ilimitadas son un único pago, una sola vez, que incluye todas las actualizaciones futuras.';

  @override
  String get settingsUnlockedTitle => 'Desbloqueado';

  @override
  String get settingsUnlockedBlurb =>
      'Ciclos infinitos, partidas ilimitadas y todas las actualizaciones futuras. Gracias.';

  @override
  String get settingsFromDeveloperTitle => 'Del desarrollador';

  @override
  String get settingsFromDeveloperBlurb =>
      'Football Nations Manager lo hace una sola persona y tendrá soporte a largo plazo. Nunca habrá anuncios ni microtransacciones. Si disfrutas del juego, considera comprar la versión completa. Es lo que hace posibles las actualizaciones.';

  @override
  String get settingsFromDeveloperThanksBlurb =>
      'Football Nations Manager lo hace una sola persona y tendrá soporte a largo plazo. Nunca habrá anuncios ni microtransacciones. Gracias por comprar la versión completa. Es lo que hace posibles las actualizaciones.';

  @override
  String friendliesLikeYourCampaign(String rivals) {
    return 'Marcados abajo: equipos que juegan como $rivals, a los que aún tienes que enfrentarte.';
  }

  @override
  String get friendliesCloseToYou =>
      'Marcados abajo: los equipos más cercanos a ti en el ranking mundial. Cuando se haga el sorteo, las marcas seguirán a tu grupo.';

  @override
  String transfersMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count traspasos',
      one: '1 traspaso',
    );
    return '$_temp0';
  }

  @override
  String hubRoundPage(int page, int pages) {
    return '$page / $pages';
  }

  @override
  String get transfersNewer => 'Recientes';

  @override
  String get transfersOlder => 'Más';

  @override
  String get transfersPagePrevious => 'Anterior';

  @override
  String get transfersPageNext => 'Siguiente';

  @override
  String transfersPageOf(int page, int pages) {
    return 'Página $page de $pages';
  }

  @override
  String get transfersMovedTo => 'Fichó por';

  @override
  String get transfersUnknownClub => 'Club desconocido';

  @override
  String yAgainstThemAgain0(String opponent, String count) {
    return 'Ya van $count veces contra $opponent. Alguien lleva la cuenta, y son ellos.';
  }

  @override
  String yAgainstThemAgain1(String opponent, String count) {
    return '$opponent otra vez. $count enfrentamientos y todavía no les hemos pillado el truco.';
  }

  @override
  String yAgainstThemAgain2(String opponent, String count) {
    return 'Número $count contra $opponent. Esto ya no es casualidad.';
  }

  @override
  String yAgainstThemAgain3(String opponent, String count) {
    return 'Hemos jugado $count veces contra $opponent y no hemos aprendido nada de ninguna.';
  }

  @override
  String yAgainstThemAgain4(String opponent, String count) {
    return '$opponent, $count veces. Saben exactamente lo que vamos a hacer.';
  }

  @override
  String yAgainstThemAgain5(String opponent, String count) {
    return 'Lo que sea que $opponent tiene contra nosotros, $count partidos después, lo sigue teniendo.';
  }

  @override
  String ySameOldStory0(String count) {
    return 'Es la $count.ª vez que pasa esto últimamente. ¿En qué momento pasa a ser simplemente lo que somos?';
  }

  @override
  String ySameOldStory1(String count) {
    return 'Ya van $count tardes así. Es un patrón, no una racha de mala suerte.';
  }

  @override
  String ySameOldStory2(String count) {
    return 'Hemos visto este mismo partido $count veces últimamente. Mismo guion, mismo final.';
  }

  @override
  String ySameOldStory3(String count) {
    return 'La $count.ª versión de los mismos noventa minutos. Nadie lo arregla.';
  }

  @override
  String ySameOldStory4(String count) {
    return '$count veces. Si a estas alturas no ves el patrón, es que no miras.';
  }

  @override
  String ySameOldStory5(String count) {
    return 'La misma historia, $count veces. Se han acabado las excusas antes que los malos resultados.';
  }

  @override
  String get yToldYouSo0 =>
      'Lo dije cuando todo el mundo estaba ocupado celebrando.';

  @override
  String get yToldYouSo1 =>
      'Dos buenas semanas y otra vez éramos una generación dorada. Y aquí estamos.';

  @override
  String get yToldYouSo2 =>
      'Los que el mes pasado me decían que lo disfrutara se han quedado callados.';

  @override
  String get yToldYouSo3 => 'No me alegro de esto. Muy poco. Algo.';

  @override
  String get yToldYouSo4 =>
      'Nunca fue tan bueno como os contaron, y esta es la prueba.';

  @override
  String get yToldYouSo5 =>
      'Siempre igual. Nos dicen que esta vez es distinto y nunca lo es.';

  @override
  String get tacticsSubOffAlready => 'Ya sustituido';

  @override
  String get tacticsSubInjured => 'Lesionado';

  @override
  String get tacticsSubSentOffMark => 'Expulsado';

  @override
  String get tacticsSubNoneLeft => 'Sin cambios';

  @override
  String get tacticsUndoLastChange => 'Deshacer último cambio';

  @override
  String get matchStrengthTitle => 'QUÉ INFLUYE EN EL EQUIPO';

  @override
  String get strengthFactorFamiliarity => 'Dibujo trabajado';

  @override
  String get strengthFactorFatigue => 'Piernas cansadas';

  @override
  String get strengthFactorClubForm => 'Forma en el club';

  @override
  String get strengthFactorMorale => 'Vestuario';

  @override
  String get strengthFactorCaptain => 'Capitán';

  @override
  String get strengthFactorStaff => 'Cuerpo técnico';

  @override
  String get strengthFactorDossier => 'Informe del ojeador';

  @override
  String yDebut0(String name) {
    return '$name debuta con la selección. Quedaos con el nombre.';
  }

  @override
  String yDebut1(String name) {
    return 'Debut para $name. Se le nota, ¿a que sí?';
  }

  @override
  String yDebut2(String name) {
    return '$name, primer partido internacional. A ver qué hace con él.';
  }

  @override
  String yDebut3(String name) {
    return 'Debut de $name. Al equipo le hacían falta piernas frescas en algún sitio.';
  }

  @override
  String yDebut4(String name) {
    return '$name debuta. Últimamente estamos repartiendo muchos debuts.';
  }

  @override
  String yDebut5(String name) {
    return 'Debut de $name. Otro del que en primavera ya ni nos acordaremos.';
  }

  @override
  String yDrought0(String name, String count) {
    return '$name lleva $count partidos sin marcar y está haciendo todo lo demás en el campo.';
  }

  @override
  String yDrought1(String name, String count) {
    return '$count partidos sin gol para $name. Ya vendrán de tres en tres, como siempre.';
  }

  @override
  String yDrought2(String name, String count) {
    return '$name: $count partidos, cero goles.';
  }

  @override
  String yDrought3(String name, String count) {
    return '$count partidos sin gol para $name. Habrá que vigilarlo.';
  }

  @override
  String yDrought4(String name, String count) {
    return '$count partidos. Cero goles. $name no le da ni al arco iris.';
  }

  @override
  String yDrought5(String name, String count) {
    return '$name no marca desde hace $count partidos. Que juegue literalmente cualquier otro.';
  }

  @override
  String yRivalryLooms0(String opponent, String count) {
    return 'Ahora $opponent. $count enfrentamientos y sigue significándolo todo.';
  }

  @override
  String yRivalryLooms1(String opponent, String count) {
    return 'Ya van $count veces contra $opponent. Que vengan.';
  }

  @override
  String yRivalryLooms2(String opponent, String count) {
    return 'Ahora $opponent. Jugados: $count.';
  }

  @override
  String yRivalryLooms3(String opponent, String count) {
    return 'Enfrentamiento número $count con $opponent esta semana.';
  }

  @override
  String yRivalryLooms4(String opponent, String count) {
    return '$opponent otra vez. $count de estos y no hemos aprendido nada.';
  }

  @override
  String yRivalryLooms5(String opponent, String count) {
    return '$count partidos contra $opponent y nos siguen ganando. Maravilloso.';
  }

  @override
  String get positionGoalkeeper => 'Portero';

  @override
  String get positionLeftBack => 'Lateral izquierdo';

  @override
  String get positionCentreBack => 'Central';

  @override
  String get positionRightBack => 'Lateral derecho';

  @override
  String get positionDefensiveMid => 'Mediocentro defensivo';

  @override
  String get positionCentralMid => 'Mediocentro';

  @override
  String get positionAttackingMid => 'Mediapunta';

  @override
  String get positionLeftMid => 'Interior izquierdo';

  @override
  String get positionRightMid => 'Interior derecho';

  @override
  String get positionLeftWing => 'Extremo izquierdo';

  @override
  String get positionRightWing => 'Extremo derecho';

  @override
  String get positionStriker => 'Delantero centro';

  @override
  String get roleNone => 'Sin rol';

  @override
  String get roleTargetMan => 'Delantero referencia';

  @override
  String get rolePoacher => 'Cazagoles';

  @override
  String get rolePlaymaker => 'Organizador';

  @override
  String get roleBallWinner => 'Recuperador';

  @override
  String get roleInvertedWinger => 'Extremo a pierna cambiada';

  @override
  String get roleBallPlayingDefender => 'Central con salida de balón';

  @override
  String get roleNoneBlurb => 'Juega su juego natural.';

  @override
  String get roleTargetManBlurb =>
      'Gana balones aéreos y descarga. Asistencias y balón parado.';

  @override
  String get rolePoacherBlurb => 'Merodea en el área. Muchos más goles.';

  @override
  String get rolePlaymakerBlurb => 'Crea ocasiones. Muchas más asistencias.';

  @override
  String get roleBallWinnerBlurb => 'Corta el juego en lugar de rematarlo.';

  @override
  String get roleInvertedWingerBlurb =>
      'Se mete hacia dentro para chutar. Más goles.';

  @override
  String get roleBallPlayingDefenderBlurb => 'Inicia las jugadas desde atrás.';

  @override
  String get federationDeptYouth => 'Cantera';

  @override
  String get federationDeptCommercial => 'Comercial / Comunicación';

  @override
  String get federationDeptMedical =>
      'Servicios médicos y ciencias del deporte';

  @override
  String get federationDeptNaturalisation => 'Oficina de nacionalizaciones';

  @override
  String get federationDeptBoardRelations => 'Relaciones con la directiva';

  @override
  String get federationDeptYouthBlurb =>
      'Mejores promesas de la cantera debutan con tu selección el próximo ciclo.';

  @override
  String get federationDeptCommercialBlurb =>
      'El patrocinio aporta ingresos extra al final del ciclo.';

  @override
  String get federationDeptMedicalBlurb =>
      'Menos lesiones. Tu plantilla está disponible todo el ciclo.';

  @override
  String get federationDeptNaturalisationBlurb =>
      'Más jugadores extranjeros se ofrecen a jugar con tu selección.';

  @override
  String get federationDeptBoardRelationsBlurb =>
      'La directiva juzga tus resultados con más paciencia.';

  @override
  String get federationBuildingAcademy => 'Cantera';

  @override
  String get federationBuildingCommercial => 'Sede comercial';

  @override
  String get federationBuildingMedical => 'Centro médico';

  @override
  String get federationBuildingScouting => 'Oficina de ojeadores';

  @override
  String get federationBuildingBoardroom => 'Sala de juntas';

  @override
  String get moraleBuoyant => 'Eufórica';

  @override
  String get moralePositive => 'Positiva';

  @override
  String get moraleSettled => 'Estable';

  @override
  String get moraleUneasy => 'Inquieta';

  @override
  String get moraleRockBottom => 'Por los suelos';

  @override
  String get matchTabTimeline => 'CRONOLOGÍA';

  @override
  String get matchTabStats => 'ESTADÍSTICAS';

  @override
  String get matchTabLineups => 'ALINEACIONES';

  @override
  String get matchPenalty => 'PENALTI';

  @override
  String get matchStateLevel => 'Todo igualado';

  @override
  String matchStateLead(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ganas por $count goles',
      one: 'Ganas por un gol',
    );
    return '$_temp0';
  }

  @override
  String matchStateTrail(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Pierdes por $count goles',
      one: 'Pierdes por un gol',
    );
    return '$_temp0';
  }

  @override
  String matchPossessionShare(int possession) {
    return '$possession% de posesión';
  }

  @override
  String get boardVerdictSackedTitle => 'La directiva te ha destituido';

  @override
  String boardVerdictSackedBody(int rating) {
    return 'Un ciclo pésimo (valoración $rating%). Tu etapa termina aquí. Ahora solo selecciones menores se arriesgarán contigo.';
  }

  @override
  String get boardVerdictDelightedTitle => 'La directiva está encantada';

  @override
  String boardVerdictDelightedBody(int rating, String best) {
    return 'Un ciclo extraordinario (valoración $rating%) tras $best. Selecciones más grandes se interesan por ti, o puedes quedarte y construir.';
  }

  @override
  String get boardVerdictSolidTitle => 'Un ciclo sólido';

  @override
  String boardVerdictSolidBody(int rating) {
    return 'La directiva está satisfecha (valoración $rating%). Algunas selecciones de nivel parecido te contratarían, pero no hay prisa por moverse.';
  }

  @override
  String get boardVerdictExpectedMoreTitle => 'La directiva esperaba más';

  @override
  String boardVerdictExpectedMoreBody(int rating) {
    return 'Un ciclo decepcionante (valoración $rating%). Conservas el puesto, pero cualquier oferta sería un paso atrás.';
  }

  @override
  String get boardVerdictPressureTitle => 'Estás bajo mucha presión';

  @override
  String boardVerdictPressureBody(int rating) {
    return 'Un mal ciclo (valoración $rating%). Sobrevives, pero si quieres empezar de cero solo te quieren selecciones más débiles.';
  }

  @override
  String get boardVerdictHeroTitle => 'El país está contigo';

  @override
  String boardVerdictHeroNote(String nation, int cycles) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles ciclos',
      one: '1 ciclo',
    );
    return ' $nation te adora, eres un héroe nacional tras $_temp0; tu puesto está asegurado mientras lo quieras.';
  }

  @override
  String get boardVerdictTheNation => 'El país';

  @override
  String get boardVerdictBestQuiet => 'un ciclo tranquilo';

  @override
  String get boardVerdictBestCycle => 'el ciclo';

  @override
  String boardVerdictBestWorld(String placement) {
    return 'el Campeonato del Mundo: $placement';
  }

  @override
  String get finishThirdPlace => 'Tercer puesto';

  @override
  String get finishFourthPlace => 'Cuarto puesto';

  @override
  String get finishDidNotQualify => 'No se clasificó';

  @override
  String get careerRepIconic => 'Legendario';

  @override
  String get careerRepRenowned => 'Prestigioso';

  @override
  String get careerRepEstablished => 'Consolidado';

  @override
  String get careerRepRising => 'Emergente';

  @override
  String get careerRepUnproven => 'Sin experiencia';

  @override
  String get hubOfferStepUp => 'Paso adelante';

  @override
  String get hubOfferLateral => 'Movimiento lateral';

  @override
  String get hubOfferRebuild => 'Reconstrucción';

  @override
  String careerNationsCupWon(String league) {
    return 'Liga $league · Campeón';
  }

  @override
  String careerNationsCupRunnerUp(String league) {
    return 'Liga $league · Subcampeón';
  }

  @override
  String careerNationsCupSemi(String league) {
    return 'Liga $league · Semifinalista';
  }

  @override
  String careerNationsCupPlaced(String league, int position) {
    return 'Liga $league · $position.º';
  }

  @override
  String tourRunInto(String round) {
    return 'Próxima ronda: $round';
  }

  @override
  String get tourRunIntoThirdPlace => 'En el partido por el tercer puesto';

  @override
  String tourRunThrough(String round) {
    return 'Superada: $round';
  }

  @override
  String tourRunOut(String round) {
    return 'Eliminado: $round';
  }

  @override
  String get tourRunInGroup => 'Disputando la fase de grupos';

  @override
  String get tourRunGroupOut => 'Eliminado en la fase de grupos';

  @override
  String resultsCycleTitle(int year, String nation) {
    return 'Ciclo $year · $nation';
  }

  @override
  String resultsCycleRecord(int played, int won, int drawn, int lost) {
    return '$played jugados  ·  ${won}G ${drawn}E ${lost}P';
  }

  @override
  String resultsCycleFinish(String finish) {
    return 'Campeonato del Mundo: $finish';
  }

  @override
  String get resultsCycleUnderway => 'Todavía en juego';

  @override
  String yTurnedItRound0(String opponent) {
    return 'Perdíamos 0-2 con $opponent al descanso y lo recuperaron todo. Eso es un equipo.';
  }

  @override
  String yTurnedItRound1(String opponent) {
    return 'Dos goles abajo contra $opponent y al final daba igual. Pocos equipos hacen eso.';
  }

  @override
  String yTurnedItRound2(String opponent) {
    return 'Descanso: dos goles abajo contra $opponent. Final: ya no. La segunda parte fue otro partido.';
  }

  @override
  String yTurnedItRound3(String opponent) {
    return 'Remontada de dos goles contra $opponent. Lo que se dijera en el descanso, que se diga cada semana.';
  }

  @override
  String yTurnedItRound4(String opponent) {
    return 'Vale, lo levantamos contra $opponent. Ahora que alguien explique los primeros cuarenta y cinco minutos.';
  }

  @override
  String yTurnedItRound5(String opponent) {
    return 'Dos goles abajo contra $opponent y se supone que tenemos que estar encantados. Arreglad la primera parte.';
  }

  @override
  String yThrewItAway0(String opponent) {
    return 'Dos goles arriba contra $opponent al descanso y se nos escapó. Les pasa a equipos mejores.';
  }

  @override
  String yThrewItAway1(String opponent) {
    return 'Dos goles por delante de $opponent y se nos fue. El ciclo es largo, hay tiempo.';
  }

  @override
  String yThrewItAway2(String opponent) {
    return 'Descanso: dos goles arriba contra $opponent. Final: nada que ver.';
  }

  @override
  String yThrewItAway3(String opponent) {
    return 'Una ventaja de dos goles contra $opponent, esfumada en cuarenta y cinco minutos.';
  }

  @override
  String yThrewItAway4(String opponent) {
    return 'Dos arriba y lo perdimos. Contra $opponent. Alguien tiene que dar explicaciones.';
  }

  @override
  String yThrewItAway5(String opponent) {
    return 'Dos goles por delante contra $opponent y conseguimos esto. Siempre igual.';
  }

  @override
  String get cycleBackupDone =>
      'Carrera guardada en la carpeta FNM de este teléfono. Si desinstalas la app se borra: para guardar una copia en otro sitio, usa Copia de seguridad de esta partida en la pantalla de partidas.';

  @override
  String get cycleBackupFailed =>
      'Esta vez no se pudo hacer la copia de la carrera.';

  @override
  String pressMomentBigWinWarm1(String opponent) {
    return 'Una noche para el recuerdo contra $opponent. ¿Qué orgullo sientes por este grupo?';
  }

  @override
  String pressMomentBigWinWarm2(String opponent) {
    return '$opponent no pudo con vosotros. ¿Es este el equipo que siempre creíste tener?';
  }

  @override
  String pressMomentBigWinNeutral1(String opponent) {
    return 'Una gran victoria ante $opponent. ¿Qué marcó la diferencia esta noche?';
  }

  @override
  String pressMomentBigWinNeutral2(String opponent) {
    return '$opponent derrotado, y con comodidad. ¿Dónde ganasteis el partido?';
  }

  @override
  String pressMomentBigWinHostile1(String opponent) {
    return 'Una buena victoria ante $opponent. Una buena noche: ¿por qué debería alguien creer que va a durar?';
  }

  @override
  String pressMomentBigWinHostile2(String opponent) {
    return 'Un gran resultado contra $opponent. ¿Era tu plan o lo resolvieron los jugadores por su cuenta?';
  }

  @override
  String pressMomentBigLossWarm1(String opponent) {
    return 'Una noche dura contra $opponent. ¿Qué les dices a los jugadores después de algo así?';
  }

  @override
  String pressMomentBigLossWarm2(String opponent) {
    return 'Nadie esperaba eso contra $opponent. ¿Ha sido simplemente una de esas noches?';
  }

  @override
  String pressMomentBigLossNeutral1(String opponent) {
    return 'Ha sido una noche dolorosa contra $opponent. ¿Qué ha fallado?';
  }

  @override
  String pressMomentBigLossNeutral2(String opponent) {
    return '$opponent os ha pasado por encima. ¿Es suficientemente buena esta plantilla?';
  }

  @override
  String pressMomentBigLossHostile1(String opponent) {
    return 'Llegasteis tarde a todo contra $opponent. ¿Cómo dejaste que se pusiera tan mal?';
  }

  @override
  String pressMomentBigLossHostile2(String opponent) {
    return '$opponent marcó cuando quiso. ¿Dónde estaba el plan esta noche?';
  }

  @override
  String pressMomentCrisisWarm1(String opponent) {
    return 'Se escapa otro, esta vez contra $opponent. ¿Cómo le das la vuelta a esta racha?';
  }

  @override
  String pressMomentCrisisWarm2(String opponent) {
    return 'Los resultados no llegan y $opponent lo ha empeorado. ¿Sigues creyendo en este grupo?';
  }

  @override
  String pressMomentCrisisNeutral1(String opponent) {
    return 'Otra vez sin ganar, ahora contra $opponent, y la directiva está mirando. ¿Peligra tu puesto?';
  }

  @override
  String pressMomentCrisisNeutral2(String opponent) {
    return 'Después de $opponent, la racha se alarga. ¿Te preocupa tu futuro?';
  }

  @override
  String pressMomentCrisisHostile1(String opponent) {
    return 'Ahora también $opponent. A tu predecesor lo echaron con una racha así. ¿Por qué deberías sobrevivir tú?';
  }

  @override
  String pressMomentCrisisHostile2(String opponent) {
    return 'Tras otra noche como la de $opponent, todas las tertulias piden tu cabeza. ¿Dimitirías si te lo pidiera la directiva?';
  }

  @override
  String pressMomentJobVerdictWarm1(String opponent) {
    return 'Pusiste tu puesto en juego y, tras $opponent, no ha salido como querías. ¿Cómo lo llevas?';
  }

  @override
  String pressMomentJobVerdictWarm2(String opponent) {
    return 'Se acabaron los tres partidos, el último contra $opponent. La prueba te la pusiste tú. ¿Qué te parece el veredicto?';
  }

  @override
  String pressMomentJobVerdictNeutral1(String opponent) {
    return 'Nos dijiste que te juzgáramos por los tres siguientes. Tras $opponent, lo hemos hecho. ¿Sigue siendo tuyo el puesto?';
  }

  @override
  String pressMomentJobVerdictNeutral2(String opponent) {
    return 'Tres partidos, el último contra $opponent, y no lo que prometiste. ¿Has hablado con la directiva sobre tu futuro?';
  }

  @override
  String pressMomentJobVerdictHostile1(String opponent) {
    return 'Te pusiste la prueba tú mismo y la suspendiste contra $opponent. ¿Vas a dimitir?';
  }

  @override
  String pressMomentJobVerdictHostile2(String opponent) {
    return 'Palabras tuyas, no nuestras: juzgadme por los tres siguientes. Tras $opponent, ¿por qué sigues sentado ahí?';
  }

  @override
  String get pressBeatWhoToBlameWarm1 =>
      'Les pides más. ¿A alguien en concreto?';

  @override
  String get pressBeatWhoToBlameWarm2 =>
      'Has puesto el listón alto. ¿Quién tiene que dar un paso adelante primero?';

  @override
  String get pressBeatWhoToBlameNeutral1 =>
      'Dices que algunos tienen que mirarse a sí mismos. ¿A quién te refieres?';

  @override
  String get pressBeatWhoToBlameNeutral2 =>
      'No es suficiente, dices. ¿De quién hablas?';

  @override
  String get pressBeatWhoToBlameHostile1 =>
      'Te quedas en lo vago. ¿Vas a dar nombres o la culpa es tuya?';

  @override
  String get pressBeatWhoToBlameHostile2 =>
      'Cada semana la culpa es de otro. ¿De quién es esta vez?';

  @override
  String get pressBeatIfYouDontWarm1 =>
      'Palabras valientes. ¿Y si el próximo no sale como quieres?';

  @override
  String get pressBeatIfYouDontWarm2 =>
      'El país te lo va a recordar. ¿Y si no sale?';

  @override
  String get pressBeatIfYouDontNeutral1 =>
      '¿Y si no lo ganáis? ¿Qué pasa entonces?';

  @override
  String get pressBeatIfYouDontNeutral2 =>
      'Ya lo has dicho. ¿Qué pasa si te equivocas?';

  @override
  String get pressBeatIfYouDontHostile1 =>
      'En esta sala ya hemos oído promesas. ¿Qué les debes a los aficionados si esta también se rompe?';

  @override
  String get pressBeatIfYouDontHostile2 =>
      '¿Y cuando no ocurra, cuál será la excusa?';

  @override
  String get pressBeatFollowUpWarm1 =>
      'Una más, si te quedan fuerzas. ¿En qué tiene que seguir trabajando este grupo?';

  @override
  String get pressBeatFollowUpWarm2 =>
      'Cuando todo se calme, ¿qué te llevas de esta noche para el próximo partido?';

  @override
  String get pressBeatFollowUpNeutral1 =>
      'Vamos a profundizar un poco. ¿Qué tiene que mejorar antes del próximo partido?';

  @override
  String get pressBeatFollowUpNeutral2 =>
      'Más allá del marcador: ¿está esta plantilla donde quieres?';

  @override
  String get pressBeatFollowUpHostile1 =>
      'Muchas palabras y poco contenido. ¿Qué cambia realmente a partir de ahora?';

  @override
  String get pressBeatFollowUpHostile2 =>
      'La afición quiere una respuesta clara. ¿Es este equipo suficientemente bueno, sí o no?';

  @override
  String pressBeatStandoutWarm1(String player) {
    return '$player ha estado sensacional esta noche. ¿Hasta dónde puede llegar?';
  }

  @override
  String pressBeatStandoutWarm2(String player) {
    return '$player protagoniza todos los titulares esta noche. ¿Te lo esperabas?';
  }

  @override
  String pressBeatStandoutNeutral1(String player) {
    return '$player ha destacado. ¿Qué le pediste esta noche?';
  }

  @override
  String pressBeatStandoutNeutral2(String player) {
    return '¿Ha sido $player la diferencia esta noche?';
  }

  @override
  String pressBeatStandoutHostile1(String player) {
    return 'Sin $player, la historia sería otra. ¿Esto es un equipo o un solo jugador?';
  }

  @override
  String pressBeatStandoutHostile2(String player) {
    return '$player ha estado brillante. ¿Mérito tuyo o suyo?';
  }

  @override
  String pressBeatStrugglerWarm1(String player) {
    return '$player ha tenido una noche difícil. ¿Arrastra algún golpe?';
  }

  @override
  String pressBeatStrugglerWarm2(String player) {
    return 'No ha sido la noche de $player. ¿Vas a arroparle?';
  }

  @override
  String pressBeatStrugglerNeutral1(String player) {
    return '$player lo ha pasado mal esta noche. ¿Mantiene su puesto?';
  }

  @override
  String pressBeatStrugglerNeutral2(String player) {
    return '$player parecía fuera de ritmo. ¿Qué te pareció su partido?';
  }

  @override
  String pressBeatStrugglerHostile1(String player) {
    return '$player volvió a pasar desapercibido. ¿Por qué sigues convocándolo?';
  }

  @override
  String pressBeatStrugglerHostile2(String player) {
    return 'Todo el mundo vio que $player no estaba. ¿Todos menos el banquillo?';
  }

  @override
  String get pressThrowbackWinNextKeptWarm =>
      'Dijiste que ganaríais el siguiente y lo hicisteis. ¿Sienta bien tener razón?';

  @override
  String get pressThrowbackWinNextKeptNeutral =>
      'Prometiste una victoria en el siguiente partido y cumpliste. ¿Confianza o fanfarronería?';

  @override
  String get pressThrowbackWinNextKeptHostile =>
      'Dijiste que ganaríais el siguiente y lo hicisteis. ¿Suerte, o vamos a tener que empezar a escucharte?';

  @override
  String get pressThrowbackWinNextBrokenWarm =>
      'Nos dijiste que ganaríais ese partido. No fue así. ¿Qué falló?';

  @override
  String get pressThrowbackWinNextBrokenNeutral =>
      'Dijiste que ganaríais el siguiente. No fue así. ¿Por qué deberíamos creernos la próxima promesa?';

  @override
  String get pressThrowbackWinNextBrokenHostile =>
      'Dijiste que ganaríais el siguiente. No fue así. ¿Siguen valiendo algo tus palabras en esta sala?';

  @override
  String get pressThrowbackJobKeptWarm =>
      'Pediste que te juzgaran por tres partidos y aprobaste. ¿Te sientes reivindicado?';

  @override
  String get pressThrowbackJobKeptNeutral =>
      'Juzgadme por los tres siguientes, dijiste. Lo hicimos y llegaron los resultados. ¿Qué te enseñó esa prueba?';

  @override
  String get pressThrowbackJobKeptHostile =>
      'Te diste tres partidos y los superaste. ¿Era tan difícil la prueba?';

  @override
  String get pressThrowbackJobBrokenWarm =>
      'Pediste que te juzgaran por tres partidos. No salieron como querías. ¿Qué has aprendido?';

  @override
  String get pressThrowbackJobBrokenNeutral =>
      'Dijiste que te juzgáramos por los tres siguientes. Ya han pasado, y con ellos el beneficio de la duda. ¿Y ahora qué?';

  @override
  String get pressThrowbackJobBrokenHostile =>
      'Te pusiste la prueba y la suspendiste. ¿Por qué debería alguien fiarse ahora de tu palabra?';

  @override
  String pressThrowbackBackKeptWarm(String player) {
    return 'Apostaste por $player cuando otros no lo hacían. Respondió. ¿Parte del mérito es tuyo?';
  }

  @override
  String pressThrowbackBackKeptNeutral(String player) {
    return 'Apostaste por $player. Respondió. ¿Fe o conocimiento?';
  }

  @override
  String pressThrowbackBackKeptHostile(String player) {
    return 'Apostaste por $player y, por una vez, salió bien. ¿Estarás igual de seguro la próxima vez?';
  }

  @override
  String pressThrowbackBackBrokenWarm(String player) {
    return 'Respaldaste a $player y no ha salido bien. ¿Sigues creyendo en él?';
  }

  @override
  String pressThrowbackBackBrokenNeutral(String player) {
    return 'Apostaste por $player. No te lo ha devuelto. ¿Fue un error?';
  }

  @override
  String pressThrowbackBackBrokenHostile(String player) {
    return 'Tu criterio o tu lealtad: ¿cuál de los dos falló con $player?';
  }

  @override
  String pressThrowbackBlameKeptWarm(String player) {
    return 'Fuiste duro con $player y los partidos desde entonces te han dado la razón. ¿Te satisface?';
  }

  @override
  String pressThrowbackBlameKeptNeutral(String player) {
    return 'Señalaste a $player y no ha respondido. ¿Tiene camino de vuelta?';
  }

  @override
  String pressThrowbackBlameKeptHostile(String player) {
    return 'Dejaste a $player a los pies de los caballos y no se ha recuperado. ¿Lo has hundido?';
  }

  @override
  String pressThrowbackBlameBrokenWarm(String player) {
    return 'Señalaste a $player y te respondió en el campo. ¿Era esa la idea desde el principio?';
  }

  @override
  String pressThrowbackBlameBrokenNeutral(String player) {
    return 'Culpaste a $player y desde entonces ha sido de lo mejor del equipo. ¿Le debes una disculpa?';
  }

  @override
  String pressThrowbackBlameBrokenHostile(String player) {
    return 'Dejaste tirado a $player y desde entonces ha sido tu mejor jugador. ¿Vas a pedirle perdón?';
  }

  @override
  String get pressReplyCreditPlayers1 =>
      'Estos jugadores me lo han dado todo. No cambiaría a ninguno.';

  @override
  String get pressReplyCreditPlayers2 =>
      'Nadie trabaja más que este grupo. Los defenderé siempre.';

  @override
  String get pressReplyCreditPlayers3 =>
      'Desde esta silla no vais a oírme una palabra contra mis jugadores.';

  @override
  String get pressReplyCreditPlayers4 =>
      'El mérito es de los jugadores, no mío. Escribid sobre ellos.';

  @override
  String get pressReplyTakeResponsibility1 =>
      'Esto es culpa mía. Yo elegí el once y yo los planteé.';

  @override
  String get pressReplyTakeResponsibility2 =>
      'Juzgadme a mí, no a ellos. Es mi equipo y mi responsabilidad.';

  @override
  String get pressReplyTakeResponsibility3 =>
      'Si queréis un culpable, estoy sentado aquí mismo.';

  @override
  String get pressReplyTakeResponsibility4 =>
      'La responsabilidad es mía. Dejad a los jugadores al margen.';

  @override
  String get pressReplyDemandMore1 =>
      'Quiero más. Algunos saben perfectamente a qué me refiero.';

  @override
  String get pressReplyDemandMore2 =>
      'A este nivel, el esfuerzo no basta. Quiero más y se lo he dicho.';

  @override
  String get pressReplyDemandMore3 =>
      'Espero más de todos y cada uno de ellos, a partir de mañana.';

  @override
  String get pressReplyDemandMore4 =>
      'Algunos tienen que mirarse a sí mismos. No estoy satisfecho.';

  @override
  String get pressReplyPromiseWinNext1 =>
      'Ganaremos el siguiente. Podéis apuntarlo.';

  @override
  String get pressReplyPromiseWinNext2 =>
      'Recordad lo que digo: ganamos el próximo partido.';

  @override
  String get pressReplyPromiseWinNext3 =>
      'El próximo partido lo ganamos. Lo digo aquí para que me lo podáis echar en cara.';

  @override
  String get pressReplyPromiseWinNext4 =>
      'Confío en este equipo. Ganamos el próximo partido.';

  @override
  String get pressReplyJobOnTheLine1 =>
      'Juzgadme por los tres próximos partidos. Es justo.';

  @override
  String get pressReplyJobOnTheLine2 =>
      'Dadme tres partidos. Si para entonces no funciona, juzgadme por ello.';

  @override
  String get pressReplyJobOnTheLine3 =>
      'Los tres próximos demostrarán si soy la persona adecuada. Recordádmelo.';

  @override
  String get pressReplyJobOnTheLine4 =>
      'Tres partidos. Después escribid de mí lo que queráis.';

  @override
  String get pressReplyDeflect1 =>
      'Vamos partido a partido. Nada más que añadir.';

  @override
  String get pressReplyDeflect2 => 'Hoy no os voy a dar titulares.';

  @override
  String get pressReplyDeflect3 =>
      'El próximo partido. Es lo único en lo que pienso.';

  @override
  String get pressReplyDeflect4 => 'Lo que pienso se queda en el vestuario.';

  @override
  String get pressReplyTakeCredit1 => 'Lo dije porque lo creía, y tenía razón.';

  @override
  String get pressReplyTakeCredit2 => 'Lo leí bien. Para eso estoy aquí.';

  @override
  String get pressReplyTakeCredit3 => 'Llamadlo criterio. Sabía lo que decía.';

  @override
  String get pressReplyTakeCredit4 =>
      'Tomé la decisión y salió bien. Me lo apunto.';

  @override
  String get pressReplyStandByIt1 => 'Dije lo que creía. Lo mantengo.';

  @override
  String get pressReplyStandByIt2 => 'No retiro ni una palabra.';

  @override
  String get pressReplyStandByIt3 =>
      'La misma respuesta que entonces. Lo decía en serio y lo sigo diciendo.';

  @override
  String get pressReplyStandByIt4 => 'Mañana lo volvería a decir.';

  @override
  String get pressReplyAdmitMistake1 => 'Me equivoqué. Lo asumo.';

  @override
  String get pressReplyAdmitMistake2 =>
      'De acuerdo, lo calculé mal. Aprenderé de ello.';

  @override
  String get pressReplyAdmitMistake3 => 'Me equivoqué, y puedo decirlo.';

  @override
  String get pressReplyAdmitMistake4 => 'Esa decisión no funcionó, y fue mía.';

  @override
  String pressReplyBackPlayer1(String player) {
    return '$player tiene todo mi respaldo. Saldrá adelante.';
  }

  @override
  String pressReplyBackPlayer2(String player) {
    return 'Creo en $player, y os demostrará por qué.';
  }

  @override
  String pressReplyBackPlayer3(String player) {
    return 'No me vais a oír una palabra contra $player. Responderá.';
  }

  @override
  String pressReplyBackPlayer4(String player) {
    return '$player sigue en mis planes. Fijaos en lo que hace ahora.';
  }

  @override
  String pressReplyBlamePlayer1(String player) {
    return '$player nos ha fallado esta noche, y lo sabe.';
  }

  @override
  String pressReplyBlamePlayer2(String player) {
    return 'Esperaba mucho más de $player. Tiene que responder a eso.';
  }

  @override
  String pressReplyBlamePlayer3(String player) {
    return '$player no estuvo al nivel. Lo digo públicamente.';
  }

  @override
  String pressReplyBlamePlayer4(String player) {
    return 'Lo de $player no fue suficiente, y se lo voy a decir yo.';
  }

  @override
  String get pressOnRecordWinNext =>
      'Queda registrado: ganarás el próximo partido.';

  @override
  String get pressOnRecordJob =>
      'Queda registrado: que te juzguen por los tres próximos.';

  @override
  String pressOnRecordBack(String player) {
    return 'Queda registrado: respaldas a $player.';
  }

  @override
  String pressOnRecordBlame(String player) {
    return 'Queda registrado: $player te ha fallado.';
  }

  @override
  String yStatementKept0(String nation) {
    return 'Lo dijo y pasó. $nation tiene un seleccionador que cumple lo que dice.';
  }

  @override
  String yStatementKept1(String nation) {
    return 'Lo dijo en voz alta y luego lo hizo. Ese es el hombre que $nation necesitaba.';
  }

  @override
  String yStatementKept2(String nation) {
    return '$nation: lo anticipó y se cumplió. Nada que objetar.';
  }

  @override
  String yStatementKept3(String nation) {
    return 'Lo dijo públicamente y se cumplió. Un punto para él. $nation sigue adelante.';
  }

  @override
  String yStatementKept4(String nation) {
    return 'Ha acertado una. $nation, no os acostumbréis.';
  }

  @override
  String yStatementKept5(String nation) {
    return 'Hasta un reloj parado acierta dos veces al día. $nation ha tenido suerte esta vez.';
  }

  @override
  String yStatementBroken0(String nation) {
    return 'Lo dijo y no salió. Sigo con él. $nation lo vuelve a intentar.';
  }

  @override
  String yStatementBroken1(String nation) {
    return '$nation: prometió más de lo que nos dio, pero prefiero un seleccionador que confíe en sí mismo.';
  }

  @override
  String yStatementBroken2(String nation) {
    return '$nation: lo dijo públicamente y no pasó. La gente se acordará.';
  }

  @override
  String yStatementBroken3(String nation) {
    return 'Mucho bla bla y nada detrás. $nation: la próxima vez, menos palabras.';
  }

  @override
  String yStatementBroken4(String nation) {
    return 'Se plantó ahí y nos lo dijo. Y luego esto. $nation merece algo más que palabras.';
  }

  @override
  String yStatementBroken5(String nation) {
    return 'Su palabra ya no vale nada. Apúntalo, $nation.';
  }

  @override
  String get ncZoneNorth => 'Zona Norte';

  @override
  String get ncZoneWest => 'Zona Oeste';

  @override
  String get ncZoneEast => 'Zona Este';

  @override
  String get ncZoneCentralSouthern => 'Zona Centro y Sur';

  @override
  String careerNationsCupZoneWon(String zone) {
    return '$zone · Campeón';
  }

  @override
  String careerNationsCupZoneRunnerUp(String zone) {
    return '$zone · Subcampeón';
  }

  @override
  String careerNationsCupZoneSemi(String zone) {
    return '$zone · Semifinalista';
  }

  @override
  String careerNationsCupZoneRoundOf16(String zone) {
    return '$zone · Octavos de final';
  }

  @override
  String careerNationsCupZoneQuarter(String zone) {
    return '$zone · Cuartofinalista';
  }

  @override
  String careerNationsCupZonePlaced(String zone, int position) {
    return '$zone · $position.º';
  }

  @override
  String get objectiveNcFinalsEight => 'Llegar a cuartos de final';

  @override
  String get objectiveNcZoneWinGroup => 'Ganar tu grupo';

  @override
  String get finishNcFinalsEight => 'Cuartos de final';

  @override
  String get finishNcBottomHalf => 'Mitad baja del grupo';

  @override
  String get tourContTabZones => 'ZONAS';

  @override
  String get tourContTabFinalsEight => 'ELIMINATORIAS';

  @override
  String get tourContFinalsEightSoon =>
      'Las eliminatorias empiezan en noviembre con unos octavos de final: los 14 campeones de grupo y los 2 mejores segundos.';

  @override
  String get tourContQuarterFinals => 'CUARTOS DE FINAL';

  @override
  String get tourContZoneAdvancement =>
      'Todos los campeones de grupo pasan a octavos de final, junto con los 2 mejores segundos. Nadie desciende.';

  @override
  String tourContZoneHeadingYours(String zone) {
    return '$zone ★';
  }

  @override
  String get compNorthAmericaNationsCup =>
      'Copa de las Naciones de Norteamérica';

  @override
  String get compAfricanNationsCup => 'Copa de las Naciones';

  @override
  String get objectiveNcWinItNorthAmerica =>
      'Ganar la Copa de las Naciones de Norteamérica';

  @override
  String get objectiveNcWinItAfrica => 'Ganar la Copa de las Naciones';

  @override
  String get objectiveNcReachFinalNorthAmerica =>
      'Llegar a la final de la Copa de las Naciones de Norteamérica';

  @override
  String get objectiveNcReachFinalAfrica =>
      'Llegar a la final de la Copa de las Naciones';

  @override
  String get finishNcChampionsNorthAmerica =>
      'Campeón de la Copa de las Naciones de Norteamérica';

  @override
  String get finishNcChampionsAfrica => 'Campeón de la Copa de las Naciones';

  @override
  String pressAimQualWarm1(String competition) {
    return 'Clasificación: $competition. Todo el país cree en este equipo. ¿Cuál es tu objetivo?';
  }

  @override
  String pressAimQualWarm2(String competition) {
    return 'Nueva fase de clasificación, $competition, y el ánimo está por las nubes. ¿Hasta dónde puede llegar este equipo?';
  }

  @override
  String pressAimQualNeutral1(String competition) {
    return 'Arranca la clasificación, $competition. ¿Cuál es el objetivo de esta campaña?';
  }

  @override
  String pressAimQualNeutral2(String competition) {
    return 'Ya llega la clasificación, $competition. ¿Dónde ves a este equipo al final?';
  }

  @override
  String pressAimQualHostile1(String competition) {
    return 'Arranca la clasificación, $competition, y muchos dudan de que lo consigas. ¿Qué les dices?';
  }

  @override
  String pressAimQualHostile2(String competition) {
    return 'Otra fase de clasificación, $competition. ¿Por qué creer que esta vez será distinto?';
  }

  @override
  String pressAimFinalsWarm1(String competition) {
    return 'Ya está aquí: $competition. Todo el país está contigo. ¿Hasta dónde puedes llegar?';
  }

  @override
  String pressAimFinalsWarm2(String competition) {
    return 'Estás ahí: $competition. La afición sueña. ¿Cuál es el objetivo?';
  }

  @override
  String pressAimFinalsNeutral1(String competition) {
    return 'Esta semana arranca: $competition. ¿Qué sería un éxito?';
  }

  @override
  String pressAimFinalsNeutral2(String competition) {
    return 'Tu primer partido está cerca, $competition. Danos un objetivo.';
  }

  @override
  String pressAimFinalsHostile1(String competition) {
    return 'Ya está aquí: $competition, y nadie espera mucho. ¿Qué esperas de verdad?';
  }

  @override
  String pressAimFinalsHostile2(String competition) {
    return 'Estás ahí: $competition, pero las dudas siguen. ¿Cuál es tu objetivo?';
  }

  @override
  String pressBeatRivalWarm1(String rival) {
    return 'En tu grupo está $rival. ¿Te preocupa?';
  }

  @override
  String pressBeatRivalWarm2(String rival) {
    return 'El sorteo te puso delante a $rival. ¿Cómo ves ese partido?';
  }

  @override
  String pressBeatRivalNeutral1(String rival) {
    return '$rival parece el rival más fuerte del grupo. ¿Es el favorito?';
  }

  @override
  String pressBeatRivalNeutral2(String rival) {
    return '¿Qué te parece $rival?';
  }

  @override
  String pressBeatRivalHostile1(String rival) {
    return 'En tu grupo está $rival. Sé sincero, ¿puedes competir con ellos?';
  }

  @override
  String pressBeatRivalHostile2(String rival) {
    return 'Casi todos esperan que $rival os gane. ¿Se equivocan?';
  }

  @override
  String pressBeatKeyPlayerWarm1(String player) {
    return '$player está en gran forma. ¿Es su momento?';
  }

  @override
  String pressBeatKeyPlayerWarm2(String player) {
    return '$player sale en todos los titulares. ¿Puede llevar a este equipo?';
  }

  @override
  String pressBeatKeyPlayerNeutral1(String player) {
    return '¿Cuánto depende esta campaña de $player?';
  }

  @override
  String pressBeatKeyPlayerNeutral2(String player) {
    return '¿Está $player preparado para liderar a este equipo?';
  }

  @override
  String pressBeatKeyPlayerHostile1(String player) {
    return 'Si $player no está a su mejor nivel, ¿tiene algo más este equipo?';
  }

  @override
  String pressBeatKeyPlayerHostile2(String player) {
    return '$player lleva mucho peso encima. ¿Demasiado?';
  }

  @override
  String get pressReplyAimHigher1 =>
      'Llegaremos más lejos de lo que nadie espera.';

  @override
  String get pressReplyAimHigher2 =>
      'Quiero más de lo que pide la federación, y lo digo en voz alta.';

  @override
  String get pressReplyMatchBrief1 =>
      'Conocemos el objetivo y lo vamos a cumplir.';

  @override
  String get pressReplyMatchBrief2 =>
      'La federación marcó un objetivo. Lo cumpliremos.';

  @override
  String get pressReplyPlayDown1 => 'Vamos partido a partido.';

  @override
  String get pressReplyPlayDown2 =>
      'Nada de grandes promesas. Ya veremos dónde estamos.';

  @override
  String get pressReplyPromiseQualify1 =>
      'Nos vamos a clasificar. Podéis escribirlo.';

  @override
  String get pressReplyPromiseQualify2 =>
      'Este equipo estará en la fase final.';

  @override
  String get pressReplyFearNobody1 => 'No le tenemos miedo a nadie.';

  @override
  String get pressReplyFearNobody2 =>
      'Ellos también tienen que jugar contra nosotros.';

  @override
  String get pressReplyRespectRival1 => 'Son los favoritos y los respetamos.';

  @override
  String get pressReplyRespectRival2 =>
      'Un equipo muy bueno. Necesitaremos nuestra mejor versión.';

  @override
  String get pressReplyTeamFirst1 =>
      'Importa todo el equipo, no un solo jugador.';

  @override
  String get pressReplyTeamFirst2 => 'Nadie gana esto solo.';

  @override
  String pressOnRecordTarget(String aim) {
    return 'Queda registrado: $aim.';
  }

  @override
  String get pressOnRecordPlayDown => 'Queda registrado: sin promesas.';

  @override
  String get pressThrowbackTargetKeptWarm =>
      'Antes de la campaña marcaste un objetivo y lo cumpliste. ¿Es tu momento de mayor orgullo?';

  @override
  String get pressThrowbackTargetKeptNeutral =>
      'Dijiste lo que ibas a lograr y lo lograste. ¿Dudaste alguna vez?';

  @override
  String get pressThrowbackTargetKeptHostile =>
      'Cumpliste tu objetivo. ¿Suerte o era de verdad el plan?';

  @override
  String get pressThrowbackTargetBrokenWarm =>
      'Marcaste un objetivo y te quedaste corto. ¿Qué falló?';

  @override
  String get pressThrowbackTargetBrokenNeutral =>
      'Prometiste más de lo que dio el equipo. ¿Te arrepientes de haberlo dicho?';

  @override
  String get pressThrowbackTargetBrokenHostile =>
      'Hablaste a lo grande antes de la campaña y te quedaste corto. ¿Por qué creerte ahora?';

  @override
  String hubEventPressPreviewSub(String competition) {
    return 'La prensa quiere conocer tus objetivos: $competition';
  }

  @override
  String deptLevelCost(int level, String amount) {
    return 'Nivel $level · $amount';
  }

  @override
  String get formOnFire => 'En racha';

  @override
  String get formGood => 'En forma';

  @override
  String get formSteady => 'Regular';

  @override
  String get formPoor => 'Sin forma';

  @override
  String get formCold => 'Totalmente apagado';

  @override
  String get playerFormTitle => 'FORMA Y ESTADO FÍSICO';

  @override
  String playerFormAverage(String rating) {
    return 'Promedio de $rating en sus últimos partidos';
  }

  @override
  String get playerFormNoGames =>
      'No hay suficientes partidos recientes para juzgar';

  @override
  String playerFormNextMatch(String delta) {
    return '$delta a su valoración en el próximo partido';
  }

  @override
  String get playerFormNoEffect =>
      'Sin cambios en su valoración en el próximo partido';
}
