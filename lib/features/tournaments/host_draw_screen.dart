import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/layout/form_factor.dart';
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

  static const Key landscapeKey = Key('hostDraw.landscape');

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

  /// The edition and what the envelope is about to say (or has said).
  List<Widget> _heading(
    AppLocalizations l,
    HostDrawData data,
    int hostCount,
  ) => [
    Text('${data.title} · ${data.year}', style: AppTypography.headlineMedium),
    const SizedBox(height: AppSpacing.xs),
    Text(
      _revealed
          ? (hostCount > 1 ? l.tourDrawHostsReveal : l.tourDrawHostReveal)
          : l.tourDrawHostCandidates,
      style: AppTypography.bodyMedium.copyWith(
        color: AppColors.onSurfaceVariant,
      ),
    ),
  ];

  /// A bid wins as a whole, so it's chosen only when it IS the winning bid,
  /// not merely overlapping it.
  bool _won(HostDrawData data, List<int> bid) =>
      _revealed &&
      bid.length == data.hostIds.length &&
      bid.every(data.hostIds.contains);

  /// Every bid on the table, the winning one lit once revealed.
  Widget _candidates(HostDrawData data) => Wrap(
    spacing: AppSpacing.sm,
    runSpacing: AppSpacing.sm,
    children: [
      for (final bid in data.bids)
        _Candidate(
          nations: [
            for (final id in bid)
              (
                code: data.nations[id]?.code ?? '??',
                name: data.nations[id]?.name ?? '—',
              ),
          ],
          chosen: _won(data, bid),
          dimmed: _revealed && !_won(data, bid),
        ),
    ],
  );

  /// Open the envelope, then Continue.
  Widget _action(AppLocalizations l, HostDrawData data) => _revealed
      ? PrimaryButton(
          label: l.tourSharedContinue,
          icon: Icons.check_rounded,
          onPressed: _toHub,
        )
      : PrimaryButton(
          label: l.tourSharedOpenEnvelope,
          icon: Icons.mail_outline_rounded,
          onPressed: () => unawaited(_reveal(data)),
        );

  /// A tablet: the edition and the envelope centred on top, the bids as large
  /// tiles across the full width below, the action bottom right.
  Widget _landscape(
    AppLocalizations l,
    HostDrawData data,
    List<({String code, String name})> hosts,
  ) {
    return Padding(
      key: HostDrawScreen.landscapeKey,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DefaultTextStyle.merge(
            textAlign: TextAlign.center,
            child: Column(children: _heading(l, data, hosts.length)),
          ),
          const SizedBox(height: AppSpacing.md),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: _Envelope(revealed: _revealed, hosts: hosts, large: true),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            l.tourCandidates,
            style: AppTypography.labelSmall.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: LayoutBuilder(
              builder: (context, box) => _candidateGrid(data, box),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(width: 320, child: _action(l, data)),
          ),
        ],
      ),
    );
  }

  /// The bids as large tiles filling [box]: as many columns as fit at about
  /// 200 wide, more (down to about 140 wide) when the rows would not fit
  /// otherwise, each tile as tall as the rows allow between a floor and a cap,
  /// scrolling only when even the floor will not fit.
  Widget _candidateGrid(HostDrawData data, BoxConstraints box) {
    const gap = AppSpacing.sm;
    const minTile = 96.0;
    const maxTile = 180.0;
    final count = max(1, data.bids.length);
    int rowsFor(int columns) => (count / columns).ceil();
    bool fits(int columns) =>
        rowsFor(columns) * (minTile + gap) - gap <= box.maxHeight;
    var columns = min(max(2, (box.maxWidth / 200).floor()), count);
    final most = min(max(columns, (box.maxWidth / 140).floor()), count);
    while (columns < most && !fits(columns)) {
      columns++;
    }
    final rows = rowsFor(columns);
    final fit = (box.maxHeight - (rows - 1) * gap) / rows;
    final tileHeight = fit.clamp(minTile, maxTile);
    final tileWidth = (box.maxWidth - (columns - 1) * gap) / columns;
    // The flags grow with the tile, so a tall tile is not an empty one.
    final flag = (tileHeight * 0.36).clamp(40.0, 64.0);
    return GridView.count(
      crossAxisCount: columns,
      childAspectRatio: tileWidth / tileHeight,
      mainAxisSpacing: gap,
      crossAxisSpacing: gap,
      children: [
        for (final bid in data.bids)
          _CandidateTile(
            nations: [
              for (final id in bid)
                (
                  code: data.nations[id]?.code ?? '??',
                  name: data.nations[id]?.name ?? '—',
                ),
            ],
            chosen: _won(data, bid),
            dimmed: _revealed && !_won(data, bid),
            flagSize: flag,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final async = ref.watch(
      hostDrawProvider((careerId: widget.careerId, worldCup: widget.worldCup)),
    );

    final landscape = useTabletLayout(context, ref);

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
          if (landscape) return _landscape(l, data, hosts);

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(AppSpacing.marginMobile),
                  children: [
                    ..._heading(l, data, hosts.length),
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
                    _candidates(data),
                  ],
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.marginMobile),
                  child: _action(l, data),
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
  const _Envelope({
    required this.revealed,
    required this.hosts,
    this.large = false,
  });

  final bool revealed;
  final List<({String code, String name})> hosts;

  /// The tablet stage's bigger envelope: taller, with bigger flags and name.
  final bool large;

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
    final large = widget.large;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
      constraints: BoxConstraints(minHeight: large ? 200 : 160),
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
            return Icon(
              Icons.mail_outline_rounded,
              size: large ? 72 : 56,
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
                    size: large ? 48 : 40,
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
                                    size: large
                                        ? (multi ? 64 : 80)
                                        : (multi ? 44 : 56),
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
                              style: multi && !large
                                  ? AppTypography.titleMedium
                                  : AppTypography.headlineMedium,
                            ),
                            Text(
                              multi
                                  ? AppLocalizations.of(
                                      context,
                                    ).tourSharedCoHostsHeading
                                  : AppLocalizations.of(
                                      context,
                                    ).tourSharedHostHeading,
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

/// The tablet's candidature tile: the bid's flags and names large and
/// centred, lit when it wins and dimmed when it loses, like [_Candidate].
class _CandidateTile extends StatelessWidget {
  const _CandidateTile({
    required this.nations,
    required this.chosen,
    required this.dimmed,
    required this.flagSize,
  });

  final List<({String code, String name})> nations;
  final bool chosen;
  final bool dimmed;

  /// A lone nation's flag; a joint bid's flags are a little smaller.
  final double flagSize;

  @override
  Widget build(BuildContext context) {
    final joint = nations.length > 1;
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 350),
      opacity: dimmed ? 0.35 : 1,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: chosen
              ? AppColors.secondaryContainer
              : AppColors.surfaceContainer,
          borderRadius: AppRadii.baseAll,
          border: Border.all(
            color: chosen ? AppColors.primary : AppColors.outlineVariant,
            width: chosen ? 2 : 1,
          ),
        ),
        // Scaled down only when a floor-height tile cannot hold it all.
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final (i, n) in nations.indexed) ...[
                    if (i > 0) const SizedBox(width: AppSpacing.xs),
                    FlagDisc(
                      n.code,
                      size: joint ? flagSize * 0.85 : flagSize,
                      highlighted: chosen,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                nations.map((n) => n.name).join(' & '),
                textAlign: TextAlign.center,
                maxLines: 1,
                style: AppTypography.titleMedium.copyWith(
                  color: chosen ? AppColors.primary : AppColors.onSurface,
                  fontWeight: chosen ? FontWeight.w700 : null,
                ),
              ),
              if (joint)
                Text(
                  AppLocalizations.of(context).tourJointBid,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
