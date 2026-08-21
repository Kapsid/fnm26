part of 'hub_providers.dart';

/// Rolling a save into its next four-year cycle: the new campaign's fixtures,
/// the manager's own move, and the world texture that fills the gap — club
/// transfers, all-time records, naturalisation offers.
///
/// Split out of [SeasonService] purely to make it navigable: the class is one
/// library, so these read and write exactly the state they did before.
extension SeasonRollover on SeasonService {
  Future<void> _startNextCycle(
    int careerId, {
    int? switchToNationId,
    String? boardTitle,
    String? boardBody,
    FederationInvestment? nextInvestment,
  }) async {
    final career = await _careers.byId(careerId);
    if (career == null) return;
    if (await _comp.worldChampion(careerId) == null) return; // not finished

    // The board answers for every brief it set BEFORE the cycle pointer moves
    // on. Grading is normally filed the moment a tournament settles, but every
    // one of those hooks hangs off a step of the world; a cycle that ends
    // without one (the last act being a foreign final, say) used to roll over
    // with an objective still ungraded, and once the pointer moved the cycle's
    // fixtures were out of reach and the verdict could never be filed at all.
    // Deduped per cycle and tier, so this is a no-op when it already landed.
    await _gradeObjectivesIfDecided(careerId);

    // Settle the finishing cycle's finances: bank income, then commit the
    // manager's allocation for the cycle about to begin.
    final income = await _ref
        .read(federationServiceProvider)
        .incomeForCycle(careerId, career.cyclePointer);
    // What the manager talked the federation into. Applied to everything
    // coming in rather than to the grant alone: a negotiator gets a better
    // deal on the commercial side and a better bonus for the run, not just a
    // bigger cheque from the association.
    final negotiated =
        ((income.grant + income.prize + income.commercial) *
                ManagerSkills.incomeBonus(career.skillNegotiation))
            .round();
    // And out again: the staff are paid for the cycle just finished. A manager
    // who hires an elite room and then misses a tournament feels it.
    final wages = Staff.totalCost({
      StaffRole.assistant: career.staffAssistant,
      StaffRole.scout: career.staffScout,
      StaffRole.fitnessCoach: career.staffFitnessCoach,
    });
    var budget = career.budget + negotiated - wages;
    if (budget < 0) budget = 0;
    if (nextInvestment != null) {
      final spend =
          nextInvestment.youth +
          nextInvestment.commercial +
          nextInvestment.medical +
          nextInvestment.naturalization +
          nextInvestment.boardRelations;
      // The UI validates spend <= budget; ignore an over-budget allocation
      // rather than going negative.
      if (spend <= budget) {
        await _careers.setInvestment(
          careerId,
          career.cyclePointer + 1,
          nextInvestment,
        );
        budget -= spend;
      }
    }
    await _careers.setBudget(careerId, budget);

    // Move the Nations Cup ladder on this cycle's cup — every league's group
    // winners climb, bottom sides drop. Read the tables BEFORE advancing the
    // cycle (they are scoped to the current, finishing cycle).
    var ncTiers = await _careers.nationsCupTiers(careerId);
    final ncTables = await _comp.tournamentGroupTables(
      careerId,
      CompetitionKind.nationsLeague,
    );
    if (ncTables.isNotEmpty && ncTiers.isNotEmpty) {
      final groups = [
        for (final t in ncTables)
          if (t.standings.length >= 2)
            (
              tier: NationsCup.tierOfGroupName(t.name),
              winner: t.standings.first,
              bottom: t.standings.last,
            ),
      ];
      ncTiers = NationsCup.promoteRelegate(tiers: ncTiers, groups: groups);
      await _careers.setNationsCupTiers(careerId, ncTiers);
    }

    if (switchToNationId != null && switchToNationId != career.nationId) {
      await _careers.switchNation(careerId, switchToNationId);
      await _resetSquadForNewNation(careerId, switchToNationId, career);
      // A new nation means an unfamiliar squad — the drilled-shape bonus resets.
      await _ref.read(tacticFamiliarityRepositoryProvider).reset(careerId);
    }
    if (boardTitle != null) {
      await _comp.addMessage(
        careerId: careerId,
        dedupKey: 'board:${career.cyclePointer}',
        category: 'board',
        title: boardTitle,
        body: boardBody ?? '',
        year: SeasonService.finalsYear(career.cyclePointer),
      );
    }
    final nationId = switchToNationId ?? career.nationId;

    final nextCycle = career.cyclePointer + 1;
    final nextStart = DateTime(
      SeasonService.finalsYear(career.cyclePointer),
      9,
    );

    // Where the board finished, read BEFORE the pointer moves: satisfaction is
    // derived from this cycle's objectives and form, and a moment from now
    // none of that will be this cycle any more.
    final closingBoard = await _ref.read(satisfactionProvider(careerId).future);
    await _careers.advanceCycle(
      careerId,
      nextCycle,
      nextStart,
      closingBoard: closingBoard,
    );
    await _careers.recordStint(careerId, nextCycle, nationId);

    // Freeze the current standings as the seeding ranking for the new cycle, so
    // its draws reflect how nations have actually performed — and stay in step
    // with the draw ceremonies no matter when they are viewed.
    await _ensureRank(careerId);
    final nations = await _nationsById();
    final seedRank = _liveRankById(nations);
    await _ref
        .read(seedRankingRepositoryProvider)
        .snapshot(careerId, nextCycle, seedRank);

    // Build the whole next cycle in real-world order (continental qualifying →
    // continental finals → World Cup qualifying → World Cup finals) plus
    // friendlies, mirroring a fresh save.
    await CareerService.buildCalendar(
      comp: _comp,
      nations: nations.values.toList(),
      careerId: careerId,
      nationId: nationId,
      rngSeed: career.rngSeed,
      cycle: nextCycle,
      cycleStart: nextStart,
      wcYear: SeasonService.finalsYear(nextCycle),
      rankById: seedRank,
      nationsCupTiers: ncTiers,
    );

    // The naturalisation roll is NOT done here: the cycle's naturalisation
    // budget isn't allocated until the forced budget-setup event that opens the
    // new cycle, so rolling now would always see zero investment. It is rolled
    // from [rollNaturalization], called once the budget is confirmed.

    // The ranking screen's data is auto-disposed but can be kept alive by a
    // listener elsewhere (careers list, vitrine) — refresh it explicitly so
    // the full ranking always shows the points the sim just moved.
    _ref
      ..invalidate(hubDataProvider)
      ..invalidate(worldRankingProvider)
      ..invalidate(rankHistoryProvider)
      // The board's brief and its mood are derived from fixtures the sim has
      // just changed, and neither reads them through a provider that would
      // notice — so they are refreshed by hand, or the hub keeps showing the
      // verdict it computed before the tournament was played.
      ..invalidate(cycleObjectiveOutcomesProvider)
      ..invalidate(cycleObjectivesProvider)
      ..invalidate(satisfactionProvider);
  }

  /// Posts transfer messages for the manager's nation's notable club moves over
  /// one calendar [year]. A player's club is derived from their overall, so a
  /// year of development (or decline) moves some of them between clubs — those
  /// are the transfers. Deterministic and idempotent (deduped per player+year),
  /// so re-running is a no-op.
  Future<void> _recordTransferYear(
    int careerId,
    int nationId,
    int saveSeed,
    int year,
  ) async {
    final agingNow = (year - CareerService.cycleStart.year).clamp(0, 400);
    final agingPrev = (agingNow - 1).clamp(0, 400);
    if (agingNow <= agingPrev) return; // save's first year — nothing before it
    final youth = await _ref.read(youthBonusByCycleProvider(careerId).future);
    final careerDev = await _ref.read(careerDevBonusProvider(careerId).future);
    final repo = _ref.read(playerRepositoryProvider);
    final before = await repo.byNation(
      nationId,
      agingYears: agingPrev,
      saveSeed: saveSeed,
      youthBonusByCycle: youth,
      careerStartsByPlayer: careerDev,
    );
    final after = await repo.byNation(
      nationId,
      agingYears: agingNow,
      saveSeed: saveSeed,
      youthBonusByCycle: youth,
      careerStartsByPlayer: careerDev,
    );
    final beforeById = {for (final p in before) p.id: p};
    // Notable players whose club changed over the year, biggest first.
    //
    // "Notable" is RELATIVE to the nation, not an absolute rating: a fixed
    // >=78 bar meant only the giants ever had a transfer window, and a manager
    // of anyone outside the top thirty nations saw an empty one every single
    // year. The bar is now the nation's own senior pool, so a minnow's best
    // players moving club is news there exactly as a superstar's move is news
    // in Brazil.
    final ranked = [...after]..sort((a, b) => b.overall.compareTo(a.overall));
    final notable = {for (final p in ranked.take(_transferPoolSize)) p.id};
    final moves = <(Player now, Player was)>[
      for (final p in after)
        if (notable.contains(p.id) &&
            beforeById[p.id] != null &&
            beforeById[p.id]!.club != p.club)
          (p, beforeById[p.id]!),
    ]..sort((a, b) => b.$1.value.compareTo(a.$1.value));

    // The country a club plays in, for naming a move that crosses a border.
    final byCode = {
      for (final n in (await _nationsById()).values) n.code.toLowerCase(): n,
    };

    for (final m in moves.take(3)) {
      final (p, was) = m;
      final fee = _transferFee(p);
      // A move abroad used to read exactly like a move across town, so every
      // transfer in the feed looked domestic. Name the country when the player
      // crosses a border — that is the part of the news that is the news.
      final destination = transferDestination(
        _l,
        club: p.club,
        toCountryName: byCode[p.clubCountry]?.name,
        crossedBorder: was.clubCountry != p.clubCountry,
      );
      await _comp.addMessage(
        careerId: careerId,
        dedupKey: 'transfer:${p.id}:$year',
        category: 'transfer',
        title: _l.newsTransferTitle(p.name, p.club),
        body: _l.newsTransferBody(
          p.name,
          p.position.label,
          was.club,
          destination,
          _feeLabel(fee),
          p.overall,
        ),
        year: year,
      );
    }
  }

  /// Announces a new all-time record holder (leading scorer / most-capped) as a
  /// headline. Deduped per holder id, so a record only makes the news when a
  /// NEW player takes it — a threshold keeps trivial early-save "records" out.
  Future<void> _checkRecords(int careerId, Career career, int year) async {
    Future<String> nameOf(int id) async {
      final p = await _ref
          .read(playerRepositoryProvider)
          .byId(
            id,
            agingYears: CareerService.agingYears(career),
            saveSeed: career.rngSeed,
          );
      return p?.name ?? _l.newsARecordBreaker;
    }

    final scorers = await _comp.allTimeTopScorers(careerId, limit: 1);
    if (scorers.isNotEmpty && scorers.first.goals >= 30) {
      final s = scorers.first;
      await _comp.addMessage(
        careerId: careerId,
        dedupKey: 'record:scorer:${s.playerId}',
        category: 'record',
        title: _l.newsRecordScorerTitle,
        body: _l.newsRecordScorerBody(await nameOf(s.playerId), s.goals),
        year: year,
      );
    }
    final caps = await _comp.allTimeTopAppearances(careerId, limit: 1);
    if (caps.isNotEmpty && caps.first.games >= 70) {
      final c = caps.first;
      await _comp.addMessage(
        careerId: careerId,
        dedupKey: 'record:caps:${c.playerId}',
        category: 'record',
        title: _l.newsRecordCapsTitle,
        body: _l.newsRecordCapsBody(await nameOf(c.playerId), c.games),
        year: year,
      );
    }
  }

  /// How deep into a nation's pool a club move still counts as news: the
  /// nation's top ten, so the window reports the players a manager would
  /// actually recognise rather than the hundredth man on the depth chart.
  ///
  /// This is the dial that decides how BUSY a transfer window looks, and it was
  /// set far too deep at first. With sixteen players in scope, more than three
  /// of them moved in 69% of years — so the `take(3)` cap below was doing all
  /// the work and every window reported exactly three transfers. Measured over
  /// five nations × 16 years, ten in scope gives a mean of 1.4 moves a year and
  /// hits the cap in 18% of them: sometimes none, usually one or two,
  /// occasionally a full three.
  static const int _transferPoolSize = 10;

  /// A plausible transfer fee: the player's value with a deterministic premium
  /// (a fee usually tops the book value), so a marquee move reads big — capped
  /// by what the league he is joining could actually pay.
  ///
  /// The cap is the fix for thirty-million-euro moves to Romania. What a player
  /// is worth and what a buying league can afford are two different numbers,
  /// and a transfer fee is the smaller of them. It is a SOFT cap: a fee
  /// approaches the ceiling asymptotically rather than stopping dead on it, so
  /// a lesser league's record signing still reads as a bigger deal than its
  /// ordinary business instead of every good move printing the same number.
  ///
  /// Floored well above zero — [Player.value] is zero for anyone under 44
  /// overall, which would have every move in a smaller nation announced as a
  /// free transfer.
  int _transferFee(Player p) {
    final premium = 1.0 + (p.id.abs() % 60) / 100; // 1.00–1.59×
    final floor = 100000 + (p.overall.clamp(20, 99) * 6000);
    final raw = (p.value * premium).round().clamp(floor, 1 << 62);
    final ceiling = ClubService.feeCeilingForTier(
      ClubService.tierOfCountry(p.clubCountry),
    );
    if (raw <= ceiling) return raw;
    // Everything above the ceiling is compressed into the last tenth of it, so
    // the ordering of moves within a league survives while the numbers stop
    // being absurd.
    final over = raw - ceiling;
    return (ceiling * 0.9 + ceiling * 0.1 * (over / (over + ceiling))).round();
  }

  /// Formats a euro fee compactly: €X.XM / €XXXk / €X.
  String _feeLabel(int euros) {
    if (euros <= 0) return _l.newsTransferFree;
    if (euros >= 1000000) {
      return '€${(euros / 1000000).toStringAsFixed(euros >= 10000000 ? 0 : 1)}M';
    }
    if (euros >= 1000) return '€${(euros / 1000).round()}k';
    return '€$euros';
  }

  /// Hands the manager a real squad at their new nation.
  ///
  /// Call-ups, the tactic and its lineup are all keyed by career alone, and
  /// player ids are partitioned per nation — so left alone, the old nation's
  /// 23 names survive the move and select nothing from the new pool. The
  /// manager would arrive to an empty squad, an unfillable XI, and a call-up
  /// screen that can't reach the 16 needed to save a repair.
  Future<void> _resetSquadForNewNation(
    int careerId,
    int nationId,
    Career career,
  ) async {
    // No explicit selection: the whole new pool is available (as for a fresh
    // save) until the manager curates it.
    await _ref.read(squadRepositoryProvider).clearCallUps(careerId);

    // Rebuild the XI from the new nation's players; saveTactic replaces the
    // stored lineup slots, which still named the old squad.
    final players = await _ref
        .read(playerRepositoryProvider)
        .byNation(
          nationId,
          agingYears: CareerService.agingYears(career),
          saveSeed: career.rngSeed,
        );
    const formation = Formation.f433;
    await _ref
        .read(tacticsRepositoryProvider)
        .saveTactic(
          careerId,
          Tactic(
            formation: formation,
            lineup: bestEleven(formation, players),
          ),
        );

    _ref
      ..invalidate(squadDataProvider)
      ..invalidate(tacticDataProvider);
  }

  /// Rolls (up to twice) for a foreign player offering to naturalise this
  /// cycle. Each roll's chance scales with the Naturalisation Office
  /// investment; on a hit a plausible player from another nation is offered and
  /// announced in the inbox. Most are mid-tier, still-developing players, but
  /// there is a small chance of a marquee name — and, realistically, a genuine
  /// star only ever surfaces from a strong footballing nation (a minnow simply
  /// hasn't got one). Two hits queue: the second appears once the first is
  /// answered.
  /// Rolls this cycle's naturalisation offer, weighted by the naturalisation
  /// budget just allocated for it. Called from the budget-setup event, so the
  /// investment is in place when the chance is computed (a strong naturalisation
  /// spend should make an offer likely). No-op if it can't run.
  Future<void> rollNaturalization(int careerId) async {
    final career = await _careers.byId(careerId);
    if (career == null) return;
    final nations = await _nationsById();
    await _maybeGenerateNaturalizationOffer(
      careerId,
      career.nationId,
      career.cyclePointer,
      career.inGameDate,
      nations,
    );
  }

  /// Rolls the cycle's naturalization interest at a seed-derived random point in
  /// the cycle (not tied to setting the budget), once per cycle. An approach
  /// from a foreign talent can then arrive at any time rather than always right
  /// after the budget is confirmed.
  Future<void> _rollNaturalizationIfDue(int careerId) async {
    final career = await _careers.byId(careerId);
    if (career == null) return;
    final cycle = career.cyclePointer;
    if (await _comp.hasWatchedDraw(careerId, cycle, 'natzrolled')) return;
    // A seed-derived due date between ~three and one years before the World Cup.
    final wcYear = CareerService.worldCupYear(cycle);
    final rng = SeededRng(career.rngSeed ^ (cycle * 0x2717) ^ 0x9A72CE);
    final due = DateTime(wcYear - 1 - rng.nextInt(3), 1 + rng.nextInt(12));
    if (career.inGameDate.isBefore(due)) return; // not time yet
    await _comp.markDrawWatched(careerId, cycle, 'natzrolled');
    await rollNaturalization(careerId);
  }

  Future<void> _maybeGenerateNaturalizationOffer(
    int careerId,
    int nationId,
    int nextCycle,
    DateTime cycleStart,
    Map<int, Nation> nations,
  ) async {
    final invest = await _careers.investment(careerId, nextCycle);
    final chance = FederationFinance.naturalizationChance(
      invest.naturalization,
    );
    final career = await _careers.byId(careerId);
    if (career == null) return;

    final others = nations.values.where((n) => n.id != nationId).toList()
      ..sort((a, b) => a.ranking.compareTo(b.ranking)); // strongest first
    if (others.isEmpty) return;
    final playerRepo = _ref.read(playerRepositoryProvider);
    final agingYears = (cycleStart.year - CareerService.cycleStart.year).clamp(
      0,
      400,
    );

    // Never re-offer a player already secured; keep the two rolls distinct.
    final taken = {
      for (final l in await _careers.acceptedNaturalizations(careerId))
        l.playerId,
    };
    final pending = await _careers.pendingNaturalization(careerId);
    if (pending != null) taken.add(pending.playerId);

    // Two independent rolls per cycle.
    for (var attempt = 0; attempt < 2; attempt++) {
      final rng = SeededRng(
        career.rngSeed ^ (nextCycle * 0x4E17) ^ (attempt * 0x51ED) ^ 0x9A72,
      );
      if (rng.nextDouble() >= chance) continue;

      // A small chance the candidate is a genuine star — but only ever from a
      // strong footballing nation (the top of the ranking), so the quality is
      // believable. Otherwise a mid-tier player from anywhere.
      final marquee = rng.nextDouble() < 0.05;
      final sources = marquee
          ? others
                .take(20)
                .toList() // only strong nations breed stars
          : others;
      final minR = marquee ? 85 : 66;
      final maxR = marquee ? 93 : 84;
      final maxAge = marquee ? 32 : 29;

      final candidates = <Player>[];
      for (var i = 0; i < 8 && candidates.length < 12; i++) {
        final n = sources[rng.nextInt(sources.length)];
        final pool = await playerRepo.byNation(
          n.id,
          agingYears: agingYears,
          saveSeed: career.rngSeed,
        );
        candidates.addAll(
          pool.where(
            (p) =>
                p.age <= maxAge &&
                p.overall >= minR &&
                p.overall <= maxR &&
                !taken.contains(p.id),
          ),
        );
      }
      if (candidates.isEmpty) continue;
      final pick = candidates[rng.nextInt(candidates.length)];
      taken.add(pick.id);
      final l = _l;
      final from = nations[pick.nationId]?.name ?? l.newsTheirNation;
      final to = nations[nationId]?.name ?? l.newsYourNation;

      await _careers.addNaturalizationOffer(
        careerId: careerId,
        playerId: pick.id,
        sourceNationId: pick.nationId,
        cycle: nextCycle,
      );
      await _comp.addMessage(
        careerId: careerId,
        dedupKey: 'natz:$nextCycle:${pick.id}',
        category: 'naturalize',
        title: pick.overall >= 85
            ? l.newsNatzStarTitle(pick.name, to)
            : l.newsNatzTitle(pick.name, to),
        body: pick.overall >= 85
            ? l.newsNatzBodyStar(
                pick.name,
                pick.position.label,
                from,
                to,
                pick.age,
                pick.overall,
              )
            : l.newsNatzBody(
                pick.name,
                pick.position.label,
                from,
                to,
                pick.age,
                pick.overall,
              ),
        year: SeasonService.finalsYear(nextCycle),
      );
    }
  }
}
