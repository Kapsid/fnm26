import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/services/press/y_feed.dart';
import 'package:fnm/features/y/y_screen.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// One post, and everything else said about the same event.
///
/// A post's key starts with the event it came from, so the replies are simply
/// the other posts that came out of the same match — which is what makes the
/// feed read as a conversation rather than a list of unrelated lines.
class YPostDetail extends StatelessWidget {
  const YPostDetail({required this.post, required this.all, super.key});

  final YPost post;

  /// The whole feed, which the replies are drawn from.
  final List<YPost> all;

  /// The event a post came from — its key without the voice that said it and
  /// the shape they said it in.
  static String eventOf(YPost p) => p.key.split('|').first;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final event = eventOf(post);
    final replies = [
      for (final p in all)
        if (p.key != post.key && eventOf(p) == event) p,
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(l.yTitle, style: AppTypography.titleMedium),
        centerTitle: true,
      ),
      // Edge to edge, like the feed it was opened from: the rows carry their
      // own margins now, so a page padding here would inset the conversation
      // by twice as much as the timeline behind it.
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          YPostTile(post: post),
          if (replies.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.marginMobile,
                AppSpacing.sm,
                AppSpacing.marginMobile,
                AppSpacing.xs,
              ),
              child: Text(
                l.yReplies,
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),
            for (final r in replies) YPostTile(post: r),
          ],
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}
