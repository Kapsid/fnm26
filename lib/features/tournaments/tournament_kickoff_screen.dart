import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/competition/continental_cups.dart';
import 'package:fnm/domain/services/competition/hosts.dart';
import 'package:fnm/domain/services/competition/trophies.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

/// Which tournament a kickoff ceremony is for: the World Cup ([conf] == null)
/// or a continental championship (the named confederation's cup).
typedef KickoffArg = ({int careerId, Confederation? conf});

/// A tournament's opening-ceremony details — its name, year, trophy artwork and
/// host nation(s) — regardless of whether the manager is in the finals.
typedef KickoffData = ({
  String title,
  int year,
  String trophyAsset,
  List<String> hostCodes,
  List<String> hostNames,
});

/// The opening-ceremony details for the cycle's World Cup or a continental cup.
/// A continental edition ([arg.conf] set) pulls its name, trophy and hosts from
/// that confederation; otherwise it's the World Cup.
final AutoDisposeFutureProviderFamily<KickoffData?, KickoffArg>
tournamentKickoffProvider = FutureProvider.autoDispose
    .family<KickoffData?, KickoffArg>((ref, arg) async {
      await ref.watch(seedLoaderProvider).ensureSeeded();
      final career = await ref
          .watch(careerRepositoryProvider)
          .byId(arg.careerId);
      if (career == null) return null;
      final allNations = await ref.watch(nationRepositoryProvider).all();
      final byId = {for (final n in allNations) n.id: n};

      final String title;
      final int year;
      final String trophy;
      final List<int> hosts;
      final conf = arg.conf;
      if (conf == null) {
        title = 'WORLD CUP';
        year = CareerService.worldCupYear(career.cyclePointer);
        trophy = Trophies.worldCup;
        hosts = WorldCupHosts.hostsFor(
          year: year,
          nations: allNations,
          seed: career.rngSeed,
        );
      } else {
        title =
            (ContinentalCups.byConfederation[conf]?.name ?? 'CONTINENTAL CUP')
                .toUpperCase();
        // Continental finals sit two years off the World Cup in the cycle.
        year = CareerService.worldCupYear(career.cyclePointer) - 2;
        trophy = Trophies.forConfederation(conf);
        hosts = WorldCupHosts.continentalHostsFor(
          confederation: conf,
          cycle: career.cyclePointer,
          seed: career.rngSeed,
          nations: allNations,
        );
      }
      return (
        title: title,
        year: year,
        trophyAsset: trophy,
        hostCodes: [
          for (final h in hosts)
            if (byId[h] != null) byId[h]!.code,
        ],
        hostNames: [
          for (final h in hosts)
            if (byId[h] != null) byId[h]!.name,
        ],
      );
    });

/// A one-shot ceremony screen shown as a hub event when a finals tournament
/// kicks off: an animated trophy and host reveal, for the World Cup and every
/// continental championship alike. "Let the finals begin" marks it watched (so
/// it fires once) and opens the tournament.
class TournamentKickoffScreen extends ConsumerWidget {
  const TournamentKickoffScreen({required this.careerId, this.conf, super.key});

  final int careerId;

  /// The confederation whose cup is kicking off, or null for the World Cup.
  final Confederation? conf;

  Future<void> _begin(BuildContext context, WidgetRef ref) async {
    final career = await ref.read(careerRepositoryProvider).byId(careerId);
    if (career != null) {
      await ref
          .read(competitionRepositoryProvider)
          .markDrawWatched(
            careerId,
            career.cyclePointer,
            conf == null ? worldCupKickoffKind : continentalKickoffKind,
          );
    }
    if (!context.mounted) return;
    // Just close back to the hub — the ceremony was the last thing before the
    // opening match, so the hub's next event is the player's first finals game.
    context.go('${Routes.hub}?careerId=$careerId');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final async = ref.watch(
      tournamentKickoffProvider((careerId: careerId, conf: conf)),
    );
    return Scaffold(
      body: SafeArea(
        child: async.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => Center(child: Text(l.tourSharedCouldNotLoad)),
          data: (data) {
            final hostLabel = data == null || data.hostNames.isEmpty
                ? l.tourSharedHostTbc
                : data.hostNames.join('  ·  ').toUpperCase();
            final title = data == null ? '' : '${data.title} ${data.year}';
            return Column(
              children: [
                Expanded(
                  child: Center(
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 1100),
                      curve: Curves.easeOutBack,
                      builder: (context, t, child) {
                        final c = t.clamp(0.0, 1.0);
                        return Opacity(
                          opacity: c,
                          child: Transform.scale(
                            scale: 0.55 + 0.45 * c,
                            child: child,
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.xl),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              title,
                              textAlign: TextAlign.center,
                              style: AppTypography.labelMedium.copyWith(
                                color: AppColors.primary,
                                letterSpacing: 3,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            Image.asset(
                              data?.trophyAsset ?? Trophies.worldCup,
                              height: 220,
                              fit: BoxFit.contain,
                              errorBuilder: (_, _, _) => const Icon(
                                Icons.emoji_events,
                                size: 140,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            Text(
                              'THE FINALS ARE HERE',
                              style: AppTypography.headlineMedium.copyWith(
                                color: AppColors.onSurface,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            if (data != null && data.hostCodes.isNotEmpty)
                              Wrap(
                                alignment: WrapAlignment.center,
                                spacing: AppSpacing.sm,
                                children: [
                                  for (final c in data.hostCodes)
                                    FlagDisc(c, size: 30),
                                ],
                              ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              'HOSTED BY  $hostLabel',
                              textAlign: TextAlign.center,
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.marginMobile),
                  child: PrimaryButton(
                    label: l.tourSharedLetFinalsBegin,
                    icon: Icons.sports_soccer,
                    onPressed: () => _begin(context, ref),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
