import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/features/tournaments/host_draw_providers.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

/// The host-selection ceremony: the candidate nations are shown first, then the
/// envelope is opened to reveal the chosen host. Viewing it once marks the draw
/// watched, so it fires as a timeline event a single time.
class HostDrawScreen extends ConsumerStatefulWidget {
  const HostDrawScreen({
    required this.careerId,
    required this.worldCup,
    super.key,
  });

  final int careerId;
  final bool worldCup;

  @override
  ConsumerState<HostDrawScreen> createState() => _HostDrawScreenState();
}

class _HostDrawScreenState extends ConsumerState<HostDrawScreen> {
  bool _revealed = false;

  Future<void> _reveal(HostDrawData data) async {
    setState(() => _revealed = true);
    await ref
        .read(competitionRepositoryProvider)
        .markDrawWatched(widget.careerId, data.cycle, data.watchedKind);
  }

  void _toHub() => context.go('${Routes.hub}?careerId=${widget.careerId}');

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(
      hostDrawProvider((careerId: widget.careerId, worldCup: widget.worldCup)),
    );

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'HOST SELECTION',
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not load host draw.\n$e')),
        data: (data) {
          if (data == null) {
            return Center(
              child: PrimaryButton(
                label: 'Continue',
                icon: Icons.check_rounded,
                onPressed: _toHub,
              ),
            );
          }
          final hostName = data.nations[data.hostId]?.name ?? '—';
          final hostCode = data.nations[data.hostId]?.code ?? '??';

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(AppSpacing.marginMobile),
                  children: [
                    Text('${data.title} · ${data.year}',
                        style: AppTypography.headlineMedium),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      _revealed
                          ? 'And the hosts will be…'
                          : 'The candidates in the running:',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _Envelope(
                      revealed: _revealed,
                      hostCode: hostCode,
                      hostName: hostName,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'CANDIDATES',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: [
                        for (final id in data.candidateIds)
                          _Candidate(
                            code: data.nations[id]?.code ?? '??',
                            name: data.nations[id]?.name ?? '—',
                            chosen: _revealed && id == data.hostId,
                            dimmed: _revealed && id != data.hostId,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.marginMobile),
                  child: _revealed
                      ? PrimaryButton(
                          label: 'Continue',
                          icon: Icons.check_rounded,
                          onPressed: _toHub,
                        )
                      : PrimaryButton(
                          label: 'Open the envelope',
                          icon: Icons.mail_outline_rounded,
                          onPressed: () => unawaited(_reveal(data)),
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

class _Envelope extends StatelessWidget {
  const _Envelope({
    required this.revealed,
    required this.hostCode,
    required this.hostName,
  });

  final bool revealed;
  final String hostCode;
  final String hostName;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
      height: 160,
      decoration: BoxDecoration(
        color: revealed
            ? AppColors.secondaryContainer
            : AppColors.surfaceContainerHigh,
        borderRadius: AppRadii.baseAll,
        border: Border.all(
          color: revealed ? AppColors.primary : AppColors.outlineVariant,
          width: revealed ? 2 : 1,
        ),
      ),
      alignment: Alignment.center,
      child: revealed
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FlagDisc(hostCode, size: 56, highlighted: true),
                const SizedBox(height: AppSpacing.sm),
                Text(hostName, style: AppTypography.headlineMedium),
                Text(
                  'HOSTS',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            )
          : const Icon(
              Icons.mail_outline_rounded,
              size: 56,
              color: AppColors.onSurfaceVariant,
            ),
    );
  }
}

class _Candidate extends StatelessWidget {
  const _Candidate({
    required this.code,
    required this.name,
    required this.chosen,
    required this.dimmed,
  });

  final String code;
  final String name;
  final bool chosen;
  final bool dimmed;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: dimmed ? 0.35 : 1,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: chosen
              ? AppColors.secondaryContainer
              : AppColors.surfaceContainer,
          borderRadius: AppRadii.smAll,
          border: Border.all(
            color: chosen ? AppColors.primary : AppColors.outlineVariant,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FlagDisc(code, size: 20, highlighted: chosen),
            const SizedBox(width: AppSpacing.sm),
            Text(
              name,
              style: AppTypography.bodySmall.copyWith(
                color: chosen ? AppColors.primary : AppColors.onSurface,
                fontWeight: chosen ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
