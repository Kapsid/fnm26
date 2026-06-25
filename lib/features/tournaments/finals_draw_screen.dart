import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/features/tournaments/draw_ceremony.dart';
import 'package:fnm/features/tournaments/finals_draw_providers.dart';
import 'package:go_router/go_router.dart';

/// The World Cup finals draw, presented through the shared [DrawCeremony]
/// (balls drawn from four pots into the eight groups).
class FinalsDrawScreen extends ConsumerWidget {
  const FinalsDrawScreen({required this.careerId, super.key});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(finalsDrawProvider(careerId));
    void leave() => context.go('${Routes.cup}?careerId=$careerId');

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.primary),
          onPressed: leave,
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
          return DrawCeremony(
            groups: [
              for (final g in data.draw.groups)
                (name: g.name, nationIds: g.nationIds),
            ],
            nations: data.nations,
            potCount: 4,
            onContinue: leave,
          );
        },
      ),
    );
  }
}
