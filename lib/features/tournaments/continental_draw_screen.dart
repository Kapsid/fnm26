import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/tournaments/continental_detail_providers.dart';
import 'package:fnm/features/tournaments/draw_ceremony.dart';
import 'package:go_router/go_router.dart';

/// The continental championship group draw, presented through the shared
/// [DrawCeremony] (balls from pots into the groups). Shows either the
/// qualifying draw or the finals draw, per [qualifying]. Viewing the finals
/// draw marks it watched so it fires as a timeline event only once.
class ContinentalDrawScreen extends ConsumerStatefulWidget {
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
  ConsumerState<ContinentalDrawScreen> createState() =>
      _ContinentalDrawScreenState();
}

class _ContinentalDrawScreenState extends ConsumerState<ContinentalDrawScreen> {
  bool _marked = false;

  Future<void> _markFinalsWatched() async {
    final career =
        await ref.read(careerRepositoryProvider).byId(widget.careerId);
    if (career == null) return;
    await ref.read(competitionRepositoryProvider).markDrawWatched(
          widget.careerId,
          career.cyclePointer,
          continentalFinalsDrawKind,
        );
  }

  @override
  Widget build(BuildContext context) {
    final careerId = widget.careerId;
    final confederation = widget.confederation;
    final key = (careerId: careerId, confederation: confederation);
    final dataAsync = ref.watch(
      widget.qualifying
          ? continentalQualifyingDrawProvider(key)
          : continentalDrawProvider(key),
    );

    // The finals draw fires as a one-time timeline event: mark it watched once
    // its data is ready (after the frame, to avoid mutating during build).
    if (!widget.qualifying && !_marked && dataAsync.valueOrNull != null) {
      _marked = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        unawaited(_markFinalsWatched());
      });
    }

    void leave() => context.go('${Routes.hub}?careerId=$careerId');

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.primary),
          onPressed: leave,
        ),
        title: Text(
          widget.qualifying ? 'QUALIFYING DRAW' : 'GROUP DRAW',
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
            highlightNationId: data.playerNationId,
            potCount: 4,
            onContinue: leave,
          );
        },
      ),
    );
  }
}
