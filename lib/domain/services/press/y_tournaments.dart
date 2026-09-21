import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/group_standing.dart';
import 'package:fnm/domain/services/competition/rounds.dart';
import 'package:fnm/domain/services/press/y_feed.dart';

/// What the country has to say about the TOURNAMENTS themselves — the trophy,
/// the exit, the place booked, the one that is nearly here.
///
/// Pure, and deliberately so. This used to be a private function inside the Y
/// provider, which meant the only way to ask "does the European Championship
/// produce a post?" was to simulate a whole World Cup cycle — so nobody ever
/// asked, and a competition that said nothing said nothing quietly. Everything
/// it needs is passed in: the nation's fixtures, the world's, and the
/// competition names.
abstract final class YTournaments {
  /// A qualifying campaign counts as a place BOOKED when the nation turns up
  /// at a finals within this long of its last qualifier. Two years: qualifying
  /// ends roughly a year before the tournament it feeds, and a slack window is
  /// safer than a tight one — a missed campaign has no finals fixtures at all,
  /// so nothing here can turn a miss into a celebration.
  static const Duration qualifyingReach = Duration(days: 730);

  /// Every milestone [nationId]'s campaigns have reached, in no particular
  /// order — the feed dates and sorts them.
  ///
  /// [nationFixtures] is the nation's own schedule; [worldFixtures] is
  /// everybody's, which is what a group finish has to be read against (the
  /// nation's own fixtures say only that it has no match left, and that is
  /// true of a group winner waiting on a draw as much as of a side on the
  /// plane home).
  static List<YMilestone> milestones({
    required List<Fixture> nationFixtures,
    required List<Fixture> worldFixtures,
    required Map<int, String> names,
    required int nationId,
  }) {
    if (nationFixtures.isEmpty) return const [];

    final byCompetition = <int, List<Fixture>>{};
    for (final f in nationFixtures) {
      (byCompetition[f.competitionId] ??= []).add(f);
    }
    for (final list in byCompetition.values) {
      list.sort((a, b) => a.date.compareTo(b.date));
    }

    final milestones = <YMilestone>[];
    for (final entry in byCompetition.entries) {
      final list = entry.value;
      final competition = names[entry.key];
      if (competition == null) continue;
      final played = [
        for (final f in list)
          if (f.hasResult) f,
      ];
      // A campaign still has matches to come: nobody writes its obituary yet.
      final finished = played.length == list.length;
      final last = played.isEmpty ? null : played.last;

      // A finals tournament the nation has finished: it ended in a trophy, a
      // runners-up medal, or an exit. Which one is the last round they played.
      if (finished && last != null) {
        final home = last.homeNationId == nationId;
        final mine = home ? last.homeScore! : last.awayScore!;
        final theirs = home ? last.awayScore! : last.homeScore!;
        final milestone = YFeed.endOfCampaign(
          round: last.round,
          competition: competition,
          // A final settled on penalties is won by the shoot-out, not the
          // score.
          won: last.wentToShootout
              ? (home
                    ? last.homePenalties! > last.awayPenalties!
                    : last.awayPenalties! > last.homePenalties!)
              : mine > theirs,
          date: last.date,
          key: 'cmp:${entry.key}',
          goneAtGroup: goneAtGroup(
            worldFixtures,
            competitionId: entry.key,
            nationId: nationId,
            groupId: last.groupId,
          ),
        );
        if (milestone != null) milestones.add(milestone);
      }

      // A qualifying campaign that ended in a place at the finals. Qualifying
      // is the rounds a finals tournament does NOT use — World Championship
      // qualifiers carry no round code at all, continental ones carry 'CQ'.
      if (finished && last != null && isQualifying(list)) {
        final reached = _finalsAfter(byCompetition, familyOf(list), last.date);
        if (reached != null && names[reached] != null) {
          milestones.add((
            template: YTemplate.qualified,
            args: [names[reached]!],
            date: last.date,
            key: 'qual:${entry.key}',
          ));
        }
      }

      // And the one that has not started yet. Dated at its first match rather
      // than invented: the feed sorts by date, and a post about a tournament
      // must not land before the results it is anticipating.
      final firstUnplayed = list.where((f) => !f.hasResult).firstOrNull;
      if (firstUnplayed != null && played.isEmpty && isFinals(list)) {
        milestones.add((
          template: YTemplate.tournamentSoon,
          args: [competition],
          date: firstUnplayed.date,
          key: 'soon:${entry.key}',
        ));
      }
    }
    return milestones;
  }

  /// Whether the nation's tournament ENDED in the group stage — really ended,
  /// rather than merely running out of fixtures for the moment.
  ///
  /// Three things have to hold, and each of them rules out a case that used to
  /// be reported as an elimination:
  ///
  ///  * the tournament has knockout ties already drawn — otherwise the side may
  ///    be a group winner waiting on a draw nobody has made yet;
  ///  * the nation is in none of them — the plain meaning of going out;
  ///  * and it did not win its group — the Nations Cup is one competition with
  ///    several leagues stacked inside it, so the ties above belong to League A
  ///    and a side that topped League B has been PROMOTED, not knocked out.
  static bool goneAtGroup(
    List<Fixture> worldFixtures, {
    required int competitionId,
    required int nationId,
    required int? groupId,
  }) {
    final knockout = [
      for (final f in worldFixtures)
        if (f.competitionId == competitionId &&
            coreRound(f.round) != null &&
            coreRound(f.round) != 'GROUP' &&
            YFeed.finalsRounds.contains(coreRound(f.round)))
          f,
    ];
    if (knockout.isEmpty) return false;
    final playing = knockout.any(
      (f) => f.homeNationId == nationId || f.awayNationId == nationId,
    );
    if (playing) return false;
    if (groupId == null) return true;

    final groupFixtures = [
      for (final f in worldFixtures)
        if (f.groupId == groupId) f,
    ];
    final members = <int>{
      for (final f in groupFixtures) ...[f.homeNationId, f.awayNationId],
    };
    final table = GroupStanding.table(members.toList(), groupFixtures);
    return table.isEmpty || table.first.nationId != nationId;
  }

  /// The core (confederation prefix stripped) of a fixture's round code.
  static String? coreRound(String? round) {
    if (round == null) return null;
    return round.startsWith('C') || round.startsWith('N')
        ? round.substring(1)
        : round;
  }

  /// Whether a competition is a FINALS tournament — the rounds a trophy is won
  /// in, as opposed to the campaign that gets a nation there.
  static bool isFinals(List<Fixture> list) =>
      list.any((f) => YFeed.finalsRounds.contains(coreRound(f.round)));

  /// Whether a competition is a QUALIFYING campaign: no finals round anywhere
  /// in it, and not a run of friendlies.
  static bool isQualifying(List<Fixture> list) =>
      !isFinals(list) && list.any((f) => f.round != Rounds.friendly);

  /// Which competition a set of fixtures belongs to: 'C' for the continental
  /// cup and its qualifiers, 'N' for the Nations Cup, '' for the World
  /// Championship and its qualifiers (which carry the bare round codes, or
  /// none at all).
  ///
  /// This is what stops a European qualifying campaign being credited with a
  /// place at the NATIONS CUP, which runs alongside it: without a family the
  /// rule "a finals tournament started shortly after this campaign ended" is
  /// true of every tournament in the calendar.
  static String familyOf(List<Fixture> list) {
    for (final f in list) {
      final round = f.round;
      if (round == null || round == Rounds.friendly) continue;
      if (round.startsWith('C')) return 'C';
      if (round.startsWith('N')) return 'N';
      return '';
    }
    // Nothing but uncoded fixtures: World Championship qualifying carries no
    // round code.
    return '';
  }

  /// The finals competition of [family] the nation turned up at after [after],
  /// or null when they did not — which is what a missed campaign looks like.
  static int? _finalsAfter(
    Map<int, List<Fixture>> byCompetition,
    String family,
    DateTime after,
  ) {
    for (final entry in byCompetition.entries) {
      final list = entry.value;
      if (!isFinals(list)) continue;
      if (familyOf(list) != family) continue;
      final first = list.first.date;
      if (first.isAfter(after) && first.difference(after) <= qualifyingReach) {
        return entry.key;
      }
    }
    return null;
  }
}
