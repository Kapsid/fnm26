import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/services/competition/venues.dart';
import 'package:fnm/shared/widgets/widgets.dart';

/// The host nation and its tournament cities/stadiums.
class VenuesCard extends StatelessWidget {
  const VenuesCard({
    required this.hostCode,
    required this.hostName,
    required this.venues,
    super.key,
  });

  final String hostCode;
  final String hostName;
  final List<Venue> venues;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FlagDisc(hostCode, size: 28, highlighted: true),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('HOSTS',
                        style: AppTypography.labelSmall
                            .copyWith(color: AppColors.primary)),
                    Text(hostName, style: AppTypography.titleMedium),
                  ],
                ),
              ),
              const Icon(
                Icons.stadium,
                size: 20,
                color: AppColors.onSurfaceVariant,
              ),
            ],
          ),
          const Divider(height: AppSpacing.md),
          Text(
            'VENUES',
            style:
                AppTypography.labelSmall.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: AppSpacing.xs),
          for (final v in venues)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  const Icon(
                    Icons.place_outlined,
                    size: 16,
                    color: AppColors.onSurfaceVariant,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      v.stadium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodyMedium,
                    ),
                  ),
                  Text(
                    v.city,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
