import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/services/match/attendance.dart';
import 'package:fnm/domain/services/match/stadium/kick_off.dart';
import 'package:fnm/domain/services/match/stadium/match_weather.dart';
import 'package:fnm/domain/services/press/fan_mood.dart';
import 'package:fnm/features/y/fan_mood_text.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';

/// Where the match is played and who turned up: the ground, its city, and the
/// crowd against the stadium's capacity.
///
/// The crowd is not decoration — how full the ground is scales whatever home
/// advantage applies (see [Attendance.atmosphere]), so a sell-out is worth
/// something and a half-empty friendly is not.
class GroundCard extends StatelessWidget {
  const GroundCard({
    required this.ground,
    this.compact = false,
    this.neutral = false,
    this.groundNationCode,
    this.fans,
    this.kickOff,
    this.weather,
    super.key,
  });

  /// The key of the kick-off and weather line.
  static const Key conditionsKey = Key('ground.kickOffWeather');

  /// When the match kicks off, local time at the ground, and the weather it
  /// is played in: the 2D TV's own (see `matchConditionsShown`). Null
  /// draws no line.
  final KickOffTime? kickOff;
  final WeatherKind? weather;

  final MatchGround ground;

  /// A single line, for the pre-match preview where space is tight.
  final bool compact;

  /// Whether the tie is played on neutral ground (a finals match at the
  /// tournament host). Worth stating: it is the difference between a home
  /// crowd behind the side and a stadium that belongs to neither team.
  final bool neutral;

  /// The country the ground is in, for its flag — the tournament host at a
  /// neutral finals, the home nation otherwise.
  final String? groundNationCode;

  /// How the home supporters feel, at a home game of the manager's own side:
  /// the reason the ground is as full (or as empty) as it is. Null anywhere
  /// else, and then nothing is drawn.
  final FanMoodBand? fans;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final fill = ground.capacity <= 0
        ? 0.0
        : (ground.attendance / ground.capacity).clamp(0.0, 1.0);
    final code = groundNationCode;
    Widget badge(String text, Color color) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: AppRadii.smAll,
      ),
      child: Text(
        text,
        style: AppTypography.labelSmall.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 9,
        ),
      ),
    );
    final badges = [
      if (neutral) badge(l.matchNeutralGround, AppColors.primary),
      if (ground.soldOut) badge(l.matchSoldOut, AppColors.positive),
    ];
    final line = Row(
      children: [
        if (code != null)
          FlagDisc(code, size: 16)
        else
          const Icon(
            Icons.stadium_outlined,
            size: 16,
            color: AppColors.onSurfaceVariant,
          ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          // Ground and city together run long, and half a stadium name is not
          // a place. It gives way by shrinking, not by being cut.
          child: WholeText(
            '${ground.stadium} · ${ground.city}',
            maxLines: 1,
            style: AppTypography.labelMedium,
          ),
        ),
        // The full card says "X of Y seats filled" under the bar, so the
        // crowd figure beside the name only repeated it and squeezed the
        // stadium name. Only the compact line, which has no bar, keeps it.
        if (compact) ...[
          const SizedBox(width: AppSpacing.sm),
          Text(
            _thousands(ground.attendance),
            style: AppTypography.labelMedium.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ],
    );
    // The badges (neutral ground, sold out) sit on a line of their own under
    // the name and wrap: beside it, both together overflowed a 360-wide phone
    // at the largest text size in the long languages.
    final crowd = badges.isEmpty
        ? line
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              line,
              const SizedBox(height: AppSpacing.xs),
              Padding(
                padding: const EdgeInsets.only(left: 16 + AppSpacing.sm),
                child: Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: badges,
                ),
              ),
            ],
          );
    final kickOff = this.kickOff;
    final weather = this.weather;
    final Widget? conditions = kickOff == null || weather == null
        ? null
        : Row(
            key: conditionsKey,
            children: [
              Icon(
                switch (weather) {
                  WeatherKind.clear => Icons.wb_sunny_rounded,
                  WeatherKind.rain => Icons.umbrella_rounded,
                  WeatherKind.snow => Icons.ac_unit_rounded,
                  WeatherKind.haze => Icons.blur_on_rounded,
                  WeatherKind.heavyRain => Icons.water_drop_rounded,
                  WeatherKind.thunderstorm => Icons.thunderstorm_rounded,
                  WeatherKind.fog => Icons.foggy,
                  WeatherKind.windy => Icons.air_rounded,
                  WeatherKind.dustStorm => Icons.grain_rounded,
                  WeatherKind.frostyNight => Icons.severe_cold_rounded,
                },
                size: 16,
                color: AppColors.onSurfaceVariant,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: WholeText(
                  '${l.matchConditionsKickOff} ${kickOff.label} · '
                  '${weatherLabel(l, weather)}',
                  maxLines: 1,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          );
    final band = fans;
    final mood = band == null
        ? null
        : FanMoodRow(
            band: band,
            label: l.matchHomeFans(fanMoodLabel(l, band)),
          );
    if (compact) {
      if (mood == null && conditions == null) return crowd;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          crowd,
          if (conditions != null) ...[
            const SizedBox(height: AppSpacing.xs),
            conditions,
          ],
          if (mood != null) ...[
            const SizedBox(height: AppSpacing.xs),
            mood,
          ],
        ],
      );
    }
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          crowd,
          if (conditions != null) ...[
            const SizedBox(height: AppSpacing.xs),
            conditions,
          ],
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: AppRadii.smAll,
            child: LinearProgressIndicator(
              value: fill,
              minHeight: 5,
              backgroundColor: AppColors.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(
                fill >= 0.95 ? AppColors.positive : AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            l.matchAttendanceOf(
              _thousands(ground.attendance),
              _thousands(ground.capacity),
            ),
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          if (mood != null) ...[
            const SizedBox(height: AppSpacing.sm),
            mood,
          ],
        ],
      ),
    );
  }

  /// The weather, in a word.
  static String weatherLabel(AppLocalizations l, WeatherKind w) => switch (w) {
    WeatherKind.clear => l.matchWeatherClear,
    WeatherKind.rain => l.matchWeatherRain,
    WeatherKind.snow => l.matchWeatherSnow,
    WeatherKind.haze => l.matchWeatherHaze,
    WeatherKind.heavyRain => l.matchWeatherHeavyRain,
    WeatherKind.thunderstorm => l.matchWeatherThunderstorm,
    WeatherKind.fog => l.matchWeatherFog,
    WeatherKind.windy => l.matchWeatherWindy,
    WeatherKind.dustStorm => l.matchWeatherDustStorm,
    WeatherKind.frostyNight => l.matchWeatherFrostyNight,
  };

  /// `62431` → `62,431`.
  static String _thousands(int v) {
    final s = '$v';
    final out = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) out.write(',');
      out.write(s[i]);
    }
    return out.toString();
  }
}

/// The ground as one line for the tablet 2D TV's header band: the flag, the
/// stadium and its city, the kick-off and the weather, the crowd against the
/// capacity with a small fill bar, and the home fans' mood. The same facts
/// as [GroundCard], at the width of the picture.
class GroundStrip extends StatelessWidget {
  const GroundStrip({
    required this.ground,
    this.neutral = false,
    this.groundNationCode,
    this.fans,
    this.kickOff,
    this.weather,
    super.key,
  });

  /// The key of the strip.
  static const Key stripKey = Key('ground.strip');

  final MatchGround ground;
  final bool neutral;
  final String? groundNationCode;
  final FanMoodBand? fans;
  final KickOffTime? kickOff;
  final WeatherKind? weather;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final fill = ground.capacity <= 0
        ? 0.0
        : (ground.attendance / ground.capacity).clamp(0.0, 1.0);
    final kickOff = this.kickOff;
    final weather = this.weather;
    final place = [
      '${ground.stadium} · ${ground.city}',
      if (neutral) l.matchNeutralGround,
      if (kickOff != null) '${l.matchConditionsKickOff} ${kickOff.label}',
      if (weather != null) GroundCard.weatherLabel(l, weather),
    ].join(' · ');
    // The sans, not the mono: a whole line of facts in the header's width.
    final style = AppTypography.bodySmall.copyWith(
      color: AppColors.onSurfaceVariant,
      fontSize: 12,
      height: 1,
    );
    final code = groundNationCode;
    final band = fans;
    return Row(
      key: stripKey,
      children: [
        if (code != null)
          FlagDisc(code, size: 14)
        else
          const Icon(
            Icons.stadium_outlined,
            size: 14,
            color: AppColors.onSurfaceVariant,
          ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: WholeText(place, maxLines: 1, style: style),
        ),
        const SizedBox(width: AppSpacing.sm),
        SizedBox(
          width: 44,
          height: 4,
          child: ClipRRect(
            borderRadius: AppRadii.smAll,
            child: LinearProgressIndicator(
              value: fill,
              minHeight: 4,
              backgroundColor: AppColors.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(
                fill >= 0.95 ? AppColors.positive : AppColors.primary,
              ),
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '${GroundCard._thousands(ground.attendance)} / '
          '${GroundCard._thousands(ground.capacity)}',
          maxLines: 1,
          softWrap: false,
          style: style.copyWith(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w700,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        if (band != null) ...[
          Text(' · ', style: style),
          Text(
            l.matchHomeFans(fanMoodLabel(l, band)),
            maxLines: 1,
            softWrap: false,
            style: style,
          ),
        ],
      ],
    );
  }
}
