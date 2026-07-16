import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/features/friendlies/friendlies_providers.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

/// Arrange up to three friendlies in the gap before the next competitive block.
/// Pick an opponent for each window (or leave it free); confirming schedules
/// the games and clears the hub's "arrange friendlies" prompt.
class FriendliesScreen extends ConsumerStatefulWidget {
  const FriendliesScreen({required this.careerId, super.key});

  final int careerId;

  @override
  ConsumerState<FriendliesScreen> createState() => _FriendliesScreenState();
}

class _FriendliesScreenState extends ConsumerState<FriendliesScreen> {
  // window date → chosen opponent id (absent = no game that window).
  final Map<DateTime, int> _picks = {};
  bool _saving = false;

  static const _months = [
    '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', //
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  String _label(DateTime d) => '${_months[d.month]} ${d.year}';

  /// A distinct block of suggested opponents for window [index], so each window
  /// offers a different (already seed-shuffled) set rather than the same list.
  List<Nation> _opponentsFor(List<Nation> pool, int index, int windowCount) {
    if (pool.isEmpty) return pool;
    final per = (pool.length ~/ windowCount).clamp(6, 12);
    final start = (index * per) % pool.length;
    return [for (var k = 0; k < per; k++) pool[(start + k) % pool.length]];
  }

  Future<void> _confirm(FriendliesPlan plan) async {
    setState(() => _saving = true);
    await ref.read(friendliesServiceProvider).arrange(
          widget.careerId,
          nationId: plan.playerNationId,
          cycle: plan.cycle,
          picks: _picks,
          allWindows: plan.windows,
        );
    if (mounted) context.go('${Routes.hub}?careerId=${widget.careerId}');
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(friendliesPlanProvider(widget.careerId));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () =>
              context.go('${Routes.hub}?careerId=${widget.careerId}'),
        ),
        title: Text(
          'FRIENDLIES',
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not load friendlies.\n$e')),
        data: (plan) {
          if (plan == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: PrimaryButton(
                  label: 'Continue',
                  icon: Icons.check_rounded,
                  onPressed: () =>
                      context.go('${Routes.hub}?careerId=${widget.careerId}'),
                ),
              ),
            );
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.marginMobile),
                child: Text(
                  'Arrange warm-ups for the ${plan.windows.length} open '
                  'window${plan.windows.length == 1 ? '' : 's'} before your '
                  'next competitive match. Tap an opponent, or leave it free.',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.marginMobile,
                  ),
                  children: [
                    for (var i = 0; i < plan.windows.length; i++)
                      _WindowCard(
                        label: _label(plan.windows[i]),
                        opponents: _opponentsFor(
                          plan.opponents,
                          i,
                          plan.windows.length,
                        ),
                        selected: _picks[plan.windows[i]],
                        code: (id) => plan.nations[id]?.code ?? '??',
                        name: (id) => plan.nations[id]?.name ?? '—',
                        onPick: (id) => setState(() {
                          final w = plan.windows[i];
                          if (_picks[w] == id) {
                            _picks.remove(w);
                          } else {
                            _picks[w] = id;
                          }
                        }),
                      ),
                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.marginMobile),
                  child: PrimaryButton(
                    label: _picks.isEmpty
                        ? 'No friendlies this window'
                        : 'Confirm ${_picks.length} friendly'
                            '${_picks.length == 1 ? '' : 's'}',
                    icon: Icons.check_rounded,
                    onPressed: _saving ? null : () => unawaited(_confirm(plan)),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _WindowCard extends StatelessWidget {
  const _WindowCard({
    required this.label,
    required this.opponents,
    required this.selected,
    required this.code,
    required this.name,
    required this.onPick,
  });

  final String label;
  final List<Nation> opponents;
  final int? selected;
  final String Function(int) code;
  final String Function(int) name;
  final ValueChanged<int> onPick;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(label, style: AppTypography.labelMedium),
                const Spacer(),
                if (selected != null)
                  Row(
                    children: [
                      FlagDisc(code(selected!), size: 18, highlighted: true),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        name(selected!),
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  )
                else
                  Text(
                    'Free',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final o in opponents)
                  _OppChip(
                    code: code(o.id),
                    selected: selected == o.id,
                    onTap: () => onPick(o.id),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _OppChip extends StatelessWidget {
  const _OppChip({
    required this.code,
    required this.selected,
    required this.onTap,
  });

  final String code;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.secondaryContainer
              : AppColors.surfaceContainer,
          borderRadius: AppRadii.smAll,
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.outlineVariant,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FlagDisc(code, size: 16, highlighted: selected),
            const SizedBox(width: 4),
            Text(
              code,
              style: AppTypography.labelSmall.copyWith(
                color: selected ? AppColors.primary : AppColors.onSurface,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
