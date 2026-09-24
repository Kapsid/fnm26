import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/services/competition/finals_participation.dart';
import 'package:fnm/domain/services/competition/rounds.dart';
import 'package:fnm/domain/services/press/squad_stories.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/records/rivalry_providers.dart';
import 'package:fnm/features/squad/captain_providers.dart';
import 'package:fnm/features/tactics/tactics_providers.dart';

/// What the SQUAD is asking of the manager right now, and what the NEXT match
/// is.
///
/// Two providers, one job: the press room and the feed are two readings of the
/// same week and must not be able to disagree about it. Batch 1's incidents
/// were read twice — once by the conference, once by the feed — because the
/// rule was "was anybody sent off", which is too small to go wrong. A drought,
/// a dropped star and a head-to-head run are not, so the reading happens once
/// and both callers watch it.
///
/// The rules themselves are pure and live in [SquadStories] / [OpponentStories];
/// everything here is the gathering.
final AutoDisposeFutureProviderFamily<List<SquadStory>, int>
squadStoriesProvider = FutureProvider.autoDispose.family<List<SquadStory>, int>(
  (ref, careerId) async {
    final career = await ref.watch(careerRepositoryProvider).byId(careerId);
    if (career == null) return const [];
    final squad = await ref.watch(squadDataProvider(careerId).future);
    if (squad == null) return const [];
    final comp = ref.watch(competitionRepositoryProvider);

    // The XI the manager has actually saved. A side with no stored tactic has
    // no selection to be asked about, which is the honest answer on day one.
    final tactic = await ref
        .watch(tacticsRepositoryProvider)
        .tacticForCareer(careerId);
    final xi = {...?tactic?.lineup.whereType<int>()};

    final caps = {
      for (final a in await comp.nationTopAppearances(
        careerId,
        career.nationId,
        limit: _capsRead,
      ))
        a.playerId: a.games,
    };

    // The match the country is still talking about, and who played in it.
    // Friendlies count here: a first cap is a first cap whoever it came
    // against, and the man who won it is news that week.
    final fixtures = await comp.fixturesForNation(careerId, career.nationId);
    final played = [
      for (final f in fixtures)
        if (f.hasResult) f,
    ]..sort((a, b) => b.date.compareTo(a.date));
    final lastMatch = played.firstOrNull;
    final lastRatings = <int, double>{};
    if (lastMatch != null) {
      for (final line in await comp.ratingsForFixture(careerId, lastMatch.id)) {
        if (line.nationId != career.nationId) continue;
        lastRatings[line.playerId] = line.rating;
      }
    }

    // Only the man leading the line is worth a per-match history: a drought is
    // a question about the first-choice forward, so walking the whole pool's
    // match-by-match record would be reading a hundred careers to ask about
    // one.
    final forwards = [
      for (final p in squad.pool)
        if (p.category == PositionCategory.forward && xi.contains(p.id)) p,
    ];
    final lead = forwards.isEmpty
        ? null
        : forwards.reduce((a, b) => b.overall > a.overall ? b : a).id;
    int? sinceGoal;
    if (lead != null && (caps[lead] ?? 0) >= SquadStories.droughtCaps) {
      final history = await comp.playerMatchHistory(careerId, lead, limit: 40);
      var run = 0;
      for (final m in history) {
        if (m.goals > 0) break;
        run++;
      }
      sinceGoal = run;
    }

    // The captain's form, which is the one thing about him the save records.
    final captain = await ref.watch(captainProvider(careerId).future);
    final captainStats = captain == null
        ? null
        : await comp.playerCareerStats(careerId, captain.id);

    // A year ago, so a decline can be SEEN rather than assumed from an age.
    // Derived the way the yearly squad report derives it, and only when there
    // is a veteran in the squad for it to be about.
    final aging = CareerService.agingYears(career);
    final hasVeteran = squad.pool.any(
      (p) =>
          p.age >= SquadStories.veteranAge &&
          squad.callUps.contains(p.id) &&
          (caps[p.id] ?? 0) >= SquadStories.veteranCaps,
    );
    final lastYear = <int, int>{};
    if (hasVeteran && aging >= 1) {
      for (final p
          in await ref
              .watch(playerRepositoryProvider)
              .byNation(
                career.nationId,
                agingYears: aging - 1,
                saveSeed: career.rngSeed,
              )) {
        lastYear[p.id] = p.overall;
      }
    }

    return SquadStories.read([
      for (final p in squad.pool)
        if (squad.callUps.contains(p.id))
          (
            playerId: p.id,
            name: p.name,
            age: p.age,
            overall: p.overall,
            position: p.position,
            caps: caps[p.id] ?? 0,
            available: squad.absences[p.id]?.isAvailable ?? true,
            inXi: xi.contains(p.id),
            gamesSinceGoal: p.id == lead ? sinceGoal : null,
            lastRating: lastRatings[p.id],
            overallLastYear: lastYear[p.id],
            captain: p.id == captain?.id,
            // Only the captain's row carries a form reading: nothing else here
            // asks about form, and filling every row with his figures would be
            // a fact about him filed under everybody.
            formRating: p.id == captain?.id ? captainStats?.formRating : null,
            careerRating: p.id == captain?.id ? captainStats?.avgRating : null,
          ),
    ]);
  },
);

/// How far down the appearance ledger to read. Comfortably more than a nation
/// has ever capped, so a one-cap debutant is in it.
const int _capsRead = 500;

/// The next match, and what there is to say about the side on the other side
/// of it.
final AutoDisposeFutureProviderFamily<List<OpponentStory>, int>
opponentStoriesProvider = FutureProvider.autoDispose
    .family<List<OpponentStory>, int>((ref, careerId) async {
      final career = await ref.watch(careerRepositoryProvider).byId(careerId);
      if (career == null) return const [];
      final comp = ref.watch(competitionRepositoryProvider);
      final fixtures = await comp.fixturesForNation(careerId, career.nationId);
      final next = ([
        for (final f in fixtures)
          if (!f.hasResult) f,
      ]..sort((a, b) => a.date.compareTo(b.date))).firstOrNull;
      if (next == null) return const [];
      final opponentId = next.homeNationId == career.nationId
          ? next.awayNationId
          : next.homeNationId;

      // Every previous meeting, newest first, as a win/draw/defeat.
      final meetings = [
        for (final f in fixtures)
          if (f.hasResult &&
              (f.homeNationId == opponentId || f.awayNationId == opponentId))
            f,
      ]..sort((a, b) => b.date.compareTo(a.date));
      final results = [
        for (final f in meetings)
          () {
            final home = f.homeNationId == career.nationId;
            final mine = (home ? f.homeScore : f.awayScore) ?? 0;
            final theirs = (home ? f.awayScore : f.homeScore) ?? 0;
            return mine.compareTo(theirs);
          }(),
      ];

      final rivalry = await ref.watch(rivalryProvider(careerId).future);

      return OpponentStories.read(
        nextOpponentId: opponentId,
        rivalId: rivalry?.rival.id,
        rivalMeetings: rivalry?.played ?? 0,
        results: results,
        knockedUsOutId: _lastEliminator(
          fixtures,
          career.nationId,
          before: next.date,
        ),
      );
    });

/// How long a tournament exit is still worth avenging. One cycle: beyond that
/// the side that beat you is a different side and so is yours.
const int _revengeDays = 365 * 4;

/// Who put this nation out of the last tournament it went out of, if that was
/// recently enough to still be the story.
///
/// A knockout defeat in a finals round ends a run there and then — the same
/// reading [PressTopic.elimination] takes of the same fixture list. The
/// third-place match is not one of those: losing it is a disappointment, not
/// an elimination, because the side was already out when it kicked off.
int? _lastEliminator(
  List<Fixture> fixtures,
  int nationId, {
  required DateTime before,
}) {
  final out = [
    for (final f in fixtures)
      if (f.hasResult &&
          Rounds.isKnockout(f.round) &&
          !(f.round?.endsWith('3RD') ?? false) &&
          FinalsRounds.familyOf(f.round) != null &&
          before.difference(f.date).inDays <= _revengeDays)
        f,
  ]..sort((a, b) => b.date.compareTo(a.date));
  for (final f in out) {
    final home = f.homeNationId == nationId;
    final mine = (home ? f.homeScore : f.awayScore) ?? 0;
    final theirs = (home ? f.awayScore : f.homeScore) ?? 0;
    if (mine >= theirs) continue;
    return home ? f.awayNationId : f.homeNationId;
  }
  return null;
}
