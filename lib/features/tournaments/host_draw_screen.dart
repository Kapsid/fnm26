import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/features/tournaments/host_draw_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
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
    final l = AppLocalizations.of(context);
    final async = ref.watch(
      hostDrawProvider((careerId: widget.careerId, worldCup: widget.worldCup)),
    );

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          l.tourHostSelection,
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(child: Text(l.tourSharedCouldNotLoad)),
        data: (data) {
          if (data == null) {
            return Center(
              child: PrimaryButton(
                label: l.tourSharedContinue,
                icon: Icons.check_rounded,
                onPressed: _toHub,
              ),
            );
          }
          final hosts = [
            for (final id in data.hostIds)
              (
                code: data.nations[id]?.code ?? '??',
                name: data.nations[id]?.name ?? '—',
              ),
          ];

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(AppSpacing.marginMobile),
                  children: [
                    Text(
                      '${data.title} · ${data.year}',
                      style: AppTypography.headlineMedium,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      _revealed
                          ? (hosts.length > 1
                                ? 'And the hosts will be…'
                                : 'And the host will be…')
                          : 'The candidates in the running:',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _Envelope(revealed: _revealed, hosts: hosts),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      l.tourCandidates,
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: [
                        for (final bid in data.bids)
                          () {
                            // A bid wins as a whole, so it's chosen only when
                            // it IS the winning bid — not merely overlapping.
                            final won =
                                _revealed &&
                                bid.length == data.hostIds.length &&
                                bid.every(data.hostIds.contains);
                            return _Candidate(
                              nations: [
                                for (final id in bid)
                                  (
                                    code: data.nations[id]?.code ?? '??',
                                    name: data.nations[id]?.name ?? '—',
                                  ),
                              ],
                              chosen: won,
                              dimmed: _revealed && !won,
                            );
                          }(),
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
                          label: l.tourSharedContinue,
                          icon: Icons.check_rounded,
                          onPressed: _toHub,
                        )
                      : PrimaryButton(
                          label: l.tourSharedOpenEnvelope,
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

class _Envelope extends StatefulWidget {
  const _Envelope({required this.revealed, required this.hosts});

  final bool revealed;
  final List<({String code, String name})> hosts;

  @override
  State<_Envelope> createState() => _EnvelopeState();
}

class _EnvelopeState extends State<_Envelope>
    with SingleTickerProviderStateMixin {
  // Plays once when the envelope is opened: the flap lifts, then the host
  // card springs out of it.
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  @override
  void initState() {
    super.initState();
    if (widget.revealed) _c.value = 1; // already opened (revisiting)
  }

  @override
  void didUpdateWidget(_Envelope old) {
    super.didUpdateWidget(old);
    if (widget.revealed && !old.revealed) _c.forward(from: 0);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final multi = widget.hosts.length > 1;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
      constraints: const BoxConstraints(minHeight: 160),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: widget.revealed
            ? AppColors.secondaryContainer
            : AppColors.surfaceContainerHigh,
        borderRadius: AppRadii.baseAll,
        border: Border.all(
          color: widget.revealed ? AppColors.primary : AppColors.outlineVariant,
          width: widget.revealed ? 2 : 1,
        ),
      ),
      alignment: Alignment.center,
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, _) {
          if (!widget.revealed) {
            return const Icon(
              Icons.mail_outline_rounded,
              size: 56,
              color: AppColors.onSurfaceVariant,
            );
          }
          // Phase 1 (0–0.45): the flap opens — the closed envelope tips up and
          // fades into the open one. Phase 2 (0.45–1): the host card springs
          // out, scaling and rising into place.
          final flap = (_c.value / 0.45).clamp(0.0, 1.0);
          final content = Curves.easeOutBack.transform(
            ((_c.value - 0.45) / 0.55).clamp(0.0, 1.0),
          );

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // The opening envelope: mail → drafts, flap lifting up.
              Transform(
                alignment: Alignment.topCenter,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.002)
                  ..rotateX(-0.9 * flap),
                child: Opacity(
                  opacity: 1 - content.clamp(0.0, 1.0) * 0.85,
                  child: Icon(
                    flap < 0.5
                        ? Icons.mail_outline_rounded
                        : Icons.drafts_rounded,
                    size: 40,
                    color: AppColors.primary,
                  ),
                ),
              ),
              // The host card rising out of the envelope.
              ClipRect(
                child: Align(
                  heightFactor: content.clamp(0.0, 1.0),
                  child: Opacity(
                    opacity: content.clamp(0.0, 1.0),
                    child: Transform.scale(
                      scale: 0.7 + 0.3 * content.clamp(0.0, 1.0),
                      child: Padding(
                        padding: const EdgeInsets.only(top: AppSpacing.sm),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                for (final h in widget.hosts) ...[
                                  FlagDisc(
                                    h.code,
                                    size: multi ? 44 : 56,
                                    highlighted: true,
                                  ),
                                  const SizedBox(width: AppSpacing.sm),
                                ],
                              ],
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              widget.hosts.map((h) => h.name).join(' · '),
                              textAlign: TextAlign.center,
                              style: multi
                                  ? AppTypography.titleMedium
                                  : AppTypography.headlineMedium,
                            ),
                            Text(
                              multi ? 'CO-HOSTS' : 'HOST',
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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

/// One candidature on the table: a lone nation, or two or three standing
/// jointly. A joint bid reads as one chip — because that is what it is, and it
/// wins or loses as one.
class _Candidate extends StatelessWidget {
  const _Candidate({
    required this.nations,
    required this.chosen,
    required this.dimmed,
  });

  final List<({String code, String name})> nations;
  final bool chosen;
  final bool dimmed;

  @override
  Widget build(BuildContext context) {
    final joint = nations.length > 1;
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final n in nations) ...[
                  FlagDisc(n.code, size: 20, highlighted: chosen),
                  const SizedBox(width: 4),
                ],
                const SizedBox(width: AppSpacing.xs),
                Text(
                  nations.map((n) => n.name).join(' & '),
                  style: AppTypography.bodySmall.copyWith(
                    color: chosen ? AppColors.primary : AppColors.onSurface,
                    fontWeight: chosen ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
              ],
            ),
            if (joint)
              Text(
                AppLocalizations.of(context).tourJointBid,
                style: AppTypography.labelSmall.copyWith(
                  fontSize: 8,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
