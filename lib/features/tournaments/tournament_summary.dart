import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/services/competition/tournament_identity.dart';
import 'package:fnm/domain/services/competition/venues.dart';
import 'package:fnm/features/tournaments/tournament_history.dart';
import 'package:fnm/features/tournaments/venues_card.dart';

/// The tournament "summary" tab: the host nation(s), their cities and stadiums,
/// and the edition's mascot and match ball. Shared by the World Cup and the
/// continental cups so the host/venue detail lives in one place rather than
/// crowding the finals groups.
class TournamentSummaryTab extends StatelessWidget {
  const TournamentSummaryTab({
    required this.hostIds,
    required this.hostCities,
    required this.code,
    required this.name,
    this.identity,
    this.trophyAsset,
    super.key,
  });

  final List<int> hostIds;
  final Map<int, List<String>> hostCities;
  final TournamentIdentity? identity;

  /// This competition's trophy artwork, shown at the top of the summary.
  final String? trophyAsset;
  final String Function(int) code;
  final String Function(int) name;

  @override
  Widget build(BuildContext context) {
    final trophy = trophyAsset;
    if (hostIds.isEmpty) {
      return ListView(
        padding: const EdgeInsets.all(AppSpacing.marginMobile),
        children: [
          if (trophy != null) _TrophyBanner(asset: trophy),
          const TournamentSoon(
            message:
                'The host and its stadiums appear once this edition is drawn.',
          ),
        ],
      );
    }
    final byHost = VenueGenerator.forHosts(
      hostIds: hostIds,
      citiesByHost: hostCities,
    );
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.marginMobile),
      children: [
        if (trophy != null) ...[
          _TrophyBanner(asset: trophy),
          const SizedBox(height: AppSpacing.md),
        ],
        Text(
          hostIds.length == 1 ? 'HOST' : 'HOSTS',
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        const SizedBox(height: AppSpacing.sm),
        VenuesCard(
          hosts: [
            for (final h in hostIds)
              (code: code(h), name: name(h), venues: byHost[h] ?? const []),
          ],
          mascot: identity?.mascot,
          ball: identity?.ball,
        ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}

/// The competition's trophy, centred at the top of the summary.
class _TrophyBanner extends StatelessWidget {
  const _TrophyBanner({required this.asset});

  final String asset;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        asset,
        height: 180,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
      ),
    );
  }
}
