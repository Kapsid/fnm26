import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/features/share/share_card_kit.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// One kind of trophy in the cabinet, and the years it was lifted.
@immutable
class ShareTrophy {
  const ShareTrophy({
    required this.label,
    required this.asset,
    required this.years,
  });

  /// The competition's name, already in the manager's language.
  final String label;

  /// The trophy artwork (see `Trophies.cabinet`).
  final String asset;

  /// The years it was won, oldest first.
  final List<int> years;

  int get count => years.length;
}

/// Everything the trophy cabinet share card shows.
@immutable
class CabinetShareData {
  const CabinetShareData({
    required this.nationName,
    required this.nationCode,
    required this.trophies,
    this.managerName,
  });

  final String nationName;
  final String nationCode;
  final String? managerName;

  /// Every trophy won, BIGGEST FIRST (the order of `Trophies.cabinet`): the
  /// first is the card's headline.
  final List<ShareTrophy> trophies;

  int get total => trophies.fold(0, (n, t) => n + t.count);
}

/// The trophy cabinet as a poster: the nation and its manager on top, the
/// biggest title lit as the headline, the rest on a shelf below, and the
/// brand at the foot.
///
/// Pure: everything comes in through [data]; no providers.
class CabinetShareCard extends StatelessWidget {
  const CabinetShareCard({required this.data, required this.format, super.key});

  final CabinetShareData data;
  final ShareFormat format;

  @override
  Widget build(BuildContext context) {
    final story = format.isStory;
    final shelf = data.trophies.skip(1).toList();
    return ShareCanvas(
      format: format,
      child: ShareBackdrop(
        topGlow: kShareGold,
        child: Padding(
          padding: format.contentInsets,
          child: Column(
            children: [
              _Identity(data: data, story: story),
              SizedBox(height: story ? 40 : 18),
              Expanded(
                child: _Headline(
                  trophy: data.trophies.first,
                  story: story,
                  alone: shelf.isEmpty,
                ),
              ),
              if (shelf.isNotEmpty) ...[
                SizedBox(height: story ? 40 : 18),
                _Shelf(trophies: shelf, story: story),
              ],
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

class _Identity extends StatelessWidget {
  const _Identity({required this.data, required this.story});

  final CabinetShareData data;
  final bool story;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Column(
      children: [
        ShareCaption(
          l.careerTrophyCabinet,
          color: kShareGold,
          size: story ? 26 : 21,
        ),
        SizedBox(height: story ? 30 : 18),
        Row(
          children: [
            ShareFlag(data.nationCode, size: story ? 132 : 104),
            SizedBox(width: story ? 30 : 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShareFitText(
                    data.nationName.toUpperCase(),
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    minSize: 30,
                    style: AppTypography.displayLarge.copyWith(
                      fontSize: story ? 58 : 50,
                      height: 1.05,
                      letterSpacing: 1,
                      fontWeight: FontWeight.w800,
                      color: AppColors.onSurface,
                    ),
                  ),
                  if (data.managerName case final m?) ...[
                    const SizedBox(height: 8),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '${l.managerTitle.toUpperCase()}  ',
                            style: AppTypography.labelSmall.copyWith(
                              fontSize: story ? 21 : 18,
                              letterSpacing: 2.6,
                              fontWeight: FontWeight.w600,
                              color: AppColors.outline,
                            ),
                          ),
                          TextSpan(text: m),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.titleMedium.copyWith(
                        fontSize: story ? 30 : 26,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (data.total > 1) ...[
              SizedBox(width: story ? 24 : 20),
              Column(
                children: [
                  Text(
                    '${data.total}',
                    style: AppTypography.displayLarge.copyWith(
                      fontSize: story ? 84 : 70,
                      height: 1,
                      color: kShareGold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  ShareCaption(l.careerStatTitles, size: story ? 19 : 16),
                ],
              ),
            ],
          ],
        ),
      ],
    );
  }
}

/// The biggest title, lit: its trophy as large as the space allows, its
/// name, how many and when.
class _Headline extends StatelessWidget {
  const _Headline({
    required this.trophy,
    required this.story,
    required this.alone,
  });

  final ShareTrophy trophy;
  final bool story;

  /// Nothing else on the shelf: the headline has the card to itself.
  final bool alone;

  @override
  Widget build(BuildContext context) {
    final nameSize = story ? 48.0 : (alone ? 44.0 : 36.0);
    final yearsSize = story ? 28.0 : 23.0;
    final textBlock = (story ? 200.0 : (alone ? 150.0 : 112.0));
    return LayoutBuilder(
      builder: (context, c) {
        final art = (c.maxHeight - textBlock).clamp(
          80.0,
          story ? 520.0 : 420.0,
        );
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: art * 1.5,
              height: art,
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  // The spotlight behind the trophy.
                  Container(
                    width: art * 1.35,
                    height: art * 1.35,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          kShareGold.withValues(alpha: 0.30),
                          kShareGold.withValues(alpha: 0.08),
                          kShareGold.withValues(alpha: 0),
                        ],
                        stops: const [0, 0.45, 0.72],
                      ),
                    ),
                  ),
                  Image.asset(trophy.asset, height: art, fit: BoxFit.contain),
                  if (trophy.count > 1)
                    Positioned(
                      right: art * 0.12,
                      bottom: art * 0.04,
                      child: _CountBadge(count: trophy.count, size: art * 0.26),
                    ),
                ],
              ),
            ),
            SizedBox(height: story ? 24 : 12),
            ShareFitText(
              trophy.label.toUpperCase(),
              minSize: 24,
              style: AppTypography.displayLarge.copyWith(
                fontSize: nameSize,
                height: 1.1,
                letterSpacing: nameSize * 0.12,
                fontWeight: FontWeight.w800,
                color: AppColors.onSurface,
              ),
            ),
            SizedBox(height: story ? 12 : 6),
            ShareFitText(
              trophy.years.join('  ·  '),
              minSize: 16,
              style: AppTypography.labelMedium.copyWith(
                fontSize: yearsSize,
                height: 1.2,
                letterSpacing: 2,
                fontWeight: FontWeight.w600,
                color: kShareGold,
              ),
            ),
          ],
        );
      },
    );
  }
}

/// "×3" on a gold medal, pinned to a trophy.
class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.count, required this.size});

  final int count;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFFBE7A6), Color(0xFFD4A440), Color(0xFFB88A2A)],
      ),
      border: Border.all(color: const Color(0xFF1C1405), width: size * 0.05),
      boxShadow: [
        BoxShadow(
          color: const Color(0x99000000),
          blurRadius: size * 0.3,
          offset: Offset(0, size * 0.06),
        ),
      ],
    ),
    child: Text(
      '×$count',
      style: AppTypography.displayLarge.copyWith(
        fontSize: size * 0.42,
        height: 1,
        letterSpacing: 0,
        color: const Color(0xFF1C1405),
      ),
    ),
  );
}

/// The other trophies, on a shelf: each with its art, its count, its name
/// and its years.
class _Shelf extends StatelessWidget {
  const _Shelf({required this.trophies, required this.story});

  final List<ShareTrophy> trophies;
  final bool story;

  @override
  Widget build(BuildContext context) {
    final n = trophies.length;
    final cols = story ? (n <= 3 ? n : (n <= 6 ? 3 : 4)) : (n <= 4 ? n : 4);
    final rows = <List<ShareTrophy>>[
      for (var i = 0; i < n; i += cols)
        trophies.sublist(i, (i + cols).clamp(0, n)),
    ];
    final art = story
        ? (cols <= 3 ? 150.0 : 118.0)
        : (rows.length > 1 ? 82.0 : 112.0);
    return LayoutBuilder(
      builder: (context, c) => Column(
        children: [
          const ShareRule(color: kShareGold),
          SizedBox(height: story ? 34 : 18),
          for (var r = 0; r < rows.length; r++) ...[
            if (r > 0) SizedBox(height: story ? 30 : 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final t in rows[r])
                  SizedBox(
                    width: c.maxWidth / cols,
                    child: _ShelfItem(
                      trophy: t,
                      art: art,
                      story: story,
                      labelLines: _labelLines(c.maxWidth / cols - 16),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

extension on _Shelf {
  int _labelLines(double width) {
    final style = _ShelfItem.labelStyleFor(story: story);
    for (final t in trophies) {
      final tp = TextPainter(
        text: TextSpan(text: t.label.toUpperCase(), style: style),
        textDirection: TextDirection.ltr,
        maxLines: 1,
      )..layout(maxWidth: width);
      if (tp.didExceedMaxLines) return 2;
    }
    return 1;
  }
}

class _ShelfItem extends StatelessWidget {
  const _ShelfItem({
    required this.trophy,
    required this.art,
    required this.story,
    required this.labelLines,
  });

  final ShareTrophy trophy;
  final double art;
  final bool story;

  /// How many lines the shelf's longest name takes: every name gets that
  /// much room, so the years beneath line up along the row.
  final int labelLines;

  static TextStyle labelStyleFor({required bool story}) =>
      AppTypography.titleMedium.copyWith(
        fontSize: story ? 21 : 17,
        height: 1.15,
        letterSpacing: 1.2,
        fontWeight: FontWeight.w700,
        color: AppColors.onSurface,
      );

  TextStyle get labelStyle => labelStyleFor(story: story);

  @override
  Widget build(BuildContext context) {
    final years = trophy.years.length > 3
        ? '${trophy.years.take(2).join(' · ')} +${trophy.years.length - 2}'
        : trophy.years.join(' · ');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          SizedBox.square(
            dimension: art,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Image.asset(trophy.asset, height: art, fit: BoxFit.contain),
                if (trophy.count > 1)
                  Positioned(
                    right: art * 0.02,
                    bottom: 0,
                    child: _CountBadge(count: trophy.count, size: art * 0.36),
                  ),
              ],
            ),
          ),
          SizedBox(height: story ? 14 : 8),
          SizedBox(
            height: labelStyle.fontSize! * labelStyle.height! * labelLines,
            child: Center(
              child: ShareFitText(
                trophy.label.toUpperCase(),
                maxLines: 2,
                minSize: 13,
                style: labelStyle,
              ),
            ),
          ),
          SizedBox(height: story ? 6 : 3),
          Text(
            years,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.labelSmall.copyWith(
              fontSize: story ? 19 : 15,
              letterSpacing: 0.5,
              color: AppColors.outline,
            ),
          ),
        ],
      ),
    );
  }
}
