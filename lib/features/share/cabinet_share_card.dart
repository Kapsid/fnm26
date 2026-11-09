import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/features/share/share_card_kit.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// A nation on the cabinet card: its FIFA code (for the flag) and its name,
/// already in the manager's language.
typedef ShareNation = ({String code, String name});

/// One title: the year and the nation (its FIFA code) it was won with.
typedef ShareWin = ({int year, String code});

/// One kind of trophy in the cabinet, and every time it was lifted.
@immutable
class ShareTrophy {
  const ShareTrophy({
    required this.label,
    required this.asset,
    required this.wins,
  });

  /// The competition's name, already in the manager's language.
  final String label;

  /// The trophy artwork (see `Trophies.cabinet`).
  final String asset;

  /// Each time it was won, oldest first.
  final List<ShareWin> wins;

  int get count => wins.length;

  /// The years, oldest first.
  List<int> get years => [for (final w in wins) w.year];

  /// The nations it was won with, in the order they first won it.
  List<String> get codes => {for (final w in wins) w.code}.toList();
}

/// Everything the trophy cabinet share card shows: the MANAGER's cabinet,
/// across every nation he has coached.
@immutable
class CabinetShareData {
  const CabinetShareData({
    required this.managerName,
    required this.nations,
    required this.trophies,
  });

  final String managerName;

  /// Every nation he has coached, the current one first.
  final List<ShareNation> nations;

  /// Every trophy won, BIGGEST FIRST (the order of `Trophies.cabinet`): the
  /// first is the card's headline.
  final List<ShareTrophy> trophies;

  int get total => trophies.fold(0, (n, t) => n + t.count);

  /// Whether his titles came with more than one nation: then each trophy
  /// says which, by its flags.
  bool get manyNations => {for (final t in trophies) ...t.codes}.length > 1;
}

/// The trophy cabinet as a poster: the manager and his nations on top, the
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
                  flags: data.manyNations,
                ),
              ),
              if (shelf.isNotEmpty) ...[
                SizedBox(height: story ? 40 : 18),
                _Shelf(
                  trophies: shelf,
                  story: story,
                  flags: data.manyNations,
                ),
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
    final current = data.nations.isEmpty ? null : data.nations.first;
    final caption = AppTypography.labelSmall.copyWith(
      fontSize: story ? 21 : 18,
      letterSpacing: 2.6,
      fontWeight: FontWeight.w600,
      color: AppColors.outline,
    );
    final small = story ? 44.0 : 38.0;
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
            if (current != null) ...[
              ShareFlag(current.code, size: story ? 132 : 104),
              SizedBox(width: story ? 30 : 24),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l.managerTitle.toUpperCase(), style: caption),
                  const SizedBox(height: 6),
                  ShareFitText(
                    data.managerName.toUpperCase(),
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    minSize: 30,
                    style: AppTypography.displayLarge.copyWith(
                      fontSize: story ? 56 : 46,
                      height: 1.05,
                      letterSpacing: 1,
                      fontWeight: FontWeight.w800,
                      color: AppColors.onSurface,
                    ),
                  ),
                  SizedBox(height: story ? 12 : 8),
                  if (data.nations.length == 1)
                    Text(
                      current!.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.titleMedium.copyWith(
                        fontSize: story ? 30 : 26,
                        color: AppColors.onSurfaceVariant,
                      ),
                    )
                  else if (data.nations.length > 1)
                    // Every side he has led, the current one first.
                    SizedBox(
                      height: small,
                      child: Row(
                        children: [
                          for (final n in data.nations.take(8)) ...[
                            ShareFlag(n.code, size: small),
                            const SizedBox(width: 10),
                          ],
                        ],
                      ),
                    ),
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

/// The years a trophy was won: with [flags], each nation's years beside its
/// flag (a manager who won it with more than one); else the years alone.
class _WinsLine extends StatelessWidget {
  const _WinsLine({
    required this.trophy,
    required this.flags,
    required this.style,
    required this.flagSize,
    required this.maxYears,
    this.separator = '  ·  ',
  });

  final ShareTrophy trophy;
  final bool flags;
  final TextStyle style;
  final double flagSize;
  final int maxYears;
  final String separator;

  String _years(List<int> ys, int max) => ys.length > max
      ? '${ys.take(max - 1).join(separator)} +${ys.length - max + 1}'
      : ys.join(separator);

  @override
  Widget build(BuildContext context) {
    if (!flags) {
      return ShareFitText(
        _years(trophy.years, maxYears),
        style: style,
      );
    }
    final codes = trophy.codes.take(3).toList();
    // Two or more nations share the budget of years between them.
    final each = codes.length == 1 ? maxYears : (maxYears / 2).ceil();
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < codes.length; i++) ...[
            if (i > 0) SizedBox(width: flagSize * 0.7),
            ShareFlag(codes[i], size: flagSize),
            SizedBox(width: flagSize * 0.3),
            Text(
              _years([
                for (final w in trophy.wins)
                  if (w.code == codes[i]) w.year,
              ], each),
              style: style,
            ),
          ],
        ],
      ),
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
    required this.flags,
  });

  final ShareTrophy trophy;
  final bool story;

  /// Show the flag of each nation it was won with.
  final bool flags;

  /// Nothing else on the shelf: the headline has the card to itself.
  final bool alone;

  @override
  Widget build(BuildContext context) {
    final nameSize = story ? 48.0 : (alone ? 44.0 : 36.0);
    final yearsSize = story ? 28.0 : 23.0;
    final textBlock =
        (story ? 200.0 : (alone ? 150.0 : 112.0)) + (flags ? 12.0 : 0.0);
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
            _WinsLine(
              trophy: trophy,
              flags: flags,
              maxYears: 6,
              flagSize: story ? 44 : 36,
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
  const _Shelf({
    required this.trophies,
    required this.story,
    required this.flags,
  });

  final List<ShareTrophy> trophies;
  final bool story;
  final bool flags;

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
                      flags: flags,
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
    required this.flags,
  });

  final ShareTrophy trophy;
  final double art;
  final bool story;
  final bool flags;

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
          _WinsLine(
            trophy: trophy,
            flags: flags,
            maxYears: 3,
            separator: ' · ',
            flagSize: story ? 26 : 21,
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
