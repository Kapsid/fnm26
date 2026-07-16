import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/features/tournaments/draw_ceremony.dart';
import 'package:fnm/features/tournaments/nations_cup_draw_providers.dart';
import 'package:go_router/go_router.dart';

/// The Nations Cup group draw, presented through the shared [DrawCeremony]
/// (balls from pots into the manager's league groups). Viewing it once marks
/// the draw watched, so it fires as a timeline event a single time — and the
/// group tables stay hidden until it has been seen.
class NationsCupDrawScreen extends ConsumerStatefulWidget {
  const NationsCupDrawScreen({required this.careerId, super.key});

  final int careerId;

  @override
  ConsumerState<NationsCupDrawScreen> createState() =>
      _NationsCupDrawScreenState();
}

class _NationsCupDrawScreenState extends ConsumerState<NationsCupDrawScreen> {
  bool _marked = false;

  Future<void> _markWatched() async {
    final career =
        await ref.read(careerRepositoryProvider).byId(widget.careerId);
    if (career == null) return;
    await ref.read(competitionRepositoryProvider).markDrawWatched(
          widget.careerId,
          career.cyclePointer,
          nationsCupDrawKind,
        );
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(nationsCupDrawProvider(widget.careerId));

    // Fires once as a timeline event: mark it watched as soon as the data is
    // ready (after the frame, to avoid mutating during build).
    if (!_marked && async.valueOrNull != null) {
      _marked = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        unawaited(_markWatched());
      });
    }

    void leave() =>
        context.go('${Routes.hub}?careerId=${widget.careerId}');

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.primary),
          onPressed: leave,
        ),
        title: Text(
          'NATIONS CUP DRAW',
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not load draw.\n$e')),
        data: (data) {
          if (data == null) {
            return const Center(child: Text('The draw is not ready yet.'));
          }
          return DrawCeremony(
            groups: [
              for (final g in data.groups)
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
