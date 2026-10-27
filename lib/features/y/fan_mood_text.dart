import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/services/press/fan_mood.dart';
import 'package:fnm/features/federation/national_stadium_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

/// The word for a [FanMoodBand].
String fanMoodLabel(AppLocalizations l, FanMoodBand band) => switch (band) {
  FanMoodBand.furious => l.fanMoodFurious,
  FanMoodBand.restless => l.fanMoodRestless,
  FanMoodBand.neutral => l.fanMoodCalm,
  FanMoodBand.warm => l.fanMoodUpbeat,
  FanMoodBand.euphoric => l.fanMoodEuphoric,
};

/// The colour a [FanMoodBand] is drawn in.
Color fanMoodColor(FanMoodBand band) => switch (band) {
  FanMoodBand.furious => AppColors.ratingPoor,
  FanMoodBand.restless => AppColors.warning,
  FanMoodBand.neutral => AppColors.onSurfaceVariant,
  FanMoodBand.warm || FanMoodBand.euphoric => AppColors.positive,
};

/// The icon a [FanMoodBand] is drawn with.
IconData fanMoodIcon(FanMoodBand band) => switch (band) {
  FanMoodBand.furious => Icons.sentiment_very_dissatisfied,
  FanMoodBand.restless => Icons.sentiment_dissatisfied,
  FanMoodBand.neutral => Icons.sentiment_neutral,
  FanMoodBand.warm => Icons.sentiment_satisfied,
  FanMoodBand.euphoric => Icons.sentiment_very_satisfied,
};

/// [label] beside its band's icon, in its band's colour, wrapping rather than
/// overflowing in a long language.
class FanMoodRow extends StatelessWidget {
  const FanMoodRow({
    required this.band,
    required this.label,
    this.detail,
    super.key,
  });

  final FanMoodBand band;
  final String label;

  /// A second, quieter line under it (what the mood does to the money).
  final String? detail;

  @override
  Widget build(BuildContext context) {
    final color = fanMoodColor(band);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(fanMoodIcon(band), size: 16, color: color),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTypography.labelMedium.copyWith(color: color),
              ),
              if (detail != null)
                Text(
                  detail!,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// The supporters' mood today and what it REALLY does to the stadium income
/// paid at the next rollover (after the grant cap, on the estate as it
/// stands: see [stadiumMoodEffectProvider]), for the finances screen. The
/// income line is left out when the mood changes nothing. Nothing at all
/// while it loads or fails: it is a footnote.
class FanMoodLine extends ConsumerWidget {
  const FanMoodLine({required this.careerId, super.key});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final effect = ref.watch(stadiumMoodEffectProvider(careerId)).valueOrNull;
    if (effect == null) return const SizedBox.shrink();
    final l = AppLocalizations.of(context);
    return FanMoodRow(
      band: effect.band,
      label: l.federationFans(fanMoodLabel(l, effect.band)),
      detail: effect.percent == 0
          ? null
          : l.federationFansIncome(signedPercent(effect.percent, l.localeName)),
    );
  }
}

/// [percent] as a signed percentage in [locale]'s own format: "+10%" in
/// English, "+10 %" in French, "+%10" in Turkish.
String signedPercent(int percent, String locale) {
  String formatted;
  try {
    formatted = NumberFormat.percentPattern(locale).format(percent / 100);
  } on Object {
    formatted = '$percent%';
  }
  return percent > 0 ? '+$formatted' : formatted;
}
