import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/util/text_variety.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/services/competition/kickoff_keys.dart';
import 'package:fnm/domain/services/competition/rounds.dart';
import 'package:fnm/domain/services/press/press.dart';
import 'package:fnm/features/ranking/world_ranking_providers.dart';

/// The press question waiting right now, or null when they have nothing to ask
/// — which is most of the time, and deliberately so.
///
/// The rules that keep it from being a chore:
///  * one question at a time, and each key is asked ONCE ever;
///  * only after something actually happened (a hammering, a trophy, a
///    tournament exit, a run of results with the board watching, the eve of a
///    finals) — never after an ordinary win;
///  * it goes stale after [Press.askWindowDays], so an unanswered question is
///    dropped rather than queued up behind the next one;
///  * nothing at all for [Press.quietDays] after the last answer.
final AutoDisposeFutureProviderFamily<PressQuestion?, int>
pressQuestionProvider = FutureProvider.autoDispose.family<PressQuestion?, int>((
  ref,
  careerId,
) async {
  final careerRepo = ref.watch(careerRepositoryProvider);
  final career = await careerRepo.byId(careerId);
  if (career == null) return null;
  final answers = await careerRepo.pressAnswers(careerId);
  final asked = {for (final a in answers) a.questionKey};
  final now = career.inGameDate;

  final comp = ref.watch(competitionRepositoryProvider);
  final fixtures = await comp.fixturesForNation(careerId, career.nationId);

  // 0. The opening press conference, held the moment a tournament the nation is
  //    contesting has been opened and before a ball is kicked. It jumps the
  //    quiet period on purpose: the press used to be heard from only in the
  //    wreckage AFTER a tournament (an exit, a hammering), so a manager never
  //    got to set the tone going into one.
  //
  //    Read from THIS cycle's fixtures: round codes repeat every four years,
  //    so an all-time list would show the last World Cup's group games as
  //    played and the conference would never be held again.
  final opening = _openingQuestion(
    career.nationId,
    await comp.cycleFixturesForNation(careerId, career.nationId),
    asked,
  );
  if (opening != null &&
      await comp.hasWatchedDraw(
        careerId,
        career.cyclePointer,
        _kickoffKindFor(opening.round),
      )) {
    return opening.question;
  }

  // The press let a manager breathe after they have just spoken.
  for (final a in answers) {
    if (now.difference(a.answeredAt).inDays < Press.quietDays) return null;
  }

  final played = [
    for (final f in fixtures)
      if (f.hasResult) f,
  ]..sort((a, b) => b.date.compareTo(a.date)); // newest first

  PressQuestion? q(
    String key,
    PressTopic topic, {
    int? subjectNationId,
  }) => asked.contains(key)
      ? null
      : (
          key: key,
          topic: topic,
          subjectNationId: subjectNationId,
          options: Press.optionsFor(topic),
        );

  // Only the recent past is news.
  final recent = [
    for (final f in played)
      if (now.difference(f.date).inDays <= Press.askWindowDays) f,
  ];
  final competitive = [
    for (final f in recent)
      if (f.round != Rounds.friendly) f,
  ];

  // Every story the press could lead with right now, biggest first. One of the
  // top few is then drawn (see [Press.storyPool]) — asking strictly in order
  // meant a manager always got the same question for the same situation.
  final candidates = <PressQuestion>[];
  void add(PressQuestion? question) {
    if (question != null) candidates.add(question);
  }

  // A hammering — the biggest story there is.
  for (final f in recent) {
    final mine = _mine(f, career.nationId);
    if (mine.against - mine.forGoals >= 3) {
      add(
        q(
          'defeat:${f.id}',
          PressTopic.heavyDefeat,
          subjectNationId: _opponent(f, career.nationId),
        ),
      );
      break;
    }
  }

  // Out of a tournament: a knockout defeat ends the run there and then.
  for (final f in recent) {
    if (!Rounds.isKnockout(f.round)) continue;
    final mine = _mine(f, career.nationId);
    if (mine.forGoals < mine.against) {
      add(
        q(
          'exit:${f.id}',
          PressTopic.elimination,
          subjectNationId: _opponent(f, career.nationId),
        ),
      );
      break;
    }
  }

  // A trophy — the one question a manager enjoys.
  for (final h in await comp.honours(careerId)) {
    if (h.championId != career.nationId) continue;
    if (h.year < now.year - 1) continue;
    add(q('triumph:${h.competition}:${h.year}', PressTopic.triumph));
    break;
  }

  // The other side of a hammering: a night when everything came off.
  for (final f in recent) {
    final mine = _mine(f, career.nationId);
    if (mine.forGoals - mine.against >= 3) {
      add(
        q(
          'rout:${f.id}',
          PressTopic.bigWin,
          subjectNationId: _opponent(f, career.nationId),
        ),
      );
      break;
    }
  }

  // A bad run with the board watching: three straight competitive games
  // without a win.
  if (competitive.length >= 3) {
    final winless = competitive.take(3).every((f) {
      final mine = _mine(f, career.nationId);
      return mine.forGoals <= mine.against;
    });
    if (winless) {
      add(q('pressure:${competitive.first.id}', PressTopic.underPressure));
    }
  }

  // …and its opposite: a long run nobody has ended yet.
  if (competitive.length >= _unbeatenRunLength) {
    final unbeaten = competitive.take(_unbeatenRunLength).every((f) {
      final mine = _mine(f, career.nationId);
      return mine.forGoals >= mine.against;
    });
    if (unbeaten) {
      add(q('unbeaten:${competitive.first.id}', PressTopic.unbeatenRun));
    }
  }

  // The first days in a job, before a ball has been kicked for this nation.
  if (played.isEmpty) {
    add(
      q(
        'newjob:${career.nationId}:${career.cyclePointer}',
        PressTopic.newJob,
      ),
    );
  }

  // A place booked, or a campaign that came up short. Both are read off THIS
  // cycle's finals fixtures: the nation's own, and the tournament's.
  final cycleFixtures = await comp.cycleFixturesForNation(
    careerId,
    career.nationId,
  );
  // The continental entry names the manager's confederation: every continent's
  // cup is a competition of the same kind, and reading them all would let
  // another continent's group stage kicking off decide that this nation had
  // missed out on its own.
  final myConf = (await ref.watch(nationRepositoryProvider).all())
      .where((n) => n.id == career.nationId)
      .firstOrNull
      ?.confederation;
  for (final (round, kind, conf) in [
    ('GROUP', CompetitionKind.worldCupFinals, null),
    ('CGROUP', CompetitionKind.continentalFinals, myConf),
  ]) {
    final field = await comp.fixturesByRound(
      careerId,
      round,
      kind: kind,
      confederation: conf,
    );
    if (field.isEmpty) continue;
    final year = field.first.date.year;
    final mine = [
      for (final f in cycleFixtures)
        if (f.round == round) f,
    ];
    if (mine.isEmpty) {
      // Not in the draw — the campaign fell short, and there is no hiding it
      // once the tournament is under way.
      if (field.any((f) => f.hasResult)) {
        add(q('missed:$round:$year', PressTopic.missedOut));
      }
      continue;
    }
    // In the draw and not yet under way: the place is the story until the
    // build-up proper takes over (see the eve-of-finals question below).
    if (!mine.any((f) => f.hasResult) &&
        mine.first.date.difference(now).inDays > 21) {
      add(q('qualified:$round:$year', PressTopic.qualified));
    }
  }

  // A world ranking the nation has never held before.
  final extremes = await ref.watch(rankExtremesProvider(careerId).future);
  final live = await ref.watch(worldRankingProvider(careerId).future);
  final rank = live?.position[career.nationId];
  if (rank != null &&
      rank <= _peakRankCeiling &&
      extremes != null &&
      rank <= extremes.best) {
    add(q('peak:$rank', PressTopic.rankingPeak));
  }

  // The eve of a finals: asked once per tournament, before a ball is kicked,
  // so the manager sets the expectation themselves.
  final next = [
    for (final f in fixtures)
      if (!f.hasResult) f,
  ]..sort((a, b) => a.date.compareTo(b.date));
  final opener = next.firstOrNull;
  if (opener != null &&
      (opener.round == 'GROUP' || opener.round == 'CGROUP') &&
      opener.matchday == 1 &&
      opener.date.difference(now).inDays <= 21) {
    add(
      q(
        'preview:${opener.round}:${opener.date.year}',
        PressTopic.tournamentPreview,
        subjectNationId: _opponent(opener, career.nationId),
      ),
    );
  }

  if (candidates.isEmpty) return null;
  final pool = candidates.take(Press.storyPool).toList();
  final seed = varietySeed(
    'press:${career.rngSeed}:${now.year}:${now.month}:${now.day}',
  );
  return pool[seed % pool.length];
});

/// How many competitive games without defeat make a run worth asking about.
const int _unbeatenRunLength = 6;

/// A new world-ranking high is only news near the top of the table.
const int _peakRankCeiling = 20;

/// Everything the manager has said THIS cycle, as a single nudge to the
/// dressing room and to the board. Older cycles are forgotten.
final AutoDisposeFutureProviderFamily<PressEffect, int> pressEffectProvider =
    FutureProvider.autoDispose.family<PressEffect, int>((ref, careerId) async {
      final careerRepo = ref.watch(careerRepositoryProvider);
      final career = await careerRepo.byId(careerId);
      if (career == null) return (morale: 0, board: 0);
      final answers = await careerRepo.pressAnswers(
        careerId,
        cycle: career.cyclePointer,
      );
      return Press.totalOf([
        for (final a in answers) (morale: a.moraleDelta, board: a.boardDelta),
      ]);
    });

/// Records an answer and refreshes everything it touches.
class PressService {
  PressService(this._ref);

  final Ref _ref;

  Future<void> answer(
    int careerId,
    PressQuestion question,
    PressTone tone,
  ) async {
    final repo = _ref.read(careerRepositoryProvider);
    final career = await repo.byId(careerId);
    if (career == null) return;
    final effect = Press.effectOf(tone);
    await repo.recordPressAnswer(
      careerId: careerId,
      cycle: career.cyclePointer,
      questionKey: question.key,
      tone: tone.name,
      moraleDelta: effect.morale,
      boardDelta: effect.board,
      answeredAt: career.inGameDate,
    );
    _ref
      ..invalidate(pressQuestionProvider)
      ..invalidate(pressEffectProvider);
  }
}

final Provider<PressService> pressServiceProvider = Provider(PressService.new);

/// The World Cup finals rounds and the continental finals rounds, so the
/// nation's own tournament can be spotted from its fixture list.
const _wcFinalsRounds = {'GROUP', 'R32', 'R16', 'QF', 'SF', '3RD', 'FINAL'};
const _contFinalsRounds = {'CGROUP', 'CR16', 'CQF', 'CSF', 'C3RD', 'CFINAL'};

/// Which opening-ceremony key gates the conference for a tournament whose group
/// round is [round].
String _kickoffKindFor(String round) =>
    round == 'GROUP' ? worldCupKickoffKind : continentalKickoffKind;

/// The opening press conference the nation is due, or null.
///
/// Due when the side is contesting a finals tournament that has not started —
/// it has finals fixtures and none of them has been played — and the question
/// has not already been answered. The [round] it comes back with says which
/// tournament, so the caller can check that its ceremony has been held.
({PressQuestion question, String round})? _openingQuestion(
  int nationId,
  List<Fixture> fixtures,
  Set<String> asked,
) {
  for (final rounds in [_wcFinalsRounds, _contFinalsRounds]) {
    final mine = [
      for (final f in fixtures)
        if (f.round != null && rounds.contains(f.round)) f,
    ]..sort((a, b) => a.date.compareTo(b.date));
    if (mine.isEmpty) continue;
    if (mine.any((f) => f.hasResult)) continue; // already under way
    final group = rounds == _wcFinalsRounds ? 'GROUP' : 'CGROUP';
    final opener = mine.first;
    final key = 'opening:$group:${opener.date.year}';
    if (asked.contains(key)) continue;
    return (
      question: (
        key: key,
        topic: PressTopic.tournamentOpening,
        subjectNationId: opener.homeNationId == nationId
            ? opener.awayNationId
            : opener.homeNationId,
        options: Press.optionsFor(PressTopic.tournamentOpening),
      ),
      round: group,
    );
  }
  return null;
}

/// This nation's goals for and against in [f].
({int forGoals, int against}) _mine(Fixture f, int nationId) {
  final isHome = f.homeNationId == nationId;
  return (
    forGoals: (isHome ? f.homeScore : f.awayScore) ?? 0,
    against: (isHome ? f.awayScore : f.homeScore) ?? 0,
  );
}

int _opponent(Fixture f, int nationId) =>
    f.homeNationId == nationId ? f.awayNationId : f.homeNationId;
