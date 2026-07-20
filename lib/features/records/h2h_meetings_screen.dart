import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/features/nations/nation_select_providers.dart';
import 'package:fnm/features/records/head_to_head_providers.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// Every past meeting between two nations — result, date and competition — the
/// detail behind a head-to-head record. Reached from the match preview or the
/// head-to-head screen.
class H2HMeetingsScreen extends ConsumerWidget {
  const H2HMeetingsScreen({
    required this.careerId,
    required this.nationA,
    required this.nationB,
    super.key,
  });

  final int careerId;
  final int nationA;
  final int nationB;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nationsAsync = ref.watch(nationsProvider);
    final meetingsAsync = ref.watch(
      h2hMeetingsProvider(
        (careerId: careerId, nationA: nationA, nationB: nationB),
      ),
    );
    final byId = <int, Nation>{
      for (final n in nationsAsync.valueOrNull ?? const <Nation>[]) n.id: n,
    };
    final aName = byId[nationA]?.name ?? '';
    final bName = byId[nationB]?.name ?? '';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () =>
              context.canPop() ? context.pop() : context.go('/'),
        ),
        title: Text(
          'MEETINGS',
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: meetingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not load.\n$e')),
        data: (meetings) {
          if (meetings.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Text(
                  '$aName and $bName have never met in this save.',
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyMedium
                      .copyWith(color: AppColors.onSurfaceVariant),
                ),
              ),
            );
          }
          final wins = meetings.where((m) => m.forA > m.forB).length;
          final draws = meetings.where((m) => m.forA == m.forB).length;
          final losses = meetings.where((m) => m.forA < m.forB).length;
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            children: [
              Text(
                '$aName vs $bName',
                style: AppTypography.titleMedium,
              ),
              Text(
                '${meetings.length} meetings · ${wins}W ${draws}D ${losses}L',
                style: AppTypography.labelSmall
                    .copyWith(color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(height: AppSpacing.md),
              for (final m in meetings) _MeetingRow(meeting: m),
              const SizedBox(height: AppSpacing.xl),
            ],
          );
        },
      ),
    );
  }
}

class _MeetingRow extends StatelessWidget {
  const _MeetingRow({required this.meeting});

  final H2HMeeting meeting;

  @override
  Widget build(BuildContext context) {
    final m = meeting;
    final result = m.forA > m.forB
        ? AppColors.positive
        : m.forA < m.forB
            ? AppColors.error
            : AppColors.onSurfaceVariant;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.sm,
          horizontal: AppSpacing.md,
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                color: result.withValues(alpha: 0.14),
                borderRadius: AppRadii.smAll,
              ),
              child: Text(
                '${m.forA}–${m.forB}',
                style: AppTypography.titleMedium.copyWith(color: result),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    m.competition,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodyMedium,
                  ),
                  Text(
                    DateFormat('d MMM yyyy').format(m.date),
                    style: AppTypography.labelSmall
                        .copyWith(color: AppColors.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
