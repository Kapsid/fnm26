part of 'hub_providers.dart';

/// Moving a cycle forward: what happens after a round of results is in.
///
/// Qualifying draws, the Nations Cup ladder, every confederation's cup, the
/// World Cup's own rounds and the honours each of them records. Split out of
/// [SeasonService] for navigability only — same library, same state.
extension SeasonCycle on SeasonService {
  Future<bool> _roundComplete(
    int careerId,
    String round, {
    CompetitionKind kind = CompetitionKind.worldCupFinals,
    Confederation? confederation,
  }) async {
    final fx = await _comp.fixturesByRound(
      careerId,
      round,
      kind: kind,
      confederation: confederation,
    );
    return fx.isNotEmpty && fx.every((f) => f.hasResult);
  }

  Future<DateTime> _maxDate(
    int careerId,
    String round, {
    CompetitionKind kind = CompetitionKind.worldCupFinals,
    Confederation? confederation,
  }) async {
    final fx = await _comp.fixturesByRound(
      careerId,
      round,
      kind: kind,
      confederation: confederation,
    );
    return fx.map((f) => f.date).reduce((a, b) => a.isAfter(b) ? a : b);
  }

  /// Creates the next competition stage when the current one finishes.
  /// Files the board's verdict on each of the cycle's objectives the moment
  /// that tournament is settled for the manager's nation — the cup is won, or
  /// their run in it is over.
  ///
  /// The board used to say nothing at all until the cycle rolled over, two
  /// years after a continental championship and weeks after a World Cup: the
  /// expectation was stated up front, the tournament was played, and the
  /// verdict on it only ever appeared inside the end-of-cycle summary. Both
  /// objectives are now graded and announced when they happen, so winning your
  /// continent is answered by the board in the same month you win it.
  ///
  /// Deduped per cycle and tier, so it is filed once however many times the
  /// world is stepped afterwards.
  Future<void> _gradeObjectivesIfDecided(int careerId) async {
    final career = await _careers.byId(careerId);
    if (career == null) return;
    // Grade from FRESH data. The objectives read the database imperatively, so
    // nothing about a played match invalidates them — and the hub keeps the
    // whole chain alive (its board strip watches satisfaction, which watches
    // the objectives), so this used to read a snapshot taken early in the cycle
    // where nothing was decided yet. The tournament was won or lost and the
    // board's verdict was graded against a cached "still to be decided",
    // which is why no verdict ever arrived, at the Euro or anywhere else.
    _ref.invalidate(cycleObjectiveOutcomesProvider(careerId));
    final objectives = await _ref.read(
      cycleObjectiveOutcomesProvider(careerId).future,
    );
    final l = _l;
    for (final o in objectives) {
      if (!o.decided) continue;
      final demand = objectiveDemandText(l, o.tier, o.target);
      final finish = objectiveFinishText(l, o.tier, o.actual);
      final comp = competitionLabel(l, o.competition);
      await _comp.addMessage(
        careerId: careerId,
        dedupKey: 'objective:${career.cyclePointer}:${o.tier.name}',
        category: 'board',
        title: o.met
            ? l.boardObjectiveMetTitle(comp)
            : l.boardObjectiveMissedTitle(comp),
        body: o.met
            ? l.boardObjectiveMetBody(comp, demand, finish)
            : l.boardObjectiveMissedBody(comp, demand, finish),
        year: career.inGameDate.year,
      );
    }
  }

  Future<void> _progress(int careerId) async {
    await _drawWorldCupQualifyingIfDue(careerId);
    await _progressWorldCup(careerId);
    await _progressContinental(careerId);
    await _progressNationsLeague(careerId);
    await _progressFinalissima(careerId);
  }

  /// Draws World Cup qualifying once the cycle reaches it.
  ///
  /// It used to be written with the rest of the calendar on the cycle's first
  /// day, so the World Cup groups existed before the continental championship
  /// that comes first had been played, and its "draw" ceremony was a replay of
  /// fixtures that had been in the database for two years. Drawing it here
  /// puts it in its proper place in the calendar.
  ///
  /// Drawn as soon as the manager's continental championship has a winner —
  /// that is the moment the cycle's first half is over — with the calendar date
  /// as a fallback.
  ///
  /// The fallback is not optional. `advance` moves the clock to the next
  /// unplayed fixture, so if the cup somehow never crowned a champion the
  /// calendar would empty, the date would stop, and a date-only trigger could
  /// never arrive: the save would stall with nothing left to play. Either
  /// condition alone is enough to draw.
  Future<void> _drawWorldCupQualifyingIfDue(int careerId) async {
    final career = await _careers.byId(careerId);
    if (career == null) return;
    final wcYear = SeasonService.finalsYear(career.cyclePointer);
    if (await _comp.hasTournament(
      careerId,
      CompetitionKind.worldCupQualifying,
    )) {
      return;
    }
    final conf = await _managerConfederation(careerId);
    final contDecided =
        conf != null &&
        await _comp.continentalChampion(careerId, confederation: conf) != null;
    if (!contDecided &&
        !CareerService.wcQualifyingDue(career.inGameDate, wcYear)) {
      return;
    }
    // Seed the pots from the LIVE ranking, snapshotted here so the ceremony
    // reproduces exactly the pots the draw used. It used to read the cycle-start
    // baseline, frozen two years earlier — a nation that had climbed to number
    // one in the meantime was still drawn out of the pot it started the cycle
    // in, which is the one thing a draw must never get wrong.
    await _ensureRank(careerId);
    final nations = await _nationsById();
    final seedRank = _liveRankById(nations);
    await _ref
        .read(seedRankingRepositoryProvider)
        .snapshot(
          careerId,
          drawSeedCycle(career.cyclePointer, drawSlotWorldCupQualifying),
          seedRank,
        );
    await CareerService.buildWorldCupQualifying(
      comp: _comp,
      nations: nations.values.toList(),
      careerId: careerId,
      nationId: career.nationId,
      rngSeed: career.rngSeed,
      cycle: career.cyclePointer,
      wcYear: wcYear,
      rankById: seedRank.isEmpty ? null : seedRank,
    );
  }

  /// Progresses the Nations Cup: once the groups are done, the four group
  /// winners contest a Finals Four (two semi-finals then a final); the final's
  /// winner takes the title. Leagues with fewer than four groups fall back to a
  /// single decider (or crown a lone winner outright).
  Future<void> _progressNationsLeague(int careerId) async {
    const kind = CompetitionKind.nationsLeague;
    if (!await _comp.hasTournament(careerId, kind)) return;

    final finalFx = await _comp.fixturesByRound(careerId, 'NFINAL', kind: kind);
    final semiFx = await _comp.fixturesByRound(careerId, 'NSF', kind: kind);

    // Stage 1 — groups done: seed the Finals Four from the group winners.
    if (finalFx.isEmpty && semiFx.isEmpty) {
      if (!await _roundComplete(careerId, 'NGROUP', kind: kind)) return;
      final tables = await _comp.tournamentGroupTables(careerId, kind);
      // The title is contested by League A (tier 0) — its group winners meet in
      // the Finals Four.
      final winners = [
        for (final t in tables)
          if (t.standings.isNotEmpty && NationsCup.tierOfGroupName(t.name) == 0)
            t.standings.first,
      ]..sort(SeasonService._rankStandings);
      if (winners.isEmpty) return;
      if (winners.length < 2) {
        await _recordNationsLeagueHonour(
          careerId,
          winners.first.nationId,
          null,
        );
        return;
      }
      // The Finals Four takes the real Nations League slot: the June window of
      // the year after the autumn group stage — the season before the World
      // Cup, so the whole Nations Cup is settled before the finals begin.
      // Days 18/21 sit clear of that window's qualifying matchdays.
      final career = await _careers.byId(careerId);
      if (career == null) return;
      final scheduled = DateTime(
        SeasonService.finalsYear(career.cyclePointer) - 1,
        6,
        18,
      );
      final date = scheduled.isAfter(career.inGameDate)
          ? scheduled
          : career.inGameDate.add(const Duration(days: 14));
      if (winners.length < 4) {
        // Too few group winners for a Finals Four — a single decider.
        await _comp.addKnockoutFixtures(
          careerId: careerId,
          round: 'NFINAL',
          kind: kind,
          pairings: [(winners[0].nationId, winners[1].nationId)],
          date: date,
        );
        return;
      }
      // Semi-finals: top seed v fourth, second v third.
      await _comp.addKnockoutFixtures(
        careerId: careerId,
        round: 'NSF',
        kind: kind,
        pairings: [
          (winners[0].nationId, winners[3].nationId),
          (winners[1].nationId, winners[2].nationId),
        ],
        date: date,
      );
      return;
    }

    // Stage 2 — both semis played: the winners meet in the final.
    if (finalFx.isEmpty) {
      if (semiFx.length < 2 || !semiFx.every((f) => f.hasResult)) return;
      await _comp.addKnockoutFixtures(
        careerId: careerId,
        round: 'NFINAL',
        kind: kind,
        pairings: [
          (SeasonService._winner(semiFx[0]), SeasonService._winner(semiFx[1])),
        ],
        date: (await _maxDate(
          careerId,
          'NSF',
          kind: kind,
        )).add(const Duration(days: 3)),
      );
      return;
    }

    final f = finalFx.first;
    if (!f.hasResult) return;
    await _recordNationsLeagueHonour(
      careerId,
      SeasonService._winner(f),
      SeasonService._loser(f),
      finalFixture: f,
    );
  }

  Future<void> _recordNationsLeagueHonour(
    int careerId,
    int champion,
    int? runnerUp, {
    Fixture? finalFixture,
  }) async {
    final career = await _careers.byId(careerId);
    if (career == null) return;
    final year = SeasonService.finalsYear(career.cyclePointer) - 2;
    if (await _comp.hasHonour(careerId, 'Nations Cup', year)) return;
    // Store the final's scoreline champion-first, so the past-winners card
    // shows the result rather than a bare "beat".
    final f = finalFixture;
    final scored = f != null && f.hasResult;
    final champIsHome = scored && SeasonService._winner(f) == f.homeNationId;
    await _comp.recordHonour(
      careerId: careerId,
      year: year,
      competition: 'Nations Cup',
      championId: champion,
      runnerUpId: runnerUp ?? champion,
      finalHomeScore: !scored
          ? null
          : (champIsHome ? f.homeScore : f.awayScore),
      finalAwayScore: !scored
          ? null
          : (champIsHome ? f.awayScore : f.homeScore),
    );
  }

  /// Creates and resolves the Finalissima: a one-off match between the
  /// European and South American champions of the cycle.
  Future<void> _progressFinalissima(int careerId) async {
    const kind = CompetitionKind.finalissima;
    final career = await _careers.byId(careerId);
    if (career == null) return;
    final year = SeasonService.finalsYear(career.cyclePointer) - 2;
    if (await _comp.hasHonour(careerId, 'Continental Clash', year)) return;

    final existing = await _comp.fixturesByRound(
      careerId,
      'FFINAL',
      kind: kind,
    );
    if (existing.isEmpty) {
      final honours = await _comp.honours(careerId);
      int? euro;
      int? copa;
      for (final h in honours) {
        if (h.year != year) continue;
        if (h.competition == 'European Championship') euro = h.championId;
        if (h.competition == 'South America Cup') copa = h.championId;
      }
      if (euro == null || copa == null) return;
      await _comp.saveTournamentGroups(
        careerId: careerId,
        cycle: career.cyclePointer,
        confederation: Confederation.europe,
        kind: kind,
        name: 'Continental Clash',
        draw: FinalsDraw(
          groups: [
            FinalsGroupDraw(
              name: 'F',
              nationIds: [euro, copa],
              fixtures: [(1, euro, copa)],
            ),
          ],
        ),
        groupStart: DateTime(year, 8, 15),
        round: 'FFINAL',
      );
      return;
    }
    final f = existing.first;
    if (!f.hasResult) return;
    // Champion-first scoreline, so the record shows the result, not "beat".
    final champIsHome = SeasonService._winner(f) == f.homeNationId;
    await _comp.recordHonour(
      careerId: careerId,
      year: year,
      competition: 'Continental Clash',
      championId: SeasonService._winner(f),
      runnerUpId: SeasonService._loser(f),
      finalHomeScore: champIsHome ? f.homeScore : f.awayScore,
      finalAwayScore: champIsHome ? f.awayScore : f.homeScore,
    );
  }

  Future<void> _progressWorldCup(int careerId) async {
    if (!await _comp.hasFinals(careerId)) {
      if (await _comp.allQualifyingPlayed(careerId)) {
        await _progressPlayoff(careerId);
      }
      return;
    }

    // Round of 32 (after the 12-group stage): 24 group qualifiers + 8 thirds.
    if ((await _comp.fixturesByRound(careerId, WorldCupFinals.r32)).isEmpty) {
      if (await _roundComplete(careerId, 'GROUP')) {
        final tables = await _comp.finalsGroupTables(careerId);
        final pairings = WorldCupFinals.roundOf32(
          tables.map((t) => t.standings).toList(),
        );
        await _comp.addKnockoutFixtures(
          careerId: careerId,
          round: WorldCupFinals.r32,
          pairings: pairings,
          date: (await _maxDate(careerId, 'GROUP')).add(
            const Duration(days: 7),
          ),
        );
      }
      return;
    }

    await _advanceTournamentKnockout(careerId, CompetitionKind.worldCupFinals);
    await _recordHonourIfDecided(careerId);
  }

  /// Progresses EVERY confederation's championship, not only the manager's.
  ///
  /// The rest of the world's cups used to be created and then never played, so
  /// the only continent that ever put goals and caps on the record was the one
  /// the manager happened to be working in — the all-time world records read as
  /// a chart of a single confederation. It also meant the Continental Clash
  /// could only ever happen for a European or South American manager, since it
  /// needs both of those champions on the honours roll.
  ///
  /// The manager's own cup is progressed first so nothing about their season
  /// depends on the order the others resolve in.
  Future<void> _progressContinental(int careerId) async {
    final mine = await _managerConfederation(careerId);
    if (mine == null) return;
    await _progressContinentalFor(careerId, mine, isManagers: true);
    for (final conf in Confederation.values) {
      if (conf == mine) continue;
      await _progressContinentalFor(careerId, conf, isManagers: false);
    }
  }

  /// Progresses one confederation's championship from its group stage through
  /// to its final, recording the honour once it is decided.
  Future<void> _progressContinentalFor(
    int careerId,
    Confederation conf, {
    required bool isManagers,
  }) async {
    const kind = CompetitionKind.continentalFinals;
    // Already decided this cycle: nothing to advance, and this is by far the
    // cheapest way to say so — `_progress` runs up to forty times in a single
    // catch-up, and there are six cups to look at on every one of those passes.
    final cupName = ContinentalCups.byConfederation[conf]?.name;
    if (cupName != null) {
      final career = await _careers.byId(careerId);
      if (career == null) return;
      final cupYear = SeasonService.finalsYear(career.cyclePointer) - 2;
      if (await _comp.hasHonour(careerId, cupName, cupYear)) return;
    }
    // EVERY confederation's championship lives in this cycle as a competition
    // of this same kind, so a lookup that doesn't name the confederation picks
    // an arbitrary one. That let the manager's own cup be left undrawn (another
    // continent's existed, so "we already have a continental tournament" read
    // true) and another continent's bracket be advanced and recorded in its
    // place — after which the board's continental objective could never be
    // graded, because the manager's cup had no champion.
    if (!await _comp.hasTournament(careerId, kind, confederation: conf)) {
      // Once THIS confederation's qualifying is complete, draw its finals from
      // its own qualifiers. Every qualifying confederation now runs a campaign,
      // so every one of them draws its field the same way the manager's does —
      // and each lookup names its confederation, because all six live in this
      // cycle under the same competition kind.
      if (await _comp.hasTournament(
            careerId,
            CompetitionKind.continentalQualifying,
            confederation: conf,
          ) &&
          await _comp.allPlayedForKind(
            careerId,
            CompetitionKind.continentalQualifying,
            confederation: conf,
          )) {
        await _generateContinentalFinals(
          careerId,
          conf,
          isManagers: isManagers,
        );
      }
      return;
    }

    // Group stage → first knockout round, once every group game is played. The
    // round depends on how many teams advance: a 24-team cup (6 groups) sends
    // the top two plus the four best third-placed teams into a round of 16; a
    // 16-team cup (4 groups) opens at the quarter-finals; an 8-team cup (2
    // groups) at the semi-finals.
    final tables = await _comp.tournamentGroupTables(
      careerId,
      kind,
      confederation: conf,
    );
    if (tables.isNotEmpty) {
      final standings = tables.map((t) => t.standings).toList();
      // Copa América: two groups of five, the top four of each into the
      // quarter-finals (only the fifth-placed side goes out).
      final copa = tables.length == 2 && standings.every((s) => s.length >= 5);
      final bestThirds = WorldCupFinals.bestThirdsFor(tables.length);
      final firstRound = copa
          ? 'CQF'
          : switch (tables.length) {
              6 => 'CR16',
              4 => 'CQF',
              _ => 'CSF',
            };
      final started = (await _comp.fixturesByRound(
        careerId,
        firstRound,
        kind: kind,
        confederation: conf,
      )).isNotEmpty;
      if (!started) {
        if (!await _roundComplete(
          careerId,
          'CGROUP',
          kind: kind,
          confederation: conf,
        )) {
          return;
        }
        await _comp.addKnockoutFixtures(
          careerId: careerId,
          round: firstRound,
          kind: kind,
          confederation: conf,
          pairings: copa
              ? WorldCupFinals.copaQuarters(standings)
              : bestThirds > 0
              ? WorldCupFinals.knockoutWithThirds(standings, bestThirds)
              : WorldCupFinals.knockoutFromGroups(standings),
          date: (await _maxDate(
            careerId,
            'CGROUP',
            kind: kind,
            confederation: conf,
          )).add(const Duration(days: 7)),
        );
        return;
      }
    }

    await _advanceTournamentKnockout(
      careerId,
      kind,
      prefix: 'C',
      thirdPlace: false,
      confederation: conf,
    );
    await _recordContinentalHonourIfDecided(careerId, conf);
  }

  /// The confederation of the nation the manager currently leads — the one
  /// whose continental championship is theirs to play.
  Future<Confederation?> _managerConfederation(int careerId) async {
    final career = await _careers.byId(careerId);
    if (career == null) return null;
    return (await _nationsById())[career.nationId]?.confederation;
  }

  /// Advances a knockout from its first round to the final (and, for the World
  /// Cup, the third-place game). The R16 step is a no-op for brackets that start
  /// later (e.g. an 8-team continental cup that opens at the quarter-finals).
  /// [prefix] namespaces the round labels so the continental cup is distinct
  /// from the World Cup.
  ///
  /// [thirdPlace] is true only for the World Cup: the continental championships
  /// (like the real European Championship) have NO third-place play-off — the
  /// two beaten semi-finalists share the bronze finish and no extra match is
  /// scheduled.
  Future<void> _advanceTournamentKnockout(
    int careerId,
    CompetitionKind kind, {
    String prefix = '',
    bool thirdPlace = true,
    Confederation? confederation,
  }) async {
    final r32 = '${prefix}R32';
    final r16 = '${prefix}R16';
    final qf = '${prefix}QF';
    final sf = '${prefix}SF';
    final third = '${prefix}3RD';
    final fin = '${prefix}FINAL';

    // The R32 step is a no-op for brackets that start later (continental cups
    // open at the quarter- or semi-finals — their R32 round never exists).
    await _advanceRound(
      careerId,
      r32,
      r16,
      4,
      kind: kind,
      confederation: confederation,
    );
    await _advanceRound(
      careerId,
      r16,
      qf,
      4,
      kind: kind,
      confederation: confederation,
    );
    await _advanceRound(
      careerId,
      qf,
      sf,
      4,
      kind: kind,
      confederation: confederation,
    );

    if ((await _comp.fixturesByRound(
          careerId,
          fin,
          kind: kind,
          confederation: confederation,
        )).isEmpty &&
        await _roundComplete(
          careerId,
          sf,
          kind: kind,
          confederation: confederation,
        )) {
      final semis = await _comp.fixturesByRound(
        careerId,
        sf,
        kind: kind,
        confederation: confederation,
      );
      final afterSemis = await _maxDate(
        careerId,
        sf,
        kind: kind,
        confederation: confederation,
      );
      // The play-off comes first and the final closes the tournament, on their
      // own days — sharing one date collapsed them into a single round popup
      // titled after the play-off, so the final was never its own moment.
      if (thirdPlace) {
        await _comp.addKnockoutFixtures(
          careerId: careerId,
          round: third,
          kind: kind,
          confederation: confederation,
          pairings: WorldCupFinals.pairWinners(
            semis.map(SeasonService._loser).toList(),
          ),
          date: afterSemis.add(const Duration(days: 5)),
        );
      }
      await _comp.addKnockoutFixtures(
        careerId: careerId,
        round: fin,
        kind: kind,
        confederation: confederation,
        pairings: WorldCupFinals.pairWinners(
          semis.map(SeasonService._winner).toList(),
        ),
        date: afterSemis.add(const Duration(days: 7)),
      );
    }

    // Repair saves whose play-off and final were scheduled on the SAME day
    // (before the split above): push an unplayed final onto its own later day.
    if (!thirdPlace) return;
    final finFx = await _comp.fixturesByRound(
      careerId,
      fin,
      kind: kind,
      confederation: confederation,
    );
    final thirdFx = await _comp.fixturesByRound(
      careerId,
      third,
      kind: kind,
      confederation: confederation,
    );
    if (finFx.isNotEmpty && thirdFx.isNotEmpty) {
      final f = finFx.first;
      if (!f.hasResult && !f.date.isAfter(thirdFx.first.date)) {
        await _comp.rescheduleFixture(
          f.id,
          thirdFx.first.date.add(const Duration(days: 2)),
        );
      }
    }
  }

  /// Draws the continental finals (a group stage) from the teams that came
  /// through continental qualifying, mirroring the World Cup finals draw.
  Future<void> _generateContinentalFinals(
    int careerId,
    Confederation conf, {
    required bool isManagers,
  }) async {
    final career = await _careers.byId(careerId);
    if (career == null) return;
    final nations = await _nationsById();
    final cont = ContinentalCups.byConfederation[conf];
    if (cont == null) return;

    // The hosts qualify automatically and reserve their berths, so only
    // (size − hosts) teams come through qualifying — a host does NOT bump the
    // last third-placed qualifier out.
    final hosts = WorldCupHosts.continentalHostsFor(
      confederation: conf,
      cycle: career.cyclePointer,
      seed: career.rngSeed,
      nations: nations.values.toList(),
    );
    final berths = (cont.size - hosts.length).clamp(1, cont.size);
    // Named confederation: every confederation's qualifying is a competition of
    // this same kind now, so an unqualified lookup would seed this continent's
    // finals out of another continent's group tables.
    final tables = await _comp.tournamentGroupTables(
      careerId,
      CompetitionKind.continentalQualifying,
      confederation: conf,
    );
    final qualifiers = Qualification.qualifiers(
      tables.map((t) => t.standings).toList(),
      berths,
    );
    if (qualifiers.length < berths) return;

    final field = [
      ...qualifiers,
      for (final h in hosts)
        if (!qualifiers.contains(h)) h,
    ].take(cont.size).toList();

    final wcYear = CareerService.worldCupYear(career.cyclePointer);
    // Pot the continental finals by the LIVE ranking (post-qualifying),
    // snapshotted so the draw ceremony reproduces the same pots.
    await _ensureRank(careerId);
    final rankingById = _liveRankById(nations);
    await _ref
        .read(seedRankingRepositoryProvider)
        .snapshot(
          careerId,
          drawSeedCycle(career.cyclePointer, drawSlotContinentalFinals),
          rankingById,
        );
    final draw = WorldCupFinals.drawGroups(
      qualifierIds: field,
      rankingById: rankingById,
      rngSeed: career.rngSeed ^ (career.cyclePointer * 0x71) ^ 0xC0FF,
      hosts: hosts,
      perGroup: cont.groupSize,
    );
    await _comp.saveTournamentGroups(
      careerId: careerId,
      cycle: career.cyclePointer,
      confederation: conf,
      kind: CompetitionKind.continentalFinals,
      name: cont.name,
      draw: draw,
      groupStart: DateTime(wcYear - 2, cont.month, 8),
      round: 'CGROUP',
    );

    // If the manager's nation didn't make the field, their continental
    // qualifying campaign fell short. Only ever filed for their OWN continent —
    // every confederation draws its finals through here now, and a manager does
    // not need telling they missed out on a cup they were never in.
    if (isManagers && !field.contains(career.nationId)) {
      final year = wcYear - 2;
      await _comp.addMessage(
        careerId: careerId,
        dedupKey: 'contmiss:$year',
        category: 'eliminated',
        title: _l.newsContMissTitle(continentalCupLabel(_l, conf)),
        body: _l.newsContMissBody(continentalCupLabel(_l, conf)),
        year: year - 1,
      );
    }
  }

  /// Records [conf]'s continental championship to the honours roll once its
  /// final is played (so the played result — not the background sim — counts).
  /// Every confederation's cup is recorded, so the world's honours roll is
  /// complete and the Continental Clash always has two champions to call on.
  Future<void> _recordContinentalHonourIfDecided(
    int careerId,
    Confederation conf,
  ) async {
    const kind = CompetitionKind.continentalFinals;
    final career = await _careers.byId(careerId);
    if (career == null) return;
    final nations = await _nationsById();

    // THIS confederation's final: every confederation's cup is a competition of
    // this kind, and an unqualified lookup could hand back another continent's
    // final and file it under the wrong competition.
    final finals = await _comp.fixturesByRound(
      careerId,
      'CFINAL',
      kind: kind,
      confederation: conf,
    );
    if (finals.isEmpty || !finals.first.hasResult) return;
    final f = finals.first;
    final year = f.date.year;

    final name = ContinentalCups.byConfederation[conf]?.name;
    if (name == null) return;
    if (await _comp.hasHonour(careerId, name, year)) return;

    // No third-place play-off in the continental championships — the two beaten
    // semi-finalists SHARE the bronze, so record both as third place.
    final semis = await _comp.fixturesByRound(
      careerId,
      'CSF',
      kind: kind,
      confederation: conf,
    );
    final bronzes = [
      for (final s in semis)
        if (s.hasResult) SeasonService._loser(s),
    ];
    final boot = await _comp.topScorers(
      careerId,
      kind: kind,
      confederation: conf,
      limit: 1,
    );
    String? bootName;
    int? bootGoals;
    if (boot.isNotEmpty) {
      bootName =
          (await _ref
                  .read(playerRepositoryProvider)
                  .byId(
                    boot.first.playerId,
                    agingYears: _simYears,
                    saveSeed: _simSeed,
                  ))
              ?.name;
      bootGoals = boot.first.goals;
    }

    final champIsHome = f.homeScore! >= f.awayScore!;
    await _comp.recordHonour(
      careerId: careerId,
      year: year,
      competition: name,
      championId: SeasonService._winner(f),
      runnerUpId: SeasonService._loser(f),
      thirdId: bronzes.isNotEmpty ? bronzes[0] : null,
      thirdId2: bronzes.length > 1 ? bronzes[1] : null,
      hostId: WorldCupHosts.continentalHostFor(
        confederation: conf,
        cycle: career.cyclePointer,
        seed: career.rngSeed,
        nations: nations.values.toList(),
      ),
      finalHomeScore: champIsHome ? f.homeScore : f.awayScore,
      finalAwayScore: champIsHome ? f.awayScore : f.homeScore,
      topScorerName: bootName,
      topScorerGoals: bootGoals,
    );

    // Every other confederation's championship is decided in the same window,
    // so record them now rather than two years later after the World Cup.
    await _simulateContinentalCups(careerId, year + 2);
  }

  /// Records the World Cup roll-of-honour entry once the final is played.
  Future<void> _recordHonourIfDecided(int careerId) async {
    final finals = await _comp.fixturesByRound(
      careerId,
      WorldCupFinals.finalRound,
    );
    if (finals.isEmpty || !finals.first.hasResult) return;
    final f = finals.first;
    final year = f.date.year;
    if (await _comp.hasHonour(careerId, 'World Championship', year)) return;

    final thirds = await _comp.fixturesByRound(careerId, WorldCupFinals.third);
    final nations = await _nationsById();
    final host = WorldCupHosts.hostFor(
      year: year,
      nations: nations.values.toList(),
      seed: (await _careers.byId(careerId))?.rngSeed ?? 0,
    );

    final boot = await _comp.topScorers(
      careerId,
      kind: CompetitionKind.worldCupFinals,
      limit: 1,
    );
    String? bootName;
    int? bootGoals;
    if (boot.isNotEmpty) {
      final p = await _ref
          .read(playerRepositoryProvider)
          .byId(
            boot.first.playerId,
            saveSeed: _simSeed,
          );
      bootName = p?.name;
      bootGoals = boot.first.goals;
    }

    // The champion is the home/away winner; orient the score accordingly.
    final champIsHome = f.homeScore! >= f.awayScore!;
    await _comp.recordHonour(
      careerId: careerId,
      year: year,
      competition: 'World Championship',
      championId: SeasonService._winner(f),
      runnerUpId: SeasonService._loser(f),
      thirdId: thirds.isNotEmpty && thirds.first.hasResult
          ? SeasonService._winner(thirds.first)
          : null,
      hostId: host,
      finalHomeScore: champIsHome ? f.homeScore : f.awayScore,
      finalAwayScore: champIsHome ? f.awayScore : f.homeScore,
      topScorerName: bootName,
      topScorerGoals: bootGoals,
    );

    // The finals didn't move the ranking live; settle the whole tournament now,
    // heavier than any qualifier, so the champion's run is the cycle's biggest
    // ranking swing and it lands as one update after the final.
    await _settleWorldCupRanking(careerId);

    await _simulateContinentalCups(careerId, year);
  }

  /// A BACKSTOP for any confederation whose championship never got played.
  ///
  /// Every confederation's cup is now drawn when the cycle is built and played
  /// out in its own window alongside the manager's (see [_progressContinental]),
  /// which is what puts the world's goals, caps and honours on the record at the
  /// right time — and what lets the Continental Clash find both its champions in
  /// the year it is meant to be staged. This runs after the World Cup final and
  /// only picks up a cup that somehow has neither a tournament nor an honour
  /// (an older save, or a cycle whose draw never happened), so a continent is
  /// never left with a missing edition.
  Future<void> _simulateContinentalCups(int careerId, int wcYear) async {
    final year = wcYear - 2;
    final career = await _careers.byId(careerId);
    if (career == null) return;
    final nations = await _ref.read(nationRepositoryProvider).all();

    for (final entry in ContinentalCups.byConfederation.entries) {
      final cont = entry.value;
      if (await _comp.hasHonour(careerId, cont.name, year)) continue;
      // Already drawn (and being played, or waiting on a round) — leave it to
      // the normal progression rather than drawing a second competition of the
      // same kind and confederation on top of it.
      if (await _comp.hasTournament(
        careerId,
        CompetitionKind.continentalFinals,
        confederation: entry.key,
      )) {
        continue;
      }

      final members =
          nations.where((n) => n.confederation == entry.key).toList()
            ..sort((a, b) => a.ranking.compareTo(b.ranking));
      if (members.length < 4) continue;

      await _simulateBackgroundCup(
        careerId: careerId,
        confederation: entry.key,
        year: year,
        career: career,
        allNations: nations,
        members: members,
      );

      // No message is filed here: every cup result is announced from its
      // honour row by the message service, which reads the scoreline recorded
      // just above. Announcing it here too filed each background cup's title
      // twice.
    }
  }

  /// Plays and persists one confederation's continental championship in full —
  /// group stage then knockout — and records its honour with the real final
  /// scoreline and golden boot. Deterministic from the save seed.
  Future<void> _simulateBackgroundCup({
    required int careerId,
    required Confederation confederation,
    required int year,
    required Career career,
    required List<Nation> allNations,
    required List<Nation> members,
  }) async {
    final cont = ContinentalCups.byConfederation[confederation]!;
    final nationsById = {for (final n in allNations) n.id: n};
    final rngSeed = career.rngSeed ^ (year * 0x33) ^ confederation.index;

    // Seed the finals field straight from the confederation ranking, into
    // groups of four (the largest power-of-the-format that fits).
    final field = members.take(cont.size).map((n) => n.id).toList();
    final draw = WorldCupFinals.drawGroups(
      qualifierIds: field,
      rankingById: {for (final n in allNations) n.id: n.ranking},
      rngSeed: rngSeed ^ 0xC0FF,
      perGroup: cont.groupSize,
    );
    if (draw.groups.isEmpty) return;

    await _comp.saveTournamentGroups(
      careerId: careerId,
      cycle: career.cyclePointer,
      confederation: confederation,
      kind: CompetitionKind.continentalFinals,
      name: cont.name,
      draw: draw,
      groupStart: DateTime(year, cont.month, 8),
      round: 'CGROUP',
    );

    const kind = CompetitionKind.continentalFinals;
    Future<List<Fixture>> byRound(String r) => _comp.fixturesByRound(
      careerId,
      r,
      kind: kind,
      confederation: confederation,
    );
    Future<void> simRound(String r) async {
      for (final f in await byRound(r)) {
        if (!f.hasResult) await _simAndRecord(f, nationsById, rngSeed);
      }
    }

    Future<DateTime> lastDate(String r) async => (await byRound(
      r,
    )).map((f) => f.date).reduce((a, b) => a.isAfter(b) ? a : b);

    // Group stage.
    await simRound('CGROUP');

    // First knockout round from the group tables (R16 / QF / SF by field size),
    // then advance round by round to the final + third-place play-off.
    final tables = await _comp.tournamentGroupTables(
      careerId,
      kind,
      confederation: confederation,
    );
    final standings = tables.map((t) => t.standings).toList();
    // Copa América: two groups of five, top four of each into the quarters.
    final copa = tables.length == 2 && standings.every((s) => s.length >= 5);
    final bestThirds = WorldCupFinals.bestThirdsFor(tables.length);
    final ladder = copa
        ? ['CQF', 'CSF']
        : switch (tables.length) {
            6 => ['CR16', 'CQF', 'CSF'],
            4 => ['CQF', 'CSF'],
            _ => ['CSF'],
          };
    final firstRound = ladder.first;
    await _comp.addKnockoutFixtures(
      careerId: careerId,
      round: firstRound,
      kind: kind,
      confederation: confederation,
      pairings: copa
          ? WorldCupFinals.copaQuarters(standings)
          : bestThirds > 0
          ? WorldCupFinals.knockoutWithThirds(standings, bestThirds)
          : WorldCupFinals.knockoutFromGroups(standings),
      date: (await lastDate('CGROUP')).add(const Duration(days: 5)),
    );
    // Play each round, seeding the next from its winners — straight to the
    // final. Continental championships have no third-place play-off.
    for (var i = 0; i < ladder.length; i++) {
      final round = ladder[i];
      await simRound(round);
      final winners = (await byRound(
        round,
      )).map(SeasonService._winner).toList();
      final next = i + 1 < ladder.length ? ladder[i + 1] : 'CFINAL';
      final base = (await lastDate(round)).add(const Duration(days: 4));
      await _comp.addKnockoutFixtures(
        careerId: careerId,
        round: next,
        kind: kind,
        confederation: confederation,
        pairings: WorldCupFinals.pairWinners(winners),
        date: base,
      );
    }
    await simRound('CFINAL');

    // Record the honour from the real final + golden boot. The continental
    // cups have no third-place play-off, so BOTH beaten semi-finalists share
    // the bronze — record the two 'CSF' losers as third place.
    final finals = await byRound('CFINAL');
    if (finals.isEmpty || !finals.first.hasResult) return;
    final f = finals.first;
    final bronzes = [
      for (final s in await byRound('CSF'))
        if (s.hasResult) SeasonService._loser(s),
    ];
    final boot = await _comp.topScorers(
      careerId,
      kind: kind,
      confederation: confederation,
      limit: 1,
    );
    String? bootName;
    int? bootGoals;
    if (boot.isNotEmpty) {
      bootName =
          (await _ref
                  .read(playerRepositoryProvider)
                  .byId(
                    boot.first.playerId,
                    agingYears: _simYears,
                    saveSeed: _simSeed,
                  ))
              ?.name;
      bootGoals = boot.first.goals;
    }
    final champIsHome = f.homeScore! >= f.awayScore!;
    await _comp.recordHonour(
      careerId: careerId,
      year: year,
      competition: cont.name,
      championId: SeasonService._winner(f),
      runnerUpId: SeasonService._loser(f),
      thirdId: bronzes.isNotEmpty ? bronzes[0] : null,
      thirdId2: bronzes.length > 1 ? bronzes[1] : null,
      hostId: members.first.id,
      finalHomeScore: champIsHome ? f.homeScore : f.awayScore,
      finalAwayScore: champIsHome ? f.awayScore : f.homeScore,
      topScorerName: bootName,
      topScorerGoals: bootGoals,
    );
  }

  Future<void> _advanceRound(
    int careerId,
    String from,
    String to,
    int plusDays, {
    CompetitionKind kind = CompetitionKind.worldCupFinals,
    Confederation? confederation,
  }) async {
    if ((await _comp.fixturesByRound(
      careerId,
      to,
      kind: kind,
      confederation: confederation,
    )).isNotEmpty) {
      return;
    }
    if (!await _roundComplete(
      careerId,
      from,
      kind: kind,
      confederation: confederation,
    )) {
      return;
    }
    final fx = await _comp.fixturesByRound(
      careerId,
      from,
      kind: kind,
      confederation: confederation,
    );
    await _comp.addKnockoutFixtures(
      careerId: careerId,
      round: to,
      kind: kind,
      confederation: confederation,
      pairings: WorldCupFinals.pairWinners(
        fx.map(SeasonService._winner).toList(),
      ),
      date: (await _maxDate(
        careerId,
        from,
        kind: kind,
        confederation: confederation,
      )).add(Duration(days: plusDays)),
    );
  }
}
