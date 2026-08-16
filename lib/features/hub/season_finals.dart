part of 'hub_providers.dart';

/// The intercontinental play-off and the finals field it feeds.
///
/// The delicate part of a cycle: the bracket the manager plays, the bracket
/// the screen shows and the field the draw uses must be the same six teams
/// with the same winners, or the finals contain a nation the bracket says
/// lost. Split out of [SeasonService] for navigability only — same library,
/// same state.
extension SeasonFinals on SeasonService {
  /// Between qualifying ending and the finals being drawn, resolve the
  /// intercontinental play-off.
  ///
  /// When the manager's nation is NOT among the six entrants (the common case)
  /// this generates the finals exactly as before — every tie decided by the
  /// deterministic model, zero behaviour change. When they ARE an entrant, the
  /// ties on their side of the bracket become real, playable knockouts: a semi
  /// if they were not seeded into a bye, then the path final if they win it.
  /// The finals wait until those are played, and the played winners are fed
  /// back into finalist selection AND into the bracket screen, so all three
  /// tell the same story. Any unexpected pool shape falls back to the instant
  /// path, so this can never stall the cycle.
  Future<void> _progressPlayoff(int careerId) async {
    final career = await _careers.byId(careerId);
    if (career == null) return;

    final tables = await _comp.allGroupTablesByConfederation(careerId);
    final grouped = <Confederation, List<List<GroupStanding>>>{};
    for (final t in tables) {
      (grouped[t.confederation] ??= []).add(t.standings);
    }
    await _ensureRank(careerId);
    final nations = await _nationsById();
    // The seeding is frozen the first time the play-off is looked at. The
    // manager's own tie moves the live ranking, and a bracket that reseeded
    // itself between his semi and his final could hand him a different
    // opponent from the one he was shown.
    final rankingById = await _playoffRanking(careerId, career, nations);
    final pool = WorldCupFinals.playoffPoolFor(
      byConfederation: grouped,
      rankingById: rankingById,
    );
    final me = career.nationId;
    final path = playoffPathOf(
      pool: pool,
      rankingById: rankingById,
      nationId: me,
    );

    // Not the standard six, or the manager sits it out → decide instantly, as
    // the game always has.
    if (path == null) {
      await _generateFinals(careerId);
      return;
    }

    const kind = CompetitionKind.worldCupPlayoff;
    final semis = await _comp.fixturesByRound(
      careerId,
      playoffSemiFixtureRound,
      kind: kind,
    );
    final finals = await _comp.fixturesByRound(
      careerId,
      playoffFinalFixtureRound,
      kind: kind,
    );
    final played = playoffPlayed(path: path, semis: semis, finals: finals);

    // The bracket as it stands, with anything already played written into it.
    // Both the opponent lookup below and the screen build it this way, off the
    // same seed, so they cannot disagree.
    List<PlayoffTie> bracket() => WorldCupFinals.playoffBracket(
      byConfederation: grouped,
      rankingById: rankingById,
      rng: _playoffRng(career),
      pool: pool,
      playedResults: played.results,
      playedScores: played.scores,
    );

    Future<void> finish() async {
      final winners = WorldCupFinals.playoffWinners(
        pool,
        rankingById,
        _playoffRng(career),
        playedResults: played.results,
      );
      await _generateFinals(careerId, playoffWinners: winners);
    }

    final semiSlot = path.semiSlot;
    if (semiSlot != null) {
      if (semis.isEmpty) {
        final tie = bracket()[semiSlot];
        await _createPlayoffTie(
          careerId: careerId,
          career: career,
          nations: nations,
          me: me,
          opponent: tie.home == me ? tie.away : tie.home,
          round: playoffSemiFixtureRound,
          firstTie: true,
        );
        return;
      }
      if (!semis.first.hasResult) return; // still to be played
      final semiKey = WorldCupFinals.tieKey(
        round: WorldCupFinals.playoffSemiRound,
        slot: semiSlot,
      );
      if (played.results[semiKey] != me) {
        // Beaten in the semi — the rest of the bracket is settled by the model
        // and the manager's World Cup is over, but on the pitch this time.
        await finish();
        return;
      }
    }

    if (finals.isEmpty) {
      final tie = bracket().where((t) => t.isFinal).toList()[path.finalSlot];
      await _createPlayoffTie(
        careerId: careerId,
        career: career,
        nations: nations,
        me: me,
        opponent: tie.home == me ? tie.away : tie.home,
        round: playoffFinalFixtureRound,
        firstTie: semis.isEmpty,
      );
      return;
    }
    if (!finals.first.hasResult) return; // still to be played
    await finish();
  }

  /// The rng the whole play-off is decided on — the same stream the finalist
  /// selection and the bracket screen use, so the three agree.
  SeededRng _playoffRng(Career career) =>
      SeededRng(career.rngSeed ^ (career.cyclePointer * 0x50FF) ^ 0xB1A0);

  /// The ranking the play-off is seeded on, snapshotted on first use so the
  /// bracket cannot reseed itself mid-tie.
  Future<Map<int, int>> _playoffRanking(
    int careerId,
    Career career,
    Map<int, Nation> nations,
  ) async {
    final cycle = drawSeedCycle(career.cyclePointer, drawSlotWorldCupPlayoff);
    final repo = _ref.read(seedRankingRepositoryProvider);
    final stored = await repo.forCycle(careerId, cycle);
    if (stored.isNotEmpty) return stored;
    final live = _liveRankById(nations);
    await repo.snapshot(careerId, cycle, live);
    return live;
  }

  /// Schedules one of the manager's play-off ties. The first tie creates the
  /// competition; a later round is added to it.
  Future<void> _createPlayoffTie({
    required int careerId,
    required Career career,
    required Map<int, Nation> nations,
    required int me,
    required int opponent,
    required String round,
    required bool firstTie,
  }) async {
    // Dated just ahead so it is the manager's next match, never in the past
    // where the catch-up sim would take it off him.
    final date = career.inGameDate.add(const Duration(days: 7));
    if (firstTie) {
      await _comp.createKnockout(
        careerId: careerId,
        cycle: career.cyclePointer,
        confederation: nations[me]?.confederation ?? Confederation.europe,
        kind: CompetitionKind.worldCupPlayoff,
        name: 'Intercontinental Play-off',
        pairings: [(me, opponent)],
        date: date,
        firstRound: round,
      );
      return;
    }
    await _comp.addKnockoutFixtures(
      careerId: careerId,
      round: round,
      pairings: [(me, opponent)],
      date: date,
      kind: CompetitionKind.worldCupPlayoff,
    );
  }

  Future<void> _generateFinals(
    int careerId, {
    List<int>? playoffWinners,
  }) async {
    final career = await _careers.byId(careerId);
    if (career == null) return;

    final byConfederation = await _comp.allGroupTablesByConfederation(
      careerId,
    );
    final grouped = <Confederation, List<List<GroupStanding>>>{};
    for (final t in byConfederation) {
      (grouped[t.confederation] ??= []).add(t.standings);
    }

    final nations = await _nationsById();
    // Pot the finals by the LIVE world ranking as it stands now — after every
    // qualifying result — not the ranking frozen at the cycle's start. The
    // exact ranking used is snapshotted so the draw ceremony reproduces these
    // pots precisely.
    await _ensureRank(careerId);
    final rankingById = _liveRankById(nations);
    await _ref
        .read(seedRankingRepositoryProvider)
        .snapshot(
          careerId,
          drawSeedCycle(career.cyclePointer, drawSlotWorldCupFinals),
          rankingById,
        );
    final year = SeasonService.finalsYear(career.cyclePointer);

    // The hosts (primary + any co-hosts) qualify automatically. Finalist
    // selection is shared with the draw ceremony.
    final hosts = WorldCupHosts.hostsFor(
      year: year,
      nations: nations.values.toList(),
      seed: career.rngSeed,
    );
    final qualifiers = WorldCupFinals.selectFinalists(
      byConfederation: grouped,
      rankingById: rankingById,
      hosts: hosts,
      // When the manager played their own play-off tie, its real winners are
      // passed in and override the instant resolution below.
      playoffWinnersOverride: playoffWinners,
      playoffRng: SeededRng(
        career.rngSeed ^ (career.cyclePointer * 0x50FF) ^ 0xB1A0,
      ),
    );

    final draw = WorldCupFinals.drawGroups(
      qualifierIds: qualifiers,
      rankingById: rankingById,
      rngSeed: career.rngSeed ^ (career.cyclePointer * 0x2D31),
      hosts: hosts,
    );
    if (draw.groups.isEmpty) return;

    // The finals open in June of the World Cup year — but never in the past.
    // The draw waits on the slowest confederation's qualifying, so if that
    // ever overruns June the tournament would be created already-due and
    // _catchUp would resolve every round in one pass (crowning a champion with
    // nothing to watch). Anchoring to the in-game date keeps it step-by-step.
    final scheduled = DateTime(year, 6, 11);
    final inGame = career.inGameDate;
    await _comp.saveFinals(
      careerId: careerId,
      draw: draw,
      groupStart: scheduled.isAfter(inGame)
          ? scheduled
          : inGame.add(const Duration(days: 14)),
      cycle: career.cyclePointer,
    );

    // The field is set — if the manager's nation isn't in it, their qualifying
    // campaign came up short.
    if (!qualifiers.contains(career.nationId)) {
      await _comp.addMessage(
        careerId: careerId,
        dedupKey: 'wcmiss:$year',
        category: 'eliminated',
        title: 'World Cup dream over',
        body:
            "You didn't make the $year World Cup — the qualifying campaign "
            'fell short. Four more years.',
        year: year - 1,
      );
    }
  }
}
