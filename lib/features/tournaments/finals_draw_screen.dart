import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/features/tournaments/draw_ceremony.dart';
import 'package:fnm/features/tournaments/finals_draw_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

/// The World Cup finals draw. Shows the seeding pots first (so the player can
/// see who's in each pot and where they're seeded), then plays the shared
/// [DrawCeremony] once the player starts it.
class FinalsDrawScreen extends ConsumerStatefulWidget {
  const FinalsDrawScreen({required this.careerId, super.key});

  final int careerId;

  @override
  ConsumerState<FinalsDrawScreen> createState() => _FinalsDrawScreenState();
}

class _FinalsDrawScreenState extends ConsumerState<FinalsDrawScreen> {
  bool _drawing = false;

  Future<void> _finishWatched(FinalsDrawData data) async {
    await ref
        .read(competitionRepositoryProvider)
        .markDrawWatched(widget.careerId, data.cycle, worldCupDrawKind);
    if (mounted) {
      context.go('${Routes.cup}?careerId=${widget.careerId}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final dataAsync = ref.watch(finalsDrawProvider(widget.careerId));
    void leave() => context.go('${Routes.cup}?careerId=${widget.careerId}');

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.primary),
          onPressed: leave,
        ),
        title: Text(
          _drawing ? 'FINALS DRAW' : 'SEEDING POTS',
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: dataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(child: Text(l.tourSharedCouldNotLoad)),
        data: (data) {
          if (data == null) {
            return Center(child: Text(l.tourContDrawNotReady));
          }
          if (_drawing) {
            return DrawCeremony(
              groups: [
                for (final g in data.draw.groups)
                  (name: g.name, nationIds: g.nationIds),
              ],
              nations: data.nations,
              highlightNationId: data.playerNationId,
              potCount: 4,
              onContinue: () => _finishWatched(data),
            );
          }
          // Once watched, the ceremony never re-animates — the pots view leads
          // straight to the drawn groups instead.
          return _PotsPreview(
            data: data,
            buttonLabel: data.alreadyWatched ? 'View groups' : 'Start the draw',
            buttonIcon: data.alreadyWatched
                ? Icons.table_rows_rounded
                : Icons.casino,
            onStart: data.alreadyWatched
                ? leave
                : () => setState(() => _drawing = true),
          );
        },
      ),
    );
  }
}

/// The four seeding pots (top-ranked teams in Pot 1) shown before the draw.
class _PotsPreview extends StatelessWidget {
  const _PotsPreview({
    required this.data,
    required this.onStart,
    required this.buttonLabel,
    required this.buttonIcon,
  });

  final FinalsDrawData data;
  final VoidCallback onStart;
  final String buttonLabel;
  final IconData buttonIcon;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    // Invert the nation→pot map into pot→nations, best-ranked first.
    final potCount = data.potByNation.values.fold(0, (m, p) => p > m ? p : m);
    final byPot = <int, List<int>>{};
    for (final entry in data.potByNation.entries) {
      (byPot[entry.value] ??= []).add(entry.key);
    }
    for (final list in byPot.values) {
      list.sort((a, b) {
        final ra = data.nations[a]?.ranking ?? 9999;
        final rb = data.nations[b]?.ranking ?? 9999;
        return ra.compareTo(rb);
      });
    }

    String code(int id) => data.nations[id]?.code ?? '??';
    String name(int id) => data.nations[id]?.name ?? '—';

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            children: [
              Text(
                l.tourFinalsDrawBlurb,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              for (var pot = 1; pot <= potCount; pot++) ...[
                Text(
                  AppLocalizations.of(context).tourPot(pot),
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                AppCard(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.sm,
                    horizontal: AppSpacing.md,
                  ),
                  child: Column(
                    children: [
                      for (final id in byPot[pot] ?? const <int>[])
                        _potRow(
                          code(id),
                          name(id),
                          isPlayer: id == data.playerNationId,
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
              ],
              const SizedBox(height: AppSpacing.sm),
            ],
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            child: PrimaryButton(
              label: buttonLabel,
              icon: buttonIcon,
              onPressed: onStart,
            ),
          ),
        ),
      ],
    );
  }

  Widget _potRow(String code, String name, {required bool isPlayer}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 1),
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
      decoration: isPlayer
          ? const BoxDecoration(
              color: AppColors.secondaryContainer,
              borderRadius: AppRadii.smAll,
            )
          : null,
      child: Row(
        children: [
          FlagDisc(code, size: 20, highlighted: isPlayer),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodySmall.copyWith(
                color: isPlayer ? AppColors.primary : AppColors.onSurface,
                fontWeight: isPlayer ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
