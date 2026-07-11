import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/features/tournaments/continental_detail_providers.dart';
import 'package:fnm/features/tournaments/draw_ceremony.dart';
import 'package:go_router/go_router.dart';

/// The continental championship group draw, presented through the shared
/// [DrawCeremony] (balls from pots into the groups). Shows either the
/// qualifying draw or the finals draw, per [qualifying].
class ContinentalDrawScreen extends ConsumerWidget {
  const ContinentalDrawScreen({
    required this.careerId,
    required this.confederation,
    this.qualifying = false,
    super.key,
  });

  final int careerId;
  final Confederation confederation;
  final bool qualifying;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final key = (careerId: careerId, confederation: confederation);
    final dataAsync = ref.watch(
      qualifying
          ? continentalQualifyingDrawProvider(key)
          : continentalDrawProvider(key),
    );
    void leave() => context.go(
          '${Routes.continental}?careerId=$careerId&conf=${confederation.name}',
        );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.primary),
          onPressed: leave,
        ),
        title: Text(
          qualifying ? 'QUALIFYING DRAW' : 'GROUP DRAW',
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
