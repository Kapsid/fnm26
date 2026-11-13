import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/group_standing.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/press/conference.dart';
import 'package:fnm/domain/services/press/press.dart';
import 'package:fnm/features/press/press_providers.dart';

/// A finals group C for the press-room tests: England (1) lost 0-3 to the
/// Netherlands (2), drew 1-1 in Senegal (3) and plays Japan (4) next.
abstract final class PressRoom {
  static const int england = 1;

  static Nation _nation(int id, String name, String code) => Nation(
    id: id,
    name: name,
    code: code,
    confederation: Confederation.europe,
    ranking: id * 5,
  );

  static final Map<int, Nation> nations = {
    1: _nation(1, 'England', 'ENG'),
    2: _nation(2, 'Netherlands', 'NED'),
    3: _nation(3, 'Senegal', 'SEN'),
    4: _nation(4, 'Japan', 'JPN'),
  };

  static Fixture _f(
    int id,
    DateTime date,
    int home,
    int away, {
    int? hs,
    int? as,
    int matchday = 1,
  }) => Fixture(
    id: id,
    careerId: 1,
    competitionId: 9,
    matchday: matchday,
    date: date,
    homeNationId: home,
    awayNationId: away,
    groupId: 7,
    round: 'GROUP',
    homeScore: hs,
    awayScore: as,
    played: hs != null,
  );

  /// After the second match: two results, Japan still to come.
  static final List<Fixture> afterTwo = [
    _f(11, DateTime(2034, 6, 10), 1, 2, hs: 0, as: 3),
    _f(12, DateTime(2034, 6, 14), 3, 1, hs: 1, as: 1, matchday: 2),
    _f(13, DateTime(2034, 6, 17), 1, 4, matchday: 3),
  ];

  /// Before the finals: nothing played yet.
  static final List<Fixture> beforeAny = [
    _f(11, DateTime(2034, 6, 10), 1, 2),
    _f(12, DateTime(2034, 6, 14), 3, 1, matchday: 2),
    _f(13, DateTime(2034, 6, 17), 1, 4, matchday: 3),
  ];

  static GroupTable get group {
    GroupStanding row(int id, {int w = 0, int d = 0, int l = 0}) =>
        GroupStanding(id)
          ..played = w + d + l
          ..won = w
          ..drawn = d
          ..lost = l;
    return (
      groupId: 7,
      name: 'C',
      competition: 'World Championship',
      kind: CompetitionKind.worldCupFinals,
      groupCount: 8,
      standings: [
        row(2, w: 2),
        row(3, d: 1, w: 1),
        row(1, d: 1, l: 1),
        row(4, l: 2),
      ],
    );
  }

  static const Map<int, String> groupNames = {7: 'C'};

  static String dateLabel(DateTime d) => 'WED ${d.day}/${d.month}';

  /// The post-match conference after the Senegal draw.
  static final PendingConference postMatch = (
    row: (
      id: 50,
      cycle: 0,
      reason: ConferenceReason.bigLoss,
      fixtureId: 12,
      triggeredOn: DateTime(2034, 6, 14),
      status: ConferenceStatus.pending,
    ),
    facts: (
      reason: ConferenceReason.bigLoss,
      bestPlayerId: null,
      worstPlayerId: null,
      hasOpenWinNext: false,
      hasOpenJob: false,
      playersWithOpenStatement: <int>{},
      throwback: null,
      preview: null,
      opposingManager: null,
    ),
    credibility: 50,
    opponentNationId: 3,
  );

  /// The preview before the opener against the Netherlands.
  static final PendingConference preview = (
    row: (
      id: 51,
      cycle: 0,
      reason: ConferenceReason.preview,
      fixtureId: 11,
      triggeredOn: DateTime(2034, 6, 1),
      status: ConferenceStatus.pending,
    ),
    facts: (
      reason: ConferenceReason.preview,
      bestPlayerId: null,
      worstPlayerId: null,
      hasOpenWinNext: false,
      hasOpenJob: false,
      playersWithOpenStatement: <int>{},
      throwback: null,
      preview: (
        campaign: PreviewCampaign.worldFinals,
        brief: 4,
        rivalNationId: 2,
        keyPlayerId: 9,
      ),
      opposingManager: null,
    ),
    credibility: 50,
    opponentNationId: 2,
  );
}

/// A conference service that records the answers and writes nothing.
class FakePressService implements ConferenceService {
  final answers = <(int, AnswerKind)>[];
  final finished = <int>[];

  @override
  Future<PressEffect> answer(
    int careerId,
    PendingConference c,
    int beatIndex,
    Beat beat,
    AnswerKind a,
  ) async {
    answers.add((beatIndex, a));
    return ConferenceBuilder.effectOf(a, c.credibility);
  }

  @override
  Future<int> openPreview(int careerId, PreviewDue due) async => 0;

  @override
  Future<Map<int, String>> playerNames(
    Career career,
    PendingConference c,
  ) async => const {};

  @override
  Future<Map<int, String>> namesFor(Career career, Set<int> ids) async =>
      const {};

  @override
  Future<void> finish(int careerId, int conferenceId) async {
    finished.add(conferenceId);
  }
}
