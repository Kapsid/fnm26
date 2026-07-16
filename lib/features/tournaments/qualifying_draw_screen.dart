import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/features/tournaments/draw_ceremony.dart';
import 'package:fnm/features/tournaments/qualifying_draw_providers.dart';
import 'package:go_router/go_router.dart';

/// A qualifying draw, presented through the shared animated [DrawCeremony] (the
/// same ball-from-pots ceremony as the World Cup finals draw). Viewing it marks
/// the draw watched, so it fires as a timeline event once.
class QualifyingDrawScreen extends ConsumerStatefulWidget {
  const QualifyingDrawScreen({
    required this.careerId,
    required this.worldCup,
    super.key,
  });

  final int careerId;
  final bool worldCup;

  @override
  ConsumerState<QualifyingDrawScreen> createState() =>
      _QualifyingDrawScreenState();
}

class _QualifyingDrawScreenState extends ConsumerState<QualifyingDrawScreen> {
  bool _marked = false;

  @override
  Widget build(BuildContext context) {
    final careerId = widget.careerId;
    final worldCup = widget.worldCup;
    final dataAsync = ref.watch(
      qualifyingDrawProvider((careerId: careerId, worldCup: worldCup)),
    );

    // Record that this draw has now been seen (once) so the hub stops surfacing
    // it as a pending event — after the frame, to avoid mutating during build.
    // nextEventProvider auto-disposes, so it re-reads this on returning to hub.
    final data = dataAsync.valueOrNull;
    if (data != null && !_marked) {
      _marked = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        unawaited(
          ref
              .read(competitionRepositoryProvider)
              .markDrawWatched(careerId, data.cycle, data.watchedKind),
        );
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
          worldCup ? 'WC QUALIFYING DRAW' : 'QUALIFYING DRAW',
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: dataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not load draw.\n$e')),
        data: (data) {
          if (data == null) {
            return const Center(child: Text('No qualifying draw.'));
          }
          final potCount = data.groups.fold(
            0,
            (m, g) => g.nationIds.length > m ? g.nationIds.length : m,
          );
          return DrawCeremony(
            groups: [
              for (final g in data.groups)
                (name: g.name, nationIds: g.nationIds),
            ],
            nations: data.nations,
            highlightNationId: data.playerNationId,
            potCount: potCount,
            onContinue: leave,
          );
        },
      ),
    );
  }
}
