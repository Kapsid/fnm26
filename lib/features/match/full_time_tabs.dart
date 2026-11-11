import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/core/util/caps.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/match/attendance.dart';
import 'package:fnm/domain/services/match/match_conditions.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/match_moments.dart';
import 'package:fnm/domain/services/match/stadium/ground_character.dart';
import 'package:fnm/domain/services/match/stadium/kick_off.dart';
import 'package:fnm/domain/services/match/stadium/match_weather.dart';
import 'package:fnm/domain/services/press/fan_mood.dart';
import 'package:fnm/features/match/conditions_note.dart';
import 'package:fnm/features/match/ground_card.dart';
import 'package:fnm/features/match/pitch/pitch_match_view.dart';
import 'package:fnm/features/match/pitch/pitch_view_providers.dart';
import 'package:fnm/features/match/pitch/stadium_painter.dart';
import 'package:fnm/features/y/fan_mood_text.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';

/// The two tabs the match screen adds once the match is over: the player of
/// the match, and the ground it was played in. Read-only: they show what the
/// result and the fixture already hold, and decide nothing.

/// What one player did in one match, read off the result: nothing here is
/// estimated. The shots, shots on target, saves and xG come from the
/// engine's moments and are null for a result that never recorded them (a
/// stored one), so the tab leaves them out rather than printing a zero.
typedef PlayerMatchLine = ({
  int goals,
  int assists,
  int minutes,
  int yellows,
  int reds,
  int? shots,
  int? onTarget,
  int? saves,
  double? xg,
});

/// [playerId]'s line in [r]. A player who came on is counted from the minute
/// he did, one who went off (a change, a red, a knock) to it. The whistle is at
/// 120 when extra time was played, at 90 otherwise (added time is not
/// counted, as a scoresheet does not count it).
PlayerMatchLine playerMatchLine(MatchResult r, int playerId) {
  final end = r.extraTime != null ? 120 : 90;
  var on = 0;
  var off = end;
  var goals = 0;
  var assists = 0;
  var yellows = 0;
  var reds = 0;
  for (final e in r.events) {
    switch (e.type) {
      case MatchEventType.goal:
        if (e.playerId == playerId && !e.ownGoal) goals++;
        if (e.assistPlayerId == playerId) assists++;
      case MatchEventType.substitution:
        if (e.playerId == playerId) on = e.minute;
        if (e.secondaryPlayerId == playerId && e.minute < off) off = e.minute;
      case MatchEventType.yellowCard:
        if (e.playerId == playerId) yellows++;
      case MatchEventType.redCard:
        if (e.playerId == playerId) {
          reds++;
          if (e.minute < off) off = e.minute;
        }
      case MatchEventType.injury:
        if (e.playerId == playerId && e.minute < off) off = e.minute;
    }
  }
  final shots = r.moments.whereType<ShotMoment>().toList();
  final recorded = shots.isNotEmpty;
  final his = [
    for (final s in shots)
      if (s.shooterId == playerId) s,
  ];
  return (
    goals: goals,
    assists: assists,
    minutes: (off - on).clamp(1, end),
    yellows: yellows,
    reds: reds,
    shots: recorded ? his.length : null,
    onTarget: recorded
        ? his
              .where(
                (s) =>
                    s.outcome == ShotOutcome.goal ||
                    s.outcome == ShotOutcome.saved,
              )
              .length
        : null,
    saves: recorded
        ? shots
              .where(
                (s) => s.keeperId == playerId && s.outcome == ShotOutcome.saved,
              )
              .length
        : null,
    xg: recorded ? his.fold<double>(0, (a, s) => a + s.xg) : null,
  );
}

/// The player's international record as it stood before this match: the
/// live screen shows a match not yet saved, so it is not counted in it.
final AutoDisposeFutureProviderFamily<
  PlayerCareerStats?,
  ({int careerId, int playerId})
>
potmCareerStatsProvider = FutureProvider.autoDispose
    .family<PlayerCareerStats?, ({int careerId, int playerId})>(
      (ref, a) => ref
          .watch(competitionRepositoryProvider)
          .playerCareerStats(a.careerId, a.playerId),
    );

/// The Player tab: the man of the match in the player page's silver header
/// card, the match he had, his record before it and the way to his page.
class PlayerOfMatchTab extends ConsumerWidget {
  const PlayerOfMatchTab({
    required this.result,
    required this.careerId,
    this.nationCode,
    this.nationName,
    this.age,
    this.onOpenPlayer,
    super.key,
  });

  static const Key emptyKey = Key('potm.empty');
  static const Key headerKey = Key('potm.header');
  static const Key careerKey = Key('potm.career');
  static const Key openKey = Key('potm.open');

  final MatchResult result;
  final int careerId;

  /// His nation's code and name (either side's man).
  final String? nationCode;
  final String? nationName;

  /// His age, when the screen has the player to hand.
  final int? age;

  /// Opens his page; null leaves the button out.
  final VoidCallback? onOpenPlayer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final motm = result.manOfTheMatch;
    if (motm == null) {
      return Center(
        key: emptyKey,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.star_outline_rounded,
                size: 32,
                color: AppColors.outline,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                l.matchPotmNone,
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }
    final line = playerMatchLine(result, motm.playerId);
    final keeper = motm.position == PlayerPosition.gk;
    final code = nationCode;
    final header = ProfileHeaderCard(
      key: headerKey,
      disc: motm.rating.toStringAsFixed(1),
      name: motm.playerName,
      meta: [
        if (code != null) ...[
          FlagDisc(code, size: 16),
          const SizedBox(width: AppSpacing.xs),
        ],
        Flexible(
          child: Text(
            nationName ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: profileMetaStyle,
          ),
        ),
        profileMetaDot(),
        Flexible(flex: 0, child: ProfileChip(motm.position.label)),
      ],
      // His age on a line of its own: beside the nation and the position it
      // ran out of room at a large text size on a narrow phone.
      notes: [
        if (age != null)
          Text(
            l.tacticsAgeOnly(age!),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: profileMetaStyle,
          ),
        Row(
          children: [
            const Icon(
              Icons.star_rounded,
              size: 16,
              color: AppColors.primary,
            ),
            const SizedBox(width: AppSpacing.xs),
            Flexible(
              child: Text(
                l.ratingPlayerOfTheMatch,
                style: profileMetaStyle.copyWith(color: AppColors.primary),
              ),
            ),
          ],
        ),
      ],
      stats: [
        if (keeper && line.saves != null)
          ProfileKeyStat.text('${line.saves}', label: l.matchStatSaves),
        ProfileKeyStat.text('${line.goals}', label: l.playerStatGoals),
        ProfileKeyStat.text('${line.assists}', label: l.playerStatAssists),
        if (!keeper && line.shots != null)
          ProfileKeyStat.text('${line.shots}', label: l.matchStatShots),
        ProfileKeyStat.text("${line.minutes}'", label: l.matchStatMinutes),
      ],
    );
    // The rest of his match, row by row, each only when it says something.
    final rows = <(String, String)>[
      if (!keeper && line.shots != null && line.shots! > 0) ...[
        (l.matchStatOnTarget, '${line.onTarget} / ${line.shots}'),
        ('xG', line.xg!.toStringAsFixed(2)),
      ],
      if (!keeper && line.saves != null && line.saves! > 0)
        (l.matchStatSaves, '${line.saves}'),
      if (line.yellows > 0) (l.matchStatYellowCards, '${line.yellows}'),
      if (line.reds > 0) (l.matchStatRedCards, '${line.reds}'),
    ];
    final career = ref
        .watch(
          potmCareerStatsProvider((
            careerId: careerId,
            playerId: motm.playerId,
          )),
        )
        .valueOrNull;
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.marginMobile),
      children: [
        header,
        if (rows.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          ProfileBlock(
            title: l.matchPotmHisMatch,
            child: Column(
              children: [for (final (k, v) in rows) _FactRow(k, v)],
            ),
          ),
        ],
        if (career != null) ...[
          const SizedBox(height: AppSpacing.md),
          ProfileBlock(
            key: careerKey,
            title: l.matchPotmBeforeMatch,
            child: Column(
              children: [
                _FactRow(l.playerStatCaps, '${career.caps}'),
                _FactRow(l.playerStatGoals, '${career.goals}'),
              ],
            ),
          ),
        ],
        if (onOpenPlayer != null) ...[
          const SizedBox(height: AppSpacing.md),
          Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton.icon(
              key: openKey,
              onPressed: onOpenPlayer,
              icon: const Icon(Icons.person_outline_rounded, size: 18),
              label: Text(l.paneFullProfile),
            ),
          ),
        ],
      ],
    );
  }
}

/// The Stadium tab: a still of the ground as the 2D TV draws it for this
/// match, its name and place, the seats and the crowd, the kick-off and the
/// weather with what they do, and whose ground it is.
///
/// Never names a landmark: the picture may show one, the copy does not.
class MatchStadiumTab extends StatelessWidget {
  const MatchStadiumTab({
    required this.ground,
    required this.neutral,
    this.groundNationCode,
    this.groundNationName,
    this.homeNationName,
    this.homeFans,
    this.kickOff,
    this.weather,
    this.conditions,
    this.playerIsHome = true,
    this.stadium,
    this.works = GroundWorks.none,
    super.key,
  });

  static const Key pictureKey = Key('stadium.picture');
  static const Key nameKey = Key('stadium.name');
  static const Key capacityKey = Key('stadium.capacity');
  static const Key attendanceKey = Key('stadium.attendance');
  static const Key fillKey = Key('stadium.fill');

  final MatchGround ground;
  final bool neutral;
  final String? groundNationCode;
  final String? groundNationName;

  /// The home side, named when the ground is its own (not neutral).
  final String? homeNationName;
  final FanMoodBand? homeFans;
  final KickOffTime? kickOff;
  final WeatherKind? weather;

  /// The altitude, heat and weather the match was played in, for the lines
  /// [ConditionsNote] writes.
  final MatchConditions? conditions;
  final bool playerIsHome;

  /// The ground as the Pitch view builds it for this fixture; null leaves
  /// the picture out.
  final PitchStadium? stadium;

  /// What the manager's federation has done to the ground.
  final GroundWorks works;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final fill = ground.capacity <= 0
        ? 0.0
        : (ground.attendance / ground.capacity).clamp(0.0, 1.0);
    final code = groundNationCode;
    final place = [ground.city, ?groundNationName].join(' · ');
    final notes = <(IconData, String)>[
      if (neutral)
        (Icons.balance_rounded, l.matchStadiumNeutral)
      else if (homeNationName != null)
        (Icons.home_outlined, l.matchStadiumHomeOf(homeNationName!)),
      if (works.built)
        (Icons.foundation_rounded, l.matchStadiumBuilt)
      else if (works.upgrades > 0)
        (Icons.add_business_outlined, l.matchStadiumEnlarged),
      if (works.underWay) (Icons.construction_rounded, l.matchStadiumWorks),
      if (ground.soldOut) (Icons.confirmation_number_outlined, l.matchSoldOut),
    ];
    final k = kickOff;
    final w = weather;
    final c = conditions;
    final conditionLines = <(IconData, String)>[
      if (k != null && w != null)
        (
          _weatherIcon(w),
          '${l.matchConditionsKickOff} ${k.label} · '
              '${GroundCard.weatherLabel(l, w)}',
        ),
      if (c != null)
        ...ConditionsNote.linesFor(l, c, playerIsHome: playerIsHome),
    ];
    final s = stadium;
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.marginMobile),
      children: [
        if (s != null) ...[
          ClipRRect(
            key: pictureKey,
            borderRadius: AppRadii.mdAll,
            child: AspectRatio(
              aspectRatio: _aspect,
              child: _GroundStill(stadium: s),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        ProfileBlock(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: code != null
                        ? FlagDisc(code, size: 22)
                        : const Icon(
                            Icons.stadium_outlined,
                            size: 22,
                            color: AppColors.onSurfaceVariant,
                          ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ground.stadium,
                          key: nameKey,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.headlineMedium.copyWith(
                            fontWeight: FontWeight.w800,
                            height: 1.15,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(place, style: profileMetaStyle),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              // Three across; in a column narrower than a phone (a
              // tablet's side column) or at a large text size one under
              // another, so no caption breaks inside a word.
              LayoutBuilder(
                builder: (context, c) {
                  final figures = [
                    (
                      capacityKey,
                      GroundCard.thousands(ground.capacity),
                      l.matchStadiumCapacity,
                    ),
                    (
                      attendanceKey,
                      GroundCard.thousands(ground.attendance),
                      l.matchStadiumAttendance,
                    ),
                    (fillKey, '${(fill * 100).round()}%', l.matchStadiumFull),
                  ];
                  if (c.maxWidth < _acrossFrom ||
                      MediaQuery.textScalerOf(context).scale(10) > 11.5) {
                    return Column(
                      children: [
                        for (final (key, value, label) in figures)
                          _FactRow(label, value, key: key),
                      ],
                    );
                  }
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final (key, value, label) in figures)
                        Expanded(
                          child: _Number(key: key, value: value, label: label),
                        ),
                    ],
                  );
                },
              ),
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
              if (homeFans case final band?) ...[
                const SizedBox(height: AppSpacing.sm),
                FanMoodRow(
                  band: band,
                  label: l.matchHomeFans(fanMoodLabel(l, band)),
                ),
              ],
              for (final (icon, text) in notes) ...[
                const SizedBox(height: AppSpacing.sm),
                _IconLine(icon, text),
              ],
            ],
          ),
        ),
        if (conditionLines.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          ProfileBlock(
            title: l.matchStadiumConditions,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final (i, (icon, text)) in conditionLines.indexed) ...[
                  if (i > 0) const SizedBox(height: AppSpacing.sm),
                  _IconLine(icon, text),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }

  /// The still's frame: the Pitch view's own, so the ground sits in it as
  /// it does on the 2D TV.
  static const double _aspect = 390 / 280;

  /// From this width the three figures sit side by side.
  static const double _acrossFrom = 250;

  static IconData _weatherIcon(WeatherKind w) => switch (w) {
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
  };
}

/// The ground with nobody on it, at kick-off's light: the Pitch view's own
/// [StadiumPainter], painted once (nothing in it moves).
class _GroundStill extends StatelessWidget {
  const _GroundStill({required this.stadium});

  final PitchStadium stadium;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, c) {
      final size = c.biggest;
      return RepaintBoundary(
        child: ColoredBox(
          color: const Color(0xFF0E1012),
          child: CustomPaint(
            size: size,
            painter: StadiumPainter(
              stadium.spec,
              PitchMatchView.projectionFor(size),
              light: stadium.lightAt(1),
              dressing: stadium.dressing,
            ),
          ),
        ),
      );
    },
  );
}

/// A figure over its caption, like the player header's key numbers.
class _Number extends StatelessWidget {
  const _Number({required this.value, required this.label, super.key});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    return Column(
      children: [
        Text(
          value,
          maxLines: 1,
          softWrap: false,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.titleMedium.copyWith(
            fontWeight: FontWeight.w700,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label.capsIn(lang),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: profileCaptionStyle.copyWith(fontSize: 10),
        ),
      ],
    );
  }
}

/// A fact as a name and its figure on one row.
class _FactRow extends StatelessWidget {
  const _FactRow(this.label, this.value, {super.key});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          value,
          style: AppTypography.bodyMedium.copyWith(
            fontWeight: FontWeight.w700,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    ),
  );
}

/// A line of text behind its icon, wrapping under itself.
class _IconLine extends StatelessWidget {
  const _IconLine(this.icon, this.text);

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, size: 16, color: AppColors.onSurfaceVariant),
      const SizedBox(width: AppSpacing.sm),
      Expanded(
        child: Text(
          text,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ),
    ],
  );
}
