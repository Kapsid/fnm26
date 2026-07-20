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
  static ({int direct, int? contention}) worldCupQualifying(
    Confederation confederation,
    int groupCount,
  ) {
    final fmt = QualificationFormat.forConfederation(confederation);
    final groups = groupCount < 1 ? 1 : groupCount;
    final direct = (fmt.directBerths ~/ groups).clamp(1, 99);
    final leftover = fmt.directBerths - direct * groups; // via best runners-up
    final hasContention = leftover > 0 || fmt.playoffEntrants > 0;
    return (direct: direct, contention: hasContention ? direct + 1 : null);
  }

  /// Continental qualifying, from the finals field [size] and [groupCount].
  /// Group winners always go through; the rest come from the best runners-up
  /// then the best thirds (as Qualification.qualifiers resolves them).
  ///
  /// `runnersQualify`/`thirdsQualify` say how many of each cross-group tier
  /// actually go through, so a screen can show the real ladder ("6 of 9
  /// runners-up advance") instead of leaving an amber stripe to be guessed at.
  static ({int direct, int? contention, int runnersQualify, int thirdsQualify})
      continentalQualifying(
    int size,
    int groupCount,
  ) {
    if (groupCount < 1) {
      return (direct: 1, contention: null, runnersQualify: 0, thirdsQualify: 0);
    }
    final afterWinners = size - groupCount; // places left for 2nd/3rd tiers
    if (afterWinners <= 0) {
      return (direct: 1, contention: null, runnersQualify: 0, thirdsQualify: 0);
    }
    if (afterWinners >= groupCount) {
      final thirds = (afterWinners - groupCount).clamp(0, groupCount);
      // The top two go through reliably (green). When any best-thirds places
      // exist, third place is flagged "in contention" (amber) — the same
      // reading the tournament detail screens give, so the hub, the round
      // results and the detail tabs never disagree about what third means.
      return (
        direct: 2,
        contention: thirds > 0 ? 3 : null,
        runnersQualify: groupCount,
        thirdsQualify: thirds,
      );
    }
    // Only the best runners-up qualify — second place is in contention.
    return (
      direct: 1,
      contention: 2,
      runnersQualify: afterWinners,
      thirdsQualify: 0,
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
        return (direct: 2, contention: null, relegate: 0);
    }
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
    switch (kind) {
      case CompetitionKind.nationsLeague:
        return adv.relegate > 0
            ? 'Winner goes up (League A: to the Finals Four); '
                'bottom side is relegated'
            : 'Winner goes up';
      case CompetitionKind.worldCupQualifying:
        return adv.contention != null
            ? '${top(adv.direct)} qualify; the best runners-up go to the '
                'play-offs'
            : '${top(adv.direct)} qualify';
      case CompetitionKind.continentalQualifying:
        return adv.contention != null
            ? '${top(adv.direct)} advance to the finals; the best third may '
                'follow'
            : '${top(adv.direct)} advance to the finals';
      case CompetitionKind.worldCupFinals:
      case CompetitionKind.continentalFinals:
        return adv.contention != null
            ? '${top(adv.direct)} advance; the best third-placed teams join them'
            : '${top(adv.direct)} advance';
      case CompetitionKind.friendly:
      case CompetitionKind.finalissima:
        return '';
    }
  }
}
