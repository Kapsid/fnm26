import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/services/competition/venues.dart';
import 'package:fnm/shared/widgets/widgets.dart';

/// One host country and the grounds it stages the tournament in.
typedef HostVenues = ({String code, String name, List<Venue> venues});

/// The host nation(s) and their tournament cities/stadiums.
///
/// Takes every host rather than one: a co-hosted tournament is played across
/// all of them, and showing a single country's grounds under a "HOSTS" heading
/// simply loses the others.
class VenuesCard extends StatelessWidget {
  const VenuesCard({required this.hosts, super.key});

  final List<HostVenues> hosts;

  /// "58,000" from 58000 — a thousands-separated seat count.
  static String _capacity(int seats) {
    final s = seats.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }

  @override
  Widget build(BuildContext context) {
    if (hosts.isEmpty) return const SizedBox.shrink();
    final joint = hosts.length > 1;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              for (final h in hosts) ...[
                FlagDisc(h.code, size: 28, highlighted: true),
                const SizedBox(width: AppSpacing.xs),
              ],
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      joint ? 'CO-HOSTS' : 'HOST',
                      style: AppTypography.labelSmall
                          .copyWith(color: AppColors.primary),
                    ),
                    Text(
                      hosts.map((h) => h.name).join(' & '),
                      style: AppTypography.titleMedium,
                    ),
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
            style: AppTypography.labelSmall.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: AppSpacing.xs),
          for (final h in hosts) ...[
            // Only worth naming the country when there's more than one.
            if (joint) ...[
              const SizedBox(height: AppSpacing.xs),
              Row(
                children: [
                  FlagDisc(h.code, size: 14),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    h.name.toUpperCase(),
                    style: AppTypography.labelSmall
                        .copyWith(color: AppColors.onSurfaceVariant),
                  ),
                ],
              ),
            ],
            for (final v in h.venues) _venueRow(v),
          ],
        ],
      ),
    );
  }

  Widget _venueRow(Venue v) => Padding(
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    v.stadium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodyMedium,
                  ),
                  Text(
                    '${v.city} · ${_capacity(v.capacity)} seats',
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
