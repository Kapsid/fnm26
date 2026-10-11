import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/features/records/all_time_records_providers.dart';
import 'package:fnm/features/shell/detail_pane_host.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/tablet.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

part 'all_time_records_tablet_layout.dart';

/// The save's global all-time records across every nation — the greatest
/// goalscorers and most-capped players the world has ever produced. Players
/// still active are highlighted, so a chart-topper you can still pick stands
/// out from the legends of the past.
class AllTimeRecordsScreen extends ConsumerStatefulWidget {
  const AllTimeRecordsScreen({required this.careerId, super.key});

  final int careerId;

  static const Key tabletLayoutKey = Key('allTimeRecords.tabletLayout');

  @override
  ConsumerState<AllTimeRecordsScreen> createState() =>
      _AllTimeRecordsScreenState();
}

class _AllTimeRecordsScreenState extends ConsumerState<AllTimeRecordsScreen> {
  String _query = '';

  /// The search box's text, owned here and handed to whichever layout is
  /// drawn, so a window resized across 1000 px keeps what was typed.
  final TextEditingController _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (TabletShellScope.isActive(context)) {
      return _AllTimeTabletLayout(
        careerId: widget.careerId,
        query: _query,
        search: _search,
        onQuery: (v) => setState(() => _query = v),
      );
    }
    final l = AppLocalizations.of(context);
    final async = ref.watch(allTimeRecordsProvider(widget.careerId));
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.canPop()
              ? context.pop()
              : context.go('${Routes.records}?careerId=${widget.careerId}'),
        ),
        title: Text(
          l.recordsAllTimeWorld,
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text(l.recordsCouldNotLoadRecords(e.toString()))),
        data: (records) {
          if (records == null) {
            return Center(child: Text(l.recordsSaveNotFound));
          }
          if (records.topScorers.isEmpty && records.mostCaps.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Text(
                  l.recordsNoWorldHistory,
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            );
          }
          final scorers = _filtered(records.topScorers, _query);
          final caps = _filtered(records.mostCaps, _query);
          final wcStarts = _filtered(records.mostWcStarts, _query);
          final cups = _filtered(records.mostCupsAttended, _query);
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            children: [
              _SearchField(
                controller: _search,
                onChanged: (v) => setState(() => _query = v),
              ),
              const SizedBox(height: AppSpacing.md),
              _Board(
                title: l.recordsAllTimeTopScorers,
                unit: l.recordsUnitGoals,
                leaders: scorers,
                careerId: widget.careerId,
                highlightNations: records.myNationIds,
              ),
              const SizedBox(height: AppSpacing.lg),
              _Board(
                title: l.recordsMostCapped,
                unit: l.recordsUnitCaps,
                leaders: caps,
                careerId: widget.careerId,
                highlightNations: records.myNationIds,
              ),
              const SizedBox(height: AppSpacing.lg),
              _Board(
                title: l.recordsMostWcStarts,
                unit: l.recordsUnitStarts,
                leaders: wcStarts,
                careerId: widget.careerId,
                highlightNations: records.myNationIds,
              ),
              const SizedBox(height: AppSpacing.lg),
              _Board(
                title: l.recordsMostTournaments,
                unit: l.recordsUnitCups,
                leaders: cups,
                careerId: widget.careerId,
                highlightNations: records.myNationIds,
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: AppColors.positive,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    l.recordsStillActive,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          );
        },
      ),
    );
  }
}

/// [leaders] whose name or nation contains [query], ignoring case; all of
/// them when the query is blank.
List<AllTimeLeader> _filtered(List<AllTimeLeader> leaders, String query) {
  final q = query.trim().toLowerCase();
  if (q.isEmpty) return leaders;
  return [
    for (final l in leaders)
      if (l.name.toLowerCase().contains(q) ||
          l.nationName.toLowerCase().contains(q))
        l,
  ];
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: AppTypography.bodyMedium,
      decoration: InputDecoration(
        isDense: true,
        hintText: l.recordsSearchPlayerOrNation,
        prefixIcon: const Icon(Icons.search, size: 20),
        filled: true,
        fillColor: AppColors.surfaceContainerHigh,
        border: const OutlineInputBorder(
          borderRadius: AppRadii.baseAll,
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _Board extends StatelessWidget {
  const _Board({
    required this.title,
    required this.unit,
    required this.leaders,
    required this.careerId,
    required this.highlightNations,
  });

  final String title;
  final String unit;
  final List<AllTimeLeader> leaders;
  final int careerId;
  final Set<int> highlightNations;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        const SizedBox(height: AppSpacing.sm),
        if (leaders.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Text(
              l.recordsNoMatches,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          )
        else
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (var i = 0; i < leaders.length; i++)
                  LeaderRow(
                    rank: i + 1,
                    name: leaders[i].name,
                    // The nation under the name: this chart spans the world,
                    // so who they played for is half the fact.
                    subtitle: leaders[i].nationName,
                    flagCode: leaders[i].nationCode,
                    value: '${leaders[i].value} $unit',
                    trailing: leaders[i].active ? const ActiveBadge() : null,
                    highlighted: highlightNations.contains(
                      leaders[i].nationId,
                    ),
                    onTap: () => context.push(
                      '${Routes.player}?careerId=$careerId'
                      '&playerId=${leaders[i].playerId}',
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
