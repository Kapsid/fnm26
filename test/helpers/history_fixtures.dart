import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/squad/legends.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/career/career_transfer_providers.dart';
import 'package:fnm/features/career/play_time.dart';
import 'package:fnm/features/messages/message_providers.dart';
import 'package:fnm/features/records/all_time_records_providers.dart';
import 'package:fnm/features/records/head_to_head_providers.dart';
import 'package:fnm/features/records/legends_providers.dart';
import 'package:fnm/features/records/record_book_providers.dart';
import 'package:fnm/features/records/rivalry_providers.dart';

import 'competition_fixtures.dart';
import 'seeded_save.dart';

// Fakes for the history and career screens: the states a fresh save does
// not reach on its own (records, legends, a rivalry, meetings), drawn with
// the REAL players and nations, so a player opened in a pane exists.

/// [nationId]'s players in the real data, best first.
List<Player> squadOf(int nationId) => [
  for (final p in realPlayers)
    if (p.nationId == nationId) p,
]..sort((a, b) => b.overall.compareTo(a.overall));

/// The manager's opponent in every fake pairing: the best-ranked nation
/// after his.
Nation get rivalNation => fieldOf(seededNationId, 2)[1];

List<RecordLeader> _leaders(Iterable<Player> players, List<int> values) {
  final list = players.toList();
  return [
    for (var i = 0; i < values.length; i++)
      (
        playerId: list[i].id,
        name: list[i].name,
        value: values[i],
        active: i.isEven,
      ),
  ];
}

/// The manager's record book after a few cycles: three boards of five, each
/// drawn from a different slice of his squad. The team records are the ones
/// [fakeMeetingsByOpponent] add up to: the 2-0 over the rival is the biggest
/// win, and the last four results (W W D D) the longest unbeaten run.
RecordBook fakeRecordBook() {
  final squad = squadOf(seededNationId);
  return (
    nationName: realNationsById[seededNationId]!.name,
    mostCaps: _leaders(squad, const [61, 54, 48, 40, 33]),
    topScorers: _leaders(squad.skip(5), const [22, 17, 12, 9, 6]),
    topAssists: _leaders(squad.skip(10), const [14, 11, 8, 5, 3]),
    biggestWin: (oppId: rivalNation.id, gf: 2, ga: 0),
    longestUnbeaten: 4,
    bestFinish: 'Quarter-finals',
    nations: realNationsById,
  );
}

/// The fiercest rival: the opponent met most often, with the same record as
/// the ledger's first line and the rival's three meetings ([fakeMeetings]).
Rivalry fakeRivalry() => (
  rival: rivalNation,
  played: 3,
  wins: 1,
  draws: 1,
  losses: 1,
  goalsFor: 3,
  goalsAgainst: 2,
);

List<Override> fakeRecordsOverrides() => [
  recordBookProvider(
    kSeededCareerId,
  ).overrideWith((ref) async => fakeRecordBook()),
  rivalryProvider(kSeededCareerId).overrideWith((ref) async => fakeRivalry()),
];

/// Sixteen of the manager's players ranked into a hall of fame, and the
/// all-time XI the ranking picks from them.
LegendsView fakeLegends() {
  final squad = squadOf(seededNationId);
  final ranked = Legends.rank([
    for (var i = 0; i < 16; i++)
      (
        playerId: squad[i].id,
        name: squad[i].name,
        position: squad[i].position,
        caps: 60 - 3 * i,
        goals: squad[i].category == PositionCategory.forward ? 20 - i : i % 3,
        assists: 10 - i ~/ 2,
        motm: 5 - i ~/ 4,
        avgRating: 7.4 - i * 0.05,
      ),
  ]);
  return (
    nationName: realNationsById[seededNationId]!.name,
    allTimeXi: Legends.allTimeXi(ranked),
    hallOfFame: ranked.take(20).toList(),
  );
}

Override fakeLegendsOverride() => legendsProvider(
  kSeededCareerId,
).overrideWith((ref) async => fakeLegends());

AllTimeLeader _allTimeLeader(
  Nation nation,
  int depth,
  int value,
  bool active,
) {
  final p = squadOf(nation.id)[depth];
  return (
    playerId: p.id,
    nationId: nation.id,
    name: p.name,
    nationCode: nation.code,
    nationName: nation.name,
    value: value,
    active: active,
  );
}

/// The world's boards: players of the manager's nation and the three best
/// after it, in turn, so a board holds two of each nation's first four.
AllTimeRecords fakeAllTimeRecords() {
  final field = fieldOf(seededNationId, 4);
  List<AllTimeLeader> board(List<int> values) => [
    for (var i = 0; i < values.length; i++)
      _allTimeLeader(
        field[i % field.length],
        i ~/ field.length,
        values[i],
        i.isOdd,
      ),
  ];
  return (
    topScorers: board(const [71, 64, 58, 50, 44, 39]),
    mostCaps: board(const [180, 171, 166, 150, 142, 133]),
    mostWcStarts: board(const [26, 24, 21, 19]),
    mostCupsAttended: board(const [6, 5, 5, 4]),
    myNationIds: {seededNationId},
  );
}

Override fakeAllTimeOverride() => allTimeRecordsProvider(
  kSeededCareerId,
).overrideWith((ref) async => fakeAllTimeRecords());

/// The manager's ledger: the rival (met three times) first, then two more.
/// Each line is what that opponent's meetings in [fakeMeetingsByOpponent] add
/// up to.
List<MyH2HLine> fakeLedger() {
  final field = fieldOf(seededNationId, 4);
  MyH2HLine line(Nation n, int won, int drawn, int lost, int gf, int ga) => (
    opponentId: n.id,
    opponentName: n.name,
    opponentCode: n.code,
    played: won + drawn + lost,
    wins: won,
    draws: drawn,
    losses: lost,
    goalsFor: gf,
    goalsAgainst: ga,
  );
  return [
    line(field[1], 1, 1, 1, 3, 2),
    line(field[2], 1, 0, 1, 2, 2),
    line(field[3], 0, 1, 0, 1, 1),
  ];
}

/// The manager's record against [rivalNation], from his side (A): what
/// [fakeMeetings] add up to.
HeadToHead fakeHeadToHead() => (
  played: 3,
  winsA: 1,
  draws: 1,
  winsB: 1,
  goalsA: 3,
  goalsB: 2,
  biggestWinMarginA: 2,
  biggestWinMarginB: 1,
);

/// The manager's three meetings with [rivalNation], from his side (A), newest
/// first: a World Championship draw settled on penalties, a continental win,
/// a friendly defeat.
List<H2HMeeting> fakeMeetings() => [
  (
    date: DateTime(2029, 6, 21),
    competition: 'World Championship',
    forA: 1,
    forB: 1,
    afterExtraTime: true,
    penA: 4,
    penB: 3,
  ),
  (
    date: DateTime(2028, 6, 14),
    competition: 'European Championship',
    forA: 2,
    forB: 0,
    afterExtraTime: false,
    penA: null,
    penB: null,
  ),
  (
    date: DateTime(2027, 3, 26),
    competition: 'Friendly',
    forA: 0,
    forB: 1,
    afterExtraTime: false,
    penA: null,
    penB: null,
  ),
];

H2HMeeting _friendly(int year, int month, int day, int forA, int forB) => (
  date: DateTime(year, month, day),
  competition: 'Friendly',
  forA: forA,
  forB: forB,
  afterExtraTime: false,
  penA: null,
  penB: null,
);

/// Every meeting the manager's nation has played, by opponent, from his side
/// (A), newest first: the one source the ledger, the rivalry, the record
/// book's team records and the keyed head-to-head fakes all agree with.
Map<int, List<H2HMeeting>> fakeMeetingsByOpponent() {
  final field = fieldOf(seededNationId, 4);
  return {
    field[1].id: fakeMeetings(),
    field[2].id: [_friendly(2028, 10, 10, 1, 0), _friendly(2026, 11, 15, 1, 2)],
    field[3].id: [_friendly(2029, 3, 25, 1, 1)],
  };
}

/// [m] seen from side B.
H2HMeeting _flip(H2HMeeting m) => (
  date: m.date,
  competition: m.competition,
  forA: m.forB,
  forB: m.forA,
  afterExtraTime: m.afterExtraTime,
  penA: m.penB,
  penB: m.penA,
);

/// The meetings between [key]'s two nations, from side A, newest first. A
/// pairing that never met (any not involving the manager's nation) has none.
List<H2HMeeting> fakeMeetingsFor(H2HKey key) {
  final byOpponent = fakeMeetingsByOpponent();
  if (key.nationA == seededNationId) {
    return byOpponent[key.nationB] ?? const [];
  }
  if (key.nationB == seededNationId) {
    return [
      for (final m in byOpponent[key.nationA] ?? const <H2HMeeting>[]) _flip(m),
    ];
  }
  return const [];
}

/// The record [meetings] add up to, from side A, as the repository counts
/// it: a shootout is a draw, and a side's biggest win margin is 0 without a
/// win.
HeadToHead headToHeadOf(List<H2HMeeting> meetings) {
  var winsA = 0;
  var draws = 0;
  var winsB = 0;
  var goalsA = 0;
  var goalsB = 0;
  var marginA = 0;
  var marginB = 0;
  for (final m in meetings) {
    goalsA += m.forA;
    goalsB += m.forB;
    final margin = m.forA - m.forB;
    if (margin > 0) {
      winsA++;
      if (margin > marginA) marginA = margin;
    } else if (margin < 0) {
      winsB++;
      if (-margin > marginB) marginB = -margin;
    } else {
      draws++;
    }
  }
  return (
    played: meetings.length,
    winsA: winsA,
    draws: draws,
    winsB: winsB,
    goalsA: goalsA,
    goalsB: goalsB,
    biggestWinMarginA: marginA,
    biggestWinMarginB: marginB,
  );
}

/// The ledger, and any pairing's record and meetings, keyed as the real
/// providers are: the manager against the rival is [fakeHeadToHead] and
/// [fakeMeetings]; opened from the other side the wins and goals swap; a
/// pairing that never met has played 0 and no meetings.
List<Override> fakeH2hOverrides() => [
  myHeadToHeadsProvider(
    kSeededCareerId,
  ).overrideWith((ref) async => fakeLedger()),
  headToHeadProvider.overrideWith(
    (ref, key) async => headToHeadOf(fakeMeetingsFor(key)),
  ),
  h2hMeetingsProvider.overrideWith(
    (ref, key) async => fakeMeetingsFor(key),
  ),
];

/// A second career, on [rivalNation], beside [save]'s. Returns its id.
///
/// Its welcome news is read, as [seedSave] does for the first, so opening it
/// does not pop news over the hub.
///
/// The ORDER of the two in `savesProvider` is not defined: neither has been
/// played (`lastPlayedAt` null) and `createdAt` is the game's start date, the
/// same for both, so they tie on every key the list sorts by. Find the
/// second save by its nation ([rivalNation]) or its id, never by position.
Future<int> addSecondSave(WidgetTester tester, SeededSave save) async {
  late int id;
  await tester.runAsync(() async {
    final created = await save.container
        .read(careerServiceProvider)
        .create(nationId: rivalNation.id, managerName: 'N', rngSeed: 20261010);
    final career = created.valueOrNull;
    if (career == null) {
      throw StateError(
        'addSecondSave: creating the second career failed: '
        '$created',
      );
    }
    id = career.id;
    await save.container.read(messageInboxProvider(id).future);
    await save.container
        .read(competitionRepositoryProvider)
        .markMessagesRead(id);
  });
  save.container
    ..invalidate(messageInboxProvider(id))
    ..invalidate(unreadMessagesProvider(id));
  return id;
}

/// The career transfer service without the file system: an export is a file
/// that is never written (the share sheet only takes its path), and the
/// app-folder copy a delete removes is only noted.
class FakeCareerTransfer extends CareerTransferService {
  // A positional forward, not `super.ref`: the real constructor's parameter
  // is the private `this._ref`, and a super parameter named otherwise trips
  // `matching_super_parameters`.
  // ignore: use_super_parameters
  FakeCareerTransfer(Ref ref) : super(ref);

  final List<int> exported = [];
  final List<int> removed = [];

  @override
  Future<File> export(int careerId, {DateTime? at}) async {
    exported.add(careerId);
    return File('fnm-test-career-$careerId.fnmcareer');
  }

  @override
  Future<void> removeAppFolderBackup(int careerId) async =>
      removed.add(careerId);
}

Override fakeTransferOverride() =>
    careerTransferServiceProvider.overrideWith(FakeCareerTransfer.new);

/// Ends a test that tapped a Continue. The Continue started the play-time
/// clock, a periodic timer that would still be pending; stopping it credits
/// the time and invalidates `savesProvider`, which the screen that watched it
/// has left. Re-reading it rebuilds it, so riverpod 2.6.1 does not complete
/// its future a second time at teardown (Stage 4 adjustments).
Future<void> stopPlayClock(WidgetTester tester, SeededSave save) async {
  await tester.runAsync(() async {
    await save.container.read(playTimeTrackerProvider).stop();
    await save.container.read(savesProvider.future);
  });
}
