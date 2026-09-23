import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/competition/continental_cups.dart';
import 'package:fnm/domain/services/competition/rounds.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/hub/hub_providers.dart';

/// International match windows (month numbers) a friendly can be arranged in.
const _windowMonths = [9, 10, 11, 3, 6];

/// Marks a friendly window (year/month) decided, so the hub stops prompting for
/// it once the manager has arranged or declined a game there.
String friendlyWindowKey(DateTime d) => 'friendly:${d.year}-${d.month}';

/// Whether the manager's side hosts a friendly arranged in the window on [d].
/// Fixed by the window (not the opponent) so the arrange screen can show it
/// before anything is scheduled, and so it matches what [FriendliesService]
/// actually saves.
bool friendlyIsHome(DateTime d) => d.month.isEven;

/// Why the shortlist is ordered the way it is — the thing a manager has to be
/// told, because a list reordered silently is just a different list.
enum FriendlyReason {
  /// A finals group is drawn: the shortlist resembles the sides in it.
  finalsGroup,

  /// The next competitive block is a qualifying campaign: the shortlist
  /// resembles the sides still to be played in it.
  qualifyingGroup,

  /// Nothing is drawn yet, so the shortlist is simply close to the manager's
  /// own standing in the world.
  ranking,
}

/// The friendlies the manager can arrange in the current gap before their next
/// competitive fixture: every open window in that gap and a shortlist of
/// suggested [opponents] (by ranking proximity). Null when there is no gap.
class FriendliesPlan {
  const FriendliesPlan({
    required this.windows,
    this.rivals = const [],
    this.reason = FriendlyReason.ranking,
    required this.opponents,
    required this.nations,
    required this.playerNationId,
    required this.cycle,
  });

  final List<DateTime> windows;

  /// Who the nation is warming up FOR, and why the shortlist looks the way it
  /// does. Never empty of meaning: with no group drawn yet the reason is the
  /// ranking, and the screen says so.
  final List<Nation> rivals;
  final FriendlyReason reason;
  final List<Nation> opponents;
  final Map<int, Nation> nations;
  final int playerNationId;
  final int cycle;
}

final AutoDisposeFutureProviderFamily<FriendliesPlan?, int>
friendliesPlanProvider = FutureProvider.autoDispose.family<FriendliesPlan?, int>(
  (
    ref,
    careerId,
  ) async {
    final career = await ref.watch(careerRepositoryProvider).byId(careerId);
    if (career == null) return null;
    final comp = ref.watch(competitionRepositoryProvider);
    final fixtures = await comp.fixturesForNation(careerId, career.nationId);

    // The next competitive fixture bounds the current gap. Warm-ups are only
    // offered when there's an upcoming block to prepare for.
    DateTime? nextComp;
    final occupied = <(int, int)>{};
    for (final f in fixtures) {
      occupied.add((f.date.year, f.date.month));
      final isCompetitive = f.round != 'FRIENDLY';
      if (!f.played && isCompetitive) {
        if (nextComp == null || f.date.isBefore(nextComp)) nextComp = f.date;
      }
    }
    if (nextComp == null) return null;

    final all = await ref.watch(nationRepositoryProvider).all();
    final nations = {for (final n in all) n.id: n};

    // Windows that a finals tournament will swallow, even though nothing is on
    // the calendar there yet.
    //
    // [occupied] can only see fixtures that EXIST. A side that reaches a finals
    // without playing a qualifier — a host, above all — has no fixture in the
    // tournament's month until the draw is made, so its June window looked free
    // and a warm-up could be booked straight into the middle of its own
    // tournament. The finals calendar is deterministic, so those months are
    // blocked up front and only released once the draw proves the nation isn't
    // in the field (at which point its fixtures, or the absence of them, speak
    // for themselves).
    final blocked = await _finalsWindows(comp, career, nations);

    final now = career.inGameDate;
    final candidates = <DateTime>[];
    for (var year = now.year; year <= now.year + 2; year++) {
      for (final month in _windowMonths) {
        candidates.add(DateTime(year, month, 14));
      }
    }
    candidates.sort();

    final windows = <DateTime>[];
    for (final d in candidates) {
      if (!d.isAfter(now)) continue;
      if (!d.isBefore(nextComp)) break; // only the gap before the next block
      if (occupied.contains((d.year, d.month))) continue;
      if (blocked.contains((d.year, d.month))) continue;
      if (await comp.hasWatchedDraw(
        careerId,
        career.cyclePointer,
        friendlyWindowKey(d),
      )) {
        continue;
      }
      windows.add(d);
      // The WHOLE gap, in one sitting. It used to stop at three, and arranging
      // those three simply revealed the next three — so a long gap before a
      // tournament asked the same question at three consecutive events, which
      // reads as the game having lost track of what you already answered.
      // Six is a ceiling against an absurd calendar, not a page size; a real
      // gap holds two or three.
      if (windows.length >= 6) break;
    }
    if (windows.isEmpty) return null;

    final me = nations[career.nationId];
    final myRank = me?.ranking ?? 100;
    // A ranking-plausible candidate pool (closest ~60 by strength), then a
    // seeded shuffle so the suggested opponents vary cycle to cycle instead of
    // always being the same static nearest-neighbours list.
    final byProximity = all.where((n) => n.id != career.nationId).toList()
      ..sort(
        (a, b) =>
            (a.ranking - myRank).abs().compareTo((b.ranking - myRank).abs()),
      );
    final pool = byProximity.take(60).toList();
    final rng = SeededRng(
      career.rngSeed ^ (career.cyclePointer * 0x2F) ^ 0xF1E4,
    );
    final shuffled = rng.shuffled(pool);

    // If the finals group is already drawn, the point of a friendly changes.
    // It stops being an exhibition and becomes preparation for three specific
    // sides, which is what a real federation books them for — you play
    // somebody who resembles who you have got.
    //
    // Ranking is the proxy for resemblance the rest of the game already uses,
    // so a candidate is scored by how close he is to the NEAREST of the drawn
    // rivals, and the closest float to the front. A confederation match is
    // worth something too: sides from the same continent play a recognisable
    // way, and that is half of what the manager is trying to rehearse.
    //
    // And when NO group is drawn, the campaign the manager is in the middle of
    // is the next best thing: the sides he still has to play in his qualifying
    // group are who he is warming up for, and they are known long before any
    // finals draw. The tip used to appear only in the narrow stretch between a
    // finals draw and the finals themselves — which is almost never when a
    // friendly window is open — so in practice there was no tip at all.
    var reason = FriendlyReason.finalsGroup;
    var rivals = await _drawnGroupRivals(comp, careerId, career.nationId);
    if (rivals.isEmpty) {
      reason = FriendlyReason.qualifyingGroup;
      rivals = await _campaignRivals(comp, careerId, career.nationId);
    }
    if (rivals.isEmpty) reason = FriendlyReason.ranking;
    final rivalNations = [
      for (final id in rivals)
        if (nations[id] != null) nations[id]!,
    ];
    final opponents = rivalNations.isEmpty
        ? shuffled
        : (shuffled.toList()..sort((a, b) {
            int distance(Nation n) => rivalNations
                .map(
                  (r) =>
                      (n.ranking - r.ranking).abs() +
                      (n.confederation == r.confederation ? 0 : 12),
                )
                .reduce((x, y) => x < y ? x : y);
            return distance(a).compareTo(distance(b));
          }));

    return FriendliesPlan(
      windows: windows,
      // Enough for every window to be dealt a slice off the TOP of the
      // ordering — see [FriendliesScreen._opponentsFor]. Twenty-four was the
      // whole shortlist for one window and the leftovers for the rest, so only
      // the first window was ever offered the sides that resemble the rivals.
      opponents: opponents.take(48).toList(),
      rivals: rivalNations,
      reason: reason,
      nations: nations,
      playerNationId: career.nationId,
      cycle: career.cyclePointer,
    );
  },
);

/// The `(year, month)` windows this cycle's finals tournaments occupy, for a
/// nation that might still be playing in them.
///
/// A tournament whose draw has already been made puts real fixtures on the
/// calendar, so it needs no help here: either the nation is in the field (and
/// the month is occupied) or it isn't (and the month is genuinely free). It is
/// the stretch BEFORE the draw that needs blocking, which is exactly when a
/// host — with no qualifiers to play — has an empty summer that isn't empty at
/// all.
Future<Set<(int, int)>> _finalsWindows(
  CompetitionRepository comp,
  Career career,
  Map<int, Nation> nations,
) async {
  final blocked = <(int, int)>{};
  final wcYear = CareerService.worldCupYear(career.cyclePointer);

  // The World Cup finals open in June of the World Cup year.
  if (!await comp.hasTournament(career.id, CompetitionKind.worldCupFinals)) {
    blocked.add((wcYear, 6));
  }

  // The continental championship: two years before the World Cup, in the
  // confederation's own finals month.
  final conf = nations[career.nationId]?.confederation;
  final cup = conf == null ? null : ContinentalCups.byConfederation[conf];
  if (conf != null &&
      cup != null &&
      !await comp.hasTournament(
        career.id,
        CompetitionKind.continentalFinals,
        confederation: conf,
      )) {
    blocked.add((wcYear - 2, cup.month));
  }
  return blocked;
}

/// Arranges the manager's chosen friendlies and records that every offered
/// window has now been decided (so the hub stops prompting for this gap).
class FriendliesService {
  FriendliesService(this._ref);

  final Ref _ref;

  /// [picks] maps a window date to the chosen opponent id (windows the manager
  /// left empty are simply skipped). [allWindows] is every window that was
  /// shown, so declining one is also remembered.
  Future<void> arrange(
    int careerId, {
    required int nationId,
    required int cycle,
    required Map<DateTime, int> picks,
    required List<DateTime> allWindows,
  }) async {
    final comp = _ref.read(competitionRepositoryProvider);
    final games = [
      for (final e in picks.entries)
        (date: e.key, opponentId: e.value, home: friendlyIsHome(e.key)),
    ]..sort((a, b) => a.date.compareTo(b.date));
    if (games.isNotEmpty) {
      await comp.saveFriendlies(
        careerId: careerId,
        nationId: nationId,
        cycle: cycle,
        friendlies: games,
      );
    }
    for (final d in allWindows) {
      await comp.markDrawWatched(careerId, cycle, friendlyWindowKey(d));
    }
    _ref
      ..invalidate(hubDataProvider(careerId))
      ..invalidate(friendliesPlanProvider(careerId));
  }
}

final Provider<FriendliesService> friendliesServiceProvider = Provider(
  FriendliesService.new,
);

/// The sides the manager has been drawn against in a finals group that has NOT
/// been played yet, or empty when there is no such group.
///
/// Only the group stage: a knockout opponent is not known far enough ahead to
/// prepare for, and by the time he is there are no friendly windows left.
Future<Set<int>> _drawnGroupRivals(
  CompetitionRepository comp,
  int careerId,
  int nationId,
) async {
  const groupRounds = {'GROUP', 'CGROUP', 'NGROUP'};
  final fixtures = await comp.cycleFixturesForNation(careerId, nationId);
  return {
    for (final f in fixtures)
      if (groupRounds.contains(f.round) && !f.hasResult)
        if (f.homeNationId == nationId) f.awayNationId else f.homeNationId,
  };
}

/// The sides left to play in the campaign the manager is in the middle of —
/// continental or World Cup qualifying — or empty when there is no such game
/// left on the calendar.
///
/// World Cup qualifying carries NO round code (see [Rounds]), so this is framed
/// as "every competitive fixture still to come that isn't a finals tie" rather
/// than as a list of round names: naming them is how the World Cup campaign
/// got left out of a rule that was written with the continental one in mind.
Future<Set<int>> _campaignRivals(
  CompetitionRepository comp,
  int careerId,
  int nationId,
) async {
  final fixtures = await comp.cycleFixturesForNation(careerId, nationId);
  return {
    for (final f in fixtures)
      if (!f.hasResult &&
          f.round != Rounds.friendly &&
          !Rounds.isKnockout(f.round))
        if (f.homeNationId == nationId) f.awayNationId else f.homeNationId,
  };
}
