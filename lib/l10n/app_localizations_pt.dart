// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get matchPreviewTitle => 'PRÉVIA DA PARTIDA';

  @override
  String get matchKickOff => 'Começar o jogo';

  @override
  String get matchTactics => 'Tática';

  @override
  String get matchYourXi => 'SEU ONZE';

  @override
  String get matchHeadToHead => 'CONFRONTO DIRETO';

  @override
  String matchCouldNotLoad(String error) {
    return 'Não foi possível carregar a partida.\n$error';
  }

  @override
  String get matchNoUpcoming => 'Nenhuma partida a seguir.';

  @override
  String get matchUnknownNation => 'Desconhecida';

  @override
  String get matchH2hFirstMeeting => 'Primeiro encontro';

  @override
  String get matchH2hYouLead => 'Você lidera o confronto direto';

  @override
  String matchH2hOppEdge(String opponent) {
    return '$opponent leva vantagem';
  }

  @override
  String get matchH2hEven => 'Tudo igual';

  @override
  String matchH2hMet(int count) {
    return '$count encontros';
  }

  @override
  String get matchH2hWon => 'Vitórias';

  @override
  String get matchH2hDrawn => 'Empates';

  @override
  String get matchH2hLost => 'Derrotas';

  @override
  String get matchDossierTitle => 'Relatório de observação';

  @override
  String get matchDossierForm => 'FORMA';

  @override
  String get matchDossierNoGames => 'Sem jogos recentes';

  @override
  String get matchDossierKeyMen => 'JOGADORES-CHAVE';

  @override
  String get matchDossierHowTheyPlay => 'COMO JOGAM';

  @override
  String matchScoutFormation1(String formation) {
    return 'Costumam jogar num $formation.';
  }

  @override
  String matchScoutFormation2(String formation) {
    return 'O seu sistema habitual é o $formation.';
  }

  @override
  String matchScoutFormation3(String formation) {
    return 'Tendem a montar-se num $formation.';
  }

  @override
  String get matchScoutStrengthPressing => 'Pressionam alto e caçam a bola.';

  @override
  String get matchScoutStrengthDirect =>
      'Jogam de forma direta e põem a bola na frente cedo.';

  @override
  String get matchScoutStrengthPossession =>
      'Guardam bem a bola e constroem com paciência.';

  @override
  String get matchScoutStrengthCounter =>
      'Esperam atrás e saem rápido no contra-ataque.';

  @override
  String get matchScoutStrengthDeepDefence =>
      'Defendem baixo e são difíceis de desmontar.';

  @override
  String get matchScoutStrengthWide => 'Abrem o campo e atacam pelas alas.';

  @override
  String get matchScoutStrengthAttacking =>
      'Gostam de assumir a iniciativa e ir para cima do adversário.';

  @override
  String get matchScoutStrengthQuickForwards =>
      'Os avançados são rápidos e adoram atacar a profundidade.';

  @override
  String get matchScoutStrengthPassingMidfield =>
      'O meio-campo deles circula bem a bola.';

  @override
  String get matchScoutStrengthHardRunning =>
      'O meio-campo deles tem pernas para correr o jogo todo.';

  @override
  String get matchScoutStrengthSetPieces => 'São perigosos nas bolas paradas.';

  @override
  String get matchScoutStrengthQuickDefence =>
      'A defesa deles é rápida e difícil de bater nas costas.';

  @override
  String get matchScoutStrengthNone =>
      'Nada se destaca de verdade no jogo deles.';

  @override
  String get matchScoutWeakSpaceBehind =>
      'A linha alta deixa espaço nas costas para uma bola longa.';

  @override
  String get matchScoutWeakPressedBuildUp =>
      'Uma pressão alta pode desequilibrar a saída de bola lenta deles.';

  @override
  String get matchScoutWeakDeepBlock =>
      'Paciência: um bloco baixo como o deles pode ser desmontado.';

  @override
  String get matchScoutWeakLongBall =>
      'Recue a sua linha e as bolas longas deles não terão para onde ir.';

  @override
  String get matchScoutWeakSlowDefence =>
      'Os defesas deles são lentos, por isso lance jogadores nas costas deles.';

  @override
  String get matchScoutWeakAerial =>
      'Parecem inseguros a defender bolas paradas.';

  @override
  String get matchScoutWeakPoorPassing =>
      'O meio-campo deles tem dificuldade em sair da pressão com passes.';

  @override
  String get matchScoutWeakTiringMidfield =>
      'Ao meio-campo deles faltam pernas para manter a pressão.';

  @override
  String get matchScoutWeakBluntAttack =>
      'Aos avançados deles falta velocidade.';

  @override
  String get matchScoutApproachTakeTheGame =>
      'Contra você, espere que tomem a iniciativa.';

  @override
  String get matchScoutApproachEven =>
      'Contra você, espere um jogo equilibrado e disputado.';

  @override
  String get matchScoutApproachSitDeep =>
      'Contra você, espere que sejam cautelosos e procurem o contra-ataque.';

  @override
  String get matchScoutLeaningAttacking =>
      'De longe, parecem uma equipa ofensiva.';

  @override
  String get matchScoutLeaningCautious =>
      'De longe, parecem uma equipa cautelosa.';

  @override
  String get matchScoutLeaningUnclear =>
      'De longe, é difícil dizer como gostam de jogar.';

  @override
  String get matchScoutHireHint =>
      'Contrate um olheiro-chefe para saber como jogam.';

  @override
  String matchCouldNotContinue(String error) {
    return 'Não foi possível continuar: $error';
  }

  @override
  String get matchSkipToFullTime => 'Ir direto ao apito final';

  @override
  String get matchStatShots => 'Finalizações';

  @override
  String get matchStatGoals => 'Gols';

  @override
  String get matchStatYellowCards => 'Amarelos';

  @override
  String get matchStatRedCards => 'Vermelhos';

  @override
  String get matchMomentum => 'MOMENTUM';

  @override
  String get matchSwingAtk => 'ATQ';

  @override
  String get matchSwingDef => 'DEF';

  @override
  String ceremonyWorldCupYear(int year) {
    return 'CAMPEONATO MUNDIAL $year';
  }

  @override
  String get ceremonyFinalsAreHere => 'A FASE FINAL CHEGOU';

  @override
  String ceremonyHostedBy(String hosts) {
    return 'SEDE  $hosts';
  }

  @override
  String get ceremonyHostTbc => 'SEDE A CONFIRMAR';

  @override
  String get matchHalfTime => 'INTERVALO';

  @override
  String get matchContinue => 'Continuar';

  @override
  String get matchContinuing => 'Aguarde…';

  @override
  String matchTacticsWithSubs(int used, int max) {
    return 'Tática · $used/$max subst.';
  }

  @override
  String matchTiredCount(int count) {
    return 'CANSADOS ×$count';
  }

  @override
  String get matchTacticsLabel => 'TÁTICA';

  @override
  String get teamOverallOverTime => 'VALOR GLOBAL AO LONGO DO TEMPO';

  @override
  String get teamOverall => 'Valor global';

  @override
  String get teamTalkHeading => 'PALAVRAS AO ELENCO';

  @override
  String get teamTalkPrompt => 'Defina o tom para o segundo tempo.';

  @override
  String get teamTalkCalmLabel => 'Cabeças frias';

  @override
  String get teamTalkCalmBlurb => 'Acalme o grupo. Um pequeno reforço geral.';

  @override
  String get teamTalkEncourageLabel => 'Incentivar';

  @override
  String get teamTalkEncourageBlurb => 'Avance e vá buscar o jogo.';

  @override
  String get teamTalkDemandMoreLabel => 'Exigir mais';

  @override
  String get teamTalkDemandMoreBlurb => 'Jogue tudo nisso. Ataque com força.';

  @override
  String get teamTalkPraiseLabel => 'Segurar firme';

  @override
  String get teamTalkPraiseBlurb => 'Fique compacto e proteja o que tem.';

  @override
  String get teamTalkBelieveLabel => 'Acreditar';

  @override
  String get teamTalkBelieveBlurb =>
      'Confiem em vocês. Um impulso nos dois lados do campo.';

  @override
  String get teamTalkFocusLabel => 'Atenção total';

  @override
  String get teamTalkFocusBlurb => 'Concentração total. Feche o jogo.';

  @override
  String get teamTalkUrgencyLabel => 'Senso de urgência';

  @override
  String get teamTalkUrgencyBlurb =>
      'Corra atrás agora. Tudo ou nada, e deixa espaços.';

  @override
  String get teamTalkReassureLabel => 'Sem pressão';

  @override
  String get teamTalkReassureBlurb =>
      'Acalme os nervos e mantenha a organização.';

  @override
  String get commonRetry => 'Tentar de novo';

  @override
  String get commonSomethingWentWrong => 'Algo deu errado';

  @override
  String get commonCrashBox =>
      'Algo deu errado aqui.\nConfigurações → Diagnóstico tem os detalhes.';

  @override
  String hubCouldNotAdvance(String error) {
    return 'Não foi possível avançar o mundo: $error';
  }

  @override
  String get settingsDiagnosticsTitle => 'Diagnóstico';

  @override
  String get settingsDiagnosticsBlurb =>
      'Erros registrados neste dispositivo. Nada é enviado para lugar nenhum.';

  @override
  String get settingsContactTitle => 'Contato';

  @override
  String get settingsContactCopied => 'Endereço copiado.';

  @override
  String get settingsCommunityTitle => 'Comunidade';

  @override
  String get settingsDiscordSubtitle => 'Junte-se à comunidade';

  @override
  String get settingsLinkCopied => 'Link copiado.';

  @override
  String get diagnosticsEmpty => 'Nenhum erro registrado. É essa a ideia.';

  @override
  String get diagnosticsCopy => 'Copiar';

  @override
  String get diagnosticsCopied =>
      'Registro copiado para a área de transferência.';

  @override
  String get diagnosticsClear => 'Limpar';

  @override
  String get navHub => 'Início';

  @override
  String get navSquad => 'Elenco';

  @override
  String get navStandings => 'Classificação';

  @override
  String get navCareers => 'Minha carreira';

  @override
  String get settingsTitle => 'CONFIGURAÇÕES';

  @override
  String get settingsSoundHapticsTitle => 'Som e vibração';

  @override
  String get settingsSoundHapticsBlurb =>
      'Vibração e um som curto nos gols, no início e no fim do jogo.';

  @override
  String get settingsLanguageTitle => 'Idioma';

  @override
  String get settingsLanguageBlurb =>
      'Escolha o idioma do app ou siga o do aparelho.';

  @override
  String get settingsLanguageSystem => 'Sistema';

  @override
  String get settingsTextSizeTitle => 'Tamanho do texto';

  @override
  String get settingsTextSizeBlurb => 'Aumente o texto se for difícil de ler.';

  @override
  String get settingsTextSizeNormal => 'Normal';

  @override
  String get settingsTextSizeLarge => 'Grande';

  @override
  String get settingsTextSizeLarger => 'Maior';

  @override
  String get matchPreviewAllMeetings => 'Todos os encontros';

  @override
  String get recordsMeetings => 'ENCONTROS';

  @override
  String get recordsLegends => 'LENDAS';

  @override
  String get recordsAllTimeXi => 'ONZE DE TODOS OS TEMPOS';

  @override
  String get recordsHallOfFame => 'GALERIA DA FAMA';

  @override
  String get recordsAllTimeWorld => 'RECORDES MUNDIAIS';

  @override
  String get recordsAllTimeTopScorers =>
      'MAIORES ARTILHEIROS DE TODOS OS TEMPOS';

  @override
  String get recordsMostCapped => 'MAIS JOGOS PELA SELEÇÃO';

  @override
  String get recordsMostWcStarts => 'MAIS TITULARIDADES NO CM';

  @override
  String get recordsMostTournaments => 'MAIS TORNEIOS DISPUTADOS';

  @override
  String get recordsRecordBook => 'LIVRO DE RECORDES';

  @override
  String get recordsHeadToHead => 'CONFRONTO DIRETO';

  @override
  String get recordsFiercestRival => 'MAIOR RIVAL';

  @override
  String get recordsMostCaps => 'MAIS JOGOS PELA SELEÇÃO';

  @override
  String get recordsTopScorers => 'ARTILHEIROS';

  @override
  String get recordsMostAssists => 'MAIS ASSISTÊNCIAS';

  @override
  String get recordsYourRecord => 'SEU HISTÓRICO';

  @override
  String get callUpHome => 'CASA';

  @override
  String get callUpAway => 'FORA';

  @override
  String get recordsHome => 'CASA';

  @override
  String get recordsAway => 'FORA';

  @override
  String get recordsActive => 'ATIVO';

  @override
  String get recordsStillActive => 'Ainda em atividade';

  @override
  String get recordsAvg => 'méd.';

  @override
  String get recordsSelect => 'Selecionar';

  @override
  String get recordsVs => 'x';

  @override
  String get recordsDraws => 'Empates';

  @override
  String get recordsGoalsLabel => 'Gols';

  @override
  String get recordsBestFinish => 'Melhor campanha';

  @override
  String get recordsNoFinalsYet => 'Ainda sem fase final';

  @override
  String get recordsLongestUnbeaten => 'Maior invencibilidade';

  @override
  String get recordsBiggestWin => 'Maior vitória';

  @override
  String get recordsSeeAllMeetings => 'Ver todos os encontros';

  @override
  String get recordsSaveNotFound => 'Gravação não encontrada.';

  @override
  String get recordsNoMatches => 'Nenhum resultado.';

  @override
  String get recordsSearchPlayerOrNation => 'Procurar jogador ou seleção';

  @override
  String get recordsSearchNation => 'Procurar seleção';

  @override
  String get recordsPickTwoDifferent => 'Escolha duas seleções diferentes.';

  @override
  String get recordsPlayToBuildRecord =>
      'Dispute algumas partidas e seu histórico contra cada adversário aparecerá aqui.';

  @override
  String get recordsTapOpponent =>
      'Toque em um adversário para ver o detalhamento.';

  @override
  String get recordsEdgeUpperHand => 'Você leva a melhor';

  @override
  String get recordsEdgeTheirNumber => 'Eles levam a melhor';

  @override
  String get recordsEdgeEven => 'Tudo igual';

  @override
  String get recordsAllTimeWorldSubtitle =>
      'Artilheiros e recordistas de jogos, de todas as seleções';

  @override
  String get recordsHeadToHeadSubtitle =>
      'Compare o histórico de duas seleções';

  @override
  String get recordsLegendsSubtitle =>
      'Onze de todos os tempos e galeria da fama';

  @override
  String get recordsUnitGoals => 'gols';

  @override
  String get recordsUnitCaps => 'jogos';

  @override
  String get recordsUnitStarts => 'titularidades';

  @override
  String get recordsUnitCups => 'torneios';

  @override
  String get recordsUnitAssists => 'assistências';

  @override
  String recordsCapsCount(int count) {
    return '$count jogos pela seleção';
  }

  @override
  String recordsGoalsCount(int count) {
    return '$count gols';
  }

  @override
  String recordsAssistsCount(int count) {
    return '$count assistências';
  }

  @override
  String recordsMotmCount(int count) {
    return '$count MEC';
  }

  @override
  String recordsMatchesCount(int count) {
    return '$count jogos';
  }

  @override
  String recordsMeetingsCount(int count) {
    return '$count encontros';
  }

  @override
  String recordsCodeWins(String code) {
    return 'Vitórias $code';
  }

  @override
  String recordsMeetingsWdl(int meetings, int wins, int draws, int losses) {
    return '$meetings encontros · ${wins}V ${draws}E ${losses}D';
  }

  @override
  String recordsWdl(int wins, int draws, int losses) {
    return '${wins}V ${draws}E ${losses}D';
  }

  @override
  String recordsRivalLine(int meetings, String record, String edge) {
    return '$meetings encontros · $record · $edge';
  }

  @override
  String recordsNeverMet(String a, String b) {
    return '$a e $b nunca se enfrentaram nesta gravação.';
  }

  @override
  String tacticsSentOffNote(String names) {
    return 'Expulsão de $names. Sem substituto, você joga com um a menos.';
  }

  @override
  String tacticsNeedFitPlayers(int required, int have) {
    return 'Precisa de $required disponíveis ($have aptos)';
  }

  @override
  String tacticsMissesOfCamp(int missed, int total) {
    return 'Perde $missed/$total';
  }

  @override
  String get tacticsOutForWholeCamp => 'Fora durante toda esta convocatória';

  @override
  String get rankingCentreOnMe => 'Centrar na minha seleção';

  @override
  String get recordsAfterExtraTime => 'pror.';

  @override
  String recordsOnPenalties(int a, int b) {
    return '$a–$b nos pênaltis';
  }

  @override
  String recordsVersus(String a, String b) {
    return '$a x $b';
  }

  @override
  String recordsPlayedScore(int played, int gf, int ga) {
    return '$played jogos · $gf–$ga';
  }

  @override
  String recordsBiggestWinValue(int gf, int ga, String opp) {
    return '$gf–$ga contra $opp';
  }

  @override
  String recordsCouldNotLoad(String error) {
    return 'Não foi possível carregar.\n$error';
  }

  @override
  String recordsCouldNotLoadLegends(String error) {
    return 'Não foi possível carregar as lendas.\n$error';
  }

  @override
  String recordsCouldNotLoadRecords(String error) {
    return 'Não foi possível carregar os recordes.\n$error';
  }

  @override
  String recordsCouldNotLoadNations(String error) {
    return 'Não foi possível carregar as seleções.\n$error';
  }

  @override
  String recordsCouldNotLoadYourRecord(String error) {
    return 'Não foi possível carregar seu histórico.\n$error';
  }

  @override
  String recordsCouldNotLoadRecord(String error) {
    return 'Não foi possível carregar o histórico.\n$error';
  }

  @override
  String recordsNoLegends(String nation) {
    return 'Ainda sem lendas para $nation. Dispute algumas campanhas e os grandes nomes vão surgir aqui.';
  }

  @override
  String recordsGreatestSide(String nation) {
    return 'O melhor onze que $nation poderia escalar.';
  }

  @override
  String get recordsNoWorldHistory =>
      'O mundo ainda não tem história. Dispute algumas campanhas e os grandes nomes de todos os tempos aparecerão aqui.';

  @override
  String recordsPlayToWriteHistory(String nation) {
    return 'Dispute algumas partidas para começar a escrever a história desta seleção ($nation).';
  }

  @override
  String get tacticsLineGk => 'GL';

  @override
  String get tacticsLineDef => 'ZAG';

  @override
  String get tacticsLineMid => 'MEI';

  @override
  String get tacticsLineFwd => 'ATA';

  @override
  String get tacticsGoalkeepers => 'GOLEIROS';

  @override
  String get tacticsDefenders => 'ZAGUEIROS';

  @override
  String get tacticsMidfielders => 'MEIO-CAMPISTAS';

  @override
  String get tacticsForwards => 'ATACANTES';

  @override
  String get tacticsCallUpsTitle => 'CONVOCATÓRIA';

  @override
  String tacticsPickAtLeastPlayers(int min) {
    return 'Escolha pelo menos $min jogadores.';
  }

  @override
  String tacticsCouldNotLoadSquad(String error) {
    return 'Não foi possível carregar o elenco.\n$error';
  }

  @override
  String get tacticsNoSquad => 'Sem elenco.';

  @override
  String tacticsSquadCount(int count, int max) {
    return 'ELENCO · $count/$max';
  }

  @override
  String tacticsMinMax(int min, int max) {
    return 'Mín. $min · Máx. $max';
  }

  @override
  String get tacticsBestQuality => 'Melhor qualidade';

  @override
  String get tacticsPreviousSquad => 'Elenco anterior';

  @override
  String get tacticsSquadLockedBack => 'Voltar (elenco fechado)';

  @override
  String get tacticsConfirmSquad => 'Confirmar elenco';

  @override
  String tacticsSquadFullMax(int max) {
    return 'Elenco completo (máx. $max)';
  }

  @override
  String get tacticsSquadLocked => 'ELENCO FECHADO';

  @override
  String get tacticsNominationOpen => 'CONVOCATÓRIA ABERTA. ESCOLHA SEU ELENCO';

  @override
  String get tacticsSquadFixedBlurb =>
      'Este elenco está fixo para as partidas abaixo. Escolha de novo antes da próxima convocatória.';

  @override
  String get tacticsSquadWillPlayBlurb =>
      'Este elenco vai disputar as partidas abaixo.';

  @override
  String get tacticsUnknown => 'Desconhecida';

  @override
  String tacticsAgeValue(int age, String value) {
    return 'Idade $age · $value';
  }

  @override
  String get tacticsFatigueExhausted => 'Exausto';

  @override
  String get tacticsFatigueTired => 'Cansado';

  @override
  String get tacticsFatigueMatchLegs => 'Pernas pesadas';

  @override
  String tacticsTooManySubs(int max) {
    return 'Substituições demais (máx. $max).';
  }

  @override
  String tacticsMinuteTitle(int minute) {
    return 'TÁTICA · $minute\'';
  }

  @override
  String get tacticsApply => 'APLICAR';

  @override
  String get tacticsTabLineupSubs => 'ESCALAÇÃO E SUBST.';

  @override
  String get tacticsTabTactics => 'TÁTICA';

  @override
  String get squadLineKeepers => 'GOLEIROS';

  @override
  String get squadLineDefenders => 'DEFESA';

  @override
  String get squadLineMidfielders => 'MEIO-CAMPO';

  @override
  String get squadLineForwards => 'ATAQUE';

  @override
  String get squadStatXiRating => 'Valor do onze';

  @override
  String get squadStatAvgAge => 'Idade média';

  @override
  String get squadStatSize => 'Elenco';

  @override
  String get squadStatUnavailable => 'Fora';

  @override
  String get squadDepthTitle => 'PROFUNDIDADE POR SETOR';

  @override
  String squadAgeShort(int age) {
    return '$age anos';
  }

  @override
  String get tacticsTabOtherPositions => 'OUTRAS POSIÇÕES';

  @override
  String get tacticsOutOfPositionNote => 'Fora de posição aqui';

  @override
  String get tacticsNobodyElse => 'Mais ninguém para tentar aqui.';

  @override
  String get tacticsPickSomebodyFirst =>
      'Escolha quem sai e o resto do banco aparece aqui, com a nota que cada um teria nesta posição.';

  @override
  String get tacticsTabSuitable => 'ADEQUADOS';

  @override
  String get tacticsTabOnPitch => 'EM CAMPO';

  @override
  String tacticsSectionSuitable(int count) {
    return 'ADEQUADOS · $count';
  }

  @override
  String get tacticsNobodySuits =>
      'Ninguém no banco é naturalmente adequado a esta posição, então aqui está todo mundo.';

  @override
  String tacticsSectionOnPitch(int count, int max) {
    return 'EM CAMPO · $count/$max';
  }

  @override
  String tacticsSectionAvailable(int count) {
    return 'DISPONÍVEIS · $count';
  }

  @override
  String get tacticsRowStarted => 'Titular';

  @override
  String tacticsRowCameOn(int minute) {
    return 'Entrou aos $minute\'';
  }

  @override
  String get tacticsRowSubstitute => 'Entrou';

  @override
  String get tacticsEnergyLabel => 'ENERGIA';

  @override
  String tacticsPickReplacementFor(String name) {
    return 'Toque em um substituto para $name, ou toque nele de novo para cancelar.';
  }

  @override
  String get tacticsSlotLostToRedCard =>
      'Um cartão vermelho custou esta posição. Arraste um companheiro para cá para mover a lacuna.';

  @override
  String get tacticsSentOffShort => 'EXPULSO';

  @override
  String get tacticsFullBackLeft => 'Lateral esquerdo';

  @override
  String get tacticsFullBackRight => 'Lateral direito';

  @override
  String get tacticsFullBackUp => 'Apoiar o ataque';

  @override
  String get tacticsFullBackDown => 'Ficar atrás';

  @override
  String get tacticsFullBackOff => 'Sem instrução';

  @override
  String tacticsFullBackUpHint(String side) {
    return '$side: apoiar o ataque. Um pouco mais de ataque, um pouco mais de risco.';
  }

  @override
  String tacticsFullBackDownHint(String side) {
    return '$side: ficar atrás. Um pouco mais seguro, um pouco menos de ataque.';
  }

  @override
  String tacticsFullBackOffHint(String side) {
    return '$side: sem instrução, segue o plano da equipa.';
  }

  @override
  String tacticsFullBackSemantics(String side, String state) {
    return '$side, seta: $state';
  }

  @override
  String tacticsSubsUsed(int used, int max) {
    return 'SUBST. · $used/$max';
  }

  @override
  String get tacticsDragSubOn =>
      'Toque em um jogador em campo para tirá-lo, ou segure e arraste um reserva sobre ele.';

  @override
  String get tacticsNoSubs => 'Sem reservas disponíveis.';

  @override
  String get tacticsChooseShape => 'ESCOLHA UM SISTEMA';

  @override
  String get tacticsFormation => 'FORMAÇÃO';

  @override
  String get tacticsInstructions => 'INSTRUÇÕES';

  @override
  String get tacticsDrilling => 'ENTROSAMENTO';

  @override
  String get tacticsDrillingUnplayed => 'NÃO JOGADO';

  @override
  String get tacticsDrillingNew => 'NOVO';

  @override
  String get tacticsDrillingSettling => 'EM AJUSTE';

  @override
  String get tacticsDrillingDrilled => 'DOMINADO';

  @override
  String get tacticsInstrMentality => 'Mentalidade';

  @override
  String get tacticsInstrDefensive => 'Defensiva';

  @override
  String get tacticsInstrAttacking => 'Ofensiva';

  @override
  String get tacticsInstrPressing => 'Pressão';

  @override
  String get tacticsInstrLowBlock => 'Bloco baixo';

  @override
  String get tacticsInstrHighPress => 'Pressão alta';

  @override
  String get tacticsInstrTempo => 'Ritmo';

  @override
  String get tacticsInstrPatient => 'Paciente';

  @override
  String get tacticsInstrFast => 'Rápido';

  @override
  String get tacticsInstrWidth => 'Amplitude';

  @override
  String get tacticsInstrNarrow => 'Estreito';

  @override
  String get tacticsInstrWide => 'Largo';

  @override
  String get tacticsInstrDefLine => 'Linha def.';

  @override
  String get tacticsInstrDefensiveLine => 'Linha defensiva';

  @override
  String get tacticsInstrDeep => 'Recuada';

  @override
  String get tacticsInstrHigh => 'Alta';

  @override
  String get tacticsInstrDirectness => 'Objetividade';

  @override
  String get tacticsInstrPossession => 'Posse';

  @override
  String get tacticsInstrDirect => 'Direto';

  @override
  String get tacticsPickGoalkeeper => 'ESCOLHER GOLEIRO';

  @override
  String get tacticsPickLeftBack => 'ESCOLHER LATERAL ESQUERDO';

  @override
  String get tacticsPickCentreBack => 'ESCOLHER ZAGUEIRO';

  @override
  String get tacticsPickRightBack => 'ESCOLHER LATERAL DIREITO';

  @override
  String get tacticsPickDefensiveMid => 'ESCOLHER MEIO-CAMPISTA DEFENSIVO';

  @override
  String get tacticsPickCentralMid => 'ESCOLHER MEIO-CAMPISTA CENTRAL';

  @override
  String get tacticsPickAttackingMid => 'ESCOLHER MEIO-CAMPISTA OFENSIVO';

  @override
  String get tacticsPickLeftMid => 'ESCOLHER MEIO-CAMPISTA ESQUERDO';

  @override
  String get tacticsPickRightMid => 'ESCOLHER MEIO-CAMPISTA DIREITO';

  @override
  String get tacticsPickLeftWing => 'ESCOLHER EXTREMO ESQUERDO';

  @override
  String get tacticsPickRightWing => 'ESCOLHER EXTREMO DIREITO';

  @override
  String get tacticsPickStriker => 'ESCOLHER ATACANTE';

  @override
  String tacticsRoleOutOfPosition(String role) {
    return '$role · fora de posição';
  }

  @override
  String tacticsAgeOnly(int age) {
    return 'Idade $age';
  }

  @override
  String tacticsRoleAge(String role, int age) {
    return '$role · Idade $age';
  }

  @override
  String get tacticsOn => 'CAMPO';

  @override
  String get tacticsSquad => 'ELENCO';

  @override
  String get tacticsTabLineup => 'ESCALAÇÃO';

  @override
  String get tacticsTabInstructions => 'INSTRUÇÕES';

  @override
  String get tacticsTabRoles => 'FUNÇÕES';

  @override
  String get tacticsTabSetPieces => 'BOLAS PARADAS';

  @override
  String get tacticsTabRolesSetPieces => 'FUNÇÕES E BOLAS PARADAS';

  @override
  String get tacticsRolesSetPiecesBlurb =>
      'Dê uma função a cada titular. Toque no emblema de pênalti (⚽) ou de falta (▲) para definir o cobrador.';

  @override
  String get tacticsTooltipCallUps => 'Convocatória';

  @override
  String get tacticsTooltipPresets => 'Esquemas táticos';

  @override
  String get tacticsTooltipInstructions => 'Instruções';

  @override
  String get tacticsNoTacticSet => 'Nenhuma tática definida.';

  @override
  String tacticsReplaceStarters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'SUBSTITUA $count TITULARES',
      one: 'SUBSTITUA $count TITULAR',
    );
    return '$_temp0';
  }

  @override
  String tacticsPlayerOut(String name, String reason) {
    return '$name: $reason';
  }

  @override
  String get tacticsOut => 'Fora';

  @override
  String get tacticsTapSpotReplace =>
      'Toque na posição dele em campo para escolher um substituto.';

  @override
  String get tacticsTapOrDrag =>
      'Toque em um jogador para trocá-lo, ou segure e arraste para movê-lo.';

  @override
  String get tacticsPlayerRoles => 'FUNÇÕES DOS JOGADORES';

  @override
  String get tacticsRolesBlurb =>
      'Dê uma missão ao jogador: um oportunista, um armador, um pivô. Define quem marca e quem cria.';

  @override
  String get tacticsSetPieceTakers => 'COBRADORES DE BOLAS PARADAS';

  @override
  String get tacticsSetPieceBlurb =>
      'Quem cobra pênaltis e bolas paradas, ou deixe com o jogador mais indicado.';

  @override
  String get tacticsTakerAuto => 'Automático';

  @override
  String get tacticsTakerQuickPick => 'Usar os melhores cobradores';

  @override
  String get tacticsPenalties => 'Pênaltis';

  @override
  String get tacticsCornersFreeKicks => 'Escanteios e faltas';

  @override
  String get tacticsSkillFin => 'FIN';

  @override
  String get tacticsSkillPas => 'PAS';

  @override
  String tacticsRolePlayer(String name) {
    return 'FUNÇÃO · $name';
  }

  @override
  String get tacticsPenaltyTaker => 'COBRADOR DE PÊNALTI';

  @override
  String get tacticsCornerFreeKickTaker => 'COBRADOR DE ESCANTEIOS E FALTAS';

  @override
  String get tacticsAutomatic => 'Automático';

  @override
  String get tacticsLetBestSuited => 'Deixe o jogador mais indicado cobrar.';

  @override
  String get tacticsInXi => 'NO ONZE';

  @override
  String get tacticsTeamInstructions => 'INSTRUÇÕES TÁTICAS';

  @override
  String get tacticsTeamInstructionsBlurb =>
      'Defina como sua seleção joga. Cada ajuste influencia o grupo todo.';

  @override
  String tacticsSavedPreset(String name) {
    return '“$name” salvo';
  }

  @override
  String tacticsAppliedPreset(String name) {
    return '“$name” aplicado';
  }

  @override
  String get tacticsTacticPresets => 'ESQUEMAS SALVOS';

  @override
  String get tacticsPresetsBlurb =>
      'Salve este sistema como um estilo reutilizável ou aplique um que você salvou antes.';

  @override
  String get tacticsSaveCurrentTactic => 'Salvar tática atual';

  @override
  String tacticsCouldNotLoadPresets(String error) {
    return 'Não foi possível carregar os esquemas.\n$error';
  }

  @override
  String get tacticsNoPresetsYet =>
      'Nenhum esquema ainda. Toque em “Salvar tática atual” para guardar esta configuração como estilo reutilizável.';

  @override
  String get tacticsNameThisTactic => 'Dê um nome à tática';

  @override
  String get tacticsNameHint => 'ex.: Pressão alta 4-3-3';

  @override
  String get tacticsCancel => 'Cancelar';

  @override
  String get tacticsSave => 'Salvar';

  @override
  String get tacticsTapToAssign => 'Toque para atribuir';

  @override
  String get tacticsHoldDragSub =>
      'Segure um reserva e arraste-o sobre um jogador para colocá-lo em campo.';

  @override
  String get hubContinue => 'Continuar';

  @override
  String get hubBrackets => 'Quadros';

  @override
  String hubCouldNotLoad(String error) {
    return 'Não foi possível carregar.\n$error';
  }

  @override
  String hubCouldNotLoadFinances(String error) {
    return 'Não foi possível carregar as finanças.\n$error';
  }

  @override
  String hubCouldNotLoadSave(String error) {
    return 'Não foi possível carregar a gravação.\n$error';
  }

  @override
  String get hubSaveNotFound => 'Gravação não encontrada.';

  @override
  String get hubUnknown => 'Desconhecido';

  @override
  String hubWorldChampionsYear(int year) {
    return 'CAMPEÃO MUNDIAL $year';
  }

  @override
  String get hubCycleComplete => 'O ciclo terminou.';

  @override
  String get hubYourJob => 'SEU CARGO';

  @override
  String get hubStayProject => 'Ficar e continuar seu projeto';

  @override
  String get hubChooseNextJob => 'ESCOLHA SEU PRÓXIMO CARGO';

  @override
  String get hubOffersOnTable => 'PROPOSTAS NA MESA';

  @override
  String hubOfferSubtitle(String tier, int position) {
    return '$tier · #$position no mundo';
  }

  @override
  String hubContinueWith(String nation) {
    return 'Continuar com $nation';
  }

  @override
  String get hubYourNation => 'sua seleção';

  @override
  String get hubTakeTheJob => 'Aceitar o cargo';

  @override
  String get hubFederationFinances => 'FINANÇAS DA FEDERAÇÃO';

  @override
  String get hubBudgetIntro =>
      'Sua primeira tarefa no próximo ciclo é definir o orçamento da federação e dividi-lo entre os departamentos.';

  @override
  String get hubStarting => 'Um instante…';

  @override
  String get hubBeginNextCycle => 'Começar o próximo ciclo';

  @override
  String get hubContinueCareer => 'Continuar sua carreira';

  @override
  String get hubBackToSaves => 'Voltar às suas gravações';

  @override
  String get hubOpeningBalance => 'Saldo inicial';

  @override
  String get hubCentralFunding => 'Financiamento central';

  @override
  String get hubPrizeMoney => 'Prêmios em dinheiro';

  @override
  String get hubCommercialReturn => 'Retorno comercial';

  @override
  String get hubAvailableToInvest => 'Disponível para investir';

  @override
  String hubReputation(String label, int rep) {
    return 'Reputação: $label ($rep)';
  }

  @override
  String get hubNationalHero => 'Herói nacional';

  @override
  String get hubFinal => 'Final';

  @override
  String get hubStageRoundOf32 => 'Dezesseis-avos de final';

  @override
  String get hubStageThirdPlace => 'Jogo do terceiro lugar';

  @override
  String get hubEventAdvanceWorld => 'Avançar o mundo';

  @override
  String hubEventStartCycle(int year) {
    return 'Iniciar o ciclo $year';
  }

  @override
  String hubEventWorldChampions(String nation) {
    return 'Campeã mundial: $nation';
  }

  @override
  String get hubEventSetBudget => 'Definir o orçamento da federação';

  @override
  String get hubEventSetBudgetSub =>
      'Distribua os recursos deste ciclo antes de a temporada começar';

  @override
  String get hubEventNaturalization => 'Analisar proposta de naturalização';

  @override
  String get hubEventNaturalizationSub =>
      'Um jogador estrangeiro quer mudar de seleção para a sua';

  @override
  String get hubEventCampaignVerdict => 'Campanha encerrada: veja o veredito';

  @override
  String get hubEventCampaignComplete => 'Campanha concluída';

  @override
  String get hubEventIntercontinentalPlayoff => 'O play-off intercontinental';

  @override
  String get hubEventWatchWcDraw => 'Assistir ao sorteio do Campeonato Mundial';

  @override
  String get hubEventWorldCupHere => 'O Campeonato Mundial chegou';

  @override
  String get hubEventWatchFinalsDraw => 'Assistir ao sorteio da fase final';

  @override
  String get hubEventFinalsHere => 'A fase final chegou';

  @override
  String get hubEventPlayWcRound =>
      'Jogar a próxima rodada do Campeonato Mundial';

  @override
  String hubEventPlayCupMatch(String cup) {
    return 'Jogar a próxima partida: $cup';
  }

  @override
  String get hubEventPlayNationsCupMatch =>
      'Jogar a próxima partida da Copa das Nações';

  @override
  String get hubEventWatchNationsCupDraw =>
      'Assistir ao sorteio da Copa das Nações';

  @override
  String get hubEventWatchHostSelection => 'Assistir à escolha do anfitrião';

  @override
  String get hubEventWatchQualifyingDraw =>
      'Assistir ao sorteio das eliminatórias';

  @override
  String get hubEventWatchWcHostSelection =>
      'Assistir à escolha do anfitrião do Campeonato Mundial';

  @override
  String get hubEventWatchWcQualifyingDraw =>
      'Assistir ao sorteio das eliminatórias do Campeonato Mundial';

  @override
  String get hubEventArrangeFriendlies => 'Marcar jogos amistosos';

  @override
  String hubEventFriendliesSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Você ainda não preencheu suas $count janelas de amistosos abertas',
      one: 'Você ainda não preencheu sua janela de amistosos aberta',
    );
    return '$_temp0';
  }

  @override
  String get hubEventReshapeXi => 'Reorganizar seu onze inicial';

  @override
  String hubEventReshapeOutSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count do seu onze estão fora (suspensos ou lesionados). Escolha os substitutos',
      one:
          '1 do seu onze está fora (suspenso ou lesionado). Escolha o substituto',
    );
    return '$_temp0';
  }

  @override
  String hubEventReshapeShortSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Seu onze inicial está incompleto. Preencha as vagas abertas',
      one: 'Seu onze inicial está incompleto. Preencha a vaga aberta',
    );
    return '$_temp0';
  }

  @override
  String hubEventPlayOpponent(String opponent) {
    return 'Jogar contra $opponent';
  }

  @override
  String get hubEventContinentalFinalsFallback => 'a fase final continental';

  @override
  String get hubCallUpFriendlies => 'Convoque seu elenco para os amistosos';

  @override
  String get hubCallUpRequalify =>
      'Convoque de novo o elenco das eliminatórias';

  @override
  String get hubCallUpWorldCup =>
      'Convoque seu elenco para o Campeonato Mundial';

  @override
  String get hubCallUpFinals => 'Convoque seu elenco para a fase final';

  @override
  String get hubCallUpNationsCup =>
      'Convoque seu elenco para a Copa das Nações';

  @override
  String get hubCallUpQualifying => 'Convoque seu elenco para as eliminatórias';

  @override
  String get hubCallUpGeneric => 'Convoque seu elenco';

  @override
  String get hubHost => 'Anfitrião';

  @override
  String get hubGoldenBoot => 'Bota de Ouro';

  @override
  String hubGoldenBootValue(String name, int goals) {
    return '$name · $goals gols';
  }

  @override
  String get hubPens => '(pên.)';

  @override
  String get hubNationalHub => 'CENTRO NACIONAL';

  @override
  String get hubMessages => 'Mensagens';

  @override
  String get hubWorldChampions => 'CAMPEÕES MUNDIAIS';

  @override
  String get hubViewBracket => 'Ver quadro ›';

  @override
  String get hubBoardDelighted => 'Encantada';

  @override
  String get hubBoardPleased => 'Satisfeita';

  @override
  String get hubBoardExpectingMore => 'Esperando mais';

  @override
  String get hubBoardConcerned => 'Preocupada';

  @override
  String get hubBoardJobAtRisk => 'Cargo em risco';

  @override
  String get hubBoard => 'DIREÇÃO';

  @override
  String hubBoardObjective(String label) {
    return 'Objetivo da direção: $label';
  }

  @override
  String hubObjectiveMet(String result) {
    return 'CUMPRIDO · $result';
  }

  @override
  String hubObjectiveMissed(String result) {
    return 'FALHOU · $result';
  }

  @override
  String get hubNoMoreFixtures => 'Sem mais jogos neste ciclo.';

  @override
  String get hubVs => 'VS';

  @override
  String hubWorldRank(int rank) {
    return '#$rank';
  }

  @override
  String get hubWorldRankLabel => 'Ranking mundial';

  @override
  String get hubSquadStatus => 'SITUAÇÃO DO ELENCO';

  @override
  String hubPlayers(int count) {
    return '$count jogadores';
  }

  @override
  String get hubAvgRating => 'Nota média';

  @override
  String get hubMorale => 'Moral';

  @override
  String get hubManageTeam => 'Seu elenco';

  @override
  String get hubGroupsToBeDrawn =>
      'Os grupos ainda serão sorteados. Assista ao sorteio para revelá-los.';

  @override
  String hubGroupName(String name) {
    return 'GRUPO $name';
  }

  @override
  String get hubTblTeam => 'SELEÇÃO';

  @override
  String get hubTblP => 'J';

  @override
  String get hubTblGd => 'SG';

  @override
  String get hubTblPts => 'PTS';

  @override
  String get homeSettings => 'Configurações';

  @override
  String get homeLeadTheNation => 'COMANDE A SELEÇÃO';

  @override
  String get homeYourNation => 'sua seleção';

  @override
  String get homeNewGame => 'Novo jogo';

  @override
  String get homeAllSaves => 'Todas as gravações';

  @override
  String get homeLoadGame => 'Carregar jogo';

  @override
  String get homeContinue => 'CONTINUAR';

  @override
  String homeRoadToWorldCup(String date, int year) {
    return '$date · Rumo ao Campeonato Mundial $year';
  }

  @override
  String get careerManageSaves => 'Gerenciar gravações';

  @override
  String get careerNewGameTitle => 'NOVO JOGO';

  @override
  String careerCouldNotLoadNation(String error) {
    return 'Não foi possível carregar a seleção.\n$error';
  }

  @override
  String get careerNationNotFound => 'Seleção não encontrada.';

  @override
  String careerWorldRankNum(int rank) {
    return 'RANKING MUNDIAL #$rank';
  }

  @override
  String get careerManagerName => 'Nome do treinador';

  @override
  String get careerManagerNameHint => 'ex.: Alex Ferguson';

  @override
  String get careerBeginsBlurb =>
      'Sua carreira começa em setembro de 2026, rumo ao Campeonato Mundial de 2030.';

  @override
  String get careerFreeCycleNote =>
      'Grátis por um ciclo completo de quatro anos: eliminatórias, seu campeonato continental e o Campeonato Mundial, em dois espaços de gravação. Depois disso, um único pagamento desbloqueia ciclos sem fim.';

  @override
  String get careerStartCareer => 'Começar carreira';

  @override
  String get careersTitle => 'CARREIRAS';

  @override
  String get careerManagerCareer => 'Carreira de treinador';

  @override
  String get careerManagerCareerSubtitle =>
      'Todos os ciclos que você comandou e seu histórico geral';

  @override
  String get careerSummaryTitle => 'Resumo da carreira';

  @override
  String get careerSummarySubtitle =>
      'Sua sala de troféus e o histórico de treinador';

  @override
  String get careerAchievements => 'Conquistas';

  @override
  String get careerAchievementsSubtitle =>
      'Marcos, títulos e satisfação da direção';

  @override
  String get careerChallenges => 'Desafios';

  @override
  String get careerChallengesSubtitle =>
      'Provas brutais para uma carreira inteira';

  @override
  String get careerTeamRecords => 'Recordes da seleção';

  @override
  String get careerTeamRecordsSubtitle =>
      'Maiores artilheiros e mais jogos de todos os tempos';

  @override
  String get careerMyMatches => 'Meus jogos';

  @override
  String get careerMyMatchesSubtitle => 'Todos os resultados e próximos jogos';

  @override
  String get careerTitle => 'CARREIRA';

  @override
  String careerCouldNotLoadCareer(String error) {
    return 'Não foi possível carregar a carreira.\n$error';
  }

  @override
  String get careerNoCareer => 'Nenhuma carreira.';

  @override
  String get careerTrophyCabinet => 'SALA DE TROFÉUS';

  @override
  String get careerTournamentHistory => 'HISTÓRICO DE TORNEIOS';

  @override
  String get careerNoTournamentsYet => 'Nenhum torneio concluído ainda.';

  @override
  String get careerTeamFallback => 'Seleção';

  @override
  String careerWorldNum(int rank) {
    return 'MUNDO #$rank';
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
  String get careerStatPlayedShort => 'J';

  @override
  String get careerStatsHeading => 'EM NÚMEROS';

  @override
  String get careerStatsWinRate => 'Aproveitamento de vitórias';

  @override
  String get careerStatsGoalsFor => 'Gols marcados';

  @override
  String get careerStatsGoalsAgainst => 'Gols sofridos';

  @override
  String get careerStatsGoalDiff => 'Saldo de gols';

  @override
  String get careerStatsCleanSheets => 'Jogos sem sofrer gols';

  @override
  String get careerStatsBiggestWin => 'Maior vitória';

  @override
  String get careerStatsWinStreak => 'Sequência de vitórias';

  @override
  String get careerStatsUnbeaten => 'Sequência invicta';

  @override
  String get careerStatsShootouts => 'Pênaltis';

  @override
  String get careerStatsHatTricks => 'Hat-tricks';

  @override
  String get careerStatsMotms => 'Melhor em campo';

  @override
  String get careerStatsBestRating => 'Melhor nota';

  @override
  String get careerStatWonShort => 'V';

  @override
  String get careerStatDrawnShort => 'E';

  @override
  String get careerStatLostShort => 'D';

  @override
  String get careerStatGoalsForShort => 'GP';

  @override
  String get careerStatGoalsAgainstShort => 'GC';

  @override
  String get careerStatGoalDiffShort => 'SG';

  @override
  String get careerNoSilverware => 'Nenhum troféu ainda. Vá buscar um.';

  @override
  String get careerMedalGold => 'OURO';

  @override
  String get careerMedalSilver => 'PRATA';

  @override
  String get careerMedalBronze => 'BRONZE';

  @override
  String careerWinnersName(String name) {
    return 'Campeão: $name';
  }

  @override
  String get careerSavesTitle => 'GRAVAÇÕES';

  @override
  String careerCouldNotLoadSaves(String error) {
    return 'Não foi possível carregar as gravações.\n$error';
  }

  @override
  String careerSlotsCount(int used, int limit) {
    return 'ESPAÇOS  $used/$limit';
  }

  @override
  String get careerThisSave => 'esta gravação';

  @override
  String get careerSlotsFull => 'Espaços cheios';

  @override
  String careerSlotsUsed(int used) {
    return 'ESPAÇOS  $used';
  }

  @override
  String get careerSlotsUnlockMore => 'Desbloquear mais gravações';

  @override
  String get careerSlotsKeepNote =>
      'Todas as gravações que você já tem continuam jogáveis. Só uma nova precisa do desbloqueio.';

  @override
  String get careerNewGame => 'Novo jogo';

  @override
  String get careerDeleteSaveTitle => 'Eliminar gravação?';

  @override
  String careerDeleteSaveBody(String label) {
    return 'Isto elimina permanentemente a sua carreira $label.';
  }

  @override
  String get careerCancel => 'Cancelar';

  @override
  String get careerDelete => 'Eliminar';

  @override
  String get careerNoSavesYet =>
      'Nenhuma gravação ainda.\nComece um novo jogo para comandar uma seleção.';

  @override
  String get careerUnknownNation => 'Desconhecida';

  @override
  String careerPlayedMinutes(int minutes) {
    return '${minutes}min';
  }

  @override
  String careerPlayedHours(int hours, int minutes) {
    return '${hours}h ${minutes}min';
  }

  @override
  String careerLastPlayed(String when) {
    return 'Último jogo: $when';
  }

  @override
  String get careerJustNow => 'agora mesmo';

  @override
  String get careerYesterday => 'ontem';

  @override
  String careerMinutesAgo(int n) {
    return 'há ${n}min';
  }

  @override
  String careerHoursAgo(int n) {
    return 'há ${n}h';
  }

  @override
  String careerDaysAgo(int n) {
    return 'há ${n}d';
  }

  @override
  String careerRoadToWorldCup(int year) {
    return 'Rumo ao Campeonato Mundial de $year';
  }

  @override
  String get careerManagerCareerTitle => 'CARREIRA DE TREINADOR';

  @override
  String careerCouldNotLoad(String error) {
    return 'Não foi possível carregar.\n$error';
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
      other: '$nations seleções comandadas',
      one: '1 seleção comandada',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get careerStatTitles => 'Títulos';

  @override
  String get careerStatPlayed => 'Jogos';

  @override
  String get careerStatWon => 'Vitórias';

  @override
  String get careerStatDrawn => 'Empates';

  @override
  String get careerStatLost => 'Derrotas';

  @override
  String careerGoalsWinRate(
    int goalsFor,
    int goalsAgainst,
    String gd,
    int winRate,
  ) {
    return 'Gols $goalsFor–$goalsAgainst  ($gd)  ·  Aproveitamento $winRate%';
  }

  @override
  String get careerRecordResults => 'RESULTADOS RECORDE';

  @override
  String get careerBestWin => 'Melhor vitória';

  @override
  String get careerWorstDefeat => 'Pior derrota';

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
    return '${won}V ${drawn}E ${lost}D  ·  GP $goalsFor GC $goalsAgainst ($gd)';
  }

  @override
  String get careerWorldCupLabel => 'Campeonato Mundial';

  @override
  String get careerContinentalLabel => 'Continental';

  @override
  String get messagesTitle => 'MENSAGENS';

  @override
  String get messagesNoMessagesYet => 'Nenhuma mensagem ainda.';

  @override
  String messagesCouldNotLoad(String error) {
    return 'Não foi possível carregar as mensagens.\n$error';
  }

  @override
  String get messagesDone => 'Concluir';

  @override
  String get messagesNext => 'Próxima';

  @override
  String get rankingWorldRanking => 'RANKING MUNDIAL';

  @override
  String rankingCouldNotLoad(String error) {
    return 'Não foi possível carregar o ranking.\n$error';
  }

  @override
  String get rankingNoRanking => 'Nenhum ranking.';

  @override
  String get rankingAll => 'TODAS';

  @override
  String get rankingYourTeam => 'SUA SELEÇÃO';

  @override
  String get rankingYourRankingOverTime => 'SEU RANKING AO LONGO DO TEMPO';

  @override
  String rankingNowRank(int rank) {
    return 'agora #$rank';
  }

  @override
  String rankingBestWorst(int best, int worst) {
    return 'melhor #$best · pior #$worst';
  }

  @override
  String get friendliesTitle => 'AMISTOSOS';

  @override
  String friendliesLoadError(String error) {
    return 'Não foi possível carregar os amistosos.\n$error';
  }

  @override
  String get friendliesContinue => 'Continuar';

  @override
  String friendliesArrangeIntro(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count janelas livres',
      one: '1 janela livre',
    );
    return 'Marque jogos de preparação para $_temp0 antes da sua próxima partida oficial. Toque em um adversário ou deixe livre.';
  }

  @override
  String get friendliesFree => 'Livre';

  @override
  String matchGoalsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count GOLS',
      one: '1 GOL',
    );
    return '$_temp0';
  }

  @override
  String get matchGoalsTitle => 'GOLS';

  @override
  String get matchGoalsNone => 'Sem gols';

  @override
  String get matchGoalPenalty => 'PEN';

  @override
  String get matchGoalSetPiece => 'BOL';

  @override
  String matchGoalAssist(String name) {
    return 'assistência $name';
  }

  @override
  String get friendliesHome => 'CASA';

  @override
  String get friendliesAway => 'FORA';

  @override
  String get friendliesNoneThisWindow => 'Sem amistosos nesta janela';

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
  String get friendliesMonthJan => 'Jan';

  @override
  String get friendliesMonthFeb => 'Fev';

  @override
  String get friendliesMonthMar => 'Mar';

  @override
  String get friendliesMonthApr => 'Abr';

  @override
  String get friendliesMonthMay => 'Mai';

  @override
  String get friendliesMonthJun => 'Jun';

  @override
  String get friendliesMonthJul => 'Jul';

  @override
  String get friendliesMonthAug => 'Ago';

  @override
  String get friendliesMonthSep => 'Set';

  @override
  String get friendliesMonthOct => 'Out';

  @override
  String get friendliesMonthNov => 'Nov';

  @override
  String get friendliesMonthDec => 'Dez';

  @override
  String get resultsMyMatches => 'MEUS JOGOS';

  @override
  String resultsCouldNotLoad(String error) {
    return 'Não foi possível carregar os resultados.\n$error';
  }

  @override
  String get resultsNoFixtures => 'Sem jogos.';

  @override
  String get resultsVs => 'vs';

  @override
  String get resultsStageQualifier => 'ELIMINATÓRIA';

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
  String get resultsStageFinalsGroup => 'GRUPO DA FASE FINAL';

  @override
  String get resultsStageRoundOf32 => 'DEZESSEIS-AVOS';

  @override
  String get resultsStageRoundOf16 => 'OITAVAS DE FINAL';

  @override
  String get resultsStageQuarterFinal => 'QUARTAS DE FINAL';

  @override
  String get resultsStageThirdPlace => 'TERCEIRO LUGAR';

  @override
  String get matchSetupWarnCaptain =>
      'Nenhum capitão escolhido. Toque para dar a braçadeira a alguém';

  @override
  String matchSetupWarnCaptainInjured(String name) {
    return '$name está lesionado e não pode comandar a seleção desta vez. Toque para passar a braçadeira';
  }

  @override
  String matchSetupWarnCaptainSuspended(String name) {
    return '$name está suspenso para este jogo. Toque para passar a braçadeira';
  }

  @override
  String matchSetupWarnCaptainDropped(String name) {
    return '$name tem a braçadeira, mas não está no seu elenco. Toque para passá-la a outro';
  }

  @override
  String get matchSetupWarnSetPieces =>
      'Nenhum cobrador de bolas paradas escolhido. Toque para escolher quem assume';

  @override
  String get matchSetupWarnBoth =>
      'Sem capitão e sem cobradores de bolas paradas. Toque para definir';

  @override
  String matchStageMatchday(int matchday) {
    return 'R $matchday';
  }

  @override
  String get squadCaptain => 'Capitão';

  @override
  String deptEffectYouth(int points) {
    return 'As promessas da academia chegam cerca de $points de valor global melhores';
  }

  @override
  String deptEffectCommercial(String amount) {
    return '$amount de volta no fim do ciclo';
  }

  @override
  String deptEffectMedical(int percent) {
    return '$percent% menos lesões';
  }

  @override
  String deptEffectNaturalisation(int percent) {
    return '$percent% de chance de um jogador estrangeiro pedir para mudar de seleção';
  }

  @override
  String deptEffectBoard(int points) {
    return '+$points de paciência da direção antes de o seu cargo correr risco';
  }

  @override
  String get deptEffectNone => 'Sem efeito enquanto não houver verba';

  @override
  String get statsBestRated => 'Notas';

  @override
  String get statsMyCareer => 'Carreira';

  @override
  String get statsBestAverageRating => 'MELHOR NOTA MÉDIA';

  @override
  String get statsMyCareerRecord => 'SEU HISTÓRICO';

  @override
  String get statsNoRatingsRecorded => 'Nenhuma nota registrada ainda.';

  @override
  String get statsGroupRecord => 'Histórico';

  @override
  String get statsGroupRuns => 'Sequências';

  @override
  String get statsGroupExtremes => 'Extremos';

  @override
  String get statsGroupSplits => 'Em casa e fora';

  @override
  String get statsGroupSquad => 'Seus jogadores';

  @override
  String get statsPlayed => 'Jogos disputados';

  @override
  String get statsWinDrawLoss => 'Vitórias–empates–derrotas';

  @override
  String get statsWinRate => 'Aproveitamento de vitórias';

  @override
  String get statsGoals => 'Gols pró:contra';

  @override
  String get statsCleanSheets => 'Jogos sem sofrer gols';

  @override
  String get statsFailedToScore => 'Jogos sem marcar';

  @override
  String get statsLongestWinStreak => 'Maior sequência de vitórias';

  @override
  String get statsLongestUnbeaten => 'Maior sequência invicta';

  @override
  String get statsLongestCleanSheets => 'Maior sequência sem sofrer gols';

  @override
  String get statsLongestWinless => 'Maior sequência sem vencer';

  @override
  String get statsCurrentRun => 'Sequência invicta atual';

  @override
  String get statsBiggestWin => 'Maior vitória';

  @override
  String get statsHeaviestDefeat => 'Pior derrota';

  @override
  String get statsMostGoalsInAGame => 'Mais gols em um jogo';

  @override
  String get statsShootouts => 'Pênaltis ganhos–perdidos';

  @override
  String get statsComebackWins => 'Vitórias de virada';

  @override
  String get statsHome => 'Em casa';

  @override
  String get statsAway => 'Fora';

  @override
  String get statsNeutral => 'Neutro';

  @override
  String get statsCompetitive => 'Oficiais';

  @override
  String get statsFriendlies => 'Amistosos';

  @override
  String get statsHatTricks => 'Hat-tricks';

  @override
  String get statsBraces => 'Dobradinhas';

  @override
  String get statsMotms => 'Prêmios de melhor em campo';

  @override
  String get statsAssists => 'Assistências';

  @override
  String get statsCards => 'Cartões';

  @override
  String get statsBestRating => 'Melhor nota individual';

  @override
  String statsAppsShort(int apps) {
    return '$apps jogos';
  }

  @override
  String statsMotmShort(int motms) {
    return '$motms MEC';
  }

  @override
  String get captainArmband => 'C';

  @override
  String get captainCurrent => 'Capitão. Toque para retirar a braçadeira';

  @override
  String get captainFitBorn => 'Um líder nato';

  @override
  String get captainFitNatural => 'Um capitão natural';

  @override
  String get captainFitCapable => 'Pode usar a braçadeira';

  @override
  String get captainFitUnproven => 'Ainda não é líder';

  @override
  String get captainNone => 'Nenhum capitão escolhido';

  @override
  String captainMoraleBoost(int morale) {
    return '+$morale de moral no elenco';
  }

  @override
  String get resultsCategoryWorldCupQualifying =>
      'Eliminatórias do Campeonato Mundial';

  @override
  String get resultsCategoryFriendlies => 'Amistosos';

  @override
  String get resultsCategoryContinentalClash => 'Duelo Continental';

  @override
  String get resultsCategoryNationsCup => 'Copa das Nações';

  @override
  String get resultsCategoryContinentalCup => 'Copa Continental';

  @override
  String get resultsCategoryWorldCupQualifyingShort => 'Elim. CM';

  @override
  String get resultsCategoryContinentalQualifyingShort => 'Elim. Contin.';

  @override
  String get resultsCategoryContinentalQualifying =>
      'Eliminatórias da Copa Continental';

  @override
  String get resultsCategoryWorldCupFinals =>
      'Fase final do Campeonato Mundial';

  @override
  String get resultsRoundResults => 'RESULTADOS DA RODADA';

  @override
  String get resultsFriendlyInternationals => 'AMISTOSOS INTERNACIONAIS';

  @override
  String get resultsKnockout => 'Mata-mata';

  @override
  String resultsEarlierMatches(int count) {
    return 'Jogos anteriores ($count)';
  }

  @override
  String resultsMatchday(int matchday) {
    return 'RODADA $matchday';
  }

  @override
  String get resultsContinue => 'Continuar';

  @override
  String resultsGroup(String name) {
    return 'GRUPO $name';
  }

  @override
  String get achievementsScreenTitle => 'CONQUISTAS';

  @override
  String get achievementsChallengesTooltip => 'Desafios';

  @override
  String get achievementsChallengesHeading => 'DESAFIOS';

  @override
  String get achievementsBrutalTests =>
      'Provas brutais para uma carreira inteira';

  @override
  String achievementsCouldNotLoad(String error) {
    return 'Não foi possível carregar.\n$error';
  }

  @override
  String achievementsUnlockedCount(int earned, int total) {
    return '$earned / $total desbloqueadas';
  }

  @override
  String achievementsConqueredCount(int done, int total) {
    return '$done / $total vencidos';
  }

  @override
  String get achievementsBoardSatisfaction => 'SATISFAÇÃO DA DIREÇÃO';

  @override
  String achievementsUnlockedBanner(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count CONQUISTAS DESBLOQUEADAS',
      one: 'CONQUISTA DESBLOQUEADA',
    );
    return '$_temp0';
  }

  @override
  String get achCatWins => 'Vitórias';

  @override
  String get achCatMatches => 'Jogos';

  @override
  String get achCatQualifications => 'Qualificações';

  @override
  String get achCatTitles => 'Títulos';

  @override
  String get achCatMisc => 'Diversos';

  @override
  String get achCatMega => 'Mega';

  @override
  String get achCatGoals => 'Gols';

  @override
  String get achCatStreaks => 'Sequências';

  @override
  String get achTierBronze => 'Bronze';

  @override
  String get achTierSilver => 'Prata';

  @override
  String get achTierGold => 'Ouro';

  @override
  String get achTierPlatinum => 'Platina';

  @override
  String achGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Gols',
      one: '$count Gol',
    );
    return '$_temp0';
  }

  @override
  String achGoalsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Marque $count gols.',
      one: 'Marque 1 gol.',
    );
    return '$_temp0';
  }

  @override
  String achCleanSheets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Jogos sem sofrer gols',
      one: '$count Jogo sem sofrer gols',
    );
    return '$_temp0';
  }

  @override
  String achCleanSheetsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Termine $count jogos sem sofrer gols.',
      one: 'Termine 1 jogo sem sofrer gols.',
    );
    return '$_temp0';
  }

  @override
  String get achStreakWin5 => 'Hábito de Vencer';

  @override
  String get achStreakWin5Desc => 'Vença cinco jogos seguidos.';

  @override
  String get achStreakWin10 => 'Embalado';

  @override
  String get achStreakWin10Desc => 'Vença dez jogos seguidos.';

  @override
  String get achStreakWin20 => 'Rolo Compressor';

  @override
  String get achStreakWin20Desc => 'Vença vinte jogos seguidos.';

  @override
  String get achUnbeaten15 => 'Osso Duro';

  @override
  String get achUnbeaten15Desc => 'Fique quinze jogos sem perder.';

  @override
  String get achUnbeaten30 => 'Intocável';

  @override
  String get achUnbeaten30Desc => 'Fique trinta jogos sem perder.';

  @override
  String get achHattrick => 'Herói do Hat-trick';

  @override
  String get achHattrickDesc => 'Faça um jogador marcar um hat-trick.';

  @override
  String get achMotm10 => 'Destaque';

  @override
  String get achMotm10Desc => 'Receba 10 prêmios de melhor em campo.';

  @override
  String get achMotm50 => 'Talismã';

  @override
  String get achMotm50Desc => 'Receba 50 prêmios de melhor em campo.';

  @override
  String get achPerfect => 'Nota Dez';

  @override
  String get achPerfectDesc =>
      'Faça um jogador conseguir nota 9,5 ou mais em um jogo.';

  @override
  String get achShootout => 'Sangue Frio';

  @override
  String get achShootoutDesc => 'Vença cinco disputas de pênaltis.';

  @override
  String get achMassacre => 'Massacre';

  @override
  String get achMassacreDesc =>
      'Vença um jogo por 7 gols de diferença ou mais.';

  @override
  String get achAnnihilation => 'Aniquilação';

  @override
  String get achAnnihilationDesc =>
      'Vença um jogo por 10 gols de diferença ou mais.';

  @override
  String get chTierBronze => 'Bronze';

  @override
  String get chTierSilver => 'Prata';

  @override
  String get chTierGold => 'Ouro';

  @override
  String get chTierLegendary => 'Lendário';

  @override
  String get chFirstSteps => 'No Banco de Reservas';

  @override
  String get chFirstStepsDesc => 'Comande por 5 anos.';

  @override
  String get chUnbeaten10 => 'Embalado';

  @override
  String get chUnbeaten10Desc => 'Fique 10 jogos oficiais sem perder.';

  @override
  String get chTwoNations => 'Novo Desafio';

  @override
  String get chTwoNationsDesc => 'Comande 2 seleções diferentes.';

  @override
  String get chCont1 => 'Campeão Continental';

  @override
  String get chCont1Desc => 'Vença um campeonato continental.';

  @override
  String get chNc1 => 'Campeão da Copa das Nações';

  @override
  String get chNc1Desc => 'Vença a Copa das Nações.';

  @override
  String get chWc1 => 'Campeão Mundial';

  @override
  String get chWc1Desc => 'Vença o Campeonato Mundial.';

  @override
  String get chYears25 => 'Estabelecido';

  @override
  String get chYears25Desc => 'Comande por 25 anos.';

  @override
  String get chWc3 => 'Vencedor em Série';

  @override
  String get chWc3Desc => 'Vença 3 Campeonatos Mundiais.';

  @override
  String get chWc5 => 'Dinastia';

  @override
  String get chWc5Desc => 'Vença 5 Campeonatos Mundiais.';

  @override
  String get chWc10 => 'Imortal';

  @override
  String get chWc10Desc => 'Vença 10 Campeonatos Mundiais.';

  @override
  String get chWc2Teams => 'Malas Sempre Prontas';

  @override
  String get chWc2TeamsDesc =>
      'Vença o Campeonato Mundial com 2 seleções diferentes.';

  @override
  String get chWc3Teams => 'Globetrotter';

  @override
  String get chWc3TeamsDesc =>
      'Vença o Campeonato Mundial com 3 seleções diferentes.';

  @override
  String get chWcStreak3 => 'Tricampeonato';

  @override
  String get chWcStreak3Desc => 'Vença 3 Campeonatos Mundiais seguidos.';

  @override
  String get chWcAllconf => 'Conquistador do Mundo';

  @override
  String get chWcAllconfDesc =>
      'Vença o Campeonato Mundial com uma seleção de cada confederação (6).';

  @override
  String get chCont5 => 'Rei Continental';

  @override
  String get chCont5Desc => 'Vença 5 campeonatos continentais.';

  @override
  String get chContAll => 'Grand Slam dos Seis Continentes';

  @override
  String get chContAllDesc =>
      'Vença o campeonato continental de cada confederação (6).';

  @override
  String get chTreble => 'Varredura Total';

  @override
  String get chTrebleDesc =>
      'Vença o Campeonato Mundial, um título continental e a Copa das Nações na mesma carreira.';

  @override
  String get chNations10 => 'Nômade';

  @override
  String get chNations10Desc => 'Comande 10 seleções diferentes.';

  @override
  String get chYears100 => 'Século';

  @override
  String get chYears100Desc => 'Comande por 100 anos.';

  @override
  String get chYears500 => 'Meio Milênio';

  @override
  String get chYears500Desc => 'Comande por 500 anos.';

  @override
  String get chYears1000 => 'Eterno';

  @override
  String get chYears1000Desc => 'Comande por 1000 anos.';

  @override
  String get chGrandmaster => 'Grande Mestre';

  @override
  String get chGrandmasterDesc =>
      'Vença 3 Campeonatos Mundiais E 5 campeonatos continentais.';

  @override
  String get chUndefeated => 'Intocável';

  @override
  String get chUndefeatedDesc =>
      'Vença um Campeonato Mundial sem perder nenhum jogo.';

  @override
  String get chPerfectQual => 'Passagem Impecável';

  @override
  String get chPerfectQualDesc =>
      'Vença todos os jogos das eliminatórias do Campeonato Mundial.';

  @override
  String get chMinnow => 'Milagre dos Pequenos';

  @override
  String get chMinnowDesc =>
      'Vença o Campeonato Mundial com uma seleção fora do top 32 do ranking mundial.';

  @override
  String get chGrandTour => 'Em Casa e Fora';

  @override
  String get chGrandTourDesc =>
      'Vença um Campeonato Mundial como anfitrião e outro fora de casa.';

  @override
  String get chUnbeaten25 => 'A Muralha';

  @override
  String get chUnbeaten25Desc => 'Fique 25 jogos oficiais sem perder.';

  @override
  String get chGoals10k => 'Máquina de Gols';

  @override
  String get chGoals10kDesc => 'Marque 10.000 gols na carreira.';

  @override
  String get chCleanSheets500 => 'Fortaleza';

  @override
  String get chCleanSheets500Desc =>
      'Termine 500 jogos da carreira sem sofrer gols.';

  @override
  String get chHatTricks25 => 'Vício de Hat-trick';

  @override
  String get chHatTricks25Desc => 'Faça seus jogadores marcarem 25 hat-tricks.';

  @override
  String get chWinStreak25 => 'Implacável';

  @override
  String get chWinStreak25Desc => 'Vença 25 jogos seguidos.';

  @override
  String get chCont10 => 'Dinastia Continental';

  @override
  String get chCont10Desc => 'Vença 10 campeonatos continentais.';

  @override
  String get chPcWc => 'Campeão em Série';

  @override
  String chPcWcDesc(int count) {
    return 'Vença $count Campeonatos Mundiais nesta gravação.';
  }

  @override
  String get chPcMajors => 'Colecionador de Troféus';

  @override
  String chPcMajorsDesc(int count) {
    return 'Vença $count grandes troféus (Campeonato Mundial, continental ou Copa das Nações).';
  }

  @override
  String get chPcUnbeaten => 'Muralha de Ferro';

  @override
  String chPcUnbeatenDesc(int count) {
    return 'Fique $count jogos oficiais sem perder.';
  }

  @override
  String get chPcNations => 'Andarilho';

  @override
  String chPcNationsDesc(int count) {
    return 'Comande $count seleções diferentes.';
  }

  @override
  String get chPcYears => 'Longa Jornada';

  @override
  String chPcYearsDesc(int count) {
    return 'Comande por $count anos.';
  }

  @override
  String achWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Vitórias',
      one: '$count Vitória',
    );
    return '$_temp0';
  }

  @override
  String achWinsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vença $count jogos.',
      one: 'Vença 1 jogo.',
    );
    return '$_temp0';
  }

  @override
  String achMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Jogos',
      one: '$count Jogo',
    );
    return '$_temp0';
  }

  @override
  String achMatchesDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dispute $count jogos.',
      one: 'Dispute 1 jogo.',
    );
    return '$_temp0';
  }

  @override
  String get achQualWc => 'Classificado ao Campeonato Mundial';

  @override
  String get achQualWcDesc => 'Qualifique-se para o Campeonato Mundial.';

  @override
  String get achQualCont => 'Classificado ao Continental';

  @override
  String get achQualContDesc =>
      'Qualifique-se para o seu campeonato continental.';

  @override
  String get achTitleWc => 'Campeões Mundiais';

  @override
  String get achTitleWcDesc => 'Vença o Campeonato Mundial.';

  @override
  String get achTitleEuro => 'Campeões Europeus';

  @override
  String get achTitleEuroDesc => 'Vença o Campeonato Europeu.';

  @override
  String get achTitleCopa => 'Campeões da América do Sul';

  @override
  String get achTitleCopaDesc => 'Vença a Copa da América do Sul.';

  @override
  String get achTitleAfcon => 'Campeões Africanos';

  @override
  String get achTitleAfconDesc => 'Vença a Copa da África.';

  @override
  String get achTitleAsia => 'Campeões Asiáticos';

  @override
  String get achTitleAsiaDesc => 'Vença a Copa da Ásia.';

  @override
  String get achTitleConcacaf => 'Campeões da América do Norte';

  @override
  String get achTitleConcacafDesc => 'Vença a Copa da América do Norte.';

  @override
  String get achTitleOfc => 'Campeões da Oceania';

  @override
  String get achTitleOfcDesc => 'Vença a Copa da Oceania.';

  @override
  String get achTitleNations => 'Campeões da Copa das Nações';

  @override
  String get achTitleNationsDesc => 'Vença a Copa das Nações.';

  @override
  String get achTitleClash => 'Vencedores do Duelo Continental';

  @override
  String get achTitleClashDesc => 'Vença o Duelo Continental.';

  @override
  String get achMarksman => 'Artilheiro do Campeonato Mundial';

  @override
  String get achMarksmanDesc =>
      'Faça um jogador do elenco marcar 6 ou mais gols na fase final do Campeonato Mundial.';

  @override
  String get achSweep => 'Varredura Total';

  @override
  String get achSweepDesc =>
      'Conquiste o Campeonato Mundial e o seu título continental na mesma carreira.';

  @override
  String get achAllstar => 'Seleção do Torneio';

  @override
  String get achAllstarDesc =>
      'Tenha um jogador na seleção do torneio do Campeonato Mundial.';

  @override
  String get achGoldenboot => 'Bota de Ouro';

  @override
  String get achGoldenbootDesc =>
      'Faça sua seleção terminar como artilheira de um campeonato.';

  @override
  String get achDemolition => 'Demolição';

  @override
  String get achDemolitionDesc =>
      'Vença um jogo por 5 gols de diferença ou mais.';

  @override
  String get achievementsNice => 'Legal!';

  @override
  String get achievementsHardestTests =>
      'As provas mais duras de um treinador, ao longo de uma carreira inteira e de muitas seleções.';

  @override
  String get achievementsThisSave => 'ESTA GRAVAÇÃO';

  @override
  String get achievementsBrutalBadge => 'BRUTAL';

  @override
  String get paywallGoPro => 'SEM LIMITES';

  @override
  String get paywallOneTimeUnlock => 'Desbloqueio único. Sem assinatura.';

  @override
  String get paywallBenefitCarryOn =>
      'Esta gravação continua exatamente de onde parou, com todos os jogos pela seleção, recordes e rivalidades intactos.';

  @override
  String get paywallBenefitNoAds =>
      'Sem anúncios, sem microtransações, sem assinatura. Um pagamento, e todas as atualizações futuras são suas.';

  @override
  String get paywallBenefitSaves =>
      'Quantas gravações quiser. Comande uma favorita e uma seleção pequena ao mesmo tempo e veja como o mesmo jogo muda.';

  @override
  String get paywallBenefitEndless =>
      'Todos os ciclos daqui em diante. Escolha hoje um jovem de dezessete anos e descubra em 2034 se você acertou.';

  @override
  String get paywallUnlocked =>
      'O modo sem limites está desbloqueado. Aproveite!';

  @override
  String get paywallContactingStore => 'Contatando a loja…';

  @override
  String paywallUnlockProPriced(String price) {
    return 'Desbloquear sem limites · $price';
  }

  @override
  String get paywallRestorePurchases => 'Restaurar compras';

  @override
  String get paywallStoreUnavailable => 'Loja indisponível';

  @override
  String get paywallStoreUnavailableNote =>
      'Não foi possível carregar o preço. Verifique sua conexão e tente novamente.';

  @override
  String get paywallTryAgain => 'Tentar novamente';

  @override
  String get gateTitle => 'SEU PRIMEIRO CICLO ACABOU';

  @override
  String get gateLead =>
      'Quatro anos é um ciclo. Não é tempo suficiente para descobrir se você estava certo.';

  @override
  String get gatePriceLead => 'Um pagamento, para sempre';

  @override
  String get gateBuy => 'COMPRAR E CONTINUAR';

  @override
  String get gateExit => 'SAIR';

  @override
  String get gateSaveTitle => 'ESTE JOGO PRECISA DO PRO';

  @override
  String get gateSaveLead =>
      'Jogos além do ciclo gratuito e campanhas Pro continuam com o Pro. Nada se perde: este jogo espera por você exatamente como você o deixou.';

  @override
  String get careerSaveLockedNote => 'É preciso o Pro para continuar este jogo';

  @override
  String get federationNaturalisation => 'NATURALIZAÇÃO';

  @override
  String federationNaturalisedTitle(String name) {
    return '$name naturalizado';
  }

  @override
  String federationNaturalisedBody(String name, String nation) {
    return '$name concluiu a mudança e agora pode jogar por $nation. Convoque-o na seleção do elenco.';
  }

  @override
  String federationCouldNotLoadOffer(String error) {
    return 'Não foi possível carregar a proposta.\n$error';
  }

  @override
  String get federationContinue => 'Continuar';

  @override
  String get federationOfferToSwitchAllegiance =>
      'PROPOSTA PARA MUDAR DE SELEÇÃO';

  @override
  String federationPlayerMeta(String position, int age, String nation) {
    return '$position · $age anos · de $nation';
  }

  @override
  String federationNaturalisationBlurb(
    String name,
    String playerNation,
    String sourceNation,
  ) {
    return '$name tem vínculos com $playerNation e aceita ser naturalizado. Aceite e ele poderá ser convocado; recuse e ele continua com $sourceNation.';
  }

  @override
  String get federationDecline => 'Recusar';

  @override
  String get federationNaturalise => 'Naturalizar';

  @override
  String get federationBudgetLater => 'Decidir depois';

  @override
  String get federationSetYourBudget => 'DEFINA O ORÇAMENTO';

  @override
  String federationCouldNotLoadFinances(String error) {
    return 'Não foi possível carregar as finanças.\n$error';
  }

  @override
  String get federationSaveNotFound => 'Gravação não encontrada.';

  @override
  String get federationBudgetHeading => 'ORÇAMENTO DA FEDERAÇÃO';

  @override
  String federationDistributeBudget(String amount) {
    return 'Distribua $amount pelos departamentos para abrir o ciclo. Gaste com sabedoria.';
  }

  @override
  String federationOverBudget(String amount) {
    return '$amount a mais do que a federação tem. Retire um pouco';
  }

  @override
  String get federationAllocateFullBudget =>
      'Distribua todo o orçamento para começar o ciclo.';

  @override
  String get federationConfirming => 'Confirmando…';

  @override
  String get federationConfirmBudget => 'Confirmar orçamento';

  @override
  String get federationFinances => 'FINANÇAS';

  @override
  String get federationInvestmentUpdated => 'Investimento atualizado.';

  @override
  String get federationDevelopment => 'DESENVOLVIMENTO DA FEDERAÇÃO';

  @override
  String get federationProjectedAtSeasonEnd =>
      'PROJEÇÃO PARA O FIM DA TEMPORADA';

  @override
  String get federationCentralFunding => 'Financiamento central';

  @override
  String get federationPrizeMoneySoFar => 'Prêmios até agora';

  @override
  String get federationCommercialReturn => 'Retorno comercial';

  @override
  String get federationThisSeasonLocked => 'ESTA TEMPORADA (BLOQUEADO)';

  @override
  String get federationInvestForNextSeason => 'INVISTA NA PRÓXIMA TEMPORADA';

  @override
  String get federationNextSeasonImpact => 'IMPACTO NA PRÓXIMA TEMPORADA';

  @override
  String get federationSaving => 'Gravando…';

  @override
  String get federationConfirmInvestment => 'Confirmar investimento';

  @override
  String get federationBalance => 'SALDO DA FEDERAÇÃO';

  @override
  String get federationCommittedToStaff => 'Reservado para a comissão técnica';

  @override
  String get federationFreeToSpend => 'Livre para gastar';

  @override
  String get federationWagesNote =>
      'Os salários saem do saldo no fim do ciclo, por isso este valor já está comprometido.';

  @override
  String get federationInvestAtCeremony =>
      'Invista na próxima temporada na cerimônia de fim de ciclo.';

  @override
  String federationLevelBadge(int level) {
    return 'N$level';
  }

  @override
  String get federationAcademyProspects => 'Promessas da academia';

  @override
  String federationPlusOverall(int value) {
    return '+$value de valor global';
  }

  @override
  String get federationInjuryRisk => 'Risco de lesão';

  @override
  String get federationNaturalisationChance => 'Chance de naturalização';

  @override
  String get federationBoardPatience => 'Paciência da direção';

  @override
  String get federationUnallocated => 'NÃO DISTRIBUÍDO';

  @override
  String get nationsVitrineTitle => 'VITRINE NACIONAL';

  @override
  String nationsCouldNotLoad(String error) {
    return 'Não foi possível carregar a seleção.\n$error';
  }

  @override
  String get nationsNoNation => 'Nenhuma seleção.';

  @override
  String get nationsHonours => 'PALMARÉS';

  @override
  String get nationsRankingHistory => 'HISTÓRICO DO RANKING MUNDIAL';

  @override
  String get nationsTopScorers => 'MAIORES ARTILHEIROS DE TODOS OS TEMPOS';

  @override
  String get nationsTitles => 'TÍTULOS';

  @override
  String get nationsYourTeam => 'SUA SELEÇÃO';

  @override
  String get nationsWorld => 'MUNDO';

  @override
  String get nationsWorldCup => 'Campeonato Mundial';

  @override
  String get nationsContinental => 'Continental';

  @override
  String nationsAppearances(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count participações',
      one: '1 participação',
    );
    return '$_temp0';
  }

  @override
  String get nationsNotEnoughHistory =>
      'Ainda não há histórico suficiente. Volte depois de um ou dois ciclos.';

  @override
  String nationsBestRank(int rank) {
    return 'Melhor: #$rank';
  }

  @override
  String nationsNowRank(int rank) {
    return 'Agora: #$rank';
  }

  @override
  String get nationsNoGoals => 'Nenhum gol registrado ainda.';

  @override
  String get nationsGoalsAbbrev => 'gols';

  @override
  String get nationsHosts => 'SEDE';

  @override
  String get nationsSelectTitle => 'ESCOLHA A SELEÇÃO';

  @override
  String nationsCouldNotLoadNations(String error) {
    return 'Não foi possível carregar as seleções.\n$error';
  }

  @override
  String get nationsNoMatch => 'Nenhuma seleção encontrada.';

  @override
  String get nationsSelectHeading => 'Escolha a seleção';

  @override
  String get nationsSearchHint => 'Procurar país…';

  @override
  String get nationsRank => 'RANKING ';

  @override
  String get nationsPremium => 'PRO';

  @override
  String get nationsSelect => 'ESCOLHER';

  @override
  String get statsTeamRecords => 'RECORDES DA SELEÇÃO';

  @override
  String get statsRecordBook => 'Livro de recordes';

  @override
  String statsCouldNotLoadStats(String error) {
    return 'Não foi possível carregar as estatísticas.\n$error';
  }

  @override
  String get statsNoData => 'Sem dados.';

  @override
  String get statsTopScorers => 'ARTILHEIROS';

  @override
  String get statsMostGamesPlayed => 'MAIS JOGOS DISPUTADOS';

  @override
  String get statsTeam => 'Seleção';

  @override
  String get statsTopScorersShort => 'Artilheiros';

  @override
  String get statsMostGames => 'Mais jogos';

  @override
  String get statsNoGoalsRecorded => 'Nenhum gol registrado ainda.';

  @override
  String get statsUnknown => 'Desconhecido';

  @override
  String get playerTitle => 'JOGADOR';

  @override
  String playerLoadError(String error) {
    return 'Não foi possível carregar o jogador.\n$error';
  }

  @override
  String get playerNotFound => 'Jogador não encontrado.';

  @override
  String get playerClub => 'CLUBE';

  @override
  String get playerClubRole => 'No clube';

  @override
  String get playerPosition => 'Posição';

  @override
  String get playerPotential => 'Potencial';

  @override
  String get playerAge => 'Idade';

  @override
  String get playerValue => 'Valor';

  @override
  String get clubFirstChoice => 'Joga toda semana';

  @override
  String get clubRotation => 'Entra e sai';

  @override
  String get clubFringe => 'Quase não joga';

  @override
  String get clubFrozenOut => 'Não joga';

  @override
  String clubAtClub(String club, String standing) {
    return '$club: $standing';
  }

  @override
  String yWinUpset0(String opponent, String score) {
    return 'Vejo futebol há trinta anos e não esperava isso. $opponent vencido por $score.';
  }

  @override
  String yWinUpset1(String opponent, String score) {
    return 'Ninguém dava nada por eles contra $opponent. $score. Absolutamente ninguém.';
  }

  @override
  String yWinUpset2(String opponent, String score) {
    return '$score contra $opponent. Vá acordar os vizinhos.';
  }

  @override
  String yWinUpset3(String opponent, String score) {
    return 'Esse é o tipo de noite que se conta aos netos. $opponent $score.';
  }

  @override
  String yWinUpset4(String opponent, String score) {
    return '$score contra $opponent. Seja como for que aconteceu, aconteceu.';
  }

  @override
  String yWinUpset5(String opponent, String score) {
    return 'No papel, isso estava decidido antes de começar. $opponent $score diz o contrário.';
  }

  @override
  String yWinUpset6(String opponent, String score) {
    return 'Vencemos $opponent por $score. Daqui a um ano ninguém vai acreditar nesse resultado.';
  }

  @override
  String yWinUpset7(String opponent, String score) {
    return '$opponent $score. Aproveite e depois olhe para a tabela de jogos.';
  }

  @override
  String yWinUpset8(String opponent, String score) {
    return '$score contra $opponent, e contamos com a sorte em oitenta dos noventa minutos.';
  }

  @override
  String yWinUpset9(String opponent, String score) {
    return 'Uma noite contra $opponent não desfaz um ano inteiro. $score.';
  }

  @override
  String yWinUpset10(String opponent, String score) {
    return 'Vencemos $opponent por $score e agora vão dizer que viramos a página. Não viramos.';
  }

  @override
  String yWinUpset11(String opponent, String score) {
    return '$opponent $score. Maravilhoso. Pergunte de novo quando valer de verdade.';
  }

  @override
  String yWinRoutine0(String opponent, String score) {
    return 'Vencemos $opponent por $score. Exatamente como deve ser, e há prazer nisso.';
  }

  @override
  String yWinRoutine1(String opponent, String score) {
    return '$score sobre $opponent. Implacáveis, e implacável é um elogio.';
  }

  @override
  String yWinRoutine2(String opponent, String score) {
    return '$opponent $score. Sem alarde, sem susto, sem reclamações.';
  }

  @override
  String yWinRoutine3(String opponent, String score) {
    return 'Um $score tranquilo contra $opponent. É assim que uma boa seleção se comporta num dia calmo.';
  }

  @override
  String yWinRoutine4(String opponent, String score) {
    return '$score contra $opponent. Missão cumprida, nada aprendido.';
  }

  @override
  String yWinRoutine5(String opponent, String score) {
    return 'Vencemos $opponent por $score. Era para vencer, e vencemos.';
  }

  @override
  String yWinRoutine6(String opponent, String score) {
    return 'Um $score profissional sobre $opponent. Próximo.';
  }

  @override
  String yWinRoutine7(String opponent, String score) {
    return '$opponent despachado por $score. Arquive e siga em frente.';
  }

  @override
  String yWinRoutine8(String opponent, String score) {
    return '$score contra $opponent e esperam que a gente aplauda. Por vencer o adversário.';
  }

  @override
  String yWinRoutine9(String opponent, String score) {
    return 'Parabéns a todos os envolvidos no $score sobre $opponent, suponho.';
  }

  @override
  String yWinRoutine10(String opponent, String score) {
    return '$opponent $score. Vencer adversários assim é o mínimo, não é conquista.';
  }

  @override
  String yWinRoutine11(String opponent, String score) {
    return 'Vencemos $opponent por $score e jogamos pesados para isso.';
  }

  @override
  String yWinTight0(String opponent, String score) {
    return '$score contra $opponent e cada minuto foi merecido.';
  }

  @override
  String yWinTight1(String opponent, String score) {
    return 'Isso exigiu caráter. $opponent $score.';
  }

  @override
  String yWinTight2(String opponent, String score) {
    return 'Vencemos $opponent por $score do jeito difícil, que é o que dura.';
  }

  @override
  String yWinTight3(String opponent, String score) {
    return '$score contra $opponent. Quem vence jogos assim é quem ainda está de pé em junho.';
  }

  @override
  String yWinTight4(String opponent, String score) {
    return 'Nervoso, feio, e uma vitória. $opponent $score.';
  }

  @override
  String yWinTight5(String opponent, String score) {
    return 'Vencemos $opponent por $score. Leve os três pontos e nunca mais reveja o jogo.';
  }

  @override
  String yWinTight6(String opponent, String score) {
    return '$score. $opponent nos fez suar por cada centímetro.';
  }

  @override
  String yWinTight7(String opponent, String score) {
    return '$opponent $score. Não foi bonito. Vale o mesmo.';
  }

  @override
  String yWinTight8(String opponent, String score) {
    return '$score contra $opponent e tornamos isso dez vezes mais difícil do que era.';
  }

  @override
  String yWinTight9(String opponent, String score) {
    return 'Não devíamos estar sofrendo contra $opponent. $score.';
  }

  @override
  String yWinTight10(String opponent, String score) {
    return '$opponent $score. Ganhamos e não aprendemos nada de bom sobre nós.';
  }

  @override
  String yWinTight11(String opponent, String score) {
    return 'Um $score que nos favoreceu contra $opponent.';
  }

  @override
  String yDrew0(String opponent, String score) {
    return 'Um ponto contra $opponent, $score. Fique com ele e siga em frente.';
  }

  @override
  String yDrew1(String opponent, String score) {
    return '$score com $opponent. Há tardes piores do que esta.';
  }

  @override
  String yDrew2(String opponent, String score) {
    return 'Seguramos $opponent em $score. Nem tudo precisa virar história.';
  }

  @override
  String yDrew3(String opponent, String score) {
    return '$opponent $score. Um ponto é um ponto e a tabela não pergunta como.';
  }

  @override
  String yDrew4(String opponent, String score) {
    return '$score com $opponent. Dois pontos perdidos ou um ganho. Escolha o seu humor.';
  }

  @override
  String yDrew5(String opponent, String score) {
    return 'Empate contra $opponent, $score. Ninguém está feliz, ninguém está furioso.';
  }

  @override
  String yDrew6(String opponent, String score) {
    return '$opponent $score. Os noventa minutos mais esquecíveis do ano.';
  }

  @override
  String yDrew7(String opponent, String score) {
    return 'Dividimos os pontos com $opponent, $score. Vamos em frente.';
  }

  @override
  String yDrew8(String opponent, String score) {
    return '$score contra $opponent. Empates assim são como as campanhas morrem em silêncio.';
  }

  @override
  String yDrew9(String opponent, String score) {
    return 'Dois pontos jogados fora contra $opponent. $score. Não há outro nome.';
  }

  @override
  String yDrew10(String opponent, String score) {
    return '$opponent $score. Tivemos noventa minutos e nenhuma ideia do que fazer com eles.';
  }

  @override
  String yDrew11(String opponent, String score) {
    return 'Um $score com $opponent que ninguém vai lembrar e todo mundo vai pagar por ele.';
  }

  @override
  String yLost0(String opponent, String score) {
    return 'Derrota por $score para $opponent. Acontece.';
  }

  @override
  String yLost1(String opponent, String score) {
    return '$opponent $score. Nada que justifique culpar alguém. Vamos para o próximo.';
  }

  @override
  String yLost2(String opponent, String score) {
    return 'Perdemos por $score para $opponent e demos tudo. Em alguns dias não basta.';
  }

  @override
  String yLost3(String opponent, String score) {
    return '$score para $opponent. Cabeça erguida. Esta seleção tem muito a dar.';
  }

  @override
  String yLost4(String opponent, String score) {
    return '$opponent $score. Fomos o segundo melhor e não há discussão.';
  }

  @override
  String yLost5(String opponent, String score) {
    return 'Perdemos por $score para $opponent. Reorganizar.';
  }

  @override
  String yLost6(String opponent, String score) {
    return '$score para $opponent. Não é uma vergonha, mas não é bom o bastante.';
  }

  @override
  String yLost7(String opponent, String score) {
    return 'Derrota por $score para $opponent. Aprenda algo com isso ou foi em vão.';
  }

  @override
  String yLost8(String opponent, String score) {
    return '$score para $opponent e não encostamos neles.';
  }

  @override
  String yLost9(String opponent, String score) {
    return 'Perdemos para $opponent, $score. Os mesmos problemas, o mesmo mês, as mesmas desculpas a caminho.';
  }

  @override
  String yLost10(String opponent, String score) {
    return '$opponent $score. A partir de que ponto isso deixa de ser má sorte?';
  }

  @override
  String yLost11(String opponent, String score) {
    return 'Derrota por $score para $opponent. Um resultado que deveria custar caro a alguém.';
  }

  @override
  String yLostBadly0(String opponent, String score) {
    return '$score para $opponent. Uma noite ruim. Julguem a seleção pela campanha, não por isso.';
  }

  @override
  String yLostBadly1(String opponent, String score) {
    return 'Ninguém queria menos esse $score contra $opponent do que os próprios jogadores.';
  }

  @override
  String yLostBadly2(String opponent, String score) {
    return '$opponent $score. Feio, e não é quem esta seleção é.';
  }

  @override
  String yLostBadly3(String opponent, String score) {
    return 'Um $score para esquecer contra $opponent. Vão dar a resposta na próxima vez.';
  }

  @override
  String yLostBadly4(String opponent, String score) {
    return '$score. Para $opponent. Estou sem palavras e sou pago para ter palavras.';
  }

  @override
  String yLostBadly5(String opponent, String score) {
    return '$opponent $score. Alguém tem que responder por isso.';
  }

  @override
  String yLostBadly6(String opponent, String score) {
    return 'Quero o $score contra $opponent apagado dos registros e da memória.';
  }

  @override
  String yLostBadly7(String opponent, String score) {
    return 'Derrota por $score para $opponent. Não há como disfarçar um resultado assim.';
  }

  @override
  String yLostBadly8(String opponent, String score) {
    return 'Isso não foi uma derrota para $opponent, foi uma rendição. $score.';
  }

  @override
  String yLostBadly9(String opponent, String score) {
    return '$score. Contra $opponent. Gente pagou para ver isso.';
  }

  @override
  String yLostBadly10(String opponent, String score) {
    return '$opponent $score. Se isso não mudar alguma coisa, nada vai mudar.';
  }

  @override
  String yLostBadly11(String opponent, String score) {
    return 'Já vi esta seleção humilhada antes, mas $score para $opponent é um novo fundo do poço.';
  }

  @override
  String yWinUpset12(String opponent, String score) {
    return 'Vitória por $score frente a $opponent. Apontem a data, vão perguntar-vos onde estavam.';
  }

  @override
  String yWinUpset13(String opponent, String score) {
    return 'Fora do balneário ninguém acreditava. $score contra $opponent. Orgulho é pouco.';
  }

  @override
  String yWinUpset14(String opponent, String score) {
    return '$score contra $opponent! Correram todos até não terem mais nada.';
  }

  @override
  String yWinUpset15(String opponent, String score) {
    return 'Matadores de gigantes. $opponent, $score. É por isto que voltamos sempre.';
  }

  @override
  String yWinUpset16(String opponent, String score) {
    return '$score contra $opponent. Os prognósticos acabaram de sair pela janela.';
  }

  @override
  String yWinUpset17(String opponent, String score) {
    return 'Grande favorito: $opponent. Resultado final: $score para nós.';
  }

  @override
  String yWinUpset18(String opponent, String score) {
    return 'Uma das surpresas do ano: $score contra $opponent.';
  }

  @override
  String yWinUpset19(String opponent, String score) {
    return '$opponent $score. Ninguém previu e ninguém consegue bem explicar.';
  }

  @override
  String yWinUpset20(String opponent, String score) {
    return '$score contra $opponent. Lindo. Agora vejam todos esquecerem como foi mau o resto do ano.';
  }

  @override
  String yWinUpset21(String opponent, String score) {
    return '$score contra $opponent e o comboio já vai cheio. Eu estava cá quando ia vazio.';
  }

  @override
  String yWinUpset22(String opponent, String score) {
    return '$opponent $score. Brilhante, e mesmo assim vão arranjar maneira de desperdiçar isto.';
  }

  @override
  String yWinUpset23(String opponent, String score) {
    return 'Grande noite contra $opponent, $score. Uma andorinha não faz a primavera.';
  }

  @override
  String yLostBadly12(String opponent, String score) {
    return '$score frente a $opponent. Dói porque nos importa. Apoiem-nos na mesma.';
  }

  @override
  String yLostBadly13(String opponent, String score) {
    return 'Uma noite para esquecer contra $opponent, $score. Aos jogadores dói mais do que a ninguém.';
  }

  @override
  String yLostBadly14(String opponent, String score) {
    return '$opponent $score. Cabeça erguida. Uma equipa julga-se pela forma como responde a isto.';
  }

  @override
  String yLostBadly15(String opponent, String score) {
    return '$score contra $opponent. Mau, sim. O fim do mundo, não.';
  }

  @override
  String yLostBadly16(String opponent, String score) {
    return '$score frente a $opponent. Um resultado de que se vai falar durante anos, pelos piores motivos.';
  }

  @override
  String yLostBadly17(String opponent, String score) {
    return 'Vitória de $opponent, $score. Depois disto, ninguém se espante da próxima vez.';
  }

  @override
  String yLostBadly18(String opponent, String score) {
    return 'Uma das piores noites em muito tempo: $score contra $opponent.';
  }

  @override
  String yLostBadly19(String opponent, String score) {
    return '$opponent $score. Vai haver perguntas, e com razão.';
  }

  @override
  String yLostBadly20(String opponent, String score) {
    return '$score frente a $opponent. Vergonhoso é pouco.';
  }

  @override
  String yLostBadly21(String opponent, String score) {
    return 'Derrota por $score frente a $opponent. O último a sair que apague a luz.';
  }

  @override
  String yLostBadly22(String opponent, String score) {
    return '$opponent $score. Já não me surpreende, e isso assusta-me.';
  }

  @override
  String yLostBadly23(String opponent, String score) {
    return '$score. $opponent. Alguém lá em cima devia atualizar o currículo esta noite.';
  }

  @override
  String yWinRout0(String opponent, String score) {
    return '$score contra $opponent! Futebol assim põe o país inteiro a sorrir.';
  }

  @override
  String yWinRout1(String opponent, String score) {
    return 'Goleada a $opponent, $score. Que exibição.';
  }

  @override
  String yWinRout2(String opponent, String score) {
    return '$score. Contra $opponent. Esta noite saiu tudo.';
  }

  @override
  String yWinRout3(String opponent, String score) {
    return 'Uma demolição por $score frente a $opponent. Guardem o resumo, vão querê-lo.';
  }

  @override
  String yWinRout4(String opponent, String score) {
    return '$opponent $score. É uma equipa a divertir-se com o seu futebol.';
  }

  @override
  String yWinRout5(String opponent, String score) {
    return '$score contra $opponent, e podiam ter sido mais. Glorioso.';
  }

  @override
  String yWinRout6(String opponent, String score) {
    return '$score contra $opponent. Um resultado que obriga a olhar duas vezes.';
  }

  @override
  String yWinRout7(String opponent, String score) {
    return 'Vitória por $score frente a $opponent. Não houve jogo depois da primeira meia hora.';
  }

  @override
  String yWinRout8(String opponent, String score) {
    return 'Resultado final: $score contra $opponent. De longe a maior vitória em muito tempo.';
  }

  @override
  String yWinRout9(String opponent, String score) {
    return '$opponent $score. Uns vieram jogar, os outros nem saíram do autocarro.';
  }

  @override
  String yWinRout10(String opponent, String score) {
    return '$score. Nenhuma resposta de $opponent, a nada.';
  }

  @override
  String yWinRout11(String opponent, String score) {
    return 'Uma cabazada: $score contra $opponent.';
  }

  @override
  String yWinRout12(String opponent, String score) {
    return '$score contra $opponent. Bonito, mas não são propriamente a referência.';
  }

  @override
  String yWinRout13(String opponent, String score) {
    return '$score contra $opponent. Acordem-me quando fizermos isto a alguém bom.';
  }

  @override
  String yWinRout14(String opponent, String score) {
    return '$opponent $score. Divertido, mas já vi equipas brilharem assim e não ganharem nada.';
  }

  @override
  String yWinRout15(String opponent, String score) {
    return '$score, e voltam todos a ser génios. Era $opponent.';
  }

  @override
  String yWinRout16(String opponent, String score) {
    return '$score contra $opponent. Calma, isto prova muito pouco.';
  }

  @override
  String yWinRout17(String opponent, String score) {
    return '$opponent $score. Aproveitem, e depois lembrem-se de como acabou da última vez que nos entusiasmámos.';
  }

  @override
  String yWinShootout0(String opponent) {
    return 'Passámos nos penáltis contra $opponent! Nervos de aço, todos eles.';
  }

  @override
  String yWinShootout1(String opponent) {
    return 'Penáltis contra $opponent, e não tremeu ninguém. Abracem um desconhecido.';
  }

  @override
  String yWinShootout2(String opponent) {
    return 'Desempate por penáltis ganho contra $opponent. O meu coração não aguenta isto.';
  }

  @override
  String yWinShootout3(String opponent) {
    return 'Vitória nos penáltis contra $opponent. Seguimos para a próxima eliminatória.';
  }

  @override
  String yWinShootout4(String opponent) {
    return 'Contra $opponent decidiu-se da marca dos onze metros, e marcámos mais.';
  }

  @override
  String yWinShootout5(String opponent) {
    return 'Penáltis ganhos contra $opponent. Da forma mais difícil, mas passámos.';
  }

  @override
  String yWinShootout6(String opponent) {
    return 'Passámos nos penáltis contra $opponent. Lotaria ganha, exibição esquecida.';
  }

  @override
  String yWinShootout7(String opponent) {
    return 'Ganhar a $opponent nos penáltis depois daquilo? Sorte, e toda a gente sabe.';
  }

  @override
  String yWinShootout8(String opponent) {
    return 'Passámos contra $opponent nos penáltis. Nunca devíamos ter precisado deles.';
  }

  @override
  String yKnockoutWin0(String opponent, String score) {
    return 'APURADOS. $score contra $opponent, e o sonho continua vivo.';
  }

  @override
  String yKnockoutWin1(String opponent, String score) {
    return 'VITÓRIA NA ELIMINATÓRIA: $score contra $opponent. O país pode começar a acreditar.';
  }

  @override
  String yKnockoutWin2(String opponent, String score) {
    return '$score contra $opponent e seguimos em frente. Que noite.';
  }

  @override
  String yKnockoutWin3(String opponent, String score) {
    return '$opponent vai para casa, $score. Em frente.';
  }

  @override
  String yKnockoutWin4(String opponent, String score) {
    return 'ELIMINATÓRIA: $score contra $opponent. Próxima fase confirmada.';
  }

  @override
  String yKnockoutWin5(String opponent, String score) {
    return 'Apurados: $score contra $opponent.';
  }

  @override
  String yKnockoutWin6(String opponent, String score) {
    return 'Fora $opponent, $score. A próxima fase espera.';
  }

  @override
  String yKnockoutWin7(String opponent, String score) {
    return 'Vitória por $score contra $opponent. Numa eliminatória ninguém pergunta como.';
  }

  @override
  String yKnockoutWin8(String opponent, String score) {
    return 'Passámos contra $opponent, $score. O próximo adversário não vai ser tão simpático.';
  }

  @override
  String yKnockoutWin9(String opponent, String score) {
    return 'O $score contra $opponent chega para passar. Da próxima vez vai ser preciso muito mais.';
  }

  @override
  String yKnockoutWin10(String opponent, String score) {
    return '$opponent fora, $score. Mais sobrevivemos do que ganhámos.';
  }

  @override
  String yKnockoutWin11(String opponent, String score) {
    return 'Na próxima fase depois do $score contra $opponent. Não perguntem como.';
  }

  @override
  String yUpsetGap0(String opponent, String gap) {
    return '$gap lugares de diferença no ranking, e ganhámos a $opponent na mesma. Magnífico.';
  }

  @override
  String yUpsetGap1(String opponent, String gap) {
    return '$opponent: $gap lugares acima de nós. E ganhámos. O futebol é maravilhoso.';
  }

  @override
  String yUpsetGap2(String opponent, String gap) {
    return 'Diferença no ranking: $gap lugares. Resultado: vitória contra $opponent. Nunca deixem de acreditar.';
  }

  @override
  String yUpsetGap3(String opponent, String gap) {
    return 'Diferença no ranking antes do apito: $gap lugares. Vitória contra $opponent na mesma.';
  }

  @override
  String yUpsetGap4(String opponent, String gap) {
    return 'No ranking mundial, $opponent estava $gap lugares acima de nós. Hoje não.';
  }

  @override
  String yUpsetGap5(String opponent, String gap) {
    return 'Índice de surpresa: $gap lugares de ranking entre as duas. Vitória nossa contra $opponent.';
  }

  @override
  String yUpsetGap6(String opponent, String gap) {
    return '$gap lugares de ranking separavam-nos de $opponent. Uma noite não fecha essa distância.';
  }

  @override
  String yUpsetGap7(String opponent, String gap) {
    return '$opponent: $gap lugares acima, e perdeu. O ranking mal vai notar.';
  }

  @override
  String yUpsetGap8(String gap) {
    return 'Diferença no ranking: $gap lugares. Lembrem-se deste número da próxima vez que perdermos com um pequeno.';
  }

  @override
  String yEatWords0(String opponent) {
    return 'Dei esta equipa como acabada. Enganei-me, e nunca fiquei tão contente por me enganar. Vitória contra $opponent.';
  }

  @override
  String yEatWords1(String opponent) {
    return 'Uma dose de humildade, por favor. Grande. A vitória contra $opponent foi magnífica.';
  }

  @override
  String yEatWords2(String opponent) {
    return 'Disse que já não tinham nada. Tinham muito. Bem jogado contra $opponent, todos.';
  }

  @override
  String yEatWords3(String opponent) {
    return 'Para que conste, não vi esta vitória contra $opponent chegar. Mérito a quem o tem.';
  }

  @override
  String yEatWords4(String opponent) {
    return 'Pronto. Disse que iam ser desmascarados. $opponent não conseguiu.';
  }

  @override
  String yEatWords5(String opponent) {
    return 'Esta noite vou engolir o que disse sobre esta equipa. Ganhar a $opponent merece isso.';
  }

  @override
  String yEatWords6(String opponent) {
    return 'Sim, disse que estavam acabados. Uma vitória contra $opponent ainda não me tira a razão.';
  }

  @override
  String yEatWords7(String opponent) {
    return 'Dizem-me para engolir as palavras depois de $opponent. Vou engolir, devagar, e guardo o talão.';
  }

  @override
  String yEatWords8(String opponent) {
    return 'Ganhar a $opponent foi impressionante. As minhas dúvidas sobre esta equipa continuam aí.';
  }

  @override
  String yAwayFansWin0(String nation, String score) {
    return 'Tiro o chapéu a $nation. $score, e mereceram cada bocado.';
  }

  @override
  String yAwayFansWin1(String nation, String score) {
    return 'Custa dizer, mas hoje a melhor equipa foi $nation. $score. Parabéns.';
  }

  @override
  String yAwayFansWin2(String nation, String score) {
    return '$score. Vénia a $nation, quiseram mais.';
  }

  @override
  String yAwayFansWin3(String nation, String score) {
    return 'Derrota por $score contra $nation. Nem sei o que dizer.';
  }

  @override
  String yAwayFansWin4(String nation, String score) {
    return '$nation $score. Os nossos deviam ter vergonha.';
  }

  @override
  String yAwayFansWin5(String nation, String score) {
    return '$score contra $nation. Alguém me explique como é que isto aconteceu.';
  }

  @override
  String yAwayFansWin6(String nation, String score) {
    return 'Perder $score contra $nation. Nunca vou ultrapassar isto.';
  }

  @override
  String yAwayFansWin7(String nation, String score) {
    return '$score contra $nation. Sorte. Pura sorte.';
  }

  @override
  String yAwayFansWin8(String nation, String score) {
    return 'Depois deste $score, os adeptos de $nation vão ser insuportáveis durante anos. Obrigado por nada.';
  }

  @override
  String yNeutralWin0(String nation, String opponent, String score) {
    return '$nation $score $opponent. Brilhante para o futebol. É por isto que o amamos.';
  }

  @override
  String yNeutralWin1(String nation, String opponent, String score) {
    return 'Que resultado para $nation: $score contra $opponent. Futebol no seu melhor.';
  }

  @override
  String yNeutralWin2(String nation, String opponent, String score) {
    return 'Todos os neutros estão com $nation esta noite. $score contra $opponent!';
  }

  @override
  String yNeutralWin3(String nation, String opponent, String score) {
    return 'Resultado da jornada: $nation $score $opponent.';
  }

  @override
  String yNeutralWin4(String nation, String opponent, String score) {
    return '$nation $score $opponent. Ninguém tinha isto no boletim.';
  }

  @override
  String yNeutralWin5(String nation, String opponent, String score) {
    return 'Grande resultado: $nation $score $opponent. O ranking vai mexer.';
  }

  @override
  String yNeutralWin6(String nation, String opponent, String score) {
    return '$nation $score $opponent. Divertido, vamos ver se conseguem repetir.';
  }

  @override
  String yNeutralWin7(String nation, String opponent, String score) {
    return '$nation $score $opponent. Ganhou $nation ou perdeu $opponent?';
  }

  @override
  String yNeutralWin8(String nation, String opponent, String score) {
    return 'Bomba: $nation $score $opponent. Contem com muitas reações exageradas.';
  }

  @override
  String yScorerHero0(String name, String opponent) {
    return '$name contra $opponent. Vão dar o nome dele aos filhos.';
  }

  @override
  String yScorerHero1(String name, String opponent) {
    return 'Uma estátua para $name. Esta noite contra $opponent foi tudo.';
  }

  @override
  String yScorerHero2(String name, String opponent) {
    return '$name, que maravilha. Lembrem-se desta noite contra $opponent.';
  }

  @override
  String yScorerHero3(String name, String opponent) {
    return '$name decidiu contra $opponent. Homem do jogo, sem discussão.';
  }

  @override
  String yScorerHero4(String name, String opponent) {
    return 'Contra $opponent, a noite foi de $name.';
  }

  @override
  String yScorerHero5(String name, String opponent) {
    return '$name apareceu quando era preciso contra $opponent.';
  }

  @override
  String yScorerHero6(String name, String opponent) {
    return '$name esteve brilhante contra $opponent. Agora todas as semanas.';
  }

  @override
  String yScorerHero7(String name, String opponent) {
    return '$name salvou a equipa contra $opponent. Os outros ajudaram pouco.';
  }

  @override
  String yScorerHero8(String name, String opponent) {
    return 'Sem $name, a noite contra $opponent teria sido muito diferente.';
  }

  @override
  String yLostShock0(String opponent, String score) {
    return '$score frente a $opponent. Um acidente. Acontece a todos uma vez.';
  }

  @override
  String yLostShock1(String opponent, String score) {
    return 'Derrota por $score frente a $opponent. Sacudir e seguir, a campanha não acabou.';
  }

  @override
  String yLostShock2(String opponent, String score) {
    return '$opponent $score. Dói, mas um resultado não define esta equipa.';
  }

  @override
  String yLostShock3(String opponent, String score) {
    return '$score contra $opponent. Um mau dia no escritório. Em frente.';
  }

  @override
  String yLostShock4(String opponent, String score) {
    return 'Derrota contra $opponent, $score. Ninguém viu isto chegar.';
  }

  @override
  String yLostShock5(String opponent, String score) {
    return '$opponent $score. Uma daquelas noites que não fazem sentido.';
  }

  @override
  String yLostShock6(String opponent, String score) {
    return '$score frente a $opponent. Uma derrota que vai ser lembrada.';
  }

  @override
  String yLostShock7(String opponent, String score) {
    return 'Batidos por $opponent, $score. Uma surpresa, seja qual for a perspetiva.';
  }

  @override
  String yLostShock8(String opponent, String score) {
    return '$score frente a $opponent. Frente a $opponent! Inaceitável.';
  }

  @override
  String yLostShock9(String opponent, String score) {
    return 'Derrota por $score frente a $opponent. Quero explicações, não desculpas.';
  }

  @override
  String yLostShock10(String opponent, String score) {
    return '$opponent $score. Uma vergonha nacional, e não é força de expressão.';
  }

  @override
  String yLostShock11(String opponent, String score) {
    return '$score contra $opponent. Como é que alguém lá em cima continua no lugar?';
  }

  @override
  String yLostRout0(String opponent, String score) {
    return '$score frente a $opponent. É uma equipa de topo. Aprendam.';
  }

  @override
  String yLostRout1(String opponent, String score) {
    return 'Ultrapassados por $opponent, $score. Não há vergonha em perder com os melhores.';
  }

  @override
  String yLostRout2(String opponent, String score) {
    return '$opponent $score. Uma lição, e é com lições que se cresce.';
  }

  @override
  String yLostRout3(String opponent, String score) {
    return '$score contra $opponent. Dói, mas estão um patamar acima.';
  }

  @override
  String yLostRout4(String opponent, String score) {
    return 'Vitória de $opponent, $score. A diferença é real, e agora toda a gente a viu.';
  }

  @override
  String yLostRout5(String opponent, String score) {
    return '$score frente a $opponent. Uma tareia, pura e simples.';
  }

  @override
  String yLostRout6(String opponent, String score) {
    return '$opponent $score. A melhor equipa, e o resultado di-lo.';
  }

  @override
  String yLostRout7(String opponent, String score) {
    return 'Derrota por $score frente a $opponent. Não é uma desonra, mas também não houve jogo.';
  }

  @override
  String yLostRout8(String opponent, String score) {
    return '$score frente a $opponent. Melhor adversário ou não, ninguém devia perder assim.';
  }

  @override
  String yLostRout9(String opponent, String score) {
    return '$opponent $score. Sequer tentámos competir?';
  }

  @override
  String yLostRout10(String opponent, String score) {
    return '$score. Contra $opponent. Cordeiros para o matadouro.';
  }

  @override
  String yLostRout11(String opponent, String score) {
    return 'Batidos por $score por $opponent, e ninguém parecia incomodado.';
  }

  @override
  String yLostShootout0(String opponent) {
    return 'Fora nos penáltis contra $opponent. Deram tudo. Orgulho neles.';
  }

  @override
  String yLostShootout1(String opponent) {
    return 'Penáltis contra $opponent. A forma mais cruel de cair. Cabeça erguida.';
  }

  @override
  String yLostShootout2(String opponent) {
    return 'Desempate por penáltis perdido contra $opponent. Ninguém merecia isto.';
  }

  @override
  String yLostShootout3(String opponent) {
    return 'Fora nos penáltis contra $opponent. Decidiu a marca dos onze metros.';
  }

  @override
  String yLostShootout4(String opponent) {
    return '$opponent passa nos penáltis. O nosso torneio acaba aqui.';
  }

  @override
  String yLostShootout5(String opponent) {
    return 'Penáltis perdidos contra $opponent. Outra vez os penáltis.';
  }

  @override
  String yLostShootout6(String opponent) {
    return 'Fora nos penáltis contra $opponent. Alguma vez os treinamos?';
  }

  @override
  String yLostShootout7(String opponent) {
    return 'Eliminados por $opponent nos penáltis. Devíamos ter resolvido muito antes.';
  }

  @override
  String yLostShootout8(String opponent) {
    return 'Penáltis contra $opponent, e perdemos. Claro que perdemos.';
  }

  @override
  String yKnockoutLoss0(String opponent, String score) {
    return 'ELIMINADOS. $score frente a $opponent. Um percurso de que nos podemos orgulhar acaba aqui.';
  }

  @override
  String yKnockoutLoss1(String opponent, String score) {
    return 'Eliminados por $opponent, $score. Obrigado pelas memórias.';
  }

  @override
  String yKnockoutLoss2(String opponent, String score) {
    return '$score contra $opponent. A viagem acabou, mas que viagem.';
  }

  @override
  String yKnockoutLoss3(String opponent, String score) {
    return 'FORA: $score frente a $opponent. Cabeça erguida.';
  }

  @override
  String yKnockoutLoss4(String opponent, String score) {
    return 'ELIMINADOS: $score contra $opponent.';
  }

  @override
  String yKnockoutLoss5(String opponent, String score) {
    return 'Fora: $score contra $opponent.';
  }

  @override
  String yKnockoutLoss6(String opponent, String score) {
    return '$opponent passa, $score. O nosso torneio acabou.';
  }

  @override
  String yKnockoutLoss7(String opponent, String score) {
    return 'Eliminados por $opponent, $score. Começa a autópsia.';
  }

  @override
  String yKnockoutLoss8(String opponent, String score) {
    return 'FORA. $score frente a $opponent. Outro torneio, o mesmo final.';
  }

  @override
  String yKnockoutLoss9(String opponent, String score) {
    return '$score frente a $opponent, e para casa. Ninguém está surpreendido.';
  }

  @override
  String yKnockoutLoss10(String opponent, String score) {
    return 'Eliminados por $opponent, $score. Contem com desculpas até de manhã.';
  }

  @override
  String yKnockoutLoss11(String opponent, String score) {
    return '$opponent $score. Fora, e nunca pareceu que pudesse acabar de outra maneira.';
  }

  @override
  String yAwayFansGloat0(String nation, String score) {
    return '$score contra $nation. Respeito, vão voltar mais fortes.';
  }

  @override
  String yAwayFansGloat1(String nation, String score) {
    return 'Boa vitória nossa, $score. Mau dia para $nation, lamento pelos adeptos deles.';
  }

  @override
  String yAwayFansGloat2(String nation, String score) {
    return '$score. Má noite para $nation, e nós aproveitámos. É assim.';
  }

  @override
  String yAwayFansGloat3(String nation, String score) {
    return '$score contra $nation! Quem é que previa isto? Eles não.';
  }

  @override
  String yAwayFansGloat4(String nation, String score) {
    return 'Vitória por $score contra $nation. Alguém vá ver como estão os adeptos deles.';
  }

  @override
  String yAwayFansGloat5(String nation, String score) {
    return '$nation $score. Esta vai para o álbum de fotografias.';
  }

  @override
  String yAwayFansGloat6(String nation, String score) {
    return '$score contra $nation. E acham-se uma grande equipa.';
  }

  @override
  String yAwayFansGloat7(String nation, String score) {
    return 'Imagina perder $score contra nós. Pergunta a $nation, agora já sabem.';
  }

  @override
  String yAwayFansGloat8(String nation, String score) {
    return '$nation, $score. Boa viagem de regresso.';
  }

  @override
  String yNeutralLoss0(String nation, String opponent, String score) {
    return '$nation $score $opponent. Grande noite para $opponent, dura para $nation.';
  }

  @override
  String yNeutralLoss1(String nation, String opponent, String score) {
    return 'Força aos adeptos de $nation depois do $score contra $opponent. Vão recuperar.';
  }

  @override
  String yNeutralLoss2(String nation, String opponent, String score) {
    return '$nation $score $opponent. Todas as grandes equipas têm uma noite assim.';
  }

  @override
  String yNeutralLoss3(String nation, String opponent, String score) {
    return 'Bomba da jornada: $nation $score $opponent.';
  }

  @override
  String yNeutralLoss4(String nation, String opponent, String score) {
    return '$nation $score $opponent. Ninguém viu isto chegar.';
  }

  @override
  String yNeutralLoss5(String nation, String opponent, String score) {
    return 'Resultado do dia: $nation $score $opponent. Agora há perguntas para $nation.';
  }

  @override
  String yNeutralLoss6(String nation, String opponent, String score) {
    return '$nation $score $opponent. Não é caso isolado, para quem tem acompanhado.';
  }

  @override
  String yNeutralLoss7(String nation, String opponent, String score) {
    return '$nation $score $opponent. Alguém lá vai ter muito que explicar.';
  }

  @override
  String yNeutralLoss8(String nation, String opponent, String score) {
    return '$nation $score $opponent. Grande nome, pequena exibição.';
  }

  @override
  String yDownGap0(String opponent, String gap) {
    return '$opponent: $gap lugares abaixo de nós. Acontece. Em frente.';
  }

  @override
  String yDownGap1(String gap) {
    return 'Diferença no ranking: $gap lugares a nosso favor. O futebol não lê rankings.';
  }

  @override
  String yDownGap2(String opponent, String gap) {
    return '$gap lugares entre nós e $opponent no papel. Não em campo, esta noite.';
  }

  @override
  String yDownGap3(String opponent, String gap) {
    return 'Diferença no ranking antes do apito: $gap lugares a favor. Derrota contra $opponent na mesma.';
  }

  @override
  String yDownGap4(String opponent, String gap) {
    return 'No ranking mundial, $opponent estava $gap lugares abaixo de nós. Resultado: derrota.';
  }

  @override
  String yDownGap5(String opponent, String gap) {
    return 'Índice de surpresa: $gap lugares de ranking, ao contrário, contra $opponent.';
  }

  @override
  String yDownGap6(String opponent, String gap) {
    return '$gap lugares acima de $opponent no ranking. Derrota. Expliquem-me isso.';
  }

  @override
  String yDownGap7(String gap) {
    return 'Derrota contra uma equipa $gap lugares abaixo de nós. Deixem esse número assentar.';
  }

  @override
  String yDownGap8(String opponent, String gap) {
    return 'Diferença no ranking: $gap lugares. Derrota contra $opponent. Alguém devia começar a contar os dias.';
  }

  @override
  String yDrewHeroic0(String opponent, String score) {
    return '$score contra $opponent! Um empate que sabe a vitória.';
  }

  @override
  String yDrewHeroic1(String opponent, String score) {
    return '$score frente a $opponent. Orgulho em cada um deles.';
  }

  @override
  String yDrewHeroic2(String opponent, String score) {
    return '$opponent $score. Eram os favoritos e estivemos à altura.';
  }

  @override
  String yDrewHeroic3(String opponent, String score) {
    return '$score com $opponent. Um ponto ganho com sangue e suor.';
  }

  @override
  String yDrewHeroic4(String opponent, String score) {
    return '$score contra $opponent. Um ponto muito bom.';
  }

  @override
  String yDrewHeroic5(String opponent, String score) {
    return 'Empate a $score com $opponent. Poucos esperavam alguma coisa.';
  }

  @override
  String yDrewHeroic6(String opponent, String score) {
    return 'Travámos $opponent, $score. Um resultado para construir.';
  }

  @override
  String yDrewHeroic7(String opponent, String score) {
    return '$score contra $opponent. Um ponto que ninguém nos dava.';
  }

  @override
  String yDrewHeroic8(String opponent, String score) {
    return '$score com $opponent. Bom ponto, mas com empates não se ganha nada.';
  }

  @override
  String yDrewHeroic9(String opponent, String score) {
    return '$score frente a $opponent. Lindo. Também não tivemos um remate a sério.';
  }

  @override
  String yDrewHeroic10(String opponent, String score) {
    return '$opponent $score. Um ponto, e toda a gente age como se tivéssemos ganho o troféu.';
  }

  @override
  String yDrewHeroic11(String opponent, String score) {
    return '$score contra $opponent. Estacionámos o autocarro e tivemos sorte.';
  }

  @override
  String yDrewShame0(String opponent, String score) {
    return '$score com $opponent. Frustrante, mas continuamos invictos.';
  }

  @override
  String yDrewShame1(String opponent, String score) {
    return 'Só $score com $opponent. Um dia mau. Acontece.';
  }

  @override
  String yDrewShame2(String opponent, String score) {
    return '$opponent $score. Não chega, e os jogadores sabem.';
  }

  @override
  String yDrewShame3(String opponent, String score) {
    return '$score contra $opponent. Dois pontos perdidos, nada mais.';
  }

  @override
  String yDrewShame4(String opponent, String score) {
    return '$score com $opponent. Dois pontos deitados fora.';
  }

  @override
  String yDrewShame5(String opponent, String score) {
    return 'Só $score com $opponent. Um mau resultado, seja como for que o embrulhem.';
  }

  @override
  String yDrewShame6(String opponent, String score) {
    return '$opponent $score. Um empate que sabe a derrota.';
  }

  @override
  String yDrewShame7(String opponent, String score) {
    return '$score contra $opponent. Estes jogos têm de ser ganhos com folga.';
  }

  @override
  String yDrewShame8(String opponent, String score) {
    return '$score com $opponent. Vergonhoso.';
  }

  @override
  String yDrewShame9(String opponent, String score) {
    return 'Só um empate com $opponent, $score. Quem é o responsável?';
  }

  @override
  String yDrewShame10(String opponent, String score) {
    return '$opponent $score. Se não ganhamos a eles, ganhamos a quem?';
  }

  @override
  String yDrewShame11(String opponent, String score) {
    return '$score com $opponent. Os adeptos deles festejam um empate contra nós. Pensem nisso.';
  }

  @override
  String yTrophy0(String opponent) {
    return 'CAMPEÕES. $opponent. Digam em voz alta.';
  }

  @override
  String yTrophy1(String opponent) {
    return 'Ganhamos. $opponent. Eu não estou bem.';
  }

  @override
  String yTrophy2(String opponent) {
    return '$opponent, e o troféu vem para casa.';
  }

  @override
  String yTrophy3(String opponent) {
    return 'Cada um deles uma lenda. $opponent.';
  }

  @override
  String yRunnerUp0(String opponent) {
    return 'Tão perto. $opponent e uma medalha que ninguém quer.';
  }

  @override
  String yRunnerUp1(String opponent) {
    return 'Vice-campeões em $opponent. Vai doer durante anos.';
  }

  @override
  String yRunnerUp2(String opponent) {
    return '$opponent: a um jogo de tudo.';
  }

  @override
  String yRunnerUp3(String opponent) {
    return 'Segundos. Em $opponent. Alguém passe a garrafa.';
  }

  @override
  String yEliminated0(String opponent) {
    return 'Fora em $opponent. Esta vai doer por um bom tempo.';
  }

  @override
  String yEliminated1(String opponent) {
    return '$opponent é onde acaba para nós.';
  }

  @override
  String yEliminated2(String opponent) {
    return 'Eliminados em $opponent. Agora o inquérito.';
  }

  @override
  String yEliminated3(String opponent) {
    return 'Eliminados em $opponent. Alguém me explique isso.';
  }

  @override
  String yQualified0(String opponent) {
    return 'VAMOS PARA $opponent.';
  }

  @override
  String yQualified1(String opponent) {
    return 'Classificados para $opponent. Peçam folga no trabalho.';
  }

  @override
  String yQualified2(String opponent) {
    return '$opponent, aí vamos nós. Nunca esteve em dúvida (esteve totalmente em dúvida).';
  }

  @override
  String yQualified3(String opponent) {
    return 'Classificados para $opponent. A parte difícil já foi.';
  }

  @override
  String yGroupDrawn0(String opponent) {
    return 'Grupo sorteado em $opponent. Podia ser pior. Podia ser muito pior.';
  }

  @override
  String yGroupDrawn1(String opponent) {
    return 'Então esse é o sorteio de $opponent. Interessante.';
  }

  @override
  String yGroupDrawn2(String opponent) {
    return 'Os grupos de $opponent saíram e eu já não gosto do nosso.';
  }

  @override
  String yGroupDrawn3(String opponent) {
    return 'Sorteio de $opponent feito. Que comece o exagero.';
  }

  @override
  String yHostNamed0(String opponent) {
    return '$opponent vai sediar. Comecem a economizar.';
  }

  @override
  String yHostNamed1(String opponent) {
    return 'Vai para $opponent. Previsível, mas tudo bem.';
  }

  @override
  String yHostNamed2(String opponent) {
    return '$opponent fica com o torneio. Parabéns a eles, suponho.';
  }

  @override
  String yHostNamed3(String opponent) {
    return 'Anfitrião confirmado: $opponent.';
  }

  @override
  String yTournamentSoon0(String opponent) {
    return '$opponent começa em breve e não consigo ficar parado.';
  }

  @override
  String yTournamentSoon1(String opponent) {
    return 'Falta pouco para $opponent.';
  }

  @override
  String yTournamentSoon2(String opponent) {
    return '$opponent está quase aí. Convocatória, por favor.';
  }

  @override
  String yTournamentSoon3(String opponent) {
    return 'A contagem regressiva para $opponent está oficialmente insuportável.';
  }

  @override
  String get navY => 'Y';

  @override
  String get yTitle => 'Y';

  @override
  String get yEmpty => 'Nada a dizer ainda. Jogue uma partida.';

  @override
  String get yEarlierHeading => 'Antes neste ciclo';

  @override
  String get yTraitLoyalist =>
      'Apoia a seleção aconteça o que acontecer. Demora a virar, perdoa depressa.';

  @override
  String get yTraitCynic => 'Espera sempre o pior e fica feliz quando acerta.';

  @override
  String get yTraitNostalgic =>
      'Tudo era melhor antes. Compara você com homens que já se aposentaram.';

  @override
  String get yTraitStatshead =>
      'Só publica números e mais nada. Quase não tem humor.';

  @override
  String get yTraitHypeman =>
      'Dois bons resultados e já é uma geração de ouro.';

  @override
  String get yTraitContrarian =>
      'Seja o que for que a sala pense, o contrário.';

  @override
  String get yTraitDoomer => 'Vai dar errado. Vai sempre dar errado.';

  @override
  String get yProfilePosts => 'PUBLICAÇÕES';

  @override
  String get yProfileEmpty => 'Nada desta conta ainda.';

  @override
  String hubEventGrievance(String player) {
    return '$player quer uma palavra';
  }

  @override
  String get hubEventGrievanceSub => 'Ele quer saber qual é o seu lugar';

  @override
  String hubEventManagerSkills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pontos de habilidade para gastar',
      one: '1 ponto de habilidade para gastar',
    );
    return '$_temp0';
  }

  @override
  String get hubEventManagerSkillsSub =>
      'O que você faz bem melhora a sua seleção';

  @override
  String get grievanceTitle => 'Uma palavra no seu gabinete';

  @override
  String grievanceGameTime(String player) {
    return '$player está no elenco e não tocou na bola. Ele quer saber por quê.';
  }

  @override
  String grievanceSquadPlace(String player) {
    return '$player não está no elenco e não entende. Ele quer que lhe digam, de um jeito ou de outro.';
  }

  @override
  String grievanceRole(String player) {
    return '$player continua sendo escalado fora de posição e já cansou disso.';
  }

  @override
  String get grievanceReassure => 'Você está nos meus planos';

  @override
  String get grievanceHonest => 'Há outros à sua frente, e eis o motivo';

  @override
  String get grievanceDismiss => 'Quem escala sou eu';

  @override
  String yScorerStar0(String name, String goals) {
    return '$name fez $goals deles. Ninguém mais chega perto.';
  }

  @override
  String yScorerStar1(String name, String goals) {
    return '$goals de $name. Ele está carregando esta seleção.';
  }

  @override
  String yScorerStar2(String name, String goals) {
    return '$name: $goals no dia. Que jogador.';
  }

  @override
  String yScorerStar3(String name, String goals) {
    return 'Meteu $goals neles, $name. Faça a reverência.';
  }

  @override
  String yScorerStar4(String name, String goals) {
    return '$goals de $name, e o resto foram passageiros.';
  }

  @override
  String yScorerStar5(String name, String goals) {
    return '$name outra vez. $goals. Imagine esta seleção sem ele.';
  }

  @override
  String yScorerStar6(String name, String goals) {
    return '$goals de $name. Um homem não devia ter de fazer tanto.';
  }

  @override
  String yScorerStar7(String name, String goals) {
    return 'Tire $name disso e são $goals a menos e uma tarde muito diferente.';
  }

  @override
  String yWinStreak0(String count) {
    return '$count seguidas. Seja o que for que se diz nesse vestiário, está funcionando.';
  }

  @override
  String yWinStreak1(String count) {
    return 'São $count seguidas. Seleções não tropeçam em sequências assim.';
  }

  @override
  String yWinStreak2(String count) {
    return '$count seguidas e contando. A confiança se vê da arquibancada.';
  }

  @override
  String yWinStreak3(String count) {
    return 'Sem derrotas em $count. Pergunte a quem já foi treinador: essa é a parte difícil.';
  }

  @override
  String yWinStreak4(String count) {
    return '$count seguidas. Aproveite enquanto o calendário é gentil.';
  }

  @override
  String yWinStreak5(String count) {
    return '$count seguidas, e não vencemos ninguém de peso.';
  }

  @override
  String yWinStreak6(String count) {
    return 'Uma sequência de $count. Pergunte de novo quando for testada.';
  }

  @override
  String yWinStreak7(String count) {
    return '$count em fila. Toda seleção tem uma dessas dentro de si uma vez.';
  }

  @override
  String yLossStreak0(String count) {
    return '$count sem vencer agora. Em algum momento as desculpas acabam.';
  }

  @override
  String yLossStreak1(String count) {
    return 'São $count seguidas perdidas. Já não é um tropeço.';
  }

  @override
  String yLossStreak2(String count) {
    return '$count derrotas seguidas. Alguém tem que responder por isso.';
  }

  @override
  String yLossStreak3(String count) {
    return 'Sem vitórias em $count. Vê-se no jeito como jogam.';
  }

  @override
  String yLossStreak4(String count) {
    return '$count sem vencer e os mesmos erros toda semana.';
  }

  @override
  String yLossStreak5(String count) {
    return '$count seguidas. Seja o que for que estão tentando, não funciona.';
  }

  @override
  String yLossStreak6(String count) {
    return '$count seguidas. Isso é uma direção, não uma queda passageira.';
  }

  @override
  String yLossStreak7(String count) {
    return 'Sem vitórias em $count, e ninguém lá em cima disse uma palavra.';
  }

  @override
  String yRivalry0(String opponent, String score) {
    return '$opponent $score. Digam o que quiserem do futebol. Este vale em dobro.';
  }

  @override
  String yRivalry1(String opponent, String score) {
    return 'Contra $opponent, logo eles. $score. Ninguém aqui vai esquecer.';
  }

  @override
  String yRivalry2(String opponent, String score) {
    return '$score contra $opponent. Esse é o jogo de que vão falar nos bares.';
  }

  @override
  String yRivalry3(String opponent, String score) {
    return 'Vizinhos, $score. Direito de gozação resolvido por um tempo.';
  }

  @override
  String yRivalry4(String opponent, String score) {
    return '$opponent $score. Aconteça o que acontecer este ano, temos isso.';
  }

  @override
  String yRivalry5(String opponent, String score) {
    return '$score contra $opponent. Alguns de nós precisavam disso mais do que a tabela.';
  }

  @override
  String yRivalry6(String opponent, String score) {
    return '$opponent $score. E eles vão querer a revanche na próxima vez, sempre querem.';
  }

  @override
  String yRivalry7(String opponent, String score) {
    return 'Contra $opponent, $score. Um ano inteiro sendo lembrado deste jogo.';
  }

  @override
  String yInjuryBlow0(String name) {
    return '$name saiu lesionado. Era a última coisa de que esta seleção precisava.';
  }

  @override
  String yInjuryBlow1(String name) {
    return 'Perder $name muda o formato de tudo.';
  }

  @override
  String yInjuryBlow2(String name) {
    return '$name mancando. Prendam a respiração.';
  }

  @override
  String yInjuryBlow3(String name) {
    return 'Sem $name por um tempo, então. Alguém tem que dar um passo à frente.';
  }

  @override
  String yInjuryBlow4(String name) {
    return '$name fora. Claro que é $name.';
  }

  @override
  String yInjuryBlow5(String name) {
    return 'Sem $name esta se torna uma seleção muito comum.';
  }

  @override
  String yInjuryBlow6(String name) {
    return '$name lesionado de novo. Alguém devia perguntar por quê.';
  }

  @override
  String yInjuryBlow7(String name) {
    return 'Perdemos $name, e não há ninguém atrás dele. Esse é o problema real.';
  }

  @override
  String ySentOff0(String name, String minute) {
    return 'Vermelho para $name aos $minute minutos e o país inteiro vira as costas. Ele nos deu mais do que a maioria. Deixem isso.';
  }

  @override
  String ySentOff1(String name, String minute) {
    return '$name expulso aos $minute minutos. Duro. Com dez ainda tentamos, o que diz alguma coisa.';
  }

  @override
  String ySentOff2(String name, String minute) {
    return '$name, $minute minutos, cartão vermelho. Dez homens a partir daí.';
  }

  @override
  String ySentOff3(String name, String minute) {
    return 'Expulsão: $name aos $minute. Não é o primeiro jogo a virar por uma decisão.';
  }

  @override
  String ySentOff4(String name, String minute) {
    return 'Brilhante. $name é expulso aos $minute minutos e ficamos com dez. De novo.';
  }

  @override
  String ySentOff5(String name, String minute) {
    return '$name expulso aos $minute minutos. Quem exatamente treina a disciplina por aqui?';
  }

  @override
  String ySentOff6(String name, String minute) {
    return '$minute minutos. Foi quanto tempo $name conseguiu manter a cabeça. Futebol profissional.';
  }

  @override
  String ySentOff7(String name, String minute) {
    return 'Vermelho para $name aos $minute minutos, e eu devo acreditar que isso é progresso.';
  }

  @override
  String get yBoardPressure0 =>
      'A direção ficou muito calada. Isso nunca é bom sinal.';

  @override
  String get yBoardPressure1 =>
      'Dizem que a sala da direção começou a fazer perguntas.';

  @override
  String get yBoardPressure2 => 'Dá para sentir o chão se mexendo lá em cima.';

  @override
  String get yBoardPressure3 =>
      'Ninguém na federação diz nada que apoie. Tirem suas conclusões.';

  @override
  String get yBoardPressure4 =>
      'Ninguém lá em cima o defende em público há semanas.';

  @override
  String get yBoardPressure5 =>
      'A federação fala mal do próprio treinador. Como sempre.';

  @override
  String get yBoardPressure6 => 'Quando uma direção se cala, já decidiu.';

  @override
  String get yBoardPressure7 =>
      'Vão deixar isso se arrastar até ser decisão de outra pessoa.';

  @override
  String get yReplies => 'TAMBÉM SOBRE ESTE JOGO';

  @override
  String get yPlayerGrievance0 =>
      'Perguntei qual é o meu lugar. Ainda espero uma resposta.';

  @override
  String get yPlayerGrievance1 =>
      'Treinando duro. Não há muito mais que eu possa fazer.';

  @override
  String get yPlayerGrievance2 => 'Algumas perguntas só se fazem uma vez.';

  @override
  String get yPlayerGrievance3 =>
      'Não cheguei até aqui para carregar os coletes.';

  @override
  String get playerHonoursTitle => 'PALMARÉS';

  @override
  String get awardGoldenBall => 'Bola de Ouro';

  @override
  String get awardGoldenBoot => 'Bota de Ouro';

  @override
  String get awardGoldenGlove => 'Luva de Ouro';

  @override
  String get awardTeamOfTournament => 'Seleção do Torneio';

  @override
  String get awardPlayerOfYear => 'Melhor Jogador do Mundo';

  @override
  String get awardYoungPlayerOfYear => 'Jovem Jogador do Ano';

  @override
  String get playerClubHistory => 'HISTÓRICO DE CLUBES';

  @override
  String get playerCareerRecord => 'REGISTRO DA CARREIRA';

  @override
  String get playerInternationalGoals => 'Gols pela seleção';

  @override
  String get playerRecentForm => 'FORMA RECENTE';

  @override
  String get playerMatchHistory => 'HISTÓRICO DE JOGOS';

  @override
  String get playerAttributes => 'ATRIBUTOS';

  @override
  String get playerUnknown => 'Desconhecido';

  @override
  String get playerAttrPace => 'Velocidade';

  @override
  String get playerAttrPhysical => 'Físico';

  @override
  String get playerAttrTechnical => 'Técnica';

  @override
  String get playerAttrShooting => 'Finalização';

  @override
  String get playerAttrPassing => 'Passe';

  @override
  String get playerAttrDribbling => 'Drible';

  @override
  String get playerAttrTackling => 'Desarme';

  @override
  String get playerAttrPositioning => 'Posicionamento';

  @override
  String get playerAttrComposure => 'Frieza';

  @override
  String get playerAttrDecisions => 'Decisão';

  @override
  String get playerAttrStamina => 'Resistência';

  @override
  String get playerAttrStrength => 'Força';

  @override
  String get playerStatCaps => 'Jogos';

  @override
  String get playerStatGoals => 'Gols';

  @override
  String get playerStatAssists => 'Assistências';

  @override
  String get playerStatAvgRating => 'Nota média';

  @override
  String get playerStatForm => 'Forma';

  @override
  String get playerStatMotm => 'Melhor em campo';

  @override
  String get playerStatCleanSheets => 'Sem sofrer';

  @override
  String get playerStatBestGame => 'Melhor jogo';

  @override
  String get playerStatCards => 'Cartões';

  @override
  String playerCardsValue(int yellows, int reds) {
    return '${yellows}A ${reds}V';
  }

  @override
  String get tourSharedYourRun => 'SUA CAMPANHA';

  @override
  String get tourSharedList => 'Lista';

  @override
  String get tourSharedBracket => 'Quadro';

  @override
  String get tourSharedVs => 'x';

  @override
  String tourSharedGroupSeed(String seed) {
    return 'Grupo $seed';
  }

  @override
  String get tourSharedThisEdition => 'Esta edição';

  @override
  String get tourSharedAllTime => 'Todos os tempos';

  @override
  String get tourSharedUnknown => 'Desconhecido';

  @override
  String get tourSharedActive => 'EM ATIVIDADE';

  @override
  String get tourSharedMedalTable => 'QUADRO DE MEDALHAS';

  @override
  String get tourSharedPastWinners => 'CAMPEÕES ANTERIORES';

  @override
  String tourSharedHost(String host) {
    return 'Anfitrião: $host';
  }

  @override
  String get tourSharedBeat => 'venceu';

  @override
  String get tourSharedPens => ' (pên.)';

  @override
  String get tourSharedAwardsEmpty =>
      'Os prêmios são decididos depois de o torneio terminar.';

  @override
  String get tourSharedGoldenBall => 'BOLA DE OURO';

  @override
  String get tourSharedPlayerOfTournament => 'Melhor Jogador do Torneio';

  @override
  String get tourSharedGoldenBoot => 'BOTA DE OURO';

  @override
  String tourSharedGoalsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gols',
      one: '1 gol',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedGoldenGlove => 'LUVA DE OURO';

  @override
  String get tourSharedTeamOfTournament => 'SELEÇÃO DO TORNEIO';

  @override
  String get tourSharedStatsEmpty =>
      'Os recordes aparecem quando a competição tiver algum histórico.';

  @override
  String get tourSharedRecordScorer => 'MAIOR ARTILHEIRO';

  @override
  String get tourSharedStillActive => 'em atividade';

  @override
  String get tourSharedMostTitles => 'MAIS TÍTULOS';

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
  String get tourSharedMostFinals => 'MAIS FINAIS';

  @override
  String tourSharedFinalsContested(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count finais disputadas',
      one: '1 final disputada',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostGamesPlayed => 'MAIS JOGOS DISPUTADOS';

  @override
  String tourSharedMatchesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jogos',
      one: '1 jogo',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostFinalsPlayed => 'MAIS FASES FINAIS DISPUTADAS';

  @override
  String tourSharedFinalsTournamentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fases finais',
      one: '1 fase final',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedBiggestFinalWin => 'MAIOR VITÓRIA EM UMA FINAL';

  @override
  String tourStatsGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gols',
      one: '1 gol',
    );
    return '$_temp0';
  }

  @override
  String get tourStatsStillActive => 'em atividade';

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
      other: '$count finais disputadas',
      one: '1 final disputada',
    );
    return '$_temp0';
  }

  @override
  String tourStatsMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jogos',
      one: '1 jogo',
    );
    return '$_temp0';
  }

  @override
  String tourStatsFinalsTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fases finais',
      one: '1 fase final',
    );
    return '$_temp0';
  }

  @override
  String get tourStatsLeaders => 'LÍDERES DE TODOS OS TEMPOS';

  @override
  String get tourStatsTabGames => 'Jogos';

  @override
  String get tourStatsTabCups => 'Edições';

  @override
  String get tourStatsTabScorers => 'Artilheiros';

  @override
  String tourSharedFinalWinDetail(String opponent, int year) {
    return 'contra $opponent · $year';
  }

  @override
  String get tourHolders => 'DETENTORES';

  @override
  String tourHoldersSince(int year) {
    return 'campeões em $year';
  }

  @override
  String get tourSharedAllTimeScorers => 'ARTILHEIROS DE TODOS OS TEMPOS';

  @override
  String get tourSharedSummaryEmpty =>
      'O anfitrião e os estádios aparecem quando esta edição for sorteada.';

  @override
  String get tourSharedHostHeading => 'ANFITRIÃO';

  @override
  String get tourSharedHostsHeading => 'ANFITRIÕES';

  @override
  String get tourSharedCoHostsHeading => 'COANFITRIÕES';

  @override
  String get tourSharedVenues => 'ESTÁDIOS';

  @override
  String get tourSharedMascot => 'MASCOTE';

  @override
  String get tourSharedMatchBall => 'BOLA OFICIAL';

  @override
  String tourSharedVenueSeats(String city, String capacity) {
    return '$city · $capacity lugares';
  }

  @override
  String get tourSharedCouldNotLoad => 'Não foi possível carregar.';

  @override
  String get tourSharedHostTbc => 'ANFITRIÃO A CONFIRMAR';

  @override
  String get tourSharedFinalsAreHere => 'A FASE FINAL CHEGOU';

  @override
  String tourSharedHostedBy(String hosts) {
    return 'ANFITRIÃO  $hosts';
  }

  @override
  String get tourSharedLetFinalsBegin => 'Que comece a fase final';

  @override
  String get tourSharedCompetitions => 'COMPETIÇÕES';

  @override
  String get tourSharedWorldRanking => 'Ranking mundial';

  @override
  String get tourSharedCouldNotLoadTournaments =>
      'Não foi possível carregar os torneios.';

  @override
  String get tourSharedPrestigeStage => 'PALCO DE PRESTÍGIO';

  @override
  String get tourSharedOverview => 'Visão geral';

  @override
  String get tourSharedWorldRankingTitle => 'Ranking mundial';

  @override
  String get tourSharedYourCompetitions => 'SUAS COMPETIÇÕES';

  @override
  String get tourSharedOtherContinents => 'OUTROS CONTINENTES';

  @override
  String get tourSharedComingSoon => 'Torneio em breve';

  @override
  String get tourSharedSoon => 'EM BREVE';

  @override
  String get tourSharedNoQualifyingDraw => 'Sem sorteio das eliminatórias.';

  @override
  String get tourSharedOpenEnvelope => 'Abrir o envelope';

  @override
  String tourSharedGroupName(String name) {
    return 'GRUPO $name';
  }

  @override
  String get tourSharedBall => 'Bola';

  @override
  String get tourSharedPot => 'Pote';

  @override
  String get tourSharedAll => 'Tudo';

  @override
  String get tourSharedTapDrawTeam => 'Toque para sortear a próxima seleção';

  @override
  String get tourSharedTapDrawPot => 'Toque para sortear o próximo pote';

  @override
  String get tourSharedTapDrawAll => 'Toque para revelar todo o sorteio';

  @override
  String get tourSharedContinue => 'Continuar';

  @override
  String get tourSharedPause => 'Pausar';

  @override
  String get tourSharedPlay => 'Retomar';

  @override
  String get tourSharedSkip => 'Pular';

  @override
  String tourSharedPotNumber(int number) {
    return 'POTE $number';
  }

  @override
  String get tourSharedDrawComplete => 'SORTEIO CONCLUÍDO';

  @override
  String get tourSharedDrawing => 'SORTEANDO…';

  @override
  String get tourContChampionship => 'CAMPEONATO';

  @override
  String get tourContTabSummary => 'RESUMO';

  @override
  String get tourContTabQualifying => 'ELIMINATÓRIAS';

  @override
  String get tourContTabFinals => 'FASE FINAL';

  @override
  String get tourContTabBracket => 'QUADRO';

  @override
  String get tourContTabAwards => 'PRÊMIOS';

  @override
  String get tourContTabScorers => 'ARTILHEIROS';

  @override
  String get tourContTabHistory => 'HISTÓRICO';

  @override
  String get tourContTabRecords => 'RECORDES';

  @override
  String tourContCouldNotLoadCup(String error) {
    return 'Não foi possível carregar a copa.\n$error';
  }

  @override
  String get tourContNoCupData => 'Sem dados da copa.';

  @override
  String get tourContUnknown => 'Desconhecido';

  @override
  String get tourContGroupsToBeDrawnQual =>
      'Os grupos das eliminatórias são sorteados na cerimônia. Acompanhe pelo Início para ver quem você vai enfrentar.';

  @override
  String get tourContQualSeeded =>
      'Sua seleção entra direto na fase final. Sem eliminatórias neste ciclo.';

  @override
  String tourContBackgroundRegion(String name) {
    return '$name é simulado em segundo plano. Os resultados aparecem aqui conforme cada rodada é disputada.';
  }

  @override
  String get tourContGroupsToBeDrawnFinals =>
      'Os grupos da fase final são sorteados na cerimônia. Acompanhe pelo Início para ver o seu grupo.';

  @override
  String get tourContFinalsDrawAfterQual =>
      'O sorteio da fase final acontece quando as eliminatórias terminarem.';

  @override
  String get tourContContestedBeforeWc =>
      'As fases eliminatórias são disputadas antes do Campeonato Mundial.';

  @override
  String tourContChampionsHeading(String name) {
    return 'CAMPEÕES: $name';
  }

  @override
  String tourContWinnersTitle(String name) {
    return 'Campeões: $name';
  }

  @override
  String get tourContNoGoalsYet => 'Nenhum gol marcado ainda.';

  @override
  String tourContGroupHeading(String name) {
    return 'GRUPO $name';
  }

  @override
  String get tourContBestRunnersUp => 'MELHORES SEGUNDOS COLOCADOS';

  @override
  String tourContGroupDropdown(String name) {
    return 'Grupo $name';
  }

  @override
  String get tourContMatches => 'JOGOS';

  @override
  String get tourContNoGroupsDrawn => 'Nenhum grupo sorteado ainda.';

  @override
  String get tourContQualifyingDraw => 'SORTEIO DAS ELIMINATÓRIAS';

  @override
  String get tourContWorldQualifyingDraw => 'SORTEIO MUNDIAL DAS ELIMINATÓRIAS';

  @override
  String get tourContFinalsDraw => 'SORTEIO DA FASE FINAL';

  @override
  String get tourContSeedingPots => 'POTES DE CABEÇAS DE SÉRIE';

  @override
  String get tourContGroupDraw => 'SORTEIO DE GRUPOS';

  @override
  String tourContCouldNotLoadDraw(String error) {
    return 'Não foi possível carregar o sorteio.\n$error';
  }

  @override
  String get tourContDrawNotReady => 'O sorteio ainda não está pronto.';

  @override
  String get tourContContinentalClash => 'DUELO CONTINENTAL';

  @override
  String get tourContTabThisCycle => 'ESTE CICLO';

  @override
  String tourContCouldNotLoadClash(String error) {
    return 'Não foi possível carregar.\n$error';
  }

  @override
  String get tourContNoSaveFound => 'Gravação não encontrada.';

  @override
  String get tourContClashSoon =>
      'O Duelo Continental é disputado assim que os dois campeões continentais forem conhecidos.';

  @override
  String get tourContTwoContinentsOneMatch => 'DOIS CONTINENTES, UM JOGO';

  @override
  String get tourContVersusShort => 'vs';

  @override
  String tourContWinTheClash(String name) {
    return '$name vence o Duelo';
  }

  @override
  String get tourContNoClashYet => 'Nenhum Duelo Continental disputado ainda.';

  @override
  String get tourContNationsCup => 'COPA DAS NAÇÕES';

  @override
  String get tourContTabLeagues => 'LIGAS';

  @override
  String get tourContTabFinalsFour => 'FINAL FOUR';

  @override
  String tourContCouldNotLoad(String error) {
    return 'Não foi possível carregar.\n$error';
  }

  @override
  String get tourContNoNationsCupGoals =>
      'Nenhum gol registrado na Copa das Nações ainda.';

  @override
  String get tourContNoNationsCupChampions =>
      'Nenhum campeão da Copa das Nações coroado ainda.';

  @override
  String get tourContNationsCupOffSeason =>
      'A Copa das Nações deste ciclo começa depois da fase final continental. Os campeões anteriores estão em Histórico.';

  @override
  String get tourContNationsCupGroupsSoon =>
      'Os grupos da Copa das Nações deste ciclo são definidos no sorteio. Assista pelo Início para ver quem você vai enfrentar.';

  @override
  String get tourContLeagueNoGroups => 'Nenhum jogo nesta liga nesta rodada.';

  @override
  String tourContLeagueHeading(String letter) {
    return 'LIGA $letter';
  }

  @override
  String tourContLeagueHeadingYours(String letter) {
    return 'LIGA $letter · SUA LIGA';
  }

  @override
  String get tourContFinalsFourSoon =>
      'A Final Four é disputada pelos vencedores dos grupos da Liga A quando a fase de grupos terminar.';

  @override
  String tourContLeagueChip(String letter) {
    return 'Liga $letter';
  }

  @override
  String tourContLeagueChipStar(String letter) {
    return 'Liga $letter ★';
  }

  @override
  String get tourContSemiFinals => 'SEMIFINAIS';

  @override
  String get tourContFinal => 'FINAL';

  @override
  String get tourContNationsCupDraw => 'SORTEIO DA COPA DAS NAÇÕES';

  @override
  String get tourContIntercontinentalPlayoff => 'PLAY-OFF INTERCONTINENTAL';

  @override
  String get tourContNoPlayoffThisCycle => 'Sem play-off neste ciclo.';

  @override
  String get tourContPlayoffIntro =>
      'Duas vagas no Campeonato Mundial decididas num mata-mata entre os melhores não classificados das eliminatórias.';

  @override
  String get tourContPlayoffThrough =>
      'Você passou no play-off. Você está no Campeonato Mundial!';

  @override
  String get tourContPlayoffOut =>
      'Você ficou pelo caminho no play-off. Sem Campeonato Mundial desta vez.';

  @override
  String get tourContContinue => 'Continuar';

  @override
  String get tourContPlayoffFinals => 'FINAIS DO PLAY-OFF';

  @override
  String get tourContPlayoffSeeded => 'Cabeça de série (folga)';

  @override
  String get tourCupTabSummary => 'RESUMO';

  @override
  String get tourCupTabQualifying => 'ELIMINATÓRIAS';

  @override
  String get tourCupTabPlayoff => 'PLAY-OFF';

  @override
  String get tourCupPlayoffSoon =>
      'O play-off intercontinental é decidido quando as eliminatórias de todas as confederações terminarem.';

  @override
  String get tourCupTabFinals => 'FASE FINAL';

  @override
  String get tourCupTabBracket => 'QUADRO';

  @override
  String get tourCupTabAwards => 'PRÊMIOS';

  @override
  String get tourCupTabScorers => 'ARTILHEIROS';

  @override
  String get tourCupTabHistory => 'HISTÓRICO';

  @override
  String get tourCupTabRecords => 'RECORDES';

  @override
  String get tourCupTitle => 'CAMPEONATO MUNDIAL';

  @override
  String get tourCupNoData => 'Sem dados do torneio.';

  @override
  String tourCupLoadError(String error) {
    return 'Não foi possível carregar o torneio.\n$error';
  }

  @override
  String get tourCupUnknown => 'Desconhecido';

  @override
  String get tourCupWorldChampions => 'CAMPEÕES MUNDIAIS';

  @override
  String get tourCupWorldChampionsTitle => 'Campeões mundiais';

  @override
  String get tourCupStillActive => 'Ainda em atividade';

  @override
  String get tourCupAllTimeScorers => 'MAIORES ARTILHEIROS DA HISTÓRIA';

  @override
  String get tourCupAllConfederations => 'Todas as confederações';

  @override
  String get tourCupBestRunnersUp => 'Melhores segundos colocados';

  @override
  String get tourCupCompWorld => 'Campeonato Mundial';

  @override
  String get tourCupCompEurope => 'Campeonato Europeu';

  @override
  String get tourCupCompSAmerica => 'Copa da América do Sul';

  @override
  String get tourCupDestRoundOf16 => 'as oitavas de final';

  @override
  String get tourCupDestKnockouts => 'o mata-mata';

  @override
  String get tourCupDestFinals => 'a fase final';

  @override
  String get tourCupDestFinalsPlayoff => 'o play-off da fase final';

  @override
  String get tourCupDestIntercontPlayoff => 'o play-off intercontinental';

  @override
  String get tourCupFinalsDrawnAfterQual =>
      'A fase final é sorteada quando as eliminatórias terminarem.';

  @override
  String get tourCupFinalsDrawSoon =>
      'Grupos a sortear. Assista ao sorteio do Campeonato Mundial pelo Início para revelá-los.';

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
    return 'Anfitrião: $host';
  }

  @override
  String tourCupHostLabelMulti(String hosts) {
    return 'Anfitriões: $hosts';
  }

  @override
  String get tourCupIntercontPlayoff => 'Play-off intercontinental';

  @override
  String get tourCupKnockoutSoon =>
      'O quadro começa quando a fase de grupos terminar.';

  @override
  String get tourCupMatches => 'JOGOS';

  @override
  String get tourCupMedalTable => 'QUADRO DE MEDALHAS';

  @override
  String get tourCupMostTitles => 'MAIS TÍTULOS';

  @override
  String tourCupMostTitlesValue(String nation, int titles, int editions) {
    return '$nation: $titles títulos em $editions edições';
  }

  @override
  String get tourCupNoGoals => 'Ainda sem gols.';

  @override
  String get tourCupNoGroups => 'Nenhum grupo sorteado.';

  @override
  String get tourCupNoHistory => 'Ainda sem histórico.';

  @override
  String get tourCupPastWinners => 'CAMPEÕES ANTERIORES';

  @override
  String get tourCupPlayoffIntro =>
      'Duas vagas no Campeonato Mundial decididas num mata-mata entre os melhores não classificados das eliminatórias.';

  @override
  String tourCupPlayoffNoEntrants(String confederation) {
    return '$confederation não disputa play-off: todas as vagas são decididas nos grupos das eliminatórias.';
  }

  @override
  String get tourCupQualDrawSoon =>
      'Grupos a sortear. Assista ao sorteio das eliminatórias pelo Início para revelá-los.';

  @override
  String tourCupRegionYours(String region) {
    return '$region · sua';
  }

  @override
  String tourCupScorePens(int home, int away) {
    return '$home–$away (pên.)';
  }

  @override
  String get tourCupSegAllTime => 'Histórico';

  @override
  String get tourCupSegFinals => 'Fase final';

  @override
  String get tourCupSegQualifying => 'Eliminatórias';

  @override
  String get playerTraitsTitle => 'CONHECIDO POR';

  @override
  String get traitBigGame => 'Decisivo';

  @override
  String get traitBigGameBlurb => 'Eleva o nível nos confrontos de mata-mata.';

  @override
  String get traitSetPiece => 'Especialista em bolas paradas';

  @override
  String get traitSetPieceBlurb =>
      'Melhor cobrança e mais gols de bola parada.';

  @override
  String get traitHothead => 'Cabeça quente';

  @override
  String get traitHotheadBlurb =>
      'Leva muito mais cartões do que os companheiros.';

  @override
  String get traitIronMan => 'Homem de ferro';

  @override
  String get traitIronManBlurb => 'Raramente se lesiona e cansa mais devagar.';

  @override
  String get traitWonderkid => 'Prodígio';

  @override
  String get traitWonderkidBlurb => 'Jovem, já bom e ainda evoluindo depressa.';

  @override
  String get traitLeader => 'Líder';

  @override
  String get traitLeaderBlurb => 'Eleva todos os companheiros em campo.';

  @override
  String get traitPacey => 'Veloz';

  @override
  String get traitPaceyBlurb =>
      'Velocidade fulminante, uma ameaça nas costas da defesa.';

  @override
  String get traitOldHead => 'Veterano';

  @override
  String get traitOldHeadBlurb =>
      'Um veterano cuja leitura de jogo dura mais que as pernas.';

  @override
  String get traitWasteful => 'Desperdiçador';

  @override
  String get traitWastefulBlurb => 'Manda para fora chances claras demais.';

  @override
  String get objectiveWorldCup => 'Campeonato Mundial';

  @override
  String get objectiveWinTournament => 'Ganhar o título';

  @override
  String get objectiveQualifyGeneric => 'Classificar-se';

  @override
  String hubBoardObjectiveFor(String competition, String label) {
    return '$competition: $label';
  }

  @override
  String get objectiveWinWorldCup => 'Ganhar o Campeonato Mundial';

  @override
  String get objectiveReachFinal => 'Chegar à final';

  @override
  String get objectiveReachSemis => 'Chegar às semifinais';

  @override
  String get objectiveReachQuarters => 'Chegar às quartas de final';

  @override
  String get objectiveReachKnockouts => 'Chegar ao mata-mata';

  @override
  String get objectiveQualify => 'Classificar-se para o Campeonato Mundial';

  @override
  String get finishChampions => 'Campeões';

  @override
  String get finishRunnersUp => 'Vice-campeões';

  @override
  String get finishSemiFinals => 'Semifinais';

  @override
  String get finishQuarterFinals => 'Quartas de final';

  @override
  String get finishRoundOf16 => 'Oitavas de final';

  @override
  String get finishGroupStage => 'Fase de grupos';

  @override
  String get objectiveQualifyingTopHalf =>
      'Terminar na metade de cima das eliminatórias';

  @override
  String get finishQualifyingTopHalf =>
      'Metade de cima do grupo das eliminatórias';

  @override
  String get finishQualifyingBottomHalf =>
      'Metade de baixo do grupo das eliminatórias';

  @override
  String get objectiveNcWinIt => 'Ganhar a Copa das Nações';

  @override
  String get objectiveNcReachFinal => 'Chegar à final da Copa das Nações';

  @override
  String get objectiveNcFinalsFour => 'Chegar à Final Four';

  @override
  String get objectiveNcWinGroup => 'Vencer o grupo e subir de liga';

  @override
  String get objectiveNcTopHalf => 'Terminar na metade de cima do grupo';

  @override
  String get objectiveNcSurvive => 'Evitar o rebaixamento';

  @override
  String get objectiveNcOffTheBottom => 'Não terminar na lanterna do grupo';

  @override
  String get finishNcChampions => 'Campeões da Copa das Nações';

  @override
  String get finishNcFinalsFour => 'Final Four';

  @override
  String get finishNcGroupWinners => 'Vencedores do grupo';

  @override
  String get finishNcTopHalf => 'Metade de cima do grupo';

  @override
  String get finishNcStayedUp => 'Permaneceu na liga';

  @override
  String get finishNcClearOfBottom => 'Fora da lanterna do grupo';

  @override
  String get finishNcBottom => 'Lanterna do grupo';

  @override
  String get careerNationsCupLabel => 'Copa das Nações';

  @override
  String get squadDevPlayer => 'JOGADOR';

  @override
  String get squadDevAge => 'IDADE';

  @override
  String get squadDevPosition => 'POS';

  @override
  String get squadDevChange => 'VALOR';

  @override
  String get squadDevNew => 'NOVO';

  @override
  String get squadDevRetired => 'APOSENTADO';

  @override
  String get squadDevEmpty => 'Um ano tranquilo. Sem mudanças no elenco.';

  @override
  String get squadDevTierRegulars => 'TITULARES';

  @override
  String get squadDevTierFringe => 'RESERVAS';

  @override
  String get squadDevTierYouth => 'JOVENS';

  @override
  String get boardObjectivesTitle => 'Objetivos da direção';

  @override
  String get boardObjectivesConfidence => 'Confiança da direção';

  @override
  String boardObjectiveBeatenBy(String result, int rounds) {
    String _temp0 = intl.Intl.pluralLogic(
      rounds,
      locale: localeName,
      other: '$rounds fases acima do pedido',
      one: 'uma fase acima do pedido',
    );
    return '$result: $_temp0';
  }

  @override
  String boardObjectiveShortBy(String result, int rounds) {
    String _temp0 = intl.Intl.pluralLogic(
      rounds,
      locale: localeName,
      other: '$rounds fases abaixo',
      one: 'uma fase abaixo',
    );
    return '$result: $_temp0';
  }

  @override
  String get boardObjectivesPending => 'AINDA EM ABERTO';

  @override
  String boardObjectiveSoFar(String result) {
    return 'ATÉ AGORA · $result';
  }

  @override
  String get boardObjectivesEmpty =>
      'A direção não definiu um objetivo para este ciclo.';

  @override
  String get tourContBestWinners => 'MELHORES VENCEDORES DE GRUPO';

  @override
  String get tourContBestThirds => 'MELHORES TERCEIROS COLOCADOS';

  @override
  String tourContBestPlaced(String position) {
    return 'MELHORES $positionº COLOCADOS';
  }

  @override
  String squadDevPageOf(String page, String pages, String total) {
    return '$page/$pages · $total jogadores';
  }

  @override
  String get matchSoldOut => 'LOTADO';

  @override
  String matchAttendanceOf(String attendance, String capacity) {
    return '$attendance de $capacity lugares ocupados';
  }

  @override
  String get matchGroundTitle => 'ESTÁDIO';

  @override
  String get absenceInjured => 'Lesionado';

  @override
  String get absenceSuspended => 'Suspenso';

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
      other: '$countString jogos',
      one: '1 jogo',
    );
    return '$_temp0';
  }

  @override
  String absenceBackFor(String opponent) {
    return 'Volta contra $opponent';
  }

  @override
  String get penaltyOrderTitle => 'Pênaltis';

  @override
  String get penaltyOrderBlurb =>
      'Escolha seus cinco cobradores, em ordem. Toque num espaço para mudar.';

  @override
  String penaltyOrderPick(int number) {
    return 'Cobrança $number';
  }

  @override
  String get penaltyOrderPickBlurb =>
      'Escolha quem vai bater. A barra mostra a calma dele na marca do pênalti.';

  @override
  String get penaltyOrderConfirm => 'Começar as cobranças';

  @override
  String get penaltyOrderCancel => 'Voltar';

  @override
  String get youthTitle => 'Base';

  @override
  String get youthEmptyLevel => 'Ninguém neste nível ainda.';

  @override
  String get youthReleased => 'Dispensados este ano';

  @override
  String get u21Title => 'Sub-21';

  @override
  String get u21Blurb =>
      'A próxima geração, a maior promessa primeiro. Estrelas vazadas são a estimativa de um olheiro. Escale o jogador pela seleção para descobrir o que ele realmente tem.';

  @override
  String get u21Empty =>
      'Ninguém com menos de 21 anos no grupo agora. A próxima leva chega com o novo ciclo.';

  @override
  String u21Breakout(int gain) {
    return '+$gain ESTE ANO';
  }

  @override
  String u21AgeCaps(int age, int caps) {
    return '$age anos · $caps jogos pela seleção';
  }

  @override
  String u21AgeUncapped(int age) {
    return '$age anos · sem jogos pela seleção';
  }

  @override
  String get u21CallUps => 'Ir às convocações';

  @override
  String get youthWatching => 'Acompanhando';

  @override
  String get youthWatchEmpty =>
      'Ninguém marcado ainda. Marque um garoto em qualquer nível e ele aparece aqui, com o que se tornou desde então.';

  @override
  String get youthWatchMark => 'Acompanhar este garoto';

  @override
  String get youthWatchUnmark => 'Deixar de acompanhar';

  @override
  String youthWatchMarked(int rating, int age) {
    return 'Marcado com $rating, aos $age anos';
  }

  @override
  String get youthWatchSenior => 'Chegou ao grupo principal';

  @override
  String get youthWatchReleased => 'Dispensado pela academia';

  @override
  String get youthWatchGone => 'Fora da base';

  @override
  String get tacticsYouth => 'Sub-21';

  @override
  String get pressSquad => 'Elenco';

  @override
  String get pressBoard => 'Direção';

  @override
  String get pressNoEffect => 'Ninguém dá muita importância';

  @override
  String get matchNeutralGround => 'NEUTRO';

  @override
  String get matchExtraTimeAhead => 'PRORROGAÇÃO';

  @override
  String get matchExtraTimeHalf => 'PRORROGAÇÃO · INTERVALO';

  @override
  String get matchClockFullTime => 'FIM DE JOGO';

  @override
  String get matchClockAfterExtraTime => 'APÓS PRORROGAÇÃO';

  @override
  String get matchClockPenalties => 'PÊNALTIS';

  @override
  String get matchClockFullTimePenalties => 'FIM · PÊNALTIS';

  @override
  String get hubEventPressConference => 'Encarar a imprensa';

  @override
  String get hubEventPressConferenceSub =>
      'A imprensa do mundo quer uma palavra antes do seu primeiro jogo';

  @override
  String get squadDevWonderkid => 'PRODÍGIO';

  @override
  String get tacticsPlaystyle => 'Estilo de jogo';

  @override
  String get tacticsPlaystyleBlurb =>
      'Escolha como a seleção joga; os ajustes abaixo refinam o estilo.';

  @override
  String get tacticsPlaystyleCustom =>
      'Suas próprias configurações. Nenhum estilo nomeado corresponde a esses ajustes.';

  @override
  String get playstyleCustom => 'Personalizado';

  @override
  String get playstyleBalanced => 'Equilibrado';

  @override
  String get playstylePossession => 'Posse de bola';

  @override
  String get playstyleGegenpress => 'Gegenpressing';

  @override
  String get playstyleCounter => 'Contra-ataque';

  @override
  String get playstyleDirect => 'Jogo direto';

  @override
  String get playstyleLowBlock => 'Bloco baixo';

  @override
  String get playstyleWingPlay => 'Jogo pelas pontas';

  @override
  String get playstyleBalancedBlurb =>
      'Sólido nos dois lados do campo, sem exageros.';

  @override
  String get playstylePossessionBlurb =>
      'Manter a bola, circular com paciência, apertar o campo.';

  @override
  String get playstyleGegenpressBlurb =>
      'Recuperar a bola assim que é perdida, lá no alto do campo.';

  @override
  String get playstyleCounterBlurb =>
      'Recuar, ficar compacto e sair em velocidade.';

  @override
  String get playstyleDirectBlurb =>
      'Bola cedo à frente e disputa da segunda bola.';

  @override
  String get playstyleLowBlockBlurb =>
      'Fundo, estreito e muito difícil de furar.';

  @override
  String get playstyleWingPlayBlurb =>
      'Abrir o campo, chegar por fora e cruzar.';

  @override
  String get nationsRandomTeam => 'Seleção aleatória';

  @override
  String get nationsFromTheBottom => 'Desde o fundo';

  @override
  String get bottomStartTitle => 'Sem emprego';

  @override
  String get bottomStartHeading => 'Três federações querem conversar';

  @override
  String get bottomStartBlurb =>
      'Você está sem emprego e sem reputação. Estas são as únicas seleções dispostas a apostar em você. Escolha uma e construa algo do zero.';

  @override
  String get bottomStartAccept => 'Aceitar';

  @override
  String get bottomStartBack => 'Voltar ao menu';

  @override
  String bottomStartRankOf(int rank, int total) {
    return '$rankº de $total no mundo';
  }

  @override
  String get campTitle => 'Quartel-general';

  @override
  String campBasedIn(String host) {
    return 'Sediado em $host';
  }

  @override
  String get campBlurb =>
      'Onde o elenco vive durante todo o torneio. Não pode ser mudado depois que a competição começa e influi em três coisas a cada jogo: como chegam descansados, a rapidez com que uma pancada cura e o quanto estão afiados.';

  @override
  String get campEffectTravel => 'Chegar descansados';

  @override
  String get campEffectRecovery => 'Lesões curam';

  @override
  String get campEffectSharpness => 'Ritmo de jogo';

  @override
  String get campTerrainCity => 'Centro da cidade';

  @override
  String get campTerrainCoastal => 'Resort à beira-mar';

  @override
  String get campTerrainMountain => 'Refúgio na montanha';

  @override
  String get campTerrainAltitude => 'Concentração em altitude';

  @override
  String get campTerrainNationalCentre => 'Centro nacional';

  @override
  String get campTerrainCityBlurb =>
      'Tudo à porta e nada para percorrer, mas sem sossego e sem escapar do barulho.';

  @override
  String get campTerrainCoastalBlurb =>
      'Calmo, confortável e bom para o moral; uma longa viagem de ônibus até cada estádio.';

  @override
  String get campTerrainMountainBlurb =>
      'Ar fresco e uma estrutura médica de primeira que recupera pancadas depressa, bem longe do torneio.';

  @override
  String get campTerrainAltitudeBlurb =>
      'Treino duro, mas pernas que aguentam até o fim do torneio.';

  @override
  String get campTerrainNationalCentreBlurb =>
      'As instalações da própria federação: nada espetacular, nada que dê errado.';

  @override
  String get hubEventChooseCamp => 'Escolher o quartel-general';

  @override
  String hubEventChooseCampSub(String host) {
    return 'Onde o elenco ficará em $host';
  }

  @override
  String get tacticsTabBench => 'Banco';

  @override
  String get squadSearchHint => 'Buscar por nome ou clube';

  @override
  String get squadFilterAll => 'Todos';

  @override
  String get squadFilterInSquad => 'No elenco';

  @override
  String get squadFilterUncapped => 'Sem jogos';

  @override
  String get squadFilterUnavailable => 'Indisponíveis';

  @override
  String get squadLineAll => 'Todas as linhas';

  @override
  String get squadSortBy => 'Ordenar';

  @override
  String get squadSortRating => 'Valor';

  @override
  String get squadSortCaps => 'Jogos';

  @override
  String get squadSortGoals => 'Gols';

  @override
  String get squadSortAge => 'Idade';

  @override
  String get squadSortName => 'Nome';

  @override
  String get squadLegendTitle => 'O que significam as marcas';

  @override
  String get squadLegendStarting => 'No seu onze inicial';

  @override
  String get squadLegendCalledUp => 'Convocado, no banco';

  @override
  String get squadLegendRatingUp => 'Valor subindo este ano';

  @override
  String get squadLegendRatingDown => 'Valor caindo este ano';

  @override
  String get squadLegendInjured => 'Lesionado, indisponível';

  @override
  String get squadLegendSuspended => 'Suspenso, indisponível';

  @override
  String get squadLegendTraits => 'CONHECIDO POR';

  @override
  String squadShowingOf(int shown, int total) {
    return 'Mostrando $shown de $total jogadores';
  }

  @override
  String get squadNobodyMatches =>
      'Ninguém no grupo corresponde a esses filtros.';

  @override
  String get squadStatPool => 'Grupo';

  @override
  String get squadStatInSquad => 'Convocados';

  @override
  String get squadMostCapped => 'Mais jogos';

  @override
  String get squadTopScorer => 'Artilheiro';

  @override
  String squadCapsValue(String name, int caps) {
    return '$name · $caps jogos';
  }

  @override
  String squadGoalsValue(String name, int goals) {
    return '$name · $goals gols';
  }

  @override
  String squadAgeClub(int age, String club) {
    return '$age · $club';
  }

  @override
  String get squadCapsShort => 'J.';

  @override
  String get squadGoalsShort => 'Gols';

  @override
  String get recordsRecordBookSubtitle =>
      'Jogos, gols e os principais recordes da seleção';

  @override
  String get statsLegacy => 'LEGADO';

  @override
  String tacticsSubAlreadyOff(String name) {
    return '$name já foi substituído e não pode voltar a entrar.';
  }

  @override
  String tacticsSubSentOff(String name) {
    return '$name foi expulso e não participa mais do jogo.';
  }

  @override
  String get tacticsInjuredShort => 'LESÃO';

  @override
  String get tacticsSuspendedShort => 'SUSPENSO';

  @override
  String get confEurope => 'Europa';

  @override
  String get confSouthAmerica => 'América do Sul';

  @override
  String get confNorthAmerica => 'América do Norte';

  @override
  String get confAfrica => 'África';

  @override
  String get confAsia => 'Ásia';

  @override
  String get confOceania => 'Oceania';

  @override
  String get compWorldCup => 'Campeonato Mundial';

  @override
  String get compWorldCupFinals => 'Fase final do Campeonato Mundial';

  @override
  String get compWorldCupQualifying => 'Eliminatórias do Campeonato Mundial';

  @override
  String compQualifiers(String region) {
    return 'Eliminatórias: $region';
  }

  @override
  String get compFriendlies => 'Amistosos';

  @override
  String get compNationsCup => 'Copa das Nações';

  @override
  String get compContinentalClash => 'Duelo Continental';

  @override
  String get compIntercontinentalPlayoff => 'Play-off intercontinental';

  @override
  String get compContinentalChampionship => 'Campeonato continental';

  @override
  String get compEuropeanChampionship => 'Campeonato Europeu';

  @override
  String get compSouthAmericaCup => 'Copa da América do Sul';

  @override
  String get compAfricanChampionship => 'Copa da África';

  @override
  String get compAsianChampionship => 'Copa da Ásia';

  @override
  String get compNorthAmericaCup => 'Copa da América do Norte';

  @override
  String get compOceaniaCup => 'Copa da Oceania';

  @override
  String get msgANation => 'Uma seleção';

  @override
  String get msgAPlayer => 'Um jogador';

  @override
  String get msgAHostNation => 'um país anfitrião';

  @override
  String get msgCycleTitle1 => 'Começa um novo ciclo';

  @override
  String msgCycleTitle2(int year) {
    return 'O caminho para $year se abre';
  }

  @override
  String get msgCycleTitle3 => 'Uma nova campanha desponta';

  @override
  String get msgCycleTitle4 => 'De volta ao trabalho';

  @override
  String msgCycleBody1(int year) {
    return 'O caminho para o Campeonato Mundial de $year começa aqui.';
  }

  @override
  String msgCycleBody2(int year) {
    return 'Um novo ciclo. O Campeonato Mundial de $year é o alvo.';
  }

  @override
  String msgCycleBody3(int year) {
    return 'Quatro anos até o Campeonato Mundial de $year. O trabalho começa agora.';
  }

  @override
  String msgCycleBody4(int year) {
    return 'A campanha de $year começa hoje.';
  }

  @override
  String msgContHostTitle(String cup, String host) {
    return 'Anfitrião de $cup: $host';
  }

  @override
  String msgContHostBody(String host, String cup) {
    return '$host sediará a próxima edição de $cup.';
  }

  @override
  String msgContQualDrawTitle(String cup) {
    return 'Sorteio das eliminatórias de $cup';
  }

  @override
  String msgContQualDrawBody(String cup) {
    return 'Os grupos das eliminatórias de $cup foram sorteados.';
  }

  @override
  String msgWcHostTitle(String host, int year) {
    return 'Anfitrião do Campeonato Mundial de $year: $host';
  }

  @override
  String msgWcHostBody(String host, int year) {
    return '$host sediará o Campeonato Mundial de $year.';
  }

  @override
  String get msgWcQualDrawTitle =>
      'Sorteio das eliminatórias do Campeonato Mundial';

  @override
  String get msgWcQualDrawBody =>
      'Os grupos das eliminatórias do Campeonato Mundial foram sorteados.';

  @override
  String msgContFinalsDrawTitle(String cup) {
    return 'Sorteio da fase final de $cup';
  }

  @override
  String msgContFinalsDrawBody(String cup) {
    return 'Os grupos da fase final de $cup foram sorteados.';
  }

  @override
  String get msgWcFinalsDrawTitle =>
      'Sorteio da fase final do Campeonato Mundial';

  @override
  String msgWcFinalsDrawBody(int year) {
    return 'O sorteio da fase final do Campeonato Mundial de $year foi realizado.';
  }

  @override
  String get msgQualWcTitle1 => 'Classificados para o Campeonato Mundial';

  @override
  String get msgQualWcTitle2 => 'Vaga no Campeonato Mundial garantida';

  @override
  String get msgQualWcTitle3 => 'Vamos para o Campeonato Mundial';

  @override
  String get msgQualWcTitle4 => 'Passagem carimbada';

  @override
  String msgQualWcBody1(int year) {
    return 'Você se classificou para a fase final do Campeonato Mundial de $year.';
  }

  @override
  String msgQualWcBody2(int year) {
    return 'É oficial: sua seleção está no Campeonato Mundial de $year.';
  }

  @override
  String msgQualWcBody3(int year) {
    return 'Uma vaga no Campeonato Mundial de $year está garantida.';
  }

  @override
  String msgQualWcBody4(int year) {
    return 'Você está na fase final do Campeonato Mundial de $year.';
  }

  @override
  String msgQualContTitle1(String cup) {
    return 'Classificados para $cup';
  }

  @override
  String msgQualContTitle2(String cup) {
    return 'Vaga em $cup garantida';
  }

  @override
  String msgQualContTitle3(String cup) {
    return 'Classificação para $cup';
  }

  @override
  String msgQualContBody1(String cup) {
    return 'Você se classificou para a fase final de $cup.';
  }

  @override
  String msgQualContBody2(String cup) {
    return 'Sua seleção selou a vaga em $cup.';
  }

  @override
  String msgQualContBody3(String cup) {
    return 'Você está em $cup.';
  }

  @override
  String msgChampTitleMine1(String comp) {
    return '$comp: SOMOS CAMPEÕES!';
  }

  @override
  String msgChampTitleMine2(String comp) {
    return '$comp: campeões!';
  }

  @override
  String msgChampTitleMine3(String comp) {
    return 'Você venceu $comp!';
  }

  @override
  String msgChampTitleOther1(String comp) {
    return '$comp: decisão encerrada';
  }

  @override
  String msgChampTitleOther2(String comp) {
    return '$comp: campeão coroado';
  }

  @override
  String msgChampTitleOther3(String comp) {
    return '$comp tem novo campeão';
  }

  @override
  String msgChampBodyMine1(String comp, String loser, String result, int year) {
    return '$comp $year: sua seleção é campeã, depois de vencer $loser$result.';
  }

  @override
  String msgChampBodyMine2(String comp, String loser, String result, int year) {
    return 'Você conquistou $comp $year, superando $loser$result.';
  }

  @override
  String msgChampBodyMine3(String comp, String loser, String result, int year) {
    return '$comp $year é seu. Vitória sobre $loser$result.';
  }

  @override
  String msgChampBodyOther1(
    String winner,
    String comp,
    String loser,
    String result,
    int year,
  ) {
    return '$winner conquistou $comp $year, vencendo $loser$result.';
  }

  @override
  String msgChampBodyOther2(
    String winner,
    String comp,
    String loser,
    String result,
    int year,
  ) {
    return '$comp $year: título para $winner, que derrotou $loser$result.';
  }

  @override
  String msgFinalScoreSuffix(int home, int away) {
    return ' por $home–$away na final';
  }

  @override
  String msgFinalPensSuffix(int home, int away) {
    return ' nos pênaltis, após um $home–$away na final';
  }

  @override
  String get msgWpotyTitle => 'Melhor Jogador do Mundo';

  @override
  String msgWpotyBodyMine(String name, String nation, int year) {
    return '$name ($nation) é eleito Melhor Jogador do Mundo de $year, um dos seus.';
  }

  @override
  String msgWpotyBodyOther(String name, String nation, int year) {
    return '$name ($nation) é eleito Melhor Jogador do Mundo de $year.';
  }

  @override
  String get msgYpotTitle => 'Jovem Jogador do Torneio';

  @override
  String msgYpotBodyMine(String name, String nation, int age, int year) {
    return '$name ($nation), de $age anos, é eleito Jovem Jogador do Torneio de $year, um dos seus.';
  }

  @override
  String msgYpotBodyOther(String name, String nation, int age, int year) {
    return '$name ($nation), de $age anos, é eleito Jovem Jogador do Torneio de $year.';
  }

  @override
  String msgRankHold1(int rank) {
    return 'Você se mantém em #$rank.';
  }

  @override
  String msgRankHold2(int rank) {
    return 'Sem mudança, ainda #$rank.';
  }

  @override
  String msgRankHold3(int rank) {
    return 'Estável em #$rank.';
  }

  @override
  String msgRankUp1(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move posições',
      one: '1 posição',
    );
    return 'Subida de $_temp0 no total, para #$rank.';
  }

  @override
  String msgRankUp2(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move posições',
      one: '1 posição',
    );
    return 'Uma escalada de $_temp0 leva você a #$rank.';
  }

  @override
  String msgRankUp3(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move posições',
      one: '1 posição',
    );
    return 'Sobe $_temp0, agora #$rank.';
  }

  @override
  String msgRankDown1(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move posições',
      one: '1 posição',
    );
    return 'Queda de $_temp0 no total, para #$rank.';
  }

  @override
  String msgRankDown2(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move posições',
      one: '1 posição',
    );
    return 'Um tombo de $_temp0 derruba você para #$rank.';
  }

  @override
  String msgRankDown3(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move posições',
      one: '1 posição',
    );
    return 'Cai $_temp0, agora #$rank.';
  }

  @override
  String get msgRankLeadYou => 'Você lidera o mundo.';

  @override
  String msgRankLeadOther(String nation) {
    return '$nation lidera o mundo.';
  }

  @override
  String msgRankTitle(int rank) {
    return 'Ranking mundial · #$rank';
  }

  @override
  String msgRankBody(String lead, String movement) {
    return 'O ranking mundial foi atualizado. $lead $movement';
  }

  @override
  String msgRankJumpTitleUp(int rank) {
    return 'Subida para #$rank';
  }

  @override
  String msgRankJumpTitleDown(int rank) {
    return 'Queda para #$rank';
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
      other: '$move posições',
      one: '1 posição',
    );
    return '$tournament mexeu no ranking mundial. $nation entrou em #$from e saiu em #$to, uma subida de $_temp0.';
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
      other: '$move posições',
      one: '1 posição',
    );
    return '$tournament mexeu no ranking mundial. $nation entrou em #$from e saiu em #$to, uma queda de $_temp0.';
  }

  @override
  String get rankingSinceWcDraw => 'Desde o sorteio do Campeonato Mundial';

  @override
  String get rankingSinceCycleStart => 'Desde o início da campanha';

  @override
  String rankingMovedFromTo(int from, int now) {
    return '#$from para #$now';
  }

  @override
  String msgCapsTitle(String name, int count) {
    return '$name chega a $count jogos pela seleção';
  }

  @override
  String msgCapsBody(String name, int count) {
    return '$name já fez $count jogos pela sua seleção.';
  }

  @override
  String msgGoalsTitle(String name, int count) {
    return '$name chega a $count gols';
  }

  @override
  String msgGoalsBody(String name, int count) {
    return '$name marcou $count gols internacionais pela sua seleção.';
  }

  @override
  String msgDevTitle(int year) {
    return 'Evolução do elenco · $year';
  }

  @override
  String msgThroughTitle(int year) {
    return 'Vindos da academia · $year';
  }

  @override
  String get msgThroughNote =>
      'Não é uma nova leva. São os garotos que entraram aos onze anos e agora cresceram até o grupo principal.';

  @override
  String msgNewFacesTitle(int year) {
    return 'Caras novas · $year';
  }

  @override
  String get msgIntakeNoteAcademy =>
      'O investimento na academia aparece: esta leva chegou mais forte do que chegaria sem ele.';

  @override
  String get msgIntakeNoteStanding =>
      'O país está de olho nesta seleção: com a seleção subindo no ranking mundial, os melhores garotos escolhem o futebol, e esta leva chegou mais forte por isso.';

  @override
  String get msgIntakeNoteBoth =>
      'O dinheiro da academia e a subida da seleção no ranking mundial aparecem: esta leva chegou mais forte do que chegaria sem eles.';

  @override
  String msgIntakeTitle(int year) {
    return 'Leva da academia · $year';
  }

  @override
  String msgRetireCaptainTitle(String name) {
    return 'Seu capitão $name se aposenta';
  }

  @override
  String msgRetireTitle(String name) {
    return '$name se despede da seleção';
  }

  @override
  String msgRetireBody(String name, int age) {
    return '$name encerrou a carreira na seleção aos $age anos.';
  }

  @override
  String msgRetireBodyWith(String name, String tally, int age) {
    return '$name encerrou a carreira na seleção aos $age anos, saindo com $tally.';
  }

  @override
  String msgTallyCaps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jogos',
      one: '1 jogo',
    );
    return '$_temp0';
  }

  @override
  String msgTallyGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gols',
      one: '1 gol',
    );
    return '$_temp0';
  }

  @override
  String get msgArmbandVacant =>
      ' A braçadeira está vaga. Escolha um novo capitão na convocatória.';

  @override
  String msgHofTitle(String name) {
    return '$name entra para a Galeria da Fama';
  }

  @override
  String msgHofBody(String name, int caps, int goals) {
    return '$name entra para a Galeria da Fama da sua seleção ($caps jogos, $goals gols). Veja em Lendas.';
  }

  @override
  String hubBanTitle(String name) {
    return '$name suspenso';
  }

  @override
  String hubBanBody(String name, String how, int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: 'os próximos $matches jogos',
      one: 'o próximo jogo',
    );
    return '$name $how e está suspenso por $_temp0. Fica indisponível para escalação.';
  }

  @override
  String get hubBanHowSecondYellow =>
      'foi expulso por um segundo cartão amarelo';

  @override
  String get hubBanHowViolent =>
      'recebeu cartão vermelho direto por conduta violenta';

  @override
  String get hubBanHowRed => 'foi expulso';

  @override
  String hubInjuryTitle(String name) {
    return '$name lesionado';
  }

  @override
  String hubInjuryBody(String name, int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: '$matches jogos',
      one: '1 jogo',
    );
    return '$name sofreu uma pancada e fica fora por $_temp0.';
  }

  @override
  String get hubRunnerUpTitle1 => 'Vice-campeões';

  @override
  String get hubRunnerUpTitle2 => 'Tão perto, tão longe';

  @override
  String get hubRunnerUpTitle3 => 'Medalha de prata';

  @override
  String hubRunnerUpBody1(String cup, String opponent) {
    return 'Você chegou à final de $cup, mas perdeu para $opponent. Foi por pouco. Prata desta vez.';
  }

  @override
  String hubRunnerUpBody2(String cup, String opponent) {
    return 'Derrota para $opponent na final de $cup. Vice-campeões, a um passo do título.';
  }

  @override
  String hubRunnerUpBody3(String cup, String opponent) {
    return 'A final de $cup escapou contra $opponent. Muito para se orgulhar, mas sem o troféu.';
  }

  @override
  String get hubKnockedOutTitle1 => 'Eliminados';

  @override
  String get hubKnockedOutTitle2 => 'Fim da linha';

  @override
  String get hubKnockedOutTitle3 => 'Jornada encerrada';

  @override
  String hubKnockedOutBody1(String cup, String opponent, String stage) {
    return 'Você está fora de $cup, derrotado por $opponent em: $stage.';
  }

  @override
  String hubKnockedOutBody2(String cup, String opponent, String stage) {
    return '$opponent encerra sua participação em $cup. Fase: $stage.';
  }

  @override
  String hubKnockedOutBody3(String cup, String opponent, String stage) {
    return 'Sua campanha em $cup termina em $stage, derrotado por $opponent.';
  }

  @override
  String get hubGroupExitTitle1 => 'Queda na fase de grupos';

  @override
  String get hubGroupExitTitle2 => 'Fora na fase de grupos';

  @override
  String get hubGroupExitTitle3 => 'Chuveiro mais cedo';

  @override
  String hubGroupExitBody1(String cup) {
    return 'Sua campanha em $cup acaba na fase de grupos. Não foi o bastante para chegar ao mata-mata.';
  }

  @override
  String hubGroupExitBody2(String cup) {
    return 'Você não conseguiu sair do grupo. Sua campanha em $cup termina aqui.';
  }

  @override
  String hubGroupExitBody3(String cup) {
    return 'Sem vaga no mata-mata desta vez. Sua campanha em $cup terminou na fase de grupos.';
  }

  @override
  String boardObjectiveMetTitle(String comp) {
    return 'Objetivo cumprido: $comp';
  }

  @override
  String boardObjectiveMissedTitle(String comp) {
    return 'Objetivo não cumprido: $comp';
  }

  @override
  String boardObjectiveMetBody(String comp, String demand, String finish) {
    return 'A meta da direção em $comp: $demand. Você terminou assim: $finish. Eles têm o que pediram.';
  }

  @override
  String boardObjectiveMissedBody(String comp, String demand, String finish) {
    return 'A meta da direção em $comp: $demand. Você terminou assim: $finish. Ficou abaixo do esperado.';
  }

  @override
  String get newsWcMissTitle => 'Sonho do Campeonato Mundial acabou';

  @override
  String newsWcMissBody(int year) {
    return 'Você ficou fora do Campeonato Mundial de $year. A campanha nas eliminatórias não foi suficiente. Mais quatro anos de espera.';
  }

  @override
  String get newsRecordScorerTitle => 'Maior artilheiro de todos os tempos';

  @override
  String newsRecordScorerBody(String name, int goals) {
    return '$name é agora o maior artilheiro da história do jogo, com $goals gols.';
  }

  @override
  String get newsRecordCapsTitle => 'Jogador com mais jogos pela seleção';

  @override
  String newsRecordCapsBody(String name, int caps) {
    return '$name é agora o jogador com mais jogos pela seleção na história do jogo, com $caps partidas.';
  }

  @override
  String get newsARecordBreaker => 'Um novo recordista';

  @override
  String newsTransferTitle(String name, String club) {
    return '$name reforça $club';
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
    return '$name ($position, $rating) deixou $fromClub e assinou com $destination por $fee.';
  }

  @override
  String newsTransferAbroad(String club, String country) {
    return '$club, em $country';
  }

  @override
  String get newsTransferFree => 'Grátis';

  @override
  String newsNatzStarTitle(String name, String nation) {
    return '$name mudaria para $nation!';
  }

  @override
  String newsNatzTitle(String name, String nation) {
    return '$name quer jogar por $nation';
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
    return '$name, $position de $age anos e classificação $rating, atualmente por $fromNation, tem laços familiares com $nation e está aberto a mudar de seleção. Abra a oferta de naturalização para aceitar ou recusar.';
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
    return '$name, $position de $age anos e classificação $rating, atualmente por $fromNation, é um grande nome com laços familiares com $nation e está aberto a mudar de seleção. Abra a oferta de naturalização para aceitar ou recusar.';
  }

  @override
  String get newsTheirNation => 'a seleção dele';

  @override
  String get newsYourNation => 'sua seleção';

  @override
  String get tourStatusChampions => 'CAMPEÕES';

  @override
  String get tourStatusFinals => 'FASE FINAL';

  @override
  String get tourStatusQualifying => 'ELIMINATÓRIAS';

  @override
  String get tourStatusUpcoming => 'EM BREVE';

  @override
  String get tourStatusInProgress => 'EM CURSO';

  @override
  String get tourStatusComingSoon => 'EM BREVE';

  @override
  String get tourStatusDecided => 'DECIDIDO';

  @override
  String tourStatusLeague(String letter) {
    return 'LIGA $letter';
  }

  @override
  String get tourDrawWcQualifying => 'SORTEIO ELIMINATÓRIAS MUNDIAIS';

  @override
  String tourDrawContQualifying(String cup) {
    return 'SORTEIO DAS ELIMINATÓRIAS $cup';
  }

  @override
  String get tourDrawWcHost => 'ANFITRIÃO DO CAMPEONATO MUNDIAL';

  @override
  String tourDrawContHost(String cup) {
    return 'ANFITRIÃO $cup';
  }

  @override
  String get tourDrawHostsReveal => 'E os anfitriões serão…';

  @override
  String get tourDrawHostReveal => 'E o anfitrião será…';

  @override
  String get tourDrawHostCandidates => 'Os candidatos na disputa:';

  @override
  String get tourKickoffContinentalCup => 'COPA CONTINENTAL';

  @override
  String tourHostCompetitionYear(String competition, int year) {
    return '$competition $year';
  }

  @override
  String newsContMissTitle(String cup) {
    return '$cup: fora da disputa';
  }

  @override
  String newsContMissBody(String cup) {
    return 'Você não se classificou para $cup. A campanha ficou aquém desta vez.';
  }

  @override
  String get potyLabelBest => 'Jogador do Ano';

  @override
  String get potyLabelYoung => 'Jovem Jogador do Ano';

  @override
  String potyTallyAssists(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count assistências',
      one: '$count assistência',
    );
    return '$_temp0';
  }

  @override
  String potyOverallValue(int value) {
    return 'Classificação $value';
  }

  @override
  String potyRatingValue(String value) {
    return 'Nota $value';
  }

  @override
  String newsPotyTitle(int year) {
    return 'Melhor Jogador do Mundo $year';
  }

  @override
  String newsPotyBody(String name) {
    return '$name é o melhor jogador do mundo neste ano.';
  }

  @override
  String newsPotyYoungSuffix(String name) {
    return ' $name leva o prêmio de jovem jogador.';
  }

  @override
  String newsWatchTitle(int year) {
    return 'Os garotos que você acompanha, $year';
  }

  @override
  String newsWatchJump(String name, int rating, int gain) {
    String _temp0 = intl.Intl.pluralLogic(
      gain,
      locale: localeName,
      other: '$gain pontos',
      one: 'um ponto',
    );
    return '$name deu um salto e chegou a $rating, $_temp0 a mais que no ano passado.';
  }

  @override
  String newsWatchBand(String name, String band) {
    return '$name sobe para a categoria $band.';
  }

  @override
  String newsWatchDebutTitle(String name) {
    return '$name estreia';
  }

  @override
  String newsWatchDebutBody(String name, int age, int rating) {
    return '$name fez seu primeiro jogo pela seleção aos $age anos, com classificação $rating. Um dos garotos que você acompanha.';
  }

  @override
  String get matchStatsAtFullTime =>
      'Posse de bola, notas dos jogadores e melhor em campo só são definidos no apito final.';

  @override
  String get matchPlayerRatings => 'NOTAS DOS JOGADORES';

  @override
  String get matchSubstitutions => 'SUBSTITUIÇÕES';

  @override
  String get matchSubstitutes => 'RESERVAS';

  @override
  String get matchPlayerOfTheMatch => 'MELHOR EM CAMPO';

  @override
  String get matchGoalShout => 'GOL!';

  @override
  String matchShootoutScore(int home, int away) {
    return 'PÊNALTIS $home–$away';
  }

  @override
  String matchShootoutKickScored(String name) {
    return '$name: MARCOU';
  }

  @override
  String matchShootoutKickMissed(String name) {
    return '$name: PERDEU';
  }

  @override
  String get matchFeedKickOff => 'Bola rolando!';

  @override
  String get matchFeedNoEvents => 'Ainda sem lances.';

  @override
  String get tourVenues => 'ESTÁDIOS';

  @override
  String tourPot(int number) {
    return 'POTE $number';
  }

  @override
  String get tourHostSelection => 'ESCOLHA DO ANFITRIÃO';

  @override
  String get tourCandidates => 'CANDIDATOS';

  @override
  String get tourJointBid => 'CANDIDATURA CONJUNTA';

  @override
  String get tourGoldenGlove => 'LUVA DE OURO';

  @override
  String get tourTeamOfTournament => 'SELEÇÃO DO TORNEIO';

  @override
  String get tourYourRun => 'SEU PERCURSO';

  @override
  String get tourMedalTable => 'QUADRO DE MEDALHAS';

  @override
  String tourHostLine(String nation) {
    return 'Anfitrião: $nation';
  }

  @override
  String tourHostLineMulti(String hosts) {
    return 'Anfitriões: $hosts';
  }

  @override
  String tourGroupNamed(String name) {
    return 'Grupo $name';
  }

  @override
  String get tourFinalsDrawBlurb =>
      'Cabeças de série pelo ranking mundial. Encontre sua seleção antes do sorteio.';

  @override
  String get tourWorldRanking => 'Ranking mundial';

  @override
  String get tourYourCompetitions => 'SUAS COMPETIÇÕES';

  @override
  String get tourOtherContinents => 'OUTROS CONTINENTES';

  @override
  String get tourZoneGlobal => 'GLOBAL';

  @override
  String get tourZoneEurope => 'EUROPA';

  @override
  String get tourZoneSouthAmerica => 'AM. DO SUL';

  @override
  String get tourZoneNorthAmerica => 'AM. DO NORTE';

  @override
  String get tourZoneAfrica => 'ÁFRICA';

  @override
  String get tourZoneAsia => 'ÁSIA';

  @override
  String get tourZoneOceania => 'OCEANIA';

  @override
  String get tourZoneIntercontinental => 'INTERCONTINENTAL';

  @override
  String tourZoneLeague(String league) {
    return 'LIGA $league';
  }

  @override
  String tourHostedBy(String hosts) {
    return 'ANFITRIÃO  $hosts';
  }

  @override
  String tourThirdsAdvance(int count, String destination) {
    return 'Os $count melhores avançam para $destination';
  }

  @override
  String newsWalkoutTitle(String name) {
    return '$name vai embora';
  }

  @override
  String newsWalkoutBody(String name, int age, int caps) {
    return '$name se aposentou da seleção aos $age anos, com $caps jogos pela seleção. Pediu para saber qual era sua posição, não teve resposta e não quer esperar mais.';
  }

  @override
  String get pressHeadlineWent1 => 'Um treinador no comando da sala';

  @override
  String get pressHeadlineWent2 =>
      'Vieram atrás de briga e encontraram um líder';

  @override
  String get pressHeadlineWent3 =>
      'Respostas diretas, e que acertaram em cheio';

  @override
  String get pressHeadlineMixed1 => 'Muito dito, pouco resolvido';

  @override
  String get pressHeadlineMixed2 => 'Algo para todos, e nada para ninguém';

  @override
  String get pressHeadlineMixed3 =>
      'Uma conferência que deixou as perguntas em aberto';

  @override
  String get pressHeadlineBadly1 => 'Uma tarde dura diante das câmeras';

  @override
  String get pressHeadlineBadly2 => 'A sala virou, e isso ficou claro';

  @override
  String get pressHeadlineBadly3 => 'Respostas que vão soar piores amanhã';

  @override
  String get pressHeadlineFlat1 => 'Nada dito, nada ganho';

  @override
  String get pressHeadlineFlat2 => 'Dez minutos, nenhuma notícia';

  @override
  String get pressHeadlineFlat3 => 'Uma página em branco para a contracapa';

  @override
  String get pressConferenceTitle => 'CONFERÊNCIA DE IMPRENSA';

  @override
  String pressQuestionOf(int index, int total) {
    return 'Pergunta $index de $total';
  }

  @override
  String get pressTomorrowsHeadline => 'CONTRACAPA DE AMANHÃ';

  @override
  String get pressLeaveRoom => 'SAIR DA SALA';

  @override
  String get pressRoomVerdictSquad => 'Vestiário';

  @override
  String get pressRoomVerdictBoard => 'Direção';

  @override
  String get yReactionElation0 => 'sem ressalvas. nenhuma. perfeito.';

  @override
  String get yReactionElation1 => 'Passei mal (de felicidade).';

  @override
  String get yReactionElation2 => 'vou emoldurar isso. em cima da lareira.';

  @override
  String get yReactionElation3 => 'voltamos com tudo';

  @override
  String get yReactionElation4 =>
      'Salvando print disso para os descrentes. Todos eles.';

  @override
  String get yReactionElation5 =>
      'Vou ficar insuportável com isso por uma década.';

  @override
  String get yReactionElation6 => 'Pronto. É por isso que a gente assiste.';

  @override
  String get yReactionElation7 => 'Dias assim compensam todos os outros.';

  @override
  String get yReactionElation8 => 'Já era hora. De verdade, já era hora.';

  @override
  String get yReactionElation9 =>
      'Ótimo. Agora faz de novo semana que vem e eu acredito.';

  @override
  String get yReactionElation10 =>
      'Aproveite hoje, porque essa turma vai dar um jeito de estragar.';

  @override
  String get yReactionElation11 =>
      'Uma noite boa não faz de ninguém uma grande seleção.';

  @override
  String get yReactionRelief0 => 'Não foi bonito, mas eu aceito sempre.';

  @override
  String get yReactionRelief1 => 'Sei lá como. Sei lá como!';

  @override
  String get yReactionRelief2 => 'Feio. Três pontos. Seguimos.';

  @override
  String get yReactionRelief3 =>
      'Aceito feio o dia inteiro se vier com pontos.';

  @override
  String get yReactionRelief4 => 'isso me tirou dez anos de vida';

  @override
  String get yReactionRelief5 => 'Ninguém fala nada. Ninguém dá azar.';

  @override
  String get yReactionRelief6 => 'Batimentos: inaceitáveis.';

  @override
  String get yReactionRelief7 =>
      'Sobrevivemos. É essa a palavra. Sobrevivemos.';

  @override
  String get yReactionRelief8 =>
      'A gente não devia precisar de alívio em jogos assim.';

  @override
  String get yReactionRelief9 =>
      'Aliviado, e um pouco envergonhado por estar aliviado.';

  @override
  String get yReactionRelief10 =>
      'Se esse é o padrão que comemoramos, estamos mal.';

  @override
  String get yReactionRelief11 =>
      'Passar raspando virou hábito, e não é um bom hábito.';

  @override
  String get yReactionFury0 => 'Não é suficiente. Nem de longe.';

  @override
  String get yReactionFury1 => 'Alguém me explica isso devagar.';

  @override
  String get yReactionFury2 =>
      'Foi difícil de assistir e eu estou sendo educado.';

  @override
  String get yReactionFury3 => 'Decepcionado. Decepcionado de verdade.';

  @override
  String get yReactionFury4 => 'Que vexame absoluto.';

  @override
  String get yReactionFury5 => 'Quero nomes.';

  @override
  String get yReactionFury6 => 'Apagando o app. Reinstalo na quinta.';

  @override
  String get yReactionFury7 => 'Ninguém ali parecia querer aquilo.';

  @override
  String get yReactionFury8 =>
      'A cada quatro anos, igual. TODO ciclo de quatro anos.';

  @override
  String get yReactionFury9 => 'Isso não é uma atuação, é um insulto.';

  @override
  String get yReactionFury10 =>
      'As pessoas abrem mão de fins de semana e de dinheiro por isso. Pensem nisso.';

  @override
  String get yReactionFury11 =>
      'Defendo esta seleção há anos. Esta noite não. Não depois disso.';

  @override
  String get yReactionDespair0 => 'bem.';

  @override
  String get yReactionDespair1 => 'Sem piadas hoje. Nada.';

  @override
  String get yReactionDespair2 => 'Vou dar uma volta. Uma bem longa.';

  @override
  String get yReactionDespair3 => 'Já esgotei as formas de dizer isso.';

  @override
  String get yReactionDespair4 => 'Me acordem daqui a quatro anos.';

  @override
  String get yReactionDespair5 => 'essa é a pior linha do tempo';

  @override
  String get yReactionDespair6 =>
      'Nem raiva eu sinto mais. Isso é que é preocupante.';

  @override
  String get yReactionDespair7 => 'Essa vai doer por muito tempo.';

  @override
  String get yReactionDespair8 =>
      'Já não sei o que é isso, mas não é uma seleção de futebol.';

  @override
  String get yReactionDespair9 =>
      'Estamos mais longe do que antes, e ninguém diz.';

  @override
  String get yReactionDespair10 =>
      'Uma geração inteira desperdiçada e as mesmas pessoas decidem o que vem depois.';

  @override
  String get yReactionDespair11 =>
      'Parem de dizer que é um processo. Não está indo a lugar nenhum.';

  @override
  String get yReactionSmugness0 => 'Baixinho, mas: eu avisei.';

  @override
  String get yReactionSmugness1 => 'guarda esse aqui';

  @override
  String get yReactionSmugness2 => 'Os descrentes ficaram bem quietinhos.';

  @override
  String get yReactionSmugness3 =>
      'Não que alguém esteja contando. Eu estou contando.';

  @override
  String get yReactionSmugness4 => 'Falei em janeiro. Vejam a timeline.';

  @override
  String get yReactionSmugness5 =>
      'Alguns de vocês devem desculpas a alguns de nós.';

  @override
  String get yReactionSmugness6 =>
      'Arquivando isso em coisas que eu falei primeiro.';

  @override
  String get yReactionSmugness7 => 'Sem tirar sarro. Só um pouquinho.';

  @override
  String get yReactionSmugness8 =>
      'Cadê todos os especialistas agora? Pergunta sincera.';

  @override
  String get yReactionSmugness9 =>
      'Quero que cada um de vocês repita isso para mim.';

  @override
  String get yReactionSmugness10 =>
      'Print, impresso, emoldurado, enviado para quem riu.';

  @override
  String get yReactionSmugness11 =>
      'Vou lembrar disso pelo resto da vida e vocês merecem.';

  @override
  String get yReactionShrug0 => 'aconteceu. próximo.';

  @override
  String get yReactionShrug1 => 'Tá. Tanto faz. Em frente.';

  @override
  String get yReactionShrug2 => 'Arquivando em \"futebol\".';

  @override
  String get yReactionShrug3 => 'Sinceramente, nada a acrescentar.';

  @override
  String get yReactionShrug4 => 'sem opinião, cabeça vazia';

  @override
  String get yReactionShrug5 => 'Me chamem no próximo.';

  @override
  String get yReactionShrug6 => 'Foram noventa minutos que não voltam mais.';

  @override
  String get yReactionShrug7 => 'Nem lá nem cá, na verdade.';

  @override
  String get yReactionShrug8 =>
      'Não saberia dizer uma única coisa que aconteceu.';

  @override
  String get yReactionShrug9 => 'Mais um desses. Tem muitos desses.';

  @override
  String get yReactionShrug10 => 'Vi tudo e não senti absolutamente nada.';

  @override
  String get yReactionShrug11 =>
      'Se ninguém mencionar isso de novo, por mim tudo bem.';

  @override
  String get tourThirdsUneven =>
      'Os grupos são desiguais, então os resultados contra o último colocado de cada grupo maior são descartados e todas as seleções são avaliadas nos mesmos jogos.';

  @override
  String get careerExportSave => 'Fazer cópia desta gravação';

  @override
  String get careerBackupAll => 'COPIAR TODAS AS GRAVAÇÕES';

  @override
  String get careerBackupAllFailed =>
      'Não foi possível gerar a cópia de segurança.';

  @override
  String get backupTitle => 'CÓPIAS DE SEGURANÇA';

  @override
  String get backupBlurb =>
      'Todos os jogos salvos ficam em um só arquivo neste telefone, e nada faz cópia deles sozinho, a não ser que você ative a cópia automática abaixo. Guarde uma cópia na nuvem para que um telefone perdido ou um app apagado não custem uma carreira.';

  @override
  String get backupBlurbNoAuto =>
      'Todos os jogos salvos ficam em um só arquivo neste telefone, e nada faz cópia deles sozinho. Guarde uma cópia na nuvem para que um telefone perdido ou um app apagado não custem uma carreira.';

  @override
  String get backupExport => 'CÓPIA NA NUVEM';

  @override
  String get backupExportSubject => 'Gravações do FNM';

  @override
  String get backupRestore => 'RESTAURAR DE UM ARQUIVO';

  @override
  String get backupRestoreWarnTitle => 'Substituir todas as gravações?';

  @override
  String get backupRestoreWarnBody =>
      'Restaurar substitui todas as gravações deste aparelho pelas do arquivo. O app será reiniciado.';

  @override
  String get backupRestoreConfirm => 'SUBSTITUIR';

  @override
  String get backupCancel => 'CANCELAR';

  @override
  String get backupExported => 'Cópia pronta. Escolha onde guardá-la.';

  @override
  String get backupFailed => 'Não foi possível gerar a cópia de segurança.';

  @override
  String get backupRejectedUnreadable => 'Não foi possível abrir esse arquivo.';

  @override
  String get backupRejectedNotFnm => 'Isso não é uma gravação do FNM.';

  @override
  String get backupRejectedNewer =>
      'Essa gravação foi feita por uma versão mais nova do app. Atualize primeiro.';

  @override
  String get backupRejectedTooOld =>
      'Essa gravação é antiga demais para ser restaurada por esta versão.';

  @override
  String get careerShare => 'Compartilhar esta carreira';

  @override
  String get careerImport => 'IMPORTAR UMA CARREIRA';

  @override
  String get careerShareSubject => 'Uma carreira do FNM';

  @override
  String get careerImported => 'Carreira importada.';

  @override
  String get careerImportFailedUnreadable =>
      'Esse arquivo não é uma carreira do FNM.';

  @override
  String get careerImportFailedNewer =>
      'Essa carreira foi exportada por uma versão mais nova do app. Atualize primeiro.';

  @override
  String get careerImportFailedSlotsFull =>
      'Todos os seus espaços de gravação estão ocupados. Elimine uma gravação para abrir espaço ou desbloqueie gravações ilimitadas.';

  @override
  String get careerImportFailedNeedsPremium =>
      'Essa carreira passou do primeiro ciclo gratuito. Desbloqueie o jogo completo para importá-la.';

  @override
  String get careerImportFailedCampaignRun =>
      'Essa campanha já tem um percurso em andamento. Retome-o ou abandone-o primeiro.';

  @override
  String get careerShareFailed => 'Não foi possível exportar essa carreira.';

  @override
  String get managerRename => 'Mudar nome';

  @override
  String get managerRenameSave => 'Salvar';

  @override
  String get managerTitle => 'TREINADOR';

  @override
  String get managerSkills => 'SUAS HABILIDADES';

  @override
  String managerPointsAvailable(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pontos para gastar',
      one: '1 ponto para gastar',
      zero: 'Nenhum ponto para gastar',
    );
    return '$_temp0';
  }

  @override
  String get managerPointsHow =>
      'Dois pontos por cada ciclo concluído, um por cada troféu conquistado.';

  @override
  String get managerSkillsScale =>
      'Toda habilidade começa em 5 e vai até 20. Um ponto gasto é permanente.';

  @override
  String get managerSkillManManagement => 'Gestão de grupo';

  @override
  String get managerSkillManManagementBlurb =>
      'Cada ponto faz o que você diz à imprensa e aos jogadores pesar 3% mais no vestiário.';

  @override
  String get managerSkillTactical => 'Tática';

  @override
  String get managerSkillTacticalBlurb =>
      'Cada ponto faz um novo sistema tático ser assimilado 3% mais rápido, e mudar de sistema custa menos jogos.';

  @override
  String get managerSkillYouth => 'Desenvolvimento de jovens';

  @override
  String get managerSkillYouthBlurb =>
      'Cada ponto soma 1% ao talento que sai da sua academia, além do que você investe nela.';

  @override
  String get managerSkillNegotiation => 'Negociação';

  @override
  String get managerSkillNegotiationBlurb =>
      'Cada ponto rende 2% mais dinheiro da federação, a cada ciclo.';

  @override
  String get managerStaff => 'SUA COMISSÃO TÉCNICA';

  @override
  String managerStaffWages(String amount) {
    return 'Salários: $amount por ciclo';
  }

  @override
  String get managerRoleAssistant => 'Treinador adjunto';

  @override
  String get managerRoleAssistantBlurb =>
      'Comanda os treinos: menos lesões e jovens melhores surgindo.';

  @override
  String get managerRoleScout => 'Olheiro-chefe';

  @override
  String get managerRoleScoutBlurb =>
      'Avalia suas promessas e o próximo adversário: notas de estrela mais fiéis e uma vantagem no dia do jogo.';

  @override
  String get managerRoleFitness => 'Preparador físico';

  @override
  String get managerRoleFitnessBlurb => 'Mantém todos em campo.';

  @override
  String staffEffectInjury(int percent) {
    return '$percent% menos lesões';
  }

  @override
  String staffEffectYouth(int points) {
    return 'Jovens +$points de valor global';
  }

  @override
  String staffHiringInjury(int min, int max) {
    return 'Contratar um: de $min% a $max% menos lesões';
  }

  @override
  String staffHiringYouth(int minPoints, int maxPoints) {
    return 'e jovens com +$minPoints a +$maxPoints de valor global';
  }

  @override
  String staffEffectScoutRead(int percent) {
    return 'Lê $percent% das promessas com exatidão';
  }

  @override
  String staffEffectScoutCaps(int caps) {
    String _temp0 = intl.Intl.pluralLogic(
      caps,
      locale: localeName,
      other: 'Potencial conhecido após $caps jogos pela seleção',
      one: 'Potencial conhecido após 1 jogo pela seleção',
    );
    return '$_temp0';
  }

  @override
  String staffEffectScoutDossier(int points) {
    return '+$points de classificação pelos relatórios de adversários';
  }

  @override
  String staffHiringScoutRead(int min, int max) {
    return 'Contratar um: de $min% a $max% das leituras exatas';
  }

  @override
  String staffHiringScoutCaps(int minCaps, int maxCaps) {
    return 'e potencial conhecido $minCaps a $maxCaps jogos mais cedo';
  }

  @override
  String staffHiringScoutDossier(int minPoints, int maxPoints) {
    return 'e +$minPoints a +$maxPoints de classificação em cada jogo';
  }

  @override
  String get staffEffectNone => 'Ainda sem efeito no seu elenco';

  @override
  String get staffVacant => 'Ninguém no cargo';

  @override
  String get staffLeaveVacant => 'Deixar o cargo vago';

  @override
  String get managerTierNone => 'Nenhum';

  @override
  String get managerTierBasic => 'Básico';

  @override
  String get managerTierGood => 'Bom';

  @override
  String get managerTierElite => 'Elite';

  @override
  String get managerFree => 'grátis';

  @override
  String get managerTraining => 'ENTRE JANELAS';

  @override
  String get managerTrainingBlurb =>
      'No que o elenco trabalha quando não há jogo.';

  @override
  String get managerFocusBalanced => 'Equilibrado';

  @override
  String get managerFocusBalancedBlurb => 'Um pouco de tudo.';

  @override
  String get managerFocusFitness => 'Físico';

  @override
  String get managerFocusFitnessBlurb => 'Menos pancadas.';

  @override
  String get managerFocusCohesion => 'Entrosamento';

  @override
  String get managerFocusCohesionBlurb => 'O sistema é assimilado mais rápido.';

  @override
  String get managerFocusYouth => 'Jovens';

  @override
  String get managerFocusYouthBlurb => 'Horas com os mais novos do grupo.';

  @override
  String get tourOfferTitle => 'Primeira vez aqui?';

  @override
  String get tourOfferBody =>
      'Este é um jogo grande. Quer um passeio rápido pelas páginas que importam? Leva um minuto, e você pode recomeçar quando quiser nas configurações.';

  @override
  String get tourOfferYes => 'Mostre-me tudo';

  @override
  String get tourOfferNo => 'Não, obrigado';

  @override
  String get tourBack => 'Voltar';

  @override
  String get tourNext => 'Avançar';

  @override
  String get tourDone => 'Pronto';

  @override
  String get tourSkip => 'Pular';

  @override
  String get tourHubTitle => 'Este é o jogo todo';

  @override
  String get tourHubBody =>
      'Um botão, que muda conforme o ciclo avança: um sorteio para ver, um elenco para convocar, um jogo para disputar. Acima dele ficam a confiança da direção em você e os objetivos que ela definiu.';

  @override
  String get tourBudgetTitle => 'O dinheiro da federação';

  @override
  String get tourBudgetBody =>
      'Uma vez por ciclo de quatro anos você divide o cofre entre os departamentos. A comissão técnica é paga primeiro, então contratar um olheiro de elite é uma decisão contra a academia, não ao lado dela.';

  @override
  String get tourTacticsTitle => 'Como a seleção joga';

  @override
  String get tourTacticsBody =>
      'Seu sistema, seu jeito de jogar, seu capitão e quem cobra as bolas paradas. Deixe os dois últimos em branco e o jogo avisa antes do início, em vez de escolher em silêncio por você.';

  @override
  String get tourSquadTitle => 'Todos que você pode escalar';

  @override
  String get tourSquadBody =>
      'O grupo inteiro, não só o elenco: quem está em boa fase, quem carrega uma pancada, quem está suspenso e quem acabou de sair da academia.';

  @override
  String get tourCallUpsTitle => 'Convocar o elenco';

  @override
  String get tourCallUpsBody =>
      'Você convoca um elenco por janela internacional e ele joga todos os jogos dessa janela, exatamente como um treinador de verdade. Uma lesão dentro da janela chama um substituto por você.';

  @override
  String get tourRecordsTitle => 'Sua carreira';

  @override
  String get tourRecordsBody =>
      'Tudo o que você fez: as partidas, os recordes da seleção, os troféus e todas as seleções que você já dirigiu.';

  @override
  String get tourCupsTitle => 'O resto do mundo';

  @override
  String get tourCupsBody =>
      'Todas as competições em andamento agora: grupos, classificações e mata-matas, inclusive as que você não disputa. O mundo continua jogando, tenha você se classificado ou não.';

  @override
  String get settingsTourTitle => 'Rever o tutorial';

  @override
  String get settingsTourBlurb =>
      'Percorra de novo as páginas principais desde o início.';

  @override
  String get tourBoardTitle => 'A quem você responde';

  @override
  String get tourBoardBody =>
      'A confiança da direção em você e os objetivos definidos para este ciclo. Se não cumprir a meta, é aqui que você vai ver chegando.';

  @override
  String get tourStaffTitle => 'As pessoas ao seu redor';

  @override
  String get tourStaffBody =>
      'Um adjunto, um olheiro e um preparador físico, contratados pelo nome. Os salários saem deste orçamento antes dos departamentos, então um grande olheiro é uma decisão contra a academia.';

  @override
  String get tourPlaystyleTitle => 'Seu jeito de jogar';

  @override
  String get tourPlaystyleBody =>
      'O sistema é só metade de uma tática. Esta é a outra metade: quão alto você pressiona, quão direto você é, quanto você arrisca.';

  @override
  String get settingsTourNoSave =>
      'Comece uma carreira primeiro. O passeio percorre as páginas do seu jogo.';

  @override
  String tacticsOutOfPositionAge(int age) {
    return 'Fora de posição · $age anos';
  }

  @override
  String get federationNextCycleLocked =>
      'O orçamento do próximo ciclo é definido no início dele, de uma só vez. Até lá, isto é o que seu dinheiro está fazendo.';

  @override
  String get federationBudgetAlreadySet => 'Já definido para este ciclo';

  @override
  String yFinalLooms0(String opponent) {
    return 'É $opponent na decisão. A semana toda, só vão falar disso.';
  }

  @override
  String yFinalLooms1(String opponent) {
    return 'Confirmado: $opponent está entre nós e o título. Quatro anos por isto.';
  }

  @override
  String yFinalLooms2(String opponent) {
    return 'Pronto. $opponent. Ninguém dorme até isso acabar.';
  }

  @override
  String yFinalLooms3(String opponent) {
    return '$opponent a seguir, e o resto pode esperar. Que semana para estar vivo.';
  }

  @override
  String get matchSetupLeaveToCoach => 'Deixar os cobradores com o treinador';

  @override
  String friendliesLikeYourGroup(String rivals) {
    return 'Marcadas abaixo: seleções que jogam como $rivals, as que você enfrenta nos seus grupos neste ciclo.';
  }

  @override
  String newsTransferWindowTitle(int year) {
    return 'Janela de transferências · $year';
  }

  @override
  String careerLastAgo(String when) {
    return 'Há $when';
  }

  @override
  String get settingsFreeScopeTitle => 'Um ciclo gratuito de quatro anos';

  @override
  String get settingsFreeScopeBlurb =>
      'Um ciclo completo (eliminatórias, seu campeonato continental e o Campeonato Mundial) em duas gravações, todas as seleções do mundo, sem nada escondido. Ciclos infinitos e gravações ilimitadas são um pagamento único, uma vez, e cobrem todas as atualizações futuras.';

  @override
  String get settingsUnlockedTitle => 'Desbloqueado';

  @override
  String get settingsUnlockedBlurb =>
      'Ciclos infinitos, gravações ilimitadas e todas as atualizações futuras. Obrigado.';

  @override
  String get settingsFromDeveloperTitle => 'Do desenvolvedor';

  @override
  String get settingsFromDeveloperBlurb =>
      'Football Nations Manager é feito por uma só pessoa e terá suporte a longo prazo. Nunca haverá anúncios nem microtransações. Se você gosta do jogo, considere comprar a versão completa. É o que mantém as atualizações vindo.';

  @override
  String get settingsFromDeveloperThanksBlurb =>
      'Football Nations Manager é feito por uma só pessoa e terá suporte a longo prazo. Nunca haverá anúncios nem microtransações. Obrigado por comprar a versão completa. É o que mantém as atualizações vindo.';

  @override
  String friendliesLikeYourCampaign(String rivals) {
    return 'Marcadas abaixo: seleções que jogam como $rivals, que você ainda vai enfrentar.';
  }

  @override
  String get friendliesCloseToYou =>
      'Marcadas abaixo: as seleções mais próximas de você no ranking mundial. Depois do sorteio, as marcas seguem o seu grupo.';

  @override
  String transfersMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count movimentações',
      one: '1 movimentação',
    );
    return '$_temp0';
  }

  @override
  String hubRoundPage(int page, int pages) {
    return '$page / $pages';
  }

  @override
  String get transfersNewer => 'Mais novas';

  @override
  String get transfersOlder => 'Mais';

  @override
  String get transfersPagePrevious => 'Anterior';

  @override
  String get transfersPageNext => 'Próxima';

  @override
  String transfersPageOf(int page, int pages) {
    return 'Página $page de $pages';
  }

  @override
  String get transfersMovedTo => 'Transferido para';

  @override
  String get transfersUnknownClub => 'Clube desconhecido';

  @override
  String yAgainstThemAgain0(String opponent, String count) {
    return 'Já são $count vezes contra $opponent. Alguém está contando, e não somos nós.';
  }

  @override
  String yAgainstThemAgain1(String opponent, String count) {
    return '$opponent de novo. $count jogos, e ainda não os deciframos.';
  }

  @override
  String yAgainstThemAgain2(String opponent, String count) {
    return 'Jogo número $count contra $opponent. Isso deixou de ser coincidência.';
  }

  @override
  String yAgainstThemAgain3(String opponent, String count) {
    return 'Jogamos $count vezes contra $opponent e não aprendemos nada em nenhuma.';
  }

  @override
  String yAgainstThemAgain4(String opponent, String count) {
    return '$opponent, $count vezes. Eles sabem exatamente o que vamos fazer.';
  }

  @override
  String yAgainstThemAgain5(String opponent, String count) {
    return 'Seja o que $opponent tiver contra nós, depois de $count jogos, ainda tem.';
  }

  @override
  String ySameOldStory0(String count) {
    return 'Já são $count vezes que isso acontece ultimamente. Em que ponto é só o que somos?';
  }

  @override
  String ySameOldStory1(String count) {
    return '$count tardes assim agora. É padrão, não sequência de azar.';
  }

  @override
  String ySameOldStory2(String count) {
    return 'Vimos esse mesmo jogo $count vezes recentemente. Mesmo roteiro, mesmo final.';
  }

  @override
  String ySameOldStory3(String count) {
    return '$count versões dos mesmos noventa minutos. Ninguém conserta.';
  }

  @override
  String ySameOldStory4(String count) {
    return '$count vezes. Se você ainda não vê o padrão, não está olhando.';
  }

  @override
  String ySameOldStory5(String count) {
    return 'A mesma história, $count vezes. As desculpas acabaram antes dos resultados.';
  }

  @override
  String get yToldYouSo0 =>
      'Eu disse que isso vinha enquanto todo mundo comemorava.';

  @override
  String get yToldYouSo1 =>
      'Duas boas semanas e já éramos uma geração de ouro de novo. E olha onde estamos.';

  @override
  String get yToldYouSo2 =>
      'Quem me mandava curtir no mês passado ficou quieto.';

  @override
  String get yToldYouSo3 =>
      'Não sinto prazer nisso. Muito pouco prazer. Algum.';

  @override
  String get yToldYouSo4 =>
      'Nunca foi tão bom quanto diziam, e esta é a prova.';

  @override
  String get yToldYouSo5 =>
      'Toda vez. Dizem que agora é diferente, e toda vez não é.';

  @override
  String get tacticsSubOffAlready => 'Já saiu';

  @override
  String get tacticsSubInjured => 'Lesionado';

  @override
  String get tacticsSubSentOffMark => 'Expulso';

  @override
  String get tacticsSubNoneLeft => 'Sem mais substituições';

  @override
  String get tacticsUndoLastChange => 'Desfazer última mudança';

  @override
  String get matchStrengthTitle => 'O QUE MOVE A SELEÇÃO';

  @override
  String get strengthFactorFamiliarity => 'Sistema treinado';

  @override
  String get strengthFactorFatigue => 'Pernas cansadas';

  @override
  String get strengthFactorClubForm => 'Forma no clube';

  @override
  String get strengthFactorMorale => 'Vestiário';

  @override
  String get strengthFactorCaptain => 'Capitão';

  @override
  String get strengthFactorStaff => 'Comissão técnica';

  @override
  String get strengthFactorDossier => 'Relatório do olheiro';

  @override
  String yDebut0(String name) {
    return '$name faz seu primeiro jogo pela seleção. Guardem o nome.';
  }

  @override
  String yDebut1(String name) {
    return 'Estreia de $name. Dá para ver nele, não dá?';
  }

  @override
  String yDebut2(String name) {
    return '$name, primeiro jogo pela seleção. Vamos ver o que ele faz com isso.';
  }

  @override
  String yDebut3(String name) {
    return 'Estreia de $name. O elenco precisava de pernas novas em algum lugar.';
  }

  @override
  String yDebut4(String name) {
    return '$name ganha uma chance. Temos dado muitas ultimamente.';
  }

  @override
  String yDebut5(String name) {
    return 'Estreia de $name. Mais um que esqueceremos até a primavera.';
  }

  @override
  String yDrought0(String name, String count) {
    return '$name está há $count sem marcar e faz todo o resto em campo.';
  }

  @override
  String yDrought1(String name, String count) {
    return '$count jogos sem gol para $name. Eles vêm de três em três, sempre foi assim.';
  }

  @override
  String yDrought2(String name, String count) {
    return '$name: $count jogos, nenhum gol.';
  }

  @override
  String yDrought3(String name, String count) {
    return '$count sem gol para $name. Vale ficar de olho.';
  }

  @override
  String yDrought4(String name, String count) {
    return '$count jogos. Nenhum gol. $name não acerta nem o chão.';
  }

  @override
  String yDrought5(String name, String count) {
    return '$name não marca há $count. Joguem literalmente qualquer outro.';
  }

  @override
  String yRivalryLooms0(String opponent, String count) {
    return '$opponent a seguir. $count jogos e ainda significa tudo.';
  }

  @override
  String yRivalryLooms1(String opponent, String count) {
    return '$count vezes contra $opponent agora. Venha.';
  }

  @override
  String yRivalryLooms2(String opponent, String count) {
    return '$opponent a seguir. Já foram $count.';
  }

  @override
  String yRivalryLooms3(String opponent, String count) {
    return 'Confronto número $count com $opponent esta semana.';
  }

  @override
  String yRivalryLooms4(String opponent, String count) {
    return '$opponent de novo. $count destes e não aprendemos nada.';
  }

  @override
  String yRivalryLooms5(String opponent, String count) {
    return '$count jogos contra $opponent e eles ainda nos vencem. Maravilha.';
  }

  @override
  String get positionGoalkeeper => 'Goleiro';

  @override
  String get positionLeftBack => 'Lateral esquerdo';

  @override
  String get positionCentreBack => 'Zagueiro central';

  @override
  String get positionRightBack => 'Lateral direito';

  @override
  String get positionDefensiveMid => 'Meio-campista defensivo';

  @override
  String get positionCentralMid => 'Meio-campista central';

  @override
  String get positionAttackingMid => 'Meio-campista ofensivo';

  @override
  String get positionLeftMid => 'Meio-campista esquerdo';

  @override
  String get positionRightMid => 'Meio-campista direito';

  @override
  String get positionLeftWing => 'Ponta esquerda';

  @override
  String get positionRightWing => 'Ponta direita';

  @override
  String get positionStriker => 'Centroavante';

  @override
  String get roleNone => 'Sem função';

  @override
  String get roleTargetMan => 'Pivô';

  @override
  String get rolePoacher => 'Raposa da área';

  @override
  String get rolePlaymaker => 'Armador';

  @override
  String get roleBallWinner => 'Desarmador';

  @override
  String get roleInvertedWinger => 'Ponta invertido';

  @override
  String get roleBallPlayingDefender => 'Zagueiro construtor';

  @override
  String get roleNoneBlurb => 'Joga o seu jogo natural.';

  @override
  String get roleTargetManBlurb =>
      'Ganha de cabeça e devolve. Assistências e bolas paradas.';

  @override
  String get rolePoacherBlurb => 'Fica à espreita na área. Muito mais gols.';

  @override
  String get rolePlaymakerBlurb => 'Cria chances. Muito mais assistências.';

  @override
  String get roleBallWinnerBlurb => 'Quebra o jogo em vez de finalizá-lo.';

  @override
  String get roleInvertedWingerBlurb =>
      'Corta para dentro para chutar. Mais gols.';

  @override
  String get roleBallPlayingDefenderBlurb => 'Inicia as jogadas lá de trás.';

  @override
  String get federationDeptYouth => 'Academia de jovens';

  @override
  String get federationDeptCommercial => 'Comercial / RP';

  @override
  String get federationDeptMedical => 'Medicina e ciências do esporte';

  @override
  String get federationDeptNaturalisation => 'Gabinete de Naturalização';

  @override
  String get federationDeptBoardRelations => 'Relações com a direção';

  @override
  String get federationDeptYouthBlurb =>
      'Promessas melhores da academia estreiam pela sua seleção no próximo ciclo.';

  @override
  String get federationDeptCommercialBlurb =>
      'Patrocínios trazem receita extra no fim do ciclo.';

  @override
  String get federationDeptMedicalBlurb =>
      'Menos lesões. Seu elenco fica disponível o ciclo todo.';

  @override
  String get federationDeptNaturalisationBlurb =>
      'Mais jogadores estrangeiros se oferecem para mudar para a sua seleção.';

  @override
  String get federationDeptBoardRelationsBlurb =>
      'A direção julga seus resultados com mais paciência.';

  @override
  String get federationBuildingAcademy => 'Academia';

  @override
  String get federationBuildingCommercial => 'Sede comercial';

  @override
  String get federationBuildingMedical => 'Centro médico';

  @override
  String get federationBuildingScouting => 'Gabinete de Observação';

  @override
  String get federationBuildingBoardroom => 'Sala da direção';

  @override
  String get moraleBuoyant => 'Animado';

  @override
  String get moralePositive => 'Positivo';

  @override
  String get moraleSettled => 'Estável';

  @override
  String get moraleUneasy => 'Inquieto';

  @override
  String get moraleRockBottom => 'No fundo do poço';

  @override
  String get matchTabTimeline => 'LANCES';

  @override
  String get matchTabStats => 'ESTATÍSTICAS';

  @override
  String get matchTabLineups => 'ESCALAÇÕES';

  @override
  String get matchPenalty => 'PÊNALTI';

  @override
  String get matchStateLevel => 'Está tudo empatado';

  @override
  String matchStateLead(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Você vence por $count gols',
      one: 'Você vence por um gol',
    );
    return '$_temp0';
  }

  @override
  String matchStateTrail(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Você perde por $count gols',
      one: 'Você perde por um gol',
    );
    return '$_temp0';
  }

  @override
  String matchPossessionShare(int possession) {
    return '$possession% de posse de bola';
  }

  @override
  String get boardVerdictSackedTitle => 'A direção demitiu você';

  @override
  String boardVerdictSackedBody(int rating) {
    return 'Um ciclo desastroso (avaliação $rating%). Seu mandato termina aqui. Agora só seleções menores vão arriscar com você.';
  }

  @override
  String get boardVerdictDelightedTitle => 'A direção está encantada';

  @override
  String boardVerdictDelightedBody(int rating, String best) {
    return 'Um ciclo excepcional (avaliação $rating%) após $best. Seleções maiores estão interessadas, ou você pode ficar e construir.';
  }

  @override
  String get boardVerdictSolidTitle => 'Um ciclo sólido';

  @override
  String boardVerdictSolidBody(int rating) {
    return 'A direção está satisfeita (avaliação $rating%). Algumas seleções de nível parecido aceitariam você, mas não há pressão para sair.';
  }

  @override
  String get boardVerdictExpectedMoreTitle => 'A direção esperava mais';

  @override
  String boardVerdictExpectedMoreBody(int rating) {
    return 'Um ciclo decepcionante (avaliação $rating%). Você mantém o cargo, mas qualquer proposta seria um passo atrás.';
  }

  @override
  String get boardVerdictPressureTitle => 'Você está sob pressão real';

  @override
  String boardVerdictPressureBody(int rating) {
    return 'Um ciclo fraco (avaliação $rating%). Você sobrevive, mas só seleções mais fracas têm interesse se quiser recomeçar.';
  }

  @override
  String get boardVerdictHeroTitle => 'A nação está com você';

  @override
  String boardVerdictHeroNote(String nation, int cycles) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles ciclos',
      one: '1 ciclo',
    );
    return ' $nation adora você, um herói nacional após $_temp0; seu cargo está garantido pelo tempo que você quiser.';
  }

  @override
  String get boardVerdictTheNation => 'A nação';

  @override
  String get boardVerdictBestQuiet => 'um ciclo discreto';

  @override
  String get boardVerdictBestCycle => 'o ciclo';

  @override
  String boardVerdictBestWorld(String placement) {
    return 'o Campeonato Mundial: $placement';
  }

  @override
  String get finishThirdPlace => 'Terceiro lugar';

  @override
  String get finishFourthPlace => 'Quarto lugar';

  @override
  String get finishDidNotQualify => 'Não se classificou';

  @override
  String get careerRepIconic => 'Icônico';

  @override
  String get careerRepRenowned => 'Renomado';

  @override
  String get careerRepEstablished => 'Consolidado';

  @override
  String get careerRepRising => 'Em ascensão';

  @override
  String get careerRepUnproven => 'Por provar';

  @override
  String get hubOfferStepUp => 'Passo à frente';

  @override
  String get hubOfferLateral => 'Movimento lateral';

  @override
  String get hubOfferRebuild => 'Uma reconstrução';

  @override
  String careerNationsCupWon(String league) {
    return 'Liga $league · Campeões';
  }

  @override
  String careerNationsCupRunnerUp(String league) {
    return 'Liga $league · Vice-campeões';
  }

  @override
  String careerNationsCupSemi(String league) {
    return 'Liga $league · Semifinalista';
  }

  @override
  String careerNationsCupPlaced(String league, int position) {
    return 'Liga $league · #$position';
  }

  @override
  String tourRunInto(String round) {
    return 'Próxima fase: $round';
  }

  @override
  String get tourRunIntoThirdPlace => 'Rumo ao jogo do terceiro lugar';

  @override
  String tourRunThrough(String round) {
    return 'Superou: $round';
  }

  @override
  String tourRunOut(String round) {
    return 'Eliminado: $round';
  }

  @override
  String get tourRunInGroup => 'Disputando a fase de grupos';

  @override
  String get tourRunGroupOut => 'Eliminado na fase de grupos';

  @override
  String resultsCycleTitle(int year, String nation) {
    return 'Ciclo $year · $nation';
  }

  @override
  String resultsCycleRecord(int played, int won, int drawn, int lost) {
    return '$played jogos  ·  ${won}V ${drawn}E ${lost}D';
  }

  @override
  String resultsCycleFinish(String finish) {
    return 'Campeonato Mundial: $finish';
  }

  @override
  String get resultsCycleUnderway => 'Em andamento';

  @override
  String yTurnedItRound0(String opponent) {
    return 'Perdia por dois no intervalo contra $opponent e recuperou tudo. Isso é uma seleção.';
  }

  @override
  String yTurnedItRound1(String opponent) {
    return 'Dois atrás contra $opponent e no fim não fez diferença. Poucas seleções fazem isso.';
  }

  @override
  String yTurnedItRound2(String opponent) {
    return 'Intervalo: dois gols atrás contra $opponent. Fim de jogo: nada disso. O segundo tempo foi outra partida.';
  }

  @override
  String yTurnedItRound3(String opponent) {
    return 'Virou um 0 a 2 contra $opponent. O que foi dito no intervalo, repitam toda semana.';
  }

  @override
  String yTurnedItRound4(String opponent) {
    return 'Tudo bem, recuperamos contra $opponent. Agora alguém explique os primeiros quarenta e cinco minutos.';
  }

  @override
  String yTurnedItRound5(String opponent) {
    return 'Dois atrás contra $opponent e ainda temos que ficar felizes. Arrumem o primeiro tempo.';
  }

  @override
  String yThrewItAway0(String opponent) {
    return 'Dois à frente contra $opponent no intervalo e escapou. Acontece com seleções melhores.';
  }

  @override
  String yThrewItAway1(String opponent) {
    return 'Dois gols na frente de $opponent e tudo escapou. Ciclo longo pela frente, há tempo de sobra.';
  }

  @override
  String yThrewItAway2(String opponent) {
    return 'Intervalo: dois gols à frente contra $opponent. Fim de jogo: nada parecido.';
  }

  @override
  String yThrewItAway3(String opponent) {
    return 'Dois gols de vantagem contra $opponent, perdidos em quarenta e cinco minutos.';
  }

  @override
  String yThrewItAway4(String opponent) {
    return 'Dois à frente e jogamos fora. Contra $opponent. Alguém tem que responder por isso.';
  }

  @override
  String yThrewItAway5(String opponent) {
    return 'Dois gols na frente contra $opponent e conseguimos isto. Toda vez.';
  }

  @override
  String get cycleBackupDone =>
      'Carreira copiada para a pasta FNM neste aparelho. Desinstalar o app a apaga: para guardar uma cópia em outro lugar, use Fazer cópia desta gravação no menu de gravações.';

  @override
  String get cycleBackupFailed =>
      'Não foi possível fazer a cópia da carreira desta vez.';

  @override
  String pressMomentBigWinWarm1(String opponent) {
    return 'Uma noite para recordar contra $opponent. Quanto orgulho você sente deste grupo?';
  }

  @override
  String pressMomentBigWinWarm2(String opponent) {
    return '$opponent não aguentou o seu ritmo. É esta a seleção em que você sempre acreditou?';
  }

  @override
  String pressMomentBigWinNeutral1(String opponent) {
    return 'Uma grande vitória sobre $opponent. O que fez a diferença hoje?';
  }

  @override
  String pressMomentBigWinNeutral2(String opponent) {
    return '$opponent vencido, e com folga. Onde você ganhou o jogo?';
  }

  @override
  String pressMomentBigWinHostile1(String opponent) {
    return 'Uma boa vitória sobre $opponent. Uma boa noite só: por que alguém deveria acreditar que vai durar?';
  }

  @override
  String pressMomentBigWinHostile2(String opponent) {
    return 'Um bom resultado contra $opponent. Era o seu plano, ou os jogadores resolveram sozinhos?';
  }

  @override
  String pressMomentBigLossWarm1(String opponent) {
    return 'Uma noite difícil contra $opponent. O que você diz aos jogadores depois de uma noite assim?';
  }

  @override
  String pressMomentBigLossWarm2(String opponent) {
    return 'Ninguém esperava isso contra $opponent. Foi só uma daquelas noites?';
  }

  @override
  String pressMomentBigLossNeutral1(String opponent) {
    return 'Foi uma noite humilhante contra $opponent. O que deu errado?';
  }

  @override
  String pressMomentBigLossNeutral2(String opponent) {
    return '$opponent desmontou vocês. Este elenco é bom o bastante?';
  }

  @override
  String pressMomentBigLossHostile1(String opponent) {
    return 'Vocês foram inferiores em tudo contra $opponent. Como deixou chegar a esse ponto?';
  }

  @override
  String pressMomentBigLossHostile2(String opponent) {
    return '$opponent marcou quando quis. Cadê o plano hoje?';
  }

  @override
  String pressMomentCrisisWarm1(String opponent) {
    return 'Mais um jogo que escapa, desta vez contra $opponent. Como você vira esta sequência?';
  }

  @override
  String pressMomentCrisisWarm2(String opponent) {
    return 'Os resultados secaram, e $opponent piorou tudo. Você ainda acredita neste grupo?';
  }

  @override
  String pressMomentCrisisNeutral1(String opponent) {
    return 'Sem vitória de novo, agora contra $opponent, e a direção está de olho. Seu cargo está seguro?';
  }

  @override
  String pressMomentCrisisNeutral2(String opponent) {
    return 'Depois de $opponent, a sequência já está longa. Você teme pelo seu futuro?';
  }

  @override
  String pressMomentCrisisHostile1(String opponent) {
    return '$opponent também. Seu antecessor foi demitido com uma sequência assim. Por que você sobreviveria?';
  }

  @override
  String pressMomentCrisisHostile2(String opponent) {
    return 'Depois de mais uma noite como a de $opponent, todo programa de rádio quer você fora. Você sairia se a direção pedisse?';
  }

  @override
  String pressMomentJobVerdictWarm1(String opponent) {
    return 'Você colocou o cargo em jogo, e depois de $opponent não correu como queria. Como você está lidando com isso?';
  }

  @override
  String pressMomentJobVerdictWarm2(String opponent) {
    return 'Os três jogos acabaram, o último contra $opponent. Você mesmo propôs o teste. O que acha do veredito?';
  }

  @override
  String pressMomentJobVerdictNeutral1(String opponent) {
    return 'Você disse para julgarmos você pelos próximos três. Depois de $opponent, julgamos. O cargo ainda é seu?';
  }

  @override
  String pressMomentJobVerdictNeutral2(String opponent) {
    return 'Três jogos, o último contra $opponent, e não foi o que você prometeu. Já falou com a direção sobre o seu futuro?';
  }

  @override
  String pressMomentJobVerdictHostile1(String opponent) {
    return 'Você mesmo propôs o teste e reprovou contra $opponent. Vai pedir demissão?';
  }

  @override
  String pressMomentJobVerdictHostile2(String opponent) {
    return 'São palavras suas, não nossas: julguem-me pelos próximos três. Depois de $opponent, por que você ainda está sentado aí?';
  }

  @override
  String get pressBeatWhoToBlameWarm1 =>
      'Você quer mais deles. Alguém em particular?';

  @override
  String get pressBeatWhoToBlameWarm2 =>
      'Você elevou a exigência. Quem tem que dar um passo à frente primeiro?';

  @override
  String get pressBeatWhoToBlameNeutral1 =>
      'Você diz que alguns deles precisam se olhar no espelho. Quem você quer dizer?';

  @override
  String get pressBeatWhoToBlameNeutral2 =>
      'Não foi bom o bastante, você diz. De quem está falando?';

  @override
  String get pressBeatWhoToBlameHostile1 =>
      'Você fica no vago. Vai dizer nomes, ou a conta volta para você?';

  @override
  String get pressBeatWhoToBlameHostile2 =>
      'Toda semana a culpa é de outro. De quem é desta vez?';

  @override
  String get pressBeatIfYouDontWarm1 =>
      'Palavras corajosas. E se o próximo jogo não correr bem?';

  @override
  String get pressBeatIfYouDontWarm2 =>
      'O país vai cobrar isso de você. E se não der certo?';

  @override
  String get pressBeatIfYouDontNeutral1 => 'E se você não vencer? Então?';

  @override
  String get pressBeatIfYouDontNeutral2 =>
      'Você já disse. O que acontece se estiver errado?';

  @override
  String get pressBeatIfYouDontHostile1 =>
      'Já ouvimos promessas nesta sala. O que você deve aos torcedores se esta também falhar?';

  @override
  String get pressBeatIfYouDontHostile2 =>
      'E quando não acontecer, qual será a desculpa?';

  @override
  String get pressBeatFollowUpWarm1 =>
      'Mais uma, se você ainda tiver fôlego. No que este grupo ainda precisa trabalhar?';

  @override
  String get pressBeatFollowUpWarm2 =>
      'Quando a poeira baixar, o que você leva desta noite para o próximo jogo?';

  @override
  String get pressBeatFollowUpNeutral1 =>
      'Vamos um pouco mais fundo. O que precisa melhorar antes do próximo jogo?';

  @override
  String get pressBeatFollowUpNeutral2 =>
      'Olhando além do resultado: este elenco está onde você quer?';

  @override
  String get pressBeatFollowUpHostile1 =>
      'Muitas palavras, pouco dito. O que muda de verdade a partir de agora?';

  @override
  String get pressBeatFollowUpHostile2 =>
      'Os torcedores querem uma resposta direta. Esta seleção é boa o bastante, sim ou não?';

  @override
  String pressBeatStandoutWarm1(String player) {
    return '$player foi extraordinário hoje. Até onde ele pode chegar?';
  }

  @override
  String pressBeatStandoutWarm2(String player) {
    return '$player está em todas as manchetes hoje. Você viu isso vindo?';
  }

  @override
  String pressBeatStandoutNeutral1(String player) {
    return '$player se destacou. O que você pediu a ele hoje?';
  }

  @override
  String pressBeatStandoutNeutral2(String player) {
    return '$player foi a diferença hoje?';
  }

  @override
  String pressBeatStandoutHostile1(String player) {
    return 'Sem $player a história é outra. Isto é uma seleção ou um jogador só?';
  }

  @override
  String pressBeatStandoutHostile2(String player) {
    return '$player foi brilhante. Mérito seu ou dele?';
  }

  @override
  String pressBeatStrugglerWarm1(String player) {
    return '$player teve uma noite difícil. Ele está com alguma lesão?';
  }

  @override
  String pressBeatStrugglerWarm2(String player) {
    return '$player não teve a sua noite. Você vai dar um apoio a ele?';
  }

  @override
  String pressBeatStrugglerNeutral1(String player) {
    return '$player sofreu hoje. Ele continua titular?';
  }

  @override
  String pressBeatStrugglerNeutral2(String player) {
    return '$player pareceu fora do ritmo. O que você achou do jogo dele?';
  }

  @override
  String pressBeatStrugglerHostile1(String player) {
    return '$player foi um passageiro de novo. Por que você insiste em escalá-lo?';
  }

  @override
  String pressBeatStrugglerHostile2(String player) {
    return 'Todo mundo viu que $player não estava bem. Todo mundo menos o banco?';
  }

  @override
  String get pressThrowbackWinNextKeptWarm =>
      'Você disse que venceria o próximo jogo, e venceu. É bom estar certo?';

  @override
  String get pressThrowbackWinNextKeptNeutral =>
      'Você prometeu vencer o próximo jogo e cumpriu. Confiança ou bravata?';

  @override
  String get pressThrowbackWinNextKeptHostile =>
      'Você disse que venceria o próximo, e venceu. Sorte, ou devemos começar a ouvir você?';

  @override
  String get pressThrowbackWinNextBrokenWarm =>
      'Você nos disse que venceria aquele. Não aconteceu. O que deu errado?';

  @override
  String get pressThrowbackWinNextBrokenNeutral =>
      'Você disse que venceria o próximo. Não venceu. Por que acreditaríamos na próxima promessa?';

  @override
  String get pressThrowbackWinNextBrokenHostile =>
      'Você disse que venceria o próximo. Não venceu. Suas palavras ainda valem alguma coisa nesta sala?';

  @override
  String get pressThrowbackJobKeptWarm =>
      'Você pediu para ser julgado em três jogos, e passou. Justificado?';

  @override
  String get pressThrowbackJobKeptNeutral =>
      'Julguem-me pelos próximos três, você disse. Julgamos, e os resultados vieram. O que esse teste ensinou a você?';

  @override
  String get pressThrowbackJobKeptHostile =>
      'Você se deu três jogos e passou por eles. O teste foi mesmo tão difícil?';

  @override
  String get pressThrowbackJobBrokenWarm =>
      'Você pediu para ser julgado em três jogos. Não saíram como você queria. O que aprendeu?';

  @override
  String get pressThrowbackJobBrokenNeutral =>
      'Você disse julguem-me pelos próximos três. Os três acabaram, e a boa vontade também. E agora?';

  @override
  String get pressThrowbackJobBrokenHostile =>
      'Você propôs o teste e reprovou. Por que alguém deveria acreditar em você agora?';

  @override
  String pressThrowbackBackKeptWarm(String player) {
    return 'Você apostou em $player quando outros não apostaram. Ele correspondeu. Parte do mérito é seu?';
  }

  @override
  String pressThrowbackBackKeptNeutral(String player) {
    return 'Você apostou em $player. Ele correspondeu. Fé ou conhecimento?';
  }

  @override
  String pressThrowbackBackKeptHostile(String player) {
    return 'Você apostou em $player, e desta vez deu certo. Vai ter a mesma certeza da próxima vez?';
  }

  @override
  String pressThrowbackBackBrokenWarm(String player) {
    return 'Você ficou ao lado de $player, e não deu certo. Você ainda acredita nele?';
  }

  @override
  String pressThrowbackBackBrokenNeutral(String player) {
    return 'Você apostou em $player. Ele não retribuiu. Foi um erro?';
  }

  @override
  String pressThrowbackBackBrokenHostile(String player) {
    return 'O seu discernimento ou a sua lealdade: qual dos dois falhou com $player?';
  }

  @override
  String pressThrowbackBlameKeptWarm(String player) {
    return 'Você foi duro com $player, e os jogos seguintes provaram que você tinha razão. Sente alguma satisfação?';
  }

  @override
  String pressThrowbackBlameKeptNeutral(String player) {
    return 'Você cobrou $player em público, e ele não respondeu. Há caminho de volta para ele?';
  }

  @override
  String pressThrowbackBlameKeptHostile(String player) {
    return 'Você expôs $player e ele não se recuperou. Você o destruiu?';
  }

  @override
  String pressThrowbackBlameBrokenWarm(String player) {
    return 'Você cobrou $player, e ele respondeu em campo. Era essa a ideia desde o início?';
  }

  @override
  String pressThrowbackBlameBrokenNeutral(String player) {
    return 'Você culpou $player, e desde então ele é um dos seus melhores. Você deve um pedido de desculpas a ele?';
  }

  @override
  String pressThrowbackBlameBrokenHostile(String player) {
    return 'Você jogou $player aos leões, e ele é o seu melhor jogador desde então. Vai pedir desculpas?';
  }

  @override
  String get pressReplyCreditPlayers1 =>
      'Estes jogadores me deram tudo. Não trocaria nenhum deles.';

  @override
  String get pressReplyCreditPlayers2 =>
      'Ninguém trabalha mais do que este grupo. Defendo todos eles o dia inteiro.';

  @override
  String get pressReplyCreditPlayers3 =>
      'Dos meus jogadores, daqui deste lugar, vocês não vão ouvir uma palavra contra.';

  @override
  String get pressReplyCreditPlayers4 =>
      'Os jogadores merecem o mérito, não eu. Escrevam sobre eles.';

  @override
  String get pressReplyTakeResponsibility1 =>
      'Esta é minha. Eu escolhi o onze e fui eu que o montei.';

  @override
  String get pressReplyTakeResponsibility2 =>
      'Julguem a mim, não a eles. A seleção é minha e a responsabilidade também.';

  @override
  String get pressReplyTakeResponsibility3 =>
      'Se querem um culpado, estou sentado aqui.';

  @override
  String get pressReplyTakeResponsibility4 =>
      'A responsabilidade é minha. Deixem os jogadores de fora.';

  @override
  String get pressReplyDemandMore1 =>
      'Quero mais. Alguns deles sabem exatamente o que eu quero dizer.';

  @override
  String get pressReplyDemandMore2 =>
      'Esforço não basta neste nível. Quero mais, e já disse isso a eles.';

  @override
  String get pressReplyDemandMore3 =>
      'Espero mais de cada um deles, a começar de amanhã.';

  @override
  String get pressReplyDemandMore4 =>
      'Alguns deles precisam se olhar no espelho. Não estou satisfeito.';

  @override
  String get pressReplyPromiseWinNext1 =>
      'Vamos vencer o próximo. Podem anotar.';

  @override
  String get pressReplyPromiseWinNext2 =>
      'Guardem minhas palavras: vamos vencer o próximo jogo.';

  @override
  String get pressReplyPromiseWinNext3 =>
      'No próximo jogo, vencemos. Digo isso aqui para que possam cobrar de mim.';

  @override
  String get pressReplyPromiseWinNext4 =>
      'Tenho certeza desta seleção. Vamos vencer o próximo jogo.';

  @override
  String get pressReplyJobOnTheLine1 =>
      'Julguem-me pelos próximos três jogos. É justo.';

  @override
  String get pressReplyJobOnTheLine2 =>
      'Deem-me três jogos. Se até lá não estiver certo, julguem-me por isso.';

  @override
  String get pressReplyJobOnTheLine3 =>
      'Os próximos três vão mostrar se sou o homem certo. Cobrem isso de mim.';

  @override
  String get pressReplyJobOnTheLine4 =>
      'Três jogos. Depois escrevam o que quiserem sobre mim.';

  @override
  String get pressReplyDeflect1 =>
      'Pensamos um jogo de cada vez. Nada a acrescentar.';

  @override
  String get pressReplyDeflect2 => 'Hoje não vou dar manchete para vocês.';

  @override
  String get pressReplyDeflect3 => 'Próximo jogo. É só nisso que penso.';

  @override
  String get pressReplyDeflect4 => 'O que eu penso fica no vestiário.';

  @override
  String get pressReplyTakeCredit1 =>
      'Eu disse porque acreditava, e estava certo.';

  @override
  String get pressReplyTakeCredit2 =>
      'Eu li bem o jogo. É para isso que estou aqui.';

  @override
  String get pressReplyTakeCredit3 =>
      'Chamem de discernimento. Eu sabia o que estava dizendo.';

  @override
  String get pressReplyTakeCredit4 =>
      'Tomei a decisão e deu certo. Aceito o mérito.';

  @override
  String get pressReplyStandByIt1 => 'Eu disse o que acreditava. Mantenho.';

  @override
  String get pressReplyStandByIt2 => 'Não retiro uma palavra.';

  @override
  String get pressReplyStandByIt3 =>
      'Mesma resposta de então. Eu falei sério, e ainda falo.';

  @override
  String get pressReplyStandByIt4 => 'Eu diria de novo amanhã.';

  @override
  String get pressReplyAdmitMistake1 => 'Errei nessa. Assumo.';

  @override
  String get pressReplyAdmitMistake2 =>
      'Justo, avaliei mal. Vou aprender com isso.';

  @override
  String get pressReplyAdmitMistake3 => 'Eu estava errado, e posso dizer isso.';

  @override
  String get pressReplyAdmitMistake4 =>
      'Aquela decisão não funcionou, e foi minha.';

  @override
  String pressReplyBackPlayer1(String player) {
    return '$player tem o meu apoio total. Ele vai render.';
  }

  @override
  String pressReplyBackPlayer2(String player) {
    return 'Eu acredito em $player, e ele vai mostrar por quê.';
  }

  @override
  String pressReplyBackPlayer3(String player) {
    return 'De mim vocês não vão ouvir uma palavra contra $player. Ele vai responder.';
  }

  @override
  String pressReplyBackPlayer4(String player) {
    return '$player continua nos meus planos. Vejam o que ele faz a seguir.';
  }

  @override
  String pressReplyBlamePlayer1(String player) {
    return '$player nos decepcionou hoje, e ele sabe disso.';
  }

  @override
  String pressReplyBlamePlayer2(String player) {
    return 'Esperava muito mais de $player. Ele tem que responder por isso.';
  }

  @override
  String pressReplyBlamePlayer3(String player) {
    return '$player não esteve à altura. Vou dizer isso em público.';
  }

  @override
  String pressReplyBlamePlayer4(String player) {
    return 'Não foi bom o bastante da parte de $player, e ele vai ouvir isso de mim.';
  }

  @override
  String get pressOnRecordWinNext =>
      'Registrado: você vai vencer o próximo jogo.';

  @override
  String get pressOnRecordJob => 'Registrado: julgar você pelos próximos três.';

  @override
  String pressOnRecordBack(String player) {
    return 'Registrado: apoio a $player.';
  }

  @override
  String pressOnRecordBlame(String player) {
    return 'Registrado: $player decepcionou você.';
  }

  @override
  String yStatementKept0(String nation) {
    return 'Ele disse, e aconteceu. $nation tem um treinador que cumpre o que diz.';
  }

  @override
  String yStatementKept1(String nation) {
    return 'Falou em voz alta e foi lá e fez. É o homem de que $nation precisava.';
  }

  @override
  String yStatementKept2(String nation) {
    return '$nation: ele disse e cumpriu. Justo.';
  }

  @override
  String yStatementKept3(String nation) {
    return 'Pôs no registro e se sustentou. Ponto para ele. $nation segue em frente.';
  }

  @override
  String yStatementKept4(String nation) {
    return 'Acertou uma. $nation, não se acostumem.';
  }

  @override
  String yStatementKept5(String nation) {
    return 'Até relógio parado acerta duas vezes por dia. $nation teve sorte desta vez.';
  }

  @override
  String yStatementBroken0(String nation) {
    return 'Ele disse e não deu certo. Ainda estou com ele. $nation vai de novo.';
  }

  @override
  String yStatementBroken1(String nation) {
    return '$nation: ele prometeu mais do que recebemos, mas prefiro um treinador que aposta em si mesmo.';
  }

  @override
  String yStatementBroken2(String nation) {
    return '$nation: ele disse em público e não aconteceu. As pessoas vão lembrar.';
  }

  @override
  String yStatementBroken3(String nation) {
    return 'Palavras grandes, nada por trás. $nation: da próxima vez, fale menos.';
  }

  @override
  String yStatementBroken4(String nation) {
    return 'Ficou ali e nos disse. Depois isto. $nation merece mais do que conversa.';
  }

  @override
  String yStatementBroken5(String nation) {
    return 'A palavra dele não vale mais nada. Anote, $nation.';
  }

  @override
  String get ncZoneNorth => 'Zona Norte';

  @override
  String get ncZoneWest => 'Zona Oeste';

  @override
  String get ncZoneEast => 'Zona Leste';

  @override
  String get ncZoneCentralSouthern => 'Zona Central e Austral';

  @override
  String careerNationsCupZoneWon(String zone) {
    return '$zone · Campeões';
  }

  @override
  String careerNationsCupZoneRunnerUp(String zone) {
    return '$zone · Vice-campeões';
  }

  @override
  String careerNationsCupZoneSemi(String zone) {
    return '$zone · Semifinalista';
  }

  @override
  String careerNationsCupZoneRoundOf16(String zone) {
    return '$zone · Oitavas de final';
  }

  @override
  String careerNationsCupZoneQuarter(String zone) {
    return '$zone · Quartas de final';
  }

  @override
  String careerNationsCupZonePlaced(String zone, int position) {
    return '$zone · #$position';
  }

  @override
  String get objectiveNcFinalsEight => 'Chegar às quartas de final';

  @override
  String get objectiveNcZoneWinGroup => 'Vencer o grupo';

  @override
  String get finishNcFinalsEight => 'Quartas de final';

  @override
  String get finishNcBottomHalf => 'Metade de baixo do grupo';

  @override
  String get tourContTabZones => 'ZONAS';

  @override
  String get tourContTabFinalsEight => 'MATA-MATA';

  @override
  String get tourContFinalsEightSoon =>
      'O mata-mata começa em novembro com as oitavas de final: os 14 vencedores de grupo e os 2 melhores segundos colocados.';

  @override
  String get tourContQuarterFinals => 'QUARTAS DE FINAL';

  @override
  String get tourContZoneAdvancement =>
      'Todo vencedor de grupo avança às oitavas de final, junto com os 2 melhores segundos colocados. Ninguém é rebaixado.';

  @override
  String tourContZoneHeadingYours(String zone) {
    return '$zone ★';
  }

  @override
  String get compNorthAmericaNationsCup =>
      'Copa das Nações da América do Norte';

  @override
  String get compAfricanNationsCup => 'Copa das Nações';

  @override
  String get objectiveNcWinItNorthAmerica =>
      'Vencer a Copa das Nações da América do Norte';

  @override
  String get objectiveNcWinItAfrica => 'Vencer a Copa das Nações';

  @override
  String get objectiveNcReachFinalNorthAmerica =>
      'Chegar à final da Copa das Nações da América do Norte';

  @override
  String get objectiveNcReachFinalAfrica => 'Chegar à final da Copa das Nações';

  @override
  String get finishNcChampionsNorthAmerica =>
      'Campeões da Copa das Nações da América do Norte';

  @override
  String get finishNcChampionsAfrica => 'Campeões da Copa das Nações';

  @override
  String pressAimQualWarm1(String competition) {
    return 'As eliminatórias de $competition começam agora, e o país acredita nesta seleção. Qual é a sua meta?';
  }

  @override
  String pressAimQualWarm2(String competition) {
    return 'Uma nova campanha de eliminatórias de $competition, e o astral está alto. Até onde esta seleção pode ir?';
  }

  @override
  String pressAimQualNeutral1(String competition) {
    return 'Começam as eliminatórias de $competition. Qual é a meta desta campanha?';
  }

  @override
  String pressAimQualNeutral2(String competition) {
    return 'Chegaram as eliminatórias de $competition. Onde você vê esta seleção terminando?';
  }

  @override
  String pressAimQualHostile1(String competition) {
    return 'As eliminatórias de $competition começam, e muita gente duvida que você chegue lá. O que diz a essas pessoas?';
  }

  @override
  String pressAimQualHostile2(String competition) {
    return 'Mais uma campanha de eliminatórias de $competition. Por que alguém acreditaria que esta será diferente?';
  }

  @override
  String pressAimFinalsWarm1(String competition) {
    return 'Chegou a hora de $competition e o país inteiro está com você. Até onde podem ir?';
  }

  @override
  String pressAimFinalsWarm2(String competition) {
    return 'Vocês estão em $competition e os torcedores sonham. Qual é o objetivo?';
  }

  @override
  String pressAimFinalsNeutral1(String competition) {
    return '$competition começa esta semana. O que contaria como sucesso?';
  }

  @override
  String pressAimFinalsNeutral2(String competition) {
    return 'O seu primeiro jogo em $competition está perto. Diga uma meta para nós.';
  }

  @override
  String pressAimFinalsHostile1(String competition) {
    return 'Chegou $competition e ninguém espera muito. O que você espera de verdade?';
  }

  @override
  String pressAimFinalsHostile2(String competition) {
    return 'Vocês estão em $competition, mas as dúvidas não passaram. Qual é a sua meta?';
  }

  @override
  String pressBeatRivalWarm1(String rival) {
    return '$rival está no seu grupo. Preocupa você?';
  }

  @override
  String pressBeatRivalWarm2(String rival) {
    return 'O sorteio colocou $rival no seu caminho. Como você vê esse jogo?';
  }

  @override
  String pressBeatRivalNeutral1(String rival) {
    return '$rival parece a seleção mais forte do seu grupo. É a favorita?';
  }

  @override
  String pressBeatRivalNeutral2(String rival) {
    return 'O que você acha de $rival?';
  }

  @override
  String pressBeatRivalHostile1(String rival) {
    return '$rival está no seu grupo. Seja honesto, dá para encarar?';
  }

  @override
  String pressBeatRivalHostile2(String rival) {
    return 'A maioria espera que $rival vença vocês. Estão errados?';
  }

  @override
  String pressBeatKeyPlayerWarm1(String player) {
    return '$player está em grande forma. É a hora dele?';
  }

  @override
  String pressBeatKeyPlayerWarm2(String player) {
    return '$player está em todas as manchetes. Ele consegue carregar esta seleção?';
  }

  @override
  String pressBeatKeyPlayerNeutral1(String player) {
    return 'Quanto esta campanha depende de $player?';
  }

  @override
  String pressBeatKeyPlayerNeutral2(String player) {
    return '$player está pronto para liderar esta seleção?';
  }

  @override
  String pressBeatKeyPlayerHostile1(String player) {
    return 'Se $player não estiver no seu melhor, esta seleção tem alguma coisa?';
  }

  @override
  String pressBeatKeyPlayerHostile2(String player) {
    return '$player carrega muito nos ombros. Demais?';
  }

  @override
  String get pressReplyAimHigher1 =>
      'Vamos mais longe do que qualquer um espera.';

  @override
  String get pressReplyAimHigher2 =>
      'Quero mais do que a federação pediu, e digo isso em voz alta.';

  @override
  String get pressReplyMatchBrief1 => 'Sabemos a meta e vamos cumpri-la.';

  @override
  String get pressReplyMatchBrief2 =>
      'A federação definiu uma meta. Vamos entregá-la.';

  @override
  String get pressReplyPlayDown1 => 'Vamos um jogo de cada vez.';

  @override
  String get pressReplyPlayDown2 =>
      'Sem grandes promessas. Vamos ver onde estamos.';

  @override
  String get pressReplyPromiseQualify1 =>
      'Vamos nos classificar. Podem anotar.';

  @override
  String get pressReplyPromiseQualify2 => 'Esta seleção estará na fase final.';

  @override
  String get pressReplyFearNobody1 => 'Não tememos ninguém.';

  @override
  String get pressReplyFearNobody2 => 'Eles também têm que jogar contra nós.';

  @override
  String get pressReplyRespectRival1 =>
      'São os favoritos, e nós os respeitamos.';

  @override
  String get pressReplyRespectRival2 =>
      'Uma seleção muito boa. Vamos precisar do nosso melhor.';

  @override
  String get pressReplyTeamFirst1 =>
      'É sobre o grupo todo, não sobre um jogador.';

  @override
  String get pressReplyTeamFirst2 => 'Ninguém ganha sozinho.';

  @override
  String pressOnRecordTarget(String aim) {
    return 'Registrado: $aim.';
  }

  @override
  String get pressOnRecordPlayDown => 'Registrado: nenhuma promessa.';

  @override
  String get pressThrowbackTargetKeptWarm =>
      'Você definiu uma meta antes da campanha e a atingiu. É o seu momento de maior orgulho até agora?';

  @override
  String get pressThrowbackTargetKeptNeutral =>
      'Você disse o que ia conquistar, e conquistou. Chegou a haver dúvida?';

  @override
  String get pressThrowbackTargetKeptHostile =>
      'Você atingiu a meta que definiu. Sorte, ou era mesmo o plano?';

  @override
  String get pressThrowbackTargetBrokenWarm =>
      'Você definiu uma meta e ficou aquém. O que deu errado?';

  @override
  String get pressThrowbackTargetBrokenNeutral =>
      'Você prometeu mais do que esta seleção entregou. Você se arrepende de ter dito?';

  @override
  String get pressThrowbackTargetBrokenHostile =>
      'Você falou grosso antes da campanha e ficou aquém. Por que acreditaríamos em você agora?';

  @override
  String hubEventPressPreviewSub(String competition) {
    return 'A imprensa quer ouvir seus objetivos para $competition';
  }

  @override
  String deptLevelCost(int level, String amount) {
    return 'Nível $level · $amount';
  }

  @override
  String get formOnFire => 'Em chamas';

  @override
  String get formGood => 'Em boa fase';

  @override
  String get formSteady => 'Regular';

  @override
  String get formPoor => 'Em má fase';

  @override
  String get formCold => 'Frio como gelo';

  @override
  String get playerFormTitle => 'FORMA E CONDIÇÃO FÍSICA';

  @override
  String playerFormAverage(String rating) {
    return 'Média de $rating nos jogos recentes';
  }

  @override
  String get playerFormNoGames => 'Poucos jogos recentes para avaliar';

  @override
  String playerFormNextMatch(String delta) {
    return '$delta no valor global dele no próximo jogo';
  }

  @override
  String get playerFormNoEffect =>
      'Sem mudança no valor global dele no próximo jogo';

  @override
  String get sideGroupHome => 'Início';

  @override
  String get sideGroupTeam => 'Seleção';

  @override
  String get sideGroupCompetitions => 'Competições';

  @override
  String get sideGroupFederation => 'Federação';

  @override
  String get sideGroupHistory => 'História';

  @override
  String get sideInbox => 'Mensagens';

  @override
  String get sideSquad => 'Elenco';

  @override
  String get sideTactics => 'Tática';

  @override
  String get sideMainMenu => 'Menu principal';

  @override
  String get sideCallUps => 'Convocações';

  @override
  String get sideTournaments => 'Torneios';

  @override
  String get sideRanking => 'Ranking';

  @override
  String get sideResults => 'Resultados';

  @override
  String get sideFinances => 'Finanças';

  @override
  String get sideBoard => 'Direção';

  @override
  String get sideManager => 'Treinador e comissão';

  @override
  String get sideRecords => 'Recordes';

  @override
  String get sideLegends => 'Lendas';

  @override
  String get sideHeadToHead => 'Confronto direto';

  @override
  String get sideAchievements => 'Conquistas';

  @override
  String get sideCareer => 'Carreira';

  @override
  String get topBarNext => 'Próximo';

  @override
  String get topBarDrawPending => 'Sorteio pendente';

  @override
  String get paneFullProfile => 'Perfil completo';

  @override
  String get panePickPlayer => 'Escolha um jogador para ver a ficha dele aqui';

  @override
  String get inboxPickMessage => 'Escolha uma mensagem para lê-la aqui';

  @override
  String get inboxFilterAll => 'Todas';

  @override
  String get panelViewAll => 'Ver tudo';

  @override
  String get gridViewOverview => 'Visão geral';

  @override
  String get gridColCondition => 'Condição';

  @override
  String get gridColStatus => 'Situação';

  @override
  String get gridColRank => 'Posição';

  @override
  String get gridColMove => 'Variação';

  @override
  String get gridColNation => 'Seleção';

  @override
  String get gridColRegion => 'Região';

  @override
  String get gridColPoints => 'Pontos';

  @override
  String get panePickNation => 'Escolha uma seleção para ver o histórico aqui';

  @override
  String get resultsCyclesTitle => 'Ciclos';

  @override
  String get tourDrawStart => 'Iniciar o sorteio';

  @override
  String get tourDrawViewGroups => 'Ver grupos';

  @override
  String get gridColCeiling => 'Teto';

  @override
  String get gridColYearGain => 'Ganho';

  @override
  String get gridColMarkedAt => 'Ao marcar';

  @override
  String get budgetSetupTitle => 'Defina o orçamento';

  @override
  String get budgetEffectsTitle => 'O que este orçamento compra';

  @override
  String get naturalisationTitle => 'Naturalização';

  @override
  String get yTrending => 'Em alta';

  @override
  String get yVoices => 'Vozes';

  @override
  String get yConversation => 'Conversa';

  @override
  String get allTimeRecordsTitle => 'Recordes mundiais de todos os tempos';

  @override
  String get h2hMeetingsTitle => 'Todos os confrontos';

  @override
  String get h2hPickOpponent =>
      'Escolha um adversário para ver todos os confrontos aqui';

  @override
  String get savesTitle => 'Gravações';

  @override
  String get gridColPlayer => 'Jogador';

  @override
  String get gridColPos => 'Pos';

  @override
  String get gridColActive => 'Ativo';

  @override
  String get gridColMotm => 'MEC';

  @override
  String get gridColAvg => 'Méd.';

  @override
  String get gridColOpponent => 'Adversário';

  @override
  String get gridColStarts => 'Titular';

  @override
  String get gridColTournaments => 'Torneios';

  @override
  String get gridColDate => 'Data';

  @override
  String get gridColLastPlayed => 'Última partida';

  @override
  String get gridColManager => 'Treinador';

  @override
  String nationsShownCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count seleções',
      one: '1 seleção',
    );
    return '$_temp0';
  }

  @override
  String get nationsSortedByRank => 'Ordenadas por ranking mundial';

  @override
  String get nationsStrength => 'Força';

  @override
  String nationsStrengthOf(int tier) {
    return '$tier de 5';
  }

  @override
  String get nationsSquadOverall => 'Valor global do elenco';

  @override
  String get nationsOpeningBudget => 'Orçamento inicial';

  @override
  String get nationsStarPlayer => 'Craque';

  @override
  String nationsStarTile(String position, int rating) {
    return 'Craque $position $rating';
  }

  @override
  String nationsStarAge(int age) {
    return 'Idade $age';
  }

  @override
  String get nationsBoardExpects => 'A direção espera';

  @override
  String nationsManage(String nation) {
    return 'Treinar $nation';
  }

  @override
  String get nationsManagerNext => 'Em seguida, você dá nome ao treinador';

  @override
  String get playerPageTitle => 'Jogador';

  @override
  String get nationPageTitle => 'Seleção';

  @override
  String get friendliesYourGames => 'Seus amistosos';

  @override
  String hubEventInjuryCover(String player) {
    return 'Substituir $player, lesionado';
  }

  @override
  String hubEventInjuryCoverSub(int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: 'Fora por $matches jogos',
      one: 'Fora no próximo jogo',
    );
    return '$_temp0. Convoque alguém ou siga sem ele.';
  }

  @override
  String get injuryCoverTitle => 'SUBSTITUTO';

  @override
  String injuryCoverBanner(String player, String position) {
    return '$player ($position) está lesionado. Convoque qualquer jogador de fora do elenco, em qualquer posição, ou fique com ele e siga em frente.';
  }

  @override
  String injuryCoverConfirm(String player) {
    return 'Convocar $player';
  }

  @override
  String injuryCoverKeep(String player) {
    return 'Manter $player e seguir';
  }

  @override
  String get injuryCoverPick => 'Escolha um substituto';

  @override
  String get injuryCoverNone => 'Nenhum jogador fora do elenco está apto.';

  @override
  String get nationNowRanking => 'Ranking mundial';

  @override
  String get nationNowForm => 'Forma';

  @override
  String get nationNowNoForm => 'Nenhum jogo disputado ainda';

  @override
  String get nationNowNext => 'Próximo jogo';

  @override
  String get nationNowNoNext => 'Nada agendado';

  @override
  String get nationNowSquad => 'Elenco';

  @override
  String get nationNowAgainstYou => 'Contra você';

  @override
  String nationNowRecord(int w, int d, int l) {
    return '${w}V ${d}E ${l}D';
  }

  @override
  String get nationNowLastMeeting => 'Último confronto';

  @override
  String nationNowOverall(int value) {
    return 'Valor global $value';
  }

  @override
  String get hubUpcoming => 'PRÓXIMOS JOGOS';

  @override
  String get hubFullSchedule => 'Calendário completo';

  @override
  String get scheduleTitle => 'Calendário';

  @override
  String get scheduleToday => 'Hoje';

  @override
  String get scheduleKnockoutPending => 'Mata-mata, se você avançar';

  @override
  String get scheduleNextRoundPending => 'Próxima fase';

  @override
  String scheduleFromDate(String date) {
    return 'A partir de $date';
  }

  @override
  String get scheduleHomeShort => 'C';

  @override
  String get scheduleAwayShort => 'F';

  @override
  String get tacticsNoPresetsInMatch =>
      'Nenhuma tática salva ainda. Salve uma no menu Tática antes do jogo.';

  @override
  String get homeCampaigns => 'Campanhas';

  @override
  String get homeContinueCampaign => 'CONTINUAR CAMPANHA';

  @override
  String homeCampaignCycle(String date, int cycle, int total) {
    return '$date · Ciclo $cycle de $total';
  }

  @override
  String get campaignsTitle => 'Campanhas';

  @override
  String get campaignTransplantTitle => 'O Transplante';

  @override
  String get campaignTransplantTwist =>
      'Oito dos melhores da Itália mudam de seleção para San Marino';

  @override
  String get campaignTransplantGoal =>
      'Classificar-se para o Campeonato Europeu';

  @override
  String get campaignGrudgeTitle => 'Rixa';

  @override
  String get campaignGrudgeTwist => 'Geórgia e Albânia, sorteadas juntas';

  @override
  String get campaignGrudgeGoal =>
      'Terminar acima da Albânia nas eliminatórias';

  @override
  String get campaignTransplantIntro =>
      'San Marino nunca teve uma campanha de eliminatórias digna do nome. Então oito dos melhores da Itália pegam o passaporte e entram. Você tem um ciclo para transformar uma curiosidade em uma seleção.';

  @override
  String get campaignGrudgeIntro =>
      'Geórgia e Albânia caíram no mesmo grupo das eliminatórias, e nenhuma das duas vai perdoar uma derrota. Termine acima da Albânia e veja até onde consegue levar isso.';

  @override
  String get campaignStars1Transplant => 'Classificar-se';

  @override
  String get campaignStars2Transplant => 'Chegar ao mata-mata';

  @override
  String get campaignStars3Transplant => 'Vencer o Campeonato Europeu';

  @override
  String get campaignStars1Grudge => 'Acima da Albânia';

  @override
  String get campaignStars2Grudge => 'E se classificar';

  @override
  String get campaignStars3Grudge => 'E vencer duas vezes';

  @override
  String get campaignFree => 'Grátis';

  @override
  String get campaignStart => 'Começar';

  @override
  String get campaignPartOfUnlimited => 'Incluído no modo sem limites';

  @override
  String get campaignResume => 'Continuar';

  @override
  String get campaignAbandon => 'Abandonar';

  @override
  String get campaignAbandonConfirm =>
      'Abandonar este percurso? O progresso se perde; seu carimbo fica.';

  @override
  String get campaignMoveToSaves => 'Mover para gravações';

  @override
  String get campaignCannotContinue =>
      'O mundo desta campanha está demasiado longe do real para continuar como carreira.';

  @override
  String get campaignMoveSlotsFull =>
      'Seus espaços de gravação estão cheios. Libere um primeiro.';

  @override
  String get campaignStampConquered => 'Conquistada';

  @override
  String get campaignStampFailed => 'Fracassada';

  @override
  String get campaignDifficultyHard => 'Difícil';

  @override
  String get campaignDifficultyMedium => 'Média';

  @override
  String get campaignGoalLabel => 'Objetivo';

  @override
  String get campaignStarsLabel => 'Estrelas';

  @override
  String get campaignRunInProgress =>
      'Esta campanha já tem um percurso em andamento.';

  @override
  String get campaignVerdictWon => 'Conquistada';

  @override
  String get campaignVerdictLost => 'Desta vez não';

  @override
  String get campaignVerdictContinue => 'Continuar';

  @override
  String campaignProgressQualifying(String position) {
    return 'Eliminatórias: $position';
  }

  @override
  String campaignProgressRival(String rival, String position) {
    return '$rival: $position';
  }

  @override
  String campaignProgressFinals(String stage) {
    return 'Fase final: $stage';
  }

  @override
  String get campaignRunInNumbers => 'O percurso em números';

  @override
  String campaignRunMeetings(int won, int played) {
    return 'Confrontos vencidos: $won de $played';
  }

  @override
  String campaignPlace(String which, int n) {
    String _temp0 = intl.Intl.selectLogic(
      which,
      {
        'first': '1º',
        'second': '2º',
        'third': '3º',
        'other': '$nº',
      },
    );
    return '$_temp0';
  }

  @override
  String get campaignGuineasTitle => 'A melhor Guiné';

  @override
  String get campaignGuineasTwist =>
      'Guiné Equatorial, a menor das Guinés africanas, por dois ciclos';

  @override
  String get campaignGuineasGoal => 'Vencer a Guiné e a Guiné-Bissau';

  @override
  String get campaignGuineasIntro =>
      'Três nações africanas têm o nome Guiné, e a Guiné Equatorial é a menor delas. Você tem dois ciclos para vencer a Guiné e a Guiné-Bissau pelo menos uma vez cada, e depois ver até onde chega na Copa da África. A Papua-Nova Guiné, a quarta Guiné, já está marcada para um amistoso.';

  @override
  String get campaignStars1Guineas => 'Vencer a Guiné e a Guiné-Bissau';

  @override
  String get campaignStars2Guineas =>
      'E se classificar para uma Copa da África';

  @override
  String get campaignStars3Guineas =>
      'E chegar às quartas de final de uma Copa da África';

  @override
  String get campaignYoungFinnsTitle => 'Jovens Finlandeses';

  @override
  String get campaignYoungFinnsTwist =>
      'A geração de ouro de adolescentes da Finlândia, por três ciclos';

  @override
  String get campaignYoungFinnsGoal =>
      'Classificar-se para um Campeonato Mundial';

  @override
  String get campaignYoungFinnsIntro =>
      'Os veteranos da Finlândia deixaram a seleção e uma geração de ouro tomou o lugar deles: todo jogador que você pode convocar tem 18 anos ou menos. Hoje ainda são crus, mas têm talento para se tornar uma das melhores seleções do mundo, como fez a jovem geração da Noruega. Você tem três ciclos para levá-los a um Campeonato Mundial e depois vencer o Campeonato Europeu e o Campeonato Mundial.';

  @override
  String get campaignStars1YoungFinns =>
      'Classificar-se para um Campeonato Mundial';

  @override
  String get campaignStars2YoungFinns => 'Vencer o Campeonato Europeu';

  @override
  String get campaignStars3YoungFinns => 'Vencer o Campeonato Mundial';

  @override
  String get campaignGreenlandTitle => 'Um século groenlandês';

  @override
  String get campaignGreenlandTwist =>
      'A Groenlândia ocupa o lugar de San Marino na Europa, por cem anos';

  @override
  String get campaignGreenlandGoal =>
      'Classificar-se para um Campeonato Europeu';

  @override
  String get campaignGreenlandIntro =>
      'A Groenlândia nunca disputou uma partida internacional oficial. Neste mundo, ela ocupou o lugar de San Marino na Europa e começa no fundo do ranking mundial: jogadores amadores, campos de grama sintética e uma temporada espremida entre as nevascas. Você tem cem anos, vinte e cinco ciclos, para chegar a um Campeonato Europeu, depois a um Campeonato Mundial e, se ousar sonhar, vencer um deles.';

  @override
  String get campaignStars1Greenland =>
      'Classificar-se para um Campeonato Europeu';

  @override
  String get campaignStars2Greenland =>
      'Classificar-se para um Campeonato Mundial';

  @override
  String get campaignStars3Greenland =>
      'Vencer o Campeonato Europeu ou o Campeonato Mundial';

  @override
  String get campaignPro => 'Pro';

  @override
  String campaignProgressCup(String cup, String year, String status) {
    return '$cup $year: $status';
  }

  @override
  String get campaignCupNotQualified => 'Não se classificou';

  @override
  String get campaignCupOpen => 'A decidir';

  @override
  String newsYouthTitle1(String name, String level) {
    return '$name brilha pela seleção $level';
  }

  @override
  String newsYouthTitle2(String name, String level) {
    return 'Relatório da base: $name chama a atenção';
  }

  @override
  String newsYouthTitle3(String name, String level) {
    return 'Destaque da seleção $level: $name';
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
      other: '$count vezes',
      one: 'uma vez',
    );
    return '$name balançou as redes $_temp0 pela seleção $level contra $opponent na última data FIFA.';
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
      other: '$count gols',
      one: 'Um gol',
    );
    return '$_temp0 de $name no jogo da seleção $level contra $opponent nesta data.';
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
      other: '$count gols',
      one: 'um gol',
    );
    return 'A seleção $level enfrentou $opponent, e $name saiu de campo com $_temp0 na conta.';
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
      other: '$count assistências',
      one: 'uma assistência',
    );
    return '$name deu $_temp0 pela seleção $level contra $opponent e comandou o jogo do início ao fim.';
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
      other: '$count assistências',
      one: 'uma assistência',
    );
    return 'A seleção $level pegou $opponent nesta data, e quem ditou o ritmo foi $name: $_temp0 e uma atuação da qual a comissão técnica ainda fala.';
  }

  @override
  String newsYouthCleanSheet1(String name, String level, String opponent) {
    return '$name foi excelente no jogo em que a seleção $level não sofreu gols contra $opponent.';
  }

  @override
  String newsYouthCleanSheet2(String name, String level, String opponent) {
    return 'Sem gols sofridos para a seleção $level contra $opponent, e boa parte do mérito é de $name.';
  }

  @override
  String newsYouthDisplay1(
    String name,
    String level,
    String opponent,
    int mark,
  ) {
    return '$name impressionou pela seleção $level contra $opponent, e a comissão técnica deu nota $mark de dez à atuação dele.';
  }

  @override
  String newsYouthDisplay2(
    String name,
    String level,
    String opponent,
    int mark,
  ) {
    return 'A seleção $level jogou contra $opponent nesta data, e os treinadores destacaram $name: nota $mark de dez, a maior da equipe.';
  }

  @override
  String get newsYouthDevReady1 =>
      'Nesse nível, ele já é bom o bastante para ser considerado para a seleção principal.';

  @override
  String get newsYouthDevReady2 =>
      'A comissão técnica acredita que ele já está pronto para o futebol profissional. A decisão é sua.';

  @override
  String get newsYouthDevClose1 =>
      'Ele está evoluindo bem e está perto de chegar à seleção principal.';

  @override
  String get newsYouthDevClose2 =>
      'Não falta muito para a seleção principal, e mais uma boa temporada pode bastar.';

  @override
  String get newsYouthDevGrowing1 =>
      'Ele está se desenvolvendo bem, embora a seleção principal ainda esteja a um ou dois passos.';

  @override
  String get newsYouthDevGrowing2 =>
      'Há trabalho a fazer antes de ele vestir a camisa da seleção principal, mas tudo aponta na direção certa.';

  @override
  String get newsYouthDevRaw1 =>
      'Ele ainda está cru e a alguns anos da seleção principal, mas o talento salta aos olhos.';

  @override
  String get newsYouthDevRaw2 =>
      'Ainda é cedo, e os treinadores da base pedem paciência, não manchetes.';

  @override
  String get newsYouthStrengthGkPhysical =>
      'A envergadura e o domínio da área são o que o diferenciam.';

  @override
  String get newsYouthStrengthGkTechnical =>
      'A segurança nas mãos e a reposição são as melhores que a base viu em anos.';

  @override
  String get newsYouthStrengthGkStamina =>
      'A concentração dele nunca cai: está tão ligado no minuto noventa quanto no primeiro.';

  @override
  String get newsYouthStrengthDefPhysical =>
      'A velocidade e o jogo aéreo são a chave do futebol dele.';

  @override
  String get newsYouthStrengthDefTechnical =>
      'Ele lê o jogo muito além da idade e tem calma com a bola.';

  @override
  String get newsYouthStrengthDefStamina =>
      'Ele nunca se desliga e ainda volta em velocidade no último minuto.';

  @override
  String get newsYouthStrengthMidPhysical =>
      'Ele recupera bolas com força de verdade e sai conduzindo para o ataque.';

  @override
  String get newsYouthStrengthMidTechnical =>
      'A visão de jogo e o repertório de passes são a chave do futebol dele.';

  @override
  String get newsYouthStrengthMidStamina =>
      'O fôlego dele impressiona: cobre cada centímetro do gramado.';

  @override
  String get newsYouthStrengthFwdPhysical =>
      'A velocidade em profundidade e a força pelo alto fazem dele um problema para qualquer defesa.';

  @override
  String get newsYouthStrengthFwdTechnical =>
      'A finalização e a movimentação na área são a chave do futebol dele.';

  @override
  String get newsYouthStrengthFwdStamina =>
      'Ele pressiona lá na frente o jogo todo e não dá sossego aos zagueiros.';

  @override
  String pressMomentBigWinWarm3(String opponent) {
    return 'A torcida vai cantar esse jogo contra $opponent por muito tempo. O que você disse aos jogadores no apito final?';
  }

  @override
  String pressMomentBigWinNeutral3(String opponent) {
    return 'Foi um recado e tanto contra $opponent. Quanto disso veio dos treinos?';
  }

  @override
  String pressMomentBigWinHostile3(String opponent) {
    return 'Mérito pelo resultado contra $opponent, mas já vimos noites assim. O que é diferente desta vez?';
  }

  @override
  String pressMomentBigLossWarm3(String opponent) {
    return 'Todo mundo tem uma noite ruim, e essa contra $opponent foi uma delas. Quão rápido você consegue virar a página?';
  }

  @override
  String pressMomentBigLossNeutral3(String opponent) {
    return '$opponent foi melhor em todos os setores. Por onde você começa a consertar?';
  }

  @override
  String pressMomentBigLossHostile3(String opponent) {
    return 'A torcida foi embora antes do fim contra $opponent. Dá para culpá-la?';
  }

  @override
  String pressMomentCrisisWarm3(String opponent) {
    return 'A fase é difícil, e $opponent não facilitou em nada. O que mantém você de pé?';
  }

  @override
  String pressMomentCrisisNeutral3(String opponent) {
    return 'Mais um jogo sem vencer, desta vez contra $opponent. Quanto tempo isso pode durar até a direção agir?';
  }

  @override
  String pressMomentCrisisHostile3(String opponent) {
    return 'Agora $opponent também. Sobrou alguma coisa no seu plano, ou é hora de dar lugar a outra pessoa?';
  }

  @override
  String get pressReplyCreditPlayers5 =>
      'Escrevam o que quiserem, mas escrevam sobre os jogadores. Eles merecem.';

  @override
  String get pressReplyCreditPlayers6 =>
      'Tenho um grupo que se jogaria no fogo um pelo outro. Isso não é pouca coisa.';

  @override
  String get pressReplyTakeResponsibility5 =>
      'Eu tomo as decisões, então as críticas são para mim. Faz parte do trabalho.';

  @override
  String get pressReplyTakeResponsibility6 =>
      'Olhem primeiro para o treinador. Errei em algumas coisas e vou corrigi-las.';

  @override
  String get pressReplyDemandMore5 =>
      'Bom não basta aqui. Falei isso na cara deles.';

  @override
  String get pressReplyDemandMore6 =>
      'Ninguém naquele vestiário tem vaga garantida. Agora eles sabem.';

  @override
  String get pressReplyDeflect5 =>
      'Vocês podem perguntar de três jeitos diferentes. A resposta vai ser a mesma.';

  @override
  String get pressReplyDeflect6 =>
      'Guardo o que penso para os jogadores. Vocês vão entender.';

  @override
  String yWinRoutine12(String opponent, String score) {
    return '$score contra $opponent. Futebol calmo, controlado, maduro. Dá gosto de ver.';
  }

  @override
  String yWinRoutine13(String opponent, String score) {
    return 'Vencemos $opponent por $score sem suar. Esse time está ficando bom em ser chato, e chato ganha título.';
  }

  @override
  String yWinRoutine14(String opponent, String score) {
    return '$opponent $score. Três pontos, zero drama, de volta ao trabalho.';
  }

  @override
  String yWinRoutine15(String opponent, String score) {
    return 'Um $score protocolar contra $opponent. Ninguém vai lembrar e ninguém precisa.';
  }

  @override
  String yWinRoutine16(String opponent, String score) {
    return '$score contra $opponent e mesmo assim saí preocupado.';
  }

  @override
  String yWinRoutine17(String opponent, String score) {
    return 'Vencemos $opponent por $score. Contra um time de verdade, uma atuação dessas é castigada.';
  }

  @override
  String yWinTight12(String opponent, String score) {
    return '$score contra $opponent. Cerrar os dentes, sofrer e vencer. Isso é um time.';
  }

  @override
  String yWinTight13(String opponent, String score) {
    return 'Vencemos $opponent por $score na base do nervo. Fico com um time que se recusa a perder.';
  }

  @override
  String yWinTight14(String opponent, String score) {
    return '$opponent $score. Foi até o último segundo, mas os pontos são nossos.';
  }

  @override
  String yWinTight15(String opponent, String score) {
    return 'Um $score apertado contra $opponent. Pouca diferença, e isso é futebol.';
  }

  @override
  String yWinTight16(String opponent, String score) {
    return '$score contra $opponent. Um desvio de sorte para o outro lado e a conversa seria bem diferente.';
  }

  @override
  String yWinTight17(String opponent, String score) {
    return 'Seguramos como deu contra $opponent, $score. Ninguém chame isso de atuação.';
  }

  @override
  String yDrew12(String opponent, String score) {
    return '$score com $opponent. Não é derrota, e tem dia em que o trabalho é esse.';
  }

  @override
  String yDrew13(String opponent, String score) {
    return 'Um ponto suado contra $opponent, $score. Gostei da garra.';
  }

  @override
  String yDrew14(String opponent, String score) {
    return '$opponent $score. Pontos divididos, como diziam os narradores das antigas.';
  }

  @override
  String yDrew15(String opponent, String score) {
    return '$score com $opponent. Nenhum dos dois fez o suficiente para merecer mais.';
  }

  @override
  String yDrew16(String opponent, String score) {
    return '$score com $opponent. Aquele empate que no ônibus de volta tem gosto de derrota.';
  }

  @override
  String yDrew17(String opponent, String score) {
    return 'Empate em $score com $opponent. A gente fala de evolução o tempo todo e faz isso o tempo todo.';
  }

  @override
  String yLost12(String opponent, String score) {
    return '$score para $opponent. Dói, mas vi o suficiente para acreditar neste time.';
  }

  @override
  String yLost13(String opponent, String score) {
    return 'Derrota por $score para $opponent, e eles foram bons. Reconhecer e seguir em frente.';
  }

  @override
  String yLost14(String opponent, String score) {
    return '$opponent $score. Uma derrota, algumas lições e o próximo jogo logo ali.';
  }

  @override
  String yLost15(String opponent, String score) {
    return 'Perdemos por $score para $opponent. Difícil discutir.';
  }

  @override
  String yLost16(String opponent, String score) {
    return '$score para $opponent. Os mesmos erros da última vez, cometidos com a mesma confiança.';
  }

  @override
  String yLost17(String opponent, String score) {
    return 'Derrota por $score para $opponent. Se ninguém vai responder por isso, o que estamos fazendo?';
  }

  @override
  String get yReactionShrug12 =>
      'Por mim, tudo bem. Nem toda noite precisa de fogos de artifício.';

  @override
  String get yReactionShrug13 => 'Ponto é ponto. Hoje eu durmo bem.';

  @override
  String get yReactionShrug14 => 'Vi. Sem comentários.';

  @override
  String get yReactionShrug15 => 'Algo entre ok e ok.';

  @override
  String get yReactionShrug16 =>
      'Paguei o streaming para isso. Nunca mais (vou voltar).';

  @override
  String get yReactionShrug17 =>
      'Noventa minutos de nada em formato de futebol.';

  @override
  String get yReactionRelief12 =>
      'Voltei a respirar. Orgulhoso de eles terem segurado.';

  @override
  String get yReactionRelief13 =>
      'São essas vitórias que formam um time. Feio é lindo.';

  @override
  String get yReactionRelief14 => 'Fiquei sem unhas, mas não sem pontos.';

  @override
  String get yReactionRelief15 => 'Nunca um apito final soou tão bem.';

  @override
  String get yReactionRelief16 => 'Feliz por vencer, preocupado com o jeito.';

  @override
  String get yReactionRelief17 =>
      'A gente continua escapando. Um dia não vai dar.';

  @override
  String get yReactionFury12 =>
      'Eu amo esse time, e é exatamente por isso que dói.';

  @override
  String get yReactionFury13 =>
      'Noite ruim. Da próxima vez eles nos devem uma, e sabem disso.';

  @override
  String get yReactionFury14 =>
      'Desliguei aos setenta minutos. Devia ter sido aos sessenta.';

  @override
  String get yReactionFury15 => 'Sem luta, sem ideias, sem desculpas.';

  @override
  String get yReactionFury16 =>
      'Os mesmos problemas toda vez, e ninguém conserta nada.';

  @override
  String get yReactionFury17 =>
      'Alguém na federação precisa rever isso e nos explicar.';

  @override
  String get backupShareHint =>
      'Cria um arquivo de cópia com todos os jogos salvos. Escolha Google Drive, iCloud Drive ou Arquivos para guardá-lo.';

  @override
  String backupLastAt(String date) {
    return 'Última cópia: $date';
  }

  @override
  String get backupNever => 'Nenhuma cópia ainda';

  @override
  String get backupRemindersTitle => 'Lembretes de cópia';

  @override
  String get backupRemindersBlurb =>
      'Um aviso na caixa de entrada quando a última cópia estiver ficando antiga.';

  @override
  String get backupAutoICloudTitle => 'Cópia automática no iCloud';

  @override
  String get backupAutoDriveTitle => 'Cópia automática no Google Drive';

  @override
  String get backupAutoBlurb =>
      'Faz a cópia depois das partidas, no fim de um ciclo e quando você sai do app. Mantém as duas últimas.';

  @override
  String get backupStatusUploading => 'Fazendo a cópia.';

  @override
  String get backupStatusUploaded => 'Cópia feita.';

  @override
  String get backupStatusICloudSignedOut =>
      'O iCloud está desligado. Entre no iCloud e ative o iCloud Drive no app Ajustes.';

  @override
  String get backupStatusDriveSignedOut =>
      'Sem sessão. Ligue a chave para entrar com o Google.';

  @override
  String get backupStatusNotConfigured =>
      'Ainda não disponível nesta versão do app.';

  @override
  String get backupStatusUnavailable =>
      'A nuvem não pode ser acessada agora. Nova tentativa mais tarde.';

  @override
  String get backupStatusFailed =>
      'A última cópia automática não foi concluída. Nova tentativa mais tarde.';

  @override
  String backupDriveSignedInAs(String email) {
    return 'Conectado como $email';
  }

  @override
  String get backupDriveSignOut => 'SAIR';

  @override
  String get backupDriveSignInFailed =>
      'O login com o Google não funcionou. Tente mais tarde.';

  @override
  String get backupRestoreICloud => 'RESTAURAR DO ICLOUD';

  @override
  String get backupRestoreDrive => 'RESTAURAR DO GOOGLE DRIVE';

  @override
  String get backupCrossPlatformHelp =>
      'Mudando entre iPhone e Android? Faça a cópia em um arquivo em um telefone e restaure a partir desse arquivo no outro.';

  @override
  String get backupCloudListBlurb =>
      'Cópias dos seus aparelhos nesta conta. Toque em uma para restaurá-la.';

  @override
  String get backupCloudListEmpty =>
      'Nenhuma cópia encontrada. Uma cópia nova pode levar alguns minutos para chegar a outro aparelho.';

  @override
  String get backupCloudListFailed =>
      'Não foi possível ler as cópias. Verifique a conexão e tente de novo.';

  @override
  String get backupCloudThisDevice => 'Este aparelho';

  @override
  String backupCloudMore(int count) {
    return 'Mais jogos salvos: $count';
  }

  @override
  String get backupCloudNewer =>
      'Feita por uma versão mais nova do app. Atualize primeiro.';

  @override
  String get backupCloudDownloading => 'Baixando a cópia.';

  @override
  String get backupRestoreSafetyNote =>
      'Antes, uma cópia dos jogos salvos deste telefone é guardada neste telefone.';

  @override
  String get backupRejectedSafety =>
      'Não foi possível guardar uma cópia dos jogos salvos atuais, então nada foi substituído.';

  @override
  String get newsBackupReminderTitle => 'Hora de fazer uma cópia';

  @override
  String get newsBackupReminderBody =>
      'Seus jogos salvos estão só neste telefone. Abra Ajustes e toque em Cópia na nuvem, ou ative a cópia automática por lá. Estes lembretes também podem ser desligados em Ajustes.';

  @override
  String get backupSafetyTitle => 'Cópias de antes de uma restauração';

  @override
  String get backupSafetyBlurb =>
      'Guardadas neste telefone caso uma restauração tenha sido um engano. As três mais recentes ficam.';

  @override
  String get backupSafetyRestore => 'RESTAURAR';

  @override
  String get backupSafetyShare => 'COMPARTILHAR';

  @override
  String get backupCloudNoDetails => 'Os detalhes ainda estão a caminho.';

  @override
  String get tacticsLibraryTitle => 'BIBLIOTECA DE TÁTICAS';

  @override
  String get tacticsLibraryBlurb =>
      'As táticas da sua biblioteca podem ser carregadas em qualquer gravação, inclusive nas novas. Funções e cobradores de bola parada ficam guardados por posição, não por jogador.';

  @override
  String get tacticsSaveToLibrary => 'Guardar na biblioteca';

  @override
  String get tacticsLoadFromLibrary => 'Carregar da biblioteca';

  @override
  String get tacticsLibraryEmpty =>
      'Sua biblioteca está vazia. Guarde uma tática aqui e poderá carregá-la em qualquer gravação.';

  @override
  String tacticsLibrarySaved(String name) {
    return '“$name” guardada na biblioteca';
  }

  @override
  String tacticsLibraryLoaded(String name) {
    return '“$name” carregada';
  }

  @override
  String tacticsLibraryNotFitted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count funções ou cobradores de bola parada não couberam nesta seleção.',
      one: '1 função ou cobrador de bola parada não coube nesta seleção.',
    );
    return '$_temp0';
  }

  @override
  String get tacticsLibraryRename => 'Renomear';

  @override
  String get tacticsLibraryRenameTitle => 'Renomear tática';

  @override
  String get tacticsLibraryDelete => 'Eliminar';

  @override
  String tacticsLibraryDeleteTitle(String name) {
    return 'Eliminar “$name”?';
  }

  @override
  String get tacticsLibraryDeleteBody =>
      'Ela sai da biblioteca em todas as suas gravações.';

  @override
  String get tacticsLibraryNameTaken =>
      'Sua biblioteca já tem uma tática com esse nome.';

  @override
  String tacticsLibraryCouldNotLoad(String error) {
    return 'Não foi possível carregar a biblioteca.\n$error';
  }

  @override
  String hostBidHeading(String competition, int year) {
    return 'Candidatura a sede: $competition $year';
  }

  @override
  String get hostBidScreenTitle => 'Candidatura';

  @override
  String get hostBidBlurb =>
      'A sede é sorteada entre os candidatos. Uma candidatura dá mais peso ao seu nome: os seus estádios garantem uma chance inicial e o dinheiro a aumenta, embora cada milhão a mais conte um pouco menos. O dinheiro é gasto, ganhe ou não.';

  @override
  String hostBidPrize(String amount) {
    return 'Se vencer, será a sede, ficará classificado automaticamente e receberá um apoio único de $amount para o próximo orçamento.';
  }

  @override
  String get hostBidChance => 'Chance de ser sede';

  @override
  String get hostBidBaseLabel => 'Estádios e prestígio';

  @override
  String get hostBidInvestLabel => 'Investimento';

  @override
  String hostBidCeiling(String nation, String percent) {
    return 'Teto para $nation: $percent';
  }

  @override
  String get hostBidInvestment => 'O seu investimento';

  @override
  String hostBidFreeFunds(String amount) {
    return 'Fundos livres: $amount';
  }

  @override
  String get hostBidSubmit => 'Apresentar candidatura';

  @override
  String get hostBidDecline => 'Desta vez não';

  @override
  String get hostBidUnavailable => 'Esta candidatura já não está aberta.';

  @override
  String hostBidWonTitle(String competition, int year) {
    return 'Candidatura vencedora: $competition $year';
  }

  @override
  String hostBidWonBody(String amount) {
    return 'Vamos receber o torneio e, como sede, estamos classificados automaticamente. Um apoio único de $amount já está nos fundos da federação, e você pode distribuí-lo pelos departamentos deste ciclo direto da tela principal.';
  }

  @override
  String hostBidLostTitle(String competition, int year) {
    return 'Candidatura derrotada: $competition $year';
  }

  @override
  String hostBidLostBody(String hosts) {
    return 'A sede ficou com: $hosts. Desta vez a nossa candidatura não bastou e o dinheiro investido foi perdido, mas a federação defendeu o seu projeto.';
  }

  @override
  String get hostBidGrantEvent => 'Distribuir o apoio de sede';

  @override
  String hostBidGrantBanner(String amount) {
    return 'Apoio de sede: $amount para somar já aos departamentos deste ciclo. O que já foi distribuído fica, e o que sobrar continua em caixa.';
  }

  @override
  String get stadiumsTitle => 'Estádios nacionais';

  @override
  String get stadiumsEntrySub => 'Melhore um estádio ou construa um novo';

  @override
  String get stadiumsBlurb =>
      'O nível de um estádio é o seu tamanho: nível 1 abaixo de 15.000 lugares, nível 2 a partir de 15.000, nível 3 a partir de 25.000, nível 4 a partir de 40.000, nível 5 a partir de 60.000. Cada estádio rende uma pequena receita no início de cada ciclo, mais quanto mais lugares tiver, enquanto os adeptos os encherem. Uma melhoria acrescenta lugares de imediato e alguma reputação a partir do ciclo seguinte; uma redução corta a manutenção, mas não reembolsa nada. Os seus estádios decidem a que torneios se pode candidatar.';

  @override
  String stadiumsIncome(String amount) {
    return 'Receita dos estádios: $amount por ciclo';
  }

  @override
  String stadiumsReputation(int points) {
    return 'Reputação pelos estádios: +$points';
  }

  @override
  String get stadiumsClosed =>
      'As obras são encomendadas no início de um ciclo, antes de definir o orçamento.';

  @override
  String stadiumsCapacity(String seats) {
    return 'Capacidade: $seats';
  }

  @override
  String stadiumsLevel(int level, int max) {
    return 'Nível $level/$max';
  }

  @override
  String stadiumsUpgrade(String cost) {
    return 'Melhorar: $cost';
  }

  @override
  String get stadiumsTopLevel => 'Nível máximo';

  @override
  String stadiumsOpens(int year) {
    return 'Em construção, inaugura em $year';
  }

  @override
  String get stadiumsBuildTitle => 'Construir um novo estádio';

  @override
  String get stadiumsBuildBody =>
      'Bastante caro: um novo estádio na cidade que escolher, aberto a partir do início do próximo ciclo.';

  @override
  String get stadiumsBuildCity => 'Cidade';

  @override
  String stadiumsBuildButton(String cost) {
    return 'Construir: $cost';
  }

  @override
  String get stadiumsBuilding => 'Já há um estádio em construção.';

  @override
  String get stadiumsNoCity => 'Todas as cidades já têm um estádio novo.';

  @override
  String stadiumsConfirmUpgrade(String stadium, int level, String cost) {
    return 'Melhorar $stadium para o nível $level por $cost?';
  }

  @override
  String stadiumsConfirmBuild(String city, String cost) {
    return 'Construir um novo estádio em $city por $cost?';
  }

  @override
  String get stadiumsConfirm => 'Confirmar';

  @override
  String get stadiumsCancel => 'Cancelar';

  @override
  String get stadiumsRefused => 'A encomenda não foi feita. Nada foi cobrado.';

  @override
  String get stadiumsNameLabel => 'Nome do estádio';

  @override
  String get stadiumsNameHint => 'Deixe em branco para manter o nome sugerido.';

  @override
  String get stadiumsRename => 'Renomear estádio';

  @override
  String get hostBidSectionTitle => 'Candidaturas a sede';

  @override
  String get hostBidOpenSub =>
      'Opcional. Decida antes de começar o novo ciclo.';

  @override
  String get hostBidDecidedAtRollover =>
      'A sede é anunciada quando começa o novo ciclo.';

  @override
  String get hostBidLodged =>
      'Candidatura apresentada. A sede é anunciada quando começa o novo ciclo.';

  @override
  String get hostBidDeclinedNote => 'Desta vez optou por não se candidatar.';

  @override
  String get hostBidOpensLater =>
      'Cumpre os requisitos. Pode candidatar-se no fim deste ciclo.';

  @override
  String get hostBidNoFunds =>
      'Não há fundos livres suficientes para a candidatura.';

  @override
  String hostBidNeedStadiums(int count, String seats) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Faltam-lhe $count estádios de $seats+ lugares.',
      one: 'Falta-lhe 1 estádio de $seats+ lugares.',
    );
    return '$_temp0';
  }

  @override
  String hostBidBarredConf(String confederation) {
    return '$confederation recebeu o último Campeonato Mundial.';
  }

  @override
  String get hostBidRecentHost => 'Recebeu uma das três últimas edições.';

  @override
  String hostBidRequirement(
    int grounds,
    String minSeats,
    int bigGrounds,
    String bigSeats,
  ) {
    return 'Requisito: $grounds estádios de $minSeats+ lugares, $bigGrounds deles com $bigSeats+.';
  }

  @override
  String hostBidWonBodyBudget(String amount) {
    return 'Vamos receber o torneio e estamos qualificados automaticamente como anfitriões. Um apoio único de $amount já está nos fundos da federação, pronto para o orçamento deste ciclo.';
  }

  @override
  String get hubStadiumIncome => 'Receitas dos estádios';

  @override
  String get stadiumsDownsize => 'Reduzir';

  @override
  String stadiumsConfirmDownsize(String stadium, String seats, int level) {
    return 'Reduzir $stadium para $seats lugares (nível $level)? Nada é reembolsado, mas a manutenção baixa.';
  }

  @override
  String get stadiumsResizedThisCycle => 'Remodelado neste ciclo';

  @override
  String stadiumsGroundIncome(String amount) {
    return 'Rende $amount por ciclo';
  }

  @override
  String hostBidLapsedTitle(String competition, int year) {
    return 'Candidatura retirada: $competition $year';
  }

  @override
  String hostBidLapsedBodyNation(String nation) {
    return 'A candidatura era para $nation e começa o novo ciclo noutro lado. Foi retirada e nada foi cobrado.';
  }

  @override
  String get hostBidLapsedBodyFunds =>
      'No fecho do ciclo, os fundos da federação já não cobriam a aposta. A candidatura foi retirada e nada foi cobrado.';

  @override
  String get stadiumsViewMap => 'Mapa';

  @override
  String get stadiumsViewList => 'Lista';

  @override
  String get stadiumsMapPickCity =>
      'Toque numa cidade para construir lá um novo estádio.';

  @override
  String get stadiumsMapFit => 'Ver o país inteiro';

  @override
  String get campaignLegacyTitle => 'Completar o legado';

  @override
  String get campaignLegacyTwist =>
      'A Espanha, atual campeã europeia, por um ciclo';

  @override
  String get campaignLegacyGoal => 'Defender o título europeu';

  @override
  String get campaignLegacyIntro =>
      'A Espanha é a atual campeã europeia e os céticos dizem que a fase dourada foi obra do acaso. Você tem um ciclo para provar o contrário: defenda a coroa continental e depois vá atrás do mundo. Some a Copa das Nações e o legado estará completo.';

  @override
  String get campaignStars1Legacy => 'Vencer o Campeonato Europeu';

  @override
  String get campaignStars2Legacy => 'E o Campeonato Mundial';

  @override
  String get campaignStars3Legacy => 'E a Copa das Nações';

  @override
  String get campaignSectionOneCycle => 'Um ciclo';

  @override
  String get campaignSectionShort => 'Poucos ciclos';

  @override
  String get campaignSectionLong => 'Longo prazo';

  @override
  String get campaignFilterAll => 'Todas';

  @override
  String get campaignFilterNew => 'Não jogadas';

  @override
  String get campaignFilterInProgress => 'Em andamento';

  @override
  String get campaignFilterDone => 'Concluídas';

  @override
  String get campaignFilterEmpty => 'Ainda não há campanhas aqui.';

  @override
  String campaignStarsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count estrelas',
      one: '1 estrela',
      zero: 'Sem estrelas',
    );
    return '$_temp0';
  }

  @override
  String campaignCycles(int cycles) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles ciclos',
      one: '1 ciclo',
    );
    return '$_temp0';
  }

  @override
  String get msgIntlRetireNoteHigh => ' Ele sai por cima, como campeão.';

  @override
  String get msgIntlRetireNoteMissed =>
      ' Ficar fora da fase final foi a gota d\'água.';

  @override
  String get msgIntlRetireNoteSurprise => ' Ninguém esperava por isso.';

  @override
  String get msgIntlRetireNoteRecord => ' Ele sai como recordista da seleção.';

  @override
  String msgIntlRetireNewsTitle(String nation, String name) {
    return '$nation: $name se despede da seleção';
  }

  @override
  String msgIntlRetireNewsBody(String name, String nation, int age) {
    return '$name ($nation) anunciou a aposentadoria da seleção aos $age anos.';
  }

  @override
  String msgIntlComebackTitle(String name) {
    return '$name volta à seleção';
  }

  @override
  String msgIntlComebackBody(String name, int age) {
    return '$name está de novo à disposição para convocação, aos $age anos.';
  }

  @override
  String get msgIntlComebackNoteCrisis =>
      ' Com o elenco castigado por lesões, ele atendeu ao chamado.';

  @override
  String get msgIntlComebackNoteManager => ' O novo técnico o convenceu.';

  @override
  String msgIntlComebackNewsTitle(String nation, String name) {
    return '$nation: $name volta à seleção';
  }

  @override
  String msgIntlComebackNewsBody(String name, String nation, int age) {
    return '$name ($nation) está de novo à disposição para convocação, aos $age anos.';
  }

  @override
  String playerIntlRetired(int year) {
    return 'Aposentado da seleção, $year';
  }

  @override
  String playerIntlComeback(int year) {
    return 'Voltou à seleção, $year';
  }

  @override
  String yLegendRetires0(String name) {
    return 'Obrigado, $name. Uns vestem a camisa, ele a carregou nas costas.';
  }

  @override
  String yLegendRetires1(String name) {
    return '$name encerra a carreira na seleção. Fim de uma era.';
  }

  @override
  String yLegendRetires2(String name) {
    return '$name se aposenta. Um torneio tarde demais, sendo sincero.';
  }

  @override
  String yLegendRetires3(String name) {
    return 'Então $name parou. Hora de dar chance aos jovens.';
  }

  @override
  String matchAltitudeOpponentsTire(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'Altitude $altitudeString m: o adversário vai cansar mais rápido';
  }

  @override
  String matchAltitudeYouTire(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'Altitude $altitudeString m: seus jogadores vão cansar mais rápido';
  }

  @override
  String matchAltitudeBothTire(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'Altitude $altitudeString m: as duas equipes vão cansar mais rápido';
  }

  @override
  String matchAltitudeUsedTo(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'Altitude $altitudeString m: as duas equipes estão acostumadas';
  }

  @override
  String matchHeatExpected(int temp) {
    final intl.NumberFormat tempNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String tempString = tempNumberFormat.format(temp);

    return 'Calor: $tempString °C previstos, as pernas vão pesar mais cedo';
  }

  @override
  String get matchConditionsAdvice =>
      'Planeje as substituições cedo: aqui pernas descansadas valem mais';

  @override
  String get fanMoodFurious => 'furiosos';

  @override
  String get fanMoodRestless => 'inquietos';

  @override
  String get fanMoodCalm => 'tranquilos';

  @override
  String get fanMoodUpbeat => 'animados';

  @override
  String get fanMoodEuphoric => 'eufóricos';

  @override
  String matchHomeFans(String mood) {
    return 'Adeptos da casa: $mood';
  }

  @override
  String federationFans(String mood) {
    return 'Adeptos: $mood';
  }

  @override
  String federationFansIncome(String change) {
    return 'Receita dos estádios no próximo ciclo: $change';
  }

  @override
  String yFansProtest0(String nation, String manager) {
    return 'Vinte anos a seguir a seleção em casa e fora. Não renovo o lugar anual enquanto nada mudar.';
  }

  @override
  String yFansProtest1(String nation, String manager) {
    return 'Vamos continuar a cantar pela camisola. Mas a tarja na bancada norte disse hoje o que todos pensamos.';
  }

  @override
  String yFansProtest2(String nation, String manager) {
    return 'Meio estádio vazio, e a outra metade passou a segunda parte a gritar #${manager}Out.';
  }

  @override
  String yFansProtest3(String nation, String manager) {
    return 'Os grupos organizados falam em boicotar o próximo jogo em casa. Difícil censurá-los.';
  }

  @override
  String yFansProtest4(String nation, String manager) {
    return '#${manager}Out. Já nem estou zangado. Simplesmente acabou.';
  }

  @override
  String yFansProtest5(String nation, String manager) {
    return 'Foto desta noite: filas de cadeiras vazias e um lençol a dizer #${manager}Out. Eis a crónica do jogo.';
  }

  @override
  String yFansSellOut0(String nation) {
    return 'Esgotado outra vez. A melhor seleção em anos, e o país inteiro sabe disso.';
  }

  @override
  String yFansSellOut1(String nation) {
    return 'Os bilhetes do próximo jogo em casa esgotaram em onze minutos. Esta equipa devolveu-nos os fins de semana.';
  }

  @override
  String yFansSellOut2(String nation) {
    return 'Nem um lugar livre para o próximo jogo em casa. A federação vai contar a receita de bilheteira a sorrir.';
  }

  @override
  String yFansSellOut3(String nation) {
    return 'Mais um esgotado. Digam o que quiserem da tática: as pessoas querem estar naquele estádio.';
  }

  @override
  String yFansSellOut4(String nation) {
    return 'Esgotado, está bem. As mesmas pessoas assobiavam esta equipa há ano e meio.';
  }

  @override
  String yFansSellOut5(String nation) {
    return 'De repente esgotado, de repente todos especialistas. Onde estavam quando não ganhávamos a ninguém?';
  }

  @override
  String get campaignsIntro =>
      'As campanhas são desafios feitos à mão: uma seleção definida, um mundo com uma reviravolta própria e um objetivo a cumprir num número fixo de ciclos. Cada percurso fica separado das suas carreiras salvas, e quanto mais longe você for, mais estrelas ganha, até três.';

  @override
  String hubEventScandal(String player) {
    return 'Escândalo na concentração: $player';
  }

  @override
  String get hubEventScandalSub => 'Mandá-lo para casa ou mantê-lo?';

  @override
  String get scandalTitle => 'ESCÂNDALO';

  @override
  String scandalStoryParty(String player) {
    return '$player esteve numa festa que durou até de madrugada, e as fotos estavam em todos os jornais na manhã em que a seleção se reuniu.';
  }

  @override
  String scandalStoryCurfew(String player) {
    return '$player desrespeitou o toque de recolher e foi apanhado a voltar ao hotel de madrugada.';
  }

  @override
  String scandalStoryNightclub(String player) {
    return '$player foi fotografado numa discoteca na véspera da concentração, e as imagens estão por todo o lado.';
  }

  @override
  String scandalStoryCasino(String player) {
    return '$player passou a noite antes da concentração numa mesa de casino, e um tabloide tem as fotos.';
  }

  @override
  String get scandalSendHome => 'Mandá-lo para casa';

  @override
  String scandalSendHomeCover(String player) {
    return 'Para casa, convocar $player';
  }

  @override
  String scandalKeep(String player) {
    return 'Manter $player';
  }

  @override
  String get scandalKeepNote =>
      'Se ficar: moral cerca de -4 e direção cerca de -3 até ao fim do ciclo.';

  @override
  String get scandalSendHomeNote =>
      'Se o mandar para casa: sem custo para a moral nem para a direção, e pode convocar um substituto.';

  @override
  String get scandalFinalsNote =>
      'Se o mandar para casa: sem custo para a moral nem para a direção, mas numa fase final ninguém o pode substituir.';

  @override
  String get scandalPickCover => 'Convocar um substituto (opcional)';

  @override
  String newsScandalTitle(String player) {
    return 'Escândalo na concentração: $player';
  }

  @override
  String yScandalParty0(String player, String tag) {
    return 'São miúdos. $player numa festa na noite antes da concentração, e mesmo assim quero-o em campo. #$tag';
  }

  @override
  String yScandalParty1(String player, String tag) {
    return '$player fotografado numa festa pela noite dentro, horas antes de a seleção se reunir. A federação foi informada. #$tag';
  }

  @override
  String yScandalParty2(String player, String tag) {
    return 'Festa pela noite dentro antes da concentração. $player, em que estavas a pensar? Inacreditável. #$tag';
  }

  @override
  String yScandalCurfew0(String player, String tag) {
    return 'Voltou depois do toque de recolher, pronto, acontece. $player só tem de compensar em campo. #$tag';
  }

  @override
  String yScandalCurfew1(String player, String tag) {
    return '$player apanhado a voltar ao hotel da equipa depois do toque de recolher, horas antes do treino. #$tag';
  }

  @override
  String yScandalCurfew2(String player, String tag) {
    return 'O toque de recolher não é complicado. $player não aguentou uma única noite. #$tag';
  }

  @override
  String yScandalNightclub0(String player, String tag) {
    return 'Pronto, $player esteve numa discoteca. Os futebolistas também têm vida. Deixem-no jogar. #$tag';
  }

  @override
  String yScandalNightclub1(String player, String tag) {
    return 'Fotos mostram $player numa discoteca na véspera da concentração da seleção. #$tag';
  }

  @override
  String yScandalNightclub2(String player, String tag) {
    return 'Fotos numa discoteca na véspera da concentração. $player envergonhou a camisola. #$tag';
  }

  @override
  String yScandalCasino0(String player, String tag) {
    return 'Uma noite no casino não é crime. $player vai ficar bem. #$tag';
  }

  @override
  String yScandalCasino1(String player, String tag) {
    return '$player visto numa mesa de casino na noite antes de a seleção se reunir. #$tag';
  }

  @override
  String yScandalCasino2(String player, String tag) {
    return 'A noite toda no casino antes da concentração. $player apostou mais do que dinheiro. #$tag';
  }

  @override
  String yScandalSentHome0(String player) {
    return 'Decisão certa. Ninguém é maior do que a equipa, nem mesmo $player.';
  }

  @override
  String yScandalSentHome1(String player) {
    return 'Mandar $player para casa era a única resposta. Respeito pelo selecionador.';
  }

  @override
  String yScandalSentHome2(String player) {
    return 'Disciplina é disciplina. $player conhecia as regras.';
  }

  @override
  String yScandalSentHome3(String player) {
    return 'Uma mensagem clara ao grupo: $player já está no avião de volta.';
  }

  @override
  String yScandalSentHome4(String player) {
    return 'Duro para $player. Uma noite fora e acabou-se a concentração?';
  }

  @override
  String yScandalSentHome5(String player) {
    return 'Mandar $player para casa enfraquece-nos. Vamos pagar isto em campo.';
  }

  @override
  String yScandalKept0(String player) {
    return 'Manter $player é uma aposta. É bom que a pague em campo.';
  }

  @override
  String yScandalKept1(String player) {
    return 'Está bem, $player fica. Então deve uma grande exibição a todos.';
  }

  @override
  String yScandalKept2(String player) {
    return 'Então as regras não se aplicam a $player. É bom saber.';
  }

  @override
  String yScandalKept3(String player) {
    return 'Pelos vistos o toque de recolher agora é opcional. Perguntem a $player.';
  }

  @override
  String yScandalKept4(String player) {
    return 'Manter $player depois disto? Esta seleção é uma colónia de férias.';
  }

  @override
  String yScandalKept5(String player) {
    return 'Festa a noite toda e depois direto para o onze inicial. Bela mensagem, mister. $player deve estar encantado.';
  }

  @override
  String get yStreamerBreaks0 =>
      'O MANO FOI APANHADO 😭😭 NA NOITE ANTES DA CONCENTRAÇÃO?? ESTOU A CHORAR 💀💀💀';

  @override
  String get yStreamerBreaks1 =>
      'NÃOOO CHAT OLHEM PARA ISTO 🤯🤯 O MANO FEZ MESMO ISSO ANTES DA CONCENTRAÇÃO 😭🔥';

  @override
  String get yStreamerBreaks2 =>
      'QUEM O DEIXOU SAIR?? QUEM O DEIXOU SAIR 😭😭💀 ISTO É CINEMA 🔥🔥';

  @override
  String get yStreamerSentHome0 =>
      'PARA CASA?? PARA CASA!!! 😭😭😭 O MISTER NÃO ESTÁ PARA BRINCADEIRAS 💀🔥';

  @override
  String get yStreamerSentHome1 =>
      'O MANO A FAZER AS MALAS EM DIRETO 🤯🤯 ADEUS MANO 😭👋';

  @override
  String get yStreamerSentHome2 =>
      'NÃO PODE SEEER MANDARAM-NO PARA CASA 💀💀 CHAT ESTOU A TREMER 🔥🔥🔥';

  @override
  String get yStreamerKept0 => 'FICA??? FICAAA 🤯🤯 O MANO É INTOCÁVEL 😭🔥';

  @override
  String get yStreamerKept1 =>
      'FESTA A NOITE TODA E AINDA NA CONVOCATÓRIA 💀💀 QUERO ESSE CONTRATO 😭😭';

  @override
  String get yStreamerKept2 =>
      'O MISTER DIZ QUE ESTÁ TUDO BEM 😭😭 MANO O QUÊ 🤯🤯🤯';

  @override
  String get yCameoUjfaloci =>
      'Não paguei nada, e esse valor também não bate certo';

  @override
  String get yCameoHavir0 => 'Os peixinhos fugiram a nado.';

  @override
  String get yCameoHavir1 =>
      'Lançámos as redes, os peixes estavam noutro sítio.';

  @override
  String get yCameoHavir2 =>
      'Eu já tinha dito em setembro, à frente de um goulash.';

  @override
  String get yCameoHavir3 => 'Quem não pescou a tempo, que não chore agora.';

  @override
  String get yCameoHavir4 => 'Jogámos como um siluro fora de água.';

  @override
  String get yCameoHavir5 => 'Sopra o vento, gela o lago. É assim a vida.';

  @override
  String get yCameoHavir6 => 'Há dias em que só se tira uma bota velha.';

  @override
  String get yCameoHavir7 =>
      'No meu tempo ao menos íamos beber uma cerveja. Agora nem isso.';

  @override
  String get yCameoLzimberskyHome0 =>
      'Mandar um miúdo para casa por causa de uma noite? O escândalo é isso, não a festa!';

  @override
  String get yCameoLzimberskyHome1 =>
      'Os rapazes têm direito a divertir-se! Os media hipócritas voltam a ganhar.';

  @override
  String get yCameoLzimberskyHome2 =>
      'Isto é uma caça às bruxas. Um jovem sai uma noite e vocês enforcam-no.';

  @override
  String get yCameoLzimberskyHome3 =>
      'O jornalista que nunca foi a uma festa que atire a primeira pedra. Que vergonha!';

  @override
  String get yCameoLzimberskyHome4 =>
      'O selecionador teve medo dos tabloides. Eu defendia o miúdo até ao último suspiro!';

  @override
  String get yCameoLzimberskyKept0 =>
      'Finalmente um selecionador com coragem! Manteve o miúdo e os media que chorem.';

  @override
  String get yCameoLzimberskyKept1 =>
      'Os rapazes têm direito a divertir-se, certo? Bravo, mister!';

  @override
  String get yCameoLzimberskyKept2 =>
      'Os media hipócritas gritam, o selecionador aguenta firme. É assim que se faz!';

  @override
  String get yCameoLzimberskyKept3 =>
      'Uma noite fora e a imprensa quer apedrejá-lo. O selecionador é um homem a sério!';

  @override
  String get yCameoLzimberskyKept4 =>
      'Eu digo: deixem os miúdos viver! Quem trabalha muito também se pode divertir. Polegar para cima.';

  @override
  String get yTraitStreamer =>
      'Transmite tudo em direto, no volume máximo, em maiúsculas.';

  @override
  String hubEventAwardsCeremony(int year) {
    return 'Jogador do Ano $year';
  }

  @override
  String get hubEventAwardsCeremonySub => 'Os votos foram contados';

  @override
  String get potyCeremonyWatch => 'Assistir à cerimônia';

  @override
  String get potyCeremonySkipToList => 'Pular para o top 5';

  @override
  String get potyCeremonySkip => 'Pular';

  @override
  String get potyCeremonyIntro =>
      'Os votos foram contados. Estes são os cinco melhores jogadores do mundo neste ano.';

  @override
  String potyCeremonyPlace(int place) {
    return '$placeº lugar';
  }

  @override
  String get potyCeremonyWinnerIs => 'E o Jogador do Ano é...';

  @override
  String get potyTop5Heading => 'O top 5 do mundo';

  @override
  String get potyYoungTop3Heading => 'Jovem Jogador do Ano: top 3';

  @override
  String get potySeeTop5 => 'Ver o top 5';

  @override
  String get potyYourPlayer => 'Seu jogador';

  @override
  String potyTallyCleanSheets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jogos sem sofrer gols',
      one: '1 jogo sem sofrer gols',
    );
    return '$_temp0';
  }

  @override
  String get campaignFullBrief => 'Briefing completo';

  @override
  String campaignStarsSoFar(int earned, int total) {
    return 'Estrelas conquistadas até agora: $earned de $total';
  }

  @override
  String get campaignStarEarned => 'Conquistada até agora';

  @override
  String get campaignStarNotYet => 'Ainda não conquistada';

  @override
  String get stadiumsEntrySubClosed =>
      'Veja os seus estádios. As obras voltam a abrir no início do próximo ciclo.';

  @override
  String get boardObjectiveNoBrief => 'Sem objetivo definido';

  @override
  String get boardObjectiveNoBriefBody =>
      'A direção não espera que chegue a esta fase final. Vai julgá-lo antes pelos resultados.';

  @override
  String get boardObjectiveAwaitingDraw => 'Objetivo após o sorteio';

  @override
  String get boardObjectiveAwaitingDrawBody =>
      'A direção define este objetivo assim que os grupos forem sorteados.';
}
