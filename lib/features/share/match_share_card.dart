import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/features/match/score_bug_theme.dart';
import 'package:fnm/features/share/share_card_kit.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// One side of a match, as the share card shows it.
@immutable
class ShareSide {
  const ShareSide({
    required this.name,
    required this.code,
    required this.color,
    required this.goals,
  });

  /// The nation's name, already in the manager's language.
  final String name;

  /// FIFA code, for the flag.
  final String code;

  /// The nation's colour: lights its half of the card.
  final Color color;
  final int goals;
}

/// A goal on the share card.
@immutable
class ShareGoal {
  const ShareGoal({
    required this.scorer,
    required this.minute,
    required this.home,
    this.stoppage = 0,
    this.penalty = false,
  });

  final String scorer;
  final int minute;
  final int stoppage;
  final bool home;
  final bool penalty;

  String get minuteLabel => stoppage > 0 ? "$minute+$stoppage'" : "$minute'";
}

/// The man of the match on the share card.
@immutable
class ShareStar {
  const ShareStar({
    required this.name,
    required this.code,
    required this.rating,
  });

  final String name;

  /// His nation's FIFA code.
  final String code;
  final double rating;
}

/// Everything the match share card shows. Every string arrives ready to
/// print (translated, formatted); the card only lays it out.
@immutable
class MatchShareData {
  const MatchShareData({
    required this.home,
    required this.away,
    required this.competition,
    required this.dateLabel,
    this.round,
    this.venue,
    this.trophyAsset,
    this.trophyImage,
    this.plateTheme,
    this.extraTime = false,
    this.homePens,
    this.awayPens,
    this.goals = const [],
    this.star,
    this.homePossession,
    this.homeShots,
    this.awayShots,
  });

  final ShareSide home;
  final ShareSide away;

  /// The competition's name, e.g. "World Championship".
  final String competition;

  /// The round, e.g. "Final" or "Group B". Null for a friendly.
  final String? round;

  /// The date, already formatted for the manager's language.
  final String dateLabel;

  /// The ground and city, e.g. "Estadio Azteca, Mexico City".
  final String? venue;

  /// The competition's trophy artwork (see `Trophies`), or null.
  final String? trophyAsset;

  /// The career world's own picture of that trophy (a custom world), drawn
  /// in place of [trophyAsset]; null for the bundled artwork.
  final Uint8List? trophyImage;

  /// The score bug's tournament colours (a finals match), or null for the
  /// plain silver plate.
  final ScoreBugTheme? plateTheme;

  final bool extraTime;
  final int? homePens;
  final int? awayPens;
  final List<ShareGoal> goals;
  final ShareStar? star;

  /// Home side's share of the ball, 0 to 100.
  final int? homePossession;
  final int? homeShots;
  final int? awayShots;

  bool get penalties => homePens != null && awayPens != null;
}

/// The match result as a poster, for sharing to Instagram: both nations'
/// flags around the score, the competition at the top, the scorers below,
/// the man of the match and a line of stats, and the brand at the foot.
///
/// Pure: everything comes in through [data]; no providers.
class MatchShareCard extends StatelessWidget {
  const MatchShareCard({required this.data, required this.format, super.key});

  final MatchShareData data;
  final ShareFormat format;

  @override
  Widget build(BuildContext context) {
    final story = format.isStory;
    final accent = data.plateTheme?.accent ?? AppColors.primary;
    return ShareCanvas(
      format: format,
      child: ShareBackdrop(
        leftGlow: data.home.color,
        rightGlow: data.away.color,
        child: Padding(
          padding: format.contentInsets,
          child: Column(
            children: [
              _Header(data: data, story: story, accent: accent),
              SizedBox(height: story ? 28 : 22),
              const Spacer(),
              _Scoreline(data: data, story: story, accent: accent),
              SizedBox(height: story ? 32 : 26),
              if (data.goals.isNotEmpty) _Scorers(data: data, story: story),
              const Spacer(),
              SizedBox(height: story ? 28 : 18),
              if (data.star != null ||
                  data.homePossession != null ||
                  data.homeShots != null)
                _Footer(data: data, story: story),
              SizedBox(height: story ? 44 : 22),
              ShareWatermark(format: format),
              SizedBox(height: story ? 0 : 34),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.data,
    required this.story,
    required this.accent,
  });

  final MatchShareData data;
  final bool story;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final trophy = data.trophyAsset;
    final meta = [data.dateLabel, ?data.venue].join('  ·  ');
    return Column(
      children: [
        if (trophy != null) ...[
          ShareTrophyArt(
            asset: trophy,
            custom: data.trophyImage,
            height: story ? 176 : 96,
          ),
          SizedBox(height: story ? 22 : 12),
        ],
        ShareFitText(
          data.competition.toUpperCase(),
          style: AppTypography.displayLarge.copyWith(
            fontSize: story ? 50 : 40,
            height: 1.1,
            letterSpacing: story ? 7 : 6,
            fontWeight: FontWeight.w800,
            color: AppColors.onSurface,
          ),
          minSize: 26,
        ),
        if (data.round case final round?) ...[
          SizedBox(height: story ? 12 : 8),
          ShareCaption(round, color: accent, size: story ? 28 : 24),
        ],
        SizedBox(height: story ? 18 : 12),
        ShareFitText(
          meta,
          style: AppTypography.bodyMedium.copyWith(
            fontSize: story ? 26 : 22,
            height: 1.2,
            color: AppColors.outline,
          ),
          minSize: 16,
        ),
      ],
    );
  }
}

class _Scoreline extends StatelessWidget {
  const _Scoreline({
    required this.data,
    required this.story,
    required this.accent,
  });

  final MatchShareData data;
  final bool story;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final flag = story ? 256.0 : 188.0;
    final status = data.extraTime
        ? l.matchClockAfterExtraTime
        : l.matchClockFullTime;
    Widget side(ShareSide s, ShareSide other) => Column(
      children: [
        ShareFlag(s.code, size: flag),
        SizedBox(height: story ? 26 : 18),
        SizedBox(
          height: story ? 104 : 82,
          child: Align(
            alignment: Alignment.topCenter,
            child: ShareFitText(
              s.name.toUpperCase(),
              matching: [other.name.toUpperCase()],
              maxLines: 2,
              minSize: 24,
              style: AppTypography.headlineLarge.copyWith(
                fontSize: story ? 44 : 36,
                height: 1.12,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
                color: AppColors.onSurface,
              ),
            ),
          ),
        ),
      ],
    );
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: side(data.home, data.away)),
        SizedBox(width: story ? 12 : 16),
        Padding(
          padding: EdgeInsets.only(top: flag / 2 - (story ? 92 : 74)),
          child: Column(
            children: [
              _ScorePlate(data: data, story: story),
              SizedBox(height: story ? 22 : 16),
              ShareCaption(
                status,
                size: story ? 22 : 19,
                color: AppColors.onSurfaceVariant,
              ),
              if (data.penalties) ...[
                SizedBox(height: story ? 14 : 10),
                _PensPill(
                  text: l.recordsOnPenalties(data.homePens!, data.awayPens!),
                  accent: accent,
                  story: story,
                ),
              ],
            ],
          ),
        ),
        SizedBox(width: story ? 12 : 16),
        Expanded(child: side(data.away, data.home)),
      ],
    );
  }
}

/// The two numbers on the brushed plate (or the tournament's own colours).
class _ScorePlate extends StatelessWidget {
  const _ScorePlate({required this.data, required this.story});

  final MatchShareData data;
  final bool story;

  @override
  Widget build(BuildContext context) {
    final theme = data.plateTheme;
    final ink = theme?.scoreText ?? const Color(0xFF14181C);
    final h = story ? 184.0 : 148.0;
    final numberStyle = AppTypography.displayLarge.copyWith(
      fontSize: story ? 150 : 122,
      height: 1,
      letterSpacing: -2,
      fontWeight: FontWeight.w800,
      color: ink,
      fontFeatures: const [FontFeature.tabularFigures()],
    );
    Widget figure(int n) => ConstrainedBox(
      constraints: BoxConstraints(minWidth: story ? 128 : 104),
      child: Text('$n', textAlign: TextAlign.center, style: numberStyle),
    );
    return Container(
      height: h,
      padding: EdgeInsets.symmetric(horizontal: story ? 18 : 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(story ? 26 : 22),
        gradient: theme == null
            ? const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: kShareSilverPlate,
                stops: kShareSilverStops,
              )
            : LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: theme.score,
              ),
        border: Border.all(
          color: theme?.rim ?? const Color(0xFFE9EEF3),
          width: 2,
        ),
        boxShadow: [
          const BoxShadow(
            color: Color(0x8C000000),
            blurRadius: 36,
            offset: Offset(0, 10),
          ),
          BoxShadow(
            color: (theme?.accent ?? AppColors.primary).withValues(alpha: 0.18),
            blurRadius: 60,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          figure(data.home.goals),
          Container(
            width: 3,
            height: h * 0.42,
            margin: const EdgeInsets.symmetric(horizontal: 6),
            color: theme?.divider ?? ink.withValues(alpha: 0.35),
          ),
          figure(data.away.goals),
        ],
      ),
    );
  }
}

class _PensPill extends StatelessWidget {
  const _PensPill({
    required this.text,
    required this.accent,
    required this.story,
  });

  final String text;
  final Color accent;
  final bool story;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(
      horizontal: story ? 22 : 18,
      vertical: story ? 8 : 6,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(100),
      border: Border.all(color: accent.withValues(alpha: 0.7), width: 2),
      color: accent.withValues(alpha: 0.12),
    ),
    child: Text(
      text.toUpperCase(),
      style: AppTypography.labelMedium.copyWith(
        fontSize: story ? 26 : 22,
        height: 1.2,
        letterSpacing: 2,
        fontWeight: FontWeight.w700,
        color: accent,
      ),
    ),
  );
}

/// Each side's scorers under its own flag: a name, then every minute he
/// scored in.
class _Scorers extends StatelessWidget {
  const _Scorers({required this.data, required this.story});

  final MatchShareData data;
  final bool story;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final maxRows = story ? 6 : 4;
    String minute(ShareGoal g) =>
        g.penalty ? '${g.minuteLabel} ${l.matchGoalPenalty}' : g.minuteLabel;
    List<Widget> column({required bool home}) {
      final byScorer = <String, List<ShareGoal>>{};
      for (final g in data.goals.where((g) => g.home == home)) {
        byScorer.putIfAbsent(g.scorer, () => []).add(g);
      }
      final rows = byScorer.entries.toList();
      return [
        for (final e in rows.take(maxRows))
          Padding(
            padding: EdgeInsets.only(bottom: story ? 12 : 8),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: e.key),
                  TextSpan(
                    text: '  ${e.value.map(minute).join(', ')}',
                    style: AppTypography.labelMedium.copyWith(
                      fontSize: story ? 24 : 20,
                      color: AppColors.outline,
                    ),
                  ),
                ],
              ),
              textAlign: home ? TextAlign.right : TextAlign.left,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.titleMedium.copyWith(
                fontSize: story ? 29 : 24,
                height: 1.25,
                color: AppColors.onSurface,
              ),
            ),
          ),
      ];
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: column(home: true),
          ),
        ),
        SizedBox(
          width: story ? 90 : 70,
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Icon(
              Icons.sports_soccer,
              size: story ? 30 : 26,
              color: AppColors.outline,
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: column(home: false),
          ),
        ),
      ],
    );
  }
}

/// The man of the match beside a short stat line.
class _Footer extends StatelessWidget {
  const _Footer({required this.data, required this.story});

  final MatchShareData data;
  final bool story;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final star = data.star;
    final starBlock = star == null
        ? null
        : Row(
            children: [
              ShareFlag(star.code, size: story ? 84 : 68),
              SizedBox(width: story ? 22 : 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.matchPlayerOfTheMatch.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.labelSmall.copyWith(
                        fontSize: story ? 19 : 16,
                        letterSpacing: 2.6,
                        fontWeight: FontWeight.w600,
                        color: AppColors.outline,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      star.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.headlineMedium.copyWith(
                        fontSize: story ? 34 : 29,
                        height: 1.15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: story ? 16 : 12),
              _RatingBadge(rating: star.rating, story: story),
            ],
          );
    final stats = <Widget>[
      if (data.homePossession case final p?)
        _StatBar(
          label: l.tacticsInstrPossession,
          home: p,
          away: 100 - p,
          suffix: '%',
          homeColor: data.home.color,
          awayColor: data.away.color,
          story: story,
        ),
      if ((data.homeShots, data.awayShots) case (final h?, final a?))
        _StatBar(
          label: l.matchStatShots,
          home: h,
          away: a,
          homeColor: data.home.color,
          awayColor: data.away.color,
          story: story,
        ),
    ];
    final statBlock = stats.isEmpty
        ? null
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < stats.length; i++) ...[
                if (i > 0) SizedBox(height: story ? 22 : 14),
                stats[i],
              ],
            ],
          );
    final panel = BoxDecoration(
      borderRadius: BorderRadius.circular(story ? 28 : 22),
      color: const Color(0x8C0C0E10),
      border: Border.all(
        color: AppColors.primary.withValues(alpha: 0.12),
        width: 1.5,
      ),
    );
    final pad = EdgeInsets.symmetric(
      horizontal: story ? 32 : 26,
      vertical: story ? 28 : 20,
    );
    if (story) {
      // A story has the height for the two to stand one over the other.
      return Container(
        padding: pad,
        decoration: panel,
        child: Column(
          children: [
            ?starBlock,
            if (starBlock != null && statBlock != null) ...[
              const SizedBox(height: 26),
              const ShareRule(),
              const SizedBox(height: 26),
            ],
            ?statBlock,
          ],
        ),
      );
    }
    return Container(
      padding: pad,
      decoration: panel,
      child: Row(
        children: [
          if (starBlock != null) Expanded(flex: 11, child: starBlock),
          if (starBlock != null && statBlock != null)
            Container(
              width: 1.5,
              height: 74,
              margin: const EdgeInsets.symmetric(horizontal: 24),
              color: AppColors.primary.withValues(alpha: 0.14),
            ),
          if (statBlock != null) Expanded(flex: 9, child: statBlock),
        ],
      ),
    );
  }
}

class _RatingBadge extends StatelessWidget {
  const _RatingBadge({required this.rating, required this.story});

  final double rating;
  final bool story;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(
      horizontal: story ? 18 : 14,
      vertical: story ? 8 : 6,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(story ? 14 : 12),
      color: AppColors.ratingColor(rating),
    ),
    child: Text(
      rating.toStringAsFixed(1),
      style: AppTypography.labelMedium.copyWith(
        fontSize: story ? 34 : 28,
        height: 1.15,
        fontWeight: FontWeight.w700,
        letterSpacing: 0,
        color: Colors.white,
      ),
    ),
  );
}

/// One stat as two numbers either side of its label, over a bar split in
/// the two nations' colours.
class _StatBar extends StatelessWidget {
  const _StatBar({
    required this.label,
    required this.home,
    required this.away,
    required this.homeColor,
    required this.awayColor,
    required this.story,
    this.suffix = '',
  });

  final String label;
  final int home;
  final int away;
  final Color homeColor;
  final Color awayColor;
  final bool story;
  final String suffix;

  @override
  Widget build(BuildContext context) {
    final num = AppTypography.labelMedium.copyWith(
      fontSize: story ? 28 : 23,
      height: 1.1,
      fontWeight: FontWeight.w700,
      letterSpacing: 0,
      color: AppColors.onSurface,
    );
    final total = home + away;
    final share = total == 0 ? 0.5 : home / total;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text('$home$suffix', style: num),
            Expanded(
              child: Text(
                label.toUpperCase(),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.labelSmall.copyWith(
                  fontSize: story ? 19 : 16,
                  letterSpacing: 2.4,
                  fontWeight: FontWeight.w600,
                  color: AppColors.outline,
                ),
              ),
            ),
            Text('$away$suffix', style: num),
          ],
        ),
        SizedBox(height: story ? 10 : 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: SizedBox(
            height: story ? 8 : 6,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: (share * 1000).round().clamp(1, 999),
                  child: ColoredBox(color: _bar(homeColor)),
                ),
                const SizedBox(width: 4),
                Expanded(
                  flex: ((1 - share) * 1000).round().clamp(1, 999),
                  child: ColoredBox(color: _bar(awayColor)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// A nation's colour, kept off black so its bar always shows.
  static Color _bar(Color c) {
    final hsl = HSLColor.fromColor(c);
    if (hsl.saturation < 0.15) {
      return hsl.lightness < 0.3 ? AppColors.outline : c;
    }
    return hsl.lightness < 0.45 ? hsl.withLightness(0.45).toColor() : c;
  }
}
