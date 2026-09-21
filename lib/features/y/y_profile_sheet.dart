import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/services/press/persona.dart';
import 'package:fnm/domain/services/press/y_feed.dart';
import 'package:fnm/features/y/y_post_detail.dart';
import 'package:fnm/features/y/y_screen.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';

/// The one-line description of what sort of account this is.
///
/// EXHAUSTIVE, no default branch: a new [YTrait] with no words behind it would
/// draw a blank line under a name and nobody would notice for a year.
String yTraitLine(AppLocalizations l, YTrait trait) => switch (trait) {
  YTrait.loyalist => l.yTraitLoyalist,
  YTrait.cynic => l.yTraitCynic,
  YTrait.nostalgic => l.yTraitNostalgic,
  YTrait.statshead => l.yTraitStatshead,
  YTrait.hypeman => l.yTraitHypeman,
  YTrait.contrarian => l.yTraitContrarian,
  YTrait.doomer => l.yTraitDoomer,
};

/// Who is behind a handle, and everything they have said this save.
///
/// The feed had a cast with dispositions all along and showed none of it, so
/// eight voices read as one personality wearing different names. This is where
/// a name stops being decoration: the manager who keeps seeing
/// LongSufferingLen under his defeats can open him and find out that he is
/// like that about everything.
///
/// NOTHING HERE IS STORED. The disposition is re-derived from the name (see
/// [YFeed.personaOf]) and the posts are the ones already in the timeline. A
/// stored stance would put today's opinion under a post from 2031, and a
/// profile is exactly the screen where that would be most obvious.
class YProfileSheet extends StatelessWidget {
  const YProfileSheet({required this.persona, required this.all, super.key});

  final YPersona persona;

  /// The whole feed. The account's own posts are filtered out of it, so the
  /// profile can never disagree with the timeline it was opened from.
  final List<YPost> all;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final mine = [
      for (final p in all)
        if (p.handle == persona.handle) p,
    ]..sort((a, b) => b.date.compareTo(a.date));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(l.yTitle, style: AppTypography.titleMedium),
        centerTitle: true,
      ),
      body: ListView(
        // Edge to edge, like the feed: every row below carries its own
        // margins.
        padding: EdgeInsets.zero,
        children: [
          _Header(persona: persona),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.marginMobile,
              AppSpacing.md,
              AppSpacing.marginMobile,
              AppSpacing.xs,
            ),
            child: Text(
              l.yProfilePosts,
              maxLines: 1,
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
          if (mine.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.marginMobile,
                vertical: AppSpacing.sm,
              ),
              child: Text(
                l.yProfileEmpty,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),
          for (var i = 0; i < mine.length; i++)
            YPostTile(
              post: mine[i],
              topRule: i > 0,
              // The post still opens its conversation. What it must NOT do
              // here is offer the account again: tapping the name of the
              // account whose profile you are already reading would push the
              // same page onto itself.
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => YPostDetail(post: mine[i], all: all),
                ),
              ),
            ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}

/// The name, the handle and what sort of person this is.
class _Header extends StatelessWidget {
  const _Header({required this.persona});

  final YPersona persona;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.marginMobile,
        AppSpacing.md,
        AppSpacing.marginMobile,
        AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.16),
                ),
                child: Text(
                  persona.displayName.characters.first,
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // The name and the handle are STACKED, not put on one row
                    // together. Cast names run to eighteen letters and a
                    // player posting under his own name reaches thirty-one,
                    // with the handle being that name again with an @ on it
                    // and no spaces left in it. The two side by side is the
                    // shape that has shipped a width bug six times over.
                    //
                    // Plain [Text] with a [maxLines], not a [WholeText] that
                    // would quietly scale itself down: a guard reading
                    // `didExceedMaxLines` can only ever fail on a real Text.
                    // [withBreakOpportunities] is what pays for that: it
                    // gives a space-free handle somewhere to wrap, so three
                    // lines is enough for the longest name the generators can
                    // make (a Malagasy surname behind a Malagasy forename,
                    // thirty-one letters, two and a bit lines at 360px), and
                    // a fourth would mean something really is too big.
                    Text(
                      withBreakOpportunities(persona.displayName),
                      maxLines: 3,
                      style: AppTypography.titleMedium,
                    ),
                    Text(
                      withBreakOpportunities(persona.handle),
                      maxLines: 3,
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          // The disposition runs the FULL width, under the avatar rather than
          // beside it. Sixty-odd characters in a column the avatar has taken
          // sixty pixels out of wants five lines at 360px; across the whole
          // page it is three and a bit, and four lines is the ceiling the
          // width guard holds the copy to.
          Text(
            yTraitLine(l, persona.trait),
            maxLines: 4,
            style: AppTypography.bodyMedium,
          ),
        ],
      ),
    );
  }
}
