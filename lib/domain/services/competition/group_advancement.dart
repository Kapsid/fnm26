import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/competition/finals.dart';
import 'package:fnm/domain/services/competition/qualification_format.dart';

/// How a group's places resolve — which positions advance outright (direct,
/// shown green), the single "in contention" position (contention, shown amber:
/// a best runner-up, best third or play-off spot), and how many bottom places
/// go down (relegate, shown red). Shared by the hub group summary and the
/// tournament detail screens so they never disagree.
typedef Advancement = ({int direct, int? contention, int relegate});

abstract final class GroupAdvancement {
  /// World Cup qualifying, for a confederation running [groupCount] groups.
  ///
  /// Berths are filled a POSITION AT A TIME (see [Qualification.qualifiers]):
  /// every group winner first, then every runner-up, and so on. So the places
  /// that are safe are the whole tiers the berths cover, and the one partly
  /// covered tier is what's in contention.
  ///
  /// The old maths floored the safe count at one, which broke every
  /// confederation with FEWER berths than groups — Oceania has two qualifying
  /// groups for a single direct place, and both winners were painted green as
  /// though each had qualified.
  static ({int direct, int? contention, int contentionQualify})
  worldCupQualifying(Confederation confederation, int groupCount) {
    final fmt = QualificationFormat.forConfederation(confederation);
    final groups = groupCount < 1 ? 1 : groupCount;
    final full = fmt.directBerths ~/ groups; // positions that all go through
    final rest = fmt.directBerths % groups; // best of the next position
    // Play-off entrants come from the same ladder, so the contested position is
    // contested even when the direct berths divide evenly.
    final contested = rest > 0 || fmt.playoffEntrants > 0;
    return (
      direct: full,
      contention: contested ? full + 1 : null,
      contentionQualify: rest > 0 ? rest : fmt.playoffEntrants,
    );
  }

  /// Continental qualifying, from the number of finals places to be won
  /// ([size], already less any hosts) and [groupCount].
  ///
  /// The same position-at-a-time ladder as [worldCupQualifying]: whole tiers of
  /// places are safe, and the tier the berths run out in is the contested one.
  ///
  /// This used to assume the ladder never reached past third place, which is
  /// wrong wherever the field is large relative to the confederation. The
  /// Oceania Cup takes eight of eleven nations from two qualifying groups —
  /// seven places over two groups means the top THREE are through and fourth is
  /// contested, but the table highlighted the top two and put third in
  /// contention.
  ///
  /// `contentionQualify` is how many of the contested position go through, so a
  /// screen can show the real ladder ("1 of 2 fourth-placed sides advance")
  /// rather than leaving an amber stripe to be guessed at.
  static ({int direct, int? contention, int contentionQualify})
  continentalQualifying(int size, int groupCount) {
    final groups = groupCount < 1 ? 1 : groupCount;
    final berths = size < 0 ? 0 : size;
    final full = berths ~/ groups;
    final rest = berths % groups;
    return (
      direct: full,
      contention: rest > 0 ? full + 1 : null,
      contentionQualify: rest,
    );
  }

  /// A finals group stage: normally the top two advance, with the best thirds
  /// in contention. The exception is a two-group-of-five field (Copa América),
  /// where the top FOUR of each group go through to the quarter-finals.
  static ({int direct, int? contention}) finalsGroup(
    int groupCount,
    int fieldSize,
  ) {
    final perGroup = groupCount > 0 ? fieldSize ~/ groupCount : 0;
    if (groupCount == 2 && perGroup >= 5) {
      return (direct: 4, contention: null);
    }
    final thirds = WorldCupFinals.bestThirdsFor(groupCount);
    return (direct: 2, contention: thirds > 0 ? 3 : null);
  }

  /// The advancement for any group, dispatched by its competition [kind]. For
  /// continental qualifying, [continentalSize] is that confederation's finals
  /// field size.
  ///
  /// [isLowestLeague] applies to the Nations Cup only: the bottom league has
  /// nowhere to fall, so its last place is not relegated.
  static Advancement forGroup({
    required CompetitionKind kind,
    required Confederation confederation,
    required int groupCount,
    required int continentalSize,
    bool isLowestLeague = false,
  }) {
    switch (kind) {
      case CompetitionKind.worldCupQualifying:
        final adv = worldCupQualifying(confederation, groupCount);
        return (direct: adv.direct, contention: adv.contention, relegate: 0);
      case CompetitionKind.continentalQualifying:
        final adv = continentalQualifying(continentalSize, groupCount);
        return (direct: adv.direct, contention: adv.contention, relegate: 0);
      case CompetitionKind.worldCupFinals:
      case CompetitionKind.continentalFinals:
        final adv = finalsGroup(groupCount, continentalSize);
        return (direct: adv.direct, contention: adv.contention, relegate: 0);
      case CompetitionKind.nationsLeague:
        // Only the group winner advances (to the Finals Four / promotion), and
        // each group's bottom side drops a league — see
        // NationsCup.promoteRelegate. So a single green top spot, not two, and
        // a red bottom one everywhere but the lowest league.
        return (
          direct: 1,
          contention: null,
          relegate: isLowestLeague ? 0 : 1,
        );
      case CompetitionKind.friendly:
      case CompetitionKind.finalissima:
      // A knockout, so it has no group table — this is never called for it, but
      // the switch must stay exhaustive.
      case CompetitionKind.worldCupPlayoff:
        return (direct: 2, contention: null, relegate: 0);
    }
  }

  /// An English ordinal for a table position ("2nd", "3rd", "4th").
  static String ordinal(int n) {
    if (n % 100 >= 11 && n % 100 <= 13) return '${n}th';
    return switch (n % 10) {
      1 => '${n}st',
      2 => '${n}nd',
      3 => '${n}rd',
      _ => '${n}th',
    };
  }

  /// A one-line plain-English caption for a group's zones, so a table reads
  /// clearly instead of leaving the coloured borders to be guessed at.
  ///
  /// This is what tells the manager whether "green" means "top one" or "top
  /// two", and — for the Nations Cup — that the bottom side goes down. Without
  /// it, a qualifying group where the top two advance is easily mistaken for a
  /// league where two teams "progress".
  static String caption({
    required CompetitionKind kind,
    required Advancement adv,
  }) {
    String top(int n) => n == 1 ? 'Winner' : 'Top $n';
    // The contested position, named — "the best runners-up", "the best
    // fourth-placed sides". A confederation with fewer berths than groups
    // contests FIRST place, so this has to cover that too.
    String best(int? pos) => switch (pos) {
      null => '',
      1 => 'the best group winners',
      2 => 'the best runners-up',
      3 => 'the best third-placed sides',
      _ => 'the best ${ordinal(pos)}-placed sides',
    };
    switch (kind) {
      case CompetitionKind.nationsLeague:
        return adv.relegate > 0
            ? 'Winner goes up (League A: to the Finals Four); '
                  'bottom side is relegated'
            : 'Winner goes up';
      case CompetitionKind.worldCupQualifying:
        if (adv.direct == 0) {
          return 'Only ${best(adv.contention)} qualify; the next go to the '
              'play-offs';
        }
        return adv.contention != null
            ? '${top(adv.direct)} qualify; ${best(adv.contention)} go to the '
                  'play-offs'
            : '${top(adv.direct)} qualify';
      case CompetitionKind.continentalQualifying:
        if (adv.direct == 0) {
          return 'Only ${best(adv.contention)} advance to the finals';
        }
        return adv.contention != null
            ? '${top(adv.direct)} advance to the finals; '
                  '${best(adv.contention)} may follow'
            : '${top(adv.direct)} advance to the finals';
      case CompetitionKind.worldCupFinals:
      case CompetitionKind.continentalFinals:
        return adv.contention != null
            ? '${top(adv.direct)} advance; the best third-placed teams join them'
            : '${top(adv.direct)} advance';
      case CompetitionKind.friendly:
      case CompetitionKind.finalissima:
      case CompetitionKind.worldCupPlayoff:
        return '';
    }
  }
}
