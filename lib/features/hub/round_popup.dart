import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/core/util/competition_label.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/competition/continental_cups.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

/// The knockout results of the round a background tournament just played,
/// ready to show as a popup after the player steps it forward on the hub.
typedef RoundPopup = ({
  String competition,
  String stage,
  List<Fixture> fixtures,

  /// The letter each group in the save is known by, so a group-stage day can
  /// be shown group by group instead of as one column of sixteen scorelines.
  Map<int, String> groupNames,
});

/// Human labels and bracket order for the knockout rounds of both the World Cup
/// finals and the continental championships.
const _knockoutRounds = <String, ({int order, String label})>{
  'R32': (order: 0, label: 'Round of 32'),
  'R16': (order: 1, label: 'Round of 16'),
  'QF': (order: 2, label: 'Quarter-finals'),
  'SF': (order: 3, label: 'Semi-finals'),
  '3RD': (order: 4, label: 'Third-place play-off'),
  'FINAL': (order: 5, label: 'Final'),
  'CR16': (order: 0, label: 'Round of 16'),
  'CQF': (order: 1, label: 'Quarter-finals'),
  'CSF': (order: 2, label: 'Semi-finals'),
  'C3RD': (order: 3, label: 'Third-place play-off'),
  'CFINAL': (order: 4, label: 'Final'),
  'NSF': (order: 0, label: 'Semi-finals'),
  'NFINAL': (order: 1, label: 'Final'),
};

/// The localised name for a knockout [round] code (empty/unknown = group stage),
/// shared by the World Cup, continental (C…) and Nations Cup (N…) prefixes. The
/// record still carries a canonical English [RoundPopup.stage]; this resolves
/// the code to the viewer's language only when the popup is shown.
String stageLabelFor(AppLocalizations l, String round) => switch (round) {
  'R32' => l.hubStageRoundOf32,
  'R16' || 'CR16' => l.finishRoundOf16,
  'QF' || 'CQF' => l.finishQuarterFinals,
  'SF' || 'CSF' || 'NSF' => l.finishSemiFinals,
  '3RD' || 'C3RD' => l.hubStageThirdPlace,
  'FINAL' || 'CFINAL' || 'NFINAL' => l.hubFinal,
  _ => l.finishGroupStage,
};

/// The results of the most recent day of whichever tournament the player is
/// following — the fixtures played on the latest date across the World Cup
/// finals, their continental championship and the Nations Cup Finals Four,
/// whether a group matchday or a knockout round, so a knocked-out or
/// non-qualifying manager can step through every day.
///
/// The competition is chosen by what actually played most recently rather than
/// by which tournament happens to exist: they overlap across a cycle, and the
/// Nations Cup is stepped on the hub too.
///
/// Null when nothing has been played yet.
final AutoDisposeFutureProviderFamily<RoundPopup?, int>
latestRoundPopupProvider = FutureProvider.autoDispose.family<RoundPopup?, int>((
  ref,
  careerId,
) async {
  final comp = ref.watch(competitionRepositoryProvider);
  final hub = await ref.watch(hubDataProvider(careerId).future);
  if (hub == null) return null;

  final conf = hub.nations[hub.career.nationId]?.confederation;
  final continentalName = conf == null
      ? 'Continental Championship'
      : ContinentalCups.byConfederation[conf]?.name ??
            'Continental Championship';

  // Every confederation's championship is a competition of the same kind, so
  // the continental source names the player's own: without it the popup could
  // report a round from a cup on the other side of the world under the name of
  // the manager's.
  final sources =
      <
        ({
          CompetitionKind kind,
          String name,
          List<String> rounds,
          Confederation? confederation,
        })
      >[
        (
          kind: CompetitionKind.worldCupFinals,
          name: 'World Cup',
          rounds: const ['GROUP', 'R32', 'R16', 'QF', 'SF', '3RD', 'FINAL'],
          confederation: null,
        ),
        (
          kind: CompetitionKind.continentalFinals,
          name: continentalName,
          rounds: const ['CGROUP', 'CR16', 'CQF', 'CSF', 'C3RD', 'CFINAL'],
          confederation: conf,
        ),
        (
          kind: CompetitionKind.nationsLeague,
          name: 'Nations Cup',
          rounds: const ['NSF', 'NFINAL'],
          confederation: null,
        ),
      ];

  ({String name, Fixture fixture})? newest;
  final byName = <String, List<Fixture>>{};
  for (final source in sources) {
    for (final round in source.rounds) {
      final fixtures = await comp.fixturesByRound(
        careerId,
        round,
        kind: source.kind,
        confederation: source.confederation,
      );
      for (final f in fixtures.where((f) => f.hasResult)) {
        (byName[source.name] ??= []).add(f);
        if (newest == null || f.date.isAfter(newest.fixture.date)) {
          newest = (name: source.name, fixture: f);
        }
      }
    }
  }
  final latest = newest;
  if (latest == null) return null;

  // Everything that competition played on its most recent date — the day the
  // player just stepped.
  final latestDate = latest.fixture.date;
  final sameDay =
      byName[latest.name]!
          .where((f) => f.date.isAtSameMomentAs(latestDate))
          .toList()
        ..sort((a, b) {
          final ao = _knockoutRounds[a.round ?? '']?.order ?? -1;
          final bo = _knockoutRounds[b.round ?? '']?.order ?? -1;
          return ao.compareTo(bo);
        });
  // Title by the day's most important round: should a play-off and the final
  // ever share a day, the popup reads "Final" (with the final listed last)
  // rather than burying it under "Third-place play-off".
  final round = sameDay.last.round ?? '';
  final label = _knockoutRounds[round]?.label ?? 'Group Stage';
  return (
    competition: latest.name,
    stage: label,
    fixtures: sameDay,
    groupNames: await comp.groupNames(careerId),
  );
});

/// Shows the day a background tournament just played as a centered popup, with
/// a button to open the full bracket: the ties of a knockout round, or a group
/// matchday group by group, a page at a time. Falls back to navigating straight
/// to [route] when there is nothing played to show at all.
Future<void> showRoundPopup(
  BuildContext context,
  WidgetRef ref,
  int careerId, {
  String? route,
}) async {
  final popup = await ref.refresh(latestRoundPopupProvider(careerId).future);
  final hub = await ref.read(hubDataProvider(careerId).future);
  if (!context.mounted) return;
  if (popup == null || hub == null) {
    if (route != null) context.go(route);
    return;
  }
  await showAppPopup<void>(
    context: context,
    builder: (context) => _RoundSheet(
      popup: popup,
      nations: hub.nations,
      onBracket: route == null
          ? null
          : () {
              Navigator.of(context).pop();
              context.go(route);
            },
    ),
  );
}

/// One block of the popup: the ties of a knockout round, or one group's
/// matchday.
typedef _Block = ({String? heading, List<Fixture> fixtures});

class _RoundSheet extends StatefulWidget {
  const _RoundSheet({
    required this.popup,
    required this.nations,
    required this.onBracket,
  });

  final RoundPopup popup;
  final Map<int, Nation> nations;
  final VoidCallback? onBracket;

  /// How many matches a page of the popup holds.
  ///
  /// A World Cup group matchday is sixteen fixtures, and sixteen scorelines in
  /// a popup is a column of text with the button that closes it somewhere off
  /// the bottom — the manager scrolls a list of other people's results looking
  /// for the end. Six fits the sheet, and a group is never split across a page
  /// boundary, so a page is two whole groups or one knockout round's worth.
  static const int perPage = 6;

  @override
  State<_RoundSheet> createState() => _RoundSheetState();
}

class _RoundSheetState extends State<_RoundSheet> {
  int _page = 0;

  /// The day's fixtures as blocks: one per GROUP when it was a group matchday
  /// (in group order), or a single unheaded block for a knockout round.
  List<_Block> get _blocks {
    final popup = widget.popup;
    final grouped = <String, List<Fixture>>{};
    final loose = <Fixture>[];
    for (final f in popup.fixtures) {
      final name = f.groupId == null ? null : popup.groupNames[f.groupId];
      if (name == null) {
        loose.add(f);
      } else {
        (grouped[name] ??= []).add(f);
      }
    }
    final names = grouped.keys.toList()..sort();
    return [
      if (loose.isNotEmpty) (heading: null, fixtures: loose),
      for (final name in names) (heading: name, fixtures: grouped[name]!),
    ];
  }

  /// The blocks split into pages, never cutting a group in half: a group goes
  /// on the current page if it fits, and starts a new one if it does not.
  List<List<_Block>> get _pages {
    final pages = <List<_Block>>[];
    var current = <_Block>[];
    var count = 0;
    for (final block in _blocks) {
      if (current.isNotEmpty &&
          count + block.fixtures.length > _RoundSheet.perPage) {
        pages.add(current);
        current = <_Block>[];
        count = 0;
      }
      current.add(block);
      count += block.fixtures.length;
    }
    if (current.isNotEmpty) pages.add(current);
    return pages.isEmpty ? [const <_Block>[]] : pages;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final popup = widget.popup;
    final pages = _pages;
    final page = pages[_page.clamp(0, pages.length - 1)];
    // The canonical round is the day's most important tie (fixtures are ordered
    // by bracket depth), resolved to the viewer's language here.
    final round = popup.fixtures.isEmpty
        ? ''
        : (popup.fixtures.last.round ?? '');
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
          AppSpacing.md,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header and rows mirror the after-match round-results screen, so
            // a tournament the player follows reads like one they played in.
            Text(
              // The record carries the CANONICAL stored name (a test keys on
              // it); the heading is written for the manager, like every other
              // competition name in the app.
              competitionLabel(l, popup.competition).toUpperCase(),
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.primary,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    stageLabelFor(l, round).toUpperCase(),
                    style: AppTypography.headlineMedium,
                  ),
                ),
                if (pages.length > 1)
                  Text(
                    l.hubRoundPage(_page + 1, pages.length),
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            AppCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final block in page) ...[
                    if (block.heading case final name?) ...[
                      Padding(
                        padding: const EdgeInsets.only(
                          top: AppSpacing.xs,
                          bottom: AppSpacing.xs,
                        ),
                        child: Text(
                          l.tourCupGroupName(name).toUpperCase(),
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                    for (final f in block.fixtures)
                      MatchResultRow(
                        fixture: f,
                        code: (id) => widget.nations[id]?.code ?? '??',
                        // No side is the manager's here — bold whoever
                        // advanced.
                        emphasiseWinner: true,
                      ),
                  ],
                ],
              ),
            ),
            if (pages.length > 1) ...[
              const SizedBox(height: AppSpacing.xs),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PagerButton(
                    label: l.transfersNewer,
                    icon: Icons.chevron_left_rounded,
                    leading: true,
                    onTap: _page == 0 ? null : () => setState(() => _page--),
                  ),
                  PagerButton(
                    label: l.transfersOlder,
                    icon: Icons.chevron_right_rounded,
                    leading: false,
                    onTap: _page >= pages.length - 1
                        ? null
                        : () => setState(() => _page++),
                  ),
                ],
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            // The classic bottom actions: Continue carries on (like every other
            // continue screen), Brackets opens the tournament in full.
            PrimaryButton(
              label: l.hubContinue,
              icon: Icons.check_rounded,
              onPressed: () => Navigator.of(context).pop(),
            ),
            if (widget.onBracket != null) ...[
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: widget.onBracket,
                  icon: const Icon(Icons.account_tree_outlined, size: 18),
                  label: Text(l.hubBrackets),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.outlineVariant),
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.md,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
