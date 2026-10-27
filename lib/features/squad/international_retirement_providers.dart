import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/core/util/message_text.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/repositories/international_retirement_repository.dart';
import 'package:fnm/domain/services/manager/stints.dart';
import 'package:fnm/domain/services/player/international_retirement.dart';
import 'package:fnm/domain/services/player/player_lifecycle.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/career_pool.dart';
import 'package:fnm/features/federation/naturalization_providers.dart';
import 'package:fnm/features/settings/settings_providers.dart';
import 'package:fnm/features/squad/captain_providers.dart';
import 'package:fnm/features/squad/grievance_providers.dart';
import 'package:fnm/features/tactics/tactics_providers.dart';

/// The international retirements (and comebacks) of a career, by player id.
/// For the screens that say so, such as the player page.
final AutoDisposeFutureProviderFamily<Map<int, IntlRetirement>, int>
intlRetirementsProvider = FutureProvider.autoDispose
    .family<Map<int, IntlRetirement>, int>(
      (ref, careerId) => ref
          .watch(playerRepositoryProvider)
          .internationalRetirements(careerId),
    );

/// The decisions behind [InternationalRetirement]: runs a wave after every
/// finished World Championship or continental finals, and a yearly comeback
/// roll, and tells the inbox.
///
/// Idempotent and catch-up safe: each tournament is marked once its wave has
/// run, each year once its comebacks have been rolled, so calling [settle]
/// twice changes nothing and a save that skipped ahead settles everything it
/// owes in order.
class InternationalRetirementService {
  InternationalRetirementService(this._ref);

  final Ref _ref;

  /// How many other nations' retirements one wave may file as news. The
  /// inbox is the manager's; the world's veterans are a headline, not a list.
  static const int maxForeignNews = 6;

  /// The rating from which another nation's veteran is famous enough to be
  /// news.
  static const int famousOverall = 84;

  /// Competition ids this session already knows are settled, per career: a
  /// cache that only spares re-reading their fixtures on every step. It never
  /// decides anything (the done markers do), so it may be lost freely.
  final Map<int, Set<int>> _doneIds = {};

  /// Runs every wave and comeback roll [careerId] owes. True when anybody's
  /// selectability changed, so a caller holding pools can drop them.
  ///
  /// [asOf] is the day it is settled on when the career's own date lags it
  /// (a final simulated in the middle of a step, before the step moves the
  /// career's clock): the retirements are dated, and the pools aged, on it.
  Future<bool> settle(int careerId, {DateTime? asOf}) async {
    var career = await _ref.read(careerRepositoryProvider).byId(careerId);
    if (career == null) return false;
    if (asOf != null && asOf.isAfter(career.inGameDate)) {
      career = career.copyWith(inGameDate: asOf);
    }
    final store = _ref.read(internationalRetirementRepositoryProvider);
    final years = CareerService.agingYears(career);

    // The first look at a career: everything already played is history. An
    // old save starts with nobody retired, and a new one has nothing played.
    if (!await store.hasMarker(careerId, InternationalRetirement.initMarker)) {
      final finished = await store.finishedFinals(careerId);
      await store.addMarkers(careerId, career.cyclePointer, [
        InternationalRetirement.initMarker,
        for (final f in finished) _doneMarker(f),
        '${InternationalRetirement.comebackCheckPrefix}$years',
      ]);
      return false;
    }

    var changed = false;
    final done = await store.markersWithPrefix(
      careerId,
      InternationalRetirement.donePrefix,
    );
    // Ids are only a shortcut past tournaments already dealt with in THIS
    // database; the done marker itself is keyed on the tournament's identity.
    final known = _doneIds[careerId] ??= {};
    for (final f in await store.finishedFinals(careerId, skip: known)) {
      final marker = _doneMarker(f);
      if (done.contains(marker)) {
        known.add(f.competitionId);
        continue;
      }
      // The wave writes its retirements AND this marker in one batch, so a
      // crash can never leave the one without the other.
      if (await _wave(career, f, years, marker)) changed = true;
      done.add(marker);
      known.add(f.competitionId);
    }

    final check = '${InternationalRetirement.comebackCheckPrefix}$years';
    if (!await store.hasMarker(careerId, check)) {
      if (await _comebacks(career, years, check)) changed = true;
    }

    if (changed) {
      _ref
        ..invalidate(intlRetirementsProvider)
        ..invalidate(squadDataProvider)
        ..invalidate(tacticDataProvider);
    }
    return changed;
  }

  /// The done marker of [f]: its kind, confederation and cycle, which a
  /// career bundle carries unchanged (its competition id does not survive an
  /// import).
  static String _doneMarker(FinishedFinals f) =>
      '${InternationalRetirement.donePrefix}'
      '${InternationalRetirement.waveKey(f.kind, f.confederation, f.cycle)}';

  /// A nation's selectable seniors in [career], as the guard counts them:
  /// without anyone naturalised away, with anyone naturalised into the
  /// manager's side, and without anyone who walked out on him.
  Future<List<Player>> _poolFor(
    Career career,
    int nationId,
    int years,
    Set<int> away,
    Set<int> walked,
    List<Player> naturalizedIn, {
    List<Player>? raw,
  }) async {
    final players = _ref.read(playerRepositoryProvider);
    // [raw] is the nation's pool read with the retired still in it (the
    // comeback roll needs them); filtered here exactly as [byNation] does.
    final pool = raw != null
        ? InternationalRetirement.filterPool(
            raw,
            await players.internationalRetirements(career.id),
            years,
          )
        : await players.byNation(
            nationId,
            agingYears: years,
            saveSeed: career.rngSeed,
            careerId: career.id,
          );
    final out = dropNaturalizedAway(pool, away);
    if (nationId != career.nationId) return out;
    return [
      for (final p in withNaturalizedIn(out, naturalizedIn))
        if (!walked.contains(p.id)) p,
    ];
  }

  /// The manager's naturalised men who are still selectable at [years].
  Future<List<Player>> _naturalizedIn(Career career, int years) async {
    final retired = await _ref
        .read(playerRepositoryProvider)
        .internationalRetirements(career.id);
    return [
      for (final p in await naturalizedPlayersFor(_ref, career))
        if (!(retired[p.id]?.isRetiredAt(years) ?? false)) p,
    ];
  }

  Future<bool> _wave(
    Career career,
    FinishedFinals f,
    int years,
    String doneMarker,
  ) async {
    final careerId = career.id;
    final comp = _ref.read(competitionRepositoryProvider);
    final nations = await _ref
        .read(nationRepositoryProvider)
        .forCareer(careerId);
    final considered = [
      for (final n in nations)
        if (f.kind == CompetitionKind.worldCupFinals ||
            n.confederation == f.confederation)
          n,
    ]..sort((a, b) => a.id.compareTo(b.id));

    final apps = <int, int>{};
    final ratings = <int, double>{};
    for (final line in await comp.competitionPlayerLines(
      careerId,
      f.competitionId,
    )) {
      apps[line.playerId] = line.apps;
      if (line.apps > 0) ratings[line.playerId] = line.meanRating;
    }
    final away = await naturalizedAwayIds(
      _ref.read(careerRepositoryProvider),
      careerId,
    );
    final walked = await _ref.read(walkoutsProvider(careerId).future);
    final already = await _ref
        .read(playerRepositoryProvider)
        .internationalRetirements(careerId);
    final naturalizedIn = await _naturalizedIn(career, years);
    // Long injuries count against the guard: a man out for the next camps is
    // not cover the nation can lean on.
    final longInjured = {
      for (final e
          in (await _ref.read(absenceRepositoryProvider).forCareer(careerId))
              .entries)
        if (e.value.injuryMatches >= InternationalRetirement.longInjuryMatches)
          e.key,
    };
    final record = await _record(career);
    // Stable across careers and bundle imports: the tournament's identity,
    // never its row id.
    final salt = InternationalRetirement.stableHash(
      InternationalRetirement.waveKey(f.kind, f.confederation, f.cycle),
    );

    final markers = <String>[doneMarker];
    final foreign = <(Player, Nation, IntlRetireReason)>[];
    final mine = <IntlRetireDecision>[];
    for (final n in considered) {
      final participated = f.participants.contains(n.id);
      final pool = await _poolFor(
        career,
        n.id,
        years,
        away,
        walked,
        naturalizedIn,
      );
      if (pool.isEmpty) continue;
      final ranked = [...pool]..sort((a, b) => b.overall.compareTo(a.overall));
      final rankOf = {
        for (var i = 0; i < ranked.length; i++) ranked[i].id: i,
      };
      final decisions = InternationalRetirement.waveFor(
        pool: pool,
        guardPool: InternationalRetirement.guardPoolFor(
          pool,
          years,
          longInjured: longInjured,
        ),
        context: (
          participated: participated,
          champion: f.championId == n.id,
          worldChampionship: f.kind == CompetitionKind.worldCupFinals,
          appsByPlayer: participated ? apps : const {},
          ratingByPlayer: participated ? ratings : const {},
        ),
        rng: SeededRng(
          InternationalRetirement.seedFor(career.rngSeed, salt, n.id),
        ),
        alreadyRetired: already.keys.toSet(),
      );
      for (final d in decisions) {
        final id = d.player.id;
        markers.add(
          InternationalRetirement.retiredKind(
            id,
            years,
            career.inGameDate,
            nationId: n.id,
            // Only a real international gets the country's farewell on Y.
            notable:
                n.id == career.nationId &&
                ((rankOf[id] ?? 99) < 23 ||
                    (record.caps[id] ?? 0) >= 20 ||
                    (record.goals[id] ?? 0) >= 10 ||
                    career.captainPlayerId == id ||
                    record.leaders.contains(id)),
          ),
        );
        if (n.id == career.nationId) {
          mine.add(d);
        } else if (d.player.overall >= famousOverall ||
            PlayerLifecycle.isSuperstar(d.player.id)) {
          foreign.add((d.player, n, d.reason));
        }
      }
    }
    // One batch (one transaction): the retirements and the done marker land
    // together or not at all. The announcements follow; at worst a crash
    // costs a message, never an extra retirement.
    await _ref
        .read(internationalRetirementRepositoryProvider)
        .addMarkers(careerId, career.cyclePointer, markers);
    if (markers.length == 1) return false;
    await _announceMine(career, mine, record);
    foreign.sort((a, b) => b.$1.overall.compareTo(a.$1.overall));
    await _announceForeign(career, foreign.take(maxForeignNews).toList());
    return true;
  }

  /// The note a reason adds to the announcement, if any.
  static MsgText? _reasonNote(IntlRetireReason r) => switch (r) {
    IntlRetireReason.age => null,
    IntlRetireReason.onAHigh => const MsgText(MsgKey.msgIntlRetireNoteHigh),
    IntlRetireReason.missedOut => const MsgText(
      MsgKey.msgIntlRetireNoteMissed,
    ),
    IntlRetireReason.surprise => const MsgText(
      MsgKey.msgIntlRetireNoteSurprise,
    ),
  };

  /// The manager's own veterans: one inbox message each, with his record, the
  /// reason, and (for the captain or a record holder) the bigger story.
  /// The manager's nation's caps and goals, and who holds each record.
  Future<_Record> _record(Career career) async {
    final comp = _ref.read(competitionRepositoryProvider);
    final caps = await comp.nationTopAppearances(
      career.id,
      career.nationId,
      limit: 500,
    );
    final scorers = await comp.nationTopScorers(
      career.id,
      career.nationId,
      limit: 500,
    );
    return (
      caps: {for (final c in caps) c.playerId: c.games},
      goals: {for (final s in scorers) s.playerId: s.goals},
      leaders: {
        if (caps.isNotEmpty && caps.first.games > 0) caps.first.playerId,
        if (scorers.isNotEmpty && scorers.first.goals > 0)
          scorers.first.playerId,
      },
    );
  }

  Future<void> _announceMine(
    Career career,
    List<IntlRetireDecision> mine,
    _Record record,
  ) async {
    if (mine.isEmpty) return;
    final careerId = career.id;
    final comp = _ref.read(competitionRepositoryProvider);
    final l = _ref.read(appLocalizationsProvider);
    for (final d in mine) {
      final p = d.player;
      final pc = record.caps[p.id] ?? 0;
      final pg = record.goals[p.id] ?? 0;
      final wasCaptain = career.captainPlayerId == p.id;
      if (wasCaptain) {
        await _ref.read(careerRepositoryProvider).setCaptain(careerId, null);
        _ref
          ..invalidate(captainProvider)
          ..invalidate(storedCaptainIdProvider)
          ..invalidate(captainMoraleProvider)
          ..invalidate(careerByIdProvider);
      }
      final tally = MsgJoin([
        if (pc > 0) MsgText(MsgKey.msgTallyCaps, [pc]),
        if (pg > 0) MsgText(MsgKey.msgTallyGoals, [pg]),
      ], separator: ', ');
      final recordHolder = record.leaders.contains(p.id);
      await comp.addTextMessage(
        l: l,
        careerId: careerId,
        // The key the yearly report's own send-off uses, so a veteran who
        // announced it is never sent off a second time by the age wave.
        dedupKey: 'retire:${p.id}',
        category: 'retirement',
        title: MsgText(
          wasCaptain ? MsgKey.msgRetireCaptainTitle : MsgKey.msgRetireTitle,
          [p.name],
        ),
        body: MsgJoin([
          if (tally.parts.isEmpty)
            MsgText(MsgKey.msgRetireBody, [p.name, p.age])
          else
            MsgText(MsgKey.msgRetireBodyWith, [p.name, tally, p.age]),
          ?_reasonNote(d.reason),
          if (recordHolder) const MsgText(MsgKey.msgIntlRetireNoteRecord),
          if (wasCaptain) const MsgText(MsgKey.msgArmbandVacant),
        ]),
        year: career.inGameDate.year,
      );
    }
  }

  /// The world's famous veterans, as news.
  Future<void> _announceForeign(
    Career career,
    List<(Player, Nation, IntlRetireReason)> foreign,
  ) async {
    if (foreign.isEmpty) return;
    final comp = _ref.read(competitionRepositoryProvider);
    final l = _ref.read(appLocalizationsProvider);
    for (final (p, n, reason) in foreign) {
      await comp.addTextMessage(
        l: l,
        careerId: career.id,
        dedupKey: 'intlRetNews:${p.id}',
        category: 'retirement',
        title: MsgText(MsgKey.msgIntlRetireNewsTitle, [p.name, n.name]),
        body: MsgJoin([
          MsgText(MsgKey.msgIntlRetireNewsBody, [p.name, n.name, p.age]),
          ?_reasonNote(reason),
        ]),
        year: career.inGameDate.year,
      );
    }
  }

  /// The yearly roll: a retired player who is still good enough may come
  /// back, once, likelier in an injury crisis or under a new manager.
  Future<bool> _comebacks(Career career, int years, String check) async {
    final careerId = career.id;
    final players = _ref.read(playerRepositoryProvider);
    // Only the retirees who could still come back are resolved at all: the
    // list of everyone who ever retired grows by hundreds a cycle, and
    // reading each of them every December stalled a long save. Pruned on the
    // marker alone: never back before, a full year out at least (a summer
    // retirement is not eligible at the first December tick, only the one
    // after), and not so long ago that he is past [comebackMaxAge] (nobody
    // retires before [earliestRetirementAge]).
    final byNation = await players.internationalRetirementsByNation(careerId);
    final candidatesByNation = <int, List<IntlRetirement>>{};
    for (final e in byNation.entries) {
      for (final r in e.value.values) {
        final out = years - r.retiredAging;
        if (r.comebackAging == null &&
            out >= 2 &&
            out <= InternationalRetirement.maxYearsAwayForComeback) {
          (candidatesByNation[e.key] ??= []).add(r);
        }
      }
    }
    final candidates = [
      for (final list in candidatesByNation.values) ...list,
    ]..sort((a, b) => a.playerId.compareTo(b.playerId));
    final store = _ref.read(internationalRetirementRepositoryProvider);
    if (candidates.isEmpty) {
      await store.addMarkers(careerId, career.cyclePointer, [check]);
      return false;
    }

    final away = await naturalizedAwayIds(
      _ref.read(careerRepositoryProvider),
      careerId,
    );
    final walked = await _ref.read(walkoutsProvider(careerId).future);
    final absences = await _ref
        .read(absenceRepositoryProvider)
        .forCareer(careerId);
    final stints = await _ref.read(careerRepositoryProvider).stints(careerId);
    final arrival = Stints.arrivalCycle(
      stints,
      career.cyclePointer,
      career.nationId,
    );
    final nations = {
      for (final n
          in await _ref.read(nationRepositoryProvider).forCareer(careerId))
        n.id: n,
    };
    final naturalizedIn = await _naturalizedIn(career, years);
    // One read per nation with a candidate (retired men left in), not one
    // per retiree. A man missing from the nation he retired from has aged
    // out or been naturalised away, and neither comes back; only a marker
    // that names no nation is read on its own.
    final raw = <int, List<Player>>{};
    final resolved = <int, Player>{};
    for (final nationId in candidatesByNation.keys.toList()..sort()) {
      if (nationId == 0) continue;
      final pool = await players.byNation(
        nationId,
        agingYears: years,
        saveSeed: career.rngSeed,
        careerId: careerId,
        includeIntlRetired: true,
      );
      raw[nationId] = pool;
      final byId = {for (final p in pool) p.id: p};
      for (final r in candidatesByNation[nationId]!) {
        final p = byId[r.playerId];
        if (p != null) resolved[r.playerId] = p;
      }
    }
    final pools = <int, List<Player>>{};
    final markers = <String>[check];
    final back = <(Player, Nation?, bool crisis, bool newManager)>[];
    final year = career.inGameDate.year;
    for (final r in candidates) {
      final p = r.nationId != null && r.nationId != 0
          ? resolved[r.playerId]
          : await players.byId(
              r.playerId,
              agingYears: years,
              saveSeed: career.rngSeed,
              careerId: careerId,
            );
      if (p == null || away.contains(p.id)) continue;
      if (p.age > InternationalRetirement.comebackMaxAge) continue;
      // The age wave has ended his career anyway: nothing to come back to.
      if (PlayerLifecycle.hasRetiredAt(p.id, p.age, years)) continue;
      final pool = pools[p.nationId] ??= await _poolFor(
        career,
        p.nationId,
        years,
        away,
        walked,
        naturalizedIn,
        raw: raw[p.nationId],
      );
      final best23 = ([
        ...pool,
      ]..sort((a, b) => b.overall.compareTo(a.overall))).take(23);
      final injured = best23
          .where((q) => (absences[q.id]?.injuryMatches ?? 0) > 0)
          .length;
      // A new man in the dugout: his first two years in the job, for a
      // player who retired under his predecessor (filed in an earlier cycle).
      final newManager =
          p.nationId == career.nationId &&
          arrival == career.cyclePointer &&
          years < arrival * 4 + 2 &&
          r.retiredCycle != null &&
          r.retiredCycle! < arrival;
      final returns = InternationalRetirement.comesBack(
        p: p,
        pool: pool,
        injuredInSquad: injured,
        newManager: newManager,
        rng: SeededRng(
          InternationalRetirement.seedFor(
            career.rngSeed,
            0x0BAC0000 + years,
            p.id,
          ),
        ),
      );
      if (!returns) continue;
      markers.add(
        InternationalRetirement.comebackKind(p.id, years, career.inGameDate),
      );
      back.add((p, nations[p.nationId], injured >= 3, newManager));
    }
    // The comebacks and the year's check marker in one batch.
    await store.addMarkers(careerId, career.cyclePointer, markers);
    if (markers.length == 1) return false;

    final comp = _ref.read(competitionRepositoryProvider);
    final l = _ref.read(appLocalizationsProvider);
    for (final (p, n, crisis, newManager) in back) {
      if (p.nationId == career.nationId) {
        await comp.addTextMessage(
          l: l,
          careerId: careerId,
          dedupKey: 'intlBack:${p.id}',
          category: 'retirement',
          title: MsgText(MsgKey.msgIntlComebackTitle, [p.name]),
          body: MsgJoin([
            MsgText(MsgKey.msgIntlComebackBody, [p.name, p.age]),
            if (crisis)
              const MsgText(MsgKey.msgIntlComebackNoteCrisis)
            else if (newManager)
              const MsgText(MsgKey.msgIntlComebackNoteManager),
          ]),
          year: year,
        );
      } else if (n != null &&
          (p.overall >= famousOverall || PlayerLifecycle.isSuperstar(p.id))) {
        await comp.addTextMessage(
          l: l,
          careerId: careerId,
          dedupKey: 'intlBackNews:${p.id}',
          category: 'retirement',
          title: MsgText(MsgKey.msgIntlComebackNewsTitle, [p.name, n.name]),
          body: MsgText(MsgKey.msgIntlComebackNewsBody, [
            p.name,
            n.name,
            p.age,
          ]),
          year: year,
        );
      }
    }
    return true;
  }
}

/// The manager's nation's record book, for the announcements.
typedef _Record = ({
  Map<int, int> caps,
  Map<int, int> goals,
  Set<int> leaders,
});

final Provider<InternationalRetirementService>
internationalRetirementServiceProvider = Provider(
  InternationalRetirementService.new,
);
