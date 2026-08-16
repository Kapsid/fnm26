import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/features/records/all_time_records_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

/// The save's global all-time records across every nation — the greatest
/// goalscorers and most-capped players the world has ever produced. Players
/// still active are highlighted, so a chart-topper you can still pick stands
/// out from the legends of the past.
class AllTimeRecordsScreen extends ConsumerStatefulWidget {
  const AllTimeRecordsScreen({required this.careerId, super.key});

  final int careerId;

  @override
  ConsumerState<AllTimeRecordsScreen> createState() =>
      _AllTimeRecordsScreenState();
}

class _AllTimeRecordsScreenState extends ConsumerState<AllTimeRecordsScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
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
          final q = _query.trim().toLowerCase();
          bool match(AllTimeLeader l) =>
              q.isEmpty ||
              l.name.toLowerCase().contains(q) ||
              l.nationName.toLowerCase().contains(q);
          final scorers = records.topScorers.where(match).toList();
          final caps = records.mostCaps.where(match).toList();
          final wcStarts = records.mostWcStarts.where(match).toList();
          final cups = records.mostCupsAttended.where(match).toList();
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            children: [
              _SearchField(onChanged: (v) => setState(() => _query = v)),
              const SizedBox(height: AppSpacing.md),
              _Board(
                title: l.recordsAllTimeTopScorers,
                unit: l.recordsUnitGoals,
                leaders: scorers,
                careerId: widget.careerId,
              ),
              const SizedBox(height: AppSpacing.lg),
              _Board(
                title: l.recordsMostCapped,
                unit: l.recordsUnitCaps,
                leaders: caps,
                careerId: widget.careerId,
              ),
              const SizedBox(height: AppSpacing.lg),
              _Board(
                title: l.recordsMostWcStarts,
                unit: l.recordsUnitStarts,
                leaders: wcStarts,
                careerId: widget.careerId,
              ),
              const SizedBox(height: AppSpacing.lg),
              _Board(
                title: l.recordsMostTournaments,
                unit: l.recordsUnitCups,
                leaders: cups,
                careerId: widget.careerId,
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

class _SearchField extends StatelessWidget {
  const _SearchField({required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return TextField(
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
  });

  final String title;
  final String unit;
  final List<AllTimeLeader> leaders;
  final int careerId;

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
                    trailing: leaders[i].active ? const _ActiveDot() : null,
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

class _ActiveDot extends StatelessWidget {
  const _ActiveDot();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.positive.withValues(alpha: 0.15),
        borderRadius: AppRadii.smAll,
      ),
      child: Text(
        l.recordsActive,
        style: AppTypography.labelSmall.copyWith(
          color: AppColors.positive,
          fontSize: 9,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
