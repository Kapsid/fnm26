import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/services/squad/training_camp.dart';
import 'package:fnm/features/squad/training_camp_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

/// Choosing the squad's base camp for a tournament — where they will live for
/// the month, in the host country.
///
/// A real preparation decision with no right answer: a base in the middle of
/// the host's biggest city means no travel but no peace; a lodge up in the
/// hills gets knocks turned round quickly and costs a coach ride to every
/// match. Each option states its trade plainly, because the trade IS the
/// choice.
class TrainingCampScreen extends ConsumerWidget {
  const TrainingCampScreen({required this.careerId, super.key});

  final int careerId;

  String _exit() => '${Routes.hub}?careerId=$careerId';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final planAsync = ref.watch(trainingCampPlanProvider(careerId));
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(l.campTitle, style: AppTypography.titleMedium),
        centerTitle: true,
      ),
      body: planAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l.hubCouldNotLoad('$e'))),
        data: (plan) {
          if (plan == null) {
            // Nothing to decide (the tournament has started, or the nation
            // isn't in one) — don't strand the manager on a blank screen.
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: PrimaryButton(
                  label: l.hubContinue,
                  icon: Icons.arrow_forward_rounded,
                  onPressed: () => context.go(_exit()),
                ),
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            children: [
              AppCard(
                child: Row(
                  children: [
                    FlagDisc(plan.hostCode, size: 34),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            // Every host country, not just the primary one —
                            // the squad may be based in any of them.
                            l.campBasedIn(plan.hostNames.join(' · ')),
                            style: AppTypography.titleMedium,
                          ),
                          Text(
                            l.campBlurb,
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              for (final option in plan.options)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _CampCard(
                    camp: option.camp,
                    // The country is part of the choice when the tournament is
                    // shared, so every card wears its flag.
                    countryCode:
                        plan.hostNames.length > 1 ? option.hostCode : null,
                    countryName:
                        plan.hostNames.length > 1 ? option.hostName : null,
                    selected: plan.isChosen(option),
                    onTap: () async {
                      await ref
                          .read(trainingCampServiceProvider)
                          .choose(careerId, plan, option);
                      if (context.mounted) context.go(_exit());
                    },
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

/// One camp on offer: where it is, what it feels like, and its three effects.
class _CampCard extends StatelessWidget {
  const _CampCard({
    required this.camp,
    required this.selected,
    required this.onTap,
    this.countryCode,
    this.countryName,
  });

  final TrainingCamp camp;
  final bool selected;
  final VoidCallback onTap;

  /// The host country this camp is in — shown only when the tournament is
  /// shared and the country is therefore part of the decision.
  final String? countryCode;
  final String? countryName;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return AppCard(
      onTap: onTap,
      color: selected ? AppColors.secondaryContainer : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (countryCode != null)
                FlagDisc(countryCode!, size: 24)
              else
                Icon(_icon(camp.terrain), size: 20, color: AppColors.primary),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(camp.name, style: AppTypography.titleMedium),
                    Text(
                      countryName == null
                          ? _terrainLabel(l, camp.terrain)
                          : '$countryName · ${_terrainLabel(l, camp.terrain)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (selected)
                const Icon(
                  Icons.check_circle,
                  size: 20,
                  color: AppColors.primary,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            _terrainBlurb(l, camp.terrain),
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.xs,
            children: [
              // Less travel fatigue is good, so the sign is flipped for the
              // reader: what they care about is the effect on their players.
              _Effect(
                label: l.campEffectTravel,
                value: -_percent(camp.travelFatigue),
              ),
              _Effect(
                label: l.campEffectRecovery,
                value: _percent(camp.injuryRecovery),
              ),
              _Effect(
                label: l.campEffectSharpness,
                value: camp.conditionBonus,
                suffix: '',
              ),
            ],
          ),
        ],
      ),
    );
  }

  static int _percent(double factor) => ((factor - 1) * 100).round();

  static IconData _icon(CampTerrain t) => switch (t) {
    CampTerrain.cityCentre => Icons.location_city_rounded,
    CampTerrain.coastal => Icons.beach_access_rounded,
    CampTerrain.mountain => Icons.landscape_rounded,
    CampTerrain.altitude => Icons.filter_hdr_rounded,
    CampTerrain.nationalCentre => Icons.fitness_center_rounded,
  };

  static String _terrainLabel(AppLocalizations l, CampTerrain t) => switch (t) {
    CampTerrain.cityCentre => l.campTerrainCity,
    CampTerrain.coastal => l.campTerrainCoastal,
    CampTerrain.mountain => l.campTerrainMountain,
    CampTerrain.altitude => l.campTerrainAltitude,
    CampTerrain.nationalCentre => l.campTerrainNationalCentre,
  };

  static String _terrainBlurb(AppLocalizations l, CampTerrain t) => switch (t) {
    CampTerrain.cityCentre => l.campTerrainCityBlurb,
    CampTerrain.coastal => l.campTerrainCoastalBlurb,
    CampTerrain.mountain => l.campTerrainMountainBlurb,
    CampTerrain.altitude => l.campTerrainAltitudeBlurb,
    CampTerrain.nationalCentre => l.campTerrainNationalCentreBlurb,
  };
}

/// One effect chip: a signed figure, green when it helps and red when it costs.
class _Effect extends StatelessWidget {
  const _Effect({
    required this.label,
    required this.value,
    this.suffix = '%',
  });

  final String label;
  final int value;
  final String suffix;

  @override
  Widget build(BuildContext context) {
    if (value == 0) return const SizedBox.shrink();
    final good = value > 0;
    final color = good ? AppColors.positive : AppColors.error;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: AppRadii.smAll,
      ),
      child: Text(
        '$label ${good ? '+' : ''}$value$suffix',
        style: AppTypography.labelSmall.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
