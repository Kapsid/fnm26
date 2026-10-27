import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/util/message_text.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/services/competition/finals_participation.dart';
import 'package:fnm/domain/services/player/player_lifecycle.dart';
import 'package:fnm/domain/services/squad/camp_scandal.dart';
import 'package:fnm/domain/services/squad/nomination.dart';
import 'package:fnm/features/achievements/achievement_providers.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/messages/message_providers.dart';
import 'package:fnm/features/press/press_providers.dart';
import 'package:fnm/features/settings/settings_providers.dart';
import 'package:fnm/features/tactics/condition_providers.dart';
import 'package:fnm/features/tactics/tactics_providers.dart';
import 'package:fnm/features/y/y_providers.dart';

/// A scandal that has broken in the squad that has just gathered, waiting for
/// the manager's answer.
typedef PendingScandal = ({
  int cycle,

  /// The date of the window's first match: the window's key.
  DateTime window,
  int playerId,
  String playerName,
  ScandalKind kind,

  /// Whether the squad is at a finals tournament, where nobody can be called
  /// up in a sent-home man's place.
  bool finals,
});

/// The scandal the manager has to answer now, or null.
///
/// Only in the gap between the call-up and the window's first match: the
/// squad has gathered, nobody has played. Read fresh (a plain function, not a
/// cached provider) for the same reason as `pendingInjuryCover`: the hub asks
/// after every step.
///
/// Never twice in a cycle: once any scandal of this cycle is recorded, the
/// rest of the cycle is quiet whatever the dice say.
Future<PendingScandal?> pendingScandal(Ref ref, int careerId) async {
  final career = await ref.read(careerRepositoryProvider).byId(careerId);
  if (career == null) return null;
  final comp = ref.read(competitionRepositoryProvider);
  final fixtures = await comp.cycleFixturesForNation(careerId, career.nationId);
  // The window has not started: nobody in it has played yet.
  if (!Nomination.windowOpen(fixtures)) return null;
  final period = Nomination.currentPeriod(fixtures);
  if (period.isEmpty) return null;
  final cycle = career.cyclePointer;
  // And the squad has been named, so there is a squad to have gathered.
  if (!await comp.hasWatchedDraw(
    careerId,
    cycle,
    'callup:${period.first.id}',
  )) {
    return null;
  }
  final window = period.first.date;
  final starts = CampScandal.windowStarts(fixtures);
  final span = scandalSpan(cycle);
  // The cheap question first: most windows are quiet, and the pool is only
  // worth loading for the one that is not.
  if (!CampScandal.fires(
    seed: career.rngSeed,
    cycle: cycle,
    window: window,
    starts: starts,
    opens: span.opens,
    closes: span.closes,
  )) {
    return null;
  }
  if (await _hadScandal(ref, careerId, cycle)) return null;
  final callUps = await ref.read(squadRepositoryProvider).callUps(careerId);
  if (callUps.isEmpty) return null;
  final absences = await ref
      .read(absenceRepositoryProvider)
      .forCareer(careerId);
  final pool = await ref
      .read(playerRepositoryProvider)
      .byNation(
        career.nationId,
        agingYears: CareerService.agingYears(career),
        saveSeed: career.rngSeed,
        careerId: career.id,
        minAge: PlayerLifecycle.callUpMinAge,
      );
  final candidates = [
    for (final p in pool)
      if (callUps.contains(p.id) && (absences[p.id]?.injuryMatches ?? 0) <= 0)
        (playerId: p.id, age: p.age),
  ];
  final rolled = CampScandal.roll(
    seed: career.rngSeed,
    cycle: cycle,
    window: window,
    starts: starts,
    opens: span.opens,
    closes: span.closes,
    candidates: candidates,
  );
  if (rolled == null) return null;
  final round = period.first.round;
  return (
    cycle: cycle,
    window: window,
    playerId: rolled.playerId,
    playerName: pool.where((p) => p.id == rolled.playerId).first.name,
    kind: rolled.kind,
    finals:
        FinalsRounds.worldChampionship.contains(round) ||
        FinalsRounds.continental.contains(round),
  );
}

/// The calendar span a cycle's scandal is drawn across: the day the cycle
/// opens to its World Championship final (mid-July of the finals year).
({DateTime opens, DateTime closes}) scandalSpan(int cycle) => (
  opens: CareerService.cycleOpens(cycle),
  closes: DateTime(CareerService.worldCupYear(cycle), 7, 19),
);

Future<bool> _hadScandal(Ref ref, int careerId, int cycle) async {
  final markers = await ref
      .read(competitionRepositoryProvider)
      .watchedKindsWithPrefix(CampScandal.cyclePrefix(cycle));
  return markers.any((m) => m.careerId == careerId);
}

/// [pendingScandal] for the decision screen.
final AutoDisposeFutureProviderFamily<PendingScandal?, int>
pendingScandalProvider = FutureProvider.autoDispose
    .family<PendingScandal?, int>(pendingScandal);

/// Every scandal this career has answered, oldest first.
final AutoDisposeFutureProviderFamily<List<CampScandalRecord>, int>
campScandalsProvider = FutureProvider.autoDispose
    .family<List<CampScandalRecord>, int>((ref, careerId) async {
      final markers = await ref
          .watch(competitionRepositoryProvider)
          .watchedKindsWithPrefix(CampScandal.prefix);
      return [
        for (final m in markers)
          if (m.careerId == careerId)
            if (CampScandal.parse(m.kind) case final r?) r,
      ]..sort((a, b) => a.window.compareTo(b.window));
    });

/// The inbox's dedup key for a scandal: one story per man per cycle.
String scandalMessageKey(int cycle, int playerId) =>
    '${CampScandal.prefix}$cycle:$playerId';

/// The story, as a message part.
MsgText scandalStoryMsg(ScandalKind kind, String playerName) => MsgText(
  switch (kind) {
    ScandalKind.party => MsgKey.scandalStoryParty,
    ScandalKind.curfew => MsgKey.scandalStoryCurfew,
    ScandalKind.nightclub => MsgKey.scandalStoryNightclub,
    ScandalKind.casino => MsgKey.scandalStoryCasino,
  },
  [playerName],
);

/// Answers a scandal: send the man home (with somebody called up in his place,
/// outside a finals) or keep him and pay for it.
class CampScandalService {
  CampScandalService(this._ref);

  final Ref _ref;

  /// Sends [s]'s man home for the rest of the window, calling [replacement]
  /// up in his place when given (never at a finals tournament). No cost to
  /// the dressing room or the board: the decision is the price.
  Future<void> sendHome(
    int careerId,
    PendingScandal s, {
    int? replacement,
  }) async {
    await _ref
        .read(squadServiceProvider)
        .sendHome(
          careerId,
          outId: s.playerId,
          inId: s.finals ? null : replacement,
        );
    await _record(careerId, s, ScandalChoice.sentHome);
  }

  /// Keeps [s]'s man: morale and the board take [CampScandal.keepMorale] and
  /// [CampScandal.keepBoard] for the rest of the cycle, through the press
  /// effect, which both already read and which expires with the cycle.
  Future<void> keep(int careerId, PendingScandal s) async {
    final repo = _ref.read(careerRepositoryProvider);
    final career = await repo.byId(careerId);
    if (career == null) return;
    final key = CampScandal.pressKeyOf(s.cycle, s.playerId);
    final already = (await repo.pressAnswers(
      careerId,
      cycle: s.cycle,
    )).any((a) => a.questionKey == key);
    if (!already) {
      await repo.recordPressAnswer(
        careerId: careerId,
        cycle: s.cycle,
        questionKey: key,
        tone: CampScandal.keepTone,
        moraleDelta: CampScandal.keepMorale,
        boardDelta: CampScandal.keepBoard,
        answeredAt: career.inGameDate,
      );
    }
    await _record(careerId, s, ScandalChoice.kept);
  }

  /// A scandal nobody answered, because the manager played or simulated the
  /// window's first match without going through the hub: it counts as KEPT.
  /// Doing nothing about a story is keeping the man.
  ///
  /// Returns whether one was settled.
  Future<bool> settleUnanswered(int careerId) async {
    final s = await pendingScandal(_ref, careerId);
    if (s == null) return false;
    await keep(careerId, s);
    return true;
  }

  /// A man sent home is out for the rest of THAT window, not the next one.
  ///
  /// The call-ups are one stored set, so a manager who plays on into the
  /// next window without naming a new squad would field the old set again,
  /// still without him. Before the manager's own match is played, a man sent
  /// home in the window just gone is put back, but only when the window now
  /// starting is the very next one and no squad has been named for it (a
  /// squad named without him is the manager's own choice), and only into a
  /// free place: the squad never goes over [kMaxSquadSize].
  Future<void> restoreSentHome(int careerId) async {
    final career = await _ref.read(careerRepositoryProvider).byId(careerId);
    if (career == null) return;
    final comp = _ref.read(competitionRepositoryProvider);
    final fixtures = await comp.cycleFixturesForNation(
      careerId,
      career.nationId,
    );
    final period = Nomination.currentPeriod(fixtures);
    if (period.isEmpty) return;
    final cycle = career.cyclePointer;
    if (await comp.hasWatchedDraw(
      careerId,
      cycle,
      'callup:${period.first.id}',
    )) {
      return;
    }
    final starts = CampScandal.windowStarts(fixtures);
    final now = period.first.date;
    final markers = await comp.watchedKindsWithPrefix(
      CampScandal.cyclePrefix(cycle),
    );
    for (final m in markers) {
      if (m.careerId != careerId) continue;
      final r = CampScandal.parse(m.kind);
      if (r == null || r.choice != ScandalChoice.sentHome) continue;
      final next = starts.where((d) => d.isAfter(r.window)).firstOrNull;
      if (next == null || !_sameDay(next, now)) continue;
      final squads = _ref.read(squadRepositoryProvider);
      final callUps = await squads.callUps(careerId);
      if (callUps.isEmpty || callUps.contains(r.playerId)) continue;
      // Only into a free place: a man called up in his place keeps it, and
      // the squad never goes over its limit.
      if (callUps.length >= kMaxSquadSize) continue;
      await squads.setCallUps(careerId, {...callUps, r.playerId});
    }
  }

  static bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  Future<void> _record(
    int careerId,
    PendingScandal s,
    ScandalChoice choice,
  ) async {
    final comp = _ref.read(competitionRepositoryProvider);
    await comp.markDrawWatched(
      careerId,
      s.cycle,
      CampScandal.markerOf((
        cycle: s.cycle,
        window: s.window,
        playerId: s.playerId,
        kind: s.kind,
        choice: choice,
      )),
    );
    await fileScandalMessage(
      _ref,
      careerId,
      cycle: s.cycle,
      window: s.window,
      playerId: s.playerId,
      playerName: s.playerName,
      kind: s.kind,
    );
    _ref
      ..invalidate(pendingScandalProvider(careerId))
      ..invalidate(campScandalsProvider(careerId))
      ..invalidate(pressEffectProvider)
      ..invalidate(moraleProvider)
      ..invalidate(satisfactionProvider)
      ..invalidate(squadConditionProvider)
      ..invalidate(yFeedProvider)
      ..invalidate(messageInboxProvider(careerId))
      ..invalidate(unreadMessagesProvider(careerId))
      ..invalidate(nextEventProvider(careerId))
      ..invalidate(hubDataProvider(careerId));
  }
}

/// Files the inbox story of a scandal, once (keyed by cycle and man).
Future<void> fileScandalMessage(
  Ref ref,
  int careerId, {
  required int cycle,
  required DateTime window,
  required int playerId,
  required String playerName,
  required ScandalKind kind,
}) async {
  final comp = ref.read(competitionRepositoryProvider);
  final key = scandalMessageKey(cycle, playerId);
  if ((await comp.messageKeys(careerId)).contains(key)) return;
  await comp.addTextMessage(
    l: ref.read(appLocalizationsProvider),
    careerId: careerId,
    dedupKey: key,
    category: 'discipline',
    title: MsgText(MsgKey.newsScandalTitle, [playerName]),
    body: scandalStoryMsg(kind, playerName),
    year: window.year,
  );
}

final Provider<CampScandalService> campScandalServiceProvider = Provider(
  CampScandalService.new,
);
