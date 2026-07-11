import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/competition/qualification_format.dart';
import 'package:fnm/domain/services/competition/round_robin.dart';

/// A generated fixture, before persistence.
class GeneratedFixture {
  const GeneratedFixture({
    required this.matchday,
    required this.date,
    required this.homeNationId,
    required this.awayNationId,
  });

  final int matchday;
  final DateTime date;
  final int homeNationId;
  final int awayNationId;
}

/// A generated qualifying group, before persistence.
class GeneratedGroup {
  const GeneratedGroup({
    required this.name,
    required this.nationIds,
    required this.fixtures,
  });

  final String name;
  final List<int> nationIds;
  final List<GeneratedFixture> fixtures;
}

/// The full generated qualifying competition for one confederation.
class GeneratedSchedule {
  const GeneratedSchedule({
    required this.confederation,
    required this.name,
    required this.groups,
  });

  final Confederation confederation;
  final String name;
  final List<GeneratedGroup> groups;
}

/// Builds a deterministic World Cup qualifying schedule for a confederation:
/// a pot-based group draw plus double round-robin fixtures scheduled into FIFA
/// international windows.
class ScheduleGenerator {
  const ScheduleGenerator();

  /// International match windows (month numbers), two matchdays each.
  static const _windowMonths = [9, 10, 11, 3, 6];

  GeneratedSchedule generate({
    required Confederation confederation,
    required List<Nation> nations,
    required int rngSeed,
    DateTime? start,
    int? groupSize,
    Map<int, int>? rankById,
  }) {
    final rng = SeededRng(rngSeed ^ 0x5151A);
    final format = QualificationFormat.forConfederation(confederation);
    final groups = _draw(
      nations,
      groupSize ?? format.targetGroupSize,
      rng,
      rankById,
    );

    // One shared matchday→date map sized to the largest group.
    final maxRounds = groups
        .map((g) => _roundCount(g.length))
        .fold(0, (m, r) => r > m ? r : m);
    final dates = _matchdayDates(start ?? DateTime(2026, 9), maxRounds);

    final result = <GeneratedGroup>[];
    for (var gi = 0; gi < groups.length; gi++) {
      final ids = groups[gi];
      final rounds = doubleRoundRobin(ids, rng: rng);
      final fixtures = <GeneratedFixture>[];
      for (var r = 0; r < rounds.length; r++) {
        for (final (home, away) in rounds[r]) {
          fixtures.add(
            GeneratedFixture(
              matchday: r + 1,
              date: dates[r],
              homeNationId: home,
              awayNationId: away,
            ),
          );
        }
      }
      result.add(
        GeneratedGroup(
          name: String.fromCharCode(65 + gi), // A, B, C…
          nationIds: ids,
          fixtures: fixtures,
        ),
      );
    }

    return GeneratedSchedule(
      confederation: confederation,
      name: '${confederation.label} Qualifiers',
      groups: result,
    );
  }

  /// Pot-based draw: rank nations, split into pots, distribute one per group.
  /// Seeds by [rankById] (nationId → world position) when supplied, else by the
  /// nation's static seed ranking.
  List<List<int>> _draw(
    List<Nation> nations,
    int targetSize,
    SeededRng rng,
    Map<int, int>? rankById,
  ) {
    int rankOf(Nation n) => rankById?[n.id] ?? n.ranking;
    final sorted = [...nations]..sort((a, b) => rankOf(a).compareTo(rankOf(b)));
    final groupCount = (sorted.length / targetSize).round().clamp(1, 12);
    final groups = List.generate(groupCount, (_) => <int>[]);

    for (var start = 0; start < sorted.length; start += groupCount) {
      final end = (start + groupCount).clamp(0, sorted.length);
      final pot = rng.shuffled(
        sorted.sublist(start, end).map((n) => n.id).toList(),
      );
      for (var i = 0; i < pot.length; i++) {
        groups[i].add(pot[i]);
      }
    }
    return groups;
  }

  int _roundCount(int teams) => teams.isEven ? 2 * (teams - 1) : 2 * teams;

  List<DateTime> _matchdayDates(DateTime start, int count) {
    final dates = <DateTime>[];
    var seasonYear = start.year;
    var wi = 0;
    while (dates.length < count) {
      final month = _windowMonths[wi];
      final year = month >= 9 ? seasonYear : seasonYear + 1;
      dates.add(DateTime(year, month, 6));
      if (dates.length < count) dates.add(DateTime(year, month, 9));
      wi++;
      if (wi == _windowMonths.length) {
        wi = 0;
        seasonYear++;
      }
    }
    return dates;
  }
}
