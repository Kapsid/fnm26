import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/features/tournaments/finals_draw_providers.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

/// A pot-by-pot World Cup finals draw ceremony: teams are revealed into their
/// groups one at a time (the result is already decided; this presents it).
class FinalsDrawScreen extends ConsumerStatefulWidget {
  const FinalsDrawScreen({required this.careerId, super.key});

  final int careerId;

  @override
  ConsumerState<FinalsDrawScreen> createState() => _FinalsDrawScreenState();
}

typedef _Step = ({int groupIndex, int nationId, int pot});

class _FinalsDrawScreenState extends ConsumerState<FinalsDrawScreen> {
  int _revealed = 0;
  Timer? _timer;
  List<_Step> _steps = const [];

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _start(List<_Step> steps) {
    if (_steps.isNotEmpty) return;
    _steps = steps;
    _timer = Timer.periodic(const Duration(milliseconds: 280), (t) {
      if (_revealed >= _steps.length) {
        t.cancel();
        return;
      }
      setState(() => _revealed++);
    });
  }

  void _skip() {
    _timer?.cancel();
    setState(() => _revealed = _steps.length);
  }

  @override
  Widget build(BuildContext context) {
    final dataAsync = ref.watch(finalsDrawProvider(widget.careerId));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.primary),
          onPressed: () =>
              context.go('${Routes.cup}?careerId=${widget.careerId}'),
        ),
        title: Text(
          'FINALS DRAW',
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: dataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not load draw.\n$e')),
        data: (data) {
          if (data == null) {
            return const Center(child: Text('The draw is not ready yet.'));
          }
          final groups = data.draw.groups;
          final steps = <_Step>[
            for (var pot = 0; pot < 4; pot++)
              for (var gi = 0; gi < groups.length; gi++)
                if (pot < groups[gi].nationIds.length)
                  (
                    groupIndex: gi,
                    nationId: groups[gi].nationIds[pot],
                    pot: pot,
                  ),
          ];
          WidgetsBinding.instance.addPostFrameCallback((_) => _start(steps));

          final shown = steps.take(_revealed).toList();
          final revealedByGroup = <int, List<int>>{};
          for (final s in shown) {
            (revealedByGroup[s.groupIndex] ??= []).add(s.nationId);
          }
          final done = _revealed >= steps.length;
          final currentPot = done
              ? 4
              : (_revealed < steps.length ? steps[_revealed].pot + 1 : 4);

          String code(int id) => data.nations[id]?.code ?? '??';
          String name(int id) => data.nations[id]?.name ?? '—';

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.marginMobile),
                child: Text(
                  done ? 'DRAW COMPLETE' : 'DRAWING POT $currentPot',
                  style: AppTypography.labelMedium
                      .copyWith(color: AppColors.primary),
                ),
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.marginMobile,
                  ),
                  childAspectRatio: 0.92,
                  mainAxisSpacing: AppSpacing.sm,
                  crossAxisSpacing: AppSpacing.sm,
                  children: [
                    for (var gi = 0; gi < groups.length; gi++)
                      _GroupCard(
                        title: 'GROUP ${groups[gi].name}',
                        revealed: revealedByGroup[gi] ?? const [],
                        justAdded: !done &&
                                _revealed > 0 &&
                                steps[_revealed - 1].groupIndex == gi
                            ? steps[_revealed - 1].nationId
                            : null,
                        code: code,
                        name: name,
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.marginMobile),
                child: done
                    ? PrimaryButton(
                        label: 'Continue',
                        icon: Icons.check_rounded,
                        onPressed: () => context.go(
                          '${Routes.cup}?careerId=${widget.careerId}',
                        ),
                      )
                    : OutlinedButton(
                        onPressed: _skip,
                        child: const Text('Skip'),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _GroupCard extends StatelessWidget {
  const _GroupCard({
    required this.title,
    required this.revealed,
    required this.justAdded,
    required this.code,
    required this.name,
  });

  final String title;
  final List<int> revealed;
  final int? justAdded;
  final String Function(int) code;
  final String Function(int) name;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.labelSmall.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: AppSpacing.xs),
          for (var slot = 0; slot < 4; slot++)
            Expanded(
              child: slot < revealed.length
                  ? _row(revealed[slot], revealed[slot] == justAdded)
                  : const _EmptySlot(),
            ),
        ],
      ),
    );
  }

  Widget _row(int nationId, bool highlight) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          FlagDisc(code(nationId), size: 18, highlighted: highlight),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              name(nationId),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodySmall.copyWith(
                color: highlight ? AppColors.primary : AppColors.onSurface,
                fontWeight: highlight ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptySlot extends StatelessWidget {
  const _EmptySlot();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.outlineVariant),
        ),
      ),
    );
  }
}
