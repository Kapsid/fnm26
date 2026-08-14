import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/nations/nation_select_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

/// The share of the world ranking a "from the bottom" career starts in: the
/// bottom half, drawn from at random.
///
/// Not the literal last three sides — that would be the same three every time,
/// and the point of the mode is that you do not get to choose. A pool this wide
/// keeps every run different while still meaning nobody who could realistically
/// qualify for anything is on the table.
const double _bottomShare = 0.5;

/// How many federations come in for an out-of-work manager.
const int _offerCount = 3;

/// Starting a career with no job: three of the world's weakest federations put
/// an offer on the table, and the manager takes one of them.
///
/// The ordinary route into a save is to pick your country off a list, which
/// makes the first decision of a career the least interesting one available —
/// everybody picks somebody good. Here the job picks you.
class UnemployedStartScreen extends ConsumerStatefulWidget {
  const UnemployedStartScreen({super.key});

  @override
  ConsumerState<UnemployedStartScreen> createState() =>
      _UnemployedStartScreenState();
}

class _UnemployedStartScreenState extends ConsumerState<UnemployedStartScreen> {
  /// Fixed for the life of the screen, so the offers do not reshuffle on every
  /// rebuild. There is deliberately no re-roll: an out-of-work manager takes
  /// one of the three jobs on the table or walks away — waiting for a better
  /// offer would turn the mode back into picking your country off a list.
  final int _seed = DateTime.now().microsecondsSinceEpoch & 0x7FFFFFFF;

  /// The federations on the table: [_offerCount] drawn at random from the
  /// bottom [_bottomShare] of the ranking that this player may actually manage.
  List<Nation> _offers(List<Nation> all, {required bool premium}) {
    final eligible = [
      for (final n in all)
        if (nationSelectable(n, premiumUnlocked: premium)) n,
    ]..sort((a, b) => a.ranking.compareTo(b.ranking));
    if (eligible.isEmpty) return const [];
    // The weakest half — but never fewer than the number of offers, so a
    // demo-locked pool of a handful of nations still fills the table.
    final from = (eligible.length * (1 - _bottomShare)).floor();
    var pool = eligible.sublist(from.clamp(0, eligible.length - 1));
    if (pool.length < _offerCount) pool = eligible;
    return SeededRng(_seed).shuffled(pool).take(_offerCount).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final nationsAsync = ref.watch(nationsProvider);
    final premium = ref.watch(premiumUnlockedProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () =>
              context.canPop() ? context.pop() : context.go(Routes.nations),
        ),
        title: Text(
          l.bottomStartTitle,
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: nationsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text(l.nationsCouldNotLoadNations(e.toString()))),
        data: (nations) {
          final offers = _offers(nations, premium: premium);
          if (offers.isEmpty) {
            return Center(child: Text(l.nationsNoMatch));
          }
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            children: [
              Text(
                l.bottomStartHeading,
                style: AppTypography.headlineLargeMobile,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                l.bottomStartBlurb,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              for (final nation in offers)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _OfferCard(
                    nation: nation,
                    total: nations.length,
                    onAccept: () =>
                        context.go('${Routes.newGame}?nationId=${nation.id}'),
                  ),
                ),
              const SizedBox(height: AppSpacing.md),
              OutlinedButton.icon(
                onPressed: () => context.canPop()
                    ? context.pop()
                    : context.go(Routes.nations),
                icon: const Icon(Icons.arrow_back, size: 18),
                label: Text(l.bottomStartBack),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.onSurfaceVariant,
                  side: const BorderSide(color: AppColors.outlineVariant),
                  minimumSize: const Size.fromHeight(48),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          );
        },
      ),
    );
  }
}

/// One federation's offer: who they are, where they sit in the world, and the
/// button that takes the job.
class _OfferCard extends StatelessWidget {
  const _OfferCard({
    required this.nation,
    required this.total,
    required this.onAccept,
  });

  final Nation nation;
  final int total;
  final VoidCallback onAccept;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return AppCard(
      onTap: onAccept,
      child: Row(
        children: [
          FlagDisc(nation.code, size: 48),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nation.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.titleMedium,
                ),
                const SizedBox(height: 2),
                Text(
                  l.bottomStartRankOf(nation.ranking, total),
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            l.bottomStartAccept.toUpperCase(),
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Icon(
            Icons.chevron_right,
            size: 18,
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
