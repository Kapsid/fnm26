import 'dart:math' as math;

import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/core/util/text_variety.dart';
import 'package:fnm/domain/entities/world_manager.dart';
import 'package:fnm/domain/services/world_managers/manager_reputation.dart';

/// What one AI nation did since the last decision point.
typedef NationWindow = ({
  int briefNet,
  double surpriseSum,
  bool settledFinalsBriefMet,
  bool anyBriefSettled,
});

/// One decision point. `scope` is the set of nations whose tournament just
/// settled, or every nation at a rollover; `key` is unique per point.
typedef DecisionContext = ({
  DateTime date,
  Map<int, int> rankById,
  Set<int> scope,
  Set<int> playerNationIds,
  int rngSeed,
  String key,
  bool rollover,
});

/// The manager decision engine (spec section 2): sackings, resignations,
/// contracts, retirements, poaching and hiring at one decision point. Pure:
/// it reads a [ManagerWorld] and returns the [ManagerChanges] to apply.
abstract final class ManagerDecisions {
  // Spec values.
  static const double bigSackChance = 0.60;
  static const double smallSackChance = 0.25;
  static const double bigSackBelow = -2;
  static const double smallSackBelow = -1;
  static const double capShare = 0.25;
  static const int retireFromAge = 64;
  static const int freeYearsToLeave = 8;
  static const int poachTopRank = 40;
  static const int poachRankGap = 20;
  static const int poachMargin = 15;
  static const int domesticOwnBonus = 8;
  static const int domesticBonus = 5;

  // Rulings, tuned in the tenure lab (manager_lab_test.dart, 5 cycles x 8
  // seeds): with the spec's cap and 12-month guards, turnover plateaus near
  // a 6-year tenure; these are the mildest values that keep the guard's band.
  /// (Ruling) A badly beaten manager not sacked walks at this chance.
  static const double resignChance = 0.40;

  /// (Ruling) A contract, new or renewed, runs this many whole years (a
  /// spread of 2 to 6 left the lab at 6.4 years).
  static const int contractMinYears = 2;
  static const int contractMaxYears = 4;

  /// The best reputation a nation of [rank] can attract.
  static double attractCap(int rank) =>
      math.min(100, 40 + (ManagerReputation.unranked - rank) * 0.3);

  /// The chance a manager of [age] retires at a rollover: none until 64,
  /// certain from 75.
  static double retireChance(int age) =>
      age < retireFromAge ? 0 : ((age - 63) / 12).clamp(0.0, 1.0);

  /// Runs one decision point.
  ///
  /// [finalsBriefMetOn] holds, per nation, the date of the last earlier
  /// decision point at which its manager met a settled finals brief: he is
  /// safe from the sack for 12 months after it. [codeById] (FIFA codes) feeds
  /// the domestic preference when hiring.
  static ManagerChanges decide(
    ManagerWorld w,
    Map<int, NationWindow> windows,
    DecisionContext ctx, {
    Map<int, int> honoursByManager = const {},
    List<WorldManager> entrants = const [],
    Map<int, DateTime> finalsBriefMetOn = const {},
    Map<int, String> codeById = const {},
  }) {
    final date = ctx.date;
    final yearAgo = DateTime(date.year - 1, date.month, date.day);
    final player = ctx.playerNationIds;
    bool inScope(int n) => ctx.scope.contains(n) && !player.contains(n);
    int rankOf(int n) => ctx.rankById[n] ?? ManagerReputation.unranked;

    // The cap: a quarter of the world's AI nations.
    final ai = {
      ...ctx.rankById.keys,
      if (ctx.rankById.isEmpty) ...{for (final s in w.spells) s.nationId},
    }..removeAll(player);
    final budget = (ai.length * capShare).floor();

    // One stream per nation, its draws taken in a fixed order up front so a
    // draw used on one path never shifts another.
    final rolls = <int, _Rolls>{};
    _Rolls rollsFor(int n) => rolls[n] ??= _Rolls(
      SeededRng(varietySeed('mgr:decide:${ctx.rngSeed}:${ctx.key}:$n')),
    );

    final byId = {for (final m in w.managers) m.managerId: m};
    final spellsOf = <int, List<ManagerSpell>>{};
    final current = <int, ManagerSpell>{};
    final changedAt = <int, DateTime>{};
    for (final s in w.spells) {
      (spellsOf[s.managerId] ??= []).add(s);
      if (s.current) current[s.nationId] = s;
      for (final d in [s.fromDate, ?s.toDate]) {
        final seen = changedAt[s.nationId];
        if (seen == null || d.isAfter(seen)) changedAt[s.nationId] = d;
      }
    }
    bool changedRecently(int n) => changedAt[n]?.isAfter(yearAgo) ?? false;

    final updated = <int, WorldManager>{};
    final closed = <ManagerSpell>[];
    final renewed = <int, ManagerSpell>{};
    final opened = <ManagerSpell>[];
    final outgoing = <int, ({int id, SpellEnd why})>{};
    final incoming = <int, int>{};
    final released = <int>{};
    var nextSpell = w.nextSpellNo;

    void retire(WorldManager m) =>
        updated[m.managerId] = m.copyWith(retiredAt: date);
    void end(ManagerSpell s, SpellEnd why, {int? briefNet}) {
      closed.add(_withTerms(s, briefNet: briefNet).close(date, why));
      renewed.remove(s.spellNo);
      outgoing[s.nationId] = (id: s.managerId, why: why);
      released.add(s.managerId);
      current.remove(s.nationId);
    }

    DateTime contractFrom(int years) =>
        DateTime(date.year + years, date.month, date.day);

    // 6. Retirement and the long-unhired leaving (rollover only).
    final employedAt = {for (final s in current.values) s.managerId: s};
    if (ctx.rollover) {
      for (final m in w.managers) {
        if (m.retiredAt != null) continue;
        final spell = employedAt[m.managerId];
        if (spell != null && !inScope(spell.nationId)) continue;
        final roll = spell != null
            ? rollsFor(spell.nationId).retire
            : SeededRng(
                varietySeed(
                  'mgr:decide:${ctx.rngSeed}:${ctx.key}:free:${m.managerId}',
                ),
              ).nextDouble();
        if (roll < retireChance(date.year - m.birthYear)) {
          retire(m);
          if (spell != null) end(spell, SpellEnd.retired);
          continue;
        }
        if (spell == null) {
          var last = m.enteredAt;
          for (final s in spellsOf[m.managerId] ?? const <ManagerSpell>[]) {
            final to = s.toDate;
            if (to != null && to.isAfter(last)) last = to;
          }
          final leaveOn = DateTime(
            last.year + freeYearsToLeave,
            last.month,
            last.day,
          );
          if (!date.isBefore(leaveOn)) retire(m);
        }
      }
    }

    // 1 to 4. Score, sack, resign, contract.
    final voluntary = <_Candidate>[];
    final nations = [...current.keys]..sort();
    for (final n in nations) {
      if (!inScope(n)) continue;
      final s = current[n]!;
      final win = windows[n];
      final score = win == null ? 0.0 : win.briefNet + 0.5 * win.surpriseSum;
      final net = s.briefNet + score.round();
      final r = rollsFor(n);
      final guarded = s.fromDate.isAfter(yearAgo) || changedRecently(n);
      final metOn = finalsBriefMetOn[n];
      final shielded =
          (win?.settledFinalsBriefMet ?? false) ||
          (metOn != null && metOn.isAfter(yearAgo));
      final renewal = _withTerms(
        s,
        briefNet: net,
        until: contractFrom(r.years(contractMinYears, contractMaxYears)),
      );
      final expired = !date.isBefore(s.contractUntil);
      // The spell as it stands, carrying the score: what a change the cap
      // trims leaves behind. An expired contract stays expired, so the next
      // decision point looks at him again rather than handing him years.
      final held = net == s.briefNet ? null : _withTerms(s, briefNet: net);

      SpellEnd? why;
      if (!guarded) {
        final p = score < bigSackBelow
            ? bigSackChance
            : score < smallSackBelow
            ? smallSackChance
            : 0.0;
        if (!shielded && r.sack < p) {
          why = SpellEnd.sacked;
        } else if (!shielded &&
            score < bigSackBelow &&
            (win?.anyBriefSettled ?? false) &&
            r.resign < resignChance) {
          why = SpellEnd.resigned;
        } else if (expired && score < 0) {
          why = SpellEnd.contractEnd;
        }
      }
      if (why == null) {
        final keep = expired ? renewal : held;
        if (keep != null) renewed[s.spellNo] = keep;
      } else {
        voluntary.add((
          nation: n,
          spell: s,
          why: why,
          score: score,
          net: net,
          held: held,
        ));
      }
    }

    // 5. The cap. Forced vacancies always count and are always filled; the
    // voluntary changes go worst score first, and those the cap trims stay
    // on as they were (an expired contract held over to the next point).
    final vacant = <int>{
      for (final n in ctx.scope)
        if (inScope(n) && !current.containsKey(n)) n,
    };
    var used = vacant.length;
    voluntary.sort((a, b) {
      final c = a.score.compareTo(b.score);
      return c != 0 ? c : a.nation.compareTo(b.nation);
    });
    for (final c in voluntary) {
      if (used < budget) {
        end(c.spell, c.why, briefNet: c.net);
        vacant.add(c.nation);
        used++;
      } else if (c.held case final h?) {
        renewed[c.spell.spellNo] = h;
      }
    }

    // 7. Entrants join the pool (rollover only).
    final added = ctx.rollover ? entrants : const <WorldManager>[];
    final busy = {for (final s in current.values) s.managerId};
    final pool = <WorldManager>[
      for (final m in [...w.managers, ...added])
        if (m.retiredAt == null &&
            !updated.containsKey(m.managerId) &&
            !busy.contains(m.managerId) &&
            !released.contains(m.managerId))
          m,
    ];
    final fallback = <WorldManager>[
      for (final id in released)
        if (!updated.containsKey(id) && byId[id] != null) byId[id]!,
    ];

    final reps = <int, int>{};
    int rep(int id) => reps[id] ??= ManagerReputation.score(
      spellsOf[id] ?? const [],
      ctx.rankById,
      honoursByManager[id] ?? 0,
      date,
    );

    WorldManager? pick(List<WorldManager> from, int nation) {
      if (from.isEmpty) return null;
      final cap = attractCap(rankOf(nation));
      final code = codeById[nation]?.toUpperCase();
      int bonus(WorldManager m) {
        if (code == null || m.nationality.toUpperCase() != code) return 0;
        return m.origin == ManagerOrigin.fresh
            ? domesticBonus
            : domesticOwnBonus;
      }

      WorldManager? best;
      for (final m in from) {
        if (rep(m.managerId) > cap) continue;
        if (best == null) {
          best = m;
          continue;
        }
        final a = rep(m.managerId) + bonus(m);
        final b = rep(best.managerId) + bonus(best);
        if (a > b || (a == b && m.managerId < best.managerId)) best = m;
      }
      if (best != null) return best;
      for (final m in from) {
        if (best == null ||
            rep(m.managerId) < rep(best.managerId) ||
            (rep(m.managerId) == rep(best.managerId) &&
                m.managerId < best.managerId)) {
          best = m;
        }
      }
      return best;
    }

    void open(int nation, WorldManager m) {
      opened.add(
        ManagerSpell(
          spellNo: nextSpell++,
          managerId: m.managerId,
          nationId: nation,
          fromDate: date,
          contractUntil: contractFrom(
            rollsFor(nation).hireYears(contractMinYears, contractMaxYears),
          ),
        ),
      );
      incoming[nation] = m.managerId;
    }

    // 8 and 9. Poaching (rollover only) and hiring, best nation first.
    final noChain = <int>{};
    final queue = vacant.toList();
    int byRank(int a, int b) {
      final c = rankOf(a).compareTo(rankOf(b));
      return c != 0 ? c : a.compareTo(b);
    }

    while (queue.isNotEmpty) {
      queue.sort(byRank);
      final v = queue.removeAt(0);
      final rank = rankOf(v);
      final free = pick(pool, v);
      if (ctx.rollover &&
          !noChain.contains(v) &&
          rank <= poachTopRank &&
          used < budget) {
        final bar = (free == null ? 0 : rep(free.managerId)) + poachMargin;
        ManagerSpell? target;
        for (final t in current.values) {
          if (!inScope(t.nationId) || changedRecently(t.nationId)) continue;
          if (incoming.containsKey(t.nationId)) continue;
          if (rankOf(t.nationId) < rank + poachRankGap) continue;
          if (rep(t.managerId) < bar) continue;
          if (target == null ||
              rep(t.managerId) > rep(target.managerId) ||
              (rep(t.managerId) == rep(target.managerId) &&
                  t.managerId < target.managerId)) {
            target = t;
          }
        }
        if (target != null) {
          final m = byId[target.managerId]!;
          final kept = renewed[target.spellNo];
          end(target, SpellEnd.poached, briefNet: kept?.briefNet);
          released.remove(m.managerId);
          open(v, m);
          noChain.add(target.nationId);
          queue.add(target.nationId);
          used++;
          continue;
        }
      }
      var m = free;
      var from = pool;
      if (m == null) {
        from = fallback;
        m = pick(fallback, v);
      }
      if (m == null) continue;
      from.remove(m);
      open(v, m);
    }

    final touched = {...outgoing.keys, ...incoming.keys};
    return ManagerChanges(
      added: added,
      updated: updated.values.toList(),
      opened: opened,
      closed: closed,
      renewed: renewed.values.toList(),
      moves: [
        for (final n in touched.toList()..sort())
          (
            nationId: n,
            outgoingId: outgoing[n]?.id,
            why: outgoing[n]?.why,
            incomingId: incoming[n],
            date: date,
          ),
      ],
    );
  }

  static ManagerSpell _withTerms(
    ManagerSpell s, {
    int? briefNet,
    DateTime? until,
  }) => ManagerSpell(
    spellNo: s.spellNo,
    managerId: s.managerId,
    nationId: s.nationId,
    fromDate: s.fromDate,
    toDate: s.toDate,
    endReason: s.endReason,
    contractUntil: until ?? s.contractUntil,
    briefNet: briefNet ?? s.briefNet,
  );
}

typedef _Candidate = ({
  int nation,
  ManagerSpell spell,
  SpellEnd why,
  double score,
  int net,
  ManagerSpell? held,
});

/// One nation's draws for one decision point, in a fixed order.
class _Rolls {
  _Rolls(SeededRng rng)
    : retire = rng.nextDouble(),
      sack = rng.nextDouble(),
      resign = rng.nextDouble(),
      _renew = rng.nextDouble(),
      _hire = rng.nextDouble();

  final double retire;
  final double sack;
  final double resign;
  final double _renew;
  final double _hire;

  int years(int min, int max) => min + (_renew * (max - min + 1)).floor();
  int hireYears(int min, int max) => min + (_hire * (max - min + 1)).floor();
}
