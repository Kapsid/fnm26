import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/core/util/app_date.dart';
import 'package:fnm/core/util/career_label.dart';
import 'package:fnm/core/util/match_stage.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/competition/cycle_finish.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/results/results_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

/// One competition's matches, split into what the manager is living through
/// and the campaigns that are already history.
typedef ResultSection = ({
  /// The competition's name, as [MatchStage.category] writes it.
  String key,

  /// What is coming, soonest first, then what just happened, latest first.
  List<Fixture> current,

  /// Every earlier campaign's matches, latest first. Hidden until asked for.
  List<Fixture> older,
});

/// One cycle of a career, folded: what the summary line says, and the
/// competition sections behind it.
///
/// A career runs for decades and this screen is read by scrolling, so the list
/// grew without limit and answering "how did that cycle go?" meant scrolling
/// past every match of it. The summary carries the answer instead, and the
/// matches wait behind it.
typedef ResultsCycle = ({
  /// The cycle index, 0 up.
  int cycle,

  /// The World Championship year that closes it.
  int year,

  /// The nation led through it, or null when the save has no record of it.
  Nation? nation,

  int played,
  int won,
  int drawn,
  int lost,

  /// What the cycle ended in, or null while it is still being played.
  CycleFinish? finish,

  /// Its competitions, in the order [ResultsScreen.sections] puts them.
  List<ResultSection> sections,
});

/// The player's own matches (qualifiers + finals), the present at the top.
class ResultsScreen extends ConsumerStatefulWidget {
  const ResultsScreen({required this.careerId, super.key});

  final int careerId;

  /// Groups fixtures by competition, ordering the groups so the most currently
  /// relevant one (the soonest still-to-play) comes first; fully-played
  /// competitions fall to the bottom, most-recent first.
  ///
  /// Inside a group the order is the manager's, not the database's. A career
  /// runs for decades and the fixtures come back oldest first, so the screen
  /// used to open on a qualifier played twenty years ago. What is still to be
  /// played leads, soonest at the top; the results follow with the latest
  /// first; and everything from before the CURRENT campaign is set aside.
  ///
  /// "Campaign" is the competition row a fixture belongs to, which is created
  /// fresh each cycle: this World Championship, this qualifying group, this
  /// year's friendlies. That is the unit a manager thinks in. A calendar
  /// window would cut a qualifying campaign in half, and a single round would
  /// hide the group games while the quarter-final is being played. Nothing
  /// still to be played is ever set aside, whichever campaign it belongs to.
  static List<ResultSection> sections(AppLocalizations l, List<Fixture> all) {
    final groups = <String, List<Fixture>>{};
    for (final f in all) {
      (groups[MatchStage.category(l, f.round)] ??= []).add(f);
    }

    int keyFor(List<Fixture> fx) {
      final upcoming = fx.where((f) => !f.played).map((f) => f.date);
      if (upcoming.isNotEmpty) {
        // Soonest upcoming first (small, positive sort key).
        return upcoming
            .reduce((a, b) => a.isBefore(b) ? a : b)
            .millisecondsSinceEpoch;
      }
      // All played: push below any live competition, most recent first.
      final last = fx.map((f) => f.date).reduce((a, b) => a.isAfter(b) ? a : b);
      return 8000000000000 - last.millisecondsSinceEpoch;
    }

    final ordered = groups.entries.toList()
      ..sort((a, b) => keyFor(a.value).compareTo(keyFor(b.value)));

    return [
      for (final group in ordered)
        () {
          final upcoming = group.value.where((f) => !f.played).toList()
            ..sort((a, b) => a.date.compareTo(b.date));
          final played = group.value.where((f) => f.played).toList()
            ..sort((a, b) => b.date.compareTo(a.date));
          // The campaign the manager is in: the one the next match belongs to,
          // or, with nothing left to play, the one that finished last.
          final anchor = upcoming.isNotEmpty
              ? upcoming.first.competitionId
              : (played.isEmpty ? null : played.first.competitionId);
          return (
            key: group.key,
            current: [
              ...upcoming,
              ...played.where((f) => f.competitionId == anchor),
            ],
            older: played.where((f) => f.competitionId != anchor).toList(),
          );
        }(),
    ];
  }

  /// [data] as one section per cycle, the current cycle first.
  ///
  /// The record is counted over the cycle's own played matches from the point
  /// of view of the side the manager had at the time — which is not always the
  /// side he has now.
  static List<ResultsCycle> cycles(AppLocalizations l, ResultsData data) {
    final byCycle = <int, List<Fixture>>{};
    for (final f in data.fixtures) {
      (byCycle[cycleOfDate(f.date, data.cyclePointer)] ??= []).add(f);
    }
    final ordered = byCycle.keys.toList()..sort((a, b) => b.compareTo(a));
    return [
      for (final c in ordered)
        () {
          final fixtures = byCycle[c]!;
          final nationId = data.nationByCycle[c] ?? data.playerNationId;
          var played = 0;
          var won = 0;
          var drawn = 0;
          var lost = 0;
          for (final f in fixtures) {
            if (!f.hasResult) continue;
            final home = f.homeNationId == nationId;
            if (!home && f.awayNationId != nationId) continue;
            final mine = home ? f.homeScore! : f.awayScore!;
            final theirs = home ? f.awayScore! : f.homeScore!;
            played++;
            if (mine > theirs) {
              won++;
            } else if (mine == theirs) {
              drawn++;
            } else {
              lost++;
            }
          }
          return (
            cycle: c,
            year: CareerService.worldCupYear(c),
            nation: data.nations[nationId],
            played: played,
            won: won,
            drawn: drawn,
            lost: lost,
            // The cycle being played has not ended in anything yet, and saying
            // it did not qualify because the finals are months away would be a
            // lie the summary line cannot afford.
            finish: c == data.cyclePointer
                ? null
                : cycleFinishOf(fixtures, nationId, continental: false),
            sections: sections(l, fixtures),
          );
        }(),
    ];
  }

  @override
  ConsumerState<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends ConsumerState<ResultsScreen> {
  /// The competitions whose history the manager has opened, by section key.
  ///
  /// Keyed by CYCLE and section, because the same competition now appears once
  /// per cycle: an unqualified key opened four campaigns' worth of history at
  /// once.
  final Set<String> _opened = {};

  /// The cycles the manager has folded shut or pulled open by hand, against the
  /// default (see [_cycleOpen]). Empty until he touches one.
  final Map<int, bool> _cycles = {};

  /// Whether cycle [c] is showing its matches. The one being played opens; the
  /// rest wait behind their summary line, which is the whole point of folding
  /// them.
  bool _cycleOpen(int c, int cyclePointer) =>
      _cycles[c] ?? (c == cyclePointer);

  int get careerId => widget.careerId;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final dataAsync = ref.watch(resultsProvider(careerId));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.go('${Routes.hub}?careerId=$careerId'),
        ),
        title: Text(
          l.resultsMyMatches,
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: dataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text(l.resultsCouldNotLoad(e.toString()))),
        data: (data) {
          if (data == null || data.fixtures.isEmpty) {
            return Center(child: Text(l.resultsNoFixtures));
          }
          String code(int id) => data.nations[id]?.code ?? '??';

          Widget card(Fixture f) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: AppCard(
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.sm,
                horizontal: AppSpacing.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // The longest stage name in Czech ("SKUPINA FINÁLOVÉHO
                      // TURNAJE") is wider than the room left beside the
                      // date, so it is given the leftover width and the lines
                      // to wrap into. It used to sit beside a Spacer with
                      // neither, which is an overflow on a narrow phone. A
                      // plain Text, not a WholeText: this one has room to
                      // wrap into, and a WholeText scales itself down and so
                      // reports no cut however tight the box gets.
                      Expanded(
                        child: Text(
                          MatchStage.stage(l, f.round),
                          maxLines: 3,
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        AppDate.dayMonthYear(context, f.date),
                        maxLines: 1,
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  _ResultRow(fixture: f, code: code, isPlayer: false),
                ],
              ),
            ),
          );

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            children: [
              for (final cycle in ResultsScreen.cycles(l, data)) ...[
                _CycleHeader(
                  cycle: cycle,
                  open: _cycleOpen(cycle.cycle, data.cyclePointer),
                  onTap: () => setState(() {
                    _cycles[cycle.cycle] = !_cycleOpen(
                      cycle.cycle,
                      data.cyclePointer,
                    );
                  }),
                ),
                if (_cycleOpen(cycle.cycle, data.cyclePointer))
                  for (final section in cycle.sections) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        4,
                        AppSpacing.md,
                        4,
                        AppSpacing.sm,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // "KVALIFIKACE KONTINENTÁLNÍHO POHÁRU" is the widest
                          // heading in either language and wraps on a narrow
                          // phone; before this it had neither room nor lines
                          // and ran off the side.
                          Expanded(
                            child: Text(
                              section.key.toUpperCase(),
                              maxLines: 3,
                              style: AppTypography.labelMedium.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            '${section.current.length + section.older.length}',
                            maxLines: 1,
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    for (final f in section.current) card(f),
                    if (section.older.isNotEmpty) ...[
                      () {
                        final key = '${cycle.cycle}|${section.key}';
                        return _EarlierHeader(
                          count: section.older.length,
                          open: _opened.contains(key),
                          onTap: () => setState(() {
                            if (!_opened.remove(key)) _opened.add(key);
                          }),
                        );
                      }(),
                      if (_opened.contains('${cycle.cycle}|${section.key}'))
                        for (final f in section.older) card(f),
                    ],
                  ],
              ],
              const SizedBox(height: AppSpacing.xl),
            ],
          );
        },
      ),
    );
  }
}

/// One cycle's summary line: the fold, and everything a manager needs to decide
/// whether to open it.
///
/// Four facts, because four is what the question takes: WHICH cycle and WHOSE
/// side (a career crosses nations), how the football went, and what it all
/// ended in. A header that said only "2034" would have moved the scrolling
/// rather than removed it.
class _CycleHeader extends StatelessWidget {
  const _CycleHeader({
    required this.cycle,
    required this.open,
    required this.onTap,
  });

  final ResultsCycle cycle;
  final bool open;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final finish = cycle.finish;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
        onTap: onTap,
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.sm,
          horizontal: AppSpacing.md,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    l.resultsCycleTitle(
                      cycle.year,
                      cycle.nation?.name ?? l.hubYourNation,
                    ),
                    // Two lines: the longest nation name in the game beside a
                    // four-digit year does not fit one at 320px.
                    maxLines: 2,
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Icon(
                  open ? Icons.expand_less : Icons.expand_more,
                  size: 20,
                  color: AppColors.onSurfaceVariant,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              l.resultsCycleRecord(
                cycle.played,
                cycle.won,
                cycle.drawn,
                cycle.lost,
              ),
              maxLines: 2,
              style: AppTypography.bodySmall,
            ),
            Text(
              finish == null
                  ? l.resultsCycleUnderway
                  : l.resultsCycleFinish(cycleFinishLabel(l, finish)),
              maxLines: 2,
              style: AppTypography.labelSmall.copyWith(
                color: finish == CycleFinish.champions
                    ? AppColors.primary
                    : AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The one line that stands in for every campaign before the current one.
///
/// A career has no end, so this count climbs for as long as the save is
/// played. It costs one row until it is tapped, which is the point: the
/// screen's height stops depending on how long the manager has been in the
/// job.
class _EarlierHeader extends StatelessWidget {
  const _EarlierHeader({
    required this.count,
    required this.open,
    required this.onTap,
  });

  final int count;
  final bool open;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
        onTap: onTap,
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.sm,
          horizontal: AppSpacing.md,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                l.resultsEarlierMatches(count),
                // Two lines, because the count has no ceiling: after forty
                // years it is four digits long and the line still has to read
                // whole rather than trail off.
                maxLines: 2,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Icon(
              open ? Icons.expand_less : Icons.expand_more,
              size: 20,
              color: AppColors.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({
    required this.fixture,
    required this.code,
    required this.isPlayer,
  });

  final Fixture fixture;
  final String Function(int) code;
  final bool isPlayer;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final middle = fixture.hasResult
        ? '${fixture.homeScore} - ${fixture.awayScore}'
        : l.resultsVs;

    return Container(
      color: isPlayer ? AppColors.surfaceContainerHigh : null,
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 4),
      child: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  code(fixture.homeNationId),
                  style: AppTypography.bodySmall,
                ),
                const SizedBox(width: AppSpacing.sm),
                FlagDisc(code(fixture.homeNationId), size: 22),
              ],
            ),
          ),
          SizedBox(
            width: 64,
            child: Text(
              middle,
              textAlign: TextAlign.center,
              style: fixture.hasResult
                  ? AppTypography.labelMedium
                  : AppTypography.labelSmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                FlagDisc(code(fixture.awayNationId), size: 22),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  code(fixture.awayNationId),
                  style: AppTypography.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
